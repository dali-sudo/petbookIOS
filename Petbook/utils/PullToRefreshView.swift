//
//  PullToRefreshView.swift
//  Petbook
//
//  Created by user233432 on 5/18/23.
//

import SwiftUI

struct PullToRefreshView: View
{
    private static let minRefreshTimeInterval = TimeInterval(0.2)
    private static let triggerHeight = CGFloat(100)
    private static let indicatorHeight = CGFloat(100)
    private static let fullHeight = triggerHeight + indicatorHeight
    
    let backgroundColor: Color
    let foregroundColor: Color
    let isEnabled: Bool
    let onRefresh: () -> Void
    
    @State private var isRefreshIndicatorVisible = false
    @State private var refreshStartTime: Date? = nil
    
    init(bg: Color = .white, fg: Color = .black, isEnabled: Bool = true, onRefresh: @escaping () -> Void)
    {
        self.backgroundColor = bg
        self.foregroundColor = fg
        self.isEnabled = isEnabled
        self.onRefresh = onRefresh
    }
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            LazyVStack(spacing: 0)
            {
                Color.clear
                    .frame(height: Self.triggerHeight)
                    .onAppear
                    {
                        if isEnabled
                        {
                            withAnimation
                            {
                                isRefreshIndicatorVisible = true
                            }
                            refreshStartTime = Date()
                        }
                    }
                    .onDisappear
                    {
                        if isEnabled, isRefreshIndicatorVisible, let diff = refreshStartTime?.distance(to: Date()), diff > Self.minRefreshTimeInterval
                        {
                            onRefresh()
                        }
                        withAnimation
                        {
                            isRefreshIndicatorVisible = false
                        }
                        refreshStartTime = nil
                    }
            }
            .frame(height: Self.triggerHeight)
            
            indicator
                .frame(height: Self.indicatorHeight)
        }
        .background(backgroundColor)
        .ignoresSafeArea(edges: .all)
        .frame(height: Self.fullHeight)
        .padding(.top, -Self.fullHeight)
    }
    
    private var indicator: some View
    {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
            .opacity(isRefreshIndicatorVisible ? 1 : 0)
    }
}

struct PullToRefresh: View {
    
    private enum Constants {
        static let refreshTriggerOffset = CGFloat(-140)
    }
    
    @Binding private var needsRefresh: Bool
    private let coordinateSpaceName: String
    private let onRefresh: () -> Void
    
    init(needsRefresh: Binding<Bool>, coordinateSpaceName: String, onRefresh: @escaping () -> Void) {
        self._needsRefresh = needsRefresh
        self.coordinateSpaceName = coordinateSpaceName
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        HStack(alignment: .center) {
            if needsRefresh {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(height: 60)
            }
        }
        .background(GeometryReader {
            Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self,
                                   value: -$0.frame(in: .named(coordinateSpaceName)).origin.y)
        })
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { offset in
            guard !needsRefresh, offset < Constants.refreshTriggerOffset else { return }
            withAnimation { needsRefresh = true }
            onRefresh()
        }
    }
}


private struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}


private enum Constants {
    static let coordinateSpaceName = "PullToRefreshScrollView"
}

struct PullToRefreshScrollView<Content: View>: View {
    @Binding private var needsRefresh: Bool
    private let onRefresh: () -> Void
    private let content: () -> Content
    
    init(needsRefresh: Binding<Bool>,
         onRefresh: @escaping () -> Void,
         @ViewBuilder content: @escaping () -> Content) {
        self._needsRefresh = needsRefresh
        self.onRefresh = onRefresh
        self.content = content
    }
    
    var body: some View {
        ScrollView {
            PullToRefresh(needsRefresh: $needsRefresh,
                          coordinateSpaceName: Constants.coordinateSpaceName,
                          onRefresh: onRefresh)
            content()
        }
        .coordinateSpace(name: Constants.coordinateSpaceName)
    }
}

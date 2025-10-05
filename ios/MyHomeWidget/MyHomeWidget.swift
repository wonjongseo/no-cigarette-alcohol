//
//  MyHomeWidget.swift
//  MyHomeWidget
//
//  Created by Jongseo Won on 10/5/25.
//

import WidgetKit
import SwiftUI

private let appGroupId = "group.com.wonjongseo.no-cigarette-alcohol"
private let widgetKind = "MyHomeWidget"

struct Provider: TimelineProvider {
    
    fileprivate func parseISO8601(_ s: String) -> Date? {
        // 1) 인터넷 표준 + 밀리초 허용
        let f1 = ISO8601DateFormatter()
        f1.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = f1.date(from: s) { return d }

        // 2) 밀리초가 없는 일반 케이스도 시도
        let f2 = ISO8601DateFormatter()
        f2.formatOptions = [.withInternetDateTime]
        if let d = f2.date(from: s) { return d }

        // 3) 마지막으로 공백/밀리초 제거 후 시도 (예방)
        let trimmed = s.trimmingCharacters(in: .whitespacesAndNewlines)
        if let dot = trimmed.firstIndex(of: ".") {
            let noMs = String(trimmed[..<dot]) + "Z" // 밀리초 제거하고 Z(UTC) 붙이기
            return f2.date(from: noMs)
        }
        return nil
    }
    
    
    func placeholder(in context: Context) -> Entry { Entry(title: "-", subtitle: "-") }
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(Entry(title: "Snapshot", subtitle: "Example"))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let d = UserDefaults(suiteName: appGroupId)
        let iso = d?.string(forKey: "start_date_iso")
        let cig = d?.double(forKey: "cig_daily") ?? 0
        let drink = d?.double(forKey: "drink_daily") ?? 0
        let currency = d?.string(forKey: "currency") ?? "¥"

        var title = "금연·금주"
        var subtitle = "시작값 필요"
        if let iso, let start = parseISO8601(iso) {
            let days = daysSince(start: start)
            let total = Double(days) * (cig + drink)
            title = "누적 \(currency)\(Int(total))"
            subtitle = "\(days)일째"
        }

        let entry = Entry(title: title, subtitle: subtitle)

        // ✅ 다음 자정(로컬)으로 새로고침 예약
//        let next = Calendar.current.nextDate(after: Date(),
//                                             matching: DateComponents(hour:0, minute:0, second:5),
//                                             matchingPolicy: .nextTime) ?? Date().addingTimeInterval(3600)

        let next = Date().addingTimeInterval(60) // 60초 후
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

    private func daysSince(start: Date) -> Int {
        let startDay = Calendar.current.startOfDay(for: start)
        let today = Calendar.current.startOfDay(for: Date())
        return Calendar.current.dateComponents([.day], from: startDay, to: today).day ?? 0
    }
}

struct Entry: TimelineEntry {
    let date: Date = Date()
    let title: String
    let subtitle: String
}

struct MyHomeWidgetEntryView: View {
    var entry: Provider.Entry
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title).font(.headline)
            Text(entry.subtitle).font(.subheadline)
        }
        .padding()
        .ifAvailableiOS17ContainerBackground()
    }
}

private extension View {
    @ViewBuilder func ifAvailableiOS17ContainerBackground() -> some View {
        if #available(iOS 17.0, *) { self.containerBackground(.fill.tertiary, for: .widget) }
        else { self.background(Color(.systemBackground)) }
    }
}


struct MyHomeWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: widgetKind, provider: Provider()) { MyHomeWidgetEntryView(entry: $0) }
            .configurationDisplayName("금연·금주")
            .description("금연·금주 누적 금액/일수")
            .supportedFamilies([.systemSmall, .systemMedium])
    }
}

//
//  MyHomeWidget.swift
//  MyHomeWidget
//
//  Created by Jongseo Won on 10/5/25.
//

import WidgetKit
import SwiftUI

private let appGroupId = "group.com.wonjongseo.no-cigarette-alcohol"
private let widgetKind  = "MyHomeWidget"

// MARK: - Entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let subtitle: String
}

// MARK: - Provider
struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "No Smoking · No Drinking", subtitle: "Loading…")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry(date: Date(), title: "No Smoking · No Drinking", subtitle: "Preview"))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let d = UserDefaults(suiteName: appGroupId)

        // Flutter에서 내려주는 i18n 라벨
        let cigLabel = d?.string(forKey: "cig") ?? "Cigarette"
        let alcLabel = d?.string(forKey: "alc") ?? "Alcohol"
        let dayLabel = d?.string(forKey: "day") ?? "Day"
        let sumLabel = d?.string(forKey: "sum") ?? "Total"

        // Flutter에서 미리 계산해 저장한 값들
        let days      = d?.integer(forKey: "days") ?? 0
        let cigTotal  = d?.double(forKey: "cig_total") ?? 0
        let alcTotal  = d?.double(forKey: "alc_total") ?? 0
        let sumExists = d?.object(forKey: "sum_total") != nil
        let sumTotal  = d?.double(forKey: "sum_total") ?? 0
        let cigCur    = d?.string(forKey: "cig_currency") ?? "₩"
        let alcCur    = d?.string(forKey: "alc_currency") ?? "₩"

        func makeEntry(at t: Date) -> SimpleEntry {
            // 제목: Day N / N일째 등
            let title = (dayLabel == "Day") ? "Day \(days)" : "\(days)\(dayLabel)"

            // 본문 라인
            var lines: [String] = [
                "\(cigLabel): \(Int(cigTotal))\(cigCur)",
                "\(alcLabel): \(Int(alcTotal))\(alcCur)"
            ]
            if sumExists && cigCur == alcCur {
                lines.append("\(sumLabel): \(Int(sumTotal))\(cigCur)")
            }

            // 데이터가 하나도 없을 때의 안내
            if days == 0 && cigTotal == 0 && alcTotal == 0 && !sumExists {
                return SimpleEntry(
                    date: t,
                    title: "No Smoking · No Drinking",
                    subtitle: "Please open the app and enter data"
                )
            }

            return SimpleEntry(date: t, title: title, subtitle: lines.joined(separator: "\n"))
        }

        #if DEBUG
        // 디버그: 1분 뒤 한 번 더 새로고침(값이 바뀌었으면 반영)
        let now = Date()
        let next = now.addingTimeInterval(60)
        completion(Timeline(entries: [makeEntry(at: now), makeEntry(at: next)], policy: .atEnd))
        #else
        // 릴리즈: 1시간 간격으로 새로고침(앱이 저장한 최신값을 읽어옴)
        let entry = makeEntry(at: Date())
        completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600))))
        #endif
    }
}

// MARK: - View
struct MyHomeWidgetEntryView: View {
    var entry: SimpleEntry
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.title)
                .font(.headline)
                .padding(.bottom, 4)

            Text(entry.subtitle)
                .font(.system(size: 14))
                .multilineTextAlignment(.leading)
        }
        .padding()
        .ifAvailableiOS17ContainerBackground()
    }
}

private extension View {
    @ViewBuilder func ifAvailableiOS17ContainerBackground() -> some View {
        if #available(iOS 17.0, *) {
            self.containerBackground(.fill.tertiary, for: .widget)
        } else {
            self.background(Color(.systemBackground))
        }
    }
}

// MARK: - Widget
struct MyHomeWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: widgetKind, provider: Provider()) { entry in
            MyHomeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("No Smoking · No Drinking")
        .description("Total money saved / days since start")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
import SwiftUI
import WidgetKit

struct RimWidgetEntryView: View {
    var entry: Provider.Entry

    var userCpuUsage: Double {
        entry.data?.cpu.last?.userPercentage ?? 0
    }

    var systemCpuUsage: Double {
        entry.data?.cpu.last?.sysPercentage ?? 0
    }

    var totalCpuUsage: Double {
        userCpuUsage + systemCpuUsage
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.userCpuUsage / 100, 1)))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundColor(Color.green)
                    .rotationEffect(Angle(degrees: -90))
                
                Circle()
                    .trim(from: CGFloat(min(self.userCpuUsage / 100, 1)), to: CGFloat(min(self.totalCpuUsage / 100, 1)))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundColor(Color.yellow)
                    .rotationEffect(Angle(degrees: -90))
            }
            .padding(20) // Adjust padding to fit the circle nicely within the widget
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct RimWidget: Widget {
    let kind: String = "widget.rim"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RimWidgetEntryView(entry: entry) // 确保这里使用了正确的视图名
                .containerBackground(.background, for: .widget)
                .widgetURL(URL(string: "main"))
        }
        .configurationDisplayName("CPU Usage")
        .description("Displays user and system CPU usage.")
        .supportedFamilies([.systemSmall, .systemMedium]) // 根据需要更新支持的尺寸
    }
}

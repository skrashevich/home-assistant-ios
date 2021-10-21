import Intents
import Shared
import SwiftUI
import WidgetKit

struct WidgetOpenPage: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: WidgetOpenPageIntent.widgetKind,
            intent: WidgetOpenPageIntent.self,
            provider: WidgetOpenPageProvider(),
            content: {
                WidgetBasicContainerView(
                    emptyViewGenerator: {
                        AnyView(WidgetEmptyView(message: L10n.Widgets.OpenPage.notConfigured))
                    },
                    contents: $0.pages.map { panel in
                        WidgetBasicViewModel(
                            id: panel.identifier!,
                            title: panel.displayString,
                            widgetURL: panel.widgetURL,
                            icon: panel.materialDesignIcon,
                            showsChevron: true,
                            textColor: .white,
                            iconColor: .white,
                            backgroundColor: Color(Constants.darkerTintColor)
                        )
                    }
                )
            }
        )
        .configurationDisplayName(L10n.Widgets.OpenPage.title)
        .description(L10n.Widgets.OpenPage.description)
        .supportedFamilies({
            var supportedFamilies: [WidgetFamily] = [.systemSmall, .systemMedium, .systemLarge]

            if #available(iOS 15, *) {
                supportedFamilies.append(.systemExtraLarge)
            }

            return supportedFamilies
        }())
        .onBackgroundURLSessionEvents(matching: nil) { identifier, completion in
            Current.webhooks.handleBackground(for: identifier, completionHandler: completion)
        }
    }
}

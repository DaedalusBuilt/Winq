import SwiftUI

struct ChancesView: View {
    @Environment(\.dismiss) var dismiss
    @State private var tab = 0   // 0 = chatbot, 1 = form
    @State private var messages: [ChatMessage] = [
        ChatMessage(isBot: true, text: "Tell me about the moment."),
        ChatMessage(isBot: false, text: "L train, around 5pm last Thursday. He was reading a Murakami."),
        ChatMessage(isBot: true, text: "Got it. Roughly where did you get on?"),
        ChatMessage(isBot: false, text: "Bedford Ave."),
        ChatMessage(isBot: true, text: "And him — describe him in one sentence."),
    ]
    @State private var inputText = ""
    @FocusState private var inputFocused: Bool

    // Form fields
    @State private var when = "Thursday · ~5:00 PM"
    @State private var where_ = "L train · Bedford Ave"
    @State private var theyLookLike = "tall · dark coat · reading Murakami"
    @State private var iWas = "wearing yellow scarf · short hair"
    @State private var story = "We made eye contact 3 times. He smiled."
    @State private var filed = false

    var body: some View {
        NavigationStack {
            ZStack {
                WK.paper.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("What are\nthe chances?")
                            .font(WK.emph(26))
                            .foregroundColor(WK.ink)
                            .lineSpacing(2)
                        Text("Tell us about a missed moment. We'll see if they remember it too.")
                            .font(WK.hand(13))
                            .foregroundColor(WK.ink2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 12)

                    WavyDivider().padding(.horizontal, 20)

                    // Tab toggle
                    HStack(spacing: 10) {
                        Button("💬 Chat") { tab = 0 }
                            .buttonStyle(WKButtonStyle(
                                fill: tab == 0 ? WK.ink : .clear,
                                stroke: WK.ink,
                                foreground: tab == 0 ? WK.paper : WK.ink,
                                size: .sm
                            ))
                        Button("📋 Form") { tab = 1 }
                            .buttonStyle(WKButtonStyle(
                                fill: tab == 1 ? WK.ink : .clear,
                                stroke: WK.ink,
                                foreground: tab == 1 ? WK.paper : WK.ink,
                                size: .sm
                            ))
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                    if tab == 0 {
                        chatView
                    } else {
                        formView
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                        .font(WK.hand(15))
                        .foregroundColor(WK.accent)
                }
            }
        }
    }

    // MARK: - Chat view
    var chatView: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(messages) { msg in
                            HStack {
                                if msg.isBot { Spacer(minLength: 40) }
                                Text(msg.text)
                                    .font(WK.hand(14))
                                    .foregroundColor(msg.isBot ? WK.ink : WK.paper)
                                    .padding(.horizontal, 12).padding(.vertical, 8)
                                    .background(msg.isBot ? WK.paperDim : WK.accent)
                                    .clipShape(
                                        UnevenRoundedRectangle(
                                            topLeadingRadius: 14,
                                            bottomLeadingRadius: msg.isBot ? 4 : 14,
                                            bottomTrailingRadius: msg.isBot ? 14 : 4,
                                            topTrailingRadius: 14
                                        )
                                    )
                                    .overlay(
                                        UnevenRoundedRectangle(
                                            topLeadingRadius: 14,
                                            bottomLeadingRadius: msg.isBot ? 4 : 14,
                                            bottomTrailingRadius: msg.isBot ? 14 : 4,
                                            topTrailingRadius: 14
                                        )
                                        .stroke(WK.ink, lineWidth: 1.5)
                                    )
                                    .id(msg.id)
                                if !msg.isBot { Spacer(minLength: 40) }
                            }
                        }
                    }
                    .padding(16)
                }
                .onChange(of: messages.count) { _ in
                    withAnimation { proxy.scrollTo(messages.last?.id) }
                }
            }

            // Input bar
            HStack(spacing: 10) {
                TextField("type a memory…", text: $inputText)
                    .font(WK.hand(14))
                    .focused($inputFocused)

                Button("send →") {
                    guard !inputText.isEmpty else { return }
                    let userMsg = ChatMessage(isBot: false, text: inputText)
                    messages.append(userMsg)
                    inputText = ""

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        let botResponses = [
                            "Got it. Anything else stand out?",
                            "And what were you wearing?",
                            "Perfect. We'll watch for a match.",
                        ]
                        let reply = botResponses.randomElement() ?? "Tell me more."
                        messages.append(ChatMessage(isBot: true, text: reply))
                    }
                }
                .font(WK.hand(13))
                .foregroundColor(WK.accent)
            }
            .padding(12)
            .wkBox(fill: WK.paperDim, radius: 20)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }

    // MARK: - Form view
    var formView: some View {
        ScrollView {
            VStack(spacing: 10) {
                formField("WHEN", binding: $when)
                formField("WHERE", binding: $where_)
                formField("THEY LOOKED LIKE", binding: $theyLookLike)
                formField("I WAS", binding: $iWas)
                formField("STORY", binding: $story)

                // Match hint
                HStack(alignment: .top, spacing: 8) {
                    Text("💡")
                    Text("2 stories nearby match. If they file too — we'll connect you.")
                        .font(WK.hand(13))
                        .foregroundColor(WK.ink)
                }
                .padding(12)
                .wkBox(fill: WK.accentSoft, radius: 10)

                if filed {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(WK.accent)
                        Text("Filed. We're watching.")
                            .font(WK.hand(15))
                            .foregroundColor(WK.ink)
                    }
                    .padding(12)
                    .wkBox(fill: WK.accentSoft, radius: 10)
                } else {
                    Button("File this moment") {
                        WK.hapticSuccess()
                        withAnimation { filed = true }
                    }
                    .buttonStyle(WKButtonStyle(fill: WK.accent, stroke: WK.accent,
                                               foreground: WK.paper, fullWidth: true))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 40)
        }
    }

    func formField(_ key: String, binding: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(key)
                .font(WK.mono(9))
                .foregroundColor(WK.ink3)
            TextField("", text: binding)
                .font(WK.hand(14))
                .foregroundColor(WK.ink)
        }
        .padding(12)
        .wkBox(radius: 10)
    }
}

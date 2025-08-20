# TapSnap iOS (SwiftUI)

**What’s here:** UI screens + flow (Amount → Tap → Processing → Result), transactions list/detail, settings, mock payment.

**Build later on Mac (Xcode):**
1. Open Xcode → File → New → Project → iOS → App → Name: TapSnap (SwiftUI).
2. Add all files from this repo's \swift\ folder into the project.
3. Set \TapSnapApp.swift\ as the @main entry if Xcode created another one.
4. Run on an iPhone. (NFC Tap to Pay requires a physical iPhone; simulator has no NFC.)
5. Add Adyen via Swift Package Manager, then replace the mock service with the Adyen calls.


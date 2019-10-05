// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Add a new custom answer please.
  internal static let addCustomAnswer = L10n.tr("Localizable", "addCustomAnswer")
  /// Answer should be at least one character or more. Try again, please.
  internal static let answerLength = L10n.tr("Localizable", "answerLength")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "cancel")
  /// AnswerTableViewCell
  internal static let identifier = L10n.tr("Localizable", "identifier")
  /// New answer
  internal static let newAnswer = L10n.tr("Localizable", "newAnswer")
  /// AnswerTableViewCell
  internal static let nibName = L10n.tr("Localizable", "nibName")
  /// Ok
  internal static let ok = L10n.tr("Localizable", "ok")
  /// Save
  internal static let save = L10n.tr("Localizable", "save")
  /// Settings
  internal static let settings = L10n.tr("Localizable", "settings")
  /// Shake Me
  internal static let shakeMe = L10n.tr("Localizable", "shakeMe")
  /// Why are you shaking me?
  internal static let shakingMe = L10n.tr("Localizable", "shakingMe")
  /// Add please custom answers or turn on the internet.
  internal static let turnOnInternet = L10n.tr("Localizable", "turnOnInternet")
  /// Warning
  internal static let warning = L10n.tr("Localizable", "warning")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

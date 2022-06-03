import Foundation

struct Life {
    static let totalWeeksInAYear = 52

    var age: Int
    var weekOfYear: Int
    var lifeExpectancy: Int

    init?(birthday: Date, lifeExpectancy: Int) {
        let ageComponents = Calendar.current.dateComponents(
            [.year, .weekOfYear],
            from: birthday,
            to: Date.now
        )

        guard let age = ageComponents.year,
              let weekOfYear = ageComponents.weekOfYear
        else {
            return nil
        }

        self.age = age
        self.weekOfYear = weekOfYear
        self.lifeExpectancy = lifeExpectancy
    }

    var progress: Double {
        let realAge = Double(age) + Double(weekOfYear) /
            Double(Life.totalWeeksInAYear)
        let progress = realAge /
            Double(lifeExpectancy)

        return progress
    }

    var formattedProgress: String {
        let formattedProgress = String(format: "%.1f", progress * 100)

        return formattedProgress
    }

    var currentYearProgress: Double {
        return Double(weekOfYear) / Double(Life.totalWeeksInAYear)
    }

    var remainingWeeks: Int {
        return Int((1 - progress) *
            Double(Life.totalWeeksInAYear * lifeExpectancy))
    }

    static var example: Life {
        // This is meant to be used only in previews
        // So I think it's okay to force unwrap here
        let birthday = Calendar.current.date(from: DateComponents(year: 1999, month: 9, day: 9))!
        let life = Life(
            birthday: birthday,
            lifeExpectancy: 72
        )!

        return life
    }
}
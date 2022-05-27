import SwiftUI

struct ContentView: View {
    @State private var showingSettings = false
    @AppStorage("lifeExpectancy") private var lifeExpectancy = 72
    @AppStorage("birthday") private var birthday = Date.now

    var body: some View {
        NavigationView {
            if let lifeProgress = LifeProgress(birthday: birthday, lifeExpectancy: lifeExpectancy) {
                LifeCalendarView(progress: lifeProgress)
                    .padding()
                    .navigationTitle("Life Progress: \(lifeProgress.formattedProgress)%")
                    .navigationBarItems(trailing:
                        Button(action: {
                            showingSettings.toggle()
                        }) {
                            Image(systemName: "gearshape").imageScale(.large)
                        })
                    .sheet(isPresented: $showingSettings) {
                        Settings()
                    }
            }
        }
    }
}

struct LifeCalendarView: View {
    let progress: LifeProgress

    var body: some View {
        Canvas { context, size in
            let cellSize = size.width / CGFloat(LifeProgress.totalWeeksInAYear)
            let cellPadding = cellSize / 8

            for rowIndex in 0 ..< progress.lifeExpectancy {
                for colIndex in 0 ..< LifeProgress.totalWeeksInAYear {
                    let cellPath =
                        Path(CGRect(
                            x: CGFloat(colIndex) * cellSize + cellPadding,
                            y: CGFloat(rowIndex) * cellSize + cellPadding,
                            width: cellSize - cellPadding * 2,
                            height: cellSize - cellPadding * 2
                        ))

                    if rowIndex < progress.age || rowIndex == progress
                        .age && colIndex <=
                        progress.weekOfYear
                    {
                        context.fill(cellPath, with: .color(.gray))
                    } else {
                        context.stroke(
                            cellPath,
                            with: .color(.gray),
                            lineWidth: cellSize / 8
                        )
                    }
                }
            }
        }
    }
}

struct LifeProgress {
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

    var formattedProgress: String {
        let realAge = Double(age) + Double(weekOfYear) /
            Double(LifeProgress.totalWeeksInAYear)
        let progress = realAge /
            Double(lifeExpectancy) * 100
        let formattedProgress = String(format: "%.1f", progress)

        return formattedProgress
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

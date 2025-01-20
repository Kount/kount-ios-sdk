//
//  MotionActivityLibrary.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 17-06-24.
//

import CoreMotion

final class MotionActivityLibrary: Library {
    private let motionActivityManager = CMMotionActivityManager()
    private weak var observer: LibraryDataObserver?

    var type: LibraryType { return .motionActivity }
    var parameters: [LibraryParameter] = [
        LibraryParameter(name: "Current activity", requiresLiveUpdates: true, value: "...")
    ]

    init(observer: LibraryDataObserver) {
        self.observer = observer
    }

    func start() {
        guard CMMotionActivityManager.isActivityAvailable() else { return }
        motionActivityManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let self = self, let activity = activity else { return }
            self.updateActivityState(activity)
        }
    }

    func stop() {
        motionActivityManager.stopActivityUpdates()
    }

    private func updateActivityState(_ activity: CMMotionActivity) {
        let state = getActivityState(activity: activity)
        updateParameter("Current activity", with: state)
    }

    private func getActivityState(activity: CMMotionActivity) -> String {
        if activity.walking {
            return ActivityState.walking.rawValue
        } else if activity.running {
            return ActivityState.running.rawValue
        } else if activity.automotive {
            return ActivityState.automotive.rawValue
        } else if activity.cycling {
            return ActivityState.cycling.rawValue
        } else if activity.stationary {
            return ActivityState.stationary.rawValue
        } else {
            return ActivityState.unknown.rawValue
        }
    }

    private func updateParameter(_ name: String, with value: String) {
        if let index = parameters.firstIndex(where: { $0.name == name }) {
            parameters[index].value = value
            observer?.didUpdateLibraryData(fetchLibraryData(), for: type)
        }
    }

    private func fetchLibraryData() -> [String: String] {
        var data: [String: String] = [:]
        parameters.forEach { parameter in
            data[parameter.name] = parameter.value
        }
        return data
    }
}

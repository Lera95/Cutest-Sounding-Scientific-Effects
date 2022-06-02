import Foundation

class CutestTimer {
    private var timer: Timer?
    var onFire: (() -> Void)?

    @objc
       fileprivate func handleTimerEvent() {
           onFire?()
       }

    func start(withTimeInterval timeInterval: TimeInterval,
               repeats: Bool = false,
               onFire: @escaping () -> Void) {
        self.timer?.invalidate()

        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(handleTimerEvent),
                                     userInfo: nil, repeats: repeats)
        self.onFire = onFire
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        onFire = nil
    }
}

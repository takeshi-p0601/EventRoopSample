import Foundation

final class EventLoop {
    
    private let microsecondsInSecond: UInt32 = 1_000_000
    private let iterationsPerSecond: UInt32
    private let block: (inout Bool) -> Void
    private var isRunning = false
    
    init(_ iterPerSec: UInt32 = 10, _ block: @escaping (inout Bool) -> Void) {
        self.iterationsPerSecond = iterPerSec
        self.block = block
    }
    
    func run() {
        isRunning = true
        while isRunning {
            usleep(microsecondsInSecond/iterationsPerSecond)
            block(&isRunning)
        }
    }
    
    func stop() {
        isRunning = false
    }
}

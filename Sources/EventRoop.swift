import Foundation

final class EventLoop {
    
    private let microsecondsInSecond: UInt32 = 1_000_000 // 1秒くらい
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
            // スリープさせる
            // 1秒(microsecondsInSecond)/10回(iterationsPerSecond)とすると、1秒を10で割った速さ分sleepするということ
            usleep(microsecondsInSecond/iterationsPerSecond)
            // スリープ解除後、closureを呼ぶ
            block(&isRunning)
        }
    }
    
    func stop() {
        isRunning = false
    }
}

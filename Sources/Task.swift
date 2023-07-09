import Foundation

struct Task {
    var iterations: UInt32
    var param: Int
    var task: (Int) -> Void
    private let iterationsPerSecond: UInt32 = 10
    
    init(time: UInt32, param: Int, task: @escaping (Int) -> Void) {
        self.iterations = time * iterationsPerSecond
        self.param = param
        self.task = task
    }
}

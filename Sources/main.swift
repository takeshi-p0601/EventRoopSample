import Foundation

func heartbeat(_ date: inout Date, _ interval: Int = 5) {
    let currentDate = Date()
    if abs(Int(date.timeIntervalSince(currentDate))) >= interval {
        print("Date: \(currentDate.description), Thread: \(Thread.current)")
        date = currentDate
    }
}

let inputQueue = Queue<String>()

let inputThread = Thread {
    while true {
        if let val = readLine() {
            inputQueue.enqueue(val)
        }
    }
}

inputThread.qualityOfService = .userInteractive
inputThread.start()

var heartBeatDate = Date()

let mainEventLoop = EventLoop { running in
    heartbeat(&heartBeatDate)
    
    if let val = inputQueue.dequeue() {
        print("Your input is: \(val)")
        if val == "exit" {
            running = false
        }
    }
}
mainEventLoop.run()

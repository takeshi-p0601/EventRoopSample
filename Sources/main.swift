import Foundation

func heartbeat(_ date: inout Date, _ interval: Int = 5) {
    let currentDate = Date()
    if abs(Int(date.timeIntervalSince(currentDate))) >= interval {
        print("Date: \(currentDate.description), Thread: \(Thread.current)")
        date = currentDate
    }
}

let inputQueue = Queue<String>()

// イベント待ちのスレッド
// mainスレッドでイベントを待つ場合、mainスレッドを占有してしまうことになるので、別途スレッドを作成する必要がある
let inputThread = Thread {
    while true {
        // イベントを待っている
        if let val = readLine() {
            // 入力されたらvalueをQueueに追加
            inputQueue.enqueue(val)
        }
    }
}
inputThread.qualityOfService = .userInteractive
inputThread.start()


func sumFromOneTo(n: Int) {
    print("Sum from 1 to \(n) = \((n * (n + 1))/2)")
}

let factorialOf: (Int) -> Void = {n in
    print("Factorial of \(n) = \(Array(1...n).reduce(1, *))")
}

var scheduledTasks = [Task]()
scheduledTasks.append(Task(time: 5, param: 5, task: sumFromOneTo))
scheduledTasks.append(Task(time: 3, param: 5, task: factorialOf))
scheduledTasks.append(Task(time: 12, param: 16, task: {num in print(sqrt(Double(num)))}))

var heartBeatDate = Date()

let mainEventLoop = EventLoop { running in
    /*
     ⭐️RunLoopのsleep(秒)経ったあと呼ばれる。デフォルトでは0.1秒(10分の1秒)⭐️
     */
    
    print("mainEventLoop closure called")
    // 内部的に5秒後にハートビートが打たれる
    heartbeat(&heartBeatDate)
    
    // 入力されたQueueに値が入っているか確認
    // inputQueueへの値追加は、mainスレッドとは別のスレッド経由して呼ばれる。
    // libsystem_kernel.dylib`mach_msg2_trap + 8, name = 'com.apple.uikit.eventfetch-thread' みたいな感じでiOSアプリを起動してボタンタップすると、タッチ用?のスレッドがある
    if let val = inputQueue.dequeue() {
        print("Your input is: \(val)")
        if val == "exit" {
            running = false
        }
    }
    
    if !scheduledTasks.isEmpty {
        var i = 0
        while i < scheduledTasks.count {
            scheduledTasks[i].iterations -= 1
            if scheduledTasks[i].iterations == .zero {
                let scheduledTask = scheduledTasks.remove(at: i)
                scheduledTask.task(scheduledTask.param)
                continue
            }
            i += 1
        }
    }
}
mainEventLoop.run()

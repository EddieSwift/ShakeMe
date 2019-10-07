import UIKit

// MARK: - Task 1: Deadlock with two queues

let serialQueueOne = DispatchQueue(label: "com.gcd.serialQueueOne")
let serialQueueTwo = DispatchQueue(label: "com.gcd.serialQueueTwo")

serialQueueOne.async {
    print("Work - 1")
    serialQueueTwo.sync {
        serialQueueOne.sync {
            print("Work - 2")
        }
        print("Work - 3")
    }
    print("Work - 4")
}

// MARK: - Task 2: Cancellation of DispatchWorkItem

let backgroundQueue = DispatchQueue.global(qos: .background)

var workItem: DispatchWorkItem!

print("Start working")
workItem = DispatchWorkItem {
    while true {
        if workItem.isCancelled {
            print("Work Canceled")
            break
        }
        print("0")
    }
    workItem = nil
}

backgroundQueue.async(execute: workItem)

backgroundQueue.asyncAfter(deadline: .now() + 2) {
    workItem?.cancel()
}

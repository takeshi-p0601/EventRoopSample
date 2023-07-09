final class Queue<T> {
    
    private final class Node<T> {
        let val: T
        var next: Node?
        
        init(_ val: T) {
            self.val = val
        }
    }
    
    private var head: Node<T>?
    private var tail: Node<T>?
    
    var isEmpty: Bool {
        return head == nil
    }
    
    func enqueue(_ val: T) {
        let node = Node(val)
        if head == nil {
            head = node
            tail = node
        } else {
            tail?.next = node
            tail = tail?.next
        }
    }
    
    func dequeue() -> T? {
        if isEmpty {
            return nil
        }
        
        let val = head!.val
        head = head?.next
        if head == nil {
            tail = nil
        }
        
        return val
    }
}

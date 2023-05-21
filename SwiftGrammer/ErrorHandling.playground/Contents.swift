/// 2023.05.17

// 에러가 발생할 수 있는 함수, 메서드, 또는 초기화 구문을 나타내기 위해 함수의 선언 중 파라미터 뒤에 throws 키워드를 작성
//func canThrowErrors() throws -> String
//
//func cannotThrowErrors() -> String



struct Item {
    var price: Int
    var count: Int
}


enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

// VendingMachine 클래스는 요청된 항목이 불가능 하거나 품절이거나 현재 입금액을 초과하는 비용이 있는 경우 적절한 VendingMachineError 를 발생하는 vend(itemNamed:) 메서드
class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0

    func vend(itemNamed name: String) throws {
        
        // invertory 이름이 다를 경우 error 처리
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }

        // 상품 개수가 0보다 작을 경우 error 처리
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }

        // 상품 가격이 가진 돈보다 클 경우 error 처리
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }

        coinsDeposited -= item.price

        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem

        print("Dispensing \(name)")
    }
}


// buyFavoriteSnack(person:vendingMachine:) 은 던지기 함수이며 vend(itemNamed:) 메서드에서 발생한 에러는 buyFavoriteSnack(person:vendingMachine:) 함수가 호출된 지점까지 전파될 것
// buyFavoriteSnack(person:vendingMachine:) 함수는 주어진 사람의 좋아하는 스낵을 검색하고 vend(itemNamed:) 메서드를 호출하여 그 제품을 구입 vend(itemNamed:) 메서드는 에러를 발생할 수 있으므로 try 키워드를 앞에 두어 호출
let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]

// 던지기 초기화 구문은 던지기 함수와 같은 방법으로 에러를 전파
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
}

struct PurchasedSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}

// do-catch 구문의 일반적인 형태
// 처리할 수 있는 에러가 무엇인지 나타내기 위해 catch 뒤에 패턴을 작성

var vendingMachine = VendingMachine()

vendingMachine.coinsDeposited = 8

do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("Unexpected error: \(error).")
}



// 모르는 것 복습
// Switch case
let result: Result<Int, Error> = .success(42)

switch result {
case .success(let value):
    print("Success with value: \(value)")
case .failure(let error):
    print("Failure with error: \(error)")
}

// Enum case
enum Result<Value, Error> {
    case success(Value)
    case failure(Error)
}


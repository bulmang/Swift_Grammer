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
/*do {
 try <#expression#>
 <#statements#>
} catch <#pattern 1#> {
 <#statements#>
} catch <#pattern 2#> where <#condition#> {
 <#statements#>
} catch <#pattern 3#>, <#pattern 4#> where <#condition#> {
 <#statements#>
} catch {
 <#statements#>
}
 */

// 처리할 수 있는 에러가 무엇인지 나타내기 위해 catch 뒤에 패턴을 작성
// buyFavoriteSnack(person:vendingMachine:) 함수는 에러를 발생할 수 있으므로 try 표현식으로 호출
// 에러가 발생하면 실행이 즉시 catch 절로 전송되어 전파가 계속 될 것인지 여부를 결정
// 패턴이 일치하지 않으면 에러는 마지막 catch 절에 의해 포착되고 지역 error 상수에 바인딩
// 에러가 발생하지 않으면 do 구문에 나머지 구문이 실행

// catch절은 do절에서 발생할 수 있는 모든 에러를 처리할 필요는 없음
//

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

// nourish(with:) 함수에서 vend(itemNamed:) 가 VendingMachineError 열거형에 케이스 중 하나의 에러를 발생하면 nourish(with:) 는 메세지를 출력하여 에러를 처리
func nourish(with item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch is VendingMachineError {
        print("Couldn't buy that from the vending machine.")
    }
}

do {
    try nourish(with: "Beet-Flavored Chips")
} catch {
    print("Unexpected non-vending-machine-related error: \(error)")
}
// Prints "Couldn't buy that from the vending machine."

// 연관된 에러를 포착하기 위한 다른 방법은 콤마로 구분하여 catch 다음에 리스트 형식으로 작성하는 것
// 리스트화 된 3가지 에러 중 어떤 에러가 발생하면 이 catch 절은 메세지를 출력하여 처리
func eat(item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch VendingMachineError.invalidSelection, VendingMachineError.insufficientFunds, VendingMachineError.outOfStock {
        print("Invalid selection, out of stock, or not enough money.")
    }
}
// 에러를 옵셔널값으로 변화하여 처리하기위해 try? 사용
func someThrowingFunction() throws -> Int {
    return 2
}

let x = try? someThrowingFunction()

let y: Int?
do {
    y = try someThrowingFunction()
} catch {
    y = nil
}
// 여러 접근방식을 사용하여 데이터를 가져오거나 모든 접근방식ㅇ ㅣ실패하면 nil 반환
func fetchData() -> Data? {
    if let data = try? fetchDataFromDisk() { return data }
    if let data = try? fetchDataFromServer() { return data }
    return nil
}

// 주어진 경로의 이미지를 로드하거나 이미지를 로드할 수 없을 때는 에러를 발생하는 loadImage(atPath:) 함수를 사용
// 이미지는 이미지는 애플리케이션과 함께 제공되고 런타임에 에러가 발생하지 않으므로 에러 전파를 비활성화 하는 것이 적절
let photo = try! loadImage(atPath: "./Resources/John Appleseed.jpg")

// defer 구문
// processFile() 함수가 종료될 때까지 실행되지 않으며, 이를 통해 파일 핸들을 안전하게 닫을 수 있음
func processFile() throws {
    let file = openFile()
    defer {
        closeFile(file)
    }
    
    // 파일을 처리하는 코드
    // 에러가 발생할 수 있는 작업
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


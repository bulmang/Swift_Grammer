
/*
 class Bulmang {
     var age = 24
     var description: String {
         return "His age is \(age)"
     }
 }

 let bulmang = Bulmang()
 print(bulmang.description)

 class RealAge: Bulmang{
     override init() {
         super.init()
         age = 25
     }
 }

 let realAge = RealAge()
 print(realAge.description)

 class Job: Bulmang{
     var job: String
     init(job: String) {
         self.job = job
         // super..init()은 암시적으로 호출됨
     }
     override var description: String {
         return "\(super.description) and he is \(job)"
     }
 }

 let job = Job(job: "Apple Developer Academy Student")
 print("\(job.description)")
 */




/*
 class Academy {
     var name: String

     init(name: String) {
         self.name = name
     }
     convenience init() {
         self.init(name:"[Unnamed]")
     }
 }

 let academy = Academy(name: "AppleDeveloper")
 let pohang = Academy()

 class ADAP: Academy {
     var member: Int
     init(name: String,member: Int) {
         self.member = member
         super.init(name: name)
     }
     override convenience init(name: String){
             self.init(name: name, member: 5)
         }
 }

 let oneMysteryItem = ADAP()
 let name = ADAP(name: "As Deep As Possible")
 let members = ADAP(name: "Eggs", member: 6)
 */

/// 2023.05.17 옵셔널 체이닝 (Option Chaining)
// 옵셔널 체이닝이 강제 언래핑과 어떻게 다른지 보여주고 성공 여부를 확인
// Residence 인스턴스는 기본값이 1 인 numberOfRooms 라는 Int 프로퍼티를 가지고 있음. ADAP 인스턴스는 Residence? 타입의 옵셔널 residence 프로퍼티를 가지고 있음
// 새로운 ADAP 인스턴스를 생성하면 residence 프로퍼티는 옵셔널 규칙에 따라 nil 로 초기화
class ADAP {
    var residence: Residence?
}

class Residence {
    var numberOfRooms = 1
}

// bulmang 은 nil 의 residence 프로퍼티 값을 가짐
let bulmang = ADAP()

// 값에 강제 언래핑을 하기 위해 residence 뒤에 느낌표를 배치하여 사람의 residence 에 numberOfRooms 프로퍼티를 접근하면 residence 값이 없기 때문에 런타임 에러가 발생
// let roomCount = bulmang.residence!.numberOfRooms

// 옵셔널 체이닝은 numberOfRooms 의 값에 접근하기 위한 대안으로 제공
// Swift가 옵셔널 residence 프로퍼티를 "체인"하고 residence 가 존재하면 numberOfRooms 값을 조회
if let roomCount = bulmang.residence?.numberOfRooms {
    print("Bulmang's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}

// nil 값을 갖지 않기 위해 bulmang.residence에 Residene 인스턴스를 할당할 수 있음.
// bulmang.residence 는 nil 이 아닌 실제 Residence 인스턴스를 포함
bulmang.residence = Residence()

if let roomCount = bulmang.residence?.numberOfRooms {
    print("Bulmang's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}



// 여러 레벨 옵셔널 체이닝의 예를 포함하여 몇몇의 후속 예제에서 사용할 4개의 모델 클래스를 정의

class Ada {
    var residence1: Residence1?
}

class Residence1 {
    var rooms: [Room] = []
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i:Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The numger of rooms is \(String(describing: printNumberOfRooms))")
    }
    // 옵셔널 프로퍼티
    var address: Address?
}

class Room {
    let name: String
    // 방 이름을 초기화 지정 초기화 구문
    init(name: String) { self.name = name }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if let buildingNumber = buildingNumber, let street = street {
            return "\(buildingNumber) \(street)"
        } else if buildingName != nil {
            return buildingName
        } else {
            return nil
        }
    }
}


let malty = Ada()
if let roomCount = malty.residence1?.numberOfRooms {
    print("Malty's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}

// 옵셔널 체이닝을 통해 프로퍼티의 값을 설정
let someAddress = Address()
someAddress.buildingNumber = "29"
someAddress.street = "포항시 지곡로 철길"
// malty.residence?.address = someAddress 오류 발생 (이 할당은 = 연산자의 우항의 코드는 평가되지 않으므로 옵셔널 체이닝의 일부입니다. 이전 예제에서 상수에 접근하는 것은 어떠한 영향도 없기 때문에 someAddress 가 평가되지 않는다는 것을 쉽게 파악할 수 없음)

func createAddress() -> Address {
    print("Function was called.")

    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Road"

    return someAddress
}
malty.residence1?.address = createAddress()

// Void 의 암시적 반환 타입을 가지고 있습니다. 이것은 () 의 값 또는 빈 튜플을 반환한다는 의
//func printNumberOfRooms() {
//    print("The number of rooms is \(numberOfRooms)")
//}

if malty.residence1?.printNumberOfRooms() != nil {
    print("It was possible to print the number of rooms.")
} else {
    print("It was not possible to print the number of rooms.")
}

// Residence 클래스에 정의된 서브 스크립트를 사용하여 john.residence 프로퍼티에 rooms 배열의 첫번째 방 이름을 조회
// 현재 malty.residence는 nil

if let firstRoomName = malty.residence1?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
}

// residence 가 현재 nil 이므로 서브 스크립트 설정은 실패
malty.residence1?[0] = Room(name: "Bathroom")

// malty.residence 에 실제 Residence 인스턴스를 생성하고 할당하면 옵셔널 체이닝으로 Residence 서브 스크립트를 사용하여 rooms 배열의 항목을 접근
let maltyHouse = Residence1()
maltyHouse.rooms.append(Room(name: "Living Room"))
maltyHouse.rooms.append(Room(name: "Kitchen"))
malty.residence1 = maltyHouse

if let firstRoomName = malty.residence1?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
}

// tring 키를 Int 값 배열에 매핑하는 2개의 키-값 쌍을 포함하는 testScores 라는 딕셔너리를 정의
var testScores = ["Bulmang": [86, 82, 84], "Jun": [79, 94, 81]]
testScores["Bulmang"]?[0] = 91
testScores["Jun"]?[0] += 1
testScores["Malty"]?[0] = 72


// malty 의 residence 프로퍼티에 address 프로퍼티에 street 프로퍼티를 접근
// residence 와 address 프로퍼티를 통해 연결하기 위해 2단계 수준의 옵셔널 체이이 사용되며 둘 다 옵셔널 타입
if let maltyStreet = malty.residence1?.address?.street {
    print("John's street name is \(maltyStreet).")
} else {
    print("Unable to retrieve the address.")
}
// Prints "Unable to retrieve the address."

let maltysAddress = Address()
maltysAddress.buildingName = "포항"
maltysAddress.street = "지곡동 철길"
malty.residence1?.address = maltysAddress

// 옵셔널 체이닝을 통해 street 프로퍼티의 값에 접근
if let maltyStreet = malty.residence1?.address?.street {
    print("John's street name is \(maltyStreet).")
} else {
    print("Unable to retrieve the address.")
}
// Prints "John's street name is Laurel Street."

// 옵셔널 체이닝을 통해 Address 클래스의 buildingIdentifier() 메서드를 호출
// 이 메서드는 String? 타입의 값을 반환. 위에서 설명 했듯이 옵셔널 체이닝 이후 이 메서드 호출의 반환 타입은 String?
if let buildingIdentifier = malty.residence1?.address?.buildingIdentifier() {
    print("Malty's building identifier is \(buildingIdentifier).")
}
if let beginsWithThe =
    malty.residence1?.address?.buildingIdentifier()?.hasPrefix("The") {
    if beginsWithThe {
        print("Malty's building identifier begins with \"The\".")
    } else {
        print("Malty's building identifier does not begin with \"The\".")
    }
}
// Prints "John's building identifier begins with "The".

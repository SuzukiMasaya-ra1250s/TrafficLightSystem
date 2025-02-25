import Foundation
import PlaygroundSupport

class TrafficLightSystem {
    // 信号機のライトを定義(配列：青、黄、赤)
    var trafficLightEastWest: [Bool] = [false, false, true] // 東西線用：初期値赤点灯
    var trafficLightSouthNorth: [Bool] = [false, false, true] // 南北線用：初期値赤点灯
    
    // Timer設定
    var timer: Timer?
    var count: Int = 0
    
    // 信号機の表示パターンを定義
    enum TrafficLightTime {
        case trafficLightAllRed // 全て：赤🔴
        case trafficLightEastWestBlue // 東西線：青🔵
        case trafficLightEastWestYellow // 東西線：黄🟡
        case trafficLightSouthNorthBlue // 南北線：青🔵
        case trafficLightSouthNorthYellow // 南北線：黄🟡
    }
    
    // 信号機稼働開始
    func start() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(countup),
            userInfo: nil,
            repeats: true
        )
    }
    
    // 信号機稼働停止
    func stop() {
        trafficLightControl(type: .trafficLightAllRed) // 信号を赤にしてからタイマーを止める
        timer?.invalidate()
        print("信号機停止")
    }

    // カウント時間（範囲）の信号表示パタンを定義する
    @objc func countup() {
        count += 1
        print(count)

        switch count {
        case 0...5: // 0~5秒：すべて赤🔴
            trafficLightControl(type: .trafficLightAllRed)
        case 6...10: // 6~10秒：東西線信号を青🔵に変える
            trafficLightControl(type: .trafficLightEastWestBlue)
        case 11...13: // 11~13秒：東西信号を黄🟡に変える
            trafficLightControl(type: .trafficLightEastWestYellow)
        case 14...15: // 14,15秒：東西信号を赤🔴に変える=全て赤🔴
            trafficLightControl(type: .trafficLightAllRed)
        case 16...20: // 16~20秒：南北線信号を青🔵に変える
            trafficLightControl(type: .trafficLightSouthNorthBlue)
        case 21...23: // 21~23秒：南北線信号を黄🟡に変える
            trafficLightControl(type: .trafficLightSouthNorthYellow)
        case 24: // 24,5秒：東西信号を赤🔴に変える=全て赤🔴、１サイクルしたのでループ途中に戻すためcount値変更
            trafficLightControl(type: .trafficLightAllRed)
            count = 4
        default: // 例外：もし範囲外の秒数になった場合には信号機を止める
            stop()
        }
    }
    
    // 信号機（配列）に表示される信号表示パタンを書き込む
    func trafficLightControl(type: TrafficLightTime){
        switch type {
        case .trafficLightAllRed:
            trafficLightEastWest = [false, false, true] // 東西：⚫️⚫️🔴
            trafficLightSouthNorth = [false, false, true] // 南北：⚫️⚫️🔴
        case .trafficLightEastWestBlue:
            trafficLightEastWest = [true, false, false] // 東西：🔵⚫️⚫️
            trafficLightSouthNorth = [false, false, true] // 南北：⚫️⚫️🔴
        case .trafficLightEastWestYellow:
            trafficLightEastWest = [false, true, false] // 東西：⚫️🟡⚫️
            trafficLightSouthNorth = [false, false, true] // 南北：⚫️⚫️🔴
        case .trafficLightSouthNorthBlue:
            trafficLightEastWest = [false, false, true] // 東西：⚫️⚫️🔴
            trafficLightSouthNorth = [true, false, false] // 南北：🔵⚫️⚫️
        case .trafficLightSouthNorthYellow:
            trafficLightEastWest = [false, false, true] // 東西：⚫️⚫️🔴
            trafficLightSouthNorth = [false, true, false] // 南北：⚫️🟡⚫️
        }
        
        print("東西線信号：\(trafficLightEastWest)，南北線信号：\(trafficLightSouthNorth)") // 動作確認用のprint文
        trafficLightAuth() // 信号が規定通りの表示になっているかチェックする（メソッド呼び出し）
    }
    
    // 信号動作の保証（点灯しているのは１つだけ、決まった信号パタンであること：青/黄のとき交差側は赤、赤どうしは許容）
    func trafficLightAuth() {
        let a: Bool = trafficLightEastWest[0]
        let b: Bool = trafficLightEastWest[1]
        let c: Bool = trafficLightEastWest[2]
        let d: Bool = trafficLightSouthNorth[0]
        let e: Bool = trafficLightSouthNorth[1]
        let f: Bool = trafficLightSouthNorth[2]
        
        let oneTrueEW: Bool = (a && !b && !c) || (!a && b && !c) || (!a && !b && c) // 東西線信号内で点灯は１つだけ
        let oneTrueSN: Bool = (d && !e && !f) || (!d && e && !f) || (!d && !e && f) // 南北線信号内で点灯は１つだけ
        let crossRed: Bool = (c && f) || (a && f) || (b && f) || (c && d) || (c && e) // 決まった信号パタンであること（許容パタン）
        let lightAuth = oneTrueEW && oneTrueSN && crossRed
        print("正常動作：\(lightAuth)")
    }
}
let trafficLightSystem = TrafficLightSystem()
let trafficLightEastWest = trafficLightSystem.trafficLightEastWest
let trafficLightSouthNorth = trafficLightSystem.trafficLightSouthNorth

trafficLightSystem.start() // 信号機電源オン

print("東西線信号：\(trafficLightEastWest)，南北線信号：\(trafficLightSouthNorth)")


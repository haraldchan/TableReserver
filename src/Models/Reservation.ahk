#Include "../../lib/LibIndex.ahk"

Guest := Struct({
	name: String,
	roomConf: Integer,
	mobile: Integer,
})

Zone := Struct({
    period: String, ; 早茶/午市/晚市
    round: Integer
})

Request := Struct({
    restaurant: String,
    accommodate: Integer,
    date: String,
    time: String,
    zone: Zone,
    isLargeTable: Integer ; bool
})

Reservation := Struct({
    bookingId: String, ; A_Now . A_MSec . "rand" . Random(100)
    guest: Guest,
    request: Request,
    booker: String,
    remarks: String,
    textSend: Integer, ; bool
})
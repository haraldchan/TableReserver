#Include "../TableReserve.ahk"
#Include "../src/Components/ResvDetail.ahk"

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

dummyGuest := Reservation.new({
    bookingId: "000000000000r0000",
	guest: {
		name: "蒋俊伟",
		roomConf: 2604,
		mobile: 18824190309
	},
	request: {
		restaurant: "宏图府",
		accommodate: 8,
		date: "20241101",
		time: "0800",
		zone: {
			period: "早茶",
			round: 1
	    },
		isLargeTable: true
    },


	booker: "QQ",
	remarks: "尽量靠窗",
	textSend: 1
})

ResvDetail("", db, dummyGuest)

F12::RELOAD

#Include "../TableReserve.ahk"
#Include "../src/Components/ResvList.ahk"
#Include "../src/Models/Reservation.ahk"

LIMIT := JSON.parse(FileRead("../tr.config.json", "UTF-8"))["limit"]

dummyResvs := [
{
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
}, {
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
}, {
    bookingId: "000000000000r0000",
    guest: {
        name: "蒋俊伟",
        roomConf: 2604,
        mobile: 18824190309
    },
    request: {
        restaurant: "玉堂春暖",
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
}, {
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
},
]

ResvList(TableReserve, dummyResvs, LIMIT)
TableReserve.Show()

F12:: RELOAD

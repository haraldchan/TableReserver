#Include "../TableReserve.ahk"
#Include "../src/Components/ResvLists/ResvListTab.ahk"
#Include "../src/Models/Reservation.ahk"

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

ResvListTab(TableReserve, dummyResvs)
TableReserve.Show()
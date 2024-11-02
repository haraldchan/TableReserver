HongTuHall(App, resvAll, hthLimit) {
    largeTable := computed(resvAll, all => all.filter(item => item["request"]["retaurant"] == "宏图府" && item["request"]["isLargeTable"]))
    round1 := computed(resvAll, all => all.filter(item => item["request"]["retaurant"] == "宏图府" && item["request"]["zone"]["round"] == 1))
    round2 := computed(resvAll, all => all.filter(item => item["request"]["retaurant"] == "宏图府" && item["request"]["zone"]["round"] == 2))
    round3 := computed(resvAll, all => all.filter(item => item["request"]["retaurant"] == "宏图府" && item["request"]["zone"]["round"] == 3))
    roundW := computed(resvAll, all => all.filter(item => item["request"]["retaurant"] == "宏图府" && item["request"]["zone"]["round"] == 0))

    lvSettings := {
        columnDetails: {
            keys: [
                ["guest", "name"],
                ["request", "accommodate"],
                ["request", "time"],
                ["guest", "roomConf"],
                ["guest", "mobile"],
                "booker",
                "remarks"
            ],
            titles: ["客人姓名", "用餐人数", "用餐时间", "房号/确认号", "联系电话", "预订经手人", "备注"],
        },
        commonOption: "Grid NoSortHdr -ReadOnly -Multi x20 y+15 w350 ",
        optionsL:  { lvOptions: lvSettings.commonOption . "r3" },
        optionsR1: { lvOptions: lvSettings.commonOption . "r10" },
        optionsR2: { lvOptions: lvSettings.commonOption . "r5" },
        optionsR3: { lvOptions: lvSettings.commonOption . "r5" },
        optionsRW: { lvOptions: lvSettings.commonOption . "r5" },
    }

    return (
        ; large table
        App.AddText("w200 h25", "大台").SetFont("Bold s10.5"),
        App.AddReactiveText("x+20", "已预订: {1} / " . hthLimit["isLargeTable"], computed(largeTable, cur => cur.Length)),
        App.AddReactiveListView(lvSettings.optionsL, lvSettings.columnDetails, largeTable),
        ; round 1
        App.AddText("w200 h25 y+15", "第一轮").SetFont("Bold s10.5"),
        App.AddReactiveText("x+20", "已预订: {1} / " . hthLimit["round1"], computed(round1, cur => cur.Length)),
        App.AddReactiveListView(lvSettings.optionsR1, lvSettings.columnDetails, round1),
        ; round 2
        App.AddText("w200 h25 y+15", "第二轮").SetFont("Bold s10.5"),
        App.AddReactiveText("x+20", "已预订: {1} / " . hthLimit["round2"], computed(round2, cur => cur.Length)),
        App.AddReactiveListView(lvSettings.optionsR2, lvSettings.columnDetails, round2),
        ; round 3
        App.AddText("w200 h25 y+15", "第三轮").SetFont("Bold s10.5"),
        App.AddReactiveText("x+20", "已预订: {1} / " . hthLimit["round3"], computed(round3, cur => cur.Length)),
        App.AddReactiveListView(lvSettings.optionsR3, lvSettings.columnDetails, round3),
        ; round wait-list
        App.AddText("w200 h25 y+15", "轮候").SetFont("Bold s10.5"),
        App.AddReactiveText("x+20", "已预订: {1} / " . hthLimit["roundW"], computed(roundW, cur => cur.Length)),
        App.AddReactiveListView(lvSettings.optionsRW, lvSettings.columnDetails, roundW),
    )
}
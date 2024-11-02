/**
 * @param {Gui} App main gui object.
 * @param {signal<Array>} resvAll all reservations of the day
 * @param {Map} limit reservation limit from config
 * @param {String} resName name of restaurant
 */
ThirdFloors(App, resvAll, limit, resName) {
    resLimit := limit[resName]
    rounds := [1, 2, 3]
    curPeriod := signal("B")

    round1 := computed(resvAll, all => all.filter(item => item["request"]["restaurant"] == resName && item["request"]["zone"][curPeriod.value]))

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
        optionsR1: { lvOptions: lvSettings.commonOption . "r10" },
        optionsR2: { lvOptions: lvSettings.commonOption . "r5" },
        optionsR3: { lvOptions: lvSettings.commonOption . "r5" },
        optionsRW: { lvOptions: lvSettings.commonOption . "r5" },
    }

    addLists(App, listViewOptions, round) {
        return (
            App.AddText("w200 h25", Format("第 {1} 轮", round)).SetFont("Bold s10.5"),
            App.AddReactiveText("x+20", "已预订: {1} / {2}", [
                computed([resvAll,curPeriod], (all, cur) => all.count(item => item["request"]["restaurant"] == resName && item["request"]["zone"]["period"] == cur)),
                computed(curPeriod, cur => limit["round" . cur . round])
            ]),
            App.AddReactiveList(lvSettings.optionsR1, lvSettings.columnDetails, 
                computed([resvAll, curPeriod], (all, cur) => all.filter(item => 
                    item["request"]["restaurant"] == resName
                    && item["request"]["zone"]["period"] == cur 
                    && item["request"]["zone"]["round"] == round
            )))
        )
    }

    return (
        ; period btn group
        App.AddButton("w100 h35", "早 茶").OnEvent("Click", (*) => curPeriod.set("B")),
        App.AddButton("x+0 w100 h35", "午 市").OnEvent("Click", (*) => curPeriod.set("L")),
        App.AddButton("x+0 w100 h35", "晚 市").OnEvent("Click", (*) => curPeriod.set("D")),
        
        addLists(App, lvSettings.optionsR1, 1)
        addLists(App, lvSettings.optionsR1, 2)
        addLists(App, lvSettings.optionsR1, 3)
    )
}
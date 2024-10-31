ResvList(App, listData, LIMIT) {
    reservations := signal(listData)
    selectedRestaurant := signal("宏图府")
    filteredReservations := computed([reservations, selectedRestaurant], (list, res) => 
        list.filter(item => list.filter(item => item["request"]["restaurant"] == res))
    )

    avail := computed([filteredReservations, selectedRestaurant], (filtered, res) => getAvail(filtered, res))
    getAvail(filtered, res) {
        if (res == "宏图府") {
            return Format("大台: {}/{}; 第一轮: {}/{}`n第二轮: {}/{}`n第三轮: {}/{}",
                filtered.filter(resv => resv["request"]["isLargeTable"] == true).Length,
                LIMIT["hongtuHall"]["isLargeTable"],
                filtered.filter(resv => resv["request"]["zone"]["round"] == 1).Length,
                LIMIT["hongtuHall"]["round1"],
                filtered.filter(resv => resv["request"]["zone"]["round"] == 2).Length,
                LIMIT["hongtuHall"]["round2"],
                filtered.filter(resv => resv["request"]["zone"]["round"] == 3).Length,
                LIMIT["hongtuHall"]["round3"],
            )
        } else if (res == "玉堂春暖" || res == "风味餐厅") {
            curRes := res == "玉堂春暖" ? "jadeRiver" : "flavorsOfChina"
            return Format("
            (
                早茶 第一轮: {}/{};  第二轮: {}/{}
                午市 第一轮: {}/{};  第二轮: {}/{}
                晚市 第一轮: {}/{};  第二轮: {}/{}; 第三轮: {}/{}
            )",
                filtered.filter(resv => resv["request"]["zone"]["period"] == "早茶" && resv["request"]["zone"]["round"] == 1),
                LIMIT[res]["早茶"]["round1"]
                filtered.filter(resv => resv["request"]["zone"]["period"] == "早茶" && resv["request"]["zone"]["round"] == 2),
                LIMIT[res][""]
                filtered.filter(resv => resv["request"]["zone"]["period"] == "午市" && resv["request"]["zone"]["round"] == 1),
                LIMIT[res][""]
                filtered.filter(resv => resv["request"]["zone"]["period"] == "午市" && resv["request"]["zone"]["round"] == 2),
                LIMIT[res][""]
                filtered.filter(resv => resv["request"]["zone"]["period"] == "晚市" && resv["request"]["zone"]["round"] == 1),
                LIMIT[res][""]
                filtered.filter(resv => resv["request"]["zone"]["period"] == "晚市" && resv["request"]["zone"]["round"] == 2),
                LIMIT[res][""]
                filtered.filter(resv => resv["request"]["zone"]["period"] == "晚市" && resv["request"]["zone"]["round"] == 3)
            )
        }
    }

    lvSettings := {
        columnDetails: {
            keys: [
                ["guest", "name"], 
                ["request", "accommodate"], 
                ["request","time"], 
                ["guest","roomConf"], 
                ["guest, mobile"], 
                "booker", 
                "remarks"
            ],
            titles: ["客人姓名", "用餐人数", "用餐时间", "房号/确认号", "联系电话", "预订经手人", "备注"],
        },
        options: {
            lvOptions: "$resvList Grid NoSortHdr -ReadOnly -Multi x30 y+15 w350 r15",
        }
    }

    return (
        ; restaurant selector btn group
        App.AddButton("vhongtuHallx30 y+15 w115 h35", "宏图府")
           .OnEvent("Click", (ctrl, _) => selectedRestaurant.set(ctrl.Text)),
        App.AddButton("vjadeRiver x+0 w115 h35", "玉堂春暖")
           .OnEvent("Click", (ctrl, _) => selectedRestaurant.set(ctrl.Text)),
        App.AddButton("vflavorsOfChina x+0 w115 h35", "风味餐厅")
           .OnEvent("Click", (ctrl, _) => selectedRestaurant.set(ctrl.Text)),

        ; report listview
        App.AddReactiveText("y+20 h60", "{1}", avail),

        App.AddReactiveListView(lvSettings.options, lvSettings.columnDetails, filteredReservations),
    )
}
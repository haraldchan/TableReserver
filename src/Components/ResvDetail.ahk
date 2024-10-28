ResvDetail(App, db, updateInfo := 0) {
    RD := Gui("+AlwaysOnTop", "预订详情")
    RD.SetFont(, "微软雅黑")

    Reservation := Struct({
        bookingId: Integer, ; A_Now . A_MSec . "rand" . Random(100)
        guest: Guest,
        request: Request,
        booker: String,
        remarks: String,
        textSend: Integer, ; bool
    })

    Guest := Struct({
        name: String,
        roomConf: String,
        mobile: Integer,
    })

    Request := Struct({
        restaurant: String,
        accommodate: Integer,
        date: String,
        zone: Zone,
        isLargeTable: Integer ; bool
    })

    Zone := Struct({
        period: String, ; 早茶/午市/晚市
        round: Integer
    })

    zoneSignal := signal(updateInfo == 0
        ? { period: " ", round: " " }
        : { period: updateInfo["request"]["zone"]["period"], round: updateInfo["request"]["zone"]["round"] }
    )
    restaurantList := ["宏图府", "玉堂春暖", "风味餐厅", "流浮阁"]
    tomorrow := FormatTime(DateAdd(A_Now, 1, "Days"), "yyyyMMdd")

    resvInfo := Reservation.new(updateInfo != 0 ? updateInfo : {
        bookingId: A_Now . A_MSec . "rand" . Random(100),
        guest: {
            name: "",
            roomConf: 0,
            mobile: 0
        },
        request: {
            retaurant: restaurantList[1],
            accommodate: 1,
            date: tomorrow,
            zone: {
                period: zoneSignal.value["period"],
                round: zoneSignal.value["round"]
            },
            isLargeTable: form.accommodate > 6 ? true : false
        },
        booker: "",
        remarks: "",
        textSend: 0
    })

    saveResv() {
        form := RD.submit()

        ; update guest
        resvInfo["guest"]["name"] := form.name
        resvInfo["guest"]["nameConf"] := form.nameConf
        resvInfo["guest"]["mobile"] := form.mobile

        ; update request
        resvInfo["request"]["restaurant"] := form.restaurant
        resvInfo["request"]["accommodate"] := form.accommodate
        resvInfo["request"]["date"] := form.date
        resvInfo["request"]["zone"]["period"] := zoneSignal.value["period"]
        resvInfo["request"]["zone"]["round"] := zoneSignal.value["round"]
        resvInfo["request"]["isLargeTable"] := form.accommodate > 6 ? true : false

        ; update misc
        resvInfo["booker"] := form.booker
        resvInfo["remarks"] := form.remarks
        resvInfo["textSend"] := form.textSend

        if (updateInfo = 0) {
            db.add(resvInfo.stringify(), FormatTime(resvInfo["request"]["date"], "yyyyMMdd"), resvInfo["bookingId"])
        } else {
            db.updateOne(resvInfo.stringify(), resvInfo["request"]["date"], resvInfo["bookingId"] . ".json")
        }

        A_Clipboard := Format("已预订{1} {2}, {3}。 人数: {4}位，预订人：{5} {6}",
            resvInfo["request"]["restaurant"],
            resvInfo["request"]["date"],
            resvInfo["request"]["time"],
            resvInfo["request"]["accommodate"],
            resvInfo["booker"],
            resvInfo["textSend"] == true ? "已发短信" : ""
        )
    }

    /**
     * Sets zoneSignal with value: {period: "早茶"/"午市"/"晚市", round: 1/2/3/0}
     * @param {String} time "HHMM"
     */
    zoneSetter(time) {
        if (time == "") {
            zoneSignal.set("")
        }

        if (time.Length != 4) {
            MsgBox("时间格式必须为 HHMM。如：0800", "预订详情", "T2")
            RD.getCtrlByName("time").Text := ""
            zoneSignal.set("")
            return
        }

        currentRestaurant := RD.getCtrlByName("retaurant").Text
        period := ""
        round := 0

        if (currentRestaurant == "宏图府") {
            period := "早茶"

            if (time = 800) {
                round := 1
            } else if (time > 800 && time < 1200) {
                round := 2
            } else if (time >= 1200) {
                round := 3
            }
        }

        if (currentRestaurant == "玉堂春暖" || currentRestaurant == "风味餐厅") {
            if (time < 1130) {
                period := "早茶"

                if (time = 800) {
                    round := 1
                } else if (time > 800 && time < 1130) {
                    round := 2
                }
            } else if (time > 1130 && time < 1730) {
                period := "午市"

                if (time >= 1130 && time < 1300) {
                    round := 1
                } else if (time > 1300 && time < 1500) {
                    round := 2
                }

            } else if (time > 1730) {
                period := "晚市"

                if (time >= 1730 && time < 2000) {
                    round := 1
                } else if (time >= 2000 && time < 2100) {
                    round := 2
                } else if (time >= 2100) {
                    round := 3
                }
            }
        }

        zoneSignal.set({ period: period, round: round })
    }

    return (
        ; guest info
        RD.AddGroupBox("Section x30 y350 r4 w350", "客人信息"),
        ; name
        RD.AddText("xp+10 y+10 h20 0x200", "客人姓名"),
        RD.AddEdit("vname x+13 w150 h20", resvInfo["guest"]["name"]),
        ; room/conf.
        RD.AddText("xs10 y+10 h20 0x200", "房号/确认号"),
        RD.AddEdit("vroomConf x+13 w150 h20 Number", resvInfo["guest"]["nameConf"]),
        ; mobile
        RD.AddText("xs10 y+10 h20 0x200", "手机号码"),
        RD.AddEdit("vmobile x+13 w150 h20 Number", resvInfo["guest"]["mobile"]),
        ; resv info
        RD.AddGroupBox("Section x30 y+10 r7 w350", "订台详情"),
        ; restaurant
        RD.AddText("xp+10 yp+30 h20 0x200", "预订餐厅"),
        RD.AddDropDownList("vrestaurant w150 x+10 Choose" . restaurantList.findIndex(r => r == resvInfo["request"]["restaurant"]), restaurantList),
        ; date
        RD.AddText("xs10 y+10 h20 0x200", "预订日期"),
        RD.AddDateTime("vdate x+13 w150 Choose" . resvInfo["request"]["date"], "LongDate"),
        ; time/zone
        RD.AddText("xs10 y+10 h20 0x200", "预订时间"),
        RD.AddEdit("vtime x+13 w120 h20 Number", resvInfo["request"]["time"])
        .OnEvent("LoseFocus", (ctrl, _) => zoneSetter(ctrl.Value)),
        RD.AddReactiveText("x+13 h20 0x200", "{1}第{2}轮", zoneSignal, ["period", "round"]),
        ; accommodate
        RD.AddText("xs10 y+10 h20 0x200", "用餐人数"),
        RD.AddEdit("vaccommodate x+13 w150 h20 Number", resvInfo["request"]["accommodate"]),
        ; misc
        RD.AddGroupBox("Section x30 y+10 r7 w350", "其他信息"),
        ; booker
        RD.AddText("xs10 y+10 h20 0x200", "预订人"),
        RD.AddEdit("vbooker x+13 w150 h20", resvInfo["booker"]),
        ; remarks
        RD.AddText("xs10 y+10 h20 0x200", "备注信息"),
        RD.AddEdit("vremarks x+13 w150 h20", resvInfo["remarks"]),
        ; text send
        RD.AddCheckbox("vtextSend xs10 y+10 h20 0x200 " . resvInfo["textSend"] == true ? "Checked" : "", "已发短信"),
        ; btns
        RD.AddButton("y+20", "取消").OnEvent("Click", (*) => RD.Destroy()),
        RD.AddButton("x+20", "提交").OnEvent("Click", (*) => saveResv())
    )
}
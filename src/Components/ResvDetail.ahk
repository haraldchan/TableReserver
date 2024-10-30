ResvDetail(App, db, readInfo := 0) {
    RD := Gui("+AlwaysOnTop", "预订详情")
    RD.SetFont(, "微软雅黑")


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
        bookingId: Integer, ; A_Now . A_MSec . "rand" . Random(100)
        guest: Guest,
        request: Request,
        booker: String,
        remarks: String,
        textSend: Integer, ; bool
    })

    zoneSignal := signal(readInfo == 0
        ? { period: " ", round: " " }
        : { period: readInfo["request"]["zone"]["period"], round: readInfo["request"]["zone"]["round"] }
    )
    restaurantList := ["宏图府", "玉堂春暖", "风味餐厅", "流浮阁"]
    tomorrow := FormatTime(DateAdd(A_Now, 1, "Days"), "yyyyMMdd")

    saveResv() {
        form := RD.submit()

        resvInfo := Reservation.new({
            bookingId: readInfo == 0 ? A_Now . A_MSec . "rand" . Random(100) : readInfo["bookingId"],
            guest: {
                name: form.name,
                roomConf: form.roomConf,
                mobile: form.mobile
            },
            request: {
                retaurant: restaurantList[form.restaurant],
                accommodate: form.accommodate,
                date: form.date,
                zone: {
                    period: zoneSignal.value["period"],
                    round: zoneSignal.value["round"]
                },
                isLargeTable: form.accommodate > 6 ? true : false
            },
            booker: form.booker,
            remarks: form.remarks,
            textSend: form.textSend
        })

        ; if (readInfo = 0) {
        ;     db.add(resvInfo.stringify(), FormatTime(resvInfo["request"]["date"], "yyyyMMdd"), resvInfo["bookingId"])
        ; } else {
        ;     db.updateOne(resvInfo.stringify(), resvInfo["request"]["date"], resvInfo["bookingId"] . ".json")
        ; }

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

        if (StrLen(time) != 4) {
            MsgBox("时间格式必须为 HHMM。如：0800", "预订详情", "T2")
            RD.getCtrlByName("time").Text := ""
            zoneSignal.set("")
            return
        }

        currentRestaurant := RD.getCtrlByName("restaurant").Text
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

            } else if (time >= 1730) {
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

        zoneSignal.set({ time: time, period: period, round: round })
    }



    return (
        ; guest info
        RD.AddGroupBox("Section x20 r4.5 w250", "客人信息").SetFont(, "Bold"),
        ; name
        RD.AddText("xp+10 yp+25 h25 0x200", "客人姓名    "),
        RD.AddEdit("vname x+13 w150 h25", !readInfo ? "" : readInfo["guest"]["name"]),
        ; room/conf.
        RD.AddText("xs10 y+10 h25 0x200", "房号/确认号"),
        RD.AddEdit("vroomConf x+13 w150 h25 Number", !readInfo ? "" : readInfo["guest"]["roomConf"]),
        ; mobile
        RD.AddText("xs10 y+10 h20 0x200", "手机号码    "),
        RD.AddEdit("vmobile x+13 w150 h25 Number", !readInfo ? "" : readInfo["guest"]["mobile"]),
        
        ; resv info
        RD.AddGroupBox("Section x20 y+30 r6 w250", "订台详情"),
        ; restaurant
        RD.AddText("xp+10 yp+30 h25 0x200", "预订餐厅    "),
        RD.AddDropDownList("vrestaurant w150 x+10 Choose" . (!readInfo ? 1 :restaurantList.findIndex(r => r == readInfo["request"]["restaurant"])), restaurantList),
        ; date
        RD.AddText("xs10 y+10 h25 0x200", "预订日期    "),
        RD.AddDateTime("vdate x+13 w150 Choose" . (!readInfo ? tomorrow : readInfo["request"]["date"]), "LongDate"),
        ; time/zone
        RD.AddText("xs10 y+10 h25 0x200", "预订时间    "),
        RD.AddEdit("vtime x+13 w70 h25 Number", !readInfo ? "" : readInfo["request"]["time"])
          .OnEvent("LoseFocus", (ctrl, _) => zoneSetter(ctrl.Value)),
        RD.AddReactiveText("x+13 h25 0x200", "{1} 第 {2} 轮", zoneSignal, ["period", "round"]),
        ; accommodate
        RD.AddText("xs10 y+10 h20 0x200", "用餐人数    "),
        RD.AddEdit("vaccommodate x+13 w150 h20 Number", !readInfo ? "" : readInfo["request"]["accommodate"]),
        
        ; misc
        RD.AddGroupBox("Section x20 y+30 r3 w250", "其他信息"),
        ; booker
        RD.AddText("xp+10 yp+30 h20 0x200", "预订人       "),
        RD.AddEdit("vbooker x+13 w150 h20", !readInfo ? "" : readInfo["booker"]),
        ; remarks
        RD.AddText("xs10 y+10 h20 0x200", "备注信息    "),
        RD.AddEdit("vremarks x+13 w150 h20", !readInfo ? "" : readInfo["remarks"]),
        ; ; text send
        ; RD.AddCheckbox("vtextSend xs10 y+10 h20 0x200 " . !readInfo ? false : readInfo["textSend"] ? "Checked" : "", "已发短信"),



        ; ; btns
        ; RD.AddButton("y+20", "取消").OnEvent("Click", (*) => RD.Destroy()),
        ; RD.AddButton("x+20", "提交").OnEvent("Click", (*) => saveResv())
        RD.Show()
    )
}

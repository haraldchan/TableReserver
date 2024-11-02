#Include "./HongTuHall.ahk"

ResvListTab(App, reservations) {
    restaurantMap := OrderedMap(
        "宏图府", "hongTuHall",
        "玉堂春暖", "jadeRiver",
        "风味餐厅", "flavorsOfChina"
    )
    limit := JSON.parse(FileRead("../../../tr.config.json", "UTF-8"))["limit"]
    resvAll := signal(reservations)

    return (
        Tab3 := App.AddTab3("w550", restaurantMap.keys()),
        
        Tab3.UseTab("宏图府"),
        HongTuHall(App, resvAll, limit["hongtuHall"]),

        Tab3.UseTab("玉堂春暖"),
        Tab3.UseTab("风味餐厅"),
        Tab3.UseTab(0)
    )
}
#Include "../TableReserve.ahk"
#Include "../src/Components/ResvDetail.ahk"

ResvDetail_Test := Gui()
ResvDetail(ResvDetail_Test, db)
ResvDetail_Test.Show()
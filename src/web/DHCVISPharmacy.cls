Import SQLUser

Class web.DHCVISPharmacy Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCVISPharmacy).GetWindowInfo("10.8.12.13")
ClassMethod GetWindowInfo(ServerIP As %String = "") As %String
{
	s RetStr="" //"1&0&sdfdefsd^2&0&dsfds"
	q:ServerIP="" RetStr
	s ServerId=$O(^DHCVISServeri(0,"ServerIP",ServerIP,""))
	q:ServerId="" RetStr
	s LocId=$P($G(^DHCVISServer(ServerId)),"^",8)
	i LocId="" d
	.s ClientId=""
	.f  s ClientId=$O(^DHCVISClienti(0,"ServerID",ServerId,ClientId)) q:ClientId=""  d
	..s WinId=$P($G(^DHCVISClient(ClientId)),"^",11)
	..s WindNo=+$P($G(^DHCVISClient(ClientId)),"^",5)
	..q:WinId=""
 	..s WinDesc=$p(^DHCPHWIN(WinId),"^",1)
 	..s PhlId=+$p(^DHCPHWIN(WinId),"^",2)
 	..s PhLocId=+$p(^DHCPHLOC(PhlId),"^",1)
 	..q:((LocId'="")&&(LocId'=PhLocId))
 	..s PhWpId=$O(^DHCPHWPi("WINDOW",PhlId,WinId,""))
 	..i PhWpId'="" d
 	...s DoFlag=+$p(^DHCPHWP(PhWpId),"^",1)
 	...i DoFlag="1" s WindowState="Y" 
 	...e  s WindowState="N"
 	..i WindowState="Y" s WindowState=0
 	..i WindowState="N" s WindowState=1
 	..s WindWaitSum=..GetWindowWait(WinId)
 	..i (WindWaitSum>0)&&(WindowState=1) s WindowState=0
 	..s WindowContent=""
 	..s PhWindId=$O(^DHCVISPhWindi("0","DateWind",+$H,WinId,""))
 	..i PhWindId'="" d
 	...s PhWindStr=$G(^DHCVISPhWind(PhWindId))
 	...s WindowContent=$P(PhWindStr,"^",3)
 	...//s WindowState=$P(PhWindStr,"^",2)
 	..i RetStr="" s RetStr=WindNo_"&"_WindowState_"&"_WindowContent
 	..e  s RetStr=RetStr_"^"_WindNo_"&"_WindowState_"&"_WindowContent
	e  d
	.s WinId=0
 	.f  s WinId=$o(^DHCPHWIN(WinId)) q:(WinId="")!(WinId="0")  d
 	..s WinDesc=$p(^DHCPHWIN(WinId),"^",1)
 	..s PhlId=+$p(^DHCPHWIN(WinId),"^",2)
 	..s PhLocId=+$p(^DHCPHLOC(PhlId),"^",1)
 	..q:((LocId'="")&&(LocId'=PhLocId))
 	..s PhWpId=$O(^DHCPHWPi("WINDOW",PhlId,WinId,""))
 	..i PhWpId'="" d
 	...s DoFlag=+$p(^DHCPHWP(PhWpId),"^",1)
 	...i DoFlag="1" s WindowState="Y" 
 	...e  s WindowState="N"
 	..i WindowState="Y" s WindowState=0
 	..i WindowState="N" s WindowState=1
 	..s WindWaitSum=..GetWindowWait(WinId)
 	..i (WindWaitSum>0)&&(WindowState=1) s WindowState=0
 	..s WindowContent=""
 	..s PhWindId=$O(^DHCVISPhWindi("0","DateWind",+$H,WinId,""))
 	..i PhWindId'="" d
 	...s PhWindStr=$G(^DHCVISPhWind(PhWindId))
 	...s WindowContent=$P(PhWindStr,"^",3)
 	...//s WindowState=$P(PhWindStr,"^",2)
 	..i RetStr="" s RetStr=WindNo_"&"_WindowState_"&"_WindowContent
 	..e  s RetStr=RetStr_"^"_WindNo_"&"_WindowState_"&"_WindowContent
	q RetStr
}

ClassMethod UpdatePhwp(phwp As %String = "", flag As %String = "") As %String
{
	q:(phwp="") 0
	s retFlag=1
	s ActiveSum=0
	i flag=0 d
	.s PhlDr=$P($G(^DHCPHWP(phwp)),"^",2)
	.i PhlDr="" s retFlag=0 q
	.s PhWindDr="" f  s PhWindDr=$O(^DHCPHWPi("WINDOW",PhlDr,PhWindDr)) q:PhWindDr=""  d
	..s PhlFlag=$P($G(^DHCPHWP(PhWindDr)),"^",1)
	..i PhlFlag=1 s ActiveSum=ActiveSum+1
	.i ActiveSum<2 s retFlag=0
 	q:retFlag=0 "不能修改默认窗口状态!"
 	&sql(update dhc_phwper set phwp_doflag=:flag where phwp_rowid=:phwp)

    q SQLCODE
}

ClassMethod UpdateWindow(WindowId As %String = "", WindowContent As %String = "", Avitive As %String = "N", ReceiveWindowId As %String = "") As %String
{
	q:(WindowId="") "信息不完整!"
	s ChangeDate=+$H
	s ChangeTime=$P($H,",",2)
	s PhWindId=$O(^DHCVISPhWindi("0","DateWind",ChangeDate,WindowId,""))
	i PhWindId="" d
	.&SQL(insert into DHC_VIS_PhWind (WindowId,WindowState,ReceiveWindowId,WindowContent,ChangeDate,ChangeTime) values (:WindowId,:Avitive,:ReceiveWindowId,:WindowContent,:ChangeDate,:ChangeTime))
	e  d
	.&SQL(update DHC_VIS_PhWind set WindowId=:WindowId,WindowState=:Avitive,ReceiveWindowId=:ReceiveWindowId,WindowContent=:WindowContent,ChangeDate=:ChangeDate,ChangeTime=:ChangeTime where ID=:PhWindId)
 	i (SQLCODE=0)&&(ReceiveWindowId'="") d
 	.s ChangeRet=..UpdateWindowList(WindowId,ReceiveWindowId)
 	i Avitive="N" d
 	.s UpdateRet=..UpdatePhwp(WindowId,0)
 	e  d
 	.s UpdateRet=..UpdatePhwp(WindowId,1)
	q SQLCODE
}

ClassMethod UpdateWindowList(WindowId As %String = "", ReceiveWindowId As %String = "") As %String
{
	q:((WindowId="")||(ReceiveWindowId="")) ""
 	s WinDesc=$p(^DHCPHWIN(WindowId),"^",1)
 	s PhlId=+$p(^DHCPHWIN(WindowId),"^",2)
 	q:PhlId="" ""
 	s LocId=+$p(^DHCPHLOC(PhlId),"^",1)
	q:LocId="" ""
	s ServerId=""
	s ClientId=$O(^DHCVISClienti(0,"ExaRoomId",WindowId,""))
	i ClientId'="" d
	.s ServerId=+$G(^DHCVISClient(ClientId))
	e  d
	.&SQL(select VIS_ServerID into :ServerId  from DHC_VIS_VoiceServer where VIS_ServerLinkOtherLoc=:LocId)
	q:ServerId="" ""
	s WindNo=+WinDesc
	s ReceiveWinDesc=$p($G(^DHCPHWIN(ReceiveWindowId)),"^",1)
	s ReceiveWindNo=+ReceiveWinDesc
	s Sum=0
	s RowID=""
	f  s RowID=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$h,ServerId,WindNo,"Y",RowID)) q:RowID=""  d
	.&SQL(Update DHC_VIS_DurgLedList set WindowDesc=:ReceiveWinDesc,WindowNo=:ReceiveWindNo where RowID=:RowID)
	.i SQLCODE=0 s Sum=Sum+1
	q Sum
}

ClassMethod GetWindowWait(PhWindId As %String = "") As %String
{
	q:(PhWindId="") 0
	s WinDesc=$p(^DHCPHWIN(PhWindId),"^",1)
	s WindNo=+WinDesc
	s ServerId=""
	s ClientId=$O(^DHCVISClienti(0,"ExaRoomId",PhWindId,""))
	i ClientId'="" d
	.s ServerId=+$G(^DHCVISClient(ClientId))
	e  d
	.s PhlId=+$p(^DHCPHWIN(PhWindId),"^",2)
 	.q:PhlId=""
 	.s LocId=+$p(^DHCPHLOC(PhlId),"^",1)
	.&SQL(select VIS_ServerID into :ServerId  from DHC_VIS_VoiceServer where VIS_ServerLinkOtherLoc=:LocId)
	q:ServerId="" 0
	s Sum=0
	s RowID=""
	f  s RowID=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$h,ServerId,WindNo,"Y",RowID)) q:RowID=""  d
	.s Sum=Sum+1
	q Sum
}

ClassMethod FindWindowClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindWindowExecute ]
{
	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod FindWindowExecute(ByRef QHandle As %Binary, txtCTLocId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	f WinId=0
 	f  s WinId=$o(^DHCPHWIN(WinId)) q:(WinId="")!(WinId="0")  d
 	.s (LocDesc,LocId,WinDesc,WindowState,WindowContent,WindowWait,ReceiveWindow,ReceiveWindowId)=""
 	.s WinDesc=$p(^DHCPHWIN(WinId),"^",1)
 	.s PhlId=+$p(^DHCPHWIN(WinId),"^",2)
 	.s LocId=+$p(^DHCPHLOC(PhlId),"^",1)
 	.q:((txtCTLocId'="")&&(txtCTLocId'=LocId))
 	.s LocDesc=$p($g(^CTLOC(LocId)),"^",2)
 	.s PhWpId=$o(^DHCPHWPi("WINDOW",PhlId,WinId,""))
 	.i PhWpId'="" d
 	..s DoFlag=+$p(^DHCPHWP(PhWpId),"^",1)
 	..i DoFlag="1" s WindowState="Y" 
 	..e  s WindowState="N"
 	.s PhWindId=$O(^DHCVISPhWindi("0","DateWind",+$H,WinId,""))
 	.i PhWindId'="" d
 	..s PhWindStr=$G(^DHCVISPhWind(PhWindId))
 	..q:PhWindStr=""
 	..//s WindowState=$P(PhWindStr,"^",2)
 	..s WindowContent=$P(PhWindStr,"^",3)
 	..s ReceiveWindowId=$P(PhWindStr,"^",4)
 	..i ReceiveWindowId'="" s ReceiveWindow=$p(^DHCPHWIN(ReceiveWindowId),"^",1)
 	.s WindowWait=..GetWindowWait(WinId)
 	.
 	.Do WinOutputRow
 	
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
WinOutputRow
	set Data=$lb(LocDesc,LocId,WinDesc,WinId,WindowState,WindowContent,WindowWait,ReceiveWindow,ReceiveWindowId)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
}

ClassMethod FindWindowFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWindowExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else {
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query FindWindow(txtCTLocId As %String = "") As %Query(ROWSPEC = "TLocDesc:%String,TLocId:%String,TWinDesc:%String,TWinId:%String,TWindowState:%String,TWindowContent:%String,TWindowWait:%String,TReceiveWindow:%String,TReceiveWindowId:%String") [ SqlProc ]
{
}

Query DeptList(CTType As %String, Desc As %String) As %Query(ROWSPEC = "CTRowId:%String,CTDesc:%String")
{
}

ClassMethod DeptListExecute(ByRef qHandle As %Binary, CTType As %String = "D", Desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	i CTType="" s CTType="D"
	s ctlocId=""
	f  s ctlocId=$o(^CTLOC(0,"LocType",CTType,ctlocId)) q:ctlocId=""  d
	.s CTDesc=$p($g(^CTLOC(ctlocId)),"^",2)
	.q:(Desc'="")&&(CTDesc'[Desc)
	.s CTRowId=ctlocId
	.Do OutputRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(CTRowId,CTDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod DeptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		Set AtEnd=1
		Set Row=""
	}
	Else {
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DeptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//w ##Class(web.DHCVISPharmacy).SynPhDispen("10.8.12.13")

ClassMethod SynPhDispen(ServerIP As %String = "")
{
	i ServerIP="" s ServerIP=$ZUTIL(67,15,$JOB)
	q:ServerIP="" ""
	s ServerId=$O(^DHCVISServeri(0,"ServerIP",ServerIP,""))
	q:ServerId="" ""
	s CtLocId=$P($G(^DHCVISServer(ServerId)),"^",8)
	i CtLocId'="" d
	.s PhDisDate=+$H
	.s PhLinLocId=$O(^DHCPHLOCi("LOC",CtLocId,""))
	.q:PhLinLocId=""
	.s PhDisRowId=""
	.f  s PhDisRowId=$o(^DHCPHDISPi(PhDisDate,PhLinLocId,PhDisRowId)) q:(PhDisRowId="")!(PhDisRowId="0")  d
	..s SendRet=..PhDispenSend(ServerIP,PhDisRowId)
	e  d
	.s ClientId=""
	.f  s ClientId=$O(^DHCVISClienti(0,"ServerID",ServerId,ClientId)) q:ClientId=""  d
	..
	..s LinkPhWindId=$P($G(^DHCVISClient(ClientId)),"^",11)
	..s ClientIP=$P($G(^DHCVISClient(ClientId)),"^",2)
	..q:LinkPhWindId=""
 	..s PhLinLocId=+$p($G(^DHCPHWIN(LinkPhWindId)),"^",2)
 	..q:PhLinLocId=""
 	..s PhDisDate=+$H
	..s PhDisRowId=""
	..f  s PhDisRowId=$o(^DHCPHDISPi(PhDisDate,PhLinLocId,PhDisRowId)) q:(PhDisRowId="")!(PhDisRowId="0")  d
	...s PhWinId=+$p(^DHCPHDISP(PhDisRowId,1),"^",4)
	...q:PhWinId'=LinkPhWindId
	...s SendRet=..PhDispenSend(ClientIP,PhDisRowId)
	q 0
}

ClassMethod PhDispenSend(ServerIP As %String = "", PhDisRowId As %String = "")
{
	s PYDr=+$p(^DHCPHDISP(PhDisRowId,1),"^",3)
	s PYFlag=+$p(^DHCPHDISP(PhDisRowId,1),"^",6)
	q:PYFlag'="1" ""
	s PatPmi=+$p(^DHCPHDISP(PhDisRowId),"^",7)
	s PatName=$p(^PAPER(PatPmi,"ALL"),"^",1)
	s PatNo=$p(^PAPER(PatPmi,"PAT",1),"^",2)
	s PYUserId=1
	i PYDr'=0 s PYUserId=+$p(^DHCPHPER(PYDr),"^",5)
	i PYUserId=0 s PYUserId=1
	s PhWin=+$p(^DHCPHDISP(PhDisRowId,1),"^",4)
 	s PhlId=+$p(^DHCPHWIN(PhWin),"^",2)
 	s PhWpId=$o(^DHCPHWPi("WINDOW",PhlId,PhWin,""))
 	q:PhWpId="" ""
 	s DoFlag=+$p(^DHCPHWP(PhWpId),"^",1)
	q:DoFlag'=1 ""
	s WinDesc=$p(^DHCPHWIN(PhWin),"^",1)
	s PrtId=+$p(^DHCPHDISP(PhDisRowId),"^",2)
	s PrescNo=$p(^DHCPHDISP(PhDisRowId,2),"^",1)
	s VoiceContent="请"_PatName_"到"_WinDesc_"取药"
	s VoiceContent=""
	i $P(WinDesc,"西药房",2)'="" s WinDesc=$P(WinDesc,"西药房",2)
	i $P(WinDesc,"中成药房",2)'="" s WinDesc=$P(WinDesc,"中成药房",2)
	i $P(WinDesc,"免煎药房",2)'="" s WinDesc=$P(WinDesc,"免煎药房",2)
	i $P(WinDesc,"中草药房",2)'="" s WinDesc=$P(WinDesc,"中草药房",2)
	s ScreentContent=WinDesc_","_PatName_","_PatNo_","_PrescNo_","
	s RetVal=##class(web.DHCVISVoiceCall).InsertVoiceQueue(VoiceContent,PYUserId,ServerIP,"D","LR","N",ScreentContent,ScreentContent,"","")
	q RetVal
}

/// w ##class(web.DHCVISPharmacy).GetTopDurgInfo("10.8.10.92")
ClassMethod GetTopDurgInfo(serverIP As %String = "") As %String
{
	s RetStr=""
	s serverID=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverID="" RetStr
	s nowDate=+$H,nowTime=$P($H,",",2)
	&SQL(update DHC_VIS_VoiceServer set VIS_ServerUpdateDate=:nowDate,VIS_ServerUpdateTime=:nowTime where VIS_ServerID=:serverID)
	s AutoSynPh=##Class(web.DHCVISPharmacy).SynPhDispen(serverIP)
	s ShowMax=7
	s WindowNo=""
	f  s WindowNo=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo)) q:WindowNo=""  d
	.i $O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",""))="" d
	..i RetStr="" s RetStr=WindowNo_", "
	..e  s RetStr=RetStr_"&"_WindowNo_", "
	.q:$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",""))=""
	.s CKStr=""
	.s num=1
	.s RowID=$P($G(^DHCVISTemp(+$H,"CK",serverID,WindowNo)),",",1)
	.i $O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID))="" s RowID=""
	.f  s RowID=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID)) q:(RowID="")||(num>ShowMax)  d
	..q:+RowID=0
	..s PrescNo=$P($G(^DHCVISDurgList(RowID)),"^",1)
	..q:PrescNo=""
	..s FYFlag="",BillState=""
	..s PhdRow=$O(^DHCPHDISPi("PRESCNO",PrescNo,""))
	..i PhdRow'="" d
	...s FYFlag=$p($G(^DHCPHDISP(PhdRow)),"^",4)
	...s NowDate=+$H
	...i FYFlag="1" &SQL(Update DHC_VIS_DurgLedList set ActiveFlag='N' where InsertDate=:NowDate and PrescNo=:PrescNo)
	...e  d
	....s OrdId=$O(^OEORD(0,"PrescNo",PrescNo,""))
	....q:OrdId=""
	....s OrdSubId=$O(^OEORD(0,"PrescNo",PrescNo,OrdId,""))
	....q:OrdSubId=""
	....s OrderStateDr=$P($G(^OEORD(OrdId,"I",OrdSubId,1)),"^",13)
	....s BillState=$P($G(^OEORD(OrdId,"I",OrdSubId,3)),"^",5)
	....i (BillState'="P")||((OrderStateDr'=1)&&(OrderStateDr'=6)) &SQL(Update DHC_VIS_DurgLedList set ActiveFlag='N' where InsertDate=:NowDate and PrescNo=:PrescNo)
	..q:((FYFlag="1")||(BillState'="P"))
	..s PatName=$P($G(^DHCVISDurgList(RowID)),"^",3)
	..s PatName=$$ALPHAUP^SSUTIL4(PatName)
	..i $L(PatName)>4 s PatName=$E(PatName,1,4)
	..i $L(PatName)=2 s PatName=PatName_"    "
	..i $L(PatName)=3 s PatName=PatName_"  "
	..i CKStr="" s CKStr=PatName
	..e  d
	...i CKStr'[PatName d
	....s CKStr=CKStr_"^"_PatName
	....s num=num+1
	.i CKStr'="" d
	..i RetStr="" s RetStr=WindowNo_","_CKStr
	..e  s RetStr=RetStr_"&"_WindowNo_","_CKStr
	.s RowID=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID),-1)
	.s ^DHCVISTemp(+$H,"CK",serverID,WindowNo)=RowID
	q RetStr
}

}

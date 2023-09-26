Class web.DHCPE.RoomManagerEx Extends %Persistent
{

// 获取检查科室平均检查时间

// d ##class(%ResultSet).RunQuery("web.DHCPE.RoomManagerEx", "SearchRoomTime","",+$H)

Query SearchRoomTime(StartDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "AreaID:%String,AreaDesc:%String,RoomID:%String,RoomDesc:%String,UserID:%String,UserDesc:%String,Time:%String")
{
}

ClassMethod SearchRoomTimeExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	i (StartDate="")&&(EndDate="")
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s:StartDate="" StartDate=1
 	s:EndDate="" EndDate=+$H
 	s Date=StartDate-1
 	f  s Date=$O(^User.DHCPEAdmRoomRecordI("RoomUserIndex",Date)) q:(Date="")||(Date>EndDate)  d
 	.s RoomInfo=""
 	.f  s RoomInfo=$O(^User.DHCPEAdmRoomRecordI("RoomUserIndex",Date,RoomInfo)) q:(RoomInfo="")  d
 	..s RoomID=$P(RoomInfo," ",2)
 	..s AreaID=+RoomID
 	..s RoomDesc=$LG(^User.DHCPEAreaD(AreaID,"ChildRoom",$P(RoomID,"||",2)),3)
 	..s AreaDesc=$LG(^User.DHCPEAreaD(AreaID),3)
 	..s AdmID=""
 	..f  s AdmID=$O(^User.DHCPEAdmRoomRecordI("RoomUserIndex",Date,RoomInfo,AdmID)) q:(AdmID="")  d
 	...s UserID=""
 	...f  s UserID=$O(^User.DHCPEAdmRoomRecordI("RoomUserIndex",Date,RoomInfo,AdmID,UserID)) q:(UserID="")||(UserID="-100000000000000")  d
 	....s UserDesc=$P(^SSU("SSUSR",UserID),"^",2)
 	....s ID=""
 	....f  s ID=$O(^User.DHCPEAdmRoomRecordI("RoomUserIndex",Date,RoomInfo,AdmID,UserID,ID)) q:(ID="")  d
 	.....s InTime=$LG(^User.DHCPEAdmRoomRecordD(ID),4)
 	.....q:InTime=""
 	.....s OutTime=$LG(^User.DHCPEAdmRoomRecordD(ID),5)
 	.....q:OutTime=""
 	.....s Time=OutTime-InTime
 	.....d SearchRoomTimeBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

SearchRoomTimeBuild
	set Data=$lb(AreaID,AreaDesc,RoomID,RoomDesc,UserID,UserDesc,Time)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchRoomTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchRoomTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SearchRoomTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchRoomTimeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query SearchRoomDetail(Name As %String = "", IDCard As %String = "") As %Query(ROWSPEC = "RegNo:%String:ID号,Name:%String:姓名,Sex:%String:性别,Age:%String:年龄,IDCard:%String:证件号码,GroupDesc:%String:单位,RoomName:%String:诊室名称,RoomStatus:%String:状态")
{
}

ClassMethod SearchRoomDetailExecute(ByRef qHandle As %Binary, Name As %String = "", IDCard As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	/*
 	i (Name="")&&(IDCard="")
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}*/
 	s TotalPerson=0
 	s Name=$ZCVT(Name,"U")
 	s TRoomStatus="等待"
 	s RoomID=""
 	f  s RoomID=$O(^User.DHCPEAdmRoomRecordI("StatusIndex"," N",RoomID)) q:RoomID=""  d
 	.s RealRoomID=$P(RoomID," ",2)
 	.s TRoomName=$LG(^User.DHCPEAreaD(+RealRoomID,"ChildRoom",$P(RealRoomID,"||",2)),3)
 	.s AdmID=""
 	.f  s AdmID=$O(^User.DHCPEAdmRoomRecordI("StatusIndex"," N",RoomID,AdmID)) q:AdmID=""  d
 	..s TotalPerson=TotalPerson+1
 	..s TRoomName=TRoomName_",第"_TotalPerson_"个"
 	..d OneInfo
	s TRoomStatus="过号"
 	s RoomID=""
 	f  s RoomID=$O(^User.DHCPEAdmRoomRecordI("StatusIndex"," P",RoomID)) q:RoomID=""  d
 	.s RealRoomID=$P(RoomID," ",2)
 	.s TRoomName=$LG(^User.DHCPEAreaD(+RealRoomID,"ChildRoom",$P(RealRoomID,"||",2)),3)
 	.s AdmID=""
 	.f  s AdmID=$O(^User.DHCPEAdmRoomRecordI("StatusIndex"," P",RoomID,AdmID)) q:AdmID=""  d
	..d OneInfo
	
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneInfo
	d ClearInfo
	s EpisodeID=$P(AdmID," ",2)
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s CTLocID=$P(^PAADM(EpisodeID),"^",4)
	s HospID=$p($g(^CTLOC(CTLocID)),"^",22)
	s TRegNo=$P(^PAPER(PatientID,"PAT",1),"^",1)
	s TName=$P(^PAPER(PatientID,"ALL"),"^",1)
	s TNamePY=##class(web.DHCINSUPort).GetCNCODE(TName,4,"")
	q:(Name'="")&&(TName'[Name)&&(TNamePY'[Name)
	s TIDCard=$P(^PAPER(PatientID,"PAT",3),"^",6)
	q:(IDCard'="")&&(TIDCard'=IDCard)
	s TSex=$P(^PAPER(PatientID,"ALL"),"^",7)
	S:TSex'="" TSex=$P(^CT("SEX",TSex),"^",2)
	;s TAge=$P(^PAPER(PatientID,"ALL"),"^",6)
	//I PatientID'="" s TAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID)
	I PatientID'="" s TAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PatientID,HospID)
	s PADM=$O(^DHCPEIADM(0,"PAADM",EpisodeID,0))
	q:PADM=""
	s PreADM=$P(^DHCPEIADM(PADM),"^",4)
	s TGroupDesc=$P(^DHCPEPreIADM(PreADM),"^",2)
	s:TGroupDesc'="" TGroupDesc=$P(^DHCPEPreGADM(TGroupDesc),"^",1)
	s:TGroupDesc'="" TGroupDesc=$P(^DHCPEPreGBI(TGroupDesc),"^",2)
	s TTeamDesc=$P(^DHCPEPreIADM(PreADM),"^",3)
	s:TTeamDesc'="" TTeamDesc=$P(^DHCPEPreGADM(+TTeamDesc,"Team",$P(TTeamDesc,"||",2)),"^",1)
	s TVipLevel=$P(^DHCPEPreIADM(PreADM),"^",18)
	s:TVipLevel'="" TVipLevel=$p($g(^DHCPEVIPLevel("VIP",TVipLevel)),"^",2)
	d SearchRoomDetailBuild
	q
ClearInfo
	s (TRegNo,TName,TSex,TAge,TIDCard,TGroupDesc)=""
	q
SearchRoomDetailBuild
	
	//RegNo:%String:ID号,TName:%String:姓名,Sex:%String:性别,Age:%String:年龄,GroupDesc:%String:单位,RoomName:%String:诊室名称,RoomStatus
	set Data=$lb(TRegNo,TName,TSex,TAge,TIDCard,TGroupDesc,TRoomName,TRoomStatus)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchRoomDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchRoomDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SearchRoomDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchRoomDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// 创建叫号排队的列表

ClassMethod OutRoomPersonDiv(RoomID, PAADM)
{
	s TableWidth=525
	s RoomID=$P(RoomID,"$",1)
	q:RoomID=""
	i PAADM'=""{
		s PAdm=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
		q:PAdm="" ""
	}
	s obj=##class(User.DHCPERoom).%OpenId(RoomID)
	s RoomDesc=obj.RDesc
	s StationID=obj.RStationDR
	s UserID=%session.Get("LOGON.USERID")
	s LocID=%session.Get("LOGON.CTLOCID")
	s GroupID=%session.Get("LOGON.GROUPID")
	s CompleteFlag=""
	s:StationID'="" CompleteFlag=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"WriteWay",StationID))
	s:CompleteFlag="" CompleteFlag=1
	s ShowCpmpleteFlag=0
	s:CompleteFlag="1" ShowCpmpleteFlag=1
	;w ##class(web.DHCPE.RoomManagerEx).OutRoomPersonDiv("2||30$Y")
	s ret=""
	s ret="<Table width="_TableWidth_" height=25px border=0>"
	s WaitInfo=""
	i PAADM'="" d
	.s WaitInfo=##class(web.DHCPE.RoomManager).GetAdmCurRoom(PAADM,"ADM")
	.i WaitInfo="" d
	..s PAdm=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	..s PreIADM=$P(^DHCPEIADM(PAdm),"^",4)
	..s PIBI=$P(^DHCPEPreIADM(PreIADM),"^",1)
	..q:PIBI=""
	..s PatName=$P(^DHCPEPreIBI(PIBI),"^",2)
	..s WaitInfo="'<font color=red>"_PatName_"</font>'您的排队项目已全部完成,如尿便已留,请将指引单交回前台"
	.e  d
	..s Person=$P(WaitInfo,"^",2)
	..s Name=$P(WaitInfo,"^",3)
	..s WaitInfo=$P(WaitInfo,"^",1)
	..i RoomDesc=WaitInfo d
	...s WaitInfo="正检<font color=red>"_Name
	..e  d
	...s WaitInfo="请<font color=red><b>"_Name_"</b></font>到<font color=red><b>"_WaitInfo_"</b></font>处候诊,您是第"_Person_"位"
	..;s WaitInfo="请'<font color=red>"_Name_"</font>'到'<font color=red>"_WaitInfo_"</font>'处候诊"
	..;s WaitInfo="正检<font color=red>"_Name
	/*
	//下一站提示信息
	s ret=ret_"<TR><TD colspan=5><label id='cWaitInfo'>"_WaitInfo_"</label></TD>"
	//当前诊室名称，刷新，关闭，诊室信息调整
	s ret=ret_"<TD width=30%>"
	s:ShowCpmpleteFlag=1 ret=ret_"<button id='"_RoomID_"' onclick='BComplete(this);'>科室确认(F9)</button>"
	;s ret=ret_"<button onclick='CreateRoomRecordList();'>刷新</button>"
	s ret=ret_"<button onclick='Call();'>叫号</button>"
	s ret=ret_"<button onclick='Delay();'>顺延</button>"
	s ret=ret_"<button onclick='Pass();'>过号</button>"
	s ret=ret_"<button id='"_RoomID_"' onclick='RoomInfoModify(this);'>诊室信息</button>"
	s MinFlag=+$G(^DHCPEDataEx("RoomUserEx",RoomID,UserID))
	i MinFlag=1 d  ;已经是最小化
	.s ret=ret_"<button id='"_RoomID_"^0' onclick='DivMainShow(this);'>最大</button>"
	e  d
	.s ret=ret_"<button id='"_RoomID_"^1' onclick='DivMainShow(this);'>最小</button>"
	
	s ret=ret_"</TD>"
	s ret=ret_"</TR></Table>"
	*/
	//下一站提示信息
	s ret=ret_"<TR><TD colspan=5><label id='cWaitInfo'>"_WaitInfo_"</label></TD>"
	//当前诊室名称，刷新，关闭，诊室信息调整
	s ret=ret_"<TD width=75%><table><tr>"
	s:ShowCpmpleteFlag=1 ret=ret_"<td><button id='"_RoomID_"' onclick='BComplete(this);'>科室确认(F9)</button></td>"
	;s ret=ret_"<button onclick='CreateRoomRecordList();'>刷新</button>"
	s ret=ret_"<td><button onclick='Call();'>叫号</button></td>"
	s ret=ret_"<td><button onclick='Delay();'>顺延</button></td>"
	s ret=ret_"<td><button onclick='Pass();'>过号</button></td>"
	s ret=ret_"<td><button id='"_RoomID_"' onclick='RoomInfoModify(this);'>诊室信息</button></td>"
	s MinFlag=+$G(^DHCPEDataEx("RoomUserEx",RoomID,UserID))
	i MinFlag=1 d  ;已经是最小化
	.s ret=ret_"<td><button id='"_RoomID_"^0' onclick='DivMainShow(this);'>最大</button></td>"
	e  d
	.s ret=ret_"<td><button id='"_RoomID_"^1' onclick='DivMainShow(this);'>最小</button></td>"
	
	s ret=ret_"</tr></table></TD>"
	s ret=ret_"</TR></Table>"
	
	//q:MinFlag=1 ret
	s Hidden=""
	s:MinFlag=1 Hidden=" style='display:none;'"
	s ListInfo=..GetRoomPersonInfo(RoomID)
	q:ListInfo="" ret
	s ListRet="<Table id='RoomPresonListTB' width="_TableWidth_Hidden_" border=1>"
	;s ListRet=ListRet_"<TR bgcolor='#C0C0C0' align='center' height=20px><TD width=8%>序号</TD><TD width=15%>ID号</TD><TD width=15%>姓名</TD><TD width=8%>性别</TD><TD width=15%>年龄</TD><TD width=15%>电话</TD><TD>操作</TD></TR>"
	s ListRet=ListRet_"<TR bgcolor='#C0C0C0' align='center' height=20px><TD width=8%>序号</TD><TD width=15%>ID号</TD><TD width=15%>姓名</TD><TD width=15%>年龄</TD><TD>操作</TD></TR>"
	
	s ListLength=$L(ListInfo,$C(1))
	for i=1:1:ListLength
	{
		s OneInfo=$P(ListInfo,$C(1),i)
		s ListRet=ListRet_"<TR height=15px>"
		s RecordID=$P(OneInfo,"^",1)
		s ListRet=ListRet_"<TD>"_..ChangeNull($P(OneInfo,"^",9))_"</TD>"
		s ListRet=ListRet_"<TD>"_..ChangeNull($P(OneInfo,"^",2))_"</TD>"
		s ListRet=ListRet_"<TD id='"_RecordID_"Name'>"_..ChangeNull($P(OneInfo,"^",3))_"</TD>"
		;s ListRet=ListRet_"<TD>"_..ChangeNull($P(OneInfo,"^",4))_"</TD>"
		s ListRet=ListRet_"<TD>"_..ChangeNull($P(OneInfo,"^",5))_"</TD>"
		;s ListRet=ListRet_"<TD>"_..ChangeNull($P(OneInfo,"^",6))_"</TD>"
		s Status=$P(OneInfo,"^",7)
		s ind=$P(OneInfo,"^",9)
		i i=1 d
		.s ListRet=ListRet_"<TD>当前诊室:"_RoomDesc_"</TD>"
		e  d
		.s ListRet=ListRet_"<TD>"_..ChangeNull(..GetDocButton(RecordID,Status,ind))_"</TD>"
		s ListRet=ListRet_"</TR>"
	}
	
	
	s ListRet=ListRet_"</Table>"
	q ret_ListRet
}

// 叫号按钮

ClassMethod GetDocButton(RecordID, Status, ind)
{
	q:RecordID="" ""
	q:(Status="N")&&(ind'=1) ""
	s ButtonRet=""
	if Status="N" d
	.s ButtonRet="<button id='"_RecordID_"' name='StopButton' onclick='CallCurRoom(this);' width=200>叫　 号</button>"
	.s ButtonRet=ButtonRet_"<button id='"_RecordID_"' name='StopButton' onclick='DelayCurRoom(this);' width=200>顺　 延</button>"
	.s ButtonRet=ButtonRet_"<button id='"_RecordID_"' name='StopButton' onclick='PassCurRoom(this);'>过　 号</button>"
	if Status="P" d
	.s ButtonRet="<button id='"_RecordID_"' name='StopButton' onclick='ReStartCurRoom(this);'>过号启用</button>"
	q ButtonRet
}

ClassMethod ChangeNull(Str)
{
	q:Str="" "&nbsp;"
	q Str
}

// 获取叫号队列

ClassMethod GetRoomPersonInfo(RoomID)
{
	;w ##class(web.DHCPE.RoomManagerEx).GetRoomPersonInfo("2||30")
	s ret=""
	s rset = ##class(%ResultSet).%New()
	s rset.ClassName = "web.DHCPE.RoomManager"
	s rset.QueryName = "FindRoomPersonDetail"
	d rset.Execute(RoomID)
	While (rset.Next()) 
     {
	     s OneInfo=""
	     s OneInfo=rset.Data("TRecordID") ;1
	     s OneInfo=OneInfo_"^"_rset.Data("TRegNo") ;2
	     s OneInfo=OneInfo_"^"_rset.Data("TName") ;3
	     s OneInfo=OneInfo_"^"_rset.Data("TSex") ;4
	     s OneInfo=OneInfo_"^"_rset.Data("TAge") ;5
	     ;s ^sxt("tt")=rset.Data("TAge")
	     s OneInfo=OneInfo_"^"_rset.Data("TTel") ;6
	     s OneInfo=OneInfo_"^"_rset.Data("TStatus") ;7
	     s OneInfo=OneInfo_"^"_rset.Data("TPAADM") ;8
	     s OneInfo=OneInfo_"^"_rset.Data("TIND") ;9
	     i ret="" d
	     .s ret=OneInfo
	     e  d
	     .s ret=ret_$C(1)_OneInfo
     }
     q ret
}

// 保存Div的位置

ClassMethod UpdateMinFlag(Str)
{
	;Flag=1 最小化
	s RoomID=$P(Str,"^",1)
	s Flag=$P(Str,"^",2)
	s UserID=%session.Get("LOGON.USERID")
	i Flag'="" d
	.s $P(^DHCPEDataEx("RoomUserEx",RoomID,UserID),"^","1")=Flag
	s $P(^DHCPEDataEx("RoomUserEx",RoomID,UserID),"^","2")=+$P(Str,"^",3)
	s $P(^DHCPEDataEx("RoomUserEx",RoomID,UserID),"^","3")=+$P(Str,"^",4)
	q 0
}

// 得到DIv的位置

ClassMethod GetMinFlag(RoomID)
{
	s UserID=%session.Get("LOGON.USERID")
	s RoomID=$P(RoomID,"$",1)
	q:RoomID="" ""
	s ret=$G(^DHCPEDataEx("RoomUserEx",RoomID,UserID))
	i ret="" q "0^0^0"
	s:$P(ret,"^",2)<0 $P(ret,"^",2)=0
	s:$P(ret,"^",3)<0 $P(ret,"^",3)=0
	q ret
	;q ret
}

ClassMethod GetRecordStatus(RecordID)
{
	s $ZT="RecordStatusErr"
	s Status=$LG(^User.DHCPEAdmRoomRecordD(RecordID),7)
	s DetailStatus=$LG(^User.DHCPEAdmRoomRecordD(RecordID),9)
	q Status_"^"_DetailStatus
RecordStatusErr
	q ""
}

/// 增加多诊室共用一个队列的 IP判断 add by sunxintao 20210801
/// IsCall 是否叫号操作 Y N 是的话需要获取当前IP对应的诊室否则往叫号屏传的信息不对
/// DEBUGGER: ##Class(web.DHCPE.RoomManagerEx).GetNextInfo("2||40","Y")
ClassMethod GetNextInfo(RoomID, ISCall As %String = "N")
{
	;w ##class(web.DHCPE.RoomManagerEx).GetNextInfo("2||29")
	s CallRoom=""
	i ISCall="Y" d
	.s CurIP=##Class(ext.util.String).ClientIP()
	.s CallRoom=$p(##Class(web.DHCPE.RoomManager).GetRoomIDByComputeNew(CurIP),"$",1)
	b
	s ^DHCPERecord("GetNextInfo")=$lb(RoomID, ISCall,CurIP,CallRoom)
	s RoomID=$P(RoomID,"$",1)
	q:RoomID="" ""
	s RetRecordID=""
	s RetAdm=""
	s Sort=""
	f  s Sort=$O(^User.DHCPEAdmRoomRecordI("StatusSortIndex"," N"," "_RoomID,Sort)) q:(Sort="")||(RetRecordID'="")  d
	.s AdmID=""
	.f  s AdmID=$O(^User.DHCPEAdmRoomRecordI("StatusSortIndex"," N"," "_RoomID,Sort,AdmID)) q:(AdmID="")||(RetRecordID'="")  d
	..s RecordID=""
	..f  s RecordID=$O(^User.DHCPEAdmRoomRecordI("StatusSortIndex"," N"," "_RoomID,Sort,AdmID,RecordID)) q:(RecordID="")||(RetRecordID'="")  d
	...s DetailStatus=$LG(^User.DHCPEAdmRoomRecordD(RecordID),9)
	...s CurCallRoom=$LG(^User.DHCPEAdmRoomRecordD(RecordID),15)
	...q:(CallRoom'="")&&(CurCallRoom'=CallRoom)&&(CurCallRoom'="")
	...q:DetailStatus="E"
	...s RetRecordID=RecordID
	...s RetAdm=$P(AdmID," ",2)
	q:RetRecordID="" ""
	s PAPatID=$P(^PAADM(RetAdm),"^",1)
	s PAPatName=$P(^PAPER(PAPatID,"ALL"),"^",1)
	q RetRecordID_"^"_PAPatName
}

ClassMethod GetTotalOverPersonByRoom(RoomID)
{
	//n (RoomID,Status)
	q:RoomID="" ""
	;StatusIndex
	s TotalPerson=0
	s Date=+$H
	s ID=""
	f  s ID=$O(^User.DHCPEAdmRoomRecordI("StatusRoomDateIndex"," O"," "_RoomID,Date,ID)) q:ID=""  d
	.s TotalPerson=TotalPerson+1
	q TotalPerson
}

// 0没有改诊室  1有改诊室

ClassMethod CheckHadRoom(PAADM, RoomID)
{
	;q:##class(web.DHCPE.RoomManagerEx).CheckHadRoom(AdmId,RoomID)=0
	q:$D(^User.DHCPEAdmRefuseRoomI("PAADMStatus",PAADM,"RF",RoomID)) "0"
	s StationID=$LG(^User.DHCPEAreaD(+RoomID,"ChildRoom",$P(RoomID,"||",2)),7)
	q:StationID="" 1
	s Order=$O(^OEORD(0,"Adm",PAADM,0))
	q:Order="" 0
	s ret=0
	s OrderSub=0
	f  s OrderSub=$O(^OEORD(Order,"I",OrderSub)) q:(OrderSub="")||(ret=1)  d
	.s Stat=$P($G(^OEORD(Order,"I",OrderSub,1)),"^",13)
	.q:Stat'="1"
	.s ItemMastID=$P($G(^OEORD(Order,"I",OrderSub,1)),"^",2)
	.s STID=$O(^DHCPEST(0,"STORD_ARCIM",ItemMastID,0))
	.q:STID'=StationID
	.s ret=1
	q ret
}

ClassMethod SaveRoomPlace(ID, Str, ExpStr As %String = "")
{
	//Str  code^desc^viplevel^gori^locid
	i ID="" d
	.s ID=$I(^DHCPECTDataEx("RoomPlace"))
	s CurLoc=%session.Get("LOGON.CTLOCID")
	s ^DHCPECTDataEx("RoomPlace",ID)=Str_"^"_CurLoc_"^"_ExpStr
	q 0
}

ClassMethod GetOneRoomPlace(ID)
{
	q:ID="" "^^^^^"
	q $G(^DHCPECTDataEx("RoomPlace",ID))
}

ClassMethod OutGITypeToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='GIType' id='GIType' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value='N'>不限</option>",!
	w "<option value='I'>个人</option>",!
	w "<option value='G'>团体</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutRoomPlaceToHTML(IDName As %String = "", ContrlWidth As %String = "", DefaultValue As %String = "", tabIndex As %String = 0) As %String
{
	
	s:(""=ContrlWidth) ContrlWidth="155"
	s:IDName="" IDName="RoomPlace"
	i DefaultValue="" s DefaultValue=1
	s CurLoc=%session.Get("LOGON.CTLOCID")
	;w "<select name='"_IDName_"' id='"_IDName_"' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex="_tabIndex_">",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle(IDName,"")
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$o(^DHCPECTDataEx("RoomPlace",id)) q:id=""  d
	.s locid=$p($g(^DHCPECTDataEx("RoomPlace",id)),"^",5)
	.q:locid'=CurLoc
	.s selected=""
	.s:DefaultValue=id selected="selected"
	.s desc=$p($g(^DHCPECTDataEx("RoomPlace",id)),"^",2) ;_"   "_use
	.//i use="Y" d
	.w "<option value='"_id_"' "_selected_">"_desc_"</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutRoomPlaceNewToHTML(IDName As %String = "", ContrlWidth As %String = "", DefaultValue As %String = "", tabIndex As %String = 0) As %String
{
	
	s:(""=ContrlWidth) ContrlWidth="155"
	s:IDName="" IDName="RoomPlace"
	s CurLoc=%session.Get("LOGON.CTLOCID")
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle(IDName,"")
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$o(^DHCPECTDataEx("RoomPlace",id)) q:id=""  d
	.s locid=$p($g(^DHCPECTDataEx("RoomPlace",id)),"^",5)
	.q:locid'=CurLoc
	.s selected=""
	.s:DefaultValue=id selected="selected"
	.s desc=$p($g(^DHCPECTDataEx("RoomPlace",id)),"^",2) ;_"   "_use
	.w "<option value='"_id_"' "_selected_">"_desc_"</option>",!
	w "</select>",!
	Quit $$$OK
}

Query RoomPlace() As %Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TVIPLevelID:%String,TVIPLevelDesc:%String,TGIType:%String,TGITypeDesc:%String,TNoPrintBlood:%String") [ SqlProc ]
{
}

ClassMethod RoomPlaceExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s CurLoc=%session.Get("LOGON.CTLOCID")
 	s ind=1
 	s ID=""
 	f  s ID=$O(^DHCPECTDataEx("RoomPlace",ID)) q:ID=""  d
 	.s TID=ID
 	.s Str=$G(^DHCPECTDataEx("RoomPlace",ID))
 	.s locid=$p(Str,"^",5)
	.q:locid'=CurLoc
 	.s TCode=$P(Str,"^",1)
 	.s TDesc=$P(Str,"^",2)
 	.s TVIPLevelID=$P(Str,"^",3)
 	.s TVIPLevelDesc=""
 	.s:TVIPLevelID'="" TVIPLevelDesc=$P(^DHCPEVIPLevel("VIP",TVIPLevelID),"^",2)
 	.s TGIType=$P(Str,"^",4)
 	.s:TGIType="N" TGITypeDesc="不限"
 	.s:TGIType="I" TGITypeDesc="个人"
 	.s:TGIType="G" TGITypeDesc="团体"
 	.s TNoPrintBlood=$P(Str,"^",6)
 	.
 	.d RoomPlaceBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

RoomPlaceBuild
	set Data=$lb(TID,TCode,TDesc,TVIPLevelID,TVIPLevelDesc,TGIType,TGITypeDesc,TNoPrintBlood)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod RoomPlaceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RoomPlaceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod RoomPlaceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RoomPlaceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/*
ClassMethod GetDefaultRoomPlace(VIPLevel, GIType, CurLoc As %String = "")
{
	s ret=""
	i CurLoc="" s CurLoc=%session.Get("LOGON.CTLOCID")
	s ID=0
	f  s ID=$O(^DHCPECTDataEx("RoomPlace",ID)) q:(ID="")||(ret'="")  d
 	.s Str=$G(^DHCPECTDataEx("RoomPlace",ID))
 	.s locid=$p(Str,"^",5)
	.q:locid'=CurLoc
 	.s TVIPLevelID=$P(Str,"^",3)
 	.q:(VIPLevel'=TVIPLevelID)
 	.s TGIType=$P(Str,"^",4)
 	.q:(TGIType'="N")&&(TGIType'=GIType)
 	.s ret=ID
 	q ret
}
*/
/// Description: 获取默认的诊室位置（多院区）
/// Input: VIPLevel:VIPID, GIType:G/I(团体/个人) , CurLoc:科室ID
/// Return： 默认诊室位置ID
/// debug: d ##class(web.DHCPE.RoomManagerEx).GetDefaultRoomPlace()
ClassMethod GetDefaultRoomPlace(VIPLevel, GIType, CurLoc As %String = "")
{
	s ret=""
	i CurLoc="" s CurLoc=%session.Get("LOGON.CTLOCID")
	
	s ID=0
	f  s ID=$o(^CF.PE.RoomPlaceD(ID)) q:ID=""  d
    .;s desc=$lg(^CF.PE.RoomPlaceD(ID),3)
    .s locid=$lg(^CF.PE.RoomPlaceD(ID),7)
    .q:(locid'=CurLoc)&&(CurLoc'="")
    .s Active=$lg(^CF.PE.RoomPlaceD(ID),8)
    .q:Active'="Y"
    .s TVIPLevelID=$lg(^CF.PE.RoomPlaceD(ID),4)
    .q:(VIPLevel'="")&&(VIPLevel'=TVIPLevelID)
    .s TGIType=$lg(^CF.PE.RoomPlaceD(ID),5)
 	.q:(TGIType'="N")&&(TGIType'=GIType)
 	.s ret=ID
 	q ret
}

ClassMethod IsExistRoomPlace(Code As %String = "", Desc As %String = "", CurLoc As %String = "")
{
	s DFlag=0,CFlag=0
	s ID=0
	f  s ID=$O(^DHCPECTDataEx("RoomPlace",ID)) q:((ID="")||(CFlag=1)||(DFlag=1))  d
	.s locid=$p($g(^DHCPECTDataEx("RoomPlace",ID)),"^",5)
	.q:locid'=CurLoc
	.s RCode=$p($g(^DHCPECTDataEx("RoomPlace",ID)),"^",1)
	.s RDesc=$p($g(^DHCPECTDataEx("RoomPlace",ID)),"^",2)
	.i RCode=Code S CFlag=1
	.i RDesc=Desc S DFlag=1
	q DFlag_"^"_CFlag
}

Storage Default
{
<Data name="RoomManagerExDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.RoomManagerExD</DataLocation>
<DefaultData>RoomManagerExDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.RoomManagerExD</IdLocation>
<IndexLocation>^web.DHCPE.RoomManagerExI</IndexLocation>
<StreamLocation>^web.DHCPE.RoomManagerExS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

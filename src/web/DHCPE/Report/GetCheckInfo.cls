Class web.DHCPE.Report.GetCheckInfo Extends %Persistent
{

ClassMethod ListOrdStatusExecute(ByRef qHandle As %Binary) As %Status
{
      // n (Ward,RegNo)
    Set repid=$I(^CacheTemp)
	s ind=1
	s ArcimDesc=$g(ArcimDesc)
	s ArcimDesc=$ZCVT(ArcimDesc,"U")
	s OrdStatusDesc="所有状态"
	s OrdStatusCode=""
	s id=""
	d OutPat
 	s id="0" 
 		
	f  s id=$O(^OEC("OSTAT",id)) q:id=""  d
	.s OrdStatusDesc=$p(^OEC("OSTAT",id),"^",2)
	.s OrdStatusCode=$p(^OEC("OSTAT",id),"^",1)
	.b //1
	.q:(OrdStatusCode'="E")&&(OrdStatusCode'="V") //s ^zl("2010",1)=CurData
	.d OutPat
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutPat
    set Data=$lb(OrdStatusDesc,OrdStatusCode,id)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
 /////////////////////////////////////////////////////////////////////
}

ClassMethod ListOrdStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListOrdStatusExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod ListOrdStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListOrdStatusExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query ListOrdStatus() As %Query(ROWSPEC = "OrdStatusDesc:%String:描述,OrdStatusCode:%String:编码,id:%String:ID")
{
}

ClassMethod ListItemExecute(ByRef qHandle As %Binary, StationID As %String, ArcimDesc As %String = "") As %Status
{
      // n (Ward,RegNo)
          Set repid=$I(^CacheTemp)
          
          i ""=StationID {	
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ind=1
	s iARCIMDesc="所有项目"
	s iARCIMDR=""
	d OutPat
	s ArcimDesc=$g(ArcimDesc)
	s ArcimDesc=$ZCVT(ArcimDesc,"U")
	
 	s id="0" 	
	f  s id=$O(^DHCPEST(StationID,"O",id)) q:id=""  d
	.s CurData=$g(^DHCPEST(StationID,"O",id))
	.//s ^zl("2010",1)=CurData
	.s iParRef=StationID
	.s iChildsub=id
	.s iRowId=iParRef_"||"_id
	.s flag=0
	.s:ArcimDesc="" flag=1
	.// 医嘱编码 医嘱名称
	.s iARCIMDR=$p(CurData,"^",1)
	.//s ^zl("2010",2)=iARCIMDR
	.Q:(""=iARCIMDR)
	.s iARCIMDesc=$p($G(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1)),"^",2)
    .s:(iARCIMDesc[ArcimDesc) flag=1
    .s AliasId=""
    .f  s AliasId=$o(^ARC("ALIAS",0,"ARCIM",iARCIMDR,AliasId)) q:(AliasId="")  d
     ..s EffDate=$p(^ARC("ALIAS",AliasId),"^",13)
	..i EffDate="" s EffDate=+$h+1
	..q:EffDate<+$h
	..s Alia=$p(^ARC("ALIAS",AliasId),"^",6)
	..s Alia=$ZCVT(Alia,"U")
	..s:(Alia[ArcimDesc) flag=1
	.q:(flag=0)
	.d OutPat
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutPat
    set Data=$lb(iARCIMDesc,iARCIMDR)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
 /////////////////////////////////////////////////////////////////////
}

ClassMethod ListItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListItemExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod ListItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListItemExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query ListItem(StationID As %String, ArcimDesc As %String = "") As %Query(ROWSPEC = "ArcimDesc:%String:项目名称,ArcimDR:%String:项目ID")
{
}

ClassMethod GetCheckStatus2(PAADM, StationID, AddItem)
{
		s LocID=$P($G(^PAADM(PAADM)),"^",4)
	//s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab",LocID))

	s ExeFlag=0
	s NoExeFlag=0
	s RefFlag=0
	s ret="",AddItems="",OrdEntDR=""
	s Order=$O(^OEORD(0,"Adm",PAADM,0))
	q:Order="" ret
	s ItemSub=""
	f  s ItemSub=$O(^OEORD(Order,"I",ItemSub)) q:ItemSub=""  d
	.s Stat=$p($G(^OEORD(Order,"I",ItemSub,1)),"^",13)
	.q:Stat="4"
	.s ArcimID=$p($G(^OEORD(Order,"I",ItemSub,1)),"^",2)
	.q:ArcimID=""
	.s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
	.q:STID'=StationID
	.s OEORIRowId=Order_"||"_ItemSub
	.s CRMOId=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,0))   //Modified by MLH
	.q:CRMOId=""
	.s CRMOrI=$p(^DHCPECRMO(CRMOId),"^",2)
	.q:CRMOrI=""
	.;w OEORIRowId_"@@@"
	.s:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) RefFlag=1
	.q:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId))
	.s:(1=AddItem)&&(OrdEntDR="") NoExeFlag=1
	.s:(0=AddItem)&&(OrdEntDR'="") NoExeFlag=1
	q NoExeFlag
}

ClassMethod GetCheckStatus(PAADM, StationID, AddItem, SelectArcimDR, OrdStatusDR)
{
	;w ##class(web.DHCPE.Report.GetCheckInfo).GetCheckStatus(4277415,21,"","","")
	s LocID=$P($G(^PAADM(PAADM)),"^",4)
	//s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab",LocID))

	s selectFlag=0
	s SelectArcimDR=$G(SelectArcimDR)
	s OrdStatusDR=$G(OrdStatusDR)
	s:(SelectArcimDR="") selectFlag=1
	s OrderFlag=0
	s ExeFlag=0
	s NoExeFlag=0
	s RefFlag=0
	s ret="",AddItems="",OrdEntDR=""
	s Order=$O(^OEORD(0,"Adm",PAADM,0))
	q:Order="" ret
	s ItemSub=""
	f  s ItemSub=$O(^OEORD(Order,"I",ItemSub)) q:ItemSub=""  d
	.s Stat=$p($G(^OEORD(Order,"I",ItemSub,1)),"^",13)
	.q:Stat="4"
	.q:((OrdStatusDR'="")&&(Stat'=OrdStatusDR))
	.s ArcimID=$p($G(^OEORD(Order,"I",ItemSub,1)),"^",2)
	.q:ArcimID=""
	.s:(SelectArcimDR'="")&&(SelectArcimDR=ArcimID) selectFlag=1
	.s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
	.q:(STID'=StationID)&(StationID'="")
	.s OrderFlag=1
	.s OEORIRowId=Order_"||"_ItemSub
	.;w OEORIRowId_"@@@"
	.s CRMOId=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,0))   //Modified by MLH
	.q:CRMOId=""
	.s CRMOrI=$p(^DHCPECRMO(CRMOId),"^",2)
	.q:CRMOrI=""
	.s Admid=$p(CRMOrI,"||",1)
	.s sub=$p(CRMOrI,"||",2)
	.s OrdEntDR=$p($g(^DHCPEPreIADM(Admid,"ORDITEM",sub)),"^",2)
	.q:(1=AddItem)&&(OrdEntDR'="")
	.q:(0=AddItem)&&(OrdEntDR="")
	.s:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) RefFlag=1
	.q:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId))
	.i LabStation=StationID d
	..s SpecNo=$p($G(^OEORD(Order,"I",ItemSub,3)),"^",20)
	..q:SpecNo=""
	..s SpecimenType=##class(web.DHCPE.BarPrint).GetSpecName(OEORIRowId)
	..q:(SpecimenType'[("血"))
	..i $D(^DHCPETempLabEpisodeScan(SpecNo)) d
	...s ExeFlag=1
	..e  d
	...s NoExeFlag=1
	.e  d
	..i Stat=6 d
	...s ExeFlag=1
	..e  d
	...s NoExeFlag=1
	s obj=##class(User.PAAdm).%OpenId(PAADM)
	//if obj.PAADMPAPMIDR.PAPMINo="18106980" w PAADM_","_StationID_","_AddItem_","_SelectArcimDR_","_OrdStatusDR
	q:OrderFlag=0 ""
	q:(selectFlag=0) ""
	q:(NoExeFlag=1)&&(ExeFlag=1) 2
	q:(NoExeFlag=0)&&(ExeFlag=0)&&(RefFlag=1) 0
	q:(NoExeFlag=0)&&(ExeFlag=1) 3
	q:(NoExeFlag=1)&&(ExeFlag=0) 1
	q ret
}

Query CheckInfo(BeginDate As %String = "", EndDate As %String = "", StationID As %String = "", RoomID As %String = "", ChcekStatus As %String = "", VIPLevel As %String = "", SexDR As %String = "", AuditStatus As %String = "", AddItem As %String = "", AdmStr As %String = "", ArcimDR As %String = "", OrdStatusDR As %String = "") As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TSex:%String,TBirth:%String,TTel:%String,TGroupDesc:%String,TCurRoom:%String,TVIPLevel:%String,TCheckStatus:%String,TAuditStatus:%String,ind:%String,TAge:%String,TPAADM:%String,TItemName:%String")
{
}

ClassMethod CheckInfoExecute(ByRef qHandle As %Binary, BeginDate As %String = "", EndDate As %String = "", StationID As %String = "", RoomID As %String = "", ChcekStatus As %String = "", VIPLevel As %String = "", SexDR As %String = "", AuditStatus As %String = "", AddItem As %String = "", AdmStr As %String = "", ArcimDR As %String = "", OrdStatusDR As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Job=$J
 	k ^TempDHCPECheckInfo(Job)
 	k ^TempDHCPECheckInfoSex(Job)
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
 	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	i BeginDate="" s BeginDate=1
 	i EndDate="" s EndDate=$H

 	//s ^tempdhcpe("1019","param")=BeginDate_"^"_EndDate_"^"_StationID_"^"_RoomID_"^"_ChcekStatus_"^"_VIPLevel_"^"_AuditStatus_"^"_AddItem _"^"_AdmStr
 	i AdmStr'=""
 	{
	 	s Date=+$H
	 	s AdmLength=$L(AdmStr,"^")
	 	s RoomID=$P(AdmStr,"^",1)
	 	s RoomID=$P(RoomID,"$",1)
	 	s StationID=$LG(^User.DHCPEAreaD(+RoomID,"ChildRoom",$P(RoomID,"||",2)),7)
		f i=2:1:AdmLength d
		.s OneAdmStr = $P(AdmStr,"^",i)
		.q:OneAdmStr=""
		.i StationID="" d
		..s (CheckFlag,AudtiFlag)=""
		.e  d
		..s CheckFlag=..GetCheckStatus(OneAdmStr,StationID,AddItem)
		..s SSID=##class(web.DHCPE.ResultEdit).GetSSId(OneAdmStr,StationID)
    	..i SSID'="" d
    	...s Status=$P(^DHCPESS(SSID,1),"^",7)
		...i Status="NA" d
		....s AudtiFlag=1
		...e  d
		....s AudtiFlag=2
		..e  d
		...s AudtiFlag=1
		.s ^TempDHCPECheckInfo(Job,Date,OneAdmStr)=CheckFlag_"^"_AudtiFlag
 	}
 	else{
 	i (StationID="")&(BeginDate="")&(EndDate=""){
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	//i BeginDate="" s BeginDate=1
 	//i EndDate="" s EndDate=$H
 	s Date=BeginDate-1
 	;f  s Date=$O(^User.DHCPECurDateAdmInfoI("DateAdmIndex",Date)) q:(Date="")||(Date>EndDate)  d
 	;.s PAADM=""
	;.f  s PAADM=$O(^User.DHCPECurDateAdmInfoI("DateAdmIndex",Date,PAADM)) q:PAADM=""  d
	
	f  s Date=$O(^DHCPEIADM(0,"AdmDateTime",Date)) q:(Date="")||(Date>EndDate)  d
	.s Time=""
	.f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
	..s IADM=""
	..f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM)) q:(IADM="")  d
	...s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	...;s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	...;q:IADM=""
	...s PreAdm=$P(^DHCPEIADM(IADM),"^",4)
	...s Status=$P(^DHCPEIADM(IADM),"^",8)
	...q:Status'="ARRIVED"
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)         //Add by 090702
    ...q:LocFlag=1
    ...s CheckFlag=..GetCheckStatus(PAADM,StationID,AddItem,ArcimDR,OrdStatusDR)
    ...;s ItemFlag=0
    ...;s ItemFlag=..GetCheckStatus2(PAADM,StationID,AddItem)
    ...;q:ItemFlag 
    ...
    ...q:CheckFlag=""
    ...q:(ChcekStatus'="")&&(ChcekStatus'=CheckFlag)
    ...s SSID=##class(web.DHCPE.ResultEdit).GetSSId(PAADM,StationID)
    ...i SSID'="" d
    ....s Status=$P(^DHCPESS(SSID,1),"^",7)
	....i Status="NA" d
	.....s AudtiFlag=1
	....e  d
	.....s AudtiFlag=2
	...e  d
	....s AudtiFlag=1
	...q:(AuditStatus'="")&&(AuditStatus'=AudtiFlag)
	...s ^TempDHCPECheckInfo(Job,Date,PAADM)=CheckFlag_"^"_AudtiFlag
 	}
	S Sex=""
	s:SexDR'="" Sex=$P(^CT("SEX",SexDR),"^",2)

	s Date=""
	f  s Date=$O(^TempDHCPECheckInfo(Job,Date)) q:Date=""  d
	.s PAADM=""
	.f  s PAADM=$O(^TempDHCPECheckInfo(Job,Date,PAADM)) q:PAADM=""  d
	..d ClearInfo
	..S TPAADM=PAADM
	..s CurVIP=##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",PAADM)
	..q:(VIPLevel'="")&&(+CurVIP'=VIPLevel)
	..s TVIPLevel=$P(CurVIP,"^",2)
	..;s obj=##class(User.PAAdm).%OpenId(PAADM)
	..s BaseInfo=##class(web.DHCPE.AdmRecordManager).GetBaseInfo(PAADM)
	..;PatName_"^"_Sex_"^"_Birth_"^"_IDCard_"^"_RegNo_"^"_Tel_"^"_Group
	..s TRegNo=$P(BaseInfo,"^",5)
	..s TName=$P(BaseInfo,"^",1)
	..s TSex=$P(BaseInfo,"^",2)
	..q:(Sex'="")&&(Sex'=TSex)
	..s TBirth=$P(BaseInfo,"^",3)
	..;s TAge=##class(websys.Conversions).DateHtmlToLogical(TBirth)
	..;i TAge'="" s TAge=$P(##class(web.DHCLCNUREXCUTE).CalAge(TAge,+$H),"Y",1)
	.. s TAge=##class(web.DHCBillInterface).GetPapmiAge($P(BaseInfo,"^",8))
	..;s:TBirth'="" TBirth=$ZD(TBirth,3)
	..s TTel=$P(BaseInfo,"^",6) //$P(^PAPER(PapmiId,"PER",4),"^",21)
	..s CurRoomInfo=##class(web.DHCPE.RoomManager).GetAdmCurRoom(PAADM,"ADM","Desc")
	..s Person=$P(CurRoomInfo,"^",2)
	..s Name=$P(CurRoomInfo,"^",3)
	..s CurRoomInfo=$P(CurRoomInfo,"^",1)
	..s:CurRoomInfo'="" CurRoomInfo=CurRoomInfo_"("_Person_")"
	..s TCurRoom=CurRoomInfo
	..s Info=$G(^TempDHCPECheckInfo(Job,Date,PAADM))
	..s TCheckStatus=$P(Info,"^",1)
	..s:TCheckStatus="0" TCheckStatus="谢绝检查"
	..s:TCheckStatus="1" TCheckStatus="未检"
	..s:TCheckStatus="2" TCheckStatus="部分已检"
	..s:TCheckStatus="3" TCheckStatus="全部已检"
	..s TAuditStatus=$P(Info,"^",2)
	..s:TAuditStatus="1" TAuditStatus="未提交"
	..s:TAuditStatus="2" TAuditStatus="已提交"
 	..s HIADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	..s PIADM=$P(^DHCPEIADM(HIADM),"^",4)
	..s GIADM=$P(^DHCPEPreIADM(PIADM),"^",2)
	..i GIADM'="" d
	...s GBID=$P(^DHCPEPreGADM(GIADM),"^",1)
	...s TGroupDesc=$P(^DHCPEPreGBI(GBID),"^",2)
	..e  d
	...s TGroupDesc=""
 	..s ^TempDHCPECheckInfoSex(Job,TSex)=+($G(^TempDHCPECheckInfoSex(Job,TSex)))+1
 	..s Sub=0,Items=""
 	..f  s Sub=$o(^DHCPEPreIADM(PIADM,"ORDITEM",Sub)) q:(Sub="")  d
 	...s CurData=$g(^DHCPEPreIADM(PIADM,"ORDITEM",Sub))
 	...s ItemStat=$p(CurData,"^",16)
 	...q:ItemStat'="1"
 	...s Itemmast=$p(CurData,"^",1)
 	...s Item=""
 	...s Item=$p(^ARCIM($p(Itemmast,"||"),$p(Itemmast,"||",2),1),"^",2)
 	...
 	...s:($p(CurData,"^",2)="") Items=Items_Item_" "
 	..d FindBuild
	s SexDesc="",num=0
	f  s SexDesc=$O(^TempDHCPECheckInfoSex(Job,SexDesc)) q:SexDesc=""  d
	.d ClearInfo
	.s Items=""
	.i num="0" s TRegNo="合计:"
	.e  s TRegNo=""
	.s num=num+1
	.s TSex=SexDesc_" "_$G(^TempDHCPECheckInfoSex(Job,SexDesc))_" 人"
	.d FindBuild
	k ^TempDHCPECheckInfo(Job)
	k ^TempDHCPECheckInfoSex(Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ClearInfo
	s (TRegNo,TName,TSex,TBirth,TTel,TGroupDesc,TCurRoom,TVIPLevel,TCheckStatus,TAuditStatus,TAge,TPAADM)=""	
	q
FindBuild
	;TRegNo:%String,TName:%String,TSex:%String,TBirth:%String,TTel:%String,TGroupDesc:%String,TCurRoom:%String,TVIPLevel:%String   
	set Data=$lb(TRegNo,TName,TSex,TBirth,TTel,TGroupDesc,TCurRoom,TVIPLevel,TCheckStatus,TAuditStatus,ind,TAge,TPAADM,Items)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CheckInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				// fetch row
 	Set Row=^CacheTemp(repid,ind)
 	}
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

ClassMethod CheckInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

Query RoomInfoByStation(StationID As %String = "") As %SQLQuery(ROWSPEC = "ID:%String:ID,Code:%String:编码,Desc:%String:名称")
{
	select ID,R_Code,R_desc 
	from Sqluser.DHC_PE_Room
	where R_Station_DR=:StationID
}

ClassMethod OutAddItem(ContrlWidth As %String = "", DefaultValue As %String = "")
{
	;d ##class(web.DHCPE.Report.GetCheckInfo).OutCheckStatus("",1)
	s:(""=ContrlWidth) ContrlWidth="155"
	w "<select name='AddItem' id='AddItem' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w "<option value=''></option>",!
	s selected=""
	s:DefaultValue="0" selected="selected"
	w "<option value='0' "_selected_">预约</option>",!
	s selected=""
	s:DefaultValue="1" selected="selected"
	w "<option value='1' "_selected_">加项</option>",!
	s selected=""
	
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutCheckStatus(ContrlWidth As %String = "", DefaultValue As %String = "")
{
	;d ##class(web.DHCPE.Report.GetCheckInfo).OutCheckStatus("",1)
	s:(""=ContrlWidth) ContrlWidth="155"
	w "<select name='ChcekStatus' id='ChcekStatus' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w "<option value=''></option>",!
	s selected=""
	s:DefaultValue="0" selected="selected"
	w "<option value='0' "_selected_">谢绝检查</option>",!
	s selected=""
	s:DefaultValue="1" selected="selected"
	w "<option value='1' "_selected_">未检</option>",!
	s selected=""
	s:DefaultValue="2" selected="selected"
	w "<option value='2' "_selected_">本科室部分已检</option>",!
	s selected=""
	s:DefaultValue="3" selected="selected"
	w "<option value='3' "_selected_">本科室全部已检</option>",!
	
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutAuditStatus(ContrlWidth As %String = "", DefaultValue As %String = "")
{
	;d ##class(web.DHCPE.Report.GetCheckInfo).OutCheckStatus("",1)
	s:(""=ContrlWidth) ContrlWidth="155"
	w "<select name='AuditStatus' id='AuditStatus' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w "<option value=''></option>",!
	s selected=""
	s:DefaultValue="1" selected="selected"
	w "<option value='1' "_selected_">未提交</option>",!
	s selected=""
	s:DefaultValue="2" selected="selected"
	w "<option value='2' "_selected_">已提交</option>",!
	w "</select>",!
	Quit $$$OK
}

// 得到当天到达人数、未检人数、已检人数

ClassMethod GetCheckInfo(RoomID, UserID)
{
	;w ##class(web.DHCPE.Report.GetCheckInfo).GetCheckInfo("1||23$Y","5918")
	;q:RoomID="" ""
	//s UserID=session.Get("LOGON.USERID")
	s RoomID=$P(RoomID,"$",1)
	q:RoomID="" ""
	s StationID=$LG(^User.DHCPEAreaD(+RoomID,"ChildRoom",$P(RoomID,"||",2)),7)
	s CurVIPLevel=$LG(^User.DHCPEAreaD(+RoomID),5)
	s Date=+$H
	s TotalPerson=0
	s HadCheckPerson=0
	s NoCheckPerson=0
	s RefusePerson=0
	s NoCheckStr=""
	s HadCheckStr=""
	s RefuseCheckStr=""
	s PAADM=""
	f  s PAADM=$O(^User.DHCPECurDateAdmInfoI("DateAdmIndex",Date,PAADM)) q:PAADM=""  d
	.s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	.q:IADM=""
	.s PreAdm=$P(^DHCPEIADM(IADM),"^",4)
	.s Status=$P(^DHCPEIADM(IADM),"^",8)
	.q:Status'="ARRIVED"
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)         //Add by 090702
    .q:LocFlag=1 
	.s VIPLevel=##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PreAdm)
	.s VIPLevel=$P(VIPLevel,"^",1)
	.q:(CurVIPLevel'="")&&(CurVIPLevel'=VIPLevel)
	.s PAPMIID=$P(^PAADM(PAADM),"^",1)
	.s Sex=$P(^PAPER(PAPMIID,"ALL"),"^",7)
	.s SexCode="N"
	.s:Sex'="" SexCode=$P(^CT("SEX",Sex),"^",1)
	.b ;PAADM
	.s LocID=$P($G(^PAADM(PAADM)),"^",4)
	.s TotalPerson=TotalPerson+1
	.q:RoomID=""
	.i StationID'="" d
	..b ;StationID,!
	..s AreaID=""
	..f  s AreaID=$O(^User.DHCPERoomI("RStationIndex",StationID,AreaID)) q:AreaID=""  d
	...b ;AreaID
	...s RoomSub=""
	...f  s RoomSub=$O(^User.DHCPERoomI("RStationIndex",StationID,AreaID,RoomSub)) q:RoomSub=""  d
	....b ;RoomSub
	....s CurRoomID=AreaID_"||"_RoomSub
	....i $O(^User.DHCPEAdmRoomRecordI("RoomUserIndex",Date," "_CurRoomID,PAADM,""))>0 d
	.....s HadCheckPerson=HadCheckPerson+1
	.....s HadCheckStr=HadCheckStr_"^"_PAADM
	....i $D(^User.DHCPEAdmRefuseRoomI("PAADMStatus",PAADM,"RF",CurRoomID)) d
	.....s RefusePerson=RefusePerson+1
	.....s RefuseCheckStr=RefuseCheckStr_"^"_PAADM
	.e  d
	..i $D(^User.DHCPEAdmRoomRecordI("UserRoomIndex",Date,UserID," "_RoomID," "_PAADM)) d
	...s HadCheckPerson=HadCheckPerson+1
	...s HadCheckStr=HadCheckStrr_"^"_PAADM
	...b ;HadCheck
	.s StationID=$LG(^User.DHCPEAreaD(+RoomID,"ChildRoom",$P(RoomID,"||",2)),7)
	.s Diet=$LG(^User.DHCPEAreaD(+RoomID,"ChildRoom",$P(RoomID,"||",2)),4)
	.s Sex=$LG(^User.DHCPEAreaD(+RoomID,"ChildRoom",$P(RoomID,"||",2)),5)
	.q:(Sex'="N")&&(Sex'=SexCode)
	.i StationID=""  d
	..q:$D(^User.DHCPEAdmRoomRecordI("UserRoomIndex",Date,UserID," "_RoomID," "_PAADM))
	..s NoCheckPerson=NoCheckPerson+1
	..s NoCheckStr=NoCheckStr_"^"_PAADM
	.e  d
	..q:$D(^User.DHCPEAdmRoomRecordI("StatusIndex"," O"," "_RoomID," "_PAADM))
	..s SpecStr=""
	..;i StationID=$G(^DHCPESetting("DHCPE","StationId_Lab")) d
	..i StationID=$G(^DHCPESetting("DHCPE","StationId_Lab",LocID)) d
	...s SpecStr=##class(web.DHCPE.RoomManager).GetAllSpec(RoomID)
	...s SpecStr="^"_SpecStr_"^"
	..b ;SpecStr
	..s Flag=0
	..s OrdSub=0
	..f  s OrdSub=$O(^DHCPEPreIADM(PreAdm,"ORDITEM",OrdSub)) q:(OrdSub="")||(Flag=1)  d
	...s DietFlag=$P($G(^DHCPEPreIADM(PreAdm,"ORDITEM",OrdSub)),"^",2)
	...s Stat=$P($G(^DHCPEPreIADM(PreAdm,"ORDITEM",OrdSub)),"^",16)
	...q:Stat'="1"
	...s CrmOrderID=$O(^DHCPECRMO(0,"CRMORI",PreAdm_"||"_OrdSub,0))
	...q:CrmOrderID=""
	...s OrdItemID=$P(^DHCPECRMO(CrmOrderID),"^",1)
	...s Stat=$P(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1),"^",13)
	...q:Stat="6" ;执行的退出
	...q:(Stat="1")&&$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrdItemID)) ;谢绝检查的退出
	...s ItemMastID=$P(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1),"^",2)
	...q:ItemMastID=""   ;20140108
	...s STID=$O(^DHCPEST(0,"STORD_ARCIM",ItemMastID,0))
	...q:STID'=StationID
	...;q:(Diet'="N")&&(DietFlag'=Diet)
	...;i StationID=$G(^DHCPESetting("DHCPE","StationId_Lab")) d
	...i StationID=$G(^DHCPESetting("DHCPE","StationId_Lab",LocID)) d
	....s SpecNo=$p($G(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),3)),"^",20)
	....q:SpecNo=""
	....q:$D(^DHCPETempLabEpisodeScan(SpecNo))   //已经抽血确认的退出
	....b ;SpecNo2
	....s CurSpec=$G(^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",PreAdm_"||"_OrdSub))
	....s CurSpec=$P(CurSpec,"^",1)
	....s:SpecStr[("^"_CurSpec_"^") Flag=1
	...e  d
	....s Flag=1
	..q:Flag=0
	..s NoCheckPerson=NoCheckPerson+1
	..s NoCheckStr=NoCheckStr_"^"_PAADM
	q TotalPerson_"^"_HadCheckPerson_"^"_NoCheckPerson_"^"_RefusePerson_"$"_HadCheckStr_"$"_NoCheckStr_"$"_RefuseCheckStr
}

Storage Default
{
<Data name="GetCheckInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.Report.GetCheckInfoD</DataLocation>
<DefaultData>GetCheckInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.Report.GetCheckInfoD</IdLocation>
<IndexLocation>^web.DHCPE.Report.GetCheckInfoI</IndexLocation>
<StreamLocation>^web.DHCPE.Report.GetCheckInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

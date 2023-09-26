Class web.DHCDocTransfer Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod FindCurrenAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurrenAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCurrenAdmExecute(ByRef qHandle As %Binary, Papmino As %String, LocID As %String, UserID As %String) As %Status
{
	s ^RP("Papmino")=Papmino
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	If LocID="" Set LocID=%session.Get("LOGON.CTLOCID")
	If UserID="" Set UserID=%session.Get("LOGON.USERID")
	If LocID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	If UserID="" Set qHandle=$lb(0,repid,0) Quit $$$OK	
	s CareId=..GetCareDrByUserID(UserID)
	i CareId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	//s UserID="1335"
	//s LocID="152"
	s AdmType=""
	s IsEmergency=##class(web.DHCOPAdmReg).IsEmergency(LocID)
	if IsEmergency="1" s AdmType="E"
	if (AdmType'="E"){
	s rset=##class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
	do rset.Execute(LocID,UserID,"","",Papmino,"",+$H,+$H,"","on")
	while (rset.Next()) {
		s SeqNo=rset.GetData(28)
		s RegNo=rset.GetData(4)
		s AdmID=rset.GetData(2)
		s PatName=rset.GetData(5)
		s PatSex=rset.GetData(7)
		s PatAge=rset.GetData(35)
		s RegDoctor=rset.GetData(22)
		s TimeRange=rset.GetData(41)
		s PAAdmReason=rset.GetData(20)
		s PAAdmDep=rset.GetData(11)
		s PAAdmType=rset.GetData(13)
		s TPoliticalLevel=rset.GetData(39)
		s TSecretLevel=rset.GetData(40)
		//s WalkStatus=rset.GetDataByName("WalkStatus")
		//continue:WalkStatus'="等候"
		continue:AdmID=""
		d OutputRow3
	}
	}
	else{
	s rset=##class(%ResultSet).%New("web.DHCDocEmergencyPatientList:FindLocDocCurrentAdm")
	do rset.Execute(LocID,UserID,"","",Papmino,"","","","","")
	while (rset.Next()) {
		s SeqNo=rset.GetData(28)
		s RegNo=rset.GetData(4)
		s AdmID=rset.GetData(2)
		s PatName=rset.GetData(5)
		s PatSex=rset.GetData(7)
		s PatAge=rset.GetData(35)
		s RegDoctor=rset.GetData(22)
		s TimeRange=rset.GetData(41)
		s PAAdmReason=rset.GetData(20)
		s PAAdmDep=rset.GetData(11)
		s PAAdmType=rset.GetData(13)
		s TPoliticalLevel=rset.GetData(39)
		s TSecretLevel=rset.GetData(40)
		//s WalkStatus=rset.GetDataByName("WalkStatus")
		//continue:WalkStatus'="等候"
		continue:AdmID=""
		d OutputRow3
	}
		
		}
	d rset.Close()
	d rset.Close()
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(SeqNo,RegNo,AdmID,PatName,PatSex,PatAge,RegDoctor,TimeRange,PAAdmReason,PAAdmDep,PAAdmType,TPoliticalLevel,TSecretLevel)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindCurrenAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurrenAdmExecute ]
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

ClassMethod GetAllPatientCount() As %String
{
	s NowDate=..%SysDate()
	s UserID=%session.Get("LOGON.USERID")
	s DocId=$P($G(^SSU("SSUSR",UserID)),"^",14)
	q:DocId="" ""
 &SQL(select count(*) into :AllCount from SQLUSER.DHCQueue where QueMarkDr=:DocId and QueStateDr<>5 and QueDate=:NowDate)
 q AllCount
}

ClassMethod GetCareDrByUserID(UserID As %String) As %String
{
	q:UserID="" ""
	s CareId=$P($G(^SSU("SSUSR",UserID)),"^",14)
	q CareId
}

ClassMethod GetDocStr(DepRowId As %String, EpisodeID As %String = "") As %String
{
	;w ##class(web.DHCDocTransfer).GetDocStr(152)
	s rset=##class(%ResultSet).%New("web.DHCDocTransfer:OPDocList")
	s ret=""
	do rset.Execute(DepRowId,EpisodeID)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_"$c(2)"_rset.GetData(2)
		e  s ret=ret_"$c(1)"_rset.GetData(1)_"$c(2)"_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

ClassMethod GetOPDeptStr(AdmType As %String = "", HospId As %String) As %String
{
	;w ##class(web.DHCDocTransfer).GetOPDeptStr("O")
	s rset=##class(%ResultSet).%New("web.DHCDocTransfer:OPDeptList")
	s ret=""
	s ParaAdmType=AdmType
	i AdmType=""  s AdmType="O"
	do rset.Execute(AdmType,HospId)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
		e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
	}
	d rset.Close()
	i ParaAdmType=""  {
		s AdmType="E"
		do rset.Execute(AdmType,HospId)
		while (rset.Next()) {
			i ret=""  s ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
			e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
		}
		d rset.Close()
	}
		
	
	q ret
}

ClassMethod GetQueueCount() As %String
{
	s NowDate=..%SysDate()
	s UserID=%session.Get("LOGON.USERID")
	s DocId=$P($G(^SSU("SSUSR",UserID)),"^",14)
	q:DocId="" ""
 &SQL(select count(*) into :QueueCount from SQLUSER.DHCQueue where QueMarkDr=:DocId and QueStateDr=2 and QueDate=:NowDate)
 q QueueCount
}

ClassMethod GetSessionRoomByCareID(DepRowId As %String, CareID As %String) As %String
{
	;w ##class(web.DHCDocTransfer).GetSessionRoomByCareID(152,2)
	q:(DepRowId="")!(CareID="") ""
	s NowDowDr=$ZD(+$H,10)
	s SessionRoom=""
	s ResRowId=""
	f  s ResRowId=$o(^RB("RES",0,"CTLOC",DepRowId,ResRowId)) q:ResRowId=""  d
	.s DocId=$p($G(^RB("RES",ResRowId)),"^",2)
	.q:DocId'=CareID
	.s DateChidDr=""
	.s DateChidDr=$O(^RB("RES",ResRowId,"DATE",DateChidDr),-1)
	.q:DateChidDr=""
	.s SessionDr=""
	.f  s SessionDr=$O(^RB("RES",ResRowId,"DATE",DateChidDr,"SESS",SessionDr)) q:SessionDr=""  d
	..s DowDr=$P($G(^RB("RES",ResRowId,"DATE",DateChidDr,"SESS",SessionDr)),"^",2)
	..;q:DowDr'=NowDowDr
	..s StartTime=$P($G(^RB("RES",ResRowId,"DATE",DateChidDr,"SESS",SessionDr)),"^",4)
	..s EndTime=$P($G(^RB("RES",ResRowId,"DATE",DateChidDr,"SESS",SessionDr)),"^",5)
	..s NowTime=..%SysTime()
	..;q:(NowTime<StartTime)!(NowTime>EndTime)
	..s SessionRoom=$P($G(^RB("RES",ResRowId,"DATE",DateChidDr,"SESS",SessionDr)),"^",19)
	q SessionRoom
}

ClassMethod GetSessionTypeByCareID(DepRowId As %String, CareID As %String) As %String
{
	;w ##class(web.DHCDocTransfer).GetSessionTypeByCareID(44,880)
	q:(DepRowId="")!(CareID="") ""
	;不去找模板上的记录以当时可见排班为准，只有给现在出诊的人转过去才有意义。
	s SessionType=""
	s ResRowId=""
	f  s ResRowId=$o(^RB("RES",0,"CTLOC",DepRowId,ResRowId)) q:ResRowId=""  d
	.s DocId=$p($G(^RB("RES",ResRowId)),"^",2)
	.q:DocId'=CareID
	.s DocDesc=$p($G(^RB("RES",ResRowId)),"^",17)
	.//s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime()
	.;一个科室中一个人在一个有效时段内存在有且只有一个排班
	.s AvailAS=##class(web.DHCRBApptSchedule).GetAvailRA(ResRowId,+$H,"","CUR")
	.;防止瞬间出现超过时段后再次获得排班为空报错
	.if AvailAS'=""  d
	..s ASRowId=$P(AvailAS,"^",1)
	..;取到可用排班第一个
	..s SessionType=$P(^RBAS(+ASRowId,$P(ASRowId,"||",2),"DHC"),"^",6)
	Q SessionType
}

ClassMethod OPDeptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPDeptListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OPDeptListExecute(ByRef qHandle As %Binary, AdmType As %String = "", HospId As %String) As %Status
{
	s ^tempscl("oploc")=HospId
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	i AdmType="" s AdmTypeStr="O^E"
	e  s AdmTypeStr=AdmType
	for i=1:1:$l(AdmTypeStr,"^") d
	.s AdmType=$p(AdmTypeStr,"^",i)
	.s admlocId=""
	.f  s admlocId=$o(^PAC("ADMLOC",admlocId)) q:admlocId=""  d
	..i AdmType'[$p(^PAC("ADMLOC",admlocId),"^") q
	..s ctlocId=$p(^PAC("ADMLOC",admlocId),"^",2)
	..s CTLocHospDr=$p(^CTLOC(ctlocId),"^",22)
	..q:(HospId'="")&&(CTLocHospDr'=HospId)
	..s CTDesc=$p($g(^CTLOC(ctlocId)),"^",2)
	..s CTAlias=$P(^CTLOC(ctlocId),"^",43)
	..//s CTDesc=$P($p($g(^CTLOC(ctlocId)),"^",2),"-",2)
	..//s CTAlias=$P($p($g(^CTLOC(ctlocId)),"^",2),"-",1)
	..s CTRowId=ctlocId
	..s NoReferral=$P($g(^CTLOC(CTRowId,"DHC")),"^",2)
	..q:NoReferral="1"
	..Do OutputRow1
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(CTRowId,CTDesc,CTAlias)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod OPDeptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDeptListExecute ]
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

ClassMethod OPDocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPDocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocTransfer","OPDocList",4,711)
ClassMethod OPDocListExecute(ByRef qHandle As %Binary, DepRowId As %String, AdmId As %String = "") As %Status
{
	;lxz去掉不必要的限制出诊type在转诊的时候判断 根据需要排班标志过滤不需要显示所有医生。因为不会有出诊
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	i DepRowId="" 	Set qHandle=$lb(0,repid,0)	Quit $$$OK
	s UserID=%session.Get("LOGON.USERID")
	s LocID=%session.Get("LOGON.CTLOCID")
	s CurLogonHosp=%session.Get("LOGON.HOSPID")
	i UserID'="" s CareId=..GetCareDrByUserID(UserID)
	i CareId=""   Set qHandle=$lb(0,repid,0)	Quit $$$OK
	Set langid=..%LanguageID()
	//允许跨级别转诊
	s AllowCrossSessTypeTrans=..%GetConfig("AllowCrossSessTypeTrans",CurLogonHosp)
	//$g(^DHCDocConfig("AllowCrossSessTypeTrans"))
	//允许不同费用转诊
	s AllowNotSameFeeTrans=..%GetConfig("AllowNotSameFeeTrans",CurLogonHosp)
	//$g(^DHCDocConfig("AllowNotSameFeeTrans"))
	i AdmId'="" {
		&SQL(Select RegfeeSessionTypeDr into  :SessionTypeF  from SQLUSER.DHCRegistrationFee  where RegfeeAdmDr=:AdmId)
	}
	s ResRowId=""
	f  s ResRowId=$o(^RB("RES",0,"CTLOC",DepRowId,ResRowId)) q:ResRowId=""  d
	.s DocId=$p($G(^RB("RES",ResRowId)),"^",2)
	.s DocDesc=$p($G(^RB("RES",ResRowId)),"^",17)
	.Set DocDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",DocDesc,langid)
	.s ScheSt=$p(^RB("RES",ResRowId),"^",6)
	.Q:(ScheSt'="Y")  
	.s Datefrom=$p(^RB("RES",ResRowId),"^",22)
	.s DateTo=$p(^RB("RES",ResRowId),"^",23)
	.Q:(Datefrom'="")&&(Datefrom>+$H)
	.q:(DateTo'="")&&(DateTo<+$H)
	.//s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime()
	.//TRRowId传当前,排班记录时段的挂号时间段包含当前时间显示该医生
	.s AvailASRowIdStr=##class(web.DHCRBApptSchedule).GetAvailRA(ResRowId,+$H,"","CUR")
	.Q:AvailASRowIdStr=""
	.s AvailASFlag="N"
	.for i=1:1:$l(AvailASRowIdStr,"^") d
	..s OneASRowId=$p(AvailASRowIdStr,"^",i)
	..//停止挂号（医生坐诊信息开启停止挂号后，不允许挂号及取号）
	..s StopRegFlag=$P($G(^RBAS(+OneASRowId,$P(OneASRowId,"||",2),"DHC")),"^",30)
	..Q:StopRegFlag="Y"
	..s AvailASFlag="Y"
	.Q:AvailASFlag="N"
	.s valid=1
	.i AdmId'="" d 
	..s SessionTypeT=..GetSessionTypeByCareID(DepRowId,DocId)
	..if (SessionTypeF'=SessionTypeT)&&(AllowCrossSessTypeTrans'=1) s valid=0
	..s PriceT=$$GetPrice(SessionTypeT)
	..s PriceF=$$GetPrice(SessionTypeF)
	..if (PriceT'=PriceF)&&(AllowNotSameFeeTrans'=1) s valid=0
	.Q:valid=0
	.Do OutputRow2
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(DocId,DocDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
GetPrice(SessionType)
    Q:SessionType="" 0
	s PriceSum=0	
	s Child=0 f  s Child=$O(^RBC("SESS",SessionType,"SER",Child)) q:(Child="")  d
	.s ArcimId=$p(^RBC("SESS",SessionType,"SER",Child),"^",1)
	.s Price=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimId,+$h,"","","","",CurLogonHosp),"^",4)
	.s PriceSum=PriceSum+Price
	q PriceSum
}

ClassMethod OPDocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDocListExecute ]
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

/// w ##class(web.DHCDocTransfer).CheckRegDeptAgeSex("","869","57")
ClassMethod CheckRegDeptAgeSex(ASRowId, PatientID, DepRowId As %String = "")
{
	s ^tmp("imitwert")=$LB(ASRowId, PatientID, DepRowId)
	s LimitSexMsg=""
	s LimitAgeMsg=""
	s RegDeptAgeSexFlag=##class(web.DHCOPAdmReg).CheckRegDeptAgeSex(ASRowId,PatientID,DepRowId)
	s LimitFlag=$P(RegDeptAgeSexFlag,$C(2),1)
	if (LimitFlag'=0){
		s LimitSex=$P(RegDeptAgeSexFlag,$C(2),2)
		s LimitAge=$P(RegDeptAgeSexFlag,$C(2),3)
		//"此科室支持性别【"+AllowSexDesc+"】"
		s:LimitAge'="" LimitAgeMsg="此科室支持年龄段【"_AgeRange_"】"
		s:LimitSex'="" LimitSexMsg="此科室支持性别【"_LimitSex_"】"
	}
	
	q:LimitSexMsg'="" LimitSexMsg
	q:LimitAgeMsg'="" LimitAgeMsg
	q ""
}

/// w ##class(web.DHCDocTransfer).UpdateTransfer(1,128,915,"")
ClassMethod UpdateTransfer(DepRowId As %String, DocRowId As %String, AdmIdStr As %String, UserID As %String = "") As %String
{
	s ^tempscl("UpdateTransfer")=DepRowId_","_DocRowId_","_AdmIdStr_","_UserID
	s ret=0
	q:DepRowId="" ret
	q:DocRowId="" ret
	q:AdmIdStr="" ret
	if UserID="" s UserID=%session.Get("LOGON.USERID") ;lxz 尽量参数保持传入有利于调试
	s CurLogonHosp=$p(^CTLOC(DepRowId),"^",22)
	//是否允许跨级别转诊
	s AllowCrossSessTypeTrans=..%GetConfig("AllowCrossSessTypeTrans",CurLogonHosp)
	//$g(^DHCDocConfig("AllowCrossSessTypeTrans"))
	//是否允许不同费用转诊
	s AllowNotSameFeeTrans=..%GetConfig("AllowNotSameFeeTrans",CurLogonHosp)
	//$g(^DHCDocConfig("AllowNotSameFeeTrans"))
	s ^Temp("AllowNotSameFeeTrans")=$LB(AllowNotSameFeeTrans,CurLogonHosp,AllowCrossSessTypeTrans)
	s CareId=..GetCareDrByUserID(UserID)
	q:CareId="" ret
	s SessionTypeT=""
	s SessionTypeF=""
	s SessionRoomDR=""
	s SessionRoomDR=..GetSessionRoomByCareID(DepRowId,DocRowId)
	s SessionTypeT=..GetSessionTypeByCareID(DepRowId,DocRowId)
	
	s PriceT=$$GetPrice(SessionTypeT)
	s AdmId=""
	s ret=""
	s len=$l(AdmIdStr,"^")
	s Flag=0
	;暂时按照出诊级别来判断是否可以转。
	f i=1:1:len d
	.s AdmId=$P($G(AdmIdStr),"^",i)
	.q:AdmId=""
	.s NameID=$P(^PAADM(AdmId),"^",1)
	.s Name=$P($G(^PAPER(NameID,"ALL")),"^",1)
	.s flag=..CheckRegDeptAgeSex("",NameID,DepRowId)
	.i flag'="" d
	..s ErrMsg=Name_flag_"!"_"-100"
	..s ret=$s(ret="":ErrMsg,1:ret_"^"_ErrMsg)

	.q:flag'=""
	
	.//应急系统患者不能进行转诊
	.s IsCESAdm=##Class(DHCDoc.Interface.StandAlone.Service).IsCESAdm(AdmId)
	.if IsCESAdm=1  d
	..s ErrMsg=Name_"为应急系统患者,不能转诊"_"!"_"-100"
	..s ret=$s(ret="":ErrMsg,1:ret_"^"_ErrMsg)
	.q:IsCESAdm=1
	.&SQL(Select RegfeeSessionTypeDr into  :SessionTypeF  from SQLUSER.DHCRegistrationFee  where RegfeeAdmDr=:AdmId)
	.if (SessionTypeF'=SessionTypeT)&&(AllowCrossSessTypeTrans'=1)  d
	..if ret="" s ret=Name_"转科级别不同"_"!"_"-100"
	..else  s ret=ret_"^"_Name_"转科级别不同"_"!"_"-100"
	.Q:(SessionTypeF'=SessionTypeT)&&(AllowCrossSessTypeTrans'=1)
	.;--------------
	.s PriceF=$$GetPrice(SessionTypeF)
	.if (PriceT'=PriceF)&&(AllowNotSameFeeTrans'=1) d  ;判断级别对应价格
	..if ret="" s ret=Name_"转科级别费用不同"_"!"_"-100"
	..else  s ret=ret_"^"_Name_"转科级别费用不同"_"!"_"-100"
	.Q:(PriceT'=PriceF)&&(AllowNotSameFeeTrans'=1)
	.S QueExabdr="",PersDr=""
	.s BordRowid="" f  s BordRowid=$O(^User.DHCExaBorDepI("BordDepDrIndex"," "_DepRowId,BordRowid)) q:BordRowid=""  d
	..Q:'$D(^User.DHCExaBorDepD(BordRowid))
	..S BoroughRowid=$List(^User.DHCExaBorDepD(BordRowid),6)
	..Q:'$D(^User.DHCExaBoroughD(BoroughRowid))
	..s QueExabdr=BoroughRowid
	..&sql(select ID into :PersDr from  SQLUser.DHCPerState where PersName='等候')
	.i PersDr="" d
	..s QueExabdr=""
	..s BordRowid="" f  s BordRowid=$O(^User.DHCExaBorDepI("BordDepDrIndex",DepRowId,BordRowid)) q:BordRowid=""  d
	...Q:'$D(^User.DHCExaBorDepD(BordRowid))
	...S BoroughRowid=$List(^User.DHCExaBorDepD(BordRowid),6)
	...Q:'$D(^User.DHCExaBoroughD(BoroughRowid))
	...s QueExabdr=BoroughRowid
	...&sql(select ID into :PersDr from  SQLUser.DHCPerState where PersName='等候')
	.if PersDr="" d
	..if ret="" s ret=Name_"请确认转诊到的科室是否进行了诊区科室对照"_"!"_"-100"
	..else  s ret=ret_"^"_Name_"请确认转诊到的科室是否进行了诊区科室对照"_"!"_"-100"
	.Q:PersDr=""
	.TStart
	.s Return=$$GetMsgForInset(AdmId,UserID)
	.;-----------------------------lxz 修改病人就诊类型
	.s PaAdmType="O"
	.&sql(select PAADM_Type  into :PaAdmType from SQLUSER.PA_ADM where PAADM_RowID=:AdmId)
	.s LocType="O"
	.s IsEmergency=##class(web.DHCOPAdmReg).IsEmergency(DepRowId)
	.if (IsEmergency="1") s LocType="E"
	.if (PaAdmType'=LocType)&&(PaAdmType'="I") d
	..s InsAdmNo=##class(web.DHCPAADM).CompADMNo(LocType)
	..&SQL(Update SQLUSER.PA_ADM set PAADM_Type=:LocType,PAADM_ADMNo=:InsAdmNo where PAADM_RowID=:AdmId)
	.i SQLCODE'=0 TRollBack
	.q:SQLCODE'=0
	.;------------------------------
	.&SQL(Update SQLUSER.PA_ADM set PAADM_DepCode_DR=:DepRowId,PAADM_AdmDocCodeDR=:DocRowId where PAADM_RowID=:AdmId)
	.i ret="" d
	..s ret=AdmId_"!"_SQLCODE
	.e  d
	..s ret=ret_"^"_AdmId_"!"_SQLCODE
	.i SQLCODE'=0 TRollBack
	.q:SQLCODE'=0
	.&SQL(Update SQLUSER.DHCRegistrationFee set RegfeeDepDr=:DepRowId,RegfeeDocDr=:DocRowId,RegfeeRoomDr=:SessionRoomDR,RegTransferReDoc=:CareId,RegTransferFlag='1' where RegfeeAdmDr=:AdmId)
	.s ret=ret_"!"_SQLCODE
	.i SQLCODE'=0 TRollBack
	.q:SQLCODE'=0
	.&SQL(Select RegfeeSessionTypeDr into  :SessionTypeF  from SQLUSER.DHCRegistrationFee  where RegfeeAdmDr=:AdmId)
	.s ret=ret_"!"_SQLCODE
	.i SQLCODE'=0 TRollBack
	.q:SQLCODE'=0
	.i (SessionTypeF'=SessionTypeT)&&(AllowCrossSessTypeTrans'=1) s ret=ret_"!"_"100"
	.//i SessionTypeF=SessionTypeT s ret=ret_"!"_"0"
	.e  s ret=ret_"!"_"0"
	.;i SessionTypeF'=SessionTypeT  TRollBack
	.;q:SessionTypeF'=SessionTypeT
	.&SQL(Update SQLUSER.DHCQueue set QueCompDr=null,QueDocDr=null,QueDepDr=:DepRowId,QueMarkDr=:DocRowId,QueExabDr=:QueExabdr,QueStateDr=:PersDr,QueRoomDr=:SessionRoomDR where QuePaadmDr=:AdmId)
	.s ret=ret_"!"_SQLCODE
	.i SQLCODE'=0 TRollBack
	.q:SQLCODE'=0
	.TCommit
	q ret
GetPrice(SessionType)
    Q:SessionType="" 0
	s PriceSum=0	
	s Child=0 f  s Child=$O(^RBC("SESS",SessionType,"SER",Child)) q:(Child="")  d
	.s ArcimId=$p(^RBC("SESS",SessionType,"SER",Child),"^",1)
	.s Price=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimId,+$h,"","","",""),"^",4)
	.s PriceSum=PriceSum+Price
	q PriceSum
GetMsgForInset(AdmInput,UserID)
	Q:AdmInput="" ""
	s (InsPatType,InsAdmDep,InsAdmDoc,InsRegfeeDep,InsRegfeeDoc,InsRegfeeRoom,InsRegfeeSessionType,InsQueDep,InsQueDoc,InsQueExabdr,InsAdmNo)=""
	
	&sql(select PAADM_Type,PAADM_DepCode_DR,PAADM_AdmDocCodeDR,PAADM_ADMNo
	into :InsPatType,:InsAdmDep,:InsAdmDoc,:InsAdmNo from SQLUSER.PA_ADM where PAADM_RowID=:AdmInput)
	
	&sql(select RegfeeDepDr,RegfeeDocDr,RegfeeRoomDr,RegfeeSessionTypeDr
	into :InsRegfeeDep,:InsRegfeeDoc,:InsRegfeeRoom,:InsRegfeeSessionType
	from SQLUSER.DHCRegistrationFee where RegfeeAdmDr=:AdmInput)
	
	&sql(select QueDepDr,QueMarkDr,QueExabDr
	into :InsQueDep,:InsQueDoc,:InsQueExabdr
	from SQLUSER.DHCQueue where QuePaadmDr=:AdmInput)
	
	&sql(insert SQLUSER.DHCOPTransAdm
	(Trans_Adm,Trans_AdmDep,Trans_AdmDoc,Trans_RegFeeDep,Trans_RegFeeDoc,Trans_RegFeeRoom,
	Trans_RegFeeSessionType,Trans_QueDep,Trans_QueMark,Trans_QueExabdr,Trans_User,Trans_AdmType,Trans_AdmNo
	,Trans_ToAdmDep,Trans_ToAdmDoc)
	values
	(:AdmInput,:InsAdmDep,:InsAdmDoc,:InsRegfeeDep,:InsRegfeeDoc,:InsRegfeeRoom,
	:InsRegfeeSessionType,:InsQueDep,:InsQueDoc,:InsQueExabdr,:UserID,:InsPatType,:InsAdmNo,:DepRowId,:DocRowId)
	)
	Q SQLCODE
}

Query FindCurrenAdm(Papmino As %String, LocID As %String, UserID As %String) As %Query(ROWSPEC = "SeqNo:%String,RegNo:%String,AdmID:%String,PatName:%String,PatSex:%String,PatAge:%String,RegDoctor:%String,TimeRange:%String,PAAdmReason:%String,PAAdmDep:%String,PAAdmType:%String,TPoliticalLevel:%String,TSecretLevel:%String")
{
}

Query OPDeptList(AdmType As %String, HospId As %String) As %Query(ROWSPEC = "CTCode:%String,CTDesc:%String,CTAlias:%String")
{
}

Query OPDocList(DepRowId As %String, AdmId As %String = "") As %Query(ROWSPEC = "DocId:%String,DocDesc:%String")
{
}

/// 获取病人就诊状态
ClassMethod GetQueStatusByAdm(Adm) As %String
{
	q:Adm="" ""
	s QueId=$o(^User.DHCQueueI("QuePaadmDrIndex",Adm,0))
	;q:QueId="" ""
	if (QueId=""){
		//应急系统患者默认是到达状态,此时没有问题,但如果需要对应急系统患者分状态,需要修改转诊方法,以适配应急系统
		s CESAdmQueStatInfo=##Class(DHCDoc.Interface.StandAlone.Service).GetCESAdmQueStatInfo(Adm)
		s Status=$p(CESAdmQueStatInfo,"^",3)
		q Status
	}
	
	s StatusDr=$lg(^User.DHCQueueD(QueId),14)
	s Status=""
	s:StatusDr'="" Status=$lg(^User.DHCPerStateD(StatusDr),4)
	q Status
}

/// 获取就诊对应诊区的未报到可就诊标志
ClassMethod GetExaNoCheckinDocCanRecAdm(Adm) As %String
{
	q:Adm="" ""
	s QueId=$o(^User.DHCQueueI("QuePaadmDrIndex",Adm,0))
	q:QueId="" ""
	Set oref=##Class(User.DHCQueue).%OpenId(QueId)
	Set ExabNoCheckinDocCanRecAdm=oref.QueExabDr.ExabNoCheckinDocCanRecAdm
	Do oref.%Close()
	Set oref=""
	Q ExabNoCheckinDocCanRecAdm
}

}

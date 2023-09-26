Class DHCDoc.DHCDocConfig.HolidaysRecLoc Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->节假日接收科室定义 查询接收科室
Query FindRecDep(LocId As %String, NodeRowid As %String, NodeDesc As %String, HospId As %String = "") As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,selected:%String")
{
}

ClassMethod FindRecDepExecute(ByRef qHandle As %Binary, LocId As %String, NodeRowid As %String, NodeDesc As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HolidaysRecLoc","FindRecDep","OneOrderDefaultRecLoc")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}else{
		s HospCodeNode=""
	}
 	s CTLOCRowID=0
 	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
 	.s str=$g(^CTLOC(CTLOCRowID))
 	.q:##class(web.DHCDocCommon).CheckLocIsValid(CTLOCRowID)=0
 	.s CTLOCType=$p(str,"^",13)
 	.q:CTLOCType'="D"
 	.s CTLOCDesc=$p(str,"^",2)
 	.s selected=0
 	.i (NodeRowid'="")&&(LocId'="") d
 	..s:("^"_##class(web.DHCDocConfig).GetConfigNode3(NodeDesc,LocId,NodeRowid,HospId)_"^")[("^"_CTLOCRowID_"^") selected=1 //$g(^DHCDocConfig(NodeDesc,LocId,NodeRowid))
	.Do OutputRowFindRecDep
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindRecDep
	set Data=$lb($g(CTLOCRowID),$g(CTLOCDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindRecDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRecDepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRecDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRecDepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->节假日接收科室定义 查询门诊 住院病区
Query FindDep(HospRowId As %String = "") As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,selected:%Boolean")
{
}

ClassMethod FindDepExecute(ByRef qHandle As %Binary, HospRowId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HolidaysRecLoc","FindDep","OneOrderDefaultRecLoc")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s CTLOCRowID=0
 	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
 	.s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",CTLOCRowID,HospRowId)
	.q:flag="N"
 	.s str=$g(^CTLOC(CTLOCRowID))
 	.s CTLOCType=$p(str,"^",13)
 	.q:(CTLOCType'="E")&&(CTLOCType'="W")
 	.q:##class(web.DHCDocCommon).CheckLocIsValid(CTLOCRowID)=0
 	.s LocHospDr=$p(str,"^",22)
 	.Q:LocHospDr'=HospRowId
 	.s selected=0
 	.s CTLOCDesc=$p(str,"^",2)
	.Do OutputRowFindDep
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDep
	set Data=$lb($g(CTLOCRowID),$g(CTLOCDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->节假日接收科室定义 
Query FindPriorByLoc(LocID As %String, value As %String, Type As %String = "") As %Query(ROWSPEC = "OECPRRowId:%String,OECPRDesc:%String,selected:%Boolean")
{
}

ClassMethod FindPriorByLocExecute(ByRef qHandle As %Binary, LocID As %String, value As %String, Type As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HolidaysRecLoc","FindPriorByLoc",1,"HolidaysOrderPriorStr")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s OECPRRowId=0
 	f  s OECPRRowId=$o(^OECPR(OECPRRowId)) q:OECPRRowId=""  d
 	.s OECPRDesc=$p(^OECPR(OECPRRowId),"^",2)
 	.s OECPRCode=$p(^OECPR(OECPRRowId),"^",1)
 	.s selected=0
 	.i LocID'="" d
 	..s CNMedPriorListStr=..%GetConfig1(value,LocID) //$g(^DHCDocConfig(value,LocID))
 	..s:("^"_CNMedPriorListStr_"^")[("^"_OECPRRowId_"^") selected=1
 	.//用法接收科室页面医嘱类型不显示取药和出院带药
 	.Q:(Type="InstrLoc")&&(OECPRCode="ONE")||(OECPRCode="OUT")
	.Do OutputRowFindPriorByLoc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindPriorByLoc
	set Data=$lb($g(OECPRRowId),$g(OECPRDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindPriorByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPriorByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPriorByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPriorByLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:宋春莉
/// date:2015-12-18
/// desc:医生站设置程序->节假日接收科室定义 查询节假日列表
Query GetHolidaysList(HospId As %String = "") As %Query(ROWSPEC = "HolidaySetRowId:%String,RDHIsActiveFlag:%String,RDHStartDate:%String,RDHStartTime:%String,RDHEndDate:%String,RDHEndTime:%String,RDHCreateUser:%String,RDHCreateDate:%String,RDHCreateTime:%String")
{
}

ClassMethod GetHolidaysListExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HolidaysRecLoc","GetHolidaysList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
    Set HolidaySetRowId=0
    f  s HolidaySetRowId=$o(^User.DHCOPRecDepHolidayD(HolidaySetRowId)) q:HolidaySetRowId=""  d
    .s RDHIsActiveFlag=$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),5)
    .s RDHStartDate=$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),6)
    .i RDHStartDate'="" s RDHStartDate=..%ZD(RDHStartDate) //$zd(RDHStartDate,3)
    .s RDHStartTime=+$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),7)
    .i RDHStartTime'="" s RDHStartTime=..%ZT(RDHStartTime,1)
    .s RDHEndDate=$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),8)
    .i RDHEndDate'="" s RDHEndDate=..%ZD(RDHEndDate) //$zd(RDHEndDate,3)
    .s RDHEndTime=$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),9)
    .s RDHHospDR=$lg(^User.DHCOPRecDepHolidayD(HolidaySetRowId),10)
    .Q:(HospId'=RDHHospDR)
    .i RDHEndTime'="" s RDHEndTime=..%ZT(RDHEndTime,1)
    .s RDHCreateUserDR=$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),2)
    .s RDHCreateUser=""
    .i RDHCreateUserDR'="" s RDHCreateUser=$p($g(^SSU("SSUSR",RDHCreateUserDR)),"^",2)
    .s RDHCreateDate=$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),3)
    .i RDHCreateDate'="" s RDHCreateDate=..%ZD(RDHCreateDate) //$zd(RDHCreateDate,3)
    .s RDHCreateTime=$list(^User.DHCOPRecDepHolidayD(HolidaySetRowId),4)
    .i RDHCreateTime'="" s RDHCreateTime=..%ZT(RDHCreateTime,1)
	.Do OutputRowGetHolidaysList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetHolidaysList
	set Data=$lb($g(HolidaySetRowId),$g(RDHIsActiveFlag),$g(RDHStartDate),$g(RDHStartTime),$g(RDHEndDate),$g(RDHEndTime),$g(RDHCreateUser),$g(RDHCreateDate),$g(RDHCreateTime))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetHolidaysListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHolidaysListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHolidaysListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHolidaysListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:fxn
/// date:2018-4-19
/// desc:医生站设置程序->节假日接收科室定义 查询下班时间段
Query GetOffWorkTimeList(HospId As %String = "") As %Query(ROWSPEC = "OffWorkTimesSetRowId:%String,OffWorkStartTime:%String,OffWorkEndTime:%String,Active:%String")
{
}

ClassMethod GetOffWorkTimeListExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HolidaysRecLoc","GetOffWorkTimeList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		Set OffWorkTimesSetRowId=0
	    f  s OffWorkTimesSetRowId=$o(^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",OffWorkTimesSetRowId)) q:OffWorkTimesSetRowId=""  d
	    .s OffWorkStartTime=$p($g(^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",OffWorkTimesSetRowId)),"^",1)
	    .i (OffWorkStartTime'="")&&(OffWorkStartTime'[":") s OffWorkStartTime=..%ZT(OffWorkStartTime,1)
	    .s OffWorkEndTime=$p($g(^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",OffWorkTimesSetRowId)),"^",2)
	    .i (OffWorkEndTime'="")&&(OffWorkEndTime'[":")  s OffWorkEndTime=..%ZT(OffWorkEndTime,1)
	    .s Active=$p($g(^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",OffWorkTimesSetRowId)),"^",3)
	    .if (Active="") s Active=1
		.Do OutputRowGetOffWorkTimeList
	}else{
	    Set OffWorkTimesSetRowId=0
	    f  s OffWorkTimesSetRowId=$o(^DHCDocConfig("OffWorkTimesSet",OffWorkTimesSetRowId)) q:OffWorkTimesSetRowId=""  d
	    .s OffWorkStartTime=$p($g(^DHCDocConfig("OffWorkTimesSet",OffWorkTimesSetRowId)),"^",1)
	    .i (OffWorkStartTime'="")&&(OffWorkStartTime'[":") s OffWorkStartTime=..%ZT(OffWorkStartTime,1)
	    .s OffWorkEndTime=$p($g(^DHCDocConfig("OffWorkTimesSet",OffWorkTimesSetRowId)),"^",2)
	    .i (OffWorkEndTime'="")&&(OffWorkEndTime'[":")  s OffWorkEndTime=..%ZT(OffWorkEndTime,1)
	    .s Active=$p($g(^DHCDocConfig("OffWorkTimesSet",OffWorkTimesSetRowId)),"^",3)
	    .if (Active="") s Active=1
		.Do OutputRowGetOffWorkTimeList
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetOffWorkTimeList
	set Data=$lb($g(OffWorkTimesSetRowId),$g(OffWorkStartTime),$g(OffWorkEndTime),$g(Active))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetOffWorkTimeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOffWorkTimeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOffWorkTimeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOffWorkTimeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取所有执行科室
Query LookUpAllLoc(Desc As %String = "") As websys.Query(ROWSPEC = "Desc:%String,rowid:%String") [ SqlProc ]
{
}

ClassMethod LookUpAllLocExecute(ByRef QHandle As %Binary, Desc As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HolidaysRecLoc","LookUpAllLoc","1")
	Set repid=$I(^CacheTemp)
	s ind=1

	s CTLOCRowID=0
 	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
 	.s str=$g(^CTLOC(CTLOCRowID))
 	.q:##class(web.DHCDocCommon).CheckLocIsValid(CTLOCRowID)=0
 	.s CTLOCType=$p(str,"^",13)
 	.q:CTLOCType="C"
	.q:CTLOCType="OR"
	.q:##class("web.DHCOPAdmReg").CheckLocDesc(CTLOCRowID,Desc)'=1
 	.s CTLOCDesc=$p(str,"^",2)
	.d OutputRow1
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(CTLOCDesc,CTLOCRowID)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

/// 插入数据
ClassMethod InsertHoliday(Data As %String, HospId As %String = "")
{
	s ^tempscl("InsertHoliday")=Data
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s HolidayStatrDate=$p(Data,"^",1)
	i HolidayStatrDate'="" s HolidayStatrDate=..%ZDH(HolidayStatrDate)
	s HolidayStartTime=$p(Data,"^",2)
	i HolidayStartTime'="" s HolidayStartTime=..%ZTH(HolidayStartTime)
	s HolidayEndDate=$p(Data,"^",3)
	i HolidayEndDate'="" s HolidayEndDate=..%ZDH(HolidayEndDate)
	s HolidayEndTime=$p(Data,"^",4)
	i HolidayEndTime'="" s HolidayEndTime=..%ZTH(HolidayEndTime)
	i HolidayEndTime="" s HolidayEndTime=$ZTH("23:59:59")
	Q:(HolidayStatrDate'="")&&(HolidayEndDate'="")&&(HolidayStatrDate>HolidayEndDate) "假期开始日期不能大于假期结束日期"
	q:(HolidayEndDate=HolidayStatrDate)&&(HolidayStartTime>HolidayEndTime)&&(HolidayEndTime'="")&&(HolidayStartTime'="") "假期开始时间不能大于假期结束时间"
	s UserID=$p(Data,"^",5)
	s CurrentDate=..%SysDate()
	s CurrentTime=..%SysTime()
	s ActiveFlag="Y"
	&sql(insert into SQLUSER.DHC_OPRecDepHoliday set RDH_StartDate=:HolidayStatrDate,RDH_StartTime=:HolidayStartTime,RDH_EndDate=:HolidayEndDate,RDH_EndTime=:HolidayEndTime,RDH_CreateUser_DR=:UserID,RDH_CreateDate=:CurrentDate,RDH_CreateTime=:CurrentTime,RDH_IsActiveFlag=:ActiveFlag,RDH_Hosp_DR=:HospId)
    Q SQLCODE
}

/// 删除数据
ClassMethod DeleteHoliday(HolidaySetRowId As %String)
{
	
	&sql(delete SQLUSER.CT_DOC_Order.RecDepHolidayDetails where RDH_ConfigType='HolidaysRecStr' AND RDH_RecHolidayDr=:HolidaySetRowId)
	&sql(delete SQLUSER.DHC_OPRecDepHoliday where ID=:HolidaySetRowId)
    Q SQLCODE
}

/// w ##Class(DHCDoc.DHCDocConfig.HolidaysRecLoc).DeleteOffWorkTimesDetails(3,"")
ClassMethod DeleteOffWorkTimesDetails(OffWorkTimesSetRowId As %String, HospId As %String = "")
{
	s ID=0
	for i=1:1:$length(OffWorkTimesSetRowId,"^"){
		s ID=$P(OffWorkTimesSetRowId,"^",i)
		continue:(ID="")
		&SQL(DELETE FROM CT_DOC_Order.RecDepHolidayDetails WHERE ID = :ID)
		b ;---
	}
	q 0
}

/// 保存上下班时间信息
/// w ##Class(DHCDoc.DHCDocConfig.HolidaysRecLoc).SaveOffWorkTimes("","01:00:00^22:00:00^1","2")
ClassMethod SaveOffWorkTimes(Node1 As %String, NodeValue As %String, HospId As %String = "") As %String
{
	;s ^tempfxn("SaveConfig3")=Node_","_Node_","_NodeValue
 	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s HospCodeNode="HospDr_"_HospId
	if (Node1=""){
		s FindSameDataFlag=0
		Set OffWorkTimesSetRowId=0
	    f  {
			s OffWorkTimesSetRowId=$o(^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",OffWorkTimesSetRowId))
			q:OffWorkTimesSetRowId=""
			s OffWorkStartTime=$p($g(^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",OffWorkTimesSetRowId)),"^",1)
			i OffWorkStartTime[":" s OffWorkStartTime=..%ZTH(OffWorkStartTime)
			s OffWorkEndTime=$p($g(^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",OffWorkTimesSetRowId)),"^",2)
			i OffWorkEndTime[":" s OffWorkEndTime=..%ZTH(OffWorkEndTime)
			if (OffWorkStartTime=..%ZTH($P(NodeValue,"^",1)))&&(OffWorkEndTime=..%ZTH($P(NodeValue,"^",2))){
				s FindSameDataFlag=1
			}
		}
		if (FindSameDataFlag=1){
			q "-1^保存失败，存在相同的上下班时间"
		}
	}


	
	if (Node1="") {
		s Node1=$o(^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",""),-1)
		i Node1="" s Node1=0
		s Node1=Node1+1
	}
	s ^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",Node1)=NodeValue

	q 0
}

ClassMethod DeleteOffWorkTimes(OffWorkTimesSetRowId As %String, HospId As %String = "")
{
	Q:OffWorkTimesSetRowId="" ""
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		i $d(^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",OffWorkTimesSetRowId)) d
		.k ^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",OffWorkTimesSetRowId)
	}else{
		i $d(^DHCDocConfig("OffWorkTimesSet",OffWorkTimesSetRowId)) d
		.k ^DHCDocConfig("OffWorkTimesSet",OffWorkTimesSetRowId)
	}
	Q 0
}

/*
---------------老数据格式----------------
//NodeDesc:"OffWorkTimesRecStr":上下班接收科室串
			"HolidaysRecStr":节假日接收科室串
//NodeRowid:"OffWorkTimesRec":上下班接收科室信息
			"HolidaySetRowId"：节假日接收科室信息
s ^DHCDocConfig(HospCodeNode,NodeDesc,LocId,NodeRowid)=RecLocStr
---------------新数据格式----------------
统一走CT.DOC.Order.RecDepHolidayDetails
*/
/// 保存节假日接收科室列表
/// TODO 清数据
/// w ##Class(DHCDoc.DHCDocConfig.HolidaysRecLoc).SaveRecConfig("","OffWorkTimesRecStr^^57^^Y^3^All","2")
ClassMethod SaveRecConfig(RowID As %String, Val As %String, HospId As %String) As %Status
{
	s ^TMPtan("SaveRecConfig")=$LB(RowID,Val,HospId)
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId="") {
		q "-1^院区ID不能为空"
	}
	s ConfigType=$P(Val,"^",1)		//配置类型
	s RecHolidayDr=$P(Val,"^",2)	//节假日指向，节假日接收科室配置时必填
	s OrdLocDr=$P(Val,"^",3)		//开单科室
	s RecLocDr=$P(Val,"^",4)		//接收科室列表
	s IsActiveFlag=$P(Val,"^",5)	//是否可用标识
	s OrderPrior=$P(Val,"^",6)		//条件：医嘱类型
	s NotifyClinician=$P(Val,"^",7)	//条件：是否加急

	if (ConfigType'="OffWorkTimesRecStr")&&(ConfigType'="HolidaysRecStr"){
		q "-1^无法识别的配置类型"
	}
	if (ConfigType="OffWorkTimesRecStr")&&(RecHolidayDr'=""){
		q "-1^上下班接收科室配置无需关联节日"
	}
	if (ConfigType="HolidaysRecStr")&&(RecHolidayDr=""){
		q "-1^无效的主表数据，请选中节假日后再保存"
	}
	if (OrdLocDr=""){
		q "-1^开单科室不能为空"
	}
	#; 实际应用过程中可能存在相同科室一个关联药品，一个关联材料这种情况，所以应该允许重复
	#; s ID=0,count=0
	#; for {
	#; 	s ID=$O(^CF.DOC.Order.RecDepHoliDayD(ID))
	#; 	q:(ID="")
	#; 	s Val=$G(^CF.DOC.Order.RecDepHoliDayD(ID))
	#; 	continue:(Val="")
	#; 	continue:(RowID'="")&&(RowID=ID)
	#; 	continue:($LG(Val,2)'=ConfigType)
	#; 	continue:($LG(Val,3)'=RecHolidayDr)
	#; 	continue:($LG(Val,4)'=OrdLocDr)
	#; 	continue:($LG(Val,7)'=HospId)
	#; 	continue:($LG(Val,8)'=OrderPrior)
	#; 	continue:($LG(Val,9)'=NotifyClinician)
	#; 	s count=count+1
	#; }
	#; if (count>0){
	#; 	//q "-1^存在类似的节假日接收科室信息维护，请在原数据基础上做修改操作!"
	#; }
	
	s IsActiveFlag=$CASE(IsActiveFlag,"Y":"Y",:"N")
	if (RowID=""){
		s obj=##Class(CT.DOC.Order.RecDepHolidayDetails).%New()
	}else{
		s obj=##Class(CT.DOC.Order.RecDepHolidayDetails).%OpenId(RowID)
	}
	s obj.RDHConfigType=ConfigType
	if (ConfigType="HolidaysRecStr")&&(RecHolidayDr'=""){
		d obj.RDHRecHolidayDrSetObjectId(RecHolidayDr)
	}
	d obj.RDHOrdLocDrSetObjectId(OrdLocDr)

	s obj.RDHIsActiveFlag=IsActiveFlag
	d obj.RDHHospDRSetObjectId(HospId)
	
	d obj.RDHOrderPriorSetObjectId(OrderPrior)

	s obj.RDHNotifyClinician=NotifyClinician
	s obj.RDHLastUpdateDate=..%SysDate()
	s obj.RDHLastUpdateTime=..%SysTime()
	s sc=obj.%Save()
	if ($$$ISERR(sc)){
		q "-1^保存数据失败:"_$G(%msg)

	}
	q 0
}

/// 插入接收科室列表
/// w ##Class(DHCDoc.DHCDocConfig.HolidaysRecLoc).UpdateRecLocInfo("Add","4","2")
ClassMethod UpdateRecLocInfo(TYPE As %String = "Add", RowID As %String, RecLocDr As %String) As %Status
{
	s obj=##Class(CT.DOC.Order.RecDepHolidayDetails).%OpenId(RowID)
	if ('$ISObject(obj)){
		q "-1^保存失败"
	}
	s RecLocList=obj.RDHRecLocDr
	s key="",sc=$$$YES
	while (RecLocList'="" && RecLocList.GetNext(.key) && ($$$ISOK(sc))){
		s ReclocDr=RecLocList.GetAt(key)
		if (ReclocDr=""){
			continue
		}
		if (ReclocDr=RecLocDr){
			Quit
		}
	}
	if (TYPE="Add"){
		if (key'=""){
			q "-1^已存在相同的接收科室记录,不需要重复添加"
		}
		D obj.RDHRecLocDr.Insert(RecLocDr)
	}elseif (TYPE="Delete"){
		if (key=""){
			//q "-1^未找到接收科室记录"
			q 0
		}
		D obj.RDHRecLocDr.RemoveAt(key)
	}
	s obj.RDHLastUpdateDate=..%SysDate()
	s obj.RDHLastUpdateTime=..%SysTime()
	s sc=obj.%Save()
	if ($$$ISERR(sc)){
		q "-1^操作数据失败:"_$G(%msg)

	}
	b ;----
	q 0
}

/*ClassMethod SaveRecConfig(LocId As %String, NodeRowid As %String, NodeDesc As %String, RecLocStr As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ^DHCDocConfig(HospCodeNode,NodeDesc,LocId,NodeRowid)=RecLocStr
	}else{
		s ^DHCDocConfig(NodeDesc,LocId,NodeRowid)=RecLocStr
	}
	q 0
}*/
/// Description
Query FindRecConfig(ConfigType As %String, HolidayDr As %String, HospId As %String = "") As websys.Query(ROWSPEC = "RowID,OrdLocDr,OrderDept,OrderPriorID,OrderPrior,NotifyClinician,IsActiveFlag,ItemCatList,ExceptionArcimList")
{
}

ClassMethod FindRecConfigExecute(ByRef qHandle As %Binary, ConfigType As %String, HolidayDr As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HolidaysRecLoc","FindRecConfig","OffWorkTimesRecStr","",2)
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
	s SqlStr="SELECT ID,RDH_ConfigType,RDH_OrdLocDr,RDH_OrdLocDr->CTLOC_Desc  OrdLocDesc,RDH_IsActiveFlag,"
		_"RDH_OrderPrior OrderPriorID,RDH_OrderPrior->OECPR_Desc OrderPriorDesc,RDH_NotifyClinician,RDH_LastUpdateDate,RDH_LastUpdateTime"
		_" FROM CT_DOC_Order.RecDepHolidayDetails"
		_" WHERE RDH_ConfigType = '"_ConfigType _"'"
	if (HolidayDr'=""){
		s SqlStr=SqlStr_" and RDH_RecHolidayDr = "_HolidayDr
	}
	if (HospId'=""){
		s SqlStr=SqlStr_"  and RDH_Hosp_DR = "_HospId
	}
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowID = xrs.Data("ID")
		s OrdLocDr = xrs.Data("RDH_OrdLocDr")
		s OrderDept = xrs.Data("OrdLocDesc")
		s IsActiveFlag = xrs.Data("RDH_IsActiveFlag")
		s OrderPriorID = xrs.Data("OrderPriorID")
		s OrderPrior = xrs.Data("OrderPriorDesc")
		s NotifyClinician = xrs.Data("RDH_NotifyClinician")
		s LastUpdateDate = xrs.Data("RDH_LastUpdateDate")
		s LastUpdateTime = xrs.Data("RDH_LastUpdateTime")

		s ItemCatList = $LG(^CF.DOC.Order.RecDepHoliDayD(RowID),12)
		s ItemCatList=$LISTTOSTRING(ItemCatList,"!",1)
		s ExceptionArcimList = $LG(^CF.DOC.Order.RecDepHoliDayD(RowID),13)
		s ExceptionArcimList=$LISTTOSTRING(ExceptionArcimList,"!",1)

		Do OutputRowFindRecConfig
	}
	Quit $$$OK
OutputRowFindRecConfig
	set Data=$lb(RowID,OrdLocDr,OrderDept,OrderPriorID,OrderPrior,NotifyClinician,IsActiveFlag,ItemCatList,ExceptionArcimList)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 获取医嘱类型列表
ClassMethod GetOECPriirty() As %String
{
	s obj=##class(DHCDoc.Util.QueryToJSON).%New("DHCDoc.DHCDocConfig.HolidaysRecLoc","QueryOECPriority")
	s retObj=obj.ToGrid()
	s stream=##class(%Stream.GlobalCharacter).%New()
	d retObj.%ToJSON(.stream)
	s OECPriorityJson=stream.Read()

	q OECPriorityJson
}

/// 获取医嘱类型列表
Query QueryOECPriority() As %SQLQuery [ SqlProc ]
{
	SELECT OECPR_RowId, OECPR_Desc FROM SQLUser.OEC_Priority
}

Query FindRecDetails(RDHDr) As websys.Query(ROWSPEC = "ReclocDr,RecLoc")
{
}

ClassMethod FindRecDetailsExecute(ByRef qHandle As %Binary, RDHDr) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.HolidaysRecLoc","FindRecDetails","4")
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
	if (RDHDr=""){
		q $$$OK
	}
	s obj=##Class(CT.DOC.Order.RecDepHolidayDetails).%OpenId(RDHDr)
	if ('$isobject(obj)){
		q $$$OK
	}
	s RecLocList=obj.RDHRecLocDr
	s key="",sc=$$$YES
	while (RecLocList'="" && RecLocList.GetNext(.key) && ($$$ISOK(sc))){
		s ReclocDr=RecLocList.GetAt(key)
		if (ReclocDr=""){
			continue
		}
		s ReclocDesc=$P(^CTLOC(ReclocDr),"^",2)
		d OutputRowFindRecDetails
	}

	Quit $$$OK
OutputRowFindRecDetails
	set Data=$lb(ReclocDr,ReclocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 更新关联的子分类
ClassMethod UpdateItemCatList(ID, ItemCatList As %String) As %Status
{
	k ItemCatArr
	for i=1:1:$Length(ItemCatList,"!"){
		s ItemCatDr=$P(ItemCatList,"!",i)
		continue:(ItemCatDr="")
		s ItemCatArr(ItemCatDr)=""
	}
	s SameItemCatStr=""
	s Val=$G(^CF.DOC.Order.RecDepHoliDayD(ID))
	s LoopID=0,count=0
	for {
		s LoopID=$O(^CF.DOC.Order.RecDepHoliDayD(LoopID))
		q:(LoopID="")
		continue:(LoopID=ID)
		s LoopVal=$G(^CF.DOC.Order.RecDepHoliDayD(LoopID))
		continue:(LoopVal="")
		continue:($LG(LoopVal,2)'=$LG(Val,2))
		continue:($LG(LoopVal,3)'=$LG(Val,3))
		continue:($LG(LoopVal,4)'=$LG(Val,4))
		continue:($LG(LoopVal,7)'=$LG(Val,7))
		continue:($LG(LoopVal,8)'=$LG(Val,8))
		continue:($LG(LoopVal,9)'=$LG(Val,9))
		s LoopItemCatList=$LG(LoopVal,12)
		continue:(LoopItemCatList="")
		
		s ItemCatDr=0
		for {
			s ItemCatDr=$O(ItemCatArr(ItemCatDr))
			q:(ItemCatDr="")
			s ItemCatDesc=$P(^ARC("IC",ItemCatDr),"^",2)
			continue:(","_SameItemCatStr_",")[(","_ItemCatDesc_",")
			if ($LISTFIND(LoopItemCatList,ItemCatDr)>0){
				if (SameItemCatStr=""){
					s SameItemCatStr=ItemCatDesc
				}else{
					s SameItemCatStr=SameItemCatStr_"、"_ItemCatDesc
				}
			}
		}
		
		
	}
	if (SameItemCatStr'=""){
		q "-1^在相同的开单科室及参数下，发现了重复维护的子类:"_SameItemCatStr_",不允许保存"
	}

	s obj=##Class(CT.DOC.Order.RecDepHolidayDetails).%OpenId(ID)
	if ('$isobject(obj)){
		q "-1^更新失败"
	}
	
	s key="",sc=$$$YES
	while (obj.RDHItemCatDr'="" && obj.RDHItemCatDr.GetNext(.key) && ($$$ISOK(sc))){
		s ItemCatDr=obj.RDHItemCatDr.GetAt(key)
		if (ItemCatDr=""){
			continue
		}
		if ($D(ItemCatArr(ItemCatDr))){
			k ItemCatArr(ItemCatDr)
		}else{
			d obj.RDHItemCatDr.RemoveAt(key)
			s key=obj.RDHItemCatDr.Previous(key)
		}
	}
	s ItemCatDr=0
	for {
		s ItemCatDr=$O(ItemCatArr(ItemCatDr))
		q:(ItemCatDr="")
		d obj.RDHItemCatDr.Insert(ItemCatDr)
	}
	s sc=obj.%Save()
	if ($$$ISERR(sc)){
		q "-1^操作数据失败:"_$G(%msg)

	}
	q 0
}

/// 更新例外的医嘱项
ClassMethod UpdateArcimList(ID, ArcimList As %String) As %Status
{
	k ArcimArr
	for i=1:1:$Length(ArcimList,"!"){
		s ArcimDr=$P(ArcimList,"!",i)
		continue:(ArcimDr="")
		s ArcimArr(ArcimDr)=""
	}
	s obj=##Class(CT.DOC.Order.RecDepHolidayDetails).%OpenId(ID)
	if ('$isobject(obj)){
		q "-1^更新失败"
	}
	
	s key="",sc=$$$YES
	while (obj.RDHExceptionArcimDr'="" && obj.RDHExceptionArcimDr.GetNext(.key) && ($$$ISOK(sc))){
		s ArcimDr=obj.RDHExceptionArcimDr.GetAt(key)
		if (ArcimDr=""){
			continue
		}
		if ($D(ArcimArr(ArcimDr))){
			k ArcimArr(ArcimDr)
		}else{
			d obj.RDHExceptionArcimDr.RemoveAt(key)
			s key=obj.RDHExceptionArcimDr.Previous(key)
		}
	}
	s ArcimDr=0
	for {
		s ArcimDr=$O(ArcimArr(ArcimDr))
		q:(ArcimDr="")
		d obj.RDHExceptionArcimDr.Insert(ArcimDr)
	}
	s sc=obj.%Save()
	if ($$$ISERR(sc)){
		q "-1^操作数据失败:"_$G(%msg)

	}
	q 0
}

}

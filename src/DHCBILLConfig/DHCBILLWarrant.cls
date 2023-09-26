Import SQLUSER

/// Creator: xiongwang
/// CreateDate:	2017-08-18
/// Function: 担保额度设置
Class DHCBILLConfig.DHCBILLWarrant Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLWarrant","FindLoc", "")
Query FindLoc(desc As %String, hospId As %String) As websys.Query(ROWSPEC = "LocRowid:%String,LocDesc:%String")
{
}

ClassMethod FindLocExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
	Set ^TMP("FindLoc")=$lb(desc, hospId)

	If (desc'="") Set desc=$$ALPHAUP^SSUTIL4(desc)
	
    Set rowid=0
    For  Set rowid=$o(^CTLOC(rowid)) Quit:(rowid="")  Do
    .Set locType=$p(^CTLOC(rowid),"^",13)
    .Quit:(" E OP W "'[(" "_locType_" "))
    .Set wardFlag=$p(^CTLOC(rowid),"^",5)
    .Quit:(wardFlag="Y")
 	.Set dateFrom=$p(^CTLOC(rowid),"^",24)
	.Set dateTo=$p(^CTLOC(rowid),"^",25)
	.Quit:((dateFrom'="")&&(dateFrom>+$h))
	.Quit:((dateTo'="")&&(dateTo<+$h))          //+2018-01-16 ZhYW 过滤不在有效期的
	.Set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", rowid, hospId)
	.Quit:(showFlag="N")
 	.Set ctContactName=$p(^CTLOC(rowid),"^",43)   //科室检索码
    .Set ctContactName=$$ALPHAUP^SSUTIL4(ctContactName)
    .Set ctdesc=$p(^CTLOC(rowid),"^",2)
    .Quit:((desc'="")&&(ctContactName'[desc)&&(ctdesc'[desc))
	.Do OutputLoc

	Quit $$$OK
OutputLoc
	Set Data=$lb(rowid,ctdesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// do ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLWarrant","FindAdmReason","", "", "2")
Query FindAdmReason(Code As %String, Desc As %String, HospId As %String) As websys.Query(ROWSPEC = "RowID:%String,REACode:%String,READesc:%String,READateFrom:%String,READateTo:%String,REANationalCode:%String,REAAdmSource:%String")
{
}

ClassMethod FindAdmReasonExecute(ByRef qHandle As %Binary, Code As %String, Desc As %String, HospId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    If ((Code="")&&(Desc="")) Do
	.Set RowID=0
	.For  Set RowID=$O(^PAC("ADMREA",RowID)) Quit:(RowID="")  Do
	..Do GetAdmReason(RowID)
	If (Code'="") Do
	.Set OldCode=Code,Code=$O(^PAC("ADMREA",0,"Code",Code),-1)
	.If  Set Code=$O(^PAC("ADMREA",0,"Code",Code)) Quit:(Code="")||($E(Code,1,$L(OldCode))'=OldCode)  Do
	..Set RowID=0
	..For  Set RowID=$o(^PAC("ADMREA",0,"Code",Code,RowID)) Quit:(RowID="")  Do
	...d GetAdmReason(RowID) 
	Else  If (Desc'="") Do
	.Set OldDesc=Desc,Desc=$o(^PAC("ADMREA",0,"Desc",Desc),-1)
	.For  Set Desc=$o(^PAC("ADMREA",0,"Desc",Desc)) Quit:(Desc="")||($E(Desc,1,$L(OldDesc))'=OldDesc)  Do
	..Set RowID=0
	..For  Set RowID=$o(^PAC("ADMREA",0,"Desc",Desc,RowID)) Quit:RowID=""  Do
	...Do GetAdmReason(RowID)

	Quit $$$OK

GetAdmReason(RowID)
    Set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("PAC_AdmReason", RowID, HospId)
    Quit:(ShowFlag="N")
    Set REACode=$p(^PAC("ADMREA",RowID),"^",1)
    Set READesc=$p(^PAC("ADMREA",RowID),"^",2)
    Set READateFrom=$p(^PAC("ADMREA",RowID),"^",3)
    Quit:((READateFrom'="")&&(READateFrom>+$h))
    If (READateFrom'="") Set READateFrom=##class(websys.Conversions).DateLogicalToHtml(READateFrom)
    Set READateTo=$p(^PAC("ADMREA",RowID),"^",4)
	Quit:((READateTo'="")&&(READateTo<+$h))
    If (READateTo'="") Set READateTo=##class(websys.Conversions).DateLogicalToHtml(READateTo)
    Set REANationalCode=$p(^PAC("ADMREA",RowID),"^",5)
    Set REAAdmSource=$p(^PAC("ADMREA",RowID),"^",9)
    Do OutputAdmReason
    Quit
OutputAdmReason
	Set Data=$lb(RowID,REACode,READesc,READateFrom,READateTo,REANationalCode,REAAdmSource)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLWarrant","FindWarantLocLimit","^")
Query FindWarantLocLimit(ExpStr As %String) As websys.Query(ROWSPEC = "JFWLLRowID:%String,JFWLLLocDesc:%String,JFWLLAdmReasonDesc:%String,JFWLLTimeLimitTypeDesc:%String,JFWLLTimeLimit:%String,JFWLLLimitAmount:%String,JFWLLUserDR:%String,JFWLLDate:%String,JFWLLTime:%String,JFWLLLocDR:%String,JFWLLAdmReasonDR:%String,JFWLLTimeLimitType:%String")
{
}

ClassMethod FindWarantLocLimitExecute(ByRef qHandle As %Binary, ExpStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
	set LocId=$p(ExpStr,"^",1)
	set AdmReaId=$p(ExpStr,"^",2)
	set HospId=$p(ExpStr,"^",3)
	
	Set rtn=$$OPEN^DHCJFWarrantLocLimit()
	If (+rtn) Quit $$$OK
	Do{
		Set rtn=$$FETCH^DHCJFWarrantLocLimit()
	    Do GetLocExpt
	}While(rtn=0)
    Set rtn=$$CLOSE^DHCJFWarrantLocLimit()

	Quit $$$OK
GetLocExpt
	Quit:$d(PLIST)=0
	Quit:PLIST=1
	Set JFWLLRowID=PLIST(1)
	Set JFWLLLocDR=PLIST(2)
	Set JFWLLLocDesc=JFWLLLocDR
	Quit:((LocId'="")&&(JFWLLLocDR'=LocId))
	Set JFWLLLocDesc=$s((+JFWLLLocDR'=0):$p($g(^CTLOC(JFWLLLocDR)),"^",2),1:"")
	Set JFWLLAdmReasonDR=PLIST(3)
	Quit:((AdmReaId'="")&&(JFWLLAdmReasonDR'=AdmReaId))
	Set JFWLLAdmReasonDesc=$s((+JFWLLAdmReasonDR'=0):$p($g(^PAC("ADMREA",JFWLLAdmReasonDR)),"^",2),1:"")
	Set JFWLLTimeLimitType=PLIST(4)
	Set JFWLLTimeLimitTypeDesc=""
	Set:(JFWLLTimeLimitType="D") JFWLLTimeLimitTypeDesc="按天"
	Set:(JFWLLTimeLimitType="H") JFWLLTimeLimitTypeDesc="按时"
	Set JFWLLTimeLimit=PLIST(5)
	Set JFWLLLimitAmount=PLIST(6)
	Set JFWLLUserDR=PLIST(7)
	Set JFWLLDate=PLIST(8)
	Set JFWLLTime=PLIST(9)
	Set JFWLLHospDr=PLIST(10)
	Quit:(JFWLLHospDr'=HospId)
	Do OutputRowLocLimit
	
	Quit
OutputRowLocLimit
	Set Data=$lb(JFWLLRowID,JFWLLLocDesc,JFWLLAdmReasonDesc,JFWLLTimeLimitTypeDesc,JFWLLTimeLimit,JFWLLLimitAmount,JFWLLUserDR,JFWLLDate,JFWLLTime,JFWLLLocDR,JFWLLAdmReasonDR,JFWLLTimeLimitType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// Debug: w ##class(DHCBILLConfig.DHCBILLWarrant).InsertWarrantLocLimit("^3^1^D^1.00^3.00","1","2")
ClassMethod InsertWarrantLocLimit(LocLimitInfo, Guser, HospID)
{
	New (LocLimitInfo, Guser, HospID)
	Set ^TMP=$lb(LocLimitInfo, Guser, HospID)
	Set JFWLLRowID=""
	Set JFWLLLocDR=$p(LocLimitInfo,"^",2)
	Set JFWLLAdmReason=$p(LocLimitInfo,"^",3)
	Set JFWLLTimeLimitType=$p(LocLimitInfo,"^",4)
	Set JFWLLTimeLimit=$p(LocLimitInfo,"^",5)
	Set JFWLLLimitAmount=$p(LocLimitInfo,"^",6)
	
	Kill PLIST
	Set PLIST(2)=JFWLLLocDR
	Set PLIST(3)=JFWLLAdmReason
	Set PLIST(4)=JFWLLTimeLimitType
	Set PLIST(5)=JFWLLTimeLimit
	Set PLIST(6)=JFWLLLimitAmount
	Set PLIST(7)=Guser
	Set PLIST(8)=+$h
	Set PLIST(9)=$p($h,",",2)
	Set PLIST(10)=HospID
	Set rtn=$$INSERT^DHCJFWarrantLocLimit()
	If (rtn=-100) Set rtn=-100_"^"_"数据重复"

	If (+rtn=0) Do
	.Set TableName="DHC_JFWarrantLocLimit",ClassName="User.DHCJFWarrantLocLimit",TableDesc="担保额度设置",InsRowid=%ROWID
	.Set JsonStr="{JFWLLRowID:"_InsRowid
	.Set JsonStr=JsonStr_",JFWLLLocDR:"_JFWLLLocDR
	.Set JsonStr=JsonStr_",JFWLLAdmReasonDR:"_JFWLLAdmReason
	.Set JsonStr=JsonStr_",JFWLLTimeLimitType:"_JFWLLTimeLimitType
	.Set JsonStr=JsonStr_",JFWLLTimeLimit:"_JFWLLTimeLimit
	.Set JsonStr=JsonStr_",JFWLLLimitAmount:"_JFWLLLimitAmount
	.Set JsonStr=JsonStr_",JFWLLUserDR:"_Guser
	.Set JsonStr=JsonStr_",JFWLLDate:"_+$h
	.Set JsonStr=JsonStr_",JFWLLTime:"_$p($h,",",2)_"}"
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(TableName, ClassName, TableDesc, InsRowid, "", "A", JsonStr)
	
	Quit rtn
}

/// Debug: w ##class(DHCBILLConfig.DHCBILLWarrant).UpdateWarrantLocLimit("67^94^1^D^0^1e+33","1","2")
ClassMethod UpdateWarrantLocLimit(LocLimitInfo, Guser, HospID)
{
	New (LocLimitInfo, Guser, HospID)
	Set ^TMP("UpdateWarrantLocLimit")=$lb(LocLimitInfo, Guser, HospID)
	Set JFWLLRowID=$p(LocLimitInfo,"^",1)
	Set JFWLLLocDR=$p(LocLimitInfo,"^",2)
	set JFWLLAdmReason=$p(LocLimitInfo,"^",3)
	Set JFWLLTimeLimitType=$p(LocLimitInfo,"^",4)
	Set JFWLLTimeLimit=$p(LocLimitInfo,"^",5)
	Set JFWLLLimitAmount=$p(LocLimitInfo,"^",6)
	
	Set OldJFWLLLocDR=$p(^DHCJFWARRANTLOCLIMIT(JFWLLRowID),"^",1)
	Set OldJFWLLAdmReason=$p(^DHCJFWARRANTLOCLIMIT(JFWLLRowID),"^",2)
	Set OldJFWLLTimeLimitType=$p(^DHCJFWARRANTLOCLIMIT(JFWLLRowID),"^",3)
	Set OldJFWLLTimeLimit=$p(^DHCJFWARRANTLOCLIMIT(JFWLLRowID),"^",4)
	Set OldJFWLLLimitAmount=$p(^DHCJFWARRANTLOCLIMIT(JFWLLRowID),"^",6)
	Set OldGuser=$p(^DHCJFWARRANTLOCLIMIT(JFWLLRowID),"^",6)
	Set OldDate=$p(^DHCJFWARRANTLOCLIMIT(JFWLLRowID),"^",7)
	Set OldTime=$p(^DHCJFWARRANTLOCLIMIT(JFWLLRowID),"^",8)
	
	Kill PLIST
	Set PLIST(2)=JFWLLLocDR
	Set PLIST(3)=JFWLLAdmReason
	Set PLIST(4)=JFWLLTimeLimitType
	Set PLIST(5)=JFWLLTimeLimit
	Set PLIST(6)=JFWLLLimitAmount
	Set PLIST(7)=Guser
	Set PLIST(8)=+$h
	Set PLIST(9)=$p($h,",",2)
	Set PLIST(10)=HospID
	Set rtn=$$UPDATE^DHCJFWarrantLocLimit(JFWLLRowID)
	If (rtn=-100) Set rtn=-100_"^"_"数据重复"

	If (+rtn=0) Do
	.Set TableName="DHC_JFWarrantLocLimit",ClassName="User.DHCJFWarrantLocLimit",TableDesc="担保额度设置",InsRowid=JFWLLRowID
	.Set JsonStr="{JFWLLRowID:"_InsRowid
	.Set JsonStr=JsonStr_",JFWLLLocDR:"_JFWLLLocDR
	.Set JsonStr=JsonStr_",JFWLLAdmReasonDR:"_JFWLLAdmReason
	.Set JsonStr=JsonStr_",JFWLLTimeLimitType:"_JFWLLTimeLimitType
	.Set JsonStr=JsonStr_",JFWLLTimeLimit:"_JFWLLTimeLimit
	.Set JsonStr=JsonStr_",JFWLLLimitAmount:"_JFWLLLimitAmount
	.Set JsonStr=JsonStr_",JFWLLUserDR:"_Guser
	.Set JsonStr=JsonStr_",JFWLLDate:"_+$h
	.Set JsonStr=JsonStr_",JFWLLTime:"_$p($h,",",2)_"}"
	.Set JsonStrOld="{JFWLLRowID:"_InsRowid
	.Set JsonStrOld=JsonStrOld_",JFWLLLocDR:"_OldJFWLLLocDR
	.Set JsonStrOld=JsonStrOld_",JFWLLAdmReasonDR:"_OldJFWLLAdmReason
	.Set JsonStrOld=JsonStrOld_",JFWLLTimeLimitType:"_OldJFWLLTimeLimitType
	.Set JsonStrOld=JsonStrOld_",JFWLLTimeLimit:"_OldJFWLLTimeLimit
	.Set JsonStr=JsonStr_",JFWLLLimitAmount:"_OldJFWLLLimitAmount
	.Set JsonStrOld=JsonStrOld_",JFWLLUserDR:"_OldGuser
	.Set JsonStrOld=JsonStrOld_",JFWLLDate:"_OldDate
	.Set JsonStrOld=JsonStrOld_",JFALETime:"_OldTime_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(TableName, ClassName, TableDesc, InsRowid, "", "U", JsonStr, JsonStrOld)

	Quit rtn
}

ClassMethod DeleteWarrantLocLimit(LocLimitInfo, Guser)
{
	New (LocLimitInfo, Guser)
	Set JFWLLRowID=$p(LocLimitInfo,"^",1)
	Set rtn=$$SELECT^DHCJFWarrantLocLimit(JFWLLRowID)
	Set JFWLLLocDR=PLIST(2)
	set JFWLLAdmReason=PLIST(3)
	Set JFWLLTimeLimitType=PLIST(4)
	Set JFWLLTimeLimit=PLIST(5)
	set JFWLLLimitAmount=PLIST(6)
	Set JFWLLUserDR=PLIST(7)
	Set JFWLLDate=PLIST(8)
	Set JFWLLTime=PLIST(9)
	Set rtn=$$DELETE^DHCJFWarrantLocLimit(JFWLLRowID)
	If (+rtn=0) Do
	.Set TableName="DHC_JFWarrantLocLimit",ClassName="User.DHCJFWarrantLocLimit",TableDesc="担保额度设置",InsRowid=%ROWID
	.Set JsonStr="{JFWLLRowID:"_InsRowid
	.Set JsonStr=JsonStr_",JFWLLLocDR:"_JFWLLLocDR
	.Set JsonStr=JsonStr_",JFWLLAdmReasonDR:"_JFWLLAdmReason
	.Set JsonStr=JsonStr_",JFWLLTimeLimitType:"_JFWLLTimeLimitType
	.Set JsonStr=JsonStr_",JFWLLTimeLimit:"_JFWLLTimeLimit
	.Set JsonStr=JsonStr_",JFWLLLimitAmount:"_JFWLLLimitAmount
	.Set JsonStr=JsonStr_",JFWLLUserDR:"_Guser
	.Set JsonStr=JsonStr_",JFWLLDate:"_JFWLLDate
	.Set JsonStr=JsonStr_",JFWLLTime:"_JFWLLTime_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(TableName, ClassName, TableDesc, InsRowid, "", "D", JsonStr)

	Quit rtn
}

}

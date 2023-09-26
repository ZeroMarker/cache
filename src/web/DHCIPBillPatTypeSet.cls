Import SQLUser

/// Creator：Lid
/// CreatDate：2008-10-30
/// Description: 病人费用类型配置业务
Class web.DHCIPBillPatTypeSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCIPBillPatTypeSet","FindSSGRP","",2)
Query FindSSGRP(SSGrp As %String, HospId As %String) As websys.Query(ROWSPEC = "group:%String:安全组,rowid:%String:ID")
{
}

ClassMethod FindSSGRPExecute(ByRef qHandle As %Binary, SSGrp As %String, HospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ^TMP("FindSSGRP")=$lb(SSGrp, HospId)
	set ind=1
	
	if (SSGrp'="") do
    .set SSGrp=$$ALPHAUP^SSUTIL4(SSGrp)
    
	set rowid=0
	for  set rowid=$o(^SSU("SSGRP",rowid)) quit:(rowid="")  do
	.set name=$p(^SSU("SSGRP",rowid),"^",1)
	.quit:((SSGrp'="")&&($$ALPHAUP^SSUTIL4(name)'[SSGrp))
	.set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_Group", rowid, HospId)
	.quit:(showFlag="N")
	.do OutPutSSGRP
	
	quit $$$OK
OutPutSSGRP
    set Data=$lb(name,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCIPBillPatTypeSet","FindAdmReason","")
Query FindAdmReason(HospId As %String) As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindAdmReasonExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
   	set rowId=0
	for  set rowId=$O(^PAC("ADMREA",rowId)) quit:(rowId="")  do
    .set reaDesc=$p(^PAC("ADMREA",rowId),"^",2)
    .set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("PAC_AdmReason", rowId, HospId)
	.quit:(showFlag="N")
    .set reaDateFrom=$p(^PAC("ADMREA",rowId),"^",3)
    .set reaDateTo=$p(^PAC("ADMREA",rowId),"^",4)
    .do OutputAdmReason
	
	quit $$$OK
OutputAdmReason
	set Data=$lb(rowId,reaDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator： Lid
/// CreatDate： 2008-10-30
/// Description: 查询结果
/// Table： DHC_JFSSGrpAdmReasonConfig, SS_Group, PAC_AdmReason
/// Input： UserGrp:安全组ID     
/// Return： rowid:RowID,grp:安全组, pattype:病人费用类型,def:默认值
/// d ##class(%ResultSet).RunQuery("web.DHCIPBillPatTypeSet","FindGrpPatType","238","2")
Query FindGrpPatType(UserGrp As %String, HospId As %String) As websys.Query(ROWSPEC = "rowid:%String,grpDr:%String,grp:%String,admReaDr:%String,pattype:%String,def:%String,TBillNotPrint:%String")
{
}

ClassMethod FindGrpPatTypeExecute(ByRef qHandle As %Binary, UserGrp As %String, HospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	s ^TMP("FindGrpPatType")=$lb(UserGrp, HospId)
	if (UserGrp="") do
	.set rowid=0
	.for  set rowid=$o(^DHCJFSSGRPADMREASONCONFIG(rowid)) quit:(rowid="")  do
	..set tmp=$g(^DHCJFSSGRPADMREASONCONFIG(rowid))
	..quit:(tmp="")
	..do GetOutput
	else  do
	.set rowid=0
	.for  set rowid=$o(^DHCJFSSGRPADMREASONCONFIG(0,"SSGrp",UserGrp,rowid)) quit:(rowid="")  do
	..set tmp=$g(^DHCJFSSGRPADMREASONCONFIG(rowid))
	..quit:(tmp="")
	..do GetOutput
	
	quit $$$OK
GetOutput
	set grpDr=$p(tmp,"^",1)   //GrpRea_SSGrp_Dr
	quit:(+grpDr=0)
	set grpDesc=$p(^SSU("SSGRP",grpDr),"^",1)
	set admReaDr=$p(tmp,"^",2)
	set patType=$P(^PAC("ADMREA",admReaDr),"^",2)
	set defFlag=$p(tmp,"^",3)
	set billNotPrint=$p(tmp,"^",4)
	set hospDR=$p(tmp,"^",6)
	quit:(HospId'=hospDR)
	do OutPutGrpPatType
	quit
OutPutGrpPatType
    set Data=$lb(rowid,grpDr,grpDesc,admReaDr,patType,defFlag,billNotPrint)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 添加
ClassMethod AddInfo(Grp As %String, PatType As %String, Default As %String, billNotPrintFlag As %String, HospId As %String) As %String
{
	new (Grp, PatType, Default, billNotPrintFlag, HospId)
	&sql(INSERT INTO DHC_JFSSGrpAdmReasonConfig(GrpRea_SSGrp_Dr,GrpRea_AdmReason_Dr,GrpRea_DefaultAdmReason,GrpRea_Comment1,GrpRea_Hosp_Dr) 
	VALUES(:Grp,:PatType,:Default,:billNotPrintFlag,:HospId))
    quit SQLCODE
}

/// 删除
ClassMethod DelInfo(rowid As %Library.String)
{
   &sql(DELETE FROM  DHC_JFSSGrpAdmReasonConfig WHERE GrpRea_RowId=:rowid)
   q SQLCODE
}

/// Creator: Lid
/// CreatDate: 2008-10-30
/// Description: 验证记录是否存在, 判断是否已存在默认
/// Table: DHC_JFSSGrpAdmReasonConfig
/// Input: grp:安全组ID，patType:病人类型ID，default:默认值      
/// Return: 存在返回0，不存在返回1
/// Debug: w ##class(web.DHCIPBillPatTypeSet).CheckInfo("129","241","7","Y","2")
ClassMethod CheckInfo(grpReaId As %String, grp As %String, patType As %String, default As %String, hospId As %String)
{
	n (grpReaId, grp, patType, default, hospId)
	s ^TMP("CheckInfo")=$lb(grpReaId, grp, patType, default, hospId)
	s rtn=0
	s rowId=0
	f  s rowId=$o(^DHCJFSSGRPADMREASONCONFIG(0,"SSGrp",grp,rowId)) q:((rowId="")||(rtn'=0))  d
	.q:(grpReaId=rowId)
	.s tmp=$g(^DHCJFSSGRPADMREASONCONFIG(rowId))
	.q:(tmp="")
	.s myHospDR=$p(tmp,"^",6)
	.q:(myHospDR'=hospId)
	.s myDefFlag=$p(tmp,"^",3)
	.i ((default="Y")&&(myDefFlag="Y")) d
	..s rtn=2
	.q:(+rtn)
	.s myAdmReaDR=$p(tmp,"^",2)
	.q:(myAdmReaDR'=patType)
	.s myDefFlag=$p(tmp,"^",3)
	.s rtn=1

	q rtn
}

/// Creator: wanghuicai
/// CreatDate：2009-5-11
/// Description: 更新表DHC_JFSSGrpAdmReasonConfig
/// Table: DHC_JFSSGrpAdmReasonConfig
/// Input： ObjRoeId:DHC_JFSSGrpAdmReasonConfig表rowid,grp:安全组desc，patType:病人类型desc，default:默认值,billNotPrintFlag:不打印标志     
/// Return： SQLCODE
ClassMethod updateInfo(ObjRoeId As %String, grpId As %String, admReaId As %String, deft As %String, billNotPrintFlag As %String)
{
	new (ObjRoeId, grpId, admReaId, deft, billNotPrintFlag)
	
	quit:$d(^DHCJFSSGRPADMREASONCONFIG(ObjRoeId))=0 -1
	&sql(UPDATE DHC_JFSSGrpAdmReasonConfig SET
		 GrpRea_SSGrp_Dr=:grpId, GrpRea_AdmReason_Dr=:admReaId,
		 GrpRea_DefaultAdmReason=:deft, GrpRea_Comment1=:billNotPrintFlag
		 WHERE GrpRea_RowId=:ObjRoeId)
	quit SQLCODE
}

}

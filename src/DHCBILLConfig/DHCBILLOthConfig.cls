Import SQLUSER

/// Creator: TangTao
/// CreateDate:	2014-04-13
/// Function: 其他设置
Class DHCBILLConfig.DHCBILLOthConfig Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLOthConfig","FindGroup","")
Query FindGroup(Grp As %String, HospId As %String) As websys.Query(ROWSPEC = "TGrpRowid:%String,TGrpFesc:%String")
{
}

ClassMethod FindGroupExecute(ByRef qHandle As %Binary, Grp As %String, HospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1

	Set grpId=0
	For  Set grpId=$o(^SSU("SSGRP",grpId)) Quit:(grpId="")  Do
	.Set grpData=$g(^SSU("SSGRP",grpId))
	.Set isActive=$p(grpData,"^",151)
	.Quit:(isActive="N")
	.Set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_Group", grpId, HospId)
	.Quit:(showFlag="N")
	.Set grpDesc=$p(grpData,"^",1)
	.Quit:((Grp'="")&&($zcvt(grpDesc,"U")'[$zcvt(Grp,"U")))
	.Do OutputGrpList
	
	Quit $$$OK
OutputGrpList
	set Data=$lb(grpId,grpDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLOthConfig","FindGroupUser",1,"","2")
Query FindGroupUser(Grp As %String, Usr As %String, HospId As %String) As websys.Query(ROWSPEC = "TUsrRowid:%String,TUsrName:%String")
{
}

ClassMethod FindGroupUserExecute(ByRef qHandle As %Binary, Grp As %String, Usr As %String, HospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1

	If (Grp="") Do
	.Set userId=0
	.For  Set userId=$o(^SSU("SSUSR",userId)) Quit:(userId="")  Do
	..Set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_User", userId, HospId)
	..Quit:(showFlag="N")
	..Set userData=$g(^SSU("SSUSR",userId))
	..Set isActive=$p(userData,"^",19)
	..Quit:(isActive'="Y")
	..Set dateFrom=$p(userData,"^",96)
	..Set dateTo=$p(userData,"^",97)
	..Quit:((dateFrom'="")&&(dateFrom>+$h))
	..Quit:((dateTo'="")&&(dateTo<+$h))
	..Set usrname=$p(userData,"^",2)
	..Quit:((Usr'="")&&(usrname'[Usr))
	..Do OutputGrpUsr
	If (Grp="")  Quit $$$OK
	
	Kill UserArray
	Set userId=0
	For  Set userId=$o(^SSU("SSUSR",userId)) Quit:(userId="")  Do
	.Set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_User", userId, HospId)
	.Quit:(showFlag="N")
	.Set userData=$g(^SSU("SSUSR",userId))
	.Set isActive=$p(userData,"^",19)
	.Quit:(isActive'="Y")
	.Set dateFrom=$p(userData,"^",96)
	.Set dateTo=$p(userData,"^",97)
	.Quit:((dateFrom'="")&&(dateFrom>+$h))
	.Quit:((dateTo'="")&&(dateTo<+$h))
	.Set DefaultGrp=$p(userData,"^",5)
	.If (DefaultGrp=Grp) Do
	..Set usrname=$p(userData,"^",2)
	..Quit:((Usr'="")&&(usrname'[Usr))
	..Quit:$d(UserArray(userId))
	..Set UserArray(userId)=userId
	..Do OutputGrpUsr
	.Else  Do
	..Set Sub=0
	..For  Set Sub=$o(^SSU("SSUSR",userId,"OTHLL",Sub)) Quit:(Sub="")  Do
	...Set usrgrp=$p(^SSU("SSUSR",userId,"OTHLL",Sub),"^",2)
	...Quit:((Grp'="")&&(Grp'=usrgrp))
	...Set usrname=$p(^SSU("SSUSR",userId),"^",2)
	...Quit:((Usr'="")&&(usrname'[Usr))
	...Quit:$d(UserArray(userId))
	...Set UserArray(userId)=userId
	...Do OutputGrpUsr

	Quit $$$OK
OutputGrpUsr
	Set Data=$lb(userId,usrname)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLOthConfig","FindRcptGrpUser","A","",2)
Query FindRcptGrpUser(RcptType As %String, RcptGrpType As %String, HospId As %String) As websys.Query(ROWSPEC = "TRcptUsrName:%String,TRcptUsrGrp:%String,TRcptUsrRowid:%String,TRcptUsrGrpRowid:%String,TGrpUsrRowid:%String")
{
}

ClassMethod FindRcptGrpUserExecute(ByRef qHandle As %Binary, RcptType As %String, RcptGrpType As %String, HospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
	If ((RcptType="")||(RcptGrpType="")) Quit $$$OK
	
	Set rowid=$o(^DHCJFRcptGroupSet(0,"Type",RcptType,RcptGrpType,0))
	if (rowid="")  Quit $$$OK
	
	Set sub=0
	For  Set sub=$o(^DHCJFRcptGroupSet(rowid,"Sub",sub)) Quit:(sub="")  Do
	.Set data=$g(^DHCJFRcptGroupSet(rowid,"Sub",sub))
	.Quit:(data="")
	.Set grpusrrowid=rowid_"||"_sub
	.Set usrgrprowid=$p(data,"^",3)
	.Quit:(+usrgrprowid=0)
	.Set userId=$p(data,"^",4)
	.Quit:(+userId=0)
	.Set usrHospDR=$p(data,"^",5)
	.Quit:(usrHospDR'=HospId)
	.Set usrname=$p($g(^SSU("SSUSR",userId)),"^",2)
	.Set usrgrp=$p($g(^SSU("SSGRP",usrgrprowid)),"^",1)
	.Do OutputGrpUser
	
	Quit $$$OK
OutputGrpUser
	Set Data=$lb(usrname,usrgrp,userId,usrgrprowid,grpusrrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLOthConfig","FindBillType")
Query FindBillType() As websys.Query(ROWSPEC = "BillRowid:%String,BillVal:%String,BillDesc:%String")
{
}

ClassMethod FindBillTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
	Set Rowid=0
	For  Set Rowid=$o(^DHCJFBILLADMREACON(Rowid)) Quit:(Rowid="")  Do
	.Set BillDesc=$p($g(^DHCJFBILLADMREACON(Rowid)),"^",2)
	.Set BillVal=$p($g(^DHCJFBILLADMREACON(Rowid)),"^",3)
	.Set BillVal=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(BillVal)
	.Set BillDesc=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(BillDesc)
	.Do OutputBillType
	Quit $$$OK
OutputBillType
	Set Data=$lb(Rowid,BillVal,BillDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// w ##class(DHCBILLConfig.DHCBILLOthConfig).InsertGrpUser("1^1^11914^A^2","1")
ClassMethod InsertGrpUser(GrpInfo, Guser)
{
	New (GrpInfo, Guser)
	Set ^TMP("InsertGrpUser")=$lb(GrpInfo, Guser)
	Set UserType=$p(GrpInfo,"^",1)
	Set GrpGroup=$p(GrpInfo,"^",2)
	Set GrpUsr=$p(GrpInfo,"^",3)
	Set GrpType=$p(GrpInfo,"^",4)
	Set GrpHosp=$p(GrpInfo,"^",5)
	Quit:(UserType="") """"_"人员类型为空,不能添加!"_""""
	Quit:(GrpGroup="") """"_"安全组为空,不能添加!"_""""
	Quit:(GrpUsr="") """"_"人员为空,不能添加!"_""""
	Set rtn=..JudgeGrpUser(UserType, GrpUsr, GrpType, GrpHosp)
	Quit:(rtn'=0) """"_"此用户已经添加过,不能再次添加!"_""""

	Set rtn=0
	Set Typerowid=$$gettype^DHCJFRcptUserSet(GrpType, UserType)
	
	If (Typerowid="") Do
	.Set ExpStr=GrpType_"^"_UserType
	.Set rtn=$$insertgrp^DHCJFRcptUserSet(ExpStr)
	.Quit:(rtn'=0)
	.Set Typerowid=P4
	.;
	.Set Flag2="DHC_JFRcptGroupSet",UserTable="User.DHCJFRcptGroupSet",TableDesc="押金收据与发票类型设置",InsRowid=Typerowid
	.Set JsonStr="{grprowid:"_InsRowid_",grprcpttype:"_GrpType_",grprcptgrptype:"_UserType_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "插入", "A", JsonStr)

	Quit:(rtn'=0) """"_"插入类型主表失败!"_""""
	
	Set ExpStr=Typerowid_"^"_GrpGroup_"^"_GrpUsr_"^"_GrpHosp
	Set DefaultGrp=$p(^SSU("SSUSR",GrpUsr),"^",5)	;保存收费员的默认安全组
	If (DefaultGrp'="") Set GrpGroup=DefaultGrp
	Set rtn=$$insertuser^DHCJFRcptUserSet(ExpStr)
	Quit:(rtn'=0) """"_"插入子表失败!"_""""
	
	; grpuserparref, grpuserrowid, grpuserssgrpdr, grpuserssusrdr, grpuserchildsub
	Set Flag2="DHC_JFRcptGroupUser",UserTable="User.DHCJFRcptGroupUser",TableDesc="押金发票类型与人员设置",InsRowid=%ROWID
	Set JsonStr="{grpuserparref:"_Typerowid_",grpuserrowid:"_InsRowid_",grpuserssgrpdr:"_GrpGroup_",grpuserssusrdr:"_GrpUsr_"}" 
	Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "插入", "A", JsonStr)
	
	Quit """"_rtn_""""
}

ClassMethod DeleteGrpUser(GrpInfo, Guser)
{
	New (GrpInfo, Guser)
	Set UserType=$p(GrpInfo,"^",1)
	Set GrpGroup=$p(GrpInfo,"^",2)
	Set GrpUsr=$p(GrpInfo,"^",3)
	Set GrpType=$p(GrpInfo,"^",4)
	Set RcptUserSetRowid=$p(GrpInfo,"^",5)
	Set Typerowid=$$gettype^DHCJFRcptUserSet(GrpType, UserType)

	Set rtn=$$deleteuser^DHCJFRcptUserSet(RcptUserSetRowid)
	If (+rtn=0) Do
	.Set Flag2="DHC_JFRcptGroupUser",UserTable="User.DHCJFRcptGroupUser",TableDesc="押金发票类型与人员设置",InsRowid=RcptUserSetRowid
	.Set JsonStr="{grpuserparref:"_Typerowid_",grpuserrowid:"_InsRowid_",grpuserssgrpdr:"_GrpGroup_",grpuserssusrdr:"_GrpUsr_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "删除", "D", JsonStr)
	
	Quit """"_rtn_""""
}

ClassMethod JudgeGrpUser(UserType As %String, GrpUsr As %String, GrpType As %String, GrpHosp As %String) As %String
{
	new (UserType, GrpUsr, GrpType, GrpHosp)
	set flag=0

	set rowid=$o(^DHCJFRcptGroupSet(0,"Type",GrpType,UserType,""))
	quit:(rowid="") flag
	
	set sub=0
	for  set sub=$o(^DHCJFRcptGroupSet(rowid,"Sub",sub)) quit:((sub="")||(flag'=0))  do
	.set data=$g(^DHCJFRcptGroupSet(rowid,"Sub",sub))
	.quit:(data="")
	.set userDR=$p(data,"^",4)
	.quit:(GrpUsr'=userDR)
	.set hospDR=$p(data,"^",5)
	.quit:(hospDR'=GrpHosp)
	.set flag=1
	
	quit flag
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLOthConfig","FindDepRefReason",2)
Query FindDepRefReason(hospId As %String) As websys.Query(ROWSPEC = "TRefCode:%String,TRefDesc:%String,TRefStdate:%String,TRefEnddate:%String,TRefflagdesc:%String,TRowid:%String,TRefflag:%String,TRefHospDR:%String")
{
}

ClassMethod FindDepRefReasonExecute(ByRef qHandle As %Binary, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set rowid=0
	for  set rowid=$o(^DHCJFYJRREASON(rowid)) quit:(rowid="")  do
	.set data=$g(^DHCJFYJRREASON(rowid))
	.quit:(data="")
	.set reahospdr=$p(data,"^",6)
	.quit:(reahospdr'=hospId)
	.set refcode=$p(data,"^",1)
	.set refdesc=$p(data,"^",2)
	.set refstdate=$p(data,"^",3)
	.set refstdate=##class(websys.Conversions).DateLogicalToHtml(refstdate)
	.set refenddate=$p(data,"^",4)
	.set refenddate=##class(websys.Conversions).DateLogicalToHtml(refenddate)
	.set refflag=$p(data,"^",5)
	.set refflagdesc=$s((refflag="N"):"停止",1:"正常")
	.do OutputRefDepReason
	
	quit $$$OK
OutputRefDepReason
	set Data=$lb(refcode,refdesc,refstdate,refenddate,refflagdesc,rowid,refflag,reahospdr)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod InsertRefDepReason(RefInfo, Guser)
{
	New (RefInfo, Guser)
	Set ReaCode=$p(RefInfo,"^",2)
	Set ReaDesc=$p(RefInfo,"^",3)
	Set ReaStDate=$p(RefInfo,"^",4)
	Set ReaEndDate=$p(RefInfo,"^",5)
	Set ReaFlag=$p(RefInfo,"^",6)
	If (ReaFlag="正常") Set ReaFlag="Y"
	If (ReaFlag="停止") Set ReaFlag="N"
	If (ReaFlag="") Set ReaFlag="Y"
	Set ReaHospDR=$p(RefInfo,"^",7)
	
	Quit:(ReaCode="") """"_"-1001代码为空!"_""""
	Quit:(ReaDesc="") """"_"-1002退押金原因为空!"_""""
	
	Set rtn=0
	Set myRowId=0
	For  Set myRowId=$o(^DHCJFYJRREASON(0,"desc",ReaDesc,myRowId)) Quit:((myRowId="")||(rtn'=0))  Do
	.Set data=$g(^DHCJFYJRREASON(myRowId))
	.Quit:(data="")
	.Set myHospDR=$p(data,"^",6)
	.Quit:(myHospDR'=ReaHospDR)
	.Set rtn=-1003
	Quit:(+rtn) """"_"-1003退押金原因重复!"_""""
	
	Set myRowId=0
	For  Set myRowId=$o(^DHCJFYJRREASON(0,"code",ReaCode,myRowId)) Quit:((myRowId="")||(rtn'=0))  Do
	.Set data=$g(^DHCJFYJRREASON(myRowId))
	.Quit:(data="")
	.Set rtn=-1004
	Quit:(+rtn) """"_"-1004代码重复!"_""""

	Set RefInfo=ReaCode_"^"_ReaDesc_"^"_ReaStDate_"^"_ReaEndDate_"^"_ReaFlag_"^"_ReaHospDR
	Set rtn=$$insertyjref^DHCJFYJRefReason(RefInfo)

	If (+rtn=0) Do
	.Set Flag2="dhc_jfyjrefreason",UserTable="User.dhcjfyjrefreason",TableDesc="退押金原因设置",InsRowid=P9
	.Set JsonStr="{yjrrearowid:"_InsRowid_",yjrreacode:"_ReaCode_",yjrreadesc:"_ReaDesc
	.Set JsonStr=JsonStr_",yjrreastdate:"_ReaStDate_",yjrreaenddate:"_ReaEndDate_",yjrreaflag:"_ReaFlag_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "插入", "A", JsonStr)

	Quit """"_rtn_""""
}

ClassMethod UpdateRefDepReason(RefInfo, Guser)
{
	New (RefInfo, Guser)
	Set ReaRowid=$p(RefInfo,"^",1)
	Set ReaCode=$p(RefInfo,"^",2)
	Set ReaDesc=$p(RefInfo,"^",3)
	Set ReaStDate=$p(RefInfo,"^",4)
	Set ReaEndDate=$p(RefInfo,"^",5)
	Set ReaFlag=$p(RefInfo,"^",6)
	If (ReaFlag="正常") Set ReaFlag="Y"
	If (ReaFlag="停止") Set ReaFlag="N"
	If (ReaFlag="") Set ReaFlag="Y"
	Set ReaHospDR=$p(RefInfo,"^",7)
	
	Quit:(ReaCode="") """"_"-1001代码为空!"_""""
	Quit:(ReaDesc="") """"_"-1002退押金原因为空!"_""""
		
	Set rtn=0
	Set myRowId=0
	For  Set myRowId=$o(^DHCJFYJRREASON(0,"desc",ReaDesc,myRowId)) Quit:((myRowId="")||(rtn'=0))  Do
	.Quit:(myRowId=ReaRowid)
	.Set data=$g(^DHCJFYJRREASON(myRowId))
	.Quit:(data="")
	.Set myHospDR=$p(data,"^",6)
	.Quit:(myHospDR'=ReaHospDR)
	.Set rtn=-1003
	Quit:(+rtn) """"_"-1003退押金原因重复!"_""""
	
	Set myRowId=0
	For  Set myRowId=$o(^DHCJFYJRREASON(0,"code",ReaCode,myRowId)) Quit:((myRowId="")||(rtn'=0))  Do
	.Quit:(myRowId=ReaRowid)
	.Set data=$g(^DHCJFYJRREASON(myRowId))
	.Quit:(data="")
	.Set rtn=-1004
	Quit:(+rtn) """"_"-1004代码重复!"_""""
		
	Set OldReaCode=$p(^DHCJFYJRREASON(ReaRowid),"^",1)
	Set OldReaDesc=$p(^DHCJFYJRREASON(ReaRowid),"^",2)
	Set OldReaStDate=$p(^DHCJFYJRREASON(ReaRowid),"^",3)
	Set OldReaEndDate=$p(^DHCJFYJRREASON(ReaRowid),"^",4)
	Set OldReaFlag=$p(^DHCJFYJRREASON(ReaRowid),"^",5)
	
	Set RefInfo=ReaCode_"^"_ReaDesc_"^"_ReaStDate_"^"_ReaEndDate_"^"_ReaFlag_"^"_ReaRowid
	Set rtn=$$updateyjref^DHCJFYJRefReason(RefInfo)
	
	If (+rtn=0) Do
	.Set Flag2="dhc_jfyjrefreason",UserTable="User.dhcjfyjrefreason",TableDesc="退押金原因设置",InsRowid=ReaRowid
	.Set JsonStr="{yjrrearowid:"_InsRowid_",yjrreacode:"_ReaCode_",yjrreadesc:"_ReaDesc
	.Set JsonStr=JsonStr_",yjrreastdate:"_ReaStDate_",yjrreaenddate:"_ReaEndDate_",yjrreaflag:"_ReaFlag_"}" 
	.Set JsonStrOld="{yjrrearowid:"_InsRowid_",yjrreacode:"_OldReaCode_",yjrreadesc:"_OldReaDesc
	.Set JsonStrOld=JsonStrOld_",yjrreastdate:"_OldReaStDate_",yjrreaenddate:"_OldReaEndDate_",yjrreaflag:"_OldReaFlag_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "修改", "U", JsonStr, JsonStrOld)

	Quit """"_rtn_""""
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLOthConfig","FindPrintItmCat")
Query FindPrintItmCat(HospId As %String) As websys.Query(ROWSPEC = "TCatDesc:%String,TCatRowid:%String,TFlag:%String,TLinkRowid:%String")
{
}

ClassMethod FindPrintItmCatExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1

	Set rowid=0
	For  Set rowid=$o(^DHCJFORDITEMCATSET(rowid))  Quit:(rowid="")  Do
	.Set data=$g(^DHCJFORDITEMCATSET(rowid))
	.Quit:(data="")
	.Set myHospDR=$p(data,"^",3)
	.Quit:(myHospDR'=HospId)
	.Set catrowid=$p(data,"^",1)
	.Quit:(+catrowid=0)
	.Set catdesc=$p($g(^ARC("IC",catrowid)),"^",2)
	.Set flag=$p(data,"^",2)
	.If (flag="Y") Set flag="Yes"
	.If (flag="N") Set flag="No"
	.Do OutputItmCat
	Quit $$$OK
OutputItmCat
	Set Data=$lb(catdesc,catrowid,flag,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLOthConfig","FindPrintItmCat")
Query FindArcCat(HospId As %String) As websys.Query(ROWSPEC = "TQCatDesc:%String,TQRowid:%String")
{
}

ClassMethod FindArcCatExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1

	Set rowid=0
	For  Set rowid=$o(^ARC("IC",rowid)) Quit:(rowid="")  Do
	.Set data=$g(^ARC("IC",rowid))
	.Quit:(data="")
	.Set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat", rowid, HospId)
	.Quit:(showFlag="N")
	.Set catdesc=$p(data,"^",2)
	.Set catdesc=##class(DHCBILLConfig.DHCBILLFIND).TR(catdesc)
	.Set catdesc=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(catdesc)	
	.Do OutputArcCat
	
	Quit $$$OK
OutputArcCat
	Set Data=$lb(catdesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod InsertPrintArcItmCat(InsertInfo, Guser, HospID)
{
	New (InsertInfo, Guser, HospID)
	Set NewArcCat=$p(InsertInfo,"^",2)
	Set ActivFlag=$p(InsertInfo,"^",3)
	If (ActivFlag="Yes") Set ActivFlag="Y"
	If (ActivFlag="No") Set ActivFlag="N"
	If (ActivFlag="") Set ActivFlag="Y"
	
	Set Date=+$h, Time=$p($h,",",2)
	
	Set ArcCatLen=$l(NewArcCat,",")
	Set rtn=0, NotInsertInfo=""
	For i=1:1:ArcCatLen Do
	.Set ArcCat=$p(NewArcCat,",",i)
	.Quit:(+ArcCat=0)
	.Set Rowid=0, Flag=0
    .For  Set Rowid=$o(^DHCJFORDITEMCATSET(0,"ItemCat",ArcCat,Rowid)) Quit:((Rowid="")||(Flag'=0))  Do
    ..set HospDR=$p(^DHCJFORDITEMCATSET(Rowid),"^",3)
  	..quit:(HospDR'=HospID)
    ..Set Flag=1
    ..Set ItmCatDesc=$p(^ARC("IC",ArcCat),"^",2)
    ..If (NotInsertInfo="") Set NotInsertInfo=ItmCatDesc
    ..Else  Set NotInsertInfo=NotInsertInfo_","_ItmCatDesc
    .Quit:(Flag'=0)
	.Kill PLIST
	.Set PLIST(2)=ArcCat
	.Set PLIST(3)=ActivFlag
	.set PLIST(4)=HospID
	.Set rtn=$$INSERT^DHCJFOrdItemCatSet()
	
	.If (+rtn=0) Do
	..Set Flag2="DHC_JFOrdItemCatSet",UserTable="User.DHCJFOrdItemCatSet",TableDesc="打印医嘱项子类设置",InsRowid=%ROWID
	..Set JsonStr="{OrdItemCatRowId:"_InsRowid_",OrdItemCatParref:"_ArcCat_",OrdItemCatFlag:"_ActivFlag_"}" 
	..Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "插入", "A", JsonStr)

	Set rtn=rtn_"^"
	If (NotInsertInfo'="") Set rtn="-1003^以下子类已维护,不能再添加,其他子类维护成功:"_NotInsertInfo

	Quit """"_rtn_""""
}

ClassMethod DeletePrintArcItmCat(InsertInfo, Guser)
{
	New (InsertInfo, Guser)
	Set OrdItemCatRowId=$p(InsertInfo,"^",1)
	Set rtn=$$SELECT^DHCJFOrdItemCatSet(OrdItemCatRowId)
	Set ArcCat=PLIST(2)
	Set ActivFlag=PLIST(3)
	Set rtn=$$DELETE^DHCJFOrdItemCatSet(OrdItemCatRowId)
	If (+rtn=0) Do
	.Set Flag2="DHC_JFOrdItemCatSet",UserTable="User.DHCJFOrdItemCatSet",TableDesc="打印医嘱项子类设置",InsRowid=OrdItemCatRowId
	.Set JsonStr="{OrdItemCatRowId:"_InsRowid_",OrdItemCatParref:"_ArcCat_",OrdItemCatFlag:"_ActivFlag_"}" 
	.Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "删除", "D", JsonStr)

	Quit """"_rtn_""""
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLOthConfig","FindChangGroup")
Query FindChangGroup() As websys.Query(ROWSPEC = "TGrpDesc:%String,TGrpRowid:%String")
{
}

ClassMethod FindChangGroupExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
	
	Set Str=$g(^DHCIPBILLConfig("SSGroup"))
	If (Str="") Quit $$$OK
	
	Set len=$l(Str,"^")
	For i=1:1:len Do
	.Set GrpRowid=$p(Str,"^",i)
	.Set GrpDesc=$p(^SSU("SSGRP",GrpRowid),"^",1)
	.Do OutputChaGrp

	Quit $$$OK
OutputChaGrp
	Set Data=$lb(GrpDesc,GrpRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// w ##class(DHCBILLConfig.DHCBILLOthConfig).InsertComGrp(39,1,2,"Delete")
ClassMethod InsertComGrp(NewGrpInfo, Guser, HospID, InsFlag)
{
	Set Flag="SSGroup"
	Quit:NewGrpInfo="" """"_"安全组信息不能为空"_""""
	Set NewGrpInfo=$tr(NewGrpInfo,"""","")
	Kill GrpArray
	
	If InsFlag="Insert" Do
	.Set OldGrpInfo=$$GetConfigStr^DHCJFUNConfirmLoc(Flag)
	.Set Oldlen=$l(OldGrpInfo,"^")
	.For i=1:1:Oldlen Do
	..Set Group=$p(OldGrpInfo,"^",i)
	..Quit:(Group="")
	..Set GrpArray(Group)=Group
	.;
	.Set Newlen=$l(NewGrpInfo,",")
	.For i=1:1:Newlen Do
	..Set Group=$p(NewGrpInfo,",",i)
	..Quit:Group=""
	..Set GrpArray(Group)=Group
	Else  Do
	.Set OldGrpInfo=$$GetConfigStr^DHCJFUNConfirmLoc(Flag)
	.Set Oldlen=$l(OldGrpInfo,"^")
	.For i=1:1:Oldlen Do
	..Set Group=$p(OldGrpInfo,"^",i)
	..Quit:Group=""
	..Set GrpArray(Group)=Group
	.Set Newlen=$l(NewGrpInfo,",")
	.For i=1:1:Newlen Do
	..Set Group=$p(NewGrpInfo,",",i)
	..Quit:Group=""
	..Kill GrpArray(Group)

	Set Rowid=0, InsGrpStr=""
	For  Set Rowid=$o(GrpArray(Rowid)) Quit:(Rowid="")  Do
	.If (InsGrpStr="") Set InsGrpStr=Rowid
	.Else  Set InsGrpStr=InsGrpStr_"^"_Rowid
	
	Do InsIPLoc^DHCJFUNConfirmLoc(Flag,InsGrpStr)

	Set Flag2="^DHCIPBILLConfig(""SSGroup"")",UserTable="^DHCIPBILLConfig(""SSGroup"")",TableDesc="修改价格安全组设置",InsRowid=""
	Set JsonStr="{^DHCIPBILLConfig(""SSGroup""):"_InsGrpStr_"}" 
	Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2, UserTable, TableDesc, InsRowid, "插入", "A", JsonStr)

	Quit """"_0_""""
}

/// do ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLOthConfig","FindHospConfig")
Query FindHospConfig(hospId As %String) As websys.Query(ROWSPEC = "TConHospDesc:%String,TConHospRowID:%String")
{
}

ClassMethod FindHospConfigExecute(ByRef qHandle As %Binary, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	if (+hospId=0) quit $$$OK
	if '$d(^DHCJFHOSPRICEDATECONFIG("DHCBILL",hospId)) quit $$$OK
	set hospDesc=$p($g(^CT("HOSP",hospId)),"^",2)
	do OutputHospCon
	quit $$$OK
OutputHospCon
	set Data=$lb(hospDesc,hospId)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod InsertHospConfig(HospStr, Guser)
{
	New (HospStr, Guser)
	Set LocHospDr=$p(HospStr,"^",1)
	Quit:(LocHospDr="")
	Do Insert^DHCJFHosPriceDateConfig(LocHospDr)

	Set Flag2="^DHCJFHOSPRICEDATECONFIG(""DHCBILL"")",UserTable="^DHCJFHOSPRICEDATECONFIG(""DHCBILL"")",TableDesc="调价生效日期设置",InsRowid=LocHospDr
	Set JsonStr="{^DHCJFHOSPRICEDATECONFIG(""DHCBILL""):"_LocHospDr_"}" 
	Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"插入","A",JsonStr)

	Quit """"_0_""""
}

ClassMethod DeleteHospConfig(HospStr, Guser)
{
	New (HospStr, Guser)
	Set LocHospDr=$p(HospStr,"^",1)
	Quit:(LocHospDr="")
	Do Delete^DHCJFHosPriceDateConfig(LocHospDr)

	Set Flag2="^DHCJFHOSPRICEDATECONFIG(""DHCBILL"")",UserTable="^DHCJFHOSPRICEDATECONFIG(""DHCBILL"")",TableDesc="调价生效日期设置",InsRowid=LocHospDr
	Set JsonStr="{^DHCJFHOSPRICEDATECONFIG(""DHCBILL""):"_LocHospDr_"}" 
	Do ##class(DHCBILLConfig.DHCBILLSysType).SaveLogForOther(Flag2,UserTable,TableDesc,InsRowid ,"删除","D",JsonStr)

	Quit 0
}

ClassMethod BuildAutAry(Table)
{
   	w !
   	w !,"<script type=""text/javascript"">",!
	w !,"var BDPDisableArray = new Array();",!
	w "function BDPAutDisableFlag(a){",!
	w "	   return false;",!
	w "};",!
    w "</script>"
	w !
	q
}

}

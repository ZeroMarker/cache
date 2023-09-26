/// Description:科室人员增删改查
/// Creater:	czf
/// CreateDate:	2021-07-14
Class web.DHCEQ.Plat.CTLocUser Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	查询科室人员明细信息
/// Creater:	czf
/// CreateDate:	2021-07-14
/// Table:		DHC_EQCLocUser
/// Input:		LocID:科室ID
/// 				UserID:人员ID
/// 				UserType:人员类型(1:管理员 2:负责人)
/// 				QXType:权限类型
/// Return：	科室人员明细信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTLocUser","LocUser","437","","2","")
Query LocUser(LocID As %String, UserID As %String, UserType As %String, QXType As %String) As %Query(ROWSPEC = "LURowID:%String,LUUserType:%String,LUUserType_Desc:%String,LULocDR:%String,LULocDR_DeptDesc:%String,LUUserDR:%String,LUUserDR_UName:%String,LURow:%String") [ SqlProc ]
{
}

ClassMethod LocUserExecute(ByRef qHandle As %Binary, LocID As %String, UserID As %String, UserType As %String, QXType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s TRow=0
	
	s RowID=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCLocUser",RowID)) q:RowID=""  d
	.d ResetLocUser
	.s LURowID=RowID
	.s LocUserInfo=$g(^DHCEQCCode("DHCEQCLocUser",LURowID))
	.s LUUserType=$p(LocUserInfo,"^",1)
	.q:(UserType'="")&&(UserType'=LUUserType)
	.s LUUserTypeDesc=$case(LUUserType,"1":"管理员","2":"负责人",:"")		//人员类型
	.s LULocDR=$p(LocUserInfo,"^",2)
	.q:(LocID'="")&&(LocID'=LULocDR)
	.s LULocDRDeptDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",LULocDR)
	.s LUUserDR=$p(LocUserInfo,"^",3)
	.q:(UserID'="")&&(UserID'=LUUserDR)
	.s LUUserDRUName=##class(web.DHCEQCommon).GetTrakNameByID("user",LUUserDR)
	.s LUInvalidFlag=$p(LocUserInfo,"^",4)
	.q:LUInvalidFlag="Y"
	.s TRow=TRow+1
	.d OutPutRowLocUser
	
	i TRow=0 d
	.d ResetLocUser
	.s TRow=1
	.d OutPutRowLocUser
	
	Quit $$$OK
	
ResetLocUser
	s (LURowID,LocUserInfo,LUUserType,LUUserTypeDesc,LULocDR,LULocDRDeptDesc,LUUserDR,LUUserDRUName,LUInvalidFlag)=""
	quit
OutPutRowLocUser
	s Data=$lb(LURowID,LUUserType,LUUserTypeDesc,LULocDR,LULocDRDeptDesc,LUUserDR,LUUserDRUName,TRow)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	quit
}

ClassMethod LocUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocUserExecute ]
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

ClassMethod LocUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Descript:	查询科室人员类型
/// Creater:	czf
/// CreateDate:	2021-07-14
/// Table:		DHC_EQCLocUser
/// Input:		Name:人员名称
/// Return：	科室人员类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTLocUser","LocUserType","")
Query LocUserType(Name As %String) As %Query(ROWSPEC = "TRowID:%String,TName:%String") [ SqlProc ]
{
}

ClassMethod LocUserTypeExecute(ByRef qHandle As %Binary, Name As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s TRow=0
	
	s TRowID=1
	s TName="管理员"
	d OutPutRowLocUserType
	s TRowID=2
	s TName="负责人"
	d OutPutRowLocUserType
	
	Quit $$$OK
	
OutPutRowLocUserType
	;q:(Name'="")&&(TName'[Name)		//数据较少，暂不过滤
	s TRow=TRow+1
	s Data=$lb(TRowID,TName)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	quit
}

ClassMethod LocUserTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocUserTypeExecute ]
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

ClassMethod LocUserTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocUserTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Descript:	保存/更新科室人员信息
/// Creater:	czf
/// CreateDate: 2021-07-14
/// Table:		DHC_EQCLocUser
/// Input:		数据Json串:rowid,代码,描述
/// Return: 	操作成功或失败代码Json串，操作成功:{"Data":"0","SQLCODE":"0"} 
/// d ##class(web.DHCEQ.Plat.CTLocUser).SaveData("2^437","{""LURowID"":""1"",""LUUserType"":""2"",""LUUserType_Desc"":""负责人"",""LULocDR"":""437"",""LULocDR_DeptDesc"":""CT室[西院]"",""LUUserDR"":""1"",""LUUserDR_UName"":""Demo Group"",""LURow"":""1""}$CHAR(3){""LURowID"":""3"",""LUUserType"":""2"",""LUUserType_Desc"":""负责人"",""LULocDR"":""437"",""LULocDR_DeptDesc"":""CT室[西院]"",""LUUserDR"":""9"",""LUUserDR_UName"":""nurse"",""LURow"":""2""}$CHAR(3){""LUUserDR"":""8"",""LUUserDR_UName"":""med manager""}","","77")
ClassMethod SaveData(var As %Library.String = "", list As %Library.String = "", DelRowid As %Library.String = "", User As %String = "")
{
	n (var,list,DelRowid,User)
	Set $ZT="ERRORSaveData"
	Set Date=+$H
 	Set Time=$Piece($H,",",2)
 	i User="" Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	
 	s SQLCODE=0
	TStart
	s LULocDR=$p(var,"^",1)
	i (LULocDR="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000","科室ID不能为空!")
	
	s SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s Length=$Length(list,SplitRowCode)
	f i=1:1:Length  q:SQLCODE'=0  d
	.K LIST
	.s valList= $Piece(list,SplitRowCode,i)
	.s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
	.s LIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCLocUser",JsonData,.LIST)
	.s LURowid = JsonData.LURowID
	.s LUUserDR= JsonData.LUUserDR
	.s LUUserType=JsonData.LUUserType
	.s LIST(3) = LULocDR
	.s LIST(5) = "N"
	.s LIST(6) = Date
	.s tmpLocUserID=""
	.&SQL(Select LU_RowID into :tmpLocUserID from SQLUSER.DHC_EQCLocUser where LU_LocDR = :LULocDR and LU_UserType=:LUUserType and LU_UserDR=:LUUserDR)
	.i SQLCODE=100 s SQLCODE=0
	.i (LURowid="")  d
	..i tmpLocUserID="" d
	...&SQL(Insert Into SQLUSER.DHC_EQCLocUser Values :LIST())
	..e  d
	...&SQL(Update SQLUSER.DHC_EQCLocUser Values :LIST() where LU_RowID = :tmpLocUserID)
	..s LURowid=$Get(%ROWID)
	.e  d
	..&SQL(Update SQLUSER.DHC_EQCLocUser Values :LIST() where LU_RowID = :LURowid)
	.i SQLCODE=100 Set SQLCODE=0
	.q:SQLCODE'=0
	If SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存科室人员明细错误!")
	}
	
	Set SQLCODE=..DeleteList(DelRowid)		;删除明细
	If SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"删除科室人员明细错误!")
	}

	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,0)

ERRORSaveData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// Descript:	删除科室人员明细
/// Creater:	czf
/// CreateDate: 2021-07-14
/// Table:		DHC_EQCLocUser
/// Input:		需删除的RowID串:"1,2,3,4"
/// Return: 	操作成功标志：0:成功 其他：失败
/// Command:	w ##Class(web.DHCEQ.Plat.CTLocUser).DeleteList(",0,0,0")
ClassMethod DeleteList(DelRowIDs)
{
	new (DelRowIDs)
	If DelRowIDs="" Quit 0
	
	Set Flag=0
	Set Length=$Length(DelRowIDs,",")
	for i=1:1:Length
	{
		Quit:Flag'=0
		Set LURowID=$Piece(DelRowIDs,",",i)
		i LURowID="" continue
		If (LURowID>0)
		{
			//&SQL(delete from sqluser.DHC_EQCLocUser where LU_RowID=:LURowID)
			&SQL(Update sqluser.DHC_EQCLocUser set LU_InvalidFlag='Y' where LU_RowID=:LURowID)
			If SQLCODE Set Flag=SQLCODE
		}
	}
	Quit Flag
}

/// Descript:	获取科室人员明细
/// Creater:	czf
/// CreateDate: 2021-07-14
/// Table:		DHC_EQCLocUser
/// Input:		LocID:科室ID
/// 				UserType:人员类型(1:管理员 2:负责人)
/// Return: 	科室人员名称串，逗号分隔
/// Command:	w ##Class(web.DHCEQ.Plat.CTLocUser).GetLocUserNames("437","1")
ClassMethod GetLocUserNames(LocID, UserType)
{
	n (LocID, UserType)
	i (LocID="")||(UserType="") q ""
	
	s UserNames=""
	s UserID=0
	f  s UserID=$o(^DHCEQCCode("DHCEQCLocUser",0,"LocUserType",LocID,UserType,UserID)) q:UserID=""  d
	.s LURowID=0
	.f  s LURowID=$o(^DHCEQCCode("DHCEQCLocUser",0,"LocUserType",LocID,UserType,UserID,LURowID)) q:LURowID=""  d
	..q:$p($g(^DHCEQCCode("DHCEQCLocUser",LURowID)),"^",4)="Y"
	..s UserName=##class(web.DHCEQCommon).GetTrakNameByID("user",UserID)
	..i UserNames="" s UserNames=UserName
	..e  i (","_UserNames_",")'[(","_UserName_",") s UserNames=UserNames_","_UserName
	
	q UserNames
}

/// Descript:	获取登录人员可访问科室ID串
/// Creater:	czf
/// CreateDate: 2021-07-14
/// Table:		DHC_EQCLocUser
/// Input:		User:人员ID
/// 			UserType:人员类型(1:管理员 2:负责人)
/// Return: 	科室ID串，逗号分隔
/// Command:	w ##Class(web.DHCEQ.Plat.CTLocUser).GetUserLocInfo("1736","","1")
ClassMethod GetUserLocInfo(User As %String = "", UserType As %String = "", ChildLocInclude As %String = "")
{
	n (User, UserType,ChildLocInclude,AllLocIDs,LocIDs,i,LocID)
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	s (AllLocIDs,LocIDs)=""
	s LUUserType=0
	f  s LUUserType=$o(^DHCEQCCode("DHCEQCLocUser",0,"UserType",LUUserType)) q:LUUserType=""  d
	.q:(UserType'="")&&(UserType'=LUUserType)
	.s LULocDR=0
	.f  s LULocDR=$o(^DHCEQCCode("DHCEQCLocUser",0,"UserType",LUUserType,User,LULocDR)) q:LULocDR=""  d
	..s LURowID=0
	..f  s LURowID=$o(^DHCEQCCode("DHCEQCLocUser",0,"UserType",LUUserType,User,LULocDR,LURowID)) q:LURowID=""  d
	...q:$p($g(^DHCEQCCode("DHCEQCLocUser",LURowID)),"^",4)="Y"
	...i LocIDs="" s LocIDs=LULocDR
	...e  i (","_LocIDs_",")'[(","_LULocDR_",") s LocIDs=LocIDs_","_LULocDR
	
	i ChildLocInclude=1
	{
		i LocIDs="" q ""
		f i=1:1:$l(LocIDs,",") d
		.s LocID=$p(LocIDs,",",i)
		.q:LocID=""
		.s LocTreeMapID=##class(web.DHCEQCTreeMap).GetTreeMapIDByTreeID(LocID,1)
		.s ChildLocIDs=##Class(web.DHCEQCTreeMap).GetTreeNoteIds(LocTreeMapID,"treeid")
		.i ChildLocIDs="" s ChildLocIDs=LocID
		.e  s ChildLocIDs=ChildLocIDs_","_LocID		//包含父科室
		.i AllLocIDs'="" s AllLocIDs=AllLocIDs_","
		.s AllLocIDs=AllLocIDs_ChildLocIDs
		q AllLocIDs
	}
	else
	{
		s AllLocIDs=LocIDs
		q AllLocIDs
	}
}

}

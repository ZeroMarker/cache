Import SQLUser

/// 修改人： Mozy0039 2011-01-07
/// 描述:用户角色设置
Class web.DHCEQCUserRole Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// SourceTypeDR As %String = "", SourceDR As %String = "", RoleDR As %String = "", BussTypeDR As %String = ""
/// d ##class(%ResultSet).RunQuery("web.DHCEQCUserRole","UserRole","","","","21")
Query UserRole(SourceTypeDR As %String = "", SourceDR As %String = "", RoleDR As %String = "", BussTypeDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceDR:%String,TSource:%String,TRoleDR:%String,TRole:%String,TBussTypeDR:%String,TBussType:%String")
{
}

ClassMethod UserRoleExecute(ByRef qHandle As %Binary, SourceTypeDR As %String = "", SourceDR As %String = "", RoleDR As %String = "", BussTypeDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	;^DHCEQCCode("DHCEQCUserRole",4)=2^2164^12^51
	;s ^DHCEQMozy("BussTypeDR")=BussTypeDR
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCUserRole",rowid))  Quit:rowid=""  Do
	.Do ResetVariablesUserRole
	.Set TRowID = rowid
	.Set TSourceType=$Piece($Get(^DHCEQCCode("DHCEQCUserRole",TRowID)),"^",1)
	.Quit:(SourceTypeDR'="")&&(SourceTypeDR'=TSourceType)
	.Set TSourceDR=$Piece($Get(^DHCEQCCode("DHCEQCUserRole",TRowID)),"^",2)
	.Quit:(SourceDR'="")&&(SourceDR'=TSourceDR)
	.If TSourceDR'="" Do
	..If TSourceType=2 Set TSource=##class(web.DHCEQCommon).GetTrakNameByID("grp",TSourceDR)		//安全组
	..If TSourceType=1 Set TSource=##class(web.DHCEQCommon).GetTrakNameByID("user",TSourceDR)		//用户名
	.Set TSourceType=##Class(web.DHCEQCUserRole).GetEditSourceType(TSourceType)
	.Set TRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCUserRole",TRowID)),"^",3)
	.Quit:(RoleDR'="")&&(RoleDR'=TRoleDR)
	.If TRoleDR'="" Set TRole=$Piece($Get(^DHCEQCCode("DHCEQCApproveRole",TRoleDR)),"^",2)
	.Set TBussTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCUserRole",TRowID)),"^",4)
	.Quit:(BussTypeDR'="")&&(BussTypeDR'=TBussTypeDR)
	.If TBussTypeDR'="" Set TBussType=##class(web.DHCEQFind).GetBussTypeDesc(TBussTypeDR)
	.Do OutputRowUserRole
	Quit $$$OK
OutputRowUserRole
	Set Data=$lb(TRowID,TSourceType,TSourceDR,TSource,TRoleDR,TRole,TBussTypeDR,TBussType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesUserRole
	Set (TRowID,TSourceType,TSourceDR,TSource,TRoleDR,TRole,TBussTypeDR,TBussType)=""
	Quit
}

ClassMethod UserRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UserRoleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod UserRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UserRoleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCEQCUserRole).GetUserRoleByID(1)
ClassMethod GetUserRoleByID(rowid As %Library.String = "")
{
	Quit:rowid="" ""
	
	new result,resultex,LocCode,AppInfo,Total
	Set (result,resultex,LocCode,AppInfo,Total)=""
	Set result= $Get(^DHCEQCCode("DHCEQCUserRole",rowid))
	
	Set resultex=resultex_"^"	;1 SourceType
	If $Piece(result,"^",1)'=""  d
	.Set resultex=resultex_..GetEditSourceType($Piece(result,"^",1))
	Set resultex=resultex_"^"	;2 SourceDR
	If $Piece(result,"^",2)'=""  d
	.If $Piece(result,"^",1)=2 Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("grp",$Piece(result,"^",2))
	.If $Piece(result,"^",1)=1 Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",2))
	Set resultex=resultex_"^"	;3 RoleDR
	If $Piece(result,"^",3)'=""  d
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCApproveRole",$Piece(result,"^",3))),"^",2)
	Set resultex=resultex_"^"	;4 BussType
	If $Piece(result,"^",4)'=""  d
	.Set resultex=resultex_##class(web.DHCEQFind).GetBussTypeDesc($Piece(result,"^",4))
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n") //回车符转换为"\n"
	
	Quit rowid_"^"_result_resultex
}

/// w ##class(web.DHCEQCUserRole).SaveData("","","1^2^3^4^5")
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	Kill PLIST,rowid,tmpid
	s (rowid,tmpid)=""
	Set rowid=$Piece(val,"^",1)
	If (+isDel=1)
	{
	 	&SQL(delete from sqluser.DHC_EQCUserRole where UR_RowID=:rowid)
	 	If SQLCODE  Quit SQLCODE
	 	Quit rowid
 	}
 	
 	Set PLIST(2)=$Piece(val,"^",2) 		// SourceTypeDR
 	Set PLIST(3)=$Piece(val,"^",3) 		// SourceDR
 	Set PLIST(4)=$Piece(val,"^",4) 		// RoleDR
 	Set PLIST(5)=$Piece(val,"^",5) 		// BussTypeDR
	&SQL(select UR_RowID into :tmpid from sqluser.DHC_EQCUserRole where UR_SourceType=:PLIST(2) and UR_SourceID=:PLIST(3) and UR_RoleDR=:PLIST(4))
	if ((tmpid="")||(tmpid=rowid))
	{
	 	If (rowid="")  //新增按钮操作
	 	{
		 	&SQL(Insert Into SQLUSER.DHC_EQCUserRole Values :PLIST())
	 	}
	 	Else  //更新按钮操作
	 	{
			&SQL(Update SQLUSER.DHC_EQCUserRole Values :PLIST() where UR_RowID = :rowid)
	 	}
	}
 	If SQLCODE Quit SQLCODE
 	Set ID=$Get(%ROWID)
 	Quit ID
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCUserRole","GetUserRole","")
Query GetUserRole(Desc As %String = "") As %Query(ROWSPEC = "TDesc:%String,Hidden,TCode:%String,Hidden,TUnit:%String,TPrice:%String")
{
}

ClassMethod GetUserRoleExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	Do BuildDataGetUserRole
	Quit $$$OK
BuildDataGetUserRole
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCServiceDetails",rowid))  Quit:rowid=""  Do
	.Do ResetVariablesUserRole
	.Set TRowID = rowid
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCServiceDetails",rowid)),"^",1)
	.Quit:(Desc'="")&&(TDesc'=Desc)
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCServiceDetails",rowid)),"^",2)
	.Set TUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCServiceDetails",rowid)),"^",3)
	.If TUnitDR'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.Set TPrice=$Piece($Get(^DHCEQCCode("DHCEQCServiceDetails",rowid)),"^",4)
	.
	.Do OutputRowGetUserRole
	Quit
OutputRowGetUserRole
	Set Data=$lb(TDesc,TRowID,TCode,TUnitDR,TUnit,TPrice)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetUserRole
	Set (TDesc,TRowID,TCode,TUnitDR,TUnit,TPrice)=""
	Quit
}

ClassMethod GetUserRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserRoleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetUserRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserRoleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SourceType(name, width) As %String
{
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=2>安全组</option>"
	w "<option value=1>用户名</option>"
	w "</select>",!
}

ClassMethod GetEditSourceType(Type As %Library.String) As %Status
{
	If Type=""  Quit ""
	If +Type=2  Quit "安全组"
	If +Type=1  Quit "用户名"
	Quit "未定义"
}

/// w ##class(web.DHCEQCUserRole).CheckUserRole("18","0",1,1)
ClassMethod CheckUserRole(role, busstypeid As %Library.String = "", CurUserID As %Library.String = "", CurGroupID As %Library.String = "", OnlyCurGroup As %Library.String = "0")
{
	new rowid,BussTypeID,Flag
	If role="" Quit 0
	If CurUserID="" Set CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	If CurGroupID="" Set CurGroupID=%session.Get("LOGON.GROUPID")
	Set Flag=0
	s rowid=0
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCUserRole",0,"Role",role,rowid))  Quit:(rowid="")||(Flag=1)  Do
	.Set BussTypeID=$Piece($Get(^DHCEQCCode("DHCEQCUserRole",rowid)),"^",4)	//业务类型
	.q:(busstypeid'="")&&(BussTypeID'=BussTypeID)
	.Set SourceType=$Piece($Get(^DHCEQCCode("DHCEQCUserRole",rowid)),"^",1)  //1,用户；2,安全组
	.Set SourceID=$Piece($Get(^DHCEQCCode("DHCEQCUserRole",rowid)),"^",2)	//ID
	.If (SourceType=1)  d
	..i (SourceID=CurUserID) Set Flag=1		//1,用户
	.e  d
	..If (SourceID=CurGroupID)  d
	...Set Flag=1		//2,安全组
	..e  d
	...i OnlyCurGroup=0  d
	....i $d(^SSU("SSUSR",0,"Group",SourceID,CurUserID)) s Flag=1
	.Quit:Flag=1
	
	Quit Flag
}

}

/// 名称: web.DHCCPW.MR.CTCareProvSrv
/// 描述: 临床路径
/// 编写者：zhufei
/// 编写日期: 2010-05-13
Class web.DHCCPW.MR.CTCareProvSrv Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-05-17
/// Description:  根据用户ID取关联医护人员
/// Table：       User.SSUser
/// Input：       ID:    User.SSUser.Id
///               separete: 指定的分隔符
/// Return：      返回String
/// w ##class(web.DHCCPW.MR.CTCareProvSrv).GetCareProvByUserID(2040,"")
ClassMethod GetCareProvByUserID(argUserID As %String, argSeparete As %String) As %String
{
	New (argUserID,argSeparete)
	Set return=""
	Set objSSUser=##Class(User.SSUser).%OpenId(argUserID)
	If $IsObject(objSSUser)
	{
		Set:$g(argSeparete)="" argSeparete=..#SEPARATE
		
		If $IsObject(objSSUser.SSUSRCareProvDR)
		{
			Set CareProvDR=objSSUser.SSUSRCareProvDR.%Id()
			Set CareProvDesc=objSSUser.SSUSRCareProvDR.CTPCPDesc
			
		}
		
		Set UserCode=objSSUser.SSUSRInitials
		Set UserName=objSSUser.SSUSRName
		
		If $IsObject(objSSUser.SSUSRGroup)
		{
			Set GroupID=objSSUser.SSUSRGroup.%Id()
			Set GroupDesc=objSSUser.SSUSRGroup.SSGRPDesc
		}
	} Else {
		Quit return
	}
	Do:objSSUser'="" objSSUser.%Close()
	
	Set return=$g(CareProvDR)_argSeparete_$g(CareProvDesc)_argSeparete_$g(argUserID)_argSeparete_$g(UserCode)_argSeparete_$g(UserName)_argSeparete_$g(GroupID)_argSeparete_$g(GroupDesc)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-06-12
/// Description:  根据ID取医护人员
/// Table：       User.CTCareProv
/// Input：       ID:    User.CTCareProv.Id
///               separete: 指定的分隔符
/// Return：      返回String
/// w ##class(web.DHCCPW.MR.CTCareProvSrv).GetCareProvByID(376,"^")
ClassMethod GetCareProvByID(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	quit:'$d(^CTPCP(+id)) return
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set Code=$p($g(^CTPCP(+id,1)),"^",1)     // 代码
	set Name=$p($g(^CTPCP(+id,1)),"^",2)     // 姓名
	set CarPrvTypeDr=$p($g(^CTPCP(+id,1)),"^",4)   // 医护人员类型
	set CarPrvTypeCode=$p($g(^CT("CPT",+CarPrvTypeDr)),"^",1)   // 医护人员类型代码
	set CarPrvTypeDesc=$p($g(^CT("CPT",+CarPrvTypeDr)),"^",2)   // 医护人员类型描述
	set InternalType=$p($g(^CT("CPT",+CarPrvTypeDr)),"^",4)   // 医护类型
	set return=id_separete_Code_separete_Name_separete_CarPrvTypeDr
	set return=return_separete_CarPrvTypeCode_separete_CarPrvTypeDesc_separete_InternalType
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-14
/// Description:  取医护人员字典
/// Input：       CT_CarProv.Name 或 CT_CarProv.Code
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.CTCareProvSrv","QryCareProvByName","张晓","")
Query QryCareProvByName(argAlias As %String, argLocID As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod QryCareProvByNameExecute(ByRef qHandle As %Binary, argAlias As %String, argLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set CareProvID=0
	For {
		Set CareProvID=$o(^CTPCP(CareProvID))
		Quit:CareProvID=""
		Set Code=$p($g(^CTPCP(CareProvID,1)),"^",1)
		Set Desc=$p($g(^CTPCP(CareProvID,1)),"^",2)
		Set argAlias=$$ALPHAUP^SSUTIL4(argAlias)
		Set IsSelect=0
		Set:(argAlias'="")&&($e($$ALPHAUP^SSUTIL4(Code),1,$l(argAlias))=argAlias) IsSelect=1
		Set:(argAlias'="")&&($e($$ALPHAUP^SSUTIL4(Desc),1,$l(argAlias))=argAlias) IsSelect=1
		Set ChildSub=0
		For {
			Quit:argAlias=""
			Set ChildSub=$o(^CTPCP(CareProvID,"KEYW",ChildSub))
			Quit:ChildSub=""
			Set Alias=$p($g(^CTPCP(CareProvID,"KEYW",ChildSub)),"^",1)
			Continue:$e(Alias,1,$l(argAlias))'=argAlias
			Set IsSelect=1
		}
		Continue:(argAlias'="")&&(IsSelect=0)
		Continue:(argLocID'="")&&'$d(^RB("RES",0,"CTPCP",CareProvID,+argLocID))
		Set Data=$lb(CareProvID,Code,Desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCareProvByNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCareProvByNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCareProvByNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCareProvByNameExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="CTCareProvSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW.MR.CTCareProvSrvD</DataLocation>
<DefaultData>CTCareProvSrvDefaultData</DefaultData>
<IdLocation>^web.DHCCPW.MR.CTCareProvSrvD</IdLocation>
<IndexLocation>^web.DHCCPW.MR.CTCareProvSrvI</IndexLocation>
<StreamLocation>^web.DHCCPW.MR.CTCareProvSrvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

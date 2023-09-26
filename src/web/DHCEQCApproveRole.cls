Class web.DHCEQCApproveRole Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 6;

Parameter SQLCODE = "AR_Code";

Parameter SQLDATEFROM;

Parameter SQLFILTER = " (AR_InvalidFlag = 'N') ";

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "AR_Desc";

Parameter SQLROWID = "AR_RowID";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String:名称,HIDDEN:%String,Code:%String:编码")
{
SELECT AR_Desc,
	   AR_RowID,
	   AR_Code
FROM sqluser.DHC_EQCApproveRole
where AR_InvalidFlag = 'N' and AR_Desc like nvl(:para,'')||'%'
}

/// Modfied by zc 2015-07-08 ZC0026
/// 描述：根据权限分配角色
/// d ##class(%ResultSet).RunQuery("web.DHCEQCApproveRole","GetRole","","","")
/// modified by czf 增加入参Remark过滤 519002
Query GetRole(Code As %String = "", Desc As %String = "", LocFlag As %String = "", vRemark As %String = "") As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String,remark:%String,invalidFlag:%String,locFlagdr:%String,locFlag:%String")
{
}

ClassMethod GetRoleExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", LocFlag As %String = "", vRemark As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s RowID=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCApproveRole",RowID))  quit:RowID=""  d
	.d ResetVariablesGetRole
	.s rowid = RowID
	.s invalidFlag =$p($g(^DHCEQCCode("DHCEQCApproveRole",rowid)),"^",4)
	.q:invalidFlag="Y"
	.s code=$p($g(^DHCEQCCode("DHCEQCApproveRole",rowid)),"^",1)
	.q:(Code'="")&&(code'[Code)
	.s desc =$p($g(^DHCEQCCode("DHCEQCApproveRole",rowid)),"^",2)
	.q:(Desc'="")&&(desc'[Desc)
	.s remark=$p($g(^DHCEQCCode("DHCEQCApproveRole",rowid)),"^",3)
	.q:(vRemark'="")&&(remark'[vRemark)
	.s locFlagdr =$p($g(^DHCEQCCode("DHCEQCApproveRole",rowid)),"^",5)
	.q:(LocFlag'="")&&(locFlagdr'=LocFlag)
	.s locFlag=$CASE(locFlagdr,"":"","0":"所有","1":"根据权限","2":"本科","3":"本院","4":"本组","5":"本人")
	.d OutputRowGetRole
	quit $$$OK
OutputRowGetRole
	s Data=$lb(rowid,code,desc,remark,invalidFlag,locFlagdr,locFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRole
	s (rowid,code,desc,remark,invalidFlag,locFlagdr,locFlag)=""
	quit
}

ClassMethod GetRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoleExecute ]
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

ClassMethod GetRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modfied by zc 2015-07-27 ZC0026
/// 描述:新增与更新分开,此部分是更新
ClassMethod SaveRole(RowId As %String, Code As %String, Desc As %String, Remark As %String, InvalidFlag As %String = "N", LocFlag As %String)
{
	k PLIST,rowid
	s rowid=RowId
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=Remark
	s PLIST(5)="N"
	s PLIST(6)=LocFlag
	s tmpid=""
	&SQL(select AR_RowID into :tmpid from sqluser.DHC_EQCApproveRole where AR_Code=:Code and AR_Desc=:Desc and AR_InvalidFlag='N' and AR_LocFlag=:LocFlag)
	if ((tmpid'="")&&(tmpid'=rowid)) q "数据有重复"	;重复记录
	&SQL(Update sqluser.DHC_EQCApproveRole Values :PLIST() where AR_RowID = :rowid)  
	q SQLCODE
}

ClassMethod DeleteRole(OPRRowid As %String)
{
	i (OPRRowid'="")
	{
		&SQL(Update sqluser.DHC_EQCApproveRole set AR_InvalidFlag='Y' where AR_RowID = :OPRRowid)
	}
	q 0
}

/// Modfied by zc 2015-07-27 ZC0026
/// 描述:新增与更新分开,此部分是新增
ClassMethod AddRole(Code As %String, Desc As %String, Remark As %String, InvalidFlag As %String = "N", LocFlag As %String)
{
	k PLIST
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=Remark
	s PLIST(5)="N"
	s PLIST(6)=LocFlag
	s tmpid=""
	&SQL(select AR_RowID into :tmpid from sqluser.DHC_EQCApproveRole where AR_Code=:Code and AR_Desc=:Desc and AR_InvalidFlag='N')
	if (tmpid'="") q "数据有重复"	;重复记录
	&SQL(Insert into sqluser.DHC_EQCApproveRole Values :PLIST())
	if SQLCODE  q "更新失败"
	Set ID=$g(%ROWID)
	q ID
}

}

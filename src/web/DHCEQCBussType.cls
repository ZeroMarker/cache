Class web.DHCEQCBussType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Modefied by zc 2015-07-08 zc0026
/// 描述：业务定义
/// d ##class(%ResultSet).RunQuery("web.DHCEQCBussType","GetBussType","","","")
Query GetBussType(Code As %String = "", Desc As %String = "", ModleType As %String = "") As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String,modletypedr:%String,modletype:%String,invalidFlag:%String")
{
}

ClassMethod GetBussTypeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", ModleType As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s index=1
	s RowID=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCBussType",RowID))  quit:RowID=""  d
	.d ResetVariablesGetBussType
	.s invalidFlag =$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",4)  ///Modefied by zc 2015-07-08 zc0026 rowid改为RowID
	.q:invalidFlag="Y"
	.s code=$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",1) ///Modefied by zc 2015-07-08 zc0026 rowid改为RowID
	.q:(Code'="")&&(code'[Code)
	.s desc =$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",2) ///Modefied by zc 2015-07-08 zc0026 rowid改为RowID
	.q:(Desc'="")&&(desc'[Desc)
	.s modletypedr=$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",3) ///Modefied by zc 2015-07-08 zc0026 rowid改为RowID
	.q:(ModleType'="")&&(modletypedr'=ModleType)   ///Modefied by zc 2015-08-21 zc0028
	.s modletype=$CASE(modletypedr,"":"","1":"设备管理","2":"维修管理","3":"效益分析","4":"移动盘点","5":"移动维修")
	.s rowid = RowID  
	.d OutputRowGetBussType
	quit $$$OK
OutputRowGetBussType
	s Data=$lb(rowid,code,desc,modletypedr,modletype,invalidFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBussType
	s (rowid,code,desc,modletypedr,modletype,invalidFlag)=""
	quit
}

ClassMethod GetBussTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussTypeExecute ]
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

ClassMethod GetBussTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modefied by zc 2015-07-27 zc0026
/// 描述：业务定义的新增与更新分开，此部分为更新
/// w ##Class(web.DHCEQCBussType).SaveBussType("","05","效益分析","1")
ClassMethod SaveBussType(RowId As %String, Code As %String, Desc As %String, ModleType As %String, InvalidFlag As %String = "N")
{
	k PLIST,rowid
	s rowid=RowId
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=ModleType
	s PLIST(5)="N"
	s tmpid=""
	&SQL(select BT_RowID into :tmpid from sqluser.DHC_EQCBussType where BT_Code=:Code and BT_Desc=:Desc and BT_InvalidFlag='N' and BT_ModleType=:ModleType)
	if ((tmpid'="")&&(tmpid'=rowid)) q "数据有重复"	;重复记录
	&SQL(Update sqluser.DHC_EQCBussType Values :PLIST() where BT_RowID = :rowid)
	q SQLCODE
}

ClassMethod DeleteBussType(OPRRowid As %String)
{
	i (OPRRowid'="")
	{
		&SQL(Update sqluser.DHC_EQCBussType set BT_InvalidFlag='Y' where BT_RowID = :OPRRowid)
	}
	q 0
}

/// Modefied by zc 2015-07-27 zc0026
/// 描述：业务定义的新增与更新分开，此部分为新增
/// w ##Class(web.DHCEQCBussType).AddBussType("05","效益分析","1")
ClassMethod AddBussType(Code As %String, Desc As %String, ModleType As %String, InvalidFlag As %String = "N")
{
	k PLIST
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=ModleType
	s PLIST(5)="N"
	s tmpid=""
	&SQL(select BT_RowID into :tmpid from sqluser.DHC_EQCBussType where BT_Code=:Code and BT_Desc=:Desc and BT_InvalidFlag='N' and BT_ModleType=:ModleType)
	if (tmpid'="") q "数据有重复"	;重复记录
	&SQL(Insert into sqluser.DHC_EQCBussType Values :PLIST())
	if SQLCODE  q "更新失败"
	Set ID=$g(%ROWID)
	q ID
}

/// w ##Class(web.DHCEQCBussType).GetBussTypeByCode(1,"63-2")
ClassMethod GetBussTypeByCode(ModleType, Code As %String = "")
{
	if Code="" q ""
	n RowID
	s findlflag=""
	s RowID=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCBussType",RowID)) quit:(RowID="")||(findlflag'="")  d
	.q:$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",4)="Y"
	.q:$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",3)'=ModleType
	.q:$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",1)'=Code
	.s findlflag=$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",2)
	
	q findlflag
}

}

Class web.DHCEQM.DHCEQMCManageType Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Create By GR 2014-08-20
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMCManageType","ManageType")
/// modified by czf 406181 增加TRow并输出
Query ManageType() As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlag:%String,TRow:%String")
{
}

ClassMethod ManageTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ManageTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

 	Quit $$$OK
}

ClassMethod ManageTypeExecute(ByRef qHandle As %Binary) As %Status
{
	//new repid ,index,rowid
	//new index
	//new rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	//s Desc=$ZCONVERT(Desc ,"U")
 	//s Code=$ZCONVERT(Code ,"U")
 	s index=1
	s rowid=0
	s TRow=1
	for  s rowid=$o(^DHCEQCCode("DHCEQMCManageType",rowid)) quit:rowid=""  d
	.d ResetVariablesGetEquipType
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQMCManageType",rowid)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQMCManageType",rowid)),"^",2)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQMCManageType",rowid)),"^",3)
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCManageType",rowid)),"^",4)
	.q:TInvalidFlag="Y"
	.d OutputRowGetEquipType
	Quit $$$OK
	
OutputRowGetEquipType
	s Data=$lb(TRowID,TCode,TDesc,TRemark,TInvalidFlag,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetEquipType
	s (TRowID,TCode,TDesc,TRemark,TInvalidFlag)=""
	quit
}

ClassMethod ManageTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ManageTypeExecute ]
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

/// by zx 2015-08-20 Bug ZX0029
/// 通过rowid查找数据
ClassMethod GetData(rowid As %String = "")
{
	s result=""
	if (rowid=0)||(rowid="")  q ""
	s result= $g(^DHCEQCCode("DHCEQMCManageType",rowid))
	if result="" q ""
	q rowid_"^"_result
}

/// Add By QW20220122 
/// 通过Code查找数据
/// w ##class(web.DHCEQM.DHCEQMCManageType).GetIDByCode(1)
ClassMethod GetIDByCode(code As %String = "")
{
	s result=""
	s MTRowID=""
	if code=""  q ""
	s rowid=0
	for  s rowid=$O(^DHCEQCCode("DHCEQMCManageType",0,code,rowid))  quit:rowid=""  d
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCManageType",rowid)),"^",4)
	.q:TInvalidFlag="Y"
	.s MTRowID=rowid
	q MTRowID
}

/// idDel=1 执行删除操作
/// idDel="" $p(val,"^",1)="" 执行新增操作
/// idDel="" $p(val,"^",1)'="" 执行更新操作
/// set a= ##class(web.DHCEQM.DHCEQMCManageType).SaveData("4^03^shuxue^math1^N","")
ClassMethod SaveData(val, isDel)
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	i (+isDel=1)
	{
		s PLIST(5)="Y"
		&SQL(Update sqluser.DHC_EQMCManageType Values :PLIST() where MT_RowID = :rowid) 
		if SQLCODE  q SQLCODE
		q rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s Code=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s Desc=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	//s PLIST(5)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"bool")
	s PLIST(5)=$p(val,"^",5)
	s tmpid=""
	//查找数据是否已存在
	&SQL(select MT_RowID into :tmpid from sqluser.DHC_EQMCManageType where MT_Code=:Code and MT_Desc=:Desc and MT_InvalidFlag!='Y')
	if ((tmpid="")||(tmpid=rowid))
	{ 
		s PLIST(5)="N"
		i (rowid="")
		{
			&SQL(Insert Into sqluser.DHC_EQMCManageType Values :PLIST())
		
		} 
		else
		{
			&SQL(Update sqluser.DHC_EQMCManageType Values :PLIST() where MT_RowID = :rowid)
			
		}
	}
	if SQLCODE  q SQLCODE
	Set ID=$g(%ROWID)
	q ID
}

Query LookUp(para) As %SQLQuery(ROWSPEC = "MTCode:%String,MTDesc:%String,MTRemark:%String,MTInvalidFlag:%String,TRowid:%String")
{
SELECT 	MT_Code,
		MT_Desc, 
		MT_Remark,
		MT_InvalidFlag,
		MT_Rowid 
FROM 	sqluser.DHC_EQMCManageType
where MT_InvalidFlag = 'N' and MT_Desc like nvl(:para,'')||'%'
}

Storage Default
{
<Data name="DHCEQMCManageTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQM.DHCEQMCManageTypeD</DataLocation>
<DefaultData>DHCEQMCManageTypeDefaultData</DefaultData>
<IdLocation>^web.DHCEQM.DHCEQMCManageTypeD</IdLocation>
<IndexLocation>^web.DHCEQM.DHCEQMCManageTypeI</IndexLocation>
<StreamLocation>^web.DHCEQM.DHCEQMCManageTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

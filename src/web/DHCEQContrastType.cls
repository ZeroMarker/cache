/// -------------------------------
/// 创建:Mozy 2009-07-20	Mzy0018
/// 描述：设备对照类型表的类型
/// --------------------------------
Class web.DHCEQContrastType Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 13;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CT_Code";

Parameter SQLDESCRIPTION = "CT_Desc";

Parameter SQLROWID = "CT_RowID";

/// 创建：Mozy 2009-07-20
/// 描述：返回设备名称列对照表的类型
/// 访问表:DHC_EQContrastType
/// 输入：Desc：描述	Code:编码
/// 输出：无
/// 返回：成功返回记录，否则返回出错信息
/// 备注： 
/// d ##class(%ResultSet).RunQuery("web.DHCEQContrastType","GetContrastType","","")
Query GetContrastType(Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String")
{
}

ClassMethod GetContrastTypeExecute(ByRef qHandle As %Binary, Code, Desc) As %Status
{
 	new repid, index,rowid
	Set repid=$Increment(^CacheTemp)
 	Set qHandle=$ListBuild(0,repid,0)
 	 Set Code=##Class(web.DHCEQCommon).UnEscape(Code)
 	Set Code=$ZCONVERT(Code ,"U")
	Set Desc=##Class(web.DHCEQCommon).UnEscape(Desc)
 	Set Desc=$ZCONVERT(Desc ,"U")
	Set index=1
	Set rowid=0
	Do BuildDataGetContrastType
	Quit $$$OK
BuildDataGetContrastType
	//CT_RowID CT_Desc CT_Remark CT_DataType CT_Mask CT_ContrastType CT_Hold1 CT_Hold2 CT_Hold3 CT_Hold4 CT_Hold5 CT_Code 
	For  Set rowid=$Order(^DHCEQCCode("DHCEQContrastType",rowid))  Quit:rowid=""  Do
	.Do ResetVariablesGetContrastType
	.Set TRowID = rowid
	.Set TDesc = $Piece($Get(^DHCEQCCode("DHCEQContrastType",rowid)),"^",1)
	.Set TCode = $Piece($Get(^DHCEQCCode("DHCEQContrastType",rowid)),"^",6)
	.Quit:(Desc'="")&&($ZCONVERT(TDesc,"U")'[Desc)
	.Quit:(Code'="")&&($ZCONVERT(TCode,"U")'[Code)
	.Do OutputRowGetContrastType
	Quit
OutputRowGetContrastType
	Set Data=$ListBuild(TRowID,TCode,TDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	Quit
ResetVariablesGetContrastType
	Set (TRowID,TCode,TDesc)=""
	Quit
}

ClassMethod GetContrastTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContrastTypeExecute ]
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
	Set qHandle=$ListBuild(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetContrastTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContrastTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="DHCEQContrastTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQContrastTypeD</DataLocation>
<DefaultData>DHCEQContrastTypeDefaultData</DefaultData>
<IdLocation>^web.DHCEQContrastTypeD</IdLocation>
<IndexLocation>^web.DHCEQContrastTypeI</IndexLocation>
<StreamLocation>^web.DHCEQContrastTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// author:wanghc
/// date:  2009-11-12
/// desc:  查询表的各属性
Class web.Util.DHCJFClassGlobal Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod GetTableValueByID(schemaTable, idValue)
{
}

ClassMethod GetUserRowid(packageName, className, Namespace = "")
{
}

/// @param: class All Name   websys.menu, PA_Adm
/// @return: 表名!包名!类名!主索引名
/// User包下的实体类可以省略User
/// w ##class(web.Util.DHCJFClassGlobal).GetTableInfo("SQLUSER.CT_PAYMODE")
/// w ##class(web.Util.DHCJFClassGlobal).GetTableInfo("PIS.DHCPIS_ARCHIVE_CLASS","PIS")
ClassMethod GetTableInfo(SchemaTable, Namespace = "")
{
}

ClassMethod GetPropertyPiece(classAllName, propertyField)
{
}

/// @param: {String} Schema SQLUser
/// @param: {String} Table  PA_Adm
/// @param: {String}	Filed "PAADM_PAPMI_DR"
ClassMethod GetREFTable(Schema, Table, Filed) [ Private ]
{
}

/// @param: {String} Schema SQLUser
/// @param: {String} Table  PA_Adm
/// @param: {String}	Filed "PAADM_PAPMI_DR->PAPMI_Sex_DR->CT"
ClassMethod GetREF(Schema = "SQLUser", Table, Filed)
{
}

/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectColumn","SQLUser","PA_Adm","")
/// input: Schema名,表名,列前缀名
Query SelectColumn(Schema As %String, Table As %String, preColumn As %String, Namespace = "") As websys.Query(ROWSPEC = "Column:%String,Type:%String")
{
}

ClassMethod SelectColumnExecute(ByRef qHandle As %Binary, Schema As %String, Table As %String, preColumn As %String, Namespace = "") As %Status
{
}

/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectTable","SQLUser","PA_")
/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectTable","SQLUser","DHC_PhSendMsg")
/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectTable","SQLUser","DHCMedAdvRepNotes")
/// input: Schema名,表的前缀名
Query SelectTable(Schema As %String = "SQLUser", preTable As %String = "", Namespace = "") As websys.Query(ROWSPEC = "Schema:%String,Table:%String,ClassName:%String")
{
}

ClassMethod SelectTableExecute(ByRef qHandle As %Binary, Schema As %String = "SQLUser", preTable As %String = "", Namespace = "") As %Status
{
}

/// @data 2013-04-20
/// input: Schema前缀名
Query SelectSchema(preSchema As %String = "", Namespace = "") As websys.Query(ROWSPEC = "Schema:%String")
{
}

ClassMethod SelectSchemaExecute(ByRef qHandle As %Binary, preSchema As %String = "", Namespace = "") As %Status
{
}

/// input: 包名,类名(按开头字母查询)
/// desc : 只查询前十个类
Query SelectClass(packageName As %String, preClassName As %String) As %Query(ROWSPEC = "className:%String:类名")
{
}

/// 开始用$order有大小写的问题,处理不是很好.全循环效率差不多
ClassMethod SelectClassExecute(ByRef qHandle As %Binary, packageName As %String, preClassName As %String) As %Status
{
}

ClassMethod SelectClassClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectClassExecute ]
{
}

ClassMethod SelectClassFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectClassExecute ]
{
}

Query SelectGlobal(preGlobalName As %String) As %Query(ROWSPEC = "globalName:%String")
{
}

ClassMethod SelectGlobalExecute(ByRef qHandle As %Binary, preGlobalName As %String) As %Status
{
}

ClassMethod SelectGlobalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectGlobalExecute ]
{
}

ClassMethod SelectGlobalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectGlobalExecute ]
{
}

/// 查询某包下所有global及对应信息
/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectGlobalInfo","websys")
Query SelectGlobalInfo(PackageName As %String = "") As websys.Query(ROWSPEC = "SubScriptString:%String:Gloabl名称,Database:%String:数据库,IndexType:%String:索引类型,ClassAllName:%String:类名,TableName:%String:表名,createDate:%String:CreateDate,Mdata:%String")
{
}

ClassMethod SelectGlobalInfoExecute(ByRef qHandle As %Binary, PackageName As %String = "") As %Status
{
}

/// so slow
/// s sog=$System.OBJ.GetPackageList(.PLIST,""_PackageName_"","*")
/// Do:('sog) $system.Status.DisplayError(sog)
/// for  s ClassAllName=$o(PLIST(ClassAllName)) q:ClassAllName=""  D
/// .set dcd = ##class(%Dictionary.ClassDefinition).%OpenId(ClassAllName)
/// .set TableName=dcd.SqlTableName
/// .set dsd=dcd.Storages
/// .set dsdCount=dsd.Count()
/// 	.for j=1:1:dsdCount  d
/// 	..s sqlMapsID=dsd.GetAt(j).SQLMaps
/// 	..s sqlMapsCount=sqlMapsID.Count()
/// 	..for i=1:1:sqlMapsCount d
/// 	...set sqlMapID=sqlMapsID.GetAt(i)
/// 	...set global=sqlMapID.Global
/// 	...quit:$ZCVT($e(global,1,GlobalNameLen),"U")'=GlobalName
/// 	...set IndexType=sqlMapID.Type
/// 	...set indexName=sqlMapID.Name
/// 	...set SubScriptString=global_..getIndexSubStr(sqlMapID.Subscripts)
/// 	...do OutputRowClassByGlobal
/// 	.s dcd=""	
/// 没有索引,只能遍历所用表,除非自己建表表,但没有实时性
Query SelectClassByGlobal(PackageName As %String, GlobalName As %String) As %Query(ROWSPEC = "ClassAllName:%String,TableName:%String,SubScriptString:%String,IndexType:%String")
{
}

ClassMethod SelectClassByGlobalExecute(ByRef qHandle As %Binary, PackageName, GlobalName As %String) As %Status
{
}

ClassMethod SelectClassByGlobalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectClassByGlobalExecute ]
{
}

ClassMethod SelectClassByGlobalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectClassByGlobalExecute ]
{
}

ClassMethod SelectChild(packageName As %String, className As %String, Namespace = "") As %String
{
}

ClassMethod SelectParentGlobal(classAllName)
{
}

ClassMethod SelectParent(packageName As %String, className As %String, Namespace = "") As %String
{
}

/// 描述:    得到主索引或索引的subString
/// 返回:    subString:   (0,"BillDate",{PBDO_BillDate},{PBDO_RowId})
/// 入参:    subScripts
/// [Previously private]
ClassMethod getIndexSubStr(subScripts)
{
}

ClassMethod getMasterIndexName(packageName As %String, className As %String, Namespace = "")
{
}

/// input: 包名,类名
/// desc:  查询表的结构
/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectMaster","websys","Menu")
/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectMaster","User","DHCPhSend")
/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectMaster","User","DHCMedAdvRepNotes")
/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectMaster","PIS","DHCPISARCHIVECLASS","PIS")
Query SelectMaster(packageName As %String, className As %String, Namespace = "") As %Query(ROWSPEC = "type:%String:索引类型,indexName:%String:索引名,indexMasterData:%String:索引结构")
{
}

ClassMethod SelectMasterExecute(ByRef qHandle As %Binary, packageName As %String, className As %String, Namespace = "") As %Status
{
}

ClassMethod SelectMasterClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectMasterExecute ]
{
}

ClassMethod SelectMasterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectMasterExecute ]
{
}

/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectProperty","User","PAAdm","")
/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectProperty","websys","Menu","")
Query SelectProperty(packageName As %String, className As %String, masterIndexName As %String, Namespace = "") As %Query(ROWSPEC = "propertyName:%String,propertyNode:%String,propertyDeli:%String,propertyPiece:%String,propertyType:%String,propertyField:%String,propertyColumn:%String,propertyDesc:%String")
{
}

ClassMethod SelectPropertyExecute(ByRef qHandle As %Binary, packageName As %String, className As %String, masterIndexName As %String, Namespace = "") As %Status
{
}

ClassMethod SelectPropertyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPropertyExecute ]
{
}

ClassMethod SelectPropertyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPropertyExecute ]
{
}

Query SelectComponent(preComponentName As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "componentName:%String:组件名,componentID:%String:ID", SELECTMODE = "RUNTIME")
{
	SELECT Name,ID FROM websys.Component WHERE (Name %STARTSWITH :preComponentName) ORDER BY Name
}

Query SelectComponentByName(componentName As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "componentName:%String:组件名,componentID:%String:ID", SELECTMODE = "RUNTIME")
{
	SELECT Name,ID FROM websys.Component WHERE (Name = :componentName) ORDER BY Name
}

/// 校正scheme
/// SQLUSER-SQLUser
ClassMethod RegulateSchema(ByRef Schema As %String, Namespace = "") As %Status
{
}

ClassMethod RegulateTable(ByRef Schema As %String, ByRef Table As %String, ByRef ClassName As %String, Namespace = "")
{
}

ClassMethod GetAllMdataInfo()
{
}

/// 查询没有Close的Query
/// zx
Query FindNotCloseQuery() As websys.Query(CONTAINID = 1, ROWSPEC = "ind,clsname,queryname,querytype")
{
}

ClassMethod FindNotCloseQueryExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
}

/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","FindBlockCls")
Query FindBlockCls() As websys.Query(CONTAINID = 1, ROWSPEC = "ind,clsname")
{
}

ClassMethod FindBlockClsExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
}

/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectWS")
Query SelectWS(ns As %String = "DHC-APP", PackageName As %String = "") As websys.Query(ROWSPEC = "MyIndex:%String,ClassAllName:%String,CreateDate:%String,ModDate:%String")
{
}

ClassMethod SelectWSExecute(ByRef qHandle As %Binary, ns As %String = "DHC-APP", PackageName As %String = "") As %Status
{
}

}

Class User.DHCDocCTDefine Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DHCDoc_CT_Define, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCDocCTDefineData As DHCDocCTDefineData [ Cardinality = children, Inverse = DHCDocCTDefineParRef ];

/// Charge Code
Property DHCDocCTDefineCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DHCDoc_CT_Define_Code ];

/// Description
Property DHCDocCTDefineDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = DHCDoc_CT_Define_Desc ];

/// Ref to User.DHCDocCTModule
Property DHCDocCTModuleDR As DHCDocCTModule [ Required, SqlColumnNumber = 4, SqlFieldName = DHCDoc_CT_Define_ModuleDR ];

/// Creator:      郭荣勇
/// CreatDate:    2017.06.07
/// Description:  根据代码模块表(DHCDoc_CT_Module)Rowid得到本数据结构的数据
/// Table:        DHCDoc_CT_Module,DHCDoc_CT_Define
ClassMethod GetDataByModuleClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetDataByModuleExecute ]
{
 Set repid=$LIST(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDataByModuleExecute(ByRef QHandle As %Library.Binary, ModuleId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if ModuleId="" Set QHandle=$lb(0,repid,0) Quit $$$OK
 	s RowId=0
 	for {
	 	s RowId=$O(^DHCDocCTi(0,"Define","ModuleDR",ModuleId,RowId)) Q:RowId=""
 		s RowData=$g(^DHCDocCT("Define",RowId))
 		s DataCode=$p(RowData,"^",1)
 		s DataDesc=$p(RowData,"^",2)
 		s ModuleDR=$p(RowData,"^",3)
 		s Data=$lb(RowId,DataCode,DataDesc,ModuleDR)
 		d OutputRow
 	}
 	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetDataByModuleFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataByModuleExecute ]
{
 Set AtEnd=$LIST(QHandle,1)
 Set repid=$LIST(QHandle,2)
 Set ind=$LIST(QHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetDataByModule(ModuleId As %String) As %Library.Query(ROWSPEC = "RowId,DataCode,DataDesc,ModuleDR")
{
}

/// 根据代码得到代码表Id,此方法默认代码是不重复的,前台也需要控制代码不能重复
ClassMethod GetIdByCode(Code As %String) As %String
{
	Q:(Code="") ""
	s Code=$$ALPHAUP^SSUTIL4(Code)
	s Id=$O(^DHCDocCTi(0,"Define","Code",Code,0))
	
	Q Id
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCDocCT("Define",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCDoc_CT_Define_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCDoc_CT_Define_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCDoc_CT_Define_ModuleDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Define"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDocCTi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Define"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DHCDoc_CT_Define_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCDocCTi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Define"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DHCDoc_CT_Define_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexModuleDR">
<Global>^DHCDocCTi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Define"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ModuleDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCDoc_CT_Define_ModuleDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocCTDefineS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

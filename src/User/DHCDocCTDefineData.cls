Class User.DHCDocCTDefineData Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCDoc_CT_DefineData, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DHCDocCTDefineChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to User.DHCDocCTDefine
Relationship DHCDocCTDefineParRef As DHCDocCTDefine [ Cardinality = parent, Inverse = ChildDHCDocCTDefineData, Required, SqlFieldName = DHCDoc_CT_Define_ParRef ];

/// User.DHCDocCTDefineData KEY
Property DHCDocCTDefineChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCDocCT("DefineData",+$s($d(initvalue):initvalue,1:%d(0)),"D",0))}, Required, SqlColumnNumber = 2, SqlFieldName = DHCDoc_CT_Define_ChildSub ];

/// Charge Code
Property DHCDocCTDefineDataCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = DHCDoc_CT_DefineData_Code ];

/// Description
Property DHCDocCTDefineDataDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = DHCDoc_CT_DefineData_Desc ];

/// startdate
Property StDate As %Date [ SqlColumnNumber = 5, SqlFieldName = DHCDoc_CT_DefineData_StDate ];

/// enddate
Property EndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = DHCDoc_CT_DefineData_EndDate ];

/// Creator:      郭荣勇
/// CreatDate:    2017.06.07
/// Description:  根据父表(DHCDoc_CT_Define)Rowid得到本数据结构的数据
/// Table:        DHCDoc_CT_Define,DHCDoc_CT_DefineData
ClassMethod GetDataByParRefClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetDataByParRefExecute ]
{
 Set repid=$LIST(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDataByParRefExecute(ByRef QHandle As %Library.Binary, par As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if par="" Set QHandle=$lb(0,repid,0) Quit $$$OK
 	s ChildSub=0
 	for {
 		s ChildSub=$O(^DHCDocCT("DefineData",par,"D",ChildSub)) q:ChildSub=""
 		s RowData=$g(^DHCDocCT("DefineData",par,"D",ChildSub))
 		s DataCode=$p(RowData,"^",1)
 		s DataDesc=$p(RowData,"^",2)
 		s StDate=$p(RowData,"^",3)
 		s EndDate=$p(RowData,"^",4)
 		s Data=$lb(par_"||"_ChildSub,DataCode,DataDesc,StDate,EndDate)
 		d OutputRow
 	}
 	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetDataByParRefFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataByParRefExecute ]
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

Query GetDataByParRef(par As %String) As %Library.Query(ROWSPEC = "ID,DataCode,DataDesc,StDate,EndDate")
{
}

/// 根据代码得到代码表Id,此方法默认代码是不重复的,前台也需要控制代码不能重复
ClassMethod GetIdByCode(Code As %String, ParRef As %String) As %String
{
	Q:(Code="")||(ParRef="") ""
	s Code=$$ALPHAUP^SSUTIL4(Code)
	s ChildSub=$o(^DHCDocCTi(0,"DefineData",Code,"Code",ParRef,0))
	Q:ChildSub="" ""
	Q ParRef_"||"_ChildSub
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCDocCT("DefineData",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCDoc_CT_DefineData_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCDoc_CT_DefineData_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCDoc_CT_DefineData_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCDoc_CT_DefineData_StDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHCDoc_CT_Define.RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHCDoc_CT_Define_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DefineData"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{DHCDoc_CT_Define.RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"D"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCDoc_CT_Define_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDocCTi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCDoc_CT_Define.RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHCDoc_CT_Define_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DefineData"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCDoc_CT_DefineData_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCDoc_CT_Define.RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCDoc_CT_Define_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHCDoc_CT_Define_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocCTDefineDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCLocGroup Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LG_RowId, SqlTableName = DHC_LocGroup, StorageStrategy = Default ]
{

Parameter EXTENTSIZE = 250;

Property LGCTLocDR As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = LG_CTLOC_DR ];

Property LGLocGroupCode As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = LG_LOCGROUPCODE ];

Property CreateDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, SqlColumnNumber = 4, SqlFieldName = LG_CreateDate ];

Property CreateTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 5, SqlFieldName = LG_CreateTime ];

Index LGCTLocDRIndex On LGCTLocDR As String;

ClassMethod getRowIdByLocDR(locDR As %String) As %String
{
	q:locDR="" -1
	s RowId=""
	s id=0
	f  s id=$O(^User.DHCLocGroupD(id)) q:(id="")!(RowId'="")  d
	.s loc=$listget(^User.DHCLocGroupD(id),2)
	.i loc=locDR s RowId=id
	q RowId
}

ClassMethod getGroupByLocDR(locDR As %String) As %String
{
	n (locDR)
	q:locDR="" -1
	s groupId=""
	s id=0
	f  s id=$O(^User.DHCLocGroupD(id)) q:(id="")!(groupId'="")  d
	.s loc=$listget(^User.DHCLocGroupD(id),2)
	.q:(loc'=locDR)
	.s groupId=$listget(^User.DHCLocGroupD(id),3)
	q groupId
}

ClassMethod getLocByGroupId(locDR As %String) As %String
{
	n (locDR)
	q:locDR="" -1
	s locId=""
	s id=0
	f  s id=$O(^User.DHCLocGroupD(id)) q:(id="")!(locId'="")  d
	.s Group=$listget(^User.DHCLocGroupD(id),3)
	.q:Group'=locDR
	.s locId=$listget(^User.DHCLocGroupD(id),2)
	q locId
}

ClassMethod getLocStr(Grouploc As %String = "") As %String
{
	s retStr=""
	s id=0
	f  s id=$O(^User.DHCLocGroupD(id)) q:(id="")  d
	.s loc=$listget(^User.DHCLocGroupD(id),2)
	.s group=$listget(^User.DHCLocGroupD(id),3)
	.q:(group="")
	.q:loc=""
	.q:(Grouploc'="")&&(group'=Grouploc)
	.i retStr="" s retStr="^"_loc_"^"
	.e  i (("^"_loc_"^")'[retStr)  s retStr=retStr_loc_"^"
	q retStr
}

Storage Default
{
<Data name="DHCLocGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LGCTLocDR</Value>
</Value>
<Value name="3">
<Value>LGLocGroupCode</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCLocGroupD</DataLocation>
<DefaultData>DHCLocGroupDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCLocGroupD</IdLocation>
<IndexLocation>^User.DHCLocGroupI</IndexLocation>
<SqlIdExpression>$i(^LOCGROUP(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LG_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LG_LOCGROUPCODE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^LOCGROUP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LG_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{LG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCLocGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="LG_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LG_LOCGROUPCODE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^LOCGROUP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{LG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCLocGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

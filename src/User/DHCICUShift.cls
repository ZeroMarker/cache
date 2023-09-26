/// DHC_ICU_Shift
Class User.DHCICUShift Extends %Library.Persistent [ ProcedureBlock, SqlRowIdName = ICUS_RowId, SqlTableName = DHC_ICU_Shift, StorageStrategy = CacheSQLStorage ]
{

Relationship ICUSParref As User.DHCICUArrange [ Cardinality = parent, Inverse = ChildDHCICUShift, Required, SqlFieldName = ICUS_Parref ];

Relationship ChildDHCICUShiftItem As User.DHCICUShiftItem [ Cardinality = children, Inverse = ICUSIParref ];

Index ICUSChildSub On ICUSChildSub [ IdKey, PrimaryKey, Unique ];

/// For P5 ///Property ICUSChildSub As %Numeric [ InitialExpression = {$i(^DHCICUArrange($p($s($d(p1):p1,1:%d(0)),$c(1),1),"Shift",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUS_ChildSub ];
Property ICUSChildSub As %Numeric [ InitialExpression = {$i(^DHCICUArrange($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"Shift",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUS_ChildSub ];

Property ICUSDate As %Date [ SqlColumnNumber = 3, SqlFieldName = ICUS_Date ];

Property ICUSTime As %Time [ SqlColumnNumber = 4, SqlFieldName = ICUS_Time ];

Property ICUSType As %String(DISPLAYLIST = ",Day,Shift,Other", MAXLEN = 5, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",D,S,O") [ SqlColumnNumber = 5, SqlFieldName = ICUS_Type ];

Property ICUSShiftCtcpDr As %String [ SqlColumnNumber = 6, SqlFieldName = ICUS_ShiftCtcp_Dr ];

Property ICUSReliefCtcpDr As %String [ SqlColumnNumber = 7, SqlFieldName = ICUS_ReliefCtcp_Dr ];

Storage CacheSQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ICUS_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUS_ReliefCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUS_ShiftCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUS_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUS_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCICUArrange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ICU_Arrange.ICUA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ICUS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_ICU_Arrange.ICUA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shift"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUS_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCICUArrange</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_ICU_Arrange.ICUA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ICUS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ShiftDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUS_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_ICU_Arrange.ICUA_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ICUS_RowId</SqlRowIdName>
<StreamLocation>^User.DHCICUShiftS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

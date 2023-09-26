/// Create Time：20130901
/// 健康教育评估
Class DHCMGNUR.DHCHlthEduAss Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, StorageStrategy = SQLStorage ]
{

/// 指向病人信息表PAPatMas的HEA_RowId
Property HEAPAPMDR As User.PAAdm [ Required, SqlColumnNumber = 2, SqlFieldName = HEA_PAPM_DR ];

/// 教育日期HEA_Date
Property HEADate As %Date [ SqlColumnNumber = 3, SqlFieldName = HEA_Date ];

/// 教育时间HEA_Time
Property HEATime As %Time [ SqlColumnNumber = 4, SqlFieldName = HEA_Time ];

/// 健康教育个性化需求HEA_IdvdNd
Property HEAIdvdNd As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = HEA_IdvdNd ];

/// 教育项目HEA_Project
Property HEAProject As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = HEA_Project ];

/// 教育对象HEA_Object
Property HEAObject As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = HEA_Object ];

/// 教育时机HEA_Opportunity
Property HEAOpportunity As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = HEA_Opportunity ];

/// 教育方法HEA_Method
Property HEAMethod As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = HEA_Method ];

/// 效果评价HEA_EffectAss
Property HEAEffectAss As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = HEA_EffectAss ];

/// 教育者HEA_Teacher
Property HEATeacher As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = HEA_Teacher ];

/// 备注HEA_Remarks
Property HEARemarks As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = HEA_Remarks ];

Property HEAValid As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = HEA_Valid ];

Parameter EXTENSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^HEDUA(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="HEA_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HEA_EffectAss">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HEA_IdvdNd">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HEA_Method">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HEA_Object">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HEA_Opportunity">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HEA_PAPM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HEA_Project">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HEA_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HEA_Teacher">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HEA_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HEA_Valid">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^HEDUA</Global>
<RowIdSpec name="1">
<Field>{HEA_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{HEA_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHEAByDate">
<Condition>1</Condition>
<Global>^HEDUA</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>{HEA_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{HEA_Date}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HEADATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HEA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHEAByPAPMDR">
<Global>^HEDUA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>{HEA_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{HEA_PAPM_DR}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HEAPAPM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HEA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHEAPIData">
<Global>^HEDUA</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>{HEA_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{HEA_Project}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HEAPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HEA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HEA_RowId</SqlRowIdName>
<StreamLocation>^DHCMGNUR.DHCHlthEduAssS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

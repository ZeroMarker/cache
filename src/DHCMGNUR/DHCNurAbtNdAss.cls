/// Create Time: 20130901
/// 教育能力需求评估表
Class DHCMGNUR.DHCNurAbtNdAss Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, StorageStrategy = SQLStorage ]
{

/// 指向PA_PatMas表EANA_PAPMi_Dr
Property EANAPAPMDr As User.PAAdm [ Required, SqlColumnNumber = 2, SqlFieldName = EANA_PAPMDr ];

/// 评估日期EANA_Date
Property EANADate As %Date [ SqlColumnNumber = 3, SqlFieldName = EANA_Date ];

/// 评估时间EANA_Time
Property EANATime As %Time [ SqlColumnNumber = 4, SqlFieldName = EANA_Time ];

/// 评估对象EANA_Object
Property EANAObject As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = EANA_Object ];

/// 语言交流
Property EANALangTalk As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = EANA_LangTalk ];

/// 阅读能力
Property EANAReadAbt As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = EANA_ReadAbt ];

/// 书写能力
Property EANAWriteAbt As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = EANA_WriteAbt ];

/// 理解能力
Property EANAUnderStandAbt As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = EANA_UnderStandAbt ];

/// 实施能力
Property EANAImplementAbt As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = EANA_ImplementAbt ];

/// 可接受方法
Property EANAAcceptWay As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = EANA_AcceptWay ];

/// 乐意接受内容
Property EANALkAcptContent As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = EANA_LkAcptContent ];

/// 护士签名
Property EANANurSign As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = EANA_NurSign ];

Property EANAValid As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = EANA_Valid ];

Parameter EXENTSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^EDUANA(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="EANA_AcceptWay">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EANA_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EANA_ImplementAbt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EANA_LangTalk">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EANA_LkAcptContent">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EANA_NurSign">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EANA_Object">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EANA_PAPMDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EANA_ReadAbt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EANA_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EANA_UnderStandAbt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EANA_Valid">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EANA_WriteAbt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^EDUANA</Global>
<RowIdSpec name="1">
<Field>{EANA_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EANA_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEANAByDate">
<Condition>1</Condition>
<Global>^EDUANA</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>{EANA_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EANA_Date}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EANADATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EANA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEANAByPAPMDR">
<Global>^EDUANA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>{EANA_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EANA_PAPMDr}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EANAPAPM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EANA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EANA_RowId</SqlRowIdName>
<StreamLocation>^MHCMGNUR.DHCNurEduAbtNdAssS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

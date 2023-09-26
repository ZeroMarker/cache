/// CT Sex                   (CTSEX,23)
/// 性别字典
Class User.CTSex Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Sex, StorageStrategy = SQLStorage ]
{

/// 性别代码
Property CTSEXCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTSEX_Code ];

/// 性别名称
Property CTSEXDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTSEX_Desc ];

/// Grouper Code
Property CTSEXGrouperCode As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CTSEX_GrouperCode ];

/// 开始日期
Property CTSEXDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = CTSEX_DateFrom ];

/// 结束日期
Property CTSEXDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = CTSEX_DateTo ];

/// CTSEX
Property CTSEXGender As %String(MAXLEN = 201, TRUNCATE = 1, VALUELIST = ",M||Male,F||Female,U||Unknown") [ SqlColumnNumber = 8, SqlFieldName = CTSEX_Gender ];

/// HL7 Code
Property CTSEXHL7Code As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CTSEX_HL7Code ];

/// 是否有效(Y/N)add@20220923
Property CTSEXActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 10, SqlFieldName = CTSEX_Activity ];

/// 系统创建日期
Property CTSEXCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11, SqlFieldName = CTSEX_CreateDate ];

/// 系统创建时间
Property CTSEXCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12, SqlFieldName = CTSEX_CreateTime ];

/// 系统创建人
Property CTSEXCreateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = CTSEX_CreateUser ];

/// 系统排序号
Property CTSEXSeqNo As %Float [ SqlColumnNumber = 14, SqlFieldName = CTSEX_SeqNo ];

/// 系统最后更新日期
Property CTSEXLastUpdateDate As %Date [ SqlColumnNumber = 15, SqlFieldName = CTSEX_LastUpdateDate ];

/// 系统最后更新时间
Property CTSEXLastUpdateTime As %Time [ SqlColumnNumber = 16, SqlFieldName = CTSEX_LastUpdateTime ];

/// 系统最新更新人
Property CTSEXLastUpdateUser As User.SSUser [ SqlColumnNumber = 17, SqlFieldName = CTSEX_LastUpdateUser ];

/// 拼音码
Property CTSEXPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = CTSEX_PYCode ];

/// 五笔码
Property CTSEXWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = CTSEX_WBCode ];

/// 备注
Property CTSEXMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = CTSEX_Mark ];

Index CTSEXCodeUnqIdx1 On CTSEXCode [ Unique ];

Index CTSEXDescUnqIdx2 On CTSEXDesc [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTSex).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTSex","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTSex).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTSex","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTSex).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTSex","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTSex).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTSex","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTSex).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTSex","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("SEX",0))</SqlIdExpression>
<SQLMap name="DataMasterCTSEX">
<Data name="CTSEX_Activity">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTSEX_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTSEX_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTSEX_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTSEX_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTSEX_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTSEX_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTSEX_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTSEX_Gender">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTSEX_GrouperCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTSEX_HL7Code">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTSEX_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CTSEX_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CTSEX_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CTSEX_Mark">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CTSEX_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CTSEX_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTSEX_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTSEX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SEX"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTSEX_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTSEXCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTSEX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SEX"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTSEX_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTSEX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTSEXDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTSEX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SEX"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTSEX_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTSEX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTSEX_RowId</SqlRowIdName>
<StreamLocation>^User.CTSexS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

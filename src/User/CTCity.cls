/// CT City                  (CTCIT,52)
Class User.CTCity Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_City, StorageStrategy = SQLStorage ]
{

/// 市级行政区代码
Property CTCITCode As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTCIT_Code ];

/// 市级行政区名称
Property CTCITDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CTCIT_Desc ];

/// Fiscal Prefix
Property CTCITFiscalPrefix As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CTCIT_FiscalPrefix ];

/// 省份-外键
Property CTCITProvinceDR As User.CTProvince [ SqlColumnNumber = 6, SqlFieldName = CTCIT_Province_DR ];

/// 开始日期
Property CTCITDateFrom As %Date [ SqlColumnNumber = 7, SqlFieldName = CTCIT_DateFrom ];

/// 结束日期
Property CTCITDateTo As %Date [ SqlColumnNumber = 8, SqlFieldName = CTCIT_DateTo ];

/// Locality Type
Property CTCITLocalityType As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CTCIT_LocalityType ];

/// National Code
Property CTCITNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CTCIT_NationalCode ];

/// 市级行政区罗马代码add@20220923
Property CTCITRomanCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CTCIT_RomanCode ];

/// 市级行政区罗马名称
Property CTCITRomanDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CTCIT_RomanDesc ];

/// 是否有效(Y/N)
Property CTCITActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 13, SqlFieldName = CTCIT_Activity ];

/// 系统创建日期
Property CTCITCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 14, SqlFieldName = CTCIT_CreateDate ];

/// 系统创建时间
Property CTCITCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 15, SqlFieldName = CTCIT_CreateTime ];

/// 系统创建人
Property CTCITCreateUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = CTCIT_CreateUser ];

/// 系统排序号
Property CTCITSeqNo As %Float [ SqlColumnNumber = 17, SqlFieldName = CTCIT_SeqNo ];

/// 系统最后更新日期
Property CTCITLastUpdateDate As %Date [ SqlColumnNumber = 18, SqlFieldName = CTCIT_LastUpdateDate ];

/// 系统最后更新时间
Property CTCITLastUpdateTime As %Time [ SqlColumnNumber = 19, SqlFieldName = CTCIT_LastUpdateTime ];

/// 系统最新更新人
Property CTCITLastUpdateUser As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = CTCIT_LastUpdateUser ];

/// 拼音码
Property CTCITPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = CTCIT_PYCode ];

/// 五笔码
Property CTCITWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = CTCIT_WBCode ];

/// 备注
Property CTCITMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = CTCIT_Mark ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTCity).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCity","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTCity).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCity","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTCity).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCity","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTCity).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCity","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTCity).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCity","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("CIT",0))</SqlIdExpression>
<SQLMap name="DataMasterCTCIT">
<Data name="CTCIT_Activity">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTCIT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTCIT_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTCIT_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CTCIT_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CTCIT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTCIT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTCIT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTCIT_FiscalPrefix">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTCIT_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CTCIT_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CTCIT_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CTCIT_LocalityType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTCIT_Mark">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CTCIT_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTCIT_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CTCIT_Province_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTCIT_RomanCode">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTCIT_RomanDesc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTCIT_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CTCIT_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTCIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CIT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTCIT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTCITCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTCIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CIT"</Expression>
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
<Expression>$$ALPHAUP({CTCIT_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTCIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTCITDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTCIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CIT"</Expression>
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
<Expression>$$ALPHAUP({CTCIT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTCIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CTCIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CIT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ProvCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTCIT_Province_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({CTCIT_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CTCIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CTCIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CIT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ProvDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTCIT_Province_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({CTCIT_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CTCIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTCIT_RowId</SqlRowIdName>
<StreamLocation>^User.CTCityS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

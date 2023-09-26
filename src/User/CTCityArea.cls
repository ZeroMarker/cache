/// CT City Area(1576)
Class User.CTCityArea Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_CityArea, StorageStrategy = SQLStorage ]
{

/// 县级行政区代码
Property CITAREACode As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CITAREA_Code ];

/// 县级行政区名称
Property CITAREADesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CITAREA_Desc ];

/// 城市-外键
Property CITAREACityDR As User.CTCity [ SqlColumnNumber = 4, SqlFieldName = CITAREA_City_DR ];

/// 开始日期
Property CITAREADateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = CITAREA_DateFrom ];

/// 结束日期
Property CITAREADateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = CITAREA_DateTo ];

/// Des Ref Locality
Property CITAREALocalityDR As CTLocalityType [ SqlColumnNumber = 7, SqlFieldName = CITAREA_Locality_DR ];

/// 县级行政区罗马代码add@20220923
Property CITAREARomanCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CITAREA_RomanCode ];

/// 县级行政区罗马代码
Property CITAREARomanDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CITAREA_RomanDesc ];

/// 是否有效(Y/N)
Property CITAREAActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 10, SqlFieldName = CITAREA_Activity ];

/// 系统创建日期
Property CITAREACreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11, SqlFieldName = CITAREA_CreateDate ];

/// 系统创建时间
Property CITAREACreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12, SqlFieldName = CITAREA_CreateTime ];

/// 系统创建人
Property CITAREACreateUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = CITAREA_CreateUser ];

/// 系统排序号
Property CITAREASeqNo As %Float [ SqlColumnNumber = 14, SqlFieldName = CITAREA_SeqNo ];

/// 系统最后更新日期
Property CITAREALastUpdateDate As %Date [ SqlColumnNumber = 15, SqlFieldName = CITAREA_LastUpdateDate ];

/// 系统最后更新时间
Property CITAREALastUpdateTime As %Time [ SqlColumnNumber = 16, SqlFieldName = CITAREA_LastUpdateTime ];

/// 系统最新更新人
Property CITAREALastUpdateUser As User.SSUser [ SqlColumnNumber = 17, SqlFieldName = CITAREA_LastUpdateUser ];

/// 拼音码
Property CITAREAPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = CITAREA_PYCode ];

/// 五笔码
Property CITAREAWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = CITAREA_WBCode ];

/// 备注
Property CITAREAMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = CITAREA_Mark ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTCityArea).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCityArea","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTCityArea).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCityArea","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTCityArea).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCityArea","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTCityArea).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCityArea","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTCityArea).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCityArea","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCityArea","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("CITAREA",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CITAREA_Activity">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CITAREA_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CITAREA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CITAREA_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CITAREA_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CITAREA_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CITAREA_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CITAREA_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CITAREA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CITAREA_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CITAREA_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CITAREA_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CITAREA_Locality_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CITAREA_Mark">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CITAREA_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CITAREA_RomanCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CITAREA_RomanDesc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CITAREA_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CITAREA_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CITAREA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CITAREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CITAREA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCityCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CITAREA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CITAREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CityCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CITAREA_City_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({CITAREA_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CITAREA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCityDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CITAREA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CITAREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CityDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CITAREA_City_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({CITAREA_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CITAREA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CITAREA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CITAREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CITAREA_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CITAREA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CITAREA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CITAREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CITAREA_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CITAREA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CITAREA_RowId</SqlRowIdName>
<StreamLocation>^User.CTCityAreaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

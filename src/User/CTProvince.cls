/// CT Province(1402)
Class User.CTProvince Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Province, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 30;

/// 省级行政区代码
Property PROVCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PROV_Code ];

/// 省级行政区名称
Property PROVDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PROV_Desc ];

/// 区域指针
Property PROVRegionDR As CTRegion [ SqlColumnNumber = 4, SqlFieldName = PROV_Region_DR ];

/// 开始日期
Property PROVDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = PROV_DateFrom ];

/// 结束日期
Property PROVDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = PROV_DateTo ];

/// NationalCode
Property PROVNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PROV_NationalCode ];

/// 省级行政区罗马代码add@20220923
Property PROVRomanCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PROV_RomanCode ];

/// 省级行政区罗马名称
Property PROVRomanDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PROV_RomanDesc ];

/// 国家-外键
Property PROVCountryCode As User.CTCountry [ SqlColumnNumber = 10, SqlFieldName = PROV_CountryCode ];

/// 是否有效(Y/N)
Property PROVActivity As %String [ InitialExpression = "Y", SqlColumnNumber = 11, SqlFieldName = PROV_Activity ];

/// 系统创建日期
Property PROVCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 12, SqlFieldName = PROV_CreateDate ];

/// 系统创建时间
Property PROVCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 13, SqlFieldName = PROV_CreateTime ];

/// 系统创建人
Property PROVCreateUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = PROV_CreateUser ];

/// 系统排序号
Property PROVSeqNo As %Float [ SqlColumnNumber = 15, SqlFieldName = PROV_SeqNo ];

/// 系统最后更新日期
Property PROVLastUpdateDate As %Date [ SqlColumnNumber = 16, SqlFieldName = PROV_LastUpdateDate ];

/// 系统最后更新时间
Property PROVLastUpdateTime As %Time [ SqlColumnNumber = 17, SqlFieldName = PROV_LastUpdateTime ];

/// 系统最新更新人
Property PROVLastUpdateUser As User.SSUser [ SqlColumnNumber = 18, SqlFieldName = PROV_LastUpdateUser ];

/// 拼音码
Property PROVPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PROV_PYCode ];

/// 五笔码
Property PROVWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = PROV_WBCode ];

/// 备注
Property PROVMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = PROV_Mark ];

Index PROVCodeUnqIdx1 On PROVCode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTProvince).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTProvince","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTProvince).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTProvince","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTProvince).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTProvince","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTProvince).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTProvince","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTProvince).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTProvince","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>30</ExtentSize>
<Property name="PROVCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="PROVDateFrom">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PROVDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PROVDesc">
<Selectivity>3.3333%</Selectivity>
</Property>
<Property name="PROVNationalCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PROVRegionDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("PROV",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PROV_Activity">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PROV_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PROV_CountryCode">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PROV_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PROV_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PROV_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PROV_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PROV_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PROV_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PROV_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PROV_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PROV_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PROV_Mark">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PROV_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PROV_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PROV_Region_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PROV_RomanCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PROV_RomanDesc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PROV_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PROV_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PROV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PROV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PROV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PROV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PROV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PROV_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PROV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PROV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PROV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PROV_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PROV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PROV_RowId</SqlRowIdName>
<StreamLocation>^User.CTProvinceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

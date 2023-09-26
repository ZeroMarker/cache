/// 排班管理-排班子表
Class User.PIVAScheArrangeItm Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = PIVA_ScheArrangeItm, StorageStrategy = CacheSQLStorage ]
{

Index RowIDBasedIDKeyIndex On PSAIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PSAIParref As User.PIVAScheArrange [ Cardinality = parent, Inverse = ChildPIVAScheArrangeItm, Required, SqlFieldName = PSAI_Parref ];

Property PSAIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PSAI_ChildSub ];

/// 日期
Property PSAIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PSAI_Date ];

/// 人员
Property PSAIUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PSAI_User_Dr ];

/// 班次
Property PSAISchedulDr As User.PIVASchedul [ SqlColumnNumber = 5, SqlFieldName = PSAI_Schedul_Dr ];

/// 岗位,关联对照会发生变化,但历史数据不应该变化
Property PSAIDutyDr As User.PIVADuty [ SqlColumnNumber = 6, SqlFieldName = PSAI_Duty_Dr ];

Storage CacheSQLStorage
{
<SQLMap name="DataMaster">
<Data name="PSAI_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PSAI_Duty_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PSAI_Schedul_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PSAI_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^Busi.PIVA.ScheArrange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_ScheArrange.PSA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PSAI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIVA_ScheArrange.PSA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PSAI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PSAI_RowId</SqlRowIdName>
<StreamLocation>^User.PIVAScheArrangeItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCDocCureTriage Extends %Persistent [ SqlTableName = DHC_DocCureTriage, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DDCTChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocCureApp Parent Reference
Relationship DDCTParRef As User.DHCDocCureApp [ Cardinality = parent, Inverse = ChildDHCDocCureTriage, Required, SqlFieldName = DDCT_ParRef ];

/// DDCT_ChildSub
Property DDCTChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCureTRI($p(%d(0),$c(1)),"Triage",0))}, SqlColumnNumber = 2, SqlFieldName = DDCT_ChildSub ];

/// DDCT_RBAS_DR  分配资源关联
Property DDCTRBASDR As User.DHCDocCureTriageResource [ SqlColumnNumber = 3, SqlFieldName = DDCT_RBAS_DR ];

/// DDCT_LastUpdateUser_DR  分诊人
Property DDCTTriageUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = DDCT_TriageUser_DR ];

/// DDCT_LastUpdateDate  分诊日期
Property DDCTTriageDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = DDCT_TriageDate ];

/// DDCT_LastUpdateTime  分诊时间
Property DDCTTriageTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DDCT_TriageTime ];

/// DCA_Status 分配状态   T 已分配，A已接收,C取消分配
Property DDCTStatus As %Library.String(DISPLAYLIST = ",Triage,Arrive,Cancel", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",T,A,C") [ SqlColumnNumber = 7, SqlFieldName = DDCT_Status ];

/// 取消分诊操作用户
Property DDCTCancelTriageUserDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = DDCT_CancelTriageUser_DR ];

/// DDCT_LastUpdateDate  取消分诊日期
Property DDCTCancelTriageDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = DDCT_CancelTriageDate ];

/// DDCT_LastUpdateTime  取消分诊时间
Property DDCTCancelTriageTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DDCT_CancelTriageTime ];

/// 接收分配操作用户
Property DDCTArriveUserDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = DDCT_ArriveUser_DR ];

/// DDCT_LastUpdateDate  更新日期
Property DDCTArriveDate As %Library.Date [ SqlColumnNumber = 12, SqlFieldName = DDCT_ArriveDate ];

/// DDCT_LastUpdateTime  更新时间
Property DDCTArriveTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = DDCT_ArriveTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DDCT_ArriveDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DDCT_ArriveTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DDCT_ArriveUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DDCT_CancelTriageDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DDCT_CancelTriageTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DDCT_CancelTriageUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DDCT_RBAS_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCT_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDCT_TriageDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDCT_TriageTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDCT_TriageUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocCureTRI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DDCT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Triage"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCT_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRBAS">
<Global>^DHCDocCureTRIi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DDCT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RBAS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCT_RBAS_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDCT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSTATRBAS">
<Global>^DHCDocCureTRIi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DDCT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StatuRBAS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCT_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCT_RBAS_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DDCT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHCDocCureTRI_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocCureTriageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

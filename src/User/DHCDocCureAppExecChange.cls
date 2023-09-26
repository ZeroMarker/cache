Class User.DHCDocCureAppExecChange Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = DCAEC_RowId, SqlTableName = DHC_DocCure_AppExecChange, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DCAECChildSub [ IdKey, PrimaryKey, Unique ];

Relationship DCAECParRef As User.DHCDocCureApp [ Cardinality = parent, Inverse = ChildDHCDocCureExecChange, Required, SqlFieldName = DCAEC_ParRef ];

Property DCAECChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCure($p(%d(0),$c(1)),"DCAEC",0))}, SqlColumnNumber = 2, SqlFieldName = DCAEC_ChildSub ];

/// DCAEC_Date  修改日期
Property DCAECDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = DCAEC_Date ];

/// DCAEC_Time  修改时间
Property DCAECTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DCAEC_Time ];

/// DCAEC_User_DR  修改用户
Property DCAECUserDR As %Library.String [ SqlColumnNumber = 5, SqlFieldName = DCAEC_User_DR ];

/// DCAEC_Type 执行操作
Property DCAECType As %Library.String(DISPLAYLIST = ",Exec,Cancel,Stop", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",E,C,S") [ SqlColumnNumber = 6, SqlFieldName = DCAEC_Type ];

/// DCAEC_ExecNum 操作次数
Property DCAECExecNum As %Library.String [ SqlColumnNumber = 7, SqlFieldName = DCAEC_ExecNum ];

/// DCAEC_LastUpdateDate
Property DCAECLastUpdateDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = DCAEC_LastUpdateDate ];

/// DCAEC_LastUpdateTime
Property DCAECLastUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = DCAEC_LastUpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DCAEC_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCAEC_ExecNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCAEC_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCAEC_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DCAEC_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCAEC_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCAEC_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCure</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DCAEC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DCAEC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAEC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexECType">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DCAEC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AECTYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAEC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCAEC_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCAEC_Time}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DCAEC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocCureAppExecChangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

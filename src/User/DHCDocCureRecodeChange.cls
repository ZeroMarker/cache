/// 治疗记录改变表(治疗记录表子表)
Class User.DHCDocCureRecodeChange Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCRC_RowId, SqlTableName = DHC_DocCureRecodeChange, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DCRCChildSub [ IdKey, PrimaryKey, Unique ];

/// User.DHCDocCureRecode Parent Reference
Relationship DCRCParRef As User.DHCDocCureRecode [ Cardinality = parent, Inverse = ChildDHCDocCureRecodeChange, Required, SqlFieldName = DCRC_ParRef ];

/// DCRC_ChildSub
Property DCRCChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCure(+$s($d(initvalue):initvalue,1:%d(0)),"Recode",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"Change",0))}, SqlColumnNumber = 2, SqlFieldName = DCRC_ChildSub ];

/// DCRC_Date  修改日期
Property DCRCDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = DCRC_Date ];

/// DCRC_Time  修改时间
Property DCRCTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DCRC_Time ];

/// DCRC_User_DR  修改用户
Property DCRCUserDR As %Library.String [ SqlColumnNumber = 5, SqlFieldName = DCRC_User_DR ];

/// DCRC_Content 修改内容
Property DCRCContent As %Library.String(MAXLEN = 5000) [ SqlColumnNumber = 6, SqlFieldName = DCRC_Content ];

/// DCRC_OPDate 操作日期
Property DCRCOPDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = DCRC_OPDate ];

/// DCRC_OPTime 操作时间
Property DCRCOPTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = DCRC_OPTime ];

/// DCRC_LastUpdateDate
Property DCRCLastUpdateDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = DCRC_LastUpdateDate ];

/// DCRC_LastUpdateTime
Property DCRCLastUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DCRC_LastUpdateTime ];

/// DCRC_LastUpdateUser_DR
Property DCRCLastUpdateUserDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = DCRC_LastUpdateUser_DR ];

/// DCRC_Remark
Property DCRCRemark As %Library.String [ SqlColumnNumber = 12, SqlFieldName = DCRC_Remark ];

/// DCRC_Text1
Property DCRCText1 As %Library.String [ SqlColumnNumber = 13, SqlFieldName = DCRC_Text1 ];

/// DCRC_Text2
Property DCRCText2 As %Library.String [ SqlColumnNumber = 14, SqlFieldName = DCRC_Text2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DCRC_Content">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCRC_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCRC_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DCRC_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DCRC_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DCRC_OPDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCRC_OPTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCRC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DCRC_Text1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DCRC_Text2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DCRC_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCRC_User_DR">
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
<Field>DHC_DocCureRecode.DCR_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DCRC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Recode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocCureRecode.DCR_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Change"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCRC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DCRC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocCureRecodeChangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

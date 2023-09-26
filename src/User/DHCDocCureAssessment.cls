/// 治疗评估
Class User.DHCDocCureAssessment Extends %Persistent [ Not ProcedureBlock, SqlRowIdName = DCAASS_RowID, SqlTableName = DHC_DocCureAssessment, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DCAssChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocCureApp Parent Reference
Relationship DCAssParRef As User.DHCDocCureApp [ Cardinality = parent, Inverse = ChildDHCDocCureAssessment, Required, SqlFieldName = DCAss_ParRef ];

/// DCAss_ChildSub
Property DCAssChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCure($p(%d(0),$c(1)),"ASS",0))}, SqlColumnNumber = 2, SqlFieldName = DCAss_ChildSub ];

/// DCAss_CreateUser_DR 创建人
Property DCAssCreateUserDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = DCAss_CreateUser_DR ];

/// DCAss_CreateDate 创建日期
Property DCAssCreateDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = DCAss_CreateDate ];

/// DCAss_CreateTime 创建时间
Property DCAssCreateTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = DCAss_CreateTime ];

/// DCAss_Content 评估内容
Property DCAssContent As %Library.String(MAXLEN = 9999) [ SqlColumnNumber = 6, SqlFieldName = DCAss_Content ];

/// DCAss_CreateUser_DR 最后更新人
Property DCAssLastUpdateUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DCAss_LastUpdateUser_DR ];

/// DCAss_CreateDate 最后更新日期
Property DCAssLastUpdateDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = DCAss_LastUpdateDate ];

/// DCAss_CreateTime 最后更新时间
Property DCAssLastUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = DCAss_LastUpdateTime ];

/// DCAss_UpdateStatus 提交状态 N 暂存，Y 保存提交
Property DCAssUpdateStatus As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = DCAss_UpdateStatus ];

/// DCAss_ActiveFlag 有效状态 N 无效，Y 有效
Property DCAssActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = DCAss_ActiveFlag ];

/// DCAA_OEOrdExec_DR  执行记录关联
Property DCAssOEOrdExecDR As User.OEOrdExec [ SqlColumnNumber = 12, SqlFieldName = DCAss_OEOrdExec_DR ];

/// DCAss_Content 评估内容
Property DCAssContentJsonStr As %Library.String(MAXLEN = 99999) [ SqlColumnNumber = 13, SqlFieldName = DCAss_Content_JsonStr ];

/// DCAss_MapID 保存时所用的模板ID
Property DCAssMapID As %Library.String [ SqlColumnNumber = 14, SqlFieldName = DCAss_MapID ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DCAss_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DCAss_Content">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCAss_Content_JsonStr">
<Node>"JsonStr"</Node>
</Data>
<Data name="DCAss_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCAss_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCAss_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCAss_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCAss_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DCAss_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCAss_MapID">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DCAss_OEOrdExec_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DCAss_UpdateStatus">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCDocCure</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DCAss_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ASS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAss_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOEOrdExec">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DCAss_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AssOrdExec"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAss_OEOrdExec_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCAss_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCAASS_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocCureAssessmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

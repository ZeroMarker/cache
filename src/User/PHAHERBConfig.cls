Class User.PHAHERBConfig Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCF_RowID, SqlTableName = PHAHERB_Config, StorageStrategy = sqlStorage ]
{

Property PHCFCtlocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PHCF_Ctloc_Dr ];

Property PHCFPresTypeDr As User.PHAHERBPresType [ SqlColumnNumber = 3, SqlFieldName = PHCF_PresType_Dr ];

Property PHCFPresChkFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 4, SqlFieldName = PHCF_PresChkFlag ];

Property PHCFPresChkSel As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHCF_PresChkSel ];

Property PHCFPatRepFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = PHCF_PatRepFlag ];

Property PHCFPrintPresFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 7, SqlFieldName = PHCF_PrintPresFlag ];

Property PHCFPrintLabSelect As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHCF_PrintLabSelect ];

Property PHCFCallFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 9, SqlFieldName = PHCF_CallFlag ];

Property PHCFScreenFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 10, SqlFieldName = PHCF_ScreenFlag ];

/// 是否揭药室全送
Property PHCFPresAllSendFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 11, SqlFieldName = PHCF_PresAllSendFlag ];

/// 是否允许退药
Property PHCFPresAgreeRetFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 12, SqlFieldName = PHCF_PresAgreeRetFlag ];

/// 是否打印调剂单
Property PHCFPrintDispSheet As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 13, SqlFieldName = PHCF_PrintDispSheet ];

/// 就诊类型
Property PHCFAdmType As %String(DISPLAYLIST = ",OP,EM,IP", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",O,E,I") [ InitialExpression = "N", SqlColumnNumber = 14, SqlFieldName = PHCF_AdmType ];

Storage sqlStorage
{
<SqlIdExpression>$i(^CF.PHA.HERB.Config(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHCF_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHCF_CallFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHCF_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCF_PatRepFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHCF_PresAgreeRetFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHCF_PresAllSendFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHCF_PresChkFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHCF_PresChkSel">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHCF_PresType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCF_PrintDispSheet">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHCF_PrintLabSelect">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHCF_PrintPresFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHCF_ScreenFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^CF.PHA.HERB.Config</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHCF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^CF.PHA.HERB.Configi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHCF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHCF_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocFormType">
<Global>^CF.PHA.HERB.Configi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHCF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LocFormType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHCF_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCF_PresType_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCF_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocPresType">
<Global>^CF.PHA.HERB.Configi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LocPresType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHCF_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCF_PresType_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHAHERBConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

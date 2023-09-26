/// 揭药主表（新疆中医院） 2017-08-23 hulihua 
/// d ##Class(User.DHCPhaMedBroth).%BuildIndices()
Class User.DHCPhaMedBroth Extends (%Persistent, %XML.Adaptor, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMB_RowID, SqlTableName = DHC_PhaMedBroth, StorageStrategy = SQLStorage ]
{

/// 和子表做关联	
Relationship ChildDHCPhaMedBrothItm As User.DHCPhaMedBrothItm [ Cardinality = children, Inverse = PHMBIPHMBParRef ];

/// Patient Information 指向病人信息表
Property PHMBPapmiDR As User.PAPatMas [ SqlColumnNumber = 2, SqlFieldName = PHMB_PapmiDR ];

/// Patient Adm 指向就诊表
Property PHMBAdmDR As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = PHMB_AdmDR ];

/// Pharmacy 药房ID
Property PHMBPHALocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PHMB_PHALocDR ];

/// Prescription Number 处方号
Property PHMBPrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHMB_PrescNo ];

/// 揭药完成标志
Property PHMBMedBroCompFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = PHMB_MedBroCompFlag ];

/// 总袋数
Property PHMBTolPocNum As %Library.Integer [ SqlColumnNumber = 7, SqlFieldName = PHMB_TolPocNum ];

/// 发药主表ID 
Property PHMBPHADR As User.DHCPHACollected [ SqlColumnNumber = 8, SqlFieldName = PHMB_PHA_DR ];

/// 插入揭药表日期
Property PHMBInsertDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = PHMB_InsertDate ];

/// 插入揭药表时间
Property PHMBInsertTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = PHMB_InsertTime ];

/// 是否全送标志
Property PHMBMedAllSendFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 11, SqlFieldName = PHMB_MedAllSendFlag ];

/// 揭药类型
Property PHMBType As %Library.String(DISPLAYLIST = ",Inpatient,Outpatient", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 12, SqlFieldName = PHMB_Type ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHAMEDB)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHMB_AdmDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMB_InsertDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHMB_InsertTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHMB_MedAllSendFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHMB_MedBroCompFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHMB_PHALocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMB_PHA_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHMB_PapmiDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMB_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHMB_TolPocNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHMB_Type">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCPHAMEDB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHMB_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPapCompFlagPres">
<Global>^DHCPHAMEDBi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHMB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PapmiCompFlagPres"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHMB_PapmiDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMB_MedBroCompFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMB_PrescNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHMB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^DHCPHAMEDBi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHMB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PrescNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHMB_PrescNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaMedBrothS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

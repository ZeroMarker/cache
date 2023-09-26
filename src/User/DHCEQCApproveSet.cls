Class User.DHCEQCApproveSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AS_RowID, SqlTableName = DHC_EQCApproveSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AS_ApproveTypeDR
Property ASApproveTypeDR As User.DHCEQCApproveType [ SqlColumnNumber = 2, SqlFieldName = AS_ApproveTypeDR ];

/// AS_Desc
Property ASDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AS_Desc ];

/// AS_Code
Property ASCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AS_Code ];

/// AS_EquipTypeDR ////modified by sjh SJH0042 2020-12-29 
Property ASEquipTypeDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AS_EquipTypeDR ];

/// AS_PurchaseTypeDR
Property ASPurchaseTypeDR As User.DHCEQCPurchaseType [ SqlColumnNumber = 6, SqlFieldName = AS_PurchaseTypeDR ];

/// AS_SpecialTypeDR
Property ASSpecialTypeDR As User.DHCEQCSpecialType [ SqlColumnNumber = 7, SqlFieldName = AS_SpecialTypeDR ];

/// AS_SingleMinFee
Property ASSingleMinFee As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = AS_SingleMinFee ];

/// AS_SingleMaxFee
Property ASSingleMaxFee As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = AS_SingleMaxFee ];

/// AS_AutoAuditFlag
Property ASAutoAuditFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = AS_AutoAuditFlag ];

/// AS_YearFlag
Property ASYearFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = AS_YearFlag ];

/// AS_HospDR
Property ASHospDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AS_HospDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCApproveSet",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AS_ApproveTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AS_AutoAuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AS_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AS_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AS_HospDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AS_PurchaseTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AS_SingleMaxFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AS_SingleMinFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AS_SpecialTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AS_YearFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCApproveSet"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApproveType">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCApproveSet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ApproveType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AS_ApproveTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCApproveSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

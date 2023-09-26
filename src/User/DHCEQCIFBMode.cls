Class User.DHCEQCIFBMode Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IFBM_RowID, SqlTableName = DHC_EQCIFBMode, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IFBM_Code
Property IFBMCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IFBM_Code ];

/// IFBM_Desc
Property IFBMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IFBM_Desc ];

/// IFBM_Remark
Property IFBMRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IFBM_Remark ];

/// IFBM_InvalidFlag
Property IFBMInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = IFBM_InvalidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCIFBMode",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IFBM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IFBM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IFBM_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IFBM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>IFBM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCIFBMode"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{IFBM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCIFBModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

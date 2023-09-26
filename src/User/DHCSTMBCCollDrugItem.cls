Class User.DHCSTMBCCollDrugItem Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MBCI_Rowid, SqlTableName = DHCST_MBCCollDrugItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MBCIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCST_MBCCollDrug Parent Reference
Relationship MBCIParref As User.DHCSTMBCCollDrug [ Cardinality = parent, Inverse = ChildDHCSTMBCCollDrugItem, Required, SqlFieldName = MBCI_Parref ];

/// MBCI_ChildSub
Property MBCIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = MBCI_ChildSub ];

/// MBCI_DateUser_Dr
Property MBCIDateUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = MBCI_DateUser_Dr ];

/// MBCI_Date
Property MBCIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = MBCI_Date ];

/// MBCI_Time
Property MBCITime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = MBCI_Time ];

/// MBCI_State_Dr
Property MBCIStateDr As User.DHCSTMBCState [ SqlColumnNumber = 6, SqlFieldName = MBCI_State_Dr ];

/// MBCI_PrintDate
Property MBCIPrintDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = MBCI_PrintDate ];

/// MBCI_PrintTime
Property MBCIPrintTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = MBCI_PrintTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMBCI">
<Data name="MBCI_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MBCI_DateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MBCI_PrintDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MBCI_PrintTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MBCI_State_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MBCI_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMBC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCST_MBCCollDrug.MBC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MBCI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCST_MBCCollDrug.MBC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCMBC</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITMDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCI_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCST_MBCCollDrug.MBC_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MBCI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateState">
<Global>^DHCMBC</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATESTATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCI_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBCI_State_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCST_MBCCollDrug.MBC_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MBCI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateUser">
<Global>^DHCMBC</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATESSUSER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCI_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBCI_DateUser_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCST_MBCCollDrug.MBC_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MBCI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrintDate">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRINTDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCI_PrintDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCST_MBCCollDrug.MBC_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MBCI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexState">
<Global>^DHCMBC</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITMSTATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCI_State_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCST_MBCCollDrug.MBC_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MBCI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStateDate">
<Global>^DHCMBC</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STATEDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCI_State_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBCI_PrintDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCST_MBCCollDrug.MBC_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MBCI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatePrintDate">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STATEPRINTDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCI_State_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBCI_PrintDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCST_MBCCollDrug.MBC_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MBCI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStateUser">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STATEUSER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCI_State_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBCI_DateUser_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCST_MBCCollDrug.MBC_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MBCI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCMBC</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SSUSER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCI_DateUser_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCST_MBCCollDrug.MBC_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MBCI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDate">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SSUSERDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCI_DateUser_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBCI_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCST_MBCCollDrug.MBC_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MBCI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserPrintDate">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SSUSERPRINTDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCI_DateUser_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBCI_PrintDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCST_MBCCollDrug.MBC_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MBCI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCSTMBCCollDrugItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

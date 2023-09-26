/// DHC_PA_AdmDischarge
Class User.DHCPAAdmDischarge Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADMD_RowId, SqlTableName = DHC_PA_AdmDischarge, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ADMDChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_PA_Adm Parent Reference
Relationship ADMDParref As User.DHCPAAdm [ Cardinality = parent, Inverse = ChildDHCPAAdmDischarge, Required, SqlFieldName = ADMD_Parref ];

/// ADMD_Childsub
Property ADMDChildsub As %Library.Float [ InitialExpression = {$i(^DHCPAADM($p(%d(0),$c(1)),"D",0))}, SqlColumnNumber = 2, SqlFieldName = ADMD_Childsub ];

/// ADMD_Status
Property ADMDStatus As %Library.String(DISPLAYLIST = ",Discharge,Return,Admit", MAXLEN = 9, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",D,R,A") [ SqlColumnNumber = 3, SqlFieldName = ADMD_Status ];

/// ADMD_User_Dr
Property ADMDUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ADMD_User_Dr ];

/// ADMD_StatusDate
Property ADMDStatusDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = ADMD_StatusDate ];

/// ADMD_StatusTime
Property ADMDStatusTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = ADMD_StatusTime ];

/// ADMD_UpdateDate
Property ADMDUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = ADMD_UpdateDate ];

/// ADMD_UpdateTime
Property ADMDUpdateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = ADMD_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADMD_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADMD_StatusDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADMD_StatusTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADMD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADMD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADMD_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPAAdm</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PA_Adm.DHCADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADMD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_PA_Adm.DHCADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADMD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPAAdmDischargeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

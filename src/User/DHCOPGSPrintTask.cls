Class User.DHCOPGSPrintTask Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PT_RowID, SqlTableName = DHC_OPGSPrintTask, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PTSub [ IdKey, PrimaryKey, Unique ];

/// DHC_OPGroupSettings Parent Reference
Relationship GSPTParRef As User.DHCOPGroupSettings [ Cardinality = parent, Inverse = ChildDHCOPGSPrintTask, Required, SqlFieldName = GS_PT_ParRef ];

/// PT_Sub
Property PTSub As %Library.Float [ InitialExpression = {$i(^DHCOPGS("GS",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"PT",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PT_Sub ];

/// PT_PrtXmlName
Property PTPrtXmlName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PT_PrtXmlName ];

/// PT_ClassName
Property PTClassName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PT_ClassName ];

/// PT_MethodName
Property PTMethodName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PT_MethodName ];

/// PT_TaskType
Property PTTaskType As %Library.String(DISPLAYLIST = ",OP Charge Print,Account Collect Printer,Account Prepay Print", MAXLEN = 23, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",CP,ACP,APP") [ SqlColumnNumber = 6, SqlFieldName = PT_TaskType ];

/// PT_PrintMode
Property PTPrintMode As %Library.String(DISPLAYLIST = ",XML Print,Bar Code Print", MAXLEN = 30, TRUNCATE = 0, VALUELIST = ",XML,BC") [ SqlColumnNumber = 7, SqlFieldName = PT_PrintMode ];

/// PT_HardEquip_DR
Property PTHardEquipDR As User.DHCCardHardComManager [ SqlColumnNumber = 8, SqlFieldName = PT_HardEquip_DR ];

/// PT_Note3
Property PTNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PT_Note3 ];

/// PT_Note4
Property PTNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PT_Note4 ];

/// PT_Note5
Property PTNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PT_Note5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterData">
<Data name="PT_ClassName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PT_HardEquip_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PT_MethodName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PT_Note3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PT_Note4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PT_Note5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PT_PrintMode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PT_PrtXmlName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PT_TaskType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCOPGS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_OPGroupSettings.GS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PT_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GS"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_OPGroupSettings.GS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"PT"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PT_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCOPGSPrintTaskS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}

Class User.DHCDocPilotProFreeOrdLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPFL_RowId, SqlTableName = DHCDocPilotProFreeOrdLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PPFLChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PPFLPPParRef As User.DHCDocPilotProFreeOrd [ Cardinality = parent, Inverse = ChildDHCDocPilotProFreeOrdLog, Required, SqlFieldName = PPFL_PPParRef ];

Property PPFLChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocPPFL($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),0))}, SqlColumnNumber = 2, SqlFieldName = PPFL_ChildSub ];

Property PPFLSttDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PPFL_SttDate ];

Property PPFLSttTime As %Time [ SqlColumnNumber = 4, SqlFieldName = PPFL_SttTime ];

Property PPFLEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PPFL_EndDate ];

Property PPFLEndTime As %Time [ SqlColumnNumber = 6, SqlFieldName = PPFL_EndTime ];

Property PPFLItmMastDR As ARCItmMast [ Required, SqlColumnNumber = 7, SqlFieldName = PPFL_ItmMastDR ];

Property PPFLFreeNum As %Library.String [ SqlColumnNumber = 8, SqlFieldName = PPFL_FreeNum ];

Property PPFLUserDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PPFL_User_Dr ];

Property PPFLUpDate As %Date [ SqlColumnNumber = 10, SqlFieldName = PPFL_UpDate ];

Property PPFLUpTime As %Time [ SqlColumnNumber = 11, SqlFieldName = PPFL_UpTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterIndex">
<Data name="PPFL_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPFL_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPFL_FreeNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPFL_ItmMastDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPFL_SttDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPFL_SttTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPFL_UpDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPFL_UpTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPFL_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCDocPPFL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DHC_DocPilotProFreeOrd.PPF_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L3}</Expression>
<Field>PPFL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProFreeOrd.PPF_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PPFL_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PPFL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocPilotProFreeOrdLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

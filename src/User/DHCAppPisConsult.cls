Class User.DHCAppPisConsult Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AP_RowID, SqlTableName = DHC_AppPisConsult, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On APChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppPisMaster Parent Reference AP_ParRef_Dr
Relationship APParRefDr As User.DHCAppPisMaster [ Cardinality = parent, Inverse = ChildDHCAPPPISCONSULT, Required, SqlFieldName = AP_ParRef_Dr ];

/// AP_ChildSub
Property APChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AP_ChildSub ];

/// 送检医生  AP_InsDoc
Property APInsDoc As %String [ SqlColumnNumber = 3, SqlFieldName = AP_InsDoc ];

/// 送检医院  AP_InsHosp
Property APInsHosp As %String [ SqlColumnNumber = 4, SqlFieldName = AP_InsHosp ];

/// 大体标本检查所见  AP_SpecExaRes
Property APSpecExaRes As %String [ SqlColumnNumber = 5, SqlFieldName = AP_SpecExaRes ];

/// 会诊要求  AP_ConsNote
Property APConsNote As %String [ SqlColumnNumber = 6, SqlFieldName = AP_ConsNote ];

/// 会诊专家  AP_ConsStaff
Property APConsStaff As %String [ SqlColumnNumber = 7, SqlFieldName = AP_ConsStaff ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AP_ConsNote">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AP_ConsStaff">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AP_InsDoc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_InsHosp">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_SpecExaRes">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPPPM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppPisMaster.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppPisMaster.AP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"C"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPisConsultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCRegConFree Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RCF_Rowid, SqlTableName = DHC_RegConFree, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCRegConFreeRelFee As User.DHCRegConFreeRelFee [ Cardinality = children, Inverse = RCFRParRef ];

/// RCF_AdmReason_Dr
Property RCFAdmReasonDr As User.PACAdmReason [ SqlColumnNumber = 2, SqlFieldName = RCF_AdmReason_Dr ];

/// RCF_StartDate
Property RCFStartDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = RCF_StartDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRCF)</SqlIdExpression>
<SQLMap name="MasterIndex">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="RCF_AdmReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RCF_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RCF_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RCF_FreeAllFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RCF_FreeAppFee">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RCF_FreeCheckFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RCF_FreeOtherFee">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RCF_FreeRegFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RCF_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RCF_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRCF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RCF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RCF_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRegConFreeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// RCF_StartTime
Property RCFStartTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = RCF_StartTime ];

/// RCF_EndDate
Property RCFEndDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = RCF_EndDate ];

/// RCF_EndTime
Property RCFEndTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = RCF_EndTime ];

/// RCF_FreeRegFee
/// Property RCFFreeRegFee As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = RCF_FreeRegFee ];
Property RCFFreeRegFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = RCF_FreeRegFee ];

/// RCF_FreeCheckFee
/// Property RCFFreeCheckFee As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = RCF_FreeCheckFee ];
Property RCFFreeCheckFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = RCF_FreeCheckFee ];

/// RCF_FreeAllFee
Property RCFFreeAllFee As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = RCF_FreeAllFee ];

/// RCF_FreeAppFee
/// Property RCFFreeAppFee As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = RCF_FreeAppFee ];
Property RCFFreeAppFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = RCF_FreeAppFee ];

/// RCF_FreeOtherFee
/// Property RCFFreeOtherFee As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = RCF_FreeOtherFee ];
Property RCFFreeOtherFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = RCF_FreeOtherFee ];

}

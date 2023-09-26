Class User.DHCPhLabel Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PhLab_Rowid, SqlTableName = DHC_PhLabel, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Phlab_bed
Property Phlabbed As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = Phlab_bed ];

/// Phlab_creatflag
Property Phlabcreatflag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = Phlab_creatflag ];

/// Phlab_ctloc_dr
Property Phlabctlocdr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Phlab_ctloc_dr ];

/// Phlab_date
Property Phlabdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = Phlab_date ];

/// Phlab_daynum
Property Phlabdaynum As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = Phlab_daynum ];

/// Phlab_exedate
Property Phlabexedate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = Phlab_exedate ];

/// Phlab_name
Property Phlabname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = Phlab_name ];

/// Phlab_ordqty
Property Phlabordqty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = Phlab_ordqty ];

/// Phlab_paadm_dr
Property Phlabpaadmdr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = Phlab_paadm_dr ];

/// Phlab_pc
Property Phlabpc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = Phlab_pc ];

/// Phlab_printflag
Property Phlabprintflag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = Phlab_printflag ];

/// Phlab_room
Property Phlabroom As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = Phlab_room ];

/// Phlab_serial
Property Phlabserial As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = Phlab_serial ];

/// Phlab_ssusr_dr
Property Phlabssusrdr As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = Phlab_ssusr_dr ];

/// Phlab_time
Property Phlabtime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = Phlab_time ];

/// Phlab_usetype
Property Phlabusetype As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = Phlab_usetype ];

/// Phlab_ward
Property Phlabwarddr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = Phlab_ward_dr ];

Property Phlabzyh As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Phlab_zyh ];

/// phlab_fydate
Property phlabfydate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = phlab_fydate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PHLAB)</SqlIdExpression>
<SQLMap name="phlabindexdate">
<Global>^PHLABi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PhLab_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{phlab_fydate}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{Phlab_paadm_dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PhLab_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="phlabmaster">
<Data name="Phlab_bed">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Phlab_creatflag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Phlab_ctloc_dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Phlab_date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Phlab_daynum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Phlab_exedate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Phlab_name">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Phlab_ordqty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Phlab_paadm_dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Phlab_pc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Phlab_printflag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="Phlab_room">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="Phlab_serial">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="Phlab_ssusr_dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="Phlab_time">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="Phlab_usetype">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="Phlab_ward_dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="Phlab_zyh">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="phlab_fydate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Global>^PHLAB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PhLab_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PhLab_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhLabelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

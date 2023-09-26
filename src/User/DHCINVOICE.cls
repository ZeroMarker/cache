/// DHC_INVOICE
Class User.DHCINVOICE Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHC_INVOICE, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INVrowid [ IdKey, PrimaryKey, Unique ];

/// INV_StartInv
Property INVStartInv As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INV_StartInv ];

/// INV_EndInv
Property INVEndInv As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INV_EndInv ];

/// INV_Usr
Property INVUsr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = INV_Usr ];

/// INV_Date
Property INVDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = INV_Date ];

/// INV_Time
Property INVTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6, SqlFieldName = INV_Time ];

/// INV_LastNum
Property INVLastNum As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INV_LastNum ];

/// INC_Finalflag
Property INVFinalflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = INV_Finalflag ];

/// INV_type
/// (DISPLAYLIST = ",InPatient,OutPatient,Emergency,Registration,Login", MAXLEN = 10, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,O,E,R,L")
Property INVtype As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INV_type ];

/// INV_Status
Property INVStatus As %Library.String(DISPLAYLIST = ",Normal,Trans", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,T") [ SqlColumnNumber = 10, SqlFieldName = INV_Status ];

/// INV_Linkto
Property INVLinkto As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INV_Linkto ];

/// INV_jynum
Property INVjynum As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INV_jynum ];

/// INV_serialno
Property INVserialno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INV_serialno ];

/// INV_UsrJynum
Property INVUsrJynum As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INV_UsrJynum ];

/// INV_UsrSerialno
Property INVUsrSerialno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INV_UsrSerialno ];

/// INV_original_dr
Property INVoriginaldr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INV_original_dr ];

/// INV_title
Property INVtitle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INV_title ];

/// INV_comment1
Property INVcomment1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INV_comment1 ];

/// INV_comment2
Property INVcomment2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INV_comment2 ];

/// INV_ConfirmFlag
Property INVconfirmflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = INV_confirmflag ];

/// INV_ConfirmDate
Property INVconfirmdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = INV_confirmdate ];

/// INV_confirmtime
Property INVconfirmtime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = INV_confirmtime ];

/// INV_returnflag
Property INVreturnflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = INV_returnflag ];

/// INV_returndate
Property INVreturndate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = INV_returndate ];

/// INV_returntime
Property INVreturntime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = INV_returntime ];

/// INV_hospital
Property INVhospital As User.CTHospital [ SqlColumnNumber = 26, SqlFieldName = INV_hospital ];

/// DHC_INVOICE Row ID
Property INVrowid As %Library.Numeric(SCALE = 0, SELECTIVITY = 1) [ InitialExpression = {$i(^mdata("DHCINVOICE"))}, Required, SqlFieldName = INV_rowid ];

Storage SQLStorage
{
<ExtentSize>3250000</ExtentSize>
<SQLMap name="BeginINVABCIdx">
<Global>^DHCINVOICEi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BINVABC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INV_type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INV_title}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>$l({INV_StartInv})</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INV_StartInv}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{INV_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="BeginINVIdx">
<Global>^DHCINVOICEi</Global>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BINV"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INV_type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$length({INV_StartInv})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INV_StartInv}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INV_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexcomment1">
<Global>^DHCINVOICE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INV_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"comment1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INV_comment1}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INV_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexcomment2">
<Global>^DHCINVOICE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INV_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"comment2"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INV_comment2}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INV_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indextitle">
<Global>^DHCINVOICE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INV_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"title"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INV_title}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INV_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MAST">
<Data name="INV_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INV_EndInv">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INV_Finalflag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INV_LastNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INV_Linkto">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INV_StartInv">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INV_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INV_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INV_Usr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INV_UsrJynum">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INV_UsrSerialno">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INV_comment1">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INV_comment2">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INV_confirmdate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INV_confirmflag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INV_confirmtime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INV_hospital">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INV_jynum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INV_original_dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INV_returndate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INV_returnflag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INV_returntime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INV_serialno">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INV_title">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INV_type">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCINVOICE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INV_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INV_rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexdate">
<Global>^DHCINVOICE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INV_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DAT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INV_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INV_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexflag">
<Global>^DHCINVOICE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INV_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FLAG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INV_Finalflag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INV_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexlinkto">
<Global>^DHCINVOICE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INV_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LINK"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INV_Linkto}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INV_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexstartinv">
<Global>^DHCINVOICE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INV_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STNO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INV_StartInv}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INV_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexstatus">
<Global>^DHCINVOICE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INV_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STAT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INV_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INV_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indextype">
<Global>^DHCINVOICE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INV_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INV_type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INV_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexuser">
<Global>^DHCINVOICE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INV_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INV_Usr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INV_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINVOICES</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 3250000;

}

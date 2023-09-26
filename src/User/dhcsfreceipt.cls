Class User.dhcsfreceipt Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = rcpt_rowid, SqlTableName = dhc_sfreceipt, StorageStrategy = SQLStorage ]
{

/// rcpt_currentno
Property rcptcurrentno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = rcpt_currentno ];

/// rcpt_endno
Property rcptendno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = rcpt_endno ];

/// rcpt_loc
Property rcptloc As %Library.String(DISPLAYLIST = ",InPatient,OutPatient,Emergency,Registration,Login,Medicare", MAXLEN = 10, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,O,E,R,L,M") [ SqlColumnNumber = 16, SqlFieldName = rcpt_loc ];

/// rcpt_lqdate
Property rcptlqdate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 2, SqlFieldName = rcpt_lqdate ];

/// rcpt_lqtime
Property rcptlqtime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 3, SqlFieldName = rcpt_lqtime ];

/// rcpt_lquser
Property rcptlquser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = rcpt_lquser ];

/// rcpt_original_dr
Property rcptoriginaldr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = rcpt_original_dr ];

/// rcptrem
Property rcptremain As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = rcpt_remain ];

/// rcpt_serialno
Property rcptserialno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = rcpt_serialno ];

/// rcpt_startno
Property rcptstartno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = rcpt_startno ];

/// rcpt_title
Property rcpttitle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = rcpt_title ];

/// rcpt_useflag
Property rcptuseflag As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = rcpt_useflag ];

/// rcpt_user
Property rcptuser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = rcpt_user ];

/// rcpt_usrremain
Property rcptusrremain As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = rcpt_usrremain ];

/// rcpt_usrserialno
Property rcptusrserialno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = rcpt_usrserialno ];

/// rcpt_confirmflag
Property rcptconfirmflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = rcpt_confirmflag ];

/// rcpt_confirmdate
Property rcptconfirmdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = rcpt_confirmdate ];

/// rcpt_confirmtime
Property rcptconfirmtime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = rcpt_confirmtime ];

/// rcpt_returnflag
Property rcptreturnflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = rcpt_returnflag ];

/// rcpt_returndate
Property rcptreturndate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = rcpt_returndate ];

/// rcpt_returntime
Property rcptreturntime As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = rcpt_returntime ];

/// rcpt_hospital
Property rcpthospital As User.CTHospital [ SqlColumnNumber = 23, SqlFieldName = rcpt_hospital ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSFRECEIPT)</SqlIdExpression>
<SQLMap name="Indexdate">
<Global>^DHCSFRECEIPT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>rcpt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{rcpt_lqdate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{rcpt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexlquser">
<Global>^DHCSFRECEIPT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>rcpt_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"lquser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{rcpt_lquser}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{rcpt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="dataMaster">
<Data name="rcpt_confirmdate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="rcpt_confirmflag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="rcpt_confirmtime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="rcpt_currentno">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="rcpt_endno">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="rcpt_hospital">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="rcpt_loc">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="rcpt_lqdate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="rcpt_lqtime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="rcpt_lquser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="rcpt_original_dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="rcpt_remain">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="rcpt_returndate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="rcpt_returnflag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="rcpt_returntime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="rcpt_serialno">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="rcpt_startno">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="rcpt_title">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="rcpt_useflag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="rcpt_user">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="rcpt_usrremain">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="rcpt_usrserialno">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCSFRECEIPT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>rcpt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{rcpt_rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.dhcsfreceiptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}

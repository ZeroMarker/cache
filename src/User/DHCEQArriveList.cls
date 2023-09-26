Class User.DHCEQArriveList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AL_RowID, SqlTableName = DHC_EQArriveList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AL_ArriveDR
Property ALArriveDR As User.DHCEQArrive [ SqlColumnNumber = 2, SqlFieldName = AL_ArriveDR ];

/// AL_SourceType
Property ALSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AL_SourceType ];

/// AL_SourceID
Property ALSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AL_SourceID ];

/// AL_ArriveQty
Property ALArriveQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = AL_ArriveQty ];

/// AL_PackageNum
Property ALPackageNum As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = AL_PackageNum ];

/// AL_LocationDR
Property ALLocationDR As User.DHCEQCLocation [ SqlColumnNumber = 7, SqlFieldName = AL_LocationDR ];

/// AL_Status
Property ALStatus As %Library.String(DISPLAYLIST = ",取消到货,通知到货", MAXLEN = 1, SELECTIVITY = "33.3333%", VALUELIST = ",0,1") [ SqlColumnNumber = 8, SqlFieldName = AL_Status ];

/// AL_Remark
Property ALRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AL_Remark ];

/// AL_InvalidFlag
Property ALInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AL_InvalidFlag ];

/// AL_CancelArriveUserDR
Property ALCancelArriveUserDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = AL_CancelArriveUserDR ];

/// AL_CancelArriveDate
Property ALCancelArriveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = AL_CancelArriveDate ];

/// AL_CancelArriveTime
Property ALCancelArriveTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = AL_CancelArriveTime ];

/// AL_CheckGroupDR
Property ALCheckGroupDR As User.DHCEQMCMaintGroup [ SqlColumnNumber = 14, SqlFieldName = AL_CheckGroupDR ];

/// AL_CheckUserDR
Property ALCheckUserDR As User.DHCEQMCMaintGroupList [ SqlColumnNumber = 15, SqlFieldName = AL_CheckUserDR ];

/// AL_OpenCheckListDR
Property ALOpenCheckListDR As User.DHCEQOpenCheckList [ SqlColumnNumber = 16, SqlFieldName = AL_OpenCheckListDR ];

/// AL_Hold1
Property ALHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AL_Hold1 ];

/// AL_Hold2
Property ALHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AL_Hold2 ];

/// AL_Hold3
Property ALHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AL_Hold3 ];

/// AL_Hold4
Property ALHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AL_Hold4 ];

/// AL_Hold5
Property ALHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQArriveList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AL_ArriveDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AL_ArriveQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AL_CancelArriveDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AL_CancelArriveTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AL_CancelArriveUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AL_CheckGroupDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AL_CheckUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AL_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AL_LocationDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AL_OpenCheckListDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AL_PackageNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AL_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AL_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AL_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQArriveList</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{AL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArriveDR">
<Global>^DHCEQArriveList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ArriveDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AL_ArriveDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceType">
<Global>^DHCEQArriveList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AL_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AL_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQArriveListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

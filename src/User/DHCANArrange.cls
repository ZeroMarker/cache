Class User.DHCANArrange Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AN_Arr_RowId, SqlTableName = DHC_AN_Arrange, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AN_ArrDate
Property ANArrDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = AN_Arr_Date ];

/// AN_ArrTime
Property ANArrTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = AN_Arr_Time ];

/// AN_Arr_Ctcp_Dr
Property ANArrCtcpDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = AN_Arr_Ctcp_DR ];

/// AN_Arr_Room_DR
Property ANArrRoomDR As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = AN_Arr_Room_DR ];

/// AN_Arr_Op_DR
Property ANArrOpDR As User.DHCANOPArrange [ SqlColumnNumber = 7, SqlFieldName = AN_Arr_Op_DR ];

/// AN_Arr_NurDoc
Property ANArrNurDoc As %Library.String(DISPLAYLIST = ",Doctor,Nurse", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",D,N") [ SqlColumnNumber = 8, SqlFieldName = AN_Arr_NurDoc ];

/// AN_Arr_UpdateDate
Property ANArrUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = AN_Arr_UpdateDate ];

/// AN_Arr_UpdateTime
Property ANArrUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = AN_Arr_UpdateTime ];

/// AN_Arr_UpdateUser
Property ANArrUpdateUserId As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = AN_Arr_UpdateUserId ];

/// AN_Arr_DocCat
Property ANArrDocCat As %Library.String(DISPLAYLIST = ",AnDoctor,OtherAnDoctor,ExAnDoctor,AnDoctorNote,Ansupervisor", MAXLEN = 13, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",A,O,J,N,S") [ SqlColumnNumber = 12, SqlFieldName = AN_Arr_DocCat ];

/// AN_Arr_NurCat
Property ANArrNurCat As %Library.String(DISPLAYLIST = ",AnNurse,DeviceNurse,ExDeviceNurse,ScrubNurse,ExScrubNurse", MAXLEN = 13, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",A,D,J,T,X") [ SqlColumnNumber = 13, SqlFieldName = AN_Arr_NurCat ];

/// AN_Arr_Num
Property ANArrCtcpNum As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = AN_Arr_CtcpNum ];

/// AN_Arr_Note
Property ANArrNote As %Library.String(COLLATION = "Exact", MAXLEN = 800, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AN_Arr_Note ];

/// AN_Arr_EditFlag
Property ANArrEditFlag As %Library.String(DISPLAYLIST = ",Normal,Edit,Changed,Delete,Removed", MAXLEN = 7, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",N,E,C,D,R") [ SqlColumnNumber = 16, SqlFieldName = AN_Arr_EditFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANArr)</SqlIdExpression>
<SQLMap name="ANArrDataMasterMap">
<Data name="AN_Arr_CtcpNum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AN_Arr_Ctcp_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AN_Arr_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AN_Arr_DocCat">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AN_Arr_EditFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AN_Arr_Note">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AN_Arr_NurCat">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AN_Arr_NurDoc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AN_Arr_Op_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AN_Arr_Room_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AN_Arr_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AN_Arr_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AN_Arr_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AN_Arr_UpdateUserId">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCANArr</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AN_Arr_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AN_Arr_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCANArr</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AN_Arr_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AnArrDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AN_Arr_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AN_Arr_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateCtcp">
<Global>^DHCANArr</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AN_Arr_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateCtcp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AN_Arr_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AN_Arr_Ctcp_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AN_Arr_Room_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AN_Arr_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateRoom">
<Global>^DHCANArr</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AN_Arr_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateRoom"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AN_Arr_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AN_Arr_Room_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AN_Arr_Ctcp_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AN_Arr_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANArrangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

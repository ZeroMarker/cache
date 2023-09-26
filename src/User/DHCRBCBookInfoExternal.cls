Class User.DHCRBCBookInfoExternal Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BIE_RowId, SqlTableName = DHCRBC_BookInfoExternal, StorageStrategy = SQLStorage ]
{

Property patientID As %String;

Property patientName As %String;

Property bookDate As %Date;

Property startTime As %Time;

Property endTime As %Time;

Property resSchduleID As %String;

Property resourceID As %String;

Property resourceDesc As %String;

Property bookNum As %String;

Property locID As %String;

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCRBCBookInfoExternal)</SqlIdExpression>
<SQLMap name="indexLoc">
<Global>^DHCRBCBookInfoExternali</Global>
<Subscript name="1">
<Expression>"loc-res"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{locID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{bookDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{resourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BIE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexPatient">
<Global>^DHCRBCBookInfoExternali</Global>
<Subscript name="1">
<Expression>"IndexPat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{locID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{bookDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{patientID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BIE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexResSchdule">
<Global>^DHCRBCBookInfoExternali</Global>
<Subscript name="1">
<Expression>"ResSchedule"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{resSchduleID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{patientID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BIE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="masterMap">
<Data name="bookDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="bookNum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="endTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="locID">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="patientID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="patientName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="resSchduleID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="resourceDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="resourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="startTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCRBCBookInfoExternal</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BIE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BIE_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCBookInfoExternalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

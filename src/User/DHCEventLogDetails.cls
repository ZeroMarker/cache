Class User.DHCEventLogDetails Extends %Persistent [ SqlRowIdName = Det_RowId, SqlTableName = DHC_EventLogDetails, StorageStrategy = NewStorage1 ]
{

Property DetChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCEVENTLOG($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"D",0))}, Required, SqlColumnNumber = 2, SqlFieldName = Det_ChildSub ];

Index RowIDBasedIDKeyIndex On DetChildSub [ IdKey, PrimaryKey, Unique ];

Relationship DetLogParRef As User.DHCEventLog [ Cardinality = parent, Inverse = ChildDHCEventLogDet, Required, SqlFieldName = Det_Log_ParRef ];

Property DetUserDr As SSUser [ SqlFieldName = Det_User_Dr ];

Property DetLoginDr As SSUserLogin [ SqlFieldName = Det_Login_Dr ];

Property DetLocDr As CTLoc [ SqlFieldName = Det_Loc_Dr ];

Property DetGroupDr As SSGroup [ SqlFieldName = Det_Group_Dr ];

Property DetSecretLevelDr As DHCSecretLevel [ SqlFieldName = Det_SecretLevel_Dr ];

Property DetDate As %Date [ SqlFieldName = Det_Date ];

Property DetTime As %Time [ SqlFieldName = Det_Time ];

Property DetConditions As %String(MAXLEN = 1000) [ SqlFieldName = Det_Conditions ];

Property DetContent As %String(MAXLEN = 2000) [ SqlFieldName = Det_Content ];

Property DetComputerIP As %String [ SqlFieldName = Det_ComputerIP ];

Property DetComputerMac As %String [ SqlFieldName = Det_ComputerMac ];

Property DetComputerName As %String [ SqlFieldName = Det_ComputerName ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMap">
<Data name="Det_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Det_ComputerIP">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Det_ComputerMac">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="Det_ComputerName">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="Det_Conditions">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Det_Content">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Det_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Det_Group_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Det_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Det_Log_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Det_Login_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Det_SecretLevel_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Det_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Det_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEVENTLOG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EventLog.Log_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>Det_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EventLog.Log_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Det_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexModulCondition">
<Global>^DHCEVENTLOGI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_EventLog.Log_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>Det_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DetCondition"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Det_Conditions}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_EventLog.Log_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Det_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEventLogDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

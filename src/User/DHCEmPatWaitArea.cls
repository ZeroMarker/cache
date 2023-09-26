Class User.DHCEmPatWaitArea Extends %Persistent [ SqlRowIdName = EC_RowID, SqlTableName = DHC_EmPatWaitArea, StorageStrategy = SQLStorage ]
{

/// 病人Adm   EM_Adm_Dr
Property EMAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = EM_Adm_Dr ];

/// 科室ID	  EM_Loc_Dr
Property EMLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = EM_Loc_Dr ];

/// 日期  EM_Date
Property EMDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = EM_Date ];

/// 时间  EM_Time 
Property EMTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = EM_Time ];

/// 叫号状态  EM_Called
Property EMCalled As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = EM_Called ];

/// 状态  EM_State
Property EMState As %Library.String(DISPLAYLIST = ",Wait,Arrange", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",W,A") [ SqlColumnNumber = 7, SqlFieldName = EM_State ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMPWA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EM_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EM_Called">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EM_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EM_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EM_State">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EM_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMPWA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEMPWA</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EM_State}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatWaitAreaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

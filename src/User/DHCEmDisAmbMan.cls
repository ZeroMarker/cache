Class User.DHCEmDisAmbMan Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ED_RowID, SqlTableName = DHC_EmDisAmbMan, StorageStrategy = SQLStorage ]
{

/// 病人Adm   ED_Adm_Dr
Property EWAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = ED_Adm_Dr ];

/// 登记科室  ED_RLoc_Dr
Property EWRLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = ED_RLoc_Dr ];

/// 登记日期  ED_RDate
Property EWRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = ED_RDate ];

/// 登记时间  ED_RTime
Property EWRTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = ED_RTime ];

/// 登记人  ED_RUser_Dr
Property EWRUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = ED_RUser_Dr ];

/// 是否院外  ED_OutFlag
Property EDOutFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ED_OutFlag ];

/// 备注  ED_Note
Property EDNote As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ED_Note ];

/// 出诊记录  ED_PHV_Dr
Property EDPHVDr As %Library.String [ SqlColumnNumber = 9, SqlFieldName = ED_PHV_Dr ];

/// d ##class(User.DHCEmDisAmbMan).%BuildIndices()
Storage SQLStorage
{
<Description>
<![CDATA[d ##class(User.DHCEmDisAmbMan).%BuildIndices()]]></Description>
<SqlIdExpression>$i(^DHCEMDAM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ED_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ED_Note">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ED_OutFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ED_PHV_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ED_RDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ED_RLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ED_RTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ED_RUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEMDAM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ED_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ED_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCEMDAM</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ED_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ED_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ED_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCEMDAM</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ED_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ED_RDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ED_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHosVis">
<Global>^DHCEMDAM</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ED_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSVIS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ED_PHV_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ED_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmDisAmbManS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCEmOnlyDocAdvice Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ODA_RowID, SqlTableName = DHC_EmOnlyDocAdvice, StorageStrategy = SQLStorage ]
{

/// 序号 
Property ODANumber As %Library.Integer [ SqlColumnNumber = 2, SqlFieldName = ODA_Number ];

/// 医嘱大类
Property ODAOecDr As User.OECOrderCategory [ SqlColumnNumber = 3, SqlFieldName = ODA_Oec_Dr ];

/// 是否启用
Property ODAActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ODA_ActiveFlag ];

/// 医院
Property ODAHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = ODA_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMODA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ODA_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ODA_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ODA_Number">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ODA_Oec_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMODA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ODA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ODA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmOnlyDocAdviceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

/// 药剂科处方登记表
/// 20170821wush+
Class User.DHCPrescReg Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = ID, SqlTableName = DHC_PrescReg ]
{

/// Qty
Property Qty As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = Qty ];

/// LeadDate
Property LeadDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = LeadDate ];

/// ApplyLOCDR
Property AppLocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = AppLoc_DR ];

/// PapmiDR
Property PapmiDR As User.PAPatMas [ SqlColumnNumber = 5, SqlFieldName = Papmi_DR ];

/// AppDocDR
Property AppDocDR As User.CTCareProv [ SqlColumnNumber = 6, SqlFieldName = AppDoc_DR ];

/// AppType
Property AppType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AppType ];

/// CardID
Property CardID As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CardID ];

/// INCI_DR
Property INCIDR As User.INCItm [ SqlColumnNumber = 9, SqlFieldName = INCI_DR ];

/// CTUOM_DR
Property CTUOMDR As User.CTUOM [ SqlColumnNumber = 10, SqlFieldName = CTUOM_DR ];

/// UserID
Property UserID As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = UserID ];

/// UpdDate
Property UpdDate As %Library.Date [ SqlColumnNumber = 12, SqlFieldName = UpdDate ];

/// UpdTime
Property UpdTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = UpdTime ];

/// PatNo
Property PatNo As %Library.String [ SqlColumnNumber = 14, SqlFieldName = PatNo ];

/// PatName
Property PatName As %Library.String [ SqlColumnNumber = 15, SqlFieldName = PatName ];

/// Sex
Property Sex As %Library.String [ SqlColumnNumber = 16, SqlFieldName = Sex ];

/// Age
Property Age As %Library.String [ SqlColumnNumber = 17, SqlFieldName = Age ];

/// 供应商APC_Vendor 
Property VenId As User.APCVendor [ SqlColumnNumber = 18, SqlFieldName = VenId ];

/// 价格(存的进价)
Property RealPrice As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = RealPrice ];

/// BedNo 床号
Property BedNo As %Library.String [ SqlColumnNumber = 20, SqlFieldName = BedNo ];

/// AdmType 门诊/住院
Property AdmType As %Library.String [ SqlColumnNumber = 21, SqlFieldName = AdmType ];

Index PapmiDR On PapmiDR;

Index LeadDate On LeadDate;

Index CardID On CardID;

/// Origin 新增Origin字段用于判断处方购药和核医学制采购单 hsq 20181218
Property OriginType As %Library.String(VALUELIST = ",处方购药,核医学", XSDTYPE = "string") [ SqlColumnNumber = 22, SqlFieldName = OriginType ];

Storage Default
{
<Data name="DHCPrescRegDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModQty</Value>
</Value>
<Value name="3">
<Value>LeadDate</Value>
</Value>
<Value name="4">
<Value>AppLocDR</Value>
</Value>
<Value name="5">
<Value>PapmiDR</Value>
</Value>
<Value name="6">
<Value>AppDocDR</Value>
</Value>
<Value name="7">
<Value>AppType</Value>
</Value>
<Value name="8">
<Value>CardID</Value>
</Value>
<Value name="9">
<Value>INCIDR</Value>
</Value>
<Value name="10">
<Value>CTUOMDR</Value>
</Value>
<Value name="11">
<Value>Qty</Value>
</Value>
<Value name="12">
<Value>UserID</Value>
</Value>
<Value name="13">
<Value>UpdDate</Value>
</Value>
<Value name="14">
<Value>UpdTime</Value>
</Value>
<Value name="15">
<Value>PatNo</Value>
</Value>
<Value name="16">
<Value>PatName</Value>
</Value>
<Value name="17">
<Value>Sex</Value>
</Value>
<Value name="18">
<Value>Age</Value>
</Value>
<Value name="19">
<Value>VenId</Value>
</Value>
<Value name="20">
<Value>Price</Value>
</Value>
<Value name="21">
<Value>RealPrice</Value>
</Value>
<Value name="22">
<Value>BedNo</Value>
</Value>
<Value name="23">
<Value>AdmType</Value>
</Value>
<Value name="24">
<Value>OriginType</Value>
</Value>
</Data>
<DataLocation>^User.DHCPrescRegD</DataLocation>
<DefaultData>DHCPrescRegDefaultData</DefaultData>
<IdLocation>^User.DHCPrescRegD</IdLocation>
<IndexLocation>^User.DHCPrescRegI</IndexLocation>
<StreamLocation>^User.DHCPrescRegS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="AppDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AppLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AppType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CardID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LeadDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ModQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Papmi_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPrescReg</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ID</SqlRowIdName>
<StreamLocation>^User.DHCPrescRegS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

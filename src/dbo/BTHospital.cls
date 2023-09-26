/// 医院
Class dbo.BTHospital Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Hospital, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexLicenseCode On LicenseCode [ SqlName = Index_LicenseCode, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKBTHospitalHospitalDR created via DDL
ForeignKey FKBTHospitalHospitalDR(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BTHospitalHospitalDR ];

/// Foreign Key FKBTHospitalTCHospitalDR created via DDL
ForeignKey FKBTHospitalTCHospitalDR(TCHospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BTHospitalTCHospitalDR ];

/// Foreign Key FKBTHospitalTCHospitalDR created via DDL
ForeignKey FKBTHospitalBBHospitalDR(BBHospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BTHospitalBBHospitalDR ];

/// DDL Primary Key Specification
Index PKBTHOSPITAL On RowID [ PrimaryKey, SqlName = PK_BT_HOSPITAL, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

/// 描述  
Property FullDesc As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

/// 地址  
Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 6 ];

/// 电话  
Property Telephone As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 医院编号  
Property HospitalNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 排名  
Property Rank As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 9 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 10 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 是否激活  {1:True,0:False}
Property Active As %Library.Boolean [ SqlColumnNumber = 12 ];

/// 归属医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 检测项目归属医院  
Property TCHospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// BBHospitalDR  
Property BBHospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 授权代码  
Property LicenseCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="BTHospitalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>FullDesc</Value>
</Value>
<Value name="5">
<Value>Address</Value>
</Value>
<Value name="6">
<Value>Telephone</Value>
</Value>
<Value name="7">
<Value>HospitalNo</Value>
</Value>
<Value name="8">
<Value>Rank</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
<Value name="11">
<Value>Active</Value>
</Value>
<Value name="12">
<Value>HospitalDR</Value>
</Value>
<Value name="13">
<Value>TCHospitalDR</Value>
</Value>
<Value name="14">
<Value>BBHospitalDR</Value>
</Value>
<Value name="15">
<Value>LicenseCode</Value>
</Value>
</Data>
<DataLocation>^dbo.BTHospitalD</DataLocation>
<DefaultData>BTHospitalDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTHospitalD</IdLocation>
<IndexLocation>^dbo.BTHospitalI</IndexLocation>
<StreamLocation>^dbo.BTHospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

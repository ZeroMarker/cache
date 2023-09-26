/// 混捡信息
Class dbo.RPMixedInspection Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MixedInspection ]
{

/// Foreign Key FKRPMixedInspectionHospitalDR created via DDL
ForeignKey FKRPMixedInspectionHospitalDR(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_RPMixedInspectionHospitalDR ];

/// Foreign Key FKRPMixedInspectionAddUserDR created via DDL
ForeignKey FKRPMixedInspectionAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPMixedInspectionAddUserDR ];

Index IndexVisitNumber On VisitNumber [ SqlName = Index_VisitNumber, Type = index, Unique ];

Index IndexMixNo On MixNo [ SqlName = Index_MixNo, Type = index ];

Index IndexAddDate On (AddDate, MixNo) [ SqlName = Index_AddDate, Type = index ];

/// DDL Primary Key Specification
Index PKRPMIXEDINSPECTION On RowID [ PrimaryKey, SqlName = PK_RP_MIXEDINSPECTION, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 混检号  
Property MixNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 标本  
Property VisitNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 登记日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 登记时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 登记人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 封箱号
Property PackageNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

/// 封箱日期  
Property PackageDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 封箱时间  
Property PackageTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 封箱人  
Property PackageUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="RPMixedInspectionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MixNo</Value>
</Value>
<Value name="3">
<Value>VisitNumber</Value>
</Value>
<Value name="4">
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
<Value name="8">
<Value>PackageNo</Value>
</Value>
<Value name="9">
<Value>PackageDate</Value>
</Value>
<Value name="10">
<Value>PackageTime</Value>
</Value>
<Value name="11">
<Value>PackageUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMixedInspectionD</DataLocation>
<DefaultData>RPMixedInspectionDefaultData</DefaultData>
<IdLocation>^dbo.RPMixedInspectionD</IdLocation>
<IndexLocation>^dbo.RPMixedInspectionI</IndexLocation>
<StreamLocation>^dbo.RPMixedInspectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

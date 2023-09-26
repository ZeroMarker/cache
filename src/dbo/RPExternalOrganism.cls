/// 外来菌登记
Class dbo.RPExternalOrganism Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_ExternalOrganism ]
{

/// Foreign Key FKRPExternalOrganismAddUserDR created via DDL
ForeignKey FKRPExternalOrganismAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPExternalOrganismAddUserDR ];

/// Foreign Key FKRPExternalOrganismAddHospitalDR created via DDL
ForeignKey FKRPExternalOrganismAddHospitalDR(AddHospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_RPExternalOrganismAddHospitalDR ];

/// Foreign Key FKWorkGroupDR created via DDL
ForeignKey FKWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroupDR ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate ];

Index IndexVisitNumber On VisitNumber [ SqlName = Index_VisitNumber ];

Index IndexWorkGroup On (WorkGroupDR, AddDate) [ SqlName = Index_WorkGroup ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser ];

/// DDL Primary Key Specification
Index PKRPEXTERNALORGANISM On RowID [ PrimaryKey, SqlName = PK_RP_EXTERNALORGANISM, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 检验号  
Property VisitNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 3 ];

/// 医院名称  
Property HosName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 菌株编号  
Property OrganismNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

/// 年龄  
Property Age As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 性别  
Property Sex As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

/// 病案号  
Property MedicalRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 8 ];

/// 科室  
Property LocationName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 9 ];

/// 就诊类型  
Property AdmissionType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 诊断  
Property Symptom As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 11 ];

/// 采集日期  
Property CollectDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 采集时间  
Property CollectTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

///       
Property Specimen As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 14 ];

/// 采集部位  
Property CollectPositon As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 15 ];

/// 细菌主键  
Property OrganismID As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 16 ];

/// 细菌名称  
Property OrganismName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 17 ];

/// 复合主键  
Property ReOrganismID As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 18 ];

/// 复合名称  
Property ReOrganismName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 19 ];

/// 添加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 添加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 添加人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 添加医院  
Property AddHospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 检测方法     
Property TestMethod As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 24 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

Storage Default
{
<Data name="RPExternalOrganismDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumber</Value>
</Value>
<Value name="3">
<Value>HosName</Value>
</Value>
<Value name="4">
<Value>OrganismNo</Value>
</Value>
<Value name="5">
<Value>Age</Value>
</Value>
<Value name="6">
<Value>Sex</Value>
</Value>
<Value name="7">
<Value>MedicalRecordNo</Value>
</Value>
<Value name="8">
<Value>LocationName</Value>
</Value>
<Value name="9">
<Value>AdmissionType</Value>
</Value>
<Value name="10">
<Value>Symptom</Value>
</Value>
<Value name="11">
<Value>CollectDate</Value>
</Value>
<Value name="12">
<Value>CollectTime</Value>
</Value>
<Value name="13">
<Value>Specimen</Value>
</Value>
<Value name="14">
<Value>CollectPositon</Value>
</Value>
<Value name="15">
<Value>OrganismID</Value>
</Value>
<Value name="16">
<Value>OrganismName</Value>
</Value>
<Value name="17">
<Value>ReOrganismID</Value>
</Value>
<Value name="18">
<Value>ReOrganismName</Value>
</Value>
<Value name="19">
<Value>AddDate</Value>
</Value>
<Value name="20">
<Value>AddTime</Value>
</Value>
<Value name="21">
<Value>AddUserDR</Value>
</Value>
<Value name="22">
<Value>AddHospitalDR</Value>
</Value>
<Value name="23">
<Value>TestMethod</Value>
</Value>
<Value name="24">
<Value>WorkGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPExternalOrganismD</DataLocation>
<DefaultData>RPExternalOrganismDefaultData</DefaultData>
<IdLocation>^dbo.RPExternalOrganismD</IdLocation>
<IndexLocation>^dbo.RPExternalOrganismI</IndexLocation>
<StreamLocation>^dbo.RPExternalOrganismS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

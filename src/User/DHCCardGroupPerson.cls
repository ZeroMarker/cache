/// 办理集团注册后， 人员信息
Class User.DHCCardGroupPerson Extends (%Persistent, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = DHC_CardGroupPerson ]
{

Property CityDesc As %String(TRUNCATE = 1) [ SqlFieldName = CityDesc ];

Property CityDescLookUpRowID As %String(TRUNCATE = 1) [ SqlFieldName = CityDescLookUpRowID ];

Property CountryDesc As %String(TRUNCATE = 1) [ SqlFieldName = CountryDesc ];

Property CountryDescLookUpRowID As %String(TRUNCATE = 1) [ SqlFieldName = CountryDescLookUpRowID ];

Property CredTypeDesc As %String(TRUNCATE = 1) [ SqlFieldName = CredTypeDesc ];

Property EmployeeCompanyLookUpRowID As %String(TRUNCATE = 1) [ SqlFieldName = EmployeeCompanyLookUpRowID ];

Property GroupUnitName As %String(TRUNCATE = 1) [ SqlFieldName = GroupUnitName ];

Property InMedicare As %String(TRUNCATE = 1) [ SqlFieldName = InMedicare ];

Property NationDesc As %String(TRUNCATE = 1) [ SqlFieldName = NationDesc ];

Property NationDescLookUpRowID As %String(TRUNCATE = 1) [ SqlFieldName = NationDescLookUpRowID ];

Property OpMedicare As %String(TRUNCATE = 1) [ SqlFieldName = OpMedicare ];

Property PAPMINo As %String(TRUNCATE = 1) [ SqlFieldName = PAPMINo ];

Property PatTypeDesc As %String(TRUNCATE = 1) [ SqlFieldName = PatTypeDesc ];

Property ProvinceInfo As %String(TRUNCATE = 1) [ SqlFieldName = ProvinceInfo ];

Property ProvinceInfoLookUpRowID As %String(TRUNCATE = 1) [ SqlFieldName = ProvinceInfoLookUpRowID ];

Property Address As %String(TRUNCATE = 1) [ SqlFieldName = Address ];

Property Vocation As %String(TRUNCATE = 1) [ SqlFieldName = Vocation ];

Property Birth As %String(TRUNCATE = 1) [ Required, SqlFieldName = Birth ];

/// PatMas表的RowID
Property CGPPAPMIDR As %String(TRUNCATE = 1) [ SqlFieldName = CGP_PAPMI_DR ];

/// 日志，
Property CGPRegLog As %String(TRUNCATE = 1) [ SqlFieldName = CGP_RegLog ];

/// 办理注册时状态
Property CGPRegStatus As %String(DISPLAYLIST = ",None,Success,Fail,Tie, Appertain", TRUNCATE = 1, VALUELIST = ",N,S,F,T,A") [ Required, SqlFieldName = CGP_RegStatus ];

Property CardNo As %String(TRUNCATE = 1) [ SqlFieldName = CardNo ];

Property CardTypeDefine As %String(TRUNCATE = 1) [ SqlFieldName = CardTypeDefine ];

Property CardTypeDefineDesc As %String(TRUNCATE = 1) [ SqlFieldName = CardTypeDefineDesc ];

/// 指向 集团注册发票
Relationship ParRef As User.DHCCardGroupRegisterINV [ Cardinality = parent, Inverse = CGPersons ];

Property CredNo As %String(TRUNCATE = 1) [ SqlFieldName = CredNo ];

Property CredType As %String(TRUNCATE = 1) [ Required, SqlFieldName = CredType ];

Property Name As %String(TRUNCATE = 1) [ Required, SqlFieldName = Name ];

Property PatType As %String(TRUNCATE = 1) [ SqlFieldName = PatType ];

Property Sex As %String(TRUNCATE = 1) [ Required, SqlFieldName = Sex ];

Storage Default
{
<Data name="DHCCardGroupPersonCLASSNAME">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCardGroupPersonDefaultData">
<Value name="1">
<Value>CGPPAPMIDR</Value>
</Value>
<Value name="2">
<Value>CGPRegStatus</Value>
</Value>
<Value name="3">
<Value>Birth</Value>
</Value>
<Value name="4">
<Value>CGPRegLog</Value>
</Value>
<Value name="5">
<Value>CardNo</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
<Value name="7">
<Value>Sex</Value>
</Value>
<Value name="8">
<Value>CardTypeDefine</Value>
</Value>
<Value name="9">
<Value>CredNo</Value>
</Value>
<Value name="10">
<Value>CredType</Value>
</Value>
<Value name="11">
<Value>PatType</Value>
</Value>
<Value name="12">
<Value>Address</Value>
</Value>
<Value name="13">
<Value>Vocation</Value>
</Value>
<Value name="14">
<Value>CardTypeDefineDesc</Value>
</Value>
<Value name="15">
<Value>CityDesc</Value>
</Value>
<Value name="16">
<Value>CityDescLookUpRowID</Value>
</Value>
<Value name="17">
<Value>CountryDesc</Value>
</Value>
<Value name="18">
<Value>CountryDescLookUpRowID</Value>
</Value>
<Value name="19">
<Value>CredTypeDesc</Value>
</Value>
<Value name="20">
<Value>EmployeeCompanyLookUpRowID</Value>
</Value>
<Value name="21">
<Value>GroupUnitName</Value>
</Value>
<Value name="22">
<Value>InMedicare</Value>
</Value>
<Value name="23">
<Value>NationDesc</Value>
</Value>
<Value name="24">
<Value>NationDescLookUpRowID</Value>
</Value>
<Value name="25">
<Value>OpMedicare</Value>
</Value>
<Value name="26">
<Value>PAPMINo</Value>
</Value>
<Value name="27">
<Value>PatTypeDesc</Value>
</Value>
<Value name="28">
<Value>ProvinceInfo</Value>
</Value>
<Value name="29">
<Value>ProvinceInfoLookUpRowID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DHCCardGroupPerson")</DataLocation>
<DefaultData>DHCCardGroupPersonDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("DHCCardGroupPerson")</IdLocation>
<IndexLocation>^DHCCardGroupPersonI</IndexLocation>
<StreamLocation>^DHCCardGroupPersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

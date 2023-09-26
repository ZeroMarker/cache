Class User.DHCDocCurePartGrpLinkSet Extends %Persistent [ SqlTableName = DHC_DocCure_PartGrpLinkSet ]
{

Parameter EXTENTSIZE = 250;

Relationship CPGLSParRefDr As User.DHCDocCurePartGrpSet [ Cardinality = parent, Inverse = ChildDHCDocCurePartGrpLinkSet, Required, SqlFieldName = CPGLS_ParRef_Dr ];

/// CPGLS_Part_Dr 关联部位
Property CPGLSPartDr As User.DHCDocCurePartSet [ SqlColumnNumber = 2, SqlFieldName = CPGLS_Part_Dr ];

/// CPGLS_IndexSeq 排序
Property CPGLSIndexSeq As %String [ SqlColumnNumber = 3, SqlFieldName = CPGLS_IndexSeq ];

/// CPGLS_Hospital 院区
Property CPGLSHospital As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = CPGLS_Hospital ];

Index CPGLSHospital On CPGLSHospital;

Storage Default
{
<Data name="DHCDocCurePartGrpLinkSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPGLSPartDr</Value>
</Value>
<Value name="3">
<Value>CPGLSIndexSeq</Value>
</Value>
<Value name="4">
<Value>CPGLSHospital</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDHCDocCurePartGrpLinkSet")</DataLocation>
<DefaultData>DHCDocCurePartGrpLinkSetDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCDocCurePartGrpSetC("ChildDHCDocCurePartGrpLinkSet")</IdLocation>
<IndexLocation>^User.DHCDocCurePartGrpLinkSetI</IndexLocation>
<StreamLocation>^User.DHCDocCurePartGrpLinkSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

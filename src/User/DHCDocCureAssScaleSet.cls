/// 治疗评定量表设置
Class User.DHCDocCureAssScaleSet Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCASS_RowID, SqlTableName = DHC_DocCureAssScaleSet ]
{

Relationship DCASSParRefDr As User.DHCDocCureAssScale [ Cardinality = parent, Inverse = ChildDHCDocCureAssScaleSet, Required, SqlFieldName = DCASS_ParRef_Dr ];

/// 元素ID  DCASS_key
Property DCASSkey As %String(DISPLAYLIST = ",ARCIM,CTLOC", MAXLEN = 9, SELECTIVITY = "33.3333%", VALUELIST = ",ARCIM,CTLOC") [ SqlColumnNumber = 2, SqlFieldName = DCASS_key ];

/// 元素值  DCASS_Text
Property DCASSValue As %String [ SqlColumnNumber = 3, SqlFieldName = DCASS_Value ];

/// 医院 DCAS_Hosp_Dr  
Property DCASSHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = DCASS_Hosp_Dr ];

Index DCASSkeyValueIndex On (DCASSkey, DCASSValue);

Index DCASSkeyHospValueIndex On (DCASSkey, DCASSHospDr, DCASSValue);

Storage Default
{
<Data name="DHCDocCureAssScaleSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DCASSkey</Value>
</Value>
<Value name="3">
<Value>DCASSValue</Value>
</Value>
<Value name="4">
<Value>DCASSHospDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDHCDocCureAssScaleSet")</DataLocation>
<DefaultData>DHCDocCureAssScaleSetDefaultData</DefaultData>
<IdLocation>^User.DHCDocCureAssScaleC("ChildDHCDocCureAssScaleSet")</IdLocation>
<IndexLocation>^User.DHCDocCureAssScaleSetI</IndexLocation>
<StreamLocation>^User.DHCDocCureAssScaleSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

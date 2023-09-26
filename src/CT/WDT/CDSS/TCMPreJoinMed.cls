/// Creator:高姗姗
/// CreatDate:2021-08-11
/// Description：方剂关联中药字典 
/// Table：CT.WDT.CDSS.TCMPreJoinMed
Class CT.WDT.CDSS.TCMPreJoinMed Extends (%Persistent, User.Abstract)
{

/// 方剂 指向中医方剂字典
Property PrescriptionDR As CT.WDT.CDSS.TCMPrescription [ Required ];

/// 中药 指向中药字典【方剂组成】
Property MedicineDR As CT.WDT.CDSS.TCMMedicine [ Required ];

// Property RecommendDose As DHCDSSTCMMedicine;

/// 推荐剂量
Property RecommendDose As %String(MAXLEN = "");

/// 剂量单位
Property DoseUnit As CT.WDT.CDSS.UnitDict;

/// 煎法
Property Decoction As CT.WDT.CDSS.TCMDecoction;

Index PrescriptionIndex On PrescriptionDR;

Index MedicineIndex On MedicineDR;

Index PrescriptMedIndex On (PrescriptionDR, MedicineDR);

Storage Default
{
<Data name="TCMPreJoinMedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PrescriptionDR</Value>
</Value>
<Value name="3">
<Value>MedicineDR</Value>
</Value>
<Value name="4">
<Value>RecommendDose</Value>
</Value>
<Value name="5">
<Value>DoseUnit</Value>
</Value>
<Value name="6">
<Value>Decoction</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.TCMPreJoinMedD</DataLocation>
<DefaultData>TCMPreJoinMedDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TCMPreJoinMedD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TCMPreJoinMedI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TCMPreJoinMedS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

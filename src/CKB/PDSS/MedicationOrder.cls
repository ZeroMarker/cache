Class CKB.PDSS.MedicationOrder Extends (%Persistent, User.Abstract) [ SqlRowIdName = MO_RowID, SqlTableName = MedicationOrder ]
{

/// 就诊号
Property MOAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = MO_Adm_Dr ];

/// 系统编号
Property MOSysNo As %String [ SqlColumnNumber = 3, SqlFieldName = MO_SysNo ];

/// 日期
Property MODate As %Date [ SqlColumnNumber = 4, SqlFieldName = MO_Date ];

/// 处方号
Property MOPrescripNo As %String [ SqlColumnNumber = 5, SqlFieldName = MO_PrescripNo ];

/// 备注
Property MORemarks As %String(MAXLEN = 9999) [ SqlColumnNumber = 6, SqlFieldName = MO_Remarks ];

/// 煎煮器皿
Property MODecVessel As %String(MAXLEN = 9999) [ SqlColumnNumber = 7, SqlFieldName = MO_DecVessel ];

/// 浸泡水量
Property MOSoakWater As %String(MAXLEN = 9999) [ SqlColumnNumber = 8, SqlFieldName = MO_SoakWater ];

/// 浸泡时间
Property MOSoakTime As %String(MAXLEN = 9999) [ SqlColumnNumber = 9, SqlFieldName = MO_SoakTime ];

/// 煎煮次数
Property MODecTimes As %String(MAXLEN = 9999) [ SqlColumnNumber = 10, SqlFieldName = MO_DecTimes ];

/// 煎煮时间
Property MODecTime As %String(MAXLEN = 9999) [ SqlColumnNumber = 11, SqlFieldName = MO_DecTime ];

/// 煎煮温度
Property MODecTemp As %String(MAXLEN = 9999) [ SqlColumnNumber = 12, SqlFieldName = MO_DecTemp ];

/// 特殊煎煮方法
Property MODecMethod As %String(MAXLEN = 9999) [ SqlColumnNumber = 13, SqlFieldName = MO_DecMethod ];

/// 第一煎
Property MODecFirFried As %String(MAXLEN = 9999) [ SqlColumnNumber = 14, SqlFieldName = MO_DecFirFried ];

/// 第二煎
Property MODecSecFried As %String(MAXLEN = 9999) [ SqlColumnNumber = 15, SqlFieldName = MO_DecSecFried ];

/// 服药温度
Property MOMedTemp As %String(MAXLEN = 9999) [ SqlColumnNumber = 16, SqlFieldName = MO_MedTemp ];

/// 服药时间
Property MOMedTime As %String(MAXLEN = 9999) [ SqlColumnNumber = 17, SqlFieldName = MO_MedTime ];

/// 服药次数
Property MOMedTimes As %String(MAXLEN = 9999) [ SqlColumnNumber = 18, SqlFieldName = MO_MedTimes ];

/// 服药剂量
Property MODosage As %String(MAXLEN = 9999) [ SqlColumnNumber = 19, SqlFieldName = MO_Dosage ];

/// 服药食忌
Property MOFoodTaboo As %String(MAXLEN = 9999) [ SqlColumnNumber = 20, SqlFieldName = MO_FoodTaboo ];

/// 药后护理
Property MOPostDrugCare As %String(MAXLEN = 9999) [ SqlColumnNumber = 21, SqlFieldName = MO_PostDrugCare ];

/// 用药告知
Property MOMedNotify As %String(MAXLEN = 9999) [ SqlColumnNumber = 22, SqlFieldName = MO_MedNotify ];

/// 储存方法
Property MOStorageMethod As %String(MAXLEN = 9999) [ SqlColumnNumber = 23, SqlFieldName = MO_StorageMethod ];

/// 特殊服法
Property MOSpecialObey As %String(MAXLEN = 9999) [ SqlColumnNumber = 24, SqlFieldName = MO_SpecialObey ];

/// 方剂类型
Property MOPrescType As %String(MAXLEN = 9999) [ SqlColumnNumber = 25, SqlFieldName = MO_PrescType ];

/// 浸泡水量2(二煎)
Property MOSoakWater2 As %String(MAXLEN = 9999) [ SqlColumnNumber = 26, SqlFieldName = MO_SoakWater2 ];

/// 煎煮时间2(二煎)
Property MODecTime2 As %String(MAXLEN = 9999) [ SqlColumnNumber = 27, SqlFieldName = MODecTime2 ];

/// 注意事项
Property MOMattersAttention As %String(MAXLEN = 9999) [ SqlColumnNumber = 28, SqlFieldName = MO_MattersAttention ];

/// 证候禁忌
Property MOSyndromeContion As %String(MAXLEN = 9999) [ SqlColumnNumber = 29, SqlFieldName = MO_SyndromeContion ];

/// 饮食禁忌
Property MODietaryTaboos As %String(MAXLEN = 9999) [ SqlColumnNumber = 30, SqlFieldName = MO_DietaryTaboos ];

/// 孕妇及哺乳期妇女用药
Property MOPregMedication As %String(MAXLEN = 9999) [ SqlColumnNumber = 31, SqlFieldName = MO_PregMedication ];

/// 儿童用药
Property MOChildMedication As %String(MAXLEN = 9999) [ SqlColumnNumber = 32, SqlFieldName = MO_ChildMedication ];

/// 老年用药
Property MOGeriatricMedication As %String(MAXLEN = 9999) [ SqlColumnNumber = 33, SqlFieldName = MO_GeriatricMedication ];

/// 药物相互作用
Property MODrugInteraction As %String(MAXLEN = 9999) [ SqlColumnNumber = 34, SqlFieldName = MO_DrugInteraction ];

/// 贮藏方法
Property MOStorMethod As %String(MAXLEN = 9999) [ SqlColumnNumber = 35, SqlFieldName = MO_StorMethod ];

/// 毒性提示
Property MOToxicityTips As %String(MAXLEN = 9999) [ SqlColumnNumber = 36, SqlFieldName = MO_ToxicityTips ];

/// 健康提示
Property MOHealthTips As %String(MAXLEN = 9999) [ SqlColumnNumber = 37, SqlFieldName = MO_HealthTips ];

/// 处方组成
Property MOPrescCompotion As %String(MAXLEN = 9999) [ SqlColumnNumber = 38, SqlFieldName = MO_PrescCompotion ];

/// 处方规格
Property MOPrescSpec As %String(MAXLEN = 9999) [ SqlColumnNumber = 39, SqlFieldName = MO_PrescSpec ];

/// 处方数量
Property MOPrescNum As %String(MAXLEN = 9999) [ SqlColumnNumber = 40, SqlFieldName = MO_PrescNum ];

Index Adm On MOAdmDr As Exact;

Index Date On MODate As Exact;

Index PrescripNo On MOPrescripNo As Exact;

Index SysNo On MOSysNo As Exact;

Storage Default
{
<Data name="MedicationOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MOAdmDr</Value>
</Value>
<Value name="3">
<Value>MOSysNo</Value>
</Value>
<Value name="4">
<Value>MODate</Value>
</Value>
<Value name="5">
<Value>MOPrescripNo</Value>
</Value>
<Value name="6">
<Value>MORemarks</Value>
</Value>
<Value name="7">
<Value>MODecVessel</Value>
</Value>
<Value name="8">
<Value>MOSoakWater</Value>
</Value>
<Value name="9">
<Value>MOSoakTime</Value>
</Value>
<Value name="10">
<Value>MODecTimes</Value>
</Value>
<Value name="11">
<Value>MODecTime</Value>
</Value>
<Value name="12">
<Value>MODecTemp</Value>
</Value>
<Value name="13">
<Value>MODecMethod</Value>
</Value>
<Value name="14">
<Value>MODecFirFried</Value>
</Value>
<Value name="15">
<Value>MODecSecFried</Value>
</Value>
<Value name="16">
<Value>MOMedTemp</Value>
</Value>
<Value name="17">
<Value>MOMedTime</Value>
</Value>
<Value name="18">
<Value>MOMedTimes</Value>
</Value>
<Value name="19">
<Value>MODosage</Value>
</Value>
<Value name="20">
<Value>MOFoodTaboo</Value>
</Value>
<Value name="21">
<Value>MOPostDrugCare</Value>
</Value>
<Value name="22">
<Value>MOMedNotify</Value>
</Value>
<Value name="23">
<Value>MOStorageMethod</Value>
</Value>
<Value name="24">
<Value>MOSpecialObey</Value>
</Value>
<Value name="25">
<Value>MOPrescType</Value>
</Value>
<Value name="26">
<Value>MOSoakWater2</Value>
</Value>
<Value name="27">
<Value>MODecTime2</Value>
</Value>
<Value name="28">
<Value>MOMattersAttention</Value>
</Value>
<Value name="29">
<Value>MOSyndromeContion</Value>
</Value>
<Value name="30">
<Value>MODietaryTaboos</Value>
</Value>
<Value name="31">
<Value>MOPregMedication</Value>
</Value>
<Value name="32">
<Value>MOChildMedication</Value>
</Value>
<Value name="33">
<Value>MOGeriatricMedication</Value>
</Value>
<Value name="34">
<Value>MODrugInteraction</Value>
</Value>
<Value name="35">
<Value>MOStorMethod</Value>
</Value>
<Value name="36">
<Value>MOToxicityTips</Value>
</Value>
<Value name="37">
<Value>MOHealthTips</Value>
</Value>
<Value name="38">
<Value>MOPrescCompotion</Value>
</Value>
<Value name="39">
<Value>MOPrescSpec</Value>
</Value>
<Value name="40">
<Value>MOPrescNum</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.MedicationOrderD</DataLocation>
<DefaultData>MedicationOrderDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.MedicationOrderD</IdLocation>
<IndexLocation>^CKB.PDSS.MedicationOrderI</IndexLocation>
<StreamLocation>^CKB.PDSS.MedicationOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

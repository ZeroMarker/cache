/// 特殊人群检查
Class CHSS.PersonYearCheckSpecial Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = SpecialRowId, SqlTableName = PersonYearCheckSpecial ]
{

Property YearCheckRowIdParref As CHSS.PersonYearCheckRecord [ Required ];

//足背动脉搏动

Property DorsumArteriopalums As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DorsumArteriopalums ];

//颈静脉怒张标志

Property DistensionOfJugularVein As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DistensionOfJugularVein ];

//口唇紫濳标志

Property OralLips As CHSS.DictOralLips [ SqlColumnNumber = 4, SqlFieldName = OralLips ];

//血氧饱和度

Property OxyhemoglobinSaturation As %Float [ SqlColumnNumber = 5, SqlFieldName = OxyhemoglobinSaturation ];

//糖化血红蛋白

Property GlycosylatedHemoglobin As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = GlycosylatedHemoglobin ];

//空腹血糖

Property FPG As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = FPG ];

//血钾

Property K As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = K ];

//血钠

Property Na As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = Na ];

//COPD咳嗽症状

Property Cough As CHSS.DictChogh [ SqlColumnNumber = 10, SqlFieldName = Cough ];

//COP咯痰症状

Property Phlegm As CHSS.DictExpectoration [ SqlColumnNumber = 11, SqlFieldName = Phlegm ];

//一秒钟用力呼吸量

Property BCOfOneSecond As %Integer [ SqlColumnNumber = 12, SqlFieldName = BCOfOneSecond ];

//一秒钟用力呼吸量/最大肺活量

Property BCRate As %Integer [ SqlColumnNumber = 13, SqlFieldName = BCRate ];

//呼吸困难

Property Dyspnea As CHSS.DictDyspnea [ SqlColumnNumber = 14, SqlFieldName = Dyspnea ];

//口唇发紫

Property CyanOticLips As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CyanOticLips ];

//颈静脉

Property JugularVein As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = JugularVein ];

//哮鸣音

Property WheezingRale As CHSS.DictWheezingRale [ SqlColumnNumber = 17, SqlFieldName = WheezingRale ];

//6分钟步行距离

Property WalkDistanceInSix As %Integer [ SqlColumnNumber = 18, SqlFieldName = WalkDistanceInSix ];

//血氧饱和度 

Property SaO2 As %Float [ SqlColumnNumber = 19, SqlFieldName = SaO2 ];

//第一秒用力肺活量到用力肺活量

Property FEV1toFVC As %Float [ SqlColumnNumber = 20, SqlFieldName = FEV1toFVC ];

//第一秒用力肺活量

Property FEV1 As %Float [ SqlColumnNumber = 21, SqlFieldName = FEV1 ];

//SGRQ评分值

Property SGRQ As %Float [ SqlColumnNumber = 22, SqlFieldName = SGRQ ];

//备注

Property Remark As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = Remark ];

Index YearCheckRowIdParrefIndex On YearCheckRowIdParref [ Unique ];

Storage Default
{
<Data name="PersonYearCheckSpecialDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BCOfOneSecond</Value>
</Value>
<Value name="3">
<Value>BCRate</Value>
</Value>
<Value name="4">
<Value>Cough</Value>
</Value>
<Value name="5">
<Value>CyanOticLips</Value>
</Value>
<Value name="6">
<Value>DistensionOfJugularVein</Value>
</Value>
<Value name="7">
<Value>DorsumArteriopalums</Value>
</Value>
<Value name="8">
<Value>Dyspnea</Value>
</Value>
<Value name="9">
<Value>FEV1</Value>
</Value>
<Value name="10">
<Value>FEV1toFVC</Value>
</Value>
<Value name="11">
<Value>FPG</Value>
</Value>
<Value name="12">
<Value>GlycosylatedHemoglobin</Value>
</Value>
<Value name="13">
<Value>JugularVein</Value>
</Value>
<Value name="14">
<Value>K</Value>
</Value>
<Value name="15">
<Value>Na</Value>
</Value>
<Value name="16">
<Value>OralLips</Value>
</Value>
<Value name="17">
<Value>OxyhemoglobinSaturation</Value>
</Value>
<Value name="18">
<Value>Phlegm</Value>
</Value>
<Value name="19">
<Value>Remark</Value>
</Value>
<Value name="20">
<Value>SGRQ</Value>
</Value>
<Value name="21">
<Value>SaO2</Value>
</Value>
<Value name="22">
<Value>WalkDistanceInSix</Value>
</Value>
<Value name="23">
<Value>WheezingRale</Value>
</Value>
<Value name="24">
<Value>YearCheckRowIdParref</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonYearCheckSpecialD</DataLocation>
<DefaultData>PersonYearCheckSpecialDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonYearCheckSpecialD</IdLocation>
<IndexLocation>^CHSS.PersonYearCheckSpecialI</IndexLocation>
<StreamLocation>^CHSS.PersonYearCheckSpecialS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

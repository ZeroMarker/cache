Class CHSS.FamilyEarthquakeInfo Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = FamilyEarthquakeInfo ]
{

Property FamilyProperty As CHSS.DictFamilyProperty;

/// 外键
Property FamilyRowIdParref As CHSS.FamilyHealthRecord [ Required ];

/// 家庭性质
/// 地震前劳动力人数
Property NumOfLabourBefore As %Numeric;

/// 地震前其他人数
Property NumOfOtherBefore As %Numeric;

/// 地震前男
Property NumOfManBefore As %Numeric;

/// 地震前女
Property NumOfWomenBefore As %Numeric;

/// 地震后劳动力人数
Property NumOfLabourAfter As %Numeric;

/// 地震后其他人数
Property NumOfOtherAfter As %Numeric;

/// 地震后男
Property NumOfManAfter As %Numeric;

/// 地震后女 
Property NumOfWomenAfter As %Numeric;

/// 地震前家庭人均收入
Property PerIncomeBefore As %Float;

/// 地震前家庭总收入
Property AllIncomeBefore As %Float;

/// 地震后家庭人均收入
Property PerIncomeAfter As %Float;

/// 地震后家庭总收入
Property AllIncomeAfter As %Float;

/// 地震前家庭消费年支出-食品
Property ExpensesOfFoodBefore As %Float;

/// 地震前家庭消费年支出-衣着
Property ExpensesOfDressBefore As %Float;

/// 地震前家庭消费年支出-家庭设备用品
Property ExpensesOfFacilitiesBefore As %Float;

/// 地震前家庭消费年支出-医疗保健
Property ExpensesOfHealthCareBefore As %Float;

/// 地震前家庭消费年支出-交通通信
Property ExpensesOfTransportBefore As %Float;

/// 地震前家庭消费年支出-文教娱乐
Property ExpensesOfRecreationBefore As %Float;

/// 地震前家庭消费年支出-居住
Property ExpensesOfLiveBefore As %Float;

/// 地震前家庭消费年支出-杂项
Property ExpensesOfOverheadsBefore As %Float;

/// 地震后家庭消费年支出-食品
Property ExpensesOfFoodAfter As %Float;

/// 地震后家庭消费年支出-衣着
Property ExpensesOfDressAfter As %Float;

/// 地震后家庭消费年支出-家庭设备用品
Property ExpensesOfFacilitiesAfter As %Float;

/// 地震后家庭消费年支出-医疗保健
Property ExpensesOfHealthCareAfter As %Float;

/// 地震后家庭消费年支出-交通通信
Property ExpensesOfTransportAfter As %Float;

/// 地震后家庭消费年支出-居住
Property ExpensesOfLiveAfter As %Float;

/// 地震后家庭消费年支出-文教娱乐
Property ExpensesOfRecreationAfter As %Float;

/// 地震后家庭消费年支出-杂项
Property ExpensesOfOverheadsAfter As %Float;

/// 地震前居住地是否通公路
Property bHighwaysBefore As %String(MAXLEN = 5, TRUNCATE = 1);

/// 高速公路类型
Property HighwayType As CHSS.HighWayType;

/// 地震后居住地交通是否受损
Property bHighwayAverage As %String(MAXLEN = 5, TRUNCATE = 1);

/// 阻断时间
Property TimeOfInterdiction As %Numeric;

/// 地震前通信情况
Property CommunicationBefore As CHSS.DictCommunication;

/// 地震后通信是否受损
Property bCommunicationAverage As %String(MAXLEN = 5, TRUNCATE = 1);

/// 中断时间
Property TimeOfInterrupt As %Numeric;

/// 地震前家庭是否有结核病人居住
Property HaveTBPatient As %String(MAXLEN = 5, TRUNCATE = 1);

/// 结核病人数
Property NumberOfTB As %Numeric;

/// 结核病人是否治疗
Property bTreatment As %String(MAXLEN = 5, TRUNCATE = 1);

/// 录入人员
Property OperatorInput As User.SSUser;

/// 录入日期
Property DateInput As %Date;

Index FamilyRowIdParrefIndex On FamilyRowIdParref [ Unique ];

Storage Default
{
<Data name="FamilyEarthquakeInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FamilyProperty</Value>
</Value>
<Value name="3">
<Value>NumOfLabourBefore</Value>
</Value>
<Value name="4">
<Value>NumOfOtherBefore</Value>
</Value>
<Value name="5">
<Value>NumOfManBefore</Value>
</Value>
<Value name="6">
<Value>NumOfWomenBefore</Value>
</Value>
<Value name="7">
<Value>NumOfLabourAfter</Value>
</Value>
<Value name="8">
<Value>NumOfOtherAfter</Value>
</Value>
<Value name="9">
<Value>NumOfManAfter</Value>
</Value>
<Value name="10">
<Value>NumOfWomenAfter</Value>
</Value>
<Value name="11">
<Value>PerIncomeBefore</Value>
</Value>
<Value name="12">
<Value>AllIncomeBefore</Value>
</Value>
<Value name="13">
<Value>AllIncomeAfter</Value>
</Value>
<Value name="14">
<Value>PerIncomeAfter</Value>
</Value>
<Value name="15">
<Value>ExpensesOfFoodBefore</Value>
</Value>
<Value name="16">
<Value>ExpensesOfDressBefore</Value>
</Value>
<Value name="17">
<Value>ExpensesOfFacilitiesBefore</Value>
</Value>
<Value name="18">
<Value>ExpensesOfHealthCareBefore</Value>
</Value>
<Value name="19">
<Value>ExpensesOfTransportBefore</Value>
</Value>
<Value name="20">
<Value>ExpensesOfRecreationBefore</Value>
</Value>
<Value name="21">
<Value>ExpensesOfLiveBefore</Value>
</Value>
<Value name="22">
<Value>ExpensesOfOverheadsBefore</Value>
</Value>
<Value name="23">
<Value>ExpensesOfFoodAfter</Value>
</Value>
<Value name="24">
<Value>ExpensesOfDressAfter</Value>
</Value>
<Value name="25">
<Value>ExpensesOfFacilitiesAfter</Value>
</Value>
<Value name="26">
<Value>ExpensesOfHealthCareAfter</Value>
</Value>
<Value name="27">
<Value>ExpensesOfLiveAfter</Value>
</Value>
<Value name="28">
<Value>ExpensesOfTransportAfter</Value>
</Value>
<Value name="29">
<Value>ExpensesOfRecreationAfter</Value>
</Value>
<Value name="30">
<Value>ExpensesOfOverheadsAfter</Value>
</Value>
<Value name="31">
<Value>bHighwaysBefore</Value>
</Value>
<Value name="32">
<Value>HighwayType</Value>
</Value>
<Value name="33">
<Value>bHighwayAverage</Value>
</Value>
<Value name="34">
<Value>TimeOfInterdiction</Value>
</Value>
<Value name="35">
<Value>CommunicationBefore</Value>
</Value>
<Value name="36">
<Value>bCommunicationAverage</Value>
</Value>
<Value name="37">
<Value>TimeOfInterrupt</Value>
</Value>
<Value name="38">
<Value>HaveTBPatient</Value>
</Value>
<Value name="39">
<Value>DateInput</Value>
</Value>
<Value name="40">
<Value>NumberOfTB</Value>
</Value>
<Value name="41">
<Value>OperatorInput</Value>
</Value>
<Value name="42">
<Value>bTreatment</Value>
</Value>
<Value name="43">
<Value>FamilyRowIdDR</Value>
</Value>
<Value name="44">
<Value>FamilyRowIdParref</Value>
</Value>
</Data>
<DataLocation>^CHSS.FamilyEarthquakeInfoD</DataLocation>
<DefaultData>FamilyEarthquakeInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.FamilyEarthquakeInfoD</IdLocation>
<IndexLocation>^CHSS.FamilyEarthquakeInfoI</IndexLocation>
<StreamLocation>^CHSS.FamilyEarthquakeInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

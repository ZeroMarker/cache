Class CHSS.PersonEarthquakeInfo Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = PersonEarthquakeInfo ]
{

/// 外键
Property PersonRowIdDR As CHSS.PersonHealthRecordMain [ Required ];

/// 所在市
Property CityThen As CHSS.DictCity;

/// 所在县
Property CountryThen As CHSS.DictSection;

/// 所在镇
Property TownThen As CHSS.DictStreet;

/// 是否受伤
Property bHurt As %String(MAXLEN = 5, TRUNCATE = 1);

/// 是否住院
Property bInHospital As %String(MAXLEN = 5, TRUNCATE = 1);

/// 医院名称
Property HospitalName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 医院名称
Property TransferHospitalName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 转诊住院号
Property TransferInHospitalNumber As %String(MAXLEN = 30, TRUNCATE = 1);

/// 科室
Property Dept As User.CTLoc;

/// 转院科室
Property TransferDept As User.CTLoc;

/// 住院号
Property InHospitalNumber As %String(MAXLEN = 30, TRUNCATE = 1);

/// 入院日期
Property DateOfInHos As %Date;

/// 入院时间
Property TimeOfInHos As %Time;

/// 是否手术
Property bOPS As %String(MAXLEN = 5, TRUNCATE = 1);

/// 是否转院
Property bTransfer As %String(MAXLEN = 5, TRUNCATE = 1);

/// 致伤原因
Property HurtReason As CHSS.DictHurtReason;

/// 是否挤压/掩埋
Property bBury As %String(MAXLEN = 5, TRUNCATE = 1);

/// 被掩埋时间
Property TimeOfBury As %Numeric;

/// 被掩埋中是否进食或饮水
Property bEatorDrink As %String(MAXLEN = 5, TRUNCATE = 1);

/// 被掩埋时意识是否清醒
Property bClearHead As %String(MAXLEN = 5, TRUNCATE = 1);

/// 被掩埋部位
Property BuryPart As CHSS.DictBuryPart;

/// 是否截肢
Property bAmputation As %String(MAXLEN = 5, TRUNCATE = 1);

/// 配偶情况
Property SpouseInfo As CHSS.DictRelativeInfo;

/// 父亲情况
Property FatherInfo As CHSS.DictRelativeInfo;

/// 母亲情况
Property MotherInfo As CHSS.DictRelativeInfo;

/// 子女总数
Property ChildNum As %Numeric;

/// 子女地震前已去世人数
Property ChildDiedBefore As %Numeric;

/// 子女地震中去世人数
Property ChildDiedAfter As %Numeric;

/// 子女地震后下落不明人数
Property ChildUnknownAfter As %Numeric;

/// 子女地震受伤住院人数
Property ChildInHospitalAfter As %Numeric;

/// 亲兄妹总数
Property SibNum As %Numeric;

/// 亲兄妹地震前去世人数
Property SibDiedBefore As %Numeric;

/// 亲兄妹地震中去世人数
Property SibDiedAfter As %Numeric;

/// 亲兄妹地震后下落不明人数
Property SibUnknownAfter As %Numeric;

/// 亲兄妹地震受伤住院人数
Property SibInHospitalAfter As %Numeric;

/// 其他人地震受伤住院人数
Property OtherInHospitalAfter As %Numeric;

/// 其他人地震后下落不明人数
Property OtherUnknown As %Numeric;

/// 其他人地震中去世人数
Property OtherDiedAfter As %Numeric;

/// 其他人地震前去世人数
Property OtherDiedBefore As %Numeric;

/// 是否有同学在地震中死亡
Property bFriendDied As %String(TRUNCATE = 1);

/// 房屋、财产是否受损严重
Property bHouseAverage As %String(MAXLEN = 5, TRUNCATE = 1);

/// 是否亲眼目睹有人因地震掩埋
Property bSeePersonBury As %String(MAXLEN = 5, TRUNCATE = 1);

/// 是否亲眼目睹有人因地震死亡
Property bSeePersonDied As %String(MAXLEN = 5, TRUNCATE = 1);

/// 是否亲眼目睹有人因地震受伤
Property bSeePersonHurt As %String(MAXLEN = 5, TRUNCATE = 1);

/// 地震后居住状况是否改变
Property bResidenceStatusChanged As %String(MAXLEN = 5, TRUNCATE = 1);

/// 地震前住房类型
Property HouseTypeBefore As CHSS.DictHouseTypeBefore;

/// 地震前居住密度
Property ResidentialDensityBefore As %Numeric;

/// 地震前卫生条件
Property SanitaryConditionBefore As CHSS.DictSanitaryCondition;

/// 地震后住房类型
Property HouseTypeAfter As CHSS.DictHouseTypeBefore;

/// 地震后居住密度
Property ResidentialDensityAfter As %Numeric;

/// 地震后卫生条件
Property SanitaryConditionAfter As CHSS.DictSanitaryCondition;

/// 是否住板房
Property bSampleRoom As %String(MAXLEN = 5, TRUNCATE = 1);

/// 开始时间
Property DateOfStartLive As %Date;

/// 结束时间
Property DateOfEndLive As %Date;

/// 建档人员
Property OperatorInput As User.SSUser;

/// 录入日期
Property DateInput As %Date;

/// 清醒时间
Property TimeOfClear As %Numeric;

/// 受伤部位
Property HurtPart As CHSS.DictHurtPart;

/// 截肢部位
Property Amputation As CHSS.DictAmputation;

Index PersonRowIdDRIndex On PersonRowIdDR [ Unique ];

Storage Default
{
<Data name="PersonEarthquakeInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>bHurt</Value>
</Value>
<Value name="3">
<Value>bInHospital</Value>
</Value>
<Value name="4">
<Value>HospitalName</Value>
</Value>
<Value name="5">
<Value>Dept</Value>
</Value>
<Value name="6">
<Value>DateOfInHos</Value>
</Value>
<Value name="7">
<Value>InHospitalNumber</Value>
</Value>
<Value name="8">
<Value>TimeOfInHos</Value>
</Value>
<Value name="9">
<Value>bOPS</Value>
</Value>
<Value name="10">
<Value>BuryPart</Value>
</Value>
<Value name="11">
<Value>HurtReason</Value>
</Value>
<Value name="12">
<Value>TimeOfBury</Value>
</Value>
<Value name="13">
<Value>bBury</Value>
</Value>
<Value name="14">
<Value>bClearHead</Value>
</Value>
<Value name="15">
<Value>bEatorDrink</Value>
</Value>
<Value name="16">
<Value>bTransfer</Value>
</Value>
<Value name="17">
<Value>bAmputation</Value>
</Value>
<Value name="18">
<Value>ChildDiedBefore</Value>
</Value>
<Value name="19">
<Value>ChildNum</Value>
</Value>
<Value name="20">
<Value>FatherInfo</Value>
</Value>
<Value name="21">
<Value>MotherInfo</Value>
</Value>
<Value name="22">
<Value>SpouseInfo</Value>
</Value>
<Value name="23">
<Value>ChildDiedAfter</Value>
</Value>
<Value name="24">
<Value>ChildInHospitalAfter</Value>
</Value>
<Value name="25">
<Value>ChildUnknownAfter</Value>
</Value>
<Value name="26">
<Value>SibNum</Value>
</Value>
<Value name="27">
<Value>SibDiedBefore</Value>
</Value>
<Value name="28">
<Value>SibDiedAfter</Value>
</Value>
<Value name="29">
<Value>SibUnknownAfter</Value>
</Value>
<Value name="30">
<Value>SibInHospitalAfter</Value>
</Value>
<Value name="31">
<Value>OtherInHospitalAfter</Value>
</Value>
<Value name="32">
<Value>OtherUnknown</Value>
</Value>
<Value name="33">
<Value>OtherDiedAfter</Value>
</Value>
<Value name="34">
<Value>OtherDiedBefore</Value>
</Value>
<Value name="35">
<Value>bFriendDied</Value>
</Value>
<Value name="36">
<Value>bHouseAverage</Value>
</Value>
<Value name="37">
<Value>bSeePersonBury</Value>
</Value>
<Value name="38">
<Value>bSeePersonDied</Value>
</Value>
<Value name="39">
<Value>bSeePersonHurt</Value>
</Value>
<Value name="40">
<Value>bResidenceStatusChanged</Value>
</Value>
<Value name="41">
<Value>HouseTypeBefore</Value>
</Value>
<Value name="42">
<Value>ResidentialDensityBefore</Value>
</Value>
<Value name="43">
<Value>SanitaryConditionBefore</Value>
</Value>
<Value name="44">
<Value>HouseTypeAfter</Value>
</Value>
<Value name="45">
<Value>ResidentialDensityAfter</Value>
</Value>
<Value name="46">
<Value>SanitaryConditionAfter</Value>
</Value>
<Value name="47">
<Value>bSampleRoom</Value>
</Value>
<Value name="48">
<Value>DateOfStartLive</Value>
</Value>
<Value name="49">
<Value>DateOfEndLive</Value>
</Value>
<Value name="50">
<Value>OperatorInput</Value>
</Value>
<Value name="51">
<Value>DateInput</Value>
</Value>
<Value name="52">
<Value>PersonRowIdDR</Value>
</Value>
<Value name="53">
<Value>TimeOfClear</Value>
</Value>
<Value name="54">
<Value>CityThen</Value>
</Value>
<Value name="55">
<Value>CountryThen</Value>
</Value>
<Value name="56">
<Value>TownThen</Value>
</Value>
<Value name="57">
<Value>TransferDept</Value>
</Value>
<Value name="58">
<Value>TransferHospitalName</Value>
</Value>
<Value name="59">
<Value>TransferInHospitalNumber</Value>
</Value>
<Value name="60">
<Value>HurtPart</Value>
</Value>
<Value name="61">
<Value>Amputation</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonEarthquakeInfoD</DataLocation>
<DefaultData>PersonEarthquakeInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonEarthquakeInfoD</IdLocation>
<IndexLocation>^CHSS.PersonEarthquakeInfoI</IndexLocation>
<StreamLocation>^CHSS.PersonEarthquakeInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

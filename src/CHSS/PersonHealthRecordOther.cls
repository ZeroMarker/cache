Class CHSS.PersonHealthRecordOther Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = PersonOtherRowId, SqlTableName = PersonHealthRecordOther ]
{

/// 外键
Property PersonRowIdParref As CHSS.PersonHealthRecordMain [ Required ];

/// 暂住证类别
Property TempResidentType As %String(MAXLEN = 60, TRUNCATE = 1);

/// 来京日期
Property DateToBJ As %Date(FORMAT = 1);

/// 住宅电话
Property HomePhone As %String(MAXLEN = 50, TRUNCATE = 1);

/// 手机号码
Property CellPhone As %String(MAXLEN = 30, TRUNCATE = 1);

/// 出生证号
Property BirthID As %String(MAXLEN = 30, TRUNCATE = 1);

/// 儿童手册号
Property ChildID As %String(MAXLEN = 30, TRUNCATE = 1);

/// 妇保手册号
Property WomenID As %String(MAXLEN = 30, TRUNCATE = 1);

/// 父亲姓名
Property FatherName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 母亲姓名
Property MotherName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 配偶姓名
Property SpouseName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 身高
Property Height As %Float;

/// 体重
Property Weight As %Float;

/// 经济来源
Property IncomeSource As %String(MAXLEN = 50, TRUNCATE = 1);

/// add by wangbo 2009-11-16
/// 
/// 工作单位地址
Property WorkPlaceAdd As %String(MAXLEN = 100, TRUNCATE = 1);

/// 单位电话
Property WorkPlacePhone As %String(MAXLEN = 50, TRUNCATE = 1);

/// 从事时间最长的职业
Property LongProfessionDR As User.CTOccupation;

/// 最长居住地
Property Domicile As %String(MAXLEN = 80, TRUNCATE = 1);

/// 身体不适时采用的措施
Property MUPSMeasure As %String(MAXLEN = 100, TRUNCATE = 1);

/// 卫生服务要求
Property HeaSerWant As %String(MAXLEN = 100, TRUNCATE = 1);

/// 心率
Property PHeartRate As %Numeric;

/// 高压
Property PHighHBP As %Numeric;

/// 低压
Property PLowHBP As %Numeric;

/// 邮编
Property PersonPost As %String(MAXLEN = 6, TRUNCATE = 1);

/// RH血型
Property RHBloodType As %String(MAXLEN = 60, TRUNCATE = 1);

Index PersonRowIdParrefIndex On PersonRowIdParref;

Storage Default
{
<Data name="PersonHealthRecordOtherDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BirthID</Value>
</Value>
<Value name="3">
<Value>CellPhone</Value>
</Value>
<Value name="4">
<Value>ChildID</Value>
</Value>
<Value name="5">
<Value>DateToBJ</Value>
</Value>
<Value name="6">
<Value>HomePhone</Value>
</Value>
<Value name="7">
<Value>TempResidentType</Value>
</Value>
<Value name="8">
<Value>WomenID</Value>
</Value>
<Value name="9">
<Value>FatherName</Value>
</Value>
<Value name="10">
<Value>Height</Value>
</Value>
<Value name="11">
<Value>IncomeSource</Value>
</Value>
<Value name="12">
<Value>MotherName</Value>
</Value>
<Value name="13">
<Value>SpouseName</Value>
</Value>
<Value name="14">
<Value>Weight</Value>
</Value>
<Value name="15">
<Value>PersonRowIdParref</Value>
</Value>
<Value name="16">
<Value>LongProfessionDR</Value>
</Value>
<Value name="17">
<Value>WorkPlaceAdd</Value>
</Value>
<Value name="18">
<Value>WorkPlacePhone</Value>
</Value>
<Value name="19">
<Value>Domicile</Value>
</Value>
<Value name="20">
<Value>HeaSerWant</Value>
</Value>
<Value name="21">
<Value>MUPSMeasure</Value>
</Value>
<Value name="22">
<Value>PHeartRate</Value>
</Value>
<Value name="23">
<Value>PHighHBP</Value>
</Value>
<Value name="24">
<Value>PLowHBP</Value>
</Value>
<Value name="25">
<Value>PersonPost</Value>
</Value>
<Value name="26">
<Value>RHBloodType</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonHealthRecordOtherD</DataLocation>
<DefaultData>PersonHealthRecordOtherDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonHealthRecordOtherD</IdLocation>
<IndexLocation>^CHSS.PersonHealthRecordOtherI</IndexLocation>
<StreamLocation>^CHSS.PersonHealthRecordOtherS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

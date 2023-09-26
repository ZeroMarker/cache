/// 人员信息表
Class dhc.bonus.data.BonusPersonInfo Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = Rowid, SqlTableName = BonusPersonInfo ]
{

/// 人员编码
Property PersonCode As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 人员姓名
Property PersonName As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 姓名简拼或全拼
Property PersonSpell As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 科别
Property Dept As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// 身份证号
Property PersonIDCard As %Library.String(COLLATION = "Exact", MAXLEN = 18, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// 电话号码
Property TelPhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// 工资号
Property SalaryNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

/// 建行卡号  
Property CCBCard As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

/// 建行姓名  
Property CCBName As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

/// 招行卡号  
Property CMBCard As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

/// 招行姓名  
Property CMBName As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

/// 人员类型
Property PersonType As %Library.Integer [ SqlColumnNumber = 13 ];

/// 部门类型
Property DeptType As %Library.Integer [ SqlColumnNumber = 14 ];

/// 来院时间
Property WorkDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15 ];

/// 岗位
Property Post As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

/// 类别
Property Category As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

/// 中餐编号
Property FoodNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 18 ];

/// 新中餐编号
Property NewFoodNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 19 ];

/// 岗位备注1
Property RemarkOne As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20 ];

/// 岗位备注2
Property RemarkTwo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21 ];

/// 统计学历
Property Education As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 22 ];

/// 最高职称聘任/岗位
Property SuperPost As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23 ];

/// 第二轮岗位聘任/聘用岗位2013
Property Twopost As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24 ];

Index code On PersonCode;

Storage Default
{
<Data name="BonusPersonInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonCode</Value>
</Value>
<Value name="3">
<Value>PersonName</Value>
</Value>
<Value name="4">
<Value>PersonSpell</Value>
</Value>
<Value name="5">
<Value>DeptCode</Value>
</Value>
<Value name="6">
<Value>DeptName</Value>
</Value>
<Value name="7">
<Value>PersonIDCard</Value>
</Value>
<Value name="8">
<Value>PersonBankCard</Value>
</Value>
<Value name="9">
<Value>PersonBonusUnitID</Value>
</Value>
<Value name="10">
<Value>PersonHospital</Value>
</Value>
<Value name="11">
<Value>PersonIsValid</Value>
</Value>
<Value name="12">
<Value>PersonSex</Value>
</Value>
<Value name="13">
<Value>PersonTelPhone</Value>
</Value>
<Value name="14">
<Value>PersonType</Value>
</Value>
<Value name="15">
<Value>PersonRoles</Value>
</Value>
<Value name="16">
<Value>TelPhone</Value>
</Value>
<Value name="17">
<Value>SalaryNumber</Value>
</Value>
<Value name="18">
<Value>CCBCard</Value>
</Value>
<Value name="19">
<Value>CCBName</Value>
</Value>
<Value name="20">
<Value>CMBCard</Value>
</Value>
<Value name="21">
<Value>CMBName</Value>
</Value>
<Value name="22">
<Value>DeptType</Value>
</Value>
<Value name="23">
<Value>WorkDate</Value>
</Value>
<Value name="24">
<Value>Post</Value>
</Value>
<Value name="25">
<Value>Category</Value>
</Value>
<Value name="26">
<Value>FoodNumber</Value>
</Value>
<Value name="27">
<Value>NewFoodNumber</Value>
</Value>
<Value name="28">
<Value>RemarkOne</Value>
</Value>
<Value name="29">
<Value>RemarkTwo</Value>
</Value>
<Value name="30">
<Value>Education</Value>
</Value>
<Value name="31">
<Value>SuperPost</Value>
</Value>
<Value name="32">
<Value>Twopost</Value>
</Value>
<Value name="33">
<Value>Dept</Value>
</Value>
</Data>
<DataLocation>^dhcbsPersonInfoD</DataLocation>
<DefaultData>BonusPersonInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsPersonInfoD</IdLocation>
<IndexLocation>^dhcbsBonusPersonInfoI</IndexLocation>
<StreamLocation>^herpBonusPersonInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// 奖金自定义函数
Class dhc.bonus.data.BonusCalcFunction Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BankAccountID ]
{

/// 函数标识
Property FunCode As %Library.String [ SqlColumnNumber = 2 ];

/// 函数名称
Property FunName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 功能描述
Property FunDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 函数M类
Property FunClass As %Library.String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// 参数说明
Property ParaDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// 是否有效，1=有效，0=无效
Property IsValid As %Library.Integer [ SqlColumnNumber = 7 ];

/// 创建日期 系统时间
Property CreatDate As %Library.String [ SqlColumnNumber = 8 ];

Index codeIndex On FunCode As Exact;

/* -------------初始化值----------------------

INSERT INTO dhc_bonus_data.BonusCalcFunction (FunCode, FunName, FunDesc, FunClass, ParaDesc, IsValid, CreatDate)
VALUES ('Percent', '同级指标占比', '取同级指标总和的百分比', 'class(dhc.bonus.udata.uBonusCalcFunction).BSFPercent', 'sCode：奖金方案项目编码或指标编码 ;sParam:单元iD^年份^月份^奖金方案ID', 1, '2016-08-31 15:20:19');

INSERT INTO dhc_bonus_data.BonusCalcFunction (FunCode, FunName, FunDesc, FunClass, ParaDesc, IsValid, CreatDate)
VALUES ('Sum', '同级指标求和', '取同级子指标总和', 'class(dhc.bonus.udata.uBonusCalcFunction).BSBSFSum', 'sCode：奖金方案项目编码或指标编码 ;sParam:单元iD^年份^月份^奖金方案ID', 1, '2016-08-31 15:20:19');

INSERT INTO dhc_bonus_data.BonusCalcFunction (FunCode, FunName, FunDesc, FunClass, ParaDesc, IsValid, CreatDate)
VALUES ('BSAvg', '同级指标均值', '取同级子指标平均值', 'class(dhc.bonus.udata.uBonusCalcFunction).BSFAvg', 'sCode：奖金方案项目编码或指标编码 ;sParam:单元iD^年份^月份^奖金方案ID', 1, '2016-08-31 15:20:19');

INSERT INTO dhc_bonus_data.BonusCalcFunction (FunCode, FunName, FunDesc, FunClass, ParaDesc, IsValid, CreatDate)
VALUES ('SumGrandpa', '祖父级指标求和', '取同祖父指标总和', 'class(dhc.bonus.udata.uBonusCalcFunction).BSFSumGrandpa', 'sCode：奖金方案项目编码或指标编码 ;sParam:单元iD^年份^月份^奖金方案ID', 1, '2016-08-31 15:20:19');

INSERT INTO dhc_bonus_data.BonusCalcFunction (FunCode, FunName, FunDesc, FunClass, ParaDesc, IsValid, CreatDate)
VALUES ('SumChild', '取零相对值', '当指标值大于0时返回1，小于等0时返回0', 'class(dhc.bonus.udata.uBonusCalcFunction).BSFSumChild', 'sCode：奖金方案项目编码或指标编码 ;sParam:单元iD^年份^月份^奖金方案ID', 1, '2016-08-31 15:20:19');

INSERT INTO dhc_bonus_data.BonusCalcFunction (FunCode, FunName, FunDesc, FunClass, ParaDesc, IsValid, CreatDate)
VALUES ('BSDays', '当月天数', '取当月天数', 'class(dhc.bonus.udata.uBonusCalcFunction).BSDays', 'sCode：奖金方案项目编码或指标编码 ;sParam:单元iD^年份^月份^奖金方案ID', 1, '2016-08-31 15:20:19');

INSERT INTO dhc_bonus_data.BonusCalcFunction (FunCode, FunName, FunDesc, FunClass, ParaDesc, IsValid, CreatDate)
VALUES ('BSFPositive', '取正数', '当a>0时取a，当a<0时取0', 'class(dhc.bonus.udata.uBonusCalcFunction).BSFPositive', 'sCode：奖金方案项目编码或指标编码 ;sParam:单元iD^年份^月份^奖金方案ID', 1, '2016-08-31 15:20:19');

INSERT INTO dhc_bonus_data.BonusCalcFunction (FunCode, FunName, FunDesc, FunClass, ParaDesc, IsValid, CreatDate)
VALUES ('BSFInteger', '取整数', '去掉小数点，取整数', 'class(dhc.bonus.udata.uBonusCalcFunction).BSFInteger', 'sCode：奖金方案项目编码或指标编码 ;sParam:单元iD^年份^月份^奖金方案ID', 1, '2016-08-31 15:20:19');




*/
Storage Default
{
<Data name="BonusCalcFunctionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FunCode</Value>
</Value>
<Value name="3">
<Value>FunName</Value>
</Value>
<Value name="4">
<Value>FunDesc</Value>
</Value>
<Value name="5">
<Value>FunClass</Value>
</Value>
<Value name="6">
<Value>ParaDesc</Value>
</Value>
<Value name="7">
<Value>IsValid</Value>
</Value>
<Value name="8">
<Value>CreatDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsCalcFunctionD</DataLocation>
<DefaultData>BonusCalcFunctionDefaultData</DefaultData>
<IdLocation>^dhcbsCalcFunctionD</IdLocation>
<IndexLocation>^dhcbsCalcFunctionI</IndexLocation>
<StreamLocation>^dhcbsCalcFunctionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

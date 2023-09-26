/// 科室收入采集表
Class dhc.bonus.module.BonusIncomeCollect Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubIncomeCollectID ]
{

//收费项目编码

Property IncomeItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IncomeItemCode ];

//所属年

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BonusYear ];

//奖金期间

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BonusPeriod ];

//开单科室编码

Property MakeBillDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MakeBillDeptCode ];

//执行科室编码

Property ExecuteDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ExecuteDeptCode ];

//病人科室编码

Property SickDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SickDeptCode ];

//病人类别 1:门诊，2：住院

Property SickType As %Library.Integer [ SqlColumnNumber = 8, SqlFieldName = SickType ];

//主治医师编码

Property ChiefDoctorCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ChiefDoctorCode ];

//开单医生编码

Property MakeBillDoctorCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MakeBillDoctorCode ];

//执行医生编码

Property ExecuteDoctorCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ExecuteDoctorCode ];

//收入金额

Property IncomeMoney As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = IncomeMoney ];

//调整金额

Property adjustMoney As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = adjustMoney ];

//数据状态

Property State As %Library.Integer [ SqlColumnNumber = 14, SqlFieldName = State ];

//数据导入时间

Property UpdateDate As %Library.String [ SqlColumnNumber = 15, SqlFieldName = UpdateDate ];

// 导入文件名称

Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

// 导入文件名称

Property operator As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

Index IncCollect On (BonusYear, BonusPeriod, SickType, IncomeItemCode, MakeBillDeptCode, ExecuteDeptCode, SickDeptCode);

Storage Default
{
<Data name="BonusIncomeCollectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IncomeItemCode</Value>
</Value>
<Value name="3">
<Value>BonusYear</Value>
</Value>
<Value name="4">
<Value>BonusPeriod</Value>
</Value>
<Value name="5">
<Value>MakeBillDeptCode</Value>
</Value>
<Value name="6">
<Value>ExecuteDeptCode</Value>
</Value>
<Value name="7">
<Value>SickDeptCode</Value>
</Value>
<Value name="8">
<Value>SickType</Value>
</Value>
<Value name="9">
<Value>ChiefDoctorCode</Value>
</Value>
<Value name="10">
<Value>MakeBillDoctorCode</Value>
</Value>
<Value name="11">
<Value>ExecuteDoctorCode</Value>
</Value>
<Value name="12">
<Value>IncomeMoney</Value>
</Value>
<Value name="13">
<Value>State</Value>
</Value>
<Value name="14">
<Value>UpdateDate</Value>
</Value>
<Value name="15">
<Value>FileName</Value>
</Value>
<Value name="16">
<Value>operator</Value>
</Value>
<Value name="17">
<Value>adjustMoney</Value>
</Value>
</Data>
<DataLocation>^dhcbsmdBonusIncomeCollectD</DataLocation>
<DefaultData>BonusIncomeCollectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsmdBonusIncomeCollectD</IdLocation>
<IndexLocation>^dhcbsmdBonusIncomeCollectI</IndexLocation>
<StreamLocation>^dhcbsmdBonusIncomeCollectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

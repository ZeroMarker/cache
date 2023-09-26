Class User.CSSDMachineConfig Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_MachineConfig ]
{

/// key 
Property CSSDMCKey As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDMC_Key ];

/// 机器号
Property CSSDMCNum As %Library.Integer [ Required, SqlColumnNumber = 3, SqlFieldName = CSSDMC_Num ];

/// 厂商
Property CSSDMCManufacture As User.CSSDVen [ SqlColumnNumber = 4, SqlFieldName = CSSDMC_Manufacture ];

/// 数据路径
Property CSSDMCDataPath As %String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 5, SqlFieldName = CSSDMC_DataPath ];

/// 机器类型
Property CSSDMCMachineType As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 6, SqlFieldName = CSSDMC_MachineType ];

/// 机器存储文件名前缀
Property CSSDMCFileNamePrefix As %String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = CSSDMC_FileNamePrefix ];

/// 机器循环次数
Property CSSDMCCycle As %Integer [ SqlColumnNumber = 8, SqlFieldName = CSSDMC_Cycle ];

/// 扩展类型 如 高温,低温等离子,低温环氧乙烷
Property CSSDMCExtType As %String(COLLATION = "Exact") [ SqlColumnNumber = 9, SqlFieldName = CSSDMC_ExtType ];

/// 别名
Property CSSDMCAlias As %String(COLLATION = "Exact") [ SqlColumnNumber = 10, SqlFieldName = CSSDMC_Alias ];

/// 机器运行时间
Property CSSDMCRunTime As %String(COLLATION = "Exact") [ SqlColumnNumber = 11, SqlFieldName = CSSDMC_RunTime ];

/// BD开始时间
Property CSSDMCBDStartTime As %String(COLLATION = "Exact") [ SqlColumnNumber = 12, SqlFieldName = CSSDMC_BD_StartTime ];

/// 是否做BD测试
Property CSSDMCIsBD As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 13, SqlFieldName = CSSDMC_IsBD ];

/// 器械设置状态 可用、停用
Property CSSDMCNotUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 14, SqlFieldName = CSSDMC_NotUseFlag ];

/// 生物监测周期
Property CSSDMCBioTime As %Integer [ SqlColumnNumber = 15, SqlFieldName = CSSDMC_BioTime ];

/// 灭菌器最大装载数量
Property CSSDMCLoadNum As %Integer [ SqlColumnNumber = 16, SqlFieldName = CSSDMC_LoadNum ];

/// 灭菌器/清洗机类型
Property CSSDMCTempType As %String(COLLATION = "Exact") [ SqlColumnNumber = 17, SqlFieldName = CSSDMC_TempType ];

Property CSSDMCSterCar As User.CSSDCodeDict [ SqlColumnNumber = 18, SqlFieldName = CSSDMC_SterCar ];

Property CSSDMCCreateLocDr As User.CTLoc [ SqlColumnNumber = 19, SqlFieldName = CSSDMC_CreateLocDr ];

/// 是否测漏
Property CSSDMCIsLeak As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 20, SqlFieldName = CSSDMC_IsLeak ];

/// 测漏周期
Property CSSDMCLeakTime As %Integer [ SqlColumnNumber = 21, SqlFieldName = CSSDMC_LeakTime ];

/// 型号
Property CSSDMCModel As %String(COLLATION = "Exact") [ SqlColumnNumber = 22, SqlFieldName = CSSDMC_Model ];

/// 供应科室Dr
Property CSSDMCSupLocDR As User.CTLoc [ SqlColumnNumber = 23, SqlFieldName = CSSDMC_SupLoc_DR ];

/// 是否多仓
Property CSSDMCMulBinFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 24, SqlFieldName = CSSDMC_MulBinFlag ];

Index IndexCSSDMCNumType On (CSSDMCNum As Exact, CSSDMCMachineType As Exact);

Index IndexCSSDMCKeyType On (CSSDMCKey As Exact, CSSDMCMachineType As Exact);

Index IndexCSSDMCAliasType On (CSSDMCAlias As Exact, CSSDMCMachineType As Exact);

Index TypeSupLoc On (CSSDMCMachineType As Exact, CSSDMCSupLocDR As Exact);

Index IndexCSSDMCSterCar On CSSDMCSterCar As Exact;

Storage Default
{
<Data name="CSSDMachineConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDMCKey</Value>
</Value>
<Value name="3">
<Value>CSSDMCNum</Value>
</Value>
<Value name="4">
<Value>CSSDMCManufacture</Value>
</Value>
<Value name="5">
<Value>CSSDMCDataPath</Value>
</Value>
<Value name="6">
<Value>CSSDMCMachineType</Value>
</Value>
<Value name="7">
<Value>CSSDMCFileNamePrefix</Value>
</Value>
<Value name="8">
<Value>CSSDMCCycle</Value>
</Value>
<Value name="9">
<Value>CSSDMCExtType</Value>
</Value>
<Value name="10">
<Value>CSSDMCAlias</Value>
</Value>
<Value name="11">
<Value>CSSDMCRunTime</Value>
</Value>
<Value name="12">
<Value>CSSDMCBDStartTime</Value>
</Value>
<Value name="13">
<Value>CSSDMCIsBD</Value>
</Value>
<Value name="14">
<Value>CSSDMCNotUseFlag</Value>
</Value>
<Value name="15">
<Value>CSSDMCBioTime</Value>
</Value>
<Value name="16">
<Value>CSSDMCLoadNum</Value>
</Value>
<Value name="17">
<Value>CSSDMCTempType</Value>
</Value>
<Value name="18">
<Value>CSSDMCSterCar</Value>
</Value>
<Value name="19">
<Value>CSSDMCCreateLocDr</Value>
</Value>
<Value name="20">
<Value>CSSDMCIsLeak</Value>
</Value>
<Value name="21">
<Value>CSSDMCLeakTime</Value>
</Value>
<Value name="22">
<Value>CSSDMCModel</Value>
</Value>
<Value name="23">
<Value>CSSDMCSupLocDR</Value>
</Value>
<Value name="24">
<Value>CSSDMCMulBinFlag</Value>
</Value>
</Data>
<DataLocation>^User.CSSDMachineConfigD</DataLocation>
<DefaultData>CSSDMachineConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDMachineConfigD</IdLocation>
<IndexLocation>^User.CSSDMachineConfigI</IndexLocation>
<StreamLocation>^User.CSSDMachineConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

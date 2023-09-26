/// 麻醉记录数据/麻醉恢复记录数据
Class CIS.AN.AnaData Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = AnaData ]
{

/// 麻醉记录项
Property ParaItem As CIS.AN.ParaItem [ Required, SqlColumnNumber = 2 ];

/// 麻醉记录开始日期
Property StartDate As %Date [ SqlColumnNumber = 3 ];

/// 麻醉记录开始时间
Property StartTime As %Time [ SqlColumnNumber = 4 ];

/// 麻醉记录结束日期
Property EndDate As %Date [ SqlColumnNumber = 5 ];

/// 麻醉记录结束时间
Property EndTime As %Time [ SqlColumnNumber = 6 ];

/// 麻醉记录数据
Property DataValue As %String(MAXLEN = 500) [ SqlColumnNumber = 7 ];

/// 编辑标志
Property EditFlag As %String(DISPLAYLIST = ",正常,删除", VALUELIST = ",N,D") [ SqlColumnNumber = 8 ];

/// 表示麻醉记录数据从哪个数据编辑而来
Property FromData As CIS.AN.AnaData [ SqlColumnNumber = 9 ];

/// 创建用户ID
Property CreateUserID As %String [ SqlColumnNumber = 10 ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11 ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12 ];

/// 数据项
Property DataItem As CT.AN.DataItem [ SqlColumnNumber = 13 ];

/// 自定义项目
Property UserDefinedItem As CF.AN.UserDefDataItem [ SqlColumnNumber = 14 ];

/// 数据来源
Property Source As %String(DISPLAYLIST = ",手工录入,机器采集,自动生成", VALUELIST = ",M,I,A") [ SqlColumnNumber = 15 ];

/// 是否持续
Property Continuous As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 16 ];

/// 签名医生（宁医总院）
Property SignDoctor As %String [ SqlColumnNumber = 17 ];

/// 签名护士（宁医总院）
Property SignNurse As %String [ SqlColumnNumber = 18 ];

/// 自动生成时绑定的收费记录明细
Property ChargeDetail As CIS.AN.ChargeDetail [ SqlColumnNumber = 19 ];

/// 麻醉记录参数索引
Index IParaItem On ParaItem;

/// 麻醉记录参数、开始日期、开始时间索引
Index IItemTime On (ParaItem, StartDate, StartTime);

/// 麻醉记录参数外键约束
ForeignKey FKParaItem(ParaItem) References CIS.AN.ParaItem() [ OnDelete = cascade ];

Storage Default
{
<Data name="AnaDataDefaultData">
<Value name="1">
<Value>ParaItem</Value>
</Value>
<Value name="2">
<Value>StartDate</Value>
</Value>
<Value name="3">
<Value>StartTime</Value>
</Value>
<Value name="4">
<Value>EndDate</Value>
</Value>
<Value name="5">
<Value>EndTime</Value>
</Value>
<Value name="6">
<Value>DataValue</Value>
</Value>
<Value name="7">
<Value>EditFlag</Value>
</Value>
<Value name="8">
<Value>FromData</Value>
</Value>
<Value name="9">
<Value>CreateUserID</Value>
</Value>
<Value name="10">
<Value>CreateDate</Value>
</Value>
<Value name="11">
<Value>CreateTime</Value>
</Value>
<Value name="12">
<Value>DataItem</Value>
</Value>
<Value name="13">
<Value>UserDefinedItem</Value>
</Value>
<Value name="14">
<Value>Source</Value>
</Value>
<Value name="15">
<Value>Continuous</Value>
</Value>
<Value name="16">
<Value>SignDoctor</Value>
</Value>
<Value name="17">
<Value>SignNurse</Value>
</Value>
<Value name="18">
<Value>ChargeDetail</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.AnaDataD</DataLocation>
<DefaultData>AnaDataDefaultData</DefaultData>
<IdLocation>^CIS.AN.AnaDataD</IdLocation>
<IndexLocation>^CIS.AN.AnaDataI</IndexLocation>
<StreamLocation>^CIS.AN.AnaDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

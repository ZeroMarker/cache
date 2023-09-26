Class DHCEPRFS.META.WatermarkScheme Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 水印方案适用范围
Property WatermarkScale As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 水印方案名称
Property WatermarkSchemeName As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 水印方案描述
Property WatermarkSchemeDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 水印位置
/// COMMON - 通用  QUEUEVIEW - 队列管理浏览  QUERYVIEW - 查询浏览  PRINT - 打印  EXPORT - 导出  ACTIVEXVIEW - 前端控件浏览
Property WatermarkLocation As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 是否可用
Property IsAvailable As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 7 ];

/// 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 8 ];

/// 创建用户ID
Property CreateUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

/// 修改日期
Property ModifyDate As %Date [ SqlColumnNumber = 10 ];

/// 修改时间
Property ModifyTime As %Time [ SqlColumnNumber = 11 ];

/// 修改用户ID
Property ModifyUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 12 ];

/// 水印内容
Property WatermarkText As %String(TRUNCATE = 1) [ SqlColumnNumber = 13 ];

/// 水印字体RGB颜色
Property FontColor As %String(TRUNCATE = 1) [ SqlColumnNumber = 14 ];

/// 水印重复次数
Property DuplicateTimes As %String(TRUNCATE = 1) [ SqlColumnNumber = 15 ];

/// 水印行间距
Property LineHeight As %String(TRUNCATE = 1) [ SqlColumnNumber = 16 ];

/// 水印倾斜角度
Property Rotation As %String(TRUNCATE = 1) [ SqlColumnNumber = 17 ];

/// 水印字体大小
Property FontSize As %String(TRUNCATE = 1) [ SqlColumnNumber = 18 ];

/// 水印自定义内容
Property Custom As %String(TRUNCATE = 1) [ SqlColumnNumber = 19 ];

Index IdxWatermarkScale On WatermarkScale;

Index IdxWatermarkLocation On (WatermarkScale, WatermarkLocation);

Index IdxIsAvailable On (WatermarkScale, WatermarkLocation, IsAvailable);

Storage Default
{
<Data name="WatermarkSchemeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WatermarkScale</Value>
</Value>
<Value name="3">
<Value>WatermarkSchemeName</Value>
</Value>
<Value name="4">
<Value>WatermarkSchemeDesc</Value>
</Value>
<Value name="5">
<Value>WatermarkLocation</Value>
</Value>
<Value name="6">
<Value>IsAvailable</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
<Value name="9">
<Value>CreateUserID</Value>
</Value>
<Value name="10">
<Value>ModifyDate</Value>
</Value>
<Value name="11">
<Value>ModifyTime</Value>
</Value>
<Value name="12">
<Value>ModifyUserID</Value>
</Value>
<Value name="13">
<Value>WatermarkText</Value>
</Value>
<Value name="14">
<Value>FontColor</Value>
</Value>
<Value name="15">
<Value>DuplicateTimes</Value>
</Value>
<Value name="16">
<Value>LineHeight</Value>
</Value>
<Value name="17">
<Value>Rotation</Value>
</Value>
<Value name="18">
<Value>FontSize</Value>
</Value>
<Value name="19">
<Value>Custom</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.WatermarkSchemeD</DataLocation>
<DefaultData>WatermarkSchemeDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.WatermarkSchemeD</IdLocation>
<IndexLocation>^DHCEPRFS.META.WatermarkSchemeI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.WatermarkSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

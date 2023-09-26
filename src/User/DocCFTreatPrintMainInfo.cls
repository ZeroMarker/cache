/// 定义接诊打印目录配置表
Class User.DocCFTreatPrintMainInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = TreatPrintMainID ]
{

// PId

Property PId As User.DocCFTreatPrintMainInfo [ SqlColumnNumber = 2 ];

// 目录名称

Property DirectoryName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

// 元素ID

Property ElementId As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

// 值 

Property Value As %Library.String(MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

// 显示顺序

Property DisplayNum As %Library.Integer [ SqlColumnNumber = 6 ];

// 是否为复选框类型

Property noCheckbox As %Library.Boolean [ SqlColumnNumber = 7 ];

// 当isCheckbox为true时节点是否默认选中

Property CheckAble As %Library.Boolean [ SqlColumnNumber = 8 ];

// 是否有效

Property IsActive As %Library.Boolean [ SqlColumnNumber = 9 ];

// 是否展开

Property IsExpand As %Library.Boolean [ SqlColumnNumber = 10 ];

// 展开事件

Property ExpandMethodForLoadingTable As %Library.String(MAXLEN = 124) [ SqlColumnNumber = 11 ];

// 未打印是否在接诊后提示

Property IsSendMessage As %Library.Boolean [ SqlColumnNumber = 12 ];

// 图标样式  ->icon

Property IconStyle As %Library.String(MAXLEN = 124, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

// 字体样式

Property FontStyle As %Library.String(MAXLEN = 124, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

// 点击事件 

Property ClickEvent As %Library.String(MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 15 ];

// 链接  ->urlObject

Property URLObject As %Library.String(MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

// 链接类型  

Property URLStyle As %Library.String(MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

// 条件表达式

Property IconExpression As %Library.String(MAXLEN = 124, TRUNCATE = 0) [ SqlColumnNumber = 18 ];

// 预览的XML文件名称

Property PreviewXMLName As %Library.String(MAXLEN = 124, TRUNCATE = 0) [ SqlColumnNumber = 19 ];

// 获取打印数据的方法

Property PrintMethod As %Library.String(MAXLEN = 124, TRUNCATE = 0) [ SqlColumnNumber = 20 ];

Property HospDr As User.CTHospital [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="DocCFTreatPrintMainInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PId</Value>
</Value>
<Value name="3">
<Value>DirectoryName</Value>
</Value>
<Value name="4">
<Value>ElementID</Value>
</Value>
<Value name="5">
<Value>DisplayType</Value>
</Value>
<Value name="6">
<Value>DisplayNum</Value>
</Value>
<Value name="7">
<Value>IsActive</Value>
</Value>
<Value name="8">
<Value>IsOpen</Value>
</Value>
<Value name="9">
<Value>IconStyle</Value>
</Value>
<Value name="10">
<Value>FontStyle</Value>
</Value>
<Value name="11">
<Value>URLobject</Value>
</Value>
<Value name="12">
<Value>Expression</Value>
</Value>
<Value name="13">
<Value>Message</Value>
</Value>
<Value name="14">
<Value>PreviewXMLname</Value>
</Value>
<Value name="15">
<Value>PrintMethod</Value>
</Value>
<Value name="16">
<Value>URLObject</Value>
</Value>
<Value name="17">
<Value>PreviewXMLName</Value>
</Value>
<Value name="18">
<Value>isCheckbox</Value>
</Value>
<Value name="19">
<Value>CheckAble</Value>
</Value>
<Value name="20">
<Value>ClickEvent</Value>
</Value>
<Value name="21">
<Value>IconExpression</Value>
</Value>
<Value name="22">
<Value>ElementId</Value>
</Value>
<Value name="23">
<Value>IsSendMessage</Value>
</Value>
<Value name="24">
<Value>IsExpand</Value>
</Value>
<Value name="25">
<Value>ExpandEvent</Value>
</Value>
<Value name="26">
<Value>ExpandMethodForLoadingTable</Value>
</Value>
<Value name="27">
<Value>noCheckbox</Value>
</Value>
<Value name="28">
<Value>Value</Value>
</Value>
<Value name="29">
<Value>URLStyle</Value>
</Value>
<Value name="30">
<Value>HospDr</Value>
</Value>
</Data>
<DataLocation>^User.DocCFTreatPrintMainInfoD</DataLocation>
<DefaultData>DocCFTreatPrintMainInfoDefaultData</DefaultData>
<IdLocation>^User.DocCFTreatPrintMainInfoD</IdLocation>
<IndexLocation>^User.DocCFTreatPrintMainInfoI</IndexLocation>
<StreamLocation>^User.DocCFTreatPrintMainInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

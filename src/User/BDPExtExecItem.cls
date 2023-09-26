Class User.BDPExtExecItem Extends %Persistent [ ProcedureBlock ]
{

Relationship ParRef As User.BDPExecutables [ Cardinality = parent, Inverse = ChildExtExecItem ];

/// 字段代码 唯一
Property Code As %String(MAXLEN = "") [ Required, SqlFieldName = Code ];

/// 字段描述,或者控件名称等
Property Name As %String(MAXLEN = "") [ SqlFieldName = Name ];

/// 如果为真，则在HTML时标明此表单元素为只读,Yes/No:  Y/N
Property ReadOnly As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlFieldName = ReadOnly ];

/// 值为 false 时将效验输入字符个数大于0,  Yes/No:   Y/N
Property AllowBlank As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlFieldName = AllowBlank ];

/// 是否隐藏,  Yes/No:   Y/N
Property Hidden As %String [ SqlFieldName = Hidden ];

/// false则不可编辑，默认为 true ,  Yes/No:   Y/N
Property Editable As %String [ SqlFieldName = Editable ];

/// 悬浮提示信息
Property ToolTip As %String(MAXLEN = "") [ SqlFieldName = ToolTip ];

/// 定义显示提示信息的类型，有qtip和title两种方式，默认是qtip
Property ToolTipType As %String [ SqlFieldName = ToolTipType ];

/// 按钮类型：可以是submit, reset or button  默认是 button
Property Type As %String [ SqlFieldName = Type ];

/// 是否自动显示，默认false  ,  Yes/No:   Y/N
Property AutoShow As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlFieldName = AutoShow ];

/// 图标
Property IconCls As %String(MAXLEN = "") [ SqlFieldName = IconCls ];

/// 函数
Property Handler As %String(MAXLEN = "") [ SqlFieldName = Handler ];

Property XType As %String(DISPLAYLIST = ",button,progress,colorpalette,datepicker,checkbox,combo,datefield,timefield,field,displayfield,fieldset,hidden,htmleditor,label,numberfield,radio,textarea,textfield,trigger,checkboxgroup,radiogroup", VALUELIST = ",button,progress,colorpalette,datepicker,checkbox,combo,datefield,timefield,field,displayfield,fieldset,hidden,htmleditor,label,numberfield,radio,textarea,textfield,trigger,checkboxgroup,radiogroup") [ SqlFieldName = XType ];

/// 字段校验时调用的自定义函数 
Property Validator As %String(MAXLEN = "") [ SqlFieldName = Validator ];

/// 如果指定了, 则会动态生成一个以指定名称命名的隐藏域用来存放值数据(默认为)；    真正提交时此combo的name，这个一定要是hiddenName不是name，不然提交的数据为文本框中内容  ..如果ComboBox读取本地数据则将值设为'local'
Property HiddenName As %String(MAXLEN = "") [ SqlFieldName = HiddenName ];

/// 一个用以在效验时使用的 JavaScript 正则表达式对象(默认为 null)。如果启用此项，则此正则表达式将在所有基础效验成功之后被执行，执行此正则表达式时传递的参数为该字段的值。如果效验失败，则根据regexText的设置将字段标记为无效。
Property Regex As %String(MAXLEN = "") [ SqlFieldName = Regex ];

/// 当{@link #regex}被设置且效验失败时显示的错误文本
Property RegexText As %String(MAXLEN = "") [ SqlFieldName = RegexText ];

Property ValueGet As %String(MAXLEN = "") [ SqlFieldName = ValueGet ];

Property ValueSet As %String(MAXLEN = "") [ SqlFieldName = ValueSet ];

Index UnCodeIndex On (ParRef, Code) [ Unique ];

Index CodeIndex On Code;

Storage Default
{
<Data name="BDPExtExecItemClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BDPExtExecItemDefaultData">
<Value name="1">
<Value>BDEFCode</Value>
</Value>
<Value name="2">
<Value>BDEFDesc</Value>
</Value>
<Value name="3">
<Value>BDEFReadOnly</Value>
</Value>
<Value name="4">
<Value>BDEFAllowBlank</Value>
</Value>
<Value name="5">
<Value>BDEFHidden</Value>
</Value>
<Value name="6">
<Value>BDEFEditable</Value>
</Value>
<Value name="7">
<Value>BDEFToolTip</Value>
</Value>
<Value name="8">
<Value>BDEFToolTipType</Value>
</Value>
<Value name="9">
<Value>BDEFType</Value>
</Value>
<Value name="10">
<Value>BDEFAutoShow</Value>
</Value>
<Value name="11">
<Value>BDEFIconCls</Value>
</Value>
<Value name="12">
<Value>BDEFHandler</Value>
</Value>
<Value name="13">
<Value>BDEFXType</Value>
</Value>
<Value name="14">
<Value>BDEFValidator</Value>
</Value>
<Value name="15">
<Value>BDEFHiddenName</Value>
</Value>
<Value name="16">
<Value>BDEFRegex</Value>
</Value>
<Value name="17">
<Value>BDEFRegexText</Value>
</Value>
<Value name="18">
<Value>AllowBlank</Value>
</Value>
<Value name="19">
<Value>AutoShow</Value>
</Value>
<Value name="20">
<Value>Code</Value>
</Value>
<Value name="21">
<Value>Desc</Value>
</Value>
<Value name="22">
<Value>Editable</Value>
</Value>
<Value name="23">
<Value>Handler</Value>
</Value>
<Value name="24">
<Value>Hidden</Value>
</Value>
<Value name="25">
<Value>HiddenName</Value>
</Value>
<Value name="26">
<Value>IconCls</Value>
</Value>
<Value name="27">
<Value>ReadOnly</Value>
</Value>
<Value name="28">
<Value>Regex</Value>
</Value>
<Value name="29">
<Value>RegexText</Value>
</Value>
<Value name="30">
<Value>ToolTip</Value>
</Value>
<Value name="31">
<Value>ToolTipType</Value>
</Value>
<Value name="32">
<Value>Type</Value>
</Value>
<Value name="33">
<Value>Validator</Value>
</Value>
<Value name="34">
<Value>XType</Value>
</Value>
<Value name="35">
<Value>ValueGet</Value>
</Value>
<Value name="36">
<Value>ValueSet</Value>
</Value>
<Value name="37">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildExtExecItem")</DataLocation>
<DefaultData>BDPExtExecItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPExecutablesC("ChildExtExecItem")</IdLocation>
<IndexLocation>^User.BDPExtExecItemI</IndexLocation>
<StreamLocation>^User.BDPExtExecItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

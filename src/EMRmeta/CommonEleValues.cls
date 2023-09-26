/// Desc:      公用元素表
/// Creator:   yejian
/// CreateDate:2014-4-15
Class EMRmeta.CommonEleValues Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 数据元标示符索引
Index IdxCode On Code;

Index IdxTemplateSection On (TemplateCode, SectionCode);

/// 数据元类型
Property ElemType As %String(MAXLEN = 50, TRUNCATE = 1);

/// 数据值域标示符
Property Code As %String(MAXLEN = 50, TRUNCATE = 1);

/// 值含义
Property DisplayName As %String(MAXLEN = 500, TRUNCATE = 1);

/// 说明
Property Description As %String(MAXLEN = 100, TRUNCATE = 1);

/// 绑定类型
Property BindType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 绑定值
Property BindCode As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 是否同步
Property Synch As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否为空
Property AllowNull As %String(MAXLEN = 100, TRUNCATE = 1);

/// 校验信息
Property ValidateMsg As %String(MAXLEN = 100, TRUNCATE = 1);

/// 正则表达式
Property RegExp As %String(MAXLEN = 100, TRUNCATE = 1);

/// 最长值
Property MaxLength As %String(MAXLEN = 100, TRUNCATE = 1);

/// 保密级别
Property ConfidentialityCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否只读
Property ReadOnly As %String(MAXLEN = 100, TRUNCATE = 1);

/// tabIndex
Property TabIndex As %String(MAXLEN = 100, TRUNCATE = 1);

/// 固定结构
Property FixedStructs As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否可见
Property Visible As %String(MAXLEN = 100, TRUNCATE = 1);

/// 动态字段，主要用于解决页眉中床位号、科室等可能改变的业务需求
Property DynamicField As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否包含日期
Property IncludeDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否包含时间
Property IncludeTime As %String(MAXLEN = 100, TRUNCATE = 1);

/// 日期格式
Property DateFormat As %String(MAXLEN = 100, TRUNCATE = 1);

/// 时间格式
Property TimeFormat As %String(MAXLEN = 100, TRUNCATE = 1);

/// 最小值
Property MinVal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 最大值
Property MaxVal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有最小值
Property HasMinVal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有最大值
Property HasMaxVal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 包含最小值
Property IncludeMin As %String(MAXLEN = 100, TRUNCATE = 1);

/// 包含最大值
Property IncludeMax As %String(MAXLEN = 100, TRUNCATE = 1);

/// 小数点位数
Property DecimalPlace As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备选项强制换行
Property WrapChoice As %String(MAXLEN = 100, TRUNCATE = 1);

/// 选择列表集
Property Choices As %String(MAXLEN = 3000, TRUNCATE = 1);

/// 字典类型
Property DictionaryType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标准字典Code
Property CodeSystem As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标准字典Name
Property CodeSystemName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 自定义字典名
Property CustDicClassName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 显示类型
Property DisplayType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 显示分格符
Property Separator As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果1列类型
Property FirstColType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果2列类型
Property SecondColType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果3列类型
Property ThirdColType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 允许使用非标准字典代码(I)
Property AllowCodeNull As %String(MAXLEN = 100, TRUNCATE = 1);

/// 允许使用非标准字典描述(I)
Property AllowValueNull As %String(MAXLEN = 100, TRUNCATE = 1);

/// 查询条件单元
Property AssociateItem As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否可编辑
Property AllowEdit As %String(MAXLEN = 100, TRUNCATE = 1);

/// 关联字典编码
Property LinkCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 关联显示类型
Property LinkDisplayType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 链接方式
Property LinkMethod As %String(MAXLEN = 100, TRUNCATE = 1);

/// 签名级别
Property SignatureLevel As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否显示未选中项
Property ShowUnChecked As %String(MAXLEN = 100, TRUNCATE = 1);

/// 未选中项前缀
Property UncheckedPrefix As %String(MAXLEN = 100, TRUNCATE = 1);

/// 选中项前缀
Property CheckedPrefix As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否逐项加前缀
Property OneByOneLink As %String(MAXLEN = 100, TRUNCATE = 1);

/// 章节维护模板编码
Property TemplateCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 章节维护模板名称
Property TemplateName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 章节维护模板章节编码
Property SectionCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 章节维护模板章节名称
Property SectionName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 显示职称(签名者描述)
Property ShowSignerDescription As %String(MAXLEN = 100, TRUNCATE = 1);

/// 头像关联路径
Property HeaderImageCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 指纹关联路径
Property FingerImageCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 是否绑定图片
Property IsBindImage As %String(MAXLEN = 200, TRUNCATE = 1);

/// 静默同步
Property SilentSynch As %String(MAXLEN = 200, TRUNCATE = 1);

Storage Default
{
<Data name="CommonEleValuesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ElemType</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>DisplayName</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>BindType</Value>
</Value>
<Value name="7">
<Value>BindCode</Value>
</Value>
<Value name="8">
<Value>Synch</Value>
</Value>
<Value name="9">
<Value>AllowNull</Value>
</Value>
<Value name="10">
<Value>ValidateMsg</Value>
</Value>
<Value name="11">
<Value>RegExp</Value>
</Value>
<Value name="12">
<Value>MaxLength</Value>
</Value>
<Value name="13">
<Value>ConfidentialityCode</Value>
</Value>
<Value name="14">
<Value>ReadOnly</Value>
</Value>
<Value name="15">
<Value>TabIndex</Value>
</Value>
<Value name="16">
<Value>FixedStructs</Value>
</Value>
<Value name="17">
<Value>Visible</Value>
</Value>
<Value name="18">
<Value>DynamicField</Value>
</Value>
<Value name="19">
<Value>IncludeDate</Value>
</Value>
<Value name="20">
<Value>IncludeTime</Value>
</Value>
<Value name="21">
<Value>DateFormat</Value>
</Value>
<Value name="22">
<Value>TimeFormat</Value>
</Value>
<Value name="23">
<Value>MinVal</Value>
</Value>
<Value name="24">
<Value>MaxVal</Value>
</Value>
<Value name="25">
<Value>HasMinVal</Value>
</Value>
<Value name="26">
<Value>HasMaxVal</Value>
</Value>
<Value name="27">
<Value>IncludeMin</Value>
</Value>
<Value name="28">
<Value>IncludeMax</Value>
</Value>
<Value name="29">
<Value>DecimalPlace</Value>
</Value>
<Value name="30">
<Value>WrapChoice</Value>
</Value>
<Value name="31">
<Value>Choices</Value>
</Value>
<Value name="32">
<Value>DictionaryType</Value>
</Value>
<Value name="33">
<Value>CodeSystem</Value>
</Value>
<Value name="34">
<Value>CodeSystemName</Value>
</Value>
<Value name="35">
<Value>CustDicClassName</Value>
</Value>
<Value name="36">
<Value>DisplayType</Value>
</Value>
<Value name="37">
<Value>Separator</Value>
</Value>
<Value name="38">
<Value>FirstColType</Value>
</Value>
<Value name="39">
<Value>SecondColType</Value>
</Value>
<Value name="40">
<Value>ThirdColType</Value>
</Value>
<Value name="41">
<Value>AllowCodeNull</Value>
</Value>
<Value name="42">
<Value>AllowValueNull</Value>
</Value>
<Value name="43">
<Value>AssociateItem</Value>
</Value>
<Value name="44">
<Value>AllowEdit</Value>
</Value>
<Value name="45">
<Value>LinkCode</Value>
</Value>
<Value name="46">
<Value>LinkDisplayType</Value>
</Value>
<Value name="47">
<Value>LinkMethod</Value>
</Value>
<Value name="48">
<Value>SignatureLevel</Value>
</Value>
<Value name="49">
<Value>ShowUnChecked</Value>
</Value>
<Value name="50">
<Value>UncheckedPrefix</Value>
</Value>
<Value name="51">
<Value>CheckedPrefix</Value>
</Value>
<Value name="52">
<Value>OneByOneLink</Value>
</Value>
<Value name="53">
<Value>TemplateCode</Value>
</Value>
<Value name="54">
<Value>TemplateName</Value>
</Value>
<Value name="55">
<Value>SectionCode</Value>
</Value>
<Value name="56">
<Value>SectionName</Value>
</Value>
<Value name="57">
<Value>SignerDescription</Value>
</Value>
<Value name="58">
<Value>ShowSignerDescription</Value>
</Value>
<Value name="59">
<Value>HeaderImageCode</Value>
</Value>
<Value name="60">
<Value>FingerImageCode</Value>
</Value>
<Value name="61">
<Value>IsBindImage</Value>
</Value>
<Value name="62">
<Value>SilentSynch</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CommonEleValuesD</DataLocation>
<DefaultData>CommonEleValuesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.CommonEleValuesD</IdLocation>
<IndexLocation>^DHCEMRM.CommonEleValuesI</IndexLocation>
<StreamLocation>^DHCEMRM.CommonEleValuesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

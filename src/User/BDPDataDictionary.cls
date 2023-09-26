/// Function: 数据字典
/// Creator:  sunfengchao
/// CreateDate:2018-08-22
Class User.BDPDataDictionary Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_DataDictionary ]
{

///  代码
Property BDPDictionaryCode As %String(MAXLEN = "") [ Required, SqlColumnNumber = 2, SqlFieldName = BDP_DictionaryCode ];

///  描述
Property BDPDictionaryDesc As %String(MAXLEN = "") [ Required, SqlColumnNumber = 3, SqlFieldName = BDP_DictionaryDesc ];

/// 所属字典目录
Property BDPDictionaryDR As User.BDPDataDictionary [ SqlColumnNumber = 4, SqlFieldName = BDP_Dictionary_DR ];

/// 开始日期
Property BDPDictionaryDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = BDP_DictionaryDateFrom ];

/// 结束日期
Property BDPDictionaryDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = BDP_DictionaryDateTo ];

/// 预留字段1  如果是 字典 就存 字段含义 是字典数据就存value值
Property BDPDictionaryText1 As %String [ SqlColumnNumber = 7, SqlFieldName = BDP_DictionaryText1 ];

/// 预留字段2
Property BDPDictionaryText2 As %String [ SqlColumnNumber = 8, SqlFieldName = BDP_DictionaryText2 ];

/// 预留字段3
Property BDPDictionaryText3 As %String [ SqlColumnNumber = 9, SqlFieldName = BDP_DictionaryText3 ];

/// 预留字段4
Property BDPDictionaryText4 As %String [ SqlColumnNumber = 10, SqlFieldName = BDP_DictionaryText4 ];

/// 预留字段5
Property BDPDictionaryText5 As %String [ SqlColumnNumber = 11, SqlFieldName = BDP_DictionaryText5 ];

/// 预留字段6
Property BDPDictionaryText6 As %String [ SqlColumnNumber = 12, SqlFieldName = BDP_DictionaryText6 ];

/// 预留字段7
Property BDPDictionaryText7 As %String [ SqlColumnNumber = 13, SqlFieldName = BDP_DictionaryText7 ];

/// 预留字段8
Property BDPDictionaryText8 As %String [ SqlColumnNumber = 14, SqlFieldName = BDP_DictionaryText8 ];

/// 预留字段9
Property BDPDictionaryText9 As %String [ SqlColumnNumber = 15, SqlFieldName = BDP_DictionaryText9 ];

/// 预留字段10
Property BDPDictionaryText10 As %String [ SqlColumnNumber = 16, SqlFieldName = BDP_DictionaryText10 ];

/// 预留字段11
Property BDPDictionaryText11 As %String [ SqlColumnNumber = 17, SqlFieldName = BDP_DictionaryText11 ];

/// 预留字段12
Property BDPDictionaryText12 As %String [ SqlColumnNumber = 18, SqlFieldName = BDP_DictionaryText12 ];

/// 预留字段13
Property BDPDictionaryText13 As %String [ SqlColumnNumber = 19, SqlFieldName = BDP_DictionaryText13 ];

/// 预留字段14
Property BDPDictionaryText14 As %String [ SqlColumnNumber = 20, SqlFieldName = BDP_DictionaryText14 ];

/// 预留字段15
Property BDPDictionaryText15 As %String [ SqlColumnNumber = 21, SqlFieldName = BDP_DictionaryText15 ];

/// 预留字段16
Property BDPDictionaryText16 As %String [ SqlColumnNumber = 22, SqlFieldName = BDP_DictionaryText16 ];

/// 预留字段17
Property BDPDictionaryText17 As %String [ SqlColumnNumber = 23, SqlFieldName = BDP_DictionaryText17 ];

/// 预留字段18
Property BDPDictionaryText18 As %String [ SqlColumnNumber = 24, SqlFieldName = BDP_DictionaryText18 ];

/// 预留字段19
Property BDPDictionaryText19 As %String [ SqlColumnNumber = 25, SqlFieldName = BDP_DictionaryText19 ];

/// 预留字段20
Property BDPDictionaryText20 As %String [ SqlColumnNumber = 26, SqlFieldName = BDP_DictionaryText20 ];

/// 预留字段21
Property BDPDictionaryText21 As %String [ SqlColumnNumber = 27, SqlFieldName = BDP_DictionaryText21 ];

/// 预留字段22
Property BDPDictionaryText22 As %String [ SqlColumnNumber = 28, SqlFieldName = BDP_DictionaryText22 ];

/// 预留字段23
Property BDPDictionaryText23 As %String [ SqlColumnNumber = 29, SqlFieldName = BDP_DictionaryText23 ];

/// 预留字段24
Property BDPDictionaryText24 As %String [ SqlColumnNumber = 30, SqlFieldName = BDP_DictionaryText24 ];

/// 预留字段25
Property BDPDictionaryText25 As %String [ SqlColumnNumber = 31, SqlFieldName = BDP_DictionaryText25 ];

/// 目录指向
Property BDPParentMenuDr As User.BDPDataDictionary [ SqlColumnNumber = 32, SqlFieldName = BDP_ParentMenu_Dr ];

/// 自动生成的配置源
Property BDPExtMenuDr As User.BDPExecutables [ SqlColumnNumber = 33, SqlFieldName = BDP_ExtMenu_Dr ];

Index CodeI On BDPDictionaryCode;

Index DescI On BDPDictionaryDesc;

Index DicDRI On BDPDictionaryDR;

Index BDPParentMenuDrI On BDPParentMenuDr;

/// 对字典的代码 做索引
Index BDPDicCodeI On (BDPDictionaryDR, BDPDictionaryCode);

/// 对字典的描述 做索引
Index BDPDicDescI On (BDPDictionaryDR, BDPDictionaryDesc);

Storage Default
{
<Data name="BDPDataDictionaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDPDictionaryCode</Value>
</Value>
<Value name="3">
<Value>BDPDictionaryDesc</Value>
</Value>
<Value name="4">
<Value>BDPDictionaryDR</Value>
</Value>
<Value name="5">
<Value>BDPDictionaryDateFrom</Value>
</Value>
<Value name="6">
<Value>BDPDictionaryDateTo</Value>
</Value>
<Value name="7">
<Value>BDPDictionaryText1</Value>
</Value>
<Value name="8">
<Value>BDPDictionaryText2</Value>
</Value>
<Value name="9">
<Value>BDPDictionaryText3</Value>
</Value>
<Value name="10">
<Value>BDPDictionaryText4</Value>
</Value>
<Value name="11">
<Value>BDPDictionaryText5</Value>
</Value>
<Value name="12">
<Value>BDPDictionaryText6</Value>
</Value>
<Value name="13">
<Value>BDPDictionaryText7</Value>
</Value>
<Value name="14">
<Value>BDPDictionaryText8</Value>
</Value>
<Value name="15">
<Value>BDPDictionaryText9</Value>
</Value>
<Value name="16">
<Value>BDPDictionaryText10</Value>
</Value>
<Value name="17">
<Value>BDPDictionaryText11</Value>
</Value>
<Value name="18">
<Value>BDPDictionaryText12</Value>
</Value>
<Value name="19">
<Value>BDPDictionaryText13</Value>
</Value>
<Value name="20">
<Value>BDPDictionaryText14</Value>
</Value>
<Value name="21">
<Value>BDPDictionaryText15</Value>
</Value>
<Value name="22">
<Value>BDPDictionaryText16</Value>
</Value>
<Value name="23">
<Value>BDPDictionaryText17</Value>
</Value>
<Value name="24">
<Value>BDPDictionaryText18</Value>
</Value>
<Value name="25">
<Value>BDPDictionaryText19</Value>
</Value>
<Value name="26">
<Value>BDPDictionaryText20</Value>
</Value>
<Value name="27">
<Value>BDPDictionaryText21</Value>
</Value>
<Value name="28">
<Value>BDPDictionaryText22</Value>
</Value>
<Value name="29">
<Value>BDPDictionaryText23</Value>
</Value>
<Value name="30">
<Value>BDPDictionaryText24</Value>
</Value>
<Value name="31">
<Value>BDPDictionaryText25</Value>
</Value>
<Value name="32">
<Value>BDPParentMenuDr</Value>
</Value>
<Value name="33">
<Value>BDPExtMenuDr</Value>
</Value>
</Data>
<DataLocation>^User.BDPDataDictionaryD</DataLocation>
<DefaultData>BDPDataDictionaryDefaultData</DefaultData>
<IdLocation>^User.BDPDataDictionaryD</IdLocation>
<IndexLocation>^User.BDPDataDictionaryI</IndexLocation>
<StreamLocation>^User.BDPDataDictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// Function: 通用字典的字段配置信息
/// Creator:  sunfengchao
/// CreateDate:2018-09-06
Class User.BDPDictionaryConfig Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_DictionaryConfig ]
{

/// 通用字典的指向
Property BDPDictionaryDR As User.BDPDataDictionary [ SqlColumnNumber = 2, SqlFieldName = BDP_Dictionary_DR ];

/// 预留字段1 类型
Property BDPDictionaryText1Type As %String [ SqlColumnNumber = 3, SqlFieldName = BDP_DictionaryText1Type ];

/// 预留字段2 类型
Property BDPDictionaryText2Type As %String [ SqlColumnNumber = 4, SqlFieldName = BDP_DictionaryText2Type ];

/// 预留字段3 类型
Property BDPDictionaryText3Type As %String [ SqlColumnNumber = 5, SqlFieldName = BDP_DictionaryText3Type ];

/// 预留字段4 类型
Property BDPDictionaryText4Type As %String [ SqlColumnNumber = 6, SqlFieldName = BDP_DictionaryText4Type ];

/// 预留字段5 类型
Property BDPDictionaryText5Type As %String [ SqlColumnNumber = 7, SqlFieldName = BDP_DictionaryText5Type ];

/// 预留字段6 类型 
Property BDPDictionaryText6Type As %String [ SqlColumnNumber = 8, SqlFieldName = BDP_DictionaryText6Type ];

/// 预留字段7 类型 
Property BDPDictionaryText7Type As %String [ SqlColumnNumber = 9, SqlFieldName = BDP_DictionaryText7Type ];

/// 预留字段8 类型 
Property BDPDictionaryText8Type As %String [ SqlColumnNumber = 10, SqlFieldName = BDP_DictionaryText8Type ];

/// 预留字段9 类型 
Property BDPDictionaryText9Type As %String [ SqlColumnNumber = 11, SqlFieldName = BDP_DictionaryText9Type ];

/// 预留字段10 类型 
Property BDPDictionaryText10Type As %String [ SqlColumnNumber = 12, SqlFieldName = BDP_DictionaryText10Type ];

/// 预留字段11 类型
Property BDPDictionaryText11Type As %String [ SqlColumnNumber = 13, SqlFieldName = BDP_DictionaryText11Type ];

/// 预留字段12 类型 
Property BDPDictionaryText12Type As %String [ SqlColumnNumber = 14, SqlFieldName = BDP_DictionaryText12Type ];

/// 预留字段13 类型 
Property BDPDictionaryText13Type As %String [ SqlColumnNumber = 15, SqlFieldName = BDP_DictionaryText13Type ];

/// 预留字段14 类型
Property BDPDictionaryText14Type As %String [ SqlColumnNumber = 16, SqlFieldName = BDP_DictionaryText14Type ];

/// 预留字段15 类型
Property BDPDictionaryText15Type As %String [ SqlColumnNumber = 17, SqlFieldName = BDP_DictionaryText15Type ];

/// 预留字段16 类型 
Property BDPDictionaryText16Type As %String [ SqlColumnNumber = 18, SqlFieldName = BDP_DictionaryText16Type ];

/// 预留字段17 类型 
Property BDPDictionaryText17Type As %String [ SqlColumnNumber = 19, SqlFieldName = BDP_DictionaryText17Type ];

/// 预留字段18 类型 
Property BDPDictionaryText18Type As %String [ SqlColumnNumber = 20, SqlFieldName = BDP_DictionaryText18Type ];

/// 预留字段19 类型 
Property BDPDictionaryText19Type As %String [ SqlColumnNumber = 21, SqlFieldName = BDP_DictionaryText19Type ];

/// 预留字段20 类型 
Property BDPDictionaryText20Type As %String [ SqlColumnNumber = 22, SqlFieldName = BDP_DictionaryText20Type ];

/// 预留字段21 类型  
Property BDPDictionaryText21Type As %String [ SqlColumnNumber = 23, SqlFieldName = BDP_DictionaryText21Type ];

/// 预留字段22 类型 
Property BDPDictionaryText22Type As %String [ SqlColumnNumber = 24, SqlFieldName = BDP_DictionaryText22Type ];

/// 预留字段23 类型
Property BDPDictionaryText23Type As %String [ SqlColumnNumber = 25, SqlFieldName = BDP_DictionaryText23Type ];

/// 预留字段24 类型 
Property BDPDictionaryText24Type As %String [ SqlColumnNumber = 26, SqlFieldName = BDP_DictionaryText24Type ];

/// 预留字段25 类型
Property BDPDictionaryText25Type As %String [ SqlColumnNumber = 27, SqlFieldName = BDP_DictionaryText25Type ];

/// 预留字段 1 指向表 
Property BDPDictionaryText1DRCode As %String [ SqlColumnNumber = 29, SqlFieldName = BDP_DictionaryText1DRCode ];

/// 预留字段 2 指向表 
Property BDPDictionaryText2DRCode As %String [ SqlColumnNumber = 30, SqlFieldName = BDP_DictionaryText2DRCode ];

/// 预留字段3 指向表 
Property BDPDictionaryText3DRCode As %String [ SqlColumnNumber = 31, SqlFieldName = BDP_DictionaryText3DRCode ];

/// 预留字段 4 指向表 
Property BDPDictionaryText4DRCode As %String [ SqlColumnNumber = 32, SqlFieldName = BDP_DictionaryText4DRCode ];

/// 预留字段5 指向表 
Property BDPDictionaryText5DRCode As %String [ SqlColumnNumber = 33, SqlFieldName = BDP_DictionaryText5DRCode ];

/// 预留字段 6 指向表 
Property BDPDictionaryText6DRCode As %String [ SqlColumnNumber = 34, SqlFieldName = BDP_DictionaryText6DRCode ];

/// 预留字段7 指向表 
Property BDPDictionaryText7DRCode As %String [ SqlColumnNumber = 35, SqlFieldName = BDP_DictionaryText7DRCode ];

/// 预留字段8 指向表 
Property BDPDictionaryText8DRCode As %String [ SqlColumnNumber = 36, SqlFieldName = BDP_DictionaryText8DRCode ];

/// 预留字段9 指向表 
Property BDPDictionaryText9DRCode As %String [ SqlColumnNumber = 37, SqlFieldName = BDP_DictionaryText9DRCode ];

/// 预留字段10  指向表 
Property BDPDictionaryText10DRCode As %String [ SqlColumnNumber = 38, SqlFieldName = BDP_DictionaryText10DRCode ];

/// 预留字段11 指向表 
Property BDPDictionaryText11DRCode As %String [ SqlColumnNumber = 39, SqlFieldName = BDP_DictionaryText11DRCode ];

/// 预留字段12 指向表 
Property BDPDictionaryText12DRCode As %String [ SqlColumnNumber = 40, SqlFieldName = BDP_DictionaryText12DRCode ];

/// 预留字段13 指向表 
Property BDPDictionaryText13DRCode As %String [ SqlColumnNumber = 41, SqlFieldName = BDP_DictionaryText13DRCode ];

/// 预留字段 14 指向表 
Property BDPDictionaryText14DRCode As %String [ SqlColumnNumber = 42, SqlFieldName = BDP_DictionaryText14DRCode ];

/// 预留字段15 指向表 
Property BDPDictionaryText15DRCode As %String [ SqlColumnNumber = 43, SqlFieldName = BDP_DictionaryText15DRCode ];

/// 预留字段16 指向表 
Property BDPDictionaryText16DRCode As %String [ SqlColumnNumber = 44, SqlFieldName = BDP_DictionaryText16DRCode ];

/// 预留字段17 指向表 
Property BDPDictionaryText17DRCode As %String [ SqlColumnNumber = 45, SqlFieldName = BDP_DictionaryText17DRCode ];

/// 预留字段18  指向表 
Property BDPDictionaryText18DRCode As %String [ SqlColumnNumber = 46, SqlFieldName = BDP_DictionaryText18DRCode ];

/// 预留字段19 指向表 
Property BDPDictionaryText19DRCode As %String [ SqlColumnNumber = 47, SqlFieldName = BDP_DictionaryText19DRCode ];

/// 预留字段20 指向表 
Property BDPDictionaryText20DRCode As %String [ SqlColumnNumber = 48, SqlFieldName = BDP_DictionaryText20DRCode ];

/// 预留字段21 指向表 
Property BDPDictionaryText21DRCode As %String [ SqlColumnNumber = 49, SqlFieldName = BDP_DictionaryText21DRCode ];

/// 预留字段22 指向表 
Property BDPDictionaryText22DRCode As %String [ SqlColumnNumber = 50, SqlFieldName = BDP_DictionaryText22DRCode ];

/// 预留字段23  指向表 
Property BDPDictionaryText23DRCode As %String [ SqlColumnNumber = 51, SqlFieldName = BDP_DictionaryText23DRCode ];

/// 预留字段24 指向表 
Property BDPDictionaryText24DRCode As %String [ SqlColumnNumber = 52, SqlFieldName = BDP_DictionaryText24DRCode ];

/// 预留字段25 指向表 
Property BDPDictionaryText25DRCode As %String [ SqlColumnNumber = 53, SqlFieldName = BDP_DictionaryText25DRCode ];

/// 对 字典的索引
Index DictionaryDRIndex On BDPDictionaryDR;

Storage Default
{
<Data name="BDPDictionaryConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDPDictionaryDR</Value>
</Value>
<Value name="3">
<Value>BDPDictionaryText1Type</Value>
</Value>
<Value name="4">
<Value>BDPDictionaryText2Type</Value>
</Value>
<Value name="5">
<Value>BDPDictionaryText3Type</Value>
</Value>
<Value name="6">
<Value>BDPDictionaryText4Type</Value>
</Value>
<Value name="7">
<Value>BDPDictionaryText5Type</Value>
</Value>
<Value name="8">
<Value>BDPDictionaryText6Type</Value>
</Value>
<Value name="9">
<Value>BDPDictionaryText7Type</Value>
</Value>
<Value name="10">
<Value>BDPDictionaryText8Type</Value>
</Value>
<Value name="11">
<Value>BDPDictionaryText9Type</Value>
</Value>
<Value name="12">
<Value>BDPDictionaryText10Type</Value>
</Value>
<Value name="13">
<Value>BDPDictionaryText11Type</Value>
</Value>
<Value name="14">
<Value>BDPDictionaryText12Type</Value>
</Value>
<Value name="15">
<Value>BDPDictionaryText13Type</Value>
</Value>
<Value name="16">
<Value>BDPDictionaryText14Type</Value>
</Value>
<Value name="17">
<Value>BDPDictionaryText15Type</Value>
</Value>
<Value name="18">
<Value>BDPDictionaryText16Type</Value>
</Value>
<Value name="19">
<Value>BDPDictionaryText17Type</Value>
</Value>
<Value name="20">
<Value>BDPDictionaryText18Type</Value>
</Value>
<Value name="21">
<Value>BDPDictionaryText19Type</Value>
</Value>
<Value name="22">
<Value>BDPDictionaryText20Type</Value>
</Value>
<Value name="23">
<Value>BDPDictionaryText21Type</Value>
</Value>
<Value name="24">
<Value>BDPDictionaryText22Type</Value>
</Value>
<Value name="25">
<Value>BDPDictionaryText23Type</Value>
</Value>
<Value name="26">
<Value>BDPDictionaryText24Type</Value>
</Value>
<Value name="27">
<Value>BDPDictionaryText25Type</Value>
</Value>
<Value name="28">
<Value>BDPDictionaryText1DRCode</Value>
</Value>
<Value name="29">
<Value>BDPDictionaryText2DRCode</Value>
</Value>
<Value name="30">
<Value>BDPDictionaryText3DRCode</Value>
</Value>
<Value name="31">
<Value>BDPDictionaryText4DRCode</Value>
</Value>
<Value name="32">
<Value>BDPDictionaryText5DRCode</Value>
</Value>
<Value name="33">
<Value>BDPDictionaryText6DRCode</Value>
</Value>
<Value name="34">
<Value>BDPDictionaryText7DRCode</Value>
</Value>
<Value name="35">
<Value>BDPDictionaryText8DRCode</Value>
</Value>
<Value name="36">
<Value>BDPDictionaryText9DRCode</Value>
</Value>
<Value name="37">
<Value>BDPDictionaryText10DRCode</Value>
</Value>
<Value name="38">
<Value>BDPDictionaryText11DRCode</Value>
</Value>
<Value name="39">
<Value>BDPDictionaryText12DRCode</Value>
</Value>
<Value name="40">
<Value>BDPDictionaryText13DRCode</Value>
</Value>
<Value name="41">
<Value>BDPDictionaryText14DRCode</Value>
</Value>
<Value name="42">
<Value>BDPDictionaryText15DRCode</Value>
</Value>
<Value name="43">
<Value>BDPDictionaryText16DRCode</Value>
</Value>
<Value name="44">
<Value>BDPDictionaryText17DRCode</Value>
</Value>
<Value name="45">
<Value>BDPDictionaryText18DRCode</Value>
</Value>
<Value name="46">
<Value>BDPDictionaryText19DRCode</Value>
</Value>
<Value name="47">
<Value>BDPDictionaryText20DRCode</Value>
</Value>
<Value name="48">
<Value>BDPDictionaryText21DRCode</Value>
</Value>
<Value name="49">
<Value>BDPDictionaryText22DRCode</Value>
</Value>
<Value name="50">
<Value>BDPDictionaryText23DRCode</Value>
</Value>
<Value name="51">
<Value>BDPDictionaryText24DRCode</Value>
</Value>
<Value name="52">
<Value>BDPDictionaryText25DRCode</Value>
</Value>
</Data>
<DataLocation>^User.BDPDictionaryConfigD</DataLocation>
<DefaultData>BDPDictionaryConfigDefaultData</DefaultData>
<IdLocation>^User.BDPDictionaryConfigD</IdLocation>
<IndexLocation>^User.BDPDictionaryConfigI</IndexLocation>
<StreamLocation>^User.BDPDictionaryConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

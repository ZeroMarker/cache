/// 手术诊断对照
Class User.INSUOPERContrast Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

Parameter EXTENTSIZE = 250;

/// 1 手术Dr	INOPT_Oper_Dr
Property INOPTOperDr As %Integer(CAPTION = "手术诊断表Dr") [ SqlColumnNumber = 2 ];

/// 2 手术代码	INOPT_Oper_Code
Property INOPTOperCode As %String(CAPTION = "手术代码", MAXLEN = 30) [ SqlColumnNumber = 3 ];

/// 3 手术名称	INOPT_Oper_Desc
Property INOPTOperDesc As %String(CAPTION = "手术名称", MAXLEN = 100) [ SqlColumnNumber = 4 ];

/// 4 医保手术表Dr	INOPT_Insu_Dr
Property INOPTInsuDr As CT.INSU.MI.OPRNOPRTLIST(CAPTION = "医保手术表Dr") [ SqlColumnNumber = 5 ];

/// 5 医保手术代码	INOPT_InsuCode
Property INOPTInsuCode As %String(CAPTION = "医保代码", MAXLEN = 30) [ SqlColumnNumber = 6 ];

/// 6 医保手术名称	INOPT_InsuDesc
Property INOPTInsuDesc As %String(CAPTION = "医保名称", MAXLEN = 100) [ SqlColumnNumber = 7 ];

/// 7 数据来源	INOPT_Source
Property INOPTSource As %String(CAPTION = "数据来源", MAXLEN = 30) [ SqlColumnNumber = 8 ];

/// 8 字典类型	INOPT_DicType
Property INOPTDicType As %String(CAPTION = "字典类型", MAXLEN = 30) [ SqlColumnNumber = 9 ];

/// 9 生效日期	INOPT_ActiveDate
Property INOPTActiveDate As %Library.Date(CAPTION = "生效日期") [ SqlColumnNumber = 10 ];

/// 10 失效日期	INOPT_ExpiryDate
Property INOPTExpiryDate As %Library.Date(CAPTION = "失效日期") [ SqlColumnNumber = 11 ];

/// 11 对照人	INOPT_User_Dr
Property INOPTUserDr As User.SSUser(CAPTION = "对照人") [ SqlColumnNumber = 12 ];

/// 12 对照日期	INOPT_Date
Property INOPTDate As %Library.Date(CAPTION = "对照日期") [ SqlColumnNumber = 13 ];

/// 13 对照时间	INOPT_Time
Property INOPTTime As %Library.Time(CAPTION = "对照时间") [ SqlColumnNumber = 14 ];

/// 14 添加IP	INOPT_ADDIP
Property INOPTADDIP As %String(CAPTION = "添加IP", MAXLEN = 30) [ SqlColumnNumber = 15 ];

/// 15 唯一标识	INOPT_Unique
Property INOPTUnique As %String(CAPTION = "唯一标识", MAXLEN = 30) [ SqlColumnNumber = 16 ];

/// 16 备注	INOPT_Memo
Property INOPTMemo As %String(CAPTION = "备注", MAXLEN = 300) [ SqlColumnNumber = 17 ];

/// 17 数据来源版本 INOPT_SoucVer 20220215 
Property INOPTSoucVer As %String(CAPTION = "数据来源版本", MAXLEN = 30) [ SqlColumnNumber = 18 ];

/// 18 预留串3	INOPT_XString03
Property INOPTXString03 As %String(CAPTION = "预留串3", MAXLEN = 30) [ SqlColumnNumber = 19 ];

/// 19 预留串4	INOPT_XString04
Property INOPTXString04 As %String(CAPTION = "预留串4", MAXLEN = 30) [ SqlColumnNumber = 20 ];

/// 20 预留串5	INOPT_XString05
Property INOPTXString05 As %String(CAPTION = "预留串5", MAXLEN = 30) [ SqlColumnNumber = 21 ];

/// 21 院区ID	INOPT_HospDr
Property INOPTHospDr As %String(CAPTION = "院区ID", MAXLEN = 30) [ SqlColumnNumber = 22 ];

/// 手术指针索引
Index IdxINOPTOperDr On INOPTOperDr As Exact;

/// 手术代码索引
Index IdxINOPTOperCode On INOPTOperCode As Exact;

/// 医保手术指针索引
Index IdxINOPTInsuDr On INOPTInsuDr As Exact;

/// 数据来源索引
Index IdxINOPTSource On INOPTSource As Exact;

/// 生效日期索引
Index IdxINOPTActiveDate On INOPTActiveDate As Exact;

/// 院区索引
Index IdxINOPTHospDr On INOPTHospDr As Exact;

Storage Default
{
<Data name="INSUOPERContrastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>INOPTOperDr</Value>
</Value>
<Value name="3">
<Value>INOPTOperCode</Value>
</Value>
<Value name="4">
<Value>INOPTOperDesc</Value>
</Value>
<Value name="5">
<Value>INOPTInsuDr</Value>
</Value>
<Value name="6">
<Value>INOPTInsuCode</Value>
</Value>
<Value name="7">
<Value>INOPTInsuDesc</Value>
</Value>
<Value name="8">
<Value>INOPTSource</Value>
</Value>
<Value name="9">
<Value>INOPTDicType</Value>
</Value>
<Value name="10">
<Value>INOPTActiveDate</Value>
</Value>
<Value name="11">
<Value>INOPTExpiryDate</Value>
</Value>
<Value name="12">
<Value>INOPTUserDr</Value>
</Value>
<Value name="13">
<Value>INOPTDate</Value>
</Value>
<Value name="14">
<Value>INOPTTime</Value>
</Value>
<Value name="15">
<Value>INOPTADDIP</Value>
</Value>
<Value name="16">
<Value>INOPTUnique</Value>
</Value>
<Value name="17">
<Value>INOPTMemo</Value>
</Value>
<Value name="18">
<Value>INOPTSoucVer</Value>
</Value>
<Value name="19">
<Value>INOPTXString03</Value>
</Value>
<Value name="20">
<Value>INOPTXString04</Value>
</Value>
<Value name="21">
<Value>INOPTXString05</Value>
</Value>
<Value name="22">
<Value>INOPTHospDr</Value>
</Value>
</Data>
<DataLocation>^User.INSUOPERContrastD</DataLocation>
<DefaultData>INSUOPERContrastDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.INSUOPERContrastD</IdLocation>
<IndexLocation>^User.INSUOPERContrastI</IndexLocation>
<StreamLocation>^User.INSUOPERContrastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

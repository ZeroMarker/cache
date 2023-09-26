/// 
Class User.INSUUploadInfoCon Extends (%Persistent, %XML.Adaptor) [ Not ProcedureBlock ]
{

// 医保类型

Property InsuType As %Library.String;

// 业务类型 

Property BSYType As %Library.String;

// 模版字段类型

Property PropType As %Library.String(DISPLAYLIST = ",STRING,LIST", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",STRING,LIST");

// 父节点Rowid

Property ParRowid As %String;

// 模版字段代码

Property tplCode As %Library.String;

// 模版字段名称

Property tplDesc As %Library.String;

// 对应对象代码

Property ConCode As %Library.String(MAXLEN = 500);

// 对应对象描述

Property ConDesc As %Library.String;

// 扩展字段

Property ExtStr1 As %Library.String;

// 扩展字段

Property ExtStr2 As %Library.String;

// 扩展字段

Property ExtStr3 As %Library.String;

// 扩展字段

Property ExtStr4 As %Library.String;

// 扩展字段

Property ExtStr5 As %Library.String;

// 院区

Property Hospital As %Library.String;

Index IDataKey On (Hospital As Exact, InsuType As Exact, BSYType As Exact, tplCode As Exact);

Index IndexOfUnique On (Hospital As Exact, InsuType As Exact, BSYType As Exact, ParRowid As Exact, tplCode As Exact);

Index IndexOfSub On (Hospital As Exact, InsuType As Exact, BSYType As Exact, ParRowid As Exact);

Index IndexOfParId On ParRowid As AlphaUp;

Storage Default
{
<Data name="INSUUploadInfoConDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InsuType</Value>
</Value>
<Value name="3">
<Value>BSYType</Value>
</Value>
<Value name="4">
<Value>PropType</Value>
</Value>
<Value name="5">
<Value>ParRowid</Value>
</Value>
<Value name="6">
<Value>tplCode</Value>
</Value>
<Value name="7">
<Value>tplDesc</Value>
</Value>
<Value name="8">
<Value>ConCode</Value>
</Value>
<Value name="9">
<Value>ConDesc</Value>
</Value>
<Value name="10">
<Value>ExtStr1</Value>
</Value>
<Value name="11">
<Value>ExtStr2</Value>
</Value>
<Value name="12">
<Value>ExtStr3</Value>
</Value>
<Value name="13">
<Value>ExtStr4</Value>
</Value>
<Value name="14">
<Value>ExtStr5</Value>
</Value>
<Value name="15">
<Value>Hospital</Value>
</Value>
</Data>
<DataLocation>^User.INSUUploadInfoConD</DataLocation>
<DefaultData>INSUUploadInfoConDefaultData</DefaultData>
<IdLocation>^User.INSUUploadInfoConD</IdLocation>
<IndexLocation>^User.INSUUploadInfoConI</IndexLocation>
<StreamLocation>^User.INSUUploadInfoConS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// 代码表：trakcare的“科室” 与 病案室的“科室” 对照
Class EPRmeta.CodeTable.CTLoc Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// trakcare的 科室代码
Property LocCode As %String(TRUNCATE = 1);

/// trakcare的 科室描述
Property LocDesc As %String(TRUNCATE = 1);

/// 病案室的 科室代码
Property BALocCode As %String(TRUNCATE = 1);

/// 病案室的 科室描述
Property BALocDesc As %String(TRUNCATE = 1);

Index IdxLocCode On LocCode;

/// 由 科室代码 获取对应的 病案室的科室代码^描述
ClassMethod SelectBALocByLocCode(ALocCode As %String) As %String
{
 s Result = ""
 new CountID 
 new baloccode, balocdesc 
 
 &sql(SELECT Count(ID)
 Into :CountID
 FROM EPRmeta_CodeTable.CTLoc
 where LocCode = :ALocCode)
 
 if (CountID >0){
 	&sql(SELECT BALocCode, BALocDesc
 	Into :baloccode, :balocdesc
 	FROM EPRmeta_CodeTable.CTLoc
 	where LocCode = :ALocCode)
 	s Result=baloccode_"^"_balocdesc
 }

 QUIT Result
}

Storage Default
{
<Data name="CTLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BALocCode</Value>
</Value>
<Value name="3">
<Value>BALocDesc</Value>
</Value>
<Value name="4">
<Value>LocCode</Value>
</Value>
<Value name="5">
<Value>LocDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.CodeTable.CTLocD</DataLocation>
<DefaultData>CTLocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.CodeTable.CTLocD</IdLocation>
<IndexLocation>^DHCEPRM.CodeTable.CTLocI</IndexLocation>
<StreamLocation>^DHCEPRM.CodeTable.CTLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

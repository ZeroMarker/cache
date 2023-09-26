Class User.DHCNURMGQualItm Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property QualTitle As %String(TRUNCATE = 1);

Property QualCode As %String(TRUNCATE = 1);

Property QualPoint As %String(TRUNCATE = 1);

Property QualPercent As %String(TRUNCATE = 1);

Property QualItm As %GlobalCharacterStream(LOCATION = "^User.DHCNURMGQualItmS");

Property QualPass As %String;

Index Code On QualCode;

ClassMethod save(itm As %String, id As %String) As %String
{
   s a=##class(User.DHCNURMGQualItm).%OpenId(id)
   d a.QualItm.Write(itm)
   d a.%Save()
}

Method SaveStream(ByRef Itm As User.DHCNURMGQualItm, str As %String) As %String
{
 //##class(
    
	d Itm.QualItm.Write(str)
	q 0
}

ClassMethod GetQualStr(code) As %String
{
   
    s code=" "_code
    s rw=""   s rw=$O(^User.DHCNURMGQualItmI("Code",code,rw)) 
    q rw
}

ClassMethod GetQualItm(code1, Qual) As %String
{
  //##class(User.DHCNURMGQualItm).GetQualItm()
   s ret=""
     s code1=$ZConvert(code1,"U")
   s code=" "_code1  f  s code=$O(^User.DHCNURMGQualItmI("Code",code)) q:code=""  d
    .b
    .s rw="" f  s rw=$O(^User.DHCNURMGQualItmI("Code",code,rw)) q:rw=""  d
    ..s b=^User.DHCNURMGQualItmD(rw)
    ..b
    ..s title=$List(b,4)
    ..s percent=$ListGet(b,6)   //权重
    ..s Qual(rw)=title_"|"_percent
    b //dd
    q ""
}

ClassMethod GetQualCode(code1) As %String
{
  //s a=##class(User.DHCNURMGQualItm).GetQualCode()
     s code1=$ZConvert(code1,"U")
     s ret=""
     s id=" "_code1
	 s ln=$L(" "_code1)
	 s im=" "_code1
     s flag=0
   s code=" "_code1  f  s code=$O(^User.DHCNURMGQualItmI("Code",code)) q:(code="")!(flag=1)  d
	.if $E(code,0,ln)'=im s flag=1
    .s rw="" f  s rw=$O(^User.DHCNURMGQualItmI("Code",code,rw)) q:rw=""!(flag=1)  d
    ..s b=^User.DHCNURMGQualItmD(rw)
    ..s title=$List(b,4)
    ..s percent=$ListGet(b,6)   //权重
    ..s ret=ret_rw_"|"_title_"^"
    q ret
}

Storage Default
{
<Data name="DHCNURMGQualItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QualItm</Value>
</Value>
<Value name="3">
<Value>QualPoint</Value>
</Value>
<Value name="4">
<Value>QualTitle</Value>
</Value>
<Value name="5">
<Value>QualCode</Value>
</Value>
<Value name="6">
<Value>QualPercent</Value>
</Value>
<Value name="7">
<Value>QualPass</Value>
</Value>
</Data>
<DataLocation>^User.DHCNURMGQualItmD</DataLocation>
<DefaultData>DHCNURMGQualItmDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNURMGQualItmD</IdLocation>
<IndexLocation>^User.DHCNURMGQualItmI</IndexLocation>
<StreamLocation>^User.DHCNURMGQualItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

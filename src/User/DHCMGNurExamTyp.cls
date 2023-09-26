Class User.DHCMGNurExamTyp Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//考核代码

Property ExamCode As %String(TRUNCATE = 1);

Property ExamDesc As %String(TRUNCATE = 1);

Property ExamType As %String(TRUNCATE = 1);

Index Type On ExamType;

ClassMethod getcodedr(typ) As %String
{
 //s a=##class(User.DHCMGNurExamTyp).getcodedr("")
   s codedr=""
   s rw="" f  s rw=$O(^User.DHCMGNurExamTypD(rw)) q:(rw="")!(codedr'="")  d
   .s a=^User.DHCMGNurExamTypD(rw)
   .s code=$List(a,2)
   .if code=typ s codedr=rw
   q codedr
}

ClassMethod GetExamCode(parr) As %String
{
	//w ##class(User.DHCMGNurExamTyp).GetExamCode("TE")
	//w ##class(User.DHCMGNurExamTyp).GetExamCode("QUAL")
	s cod=$P(parr,"^",1)
	s typ=$P(parr,"^",2)
	s ret=""
	s rw="" f  s rw=$O(^User.DHCMGNurExamTypD(rw)) q:(rw="")  d
	.s a=^User.DHCMGNurExamTypD(rw)
	.s code=$List(a,2)
	.q:(cod'="")&(code'[cod)
	.s type=$ListGet(a,4)
	.q:(typ'="")&(type'=typ)
	.s desc=$List(a,3)
	.s ret=ret_rw_"|"_desc_"^"
	q ret
}

ClassMethod Save(Parr As %String) As %String
{
	//w ##class(User.DHCMGNurExamTyp).Save("20^QUAL25^综合质量评价结果^OP")
	s id=$P(Parr,"^",1)
	s code=$P(Parr,"^",2)
	s desc=$P(Parr,"^",3)
	s typ=$P(Parr,"^",4)
	s ret=..getcodedr(code)
	q:(id="")&(ret'="") 0
	if id'="" s a=##class(User.DHCMGNurExamTyp).%OpenId(id)
	e  s a=##class(User.DHCMGNurExamTyp).%New()
	s a.ExamCode=code
	s a.ExamDesc=desc
	s a.ExamType=typ
	d a.%Save()
	q 0
}

/// 保存质控的类型(病房,门诊,其它(ICU,急诊,手术室,导管室))
ClassMethod GetExamTyp(code) As %String
{
	//w ##class(User.DHCMGNurExamTyp).GetExamTyp("")
	s ret=""
	s Typ="W|病房^O|门诊^OP|手术室"
	s len=$L(Typ,"^")
	for i=1:1:len d
	.s curTyp=$P(Typ,"^",i)
	.s rw=$P(curTyp,"|",1)
	.q:(code'="")&(code'=rw)
	.s desc=$P(curTyp,"|",2)
	.s ret=ret_rw_"|"_desc_"^"
	q ret
}

Storage Default
{
<Data name="DHCMGNurExamTypDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExamCode</Value>
</Value>
<Value name="3">
<Value>ExamDesc</Value>
</Value>
<Value name="4">
<Value>ExamType</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurExamTypD</DataLocation>
<DefaultData>DHCMGNurExamTypDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurExamTypD</IdLocation>
<IndexLocation>^User.DHCMGNurExamTypI</IndexLocation>
<StreamLocation>^User.DHCMGNurExamTypS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

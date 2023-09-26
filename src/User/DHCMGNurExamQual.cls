Class User.DHCMGNurExamQual Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//护理质控数据总数/平均分/合格率

Property QualDep As %String(TRUNCATE = 1);

Property QualItm As User.DHCMGNurExamTyp;

Property QualStDate As %Library.Date(FORMAT = 1);

Property QualEndDate As %Library.Date(FORMAT = 1);

Property QualNum As %String(TRUNCATE = 1);

Property QualScore As %String(TRUNCATE = 1);

Property QualPercent As %String(TRUNCATE = 1);

Property QualRecUser As User.DHCMGPersons;

Property QualRecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)} ];

Property QualRecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)} ];

Property QualMon As %String(TRUNCATE = 1);

Property QualNote As %String(TRUNCATE = 1);

Property QualCareNum As %String(TRUNCATE = 1);

Property QualDischNum As %String(TRUNCATE = 1);

Property QualDischScore As %String(TRUNCATE = 1);

Property QualDischPercent As %String(TRUNCATE = 1);

Property QualGroup As %String(TRUNCATE = 1);

Index DepDate On (QualGroup, QualDep, QualStDate);

Index DepMon On (QualGroup, QualDep, QualMon);

ClassMethod Save(parr As %String) As %String
{
	//id + "^" + dep + "^" + itm + "^" + stdate + "^" +enddate "^" + num  + "^" + score + "^" + percent + "^" + user + "^" + mon;
	//w ##class(User.DHCMGNurExamQual).Save()
	s id=$P(parr,"^",1)
	s dep=$P(parr,"^",2)
	s itm=$P(parr,"^",3)
	s stdate=$P(parr,"^",4)
	s enddate=$P(parr,"^",5)
	s num=$P(parr,"^",6)
	s score=$P(parr,"^",7)
	s percent=$P(parr,"^",8)
	s user=$P(parr,"^",9)
	s mon=$P(parr,"^",10)
	s carenum=$P(parr,"^",11)
	s dischnum=$P(parr,"^",12)
	s dischscore=$P(parr,"^",13)
	s dischpercent=$P(parr,"^",14)
	s group=$P(parr,"^",15)
	
	if id'="" s a=##class(User.DHCMGNurExamQual).%OpenId(id)
	e  d
	.s qualid=..IfExistItm(dep_"^"_mon_"^"_group_"^"_itm)
	.i qualid'="" s a=##class(User.DHCMGNurExamQual).%OpenId(qualid)
	.e  s a=##class(User.DHCMGNurExamQual).%New()
	s a.QualDep=dep
	s a.QualItm=##class(User.DHCMGNurExamTyp).%OpenId(itm)
	s a.QualStDate=$ZDH(stdate,3)
	s a.QualEndDate=$ZDH(enddate,3) 
	s a.QualNum=num
	s a.QualScore=score
	s a.QualPercent=percent
	s a.QualRecUser=##class(User.DHCMGPersons).%OpenId(user)
	s a.QualRecDate=+$h
	s a.QualRecTime=$P($h,",",2)
	s a.QualMon=mon
	s a.QualCareNum=carenum
	s a.QualDischNum=dischnum
	s a.QualDischScore=dischscore
	s a.QualDischPercent=dischpercent
	s a.QualGroup=group
	d a.%Save()
	q 0
}

ClassMethod Delete(id As %String) As %String
{
	d ##class(User.DHCMGNurExamQual).%DeleteId(id)
	q 0
}

ClassMethod IfExistItm(parr As %String) As %String
{
	//w ##class(User.DHCMGNurExamQual).IfExistItm("1^2010-7^1^1")
	s dep=$P(parr,"^",1)
	s mon=$P(parr,"^",2)
	s group=$P(parr,"^",3)
	s itm=$P(parr,"^",4)
	q:(dep="")!(mon="")!(group="") ""
	s ret=""
	s rw="" f  s rw=$O(^User.DHCMGNurExamQualI("DepMon"," "_group," "_dep," "_mon,rw)) q:(rw="")  d
	.s Qual=^User.DHCMGNurExamQualD(rw)
	.s QualItm=$List(Qual,3)
	.q:QualItm=""
	.b //000
	.q:QualItm'=itm
	.s ret=rw
	q ret
}

Storage Default
{
<Data name="DHCMGNurExamQualDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QualDep</Value>
</Value>
<Value name="3">
<Value>QualItm</Value>
</Value>
<Value name="4">
<Value>QualNum</Value>
</Value>
<Value name="5">
<Value>QualScore</Value>
</Value>
<Value name="6">
<Value>QualPercent</Value>
</Value>
<Value name="7">
<Value>QualRecDate</Value>
</Value>
<Value name="8">
<Value>QualRecTime</Value>
</Value>
<Value name="9">
<Value>QualRecUser</Value>
</Value>
<Value name="10">
<Value>QualEndDate</Value>
</Value>
<Value name="11">
<Value>QualStDate</Value>
</Value>
<Value name="12">
<Value>QualMon</Value>
</Value>
<Value name="13">
<Value>QualNote</Value>
</Value>
<Value name="14">
<Value>QualCareNum</Value>
</Value>
<Value name="15">
<Value>QualDischNum</Value>
</Value>
<Value name="16">
<Value>QualDischPercent</Value>
</Value>
<Value name="17">
<Value>QualDischScore</Value>
</Value>
<Value name="18">
<Value>QualGroup</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurExamQualD</DataLocation>
<DefaultData>DHCMGNurExamQualDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurExamQualD</IdLocation>
<IndexLocation>^User.DHCMGNurExamQualI</IndexLocation>
<StreamLocation>^User.DHCMGNurExamQualS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class User.DHCMGPerCyclePlan Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property plDep As %String(TRUNCATE = 1);

Property plPerson As User.DHCMGPersons;

Property plStdate As %Library.Date(FORMAT = 1);

Property plEndate As %Library.Date(FORMAT = 1);

Property mDate As %Library.Date(FORMAT = 1);

Property mtime As %Library.Time;

Property mUser As User.DHCMGPersons;

Property Plan As User.DHCMGTurnPlan;

Property mPos As %String(TRUNCATE = 1);

Index dep On plDep;

Index person On plPerson;

Index Plan On Plan;

Index planPer On (Plan, plPerson);

ClassMethod save(parr As %String) As %String
{
   // s parr="^1090^243|297|423|500|527|606|^2009-05-15^2009-07-15"
   
    s id=$P(parr,"^",1)
    s dep=$P(parr,"^",2)
    s per=$P(parr,"^",3)
    s stdate=$P(parr,"^",4)
    s edate=$P(parr,"^",5)
    s user=$P(parr,"^",6)
    s ln=$L(per,"|")
    for i=1:1:ln
    {
	    s perdr=$P(per,"|",i)
	    if perdr="" continue
	    if id'="" s a=##class(User.DHCMGPerCyclePlan).%OpenId(id)
	    e  s a=##class(User.DHCMGPerCyclePlan).%New()
	    s a.plDep=dep
	    s a.plPerson=##class(User.DHCMGPersons).%OpenId(perdr)
	    s a.plStdate=$ZDH(stdate,3)
	    s a.plEndate=$ZDH(edate,3)
	    s a.mDate=+$H
	    s a.mtime=$P($H,",",2)
	    s a.mUser=##class(User.DHCMGPersons).%OpenId(user)
	    d a.%Save()
	    b
    }
    q 0
}

ClassMethod delper(plan, per) As %String
{
 
   //删除计划
    s id=$O(^User.DHCMGPerCyclePlanI("planPer",plan,per,""))
	d ##class(User.DHCMGPerCyclePlan).%DeleteId(id)
	q 0
}

ClassMethod save1(parr As %String) As %String
{
   // s parr="^1090^243|297|423|500|527|606|^2009-05-15^2009-07-15"
   // s a=##class(User.DHCMGPerCyclePlan).save1()
   // s parr="^1209^1945^3552^1"
    s id=$P(parr,"^",1)
    s dep=$P(parr,"^",2)
    s per=$P(parr,"^",3)
    s user=$P(parr,"^",4)
    s plan=$P(parr,"^",5)
    s id=$O(^User.DHCMGPerCyclePlanI("planPer",plan,per,id))
    s pos=$P(parr,"^",6)
    b
    if id'="" s a=##class(User.DHCMGPerCyclePlan).%OpenId(id)
    e  s a=##class(User.DHCMGPerCyclePlan).%New()
    s a.plDep=dep
    s a.plPerson=##class(User.DHCMGPersons).%OpenId(per)
    s a.mDate=+$H
    s a.mtime=$P($H,",",2)
    s a.mUser=##class(User.DHCMGPersons).%OpenId(user)
    s a.Plan=##class(User.DHCMGTurnPlan).%OpenId(plan)
    s a.mPos=pos
    d a.%Save()
	    b
    q 0
}

ClassMethod DelPerson(id As %String) As %String
{
	d ##class(User.DHCMGPerCyclePlan).%DeleteId(id)
	q 0
}

ClassMethod DelPlan(plan) As %String
{
     s id="" f  s id=$O(^User.DHCMGPerCyclePlanI("Plan",plan,id)) q:id=""  d
     .d ##class(User.DHCMGPerCyclePlan).%DeleteId(id)
     q 0
}

ClassMethod SurePlan(plid, user) As %String
{
  //s a=##class(User.DHCMGPerCyclePlan).SurePlan(1,3552)
         s b=##class(User.DHCMGTurnPlan).%OpenId(plid)  
         s stdate=b.plStdate      
         s id="" f  s id=$O(^User.DHCMGPerCyclePlanI("Plan",plid,id)) q:id=""  d
         .s a=^User.DHCMGPerCyclePlanD(id)
         .s dep=$ListGet(a,2)
         .s per=$ListGet(a,3)
         .s pp=##class(User.DHCMGPersons).%OpenId(per)
         .s pp.PersonDepDR=dep
         .d pp.%Save()
  	     .s parr="^"_per_"^"_dep_"^"_$ZD(stdate,3)_"^^Y"
  	     .b
         .s aa=##class(User.DHCMGTrans).Save(parr)
         s b.plStatus="A"
		 s b.mDate=$P($H,",",1)
		 s b.mtime=$P($H,",",2)
		 s b.mUser=##class(User.DHCMGPersons).%OpenId(user)
		 d b.%Save()
         q 0
}

Storage Default
{
<Data name="DHCMGPerCyclePlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>plDep</Value>
</Value>
<Value name="3">
<Value>plPerson</Value>
</Value>
<Value name="4">
<Value>plStdate</Value>
</Value>
<Value name="5">
<Value>plEndate</Value>
</Value>
<Value name="6">
<Value>mDate</Value>
</Value>
<Value name="7">
<Value>mUser</Value>
</Value>
<Value name="8">
<Value>mtime</Value>
</Value>
<Value name="9">
<Value>Plan</Value>
</Value>
<Value name="10">
<Value>mPos</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPerCyclePlanD</DataLocation>
<DefaultData>DHCMGPerCyclePlanDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGPerCyclePlanD</IdLocation>
<IndexLocation>^User.DHCMGPerCyclePlanI</IndexLocation>
<StreamLocation>^User.DHCMGPerCyclePlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

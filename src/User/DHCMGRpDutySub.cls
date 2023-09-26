Class User.DHCMGRpDutySub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship DHCMGRpDutyParRef As User.DHCMGRpDuty [ Cardinality = parent, Inverse = ChildDHCMGRpDutySub, Required ];

Property SubPerDr As User.DHCMGPersons;

Property SubInitiVal As %String(TRUNCATE = 1);

/// 基值
Property SubFeriHours As %String(TRUNCATE = 1);

Property SubFeastHours As %String(TRUNCATE = 1);

Property SubFerSum As %String(TRUNCATE = 1);

Property SubFeaSum As %String(TRUNCATE = 1);

Property SubSum As %String(TRUNCATE = 1);

Property SubPerBill As User.DHCMGDepBillSub;

Index perbill On (SubPerDr, SubPerBill);

ClassMethod GetInitiVal(per) As %String
{
 //s a=##class(User.DHCMGRpDutySub).GetInitiVal()
       s parr=^User.DHCMGPersonsD(per)
       s worktime=$List(parr,40)
       if worktime'="" s workstyear=$ZD(worktime,3)
       e  s workstyear=$ZD(+$H,3)
       s curryear=$ZD(+$H,3)
       s years=(+curryear)-(+workstyear)
       b
       s a=##class(User.DHCMGCHolWorkAge).getval(years)
      q a
}

ClassMethod Save(par As User.DHCMGRpDuty, parr) As %String
{
	
  s ln=$P(parr,"^")
  f i=1:1:ln
  { //per_"|"_feahours_"|"_ferihours_"|"_feasum_"|"_ferisum_"|"_sum_"^"
    s itm=$P(parr,"^",i)
    if itm="" continue
    s per=$P(itm,$C(1))
    s feahours=$P(itm,$C(1),2)
    s ferihours=$P(itm,$C(1),3)
    s feasum=$P(itm,$C(1),4)
    s fersum=$P(itm,$C(1),5)
    s sum=$P(itm,$C(1),6)
    s rw=$P(itm,$C(1),7)
    s parstr=##class(User.DHCMGRpDuty).getparw(per,rw)
    s a=""
    if parstr'="" 
    {
	   s par=$P(parstr,"^"),chl=$P(parstr,"^",2)
	   s pchl=par_"||"_chl
	   s a=##class(User.DHCMGRpDutySub).%OpenId(pchl)
	} else{
    s a=##class(User.DHCMGRpDutySub).%New()
	}
    s a.DHCMGRpDutyParRef=par
    s a.SubPerDr=##class(User.DHCMGPersons).%OpenId(per)
    s a.SubFeriHours=ferihours
   // s a.SubInitiVal=..GetInitiVal(per)
    s a.SubFeastHours=feahours

    s a.SubFerSum=fersum

    s a.SubFeaSum=feasum
    s a.SubSum=sum
    s a.SubPerBill=##class(User.DHCMGDepBillSub).%OpenId(rw)
    d a.%Save()
  }
  q 0
}

Storage Default
{
<Data name="DHCMGRpDutySubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubPerDr</Value>
</Value>
<Value name="3">
<Value>SubFeaSum</Value>
</Value>
<Value name="4">
<Value>SubFeastHours</Value>
</Value>
<Value name="5">
<Value>SubFerSum</Value>
</Value>
<Value name="6">
<Value>SubFeriHours</Value>
</Value>
<Value name="7">
<Value>SubSum</Value>
</Value>
<Value name="8">
<Value>SubPerBill</Value>
</Value>
<Value name="9">
<Value>SubInitiVal</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDHCMGRpDutySub")</DataLocation>
<DefaultData>DHCMGRpDutySubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildDHCMGRpDutySub")</IdLocation>
<IndexLocation>^User.DHCMGRpDutySubI</IndexLocation>
<StreamLocation>^User.DHCMGRpDutySubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

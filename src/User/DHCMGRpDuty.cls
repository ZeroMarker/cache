Class User.DHCMGRpDuty Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property DutyRpDep As %String(TRUNCATE = 1);

Property DutyRpStDate As %Library.Date(FORMAT = 1);

Property DutyRpEndDate As %Library.Date(FORMAT = 1);

Property DutyRpFeahours As %String(TRUNCATE = 1);

Property DutyRpFeriHours As %String(TRUNCATE = 1);

Property DutyRpSum As %String(TRUNCATE = 1);

Property DutyRpFeaSum As %String(TRUNCATE = 1);

Property DutyRpFeriSum As %String(TRUNCATE = 1);

Property DutyRpFeaPrice As %String(TRUNCATE = 1);

Property DutyRpFeriPrice As %String(TRUNCATE = 1);

Property DutyRpMem As %String(TRUNCATE = 1);

Property DutyRpFlag As %Library.String(DISPLAYLIST = ",Submit,Audit,Refund", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",S,A,R");

Property DutyRecUser As User.DHCMGPersons;

Property DutyRecDate As %Library.Date(FORMAT = 1);

Property DutyRecTime As %Library.Time [ Required ];

Property DutyAudUser As User.DHCMGPersons;

Property DutyAudDate As %Library.Date(FORMAT = 1);

Property DutyAudTime As %Library.Time;

Relationship ChildDHCMGRpDutySub As User.DHCMGRpDutySub [ Cardinality = children, Inverse = DHCMGRpDutyParRef ];

Index DepDate On (DutyRpDep, DutyRecDate);

ClassMethod Save(parrm As %String) As %String
{
 /// s parrm="1082|20|10|543^244|10|24|21^298|3|24|22^424|6|3|23^501|8|5|24^528|8|2|25^607|9|9|26^694|3|10|27^695|8|5|28^696|6|9|29^697|5|5|30^698|7|5|31^699|4|8|32^700|6|3|33^720|4|2|34^726|4|23|35^727|4|4|36^728|6|5|37^729|4|4|38^931|8|7|39^1149|8|2|40^1168|8|3|41^1177|5|4|42^1237|7|6|43^1238|9|8|44^"
  //s parrm=^t(1)
  s ln=$l(parrm,"^")
  s feahours="",ferihours="",feasum="",ferisum="",sum=""
  s sfeahours="",sferihours="",sfeasum="",sferisum="",ssum=""
  s substr=""
  s ferprice="",feaprice=""
  s user="",dep="",stdate="",edate=""
  s id=""
  for i=1:1:ln
  {
    
    s itm=$P(parrm,"^",i)
    if itm="" continue
    if i=1
    {
	  s dep=$P(itm,$C(1),1) 
	  s user=$P(itm,$C(1),2) 
	}
	if i=1 continue
	s per=$P(itm,$C(1),1)
	s rw=$P(itm,$C(1),4)
	
	
	if stdate=""
	{
		b
		s a=##class(User.DHCMGDepBill).%OpenId(+rw)
		s stdate=a.BillStDate
		s edate=a.BillEnDate
		s feaprice=a.BillFeastPrice
	    s ferprice=a.BillFeriPrice
	}
	s parstr=..getparw(per,rw)
	if parstr'=""
	{
	  s id=$P(parstr,"^",1)
	} 
	s feahours=$P(itm,$C(1),3)
	s ferihours=$P(itm,$C(1),2)
    s feasum=feahours*feaprice
    s ferisum=ferihours*ferprice
    s sum=feasum+ferisum
    s substr=substr_per_$C(1)_feahours_$C(1)_ferihours_$C(1)_feasum_$C(1)_ferisum_$C(1)_sum_$C(1)_rw_"^"
    s sfeahours=sfeahours+feahours
    s sferihours=sferihours+ferihours
    s sfeasum=sfeasum+feasum
    s sferisum=sferisum+ferisum 
    s ssum=ssum+sum
  }
  s parr=dep_"^"_user_"^"_stdate_"^"_edate_"^"_sfeahours_"^"_sferihours_"^"_sfeasum_"^"_sferisum_"^"_ssum
  s user=$P(parr,"^",2)
  s dep=$P(parr,"^",1)
  s stdate=$P(parr,"^",3)
  s edate=$P(parr,"^",4)
  s feahours=$P(parr,"^",5)
  s ferihours=$P(parr,"^",6)
  s sum=$P(parr,"^",9)
  s feasum=$P(parr,"^",7)
  s ferisum=$P(parr,"^",8)
  if id'="" s a=##class(User.DHCMGRpDuty).%OpenId(id)
  e  s a=##class(User.DHCMGRpDuty).%New()
  s a.DutyRpDep=dep //##class(User.CTLoc).%OpenId(dep)
  s a.DutyRpStDate=stdate
  s a.DutyRpEndDate=edate
  s a.DutyRpFeahours=feahours
  s a.DutyRpFeriHours=ferihours
  s a.DutyRpSum=sum
  s a.DutyRpFeaSum=feasum
  s a.DutyRpFeriSum=ferisum
  s a.DutyRpFeaPrice=feaprice
  s a.DutyRpFeriPrice=ferprice
  s a.DutyRecUser=##class(User.DHCMGPersons).%OpenId(user)
  s a.DutyRecDate=+$H
  s a.DutyRecTime=$P($H,",",2)
  s a.DutyRpFlag="S"
  d a.%Save()
  //s ^temp1=substr
  s ret=##class(User.DHCMGRpDutySub).Save(a,substr)
  q 0
}

ClassMethod getparw(per, perbill) As %String
{
  //##class(User.DHCMGRpDuty).getparw()
   s parw="",chlw=""
   s par="" f  s par=$O(^User.DHCMGRpDutySubI("perbill",per,perbill,par)) q:par=""  d
   .s sub="" f  s sub=$O(^User.DHCMGRpDutySubI("perbill",per,perbill,par,sub))  q:sub=""  d
   ..s parw=par,chlw=sub
   if parw="" q ""
   q parw_"^"_chlw
}

ClassMethod Refund(par) As %String
{
 //退回 s a=##class(User.DHCMGRpDuty).Refund()
  //s par="4^543^asdfadsfasfas"
  s id=$P(par,"^",1)
  s user=$P(par,"^",2)
  s mem=$P(par,"^",3)
  s a=##class(User.DHCMGRpDuty).%OpenId(id)
  s a.DutyRpFlag="R"
  s a.DutyRpMem=mem
  d a.%Save()
  q 0
}

ClassMethod AuditDuty(par) As %String
{
 //发放
  s id=$P(par,"^",1)
  s user=$P(par,"^",2)
  s a=##class(User.DHCMGRpDuty).%OpenId(id)
  s a.DutyAudDate=+$H
  s a.DutyAudTime=$P($H,",",2)
  s a.DutyAudUser=##class(User.DHCMGPersons).%OpenId(user)
  s a.DutyRpFlag="A"
  d a.%Save()
  ///审核减存休
  s chl=""  f  s chl=$O(^User.DHCMGRpDutyD(id,"ChildDHCMGRpDutySub",chl)) q:chl=""  d
  .s rw=id_"||"_chl
  .s chlobj=##class(User.DHCMGRpDutySub).%OpenId(rw)
  .s addhours=chlobj.SubPerBill.PerBillAddHours
  .s bfhour=chlobj.SubFeriHours+chlobj.SubFeastHours
  .s addhours=addhours-bfhour
  .s chlobj.SubPerBill.PerBillAddHours=addhours
  .d chlobj.%Save()
  
  q 0
}

Storage Default
{
<Data name="DHCMGRpDutyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DutyRpDep</Value>
</Value>
<Value name="3">
<Value>DutyRpEndDate</Value>
</Value>
<Value name="4">
<Value>DutyRpFlag</Value>
</Value>
<Value name="5">
<Value>DutyRpNum</Value>
</Value>
<Value name="6">
<Value>DutyRpStDate</Value>
</Value>
<Value name="7">
<Value>DutyRecUser</Value>
</Value>
<Value name="8">
<Value>DutyRecDate</Value>
</Value>
<Value name="9">
<Value>DutyRecTime</Value>
</Value>
<Value name="10">
<Value>DutyAudDate</Value>
</Value>
<Value name="11">
<Value>DutyAudTime</Value>
</Value>
<Value name="12">
<Value>DutyAudUser</Value>
</Value>
<Value name="13">
<Value>DutyRpFeaPrice</Value>
</Value>
<Value name="14">
<Value>DutyRpFeaSum</Value>
</Value>
<Value name="15">
<Value>DutyRpFeahours</Value>
</Value>
<Value name="16">
<Value>DutyRpFeriHours</Value>
</Value>
<Value name="17">
<Value>DutyRpFeriPrice</Value>
</Value>
<Value name="18">
<Value>DutyRpFeriSum</Value>
</Value>
<Value name="19">
<Value>DutyRpSum</Value>
</Value>
<Value name="20">
<Value>DutyRpMem</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGRpDutyD</DataLocation>
<DefaultData>DHCMGRpDutyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGRpDutyD</IdLocation>
<IndexLocation>^User.DHCMGRpDutyI</IndexLocation>
<StreamLocation>^User.DHCMGRpDutyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class User.DHCMGDepBill Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property BillDepDr As %String(TRUNCATE = 1);

Property BillStDate As %Library.Date(FORMAT = 1);

Property BillEnDate As %Library.Date(FORMAT = 1);

//累计存休

Property BillAddHours As %String(TRUNCATE = 1);

//实际工作小时数

Property BillRealWorkHours As %String(TRUNCATE = 1);

//应该工作小时数

Property BillTheroWorkDays As %String(TRUNCATE = 1);

//节日工作小时数

Property BillFeastHours As %String(TRUNCATE = 1);

Property BillFeastPrice As %String(TRUNCATE = 1);

Property BillFeriPrice As %String(TRUNCATE = 1);

Property BillStat As %Library.String(DISPLAYLIST = ",Paid,Billed", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",P,B");

Property BillPaidDate As %Library.Date(FORMAT = 1);

Property BillPaidTime As %Library.Time;

Property BillPaidUser As User.DHCMGPersons;

Relationship ChildDHCMGDepBillSub As User.DHCMGDepBillSub [ Cardinality = children, Inverse = DHCMGDepBillParRef ];

Index BillDepDate On (BillDepDr, BillStDate);

ClassMethod Save(parr As %String) As %String
{
  //"^"_dep_"^"_stdate_"^"_edate_"^"_addhours_"^"_realhours_"^"_therodays_"^"_feasthours_"^"_FeastPrice_"^"_FeriPrice_"^"_stat_"^"_User
   
   s id=$P(parr,"^",13)
   s dep=$P(parr,"^",2)
   s stdate=$P(parr,"^",3)
   s endate=$P(parr,"^",4)
   s addhours=$P(parr,"^",5)
   s realhours=$P(parr,"^",6)
   s therodays=$P(parr,"^",7)
   s feasthours=$P(parr,"^",8)
   s FeastPrice=$P(parr,"^",9)
   s FeriPrice=$P(parr,"^",10)
   s stat=$P(parr,"^",11)
   s user=$P(parr,"^",12)
   ///n
   s previd=..getprevid(dep,"P")
   if id'=""  s a=##class(User.DHCMGDepBill).%OpenId(id)
   e  s a=##class(User.DHCMGDepBill).%New()
   s a.BillDepDr=dep //##class(User.CTLoc).%OpenId(dep)

   s a.BillStDate=stdate

   s a.BillEnDate=endate


   s a.BillAddHours=addhours


   s a.BillRealWorkHours=realhours


   s a.BillTheroWorkDays=therodays


   s a.BillFeastHours=feasthours

   s a.BillFeastPrice=FeastPrice

   s a.BillFeriPrice=FeriPrice

   s a.BillStat=stat

   s a.BillPaidDate=+$H

   s a.BillPaidTime=$P($H,",")

   s a.BillPaidUser=##class(User.DHCMGPersons).%OpenId(user)
   d a.%Save()
   s currid=..getprevid(dep,stat)
   q previd_"^"_currid
}

ClassMethod getprevid(dep, stflag) As %String
{
  //s a=##class(User.DHCMGDepBill).getprevid()

 s id="",stat=""
 s date=""  f  s date=$O(^User.DHCMGDepBillI("BillDepDate"," "_dep,date),-1) q:date=""!(stat=stflag)  d
 .s id=""
 .s rw=""  f  s rw=$O(^User.DHCMGDepBillI("BillDepDate"," "_dep,date,rw)) q:rw=""  d
 ..s a=^User.DHCMGDepBillD(rw)
 ..s stat=$list(a,13)
 ..q:stat'=stflag
 ..s id=rw
 q id
}

Storage Default
{
<Data name="DHCMGDepBillDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BillDepDr</Value>
</Value>
<Value name="3">
<Value>BillAddHours</Value>
</Value>
<Value name="4">
<Value>BillEnDate</Value>
</Value>
<Value name="5">
<Value>BillFeastHours</Value>
</Value>
<Value name="6">
<Value>BillFeastPrice</Value>
</Value>
<Value name="7">
<Value>BillFeriPrice</Value>
</Value>
<Value name="8">
<Value>BillPaidDate</Value>
</Value>
<Value name="9">
<Value>BillPaidTime</Value>
</Value>
<Value name="10">
<Value>BillPaidUser</Value>
</Value>
<Value name="11">
<Value>BillRealWorkHours</Value>
</Value>
<Value name="12">
<Value>BillStDate</Value>
</Value>
<Value name="13">
<Value>BillStat</Value>
</Value>
<Value name="14">
<Value>BillTheroWorkDays</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGDepBillD</DataLocation>
<DefaultData>DHCMGDepBillDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGDepBillD</IdLocation>
<IndexLocation>^User.DHCMGDepBillI</IndexLocation>
<StreamLocation>^User.DHCMGDepBillS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

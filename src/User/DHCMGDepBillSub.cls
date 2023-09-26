Class User.DHCMGDepBillSub Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_DepBillSub ]
{

Relationship DHCMGDepBillParRef As User.DHCMGDepBill [ Cardinality = parent, Inverse = ChildDHCMGDepBillSub, Required ];

Property PerBillPer As User.DHCMGPersons;

//累计存休

Property PerBillAddHours As %String(TRUNCATE = 1);

//实际工作小时数

Property PerBillRealWorkHours As %String(TRUNCATE = 1);

//应该工作小时数

Property PerBillTheroWorkHours As %String(TRUNCATE = 1);

//节日工作小时数

Property PerBillFeastHours As %String(TRUNCATE = 1);

Property PerBillStat As %Library.String(DISPLAYLIST = ",Paid,Billed", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",P,B");

Property PerBillInitiVal As %String(TRUNCATE = 1);

Index Per On PerBillPer;

ClassMethod GetInitiVal(per) As %String
{
 //s a=##class(User.DHCMGDepBillSub).GetInitiVal()
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

ClassMethod Save(parent, parr As %String) As %String
{
   //取上次结帐的累计存休

  //=dep_"^"_per_"^"_User_"^"_stdate_"^"_edate_"^"_realhours(nur)_"^"_theoryhours(nur)_"^"_feasthours(nur)_"^"_feastprice_"^"_feriprice
  
  s dep=$P(parr,"^",1)
  s User=$P(parr,"^",3)
  s per=$P(parr,"^",2)
  s status=$P(parr,"^",11)
  s oldid=$P(parr,"^",12)
  s currid=$P(parr,"^",13)
  
  s prevaddhours=""

  if oldid'="" s prevaddhours=..getprevhours(oldid,per)
  //结算时查找最后一条paid记录  取其上次累计存休 
  //查找最后一条billed记录 取其id值 更新期数据 状态改成paid
  //结算时排他操作
  s StDate=$P(parr,"^",4)
  s EnDate=$P(parr,"^",5)
  s RealWorkHours=$P(parr,"^",6)
  s TheroHours=$P(parr,"^",7)
  s FeastHours=$P(parr,"^",8)
  s FeastPrice=$P(parr,"^",9)
  s FeriPrice=$P(parr,"^",10)
  //本次累计存休=实际工作时间-应该工作时间+上次累计
  s AddHours=RealWorkHours-TheroHours+prevaddhours
  s reshours=##class(web.DHCMGPersonBill).getperhlBx(per,"BX",StDate,EnDate)
  s AddHours=AddHours-reshours
  //每次结算减去补休时间
  //if StDate'=""  s StDate=$ZDH(StDate,3)
  //if EnDate'=""  s EnDate=$ZDH(EnDate,3)
  s id=""
  s chl=""
  if currid'="" s chl=$O(^User.DHCMGDepBillSubI("Per",per,currid,""))
  if chl'="" s id=currid_"||"_chl
  if id'=""  s a=##class(User.DHCMGDepBillSub).%OpenId(id)
  e  s a=##class(User.DHCMGDepBillSub).%New()
  s a.PerBillPer=##class(User.DHCMGPersons).%OpenId(per)
  s a.PerBillAddHours=AddHours
  s a.PerBillRealWorkHours=RealWorkHours
  s a.PerBillTheroWorkHours=TheroHours
  s a.PerBillFeastHours=FeastHours
  s a.PerBillStat=status
  s a.PerBillInitiVal=..GetInitiVal(per)*8
  s a.DHCMGDepBillParRef=parent
  d a.%Save()
  q 0
}

ClassMethod getprevhours(oldid, per) As %String
{
   s addhours=0
   s rw="" f  s rw=$O(^User.DHCMGDepBillSubI("Per",per,oldid,rw)) q:rw=""  d
   .s a=^User.DHCMGDepBillSubD(oldid,rw)
   .s addhours=$list(a,2)
   q addhours
}

Storage Default
{
<Data name="DHCMGDepBillSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PerBillAddHours</Value>
</Value>
<Value name="3">
<Value>PerBillFeastHours</Value>
</Value>
<Value name="4">
<Value>PerBillPer</Value>
</Value>
<Value name="5">
<Value>PerBillRealWorkHours</Value>
</Value>
<Value name="6">
<Value>PerBillStat</Value>
</Value>
<Value name="7">
<Value>PerBillTheroWorkHours</Value>
</Value>
<Value name="8">
<Value>PerBillInitiVal</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGDepBillSubD</DataLocation>
<DefaultData>DHCMGDepBillSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Child")</IdLocation>
<IndexLocation>^User.DHCMGDepBillSubI</IndexLocation>
<StreamLocation>^User.DHCMGDepBillSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

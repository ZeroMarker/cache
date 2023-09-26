Class User.DHCMGPersonOverRest Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_OVER_REST ]
{

/// /加班日期
Property OVDate As %Library.Date(FORMAT = 1);

//科室

Property OVTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property OVPersonDr As %String(TRUNCATE = 1);

Property OVReasonDR As %String(TRUNCATE = 1);

Property OVSum As %String(TRUNCATE = 1);

//每次操作最后个人的合计 qse 2009-3-31

//加班休息时间

Property OVRestTimes As %String(TRUNCATE = 1);

Property OVRecDate As %Library.Date(FORMAT = 1);

Property OVRecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property OVRecUser As %String(TRUNCATE = 1);

Property OVTyp As %Library.String(DISPLAYLIST = ",Over,Rest", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",OV,RS");

Property OVDepDR As %String(TRUNCATE = 1);

//休假代码

Property VORESHLDR As User.DHCMGCHoliday;

//开始时间

Property OVRESStTime As %Library.Time;

//结束时间

Property OVRESETime As %Library.Time;

Index Dep On OVDepDR;

Index PerDate On (OVPersonDr, OVDate);

Index PersonDate On (OVPersonDr, OVRecDate);

Index DepDate On (OVDepDR, OVDate);

ClassMethod delvo(per, date) As %String
{
  //s a=##class(User.DHCMGPersonOverRest).delvo()
    //s per="2490",date="2009-11-28"
    s date=$ZDH(date,3)
    s ProtectDay=$g(^DHCCLSet("DHCNURMG","ArrangeProtectDay"))
    q:(date<(+$h))&((+$h-date)'<ProtectDay)&(ProtectDay'="") 0
    b
    s rw="" f  s rw=$O(^User.DHCMGPersonOverRestI("PerDate"," "_per,date,rw)) q:(rw="")  d
    .b //s rw=$O(^User.DHCMGPersonOverRestI("PersonDate"," "_per,date,"")) 
    .d ##class(User.DHCMGPersonOverRest).%DeleteId(rw)
    .
    .b 
    q 0
}

ClassMethod SaveOV(parr As %String) As %String
{
 //id + "^" + person + "^" + datestr  + "^" + mem  + "^" + typ  + "^" + times + "^" +  Comm.UserID+ "^" + Comm.logonLoc;
 // s parr="^726^2009-4-13^^OV^^543^1082^14:30:00^16:30:00^"
  s id=$P(parr,"^",1)
  s per=$P(parr,"^",2)
  s ovdate=$P(parr,"^",3)
  s curovdate=$ZDH(ovdate,3)
  s ProtectDay=$g(^DHCCLSet("DHCNURMG","ArrangeProtectDay"))
  q:(curovdate<(+$h))&((+$h-curovdate)'<ProtectDay)&(ProtectDay'="") 0
  s reason=$P(parr,"^",4)
  s typ=$P(parr,"^",5)
  s ovrestime=$P(parr,"^",6)
  s user=$P(parr,"^",7)
  s dep=$P(parr,"^",8)
  s sttime=$P(parr,"^",9)
  s etime=$P(parr,"^",10)
  s hl=$P(parr,"^",11)
  s sttime=$ZTH(sttime),etime=$ZTH(etime)
  s ovrestime=(etime-sttime)/3600
  s rw=""
  s sum=0
  s oldval=0
  s date="" f  s date=$O(^User.DHCMGPersonOverRestI("PersonDate"," "_per,date),-1) q:(date="")!(rw'="")  d
  .s rw=$O(^User.DHCMGPersonOverRestI("PersonDate"," "_per,date,"")) 
  .b
  b
  if rw'=""  
  {
	  s a=##class(User.DHCMGPersonOverRest).%OpenId(rw)
	  s sum=a.OVSum
	  s oldval=a.OVRestTimes
  }
  i id="" s ov=##class(User.DHCMGPersonOverRest).%New()
  e  s ov=##class(User.DHCMGPersonOverRest).%OpenId(id)
  s ov.OVDate=$ZDH(ovdate,3)
  s ov.OVPersonDr=per
  s ov.OVReasonDR=reason
  s ov.OVRestTimes=ovrestime
  s ov.OVTyp=typ
  s ov.OVRecDate=+$H
  s ov.OVRecTime=$P($H,",",2)
  s ov.OVRecUser=user
  s ov.OVDepDR=dep
  s ov.OVRESStTime=sttime
  s ov.OVRESETime=etime
  if hl'="" s ov.VORESHLDR=##class(User.DHCMGCHoliday).%OpenId(hl)
  s hlobj=ov.VORESHLDR
  if hl'=""{
     if hlobj.HolCode'="BX" s ovrestime=0 
  }
  if rw'=id
  {
   if (typ="OV") s ov.OVSum=sum+ovrestime
   
   if (typ="RS") s ov.OVSum=sum-ovrestime
  }else{
	   s newval=ovrestime-oldval
	   if typ="OV" s ov.OVSum=sum+newval
       if (typ="RS") s ov.OVSum=sum-newval

	  }
  d ov.%Save()
  q 0
}

ClassMethod uplastRec(per As %String, val As %String) As %String
{
  s rw=""
  s sum=0
  s oldval=0
  s date="" f  s date=$O(^User.DHCMGPersonOverRestI("PersonDate"," "_per,date),-1) q:(date="")!(rw'="")  d
  .s rw=$O(^User.DHCMGPersonOverRestI("PersonDate"," "_per,date,"")) 
  if rw'=""  
  {
	  s a=##class(User.DHCMGPersonOverRest).%OpenId(rw)
	  s a.OVSum=a.OVSum-val
	  d a.%Save()
  }
  q 0
}

ClassMethod upRec(id As %String, val As %String) As %String
{
  s rw=""
  s sum=0
  s oldval=0
  s ov=##class(User.DHCMGPersonOverRest).%OpenId(id)
  s per=ov.OVPersonDr
  s date="" f  s date=$O(^User.DHCMGPersonOverRestI("PersonDate"," "_per,date),-1) q:(date="")!(rw'="")  d
  .s rw=$O(^User.DHCMGPersonOverRestI("PersonDate"," "_per,date,"")) 
  if rw'=""  
  {
	  s a=##class(User.DHCMGPersonOverRest).%OpenId(rw)
	  s a.OVSum=val
	  d a.%Save()
  }
  q 0
}

Storage Default
{
<Data name="DHCMGPersonOverRestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OVDate</Value>
</Value>
<Value name="3">
<Value>OVDepDR</Value>
</Value>
<Value name="4">
<Value>OVPersonDr</Value>
</Value>
<Value name="5">
<Value>OVReasonDR</Value>
</Value>
<Value name="6">
<Value>OVRecDate</Value>
</Value>
<Value name="7">
<Value>OVRecTime</Value>
</Value>
<Value name="8">
<Value>OVRecUser</Value>
</Value>
<Value name="9">
<Value>OVTime</Value>
</Value>
<Value name="10">
<Value>OVTyp</Value>
</Value>
<Value name="11">
<Value>OVRestTimes</Value>
</Value>
<Value name="12">
<Value>OVSum</Value>
</Value>
<Value name="13">
<Value>OVRESETime</Value>
</Value>
<Value name="14">
<Value>OVRESStTime</Value>
</Value>
<Value name="15">
<Value>VORESHLDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPersonOverRestD</DataLocation>
<DefaultData>DHCMGPersonOverRestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGPersonOverRestD</IdLocation>
<IndexLocation>^User.DHCMGPersonOverRestI</IndexLocation>
<StreamLocation>^User.DHCMGPersonOverRestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

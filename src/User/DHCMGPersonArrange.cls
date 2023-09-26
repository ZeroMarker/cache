Class User.DHCMGPersonArrange Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_PersonArrange ]
{

//科室病区User.DHCMGPersonPlanArrange

Property ARRPerDR As %String(TRUNCATE = 1);

Property ARRPostDR As %String(TRUNCATE = 1);

Property ARRDate As %Library.Date(FORMAT = 1);

Property ARRRecordUser As %String(TRUNCATE = 1);

Property ARRRecDate As %Library.Date(FORMAT = 1);

Property ARRRecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property ARRMem As %String(TRUNCATE = 1);

Property ARRDepDR As %String(TRUNCATE = 1);

Property ARRRelayDR As %String(TRUNCATE = 1);

Property AuditDr As User.DHCMGAuditArrange;

//

Index Loc On ARRDepDR;

Index PersonDate On (ARRPerDR, ARRDate);

Index DepDate On (ARRDepDR, ARRDate);

Index DatePost On (ARRDate, ARRPostDR);

Index Date On ARRDate;

Index Audit On AuditDr;

ClassMethod ptarrange(parr As %String) As %String
{
   s post=$P(parr,"^",1)
   s person=$P(parr,"^",2)
   if person="" q 0
   s arrdate=$P(parr,"^",3)
   s ProtectDay=$g(^DHCCLSet("DHCNURMG","ArrangeProtectDay"))
   q:(arrdate<(+$h))&((+$h-arrdate)'<ProtectDay)&(ProtectDay'="") 0
   s dep=$P(parr,"^",4)
   s user=$P(parr,"^",5)
   s flag=$P(parr,"^",6)
   s arr=##class(User.DHCMGPersonArrange).%New()
   s arr.ARRPostDR=post
   s arr.ARRPerDR=person
   s arr.ARRDate=arrdate
   s arr.ARRDepDR=dep
   s arr.ARRRecDate=+$H
   s arr.ARRRecTime=$P($H,",",2)
   s arr.ARRRecordUser=user
   s arr.ARRMem=flag
   d arr.%Save()
   q arr
}

ClassMethod manulArrange(parr As %String) As %String
{
   //s parr="3|^186^2009-3-1^1079^561"
   //21|^6016^2012-10-9|2012-10-9^76^6017^^
   //21|^6016^2012-10-9|2012-10-9^76^6017^^
   //21|^6016^2012-10-9^76^6017^^Y
   // w ##class(User.DHCMGPersonArrange).manulArrange("21|^6016^2012-10-9|2012-10-9^76^6017^^")
   //w ##class(User.DHCMGPersonArrange).manulArrange("21|^6016^2012-10-9^76^6017^^Y")
   s poststr=$P(parr,"^",1)
   s nurse=$P(parr,"^",2)
   if nurse="" q 0
   s arrdate=$P(parr,"^",3)
   s Dep=$P(parr,"^",4)
   s User=$P(parr,"^",5)
   s flag=$P(parr,"^",6)
   s addflag=$P(parr,"^",7)
   s n=$L(poststr,"|")
   if $F(arrdate,"|")>1
   {
      s std=$P(arrdate,"|",1)
      s ed=$P(arrdate,"|",2)
      s std=$ZDH(std,3),ed=$ZDH(ed,3)
      f arrdate=std:1:ed
      {
        s a=..delarr(nurse,$ZD(arrdate,3),"1")
        //b //88
        if a="1" q
        //q:a="1" ""
	  }
	 f j=1:1:n
	 { //人员 检查某人某日是否已有岗位//岗位人数还没考虑 //考虑关联人
	  //b 999
		s pt=$P(poststr,"|",j)
		q:pt=""
	    f arrdate=std:1:ed
	    {
		  	s parr=pt_"^"_nurse_"^"_arrdate_"^"_Dep_"^"_User_"^"_flag
		  	//b //888
			s ret=##class(User.DHCMGPersonArrange).ptarrange(parr)
	    }
	 } 
	 //b //100
    q "1"
    //b //102
   }
   //b //103
   if addflag="Y"
   {
   }else
   {
     
     s a=..delarr(nurse,arrdate,"1")
     //b //89
     q:a="1" ""
   }
	f j=1:1:n
	{ //人员 检查某人某日是否已有岗位//岗位人数还没考虑 //考虑关联人
	  //b 999
	s pt=$P(poststr,"|",j)
	q:pt=""
	s parr=pt_"^"_nurse_"^"_$ZDH(arrdate,3)_"^"_Dep_"^"_User_"^"_flag
	//b //892
	s ret=##class(User.DHCMGPersonArrange).ptarrange(parr)
	} 
 q ret
}

ClassMethod manulArrange1(parr As %String) As %String
{
  //复制粘贴
   //s parr="3|^186^2009-3-1^1079^561"
   s poststr=$P(parr,"^",1)
   s nurse=$P(parr,"^",2)
   if nurse="" q 0
   s arrdate=$P(parr,"^",3)
   s Dep=$P(parr,"^",4)
   s User=$P(parr,"^",5)
   s flag=$P(parr,"^",6)
   s addflag=$P(parr,"^",7)
   s n=$L(poststr,"|")
   if addflag="Y"
   {
   }else
   {
     s a=..ifexist(nurse,arrdate)
     q:a="1" ""
   }
	f j=1:1:n
	{ //人员 检查某人某日是否已有岗位//岗位人数还没考虑 //考虑关联人
	//  b 999
	s pt=$P(poststr,"|",j)
	q:pt=""
	s parr=pt_"^"_nurse_"^"_$ZDH(arrdate,3)_"^"_Dep_"^"_User_"^"_flag
	s ret=##class(User.DHCMGPersonArrange).ptarrange(parr)
	} 
 q ret
}

ClassMethod ifexist(per, date) As %String
{
 //删除排班
   s date=$ZDH(date,3)
   s flag="0"
   s rw=""  f  s rw=$O(^User.DHCMGPersonArrangeI("PersonDate"," "_per,date,rw)) q:rw=""  d
   .s flag="1"
   q flag
}

ClassMethod delarr(per, date, ff As %String = "0") As %String
{
 //删除排班
   s date=$ZDH(date,3)
   s ProtectDay=$g(^DHCCLSet("DHCNURMG","ArrangeProtectDay"))
   q:(date<(+$h))&((+$h-date)'<ProtectDay)&(ProtectDay'="") 0

   s flag=0
   s rw=""  f  s rw=$O(^User.DHCMGPersonArrangeI("PersonDate"," "_per,date,rw)) q:rw=""  d
   .s mem=$listget(^User.DHCMGPersonArrangeD(rw),4)
   .if mem'=""  s flag=1
   .q:((mem'="")&(ff="1"))
   .d ##class(User.DHCMGPersonArrange).%DeleteId(rw)
   q flag
}

ClassMethod AdjDelarr(parr As %String) As %String
{
 //保存 删除排班
   s per=$P(parr,"^",1)
   s date=$P(parr,"^",2)
   s user=$P(parr,"^",3)
   s date=$ZDH(date,3)
   
   s rw=""  f  s rw=$O(^User.DHCMGPersonArrangeI("PersonDate"," "_per,date,rw)) q:rw=""  d
   .s arr=##class(User.DHCMGPersonArrange).%OpenId(rw)
   .s oldpost=arr.ARRPostDR
   .s parr=per_"^"_date_"^"_oldpost_"^"_""_"^"_user
   .s ret=##class(User.DHCMGPostAdjust).SaveAdjust(parr)
   .d ##class(User.DHCMGPersonArrange).%DeleteId(rw)
   q 0
}

ClassMethod getarrmem(per, date) As %String
{
 //找最近的 备注
   // s date=$ZDH("2009-12-01",3)
    s stdate=date+1
    s ret=""
   // s per=1992
    s date=stdate  f  s date=$O(^User.DHCMGPersonArrMemI("PersonDate"," "_per,date),-1) q:date=""!(ret'="")  d
    .s rw=""  f  s rw=$O(^User.DHCMGPersonArrMemI("PersonDate"," "_per,date,rw),-1) q:rw=""!(ret'="")  d
	..s arr=^User.DHCMGPersonArrMemD(rw)
	..s mem=$ListGet(arr,3)
	..if mem'="" s ret=mem
  q ret
}

ClassMethod getdeparrmem(dep, date) As %String
{
 //找最近的 备注
   // s date=$ZDH("2009-12-01",3)
   // s a=##class(User.DHCMGPersonArrange).getdeparrmem(1340,"2010-02-07")
    s date=$ZDH(date,3)
    s stdate=date+1
    s ret=""
   // s per=1992
    s date=stdate  f  s date=$O(^User.DHCMGPersonArrMemI("DepDate"," "_dep,date),-1) q:date=""!(ret'="")  d
    .s rw=""  f  s rw=$O(^User.DHCMGPersonArrMemI("DepDate"," "_dep,date,rw),-1) q:rw=""!(ret'="")  d
	..s arr=^User.DHCMGPersonArrMemD(rw)
	..s mem=$ListGet(arr,3)
	..if mem'="" s ret=mem
  q ret
}

ClassMethod arrange(parr As %String) As %String
{
   s post=$P(parr,"^",1)
   s person=$P(parr,"^",2)
   if person="" q 0
   s arrdate=$P(parr,"^",3)
   s dep=$P(parr,"^",4)
   s user=$P(parr,"^",5)
   s id=$P(parr,"^",6)
   s rw="" s rw=$O(^User.DHCMGPersonArrangeI("PersonDate"," "_person,arrdate,rw))
   if rw="" s id=""
   e  s id=rw
   if id="" s arr=##class(User.DHCMGPersonArrange).%New()
   e  s arr=##class(User.DHCMGPersonArrange).%OpenId(id)
   if id'=""
   { //如果不是当天调的记录调班记录
      //如果岗位相同就退出
      s oldpost=arr.ARRPostDR
      if oldpost=post q 0
      s parr=person_"^"_arrdate_"^"_oldpost_"^"_post_"^"_user
      s ret=##class(User.DHCMGPostAdjust).SaveAdjust(parr)

   }else{
          s parr=person_"^"_arrdate_"^"_""_"^"_post_"^"_user
          s ret=##class(User.DHCMGPostAdjust).SaveAdjust(parr)
   }
   q 0
}

Storage Default
{
<Data name="DHCMGPersonArrangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ARRDate</Value>
</Value>
<Value name="3">
<Value>ARRDepDR</Value>
</Value>
<Value name="4">
<Value>ARRMem</Value>
</Value>
<Value name="5">
<Value>ARRPerDR</Value>
</Value>
<Value name="6">
<Value>ARRPostDR</Value>
</Value>
<Value name="7">
<Value>ARRRecDate</Value>
</Value>
<Value name="8">
<Value>ARRRecTime</Value>
</Value>
<Value name="9">
<Value>ARRRecordUser</Value>
</Value>
<Value name="10">
<Value>ARRRelayDR</Value>
</Value>
<Value name="11">
<Value>AuditDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPersonArrangeD</DataLocation>
<DefaultData>DHCMGPersonArrangeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGPersonArrangeD</IdLocation>
<IndexLocation>^User.DHCMGPersonArrangeI</IndexLocation>
<StreamLocation>^User.DHCMGPersonArrangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

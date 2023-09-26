Class DHCMGNUR.MgCheckWard Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Wards As list Of %String(TRUNCATE = 1);

Property CheckTitle As %String(TRUNCATE = 1);

Property NurTyp As %String(TRUNCATE = 1);

Property CheckTyp As %String(TRUNCATE = 1);

//SafeCheck  QualCheck  //SpecCheck/ Satisfy -Discharge,CurrPat,Nurse,Doctor

Property CheckUsers As list Of %String(TRUNCATE = 1);

Property CheckStDate As %Library.Date(FORMAT = 1);

Property CheckEdDate As %Library.Date(FORMAT = 1);

Property CheckStatus As %String(TRUNCATE = 1);

Property CheckMem As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0);

Property CheckQuals As list Of %String(TRUNCATE = 1);

Property RecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property RecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property RecUser As %String(TRUNCATE = 1);

Index CheckDate On (CheckTyp, CheckStDate);

ClassMethod Save(parr As %String, users As %String, checkitms As %String) As %String
{
   	s ^TEMPPPP("ssss")=parr_"@"_users_"@"_checkitms
	s tmp=""
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s tdata=""
    s id=$G(tmp("rw"))
    if id=""
    {
		s a=##class(DHCMGNUR.MgCheckWard).%New()
	}else{	 
		s a=##class(DHCMGNUR.MgCheckWard).%OpenId(id)
	}
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.MgCheckWard","a",p)) q:p=""  d
	.if $D(tmp(p)) d
	..if p="CheckStDate" s tmp(p)=$ZDH(tmp(p),3)
	..if p="CheckEdDate" s tmp(p)=$ZDH(tmp(p),3)
	..if $G(tmp("NurTyp"))=3 s tmp("NurTyp")="MasterNur"
	..if $G(tmp("NurTyp"))=2 s tmp("NurTyp")="LocNur"
	..if $G(tmp("NurTyp"))=1 s tmp("NurTyp")="Nur"
	..s $ZOBJPROPERTY(a,p)=tmp(p)
	s l=$L(checkitms,"^")
	d a.CheckQuals.Clear()
	for i=1:1:l
	{
		s itm=$P(checkitms,"^",i)
	  	if itm'=""
	  	{
	    	//s itm=##class(web.DHCNUREMR).Replace(itm,"_","||")
	    	s sc=a.CheckQuals.Insert(itm)
	  	}
	}
	s l=$L(users,"^")
	d a.CheckUsers.Clear()
	for i=1:1:l
	{
	 	s itm=$P(users,"^",i)
	  	if itm'=""
	  	{
	    	//s itm=##class(web.DHCNUREMR).Replace(itm,"_","||")
	    	s sc=a.CheckUsers.Insert(itm)
	  	}
	}
	s l=a.CheckUsers.Count()
	i l=0  q "请录入审核人"
    d a.%Save()
	q a.%Id()
}

//SunZongJu

ClassMethod judClear(Par) As %String
{
	//d ##class(DHCMGNUR.MgCheckWard).judClear("113")
 s count=0
 s score=""
   s loc=""  f  s loc=$O(^Nur.QualCheckRecI("QCheck"," "_Par,loc)) q:loc=""  d
 	.s code=""  f  s code=$O(^Nur.QualCheckRecI("QCheck"," "_Par,loc,code)) q:code=""  d
 	..s chl=""  f  s chl=$O(^Nur.QualCheckRecI("QCheck"," "_Par,loc,code,chl)) q:chl=""  d
 	...s b=##class(Nur.QualCheckRec).%OpenId(chl)
 	...s score=b.Score
 	...if (score'="") s count=count+1
 	...s score=""
 	q count
}

ClassMethod delQual(par) As %String
{
  s a=##class(DHCMGNUR.MgCheckWard).%DeleteId(par)
  q 0
}

ClassMethod getCheckId(typ) As %String
{
 //s a=##class(DHCMGNUR.MgCheckWard).getCheckId()
   s stdate=$H-10
   s edate=$H+10
   s curdate=+$H
   s chktyp=$TR($ZConvert(typ,"U")," ","")
   s CheckId=""
   for date=stdate:1:edate
   {
      s rw=""
      f {
	      s rw=$O(^DHCMGNUR.MgCheckWardI("CheckDate"," "_chktyp,date,rw))
	      q:rw=""
	      s a=##class(DHCMGNUR.MgCheckWard).%OpenId(rw)
	      s chkstdate=a.CheckStDate
	      s chkeddate=a.CheckEdDate
	      
	      b //在此时间范围内就有效
	      if ((curdate'<chkstdate)&&(curdate'>chkeddate)) s CheckId=rw
	      b //
	    
	    }
   }
   q CheckId
}

ClassMethod getVal(id) As %String
{
 //w ##class(DHCMGNUR.MgCheckWard).getVal(48)
 	s ^TEMP("DHCMGNURID")=id
	s ret=""
	if id'=""
	{
		s a=##class(DHCMGNUR.MgCheckWard).%OpenId(id)
		s tdata="",tmp=""
		s p="" f  s p=$O(^oddCOM("DHCMGNUR.MgCheckWard","a",p)) q:p=""  d
		.q:p["%"
		.s tmp(p)=$ZOBJPROPERTY(a,p)
    	//s itms=..getcountweight(a)
		s itms=..getitms(a)
		s tmp("CheckUsers")=$P(itms,"$",1)
		s tmp("Wards")=$P(itms,"$",2)
		s tmp("CheckStDate")=$ZD(tmp("CheckStDate"),3)
		s tmp("CheckEdDate")=$ZD(tmp("CheckEdDate"),3)
		//if tmp("CheckTyp")'="" s tmp("CheckRoom")=$G(aa(tmp("CheckTyp")))
		i tmp("NurTyp")=3 s tmp("NurTyp")="MasterNur"
		i tmp("NurTyp")=2 s tmp("NurTyp")="LocNur"
		i tmp("NurTyp")=1 s tmp("NurTyp")="Nur"
		s tmp("CheckScore")=..getScore(id)
		s k=""
		f {
			s k=$O(tmp(k))
			q:k=""
			if tmp(k)["%" continue
			s ret=ret_k_"|"_tmp(k)_"^"
		}
	}
	q ret
}

ClassMethod getScore(Par) As %String
{
	s score=0
	s id="" f  s id=$O(^DHCMGNUR.MgCheckWardD(Par,"ChildSub",id)) q:id=""  d
 	.s a=##class(DHCMGNUR.MgCheckWard).%OpenId(Par_"||"_id)
	.s code=a.ItemCode
	.s chkitm=a.CheckItem
	.s score=score+chkitm.ItemValue
	.//b //3
	q score
}

ClassMethod getitms(itm) As %String
{
	    //s ^dd=itm
  
   		s l=itm.CheckUsers.Count()
	    s ret1="",ret2=""
	    for i=1:1:l
	    {
		  s rw=itm.CheckUsers.GetAt(i)
		  s des=$P(..getsuser(rw),"!",2)
		  s ret1=ret1_des_";"
		} 
       s l=itm.CheckQuals.Count()
	    for i=1:1:l
	    {
		  s rww=itm.CheckQuals.GetAt(i)
		  s rw=$p(rww,"!",2)
		  s wet=$p(rww,"!",1)
		  s a=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
		  s des=a.QualDesc   
		  s ret2=ret2_des_";"
		 
		}

		s ret=ret1_"$"_ret2
		q ret
}

//sun

ClassMethod getcountweight(id) As %String
{
	//d ##class(DHCMGNUR.MgCheckWard).getcountweight(48)
	   s itm=##class(DHCMGNUR.MgCheckWard).%OpenId(id)
       s l=itm.CheckQuals.Count()
       s sun=0
      
	    for i=1:1:l
	    {
		  s rw=itm.CheckQuals.GetAt(i)
		  s a=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
		  s weight=a.QualWeight	    
		  s sun=sun+weight
		}
		s sun=100/sun		
		q sun
}

ClassMethod getcountWeight2(qpar, checkcode, score) As %String
{
	   s itm=##class(DHCMGNUR.MgCheckWard).%OpenId(qpar)
       s l=itm.CheckQuals.Count()
       s zong=0
       
	    for i=1:1:l
	    {
		  s rw=itm.CheckQuals.GetAt(i)
		  s a=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
		  s qcode=a.QualCode
		  //s qcode=$TR($ZConvert(a.QualCode,"U")," ","")
		  if (qcode=checkcode&&score'="")
		  {
			s zong=a.QualWeight 
		 }
		 }
		q zong
}

ClassMethod getcountgrade(qpar, tweight, checkcode, score) As %String
{
	   //d ##class(DHCMGNUR.MgCheckWard).getcountweight(48)
	   //s ^hh=$LB(qpar, sun, checkcode, score)
	   s itm=##class(DHCMGNUR.MgCheckWard).%OpenId(qpar)
       s l=itm.CheckQuals.Count()
       s sc=0
       //w qpar_","_tweight_","_checkcode_","_score
	    for i=1:1:l
	    {
		  s rww=itm.CheckQuals.GetAt(i)
		  s rw=$p(rww,"!",2)
		  s weit=$p(rww,"!",1)
		  s qualcode=$list(^DHCMGNUR.QualCodeItemD(rw),2)
		  s value=$list(^DHCMGNUR.QualCodeItemD(rw),4)
	      if (qualcode=checkcode) s sc=score*tweight*weit/value	
	     }
	     	q sc
		  //s a=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
		 // s qcode=a.QualCode
		  //s qcode=$TR($ZConvert(a.QualCode,"U")," ","")
		 // if (qcode=checkcode)
		 // {
			//s weit=a.QualWeight
			//s value=a.QualValue
		   // s sc=score*tweight*weit/value	  
		// }
}

ClassMethod getqualWet(qpar, code) As %String
{
 //w qpar_"|"_code
 s itm=##class(DHCMGNUR.MgCheckWard).%OpenId(qpar)
 s l=itm.CheckQuals.Count()	
 s wet=""
 for i=1:1:l
	    {
		  s rww=itm.CheckQuals.GetAt(i)
		  s rw=$p(rww,"!",2)
		  s wei=$p(rww,"!",1)
		  //s a=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
	      s qualcode=$list(^DHCMGNUR.QualCodeItemD(rw),2)
	      if (qualcode=code) s wet=wei
	    }
		 q wet
}

ClassMethod getfen(qPar, checkcode) As %String
{
	   s itm=##class(DHCMGNUR.MgCheckWard).%OpenId(qPar)
       s l=itm.CheckQuals.Count()
       s baifenbi=0
	    for i=1:1:l
	    {
		  s rw=itm.CheckQuals.GetAt(i)
		  s a=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
		  s check=a.QualCode
		 // if (check==checkcode)
		 // {
           // s qualvale=a.QualValue
           // s qualweight=a.QualWeight
              s baifenbi=qualvale/qualweight
		 // }  
		 
		 
		}
		q baifenbi
}

//sun

ClassMethod getitms1(id) As %String
{
   		s itm=##class(DHCMGNUR.MgCheckWard).%OpenId(id)
   		s l=itm.CheckUsers.Count()
	    s ret1="",ret2=""
	    for i=1:1:l
	    {
		  s rw=itm.CheckUsers.GetAt(i)
		  s des=$P(..getsuser(rw),"!",2)
		  s ret1=ret1_des_"^"_rw_"!"
		} 
        s l=itm.CheckQuals.Count()
	    for i=1:1:l
	    {
		  s rww=itm.CheckQuals.GetAt(i)
		  s rw=$p(rww,"!",2)
		  s wet=$p(rww,"!",1)
		
		  s a=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
		  s des=a.QualDesc	    
		  s ret2=ret2_des_"^"_wet_"^"_rw_"!"
		}
		b 
		s ret=ret1_"$"_ret2
		
		q ret
}

ClassMethod getsuser(recuserId) As %String
{
  q:recuserId="" ""
  s User=$p($g(^SSU("SSUSR",recuserId)),"^",2)
  q recuserId_"!"_User
}

Method ListProperties() As %String [ CodeMode = objectgenerator ]
{
  //s a=##class(DHCMGNUR.MgCheckWard).ListProperties()
   s clsname="DHCMGNUR.MgCheckWard"
    s tpp=""
    k ^tCodeItem(clsname)
    For i = 1:1:%compiledclass.Properties.Count() {
        Set prop = %compiledclass.Properties.GetAt(i).Name
	    if $F(prop,"%")=0
        {
         Do %code.WriteLine(" s ^tCodeItem("""_clsname_""","""_prop_""")="_i)
        }

    }
    //Do %code.WriteLine(" Quit")
    //删除 没有的属性

    Quit $$$OK
}

ClassMethod getRecUser(id) As %String
{
	s obj=##class(DHCMGNUR.MgCheckWard).%OpenId(id)
	s recUser=obj.RecUser
	q recUser
}

Storage Default
{
<Data name="MgCheckWardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Wards</Value>
</Value>
<Value name="3">
<Value>CheckTyp</Value>
</Value>
<Value name="4">
<Value>CheckUsers</Value>
</Value>
<Value name="5">
<Value>CheckStDate</Value>
</Value>
<Value name="6">
<Value>CheckEdDate</Value>
</Value>
<Value name="7">
<Value>CheckStatus</Value>
</Value>
<Value name="8">
<Value>CheckQuals</Value>
</Value>
<Value name="9">
<Value>RecDate</Value>
</Value>
<Value name="10">
<Value>RecTime</Value>
</Value>
<Value name="11">
<Value>RecUser</Value>
</Value>
<Value name="12">
<Value>CheckMem</Value>
</Value>
<Value name="13">
<Value>CheckTitle</Value>
</Value>
<Value name="14">
<Value>NurTyp</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgCheckWardD</DataLocation>
<DefaultData>MgCheckWardDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgCheckWardD</IdLocation>
<IndexLocation>^DHCMGNUR.MgCheckWardI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgCheckWardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

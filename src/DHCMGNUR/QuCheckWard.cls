Class DHCMGNUR.QuCheckWard Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship ChildSub As DHCMGNUR.QuCheckWardChild [ Cardinality = children, Inverse = QualParref ];

/// 检查病区
Property Wards As list Of %String(MAXLEN = 300, TRUNCATE = 1);

/// 查房类型
Property CheckTyp As %String(TRUNCATE = 1);

/// 检查人员
Property CheckUsers As list Of %String(TRUNCATE = 1);

/// 检查日期
Property CheckDate As %Library.Date(FORMAT = 1);

/// 检查开始时间
Property CheckSTime As %String(TRUNCATE = 1);

/// 检查结束时间
Property CheckEndTime As %String(TRUNCATE = 1);

Property CheckStatus As %String(TRUNCATE = 1);

/// CheckFlag 为0时是固定模板  为1时是调用自定义的维护模板
Property CheckFlag As %String(TRUNCATE = 1);

/// 质控项目id
Property CheckMoudId As %String(TRUNCATE = 1);

Property RecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property RecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property RecUser As %String(TRUNCATE = 1);

/// 检查层次H:护理部 W:病区 Z：总（科）护士长
Property CheckLevel As %String(TRUNCATE = 1);

Index CheckDate On CheckDate;

Index CheckFlag On CheckFlag;

ClassMethod Save(parr As %String, users As %String, cwards As %String) As %String
{
	s tmp=""
	s ^TEMP("g06241558001")=parr_"&"_users_"&"_cwards
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s tdata=""
    s id=$G(tmp("rw"))
   // m ^TMP("pp")=tmp
    if id=""
    {
	    s a=##class(DHCMGNUR.QuCheckWard).%New()
	}else{ 
		s a=##class(DHCMGNUR.QuCheckWard).%OpenId(id)
	}
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.QuCheckWard","a",p)) q:p=""  d
	.if $D(tmp(p)) d
	..if p="CheckDate" s tmp(p)=$ZDH(tmp(p),3)
	..s $ZOBJPROPERTY(a,p)=tmp(p)
	s l=$L(cwards,"^")
	d a.Wards.Clear()
	for i=1:1:l
	{
	  s itm=$P(cwards,"^",i)
	  if itm'=""
	  {
	    //s itm=##class(web.DHCNUREMR).Replace(itm,"_","||")
	    s sc=a.Wards.Insert(itm)
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

    d a.%Save()
	q a.%Id()
}

ClassMethod delQual(rw) As %String
{
   s a=##class(DHCMGNUR.QuCheckWard).%DeleteId(rw)
   q 0
}

ClassMethod getVal(id) As %String
{
	s ^TEMP("g06241149001")=id
	s ret=""
	s aa("DayChk")="随机督查"
	s aa("NightChk")="夜查房"
	if id'=""
	{
		s a=##class(DHCMGNUR.QuCheckWard).%OpenId(id)
		s tdata="",tmp=""
		s p="" f  s p=$O(^oddCOM("DHCMGNUR.QuCheckWard","a",p)) q:p=""  d
		.q:p["%"
		.s tmp(p)=$ZOBJPROPERTY(a,p)
		s itms=..getitmsM(a)
		s tmp("CheckUsers")=$P(itms,"$",1)
		s tmp("Wards")=$P(itms,"$",2)
		;s tmp("Wards")=$p(tmp("Wards"),";",1)_"..."
		s tmp("CheckDate")=$ZD(tmp("CheckDate"),3)
		if tmp("CheckTyp")'="" s tmp("CheckRoom")=$G(aa(tmp("CheckTyp")))
		s tmp("CheckScore")=..getScore(id)
		i tmp("CheckLevel")="H" s tmp("CheckLevel")="护理部"
		e  i tmp("CheckLevel")="W" s tmp("CheckLevel")="病区"
		e  i tmp("CheckLevel")="Z" s tmp("CheckLevel")="科护士长"
		e  s tmp("CheckLevel")=""
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

ClassMethod getVal1(id) As %String
{
	//短信通知取数据
 //w ##class(DHCMGNUR.MenuSystem).getVal(
	s ret=""
	b
	s aa("DayChk")="随机督查"
	s aa("NightChk")="夜查房"
	if id'=""
	{
	s a=##class(DHCMGNUR.QuCheckWard).%OpenId(id)
	s tdata="",tmp=""
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.QuCheckWard","a",p)) q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(a,p)
	s itms=..getitmsM(a)
	
	
	s tmp("CheckUsers")=$P(itms,"$",1)
	s tmp("Wards")=$P(itms,"$",2)
	s tmp("CheckDate")=$ZD(tmp("CheckDate"),3)
	if tmp("CheckTyp")'="" s tmp("CheckRoom")=$G(aa(tmp("CheckTyp")))

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
	s ^TEMP("g06241136001")=Par
	s score=0
	s b=##class(DHCMGNUR.QuCheckWard).%OpenId(Par)
	i (b.CheckFlag=0)||(b.CheckFlag="")
	{
		s id="" f  s id=$O(^DHCMGNUR.QuCheckWardD(Par,"ChildSub",id))  q:id=""  d
 	 	.s a=##class(DHCMGNUR.QuCheckWardChild).%OpenId(Par_"||"_id)
	 	.s code=a.ItemCode
	 	.s chkitm=a.CheckItem
	 	.s score=score+chkitm.ItemValue
	}
	i b.CheckFlag=1
	{
		s id="" f  s id=$O(^DHCMGNUR.QuCheckWardD(Par,"ChildSub",id))  q:id=""  d
 		.s a=##class(DHCMGNUR.QuCheckWardChild).%OpenId(Par_"||"_id)
		.s code=a.ItemCode
		.s chkitm=a.CheckItem
		.s score=score+chkitm.ItemValue
   	}
	q score
}

ClassMethod getitms(itm) As %String
{
   		s l=itm.CheckUsers.Count()
	    s ret1="",ret2=""
	    for i=1:1:l
	    {
		  s rw=itm.CheckUsers.GetAt(i)
		  s des=$P(..getsuser(rw),"!",2)
		  s ret1=ret1_des_";"
		} 
        s l=itm.Wards.Count()
	    for i=1:1:l
	    {
		  s rw=itm.Wards.GetAt(i)
		  s des=$p(^CTLOC(rw),"^",2)	    

		  s ret2=ret2_des_";"
		}
		s ret=ret1_"$"_ret2
		q ret
}

ClassMethod getitmsM(itm) As %String
{
   		s l=itm.CheckUsers.Count()
	    s ret1="",ret2=""
	    for i=1:1:l
	    {
		  s rw=itm.CheckUsers.GetAt(i)
		  s des=$P(..getsuser(rw),"!",2)
		  s ret1=ret1_des_";"
		} 
        s l=itm.Wards.Count()
	    for i=1:1:l
	    {
		  s rw=itm.Wards.GetAt(i)
		  s des=$p($p(^CTLOC(rw),"^",2),"-",2)	    

		  s ret2=ret2_des_";"
		}
		s ret=ret1_"$"_ret2
		q ret
}

ClassMethod getitms1(id) As %String
{
	s itm=##class(DHCMGNUR.QuCheckWard).%OpenId(id)
   	s l=itm.CheckUsers.Count()
	s ret1="",ret2=""
	for i=1:1:l
	{
		s rw=itm.CheckUsers.GetAt(i)
		s des=$P(..getsuser(rw),"!",2)
		s ret1=ret1_des_"^"_rw_"!"
	} 
    s l=itm.Wards.Count()
	for i=1:1:l
	{
		s rw=itm.Wards.GetAt(i)
		s des=$p(^CTLOC(rw),"^",2)
		s ret2=ret2_des_"^"_rw_"!"
	}
	s ret=ret1_"$"_ret2
	q ret
}

ClassMethod getsuser(recuserId) As %String
{
  q:recuserId="" ""
  s User=$p($g(^SSU("SSUSR",recuserId)),"^",2)
  q recuserId_"!"_User
}

ClassMethod getRecDate(id) As %String
{
	s ^TEMP("g06270856001")=id
	s obj=##class(DHCMGNUR.QuCheckWard).%OpenId(id)
	s checkdate=$zd(obj.CheckDate,3)
	q checkdate
}

Storage Default
{
<Data name="QuCheckWardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecDate</Value>
</Value>
<Value name="3">
<Value>RecTime</Value>
</Value>
<Value name="4">
<Value>RecUser</Value>
</Value>
<Value name="5">
<Value>Wards</Value>
</Value>
<Value name="6">
<Value>CheckUsers</Value>
</Value>
<Value name="7">
<Value>CheckDate</Value>
</Value>
<Value name="8">
<Value>CheckEndTime</Value>
</Value>
<Value name="9">
<Value>CheckSTime</Value>
</Value>
<Value name="10">
<Value>CheckTyp</Value>
</Value>
<Value name="11">
<Value>CheckStatus</Value>
</Value>
<Value name="12">
<Value>CheckFlag</Value>
</Value>
<Value name="13">
<Value>CheckMoudId</Value>
</Value>
<Value name="14">
<Value>CheckLevel</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.QuCheckWardD</DataLocation>
<DefaultData>QuCheckWardDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.QuCheckWardD</IdLocation>
<IndexLocation>^DHCMGNUR.QuCheckWardI</IndexLocation>
<StreamLocation>^DHCMGNUR.QuCheckWardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

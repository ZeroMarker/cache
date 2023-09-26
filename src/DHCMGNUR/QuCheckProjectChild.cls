Class DHCMGNUR.QuCheckProjectChild Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship QualParref As DHCMGNUR.QuCheckProject [ Cardinality = parent, Inverse = ChildSub, Required ];

Property CheckItem As DHCMGNUR.QualCodeItemSub;

Property ItemCode As %String(TRUNCATE = 1);

Property ItemLevel As %String(TRUNCATE = 1);

Property ItemDesc As %String(TRUNCATE = 1);

Index Level On ItemLevel;

Index CheckItem On CheckItem;

ClassMethod SaveCheckMoud(item, par, level, code) As %String
{
   s a=##class(DHCMGNUR.QuCheckProjectChild).%New()
   s a.CheckItem=##class(DHCMGNUR.QualCodeItemSub).%OpenId(item)
   s a.QualParref=##class(DHCMGNUR.QuCheckProject).%OpenId(par)
   if level="" s level=$P(item,"||")
   s a.ItemLevel=level
   i code=""  s code=level_"."_..getlevecode(level,par)
   s a.ItemCode=code
   d a.%Save()
   q a.%Id()
}

ClassMethod SaveEdit(rw, level, code) As %String
{
	s ^TEMP("g201501092001001")=rw_"%"_level_"%"_code
	//7||1%2%1.2
	s a=##class(DHCMGNUR.QuCheckProjectChild).%OpenId(rw)
	s a.ItemLevel=level
	s a.ItemCode=code
	d a.%Save()
	q 0
}

ClassMethod getlevecode(level, par) As %String
{
  s i=1
  s rw="" f  s rw=$O(^DHCMGNUR.QuCheckProjectChildI("Level"," "_level,par,rw)) q:rw=""  d
  .s i=i+1
  q i
}

ClassMethod getVal(id) As %String
{
 //w ##class(DHCMGNUR.QuCheckProjectChild).getVal(
	s ret=""
	if id'=""
	{
		s a=##class(DHCMGNUR.QuCheckProjectChild).%OpenId(id)
		s tdata="",tmp=""
		s code=a.ItemCode
	    s level=a.ItemLevel
		s tmp("MinLevel")="Y"
		s subitm=code_".1"
		s Par=$P(id,"||")
		
		if $D(^DHCMGNUR.QuCheckProjectChildI("Level"," "_subitm,Par)) s tmp("MinLevel")="N"
        
		s p="" f  s p=$O(^oddCOM("DHCMGNUR.QualCodeItemSub","a",p)) q:p=""  d
		.q:p["%"
		.s tmp(p)=$ZOBJPROPERTY(a.CheckItem,p)
		;b //itm
		s tmp("ItemCode")=code
		s tmp("ItemLevel")=level
		s k=""
		f {
			s k=$O(tmp(k))
			q:k=""
			s ret=ret_k_"|"_tmp(k)_"^"
		 }
	}
	q ret
}

ClassMethod DelItmMoud(rw) As %String
{
   s flag=""
   s flag=##class(DHCMGNUR.QuCheckProject).EditFlag($p(rw,"||",1))
   q:flag'=0 "已使用,不能删除!"
   s a=##class(DHCMGNUR.QuCheckProjectChild).%DeleteId(rw)
   q 0
}

//删除自定义模板的名称

ClassMethod DelItmMoudName(rw) As %String
{
   s flag=""
   s flag=$O(^DHCMGNUR.QuCheckProjectD(rw,"ChildSub",""))
   if flag="" s a=##class(DHCMGNUR.QuCheckProject).%DeleteId(rw)
   q:flag="" 0
   q 1
}

ClassMethod getQuVal(id) As %String
{
 //w ##class(DHCMGNUR.QuCheckProjectChild).getVal(
	s ret=""
	if id'=""
	{
		s a=##class(DHCMGNUR.QuCheckWardChild).%OpenId(id)
		s tdata="",tmp=""
		s code=a.ItemCode
	    s level=a.ItemLevel
		s tmp("MinLevel")="Y"
		s subitm=code_".1"
		s Par=$P(id,"||")
	    s chkitmid=$lg(^DHCMGNUR.QuCheckWardD(Par,"ChildSub",$P(id,"||",2)),2)
		s c=##class(DHCMGNUR.QuCheckProjectChild).%OpenId(chkitmid)
		s chkitm=c.CheckItem
		
		if $D(^DHCMGNUR.QuCheckProjectChildI("Level"," "_subitm,Par)) s tmp("MinLevel")="N"
        
		s p="" f  s p=$O(^oddCOM("DHCMGNUR.QualCodeItemSub","a",p)) q:p=""  d
		.q:p["%"
		.s tmp(p)=$ZOBJPROPERTY(chkitm,p)
		;b //itm
		s tmp("ItemCode")=code
		s tmp("ItemLevel")=level
		s k=""
		f {
			s k=$O(tmp(k))
			q:k=""
			s ret=ret_k_"|"_tmp(k)_"^"
		 }
	}
	q ret
}

Storage Default
{
<Data name="QuCheckProjectChildDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckItem</Value>
</Value>
<Value name="3">
<Value>ItemCode</Value>
</Value>
<Value name="4">
<Value>ItemDesc</Value>
</Value>
<Value name="5">
<Value>ItemLevel</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.QuCheckProjectChildD</DataLocation>
<DefaultData>QuCheckProjectChildDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCMGNUR.QuCheckProjectChildI</IndexLocation>
<StreamLocation>^DHCMGNUR.QuCheckProjectChildS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

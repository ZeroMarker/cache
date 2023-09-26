Class DHCMGNUR.QuCheckWardChild Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship QualParref As DHCMGNUR.QuCheckWard [ Cardinality = parent, Inverse = ChildSub, Required ];

Property CheckItem As DHCMGNUR.QualCodeItemSub;

Property ItemCode As %String(TRUNCATE = 1);

Property ItemLevel As %String(TRUNCATE = 1);

Property ItemDesc As %String(TRUNCATE = 1);

Property ItemValue As %String(TRUNCATE = 1);

Property ModleCode As %String(TRUNCATE = 1);

Index Level On ItemLevel;

Index CheckItem On CheckItem;

ClassMethod Save(item, par, level, code, CheckFlag) As %String
{
   //s bb=##class(DHCMGNUR.QuCheckWard).%OpenId(par)
   //q:bb.CheckMoudId'="" 0
   if (CheckFlag=0)
   {
   s a=##class(DHCMGNUR.QuCheckWardChild).%New()
   s a.CheckItem=##class(DHCMGNUR.QualCodeItemSub).%OpenId(item)
   s a.QualParref=##class(DHCMGNUR.QuCheckWard).%OpenId(par)
   if level="" s level=$P(item,"||")
   s a.ItemLevel=level
   i code=""  s code=level_"."_..getlevecode(level,par)
   s a.ItemCode=code
   d a.%Save()
   s b=##class(DHCMGNUR.QuCheckWard).%OpenId(par)
   s b.CheckFlag=CheckFlag
   s b.CheckMoudId=level
   d b.%Save()
   }
   if (CheckFlag=1)
   {
   s a=##class(DHCMGNUR.QuCheckWardChild).%New()
   s a.CheckItem=##class(DHCMGNUR.QuCheckProjectChild).%OpenId(item)
   s a.QualParref=##class(DHCMGNUR.QuCheckWard).%OpenId(par)
   if level="" s level=$P(item,"||")
   s a.ItemLevel=level
   i code=""  s code=level_"."_..getlevecode(level,par)
   s a.ItemCode=code
   d a.%Save()
   s b=##class(DHCMGNUR.QuCheckWard).%OpenId(par)
   s b.CheckFlag=CheckFlag
   s b.CheckMoudId=level
   d b.%Save()
   }
   q a.%Id()
}

ClassMethod SaveItm(rw, level, code) As %String
{
   s ^TEMP("g201501171648001")=rw_"%"_level_"%"_code
   s ret=0
   s a=##class(DHCMGNUR.QuCheckWardChild).%OpenId(rw)
   i a="" s ret=1
   e  d
   .s a.ItemCode=code
   .s a.ItemLevel=level
   .d a.%Save()
   q ret
}

ClassMethod DelItm(rw) As %String
{
	s flag=""
	s flag=##class(DHCMGNUR.QuCheckProject).EditFlag(id)
	q:flag'=0 flag
   s a=##class(DHCMGNUR.QuCheckWardChild).%DeleteId(rw)
   q 0
}

ClassMethod getlevecode(level, par) As %String
{
  s i=1
  s rw="" f  s rw=$O(^DHCMGNUR.QuCheckWardChildI("Level"," "_level,par,rw)) q:rw=""  d
  .s i=i+1
  q i
}

ClassMethod getVal(id) As %String
{
 //w ##class(DHCMGNUR.QuCheckWardChild).getVal(
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
		
		if $D(^DHCMGNUR.QuCheckWardChildI("Level"," "_subitm,Par)) s tmp("MinLevel")="N"
        
		s p="" f  s p=$O(^oddCOM("DHCMGNUR.QualCodeItemSub","a",p)) q:p=""  d
		.q:p["%"
		.s tmp(p)=$ZOBJPROPERTY(a.CheckItem,p)
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

ClassMethod SaveChildItms(ret) As %String
{
	s ^TEMP("g06200930001")=ret //27^抽好的针未放无菌盘、举针给药^2^12^11
	s PRowId=$P(ret,"^",1)
	s desc=$P(ret,"^",2)
	s score=$P(ret,"^",3)
	s QualPar=$P(ret,"^",4)
	s QualRaw=$P(ret,"^",5)
	s CheckFlag=$P(ret,"^",6)
	s ModleCode=$P(ret,"^",7)
	s obj=##class(DHCMGNUR.QuCheckWardChild).%New()
	s obj.QualParref=##class(DHCMGNUR.QuCheckWard).%OpenId(PRowId)
	s obj.ItemDesc=desc
	s obj.ItemValue=score
	s obj.ItemCode=..getQualItmCode(QualPar,QualRaw)
	s obj.CheckItem=##class(DHCMGNUR.QualCodeItemSub).%OpenId(QualPar_"||"_QualRaw)
	s obj.ModleCode=ModleCode
	d obj.%Save()
	s b=##class(DHCMGNUR.QuCheckWard).%OpenId(PRowId)
   	s b.CheckFlag=CheckFlag
   	;s b.CheckMoudId=level
   	d b.%Save()
	q 1
}

ClassMethod getQualItmCode(Par, Raw) As %String
{
	s ret=""
	s obj=##class(DHCMGNUR.QualCodeItemSub).%OpenId(Par_"||"_Raw)
	s ret=obj.ItemCode
	q ret
}

ClassMethod DelChildItms(Par) As %String
{
	s ^TEMP("06200939001")=Par
	q:Par="" ""
	s raw="" f  s raw=$O(^DHCMGNUR.QuCheckWardD(Par,"ChildSub",raw)) q:raw=""  d
	.d ##class(DHCMGNUR.QuCheckWardChild).%DeleteId(Par_"||"_raw)
	q 0
}

Storage Default
{
<Data name="QuCheckWardChildDefaultData">
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
<Value>ItemLevel</Value>
</Value>
<Value name="5">
<Value>ItemDesc</Value>
</Value>
<Value name="6">
<Value>ItemValue</Value>
</Value>
<Value name="7">
<Value>Code</Value>
</Value>
<Value name="8">
<Value>ModleCode</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>QuCheckWardChildDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCMGNUR.QuCheckWardChildI</IndexLocation>
<StreamLocation>^DHCMGNUR.QuCheckWardChildS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

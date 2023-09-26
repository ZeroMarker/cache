Class DHCMGNUR.CommDictionary Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//所属医院

Relationship ChildSub As DHCMGNUR.CommDictionarySub [ Cardinality = children, Inverse = CommParref ];

Property MouldCode As %String(TRUNCATE = 1);

Property Category As %String(TRUNCATE = 1);

Property Code As %String(TRUNCATE = 1);

Property CateDesc As %String(TRUNCATE = 1);

Property CodeUse As %String(TRUNCATE = 1);

Property ValidFlag As %String(TRUNCATE = 1);

Property HisDr As %String(TRUNCATE = 1);

Index Code On Code;

Index MouldCode On MouldCode;

ClassMethod getcodepar(code As %String) As %String
{
  //##class(DHCMGNUR.CommDictionary).getcodepar
   s code=$TR($ZConvert(code,"U")," ","")
   s par=$O(^DHCMGNUR.CommDictionaryI("Code"," "_code,""))
   q par
}

ClassMethod Save(parr As %String) As %String
{
	s ^TEMP("g201412261100001")=parr
	//parr=rw|^Category|test1^MouldCode|1^Code|test1^ValidFlag|true^CateDesc|test1^HisDr|2^CodeUse|test1
	
	s id=$P($P(parr,"^",1),"|",2)
	i id=""
	{
		s a=##class(DHCMGNUR.CommDictionary).%New()
	}else{
		s a=##class(DHCMGNUR.CommDictionary).%OpenId(id)
	}
	s a.Category=$P($P(parr,"^",2),"|",2)
	s a.MouldCode=$P($P(parr,"^",3),"|",2)
	s a.Code=$P($P(parr,"^",4),"|",2)
	s a.ValidFlag=$P($P(parr,"^",5),"|",2)
	s a.CateDesc=$P($P(parr,"^",6),"|",2)
	s a.HisDr=$P($P(parr,"^",7),"|",2)
	s a.CodeUse=$P($P(parr,"^",8),"|",2)
	d a.%Save()
	q a.%Id()
}

ClassMethod SaveOld(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s tdata=""
    s id=$G(tmp("rw"))
   // m ^TMP("pp")=tmp
     if id=""
     {
		 s a=##class(DHCMGNUR.CommDictionary).%New()
	 }else{
		 
		 s a=##class(DHCMGNUR.CommDictionary).%OpenId(id)
	 }
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.CommDictionary","a",p)) q:p=""  d
	.if $D(tmp(p)) d
	..s $ZOBJPROPERTY(a,p)=tmp(p)
    d a.%Save()
	q a.%Id()
}

ClassMethod getVal(id) As %String
{
 //w ##class(DHCMGNUR.MenuSystem).getVal(
	s ret=""
	;b
	if id'=""
	{
	s a=##class(DHCMGNUR.CommDictionary).%OpenId(id)
	s tdata="",tmp=""
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.CommDictionary","a",p)) q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(a,p)
	.i p="ValidFlag" d
	..s ^TEMP("g201412261049001")=tmp(p)
	..i tmp(p)="true" s tmp(p)="有效"
	..i tmp(p)="false" s tmp(p)="无效"
	.if ((p="MouldCode")&(tmp(p)'="")) d
	..s moul=##class(DHCMGNUR.Mould).%OpenId(tmp(p))
	..;s tmp(p)=moul.MouldName_"!"_tmp(p)
	..s tmp(p)=moul.MouldName
	.if ((p="HisDr")&(tmp(p)'="")) d
    ..s HospName=$p($G(^CT("HOSP",tmp(p))),"^",2)
	..;s tmp(p)=HospName_"!"_tmp(p)
	..s tmp(p)=HospName
	..b
	s k=""
	f {
		s k=$O(tmp(k))
		q:k=""
		s ret=ret_k_"|"_tmp(k)_"^"
	}
	}
	q ret
}

ClassMethod del(id) As %String
{
	TStart
	s object=##class(DHCMGNUR.CommDictionarySub).%OpenId(id)
	s sc = object.%DeleteId(id)
	b ;01
	i $$$ISERR(sc)  
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
		q "删除失败"
	}
	else
	{
		TCommit
		q "删除成功"
	}
}

Storage Default
{
<Data name="CommDictionaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CateDesc</Value>
</Value>
<Value name="3">
<Value>Category</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>CodeUse</Value>
</Value>
<Value name="6">
<Value>MouldCode</Value>
</Value>
<Value name="7">
<Value>ValidFlag</Value>
</Value>
<Value name="8">
<Value>HisDr</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.CommDictionaryD</DataLocation>
<DefaultData>CommDictionaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.CommDictionaryD</IdLocation>
<IndexLocation>^DHCMGNUR.CommDictionaryI</IndexLocation>
<StreamLocation>^DHCMGNUR.CommDictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

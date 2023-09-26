Class DHCMGNUR.CommDictionarySub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship CommParref As DHCMGNUR.CommDictionary [ Cardinality = parent, Inverse = ChildSub, Required ];

Property Code As %String(TRUNCATE = 1);

Property CodeDesc As %String(TRUNCATE = 1);

// 所属医院

Property HisDr As %String(TRUNCATE = 1);

Property txtMem As %String(TRUNCATE = 1);

Property ValidFlag As %String(TRUNCATE = 1);

Property FromDate As %Library.Date(FORMAT = 1);

Property EndDate As %Library.Date(FORMAT = 1);

Index Code On Code;

ClassMethod Save(parr As %String) As %String
{
	s ^TEMP("1703021145001")=parr
	s tmp=""
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
    s id=$G(tmp("rw"))
    //m tmp=^TMP("pp")
     if id=""
     {
		 s a=##class(DHCMGNUR.CommDictionarySub).%New()
		 s a.CommParref=##class(DHCMGNUR.CommDictionary).%OpenId(tmp("Par"))
	 }else{
		 
		 s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(tmp("Par")_"||"_id)
	 }
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.CommDictionarySub","a",p)) q:p=""  d
	.if (p="FromDate")&($G(tmp(p))'="") s tmp(p)=$ZDH(tmp(p),3)
	.if (p="EndDate")&($G(tmp(p))'="") s tmp(p)=$ZDH(tmp(p),3)
	.if $D(tmp(p)) d
	..s $ZOBJPROPERTY(a,p)=tmp(p)
    d a.%Save()
    b ///sss
	q a.%Id()
}

ClassMethod getVal(id) As %String
{
 	s dateFlag=##class(websys.Conversions).DateFormat()
	s ret=""
	if id'=""
	{
		s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(id)
		s tdata="",tmp=""
		s p="" f  s p=$O(^oddCOM("DHCMGNUR.CommDictionarySub","a",p)) q:p=""  d
		.q:p["%"
		.s tmp(p)=$ZOBJPROPERTY(a,p)
		.if (p="FromDate")&(tmp(p)'="")&((dateFlag=3)!(dateFlag=4)) s tmp(p)=##class(web.DHCMgNurPerHRComm).getDateFormat(tmp(p)) //s tmp(p)=$ZD(tmp(p),3)
		.if (p="EndDate")&(tmp(p)'="")&((dateFlag=3)!(dateFlag=4)) s tmp(p)=##class(web.DHCMgNurPerHRComm).getDateFormat(tmp(p)) //s tmp(p)=$ZD(tmp(p),3)
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
<Data name="CommDictionarySubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>DDesc</Value>
</Value>
<Value name="4">
<Value>HisDr</Value>
</Value>
<Value name="5">
<Value>CodeDesc</Value>
</Value>
<Value name="6">
<Value>EndDate</Value>
</Value>
<Value name="7">
<Value>FromDate</Value>
</Value>
<Value name="8">
<Value>ValidFlag</Value>
</Value>
<Value name="9">
<Value>txtMem</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.CommDictionarySubD</DataLocation>
<DefaultData>CommDictionarySubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCMGNUR.CommDictionarySubI</IndexLocation>
<StreamLocation>^DHCMGNUR.CommDictionarySubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

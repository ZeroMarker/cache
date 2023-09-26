Class DHCMGNUR.MenuSystemSub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship MenuParref As DHCMGNUR.MenuSystem [ Cardinality = parent, Inverse = ChildSub, Required ];

Property ItemTyp As %String(TRUNCATE = 1);

Property ItemDesc As %String(TRUNCATE = 1);

Property ItemCode As %String(TRUNCATE = 1);

Index ItemCode On ItemCode;

//[ Unique ];

//元素类型，元素代码 描述

ClassMethod Save(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s tdata=""
    s id=$G(tmp("rw"))
      m ^TMP("pp")=tmp
     if id=""
     {
		 s a=##class(DHCMGNUR.MenuSystemSub).%New()
		 s a.MenuParref=##class(DHCMGNUR.MenuSystem).%OpenId(tmp("Par"))
	 }else{
		 
		 s a=##class(DHCMGNUR.MenuSystemSub).%OpenId(tmp("Par")_"||"_id)
	 }
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.MenuSystemSub","a",p)) q:p=""  d
	.if $D(tmp(p)) d
	..s $ZOBJPROPERTY(a,p)=tmp(p)
    d a.%Save()
	q a.%Id()
}

ClassMethod getVal(id) As %String
{
 //w ##class(DHCMGNUR.MenuSystem).getVal(
	s ret=""
	b
	if id'=""
	{
	s a=##class(DHCMGNUR.MenuSystemSub).%OpenId(id)
	s tdata="",tmp=""
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.MenuSystemSub","a",p)) q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(a,p)
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
<Data name="MenuSystemSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemDesc</Value>
</Value>
<Value name="3">
<Value>ItemTyp</Value>
</Value>
<Value name="4">
<Value>ItemCode</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MenuSystemSubD</DataLocation>
<DefaultData>MenuSystemSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCMGNUR.MenuSystemSubI</IndexLocation>
<StreamLocation>^DHCMGNUR.MenuSystemSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

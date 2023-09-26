Class User.DHCMGSSGRPRELHISGRP Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//与his安全组对照

Property ssgrp As User.DHCMGSSGROUP;

Property hisssgrp As %String(TRUNCATE = 1);

Index hisgrp On hisssgrp;

ClassMethod save(parr) As %String
{
   s id=$P(parr,"^",1)
   s ss=$P(parr,"^",2)
   s his=$P(parr,"^",3)
   if id="" s a=##class(User.DHCMGSSGRPRELHISGRP).%New()
   e  s a=##class(User.DHCMGSSGRPRELHISGRP).%OpenId(id)
   s a.ssgrp=##class(User.DHCMGSSGROUP).%OpenId(ss)
   s a.hisssgrp=his
   d a.%Save()
   q 0
}

ClassMethod getgrp(hisgrp) As %String
{
 //##class(User.DHCMGSSGRPRELHISGRP).getgrp(ssgrp)
	s grp=""
	s rw="" s rw=$O(^User.DHCMGSSGRPRELHISGRPI("hisgrp"," "_hisgrp,rw))
	if rw'=""
	{
	  s grp=$list(^User.DHCMGSSGRPRELHISGRPD(rw),3)
	  s typ=$ListGet(^User.DHCMGSSGROUPD(grp),4)
	}
	q grp_"^"_$G(typ)
}

Storage Default
{
<Data name="DHCMGSSGRPRELHISGRPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>hisssgrp</Value>
</Value>
<Value name="3">
<Value>ssgrp</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGSSGRPRELHISGRPD</DataLocation>
<DefaultData>DHCMGSSGRPRELHISGRPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGSSGRPRELHISGRPD</IdLocation>
<IndexLocation>^User.DHCMGSSGRPRELHISGRPI</IndexLocation>
<StreamLocation>^User.DHCMGSSGRPRELHISGRPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// 
/// ClassDescription:保存安全组子页面菜单、控件
/// Date:2015-02-12
Class DHCMGNUR.MgNurSecLayOut Extends %Persistent
{

Relationship ChildSub As DHCMGNUR.MgNurSecLayOutSub [ Cardinality = children, Inverse = layparref ];

/// 护理安全组
Property SecGrp As %String(TRUNCATE = 1);

Property laytitle As %String(TRUNCATE = 1);

Index secGrp On (SecGrp, laytitle);

ClassMethod deleteAll(rw) As %String
{
	s chl=""  f  s chl=$O(^DHCMGNUR.MgNurSecLayOutD(rw,"ChildSub",chl)) q:chl=""  d
	.s bb=##class(DHCMGNUR.MgNurSecLayOutSub).%DeleteId(rw_"||"_chl)
    q 0
}

ClassMethod Save(ssgrp, parr) As %String
{
	s ^TEMP("g201502131945001")=ssgrp_"%"_parr
	//parr="DHCNURPerResearch|DHCNURPerResearch,DHCNURPerResearch^addNew"
	s mouldcode= $ZConvert($P(parr,"|"),"U")
	s menuitm=$p(parr,"|",2)
	s mouldid=$O(^DHCMGNUR.MgChildPagEleI("Code"," "_mouldcode,""))
	i mouldid="" q 0
	i ssgrp'=""
	{
		s rw=$O(^DHCMGNUR.MgNurSecLayOutI("secGrp"," "_ssgrp," "_mouldid,""))
		i rw="" s obj=##class(DHCMGNUR.MgNurSecLayOut).%New()
		e  d
		.s obj=##class(DHCMGNUR.MgNurSecLayOut).%OpenId(rw)
		.s a=..deleteAll(rw)
		s obj.SecGrp=ssgrp
	}
	s obj.laytitle=mouldid
	s len=$L(menuitm,",")
	s TMP=""
	for i=1:1:len
	{
		s itm=$P(menuitm,",",i)
     	s paritm=$P(itm,"^")
     	s paritm=$ZConvert(paritm,"U")
     	s menuid=$O(^DHCMGNUR.MgChildPagEleI("Code"," "_paritm,""))
     	i menuid="" continue
     	s subitm=$P(itm,"^",2)
     	s subitm=$ZConvert(subitm,"U")
     	i subitm'=""
     	{
	     	i '$D(^DHCMGNUR.MgChildPagEleSubI("ItemCode"," "_subitm)) continue
	     	s subitmid=$O(^DHCMGNUR.MgChildPagEleSubI("ItemCode"," "_subitm,menuid,""))
	     	if '$D(TMP(menuid)) s TMP(menuid)=menuid_"||"_subitmid
	     	e  s $P(TMP(menuid),"^",($L(TMP(menuid),"^"))+1)=menuid_"||"_subitmid
     	}
     	else{
     		s TMP(menuid)=""
     	}
     	b ;01
	}
	s menu="" f  s menu=$O(TMP(menu)) q:menu=""  d
	.s b=##class(DHCMGNUR.MgNurSecLayOutSub).%New()
	.s b.layparref=obj
	.s b.laysubmoud=##class(DHCMGNUR.MgChildPagEle).%OpenId(menu)
	.s b.laysubitem=TMP(menu)
	.d b.%Save()
   q 0
}

Storage Default
{
<Data name="MgNurSecLayOutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SecGrp</Value>
</Value>
<Value name="3">
<Value>laytitle</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurSecLayOutD</DataLocation>
<DefaultData>MgNurSecLayOutDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurSecLayOutD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurSecLayOutI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurSecLayOutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class DHCMGNUR.MgNurQcModelChild Extends %Persistent
{

Relationship SunSub As DHCMGNUR.MgNurQcModChildSub [ Cardinality = children, Inverse = ParrefSub ];

Relationship Parref As DHCMGNUR.MgNurQcModel [ Cardinality = parent, Inverse = ChildSub, Required ];

Property ChildDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Child_Desc ];

Property ChildPar As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Child_Par ];

Property ChildRw As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = Child_Rw ];

Property ChildMinLev As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Child_MinLev ];

ClassMethod SaveChildSub(strsub) As %String
{
	s ^TEMP("g06141036001")=strsub //modelName|3^ChildDesc|身份识别^ChildPar|11^ChildRw|1^rowId|
	s tmp=""
	s aa=##class(web.DHCMgNurQcRestruct).settmp(strsub,.tmp)
	s id=$g(tmp("rowId"))
	i id="" d
	.s obj=##class(DHCMGNUR.MgNurQcModelChild).%New()
	.s obj.Parref=##class(DHCMGNUR.MgNurQcModel).%OpenId(tmp("modelName"))
	e  s obj=##class(DHCMGNUR.MgNurQcModelChild).%OpenId(tmp("modelName")_"||"_id)
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.MgNurQcModelChild","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s tmp(p)=$zcvt($tr(tmp(p)," ",""),"U")
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

ClassMethod isExistRec(strsub As %String) As %String
{
	s par=$P($P(strsub,"^",1),"|",2)
	s name=$zcvt($tr($P($P(strsub,"^",2),"|",2)," ",""),"U")
	s ret=0
	s raw="" f  s raw=$O(^DHCMGNUR.MgNurQcModelChildD(par,raw)) q:raw=""  d
	.s obj=##class(DHCMGNUR.MgNurQcModelChild).%OpenId(par_"||"_raw)
	.i obj.ChildDesc=name s ret=1
	q ret
}

ClassMethod delRecItm(par, raw) As %String
{
	d ##class(DHCMGNUR.MgNurQcModelChild).%DeleteId(par_"||"_raw)
	q 0
}

Storage Default
{
<Data name="MgNurQcModelChildDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QualItem</Value>
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
<Value>MinLevel</Value>
</Value>
<Value name="8">
<Value>ChildDesc</Value>
</Value>
<Value name="9">
<Value>ChildPar</Value>
</Value>
<Value name="10">
<Value>ChildRw</Value>
</Value>
<Value name="11">
<Value>ChildMinLev</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurQcModelChildD</DataLocation>
<DefaultData>MgNurQcModelChildDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurQcModelChildI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurQcModelChildS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

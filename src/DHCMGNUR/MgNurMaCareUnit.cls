/// Hospital:北京协和医院
/// Class Decription:大科护理单元维护
/// Date:2014-12-03
Class DHCMGNUR.MgNurMaCareUnit Extends %Persistent
{

/// 护理单元Code
Property WardLoc As %Integer [ SqlColumnNumber = 2 ];

/// 护理单元描述
Property WardDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 类型
Property WardTyp As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Index Typ On (WardTyp, WardLoc);

Index WardId On WardLoc;

ClassMethod Save(typ, qustr) As %String
{
	//typ_@_qustr=OutWard@1^2^3
	s ^TEMP("g20141204094801")=typ_"@"_qustr
	s l=$L(qustr,"^")
	s typ=$TR($ZConvert(typ,"U")," ","")
	s count=0
	 s qudr="" f  s qudr=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_typ,qudr)) q:qudr=""  d
	.s count=count+1
	for i=1:1:l
	{
	  s qudr=$P(qustr,"^",i)
	  if qudr="" continue
	  if '$D(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_typ,qudr))
	  {
	     s a=##class(DHCMGNUR.MgNurMaCareUnit).%New()
	     s a.WardLoc=qudr
	     s a.WardTyp=typ
	     d a.%Save()
	  }
	}
}

ClassMethod getselloc(typ)
{
	s ret=""
  	s typ=$TR($ZConvert(typ,"U")," ","")
  	s qudr="" f  s qudr=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_typ,qudr)) q:qudr=""  d
  	.s ret=ret_qudr_"^"
  	q ret
}

ClassMethod DelItem(typ As %String, LocId As %String) As %String
{
	s ^TEMP("g20141204114101")=typ_"@"_LocId
	s typ=$ZConvert(typ,"U")
	s ret=""
	s id=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_typ,LocId,""))
	TStart
	s obj=##class(DHCMGNUR.MgNurMaCareUnit).%OpenId(id)
	s sc = obj.%DeleteId(id)
	i $$$ISERR(sc)  
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q ret="删除失败"
	}
	else
	{
		TCommit
		q ret="删除成功"
	}
	q ret
}

Storage Default
{
<Data name="MgNurMaCareUnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardLoc</Value>
</Value>
<Value name="3">
<Value>WardDesc</Value>
</Value>
<Value name="4">
<Value>Exegesis</Value>
</Value>
<Value name="5">
<Value>WardTyp</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurMaCareUnitD</DataLocation>
<DefaultData>MgNurMaCareUnitDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurMaCareUnitD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurMaCareUnitI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurMaCareUnitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

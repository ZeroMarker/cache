/// Hospital:北京协和医院
/// Class　Description:大科维护表
/// Date:2014-12-10
Class DHCMGNUR.MgNurLargeLoc Extends %Persistent
{

/// 代码
Property LocCode As %Library.String [ SqlColumnNumber = 2, SqlFieldName = Loc_Code ];

/// 描述
Property LocDes As %Library.String [ SqlColumnNumber = 3, SqlFieldName = Loc_Des ];

Index Code On LocCode;

ClassMethod Save(parr As %String) As %String
{
	///parr="locCode|ccc^locDes|特殊^rw|"
	s ^TEM("g20141210094501")=parr
	s id=$P($P(parr,"^",3),"|",2)
	i id="" s obj=##class(DHCMGNUR.MgNurLargeLoc).%New()
	e  s obj=##class(DHCMGNUR.MgNurLargeLoc).%OpenId(id)
	s obj.LocCode=$P($P(parr,"^",1),"|",2)
	s obj.LocDes=$P($P(parr,"^",2),"|",2)
	d obj.%Save()
	q obj.%Id()
}

ClassMethod Modify(parr As %String) As %String
{
	q:parr="" 0
	;s ^TEMP("largeParr001")=parr
	s ret=0
	//parr="locCode|cs1^locDes|测试1^rw|13"
	s wardid=""
	s largeward=""
	s id=$P($P(parr,"^",3),"|",2)
	q:id="" 0
	s obj=##class(DHCMGNUR.MgNurLargeLoc).%OpenId(id)
	s largeCode=$ZConvert(obj.LocCode,"U")
	;s largeCode=$ZConvert($P($P(parr,"^",1),"|",2),"U")
	i largeCode'="" d
	.s wardid=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_largeCode,""))
	.s largeward=$O(^DHCMGNUR.DHCMgNurLarNurForLocI("Code"," "_largeCode,""))
	.i (wardid'="")!(largeward'="") d
	..s ret=1
	.e  s ret=0
	q ret
}

ClassMethod IsExist(str As %String) As %String
{
	;s ^TEMP("strIsExist001")=str
	s code=$ZConvert($P($P(str,"^",1),"|",2),"U")
	s rw=$P($P(str,"^",3),"|",2)
	s flag=""
	s id=$O(^DHCMGNUR.MgNurLargeLocI("Code"," "_code,""))
	q:id="" 1
	i id=rw s flag=1
	e  s flag=0
	q flag
}

ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.MgNurLargeLoc).%OpenId(id)
	s code=$ZConvert(object.LocCode,"U")
	s rid=$O(^DHCMGNUR.DHCMgNurLarNurForLocI("Code"," "_code,""))
	i rid'="" q "exist"
	s sc = object.%DeleteId(id)
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
<Data name="MgNurLargeLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocCode</Value>
</Value>
<Value name="3">
<Value>LocDes</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurLargeLocD</DataLocation>
<DefaultData>MgNurLargeLocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurLargeLocD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurLargeLocI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurLargeLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

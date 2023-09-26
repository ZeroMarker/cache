/// Hospital:北京协和医院
/// Class Decription:大科护士长关联大科
/// Date:2014-12-10
Class DHCMGNUR.DHCMgNurLarNurForLoc Extends %Persistent
{

/// 大科护士长ID
Property NurseId As %Library.String [ SqlColumnNumber = 2, SqlFieldName = Nurse_Id ];

/// 大科ID
Property LocCode As %Library.String [ SqlColumnNumber = 3, SqlFieldName = Loc_Code ];

Index Code On LocCode;

Index Typ On (NurseId, LocCode);

ClassMethod Save(parr As %String) As %String
{
	s id=$P($P(parr,"^",3),"|",2)
	s nurseHead=$P($P(parr,"^",1),"|",2)
	s nurseLoc=$P($P(parr,"^",2),"|",2)
	i id="" s a=##class(DHCMGNUR.DHCMgNurLarNurForLoc).%New()
	s a.NurseId=nurseHead
	s a.LocCode=nurseLoc
	d a.%Save()
	q a.%Id()
}

ClassMethod IsExistRec(parr As %String) As %String
{
	s ret=0
	s nurseid=$P($P(parr,"^",1),"|",2)
	s largeloc=$zcvt($P($P(parr,"^",2),"|",2),"U")
	s rw=$O(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_nurseid," "_largeloc,""))
	i rw'="" s ret=1
	q ret
}

ClassMethod delItem(id As %String) As %String
{
	TStart
	s object=##class(DHCMGNUR.DHCMgNurLarNurForLoc).%OpenId(id)
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
<Data name="DHCMgNurLarNurForLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NurseId</Value>
</Value>
<Value name="3">
<Value>LocCode</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.DHCMgNurLarNurForLocD</DataLocation>
<DefaultData>DHCMgNurLarNurForLocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.DHCMgNurLarNurForLocD</IdLocation>
<IndexLocation>^DHCMGNUR.DHCMgNurLarNurForLocI</IndexLocation>
<StreamLocation>^DHCMGNUR.DHCMgNurLarNurForLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

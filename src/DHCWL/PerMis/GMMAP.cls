Class DHCWL.PerMis.GMMAP Extends %Persistent
{

Property GrpDr As Grp;

Property UserDr As User.SSUser;

Index InxGM On (GrpDr, UserDr);

ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""

	s grpID=inParam("grpID")
	s userIDs=inParam("userIDs")
	s cnt=$l(userIDs,",")
	if cnt=0 q ""
	
	s grpObj=##class(Grp).%OpenId(grpID)
	f i=1:1:cnt {
		s uid=$p(userIDs,",",i)
		s usrObj=##class(User.SSUser).%OpenId(uid)
		s newObj=##class(GMMAP).%New()
		s newObj.GrpDr=grpObj
		s newObj.UserDr=usrObj
		s sc=newObj.%Save()
		If $$$ISERR(sc) {
			s ret="组-组内用户失败:"_$System.Status.GetErrorText(sc)
			q
	 	}
	 	d newObj.%Close()				
	}
		
	q ret
SQLErr
	if ret="" s ret="新建报表-组关系失败:"_$ZERROR
	q ret
}

Storage Default
{
<Data name="GMMAPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GrpDr</Value>
</Value>
<Value name="3">
<Value>UserDr</Value>
</Value>
</Data>
<DataLocation>^DHCWL.PerMis.GMMAPD</DataLocation>
<DefaultData>GMMAPDefaultData</DefaultData>
<IdLocation>^DHCWL.PerMis.GMMAPD</IdLocation>
<IndexLocation>^DHCWL.PerMis.GMMAPI</IndexLocation>
<StreamLocation>^DHCWL.PerMis.GMMAPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

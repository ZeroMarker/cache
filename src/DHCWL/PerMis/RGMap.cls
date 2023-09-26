/// add by wz .2018-08/// d ##class(DHCWL.PerMis.RGMap).%BuildIndices()
Class DHCWL.PerMis.RGMap Extends %Persistent
{

Property RptTool As %String(COLLATION = "EXACT");

Property RptID As %String(COLLATION = "EXACT");

Property GrpDr As Grp;

Index InxRG On (RptTool, RptID, GrpDr);

Index InxGR On (GrpDr, RptID);

ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	s grpIDs=inParam("grpIDs")
	s rptID=inParam("rptID")
	s rptTool=inParam("rptTool")
	s cnt=$l(grpIDs,",")
	
	q:cnt=0 ""
	for i=1:1:cnt {
		s grpID=$p(grpIDs,",",i)
		s grpObj=##class(Grp).%OpenId(grpID)
		s newObj=##class(RGMap).%New()
		s newObj.RptTool=rptTool
		s newObj.RptID=rptID
		s newObj.GrpDr=grpObj
		s sc=newObj.%Save()
		If $$$ISERR(sc) {
			s ret="新建报表-组关系失败:"_$System.Status.GetErrorText(sc)
			q
	 	}
	 	d newObj.%Close()
	}
	q ret
SQLErr
	if ret="" s ret="新建报表-组关系失败:"_$ZERROR
	q ret
}

ClassMethod DelByID(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	s ID=inParam("ID")
	
	//1、删除表
	&sql(DELETE FROM DHCWL_PerMis.RGMap WHERE ID=:ID)
	if SQLCODE<0 {
		Trollback
		s ret="删除 'DHCWL_PerMis.RGMap'对象失败:SQLCODE="_SQLCODE
		q ret
	}

	q ret
}

Storage Default
{
<Data name="RGMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RptTool</Value>
</Value>
<Value name="3">
<Value>RptID</Value>
</Value>
<Value name="4">
<Value>GrpDr</Value>
</Value>
</Data>
<DataLocation>^DHCWL.PerMis.RGMapD</DataLocation>
<DefaultData>RGMapDefaultData</DefaultData>
<IdLocation>^DHCWL.PerMis.RGMapD</IdLocation>
<IndexLocation>^DHCWL.PerMis.RGMapI</IndexLocation>
<StreamLocation>^DHCWL.PerMis.RGMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

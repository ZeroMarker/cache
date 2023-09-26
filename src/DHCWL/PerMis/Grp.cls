Class DHCWL.PerMis.Grp Extends %Persistent
{

/// 名称
Property Code As %String(COLLATION = "EXACT");

/// 描述
Property Descript As %String(MAXLEN = 150);

/// 编码 add by wz.2018-08
Property Name As %String(COLLATION = "EXACT");

Index InxCode On Code;

ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	s existObj=..GetByCode(inParam("Code"))
	q:$ISOBJECT(existObj) "编码已存在"
	s newObj=##class(DHCWL.PerMis.Grp).%New()
	s newObj.Code=inParam("Code")
	s newObj.Descript=inParam("Descript")
	s newObj.Name=inParam("Name")
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="新增 'Group'对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	s inParam("NEWID")=newObj.%Id() 
	d newObj.%Close()

	q ret
	
SQLErr
	if ret="" s ret="新增 'grp'对象失败:"_$ZERROR
	q ret
}

ClassMethod GetByCode(Code As %String) As Grp
{
	q:Code="" ""
	q:'$d(^DHCWL.PerMis.GrpI("InxCode",Code)) ""
  	s id=$o(^DHCWL.PerMis.GrpI("InxCode",Code,""))
	q:id="" ""
	q ##class(Grp).%OpenId(id)
}

ClassMethod Delete(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	s code=inParam("Code")
	TSTART
	//1、删除表
	&sql(DELETE FROM DHCWL_PerMis.Rpt WHERE GrpCode=:code)
	if SQLCODE<0 {
		Trollback
		s ret="DELETE 'DHCWL_PerMis.Rpt'对象失败:SQLCODE="_SQLCODE
		q ret
	}
	//2、删除用户
	&sql(DELETE FROM DHCWL_PerMis.Member WHERE GrpCode=:code)
	if SQLCODE<0 {
		Trollback
		s ret="DELETE 'DHCWL_PerMis.Member'对象失败:SQLCODE="_SQLCODE
		q ret
	}	
	//3、删除组
	&sql(DELETE FROM DHCWL_PerMis.Grp WHERE Code=:code)
	if SQLCODE<0 {
		Trollback
		s ret="DELETE 'DHCWL_PerMis.Grp'对象失败:SQLCODE="_SQLCODE
		q ret
	}	
	
	TCOMMIT
	q ret
}

ClassMethod DelByID(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	s ID=inParam("ID")
	if 1 {
		if $d(^DHCWL.PerMis.GMMAPI("InxGM",ID)) {
			s ret="请先删除组下的人员"
			q ret
		}
		if $d(^DHCWL.PerMis.RGMapI("InxGR",ID)) {
			s ret="请先删除与该组关联的报表"
			q ret
		}
		
		//3、删除组
		&sql(DELETE FROM DHCWL_PerMis.Grp WHERE ID=:ID)
		if SQLCODE<0 {
			Trollback
			s ret="DELETE 'DHCWL_PerMis.Grp'对象失败:SQLCODE="_SQLCODE
			q ret
		}	
	}else{
		TSTART
		//1、删除表
		&sql(DELETE FROM DHCWL_PerMis.RGMap WHERE GrpDr=:ID)
		if SQLCODE<0 {
			Trollback
			s ret="删除 'DHCWL_PerMis.RGMap'对象失败:SQLCODE="_SQLCODE
			q ret
		}
		//2、删除用户
		&sql(DELETE FROM DHCWL_PerMis.GMMAP WHERE GrpDr=:ID)
		if SQLCODE<0 {
			Trollback
			s ret="DELETE 'DHCWL_PerMis.GMMAP'对象失败:SQLCODE="_SQLCODE
			q ret
		}	
	
		//3、删除组
		&sql(DELETE FROM DHCWL_PerMis.Grp WHERE ID=:ID)
		if SQLCODE<0 {
			Trollback
			s ret="DELETE 'DHCWL_PerMis.Grp'对象失败:SQLCODE="_SQLCODE
			q ret
		}	
		TCOMMIT		
	}
	q ret
}

ClassMethod Update(ByRef inParam, ByRef outParam) As %String
{
	s ret=""
	s obj=##class(Grp).%OpenId(inParam("ID"))
	s obj.Name=inParam("Name")
	s obj.Descript=inParam("Descript")

	s sc=obj.%Save()
	If $$$ISERR(sc) {
		s ret="更新'Group'对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}

	d obj.%Close()

	q ret
}

Storage Default
{
<Data name="GrpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Descript</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^DHCWL.PerMis.GrpD</DataLocation>
<DefaultData>GrpDefaultData</DefaultData>
<IdLocation>^DHCWL.PerMis.GrpD</IdLocation>
<IndexLocation>^DHCWL.PerMis.GrpI</IndexLocation>
<StreamLocation>^DHCWL.PerMis.GrpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

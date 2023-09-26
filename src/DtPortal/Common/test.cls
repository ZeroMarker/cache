Class DtPortal.Common.test Extends %RegisteredObject
{

/// w ##class(DtPortal.Common.test).testClassMethod()
ClassMethod testClassMethod() As %String
{
	/*
	//测试方法1：通过接口客户端调用
	s objtest = ##class(%GlobalCharacterStream).%New()
	//d objtest.Write("testuser2^0^6^[{""name"":""sEcho"",""value"":1},{""name"":""iColumns"",""value"":2},{""name"":""sColumns"",""value"":""""},{""name"":""iDisplayStart"",""value"":0},{""name"":""iDisplayLength"",""value"":5},{""name"":""mDataProp_0"",""value"":""businessTitle""},{""name"":""mDataType_0""},{""name"":""mDataProp_1"",""value"":""started""},{""name"":""mDataType_1""},{""name"":""iSortCol_0"",""value"":1},{""name"":""sSortDir_0"",""value"":""desc""},{""name"":""iSortingCols"",""value"":1},{""name"":""bSortable_0"",""value"":true},{""name"":""bSortable_1"",""value"":true},{""name"":""type"",""value"":""1""}]")
	
	d objtest.Write("{"data":"27^10^0^23^0","status":"1"}")
	;d objtest.Write("3728,X")
	set soap=##class(SOAP.Test.TodoListServiceHttpPort).%New()
	set result=soap.getToDoListData(objtest)
	w result.Read()
	b ;0222
	q ""
	*/
	
	/*
	//测试方法2：通过平台调用
	set client=##class(DtPortalWS.MyEnsembleRequestWebServiceSoap).%New()
	s arg=##Class(%GlobalCharacterStream).%New()
	d arg.Write("906")
	set ret=client.GetServiceInfo("C80.02.01",arg)
	b ;1
	w ret.Read()
	quit ""
	*/
	
	
	//测试方法3：不经过平台，直接调用 
	s clsName="DtPortal.DD.DD01EmphasisFocus"
	s queryName="EmphasisFocusNum"
	s objtest = ##class(%GlobalCharacterStream).%New()
	;d objtest.Write("0^0^8a81bff0479f361c01479fb2388c0008^reshenqing^001^001^001^11e41ba005cbb1e9b2b99d4461b27a7e^<data><property name='Title' value='765'/><property name='RecordTypeID' value='SCIE'/><property name='RecordTypeID_CODE' value='1'/><property name='SubUser' value='毛羽'/><property name='SubUser_CODE' value='001'/><property name='SubUserDept' value='WYKMZ-外一科门诊'/><property name='SubUserDept_CODE' value='外一科门诊'/><property name='JournalName' value='教育类核心期刊'/><property name='JournalName_CODE' value='N001'/><property name='Ptype' value='国外'/><property name='Ptype_CODE' value='2'/><property name='FirstAuthor' value='毛羽'/><property name='FirstAuthor_CODE' value='001'/><property name='FirstAuthorDept' value='WYKMZ-外一科门诊'/><property name='FirstAuthorDept_CODE' value='外一科门诊'/><property name='TFAuthor' value='毛羽'/><property name='TFAuthor_CODE' value='001'/><property name='TFAuthorDept' value='WYKMZ-外一科门诊'/><property name='TFAuthorDept_CODE' value='外一科门诊'/><property name='CorrAuthor' value='毛羽'/><property name='CorrAuthor_CODE' value='001'/><property name='CorrAuthorDept' value='WYKMZ-外一科门诊'/><property name='CorrAuthorDept_CODE' value='外一科门诊'/><property name='TCAuthor' value='毛羽'/><property name='TCAuthor_CODE' value='001'/><property name='TCAuthorDept' value='WYKMZ-外一科门诊'/><property name='TCAuthorDept_CODE' value='外一科门诊'/></data>")
	;d objtest.Write("0^0^8a81bff0479f361c01479fb2388c0008^reshenqing^001^001^001^11e41ba005cbb1e9b2b99d4461b27a7e^<data><property name=""Title"" value=""765""/><property name=""RecordTypeID"" value=""SCIE""/><property name=""RecordTypeID_CODE"" value=""1""/><property name=""SubUser"" value=""毛羽""/><property name=""SubUser_CODE"" value=""001""/><property name=""SubUserDept"" value=""WYKMZ-外一科门诊""/><property name=""SubUserDept_CODE"" value=""外一科门诊""/><property name=""JournalName"" value=""教育类核心期刊""/><property name=""JournalName_CODE"" value=""N001""/><property name=""Ptype"" value=""国外""/><property name=""Ptype_CODE"" value=""2""/><property name=""FirstAuthor"" value=""毛羽""/><property name=""FirstAuthor_CODE"" value=""001""/><property name=""FirstAuthorDept"" value=""WYKMZ-外一科门诊""/><property name=""FirstAuthorDept_CODE"" value=""外一科门诊""/><property name=""TFAuthor"" value=""毛羽""/><property name=""TFAuthor_CODE"" value=""001""/><property name=""TFAuthorDept"" value=""WYKMZ-外一科门诊""/><property name=""TFAuthorDept_CODE"" value=""外一科门诊""/><property name=""CorrAuthor"" value=""毛羽""/><property name=""CorrAuthor_CODE"" value=""001""/><property name=""CorrAuthorDept"" value=""WYKMZ-外一科门诊""/><property name=""CorrAuthorDept_CODE"" value=""外一科门诊""/><property name=""TCAuthor"" value=""毛羽""/><property name=""TCAuthor_CODE"" value=""001""/><property name=""TCAuthorDept"" value=""WYKMZ-外一科门诊""/><property name=""TCAuthorDept_CODE"" value=""外一科门诊""/></data>")
	d objtest.Write("762")
	s tse= ##class(DtPortal.Common.Data2JsonService).%New()
	set outPut=tse.GetClassMethodData(clsName,queryName,objtest)
	w "888="_outPut.Read()
	b ///ceshi
	q outPut.Read()
}

/// w ##Class(DtPortal.Common.test).testQueryMethod()
ClassMethod testQueryMethod() As %String
{
	/*
	s objtest = ##class(%GlobalCharacterStream).%New()
	d objtest.Write("1,10,,,,")
	set soap=##class(SOAP.Test.Data2JsonServiceSoap).%New()
	set result=soap.GetQueryData("DtPortal.Doctor.ScientificResearch","ScientificSubjQuery",objtest)
	b ;0222
	
	//测试方法1：通过平台调用
	set client=##class(DtPortalWS.MyEnsembleRequestWebServiceSoap).%New()
	s arg=##Class(%GlobalCharacterStream).%New()
	d arg.Write(",,834")
	set ret=client.GetServiceInfo("D02.10.02",arg)
	b ///123
	w ret.Read()
	quit ""
	*/
	
	//##class(%ResultSet).RunQuery("DtPortal.Doctor.ClinicPrompt.TemperatureAnomalies","TemperatureAnomaliesQuery","")
	//d ##class(%ResultSet).RunQuery("HRweb.RunqianQueryHr","GetPersonInfoByEmpCard","001^601")
	//测试方法2：不经过平台，直接调用
	s clsName="DtPortal.MD.MD10InfectionAlert"
	s queryName="FindMoreWarningPat"
	s objtest = ##class(%GlobalCharacterStream).%New()
	;d objtest.Write("0^0^8a81bff0479f361c01479fb2388c0008^reshenqing^001^001^001^11e41ba005cbb1e9b2b99d4461b27a7e^<data><property name=""Title"" value=""765""/><property name=""RecordTypeID"" value=""SCIE""/><property name=""RecordTypeID_CODE"" value=""1""/><property name=""SubUser"" value=""毛羽""/><property name=""SubUser_CODE"" value=""001""/><property name=""SubUserDept"" value=""WYKMZ-外一科门诊""/><property name=""SubUserDept_CODE"" value=""外一科门诊""/><property name=""JournalName"" value=""教育类核心期刊""/><property name=""JournalName_CODE"" value=""N001""/><property name=""Ptype"" value=""国外""/><property name=""Ptype_CODE"" value=""2""/><property name=""FirstAuthor"" value=""毛羽""/><property name=""FirstAuthor_CODE"" value=""001""/><property name=""FirstAuthorDept"" value=""WYKMZ-外一科门诊""/><property name=""FirstAuthorDept_CODE"" value=""外一科门诊""/><property name=""TFAuthor"" value=""毛羽""/><property name=""TFAuthor_CODE"" value=""001""/><property name=""TFAuthorDept"" value=""WYKMZ-外一科门诊""/><property name=""TFAuthorDept_CODE"" value=""外一科门诊""/><property name=""CorrAuthor"" value=""毛羽""/><property name=""CorrAuthor_CODE"" value=""001""/><property name=""CorrAuthorDept"" value=""WYKMZ-外一科门诊""/><property name=""CorrAuthorDept_CODE"" value=""外一科门诊""/><property name=""TCAuthor"" value=""毛羽""/><property name=""TCAuthor_CODE"" value=""001""/><property name=""TCAuthorDept"" value=""WYKMZ-外一科门诊""/><property name=""TCAuthorDept_CODE"" value=""外一科门诊""/></data>")
	d objtest.Write(""_$C(9813)_""_$C(9813)_"2016-3-1"_$C(9813)_"2016-4-1"_$C(9813)_""_$C(9813)_"")
	;d objtest.Write()
	s tse= ##class(DtPortal.Common.Data2JsonService).%New()
	set outPut=tse.GetQueryData(clsName,queryName,objtest)
	b ///ceshi
	q outPut.Read()
}

/// w ##Class(DtPortal.Common.test).testMineService()
ClassMethod testMineService()
{
	s soap = ##class(DtPortalTest.mine.Data2JsonServiceSoap).%New()
	s params = ##Class(%GlobalCharacterStream).%New()
	
	d params.Write("001")
	s methodResult = soap.GetClassMethodData("DtPortal.Doctor.DHCDocComService","GetLocNameByUserCode",params)
	q methodResult.Read()
}

// w ##class(DtPortal.Common.test).testOAService()

ClassMethod testOAService()
{
	
	s soap = ##class(DtPortalTest.OA.DraftsListServiceHttpPort).%New()
	
	s obj = ##class(%GlobalCharacterStream).%New()
	d obj.Write("testuser2^0^6^[{""name"":""sEcho"",""value"":1},{""name"":""iColumns"",""value"":2},{""name"":""sColumns"",""value"":""""},{""name"":""iDisplayStart"",""value"":0},{""name"":""iDisplayLength"",""value"":5},{""name"":""mDataProp_0"",""value"":""businessTitle""},{""name"":""mDataType_0""},{""name"":""mDataProp_1"",""value"":""started""},{""name"":""mDataType_1""},{""name"":""iSortCol_0"",""value"":1},{""name"":""sSortDir_0"",""value"":""desc""},{""name"":""iSortingCols"",""value"":1},{""name"":""bSortable_0"",""value"":true},{""name"":""bSortable_1"",""value"":true},{""name"":""type"",""value"":""1""}]")
	
	s result = soap.getDraftsListData(obj)
	q result
}

}

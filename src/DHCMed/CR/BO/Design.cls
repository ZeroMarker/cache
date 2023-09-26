/// 名称: DHCMed.CR.BO.Design
/// 描述: 表单设计器服务
/// 编写者：wuqk
/// 编写日期: 2012-11-22
Class DHCMed.CR.BO.Design Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     wuqk
/// CreatDate：   2012-11-23
/// Description:  保存设计表单和运行表单
/// Table：       DHCMed.CR.PO.FormVer
/// Input：       %request
/// Return：      
/// w ##class(DHCMed.CR.BODesign).SaveLayout()
ClassMethod SaveLayout() As %String
{
	Set $ZT="SaveLayoutErr"
	
	set return = "{Result:false,Message:'"
	
	//m ^tmpcrf("saveDj",$j,$h)=%request.Data
	set formID = +%request.Get("ID",1)
	set VerID = %request.Get("VerID",1)
	quit:'##class(DHCMed.CR.PO.FormVer).%ExistsId(VerID) return_"Not Found Form Version id="_VerID_"'}"
	
	set objFormVer = ##class(DHCMed.CR.PO.FormVer).%OpenId(VerID)
	
	set djLayout = objFormVer.djLayout //##class(%Library.GlobalCharacterStream).%New()
	set key="sdjLayout"
	//Modified By LiYang 2014-05-15 FixBug：按序获取流信息
	Set i=0
	for {
		set strLine=%request.Get(key_i,1)
		quit:strLine=""
		do djLayout.WriteLine(strLine)
		Set i=i+1
	}
	do objFormVer.djLayout.WriteLine("")
	do objFormVer.djLayout.Flush()
	
	set htmlLayout = objFormVer.htmlLayout
	set key="shtmlLayout"
	do htmlLayout.WriteLine(%request.Get(key,1))
	Set i=0
	for {
		set strLine=%request.Get(key_i)
		quit:strLine=""
		do htmlLayout.WriteLine(strLine)
		Set i=i+1
	}
	do objFormVer.htmlLayout.WriteLine("")
	Do objFormVer.htmlLayout.Flush()
	
	set sc=objFormVer.%Save()
	if $$$ISERR(sc){
		set return = return_sc_"'}" //Modified By LiYang 2014-05-13 为老版本数据库提供兼容
	}
	else{
		set return = "{Result:true}"
	}
	quit return
SaveLayoutErr
	set return = "{Result:false,Message:'"_$ZE_"'}"
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2012-11-26
/// Description:  保存表单存储结构
/// Table：       DHCMed.CR.PO.Form
/// Input：       %request
/// Return：      
/// w ##class(DHCMed.CR.BO.Design).SaveStructure()
ClassMethod SaveStructure() As %String
{
	Set $ZT="SaveStructureErr"
	
	set return = "{Result:false,Message:'"
	
	//m ^tmpcrf("saveStruct",$j,$h)=%request.Data
	set formID = +%request.Get("formID",1)
	//set formID = +^tmpcrf("saveStruct",6380,"62788,65008","formID",1)
	quit:'##class(DHCMed.CR.PO.Form).%ExistsId(formID) return_"Not Found Form id="_formID_"'}"
	
	tStart
	
	set sFormControlList = %request.Get("sFormControlList",1)
	//set sFormControlList = ^tmpcrf("saveStruct",6380,"62788,65008","sFormControlList",1)
	
	set fields=##class(DHCMed.CR.Util.JsonObject).ObjectListFromJSON(sFormControlList,"DHCMed.CR.PO.MetaData")

	set objForm = ##class(DHCMed.CR.PO.Form).%OpenId(formID)
	set clsflag = ..DefiendClass(objForm,fields)
	if +clsflag<0 {
		tRollBack
		set return = "{Result:false,Message:'"_clsflag_"'}"
		quit return	
	}
	
	set metflag = ..UpdateMetData(fields)
	if +metflag<0 {
		tRollBack
		set return = "{Result:false,Message:'"_metflag_"'}"
		quit return	
	}
	
	tCommit
	set return = "{Result:true}"
	q return
SaveStructureErr
	tRollBack
	set return = "{Result:false,Message:'"_$ZE_"'}"
	quit return
}

/// Creator : wuqk
/// CreatDate : 2012-11-12
/// Description : 持久类定义
/// Input : 
///        objForm
///        list of MetaData
/// Output ：
/// Return ：成功标记
/// w ##class(DHCMed.CR.BODesign).DefiendClass(objForm,fields)
ClassMethod DefiendClass(objForm As DHCMed.CR.PO.Form, fields As %ListOfObjects)
{
	new (objForm,fields)
	set flag=0
	quit:'$IsObject(objForm) flag
	quit:'$IsObject(fields) flag
	
	Set $ZT="DefiendClassErr"
	
	set ClassName=objForm.ESchema_"."_objForm.Type_"."_objForm.EName
	if ##class(%Dictionary.ClassDefinition).%ExistsId(ClassName){
		set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
	}
	else{
		set cdef = ##class(%Dictionary.ClassDefinition).%New(ClassName)
		set cdef.Super = "DHCMed.CR.PO.Data" //"%Persistent,%XML.Adaptor"
		set cdef.ClassType = "persistent"
		set cdef.Owner= ""
		
		//为避免不同包中的同名类因为 超类的 %XML.Adaptor默认XMLType问题出现异常
		set parameter = ##class(%Dictionary.ParameterDefinition).%New()
		set parameter.Name = "XMLTYPE"
		set parameter.Default = ClassName
		do cdef.Parameters.Insert(parameter)
		
		//set pdef = ##class(%Dictionary.PropertyDefinition).%New("RowId")
		//do cdef.Properties.Insert(pdef)
		//set pdef.Name="RowId"
		//set pdef.Type="%String"
	}
	
		
	set cnt=fields.Count()
	for i=1:1:cnt {
		;#dim objField As Entity.MetaData //Modified By LiYang 2014-05-13 为老版本数据库提供兼容
		set objField=fields.GetAt(i)
		set propertyName=objField.ColEName
		set pdef=$$GetPropertyByName(cdef,propertyName)
		if pdef="" {
			set pdef = ##class(%Dictionary.PropertyDefinition).%New(propertyName)
			do cdef.Properties.Insert(pdef)
			set pdef.Name=objField.ColEName
		}
		set pdef.Description=objField.ColCName
		set pdef.Type=objField.ColDataType
		//do:pdef.Type="%String" pdef.Parameters.SetAt(objField.ColLength,"MAXLEN")
		//do pdef.Parameters.SetAt(1,"TRUNCATE")
		if (pdef.Type="%String") {
			Set:objField.ColLength="undefined" objField.ColLength=100
			Do pdef.Parameters.SetAt(objField.ColLength,"MAXLEN")
		}

	}
	set sc = cdef.%Save()
	if $$$ISERR(sc) {
		set error = $System.Status.GetErrorText(sc)
		quit "-2^%SaveError^"_error
	}
	set cc = $System.OBJ.Compile(ClassName, "-d")	
	if $$$ISERR(cc) {
		set error = $System.Status.GetErrorText(cc)
		quit "-c^CompileClass^"_error
	}
	q $$$OK
GetPropertyByName(cdef,propertyName)
	n (cdef,propertyName)
	set ret=""
	set pcnt=cdef.Properties.Count()
	for i=1:1:pcnt {
		set pdef=cdef.Properties.GetAt(i)
		set:propertyName=pdef.Name ret=pdef
		quit:ret'=""
	}
	quit ret
	
DefiendClassErr
	quit "-1"_$ze
}

/// Creator : wuqk
/// CreatDate : 2012-11-12
/// Description : 保存原数据定义
/// Input : list of MetaData
/// Output ：
/// Return ：成功标记
/// w ##class(DHCMed.CR.BODesign).UpdateMetData(fields)
ClassMethod UpdateMetData(fields As %ListOfObjects)
{
	new (fields)
	set cnt=fields.Count()
	for i=1:1:cnt {
		;#dim objField As DHCMed.CR.BO.DataModel //Modified By LiYang 2014-05-13 为老版本数据库提供兼容
		set objField=fields.GetAt(i)
		set propertyName=objField.ColEName
		set formID=objField.FormID
		if $d(^DHCMed.CR.PO.MetaDataI("IndexUnique",formID," "_$zcvt(propertyName,"u"))) {
			set id=$o(^DHCMed.CR.PO.MetaDataI("IndexUnique",formID," "_$zcvt(propertyName,"u"),""))
			set tmpField=##class(DHCMed.CR.PO.MetaData).%OpenId(id)
			set tmpField.ColCName=objField.ColCName
			set tmpField.ColDataType=objField.ColDataType
			set tmpField.ColLength=objField.ColLength
		}
		else{
			set tmpField=objField
		}
		set sc=tmpField.%Save()
	}
	quit $$$OK
}

}

Class EMRservice.Ajax.MedicalCalculate Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	if (action = "getitem"){
		s name = $g(%request.Data("Name",1),"")
		q:(name = "")
		w ..GetItem(name)	
	}
	elseif (action = "additem"){
		s param = $g(%request.Data("Param",1),"")
		d ..AddItem(param)
	}
	Quit $$$OK
}

/// w ##Class(EMRservice.Ajax.MedicalCalculate).GetItem("IBW")
ClassMethod GetItem(name)
{
	s formulaindex = ""
	s json = ""
	s Uname = $zcvt(name,"U")
	for{
		//b "s"
		s formulaindex = $o(^DHCEMRM.MedicalCalculateI("IdxCode", " "_Uname, formulaindex))
		q:(formulaindex = "")
		s object = ##Class(EMRmeta.MedicalCalculate).%OpenId(formulaindex)
		q:(object = "")
		s json = json_"{"
		s json = json_"""Code"":"""_object.Code
		s json = json_""",""Description"":"""_object.Description
		s json = json_""",""Variable"":"""_object.Variable
		s json = json_""",""VarDesc"":"""_object.VarDesc
		s json = json_""",""VarType"":"""_object.VarType
		s json = json_""",""VarUnit"":"""_object.VarUnit
		s json = json_""",""VarParam"":"""_object.VarParam
		s json = json_""",""Formula"":"""_object.Formula
		s json = json_""",""Result"":"""_object.Result
		s json = json_""",""ResDesc"":"""_object.ResDesc
		s json = json_""",""ResUnit"":"""_object.ResUnit
		s json = json_""",""Precision"":"_object.Precision_"}"
		d object.%Close()
	}
	s json = $ZSTRIP(json,"*C")
	q json
}

ClassMethod AddItem(param)
{
	s paramlist = split(param,"$")
	s length = paramlist.length
	s object = ##class(EMRmeta.MedicalCalculate).%New()
	TSTART
	s object.Code = $p(paramlist(1),":")
	s object.Description = $p(paramlist(2),":")
	s object.Variable = $p(paramlist(3),":")
	s object.VarDesc = $p(paramlist(4),":")
	s object.VarType = $p(paramlist(5),":")
	s object.VarUnit = $p(paramlist(6),":")
	s object.VarParam = $p(paramlist(7),":")
	s object.Formula = $p(paramlist(8),":")
	s object.Result = $p(paramlist(9),":")
	s object.ResDesc = $p(paramlist(10),":")
	s object.ResUnit = $p(paramlist(11),":")
	s object.Precision = $p(paramlist(12),":")
	d object.%Save()
	if $$$ISERR(sc){
		TROLLBACK
	}
	else{
		TCOMMIT
	}
}

Storage Default
{
<Data name="MedicalCalculateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EMRservice7C21.MedicalCalc5775D</DataLocation>
<DefaultData>MedicalCalculateDefaultData</DefaultData>
<IdLocation>^EMRservice7C21.MedicalCalc5775D</IdLocation>
<IndexLocation>^EMRservice7C21.MedicalCalc5775I</IndexLocation>
<StreamLocation>^EMRservice7C21.MedicalCalc5775S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class web.DHCENS.Method.PageLoad Extends %CSP.Page
{

Parameter CONTENTTYPE = "text/plain;charset=UTF-8";

ClassMethod OnPage() As %Status
{
	set action=$g(%request.Data("action",1))
	set input=$g(%request.Data("input",1))
	set page=$g(%request.Data("page",1))
	set rows=$g(%request.Data("rows",1))
	
	if action="methodlist" {
		set sc=##class(web.DHCENS.Method.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.Method.EnsInterfaceMethod","GetEnsInterfaceMethodData",input,page,rows)
	}elseif action="methodProcuctionTermlist" {
		set sc=##class(web.DHCENS.Method.CreateJson).GetDataInfoListShowCombox("web.DHCENS.Method.EnsInterfaceMethod","GetMethodProcuctionTermData",input)
	}elseif action="hisVersionlist" {
		set sc=##class(web.DHCENS.Method.CreateJson).GetDataInfoListShowCombox("web.DHCENS.Method.EnsInterfaceMethod","GetHisVersionTermData",input)
	}elseif action="methodDetail" {
		set sc=##class(web.DHCENS.Method.CreateJson).GetDataDetailInfo("web.DHCENS.Method.EnsInterfaceMethod","GetEnsInterfaceMethodDetailInfo",input)
	}elseif action="methodCode" {
		set result=##class(web.DHCENS.Method.EnsInterfaceMethod).getMethodCode()
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_$p(result,"^",2)_"""}"
	}elseif action="delMethodData" {
		set result=##class(web.DHCENS.Method.EnsInterfaceMethod).delEnsInterfaceMethodInfo(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_$p(result,"^",2)_"""}"
	}elseif action="saveMethodData" {		
		s inLength=%request.Count("input")
		for i=1:1:inLength {
			s input(i)=$g(%request.Data("input",i))
		}
		s j=0
		s tmpAllPar=""
		do {
			s tmpPar=""
			s parLength=%request.Count("inGd"_j)
			for i=1:1:parLength {
				s params(i)=$g(%request.Data("inGd"_j,i))
				if (""=tmpPar) {
					s tmpPar=params(i)
				}else {
					s tmpPar=tmpPar_$char(2)_params(i) //单条之间分割暂定 ^
				}
			}
			if (tmpPar'=""){
				s tmpPar=tmpPar_$char(28) //多条之间分割暂定 ###
				if (""=tmpAllPar) {
					s tmpAllPar=tmpPar
				}else {
					s tmpAllPar=tmpAllPar_tmpPar
				}
			}
			s j=j+1
		}while($d(%request.Data("inGd"_j,1)))
		set length=$l(tmpAllPar,$char(28))
		set tmpAllPar=$p(tmpAllPar,$char(28),1,length-1)
		set result=##class(web.DHCENS.Method.EnsInterfaceMethod).SaveEnsInterfaceMethodInfo(tmpAllPar,input(1),input(2),input(3),input(4),input(5),input(6),input(7),input(8),input(9),input(10),input(11),input(12))
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif action="updateMethodStatus" {
		set result=##class(web.DHCENS.Method.EnsInterfaceMethod).UpdateEnsInterfaceMethodStatus(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif action="expandMethodDetail" {
		set sc=##class(web.DHCENS.Method.CreateJson).GetDataInfoListShowCombox("web.DHCENS.Method.EnsInterfaceMethod","GetEnsInterfaceMethodDetailInfo",input)
	}elseif action="inputType" {
		if input'="" { 
			set sc=##class(web.DHCENS.Method.CreateJson).GetDataInfoListShowCombox("web.DHCENS.Method.EnsInterfaceMethod","GetMethodInputData",input)
		}
		else {
			w "[]"
		}
	}elseif action="outputType" {
		if input'="" { 
			set sc=##class(web.DHCENS.Method.CreateJson).GetDataInfoListShowCombox("web.DHCENS.Method.EnsInterfaceMethod","GetMethodOutputData",input)
		}
		else {
			w "[]"
		}
	}elseif action="baseType" {
		w "[{""baseType"":""%String""},{""baseType"":""%GlobalCharacterStream""}]"
	}elseif action="saveMethodInput" {
		set result=##class(web.DHCENS.Method.EnsInterfaceMethod).SaveMethodInput(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif action="deleteMethodInput" {
		set result=##class(web.DHCENS.Method.EnsInterfaceMethod).DeleteMethodInput(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif action="saveMethodOutput" {
		set result=##class(web.DHCENS.Method.EnsInterfaceMethod).SaveMethodOutput(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif action="deleteMethodOutput" {
		set result=##class(web.DHCENS.Method.EnsInterfaceMethod).DeleteMethodOutput(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}else{
		w "[]"
	}
	Quit $$$OK
}

}

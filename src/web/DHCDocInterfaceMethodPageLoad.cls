Class web.DHCDocInterfaceMethodPageLoad Extends %CSP.Page
{

Parameter CONTENTTYPE = "text/plain;charset=UTF-8";

ClassMethod OnPage() As %Status
{
	set action=$g(%request.Data("action",1))
	set input=$g(%request.Data("input",1))
	set page=$g(%request.Data("page",1))
	set rows=$g(%request.Data("rows",1))
	if action="saveMethodData" {		
		s inLength=%request.Count("input")
		for i=1:1:inLength {
			s input(i)=$g(%request.Data("input",i))
		}
		s j=0
		s tmpAllInPar=""
		do {
			s tmpPar=""
			s parLength=%request.Count("inGd"_j)
			for i=1:1:parLength {
				s params(i)=$g(%request.Data("inGd"_j,i))
				if (""=tmpPar) {
					s tmpPar=params(i)
				}else {
					s tmpPar=tmpPar_$C(14)_params(i) //单条之间分割
				}
			}
			if (tmpPar'=""){
				s tmpPar=tmpPar_$C(28) //多条之间分割
				if (""=tmpAllInPar) {
					s tmpAllInPar=tmpPar
				}else {
					s tmpAllInPar=tmpAllInPar_tmpPar
				}
			}
			s j=j+1
		}while($d(%request.Data("inGd"_j,1)))
		set length=$l(tmpAllInPar,$C(28))
		set tmpAllInPar=$p(tmpAllInPar,$C(28),1,length-1)
		
		s j=0
		s tmpAllOutPar=""
		do {
			s tmpPar=""
			s parLength=%request.Count("outGd"_j)
			for i=1:1:parLength {
				s params(i)=$g(%request.Data("outGd"_j,i))
				if (""=tmpPar) {
					s tmpPar=params(i)
				}else {
					s tmpPar=tmpPar_$C(14)_params(i) //单条之间分割
				}
			}
			if (tmpPar'=""){
				s tmpPar=tmpPar_$C(28) //多条之间分割
				if (""=tmpAllOutPar) {
					s tmpAllOutPar=tmpPar
				}else {
					s tmpAllOutPar=tmpAllOutPar_tmpPar
				}
			}
			s j=j+1
		}while($d(%request.Data("outGd"_j,1)))
		set length=$l(tmpAllOutPar,$C(28))
		set tmpAllOutPar=$p(tmpAllOutPar,$C(28),1,length-1)
		set result=##class(web.DHCDocInterfaceMethod).SaveDocInterfaceMethodInfo(tmpAllInPar,tmpAllOutPar,input(1),input(2),input(3),input(4),input(5),input(6),input(7),input(8),input(9),input(10),input(11),input(12),input(13),input(14))
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif action="inputType" {
		if input'="" { 
			;query输出的字段存在特殊数据时，平台方法转换json存在问题
			;set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowCombox("web.DHCDocInterfaceMethod","GetMethodInputData",input)
			set sc=##class(web.DHCDocInterfaceMethod).GetDataInfoListShowCombox("web.DHCDocInterfaceMethod","GetMethodInputData",input)
		}	
		else {
			w "[]"
		}
	}elseif action="outputType" {
		if input'="" { 
			;set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowCombox("web.DHCDocInterfaceMethod","GetMethodOutputData",input)
			set sc=##class(web.DHCDocInterfaceMethod).GetDataInfoListShowCombox("web.DHCDocInterfaceMethod","GetMethodOutputData",input)
		}
		else {
			w "[]"
		}
	}elseif action="methodlist" {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCDocInterfaceMethod","GetDocInterfaceMethodData",input,page,rows)
	}elseif action="methodDetail" {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataDetailInfo("web.DHCDocInterfaceMethod","GetDocInterfaceMethodDetailInfo",input)
	}elseif action="delMethodData" {
		set result=##class(web.DHCDocInterfaceMethod).delDocInterfaceMethodInfo(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_$p(result,"^",2)_"""}"
	}elseif action="updateMethodStatus" {
		set result=##class(web.DHCDocInterfaceMethod).UpdateDocInterfaceMethodStatus(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif action="expandMethodDetail" {
		;set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowCombox("web.DHCDocInterfaceMethod","GetDocInterfaceMethodDetailInfo",input)
		set sc=##class(web.DHCDocInterfaceMethod).GetDataInfoListShowCombox("web.DHCDocInterfaceMethod","GetDocInterfaceMethodDetailInfo",input)
	}elseif action="baseType" {
		w "[{""baseType"":""%String""},{""baseType"":""%Stream.GlobalCharacter""}]"
	}elseif action="debugMethodData" {
		s RowID=$g(%request.Data("RowID",1))
		s j=0
		s tmpAllInPar=""
		do {
			s tmpPar=$g(%request.Data("inGd"_j,1))
			if (tmpAllInPar="") {
				s tmpAllInPar=tmpPar
			}else {
				s tmpAllInPar=tmpAllInPar_$C(28)_tmpPar
			}
			s j=j+1
		}while($d(%request.Data("inGd"_j,1)))
		d ##class(web.DHCDocInterfaceMethod).DebugInterfaceMethod(RowID,tmpAllInPar)
	}
	Quit $$$OK
}

}

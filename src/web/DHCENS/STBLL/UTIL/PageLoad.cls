Class web.DHCENS.STBLL.UTIL.PageLoad Extends %CSP.Page
{

Parameter CONTENTTYPE = "text/plain;charset=UTF-8";

ClassMethod OnPage() As %Status
{
	set action=$g(%request.Data("action",1))
	set input=$g(%request.Data("input",1))
	set page=$g(%request.Data("page",1))
	set rows=$g(%request.Data("rows",1))
	if action="methodlist" {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.STBLL.UTIL.EnsInterfaceMethod","GetEnsInterfaceMethodData",input,page,rows)
	}elseif action="methodProcuctionTermlist" {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowCombox("web.DHCENS.STBLL.UTIL.EnsInterfaceMethod","GetMethodProcuctionTermData",input)
	}elseif action="hisVersionlist" {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowCombox("web.DHCENS.STBLL.UTIL.EnsInterfaceMethod","GetHisVersionTermData",input)
	}elseif action="methodDetail" {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataDetailInfo("web.DHCENS.STBLL.UTIL.EnsInterfaceMethod","GetEnsInterfaceMethodDetailInfo",input)
	}elseif action="methodCode" {
		set result=##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).getMethodCode()
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_$p(result,"^",2)_"""}"
	}elseif action="delMethodData" {
		set result=##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).delEnsInterfaceMethodInfo(input)
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
		set result=##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).SaveEnsInterfaceMethodInfo(tmpAllPar,input(1),input(2),input(3),input(4),input(5),input(6),input(7),input(8),input(9),input(10),input(11),input(12),input(13),input(14),input(15))
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif action="updateMethodStatus" {
		set result=##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).UpdateEnsInterfaceMethodStatus(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif action="expandMethodDetail" {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowCombox("web.DHCENS.STBLL.UTIL.EnsInterfaceMethod","GetEnsInterfaceMethodDetailInfo",input)
	}elseif action="inputType" {
		if input'="" { 
			set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowCombox("web.DHCENS.STBLL.UTIL.EnsInterfaceMethod","GetMethodInputData",input)
		}
		else {
			w "[]"
		}
	}elseif action="outputType" {
		if input'="" { 
			set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowCombox("web.DHCENS.STBLL.UTIL.EnsInterfaceMethod","GetMethodOutputData",input)
		}
		else {
			w "[]"
		}
	}elseif action="baseType" {
		w "[{""baseType"":""%String""},{""baseType"":""%GlobalCharacterStream""}]"
	}elseif action="saveMethodInput" {
		set result=##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).SaveMethodInput(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif action="deleteMethodInput" {
		set result=##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).DeleteMethodInput(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif action="saveMethodOutput" {
		set result=##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).SaveMethodOutput(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif action="deleteMethodOutput" {
		set result=##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).DeleteMethodOutput(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif action="saveWebServiceData" {		
		set inLength=%request.Count("input")
		set tmpPar=""
		for i=1:1:inLength {
			set input(i)=$g(%request.Data("input",i))
			if tmpPar="" {
				set tmpPar=input(i)
			}
			else {
				set tmpPar=tmpPar_$char(2)_input(i)
			}
		}
		set result=##class(web.DHCENS.STBLL.UTIL.EnsWebServiceClient).SaveEnsWebServiceClientInfo(tmpPar)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif(action="webserviceclientlist") { //原服务列表
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.STBLL.UTIL.EnsWebServiceClient","GetEnsWebServiceClientData",input,page,rows)
		
	}elseif action="serviceProcuctionTermList" {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowCombox("web.DHCENS.STBLL.UTIL.EnsWebServiceClient","GetServiceProcuctionTermData",input)
	}elseif action="serviceLanguesList" {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowCombox("web.DHCENS.STBLL.UTIL.EnsWebServiceClient","GetServiceLanguesData",input)
	}elseif action="webServiceClientDetail" {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataDetailInfo("web.DHCENS.STBLL.UTIL.EnsWebServiceClient","GetEnsWebServiceClientDetailInfo",input)
	}elseif action="delEnsWebServiceClient" {
		set result=##class(web.DHCENS.STBLL.UTIL.EnsWebServiceClient).DelEnsWebServiceClientInfo(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_$p(result,"^",2)_"""}"
	}elseif action="updateWebServiceClientStatus" {
		set result=##class(web.DHCENS.STBLL.UTIL.EnsWebServiceClient).UpdateEnsWebServiceClientStatus(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif(action="ensInterfacelist") {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.STBLL.UTIL.EnsInterface","GetEnsInterfaceData",input,page,rows)
	}elseif action="methodComboxlist" {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowCombox("web.DHCENS.STBLL.UTIL.EnsInterfaceMethod","GetEnsInterfaceMethodData",input)
	}elseif(action="loadMethodItemListInfo") {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowCombox("web.DHCENS.STBLL.UTIL.EnsInterfaceMethodItem","GetEnsInterfaceMethodItem",input)
	}elseif(action="saveEnsInMethodItem") {
		set result=##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethodItem).SaveEnsInMethodItem(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif(action="testMethodResult") {	
		set inLength=%request.Count("input")
		set result=inLength
		set tmpPar=""
		for i=1:1:inLength {
			set input(i)=$g(%request.Data("input",i))
			if tmpPar="" {
				set tmpPar=input(i)
			}
			else {
				set tmpPar=tmpPar_$char(2)_input(i)
			}
		}
		set result=##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).TestEnsInterfaceMethod(tmpPar)
		w "{""retvalue"":"""_$p(result,$c(2),1)_""",""retinfo"":"""_$p(result,$c(2),2)_"""}"
	}elseif(action="saveEnsSendDataInfo") {
		set result=##class(web.DHCENS.STBLL.UTIL.EnsSendDataInfo).SaveEnsSendDataInfo(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
		
	}elseif(action="ensSendDatalist") {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.STBLL.UTIL.EnsSendDataInfo","GetEnsSendDataInfo",input,page,rows)
	}elseif(action="ensSendDataDetail") {
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataDetailInfo("web.DHCENS.STBLL.UTIL.EnsSendDataInfo","GetEnsSendDataDetailInfo",input)
	}elseif(action="updateSendDataStatus") {
		set result=##class(web.DHCENS.STBLL.UTIL.EnsSendDataInfo).UpdateSendDataStatus(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_result_"""}"
	}elseif(action="delSendData") {
		set result=##class(web.DHCENS.STBLL.UTIL.EnsSendDataInfo).DelSendDataInfo(input)
		w "{""retvalue"":"""_$p(result,"^",1)_""",""retinfo"":"""_$p(result,"^",2)_"""}"
	}elseif(action="ensSendData") {
		
	}elseif action="selectLookUpTableInfoTreeList" {
		w ##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowTree("web.DHCENS.STBLL.UTIL.EnsLookUpTable","GetLookUpTableInfoData","")
	}
	elseif action="getLookUpTableData" {
		w ##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.STBLL.UTIL.EnsLookUpTableData","GetLookUpTableData",input,page,rows)
	}
	elseif action="getTargetLookUpTableData" {
		w ##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.STBLL.UTIL.EnsTarLookUpTData","GetTargetLookUpTableData",input,page,rows)
	}
	elseif action="getSourceLookUpTableData" {
		w ##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.STBLL.UTIL.EnsSouLookUpTData","GetSourceLookUpTableData",input,page,rows)
	}
	elseif action="saveLookUpTableDataInfo" {
		set myrtn=##class(web.DHCENS.STBLL.UTIL.EnsLookUpTableData).SaveLookUpTableDataInfo(input)
	}
	elseif action="canCelRelevanceInfo" {
		set myrtn=##class(web.DHCENS.STBLL.UTIL.EnsLookUpTableData).CanCelRelevanceInfo(input)
	}
	elseif action="relevanceInfo" {
		set myrtn=##class(web.DHCENS.STBLL.UTIL.EnsLookUpTableData).RelevanceInfo(input)
	}
	elseif action="saveLookUpTableInfo" {
		set myrtn=##class(web.DHCENS.STBLL.UTIL.EnsLookUpTable).SaveLookUpTableInfo(input)
	}
	elseif action="deleteLookUpTableInfo" {
		set myrtn=##class(web.DHCENS.STBLL.UTIL.EnsLookUpTable).DeleteLookUpTableInfo(input)
	}
	elseif action="deleteTargetTableDataInfo" {
		set myrtn=##class(web.DHCENS.STBLL.UTIL.EnsTarLookUpTData).DeleteTargetTableDataInfo(input)
	}
	elseif action="deleteSourceTableDataInfo" {
		set myrtn=##class(web.DHCENS.STBLL.UTIL.EnsSouLookUpTData).DeleteSourceTableDataInfo(input)
	}
	elseif action="ServiceList"{//WSDL服务列表（HISUI）-获取服务列表
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.STBLL.REGISTER.DAO.RegisteredService","GetServiceGridInfo",input,page,rows)
	}
	elseif action="SerMethodList"{//WSDL服务列表（HISUI））-编辑-获取方法列表
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPMethod","GetMethodGridInfo",input,page,rows)
	}
	elseif action="SerParameterList"{//WSDL服务列表（HISUI）-编辑-获取参数列表
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPParameter","GetParameterGridInfo",input,page,rows)
	}
	elseif action="SerFunctionList"{//WSDL服务列表（HISUI）-编辑-获取功能列表
		/*服务代码^方法代码^参数代码^功能代码^功能描述*/
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPFunction","GetFunctionGridInfo",input,page,rows)
	}
	elseif action="saveSerMethodData"{//编辑方法，待修改
		/*参数格式： 服务代码^方法代码^方法描述^方法状态^返回值类型^总线代码*/
		set myrtn=##class(web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPMethod).SaveMethodInfo(input)
		w myrtn
	}
	elseif action="saveSerParamsData"{//编辑参数
		/*参数格式： 服务代码^方法代码^参数代码^参数类型^参数描述*/
		set myrtn=##class(web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPParameter).SaveParameterInfo(input)
		w myrtn
	}
	elseif action="saveSerFuncData"{//新增、编辑功能
		/*参数格式：服务代码^方法代码^参数代码^功能代码^功能描述*/
		set myrtn=##class(web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPFunction).SaveFunctionInfo(input)
		w myrtn
	}
	/*
	elseif action="addSerFuncData"{//新增功能，待添加
		///参数格式：服务代码^方法代码^参数代码^功能代码^功能描述
		set myrtn=##class(web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPFunction).AddFunctionInfo(input)
		w myrtn
	}
	*/
	elseif action="EditSG"{//保存基本信息
		/* 
		参数格式：服务代码^服务名称^服务描述^服务IP^服务状态^总线代码^服务端口^方法代码^方法描述*/
		set myrtn=##class(web.DHCENS.STBLL.REGISTER.DAO.RegisteredService).SaveServiceInfo(input)
		w myrtn
	}
	elseif action="DateFormat"{//获取日期格式
		set myrtn=##class(websys.Conversions).DateFormat()
		w myrtn
	}
	///下拉-目标列表，用于方法列表界面，维护调用目标
	elseif action="TargetList"{	
		set result=##class(web.DHCENS.STBLL.MANAGE.SystemConfig).TargetList()
		w result
	}
	///调阅接口文档 .md
	elseif action="MDSearch"{	
		set result=##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).MDSearch(input)
		w result
	}
	else{
		w "[]"
	}
	Quit $$$OK
}

}

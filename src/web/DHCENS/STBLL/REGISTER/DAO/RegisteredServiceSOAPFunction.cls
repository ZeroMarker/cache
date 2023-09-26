Class web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPFunction Extends (%RegisteredObject, %XML.Adaptor)
{

/// Input: 服务代码^方法代码^参数代码^功能代码^功能描述
/// d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPFunction","GetFunctionGridInfo","REG0002^HIPMessageServer^input1^function1^")
Query GetFunctionGridInfo(Input As %String) As %Query(ROWSPEC = "rowId:%String,FunctionDesc:%String,FunctionCode:%String,ParaNote:%String,ParaDesc:%String,ParaCode:%String,MethodNote:%String,MethodDesc:%String,MethodCode:%String,ServDesc:%String,ServCode:%String")
{
}

ClassMethod GetFunctionGridInfoExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set serviceCode=$p(Input,"^",1)
	set methodCode=$p(Input,"^",2)
	set paraCode=$p(Input,"^",3)
	set funcCode=$p(Input,"^",4)
	set funcDesc=$p(Input,"^",5)
	s (tmpServCode,tmpMethCode,tmpParaCode,tmpFuncCode,tmpFuncDesc)=""
	s funcRowId="" 
	for  
	{
		s funcRowId=$o(^Busi.ENS.RegisteredServiceSFunD(funcRowId))
		q:funcRowId=""
		s functionStr=$g(^Busi.ENS.RegisteredServiceSFunD(funcRowId))
		q:functionStr=""
		s tmpServCode=$lg(functionStr,2)
		continue:(serviceCode'="")&&((tmpServCode'=serviceCode)&&(tmpServCode'[serviceCode))
		s serRowID=$o(^Busi.ENS.RegisteredServiceI("PKServiceCode",tmpServCode,""))
		s serStr=$g(^Busi.ENS.RegisteredServiceD(serRowID))
		s tmpServNote=$lg(serStr,4)
		
		s tmpMethCode=$lg(functionStr,3)
		s mthRowID=$o(^Busi.ENS.RegisteredServiceSMetI("PKMethodCode",tmpServCode,tmpMethCode,""))
		s mthStr=$g(^Busi.ENS.RegisteredServiceSMetD(mthRowID))
		s tmpMethCode=$lg(mthStr,3)
		continue:(methodCode'="")&&((tmpMethCode'=methodCode)&&(tmpMethCode'[methodCode))
		s tmpMethDesc=$lg(mthStr,4)
		s tmpMethNote=$lg(mthStr,5)
		
		s tmpParaCode=$lg(functionStr,4)
		s paraRowID=$o(^Busi.ENS.RegisteredServiceSParI("PKParameterCode",tmpServCode,tmpMethCode,tmpParaCode,""))
		s paraStr=$g(^Busi.ENS.RegisteredServiceSParD(paraRowID))
		s tmpParaCode=$lg(paraStr,4)
		continue:(paraCode'="")&&(tmpParaCode'=paraCode)
		s tmpParaDesc=$lg(paraStr,7)
		s tmpParaNote=$lg(paraStr,8)
		if (serviceCode'=""){
			i (((serviceCode'="")&&(tmpServCode'=serviceCode)&&(tmpServCode'[serviceCode))||((tmpMethCode'=methodCode)&&(tmpMethCode'[methodCode))||((tmpParaCode'=paraCode)||(tmpParaCode'[paraCode))){
				continue
			}
		}
		s tmpFuncCode=$lg(functionStr,5)
		continue:(funcCode'="")&&((tmpFuncCode'=funcCode)&&(tmpFuncCode'[funcCode))
		s tmpFuncDesc=$lg(functionStr,6)
		continue:(funcDesc'="")&&((tmpFuncDesc'=funcDesc)&&(tmpFuncDesc'[funcDesc))
		s rowId=""
		s btnUpdate=""
		s ^CacheTemp(repid,ind)=$lb(rowId,tmpFuncDesc,tmpFuncCode,tmpParaNote,tmpParaDesc,tmpParaCode,tmpMethNote,tmpMethDesc,tmpMethCode,tmpServNote,tmpServCode)
		s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetFunctionGridInfoClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetFunctionGridInfoExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetFunctionGridInfoFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFunctionGridInfoExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Input: 服务代码^方法代码^参数代码^功能代码^功能描述
/// w ##class(web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPFunction).SaveFunctionInfo("REG0005^HIPMessageServer^input1^msg0001^测试消息1")
ClassMethod SaveFunctionInfo(funcInfo As %String) As %String
{
	s $zt="err"
	s serviceCode=$p(funcInfo,"^",1)
	s methodCode=$p(funcInfo,"^",2)
	s parameterCode=$p(funcInfo,"^",3)
	s funcCode=$p(funcInfo,"^",4)
	s funcNote=$p(funcInfo,"^",5)
	q:funcCode="" "-1^功能代码为空"
	s methodType="classMethod"
	//增加判断功能是否已存在
	ts
	s funcRowid=$o(^Busi.ENS.RegisteredServiceSFunI("PKFunctionCode",serviceCode,methodCode,parameterCode,funcCode,""))
	if funcRowid'=""
	{
		s funcObj=##class(User.EnsRegisteredServiceSOAPFunction).%OpenId(funcRowid)
	}
	else
	{
		s funcObj=##class(User.EnsRegisteredServiceSOAPFunction).%New()	
	}
	s funcObj.FunctionCode=funcCode
	s funcObj.FunctionDesc=funcNote
	s funcObj.ServiceCode=serviceCode
	s funcObj.MethodCode=methodCode
	s funcObj.ParameterCode=parameterCode
	s funcObj.UpdateDate=+$h
	s funcObj.UpdateTime=$p($h,",",2)
	s sc=funcObj.%Save()
	b ;000
	if sc'=1 {
		tro
		q -1
		}
	s cmSc=0
	s inputMthCode=funcCode_"On"_serviceCode
	s className="web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface"
	if '$D(^oddDEF(className,"m",inputMthCode)) s cmSc=##class(web.DHCENS.STBLL.REGISTER.UTIL.Common).CreateMethod(inputMthCode)
	if +cmSc'=0 {
		tro
		q -1
	}
	b ;001
	s methodType="classMethod"
	s methodDesc=serviceCode_"-"_funcNote
	s inputValtype="%GlobalCharacterStream"_$c(2)_"N"_$c(2)_"请求信息流"
	s outputValtype="%GlobalCharacterStream"_$c(2)_"N"_$c(2)_"响应信息流"
	s insertDate=+$h
	s insertTime=$p($h,",",2)
	if '$D(^User.EnsInterfaceMethodI("MethodCode",methodType,inputMthCode)) {
		&sql(insert into SqlUser.Ens_InterfaceMethod(method_Code,method_Desc,method_Status,method_ProcuctionTerm,method_ClassName,method_Name,method_Type,method_PublishClassName,method_PublishName,method_Input,method_Output,insertDate,insertTime)values(:inputMthCode,:methodDesc,"Y","医院信息平台","web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface",:inputMthCode,:methodType,"web.DHCENS.EnsHISService","DHCHisInterface",:inputValtype,:outputValtype,:insertDate,:insertTime))
		if (SQLCODE'=0)&&(SQLCODE'=100) {
			tro
			q -1
		}
	}
	else {
		&sql(update SqlUser.Ens_InterfaceMethod set method_Desc=:methodDesc,insertDate=:insertDate,insertTime=:insertTime where method_Type=:methodType and method_Code=:inputMthCode)
		if (SQLCODE'=0)&&(SQLCODE'=100) {
			tro
			q -1
		}
	}
	b ;002
	do funcObj.%Reload()
	tc
	q 1
err
	b ;$ZE
	tro
	q -1_"^"_$ZE
}

ClassMethod UpdateByObj(oldFunctionCode As %String, pObj As web.DHCENS.STBLL.REGISTER.MODEL.RegisteredServiceSOAPFunction, Output rowId As %String = "") As %String
{
	s $zt="err"
	s tSC = "0"
	ts
	if pObj="" {
		Quit "-1^input empty"
	}elseif (""=oldFunctionCode){
		q "-1^获取原功能代码为空"
	}else{}
	set rowId=""
	
	s ServiceCode=pObj.ServiceCode
	s MethodCode=pObj.MethodCode
	s ParameterCode=pObj.ParameterCode
	s funcRowid=$o(^Busi.ENS.RegisteredServiceSFunI("PKFunctionCode",ServiceCode,MethodCode,ParameterCode,oldFunctionCode,""))
	s funcObj=##class(User.EnsRegisteredServiceSOAPFunction).%OpenId(funcRowid)
	if '$isobject(funcObj){
		tro
		q "-1^功能对象不存在"
	}
	s FunctionCode=pObj.FunctionCode
	s FunctionDesc=pObj.FunctionDesc
	s:FunctionCode'="" funcObj.FunctionCode=FunctionCode
	s:FunctionDesc'="" funcObj.FunctionDesc=FunctionDesc
	s funcObj.ServiceCode=pObj.ServiceCode
	s funcObj.MethodCode=pObj.MethodCode
	s funcObj.ParameterCode=pObj.ParameterCode
	s funcObj.UpdateDate=+$h
	s funcObj.UpdateTime=$p($h,",",2)
	s sc=funcObj.%Save()
	if $$$ISOK(sc) {
		d funcObj.%Reload()
		s rowId = funcObj.%Id()
		s tSC = 1
		tc
	}else {
		tro
		set rowId = ""
		set tSC = tSC_"^"_$SYSTEM.Status.GetErrorText(sc)
	}
	Quit tSC
err
	tro
	q $ze
}

/// Input: 服务代码^方法代码^参数代码^功能代码^功能描述
/// w ##class(web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPFunction).AddFunctionInfo("REG0007^M01^input1^test^测试")
ClassMethod AddFunctionInfo(funcInfo As %String) As %String
{
	s $zt="err"
	s tSC = "0"
	ts
	s serviceCode=$p(funcInfo,"^",1)
	s methodCode=$p(funcInfo,"^",2)
	s parameterCode=$p(funcInfo,"^",3)
	s funcCode=$p(funcInfo,"^",4)
	s funcNote=$p(funcInfo,"^",5)
	q:(funcCode="") "-1^功能代码为空"
	//增加判断功能是否已存在
	s funcObj=##class(User.EnsRegisteredServiceSOAPFunction).%New()
	s funcObj.FunctionCode=funcCode 
	s funcObj.FunctionDesc=funcNote
	s funcObj.ServiceCode=serviceCode
	s funcObj.MethodCode=methodCode
	s funcObj.ParameterCode=parameterCode
	s funcObj.UpdateDate=+$h
	s funcObj.UpdateTime=$p($h,",",2)
		
	s sc=funcObj.%Save()
	if $$$ISOK(sc) {
		do funcObj.%Reload()
		tc
		s tSC = "1"
		// 此处存储参数 未写
	}else {
		s tSC = tSC_"^"_$SYSTEM.Status.GetErrorText(sc)
		tro
		q
	}
	q tSC
err
	tro
	q $ze
}

}

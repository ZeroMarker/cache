Class web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPParameter Extends (%RegisteredObject, %XML.Adaptor)
{

/// Input: 服务代码^方法代码
/// d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPParameter","GetParameterGridInfo","")
Query GetParameterGridInfo(Input As %String) As %Query(ROWSPEC = "rowId:%String,ParameterCode:%String,ParameterType:%String,DataType:%String,ParameterDesc:%String,ParameterNote:%String,btnUpdate:%String")
{
}

ClassMethod GetParameterGridInfoExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set serviceCode=$p(Input,"^",1)
	set methodCode=$p(Input,"^",2)
	
	s paraRowId="" 
	for  
	{
		s paraRowId=$o(^Busi.ENS.RegisteredServiceSParD(paraRowId))
		q:paraRowId=""
		s parameterStr=$g(^Busi.ENS.RegisteredServiceSParD(paraRowId))
		s tmpServCode=$lg(parameterStr,2)
		s tmpMethCode=$lg(parameterStr,3)
		i ((serviceCode'="")&&(((tmpServCode'=serviceCode)||(tmpServCode'[serviceCode))||((tmpMethCode'=methodCode)||(tmpMethCode'[methodCode)))){
			continue
		}
		s paraCode=$lg(parameterStr,4)
		s paraType=$lg(parameterStr,5)
		s dataType=$lg(parameterStr,6)
		s paraDesc=$lg(parameterStr,7)
		s paraNote=$lg(parameterStr,8)
		s rowId=""
		s btnUpdate=""
		s ^CacheTemp(repid,ind)=$lb(rowId,paraCode,paraType,dataType,paraDesc,paraNote,btnUpdate)
		s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetParameterGridInfoClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetParameterGridInfoExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetParameterGridInfoFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetParameterGridInfoExecute ]
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

/// Input: 服务代码,方法代码,参数代码^修改项（ParameterNote或DataType）^修改值
/// w ##class(DHCENSLib.Dao.RegisteredServiceSOAPParameter).UpdateParameterInfo("S0001","1","1^ParameterNote^asdf")
ClassMethod UpdateParameterInfo(serviceCode As %String, methodCode As %String, paraInfo As %String) As %String
{
	s $zt="err"
	s tSC = "0"
	ts
	s paracode=$p(paraInfo,"^",1)
	s columndesc=$p(paraInfo,"^",2)
	s columnval=$p(paraInfo,"^",3)
	q:serviceCode="" "-1^服务代码为空"
	q:methodCode="" "-1^方法代码为空"
	if (""=paracode){
		q "-1^参数代码为空"
	}
	s paraRowid=$o(^Busi.ENS.RegisteredServiceSParI("PKParameterCode",serviceCode,methodCode,paracode,""))
	s paraObj=##class(User.EnsRegisteredServiceSOAPParameter).%OpenId(paraRowid)
	
	if columndesc="DataType"{
		// 2016-7-1 lyh 对Method HISChargeRule(inputstr As %String(XMLNAME="input_str"), hisrecordid As %String(XMLNAME="his_record_id")) As %GlobalCharacterStream(XMLNAME="HIS_ChargeRuleResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
		// 特殊处理
		s oldDataType=paraObj.DataType
		s tmpDataType=$p(oldDataType,"(",1)
		s columnval=$replace(oldDataType,tmpDataType,columnval)
	}
	s @"columnval"=columnval
	s @"paraObj"=paraObj
	s exestr="paraObj."_columndesc_"=columnval"
	s @exestr
	s paraObj.UpdateDate=+$h
	s paraObj.UpdateTime=$p($h,",",2)
	s sc=paraObj.%Save()
	if $$$ISOK(sc) {
		if columndesc="DataType"{
			s mthRowid=$o(^Busi.ENS.RegisteredServiceSMetI("PKMethodCode",serviceCode,methodCode,""))
			s mthObj=##class(User.EnsRegisteredServiceSOAPMethod).%OpenId(mthRowid)
			s mthClass=mthObj.ServiceClass
			s dataType=paraObj.DataType
			s obj=##class(%Dictionary.MethodDefinition).%OpenId(mthClass_"||"_methodCode)
			s tmpFormalSepc=obj.FormalSpec	//"%GlobalCharacterStream"
			s rtnFormalSepc=""
			s tInput=tmpFormalSepc
			s len=$l(tInput,",")
			s i=1,tSt=0,tEd=0
			while len>=i{
			    s tPara=$p(tInput,",",i)
			    s tKey=$p(tPara,":")
			    s tmpStr=tPara
                s tStr=""
			    if tPara[")"{
			        //一个属性
			        s tSt=$f(tInput,"(",tSt)
			        s tEd=$f(tInput,")",tEd)
			        s tStr=$e(tInput,tSt-1,tEd-1)
			    }elseif tPara["("{
			        //多个属性
			        s tSt=$f(tInput,"(",tSt)
					s tEd=$f(tInput,")",tEd)
					s tStr=$e(tInput,tSt-1,tEd-1)
					s tInput=$replace(tInput,tStr,"")
					s tCalc=$l(tStr,",")
					if tCalc>1{
						s tCalc=tCalc-1
					}
			        s len=len-tCalc
			        s tmpStr=$p(tPara,"(")_tStr
			    }else{
			        //没有属性
			    }
			    if (paracode=tKey){
					s tmpStr=tKey_":"_dataType_tStr
				}
				if rtnFormalSepc=""{
					s rtnFormalSepc=tmpStr
				}else{
					s rtnFormalSepc=rtnFormalSepc_","_tmpStr
				}
				s i=i+1
			}
			s obj.FormalSpec=rtnFormalSepc
			s sc=obj.%Save()
			s tSC=$system.OBJ.Compile(mthClass,"ck/displaylog=0")
			if $$$ISERR(tSC){
				tro
				q
			}
		}
		do mthObj.%Reload()
		do paraObj.%Reload()
		s tSC = "1"
		// 保存功能代码
		//s tSC=..SaveFunctionInfo(serviceCode, methodCode, ParameterCode, funcInfo)
		tc
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

/// Input: 服务代码^方法代码^参数代码^数据类型^参数描述
/// Debug:w ##class(web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPParameter).SaveParameterInfo("REG0002^HIPMessageServer^input2^%String^in2")
ClassMethod SaveParameterInfo(paraInfo As %String) As %String
{
	s $zt="err"
	s tSC = "0"
	ts
	s serviceCode=$p(paraInfo,"^",1)
	s methodCode=$p(paraInfo,"^",2)
	s parameterCode=$p(paraInfo,"^",3)
	s dataType=$p(paraInfo,"^",4)
	s parameterDesc=$p(paraInfo,"^",5)
	q:(parameterCode="") "-1^参数代码为空"
	//增加判断参数是否已存在
	s paraRowid=$o(^Busi.ENS.RegisteredServiceSParI("PKParameterCode",serviceCode,methodCode,parameterCode,""))
	if paraRowid'=""
	{
		s paraObj=##class(User.EnsRegisteredServiceSOAPParameter).%OpenId(paraRowid)
	}
	else
	{
		s paraObj=##class(User.EnsRegisteredServiceSOAPParameter).%New()
	}
	s paraObj.ServiceCode=serviceCode 
	s paraObj.MethodCode=methodCode
	s paraObj.ParameterCode=parameterCode
	s paraObj.DataType=dataType
	s paraObj.ParameterDesc=parameterDesc
	s paraObj.UpdateDate=+$h
	s paraObj.UpdateTime=$p($h,",",2)
		
	s sc=paraObj.%Save()
	if $$$ISOK(sc) {
		do paraObj.%Reload()
		tc
		s tSC = "1"
		// 此处存储参数 未写
	}else {
		s tSC = tSC_"^"_$SYSTEM.Status.GetErrorText(sc)
		tro
	}
	q tSC
err
	tro
	q $ze
}

}

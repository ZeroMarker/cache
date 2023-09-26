Class web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPMethod Extends (%RegisteredObject, %XML.Adaptor)
{

/// Input: 服务代码
/// d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPMethod","GetMethodGridInfo","")
Query GetMethodGridInfo(Input As %String) As %Query(ROWSPEC = "rowId:%String,MethodCode:%String,MethodDesc:%String,MethodNote:%String,ReturnVal:%String,MethodStatus:%String,btnUpdate:%String,BusCode:%String")
{
}

ClassMethod GetMethodGridInfoExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set serviceCode=$p(Input,"^",1)
	
	s methRowId="" 
	for  
	{
		s methRowId=$o(^Busi.ENS.RegisteredServiceSMetD(methRowId))
		q:methRowId=""
		set methodStr=$g(^Busi.ENS.RegisteredServiceSMetD(methRowId))
		set tmpServCode=$lg(methodStr,2)
		//w !,tmpServCode
		if ((serviceCode'="")&&((tmpServCode'=serviceCode)&&(tmpServCode'[serviceCode))){
			continue
		}
		set methodCode=$lg(methodStr,3)
		set methodDesc=$lg(methodStr,4)
		set methodNote=$lg(methodStr,5)
		set methodStatus=$lg(methodStr,6)
		set returnVal=$lg(methodStr,7)
		set busCode=$lg(methodStr,19)
		set rowId=""
		set btnUpdate=""
		set ^CacheTemp(repid,ind)=$lb(rowId,methodCode,methodDesc,methodNote,returnVal,methodStatus,btnUpdate,busCode)
		set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetMethodGridInfoClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetMethodGridInfoExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMethodGridInfoFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMethodGridInfoExecute ]
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

/// Input: 服务代码,方法代码^修改项（MethodNote或MethodStatus或ReturnVal）^修改值
/// w ##class(web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPMethod).UpdateMethodInfo("S0001","1^ReturnVal^%String")
ClassMethod UpdateMethodInfo(serviceCode As %String, methodInfo As %String) As %String
{
	s $zt="err"
	s tSC = "0"
	ts
	s mthcode=$p(methodInfo,"^",1)
	s columndesc=$p(methodInfo,"^",2)
	s columnval=$p(methodInfo,"^",3)
	q:serviceCode="" "-1^服务代码为空"
	if (""=mthcode){
		q "-1^方法代码为空"
	}
	
	s mthRowid=$o(^Busi.ENS.RegisteredServiceSMetI("PKMethodCode",serviceCode,mthcode,""))
	s mthObj=##class(User.EnsRegisteredServiceSOAPMethod).%OpenId(mthRowid)
	if columndesc="ReturnVal"{
		// 2016-7-6 lyh 对Method AutoQueueInformation(reqXml As %String) As %XML.String
		// 特殊处理
		s oldReturnVal=mthObj.ReturnVal
		//如果数据类型包含前缀，则替换
		if $l(oldReturnVal,".")>1{
			s columnval="%GlobalCharacterStream"
		}elseif oldReturnVal["."{
			s tPreType=$p(oldReturnVal,".",1)
			s tPreType=$zcvt(tPreType,"L")
			if (tPreType="%xsd"){
				//处理有待完善,比如是否能还原成%xsd.string?
				s columnval="%GlobalCharacterStream"
			}else{
				s tmpReturnVal=$p(oldReturnVal,".",2)
				s columnval=$replace(oldReturnVal,tmpReturnVal,$p(columnval,"%",2))
			}
		}
	}
	s @"columnval"=columnval
	s @"mthObj"=mthObj
	s exestr="mthObj."_columndesc_"=columnval"
	s @exestr
	s mthObj.UpdateDate=+$h
	s mthObj.UpdateTime=$p($h,",",2)
	s sc=mthObj.%Save()
	if $$$ISOK(sc) {
		if columndesc="ReturnVal"{
			s rtnVal=mthObj.ReturnVal
			s mthClass=mthObj.ServiceClass
			s obj=##class(%Dictionary.MethodDefinition).%OpenId(mthClass_"||"_mthcode)
			s obj.ReturnType=rtnVal	//"%GlobalCharacterStream"
			s sc=obj.%Save()
			s tSC=$system.OBJ.Compile(mthClass,"ck/displaylog=0")
			if $$$ISERR(tSC){
				tro
				q
			}
		}
		do mthObj.%Reload()
		s tSC = "1"
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

/// Input: 服务代码^方法代码^方法描述^方法状态^返回值类型^总线代码 REG0002^HIPMessageServer^LIS公共方法入口^N^%GlobalCharacterStream^PUB0002
/// w ##class(web.DHCENS.STBLL.REGISTER.DAO.RegisteredServiceSOAPMethod).SaveMethodInfo("REG0002^HIPMessageServer^LIS公共方法入口^Y^%GlobalCharacterStream")
ClassMethod SaveMethodInfo(methodInfo As %String) As %String
{
	
	s $zt="err"
	s tSC = "0"
	ts
	s serviceCode=$p(methodInfo,"^",1)
	s methodCode=$p(methodInfo,"^",2)
	s methodDesc=$p(methodInfo,"^",3)
	s methodStatus=$p(methodInfo,"^",4)
	s rtnType=$p(methodInfo,"^",5)
	s busCode=$p(methodInfo,"^",6)
	q:(methodCode="") "-1^方法代码为空"
	//增加判断方法是否已存在
	s mthRowid=$o(^Busi.ENS.RegisteredServiceSMetI("PKMethodCode",serviceCode,methodCode,""))
	if mthRowid'=""
	{
		s methodObj=##class(User.EnsRegisteredServiceSOAPMethod).%OpenId(mthRowid)
	}
	else
	{
		s methodObj=##class(User.EnsRegisteredServiceSOAPMethod).%New()
	}
	s methodObj.ServiceCode=serviceCode 
	s methodObj.MethodCode=methodCode
	s methodObj.MethodDesc=methodDesc
	s methodObj.MethodStatus=methodStatus
	s methodObj.ReturnVal=rtnType
	s methodObj.BusCode=busCode
	s methodObj.UpdateDate=+$h
	s methodObj.UpdateTime=$p($h,",",2)
		
	s sc=methodObj.%Save()
	if $$$ISOK(sc) {
		do methodObj.%Reload()
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

Class web.DHCENS.STBLL.REGISTER.DAO.RegisteredService Extends (%RegisteredObject, %XML.Adaptor)
{

/// Input: 总线代码(可空)^服务代码^服务名称^服务状态^服务类型^查询条件关键字
/// d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.REGISTER.DAO.RegisteredService","GetServiceGridInfo","")
Query GetServiceGridInfo(Input As %String) As %Query(ROWSPEC = "serCode:%String,serDesc:%String,serNote:%String,serType:%String,serFlag:%String,serWsdl:%String,host:%String,port:%String,dsn:%String,serUsr:%String,serPwd:%String,credentials:%String,rowId:%String,checkBox:%String,btnUpdate:%String,srcSSL:%String,serPy:%String,charset:%String,connect:%String,timeout:%String,reply:%String,replycode:%String,serProv:%String,serBusCode:%String")
{
}

ClassMethod GetServiceGridInfoExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set busCode=$p(Input,"^",1)
	set serviceCode=$p(Input,"^",2)
	set serviceDesc=$p(Input,"^",3)
	set serviceStatus=$p(Input,"^",4)
	set serviceType=$p(Input,"^",5)
	set condition=$p(Input,"^",6)
	set rowId=0
	s serCode=""
	for {
		s serCode=$o(^Busi.ENS.RegisteredServiceI("PKServiceCode",serCode))
		q:serCode=""
		s serRowId=$O(^Busi.ENS.RegisteredServiceI("PKServiceCode",serCode,""))
		q:serRowId=""
		set serStr=$g(^Busi.ENS.RegisteredServiceD(serRowId))
		set serCategory=$lg(serStr,11)
		set serCode=$lg(serStr,2)
		continue:(serviceCode'="")&&((serCode'=serviceCode)&&(serCode'[serviceCode))
		set serDesc=$lg(serStr,3)
		continue:(serviceDesc'="")&&((serDesc'=serviceDesc)&&(serDesc'[serviceDesc))
		set serNote=$lg(serStr,4)
		set serFlag=$lg(serStr,5)
		continue:(serviceStatus'="")&&(serFlag'=serviceStatus)
		set serType=$lg(serStr,6)
		continue:(serviceType'="")&&(serType'=serviceType)
		set serProv=$lg(serStr,7)
		set serBusCode=$lg(serStr,18)
		continue:(busCode'="")&&((serBusCode'=busCode)&&(serBusCode'[busCode))
		//判断服务类型
		s serWsdl="",port="",host="",dsn="",username="",password=""
		if (serType="SOAP"){
			set mthCode=$o(^Busi.ENS.RegisteredServiceSMetI("PKMethodCode",serCode,""))
			set mthRowId="",mthHost="",mthPort=""
			set:mthCode'="" mthRowId=$o(^Busi.ENS.RegisteredServiceSMetI("PKMethodCode",serCode,mthCode,""))
			if mthRowId'="" {
				s soapMthInfo=$g(^Busi.ENS.RegisteredServiceSMetD(mthRowId))
				s serWsdl=$lg(soapMthInfo,15)
				s username=$lg(soapMthInfo,16)
				s password=$lg(soapMthInfo,17)
				s ssl=$lg(soapMthInfo,18)
				s mthHost=$lg(soapMthInfo,11)
				s mthPort=$lg(soapMthInfo,12)
			}
			if serWsdl=""{
				//此判断是程序升级所加，为了兼容已有的注册服务
				set:mthRowId'="" serWsdl=$lg(^Busi.ENS.RegisteredServiceSMetD(mthRowId),8)
			}
			s tComponents=""
			k tComponents
			d ##class(%Net.URLParser).Parse(serWsdl,.tComponents)
			set port=$g(tComponents("port"))
			set host=$g(tComponents("host"))
			set:mthHost'="" host=mthHost
			set:mthPort'="" port=mthPort			
		}
		/*elseif (serType="REST"){
			set mthCode=$o(^DHCENSLib.RegisteredRestI("PKResourceCode",serCode,""))
			set mthRowId="",serInfo=""
			set:mthCode'="" mthRowId=$o(^DHCENSLib.RegisteredRestI("PKResourceCode",serCode,mthCode,""))
			set:mthRowId'="" serInfo=$g(^DHCENSLib.RegisteredRestD(mthRowId))
			set port=$lg(serInfo,10)
			set host=$lg(serInfo,9)
			set ssl=$lg(serInfo,11)
		}elseif (serType="SQL"){
			set mthCode=$o(^DHCENSLib.RegisteredSQLMethI("PKMethodCode",serCode,""))
			set mthRowId="",serInfo=""
			set:mthCode'="" mthRowId=$o(^DHCENSLib.RegisteredSQLMethI("PKMethodCode",serCode,mthCode,""))
			set:mthRowId'="" serInfo=$g(^DHCENSLib.RegisteredSQLMethD(mthRowId))
			set dsn=$lg(serInfo,7)
			set username=$lg(serInfo,8)
			set password=$lg(serInfo,9)
			set credentials=$lg(serInfo,15)
		}elseif (serType="HL7"){
			set mthCode=$o(^DHCENSLib.RegisteredSerHL7MesI("PKRegServHL7TCPMes",serCode,""))
			set mthRowId="",serInfo=""
			set:mthCode'="" mthRowId=$o(^DHCENSLib.RegisteredSerHL7MesI("PKRegServHL7TCPMes",serCode,mthCode,""))
			set:mthRowId'="" serInfo=$g(^DHCENSLib.RegisteredSerHL7MesD(mthRowId))
			set host=$lg(serInfo,5)
			set port=$lg(serInfo,6)
			set charset=$lg(serInfo,8)
			set replycode=$lg(serInfo,9)
			set connect=$lg(serInfo,10)
			set reply=$lg(serInfo,11)
			set timeout=$lg(serInfo,12)
		}else{}*/
		
		if condition'=""{
			if ((serCode'[condition)&&(serDesc'[condition)&&(serNote'[condition)){
				continue
			}
		}
		set rowId=rowId+1
		set checkBox=""
		set btnUpdate=""
		set serPy=##class(ext.util.String).ToChineseSpell(serDesc)
		set ^CacheTemp(repid,ind)=$lb(serCode,serDesc,serNote,serType,serFlag,serWsdl,host,port,dsn,username,password,credentials,rowId,checkBox,btnUpdatebtnUpdate,ssl,serPy,charset,connect,timeout,reply,replycode,serProv,serBusCode)
		set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod GetServiceGridInfoClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetServiceGridInfoExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetServiceGridInfoFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetServiceGridInfoExecute ]
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

/// Input: 服务代码^服务名称^服务描述^服务IP^服务端口^使用状态^用户名^密码^接入系统代码^https配置名称
/// w ##class(web.DHCENS.STBLL.REGISTER.DAO.RegisteredService).UpdateServiceInfo("REG0001^服务1^服务1^127.0.0.1^^N^^^")
ClassMethod UpdateServiceInfo(serviceInfo As %String) As %String
{
	s $zt="err"
	s tSC = 0
	ts
	s sercode=$p(serviceInfo,"^",1)
	s sername=$p(serviceInfo,"^",2)
	s serdesc=$p(serviceInfo,"^",3)
	s serhost=$p(serviceInfo,"^",4)
	s serport=$p(serviceInfo,"^",5)
	s serflag=$p(serviceInfo,"^",6)
	s username=$p(serviceInfo,"^",7)
	s password=$p(serviceInfo,"^",8)
	s serprov=$p(serviceInfo,"^",9)
	s ssl=$p(serviceInfo,"^",10)
	q:sercode="" "-1^服务代码为空"
	if (""=serhost){
		q "-1^服务地址为空"
	}
	
	s serRowid=$o(^Busi.ENS.RegisteredServiceI("PKServiceCode",sercode,""))
	s serObj=##class(User.EnsRegisteredService).%OpenId(serRowid)
	s serObj.ServiceCode=sercode
	s serObj.ServiceDesc=serdesc
	s serObj.ServiceNote=sername
	s serObj.ServiceStatus=serflag
	s serObj.UpdateDate=+$h
	s serObj.UpdateTime=$p($h,",",2)
	s serObj.ServiceProvider=serprov
	s tSC=serObj.%Save()
	if $$$ISOK(tSC) {
		do serObj.%Reload()
		s tSC = 1
	}else {
		s tSC = tSC_"^"_$SYSTEM.Status.GetErrorText(tSC)
		tro
		q tSC
	}
	s mthcode=""
	for {
		s mthcode=$o(^Busi.ENS.RegisteredServiceSOAPMethodI("PKMethodCode",sercode,mthcode))
		if (mthcode=""){
			q
		}
		s mthRowid=""
		for {
			s mthRowid=$o(^Busi.ENS.RegisteredServiceSOAPMethodI("PKMethodCode",sercode,mthcode,mthRowid))
			if (mthRowid=""){
				q
			}
			s mthObj=##class(User.EnsRegisteredServiceSOAPMethod).%OpenId(mthRowid)
			s tSerAddr=mthObj.ServiceAddress
			s tComponents=""
			k tComponents
			d ##class(%Net.URLParser).Parse(tSerAddr,.tComponents)
			s tFragment=$g(tComponents("fragment"))
			s tHost=$g(tComponents("host"))
			s tParams=$g(tComponents("params"))
			s tPath=$g(tComponents("path"))
			s tPort=$g(tComponents("port"))
			s tQuery=$g(tComponents("query"))
			s tScheme=$g(tComponents("scheme"))
			if (serport=""){
				s nSerAddr=tScheme_"://"_serhost_tPath
			}else{
				s nSerAddr=tScheme_"://"_serhost_":"_serport_tPath
			}
			if (tParams'=""){
				s nSerAddr=nSerAddr_";"_tParams
			}
			if (tQuery'=""){
				s nSerAddr=nSerAddr_"?"_tQuery
			}
			if (tFragment'=""){
				s nSerAddr=nSerAddr_"#"_tFragment
			}
			s mthObj.ServiceAddress=nSerAddr
			s mthObj.ServiceHost=serhost
			s mthObj.ServicePort=serport
			//lyh 20170517如果服务地址发生变化,暂设置成wsdl地址和location都变化
			s tSerLoc=mthObj.ServiceLocation
			if tSerLoc'=""{
				k tComponents
				d ##class(%Net.URLParser).Parse(tSerLoc,.tComponents)
				s tFragment=$g(tComponents("fragment"))
				s tHost=$g(tComponents("host"))
				s tParams=$g(tComponents("params"))
				s tPath=$g(tComponents("path"))
				s tPort=$g(tComponents("port"))
				s tQuery=$g(tComponents("query"))
				s tScheme=$g(tComponents("scheme"))
				if (serport=""){
					s tSerLoc=tScheme_"://"_serhost_tPath
				}else{
					s tSerLoc=tScheme_"://"_serhost_":"_serport_tPath
				}
				if (tParams'=""){
					s tSerLoc=tSerLoc_";"_tParams
				}
				if (tQuery'=""){
					s tSerLoc=tSerLoc_"?"_tQuery
				}
				if (tFragment'=""){
					s tSerLoc=tSerLoc_"#"_tFragment
				}
				s mthObj.ServiceLocation=tSerLoc
			}
			//lyh20170707增加用户名密码
			s mthObj.ServiceUserName=username
			s mthObj.ServicePassWord=password
			s mthObj.UpdateDate=+$h
			s mthObj.UpdateTime=$p($h,",",2)
			s mthObj.SslCongfig=ssl
			s tSC=mthObj.%Save()
			if $$$ISERR(tSC) {
				q 
			}
		}
	}

	if $$$ISERR(tSC) {
		s tSC = tSC_"^"_$SYSTEM.Status.GetErrorText(tSC)
		tro
	}
	tc
	q tSC
err
	tro
	q $ze
}

/// Input: 服务代码^服务名称^服务描述^服务IP^服务状态^总线代码^服务端口^方法代码^方法描述
/// Debug: w ##class(web.DHCENS.STBLL.REGISTER.DAO.RegisteredService).SaveServiceInfo("^李岩测试1^李岩测试1^127.0.0.1^Y^PUB0001^80^HIPMessageServer^李岩测试方法1")
ClassMethod SaveServiceInfo(serviceInfo As %String) As %String
{
	s $zt="err"
	s serviceSc = 0
	s serviceCode=$p(serviceInfo,"^",1)
	s serviceDesc=$p(serviceInfo,"^",2)
	s serviceNote=$p(serviceInfo,"^",3)
	s serviceIP=$p(serviceInfo,"^",4)
	s serviceStatus=$p(serviceInfo,"^",5)
	s busCode=$p(serviceInfo,"^",6)
	s servicePort=$p(serviceInfo,"^",7)
	s methodCodes=$p(serviceInfo,"^",8)
	s methodDesc=$p(serviceInfo,"^",9)
	s serviceType="SOAP"
	s functionCode=$p(serviceInfo,"^",10)
	if (servicePort="")||(servicePort="80")
	{
		s serviceWSDL="http://"_serviceIP_"/csp/hsb/DHC.Published."_busCode_".BS."_busCode_".cls?wsdl"
	}
	else
	{
		s serviceWSDL="http://"_serviceIP_":"_servicePort_"/csp/hsb/DHC.Published."_busCode_".BS."_busCode_".cls?wsdl"
	}
	ts
	if (serviceCode="")||('$D(^Busi.ENS.RegisteredServiceI("PKServiceCode",serviceCode)))
	{
		s serviceObj=##class(User.EnsRegisteredService).%New()
		s serviceObj.ServiceDesc=serviceDesc
		s serviceObj.ServiceNote=serviceNote
		s serviceObj.ServiceStatus=serviceStatus
		s serviceObj.ServiceType="SOAP"
		s serviceObj.BusCode=busCode
		s serviceObj.UpdateDate=+$h
		s serviceObj.UpdateTime=$p($h,",",2)
		s serviceSc=serviceObj.%Save()
		if serviceSc'=1 {
			tro
			q -1
		}
		s serviceid=serviceObj.%Id()
		s serviceCode=$LG(^Busi.ENS.RegisteredServiceD(serviceid),2)
		s tSerAddr=serviceWSDL
		s tComponents=""
		k tComponents
		d ##class(%Net.URLParser).Parse(tSerAddr,.tComponents)
		s tFragment=$g(tComponents("fragment"))
		s tHost=$g(tComponents("host"))
		s tParams=$g(tComponents("params"))
		s tPath=$g(tComponents("path"))
		s tPort=$g(tComponents("port"))
		s tQuery=$g(tComponents("query"))
		s tScheme=$g(tComponents("scheme"))
		if (servicePort="")||(servicePort="80"){
			s nSerAddr=tScheme_"://"_serviceIP_tPath
		}else{
			s nSerAddr=tScheme_"://"_serviceIP_":"_servicePort_tPath
		}
		if tParams'="" s nSerAddr=nSerAddr_";"_tParams
		if tQuery'="" s nSerAddr=nSerAddr_"?"_tQuery
		if tFragment'="" s nSerAddr=nSerAddr_"#"_tFragment
		s mthcode="",mthSc=0
		s len=$Length(methodCodes,",")
		f mcount=1:1:len {
			s mthcode=$p(methodCodes,",",mcount)
			continue:mthcode=""
			s mthObj=##class(User.EnsRegisteredServiceSOAPMethod).%New()
			s mthObj.ServiceCode=serviceCode
			s mthObj.ServiceHost=serviceIP
			s mthObj.ServicePort=servicePort
			s mthObj.ServiceAddress=nSerAddr
			s mthObj.ServiceLocation=nSerAddr
			s mthObj.MethodCode=mthcode 
			s mthObj.MethodDesc=methodDesc
			s mthObj.BusCode=busCode
			s mthObj.ReturnVal="%GlobalCharacterStream"
			s mthObj.MethodStatus="Y"
			s mthSc=mthObj.%Save()
			if $$$ISOK(mthSc) {
				do mthObj.%Reload()
				s mthSc = 1
			}
			else {
				s mthSc = $SYSTEM.Status.GetErrorText(mthSc)
				q 
			}
			s paramSc=0
			f paramCount=1:1:2 {
				s paramObj=##class(User.EnsRegisteredServiceSOAPParameter).%New()
				s paramObj.ServiceCode=serviceCode
				s paramObj.MethodCode=mthcode
				s paramObj.ParameterCode="input"_paramCount
				if paramCount=1 {
					s paramObj.ParameterDesc="标记位参数"
					s paramObj.DataType="%String"
				}
				else  {
					s paramObj.ParameterDesc="入参内容"
					s paramObj.DataType="%GlobalCharacterStream"
				}
				s paramObj.UpdateDate=+$h
				s paramObj.UpdateTime=$p($h,",",2)
				s paramSc=paramObj.%Save()	
				if $$$ISOK(paramSc) {
					do paramObj.%Reload()
					s paramSc = 1
				}else {
					s paramSc = $SYSTEM.Status.GetErrorText(paramSc)
					q
				}
			}
			if paramSc'=1 {
				s mthSc=-1
				q
			}
		}
		if mthSc'=1 {
			tro
			q -1
		}
	}
	else  {
		s serviceRowid=$o(^Busi.ENS.RegisteredServiceI("PKServiceCode",serviceCode,""))
		if +serviceRowid=0 {
			tro
			q -1
			}
		s serviceObj=##class(User.EnsRegisteredService).%OpenId(serviceRowid)
		s serviceObj.ServiceDesc=serviceDesc
		s serviceObj.ServiceNote=serviceNote
		s serviceObj.ServiceStatus=serviceStatus
		s serviceObj.ServiceType="SOAP"
		s serviceObj.BusCode=busCode
		s serviceObj.UpdateDate=+$h
		s serviceObj.UpdateTime=$p($h,",",2)
		s serviceSc=serviceObj.%Save()
		if serviceSc'=1 {
			tro
			q -1
		}
		s tSerAddr=serviceWSDL
		s tComponents=""
		k tComponents
		d ##class(%Net.URLParser).Parse(tSerAddr,.tComponents)
		s tFragment=$g(tComponents("fragment"))
		s tHost=$g(tComponents("host"))
		s tParams=$g(tComponents("params"))
		s tPath=$g(tComponents("path"))
		s tPort=$g(tComponents("port"))
		s tQuery=$g(tComponents("query"))
		s tScheme=$g(tComponents("scheme"))
		if (servicePort="")||(servicePort="80"){
			s nSerAddr=tScheme_"://"_serviceIP_tPath
		}else{
			s nSerAddr=tScheme_"://"_serviceIP_":"_servicePort_tPath
		}
		if tParams'="" s nSerAddr=nSerAddr_";"_tParams
		if tQuery'="" s nSerAddr=nSerAddr_"?"_tQuery
		if tFragment'="" s nSerAddr=nSerAddr_"#"_tFragment
		s mthcode="",mthSc=0
		f {
			s mthcode=$o(^Busi.ENS.RegisteredServiceSMetI("PKMethodCode",serviceCode,mthcode))
			q:mthcode=""
			s mthRowid=$o(^Busi.ENS.RegisteredServiceSMetI("PKMethodCode",serviceCode,mthcode,""))
			continue:+mthRowid=0
			s mthObj=##class(User.EnsRegisteredServiceSOAPMethod).%OpenId(mthRowid)
			s mthObj.ServiceCode=serviceCode
			s mthObj.ServiceHost=serviceIP
			s mthObj.ServicePort=servicePort
			s mthObj.ServiceAddress=nSerAddr
			s mthObj.ServiceLocation=nSerAddr
			s mthObj.BusCode=busCode
			s mthSc=mthObj.%Save()
			if $$$ISOK(mthSc) {
				do mthObj.%Reload()
				s mthSc = 1
			}
			else {
				s mthSc = $SYSTEM.Status.GetErrorText(mthSc)
				q 
			}
		}
		if mthSc'=1 {
			tro
			q -1
		}
	}
	tc
	q 1_"^"_serviceWSDL
err
	if $tlevel>0  tro
	q -1_"^"_$ze
}

}

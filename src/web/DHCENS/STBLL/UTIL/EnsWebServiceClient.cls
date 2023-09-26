Class web.DHCENS.STBLL.UTIL.EnsWebServiceClient Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.Method.EnsWebServiceClient).SaveEnsWebServiceClientInfo("")
ClassMethod SaveEnsWebServiceClientInfo(Input As %String) As %String
{
	set $zt="Exception"
	set eventStatus=$p(Input,$char(2),1)
	set serviceCode=$p(Input,$char(2),2)
	set serviceDesc=$p(Input,$char(2),3)
	set serviceRemarks=$p(Input,$char(2),4)
	set ipAddress=$p(Input,$char(2),5)
	set port=$p(Input,$char(2),6)
	set pLocationURL=$p(Input,$char(2),7)
	set serviceName=$p(Input,$char(2),8)
	set pPackage=$p(Input,$char(2),9)
	set userName=$p(Input,$char(2),10)
	set passWord=$p(Input,$char(2),11)
	set serviceProcuctionTerm=$p(Input,$char(2),12)
	set useFlag=$p(Input,$char(2),13)
	set langues=$p(Input,$char(2),14)
	set rowId=$o(^User.EnsWebServiceClientI("SoapServiceCode",serviceCode,""))
	if ((eventStatus="add")&&(rowId'="")) {
		Quit "-1^服务代码已经注册"
	}
	elseif ((eventStatus="add")&&(rowId="")) {
		set serviceObj=##class(User.EnsWebServiceClient).%New()
		set id=$o(^User.EnsWebServiceClientI("ServiceName",pPackage,serviceName,""))
		if id'="" {
			set obj=##class(User.EnsWebServiceClient).%OpenId(id)
			Quit:id'="" "-1^此代理类名称已经存在，同服务"_obj.serviceCode_"重复"
		}
		set serviceObj.serviceCode=serviceCode
		set serviceObj.insertDate=+$h
		set serviceObj.insertTime=$p($h,",",2)
	}
	elseif ((eventStatus="update")&&(rowId="")) {
		Quit "-1^服务代码不存在"
	}
	else {
		set serviceObj=##class(User.EnsWebServiceClient).%OpenId(rowId)
	}
	set sc=1
	set reader = ##class(%SOAP.WSDL.Reader).%New()
	set sc=reader.Process(pLocationURL,pPackage)
	Quit:sc'=1 "-1^引用WSDL服务地址异常："_sc
	set serviceObj.serviceDesc=serviceDesc
	set serviceObj.serviceRemarks=serviceRemarks
	set serviceObj.ipAddress=ipAddress
	set serviceObj.port=port
	set serviceObj.soapUrl=pLocationURL
	set serviceObj.serviceName=serviceName
	set serviceObj.className=pPackage
	set serviceObj.userName=userName
	set serviceObj.passWord=passWord
	set serviceObj.serviceProcuctionTerm=serviceProcuctionTerm
	set serviceObj.useFlag=useFlag
	set serviceObj.langues=langues
	set serviceObj.updateDate=+$h
	set serviceObj.updateTime=$p($h,",",2)
	set sc=serviceObj.%Save()
	//set project=##class(%Studio.Project).%New()
	//set sc=project.AddItem("web.DHCENS.SOAP.EnsWebServiceSoap","CLS")
	Quit sc
Exception
	Quit "-1^"_$ze
}

/// Creator：WuXianPu
/// CreatDate：2015—03-09
/// Description：服务列表信息查询
/// Table：User.EnsWebServiceClient
/// Input：id,code,desc,productionName,status,hisVersion
/// Output：返回符合条件的方法列表
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.Method.EnsWebServiceClient","GetEnsWebServiceClientData","^^^^ALL")
Query GetEnsWebServiceClientData(Input As %String) As %Query(ROWSPEC = "id:%String,code:%String,desc:%String,serviceName:%String,ipAddress:%String,port:%String,productionName:%String,status:%String,pPackage:%String")
{
}

ClassMethod GetEnsWebServiceClientDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set selCode=$p(Input,"^",1)
	set selDesc=$p(Input,"^",2)
	set selIpAdd=$p(Input,"^",3)
	set selProName=$p(Input,"^",4)
	set selStatus=$p(Input,"^",5)
	set QHandle=$lb(0,repid,0)
	set id=""  for  set id=$o(^User.EnsWebServiceClientD(id)) Quit:id=""  d
	.set serviceInfo=^User.EnsWebServiceClientD(id)
	.set code=$lg(serviceInfo,2)
	.Quit:('(code[selCode)&&(selCode'=""))
	.set desc=$lg(serviceInfo,3)
	.Quit:('(desc[selDesc)&&(selDesc'=""))
	.set productionName=$lg(serviceInfo,17)
	.Quit:('(productionName[selProName)&&((selProName'="")&&(selProName'="全部")))
	.set status=$lg(serviceInfo,18)
	.Quit:((status'=selStatus)&&((selStatus'="")&&(selStatus'="ALL")))
	.set serviceName=$lg(serviceInfo,8)	
	.set ipAddress=$lg(serviceInfo,5)
	.Quit:('(ipAddress[selIpAdd)&&(selIpAdd'=""))
	.set port=$lg(serviceInfo,6)
	.set pPackage=$lg(serviceInfo,9)
	.set ^CacheTemp(repid,ind)=$lb(id,code,desc,serviceName,ipAddress,port,productionName,status,pPackage)
	.set ind=ind+1
	k ^TMPIMP
	Quit $$$OK
}

ClassMethod GetEnsWebServiceClientDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetEnsWebServiceClientDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
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

/// Creator：WuXianPu
/// CreatDate：2015—03-09
/// Description：厂商信息
/// Table：User.EnsWebServiceClient
/// Input：GetServiceProcuctionTermData
/// Output：返回产品组信息列表
/// Return：sc=##class(User.EnsSendDataInfo).%BuildIndices()
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.Method.EnsWebServiceClient","GetServiceProcuctionTermData","")
Query GetServiceProcuctionTermData(Input As %String) As %Query(ROWSPEC = "serviceProcuctionTerm:%String")
{
}

ClassMethod GetServiceProcuctionTermDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	if Input="all" {
		set ^CacheTemp(repid,ind)=$lb("全部")
		set ind=ind+1
	}
	set productionName=""  for  set productionName=$o(^User.EnsWebServiceClientI("ServiceProcuctionTerm",productionName)) Quit:productionName=""  d
	.set ^CacheTemp(repid,ind)=$lb(productionName)
	.set ind=ind+1
	Quit $$$OK
}

ClassMethod GetServiceProcuctionTermDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetServiceProcuctionTermDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
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

/// Creator：WuXianPu
/// CreatDate：2015—03-09
/// Description：语言信息
/// Table：User.EnsWebServiceClient
/// Input：GetServiceProcuctionTermData
/// Output：返回语言信息列表
/// Return：sc=##class(User.EnsWebServiceClient).%BuildIndices()
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.Method.EnsWebServiceClient","GetServiceLanguesData","")
Query GetServiceLanguesData(Input As %String) As %Query(ROWSPEC = "langues:%String")
{
}

ClassMethod GetServiceLanguesDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	if Input="all" {
		set ^CacheTemp(repid,ind)=$lb("全部")
		set ind=ind+1
	}
	set langues=""  for  set langues=$o(^User.EnsWebServiceClientI("Langues",langues)) Quit:langues=""  d
	.set ^CacheTemp(repid,ind)=$lb(langues)
	.set ind=ind+1
	Quit $$$OK
}

ClassMethod GetServiceLanguesDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetServiceLanguesDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
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

/// Creator：WuXianPu
/// CreatDate：2015—03-10
/// Description：服务详细信息
/// Table：User.EnsWebServiceClient
/// Input：
/// Output：
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.Method.EnsWebServiceClient","GetEnsWebServiceClientDetailInfo","1")
Query GetEnsWebServiceClientDetailInfo(Input As %String) As %Query(ROWSPEC = "serviceCode:%String,serviceDesc:%String,serviceRemarks:%String,ipAddress:%String,port:%String,soapUrl:%String,serviceName:%String,className:%String,userName:%String,passWord:%String,serviceProcuctionTerm:%String,useFlag:%String,langues:%String")
{
}

ClassMethod GetEnsWebServiceClientDetailInfoExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set id=$p(Input,"^",1)
	set obj=##class(User.EnsWebServiceClient).%OpenId(id)
	set serviceCode=obj.serviceCode
	set serviceDesc=obj.serviceDesc
	set serviceRemarks=obj.serviceRemarks
	set ipAddress=obj.ipAddress
	set port=obj.port
	set soapUrl=obj.soapUrl
	set serviceName=obj.serviceName
	set className=obj.className
	set userName=obj.userName
	set passWord=obj.passWord
	set serviceProcuctionTerm=obj.serviceProcuctionTerm
	set useFlag=obj.useFlag
	set langues=obj.langues	
	set ^CacheTemp(repid,ind)=$lb(serviceCode,serviceDesc,serviceRemarks,ipAddress,port,soapUrl,serviceName,className,userName,passWord,serviceProcuctionTerm,useFlag,langues)
	set ind=ind+1
	k ^TMPIMP
	Quit $$$OK
}

ClassMethod GetEnsWebServiceClientDetailInfoClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetEnsWebServiceClientDetailInfoFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
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

/// Desc:删除方法
/// w ##class(web.DHCENS.Method.EnsWebServiceClient).DelEnsWebServiceClientInfo("1")
ClassMethod DelEnsWebServiceClientInfo(Input As %String) As %String
{
	s $zt="Exception"
	ts
	set rowId=$p(Input,"^",1)
	set obj=##class(User.EnsWebServiceClient).%OpenId(rowId)
	s sc=0
	if ($IsObject(obj)) {
		s sc=##class(User.EnsWebServiceClient).%DeleteId(rowId)
		if (sc'="1") {
			tro
			Quit "-1^删除方法"_obj.serviceCode_"数据失败"
		}	
		else {
			tc
			Quit "0^成功"
		}
	}
	else {
		tro
		Quit "-1^方法不存在"
	}
Exception
	tro
	Quit "-1^"_$ze
}

/// Desc: 更改方法状态
/// w ##class(web.DHCENS.Method.EnsWebServiceClient).UpdateEnsWebServiceClientStatus("9")
ClassMethod UpdateEnsWebServiceClientStatus(Input As %String) As %String
{
	s $zt="Exception"
	ts
	s id=$p(Input,"^",1)
	s obj=##class(User.EnsWebServiceClient).%OpenId(id)
	if '$isobject(obj) {
		q "方法不存在"
	}
	if obj.useFlag="Y" {
		s obj.useFlag="N"
	}
	else {
		s obj.useFlag="Y"
	}
	s sc=obj.%Save()
	if (sc'=1) {
		tro
		q "-1^状态保存失败"
	}
	tc
	Quit 1
Exception
	tro
	Quit "-1^"_$ze
}

}

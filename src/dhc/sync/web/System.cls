Class dhc.sync.web.System Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("dhc.sync.web.System","Find","","","")
Query Find(Code, Name, Active) As websys.Query(CONTAINID = 1, ROWSPEC = "SysRowId:%String,SysCode:%String,SysName:%String,SysActive:%String,SysPublicKey:%String,SysPrivateKey:%String,SysEnc:%String,SysEnsemble:%String,SysWSDLUrl:%String,SysClsName:%String,SysMthName:%String")
{
}

/// by wuqk 2011-05-27 未完成，全查；RUDesc 响应单位 关系不清楚
ClassMethod FindExecute(ByRef QHandle As %Library.Binary, Code, Name, Active) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	Set SysRowId=""
	for {
		Set SysRowId = $Order(^dhcsyncSystemD(SysRowId))
		Quit:SysRowId=""
		If $d(^dhcsyncSystemD(SysRowId),g){
			Set SysCode = $lg(g,2)
			Continue:(Code'="")&&(SysCode'[Code)
			Set SysName = $lg(g,3)
			Continue:(Name'="")&&(SysName'[Name)
			Set SysActive = $lg(g,4)
			Continue:(Active'="")&&(SysActive'=Active)
			Set $list(g,1)=SysRowId
			Set ^CacheTemp(repid,ind)=g
			Set ind=ind+1
		}
	}
	Set QHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod Save(RowId, Code, Name, Active, PublicKey, PrivateKey, Enc, Ensemble, WSDLUrl, ClsName, MthName)
{
	;Set ^Temp("wanghc")=RowId_","_ Code_","_ Name_","_ Active_","_ PublicKey_","_ PrivateKey_","_ Enc_","_Ensemble
	If RowId>0{
		Set Obj = ##class(dhc.sync.data.System).%OpenId(RowId)
	}else{
		Set Obj = ##class(dhc.sync.data.System).%New()
		If $d(^dhcsyncSystemI("syncSysCode",Code))>0 {
			Quit "-100^"_Code_"已存在"
		}
	}
	Set Obj.Code = Code
	
	Set Obj.Name = Name
	Set Obj.Active = Active
	Set Obj.PublicKey = PublicKey
	Set Obj.PrivateKey = PrivateKey
	Set Obj.Enc = Enc
	Set Obj.Ensemble = Ensemble
	;可以配置类名与通过WSDL生成
	if (WSDLUrl'=""){
		Set ClsName = ..GetServiceClsName(WSDLUrl)
		if (ClsName'=""){
			if ##class(websys.Conversions).IsValidMethodName(ClsName,"SaveData")  {
				Set MthName = "SaveData"
			}elseif( ##class(websys.Conversions).IsValidMethodName(ClsName,"saveData")){
				Set MthName = "saveData"
			}elseif( ##class(websys.Conversions).IsValidMethodName(ClsName,"Save")){
				Set MthName = "Save"
			}elseif(##class(websys.Conversions).IsValidMethodName(ClsName,"SwitchSystem")){
				Set MthName = "SwitchSystem"
			}else{
				Set MthName=""
			}	
		}else{
			Set MthName=""
		}
		Set Obj.WSDLUrl = WSDLUrl
	}else{
		Set Obj.WSDLUrl = ""
	}
	Set Obj.ClsName = ClsName
	Set Obj.MthName = MthName
	Set sc = Obj.%Save()
	
	If $$$ISERR(sc) set Obj="" Quit "-100^"_$SYSTEM.Status.GetErrorText(sc)
	Set rtn = Obj.%Id(),Obj=""
	if (WSDLUrl'="")&(MthName=""){Quit "-101^接口WebService中必须包含SaveData方法用于同步数据!"}
	Quit rtn
}

ClassMethod Del(RowId)
{
	Quit:RowId="" ""
	set sc = ##class(dhc.sync.data.System).%DeleteId(RowId)
	If $$$ISERR(sc) set Obj="" Quit "-100^"_$SYSTEM.Status.GetErrorText(sc)
	Quit RowId
}

/// wanghc 2016-07-26
/// 通过webservice生成代理类,且返回类名
/// d ##class(dhc.sync.web.System).GetServiceClsName("http://172.19.19.58/dthealth/web/dhcservice.SynchronizeUserLoc.cls?wsdl")
/// d ##class(dhc.sync.web.System).GetServiceClsName("http://127.0.0.1/dthealth/web/dhcservice.SynchronizeUserLoc.cls?wsdl")
ClassMethod GetServiceClsName(wsdl, package = "dhc.sync.ws")
{
	if (wsdl["dhcservice.SynchronizeUserLoc.cls"){
		set wsdl = $p(wsdl,"?")_"?wsdl=1&CacheUserName=dhwebservice&CachePassword=dhwebservice&CacheNoRedirect=1"
	}
	set reader = ##class(%SOAP.WSDL.Reader).%New()
	Set reader.CompileFlags="ck/displaylog=0"
	set soapsc = reader.Process(wsdl,package)
	Set CN=$order(reader.ClientClassList(""))
	set reader=""
	Quit CN
}

}

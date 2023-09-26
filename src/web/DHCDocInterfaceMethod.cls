Class web.DHCDocInterfaceMethod Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor)
{

/// 超时时间(秒)
Parameter TimeOut = 2;

/// 超时描述
Parameter TimeOutDesc = "网络请求超时";

/// Creator：宋春莉
/// CreatDate：2020—08-01
/// Description：保存接口注册方法
/// Table：User.DocInterfaceMethod
/// w ##class(web.DHCDocInterfaceMethod).SaveDocInterfaceMethodInfo()
ClassMethod SaveDocInterfaceMethodInfo(tmpAllInPar As %String, tmpAllOutPar As %String, Input...) As %String
{
	set $zt="Exception"
	
	s RowId=$g(Input(1))
	s interfaceCode=$g(Input(2))
	s interfaceName=$g(Input(3))
	s interfaceSttDate=$g(Input(4))
	s ProductLine=$g(Input(5))
	s Active=$g(Input(6))
	s isLocal=$g(Input(7))
	s methodInvokType=$g(Input(8))
	s ProductLinkGroup=$g(Input(9))
	s methodClassName=$g(Input(10))
	s methodName=$g(Input(11))
	s methodType=$g(Input(12))
	s methodNote=$g(Input(13))
	s ExptJson=$g(Input(14))
	s ExptObj={}.%FromJSON(ExptJson)
	s interfaceType=ExptObj."interfaceType"
	s interfaceLogFalg=ExptObj."LogFlag"
	s:interfaceSttDate="" interfaceSttDate=..%ZD(+$h)
	
	s UniqeStr=##class(web.DHCDocInterfaceLog).CheckInterfaceCode(RowId,interfaceCode,"Method")
	Q:(+UniqeStr'=0) $p(UniqeStr,"^",1,2)
	s LogRowId=$p(UniqeStr,"^",3)
	
	ts
	if (RowId="") {
		s methodObj=##class(User.DocInterfaceMethod).%New()
	}else{
		s methodObj=##class(User.DocInterfaceMethod).%OpenId(RowId)
	}
	set methodObj.methodCode=interfaceCode
	set methodObj.methodDesc=interfaceName
	set methodObj.methodSttDate=..%ZDH(interfaceSttDate)
	set methodObj.methodProductLine=ProductLine
	set methodObj.methodStatus=Active
	set methodObj.methodLocal=isLocal
	set methodObj.methodInvokType=methodInvokType //$case(methodInvokType,"Service":"S","Call":"C")
	set methodObj.methodProductLinkGroup=ProductLinkGroup
	set methodObj.methodClassName=methodClassName
	set methodObj.methodName=methodName
	set methodObj.methodType=methodType
	set methodObj.methodInput=tmpAllInPar
	set methodObj.methodOutput=tmpAllOutPar
	set methodObj.methodNote=methodNote
	set methodObj.methodPublishClassName="web.DHCDocInterfaceMethod"
	set methodObj.methodPublishName="DHCDocHisInterface"
	set methodObj.interfaceType=interfaceType
	set methodObj.interfaceLogFalg=interfaceLogFalg
	set methodObj.paramsJsonStr=ExptJson
	;set methodObj.paramsExptStr=ExptData
	set methodObj.HTimeout=ExptObj."HTimeout"
	set methodObj.HTimeOutNum=ExptObj."HTimeOutNum"
	set methodObj.HReturnStr=ExptObj."HReturnStr"
	set methodObj.HAutoSwitch=ExptObj."HAutoSwitch"
	set methodObj.HServer=ExptObj."HServer"
	set methodObj.HPort=ExptObj."HPort"
	set methodObj.HDomainFlag=ExptObj."HDomainFlag"
	set methodObj.HPath=ExptObj."HPath"
	set methodObj.HHeaderJson=ExptObj."HHeaderJson"
	set methodObj.HMethodType=ExptObj."HMethodType"
	set methodObj.HContentType=ExptObj."HContentType"
	set methodObj.HHttps=ExptObj."HHttps"
	set methodObj.HSSLCheckServerIdentity=ExptObj."HSSLCheckServerIdentity"
	set methodObj.HSSLConfiguration=ExptObj."HSSLConfiguration"
	
	if Active="Y"{
		s methodObj.SUpdateDate=+$h
		s methodObj.SUpdateTime=$p($h,",",2)
		s methodObj.AutoStop=""
	}
		
	set sc=methodObj.%Save()
	if sc=1 {
		tc
	}else {
		tro
		Q "-1^插入表失败"
	}
	s RowID=methodObj.%Id()
	s methodObj=""
	
	s Code=0
	;如果代码存在日志表信息，或者有日志标识，自动更新日志注册表信息
	i (interfaceLogFalg="Y")||(LogRowId'=""){
		s LogInfo=LogRowId_"^"_interfaceType_"^"_interfaceCode_"^"_interfaceName_"^"_ProductLine_"^"_interfaceLogFalg_"^"_ProductLinkGroup_"^"_methodNote
		s Ret=##class(web.DHCDocInterfaceLog).AutoLogRegistInfo(LogInfo)
		s Code=$p(Ret,"^",1)
	}
	Q:Code=0 "1^保存成功^"_RowID
	Q "1^保存方法注册成功，但自动插入日志注册表失败^"_RowID

Exception
	tro
	Quit "-1^"_$ze
}

/// Creator：宋春莉
/// CreatDate：2020—07-31
/// Description：方法列表信息查询
/// Table：User.DocInterfaceMethod
/// Input：id,code,desc,productionName,status,hisVersion
/// Output：返回符合条件的方法列表
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCDocInterfaceMethod","GetDocInterfaceMethodData","^^^^ALL")
Query GetDocInterfaceMethodData(Input As %String) As websys.Query(ROWSPEC = "id:%String,code:%String,desc:%String,MethodInvokType:%String,methodProductLine:%String,methodProductLinkGroup:%String,MethodStatus:%String,interfaceType:%String,LogFlag:%String,AutoStop,StopLogID")
{
}

ClassMethod GetDocInterfaceMethodDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set searchMethodInvokType=$p(Input,"^",1)
	set searchMethodCode=$p(Input,"^",2)
	set searchMethodName=$p(Input,"^",3)
	set searchProductLine=$p(Input,"^",4)
	set searchProductLinkGroup=$p(Input,"^",5)
	set searchActive=$p(Input,"^",6)
	set searchInterfaceType=$p(Input,"^",7)
	set QHandle=$lb(0,repid,0)
	set id=""  
	for  {
		set id=$o(^User.DocInterfaceMethodD(id)) Quit:id=""  d
		set methodInfo=^User.DocInterfaceMethodD(id)
		set code=$lg(methodInfo,2)
		continue:('(code[searchMethodCode)&&(searchMethodCode'=""))
		set desc=$lg(methodInfo,3)
		continue:('(desc[searchMethodName)&&(searchMethodName'=""))
		set methodProductLine=$lg(methodInfo,5)
		continue:('(("#"_searchProductLine_"#")[("#"_methodProductLine_"#"))&&(searchProductLine'=""))
		set methodProductLine=$case(methodProductLine,"Reg":"患者管理","OPAdm":"预约挂号系统","Alloc":"门诊护士分诊系统","OPDoc":"门诊医生站","IPDoc":"住院医嘱系统","Pilot":"临床药理试验系统","Cure":"治疗科室系统","Ant":"抗菌药物管理")
		set methodProductLinkGroup=$lg(methodInfo,9)
		continue:('(methodProductLinkGroup[searchProductLinkGroup)&&(searchProductLinkGroup'=""))
		set MethodInvokType=$lg(methodInfo,8)
		continue:('(MethodInvokType[searchMethodInvokType)&&(searchMethodInvokType'=""))
		set MethodInvokType=$case(MethodInvokType,"S":"服务","C":"调用")
		set MethodStatus=$lg(methodInfo,6)
		continue:('(MethodStatus[searchActive)&&(searchActive'=""))&&(searchActive'="ALL")
		set MethodStatus=$case(MethodStatus,"Y":"运行","N":"停用")
		set interfaceType=$lg(methodInfo,20)
		continue:(searchInterfaceType'="ALL")&&(searchInterfaceType'=interfaceType)
		set LogFlag=$lg(methodInfo,21)	
		set AutoStop=$lg(methodInfo,41)
		set StopLogID=$lg(methodInfo,42)	
		
		set ^CacheTemp(repid,ind)=$lb(id,code,desc,MethodInvokType,methodProductLine,methodProductLinkGroup,MethodStatus,interfaceType,LogFlag,AutoStop,StopLogID)
		set ind=ind+1
	}
	Quit $$$OK
}

/// Creator：宋春莉
/// CreatDate：2020—08-01
/// Description：入参信息
/// Table：User.DocInterfaceMethod
/// Output：返回入参信息列表
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCDocInterfaceMethod","GetMethodInputData","1")
Query GetMethodInputData(Input As %String) As websys.Query(ROWSPEC = "type:%String,requireFlag:%String,desc:%String,descHidden:%String,extNoteHidden:%String,keyname:%String")
{
}

ClassMethod GetMethodInputDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set methodInput=$lg($g(^User.DocInterfaceMethodD(Input)),13)
	Quit:methodInput="" $$$OK
	set length=$l(methodInput,$C(28))
	for i=1:1:length {
		set tmp=$p(methodInput,$C(28),i)
		set type=$p(tmp,$C(14),1)
		if ("undefined"=type) {
			s type=""
		}
		set flag=$p(tmp,$C(14),2)
		set desc=$p(tmp,$C(14),3)
		set note=$p(tmp,$C(14),4)
		set extNoteHidden=$p(tmp,$C(14),5)
		set keyname=$p(tmp,$C(14),6)
		set ^CacheTemp(repid,ind)=$lb(type,flag,desc,note,extNoteHidden,keyname)
		set ind=ind+1
	}
	Quit $$$OK
}

/// Creator：宋春莉
/// CreatDate：2020—08-01
/// Description：出参信息
/// Table：User.DocInterfaceMethod
/// Output：返回入参信息列表
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCDocInterfaceMethod","GetMethodOutputData","1")
Query GetMethodOutputData(Input As %String) As websys.Query(ROWSPEC = "type:%String,desc:%String,descHidden:%String,extNoteHidden:%String,keyname:%String")
{
}

ClassMethod GetMethodOutputDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set methodOutput=$lg($g(^User.DocInterfaceMethodD(Input)),14)
	Quit:methodOutput="" 
	set length=$l(methodOutput,$C(28))
	for i=1:1:length {
		set tmp=$p(methodOutput,$C(28),i)
		set type=$p(tmp,$C(14),1)
		set desc=$p(tmp,$C(14),2)
		set descHidden=$p(tmp,$C(14),3)
		set extNoteHidden=$p(tmp,$C(14),4)
		set keyname=$p(tmp,$C(14),5)
		set ^CacheTemp(repid,ind)=$lb(type,desc,descHidden,extNoteHidden,keyname)
		set ind=ind+1
	}
	Quit $$$OK
}

/// Creator：宋春莉
/// CreatDate：2020—08-01
/// Description：方法详细信息
/// Table：User.DocInterfaceMethod
/// Input：
/// Output：返回his版本信息信息列表
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCDocInterfaceMethod","GetDocInterfaceMethodDetailInfo","1")
Query GetDocInterfaceMethodDetailInfo(Input As %String) As websys.Query(ROWSPEC = "methodCode:%String,methodDesc:%String,methodSttDate:%String,methodStatus:%String,methodLocal:%String,methodInvokType:%String,methodProductLinkGroup:%String,methodClassName:%String,methodName:%String,methodType:%String,methodNote:%String,methodProductLine:%String,methodPublishClassName:%String,methodInputDesc:%String,methodOutputDesc:%String,interfaceType:%String,interfaceLogFalg:%String")
{
}

ClassMethod GetDocInterfaceMethodDetailInfoExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set id=$p(Input,"^",1)
	set obj=##class(User.DocInterfaceMethod).%OpenId(id)
	set methodCode=obj.methodCode
	set methodDesc=obj.methodDesc
	set methodSttDate=..%ZD(obj.methodSttDate)
	set methodStatus=obj.methodStatus
	set methodLocal=obj.methodLocal
	set methodInvokType=obj.methodInvokType
	set methodProductLinkGroup=obj.methodProductLinkGroup
	set methodClassName=obj.methodClassName
	set methodName=obj.methodName
	set methodType=obj.methodType
	set methodNote=obj.methodNote
	set methodProductLine=obj.methodProductLine
	set interfaceType=obj.interfaceType
	set interfaceLogFalg=obj.interfaceLogFalg
	set tMethodInput=""
	set inputDesc=obj.methodInput
	set outputDesc=obj.methodOutput
	set length=$l(inputDesc,$C(28))
	set methodInputDesc=""
	for i=1:1:length {
		set str=$p(inputDesc,$C(28),i)
		Quit:str=""
		set desc=$p(str,$C(14),3)
		set parmcode=$p(str,$C(14),6)
		set:parmcode="" parmcode="input"_i
		if methodInputDesc="" {
			set methodInputDesc=parmcode_":"_desc
		}else {
			set methodInputDesc=methodInputDesc_", "_parmcode_":"_desc
		}
	}
	set methodInputDesc="KeyName(固定值):"_methodCode_", "_methodInputDesc
	set methodOutputDesc=""
	//set methodOutputDesc="数值类型:"_$p(outputDesc,$char(2),1)_",返回值描述:"_$p(outputDesc,$char(2),2)
	for i=1:1:$l(outputDesc,$C(28)) {
		set str=$p(outputDesc,$C(28),i)
		Quit:str=""
		set desc=$p(str,$C(14),2)
		set parmcode=$p(str,$C(14),5)
		set:parmcode="" parmcode="output"_i
		if methodOutputDesc="" {
			set methodOutputDesc=parmcode_":"_desc
		}else {
			set methodOutputDesc=methodOutputDesc_", "_parmcode_":"_desc
		}
	}
	for i=1:1:($l(obj.methodInput,$C(28))) {
		s tInput=$p(obj.methodInput,$C(28),i)
		s tType=$p(tInput,$C(14),1)
		s tFlag=$p(tInput,$C(14),2)
		s tDesc=$p(tInput,$C(14),3)
		s parmcode=$p(tInput,$C(14),6)
		s:parmcode="" parmcode="input"_i
		if ((""'=tType)&&("undefined"'=tType)) {
			if (tFlag="Y") {
				s tPar="必填 "_parmcode_" As "_tType
			}else {
				s tPar=parmcode_" As "_tType
			}
			if (""=tMethodInput) {
				s tMethodInput=tPar
			}else {
				s tMethodInput=tMethodInput_", "_tPar
			}
		}
	}

	set methodPublishClassName="set result=##class("_obj.methodPublishClassName_")."_obj.methodPublishName_"(KeyName As %String, "_tMethodInput_")"
	set ^CacheTemp(repid,ind)=$lb(methodCode,methodDesc,methodSttDate,methodStatus,methodLocal,methodInvokType,methodProductLinkGroup,methodClassName,methodName,methodType,methodNote, methodProductLine,methodPublishClassName,methodInputDesc,methodOutputDesc,interfaceType,interfaceLogFalg)
	set ind=ind+1
	
	Quit $$$OK
}

/// Creator：宋春莉
/// CreatDate：2020—08-01
/// Description：删除方法
/// Table：User.DocInterfaceMethod
/// Input：
/// Return：
/// w ##class(web.DHCDocInterfaceMethod).delDocInterfaceMethodInfo("1")
ClassMethod delDocInterfaceMethodInfo(Input As %String) As %String
{
	s $zt="Exception"
	ts
	set rowId=$p(Input,"^",1)
	set obj=##class(User.DocInterfaceMethod).%OpenId(rowId)
	s sc=0
	if ($IsObject(obj)) {
		s sc=##class(User.DocInterfaceMethod).%DeleteId(rowId)
		if (sc'="1") {
			tro
			Quit "-1^删除数据失败"
		}else {
			tc
			Quit "0^成功"
		}
	}else {
		tro
		Quit "-1^方法不存在"
	}
Exception
	tro
	Quit "-1^"_$ze
}

/// Creator：宋春莉
/// CreatDate：2020—08-01
/// Description：更改方法状态
/// Table：User.DocInterfaceMethod
/// Input：
/// Return：
/// w ##class(web.DHCDocInterfaceMethod).UpdateDocInterfaceMethodStatus("1")
ClassMethod UpdateDocInterfaceMethodStatus(Input As %String) As %String
{
	s $zt="Exception"
	ts
	s id=$p(Input,"^",1)
	s obj=##class(User.DocInterfaceMethod).%OpenId(id)
	if '$isobject(obj) {
		q "方法不存在"
	}
	if obj.methodStatus="Y" {
		s obj.methodStatus="N"
	}else {
		s obj.methodStatus="Y"
		s obj.SUpdateDate=+$h
		s obj.SUpdateTime=$p($h,",",2)
		s obj.AutoStop=""
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

/// Creater：李旭
/// Date：2022-04-09
/// Desc：更新方法日志状态以及日志注册状态
/// Debug：w ##class(web.DHCDocInterfaceMethod).UpdateDocInterfaceMethodInfo("5^N")
ClassMethod UpdateDocInterfaceMethodInfo(Input As %String) As %String
{
	s $zt="UpdateDocInterfaceMethodInfo"
	s RowID=$p(Input,"^",1)
	s LogFlag=$p(Input,"^",2)
	s LogFlag=$case(LogFlag,"Y":"Y",:"N")
	Q:(+RowID=0) "-1^缺少表ID"
	
	&SQL(UPDATE SQLUser.Doc_InterfaceMethod SET interface_LogFalg =:LogFlag WHERE %ID=:RowID)
	if SQLCODE {
		Q "-1^更新表失败SQLCode:"_SQLCODE_": "_$g(%msg)
	}
	
	;如果代码存在日志表信息，或者有日志标识，自动更新日志注册表信息
	s Code=0,Desc=""
	s MethodInfo=$g(^User.DocInterfaceMethodD(RowID))
	s MethodCode=$lg(MethodInfo,2)
	s MethodName=$lg(MethodInfo,3)
	s ProductLine=$lg(MethodInfo,5)
	s LinkGroup=$lg(MethodInfo,9)
	s MethodNote=$lg(MethodInfo,15)
	s InterfaceType=$lg(MethodInfo,20)
	s LogID=$o(^CF.DOC.Interface.LogRegistI("LogCode",MethodCode,0))
	i (LogFlag="Y")||(LogID'=""){
		s LogInfo=LogID_"^"_InterfaceType_"^"_MethodCode_"^"_MethodName_"^"_ProductLine_"^"_LogFlag_"^"_LinkGroup_"^"_MethodNote
		s Ret=##class(web.DHCDocInterfaceLog).AutoLogRegistInfo(LogInfo)
		s Code=$p(Ret,"^",1)
		s Desc=$p(Ret,"^",2)
	}
	Q:(Code'=0) "-1^更新日志表失败:"_Desc
	Q "0^修改成功"
	
UpdateDocInterfaceMethodInfo
	s $zt=""
	Q "-1^"_$ze
}

/// Creator：宋春莉
/// CreatDate：2020—08-01
/// Description：医生站提供给其他产品组调用统一入口
/// Input：Input:方法参数,KeyName:事件参数
/// Others：w ##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.DiagnosList",6,"","")
ClassMethod DHCDocHisInterface(KeyName As %String, Input...) As %Stream.GlobalCharacter
{
  	s $zt="DHCDocHisInterface"
	Q:(""=KeyName) "-1^接口代码为空!"
	
	s rowId=$o(^User.DocInterfaceMethodI("methodCode",KeyName,""))
	s methodObj=##class(User.DocInterfaceMethod).%OpenId(rowId)
	if '$isobject(methodObj){
		Q "-1^方法不存在!"
	}
	s methodStatus=methodObj.methodStatus
	if (methodStatus="N") {
		Q "-1^方法未启用!"
	}
	s className=methodObj.methodClassName
	s methodName=methodObj.methodName
	s methodType=methodObj.methodType
	s methodInput=methodObj.methodInput
	s interfaceType=methodObj.interfaceType
	s methodInputFlag=methodObj.methodInput			;需要判断是否有入参
	s OutputType=$p($p(methodObj.methodOutput,$char(28),1),$char(2),1)
	s OutputDesc=$p($p(methodObj.methodOutput,$char(28),1),$char(2),2)
	
	s (methodObj,rtn)=""
	i interfaceType="SOAP"{
		;webservice请求接口
		s rtn=..WebServiceInterface(KeyName,Input...)
	}elseif(interfaceType="HTTP"){
		;Http请求接口
		s rtn=..HttpServiceInterface(KeyName,Input...)
	}else{
		s tmpInput=""
		f i=1:1:$g(Input,0){
			s @("Input"_i)=$g(Input(i),"<NULL>")
			if (tmpInput=""){
				s tmpInput="Input"_i
			}else{
				s tmpInput=tmpInput_","_"Input"_i
			}
		}
		;HIS内部接口
		if (methodType="ClassMethod") {
			i methodInputFlag="" s exeStr="rtn=##class("_className_")."_methodName_"()"
			e  s exeStr="rtn=##class("_className_")."_methodName_"("_tmpInput_")"
			s @exeStr
			s rtn=@"rtn"
		}else{
			s exeStr="rset=##class(%ResultSet).%New("""_className_"."_methodName_""")"
			s @exeStr
			s rtn=@"rset"
			i methodInputFlag="" s exeStr="Status=rset.Execute"_"()"
			e  s exeStr="Status=rset.Execute"_"("_tmpInput_")"
			s @exeStr
		}
	}
	;非Query的请求，调用记录统一日志方法
	i (interfaceType'="HIS")||(methodType'="Query"){
		do ##class(web.DHCDocInterfaceLog).SaveInterfaceLog(KeyName,"",rtn,Input...)
	}
	q rtn
				
DHCDocHisInterface
	s $zt=""
	s ermsg=$ze
	s ermsg=..FormatMethodOutPut(KeyName,ermsg,"Web")
	do ##class(web.DHCDocInterfaceLog).SaveInterfaceLog(KeyName,"",$ze,Input...)
	Q "-1^"_ermsg
}

/// Creater：李旭
/// Date：2022-04-01
/// Desc: webservice统一接口方法
/// Input: KeyName:接口代码、InParams：入参
/// w ##class(web.DHCDocInterfaceMethod).WebServiceInterface()
ClassMethod WebServiceInterface(KeyName, InParams...) As %String
{
	s $zt="WebserviceInterface"
	s RowID=$o(^User.DocInterfaceMethodI("methodCode",KeyName,""))
	s methodObj=##class(User.DocInterfaceMethod).%OpenId(RowID,0)
	if '$isobject(methodObj){
		Q "-1^方法不存在!"
	}
	s methodStatus=methodObj.methodStatus
	if (methodStatus="N") {
		Q "-1^方法未启用!"
	}
	s className=methodObj.methodClassName
	s methodName=methodObj.methodName
	s methodInputFlag=methodObj.methodInput			;需要判断是否有入参
	s methodInvokType=methodObj.methodInvokType
	s HTimeout=methodObj.HTimeout					;超时时间
	s:HTimeout="" HTimeout=..#TimeOut	
	s methodObj=""
	
	s tmpInput=""
	f i=1:1:$g(InParams,0){
		s @("Input"_i)=$g(InParams(i),"<NULL>")
		if (tmpInput=""){
			s tmpInput="Input"_i
		}else{
			s tmpInput=tmpInput_","_"Input"_i
		}
	}
	
	s result=""
	i methodInvokType="C" {
		;调用外部webservice接口
		s exeStr="s Obj=##class("_className_").%New()"
		s exeStr=exeStr_" s Obj.Timeout="_HTimeout
		i methodInputFlag="" s exeStr=exeStr_" s rtn=Obj."_methodName_"()"
		e  s exeStr=exeStr_" s rtn=Obj."_methodName_"("_tmpInput_")"
		x exeStr
		s result=@"rtn"
	}else{
		;调用内部接口(需注意是否需要new)
		i methodInputFlag="" s exeStr="rtn=##class("_className_")."_methodName_"()"
		e  s exeStr="rtn=##class("_className_")."_methodName_"("_tmpInput_")"
		s @exeStr
		s result=@"rtn"
	}
	Q result
		
WebserviceInterface
	s $zt=""
	s ermsg=$ze
	i ermsg="<ZSOAP>zInvokeClient+205^%SOAP.WebClient.1" s ermsg=..#TimeOutDesc
	do ##class(web.DHCDocInterfaceLog).SaveInterfaceLog(KeyName,"",ermsg,InParams...)
	
	s ermsg=..FormatMethodOutPut(KeyName,ermsg,"Web")
	q "-1^"_ermsg
}

/// Creater：李旭
/// Date：2022-04-01
/// Desc: Http统一接口方法(请求第三方的入参目前只考虑json串或键值对)
/// Input: KeyName:接口代码、InParams：入参
/// w ##class(web.DHCDocInterfaceMethod).HttpServiceInterface(81,"{""orgCode"":""153707CABAAC49307137D5FA81472233"",""appKey"":""YjAzODA0N2QtM2JkYy00N2YzLWI4YjctOTM4NTQxM2M1Y2I0""}")
ClassMethod HttpServiceInterface(KeyName, InParams...) As %String
{
	s ^templx("HttpServiceInterface")=$lb(KeyName,$g(InParams(1)))
	s $zt="HttpServiceInterface"
	
	s RowID=$o(^User.DocInterfaceMethodI("methodCode",KeyName,""))
	s methodObj=##class(User.DocInterfaceMethod).%OpenId(RowID,0)
	if '$isobject(methodObj){
		Q "-1^方法不存在!"
	}
	s methodStatus=methodObj.methodStatus
	if (methodStatus="N") {
		Q "-1^方法未启用!"
	}
	s className=methodObj.methodClassName
	s methodName=methodObj.methodName
	s methodInvokType=methodObj.methodInvokType
	s paramsJsonStr=methodObj.paramsJsonStr
	s methodInputFlag=methodObj.methodInput
	s methodObj=""
		
	s JsonStr=$g(InParams(1)) 	;请求的入参(一个键值对或json)
	s tmpInput=""
	f i=1:1:$g(InParams,0){
		s @("Input"_i)=$g(InParams(i),"<NULL>")
		if (tmpInput=""){
			s tmpInput="Input"_i
		}else{
			s tmpInput=tmpInput_","_"Input"_i
		}
	}
	i (className'="")&&(methodName'=""){
		;封装的方法不能实现的接口，如果配置了类方法，则直接调用
		i methodInputFlag="" s exeStr="rtn=##class("_className_")."_methodName_"()"
		e  s exeStr="rtn=##class("_className_")."_methodName_"("_tmpInput_")"
		s @exeStr
		s result=@"rtn"
		Q result
	}else{
		;已配置HTTP请求参数
		i (paramsJsonStr'="") {
			s Obj=##class(DHCDoc.Util.FromXML).Json2Arr(paramsJsonStr)
			s HServer=Obj."HServer"
			s HPort=Obj."HPort"
			s HPath=Obj."HPath"	
			s HDomainFlag=Obj."HDomainFlag"
			s HHttps=Obj."HHttps"
			s HSSLConfiguration=Obj."HSSLConfiguration"
			s HSSLCheckServerIdentity=Obj."HSSLCheckServerIdentity"	
			s HTimeout=Obj."HTimeout"
			s:HTimeout="" HTimeout=..#TimeOut
			s HContentType=Obj."HContentType"
			s HMethodType=Obj."HMethodType"
			s HHeaderJson=Obj."HHeaderJson"
			s HContentType=$zcvt(HContentType,"U")
			s HMethodType=$zcvt(HMethodType,"U")
			
			Q:HServer="" "-1^没有配置必要的IP/域名信息"
			
			s httprequest=##class(%Net.HttpRequest).%New()
			s httprequest.Timeout=HTimeout
			s httprequest.ReadRawMode=1			;跨域调用
			i HDomainFlag="Y"{
				;域Flag(如果是直接Get请求域名时，直接在路径中获取)
				i $e(HPath,1)'="/" s HPath="/"_HPath
				s HPath=HServer_HPath
			}else{
				s httprequest.Server=HServer
				s httprequest.Port=HPort
			}
			i HHttps="Y" {
				s httprequest.Https=1
				s httprequest.SSLConfiguration=HSSLConfiguration
				s httprequest.SSLCheckServerIdentity=(HSSLCheckServerIdentity'=0)
			}
			;此处实现Header参数
			i HHeaderJson'=""{
				s HeadArr=##class(DHCDoc.Util.FromXML).Json2Arr(HHeaderJson)
				for len=1:1:HeadArr.%Size(){
					s Key=HeadArr.Data(len)."key"
					s Val=HeadArr.Data(len)."value"
					continue:(Key="")||(Val)
					d httprequest.SetHeader(Key,Val)
				}
			}else{
				;没有默认只增加Content-Type
				d httprequest.SetHeader("Content-Type","application/json;charset=UTF-8")
			}
			i HContentType="FORM-URLENCODED"{
				;考虑key=val&key1=val1
				f len=1:1:$L(JsonStr,"&"){
					s key=$p($p(JsonStr,"&",len),"=",1)
					s val=$p($p(JsonStr,"&",len),"=",2)
					continue:key=""
					i HMethodType="GET"{
						d httprequest.SetParam(key,val)
					}else{
						d httprequest.InsertFormData(key,val)
					}
				}
			}elseif HContentType="JSON"{
				if $IsObject(JsonStr){
					d httprequest.EntityBody.CopyFrom(JsonStr)
				}else{
					d httprequest.EntityBody.Write(JsonStr)
				}
			}
			i HMethodType="GET"{
				s sc= httprequest.Get(Obj.HPath)
			}elseif HMethodType="POST"{
				s sc= httprequest.Post(Obj.HPath)
			}
			i $$$ISERR(sc){
				s ErrMsg=$system.Status.GetErrorText(sc)
				i ErrMsg="错误 #5922: 等待响应超时" {
					s ErrMsg=..#TimeOutDesc
				}
				Q "-1^"_ErrMsg
			}
			
			s response=httprequest.HttpResponse
			i response {
				s StatusCode=response.StatusCode
				s Data=response.Data
				i $IsObject(Data){
					s Stream=##class(%GlobalCharacterStream).%New()
					i Data.Size<30000 {
						;如果字节恰巧被分割，则转编码后的字符串会不对。
						;此处只针对能一次读取的数据进行转码，如果超长，则对每个字段取值后再转码。
						s strData=Data.Read(30000)
						if ##class(ext.util.String).IsUTF8ByteString(strData) {
							;满足utf8编码格式的 按utf8转成字符串
							s strData=$zcvt(strData,"I","UTF8")
						}else{ 
							;按GB18030转
							s strData=$zcvt(strData,"I","GB18030")
						}
						d Stream.Write(strData)
					}else{
						d Stream.CopyFrom(Data)
					}
					Q Stream
				}else{
					Q Data
				}
			}
			Q "-1^请求失败"
		}
		Q "-1^没有配置必要的请求JOSN信息"
	}
	Q "-1^没有进入请求方法"	
	
HttpServiceInterface
	s $zt=""
	s ermsg=$ze
	s ermsg=..FormatMethodOutPut(KeyName,ermsg,"Http")
	do ##class(web.DHCDocInterfaceLog).SaveInterfaceLog(KeyName,"",$ze,InParams...)
	q "-1^"_ermsg
}

/// Desc: 格式化返回值
/// Debug: w ##class(web.DHCDocInterfaceMethod).FormatMethodOutPut(79,"<ZSOAP>zInvokeClient+205^%SOAP.WebClient.1","web")
ClassMethod FormatMethodOutPut(KeyName, ErrMsg, Flag) As %String
{
	s $zt="FormatMethodOutPut"
	s RowID=$o(^User.DocInterfaceMethodI("methodCode",KeyName,""))
	Q:(+RowID=0) ErrMsg

	s Flag=$zcvt(Flag,"U")
	i Flag="WEB"{
		s ErrMsg="<![CDATA["_ErrMsg_"]]>"
	}
	
	s MethodInfo=$g(^User.DocInterfaceMethodD(RowID))
	s ErrStr=$lg(MethodInfo,27)
	i ErrStr'=""{
		s ErrStr=$replace(ErrStr,"?",ErrMsg)
	}
	i ErrStr=""{
		i Flag="WEB" s ErrStr="<Response><Code>-1</Code><Desc>请求异常</Desc></Response>"
		i Flag="HTTP" s ErrStr="{""Response"":{""Code"":""-1"",""Desc"":""请求异常""}}"
	}
	q ErrStr

FormatMethodOutPut
	s $zt=""
	q ErrMsg
}

/// Creater：李旭
/// Date：2022-02-08
/// Desc: 通过表ID获取扩展的JSON数据
/// Debug: w ##class(web.DHCDocInterfaceMethod).GetExtDetailJSONStr()
ClassMethod GetExtDetailJSONStr(Input) As %String
{
	s id=$p(Input,"^",1)
	s methodInfo=$g(^User.DocInterfaceMethodD(id))
	s paramsJsonStr=$lg(methodInfo,22)
	s paramsJsonStr1=$lg(methodInfo,23)
	s paramsExptStr=$lg(methodInfo,24)
	q paramsJsonStr_$c(28)_paramsJsonStr1_$c(28)_paramsExptStr
}

/// Creater：李旭
/// Date：2022-02-08
/// Desc：调试医生站接口注册方法
/// Input: RowID:表Doc_InterfaceMethod的ID、ParamStr:入参串($c(28)拼接)
/// Output：输出的返回值
/// Debug：d ##class(web.DHCDocInterfaceMethod).DebugInterfaceMethod(5,"dischargeNeedArcim"_$c(28)_"2")
/// 	   d ##class(web.DHCDocInterfaceMethod).DebugInterfaceMethod($lg(^templx("DebugInterfaceMethod"),1),$lg(^templx("DebugInterfaceMethod"),2))
ClassMethod DebugInterfaceMethod(RowID, ParamStr) As %String
{
	s $zt="DebugInterfaceMethodErr"
	s ^templx("DebugInterfaceMethod")=$lb(RowID,ParamStr)
	
	s InterfaceInfo=$g(^User.DocInterfaceMethodD(RowID))
	s InterfaceCode=$lg(InterfaceInfo,2)
	s methodType=$lg(InterfaceInfo,12)
	s methodInput=$lg(InterfaceInfo,13)
	
	s tmpInput=""
	for len=1:1:$l(methodInput,$C(28)) {
		s Param=$p(ParamStr,$c(28),len)
		s tmp=$p(methodInput,$C(28),len)
		s type=$p(tmp,$C(14),1)
		if (type="%Stream.GlobalCharacter") {
			s Stream=##class(%Stream.GlobalCharacter).%New()
			d Stream.Write(Param)
			s @("Input"_len)=Stream
		}else{
			s @("Input"_len)=Param
		}
		if (tmpInput=""){
			s tmpInput="Input"_len
		}else{
			s tmpInput=tmpInput_","_"Input"_len
		}
	}
	
	s @("methodCode")=InterfaceCode
	s exeStr="rtn=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface(methodCode,"_tmpInput_")"
	s @exeStr
	s result=@"rtn"
		
	if (methodType="Query")&&($IsObject(result)){
		s ColCounts=result.GetColumnCount()
		for len=1:1:ColCounts {
			s fieldDesc=result.GetColumnHeader(len)
			s fieldCode=result.GetColumnName(len)
			w fieldCode_":"_fieldDesc_":"
		}
		w !
		while(result.Next()){
			for len=1:1:ColCounts {
				s Data=result.GetData(len)
				w Data_":"
			}
			w !
		}
	}else{
		if $IsObject(result){
			d result.OutputToDevice()
		}else{
			w result ,!
		}
	}
	
	Q ""

DebugInterfaceMethodErr
	s $zt=""
	w "-1^"_$ze
	q ""
}

/// Desc：初始化接口注册表中的接口类型(用于部署项目后初始化)
/// Debug：d ##class(web.DHCDocInterfaceMethod).InitInterfaceMethod()
ClassMethod InitInterfaceMethod() As %String
{
	s MethodID=""
	for {
		s MethodID=$o(^User.DocInterfaceMethodD(MethodID))
		Q:MethodID=""
		&SQL(UPDATE SQLUser.Doc_InterfaceMethod SET interface_Type ="HIS" WHERE %ID=:MethodID)
		if SQLCODE {
			w MethodID_"^更新表失败SQLCode:"_SQLCODE_": "_$g(%msg) ,!
		}
	}
	w "完成" ,!
	q ""
}

/// Desc：通过类名、方法名、方法类型反向获取方法出入参及备注
/// Input: CName:类名、MName:方法名、MType:方法类型("Method"/"Query")、OutFlag:(In/Out:入参/出参)
/// Output: json串([{"keyname":"aa","type":"%String","keytype":"%STRING","requireFlag":"Y","desc":"测试"}])
/// Debug：w ##class(web.DHCDocInterfaceMethod).GetMethodParamsStr("web.DHCDocInterfaceMethod","FormatMethodOutPut","Method")
/// Debug：w ##class(web.DHCDocInterfaceMethod).GetMethodParamsStr("web.DHCDocInterfaceMethod","GetDocInterfaceMethodData","Query")
ClassMethod GetMethodParamsStr(CName, MName, MType, OutFlag = "In") As %String
{
	s MType=$zcvt(MType,"U")
	s OutFlag=$zcvt(OutFlag,"U")
	s ^templx("GetMethodParamsStr")=$lb(CName, MName, MType, OutFlag)
	
	s ParamsList=[]
	;返回值,入参,入参备注
	s (RowSpecStr,methodParams,NoteDescStr)=""
	i MType="QUERY"{
		s methodParams=$g(^oddCOM(CName, "q", MName, 34))
		s NoteDescStr=$g(^oddDEF(CName,"q",MName,4))
		s RowSpecStr=$g(^oddDEF(CName,"q",MName,"P","ROWSPEC"))
	}else{
		s methodParams = $g(^oddCOM(CName, "m", MName, 60))
		s NoteDescStr = $g(^oddDEF(CName,"m",MName,4))
		s RowSpecStr=$g(^oddDEF(CName,"m",MName,42))
	}
	s InputNoteStr=$p($p(NoteDescStr,"Input:",2),$c(13,10),1)
	s OutputNoteStr=$p($p(NoteDescStr,"Output:",2),$c(13,10),1)
	s:OutputNoteStr="" OutputNoteStr=$p($p(NoteDescStr,"Return:",2),$c(13,10),1)
	
	i (OutFlag="OUT"){
		;出参
		i MType="QUERY"{
			for len=1:1:$l(RowSpecStr,","){
				s OParamsStr=$p(RowSpecStr,",",len)
				Continue:OParamsStr=""
				do ParamsObjNull
				s KeyName=$p(OParamsStr,":",1)		;参数名
				s KeyType=$p(OParamsStr,":",2)		;参数类型
				s KeyType=$zcvt(KeyType,"U")
				s KeyNote=$p(OParamsStr,":",3)		;参数说明
				i KeyType[("STREAM") s KeyTypeID="%Stream.GlobalCharacter"
				do ParamsObj
			}
		}else{
			do ParamsObjNull
			s KeyType=$zcvt(RowSpecStr,"U")
			i KeyType[("STREAM") s KeyTypeID="%Stream.GlobalCharacter"
			s KeyNote=$zstrip(OutputNoteStr, "*C", " ") 
			do ParamsObj
		}
	}else{
		;入参
		s ParamsNum=$ll(methodParams)
		for len=1:1:ParamsNum{
			s ParamsStr=$lg(methodParams,len)
			Continue:ParamsStr=""
			do ParamsObjNull
			s KeyName=$lg(ParamsStr,1)		;参数名
			s KeyType=$lg(ParamsStr,2)		;参数类型
			s KeyType=$zcvt(KeyType,"U")
			s KeyRef=$lg(ParamsStr,3)		;"&":引用类型
			s DefaultVal=$lg(ParamsStr,4)	;默认值
			i KeyType[("STREAM") s KeyTypeID="%Stream.GlobalCharacter"
			i DefaultVal'="" s RequireFlag="N"
			s KeyNote=$p($p(InputNoteStr,KeyName_":",2),"、")		;备注
			do ParamsObj
		}
	}
	Q ParamsList.%ToJSON()

ParamsObjNull
	s KeyTypeID="%String"		;数据类型
	s RequireFlag="Y"			;必填标识
	s (KeyName,KeyType,KeyNote)=""
	Q ""
	
ParamsObj
	s Obj={}
	s Obj."keyname"=KeyName
	s Obj."type"=KeyTypeID
	s Obj."keytype"=KeyType
	s Obj."requireFlag"=RequireFlag
	s Obj."desc"=KeyNote
	d ParamsList.%Push(Obj)
	Q ""
}

/// Desc：通过类名、方法名、方法类型反向获取方法申明及方法备注
/// Input: CName:类名、MName:方法名、MType:方法类型("Method"/"Query")、OutFlag:(In/Out:入参/出参)
/// Output: 备注串$(13,10)拼接
/// Debug：w ##class(web.DHCDocInterfaceMethod).GetMethodNoteStr("web.DHCDocInterfaceMethod","FormatMethodOutPut","Method")
/// Debug：w ##class(web.DHCDocInterfaceMethod).GetMethodNoteStr("web.DHCDocInterfaceMethod","GetDocInterfaceMethodData","Query")
ClassMethod GetMethodNoteStr(CName, MName, MType) As %String
{
	s MType=$zcvt(MType,"U")
	s ^templx("GetMethodNoteStr")=$lb(CName, MName, MType)
	
	;改为直接取Global,对象方式可参考%CSP.Documatic->RenderClassPage
	i MType="QUERY"{
		if ('$d(^oddDEF(CName,"q",MName))) w CName_".cls 没有有效的Query："_MName_" 请核实！" Q
		;s mdef=##class(%QueryDefinition).%OpenId(CName_"."_MName)
		s NoteDescStr = $g(^oddDEF(CName,"q",MName,4))
		s ReturnType=$g(^oddDEF(CName,"q",MName,5))
		s ParmStr=$g(^oddDEF(CName,"q",MName,24))
		s SqlProc=$g(^oddDEF(CName,"q",MName,28))
		s RowSpec=$g(^oddDEF(CName,"q",MName,"P","ROWSPEC"))
		i SqlProc=1 s SqlProcStr=" [SqlProc]"
		s OtherStr=" (ROWSPEC = """_RowSpec_""")"_$g(SqlProcStr)
	}else{
		if ('$d(^oddDEF(CName,"m",MName))) w CName_".cls 没有有效的方法："_MName_" 请核实！" Q
		;s mdef=##class(%MethodDefinition).%OpenId(CName_"."_MName)
		s NoteDescStr = $g(^oddDEF(CName,"m",MName,4))
		s ReturnType = $g(^oddDEF(CName,"m",MName,42))
		s ParmStr=$g(^oddDEF(CName,"m",MName,27))
	}
	for len=1:1:$l(NoteDescStr,$c(13,10)){
		s NoteStr=$p(NoteDescStr,$c(13,10),len)
		continue:NoteStr=""
		w "/// "_NoteStr ,!
	}
	s ReturnType=..ConvertFormalSpec(ReturnType)
	s ParmStr=..ConvertFormalSpec(ParmStr)
	s MTypeDesc=$case(MType,"QUERY":"Query",:"ClassMethod")
	w MTypeDesc_" "_MName_"("_ParmStr_")As "_ReturnType_$g(OtherStr)
	Q ""
}

/// Desc：格式化方法的入参，返回对应的定义申明。拷贝自：%CSP.Documatic.cls->ConvertFormalSpec
/// Input: FormalSpec:方法入参串
ClassMethod ConvertFormalSpec(FormalSpec As %String) As %String
{
	Set out="",type=""
	Set state=0
	For pos=1:1:$L(FormalSpec) {
		Set c=$E(FormalSpec,pos)
		Set s=state
		If (s=0) {
			If ("*"[c) { Set out=out_"Output " }
			ElseIf ("*"[c) { Set out=out_"Output " }
			ElseIf ("&"[c) { Set out=out_"ByRef " }
			ElseIf (","[c) { Set out=out_", " }
			ElseIf (":"[c) {
				Set state=1
				Set type=""
			}
			ElseIf (""""[c) {
				Set out=out_c
				Set state=2
				Set type=""
			}
			Else {
				Set out=out_c
			}
		}
		ElseIf (s=1) {
			If (":"[c) {
				// ClassToLink (<name>, <type>, <dname>)
				Set out=out_$S(type'="":" As "_type,1:"")
				Set state=3
			}
			ElseIf ("=,("[c) {
				Set out=out_$S(type'="":" As "_type,1:"")
				Set out=out_$S(c="=":" = ",c=",":", ",c="(":c,1:" ")
				Set state=0
			}
			ElseIf (" "[c) {
				set c=c	 //no op
			}
			Else {
				Set type=type_c
			}
			
		}
		ElseIf (s=2) {
			If (""""[c) {
				// end of quoted literal
				Set out=out_c
				Set state=0
			}
			Else { Set out=out_c }
		}
		ElseIf (s=3) {
			If ("=,"[c) {
				Set out=out_$S(c="=":" = ",c=",":", ",1:" ")
				Set state=0
			}
		}
	}
	If ((state=1)&&(type'="")) { Set out=out_" As "_type }
	Quit out
}

/// Desc：通过类名、Query名、入参，将Query的输出转为Json数据
/// Debug: w ##class(web.DHCDocInterfaceMethod).GetDataInfoListShowCombox("web.DHCDocInterfaceMethod","GetMethodInputData",80)
ClassMethod GetDataInfoListShowCombox(classname As %String, classquery As %String, Input As %String, Write = "Y") As %Stream.GlobalCharacter
{
	s $zt="Exception"
	s ^templx("GetDataInfoListShowCombox")=$lb(classname,classquery,Input,Write)
	
	s List=[]
	s rs=##class(%Library.ResultSet).%New(classname_":"_classquery)
	s columns=rs.GetColumnCount()
	s sc=rs.Execute(Input)
	while(rs.Next()){
		s Obj={}
		for len=1:1:columns {
			s ColName=rs.GetColumnName(len)
			s ColData=rs.GetData(len)
			d Obj.%Set(ColName,ColData)
		}
		d List.%Push(Obj)
	}
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d List.%ToJSON(Stream)
	if Write="Y"{
		d Stream.OutputToDevice()
		Quit ""
	}
	Quit Stream
	
Exception
	Quit:Write="Y" "[]"
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[]")
	Quit Stream
}

}

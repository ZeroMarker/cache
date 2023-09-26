Class web.DHCENS.STBLL.UTIL.EnsInterfaceMethod Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).Test()
ClassMethod Test() As %String
{
	set methodPublishClassName="web.DHCENS.EnsWebService"
	set tClassDef=##class(%Dictionary.ClassDefinition).%OpenId(methodPublishClassName)
	set methodDefinition=##class(%Dictionary.MethodDefinition).%New()
	set methodDefinition.Name="SendPatInfo"
	set methodDefinition.FormalSpec	="Input:%String,aa:%GlobalCharacterStream"
	set methodDefinition.Abstract=0
	set methodDefinition.ClassMethod=1
	set methodDefinition.ReturnType="%GlobalCharacterStream"
	set methodDefinition.WebMethod=1
	set impleStream=##class(%GlobalCharacterStream).%New()
	d impleStream.Write("	set a=1")
	set methodDefinition.Description="方法描述：发送病人基本信息"
	set methodDefinition.Implementation=impleStream
	set sc=tClassDef.Methods.Insert(methodDefinition)
	quit:$$$ISERR(sc) "-1^"_sc
	
	set sc= tClassDef.%Save()
	Quit sc
}

/// Desc: 保存方法
/// w ##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).SaveEnsInterfaceMethodInfo("%String^N^ad###","update","M0008","取出住院发药明细相关信息","药房药库","Y","webMethod","web.DHCENS.Method.PatInfo","test3","取详细信息^TEMP()")
ClassMethod SaveEnsInterfaceMethodInfo(tmpPar As %String, Input...) As %String
{
	set $zt="Exception"
	ts	
	s eventStatus=$g(Input(1))
	s methodCode=$g(Input(2))
	s methodDesc=$g(Input(3))
	s methodStatus=$g(Input(5))
	s methodProcuctionTerm=$g(Input(4))
	s methodClassName=$g(Input(7))
	s methodName=$g(Input(8))
	s methodType=$g(Input(6))
	s methodNote=$g(Input(9))
	s returnType=$g(Input(10))
	s returnDesc=$g(Input(11))
	s returnLongDesc=$g(Input(12))
	s interfaceFlag=$g(Input(13))
	s hsbSynvFlag=$g(Input(14))
	s content=$g(Input(15))
	set methodInput="",methodOutput="",formalSpec="",oldMethodId="",delFlag=0
	// 默认
	if methodType="webMethod" {
		set methodPublishName="DHCWebInterface"
		set methodPublishClassName="web.DHCENS.EnsWebService"
	}
	else {
		set methodPublishName="DHCHisInterface"
		set methodPublishClassName="web.DHCENS.EnsHISService"
	}
	//set methodPublishName=$g(Input(2))
	// 查找注册方法是否存在
	set methodFlag="-1^"
	set methodTypeFlag="-1^"
	
	set rowId=$o(^User.EnsInterfaceMethodI("MethodCode",methodType,methodCode,""))
	if ((eventStatus="add")&&(rowId'="")) {
		tro
		Quit "-1^方法代码已经注册"
	}
	elseif ((eventStatus="add")&&(rowId="")) {
		set methodObj=##class(User.EnsInterfaceMethod).%New()
		set methodObj.methodCode=methodCode
	}
	elseif ((eventStatus="update")&&(rowId="")) {
		tro
		Quit "-1^方法代码不存在"
	}
	else {
		s methodObj=##class(User.EnsInterfaceMethod).%OpenId(rowId)
	}
	
	set inputLan=$l(tmpPar,"###")-1
	for i=1:1:inputLan {
		set tmp=$p(tmpPar,"###",i)
		Quit:tmp=""
		set type=$p(tmp,"^",1)
		set flag=$p(tmp,"^",2)
		set desc=$p(tmp,"^",3)
		if methodInput="" {
			if flag="Y" {
				set methodInput=".input"_i
				set formalSpec="*input"_i_":"_type
			}
			else {
				set methodInput="input"_i
				set formalSpec="input"_i_":"_type
			}
		}
		else {
			if flag="Y" {
				set methodInput=methodInput_",.input"_i
				set formalSpec=formalSpec_",*input"_i_":"_type
			}
			else {
				set methodInput=methodInput_",input"_i
				set formalSpec=formalSpec_",input"_i_":"_type
			}
		}
	}
	
	set methodObj.methodDesc=methodDesc
	set methodObj.methodStatus=methodStatus
	//2021-12-07 liyan
	if $Find(methodProcuctionTerm,"[") 	s methodProcuctionTerm=$Replace($Replace($Replace(methodProcuctionTerm,"[",""),"]",""),$c(34),"")
	set methodObj.methodProcuctionTerm=methodProcuctionTerm
	set methodObj.methodClassName=methodClassName
	set methodObj.methodName=methodName
	set methodObj.methodType=methodType
	set methodObj.methodPublishClassName=methodPublishClassName
	set methodObj.methodPublishName=methodPublishName
	set methodObj.methodNote=methodNote
	set methodObj.methodInput=tmpPar
	set methodObj.methodOutput=returnType_$char(2)_returnDesc_$char(2)_returnLongDesc
	if ((returnType="")&&(returnDesc="")) {
		set methodObj.methodOutput=""
	}
	//2021-12-08 liyan
	set methodObj.EnsInterfaceFlag=interfaceFlag
	set methodObj.HsbSyncFlag=hsbSynvFlag
	if content'="" s methodObj.MessageInstance=content
	set sc=methodObj.%Save()
	if sc=1 {
		tc
	}
	else {
		tro
	}
	Quit sc
Exception
	tro
	Quit "-1^"_$ze
}

/// Creator：WuXianPu
/// CreatDate：2015—01-07
/// Description：方法列表信息查询
/// Table：User.EnsInterfaceMethod
/// Input：id,code,desc,productionName,status,hisVersion
/// Output：返回符合条件的方法列表
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.UTIL.EnsInterfaceMethod","GetEnsInterfaceMethodData","^^^^ALL")
Query GetEnsInterfaceMethodData(Input As %String) As %Query(ROWSPEC = "id:%String,code:%String,desc:%String,productionName:%String,status:%String,type:%String")
{
}

ClassMethod GetEnsInterfaceMethodDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set selCode=$p(Input,"^",1)
	set selDesc=$p(Input,"^",2)
	set selProName=$p(Input,"^",3)
	set selStatus=$p(Input,"^",4)
	set selType=$p(Input,"^",5)
	set QHandle=$lb(0,repid,0)
	set id=""  for  set id=$o(^User.EnsInterfaceMethodD(id)) Quit:id=""  d
	.set methodInfo=^User.EnsInterfaceMethodD(id)
	.set code=$lg(methodInfo,2)
	.Quit:('(code[selCode)&&(selCode'=""))
	.set desc=$lg(methodInfo,3)
	.Quit:('(desc[selDesc)&&(selDesc'=""))
	.set productionName=$lg(methodInfo,5)
	.//2021-12-07
	.s calltargetlist=""
	.s functionids=productionName
	.if +functionids>0 d
	..s functionnum=$LENGTH(functionids,",")
	..f i=1:1:functionnum  d
	...s functionid=$p(functionids,",",i)
	...q:(+functionid=0)||('$D(^Config.ENS.EnsSubApiSysConfigD(functionid)))
	...s functiondesc=$LG(^Config.ENS.EnsSubApiSysConfigD(functionid),6)
	...s systemcode=$LG(^Config.ENS.EnsSubApiSysConfigD(functionid),2)
	...s hospital=$LG(^Config.ENS.EnsSubApiSysConfigD(functionid),3)
	...s systemversion=$LG(^Config.ENS.EnsSubApiSysConfigD(functionid),4)
	...s systemid=$o(^Config.ENS.EnsApiSysConfigI("PKSystemConfig",systemcode,hospital,systemversion,""))
	...q:+systemid=0
	...s workgroup=$LG(^Config.ENS.EnsApiSysConfigD(systemid),7)
	...s dbmode=$LG(^Config.ENS.EnsApiSysConfigD(systemid),6)
	...if $D(^Code.ENS.EnsWorkGroupI("workGroupCodeIndex",workgroup))  d
	....s workgroupid=$o(^Code.ENS.EnsWorkGroupI("workGroupCodeIndex",workgroup,""))
	....if +workgroupid'=0 s workgroup=$LG(^Code.ENS.EnsWorkGroupD(workgroupid),3)
	...s calltarget=functiondesc_"@"_workgroup_"("_dbmode_")"
	...if calltargetlist'=""  d
	....s calltargetlist=calltargetlist_","_calltarget
	...else  d
	....s calltargetlist=calltarget
	..s productionName=calltargetlist
	.Quit:('(productionName[selProName)&&((selProName'="")&&(selProName'="全部")))
	.set status=$lg(methodInfo,4)
	.Quit:((status'=selStatus)&&((selStatus'="")&&(selStatus'="ALL")))
	.set type=$lg(methodInfo,8)
	.Quit:((type'=selType)&&((selType'="")&&(selType'="ALL")))	
	.if type="webMethod" d
	..set type="外部调用"
	.if type="classMethod" d
	..set type="内部调用"	
	.set ^CacheTemp(repid,ind)=$lb(id,code,desc,productionName,status,type)
	.set ind=ind+1
	k ^TMPIMP
	Quit $$$OK
}

ClassMethod GetEnsInterfaceMethodDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceMethodDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetEnsInterfaceMethodDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceMethodDataExecute ]
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
/// CreatDate：2015—01-07
/// Description：产品组信息
/// Table：User.EnsInterfaceMethod
/// Input：GetmethodProcuctionTermData
/// Output：返回产品组信息列表
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.UTIL.EnsInterfaceMethod","GetMethodProcuctionTermData","")
Query GetMethodProcuctionTermData(Input As %String) As %Query(ROWSPEC = "methodProcuctionTerm:%String")
{
}

ClassMethod GetMethodProcuctionTermDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	if Input="all" {
		set ^CacheTemp(repid,ind)=$lb("全部")
		set ind=ind+1
	}
	set productionName=""  for  set productionName=$o(^User.EnsInterfaceMethodI("MethodProcuctionTerm",productionName)) Quit:productionName=""  d
	.set ascii=$a(productionName)
	.q:(ascii>=45)&&(ascii<=57) //过滤对接系统配置-功能维护列表
	.set ^CacheTemp(repid,ind)=$lb(productionName)
	.set ind=ind+1
	Quit $$$OK
}

ClassMethod GetMethodProcuctionTermDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetMethodProcuctionTermDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMethodProcuctionTermDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMethodProcuctionTermDataExecute ]
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
/// CreatDate：2015—01-07
/// Description：入参信息
/// Table：User.EnsInterfaceMethod
/// Input：GetmethodProcuctionTermData
/// Output：返回入参信息列表
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.UTIL.EnsInterfaceMethod","GetMethodInputData","1")
Query GetMethodInputData(Input As %String) As %Query(ROWSPEC = "type:%String,flag:%String,desc:%String,descHidden:%String")
{
}

ClassMethod GetMethodInputDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set methodInput=$lg($g(^User.EnsInterfaceMethodD(Input)),11)
	Quit:methodInput="" 
	set length=$l(methodInput,$char(28))
	for i=1:1:length {
		set tmp=$p(methodInput,$char(28),i)
		set type=$p(tmp,$char(2),1)
		if ("undefined"=type) {
			s type=""
		}
		set flag=$p(tmp,$char(2),2)
		set desc=$p(tmp,$char(2),3)
		set note=$p(tmp,$char(2),4)
		set ^CacheTemp(repid,ind)=$lb(type,flag,desc,note)
		set ind=ind+1
	}
	k ^TMPIMP
	Quit $$$OK
}

ClassMethod GetMethodInputDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetMethodInputDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMethodInputDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMethodInputDataExecute ]
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
/// CreatDate：2015—01-07
/// Description：返回值信息
/// Table：User.EnsInterfaceMethod
/// Input：GetmethodProcuctionTermData
/// Output：返回返回值信息列表
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.Method.EnsInterfaceMethod","GetMethodOutputData","5")
Query GetMethodOutputData(Input As %String) As %Query(ROWSPEC = "type:%String,desc:%String,descHidden:%String")
{
}

ClassMethod GetMethodOutputDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set methodOutput=$lg($g(^User.EnsInterfaceMethodD(Input)),12)
	Quit:methodOutput="" 
	set length=$l(methodOutput,$char(28))
	for i=1:1:length {
		set tmp=$p(methodOutput,$char(28),i)
		set type=$p(tmp,$char(2),1)
		set desc=$p(tmp,$char(2),2)
		set descHidden=$p(tmp,$char(2),3)
		set ^CacheTemp(repid,ind)=$lb(type,desc,descHidden)
		set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetMethodOutputDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetMethodOutputDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMethodOutputDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMethodOutputDataExecute ]
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
/// CreatDate：2015—01-07
/// Description：方法详细信息
/// Table：User.EnsInterfaceMethod
/// Input：
/// Output：返回his版本信息信息列表
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.UTIL.EnsInterfaceMethod","GetEnsInterfaceMethodDetailInfo","99")
Query GetEnsInterfaceMethodDetailInfo(Input As %String) As %Query(ROWSPEC = "methodCode:%String,methodDesc:%String,procuctionnameDetail:%String,methodStatus:%String,methodType:%String,methodClassName:%String,methodName:%String,methodNote:%String,methodPublishClassName:%String,methodOutputDesc:%String,methodInputDesc:%String,wsdlAddress:%String,ensInterfaceFlag:%String,hsbSyncFlag:%String")
{
}

ClassMethod GetEnsInterfaceMethodDetailInfoExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set id=$p(Input,"^",1)
	set obj=##class(User.EnsInterfaceMethod).%OpenId(id)
	set methodCode=obj.methodCode
	set methodDesc=obj.methodDesc
	set procuctionnameDetail=obj.methodProcuctionTerm
	set methodStatus=obj.methodStatus
	set methodType=obj.methodType
	set methodClassName=obj.methodClassName
	set methodName=obj.methodName
	set methodNote=obj.methodNote
	set outputDesc=obj.methodOutput
	set tMethodInput=""
	set inputDesc=obj.methodInput
	//set inputDesc=##class(web.DHCENS.Util.Common).ReplaceStr(obj.methodInput,"inGd1###",",")
	set length=$l(inputDesc,$char(28))
	set methodInputDesc=""
	for i=1:1:length {
		set str=$p(inputDesc,$char(28),i)
		Quit:str=""
		set desc=$p(str,$char(2),3)
		if methodInputDesc="" {
			set methodInputDesc="input"_i_":"_desc
		}
		else {
			set methodInputDesc=methodInputDesc_","_"input"_i_":"_desc
		}
	}
	set methodInputDesc="KeyName(固定值):"_methodCode_","_methodInputDesc
	if outputDesc'="" {
		set methodOutputDesc="数值类型:"_$p(outputDesc,$char(2),1)_",返回值描述:"_$p(outputDesc,$char(2),2)
	}
	else {
		set methodOutputDesc=""
	}
	for i=1:1:($l(obj.methodInput,$char(28))) {
		s tInput=$p(obj.methodInput,$char(28),i)
		s tType=$p(tInput,$char(2),1)
		s tFlag=$p(tInput,$char(2),2)
		s tDesc=$p(tInput,$char(2),3)
		if ((""'=tType)&&("undefined"'=tType)) {
			if (tFlag="Y") {
				s tPar="Output input"_i_" As "_tType
			}else {
				s tPar="input"_i_" As "_tType
			}
			if (""=tMethodInput) {
				s tMethodInput=tPar
			}else {
				s tMethodInput=tMethodInput_", "_tPar
			}
		}
	}
	
	s tMethodPublishName=""
	if (obj.methodPublishClassName="web.DHCENS.EnsHISService"){
		s tMethodPublishName="DHCHisInterface"
	}elseif (obj.methodPublishClassName="web.DHCENS.EnsWebService"){
		s tMethodPublishName="DHCWebInterface"
	}else{
	}
	set methodPublishClassName="set result=##class("_obj.methodPublishClassName_")."_tMethodPublishName_"(KeyName As %String,"_tMethodInput_")"
	set pathToApp=$lg(^websys.ConfigurationD(1),2)
	set wsdlAddress="http://127.0.0.1"_pathToApp_"/web.DHCENS.EnsWebService.CLS?WSDL=1"
	set ensInterfaceFlag=obj.EnsInterfaceFlag
	set hsbSyncFlag=obj.HsbSyncFlag
	set ^CacheTemp(repid,ind)=$lb(methodCode,methodDesc,procuctionnameDetail,methodStatus,methodType,methodClassName,methodName,methodNote,methodPublishClassName,methodOutputDesc,methodInputDesc,wsdlAddress,ensInterfaceFlag,hsbSyncFlag)
	set ind=ind+1
	k ^TMPIMP
	Quit $$$OK
}

ClassMethod GetEnsInterfaceMethodDetailInfoClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceMethodDetailInfoExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetEnsInterfaceMethodDetailInfoFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceMethodDetailInfoExecute ]
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

/// Desc: 更改方法状态
/// w ##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).UpdateEnsInterfaceMethodStatus("9")
ClassMethod UpdateEnsInterfaceMethodStatus(Input As %String) As %String
{
	s $zt="Exception"
	ts
	s id=$p(Input,"^",1)
	s obj=##class(User.EnsInterfaceMethod).%OpenId(id)
	if '$isobject(obj) {
		q "方法不存在"
	}
	if obj.methodStatus="Y" {
		s obj.methodStatus="N"
	}
	else {
		s obj.methodStatus="Y"
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

/// Desc: 保存方法入参
/// w ##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).SaveMethodInput("1^GetPhDetail^%GlobalCharacterStream^N^ytytu")
ClassMethod SaveMethodInput(Input As %String) As %String
{
	set $zt="Exception"
	set index=$p(Input,"^",1)
	set methodCode=$p(Input,"^",2)
	set type=$p(Input,"^",3)
	set flag=$p(Input,"^",4)
	set desc=$p(Input,"^",5)
	set sc=0
	set rowId=$o(^User.EnsInterfaceMethodI("MethodCode",methodCode,""))
	if rowId'="" {
		set obj=##class(User.EnsInterfaceMethod).%OpenId(rowId)
		set methodInput=obj.methodInput
		set length=$l(methodInput,";")-1
		set updMethodInput=""
		if (index+1)>length {
			set updMethodInput=methodInput_type_","_desc_","_flag_";"
		}
		else {
			for i=1:1:length {
				set tmp=$p(methodInput,";",i)
				if (i=(index+1)) {
					set updMethodInput=updMethodInput_type_","_desc_","_flag_";"
				}
				else {
					set updMethodInput=updMethodInput_tmp_";"
				}
			}
		}
		set obj.methodInput=updMethodInput
		set sc=obj.%Save()
		Quit:sc'=1 "-1^"_sc
		set classDefinition=##class(%Dictionary.ClassDefinition).%OpenId(obj.methodPublishClassName)
		set methodcount=classDefinition.Methods.Count()
		set methodFlag="-1^"
		for i=1:1:methodcount {
			set id=classDefinition.Methods.GetAt(i).%Id()
			set metName=classDefinition.Methods.GetAt(i).Name
			if methodCode=metName {
				set methodFlag=0_"^"_id
			}
		}
		set formalSpec="",methodInput="",methodOutput=""
		if $p(methodFlag,"^",1)=0 {
			set inputLan=$l(obj.methodInput,";")-1
			for i=1:1:inputLan {
				set tmp=$p(obj.methodInput,";",i)
				Quit:tmp=""
				set type=$p(tmp,",",1)
				set desc=$p(tmp,",",2)
				set flag=$p(tmp,",",3)
				if methodInput="" {
					if flag="Y" {
						set methodInput=".input"_i
						set formalSpec="*input"_i_":"_type
					}
					else {
						set methodInput="input"_i
						set formalSpec="input"_i_":"_type
					}
				}
				else {
					if flag="Y" {
						set methodInput=methodInput_",.input"_i
						set formalSpec=formalSpec_",*input"_i_":"_type
					}
					else {
						set methodInput=methodInput_",input"_i
						set formalSpec=formalSpec_",input"_i_":"_type
					}
				}
			}
			set returnType=$p(obj.methodOutput,",",1)
			set methodClassName=obj.methodClassName
			set methodName=obj.methodName
			set methodDefinition=##class(%Dictionary.MethodDefinition).%OpenId($p(methodFlag,"^",2))
			set methContent=##class(%GlobalCharacterStream).%New()
			if returnType="" {
				set methodOutput=$c(13)_$c(10)_$c(9)_"do "
			}
			else {
				set methodOutput=$c(13)_$c(10)_$c(9)_"set result="
			}
			set methodString=""
			//set methodString=$c(9)_"set $zt=""Exception"""
			if methodInput="" {
				set methodString=methodString_methodOutput_"##class("_methodClassName_")."_methodName_"()"
				d methContent.Write(methodString)
			}
			else {
				set methodString=methodString_methodOutput_"##class("_methodClassName_")."_methodName_"("_methodInput_")"
				d methContent.Write(methodString)
				if returnType'="" {
					d methContent.Write($c(13)_$c(10)_$c(9)_"Quit result")
				}
			}
			//set methodString=methodString_$c(13)_"Exception"
			//set methodString=methodString_$c(13)_$c(10)_$c(9)_"Quit ""-1^$ze"""
			//d methContent.Write(methodString)
			set methodDefinition.Implementation=methContent
			set methodDefinition.FormalSpec=formalSpec
			set methodDefinition.Abstract=0
			set methodDefinition.ReturnType=returnType
			d classDefinition.Methods.Insert(methodDefinition)
			set sc=classDefinition.%Save()
			set syssc= $system.OBJ.Compile(obj.methodPublishClassName,"cuk /checkuptodate=expandedonly")
			if sc'="1" {
				Quit "-1^保存类失败失败"_sc
			}	
			else {
				Quit "0^成功"
			}
		}
		else {
				Quit "-1^方法不存在"
		}
	}
	else {
		Quit "-1^代码信息有误"
	}
Exception
	Quit "-1^"_$ze
}

/// Desc: 删除方法入参
/// w ##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).DeleteMethodInput("1^GetPhDetail")
ClassMethod DeleteMethodInput(Input As %String) As %String
{
	
	set $zt="Exception"
	set index=$p(Input,"^",1)
	set methodCode=$p(Input,"^",2)
	set sc=0
	set rowId=$o(^User.EnsInterfaceMethodI("MethodCode",methodCode,""))
	if rowId'="" {
		set obj=##class(User.EnsInterfaceMethod).%OpenId(rowId)
		set methodInput=obj.methodInput
		set length=$l(methodInput,";")-1
		set updMethodInput=""
		for i=1:1:length {
			set tmp=$p(methodInput,";",i)
			if (i'=(index+1)) {
				set updMethodInput=updMethodInput_tmp_";"
			}
		}
		set obj.methodInput=updMethodInput
		set sc=obj.%Save()
		Quit:sc'=1 "-1^"_sc
		set classDefinition=##class(%Dictionary.ClassDefinition).%OpenId(obj.methodPublishClassName)
		set methodcount=classDefinition.Methods.Count()
		set methodFlag="-1^"
		for i=1:1:methodcount {
			set id=classDefinition.Methods.GetAt(i).%Id()
			set metName=classDefinition.Methods.GetAt(i).Name
			if methodCode=metName {
				set methodFlag=0_"^"_id
			}
		}
		set formalSpec="",methodInput="",methodOutput=""
		if $p(methodFlag,"^",1)=0 {
			set inputLan=$l(obj.methodInput,";")-1
			for i=1:1:inputLan {
				set tmp=$p(obj.methodInput,";",i)
				Quit:tmp=""
				set type=$p(tmp,",",1)
				set desc=$p(tmp,",",2)
				set flag=$p(tmp,",",3)
				if methodInput="" {
					if flag="Y" {
						set methodInput=".input"_i
						set formalSpec="*input"_i_":"_type
					}
					else {
						set methodInput="input"_i
						set formalSpec="input"_i_":"_type
					}
				}
				else {
					if flag="Y" {
						set methodInput=methodInput_",.input"_i
						set formalSpec=formalSpec_",*input"_i_":"_type
					}
					else {
						set methodInput=methodInput_",input"_i
						set formalSpec=formalSpec_",*input"_i_":"_type
					}
				}
			}
			set returnType=$p(obj.methodOutput,",",1)
			set methodClassName=obj.methodClassName
			set methodName=obj.methodName
			set methodDefinition=##class(%Dictionary.MethodDefinition).%OpenId($p(methodFlag,"^",2))
			set methContent=##class(%GlobalCharacterStream).%New()
			if returnType="" {
				set methodOutput=$c(13)_$c(10)_$c(9)_"do "
			}
			else {
				set methodOutput=$c(13)_$c(10)_$c(9)_"set result="
			}
			set methodString=""
			//set methodString=$c(9)_"set $zt=""Exception"""
			if methodInput="" {
				set methodString=methodString_methodOutput_"##class("_methodClassName_")."_methodName_"()"
				d methContent.Write(methodString)
			}
			else {
				set methodString=methodString_methodOutput_"##class("_methodClassName_")."_methodName_"("_methodInput_")"
				d methContent.Write(methodString)
				if returnType'="" {
					d methContent.Write($c(13)_$c(10)_$c(9)_"Quit result")
				}
			}
			//set methodString=methodString_$c(13)_"Exception"
			//set methodString=methodString_$c(13)_$c(10)_$c(9)_"Quit ""-1^$ze"""
			//d methContent.Write(methodString)
			set methodDefinition.Implementation=methContent
			set methodDefinition.FormalSpec=formalSpec
			set methodDefinition.Abstract=0
			set methodDefinition.ReturnType=returnType
			d classDefinition.Methods.Insert(methodDefinition)
			set sc=classDefinition.%Save()
			set syssc= $system.OBJ.Compile(obj.methodPublishClassName,"cuk /checkuptodate=expandedonly")
			if sc'="1" {
				Quit "-1^保存类失败失败"_sc
			}	
			else {
				Quit "0^成功"
			}
		}
		else {
				Quit "-1^方法不存在"
		}
	}
	else {
		Quit "-1^代码信息有误"
	}
Exception
	Quit "-1^"_$ze
}

/// Desc: 保存返回值
/// w ##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).SaveMethodOutput("1^GetPhDetail^%GlobalCharacterStream^N^ytytu")
ClassMethod SaveMethodOutput(Input As %String) As %String
{
	set $zt="Exception"
	ts
	set index=$p(Input,"^",1)
	set methodCode=$p(Input,"^",2)
	set type=$p(Input,"^",3)
	set desc=$p(Input,"^",4)
	set sc=0
	set rowId=$o(^User.EnsInterfaceMethodI("MethodCode",methodCode,""))
	if rowId'="" {
		set obj=##class(User.EnsInterfaceMethod).%OpenId(rowId)
		set methodOutput=type_","_desc
		set obj.methodOutput=methodOutput
		set sc=obj.%Save()
		if (sc'=1) {
			tro
			Quit "-1^"_sc
		}
		set classDefinition=##class(%Dictionary.ClassDefinition).%OpenId(obj.methodPublishClassName)
		if '$ISOBJECT(classDefinition) {
			tro
			Quit "-1^类"_obj.methodPublishClassName_"不存在"
		}
		set methodDefinition=##class(%Dictionary.MethodDefinition).%OpenId(obj.methodPublishClassName_"||"_obj.methodPublishName)
		if '$ISOBJECT(methodDefinition) {
			tro
			Quit "-1^方法"_obj.methodPublishName_"不存在"
		}
		set methodDefinition.ReturnType=type
		set sc=methodDefinition.%Save()
		if (sc'="1") {
			tro
			Quit "-1^保存方法失败"_sc
		}	
		else {
			set syssc= $system.OBJ.Compile(obj.methodPublishClassName,"cuk /checkuptodate=expandedonly")
			if (syssc'="1") {
				Quit "-1^"_obj.methodPublishClassName_"编译失败"_sc
			}
			tc
			Quit "0^成功"
		}
	}
	else {
		tro
		Quit "-1^代码信息有误"
	}
Exception
	tro
	Quit "-1^"_$ze
}

/// Desc: 删除返回值
/// w ##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).DeleteMethodOutput("1^GetPhDetail^%GlobalCharacterStream^N^ytytu")
ClassMethod DeleteMethodOutput(Input As %String) As %String
{
	set $zt="Exception"
	ts
	set index=$p(Input,"^",1)
	set methodCode=$p(Input,"^",2)
	set sc=0
	set rowId=$o(^User.EnsInterfaceMethodI("MethodCode",methodCode,""))
	if rowId'="" {
		set obj=##class(User.EnsInterfaceMethod).%OpenId(rowId)
		set obj.methodOutput=""
		set sc=obj.%Save()
		if (sc'=1) {
			tro
			Quit "-1^"_sc
		}
		set classDefinition=##class(%Dictionary.ClassDefinition).%OpenId(obj.methodPublishClassName)
		if '$ISOBJECT(classDefinition) {
			tro
			Quit "-1^类"_obj.methodPublishClassName_"不存在"
		}
		set methodDefinition=##class(%Dictionary.MethodDefinition).%OpenId(obj.methodPublishClassName_"||"_obj.methodPublishName)
		if '$ISOBJECT(methodDefinition) {
			tro
			Quit "-1^方法"_obj.methodPublishName_"不存在"
		}
		set methodDefinition.ReturnType=""
		set sc=methodDefinition.%Save()
		if (sc'="1") {
			tro
			Quit "-1^删除方法失败"_sc
		}	
		else {
			set syssc= $system.OBJ.Compile(obj.methodPublishClassName,"cuk /checkuptodate=expandedonly")
			if (syssc'="1") {
				Quit "-1^"_obj.methodPublishClassName_"编译失败"_sc
			}
			tc
			Quit "0^成功"
		}
	}
	else {
		tro
		Quit "-1^代码信息有误"
	}
Exception
	tro
	Quit "-1^"_$ze
}

/// Desc:删除方法
/// w ##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).delEnsInterfaceMethodInfo("1")
ClassMethod delEnsInterfaceMethodInfo(Input As %String) As %String
{
	s $zt="Exception"
	ts
	set rowId=$p(Input,"^",1)
	set obj=##class(User.EnsInterfaceMethod).%OpenId(rowId)
	s sc=0
	if ($IsObject(obj)) {
		s sc=##class(User.EnsInterfaceMethod).%DeleteId(rowId)
		if (sc'="1") {
			tro
			Quit "-1^删除方法"_obj.methodPublishName_"数据失败"
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

/// w ##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).getMethodCode()
ClassMethod getMethodCode()
{
	if ('$d(^User.EnsInterfaceMethodC)) {
		s tNo=1
	}else {
		s tNo=$g(^User.EnsInterfaceMethodC)
	}
	s tMethodCode="0^M"_$s(tNo>=1000:tNo,1:$tr($j(tNo,4)," ","0"))
	q tMethodCode
}

// w ##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).TestEnsInterfaceMethod("")

ClassMethod TestEnsInterfaceMethod(Input As %String) As %String
{
	set $zt="Exception"
	set id=$p(Input,$char(2),1)
	set inLength=$l(Input,$char(2))	
	set methodObj=##class(User.EnsInterfaceMethod).%OpenId(id)
	set methodInput=methodObj.methodInput
	set methodCode=methodObj.methodCode
	set publishClassName=methodObj.methodPublishClassName
	set publishName=methodObj.methodPublishName
	set outputType=$p($p(methodObj.methodOutput,$char(28),1),$char(2),1)
	set methodType=methodObj.methodType
	set obj=""
	set tmpInput=""
	set length=$l(methodInput,$char(28))
	set @("methodCode")=methodCode
	f i=1:1:length{
		s tInputType=$p($p(methodInput,$char(28),i),$char(2),1)	
		if methodType="webMethod" {
			set stream=##class(%GlobalCharacterStream).%New()
			d stream.Write($p(Input,$char(2),i+2))
			s @("Input"_i)=stream
		}
		else {
			s @("Input"_i)=$p(Input,$char(2),i+2)	
		}		
		if (tmpInput=""){
			s tmpInput="Input"_i
		}else{
			s tmpInput=tmpInput_","_"Input"_i
		}
	}
	s exeStr="rtn=##class("_publishClassName_")."_publishName_"(methodCode,"_tmpInput_")"
	s @exeStr
	set resultStr=@"rtn"
	if outputType="%GlobalCharacterStream" {
		Quit "0"_$c(2)_resultStr.Read(resultStr.Size)
	}
	else {
		Quit "0"_$c(2)_resultStr
	}
Exception
	Quit "-1"_$c(2)_$ze
}

/// 文档调阅
/// w ##class(web.DHCENS.STBLL.UTIL.EnsInterfaceMethod).MDSearch("内部调用^SENDRISAPPBILLINFO")
ClassMethod MDSearch(Input As %String = "") As %String
{
	s $ZT="err"
	s MethodType=$p(Input,"^",1)
	s MethodCode=$p(Input,"^",2)
	if (MethodType="")||(MethodCode="") {
		s JsonObj=##class(%DynamicObject).%New()
		s JsonObj.ResultCode=-1
		s JsonObj.ResultContent="请求参数为空"
		q JsonObj.%ToJSON()
		}
	if $Find(MethodType,"内部") {
		s MethodType="classMethod"
	}
	elseif $Find(MethodType,"外部") {
		s MethodType="webMethod"
	}
	else  {
		s JsonObj=##class(%DynamicObject).%New()
		s JsonObj.ResultCode=-1
		s JsonObj.ResultContent="未识别的方法类型"
		q JsonObj.%ToJSON()
		}
	s MethodRowID=$o(^User.EnsInterfaceMethodI("MethodCode",MethodType,MethodCode,""))
	if +MethodRowID=0 {
		s JsonObj=##class(%DynamicObject).%New()
		s JsonObj.ResultCode=-1
		s JsonObj.ResultContent="方法不存在"
		q JsonObj.%ToJSON()
		}
	s MethodObj=##class(User.EnsInterfaceMethod).%OpenId(MethodRowID)
	s DocumentContent=MethodObj.MessageInstance
	d MethodObj.%Close()
	s JsonObj=##class(%DynamicObject).%New()
	s JsonObj.ResultCode=0
	s JsonObj.ResultContent="成功"
	s JsonObj.DocumentContent=DocumentContent
	q JsonObj.%ToJSON()
err
	s JsonObj=##class(%DynamicObject).%New()
	s JsonObj.ResultCode=-1
	s JsonObj.ResultContent=$SYSTEM.Status.GetErrorText($ZE)
	q JsonObj.%ToJSON()
}

}

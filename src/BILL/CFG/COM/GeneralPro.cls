Import SQLUser

/// 名称: BILL.CFG.COM.GeneralPro.cls
/// 描述: 计费通用产品线类
/// 编写者: wzh
/// 编写日期: 2022-10-12
/// 产品组：计费医保组
Class BILL.CFG.COM.GeneralPro Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2022-02-28
/// Description: 生成通用配置树产品线所需要的数据
/// Input: 
/// Output: 
/// Debug: w ##class(BILL.CFG.COM.GeneralPro).BuildTree()
ClassMethod BuildTree() As %String
{
	set index = 0
	set o = []
	
	set proDr = 0
	for{
		set proDr = $o(^CF.BILL.COM.ProLineD(proDr))
		quit:(proDr = "")
		set proCode = $lg(^CF.BILL.COM.ProLineD(proDr),2)
		set proName = $lg(^CF.BILL.COM.ProLineD(proDr),3)
		set vaildFlag = $lg(^CF.BILL.COM.ProLineD(proDr),4)
		continue:(vaildFlag = 0)
		set d = {}
		set d.id = $i(index)
		set d.text = proName
		set p = {}
		set p.id = proDr
		set p.code = proCode
		set p.type = "Pro"
		set d.attributes = p
		
		set dc=[]
		set mIdx = 0
		set modDr = 0
		for{
			set modDr = $o(^CF.BILL.COM.ProModuleI("ProLineCode",proCode,modDr))
			quit:(modDr = "")
			set modCode = $lg(^CF.BILL.COM.ProModuleD(modDr),4)
			set modDesc = $lg(^CF.BILL.COM.ProModuleD(modDr),5)
			set m = {}
			set m.id = $i(mIdx)
			set m.text = modDesc
			set p = {}
			set p.id = modDr
			set p.code = modCode
			set p.type = "Mod"
			set m.attributes = p
			do dc.%Push(m)
		}
		if (dc.%Size()>0) {
			set d.state = "closed"
			set d.children = dc
		}
		do o.%Push(d)
	}
	set stream=##class(%GlobalCharacterStream).%New()
	do o.%ToJSON(.stream)
	do stream.OutputToDevice()
	
	quit ""
}

/// Creator: wzh
/// CreatDate: 2022.10.12
/// Description: 保存数据
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralPro).Save(^TMP("Save"))
ClassMethod Save(jsonStr As %String) As %String
{
	set ^TMP("Save")=jsonStr

	set json={}.%FromJSON(jsonStr)
	if (json.Type = "Pro"){
		set rtn = ..SavePro(json)
	}elseif(json.Type = "Mod"){
		set rtn = ..SaveMod(json)
	}elseif(json.Type = "Func"){
		;set rtn = ..SaveFunc(json)
	}
	quit rtn
}

/// Creator: wzh
/// CreatDate: 2022.10.14
/// Description: 保存产品线数据
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralPro).SavePro(^TMP("Save"))
ClassMethod SavePro(json As %String) As %String
{
	set ^TMP("SavePro")=json
	set $zt="ERROR"
	
	if (+json.ID>0) {
		set obj=##class(CF.BILL.COM.ProLine).%OpenId(json.ID, 0)
	}else {
		set obj=##class(CF.BILL.COM.ProLine).%New()
	}
	if ('$isObject(obj)) {
		quit -1_"^"_"创建对象失败"
	}
	set date = $p($h,",",1)
	set time = $p($h,",",2)
	if (+json.ID = 0){
		set obj.PLCode = json.PLCode	; 产品线代码
		// 产品线代码校验
		quit:($d(^CF.BILL.COM.ProLineI("PLCode",json.PLCode))) -1_"^"_"产品线代码已存在！"
		set obj.OptId = ##class(User.SSUser).%OpenId(%session.Data("LOGON.USERID"), 0)	; 创建人
		set obj.OptDate = date	; 创建日期
		set obj.OptTime = time	; 创建时间
	}
	set obj.PLName = json.PLName	; 产品线名称
	
	set obj.UpdtId = ##class(User.SSUser).%OpenId(%session.Data("LOGON.USERID"), 0)	; 更新人
	set obj.UpdtDate = date	; 更新日期
	set obj.UpdtTime = time	; 更新时间
	
	set sc=obj.%Save()
	do obj.%Close()
	if $$$ISERR(sc) {
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	quit 0

ERROR
	quit ..AppException()
}

/// Creator: wzh
/// CreatDate: 2022.10.12
/// Description: 保存模块数据
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralPro).SaveMod(^TMP("SaveMod"))
ClassMethod SaveMod(json As %String) As %String
{
	set ^TMP("SaveMod")=json
	set $zt="ERROR"
	
	if (+json.ID>0) {
		set obj=##class(CF.BILL.COM.ProModule).%OpenId(json.ID, 0)
	}else {
		set obj=##class(CF.BILL.COM.ProModule).%New()
	}
	if ('$isObject(obj)) {
		quit -1_"^"_"创建对象失败"
	}
	set date = $p($h,",",1)
	set time = $p($h,",",2)
	if (+json.ID = 0){
		set ProLineDr = $o(^CF.BILL.COM.ProLineI("PLCode",json.ProLineCode,""))
		quit:(+ProLineDr =0) -1_"^"_"产品线代码异常！"
		set obj.ProLineDr = ##class(CF.BILL.COM.ProLine).%OpenId(ProLineDr, 0)	; 产品线指针
		set obj.ProLineCode = json.ProLineCode	; 产品线代码
		set obj.PMCode = json.PMCode	; 模块代码
		// 模块校验
		quit:($d(^CF.BILL.COM.ProModuleI("Code",obj.ProLineCode,obj.PMCode))) -1_"^"_"模块代码已存在！"
		
		set obj.OptId = ##class(User.SSUser).%OpenId(%session.Data("LOGON.USERID"), 0)	; 创建人
		set obj.OptDate = date	; 创建日期
		set obj.OptTime = time	; 创建时间
	}
	set obj.PMName = json.PMName	; 模块名称
	;set obj.SeqNum = json.SeqNum	; 序号
	set obj.ActiveDateFrom = ##class(websys.Conversions).DateHtmlToLogical(json.ActiveDateFrom)	; 生效时间
	set obj.ActiveDateTo = ##class(websys.Conversions).DateHtmlToLogical(json.ActiveDateTo)	; 失效时间
	set obj.BasicFunctionRemark = json.BasicFunctionRemark	; 基本功能说明
	set obj.ApplicationRemark = json.ApplicationRemark	; 应用场景说明
	set obj.RelateMenu = json.RelateMenu	; 对应的菜单
	set obj.RelateCSP = json.RelateCSP	; 对应的CSP
	set obj.UpdtId = ##class(User.SSUser).%OpenId(%session.Data("LOGON.USERID"),1)	; 更新人
	set obj.UpdtDate = date	; 更新日期
	set obj.UpdtTime = time	; 更新时间

	set sc=obj.%Save()
	do obj.%Close()
	if $$$ISERR(sc) {
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	quit 0

ERROR
	quit ..AppException()
}

/// Creator: wzh
/// CreatDate: 2022.10.12
/// Description: 保存功能点数据
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralPro).SaveFunc(^TMP("SaveFunc"))
ClassMethod SaveFunc(json As %String) As %String
{
	set ^TMP("SaveFunc")=json
	set $zt="ERROR"
	
	if (+json.ID>0) {
		set obj=##class(CF.BILL.COM.ProModule).%OpenId(json.ID, 0)
	}else {
		set obj=##class(CF.BILL.COM.ProModule).%New()
	}
	if ('$isObject(obj)) {
		quit -1_"^"_"创建对象失败"
	}
	
	set sc=obj.%Save()
	do obj.%Close()
	if $$$ISERR(sc) {
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	quit 0

ERROR
	quit ..AppException()
}

}

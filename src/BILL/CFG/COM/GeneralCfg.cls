Import SQLUser

/// 名称: BILL.CFG.COM.GeneralCfg.cls
/// 描述: 计费通用配置业务类
/// 编写者: ZhYW
/// 编写日期: 2022-02-28
/// 产品组：计费医保组
Class BILL.CFG.COM.GeneralCfg Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2022-02-28
/// Description: 根据字典类型查询对应的字典数据
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GeneralCfg","QryDicDataByType","CPDataViewType")
Query QryDicDataByType(dicType As %String) As websys.Query(ROWSPEC = "code:%String,text:%String,value:%String")
{
}

ClassMethod QryDicDataByTypeExecute(ByRef qHandle As %Binary, dicType As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if (dicType="") quit $$$OK
 	
 	set dicCode=""
 	while($o(^CF.BILL.COM.DictionaryI("IDataKey",dicType,dicCode))'="") {
	 	set dicCode=$o(^CF.BILL.COM.DictionaryI("IDataKey",dicType,dicCode))
	 	set dicId=0
	 	while($o(^CF.BILL.COM.DictionaryI("IDataKey",dicType,dicCode,dicId))) {
		 	set dicId=$o(^CF.BILL.COM.DictionaryI("IDataKey",dicType,dicCode,dicId))
		 	set dicData=$g(^CF.BILL.COM.DictionaryD(dicId))
	 		set code=$lg(dicData,3)
	 		set text=$lg(dicData,4)
	 		set value=$lg(dicData,5)		   //默认值
	 		do OutputDicDataList
		}
	}
	
	quit $$$OK
	
OutputDicDataList
	set Data=$lb(code,text,value)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: wzh
/// CreatDate: 2023.03.05
/// Description: 通用配置源数据字典、目标数据字典下拉框
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GeneralCfg","QryDicDataByMode","DicINSU")
Query QryDicDataByMode(Mode As %String) As websys.Query(ROWSPEC = "code:%String,text:%String")
{
}

ClassMethod QryDicDataByModeExecute(ByRef qHandle As %Binary, Mode As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	quit:(Mode="") $$$OK
 	
	if (Mode = "Dictionary"){
		do GetCfgDicData
	}elseif(Mode = "DicINSU"){
		do GetINSUDicData
	}
	
	quit $$$OK
	
GetCfgDicData
	set dicCode=""
 	while($o(^CF.BILL.COM.DictionaryI("IDataKey","SYS",dicCode))'="") {
	 	set dicCode=$o(^CF.BILL.COM.DictionaryI("IDataKey","SYS",dicCode))
	 	set dicId=0
	 	while($o(^CF.BILL.COM.DictionaryI("IDataKey","SYS",dicCode,dicId))) {
		 	set dicId=$o(^CF.BILL.COM.DictionaryI("IDataKey","SYS",dicCode,dicId))
		 	set dicData=$g(^CF.BILL.COM.DictionaryD(dicId))
	 		set code=$lg(dicData,3)
	 		set text=$lg(dicData,4)
	 		do Output
		}
	}
	quit
GetINSUDicData
 	s Rowid=""
 	f  s Rowid=$o(^DHCINDID("0","IType","SYS",Rowid)) q:Rowid=""  d
	.s InsuDicInfo=$g(^DHCINDID(Rowid))
	.s code=$p(InsuDicInfo,"^",2)
	.s text=$p(InsuDicInfo,"^",3)
	.;s INDIDDicAuthorityFlag=$p(InsuDicInfo,"^",7)
	.;+2019-7-30 tangzf 医院授权判断 start
	.;s ParamHospital=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(INDIDDicCode,HospDr)
	.;s TmpHospital=$p(InsuDicInfo, "^", 15)
	.;q:TmpHospital'=ParamHospital ; 该院区无权查看该数据
	.d Output
	quit
Output
	set Data=$lb(code,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-02-28
/// Description: 生成通用配置树产品线所需要的数据
/// Input: 
/// Output: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).BuildProModuleTree()
ClassMethod BuildProModuleTree() As %String
{
	set index=0
	set o=[]
	set proId=0
	
	while($o(^CF.BILL.COM.ProLineD(proId))) {
		set proId = $o(^CF.BILL.COM.ProLineD(proId))
		continue:(proId = "")
		set proData = $g(^CF.BILL.COM.ProLineD(proId))
		continue:(proData = "")
		set proCode = $lg(proData,2)
		set proName = $lg(proData,3)
		set d={}
		set d.id = $i(index)
		set d.text = proName
		set p={}
		set p.id = proId
		set p.code = proCode
		set p.flag = ..CheckLimit(1,proId)
		set p.type = "ProLine"
		set d.attributes = p
		set dc = []
		set mIdx = 0
		set modId = 0
		while($o(^CF.BILL.COM.ProModuleI("ProLineCode",proCode,modId))) {
			set modId=$o(^CF.BILL.COM.ProModuleI("ProLineCode",proCode,modId))
			set modData=$g(^CF.BILL.COM.ProModuleD(modId))
			set modCode=$lg(modData,4)
			set modDesc=$lg(modData,5)
			set m={}
			set m.id=$i(index)
			set m.text=modDesc
			set p={}
			set p.id=modId
			set p.code=modCode
			set p.flag = ..CheckLimit(2,modId)
			set p.type = "ProModule"
			set m.attributes=p
			do:((d.attributes.flag'=0)||(m.attributes.flag'=0)) dc.%Push(m)
		}
		if (dc.%Size()>0) {
			set d.state="closed"
			set d.children=dc
			do o.%Push(d)
		}else{
			do:(d.attributes.flag'=0) o.%Push(d)
		}
		
	}
	set stream=##class(%GlobalCharacterStream).%New()
	do o.%ToJSON(.stream)
	do stream.OutputToDevice()
	
	quit ""
}

/// Creator: ZhYW
/// CreatDate: 2022-02-28
/// Description: 查询配置点
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GeneralCfg","QryCfgPointList","OP","OPCharge","01")
Query QryCfgPointList(dicCode As %String, modCode As %String, cfgDesc As %String) As websys.Query(ROWSPEC = "id:%Integer,code:%String,text:%String,limitFlag:%String")
{
}

ClassMethod QryCfgPointListExecute(ByRef qHandle As %Binary, dicCode As %String, modCode As %String, cfgDesc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if ((dicCode="")||(modCode="")) quit $$$OK

 	set ptId=0
	while($o(^CF.BILL.COM.CfgPointI("DicMod",dicCode,modCode,ptId))) {
		set ptId=$o(^CF.BILL.COM.CfgPointI("DicMod",dicCode,modCode,ptId))
		set limitFlag = ..CheckLimit(3,ptId)	// 校验权限
		continue:(limitFlag=0)
		set ptData=$g(^CF.BILL.COM.CfgPointD(ptId))
		set ptCode=$lg(ptData,4)
		set ptDesc=$lg(ptData,5)
		continue:((cfgDesc'="")&&(ptDesc'[cfgDesc))
		do OutputCfgPointList
	}
	
	quit $$$OK
	
OutputCfgPointList
	set Data=$lb(ptId,ptCode,ptDesc,limitFlag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-03-01
/// Description: 验证模块代码是否已存在
/// Input: 
/// Return: 0:否, 1:是
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).CheckModCodeExist("OP","6","OPCharge")
ClassMethod CheckModCodeExist(dicCode As %String, modId As %String, code As %String) As %String
{
	quit:(dicCode="") 0
	quit:(code="") 0
	set mId=$o(^CF.BILL.COM.ProModuleI("DMCode",dicCode,code,0))
	quit ((mId'="")&&(mId'=modId))
}

/// Creator: ZhYW
/// CreatDate: 2022-03-01
/// Description: 保存模块表数据
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).SaveProModule(2)
ClassMethod SaveProModule(jsonStr As %String) As %String
{
	;set ^TMP("SaveProModule")=jsonStr
	set $zt="ERROR"
	
	set json={}.%FromJSON(jsonStr)
	
	set rtn=..CheckModCodeExist(json.dicCode, json.modId, json.code)
	quit:(+rtn) -1_"^"_"代码已存在"
	
	ts
	
	if (json.modId>0) {
		set objMod=##class(CF.BILL.COM.ProModule).%OpenId(json.modId, 0)
	}else {
		set objMod=##class(CF.BILL.COM.ProModule).%New()
	}
	if ('$isObject(objMod)) {
		tro
		quit -1_"^"_"创建对象失败"
	}
	set objMod.PMDicCode=json.dicCode
	set objMod.PMCode=json.code
	set objMod.PMDesc=json.desc
	set sc=objMod.%Save()
	do objMod.%Close()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	
	if ($tl>0) tc
	
	quit 0

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-03-01
/// Description: 验证配置点代码是否已存在
/// Input: 
/// Return: 0:否, 1:是
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).CheckPointCodeExist("OP","OpCharge","1","02")
ClassMethod CheckPointCodeExist(dicCode As %String, modCode As %String, ptId As %String, code As %String) As %String
{
	;set ^TMP("CheckPointCodeExist")=$lb(dicCode, modCode, ptId, code)
	quit:((dicCode="")||(modCode="")) 0
	quit:(code="") 0
	set pId=$o(^CF.BILL.COM.CfgPointI("DMPCode",dicCode,modCode,code,0))
	quit ((pId'="")&&(pId'=ptId))
}

/// Creator: ZhYW
/// CreatDate: 2022-03-01
/// Description: 保存配置点表数据
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).SaveCfgPoint(^TMP("SaveProModule"))
ClassMethod SaveCfgPoint(jsonStr As %String) As %String
{
	;set ^TMP("SaveProModule")=jsonStr
	set $zt="ERROR"
	
	set json={}.%FromJSON(jsonStr)
	
	set rtn=..CheckPointCodeExist(json.dicCode, json.modCode, json.ptId, json.code)
	quit:(+rtn) -1_"^"_"代码已存在"
	
	ts
	
	if (json.ptId>0) {
		set objPt=##class(CF.BILL.COM.CfgPoint).%OpenId(json.ptId, 0)
	}else {
		set objPt=##class(CF.BILL.COM.CfgPoint).%New()
	}
	if ('$isObject(objPt)) {
		tro
		quit -1_"^"_"创建对象失败"
	}
	// 更新时间：2022.04.13		内容：只有新增才会赋值dicCode modCode code
	set:(json.ptId="") objPt.CPDicCode=json.dicCode
	set:(json.ptId="") objPt.CPModCode=json.modCode
	set:(json.ptId="") objPt.CPCode=json.code
	set objPt.CPDesc=json.desc
	set objPt.CPLinkURL=json.linkURL
	set objPt.CPCollDataSrc=json.collDataSrc
	set objPt.CPCollDataSrcQry=json.collDataSrcQry
	set objPt.CPCollDataSrcDicType=json.collDataSrcDicType
	set objPt.CPDataViewType=json.collDataSrcViewType
	set objPt.CPDataMulFlag=json.collDataSrcMulFlag
	set objPt.CPTgtDataSrc=json.tgtDataSrc
	set objPt.CPTgtDataSrcQry=json.tgtDataSrcQry
	set objPt.CPTgtDataSrcDicType=json.tgtDataSrcDicType
	set objPt.CPIsDeleteFlag=json.isDeleteFlag
	set objPt.CPActiveDateFrom=##class(websys.Conversions).DateHtmlToLogical(json.activeDateFrom)	; 生效开始日期
	set objPt.CPActiveDateTo=##class(websys.Conversions).DateHtmlToLogical(json.activeDateTo)		; 生效结束日期
	set objPt.CPCtrlLevelDicCode=json.ctrlLevelDicCode	; 控制级别
	set objPt.CPCtrlLevelRemark=json.ctrlLevelRemark	; 控制文字说明
	set objPt.CPUpdLevelDicCode=json.updLevelDicCode	; 修改级别
	set objPt.CPRemark=json.remark						; 说明
	set objPt.CPCtrlType=json.ctrlType					; 控制类型
	set objPt.CPResultType=json.resultType				; 结果类型
	set objPt.CPPublicFlag=json.publicFlag				; 公用标志
	
	set objPt.CPCollDataSrcQryDicDR=json.collDataSrcQryDicDR	; 集合数据源Query字典表指针
	set objPt.CPTgtDataSrcQryDicDR=json.tgtDataSrcQryDicDR		; 目标数据源Query字典表指针
	
	set sc=objPt.%Save()
	do objPt.%Close()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	
	if ($tl>0) tc
	
	quit 0

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-03-01
/// Description: 根据代码获取配置Id
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).GetRelaDataId(2)
ClassMethod GetRelaDataId(relaCode As %String, sourceData As %String, hospId As %String) As %String
{
	/*
	更新时间：2022.05.25
	更新人：wzh
	continue新增有效条件判断
	*/
	set relaId=""
	quit:(relaCode="") relaId
	
	set id=0
	while($o(^CF.BILL.COM.CfgRelaDataI("RelaCode",relaCode,id))) {
		set id=$o(^CF.BILL.COM.CfgRelaDataI("RelaCode",relaCode,id))
		set data=$g(^CF.BILL.COM.CfgRelaDataD(id))
		set srcData=$lg(data,3)
		continue:(srcData'=sourceData)
		set hospDR=$lg(data,5)
		continue:(hospDR'=hospId)
		set vaildFlag = $lg(data,14)
		continue:(vaildFlag = 0)
		set relaId=id
		quit
	}
	
	quit relaId
}

/// Creator: ZhYW
/// CreatDate: 2022-03-17
/// Description: 保存配置关系表数据
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).SaveRelaData("OPCHRG.AddPreDeposit.RcptPrtTimes", "", ^TMP("RelaList"), 2)
ClassMethod SaveRelaData(RelaCode As %String, SourceData As %String, RelaList As %String, HospId As %String) As %String
{
	/*
	更新时间：2022.06.13	更新人：wzh
	保存逻辑更改：由原来序号自动生成更改为读取前端序号
	——————————————————————————————————————————————————————————————————————————————————
	更新时间：2022.05.26	更新人：wzh
	序号 保存逻辑更改
	新增：查找该 relaCode hospId 下最大的序号，该序号值+1为新增序号值
	修改：前端传入序号值，按照序号值保存。前端上移下移应会改变序号值
	——————————————————————————————————————————————————————————————————————————————————
	更新时间：2022.05.23	更新人：wzh
	保存数据逻辑
	保存数据不再删除数据，删除数据方法单独拆分，前端删除单独调用删除数据方法。
	1.判断数据是否存在
	1.1.存在，则更新数据：生效时间，失效时间，序号及更新人、更新日期、更新时间
	1.2.不存在，则插入数据。
	序号保存方法：按照前端index保存，每次保存序号都会改变，且连续。
	
	*/
	;merge ^TMP("RelaList")=RelaList
	;set ^TMP("SaveRelaData")=$lb(RelaCode, SourceData, HospId)
	set $zt="ERROR"
	
	set rtn = 0
	set updateDate = $p($h,",",1)
	set updateTime = $p($h,",",2)
	set userId = %session.Get("LOGON.USERID")

	// 方法保护
	quit:((RelaCode = "")||(HospId = "")) 0
	
	set EnablePMASystem=##class(BILL.Interface.Inside.AuthItemApply).EnablePMASysByCfgPoint(RelaCode)
	set appJson={}   //向权力系统发送申请的JSON
	
	ts

	set i=0
	while($o(RelaList(i))) {
		set i=$o(RelaList(i))
		set jsonStr=$g(RelaList(i))
		continue:(jsonStr="")
		set json={}.%FromJSON(jsonStr)
		// 处理时间数据
		set json.CRDActiveDateFrom = ##class(websys.Conversions).DateHtmlToLogical(json.CRDActiveDateFrom)
		set json.CRDActiveDateTo = ##class(websys.Conversions).DateHtmlToLogical(json.CRDActiveDateTo)
		// 获取srcDataDesc和tgtDataDesc
		set descRtn = ..GetDescByRelaCode(RelaCode, SourceData, json.CRDTgtData)
		set srcDesc = $p(descRtn,"^",2)
		set tgtDesc = $p(descRtn,"^",4)
		// 数据存在则更新，不存在则插入
		set checkRtn = ..CheckCfgRelaDataExist(RelaCode, SourceData, json.CRDTgtData, HospId)
		if (+checkRtn){
			set id = $p(checkRtn,"^",2)
			&SQL(
				UPDATE CF_BILL_COM.CfgRelaData (
					CRDUpdtId, CRDUpdtDate, CRDUpdtTime, CRDActiveDateFrom, CRDActiveDateTo, 
					CRDSeqNum, CRDECol1, CRDECol2, CRDECol3
				)
				VALUES (
					:userId, :updateDate, :updateTime, :json.CRDActiveDateFrom, :json.CRDActiveDateTo, 
					:json.CRDSeqNum, :json.CRDECol1, :json.CRDECol2, :json.CRDECol3
				)
				WHERE %ID = :id
			)
		}else {
			//+2023-03-08 ZhYW 是否允许退挂号费
			if (EnablePMASystem) {
				set id=$o(^CF.BILL.COM.CfgRelaDataI("IHospCode",RelaCode,HospId,""),-1)
				set appJson.ID=id
				set appJson.RelaCode=RelaCode
				set appJson.SourceData=SourceData
				set appJson.TgtData=json.CRDTgtData
				set appJson.HospDR=HospId
				set appJson.SourceDataDesc=srcDesc
				set appJson.TgtDataDesc=tgtDesc
				set appJson.UpdtId=userId
				set appJson.UpdtDate=updateDate
				set appJson.UpdtTime=updateTime
				set appJson.DateFrom=json.CRDActiveDateFrom
				set appJson.DateTo=json.CRDActiveDateTo
				set appJson.SeqNum=json.CRDSeqNum
				set appJson.OptId=userId
				set appJson.OptDate=updateDate
				set appJson.OptTime=updateTime
				set appJson.ECol1=json.CRDECol1
				set appJson.ECol2=json.CRDECol2
				set appJson.ECol3=json.CRDECol3
				continue
			}
			&SQL(
				INSERT CF_BILL_COM.CfgRelaData (
					CRDRelaCode, CRDSourceData, CRDTgtData, CRDHospDR, CRDSourceDataDesc,
					CRDTgtDataDesc, CRDUpdtId, CRDUpdtDate, CRDUpdtTime, CRDActiveDateFrom,
					CRDActiveDateTo, CRDSeqNum, CRDOptId, CRDOptDate, CRDOptTime,
					CRDECol1, CRDECol2, CRDECol3
				)
				VALUES (
					:RelaCode, :SourceData, :json.CRDTgtData, :HospId, :srcDesc,
					:tgtDesc, :userId, :updateDate, :updateTime, :json.CRDActiveDateFrom,
					:json.CRDActiveDateTo, :json.CRDSeqNum, :userId, :updateDate , :updateTime,
					:json.CRDECol1, :json.CRDECol2, :json.CRDECol3
				)
			)
		}
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	//+2023-03-08 ZhYW 是否允许退挂号费
	if (appJson.%Size()>0) {
		set rtn=##class(BILL.Interface.Inside.AuthItemApply).SaveRelaDataApply(appJson.%ToJSON())   //向权力系统发送申请
	}
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: wzh
/// CreatDate: 2022.05.16
/// Description: 删除配置数据表数据
/// Input: 	id	|	CRDRowid
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).DeleteRelaData("OPCHRG.OPChg.BNYBJSDZD", "", "310", "COM")
ClassMethod DeleteRelaData(RelaCode As %String, SrcData As %String, TgtData As %String, HospId As %String) As %String
{
	/*
	更新时间：2022.06.30	更新人：wzh
	查询索引由 IRelaData 更改为 IRelaDataExist
	——————————————————————————————————————————————————————————————————————————————————
	当前删除逻辑
	1.根据入参获取数据表对应的id
	2.将id的有效标志更改为0（无效）
	3.同时存储下更新人，更新日期，更新时间
	
	*/
	set $zt="ERROR"
	;set ^TMPParam("DeleteRelaData") = $lb(RelaCode,SrcData,TgtData,HospId)
	
	set userId = %session.Get("LOGON.USERID")
	set updateDate = $p($h,",",1)
	set updateTime = $p($h,",",2)
	set flag = "0"
	set rtn = 0
	
	ts
	set:(SrcData = "") SrcData = -1E14
	set id = $o(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,RelaCode, HospId, SrcData, TgtData,""))
	&SQL(
		update CF_BILL_COM.CfgRelaData (
			CRDVaildFlag, CRDUpdtId, CRDUpdtDate, CRDUpdtTime
		)
		VALUES (
			:flag, :userId, :updateDate, :updateTime
		)
		WHERE %ID = :id
	)
	set rtn = SQLCODE
	
	if (+rtn) {
		tro
		set rtn = rtn_"^"_$g(%msg)
	}
	
	if ($tl>0) tc
	
	quit rtn
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-03-17
/// Description: 保存配置关系表数据
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).SaveRelaData("OPCHRG.OPRefd.SFYXTGHF", "64", ^TMP("RelaList","SaveRelaDataForBasic"), 2)
ClassMethod SaveRelaDataForBasic(RelaCode As %String, TgtData As %String, RelaList As %String, HospId As %String) As %String
{
	/*
	配置值保存方法
	先进行删除，再进行保存
	*/
	set ^TMP("SaveRelaDataForBasic")=$lb(RelaCode, TgtData, RelaList, HospId)
	set $zt="ERROR"
	
	set rtn = 0

	// 方法保护
	quit:((RelaCode = "")||(HospId = "")) 0
	
	set EnablePMASystem=##class(BILL.Interface.Inside.AuthItemApply).EnablePMASysByCfgPoint(RelaCode)
	
	ts
	
	// 1.判断原来是否有数据，如果有数据则删除
	if (TgtData '= ""){
		if ('EnablePMASystem) {
			set rtn = ..DeleteRelaData(RelaCode, "", TgtData, HospId)
			if (+rtn){
				tro
				quit rtn
			}
		}
	}
	
	// 2.判断当前数据是否需要保存（如果是空数据则不需要保存）
	set jsonStr=$g(RelaList(1))
	set json={}.%FromJSON(jsonStr)
	if (json.CRDTgtData '= "") {
		set rtn = ..SaveRelaData(RelaCode, "", .RelaList, HospId)
		if (+rtn) {
			tro
			quit rtn
		}
	}
	// 如果删除、保存都没有失败，则提交事务
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-02-28
/// Description: 查询医院
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GeneralCfg","QryHospList")
Query QryHospList(PublicFlag As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "id:%String,text:%String:描述")
{
	SELECT "COM", "公用"
	WHERE 1=:PublicFlag
	UNION 
	SELECT %ID, HOSP_Desc
	FROM CT_Hospital
	WHERE (HOSP_DateFrom IS NULL OR HOSP_DateFrom <= CONVERT(DATE, now()))
		AND (HOSP_DateTo IS NULL OR HOSP_DateTo >= CONVERT(DATE, now()))
}

/// Creator: ZhYW
/// CreatDate: 2022-03-01
/// Description: 根据代码获取配置值
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).GetCfgRelaData("OPCHRG.OPChg.01","",2)
ClassMethod GetCfgRelaData(relaCode As %String, sourceData As %String, hospId As %String) As %String
{
	set relaData=""
	quit:(relaCode="") relaData
	
	set id=0
	while($o(^CF.BILL.COM.CfgRelaDataI("RelaCode",relaCode,id))) {
		set id=$o(^CF.BILL.COM.CfgRelaDataI("RelaCode",relaCode,id))
		set data=$g(^CF.BILL.COM.CfgRelaDataD(id))
		set srcData=$lg(data,3)
		continue:(srcData'=sourceData)
		set hospDR=$lg(data,5)
		continue:(hospDR'=hospId)
		set vaildFlag = $lg(data,14)
		continue:(vaildFlag = 0)	;有效标志过滤
		set tgtData=$lg(data,4)
		set relaData=$s((relaData=""):tgtData,1:(relaData_"^"_tgtData))
	}
	
	quit relaData
}

/// Creator: wzh
/// CreatDate: 2022.06.30
/// Description: 根据配置点代码获取配置数据：有序号的根据序号顺序取出，剩余无序号的根据rowid顺序取数
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).GetCfgRelaDataBySeqNum("OPCHRG.OPChg.KSKYDZFFS","1",2)
ClassMethod GetCfgRelaDataBySeqNum(RelaCode As %String, SrcData As %String, HospId As %String) As %String
{
	// 初始化
	set relaData = ""
	
	// 方法保护
	quit:((RelaCode = "")||(HospId = "")) relaData
	
	// 处理序号不为空的
	set:(SrcData = "") SrcData = -1E14
	set seqNum = 0
	while($o(^CF.BILL.COM.CfgRelaDataI("ISeqNumExist",1,RelaCode,HospId,SrcData,seqNum))) {
		set seqNum = $o(^CF.BILL.COM.CfgRelaDataI("ISeqNumExist",1,RelaCode,HospId,SrcData,seqNum))
		set id = ""
		while($o(^CF.BILL.COM.CfgRelaDataI("ISeqNumExist",1,RelaCode,HospId,SrcData,seqNum,id))){
			set id = $o(^CF.BILL.COM.CfgRelaDataI("ISeqNumExist",1,RelaCode,HospId,SrcData,seqNum,id))
			set data = $g(^CF.BILL.COM.CfgRelaDataD(id))
			set tgtData = $lg(data,4)
			set relaData = $s((relaData = ""):tgtData,1:(relaData_"^"_tgtData))
		}	
	}
	// 处理序号为空的
	set seqNum = -1E14, id = ""
	while($o(^CF.BILL.COM.CfgRelaDataI("ISeqNumExist",1,RelaCode,HospId,SrcData,seqNum,id))){
		set id = $o(^CF.BILL.COM.CfgRelaDataI("ISeqNumExist",1,RelaCode,HospId,SrcData,seqNum,id))
		set data = $g(^CF.BILL.COM.CfgRelaDataD(id))
		set tgtData = $lg(data,4)
		set relaData = $s((relaData = ""):tgtData,1:(relaData_"^"_tgtData))
	}	

	quit relaData
}

/// Creator: wzh
/// CreatDate: 2022.06.30
/// Description: 根据配置点代码获取配置数据：有序号的根据序号顺序取出，剩余无序号的根据rowid顺序取数
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).GetCfgRelaDataBySeqNum("OPCHRG.PreDepRefd.SFPDCZWJFZD","",2)
ClassMethod GetCfgRelaDataIDBySeqNum(RelaCode As %String, SrcData As %String, HospId As %String) As %String
{
	// 初始化
	set relaDataID = ""
	
	// 方法保护
	quit:((RelaCode = "")||(HospId = "")) relaDataID
	
	// 处理序号不为空的
	set:(SrcData = "") SrcData = -1E14
	set seqNum = 0
	while($o(^CF.BILL.COM.CfgRelaDataI("ISeqNumExist",1,RelaCode,HospId,SrcData,seqNum))) {
		set seqNum = $o(^CF.BILL.COM.CfgRelaDataI("ISeqNumExist",1,RelaCode,HospId,SrcData,seqNum))
		set id = ""
		while($o(^CF.BILL.COM.CfgRelaDataI("ISeqNumExist",1,RelaCode,HospId,SrcData,seqNum,id))){
			set id = $o(^CF.BILL.COM.CfgRelaDataI("ISeqNumExist",1,RelaCode,HospId,SrcData,seqNum,id))
			set relaDataID = $s((relaDataID = ""):id,1:(relaDataID_"^"_id))
		}	
	}
	// 处理序号为空的
	set seqNum = -1E14, id = ""
	while($o(^CF.BILL.COM.CfgRelaDataI("ISeqNumExist",1,RelaCode,HospId,SrcData,seqNum,id))){
		set id = $o(^CF.BILL.COM.CfgRelaDataI("ISeqNumExist",1,RelaCode,HospId,SrcData,seqNum,id))
		set relaDataID = $s((relaDataID = ""):id,1:(relaDataID_"^"_id))
	}	

	quit relaDataID
}

/// Creator: wzh
/// CreatDate: 2022.04.06
/// Description: 前端配置数据列表取结果集
/// Input:	relaCode				CF_BILL_COM.CfgRelaData.CRDRelaCode
/// 		srcData					CF_BILL_COM.CfgRelaData.CRDSourceData
/// 		hospId					CF_BILL_COM.CfgRelaData.CRDHospDR
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GeneralCfg","QryCfgRelaData","OPCHRG.OPChg.BYXYBJSDZD","","2")
Query QryCfgRelaDataColl(relaCode As %String, srcData As %String, hospId As %String, VaildFlag As %String) As websys.Query(ROWSPEC = "handler:%String:操作,seqNum:%String:序号,id:%String,code:%String:代码,text:%String:描述,activeFrom:%Date:生效时间,activeTo:%Date:失效时间,eCol1:%String,eCol2:%String,eCol3:%String,updateUser:%String:更新人,updateFlag:%String:更新标志,updateDate:%String:更新日期")
{
}

ClassMethod QryCfgRelaDataCollExecute(ByRef qHandle As %Binary, relaCode As %String, srcData As %String, hospId As %String, VaildFlag As %String) As %Status
{
	/*
	更新时间：2022.06.23	更新人：wzh
	索引由 ISrcData 更改为 ISrcDataExist
	方法名由 QryCfgRelaData 改为 QryCfgRelaDataColl
	——————————————————————————————————————————————————————————————————————————————————————	
	更新时间：2022.06.13	更新人：wzh
	取数据由序号更改为rowid
	索引由 ISeqNum 更改为 ISrcData
	——————————————————————————————————————————————————————————————————————————————————————	
	更新时间：2022.05.24	更新人：wzh
	新增入参：srcData
	索引 ISeqNum 增加字段 CRDSourceData
	——————————————————————————————————————————————————————————————————————————————————————
	更新时间：2022.05.23	更新人：wzh
	获取结果集方式改变，由索引 IHospCode 变更为 ISeqNum
	逻辑及注意点：
	1.根据索引获取 序号
	2.通过 序号 获取 id		此处需要注意：每个序号下的id需要重置为空
	3.根据有效标志过滤
	*/
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	// 方法保护
	quit:((relaCode = "")||(hospId = "")||(VaildFlag = "")) $$$OK
	
	;set ^xiongwang("QryCfgColl")=$lb(relaCode,srcData,hospId)
	// 处理srcData
	set:(srcData = "") srcData = -1E14
	set id = ""	
	for{
		set id = $o(^CF.BILL.COM.CfgRelaDataI("ISrcDataExist",VaildFlag,relaCode,hospId,srcData,id))
		quit:(id = "")
		do GetCfgRelaDataById
		set rtnDesc = ..GetDescByRelaCode(relaCode,"",tgtData)
		set tgtCode = $p(rtnDesc,"^",3)
		set tgtDesc = $p(rtnDesc,"^",4)
		do Output
	}
	
	quit $$$OK

GetCfgRelaDataById
	set data = $g(^CF.BILL.COM.CfgRelaDataD(id))
	set tgtData = $lg(data,4)
	set seqNum = $lg(data,8)	; 序号
	set activeFrom = $lg(data,9)	; 生效开始时间
	set activeFrom = ##class(websys.Conversions).DateLogicalToHtml(activeFrom)
	set activeTo = $lg(data,10)	; 生效结束时间
	set activeTo = ##class(websys.Conversions).DateLogicalToHtml(activeTo)
	set updateUser = $lg(data,11)	; 维护人 dr
	set updateUser = $s((updateUser '= ""):$p(^SSU("SSUSR",updateUser),"^",2),1:"")	;	后续更改为正常。此处为了已部署的项目 wzh
	set updateDate = $lg(data,12)	; 更新日期 
	set updateDate = ##class(websys.Conversions).DateLogicalToHtml(updateDate) 
	set updateTime = $lg(data,13)	; 更新日期 
	set updateTime = ##class(websys.Conversions).TimeLogicalToHtml(updateTime)
	set updateDateTime =  updateDate_" "_updateTime
	set eCol1 = $lg(data,18)	; 第一扩展列
	set eCol2 = $lg(data,19)	; 第二扩展列
	set eCol3 = $lg(data,20)	; 第三扩展列
	quit
Output
	set Data=$lb("",seqNum,tgtData,tgtCode,tgtDesc,activeFrom,activeTo,eCol1,eCol2,eCol3,updateUser,0,updateDateTime)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator: wzh
/// CreatDate: 2022.04.06
/// Description: 前端配置数据列表取结果集
/// Input:	relaCode	|	CF_BILL_COM.CfgRelaData.CRDRelaCode
/// 		srcData		|	CF_BILL_COM.CfgRelaData.CRDSourceData
/// 		hospId		|	CF_BILL_COM.CfgRelaData.CRDHospDR
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GeneralCfg","QryCfgRelaDataCont","OPCHRG.OPChg.XMZH","","COM")
Query QryCfgRelaDataCont(relaCode As %String, srcData As %String, hospId As %String, VaildFlag As %String) As websys.Query(ROWSPEC = "handler:%String:操作,seqNum:%String:序号,srcData:%String:源数据ID,srcCode:%String:源数据代码,srcDesc:%String:源数据描述,id:%String:目标数据ID,code:%String:目标数据代码,text:%String:目标数据描述,activeFrom:%Date:生效时间,activeTo:%Date:失效时间,eCol1:%String,eCol2:%String,eCol3:%String,updateUser:%String:更新人,updateFlag:%String:更新标志,updateDate:%String:更新日期")
{
}

ClassMethod QryCfgRelaDataContExecute(ByRef qHandle As %Binary, relaCode As %String, srcData As %String, hospId As %String, VaildFlag As %String) As %Status
{
	/*
	更新时间：2022.06.23	更新人：wzh
	索引由 ISrcData 更改为 ISrcDataExist
	——————————————————————————————————————————————————————————————————————————————————————	
	更新时间：2022.06.06	更新人：wzh
	对照类型查询（选定源数据）由公用方法QryCfgRelaData转至该方法
	*/
	set repid = $I(^CacheTemp)
	set qHandle = $lb(0,repid,0)
	set ind = 1
	set ^TMPPara("QryCfgRelaDataCont") = $lb(relaCode,srcData,hospId,VaildFlag)
	// 方法保护
	quit:((relaCode = "")||(hospId = "")||(VaildFlag = "")) $$$OK
	
	// 查询标志 0：查询全部 1：查询单个
	set qryFlag = 0
	set:(srcData '= "") qryFlag = 1
	
	for{
		set:(qryFlag = 0) srcData = $o(^CF.BILL.COM.CfgRelaDataI("ISrcDataExist",VaildFlag,relaCode,hospId,srcData))
		quit:(srcData = "")
		set id = ""
		for{
			set id = $o(^CF.BILL.COM.CfgRelaDataI("ISrcDataExist",VaildFlag,relaCode,hospId,srcData,id))
			quit:(id = "")
			do GetCfgRelaDataById
			set rtnDesc = ..GetDescByRelaCode(relaCode,srcData,tgtData)
			set srcCode = $p(rtnDesc,"^",1)
			set srcDesc = $p(rtnDesc,"^",2)
			set tgtCode = $p(rtnDesc,"^",3)
			set tgtDesc = $p(rtnDesc,"^",4)
			do Output
		}
		// 查询单个只进行一次
		quit:(qryFlag = 1)
	}
	
	quit $$$OK
GetCfgRelaDataById
	set data = $g(^CF.BILL.COM.CfgRelaDataD(id))
	set tgtData = $lg(data,4)
	set seqNum = $lg(data,8)	; 序号
	set activeFrom = $lg(data,9)	; 生效开始时间
	set activeFrom = ##class(websys.Conversions).DateLogicalToHtml(activeFrom)
	set activeTo = $lg(data,10)	; 生效结束时间
	set activeTo = ##class(websys.Conversions).DateLogicalToHtml(activeTo)
	set updateUser = $lg(data,11)	; 维护人 dr
	set updateUser = $s((updateUser '= ""):$p(^SSU("SSUSR",updateUser),"^",2),1:"")	;	后续更改为正常。此处为了已部署的项目 wzh
	set updateDate = $lg(data,12)	; 更新日期 
	set updateDate = ##class(websys.Conversions).DateLogicalToHtml(updateDate) 
	set updateTime = $lg(data,13)	; 更新日期 
	set updateTime = ##class(websys.Conversions).TimeLogicalToHtml(updateTime)
	set updateDateTime =  updateDate_" "_updateTime
	set eCol1 = $lg(data,18)	; 第一扩展列
	set eCol2 = $lg(data,19)	; 第二扩展列
	set eCol3 = $lg(data,20)	; 第三扩展列
	quit

Output
	set Data=$lb("",seqNum,srcData,srcCode,srcDesc,tgtData,tgtCode,tgtDesc,activeFrom,activeTo,eCol1,eCol2,eCol3,updateUser,0,updateDateTime)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator： wzh
/// CreatDate： 2022.05.17
/// Description: 根据配置点relaCode及源数据、目标数据入参获取对应的描述
/// Table： 
/// Input： relaCode  --> 配置数据表代码
///         SrcData   --> 配置数据表源数据
///         TgtData   --> 配置数据表目标数据
/// Output：源数据代码^源数据描述^目标数据代码^目标数据描述^源数据值^目标数据值
/// Return： 
/// w ##class(BILL.CFG.COM.GeneralCfg).GetDescByRelaCode("OPCHRG.OPChg.BNYBJSDZD", "", "5")
ClassMethod GetDescByRelaCode(RelaCode As %String, SrcData As %String, TgtData As %String) As %String
{
	;set ^TMPwzh(1)=$lb(relaCode,SrcData,TgtData)
	/*
		根据配置点代码获取描述。
		A.根据源数据的ID获取源数据的描述
		B.根据目标数据的ID获取目标数据的描述
		查询CPCollDataSrc字段，
		1.CPCollDataSrc=Query，则获取 CPCollDataSrcQry 。
			通过 CPCollDataSrcQry 获取字典表对应的 DataSrcTableProperty。
			通过DataSrcTableProperty字段调用方法获取描述
		2.CPCollDataSrc=Dictionary，则获取CPCollDataSrcDicType。
		3.CPCollDataSrc=""，则返回目标数据ID。
		新增返回值:源数据值^目标数据值
		当源数据/目标数据配置类型为字典时，源数据值/目标数据值 有返回值
	*/
	set dicCode = $p(RelaCode,".",1)
	set modCode = $p(RelaCode,".",2)
	set code 	= $p(RelaCode,".",3)
	set srcCode = "", srcDesc = "", tgtCode = "", tgtDesc = "",srcValue = "", tgtValue = ""
	
	// 方法保护
	quit:((dicCode = "")||(modCode = "")||(code = "")) srcCode_"^"_srcDesc_"^"_tgtCode_"^"_tgtDesc_"^"_srcValue_"^"_tgtValue
	
	set id = $o(^CF.BILL.COM.CfgPointI("DMPCode",dicCode,modCode,code,""))
	
	if (SrcData '= ""){
		set srcType = $lg(^CF.BILL.COM.CfgPointD(id),7)
		if (srcType = "Query"){
			set srcQry = $lg(^CF.BILL.COM.CfgPointD(id),16)
			set srcTableProperty = $lg(^CF.BILL.COM.DictionaryD(srcQry),12)
			set srcTableName = $p(srcTableProperty,"||",1)
			set srcDescName = $p(srcTableProperty,"||",2)
			set srcCodeName = $p(srcTableProperty,"||",3)
			set srcDesc = $s((srcDescName'=""):##class(web.DHCBillCommon).GetPropValById(srcTableName,SrcData,srcDescName),1:"") 
			set srcCode = $s((srcCodeName'=""):##class(web.DHCBillCommon).GetPropValById(srcTableName,SrcData,srcCodeName),1:"") 
		}elseif (srcType = "Dictionary"){
			set srcCode = $lg(^CF.BILL.COM.DictionaryD(SrcData),3)
			set srcDesc = $lg(^CF.BILL.COM.DictionaryD(SrcData),4)
			set srcValue = $lg(^CF.BILL.COM.DictionaryD(SrcData),5)
		}elseif (srcType = ""){
			set srcCode = SrcData
			set srcDesc = ""
			set srcValue = SrcData
		}
	}
	if (TgtData '= ""){
		set tgtType=$lg(^CF.BILL.COM.CfgPointD(id),12)
		if (tgtType = "Query"){
			set tgtQry = $lg(^CF.BILL.COM.CfgPointD(id),23)
			set tgtTableProperty = $lg(^CF.BILL.COM.DictionaryD(tgtQry),12)
			set tgtTableName = $p(tgtTableProperty,"||",1)
			set tgtDescName = $p(tgtTableProperty,"||",2)
			set tgtCodeName = $p(tgtTableProperty,"||",3)
			set tgtDesc = $s((tgtDescName'=""):##class(web.DHCBillCommon).GetPropValById(tgtTableName,TgtData,tgtDescName),1:"") 
			set tgtCode = $s((tgtCodeName'=""):##class(web.DHCBillCommon).GetPropValById(tgtTableName,TgtData,tgtCodeName),1:"") 
		}elseif (tgtType = "Dictionary"){
			set tgtCode = $lg(^CF.BILL.COM.DictionaryD(TgtData),3)
			set tgtDesc = $lg(^CF.BILL.COM.DictionaryD(TgtData),4)
			set tgtValue = $lg(^CF.BILL.COM.DictionaryD(TgtData),5)
		}elseif (tgtType = ""){
			set tgtCode = TgtData
			set tgtDesc = ""
			set tgtValue = TgtData
		}
	}
    q srcCode_"^"_srcDesc_"^"_tgtCode_"^"_tgtDesc_"^"_srcValue_"^"_tgtValue
}

/// Creator： wzh
/// CreatDate： 2022.3.31
/// Description: 集合类型配置的导入
/// Table： 
/// Input： RowDataInfo  --> 导入模板的数据拼串
///         UserDr       --> 操作员Dr
///         ErrMsg       --> 错误信息(出参)
///         ExtStr       --> 备用字符串
/// Output： 
/// Return： 
/// w ##class(BILL.CFG.COM.GeneralCfg).ImportCollByExcel(RowDataInfo, "1", .ErrMsg, "BJDTYY^RBBX1")
ClassMethod ImportCollByExcel(RowDataInfo As %String, UserDr As %String, ByRef ErrMsg As %String, ExtStr As %String) As %String
{
	/*
	更新时间：2022.06.20	更新人：wzh
	字段取值过程去掉，改至 SaveRelaDataForImport 方法取字段值
	RowDataInfo 新增第一字段：srcData
	*/
	s RtnFlg = 0
	;s ^TMPParam("ImportCollByExcel")=$lb(RowDataInfo,UserDr,ExtStr)
	s relaCode = $p(ExtStr, "^", 1)	; 代码
	s hospId = $p(ExtStr, "^", 2)	; 院区
	// RowDataInfo 插入 srcData
	set RowDataInfo = ""_"^"_RowDataInfo
	
	s flag = ##class(BILL.CFG.COM.GeneralCfg).SaveRelaDataForImport(relaCode, RowDataInfo,UserDr, hospId)
	if (+flag = 0){
		set RtnFlg = 1
	}else{
		set ErrMsg = flag
	}
    q RtnFlg
}

/// Creator： wzh
/// CreatDate： 2022.06.20
/// Description: 集合类型配置的导入
/// Table： 
/// Input： RowDataInfo  --> 导入模板的数据拼串
///         UserDr       --> 操作员Dr
///         ErrMsg       --> 错误信息(出参)
///         ExtStr       --> 备用字符串
/// Output： 
/// Return： 
/// w ##class(BILL.CFG.COM.GeneralCfg).ImportCollByExcel(RowDataInfo, "1", .ErrMsg, "BJDTYY^RBBX1")
ClassMethod ImportContByExcel(RowDataInfo As %String, UserDr As %String, ByRef ErrMsg As %String, ExtStr As %String) As %String
{
	set RtnFlg = 0
	;set ^TMPParam("ImportCollByExcel")=$lb(RowDataInfo,UserDr,ExtStr)
	set relaCode = $p(ExtStr, "^", 1)	; 代码
	set hospId = $p(ExtStr, "^", 2)	; 院区
	
	set flag = ##class(BILL.CFG.COM.GeneralCfg).SaveRelaDataForImport(relaCode, RowDataInfo,UserDr, hospId)
	if (+flag = 0){
		set RtnFlg = 1
	}else{
		set ErrMsg = flag
	}
    quit RtnFlg
}

/// Creator: wzh
/// CreatDate: 2022.03.31
/// Description: 配置的导入功能-存表方法
/// Input: 		RelaCode	|	CF_BILL_COM.CfgRelaData.CRDRelaCode
/// 			RowDataInfo	|	配置数据串
/// 			HospId		|	院区指针
/// Return: 	flag^msg
/// 			flag:	0：成功；其余：失败
/// 			msg:错误信息、失败信息
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).SaveRelaDataForImport("OPCHRG.AddPreDeposit.RcptPrtTimes", "", ^TMP("RelaList"), 2)
ClassMethod SaveRelaDataForImport(RelaCode As %String, RowDataInfo As %String, UserDr As %String, HospId As %String) As %String
{
	set $zt = "ERROR"
	
	set ^TMPParam("SaveRelaDataForImport") = $lb(RelaCode, RowDataInfo, UserDr, HospId)
	
	// 初始化
	set rtn = 0, msg = ""

	;set userId = %session.Get("LOGON.USERID")  当前写法报错，暂时屏蔽取前端的user
	set updateDate = $p($h,",",1)
	set updateTime = $p($h,",",2)
	
	// RowDataInfo 取数据
	set srcData = $p(RowDataInfo, "^", 1)	; 源数据
	
	set tgtData = $p(RowDataInfo, "^", 2)	; 目标数据
	set:(tgtData = "") rtn = 1, msg = msg_"目标数据不能为空,"
	
	set seqNum = $p(RowDataInfo, "^", 3)	; 序号
	
	set activeDateFrom = $p(RowDataInfo, "^", 4)	; 生效时间
	set activeDateFrom = ##class(websys.Conversions).DateHtmlToLogical(activeDateFrom)
	set:((activeDateFrom '= "")&&(+activeDateFrom = 0)) rtn = 1, msg = msg_"生效时间格式错误,"
	
	set activeDateTo = $p(RowDataInfo, "^", 5)		; 失效时间
	set activeDateTo = ##class(websys.Conversions).DateHtmlToLogical(activeDateTo)
	set:((activeDateTo '= "")&&(+activeDateTo = 0)) rtn = 1, msg = msg_"失效时间格式错误,"
	
	set eCol1 = $p(RowDataInfo, "^", 6)	; 扩展列1
	set eCol2 = $p(RowDataInfo, "^", 7)	; 扩展列2
	set eCol3 = $p(RowDataInfo, "^", 8)	; 扩展列3
	
	quit:(rtn > 0) rtn_"^"_msg
	
	// 获取 源数据,目标数据 的描述
	set rtnDesc = ..GetDescByRelaCode(RelaCode,srcData,tgtData)
	set srcDesc = $p(rtnDesc,"^",2)
	set tgtDesc = $p(rtnDesc,"^",4)
	
	// 目标数据为空,通过索引判断须特殊处理
	set:(srcData = "") srcData = -1E14
	
	// 判断是否存在，如果存在则退出
	if ($d(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,RelaCode,HospId,srcData,tgtData))) {
		set rtn = 1, msg = "已存在"
	}
	quit:(rtn > 0) rtn_"^"_msg
	
	// 目标数据特殊处理后再变为原数据
	set:(srcData = -1E14) srcData = ""
	
	&SQL(
		INSERT CF_BILL_COM.CfgRelaData (
			CRDRelaCode, CRDSourceData, CRDTgtData, CRDHospDR, CRDSourceDataDesc, 
			CRDTgtDataDesc, CRDSeqNum, CRDActiveDateFrom, CRDActiveDateTo, CRDUpdtId, 
			CRDUpdtDate, CRDUpdtTime, CRDOptId, CRDOptDate, CRDOptTime,
			CRDECol1, CRDECol2, CRDECol3
		)
		VALUES (
			:RelaCode, :srcData, :tgtData, :HospId, :srcDesc,
			:tgtDesc, :seqNum, :activeDateFrom, :activeDateTo,:UserDr,
			:updateDate, :updateTime, :UserDr, :updateDate, :updateTime,
			:eCol1, :eCol2, :eCol3
		)
	)
	
	set rtn = SQLCODE
	if (+rtn) {
		set msg = $g(%msg) 
		quit rtn_"^"_msg
	}

	quit rtn_"^"_msg
ERROR
	quit ..AppException()
}

/// Creator: wzh
/// CreatDate: 2022.04.05
/// Description: 配置点修改发布状态
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).RelaseCfgPoint(^TMP("SaveProModule"))
ClassMethod RelaseCfgPoint(ID As %String, Relase As %String) As %String
{
	set $zt="ERROR"
	
	ts	
	set objPt=##class(CF.BILL.COM.CfgPoint).%OpenId(ID, 0)
	if ('$isObject(objPt)) {
		tro
		quit -1_"^"_"创建对象失败"
	}
	set objPt.CPIsReleased=Relase
	set sc=objPt.%Save()
	do objPt.%Close()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	
	if ($tl>0) tc
	
	quit 0

ERROR
	quit ..AppException()
}

/// Creator: wzh
/// CreatDate: 2023.03.21
/// Description: 通用配置通用调用方法(仅适用于返回值)
/// Input: 		RelaCode	|	CF_BILL_COM.CfgRelaData.CRDRelaCode		全代码
/// 			SourceData	|	CF_BILL_COM.CfgRelaData.CRDSourceData	源数据
/// 			TgtData		|	CF_BILL_COM.CfgRelaData.CRDTgtData		目标数据
/// 			HospId		|	CF_BILL_COM.CfgRelaData.CRDHospDR		院区
/// 			Date		|	CF_BILL_COM.CfgRelaData.CRDActiveDateFrom-CRDActiveDateTo	时间
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GeneralCfg","GetResultByRelaCodeForQuery","OPCHRG.OPChrg.SFAXZDBZZDGXDYYZ","","",2)
Query GetResultByRelaCodeForQuery(RelaCode As %String, SourceData As %String, TgtData As %String, HospId As %String, Date As %String = "") As websys.Query(ROWSPEC = "ID:%String,CRDRelaCode:%String,CRDSourceData:%String,CRDTgtData:%String,CRDHospDR:%String,CRDSourceDataDesc:%String,CRDTgtDataDesc:%String,CRDSeqNum:%String,CRDActiveDateFrom:%String,CRDActiveDateTo:%String,CRDUpdtId:%String,CRDUpdtDate:%String,CRDUpdtTime:%String,CRDVaildFlag:%String,CRDOptId:%String,CRDOptDate:%String,CRDOptTime:%String,CRDECol1:%String,CRDECol2:%String,CRDECol3:%String")
{
}

ClassMethod GetResultByRelaCodeForQueryExecute(ByRef qHandle As %Binary, RelaCode As %String, SourceData As %String, TgtData As %String, HospId As %String, Date As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	
 	// 方法开始，初始化参数，获取配置点id
	set jsonObj = {}
	/*
		1.针对于集合类型（值类型认为是不可多选的集合类型）
			1.1	输入：源数据：空；目标数据：空
				返回：所有配置的数据
			1.2	输入：源数据：空；目标数据：不为空
				返回：与目标数据一致的那条数据。如果没有则返回空
		2.针对于对照类型
			2.1	输入：源数据：空；目标数据：空
				返回：所有配置的数据
			2.2	输入：源数据：不为空；目标数据：空
				返回：指定源数据下配置的所有目标数据，如果没有则返回空
			2.2	输入：源数据：不为空；目标数据：不为空
				返回：与源数据、目标数据一致的那条数据，如果没有则返回空
         实际逻辑：	
         	1.	SourceData=""	TgtData=""	取所有数据
         	2.	SourceData=""	TgtData'="" 取指定数据(如果是对照则返回数据为空)
         	3.	SourceData'=""	TgtData=""	取SourceData下所有数据
         	4.	SourceData'=""	TgtData'=""	取指定数据
         逻辑：
         	1.判断TgtData是否为空。不为空则取指定数据，否则继续
         	2.判断SourceData是否为空，不为空则取SourceData下所有数据，否则继续
         	3.取所有数据
	*/
	
	
	set checkRtn = ..CheckCfgRelaForResult(.jsonObj,RelaCode,SourceData,TgtData,.HospId,Date)
	if (+checkRtn){
		if (TgtData '= ""){
			set:(SourceData = "") SourceData = -1E14
			set dataRtn = $o(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1, RelaCode, HospId, SourceData, TgtData,""))
			do GetDataByStr
		}else{
			if (SourceData '= ""){
				set dataRtn = ..GetCfgRelaDataIDBySeqNum(RelaCode,SourceData,HospId)
				do GetDataByStr
			}else{
				set sourceData = ""
				for{
					set sourceData = $o(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1, RelaCode, HospId, sourceData))
					quit:(sourceData="")
					set dataRtn = ..GetCfgRelaDataIDBySeqNum(RelaCode,sourceData,HospId)
					do GetDataByStr
				}
			}
		}
	}
	
	quit $$$OK
GetDataByStr
	set dataId = "",i = 1
	for{
		set dataId = $p(dataRtn,"^",i)
		set i = i+1
		quit:(dataId = "")
		set checkDataFlag = 1
		do CheckData
		continue:(checkDataFlag = 0)
		do GetData
		do Output
	}
	quit
Output
	set Data = relaData
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
CheckData
	// 配置数据有效时间判断
	set checkDataFlag = ..CheckRelaDataActiveDate(dataId)
	quit
GetData
	set relaData = $g(^CF.BILL.COM.CfgRelaDataD(dataId))
	set tgtData = $lg(relaData,4)
	//set descRtn = ..GetDescByRelaCode(RelaCode,"",tgtData)
	//set dataDesc = $p(descRtn,"^",4)
	//set dataCode = $p(descRtn,"^",3)
	//set dataValue = $p(descRtn,"^",6)
	
	set ecol1 = $lg(relaData,18)
	
	quit
}

/// Creator: wzh
/// CreatDate: 2022.09.01
/// Description: 通用配置通用调用方法(仅适用于返回值)
/// Input: 		RelaCode	|	CF_BILL_COM.CfgRelaData.CRDRelaCode
/// 			SourceData	|	CF_BILL_COM.CfgRelaData.CRDSourceData
/// 			TgtData		|	CF_BILL_COM.CfgRelaData.CRDTgtData
/// 			HospId		|	CF_BILL_COM.CfgRelaData.CRDHospDR
/// 			Date		|	CF_BILL_COM.CfgRelaData.CRDActiveDateFrom-CRDActiveDateTo
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GeneralCfg","GetResultForQuery","OPCHRG.OPChg.SJZS","","",2)
Query GetResultForQuery(RelaCode As %String, SourceData As %String, TgtData As %String, HospId As %String, Date As %String = "") As websys.Query(ROWSPEC = "ID:%String,code:%String,desc:%String")
{
}

ClassMethod GetResultForQueryExecute(ByRef qHandle As %Binary, RelaCode As %String, SourceData As %String, TgtData As %String, HospId As %String, Date As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	
 	// 方法开始，初始化参数，获取配置点id
	set jsonObj = {}
	
	set checkRtn = ..CheckCfgRelaForResult(.jsonObj,RelaCode,SourceData,TgtData,.HospId,Date)
	if (+checkRtn){
		// 如果返回值，且有 TgtData 则
		if (TgtData '= ""){
			set:(SourceData = "") SourceData = -1E14
			set dataRtn = $o(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1, RelaCode, HospId, SourceData, TgtData,""))
		}else{
			// A1.根据入参获取代码的值，将结果按照Id，Desc，Code塞入json中
			set dataRtn = ..GetCfgRelaDataIDBySeqNum(RelaCode,SourceData,HospId)
		}
		
		set dataId = "",i = 1
		for{
			set dataId = $p(dataRtn,"^",i)
			set i = i+1
			quit:(dataId = "")
			set checkDataFlag = 1
			do CheckData
			continue:(checkDataFlag = 0)
			do GetData
			do Output
		}
	}
	
	quit $$$OK
	
Output
	set Data=$lb(tgtData,dataCode,dataDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
CheckData
	// 配置数据有效时间判断
	set checkDataFlag = ..CheckRelaDataActiveDate(dataId)
	quit
GetData
	set relaData = $g(^CF.BILL.COM.CfgRelaDataD(dataId))
	set tgtData = $lg(relaData,4)
	set descRtn = ..GetDescByRelaCode(RelaCode,"",tgtData)
	set dataDesc = $p(descRtn,"^",4)
	set dataCode = $p(descRtn,"^",3)
	set dataValue = $p(descRtn,"^",6)
	;set data = $s((data '= ""):(data_"^"_tgtData_"^"_dataCode_"^"_dataDesc),1:(tgtData_"^"_dataCode_"^"_dataDesc))
	set ecol1 = $lg(relaData,18)
	;set ecol1Str = $s((ecol1Str '= ""):(ecol1Str_"^"_ecol1),1:ecol1)
	;set valueStr = $s((valueStr '= ""):(valueStr_"^"_dataValue),1:dataValue)
	quit
}

/// Creator: wzh
/// CreatDate: 2022.04.15
/// Description: 通用配置通用调用方法(建议用于返回判断类,返回值类建议仅返回单行数据)
/// Input: 		RelaCode	|	CF_BILL_COM.CfgRelaData.CRDRelaCode
/// 			SourceData	|	CF_BILL_COM.CfgRelaData.CRDSourceData
/// 			TgtData		|	CF_BILL_COM.CfgRelaData.CRDTgtData
/// 			HospId		|	CF_BILL_COM.CfgRelaData.CRDHospDR
/// 			Date		|	CF_BILL_COM.CfgRelaData.CRDActiveDateFrom-CRDActiveDateTo
/// Return: 	JSON
/// 			flag		|	1:可执行		0: 不可执行		-1:提醒	-2:警告	-3:阻断
/// 			data		|	返回值(返回值为空时flag为0)
/// 			ecol1		|	返回值-额外字段1，顺序与data中顺序相同
/// 			msg			|	flag=1,msg=""	flag'=0,msg=报错、提示
/// Debug: 	w ##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPChg.1","1","1",2)
/// 		w ##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("BILL.CFG.COM.GeneralCfg","","142",2)
ClassMethod GetResultByRelaCode(RelaCode As %String, SourceData As %String, TgtData As %String, HospId As %String, Date As %String = "") As %String
{
	/*
	通用配置调用逻辑
	当前控制点： 
		发布状态		CPIsReleased	0:未发布 1:已发布 2：已作废
		生效开始日期	CPActiveDateFrom
		生效结束日期	CPActiveDateTo
		结果类型		CPResultType	1:值 2:判断结果
		控制类型		CPCtrlType		1:适用配置 2:禁用配置
		控制级别		CPCtrlLevelDicCode	1:提醒(弹框提醒，不限制), 2:警告(告诉用户问题，用户选择是否继续), 3:阻断(提醒，不允许)
		控制级别备注	CPCtrlLevelRemark	
		
	控制逻辑：
		1.判断发布状态，非 1则直接退出。返回指定报错msg（此处是否需要返回报错。返回报错可以便于开发跟踪错误）
		2.判断两个日期，过期则直接退出，返回指定报错msg
		3.判断是否公用，如果公用则判断该院区下是否存在数据，如果没则 HospId 置为COM，取公用数据判断
		4.判断结果类型，如果是1结果，则进行A系列，否则进行B系列
		A1.根据入参获取代码的值，将结果按照Id，Desc，Code塞入json中
		B1.根据入参判断是否存在。再根据控制类型判断返回的结果
		B2.判断控制级别是否存在，如果存在，则根据控制级别及控制级别备注返回参数，由前端处理
	—————————————————————————————————————————————————————————————————————————————————————————————————————————
	更新时间：2022.12.05	更新人：wzh
	新增 返回值
	当返回值data为空时，flag为0
	—————————————————————————————————————————————————————————————————————————————————————————————————————————
	更新时间：2022.06.28	更新人：wzh
	新增 返回值 根据序号取值
	优化公用判断
	—————————————————————————————————————————————————————————————————————————————————————————————————————————
	更新时间：2022.06.20	更新人：wzh
	新增是否公用判断
	—————————————————————————————————————————————————————————————————————————————————————————————————————————
	更新时间：2022.06.02	更新人：wzh
	1.配置数据增加有效判断
	2.方法增加时间入参，如果有时间入参，则判断配置数据有效时间
	—————————————————————————————————————————————————————————————————————————————————————————————————————————
	*/
	// 方法开始，初始化参数，获取配置点id
	set jsonObj = {}
	set flag = 1, data = "", msg = ""
	
	set checkRtn = ..CheckCfgRelaForResult(.jsonObj,RelaCode,SourceData,TgtData,.HospId,Date)
	if (+checkRtn){
		// 如果返回值，且有 TgtData 则
		if (TgtData '= ""){
			set:(SourceData = "") SourceData = -1E14
			set dataRtn = $o(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1, RelaCode, HospId, SourceData, TgtData,""))
		}else{
			// A1.根据入参获取代码的值，将结果按照Id，Desc，Code塞入json中
			set dataRtn = ..GetCfgRelaDataIDBySeqNum(RelaCode,SourceData,HospId)
		}
		set:(dataRtn = "") flag = 0
		set dataId = "",i = 0,ecol1Str = "", valueStr = ""
		for{
			set i = i+1
			set dataId = $p(dataRtn,"^",i)
			quit:(dataId = "")
			set checkDataFlag = 1
			do CheckData
			continue:(checkDataFlag = 0)
			do GetData
		}
	do SetJson
	}
	
	// 方法结束
	quit jsonObj.%ToJSON()
	
SetJson
	do jsonObj.%Set("success", flag)
	do jsonObj.%Set("msg", msg)
	do jsonObj.%Set("data", data)
	do jsonObj.%Set("ecol1", $g(ecol1Str))
	do jsonObj.%Set("value", $g(valueStr))
	quit
	
CheckData
	// 配置数据有效时间判断
	set checkDataFlag = ..CheckRelaDataActiveDate(dataId)
	quit
GetData
	set relaData = $g(^CF.BILL.COM.CfgRelaDataD(dataId))
	set tgtData = $lg(relaData,4)
	set descRtn = ..GetDescByRelaCode(RelaCode,"",tgtData)
	set dataDesc = $p(descRtn,"^",4)
	set dataCode = $p(descRtn,"^",3)
	set dataValue = $p(descRtn,"^",6)
	set data = $s((data '= ""):(data_"^"_tgtData_"^"_dataCode_"^"_dataDesc),1:(tgtData_"^"_dataCode_"^"_dataDesc))
	set ecol1 = $lg(relaData,18)
	set ecol1Str = $s((ecol1Str '= ""):(ecol1Str_"^"_ecol1),1:ecol1)
	set valueStr = $s((valueStr '= ""):(valueStr_"^"_dataValue),1:dataValue)
	quit
}

/// Creator: wzh
/// CreatDate: 2022.09.01
/// Description: 校验结果,判断是否继续执行
/// Input: 	RelaCode	|	CF_BILL_COM.CfgRelaData.CRDRelaCode
/// 		SourceData	|	CF_BILL_COM.CfgRelaData.CRDSourceData
/// 		TgtData		|	CF_BILL_COM.CfgRelaData.CRDTgtData
/// 		HospId		|	CF_BILL_COM.CfgRelaData.CRDHospDR
/// 		Date		|	CF_BILL_COM.CRDActiveDateFrom-CRDActiveDateTo
/// Return: flag^id		
/// 		flag		|	1：继续，0：不继续
/// 		id			|	CF_BILL_COM.CfgRelaData.ID
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).CheckCfgRelaForResult({},"OPCHRG.OPChg.1","1","1",2)
ClassMethod CheckCfgRelaForResult(ByRef jsonObj, RelaCode As %String, SourceData As %String, TgtData As %String, ByRef HospId, Date As %String = "") As %String
{
	// 方法开始，初始化参数，获取配置点id
	set flag = 1, data = "", msg = ""
	
	set dicCode = $p(RelaCode,".",1)
	set modCode = $p(RelaCode,".",2)
	set code	= $p(RelaCode,".",3)
	
	// 方法保护 开始
	set:((dicCode = "")||(modCode = "")||(code = "")) flag = 0, msg = "入参-配置点代码格式异常！"
	if (flag '= 1) {
		do SetJson
		quit "0"
	}
	
	set:(HospId = "") flag = 0, msg = "入参-院区指针为空！"
	if (flag '= 1) {
		do SetJson
		quit "0"
	}
	
	set id = $o(^CF.BILL.COM.CfgPointI("DMPCode",dicCode,modCode,code,""))	; 配置点id

	set:(id = "") flag = 0, msg = "入参-配置点代码错误，不存在该配置点！"
	if (flag '= 1) {
		do SetJson
		quit "0"
	}
	// 方法保护 结束
	
	// 1.校验 发布状态 开始
	do ..CheckCfgPointRelease(id, .flag, .msg)

	if (flag '= 1) {
		do SetJson
		quit "0"
	}
	// 1.检验 发布状态 结束
	
	
	// 2.校验 开始日期 结束日期 开始
	do ..CheckCfgPointDate(id, .flag, .msg)
	
	if (flag '= 1) {
		do SetJson 
		quit "0"
	}
	// 2.检验 开始日期 结束日期 结束
	
	
	// 3.检验 公用标志 开始
	set publicFlag = $lg(^CF.BILL.COM.CfgPointD(id),27)		; 公用标志
	if ((publicFlag = 1)&&('..CheckCfgRelaHospExist(RelaCode,HospId))){
		set HospId = "COM"
	}
	// 3.检验 公用标志 结束
	
	
	// 4.校验 结果类型 开始
	set rtnType = $lg(^CF.BILL.COM.CfgPointD(id),26)		; 结果类型
	if (rtnType = "1"){// 返回值
		// A1.根据入参获取代码的值，将结果按照Id，Desc，Code塞入json中
		// 返回值不做任何处理,由调用方法处理
		do SetJson
		quit flag_"^"_id
	}elseif (rtnType = "2"){// 返回判断
		// 方法保护
		set:(TgtData = "") flag = 0, msg = "该类型的配置点入参目标数据不可为空"
		if (flag '= 1) {
			do SetJson 
			quit "0"
		}
		// B1.根据入参判断是否存在。再根据控制类型判断返回的结果
		set isExistFlag = +..CheckCfgRelaDataExist(RelaCode, SourceData, TgtData, HospId, Date)	;1：存在，0：不存在
		set ctrlType = $lg(^CF.BILL.COM.CfgPointD(id),25)		; 控制类型
		if (ctrlType = "1"){	; 适用配置
			// 适用配置：存在即可执行，不存在进入判断
			if (isExistFlag = "0"){
				set flag = 0,msg = "适用的配置点"_"不存在该参数"
			}
		}elseif (ctrlType = "2"){; 禁用配置
			// 禁用配置：不存在即可执行，存在进入判断
			if (isExistFlag = "1"){
				set flag = 0,msg = "禁用的配置点"_"存在该参数"
			}
		}else{// 异常数据处理
			set flag = 0,msg = "配置点未配置控制类型:"_ctrlType
			do SetJson
			quit "0"
		}
		
		// B2.判断控制级别是否存在，如果存在，则根据控制级别及控制级别备注返回参数，由前端处理
		do ..CheckCfgPointCtrl(id,TgtData,.flag,.msg)
		
		// 返回判断 特殊处理,后续不需要再继续执行
		do SetJson
		quit "0"
	}else{// 异常数据处理
		set flag = 0,msg = "配置点未配置控制类型:"_rtnType
		do SetJson
		quit "0"
	}
	// 4.检验 结果类型 结束
	
	
SetJson
	do jsonObj.%Set("success", flag)
	do jsonObj.%Set("msg", msg)
	do jsonObj.%Set("data", data)
	quit
}

/// Creator: wzh
/// CreatDate: 2022.05.05
/// Description: 判断配置点下 SourceData TgtData 是否存在
/// Input: 	RelaCode	|	CF_BILL_COM.CfgRelaData.CRDRelaCode
/// 		SourceData	|	CF_BILL_COM.CfgRelaData.CRDSourceData
/// 		TgtData		|	CF_BILL_COM.CfgRelaData.CRDTgtData
/// 		HospId		|	CF_BILL_COM.CfgRelaData.CRDHospDR
/// 		Date		|	CF_BILL_COM.CRDActiveDateFrom-CRDActiveDateTo
/// Return: flag^id		
/// 		flag		|	1：存在，0：不存在 
/// 		id			|	CF_BILL_COM.CfgRelaData.ID
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).CheckCfgRelaDataExist("OPCHRG.OPChg.1","","1","2")
ClassMethod CheckCfgRelaDataExist(RelaCode As %String, SourceData As %String, TgtData As %String, HospId As %String, Date As %String = "") As %String
{
	/*
	更新时间：2022.06.16	更新人：wzh
	查询索引由 IRelaData 变更为 IRelaDataExist	||	由原来for循环查询变更为一次查询，提高查询效率
	—————————————————————————————————————————————————————————————————————————————————————————————————————————
	更新时间：2022.06.10	更新人：wzh
	1.新增入参 Date
	2.新增判断方法 checkCfgRelaDataExistForDate
	*/
	// 初始化返回的标志flag
	set retFlag = 0, id = ""
	
	//方法保护
	quit:((RelaCode = "")||(TgtData = "")||(HospId = "")) retFlag_"^"_id
	
	// 此处由于索引创建的时候，空被创建为-1E14。此处随索引具体改变。
	set:(SourceData = "") SourceData = -1E14
	
	set Date = ##class(websys.Conversions).DateHtmlToLogical(Date)	;时间转换为数字

	set id = $o(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,RelaCode,HospId,SourceData,TgtData,""))
	quit:(id = "") retFlag_"^"_id
	
	set flag = 1	; 初始化判断标志
	/*
		时间：2022-11-27
		内容：新增有效时间校验。如果传进来时间了，则按照传进来的时间校验已有的时间，如果没有传进来时间，则判断是否在有效期内（如果校验逻辑打开了）
	*/
	if (Date = ""){
		set flag = ..CheckRelaDataActiveDate(id)
	}else{
		do CheckDate
	}
	
	set:(flag = 1) retFlag = 1
	
	
	quit retFlag_"^"_id
	
CheckDate
	set activeDateFrom = $lg(^CF.BILL.COM.CfgRelaDataD(id),9)	; 生效时间
	set activeDateTo = $lg(^CF.BILL.COM.CfgRelaDataD(id),10)	; 失效时间
	set:((activeDateFrom '= "")&&(activeDateFrom > Date)) flag = 0
	set:((activeDateTo '= "")&&(activeDateTo < Date)) flag = 0
	quit
}

/// Creator: wzh
/// CreatDate: 2022.05.27
/// Description: 判断配置点下 SourceData HospId 是否有配置数据
/// Input: 	RelaCode	|	CF_BILL_COM.CfgRelaData.CRDRelaCode
/// 		SourceData	|	CF_BILL_COM.CfgRelaData.CRDSourceData
/// 		HospId		|	CF_BILL_COM.CfgRelaData.CRDHospDR
/// Return: flag^id		flag:1：存在，0：不存在 id:CF_BILL_COM.CfgRelaData.ID
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).CheckCfgRelaDataSrcDataExist("OPCHRG.OPChg.KSKYDZFFS","1","2")
ClassMethod CheckCfgRelaDataSrcDataExist(RelaCode As %String, SourceData As %String, HospId As %String) As %String
{
	/*
	更新时间：2022.06.16	更新人：wzh
	查询索引由 IRelaData 变更为 IRelaDataExist	||	由原来for循环查询变更为一次查询，提高查询效率
	—————————————————————————————————————————————————————————————————————————————————————————————————————————
	*/
	// 初始化返回的标志flag
	set flag = 0
	
	// 方法保护
	quit:((RelaCode = "")||(HospId = "")) flag
	
	// 此处由于索引创建的时候，空被创建为-1E14。此处随索引具体改变。
	set:(SourceData = "") SourceData = -1E14
	
	if ( $d(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,RelaCode,HospId,SourceData)) ){
		set flag = 1
	}

	quit flag
}

/// Creator: wzh
/// CreatDate: 2022.06.16
/// Description: 判断配置点下 HospId 是否有配置数据
/// Input: 	RelaCode	|	CF_BILL_COM.CfgRelaData.CRDRelaCode
/// 		HospId		|	CF_BILL_COM.CfgRelaData.CRDHospDR
/// Return: flag		
/// 		flag:1：存在，0：不存在
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).CheckCfgRelaHospExist("OPCHRG.OPChg.KSKYDZFFS","2")
ClassMethod CheckCfgRelaHospExist(RelaCode As %String, HospId As %String) As %String
{
	
	// 初始化返回的标志flag
	set flag = 0
	
	// 方法保护
	quit:((RelaCode = "")||(HospId = "")) flag
	
	if ( $d(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,RelaCode,HospId)) ){
		set flag = 1
	}

	quit flag
}

/// Creator: wzh
/// CreatDate: 2022.06.16
/// Description: 判断配置点是否有配置数据
/// Input: 	RelaCode	|	CF_BILL_COM.CfgRelaData.CRDRelaCode
/// 		HospId		|	CF_BILL_COM.CfgRelaData.CRDHospDR
/// Return: flag		
/// 		flag:1：存在，0：不存在
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).CheckCfgRelaExist("OPCHRG.OPChg.KSKYDZFFS")
ClassMethod CheckCfgRelaExist(RelaCode As %String) As %String
{
	
	;set ^TMPParam("CheckCfgRelaExist") = $lb(RelaCode)
	// 初始化返回的标志flag
	set flag = 0
	
	// 方法保护
	quit:(RelaCode = "") flag
	
	if ( $d(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,RelaCode)) ){
		set flag = 1
	}

	quit flag
}

/// Creator: wzh
/// CreatDate: 2022.06.16
/// Description: 判断配置点是否配置过数据
/// Input: 	RelaCode	|	CF_BILL_COM.CfgRelaData.CRDRelaCode
/// 		HospId		|	CF_BILL_COM.CfgRelaData.CRDHospDR
/// Return: flag		
/// 		flag:1：存在，0：不存在
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).CheckCfgRelaExistData("OPCHRG.OPChg.KYDZFFS")
ClassMethod CheckCfgRelaExistData(RelaCode As %String) As %String
{
	
	;set ^TMPParam("CheckCfgRelaExistData") = $lb(RelaCode)
	// 初始化返回的标志flag
	set flag = 0
	
	// 方法保护
	quit:(RelaCode = "") flag
	
	if ( $d(^CF.BILL.COM.CfgRelaDataI("IRelaData",RelaCode)) ){
		set flag = 1
	}

	quit flag
}

/// Creator: wzh
/// CreatDate: 2022.09.28
/// Description: 判断配置点序号是否存在
/// Input: 	RelaCode	|	CF_BILL_COM.CfgRelaData.CRDRelaCode		|	代码
/// 		SrcData		|	CF_BILL_COM.CfgRelaData.CRDSourceData	|	源数据id
/// 		SeqNum		|	CF_BILL_COM.CfgRelaData.CRDSeqNum		|	序号
/// 		HospId		|	CF_BILL_COM.CfgRelaData.CRDHospDR		|	院区
/// Return: flag		
/// 		flag:1：存在，0：不存在
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).CheckCfgRelaSeqNumExist("OPCHRG.OPChrg.3","1","2","3","COM")
ClassMethod CheckCfgRelaSeqNumExist(RelaCode As %String, SrcData As %String, TgtData As %String, SeqNum As %String, HospId As %String) As %String
{
	;set ^TMPParam("CheckCfgRelaSeqNumExist") = $lb(RelaCode)
	// 初始化返回的标志flag
	set flag = 0
	// 方法保护
	quit:((RelaCode = "")||(SeqNum = "")||(HospId = "")) flag
	set:(SrcData = "") SrcData = -1E14
	if ( $d(^CF.BILL.COM.CfgRelaDataI("ISeqNumExist",1,RelaCode,HospId,SrcData,SeqNum)) ){
		set id =$o(^CF.BILL.COM.CfgRelaDataI("ISeqNumExist",1,RelaCode,HospId,SrcData,SeqNum,0))
		set tgtData = $lg(^CF.BILL.COM.CfgRelaDataD(id),4)
		set:(tgtData '= TgtData) flag = 1
	}
	quit flag
}

/// Creator: wzh
/// CreatDate: 2022.05.05
/// Description: 检验配置点控制级别
/// Input: 
/// Return: flag^msg
/// 		flag: -1:提醒	-2:警告	-3:阻断	0:正常
/// 		msg:控制级别备注。flag=0时为空
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).CheckCfgPointCtrl("","")
ClassMethod CheckCfgPointCtrl(ID As %String, TgtData As %String, ByRef Flag, ByRef Msg)
{
	// flag 不为0则退出,不符合判断条件
	quit:(Flag '= 0)

	set ctrlLevelFlag = $lg(^CF.BILL.COM.CfgPointD(ID),18)	;控制级别
	if (ctrlLevelFlag '= ""){
		set src = "", tableProperty = ""
		// 如果TgtData'=""，需要转为汉字
		if (TgtData '= ""){
			set tgtDataSrcQryDicDR = $lg(^CF.BILL.COM.CfgPointD(ID),23)		; 目标数据源Query字典表指针
			if (tgtDataSrcQryDicDR '= ""){
				set tableProperty = $lg(^CF.BILL.COM.DictionaryD(tgtDataSrcQryDicDR),12)
			}else{
				set collDataSrcQryDicDR = $lg(^CF.BILL.COM.CfgPointD(ID),16)	; 集合数据源Query字典表指针
				if (collDataSrcQryDicDR '= ""){
					set tableProperty = $lg(^CF.BILL.COM.DictionaryD(collDataSrcQryDicDR),12)
				}
			}
			if (tableProperty '= ""){
				set tableName = $p(tableProperty,"||",1)
				set colName = $p(tableProperty,"||",2)
				set src=##class(web.DHCBillCommon).GetPropValById(tableName,TgtData,colName)
			}
		}

		set Msg =$lg(^CF.BILL.COM.CfgPointD(ID),24)
		if (Msg [ "*"){
			set Msg = $REPLACE(Msg,"*",src)
			;$s((src '= ""):($lg(^CF.BILL.COM.CfgPointD(ID),24)_"："_src),1:$lg(^CF.BILL.COM.CfgPointD(ID),24))		;控制文字备注
		} 
		set Flag = -ctrlLevelFlag
	}
}

/// Creator: wzh
/// CreatDate: 2022.05.05
/// Description: 检验配置点发布状态
/// Input: 
/// Return: flag^msg
/// 		flag:1:可执行,0: 不可执行
/// 		msg:flag=0时，不可执行的原因
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).CheckCfgPointRelease("","")
ClassMethod CheckCfgPointRelease(ID As %String, ByRef Flag, ByRef Msg) As %String
{
	
	// 查看配置点发布状态控制是否开启
	/* 
		Date:2023.03.23	Num:3360467	wzh
		内容：将发布状态校验变更为固有校验，不再根据字典维护中的校验项状态进行判断
	*/
	;set checkFlagDr=$o(^CF.BILL.COM.DictionaryI("IDataKey","CPCheck","Release",""))
	;set checkFlag=$s((checkFlagDr'=""):$lg(^CF.BILL.COM.DictionaryD(checkFlagDr),5),1:"0")
	;if (checkFlag="1"){
	set releaseFlag = $lg(^CF.BILL.COM.CfgPointD(ID),22)	; 发布状态
	if (releaseFlag '= "1"){
		set Flag = 0
		set:(releaseFlag = "0") Msg = "尚未发布"
		set:(releaseFlag = "2") Msg = "已废弃"
	}
	;}
	
	quit
}

/// Creator: wzh
/// CreatDate: 2022.05.05
/// Description: 检验配置点时间
/// Input: 
/// Return: flag^msg
/// 		flag:1:可执行,0: 不可执行
/// 		msg:flag=0时，不可执行的原因
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).CheckCfgPointDate("","")
ClassMethod CheckCfgPointDate(ID As %String, ByRef Flag, ByRef Msg) As %String
{
	
	// 查看配置点发布状态控制是否开启
	set checkFlagDr = $o(^CF.BILL.COM.DictionaryI("IDataKey","CPCheck","ActiveDate",""))
	set checkFlag = $s((checkFlagDr'=""):$lg(^CF.BILL.COM.DictionaryD(checkFlagDr),5),1:"0")
	if (checkFlag = "1"){
		set ActiveDateFrom = $lg(^CF.BILL.COM.CfgPointD(ID),20)		; 生效开始日期
		set ActiveDateTo = $lg(^CF.BILL.COM.CfgPointD(ID),21)		; 生效结束日期
		set curDate = $p($h,",")
		set:((ActiveDateFrom '= "")&&(ActiveDateFrom > curDate)) Flag = 0, Msg = "该配置点尚未生效"
		set:((ActiveDateTo '= "")&&(ActiveDateTo < curDate)) Flag = 0, Msg = "该配置点已失效"
	}
	quit
}

/// Creator: wzh
/// CreatDate: 2022.06.15
/// Description: 获取已配置数据的源数据id串（仅针对对照类型）
/// Input: 	RelaCode	|	CF_BILL_COM.CfgRelaData.CRDRelaCode
/// 		HospId		|	CF_BILL_COM.CfgRelaData.CRDHospDR
/// Return: msg
/// 		msg:源数据id以"^"拼接
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).GetCfgRelaDataSrcExist("OPCHRG.OPChg.1","COM")
ClassMethod GetCfgRelaDataSrcExist(RelaCode As %String, HospId As %String) As %String
{
	// 初始化返回的标志
	set msg = ""
	
	// 方法保护
	quit:((RelaCode = "")||(HospId = "")) "入参异常！"
		
	;set ^TMPParam("GetCfgRelaDataSrcExist") = $lb(RelaCode, HospId)
	
	set srcData = ""
	for  {
		// 遍历源数据 srcData
		set srcData = $o(^CF.BILL.COM.CfgRelaDataI("ISrcDataExist",1,RelaCode,HospId,srcData))
		quit:(srcData = "")
		set id = ""
		for{
			// 遍历源数据 srcData 下的 id
			set id = $o(^CF.BILL.COM.CfgRelaDataI("ISrcDataExist",1,RelaCode,HospId,srcData,id))
			quit:(id = "")
			;set vaildFlag = $lg(^CF.BILL.COM.CfgRelaDataD(id),14)	; 有效标志
			;continue:(vaildFlag = "0")		; 过滤无效数据
			set msg = $s((msg '= ""):(msg_"^"_srcData),1:srcData)	; 存储有效的 srcData 并退出，判断下一个 srcData
			quit
		}
	}	
	
	quit msg
}

/// Creator: wzh
/// CreatDate: 2022.11.27
/// Description: 判断配置数据有效时间
/// Input: 	RelaCode	|	CF_BILL_COM.CfgRelaData.Rowid
/// Return: rtnFlag 1:有效 0:无效
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).CheckRelaDataActiveDate("OPCHRG.OPChg.1","COM")
ClassMethod CheckRelaDataActiveDate(RelaDataDr As %String)
{
	set rtnFlag = 1
	
	set checkFlagDr = $o(^CF.BILL.COM.DictionaryI("IDataKey","CPCheck","DataActiveDate",""))
	set checkFlag = $s((checkFlagDr'=""):$lg(^CF.BILL.COM.DictionaryD(checkFlagDr),5),1:"0")
	if (checkFlag = "1"){
		set activeDateFrom = $lg(^CF.BILL.COM.CfgRelaDataD(RelaDataDr),9)	; 生效时间
		set activeDateTo = $lg(^CF.BILL.COM.CfgRelaDataD(RelaDataDr),10)	; 失效时间
		set curDate = $p($h,",")
		set:((activeDateFrom '= "")&&(activeDateFrom > curDate)) rtnFlag = "0"
		set:((activeDateTo '= "")&&(activeDateTo < curDate)) rtnFlag = "0"
	}
	
	quit rtnFlag
}

/// Creator: tangzf
/// CreatDate: 2022-4-22
/// Description: 每天备份通用配置GLOBAL任务
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).GeneralCfgBackup(^TMP("SaveProModule"))
ClassMethod GeneralCfgBackup() As %String
{
	//1.备份产品线表
	merge ^DHCBILLGeneralCfg(+$h,"CF.BILL.COM.ProModuleD")=^CF.BILL.COM.ProModuleD
	merge ^DHCBILLGeneralCfg(+$h,"CF.BILL.COM.ProModuleI")=^CF.BILL.COM.ProModuleI
	//2.备份配置点表
	merge ^DHCBILLGeneralCfg(+$h,"CF.BILL.COM.CfgPointD")=^CF.BILL.COM.CfgPointD
	merge ^DHCBILLGeneralCfg(+$h,"CF.BILL.COM.CfgPointI")=^CF.BILL.COM.CfgPointI
	//3.备份配置关系表
	merge ^DHCBILLGeneralCfg(+$h,"CF.BILL.COM.CfgRelaDataD")=^CF.BILL.COM.CfgRelaDataD
	merge ^DHCBILLGeneralCfg(+$h,"CF.BILL.COM.CfgRelaDataI")=^CF.BILL.COM.CfgRelaDataI
	//4.删除7天前的备份
	d ..DelGeneralCfgBackup()
}

/// Creator: tangzf
/// CreatDate: 2022-4-22
/// Description: 删除7天前的备份
/// Input: 
/// Return: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).DelGeneralCfgBackup(^TMP("SaveProModule"))
ClassMethod DelGeneralCfgBackup() As %String
{
	s DelDate=(+$h-7)
	k ^DHCBILLGeneralCfg(DelDate)
}

/// Creator: ZhYW  --zjb 20220427 配置点添加DicCode
/// CreatDate: 2022-02-28 
/// Description: 生成通用参数配置树产品线所需要的数据
/// Input: 
/// Output: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).BuildTreeToGeneralConfig()
ClassMethod BuildTreeToGeneralConfig(InputStr = "") As %String
{
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(InputStr)
	set index=0
	set o=[]
	set dicId=0
	while($o(^CF.BILL.COM.DictionaryI("IDicType","ProductLine",dicId))) {
		set dicId=$o(^CF.BILL.COM.DictionaryI("IDicType","ProductLine",dicId))
		set dicData=$g(^CF.BILL.COM.DictionaryD(dicId))
		continue:(dicData="")
		set dateFrom=$lg(dicData,7)
		set dateTo=$lg(dicData,8)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set dicCode=$lg(dicData,3)
		set dicDesc=$lg(dicData,4)
		set d={}
		set d.id=$i(index)
		set d.text=dicDesc
		set d.Parent="0"
		set p={}
		set p.id=dicId
		set p.code=dicCode
		set d.attributes=p
		set dc=[]
		set mIdx=0
		set modId=0
		set dicNum=0
		while($o(^CF.BILL.COM.ProModuleI("DicDode",dicCode,modId))) {
			set modId=$o(^CF.BILL.COM.ProModuleI("DicDode",dicCode,modId))
			set modData=$g(^CF.BILL.COM.ProModuleD(modId))
			set modCode=$lg(modData,3)
			set modDesc=$lg(modData,4)
			continue:(InputStr'="")&&(modDesc'[InputStr)&&($$ALPHAUP^SSUTIL4(modCode)'[tCodeAndDesc)
			set m={}
			set m.id=$i(index)
			set m.text=modDesc
			set m.Parent="1"
			set p={}
			set p.id=modId
			set p.CPDicCode=dicCode
			set p.CPModCode=modCode
			set m.code=modCode
			set modNum=0 //统计数量
			set ptId=0
			while($o(^CF.BILL.COM.CfgPointI("DicMod",dicCode,modCode,ptId))) {
				set ptId=$o(^CF.BILL.COM.CfgPointI("DicMod",dicCode,modCode,ptId))
				set ptData=$g(^CF.BILL.COM.CfgPointD(ptId))
				set CPLinkURL = $lg(ptData,6)
				continue:(CPLinkURL'="dhcbill.conf.general.basic.csp")
				set modNum=$i(modNum,1)
			}
			set m.text=modDesc_"("_modNum_")"
			set m.attributes=p
			do dc.%Push(m)
		}
		if dc.%Size()>0
		{
			s dicNum=dc.%Size()
		}
		if (dc.%Size()>0) {
			if InputStr=""
			{set d.state="closed"}
			else {set d.state="open"}
			set d.children=dc
			set d.text=dicDesc_"("_dicNum_")"
			set d.chiNum=dicNum
		}
		else
		{
			set d.text=dicDesc_"("_dicNum_")"
		}
		do o.%Push(d)
	}
	
	set stream=##class(%GlobalCharacterStream).%New()
	do o.%ToJSON(.stream)
	do stream.OutputToDevice()
	
	quit ""
}

/// Creator: zjb
/// CreatDate: 2022-11-09
/// Description: 生成通用参数配置树产品线所需要的数据
/// Input: 
/// Output: 
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).BuildTreeToGeneralConfigByProLine()
ClassMethod BuildTreeToGeneralConfigByProLine(InputStr = "") As %String
{
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(InputStr)
	set index=0
	set o=[]
	set PLRowid=0
	while($o(^CF.BILL.COM.ProLineD(PLRowid))) {
		set PLRowid=$o(^CF.BILL.COM.ProLineD(PLRowid))
		continue:$g(^CF.BILL.COM.ProLineD(PLRowid))=""
		s PLCode=$lg(^CF.BILL.COM.ProLineD(PLRowid),2)
		s PLName=$lg(^CF.BILL.COM.ProLineD(PLRowid),3)
		s VaildFlag=$lg(^CF.BILL.COM.ProLineD(PLRowid),4)
		set d={}
		set d.id=$i(index)
		set d.text=PLName
		set d.Parent="0"
		set p={}
		set p.id=PLRowid
		set p.code=PLCode
		set d.attributes=p
		set dc=[]
		set mIdx=0
		set modId=0
		set dicNum=0
		while($o(^CF.BILL.COM.ProModuleI("ProLineCode",PLCode,modId))) {
			set modId=$o(^CF.BILL.COM.ProModuleI("ProLineCode",PLCode,modId))
			set modData=$g(^CF.BILL.COM.ProModuleD(modId))
			set modCode=$lg(modData,4)
			set modDesc=$lg(modData,5)
			continue:(InputStr'="")&&(modDesc'[InputStr)&&($$ALPHAUP^SSUTIL4(modCode)'[tCodeAndDesc)
			set m={}
			set m.id=$i(index)
			set m.text=modDesc
			set m.Parent="1"
			set p={}
			set p.id=modId
			set p.CPDicCode=PLCode
			set p.CPModCode=modCode
			set m.code=modCode
			set modNum=0 //统计数量
			set ptId=0
			while($o(^CF.BILL.COM.CfgPointI("DicMod",PLCode,modCode,ptId))) {
				set ptId=$o(^CF.BILL.COM.CfgPointI("DicMod",PLCode,modCode,ptId))
				set ptData=$g(^CF.BILL.COM.CfgPointD(ptId))
				set CPLinkURL = $lg(ptData,6)
				continue:(CPLinkURL'="dhcbill.conf.general.basic.csp")
				set modNum=$i(modNum,1)
			}
			set m.text=modDesc_"("_modNum_")"
			set m.attributes=p
			do dc.%Push(m)
		}
		if dc.%Size()>0
		{
			s dicNum=dc.%Size()
		}
		if (dc.%Size()>0) {
			if InputStr=""
			{set d.state="closed"}
			else {set d.state="open"}
			set d.children=dc
			set d.text=PLName_"("_dicNum_")"
			set d.chiNum=dicNum
		}
		else
		{
			set d.text=PLName_"("_dicNum_")"
		}
		do o.%Push(d)
	}
	
	set stream=##class(%GlobalCharacterStream).%New()
	do o.%ToJSON(.stream)
	do stream.OutputToDevice()
	
	quit ""
}

/// Creator: zjb
/// CreatDate: 2022-04-26
/// Description: 查询配置界面URL为dhcbill.conf.general.basic.csp的配置点
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GeneralCfg","QryCfgPointAndCfgRelaData","OPCHRG","OPRefd","2","","","1")
Query QryCfgPointAndCfgRelaData(dicCode As %String, modCode As %String = "", HosID As %String = "", cfgDesc As %String, KeyCode = "", SerchType = "") As websys.Query(ROWSPEC = "id:%Integer,code:%String,text:%String,CRDRelaCode:%String,CRDTgtData:%String,CRDHosID:%String,DefaultValue:%String,CPRemark:%String,CPTgtDataSrc:%String,CPTgtDataSrcDicType:%String,CPDataViewType:%String,CPPublicFlag:%String")
{
}

ClassMethod QryCfgPointAndCfgRelaDataExecute(ByRef qHandle As %Binary, dicCode As %String, modCode As %String = "", HosID As %String = "", cfgDesc As %String, KeyCode = "", SerchType = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if dicCode="" quit $$$OK
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(KeyCode)
	;set ^TMPwzh("QryCfgPointAndCfgRelaData")=$lb(dicCode,modCode,HosID,cfgDesc)
	if SerchType="0"
	{
		set ALLModCode=""
		while($o(^CF.BILL.COM.ProModuleI("DicDode",dicCode,ALLModCode))) {
			set ALLModCode=$o(^CF.BILL.COM.ProModuleI("DicDode",dicCode,ALLModCode))
			set modData=$g(^CF.BILL.COM.ProModuleD(ALLModCode))
			set NewmodCode=$lg(modData,3)
			set ptId=0
			while($o(^CF.BILL.COM.CfgPointI("DicMod",dicCode,NewmodCode,ptId))) {
				set ptId=$o(^CF.BILL.COM.CfgPointI("DicMod",dicCode,NewmodCode,ptId))
				set ptData=$g(^CF.BILL.COM.CfgPointD(ptId))
				set ptDesc=$lg(ptData,5)
				set CPLinkURL = $lg(ptData,6)
				
				continue:(CPLinkURL'="dhcbill.conf.general.basic.csp")
				continue:((cfgDesc'="")&&(ptDesc'[cfgDesc))
				set CPTgtDataSrc = $lg(ptData,12) //数据类型，如果是字典，需要调字典
				set CPTgtDataSrcDicType =  $lg(ptData,14) //字典类型
				set CPRemark=$lg(ptData,17) //说明
				set CPDicCode = $lg(ptData,2)
				set CPModCode = $lg(ptData,3)
				set ptCode=$lg(ptData,4)
				set CRDRelaCode = CPDicCode_"."_CPModCode_"."_ptCode
				//set Relaid = 0
				//set CfgRelaID = $o(^CF.BILL.COM.CfgRelaDataI("RelaCode",CRDRelaCode,Relaid))  //2022/11/21 改获取公共配置值
				set CfgRelaID=0
				for {
					set CfgRelaID = $o(^CF.BILL.COM.CfgRelaDataI("IHospCode",CRDRelaCode,"COM",CfgRelaID)) 
					q:CfgRelaID=""
					q:($lg(^CF.BILL.COM.CfgRelaDataD(CfgRelaID),14)="1")
				}
				// 此处优化，CfgRelaID为空不再quit，后续数据全部设置为空 wzh 2022.06.01
				if (CfgRelaID=""){
					set CRDHosID = ""
					set CRDTgtData = ""
					set DefaultValue = "" //默认值
				}else{
					set CfgRelaData = ^CF.BILL.COM.CfgRelaDataD(CfgRelaID)
					set CRDHosID = $lg(CfgRelaData,5) // 医院id
					//continue:(CRDHosID'=HosID) //过滤医院
					set CRDTgtData = $lg(CfgRelaData,4) //配置点数值
					if (CPTgtDataSrc = "Dictionary"){
						set DicData = ^CF.BILL.COM.DictionaryD(CRDTgtData)
						set CRDTgtData= $lg(DicData,4)
					}
					set DefaultValue = "" //默认值
				}
				s CPDataViewType=$lg(ptData,10)
				s CPPublicFlag=$lg(ptData,27)
				continue:(KeyCode'="")&&(ptDesc'[KeyCode)&&($$ALPHAUP^SSUTIL4(ptCode)'[tCodeAndDesc)
				do OutputCfgPointList
			}
		}
	}
	else
	{
	 	set ptId=0
		while($o(^CF.BILL.COM.CfgPointI("DicMod",dicCode,modCode,ptId))) {
			set ptId=$o(^CF.BILL.COM.CfgPointI("DicMod",dicCode,modCode,ptId))
			set ptData=$g(^CF.BILL.COM.CfgPointD(ptId))
			set ptDesc=$lg(ptData,5)
			set CPLinkURL = $lg(ptData,6)
			
			continue:(CPLinkURL'="dhcbill.conf.general.basic.csp")
			continue:((cfgDesc'="")&&(ptDesc'[cfgDesc))
			set CPTgtDataSrc = $lg(ptData,12) //数据类型，如果是字典，需要调字典
			set CPTgtDataSrcDicType =  $lg(ptData,14) //字典类型
			set CPRemark=$lg(ptData,17) //说明
			set CPDicCode = $lg(ptData,2)
			set CPModCode = $lg(ptData,3)
			set ptCode=$lg(ptData,4)
			set CRDRelaCode = CPDicCode_"."_CPModCode_"."_ptCode
			set Relaid = 0
			b //111
			//set CfgRelaID = $o(^CF.BILL.COM.CfgRelaDataI("RelaCode",CRDRelaCode,Relaid))  //2022/11/21 改获取公共配置值
			set CfgRelaID=""
			for {
				set CfgRelaID = $o(^CF.BILL.COM.CfgRelaDataI("IHospCode",CRDRelaCode,"COM",CfgRelaID)) 
				q:CfgRelaID=""
				q:($lg(^CF.BILL.COM.CfgRelaDataD(CfgRelaID),14)="1")
			}
			b //222
			// 此处优化，CfgRelaID为空不再quit，后续数据全部设置为空 wzh 2022.06.01
			if (CfgRelaID=""){
				set CRDHosID = ""
				set CRDTgtData = ""
				set DefaultValue = "" //默认值
			}else{
				set CfgRelaData = ^CF.BILL.COM.CfgRelaDataD(CfgRelaID)
				set CRDHosID = $lg(CfgRelaData,5) // 医院id
				//continue:(CRDHosID'=HosID) //过滤医院
				set CRDTgtData = $lg(CfgRelaData,4) //配置点数值
				if (CPTgtDataSrc = "Dictionary"){
					set DicData = ^CF.BILL.COM.DictionaryD(CRDTgtData)
					set CRDTgtData= $lg(DicData,4)
				}
				set DefaultValue = "" //默认值
			}
			b //333
			s CPDataViewType=$lg(ptData,10)
			s CPPublicFlag=$lg(ptData,27)
			continue:(KeyCode'="")&&(ptDesc'[KeyCode)&&($$ALPHAUP^SSUTIL4(ptCode)'[tCodeAndDesc)
			do OutputCfgPointList
		}
	}
	quit $$$OK
	
OutputCfgPointList
	set Data=$lb(ptId,ptCode,ptDesc,CRDRelaCode,CRDTgtData,CRDHosID,DefaultValue,CPRemark,CPTgtDataSrc,CPTgtDataSrcDicType,CPDataViewType,CPPublicFlag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: zjb
/// CreatDate: 2022-04-26
/// Description: 根据rowid查询CfgPoint
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GeneralCfg","QryCfgPointByRowid",29)
Query QryCfgPointByRowid(Rowid As %String) As websys.Query(ROWSPEC = "CfgRelaID,ptCode,ptDesc,CRDTgtData,CPCollDataSrcViewType,CRDRelaCode,CPCollDataSrcDicType,srcClassName,srcQueryName,CPRemark")
{
}

ClassMethod QryCfgPointByRowidExecute(ByRef qHandle As %Binary, Rowid As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if (Rowid="") quit $$$OK

    set ptId = Rowid
	set ptData=^CF.BILL.COM.CfgPointD(ptId)
	set ptDesc=$lg(ptData,5)
	set CPLinkURL = $lg(ptData,6)
	set CPDicCode = $lg(ptData,2)
	set CPModCode = $lg(ptData,3)
	set ptCode=$lg(ptData,4)
	set CPCollDataSrc = $lg(ptData,7) //数据类型，如果是字典，需要调字典
	set CPCollDataSrcQry = $lg(ptData,8)
	set CPCollDataSrcDicType =  $lg(ptData,9) //字典类型
	set CPCollDataSrcViewType = $lg(ptData,10) 
	set CPRemark=$lg(ptData,17) //说明
	if (CPCollDataSrcDicType="") {
		set srcClassName=$p(CPCollDataSrcQry,"||",1)
		set srcQueryName=$p(CPCollDataSrcQry,"||",2)
	}else {
		set srcClassName="BILL.CFG.COM.DictionaryCtl"
		set srcQueryName="QryDicListByType"
	}
	set CRDRelaCode = CPDicCode_"."_CPModCode_"."_ptCode
	set Relaid = 0
	set CfgRelaID = $o(^CF.BILL.COM.CfgRelaDataI("RelaCode",CRDRelaCode,Relaid))
	set CfgRelaData = ^CF.BILL.COM.CfgRelaDataD(CfgRelaID)
	set CRDTgtData = $lg(CfgRelaData,4) //配置点数值
	set CRDHosID = $lg(CfgRelaData,5) //医院ID
	set CRDTgtData = $lg(CfgRelaData,4) //配置点数值
	if (CPCollDataSrc = "Dictionary"){
		set Dicrow = $o(^CF.BILL.COM.DictionaryI("ITypeValue",CPCollDataSrcDicType,CRDTgtData,""))
		set DicData = ^CF.BILL.COM.DictionaryD(Dicrow)
		set CRDTgtData= $lg(DicData,4)
	}	
	set DefaultValue = "" //默认值
	do OutputCfgPointList
	quit $$$OK
	
OutputCfgPointList
	set Data=$lb(CfgRelaID,ptCode,ptDesc,CRDTgtData,CPCollDataSrcViewType,CRDRelaCode,CPCollDataSrcDicType,srcClassName,srcQueryName,CPRemark)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: zjb
/// CreatDate: 2022-05-05
/// Description: 根据rowid查询CfgRalaList
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GeneralCfg","QryCfgRalaHosByRalaCode","OPCHRG.OPChg.CSZJB")
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GeneralCfg","QryCfgRalaHosByRalaCode","OPCHRG.OPRefd.GHTF")
Query QryCfgRalaHosByRalaCode(RalaCode As %String) As websys.Query(ROWSPEC = "RalaRowid,CRDHospDR,HOSPDesc,CRDTgtData,EffectiveDate,ExpirationDate,CRDTgtDataDesc")
{
}

ClassMethod QryCfgRalaHosByRalaCodeExecute(ByRef qHandle As %Binary, RalaCode As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if (RalaCode="") quit $$$OK
    //^CF.BILL.COM.CfgPointI("DMPCode",CPDicCode:Exact,CPModCode:Exact,CPCode:Exact,ID)
	//^CF.BILL.COM.CfgRelaDataI("RelaCode",CRDRelaCode:Exact,ID)
	//^CT("HOSP",{HOSP_RowId})
	set CPDicCode = $p(RalaCode,".",1)
	set CPModCode = $p(RalaCode,".",2)
	set CPCode = $p(RalaCode,".",3)
	set PCRowid = $o(^CF.BILL.COM.CfgPointI("DMPCode",CPDicCode,CPModCode,CPCode,""))
	set CfgPointData = $g(^CF.BILL.COM.CfgPointD(PCRowid))
	set CPCollDataSrc = $lg(CfgPointData,12) //数据类型，如果是字典，需要调字典
	set CPCollDataSrcDicType =  $lg(CfgPointData,14) //字典类型
	set RalaRowid = ""
	b //123
    while ($o(^CF.BILL.COM.CfgRelaDataI("RelaCode",RalaCode,RalaRowid))) {
		set RalaRowid = $o(^CF.BILL.COM.CfgRelaDataI("RelaCode",RalaCode,RalaRowid))
		set RalaData = ^CF.BILL.COM.CfgRelaDataD(RalaRowid)
		set vaildFlag = $lg(RalaData,14)	; 有效标志
		continue:(vaildFlag = 0)
		set CRDTgtData = $lg(RalaData,4) //配置值
		set CRDTgtDataDesc=$lg(RalaData,7) //目标数据描述
		b //222
#;		if (CPCollDataSrc = "Dictionary") {
#;			//set Dicrow = $o(^CF.BILL.COM.DictionaryI("ITypeValue",CPCollDataSrcDicType,CRDTgtData,""))
#;			
#;			set DicData = $g(^CF.BILL.COM.DictionaryD(CRDTgtData))
#;			if (DicData'=""){
#;				set CRDTgtData= $lg(DicData,4)
#;			}
#;			b //333
#;		}
		set CRDHospDR=$lg(RalaData,5) //院区代码
		continue:((CRDHospDR="")||(CRDHospDR = "COM"))	; 过滤公用数据 2022.05.31 wzh
		set HOSPDesc=$p(^CT("HOSP",CRDHospDR),"^",2) //医院
		
		set EffectiveDate="" //生效日期
		set ExpirationDate="" //失效日期
		do OutputCfgRalaList
	}
	
	quit $$$OK
	
OutputCfgRalaList
	set Data=$lb(RalaRowid,CRDHospDR,HOSPDesc,CRDTgtData,EffectiveDate,ExpirationDate,CRDTgtDataDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: wzh
/// CreatDate: 2022.12.11
/// Description: 校验权限（产品线、模块、配置点）
/// Input: 	CheckType		|	产品线:1	模块:2	配置点:3		
/// 		CheckID			|	校验对象的ID
/// Return: 1：有权限，0：无权限，2：只读
/// Debug: w ##class(BILL.CFG.COM.GeneralCfg).CheckLimit("1","1")
ClassMethod CheckLimit(CheckType As %String, CheckID As %String) As %String
{
	/*
		时间：2023.01.07
		优化：1.不再使用通用配置的通用方法调用判断参数，直接使用配置点索引判断
		      2.由于配置点存储的是id，原有判断逻辑更改，逻辑如下：
		      	2.1、针对于产品线判断，直接通过索引判断是否存在
		      	2.2、针对于模块的判断，直接通过索引判断是否存在
		      	2.3、针对于配置点的判断，通过取出配置的数据判断配置点
		      	2.4、原有上下级判断优化。CheckType=1只判断产品线，不再判断下级
		————————————————————————————————————————————————————————————————————————————————————————————————
		时间：2023.01.05
		内容：1.入参调整，仅需要类型（产品线、模块、配置点）和id，安全组和用户使用session同时判断
			  2.判断是否拥有权限时，应先判断安全组、用户下是否被授权，如果授权则返回1，否则继续3
			  3.判断上级是否被授权，如果被授权则返回1，否则继续4
			  4.判断下级是否被授权，如果被授权则返回1，否则返回0
	*/
	// 方法保护
	quit:((CheckType = "")||(CheckID = "")) 0
	set (relaCode,srcData, flag) = ""
	
	// demo group用户拥有最高权限
	if (%session.Get("LOGON.GROUPID") = 1){
		quit 1
	}
	do SetID
	if (CheckType=1){
		do CheckProLine
	}elseif (CheckType=2){
		do CheckProModule
		if (flag = 0){
			do CheckProLine
		}
		if (flag = 0){
			do CheckCfgPoint
		}
	}elseif (CheckType=3){
		do CheckCfgPoint
		if (flag = 0){
			do CheckProModule
		}
		if (flag = 0){
			do CheckProLine
		}
	}

	quit $s(flag=1:1,1:0)
SetID
	set (proDr, modDr, cfgPDr) = ""
	if (CheckType = 1){
		set proDr = CheckID
		set modDr = ""
		set cfgPDr = ""
	}elseif (CheckType = 2){
		set proDr = $lg(^CF.BILL.COM.ProModuleD(CheckID),2)
		set modDr = CheckID
		set cfgPDr = ""
	}elseif (CheckType = 3){
		set proCode = $lg(^CF.BILL.COM.CfgPointD(CheckID),2)
		set proDr = $o(^CF.BILL.COM.ProLineI("PLCode",proCode,""))
		set modCode = $lg(^CF.BILL.COM.CfgPointD(CheckID),3)
		set modDr = $o(^CF.BILL.COM.ProModuleI("PMCode",modCode,""))
		set cfgPDr = CheckID
	}
	quit
SetParam(mode,type)
	set relaCode = "SYSMGT.AuthMgt."_
					$CASE(mode,
					1:"AQZ", 
					2:"YH")_
					$CASE(type,
					1:"CPX", 
					2:"MK",
					3:"PZD")_
					"SQ"
	set srcData = $CASE(mode,
					1:%session.Get("LOGON.GROUPID"),
					2:%session.Get("LOGON.USERID"))	
	quit
CheckProLine
	do SetParam(1,1)
	set rtn = $d(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,relaCode,%session.Get("LOGON.HOSPID"),srcData,proDr))
	if (+rtn = 0){
		do SetParam(2,1)
		set rtn = $d(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,relaCode,%session.Get("LOGON.HOSPID"),srcData,proDr))
	}
	set:(+rtn > 0) flag = 1
	quit
CheckProModule
	do SetParam(1,2)
	set rtn = $d(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,relaCode,%session.Get("LOGON.HOSPID"),srcData,modDr))
	if (+rtn = 0){
		do SetParam(2,2)
		set rtn = $d(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,relaCode,%session.Get("LOGON.HOSPID"),srcData,modDr))
	}
	set:(+rtn > 0) flag = 1
	quit
CheckCfgPoint
	if (cfgPDr = ""){
		do SetParam(1,3)
		for{
			set cfgPDr = $o(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,relaCode,%session.Get("LOGON.HOSPID"),srcData,cfgPDr))
			quit:(cfgPDr = "")
			set proCode = $lg(^CF.BILL.COM.CfgPointD(cfgPDr),2)
			set modCode = $lg(^CF.BILL.COM.CfgPointD(cfgPDr),3)
			set modDrTmp = $o(^CF.BILL.COM.ProModuleI("Code",proCode,modCode,""))
			if (modDrTmp = modDr){
				set cfgrelaDr = $o(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,relaCode,%session.Get("LOGON.HOSPID"),srcData,cfgPDr,""))
				set readFlag = $lg(^CF.BILL.COM.CfgRelaDataD(cfgrelaDr))
				set flag = $s((readFlag="Y"):2,1:1)
				quit
			}
		}
	}else{
		do SetParam(1,3)
		set rtn = $d(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,relaCode,%session.Get("LOGON.HOSPID"),srcData,cfgPDr))
		if (+rtn = 0){
			do SetParam(2,3)
			set rtn = $d(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,relaCode,%session.Get("LOGON.HOSPID"),srcData,cfgPDr))
		}
		if (+rtn > 0){
			set cfgrelaDr = $o(^CF.BILL.COM.CfgRelaDataI("IRelaDataExist",1,relaCode,%session.Get("LOGON.HOSPID"),srcData,cfgPDr,""))
			set readFlag = $lg(^CF.BILL.COM.CfgRelaDataD(cfgrelaDr))
			set flag = $s((readFlag="Y"):2,1:1)
		}
	}
	quit
}

/// Creator: wzh
/// CreatDate: 2023.03.11
/// Description: 获取医保字典的数据
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.GeneralCfg","QryINSUDic","NormalConfig",2)
Query QryINSUDic(dicType As %String, hospId As %String) As websys.Query(ROWSPEC = "id:%String,code:%String:代码,text:%String:描述")
{
}

ClassMethod QryINSUDicExecute(ByRef qHandle As %Binary, dicType As %String, hospId As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
 	// 方法保护
 	quit:((dicType="")||(hospId="")) $$$OK
 	
 	set rset=##class(%ResultSet).%New("web.INSUDicDataCom:QueryDicByTypeOrCodeDesc")
	set rs=rset.Execute(dicType, hospId)
	while (rset.Next()) {
		set dicId = $g(rset.Data("id"))
		set code = $g(rset.Data("cCode"))
		set desc = $g(rset.Data("cDesc"))
		do OutputDicList
	}
	
	quit $$$OK
	
OutputDicList
	set Data=$lb(dicId,code,desc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator：wzh
/// CreatDate: 2023.03.11
/// Description: 清除通用配置的配置数据
/// Debug: do ##class(BILL.CFG.COM.GeneralCfg).ClearCfgRelaData()  
ClassMethod ClearCfgRelaData()
{
	/*
		根据配置点的清除数据标志来决定是否清除数据
	*/
	set cfgpointDr = 0
	for{
		set cfgpointDr = $o(^CF.BILL.COM.CfgPointD(cfgpointDr))
		quit:(cfgpointDr="")
		set flag = $lg(^CF.BILL.COM.CfgPointD(cfgpointDr),15)
		set plCode = $lg(^CF.BILL.COM.CfgPointD(cfgpointDr),2)
		set modCode = $lg(^CF.BILL.COM.CfgPointD(cfgpointDr),3)
		set cfgCode = $lg(^CF.BILL.COM.CfgPointD(cfgpointDr),4)
		set relacode = plCode_"."_modCode_"."_cfgCode
		// flag=1不清理数据
		if (flag = 1){
			do DeleteInvalidRelaData
		}else{
			do DeleteRelaData
		}
	}
	
	
DeleteInvalidRelaData
	&SQL(
		DELETE FROM CF_BILL_COM.CfgRelaData 
		WHERE CRDRelaCode = :relacode and CRDVaildFlag = "0"
	)
	quit
DeleteRelaData
	&SQL(
		DELETE FROM CF_BILL_COM.CfgRelaData 
		WHERE CRDRelaCode = :relacode
	)
	quit
}

/// Creator：wzh
/// CreatDate: 2023.04.02
/// Description: 校验密码
/// Return：1：校验通过 0：校验不通过
/// Debug: do ##class(BILL.CFG.COM.GeneralCfg).CheckPassword("")  
ClassMethod CheckPassword(Password As %String) As %String
{
	set rtn = 0
	set TmpPassWard = $$ALPHAUP^SSUTIL4($reverse($zd(+$h,3)))
	
	set:(TmpPassWard=Password) rtn=1
	
	quit rtn
}

/// Creator：wzh
/// CreatDate: 2023.04.23
/// Description: 根据类型导出不同配置点
/// 	input：Type：类型 1:产品线	2:模块	3:配置点
/// Return：
/// d ##class(%ResultSet).RunQuery("BILL.CFG.COM.GeneralCfg","ExportPointData",1,14)
Query ExportPointData(Type As %String, ID As %String) As websys.Query(ROWSPEC = "ID,CPDicCode:%String:产品线编码,CPModCode:%String:模块编码,CPCode:%String:配置点编码,CPDesc:%String:名称,CPLinkURL:%String:配置的URL,CPCollDataSrc:%String:源数据类型,CPCollDataSrcQry:%String:源数据Query,CPCollDataSrcDicType:%String:源数据字典,CPDataViewType:%String:数据展示形式,CPDataMulFlag:%String:是否支持多选,CPTgtDataSrc:%String:目标数据类型,CPTgtDataSrcQry:%String:目标数据Query,CPTgtDataSrcDicType:%String:目标数据字典,CPIsDeleteFlag:%String:清数据标志,CPCollDataSrcQryDicDR:%String:源数据Query字典表指针,CPRemark:%String:配置点说明,CPCtrlLevelDicCode:%String:控制级别,CPUpdLevelDicCode:%String:修改级别,CPActiveDateFrom:%String:生效时间,CPActiveDateTo:%String:失效时间,CPIsReleased:%String:发布状态,CPTgtDataSrcQryDicDR:%String:目标数据Query字典表指针,CPCtrlLevelRemark:%String:提示内容,CPCtrlType:%String:控制类型,CPResultType:%String:结果类型,CPPublicFlag:%String:公用标志") [ SqlProc ]
{
}

ClassMethod ExportPointDataExecute(ByRef qHandle As %Binary, Type As %String, ID As %String) As %Status
{
	Set repid = $I(^CacheTemp)
	Set qHandle = $lb(0,repid,0)
	s ind = 1
	
	// 方法保护
	quit:((Type="")||(ID="")) $$$OK
	
	if (Type = "1"){
		set proLineCode = $lg(^CF.BILL.COM.ProLineD(ID),2)
		set proModuleCode = ""
		for{
			set proModuleCode = $o(^CF.BILL.COM.CfgPointI("DicMod",proLineCode,proModuleCode))
			quit:(proModuleCode="")
			set id = ""
			for{
				set id = $o(^CF.BILL.COM.CfgPointI("DicMod",proLineCode,proModuleCode,id))
				quit:(id="")
				do BuildData(id)
			}
		}
	}elseif(Type = "2"){
		set proLineCode = $lg(^CF.BILL.COM.ProModuleD(ID),3)
		set proModuleCode = $lg(^CF.BILL.COM.ProModuleD(ID),4)
		set id = ""
		for{
			set id = $o(^CF.BILL.COM.CfgPointI("DicMod",proLineCode,proModuleCode,id))
			quit:(id="")
			do BuildData(id)
		}
	}elseif(Type = "3"){
		do BuildData(ID)
	}
	
	
	Quit $$$OK
BuildData(id)
	set Data = ^CF.BILL.COM.CfgPointD(id)
	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind + 1
 	quit
}

/// Creator：wzh
/// CreatDate: 2023.04.24
/// Description: 导入配置点
/// 入参说明：RowDataInfo  --> 导入模板的数据拼串
///           UserDr       --> 操作员Dr
///           ErrMsg       --> 错误信息(出参)
///           ExtStr       --> 备用字符串
/// Return：
/// Debug: do ##class(BILL.CFG.COM.GeneralCfg).ImportDicdataByExcel("^wzh wzh	wzh^","","","") 
ClassMethod ImportDicdataByExcel(RowDataInfo As %String, UserDr As %String, ByRef ErrMsg As %String, ExtStr As %String) As %String
{
	s rtn = "0"
	
	/*
		导入逻辑：
		1.判断代码:是否为空,是则退出;是否存在,是则退出
		2.判断所有数据:不符合数据格式则退出
		3.获取其它数据:根据当前数据,通过字典获取指针
	*/
	set CPDicCode = ..FormatParam($p(RowDataInfo, "^", 2))   // 产品线编码
	set CPModCode = ..FormatParam($p(RowDataInfo, "^", 3))   // 模块编码
	set CPCode = ..FormatParam($p(RowDataInfo, "^", 4))   // 配置点编码
	
	// 1.判断代码:是否为空
	set:(CPDicCode="") ErrMsg = "产品线代码不能为空"
	set:(CPModCode="") ErrMsg = "模块代码不能为空"
	set:(CPCode="") ErrMsg = "配置点代码不能为空"
	quit:((CPDicCode="")||(CPModCode="")||(CPCode="")) rtn
	
	// 1.判断代码:是否存在
	set id = $o(^CF.BILL.COM.CfgPointI("DMPCode",CPDicCode,CPModCode,CPCode,""))
	set:(+id'=0) ErrMsg="该配置点已存在"
	quit:(+id'=0)
	
	// 名称不能为空
	set CPDesc = ..FormatParam($p(RowDataInfo, "^", 5))   // 名称
	set:(CPDicCode="") ErrMsg = "名称不能为空"
	quit:(CPDicCode="") rtn
	
	// 以下配置数据必须在字典中存在
	set codeFlag = 1
	set CPIsReleased = ..FormatParam($p(RowDataInfo, "^", 22))   // 发布状态
	do CheckByDicCode("CPIsReleased",CPIsReleased)
	quit:(codeFlag=0) rtn
	set CPPublicFlag = ..FormatParam($p(RowDataInfo, "^", 27))   // 公用标志
	do CheckByDicCode("CPPublicFlag",CPPublicFlag)
	quit:(codeFlag=0) rtn
	set CPResultType = ..FormatParam($p(RowDataInfo, "^", 26))   // 结果类型
	do CheckByDicCode("CPResultType",CPResultType)
	quit:(codeFlag=0) rtn
	set CPCtrlLevelDicCode = ..FormatParam($p(RowDataInfo, "^", 18))   // 控制级别
	do:(CPCtrlLevelDicCode'="") CheckByDicCode("CPCtrlLevel",CPCtrlLevelDicCode)
	quit:(codeFlag=0) rtn
	set CPUpdLevelDicCode = ..FormatParam($p(RowDataInfo, "^", 19))   // 修改级别
	do:(CPUpdLevelDicCode'="") CheckByDicCode("CPUpdLevel",CPUpdLevelDicCode)
	quit:(codeFlag=0) rtn
	set CPCtrlType = ..FormatParam($p(RowDataInfo, "^", 25))   // 控制类型
	do:(CPCtrlType'="") CheckByDicCode("CPCtrlType",CPCtrlType)
	quit:(codeFlag=0) rtn
	set CPLinkURL = ..FormatParam($p(RowDataInfo, "^", 6))   // 配置的URL
	do CheckByDicCode("URL",CPLinkURL)
	quit:(codeFlag=0) rtn
	set CPDataViewType = ..FormatParam($p(RowDataInfo, "^", 10))   // 数据展示形式
	do:(CPDataViewType'="datagrid") CheckByDicCode("CPDataViewType",CPDataViewType)
	quit:(codeFlag=0) rtn
	set CPCollDataSrc = ..FormatParam($p(RowDataInfo, "^", 7))   // 源数据类型
	do:(CPCollDataSrc'="") CheckByDicCode("CPDataSrc",CPCollDataSrc)
	quit:(codeFlag=0) rtn
	set CPTgtDataSrc = ..FormatParam($p(RowDataInfo, "^", 12))   // 目标数据类型
	do:(CPTgtDataSrc'="") CheckByDicCode("CPDataSrc",CPTgtDataSrc)
	quit:(codeFlag=0) rtn
	set CPCollDataSrcQry = ..FormatParam($p(RowDataInfo, "^", 8))   // 源数据Query
	do:(CPCollDataSrcQry'="") CheckByDicCode("QUERY",CPCollDataSrcQry)
	quit:(codeFlag=0) rtn
	set CPTgtDataSrcQry = ..FormatParam($p(RowDataInfo, "^", 13))   // 目标数据Query
	do:(CPTgtDataSrcQry'="") CheckByDicCode("QUERY",CPTgtDataSrcQry)
	quit:(codeFlag=0) rtn
	set CPCollDataSrcDicType = ..FormatParam($p(RowDataInfo, "^", 9))   // 源数据字典
	do:(CPCollDataSrcDicType'="") CheckByDicCode("SYS",CPCollDataSrcDicType)
	quit:(codeFlag=0) rtn
	set CPTgtDataSrcDicType = ..FormatParam($p(RowDataInfo, "^", 14))   // 目标数据字典
	do:(CPTgtDataSrcDicType'="") CheckByDicCode("SYS",CPTgtDataSrcDicType)
	quit:(codeFlag=0) rtn
	
	// 指针获取需要关联.只有query不为空的情况下才取
	set (CPCollDataSrcQryDicDR,CPTgtDataSrcQryDicDR) = ""
	set:(CPCollDataSrcQry'="") CPCollDataSrcQryDicDR = $o(^CF.BILL.COM.DictionaryI("ITypeValue","QUERY",CPCollDataSrcQry,""))   // 源数据Query字典表指针
	set:(CPTgtDataSrcQry'="") CPTgtDataSrcQryDicDR = $o(^CF.BILL.COM.DictionaryI("ITypeValue","QUERY",CPTgtDataSrcQry,""))   // 目标数据Query字典表指针
	
	// 固有值数据.需要判断是否在范围内
	set CPDataMulFlag = ..FormatParam($p(RowDataInfo, "^", 11))   // 是否支持多选
	set:("^^0^1^"'["^"_CPDataMulFlag_"^") ErrMsg = "是否支持多选数值异常,应为空/0/1"
	quit:("^^0^1^"'["^"_CPDataMulFlag_"^") rtn
	set CPIsDeleteFlag = ..FormatParam($p(RowDataInfo, "^", 15))   // 清数据标志
	set:("^^1^"'["^"_CPIsDeleteFlag_"^") ErrMsg = "清数据标志数值异常,应为空/1"
	quit:("^^1^"'["^"_CPIsDeleteFlag_"^") rtn
	
	// 时间做转换,确保格式正确
	set CPActiveDateFrom = $p(RowDataInfo, "^", 20)   // 生效时间
	set:(+CPActiveDateFrom'=0) CPActiveDateFrom = ##class(websys.Conversions).DateHtmlToLogical(CPActiveDateFrom)
	set CPActiveDateTo = $p(RowDataInfo, "^", 21)   // 失效时间
	set:(+CPActiveDateTo'=0) CPActiveDateTo = ##class(websys.Conversions).DateHtmlToLogical(CPActiveDateTo)
	
	set CPRemark = $p(RowDataInfo, "^", 17)   // 配置点说明
	set CPCtrlLevelRemark = $p(RowDataInfo, "^", 24)   // 提示内容
	
	set objCfgPoint = ##class(CF.BILL.COM.CfgPoint).%New()
	set objCfgPoint.CPDicCode = CPDicCode
	set objCfgPoint.CPModCode = CPModCode
	set objCfgPoint.CPCode = CPCode
	set objCfgPoint.CPDesc = CPDesc
	set objCfgPoint.CPLinkURL = CPLinkURL
	set objCfgPoint.CPCollDataSrc = CPCollDataSrc
	set objCfgPoint.CPCollDataSrcQry = CPCollDataSrcQry
	set objCfgPoint.CPCollDataSrcDicType = CPCollDataSrcDicType
	set objCfgPoint.CPDataViewType = CPDataViewType
	set objCfgPoint.CPDataMulFlag = CPDataMulFlag
	set objCfgPoint.CPTgtDataSrc = CPTgtDataSrc
	set objCfgPoint.CPTgtDataSrcQry = CPTgtDataSrcQry
	set objCfgPoint.CPTgtDataSrcDicType = CPTgtDataSrcDicType
	set objCfgPoint.CPIsDeleteFlag = CPIsDeleteFlag
	set objCfgPoint.CPCollDataSrcQryDicDR = CPCollDataSrcQryDicDR
	set objCfgPoint.CPRemark = CPRemark
	set objCfgPoint.CPCtrlLevelDicCode = CPCtrlLevelDicCode
	set objCfgPoint.CPUpdLevelDicCode = CPUpdLevelDicCode
	set objCfgPoint.CPActiveDateFrom = CPActiveDateFrom
	set objCfgPoint.CPActiveDateTo = CPActiveDateTo
	set objCfgPoint.CPIsReleased = CPIsReleased
	set objCfgPoint.CPTgtDataSrcQryDicDR = CPTgtDataSrcQryDicDR
	set objCfgPoint.CPCtrlLevelRemark = CPCtrlLevelRemark
	set objCfgPoint.CPCtrlType = CPCtrlType
	set objCfgPoint.CPResultType = CPResultType
	set objCfgPoint.CPPublicFlag = CPPublicFlag

    ///保存数据
    set sc = objCfgPoint.%Save()
    i $System.Status.IsError(sc) d
    .;$system.Status.GetErrorText(sc)
    .s rtn = "0"
    e  d
    .s rtn = objCfgPoint.%Id()

	q rtn
CheckByDicCode(type,value)
	if (value=""){
		set codeFlag = 0
	}else{
		set:('$d(^CF.BILL.COM.DictionaryI("ITypeValue",type,value))) codeFlag = 0
	}
	set:(codeFlag=0) ErrMsg = value_" 在字典中不存在。请维护 "_type_" 数据！"
	quit
}

/// Creator：wzh
/// CreatDate: 2023.04.24
/// Description: 数据去掉空格、tab等数据
/// Param  --> 需要格式的数据
/// Debug: do ##class(BILL.CFG.COM.GeneralCfg).FormatParam("") 
ClassMethod FormatParam(Param As %String) As %String
{
	set Param = $tr(Param," ","")
	set Param = $tr(Param,$c(9),"")
	quit Param
}

}

/// 名称: web.DHCBillCommon.cls
/// 描述: 计费组公共函数类
/// 编写者: ZhYW
/// 编写日期: 2018-02-09
Class web.DHCBillCommon Extends BILL.COM.Abstract
{

/// Creator: Lid
/// CreatDate: 2015-01-05
/// Description: 获取单位转换系数(考虑协议包装情况)
/// Debug: w ##class(web.DHCBillCommon).GetUomConvFactor("11846||1", "924||2")
ClassMethod GetUomConvFactor(arcim As %String, oeitm As %String) As %String
{
	set inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
	quit:(inci="") 1	               //没有库存项，就没有转换关系，默认为1
	
	set adm=$p(^OEORD(+oeitm),"^",1)
	set admType=$p(^PAADM(adm),"^",2)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	
	set billUom=""
	set baseUom=$p(^INCI(inci,1),"^",10)
	set isCNMedItem=##class(web.DHCDocOrderCommon).IsCNMedItem(arcim, hospDR)
	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(arcim, 0)
	if (ordCateType="R") {
		if (+isCNMedItem=0) {
			if (admType="I") {
				set billUom=$p($g(^INCI(inci,1)),"^",13)
			}else {
				set billUom=$p($g(^INCI(inci,1)),"^",12)
			}
		}else {
			set billUom=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),2)),"^",3)   //药学项基本单位
			set baseUom=billUom   //1:n时，显示药学项基本单位，医嘱表存的为药学项基本单位对应的数量，故这里库存项基本单位与药学项基本单位一致
		}
	}else {
		set billUom=$p(^ARCIM(+arcim,+$p(arcim,"||",2),8),"^",14)
	}
	
	set packQty=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),9)),"^",4)
	if (+packQty'=0) {
		set packUOMDR=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),"DHC")),"^",13)	  //OEORI_PackUOM_DR(OE_OrdItemExt)
		if (+packUOMDR'=0) {
			set billUom=packUOMDR	  //协议包装不为空时，根据协议包装单位取转换系数
		}
	}

	quit:((+baseUom=0)||(+billUom=0)) 1

	quit:(ordCateType="R") ##class(PHA.FACE.OUT.Com).UOMFac(billUom, baseUom)
	
	set convDr=$o(^CT("CTCF",0,"UOM",billUom,baseUom,""))
	quit:(convDr="") 1
	
	set conv=+$p(^CT("CTCF",convDr),"^",3)
	quit:(+conv=0) 1
	
	quit conv
}

/// Creator: Lid
/// CreatDate: 2015-01-05
/// Description: 获取整包装单位(考虑协议包装情况)
/// Debug: w ##class(web.DHCBillCommon).GetPackUom("11769||1", "173||3")
ClassMethod GetPackUom(arcim As %String, oeitm As %String) As %String
{
	set adm=$p(^OEORD(+oeitm),"^",1)
	set admType=$p(^PAADM(adm),"^",2)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	
	set billUom=""
	set isCNMedItem=##class(web.DHCDocOrderCommon).IsCNMedItem(arcim, hospDR)
	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(arcim, 0)
	if (ordCateType="R") {
		if (+isCNMedItem=0) {
			set inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
			if (admType="I") {
				set billUom=$s((inci'=""):$p($g(^INCI(inci,1)),"^",13),1:"")
			}else {
				set billUom=$s((inci'=""):$p($g(^INCI(inci,1)),"^",12),1:"")
			}
		}else {
			set billUom=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),2)),"^",3)   //药学项基本单位
		}
	}else {
		set billUom=$p(^ARCIM(+arcim,+$p(arcim,"||",2),8),"^",14)
	}
	
	set packQty=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),9)),"^",4)
	if (+packQty'=0) {
		set packUOMDR=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),"DHC")),"^",13)	   //OEORI_PackUOM_DR(OE_OrdItemExt)
		if (+packUOMDR'=0) {
			set billUom=packUOMDR	//协议包装不为空时，根据协议包装单位
		}
	}
	set packUOM=$s((+billUom'=0):$p($g(^CT("UOM",billUom)),"^",2),1:"")
	
	quit packUOM
}

/// Creator: ZhYW
/// CreatDate: 2018-02-09
/// Description: 格式化发票号码
///              Global定义:^TMP(note1,note2,job,guser,no)
/// Input: global: global名称, note1:global第一个节点, note2:global第二个节点...
/// Return: 
/// Other: 规定前缀都是字母
/// Debug: w ##class(web.DHCBillCommon).GetInvNoInfo("^TMP", "IPBILL", 333, 222, "NORRCPTNO")
ClassMethod GetInvNoInfo(global As %String, note1 As %String, note2 As %String, note3 As %String, note4 As %String) As %String
{
	set invNoInfo=""
	set newFlag=0
	set startNo=""
	set endNo=""
	set num=0
	set myNo=0
	for  set myNo=$o(@global@(note1,note2,note3,note4,myNo)) quit:(myNo="")  do
	.set num=$i(num)
	.set invTmp=myNo
	.set myCurPrtNoLength=$l(myNo)
	.set myCurPreABCINfo=..GetINVPreABCInfo(myNo)
	.set myCurPrePrtNo=$p(myCurPreABCINfo,"^",1)
	.set myCurPreABC=$p(myCurPreABCINfo,"^",2)
	.if ((num=1)||(newFlag=1))  do
	..set newFlag=0
	..set startNo=invTmp
	..set endNo=invTmp
	..set lenReceipNo=$l(startNo)
	.set myNextPrtNo=$o(@global@(note1,note2,note3,note4,myNo))
	.set myNextPNoLength=$l(myNextPrtNo)
	.set myNextPreABCINfo=..GetINVPreABCInfo(myNextPrtNo)
	.set myNextPrePrtNo=$p(myNextPreABCINfo,"^",1)
	.set myNextPreABC=$p(myNextPreABCINfo,"^",2)
	.//当前发票+1=下一个发票  说明在一个段，否则分段
	.if ((+myNextPrePrtNo=(+myCurPrePrtNo+1))&&(myNextPreABC=myCurPreABC)&&(+myNextPNoLength=+myCurPrtNoLength)) do
	.else  do
	..//下一个段
	..set endNo=myNo
	..if (invNoInfo="") do
	...set invNoInfo=startNo_"--"_endNo
	..else  do
	...set invNoInfo=invNoInfo_",  "_startNo_"--"_endNo
	..set startNo="", endNo=""
	..set newFlag=1
	
	quit invNoInfo
}

/// Modify: ZhYW 2022-03-04
/// Description: 把发票号码拆分成 前缀和号码
/// Debug: w ##class(web.DHCBillCommon).GetINVPreABCInfo("0000111111")
ClassMethod GetINVPreABCInfo(no As %String) As %String
{
	quit:(+no) no_"^"
	set cStr=$zstrip(no,"*N")  //去掉数字后由字母字符组成的串
	quit:(cStr="") no_"^"
	set cLastIdx=$l(no)-$locate($reverse(no),$e(cStr,*))+1    //取最后一个字母字符在字符串中的位置
	set myPreABC=$e(no,1,cLastIdx)
	set myNo=$e(no,(cLastIdx+1),*)
	quit myNo_"^"_myPreABC
}

/// Creator: ZhYW
/// CreatDate: 2018-03-14
/// Description: 取计费参数配置
/// Input: 
/// Return: flag
/// Debug: w ##class(web.DHCBillCommon).GetParamConfigFlag("DailyHandReceiveFlag")
ClassMethod GetParamConfigFlag(param As %String) As %String
{
	quit ##class(web.DHCBillParamConfig).%GetParameter(param)
}

/// Creator: ZhYW
/// CreatDate: 2018-08-06
/// Description: 根据就诊号获取床号
/// Input: 
/// Return: episodeId
/// Debug: w ##class(web.DHCBillCommon).GetPatBedCode()
ClassMethod GetPatBedCode(episodeId As %String) As %String
{
	quit ##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(episodeId)
}

/// Creator: ZhYW
/// CreatDate: 2018-08-21
/// Description: 取医嘱的基本单位
/// Input: arcim, oeitm
/// Return: 
/// Debug: w ##class(web.DHCBillCommon).GetBaseUom("511||1", "70||182")
ClassMethod GetBaseUom(arcim As %String, oeitm As %String) As %String
{
	set adm=$p(^OEORD(+oeitm),"^",1)
	set admType=$p(^PAADM(adm),"^",2)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	
	set isCNMedItem=##class(web.DHCDocOrderCommon).IsCNMedItem(arcim, hospDR)
	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(arcim, 0)
	if (ordCateType="R") {
		if (+isCNMedItem=0) {
			set inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
			set baseUomDR=$s((+inci'=0):$p($g(^INCI(inci,1)),"^",10),1:"")
		}else {
			set baseUomDR=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),2)),"^",3)   //1:n时取 药学项基本单位
		}
	}else {
		set baseUomDR=$p(^ARCIM(+arcim,+$p(arcim,"||",2),8),"^",14)
	}
	set baseUom=$s((+baseUomDR'=0):$p($g(^CT("UOM",baseUomDR)),"^",2),1:"")

	quit baseUom
}

/// Creator: ZhYW
/// CreatDate: 2018-12-11
/// Description: 获取操作员登录院区
/// Input: userId:SS_User.RowId
/// Return: 
/// Debug: w ##class(web.DHCBillCommon).GetUserLogonHosps(5)
ClassMethod GetUserLogonHosps(userId As %String) As %String
{
	set hospStr=""
	set objUser=##class(User.SSUser).%OpenId(userId, 0)
	quit:('$isObject(objUser)) hospStr

	set defHospDR=$p($g(^CTLOC(+objUser.SSUSRDefaultDeptDRGetObjectId())),"^",22)
	set locStDate=$p($g(^CTLOC(+objUser.SSUSRDefaultDeptDRGetObjectId())),"^",24)
	set locEndDate=$p($g(^CTLOC(+objUser.SSUSRDefaultDeptDRGetObjectId())),"^",25)
	if ((locEndDate="")||(locEndDate>=+$h))&&((locStDate="")||(locStDate<=+$h)){
		set hospStr=defHospDR
	}
	set myCount=objUser.ChildSSUserOtherLogonLoc.Count()
	for i=1:1:myCount {
		set objUserLoc=objUser.ChildSSUserOtherLogonLoc.GetAt(i)
		continue:('$isObject(objUserLoc.OTHLLCTLOCDR))
		set myStDate=objUserLoc.OTHLLStartDate
		set myEndDate=objUserLoc.OTHLLEndDate
		continue:((myStDate'="")&&(myStDate>+$h))
		continue:((myEndDate'="")&&(myEndDate<+$h))
		set myHospDR=$p($g(^CTLOC(+objUserLoc.OTHLLCTLOCDRGetObjectId())),"^",22)
		continue:(("^"_hospStr_"^")[("^"_myHospDR_"^"))
		set hospStr=$s((hospStr=""):myHospDR,1:hospStr_"^"_myHospDR)
	}
	
	quit hospStr
}

/// Creator: ZhYW
/// CreatDate: 2019-01-15
/// Description: 根据Id获取字段值
/// Input: tabName:表名, id:Id值, prop:属性(字段)名
/// Return: 字段值
/// Debug: w ##class(web.DHCBillCommon).GetPropValById("DHC_INVPRTZY", 1061, "PRT_ARPBL")
ClassMethod GetPropValById(tabName As %String, id As %String, prop As %String) As %String
{
	set result=##class(%Library.ResultSet).%New()
	set sqlStr="SELECT * FROM "_tabName_" WHERE %ID = "_"'"_id_"'"
	do result.Prepare(sqlStr)
	do result.Execute()
	quit $s(result.Next():result.Data(prop),1:"")
}

/// Creator: ZhYW
/// CreatDate: 2019-03-17
/// Description: 根据id获取Persistent类属性值(返回json串)
/// Input: clsName:Persistent类名
/// Return: 
/// Debug: w ##class(web.DHCBillCommon).GetClsPropValById("User.DHCINVPRTZY", "1061")
ClassMethod GetClsPropValById(clsName As %String, id As %String) As %String
{
	quit:'##class(websys.Conversions).IsValidClassName(clsName) "{}"
	set obj=$classmethod(clsName, "%OpenId", id, 0)
	quit:('$isObject(obj)) ..GetClsPropJson(clsName)     //不存在时返回属性名称
	do obj.%Close()
	set jsonObj=##class(ext.util.JsonObject).%New()
	set jsonObj.DateFormat=##class(websys.Conversions).DateFormat()
	set jsonObj.ContainNullValue=1    //空值也生成
	set jsonStr=##class(ext.util.JsonObject).ObjToJson(obj, "", jsonObj)
	do jsonObj.Clear()
	quit jsonStr
}

/// Creator: ZhYW
/// CreatDate: 2019-03-17
/// Description: 根据id获取类属性值(返回json串)
/// Input: clsName:类名
/// Return: 
/// Debug: w ##class(web.DHCBillCommon).GetClsPropJson("BILL.IP.DTO.Entity.Reg.PAAdm")
ClassMethod GetClsPropJson(clsName As %String) As %String
{
	set obj=##class(%Dictionary.CompiledClass).%OpenId(clsName, 0)
	quit:('$isObject(obj)) "{}"
	set json=##class(%DynamicObject).%New()
	for i=1:1:obj.Properties.Count() {
		set property=obj.Properties.GetAt(i)
		set name=property.Name
		continue:($e(name,1)="%")
		do json.%Set(name, "")
	}
	do obj.%Close()
	quit json.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2019-04-16
/// Description: 输出json
/// Input: 
/// Output: 
/// Debug: w ##class(web.DHCBillCommon).ReturnToJson("11", 0)
ClassMethod ReturnToJson(msg, success) As %String
{
	set obj=##class(ext.util.JsonObject).%New()
	do obj.Put("msg", msg).Put("success", success)
	w obj.Json()
	do obj.Clear()
	quit ""
}

/// Creator: ZhYW
/// CreatDate: 2019-11-21
/// Description: 获取住院业务配置参数
/// Input: hospId: CT_Hospital.HOSP_RowId, propName:属性名
/// Return: CF_BILL_IP.Param 表数据, 传入属性名时获取到该属性的值, 不传时返回所有属性值(json)
/// Debug: w ##class(web.DHCBillCommon).GetIPParamConfig(2)
ClassMethod GetIPParamConfig(hospId As %String, propName = "") As %String
{
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_IP_Param", hospId)
	set paramId=""
	set id=0
	while($o(^CF.BILL.IP.Param(id))&&(paramId="")) {
		set id=$o(^CF.BILL.IP.Param(id))
		set tmp=$g(^CF.BILL.IP.Param(id))
		continue:(tmp="")
		set hospDR=$p(tmp,"^",23)
		continue:(hospDR'=defHospId)
		set paramId=id
	}
	
	set jsonStr=##class(web.DHCBillCommon).GetClsPropValById("CF.BILL.IP.Param", paramId)
	if (propName'="") {
		set jsonObj=##class(ext.util.JsonObject).FromJSON(jsonStr)
		quit jsonObj.GetValue(propName)
	}
	quit jsonStr
}

/// Creator: ZhYW
/// CreatDate: 2020-03-03
/// Description: 根据患者主索引获取患者信息
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillCommon).GetPatientInfo(43)
ClassMethod GetPatientInfo(patientId As %String) As %String
{
	set obj={}
	quit:(patientId="") "{}"
	set objPAPerson=##class(User.PAPerson).%OpenId(patientId, 0)
	if ('$isObject(objPAPerson)) {
		quit "{}"
	}
	set patName=objPAPerson.PAPERName
	set patID=objPAPerson.PAPERID
	set patTelH=objPAPerson.PAPERTelH
	do obj.%Set("PAPERName",patName).%Set("PAPERID",patID).%Set("PAPERTelH",patTelH)
	quit obj.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2020-03-20
/// Description: 取计费系统参数配置
/// Input: hospId: CT_Hospital.RowId
/// Return: cfgId: DHC_TarPara.RowId
/// Debug: w ##class(web.DHCBillCommon).GetTarParaId(2)
ClassMethod GetTarParaId(hospId As %String) As %String
{
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_TarPara", hospId)
	set cfgId=""
	set rowId=0
	while ($o(^DHCTarC("CF",rowId))&&(cfgId="")) {
		set rowId=$o(^DHCTarC("CF",rowId))
		set hospDR=$p($g(^DHCTarC("CF",rowId)),"^",16)
		continue:(hospDR'=defHospId)
		set cfgId=rowId
	}
	
	quit cfgId
}

/// Creator: Lid
/// CreatDate: 2020-06-08
/// Description: 根据支付方式代码获取支付方式rowid  --支付方式是公有数据
/// Input: code:CT_PayMode.CTPM_Code
/// Return: 
/// Debug: w ##class(web.DHCBillCommon).GetPayModeByCode("CPP")
ClassMethod GetPayModeByCode(code As %String) As %String
{
	quit:(code="") "^^^"
	set payMId=$o(^CT("CTPM",0,"Code",code,0))
	quit:(payMId="") "^^^"
	set tmp=..GetClsPropValById("User.CTPayMode", payMId)
	set obj={}.%FromJSON(tmp)
	set payMId=obj.ID
	set payMDesc=obj.CTPMDesc
	set payMCode=obj.CTPMCode
	set isPrintInv=obj.CTPMChangeGiven
	quit payMId_"^"_payMCode_"^"_payMDesc_"^"_isPrintInv
}

}

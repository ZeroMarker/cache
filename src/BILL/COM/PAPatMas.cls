Import SQLUser

/// 名称: BILL.COM.PAPatMas.cls
/// 描述: 计费组公共患者基本信息相关类
/// 编写者: ZhYW
/// 编写日期: 2021-04-02
Class BILL.COM.PAPatMas Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2021-04-02
/// Description: 根据姓名获取病人Id(模糊检索)，将查找到的patientId存入数组
/// Input: patName: 患者姓名
/// Return: 
/// Debug: do ##class(BILL.COM.PAPatMas).GetPatientByName("加油")
ClassMethod GetPatientByName(patName As %String, ByRef patAry) As %String
{
	//set regExp=$zcvt(patName,"U")     //模糊匹配
	set regExp="^"_$zcvt(patName,"U")   //左匹配
	set tmpName=""
	do {
		set tmpName=$o(^PAPERi("PAPER_PatName",tmpName))
		quit:(tmpName="")
		while ('$locate($zcvt(tmpName,"U"),regExp)) {
			set tmpName=$o(^PAPERi("PAPER_PatName",tmpName))
			quit:(tmpName="")
		}
		quit:(tmpName="")
		
		set papmi=""
		while($o(^PAPERi("PAPER_PatName",tmpName,papmi))) {
			set papmi=$o(^PAPERi("PAPER_PatName",tmpName,papmi))
			set patAry(papmi)=""
		}
	}while(papmi'="")
	
	quit
}

/// Creator: ZhYW
/// CreatDate: 2021-11-20
/// Description: 根据身份证号获取患者主索引信息
/// Input: IDNo: 身份证号
/// Return: 
/// Debug: w ##class(BILL.COM.PAPatMas).GetPatInfoByIDNo("")
ClassMethod GetPatInfoByIDNo(IDNo As %String) As %String
{
	set json=##class(%DynamicObject).%New()
	if (IDNo="") {
		set json.success=-1
		set json.msg="身份证号为空"
		quit json.%ToJSON()
	}
	set patientId=$o(^PAPERi("PAPMI_ICPPBC",$$ALPHAUP^SSUTIL4(IDNo)_"Z",""),-1)
	if (patientId="") {
		set json.success=-1
		set json.msg="没有对应的患者信息"
		quit json.%ToJSON()
	}
	set patientNo=$p(^PAPER(patientId,"PAT",1),"^",1)
	set patName=$p(^PAPER(patientId,"ALL"),"^",1)
	
	set json.success=0
	set json.msg="获取患者信息成功"
	set json.patientId=patientId
	set json.patientNo=patientNo
	set json.patName=patName
	
	quit json.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2021-12-29
/// Description: 患者多条主索引合并时更新业务表中的患者主索引
/// Input: oldPatientId: 原患者主索引, newPatientId: 新患者主索引, userId: 操作员Id
/// Return: 
/// Other: *慎重使用*
/// Debug: w ##class(BILL.COM.PAPatMas).UpdateBizTBPAPMI(1, 2, 1)
ClassMethod UpdateBizTBPAPMI(oldPatientId As %String, newPatientId As %String, userId As %String) As %String
{
	set $zt="ERROR"
	set rtn=0
	
	if ((+oldPatientId=0)||(+newPatientId=0)) quit -1_"^"_"参数错误"
		
	&SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_INVPRT
		WHERE PRT_PAPMI_DR = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_INVPRT
			SET PRT_PAPMI_DR = :newPatientId
			WHERE PRT_PAPMI_DR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
	
	&SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_INVPRTInsu
		WHERE PrtInsu_PAPMI_DR = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_INVPRTInsu
			SET PrtInsu_PAPMI_DR = :newPatientId
			WHERE PrtInsu_PAPMI_DR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_AccManager
		WHERE AccM_PAPMI_DR = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_AccManager
			SET AccM_PAPMI_DR = :newPatientId
			WHERE AccM_PAPMI_DR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
	&SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_AccPayList
		WHERE AccPL_PAPMI_DR = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_AccPayList
			SET AccPL_PAPMI_DR = :newPatientId
			WHERE AccPL_PAPMI_DR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_EPManager
		WHERE EPM_PAPMI_DR = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_EPManager
			SET EPM_PAPMI_DR = :newPatientId
			WHERE EPM_PAPMI_DR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
	&SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_EPPayList
		WHERE EPPL_PAPMI_DR = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_EPPayList
			SET EPPL_PAPMI_DR = :newPatientId
			WHERE EPPL_PAPMI_DR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_CardINVPRT
		WHERE CIP_PAPMI_DR = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_CardINVPRT
			SET CIP_PAPMI_DR = :newPatientId
			WHERE CIP_PAPMI_DR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM BILL_AUX.CallQueue
		WHERE PAPMIDR = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK BILL_AUX.CallQueue
			SET PAPMIDR = :newPatientId
			WHERE PAPMIDR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_OPQFPatTotal
		WHERE QF_Papmi_Dr = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_OPQFPatTotal
			SET QF_Papmi_Dr = :newPatientId
			WHERE QF_Papmi_Dr = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_AccPayINV
		WHERE API_PAPMI_DR = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_AccPayINV
			SET API_PAPMI_DR = :newPatientId
			WHERE API_PAPMI_DR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_OPIPADMCON
		WHERE OCI_PAPMI_DR = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_OPIPADMCON
			SET OCI_PAPMI_DR = :newPatientId
			WHERE OCI_PAPMI_DR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM dhc_sfprintdetail
		WHERE prt_papmi_dr = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK dhc_sfprintdetail
			SET prt_papmi_dr = :newPatientId
			WHERE prt_papmi_dr = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_INVPRTZY
		WHERE PRT_PAPMI_DR = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_INVPRTZY
			SET PRT_PAPMI_DR = :newPatientId
			WHERE PRT_PAPMI_DR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_WARRANT
		WHERE WARR_PAPMI_DR = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_WARRANT
			SET WARR_PAPMI_DR = :newPatientId
			WHERE WARR_PAPMI_DR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_JFUpReport
		WHERE UPR_papmi_dr = :oldPatientId
	)
	if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_JFUpReport
			SET UPR_papmi_dr = :newPatientId
			WHERE UPR_papmi_dr = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM BILL_IP.SummaryPrtInv
		WHERE SPI_PAPMI_DR = :oldPatientId
	)
	if (id'="") {
	&SQL(
			UPDATE %NOLOCK %NOCHECK BILL_IP.SummaryPrtInv
			SET SPI_PAPMI_DR = :newPatientId
			WHERE SPI_PAPMI_DR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}

    &SQL(
		SELECT TOP 1 %ID INTO :id FROM BILL_INV.PrtExt
		WHERE PAPMIDR = :oldPatientId
	)
    if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK BILL_INV.PrtExt
			SET PAPMIDR = :newPatientId
			WHERE PAPMIDR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_OPBillDelInvPrtLog
		WHERE DIL_PAPMI_DR = :oldPatientId
	)
    if (id'="") {
	 	&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_OPBillDelInvPrtLog
			SET DIL_PAPMI_DR = :newPatientId
			WHERE DIL_PAPMI_DR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    //第三方支付
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_BillExtTradePay
		WHERE ETP_PAPMI_DR = :oldPatientId
	)
    if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_BillExtTradePay
			SET ETP_PAPMI_DR = :newPatientId
			WHERE ETP_PAPMI_DR = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_BillExtTradeBalance
		WHERE ETP_PatientID = :oldPatientId
	)
    if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_BillExtTradeBalance
			SET ETP_PatientID = :newPatientId
			WHERE ETP_PatientID = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    
    //老版本第三方支付订单表
    &SQL(
		SELECT TOP 1 %ID INTO :id FROM DHC_INVBankTradePay
		WHERE IBP_papmi_dr = :oldPatientId
	)
    if (id'="") {
		&SQL(
			UPDATE %NOLOCK %NOCHECK DHC_INVBankTradePay
			SET IBP_papmi_dr = :newPatientId
			WHERE IBP_papmi_dr = :oldPatientId
		)
		set rtn=SQLCODE
	    if (+rtn) quit rtn_"^"_$g(%msg)
	}
    	
	set ^BILL.UPDATEPAPMI(oldPatientId)=$lb(newPatientId, userId, $zdt($h,3,1))
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2021-05-20
/// Description: 获取患者基本信息
/// Input: patientId:PA_PatMas.RowId
/// Return: 
/// Debug: w ##class(BILL.COM.PAPatMas).GetPatientInfo()
ClassMethod GetPatientInfo(patientId As %String, hospId As %String = "") As %String
{
	if (hospId="")&&($d(%session)) {
		set hospId=%session.Get("LOGON.HOSPID")
	}

	set patJson=##class(%DynamicObject).%New()
	quit:(+patientId=0) patJson.%ToJSON()
	
	set patientNo=$p($g(^PAPER(patientId,"PAT",1)),"^",1)     //登记号
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patientId, "I", hospId)
	set patName=$p($g(^PAPER(patientId,"ALL")),"^",1)     //姓名
	set birthDate=$p($g(^PAPER(patientId,"ALL")),"^",6)
	set birthDate=##class(websys.Conversions).DateLogicalToHtml(birthDate)
	set sexDR=$p($g(^PAPER(patientId,"ALL")),"^",7)       //性别
	set sexCode=$s((+sexDR'=0):$p($g(^CT("SEX",sexDR)),"^",1),1:"")
	set sexIconCls=$case(sexCode,1:"man",2:"woman",:"unman")
	set sex=$s((+sexDR'=0):$p($g(^CT("SEX",sexDR)),"^",2),1:"")
	set age=##class(web.DHCBillInterface).GetPapmiAge(patientId, "", hospId)
	set ID=$p($g(^PAPER(patientId,"ALL")),"^",9)          //身份证号
	set address=$g(^PAPER(patientId,"PER","ADD",1))           //地址
	set mobPhone=$p($g(^PAPER(patientId,"PER",4)),"^",21)   //手机号
	if (mobPhone="") {
		set mobPhone=$p($g(^PAPER(patientId,"PER",1)),"^",11)   //家庭电话
	}
 	//add by wangjian 2015-01-15 增加患者密级和级别
    set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(patientId, "")
    set EncryptLevel=$p(PatEncryptLevel,"^",1)
    set PatLevel=$p(PatEncryptLevel,"^",2)
    set SecCode=$p(PatEncryptLevel,"^",3)
    
	set patJson.PatientId=patientId
    set patJson.PatientNo=patientNo
    set patJson.MedicareNo=mrNo
	set patJson.PatName=patName
	set patJson.Sex=sex
	set patJson.SexIconCls=sexIconCls
	set patJson.Age=age
	set patJson.BirthDate=birthDate
	set patJson.ID=ID
	set patJson.Address=address
	set patJson.MobPhone=mobPhone
    set patJson.EncryptLevel=EncryptLevel
    set patJson.PatLevel=PatLevel
    set patJson.SecCode=SecCode
	quit patJson.%ToJSON()
}

}

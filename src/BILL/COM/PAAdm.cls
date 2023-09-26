/// 名称: BILL.COM.PAAdm.cls
/// 描述: 计费组公共患者就诊信息相关类
/// 编写者: ZhYW
/// 编写日期: 2022-05-20
Class BILL.COM.PAAdm Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2021-05-20
/// Description: 获取患者就诊信息
/// Input: adm:PA_Adm.RowId
/// Return: 
/// Debug: w ##class(BILL.COM.PAAdm).GetAdmInfo()
ClassMethod GetAdmInfo(adm As %String) As %String
{
    set admJson=##class(%DynamicObject).%New()
	quit:(+adm=0) admJson.%ToJSON()
	
	set admType=$p(^PAADM(adm),"^",2)
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, admType, "")	

	set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(adm)
	set admDate=$p(admInOutDateInfo,"^",1)
	set admTime=$p(admInOutDateInfo,"^",2)
	set inDays=$p(admInOutDateInfo,"^",3)
	set discDate=$p(admInOutDateInfo,"^",4)
	set discTime=$p(admInOutDateInfo,"^",5)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime, 1)
	set discDate=##class(websys.Conversions).DateLogicalToHtml(discDate)
	set discTime=##class(websys.Conversions).TimeLogicalToHtml(discTime, 1)
	
	set wardDR=$p(^PAADM(adm),"^",70)
	set ward=$s((+wardDR'=0):$p($g(^PAWARD(wardDR)),"^",2),1:"")
	set deptDR=$p(^PAADM(adm),"^",4)
	set dept=$s((+deptDR'=0):$p(^CTLOC(deptDR),"^",2),1:"")
	set insTypeDR=$p(^PAADM(adm,1),"^",7)
	set insType=$s((insTypeDR'=""):$p($g(^PAC("ADMREA",insTypeDR)),"^",2),1:"")
	set bed=##class(web.DHCBillCommon).GetPatBedCode(adm)
	
	set admJson.AdmType=admType
	set admJson.MedicareNo=mrNo
    set admJson.AdmDate=admDate
    set admJson.AdmTime=admTime
	set admJson.InDays=inDays
	set admJson.DiscDate=discDate
    set admJson.DiscTime=discTime
	set admJson.Ward=ward
	set admJson.Dept=dept
    set admJson.InsType=insType
    set admJson.Bed=bed
	quit admJson.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2023-03-20
/// Description: 根据就诊判断是否"绿色通道"和"先诊疗后付费"
/// Input: adm:PA_Adm.RowId
/// Return: 是否"绿色通道"(1:是, 0:否)^是否"先诊疗后付费"(1:是, 0:否)
/// Debug: w ##class(BILL.COM.PAAdm).ChkGreenAndPayAfterTreatByAdm(17897)
ClassMethod ChkGreenAndPayAfterTreatByAdm(adm As %String, dateH As %Date = "", timeH As %Time = "") As %String
{
	set isGreen=0           //是否"绿色通道"
	set isPayAfterTreat=0   //是否"先诊疗后付费"
	quit:(+adm=0) isGreen_"^"_isPayAfterTreat
	
	set admData=$g(^PAADM(adm))
	set admType=$p(admData,"^",2)
	if (admType="I") {
		quit ##class(BILL.IP.COM.Method).ChkGreenAndPayAfterTreatByAdm(adm, dateH, timeH)
	}
	quit ##class(BILL.OP.COM.Method).ChkGreenAndPayAfterTreatByAdm(adm, dateH, timeH)
}

}

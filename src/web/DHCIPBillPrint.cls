/// 名称: web.DHCOPBillPrint.cls
/// 描述: 计费组住院公共打印类
/// 编写者: ZhYW
/// 编写日期: 2019-02-16
Class web.DHCIPBillPrint Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: ZhYW
/// CreatDate: 2019-02-16
/// Description: 获取腕带打印信息
/// Input: episodeId: PA_Adm.RowId
/// Output: 
/// Return: 
/// Debug:  w ##class(web.DHCIPBillPrint).GetWirstPrtInfo(43)
ClassMethod GetWirstPrtInfo(episodeId As %String) As %String
{
	new (episodeId)
	quit:(+episodeId=0) ""
	set adm=episodeId
	set papmi=$p(^PAADM(adm),"^",1)
	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)   //登记号
	set medicare=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID(papmi, "I", "", "")   //病案号
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)   //姓名
	set sexDR=$p(^PAPER(papmi,"ALL"),"^",7)        //性别
	set sex=$s((+sexDR'=0):$p(^CT("SEX",sexDR),"^",2),1:"")
	set patAge=##class(web.DHCBillInterface).GetPapmiAge(papmi, adm)
	set admDeptDR=$p(^PAADM(adm),"^",4)
	set admDept=$s((+admDeptDR'=0):$p(^CTLOC(admDeptDR),"^",2),1:"")
	set admDate=$p(^PAADM(adm),"^",6)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set hospitalDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
	set hospital=$s((+hospitalDR'=0):$p(^CT("HOSP",hospitalDR),"^",2),1:"")
	
	set prtTxtInfo="RegNo"_$c(2)_regNo_"^"_"RegNoBarCode"_$c(2)_"*"_regNo_"*"_"^"_"Name"_$c(2)_patName_"^"_"Sex"_$c(2)_sex
	set prtTxtInfo=prtTxtInfo_"^"_"MedicareNo"_$c(2)_medicare_"^"_"Age"_$c(2)_patAge_"^"_"AdmDep"_$c(2)_admDept
	set prtTxtInfo=prtTxtInfo_"^"_"HospitalName"_$c(2)_hospital
	
	quit prtTxtInfo
}

}

Class DHCMA.Util.Task.SyncHisBaseDic Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-07-12
/// Description:  同步基础信息
/// Table：       DHCMA.Util.EP.Hospital，DHCMA.Util.EP.Location，DHCMA.Util.EP.CareProv，DHCMA.Util.EP.SSUser
/// Input：		  aHospCode:DHCMA.Util.EP.Hospital.BTCode
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.Task.SyncHisBaseDic).SyncBaseData("HIS01","2020-01-01","2020-05-06")
ClassMethod SyncBaseData(aSYSCode As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	New (aSYSCode,aDateFrom,aDateTo)
	Set return="",Count=0
	
	Set $ZT="SyncBaseDataErr"
	
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjByCode(aSYSCode)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom="" aDateFrom=(+$h)-1
	Set:aDateTo="" aDateTo=+$h
	// 版本说明：
	// LIS1.0  ：从东华检验（CS版）直接获取检验报告信息
	// LIS2.0  ：从东华检验（BS版）直接获取检验报告信息
	// LISC1.0 ：从平台（文档）获取检验报告信息
	// LISC2.0 ：从平台（结构化）获取检验报告信息
	// RISC1.0 ：从平台（文档）获取检验检查信息
	// RISC2.0 ：从平台（结构化）获取检验检查信息
    Set LabRepVer=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSLabReportVer")
    Set RISRepVer=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSRISReportVer")

	If SYSExCode="localhost" {
		//直接调用本地库类方法
		
		//医院
		Set ret=##Class(DHCMA.Util.EPy.HospitalSrv).SyncHospital(SYSDr)
		Set:ret>0 Count=Count+ret
		
		//科室
		Set ret=##Class(DHCMA.Util.EPy.LocationSrv).SyncLocation(SYSDr)
		Set:ret>0 Count=Count+ret
		
		//医护人员
		Set ret=##Class(DHCMA.Util.EPy.CareProvSrv).SyncCareProv(SYSDr)
		Set:ret>0 Count=Count+ret
		
		//用户
		Set ret=##Class(DHCMA.Util.EPy.SSUserSrv).SyncSSUser(SYSDr)
		Set:ret>0 Count=Count+ret
		
		//安全组
		Set ret=##Class(DHCMA.Util.EPy.SSGroupSrv).SyncSSGroup(SYSDr)
		Set:ret>0 Count=Count+ret
		
		//性别
		Set ret=##Class(DHCMA.Util.EPy.DictionarySrv).GetHisDicList(SYSDr,"HISCTSex")
		Set:ret>0 Count=Count+ret
		
		//民族
		Set ret=##Class(DHCMA.Util.EPy.DictionarySrv).GetHisDicList(SYSDr,"HISCTNation")
		Set:ret>0 Count=Count+ret
		
		//国籍
		Set ret=##Class(DHCMA.Util.EPy.DictionarySrv).GetHisDicList(SYSDr,"HISCTCountry")
		Set:ret>0 Count=Count+ret
		
		//婚姻状况
		Set ret=##Class(DHCMA.Util.EPy.DictionarySrv).GetHisDicList(SYSDr,"HISCTMarital")
		Set:ret>0 Count=Count+ret
		
		//职业
		Set ret=##Class(DHCMA.Util.EPy.DictionarySrv).GetHisDicList(SYSDr,"HISCTOccupation")
		Set:ret>0 Count=Count+ret
		
		//医疗付费方式
		Set ret=##Class(DHCMA.Util.EPy.DictionarySrv).GetHisDicList(SYSDr,"HISCTSocialStatus")
		Set:ret>0 Count=Count+ret
		
		//关系
		Set ret=##Class(DHCMA.Util.EPy.DictionarySrv).GetHisDicList(SYSDr,"HISCTRelation")
		Set:ret>0 Count=Count+ret
		
		//证件类型
		Set ret=##Class(DHCMA.Util.EPy.DictionarySrv).GetHisDicList(SYSDr,"HISPACCardType")
		Set:ret>0 Count=Count+ret
		
		//学历
		Set ret=##Class(DHCMA.Util.EPy.DictionarySrv).GetHisDicList(SYSDr,"HISCTEducation")
		Set:ret>0 Count=Count+ret
		
		If LabRepVer="LISC1.0" {
			Set ret=##Class(DHCMA.Util.IO.EnsSyncLis1Srv).AutoNewTSAndTCDic(aDateFrom,aDateTo)
			Set:ret>0 Count=Count+ret
		}ElseIf LabRepVer="LISC2.0" {
			Set ret=##Class(DHCMA.Util.IO.EnsSyncLis2Srv).AutoNewTSAndTCDic(aDateFrom,aDateTo)
			Set:ret>0 Count=Count+ret
		}Else {
			//检验项目
			Set ret=##Class(DHCMA.Util.EPy.TestCodeSrv).SyncTestCode(SYSDr)
			Set:ret>0 Count=Count+ret
			
			//检验医嘱
			Set ret=##Class(DHCMA.Util.EPy.TestSetSrv).SyncTestSet(SYSDr)
			Set:ret>0 Count=Count+ret
			
			//送检标本
			Set ret=##Class(DHCMA.Util.EPy.SpecimenSrv).SyncSpecimen(SYSDr)
			Set:ret>0 Count=Count+ret
		}
		If RISRepVer="RISC2.0" {
			Set ret=##Class(DHCMA.Util.IO.EnsSyncRis2Srv).AutoNewAppPartAndArcDic(aDateFrom,aDateTo)
			Set:ret>0 Count=Count+ret
		}
		//医嘱项
		Set ret=##Class(DHCMA.Util.EPy.OrdMastSrv).SyncOrdMast(SYSDr)
		Set:ret>0 Count=Count+ret
		
	} Else {
		//调用Webservice接口
	}
	Set return=Count
	Quit return
	
SyncBaseDataErr
	Set return=Count
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-05-15
/// Description:  根据字典类型同步基础信息
/// Table：      
/// Input：		 
/// Return：      异常：0、正常：处理数据条数
/// w ##Class(DHCMA.Util.Task.SyncHisBaseDic).SyncDicData("71")
ClassMethod SyncDicData(aTypeDr As %String) As %String
{
	New (aTypeDr)
	Set return="",Count=0
	Quit:(aTypeDr="") return
	
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjByCode("HIS01")
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
		
	Set objType=##class(DHCMA.Util.BT.DicType).GetObjById(aTypeDr)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	Set TypeCode=objType.BTCode
	
    If TypeCode="HISCTSex" {
		//性别
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTSexDic")
	} ElseIf TypeCode="HISCTNation" {
		//民族
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTNationDic")
	} ElseIf TypeCode="HISCTCountry" {
		//国籍
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTCountryDic")
	} ElseIf TypeCode="HISCTMarital" {
		//婚姻状况
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTMaritalDic")
	} ElseIf TypeCode="HISCTOccupation" {
		//职业
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTOccupationDic")
	} ElseIf TypeCode="HISCTSocialStatus" {
		//医疗付费方式
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTSocialStatusDic")
	}ElseIf TypeCode="HISCTRelation" {
		//关系
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTRelationDic")
	} ElseIf TypeCode="HISPACCardType" {
		//证件类型
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetPACCardTypeDic")
	} ElseIf TypeCode="HISCTEducation" {
		//学历
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetCTEducationDic")
	}	
  	Set sc=rs.Execute("")
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")                // ID
		Set Code=rs.Data("Code")             // 代码
		Set Desc=rs.Data("Desc")             // 描述
		Set IsActive=rs.Data("IsActive")     // 是否有效
	    Set:OID'="" OID=OID_"!!"_SYSDr
		Continue:(OID="")||(Desc="")
		
		Set ID="",RangeID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.Dictionary).xGetByOID(TypeDr,OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set RangeID   = objTmp.BTRangeID
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=TypeDr
		Set $p(InputStr,"^",6)=RangeID
		Set $p(InputStr,"^",7)=IsActive
		Set $p(InputStr,"^",8)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.Dictionary).Update(InputStr,"^")
		If (+flg)>0{
			Set Count=Count+1
		}
	}
	Set return = Count
	Quit return
}

}

/// 名称: DHCMA.Util.EPy.SpecimenSrv
/// 描述: HIS接口服务 标本字典
/// 编写者：zhufei
/// 编写日期: 2019-01-17
Class DHCMA.Util.EPy.SpecimenSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2019-01-17
/// Description:  根据ID同步标本信息
/// Table：       DHCMA.Util.EP.Specimen
/// Input：		  aOID : DHCMA.Util.EP.Specimen.OID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.SpecimenSrv).SetSpecimen("S101!!1")
ClassMethod SetSpecimen(aOID As %String = "") As %String
{
	New (aOID)
	Set return=0
	Quit:(aOID="") return
	
	Set objSYS=##class(DHCMA.Util.EPS.OIDService).GetSYSDr(aOID)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	Quit:SYSExCode'="localhost" return
	Set SYSOID=##class(DHCMA.Util.EPS.OIDService).GetSYSOID(aOID)
	Quit:SYSOID="" return
	
	Set LabReportVer=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSLabReportVer")
	If LabReportVer="LIS2.0" {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis2Srv:GetLisSpecDic")
	} Else {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis1Srv:GetLisSpecDic")
	}
  	Set sc=rs.Execute(SYSOID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")               // ID
		Set Code=rs.Data("Code")            // 代码
		Set Desc=rs.Data("Desc")            // 描述
		Set IsActive=rs.Data("IsActive")    // 是否有效
	    Set:OID'="" OID=OID_"!!"_SYSDr
		Continue:(OID="")||(Code="")||(Desc="")
		
		Set ID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.Specimen).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=IsActive
		Set $p(InputStr,"^",6)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.Specimen).Update(InputStr,"^")
		Set return=+flg
		Quit
	}
	Quit return
}

/// Creator:	  zhufei
/// CreatDate：   2019-01-17
/// Description:  批量同步标本信息
/// Table：       DHCMA.Util.EP.Specimen
/// Input：		  aSYSDr : DHCMA.Util.BT.SYSTEM.ID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.SpecimenSrv).SyncSpecimen()
ClassMethod SyncSpecimen(aSYSDr As %String) As %String
{
	New (aSYSDr)
	Set return=0,Count=0
	Quit:(aSYSDr="") return
	
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjById(aSYSDr)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	Quit:SYSExCode'="localhost" return
	
	Set LabReportVer=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSLabReportVer")
	If LabReportVer="LIS2.0" {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis2Srv:GetLisSpecDic")
	} Else {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis1Srv:GetLisSpecDic")
	}
  	Set sc=rs.Execute("")
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")               // ID
		Set Code=rs.Data("Code")            // 代码
		Set Desc=rs.Data("Desc")            // 描述
		Set IsActive=rs.Data("IsActive")    // 是否有效
	    Set:OID'="" OID=OID_"!!"_SYSDr
		Continue:(OID="")||(Code="")||(Desc="")
		
		Set ID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.Specimen).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=IsActive
		Set $p(InputStr,"^",6)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.Specimen).Update(InputStr,"^")
		If (+flg)>0 {
			Set Count=Count+1
		}
	}
	Quit Count
}

}

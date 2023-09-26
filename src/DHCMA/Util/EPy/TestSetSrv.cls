/// 名称: DHCMA.Util.EPy.TestSetSrv
/// 描述: HIS接口服务 检验医嘱字典
/// 编写者：zhufei
/// 编写日期: 2019-01-17
Class DHCMA.Util.EPy.TestSetSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2019-01-17
/// Description:  根据ID同步检验医嘱信息
/// Table：       DHCMA.Util.EP.TestSet
/// Input：		  aOID : DHCMA.Util.EP.TestSet.OID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.TestSetSrv).SetTestSet()
ClassMethod SetTestSet(aOID As %String = "") As %String
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
	If LabReportVer="LIS1.0" {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis1Srv:GetLisTestSetDic")
	} ElseIf LabReportVer="LIS2.0" {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis2Srv:GetLisTestSetDic")
	} Else {
		Quit return
	}
  	Set sc=rs.Execute(SYSOID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")               // ID
		Set Code=rs.Data("Code")            // 检验医嘱代码
		Set Desc=rs.Data("Desc")            // 检验医嘱名称
		Set Code2=rs.Data("ArcimCode")      // 医嘱代码
		Set Desc2=rs.Data("ArcimDesc")      // 医嘱名称
		Set IsActive=rs.Data("IsActive")    // 是否有效
		Set TCStr=rs.Data("TCStr")          // 检验项目ID（多值^分割）
	    Set:OID'="" OID=OID_"!!"_SYSDr
		Continue:(OID="")||(Code="")||(Desc="")
		
		Set ID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.TestSet).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=Code2
		Set $p(InputStr,"^",6)=Desc2
		Set $p(InputStr,"^",7)=IsActive
		Set $p(InputStr,"^",8)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.TestSet).Update(InputStr,"^")
		If (+flg)>0 {
			Set TSDr=+flg,return=+flg
			For indTC=1:1:$l(TCStr,"^") {
				Set TCOID=$p(TCStr,"^",indTC)_"!!"_SYSDr
				Set objTC=##class(DHCMA.Util.EP.TestCode).xGetByOID(TCOID)
				Continue:'$IsObject(objTC)
				Set TCDr=objTC.%Id()
				Set flg1=##class(DHCMA.Util.EPx.TestSetTC).Update("^"_TSDr_"^"_TCDr,"^")
			}
		}
		Quit
	}
	Quit return
}

/// Creator:	  zhufei
/// CreatDate：   2019-01-17
/// Description:  批量同步检验医嘱信息
/// Table：       DHCMA.Util.EP.TestSet
/// Input：		  aSYSDr : DHCMA.Util.BT.SYSTEM.ID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.TestSetSrv).SyncTestSet()
ClassMethod SyncTestSet(aSYSDr As %String) As %String
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
	If LabReportVer="LIS1.0" {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis1Srv:GetLisTestSetDic")
	} ElseIf LabReportVer="LIS2.0" {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis2Srv:GetLisTestSetDic")
	} Else {
		Quit return
	}
  	Set sc=rs.Execute("")
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")               // ID
		Set Code=rs.Data("Code")            // 检验医嘱代码
		Set Desc=rs.Data("Desc")            // 检验医嘱名称
		Set Code2=rs.Data("ArcimCode")      // 医嘱代码
		Set Desc2=rs.Data("ArcimDesc")      // 医嘱名称
		Set IsActive=rs.Data("IsActive")    // 是否有效
		Set TCStr=rs.Data("TCStr")          // 检验项目ID（多值^分割）
	    Set:OID'="" OID=OID_"!!"_SYSDr
		Continue:(OID="")||(Code="")||(Desc="")
		
		Set ID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.TestSet).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=Code2
		Set $p(InputStr,"^",6)=Desc2
		Set $p(InputStr,"^",7)=IsActive
		Set $p(InputStr,"^",8)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.TestSet).Update(InputStr,"^")
		If (+flg)>0 {
			Set TSDr=+flg,Count=Count+1
			For indTC=1:1:$l(TCStr,"^") {
				Set TCOID=$p(TCStr,"^",indTC)_"!!"_SYSDr
				Set objTC=##class(DHCMA.Util.EP.TestCode).xGetByOID(TCOID)
				Continue:'$IsObject(objTC)
				Set TCDr=objTC.%Id()
				Set flg1=##class(DHCMA.Util.EPx.TestSetTC).Update("^"_TSDr_"^"_TCDr,"^")
			}
		}
	}
	Quit Count
}

}

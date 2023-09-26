/// 名称: DHCMA.Util.EPy.TestCodeSrv
/// 描述: HIS接口服务 检验项目字典
/// 编写者：zhufei
/// 编写日期: 2019-01-17
Class DHCMA.Util.EPy.TestCodeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2019-01-17
/// Description:  根据ID同步检验项目信息
/// Table：       DHCMA.Util.EP.TestCode
/// Input：		  aOID : DHCMA.Util.EP.TestCode.OID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.TestCodeSrv).SetTestCode()
ClassMethod SetTestCode(aOID As %String = "") As %String
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
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis1Srv:GetLisTestCodeDic")
	} ElseIf LabReportVer="LIS2.0" {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis2Srv:GetLisTestCodeDic")
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
		Set Code=rs.Data("Code")            // 代码
		Set Desc=rs.Data("Desc")            // 描述
		Set RstFormat=rs.Data("RstFormat")  // 结果类型
		Set AbFlagS=""                      // 异常标志
		Set ClDiagnos=""                    // 临床意义
		Set RefRanges=""                    // 正常值范围
		Set WCode=""                        // WHONET码
		Set IsActive=rs.Data("IsActive")    // 是否有效
		Set TSStr=rs.Data("TSStr")          // 检验医嘱（多值^分割）
	    Set:OID'="" OID=OID_"!!"_SYSDr
		Continue:(OID="")||(Code="")||(Desc="")
		
		Set ID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.TestCode).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=RstFormat
		Set $p(InputStr,"^",6)=AbFlagS
		Set $p(InputStr,"^",7)=ClDiagnos
		Set $p(InputStr,"^",8)=RefRanges
		Set $p(InputStr,"^",9)=WCode
		Set $p(InputStr,"^",10)=IsActive
		Set $p(InputStr,"^",11)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.TestCode).Update(InputStr,"^")
		If (+flg)>0 {
			Set TCDr=+flg,return=+flg
			For indTS=1:1:$l(TSStr,"^") {
				Set TSOID=$p(TSStr,"^",indTS)_"!!"_SYSDr
				Set objTS=##class(DHCMA.Util.EP.TestSet).xGetByOID(TSOID)
				Continue:'$IsObject(objTS)
				Set TSDr=objTS.%Id()
				Set flg1=##class(DHCMA.Util.EPx.TestSetTC).Update("^"_TSDr_"^"_TCDr,"^")
			}
		}
		Quit
	}
	Quit return
}

/// Creator:	  zhufei
/// CreatDate：   2019-01-17
/// Description:  批量同步检验项目信息
/// Table：       DHCMA.Util.EP.TestCode
/// Input：		  aSYSDr : DHCMA.Util.BT.SYSTEM.ID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.TestCodeSrv).SyncTestCode()
ClassMethod SyncTestCode(aSYSDr As %String) As %String
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
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis1Srv:GetLisTestCodeDic")
	} ElseIf LabReportVer="LIS2.0" {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncLis2Srv:GetLisTestCodeDic")
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
		Set Code=rs.Data("Code")            // 代码
		Set Desc=rs.Data("Desc")            // 描述
		Set RstFormat=rs.Data("RstFormat")  // 结果类型
		Set AbFlagS=""                      // 异常标志
		Set ClDiagnos=""                    // 临床意义
		Set RefRanges=""                    // 正常值范围
		Set WCode=""                        // WHONET码
		Set IsActive=rs.Data("IsActive")    // 是否有效
		Set TSStr=rs.Data("TSStr")          // 检验医嘱（多值^分割）
	    Set:OID'="" OID=OID_"!!"_SYSDr
		Continue:(OID="")||(Code="")||(Desc="")
		
		Set ID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.TestCode).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=RstFormat
		Set $p(InputStr,"^",6)=AbFlagS
		Set $p(InputStr,"^",7)=ClDiagnos
		Set $p(InputStr,"^",8)=RefRanges
		Set $p(InputStr,"^",9)=WCode
		Set $p(InputStr,"^",10)=IsActive
		Set $p(InputStr,"^",11)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.TestCode).Update(InputStr,"^")
		If (+flg)>0 {
			Set TCDr=+flg,Count=Count+1
			For indTS=1:1:$l(TSStr,"^") {
				Set TSOID=$p(TSStr,"^",indTS)_"!!"_SYSDr
				Set objTS=##class(DHCMA.Util.EP.TestSet).xGetByOID(TSOID)
				Continue:'$IsObject(objTS)
				Set TSDr=objTS.%Id()
				Set flg1=##class(DHCMA.Util.EPx.TestSetTC).Update("^"_TSDr_"^"_TCDr,"^")
			}
		}
	}
	Quit Count
}

}

/// 名称: DHCMA.Util.EPy.HospitalSrv
/// 描述: HIS接口服务 医院字典
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.EPy.HospitalSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2019-01-17
/// Description:  根据ID同步医院信息
/// Table：       DHCMA.Util.EP.Hospital
/// Input：		  aOID : DHCMA.Util.EP.Hospital.OID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.HospitalSrv).SetHospital()
ClassMethod SetHospital(aOID As %String = "") As %String
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
	
	Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetHospDic")
  	Set sc=rs.Execute(SYSOID)
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
		Set DefHospID=rs.Data("DefHospDR")
		Set DefHospCode=rs.Data("DefHospCode")
		Set DefHospDesc=rs.Data("DefHospDesc")
		Set DefHospIsActive=rs.Data("DefHospIsActive")
		
		//生成医院组数据（默认医院） add by yankai 20210719
		If (DefHospCode'="")&&(DefHospDesc'=""){
			Set GrpInputs="",HospGrpID=""
			Set HospGrpID=$o(^DHCMA.Util.BT.HospGroupI("IdxofCode"," "_$zcvt(DefHospCode,"U"),0))
			Set $p(GrpInputs,"^",1)=HospGrpID
			Set $p(GrpInputs,"^",2)=DefHospCode
			Set $p(GrpInputs,"^",3)=DefHospDesc
			Set $p(GrpInputs,"^",4)=DefHospIsActive
			Set retGrp=##class(DHCMA.Util.BT.HospGroup).Update(GrpInputs,"^")
			Continue:+retGrp<0
		}Else{
			Set retGrp=""	
		}
		
		//生成医院数据
		Set ID="",Desc2="",GroupDr="",RangeID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.Hospital).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set Desc2     = objTmp.BTDesc2
			Set RangeID   = objTmp.BTRangeID
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=Desc2
		Set $p(InputStr,"^",6)=retGrp
		Set $p(InputStr,"^",7)=RangeID
		Set $p(InputStr,"^",8)=IsActive
		Set $p(InputStr,"^",9)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.Hospital).Update(InputStr,"^")
		Set return=+flg
		Quit
	}
	Quit return
}

/// Creator:	  yankai
/// Description:  同步医院信息
/// Table：       DHCMA.Util.EP.Hospital
/// Input：		  aSYSDr : DHCMA.Util.BT.SYSTEM.ID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.HospitalSrv).SyncHospital()
ClassMethod SyncHospital(aSYSDr As %String) As %String
{
	New (aSYSDr)
	Set return=0,Count=0
	
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjById(aSYSDr)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	Quit:SYSExCode'="localhost" return
	
	Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetHospDic")
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
		Set DefHospID=rs.Data("DefHospDR")
		Set DefHospCode=rs.Data("DefHospCode")
		Set DefHospDesc=rs.Data("DefHospDesc")
		Set DefHospIsActive=rs.Data("DefHospIsActive")
		
		//生成医院组数据（默认医院） add by yankai 20210719
		If (DefHospCode'="")&&(DefHospDesc'=""){
			Set GrpInputs="",HospGrpID=""
			Set HospGrpID=$o(^DHCMA.Util.BT.HospGroupI("IdxofCode"," "_$zcvt(DefHospCode,"U"),0))
			Set $p(GrpInputs,"^",1)=HospGrpID
			Set $p(GrpInputs,"^",2)=DefHospCode
			Set $p(GrpInputs,"^",3)=DefHospDesc
			Set $p(GrpInputs,"^",4)=DefHospIsActive
			Set retGrp=##class(DHCMA.Util.BT.HospGroup).Update(GrpInputs,"^")
			Continue:+retGrp<0
		}Else{
			Set retGrp=""	
		}
		
		//生成医院数据
		Set ID="",Desc2="",GroupDr="",RangeID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.Hospital).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set Desc2     = objTmp.BTDesc2
			Set RangeID   = objTmp.BTRangeID
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=Desc2
		Set $p(InputStr,"^",6)=retGrp
		Set $p(InputStr,"^",7)=RangeID
		Set $p(InputStr,"^",8)=IsActive
		Set $p(InputStr,"^",9)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.Hospital).Update(InputStr,"^")
		If (+flg)>0{
			Set Count=Count+1
		}
	}
	Quit Count
}

}

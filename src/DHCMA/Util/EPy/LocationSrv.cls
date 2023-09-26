/// 名称: DHCMA.Util.EPy.LocationSrv
/// 描述: HIS接口服务 科室字典
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.EPy.LocationSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2019-01-17
/// Description:  根据ID同步科室信息
/// Table：       DHCMA.Util.EP.Location
/// Input：		  aOID : DHCMA.Util.EP.Location.OID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.LocationSrv).SetLocation()
ClassMethod SetLocation(aOID As %String = "") As %String
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
	
	Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetLocDic")
  	Set sc=rs.Execute(SYSOID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")                // ID
		Set Code=rs.Data("Code")             // 代码
		Set Desc=rs.Data("Desc")             // 描述
		Set Type=rs.Data("Type")             // 科室类型
		Set HospID=rs.Data("HospID")         // 医院ID
		Set IsActive=rs.Data("IsActive")     // 是否有效
	    
	    //获取科室角色类型
		Set AdmType=$s($d(^PAC("ADMLOC",0,"AdmType","I",OID)):"I",$d(^PAC("ADMLOC",0,"AdmType","O",OID)):"O",$d(^PAC("ADMLOC",0,"AdmType","E",OID)):"E",$d(^PAC("ADMLOC",0,"AdmType","H",OID)):"H",1:"")
		Set:(Type="W")&&(AdmType="") AdmType="I"  //病区护理单元也是住院
	    
	    Set:OID'="" OID=OID_"!!"_SYSDr
	    Set:HospID'="" HospID=HospID_"!!"_SYSDr
		Continue:(OID="")||(Desc="")
		
		Set ID="",Desc2="",HospID="",RangeID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.Location).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set Desc2     = objTmp.BTDesc2
			Set RangeID   = objTmp.BTRangeID
			Set ActUserID = objTmp.BTActUserID
			Set:HospID="" HospID=objTmp.BTHospID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=Desc2
		Set $p(InputStr,"^",6)=Type
		Set $p(InputStr,"^",7)=HospID
		Set $p(InputStr,"^",8)=RangeID
		Set $p(InputStr,"^",9)=IsActive
		Set $p(InputStr,"^",10)=ActUserID
		Set $p(InputStr,"^",11)=AdmType
		Set flg=##class(DHCMA.Util.EPx.Location).Update(InputStr,"^")
		Set return=+flg
		Quit
	}
	Quit return
}

/// Creator:	  yankai
/// CreatDate：   2018-06-14
/// Description:  同步科室信息
/// Table：       DHCMA.Util.EP.Location
/// Input：		  aSYSDr : DHCMA.Util.BT.SYSTEM.ID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.LocationSrv).SyncLocation(1)
ClassMethod SyncLocation(aSYSDr As %String) As %String
{
	New (aSYSDr)
	Set return=0,Count=0
	
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjById(aSYSDr)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	Quit:SYSExCode'="localhost" return
	
	Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncHisSrv:GetLocDic")
  	Set sc=rs.Execute("")
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")                // ID
		Set Code=rs.Data("Code")             // 代码
		Set Desc=rs.Data("Desc")             // 描述
		Set Type=rs.Data("Type")             // 科室类型
		Set HospID=rs.Data("HospID")         // 医院ID
		Set IsActive=rs.Data("IsActive")     // 是否有效
		
		//获取科室角色类型
		Set AdmType=$s($d(^PAC("ADMLOC",0,"AdmType","I",OID)):"I",$d(^PAC("ADMLOC",0,"AdmType","O",OID)):"O",$d(^PAC("ADMLOC",0,"AdmType","E",OID)):"E",$d(^PAC("ADMLOC",0,"AdmType","H",OID)):"H",1:"")
		Set:(Type="W")&&(AdmType="") AdmType="I"  //病区护理单元也是住院
	    
	    Set:OID'="" OID=OID_"!!"_SYSDr
	    Set:HospID'="" HospID=HospID_"!!"_SYSDr
		Continue:(OID="")||(Desc="")
		
		Set ID="",Desc2="",RangeID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.Location).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set Desc2     = objTmp.BTDesc2
			Set RangeID   = objTmp.BTRangeID
			Set ActUserID = objTmp.BTActUserID
			Set:HospID="" HospID=objTmp.BTHospID
			Set:AdmType="" AdmType=objTmp.BTAdmType
		}

		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=Desc2
		Set $p(InputStr,"^",6)=Type
		Set $p(InputStr,"^",7)=HospID
		Set $p(InputStr,"^",8)=RangeID
		Set $p(InputStr,"^",9)=IsActive
		Set $p(InputStr,"^",10)=ActUserID
		Set $p(InputStr,"^",11)=AdmType
		Set flg=##class(DHCMA.Util.EPx.Location).Update(InputStr,"^")
		If (+flg)>0{
			Set Count=Count+1
		}
	}
	Quit Count
}

}

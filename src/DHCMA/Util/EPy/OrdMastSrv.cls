/// 名称: DHCMA.Util.EPy.OrdMastSrv
/// 描述: HIS接口服务 医嘱项字典
/// 编写者：zhufei
/// 编写日期: 2019-01-17
Class DHCMA.Util.EPy.OrdMastSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2019-01-17
/// Description:  根据ID同步医嘱项信息
/// Table：       DHCMA.Util.EP.OrdMast
/// Input：		  aOID : DHCMA.Util.EP.OrdMast.OID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.OrdMastSrv).SetOrdMast()
ClassMethod SetOrdMast(aOID As %String = "") As %String
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
	
	Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncOrdSrv:GetOrdMastDic")
  	Set sc=rs.Execute(SYSOID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")                // ID
		Set Code=rs.Data("Code")             // 医嘱代码
		Set Desc=rs.Data("Desc")             // 医嘱名称
		Set OrdCatDesc=rs.Data("OrdCatDesc") // 医嘱分类
		Set OrdType=rs.Data("OrdType")       // 医嘱类型
		Set IsActive=rs.Data("IsActive")     // 是否有效
	    Set:OID'="" OID=OID_"!!"_SYSDr
		Continue:(OID="")||(Code="")||(Desc="")
		
		Set ID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.OrdMast).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=OrdCatDesc
		Set $p(InputStr,"^",6)=OrdType
		Set $p(InputStr,"^",7)=IsActive
		Set $p(InputStr,"^",8)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.OrdMast).Update(InputStr,"^")
		Set return=+flg
		Quit
    }
	Quit return
}

/// Creator:	  zhufei
/// CreatDate：   2019-01-17
/// Description:  同步医嘱项信息
/// Table：       DHCMA.Util.EP.OrdMast
/// Input：		  aSYSDr : DHCMA.Util.BT.SYSTEM.ID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.EPy.OrdMastSrv).SyncOrdMast()
ClassMethod SyncOrdMast(aSYSDr As %String) As %String
{
	New (aSYSDr)
	Set return=0,Count=0
	Quit:(aSYSDr="") return
	
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjById(aSYSDr)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	Quit:SYSExCode'="localhost" return
	
	Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.SyncOrdSrv:GetOrdMastDic")
  	Set sc=rs.Execute("")
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set OID=rs.Data("ID")               // ID
		Set Code=rs.Data("Code")            // 医嘱代码
		Set Desc=rs.Data("Desc")            // 医嘱名称
		Set CatDesc=rs.Data("OrdCatDesc")   // 医嘱分类
		Set Type=rs.Data("OrdType")         // 医嘱类型
		Set IsActive=rs.Data("IsActive")    // 是否有效
	    Set:OID'="" OID=OID_"!!"_SYSDr
		Continue:(OID="")||(Code="")||(Desc="")
		
		Set ID="",ActUserID=""
		Set objTmp=##class(DHCMA.Util.EP.OrdMast).xGetByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set ActUserID = objTmp.BTActUserID
		}
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=ID
		Set $p(InputStr,"^",2)=OID
		Set $p(InputStr,"^",3)=Code
		Set $p(InputStr,"^",4)=Desc
		Set $p(InputStr,"^",5)=CatDesc
		Set $p(InputStr,"^",6)=Type
		Set $p(InputStr,"^",7)=IsActive
		Set $p(InputStr,"^",8)=ActUserID
		Set flg=##class(DHCMA.Util.EPx.OrdMast).Update(InputStr,"^")
		If (+flg)>0{
			Set Count=Count+1
		}
	}
	Quit Count
}

}

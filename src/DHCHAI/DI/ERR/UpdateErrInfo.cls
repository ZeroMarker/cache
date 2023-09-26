/// 名称: DHCHAI.DI.ERR.UpdateErrInfo
/// 描述: 处理IsActive错误数据
/// 编写者：zhufei
/// 编写日期: 2018-03-28
Class DHCHAI.DI.ERR.UpdateErrInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Do ##class(DHCHAI.DI.ERR.UpdateErrInfo).Test()
ClassMethod Test()
{
	Set flg=..UpdateRBReport()
	w "RBReportCnt="_flg,!
	
	Set flg=..UpdateLabVisitReport()
	w "VisitReportCnt="_flg,!
	
	Set flg=..UpdateLabVisitNumber()
	w "VisitNumberCnt="_flg,!
	
	Set flg=..UpdateOperAnaes()
	w "OperAnaesCnt="_flg,!
	
	Quit "OK"
}

ClassMethod UpdateRBReport()
{
	New
	Set xID="",Count=0
	For {
		Set xID=$o(^DHCHAI.DP.RBReportD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.RBReport).GetObjById(xID)
		Continue:'$IsObject(obj)
		Set SCode=obj.RBSCode
		Set ChkStatus=obj.RBChkStatus
		Set tIsActive=obj.RBIsActive
		
		//N^未写报告、I^已有图像、R^已录入、V^已审核、S^已发布、D^全科会诊
		Set MapStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"RBRepStatus",ChkStatus)
		Set:MapStatus="" MapStatus=ChkStatus
		Set IsActive=0
		Set:(MapStatus="V")||(MapStatus="S") IsActive=1
		Continue:IsActive=tIsActive
		
		Set Count=Count+1
		
		Set obj=##class(DHCHAI.DP.RBReport).%OpenId(xID)
		Continue:'$IsObject(obj)
		Set obj.RBIsActive		= IsActive
		Set sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc)
	   		Set return=-1
		}else{
			Set return=obj.%Id()
		}
		Do obj.%Close()
    }
    Quit Count
}

ClassMethod UpdateLabVisitReport()
{
	New
	Set xID="",Count=0
	For {
		Set xID=$o(^DHCHAI.DP.LabVisitReportD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.LabVisitReport).GetObjById(xID)
		Continue:'$IsObject(obj)
		Set SCode=obj.LabSCode
		Set LabStatus=obj.LabStatus
		Set tIsActive=obj.LabIsActive
		
		//检验1.0（A审核）
		//检验2.0（1登记，2初审，3审核，4复查，5取消审核，6作废）
		Set MapStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LabRepStatus",LabStatus)
		Set:MapStatus="" MapStatus=LabStatus
	    Set IsActive=0
		Set:(MapStatus="A") IsActive=1
		Set:(MapStatus=2)||(MapStatus=3)||(MapStatus=4) IsActive=1
		Continue:IsActive=tIsActive
		
		Set Count=Count+1
		
		Set obj=##class(DHCHAI.DP.LabVisitReport).%OpenId(xID)
		Continue:'$IsObject(obj)
		Set obj.LabIsActive		 = IsActive
		Set sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc)
	   		Set return=-1
		}else{
			Set return=obj.%Id()
		}
		Do obj.%Close()
    }
    Quit Count
}

ClassMethod UpdateLabVisitNumber()
{
	New
	Set xID="",Count=0
	For {
		Set xID=$o(^DHCHAI.DP.LabVisitNumberD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xID)
		Continue:'$IsObject(obj)
		Set SCode=obj.LabSCode
		Set tIsActive=obj.LabIsActive
		
	    Set IsActive=1
		Continue:IsActive=tIsActive
		
		Set Count=Count+1
		
		Set obj=##class(DHCHAI.DP.LabVisitNumber).%OpenId(xID)
		Continue:'$IsObject(obj)
		Set obj.LabIsActive		 = IsActive
		Set sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc)
	   		Set return=-1
		}else{
			Set return=obj.%Id()
		}
		Do obj.%Close()
    }
    Quit Count
}

ClassMethod UpdateOperAnaes()
{
	New
	Set xID="",Count=0
	For {
		Set xID=$o(^DHCHAI.DP.OROperAnaesD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
		Continue:'$IsObject(obj)
		Set SCode=obj.ORSCode
		Set OperStatus=obj.OROperStatus
		Set tIsActive=obj.ORIsActive
		
		//F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消
		Set MapStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"OperStatus",OperStatus)
		Set:MapStatus="" MapStatus=OperStatus
	    Set IsActive=0
		Set:MapStatus="F" IsActive=1
		Continue:IsActive=tIsActive
		
		Set Count=Count+1
		
		Set obj=##class(DHCHAI.DP.LabVisitNumber).%OpenId(xID)
		Continue:'$IsObject(obj)
		Set obj.LabIsActive		 = IsActive
		Set sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc)
	   		Set return=-1
		}else{
			Set return=obj.%Id()
		}
		Do obj.%Close()
    }
    Quit Count
}

}

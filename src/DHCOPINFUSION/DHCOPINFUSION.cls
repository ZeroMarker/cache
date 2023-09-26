/// DHCOPINFUSION.DHCOPINFUSION
Class DHCOPINFUSION.DHCOPINFUSION Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCOPINFUSION";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://172.21.21.120/dthealth/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com/DHCInfusion";

/// TODO: add arguments and implementation.
/// Test
ClassMethod Test() As %String [ WebMethod ]
{
	Quit "Te11st"
}

ClassMethod Logon(User As %String, Pass As %String) As %String [ WebMethod ]
{
	//登录信息
	s ret=##class(web.DHCIFComm).Logon(User,Pass)
	q ret
}

ClassMethod DelSeatNo(SeatNo As %String) As %String [ WebMethod ]
{
	//处理病人呼叫
	s ret=##class(web.DHCIFCallSeat).DelSeatNo(SeatNo)
	q ret
}

ClassMethod GetDosAgeStatus(RowId As %String, No As %String) As %String [ WebMethod ]
{
	//取配液状态
	s ret=##class(web.DHCIFDosAge).GetDosAgeStatus(RowId,No)
	q ret
}

ClassMethod ExecDosAge(RowId As %String, No As %String, UserDr As %String, CTLodId As %String, Item As %String) As %String [ WebMethod ]
{
	//配液确认
	s ret=##class(web.DHCIFDosAge).ExecDosAge(RowId,No,UserDr,CTLodId,Item)
	q ret
}

ClassMethod CancelDosAge(RowId As %String, No As %String, Item As %String) As %String [ WebMethod ]
{
	//配液取消
	s ret=##class(web.DHCIFDosAge).CancelDosAge(RowId,No,Item)
	q ret
}

ClassMethod GetDosAgeOrdItem(RowId As %String, No As %String) As %String [ WebMethod ]
{
	//配液医嘱信息
	s ret=##class(web.DHCIFDosAge).GetDosAgeOrdItem(RowId,No)
	q ret
}

ClassMethod PatInfo(RegNo As %String) As %String [ WebMethod ]
{
	//病人信息
	s ret=##class(web.DHCIFComm).PatInfo(RegNo)
	q ret
}

ClassMethod GetRelationOrd(RowId As %String, No As %String) As %String [ WebMethod ]
{
	//根据条码取医嘱
	s ret=##class(web.DHCIFExec).GetRelationOrd(RowId,No)
	q ret
}

ClassMethod ScanExec(RowId As %String, No As %String, User As %String, CTLocId As %String, Item As %String, FailureNum As %String) As %String [ WebMethod ]
{
	//扫码执行
	s ret=##class(web.DHCIFExec).ScanExec(RowId,No,User,CTLocId,Item,FailureNum)
	q ret
}

ClassMethod UnExcute(RowId As %String, UserId As %String) As %String [ WebMethod ]
{
	//撤销执行
	//
	s ln=$L(RowId,"!")
	for i=1:1:ln-1
	{
		s Orw=$P(RowId,"!",i)
	 	s ret=##class(web.DHCIFExec).UnExec(Orw,UserId)
	}
	q ret
}

ClassMethod InsertWork(OeoreId As %String, Item As %String, UserId As %String, CTLocId As %String) As %String [ WebMethod ]
{
	//插入工作量
	s ret=##class(web.DHCIFWorkLoad).InsertWork(OeoreId,Item,UserId,CTLocId)
	q ret
}

ClassMethod DeleteWork(OeoreId As %String, Item As %String) As %String [ WebMethod ]
{
	//撤销工作量
	s ret=##class(web.DHCIFWorkLoad).DeleteWork(OeoreId,Item)
	q ret
}

ClassMethod InfusionPrefinalDT(Distant As %String, OeoreId As %String) As %String [ WebMethod ]
{
	//预计输液时间
	s ret=##class(web.DHCIFExec).InfusionPrefinalDT(Distant,OeoreId)
	q ret
}

ClassMethod InfusionStop(OeoreId As %String) As %String [ WebMethod ]
{
	//终止输液
	s ret=##class(web.DHCIFExec).InfusionStop(OeoreId)
	q ret
}

ClassMethod InfusionStatus(RegNo As %String) As %String [ WebMethod ]
{
	//病人输液状态返回当前输液 
	s ret=##class(web.DHCIFExec).InfusionStatus(RegNo)
	q ret
}

ClassMethod InfusionFinish(OeoreId As %String, CTLocId As %String, UserId As %String) As %String [ WebMethod ]
{
	// 输液完成
	s ret=##class(web.DHCIFExec).InfusionFinish(OeoreId,CTLocId,UserId)
	q ret
}

ClassMethod InfusionAwoke(CTLocId As %String, DefVarTyp As %String) As %String [ WebMethod ]
{
	//输液完成时间低于15分钟提醒
	s ret=##class(web.DHCIFExec).InfusionAwoke(CTLocId,DefVarTyp)
	q ret
}

ClassMethod GetQueryData(QueryName As %String, Parr As %String) As %String [ WebMethod ]
{
	//通用Query查询
    s ret=##Class(web.DHCIFComm).GetQueryData(QueryName, Parr)
    q ret
}

ClassMethod GetOrd(RegNo As %String, DefVarTyp As %String) As %String [ WebMethod ]
{
	//取病人三天内所有输液(不包括非当天执行) 
	s ret=##class(web.DHCIFExec).GetOrdData(RegNo,DefVarTyp)
	q ret
}

}

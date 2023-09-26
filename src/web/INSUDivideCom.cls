Import SQLUser

Class web.INSUDivideCom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 56;

/// 检查该病人、该帐单的状态
ClassMethod CheckStatus(itmjs As %Library.String = "", itmjsex As %Library.String = "", AdmRowid As %String, BillNo As %String)
{
	s ret=##class(web.INSUDivideSgSvr).CheckStatus(AdmRowid,BillNo)
	q ret
}

/// 检查该病人、该帐单的状态
ClassMethod GetDivInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", DivRowid As %String)
{
	s ret=##class(web.INSUDivideCtl).GetDivInfo(DivRowid)
	q ret
}

/// 查询帐单的费用明细
ClassMethod BillItems(itmjs As %Library.String = "", itmjsex As %Library.String = "", BillNo As %String, InsuType As %String)
{
	s ret=##class(web.INSUDivideSgSvr).BillItems(BillNo, InsuType)
	q ret
}

/// 取分类
ClassMethod ListCase(itmjs As %Library.String = "", itmjsex As %Library.String = "", DalJust As %String)
{
	s ret=##class(web.INSUDivideSgSvr).ListCase(DalJust)
	q ret
}

/// 取明细
ClassMethod List(itmjs As %Library.String = "", itmjsex As %Library.String = "", i As %String, DalJust As %String)
{
	s ret=##class(web.INSUDivideSgSvr).list(i,DalJust)
	q ret
}

/// 保存医保结算信息
ClassMethod InsertDivInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %String)
{
	s ret=##class(web.INSUDivideCtl).InsertDivInfo(InString)
	q ret
}

/// 取系统时间
ClassMethod GetSysDate(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	s ret=##class(web.INSUBase).GetSysDate()
	q ret
}

/// 修改结算信息状态
ClassMethod UpdateDivActive(itmjs As %Library.String = "", itmjsex As %Library.String = "", DivRowid As %String, ActiveFlag As %String, User As %String, InvPrtDr As %String)
{
	s ret=##class(web.INSUDivideCtl).UpdateDivActive(DivRowid,ActiveFlag,User,InvPrtDr)
	q ret
}

/// 取医保支付方式
ClassMethod GetInsuPayMode(itmjs As %Library.String = "", itmjsex As %Library.String = "", Code As %Library.String = "")
{
	s ret=##class(web.INSUDivideSvr).GetInsuPayMode(Code)
	q ret
}

/// 修改结算信息状态
ClassMethod UpdateDivFlag(itmjs As %Library.String = "", itmjsex As %Library.String = "", DivRowid As %String, ActiveFlag As %String, User As %String, InvPrtDr As %String, HisDivId As %String)
{
    Tstart
	s ret=##class(web.INSUDivideCtl).UpdateDivActive(DivRowid,ActiveFlag,User,InvPrtDr)
	i ret'=0 TRo
	q:ret'=0 ret
	;s ret=##class(INSUHisDivideCtl).AbortHisDiv(HisDivId,ActiveFlag,InvPrtDr)
	;i ret'=0 TRo
	;q:ret'=0 ret
	TCommit
	q ret
}

}

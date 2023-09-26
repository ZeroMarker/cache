Import SQLUser

/// 名称: 		BILL.EINV.BL.COM.InvPrintDetailsCtl.cls
/// 描述: 		计费电子发票打印数据维护
/// 编写日期: 	2021-11-26
Class BILL.EINV.BL.COM.InvPrintDetailsCtl Extends %RegisteredObject
{

/// 保存打印发票明细数据	
ClassMethod SavePrintDataResult(Input As %String) As %String
{
	s rtnFlg="-1"
	s PrintObj=##class(BILL.EINV.PO.InvPrintDetails).%New()
	s PrintObj.InvUpRowid=$p(Input,"^",1)
	s PrintObj.PayAdmType=$p(Input,"^",2)
	s PrintObj.HISPrtRowID=$p(Input,"^",3)
	s PrintObj.InvPrintDate=+$h
	s PrintObj.InvPrintTime=$p($h,",",2)
	s PrintObj.InvPrintType=$p(Input,"^",4)
	s PrintObj.InvPrintUsr=$p(Input,"^",5)
	s sc=PrintObj.%Save()
	if ($System.Status.IsError(sc)) {
		s rtnFlg="-1"_"^"_$System.Status.GetErrorText(sc)
	}else{
		s rtnFlg="0"
		}
	q rtnFlg
}

}

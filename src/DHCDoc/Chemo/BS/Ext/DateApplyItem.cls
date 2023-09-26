/// CTOR: QP
/// DATE: 2020-08-14
/// DESC: 化疗日期申请化疗项目操作类
Class DHCDoc.Chemo.BS.Ext.DateApplyItem Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-08-14
/// DESC: 保存
/// IN  : 
/// OUT : >0成功，其余失败
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.DateApplyItem).Save()
ClassMethod Save(ItemDR, PDAID)
{
	s mRtn=0
	Q:(ItemDR="")||(PDAID="") -140
	//通过ItemDR和PDAID,一定能知道是对应的哪个Order
	s a=##class(User.ChemoPlanDateApplyItem).%New(PDAID)
	d a.PDAIParRefSetObjectId(PDAID)
	Q:'$ISObject(a) -140
	s b=##class(User.ChemoPlanItem).%OpenId(ItemDR)
	Q:'$ISObject(b) -140
	d a.PGIItemDRSetObjectId(ItemDR)
	s a.PGIArcimDR=b.PGIArcimDR
	s a.PGIDosage=b.PGIDosage
	s a.PGIDosageUomDR=b.PGIDosageUomDR
	s a.PGIFreqDR=b.PGIFreqDR
	s a.PGIInstrucDR=b.PGIInstrucDR
	s a.PGIDuratDR=b.PGIDuratDR
	s a.PGIQty=b.PGIQty
	s a.PGIUomDR=b.PGIUomDR
	s a.PGILinkItem=b.PGILinkItem
	s a.PGINote=b.PGINote
	s a.PGIPriorDR=b.PGIPriorDR
	s a.PGISimpleDR=b.PGISimpleDR
	s a.PGIRemark=b.PGIRemark
	s a.PGIRecLoc=b.PGIRecLoc
	s a.PGIStage=b.PGIStage
	s a.PGIFlowRate=b.PGIFlowRate
	s a.PGIFlowRateDR=b.PGIFlowRateDR
	s a.PGISkinTest=b.PGISkinTest
	s a.PGISkinAction=b.PGISkinAction
	s a.PGITplGroupItem=b.PGITplGroupItem
	s a.PGIBSAUnit=b.PGIBSAUnit
	s a.PGIBSA=b.PGIBSA
	s a.PGIMainDrug=##class(DHCDoc.Chemo.COM.Func2).IsMainDrug(ItemDR)
	s a.PGIFormula=b.PGIFormula
	s a.PGIGFR=b.PGIGFR
	s a.PGIBSAUnitSTD=b.PGIBSAUnitSTD
	s a.PGISeqno=b.PGISeqno
	s sc=a.%Save()
	if ($$$ISERR(sc)) {
		//d $System.Status.DisplayError(sc)
		s mRtn=-140
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	d b.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-14
/// DESC: 保存
/// IN  : 
/// OUT : >0成功，其余失败
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.DateApplyItem).SaveByOrder("203||31")
ClassMethod SaveByOrder(oeori)
{
	Q:oeori="" 0
	Q:'$d(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori)) 0	
	s POID=$o(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori,""))
	Q:POID="" 0	
	s PDAID=$P(^BS.DOC.Chemo.PlanOrderD(POID),"^",7)
	Q:PDAID="" 0
	s ItemDR=$P(^BS.DOC.Chemo.PlanOrderD(POID),"^",2)
	Q:ItemDR="" 0
	s rtn=..Save(ItemDR,PDAID)
	q:rtn<0 rtn
	
	Q 0
}

}

/// CTOR: QP
/// DATE: 2021-01-08
/// DESC: 化疗项目日期排序
Class DHCDoc.Chemo.BS.Ext.PlanItemSort Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-01-08
/// DESC: 保存
/// IN  : 	
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.PlanItemSort).Save("")
ClassMethod Save(ISAry)
{
	s mRtn=0
	s PRNum=$o(ISAry(""),-1)
	Q:PRNum="" mRtn
	s ID=ISAry(1)
	s ChemoDate=##class(websys.Conversions).DateHtmlToLogical(ISAry(2))
	i ID="" {
		s ID=$o(^BS.DOC.Chemo.PlanItemSortI("ItemChemoDate",ISAry(5),ChemoDate,""))
	}
	i ID="" {
		s a=##class(User.ChemoPlanItemSort).%New()
	} else{
		s a=##class(User.ChemoPlanItemSort).%OpenId(ID)
	}
	Q:'$ISObject(a) -158
	
	s a.ISChemoDate=ChemoDate
	s a.ISSeqno=ISAry(3)
	d a.ISPSIDSetObjectId(ISAry(4))
	d a.ISItemIDSetObjectId(ISAry(5))
	
	s sc=a.%Save()
	if ($$$ISERR(sc)) {
		//d $System.Status.DisplayError(sc)
		s mRtn=-158
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-01-08
/// DESC: 得到顺序
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.PlanItemSort).GetSeqno()
ClassMethod GetSeqno(ChemoDate, ItemID) As %String
{
	s mRtn=""
	Q:(ChemoDate="")||(ItemID="") mRtn
	s ChemoDate=##class(websys.Conversions).DateHtmlToLogical(ChemoDate)
	
	s ISID=$o(^BS.DOC.Chemo.PlanItemSortI("ItemChemoDate",ItemID,ChemoDate,""))
	Q:ISID="" mRtn
	s mRtn=$p(^BS.DOC.Chemo.PlanItemSortD(ISID),"^",2)
	
	Q mRtn
}

}

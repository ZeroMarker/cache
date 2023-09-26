Class dhc.bonus.module.uWorkUnitItemRate Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.bonus.module.uWorkUnitItemRate).IfRep(10001,10011)
ClassMethod IfRep(bonusunitDr, WorkItemDr, ItemRate) As %String
{
	n (bonusunitDr,WorkItemDr,ItemRate)
	s sqlStr="SELECT *  from dhc_bonus_module.WorkUnitItemRate where BonusUnitID ="_bonusunitDr_" and BonusWorkItemID ="_WorkItemDr_"and ItemRate ="_ItemRate
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid = result.Data("WorkUnitItemRateID")
	}
	q rowid
}

/// w ##class(dhc.bonus.module.uWorkUnitItemRate).List("","","","",0,25,"10001","10011","3.1415")
/// w ##class(dhc.bonus.module.uWorkUnitItemRate).List("","","","",0,25,"","","")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, bonusunitDr, WorkItemDr, ItemRate) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit, bonusunitDr,WorkItemDr,ItemRate)
	
	s sqlStr="SELECT a.WorkUnitItemRateID WorkUnitItemRateID,a.BonusUnitID BonusUnitID,b.BonusUnitName BonusUnitName,c.BonusWorkItemID BonusWorkItemID,c.WorkItemName WorkItemName,a.ItemRate ItemRate,a.UpateDate UpateDate FROM dhc_bonus_data.BonusUnit b,dhc_bonus_module.WorkUnitItemRate a,dhc_bonus_module.BonusWorkItem c"
	s whereStr=" where b.BonusUnitID=a.BonusUnitID AND a.BonusWorkItemID=c.BonusWorkItemID"
	
	i bonusunitDr'="" d
	.s whereStr=whereStr_" and a.BonusUnitID="_bonusunitDr
	i WorkItemDr'="" d
	.s whereStr=whereStr_" and c.BonusWorkItemID="_WorkItemDr
	i ItemRate'="" d
	.s whereStr=whereStr_" and ItemRate="_ItemRate
	
	s sortStr=" ORDER BY a.WorkUnitItemRateID desc"
	s sqlStr=sqlStr_whereStr_sortStr
	
	
	;s ^TMPWYY(1)=":::"_sqlStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^bonusunitid^bonusunit^bonusworkItemid^bonusworkItem^itemrate^upatedate"
	
	//取结构
	While(result.Next()){
		
		s rowid= result.Data("WorkUnitItemRateID")
		s bonusunitid = result.Data("BonusUnitID")
		s bonusunit = result.Data("BonusUnitName")
		s bonusworkItemid = result.Data("BonusWorkItemID")
		s bonusworkItem = result.Data("WorkItemName")
		s itemrate = result.Data("ItemRate")
		s upatedate = result.Data("UpateDate")
		
		/*
		i bonusunitDr'="" d
		.q:bonusunitid'=bonusunitDr
		i WorkItemDr'="" d
		.q:bonusworkItemid'=WorkItemDr
		i ItemRate'="" d
		.q:itemrate'=ItemRate
		*/
		
		s tmp=rowid_"^"_bonusunitid_"^"_bonusunit_"^"_bonusworkItemid_"^"_bonusworkItem_"^"_itemrate_"^"_upatedate
		
		
		
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.bonus.module.uWorkUnitItemRate).InsertRec(1,2,3)
ClassMethod InsertRec(bonusunitDr, WorkItemDr, ItemRate) As %String
{
	
	n (bonusunitDr,WorkItemDr,ItemRate)
	
	s rowid=0
	s rowid=..IfRep(bonusunitDr,WorkItemDr,ItemRate)
	q:rowid>0 "RepCode"
	s tmpdate=$zdt($h,3,1)
	s date=tmpdate
	
	
	&sql(insert into dhc_bonus_module.WorkUnitItemRate(BonusUnitID,BonusWorkItemID,ItemRate,UpateDate) values(:bonusunitDr,:WorkItemDr,:ItemRate,:date))
	q SQLCODE
}

/// w ##class(dhc.bonus.module.uWorkUnitItemRate).UpdateRec(9,0,7,4)
ClassMethod UpdateRec(rowid, bonusunitDr, WorkItemDr, ItemRate) As %String
{
	
	n (rowid,bonusunitDr,WorkItemDr,ItemRate)
	
	s id=rowid 
	
	s tmp=0
	s tmp=..IfRep(bonusunitDr,WorkItemDr,ItemRate)
	q:tmp>0 "RepCode"
	s tmpdate=$zdt($h,3,1)
	s date=tmpdate
	
	
	
	&sql(update dhc_bonus_module.WorkUnitItemRate set BonusUnitID=:bonusunitDr,BonusWorkItemID=:WorkItemDr,ItemRate=:ItemRate,UpateDate=:date where %ID=:id)
	q SQLCODE
}

/// w ##class(dhc.bonus.udata.uSchemeTarget).Delete(965)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&sql(delete from dhc_bonus_module.WorkUnitItemRate where %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus8571.uWorkUnitIt6BFES</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

Class dhc.bonus.umodule.uBonusExpItemMap Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//w ##class(dhc.bonus.umodule.uBonusExpItemMap).List("","",0,10,"",80)

ClassMethod IfRepBonusExpItemMap(BonusTarget, BonusExpendItem) As %String
{
	new (BonusTarget, BonusExpendItem)
	s rowid=0 
	s rowid=$o(^dhcbsBonusExpItemMapI("BonusExpendMapIdx",BonusTarget,BonusExpendItem,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

ClassMethod List(sortField, sortDir, start, limit, BonusTarget, BonusExpendItem) As %String
{
	n (sortField, sortDir, start, limit,BonusTarget,BonusExpendItem)

	s sqlStr="select BonusExpItemMapID ,BonusExpendItemID->ItemName,BonusTargetID->BonusTargetName"
	_",ItemRate,UpdateDate, BonusExpendItemID->SuperItemID->ItemName supItemName"
	 _" from dhc_bonus_module.BonusExpItemMap where 1=1 "

	i BonusTarget'="" s sqlStr=sqlStr_" and BonusTargetID='"_BonusTarget_"'"
	i BonusExpendItem'="" s sqlStr=sqlStr_" and BonusExpendItemID='"_BonusExpendItem_"'"
	s sqlStr=sqlStr_"  order by BonusTargetID->BonusTargetCode desc" 
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	//w sqlStr,!
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^ItemName^BonusTargetName^ItemRate^UpdateDate"
	While(result.Next())
	{
	s rowid= result.Data("BonusExpItemMapID")
	s ItemName= result.Data("ItemName")
	s BonusTargetName= result.Data("BonusTargetName")
	s ItemRate= result.Data("ItemRate")
	s UpdateDate= result.Data("UpdateDate") ; 
	s supItemName= result.Data("supItemName")

	s temp=rowid_"^"_supItemName_"-"_ItemName_"^"_BonusTargetName_"^"_ItemRate_"^"_UpdateDate
	i (count>=start)&(count<=end) d
	.d json.InsertRowData(temp)
	s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

ClassMethod InsertRec(BonusTarget, BonusExpendItem, ItemRate) As %String
{
	n (BonusTarget, BonusExpendItem, ItemRate)
	
   
	s rowid=0
	s rowid=..IfRepBonusExpItemMap(BonusTarget, BonusExpendItem)
	q:rowid>0 "RepCode"
	s UpdateDate=$zd($h,3)
	&sql(INSERT INTO dhc_bonus_module.BonusExpItemMap(BonusTargetID ,BonusExpendItemID,ItemRate , UpdateDate)
	 VALUES (:BonusTarget,:BonusExpendItem,:ItemRate,:UpdateDate ))

	q SQLCODE
}

ClassMethod Delete(rowid) As %String
{
	&sql( DELETE FROM dhc_bonus_module.BonusExpItemMap WHERE %ID=:rowid)

	q SQLCODE
}

/// Others:w ##class(dhc.bonus.umodule.uBonusIncomeRate).UpdateRec(3,"","","","","","","","")
ClassMethod UpdateRec(rowid, BonusTarget, BonusExpendItem, ItemRate) As %String
{
	n (rowid, BonusTarget, BonusExpendItem, ItemRate)

    s UpdateDate=$zd($h,3)
	i BonusTarget =""   s BonusTarget= $list(^dhcbsBonusExpItemMapD(rowid),2)
 	i BonusExpendItem =""  s BonusExpendItem = $list(^dhcbsBonusExpItemMapD(rowid),3)
 	i ItemRate =""  s ItemRate = $list(^dhcbsBonusExpItemMapD(rowid),4)
    

 	s tmpRowid=0
	s tmpRowid=..IfRepBonusExpItemMap(BonusTarget, BonusExpendItem)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	
	&sql(UPDATE dhc_bonus_module.BonusExpItemMap(BonusTargetID,BonusExpendItemID,ItemRate,UpdateDate) VALUES (:BonusTarget,:BonusExpendItem,:ItemRate,:UpdateDate) where %ID=:rowid)
	q SQLCODE
}

//w ##class(dhc.bonus.umodule.uBonusExpItemMap).getBonusTarget(0,25,"")

ClassMethod getBonusTarget(start, limit, str) As %String
{
	n (start,limit,str)
   
   s sqlStr=" SELECT BonusTargetID,BonusTargetName FROM dhc_bonus_data.BonusTarget where DataSource=11 "
	i str'="" s sqlStr=sqlStr_" and BonusTargetName LIKE '%"_str_"%' "
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	//w sqlStr,!
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	While(result.Next())
	{
	s rowid= result.Data("BonusTargetID")
	s name= result.Data("BonusTargetName")
	s temp=rowid_"^"_name
	i (count>=start)&(count<=end) d
	.d json.InsertRowData(temp)
	s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

//w ##class(dhc.bonus.umodule.uBonusExpItemMap).getBonusExpendItem(0,25,"")

ClassMethod getBonusExpendItem(start, limit, str) As %String
{
	n (start,limit,str)
   
   s sqlStr=" SELECT BonusExpendItemID,ItemName , SuperItemID->ItemName supItemName FROM dhc_bonus_module.BonusExpendItem WHERE IsLast=1 "
	i str'="" s sqlStr=sqlStr_" and ItemName LIKE '%"_str_"%' "
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	//w sqlStr,!
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	While(result.Next())
	{
	s rowid= result.Data("BonusExpendItemID")
	s name= result.Data("ItemName")
	s supItemName= result.Data("supItemName")
	s temp=rowid_"^"_supItemName_"-"_name
	i (count>=start)&(count<=end) d
	.d json.InsertRowData(temp)
	s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus866B.uBonusExpIt6419S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

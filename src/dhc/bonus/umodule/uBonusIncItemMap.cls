Class dhc.bonus.umodule.uBonusIncItemMap Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//w ##class(dhc.bonus.umodule.uBonusIncItemMap).IfRepBonusIncMapIdx(1,10)

ClassMethod IfRepBonusIncMapIdx(BonusTarget, BonusIncItemID) As %String
{
	new (BonusTarget,BonusIncItemID)
	s rowid=0 
	s rowid=$o(^dhcbsBonusIncItemI("BonusIncMapIdx",BonusTarget, BonusIncItemID,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

//w ##class(dhc.bonus.umodule.uBonusIncItemMap).List("","",0,25,"","")

ClassMethod List(sortField, sortDir, start, limit, BonusTarget, BonusIncItemID) As %String
{
	n (sortField, sortDir, start, limit, BonusTarget, BonusIncItemID)

	s sqlStr="SELECT BonusIncItemMapID ,BonusTargetID->BonusTargetName,BonusIncItemID->ItemName "
	_",MakeBillRate,ExecuteRate,SickRate ,UpdateDate,ItemType"
	_" FROM dhc_bonus_module.BonusIncItemMap  "
	        _" where 1=1"

	i BonusTarget'="" s sqlStr=sqlStr_" and BonusTargetID='"_BonusTarget_"'"
	i BonusIncItemID'="" s sqlStr=sqlStr_" and BonusIncItemID='"_BonusIncItemID_"'"
	s sqlStr=sqlStr_"  order by BonusIncItemMapID desc " 
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	//w sqlStr,!
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^BonusTargetName^TARECDesc^MakeBillRate^ExecuteRate^SickRate^UpdateDate^dataType"
	While(result.Next())
	{
	s rowid= result.Data("BonusIncItemMapID")
	s BonusTargetName= result.Data("BonusTargetName")
	s TARECDesc= result.Data("ItemName")
	s MakeBillRate= result.Data("MakeBillRate")
	s ExecuteRate= result.Data("ExecuteRate")
	s SickRate= result.Data("SickRate")
    s UpdateDate= result.Data("UpdateDate")
    s ItemType = result.Data("ItemType")
    i ItemType="MX" s ItemType="开单"
    i ItemType="EX" s ItemType="执行"
    
	s temp=rowid_"^"_BonusTargetName_"^"_TARECDesc_"^"_MakeBillRate_"^"_ExecuteRate_"^"_SickRate_"^"_UpdateDate_"^"_ItemType
	i (count>=start)&(count<=end) d
	.d json.InsertRowData(temp)
	s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

//w ##class(dhc.bonus.umodule.uBonusIncItemMap).InsertRec(3,10,1,1,1)

ClassMethod InsertRec(BonusTarget, BonusIncItemID, MakeBillRate, ExecuteRate, SickRate) As %String
{
	n (BonusTarget,BonusIncItemID, MakeBillRate,ExecuteRate,SickRate)
	
   
	s rowid=0
	k ^cwtemp
	s ^cwtemp=BonusTarget_"^"_BonusIncItemID
	s rowid=..IfRepBonusIncMapIdx(BonusTarget, BonusIncItemID)
	q:rowid>0 "RepCode"
	s UpdateDate=$ZDate($P($H,",",1),3)_" "_$ZTime($P($H,",",2))	 
	&sql(INSERT INTO dhc_bonus_module.BonusIncItemMap(BonusTargetID,BonusIncItemID, MakeBillRate,ExecuteRate,SickRate,UpdateDate)
	 VALUES (:BonusTarget,:BonusIncItemID, :MakeBillRate,:ExecuteRate,:SickRate,:UpdateDate ))

	q SQLCODE
}

ClassMethod Delete(rowid) As %String
{
	&sql( DELETE FROM dhc_bonus_module.BonusIncItemMap WHERE %ID=:rowid)

	q SQLCODE
}

//w ##class(dhc.bonus.umodule.uBonusIncItemMap).UpdateRec(50,"","","","","")

ClassMethod UpdateRec(rowid, BonusTarget, BonusIncItemID, MakeBillRate, ExecuteRate, dataType) As %String
{
	n (rowid,BonusTarget,BonusIncItemID, MakeBillRate,ExecuteRate,dataType)
    s ^zlg524=rowid_","_BonusTarget_","_BonusIncItemID_","_ MakeBillRate_","_ExecuteRate_","_dataType
    
    s SickRate=""
    s UpdateDate=$zd($h,3)
    //b 1
	i BonusTarget =""   s BonusTarget= $list(^dhcbsBonusIncItemD(rowid),2)
	//b 2
 	i BonusIncItemID =""  s BonusIncItemID = $list(^dhcbsBonusIncItemD(rowid),3)
 	//b 3
 	i MakeBillRate =""  s MakeBillRate = $list(^dhcbsBonusIncItemD(rowid),5)
    i ExecuteRate =""  s ExecuteRate = $list(^dhcbsBonusIncItemD(rowid),4)
    i SickRate =""  s SickRate = $list(^dhcbsBonusIncItemD(rowid),6)
 	s tmpRowid=0
	s tmpRowid=..IfRepBonusIncMapIdx(BonusTarget, BonusIncItemID)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	
	&sql(UPDATE dhc_bonus_module.BonusIncItemMap(BonusTargetID,BonusIncItemID, MakeBillRate,ExecuteRate,SickRate,UpdateDate,ItemType) VALUES (:BonusTarget,:BonusIncItemID, :MakeBillRate,:ExecuteRate,:SickRate,:UpdateDate,:dataType) where %ID=:rowid)
	q SQLCODE
}

//w ##class(dhc.bonus.umodule.uBonusIncItemMap).getDhcTar(0,10,"")

ClassMethod getBonusTarget(start, limit, str) As %String
{
	n (start,limit,str)
   
   s sqlStr=" SELECT BonusTargetID,BonusTargetName FROM dhc_bonus_data.BonusTarget where DataSource=10 "
	i str'="" s sqlStr=sqlStr_" and BonusTargetName LIKE '%"_str_"%' "
	k ^cwtemp
	s ^cwtemp=sqlStr
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

//w ##class(dhc.bonus.umodule.uBonusIncItemMap).getDhcTar(0,10,"")

ClassMethod getDhcTar(start, limit, str) As %String
{
	n (start,limit,str)
   
   s sqlStr="SELECT BonusIncItemID , ItemCode, ItemName  FROM dhc_bonus_module.BonusIncItem WHERE IsValid=1"
    i str'="" s sqlStr=sqlStr_"AND (ItemCode LIKE '%"_str_"%' OR ItemName  LIKE '%"_str_"%') "
    
	//i str'="" s sqlStr=sqlStr_" and TAREC_Desc LIKE '%"_str_"%' "
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
	s rowid= result.Data("BonusIncItemID")
	s name= result.Data("ItemName")
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

Storage Default
{
<StreamLocation>^dhc.bonus866B.uBonusIncIt227ES</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

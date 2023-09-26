Class dhc.bonus.umodule.uBonusIncItem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//w ##class(dhc.bonus.umodule.uBonusIncItem).ListRec("","",1,25)

ClassMethod ListRec(sortField, sortDir, start, limit) As %String
{
		n ( sortField, sortDir, start, limit)
		
		s sqlStr=" SELECT BonusIncItemID,ItemCode,ItemName,IsValid,UpdateDate FROM dhc_bonus_module.BonusIncItem "
		s sqlStr=sqlStr_"  order by BonusIncItemID desc" 		
		
	
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit-1
		
		s json=##class(dhc.bonus.comm.JsonObj).%New()
		s jsonTitle="rowid^code^name^IsValid^UpdateDate"
		
		While(result.Next())
		{
			s rowid=result.Data("BonusIncItemID")
			s code=result.Data("ItemCode")
			s name=result.Data("ItemName")
			s IsValid=result.Data("IsValid")
			i IsValid=1 s IsValid="Y"
			i IsValid=0 s IsValid="N"			
		    s UpdateDate=result.Data("UpdateDate")
		 
			s tmp=rowid_"^"_code_"^"_name_"^"_IsValid_"^"_UpdateDate
		
			i (count>=start)&(count<=end) d
			.d json.InsertRowData(tmp)
		    s count=count+1
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

//w ##class(dhc.bonus.umodule.uBonusIncItem).InsertRec(1,"放屁奖","Y")

ClassMethod InsertRec(code, name, IsValid) As %String
{
	n (code, name, IsValid)
	
   
	s rowid=0
	s rowid=..IfRepBonusIncItemIdx(code)
	q:rowid>0 "RepCode"
	s UpdateDate=$zd($h,3)
	i IsValid="Y" s IsValid=1
	i IsValid="" s IsValid=0
	&sql(INSERT INTO dhc_bonus_module.BonusIncItem(ItemCode,ItemName,IsValid,UpdateDate)
	 VALUES (:code,:name,:IsValid,:UpdateDate ))

	q SQLCODE
}

ClassMethod IfRepBonusIncItemIdx(code) As %String
{
	new (code)
	s rowid=0 
	s rowid=$o(^dhcbsmodule.BonusIncItemI("BonusIncItemIdx",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

//w ##class(dhc.bonus.umodule.uBonusIncItem).UpdateRec(1,"","放屁奖","Y")

ClassMethod UpdateRec(rowid, code, name, IsValid) As %String
{
	n (rowid,code, name,IsValid)
    i IsValid="Y" s IsValid=1
    i IsValid="N" s IsValid=0
    s UpdateDate=$zd($h,3)
   
	i code =""     s code= $list(^dhcbsmodule.BonusIncItemD(rowid),2)
 	i name =""     s name = $list(^dhcbsmodule.BonusIncItemD(rowid),3)
 	i IsValid =""  s IsValid = $list(^dhcbsmodule.BonusIncItemD(rowid),4)
 	
 	s tmpRowid=0
	s tmpRowid=..IfRepBonusIncItemIdx(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	
	&sql(UPDATE dhc_bonus_module.BonusIncItem(ItemCode,ItemName,IsValid,UpdateDate) VALUES (:code,:name,:IsValid,:UpdateDate) where %ID=:rowid)
	q SQLCODE
}

ClassMethod Delete(rowid) As %String
{
	&sql( DELETE FROM dhc_bonus_module.BonusIncItem WHERE %ID=:rowid)

	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.um866B.uBonusIncItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

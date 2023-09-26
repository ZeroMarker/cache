Class dhc.bonus.ulogs.uBonusModiLog Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod List(start, limit, StartDate, EndDate) As %String
{
 n (start,limit,StartDate,EndDate)
 ;s StartDate=$ZDH(StartDate,3)
 ;s EndDate=$ZDH(EndDate,3)
 s Sqlstr=" select BonusUnitID,ModiDate,ModiPerson,TableName,ItemCode,ItemName,OldValue,NewValue,ReMark"
 		  _" from dhc_bonus_logs.BonusModiLog"
 i (StartDate'="")&(EndDate'="") s Sqlstr=Sqlstr_" where ModiDate>='"_StartDate_"' and ModiDate<='"_EndDate_"'"
 
 s result=##Class(%Library.ResultSet).%New()
 d result.Prepare(Sqlstr)
 d result.Execute(Sqlstr)
 s count=0
 s resultString=""
 s end=start+limit-1
 
 s json=##Class(dhc.bonus.comm.JsonObj).%New()
 s jsonTitle="RowID^ModiDate^ModiPerson^TableName^ItemCode^ItemName^OldValue"
 			_"^NewValue^ReMark"
 
 while(result.Next()){
 	s RowID=result.Data("BonusUnitID")
 	s ModiDate=result.Data("ModiDate")
 	s ModiPerson=result.Data("ModiPerson")
 	s TableName=result.Data("TableName")
 	s ItemCode=result.Data("ItemCode")
 	s ItemName=result.Data("ItemName")
 	s OldValue=result.Data("OldValue")
 	s NewValue=result.Data("NewValue")
 	s ReMark=result.Data("ReMark")
 	
 	s tmp=RowID_"^"_ModiDate_"^"_ModiPerson_"^"_TableName_"^"_ItemCode_"^"_ItemName
	 	   _"^"_OldValue_"^"_NewValue_"^"_ReMark
	 i (count>=start)&(count<=end) d
	 .d json.InsertRowData(tmp)
	 s count=count+1
 }
 
 d result.Close()
 s resultString = json.getJsonData(jsonTitle,count)
 k json
 q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.ulogs.uBonusModiLogS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

Class dhc.bonus.udata.uDeptManager Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod InsertRec(fDR, code, name, isEnd, alert, conting, cost, dura, pa, bonus, hr, check) As %String
{
	q:fDR="" "error"
	n (fDR,code, name,isEnd,alert,conting,cost,dura,pa,bonus,hr,check)

	&sql(insert into dhc_bonus_data.DeptManager (DeptCode,DeptName,SuperDeptID,IsBudg,IsAcct,IsCost,IsDura,IsPa,IsBonus,IsHuman,IsAttend,IsEnd) values(:code, :name,:fDR,:isEnd,:alert,:conting,:cost,:dura,:pa,:bonus,:hr,:check))
	q SQLCODE
}

ClassMethod UpdateRec(rowid, code, name, isEnd, alert, conting, cost, dura, pa, bonus, hr, check) As %String
{
	q:rowid="" "error"
	n (rowid,code, name,isEnd,alert,conting,cost,dura,pa,bonus,hr,check)

	&sql(update dhc_bonus_data.DeptManager (DeptCode,DeptName,IsBudg,IsAcct,IsCost,IsDura,IsPa,IsBonus,IsHuman,IsAttend,IsEnd) values(:code, :name,:isEnd,:alert,:conting,:cost,:dura,:pa,:bonus,:hr,:check) where DeptManagerID=:rowid)
	q SQLCODE
}

ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, parent) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit, parent)
	
	//规整查询条件
	s tmpEnd=""
	i parent="roo" s parent=0

	
	//SQL
	s sqlStr="select * from dhc_bonus_data.DeptManager"
	s whereStr=" where %ID>0 "
	s whereStr=whereStr_" and SuperDeptID ='"_parent_"'"

	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="DeptManagerID"


	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	e  s sortStr=" order by DeptCode asc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	//w sqlStr,!
	;k ^zlgtemp
	;s ^zlgtemp=sqlStr
	
	s resultString="["
	
	s result=##class(%Library.ResultSet).%New()
	;i (tmpEnd=0)||(parent=0) d
	d result.Prepare(sqlStr)
	d result.Execute()
	//取结构
	While(result.Next()){
	
		s rowid = result.Data("DeptManagerID")
		s DeptCode = result.Data("DeptCode")
		s DeptName = result.Data("DeptName")
		s SuperDeptID = result.Data("SuperDeptID")
		s IsBudg = result.Data("IsBudg")
		s IsAcct = result.Data("IsAcct")
		s IsCost = result.Data("IsCost")
		s IsDura = result.Data("IsDura")
		s IsPa = result.Data("IsPa")
		s IsBonus = result.Data("IsBonus")
		s IsHuman = result.Data("IsHuman")
		s IsAttend = result.Data("IsAttend")
		s IsEnd = result.Data("IsEnd")
		i IsEnd=1 s Flag="true"
		else  s Flag="false"

	
		s resultString=resultString_"{id:'"_rowid_"',DeptCode:'"_DeptCode_"',DeptName:'"_DeptName_"',SuperDeptID:'"_SuperDeptID_"',IsBudg:'"_IsBudg_"',IsAcct:'"
		_IsAcct_"',IsCost:'"_IsCost_"',IsDura:'"_IsDura_"',IsPa:'"_IsPa_"',parent:'"_SuperDeptID_"',IsBonus:'"_IsBonus_
		"',IsHuman:'"_IsHuman_"',leaf:"_Flag_",uiProvider:'col',IsAttend:'"_IsAttend_"',IsEnd:'"_IsEnd_"'},"
		//_"',sn:'"_SuperiorUnitName 
	}
	s resultString=resultString_"]"
	d result.Close()
	//s ^aa=resultString
	q resultString
	;q "[{id:'370',UnitFlagName:'科室',EmployeeNo:'',code:'10',name:'收费处',Spell:'',BonusUnitTypeDr:'22',BonusUnitTypeName:'收费处',LastStage:'0',parent:'0',SuperiorUnitName:'',level:'1',leaf:false,uiProvider:'col',UnitFlagDr:1},]"
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uDeptManagerS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

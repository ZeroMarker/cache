/// Creator: 陈文
/// CreatDate: 2015-04-14
/// Description:支出项目字典
Class dhc.bonus.umodule.ubonusexpenditem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：chenwen 
/// CreatDate：2015-4-14
/// Description: 查询符合条件的奖金单元设置记录
/// Table：dhc.bonus.module.BonusExpendItem
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.umodule.ubonusexpenditem).List("")
ClassMethod List(rnode) As %String
{
	n (rnode)
	
	s sqlStr="select SuperItemID->ItemLevel as SuperLevel,* from dhc_bonus_module.BonusExpendItem "
	
	i rnode=""  s whereStr=" where (SuperItemID is null or  SuperItemID='')"
	e  s whereStr=" where SuperItemID = '"_rnode_"'  "
	
	s sortStr=" ORDER BY ItemCode DESC"
	s sqlStr=sqlStr_whereStr _sortStr
	
	s ^TMPWYY(1)="sqlStr:"_sqlStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString="["
	
	While(result.Next()){
		s leaf = "false"                       
		s Rowid             = result.Data("BonusExpendItemID")
		s code              = result.Data("ItemCode")
		s name              = result.Data("ItemName")
		s IsCalc            = result.Data("IsCalc")
		s IsCalcName = ""
		i IsCalc=0 d
		.s IsCalcName = "否"
		e  d
		.s IsCalcName = "是"
		s State           = result.Data("State")
		i State=0 d
		.s StateName = "新增"
		e  d
		.s StateName = "审核"
		s month            = result.Data("Months")
		s rate         = result.Data("ItemRate")
		s SuperCode         = result.Data("SuperItemID")
		i SuperCode = $c(0) d
		.s SuperCode = ""
		s CheckDate             = result.Data("CheckDate")
		i CheckDate '="" d
		.s CheckDate    =$zd(CheckDate,3)
		s CheckMan          = result.Data("CheckMan")
		s IsLast            = result.Data("IsLast")
		i IsLast = 1 d
		.s leaf = "true"
		s UpdateDate     = result.Data("UpdateDate")
		i UpdateDate'="" d
		.s UpdateDate    =$zd(UpdateDate,3)
		s expendtypename=""
		s expendtype= result.Data("ExpendType")
		i expendtype=1 s expendtypename="人员工资"
	    i expendtype=2 s expendtypename="卫生材料"
	    i expendtype=3 s expendtypename="办公用品"
	    i expendtype=4 s expendtypename="折旧费"
        i expendtype=5 s expendtypename="维修费用"
        i expendtype=6 s expendtypename="公摊费用"
        i expendtype=9 s expendtypename="其他成本"
        s ItemLevelName=""
        s ItemLevel=result.Data("ItemLevel")
		i ItemLevel=1 s ItemLevelName="一级节点"
	    i ItemLevel=2 s ItemLevelName="二级节点"
	    i ItemLevel=3 s ItemLevelName="三级节点"
	    i ItemLevel>3 s ItemLevelName="非法节点"
		
		s tmp = "{Rowid:'"_Rowid_"',code:'"_code_"',name:'"_name_"',expendtypename:'"_expendtypename_"',expendtype:'"_expendtype_"',ItemLevelName:'"_ItemLevelName_"',ItemLevel:'"_ItemLevel_"',IsCalcName:'"_IsCalcName_"', StateName:'"_StateName_"',month:'"_month_"',rate:'"_rate_"',SuperCode:'"_SuperCode_"',CheckDate:'"_CheckDate_"',CheckMan:'"_CheckMan_"',updateData:'"_UpdateDate_"',leaf:"_leaf_"}"
		
		i resultString = "[" d
		.s resultString = resultString_tmp
		e  d
		.s resultString = resultString_","_tmp
					
		s count=count+1
	}
		
	d result.Close()
	s resultString = resultString_"]"
	s ^TMPWYY(2)= resultString
	q resultString
}

/// Creator: chenwen
/// CreatDate: 2011-1-17
/// Description: 代码是否存在
/// Table：dhc.bonus.data.BonusUnit
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.umodule.ubonusexpenditem).IfRepCode("1001")
ClassMethod IfRepCode(code) As %String
{
	new (code)
	s rowid=0
	;s rowid=$o(^dhcbsmdBonusExpendItemI("BonusItemCode",code,rowid))
	s sqlStr="SELECT BonusExpendItemID   FROM dhc_bonus_module.BonusExpendItem"
	      _" WHERE ItemCode=:code"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s tmpRowid=0
	
	While(result.Next()){                    
		s tmpRowid  = result.Data("BonusExpendItemID")
	}
	d result.Close()

	q tmpRowid
}

// w ##class(dhc.bonus.umodule.ubonusexpenditem).Insert("1003|'急诊科室'|1|0|1|0|0")

/// Creator: 陈文
/// CreatDate: 2011-1-17
/// Description: 名称是否存在
/// Table：dhc.bonus.data.BonusUnit
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.umodule.ubonusexpenditem).Insert("10010101|子一号|0|11|1|1001|1")
ClassMethod Insert(data) As %String
{
	n (data)
	q:data="" "emptyData"
    
	s code            =$p(data,"|",1)
	s name            =$p(data,"|",2) 
	s iscalc          =$p(data,"|",3)
	s month           =$p(data,"|",4)
	s rate            =$p(data,"|",5)
	s superid         =$p(data,"|",6)
	s islast          =$p(data,"|",7)
	s tmpLevel        =$p(data,"|",8)
	s tmpType         =$p(data,"|",9)
	s state           =0
	s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	s UpdateDate=$zdh(UpdateDate,3)
	
	s dictDr=..IfRepCode(code)
	
	q:dictDr>0 "编码重复!"	
	
	&sql(insert into  dhc_bonus_module.BonusExpendItem (ItemCode,ItemName,IsCalc,Months,ItemRate,SuperItemID,IsLast,UpdateDate,State,ItemLevel,ExpendType) values(:code,:name,:iscalc,:month,:rate,:superid,:islast,:UpdateDate,:state,:tmpLevel,:tmpType))
	      
	q SQLCODE
}

///  w ##class(dhc.bonus.umodule.ubonusexpenditem).Delete(12,0)
ClassMethod Delete(rowid, code) As %String
{
	n (rowid,code)
	s IsLast=""
	&sql(select IsLast into:IsLast from dhc_bonus_module.BonusExpendItem where BonusExpendItemID=:rowid)
	&sql(Delete from dhc_bonus_module.BonusExpendItem where BonusExpendItemID=:rowid)
	
	i IsLast=0 d ..Deletedetail(rowid)
	
	q 0
}

///  w ##class(herp.budg.udata.uBudgItemDict).Delete(1)
ClassMethod Deletedetail(code) As %String
{
	n (code)
	
	s sqlStr=" select * from dhc_bonus_module.BonusExpendItem where SuperItemID = '"_code_"' "
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
			
		s Rowid = result.Data("BonusExpendItemID")
		s Code = result.Data("ItemCode")
		
		d ..Delete(Rowid,Code)	

	}
	d result.Close()
}

// w ##class(dhc.bonus.umodule.ubonusexpenditem).Update(6,"1001|特别科室|1|0|1|0")

ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	q:data="" "emptyData"
	
    s code            =$p(data,"|",1)
	s name            =$p(data,"|",2) 
	s iscalc          =$p(data,"|",3)
	s month           =$p(data,"|",4)
	s rate            =$p(data,"|",5)

	s islast          =$p(data,"|",6)
	s expendtype      =$p(data,"|",7)
	s UpdateDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	s UpdateDate=$zdh(UpdateDate,3)
	s dictDr=..IfRepCode(code)

	q:(dictDr>0)&&(dictDr'=rowid) "编码重复!"
	/*	
	i rowid '="" s tmpIsLast=$list(^dhcbsmdBonusExpendItemD(rowid),10)   ;IsLast
	i rowid '="" s tmpCode=$list(^dhcbsmdBonusExpendItemD(rowid),2)

	;w tmpIsLast,"*",tmpCode,"*",tmpYear,!	
                      
	i tmpIsLast=0 d
	.&sql(UPDATE dhc_bonus_module.BonusExpendItem set SuperItemID=:Code where SuperItemID=:tmpCode )
	i (tmpIsLast=1)&&(islast =0) d
	.&sql(UPDATE dhc_bonus_module.BonusExpendItem set SuperItemID=:SuperCode where SuperItemID=:tmpCode )
	*/
	&SQL(UPDATE dhc_bonus_module.BonusExpendItem (ItemCode,ItemName,IsCalc,Months,ItemRate,IsLast,UpdateDate,ExpendType) values(:code,:name,:iscalc,:month,:rate,:islast,:UpdateDate,:expendtype) where %ID=:rowid )
	q SQLCODE
}

//w ##class(dhc.bonus.umodule.ubonusexpenditem).Checked(14,"chenwen",1001)

ClassMethod Checked(rowid, user, code) As %String
{
	n (rowid,user,code)
	s CheckDate=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	s CheckDate=$zdh(CheckDate,3)
	s IsLast=""
	&sql(select IsLast into:IsLast from dhc_bonus_module.BonusExpendItem where BonusExpendItemID=:rowid)
	
    &sql(update dhc_bonus_module.BonusExpendItem set CheckDate=:CheckDate  where BonusExpendItemID=:rowid )
  
    &sql(update dhc_bonus_module.BonusExpendItem set State=1  where BonusExpendItemID=:rowid )
    &sql(update dhc_bonus_module.BonusExpendItem set CheckMan=:user  where BonusExpendItemID=:rowid )
  
    i IsLast=0 d ..checkeddetail(user,rowid)
	q SQLCODE
}

ClassMethod checkeddetail(user, code) As %String
{
	n (user,code)
	
	s sqlStr=" select * from dhc_bonus_module.BonusExpendItem where SuperItemID = '"_code_"' "
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
			
		s Rowid = result.Data("BonusExpendItemID")
		s Code = result.Data("ItemCode")
		
		d ..Checked(Rowid,user,Code)	

	}
	d result.Close()
}

Storage Default
{
<StreamLocation>^dhc.bonus866B.ubonusexpenDAF9S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

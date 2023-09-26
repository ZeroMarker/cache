/// Creator: lxw
/// CreatDate: 2015-06-12
/// Description:Drgs指标映射
Class dhc.bonus.umodule.uDrgsTargetMap Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：lxw
/// CreatDate：2015-06-19
/// Description: 查询符合条件的数据
/// Table：dhc_bonus_module.DrgsTargetMap
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.umodule.uDrgsTargetMap).ListRec("","","","","",0,25)
ClassMethod ListRec(data, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
  n (data,searchField,searchValue,sortField,sortDir,start,limit)
  
  s SqlStr="SELECT DrgsTargetMapID1,BonusTargetID->BonusTargetName,DrgsTargetMapID->DrgsName,ItemRate,UpdateDate FROM dhc_bonus_module.DrgsTargetMap "
          _" WHERE 1=1 "
         
  s TargetId= $p(data,"^",1)
  s DragId  = $p(data,"^",2)
  i TargetId'= "" s SqlStr = SqlStr_" AND BonusTargetID  = '"_TargetId_"' "
  i DragId  '= "" s SqlStr = SqlStr_" AND DrgsTargetMapID= '"_DragId_"' "
   
  i sortField'="" d
  .i sortField = "BonusTarget" s sortField = "BonusTargetID"
  .e  i sortField = "DragName" s sortField = "DrgsTargetMapID"
  .e  i sortField = "UpdateDate" s sortField = "UpdateDate"
  .e  i sortField = "InputProport" s sortField = "ItemRate"
  .e  s sortField = "DrgsTargetMapID1"
  .s SqlStr = SqlStr_"ORDER BY "_sortField_" "_sortDir_" "
  
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(SqlStr)
  d result.Execute()

  s count=0
  s resultString=""
  s end=start+limit-1
  ;'rowid', 'BonusTarget', 'DragName', 'InputProport','UpdateDate'
  s json=##class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^BonusTarget^DragName^InputProport^UpdateDate"
  While(result.Next()){
		
    s rowid= result.Data("DrgsTargetMapID1")
	s BonusTarget = result.Data("BonusTargetName")
	s DragName = result.Data("DrgsName")
	s InputProport = result.Data("ItemRate")
	s UpdateDate= $ZD(result.Data("UpdateDate"),3) 
	 
	i (count>=start)&(count<=end) d
	.s tmp=rowid_"^"_BonusTarget_"^"_DragName_"^"_InputProport_"^"_UpdateDate
	.d json.InsertRowData(tmp)
	s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：lxw
/// CreatDate：2015-06-19
/// Description: 获取Drgs项目
/// Table：dhc_bonus_module.DrgsItem
/// Input：start-起始行;limit-行数;
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.umodule.uDrgsTargetMap).GetDrgs("",0,25)
ClassMethod GetDrgs(str, start, limit) As %String
{
  n (str,start,limit)
  s SqlStr= "SELECT DrgsItemID,DrgsCode,DrgsName FROM dhc_bonus_module.DrgsItem WHERE IsValid=1 AND LastStage=1 "
  
  i str '= ""  s SqlStr = SqlStr_ " and (DrgsCode like '%"_str_"%' or DrgsName like '%"_str_"%') "
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(SqlStr)
  d result.Execute()
	
  s count=0
  s resultString=""
  s end=start+limit-1

  s json=##class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^Code^Name"
  ;d json.InsertRowData(""_"^"_""_"^"_"空值")
  While(result.Next()){
		
    s rowid= result.Data("DrgsItemID")
	s Code = result.Data("DrgsCode")
	s Name = result.Data("DrgsName")	
     
	i (count>=start)&(count<=end) d
	.s tmp=rowid_"^"_Code_"^"_Name
	.d json.InsertRowData(tmp)
	s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：lxw
/// CreatDate：2015-06-19
/// Description: 获取奖金指标
/// Table：dhc_bonus_data.BonusTarget
/// Input：start-起始行;limit-行数;
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.umodule.uDrgsTargetMap).GetBonusTarget("",0,25)
ClassMethod GetBonusTarget(str, start, limit) As %String
{
  n (str,start,limit)
  s SqlStr= "SELECT BonusTargetID,BonusTargetCode,BonusTargetName FROM dhc_bonus_data.BonusTarget  "
           _"WHERE IsValid=1 and DataSource=13 "
  
  i str '= ""  s SqlStr = SqlStr_ "and (BonusTargetCode like '%"_str_"%' or BonusTargetName like '%"_str_"%') "
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(SqlStr)
  d result.Execute()
	
  s count=0
  s resultString=""
  s end=start+limit-1

  s json=##class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^Code^Name"
  ;d json.InsertRowData(""_"^"_""_"^"_"空值")
  While(result.Next()){
		
    s rowid= result.Data("BonusTargetID")
	s Code = result.Data("BonusTargetCode")
	s Name = result.Data("BonusTargetName")	
     
	i (count>=start)&(count<=end) d
	.s tmp=rowid_"^"_Code_"^"_Name
	.d json.InsertRowData(tmp)
	 s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：lxw
/// CreatDate：2015-06-19
/// Description: 插入数据
/// Table：dhc_bonus_module.DrgsTargetMap
/// Input：要插入的数据
/// Return：SQL返回值
/// Others:w ##class(dhc.bonus.umodule.uDrgsTargetMap).Insert("1^1^1")
ClassMethod Insert(data) As %String
{
  n (data)
  s DragsId = $p(data,"^",1) 
  s TargetId= $p(data,"^",2)
  s Proport = $p(data,"^",3)
  s date = $p($h,",",1)
  &SQL(INSERT INTO dhc_bonus_module.DrgsTargetMap(BonusTargetID,DrgsTargetMapID,ItemRate,UpdateDate) VALUES(:TargetId,:DragsId,:Proport,:date))
  
  q SQLCODE
}

/// Creator：lxw
/// CreatDate：2015-06-19
/// Description: 删除数据
/// Table：dhc_bonus_module.DrgsTargetMap
/// Input：要删除的数据ID
/// Return：SQL返回值
/// Others:w ##class(dhc.bonus.umodule.uDrgsTargetMap).Insert("1^2^3")
ClassMethod delete(data) As %String
{
  n (data)
  s rtn = 0
  f i=1:1 {
	s rowid = ""
	s rowid = $p(data,"^",i)  
	q:rowid=""
	&SQL(DELETE from dhc_bonus_module.DrgsTargetMap WHERE DrgsTargetMapID1=:rowid)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE'=0 s rtn =SQLCODE
  }
  
 q rtn
}

/// Creator：lxw
/// CreatDate：2015-06-19
/// Description: 修改数据
/// Table：dhc_bonus_module.DrgsTargetMap
/// Input：要修改的数据
/// Return：SQL返回值
/// Others:w ##class(dhc.bonus.umodule.uDrgsTargetMap).Update("1^1^34^5") 
ClassMethod Update(data) As %String
{
  n (data)
  s DragsId = $p(data,"^",1) 
  s TargetId= $p(data,"^",2)
  s Proport = $p(data,"^",3) 
  s RowId   = $p(data,"^",4) 
  s date = $p($h,",",1)
  i (DragsId="")&(TargetId="") d
  .&SQL(UPDATE dhc_bonus_module.DrgsTargetMap SET ItemRate=:Proport,UpdateDate=:date WHERE DrgsTargetMapID1=:RowId)
  e  i (DragsId="") d
  .&SQL(UPDATE dhc_bonus_module.DrgsTargetMap SET BonusTargetID =:TargetId,ItemRate=:Proport,UpdateDate=:date WHERE DrgsTargetMapID1=:RowId)
  e  i (TargetId="") d
  .&SQL(UPDATE dhc_bonus_module.DrgsTargetMap SET DrgsTargetMapID =:DragsId,ItemRate=:Proport,UpdateDate=:date WHERE DrgsTargetMapID1=:RowId)
  e  d
  .&SQL(UPDATE dhc_bonus_module.DrgsTargetMap SET BonusTargetID =:TargetId,DrgsTargetMapID =:DragsId,ItemRate=:Proport,UpdateDate=:date WHERE DrgsTargetMapID1=:RowId)
  i SQLCODE=100 s SQLCODE=0
  q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u866B.uDrgsTargetMapS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

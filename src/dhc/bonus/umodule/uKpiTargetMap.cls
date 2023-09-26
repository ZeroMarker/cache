/// Creator: lxw
/// CreatDate: 2015-06-19
/// Description:绩效奖金指标映射
Class dhc.bonus.umodule.uKpiTargetMap Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：lxw
/// CreatDate：2015-06-19
/// Description: 查询符合条件的Drgs项目
/// Table：dhc_bonus_module.KpiTargetMap
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.umodule.uKpiTargetMap).ListRec("1^0","","","","",0,25)
ClassMethod ListRec(data, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
  n (data,searchField,searchValue,sortField,sortDir,start,limit)

  s SqlStr="SELECT  KpiTargetMapID,BonusTargetID,BonusTargetID->BonusTargetName,KpiTargetID,"
          _"b.KPIIndex1_name,ItemRate,PASchemID,PASchemID->Schem_name,TargetType,UpdateDate "
          _"FROM dhc_bonus_module.KpiTargetMap a LEFT JOIN dhc_pa_data.KPIIndex1 b ON a.KpiTargetID=b.KPIIndex1_rowid "
          _" WHERE 1=1 "

  i $p(data,"^",1)'= "" s SqlStr = SqlStr_" AND BonusTargetID= '"_$p(data,"^",1)_"' "
  i ($p(data,"^",2)'= "")&($p(data,"^",2)'= 0) s SqlStr = SqlStr_" AND TargetType  = '"_$p(data,"^",2)_"' "
   
  i sortField'="" d
  .i sortField = "BonusTarget" s sortField = "BonusTargetID"
  .e  i sortField = "PaSchem" s sortField = "PASchemID"
  .e  i sortField = "PiTarget" s sortField = "KpiTargetID"
  .e  i sortField = "Proportion" s sortField = "ItemRate"
  .e  i sortField = "TargetType" s sortField = "TargetType"
  .e  s sortField = "KpiTargetMapID"
  .s SqlStr = SqlStr_"ORDER BY "_sortField_" "_sortDir_" "
  
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(SqlStr)
  d result.Execute()
  
  s count=0
  s resultString=""
  s end=start+limit-1
  ;'BonusTarget', '', '','','' 'BonusTargetID','PaSchemID','PiTargetID'
  s json=##class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^BonusTarget^TargetType^PaSchem^PiTarget^Proportion^BonusTargetID^PaSchemID^PiTargetID^TargetTypeID"
  While(result.Next()){
		
    s rowid= result.Data("KpiTargetMapID")
	s BonusTarget = result.Data("BonusTargetName")
	s TargetType = result.Data("TargetType")
	s TargetTypeID =TargetType
	i TargetType = 1 s TargetType="方案总分"
	i TargetType = 2 s TargetType="方案维度"
	i TargetType = 3 s TargetType="方案指标"
	
	
	s PaSchem = result.Data("Schem_name")
	s PiTarget = result.Data("KPIIndex1_name")
	s Proportion= result.Data("ItemRate")
	;s IsTarget= result.Data("IsTarget")
	;i IsTarget =1 s IsTarget="是"
	;e  s IsTarget="否"
	s BonusTargetID= result.Data("BonusTargetID")
	s PaSchemID= result.Data("PASchemID")
	s PiTargetID= result.Data("KpiTargetID")
	
	i (PiTarget="")&(PiTargetID=-1) s PiTarget="绩效考核分"
	
	i (count>=start)&(count<=end) d
	.s tmp=rowid_"^"_BonusTarget_"^"_TargetType_"^"_PaSchem_"^"_PiTarget_"^"_Proportion_"^"_BonusTargetID_"^"_PaSchemID_"^"_PiTargetID_"^"_TargetTypeID
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
/// Description: 删除数据
/// Table：dhc_bonus_module.KpiTargetMap
/// Input：所要删除数据的ID
/// Return：SQL返回结果
/// Others:w ##class(dhc.bonus.umodule.uKpiTargetMap).delete("4^5")
ClassMethod delete(data) As %String
{
  n (data)
  s rtn = 0
  f i=1:1 {
	s rowid = ""
	s rowid = $p(data,"^",i)  
	q:rowid=""
	&SQL(DELETE FROM dhc_bonus_module.KpiTargetMap WHERE KpiTargetMapID=:rowid)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE'=0 s rtn =SQLCODE
  }
 q rtn
}

/// Creator：lxw
/// CreatDate：2015-06-19
/// Description: 获取绩效方案
/// Table：dhc_pa_data.Schem
/// Input：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.umodule.uKpiTargetMap).GetPaScheme(0,10,"")
ClassMethod GetPaScheme(str, start, limit) As %String
{
  n (start,limit,str)
  
  s sqlStr="SELECT Schem_rowid,Schem_code,Schem_name FROM dhc_pa_data.Schem "
          _"where Schem_active='Y' "
  i str '= "" d
  .s sqlStr = sqlStr_" AND Schem_code LIKE '%"_str_"%' OR Schem_name LIKE '%"_str_"%'"
  ;w sqlStr,!		
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(sqlStr)
  d result.Execute()
	
  s count=0
  s resultString = ""
  s end = start+limit
	
  s json=##class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^Code^Name"
  
  While(result.Next()){
	 s rowid = result.Data("Schem_rowid")
	 s Code = result.Data("Schem_code")
	 s Name = result.Data("Schem_name")
	 s tmp=rowid_"^"_Code_"^"_Name
	 s count = count+1
	 i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)	
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
/// Others:w ##class(dhc.bonus.umodule.uKpiTargetMap).GetBonusTarget("",0,25)
ClassMethod GetBonusTarget(str, start, limit) As %String
{
  n (str,start,limit)
  s SqlStr= "SELECT BonusTargetID,BonusTargetCode,BonusTargetName FROM dhc_bonus_data.BonusTarget  "
           _"WHERE IsValid=1 and DataSource=14 "
  
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
/// Description: 获取绩效指标
/// Table：dhc_pa_data.KPIIndex1
/// Input：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.umodule.uKpiTargetMap).GetKpiTarget(2,"1||3","",0,10)
ClassMethod GetKpiTarget(Targetype, SchemID, str, start, limit) As %String
{
  n (Targetype,SchemID,start,limit,str)
  i Targetype=2
  {
  s sqlStr=" SELECT DimensType_rowid AS rowid,DimensType_code AS code,DimensType_name AS name FROM dhc_pa_data.SchemDetail a,dhc_pa_data.DimensType b "
              _"WHERE a.SchemDetail_KPIDr=b.DimensType_rowid "
              _"AND SchemDetail_parRef='"_SchemID_"' AND SchemDetail_isTarget=1 AND b.DimensType_active ='Y' "
   i str '= "" d
  .s sqlStr = sqlStr_" AND DimensType_name LIKE '%"_str_"%' OR DimensType_name LIKE '%"_str_"%'"	
  } 
  i Targetype=3 
  {
  s sqlStr="SELECT KPIIndex1_rowid AS rowid,KPIIndex1_code AS code,KPIIndex1_name AS name FROM dhc_pa_data.KPIIndex1 a JOIN dhc_pa_data.SchemDetail b ON a.KPIIndex1_rowid=b.SchemDetail_KPIDr "
          _"where 1=1 AND SchemDetail_isTarget=2 "
  i str '= "" d
  .s sqlStr = sqlStr_" AND KPIIndex1_code LIKE '%"_str_"%' OR KPIIndex1_name LIKE '%"_str_"%'"	
  i SchemID '= "" d
  .s sqlStr = sqlStr_"AND SchemDetail_parRef='"_SchemID_"'"
  }
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(sqlStr)
  d result.Execute()
	
  s count=0
  s resultString = ""
  s end = start+limit
	
  s json=##class(dhc.bonus.comm.JsonObj).%New()
  s jsonTitle="rowid^Code^Name"
  
  While(result.Next()){
	 s rowid = result.Data("rowid")
	 s Code = result.Data("code")
	 s Name = result.Data("name")
	 s tmp=rowid_"^"_Code_"^"_Name
	 s count = count+1
	 i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)	
  }
  
  d result.Close()
  s resultString = json.getJsonData(jsonTitle,count)
  k json
  q resultString
}

/// Creator：lxw
/// CreatDate：2015-06-19
/// Description: 插入数据
/// Table：dhc_bonus_module.KpiTargetMap
/// Input：
/// Return：SQL执行结果
/// Others:w ##class(dhc.bonus.umodule.uKpiTargetMap).Insert("4^1||3^6^4^1")
ClassMethod Insert(data) As %String
{
  n (data)
  s bonustarget= $p(data,"^",1) 
  s paschem    = $p(data,"^",2)
  s kpitarget  = $p(data,"^",3) 
  q:..IfRepCode(bonustarget,kpitarget)'=0 "RepCode"  ;判断重复
  s rate       = $p(data,"^",4)
  s targetype  = $p(data,"^",5)
  s date = $p($h,",",1)
  
  &SQL(INSERT INTO dhc_bonus_module.KpiTargetMap(BonusTargetID,KpiTargetID,ItemRate,PASchemID,UpdateDate,TargetType) VALUES(:bonustarget,:kpitarget,:rate,:paschem,:date,:targetype))
  
  q SQLCODE
}

/// Creator：lxw
/// CreatDate：2015-06-19
/// Description: 修改数据
/// Table：dhc_bonus_module.KpiTargetMap
/// Input：
/// Return：SQL执行结果
/// Others:w ##class(dhc.bonus.umodule.uKpiTargetMap).Insert("4^1||3^6^4^1^5")
ClassMethod Update(data) As %String
{
 n (data)
  s bonustarget= $p(data,"^",1) 
  s paschem    = $p(data,"^",2)
  s kpitarget  = $p(data,"^",3) 
  s rate       = $p(data,"^",4)
  s targetype   = $p(data,"^",5)
  s rowid      = $p(data,"^",6)
  q:(..IfRepCode(bonustarget,kpitarget)'=0)&(..IfRepCode(bonustarget,kpitarget)'=rowid) "RepCode"  ;判断重复
  s date = $p($h,",",1)
  &SQL(UPDATE  dhc_bonus_module.KpiTargetMap  SET BonusTargetID=:bonustarget
  ,KpiTargetID=:kpitarget,ItemRate=:rate,PASchemID=:paschem,UpdateDate=:date,TargetType=:targetype   
  WHERE KpiTargetMapID=:rowid)
  q SQLCODE
}

/// Creator: lxw
/// CreatDate: 2015-06-10
/// Description: 代码是否存在
/// Table：dhc_bonus_module.KpiTargetMap
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.umodule.uKpiTargetMap).IfRepCode(1,1)
ClassMethod IfRepCode(BonusTargetID, KpiTargetID) As %String
{
	n (BonusTargetID,KpiTargetID)
	s rowid=0
	s rowid=$o(^dhcbsmoduleKpiTargetMapI("KPIBonusTargetIDX",BonusTargetID, KpiTargetID,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

Storage Default
{
<StreamLocation>^dhc.bonus.um866B.uKpiTargetMapS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

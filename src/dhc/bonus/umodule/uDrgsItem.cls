/// Creator: lxw
/// CreatDate: 2015-06-10
/// Description:Drgs项目维护
Class dhc.bonus.umodule.uDrgsItem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：lxw
/// CreatDate：2015-06-10
/// Description: 查询符合条件的Drgs项目
/// Table：dhc_bonus_module.DrgsItem
/// Input：parent-父节点;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.umodule.uDrgsItem).List("","","","",0,25,"0")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, parent) As %String
{
	n (searchField,searchValue,sortField,sortDir,start,limit,parent)
	
	//规整查询条件
	s tmpEnd=""
	i parent="roo" s parent=0
	i parent'="" d
	.i $D(^dhcbsmoduleDrgsItemD(parent)) d
	..i $G(^dhcbsmoduleDrgsItemD(parent))'="" s tmpEnd=$L(^dhcbsmoduleDrgsItemD(parent),8)
	..e  s tmpEnd=0
	
	//SQL
	s sqlStr="SELECT DrgsItemID,DrgsCode,DrgsName,SuperDrgsID,CMIRate,CostRate,IsValid,UpdateDate,LastStage "
	        _ "FROM dhc_bonus_module.DrgsItem"
	s whereStr=" where %ID>0 and IsValid=1 "
	s whereStr=whereStr_" and SuperDrgsID ='"_parent_"'"

	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="BonusUnitID"
	
	.i sortField="code" s sortField1="BonusUnitCode"
	.i sortField="name" s sortField1="BonusUnitName"
	.i sortField="EmployeeNo" s sortField1="EmployeeNo"
	 
	.i sortField="UnitFlagName" s sortField1="UnitFlag"
	.i sortField="SuperiorUnitName" s sortField1="SuperiorUnitID"
	.i sortField="UnitLevel" s sortField1="UnitLevel"
	.i sortField="LastStage" s sortField1="LastStage"
	.i sortField="UpdateDate" s sortField1="UpdateDate"
	.i sortField="BonusUnitTypeName" s sortField1="BonusUnitTypeID"

	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	e  s sortStr=" order by DrgsCode asc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	;w sqlStr,!
	;k ^zlgtemp
	;s ^zlgtemp=sqlStr
	
	s resultString="["
	
	s result=##class(%Library.ResultSet).%New()
	;i (tmpEnd=0)||(parent=0) d
	d result.Prepare(sqlStr)
	d result.Execute()
	//取结构
	While(result.Next()){
	   s rowid = result.Data("DrgsItemID")
	   s DrCode= result.Data("DrgsCode")
	   s DrName= result.Data("DrgsName")
	   s Super = result.Data("SuperDrgsID")
	   s CMIRat= result.Data("CMIRate")
	   s CosRat= result.Data("CostRate")
	   s IsVal = result.Data("IsValid")
	   s Last  = result.Data("LastStage")
       
       s SuperName = ""
       s SuperCode = ""
       //上级单元
       i (Super'="")&(Super'=0) d
       .i $G(^dhcbsmoduleDrgsItemD(Super))'="" d
       ..s SuperName=$List(^dhcbsmoduleDrgsItemD(Super),3)
       ..s SuperCode=$List(^dhcbsmoduleDrgsItemD(Super),2)
       
	
	   i Last=1 s Flag="true"
	   i Last=0 s Flag="false"			
	   //单元级别
	   s level = 1
	   s resultString=resultString_"{id:'"_rowid_"',Name:'"_DrName_"',Code:'"_DrCode_"',Cmi:'"_CMIRat_"',Rate:'"_CosRat_"',Isvalid:'"_IsVal_"',IsLast:'"_Last_"',lv:'"_level_"',uiProvider:'col',SupCode:'"_SuperCode_"',leaf:"_Flag_",SuperName:'"_SuperName_"',SuperID:'"_Super_"'},"
	}
	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator：lxw
/// CreatDate：2015-06-10
/// Description: 插入Drgs项目
/// Table：dhc_bonus_module.DrgsItem
/// Input：
/// Return：插入结果
/// Others:w ##class(dhc.bonus.umodule.uDrgsItem).Insert("D222^eee^3^2^1^1")
ClassMethod Insert(data) As %String
{
  n (data)
  s code = $p(data,"^",1)
  s name = $p(data,"^",2)
  s cmi  = $p(data,"^",3)
  s rate = $p(data,"^",4)
  s isend= $p(data,"^",5)
  s super= $p(data,"^",6)
  s date = $p($H,",",1) ;$zd($h,3)
  
  q:..IfRepCode(code)'=0 "RepCode"
  &SQL(INSERT INTO dhc_bonus_module.DrgsItem (DrgsCode,DrgsName,SuperDrgsID,CMIRate,CostRate,IsValid,UpdateDate,LastStage) VALUES
  (:code,:name,:super,:cmi,:rate,1,:date,:isend))
  q SQLCODE
}

/// Creator：lxw
/// CreatDate：2015-06-10
/// Description: 修改Drgs项目
/// Table：dhc_bonus_module.DrgsItem
/// Input：
/// Return：修改结果
/// Others:w ##class(dhc.bonus.umodule.uDrgsItem).Update("D222^eee^3^2^1^1^3")
ClassMethod Update(data) As %String
{
  n (data)
  s code = $p(data,"^",1)
  s name = $p(data,"^",2)
  s cmi  = $p(data,"^",3)
  s rate = $p(data,"^",4)
  s isend= $p(data,"^",5)
  s super= $p(data,"^",6)
  s rowid= $p(data,"^",7)
  s date = $p($H,",",1) ;$zd($h,3)
  
  q:(..IfRepCode(code)'=0)&(..IfRepCode(code)'=rowid) "RepCode"
  &SQL(UPDATE dhc_bonus_module.DrgsItem SET DrgsCode=:code,DrgsName=:name,SuperDrgsID=:super,
  CMIRate=:cmi,CostRate=:rate,UpdateDate=:date,LastStage=:isend WHERE DrgsItemID=:rowid )
  q SQLCODE
}

/// Creator：lxw
/// CreatDate：2015-06-10
/// Description: 删除Drgs项目
/// Table：dhc_bonus_module.DrgsItem
/// Input：
/// Return：删除结果
/// Others:w ##class(dhc.bonus.umodule.uDrgsItem).Del(3)
ClassMethod Del(rowid) As %String
{
  n (rowid)
  s count=0
  &SQL(SELECT count(*) into:count FROM dhc_bonus_module.DrgsItem WHERE SuperDrgsID=:rowid)  
  q:+count>0 "havechiled"
  
  &SQL(UPDATE dhc_bonus_module.DrgsItem SET IsValid=0 WHERE DrgsItemID=:rowid)
  q SQLCODE
}

/// Creator：lxw
/// CreatDate：2015-06-10
/// Description: 获取Drgs项目
/// Table：dhc_bonus_module.DrgsItem
/// Input：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.umodule.uDrgsItem).GetDrag(3)
ClassMethod GetDrag(start, limit, str, rowid) As %String
{
  n (start,limit,str,rowid)
  
  s sqlStr="SELECT DrgsItemID,DrgsCode,DrgsName FROM dhc_bonus_module.DrgsItem "
          _"where  IsValid=1 AND LastStage=0 "
  i rowid '="" d
  .s sqlStr = sqlStr_" AND DrgsItemID <>'"_rowid_"'"
  i str '= "" d
  .s sqlStr = sqlStr_" AND DrgsCode LIKE '%"_str_"%' OR DrgsName LIKE '%"_str_"%'"
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
	 s rowid = result.Data("DrgsItemID")
	 s Code = result.Data("DrgsCode")
	 s Name = result.Data("DrgsName")
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

/// Creator: lxw
/// CreatDate: 2015-06-10
/// Description: 代码是否存在
/// Table：dhc_bonus_module.DrgsItem
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.umodule.uDrgsItem).IfRepCode("D22")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^dhcbsmoduleDrgsItemI("DrgsCode",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

Storage Default
{
<StreamLocation>^dhc.bonus.umodule.uDrgsItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

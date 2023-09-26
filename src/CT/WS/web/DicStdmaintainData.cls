/// CT.WS.web.DicStdmaintainData
/// 描述:取得公共字典数据维护
/// 编写者:yejian
/// 编写日期:2013-4-23
Class CT.WS.web.DicStdmaintainData Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	//获取表的ID
	s selID = $Get(%request.Data("selID",1),"")
	s datavalue = $Get(%request.Data("dataName",1),"")
	s actionbtn = $Get(%request.Data("actionbtn",1),"")
	s strcondition = $Get(%request.Data("condition",1),"")
	s pagesize = $Get(%request.Data("pagesize",1))
	s start = $g(%request.Data("start",1),"0")
	s limit = $g(%request.Data("limit",1),"0")
	s idxLast = start + limit - 1
	s datavalues="ID|:|"_selID_"^^^"_datavalue
	d ..GetJsonDate(start,limit,strcondition,actionbtn,datavalues)
	
    Quit $$$OK
}

/// Creator:	yejian
/// CreatDate:	2013-4-23
/// Desc:		获取字典表维护数据
/// Input：		start：每页开始行数，limit：每页行数，actionbtn：前台触发事件，datavalue，前台传入的更新数据
/// Return：	"0":删除失败	"1":删除成功	
/// d ##Class(CT.WS.web.dicStdmaintainData).GetFiledDate("1^^家庭关系代码")
ClassMethod GetFiledDate(condition As %String) As %String
{
	s strRowId = ""
   	s strValue = ""
   	if (condition'=""&condition'=$char(0))
	{
		S strRowId = $P(condition,"^^",1)
		s strValue =##class(CT.WS.BO.BODynamicConfigTable).GetClassFieldbyID(strRowId) 
	}
	s strTableName = $p(strValue,"^^",1)
	s strField = "ID,"_$p(strValue,"^^",3)
	s strInitValue = $p(strValue,"^^",4)
	s defaultValue = $p(strValue,"^^",5)
	s strValues = strTableName _"@@"_strField_"@@"_strInitValue_"@@"_defaultValue
	if (strTableName=""){
		q ""
		}else{
		q strValues
	}
}

/// Creator:	yejian
/// CreatDate:	2013-4-23
/// Desc:		获取字典表维护数据
/// Input：		start：每页开始行数，limit：每页行数，actionbtn：前台触发事件，datavalue，前台传入的更新数据
/// Return：	"0":删除失败	"1":删除成功	
/// d ##Class(CT.WS.web.dicStdmaintainData).GetJsonDate(5,5,"7^^性别关系代码表新","updateidbtn","ID:21^CtmDictCode:234^CtmDictDesc:23^CtmDictAlias:eee234^CtmDictType:GBT/91273^CtmDictName:343")
ClassMethod GetJsonDate(start As %String, limit As %String, condition As %String, actionbtn As %String, datavalue As %String)
{
   	s strValue = ""
   	if (condition'=""&condition'=$char(0))
	{
		s strValue =..GetFiledDate(condition) 
	}
	q:strValue="" ""
	s strTableName = $p(strValue,"@@",1)
	s strField = $p(strValue,"@@",2)
	s strInitValue = $p(strValue,"@@",3)
	s res = ""
   	//对维护字典进行更新处理
   	if ((actionbtn '= "")&&(datavalue'= ""))
   	{
	   	
	   	if (actionbtn = "btnInsertData")
	   	{
		   	s strrowid = ##Class(CT.WS.BO.BOStdMaintain).AddRecord(strTableName,datavalue)
	   	}
	   	elseif (actionbtn = "updateidbtn")
	   	{
		   	d ##Class(CT.WS.BO.BOStdMaintain).UpdateRecord(strTableName,datavalue)
	   	}
	   	elseif (actionbtn = "deleteidbtn")
	   	{
		   	d ##Class(CT.WS.BO.BOStdMaintain).DelRecord(strTableName,datavalue)
	   	}
   	}
    
	s strFilter =""
	if (strInitValue '="")
	{
		s strFilter = " AND  "_ $REPLACE(strInitValue,","," AND ")
	}
	s jsons = ""
	s jsons = ##class(CT.WS.BO.BODynamicConfigTable).GetJsonBySql(strTableName,strField,strFilter,start,limit)
	w jsons
}

}

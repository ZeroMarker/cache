/// CT.WS.BO.BOCustomMaintainQuery
/// 描述:取得自定义字典维护数据
/// 编写者:yejian
/// 编写日期:2013-4-23
Class CT.WS.BO.BOCustomMaintainQuery Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "CustomMaintainTable";

/// Creator:	yejian
/// CreatDate:	2013-4-23
/// Desc:		添加字典表维护数据
/// Input：		datavalue，前台传入的更新数据
/// Return：	"0":失败	"1":成功	
/// d ##Class(CT.WS.BO.BOCustomMaintainQuery).CreateStdDictionary()
ClassMethod CreateStdDictionary(datevalue As %String) As %String [ WebMethod ]
{
	s res = 0
	if (datevalue '="")
	{
	set Code = $p($p(datevalue,"^^^",1),"|-:-|",2)
	set Name = $p($p(datevalue,"^^^",2),"|-:-|",2)
	set Description = $p($p(datevalue,"^^^",3),"|-:-|",2)
	set TableName = $p($p(datevalue,"^^^",4),"|-:-|",2)
	set DicAliasCol = $p($p(datevalue,"^^^",5),"|-:-|",2)
	set DicCodeCol = $p($p(datevalue,"^^^",6),"|-:-|",2)
	set DicDescCol = $p($p(datevalue,"^^^",7),"|-:-|",2)
	set ConditionCode = $p($p(datevalue,"^^^",8),"|-:-|",2)
	set Condition = $p($p(datevalue,"^^^",9),"|-:-|",2)
	set SystemCode = $p($p(datevalue,"^^^",12),"|-:-|",2)
	set objStdDictionary = ##class(CT.WS.entity.EStdDictionary).%New() 
	set objStdDictionary.Code = Code
	set objStdDictionary.Description = Description
	set objStdDictionary.DicAliasCol =DicAliasCol
	set objStdDictionary.DicCodeCol = DicCodeCol
 	set objStdDictionary.DicDescCol = DicDescCol
 	set objStdDictionary.Name = Name
 	set objStdDictionary.TableName = TableName
 	set objStdDictionary.Condition = Condition
 	set objStdDictionary.ConditionCode = ConditionCode
 	set objStdDictionary.SystemCode=SystemCode
	s ^test3 = "Code"
	s res = ##Class(CT.WS.BO.BOStdDictionary).CreateStdDictionary(objStdDictionary)
	}
	q res
}

/// Creator:	yejian
/// CreatDate:	2013-4-23
/// Desc:		更新字典表维护数据
/// Input：		datavalue，前台传入的更新数据
/// Return：	"0":失败	"1":成功	
/// d ##Class(CT.WS.BO.BOCustomMaintainQuery).UpdateStdDictionary()
ClassMethod UpdateStdDictionary(datevalue As %String) As %String [ WebMethod ]
{
	
	s res = 0
	if (datevalue '="")
	{
	set Code = $p($p(datevalue,"^^^",1),"|-:-|",2)
	set Name = $p($p(datevalue,"^^^",2),"|-:-|",2)
	set Description = $p($p(datevalue,"^^^",3),"|-:-|",2)
	set TableName = $p($p(datevalue,"^^^",4),"|-:-|",2)
	set DicAliasCol = $p($p(datevalue,"^^^",5),"|-:-|",2)
	set DicCodeCol = $p($p(datevalue,"^^^",6),"|-:-|",2)
	set DicDescCol = $p($p(datevalue,"^^^",7),"|-:-|",2)
	set ConditionCode = $p($p(datevalue,"^^^",8),"|-:-|",2)
	set Condition = $p($p(datevalue,"^^^",9),"|-:-|",2)
	set ID = $p($p(datevalue,"^^^",10),"|-:-|",2)
	set SystemCode = $p($p(datevalue,"^^^",12),"|-:-|",2)
	set objStdDictionary = ##class(CT.WS.entity.EStdDictionary).%New() 
	set objStdDictionary.ID = ID
	set objStdDictionary.Code = Code
	set objStdDictionary.Description = Description
	set objStdDictionary.DicAliasCol =DicAliasCol
	set objStdDictionary.DicCodeCol = DicCodeCol
 	set objStdDictionary.DicDescCol = DicDescCol
 	set objStdDictionary.Name = Name
 	set objStdDictionary.TableName = TableName
 	set objStdDictionary.Condition = Condition
 	set objStdDictionary.ConditionCode = ConditionCode
 	set objStdDictionary.SystemCode=SystemCode
	s res = ##Class(CT.WS.BO.BOStdDictionary).UpdateStdDictionary(objStdDictionary)
	}
	q res
}

/// Creator:	yejian
/// CreatDate:	2013-4-23
/// Desc:		删除字典表维护数据
/// Input：		datavalue，前台传入的更新数据
/// Return：	"0":失败	"1":成功	
/// d ##Class(CT.WS.BO.BOCustomMaintainQuery).DeleteStdDictionary()
ClassMethod DeleteStdDictionary(datevalue As %String) As %String [ WebMethod ]
{
		
	s res = 0
	if (datevalue '="")
	{
	set ID = $p($p(datevalue,"^^^",10),"|-:-|",2)
	s res = ##Class(CT.WS.BO.BOStdDictionary).DeleteStdDictionary(ID)
	}
	q res
}

}

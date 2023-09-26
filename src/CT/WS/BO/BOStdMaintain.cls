/// CT.WS.BO.BOStdMaintain
/// 描述:取得公共字典数据维护BO层
/// 编写者:yejian
/// 编写日期:2013-4-23
Class CT.WS.BO.BOStdMaintain Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "StdMaintainTable";

/// Creator:	yejian
/// CreatDate:	2013-4-23
/// Desc:		添加字典表维护数据
/// Input：		datavalue，前台传入的更新数据
/// Return：	"0":失败	"1":成功	
/// d ##Class(CT.WS.BO.BOStdMaintain).AddRecord()
ClassMethod AddRecord(strTableName As %String, datevalue As %String) As %String [ WebMethod ]
{
	s res = 0
	if ((datevalue '="")&(strTableName '=""))
	{
	s intCount = $l(datevalue,"^^^")
	s strFileds = ""
	for inti=1:1:intCount
	{
		 s strFileds =strFileds_$replace($p(datevalue,"^^^",inti),"|:|","=")_","
	}
	s strFileds = $e(strFileds, 1, $l(strFileds)-1)
	s strTableName=$REPLACE(strTableName,"_",".")
	s res = ##Class(CT.WS.BO.BODynamicConfigTable).AddRecord(strTableName,strFileds)
	}
	q res
}

/// Creator:	yejian
/// CreatDate:	2013-4-23
/// Desc:		更新字典表维护数据
/// Input：		datavalue，前台传入的更新数据
/// Return：	"0":失败	"1":成功	
/// d ##Class(CT.WS.BO.BOStdMaintain).UpdateStdDictionary()
ClassMethod UpdateRecord(strTableName As %String, datevalue As %String) [ WebMethod ]
{
	
	s res = 0
	if ((datevalue '="")&(strTableName '=""))
	{
	s intCount = $l(datevalue,"^^^")
	s strFileds = ""
	s rowid = ""
	for inti=1:1:intCount
	{
		if (inti = 1)
		{
			s rowid = $p($p(datevalue,"^^^",1),"|:|",2)
		}
		else
		{
		s strFileds =strFileds_$replace($p(datevalue,"^^^",inti),"|:|","=")_","
		}
	}
	s strFileds = $e(strFileds, 1, $l(strFileds)-1)
	s strTableName=$REPLACE(strTableName,"_",".")
	d ##Class(CT.WS.BO.BODynamicConfigTable).UpdateRecord(strTableName,rowid,strFileds)
	}
}

/// Creator:	yejian
/// CreatDate:	2013-4-23
/// Desc:		删除字典表维护数据
/// Input：		datavalue，前台传入的更新数据
/// Return：	"0":失败	"1":成功	
/// d ##Class(CT.WS.BO.BOStdMaintain).DeleteStdDictionary()
ClassMethod DelRecord(strTableName As %String, datevalue As %String) [ WebMethod ]
{
		
	s res = 0
	if ((datevalue '="")&(strTableName '=""))
	{
	s rowid = $p($p(datevalue,"^^^",1),"|:|",2)
	s strTableName=$REPLACE(strTableName,"_",".")
	//Code:S15^Name:[HIS]婚姻字典^Description:[HIS]婚姻字典^TableName:SQLUser.CT_Marital^DicAliasCol:23^DicCodeCol:CTMAR_Code^DicDescCol:CTMAR_Desc^ConditionCode:23^Condition:23^ID:14
	d ##Class(CT.WS.BO.BODynamicConfigTable).DelRecord(strTableName,rowid)
	}
}

Storage Default
{
<Data name="BOStdMaintainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CT.WS.BO.BOStdMaintainD</DataLocation>
<DefaultData>BOStdMaintainDefaultData</DefaultData>
<IdLocation>^CT.WS.BO.BOStdMaintainD</IdLocation>
<IndexLocation>^CT.WS.BO.BOStdMaintainI</IndexLocation>
<StreamLocation>^CT.WS.BO.BOStdMaintainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

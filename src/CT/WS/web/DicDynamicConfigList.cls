/// 名称：		CT.WS.web.DicDynamicConfigList
/// 描述：		获取获取配置列表
/// 编写者：	yejian
/// 编写时间：	2013-4-17
Class CT.WS.web.DicDynamicConfigList Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	
	s tableName = $Get(%request.Data("tableName",1))
	s configName = $Get(%request.Data("configName",1))
	s morenzhi = $Get(%request.Data("morenzhi",1))
	//保存
	s tableNamesave = $Get(%request.Data("tableNamesave",1))
	s configNamesave = $Get(%request.Data("configNamesave",1))
	s selbox = $Get(%request.Data("selbox",1))
	
	s boxIniValue = $Get(%request.Data("boxIniValue",1))
	s boxName = $Get(%request.Data("boxName",1))
	s DefautValue=""
	if ((tableNamesave'=$c(0))&(tableNamesave'="")&(configNamesave'="")&(configNamesave'=$c(0)))
	{
		s tableName=$REPLACE(tableNamesave,"_",".")
		s obj=##Class(%Dictionary.CompiledClass).%OpenId(tableName)
		if obj=""
		{	
			q ""
		}	
		if (morenzhi'="")
		{
			s ids=""
			s ids=$o(^CT.WS.DynamicConfE129I("IdxTableNameRow"," "_$ZCVT(tableNamesave, "U")," "_$ZCVT(morenzhi, "U"),ids))
			if (ids'="")
			{
				s DefautValue=..IsDefautValue(tableNamesave,boxIniValue,configNamesave)
				if ($p(DefautValue,"^",1)="0")
				{
					d ##class(CT.WS.BO.BODynamicConfigTable).UpdateDBConfigRecord(tableNamesave,configNamesave, boxName,boxIniValue)
					
				
				}
			}
			if (ids="")
			{
				s tableNames=""
				s tableNames=$o(^CT.WS.DynamicConfE129I("IdxTableName"," "_$ZCVT(tableNamesave, "U"),tableNames))
				if (tableNames="")
				{
					
					d ##class(CT.WS.BO.BODynamicConfigDefaultValue).AddRecord(tableNamesave,morenzhi)
					
					d ##class(CT.WS.BO.BODynamicConfigTable).UpdateDBConfigRecord(tableNamesave,configNamesave, boxName,boxIniValue)
				}
			}
			
		}
		w ##class(CT.WS.BO.BODynamicConfigTable).GetClassPropertiesJson(tableName,"^@^",DefautValue)
		q $$$OK
	}else{
		w ##class(CT.WS.BO.BODynamicConfigTable).GetClassPropertiesJson(tableName,"^@^",DefautValue)
		q $$$OK
	}
}

//CT.WS.web.DicDynamicConfigList

/// d ##Class(CT.WS.web.DicDynamicConfigList).IsDefautValue("CT_WS.testdu","age='11',sex='12'")
ClassMethod IsDefautValue(tableName As %String, boxIniValue As %String, configNamesave As %String)
{

	S defaultValue=""
	s defaultRow=""
	s quit="0"
	S OneiniValueTableRowValue=""		
	s tableNamesID=""
	s tableNamesID=$o(^CT.WS.DynamicConfE129I("IdxTableName"," "_$ZCVT(tableName, "U"),tableNamesID))
	if (tableNamesID'="")
	{
		s obj=##class(CT.WS.DynamicConfigDefaultValue).%OpenId(tableNamesID)
		s defaultRow=obj.DefaultRow
	}
	s count=$l(boxIniValue,",")
	for inti=1:1:count
	{
		s OneiniValue=$p(boxIniValue,",",inti)
		s OneiniValueTableRow=$p(OneiniValue,"=",1)
		if (OneiniValueTableRow=defaultRow)
		{
			s OneiniValueTableRowValue=$p(OneiniValue,"=",2)
			s defaultValue=$P(OneiniValueTableRowValue,"'",2)
		}
	}
	S ^TESTDU1=OneiniValueTableRowValue_"^"_defaultValue
	s dfID=""
	for{
	s dfID=$o(^DHCCTWS.DynamicConfigTableI("IdxValue"," "_$ZCVT(tableName, "U"),dfID))
	q:dfID=""
	s dfObj=##class(CT.WS.DynamicConfigTable).%OpenId(dfID)
	s dfValue=dfObj.IniValue
	s dfConfigName=dfObj.ConfigName
	if (dfConfigName'=configNamesave){
	s countDfValue=$l(dfValue,",")
	for inti=1:1:countDfValue
	{
		s OneDfValue=$p(dfValue,",",inti)
		s OneDfValueTableRow=$p(OneDfValue,"=",1)
		if (OneDfValueTableRow=defaultRow)
		{
			s OneDfValueTable=$p(OneDfValue,"=",2)
			s OneDfValue=$P(OneDfValueTable,"'",2)
			if (defaultValue=OneDfValue){
				s quit="1^"_dfConfigName_"^"_OneDfValueTableRow_"="_defaultValue
				}
		}
	}}}
	q quit		
		
	
	
	//defaultValue  
	//s objIdConfigTB = ##Class(CT.WS.DynamicConfigTable).%OpenId(idConfigTB)
	//s iniValueObj=objIdConfigTB.IniValue
}

}

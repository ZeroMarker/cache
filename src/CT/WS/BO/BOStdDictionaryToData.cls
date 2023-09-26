Class CT.WS.BO.BOStdDictionaryToData Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "StdDictionaryService";

/// 根据字典表名和描述值确定其标准值
/// d ##Class(CT.WS.BO.BOStdDictionaryToData).GetStdDicitonaryByID("SQLUser.CT_Sex","男")
ClassMethod GetStdDicitonaryByID(inittableName As %String, initvalues As %String)
{
	s ind=1
	s tableNames=""
	s inittableName=" "_$zcvt(inittableName,"U")
	s initvalues=" "_initvalues
	//确定返回对象
	s objData = ##class(CT.WS.entity.EDataDicToData).%New()
	for
	{
		s tableNames=$o(^DHCCTWS.StdDictionaryI("IdxStdDictionaryID",tableNames))
		q:tableNames=""
		s dicId=""
		if (tableNames=inittableName)
		{
			s dicId=$o(^DHCCTWS.StdDictionaryI("IdxStdDictionaryID",tableNames,dicId))
			 s obj = ##Class(CT.WS.StdDictionary).%OpenId(dicId)
			 S objCode=" "_obj.Code
			 s systemCodes=""
			 for
			 {
				s systemCodes=$o(^DHCCTWS.DataValueMapI("IdxSystemCodeDicMeaning",systemCodes))
				q:systemCodes=""
				S dataValueMapID=""
				for
				{
					s dataValueMapID=$o(^DHCCTWS.DataValueMapI("IdxSystemCodeDicMeaning", systemCodes,objCode,initvalues,dataValueMapID))
					
					q:dataValueMapID=""
					s dataValueMapobj = ##Class(CT.WS.DataValueMap).%OpenId(dataValueMapID)
					
					s objData.Code=dataValueMapobj.DicCode
					s objData.ConfigId=dataValueMapobj.CtmDictCode
					s objData.ConfigValue=dataValueMapobj.CtmDictDesc
					s objData.StandardId=dataValueMapobj.DEVID
					s objData.StandardValue=dataValueMapobj.Meaning
				}
			}
			 
		}
       
	}
	q objData
}

}

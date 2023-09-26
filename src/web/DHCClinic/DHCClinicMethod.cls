Class web.DHCClinic.DHCClinicMethod Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2016-04-12
/// Description： 	判断HISID是否存在
/// Table：        	
/// Input：        	className:实体类名，HISKey:HIS ID     
/// Return：       	存在返回1，不存在返回0
/// Debug:			w ##class(web.DHCCLCCommon).ExistHISKey("User.DHCCLCBed","5||1")
ClassMethod ExistHISKey(className As %String, HISKey As %String) As %Boolean
{
	b //ccq2
	quit:(className="")!(HISKey="") 0
	
	set rowId=..GetRowIdByHISKey(className,HISKey)
	b //ccq3
	set result=(rowId>0)
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2016-04-12
/// Description： 	根据HIS ID获取临床组表的ID
/// Table：        	
/// Input：        	className:实体类名，HISKey:HIS ID     
/// Return：       	存在返回相应的ID，不存在返回-1
ClassMethod GetRowIdByHISKey(className As %String, HISKey As %String) As %Integer
{
	quit:(className="")!(HISKey="") -1
	set classDef=##class(%Dictionary.ClassDefinition).%OpenId(className)
	set storage="CacheStorage"
	set storageDef=##class(%Dictionary.StorageDefinition).%OpenId(className_"||"_storage)
	set globalName=storageDef.DataLocation
	quit:($data(@globalName)=0) -1
	set hisKeyGlobal=$p(globalName,")",1)_",0,""HISKey"")"
	quit:($data(@hisKeyGlobal)=0) -1
	set hisKeyGlobal=$p(globalName,")",1)_",0,""HISKey"","""_HISKey_""",0)"
	set rowId=$order(@hisKeyGlobal)
	set existId=$classmethod(className,"%ExistsId",rowId)
	if (existId)
	{
		quit rowId	
	}
	else
	{
		quit -1	
	}
}

/// Creator：      	陈长青
/// CreatDate：    	2016-04-12
/// Description： 	判断HISID是否存在
/// Table：        	
/// Input：        	className:实体类名，HISKey:HIS ID     
/// Return：       	存在返回1，不存在返回0
/// Debug:			w ##class(web.DHCCLCCommon).ExistHISKey("User.DHCCLCBed","5||1")
ClassMethod ExistUniqueValue(className As %String, uniqueProperty As %String, uniqueValue As %String) As %Boolean
{
	quit:(className="")!(uniqueProperty="")!(uniqueValue="") 0
	set rowId=..GetRowIdByUniqueValue(className,uniqueProperty,uniqueValue)
	set result=(rowId>0)
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2016-04-12
/// Description： 	根据HIS ID获取临床组表的ID
/// Table：        	
/// Input：        	className:实体类名，HISKey:HIS ID     
/// Return：       	存在返回相应的ID，不存在返回-1
ClassMethod GetRowIdByUniqueValue(className As %String, uniqueProperty As %String, uniqueValue As %String) As %Integer
{
	quit:(className="")!(uniqueProperty="")!(uniqueValue="") -1
	set classDef=##class(%Dictionary.ClassDefinition).%OpenId(className)
	set storage="CacheStorage"	// 约定好的Storage名称
	set storageDef=##class(%Dictionary.StorageDefinition).%OpenId(className_"||"_storage)
	set globalName=storageDef.DataLocation
	quit:($data(@globalName)=0) -1
	set indexName=storageDef.IndexLocation
	set hisKeyGlobal=$p(indexName,")",1)_","""_uniqueProperty_""")"
	quit:($data(@hisKeyGlobal)=0) -1
	set hisKeyGlobal=$p(indexName,")",1)_","""_uniqueProperty_""","""_uniqueValue_""",0)"
	set rowId=$order(@hisKeyGlobal)
	set existId=$classmethod(className,"%ExistsId",rowId)
	if (existId)
	{
		quit rowId	
	}
	else
	{
		quit -1	
	}
}

/// Creator：      	陈长青
/// CreatDate：    	2016-04-12
/// Description： 	获取属性的类型
/// Table：        	
/// Input：        	className:实体类名，propertyName:属性名   
/// Return：       	存在返回相应的ID，不存在返回-1
ClassMethod GetPropertyType(className As %String, propertyName As %String, Output isPersistent As %Boolean) As %String
{
	set result="",isPersistent=0
	quit:(##class(%Dictionary.ClassDefinition).%ExistsId(className)=0) result	
	set propertyId=className_"||"_propertyName
	quit:(##class(%Dictionary.PropertyDefinition).%ExistsId(propertyId)=0) result
	;set result=^oddDEF(className,"a",propertyName,5)
	set propertyDef=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId)
	set result=propertyDef.Type
	if (##class(%Dictionary.ClassDefinition).%ExistsId(result))
	{
		set classDef=##class(%Dictionary.ClassDefinition).%OpenId(result)
		set superDef=classDef.Super
		if (superDef="%Persistent")!(superDef="%Library.Persistent")
		{
			set isPersistent=1	
		}	
	}
	else
	{
		set customClass="User."_result
		if (##class(%Dictionary.ClassDefinition).%ExistsId(customClass))
		{
			
			set classDef=##class(%Dictionary.ClassDefinition).%OpenId(customClass)
			set superDef=classDef.Super
			if (superDef["%Persistent")!(superDef["%Library.Persistent")
			{
				set isPersistent=1	
			}
			set result=customClass	
		}	
	}
	
	
	
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2016-04-12
/// Description： 	保存代码表数据
/// Table：        	
/// Input：        	className:实体类名，rowId:实体ID，propertyPara：属性参数字符串，valuePara：属性值参数字符串   
/// Return：       	保存成功返回"S^"_ID，失败返回"E^"_错误原因
/// Debug:			w ##class(web.DHCCLCCommon).SaveCodeData("User.DHCCLCHospital","","Code^Description^HISCode^HISKey^ID","jhmcs^jhm测试^jhmcs^50^50")
ClassMethod SaveCodeData(className As %String, rowId As %String, propertyPara As %String, valuePara As %String) As %String
{
	set $zt="Error"
	set existInstance=$classmethod(className,"%ExistsId",rowId)
	set instance=""
	if (existInstance)
	{
		set instance=$classmethod(className,"%OpenId",rowId)	
	}	
	else
	{
		set instance=$classmethod(className,"%New")	
	}
	set splitChar="^"
	set propertyCount=$length(propertyPara,splitChar),HISKey=""
	for i=1:1:propertyCount
	{
		set propertyName=$p(propertyPara,splitChar,i)
		if (propertyName="HISKey")
		{
			set HISKey=$p(valuePara,splitChar,i)	
		}
	}

	quit:(existInstance)&(..ExistHISKey(className,HISKey)=1) "已存在HISKey为"_HISKey_"的记录，请重新添加保存！"
	set isPersistent=0
	for i=1:1:propertyCount
	{
		set propertyName=$p(propertyPara,splitChar,i),propertyValue=$p(valuePara,splitChar,i)
		set propertyType=..GetPropertyType(className,propertyName,.isPersistent)
		continue:(propertyType="")
		if (isPersistent)
		{
			set refInstanceId=..GetRowIdByHISKey(propertyType,propertyValue)
			set refInstance=$classmethod(propertyType,"%OpenId",refInstanceId)
			set $property(instance,propertyName)=refInstance	
		}
		else
		{
			if (propertyType="%Date")!(propertyType="%Library.Date")
			{
				set propertyValue=##class(web.DHCClinicCom).ConvertToDateH(propertyValue,"")	
			}
			elseif (propertyType="%Time")!(propertyType="%Library.Time")
			{
				set propertyValue=##class(web.DHCClinicCom).ConvertToTimeH(propertyValue,"")	
			}
			set $property(instance,propertyName)=propertyValue		
		}
	}
	set status=$method(instance,"%Save")
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}
	else
	{
		quit "S^"_$method(instance,"%Id")	
	}
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2016-04-14
/// Description： 	保存数据
/// Table：        	
/// Input：        	className:实体类名，rowId:实体ID，propertyPara：属性参数字符串，valuePara：属性值参数字符串   
/// Return：       	保存成功返回"S^"_ID，失败返回"E^"_错误原因
/// Debug:			w ##class(web.DHCCLCCommon).SaveData("User.DHCCLCHospital","","Code^Description","jhmcs^jhm测试","Code")
ClassMethod SaveData(className As %String, rowId As %String, propertyPara As %String, valuePara As %String, uniqueProperty As %String = "") As %String
{
	set $zt="Error"
	set existInstance=$classmethod(className,"%ExistsId",rowId)
	set instance=""
	if (existInstance)
	{
		set instance=$classmethod(className,"%OpenId",rowId)	
	}	
	else
	{
		set instance=$classmethod(className,"%New")	
	}
	set splitChar="^"
	set propertyCount=$length(propertyPara,splitChar),uniqueValue=""
	for i=1:1:propertyCount
	{
		set propertyName=$p(propertyPara,splitChar,i)
		if (propertyName=uniqueProperty)
		{
			set uniqueValue=$p(valuePara,splitChar,i)	
		}
	}

	quit:(existInstance=0)&(..ExistUniqueValue(className,uniqueProperty,uniqueValue)=1) "已存在"_uniqueProperty_"为"_uniqueValue_"的记录，请重新添加保存！"
	set isPersistent=0
	for i=1:1:propertyCount
	{
		set propertyName=$p(propertyPara,splitChar,i),propertyValue=$p(valuePara,splitChar,i)
		set propertyType=..GetPropertyType(className,propertyName,.isPersistent)
		continue:(propertyType="")
		if (isPersistent)
		{
			set refInstance=$classmethod(propertyType,"%OpenId",propertyValue)
			set $property(instance,propertyName)=refInstance	
		}
		else
		{
			if (propertyType="%Date")!(propertyType="%Library.Date")
			{
				set propertyValue=##class(web.DHCClinicCom).ConvertToDateH(propertyValue,"")	
			}
			elseif (propertyType="%Time")!(propertyType="%Library.Time")
			{
				set propertyValue=##class(web.DHCClinicCom).ConvertToTimeH(propertyValue,"")	
			}
			set $property(instance,propertyName)=propertyValue		
		}
	}
	set status=$method(instance,"%Save")
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}
	else
	{
		quit "S^"_$method(instance,"%Id")	
	}
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2016-04-14
/// Description： 	删除数据
/// Table：        	
/// Input：        	className:实体类名，rowId:实体ID
/// Return：       	保存成功返回"S^"_ID，失败返回"E^"_错误原因
/// Debug:			w ##class(web.DHCCLCCommon).DeleteData("User.DHCCLCHospital","4")
ClassMethod DeleteData(className As %String, rowId As %String) As %String
{
	set $zt="Error"
	set status=$classmethod(className,"%DeleteId",rowId)
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}
	else
	{
		quit "S^"_rowId	
	}
Error
	set $zt=""
	quit "E^"_$ze
}

}

Class DHCCL.BLL.String Extends %RegisteredObject
{

ClassMethod GetDescBySplitChar(originalDesc As %String, splitChar As %String, locIndex As %Integer) As %String [ SqlProc ]
{
	set result=originalDesc
	set descCount=$length(originalDesc,splitChar)
	if (descCount>=locIndex)
	{
		set result=$piece(originalDesc,splitChar,locIndex)
	}	
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2016-12-29
/// Description： 	根据ID获取名称
/// Table：        	
/// Input:			className:实体类名称，descProperty:名称(描述)字段名，rowId:对象ID
/// Return：       	ResultSet
/// w ##class(DHCAN.DataService).GetDescByID("User.SSGroup","SSGRPDesc","1")
ClassMethod GetDescByID(className As %String, descProperty As %String, rowId As %Integer) As %String [ SqlProc ]
{
	set $zt="Error",result=""
	if (##class(%ClassDefinition).%ExistsId(className))
	{
		if ($classmethod(className,"%ExistsId",rowId))
		{
			set instance=$classmethod(className,"%OpenId",rowId)
			set result=$property(instance,descProperty)	
		}
		elseif (rowId'="")&&(+rowId=0)
		{
			set result=rowId
		}
	}
	quit result
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2016-12-29
/// Description： 	根据ID获取名称
/// Table：        	
/// Input:			className:实体类名称，descProperty:名称(描述)字段名，rowId:对象ID
/// Return：       	ResultSet
/// w ##class(DHCCL.BLL.String).GetDescByIDStr("DHCAN.OperStatus","Description","1,2,3,4",",")
ClassMethod GetDescByIDStr(className As %String, descProperty As %String, rowIdStr As %Integer, splitChar As %String) As %String [ SqlProc ]
{
	set $zt="Error",result=""
	if (##class(%ClassDefinition).%ExistsId(className))
	{
		set rowIdCount=$length(rowIdStr,splitChar)
		for i=1:1:rowIdCount
		{
			set rowId=$piece(rowIdStr,splitChar,i)
			set:(i>1) result=result_splitChar
			if ($classmethod(className,"%ExistsId",rowId))
			{
				set instance=$classmethod(className,"%OpenId",rowId)
				set propValue=$property(instance,descProperty)	
				set result=result_propValue
			}		
		}
		
	}
	quit result
Error
	set $zt=""
	quit "E^"_$ze
}

ClassMethod ToArray(data As %String, ByRef array As %String) As %Status
{
	set result=$$$OK
	set objSplitChar=$char(2),propertySplitChar=$char(1),valueSplitChar=$char(0)
	set objCount=$length(data,objSplitChar)
		for objIndex=1:1:objCount
		{
			set objectString=$piece(data,objSplitChar,objIndex)
			set propertyCount=$length(objectString,propertySplitChar)
			for propertyIndex=1:1:propertyCount
			{
				set propertyString=$piece(objectString,propertySplitChar,propertyIndex)
				set propertyName=$piece(propertyString,valueSplitChar,1)
				set propertyValue=$piece(propertyString,valueSplitChar,2)
				set array(objIndex,propertyName)=propertyValue	
			}
		}	
	
	quit result
}

ClassMethod ToJson(data As %String) As %String
{
	set node="",result="",objIndex=""
	for
	{
		set objIndex=$order(data(objIndex))
		quit:(objIndex="")
		set node="",singleResult=""
		for
		{
			set node=$order(data(objIndex,node))
			quit:(node="")
			set:(singleResult'="") singleResult=singleResult_","
			set singleResult=singleResult_""""_node_""""_":"_""""_data(objIndex,node)_""""		
		}
		set singleResult="{"_singleResult_"}"
		set:(result'="") result=result_","
		set result=result_singleResult
	}
	set result="["_result_"]"
	quit result
}

ClassMethod ObjectToJSON(data As DHCCL.BLL.DataObject) As %String
{
	set result=""
	for i=1:1:data.KeyValuePairs.Size
	{
		set kvPair=data.KeyValuePairs.GetAt(i)
		set:(result'="") result=result_","
		set result=result_""""_kvPair.Key_""""_":"_""""_kvPair.Value_""""	
	}	
	set result="{"_result_"}"
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-10
/// Description： 	返回不为空的字段值
/// Table：        	
/// Input:			
/// Return：       	String
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.String","AlterDesc")
ClassMethod AlterDesc(desc1, desc2) As %String [ SqlProc ]
{
	if desc1'="" quit desc1
	
	quit desc2
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-10
/// Description： 	返回不为空的字段值
/// Table：        	
/// Input:			
/// Return：       	String
/// w ##class(DHCCL.BLL.String).PatchFloat("")
ClassMethod PatchFloat(value) As %String [ SqlProc ]
{
	if (value<1) && (value>0) quit "0"_value
	
	quit value
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-28
/// Description： 	去掉重复的内容
/// Table：        	
/// Input:			str1,str2,delimiter
/// Return：       	麻醉方法名称字符串
/// w ##class(DHCCL.BLL.String).ConcatString("助手1,助手2,助手3","助手1,助手4",",")
ClassMethod ConcatString(str1, str2, delimiter = ",") As %String
{
	set lb1=$ListFromString(str1,delimiter)
	set lb2=$ListFromString(str2,delimiter)
	for i=1:1:$ListLength(lb2)
	{
		set element=$lg(lb2,i)
		if '$ListFind(lb1,element)
		{
			set lb1=lb1_$lb(element)
		}
	}
	
	set result=$ListToString(lb1,delimiter)
	quit result
}

}

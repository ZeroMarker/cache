Class DHCCL.BLL.DataService Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-03-12
/// Description： 	通用批量数据保存类方法
/// Table：        	
/// Input:			data:数据字符串
/// Return：       	保存成功返回"S^RowId"，保存失败返回"E^失败原因"
/// w ##class(DHCCL.BLL.DataService).SaveDataList("")	
ClassMethod SaveDataList(data As %String) As %String
{
	set saveResult=""
	tstart
	set status=##class(DHCCL.BLL.String).ToArray(data,.array)
	set objIndex=0
	for
	{
		set objIndex=$order(array(objIndex))
		quit:(objIndex="")
		k singleData
		set popNode="",singleData=""
		for	
		{
			set popNode=$order(array(objIndex,popNode))
			quit:(popNode="")
			
			set singleData(popNode)=array(objIndex,popNode)
		}
		set saveResult=..SaveData(.singleData)
		quit:($piece(saveResult,"^",1)="E")
	}
	if ($piece(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit	
	quit "S^"
}

/// Creator：      	陈长青
/// CreatDate：    	2017-03-12
/// Description： 	通用数据保存类方法
/// Table：        	
/// Input:			data:数据数组字符串
/// Return：       	保存成功返回"S^RowId"，保存失败返回"E^失败原因"
/// w ##class(DHCCL.BLL.DataService).SaveData("")
ClassMethod SaveData(data As %String) As %String
{
	set $zt="Error"
	set result="",className=$get(data("ClassName")),rowId=$get(data("RowId")),parentRowId=$get(data("ParentRowId"))
	if (className'="")
	{
		if (##class(%ClassDefinition).%ExistsId(className))
		{
			set instance=""
			if ($classmethod(className,"%ExistsId",rowId)=1)
			{
				set instance=$classmethod(className,"%OpenId",rowId)	
			}	
			else
			{
				// 父子表
				if (parentRowId'="")
				{
					set instance=$classmethod(className,"%New",parentRowId)	
				}
				else
				{
					set instance=$classmethod(className,"%New")	
				}
					
			}
			set query=##class(%ResultSet).%New("DHCCL.BLL.DataService:FindProperties")
			set sc=query.Execute(className)
			while(query.%Next())
			{
				set propertyName=query.Get("Name")
				set propertyType=query.Get("Type")
				
				if (propertyName="UpdateDate")
				{
					set $property(instance,propertyName)=+$h	
				}
				if (propertyName="UpdateTime")
				{
					set $property(instance,propertyName)=$p($h,",",2)	
				}
				
				// 获取属性数据类型的完整名称
				set propertyType=$$$NormalizeClassname(propertyType)
				set propertyClass=##class(%ClassDefinition).%OpenId(propertyType)
				// 获取父类的完整名称
				set superClass=$$$NormalizeClassname(propertyClass.Super)
				continue:($data(data(propertyName))=0)
				// 如果属性数据类型的父类是一个永久类，那么需要调用%OpenId来打开数据对象
				if (superClass="%Library.Persistent")
				{
					set $property(instance,propertyName)=$classmethod(propertyType,"%OpenId",data(propertyName))	
				}
				elseif (propertyType="%Library.Date")
				{
					set $property(instance,propertyName)=##class(DHCCL.BLL.DateTime).ConvertToDateH(data(propertyName),"")		
				}
				elseif (propertyType="%Library.Time")
				{
					set $property(instance,propertyName)=##class(DHCCL.BLL.DateTime).ConvertToTimeH(data(propertyName),"")			
				}
				elseif (propertyType="%Library.TimeStamp")
				{
					set $property(instance,propertyName)=##class(DHCCL.BLL.DateTime).StandardizeTimeStamp(data(propertyName))			
				}
				elseif (propertyType="%Library.GlobalCharacterStream")
				{
					do $method($property(instance,propertyName),"Write",data(propertyName))	
				}
				else
				{
					set $property(instance,propertyName)=data(propertyName)
				}
					
			}
			set sc=$method(instance,"%Save")
			if ($System.Status.IsOK(sc))
			{
				set result="S^"_$method(instance,"%Id")
			}
			else
			{
				set result="E^"_$System.Status.GetErrorText(sc)	// 获取错误详细信息(语言使用中文)
			}
		}
		else
		{
			set result="E^类"_className_"不存在"	
		}	
	}
	else
	{
		set result="E^实体类不存在"	
	}
	quit result
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2017-03-12
/// Description： 	通用数据删除类方法
/// Table：        	
/// Input:			className:实体类名称，rowId:需删除数据的RowId
/// Return：       	删除成功返回"S^"，删除失败返回"E^失败原因"
/// w ##class(DHCCL.BLL.DataService).DelData("","")
ClassMethod DelData(className As %String, rowId As %String) As %String
{
	set $zt="Error"
	set result=""
	if (##class(%ClassDefinition).%ExistsId(className))
	{
		set sc=$classmethod(className,"%DeleteId",rowId)
		if ($System.Status.IsOK(sc))
		{
			set result="S^"	
		}	
		else
		{
			set result="E^"_$System.Status.GetErrorText(sc,"zh-cn")	
		}
	}
	else
	{
		set result="E^类"_className_"不存在!"	
	}
	quit result
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2018-01-08
/// Description： 	通用批量数据删除类方法
/// Table：        	
/// Input:			
/// Return：       	删除成功返回"S^"，删除失败返回"E^失败原因"
/// w ##class(DHCCL.BLL.DataService).DelData("","")
ClassMethod DelDatas(paraStr As %String) As %String
{
	set sc=##class(DHCCL.BLL.String).ToArray(paraStr,.array)
	set dataCount=0,delRet="S^"
	tstart
	for
	{
		set dataCount=$order(array(dataCount))
		quit:(dataCount="")
		set className=array(dataCount,"ClassName")
		set rowId=array(dataCount,"RowId")
		set delRet=..DelData(className,rowId)
		quit:($piece(delRet,"^",1)'="S")	
	}	
	if ($piece(delRet,"^",1)'="S")
	{
		trollback
		quit delRet	
	}
	
	tcommit
	quit "S^"
}

/// 查询类的属性
Query FindProperties(className As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,Name,Type From %Dictionary.PropertyDefinition where parent=:className
}

}

/// 通用数据服务
Class CIS.AN.COM.DataService Extends %RegisteredObject
{

/// Creator：        陈长青
/// CreatDate：      2017-03-12
/// Description：    通用批量数据保存类方法
/// Table：          
/// Input:          data:数据字符串
/// Return：         保存成功返回"S^RowId"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.COM.DataService).SaveDataList("")   
ClassMethod SaveDataList(data As %String) As %String
{
    set saveResult=""
    tstart
    set status=##class(CIS.AN.COM.String).ToArray(data,.array)
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

/// Creator：        陈长青
/// CreatDate：      2017-03-12
/// Description：    通用数据保存类方法
/// Table：          
/// Input:          data:数据数组字符串
/// Return：         保存成功返回"S^RowId"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.COM.DataService).SaveData(.saveData)
ClassMethod SaveData(data As %String) As %String
{
    
    set $zt="Error"
    set result="",className=$get(data("ClassName")),rowId=$get(data("RowId")),parentRowId=$get(data("ParentRowId"))
    if (className'="")
    {
        ;b //s ^tempzmy(1)=data
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
            set query=##class(%ResultSet).%New("CIS.AN.COM.DataService:FindProperties")
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
                b:propertyName="Status" ;1
                if (superClass="%Library.Persistent")
                {
                    set $property(instance,propertyName)=$classmethod(propertyType,"%OpenId",data(propertyName))    
                }
                elseif (propertyType="%Library.Date")
                {
                    set dateValue=$g(data(propertyName))
                    if ($System.SQL.UPPER(dateValue)="TODAY")
                    {
                         set $property(instance,propertyName)=+$h   
                    }
                    else
                    {
                        if (data(propertyName)=" ")
                        {
                            set data(propertyName)=""
                        }
                        set $property(instance,propertyName)=##class(CIS.AN.COM.DateTime).ConvertToDateH(data(propertyName),"") 
                    }
                         
                }
                elseif (propertyType="%Library.Time")
                {
                    set timeValue=$g(data(propertyName))
                    if ($System.SQL.UPPER(timeValue)="NOW")
                    {
                        set $property(instance,propertyName)=$p($h,",",2)
                    }
                    else
                    {
                        if (data(propertyName)=" ")
                        {
                            set data(propertyName)=""
                        }
                        set $property(instance,propertyName)=##class(CIS.AN.COM.DateTime).ConvertToTimeH(data(propertyName),"")
                    }
                              
                }
                elseif (propertyType="%Library.TimeStamp")
                {
                    // 前台可能会传入空格 dtj
                    if (data(propertyName)=" ")
                    {
                        set data(propertyName)=""
                    }
                    set $property(instance,propertyName)=##class(CIS.AN.COM.DateTime).StandardizeTimeStamp(data(propertyName))           
                }
                elseif (propertyType="%Library.GlobalCharacterStream")
                {
                    do $method($property(instance,propertyName),"Write",data(propertyName)) 
                }
                else
                {
                    b:propertyName="Status" ;1
                    set $property(instance,propertyName)=data(propertyName)
                }
                    
            }
            set sc=$method(instance,"%Save")
            if ($System.Status.IsOK(sc))
            {
                set result="S^"_$method(instance,"%Id")
                
                if ..IsPrivate(className)
                {
	                do ..BindAttribution(className,$method(instance,"%Id"),$g(data("HospitalID")))
                }
            }
            else
            {
                set result="E^"_$System.Status.GetErrorText(sc) // 获取错误详细信息(语言使用中文)
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

/// Creator：        陈长青
/// CreatDate：      2017-03-12
/// Description：    通用数据删除类方法
/// Table：          
/// Input:          className:实体类名称，rowId:需删除数据的RowId
/// Return：         删除成功返回"S^"，删除失败返回"E^失败原因"
/// w ##class(CIS.AN.COM.DataService).DelData("CT.AN.OperAction","174")
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
            
            if ..IsPrivate(className)
            {
	            do ..UnbindAttribution(className,rowId)
            }
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

/// Creator：        陈长青
/// CreatDate：      2018-01-08
/// Description：    通用批量数据删除类方法
/// Table：          
/// Input:          
/// Return：         删除成功返回"S^"，删除失败返回"E^失败原因"
/// w ##class(CIS.AN.COM.DataService).DelData("","")
ClassMethod DelDatas(paraStr As %String) As %String
{
    set sc=##class(CIS.AN.COM.String).ToArray(paraStr,.array)
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

/// 判断类的多院区权限类型是否为私有
/// w ##class(CIS.AN.COM.DataService).IsPrivate("CT.AN.SurgicalMaterial")
ClassMethod IsPrivate(className As %String) As %Boolean
{
	set result=0
	set rowId=$o(^CT.AN.TablePermissionI("IPermission"," "_$ZCVT(className,"U")," PRIVATE",""))
	if rowId>0 set result=1
	
	quit result
}

/// 判断是否已绑定了权限归属，只考虑私有的情况
ClassMethod HasBindedAttribution(className, rowId) As %Boolean
{
	set attributionId=$o(^CF.AN.DataAttributionI("IData"," "_$ZCVT(className,"U")," "_rowId,""))
	quit $s(attributionId>0:1,1:0)
}

/// 创建数据权限归属
ClassMethod CreateAttribution(className, rowId, hospId, ByRef message) As CF.AN.DataAttribution
{
	set attribution = ##class(CF.AN.DataAttribution).%New()
	set attribution.HospitalID = hospId
	set attribution.TableName = className
	set attribution.DataRowID = rowId
	
	set sc=attribution.%Save()
	if $$$ISERR(sc)
	{
		set message="E^"_$System.Status.GetErrorText(sc,"zh-cn")
	}
	else
	{
		set message="S^"
	}
	
	quit attribution
}

/// 绑定数据权限
/// w ##class(CIS.AN.COM.DataService).BindAttribution("CF.AN.OperFloor",21,2)
ClassMethod BindAttribution(className, rowId, hospId) As %String
{
	set result= "S^"
	if ((hospId>0)&&('..HasBindedAttribution(className, rowId)))
	{
        set instance=""
        if ($classmethod(className,"%ExistsId",rowId)=1)
        {
            set instance=$classmethod(className,"%OpenId",rowId)
            set $property(instance,"DataAttribution")=..CreateAttribution(className, rowId, hospId,.message)
            if ($e(message,1)="E")
            {
                set result=message
            }
            else
            {
            	set sc=$method(instance,"%Save")
            	if ($System.Status.IsOK(sc))
            	{
                	set result="S^"_$method(instance,"%Id")
            	}
            	else
            	{
                	set result="E^"_$System.Status.GetErrorText(sc) // 获取错误详细信息(语言使用中文)
            	}
            }
      	}
	}
    quit result
}

/// 取消绑定数据权限归属
ClassMethod UnbindAttribution(className, rowId) As %String
{
	set result="S^"
	if (..HasBindedAttribution(className, rowId))
	{
		set attributionId=$o(^CF.AN.DataAttributionI("IData"," "_$ZCVT(className,"U")," "_rowId,""))
		if (##class(CF.AN.DataAttribution).%ExistsId(attributionId))
		{
			set sc = ##class(CF.AN.DataAttribution).%DeleteId(attributionId)
			if ($System.Status.IsOK(sc))
        	{
            	set result="S^"
        	}   
        	else
        	{
            	set result="E^"_$System.Status.GetErrorText(sc,"zh-cn") 
        	}
		}
	}
	
	quit result
}

}

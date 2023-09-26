/// 数据对照表业务
Class CIS.OPApp.BL.DataMapping Extends %RegisteredObject
{

/// 获取外部ID
ClassMethod GetExternalID(tableName, instanceId, externalSystem) As %String
{
	set externalId=$o(^CIS.OPApp.DataMappingI("Ins"," "_$ZCVT(tableName,"U")," "_instanceId," "_$ZCVT(externalSystem,"U"),""))
	quit $e(externalId,2,$l(externalId))
}

/// 获取内部ID
ClassMethod GetInstanceID(tableName, externalId, externalSystem) As %String
{
	set instanceId=$o(^CIS.OPApp.DataMappingI("Ext"," "_$ZCVT(tableName,"U")," "_$ZCVT(externalSystem,"U")," "_externalId,""))
	quit $e(instanceId,2,$l(instanceId))
}

/// 获取RowId
ClassMethod GetRowId(tableName, externalId, externalSystem) As %String
{
	set instanceID=..GetInstanceID(tableName, externalId, externalSystem)
	set rowId=$o(^CIS.OPApp.DataMappingI("Ext"," "_$ZCVT(tableName,"U")," "_$ZCVT(externalSystem,"U")," "_externalId,instanceID,""))
	quit $e(rowId,2,$l(rowId))
}

/// 存储Mapping
ClassMethod Store(data As CIS.OPApp.DTO.Base.DataMapping) As %Status
{
	if (data.Validate())
	{
		set instanceID=..GetInstanceID(data.TableName,data.ExternalID,data.ExternalSystem)
		if (instanceID="")
		{
			do ..Create(data)
		}
		elseif (instanceID'=data.InstanceID)
		{
			do ..Restore(data)
		}
		
		quit $$$OK
	}
	
	quit $$$ERROR("传入参数错误")
}

/// 新增Mapping
ClassMethod Create(data As CIS.OPApp.DTO.Base.DataMapping) As %Status
{
	set obj=##class(CIS.OPApp.DataMapping).%New()
	set obj.TableName=data.TableName
	set obj.ExternalSystem=data.ExternalSystem
	set obj.ExternalID=data.ExternalID
	set obj.InstanceID=data.InstanceID
	
	set sc=obj.%Save()
	
	if $$$ISOK(sc) quit $$$OK
	else  quit $$$ERROR(sc)
}

/// 更新Mapping
ClassMethod Restore(data As CIS.OPApp.DTO.Base.DataMapping) As %Status
{
	set rowId=..GetRowId(data.TableName,data.ExternalID,data.ExternalSystem)
	set obj=##class(CIS.OPApp.DataMapping).%OpenId(rowId)
	set obj.TableName=data.TableName
	set obj.ExternalSystem=data.ExternalSystem
	set obj.ExternalID=data.ExternalID
	set obj.InstanceID=data.InstanceID
	
	set sc=obj.%Save()
	
	if $$$ISOK(sc) quit $$$OK
	else  quit $$$ERROR(sc)
}

}

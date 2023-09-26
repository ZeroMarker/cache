/// 与旧版本的接口类
Class CIS.AN.BL.Import Extends %RegisteredObject
{

/// Creator：      	yongyang
/// CreatDate：    	2020-2-10
/// Description： 	设置单位字典对照
/// Table：        	CT.AN.Uom
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Import).ResetUomExternalID()
ClassMethod ResetUomExternalID() As %String
{
	set rowId=0
	for
	{
		set rowId=$o(^CT.AN.UomD(rowId))
		quit:rowId=""
		
		set Uom=##class(CT.AN.Uom).%OpenId(rowId)
		set externalId=$o(^CT("UOM",0,"Code",$ZCVT(Uom.Code,"U"),""))
		set Uom.ExternalID=externalId
		do Uom.%Save()
	}
	quit "reset uom externalId success!"
}

/// Creator：      	yongyang
/// CreatDate：    	2020-2-10
/// Description： 	备份手术分级字典
/// Table：        	CT.AN.OperClass
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Import).BackupOperClass()
ClassMethod BackupOperClass() As %String
{
	kill ^CT.AN.OperClassD.Backup
	kill ^CT.AN.OperClassI.Backup
	kill ^CT.AN.OperClassS.Backup
	merge ^CT.AN.OperClassD.Backup=^CT.AN.OperClassD
	merge ^CT.AN.OperClassI.Backup=^CT.AN.OperClassI
	merge ^CT.AN.OperClassS.Backup=^CT.AN.OperClassS
	
	quit "backup operclass success!"
}

/// Creator：      	yongyang
/// CreatDate：    	2020-2-10
/// Description： 	清空手术分级字典
/// Table：        	CT.AN.OperClass
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Import).ClearOperClass()
ClassMethod ClearOperClass() As %String
{
	kill ^CT.AN.OperClassD
	kill ^CT.AN.OperClassI
	kill ^CT.AN.OperClassS
	
	quit "clear operclass success!"
}

/// Creator：      	yongyang
/// CreatDate：    	2020-2-10
/// Description： 	导入手术分级字典
/// Table：        	CT.AN.OperClass
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Import).ImportOperClass()
ClassMethod ImportOperClass() As %String
{
	TSTART
	set rowId=0,fe=0
	for
	{
		set rowId=$o(^ORC("CATEG",rowId))
		quit:(rowId="")||(fe=1)
		
		set code=$p(^ORC("CATEG",rowId),"^",1)
		set desc=$p(^ORC("CATEG",rowId),"^",2)
		set activeDate=$p(^ORC("CATEG",rowId),"^",3)
		set expireDate=$p(^ORC("CATEG",rowId),"^",4)
		
		if $d(^CT.AN.OperClassI("IExt"," "_rowId))>0
		{
			set objId=$o(^CT.AN.OperClassI("IExt"," "_rowId,0))
			set obj=##class(CT.AN.OperClass).%OpenId(objId)
		}
		else
		{
			set obj=##class(CT.AN.OperClass).%New()
		}
		set obj.Code=code
		set obj.Description=desc
		set obj.ActiveDate=activeDate
		set obj.ExpireDate=expireDate
		set obj.ExternalID=rowId
		
		set sc=obj.%Save()
		if $$$ISERR(sc) set fe=1
	}
	
	if fe=1 TRollBack  quit $system.Status.GetErrorText(sc)
	TCOMMIT
	
	quit "S^操作完毕"
}

/// Creator：      	yongyang
/// CreatDate：    	2020-2-10
/// Description： 	备份手术字典
/// Table：        	CT.AN.Operation
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Import).BackupOperation()
ClassMethod BackupOperation() As %String
{
	kill ^CT.AN.OperationD.Backup
	kill ^CT.AN.OperationI.Backup
	kill ^CT.AN.OperationS.Backup
	merge ^CT.AN.OperationD.Backup=^CT.AN.OperationD
	merge ^CT.AN.OperationI.Backup=^CT.AN.OperationI
	merge ^CT.AN.OperationS.Backup=^CT.AN.OperationS
	
	quit "backup success!"
}

/// Creator：      	yongyang
/// CreatDate：    	2020-2-10
/// Description： 	清空手术字典
/// Table：        	CT.AN.OperClass
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Import).ClearOperClass()
ClassMethod ClearOperation() As %String
{
	kill ^CT.AN.OperationD
	kill ^CT.AN.OperationI
	kill ^CT.AN.OperationS
	
	quit "clear Operation success!"
}

/// Creator：      	yongyang
/// CreatDate：    	2020-2-10
/// Description： 	导入手术字典
/// Table：        	CT.AN.Operation
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Import).ImportOperation()
ClassMethod ImportOperation() As %String
{
	do ..BackupOperation()
	TSTART
	set operId=0,fe=0
	for
	{
		set operId=$o(^ORC("OPER",operId))
		quit:(operId="")||(fe=1)
		
		set code=$p(^ORC("OPER",operId),"^",1)
		set desc=$p(^ORC("OPER",operId),"^",2)
		set operCatDr=$p(^ORC("OPER",operId),"^",7)
		set operCatDr=+operCatDr
		set operClass=$o(^CT.AN.OperClassI("IExt"," "_operCatDr,0))
		set dateFrom=$p(^ORC("OPER",operId),"^",5)
		set dateTo=$p(^ORC("OPER",operId),"^",6)
		set ICD10=$p(^ORC("OPER",operId),"^",14)
		set Active="Y"
		set:(dateTo'="")&&(dateTo<=+$h) Active="N"
		set Alias=""
		set:$d(^ORC("OPER",operId,"ALIAS",1)) Alias=$p(^ORC("OPER",operId,"ALIAS",1),"^",1)
		set obj=""
		if $d(^CT.AN.OperationI("IExt"," "_operId))>0
		{
			set objId=$o(^CT.AN.OperationI("IExt"," "_operId,0))
			set obj=##class(CT.AN.Operation).%OpenId(objId)
		}
		else
		{
			set obj=##class(CT.AN.Operation).%New()
		}
		set obj.Active=Active
		set obj.Alias=Alias
		set obj.Code=code
		set obj.Description=desc
		set obj.ActiveDate=dateFrom
		set obj.ExpireDate=dateTo
		set obj.ExternalID=operId
		set obj.ICDCode=ICD10
		do:operClass'="" obj.OperClassSetObjectId(operClass)
		set sc=obj.%Save()
		if $$$ISERR(sc) set fe=1
	}
	
	if fe=1 TRollBack  quit $system.Status.GetErrorText(sc)
	TCOMMIT
	
	quit "S^操作完毕"
}

}

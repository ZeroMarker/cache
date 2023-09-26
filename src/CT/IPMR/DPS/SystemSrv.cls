/// 名称: CT.IPMR.DPS.SystemSrv
/// 描述: DP包系统定义相关服务
/// 创建者：liyi
/// 创建日期: 2019-10-28
Class CT.IPMR.DPS.SystemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询系统定义
/// Table：       CT.IPMR.DP.System
/// Input：       
/// output:       参数配置列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.DPS.SystemSrv","QuerySystem")
Query QuerySystem() As %Query(ROWSPEC = "ID:%String,SysCode:%String,SysDesc:%String,ExCode:%String,DataSoap:%String,Resume:%String,EMRUrl:%String") [ SqlProc ]
{
}

ClassMethod QuerySystemExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xID = ""
 	For {
		Set xID = $o(^CT.IPMR.DP.SystemD(xID))
		Quit:xID=""
		Set obj = ##class(CT.IPMR.DP.System).GetObjById(xID)
		Continue:'$IsObject(obj)
		
		Set SysCode = obj.DSSysCode
		Set SysDesc = obj.DSSysDesc
		Set ExCode  = obj.DSExCode
		Set DataSoap = obj.DSDataSoap
		Set Resume = obj.DSResume
		Set EMRUrl = obj.DSEMRUrl
		Set Data=$lb(xID,SysCode,SysDesc,ExCode,DataSoap,Resume,EMRUrl)
 		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QuerySystemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySystemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySystemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySystemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liyi
/// CreatDate：   2021-12-23
/// Description:  查询接口配置
/// Table：       CT.IPMR.DP.SoapConfig
/// Input：       
/// output:       接口配置列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.DPS.SystemSrv","QuerySoapConfig",2)
Query QuerySoapConfig(aSysID As %String) As %Query(ROWSPEC = "ID:%String,TargetAddress:%String,TargetMethod:%String,ModelTypeID:%String,ModelTypeCode:%String,ModelTypeDesc:%String,Arguments:%String") [ SqlProc ]
{
}

ClassMethod QuerySoapConfigExecute(ByRef qHandle As %Binary, aSysID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xSoapID = ""
 	For {
		Set xSoapID = $o(^CT.IPMR.DP.SoapConfigI("IndexOfSystem",aSysID,xSoapID))
		Quit:xSoapID=""
		Set objSoapConfig = ##class(CT.IPMR.DP.SoapConfig).GetObjById(xSoapID)
		Continue:'$isobject(objSoapConfig)
		
		Set TargetAddress = objSoapConfig.TargetAddress
		Set TargetMethod = objSoapConfig.TargetMethod
		Set objModelType = objSoapConfig.ModelTypeDr
		Set Arguments = objSoapConfig.Arguments
		continue:'$isobject(objModelType)
		Set ModelTypeID = objModelType.%Id()
		Set ModelTypeCode = objModelType.BDCode
		Set ModelTypeDesc = objModelType.BDDesc
		
		Set Data=$lb(xSoapID,TargetAddress,TargetMethod,ModelTypeID,ModelTypeCode,ModelTypeDesc,Arguments)
 		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QuerySoapConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySoapConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySoapConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySoapConfigExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}

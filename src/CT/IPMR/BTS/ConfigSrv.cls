/// 名称: CT.IPMR.BTS.ConfigSrv
/// 描述: 参数配置相关服务方法
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BTS.ConfigSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询参数配置
/// Table：       CT.IPMR.BT.Config
/// Input：       
/// output:       参数配置列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.ConfigSrv","QueryConfig")
Query QueryConfig(aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Val:%String,ValDesc:%String,HospID:%String,HospDesc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QueryConfigExecute(ByRef qHandle As %Binary, aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xID = ""
 	For {
		Set xID = $o(^CT.IPMR.BT.ConfigD(xID))
		Quit:xID=""
		Set objConfig = ##class(CT.IPMR.BT.Config).GetObjById(xID)
		Continue:'$IsObject(objConfig)
		
		Set Code = objConfig.BCCode
		Set Desc = objConfig.BCDesc
		Set Val  = objConfig.BCVal
		Set ValDesc = objConfig.BCValDesc
		IF aAlias'="" {
			Continue:'((Code[aAlias)||(Desc[aAlias))
		}
			
		Set HospID = objConfig.BCHospID
		Set HospInfo = ##class(MA.IPMR.BTS.HospitalSrv).GetHospStrById(HospID)
		Set HospDesc = $p(HospInfo,"^",2)
		Set Resume = objConfig.BCResume
		Set Data=$lb(xID,Code,Desc,Val,ValDesc,HospID,HospDesc,Resume)
 		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryConfigExecute ]
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

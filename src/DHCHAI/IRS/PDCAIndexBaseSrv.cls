/// 名称: DHCHAI.IRS.PDCAIndexBaseSrv
/// 描述: PDCA指标库服务
/// 编写者：ShenC
/// 编写日期: 2022-07-06
Class DHCHAI.IRS.PDCAIndexBaseSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2022-07-06
/// Description:  输出'PDCA指标库'列表
/// Table：       DHCHAI.IR.PDCAIndexBase
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.PDCAIndexBaseSrv","QryPDCAIndexBase","1")
Query QryPDCAIndexBase(aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,IndexCode:%String,IndexDesc:%String,IndexType:%String,KPA:%String,LinkRep:%String,LinkRepPath:%String,LinkParm:%String,LinkCsp:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QryPDCAIndexBaseExecute(ByRef qHandle As %Binary, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//循环PDCA指标库
	Set xIndexCode=""
	For{
		Set xIndexCode=$o(^CT.MA.HAI.IR.PDCAIndexBaseI("IndexCode",xIndexCode))
		Quit:xIndexCode=""
		
		Set xID=""
		For{
			Set xID=$o(^CT.MA.HAI.IR.PDCAIndexBaseI("IndexCode",xIndexCode,xID))
			Quit:xID=""
			
			Set PAData=$g(^CT.MA.HAI.IR.PDCAIndexBaseD(xID))
			Continue:PAData=""
			
			Set IndexCode		=$lg(PAData,2)		//指标代码
			Set IndexDesc		=$lg(PAData,3)		//指标名称
			Set IndexType		=$lg(PAData,4)		//指标分类
			Set KPA				=$lg(PAData,5)		//标准值
			Set LinkRep			=$lg(PAData,6)		//报表名称
			Set LinkRepPath		=$lg(PAData,7)		//报表路径
			Set LinkParm		=$lg(PAData,8)		//报表参数
			Set LinkCsp			=$lg(PAData,9)		//关联csp
			Set IsActive		=$lg(PAData,10)		//是否有效
			//过滤无效数据
			Continue:(aIsActive="1")&&(IsActive'="1")
			
			Set Data=$lb(xID,IndexCode,IndexDesc,IndexType,KPA,LinkRep,LinkRepPath,LinkParm,LinkCsp,IsActive)  
	   		Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryPDCAIndexBaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPDCAIndexBaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPDCAIndexBaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPDCAIndexBaseExecute ]
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

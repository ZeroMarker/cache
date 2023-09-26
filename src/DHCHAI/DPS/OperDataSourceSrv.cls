/// 名称: DHCHAI.DPS.OperDataSourceSrv
/// 描述: 手术数据源相关服务
/// 编写者：liutao
/// 编写日期: 2022-11-18
Class DHCHAI.DPS.OperDataSourceSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liutao
/// CreatDate：   2022-11-18
/// Description:  查询手术数据源类型
/// Table：       DHCHAI.DP.OperDataSource
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.OperDataSourceSrv","QryDataSourceType")
Query QryDataSourceType() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,DataSource:%String,SourceCode:%String") [ SqlProc ]
{
}

ClassMethod QryDataSourceTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^CT.MA.HAI.DP.OperDataSourceD(xID))
		Quit:xID=""
		
		Set objDic = ##class(DHCHAI.DP.OperDataSource).GetObjById(xID)
		Continue:'$Isobject(objDic)
		
		Set Code 		= objDic.ODCode
		Set Desc 		= objDic.ODDesc
		Set DataSource =""
		Set DataSourceDr= objDic.DataSourceDr
		b ;1
		Set:DataSourceDr'="" DataSource=DataSourceDr.BTDesc
		Set SourceCode   =DataSourceDr.BTCode
		Set Data = $lb(xID,Code,Desc,DataSource,SourceCode)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryDataSourceTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDataSourceTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicTypeExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liutao
/// CreatDate：   2022-11-22
/// Description:  导入手术合并属性数据来源配置
/// w ##Class(DHCHAI.DPS.OperDataSourceSrv).ImportDataSource("^Inn^切口等级^1","^")
ClassMethod ImportDataSource(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set DataSourceCode    = $p(aInputStr,aSeparate,2)
	Set DataSourceDesc    = $p(aInputStr,aSeparate,3)
	Set Code    		  = $p(aInputStr,aSeparate,4)
	Quit:(DataSourceCode="")||(DataSourceDesc="")||(Code="")
	Quit:'$d(^DHCHAI.BT.DicTypeI("IdxofCode","OperDataSource")) return
    Set TypeID=""
	Set xTypeID = ""
	For {
		Set xTypeID = $o(^DHCHAI.BT.DicTypeI("IdxofCode","OperDataSource",xTypeID))
		Quit:xTypeID=""
		Set objDicType=##class(DHCHAI.BT.DicType).GetObjById(xTypeID)
		Continue:'$IsObject(objDicType)
		Set TypeID=xTypeID
	}
  
	Set DicRowID=""
	Set DicID=0
	For {
		Set DicID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeID,Code,DicID))
		Quit:DicID=""

		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set DicRowID=DicID
	}	
	Set InputStr=""_"^"_DataSourceCode_"^"_DataSourceDesc_"^"_DicRowID
	
	Set return =##class(DHCHAI.DP.OperDataSource).Update(InputStr,"^")
	Quit return
}

}

/// 名称: DHCWMR.MQService.ConditionSrv
/// 描述: 查询条件输出相关查询
/// 编写者：zhufei
/// 编写日期: 2014-12-23
Class DHCWMR.MQService.ConditionSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

///  Creator：     liyi
///  CreatDate：   2016-03-31
///  Description:  查询输出列
///  Table：       DHCWMR.MQ.CondConfig,DHCWMR.MQ.CondColConfig,DHCWMR.MQ.DataItems
///  Input：	   aModel：输出模式（1：配置模式,2:默认模式）
/// 					aCondfigID：条件配置ID
/// 				   aDataType：输出列类型（子类："DataSubCat",数据项："DataItem"）
/// 				   argID : 子类ID
/// 					argAlias：输入项
///  Return：      返回Query
///  do ##class(%Library.ResultSet).RunQuery("DHCWMR.MQService.ConditionSrv","QryCondCol","1","1","","")
Query QryCondCol(aModel As %String, aCondfigID As %String = "", aDataType As %String, argID As %String, argAlias As %String = "") As %Query(ROWSPEC = "ID:%String,Desc:%String,DataType:%String,IsChecked:%String,OutType:%String")
{
}

ClassMethod QryCondColExecute(ByRef qHandle As %Binary, aModel As %String, aCondfigID As %String = "", aDataType As %String, argID As %String, argAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	If (aModel=1){	//条件配置列
		Quit:aCondfigID="" $$$OK
		Set objCond = ##class(DHCWMR.MQ.CondConfig).GetObjById(aCondfigID)
		Quit:'$isobject(objCond) $$$OK
		
		For indCol=1:1:objCond.ChildCol.Count() {
			Set objCol=objCond.ChildCol.GetAt(indCol)
			Continue:'$IsObject(objCol)
			Set objSubCat=objCol.ColSubCat
			Set objDataItem=objCol.ColDataItem
			Continue:(objDataItem="")&&(objSubCat="")
			Set ID = objCol.%Id()
			if $isobject(objSubCat){
				Set Desc = objSubCat.DSCDesc
				Set OutType = "TEXT"
			}
			if $isobject(objDataItem){
				Set Desc = objDataItem.MRItemDesc
				Set OutType = objDataItem.DataType
			}
			Set DataType = "Cond"
			Set IsChecked = 1
			Set Data = $lb(ID,Desc,DataType,IsChecked,OutType)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	If (aModel=2){	//默认模式
		If (aDataType="DataSubCat"){		//子类
			Set xDataCatID=""
			For {
				Set xDataCatID=$o(^DHCWMR.MQ.DataCatD(xDataCatID))
				Quit:xDataCatID=""
				Set xID=""
				For {
					Set xID=$o(^DHCWMR.MQ.DataCatD(xDataCatID,"Sub",xID))
					Quit:xID=""
					
					Set ID=xDataCatID_"||"_xID
					Set objSubCat=##class(DHCWMR.MQ.DataSubCat).GetObjById(ID)
					Continue:'$isobject(objSubCat)
					Continue:(aCondfigID'="")&&($d(^DHCWMR.MQ.CondConfigI("Col","IndexColSubCat",ID,aCondfigID)))

					Set Desc = objSubCat.DSCDesc
					Continue:(argAlias'="")&&('(Desc[argAlias))
					Set IsChecked=0
					Set OutType = "TEXT"
					Set Data = $lb(ID,Desc,aDataType,IsChecked,OutType)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
		If (aDataType="DataItem"){		//数据源
			Quit:(aDataType="")||(argID="") $$$OK
			
			Set DataSubCatID=argID
			Set xDataSource=""
			For {
				Set xDataSource = $o(^DHCWMR.MQ.DataItemsI("IndexDataSrcSubCatDesc",xDataSource))
				Quit:xDataSource=""
				Continue:'$d(^DHCWMR.MQ.DataItemsI("IndexDataSrcSubCatDesc",xDataSource,DataSubCatID))
				
				Set Desc=""
				For {
					Set Desc = $o(^DHCWMR.MQ.DataItemsI("IndexDataSrcSubCatDesc",xDataSource,DataSubCatID,Desc))
					Quit:Desc=""
					Continue:(argAlias'="")&&('(Desc[argAlias))
					
					Set ID = $o(^DHCWMR.MQ.DataItemsI("IndexDataSrcSubCatDesc",xDataSource,DataSubCatID,Desc,""))
					Set objItem = ##class(DHCWMR.MQ.DataItems).GetObjById(ID)
					Continue:'$isobject(objItem)
					Continue:'objItem.IsActive
					Continue:(aCondfigID'="")&&($d(^DHCWMR.MQ.CondConfigI("Col","IndexDataItem",ID,aCondfigID)))
					 	
					Set IsChecked=0
					Set OutType =objItem.DataType
					Set Data = $lb(ID,Desc,aDataType,IsChecked,OutType)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCondColClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCondColExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCondColFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCondColExecute ]
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

///  Creator：     liyi
///  CreatDate：   2016-03-31
///  Description:  查询查询条件
///  Table：       DHCWMR.MQ.CondConfig
///  Input：	   aCondID:DHCWMR.MQ.CondConfig.ID
///  Return：      返回Query
///  do ##class(%Library.ResultSet).RunQuery("DHCWMR.MQService.ConditionSrv","QryCondInput","1")
Query QryCondInput(aCondID As %String) As %Query(ROWSPEC = "ID:%String,LogicalID:%String,LogicalDesc:%String,QryType:%String,QryID:%String,QryDesc:%String,OperID:%String,OperDesc:%String,CompVal:%String,IsChecked:%String")
{
}

ClassMethod QryCondInputExecute(ByRef qHandle As %Binary, aCondID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aCondID="" $$$OK

	Set objCond = ##class(DHCWMR.MQ.CondConfig).GetObjById(aCondID)
	Quit:'$isobject(objCond) $$$OK
	Set InputStr = objCond.CCInputStr
	For indInput=1:1:$l(InputStr,$c(1)) {
		Set tmpInput=$p(InputStr,$c(1),indInput)
		Continue:tmpInput=""
		
		Set QryType = $p($p(tmpInput,$c(2),1),$c(3),1)			//类型"DataSubCat"、'DataItem"
		Set QryID = $p($p(tmpInput,$c(2),1),$c(3),2)		
		Set OperID = $p(tmpInput,$c(2),2)
		Set CompVal = $p(tmpInput,$c(2),3)
		Continue:(QryID="")||(OperID="")||(CompVal="")
		
		Set LogicalID = $p(tmpInput,$c(2),4)
		
		If QryType="DataSubCat" {
			Set objDataSubCat = ##class(DHCWMR.MQ.DataSubCat).GetObjById(QryID)
			Continue:'$isobject(objDataSubCat)
			Set QryDesc = objDataSubCat.DSCDesc
		}
		If QryType="DataItem" {
			Set objDataItem = ##class(DHCWMR.MQ.DataItems).GetObjById(QryID)
			Continue:'$isobject(objDataItem)
			Set QryDesc = objDataItem.MRItemDesc
		}
		
		Set objOperDic = ##class(DHCWMR.SS.Dictionary).GetObjById(OperID)
		Continue:'$isobject(objOperDic)
		Set OperDesc = objOperDic.SDDesc
		Set LogicalDesc=""
		Set objLogicalDic = ##class(DHCWMR.SS.Dictionary).GetObjById(LogicalID)
		if $isobject(objLogicalDic)
		{	
			Set LogicalDesc = objLogicalDic.SDDesc
		}
		Set IsChecked = 1
		//序号,逻辑ID,逻辑描述,查询项类型,查询项ID,查询项描述,操作符ID,操作符描述,比较值
		Set Data = $lb(indInput,LogicalID,LogicalDesc,QryType,QryID,QryDesc,OperID,OperDesc,CompVal,IsChecked)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	Quit $$$OK
}

ClassMethod QryCondInputClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCondInputExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCondInputFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCondInputExecute ]
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

/// w ##class(DHCWMR.MQService.ConditionSrv).ChangeOperCode("大于等于")
ClassMethod ChangeOperCode(aOperCode As %String)
{
	New (aOperCode)
	Set return=""
	Quit:aOperCode="" return
	Set:(aOperCode="大于等于") return=">="
	Set:(aOperCode="小于等于") return="<="
	Set:(aOperCode="大于") return=">"
	Set:(aOperCode="小于") return="<"
	Set:(aOperCode="等于") return="=="
	Set:(aOperCode="包含") return="LIKE"
	Quit return
}

/// w ##class(DHCWMR.MQService.ConditionSrv).ChangeLogicalCode("或者")
ClassMethod ChangeLogicalCode(aOperCode As %String)
{
	New (aOperCode)
	Set return=""
	Quit:aOperCode="" return
	Set:(aOperCode="或者") return="||"
	Set:(aOperCode="并且") return="&&"
	Quit return
}

}

/// 名称: CT.IPMR.FPS.MQColumnSrv
/// 描述: 输出列配置服务类
/// 创建者：liyi
/// 创建日期: 2019-12-11
Class CT.IPMR.FPS.MQColumnSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  导入输出列配置
/// Table：       CT.IPMR.FP.MQColumn
/// Input：       输出列配置
/// w ##class("CT.IPMR.FPS.MQColumnSrv").ImportColumn("^O02.024.10^操作-主操作代码10^O02.024.10^手术和操作信息^1^480")
ClassMethod ImportColumn(aInput As %String) As %String
{
	New (aInput)
	Set return = 0
	//Set ^TMP("ImportColumn")=aInput
	Quit:aInput="" return
	Set ColCatDesc = $p(aInput,"^",5)
	Set objColCat = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("MQColumnCat",ColCatDesc)
	Quit:'$IsObject(objColCat) return
	Set ColCatID = objColCat.%Id()
	Set $p(aInput,"^",5)=ColCatID
	Set return = ##class(CT.IPMR.FP.MQColumn).Update(aInput,"^")
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  输出列配置
/// Table：       CT.IPMR.FP.MQColumn
/// Input：       aColCatID：分类
///               aAlias：关键字
/// output:       符合条件的字典数据  
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.MQColumnSrv","QryColumn","301","")
Query QryColumn(aColCatID As %String, aAlias As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,DataItems:%String,IsActive:%String,OrderNo:%String")
{
}

ClassMethod QryColumnExecute(ByRef qHandle As %Binary, aColCatID As %String, aAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	// 多语言
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
 	//Set ^TMP("QryColumn")=$lb(aColCatID,aAlias)
 	Set xColCatID = ""
 	For {
		Set xColCatID = $o(^CT.IPMR.FP.MQColumnI("IndexColCatOrderNo",xColCatID))
		Quit:xColCatID=""
		Continue:(aColCatID'="")&&(aColCatID'=xColCatID)
		
		Set xOrderNo = ""
		For {
			Set xOrderNo = $o(^CT.IPMR.FP.MQColumnI("IndexColCatOrderNo",xColCatID,xOrderNo))
			Quit:xOrderNo=""
			
			Set xID = ""
			For {
				Set xID = $o(^CT.IPMR.FP.MQColumnI("IndexColCatOrderNo",xColCatID,xOrderNo,xID))
				Quit:xID=""
				
				Set obj = ##class(CT.IPMR.FP.MQColumn).GetObjById(xID)
				Continue:'$isobject(obj)
				
				Set Code 		= obj.FMCode
				Set Desc 		= obj.FMDesc
				Set:Desc'="" Desc=##class(CT.IPMR.FP.MQColumn).GetTranByDesc("FMDesc",Desc,langid)
				Continue:(aAlias'="")&&(Desc'[aAlias)
				Set DataItems 	= "" //obj.FMDataItems
				Set objColCat 	= obj.FMColCatDr
				Continue:'$isobject(objColCat)
				Set IsActive 	= obj.FMIsActive
				Set OrderNo 	= obj.FMOrderNo
				Set Data = $lb(xID,Code,Desc,DataItems,IsActive,OrderNo)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
 	
	Quit $$$OK
}

ClassMethod QryColumnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryColumnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryColumnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryColumnExecute ]
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
/// CreatDate：   2021-11-22
/// Description:  自动生成输出列配置
/// Table：       CT.IPMR.FP.MQColumn
/// Input：       
/// w ##class("CT.IPMR.FPS.MQColumnSrv").AutomatiColumn()
ClassMethod AutomatiColumn() As %String
{
	// 根据字典项目MQColumnCat（输出列分类）按顺序处理
	Set xCatOrder = ""
	For {
		Set xCatOrder = $o(^CT.IPMR.BT.DictionaryI("IndexTypeOrder"," "_$ZCVT("MQColumnCat","U"),xCatOrder))
		Quit:xCatOrder=""
		Set xHospID = ""
		For {
			Set xHospID = $o(^CT.IPMR.BT.DictionaryI("IndexTypeOrder"," "_$ZCVT("MQColumnCat","U"),xCatOrder,xHospID))
			Quit:xHospID=""
			Set xCatID = ""
			For {
				Set xCatID = $o(^CT.IPMR.BT.DictionaryI("IndexTypeOrder"," "_$ZCVT("MQColumnCat","U"),xCatOrder,xHospID,xCatID))
				Quit:xCatID=""
				
				Set objCat = ##class(CT.IPMR.BT.Dictionary).GetObjById(xCatID)
				Continue:'$isobject(objCat)
				Continue:objCat.BDIsActive'=1
				
				Set CatDesc = objCat.BDDesc
				Set RegStr = objCat.BDResume
				Continue:RegStr=""
				
				Set RegExp = $p(RegStr,"|",1)  // 输出列代码匹配正则表达式
				Set FPType = $p(RegStr,"|",2)  // 首页类型代码
				Continue:RegExp=""
				
				Set OrderNo=1
				Set xDataItemID = ""
				For {
					Set xDataItemID = $o(^CT.IPMR.FP.DataItemD(xDataItemID))
					Quit:xDataItemID=""
					Set objDataItem = ##class(CT.IPMR.FP.DataItem).GetObjById(xDataItemID)
					Continue:'$isobject(objDataItem)
					
					If FPType'="" {
						Set ListobjFPType = objDataItem.FDFPType
						Set DateItemFPType=""
						For ind=1:1:ListobjFPType.Count() {
							Set objDic= ListobjFPType.GetAt(ind)
							Continue:'$isobject(objDic)
							If DateItemFPType="" {
								Set DateItemFPType = objDic.BDCode
							}else{
								Set DateItemFPType = DateItemFPType_","_objDic.BDCode
							}
						}
						Continue:DateItemFPType'=FPType	//过滤配置不符合
					}
					Set DataItemCode = objDataItem.FDCode
					
					// 生成单项信息
					If (DataItemCode["P")||(DataItemCode["F")||(DataItemCode["B")||(DataItemCode["T")  {
						Set ColumnCode = $p(DataItemCode,".",1,2)
						Set ColumnDesc = objDataItem.FDDesc
						Set ColumnDesc = $tr(ColumnDesc,"代码","") // 处理描述中的汉字
						Set ColumnID = $o(^CT.IPMR.FP.MQColumnI("IndexCode"," "_$ZCVT(ColumnCode,"U"),0))
						Set MatchResult = $MATCH(ColumnCode,RegExp)
						Continue:MatchResult=0
						
						Set TOrderNo = "",DataItems=""
						If ColumnID'="" {
							Set ExistItems = ##class(CT.IPMR.FP.MQColumn).GetObjById(ColumnID).FMDataItems
							// 需添加的项目是否已经在已有配置中
							Set ExistFlag = 0
							For ind = 1:1:$length(ExistItems,",") {
								Set ExistItem = $p(ExistItems,",",ind)
								Continue:ExistItem=""
								Set:ExistItem=DataItemCode ExistFlag=1
								Quit:ExistFlag=1
							}
							Continue:ExistFlag=1
							Set DataItems = ExistItems_","_DataItemCode
							Set TOrderNo = ##class(CT.IPMR.FP.MQColumn).GetObjById(ColumnID).FMOrderNo
						}else{
							Set DataItems = DataItemCode
						}
						Set InputStr = ColumnID
						Set InputStr = InputStr_"^"_ColumnCode
						Set InputStr = InputStr_"^"_ColumnDesc
						Set InputStr = InputStr_"^"_DataItems
						Set InputStr = InputStr_"^"_xCatID
						Set InputStr = InputStr_"^"_1
						Set InputStr = InputStr_"^"_$s(TOrderNo="":OrderNo,1:TOrderNo)
						Do ##class(CT.IPMR.FP.MQColumn).Update(InputStr,"^")
						Set:TOrderNo="" OrderNo = OrderNo+1
					}elseif (DataItemCode["D")||(DataItemCode["O" ) {
						If $MATCH(DataItemCode,RegExp) {
							Set ColumnCode = DataItemCode
							Set ColumnDesc = objDataItem.FDDesc
							Set ColumnID = $o(^CT.IPMR.FP.MQColumnI("IndexCode"," "_$ZCVT(ColumnCode,"U"),0))
							Set TOrderNo = "",DataItems=""
							If ColumnID'="" {
								Set ExistItems = ##class(CT.IPMR.FP.MQColumn).GetObjById(ColumnID).FMDataItems
								// 需添加的项目是否已经在已有配置中
								Set ExistFlag = 0
								For ind = 1:1:$length(ExistItems,",") {
									Set ExistItem = $p(ExistItems,",",ind)
									Continue:ExistItem=""
									Set:ExistItem=DataItemCode ExistFlag=1
									Quit:ExistFlag=1
								}
								Continue:ExistFlag=1
								Set DataItems = ExistItems_","_DataItemCode
								Set TOrderNo = ##class(CT.IPMR.FP.MQColumn).GetObjById(ColumnID).FMOrderNo
							}else{
								Set DataItems = DataItemCode
							}
							Set InputStr = ColumnID
							Set InputStr = InputStr_"^"_ColumnCode
							Set InputStr = InputStr_"^"_ColumnDesc
							Set InputStr = InputStr_"^"_DataItems
							Set InputStr = InputStr_"^"_xCatID
							Set InputStr = InputStr_"^"_1
							Set InputStr = InputStr_"^"_$s(TOrderNo="":OrderNo,1:TOrderNo)
							Do ##class(CT.IPMR.FP.MQColumn).Update(InputStr,"^")
							Set:TOrderNo="" OrderNo = OrderNo+1
						}
						// 分类
						If $MATCH($p(DataItemCode,".",1,2),RegExp) {
							Set ColumnCode = $p(DataItemCode,".",1,2) // 输出列代码
							Set ColumnDesc = objDataItem.FDDesc
							Set ColumnDesc = $tr(ColumnDesc,"0123456789","") // 处理描述中的数字
							Set ColumnID = $o(^CT.IPMR.FP.MQColumnI("IndexCode"," "_$ZCVT(ColumnCode,"U"),0))
							Set TOrderNo = "",DataItems=""
							If ColumnID'="" {
								Set ExistItems = ##class(CT.IPMR.FP.MQColumn).GetObjById(ColumnID).FMDataItems
								// 需添加的项目是否已经在已有配置中
								Set ExistFlag = 0
								For ind = 1:1:$length(ExistItems,",") {
									Set ExistItem = $p(ExistItems,",",ind)
									Continue:ExistItem=""
									Set:ExistItem=DataItemCode ExistFlag=1
									Quit:ExistFlag=1
								}
								Continue:ExistFlag=1
								Set DataItems = ExistItems_","_DataItemCode
								Set TOrderNo = ##class(CT.IPMR.FP.MQColumn).GetObjById(ColumnID).FMOrderNo
							}else{
								Set DataItems = DataItemCode
							}
							Set InputStr = ColumnID
							Set InputStr = InputStr_"^"_ColumnCode
							Set InputStr = InputStr_"^"_ColumnDesc
							Set InputStr = InputStr_"^"_DataItems
							Set InputStr = InputStr_"^"_xCatID
							Set InputStr = InputStr_"^"_1
							Set InputStr = InputStr_"^"_$s(TOrderNo="":OrderNo,1:TOrderNo)
							Do ##class(CT.IPMR.FP.MQColumn).Update(InputStr,"^")
							Set:TOrderNo="" OrderNo = OrderNo+1
						}
					}else{
						Continue
					}
				}
				
			}
		}
	}
	Quit 1
}

/// Creator：     liyi
/// CreatDate：   2023-02-14
/// Description:  通过列ID获取分类信息
/// Table：       
/// Input：       
/// w ##class("CT.IPMR.FPS.MQColumnSrv").GetMQColumnInfo(1)
ClassMethod GetMQColumnInfo(aID As %String) As %String
{
	New (aID)
	Set return = 0
	//Set ^TMP("aID")=aInput
	Quit:aID="" return
	Set objColumn = ##class(CT.IPMR.FP.MQColumn).GetObjById(aID)
	Quit:'$isobject(objColumn) return
	Set DataItems = objColumn.FMDataItems
	Quit:DataItems="" return
	Set objDataItem = ##class(CT.IPMR.FP.DataItem).GetObjByCode($p(DataItems,",",1),"")
	Quit:'$isobject(objDataItem) return
	Quit:'$isobject(objDataItem.FDCatDr) return
	Quit:'$isobject(objDataItem.FDCatDr.FDDataTypeDr) return
	
	Set dataType = objDataItem.FDCatDr.FDDataTypeDr.BDCode
	Set DataItemCat = objDataItem.FDCatDr.FDCode
	Set ShowCode = objDataItem.FDCatDr.FDIsShowCode
	Set return = dataType_"^"_DataItemCat_"^"_ShowCode
	Quit return
}

}

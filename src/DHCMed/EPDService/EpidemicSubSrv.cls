Class DHCMed.EPDService.EpidemicSubSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 查询附卡信息
/// ReportID:传染病报告的ID
/// AppendixID：传染病附卡的ID
/// Flag：1--使用传染病报告的ID查询所有已保存的附卡信息
///       2--使用传染病字典所关联的附卡信息初始化附卡表格
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.EpidemicSubSrv","QryEpidemicSub","",3,"")
Query QryEpidemicSub(ReportID As %String, AppendixID As %String, aEpisodeID As %String, aIsActive As %String = "") As %Query(ROWSPEC = "RowID:%String,ItemCaption:%String:项目,ItemCode::%String,ItemValue:%String:值,ItemType:%String,ItemDic:%String,AppendixItemID:%String,HiddenValue:%String,NoticeText:%String:提示,IsNecess:%String:是否必填")
{
}

ClassMethod QryEpidemicSubExecute(ByRef qHandle As %Binary, ReportID As %String, AppendixID As %String, aEpisodeID As %String, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If (ReportID'="")&&(AppendixID="") {
		Set objReport=##class(DHCMed.EPD.Epidemic).GetObjById(ReportID)
		If $IsObject(objReport){
			If $IsObject(objReport.MEPDICDDR) {
				Set AppendixID=objReport.MEPDICDDR.MIFAppendix
			}
		}
	}
	Quit:AppendixID="" $$$OK
	
	Set ItemID=""
	For {
		Set ItemID=$o(^DHCMed.EPDCi("ACSUB","IndexParef",AppendixID,ItemID))
		Quit:ItemID=""
		Set objItem=##Class(DHCMed.EPD.AppendixCardSub).GetObjById(ItemID)
		Continue:'$IsObject(objItem)
		Set IsActive=objItem.MACIActive
		Continue:(aIsActive'="")&&(aIsActive'=IsActive)
		Set ItemValRowID=""                                //值ID
		Set ItemValue1=""                                  //显示值（转换值）
		Set ItemValue=""                                   //真实值（存储值）
		Set ItemRowID=objItem.%Id()                        //项目ID
		Set ItemName=objItem.MACIName                      //项目名称
		Set ItemCode=objItem.MACICode                      //项目名称
		Set ItemDicName=objItem.MACIDicName                //项目字典代码
		Set ItemDataTypeCode=objItem.MACIDataType          //项目数据类型代码
		Set objDataTypeDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICAPPENDIXDATATYPE",ItemDataTypeCode,"")
		Set ItemDataTypeDesc=objDataTypeDic.Description    //项目数据类型描述
		Set ItemValExp=objItem.MACIValExp                  //默认值表达式
		Set ItemIsNecess=objItem.MACIIsNecess              //是否必填项
		//w "ItemName="_ItemName_",ItemDataTypeDesc="_ItemDataTypeDesc,!
		If (ReportID'="")&$d(^DHCMed.EPD("EPD",+ReportID,"I")) {
			Set ItemValID=0
			For {
				Set ItemValID=$o(^DHCMed.EPD("EPD",ReportID,"I",ItemValID))
				Quit:ItemValID=""
				Quit:ItemValRowID'=""
				Set objItemVal=##Class(DHCMed.EPD.EpidemicSub).GetObjById(ReportID_"||"_ItemValID)
				Continue:'$IsObject(objItemVal)
				Continue:objItemVal.MEPDSAppendixItemID'=ItemRowID
				Set ItemValRowID=objItemVal.%Id()
				Set ItemValue=objItemVal.MEPDSValue
			}
		} Else {
			Set ItemValue=..ChangeExp(ItemValExp,aEpisodeID)
			Set ItemValRowID=""
		}
		//显示值（转换值）
		Set ItemValue1=ItemValue
		//If (ItemDataTypeDesc["字典")&&(ItemValue1'="") {
		If (objItem.MACIDataType=4)&&(ItemValue1'="") {
			Set objItemValue=##class(DHCMed.SS.Dictionary).GetByTypeCode($ZCVT(ItemDicName,"U"),ItemValue1,"")
			If $IsObject(objItemValue) {
				Set ItemValue1=objItemValue.Description
				//w ItemValue1,!
			}
		}
		If (ItemDataTypeDesc["是否") {
			Set ItemValue=$s(ItemValue["Y":"Y",1:"N")
			Set ItemValue1=$s(ItemValue1["Y":"是",1:"否")
		}
		If (ItemDataTypeDesc["数字") {
			Set ItemValue=+ItemValue
			Set ItemValue1=+ItemValue1
		}
		If (ItemDataTypeDesc["省市县乡") {
			Set objArea=##class(DHCMed.EPD.AreaDic).GetObjById(ItemValue)
			If $IsObject(objArea) {
				Set ItemValue1=objArea.ShortDesc
			}
		}
		Set ItemIsNecess=$s(ItemIsNecess["Y":"是",1:"")
		
		//值ID、项目名称、值（显示）、项目数据类型代码、项目字典代码、项目ID、值（隐藏）、项目数据类型描述
		Set Data=$lb(ItemValRowID,ItemName,ItemCode,ItemValue1,ItemDataTypeCode,ItemDicName,ItemRowID,ItemValue,ItemDataTypeDesc,ItemIsNecess)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryEpidemicSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpidemicSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEpidemicSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEpidemicSubExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	// if there are no more rows, finish fetching
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	// fetch row
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ChangeExp(aExp As %String, aEpisodeID As %String) As %String
{
	New (aExp,aEpisodeID)
	Set return=""
	Set $ZT="ChangeExpErr"
	
	Set EpisodeID=+$g(aEpisodeID)
	Set Patient=$p($g(^PAADM(+EpisodeID)),"^",1)
	
	Set:aExp="" aExp=""""""
	Set Exp="Set return="_aExp
	X Exp
	
	Quit return
ChangeExpErr
	Quit ""
}

/// Creator：     pylian
/// CreatDate：   2018-09-11
/// Description:  查询传染病诊断附卡信息
/// Table：       DHCMed.EPD.Epidemic、DHCMed.EPD.AppendixCard
/// Input：       aReportID: 传染病报告的ID
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.EpidemicSubSrv","QryEpidemicSubInfo","104")
Query QryEpidemicSubInfo(aReportID As %String) As %Query(ROWSPEC = "RowID:%String,ItemCaption:%String:项目,ItemCode:%String,ItemValue:%String:值,ItemType:%String,ItemDic:%String,AppendixItemID:%String,HiddenValue:%String,NoticeText:%String:提示,IsNecess:%String:是否必填")
{
}

ClassMethod QryEpidemicSubInfoExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aReportID="" $$$OK 
	Set AppendixID=""
	Set objReport=##class(DHCMed.EPD.Epidemic).GetObjById(aReportID)
	If $IsObject(objReport){
		If $IsObject(objReport.MEPDICDDR) {
			Set AppendixID=objReport.MEPDICDDR.MIFAppendix
		}
	}
	Quit:AppendixID="" $$$OK
	
	Set ItemValID=0
	For {
		Set ItemValID=$o(^DHCMed.EPD("EPD",aReportID,"I",ItemValID))
		Quit:ItemValID=""
		
		Set objItemVal=##Class(DHCMed.EPD.EpidemicSub).GetObjById(aReportID_"||"_ItemValID)
		Continue:'$IsObject(objItemVal)
		Set ItemValRowID = objItemVal.%Id()
		Set ItemValue = objItemVal.MEPDSValue               //真实值（存储值）
		Set AppendixItemID = objItemVal.MEPDSAppendixItemID //附卡项目ID
		Set AppendixItem = objItemVal.MEPDSAppendixItem		//附卡项目code
		Continue:AppendixItem=""
		Set xItemID=""
		For {
			Set xItemID=$o(^DHCMed.EPDCi("ACSUB","IndexCode",AppendixID,AppendixItem,xItemID))
			Quit:xItemID=""
			Set objItem=##Class(DHCMed.EPD.AppendixCardSub).GetObjById(xItemID)
			Continue:'$IsObject(objItem)
		
			Set IsActive=objItem.MACIActive
			Set ItemValue1=""                                  //显示值（转换值）                          
			Set ItemRowID=objItem.%Id()                        //项目ID
			Set ItemName=objItem.MACIName                      //项目名称
			Set ItemCode=objItem.MACICode                      //项目代码
			Set ItemDicName=objItem.MACIDicName                //项目字典代码
			Set ItemDataTypeCode=objItem.MACIDataType          //项目数据类型代码
			Set objDataTypeDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICAPPENDIXDATATYPE",ItemDataTypeCode,"")
			Set ItemDataTypeDesc=objDataTypeDic.Description    //项目数据类型描述
			Set ItemValExp=objItem.MACIValExp                  //默认值表达式
			Set ItemIsNecess=objItem.MACIIsNecess              //是否必填项
	      	
			//显示值（转换值）
			Set ItemValue1=ItemValue
			If (objItem.MACIDataType=4)&&(ItemValue1'="") {
				Set objItemValue=##class(DHCMed.SS.Dictionary).GetByTypeCode($ZCVT(ItemDicName,"U"),ItemValue1,"")
				If $IsObject(objItemValue) {
					Set ItemValue1=objItemValue.Description
				}
			}
			If (ItemDataTypeDesc["是否") {
				Set ItemValue=$s(ItemValue["Y":"Y",1:"N")
				Set ItemValue1=$s(ItemValue1["Y":"是",1:"否")
			}
			If (ItemDataTypeDesc["数字") {
				Set ItemValue=+ItemValue
				Set ItemValue1=ItemValue1
			}
			If (objItem.MACIDataType=3) {
				Set:ItemValue'="" ItemValue=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ItemValue)
				Set ItemValue1=ItemValue
			}
			If (objItem.MACIDataType=7)&&(ItemValue1'="") { //单选列表
				Set objItemValue=##class(DHCMed.SS.Dictionary).GetByTypeCode($ZCVT(ItemDicName,"U"),ItemValue1,"")
				If $IsObject(objItemValue) {
					Set ItemValue1=objItemValue.Description
				}
			}
			If (objItem.MACIDataType=8)&&(ItemValue1'="") { //多选列表
				Set ItemValue1s="",ItemValue1=""
			    For indx=1:1:$l(ItemValue,","){
					Set Code = $p(ItemValue,",",indx)
					Set objItemValue=##class(DHCMed.SS.Dictionary).GetByTypeCode($ZCVT(ItemDicName,"U"),Code,"")
					If $IsObject(objItemValue) {
						Set ItemValue1=objItemValue.Description
					}
					Set ItemValue1s=ItemValue1s_","_ItemValue1
			    }
			    
			    Set:ItemValue1s'="" ItemValue1s=$e(ItemValue1s,2,$l(ItemValue1s))
			    Set ItemValue1 = ItemValue1s 
			}
			If (objItem.MACIDataType=10) {				//省市县乡
				Set objArea=##class(DHCMed.EPD.AreaDic).GetObjById(ItemValue)
				If $IsObject(objArea) {
					Set ItemValue1=objArea.ShortDesc
				}
			}
			Set ItemIsNecess=$s(ItemIsNecess["Y":"是",1:"")
			
			//值ID、项目名称、值（显示）、项目数据类型代码、项目字典代码、项目ID、值（隐藏）、项目数据类型描述
			Set Data=$lb(ItemValRowID,ItemName,AppendixItem,ItemValue1,ItemDataTypeCode,ItemDicName,ItemRowID,ItemValue,ItemDataTypeDesc,ItemIsNecess)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryEpidemicSubInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpidemicSubInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEpidemicSubInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEpidemicSubInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	// if there are no more rows, finish fetching
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	// fetch row
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}

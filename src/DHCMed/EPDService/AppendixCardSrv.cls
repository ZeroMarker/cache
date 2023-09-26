/// 创建者：李阳
/// 传染病附卡管理
/// 创建日期：2011-06-30
/// 
Class DHCMed.EPDService.AppendixCardSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 查询传染病附卡列表
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.AppendixCardSrv","QryAppendixCard")
Query QryAppendixCard() As %Query(ROWSPEC = "ID:%String,Code:%String:代码,Description:%String:描述,IsActive:%String:生效,Type:%String:类别,FromDate:%String:生效日期,ResumeText:%String:备注")
{
}

ClassMethod QryAppendixCardExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.EPDC("AC",RowID))
		Quit:RowID=""
		Set obj=##class(DHCMed.EPD.AppendixCard).GetObjById(RowID)
		Continue:$IsObject(obj)=0
		Do obj.%Close()
		Set data=$lb("")
		Set $li(data,1)=obj.%Id()
		Set $li(data,2)=obj.MACCode //代码
		Set $li(data,3)=obj.MACDesc //描述
		Set $li(data,4)=obj.MACActive //生效
		Set $li(data,4) = $s($li(data,4)="Y":"是",1:"否")
		Set $li(data,5)=obj.MACType //类别
		//Set $li(data,6)=$s(+obj.MACDate=0:"",1:$zd(obj.MACDate,3)) //生效日期
		Set $li(data,6)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(obj.MACDate) //生效日期
		Set $li(data,7)=obj.MACDemo //备注
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
		Set obj=""
		Kill obj
	}
	
		
	Quit $$$OK
}

ClassMethod QryAppendixCardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAppendixCardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAppendixCardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAppendixCardExecute ]
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

/// 查询传染病附卡项目
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.AppendixCardSrv","QryAppendixCartItem",1,"Y")
Query QryAppendixCartItem(AppendixCardID As %String, IsActive As %String) As %Query(ROWSPEC = "ID:%String,Name:%String:名称,ItemCode:%String,ItemActive:%String:生效,DataType:%String:数据类型,DicName:%String:辅助字典名称,HiddenValueDataType:%String,HiddenValueDicName:%String,ValExp:%String,IsNecess:%String")
{
}

ClassMethod QryAppendixCartItemExecute(ByRef qHandle As %Binary, AppendixCardID As %String, IsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:AppendixCardID="" $$$OK
	
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.EPDCi("ACSUB","IndexParef",AppendixCardID,RowID))
		Quit:RowID=""
		Set obj=##class(DHCMed.EPD.AppendixCardSub).GetObjById(RowID)
		Continue:'$IsObject(obj)
		Set ItemID=obj.%Id()
		Set ItemName=obj.MACIName
		Set ItemActive=obj.MACIActive
		Continue:(IsActive'="")&&(ItemActive'=IsActive)
		Set ItemDateType=obj.MACIDataType
		Set ItemDateTypeDesc=""
		If ItemDateType'="" {
			Set objDataType=##Class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICAPPENDIXDATATYPE",ItemDateType,"")
			If $IsObject(objDataType){
				Set ItemDateTypeDesc=objDataType.Description
			}
		}
		Set ItemDicName=obj.MACIDicName
		Set ItemDicNameDesc=""
		If ItemDicName'="" {
			Set objDicName=##class(DHCMed.SS.Dictionary).GetByTypeCode("SYS",ItemDicName,"")
			If $IsObject(objDicName){
				Set ItemDicNameDesc=objDicName.Description
			}
		}
		Set ItemValExp=obj.MACIValExp
		Set IsNecess=obj.MACIIsNecess
		//Set ItemIsNecess = $s(ItemIsNecess="Y":"是",1:"否")
		Set ItemCode=obj.MACICode
		
		Set Data=$lb(ItemID,ItemName,ItemCode,ItemActive,ItemDateTypeDesc,ItemDicNameDesc,ItemDateType,ItemDicName,ItemValExp,IsNecess)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryAppendixCartItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAppendixCartItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAppendixCartItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAppendixCartItemExecute ]
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

/// Creator：     pylian
/// CreatDate：   2018-08-29
/// Description:  获取传染病诊断对应附卡类型
/// Table：       DHCMed.EPD.Epidemic、DHCMed.EPD.AppendixCard
/// Input：       aDiseaseID:传染诊断ID
/// w ##class(DHCMed.EPDService.AppendixCardSrv).GetAppendixCard(25)
ClassMethod GetAppendixCard(aDiseaseID As %String) As %String
{
	New (aDiseaseID)
	Set return=""
	Quit:(aDiseaseID="") return
	
	Set objInf=##Class(DHCMed.EPD.Infection).GetObjById(aDiseaseID)
	Quit:'$IsObject(objInf) return
	Quit:objInf.MIFIsActive'="Y" return	
	Set IFAppendix=objInf.MIFAppendix

	Set objCard=##class(DHCMed.EPD.AppendixCard).GetObjById(IFAppendix)
	Quit:'$IsObject(objCard) return
	Quit:objCard.MACActive'="Y" return
	Set MACCode =objCard.MACCode //代码
		
	Set return =MACCode 		
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-09-06
/// Description:  获取传染病诊断对应附卡项目
/// Table：       DHCMed.EPD.Epidemic、DHCMed.EPD.AppendixCard
/// Input：       aDiseaseID:传染诊断ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.AppendixCardSrv","QryAppendixCardItem",1,"Y")
Query QryAppendixCardItem(aDiseaseID As %String, IsActive As %String) As %Query(ROWSPEC = "ID:%String,Name:%String:名称,ItemCode:%String,IsActive:%String:生效,DataType:%String:数据类型,DicName:%String:辅助字典名称,HiddenValueDataType:%String,HiddenValueDicName:%String,ValExp:%String,IsNecess:%String")
{
}

ClassMethod QryAppendixCardItemExecute(ByRef qHandle As %Binary, aDiseaseID As %String, IsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aDiseaseID="" $$$OK
		
	Set objInf=##Class(DHCMed.EPD.Infection).GetObjById(aDiseaseID)
	Quit:'$IsObject(objInf) $$$OK
	Quit:objInf.MIFIsActive'="Y" $$$OK	
	Set IFAppendix=objInf.MIFAppendix

	Set objCard=##class(DHCMed.EPD.AppendixCard).GetObjById(IFAppendix)
	Quit:'$IsObject(objCard) $$$OK
	
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.EPDCi("ACSUB","IndexParef",IFAppendix,RowID))
		Quit:RowID=""
		Set obj=##class(DHCMed.EPD.AppendixCardSub).GetObjById(RowID)
		Continue:'$IsObject(obj)
		Set ItemID=obj.%Id()
		Set ItemName=obj.MACIName
		Set ItemActive=obj.MACIActive
		Continue:(IsActive'="")&&(ItemActive'=IsActive)
		Set ItemDateType=obj.MACIDataType
		Set ItemDateTypeDesc=""
		If ItemDateType'="" {
			Set objDataType=##Class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICAPPENDIXDATATYPE",ItemDateType,"")
			If $IsObject(objDataType){
				Set ItemDateTypeDesc=objDataType.Description
			}
		}
		Set ItemDicName=obj.MACIDicName
		Set ItemDicNameDesc=""
		If ItemDicName'="" {
			Set objDicName=##class(DHCMed.SS.Dictionary).GetByTypeCode("SYS",ItemDicName,"")
			If $IsObject(objDicName){
				Set ItemDicNameDesc=objDicName.Description
			}
		}
		Set ItemValExp=obj.MACIValExp
		Set ItemIsNecess=obj.MACIIsNecess
		Set ItemCode=obj.MACICode
		
		Set Data=$lb(ItemID,ItemName,ItemCode,ItemActive,ItemDateTypeDesc,ItemDicNameDesc,ItemDateType,ItemDicName,ItemValExp,ItemIsNecess)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryAppendixCardItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAppendixCardItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAppendixCardItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAppendixCardItemExecute ]
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

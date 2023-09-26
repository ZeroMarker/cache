/// 病案收费项定义
Class DHCWMR.MF.FeeItem Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildFIS As DHCWMR.MF.FeeItemSub [ Cardinality = children, Inverse = Parref ];

/// 项目代码
Property FICode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目名称
Property FIDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目代码索引
Index IndexCode On FICode;

/// Creator:          李毅
/// CreateDate:       2015-07-21
/// Description:      根据ID取收费项
/// OperationTable:   DHCWMR.MF.FeeItem
/// Input:            Id : DHCWMR.MF.FeeItem.ID
/// Output:           返回Object
/// w ##Class(DHCWMR.MF.FeeItem).GetObjById(21)
ClassMethod GetObjById(aId As %String) As DHCWMR.MF.FeeItem
{
	new (aId)
	quit:'##class(DHCWMR.MF.FeeItem).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MF.FeeItem).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator:          李毅
/// CreateDate:       2015-07-21
/// Description:      根据Code取收费项
/// OperationTable:   DHCWMR.MF.FeeItem
/// Input:            Id : DHCWMR.MF.FeeItem.ID
/// Output:           返回Object
/// w ##Class(DHCWMR.MF.FeeItem).GetObjByCode(21)
ClassMethod GetObjByCode(aCode As %String) As DHCWMR.MF.FeeItem
{
	New (aCode)
	Set xID = $o(^DHCWMR.MF.FeeItemI("IndexCode"," "_$ZCVT(aCode,"U"),""))
	Set obj = ..GetObjById(xID)
	Quit obj
}

/// Creator:      zhufei
/// CreateDate:   2015-08-19
/// Description:  通过病案收费项+病案类型ID+医院ID取收费项
/// Table：       DHCWMR.MF.FeeItemSub,DHC_TarItem
/// Input：       aMFItemID : 病案收费项
///               aMrTypeID : 病案类型ID
///               aHospID : 医院ID
/// Return：      取有效收费项
/// Debug:		  w ##class(DHCWMR.MF.FeeItem).GetMFPrice("2","6","2")
ClassMethod GetMFPrice(aMFItemID As %String, aMrTypeID As %String, aHospID As %String) As %String
{
	new (aMFItemID,aMrTypeID,aHospID)
	Set return = ""
	Quit:(aMFItemID="")||(aMrTypeID="") return
	
	Set:aMrTypeID'="" aMrTypeID="#"_aMrTypeID_"#"
	Set:aHospID'="" aHospID="#"_aHospID_"#"
	
	Set TarItemList=""
	Set xSubID=""
	For {
		Set xSubID=$o(^DHCWMR.MF.FeeItemD(aMFItemID,"FIS",xSubID))
		Quit:xSubID=""
		
		Set objMFSub = ##class(DHCWMR.MF.FeeItemSub).GetObjById(aMFItemID_"||"_xSubID)
		Continue:'$IsObject(objMFSub)
		
		Set TarItemDr = objMFSub.FISTarItemDr
		Continue:TarItemDr=""
		Set MrTpIDs = objMFSub.FISMrTpIDs
		Set HospIDs = objMFSub.FISHospIDs
		Set SttDate = objMFSub.FISSttDate
		Set EndDate = objMFSub.FISEndDate
		
		Set:MrTpIDs'="" MrTpIDs="#"_MrTpIDs_"#"
		Set:HospIDs'="" HospIDs="#"_HospIDs_"#"
		Continue:(aMrTypeID'="")&(MrTpIDs'[aMrTypeID)
		Continue:(aHospID'="")&(HospIDs'="")&(HospIDs'[aHospID)
		Continue:(SttDate'="")&(SttDate>+$h)
		Continue:(EndDate'="")&(EndDate<+$h)
		
		Continue:$listfind(TarItemList,TarItemDr)>0
		Set TarItemList=TarItemList_$lb(TarItemDr)
		
		Set TarItemCode=$p($g(^DHCTARI(TarItemDr)),"^",1)
		Set TarItemDesc=$p($g(^DHCTARI(TarItemDr)),"^",2)
		Set Price=##class(DHCWMR.IO.FromFeeSrv).GetItmPrice(TarItemDr,"",aHospID)
		Set TarItemPrice=$p(Price,"^",4)
		Set return=return_"$"_TarItemDr_"^"_TarItemCode_"^"_TarItemDesc_"^"_TarItemPrice
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator:      李毅
/// CreateDate:   2015-07-21
/// Description:  更新收费项
/// Table：       DHCWMR.MF.FeeItem
/// Input：       InputStr : %Id^FICode^FIDesc
///               Separate ：分隔符
/// Return：      返回新纪录的%Id()值
/// w ##class(DHCWMR.MF.FeeItem).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set Code=$p(aInputStr,aSeparate,2)
	Set Desc=$p(aInputStr,aSeparate,3)	
	Quit:((Code="")||(Desc="")) return
	
	Set tID=$o(^DHCWMR.MF.FeeItemI("IndexCode"," "_$zcvt(Code,"U"),0))
	If ID="" {
		Set ID=tID
	} Else {
		Quit:ID'=tID -100
	}
	
	If ID="" {
		Set obj=##class(DHCWMR.MF.FeeItem).%New()
	} Else {
		Set obj=##class(DHCWMR.MF.FeeItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.FICode    = Code
	Set obj.FIDesc    = Desc
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator:      李毅
/// CreateDate:   2015-07-21
/// Description:  删除病案收费项
/// Table：       DHCWMR.MF.FeeItem
/// Input：       Id : DHCWMR.MF.FeeItem.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MF.FeeItem).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator:      李毅
/// CreateDate:   2015-08-19
/// Description:  通过病案收费项代码、病案类型ID 获取HIS收费项价格
/// Table：       DHCWMR.MF.FeeItem,DHCWMR.MF.FeeItemSub,DHC_TarItem
/// Input：       Id : aCode,aMrTypeID
/// Return：      有效收费项价格
/// Debug:		  w ##class(DHCWMR.MF.FeeItem).GetTariPrice("JD",7,"")
ClassMethod GetTariPrice(aCode As %String, aMrTypeID As %String, aHospID As %String = "") As %String
{
	new (aCode,aMrTypeID,aHospID)
	Set return = ""
	Quit:(aCode="")||(aMrTypeID="") return
	
	Set objFeeItem=##Class(DHCWMR.MF.FeeItem).GetObjByCode(aCode)
	Quit:'$IsObject(objFeeItem) return
	Set FeeItemCode=objFeeItem.FICode
	Set FeeItemID=objFeeItem.%Id()
	
	If FeeItemCode="FY" {
		Set MFFeeType=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MFFeeTypeByCopy",aHospID)
		Set MFFeeType=+MFFeeType
	} ElseIf FeeItemCode="JD" {
		Set MFFeeType=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MFFeeTypeByReceipt",aHospID)
		Set MFFeeType=+MFFeeType
	}
	
	If MFFeeType=1 {
		If (FeeItemCode="FY"){
			Set MFPrice=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MrCopyPrice",aHospID)
			Set return=+MFPrice
		}
		If (FeeItemCode="JD"){
			Set MFPrice=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MrReceiptPrice",aHospID)
			Set return=+MFPrice
		}
	} ElseIf MFFeeType=2 {
		Set MFPriceList=##class(DHCWMR.MF.FeeItem).GetMFPrice(FeeItemID,aMrTypeID,aHospID)
		Set return=+$p(MFPriceList,"^",4)
	}
	
	Set return=$fn(return,"",2)
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FICode</Value>
</Value>
<Value name="3">
<Value>FIDesc</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MF.FeeItemD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MF.FeeItemD</IdLocation>
<IndexLocation>^DHCWMR.MF.FeeItemI</IndexLocation>
<StreamLocation>^DHCWMR.MF.FeeItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

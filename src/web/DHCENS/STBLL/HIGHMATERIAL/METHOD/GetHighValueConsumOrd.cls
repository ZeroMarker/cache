Class web.DHCENS.STBLL.HIGHMATERIAL.METHOD.GetHighValueConsumOrd Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lipan
/// CreatDate：2016—07-26
/// Description：获取高值耗材医嘱信息
/// Table：
/// Input：医嘱号^医嘱号^医嘱号
/// Return：医嘱信息集合
/// Others: 
/// w ##class(web.DHCENS.STBLL.HIGHMATERIAL.METHOD.GetHighValueConsumOrd).HighValueOEOrder("1629||17")
ClassMethod HighValueOEOrder(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	s request=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Request).%New()
	s header=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	set highValueConsumOrdS=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.highValueConsumOrd).%New()
	
	set Oerowid=$p(Input,"^",1)
	set admRowid=$p($g(^OEORD(+Oerowid)),"^",1)
	set patId=$p(^PAADM(admRowid),"^",1)
	set highValueConsumOrdS.PATPatientID=$p($g(^PAPER(patId,"PAT",1)),"^",1)
	set highValueConsumOrdS.PAADMVisitNumber=admRowid
	set highValueConsumOrdS.PATName=$p($g(^PAPER(patId,"ALL")),"^",1)
	set highValueConsumOrdS.PATType=$p($g(^PAADM(admRowid)),"^",2)
	set admDeptRowid=$p($g(^PAADM(admRowid)),"^",4)
	if admDeptRowid'=""{
		set highValueConsumOrdS.PATDeptCode=$p($g(^CTLOC(admRowid)),"^",1)
		set highValueConsumOrdS.PATDeptDesc=$p($g(^CTLOC(admRowid)),"^",2)
	}
	
	set TRANSChildsub="",AdmDeptRowID="",TmpDeptRowID="",Bed=""
	set AdmWardCode="",AdmWardRowID="",AdmWardDesc=""
	f  s TRANSChildsub=$o(^PAADM(admRowid,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(Bed'="")  d
	.s Bed=$p($g(^PAADM(admRowid,"TRANS",TRANSChildsub)),"^",8)
	.s TmpDeptRowID=$p($g(^PAADM(admRowid,"TRANS",TRANSChildsub)),"^",6)
	.s AdmWardRowID=$p($g(^PAADM(admRowid,"TRANS",TRANSChildsub)),"^",9)
	.if TmpDeptRowID'=""  d
	..s AdmDeptRowID=TmpDeptRowID
	if AdmDeptRowID'=""  {		
		set highValueConsumOrdS.PATDeptCode=$p($g(^CTLOC(admRowid)),"^",1)
		set highValueConsumOrdS.PATDeptDesc=$p($g(^CTLOC(admRowid)),"^",2)
	}
	if AdmWardRowID'="" 
	{
		set AdmWardCode=$p($g(^PAWARD(admRowid)),"^",1)
		set highValueConsumOrdS.PATWardCode=AdmWardCode
	}
	s CurrentBedRowID=$P($g(^PAADM(admRowid)),"^",73)
	i ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1) {
		s BedWordRowID = $p(CurrentBedRowID,"||",1)
		s BedChildSub = $p(CurrentBedRowID,"||",2)
		i $d(^PAWARD(BedWordRowID,"BED"))=10 {
			s highValueConsumOrdS.PATBed=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
		}
	}
	s CurrentRoomRowID=$P($g(^PAADM(admRowid)),"^",69)
	s:CurrentRoomRowID'="" highValueConsumOrdS.PATRoom=$p($g(^PAROOM(CurrentRoomRowID)),"^",1)
	s length=$l(Input,"^")
	for i=1:1:length {
		set rowId=$p(Input,"^",i)
		set OEORIInfos=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.OEORIInfo).%New()
		set OEORIInfos=..OEOrdItem(rowId)
		d highValueConsumOrdS.OEORIInfos.Insert(OEORIInfos)
	}
	
	set body=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Body).%New()
	d body.highValueConsumOrdS.Insert(highValueConsumOrdS)
	set request.body=body
	d request.XMLExportToStream(.stream)
	b ;1
	q stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	b ;2
	Quit stream
}

ClassMethod OEOrdItem(Input As %String) As web.DHCENS.STBLL.HIGHMATERIAL.MODEL.OEORIInfo
{
	s obj=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.OEORIInfo).%New()
	s orderObj=##class(web.DHCENS.STBLL.ORDER.MODEL.OEOrdItem).%New()
	s orderObj=##class(web.DHCENS.STBLL.ORDER.METHOD.OEOrder).OEOrdItem(Input)
	s obj.BarCode=""
	s obj.OEORIOrderItemID=orderObj.OEORIOrderItemID
	s obj.OEORIOEORIDR=orderObj.OEORIOEORIDR
	s obj.OEORIARCItmMastCode=orderObj.OEORIARCItmMastCode
	s obj.OEORIARCItmMastDesc=orderObj.OEORIARCItmMastDesc
	s obj.Price=..GetPrice(Input)
	s obj.Amount=orderObj.OEORIOrderQty
	s obj.VerifyDate=orderObj.OEORIEnterDate
	s obj.VerifyTime=orderObj.OEORIEnterTime
	s obj.AppDeptCode=orderObj.OEORIEnterDeptCode
	s obj.AppDeptDesc=orderObj.OEORIEnterDeptDesc
	s obj.RecDeptCode=orderObj.OEORIExecDeptCode
	s obj.RecDeptDesc=orderObj.OEORIExecDeptDesc
	s obj.DocCode=orderObj.OEORIEnterDocCode
	s obj.DocDesc=orderObj.OEORIEnterDocDesc
	s obj.Remarks=""
	
	set ord = $P(Input,"||",1)
	set sub = $P(Input,"||",2)
	set ordstr3 = $g(^OEORD(ord,"I",sub,3))
	set ordstr1 = $g(^OEORD(ord,"I",sub,1))
	set arcimId = $P(ordstr1,"^",2)
    set arcSub = $P(arcimId,"||",1)
    set arcVer = $P(arcimId,"||",2)
    set obj.BillCode = $P(ordstr3,"^",5)   
 	set obj.BillCode=$Case(obj.BillCode,"P":"已收费",:"未收费")
 	
	q obj
}

/// 获取医嘱价格
/// w ##class(web.DHCENS.STBLL.HIGHMATERIAL.METHOD.GetHighValueConsumOrd).GetPrice("1629||28")
ClassMethod GetPrice(rowid As %String) As %String
{
	set $zt="Exception"
    set EpissubtypeDR=""
    set tempRowid=##class(web.DHCENS.STBLL.UTIL.Common).ReplaceStr(rowid,"_","||")
    set tmpAdm=$p($g(^OEORD(+tempRowid)),"^",1)
    set EpissubtypeDR=$P($g(^PAADM(tmpAdm,1)),"^",6)
       
    // 取子医嘱中医嘱价格，当医嘱类型的子类是Price时，取医嘱表中OEORI_Price中价格，
    // 然后调用计费组方法set tmpchild=##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",childarcimId,$P(childordstr3,"^",7),"","","",$p(childordstr3,"^",25))
    set childIndex="",childOrdPrice=0
    set ord=+rowid
    set arcimId = $P($g(^OEORD(ord,"I",$p(rowid,"||",2),1)),"^",2)
    set arcSub = $P(arcimId,"||",1)
    set arcVer = $P(arcimId,"||",2)
    
    
    f  s childIndex=$o(^OEORDi(0,"OEORI",ord,tempRowid,childIndex))  q:childIndex=""  d
	.set childordstr1 = $g(^OEORD(ord,"I",childIndex,1))
	.set childordstr3 = $g(^OEORD(ord,"I",childIndex,3))
	.set childarcimId = $P(childordstr1,"^",2)
	.set ItmMastFirst=$p(childarcimId,"||",1)
	.set ItmMastLast=$p(childarcimId,"||",2)
	.set ItemCatRowID=$p($g(^ARCIM(ItmMastFirst,ItmMastLast,1)),"^",10)
	
    
	.set ItmCatType=$p($g(^ARC("IC",ItemCatRowID)),"^",7)
	.set tmpchild=0
	.i ItmCatType="P" d
	..set tmpchild=##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",childarcimId,$P(childordstr3,"^",7),"","","",$p(childordstr3,"^",25))
	.set childOrdPrice=+childOrdPrice++($P(tmpchild,"^",1))
	
	set OrdSubCatRowID=$p($g(^ARCIM(arcSub,arcVer,1)),"^",10)
    //取父医嘱价格信息，方式同取子医嘱类方法相同
	set CatType=$p($g(^ARC("IC",OrdSubCatRowID)),"^",7)
	set tmpPrice=""
	set VerifyDate=$P($g(^OEORD(ord,"I",$p(rowid,"||",2),3)),"^",7)
	if (CatType="P") {
		s tmpPrice=$p(ordstr3,"^",25)
    	set price = ##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",arcimId,VerifyDate,"","","",+tmpPrice)
	}
	else {
    	set price = ##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",arcimId,VerifyDate,"","","","")
	}
    set TotalPrice=childOrdPrice+price
    Quit TotalPrice
Exception
	Quit "价格异常"
}

}

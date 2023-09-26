Class web.DHCENS.STBLL.PIVAS.METHOD.DispensStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/*set stream=##class(%GlobalCharacterStream).%New()
d stream.Write("<Request><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><OEORIInfoList><OEORIInfo><OrderExecuteID>18||1||1</OrderExecuteID><BedInfo></BedInfo>1203040301^001</OEORIInfo></OEORIInfoList></Body></Request>")
w ##class(web.DHCENS.STBLL.PIVAS.METHOD.DispensStatus).GetDispensStatus(stream)
*/
/// Creator：DongWenLong
/// CreatDate：2019—03-18
/// Description:配液状态查询信息
/// Table：
/// Input：医嘱执行记录id
ClassMethod GetDispensStatus(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set response=##class(web.DHCENS.STBLL.PIVAS.MODEL.Response).%New()
	set OEORIInfoList=##class(web.DHCENS.STBLL.PIVAS.MODEL.OEORIInfoList).%New()
	set stream=##class(%GlobalCharacterStream).%New()
	d inputContent.Rewind()
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	if $$$ISERR(tSC) {
		set header=##class(web.DHCENS.STBLL.PIVAS.MODEL.Header).%New()
		set header.MessageID=""
		set header.SourceSystem="01"
		set body=##class(web.DHCENS.STBLL.PIVAS.MODEL.ResBody).%New()
		set body.ResultCode="-1"
		set body.ResultContent=tSC
		set response.header=header
		set response.body=body
		set (header,body)=""
		do response.XMLExportToStream(.stream)
		Quit stream
	}else{
		set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIInfoList","count(OEORIInfo)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			if (hsCount="0"){
				d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>医嘱执行信息为空</ResultContent></Body></Response>")
			}
			Quit:hsCount="0" stream
			
			for i=1:1:hsCount {
				set (OrderExecuteID,BedInfo)=""	
				set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIInfoList/OEORIInfo["_i_"]/OrderExecuteID","text()",.tRes)				
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OrderExecuteID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIInfoList/OEORIInfo["_i_"]/BedInfo","text()",.tRes)				
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set BedInfo=$tr(fieldValue,$c(0),"")
				}
				set Flag=..IsPYFlag(OrderExecuteID)
				set BedFlag=..CurentbedInfo(OrderExecuteID,BedInfo)
				set OEORIInfo=##class(web.DHCENS.STBLL.PIVAS.MODEL.OEORIInfo).%New()
				set OEORIInfo.OrderExecuteID=OrderExecuteID
				set OEORIInfo.Flag=Flag
				set OEORIInfo.BedFlag=BedFlag
				d OEORIInfoList.OEORIInfos.Insert(OEORIInfo)
			}
				set header=##class(web.DHCENS.STBLL.PIVAS.MODEL.Header).%New()
				set header.MessageID=""
				set header.SourceSystem="01"
				set body=##class(web.DHCENS.STBLL.PIVAS.MODEL.ResBody).%New()
				set body.ResultCode="0"
				set body.ResultContent="成功"
				set response.header=header	
				set body.OEORIInfoList=OEORIInfoList
				set response.body=body
				set (header,body)=""
			}
			else{
				set header=##class(web.DHCENS.STBLL.PIVAS.MODEL.Header).%New()
				set header.MessageID=""
				set header.SourceSystem="01"
				set body=##class(web.DHCENS.STBLL.PIVAS.MODEL.ResBody).%New()
				set body.ResultCode="0"
				set body.ResultContent="成功"
				set response.header=header
				set response.body=body
				set (header,body)=""
			}
	}
	do response.XMLExportToStream(.stream)
	Quit stream
Exception
	set response=##class(web.DHCENS.STBLL.PIVAS.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.PIVAS.MODEL.Header).%New()
	set header.MessageID=""
	set header.SourceSystem="HIS"
	set body=##class(web.DHCENS.STBLL.PIVAS.MODEL.ResBody).%New()
	set body.ResultCode="-1"
	set body.ResultContent=$ze
	set response.header=header
	set response.body=body
	set (header,body)=""
	do response.XMLExportToStream(.stream)
	Quit stream
}

// w ##class(web.DHCENS.STBLL.PIVAS.Method.PIVASInterface).CurentbedInfo("14344139||77||1","10112^01")

ClassMethod CurentbedInfo(OrderExecuteID As %String, BedInfo As %String) As %String
{
	q:(OrderExecuteID="")||(BedInfo="") ""
	set argWardCode=$p(BedInfo,"^",1)
	set argBedCode=$p(BedInfo,"^",2)
	set BedFlag="",curWardCode="",curBedCode=""
	set ord= $P(OrderExecuteID,"||",1)
	set AdmNo=$P(^OEORD(ord),"^",1)
	set curWardId=$P(^PAADM(AdmNo),"^",70)
	set curBedId=$P(^PAADM(AdmNo),"^",73)
	set:curWardId'="" curWardCode=$p(^PAWARD(curWardId),"^",1)
	set:curBedId'="" curBedCode=$p(^PAWARD(+curBedId,"BED",$p(curBedId,"||",2)),"^",1)
	if (curWardCode'=argWardCode)||(curBedCode'=argBedCode) d
	.set BedFlag=curWardCode_"^"_curBedCode
	q BedFlag
}

ClassMethod IsPYFlag(OrdExes As %String) As %String
{
	q:OrdExes="" ""
	set Flag="N"
	set ord= $P(OrdExes,"||",1)
	set sub = $P(OrdExes,"||",2)
	set oreid= $P(OrdExes,"||",3)
	q:'$d(^OEORD(ord,"I",sub,"X",oreid)) "N"
	set exestdate=$P(^OEORD(ord,"I",sub,"X",oreid),"^",1)
	set exesttime=$P(^OEORD(ord,"I",sub,"X",oreid),"^",2)
	set ordstatus=$P(^OEORD(ord,"I",sub,1),"^",13)
	set xdate=$P(^OEORD(ord,"I",sub,3),"^",34)
	set xtime=$P(^OEORD(ord,"I",sub,2),"^",15)
	if (ordstatus=1)||(ordstatus=6) set Flag="Y"
	else  d
	.if ordstatus=4 d
	..if exestdate<xdate set Flag="Y"
	..if exestdate=xdate d
	...if exesttime<=xtime set Flag="Y"
	...else  set Flag="N"
	..if exestdate>xdate set Flag="N"
	.else  set Flag="N"
	//对已计费成功的，再查询配液状态，应该仍然为可配
	/*
 i Flag="N" d
 .s orderitem=$p(OrdExes,"||",1,2)
 .s dsp="",finddsp=""
 .f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",orderitem,dsp)) q:dsp=""  d
 ..s dspsttime=$p(^DHCOEDISQTY(dsp),"^",20)
 ..i dspsttime=exesttime s finddsp=dsp
 .i finddsp'="" d
 ..s DspStatus=$p(^DHCOEDISQTY(finddsp),"^",7)
 ..i (DspStatus="C")!(DspStatus="R") s Flag="Y"
 ..
	*/
	q Flag
}

}

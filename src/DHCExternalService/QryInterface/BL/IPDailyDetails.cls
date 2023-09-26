/// Creator:Lid
/// CreatDate:2013-08-30
/// Desc:住院病人日清明细
Class DHCExternalService.QryInterface.BL.IPDailyDetails Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:Lid
/// CreatDate:2013-08-30
/// Desc:查询住院病人的日清明细
/// Input:<Request><CardTypeCode></CardTypeCode><CardNo>000000000011</CardNo><SecrityNo></SecrityNo><StartDate>2013-05-20</StartDate><EndDate>2013-05-20</EndDate></Request>
/// Return:
/// Debug:w ##class(DHCExternalService.QryInterface.BL.IPDailyDetails).GetIPDailyDetails("<Request><CardTypeCode></CardTypeCode><CardNo>000000000011</CardNo><SecrityNo></SecrityNo><StartDate></StartDate><EndDate></EndDate></Request>")
ClassMethod GetIPDailyDetails(input As %String) As %GlobalCharacterStream
{
	Set $zt="GetIPDailyDetailsET"
	
	Set ResultCode="100",ErrorMsg="没有查询到人员信息"
	Set RpObj=##class(DHCExternalService.QryInterface.MSG.FEE.GetIPDailyDetailRp).%New()
	Set RtObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetPatInfoRt).%New()
	Do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	Set CardTypeCode=RtObj.CardTypeCode
	Set CardNo=RtObj.CardNo
	Set SecrityNo=RtObj.SecrityNo
	Set StartDate=RtObj.StartDate
	Set EndDate=RtObj.EndDate
	set PatNo=RtObj.PatientID
	set Adm=RtObj.Adm
	
	Set:StartDate["-" StartDate=$zdh(StartDate,3)
  	Set:StartDate="" StartDate=+$h-1
  	Set:EndDate["-" EndDate=$zdh(EndDate,3)
  	Set:EndDate="" EndDate=+$h-1
  	
	If (CardNo="")&&(PatNo=""){
	    Do Output10("-101","卡号不能为空")
		Quit RpStream
	}
	Set CardTypeID=##class(DHCExternalService.QryInterface.BL.InvFeeInfo).GetHisCardTypeID(CardTypeCode)
	Set myExpStr=""_$c(2)_""_$c(2)_"PatInfo"
	set Papmi=""
	set PatInfo=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetPatCommInfoByCardNo(CardNo,PatNo)
	set Papmi=$p(PatInfo,"^",1)
    if (Papmi="") {
	  	Do Output10("-102","不存在病人主索引")
		Quit RpStream
	}
    Set PatSocialStatusDR=$p(^PAPER(Papmi,"PER",1),"^",10) ;PAPER_SocialStatus_DR -> CT_SocialStatus
    Set PatSocialStatus=$p(^CT("SS",PatSocialStatusDR),"^",2)
	Set PapNo=$p(^PAPER(Papmi,"PAT",1),"^",1)   ;登记号
	Set PatName=$p(^PAPER(Papmi,"ALL"),"^",1)   ;姓名
	Set Sex=$p(^PAPER(Papmi,"ALL"),"^",7)       ;性别
	If Sex'="" Set Sex=$p(^CT("SEX",Sex),"^",2)
	Set PatAge=""
	Set PatientDOB=$P($G(^PAPER(Papmi,"ALL")),"^",6)
	Set PatAge=##class(DHCExternalService.BillInterface.Service.DHCOPBillPayLogic).GetAgeDesc(PatientDOB,+$h)
	Set VisitStatus=""	;病人是否在院标志
	Set admId=0,Index=0
	Set deposit=0,sum=0,patfee=0,patshare=0,deposit=0,discount=0
	For  Set admId=$o(^PAPERdr(Papmi,"ADM","I",admId)) Quit:admId=""  Do  ;取住院病人admId
	.q:(Adm'="")&&(Adm'=admId)  ;如果传入了adm就取当前adm
	.Quit:'$d(^PAADM(admId))
	.Set Admreasomdr=$p(^PAADM(admId,1),"^",7)
	.Set AdmreasomDesc=$p(^PAC("ADMREA",Admreasomdr),"^",2)
	.Set deprowid=$p(^PAADM(admId),"^",4)
	.If deprowid'="" Set locname=$p(^CTLOC(deprowid),"^",2)
	.Set wardid=$p(^PAADM(admId),"^",70)
	.If wardid'="" Set ward=$p($p(^PAWARD(wardid),"^",2),"-",2)  ;取病区
	.Set bedrowid=$p(^PAADM(admId),"^",73)
	.Set bedname=""
	.If bedrowid'=""  Do  
 	..Set wardid=$p(bedrowid,"||",1),bedid=$p(bedrowid,"||",2)
 	..Set bedname=$p(^PAWARD(wardid,"BED",bedid),"^",1)
	.Set VisitStatus=$p($g(^PAADM(admId)),"^",20)
	.Quit:(VisitStatus'="A") ;去掉后可以查出院病人的日清明细。	.;
	.Set RpObj.AdmReason=AdmreasomDesc
	.Set RpObj.Department=locname
	.Set RpObj.Ward=ward
	.Set RpObj.BedNO=bedname
	.Set RpObj.VisitStatus=VisitStatus
	.Set PrtFlag=$g(^DHCAutoIPDailyPrintFlag("PringFlag","PatientID",PapNo,$zd(StartDate,3)))
	.s Printtimes=+$g(^DHCAutoIPDailyPrintFlag("PringFlag","PatientID",PapNo,$zd(StartDate,3),"time"))  ;zhho打印次数
	.s RpObj.PrintTimes=Printtimes  ;zhho打印次数
	.Set:PrtFlag="" PrtFlag="N"
	.Set RpObj.PrintFlag=PrtFlag
	.Set bill=0
	.For  Set bill=$o(^DHCPB(0,"ADM",admId,bill)) q:bill=""  d  
	..Set payedflag=$p(^DHCPB(bill),"^",16)
	..Quit:payedflag="P"
	..Set deposit=##class(web.UDHCJFBaseCommon).deposit(admId)
	..Set patfee1=0,patshare1=0
	..Set feestr=##class(web.UDHCJFDayDetail).Computing(bill,"",EndDate)
	..Set patfee1=+$p(feestr,"^",1)
	..Set patshare1=+$p(feestr,"^",4)
	..Set patfee=patfee+patfee1
	..Set patshare=patshare+patshare1
	..Set expflag="",billtot=0,pvtot=0,expamt=0,billflag1=""
	..Set order=0 
	..For  Set order=$o(^DHCPB(bill,"O",order)) Quit:order=""  Do        ;帐单医嘱
	...Set prtordflag="N"
	...Set oerowid=$p($g(^DHCPB(+bill,"O",order)),"^",4)   ;YYX增加，判断医嘱不存在，则过滤掉
	...Quit:oerowid=""
	...Quit:'$d(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2)))
	...;取收费项目明细
	...Set itm=0 
	...For  Set itm=$o(^DHCPB(+bill,"O",order,"D",itm)) Quit:(itm="")!(prtordflag="Y")  Set s=^(itm) Do   ;收费项目明细
	....Set itmrowid=bill_"||"_order_"||"_itm
	....Set billdate=$p(s,"^",11),billtime=$p(s,"^",12),billstatus=$p(s,"^",14)  ;yyx 06-12-07
	....Quit:(billdate<StartDate)!(billdate>EndDate)
	....Set taritm=$p(s,"^",3)
	....Set tariDesc=$p(^DHCTARI(taritm),"^",2)
  	....Set tariChargeBasis=$p(^DHCTARI(taritm),"^",20)     ;取物价编码
  	....Set tarinpat=$p(^DHCTARI(taritm),"^",14)
	....If tarinpat'=""  Do
	.....Set taric=$p(^DHCTarC("IC",tarinpat),"^",3)  ;收费项目住院分类
	.....Set taricDesc=$p(^DHCTarC("TIC",taric),"^",2)	;住院大类
	....Set arcimid=$p($g(^DHCPB(bill,"O",order)),"^",3)
	....Set itemcat=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),1),"^",10)
	....;
   	....Set billdate=$p(s,"^",11)
   	....Set billtime=$p(s,"^",12)
    ....Set qty=$p(s,"^",5)     ;pbd_billqty
    ....Set price=$j($p(s,"^",4),3,4)   ;pbd_unitprice
    ....Set total=$fn(price*qty,"",2)     ;pbd_totalamount
    ....Quit:+total="0"
    ....Set uomDesc=""
    ....Set tariUom=$p(^DHCTARI(taritm),"^",3)  ;单位
    ....If tariUom'="" Set uomDesc=$p(^CT("UOM",tariUom),"^",2) ;单位            
    ....Set sum=sum+total   ;总计
    ....Set ybzfbl=""	;##class(web.DHCINSUFacade).GetInusTarInfo(taritm)	;;医保分类(甲、乙、丙),调用医保组接口获取
    ....Set getinsustr=##class(web.DHCINSUPort).TarItmLinkInsu(taritm,Admreasomdr,"",admId,price) ;医保自付比例,调用医保组接口获取
    ....Set YBFL=$p(getinsustr,"^",1)
    ....Set Index=Index+1
    ....Set TarItemDetailObj=##class(DHCExternalService.QryInterface.MSG.FEE.TarItemDetail).%New()
    ....Set TarItemDetailObj.Index=Index
    ....Set TarItemDetailObj.Category=taricDesc
    ....Set TarItemDetailObj.ItemName=tariDesc
    ....Set TarItemDetailObj.Qty=qty
    ....Set TarItemDetailObj.UOM=uomDesc
    ....Set TarItemDetailObj.Price=price
    ....Set TarItemDetailObj.TotalAmt=total
    ....Set TarItemDetailObj.DisAmt=0
    ....Set TarItemDetailObj.PayorAmt=0
    ....Set TarItemDetailObj.PatShareAmt=0
    ....Set TarItemDetailObj.BillDate=$zd(billdate,3)
    ....Set TarItemDetailObj.BillTime=$zt(billtime,1)
    ....Set TarItemDetailObj.InsuClass=YBFL	
    ....Set TarItemDetailObj.InsuRatio=ybzfbl 
    ....Set TarItemDetailObj.ItemChargeBasis=tariChargeBasis
    ....Do RpObj.TarItemList.Insert(TarItemDetailObj)
	;
	If (VisitStatus="A") {
		If (+Index>0){
			Set ResultCode="0",ErrorMsg="成功"	
		}else{
			Set ResultCode="-103",ErrorMsg="选择的日期内无费用发生"	
		}
	}
	If (VisitStatus="D") {
		Set ResultCode="-104",ErrorMsg="病人已出院"
	}
	If (VisitStatus="C") {
		Set ResultCode="-105",ErrorMsg="病人已退院"
	}
	If (VisitStatus="") {
		Set ResultCode="-106",ErrorMsg="非住院病人"
	}
	Set RpObj.PatientID=PapNo
	Set RpObj.PatName=PatName
	Set RpObj.PatAge=PatAge
	Set RpObj.PatSex=Sex
	Set RpObj.PatFee=patfee
	Set RpObj.Deposit=deposit
	;
	Do Output10(ResultCode,ErrorMsg)
	
	Kill ^TMPAccPatList("QueryAccList",$j)
	
	Quit RpStream
	
Output10(ResultCode,ErrorMsg)
	Set RpStream=""
	Set RpObj.ResultCode=ResultCode
	Set RpObj.ErrorMsg=ErrorMsg
	Set RtStream=##class(%GlobalCharacterStream).%New()
	Do RpObj.XMLExportToStream(.RpStream,"Response")
	Set OutputXML=""
	Do RpObj.XMLExportToString(.OutputXML,"Response")
	B ;OutputXML
	
	Quit
	
GetIPDailyDetailsET
	Set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	Set streamObj=##class(%GlobalCharacterStream).%New()
	Do streamObj.Write(myrtn)
	Quit streamObj
}

ClassMethod GetAgeDesc(DOB As %String, CalDate As %String) As %String
{
	q:DOB="" ""
	i DOB["/" s DOB=$zdh(DOB,4)
	i DOB["-" s DOB=$zdh(DOB,3)
	i CalDate["/" s CalDate=$zdh(CalDate,4)
	i CalDate["-" s CalDate=$zdh(CalDate,3)
	i CalDate="" s CalDate=+$h
	s Age=$$CalAge^at182(DOB,CalDate,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	s AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
	Q AgeDesc
}

ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	if AgeYear>0 s AgeDesc=AgeYear_"岁"
	else  d
	.if AgeMonth>0 s AgeDesc=AgeMonth_"月"
	.else  s AgeDesc=AgeDay_"天"
	Q AgeDesc
}

/// w ##class(DHCExternalService.QryInterface.BL.IPDailyDetails).SetIPDailyPrintFlag("<Request><TradeCode>90019</TradeCode><PatientID>0000000002</PatientID><EpisodeID></EpisodeID><BillNo></BillNo><QueryDate>2013-12-11</QueryDate><PrintFlag></PrintFlag></Request>")
ClassMethod SetIPDailyPrintFlag(input As %String)
{
	;Set $zt="SetIPDailyPrintFlagET"
	
	Set RpObj=##class(DHCExternalService.QryInterface.MSG.FEE.SetIPDailyPrintFlagRp).%New()
	Set RtObj=##Class(DHCExternalService.QryInterface.MSG.FEE.SetIPDailyPrintFlagRt).%New()
	Do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	Set CardTypeCode=RtObj.CardTypeCode
	Set CardNo=RtObj.CardNo
	Set SecrityNo=RtObj.SecrityNo
	Set PatientID=RtObj.PatientID
	Set EpisodeID=RtObj.EpisodeID
	Set BillNo=RtObj.BillNo
	Set QueryDate=RtObj.QueryDate
	Set PrintFlag=RtObj.PrintFlag
	b ;1111
	If BillNo=""{
		Set ^DHCAutoIPDailyPrintFlag("PringFlag","PatientID",PatientID,QueryDate)=PrintFlag	
		Set ^DHCAutoIPDailyPrintFlag("PringFlag","PatientID",PatientID,QueryDate,"time")=+$g(^DHCAutoIPDailyPrintFlag("PringFlag","PatientID",PatientID,QueryDate,"time"))+1	;zhho打印次数
	}else{
		Set ^DHCAutoIPDailyPrintFlag("PringFlag","BillNo",BillNo,QueryDate)=PrintFlag
		Set ^DHCAutoIPDailyPrintFlag("PringFlag","BillNo",BillNo,QueryDate,"time")=	+$g(^DHCAutoIPDailyPrintFlag("PringFlag","BillNo",BillNo,QueryDate,"time"))+1   ;zhho打印次数
	}
	
	Set ResultCode=0,ErrorMsg="设置成功"
	Do Output11(ResultCode,ErrorMsg)
	
	Quit RpStream
	
Output11(ResultCode,ErrorMsg)
	Set RpStream=""
	Set RpObj.ResultCode=ResultCode
	Set RpObj.ErrorMsg=ErrorMsg
	Set RtStream=##class(%GlobalCharacterStream).%New()
	Do RpObj.XMLExportToStream(.RpStream,"Response")
	Set OutputXML=""
	Do RpObj.XMLExportToString(.OutputXML,"Response")
	B ;OutputXML
	
	Quit
	
SetIPDailyPrintFlagET
	Set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	Set streamObj=##class(%GlobalCharacterStream).%New()
	Do streamObj.Write(myrtn)
	Quit streamObj
}

}

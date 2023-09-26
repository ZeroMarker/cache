/// 处方打印
Class DHCExternalService.QryInterface.BL.PHPrescInfo Extends %RegisteredObject
{

/// 获取处方列表
ClassMethod GetPHPrescList(input As %String) As %GlobalCharacterStream
{
	set $zt="GetPHPrescListET"
	set RpObj=##Class(web.DHCEntity.PCA.GetPHPrescListRp).%New()
	set ResultCode="100",ErrorMsg="没有查询到处方信息"
	set RtObj=##Class(web.DHCEntity.PCA.GetPHPrescListRt).%New()
	do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	set CardNo=RtObj.CardNo
	set PatientID=RtObj.PatientID
	set StartDate=RtObj.StartDate
	set EndDate=RtObj.EndDate
	set PrintFlag=RtObj.PrintFlag
	if (PatientID="")
	{
		set cardInfo=##class(web.UDHCJFBaseCommon).GetPapmiByCardNO(CardNo)
		if (+cardInfo'=-1) set PatientID=$piece(cardInfo,"^",3)
		
	}
	if (PatientID'="")
	{
		set Papmi=$order(^PAPERi("PAPMI_PatNo",PatientID,0))
		if (Papmi'="")
		{
			set PatName=$piece($get(^PAPER(Papmi,"ALL")),"^",1)
			set myrtn=##Class(web.DHCSTInterfacePH).GetPHPrescList(StartDate, EndDate, PatientID)
			if ((+$piece(myrtn,"^",2)'=0)&&(myrtn'=0))
			{
				set ResultCode="0",ErrorMsg="查询成功"
				set RpObj.PatientID=PatientID
				set RpObj.PatName=PatName
				set pid=$piece(myrtn,"^",1)
				set num=0
				while($order(^TMP("DHCOutPh","DHCSTInterfacePH",pid,"presclist",num))'="")
				{
					set num=$order(^TMP("DHCOutPh","DHCSTInterfacePH",pid,"presclist",num))
					set mydata=$get(^TMP("DHCOutPh","DHCSTInterfacePH",pid,"presclist",num))
					set myobj=##Class(web.DHCEntity.PCA.Presc).%New()
					set myobj.PrescNo=$piece(mydata,"^",4)
					set myobj.PharmacyLoc=$piece(mydata,"^",3)
					set myobj.OrderLoc=$piece(mydata,"^",5)
					set myobj.PrescDate=$piece(mydata,"^",6)
					set myobj.InvoiceID=$piece(mydata,"^",7)
					set myPrintFlag="N"
					if ($data(^DHCPrescPrintFlag($piece(mydata,"^",4)))) set myPrintFlag="Y"
					if ((PrintFlag="Y")||(PrintFlag="N"))&&(PrintFlag'=myPrintFlag) continue
					set myobj.PrintFlag=myPrintFlag
					do RpObj.PrescS.Insert(myobj)
					do myobj.%Close()
				}
				kill ^TMP("DHCOutPh","DHCSTInterfacePH",pid,"presclist")	
			}
			
		}
		
	}
	set RpObj.ResultCode=ResultCode
	set RpObj.ErrorMsg=ErrorMsg
	//do RpObj.XMLExportToString(.XML,"Response")
	//quit XML
	set myobj=##class(%GlobalCharacterStream).%New()
	do RpObj.XMLExportToStream(.myobj,"Response")
	do RpObj.%Close()
	quit myobj

GetPHPrescListET
	set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	set streamObj=##class(%GlobalCharacterStream).%New()
	do streamObj.Write(myrtn)
	quit streamObj
}

/// 获取处方详细信息
ClassMethod GetPHPrescInfo(input As %String) As %GlobalCharacterStream
{
	set $zt="GetPHPrescInfoET"
	set RpObj=##Class(web.DHCEntity.PCA.GetPHPrescInfoRp).%New()
	set ResultCode="100",ErrorMsg="没有查询到处方的详细信息"
	set RtObj=##Class(web.DHCEntity.PCA.GetPHPrescInfoRt).%New()
	do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	set PrescNo=RtObj.PrescNo
	set InvoiceID=RtObj.InvoiceID
	set TotalAmount=0
	
	if (PrescNo'="")&&(InvoiceID'="")
	{
			set myrtn=##Class(web.DHCSTInterfacePH).GetPrescInfoByOrd(PrescNo,InvoiceID)
			if (myrtn'="")
			{
				set ResultCode="0",ErrorMsg="查询成功"
				set PatStr=$piece(myrtn,"!!",1)
				set MedStr=$piece(myrtn,"!!",2)
				set RpObj.PatientID=$piece(PatStr,"^",1)
				set RpObj.PatName=$piece(PatStr,"^",2)
				set RpObj.PatAge=$piece(PatStr,"^",3)
				set RpObj.PatSex=$piece(PatStr,"^",4)
				set RpObj.Diagnos=$piece(PatStr,"^",5)
				set RpObj.PatWeight=$piece(PatStr,"^",6)
				set RpObj.DispensingUser=$piece(PatStr,"^",7)
				set RpObj.MedicineUser=$piece(PatStr,"^",8)
				set RpObj.DispensingDate=$piece(PatStr,"^",9)
				set RpObj.MedicineDate=$piece(PatStr,"^",10)
				set RpObj.PharmacyLoc=$piece(PatStr,"^",37)
				set RpObj.PatUnit=$piece(PatStr,"^",13)
				set RpObj.AdmDate=$piece(PatStr,"^",14)
				set RpObj.PrescNo=$piece(PatStr,"^",16)
				set RpObj.AdmLoc=$piece(PatStr,"^",17)
				set RpObj.PhaWindow=$piece(PatStr,"^",18)
				set RpObj.PatTel=$piece(PatStr,"^",19)
				set RpObj.PatAddress=$piece(PatStr,"^",20)
				set RpObj.DecoctDrugMedthod=$piece(PatStr,"^",21)
				set RpObj.DecoctDrugQty=$piece(PatStr,"^",22)
				set RpObj.PrescType=$piece(PatStr,"^",23)
				set RpObj.OrderLoc=$piece(PatStr,"^",24)
				set RpObj.Doctor=$piece(PatStr,"^",25)
				set RpObj.DecoctDrugIntro=$piece(PatStr,"^",26)
				set RpObj.DecoctDrugDose=$piece(PatStr,"^",27)
				set RpObj.PrescDate=$piece(PatStr,"^",32)
				set RpObj.ChargeDate=$piece(PatStr,"^",33)
				set RpObj.InsuType=$piece(PatStr,"^",36)
				
				set OrderNum=$length(MedStr,"@")
				for i=1:1:OrderNum
				{	
					set mydata=$piece(MedStr,"@",i)
					set myobj=##Class(web.DHCEntity.PCA.DrugOrder).%New()
					set myobj.DrugName=$piece(mydata,"^",1)
					set myobj.Qty=$piece(mydata,"^",2)
					set myobj.Unit=$piece(mydata,"^",3)
					set myobj.Dose=$piece(mydata,"^",4)
					set myobj.DoseUnit=""
					set myobj.Intro=$piece(mydata,"^",5)
					set myobj.Freq=$piece(mydata,"^",6)
					set myobj.Duration=$piece(mydata,"^",7)
					set myobj.Price=$piece(mydata,"^",8)
					set myobj.Amount=$piece(mydata,"^",9)
					set myobj.SkinTest=$piece(mydata,"^",10)
					set myobj.OrderRemarks=$piece(mydata,"^",11)
					set myobj.SpecIntro=$piece(mydata,"^",12)
					set myobj.DrugCode=$piece(mydata,"^",14)
					set myobj.Specifications=$piece(mydata,"^",15)
					set TotalAmount=TotalAmount+(+$piece(mydata,"^",9))
					do RpObj.DrugOrders.Insert(myobj)
					do myobj.%Close()
				}
				set RpObj.TotalAmount=$j(TotalAmount,3,2)					
			}
	}
	set RpObj.ResultCode=ResultCode
	set RpObj.ErrorMsg=ErrorMsg
	//do RpObj.XMLExportToString(.XML,"Response")
	//quit XML
	set myobj=##class(%GlobalCharacterStream).%New()
	do RpObj.XMLExportToStream(.myobj,"Response")
	do RpObj.%Close()
	quit myobj

GetPHPrescInfoET
	set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	set streamObj=##class(%GlobalCharacterStream).%New()
	do streamObj.Write(myrtn)
	quit streamObj
}

/// 设置处方打印标记
ClassMethod SetPHPrescPrintFlag(input As %String) As %GlobalCharacterStream
{
	set $zt="SetPHPrescPrintFlagET"
	set RpObj=##Class(web.DHCEntity.PCA.SetPHPrescPrintFlagRp).%New()
	set ResultCode="100",ErrorMsg="处方打印标记设置失败"
	set RtObj=##Class(web.DHCEntity.PCA.SetPHPrescPrintFlagRt).%New()
	do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	set PrescNo=RtObj.PrescNo
	set InvoiceID=RtObj.InvoiceID	
	if (PrescNo'="")
	{
		set num=+$order(^DHCPrescPrintFlag(PrescNo,""),-1)+1
		set ^DHCPrescPrintFlag(PrescNo,num)=$zdate(+$H,3)_" "_$zt($piece($H,",",2))
		set ResultCode="0",ErrorMsg="处方打印标记设置成功"
	}
	set RpObj.ResultCode=ResultCode
	set RpObj.ErrorMsg=ErrorMsg
	//do RpObj.XMLExportToString(.XML,"Response")
	//quit XML
	set myobj=##class(%GlobalCharacterStream).%New()
	do RpObj.XMLExportToStream(.myobj,"Response")
	do RpObj.%Close()
	quit myobj
SetPHPrescPrintFlagET
	set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	set streamObj=##class(%GlobalCharacterStream).%New()
	do streamObj.Write(myrtn)
	quit streamObj
}

}

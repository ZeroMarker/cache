Class DHCExternalService.QryInterface.BL.InvFeeInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// 根据卡号取病人信息
/// d ##class(DHCExternalService.QryInterface.BL.InvFeeInfo).GetPatInfo()
ClassMethod GetPatInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	set $zt="GetPatInfoET"
	set RpObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetPatInfoRp).%New()
	set ResultCode="100",ErrorMsg="没有查询到人员信息"
	set RtObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetPatInfoRt).%New()
	do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	set CardTypeCode=RtObj.CardTypeCode
	set CardNo=RtObj.CardNo
	if (CardNo="")
    {
	    do Output1("-101","卡号不能为空")
		quit RpStream
	}
	set CardTypeID=..GetHisCardTypeID(CardTypeCode)
	set PatientID=..GetPaitntIDByCard(CardTypeID,CardNo)
	if (PatientID="")
    {
	    do Output1("-102","没有找到病人信息")
		quit RpStream
	}
	set ResultCode="0",ErrorMsg="成功"	
	set myPatientID=..PatientNoToID(PatientID)
	set PatName=$p($g(^PAPER(myPatientID,"ALL")),"^",1)
	set RpObj.PatientID=PatientID
	set RpObj.PatName=PatName
	do Output1(ResultCode,ErrorMsg)
	quit RpStream
	
Output1(ResultCode,ErrorMsg)
	set RpStream=""
	set RpObj.ResultCode=ResultCode
	set RpObj.ErrorMsg=ErrorMsg
	set RtStream=##class(%GlobalCharacterStream).%New()
	do RpObj.XMLExportToStream(.RpStream,"Response")
	//do RpObj.XMLExportToString(.xmlOut,"Response")
	b ;xmlOut
	quit
GetPatInfoET
	set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	set streamObj=##class(%GlobalCharacterStream).%New()
	do streamObj.Write(myrtn)
	quit streamObj
}

/// 取门诊费用发票信息
ClassMethod GetOutPatInvInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	set $zt="GetOutPatInvInfoET"
	set RpObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetOutPatInvInfoRp).%New()
	set ResultCode="100",ErrorMsg="没有查询到信息"
	set RtObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetOutPatInvInfoRt).%New()
	do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	set PatientID=RtObj.PatientID
	if (PatientID="")
    {
	    do Output2("-102","没有找到病人信息")
		quit RpStream
	}
	set Row=0,RecordCount=0
	set rs=##Class(%ResultSet).%New("web.DHCIPBillTouchFee:FindOutPatFeeInfo")
		if rs.QueryIsValid() { 
			Set Status=rs.Execute("",PatientID)
			Set columns = rs.GetColumnCount()
			;b ;Status
			;If 'Status Quit
			While rs.Next() {
				set Row=Row+1
				
				set ResultCode="0",ErrorMsg="成功"
				set InvInfoObj=##Class(DHCExternalService.QryInterface.MSG.FEE.OPInvInfo).%New()
				s InvInfoObj.InvID=rs.GetDataByName("发票ID")
				s InvInfoObj.InvNo=rs.GetDataByName("发票号")
				s InvInfoObj.InvDate=rs.GetDataByName("发票日期")
				s InvInfoObj.TotalAmount=rs.GetDataByName("总费用")
				s InvInfoObj.ChargeFlag=rs.GetDataByName("结算标志")
				s InvInfoObj.AdmLoc=rs.GetDataByName("就诊科室")
				
				do RpObj.InvInfoS.Insert(InvInfoObj)
				kill InvInfoObj
				s RecordCount=RecordCount+1
				
			}
		}
		
	do Output2(ResultCode,ErrorMsg)
	quit RpStream
	
Output2(ResultCode,ErrorMsg)
	set RpStream=""
	set RpObj.ResultCode=ResultCode
	set RpObj.ErrorMsg=ErrorMsg
	set RtStream=##class(%GlobalCharacterStream).%New()
	do RpObj.XMLExportToStream(.RpStream,"Response")
	//do RpObj.XMLExportToString(.xmlOut,"Response")
	;b ;xmlOut
	quit
GetOutPatInvInfoET
	set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	set streamObj=##class(%GlobalCharacterStream).%New()
	do streamObj.Write(myrtn)
	quit streamObj
}

/// 取门诊费用发票分类金额
ClassMethod GetOutPatCateFeeInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	set $zt="GetOutPatCateFeeInfoET"
	set RpObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetOutPatCateFeeInfoRp).%New()
	set ResultCode="100",ErrorMsg="没有查询到信息"
	set RtObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetOutPatCateFeeInfoRt).%New()
	do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	set InvID=RtObj.InvID
	if (InvID="")
    {
	    do Output3("-102","发票ID不能为空")
		quit RpStream
	}
	set Row=0,RecordCount=0
	set rs=##Class(%ResultSet).%New("web.DHCIPBillTouchFee:FindOutPatCateFeeInfo")
		if rs.QueryIsValid() { 
			Set Status=rs.Execute(InvID)
			Set columns = rs.GetColumnCount()
			;b ;Status
			;If 'Status Quit
			While rs.Next() {
				set Row=Row+1
				
				set ResultCode="0",ErrorMsg="成功"
				for i=1:1:5
				{
					set CateDesc=rs.GetDataByName("分类"_i)
					set CateFee=rs.GetDataByName("金额"_i)
					if (+CateFee>0)
					{
				    	set CateFeeObj=##Class(DHCExternalService.QryInterface.MSG.FEE.CateFee).%New()
				    	set CateFeeObj.CateDesc=CateDesc
				    	set CateFeeObj.Fee=CateFee
						do RpObj.CateFeeS.Insert(CateFeeObj)
						kill CateFeeObj
						s RecordCount=RecordCount+1
					}
				}
			}
		}
		
	
	do Output3(ResultCode,ErrorMsg)
	quit RpStream
	
Output3(ResultCode,ErrorMsg)
	set RpStream=""
	set RpObj.ResultCode=ResultCode
	set RpObj.ErrorMsg=ErrorMsg
	set RtStream=##class(%GlobalCharacterStream).%New()
	do RpObj.XMLExportToStream(.RpStream,"Response")
	//do RpObj.XMLExportToString(.xmlOut,"Response")
	b ;xmlOut
	quit
GetOutPatCateFeeInfoET
	set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	set streamObj=##class(%GlobalCharacterStream).%New()
	do streamObj.Write(myrtn)
	quit streamObj
}

/// 取门诊发票费用分类明细信息
ClassMethod GetOutPatCateFeeDetail(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	set $zt="GetOutPatCateFeeDetailET"
	set RpObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetOutPatCateFeeDetailRp).%New()
	set ResultCode="100",ErrorMsg="没有查询到信息"
	set RtObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetOutPatCateFeeInfoRt).%New()
	do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	set InvID=RtObj.InvID
	if (InvID="")
    {
	    do Output4("-102","发票ID不能为空")
		quit RpStream
	}
	set Row=0,RecordCount=0
	set rs=##Class(%ResultSet).%New("web.DHCIPBillTouchFee:FindOutPatCateFeeDetail")
		if rs.QueryIsValid() { 
			Set Status=rs.Execute(InvID)
			Set columns = rs.GetColumnCount()
			;b ;Status
			;If 'Status Quit
			While rs.Next() {
				set Row=Row+1
				
				set ResultCode="0",ErrorMsg="成功"
				set InvItemObj=##Class(DHCExternalService.QryInterface.MSG.FEE.InvItem).%New()
				s InvItemObj.ItemCateDesc=rs.GetDataByName("收费项目分类")
				s InvItemObj.ItemDesc=rs.GetDataByName("收费项目名称")
				s InvItemObj.Uom=rs.GetDataByName("单位")
				s InvItemObj.Price=rs.GetDataByName("单价")
				s InvItemObj.Qty=rs.GetDataByName("数量")
				s InvItemObj.Fee=rs.GetDataByName("金额")
				
				do RpObj.InvItemS.Insert(InvItemObj)
				kill InvItemObj
				s RecordCount=RecordCount+1
				
			}
		}
		
	
	do Output4(ResultCode,ErrorMsg)
	quit RpStream
	
Output4(ResultCode,ErrorMsg)
	set RpStream=""
	set RpObj.ResultCode=ResultCode
	set RpObj.ErrorMsg=ErrorMsg
	set RtStream=##class(%GlobalCharacterStream).%New()
	do RpObj.XMLExportToStream(.RpStream,"Response")
	//do RpObj.XMLExportToString(.xmlOut,"Response")
	b ;xmlOut
	quit
GetOutPatCateFeeDetailET
	set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	set streamObj=##class(%GlobalCharacterStream).%New()
	do streamObj.Write(myrtn)
	quit streamObj
}

/// 取住院费用发票信息
ClassMethod GetInPatInvInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	set $zt="GetInPatInvInfoET"
	set RpObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetInPatInvInfoRp).%New()
	set ResultCode="100",ErrorMsg="没有查询到信息"
	set RtObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetOutPatInvInfoRt).%New()
	do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	set PatientID=RtObj.PatientID
	if (PatientID="")
    {
	    do Output5("-102","没有找到病人信息")
		quit RpStream
	}
	set Row=0,RecordCount=0
	set rs=##Class(%ResultSet).%New("web.DHCIPBillTouchFee:FindInPatFeeInfo")
		if rs.QueryIsValid() { 
			Set Status=rs.Execute("",PatientID)
			Set columns = rs.GetColumnCount()
			;b ;Status
			;If 'Status Quit
			While rs.Next() {
				set Row=Row+1
				
				set ResultCode="0",ErrorMsg="成功"
				set InvInfoObj=##Class(DHCExternalService.QryInterface.MSG.FEE.IPInvInfo).%New()
				s InvInfoObj.StartDate=rs.GetDataByName("开始日期")
				s InvInfoObj.EndDate=rs.GetDataByName("结束日期")
				s InvInfoObj.TotalAmount=rs.GetDataByName("总费用")
				s InvInfoObj.Deposit=rs.GetDataByName("预交金")
				s InvInfoObj.ChargeFlag=rs.GetDataByName("结算标志")
				if (InvInfoObj.ChargeFlag="B") set InvInfoObj.ChargeFlag="未结算"
				if (InvInfoObj.ChargeFlag="P") set InvInfoObj.ChargeFlag="已结算"
				s InvInfoObj.InvNo=rs.GetDataByName("收据号")
				s InvInfoObj.BillNo=rs.GetDataByName("账单号")
				s InvInfoObj.AdmLoc=rs.GetDataByName("就诊科室")
				
				do RpObj.InvInfoS.Insert(InvInfoObj)
				kill InvInfoObj
				s RecordCount=RecordCount+1
				
			}
		}
		
	
	do Output5(ResultCode,ErrorMsg)
	quit RpStream
	
Output5(ResultCode,ErrorMsg)
	set RpStream=""
	set RpObj.ResultCode=ResultCode
	set RpObj.ErrorMsg=ErrorMsg
	set RtStream=##class(%GlobalCharacterStream).%New()
	do RpObj.XMLExportToStream(.RpStream,"Response")
	//do RpObj.XMLExportToString(.xmlOut,"Response")
	b ;xmlOut
	quit
GetInPatInvInfoET
	set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	set streamObj=##class(%GlobalCharacterStream).%New()
	do streamObj.Write(myrtn)
	quit streamObj
}

/// 取住院费用发票分类金额
ClassMethod GetInPatCateFeeInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	set $zt="GetInPatCateFeeInfoET"
	set RpObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetOutPatCateFeeInfoRp).%New()
	set ResultCode="100",ErrorMsg="没有查询到信息"
	set RtObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetInPatCateFeeInfoRt).%New()
	do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	set BillNo=RtObj.BillNo
	if (BillNo="")
    {
	    do Output6("-102","账单号不能为空")
		quit RpStream
	}
	set Row=0,RecordCount=0
	set adm=$p(^DHCPB(BillNo),"^",1)
	set info=##class(web.UDHCJFBaseCommon).GetPatAdmInfo(adm,"",BillNo)
	set patInfo=$p(info,"#",1)
	set admInfo=$p(info,"#",2)
	;s PatInfo=PapNo_"^"_PapName_"^"_Medicare_"^"_PapmiId_"^"_Sex_"^"_$g(Address)_"^"_PapSecondPhone_"^"_Paplinkman_"^"_Paplinkrelation_"^"_Paplinkaddress_"^"_Paplinkphone_"^"_Payibaoshouce
	;s AdmInfo=AdmDate_"^"_DisDate_"^"_AdmReason_"^"_LocDesc_"^"_WardDesc_"^"_BedNo_"^"_StayDate
	set patientID=$p(patInfo,"^",1)	;登记号
	set patName=$p(patInfo,"^",2)
	set medicare=$p(patInfo,"^",3)
	set papmidr=$p(patInfo,"^",4)
	set sex=$p(patInfo,"^",5)
	set age=""
	b ;11
	;set patientDOB=$P($G(^PAPER(papmidr,"ALL")),"^",6)
	;set age=..GetAgeDesc(patientDOB,+$h)
	
	set admDate=$p(admInfo,"^",1)
	set disDate=$p(admInfo,"^",2)
	set admReason=$p(admInfo,"^",3)
	set department=$p(admInfo,"^",4)
	set admInDays=$p(admInfo,"^",7)
	
	set totalAcount=$p(^DHCPB(BillNo),"^",8)
	
	set RpObj.PatientID=patientID
	set RpObj.MedicareID=medicare
	set RpObj.PatName=patName
	set RpObj.PatAge=age
	set RpObj.PatSex=sex
	set RpObj.AdmReason=admReason
	set RpObj.AdmDate=admDate
	set RpObj.DisDate=disDate
	set RpObj.AdmInDays=admInDays
	set RpObj.Department=department
	set RpObj.TotalAmount=$j(totalAcount,3,2)
	set RpObj.PrivateAmount=""
	
	set rs=##Class(%ResultSet).%New("web.DHCIPBillTouchFee:FindInPatCateFeeInfo")
		if rs.QueryIsValid() { 
			Set Status=rs.Execute(BillNo)
			Set columns = rs.GetColumnCount()
			;b ;Status
			;If 'Status Quit
			While rs.Next() {
				set Row=Row+1
				
				set ResultCode="0",ErrorMsg="成功"
				for i=1:1:5
				{
					set CateDesc=rs.GetDataByName("分类"_i)
					set CateFee=rs.GetDataByName("金额"_i)
					if (+CateFee>0)
					{
				    	set CateFeeObj=##Class(DHCExternalService.QryInterface.MSG.FEE.CateFee).%New()
				    	set CateFeeObj.CateDesc=CateDesc
				    	set CateFeeObj.Fee=CateFee
						do RpObj.CateFeeS.Insert(CateFeeObj)
						kill CateFeeObj
						s RecordCount=RecordCount+1
					}
				}
			}
		}
		
	
	do Output6(ResultCode,ErrorMsg)
	quit RpStream
	
Output6(ResultCode,ErrorMsg)
	set RpStream=""
	set RpObj.ResultCode=ResultCode
	set RpObj.ErrorMsg=ErrorMsg
	set RtStream=##class(%GlobalCharacterStream).%New()
	do RpObj.XMLExportToStream(.RpStream,"Response")
	do RpObj.XMLExportToString(.xmlOut,"Response")
	b ;xmlOut
	quit
GetInPatCateFeeInfoET
	set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	set streamObj=##class(%GlobalCharacterStream).%New()
	do streamObj.Write(myrtn)
	quit streamObj
}

/// 取住院发票费用分类明细信息
ClassMethod GetInPatCateFeeDetail(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;w ##class(DHCExternalService.QryInterface.BL.InvFeeInfo).GetInPatCateFeeDetail("<Request><TradeCode>90007</TradeCode><BillNo>208185</BillNo><BillDate>2013-12-11</BillDate></Request>")
	set $zt="GetInPatCateFeeDetailET"
	set RpObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetOutPatCateFeeDetailRp).%New()
	set ResultCode="100",ErrorMsg="没有查询到信息"
	set RtObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetInPatCateFeeInfoRt).%New()
	do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	set BillNo=RtObj.BillNo
	if (BillNo="")
    {
	    do Output7("-102","账单号不能为空")
		quit RpStream
	}
	set BillDate=RtObj.BillDate
	set PrintFlag="N"
	set Row=0,RecordCount=0
	set rs=##Class(%ResultSet).%New("web.DHCIPBillTouchFee:FindInPatCateFeeDetail")
		if rs.QueryIsValid() { 
			Set Status=rs.Execute(BillNo,BillDate)
			Set columns = rs.GetColumnCount()
			;b ;Status
			;If 'Status Quit
			While rs.Next() {
				set Row=Row+1
				
				set ResultCode="0",ErrorMsg="成功"
				set InvItemObj=##Class(DHCExternalService.QryInterface.MSG.FEE.InvItem).%New()
				s InvItemObj.ItemCateDesc=rs.GetDataByName("收费项目分类")
				s InvItemObj.ItemDesc=rs.GetDataByName("收费项目名称")
				s InvItemObj.Uom=rs.GetDataByName("单位")
				s InvItemObj.Price=rs.GetDataByName("单价")
				s InvItemObj.Qty=rs.GetDataByName("数量")
				s InvItemObj.Fee=rs.GetDataByName("金额")
				
				s myPrintFlag=rs.GetDataByName("打印标志")
				i myPrintFlag="Y" s PrintFlag=myPrintFlag
				
				d RpObj.InvItemS.Insert(InvItemObj)
				
				kill InvItemObj
				s RecordCount=RecordCount+1
				
			}
		}
	Set RpObj.PrintFlag=PrintFlag
	
	do Output7(ResultCode,ErrorMsg)
	quit RpStream
	
Output7(ResultCode,ErrorMsg)
	set RpStream=""
	set RpObj.ResultCode=ResultCode
	set RpObj.ErrorMsg=ErrorMsg
	set RtStream=##class(%GlobalCharacterStream).%New()
	do RpObj.XMLExportToStream(.RpStream,"Response")
	do RpObj.XMLExportToString(.xmlOut,"Response")
	b ;xmlOut
	quit
GetInPatCateFeeDetailET
	set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	set streamObj=##class(%GlobalCharacterStream).%New()
	do streamObj.Write(myrtn)
	quit streamObj
}

/// 查询药品价格
ClassMethod GetMedPrice(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	set $zt="GetMedPriceET"
	set RpObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetMedPriceRp).%New()
	set ResultCode="100",ErrorMsg="没有查询到信息"
	set RtObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetMedPriceRt).%New()
	do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	set Alias=RtObj.Alias
	if (Alias="")
    {
	    do Output8("-102","别名不能为空")
		quit RpStream
	}
	set Row=0,RecordCount=0
	set rs=##Class(%ResultSet).%New("web.DHCIPBillTouchFee:FindMedInfoByAlias")
		if rs.QueryIsValid() { 
			Set Status=rs.Execute(Alias)
			Set columns = rs.GetColumnCount()
			;b ;Status
			;If 'Status Quit
			While rs.Next() {
				set Row=Row+1
				
				set ResultCode="0",ErrorMsg="成功"
				set MedItemObj=##Class(DHCExternalService.QryInterface.MSG.FEE.MedItem).%New()
				s MedItemObj.SerialNo=rs.GetDataByName("序号")
				s MedItemObj.ItemDesc=rs.GetDataByName("药品名称")
				s MedItemObj.ItemCode=rs.GetDataByName("代码")
				s MedItemObj.PricesNo=rs.GetDataByName("物价编码")
				s MedItemObj.MedCate=rs.GetDataByName("药品类别")
				s MedItemObj.DrugForm=rs.GetDataByName("剂型")
				s MedItemObj.Uom=rs.GetDataByName("单位")
				s MedItemObj.Price=rs.GetDataByName("价格")
				s MedItemObj.Factory=rs.GetDataByName("生产厂家")
				s MedItemObj.Level=rs.GetDataByName("等级")
				s MedItemObj.ChargeStandard=rs.GetDataByName("收费依据")
				s MedItemObj.InsureSign=rs.GetDataByName("医保标示")
				do RpObj.MedItemS.Insert(MedItemObj)
				kill MedItemObj
				s RecordCount=RecordCount+1
				
			}
		}
		
	
	do Output8(ResultCode,ErrorMsg)
	b ;009
	quit RpStream
	
Output8(ResultCode,ErrorMsg)
	set RpStream=""
	set RpObj.ResultCode=ResultCode
	set RpObj.ErrorMsg=ErrorMsg
	set RtStream=##class(%GlobalCharacterStream).%New()
	do RpObj.XMLExportToStream(.RpStream,"Response")
	//do RpObj.XMLExportToString(.xmlOut,"Response")
	b ;xmlOut
	quit
GetMedPriceET
	set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	set streamObj=##class(%GlobalCharacterStream).%New()
	do streamObj.Write(myrtn)
	quit streamObj
}

/// 查询非药品收费项目价格
ClassMethod GetTarItemPrice(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	set $zt="GetTarItemPriceET"
	set RpObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetTarItemPriceRp).%New()
	set ResultCode="100",ErrorMsg="没有查询到信息"
	set RtObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetMedPriceRt).%New()
	do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	set Alias=RtObj.Alias
	if (Alias="")
    {
	    do Output9("-102","别名不能为空")
		quit RpStream
	}
	set Row=0,RecordCount=0
	set rs=##Class(%ResultSet).%New("web.DHCIPBillTouchFee:FindTarItemPrice")
		if rs.QueryIsValid() { 
			Set Status=rs.Execute(Alias)
			Set columns = rs.GetColumnCount()
			;b ;Status
			;If 'Status Quit
			While rs.Next() {
				set Row=Row+1
				
				set ResultCode="0",ErrorMsg="成功"
				set TarItemObj=##Class(DHCExternalService.QryInterface.MSG.FEE.TarItem).%New()
				s TarItemObj.SerialNo=rs.GetDataByName("序号")
				s TarItemObj.ItemDesc=rs.GetDataByName("项目名称")
				s TarItemObj.ItemCode=rs.GetDataByName("项目编码")
				s TarItemObj.PricesNo=rs.GetDataByName("物价编码")
				s TarItemObj.Uom=rs.GetDataByName("计价单位")
				s TarItemObj.Price=rs.GetDataByName("普通价格")
				s TarItemObj.SpecialPrice=rs.GetDataByName("特需价格")
				s TarItemObj.Factory=rs.GetDataByName("生产厂家")
				s TarItemObj.ContentDesc=rs.GetDataByName("内容说明")
				s TarItemObj.InsureSign=rs.GetDataByName("医保标示")
				s TarItemObj.ChargeStandard=rs.GetDataByName("收费依据")
				s TarItemObj.RegistrationNo=rs.GetDataByName("注册证号")
				s TarItemObj.RegExpDate=rs.GetDataByName("注册有效期")
				
				do RpObj.TarItemS.Insert(TarItemObj)
				kill TarItemObj
				s RecordCount=RecordCount+1
				
			}
		}
		
	
	do Output9(ResultCode,ErrorMsg)
	quit RpStream
	
Output9(ResultCode,ErrorMsg)
	set RpStream=""
	set RpObj.ResultCode=ResultCode
	set RpObj.ErrorMsg=ErrorMsg
	set RtStream=##class(%GlobalCharacterStream).%New()
	do RpObj.XMLExportToStream(.RpStream,"Response")
	//do RpObj.XMLExportToString(.xmlOut,"Response")
	b ;xmlOut
	quit
GetTarItemPriceET
	set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	set streamObj=##class(%GlobalCharacterStream).%New()
	do streamObj.Write(myrtn)
	quit streamObj
}

ClassMethod GetPaitntIDByCard(CardTypeID As %String, CardNo As %String) As %String
{
	if (CardNo="") quit ""
	set PatientID=""
	s CFRowid=0
		for {
			s CFRowid=$O(^DHCCARDi("CF",0,"CardNo",CardNo,CFRowid)) Q:CFRowid=""
			s CFActive=$p(^DHCCARD("CF",CFRowid),"^",10)
			Continue:CFActive'="N"
			s CFCardTypeDR=$p(^DHCCARD("CF",CFRowid),"^",16)
			Continue:(CardTypeID'="")&&(CardTypeID'=CFCardTypeDR)
			s PatientID=$p(^DHCCARD("CF",CFRowid),"^",6)
		}
	quit PatientID
}

/// PatientID to RegNo
ClassMethod PatientIDToNo(PatientID As %String = "") As %String
{
	q:PatientID="" ""
	q $P($g(^PAPER(PatientID,"PAT",1)),"^",1)
}

/// RegNo to PatientID
ClassMethod PatientNoToID(RegNo As %String = "") As %String
{
	q:RegNo="" ""
	q $O(^PAPERi("PAPMI_PatNo",RegNo,0))
}

ClassMethod GetHisCardTypeID(CardTypeCode)
{
	Q:CardTypeCode="" ""
	s myCardTypeId=""
	s CardTypeId=0
	for {
		s CardTypeId=$O(^DHCCARDTYPEDef(CardTypeId))
		q:CardTypeId=""
		s CTDCode=$p($g(^DHCCARDTYPEDef(CardTypeId)),"^",1)
		i CTDCode=CardTypeCode {
			s myCardTypeId=CardTypeId
			Quit
		}
	}
	Quit myCardTypeId
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

}

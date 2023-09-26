Class DHCENS.BC.Method.Interface Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

/// 得到字典信息
ClassMethod GetDictInfo(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("GetDictInfo","DHCENS.BC.Model.GetDictInfoRt")
	Set DicCat=""
	While reader.Next(.obj,.sc) {
		Set DicCat=obj.DicCat
	}
	Set tmpInput=DicCat
	Set tmpInput=$tr(tmpInput,$c(0),"")
    
    Set objStream=##class(%GlobalCharacterStream).%New()
	Set objStream=##class(DHCENS.BaseCode.GetDictInfo).GetDictInfo(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><GetDictInfoReturn><ResultCode>-1</ResultCode><ResultContent>Interface中GetDictInfo方法异常</ResultContent></GetDictInfoReturn></Response>")
    Quit objStream
}

/// 获取病人列表
ClassMethod GetPatList(Input As %GlobalCharacterStream) As %String
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("GetPatList","DHCENS.BC.Model.GetPatListRt")
	Set CardValue="",CardTypes="",StartDate="",EndDate="",ExeLoc="",Status=""
	
	While reader.Next(.obj,.sc) {
		Set CardValue=$tr(obj.CardValue,$char(0),"")
		Set CardTypes=$tr(obj.CardTypes,$char(0),"")
		Set StartDate=$tr(obj.StartDate,$char(0),"")
		Set EndDate=$tr(obj.EndDate,$char(0),"")
		Set ExeLoc=$tr(obj.ExeLoc,$char(0),"")
		Set Status=$tr(obj.Status,$char(0),"")
	}
	Set tmpInput=CardValue_"^"_CardTypes_"^"_StartDate_"^"_EndDate_"^"_ExeLoc_"^"_Status
	Set tmpInput=$tr(tmpInput,$c(0),"")
    
    Set objStream=##class(%GlobalCharacterStream).%New()
	Set objStream=##class(DHCENS.BC.GetPatList).GetPatList(CardValue,CardTypes,StartDate,EndDate,ExeLoc,Status)
    Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><GetPatListReturn><ResultCode>-1</ResultCode><ResultContent>Interface中GetPatList方法异常</ResultContent></GetPatListReturn></Response>")
    Quit objStream
}

/// 得到病人基本信息
ClassMethod GetPatInfo(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("GetPatInfo","DHCENS.BC.Model.GetPatInfoRt")
	Set Rowid=""
	
	While reader.Next(.obj,.sc) {
		Set Rowid=obj.Rowid
	}
	Set tmpInput=Rowid
	Set tmpInput=$tr(tmpInput,$c(0),"")
	
	Set objStream=##class(%GlobalCharacterStream).%New()
	Set objStream=##class(DHCENS.BC.GetPatInfo).GetPatInfo(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><GetPatInfoReturn><ResultCode>-1</ResultCode><ResultContent>Interface中GetPatInfo方法异常</ResultContent></GetPatInfoReturn></Response>")
    Quit objStream
}

/// 预约
ClassMethod BookedInfo(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	d Input.Rewind()
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(Input)
	d reader.Correlate("Request","DHCENS.BC.Model.BookedInfoRt")
	s tmpInput=""
	While reader.Next(.obj,.sc) {
		s Len=obj.BookedInfos.Count()
		f i=1:1:Len
		{
			s objBookedInfo=obj.BookedInfos.GetAt(i)
			
			if (tmpInput="")
			{
				s tmpInput=objBookedInfo.Rowid_"^"_objBookedInfo.ResourceInfo_"^"_objBookedInfo.BookedDate_"^"_objBookedInfo.BookedTime_"^"_objBookedInfo.OperaterInfo_"^"_objBookedInfo.NoteInfo_"^"_objBookedInfo.OtherInfo
			}
			else
			{
				s tmpInput=tmpInput_"/"_objBookedInfo.Rowid _"^"_objBookedInfo.ResourceInfo_"^"_objBookedInfo.BookedDate_"^"_objBookedInfo.BookedTime_"^"_objBookedInfo.OperaterInfo_"^"_objBookedInfo.NoteInfo_"^"_objBookedInfo.OtherInfo
			}
		}
	}
	Set tmpInput=$tr(tmpInput,$c(0),"")
	
	Set objStream=##class(%GlobalCharacterStream).%New()
	Set objStream=##class(DHCENS.BC.BookedInfo).BookedInfo(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><BookedInfoReturn><ResultCode>-1</ResultCode><ResultContent>Interface中BookedInfo方法异常</ResultContent></BookedInfoReturn></Response>")
    Quit objStream
}

/// 取消预约
ClassMethod CancelBookedInfo(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("Request","DHCENS.BC.Model.CancelBookedInfoRt")
	s tmpInput=""
	While reader.Next(.obj,.sc) {
		s Len=obj.CancelBookedInfos.Count()
		f i=1:1:Len
		{
			s objCancelBookedInfo=obj.CancelBookedInfos.GetAt(i)
			
			if (tmpInput="")
			{
				s tmpInput=objCancelBookedInfo.Rowid
			}
			else
			{
				s tmpInput=tmpInput_"/"_objCancelBookedInfo.Rowid
			}
		}
	}
	Set tmpInput=$tr(tmpInput,$c(0),"")
	
	Set objStream=##class(%GlobalCharacterStream).%New()
	Set objStream=##class(DHCENS.BC.CancelBookedInfo).CancelBookedInfo(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><CancelBookedInfoReturn><ResultCode>-1</ResultCode><ResultContent>HIS端Interface中CancelBookedInfo方法异常</ResultContent></CancelBookedInfoReturn></Response>")
    Quit objStream
}

/// 登记
ClassMethod RegInfo(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("Request","DHCENS.BC.Model.RegInfoRt")
	s tmpInput=""
	While reader.Next(.obj,.sc) {
		s Len=obj.RegInfos.Count()
		f i=1:1:Len
		{
			s objRegInfos=obj.RegInfos.GetAt(i)
			
			if (tmpInput="")
			{
				s tmpInput=objRegInfos.Rowid_"^"_objRegInfos.StudyNo_"^"_objRegInfos.EQInfo_"^"_objRegInfos.OperatorInfo_"^"_objRegInfos.MainDocInfo
			}
			else
			{
				s tmpInput=tmpInput_"/"_objRegInfos.Rowid_"^"_objRegInfos.StudyNo_"^"_objRegInfos.EQInfo_"^"_objRegInfos.OperatorInfo_"^"_objRegInfos.MainDocInfo
			}
		}
	}
	Set tmpInput=$tr(tmpInput,$c(0),"")
	
	Set objStream=##class(%GlobalCharacterStream).%New()
	Set objStream=##class(DHCENS.BC.RegInfo).RegInfo(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><RegInfoReturn><ResultCode>-1</ResultCode><ResultContent>Interface中RegInfo方法异常</ResultContent></RegInfoReturn></Response>")
    Quit objStream
}

/// 增加医嘱
ClassMethod AddOrderItem(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("AddOrderItem","DHCENS.BC.Model.AddOrderItemRt")
	Set AdmNo="",ArcimCode="",ArcimDesc="",OrderStatus="",OrderQty=""
	Set OrderDeptCode="",OrderRecDepCode="",OrderDoctor="",OrderUserCode=""
	Set OrderSttDat="",OrderSttTim="",FeeType=""
	While reader.Next(.obj,.sc) {
		Set AdmNo=obj.AdmNo
		Set ArcimCode=obj.ArcimCode
	    Set ArcimDesc=obj.ArcimDesc
	    Set OrderStatus=obj.OrderStatus
	    Set OrderQty=obj.OrderQty
	    Set OrderDeptCode=obj.OrderDeptCode
	    Set OrderRecDepCode=obj.OrderRecDepCode
	    Set OrderDoctor=obj.OrderDoctor
	    Set OrderUserCode=obj.OrderUserCode
	    Set OrderSttDat=obj.OrderSttDat
	    Set OrderSttTim=obj.OrderSttTim
	    Set FeeType=obj.FeeType
	}
	Set tmpInput=AdmNo_"^"_ArcimCode_"^"_ArcimDesc_"^"_OrderStatus
	Set tmpInput=tmpInput_"^"_OrderQty_"^"_OrderDeptCode_"^"_OrderRecDepCode
	Set tmpInput=tmpInput_"^"_OrderDoctor_"^"_OrderUserCode_"^"_OrderSttDat
	Set tmpInput=tmpInput_"^"_OrderSttTim_"^"_FeeType
	Set tmpInput=$tr(tmpInput,$c(0),"")
	
	Set objStream=##class(%GlobalCharacterStream).%New()
	Set objStream=##class(DHCENS.BaseCode.AddOrderItem).AddOrderItem(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><AddOrderItemReturn><ResultCode>-1</ResultCode><ResultContent>Interface中AddOrderItem方法异常</ResultContent></AddOrderItemReturn></Response>")
    Quit objStream
}

/// 返回检查报告结果
ClassMethod ReturnReports(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("ReturnReport","DHCENS.BC.Model.ReturnReportsRt")	

	Set Rowid="",StudyNo="",GetDoc="",ReportStatus="",UnsendCause=""
	Set ReportDoc="",AuditDoc="",ReportDate="",AuditDate=""
	Set ReportTime="",AuditTime="",Memo=""
	Set ImageFile="",HisArchiveTag="",EyeSee="",ExamSee="",Diagnose=""
	While reader.Next(.obj,.sc) {
		
	    Set Rowid=obj.Rowid
	    Set StudyNo=obj.StudyNo
	    Set GetDoc=obj.GetDoc
	    Set ReportStatus=obj.ReportStatus
	    
	    Set UnsendCause=obj.UnsendCause
	    Set ReportDoc=obj.ReportDoc
	    Set AuditDoc=obj.AuditDoc
	    
	    Set ReportDate=obj.ReportDate
	    Set AuditDate=obj.AuditDate
	    Set ReportTime=obj.ReportTime
	    
	    Set AuditTime=obj.AuditTime
	    Set Memo=obj.Memo
	    Set ImageFile=obj.ImageFile
	    
	    Set HisArchiveTag=obj.HisArchiveTag
	    Set EyeSee=obj.EyeSee
	    Set ExamSee=obj.ExamSee
	    Set Diagnose=obj.Diagnose

	}

	Set tmpInput=Rowid_"^"_StudyNo_"^"_GetDoc_"^"_ReportStatus
	Set tmpInput=tmpInput_"^"_UnsendCause_"^"_ReportDoc_"^"_AuditDoc
		

	Set tmpInput=tmpInput_"^"_ReportDate_"^"_AuditDate_"^"_ReportTime
	
	Set tmpInput=tmpInput_"^"_AuditTime_"^"_Memo_"^"_ImageFile
	
	Set tmpInput=tmpInput_"^"_HisArchiveTag
	
	Set tmpInput=tmpInput_"/"_EyeSee_"/"_ExamSee_"/"_Diagnose
	Set tmpInput=$tr(tmpInput,$c(0),"")
	
	Set objStream=##class(%GlobalCharacterStream).%New()
	Set objStream=##class(DHCENS.BC.ReturnReports).ReturnReports(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><ReturnReportsReturn><ResultCode>-1</ResultCode><ResultContent>Interface中ReturnReports方法异常</ResultContent></ReturnReportsReturn></Response>")
    Quit objStream
}

/// 改变医嘱状态
ClassMethod ModifyStatus(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("Request","DHCENS.BC.Model.ModifyStatusRt")
	s tmpInput=""
	While reader.Next(.obj,.sc) {
		s Len=obj.ModifyStatuses.Count()
		f i=1:1:Len
		{
			s objModifyStatus=obj.ModifyStatuses.GetAt(i)
			
			if (tmpInput="")
			{
				s tmpInput=objModifyStatus.Rowid_"/"_objModifyStatus.Status_"/"_objModifyStatus.ExeUser
			}
			else
			{
				s tmpInput=tmpInput_"^"_objModifyStatus.Rowid_"/"_objModifyStatus.Status_"/"_objModifyStatus.ExeUser
			}
		}
	}
	Set tmpInput=$tr(tmpInput,$c(0),"")
	
	Set objStream=##class(%GlobalCharacterStream).%New()
	Set objStream=##class(DHCENS.BC.ModifyStatus).ModifyStatus(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><ModifyStatusReturn><ResultCode>-1</ResultCode><ResultContent>Interface中ModifyStatus方法异常</ResultContent></ModifyStatusReturn></Response>")
    Quit objStream
}

/// 退费申请
ClassMethod CancelFeeApp(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("Request","DHCENS.BC.Model.CancelFeeAppRt")
	s tmpInput=""
	While reader.Next(.obj,.sc) {
		s Len=obj.CancelFeeApps.Count()
		f i=1:1:Len
		{
			s objCancelFeeApp=obj.CancelFeeApps.GetAt(i)
			
			if (tmpInput="")
			{
				s tmpInput=objCancelFeeApp.Rowid_"/"_objCancelFeeApp.Status_"/"_objCancelFeeApp.ExeUser
			}
			else
			{
				s tmpInput=tmpInput_"^"_objCancelFeeApp.Rowid_"/"_objCancelFeeApp.Status_"/"_objCancelFeeApp.ExeUser
			}
		}
	}
	Set tmpInput=$tr(tmpInput,$c(0),"")
	
	Set objStream=##class(%GlobalCharacterStream).%New()
	Set objStream=##class(DHCENS.BC.CancelFeeApp).CancelFeeApp(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><CancelFeeAppReturn><ResultCode>-1</ResultCode><ResultContent>Interface中CancelFeeApp方法异常</ResultContent></CancelFeeAppReturn></Response>")
    Quit objStream
}

/// 取消报告审核
ClassMethod CancelReport(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("CancelReport","DHCENS.BC.Model.CancelReportRt")
	s tmpInput=""
	While reader.Next(.obj,.sc) {
	    Set Rowid=obj.Rowid
	    Set StudyNo=obj.StudyNo
	    Set CancelDoc=obj.CancelDoc
        Set CancelDate=obj.CancelDate
        Set CancelTime=obj.CancelTime
	}
	Set tmpInput=Rowid_"^"_StudyNo_"^"_CancelDoc_"^"_CancelDate_"^"_CancelTime
	Set tmpInput=$tr(tmpInput,$c(0),"")
	
	Set objStream=##class(%GlobalCharacterStream).%New()
	Set objStream=##class(DHCENS.BC.CancelReport).CancelReport(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><CancelReportReturn><ResultCode>-1</ResultCode><ResultContent>Interface中CancelReport方法异常</ResultContent></CancelReportReturn></Response>")
    Quit objStream
}

/// 获取申请单
ClassMethod GetAppForm(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("GetAppForm","DHCENS.BC.Model.GetAppFormRt")
	Set Rowid=""
	
	While reader.Next(.obj,.sc) {
		Set Rowid=obj.Rowid
	}
	Set tmpInput=Rowid
	Set tmpInput=$tr(tmpInput,$c(0),"")
	
    Set objStream=##class(%GlobalCharacterStream).%New()
	Set objStream=##class(DHCENS.BC.GetAppForm).GetAppForm(tmpInput)
	
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><GetAppFormReturn><ResultCode>-1</ResultCode><ResultContent>Interface中GetAppForm方法异常</ResultContent></GetAppFormReturn></Response>")
    Quit objStream
}

Storage Default
{
<Data name="InterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCENS.BC.Method.InterfaceD</DataLocation>
<DefaultData>InterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCENS.BC.Method.InterfaceD</IdLocation>
<IndexLocation>^DHCENS.BC.Method.InterfaceI</IndexLocation>
<StreamLocation>^DHCENS.BC.Method.InterfaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

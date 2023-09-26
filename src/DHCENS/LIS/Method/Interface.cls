Class DHCENS.LIS.Method.Interface Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

/// 得到字典信息
ClassMethod GetDictInfo(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("GetDictInfo","DHCENS.LIS.Model.GetDictInfoRt")
	Set DicCat=""
	While reader.Next(.obj,.sc) 
	{
		Set DicCat=obj.DicCat
	}
	Set tmpInput=DicCat
	Set tmpInput=$tr(tmpInput,$c(0),"")

	Set objStream=##class(%GlobalCharacterStream).%New()
	s objStream=##class(DHCENS.BaseCode.GetDictInfo).GetDictInfo(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><GetDictInfoReturn><ResultCode>-1</ResultCode><ResultContent>Interface中GetDictInfo方法异常</ResultContent></GetDictInfoReturn></Response>")
    Quit objStream
}

/// 由卡号或病人唯一号(注:东华称登记号)查出患者基本信息，
/// 当卡号不空时用卡号，卡号为空时用病人唯一号。
ClassMethod GetPatInfo(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("GetPatInfo","DHCENS.LIS.Model.GetPatInfoRt")
	Set CardType="",CardNo="",PatientNo=""
	While reader.Next(.obj,.sc) {
		Set CardNo=$tr(obj.CardNo,$char(0),"")
		Set PatientNo=$tr(obj.RegisterNo,$char(0),"")
	}

	Set objStream=##class(%GlobalCharacterStream).%New()
	s objStream=##Class(DHCENS.LIS.GetPatInfo).GetByCardNoAndPatientNo(CardType,CardNo,PatientNo)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><GetPatInfoReturn><ResultCode>-1</ResultCode><ResultContent>Interface中GetPatInfo方法异常</ResultContent></GetPatInfoReturn></Response>")
    Quit objStream
}

ClassMethod GetLabOrderList(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("GetLabOrderList","DHCENS.LIS.Model.GetLabOrderListRt")
	
	Set CardNo="",RegisterNo="",RegisterNo="",EndDate="",EpsiodeType="",OrderStatus="",OrderDept=""	
	While reader.Next(.obj,.sc) {
		set CardNo=$tr(obj.CardNo,$char(0),"")
		Set RegisterNo=$tr(obj.RegisterNo,$char(0),"")
		Set StartDate=$tr(obj.StartDate,$char(0),"")
		Set EndDate=$tr(obj.EndDate,$char(0),"")
		Set EpsiodeType=$tr(obj.EpsiodeType,$char(0),"")
		Set OrderStatus=$tr(obj.OrderStatus,$char(0),"")
		Set OrderDept=$tr(obj.OrderDept,$char(0),"")
	}
	
	Set objStream=##class(%GlobalCharacterStream).%New()
	s objStream=##class(DHCENS.LIS.GetLabOrderList).GetLabOrderList(CardNo,RegisterNo,StartDate,EndDate,EpsiodeType,OrderStatus,OrderDept)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><GetLabOrderListReturn><ResultCode>-1</ResultCode><ResultContent>Interface中GetLabOrderList方法异常</ResultContent></GetLabOrderListReturn></Response>")
    Quit objStream
}

ClassMethod ModifyStatus(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("Request","DHCENS.LIS.Model.ModifyStatusRt")
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
	s objStream=##class(DHCENS.LIS.ModifyStatus).ModifyStatus(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><ModifyStatusReturn><ResultCode>-1</ResultCode><ResultContent>Interface中ModifyStatus方法异常</ResultContent></ModifyStatusReturn></Response>")
    Quit objStream
}

/// 申请退费
ClassMethod CancelFeeApp(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("Request","DHCENS.LIS.Model.CancelFeeAppRt")
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
	s objStream=##class(DHCENS.LIS.CancelFeeApp).CancelFeeApp(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><CancelFeeAppReturn><ResultCode>-1</ResultCode><ResultContent>Interface中CancelFeeApp方法异常</ResultContent></CancelFeeAppReturn></Response>")
    Quit objStream
}

/// 得到医嘱状态
ClassMethod GetOrderStatus(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("GetOrderStatus","DHCENS.LIS.Model.GetOrderStatusRt")
	
	Set Rowid=""
	While reader.Next(.obj,.sc) {		
		Set Rowid=$tr(obj.Rowid,$char(0),"")
	}
	Set objStream=##class(%GlobalCharacterStream).%New()
	s objStream=##class(DHCENS.LIS.GetOrderStatus).GetOrderStatusXml(Rowid)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><GetOrderStatusReturn><ResultCode>-1</ResultCode><ResultContent>Interface中GetOrderStatus方法异常</ResultContent></GetOrderStatusReturn></Response>")
    Quit objStream
}

/// HIS收费前将检验医嘱发送给Lis由Lis返回计算的管子数量
ClassMethod LabOrderInfo(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	
	s objStream=##class(%GlobalCharacterStream).%New()
	d objStream.Write("<Response><LabOrderInfoReturn><ResultCode>0</ResultCode><Amount>1</Amount></LabOrderInfoReturn></Response>")
	
	
	q objStream
}

/// 报告信息ReportMsg:（医嘱号）（检验号）,接收者代码@接收者名称,接收时间,录入者代码@录入者名称,录入时间,审核者代码@审核者名称,审核时间,报告备注,危急报告说明
/// 结果信息ResultMsg:检验号,项目代码,项目名称,缩写,结果,单位,备注,结果标示,参考范围,顺序,微生物标志,微生物名称_$c(28)....
/// 药敏结果OrgResultMsg:细菌代码,抗生素代码,抗生素名称,抗生素缩写,MIC结果,KB结果,药敏结果,MIC判定范围,KB判定范围,显示顺序_$c(28)....
ClassMethod ReportMsg(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	
	s ReportMsg="",ResultMsg="",OrgResultMsg=""
	
	s reader1 = ##class(%XML.Reader).%New()
	s sc1=reader1.OpenStream(Input)
	d reader1.Correlate("ReportMsg","DHCENS.LIS.Model.ReportMsg")
    b ;1
	while reader1.Next(.objReportMsg,.sc)
	{		
	
			b ;2	
			s ReportMsg=objReportMsg.OrdID_"^"_objReportMsg.RecUser_"^"_objReportMsg.RecDate_" "_objReportMsg.RecTime
			s ReportMsg=ReportMsg_"^"_objReportMsg.EntryUser_"^"_objReportMsg.EntryDate_" "_objReportMsg.EntryTime
			s ReportMsg=ReportMsg_"^"_objReportMsg.AuthUser_"^"_objReportMsg.AuthDate_" "_objReportMsg.AuthTime
			s ReportMsg=ReportMsg_"^"_objReportMsg.Notes_"^"_objReportMsg.ImageFile_"^"_objReportMsg.MainWarnDesc
						
			s ResultMsgsLen=objReportMsg.ResultMsgs.Count()
			f j=1:1:ResultMsgsLen
			{
				s objResultMsg=objReportMsg.ResultMsgs.GetAt(j)
				if (ResultMsg="")
				{   
				    ;对检验号objResultMsg.Labno不作接收
					s ResultMsg=objResultMsg.TestCode_"^"_objResultMsg.TestName
	                s ResultMsg=ResultMsg_"^"_objResultMsg.TestEngName_"^"_objResultMsg.Result_"^"_objResultMsg.Units
					s ResultMsg=ResultMsg_"^"_objResultMsg.Notes_"^"_objResultMsg.ResultFlag_"^"_objResultMsg.Ranges
					s ResultMsg=ResultMsg_"^"_objResultMsg.Sequence_"^"_objResultMsg.MICFlag_"^"_objResultMsg.MICName
					s ResultMsg=ResultMsg_"^"_objResultMsg.WarnDesc
				}
                else{	                
	                s ResultMsg=ResultMsg_"~"_objResultMsg.TestCode_"^"_objResultMsg.TestName
	                s ResultMsg=ResultMsg_"^"_objResultMsg.TestEngName_"^"_objResultMsg.Result_"^"_objResultMsg.Units
					s ResultMsg=ResultMsg_"^"_objResultMsg.Notes_"^"_objResultMsg.ResultFlag_"^"_objResultMsg.Ranges
					s ResultMsg=ResultMsg_"^"_objResultMsg.Sequence_"^"_objResultMsg.MICFlag_"^"_objResultMsg.MICName
					s ResultMsg=ResultMsg_"^"_objResultMsg.WarnDesc	                
                }
				s OrgResultMsgsLen=objResultMsg.OrgResultMsgs.Count()
				f k=1:1:OrgResultMsgsLen
				{
					s objOrgResultMsgs=objResultMsg.OrgResultMsgs.GetAt(k)
					if (OrgResultMsg="")
					{
						s OrgResultMsg=k_"^"_objOrgResultMsgs.BugsCode_"^"_objOrgResultMsgs.AntiCode
						s OrgResultMsg=OrgResultMsg_"^"_objOrgResultMsgs.AntiName_"^"_objOrgResultMsgs.AntiEngName
						s OrgResultMsg=OrgResultMsg_"^"_objOrgResultMsgs.MICRes_"^"_objOrgResultMsgs.KBRes
						s OrgResultMsg=OrgResultMsg_"^"_objOrgResultMsgs.Result_"^"_objOrgResultMsgs.MICRanges
						s OrgResultMsg=OrgResultMsg_"^"_objOrgResultMsgs.KBRanges_"^"_objOrgResultMsgs.Order
					}
					else
					{
						s OrgResultMsg=OrgResultMsg_"~"_k_"^"_objOrgResultMsgs.BugsCode_"^"_objOrgResultMsgs.AntiCode
						s OrgResultMsg=OrgResultMsg_"^"_objOrgResultMsgs.AntiName_"^"_objOrgResultMsgs.AntiEngName
						s OrgResultMsg=OrgResultMsg_"^"_objOrgResultMsgs.MICRes_"^"_objOrgResultMsgs.KBRes
						s OrgResultMsg=OrgResultMsg_"^"_objOrgResultMsgs.Result_"^"_objOrgResultMsgs.MICRanges
						s OrgResultMsg=OrgResultMsg_"^"_objOrgResultMsgs.KBRanges_"^"_objOrgResultMsgs.Order
					}
				}
			}
	}
	
	Set tmpInput=ReportMsg_"###"_ResultMsg_"###"_OrgResultMsg
	Set tmpInput=$tr(tmpInput,$c(0),"")
    Set objStream=##class(%GlobalCharacterStream).%New()
	Set objStream=##class(DHCENS.LIS.ReportMsg).ReportMsg(tmpInput)
	;d objStream.OutputToDevice()
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><ReportMsgReturn><ResultCode>-1</ResultCode><ResultContent>Interface中ReportMsg方法异常</ResultContent></ReportMsgReturn></Response>")
    Quit objStream
}

/// 得到检验医嘱信息
ClassMethod GetLabOrder(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("GetLabOrder","DHCENS.LIS.Model.GetLabOrderRt")
	Set LabNo=""
	While reader.Next(.obj,.sc) {	
		Set LabNo=$tr(obj.LabNo,$char(0),"")
	}
	Set objStream=##class(%GlobalCharacterStream).%New()
	Set objStream=##class(DHCENS.LIS.GetLabOrder).GetLabOrder(LabNo)
	;d objStream.OutputToDevice()
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><GetLabOrderReturn><ResultCode>-1</ResultCode><ResultContent>Interface中GetLabOrder方法异常</ResultContent></GetLabOrderReturn></Response>")
    Quit objStream
}

/// 标本接收
ClassMethod CheckUp(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("Request","DHCENS.LIS.Model.CheckUpRt")
	Set tmpInput=""
	While reader.Next(.obj,.sc) {
		s CheckUpLen=obj.CheckUps.Count()
		for i=1:1:CheckUpLen
		{
			s objCheckUp=obj.CheckUps.GetAt(i)
			if (tmpInput="")
			{
				set tmpInput=objCheckUp.LabNo_"^"_objCheckUp.Rowid_"^"_objCheckUp.BilledFlag_"^"_objCheckUp.ExeUser_"^"_objCheckUp.AcceptDate_"^"_objCheckUp.AcceptTime
			}
			else
			{
			    set tmpInput=tmpInput_"/"_objCheckUp.LabNo_"^"_objCheckUp.Rowid_"^"_objCheckUp.BilledFlag_"^"_objCheckUp.ExeUser_"^"_objCheckUp.AcceptDate_"^"_objCheckUp.AcceptTime	
			}
		}
	}
	Set tmpInput=$tr(tmpInput,$c(0),"")
	Set objStream=##class(%GlobalCharacterStream).%New()
	s objStream=##class(DHCENS.LIS.CheckUp).CheckUp(tmpInput)
	;d objStream.OutputToDevice()
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><CheckUpReturn><ResultCode>-1</ResultCode><ResultContent>Interface中CheckUp方法异常</ResultContent></CheckUpReturn></Response>")
    Quit objStream
}

/// 标本拒绝
ClassMethod Refuse(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("Request","DHCENS.LIS.Model.RefuseRt")
	Set tmpInput=""
	While reader.Next(.obj,.sc) {
		s RefuseLen=obj.Refuses.Count()
		for i=1:1:RefuseLen
		{
			s objRefuse=obj.Refuses.GetAt(i)
			if (tmpInput="")
			{
				set tmpInput=objRefuse.LabNo_"^"_objRefuse.Rowid_"^"_objRefuse.RefuseReason_"^"_objRefuse.ExeUser
			}
			else
			{
			    set tmpInput=tmpInput_"/"_objRefuse.LabNo_"^"_objRefuse.Rowid_"^"_objRefuse.RefuseReason_"^"_objRefuse.ExeUser
			}
		
		}
	}
	Set tmpInput=$tr(tmpInput,$c(0),"")
	Set objStream=##class(%GlobalCharacterStream).%New()
	s objStream=##class(DHCENS.LIS.Refuse).Refuse(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><RefuseReturn><ResultCode>-1</ResultCode><ResultContent>Interface中Refuse方法异常</ResultContent></RefuseReturn></Response>")
    Quit objStream
}

/// 增加医嘱
ClassMethod AddOrderItem(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("AddOrderItem","DHCENS.LIS.Model.AddOrderItemRt")
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
	s objStream=##class(DHCENS.BaseCode.AddOrderItem).AddOrderItem(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><AddOrderItemReturn><ResultCode>-1</ResultCode><ResultContent>Interface中AddOrderItem方法异常</ResultContent></AddOrderItemReturn></Response>")
    Quit objStream
}

/// 得到检验医嘱试管数量
ClassMethod GetAmountOfTube(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "SendMessageET"
	Do Input.Rewind()
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(Input)
	Do reader.Correlate("GetAmountOfTube","DHCENS.LIS.Model.GetAmountOfTubeRt")
	Set Rowids=""
	While reader.Next(.obj,.sc) 
	{
		Set Rowids=obj.Rowids
	}
	Set tmpInput=Rowids
	Set tmpInput=$tr(tmpInput,$c(0),"")

	Set objStream=##class(%GlobalCharacterStream).%New()
	s objStream=##class(DHCENS.LIS.GetAmountOfTube).GetAmountOfTube(tmpInput)
	Quit objStream
SendMessageET
    Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Write("<Response><GetAmountOfTubeReturn><ResultCode>-1</ResultCode><ResultContent>Interface中GetAmountOfTube方法异常</ResultContent></GetAmountOfTubeReturn></Response>")
    Quit objStream
}

/// w ##class(DHCENS.LIS.Method.Interface).Test("")
ClassMethod Test(Input As %String) As %String
{
	s objStream=##class(%GlobalCharacterStream).%New()
	;d objStream.Write("<Request><GetLabOrder><LabNo>1000000212</LabNo></GetLabOrder></Request>")
	;d objStream.Write("<Request><CheckUps><CheckUp><LabNo>17</LabNo><Rowid>50_3</Rowid><ExeUser>demo@系统管理员</ExeUser><AcceptDate>2010-08-30</AcceptDate><AcceptTime>10:58:01</AcceptTime></CheckUp></CheckUps></Request>")
	;d objStream.Write("<Request><GetLabOrder><LabNo>17</LabNo></GetLabOrder></Request>")
	d objStream.Write("<Request><ReportMsg><OrdID>112_3</OrdID><ReportID>100829LA0003</ReportID><ReportUrl>201008</ReportUrl><RecUser>demo@系统管理员</RecUser><RecDate>2010-08-29</RecDate><RecTime>09:32:57</RecTime><EntryUser>demo@系统管理员</EntryUser><EntryDate>2010-08-29</EntryDate><EntryTime>11:07:01</EntryTime><AuthUser>demo@系统管理员</AuthUser><AuthDate>2010-08-29</AuthDate><AuthTime>11:07:35</AuthTime><Notes></Notes><ImageFile></ImageFile><MainWarnDesc>W@危机</MainWarnDesc><ResultMsgs><ResultMsg><LabNo>17</LabNo><TestCode>A205</TestCode><TestName>红细胞分布宽度</TestName><TestEngName>RDW</TestEngName><Result>18.00</Result><Units>%</Units><Notes></Notes><ResultFlag>H</ResultFlag><Ranges>10.9-15.7</Ranges><Sequence>018</Sequence><MICFlag>N</MICFlag><MICName></MICName><WarnDesc>W@FFFF</WarnDesc><OrgResultMsgs><OrgResultMsg><BugsCode></BugsCode><AntiCode></AntiCode><AntiName></AntiName><AntiEngName></AntiEngName><MICRes></MICRes><KBRes></KBRes><Result></Result><MICRanges></MICRanges><Order></Order></OrgResultMsg></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>17</LabNo><TestCode>A201</TestCode><TestName>白细胞</TestName><TestEngName>WBC</TestEngName><Result>1.00</Result><Units>G/L</Units><Notes></Notes><ResultFlag>L</ResultFlag><Ranges>4-10</Ranges><Sequence>001</Sequence><MICFlag>N</MICFlag><MICName></MICName><WarnDesc></WarnDesc><OrgResultMsgs><OrgResultMsg><BugsCode></BugsCode><AntiCode></AntiCode><AntiName></AntiName><AntiEngName></AntiEngName><MICRes></MICRes><KBRes></KBRes><Result></Result><MICRanges></MICRanges><Order></Order></OrgResultMsg></OrgResultMsgs></ResultMsg></ResultMsgs></ReportMsg></Request>")
	
	
	;d objStream.Write("<Request><ReportMsg><OrdID>112_20</OrdID><ReportID>100831LA0027</ReportID><ReportUrl>201008</ReportUrl><RecUser>demo@系统管理员</RecUser><RecDate>2010-08-31</RecDate><RecTime>17:54:51</RecTime><EntryUser>demo@系统管理员</EntryUser><EntryDate>2010-08-31</EntryDate><EntryTime>17:55:13</EntryTime><AuthUser>demo@系统管理员</AuthUser><AuthDate>2010-08-31</AuthDate><AuthTime>18:12:23</AuthTime><Notes></Notes><ImageFile></ImageFile><MainWarnDesc></MainWarnDesc><ResultMsgs><ResultMsg><LabNo>47</LabNo><TestCode></TestCode><TestName>超敏C反应蛋白</TestName><TestEngName>CRP</TestEngName><Result>43.00</Result><Units>mg/L</Units><Notes></Notes><ResultFlag>H</ResultFlag><Ranges>0-8</Ranges><Sequence>B03</Sequence><MICFlag>N</MICFlag><MICName></MICName><WarnDesc></WarnDesc><OrgResultMsgs><OrgResultMsg><BugsCode></BugsCode><AntiCode></AntiCode><AntiName></AntiName><AntiEngName></AntiEngName><MICRes></MICRes><KBRes></KBRes><Result></Result><MICRanges></MICRanges><Order></Order></OrgResultMsg></OrgResultMsgs></ResultMsg></ResultMsgs></ReportMsg></Request>")
	
	d ..ReportMsg(objStream)
	;<OrgResultMsgs><OrgResultMsg><BugsCode></BugsCode><AntiCode></AntiCode><AntiName></AntiName><AntiEngName></AntiEngName><MICRes></MICRes><KBRes></KBRes><Result></Result><MICRanges></MICRanges><Order></Order></OrgResultMsg></OrgResultMsgs>
	q "ok"
}

Storage Default
{
<Data name="InterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCENS.LIS.Method.InterfaceD</DataLocation>
<DefaultData>InterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCENS.LIS.Method.InterfaceD</IdLocation>
<IndexLocation>^DHCENS.LIS.Method.InterfaceI</IndexLocation>
<StreamLocation>^DHCENS.LIS.Method.InterfaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

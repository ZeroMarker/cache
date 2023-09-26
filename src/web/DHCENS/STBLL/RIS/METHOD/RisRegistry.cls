Class web.DHCENS.STBLL.RIS.METHOD.RisRegistry Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description:W00000131 检查登记
/// Debug:w ##class(web.DHCENS.STBLL.RIS.METHOD.RisRegistry).RisRegistry(入参字符流)
ClassMethod RisRegistry(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	ts
	set suCount=0,faCount=0,faInfo="",OrdFlag="",ErrorOrd="",NoneErr="",BillResult=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	set Response=##class(web.DHCENS.STBLL.RIS.MODEL.ResponseInfo).%New()
	set header=##class(web.DHCENS.STBLL.RIS.MODEL.ResponseHeader).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.RIS.MODEL.ResponseBody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set SourceSystemHer=""
		set tSC=tDocument.EvaluateExpression("/Request/Header/SourceSystem","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SourceSystemHer=$tr(fieldValue,$c(0),"")
		}
		set RISRExamID=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/RisRegistryRt/RISRExamID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISRExamID=$tr(fieldValue,$c(0),"")
			set RISRExamID=##class(web.DHCENS.Util.Common).ReplaceStr(RISRExamID,"||","-")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RisRegistryRt/OEORIOrderItemIDList","count(OEORIOrderItemID)",.tRes)
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			if hsCount="0" {
				set responseBody.ResultCode="-1"
		        set responseBody.ResultContent="-1^医嘱信息为空"
		        set Response.Respbody=responseBody
		        d Response.XMLExportToStream(.stream)
	            Quit stream	
			}
			set OrdRowIds=""
			for i=1:1:hsCount {
				set (OEORROrderItemID,UpdateUserCode,UpdateUserDesc,UpdateDate,UpdateTime)=""
				set tSC=tDocument.EvaluateExpression("/Request/Body/RisRegistryRt/OEORIOrderItemIDList/OEORIOrderItemID["_i_"]","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORROrderItemID=$tr(fieldValue,$c(0),"")
					set OEORROrderItemID=$p(OEORROrderItemID,"||",1,2)					
					if OrdRowIds'=""{
						set OrdRowIds=OrdRowIds_"^"_OEORROrderItemID
					}
					else {
							set OrdRowIds=OEORROrderItemID
					}
				}
			}
	
			set tSC=tDocument.EvaluateExpression("/Request/Body/RisRegistryRt/UpdateDate","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set UpdateDate=$tr(fieldValue,$c(0),"")
			}

			set tSC=tDocument.EvaluateExpression("/Request/Body/RisRegistryRt/UpdateTime","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set UpdateTime=$tr(fieldValue,$c(0),"")
			}
			
			set tSC=tDocument.EvaluateExpression("/Request/Body/RisRegistryRt/UpdateUserCode","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set UpdateUserCode=$tr(fieldValue,$c(0),"")
				set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UpdateUserCode),""))
				set:ExeUserID'="" UpdateUserDesc=$p($g(^SSU("SSUSR",ExeUserID)),"^",2)
			}
			
			set OrdRowIdsCount=$l(OrdRowIds,"^")
			for iOrd=1:1:OrdRowIdsCount
			{
				set OEORROrderItemID=$p(OrdRowIds,"^",iOrd)
				set tmpInput=OEORROrderItemID_"^"_RISRExamID_"^^"_UpdateUserCode_"@"_UpdateUserDesc_"^"_UpdateDate_"^"_UpdateTime
				;set Result=..InsertResultStatus(tmpInput,"SC") ;不再调用 20190731
				set AdmNo=$p(^OEORD(+OEORROrderItemID),"^",1)
				set AdmType=$p($g(^PAADM(AdmNo)),"^",2)
			    set OrdBillStatus=$p($g(^OEORD(+OEORROrderItemID,"I",$p(OEORROrderItemID,"||",2),3)),"^",5)
				set BillResult="0^成功^计费状态没问题"
				if ((AdmType'="I")&&(OrdBillStatus'="P")) set BillResult="-1^就诊状态为："_AdmType_"，计费状态为："_OrdBillStatus_"，医嘱号为："_OEORROrderItemID_"不允许登记"
				if ExeUserID=""
				{
					s NoneErr="人员代码在系统不存在!"
				}
				if ($p(BillResult,"^",1)=0)
				{
					set Result=##class(appcom.OEOrdItem).Execute(OEORROrderItemID,ExeUserID) ; 修改医嘱状态
					// 更新检查状态20190621
					set UpdateDateTime=UpdateDate_" "_UpdateTime
					set Position=""
					set Status="SC"
					set SourceSystem=##Class(web.DHCENS.STBLL.RIS.METHOD.Common).GetSystemType(OEORROrderItemID) ; 调用pacs组方法取系统编码
					IF SourceSystem=""
					{
						SET:SourceSystemHer="SYS0004" SourceSystem="PIS"
					}
					set jsonstr="[{""OEOrdItemID"":"""_OEORROrderItemID_""","_"""Position"":"""_Position_""","_"""ExamID"":"""_RISRExamID_""","_"""Status"":"""_Status_""","_"""UserID"":"""_UpdateUserCode_""","_"""UserName"":"""_UpdateUserDesc_""","_"""UpDateTime"":"""_UpdateDateTime_""","_"""SourceSystem"":"""_SourceSystem_""""_"}]"
					set jsonStream=##class(%GlobalCharacterStream).%New()
					d jsonStream.Write(jsonstr)
					set tSC=##class(%GlobalCharacterStream).%New()
					set tSC=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
					set tSCStr=tSC.Read()
					
					if (tSCStr'["成功")||(Result'=0)
					{
						set OrdFlag="-1"
						if ErrorOrd=""  set ErrorOrd=OEORROrderItemID_":"_"医生站组方法返回—"_Result_" ^计费状态返回—"_BillResult_" ^医嘱闭环返回—"_tSCStr_"执行、登记"
						else  set ErrorOrd=ErrorOrd_"^"_OEORROrderItemID_":"_"医生站组方法返回—"_Result_" ^计费状态返回—"_BillResult_" ^医嘱闭环返回—"_tSCStr_"执行、登记"
						q
					}
					else{
						set OrdFlag="0"
					}
				}
			}
		} //for
	} //if
	if OrdFlag="0"
	{
		tc
		set responseBody.ResultCode="0"
		set responseBody.ResultContent="成功"
	}
	elseif (OrdFlag'="0")&&(OrdFlag'="")
	{	
		tro
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=ErrorOrd_"医嘱接收处理有错误"_","_NoneErr
	}
	else
	{
		tro
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=BillResult_","_NoneErr
	}
	set Response.Respbody=responseBody
	d Response.XMLExportToStream(.stream)
	Quit stream
Exception
	if $TLEVEL>0
	{
	 	tro	
	}
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Response><Header><SourceSystem>SYS0001</SourceSystem><MessageID>5</MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>-1^"_$ze_"></ResultContent></Body></Response>")
	Quit stream
}

/// Debug:w ##class(web.DHCENS.STBLL.RIS.METHOD.RisRegistry).test("")
ClassMethod test(tmpStr As %String) As %String
{
	set stream=##class(%GlobalCharacterStream).%New()
	s xml="<Request><Header><SourceSystem>SYS0002</SourceSystem><MessageID></MessageID></Header><Body><RisRegistryRt><HospitalCode></HospitalCode><BusinessFieldCode>00002</BusinessFieldCode><PATPatientID>0000000013</PATPatientID><PAADMVisitNumber>34</PAADMVisitNumber><RISRExamID>APP23456</RISRExamID><OEORIOrderItemIDList><OEORIOrderItemID>26||7</OEORIOrderItemID><OEORIOrderItemID>26||8</OEORIOrderItemID></OEORIOrderItemIDList><UpdateUserCode>admin</UpdateUserCode><UpdateDate>2019-07-12</UpdateDate><UpdateTime>13:45:51</UpdateTime></RisRegistryRt></Body></Request>"
	do stream.Write(xml)
	s rtn=..RisRegistry(stream)
	q rtn
}

ClassMethod InsertResultStatus(tmpStr As %String, ResultFlag As %String) As %String
{
	s $ZTrap = "SendMessageET"
	s OrdRowID=$p(tmpStr,"^",1)
	s StudyNo=$p(tmpStr,"^",2)
	s PicturePath=$p(tmpStr,"^",3)
	s OperatorCode=$p($p(tmpStr,"^",4),"@",1)
	s Operator=$p($p(tmpStr,"^",4),"@",2)
	s CheckUpDate=$p(tmpStr,"^",5)
	s CheckUpTime=$p(tmpStr,"^",6)
	s:CheckUpDate="" CheckUpDate=$zd(+$h,3)
	s:CheckUpTime="" CheckUpTime=$zt($p($h,",",2),1)
    i Operator="" 
    {
        set Result= "-1^操作人员不能为空"
        q Result
    }
    s OrdStatus=""
	//改变医嘱Rowid为RIS接受的形式
	s RisRowid=..ReplaceStr(OrdRowID,"||","_")
	//判断医嘱是否已经停止,停止则退出
	s ItemStatDr=$p($g(^OEORD(+RisRowid,"I",$p(RisRowid,"_",2),1)),"^",13)
	s:ItemStatDr'="" OrdStatus=$p($g(^OEC("OSTAT",ItemStatDr)),"^",1)
	i ((OrdStatus="D")||(OrdStatus="U")||(OrdStatus="C"))
	{
		s Result="-1^医嘱号"_RisRowid_"已经停止！"
		q Result
	}
	
	//查询操作人信息，不存在Code默认是daijia，名称必须存在        
    if OperatorCode=""
    {
    	s OperatorAll = "pacs"_"@"_Operator
    }
    else
    {
    	s OperatorAll = OperatorCode_"@"_Operator
    }
    
	// RIS中参数格式：Info=医嘱ID^资源^更改日期^更改时间^操作员^注意事项^其他信息^检查号^检查状态^是否执行医嘱
	s tmpStr=RisRowid_"^^"_CheckUpDate_"^"_CheckUpTime_"^"_OperatorAll_"^^^"_StudyNo_"^"_ResultFlag_"^Y"
	s Result=##class(RISService.TrakRISService).SetExamStatusInfo(tmpStr)
	if (Result=0)||(Result=-209)
	{
		s Result="0^成功"
	}
	else
	{
		s Result="-1^更新医嘱表状态失败"	
	}
	Quit Result
SendMessageET
    Quit "-1^"_$ze
}

/// 字符串替换 
ClassMethod ReplaceStr(inStr As %String, idStr As %String, ass As %String) As %String(MAXLEN=32767)
{
	s retStr=""
	s len=$l(inStr,idStr)
	f i=1:1:len
	{
		i i'=len d
		.s retStr=retStr_$p(inStr,idStr,i)_ass
		e  d
		.s retStr=retStr_$p(inStr,idStr,i)
	}
	q retStr
}

}

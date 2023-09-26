Class web.DHCENS.STBLL.RIS.METHOD.RisImageCancel Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description:W00000133 取消图像
/// Debug:w ##class(web.DHCENS.STBLL.RIS.METHOD.RisImageCancel).RisImageCancel()
ClassMethod RisImageCancel(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	ts
	set suCount=0,faCount=0,faInfo=""
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
		set tSC=tDocument.EvaluateExpression("/Request/Body/RisImageCancelRt/RISRExamID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISRExamID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RisImageCancelRt/OEORIOrderItemIDList","count(OEORIOrderItemID)",.tRes)
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
				set tSC=tDocument.EvaluateExpression("/Request/Body/RisImageCancelRt/OEORIOrderItemIDList/OEORIOrderItemID["_i_"]","text()",.tRes)					
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
			set tSC=tDocument.EvaluateExpression("/Request/Body/RisImageCancelRt/UpdateDate","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set UpdateDate=$tr(fieldValue,$c(0),"")
			}

			set tSC=tDocument.EvaluateExpression("/Request/Body/RisImageCancelRt/UpdateTime","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set UpdateTime=$tr(fieldValue,$c(0),"")
			}
			
			set tSC=tDocument.EvaluateExpression("/Request/Body/RisImageCancelRt/UpdateUserCode","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set UpdateUserCode=$tr(fieldValue,$c(0),"")
				set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UpdateUserCode),""))
				set:ExeUserID'="" UpdateUserDesc=$p($g(^SSU("SSUSR",ExeUserID)),"^",2)
			}
			
			set OrdRowIdsCount=$l(OrdRowIds,"^")
			set OrdFlag="",ErrorOrd=""
		
			for iOrd=1:1:OrdRowIdsCount
			{
				set OEORROrderItemID=$p(OrdRowIds,"^",iOrd)
				set tmpInput=OEORROrderItemID_"^"_RISRExamID_"^^"_UpdateUserCode_"@"_UpdateUserDesc_"^"_UpdateDate_"^"_UpdateTime
				;set Result=..InsertResultStatus(tmpInput,"CM")
				
				// 更新检查状态20190621
				set UpdateDateTime=UpdateDate_" "_UpdateTime
				set Position=""
				set Status="CIM"
				set SourceSystem=##Class(web.DHCENS.STBLL.RIS.METHOD.Common).GetSystemType(OEORROrderItemID)
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
				if (tSCStr'["成功")
				{
					set OrdFlag="-1"
					if ErrorOrd=""  set ErrorOrd=OEORROrderItemID_":"_" ^医嘱闭环返回—"_tSCStr
					else  set ErrorOrd=ErrorOrd_"^"_OEORROrderItemID_":"_" ^医嘱闭环返回—"_tSCStr
					q
				}
				else{
					set OrdFlag="0"
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
	else
	{	
		tro
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=ErrorOrd
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
	d stream.Write("-1^"_$ze)
	Quit stream
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

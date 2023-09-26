Class web.DHCENS.STBLL.Method.ReturnSystemStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2021—04-30
/// Description：状态变更回传HIS
/// Table：Ens_Status、Ens_StatusLog
/// Input：请求xml串
/// Return：应答xml串
/// Debug:w ##class(web.DHCENS.STBLL.Method.ReturnSystemStatus).ReturnSystemStatusCircle().Read()
ClassMethod ReturnSystemStatusCircle(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Err"
	ts
	set stream=##class(%GlobalCharacterStream).%New()
	s OrdFlag="0",ErrorOrd="",ResultCode=""
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	if $$$ISERR(tSC) {
		set ResultContent="<Response><Header><SourceSystem>HIS</SourceSystem><MessageID>"_MessageID_"</MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>失败，请检查xml结构。</ResultContent></Body></Response>"
		do stream.Write(ResultContent)
	}else{
		set SourceSystem=""
		set tSC=tDocument.EvaluateExpression("/Request/Header/SourceSystem","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SourceSystem=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body","count(StatusParameter)",.tRes)
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			if hsCount="0" {
				set ResultContent="<Response><Header><SourceSystem>HIS</SourceSystem><MessageID>"_MessageID_"</MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>状态信息为空</ResultContent></Body></Response>"
				do stream.Write(ResultContent)
			}
			set jsonstr=""
			for i=1:1:hsCount {
				set (PATPatientID,PAADMVisitNumber,OEORIOrderItemID,OEORIOrdExecID,SpecimenID,RISRExamID,RISRSystemType,Position,OperAppID,BloodAppID,BloodBagNo,ConsultAppID,StatusCode,UpdateUserCode,UpdateUserName,UpdateDateTime)=""
				set ExamID=""
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/PATPatientID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set PATPatientID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/PAADMVisitNumber","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/OEORIOrderItemID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORIOrderItemID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/OEORIOrdExecID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORIOrdExecID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/SpecimenID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set SpecimenID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/RISRExamID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set RISRExamID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/RISRSystemType","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set RISRSystemType=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/Position","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set Position=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/OperAppID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OperAppID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/BloodAppID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set BloodAppID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/BloodBagNo","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set BloodBagNo=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/ConsultAppID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set ConsultAppID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/StatusCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set StatusCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/UpdateUserCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateUserCode=$tr(fieldValue,$c(0),""),ExeUserID=""
					set:UpdateUserCode'="" ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UpdateUserCode),""))
					set:ExeUserID'="" UpdateUserDesc=$p($g(^SSU("SSUSR",ExeUserID)),"^",2)
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/UpdateUserName","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateUserName=$tr(fieldValue,$c(0),"")
					set:UpdateUserName="" UpdateUserName=UpdateUserDesc
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/UpdateDateTime","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateDateTime=$tr(fieldValue,$c(0),"")
				}
				s Notes=""  
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/ESNotes","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set Notes=$tr(fieldValue,$c(0),"")
				}
				s OperateDeptCode=""  
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/ESOperateDeptCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OperateDeptCode=$tr(fieldValue,$c(0),"")
				}
				s OperateDept=""  
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/ESOperateDept","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OperateDept=$tr(fieldValue,$c(0),"")
				}
				s ReportID=""  
				set tSC=tDocument.EvaluateExpression("/Request/Body/StatusParameter["_i_"]/ESReportID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set ReportID=$tr(fieldValue,$c(0),"")
				}
			
				set:RISRSystemType="LIS" ExamID=SpecimenID //检验
				set:(RISRSystemType="PACS")||(RISRSystemType="ES")||(RISRSystemType="EKG")||(RISRSystemType="US")||(RISRSystemType="PIS")||(RISRSystemType="RIM") ExamID=RISRExamID //PACS、内镜、心电、超声、病理、医技预约
				set:(RISRSystemType="ORALMED")||(RISRSystemType="PIVAS") OEORIOrderItemID=OEORIOrdExecID,ExamID=OEORIOrdExecID //口服药、静配
				set:RISRSystemType="BLD" OEORIOrderItemID=BloodAppID,ExamID=BloodAppID //输血
				set:(RISRSystemType="OPER")||(RISRSystemType="AN") OEORIOrderItemID=OperAppID,ExamID=OperAppID //手术
				set:RISRSystemType="CONSULT" OEORIOrderItemID=ConsultAppID,ExamID=ConsultAppID //会诊
				set Result="0",RepStatus="0",BillResult="0"
				if (RISRSystemType="PACS")||(RISRSystemType="ES")||(RISRSystemType="EKG")||(RISRSystemType="US")||(RISRSystemType="PIS")||(RISRSystemType="RIM")
				{
					set AdmType=$p($g(^PAADM(PAADMVisitNumber)),"^",2)
					set OrdBillStatus=$p($g(^OEORD(+OEORIOrderItemID,"I",$p(OEORIOrderItemID,"||",2),3)),"^",5)
					set BillResult="0^成功^计费状态没问题"
					//绿色通道患者不收费返回
					s GreedPat=##class(DHCDoc.Interface.Inside.Service).GetPreCureAfterPayFlag(OEORIOrderItemID)
					s GreedPatFlag=$P(GreedPat,"^",1)
					if ((AdmType'="I")&&(OrdBillStatus'="P")&&(GreedPatFlag'="Y")) set BillResult="-1^就诊状态为："_AdmType_"，计费状态为："_OrdBillStatus_"，医嘱号为："_OEORIOrderItemID_"不允许执行该状态"
					if ($p(BillResult,"^",1)=0)&&(StatusCode="SC")
					{	
						s DeceasedFlay="" 
						set admNo = $P($g(^OEORD(+OEORIOrderItemID)),"^",1)
    					set patDr = $P($g(^PAADM(admNo)),"^",1)
    					s DeceasedFlay=$p($g(^PAPER(patDr,"ALL")),"^",12)
    					if (DeceasedFlay="Y")&&(RISRSystemType'="PIS"){  //add 2021-07-29
	    					set Result="患者已故,不容许登记"
	    				}else{	    				
		    				if Position=""
		    				{				
		    					set Result=##class(appcom.OEOrdItem).Execute(OEORIOrderItemID,ExeUserID) ; 修改医嘱状态
			    			}
			    			else
			    			{
				    			s PositionLen=$l(Position,"@@")
				    			for j=1:1:PositionLen
				    			{
					    			s SinglePosition=$p(Position,"@@",j)
					    			q:SinglePosition=""
					    			/// 单个部位，调用通过医嘱ID设置检查申请部位执行状态
					    			s SinglePositionid=$o(^DHCAPPART(0,"Desc",SinglePosition,""))
									q:SinglePositionid=""
				    				s Result=##Class(web.DHCAPPInterface).SetExaReqExeStatus(OEORIOrderItemID,SinglePositionid,"E",ExeUserID)
									d ##class(web.UDHCJFBILLIP).BILL(admNo,ExeUserID,"","")
					    		}
				    			
				    			
				    		}
		    			}
					}
					if (StatusCode="CSC")||(StatusCode="CA")
					{
						if Position=""
		    			{
							set Result=##class(appcom.OEOrdItem).Verify(OEORIOrderItemID,ExeUserID) ; 修改医嘱状态
		    			}
		    			else
		    			{
			    			s PositionLen=$l(Position,"@@")
				    		for j=1:1:PositionLen
				    		{
					    		s SinglePosition=$p(Position,"@@",j)
					    		q:SinglePosition=""
					    		/// 单个部位，调用通过医嘱ID设置检查申请部位核实状态
					    		s SinglePositionid=$o(^DHCAPPART(0,"Desc",SinglePosition,""))
								q:SinglePositionid=""
				    			s Result=##Class(web.DHCAPPInterface).SetExaReqExeStatus(OEORIOrderItemID,SinglePositionid,"V",ExeUserID)
					    	}
			    		}
					}
					if (StatusCode="CRP")||(StatusCode="CA")
					{
						set RepStatus=..UpdateReportStatusRIS(OEORIOrderItemID,RISRExamID,ReportID) ;##class(appcom.OEOrdItem).Verify(OEORIOrderItemID,ExeUserID) ; 修改医嘱状态
					}
					// add 2021-09-03 病理标本接收
					if (StatusCode="RECEIVE"){
						
						//调用护理组方法
						s RepStatus=##class(Nur.Carry.PisService).SetLabReceive(SpecimenID,ExeUserID,$P(UpdateDateTime," ",1),$P(UpdateDateTime," ",2))
					}
					if jsonstr="" set jsonstr="{""OEOrdItemID"":"""_OEORIOrderItemID_""","_"""Position"":"""_Position_""","_"""ExamID"":"""_RISRExamID_""","_"""Status"":"""_StatusCode_""","_"""UserID"":"""_UpdateUserCode_""","_"""UserName"":"""_UpdateUserName_""","_"""UpDateTime"":"""_UpdateDateTime_""","_"""SourceSystem"":"""_RISRSystemType_""","_"""Notes"":"""_Notes_""","_"""OperateDeptCode"":"""_OperateDeptCode_""""_","_"""OperateDept"":"""_OperateDept_""""_","_"""ReportID"":"""_ReportID_""""_"}"  //Notes
					else  set jsonstr=jsonstr_",{""OEOrdItemID"":"""_OEORIOrderItemID_""","_"""Position"":"""_Position_""","_"""ExamID"":"""_RISRExamID_""","_"""Status"":"""_StatusCode_""","_"""UserID"":"""_UpdateUserCode_""","_"""UserName"":"""_UpdateUserName_""","_"""UpDateTime"":"""_UpdateDateTime_""","_"""SourceSystem"":"""_RISRSystemType_""","_"""Notes"":"""_Notes_""","_"""OperateDeptCode"":"""_OperateDeptCode_""""_","_"""OperateDept"":"""_OperateDept_""""_","_"""ReportID"":"""_ReportID_""""_"}"
				}
				elseif (RISRSystemType="LIS")
				{
					set AdmType=$p($g(^PAADM(PAADMVisitNumber)),"^",2)
					set OrdBillStatus=$p($g(^OEORD(+OEORIOrderItemID,"I",$p(OEORIOrderItemID,"||",2),3)),"^",5)
					set BillResult="0^成功^计费状态没问题"
					//绿色通道患者不收费返回
					s GreedPat=##class(DHCDoc.Interface.Inside.Service).GetPreCureAfterPayFlag(OEORIOrderItemID)
					s GreedPatFlag=$P(GreedPat,"^",1)
					if ((AdmType'="I")&&(OrdBillStatus'="P")&&(GreedPatFlag'="Y")) set BillResult="-1^就诊状态为："_AdmType_"，计费状态为："_OrdBillStatus_"，医嘱号为："_OEORIOrderItemID_"不允许执行该状态"
					if ($p(BillResult,"^",1)=0)&&(StatusCode="RECEIVE")
					{
						set Result=##class(appcom.OEOrdItem).Execute(OEORIOrderItemID,ExeUserID) ; 修改医嘱状态
						set:Result="-209" Result="0" //一个条码多条医嘱时 第一次执行该条码所有医嘱
					}
					
					s OrdStatusRowID=$p($g(^OEORD(+OEORIOrderItemID,"I",$p(OEORIOrderItemID,"||",2),1)),"^",13)
					if (StatusCode="ACCEPT")&&(OrdStatusRowID="1")
					{
						set Result=##class(appcom.OEOrdItem).Execute(OEORIOrderItemID,ExeUserID) ; 修改医嘱状态
					}
					if (StatusCode="REJECT")&&(OrdStatusRowID="6")
					{
						set Result=##class(appcom.OEOrdItem).Verify(OEORIOrderItemID,ExeUserID) ; 修改医嘱状态
					}
					if (StatusCode="CRP")
					{
						set RepStatus=..UpdateReportStatusLIS(OEORIOrderItemID,SpecimenID,ReportID)
					}
					if jsonstr="" set jsonstr="{""OEOrdItemID"":"""_OEORIOrderItemID_""","_"""Position"":"""_Position_""","_"""ExamID"":"""_SpecimenID_""","_"""Status"":"""_StatusCode_""","_"""UserID"":"""_UpdateUserCode_""","_"""UserName"":"""_UpdateUserName_""","_"""UpDateTime"":"""_UpdateDateTime_""","_"""SourceSystem"":"""_RISRSystemType_""","_"""Notes"":"""_Notes_""","_"""OperateDeptCode"":"""_OperateDeptCode_""""_","_"""OperateDept"":"""_OperateDept_""""_","_"""ReportID"":"""_ReportID_""""_"}"
					else  set jsonstr=jsonstr_",{""OEOrdItemID"":"""_OEORIOrderItemID_""","_"""Position"":"""_Position_""","_"""ExamID"":"""_SpecimenID_""","_"""Status"":"""_StatusCode_""","_"""UserID"":"""_UpdateUserCode_""","_"""UserName"":"""_UpdateUserName_""","_"""UpDateTime"":"""_UpdateDateTime_""","_"""SourceSystem"":"""_RISRSystemType_""","_"""Notes"":"""_Notes_""","_"""OperateDeptCode"":"""_OperateDeptCode_""""_","_"""OperateDept"":"""_OperateDept_""""_","_"""ReportID"":"""_ReportID_""""_"}"
				}
				elseif (RISRSystemType="ORALMED")||(RISRSystemType="PIVAS")||(RISRSystemType="BLD")||(RISRSystemType="OPER")||(RISRSystemType="CONSULT")||(RISRSystemType="EMR")||(RISRSystemType="AN")
				{
					if jsonstr="" set jsonstr="{""OEOrdItemID"":"""_OEORIOrderItemID_""","_"""Position"":"""_Position_""","_"""ExamID"":"""_RISRExamID_""","_"""Status"":"""_StatusCode_""","_"""UserID"":"""_UpdateUserCode_""","_"""UserName"":"""_UpdateUserName_""","_"""UpDateTime"":"""_UpdateDateTime_""","_"""SourceSystem"":"""_RISRSystemType_""","_"""Notes"":"""_Notes_""","_"""OperateDeptCode"":"""_OperateDeptCode_""""_","_"""OperateDept"":"""_OperateDept_""""_","_"""ReportID"":"""_ReportID_""""_"}"
					else  set jsonstr=jsonstr_",{""OEOrdItemID"":"""_OEORIOrderItemID_""","_"""Position"":"""_Position_""","_"""ExamID"":"""_RISRExamID_""","_"""Status"":"""_StatusCode_""","_"""UserID"":"""_UpdateUserCode_""","_"""UserName"":"""_UpdateUserName_""","_"""UpDateTime"":"""_UpdateDateTime_""","_"""SourceSystem"":"""_RISRSystemType_""","_"""Notes"":"""_Notes_""","_"""OperateDeptCode"":"""_OperateDeptCode_""""_","_"""OperateDept"":"""_OperateDept_""""_","_"""ReportID"":"""_ReportID_""""_"}"
				}
				
				if (Result'="0")||(RepStatus'="0")||($p(BillResult,"^",1)'=0)
				{
					set OrdFlag="-1"
					if ErrorOrd=""  set ErrorOrd=OEORIOrderItemID_":"_"医生站组方法返回—"_Result_" ^计费状态返回—"_BillResult
					else  set ErrorOrd=ErrorOrd_"^"_OEORIOrderItemID_":"_"医生站组方法返回—"_Result_" ^计费状态返回—"_BillResult
					q
				}
				elseif RISRSystemType=""{
					set OrdFlag="-1"
					if ErrorOrd=""  set ErrorOrd=OEORIOrderItemID_":"_"系统类型代码不能为空！"
					else  set ErrorOrd=ErrorOrd_"^"_OEORIOrderItemID_":"_"系统类型代码不能为空！"
					q
				}
			}
			set jsonstr="["_jsonstr_"]"
			set jsonStream=##class(%GlobalCharacterStream).%New()
			d jsonStream.Write(jsonstr)
			set tSC=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
			s RtnJSONArr={}.%FromJSON(tSC)
			s RtnJSON=RtnJSONArr.%Get(0)
			s ResultCode=RtnJSON.%Get("ResultCode")
			s ResultContent=RtnJSON.%Get("ResultContent")
		}
		if (ResultCode="0")&&(OrdFlag="0")   //&&(seeType="0")
		{
			tc
			set ResultContentInfo="<Response><Header><SourceSystem>HIS</SourceSystem><MessageID>"_MessageID_"</MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>"_ResultContent_"</ResultContent></Body></Response>"
			do stream.Write(ResultContentInfo)
		}
		else
		{
			tro
			set ResultContentInfo="<Response><Header><SourceSystem>HIS</SourceSystem><MessageID>"_MessageID_"</MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_ErrorOrd_","_ResultContent_"</ResultContent></Body></Response>"
			do stream.Write(ResultContentInfo)
		}
	}
	q stream
Err
	if $TLEVEL>0
	{
	 	tro	
	}
	set stream=##class(%GlobalCharacterStream).%New()
	set ResultContent="<Response><Header><SourceSystem>HIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_"<![CDATA["_$ze_"]]>"_"</ResultContent></Body></Response>"
	do stream.Write(ResultContent)
	q stream
}

/// Description:更新文档表和检验报告表状态为取消审核
/// Debug: w ##class(web.DHCENS.STBLL.Method.ReturnSystemStatus).UpdateReportStatusLIS("2||3","0000002337")
ClassMethod UpdateReportStatusLIS(OEORROrderItemID As %String, SpecimenID As %String, LISReportID As %String = "") As %String
{
	s $Ztrap="Exception"
	q:(OEORROrderItemID="")||(SpecimenID="") "0"
	ts
	set RelODType="" for  s RelODType=$o(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",OEORROrderItemID,RelODType)) q:RelODType=""  d
	.set RelODID="" for  s RelODID= $o(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",OEORROrderItemID,RelODType,RelODID)) q:RelODID=""  d
	..set RelDocuID=$lg($g(^Busi.ENS.EnsRelOrderDocumentD(RelODID)),2)
	..q:RelDocuID=""
	..set DocuID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTPKey",RelDocuID,""))
	..&SQL(Update SQLUser.Ens_HosDocument set HOSD_Status="2" where %id=:DocuID)
	..if SQLCODE'=0 d
	...tro
	...q
	set SpecimenRepID="" for  s SpecimenRepID=$o(^Busi.ENS.EnsLISSpecimenReportI("RELORDERSPECIMENHOSCODE"," "_SpecimenID,SpecimenRepID)) q:SpecimenRepID=""  d
	.set LISSRReportID=$lg($g(^Busi.ENS.EnsLISSpecimenReportD(SpecimenRepID)),2)
	.q:(LISReportID'="")&&(LISSRReportID'=LISReportID)
	.set LISRepRowID=$O(^Busi.ENS.EnsLISReportResultI("LISREPORTRESULTPKey",LISSRReportID,""))
	.&SQL(Update SQLUser.Ens_LISReportResult set LISRR_Status="2" where %id=:LISRepRowID)
	.if SQLCODE'=0 d 
	..tro
	..q
	if LISReportID'=""
	{
		&SQL(Update SQLUser.Ens_LISReportResult set LISRR_Status="2" where LISRR_ReportID=:LISReportID)	
	}
	if (($g(SQLCODE)=0)||($g(SQLCODE)="")||($g(SQLCODE)=100))&&($TLEVEL>0)
	{
		tc
	}
	q 0
Exception
	if $TLEVEL>0
	{
	 	tro	
	}
	q "-1"
}

/// Description:更新文档表状态为取消审核
/// Debug: w ##class(web.DHCENS.STBLL.Method.ReturnSystemStatus).UpdateReportStatusRIS("2||3","0000002337","")
ClassMethod UpdateReportStatusRIS(OEORROrderItemID As %String, ExamID As %String, RISReportID As %String = "") As %String
{
	s $Ztrap="Exception"
	q:(OEORROrderItemID="")||(ExamID="") "0"
	ts
	set RelODType="" for  s RelODType=$o(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",OEORROrderItemID,RelODType)) q:RelODType=""  d
	.set RelODID="" for  s RelODID= $o(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",OEORROrderItemID,RelODType,RelODID)) q:RelODID=""  d
	..set RelExamID=$lg($g(^Busi.ENS.EnsRelOrderDocumentD(RelODID)),7)
	..q:RelExamID'=ExamID
	..set RelDocuID=$lg($g(^Busi.ENS.EnsRelOrderDocumentD(RelODID)),2)
	..q:RelDocuID=""
	..set RelODRisReportID=$lg($g(^Busi.ENS.EnsRelOrderDocumentD(RelODID)),4)
	..q:(RISReportID'="")&&(RelODRisReportID'=RISReportID)
	..set DocuID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTPKey",RelDocuID,""))
	..&SQL(Update SQLUser.Ens_HosDocument set HOSD_Status="2" where %id=:DocuID)
	..if SQLCODE'=0 d
	...tro
	...q
	if RISReportID'=""
	{
		&SQL(Update SQLUser.Ens_RISReportResult set RISR_Status="2" where RISR_ReportID=:RISReportID)	
	}
	if (($g(SQLCODE)=0)||($g(SQLCODE)="")||($g(SQLCODE)=100))&&($TLEVEL>0)
	{
		tc
	}
	q 0
Exception
	if $TLEVEL>0
	{
	 	tro	
	}
	q "-1"
}

/// Debug: w ##class(web.DHCENS.STBLL.Method.ReturnSystemStatus).test("")
ClassMethod test(tmpStr As %String) As %String
{
	set stream=##class(%GlobalCharacterStream).%New()
	;s xml="<Request><Header><SourceSystem>SYS0001</SourceSystem><MessageID></MessageID></Header><Body><StatusParameter><PATPatientID>00190131</PATPatientID><PAADMVisitNumber>23104299</PAADMVisitNumber><OEORIOrderItemID>23104345||1</OEORIOrderItemID><OEORIOrdExecID></OEORIOrdExecID><SpecimenID>100312382912</SpecimenID><RISRExamID></RISRExamID><Position></Position><OperAppID></OperAppID><BloodAppID></BloodAppID><BloodBagNo></BloodBagNo><ConsultAppID></ConsultAppID><StatusCode>SC</StatusCode><UpdateUserCode>demo</UpdateUserCode><UpdateUserName>demo</UpdateUserName><UpdateDateTime>2021-04-21 15:00:01</UpdateDateTime></StatusParameter><StatusParameter><PATPatientID>00190131</PATPatientID><PAADMVisitNumber>23104299</PAADMVisitNumber><OEORIOrderItemID>23104345||2</OEORIOrderItemID><OEORIOrdExecID></OEORIOrdExecID><SpecimenID>100312382912</SpecimenID><RISRExamID></RISRExamID><Position></Position><OperAppID></OperAppID><BloodAppID></BloodAppID><BloodBagNo></BloodBagNo><ConsultAppID></ConsultAppID><StatusCode>SC</StatusCode><UpdateUserCode>demo</UpdateUserCode><UpdateUserName>demo</UpdateUserName><UpdateDateTime>2021-04-21 15:00:01</UpdateDateTime></StatusParameter></Body></Request>"
	;s xml="<Request><Header><SourceSystem>LIS</SourceSystem><MessageID>91E43BF7-FC5B-4A10-970C-2B2F35F05871</MessageID></Header><Body><StatusParameter><PATPatientID>0000000010</PATPatientID><PAADMVisitNumber>2016</PAADMVisitNumber><OEORIOrderItemID>1797||66</OEORIOrderItemID><SpecimenID>21081500007</SpecimenID><RISRSystemType>LIS</RISRSystemType><StatusCode>RECEIVE</StatusCode><UpdateUserCode>admin</UpdateUserCode><UpdateUserName>LIS</UpdateUserName><UpdateDateTime>2021-08-16 10:26:07</UpdateDateTime></StatusParameter></Body></Request>"
	;s xml="<Request><Header><SourceSystem>LIS</SourceSystem><MessageID>C2ED046C-AE2F-4F63-9584-7EF632A303B5</MessageID></Header><Body><StatusParameter><PATPatientID>61503115</PATPatientID><PAADMVisitNumber>68527</PAADMVisitNumber><OEORIOrderItemID>68518||2</OEORIOrderItemID><SpecimenID>300000071830</SpecimenID><RISRSystemType></RISRSystemType><StatusCode>RECEIVE</StatusCode><UpdateUserCode>0129</UpdateUserCode><UpdateUserName>LIS</UpdateUserName><UpdateDateTime>2021-09-26 13:06:52</UpdateDateTime></StatusParameter><StatusParameter><PATPatientID>61503115</PATPatientID><PAADMVisitNumber>68527</PAADMVisitNumber><OEORIOrderItemID>68518||4</OEORIOrderItemID><SpecimenID>300000071830</SpecimenID><RISRSystemType>LIS</RISRSystemType><StatusCode>RECEIVE</StatusCode><UpdateUserCode>0129</UpdateUserCode><UpdateUserName>LIS</UpdateUserName><UpdateDateTime>2021-09-26 13:06:52</UpdateDateTime></StatusParameter><StatusParameter><PATPatientID>61503115</PATPatientID><PAADMVisitNumber>68527</PAADMVisitNumber><OEORIOrderItemID>68518||3</OEORIOrderItemID><SpecimenID>300000071830</SpecimenID><RISRSystemType>LIS</RISRSystemType><StatusCode>RECEIVE</StatusCode><UpdateUserCode>0129</UpdateUserCode><UpdateUserName>LIS</UpdateUserName><UpdateDateTime>2021-09-26 13:06:52</UpdateDateTime></StatusParameter></Body></Request>"
	;s xml="<Request>  <Header>    <SourceSystem>SYS0011</SourceSystem>    <MessageID></MessageID>  </Header>  <Body>    <StatusParameter>      <PATPatientID>0000000083</PATPatientID>      <PAADMVisitNumber>87</PAADMVisitNumber>      <OEORIOrderItemID>76||1197</OEORIOrderItemID>      <OEORIOrdExecID></OEORIOrdExecID>      <SpecimenID></SpecimenID>      <RISRExamID>B00000083001</RISRExamID>      <RISRSystemType>RIM</RISRSystemType>      <Position></Position>      <OperAppID></OperAppID>      <BloodAppID></BloodAppID>      <BloodBagNo></BloodBagNo>      <ConsultAppID></ConsultAppID>      <StatusCode>BK</StatusCode>      <UpdateUserCode>admin</UpdateUserCode>      <UpdateUserName>admin</UpdateUserName>      <UpdateDateTime>2023-02-07 16:56:27</UpdateDateTime>      <ESNotes>2023-02-07^16:30:00-17:30:00^^西门子^西门子^^</ESNotes>    </StatusParameter>  </Body></Request>"
	s xml="<Request> <Header> <SourceSystem>SYS0011</SourceSystem> <MessageID></MessageID> </Header> <Body> <StatusParameter> <PATPatientID>0000000230</PATPatientID> <PAADMVisitNumber>441</PAADMVisitNumber> <OEORIOrderItemID>402||239</OEORIOrderItemID> <OEORIOrdExecID></OEORIOrdExecID> <SpecimenID></SpecimenID> <RISRExamID>CS20230211018</RISRExamID> <RISRSystemType>RIM</RISRSystemType> <Position>左侧膝关节</Position> <OperAppID></OperAppID> <BloodAppID></BloodAppID> <BloodBagNo></BloodBagNo> <ConsultAppID></ConsultAppID> <StatusCode>CSC</StatusCode> <UpdateUserCode>admin</UpdateUserCode> <UpdateUserName>admin</UpdateUserName> <UpdateDateTime>2023-02-11 17:58:42</UpdateDateTime> <ESNotes></ESNotes> </StatusParameter> </Body></Request>"
	do stream.Write(xml)
	s rtn=..ReturnSystemStatusCircle(stream)
	q rtn.Read()
}

}

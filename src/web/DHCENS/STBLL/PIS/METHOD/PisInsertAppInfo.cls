Class web.DHCENS.STBLL.PIS.METHOD.PisInsertAppInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying   
/// CreatDate：2022—11-20 
/// Description:第三方回插病理申请单
/// Table：
/// Input：xmlStream
/// w ##class(web.DHCENS.STBLL.PIS.METHOD.PisInsertAppInfo).InsertPisAppOEOrder("")
ClassMethod InsertPisAppOEOrder(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set stream = ##class(%GlobalCharacterStream).%New()
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)

	s LgParams=""
	s ListData=""
	if $$$ISERR(tSC) {
		d stream.Write("xml结构错误"_tSC)
	    q stream
	}
	else{
		set PAADMVisitNumber=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")    // 就诊号
		}
		set PATPatientID=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/PATPatientID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PATPatientID=$tr(fieldValue,$c(0),"")   // 病人ID
		}
		
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos","count(OEORIInfo)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "-1^信息为空"
			s MainInputStr=""
			for i=1:1:hsCount {
				
				set (OEORIARCItmMastCode,sub,ver,itemMast,OEORIExecDeptCode,OrderRecDepId,OEORIISEmergency,userDr)=""
				set (OEORIEnterDeptCode,OEORIEnterDocCode,OrderEncDepId,FrozenFlag,HumanPapillomavirusDateTime,DocumentInfo)=""
				set (ClinicalDiagnosis,RequestType,ThirdOEORIOrderItemID,SpecNO,SpecFlag,SpecName,SpecPosition,SpecQty,Slice,OriginalNO,Notes)=""
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIARCItmMastCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIARCItmMastCode=$tr(fieldValue,$c(0),"")     // 检查分类项目ID
					set sub = $O(^ARCIM(0,"Code",OEORIARCItmMastCode,""))
					set ver = $O(^ARCIM(0,"Code",OEORIARCItmMastCode,sub,""))
					set itemMast = sub_"||"_ver    //医嘱项Rowid
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIExecDeptCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIExecDeptCode=$tr(fieldValue,$c(0),"")   // 接收科室ID
					set OrderRecDepId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(OEORIExecDeptCode),""))
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIISEmergency","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIISEmergency=$tr(fieldValue,$c(0),"")    // 是否加急
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIEnterDocCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIEnterDocCode=$tr(fieldValue,$c(0),"")  //  用户ID
					set user=$$ALPHAUP^SSUTIL4(OEORIEnterDocCode)
					set userDr = $O(^SSU("SSUSR",0,"SSUSR_Initials",user,""))	
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIEnterDeptCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIEnterDeptCode=$tr(fieldValue,$c(0),"")    //  用户科室
					set OrderEncDepId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(OEORIEnterDeptCode),""))
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/FrozenFlag","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set FrozenFlag=$tr(fieldValue,$c(0),"")    // 冰冻标志
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/HumanPapillomavirusDateTime","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set HumanPapillomavirusDateTime=$tr(fieldValue,$c(0),"")   // 人乳头病毒发现日期
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/DocumentInfo","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set DocumentInfo=$tr(fieldValue,$c(0),"")  //  临床病历
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/ClinicalDiagnosis","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set ClinicalDiagnosis=$tr(fieldValue,$c(0),"")  //  临床诊断
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/RequestType","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set RequestType=$tr(fieldValue,$c(0),"")  //  申请类型
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/ThirdOEORIOrderItemID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set ThirdOEORIOrderItemID=$tr(fieldValue,$c(0),"")   //   医嘱ID
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/RequestType","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set RequestType=$tr(fieldValue,$c(0),"")  //  申请类型
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/SpecNO","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set SpecNO=$tr(fieldValue,$c(0),"")  //  标本序号
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/SpecFlag","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set SpecFlag=$tr(fieldValue,$c(0),"")  //  标本标识
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/SpecName","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set SpecName=$tr(fieldValue,$c(0),"")  //  标本名字
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/SpecPosition","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set SpecPosition=$tr(fieldValue,$c(0),"")  //  标本部位
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/SpecQty","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set SpecQty=$tr(fieldValue,$c(0),"")  //  标本数量
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/Slice","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set Slice=$tr(fieldValue,$c(0),"")  //  拨片/蜡片
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OriginalNO","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OriginalNO=$tr(fieldValue,$c(0),"")  //  原病理号
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/Notes","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set Notes=$tr(fieldValue,$c(0),"")   //  备注
				}
				///mListData - 医嘱项ID^接收科室ID^就诊ID^申请医生ID^申请科室ID^加急标志^冰冻标志^人乳头病毒发现日期^临床病历^临床诊断^^^申请类型^医嘱ID
				///            &标本序号^标本标识^标本名字^标本部位^标本数量^拨片/蜡片^原病历号^备注

				set mListData=itemMast_"^"_OrderRecDepId_"^"_PAADMVisitNumber_"^"_userDr_"^"_OrderEncDepId_"^"_OEORIISEmergency_"^"_FrozenFlag_"^"_HumanPapillomavirusDateTime
				set mListData=mListData_"^"_DocumentInfo_"^"_ClinicalDiagnosis_"^^^"_RequestType_"^"_ThirdOEORIOrderItemID
				set mListData=mListData_"&"_SpecNO_"^"_SpecFlag_"^"_SpecName_"^"_SpecPosition_"^"_SpecQty_"^"_Slice_"^"_OriginalNO_"^"_Notes		
			} 
			
			set pisReqNo = ##Class(web.DHCAPPPisInterface).InsPisMas(mListData)
			if pisReqNo<0
			{
				set ResStr = "<Response><Header><SourceSystem>HIS</SourceSystem><MessageID>62410</MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_ThirdOEORIOrderItemID_"@@"_pisReqNo_"</ResultContent></Body></Response>"
			}
			else
			{
				s arRowid=$o(^DHCAPPPM(0,"PisNo",pisReqNo,""))
				q:arRowid=""
				s arSub=$o(^DHCAPPPM(arRowid,"A",""))
				q:arSub=""
				s arOrdItem=$p($g(^DHCAPPPM(arRowid,"A",arSub)),"^",3)
				set ResStr = "<Response><Header><SourceSystem>HIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>"_ThirdOEORIOrderItemID_"@@"_arOrdItem_"</ResultContent></Body></Response>"
			}
		    d stream.Write(ResStr)
		}  		
		q stream
	}
	
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	set ErrStr = "<Response><Header><SourceSystem>HIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_$ze_"</ResultContent></Body></Response>"
	d stream.Write(ErrStr)
	Quit stream
}

/// 测试方法
/// w ##class(web.DHCENS.STBLL.PIS.METHOD.PisInsertAppInfo).Test()
ClassMethod Test()
{
	   s input="<Request><Header>  <SourceSystem>SYS0001</SourceSystem><MessageID>S0068</MessageID></Header><Body><AddOrdersRt><PATPatientID>0000000018</PATPatientID>  <PAADMVisitNumber>12</PAADMVisitNumber>  <OEORIInfos><OEORIInfo>  <OEORIARCItmMastCode>WFYBL00001</OEORIARCItmMastCode><OEORIExecDeptCode>ZYYJ013</OEORIExecDeptCode>   <OEORIISEmergency>Y</OEORIISEmergency>   <OEORIEnterDocCode>YS01</OEORIEnterDocCode>  <OEORIEnterDeptCode>ZYTJ001</OEORIEnterDeptCode>  <FrozenFlag/> <HumanPapillomavirusDateTime/>   <DocumentInfo>aaAD</DocumentInfo>   <ClinicalDiagnosis>WWW</ClinicalDiagnosis>   <RequestType/>   <ThirdOEORIOrderItemID>W3213</ThirdOEORIOrderItemID> <SpecNO>1</SpecNO>   <SpecFlag>Y</SpecFlag> <SpecName>标本1</SpecName>   <SpecPosition/> <SpecQty>1</SpecQty>   <Slice/>   <OriginalNO/>  <Notes/>   </OEORIInfo> </OEORIInfos><UpdateUserCode>demo</UpdateUserCode><UpdateUserDesc>demo</UpdateUserDesc><UpdateDate/><UpdateTime/><OrderEndDate/><OrderEndTime/>  </AddOrdersRt>   </Body> </Request>"
	   set stream = ##class(%GlobalCharacterStream).%New()
	   d stream.Write(input)
	   set res = ..InsertPisAppOEOrder(stream).Read()
	   q res
}

}

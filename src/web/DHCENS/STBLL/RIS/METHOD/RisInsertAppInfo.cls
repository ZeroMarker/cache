Class web.DHCENS.STBLL.RIS.METHOD.RisInsertAppInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lwt   
/// CreatDate：2022—06-20 
/// Description:第三方回插检查申请单
/// Table：
/// Input：xmlStream
/// w ##class(web.DHCENS.STBLL.RIS.METHOD.RisInsertAppInfo).InsertRisAppOEOrder("")
ClassMethod InsertRisAppOEOrder(Input As %GlobalCharacterStream) As %GlobalCharacterStream
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
		set ExaminePurpose=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/ExaminePurpose","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set ExaminePurpose=$tr(fieldValue,$c(0),"")   // 检查目的
		}
		set Signs=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/Signs","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set Signs=$tr(fieldValue,$c(0),"")     // 体征
		}
		set MainTell=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/MainTell","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set MainTell=$tr(fieldValue,$c(0),"")   // 主诉
		}
		set Hpi=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/Hpi","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set Hpi=$tr(fieldValue,$c(0),"")    //  现病史
		}
		set PATPatientID=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/PATPatientID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PATPatientID=$tr(fieldValue,$c(0),"")   // 病人ID
		}
		
		// mPatSymData = 就诊号 _$C(4)_ 现病史 _$C(4)_ 体征 _$C(4)_ 主诉_$C(4)_检查目的;
		set mPatSymData= PAADMVisitNumber_$C(4)_Hpi_$C(4)_Signs_$C(4)_MainTell_$C(4)_ExaminePurpose
		
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos","count(OEORIInfo)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "-1^信息为空"
			s MainInputStr=""
			for i=1:1:hsCount {
				
				set (PartCode,DealWithAfterCode,Remark,PayCatCode,IsHealthCare,OrderEncDepId,userDr,DiagnosisRowid)=""
				set (itemMast,OrdSubCatRowID,OrderRecDepId,ThirdOEORIOrderItemID,OEORIPriorityCode,OEORIARCItmMastCode,OEORIOrderQty,OEORIFreqCode,OEORIDoseUnitCode)=""
				set (SlowDiseaseCode,SlowDiseaseDiagnosis,PositionCode,OEORIDoseForms,OEORIEnterDeptCode,OEORIExecDeptCode,OEORIEnterDocCode,OEORIRequireExecDate,OEORIRequireExecTime,OEORIRemarks,SourceSystem)=""
				set (OEORIEnterDate,OEORIEnterTime,OEORIOEORIDR,OEORISpecimenCode,OEORIDoseQty,OEORIInstrCode,OEORIDurationCode)=""
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIARCItmMastCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIARCItmMastCode=$tr(fieldValue,$c(0),"")     // 检查分类项目ID
					set sub = $O(^ARCIM(0,"Code",OEORIARCItmMastCode,""))
					set ver = $O(^ARCIM(0,"Code",OEORIARCItmMastCode,sub,""))
					set itemMast = sub_"||"_ver    //医嘱项Rowid
					 set OrdSubCatRowID = $p($g(^ARCIM(sub,ver,1)),"^",10)   // 子分类ID
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIExecDeptCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIExecDeptCode=$tr(fieldValue,$c(0),"")   // 接收科室ID
					set OrderRecDepId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(OEORIExecDeptCode),OrderRecDepId))
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
					set LgParams=userDr					
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIEnterDeptCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIEnterDeptCode=$tr(fieldValue,$c(0),"")    //  用户科室
					set OrderEncDepId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(OEORIEnterDeptCode),OrderEncDepId))
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/Diagnosis","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set Diagnosis=$tr(fieldValue,$c(0),"")    // 诊断
					set DiagnosisRowid = ..GetICDRowid(Diagnosis)
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/SlowDiseaseCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set SlowDiseaseCode=$tr(fieldValue,$c(0),"")   // 慢特病ID
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/SlowDiseaseDiagnosis","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set SlowDiseaseDiagnosis=$tr(fieldValue,$c(0),"")  //  慢特病诊断
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/ThirdOEORIOrderItemID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set ThirdOEORIOrderItemID=$tr(fieldValue,$c(0),"")   //   医嘱ID
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/PositionCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set PositionCode=$tr(fieldValue,$c(0),"")   //  体位ID
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/PartCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set PartCode=$tr(fieldValue,$c(0),"")  //  部位ID
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/Remark","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set Remark=$tr(fieldValue,$c(0),"")    //   备注
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/DealWithAfterCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set DealWithAfterCode=$tr(fieldValue,$c(0),"")   // 后处理ID
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/PayCatCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set PayCatCode=$tr(fieldValue,$c(0),"")     // 费别ID
				}
			
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/IsHealthCare","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set IsHealthCare=$tr(fieldValue,$c(0),"")   // 是否医保
				}
		       set OrdSubCatRowID=""
			   set OneListData=OrdSubCatRowID_$C(2)_PAADMVisitNumber_"^"_OrderRecDepId_"^"_OEORIISEmergency_"^"_ExaminePurpose_"^"_userDr_"^^^"_OrderEncDepId_"^^Y^"_DiagnosisRowid_"^"_SlowDiseaseCode_"^"_SlowDiseaseDiagnosis
  			   set OneListData=OneListData_$C(2)_ThirdOEORIOrderItemID_"^"_PositionCode_"^"_PartCode_"^"_DealWithAfterCode_"^"_Remark_"^^^"_PayCatCode_"^"_OEORIISEmergency_"^"_IsHealthCare
			
			   ;w ##Class(web.DHCAPPExaReport).save(60368,""_$c(2)_"361^1^N^^12175^^^115^^Y^361-1"_$c(4)_"高血压^^"_$c(2)_"11571||1^^135^^^^^1^N^0","361"_$c(4)_"单独"_$c(4,4)_"单独"_$c(4)_"单独",12175)	
			   if ListData = "" {
					  set ListData=OneListData
				}
				else {
					set ListData=ListData_$c(1)_OneListData
				}			
			} 
			set res = ##Class(web.DHCAPPInterface).Insert(LgParams,ListData,mPatSymData)
			if res<0
			{
				set ResStr = "<Response><Header><SourceSystem>HIS</SourceSystem><MessageID>62410</MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_ThirdOEORIOrderItemID_"@@"_res_"</ResultContent></Body></Response>"
			}
			else
			{
				s arRowid=$o(^DHCAPREP(0,"ARNo",res,""))
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

/// w ##class(web.DHCENS.Util.Test).Test("A00.900x002")
ClassMethod GetICDRowid(IcdCode As %String) As %String
{
		     set icdRowid=""
		     set IcdCode=$$ALPHAUP^SSUTIL4(IcdCode)
		     set icdRowid = $O(^MRC("ID",0,"Code",IcdCode,icdRowid))
			 q icdRowid
}

/// 测试方法
/// w ##class(web.DHCENS.STBLL.RIS.METHOD.RisInsertAppInfo).Test()
ClassMethod Test()
{
	/// Descript: 插入检查申请记录
	/// mPatSymData = 就诊号 _$C(4)_ 现病史 _$C(4)_ 体征 _$C(4)_ 主诉_$C(4)_检查目的;
	/// LgParams :用户User	
	/// ListData = OneListData_$C(1)_OneListData_...
	/// OneListData=检查分类项目ID_$C(2)_就诊号_"^"_接收科室ID_"^"_是否加急_"^"_检查目的_"^"_用户ID_"^^^"_用户科室_"^^Y^"_诊断_"^"_慢特病ID_"^"_慢特病诊断
	/// OneListData=OneListData_$C(2)_医嘱ID_"^"_体位ID_"^"_部位ID_"^"_后处理ID_"^"_备注_"^^^"_费别ID_"^"_是否加急_"^"_是否医保
	/// ClassMethod Insert(LgParams As %String, ListData As %String, mPatSymData As %String) As %String	 
   s input="<Request><Header><SourceSystem>SYS0001</SourceSystem><MessageID>S0068</MessageID></Header><Body><AddOrdersRt><PATPatientID>0000039023</PATPatientID><PAADMVisitNumber>89963</PAADMVisitNumber><ExaminePurpose>检查目的</ExaminePurpose><Signs>体征</Signs><MainTell>主诉</MainTell><Hpi>现病史</Hpi><OEORIInfos><OEORIInfo><OEORIARCItmMastCode>FS0216</OEORIARCItmMastCode><OEORIExecDeptCode>FSK</OEORIExecDeptCode><OEORIISEmergency>Y</OEORIISEmergency><OEORIEnterDocCode>00400</OEORIEnterDocCode><OEORIEnterDeptCode>FSK</OEORIEnterDeptCode><Diagnosis>A00.900x002</Diagnosis><SlowDiseaseCode></SlowDiseaseCode><SlowDiseaseDiagnosis></SlowDiseaseDiagnosis><ThirdOEORIOrderItemID>12345</ThirdOEORIOrderItemID><PositionCode></PositionCode><PartCode></PartCode><DealWithAfterCode></DealWithAfterCode><Remark></Remark><PayCatCode></PayCatCode><IsHealthCare></IsHealthCare></OEORIInfo></OEORIInfos><UpdateUserCode>demo</UpdateUserCode><UpdateUserDesc>demo</UpdateUserDesc><UpdateDate>2020-09-24</UpdateDate><UpdateTime>10:41:00</UpdateTime><OrderEndDate>2020-09-24</OrderEndDate><OrderEndTime>10:41:00</OrderEndTime></AddOrdersRt></Body></Request>"
   set stream = ##class(%GlobalCharacterStream).%New()
   d stream.Write(input)
   set res = ..InsertRisAppOEOrder(stream).Read()
   q res
}

}

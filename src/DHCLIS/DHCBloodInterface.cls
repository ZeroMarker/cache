/// 
/// 1. GetReqFormInfo 根据就诊号第一次有效申请单信息
/// 2. GetIsSlefReq 根据就诊号返回是否存在自体输血申请
/// 3. GetIsRecaction 根据就诊号返回是否存在不良反应
/// 4. GetPatCompontsByAdmNo 根据就诊号返回用血信息 [血成分^代码^血量^单位$$血成分^代码^血量^单位]
/// 5. GetPackInfo 获取血袋信息
/// 6. GetPatBldByAdmNo 根据就诊号返回用血总量(注意维护转换系数)
/// 7. GetPatCompontsByDate 根据发血日期，返回时间范围内血量新汇总
/// 8. GetPatOPByDate 根据发血日期，返回时间范围内的手术用血汇总
/// 9. QryBloodByAdmNo 根据患者就诊号，返回患者用血明细
/// 10. GetReqFormCountNum 根据就诊号，返回该就诊号下的申请单数量（所有）
/// 11. StateAgPackVolumnByAdmNo 根据就诊号查询自体血发血血量总和 
Class DHCLIS.DHCBloodInterface Extends %RegisteredObject
{

ClassMethod GetTransfusion(SttAccDate As %String, EndAccDate As %String) As %String
{
	S SttAccDate=$tr($g(SttAccDate),"-"),EndAccDate=$tr($g(EndAccDate),"-") 
	K ^tmpWardData
	F Date=SttAccDate:1:EndAccDate
	{
		S IssueRecordDR=""
		F {
			S IssueRecordDR=$O(^dbo.BDIssueRecordI("IndexIssueDate",Date,IssueRecordDR))
			Q:'$l(IssueRecordDR)
			S obj=##class(dbo.BDIssueRecord).%New()
			S obj=obj.%OpenId(IssueRecordDR)
			CONTINUE:'$l(obj)
			S ReqId=obj.ReqFormDR
			S ReqObj=##class(dbo.BDReqForm).%New()
			S ReqObj=ReqObj.%OpenId(ReqId)
			CONTINUE:'$l(ReqObj)
			S AdmNo=ReqObj.AdmNo
			S Name=ReqObj.SurName
			S LocationDR=ReqObj.LocationDR,(LocationCode,LocationDesc)=""
   			S LocationCode=$lg($g(^dbo.BTLocationD(LocationDR)),2)
 			S LocationDesc=$lg($g(^dbo.BTLocationD(LocationDR)),3)
 			S IssueDate=obj.IssueDate
 			I $l(IssueDate) s IssueDate=$e(IssueDate,1,4)_"-"_$e(IssueDate,5,6)_"-"_$e(IssueDate,7,8)
			S IssueTime=obj.IssueTime
			i $l(IssueTime) s IssueTime=$zt(IssueTime)
			s IssueDT=IssueDate_" "_IssueTime
			I '$D(^tmpWardData(LocationDR,IssueRecordDR))
			{
				S ^tmpWardData(LocationDR)=$I(^tmpWardData(LocationDR))
				S ^tmpWardData(LocationDR,IssueRecordDR)=""
			}
			s PackDR="" 
			F
			{  
				s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) 
				Q:'$l(PackDR)
				s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
				s IssueRecordItemsData=$g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR))
  				s IsReturned=$lg(IssueRecordItemsData,4)
  				i IsReturned=1 CONTINUE  
  				s PackData=$g(^dbo.BDPackD(PackDR))
				s PackID=$lg(PackData,2)
				s BloodProductDR=$lg(PackData,3)
				s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
				s BloodProductCode=$lg(BloodProductData,2)
				s BloodProductName=$lg(BloodProductData,3)
				s BloodGroupDR=$lg(PackData,9)
				s BDType=$lg($g(^dbo.BBBloodGroupD(BloodGroupDR)),3)
  				s PackSize=$lg(PackData,10)
   				s Units=$lg(BloodProductData,15)
				s PackVolumn=PackSize_Units 
				I $D(^tmpWardData(LocationDR,IssueRecordDR))
				{
					S ^tmpWardData(LocationDR,IssueRecordDR)=IssueRecordDR_"^"_AdmNo_"^"_Name_"^"_LocationDesc_"^"_IssueDT_"^"_BloodProductName
				}
			}
		}
	}
	Q 0
}

/// 获取血成分输注顺序 
/// 入参：血成分RowID串(格式：1^2^3^)
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetBDProductTransSeqNumInfo("1")
ClassMethod GetBDProductTransSeqNumInfo(BDBloodComponentDRStr As %String)
{
	s LisNamespace = "DHC-LISDATA"
	s BDBloodComponentDRStr=$g(BDBloodComponentDRStr)
	s Ret=""
	k ^TMP("BDProductTransSeqNum")
	i '$l(BDBloodComponentDRStr)  s Ret="-1^输入信息错误"
	f i=1:1:$l(BDBloodComponentDRStr,"^") d
	.s BDBloodComponentDR=$p(BDBloodComponentDRStr,"^",i)
	.i BDBloodComponentDR="" q
	.s BloodComponentData=$g(^dbo.BBBloodComponentsD(BDBloodComponentDR))
	.s TransSeqNum=$lg(BloodComponentData,12)
	.s CName=$lg(BloodComponentData,3)
	.s ^TMP("BDProductTransSeqNum",TransSeqNum)=CName
	
	s count=""
	f  s count=$o(^TMP("BDProductTransSeqNum",count)) q:count=""  d
	.s BDProductName=$g(^TMP("BDProductTransSeqNum",count))
	.s Ret=Ret_BDProductName_";"
	q Ret
}

/// 获取血产品输注时长 
/// 入参：血袋条码PackCode ,血产品码PackBarcode
/// 返回：输注最长时长，单位H
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetBDProductTransSeqNumInfo("1")
ClassMethod GetBDProductTransHourInfo(PackCode As %String, PackBarcode As %String, InfusionStartDate As %String, InfusionStartTime As %String, InfusionEndDate As %String, InfusionEndTime As %String)
{
	s LisNamespace = "DHC-LISDATA"
	s PackBarcode=$g(PackBarcode),PackCode=$g(PackCode)
	i '$l(PackBarcode)  s Ret="-1^输入信息错误" q Ret
	i '$l(PackCode)  s Ret="-1^输入信息错误" q Ret
	s Ret=""
	i $l(InfusionEndDate) s InfusionEndDate=$tr(InfusionEndDate,"-","") 
	i $l(InfusionStartDate) s InfusionStartDate=$tr(InfusionStartDate,"-","") 
	s InfusionStartTime=$zth(InfusionStartTime)
	s InfusionEndTime=$zth(InfusionEndTime)
	s PackDR=$o(^dbo.BDPackI("IndexBarcode",PackCode,PackBarcode,"")) 
	s PackInfo=$g(^dbo.BDPackD(PackDR))
	s BloodProductDR=$lg(PackInfo)
	i '$l(BloodProductDR) s Ret="-1^未找到血液信息" q Ret
	s TransHours=$lg($g(^dbo.BBBloodProductD(BloodProductDR)),31)
	i $l(InfusionEndDate),$l(InfusionStartDate) d
	.i InfusionEndDate=InfusionStartDate d
	..s UseHour=InfusionEndTime-InfusionStartTime
	..i (UseHour>(TransHours*3600)) d
	...s leftHour=(UseHour-(TransHours*3600))
	...s leftHour=$zt(leftHour),ret="该血产品最长输注时长为："_TransHours_"H,已超时"_leftHour
	.e  d
	..s leftDate=InfusionEndDate-InfusionStartDate
	..s UseHour=(InfusionEndTime+(leftDate*24*3600))-InfusionStartTime
	..i (UseHour>(TransHours*3600)) d
	...s leftHour=(UseHour-(TransHours*3600))
	...s leftHour=$zt(leftHour),ret="该血产品最长输注时长为："_TransHours_"H,已超时"_leftHour
	e  d
	.s Ret="该血产品最长输注时长为："_TransHours_"H"
	q Ret
}

/// 获取血产品滞留时长提示
/// 入参：血袋条码PackCode ,血产品码PackBarcode
/// 返回：输注最长时长，单位H
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetBDProductTransSeqNumInfo("1")
ClassMethod GetBDProductHoldHourInfo(PackCode As %String, PackBarcode As %String, InfusionStartDate As %String, InfusionStartTime As %String, ReceiveDate As %String, ReceiveTime As %String)
{
	s LisNamespace = "DHC-LISDATA"
	s PackBarcode=$g(PackBarcode),PackCode=$g(PackCode)
	i '$l(PackBarcode)  s Ret="-1^输入信息错误" q Ret
	i '$l(PackCode)  s Ret="-1^输入信息错误" q Ret
	s Ret=""
	i $l(ReceiveDate) s ReceiveDate=$tr(ReceiveDate,"-","") 
	i $l(InfusionStartDate) s InfusionStartDate=$tr(InfusionStartDate,"-","")
	s InfusionStartTime=$zth(InfusionStartTime)
	s ReceiveTime=$zth(ReceiveTime) 
	s PackDR=$o(^dbo.BDPackI("IndexBarcode",PackCode,PackBarcode,"")) 
	s PackInfo=$g(^dbo.BDPackD(PackDR))
	s StockOutDate=$lg(PackInfo,54)
	s StockOutTime=$lg(PackInfo,55)  //出库时间
	s BloodProductDR=$lg(PackInfo,3)
	i '$l(BloodProductDR) s Ret="-1^未找到血液信息" q Ret
	s HoldHours=$lg($g(^dbo.BBBloodProductD(BloodProductDR)),9)
	i $l(ReceiveDate),$l(StockOutDate) d
	.i StockOutDate=ReceiveDate d
	..s UseHour=ReceiveTime-StockOutTime
	..i (UseHour>(HoldHours*3600)) d
	...s leftHour=(UseHour-(HoldHours*3600))
	...s leftHour=$zt(leftHour),ret="血制品解冻后，最长滞留时间为"_HoldHours_"H,现已超时"_leftHour
	.e  d
	..s leftDate=ReceiveDate-StockOutDate
	..s UseHour=(ReceiveTime+(leftDate*24*3600))-StockOutTime
	..i (UseHour>(HoldHours*3600)) d
	...s leftHour=(UseHour-(HoldHours*3600))
	...s leftHour=$zt(leftHour),ret="血制品解冻后，最长滞留时间为"_TransHours_"H,已超时"_leftHour
	e  i $l(InfusionStartDate),$l(StockOutDate) d
	.i StockOutDate=InfusionStartDate d
	..s UseHour=InfusionStartTime-StockOutTime
	..i (UseHour>(HoldHours*3600)) d
	...s leftHour=(UseHour-(HoldHours*3600))
	...s leftHour=$zt(leftHour),ret="血制品解冻后，最长滞留时间为"_HoldHours_"H,现已超时"_leftHour
	.e  d
	..s leftDate=InfusionStartDate-StockOutDate
	..s UseHour=(InfusionStartTime+(leftDate*24*3600))-StockOutTime
	..i (UseHour>(HoldHours*3600)) d
	...s leftHour=(UseHour-(HoldHours*3600))
	...s leftHour=$zt(leftHour),ret="血制品解冻后，最长滞留时间为"_TransHours_"H,已超时"_leftHour

	q Ret
}

/// 查询不良反应信息
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetAdverseReactionInfo("1")
ClassMethod GetAdverseReactionInfo(ReactionNo As %String, ReactionDR As %String)
{
	s LisNamespace = "DHC-LISDATA"
	i '$l(ReactionDR),$l(ReactionNo) d
	.s ReactionDR = $o(^[LisNamespace]dbo.BDAdverseReactionI("IndexRecordNo"," "_ReactionNo,""))
	
	i '$l(ReactionDR) q ""
	
	//获取不良反应信息
	s AdverseReactionData = $g(^[LisNamespace]dbo.BDAdverseReactionD(ReactionDR))
	
	//填报日期AddDate,时间AddTime
	s AddDate = $lg(AdverseReactionData,6)
	i $l(AddDate) s AddDate = $e(AddDate,1,4)_"_"_$e(AddDate,5,6)_"-"_$e(AddDate,7,8)
	s AddTime = $lg(AdverseReactionData,7)
	i $l(AddTime) s AddTime = $zt(AddTime)
	
	//报告人工号AddUserCode
	s AddUserDR = $lg(AdverseReactionData,8)
	s AddUserCode=""
	i $l(AddUserDR) s AddUserCode = $lg($g(^[LisNamespace]dbo.SYSUserD(AddUserDR),2))
	
	//病案号、登记号、姓名
	s MedicalRecordNo = $lg(AdverseReactionData,10)
	s RegNo = $lg(AdverseReactionData,9)
	s SurName = $lg(AdverseReactionData,11)
	
	//性别、年龄、身份证号
	s SpeciesDR = $lg(AdverseReactionData,13),patSex=""
	i $l(SpeciesDR) s patSex=$lg($g(^[LisNamespace]dbo.BTSpeciesD(SpeciesDR)),3)
	s Age=$lg(AdverseReactionData,14)
    s AgeUnitDR=$lg(AdverseReactionData,15),AgeUnit=""
	i $l(AgeUnitDR) s AgeUnit=$lg($g(^[LisNamespace]dbo.BTAgeUnitD(AgeUnitDR)),3)
	s PatAge=Age_AgeUnit
	s IDNumber = $lg(AdverseReactionData,18)
	
	//病区
	s WardDR = $lg(AdverseReactionData,25),Ward="",WardCode=""
	I $L(WardDR),$D(^[LisNamespace]dbo.BTWardD(WardDR)) S Ward=$LG($G(^[LisNamespace]dbo.BTWardD(WardDR)),3) S WardCode=$LG($G(^[LisNamespace]dbo.BTWardD(WardDR)),2)
	
	//输血史
	s IsTransHistory = $lg(AdverseReactionData,30)
	
	//输血反应史
	s IsUntowardEffect = $lg(AdverseReactionData,32)
	
	//血型，RH
	s ABODR=$lg(AdverseReactionData,19),ABOType=""
    i $l(ABODR) s ABOType=$lg($g(^[LisNamespace]dbo.BTABOBGD(ABODR)),2)
    s RHDR=$lg(AdverseReactionData,20),RHType=""
    i $l(RHDR) s RHType=$lg($g(^[LisNamespace]dbo.BTRHBGD(RHDR)),3)
    
    //抗体筛查
    s UnexpectedScreening = $lg(AdverseReactionData,43)
    
    //本次输血血型相关根据血袋去查询，默认第一个相关的血袋、此处包括查询血液类别
    s (TransfusionABOType,TransfusionRHType,BloodComponentsCode,BloodComponentsName) =""
    s PackDR = ""
    for {
	    s PackDR = $o(^[LisNamespace]dbo.BDReactionLinkPackI("IndexMaster",ReactionDR,PackDR))
	    q:PackDR=""
	    s PackData = $g(^[LisNamespace]dbo.BDPackD(PackDR))
	    s TransfusionBloodGroupDR = $lg(PackData,9)
	    s TransfusionBloodGroupABO = $lg(^[LisNamespace]dbo.BBBloodGroupD(TransfusionBloodGroupDR),4)
	    s TransfusionABOType = TransfusionBloodGroupABO
	    i TransfusionBloodGroupABO ="U" s TransfusionABOType="未知"
	    s TransfusionBloodGroupRH = $lg(^[LisNamespace]dbo.BBBloodGroupD(TransfusionBloodGroupDR),5)
	    i TransfusionBloodGroupRH="P" s TransfusionRHType="阳"
	    e  i TransfusionBloodGroupRH="N" s TransfusionRHType="阴"
	    e  s TransfusionRHType="未知"
	    s BloodProductDR= $lg(PackData,3)
	    s BloodComponentsDR = $lg(^[LisNamespace]dbo.BBBloodProductD(BloodProductDR),10)
	    s BloodComponentsCode = $lg(^[LisNamespace]dbo.BBBloodComponentsD(BloodComponentsDR),2)
	    s BloodComponentsName = $lg(^[LisNamespace]dbo.BBBloodComponentsD(BloodComponentsDR),3)
    }
    
    //剩余量、体温、脉搏、血压、呼吸
    s LeftVolume = $lg(AdverseReactionData,59)
    s Temperature = $lg(AdverseReactionData,44)
    s Pulse = $lg(AdverseReactionData,45)
    s HighPressure = $lg(AdverseReactionData,46)
    s LowPressure = $lg(AdverseReactionData,47)
    s Breathing = $lg(AdverseReactionData,79)
    
    //用药信息
    s IsDrugHistory = $lg(AdverseReactionData,38)
    s DrugList = $lg(AdverseReactionData,39)
    
    //本次输血开始日期、时间、停止日期、时间、输血者工号
    s StartTransfusionDate = $lg(AdverseReactionData,49)
    i $l(StartTransfusionDate) s StartTransfusionDate = $e(StartTransfusionDate,1,4)_"_"_$e(StartTransfusionDate,5,6)_"-"_$e(StartTransfusionDate,7,8)
    s StartTransfusionTime = $lg(AdverseReactionData,50)
    i $l(StartTransfusionTime) s StartTransfusionTime = $zt(StartTransfusionTime)
    s StopTransfusionDate = $lg(AdverseReactionData,51)
    i $l(StopTransfusionDate) s StopTransfusionDate = $e(StopTransfusionDate,1,4)_"_"_$e(StopTransfusionDate,5,6)_"-"_$e(StopTransfusionDate,7,8)
    s StopTransfusionTime = $lg(AdverseReactionData,52)
    i $l(StopTransfusionTime) s StopTransfusionTime = $zt(StopTransfusionTime)
    s TransfusionUserDR = $lg(AdverseReactionData,53)
    s TransfusionUserCode=""
    i $l(TransfusionUserDR) s TransfusionUserCode = $lg($g(^[LisNamespace]dbo.SYSUserD(TransfusionUserDR),2))
    
    //输血反应开始日期时间、发现反应者工号
    s AdverseReactionDate = $lg(AdverseReactionData,54)
    i $l(AdverseReactionDate) s AdverseReactionDate = $e(AdverseReactionDate,1,4)_"_"_$e(AdverseReactionDate,5,6)_"-"_$e(AdverseReactionDate,7,8)
    s AdverseReactionTime = $lg(AdverseReactionData,55)
    i $l(AdverseReactionTime) s AdverseReactionTime = $zt(AdverseReactionTime)
    s AdverseReactionFindUserDR = $lg(AdverseReactionData,56)
    s AdverseReactionFindUserCode=""
    i $l(AdverseReactionFindUserDR) s AdverseReactionFindUserCode = $lg($g(^[LisNamespace]dbo.SYSUserD(AdverseReactionFindUserDR),2))
    
    //输血厂家批号
    s TransfusionMachine = $lg(AdverseReactionData,58)
    
   	//严重程度、结果、结果关联
   	s ResultSeverity = $lg(AdverseReactionData,77)
   	s ResultRelated = $lg(AdverseReactionData,78)
   	s ResultIn = $lg(AdverseReactionData,62)
   	s ResultNote = $lg(AdverseReactionData,65)
   	
   	//如果结果为死亡，则不良反应结果日期为死亡日期
   	s (DeadDate,DeadTime)=""
   	i ResultIn="死亡" d
   	.s DeadDate = $lg(AdverseReactionData,63)
   	.i $l(DeadDate) s DeadDate = $e(DeadDate,1,4)_"_"_$e(DeadDate,5,6)_"-"_$e(DeadDate,7,8)
   	.s DeadTime = $lg(AdverseReactionData,64)
   	.i $l(DeadTime) s DeadTime = $zt(DeadTime)
   	
   	//临床处理
   	s ClinicalTreatment = $lg(AdverseReactionData,66)
   	
   	//诊断
   	s Diagnosis = $lg(AdverseReactionData,27)
   	
   	//不良反应表现
   	s RectionPerformance = $lg(AdverseReactionData,57)
   	
   	//数据拼接
   	s AdverseReport = AddDate_"^"_AddTime_"^"_AddUserCode_"^"_MedicalRecordNo_"^"_RegNo_"^"_SurName_"^"_patSex_"^"_PatAge
	s AdverseReport = AdverseReport_"^"_IDNumber_"^"_WardCode_"^"_IsTransHistory_"^"_IsUntowardEffect_"^"_ABOType_"^"_RHType
	s AdverseReport = AdverseReport_"^"_UnexpectedScreening_"^"_TransfusionABOType_"^"_TransfusionRHType_"^^"_Temperature
	s AdverseReport = AdverseReport_"^"_LowPressure_"^"_HighPressure_"^"_Pulse_"^"_Breathing_"^"_IsDrugHistory_"^"_DrugList
	s AdverseReport = AdverseReport_"^"_StartTransfusionDate_"^"_StartTransfusionTime_"^"_TransfusionUserCode_"^"_AdverseReactionDate
	s AdverseReport = AdverseReport_"^"_AdverseReactionTime_"^"_AdverseReactionFindUserCode_"^"_TransfusionMachine_"^"_ResultSeverity
	s AdverseReport = AdverseReport_"^"_ResultRelated_"^"_ResultIn_"^"_DeadDate_"^"_DeadTime_"^"_ResultRelated
	
	//表拼接
	s retStr = AdverseReport_$c(2)_Diagnosis_$c(2)_RectionPerformance_$c(2)_BloodComponentsName_"^"_BloodComponentsCode
	q retStr
}

/// 获取病人手术信息
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetPatientOperationInfoNew("53304628")
ClassMethod GetPatientOperationInfoNew(AdmNo) As %String
{
	 s count=0
	 s resultString=""
	 i '$l(AdmNo) q ""
	 s ret=##class(web.DHCANAdaptor).GetANOperation("","",AdmNo,"","ARILPF","","")

	 Set reader = ##class(%XML.Reader).%New()
	 Do reader.OpenStream(ret)
	 Do reader.Correlate("PatInfo","web.DHCANInterface")
	 s RetStr=""
	 k ^TMP($zn,$j,"DHCLIS.DHCBloodInterface","GetPatientOperationInfo",AdmNo)
	 s thisDate=$p($h,",",1)
	 While (reader.Next(.object,.sc)) {
		 //w AdmNo,"^^",object.PatName,"^^",$TR(object.OpDate,"-"),"^^",object.OpaId,"^^",object.ANAOPSurgeon,"^^",object.OpName,"^^",object.ANASourceTypeDesc,!
		 s state="N"
		 s sighDate=""
		 s EpisodeName="" 
		 s InformDoctor=""  //洽谈医生
		 s ExcisionCondition="" //切除情况
		 s MainDiagnose="" //主要诊断
		 s ExcisionDept="" // 部位
		 //i object.EpisodeID'=""  d
		 i sighDate'="" s sighDate=$zd(sighDate,3)
		 ;w state_isConfim,! _object.OpDate_"^^"_
		 i '$l(object.OpDate) continue
		 s OperateDate = $ZDH(object.OpDate,3)
		 s OperateDateDT = $p(object.OpTime,"~",1)
		 //i thisDate>OperateDate continue
		 s ^TMP($zn,$j,"DHCLIS.DHCBloodInterface","GetPatientOperationInfo",AdmNo,OperateDate,count)=$TR(object.OpDate,"-")_"^^"_object.OpaId_"^^"_object.ANAOPSurgeonCode_"^^"_object.ANAOPSurgeon_"^^"_object.OpName_"^^"_object.ANASourceTypeDesc_"^^"_object.OperId_"^^"_object.OplevelCode
		 s count=count+1
	 }
	 s OperateDate=""
	 for {
		  s OperateDate=$o(^TMP($zn,$j,"DHCLIS.DHCBloodInterface","GetPatientOperationInfo",AdmNo,OperateDate),-1)
		  q:OperateDate=""
		  s order=""
		  for {
			  s order=$o(^TMP($zn,$j,"DHCLIS.DHCBloodInterface","GetPatientOperationInfo",AdmNo,OperateDate,order))
		  	  q:order=""
		  	  s RetStr = RetStr_"@@"_^TMP($zn,$j,"DHCLIS.DHCBloodInterface","GetPatientOperationInfo",AdmNo,OperateDate,order)
		  }
	 }
	 k ^TMP($zn,$j,"DHCLIS.DHCBloodInterface","GetPatientOperationInfo",AdmNo)
	 q RetStr
}

/// 根据就诊号查询本次就诊的所发血单信息：入参（就诊id），出参（发血单id ^ 发放日期 ^ 发放时间 ^ 是否有继往输血史@上次输血日期 ^ 是否有输血反应史@不良反应说明 ^ 是否孕产史@孕次@产次）
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetPackIssueInfo("47862")
ClassMethod GetPackIssueInfo(AdmNo As %String)
{
	s LisNamespace = "DHC-LISDATA"
	s retStr=""
	s BDReqFormDR="" f  s BDReqFormDR= $o(^[LisNamespace]dbo.BDReqFormI("IndexAdmNo"," "_AdmNo,BDReqFormDR)) q:(BDReqFormDR="")  d
    .s BDReqFormData=$g(^[LisNamespace]dbo.BDReqFormD(BDReqFormDR))
    .s ReqFormNo=$lg(BDReqFormData,2)
    .s IsTransHistory=$lg(BDReqFormData,27)
    .s LastTransDate=$lg(BDReqFormData,28)
    .s IsUntowardEffect=$lg(BDReqFormData,29)
    .s UntowardEffectNote=$lg(BDReqFormData,30)
    .s IsPregHistory=$lg(BDReqFormData,37)
    .s Pregnancies=$lg(BDReqFormData,38)
    .s ChildBirths=$lg(BDReqFormData,39)
    .s IssueRecordDR="" f  s IssueRecordDR= $o(^[LisNamespace]dbo.BDIssueRecordI("IndexReqForm",BDReqFormDR,IssueRecordDR)) q:(IssueRecordDR="")  d
    ..s IssueRecordData=$g(^[LisNamespace]dbo.BDIssueRecordD(IssueRecordDR))
    ..s flag=""
    ..s packDR="" f  s packDR=$o(^[LisNamespace]dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,packDR)) q:(packDR="")||$l(flag)  d
	...s BDIssueRecordItemsDR=$o(^[LisNamespace]dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,packDR,""))
	...s IsReturned=$lg($g(^[LisNamespace]dbo.BDIssueRecordItemsD(BDIssueRecordItemsDR)),4)
	...i IsReturned="1" q
	...s flag="1"
	..i '$L(flag) q
    ..s IssueDate=$lg(IssueRecordData,4)
    ..s IssueDate=$e(IssueDate,1,4)_"-"_$e(IssueDate,5,6)_"-"_$e(IssueDate,7,8)
    ..s IssueTime=$lg(IssueRecordData,5)
    ..s IssueTime=$zt(IssueTime)
    ..i '$l(retStr) d
    ...s retStr=ReqFormNo_"^"_IssueDate_"^"_IssueTime_"^"_IsTransHistory_"@"_LastTransDate_"^"_IsUntowardEffect_"@"_UntowardEffectNote_"^"_IsPregHistory_"@"_Pregnancies_"@"_ChildBirths_"^"_IssueRecordDR
    ..e  d
    ...s retStr =retStr_"$$"_ReqFormNo_"^"_IssueDate_"^"_IssueTime_"^"_IsTransHistory_"@"_LastTransDate_"^"_IsUntowardEffect_"@"_UntowardEffectNote_"^"_IsPregHistory_"@"_Pregnancies_"@"_ChildBirths_"^"_IssueRecordDR
	q retStr
}

/// 根据就诊号查询本次就诊的所发血单信息：入参（发血单id），出参（血袋编号 ^ 血袋描述(血产品)^血型^配血方法^血袋血量^输血开始日期^输血开始时间^输血结束日期^输血结束时间 ）若多条数据，以 $$ 进行分割
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetPackInfoByIssueId("50")
ClassMethod GetPackInfoByIssueId(BDIssueRecordDR As %String)
{
	s LisNamespace = "DHC-LISDATA"
	s retStr="" 
	s packDR="" f  s packDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",BDIssueRecordDR,packDR)) q:(packDR="")  d
	.s BDIssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",BDIssueRecordDR,packDR,""))
	.s XMPlanDR=$lg($g(^dbo.BDIssueRecordItemsD(BDIssueRecordItemsDR)),6)
	.s IsReturned=$lg($g(^dbo.BDIssueRecordItemsD(BDIssueRecordItemsDR)),4)
	.i IsReturned="1" q
	.s packData=$g(^dbo.BDPackD(packDR))
	.s packID=$lg(packData,2)
	.s BloodProductDR=$lg(packData,3)
	.s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
	.s BloodProductCode=$lg(BloodProductData,2)
	.s BloodProductName=$lg(BloodProductData,3)
	.s BloodGroupDR=$lg(packData,9)
	.s InfusionStartDate=$lg(packData,62)
	.i $l(InfusionStartDate) s InfusionStartDate=$e(InfusionStartDate,1,4)_"-"_$e(InfusionStartDate,5,6)_"-"_$e(InfusionStartDate,7,8)
	.s InfusionStartTime=$lg(packData,63)
	.i $l(InfusionStartTime) s InfusionStartTime=$zt(InfusionStartTime)
	.s InfusionEndDate=$lg(packData,66)
	.i $l(InfusionEndDate) s InfusionEndDate=$e(InfusionEndDate,1,4)_"-"_$e(InfusionEndDate,5,6)_"-"_$e(InfusionEndDate,7,8)
	.s InfusionEndTime=$lg(packData,67)
	.i $l(InfusionEndTime) s InfusionEndTime=$zt(InfusionEndTime)
	.s BDType=$lg($g(^dbo.BBBloodGroupD(BloodGroupDR)),3)
    .s PackSize=$lg(packData,10)
    .s Units=$lg(BloodProductData,15)
	.s packVolumn=PackSize_Units 
	.s XMMethodDR=$lg($g(^dbo.BDXMPlanD(XMPlanDR)),22),XMMethod=""
	.i $l(XMMethodDR) s XMMethod=$lg($g(^dbo.BBXMMethodD(XMMethodDR)),3)
	.s XMPlanNo=$lg($g(^dbo.BDXMPlanD(XMPlanDR)),26)
	.s XMLastResult=$lg($g(^dbo.BDXMPlanD(XMPlanDR)),24)
	.s IsIssued=$lg($g(^dbo.BDXMPlanD(XMPlanDR)),32)
	.i IsIssued="0" q  
    .i '$l(retStr) d
    ..s retStr=packID_"^"_BloodProductName_"^"_BDType_"^"_XMMethod_"^"_packVolumn_"^"_InfusionStartDate_"^"_InfusionStartTime_"^"_InfusionEndDate_"^"_InfusionEndTime
    .e  d
    ..s retStr =retStr_"$$"_packID_"^"_BloodProductName_"^"_BDType_"^"_XMMethod_"^"_packVolumn_"^"_InfusionStartDate_"^"_InfusionStartTime_"^"_InfusionEndDate_"^"_InfusionEndTime
	q retStr
}

/// w ##class(DHCLIS.DHCBloodInterface).QryBloodPatByWardDR(4381)
/// Creator：      
/// CreatDate：    20180228
/// Description:： 根据病区查询输血病人列表
/// Table：        
/// Input：        病区DR
/// Output：     输血病人admno列表    
/// Return：       
/// Others： 
ClassMethod QryBloodPatByWardDR(wardDR As %Integer)
{
	s admids=##Class(web.YGRHCommon).GetEpisodeIDByWard(wardDR)
	s WebNamespace="DHC-APP"
	s LisNamespace = "DHC-LISDATA"
	s newadmids="" 
	f i=1:1:$l(admids,"^")  { 
	 s admid=$p(admids,"^",i) 
	 s PAADMPAPMIDR=$p(^[WebNamespace]PAADM(admid),"^",1)
	 s RegNo=$p(^[WebNamespace]PAPER(PAADMPAPMIDR,"PAT",1),"^",2)
	 s IssueRecordDR="",Flag=0
	 for{
		s IssueRecordDR=$o(^[LisNamespace]dbo.BDIssueRecordI("IndexRegNo",$c(32)_RegNo,IssueRecordDR))
		q:IssueRecordDR=""
		s PackDR=""
		for{
			s PackDR=$o(^[LisNamespace]dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR))
			q:PackDR=""
			s RecordItemsDR=""
			for{
				s RecordItemsDR=$o(^[LisNamespace]dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,RecordItemsDR))
				q:RecordItemsDR=""
				s IsReturned=$lg($g(^[LisNamespace]dbo.BDIssueRecordItemsD(RecordItemsDR)),4)
				i IsReturned=1 continue
				i '$l(newadmids) {
				  s newadmids=admid
				}
				else
				{
			      s newadmids=newadmids_"^"_admid
				}
			    s Flag="1"
			    q
			}
		    i Flag="1" q
		}
		i Flag="1" q
	  }
	}
	q newadmids
}

// 根据血袋编号查询血液和病人信息：入参（血袋条码(需前台处理，去掉特殊字符)，产品码），出参（ 病人姓名^性别^年龄^病区^就诊号^住院号^血型^血袋条码^血液品种^血量^有效期^血液及血制品外观^交叉配血结果） 

/// w ##CLASS(DHCLIS.DHCBloodInterface).GetPatReqBldProductByLabNo("1609220001")
ClassMethod GetPatReqBldProductByLabNo(LabNo As %String, Output retStr As %String(MAXLEN=32767))
{
	s LabNo=$g(LabNo)
	s OrdItmId=""
    i $d(^OEORD(0,"EpisNo",LabNo)) d
    .s OrdItmId=$o(^OEORD(0,"EpisNo",LabNo,"")) 
    .s OrdItmSubId=$o(^OEORD(0,"EpisNo",LabNo,OrdItmId,"")) 
    .s OrdItmId=OrdItmId_"||"_OrdItmSubId
    s ReqProduct=""
	s LisNamespace = "DHC-LISDATA"
	zn LisNamespace
	s retStr=""  
	i '$l(OrdItmId) s retStr="-1^未查询到检验号" Q retStr 
	s ReqFormCostItemDR=$o(^dbo.BDReqFormCostItemI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OrdItmId),""),-1)
	i '$l(ReqFormCostItemDR) s retStr="-1^未查询到检验号关联病人收费信息" Q retStr 
	s ReqFormCostItemData=$g(^dbo.BDReqFormCostItemD(ReqFormCostItemDR))
	s ReqFormDR=$lg(ReqFormCostItemData,2)
	i '$l(ReqFormDR) s retStr="-1^未查询到病人申请单信息" Q retStr
	s ReqFormData=$g(^dbo.BDReqFormD(ReqFormDR))
	s AdmNo=$lg(ReqFormData,4)
	s SurName=$lg(ReqFormData,10)
 	s GivenName=$lg(ReqFormData,11)
	i SurName=GivenName s PatName=SurName
	e  s PatName=SurName_GivenName
	s SpeciesDR=$lg(ReqFormData,12),patSex="" 
    i $l(SpeciesDR) s patSex=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),3)
	s Age=$lg(ReqFormData,13)
    s AgeUnitDR=$lg(ReqFormData,14),AgeUnit=""
	i $l(AgeUnitDR) s AgeUnit=$lg($g(^dbo.BTAgeUnitD(AgeUnitDR)),3)
	s PatAge=Age_AgeUnit
	s WardDR = $lg(ReqFormData,24),WardDesc=""
    I $L(WardDR),$D(^dbo.BTWardD(WardDR)) S WardData=$G(^dbo.BTWardD(WardDR)) S WardDesc=$LG(WardData,3)
	s MedicalRecordNo = $lg(ReqFormData,9)
	s ReqProductDR=""  f  s ReqProductDR= $o(^dbo.BDReqFormProductI("IndexMaster",ReqFormDR,ReqProductDR)) q:(ReqProductDR="")  d
	.s ReqFormProductDR= $o(^dbo.BDReqFormProductI("IndexMaster",ReqFormDR,ReqProductDR,""),-1)
	.s ReqFormProductData=$g(^dbo.BDReqFormProductD(ReqFormProductDR))
	.s ReqBloodGroupDR=$lg(ReqFormProductData,9)
	.s BloodGroupData=$g(^dbo.BBBloodGroupD(ReqBloodGroupDR))
	.s BloodGroupName=$lg(BloodGroupData,3)
	.s BloodProductData=$g(^dbo.BBReqProductD(ReqProductDR))
	.s BloodProductName=$lg(BloodProductData,3)
	.s Volumn=$lg(ReqFormProductData,5)
	.s Unit=$lg(ReqFormProductData,6)
	.s ReqVol=Volumn_Unit
	.i $l(ReqProduct) d
	..s ReqProduct=ReqProduct_"$$"_BloodGroupName_"@"_BloodProductName_"@"_ReqVol
	.e  d
	..s ReqProduct=BloodGroupName_"@"_BloodProductName_"@"_ReqVol
	 
    i '$l(retStr) d
    .s retStr=PatName_"^"_patSex_"^"_PatAge_"^"_WardDesc_"^"_AdmNo_"^"_MedicalRecordNo_"^"_ReqProduct
    q retStr
}

/// 根据就诊号查询本次就诊的所发血单信息：入参（就诊id），出参（血液成分1：血量/血液成分2:血量）
/// w ##CLASS(DHCLIS.DHCBloodInterface).StateBldComponentByAdmNo("47862")
ClassMethod StateBldComponentByAdmNo(AdmNo As %String)
{
	s LisNamespace = "DHC-LISDATA"
	s retStr=""
	k ^TMP($zn,$i,$j)
	s BDReqFormDR="" f  s BDReqFormDR= $o(^[LisNamespace]dbo.BDReqFormI("IndexAdmNo"," "_AdmNo,BDReqFormDR)) q:(BDReqFormDR="")  d
    .s IssueRecordDR="" f  s IssueRecordDR= $o(^[LisNamespace]dbo.BDIssueRecordI("IndexReqForm",BDReqFormDR,IssueRecordDR)) q:(IssueRecordDR="")  d
    ..s packDR="" f  s packDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,packDR)) q:(packDR="")  d
	...s BDIssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,packDR,""))
	...s IsReturned=$lg($g(^dbo.BDIssueRecordItemsD(BDIssueRecordItemsDR)),4)
	...i IsReturned="1" q
	...s packData=$g(^dbo.BDPackD(packDR)) 
	...s BloodProductDR=$lg(packData,3)
	...s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
	...s BloodComponentsDR=$lg(BloodProductData,10) 
    ...s packVolumn=$lg(packData,10) 
    ...s Units=$lg(BloodProductData,15) 
	...s ^TMP($zn,$i,$j,"StateComponent",BloodComponentsDR,Units)=packVolumn+$g(^TMP($zn,$i,$j,"StateComponent",BloodComponentsDR,Units))
	 
	s BloodComponentsCode="" f  s BloodComponentsCode=$o(^dbo.BBBloodComponentsI("IndexCode",BloodComponentsCode)) q:BloodComponentsCode=""  d
	.s BloodComponentsDR=$o(^dbo.BBBloodComponentsI("IndexCode",BloodComponentsCode,""))
	.s Units=$o(^TMP($zn,$i,$j,"StateComponent",BloodComponentsDR,""))
	.s BloodComponentsData=$g(^dbo.BBBloodComponentsD(BloodComponentsDR))
	.s BloodComponentsName=$lg(BloodComponentsData,3)
	.s ComponentTotal=0
	.i $d(^TMP($zn,$i,$j,"StateComponent",BloodComponentsDR)) s ComponentTotal=^TMP($zn,$i,$j,"StateComponent",BloodComponentsDR,Units)
    .i '$l(retStr) d
    ..s retStr=BloodComponentsName_":"_ComponentTotal_Units
    .e  d
    ..s retStr =retStr_"/"_BloodComponentsName_":"_ComponentTotal_Units
	q retStr
}

/// 根据就诊号查询本次就诊的所发血记录信息：入参（就诊id），出参（预定用血时间^申请医师^审核医师^发血人^发血时间^发血血袋的血袋编号^血型复查的结果^检验技师^复审人）
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetPackIssueByAdm("569")
ClassMethod GetPackIssueByAdm(AdmNo As %String)
{
	s LisNamespace = "DHC-LISDATA"
	s retStr=""
	s BDReqFormDR="" f  s BDReqFormDR= $o(^[LisNamespace]dbo.BDReqFormI("IndexAdmNo"," "_AdmNo,BDReqFormDR)) q:(BDReqFormDR="")  d
    .s BDReqFormData=$g(^[LisNamespace]dbo.BDReqFormD(BDReqFormDR)) 
    .s RegNo=$lg(BDReqFormData,8)
    .s BookDate=$lg(BDReqFormData,40)
    .s BookTime=$lg(BDReqFormData,81)
    .s BookTime=$zt(BookTime)
    .s BookTimestr=$e(BookDate,1,4)_"-"_$e(BookDate,5,6)_"-"_$e(BookDate,7,8)_" "_BookTime
    .s CheckUserName="" 
    .s issuePack=""
   	.s AddUserDR=$lg(BDReqFormData,7),AddUser=""
	.i $l(AddUserDR) s AddUser=$lg($g(^dbo.SYSUserD(AddUserDR)),3)
    .s CheckUserDR=$lg(BDReqFormData,65) 
    .i $l(CheckUserDR) s CheckUserName=$lg($g(^dbo.SYSUserD(CheckUserDR)),3) 
    .s ABOTypeInfo=##class(BLD.WS.BLL.DHCTCResult).GetTCResultByRegNoMTHD(RegNo,"ABO","BLD","")
    .s RHTypeInfo=##class(BLD.WS.BLL.DHCTCResult).GetTCResultByRegNoMTHD(RegNo,"RH","BLD","")
    .i $l(ABOTypeInfo) s ABOType=$tr($p($p(ABOTypeInfo,",",6),":",2),"”""“""}'")
    .i $l(RHTypeInfo) s RHType=$tr($p($p(RHTypeInfo,",",6),":",2),"”""“""}()+-'")
    .s EntryUserName=$tr($p($p(ABOTypeInfo,",",7),":",2),"”""“""}'")
    .s AuthUserName=$tr($p($p(ABOTypeInfo,",",8),":",2),"”""“""}'") 
    .s IssueRecordDR="" f  s IssueRecordDR= $o(^[LisNamespace]dbo.BDIssueRecordI("IndexReqForm",BDReqFormDR,IssueRecordDR)) q:(IssueRecordDR="")  d
    ..s IssueRecordData=$g(^[LisNamespace]dbo.BDIssueRecordD(IssueRecordDR))
    ..s IssueUserDR= $lg(IssueRecordData,6),IssueUser=""
	..i $l(IssueUserDR) s IssueUser=$lg(^dbo.SYSUserD(IssueUserDR),3)
    ..s Status=$lg(IssueRecordData,12) 
    ..s IssueDate=$lg(IssueRecordData,4)
    ..s IssueDate=$e(IssueDate,1,4)_"-"_$e(IssueDate,5,6)_"-"_$e(IssueDate,7,8)
    ..s IssueTime=$lg(IssueRecordData,5)
    ..s IssueTime=$zt(IssueTime)
    ..s IssueTimestr=IssueDate_" "_IssueTime
    ..s issuePack="" 
    ..s retpackinfo=""
    ..s packDR="" f  s packDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,packDR)) q:(packDR="")  d
	...s BDIssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,packDR,""))
	...s XMPlanDR=$lg($g(^dbo.BDIssueRecordItemsD(BDIssueRecordItemsDR)),6)
	...s IsReturned=$lg($g(^dbo.BDIssueRecordItemsD(BDIssueRecordItemsDR)),4)
	...i IsReturned="1" q
	...s packData=$g(^dbo.BDPackD(packDR))
	...s packID=$lg(packData,2)
	...s retpackinfo=##class(Nur.BloodBagRecive).GetBloodInfoBypPackDR(packDR)  
	...//i '$l(issuePack) d
	...s issuePack=packID  
	...i '$l(issuePack) q 
    ...i '$l(retStr) d
    ....s retStr=BookTimestr_"^"_AddUser_"^"_CheckUserName_"^"_IssueUser_"^"_IssueTimestr_"^"_issuePack_"^"_ABOType_RHType_"^"_EntryUserName_"^"_AuthUserName
   	...e  d
   	....s retStr=retStr_"$$"_BookTimestr_"^"_AddUser_"^"_CheckUserName_"^"_IssueUser_"^"_IssueTimestr_"^"_issuePack_"^"_ABOType_RHType_"^"_EntryUserName_"^"_AuthUserName
   	q retStr
}

// w ##CLASS(DHCLIS.DHCBloodInterface).QryExpireReqByRegNoExecute()

ClassMethod QryExpireReqByRegNoExecute()
{
    s LisNamespace = "DHC-LISDATA"
    s $NAMESPACE=LisNamespace
	s retStr=""
	s RegNo="" 
	 for{ 
	    s RegNo = $o(^dbo.BDReqFormI("IndexRegNo",RegNo))  
	    q:RegNo=""
		s ReqFormDR = ""
		for {
			s ReqFormDR = $o(^dbo.BDReqFormI("IndexRegNo",RegNo,ReqFormDR))
			q:ReqFormDR=""
			s ReqFormData = $g(^dbo.BDReqFormD(ReqFormDR))
			s ReqFormNo=$lg(ReqFormData,2)
			s Status=$lg(ReqFormData,51) 
			i Status'="35" continue
			s BookDate=$lg(ReqFormData,40)
			i '$l(BookDate) continue 
            s BookDate=$ZDateH(BookDate,5)  
            s BookTime=$lg(ReqFormData,81)
            s NowDate=$p($h,",",1)
            s NowTime=$p($h,",",2)
            i BookDate>NowDate continue
            i (BookDate=NowDate),(BookTime>NowTime) continue
            s IssueRecordDR="" 
            s ExpireReqFlag="1"
            for { 
              s IssueRecordDR=$o(^dbo.BDIssueRecordI("IndexReqForm",ReqFormDR,IssueRecordDR))
              q:IssueRecordDR="" 
              s PackDR="" 
              for
              {
	            s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR))
                q:PackDR=""
                s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
                s IssueRecordItemsData=$g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR))
                s IsReturned=$lg(IssueRecordItemsData,4)
                i IsReturned="0" s ExpireReqFlag="0" q 
              }  
            }
            i ExpireReqFlag="0" continue   
            i '$l(retStr) d 
            .s retStr=ReqFormNo   
            e  d   
            .s retStr=retStr_"^"_ReqFormNo 
		}
 	}
 	q retStr
}

/// 根据发血单号查询血液信息：入参（发血单号），出参（血液DR^血袋编号^血制品条码号 ^ 血袋描述(血产品)^血液血型^病人血型^配血方法^血袋血量 ）若多条数据，以 $$ 进行分割
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetPackInfoByIssueNo("ISS201705170001")
ClassMethod GetPackInfoByIssueNo(IssueRecordNo As %String)
{
	s LisNamespace="DHC-LISDATA"
	//s $NAMESPACE=LisNamespace
	s retStr="" 
	i '$l(IssueRecordNo) q "发血单号不能为空!"
	s BDIssueRecordDR=$o(^[LisNamespace]dbo.BDIssueRecordI("IndexMaster"," "_IssueRecordNo,""))
	i '$l(BDIssueRecordDR) q "未查询到发血单号！"
	s RegNo=$lg($g(^[LisNamespace]dbo.BDIssueRecordD(BDIssueRecordDR)),7)
	s packDR="" f  s packDR=$o(^[LisNamespace]dbo.BDIssueRecordItemsI("IndexMaster",BDIssueRecordDR,packDR)) q:(packDR="")  d
	.s BDIssueRecordItemsDR=$o(^[LisNamespace]dbo.BDIssueRecordItemsI("IndexMaster",BDIssueRecordDR,packDR,""))
	.s XMPlanDR=$lg($g(^[LisNamespace]dbo.BDIssueRecordItemsD(BDIssueRecordItemsDR)),6)
	.s IsReturned=$lg($g(^[LisNamespace]dbo.BDIssueRecordItemsD(BDIssueRecordItemsDR)),4)
	.i IsReturned="1" q
	.s packData=$g(^[LisNamespace]dbo.BDPackD(packDR))
	.s packID=$lg(packData,2) 
	.S ProductBarcode=$lg(packData,6)
	.s BloodProductDR=$lg(packData,3)
	.s BloodProductData=$g(^[LisNamespace]dbo.BBBloodProductD(BloodProductDR))
	.s BloodProductCode=$lg(BloodProductData,2)
	.s BloodProductName=$lg(BloodProductData,3)
	.s BloodGroupDR=$lg(packData,9)
	.s BDType=$lg($g(^[LisNamespace]dbo.BBBloodGroupD(BloodGroupDR)),3)
    .s PackSize=$lg(packData,10)
    .s Units=$lg(BloodProductData,15)
	.s packVolumn=PackSize_Units 
	.s ABOTypeInfo=##class(BLD.WS.BLL.DHCTCResult).GetTCResultByRegNoMTHD(RegNo,"ABO","BLD","")
    .s RHTypeInfo=##class(BLD.WS.BLL.DHCTCResult).GetTCResultByRegNoMTHD(RegNo,"RH","BLD","")
    .i $l(ABOTypeInfo) s ABOType=$tr($p($p(ABOTypeInfo,",",6),":",2),"”""“""}'")
    .i $l(RHTypeInfo) s RHType=$tr($p($p(RHTypeInfo,",",6),":",2),"”""“""}()+-'")
    
	.s XMMethodDR=$lg($g(^[LisNamespace]dbo.BDXMPlanD(XMPlanDR)),22),XMMethod=""
	.i $l(XMMethodDR) s XMMethod=$lg($g(^[LisNamespace]dbo.BBXMMethodD(XMMethodDR)),3)
	.s XMPlanNo=$lg($g(^[LisNamespace]dbo.BDXMPlanD(XMPlanDR)),26)
	.s XMLastResult=$lg($g(^[LisNamespace]dbo.BDXMPlanD(XMPlanDR)),24)
	.s IsIssued=$lg($g(^[LisNamespace]dbo.BDXMPlanD(XMPlanDR)),32)
	.i IsIssued="0" q  
    .i '$l(retStr) d
    ..s retStr=packDR_"^"_packID_"^"_ProductBarcode_"^"_BloodProductName_"^"_BDType_"^"_ABOType_RHType_"^"_XMMethod_"^"_packVolumn
    .e  d
    ..s retStr =retStr_"$$"_packDR_"^"_packID_"^"_ProductBarcode_"^"_BloodProductName_"^"_BDType_"^"_ABOType_RHType_"^"_XMMethod_"^"_packVolumn
	q retStr
}

/// Creator：      SZW
/// CreatDate：    20170629
/// Description:： 根据时间段获取患者输血史等信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       
/// Others：  
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBloodInterface","QryBldTransInfo","2016-04-02","2017-04-02","","","","","","","","","","",20,1,"106^10^^13^1")
Query QryBldTransInfo(StDate As %String, EndDate As %String) As %Query(ROWSPEC = "ORGCODE:%String,PATIENTID:%String,ID:%String,BLOODTRANSFCAUSE:%String,BLOODTYPE:%String,BLOOD:%String,BLOODTRANSFDTIME:%String") [ SqlProc ]
{
}

ClassMethod QryBldTransInfoExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	//Session数据
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
    //总数与分页
	s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
 	
 	s StDate = $tr(StDate,"-")
 	s EndDate = $tr(EndDate,"-")
 	s StDate = StDate -1
 	for {
 		s StDate = $o(^dbo.BDIssueRecordI("IndexIssueDate",StDate))
 		q:StDate>EndDate
 		q:StDate=""
 		s IssueRecordDR=""
 		for {
	 		s IssueRecordDR = $o(^dbo.BDIssueRecordI("IndexIssueDate",StDate,IssueRecordDR))
	 		q:IssueRecordDR=""
	 		s IssueRecordData = $g(^dbo.BDIssueRecordD(IssueRecordDR))
	 		//判断发血状态
	 		s IssueStatus = $lg(IssueRecordData,12)
	 		i IssueStatus'=1 continue
	 		
	 		s IssueTime = $lg(IssueRecordData,5)
	 		s ReqFormDR = $lg(IssueRecordData,11)
	 		s ReqFormData = $g(^dbo.BDReqFormD(ReqFormDR))
	 		
	 		//申请用血目的
	 		s ReqFormPurpose=""
	 		s ReqProductDR=""
		    for {
			    s ReqProductDR = $o(^dbo.BDReqFormProductI("IndexMaster",ReqFormDR,ReqProductDR))
			 	q:ReqProductDR=""
			 	s ReqFormProductDR = $o(^dbo.BDReqFormProductI("IndexMaster",ReqFormDR,ReqProductDR,""))
			 	s ReqFormProductData = $g(^dbo.BDReqFormProductD(ReqFormProductDR))
			 	
			 	s PurposeDR = $lg(ReqFormProductData,4)
			 	s Purpose = $lg(^dbo.BBPurposeD(PurposeDR),3)
			 	i ReqFormPurpose'[Purpose d 
			 	.s ReqFormPurpose=ReqFormPurpose_Purpose_$c(13,10)
			 	
		    }
	 		
	 		//登记号
	 		s RegNo = $lg(ReqFormData,8)
	 		
	 		//血型与血量
	 		s XMPlanDR = $lg(IssueRecordData,11)
	 		s PackDR=""
	 		s TransVolume=0
	 		s BLOODTYPE=5
	 		for{
		 		s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR))
		 		q:PackDR=""
		 		s BloodGroupDR = $lg(^dbo.BDPackD(PackDR),9)
		 		s ABO=""
		 		i $l(BloodGroupDR) d
		 		.s ABO = $lg(^dbo.BBBloodGroupD(BloodGroupDR),4)
		 		s PackVolume = $lg(^dbo.BDPackD(PackDR),10)
		 		s BloodProductDR = $lg(^dbo.BDPackD(PackDR),3)
		 		s ScaleFactor = $lg(^dbo.BBBloodProductD(BloodProductDR),16)
		 		i $l(PackVolume),$l(ScaleFactor) s PackVolume=PackVolume*ScaleFactor
		 		s TransVolume = TransVolume +PackVolume
		 		
		 		i ABO="A" s BLOODTYPE=1
		 		i ABO="B" s BLOODTYPE=2
		 		i ABO="AB" s BLOODTYPE=4
		 		i ABO="O" s BLOODTYPE=3

	 		}
	 		s IssueDate=""
	 		i $l(StDate) s IssueDate = $e(StDate,1,4)_"-"_ $e(StDate,5,6)_"-"_ $e(StDate,7,8)
	 		i $l(IssueTime) s IssueTime=$zt(IssueTime)
	 		s TransDateTime = IssueDate_" "_IssueTime
	 		
	 		//机构号
	 		s ORGCODE=""
	 		s Data = $lb(ORGCODE,RegNo,IssueRecordDR,ReqFormPurpose,BLOODTYPE,TransVolume,TransDateTime)
	 		d OutPut
	 			
 		}
 	}

	
 	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QryBldTransInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBldTransInfoExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBldTransInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBldTransInfoExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      SZW
/// CreatDate：    20180809
/// Description:： 根据时间段获取患者用血史等信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       
/// Others：  
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBloodInterface","QryBldUseInfo","2016-04-02","2017-04-02","","","","","","","","","","",20,1,"106^10^^13^1")
Query QryBldUseInfo(StDate As %String, EndDate As %String, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "ORGCODE:%String,Id:%String,ID:%String,Date_T:%String,Dept_Code:%String,Dept_Name%String,ICD:%String,Diagnosis:%String,ABO_Code:%String,RH_Code:%String,Blood_Class_Type_Code:%String,Blood_Used:%String,Unit:%String,Name:%String,ID_No:%String,Card_No:%String,Event_Type:%String,Event_No:%String") [ SqlProc ]
{
}

ClassMethod QryBldUseInfoExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1

 	s StDate = $tr(StDate,"-")
 	s EndDate = $tr(EndDate,"-")
 	s StDate = StDate -1
 	for {
 		s StDate = $o(^dbo.BDIssueRecordI("IndexIssueDate",StDate))
 		q:StDate>EndDate
 		q:StDate=""
 		s IssueRecordDR=""
 		for {
	 		s IssueRecordDR = $o(^dbo.BDIssueRecordI("IndexIssueDate",StDate,IssueRecordDR))
	 		q:IssueRecordDR=""
	 		s IssueRecordData = $g(^dbo.BDIssueRecordD(IssueRecordDR))
	 		//判断发血状态
	 		s IssueStatus = $lg(IssueRecordData,12)
	 		i IssueStatus'=1 continue
	 		
	 		s IssueTime = $lg(IssueRecordData,5)
	 		s ReqFormDR = $lg(IssueRecordData,11)
	 		s ReqFormData = $g(^dbo.BDReqFormD(ReqFormDR))
	 		
	 		s (LocationCode,LocationName)=""
	 		s LocationDR = $lg(ReqFormData,23)
	 		i $l(LocationDR) d
	 		.s LocationCode = $lg(^dbo.BTLocationD(LocationDR),5)
	 		.s LocationName = $lg(^dbo.BTLocationD(LocationDR),3)
	 		
	 		s ICD=""
	 		s Diagnosis = $lg(ReqFormData,26)
	 		s PatientName=$lg(ReqFormData,10)
	 		s IDNo = $lg(ReqFormData,17)
	 		s CardNo=""
	 		s EventType=""
	 		s EventNo=""
	 		
#;	 		//申请用血目的
#;	 		s ReqFormPurpose=""
#;	 		s ReqProductDR=""
#;		    for {
#;			    s ReqProductDR = $o(^dbo.BDReqFormProductI("IndexMaster",ReqFormDR,ReqProductDR))
#;			 	q:ReqProductDR=""
#;			 	s ReqFormProductDR = $o(^dbo.BDReqFormProductI("IndexMaster",ReqFormDR,ReqProductDR,""))
#;			 	s ReqFormProductData = $g(^dbo.BDReqFormProductD(ReqFormProductDR))
#;			 	
#;			 	s PurposeDR = $lg(ReqFormProductData,4)
#;			 	s Purpose = $lg(^dbo.BBPurposeD(PurposeDR),3)
#;			 	i ReqFormPurpose'[Purpose d 
#;			 	.s ReqFormPurpose=ReqFormPurpose_Purpose_$c(13,10)
#;			 	
#;		    }
#;	 		
	 		//登记号
	 		s RegNo = $lg(ReqFormData,8)
	 		
	 		//血型与血量
	 		s XMPlanDR = $lg(IssueRecordData,11)
	 		s PackDR=""
	 		s TransVolume=0
	 		s BLOODTYPE=5
	 		for{
		 		s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR))
		 		q:PackDR=""
		 		s BloodGroupDR = $lg(^dbo.BDPackD(PackDR),9)
		 		s (ABO,RH)=""
		 		i $l(BloodGroupDR) d
		 		.s ABO = $lg(^dbo.BBBloodGroupD(BloodGroupDR),4)
		 		.s RH = $lg(^dbo.BBBloodGroupD(BloodGroupDR),5)
		 		s PackVolume = $lg(^dbo.BDPackD(PackDR),10)
		 		s BloodProductDR = $lg(^dbo.BDPackD(PackDR),3)
		 		s Units = $lg(^dbo.BBBloodProductD(BloodProductDR),15)
		 		s BloodProductName = $lg(^dbo.BBBloodProductD(BloodProductDR),3)
		 		s BloodComponentsDR = $lg(^dbo.BBBloodProductD(BloodProductDR),10)
		 		s ComponentsCode=""
		 		i $l(BloodComponentsDR) s ComponentsCode = $lg(^dbo.BBBloodComponentsD(BloodComponentsDR),5)
		 		
		 		s ABOCode=5
		 		i ABO="A" s ABOCode=1
		 		i ABO="B" s ABOCode=2
		 		i ABO="AB" s ABOCode=4
		 		i ABO="O" s ABOCode=3
		 		
		 		s RHCode=4
		 		i RH="N" s RHCode=1
		 		i RH="P" s RHCode=2
		 		i RH="U" s RHCode=3
		 		
		 		s IssueDate=""
		 		i $l(StDate) s IssueDate = $e(StDate,1,4)_"-"_ $e(StDate,5,6)_"-"_ $e(StDate,7,8)
		 		i $l(IssueTime) s IssueTime=$zt(IssueTime)
		 		s TransDateTime = IssueDate_" "_IssueTime
				//机构号
		 		s ORGCODE=""
		 		s Data = $lb(IssueDate,ORGCODE,PackDR,LocationCode,LocationName,ICD,Diagnosis,ABOCode,RHCode,ComponentsCode,PackVolume,Units,PatientName,IDNo,CardNo,EventType,EventNo)
		 		d OutPut
	 		}
	 		
	 		
	 	
	 			
 		}
 	}

	
 	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QryBldUseInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBldUseInfoExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBldUseInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBldUseInfoExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Function: 查询医嘱是否属于备血医嘱
/// CreateDate: 2017-12-25
/// InPut: 就诊号,医嘱ID     
/// OutPot: 0代表非备血医嘱 1代表备血医嘱
/// 	w ##CLASS(DHCLIS.DHCBloodInterface).GetISReqFormOrder
ClassMethod GetISReqFormOrder(AdmNo As %Library.String, HISOrderID As %Library.String)
{
	s RetValue=0
	s ReqFormDR=""
	for {
		s ReqFormDR=$o(^dbo.BDReqFormI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),ReqFormDR))
		q:ReqFormDR=""
		s BDReqFormCostItemDR=""
		for {
			s BDReqFormCostItemDR = $o(^dbo.BDReqFormCostItemI("IndexReqForm",ReqFormDR,BDReqFormCostItemDR))
			q:BDReqFormCostItemDR=""
			s BDReqFormCostItemData = $g(^dbo.BDReqFormCostItemD(BDReqFormCostItemDR))
			s ReqFormHISOrderID = $lg(BDReqFormCostItemData,25)
			s CostType = $lg(BDReqFormCostItemData,3)
			i (HISOrderID=ReqFormHISOrderID),(CostType=5) s RetValue=1 q
		}
		i RetValue=1 q
	}
	q RetValue
}

/// 获取病人手术信息
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetPatientOperationInfo("50091990")
ClassMethod GetPatientOperationInfo(AdmNo) As %String
{
	 s count=0
	 s resultString=""
	 i '$l(AdmNo) q ""
	 s ret=##class(web.DHCANAdaptor).GetANOperation("","",AdmNo,"","ARILPF","","")

	 Set reader = ##class(%XML.Reader).%New()
	 Do reader.OpenStream(ret)
	 Do reader.Correlate("PatInfo","web.DHCANInterface")
	 s RetStr=""
	 k ^TMP($zn,$j,"DHCLIS.DHCBloodInterface","GetPatientOperationInfo",AdmNo)
	 s thisDate=$p($h,",",1)
	 While (reader.Next(.object,.sc)) {
		 //w object.PatName,"/",object.AnaDoctor,"/",object.ScrubNurSecondCtcpId,"/",object.ANAOPCirculNurseDR,!
		 //Write object.BodsDesc_","_object.OpDocCtcpId_","_object.AssistantFirstCtcpId,!
		 s state="N"
		 s sighDate=""
		 s EpisodeName="" 
		 s InformDoctor=""  //洽谈医生
		 s ExcisionCondition="" //切除情况
		 s MainDiagnose="" //主要诊断
		 s ExcisionDept="" // 部位
		 //i object.EpisodeID'=""  d
		 i sighDate'="" s sighDate=$zd(sighDate,3)
		 ;w state_isConfim,! _object.OpDate_"^^"_
		 i '$l(object.OpDate) continue
		 s OperateDate = $ZDH(object.OpDate,3)
		 s OperateDateDT = $p(object.OpTime,"~",1)
		 i thisDate>OperateDate continue
		 s ^TMP($zn,$j,"DHCLIS.DHCBloodInterface","GetPatientOperationInfo",AdmNo,OperateDate,count)=object.OpDate_"^^"_OperateDateDT_"^^"_object.OperId_"^^"_object.OpName_"^^"_object.OpaId_"^^"_object.OPAAppDate_"^^"_object.OpDate_"^^"_object.BodsDesc
		 s count=count+1
	 }
	 
	 s OperateDate=""
	 for {
		  s OperateDate=$o(^TMP($zn,$j,"DHCLIS.DHCBloodInterface","GetPatientOperationInfo",AdmNo,OperateDate),-1)
		  q:OperateDate=""
		  s order=""
		  for {
			  s order=$o(^TMP($zn,$j,"DHCLIS.DHCBloodInterface","GetPatientOperationInfo",AdmNo,OperateDate,order))
		  	  q:order=""
		  	  s RetStr = RetStr_"@@"_^TMP($zn,$j,"DHCLIS.DHCBloodInterface","GetPatientOperationInfo",AdmNo,OperateDate,order)
		  }
	 }
	 k ^TMP($zn,$j,"DHCLIS.DHCBloodInterface","GetPatientOperationInfo",AdmNo)
	 q RetStr
}

/// 更新血液临床接收信息：入参（血袋条码，产品码，ArriveDate：临床接收日期，ArriveTime：临床接收时间，ArriveUserCode临床接收人code），出参：Output:1更新成功，否则返回错误信息
/// w ##CLASS(DHCLIS.DHCBloodInterface).UpdatePackArriveInfo("001040327001","Z046901","20180622","08:00","ys01")
ClassMethod UpdatePackArriveInfo(PackID As %String, ArriveUserCode As %String, ReceiveTime As %String, VerifyResultStr As %String = "", HospitalCode As %String = "", LocationCode As %String = "", WardCode As %String = "")
{
	Set $ZTrap = "ErrorHandle"
    new $NAMESPACE
    s $namespace = "DHC-LISDATA" 
    s Ret=##class(Service.BLD.PACK.PackService).SaveReceiveInfo(PackID,ArriveUserCode,ReceiveTime,VerifyResultStr,HospitalCode,LocationCode,WardCode)
    s $namespace = "DHC-APP"
    q Ret 
    
ErrorHandle  
	s Ret="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
    Quit Ret
}

/// 更新血液输注开始信息：入参（血袋条码，产品码，InfusionStartDate输注开始日期，InfusionStartTime输注开始时间，FirstCheckUserCode输注审核第一用户，SecondCheckUserCode输注审核第二用户），出参：Output:1更新成功，否则返回错误信息
/// w ##CLASS(DHCLIS.DHCBloodInterface).UpdatePackInfusionStartInfo("=01501991921021","=<PV056001","2018-06-22","10:00","00741","00741")
ClassMethod UpdatePackInfusionStartInfo(PackID As %String, FirstCheckUserCode As %String, SecondCheckUserCode As %String, StartTime As %String)
{
	
    Set $ZTrap = "ErrorHandle"
    new $NAMESPACE
    s $namespace = "DHC-LISDATA" 
    s Ret=##class(Service.BLD.PACK.PackService).SaveTransStartInfo(PackID,FirstCheckUserCode,SecondCheckUserCode,StartTime)
    s $namespace = "DHC-APP"
    q Ret

ErrorHandle  
	s Ret="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
    Quit Ret
}

/// 更新血液输注结束信息：入参（PackID:血液id通过获取血液信息接口获取，InfusionEndDate输注结束日期，InfusionEndTime输注结束时间，InfusionEndUserCode输注结束记录人code TransEndInfo：输注结束血液信息，输注结束状态(0正常结束，1出现不良反应,2其他)^^剩余血量^^异常结束原因）， 
/// w ##CLASS(DHCLIS.DHCBloodInterface).UpdatePackInfusionEndInfo("=01501991921021","=<PV056001","20180622","09:00","00741")
ClassMethod UpdatePackInfusionEndInfo(PackID As %String, InfusionEndUserCode As %String, EndTime As %String, TransEndInfo As %String = "")
{
	Set $ZTrap = "ErrorHandle"
    new $NAMESPACE
    s $namespace = "DHC-LISDATA" 
    s Ret=##class(Service.BLD.PACK.PackService).SaveTransEndInfo(PackID,InfusionEndUserCode,EndTime,TransEndInfo)
    s $namespace = "DHC-APP"
    q Ret
    
ErrorHandle  
	s Ret="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
    Quit Ret
}

/// 记录血液巡视信息：入参（血袋条码，产品码,ScoutDate巡视日期，ScoutTime巡视时间，ScoutUserCode巡视人code，BodyTemp体温，Pulse脉搏，DripSpeed滴速，SystolicPressure高压，DiastolicPressure低压，IsReaction是否不良反应1是0不是，ReactionNote不良反应症状,ScoutType:输注类型，0输注前，1输注中，2输注后）
/// 出参：Output:1保存成功，否则返回错误信息
/// w ##CLASS(DHCLIS.DHCBloodInterface).SavePackScoutInfo("0010123232001","P0065v00","2020-05-19","14:00","HS01","","","11","","",0,"")
ClassMethod SavePackScoutInfo(PackID As %String, ScoutUserCode As %String, PatrolType As %String, PatrolTime As %String, PatrolInfo As %String, PackInfusion As %String)
{
	Set $ZTrap = "ErrorHandle"
    new $NAMESPACE
    s $namespace = "DHC-LISDATA" 
    s Ret=##class(Service.BLD.PACK.PackService).SaveTransPatrolInfo(PackID,ScoutUserCode,PatrolTime,PatrolType,PatrolInfo,PackInfusion)
    s $namespace = "DHC-APP"
    q Ret

ErrorHandle  
	s Ret="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
    Quit Ret
}

/// 根据发血单号更新取血人： 入参(IssueRecordNo：发血单号,TakeUseCode:取血人code)出参：Output:1更新成功，否则返回错误信息
/// w ##CLASS(DHCLIS.DHCBloodInterface).SaveTakeUserByIssueNo("ISS201604020001","00741")
ClassMethod SaveTakeUserByIssueNo(IssueRecordNo As %String, TakeUseCode As %String, Output retStr As %String(MAXLEN=32767))
{
	s LisNamespace="DHC-LISDATA"
	//s $NAMESPACE=LisNamespace
	s retStr="" 
	i '$l(IssueRecordNo) s retStr="发血单号不能为空!" q retStr
	s BDIssueRecordDR=$o(^dbo.BDIssueRecordI("IndexMaster",##Class(LIS.Util.Common).IndexData(IssueRecordNo),""))
	i '$l(BDIssueRecordDR) s retStr="未查询到发血单号！" q retStr
    s objIssueRecordData=##class(dbo.BDIssueRecord).%OpenId(BDIssueRecordDR)
    s objIssueRecordData.TakeUserName=TakeUseCode
    s sc=objIssueRecordData.%Save()  
 
	If ($SYSTEM.Status.IsOK(sc)) {
		 s retStr=1
	}
	else {
		s retStr=$SYSTEM.Status.GetErrorText(sc)  
	} 
      
    q retStr
}

/// 根据就诊号，返回病人一段时间内的用血信息
/// 入参：开始日期，结束日期 （申请单审核时间），就诊号
/// 出参：（血袋编号 ^ 血袋描述(血产品)^血型^配血方法^血袋血量^血袋状态^预定输注日期^预定输注时间 ）若多条数据，以 $$ 进行分割
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetPatpackInfo("2018-08-01","2018-08-01",1000)
ClassMethod GetPatpackInfo(SttDate As %String, EndDate As %String, fAdmNo As %String)
{
	s SttDate=$tr($g(SttDate),"-"),EndDate=$tr($g(EndDate),"-"),fAdmNo=$g(fAdmNo)
	s LisNamespace = "DHC-LISDATA" 
	s retStr=""
	s Date=SttDate-1
	s Date=$o(^dbo.BDIssueRecordI("IndexIssueDate",SttDate)) q:(SttDate="")||($l(EndDate)&&SttDate>EndDate)  d
	.s IssueRecordDR="" f  s IssueRecordDR=$o(^dbo.BDIssueRecordI("IndexIssueDate",SttDate,IssueRecordDR)) q:IssueRecordDR=""  d
	..s IssueRecordData=$g(^dbo.BDIssueRecordD(IssueRecordDR))
	..s ReqFormDR=$lg(IssueRecordData,11)
	..s AdmNo=$lg(^dbo.BDReqFormD(ReqFormDR),4)
	..i '$l(AdmNo) q
	..i $l(fAdmNo),fAdmNo'=AdmNo q
	..s BookDate=$lg(ReqFormData,40)
	..i $l(BookDate) s BookDate=$e(BookDate,1,4)_"-"_$e(BookDate,5,6)_"-"_$e(BookDate,7,8)
	..s BookTime=$lg(ReqFormData,81)
	..i $l(BookTime) s BookTime=$zt(BookTime,2)
	..s PackDR="" f  s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) q:PackDR=""  d  // BD_IssueRecordItems 
	...s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
	...s IsReturn=$lg($g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR)),4)
	...i IsReturn="1" q
	...s XMPlanDR=$lg($g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR)),6)
	...s XMMethodDR=$lg($g(^dbo.BDXMPlanD(XMPlanDR)),22),XMMethod=""
	...i $l(XMMethodDR) s XMMethod=$lg($g(^dbo.BBXMMethodD(XMMethodDR)),3)
	...s PackData=$g(^dbo.BDPackD(PackDR))
	...s PackID=$lg(PackData,2)
	...s BloodProductDR=$lg(PackData,3)
	...s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
	...s BloodProductCode=$lg(BloodProductData,2)
	...s BloodProductName=$lg(BloodProductData,3)
	...s BloodGroupDR=$lg(PackData,9)
	...s BDType=$lg($g(^dbo.BBBloodGroupD(BloodGroupDR)),3)
    ...s PackSize=$lg(PackData,10)
    ...s Units=$lg(BloodProductData,15)
	...s PackVolumn=PackSize_Units 
	...s PackStatusDR=$lg(PackData,34),PackStatus=""
	...i $l(PackStatusDR) s PackStatus=$lg(^dbo.BBPackStatusD(PackStatusDR),3)
	...i '$l(retStr) d
    ....s retStr=PackID_"^"_BloodProductName_"^"_BDType_"^"_XMMethod_"^"_PackVolumn_"^"_PackStatus_"^"_BookDate_$c(32)_BookTime
    ....e  d
    .....s retStr =retStr_"$$"_PackID_"^"_BloodProductName_"^"_BDType_"^"_XMMethod_"^"_PackVolumn_"^"_PackStatus_"^"_BookDate_$c(32)_BookTime
	q retStr
}

/// 查询医嘱是否为备血医嘱
/// Input:就诊号，医嘱ID
/// 1为是备血医嘱  0为其他情况
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetIsReqOrder("67162||63")
ClassMethod GetIsReqOrder(OrderID)
{
	s ret=0
	s ReqFormCostItemDR=$o(^dbo.BDReqFormCostItemI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OrderID),""))
	S ReqFormCostItemData=$g(^dbo.BDReqFormCostItemD(ReqFormCostItemDR))
	s CostType=$lg(ReqFormCostItemData,3)
	i CostType'=5 q ret
	s ret=1
	q ret
}

/// Function: 根据HISOrderID 返回申请单号和申请单主键
/// CreateDate: 20190126
/// InPut: HISOrderID    
/// OutPot: 主键^单号
/// 	w ##CLASS(DHCLIS.DHCBloodInterface).GetReqFormNo("25||178")
ClassMethod GetReqFormNo(HisOrderID As %Library.String)
{
	s HisOrderID=$g(HisOrderID)
	s thisOrdId=$p(HisOrderID,"||",1)
	s thisOrdSubId=$p(HisOrderID,"||",2)   
	s (SampleNo,ReqFormDR)=""
	i $l($p($g(^OEORD(thisOrdId,"I",thisOrdSubId,3)),"^",20)) s SampleNo=$p($g(^OEORD(thisOrdId,"I",thisOrdSubId,3)),"^",20) 
	i $l(SampleNo) d
	.s ReqFormDR=$o(^dbo.BDReqFormI("IndexUseSampleNo",##Class(LIS.Util.Common).IndexData(SampleNo),""))
	e  d
	.s RowID=$o(^dbo.BDReqFormCostItemI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(HisOrderID),""))
	.i $l(RowID) d
	..s ReqFormCostItemData=$g(^dbo.BDReqFormCostItemD(RowID))
	..s ReqFormDR=$lg(ReqFormCostItemData,2)
	i '$l(ReqFormDR) q "-1^-1"
	s ReqFormData=$g(^dbo.BDReqFormD(ReqFormDR))
	s Status=$lg(ReqFormData,51)
	i Status=15 q "-1^-1"
	s ReqFormNo=$lg($g(^dbo.BDReqFormD(ReqFormDR)),2)
	q ReqFormDR_"^"_ReqFormNo
}

/// CreateDate: 
/// Creator: JinChao
/// Desction: 获取血袋信息
/// donorID:血袋编码(献血码),productID:血制品编码(区别码)
/// 
/// Return：       1RowID:血制品RowID,2DonorID:血袋编码,3ProductID:血制品编码,4ProductDesc:血制品描述,5BloodGroupID:血型ID,6BloodGroup:血型,
/// 			   7Volume:血制品量,8Unit:血制品单位,9ProductGroupID:血成份ID,10ProductGroup:血成份,11StoreStatus:库存状态,
/// 			   12TransStatus:处理状态,13TransDesc:处理操作,14ExpireDateTime:失效日期时间,15IssueDateTime:发血日期时间,
/// 			   16IssueUser:发血者,17XMMajor:主侧配血结果,18XMMinor:次侧配血结果,19XMResult:交叉配血结果,
/// 			   20XMDateTime:配血日期时间,21XMUser:配血者,22PatName:受血者姓名,23PatSex:受血者性别,24PatAge:受血者年龄,
/// 			   25PatientID:受血者登记号,26PatBldGroup:受血者血型,27Location:就诊科室,28LabRowID:检验医嘱RowID,
/// 			   29IsTrans:是否已经输用,30IsReaction:是否不良反应,31IsRetrieve:是否已回收,32AdmID:就诊号,33Ward:病区,34Bed:床号
/// w ##Class(DHCLIS.DHCBloodInterface).GetPackInfo("0010123232001","=<P0065V00")
ClassMethod GetPackInfo(PackBarCode As %String, ProdcutBarCode As %String) As %String
{
	Set $ZTrap = "ErrorHandle"
    new $NAMESPACE   
	s PackBarCode=$g(PackBarCode),ProdcutBarCode=$g(ProdcutBarCode)
	s $namespace="DHC-LISDATA" 
	s Ret=##Class(Service.BLD.PACK.PackService).GetPackInfo(PackBarCode,ProdcutBarCode)
	s $namespace="DHC-APP"
	q Ret
	
ErrorHandle  
	s Ret="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
    Quit Ret
}

/// Creator: JinChao
/// CreateDate: 2019-08-20
/// Desction: 根据就诊号返回用血信息
/// Input : AdmNo 就诊号
/// Return: Componts^CompontsCode^Volumn^Unit^$$Componts^CompontsCode^Volumn^Unit 
/// 血成分^代码^血量^单位$$血成分^代码^血量^单位
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetPatCompontsByAdmNo(37)
ClassMethod GetPatCompontsByAdmNo(fAdmNo) As %String
{
	s fAdmNo=$g(fAdmNo)
	i '$l(fAdmNo) q "-1^入参为空"
	k ^TMP.BLD("BldCom")
	s retStr=""
	s BDReqFormDR="" f  s BDReqFormDR= $o(^dbo.BDReqFormI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(fAdmNo),BDReqFormDR)) q:(BDReqFormDR="")  d
    .s BDReqFormData=$g(^dbo.BDReqFormD(BDReqFormDR))
    .s IssueRecordDR="" f  s IssueRecordDR= $o(^dbo.BDIssueRecordI("IndexReqForm",BDReqFormDR,IssueRecordDR)) q:(IssueRecordDR="")  d
    ..s IssueRecordData=$g(^dbo.BDIssueRecordD(IssueRecordDR))
    ..s PackDR="" f  s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) q:PackDR=""  d  // BD_IssueRecordItems 
	...s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
	...s IsReturn=$lg($g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR)),4)
	...i IsReturn="1" q 
	...s PackData=$g(^dbo.BDPackD(PackDR))
	...s BloodProductDR=$lg(PackData,3)
	...s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
	...s BloodComponentsDR=$lg(BloodProductData,10)
	...s PackSize=$lg(PackData,10)
    ...s Units=$lg(BloodProductData,15)
	...i $d(^TMP.BLD("BldCom",BloodComponentsDR,Units)) d
	....s ^TMP.BLD("BldCom",BloodComponentsDR,Units)=$g(^TMP.BLD("BldCom",BloodComponentsDR,Units))+PackSize
	...e  d
	....s ^TMP.BLD("BldCom",BloodComponentsDR,Units)=PackSize
	
	s BloodComponentsDR="" f  s BloodComponentsDR=$o(^TMP.BLD("BldCom",BloodComponentsDR)) q:BloodComponentsDR=""  d
	.s Unit="" f  s Unit =$o(^TMP.BLD("BldCom",BloodComponentsDR,Unit)) q:Unit=""  d
	..s PackVolumn=$g(^TMP.BLD("BldCom",BloodComponentsDR,Unit))
	..s CompontName=$lg(^dbo.BBBloodComponentsD(BloodComponentsDR),3)
	..s CompontCode=$lg(^dbo.BBBloodComponentsD(BloodComponentsDR),2)
	..i $l(retStr) s retStr=retStr_"$$"_CompontName_"^"_CompontCode_"^"_PackVolumn_"^"_Unit_"^"_BloodComponentsDR
	..e  s retStr=CompontName_"^"_CompontCode_"^"_PackVolumn_"^"_Unit_"^"_BloodComponentsDR
	k ^TMP.BLD("BldCom") 
	q retStr
}

/// Creator: JinChao
/// CreateDate: 2019-08-20
/// Desction: 根据就诊号返回是否存在不良反应
/// Input : AdmNo 就诊号
/// Return: 0 未输 1 有不良反应( 不良反应代码，成分) 2无不良反应
/// w ##Class(DHCLIS.DHCBloodInterface).GetIsRecaction("27")
ClassMethod GetIsRecaction(fAdmNo) As %String
{
	s fAdmNo=$g(fAdmNo)
	i '$l(fAdmNo) q "-1^入参为空"
	s retStr="0"
	s ReqFormDR="" f  s ReqFormDR=$o(^dbo.BDReqFormI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(fAdmNo),ReqFormDR)) q:ReqFormDR=""  d
	.s IssueRecordDR="" f  s IssueRecordDR= $o(^dbo.BDIssueRecordI("IndexReqForm",ReqFormDR,IssueRecordDR)) q:(IssueRecordDR="")  d
    ..s PackDR="" f  s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) q:PackDR=""  d  // BD_IssueRecordItems 
	...s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
	...s IsReturn=$lg($g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR)),4)
	...i IsReturn="1" q
	...s retStr="2"
	i retStr="0" q retStr
	s ReactionDR="" f  s ReactionDR=$o(^dbo.BDAdverseReactionI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(fAdmNo),ReactionDR)) q:ReactionDR=""  d
	.s Status=$lg(^dbo.BDAdverseReactionD(ReactionDR),60)
	.i ((Status=10)!(Status=15)!(Status=25)) q
	.//s retStr="1"
	.s PackDR=$o(^dbo.BDReactionLinkPackI("IndexMaster",ReactionDR,""),-1)
	.s BloodProdcutDR=$lg(^dbo.BDPackD(PackDR),3)
	.s BloodProductData=$g(^dbo.BBBloodProductD(BloodProdcutDR))
	.s BloodComponentsDR=$lg(BloodProductData,10)
	.s CompontName=$lg(^dbo.BBBloodComponentsD(BloodComponentsDR),3)
	.s CompontCode=$lg(^dbo.BBBloodComponentsD(BloodComponentsDR),2)
	.s retStr="1^"_CompontName_"^"_CompontCode
	q retStr
}

/// Creator: JinChao
/// CreateDate: 2019-08-20
/// Desction: 根据就诊号返回是否存在自体输血申请
/// Input : AdmNo 就诊号
/// Return: Y or N
ClassMethod GetIsSlefReq(fAdmNo) As %String
{
	s fAdmNo=$g(fAdmNo)
	i '$l(fAdmNo) q "-1^入参为空"
	s retStr="N"
	s BDReqFormDR="" f  s BDReqFormDR= $o(^dbo.BDReqFormI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(fAdmNo),BDReqFormDR)) q:(BDReqFormDR="")  d
    .s BDReqFormData=$g(^dbo.BDReqFormD(BDReqFormDR))
    .s ReqTypeDR=$lg(BDReqFormData,3)
    .s ReqTypeCode=$zcvt($lg(^dbo.BBReqTypeD(ReqTypeDR),2),"U")
    .i ReqTypeCode'="SELF" q
    .s Status=$lg(BDReqFormData,51)
    .i Status'=35 q // 输血科未接收
    .s retStr="Y"
	q retStr
}

/// Creator: JinChao
/// CreateDate: 2019-09-05
/// Desction: 根据就诊号第一次有效申请单信息
/// Desction: 如果没有发血不算，血袋未接收不算，第一次血袋接收时间
/// Input : AdmNo 就诊号
/// Return: 申请单审核时间  输血记录接收时间   间隔时长(分钟)    就诊号
ClassMethod GetReqFormInfo(fAdmNo) As %String
{
	s QuitFlag=0
	s retStr=""
	s ReqFormDR="" f  s ReqFormDR=$o(^dbo.BDReqFormI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(fAdmNo),ReqFormDR)) q:((ReqFormDR="")!(QuitFlag=1))  d
	.s IsStop=0
	.s IssRecordDR="" f  s IssRecordDR=$o(^dbo.BDIssueRecordI("IndexReqForm",ReqFormDR,IssRecordDR)) q:((IssRecordDR="")!(IsStop=1))  d
	..s PackDR="" f  s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssRecordDR,PackDR)) q:((PackDR="")!(IsStop=1))  d
	...s IssItemDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssRecordDR,PackDR,""))
	...s IsReturn=$lg(^dbo.BDIssueRecordItemsD(IssItemDR),4)
	...i IsReturn=1 q
	...s PackData=$lg(^dbo.BDPackD(PackDR))
	...s PackArriveDate=$lg(PackData,57)
	...i '$l(PackArriveDate) q
	...s OArriveDate=$e(PackArriveDate,1,4)_"-"_$e(PackArriveDate,5,6)_"-"_$e(PackArriveDate,7,8)
	...s ArriveTime=$lg(PackData,58)
	...s OArriveTime=$zt(ArriveTime)
	...s ArriveDate=$zdh(PackArriveDate,8)
	...s IsStop=1
	...s QuitFlag=1
	.i IsStop=0 q
	.s ReqFormData=$lg(^dbo.BDReqFormD(ReqFormDR))
	.s CheckDate=$lg(ReqFormData,63)
	.s OCheckDate=$e(CheckDate,1,4)_"-"_$e(CheckDate,5,6)_"-"_$e(CheckDate,7,8)
	.s CheckTime=$lg(ReqFormData,64)
	.s OCheckTime=$zt(CheckTime)
	.s CheckDate=$zdh(CheckDate,8)
	.s Seconds=(ArriveDate-CheckDate)*86400+ArriveTime-CheckTime
	.s Miniuts=(Seconds/60)
	.s retStr=OCheckDate_" "_OCheckTime_"^"_OArriveDate_" "_OArriveTime_"^"_Miniuts_"^"_fAdmNo
	q retStr
}

/// Creator: JinChao
/// CreateDate: 2019-12-26
/// Desction: 根据就诊号返回用血总量(注意维护转换系数)
/// Input : AdmNo 就诊号
/// Return: 用血总量（ML）
ClassMethod GetPatBldByAdmNo(fAdmNo) As %String
{
	s fAdmNo=$g(fAdmNo)
	i '$l(fAdmNo) q "-1^入参为空"
	s SumVolume=0
	s BDReqFormDR="" f  s BDReqFormDR= $o(^dbo.BDReqFormI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(fAdmNo),BDReqFormDR)) q:(BDReqFormDR="")  d
    .s BDReqFormData=$g(^dbo.BDReqFormD(BDReqFormDR))
    .s IssueRecordDR="" f  s IssueRecordDR= $o(^dbo.BDIssueRecordI("IndexReqForm",BDReqFormDR,IssueRecordDR)) q:(IssueRecordDR="")  d
    ..s IssueRecordData=$g(^dbo.BDIssueRecordD(IssueRecordDR))
    ..s PackDR="" f  s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) q:PackDR=""  d  // BD_IssueRecordItems 
	...s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
	...s IsReturn=$lg($g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR)),4)
	...i IsReturn="1" q 
	...s PackData=$g(^dbo.BDPackD(PackDR))
	...s BloodProductDR=$lg(PackData,3)
	...s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
	...s BloodComponentsDR=$lg(BloodProductData,10)
	...s PackSize=$lg(PackData,10)
    ...s Units=$lg(BloodProductData,15)
    ...s ScaleFactor=+$lg(BloodProductData,16)
	...s SumVolume=SumVolume+(PackSize*ScaleFactor)
	q SumVolume
}

/// Creator: JinChao
/// CreateDate: 2020-03-11
/// Desction: 根据发血日期，返回时间范围内的用血量信息汇总
/// Input : 发血开始，结束日期，申请单类型
/// Return: Componts^CompontsCode^Volumn^Unit^$$Componts^CompontsCode^Volumn^Unit 
/// 血成分^代码^血量^单位$$血成分^代码^血量^单位
/// w ##Class(DHCLIS.DHCBloodInterface).GetPatCompontsByDate("2019-01-01","2019-12-31","")
ClassMethod GetPatCompontsByDate(fSttDate As %String, fEndDate As %String, fReqTypeCode As %String) As %String
{
	s fSttDate=$tr($g(fSttDate),"-"),fEndDate=$tr($g(fEndDate),"-"),fReqTypeCode=$zcvt($g(fReqTypeCode),"U")
	k ^TMP.BLD("BldCom")
	s retStr=""
	
	s Date=fSttDate-1 f  s Date=$o(^dbo.BDIssueRecordI("IndexIssueDate",Date)) q:((Date="")||(Date>fEndDate))  d
	.s IssueRecordDR="" f  s IssueRecordDR= $o(^dbo.BDIssueRecordI("IndexIssueDate",Date,IssueRecordDR)) q:(IssueRecordDR="")  d
	..s IssueRecordData=$g(^dbo.BDIssueRecordD(IssueRecordDR))
	..s BDReqFormDR=$lg(IssueRecordData,11)
	..s ReqTypeDR=$lg(^dbo.BDReqFormD(BDReqFormDR),3)
	..s ReqTypeCode=$zcvt($lg(^dbo.BBReqTypeD(ReqTypeDR),2),"U")
	..i $l(fReqTypeCode),ReqTypeCode'=fReqTypeCode q
    ..s PackDR="" f  s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) q:PackDR=""  d  // BD_IssueRecordItems 
	...s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
	...s IsReturn=$lg($g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR)),4)
	...i IsReturn="1" q 
	...s PackData=$g(^dbo.BDPackD(PackDR))
	...s BloodProductDR=$lg(PackData,3)
	...s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
	...s BloodComponentsDR=$lg(BloodProductData,10)
	...s PackSize=$lg(PackData,10)
    ...s Units=$lg(BloodProductData,15)
	...i $d(^TMP.BLD("BldCom",BloodComponentsDR,Units)) d
	....s ^TMP.BLD("BldCom",BloodComponentsDR,Units)=$g(^TMP.BLD("BldCom",BloodComponentsDR,Units))+PackSize
	...e  d
	....s ^TMP.BLD("BldCom",BloodComponentsDR,Units)=PackSize
	
	s BloodComponentsDR="" f  s BloodComponentsDR=$o(^TMP.BLD("BldCom",BloodComponentsDR)) q:BloodComponentsDR=""  d
	.s Unit="" f  s Unit =$o(^TMP.BLD("BldCom",BloodComponentsDR,Unit)) q:Unit=""  d
	..s PackVolumn=$g(^TMP.BLD("BldCom",BloodComponentsDR,Unit))
	..s CompontName=$lg(^dbo.BBBloodComponentsD(BloodComponentsDR),3)
	..s CompontCode=$lg(^dbo.BBBloodComponentsD(BloodComponentsDR),2)
	..i $l(retStr) s retStr=retStr_"$$"_CompontName_"^"_CompontCode_"^"_PackVolumn_"^"_Unit
	..e  s retStr=CompontName_"^"_CompontCode_"^"_PackVolumn_"^"_Unit
	k ^TMP.BLD("BldCom") 
	q retStr
}

/// Creator: JinChao
/// CreateDate: 2020-03-11
/// Desction: 根据发血日期，返回时间范围内的用血量信息汇总
/// Input : 发血开始，结束日期，申请单类型
/// Return: Componts^CompontsCode^Volumn^Unit^$$Componts^CompontsCode^Volumn^Unit 
/// 血成分^代码^血量^单位$$血成分^代码^血量^单位
/// w ##Class(DHCLIS.DHCBloodInterface).GetPatCompontsByDate("2019-01-01","2019-12-31","")
ClassMethod GetPatOPByDate(fSttDate As %String, fEndDate As %String) As %String
{
	s fSttDate=$tr($g(fSttDate),"-"),fEndDate=$tr($g(fEndDate),"-")
	k ^TMP.BLD("BldCom")
	s retStr=""
	
	s Date=fSttDate-1 f  s Date=$o(^dbo.BDIssueRecordI("IndexIssueDate",Date)) q:((Date="")||(Date>fEndDate))  d
	.s IssueRecordDR="" f  s IssueRecordDR= $o(^dbo.BDIssueRecordI("IndexIssueDate",Date,IssueRecordDR)) q:(IssueRecordDR="")  d
	..s IssueRecordData=$g(^dbo.BDIssueRecordD(IssueRecordDR))
	..s BDReqFormDR=$lg(IssueRecordData,11)
	..s ReqTypeDR=$lg(^dbo.BDReqFormD(BDReqFormDR),3)
	..s ReqTypeCode=$zcvt($lg(^dbo.BBReqTypeD(ReqTypeDR),2),"U")
	..i ReqTypeCode'="OPERATION" q
	..s OpsName=$lg(^dbo.BDReqFormD(BDReqFormDR),53)
	..i '$l(OpsName) s OpsName="NULL"
    ..s PackDR="" f  s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) q:PackDR=""  d  // BD_IssueRecordItems 
	...s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
	...s IsReturn=$lg($g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR)),4)
	...i IsReturn="1" q 
	...s PackData=$g(^dbo.BDPackD(PackDR))
	...s BloodProductDR=$lg(PackData,3)
	...s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
	...s BloodComponentsDR=$lg(BloodProductData,10)
	...s PackSize=$lg(PackData,10)
    ...s Units=$lg(BloodProductData,15)
	...i $d(^TMP.BLD("BldCom",BloodComponentsDR,Units)) d
	....s ^TMP.BLD("BldCom",OpsName,BloodComponentsDR,Units)=$g(^TMP.BLD("BldCom",OpsName,BloodComponentsDR,Units))+PackSize
	...e  d
	....s ^TMP.BLD("BldCom",OpsName,BloodComponentsDR,Units)=PackSize
	s OpsName="" f  s OpsName=$o(^TMP.BLD("BldCom",OpsName)) q:OpsName=""  d
	.s BloodComponentsDR="" f  s BloodComponentsDR=$o(^TMP.BLD("BldCom",OpsName,BloodComponentsDR)) q:BloodComponentsDR=""  d
	..s Unit="" f  s Unit =$o(^TMP.BLD("BldCom",OpsName,BloodComponentsDR,Unit)) q:Unit=""  d
	...s PackVolumn=$g(^TMP.BLD("BldCom",OpsName,BloodComponentsDR,Unit))
	...s CompontName=$lg(^dbo.BBBloodComponentsD(BloodComponentsDR),3)
	...s CompontCode=$lg(^dbo.BBBloodComponentsD(BloodComponentsDR),2)
	...i $l(retStr) s retStr=retStr_"$$"_OpsName_"^"_CompontName_"^"_CompontCode_"^"_PackVolumn_"^"_Unit
	...e  s retStr=OpsName_"^"_CompontName_"^"_CompontCode_"^"_PackVolumn_"^"_Unit
	k ^TMP.BLD("BldCom") 
	q retStr
}

/// Creator：      JinChao
/// CreatDate：    20200324
/// Description:   根据就诊号返回发血的信息
/// Table：        
/// Input：        
/// Output：  PackID:献血码,ProductBarcode:产品码,BloodProduct:血液产品,BloodCompents:血液成分,BloodGroup:血型,PackSize:血量,Units:单位,IssueDate:发血日期,IssueTIme:发血时间,ExpiredDate:失效日期,ExpiredTime:失效时间,MedicalNo:病案号,PatName:患者姓名,fAdmNo:就诊号    
/// Return：       
/// Others：  
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBloodInterface","QryBloodByAdmNo","1")
Query QryBloodByAdmNo(fAdmNo As %String) As %Query(ROWSPEC = "PackID:%String,ProductBarcode:%String,BloodProduct:%String,BloodCompents:%String,BloodGroup:%String,PackSize:%String,Units:%String,IssueDate:%String,IssueTIme:%String,ExpiredDate:%String,ExpiredTime:%String,MedicalNo:%String,PatName:%String,fAdmNo:%String") [ SqlProc ]
{
}

ClassMethod QryBloodByAdmNoExecute(ByRef qHandle As %Binary, fAdmNo As %String, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1

 	s fAdmNo=$g(fAdmNo)
 	s LisNameSpace="DHC-LISDATA"
	s BDReqFormDR="" f  s BDReqFormDR= $o(^[LisNameSpace]dbo.BDReqFormI("IndexAdmNo"," "_fAdmNo,BDReqFormDR)) q:(BDReqFormDR="")  d
    .s BDReqFormData=$g(^[LisNameSpace]dbo.BDReqFormD(BDReqFormDR))
    .s MedicalNo=$lg(BDReqFormData,9)
    .s SurName=$lg(BDReqFormData,10)
    .s GivenName=$lg(BDReqFormData,11)
    .s PatName=SurName
    .i SurName'=GivenName s PatName=SurName_GivenName
    .s IssueRecordDR="" f  s IssueRecordDR= $o(^[LisNameSpace]dbo.BDIssueRecordI("IndexReqForm",BDReqFormDR,IssueRecordDR)) q:(IssueRecordDR="")  d
    ..s IssueRecordData=$g(^[LisNameSpace]dbo.BDIssueRecordD(IssueRecordDR))
    ..s IssueDate=$lg(IssueRecordData,4)
    ..s IssueTIme=$lg(IssueRecordData,5)
    ..i $l(IssueDate) s IssueDate=$e(IssueDate,1,4)_"-"_$e(IssueDate,5,6)_"-"_$e(IssueDate,7,8)
    ..i $l(IssueTIme) s IssueTIme=$zt(IssueTIme)
    ..s PackDR="" f  s PackDR=$o(^[LisNameSpace]dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) q:PackDR=""  d  // BD_IssueRecordItems 
	...s IssueRecordItemsDR=$o(^[LisNameSpace]dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
	...s IsReturn=$lg($g(^[LisNameSpace]dbo.BDIssueRecordItemsD(IssueRecordItemsDR)),4)
	...i IsReturn="1" q 
	...s PackData=$g(^[LisNameSpace]dbo.BDPackD(PackDR))
	...s BloodProductDR=$lg(PackData,3)
	...s BloodProductData=$g(^[LisNameSpace]dbo.BBBloodProductD(BloodProductDR))
	...s BloodComponentsDR=$lg(BloodProductData,10)
	...s PackSize=$lg(PackData,10)
    ...s Units=$lg(BloodProductData,15)
    ...s PackID=$lg(PackData,2)
    ...s BloodProduct=$lg(BloodProductData,3)
    ...s BloodCompents=$lg(^[LisNameSpace]dbo.BBBloodComponentsD(BloodComponentsDR),3)
    ...s BloodGroupDR=$lg(PackData,9)
    ...s BloodGroup=$lg(^[LisNameSpace]dbo.BBBloodGroupD(BloodGroupDR),3)
    ...s ExpiredDate=$lg(PackData,13)
    ...i $l(ExpiredDate) s ExpiredDate=$e(ExpiredDate,1,4)_"-"_$e(ExpiredDate,5,6)_"-"_$e(ExpiredDate,7,8)
    ...s ExpiredTime=$lg(PackData,14)
    ...i $l(ExpiredTime) s ExpiredTime=$zt(ExpiredTime)
    ...s ProductBarcode=$lg(PackData,6)
    ...s Data=$lb(PackID,ProductBarcode,BloodProduct,BloodCompents,BloodGroup,PackSize,Units,IssueDate,IssueTIme,ExpiredDate,ExpiredTime,MedicalNo,PatName,fAdmNo)
	...d OutPut
	
 	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QryBloodByAdmNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBloodByAdmNoExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBloodByAdmNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBloodByAdmNoExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      JinChao
/// CreatDate：    20200402
/// Description:   获取该就诊号下的申请单数量（所有）
/// Table：        
/// Input：        就诊号    
/// Output：       输血申请单数量
/// Return：       
/// Others：  
/// w ##Class(DHCLIS.DHCBloodInterface).GetReqFormCountNum(1)
ClassMethod GetReqFormCountNum(AdmNo As %String) As %String
{
	s Num=0
	s WebNameSpace="DHC-LISDATA"
	s ReqFormDR="" f  s ReqFormDR=$o(^[WebNameSpace]dbo.BDReqFormI("IndexAdmNo",$c(32)_AdmNo,ReqFormDR)) q:ReqFormDR=""  d
	.s ReqFormData=$g(^[WebNameSpace]dbo.BDReqFormD(ReqFormDR))
	.s Status=$lg(ReqFormData,51)
	.// 如需过滤状态，可再次进行修改
	.i Status=15 q   // 过滤作废,如需过滤其他状态请自行添加
	.s Num=Num+1
	
	q Num
}

Query QryEMRPatInfoByAdm(AdmNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "Purpose,Diagnosis,TransType,BloodProductName,InfusionStartDate,InfusionStartTime,InfusionEndDate,InfusionEndTime,AftAneSymDesc")
{
}

ClassMethod QryEMRPatInfoByAdmExecute(ByRef qHandle As %Binary, AdmNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s IndexAdmNo=##Class(LIS.Util.Common).IndexData(AdmNo)
    s ReqFormDR="" f  s ReqFormDR=$o(^dbo.BDReqFormI("IndexAdmNo",IndexAdmNo,ReqFormDR)) Q:ReqFormDR=""  D
    .s IssueRecordDR="" f  s IssueRecordDR=$o(^dbo.BDIssueRecordI("IndexReqForm",ReqFormDR,IssueRecordDR)) q:IssueRecordDR=""  d
    ..s PackDR="" f  s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) Q:PackDR=""  D
    ...s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
    ...s IssueRecordItemsData=$g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR))
    ...s IsReturned=$lg(IssueRecordItemsData,4)
    ...i IsReturned'=1 q
    ...s PackData=$g(^dbo.BDPackD(PackDR))
    ...s BloodProductDR=$lg(PackData,3)
    ...s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
    ...s BloodProductName=$lg(BloodProductData,3)
    ...s IsAutologous=$lg(PackData,22)
    ...i IsAutologous="1" s TransType="自体输血"
    ...e  s TransType="异体输血"
    ...s InfusionStartDate=$lg(PackData,62)
    ...s InfusionStartTime=$lg(PackData,63)
    ...s InfusionEndDate=$lg(PackData,66)
    ...s InfusionEndTime=$lg(PackData,67)
    ...s PurposeDR=$o(^dbo.BDReqFormProductI("IndexPurpose",ReqFormDR,""))
    ...S PurposeData=$g(^dbo.BBPurposeD(PurposeDR))
    ...s Purpose=$lg(PurposeData,3)
    ...s ReqFormData=$g(^dbo.BDReqFormD(ReqFormDR))
    ...s Diagnosis=$lg(ReqFormData,26)
    ...s TransEvaluationDR="" f  s TransEvaluationDR=$o(^dbo.BDTransEvaluationI("IndexReqForm",ReqFormDR,TransEvaluationDR)) q:TransEvaluationDR=""  d
    ....s TransEvaluationData=$g(^dbo.BDTransEvaluationD(TransEvaluationDR))
    ....s EvaluationStatus=$lg(TransEvaluationData,10)
    ....i EvaluationStatus'=20 q
    ....s AftAneSymDesc=$lg(TransEvaluationData,36)
    ....d OutPut
    
 	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
 	Set Data=$lb(Purpose,Diagnosis,TransType,BloodProductName,InfusionStartDate,InfusionStartTime,InfusionEndDate,InfusionEndTime,AftAneSymDesc)
 	Set ColFields="Purpose,Diagnosis,TransType,BloodProductName,InfusionStartDate,InfusionStartTime,InfusionEndDate,InfusionEndTime,AftAneSymDesc"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
    Quit
}

ClassMethod QryEMRPatInfoByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEMRPatInfoByAdmExecute ]
{
    Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryEMRPatInfoByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEMRPatInfoByAdmExecute ]
{
    Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 	Set AtEnd=1
 	Set Row=""
 	}
 	else      {	
 	Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBloodInterface","QryBldTransfusionInfo","2020-02-02","2020-08-02","","","","","","","","","","",20,1,"106^10^^13^1")
Query QryBldTransfusionInfo(SttAccDate, EndAccDate, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "IssRecordNo,RegNo,OperationNo,TreatNo,CaesareanNo,ReqFormNo,LocationCode,LocationDes,WardCode,WardDes,RoomNo,BedNo,Weight,ABOCode,RHCode,TransHistory,ReqType,ReqABOCode,ReqRHCode,TransAssIndex,TransRecord,BloodProductName,PackID,PackVolume,Units,ReactFlag,ReactType,TransTime,Purpose,IssueDate,ExecUserCode,ExecUserName")
{
}

ClassMethod QryBldTransfusionInfoExecute(ByRef qHandle As %Binary, SttAccDate, EndAccDate, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
    s SttAccDate=$tr($g(SttAccDate),"-"),EndAccDate=$tr($g(EndAccDate),"-") 
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s IssueDate=$o(^dbo.BDIssueRecordI("IndexIssueDate",SttAccDate),-1)
    f  s IssueDate=$o(^dbo.BDIssueRecordI("IndexIssueDate",IssueDate)) q:(IssueDate="")||($l(EndAccDate)&&(IssueDate>EndAccDate))  d
    .s IssueRecordDR="" f  s IssueRecordDR=$o(^dbo.BDIssueRecordI("IndexIssueDate",IssueDate,IssueRecordDR)) q:IssueRecordDR=""  d
    ..s PackDR="" f  s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) q:PackDR=""  d
    ...s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
    ...s IssueRecordItemsData=$g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR))
    ...s IsReturned=$lg(IssueRecordItemsData,4)
    ...i IsReturned=1 q  
    ...s IssueRecordData=$g(^dbo.BDIssueRecordD(IssueRecordDR))
    ...s IssRecordNo=$Lg(IssueRecordData,2) 
    ...s RegNo=$lg(IssueRecordData,7)
    ...s (OperationNo,TreatNo,CaesareanNo)="-"
    ...s ReqFormDR=$lg(IssueRecordData,11)
    ...s ReqFormData=$g(^dbo.BDReqFormD(ReqFormDR))
    ...s ReqFormNo=$lg(ReqFormData,2)
    ...s LocationDR=$Lg(ReqFormData,23),(LocationCode,LocationDes)=""
    ...i $L(LocationDR) d
    ....s LocationCode=$lg($g(^dbo.BTLocationD(LocationDR)),2)
    ....s LocationDes=$lg($g(^dbo.BTLocationD(LocationDR)),3)
    ...s WardDR=$Lg(ReqFormData,24),(WardCode,WardDes)=""
    ...i $L(WardDR) s WardCode=$lg($g(^dbo.BTWardD(WardDR)),2)
    ...i $L(WardDR) s WardDes=$lg($g(^dbo.BTWardD(WardDR)),3)
    ...s RoomNo=""
    ...s BedNo=$Lg(ReqFormData,25)
    ...s Weight=$Lg(ReqFormData,74)
    ...s ABODR=$Lg(ReqFormData,18)
    ...s RHDR=$Lg(ReqFormData,19)
    ...s (ABODes,RHDes)=""
    ...i $l(ABODR) s ABODes=$lg($g(^dbo.BTABOBGD(ABODR)),3)
    ...i $l(RHDR) s RHDes=$lg($g(^dbo.BTRHBGD(RHDR)),3) 
    ...s ABOCode="5"
    ...i ABODes="A型" S ABOCode="1"
    ...i ABODes="B型" S ABOCode="2"
    ...i ABODes="O型" S ABOCode="3"
    ...i ABODes="AB型" S ABOCode="4"
    ...S RHCode="4"
    ...I RHDes="阴性" S RHCode="1"
    ...I RHDes="阳性" S RHCode="2"
    ...I RHDes="不详" S RHCode="3"
    ...s TransHistory="03"
    ...s IsTransHistory=$Lg(ReqFormData,27)
    ...i IsTransHistory="1" s TransHistory="01"
    ...i IsTransHistory="0" s TransHistory="02"
    ...s ReqTypeDR=$Lg(ReqFormData,3)
    ...s ReqTypeData=$g(^dbo.BBReqTypeD(ReqTypeDR))
    ...s ReqTypeCode=$lg(ReqTypeData,2)
    ...s ReqType=""
    ...i ReqTypeCode="Normal" s ReqType="01"
    ...i ReqTypeCode="Operation" s ReqType="02"
    ...i ReqTypeCode="Emergency" s ReqType="03"
    ...s ReqProductDR=$o(^dbo.BDReqFormProductI("IndexMaster",ReqFormDR,"")) 
    ...S ReqABOCode="5",ReqRHCode="4",Purpose=""
    ...i $l(ReqProductDR) d
    ....s ReqFormProductDR=$o(^dbo.BDReqFormProductI("IndexMaster",ReqFormDR,ReqProductDR,""))
    ....S ReqFormProductData=$g(^dbo.BDReqFormProductD(ReqFormProductDR))
    ....s PurposeDR=$lg(ReqFormProductData,4)
    ....s Purpose=$lg($g(^dbo.BBPurposeD(PurposeDR)),3)
    ....s ReqBloodGroupDR=$lg(ReqFormProductData,9)
    ....s ReqBloodGroupData=$g(^dbo.BBBloodGroupD(ReqBloodGroupDR))
    ....s ABO=$lg(ReqBloodGroupData,4)
    ....s RH=$lg(ReqBloodGroupData,5) 
    ....i ABO="A" S ReqABOCode="1"
    ....i ABO="B" S ReqABOCode="2"
    ....i ABO="O" S ReqABOCode="3"
    ....i ABO="AB" S ReqABOCode="4"
    ....i RH="N" s ReqRHCode="1"
    ....i RH="P" s ReqRHCode="2"
    ...s (TransAssIndex,TransRecord)="-"
    ...s PackData=$g(^dbo.BDPackD(PackDR)) 
    ...s BloodProductDR=$lg(PackData,3)
    ...s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
    ...s BloodProductCode=""
    ...s BloodProductName=$lg(BloodProductData,3)
    ...s PackID=$lg(PackData,2)
    ...s PackVolume=$lg(PackData,10)
    ...s Units=$lg(BloodProductData,15)
    ...s AdmNo=$lg(ReqFormData,4)
    ...s ReactFlag="02",ReactType=""
    ...s AdverseReactionDR="" f  s AdverseReactionDR=$o(^dbo.BDAdverseReactionI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),AdverseReactionDR)) q:(AdverseReactionDR="")||$l(ReactFlag)  d
    ....i $d(^dbo.BDReactionLinkPackI("IndexMaster",AdverseReactionDR,PackDR)) s ReactFlag="01"
    ...s TransTime=""
    
    ...s ReqFormCostItemDR="" f  s ReqFormCostItemDR=$o(^dbo.BDReqFormCostItemI("IndexReqForm",ReqFormDR,ReqFormCostItemDR)) Q:ReqFormCostItemDR=""  D
    ....s ReqFormCostItemData=$g(^dbo.BDReqFormCostItemD(ReqFormCostItemDR))
    ....s fPackDR=$lg(ReqFormCostItemData,19)
    ....i fPackDR'=PackDR q
    ....s CostType=$lg(ReqFormCostItemData,3)
    ....i CostType'=15 q
    ....s HISOrderID=$lg(ReqFormCostItemData,25)
    ....s ExecUserDR=$lg(ReqFormCostItemData,13)
    ....i $l(ExecUserDR) d
    .....s ExecUserCode=$Lg($g(^dbo.SYSUserD(ExecUserDR)),2)
    .....s ExecUserName=$Lg($g(^dbo.SYSUserD(ExecUserDR)),3)
    .....d OutPut
     
 	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
 	Set Data=$lb(IssRecordNo,RegNo,OperationNo,TreatNo,CaesareanNo,ReqFormNo,LocationCode,LocationDes,WardCode,WardDes,RoomNo,BedNo,Weight,ABOCode,RHCode,TransHistory,ReqType,ReqABOCode,ReqRHCode,TransAssIndex,TransRecord,BloodProductName,PackID,PackVolume,Units,ReactFlag,ReactType,TransTime,Purpose,IssueDate,ExecUserCode,ExecUserName)
 	Set ColFields="IssRecordNo,RegNo,OperationNo,TreatNo,CaesareanNo,ReqFormNo,LocationCode,LocationDes,WardCode,WardDes,RoomNo,BedNo,Weight,ABOCode,RHCode,TransHistory,ReqType,ReqABOCode,ReqRHCode,TransAssIndex,TransRecord,BloodProductName,PackID,PackVolume,Units,ReactFlag,ReactType,TransTime,Purpose,IssueDate,ExecUserCode,ExecUserName"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
    Quit
}

ClassMethod QryBldTransfusionInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBldTransfusionInfoExecute ]
{
    Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryBldTransfusionInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBldTransfusionInfoExecute ]
{
    Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 	Set AtEnd=1
 	Set Row=""
 	}
 	else      {	
 	Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 根据就诊号查询自体血发血血量总和
/// w ##CLASS(DHCLIS.DHCBloodInterface).StateAgPackVolumnByAdmNo("47862")
ClassMethod StateAgPackVolumnByAdmNo(AdmNo As %String)
{
	s LisNamespace = "DHC-LISDATA"
	s TotalVolumn=0
	k ^TMP($zn,$i,$j)
	s BDReqFormDR="" f  s BDReqFormDR= $o(^[LisNamespace]dbo.BDReqFormI("IndexAdmNo"," "_AdmNo,BDReqFormDR)) q:(BDReqFormDR="")  d
    .s IssueRecordDR="" f  s IssueRecordDR= $o(^[LisNamespace]dbo.BDIssueRecordI("IndexReqForm",BDReqFormDR,IssueRecordDR)) q:(IssueRecordDR="")  d
    ..s packDR="" f  s packDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,packDR)) q:(packDR="")  d
	...s BDIssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,packDR,""))
	...s IsReturned=$lg($g(^dbo.BDIssueRecordItemsD(BDIssueRecordItemsDR)),4)
	...i IsReturned="1" q
	...s packData=$g(^dbo.BDPackD(packDR))
	...s IsAutologous=$lg(packData,22)
	...i IsAutologous'=1 q
    ...s PackVolumn=$lg(packData,10)
    ...s TotalVolumn=TotalVolumn+PackVolumn
    ...//s BloodProductData=""
    ...//s Units=$lg(BloodProductData,15) 
     
	q TotalVolumn
}

/// 根据患者登记号获取患者是否有疑难配血历史 1：有 0：无
/// w ##CLASS(DHCLIS.DHCBloodInterface).StateAgPackVolumnByAdmNo("47862")
ClassMethod IsBldDifficult(PatRegNo As %String)
{
	s LisNamespace = "DHC-LISDATA"
	s PatRegNo=$G(PatRegNo)
	S Ret=0
	s BDReqFormDR="" f  s BDReqFormDR= $o(^[LisNamespace]dbo.BDReqFormI("IndexRegNo"," "_PatRegNo,BDReqFormDR)) q:(BDReqFormDR="")  d
    .s PackDR="" F  S PackDR=$O(^dbo.BDXMPlanI("IndexMaster",BDReqFormDR,PackDR)) Q:PackDR=""  D
    ..S XMPlanDR="" F  S XMPlanDR=$O(^dbo.BDXMPlanI("IndexMaster",BDReqFormDR,PackDR,XMPlanDR)) Q:XMPlanDR=""  D
    ...S XMPlanInfo=$g(^dbo.BDXMPlanD(XMPlanDR))
    ...S IsBldDifficult=$LG(XMPlanInfo,38)
    ...I IsBldDifficult=1 S Ret=1
	q Ret
}

/// 获取患者最近一次血型信息
/// 入参：登记号  输出：血型
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetPatBDType("47862")
ClassMethod GetPatBDType(PatRegNo As %String)
{
	s LisNamespace = "DHC-LISDATA"
	s PatRegNo=$G(PatRegNo)
	s (PatType,ABOType,RHType)=""
    s ABOTypeInfo=##class(BLD.WS.BLL.DHCTCResult).GetTCResultByRegNoMTHD(PatRegNo,"ABO","","")
    s RHTypeInfo=##class(BLD.WS.BLL.DHCTCResult).GetTCResultByRegNoMTHD(PatRegNo,"RH","","")
    i $l(ABOTypeInfo) s ABOType=$p($p(ABOTypeInfo,"""P5"":""",2),""",",1)
    i $l(RHTypeInfo) s RHType=$p($p(RHTypeInfo,"""P5"":""",2),""",",1)
    s PatType=ABOType_RHType
	q PatType
}

/// 获取患者输血前评估相关信息
/// 入参：就诊号  输出：
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBloodInterface","QryPatReqAssessInfo","22","","","","","","","","","","","",20,1,"106^10^^13^1")
Query QryPatReqAssessInfo(AdmNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "Diagnosis,BeforeSymptom,AssessNo,TestItmData,ProductData")
{
}

ClassMethod QryPatReqAssessInfoExecute(ByRef qHandle As %Binary, AdmNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
    s AdmNo=$g(AdmNo)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s IndexAdmNo=##Class(LIS.Util.Common).IndexData(AdmNo)
    s ReqAssessDR=""
    f  s ReqAssessDR=$o(^dbo.BDReqAssessI("IndexAdmNo",IndexAdmNo,ReqAssessDR),-1) q:ReqAssessDR=""  d
    .s returnflag=0
    .d GetReqAssessData
    
   	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
    //诊断，临床症状，评估单号，输血前检测项目指标，输血申请血产品信息（输血目的，血型，血产品，申请量）
	set ColFields="Diagnosis,BeforeSymptom,AssessNo,TestItmData,ProductData"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
	
GetReqAssessData
    s (ReqAssessData,Status,Diagnosis,BeforeSymptom,AssessNo,TestItmData,ProductData)=""
    //诊断，输血前检测项目指标，临床症状，输血目的，血型，血产品，申请量
	s ReqAssessData = $g(^dbo.BDReqAssessD(ReqAssessDR))
	s Status=$lg(ReqAssessData,36)
	i Status'=30 s returnflag=1 q  //未审核不显示
	s Diagnosis=$lg(ReqAssessData,28)
	s BeforeSymptom=$lg(ReqAssessData,31)
	s AssessNo=$lg(ReqAssessData,2)

	//查询评估检测项目
	s TestItmJsonArray=##Class(LIS.JSON.Json).%New()
	S TestItmJson=##Class(LIS.JSON.Json).%New()
	s fTestItemDR = ""
	for {
		s fTestItemDR = $o(^dbo.BDReqAssessItemResultI("IndexMaster",ReqAssessDR,fTestItemDR))
		q:fTestItemDR=""
		s ItemResultDR=""
		for {
		    s ItemResultDR = $o(^dbo.BDReqAssessItemResultI("IndexMaster",ReqAssessDR,fTestItemDR,ItemResultDR))
		    q:ItemResultDR=""
			s ReqAssessItemResultData=$g(^dbo.BDReqAssessItemResultD(ItemResultDR))
			s TestItemDR=$lg(ReqAssessItemResultData,3),TestItemName="",ScCode=""
			i $l(TestItemDR) s TestItemName=$lg($g(^dbo.BBTestItemD(TestItemDR)),3),ScCode=$lg($g(^dbo.BBTestItemD(TestItemDR)),4)
			s Result=$lg(ReqAssessItemResultData,4)
			s Unit=$lg(ReqAssessItemResultData,5)
			s RefRanges=$lg(ReqAssessItemResultData,6)
			s ResultDate=$lg(ReqAssessItemResultData,7)
			s ResultTime=$lg(ReqAssessItemResultData,8)
			s ResultUserDR=$lg(ReqAssessItemResultData,9),AuthUserName=""
			i ResultUserDR'="" s AuthUserName=$lg($g(^dbo.SYSUserD(ResultUserDR)),3)
			s SeqNum=$lg(ReqAssessItemResultData,10)
			i $l(ResultDate) s ResultDate=$e(ResultDate,1,4)_"-"_$e(ResultDate,5,6)_"-"_$e(ResultDate,7,8)
			i $l(ResultTime) s ResultTime=$zt(ResultTime)
			D TestItmJson.AddKeyValue("TestItemDR",TestItemDR) 
			D TestItmJson.AddKeyValue("RowID",ItemResultDR)
			D TestItmJson.AddKeyValue("TestItemName",TestItemName)
			D TestItmJson.AddKeyValue("Result",Result) 
			D TestItmJson.AddKeyValue("Unit",Unit) 
			D TestItmJson.AddKeyValue("RefRanges",RefRanges) 
			D TestItmJson.AddKeyValue("ResultDate",ResultDate) 
			D TestItmJson.AddKeyValue("ResultTime",ResultTime) 
			D TestItmJson.AddKeyValue("ResultUserDR",ResultUserDR)
			D TestItmJson.AddKeyValue("AuthDate",ResultDate) 
			D TestItmJson.AddKeyValue("AuthTime",ResultTime) 
			D TestItmJson.AddKeyValue("AuthUserName",AuthUserName) 
			D TestItmJson.AddKeyValue("SeqNum",SeqNum) 
			D TestItmJson.AddKeyValue("ScCode",ScCode) 
			S TestItmOneItem = TestItmJson.GetJsonString()
			D TestItmJsonArray.InsertRow(TestItmOneItem)
		}
		s TestItmData = TestItmJsonArray.GetRowsJson()

	}
	
	//查询评估输血成分
	
	s ProductJsonArray=##Class(LIS.JSON.Json).%New()
	S ProductJson=##Class(LIS.JSON.Json).%New()
	s fReqProductDR = "",ReqProductLeftstr=""
	for {
		s fReqProductDR = $o(^dbo.BDReqAssessProductI("IndexMaster",ReqAssessDR,fReqProductDR))
		q:fReqProductDR=""
		S ReqAssessProductDR=""
		
		for{
			s ReqAssessProductDR = $o(^dbo.BDReqAssessProductI("IndexMaster",ReqAssessDR,fReqProductDR,ReqAssessProductDR))
	    	q:ReqAssessProductDR=""
			s ReqAssessProductData=$g(^dbo.BDReqAssessProductD(ReqAssessProductDR))
			s ReqProductDR=$lg(ReqAssessProductData,3),ReqProduct=""
			
			
			i $l(ReqProductDR) s ReqProduct=$lg($g(^dbo.BBReqProductD(ReqProductDR)),3)
			s PurposeDR=$lg(ReqAssessProductData,4) S Purpose=""
			i $l(PurposeDR) s Purpose=$lg($g(^dbo.BBPurposeD(PurposeDR)),3)
			s Volumn=$lg(ReqAssessProductData,5)
			s Unit=$lg(ReqAssessProductData,6)
			
			
			s ReqBloodGroupDR=$lg(ReqAssessProductData,7),ReqBloodGroup=""
			i $l(ReqBloodGroupDR) s ReqBloodGroup=$lg($g(^dbo.BBBloodGroupD(ReqBloodGroupDR)),3)
			s SpecialNeed=$lg(ReqAssessProductData,8)
			s Remark=$lg(ReqAssessProductData,9)
			
			S BloodComponentsDR=$lg($g(^dbo.BBReqProductD(ReqProductDR)),7),BloodComponentsCode="",BloodComponentsSynonym=""
			I $L(BloodComponentsDR) D
			.S BloodComponentsCode=$lg($g(^dbo.BBBloodComponentsD(BloodComponentsDR)),2)
	        .S BloodComponentsSynonym=$lg($g(^dbo.BBBloodComponentsD(BloodComponentsDR)),5)
			
			D ProductJson.AddKeyValue("ReqProductDR",ReqProductDR) 
			D ProductJson.AddKeyValue("PurposeDR",PurposeDR) 
			D ProductJson.AddKeyValue("RowID",fReqProductDR) 
			D ProductJson.AddKeyValue("AssVolumn",Volumn)   //血量
			D ProductJson.AddKeyValue("Unit",Unit)          //单位
			D ProductJson.AddKeyValue("ReqBloodGroupDR",ReqBloodGroupDR) 
			D ProductJson.AddKeyValue("SpecialNeed",SpecialNeed)
			D ProductJson.AddKeyValue("ReqProduct",ReqProduct)   //血产品
			D ProductJson.AddKeyValue("Purpose",Purpose)         //目的
			D ProductJson.AddKeyValue("ReqBloodGroup",ReqBloodGroup)  
			D ProductJson.AddKeyValue("Remark",Remark) 
			D ProductJson.AddKeyValue("BloodComponentsCode",BloodComponentsCode)  
			D ProductJson.AddKeyValue("BloodComponentsSynonym",BloodComponentsSynonym) 
			
			
			S ProductOneItem = ProductJson.GetJsonString()
			D ProductJsonArray.InsertRow(ProductOneItem)
				
			
			}
	
	}
	s ProductData = ProductJsonArray.GetRowsJson()
 	s Data = $lb(Diagnosis,BeforeSymptom,AssessNo,TestItmData,ProductData)
 	d OutPut
 	q
}

ClassMethod QryPatReqAssessInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatReqAssessInfoExecute ]
{
    Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryPatReqAssessInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatReqAssessInfoExecute ]
{
    Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 	Set AtEnd=1
 	Set Row=""
 	}
 	else      {	
 	Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 获取患者输注信息
/// 入参：就诊号  输出：
///                   是否签订知情同意书，患者abo，患者rh，申请类型，发血人，签收时间，签收人
///                   输注开始时间，结束时间，血袋条形码，血产品，血型，血袋血量，血袋单位
///                   是否过期，配血结果，输注中巡视内容 
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBloodInterface","QryPatInfusionInfo","22","","","","","","","","","","","",20,1,"106^10^^13^1")
Query QryPatInfusionInfo(AdmNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "IsAgreeform,ABOType,RHType,BBReqType,IssueUser,ArriveDT,ArriveUser,InfusionStartDT,InfusionEndDT,PackID,BloodProduct,BloodGroup,PackSize,Units,IsEpired,XMLastResult,PackScoutData")
{
}

ClassMethod QryPatInfusionInfoExecute(ByRef qHandle As %Binary, AdmNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
    s AdmNo=$g(AdmNo)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s IndexAdmNo=##Class(LIS.Util.Common).IndexData(AdmNo)
    S (IsAgreeform,ABOType,RHType,BBReqType,IssueUser)=""
    s BDReqFormDR="" f  s BDReqFormDR= $o(^dbo.BDReqFormI("IndexAdmNo",IndexAdmNo,BDReqFormDR)) q:(BDReqFormDR="")  d
    .s BDReqFormData=$g(^dbo.BDReqFormD(BDReqFormDR))
    .s AgreeFormNo=$lg(BDReqFormData,48),IsAgreeform="已签署"  //知情同意书是否签署
    .i '$L(AgreeFormNo) s IsAgreeform="未签署"
    .s ABODR=$lg(BDReqFormData,18),ABOType=""
    .i $l(ABODR) s ABOType=$lg($g(^dbo.BTABOBGD(ABODR)),2)     //ABO
    .s RHDR=$lg(BDReqFormData,19),RHType=""
    .i $l(RHDR) s RHType=$lg($g(^dbo.BTRHBGD(RHDR)),3)       //RH
    .s ReqTypeDR = $lg(BDReqFormData,3)
	.s BBReqType=$lg($g(^dbo.BBReqTypeD(ReqTypeDR)),3)   //申请类型
    .s IssueRecordDR="" f  s IssueRecordDR= $o(^dbo.BDIssueRecordI("IndexReqForm",BDReqFormDR,IssueRecordDR)) q:(IssueRecordDR="")  d
    ..s IssueRecordData=$g(^dbo.BDIssueRecordD(IssueRecordDR))
    ..S IssueUserDR=$LG(IssueRecordData,6),IssueUser=""
    ..i $l(IssueUserDR) s IssueUser=$lg($g(^dbo.SYSUserD(IssueUserDR)),3)
    ..s PackDR="" f  s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) q:PackDR=""  d  
	...s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
	...s IsReturn=$lg($g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR)),4)
	...i IsReturn="1" q   //退血不显示
	...s XMPlanDR=$lg($g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR)),6)
	...s returnflag=0
    ...d GetPackData
    
    
   	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
   
	//是否签订知情同意书，患者abo，患者rh，申请类型，发血人，签收时间，签收人
	//输注开始时间，结束时间，血袋条形码，血产品，血型，血袋血量，血袋单位
	//是否过期，配血结果，输注中巡视内容 
	set ColFields="IsAgreeform,ABOType,RHType,BBReqType,IssueUser,ArriveDT,ArriveUser,InfusionStartDT,InfusionEndDT,PackID,BloodProduct,BloodGroup,PackSize,Units,IsEpired,XMLastResult,PackScoutData"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
	
GetPackData
   
    s (ArriveDT,ArriveUser,InfusionStartDT,InfusionEndDT,PackID,BloodProduct,BloodGroup,PackSize,Units,IsEpired,XMLastResult,PackScoutData)=""
	s PackInfo = $g(^dbo.BDPackD(PackDR))
	S ArriveUserDR=$LG(PackInfo,59),ArriveUser=""
	i $l(ArriveUserDR) s ArriveUser=$lg($g(^dbo.SYSUserD(ArriveUserDR)),3)
	s ArriveDate=$lg(PackInfo,57)
	s ArriveTime=$lg(PackInfo,58)
	i $l(ArriveDate) s ArriveDate=$e(ArriveDate,1,4)_"-"_$e(ArriveDate,5,6)_"-"_$e(ArriveDate,7,8)
	i $l(ArriveTime) s ArriveTime=$zt(ArriveTime)
	S ArriveDT=ArriveDate_" "_ArriveTime
	s InfusionStartDate=$lg(PackInfo,62)
	i InfusionStartDate="" s returnflag=1 q
	b ;;
	s InfusionStartTime=$lg(PackInfo,63)
	i $l(InfusionStartDate) s InfusionStartDate=$e(InfusionStartDate,1,4)_"-"_$e(InfusionStartDate,5,6)_"-"_$e(InfusionStartDate,7,8)
	i $l(InfusionStartTime) s InfusionStartTime=$zt(InfusionStartTime)
	s InfusionStartDT=InfusionStartDate_" "_InfusionStartTime
	s InfusionEndDate=$lg(PackInfo,66)
	s InfusionEndTime=$lg(PackInfo,67)
	i $l(InfusionEndDate) s InfusionEndDate=$e(InfusionEndDate,1,4)_"-"_$e(InfusionEndDate,5,6)_"-"_$e(InfusionEndDate,7,8)
	i $l(InfusionEndTime) s InfusionEndTime=$zt(InfusionEndTime)
	s InfusionEndDT=InfusionEndDate_" "_InfusionEndTime
	
	s BloodProductDR=$lg(PackInfo,3)
	s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))  
    s PackID=$lg(PackInfo,2)
    s BloodProduct=$lg(BloodProductData,3)
    s BloodGroupDR=$lg(PackInfo,9)
    s BloodGroup=$lg(^dbo.BBBloodGroupD(BloodGroupDR),3)
	s PackSize=$lg(PackInfo,10) 
    s Units=$lg(BloodProductData,15)
	s ExpiredDate=$lg(PackInfo,13)
	s ExpiredTime=$lg(PackInfo,14),IsEpired=0  //有效期内
	I ExpiredDate< $zd(+$h,8) s IsEpired=1   //过期
	I ExpiredDate= $zd(+$h,8),ExpiredTime<$p($h,",",2) s IsEpired=1   //过期
	i $L(XMPlanDR) s XMLastResult=$lg($g(^dbo.BDXMPlanD(XMPlanDR)),24)   //配血结果
	
	//查询评估检测项目
	s PackScoutJsonArray=##Class(LIS.JSON.Json).%New()
	S PackScoutJson=##Class(LIS.JSON.Json).%New()
	s ScoutDR = ""
	for {
		s ScoutDR = $o(^dbo.BDPackScoutI("IndexPack",PackDR,ScoutDR))
		q:ScoutDR=""
	    S ScoutDate=$LG($G(^dbo.BDPackScoutD(ScoutDR)),3)
	    S ScoutTime=$LG($G(^dbo.BDPackScoutD(ScoutDR)),4)
	    S ScoutUserDR=$LG($G(^dbo.BDPackScoutD(ScoutDR)),5),ScoutUser=""
	    i $l(ScoutUserDR) s ScoutUser=$Lg($g(^dbo.SYSUserD(ScoutUserDR)),3)
	    S ScoutType=$LG($G(^dbo.BDPackScoutD(ScoutDR)),3)
	    I ScoutType=0 S ScoutType="输注前"
	    I ScoutType=1 S ScoutType="输注中"
	    I ScoutType=2 S ScoutType="输注后"
	    S BodyTemp=$LG($G(^dbo.BDPackScoutD(ScoutDR)),7)
	    S Pulse=$LG($G(^dbo.BDPackScoutD(ScoutDR)),8)
	    S DripSpeed=$LG($G(^dbo.BDPackScoutD(ScoutDR)),9)
	    S SystolicPressure=$LG($G(^dbo.BDPackScoutD(ScoutDR)),10)
	    S DiastolicPressure=$LG($G(^dbo.BDPackScoutD(ScoutDR)),11)
	    S IsReaction=$LG($G(^dbo.BDPackScoutD(ScoutDR)),12)
	    S HeartRate=$LG($G(^dbo.BDPackScoutD(ScoutDR)),16)
	    S Breathing=$LG($G(^dbo.BDPackScoutD(ScoutDR)),17)
	    S Height=$LG($G(^dbo.BDPackScoutD(ScoutDR)),18)
	    S Weight=$LG($G(^dbo.BDPackScoutD(ScoutDR)),19)
		i $l(ScoutDate) s ScoutDate=$e(ScoutDate,1,4)_"-"_$e(ScoutDate,5,6)_"-"_$e(ScoutDate,7,8)
		i $l(ScoutTime) s ScoutTime=$zt(ScoutTime)
		s ScoutDT=ScoutDate_" "_ScoutTime
		D PackScoutJson.AddKeyValue("ScoutDT",ScoutDT)       //巡视时间
		D PackScoutJson.AddKeyValue("ScoutUser",ScoutUser)   //巡视人
		D PackScoutJson.AddKeyValue("ScoutType",ScoutType)   //巡视类型
		D PackScoutJson.AddKeyValue("BodyTemp",BodyTemp)     //体温
		D PackScoutJson.AddKeyValue("Pulse",Pulse)            //脉搏
		D PackScoutJson.AddKeyValue("DripSpeed",DripSpeed)     //滴速
		D PackScoutJson.AddKeyValue("SystolicPressure",SystolicPressure)    //低压
		D PackScoutJson.AddKeyValue("DiastolicPressure",DiastolicPressure)   //高压
		D PackScoutJson.AddKeyValue("IsReaction",IsReaction)                 //是否不良反应
		D PackScoutJson.AddKeyValue("HeartRate",HeartRate)         //心率
		D PackScoutJson.AddKeyValue("Breathing",Breathing)         //呼吸
		D PackScoutJson.AddKeyValue("Height",Height)          //身高
		D PackScoutJson.AddKeyValue("Weight",Weight)          //体重
		S PackScoutItem = PackScoutJson.GetJsonString()
		D PackScoutJsonArray.InsertRow(PackScoutItem)
	
	}
	s PackScoutData = PackScoutJsonArray.GetRowsJson()
 	s Data = $lb(IsAgreeform,ABOType,RHType,BBReqType,IssueUser,ArriveDT,ArriveUser,InfusionStartDT,InfusionEndDT,PackID,BloodProduct,BloodGroup,PackSize,Units,IsEpired,XMLastResult,PackScoutData)
 	d OutPut
 	q
}

ClassMethod QryPatInfusionInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatInfusionInfoExecute ]
{
    Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryPatInfusionInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatInfusionInfoExecute ]
{
    Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 	Set AtEnd=1
 	Set Row=""
 	}
 	else      {	
 	Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 获取患者输血后评价信息
/// 入参：就诊号  输出：输注开始时间，血液产品，血型，血袋血量，输血后检验结果变化分析，输血后疗效评价 
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBloodInterface","QryPatTransEvlInfo","22","","","","","","","","","","","",20,1,"106^10^^13^1")
Query QryPatTransEvlInfo(AdmNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "InfusionStartDT,BloodProduct,BloodGroup,PackVol,TransItemResultData,EvaluateResult")
{
}

ClassMethod QryPatTransEvlInfoExecute(ByRef qHandle As %Binary, AdmNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
    s AdmNo=$g(AdmNo)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s IndexAdmNo=##Class(LIS.Util.Common).IndexData(AdmNo)
    s BDReqFormDR="" f  s BDReqFormDR= $o(^dbo.BDReqFormI("IndexAdmNo",IndexAdmNo,BDReqFormDR)) q:(BDReqFormDR="")  d
    .s BDReqFormData=$g(^dbo.BDReqFormD(BDReqFormDR))
    .s TransEvalDR="" f  s TransEvalDR= $o(^dbo.BDTransEvaluationI("IndexReqForm",BDReqFormDR,TransEvalDR)) q:(TransEvalDR="")  d
    ..s TransEvaluationData=$g(^dbo.BDTransEvaluationD(TransEvalDR))
    ..s EvaluationStatus=$lg(TransEvaluationData,43)
    ..d GetPackTransElvData
    
    
   	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
   
	//输注开始时间，血液产品，血型，血袋血量，输血后检验结果变化分析，输血后疗效评价  
	set ColFields="InfusionStartDT,BloodProduct,BloodGroup,PackVol,TransItemResultData,EvaluateResult"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
	
GetPackTransElvData
    s (InfusionStartDT,BloodProduct,BloodGroup,PackVol,TransItemResultData,EvaluateResult)=""
    //输注开始时间，血液产品，血型，血袋血量，输血后检验结果变化分析，输血后疗效评价 
	s IssueRecordDRs = $lg(TransEvaluationData,4)
	s EvaluateResult=$lg(TransEvaluationData,6)
	s EvaluateText=$lg(TransEvaluationData,7)
	i $l(EvaluateText) s EvaluateResult=EvaluateResult_":"_EvaluateText
	i $tr(IssueRecordDRs,$c(0),"")="" q

	f i=1:1:$l(IssueRecordDRs,",") d
	.s IssueRecordDR=$p(IssueRecordDRs,",",i)
	.i IssueRecordDR="" q
	.s PackDR=""
	.f  s PackDR=$o(^dbo.BBIssueRecordItemI("IndexMaster",IssueRecordDR,PackDR)) Q:PackDR=""  D
	..s PackInfo = $g(^dbo.BDPackD(PackDR))
	..s InfusionStartDate=$lg(PackInfo,62)
	..//i InfusionStartDate="" q
	..s InfusionStartTime=$lg(PackInfo,63)
	..i $l(InfusionStartDate) s InfusionStartDate=$e(InfusionStartDate,1,4)_"-"_$e(InfusionStartDate,5,6)_"-"_$e(InfusionStartDate,7,8)
	..i $l(InfusionStartTime) s InfusionStartTime=$zt(InfusionStartTime)
	..s InfusionStartDT=InfusionStartDate_" "_InfusionStartTime
	..s BloodProductDR=$lg(PackInfo,3)
	..s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
    ..s PackID=$lg(PackInfo,2)
    ..s BloodProduct=$lg(BloodProductData,3)
    ..s BloodGroupDR=$lg(PackInfo,9)
    ..s BloodGroup=$lg(^dbo.BBBloodGroupD(BloodGroupDR),3)
    ..s PackSize=$lg(PackInfo,10)
    ..s Units=$lg(BloodProductData,15) 
    ..s PackVol=PackSize_Units
    ..d GetTransItemResult
    ..s Data = $lb(InfusionStartDT,BloodProduct,BloodGroup,PackVol,TransItemResultData,EvaluateResult)
 	..d OutPut
 	q

GetTransItemResult	
	//查询评价检测项目
	s TransItemResultJsonArray=##Class(LIS.JSON.Json).%New()
	S TransItemResultJson=##Class(LIS.JSON.Json).%New()
	s ItemResultDR = ""
	for {
		s ItemResultDR = $o(^dbo.BDEvaluationItemResultI("IndexMaster",TransEvalDR,ItemResultDR))
		q:ItemResultDR=""
	    S TestItemDR=$LG($G(^dbo.BDEvaluationItemResultD(ItemResultDR)),3)
	    S TestName=$lg($g(^dbo.BBTestItemD(TestItemDR)),3)
	    S Result=$LG($G(^dbo.BDEvaluationItemResultD(ItemResultDR)),3)
	    S Unit=$LG($G(^dbo.BDEvaluationItemResultD(ItemResultDR)),3)
	    S RefRanges=$LG($G(^dbo.BDEvaluationItemResultD(ItemResultDR)),3)
	    S ResultDate=$LG($G(^dbo.BDEvaluationItemResultD(ItemResultDR)),3)
	    S ResultTime=$LG($G(^dbo.BDEvaluationItemResultD(ItemResultDR)),3)
		i $l(ResultDate) s ResultDate=$e(ResultDate,1,4)_"-"_$e(ResultDate,5,6)_"-"_$e(ResultDate,7,8)
		i $l(ResultTime) s ResultTime=$zt(ResultTime)
		s ResultDT=ResultDate_" "_ResultTime
		
		D TransItemResultJson.AddKeyValue("TestName",TestName) 
		D TransItemResultJson.AddKeyValue("Result",Result)
		D TransItemResultJson.AddKeyValue("Unit",Unit)
		D TransItemResultJson.AddKeyValue("RefRanges",RefRanges) 
		D TransItemResultJson.AddKeyValue("ResultDT",ResultDT) 
		
		S TransItemResultItem = TransItemResultJson.GetJsonString()
		D TransItemResultJsonArray.InsertRow(TransItemResultItem)
	
	}
	s TransItemResultData = TransItemResultJsonArray.GetRowsJson()
	q
}

ClassMethod QryPatTransEvlInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatTransEvlInfoExecute ]
{
    Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryPatTransEvlInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatTransEvlInfoExecute ]
{
    Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 	Set AtEnd=1
 	Set Row=""
 	}
 	else      {	
 	Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 获取输血前评估，输注，输血后评价信息
/// 入参：AdmNo，就诊号 
/// 输出：Diagnosis,BeforeSymptom,AssessNo,TestItmData,ProductData,InfusionStartDT,InfusionEndDT,PackID,BloodProduct,BloodGroup,PackScoutData,EVInfusionStartDT,EVBloodProduct,EVBloodGroup,PackVol,TransItemResultData,EvaluateResult 
/// 输出：诊断，临床症状，输血前评估单号，输血前评估检测项目，评估血产品信息，输注开始时间，输注结束时间，血袋献血码，血产品，血型，输注巡视信息，输血后评价中开始输血日期，输血后评价血产品，输血后评价血型，血量，输血后评价检测项目，输血后效果评价 
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBloodInterface","QryPatTransInfo","22","","","","","","","","","","","",20,1,"106^10^^13^1")
Query QryPatTransInfo(AdmNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "ReqAssessInfoData,PackScoutInfo,EvaluateInfo")
{
}

ClassMethod QryPatTransInfoExecute(ByRef qHandle As %Binary, AdmNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
    s AdmNo=$g(AdmNo)
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    
    s (Diagnosis,BeforeSymptom,AssessNo,TestItmData,ProductData)=""
    s (InfusionStartDT,InfusionEndDT,PackID,BloodProduct,BloodGroup,PackScoutData)=""
    s (EVInfusionStartDT,EVBloodProduct,EVBloodGroup,PackVol,TransItemResultData,EvaluateResult)=""
    
    s IndexAdmNo=##Class(LIS.Util.Common).IndexData(AdmNo)
    //输血前评估内容
    s ReqAssessArray=##Class(LIS.JSON.Json).%New()
	S ReqAssessJson=##Class(LIS.JSON.Json).%New()
	//输注巡视信息
	s PackSoutArray=##Class(LIS.JSON.Json).%New()
	S PackSoutJson=##Class(LIS.JSON.Json).%New()
	//输血后评价信息
	s EvaluateArray=##Class(LIS.JSON.Json).%New()
	S EvaluateJson=##Class(LIS.JSON.Json).%New()
	
    s ReqAssessDR=""
    f  s ReqAssessDR=$o(^dbo.BDReqAssessI("IndexAdmNo",IndexAdmNo,ReqAssessDR),-1) q:ReqAssessDR=""  d
    .s returnflag=0
    .d GetReqAssessData
    s BDReqFormDR="" f  s BDReqFormDR= $o(^dbo.BDReqFormI("IndexAdmNo",IndexAdmNo,BDReqFormDR)) q:(BDReqFormDR="")  d
    .s BDReqFormData=$g(^dbo.BDReqFormD(BDReqFormDR))
    .//获取输注信息
    .s IssueRecordDR="" f  s IssueRecordDR= $o(^dbo.BDIssueRecordI("IndexReqForm",BDReqFormDR,IssueRecordDR)) q:(IssueRecordDR="")  d
    ..s IssueRecordData=$g(^dbo.BDIssueRecordD(IssueRecordDR))
    ..s PackDR="" f  s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) q:PackDR=""  d  
	...s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
	...s IsReturn=$lg($g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR)),4)
	...i IsReturn="1" q   //退血不显示
	...s returnflag=0
	...//b ;01zz
    ...d GetPackData
    ...//b ;00
    .//获取输血后评价
    .s TransEvalDR="" f  s TransEvalDR= $o(^dbo.BDTransEvaluationI("IndexReqForm",BDReqFormDR,TransEvalDR)) q:(TransEvalDR="")  d
    ..s TransEvaluationData=$g(^dbo.BDTransEvaluationD(TransEvalDR))
    ..s EvaluationStatus=$lg(TransEvaluationData,43)
    
    ..d GetPackTransElvData
    ..//b ;01
    d OutPut
    
    
   	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
   
	//输注开始时间，血液产品，血型，血袋血量，输血后检验结果变化分析，输血后疗效评价 

	Set Data=$lb(ReqAssessInfoData,PackScoutInfo,EvaluateInfo) 
	set ColFields="ReqAssessInfoData,PackScoutInfo,EvaluateInfo"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit

GetPackData
    
    s (InfusionStartDT,InfusionEndDT,PackID,BloodProduct,BloodGroup,PackScoutData)=""
    //输注开始时间，结束时间，血型，血产品，血袋血量，输注中巡视内容
	s PackInfo = $g(^dbo.BDPackD(PackDR))
	s InfusionStartDate=$lg(PackInfo,62)
	//i InfusionStartDate="" q returnflag=1 
	
	s InfusionStartTime=$lg(PackInfo,63)
	i $l(InfusionStartDate) s InfusionStartDate=$e(InfusionStartDate,1,4)_"-"_$e(InfusionStartDate,5,6)_"-"_$e(InfusionStartDate,7,8)
	i $l(InfusionStartTime) s InfusionStartTime=$zt(InfusionStartTime)
	s InfusionStartDT=InfusionStartDate_" "_InfusionStartTime
	s InfusionEndDate=$lg(PackInfo,66)
	s InfusionEndTime=$lg(PackInfo,67)
	i $l(InfusionEndDate) s InfusionEndDate=$e(InfusionEndDate,1,4)_"-"_$e(InfusionEndDate,5,6)_"-"_$e(InfusionEndDate,7,8)
	i $l(InfusionEndTime) s InfusionEndTime=$zt(InfusionEndTime)
	s InfusionEndDT=InfusionEndDate_" "_InfusionEndTime
	
	s BloodProductDR=$lg(PackInfo,3)
	s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
    s PackID=$lg(PackInfo,2)
    s BloodProduct=$lg(BloodProductData,3)
    s BloodGroupDR=$lg(PackInfo,9)
    s BloodGroup=$lg(^dbo.BBBloodGroupD(BloodGroupDR),3)
	//查询评估检测项目
	s PackScoutDetilJsonArray=##Class(LIS.JSON.Json).%New()
	S PackScoutDetilJson=##Class(LIS.JSON.Json).%New()
	s ScoutDR = ""
	for {
		s ScoutDR = $o(^dbo.BDPackScoutI("IndexPack",PackDR,ScoutDR))
		q:ScoutDR=""
	    S ScoutDate=$LG($G(^dbo.BDPackScoutD(ScoutDR)),3)
	    S ScoutTime=$LG($G(^dbo.BDPackScoutD(ScoutDR)),4)
	    S ScoutUserDR=$LG($G(^dbo.BDPackScoutD(ScoutDR)),5),ScoutUser=""
	    i $l(ScoutUserDR) s ScoutUser=$Lg($g(^dbo.SYSUserD(ScoutUserDR)),3)
	    S ScoutType=$LG($G(^dbo.BDPackScoutD(ScoutDR)),3)
	    I ScoutType=0 S ScoutType="输注前"
	    I ScoutType=1 S ScoutType="输注中"
	    I ScoutType=2 S ScoutType="输注后"
	    S BodyTemp=$LG($G(^dbo.BDPackScoutD(ScoutDR)),3)
	    S Pulse=$LG($G(^dbo.BDPackScoutD(ScoutDR)),3)
	    S DripSpeed=$LG($G(^dbo.BDPackScoutD(ScoutDR)),3)
	    S SystolicPressure=$LG($G(^dbo.BDPackScoutD(ScoutDR)),3)
	    S DiastolicPressure=$LG($G(^dbo.BDPackScoutD(ScoutDR)),3)
	    S IsReaction=$LG($G(^dbo.BDPackScoutD(ScoutDR)),3)
	    S HeartRate=$LG($G(^dbo.BDPackScoutD(ScoutDR)),16)
	    S Breathing=$LG($G(^dbo.BDPackScoutD(ScoutDR)),16)
	    S Height=$LG($G(^dbo.BDPackScoutD(ScoutDR)),16)
	    S Weight=$LG($G(^dbo.BDPackScoutD(ScoutDR)),16)
		i $l(ScoutDate) s ScoutDate=$e(ScoutDate,1,4)_"-"_$e(ScoutDate,5,6)_"-"_$e(ScoutDate,7,8)
		i $l(ScoutTime) s ScoutTime=$zt(ScoutTime)
		s ScoutDT=ScoutDate_" "_ScoutTime
		
		
		D PackScoutDetilJson.AddKeyValue("ScoutDT",ScoutDT) 
		D PackScoutDetilJson.AddKeyValue("ScoutUser",ScoutUser)
		D PackScoutDetilJson.AddKeyValue("ScoutType",ScoutType)
		D PackScoutDetilJson.AddKeyValue("BodyTemp",BodyTemp) 
		D PackScoutDetilJson.AddKeyValue("Pulse",Pulse) 
		D PackScoutDetilJson.AddKeyValue("DripSpeed",DripSpeed) 
		D PackScoutDetilJson.AddKeyValue("SystolicPressure",SystolicPressure) 
		D PackScoutDetilJson.AddKeyValue("DiastolicPressure",DiastolicPressure) 
		D PackScoutDetilJson.AddKeyValue("IsReaction",IsReaction)
		D PackScoutDetilJson.AddKeyValue("HeartRate",HeartRate) 
		D PackScoutDetilJson.AddKeyValue("Breathing",Breathing) 
		D PackScoutDetilJson.AddKeyValue("Height",Height) 
		D PackScoutDetilJson.AddKeyValue("Weight",Weight) 
		S PackScoutDetilItem = PackScoutDetilJson.GetJsonString()
		D PackScoutDetilJsonArray.InsertRow(PackScoutDetilItem)
	
	}
	s PackScoutDetilData = PackScoutDetilJsonArray.GetRowsJson()
	s PackScoutArray=##Class(LIS.JSON.Json).%New()
	s PackScoutJsonArray=##Class(LIS.JSON.Json).%New()
	S PackScoutJson=##Class(LIS.JSON.Json).%New()
	D PackScoutJson.AddKeyValue("InfusionStartDT",InfusionStartDT) 
	D PackScoutJson.AddKeyValue("InfusionEndDT",InfusionEndDT) 
	D PackScoutJson.AddKeyValue("PackID",PackID) 
	D PackScoutJson.AddKeyValue("BloodProduct",BloodProduct) 
	D PackScoutJson.AddKeyValue("BloodGroup",BloodGroup) 
	D PackScoutJson.AddKeyValue("PackScoutDetilData",PackScoutDetilData)
	S PackScoutItem = PackScoutJson.GetJsonString()
	D PackScoutJsonArray.InsertRow(PackScoutItem)
	s PackScoutInfo = PackScoutJsonArray.GetRowsJson()

 	q
 	
GetReqAssessData
    s (ReqAssessInfoData,ReqAssessData,Status,Diagnosis,BeforeSymptom,AssessNo,TestItmData,ProductData)=""
    //诊断，输血前检测项目指标，临床症状，输血目的，血型，血产品，申请量
	s ReqAssessData = $g(^dbo.BDReqAssessD(ReqAssessDR))
	s Status=$lg(ReqAssessData,36)
	i Status'=30 s returnflag=1 q  //未审核不显示
	s Diagnosis=$lg(ReqAssessData,28)
	s BeforeSymptom=$lg(ReqAssessData,31)
	s AssessNo=$lg(ReqAssessData,2)

	//查询评估检测项目
	s TestItmJsonArray=##Class(LIS.JSON.Json).%New()
	S TestItmJson=##Class(LIS.JSON.Json).%New()
	s fTestItemDR = ""
	for {
		s fTestItemDR = $o(^dbo.BDReqAssessItemResultI("IndexMaster",ReqAssessDR,fTestItemDR))
		q:fTestItemDR=""
		s ItemResultDR=""
		for {
		    s ItemResultDR = $o(^dbo.BDReqAssessItemResultI("IndexMaster",ReqAssessDR,fTestItemDR,ItemResultDR))
		    q:ItemResultDR=""
			s ReqAssessItemResultData=$g(^dbo.BDReqAssessItemResultD(ItemResultDR))
			s TestItemDR=$lg(ReqAssessItemResultData,3),TestItemName="",ScCode=""
			i $l(TestItemDR) s TestItemName=$lg($g(^dbo.BBTestItemD(TestItemDR)),3),ScCode=$lg($g(^dbo.BBTestItemD(TestItemDR)),4)
			s Result=$lg(ReqAssessItemResultData,4)
			s Unit=$lg(ReqAssessItemResultData,5)
			s RefRanges=$lg(ReqAssessItemResultData,6)
			s ResultDate=$lg(ReqAssessItemResultData,7)
			s ResultTime=$lg(ReqAssessItemResultData,8)
			s ResultUserDR=$lg(ReqAssessItemResultData,9),AuthUserName=""
			i ResultUserDR'="" s AuthUserName=$lg($g(^dbo.SYSUserD(ResultUserDR)),3)
			s SeqNum=$lg(ReqAssessItemResultData,10)
			i $l(ResultDate) s ResultDate=$e(ResultDate,1,4)_"-"_$e(ResultDate,5,6)_"-"_$e(ResultDate,7,8)
			i $l(ResultTime) s ResultTime=$zt(ResultTime)
			D TestItmJson.AddKeyValue("TestItemDR",TestItemDR) 
			D TestItmJson.AddKeyValue("RowID",ItemResultDR)
			D TestItmJson.AddKeyValue("TestItemName",TestItemName)
			D TestItmJson.AddKeyValue("Result",Result) 
			D TestItmJson.AddKeyValue("Unit",Unit) 
			D TestItmJson.AddKeyValue("RefRanges",RefRanges) 
			D TestItmJson.AddKeyValue("ResultDate",ResultDate) 
			D TestItmJson.AddKeyValue("ResultTime",ResultTime) 
			D TestItmJson.AddKeyValue("ResultUserDR",ResultUserDR)
			D TestItmJson.AddKeyValue("AuthDate",ResultDate) 
			D TestItmJson.AddKeyValue("AuthTime",ResultTime) 
			D TestItmJson.AddKeyValue("AuthUserName",AuthUserName) 
			D TestItmJson.AddKeyValue("SeqNum",SeqNum) 
			D TestItmJson.AddKeyValue("ScCode",ScCode) 
			S TestItmOneItem = TestItmJson.GetJsonString()
			D TestItmJsonArray.InsertRow(TestItmOneItem)
		}
		s TestItmData = TestItmJsonArray.GetRowsJson()

	}
	
	//查询评估输血成分
	
	s ProductJsonArray=##Class(LIS.JSON.Json).%New()
	S ProductJson=##Class(LIS.JSON.Json).%New()
	s fReqProductDR = "",ReqProductLeftstr=""
	for {
		s fReqProductDR = $o(^dbo.BDReqAssessProductI("IndexMaster",ReqAssessDR,fReqProductDR))
		q:fReqProductDR=""
		S ReqAssessProductDR=""
		
		for{
			s ReqAssessProductDR = $o(^dbo.BDReqAssessProductI("IndexMaster",ReqAssessDR,fReqProductDR,ReqAssessProductDR))
	    	q:ReqAssessProductDR=""
			s ReqAssessProductData=$g(^dbo.BDReqAssessProductD(ReqAssessProductDR))
			s ReqProductDR=$lg(ReqAssessProductData,3),ReqProduct=""
			
			
			i $l(ReqProductDR) s ReqProduct=$lg($g(^dbo.BBReqProductD(ReqProductDR)),3)
			s PurposeDR=$lg(ReqAssessProductData,4) S Purpose=""
			i $l(PurposeDR) s Purpose=$lg($g(^dbo.BBPurposeD(PurposeDR)),3)
			s Volumn=$lg(ReqAssessProductData,5)
			s Unit=$lg(ReqAssessProductData,6)
			
			
			s ReqBloodGroupDR=$lg(ReqAssessProductData,7),ReqBloodGroup=""
			i $l(ReqBloodGroupDR) s ReqBloodGroup=$lg($g(^dbo.BBBloodGroupD(ReqBloodGroupDR)),3)
			s SpecialNeed=$lg(ReqAssessProductData,8)
			s Remark=$lg(ReqAssessProductData,9)
			
			S BloodComponentsDR=$lg($g(^dbo.BBReqProductD(ReqProductDR)),7),BloodComponentsCode="",BloodComponentsSynonym=""
			I $L(BloodComponentsDR) D
			.S BloodComponentsCode=$lg($g(^dbo.BBBloodComponentsD(BloodComponentsDR)),2)
	        .S BloodComponentsSynonym=$lg($g(^dbo.BBBloodComponentsD(BloodComponentsDR)),5)
			
			D ProductJson.AddKeyValue("ReqProductDR",ReqProductDR) 
			D ProductJson.AddKeyValue("PurposeDR",PurposeDR) 
			D ProductJson.AddKeyValue("RowID",fReqProductDR) 
			D ProductJson.AddKeyValue("AssVolumn",Volumn)   //血量
			D ProductJson.AddKeyValue("Unit",Unit)          //单位
			D ProductJson.AddKeyValue("ReqBloodGroupDR",ReqBloodGroupDR) 
			D ProductJson.AddKeyValue("SpecialNeed",SpecialNeed)
			D ProductJson.AddKeyValue("ReqProduct",ReqProduct)   //血产品
			D ProductJson.AddKeyValue("Purpose",Purpose)         //目的
			D ProductJson.AddKeyValue("ReqBloodGroup",ReqBloodGroup)  
			D ProductJson.AddKeyValue("Remark",Remark) 
			D ProductJson.AddKeyValue("BloodComponentsCode",BloodComponentsCode)  
			D ProductJson.AddKeyValue("BloodComponentsSynonym",BloodComponentsSynonym) 
			
			
			S ProductOneItem = ProductJson.GetJsonString()
			D ProductJsonArray.InsertRow(ProductOneItem)
			}
	
	}
	s ProductData = ProductJsonArray.GetRowsJson()
	

	D ReqAssessJson.AddKeyValue("AssessNo",AssessNo) 
	D ReqAssessJson.AddKeyValue("Diagnosis",Diagnosis) 
	D ReqAssessJson.AddKeyValue("BeforeSymptom",BeforeSymptom) 
	D ReqAssessJson.AddKeyValue("TestItmData",TestItmData) 
	D ReqAssessJson.AddKeyValue("ProductData",ProductData)   
	S ReqAssessOneItem = ReqAssessJson.GetJsonString()
	D ReqAssessArray.InsertRow(ReqAssessOneItem)
	s ReqAssessInfoData = ReqAssessArray.GetRowsJson()
 	q


	
GetPackTransElvData
    s (EVInfusionStartDT,EVBloodProduct,EVBloodGroup,PackVol,TransItemResultData,EvaluateResult,EvaluateInfo)=""
    //输注开始时间，血液产品，血型，血袋血量，输血后检验结果变化分析，输血后疗效评价 
	s IssueRecordDRs = $lg(TransEvaluationData,4)
	s EvaluateResult=$lg(TransEvaluationData,6)
	s EvaluateText=$lg(TransEvaluationData,7)
	i $l(EvaluateText) s EvaluateResult=EvaluateResult_":"_EvaluateText
	i $tr(IssueRecordDRs,$c(0),"")="" q

	f i=1:1:$l(IssueRecordDRs,",") d
	.s IssueRecordDR=$p(IssueRecordDRs,",",i)
	.i IssueRecordDR="" q
	.s PackDR=""
	.f  s PackDR=$o(^dbo.BBIssueRecordItemI("IndexMaster",IssueRecordDR,PackDR)) Q:PackDR=""  D
	..s PackInfo = $g(^dbo.BDPackD(PackDR))
	..s EVInfusionStartDate=$lg(PackInfo,62)
	..s EVInfusionStartTime=$lg(PackInfo,63)
	..i $l(EVInfusionStartDate) s EVInfusionStartDate=$e(EVInfusionStartDate,1,4)_"-"_$e(EVInfusionStartDate,5,6)_"-"_$e(EVInfusionStartDate,7,8)
	..i $l(EVInfusionStartTime) s EVInfusionStartTime=$zt(EVInfusionStartTime)
	..s EVInfusionStartDT=EVInfusionStartDate_" "_EVInfusionStartTime
	..s EVBloodProductDR=$lg(PackInfo,3)
	..s EVBloodProductData=$g(^dbo.BBBloodProductD(EVBloodProductDR))
    ..s PackID=$lg(PackInfo,2)
    ..s EVBloodProduct=$lg(EVBloodProductData,3)
    ..s EVBloodGroupDR=$lg(PackInfo,9)
    ..s EVBloodGroup=$lg(^dbo.BBBloodGroupD(EVBloodGroupDR),3)
    ..s PackSize=$lg(PackInfo,10)
    ..s Units=$lg(BloodProductData,15) 
    ..s PackVol=PackSize_Units
    ..d GetTransItemResult
    q

GetTransItemResult	
	//查询评价检测项目
	
	
	s EvaluateTestJsonArray=##Class(LIS.JSON.Json).%New()
	S EvaluateTestJson=##Class(LIS.JSON.Json).%New()
	s ItemResultDR = ""
	for {
		s ItemResultDR = $o(^dbo.BDEvaluationItemResultI("IndexMaster",TransEvalDR,ItemResultDR))
		q:ItemResultDR=""
	    S TestItemDR=$LG($G(^dbo.BDEvaluationItemResultD(ItemResultDR)),3)
	    S TestName=$lg($g(^dbo.BBTestItemD(TestItemDR)),3)
	    S Result=$LG($G(^dbo.BDEvaluationItemResultD(ItemResultDR)),3)
	    S Unit=$LG($G(^dbo.BDEvaluationItemResultD(ItemResultDR)),3)
	    S RefRanges=$LG($G(^dbo.BDEvaluationItemResultD(ItemResultDR)),3)
	    S ResultDate=$LG($G(^dbo.BDEvaluationItemResultD(ItemResultDR)),3)
	    S ResultTime=$LG($G(^dbo.BDEvaluationItemResultD(ItemResultDR)),3)
		i $l(ResultDate) s ResultDate=$e(ResultDate,1,4)_"-"_$e(ResultDate,5,6)_"-"_$e(ResultDate,7,8)
		i $l(ResultTime) s ResultTime=$zt(ResultTime)
		s ResultDT=ResultDate_" "_ResultTime

		D EvaluateTestJson.AddKeyValue("TestName",TestName) 
		D EvaluateTestJson.AddKeyValue("Result",Result)
		D EvaluateTestJson.AddKeyValue("Unit",Unit)
		D EvaluateTestJson.AddKeyValue("RefRanges",RefRanges) 
		D EvaluateTestJson.AddKeyValue("ResultDT",ResultDT) 
		S EvaluateTestItem = EvaluateTestJson.GetJsonString()
		D EvaluateTestJsonArray.InsertRow(EvaluateTestItem)
	
	}
	s EvaluateTestInfo = EvaluateTestJsonArray.GetRowsJson()
	
	
	D EvaluateJson.AddKeyValue("EVInfusionStartDT",EVInfusionStartDT)
	D EvaluateJson.AddKeyValue("EVBloodProduct",EVBloodProduct)
	D EvaluateJson.AddKeyValue("EVBloodGroup",EVBloodGroup)
	D EvaluateJson.AddKeyValue("PackVol",PackVol)
	D EvaluateJson.AddKeyValue("EvaluateResult",EvaluateResult)
	D EvaluateJson.AddKeyValue("EvaluateTestInfo",EvaluateTestInfo)
	S EvaluateItem = EvaluateJson.GetJsonString()
    D EvaluateJsonArray.InsertRow(EvaluateItem)
    s EvaluateInfo = EvaluateJsonArray.GetRowsJson()
	
	q
}

ClassMethod QryPatTransInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatTransInfoExecute ]
{
    Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryPatTransInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatTransInfoExecute ]
{
    Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 	Set AtEnd=1
 	Set Row=""
 	}
 	else      {	
 	Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 血袋回收接口
/// zyx CallBackDirection回收地点 1废弃 2 检验科，3血库 4其他
/// 20210727
/// w ##Class(DHCLIS.DHCBloodInterface).UpdatePackBackInfo("170","BLD01","2021-08-17 15:00")
ClassMethod UpdatePackBackInfo(PackID As %String, BackUserCode As %String, BackTime As %String, CallBackDirection As %String = "")
{
	Set $ZTrap = "ErrorHandle" 
    new $NAMESPACE     
	s $namespace="DHC-LISDATA" 
	s Ret=##Class(Service.BLD.PACK.PackService).SaveCallbackInfo(PackID,BackUserCode,BackTime,CallBackDirection)
	s $namespace="DHC-APP"
	q Ret
	
ErrorHandle  
	s Ret="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
    Quit Ret
}

/// 获取输血前评估填写情况
/// 入参：患者就诊号：AdmNo
/// w ##CLASS(LISAPP.DHCBloodInterface).GetReqAssessInfo("22")
ClassMethod GetReqAssessInfo(AdmNo As %String)
{
	
	S CurDate=+$h
	S Ret="",ReqAssStaRet="",ReqAssLinkRet="",ReqAssTypeRet="",ReqAssRejectRet="",Returnflag=0
	S IndexAdmNo=##Class(LIS.Util.Common).IndexData(AdmNo)
	S ReqAssessDR="",Count=0
	F  S ReqAssessDR=$O(^dbo.BDReqAssessI("IndexAdmNo",IndexAdmNo,ReqAssessDR)) Q:ReqAssessDR=""  D
	.S ReqAssessData=$G(^dbo.BDReqAssessD(ReqAssessDR))
	.S CheckDate=$LG(ReqAssessData,38) 
	.I CheckDate="" Q    //临床未审核的过滤
	.S FCheckDate=$ZDH(CheckDate,8)
	.I CurDate-FCheckDate>3 Q                  //查询3天以内的评估单
	.S Status=$LG(ReqAssessData,36)           //30审核 25输血科待审 35输血科拒审
	.I ((Status'=30)&&(Status'=25)&&(Status'=35)) Q             
	.S CheckTime=$LG(ReqAssessData,39)
	.S AssessTypeDR=$LG(ReqAssessData,3),AssessType=""
	.I $L(AssessTypeDR) s AssessType=$lg($g(^dbo.BBReqTypeD(AssessTypeDR)),3)
	.I AssessType'["手术" S ReqAssTypeRet="评估类型非手术用血" Q
	.S AssessNo=$LG(ReqAssessData,2)
	.D GetReqAssessIsLinkReqform
	.I Returnflag=1 S ReqAssLinkRet="评估单关联申请单用血量剩余为0，需重新填写评估单" Q 
	.I Status="25" S ReqAssStaRet="输血科未审核输血前评估单" Q   
	.I Status="35" D  Q
	..S DeptChekRemark=$LG(ReqAssessData,44)
	..S ReqAssRejectRet="输血科拒审，拒审原因："_DeptChekRemark   
    .S Count=Count+1
    
    I Count>0 S Ret="1^输血科审批通过"
    I Count=0,'$L(ReqAssLinkRet),'$L(ReqAssStaRet),'$l(ReqAssRejectRet),'$L(ReqAssTypeRet) S Ret="-1^请填写输血前评估单"
    I Count=0,$L(ReqAssTypeRet) S Ret="-1^"_ReqAssTypeRet
    I Count=0,$L(ReqAssLinkRet) S Ret="-1^"_ReqAssLinkRet
    I Count=0,$L(ReqAssRejectRet) S Ret="-1^"_ReqAssRejectRet
    I Count=0,$L(ReqAssStaRet) S Ret="-1^"_ReqAssStaRet 
    Q Ret

GetReqAssessIsLinkReqform	
	S ReqformDR="",ReqformNostr="",ReqProductDRstr=""
	s fReqProductDR = "",ReqProductLeftstr=""
	//查询已关联申请单信息
	F  S ReqformDR=$O(^dbo.BDReqFormI("IndexReqAssessNo",##Class(LIS.Util.Common).IndexData(AssessNo),ReqformDR)) q:ReqformDR=""  d
	.S ReqformNo=$LG($G(^dbo.BDReqFormD(ReqformDR)),2)
	.S ReqFormStatus=$LG($G(^dbo.BDReqFormD(ReqformDR)),51)
	.I ReqFormStatus=15 Q  //申请单作废则不关联
	.I ReqFormStatus=10 Q  //申请单待审则不关联
	.S ReqformNostr=ReqformNostr_ReqformNo_";"
	.S ReqformProductDR=""
	.F  S ReqformProductDR=$O(^dbo.BDReqFormProductI("IndexMaster",ReqformDR,ReqformProductDR)) q:ReqformProductDR=""  d
	..S ReqformProductRowID=$O(^dbo.BDReqFormProductI("IndexMaster",ReqformDR,ReqformProductDR,""))
	..S Volumn=$LG($G(^dbo.BDReqFormProductD(ReqformProductRowID)),5)
	..S ReqProductRowID=$LG($G(^dbo.BDReqFormProductD(ReqformProductRowID)),3)
	..S ReqProductDRstr=ReqProductDRstr_ReqProductRowID_"^"_Volumn_";"
	
	//计算当前关联申请单剩余血量信息
	S Returnflag=1
	F  S fReqProductDR = $o(^dbo.BDReqAssessProductI("IndexMaster",ReqAssessDR,fReqProductDR)) Q:fReqProductDR=""  D
	.S ReqAssessProductDR=""
	.S LeftVolumn="",ReqProductLeft=""   
	.F  S ReqAssessProductDR = $O(^dbo.BDReqAssessProductI("IndexMaster",ReqAssessDR,fReqProductDR,ReqAssessProductDR)) Q:ReqAssessProductDR=""  D
	..S ReqAssessProductData=$G(^dbo.BDReqAssessProductD(ReqAssessProductDR))
	..S ReqProductDR=$lg(ReqAssessProductData,3),ReqProduct=""
	..I $L(ReqProductDR) S ReqProduct=$LG($G(^dbo.BBReqProductD(ReqProductDR)),3)
    ..S Volumn=$lg(ReqAssessProductData,5)
	..S Unit=$lg(ReqAssessProductData,6)
	..S UseVolumn=0
	..F i=1:1:$L(ReqProductDRstr,";")  D
	...S ReqformProductInfo=$P(ReqProductDRstr,";",i)
	...S fReqFormProductDR=$P(ReqformProductInfo,"^",1)
	...S fReqFormVolumn=$P(ReqformProductInfo,"^",2)
	...I ReqProductDR=fReqFormProductDR S UseVolumn=UseVolumn+fReqFormVolumn
	..S LeftVolumn=Volumn-UseVolumn
	..I LeftVolumn[".",$p(LeftVolumn,".",1)="" s LeftVolumn=0_LeftVolumn
	..S ReqProductLeft=ReqProduct_":"_LeftVolumn_Unit
	..S ReqProductLeftstr=ReqProductLeftstr_ReqProductLeft_";"
	..I LeftVolumn>0 s Returnflag=0 
	q
}

/// 增加血液日志 
/// PackDR：血袋DR,BBTransactionDR:血液处理事件DR,ReqFormDR申请单DR,NewFormDR处理后申请单DR,Remark:备注,OperaUserDR操作用户,WorkGroupDR操作工作小组
ClassMethod AddPackTransaction(PackDR As %String, BBTransactionDR As %String, ReqFormDR As %String, NewFormDR As %String, Remark As %String, OperaUserDR As %String, WorkGroupDR As %String) As %String
{
   s PackData=$g(^dbo.BDPackD(PackDR)) 
   s objPacktran=##class(dbo.BDPackTransaction).%New()
   s objPacktran.PackDR=PackDR
   s objPacktran.TransDate=$zd($h,8)
   s objPacktran.TransTime=$p($h,",",2)
   s objPacktran.TransactionDR=BBTransactionDR
   s objPacktran.TransUserDR=OperaUserDR
   i $l(ReqFormDR) d
   .s objPacktran.UseReqDR=ReqFormDR
   .s UseReqData=$g(^dbo.BDReqFormD(ReqFormDR))
   .s RegNo=$lg(UseReqData,8)
   .s LocationDR=$lg(UseReqData,23)
   .s objPacktran.UsePatientRegNo=RegNo
   .s objPacktran.LocationDR=LocationDR
   i $l(NewFormDR) d
   .s objPacktran.NewReqDR=NewFormDR
   .s UseReqData=$g(^dbo.BDReqFormD(NewFormDR))
   .s NewRegNo=$lg(UseReqData,8)
   .s NewLocationDR=$lg(UseReqData,23)
   .s objPacktran.NewPatientRegNo=RegNo
   s PackStatusDR=$lg(PackData,34)
   s objPacktran.NewPackStatusDR=PackStatusDR
   s objPacktran.WorkGroupDR=WorkGroupDR
   s objPacktran.Remark=Remark 
   s sc=objPacktran.%Save()
   If ($SYSTEM.Status.IsOK(sc)) {
	  s RetVal=1
   }
   else {
	  s RetVal=$SYSTEM.Status.GetErrorText(sc) q RetVal
   } 
    
   q RetVal
}

/// Creator：      RWC
/// CreatDate：    20211018
/// Description:   
/// Table：        
/// Input：        就诊号    
/// Output：       输注次数@开始时间^结束时间@开始时间^结束时间
/// Return：       
/// Others：  
/// w ##Class(DHCLIS.DHCBloodInterface).GetPackInfusionTime(26)
ClassMethod GetPackInfusionTime(AdmNo As %String) As %String
{
	s Num=0,InfusionTime="",RetValue=""
	s WebNameSpace="DHC-LISDATA"
	s ReqFormDR="" f  s ReqFormDR=$o(^[WebNameSpace]dbo.BDReqFormI("IndexAdmNo",$c(32)_AdmNo,ReqFormDR)) q:ReqFormDR=""  d
	.s ReqFormData=$g(^[WebNameSpace]dbo.BDReqFormD(ReqFormDR))
	.s Status=$lg(ReqFormData,51)
	.// 如需过滤状态，可再次进行修改
	.i Status=15 q   // 过滤作废,如需过滤其他状态请自行添加
	.s PackDR="" f  s PackDR=$o(^dbo.BDPackI("IndexReq",ReqFormDR,PackDR)) q:PackDR=""  d
	..s PackData=$g(^dbo.BDPackD(PackDR))
	..s InfusionStartDate=$lg(PackData,62)
	..i '$l(InfusionStartDate) q
	..s InfusionStartTime=$lg(PackData,63)
	..i '$l(InfusionStartTime) q
	..s InfusionEndDate=$lg(PackData,66)
	..i '$l(InfusionEndDate) q
	..s InfusionEndTime=$lg(PackData,67)
	..i '$l(InfusionEndTime) q
	..i $l(InfusionTime) s InfusionTime=InfusionTime_"@"_InfusionStartDate_"^"_InfusionStartTime_"^"_InfusionEndDate_"^"_InfusionEndTime
	..e  s InfusionTime=InfusionStartDate_"^"_InfusionStartTime_"^"_InfusionEndDate_"^"_InfusionEndTime
	..s Num=Num+1
	s RetValue=Num_"@"_InfusionTime
	s WebNameSpace="DHC-APP"
	q RetValue
}

/// 获取患者输血及输血后评价情况
/// 返回 是否输血（1输血,0未输血）^是否完成输血评价（1完成,0未完成）
/// w ##CLASS(DHCLIS.DHCBloodInterface).GetPatIssEvlInfo("")
ClassMethod GetPatIssEvlInfo(AdmNo As %String) As %String
{
	
	s LisNamespace = "DHC-LISDATA"
	s IssCount=0,EvlNoComple=0,IsEvl=0,IsIss=0,ret=""
	k ^TMP($zn,$i,$j)
	s IndexAdmNo=##Class(LIS.Util.Common).IndexData(AdmNo)
	s BDReqFormDR="" f  s BDReqFormDR= $o(^dbo.BDReqFormI("IndexAdmNo",IndexAdmNo,BDReqFormDR)) q:(BDReqFormDR="")  d
    .//是否有输血记录
    .s IssueRecordDR="" f  s IssueRecordDR= $o(^dbo.BDIssueRecordI("IndexReqForm",BDReqFormDR,IssueRecordDR)) q:(IssueRecordDR="")  d
    ..s packDR="" f  s packDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,packDR)) q:(packDR="")  d
	...s BDIssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,packDR,""))
	...s IsReturned=$lg($g(^dbo.BDIssueRecordItemsD(BDIssueRecordItemsDR)),4)
	...i IsReturned="1" q
	...s IssCount=IssCount+1
	.///是否完成输血后评价
	.i '$D(^dbo.BDTransEvaluationI("IndexReqForm",BDReqFormDR)) s EvlNoComple=EvlNoComple+1
	.s TransEvalDR="" f  s TransEvalDR= $o(^dbo.BDTransEvaluationI("IndexReqForm",BDReqFormDR,TransEvalDR)) q:(TransEvalDR="")  d
    ..s TransEvaluationData=$g(^dbo.BDTransEvaluationD(TransEvalDR))
    ..s EvaluationStatus=$lg(TransEvaluationData,43)
    ..i EvaluationStatus'=20  s EvlNoComple=EvlNoComple+1   //10创建 20审核
    
    s:IssCount>0 IsIss=1
    s:EvlNoComple>0 IsEvl=0
    i IssCount>0,EvlNoComple=0 s IsEvl=1
    s ret=IsIss_"^"_IsEvl
    q ret
}

}

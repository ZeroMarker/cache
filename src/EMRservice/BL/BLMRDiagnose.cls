Import sqluser

/// Desc:诊断控件
/// Creator:Candy
Class EMRservice.BL.BLMRDiagnose Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       取诊断模板	
/// Creator:    Candy
/// CreateDate: 2016-7-8
/// Input:      AUserID 用户ID
/// Output:     Json
/// Debug:      w ##Class(EMRservice.BL.BLMRDiagnose).GetModleGroups(105)
ClassMethod GetModleGroups(AUserID As %String) As %String
{
	s result = ""
	q:(AUserID = "") result
	s ds = ##Class(%Library.ResultSet).%New("web.DHCDocService:FindDiagoseTab")
	d ds.Execute(AUserID)
	s count = 0
	While (ds.Next())
	{
		s:(count '= 0) result = result_","
		s result = result_"{"
		s result = result_ """Id"":"""_ds.Data("RowId")_""""
		s result = result_ ",""Desc"":"""_ds.Data("Desc")_""""
		s result = result_"}"
		s count = count + 1
	}
	s result = "["_result_"]"
	q result
}

/// Desc:      取诊断模板明细
/// Creator:   Candy
/// CreateDate:2016-7-8
/// Input:     AID 模板组ID
/// Output:    Json
/// Debug:     w ##Class(EMRservice.BL.BLMRDiagnos).GetDiagoseDetail(32)        
ClassMethod GetDiagnoseDetail(AID As %String) As %String
{
	s result = ""
	q:(AID = "") result
	s ds = ##Class(%Library.ResultSet).%New("web.DHCDocService:FindDiagoseTabDetail")
	d ds.Execute(AID)
	s count = 0
	While (ds.Next())
	{
		s:(count '= 0) result = result_","
		s result = result_"{"
		s result = result_ """ICDId"":"""_ds.Data("ICDRowId")_""""
		s result = result_ ",""ICDDesc"":"""_ds.Data("ICDDesc")_""""
		s result = result_"}"
		s count = count + 1
	}
	s result = "["_result_"]"
	q result
}

/// Desc:      取诊断类型
/// Creator:   Candy
/// CreateDate:2016-7-11
/// Output:    Json
/// Debug:     w ##Class(EMRservice.BL.BLMRDiagnos).GetDiagnoseType() 
ClassMethod GetDiagnoseType() As %String
{
	s result = ""
	s count = 0
	s code = ""
	for
	{
		s code = $o(^MRC("DTYP",0,"Code",code)) 
		q:(code = "")
		continue:(code = "OP")
		s rowId = ""
		for
		{
			s rowId = $o(^MRC("DTYP",0,"Code",code,rowId))
			q:(rowId = "")
			s tmpcode = $p(^MRC("DTYP",rowId),"^",1)  
			s tmpdesc = $p(^MRC("DTYP",rowId),"^",2)
			s:(count '=0) result = result_","
			s result = result_"{"
			s result = result_ """Id"":"""_rowId_""""
			s result = result_ ",""Code"":"""_tmpcode_""""
			s result = result_ ",""Desc"":"""_tmpdesc_""""
			s result = result_"}"
			s count = count + 1
		}
	}
	s result = "["_result_"]"
	q result
}

/// Desc:      取状态
/// Creator:   Candy
/// CreateDate:2016-7-14
/// Output:    Json
/// Debug:     w ##Class(EMRservice.BL.BLMRDiagnos).GetDiagnoseStatus() 
ClassMethod GetDiagnoseStatus() As %String
{
	s result = ""
	s count = 0
	s code = ""
	for
	{
		s code = $o(^MRC("DSTAT",0,"Code",code)) 
		q:(code = "")
		s rowId = ""
		for
		{
			s rowId = $o(^MRC("DSTAT",0,"Code",code,rowId))
			q:(rowId = "")
			s code = $p(^MRC("DSTAT",rowId),"^",1)  
			s desc = $p(^MRC("DSTAT",rowId),"^",2)
			s:(count '=0) result = result_","
			s result = result_"{"
			s result = result_ """Id"":"""_rowId_""""
			s result = result_ ",""Code"":"""_code_""""
			s result = result_ ",""Desc"":"""_desc_""""
			s result = result_"}"
			s count = count + 1
		}
	}
	s result = "["_result_"]"
	q result
}

/// Desc:       诊断字典
/// Creator:    Candy
/// CreateDate: 2017-6-12
/// Input:      PQueryText 查询条件
///             PICDType 诊断类型 0 西医诊断 1 中医诊断病名 2中医诊断证候
///             PMatch 匹配方式  0 模糊匹配  1 精确匹配
///             PCondition ALIAS 拼音字头  Code 代码  Desc 描述
/// Debug: w ##Class(EMRservice.BL.BLMRDiagnose).GetICDDX("g",0,0,"ALIAS")
ClassMethod GetICDDX(PQueryText As %String, PICDType As %String = "", PMatch As %String = "0", PCondition As %String = "ALIAS") As %String
{
	//s ^Temp("GetICDDX")=PQueryText_"^"_PICDType_"^"_PMatch_"^"_PCondition
	s result = ""
 	s i = 0
 	s MaxRecord = 40 	
 	s PQueryText = $ZCVT(PQueryText,"U")
 	if $d(^MRC("ID",0,PCondition,PQueryText)) '= 0
 	{
	  	s TempText = PQueryText	
	}
	else
	{
		s TempText = $o(^MRC("ID",0,PCondition,PQueryText))
	}
 	for {
	 	if (PMatch = 1)
	 	{
		 	s tmpQueryText = $e(TempText,1,$l(PQueryText))
		 	q:((TempText ="") || (tmpQueryText '= PQueryText))
		}
		else
		{
			q:((TempText = "")||(TempText '[ PQueryText))
		}

	 	s AliasRowID = "0"
	 	for {
		 	q:(i > MaxRecord)
		 	s AliasRowID =  $o(^MRC("ID",0,PCondition,TempText,AliasRowID))
		 	q:(AliasRowID = "")
		 	s RowID = AliasRowID
			d condition
			continue:(condition = 0)	
		 	d setDataName
		}
		s TempText = $o(^MRC("ID",0,PCondition,TempText))
	}
	s result = "["_result_"]"
	q result
condition
    s condition = 1
	s BillFlag3 = $P($G(^MRC("ID",RowID)),"^",15)
	s BillFlag1 = $P($G(^MRC("ID",RowID)),"^",13)
	s:((PICDType = "0")&&(BillFlag3="Y")) condition = 0
	s:((PICDType = "1")&&((BillFlag3'="Y")||(BillFlag1="Y"))) condition = 0
	s:((PICDType = "2")&&((BillFlag3'="Y")||(BillFlag1'="Y"))) condition = 0
	s dateActiveTo = $p(^MRC("ID",RowID),"^",7)
	s currentDate = $p($h,",",1)
	s:((dateActiveTo '= "")&& (dateActiveTo<currentDate)) condition = 0
	q  
setDataName
	s Desc = $p(^MRC("ID",RowID),"^",2)
	s Code = $p(^MRC("ID",RowID),"^",4)
	s:(i '= 0) result = result_","
	s result = result_"{"
	s result = result_ """Id"":"""_RowID_""""
	s result = result_ ",""Code"":"""_Code_""""
	s result = result_ ",""Desc"":"""_Desc_""""
	s result = result_"}"
	s i = i + 1
	q
}

/// Modified by liuzhongwan 2015-05-12 end
/// Desc: 添加或修改诊断记录
/// Input: AEpisodeID^ADiagnosID^ASubID^AType^AIcdID^AIcdDesc^AEvaluation^AEffect^AUserID^ALevel
/// Debug: w ##Class(EMRservice.BL.BLMRDiagnose).UpdateOrInsertDiagnos("112","","","10","","","3","","105","werewrwer")
ClassMethod UpdateOrInsertDiagnos(AEpisodeID As %String, ADiagnosID As %String, ASubID As %String, AType As %String, AIcdID As %String, AIcdDesc As %String, AEvaluation As %String, AEffect As %String, AUserID As %String, ASequence As %String, AMemo As %String, AParentID As %String, ALevel As %String, APosition As %String) As %String
{
	set result = ""
	set ICDFlag = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("OnlyICD","N")
	if ($zcvt(ICDFlag,"u") = "Y")
	{
		s:(AIcdID = "") result = "0&禁止下非ICD诊断"
	}
	set MRDIAID = "0"
	if (ADiagnosID = $c(0)) || (ADiagnosID = "")
	{
		set IsExist = ..IsICDExistInDiagnos(AEpisodeID,AIcdDesc,AType)
		set:(IsExist '= "F") result = "0&列表中已经存在此诊断"
		quit:(IsExist '= "F") result
		//添加诊断记录
		set MRDIAID = ..CMSaveDiagnos(AEpisodeID,AType,AIcdID,AIcdDesc,AUserID,ALevel,ASequence,AEvaluation,AEffect,AMemo,AParentID,APosition)	
	}                               
	else
	{
		//修改诊断记录
	    set MRDIAID = ADiagnosID_"||"_ASubID
	    set MrIcdID = $p(^MR(ADiagnosID,"DIA",ASubID),"^",1)
	    set $p(^MR(ADiagnosID,"DIA",ASubID),"^",1) = AIcdID
		set ^MR(ADiagnosID,"DIA",ASubID,"DES",1) = AMemo
	    set $p(^MR(ADiagnosID,"DIA",ASubID),"^",12) = AUserID
	    set $p(^MR(ADiagnosID,"DIA",ASubID),"^",7) = $p($h,",",1)
	    set $p(^MR(ADiagnosID,"DIA",ASubID),"^",8) = $p($h,",",2)
	    set ^MR(ADiagnosID,"DIA",ASubID,"TYP",1) = AType
	    set:((AEvaluation=$c(0))||(AEvaluation = "")) AEvaluation = ""
	    set:((AEffect=$c(0)) || (AEffect = "")) AEffect = ""	   
        set $P(^MR(ADiagnosID,"DIA",ASubID,"EPR"),"^",3)= AEvaluation
        set $P(^MR(ADiagnosID,"DIA",ASubID,"EPR"),"^",4)= AEffect
		set $p(^MR(ADiagnosID,"DIA",ASubID),"^",9) = AEvaluation
	}
	//判断疾病上报
	set SeriousDisease = ##class(DHCMed.EPDService.Service).CheckDiagnosToEpd(AEpisodeID)
	if (MRDIAID = 0) 
	{
		s result = "0&保存失败"
	}
	else
	{
		s result = "1&"_MRDIAID_"&"_SeriousDisease
	}
	q result
}

/// Desc: 删除诊断记录
/// input: AMRID,SubID 诊断ID
/// output: 0失败，1成功
/// Debug: d ##Class(EPRservice.BLL.MRDiagnos.BLMRDiagnosData).DiagnosDelete(112,102)
ClassMethod DiagnosDelete(AMRID As %String, SubID As %String) As %String
{
	s Flag = "0"
	q:((AMRID="")||(SubID=""))
	s RowID = AMRID_"||"_SubID
	&sql(delete from mr_diagnos where MRDIA_RowId =:RowID)
	d ..DeleteSub(AMRID,RowID)
	s Flag = "1"
	q Flag
}

ClassMethod DeleteSub(AMRAdm As %String, AParentID As %String) As %String
{
	s result = "1"
	s subId = ""
	for
	{
		s subId = $o(^MR(AMRAdm,"DIA",0,"Link",AParentID,subId))
		q:(subId = "")
		s RowID = AMRAdm_"||"_subId
		&sql(delete from mr_diagnos where MRDIA_RowId =:RowID)
		d ..DeleteSub(AMRAdm,RowID)
	}
	q result
}

/// Desc: 保存诊断数据
/// Input: AEpisodeID就诊号^AType类型^AIcdID就诊代码^AIcdDesc就诊描述^AUserID用户^ALevel级别^ASequence顺序^AEvaluationID转归属性^AEffect类型属性
/// OutPut: 诊断表的 RowID 
/// Debug: do ##Class(EMRservice.BL.BLMRDiagnose).CMSaveDiagnos("112","2","26312","main","105","1","1","1","1","","112||51")
ClassMethod CMSaveDiagnos(AEpisodeID As %String, AType As %String, AIcdID As %String, AIcdDesc As %String, AUserID As %String, ALevel As %String, ASequence As %String, AEvaluationID As %String, AEffect As %String, AMemo As %String, AParentID As %String, APosition As %String) As %String
{
	set RowID = "0"
	set MrAdmID= ..GetMRADMID(AEpisodeID)
	set objMRDiagnos=##Class(User.MRDiagnos).%New(MrAdmID)
	
    do objMRDiagnos.MRDIAMRADMParRefSetObjectId(MrAdmID)
    if (AIcdID '= $c(0)) && (AIcdID '="")  do objMRDiagnos.MRDIAICDCodeDRSetObjectId(AIcdID)
 	set objMRDiagnos.MRDIADate=$p($h,",",1)
	set objMRDiagnos.MRDIATime=$p($h,",",2)
	Do objMRDiagnos.MRDIAUpdateUserDRSetObjectId(AUserID)
	set objMRDiagnos.MRDIAUpdateDate=$p($h,",",1)
	set objMRDiagnos.MRDIAUpdateTime=$p($h,",",2)
	Do objMRDiagnos.MRDIAUserCreatedDRSetObjectId(AUserID)	
	d:(AParentID '= "") objMRDiagnos.MRDIAMRDIADRSetObjectId(AParentID)
	set objMRDiagnos.MRDIAActive="Y"
	Try { set objMRDiagnos.MRDIALocation = APosition}Catch{}
    if (AUserID'="") && (AUserID'=$c(0)) 
    {
       set CTPCPRowId=$P($g(^SSU("SSUSR",AUserID)),"^",14)
       if CTPCPRowId'="" Do objMRDiagnos.MRDIADocCodeDRSetObjectId(CTPCPRowId)
    }
    if (objMRDiagnos.%Save())
	{ 
	   set RowID = objMRDiagnos.%Id()
	   set SubID = $p(RowID,"||",2)
       //if (AIcdID =$c(0)) || (AIcdID ="") set ^MR(MrAdmID,"DIA",SubID,"DES",1) = AIcdDesc
	   if (AEvaluationID = $c(0)) set AEvaluationID=""
	   if (AEffect = $c(0)) || (AEffect = "")  set AEffect=""
	   if (ALevel = $c(0)) || (ALevel = "")  set ALevel = "1"
	   if (ASequence = $c(0)) || (ASequence = "") set ASequence=SubID	   
	   set ^MR(MrAdmID,"DIA",SubID,"EPR") = ALevel_"^"_SubID_"^"_AEvaluationID_"^"_AEffect
       set ^MR(MrAdmID,"DIA",SubID,"TYP",0) = 1
       set ^MR(MrAdmID,"DIA",SubID,"TYP",1) = AType
       set ^MR(MrAdmID,"DIA",SubID,"DES",1) = AMemo
	   set $p(^MR(MrAdmID,"DIA",SubID),"^",9) = AEvaluationID
	} 
   d objMRDiagnos.%Close()    
   q RowID
}

/// Desc:判断就诊表中是否下过AICDDesc这个诊断
/// debug: w ##Class(EPRservice.BLL.MRDiagnos.BLMRDiagnosData).IsICDExistInDiagnos(50729,"霍乱轻型",1)
ClassMethod IsICDExistInDiagnos(AEpisodeID As %String, AICDDesc As %String, ATypeID As %String) As %Boolean
{
	set AMRADMRowId = ..GetMRADMID(AEpisodeID)
	s MRSubID = "0" , Result = "F"
	for {
		 s MRSubID = $o(^MR(AMRADMRowId,"DIA",MRSubID))
		 q:(MRSubID = "")
		 s ICDID = $p($g(^MR(AMRADMRowId,"DIA",MRSubID)),"^",1)
		 i (ICDID '= "")&&(ICDID '= $c(0)){ set ICDDesc = $p(^MRC("ID",ICDID),"^",2)}else{set ICDDesc = $g(^MR(AMRADMRowId,"DIA",MRSubID,"DES",1))}
		 s TypeID = $g(^MR(AMRADMRowId,"DIA",MRSubID,"TYP",1))
		 if ((ICDDesc = AICDDesc)&&(TypeID = ATypeID)) 
		 {
			s BillFlag3 = $P($G(^MRC("ID",ICDID)),"^",15)
			s BillFlag1 = $P($G(^MRC("ID",ICDID)),"^",13)
			continue:((BillFlag1 = "Y")||(BillFlag3="Y"))
			s Result = "T"
			q
		 }
    }
    q Result
}

/// 获得MR_Adm RowID
ClassMethod GetMRADMID(AEpisodeID As %String) As %String
{
	q:(AEpisodeID="") ""
	s MRADMID=$p($g(^PAADM(AEpisodeID)),"^",61)
    q MRADMID
}

/// Desc:门诊诊断
/// Debug: w ##CLASS(EMRservice.BL.BLMRDiagnos).GetOPDiagnos(76)
ClassMethod GetOPDiagnos(AEpisodeID As %String) As %String
{
	s result = ""
	s opDiagTypeId =  $O(^MRC("DTYP",0,"Code","OP","")) 
	q:(opDiagTypeId = "") result
	s diagIDs = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetTypedDiagnosID(AEpisodeID, opDiagTypeId)
	q:(diagIDs = "") result
	
	s diagnosId = $P(diagIDs, "^", 1)
	s result = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetDiagnosWithNote(diagnosId)
	q result
}

/// Desc:       诊断列表
/// Creator:    Candy
/// CreateDate: 2016-7-20
/// Input:      PEpisodeID 就诊号
/// w ##Class(EMRservice.BL.BLMRDiagnose).GetDiagnos(76)
ClassMethod GetDiagnos(PEpisodeID As %String, PTypeID As %String = "") As %String
{
	set result = ""
	set MRADMRowId=..GetMRADMID(PEpisodeID)
    quit:(MRADMRowId = "") result
	s Key = $i(^CacheTemp)
	k ^tmpDiagnosList(Key)
	set DiaSubID = "0" 
	for {
		set DiaSubID = $o(^MR(MRADMRowId,"DIA",DiaSubID))
		quit:(DiaSubID = "")
		s active = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",34)
		continue:(active '= "Y")
		s MRDIA = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",15)
		s:(MRDIA = "") MRDIA = 0
		//诊断类型
		set TypeID = $g(^MR(MRADMRowId,"DIA",DiaSubID,"TYP",1))
		continue:((PTypeID '= TypeID) && (PTypeID '= "") && (PTypeID '= $c(0)))  
		set TypeDesc = "",TypeCode = ""
		set:(TypeID '="") TypeDesc = $p($g(^MRC("DTYP",TypeID)),"^",2)
		set:(TypeID '="") TypeCode = $p($g(^MRC("DTYP",TypeID)),"^",1)
		//诊断
		set ICDID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",1)
		set ICDDesc = ""
		set ICDCode = ""
		if (ICDID '= "")&&(ICDID '= $c(0))
		{
		   set ICDDesc = $p(^MRC("ID",ICDID),"^",2)
		   set ICDCode = $p(^MRC("ID",ICDID),"^",4)
		}
		//非ICD
		set MemoDesc = $g(^MR(MRADMRowId,"DIA",DiaSubID,"DES",1))
		s BillFlag1 = $P($G(^MRC("ID",+ICDID)),"^",13)
		s BillFlag3 = $P($g(^MRC("ID",+ICDID)),"^",15)
		if (BillFlag3 '= "Y")
		{
		 	s BillFlag = 0 // 西医
		 	s BillFlagDesc = "西医"
		}
		else
		{
			s BillFlag = 1 //中医
			s BillFlagDesc = "中医"
		}
		s DiagPosition = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,1)),"^",21)
		//级别
		set Level = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",1)
		set:(Level = "") Level = 1
		//set space = ..GetSpace(Level)
		set ICDDesc = ICDDesc
		
		//顺序
		set Sequence = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",2)
		set:(Sequence = "") Sequence = DiaSubID

		if $d(^MR(MRADMRowId,"DIA",DiaSubID,"EPR"))'=0
		{
		  set EvaluationID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",3)
		  set EffectsID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",4)
		}
		else 
		{
		   set EvaluationID = ""
		   set EffectsID =""
		}
		//状态属性
		set EvaluationDesc =""
		set:((EvaluationID ="") || (EvaluationID ="0")) EvaluationID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",9)
		set:((EvaluationID '="") && (EvaluationID '="0")) EvaluationDesc =$p($g(^MRC("DSTAT",EvaluationID)),"^",2)
		//日期时间
		set Date = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",7)
		set:(Date '= "") Date = $ZD(Date,3)
		set Time = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",8)
		set:(Time '="") Time = $ZT(Time)
		//set DateTime = Date_" "_Time
		//医生
		set UserID =  $p(^MR(MRADMRowId,"DIA",DiaSubID),"^",12)
		set UserName = "",UserLevel = ""
		if (UserID '="") 
		{
			set UserName = $p($g(^SSU("SSUSR",UserID)),"^",2)
		}
		
		set temp = """PID"":"""_MRADMRowId_""""
		set temp = temp_ ",""SubID"":"""_DiaSubID_""""
		set temp = temp_ ",""ID"":"""_MRADMRowId_DiaSubID_""""
		set temp = temp_ ",""TypeID"":"""_TypeID_""""
		set temp = temp_ ",""TypeCode"":"""_TypeCode_""""
		set temp = temp_ ",""TypeDesc"":"""_TypeDesc_""""
		set temp = temp_ ",""ICDID"":"""_ICDID_""""
		set temp = temp_ ",""ICDDesc"":"""_DiagPosition_" "_ICDDesc_""""
		set temp = temp_ ",""MemoDesc"":"""_MemoDesc_""""
		set temp = temp_ ",""ICDCode"":"""_ICDCode_""""
		set temp = temp_ ",""EvaluationID"":"""_EvaluationID_""""
		set temp = temp_ ",""EvaluationDesc"":"""_EvaluationDesc_""""
		set temp = temp_ ",""Level"":"""_Level_""""
		set temp = temp_ ",""Sequence"":"""_Sequence_""""
		set temp = temp_ ",""UserName"":"""_UserName_""""
		set temp = temp_ ",""Date"":"""_Date_""""
		set temp = temp_ ",""Time"":"""_Time_""""
		set temp = temp_ ",""MRDIA"":"""_MRDIA_""""
		set temp = temp_ ",""BillFlag"":"""_BillFlag_""""
		set temp = temp_ ",""BillFlagDesc"":"""_BillFlagDesc_""""
		set temp = temp_ ",""ICDDescBak"":"""_ICDDesc_""""
		set temp = temp_ ",""Position"":"""_DiagPosition_"""" 
		set temp = temp_ ",""iconCls"":""icon-icd"""
		
		if ((Level > 1)&&(MRDIA = 0))
		{
			s tempSubId = ..GetPreDiagnose(Key,MRDIA,MRADMRowId,Sequence)
			s:(tempSubId '= "") MRDIA = MRADMRowId_"||"_tempSubId
		}
		set ^tmpDiagnosList(Key,MRDIA,MRADMRowId,Sequence,DiaSubID) = temp 
	}
	set result = ..GetSeqData(Key,"0")
	kill ^tmpDiagnosList(Key)
	set result = "["_result_"]"
	quit result
}

/// Desc: 取父节点，兼容老数据
ClassMethod GetPreDiagnose(AKey, AMRDIA, AMRADMRowId, ASequence) As %String
{
	s result = ""
	s preSequence = $o(^tmpDiagnosList(AKey,AMRDIA,AMRADMRowId,ASequence),-1)
	q:(preSequence = "") result
	s subId = $o(^tmpDiagnosList(AKey,AMRDIA,AMRADMRowId,preSequence,""))
	s result = result
	q result
}

/// Desc:       排序输出诊断
/// Creator:    Candy
/// CreateDate: 2016-7-20
/// Debug: w ##Class(EMRservice.BL.BLMRDiagnose).GetSeqData(361,76)
ClassMethod GetSeqData(Key, ParentID) As %String
{
	s result = ""
	s count = 0
	s pId = ""
	for
	{
		s pId = $o(^tmpDiagnosList(Key,ParentID,pId))
		q:(pId = "")
	    s seq = ""
	    for
	    {
		    s seq = $o(^tmpDiagnosList(Key,ParentID,pId,seq))
		    q:(seq = "")
		    s subId = ""
		    for
		    {
			    s subId = $o(^tmpDiagnosList(Key,ParentID,pId,seq,subId))
			    q:(subId = "")
			    s tmpParentId = pId_"||"_subId
			    s childs = ..GetSeqData(Key,tmpParentId)
				s:(count '= 0) result = result_","
				s result = result_"{"
				s result = result_^tmpDiagnosList(Key,ParentID,pId,seq,subId)
				s:(childs '= "") result = result_",""children"":["_childs_"]"	
				s result = result_"}"
				s count = count + 1
		    }
		}	
	}
	q result
}

/// 增加空格来显示级别
ClassMethod GetSpace(ACount As %String) As %String
{
	s result = ""
	for i=1:1:ACount-1
	{
		s result = result_"&nbsp;&nbsp;&nbsp;&nbsp;"
	}
	q result
}

/// Desc:       历史诊断
/// Creator:    Candy
/// CreateDate: 2016-7-20
/// Debug: ##Class(EMRservice.BL.BLMRDiagnose).GetHistoryDiagnose(48)
ClassMethod GetHistoryDiagnose(APatientID As %String) As %String
{
	s result = ""
	q:(APatientID = "") result
	s ds = ##Class(%Library.ResultSet).%New("web.DHCDocDiagnosNew:GetHistoryMRDiagnose")
	d ds.Execute(APatientID)
	s count = 0
	While (ds.Next())
	{
		s:(count '= 0) result = result_","
		s result = result_"{"
		s result = result_ """Rowid"":"""_ds.Data("Rowid")_""""
		s desc = ds.Data("Desc")
		s:(ds.Data("MRDesc") '= "") desc = desc_" ("_ds.Data("MRDesc")_")"
		s result = result_ ",""Desc"":"""_desc_""""
		s result = result_ ",""DoctDesc"":"""_ds.Data("DoctDesc")_""""
		s result = result_ ",""MRDate"":"""_ds.Data("MRDate")_""""
		s result = result_"}"
		s count = count + 1
	}
	s result = "["_result_"]"
	q result
}

/// Desc:       修改级别
/// Creator:    Candy
/// CreateDate: 2016-7-20
/// Input:      AParams 修改内容
///             AType 修改类型 level 为级别 sequence 为顺序 
ClassMethod ModifiyDiagnos(AParams As %String, AType As %String) As %String
{
	s result = ""
	q:(AParams = "") result
	s count = $l(AParams,"|")
	for i=1:1:count
	{
		s pId = $p($p(AParams,"|",i),"^",1)
		s sId = $p($p(AParams,"|",i),"^",2)
		s index = $p($p(AParams,"|",i),"^",3)
		if (AType = "level")
		{
			s $p(^MR(pId,"DIA",sId,"EPR"),"^",1) = index  
		}
		else
		{
			s $p(^MR(pId,"DIA",sId,"EPR"),"^",2) = index	
		}
	}
	s result = 1
	q result
}

/// Desc:       修改顺序
/// Creator:    Candy
/// CreateDate: 2017-5-6
/// Input:      AId1 诊断1ID  AId2 诊断2ID
ClassMethod ModifiySequence(AId1 As %String, AId2 As %String) As %String
{
	s result = ""
	q:(AId1 = "")||(AId2 = "") result
	s pId1 = $p(AId1,"||",1)
	s cId1 = $p(AId1,"||",2)
	s pId2 = $p(AId2,"||",1)
	s cId2 = $p(AId2,"||",2)
	s tmpSeq = $p(^MR(pId1,"DIA",cId1,"EPR"),"^",2) 
	s $p(^MR(pId1,"DIA",cId1,"EPR"),"^",2) = $p(^MR(pId2,"DIA",cId2,"EPR"),"^",2) 
	s $p(^MR(pId2,"DIA",cId2,"EPR"),"^",2) = tmpSeq
	s result = 1
	q result
}

/// Desc:       级别
/// Creator:    Candy
/// CreateDate: 2017-5-6
/// Input:      AId1 诊断1ID  AId2 诊断2ID
/// Output:     result ""失败 1 成功
/// Debgu:      w ##Class(EMRservice.BL.BLMRDiagnose).ModifiyLevel("112||69","112||68")
ClassMethod ModifiyLevel(PId As %String, CId As %String, Level As %String) As %String
{
	s result = ""
	q:(PId = "")||(CId = "") result
	s cpId = $p(CId,"||",1)
	s ccId = $p(CId,"||",2)
	s $p(^MR(cpId,"DIA",ccId,"EPR"),"^",1) = Level 
	s tmp = ..ModifiSubLevel(cpId,CId,Level)
	q:(tmp '= 1) result
	s obj = ##Class(User.MRDiagnos).%OpenId(CId)
	q:(obj = "") result
	s tmpPId = PId
	s:(PId = "0") tmpPId = ""
	d obj.MRDIAMRDIADRSetObjectId(tmpPId)
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{ 
		s result = 1
	}
	
	q result
}

/// Desc:修改子节点级别
/// Creator:Candy
/// Debug: d ##Class(EMRservice.BL.BLMRDiagnose).ModifiSubLevel(112,"112||103","2")
ClassMethod ModifiSubLevel(AMRAdm As %String, AParentID As %String, ALevel As %String) As %String
{
	s $ZT="ERROR"
	s result = "1"
	s subId = ""
	for
	{
		s subId = $o(^MR(AMRAdm,"DIA",0,"Link",AParentID,subId))
		q:(subId = "")
		s level = ALevel + 1
		s $p(^MR(AMRAdm,"DIA",subId,"EPR"),"^",1) = level
		d ..ModifiSubLevel(AMRAdm,AMRAdm_"||"_subId,level)
	}
	q result
ERROR			
	q $zerror
}

/// Desc:       取部位数据
/// Creator:    Candy
/// CreateDate: 2017-9-8
ClassMethod GetPosition() As %String
{
	q ##Class(EMRservice.BL.BLDicDiagnosPosition).GetData()
}

}

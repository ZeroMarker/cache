Class DHCEPRFS.Tool.UpdateData Extends %RegisteredObject [ ProcedureBlock ]
{

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateFromMRQ()	
ClassMethod UpdateFromMRQ()
{
	s count = 0
	s rowID = ""
	for {
		s rowID = $o(^DHCMRQ.MR.DataMasterD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCMRQ.MR.DataMaster).%OpenId(rowID)
		continue:(obj = "")
		s appCode = obj.AppCode
		s episodeID = ""
		s patientID = ""
		s medRecordNo = ""
		
		if (appCode = "HA.ZK.Coding")
		{
			s log = ##class(DHCEPRFS.INST.ImportMRQLog).%New()
			s log.ActiveDate = $p($h,",",1)
			s log.ActiveTime = $p($h,",",2)
			
			s episodeID = obj.EpisodeID
			if (episodeID = "") 
			{
				s log.ErrorFlag = "Y"
				s log.ErrorMsg = "episodeID is null"
				d log.%Save()
				continue	
			}
			s patientID = obj.PatientID
			if (patientID = "") 
			{
				s log.ErrorFlag = "Y"
				s log.ErrorMsg = "patientID is null"
				s log.EpisodeID = episodeID
				d log.%Save()
				continue	
			}
			s arr = ##class(DHCEPRFS.BL.HISInfo.BLMRQInfo).GetArrayOfDataByAdm(episodeID)
			s medRecordNo = arr.GetAt("P00050000")
			if (medRecordNo = "") 
			{
				s log.ErrorFlag = "Y"
				s log.ErrorMsg = "medRecordNo is null"
				s log.EpisodeID = episodeID
				s log.PatientID = patientID
				d log.%Save()
				continue	
			}		
			
			b "s"
			s ret = ##class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeByMRQ(medRecordNo,patientID,episodeID,"DHC")
			s log.EpisodeID = episodeID
			s log.PatientID = patientID
			s log.MedRecordNo = medRecordNo
			d log.%Save()
			
			s count = count + 1
			w !,count_" "_ret_" "_episodeID
		}
	}
}

/// debug: w ##class(DHCEPRFS.Tool.UpdateData).UpdateResultColumnEMRMainDiag()
ClassMethod UpdateResultColumnEMRMainDiag()
{
	s sc = $$InitOneResultColumn("EMRMainDiagCode", "病历主要诊断编码", "Y")
	s sc = $$InitOneResultColumn("EMRMainDiagDesc", "病历主要诊断描述","Y")
InitOneResultColumn(argColumnName,argColumnDesc,argIsActive)	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.ResultColumn
		where ColName = :argColumnName)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.ResultColumn (ColName,ColDesc,IsActive) 
			values (:argColumnName,:argColumnDesc,:argIsActive))
	}
	
	q "1"
}

/// debug: w ##class(DHCEPRFS.Tool.UpdateData).UpdateQueryFieldsEMRMainDiag()
ClassMethod UpdateQueryFieldsEMRMainDiag()
{
	s sc = $$InitOneQueryField("EMRMainDiagCode", "病历主要诊断编码", "TXT", "", "PatOperInfo", "206", "Y")
	s sc = $$InitOneQueryField("EMRMainDiagDesc", "病历主要诊断描述", "TXT", "", "PatOperInfo", "207", "Y")
InitOneQueryField(argFieldName,argFieldDesc,argFieldType,argFieldInterface,argCategoryName,argSequence,argIsActive)
	s categoryID = ""
	&sql(select ID into :categoryID from DHCEPRFS_META.QueryCategory
		where CategoryName = :argCategoryName)
	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryFields
		where FieldName = :argFieldName)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.QueryFields (FieldName,FieldDesc,FieldType,FieldInterface,CategoryID,Sequence,IsActive) 
			values (:argFieldName,:argFieldDesc,:argFieldType,:argFieldInterface,:categoryID,:argSequence,:argIsActive))
	}
	
	q "1"
}

/// debug: w ##class(DHCEPRFS.Tool.UpdateData).UpdateResultColumnDPDiagnose()
ClassMethod UpdateResultColumnDPDiagnose()
{
	s sc = $$InitOneResultColumn("DPDiagnose", "损伤中毒", "Y")
	s sc = $$InitOneResultColumn("DPDiagnoseDesc", "损伤中毒描述","Y")
InitOneResultColumn(argColumnName,argColumnDesc,argIsActive)	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.ResultColumn
		where ColName = :argColumnName)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.ResultColumn (ColName,ColDesc,IsActive) 
			values (:argColumnName,:argColumnDesc,:argIsActive))
	}
	
	q "1"
}

/// debug: w ##class(DHCEPRFS.Tool.UpdateData).UpdateQueryFieldsDPDiagnose()
ClassMethod UpdateQueryFieldsDPDiagnose()
{
	s sc = $$InitOneQueryField("DPDiagnose", "损伤中毒", "TXT", "", "PatOperInfo", "204", "Y")
	s sc = $$InitOneQueryField("DPDiagnoseDesc", "损伤中毒描述", "TXT", "", "PatOperInfo", "205", "Y")
InitOneQueryField(argFieldName,argFieldDesc,argFieldType,argFieldInterface,argCategoryName,argSequence,argIsActive)
	s categoryID = ""
	&sql(select ID into :categoryID from DHCEPRFS_META.QueryCategory
		where CategoryName = :argCategoryName)
	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryFields
		where FieldName = :argFieldName)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.QueryFields (FieldName,FieldDesc,FieldType,FieldInterface,CategoryID,Sequence,IsActive) 
			values (:argFieldName,:argFieldDesc,:argFieldType,:argFieldInterface,:categoryID,:argSequence,:argIsActive))
	}
	
	q "1"
}

/// debug: w ##class(DHCEPRFS.Tool.UpdateData).UpdateResultColumnOperCode()
ClassMethod UpdateResultColumnOperCode()
{
	s sc = $$InitOneResultColumn("Oper01Code", "手术1代码", "Y")
	s sc = $$InitOneResultColumn("Oper02Code", "手术2代码", "Y")
	s sc = $$InitOneResultColumn("Oper03Code", "手术3代码", "Y")
	s sc = $$InitOneResultColumn("Oper04Code", "手术4代码", "Y")
	s sc = $$InitOneResultColumn("Oper05Code", "手术5代码", "Y")
	s sc = $$InitOneResultColumn("Oper06Code", "手术6代码", "Y")
	s sc = $$InitOneResultColumn("Oper07Code", "手术7代码", "Y")
	s sc = $$InitOneResultColumn("Oper08Code", "手术8代码", "Y")
InitOneResultColumn(argColumnName,argColumnDesc,argIsActive)	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.ResultColumn
		where ColName = :argColumnName)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.ResultColumn (ColName,ColDesc,IsActive) 
			values (:argColumnName,:argColumnDesc,:argIsActive))
	}
	
	q "1"
}

/// debug: w ##class(DHCEPRFS.Tool.UpdateData).UpdateQueryFieldsOperCode()
ClassMethod UpdateQueryFieldsOperCode()
{
	s sc = $$InitOneQueryField("Oper01Code", "手术1代码", "TXT", "", "PatOperInfo", "196", "Y")
	s sc = $$InitOneQueryField("Oper02Code", "手术2代码", "TXT", "", "PatOperInfo", "197", "Y")
	s sc = $$InitOneQueryField("Oper03Code", "手术3代码", "TXT", "", "PatOperInfo", "198", "Y")
	s sc = $$InitOneQueryField("Oper04Code", "手术4代码", "TXT", "", "PatOperInfo", "199", "Y")
	s sc = $$InitOneQueryField("Oper05Code", "手术5代码", "TXT", "", "PatOperInfo", "200", "Y")
	s sc = $$InitOneQueryField("Oper06Code", "手术6代码", "TXT", "", "PatOperInfo", "201", "Y")
	s sc = $$InitOneQueryField("Oper07Code", "手术7代码", "TXT", "", "PatOperInfo", "202", "Y")
	s sc = $$InitOneQueryField("Oper08Code", "手术8代码", "TXT", "", "PatOperInfo", "203", "Y")
InitOneQueryField(argFieldName,argFieldDesc,argFieldType,argFieldInterface,argCategoryName,argSequence,argIsActive)
	s categoryID = ""
	&sql(select ID into :categoryID from DHCEPRFS_META.QueryCategory
		where CategoryName = :argCategoryName)
	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryFields
		where FieldName = :argFieldName)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.QueryFields (FieldName,FieldDesc,FieldType,FieldInterface,CategoryID,Sequence,IsActive) 
			values (:argFieldName,:argFieldDesc,:argFieldType,:argFieldInterface,:categoryID,:argSequence,:argIsActive))
	}
	
	q "1"
}

/// debug: w ##class(DHCEPRFS.Tool.UpdateData).CheckEPRNewPrtTemple()
ClassMethod CheckEPRNewPrtTemple()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRM.EPRTemplateCategoryD(rowID))	
		q:(rowID = "")
		
		s obj = ##class(EPRmeta.EPRTemplateCategory).%OpenId(rowID)
		s type = obj.CategoryType
		continue:(type '= "PrtTemplate")
		
		s mrItemID = ""
		s mrItemID = $o(^DHCEPRFS.META.MRItemI("IdxType"," 07"," "_rowID,mrItemID))	
		continue:(mrItemID '= "")
		
		w !,"TypeParam="_rowID_" Desc="_obj.CategoryName
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateFileUniqueID()
ClassMethod UpdateFileUniqueID()
{
	s mrVerItemID = ""
	for {
		s mrVerItemID = $o(^DHCEPRFS.INST.MRVerItemD(mrVerItemID))
		q:(mrVerItemID = "")
		s fileMasterPath = ""
		s objItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		s detailNum = ""
		for {
			s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum))
			q:(detailNum = "")
			
			s subID = ""
			for {
				s subID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum,subID))
				q:(subID = "")
				
				s objDetail = ##class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemID_"||"_subID)
				s fileMasterPath = objDetail.FileMasterPath
				s fileMasterPath = $p(fileMasterPath,".",1)
				if ($l(fileMasterPath,"/") > 1)
				{
					s fileMasterPath = $p(fileMasterPath,"/",$l(fileMasterPath,"/"),$l(fileMasterPath,"/"))
				}
				s objDetail.FileDetailUniqueID = fileMasterPath
				s retSub = objDetail.%Save()
				w !,"MRVerItemDetail  "_mrVerItemID_"||"_subID_"   "_retSub
			}
		}
		s uniqueID = $p(fileMasterPath,".",1)

		if ($l(uniqueID,"_0-0_") > 1)
		{
			s uniqueID = $p(uniqueID,"_0-0_",1)
		}
		if ($l(uniqueID,"/") > 1)
		{
			s uniqueID = $p(uniqueID,"/",$l(uniqueID,"/"),$l(uniqueID,"/"))
		}
		
		s ret = ""
		if ($IsObject(objItem)=1)
		{
			s objItem.FileUniqueID = uniqueID
			s ret = objItem.%Save()
		}
		w !,"MRVerItem  "_mrVerItemID_"   "_ret
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateErrorAdmTaskSucc()
ClassMethod UpdateErrorAdmTaskSucc()
{
	s DateStart = $zdh("2017-8-1",3)
	s DateEnd = $zdh("2017-8-2",3)
	s date = DateStart - 1
	s count = 0
	for {
		s date = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxSucceedDateTime",date))
		q:(date > DateEnd)
		q:(date = "")
		
		s time = ""
		for {
			s time = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxSucceedDateTime",date,time))
			q:(time = "")
			
			s rowID = ""
			for {	
				s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxSucceedDateTime",date,time,rowID))
				q:(rowID = "")	
					
				s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)	
				s episodeID = obj.EpisodeID
				//完成队列，但没有生成日志，则错误需要重新生成
				s ret = ##Class(DHCEPRFS.BL.BLMRLog).IsRecordCreated(episodeID)
				if (ret = "0")
				{
					s count = count + 1
					w !,count_"   "_episodeID_"   "_##Class(DHCEPRFS.BL.BLAdmTaskQueue).CreatePrivacyLevel01("DHC",episodeID,"30")	
			
					s count = count + 1
				}
			}
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateMRAction()	
ClassMethod UpdateMRAction()
{
	s sc = $$InitOneMRAct("NURCONFIRM","护士结算","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("DOCCONFIRM","医生确认","1","PROCESS","病案处理")
	s sc = $$InitOneMRAct("EXPORT","病历导出","1","USE","病案使用")
	
InitOneMRAct(argActionCode, argActionName, argIsActive,argCategoryCode,argCategoryName)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.MRAction
		where ActionCode = :argActionCode)
	
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.MRAction (ActionCode, ActionName, IsActive,CategoryCode,CategoryName) 
			values (:argActionCode, :argActionName, :argIsActive, :argCategoryCode, :argCategoryName))
	}
	else
	{
		&sql(update DHCEPRFS_META.MRAction set ActionCode = :argActionCode, ActionName = :argActionName, IsActive = :argIsActive,CategoryCode =:argCategoryCode,CategoryName=:argCategoryName 
		where id = :rowid)
	}
	
	q "1"
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateCustomDic()	
ClassMethod UpdateCustomDic()
{
	s sc = $$InitOneCustomDic("1", "急诊", "jz", "InPatientWay", "1", "1")
	s sc = $$InitOneCustomDic("2", "门诊", "mz", "InPatientWay", "1", "2")
	s sc = $$InitOneCustomDic("3", "其他医疗机构转入", "qtyljgzr", "InPatientWay", "1", "3")
	s sc = $$InitOneCustomDic("9", "其他", "qt", "InPatientWay", "1", "4")

	
InitOneCustomDic(argCtmDictCode, argCtmDictDesc, argCtmDictAlias, argCtmDictType, argCtmIsActive, argCtmIndex)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.CustomDic
		where CtmDictType  = :argCtmDictType and CtmIndex = :argCtmIndex)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.CustomDic (CtmDictCode, CtmDictDesc, CtmDictAlias, CtmDictType,CtmIsActive,CtmIndex) 
			values (:argCtmDictCode, :argCtmDictDesc, :argCtmDictAlias, :argCtmDictType, :argCtmIsActive, :argCtmIndex))
	}
	
	q "1"
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateResultColumn()	
ClassMethod UpdateResultColumn()
{
	//s sc = $$InitOneResultColumn("InPatientWayCode", "入院途径代码", "Y")
	//s sc = $$InitOneResultColumn("InPatientWayDesc", "入院途径描述", "Y")
	s sc = $$InitOneResultColumn("CatalogOperator", "编目者", "Y")
	s sc = $$InitOneResultColumn("ReviewOperator", "复核者", "Y")
	s sc = $$InitOneResultColumn("ScanOperator", "扫描者", "Y")
	s sc = $$InitOneResultColumn("PrintOperator", "打印者", "Y")
	s sc = $$InitOneResultColumn("ArrangeOperator", "分类者", "Y")
	s sc = $$InitOneResultColumn("ReplaceOperator", "替换者", "Y")

	
InitOneResultColumn(argColName, argColDesc,argIsActive)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.ResultColumn
		where ColName  = :argColName)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.ResultColumn (ColName, ColDesc, IsActive) 
			values (:argColName, :argColDesc, :argIsActive))
	}
	
	q "1"
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateQueryField()		
ClassMethod UpdateQueryField()
{
	
	s sc = $$InitOneQueryField("InPatientWayDesc", "入院途径代码", "SELECT", "DHCEPRFS.BL.BLCustomDic:GetCustomDicByType|InPatientWay","PatAdmInfo","189", "Y")
	s sc = $$InitOneQueryField("CatalogOperator", "编目者", "TXT", "", "MedRecordFlowInfo", "190", "Y")
	s sc = $$InitOneQueryField("ReviewOperator", "复核者", "TXT", "", "MedRecordFlowInfo", "191", "Y")
	s sc = $$InitOneQueryField("ScanOperator", "扫描者", "TXT", "", "MedRecordFlowInfo", "192", "Y")
	s sc = $$InitOneQueryField("PrintOperator", "打印者", "TXT", "", "MedRecordFlowInfo", "193", "Y")
	s sc = $$InitOneQueryField("ArrangeOperator", "分类者", "TXT", "", "MedRecordFlowInfo", "194", "Y")
	s sc = $$InitOneQueryField("ReplaceOperator", "替换者", "TXT", "", "MedRecordFlowInfo", "195", "Y")
InitOneQueryField(argFieldName,argFieldDesc,argFieldType,argFieldInterface,argCategoryName,argSequence,argIsActive)
	s categoryID = ""
	&sql(select ID into :categoryID from DHCEPRFS_META.QueryCategory
		where CategoryName = :argCategoryName)
	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryFields
		where FieldName = :argFieldName)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.QueryFields (FieldName,FieldDesc,FieldType,FieldInterface,CategoryID,Sequence,IsActive) 
			values (:argFieldName,:argFieldDesc,:argFieldType,:argFieldInterface,:categoryID,:argSequence,:argIsActive))
	}
	
	q "1"
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateNurseCommit()		
ClassMethod UpdateNurseCommit() As %String
{
	s count=0
	s firstDate = $p($h,",",1) -1
	s sysCode = ##Class(DHCEPRFS.Const.SysCode).DHC()
	s PAADMRowID="" 
    for {
    	s PAADMRowID=$o(^PAADMi("DischDate",firstDate,PAADMRowID)) 
    	q:(PAADMRowID="")
    	// 生成 AdmMRStatus 对象
	    
	    s admMRStatusID = ##class(DHCEPRFS.BL.BLAdmMRStatus).GetIDByEpisode(PAADMRowID, sysCode)
	    if (admMRStatusID = "")
	    {
    		s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).RegFinalAccountDHC(PAADMRowID,"")
    		if (ret = 1)
    		{
    			s count = count +1
    			w !,count_"  No and Add"
    		}
	    }
	    else
	    {
		    s obj = ##Class(DHCEPRFS.INST.AdmMRStatus).%OpenId(admMRStatusID)
			
			if (obj.FlagFinalAccount '="1")
			{
				s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).RegFinalAccountDHC(PAADMRowID,"")
    			if (ret = 1)
    			{
    				s count = count +1
    				w !,count_"  0 to Add"
    			}
			}
	    }   	
    }
    q count
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateInPatientWay()	
ClassMethod UpdateInPatientWay()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.MREpisodeD(rowID),-1)
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(rowID)
		
		s episodeID = obj.EpisodeID
		s mrEpisodeID = rowID
		if ($e(episodeID,1,2) '= "VE")
		{	
			//b "s"
			s Glossary = ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(episodeID,"HDSD00.11")
			s InPatientWayCode = Glossary.GetAt("HDSD00.11.086")
			s obj.InPatientWayCode = InPatientWayCode
			
			//入院途径描述，1-急诊，2-门诊，3-其他医疗机构转入，9-其他
			s obj.InPatientWayDesc = ""
			if (obj.InPatientWayCode = "1")
			{
				s obj.InPatientWayDesc = "急诊"
			}
			elseif (obj.InPatientWayCode = "2")
			{
				s obj.InPatientWayDesc = "门诊"
			}
			elseif (obj.InPatientWayCode = "3")
			{
				s obj.InPatientWayDesc = "其他医疗机构转入"
			}
			elseif (obj.InPatientWayCode = "9")
			{
				s obj.InPatientWayDesc = "其他"
			}
			
			s ret = obj.%Save()
			s count = count + 1
			w !,count_"    "_ret_"   ok"
		}
	}
}

/// w ##class(DHCEPRFS.Tool.UpdateData).UpdateInputMVE()
ClassMethod UpdateInputMVE()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.MREpisodeD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(rowID)
		
		s episodeID = obj.EpisodeID
		s mrEpisodeID = rowID
		if ($e(episodeID,1,2) = "VE")
		{
			s mrMedRecordID = obj.MRMedRecordID
			s rowI = ""
			for {
				s rowI = $o(^DHCEPRFS.INST.InputMedLogI("IdxMRMedRecordNo"," "_mrMedRecordID,rowI))
				q:(rowI = "")
				//b "s"
				s objI = ##class(DHCEPRFS.INST.InputMedLog).%OpenId(rowI)
				s type = objI.AType
				s episodeIDI = objI.EpisodeID
				s flag = objI.Flag
	
				continue:(type '= "EPISODE")
				continue:(flag ="1")
				
				s objI.EpisodeID = episodeID
				s objI.MREpisodeID = mrEpisodeID
				s objI.Flag = "1"
				d objI.%Save()
				q
			}	
		}
		
	}
}

/// w ##class(DHCEPRFS.Tool.UpdateData).UpdateAdmType()
ClassMethod UpdateAdmType()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.MREpisodeD(rowID))
		q:(rowID="")
		
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(rowID)
		s episodeID = obj.EpisodeID
		s count = count+1
		if ($e(episodeID,1,2) = "VE")
		{

		}
		else
		{
			s AdmType = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmType(episodeID)
			s obj.AdmType = $P(AdmType,"^",2)
			s obj.AdmTypeID = $P(AdmType,"^",1)	
			d obj.%Save()
		}	
		
		
		w !,count_" "_rowID_" "_episodeID_"  "_obj.AdmType_"  "_obj.AdmTypeID_"    ok"
	}
}

/// w ##class(DHCEPRFS.Tool.UpdateData).UpdateDisDateTimeDoctor()
ClassMethod UpdateDisDateTimeDoctor()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.MREpisodeD(rowID))
		q:(rowID="")
		
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(rowID)
		s episodeID = obj.EpisodeID
		s count = count+1
		if ($e(episodeID,1,2) = "VE")
		{
			s obj.DisDateDoc = obj.DisDate
			s obj.DisTimeDoc = obj.DisTime
			d obj.%Save()
		}
		else
		{
			s obj.DisDateDoc = $P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTimeDoctor(episodeID),",",1)
			s obj.DisTimeDoc = $P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTimeDoctor(episodeID),",",2)
			d obj.%Save()
		}	
		
		
		w !,count_" "_rowID_" "_episodeID_"  "_obj.DisDateDoc_"  "_obj.DisTimeDoc_"    ok"
	}
}

/// w ##class(DHCEPRFS.Tool.UpdateData).UpdateMREpisodePatMed()
ClassMethod UpdateMREpisodePatMed()
{
	s count = 0
	s MedRecord = ""
	for {
		s MedRecord = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMain"," DHC"," N",MedRecord))	
		q:(MedRecord = "")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMain"," DHC"," N",MedRecord,rowID))
			q:(rowID = "")
			s objMRMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(rowID)
			s MRPatientID = objMRMedRecord.MRPatientID
			s EMedRecord = objMRMedRecord.MedRecordNo
			s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
			s PatientID = objMRPatient.PatientID
			s mrEpisodePatID = ""
			for {
				//b "01"
				s mrEpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatI("IdxPatientID"," DHC"," "_PatientID,mrEpisodePatID))	
				q:(mrEpisodePatID = "")
				s objMREpisodePat = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(mrEpisodePatID)
				s objMREpisodePat.MedRecordNo = EMedRecord
				d objMREpisodePat.%Save()
				s count = count + 1
				w !,count_" "_EMedRecord
			}
		}
	}
}

/// w ##class(DHCEPRFS.Tool.UpdateData).RecreateConsent()
ClassMethod RecreateConsent()
{
	s AdmDateStart = $zdh("2016-1-1",3)
	s AdmDateEnd = $zdh("2016-4-8",3)
	s date = AdmDateStart
	s count = 0
	for {
		s date = $o(^DHCEPRFS.INST.MREpisodeI("IdxAdmDate",date))
		q:(date = "")
		
		s mrPatientID = ""
		for {
			s mrPatientID = $o(^DHCEPRFS.INST.MREpisodeI("IdxAdmDate",date,mrPatientID))
			q:(mrPatientID = "")
			
			s rowID = ""
			for {
				//b "s"
				s rowID = $o(^DHCEPRFS.INST.MREpisodeI("IdxAdmDate",date,mrPatientID,rowID))
				q:(rowID = "")
		
				s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(rowID)	
				s episodeID = obj.EpisodeID
	
				s count = count + 1
				w !,count_"   "_episodeID_"   "_##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishConsent(episodeID)	
			
				s count = count + 1
			}
		}
	}
}

/// w ##class(DHCEPRFS.Tool.UpdateData).UpdateQueue()
ClassMethod UpdateQueue()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueD(rowID),-1)
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)
		s schemeType = obj.SchemeType
		if (schemeType = "CREATEPIS")
		{
			s obj.TaskType = "N"
			d obj.%Save()
			w !,rowID
		}
	}
}

/// w ##class(DHCEPRFS.Tool.UpdateData).UpdateMRItemSequence()
ClassMethod UpdateMRItemSequence()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.META.MRItemD(rowID),-1)
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(rowID)
		s sequence = obj.Sequence
		if (+sequence > 134)
		{
			//b "s"
			s obj.Sequence = sequence + 1
			d obj.%Save()
			w !,rowID
		}
	}
}

/// w ##class(DHCEPRFS.Tool.UpdateData).RecreatePrivacy()
ClassMethod RecreatePrivacy()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID),-1)
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)	
		s schemeType = obj.SchemeType
		s:(schemeType = $c(0)) schemeType = ""
		if (schemeType = "CREATEPRIVACY01")
		{
			s episodeID = obj.EpisodeID

			s count = count + 1
			w !,count_"   "_episodeID_"   "_##Class(DHCEPRFS.BL.BLAdmTaskQueue).CreatePrivacyLevel01("DHC",episodeID,"30")	
			
			s count = count + 1
		}
	}
}

/// w ##class(DHCEPRFS.Tool.UpdateData).RecreateANO()
ClassMethod RecreateANO()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID),-1)
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)	
		s schemeType = obj.SchemeType
		s:(schemeType = $c(0)) schemeType = ""
		if (schemeType = "")
		{
			s episodeID = obj.EpisodeID

			s count = count + 1
			w !,count_"   "_episodeID_"   "_##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishANO(episodeID)	
			
			s count = count + 1
		}
	}
}

/// w ##class(DHCEPRFS.Tool.UpdateData).RecreateOUT()
ClassMethod RecreateOUT()
{
	s AdmDateStart = $zdh("2015-05-01",3)
	s AdmDateEnd = $zdh("2015-06-11",3)
	s date = AdmDateStart
	s count = 0
	for {
		s date = $o(^DHCEPRFS.INST.MREpisodeI("IdxAdmDate",date))
		q:(date = "")
		
		s mrPatientID = ""
		for {
			s mrPatientID = $o(^DHCEPRFS.INST.MREpisodeI("IdxAdmDate",date,mrPatientID))
			q:(mrPatientID = "")
			
			s rowID = ""
			for {
				//b "s"
				s rowID = $o(^DHCEPRFS.INST.MREpisodeI("IdxAdmDate",date,mrPatientID,rowID))
				q:(rowID = "")
		
				s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(rowID)	
				s episodeID = obj.EpisodeID
	
				s count = count + 1
				w !,count_"   "_episodeID_"   "_##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishOUT(episodeID)	
			
				s count = count + 1
			}
		}
	}
}

/// w ##class(DHCEPRFS.Tool.UpdateData).NewRecreatePIS()
ClassMethod NewRecreatePIS()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID),-1)
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)	
		s schemeType = obj.SchemeType
		s:(schemeType = $c(0)) schemeType = ""
		if (schemeType = "CREATEPIS")
		{
			s episodeID = obj.EpisodeID
			s AdmDate = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDate(episodeID)
			s date = $zdh("2014-7-1",3)
			if (AdmDate >= date)
			{
				//b "s"
				s count = count + 1
				w !,count_"   "_episodeID_"   "_##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishPIS(episodeID)	
			
				s count = count + 1
				//q:(count = 100)
			}
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).DeleteMRVerItemByMRItem(5,2379574)
ClassMethod DeleteMRVerItemByMRItem(AMRItemID As %String, AEpisodeID As %String)
{
	s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_AEpisodeID,""))
	
	s version = ""
	for {
		b "s"
		s version = $o(^DHCEPRFS.INST.MRVersionI("IdxMain", " "_mrEpisodeID,version))
		q:(version = "")
		
		s versionID = $o(^DHCEPRFS.INST.MRVersionI("IdxMain", " "_mrEpisodeID,version,""))
		q:(versionID = "")
		
		s mrVerItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_versionID," "_AMRItemID,""))
		
		if (mrVerItemID '= "")
		{
			w ##class(DHCEPRFS.INST.MRVerItem).%DeleteId(mrVerItemID)
		}
	}
}

/// 加入全文检索队列
/// d ##class(DHCEPRFS.Tool.UpdateData).AddFullTextSearch()
ClassMethod AddFullTextSearch()
{
	s mrEpisodeID = ""
	for {
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeD(mrEpisodeID),-1)
		q:(mrEpisodeID = "")

		w !,mrEpisodeID_"   "_##class(DHCEPRSearch.BL.BLSearch).Create(mrEpisodeID,"50")
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateMedRecord()
ClassMethod UpdateMedRecord()
{
	s MREpisodePatID = ""
	for {
		s MREpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatD(MREpisodePatID))
		q:(MREpisodePatID = "")

		s objMREpisodePat = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(MREpisodePatID)
		s MedRecordNo = objMREpisodePat.MedRecordNo
		s MRPatientID = objMREpisodePat.MRPatientID
		//是否存在
		s mrMedRecordID = ""
		s mrMedRecordID = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo"," DHC"," "_MedRecordNo,mrMedRecordID))
		if (mrMedRecordID = "")
		{
			s obj = ##class(DHCEPRFS.INST.MRMedRecord).%New()
			s obj.CreateDate = $p($h,",",1)
			s obj.CreateTime = $p($h,",",2)
			s obj.LastModifyDate = $p($h,",",1)
			s obj.LastModifyTime = $p($h,",",2)
			s obj.MedRecordNo = MedRecordNo
			s obj.MRPatientID = MRPatientID
			s obj.SysCode = "DHC"
			s sc = obj.%Save()
			s mrMedRecordID = obj.%Id()	
		}
		//b "s"
		if ((objMREpisodePat.MRMedRecordID = "") || (objMREpisodePat.MRMedRecordID = $c(0)))
		{
			s objMREpisodePat.MRMedRecordID = mrMedRecordID	
			s sc = objMREpisodePat.%Save()
		}
		s mrEpisodeID = objMREpisodePat.MREpisodeID
		s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		if ((objMREpisode.MRMedRecordID = "") || (objMREpisode.MRMedRecordID = $c(0)))
		{
			s objMREpisode.MRMedRecordID = mrMedRecordID	
			s sc = objMREpisode.%Save()
		}
		w !,mrEpisodeID
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).RecreateEducation()
ClassMethod RecreateEducation()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID),-1)
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)	
		s schemeType = obj.SchemeType
		s:(schemeType = $c(0)) schemeType = ""
		if (schemeType = "")
		{

			s episodeID = obj.EpisodeID
			s count = count + 1
			w !,count_"   "_episodeID_"    "_##class(DHCEPRFS.SI.SIAdmMRStatus).PublishEducation(episodeID)
			
			s count = count + 1
			//q:(count = 100)
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).RecreateADM()
ClassMethod RecreateADM()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID),-1)
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)	
		s schemeType = obj.SchemeType
		s:(schemeType = $c(0)) schemeType = ""
		if (schemeType = "CREATEADM")
		{

			s episodeID = obj.EpisodeID
			s count = count + 1
			w !,count_"   "_episodeID_"    "_##class(DHCEPRFS.SI.SIAdmMRStatus).PublishADM(episodeID)
			
			s count = count + 1
			//q:(count = 100)
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).RecreateOrder()
ClassMethod RecreateOrder()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID),-1)
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)	
		s schemeType = obj.SchemeType
		s:(schemeType = $c(0)) schemeType = ""
		if (schemeType = "")
		{

			s episodeID = obj.EpisodeID
			s count = count + 1
			w !,count_"   "_episodeID_"    "_##class(DHCEPRFS.SI.SIAdmMRStatus).PublishLongOrder(episodeID)
			
			s count = count + 1
			//q:(count = 100)
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).CreateOrderAll()
ClassMethod CreateOrderAll()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
		s episodeID = obj.EpisodeID
		s schemeType = obj.SchemeType
		s:(schemeType = $c(0)) schemeType = ""
		if (schemeType = "")
		{
			d ##class(DHCEPRFS.SI.SIAdmMRStatus).PublishLongOrder(episodeID)
			w !,episodeID
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).CreateINDAll()
ClassMethod CreateINDAll()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
		s episodeID = obj.EpisodeID
		s schemeType = obj.SchemeType
		s:(schemeType = $c(0)) schemeType = ""
		if (schemeType = "")
		{
			d ##class(DHCEPRFS.SI.SIAdmMRStatus).PublishIND(episodeID)
			w !,episodeID
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).CreateADMAll()
ClassMethod CreateADMAll()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
		s episodeID = obj.EpisodeID
		s schemeType = obj.SchemeType
		s:(schemeType = $c(0)) schemeType = ""
		if (schemeType = "")
		{
			d ##class(DHCEPRFS.SI.SIAdmMRStatus).PublishADM(episodeID)
			w !,episodeID
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).CreatePFAll()
ClassMethod CreatePFAll()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
		s episodeID = obj.EpisodeID
		s schemeType = obj.SchemeType
		s:(schemeType = $c(0)) schemeType = ""
		if (schemeType = "")
		{
			d ##class(DHCEPRFS.SI.SIAdmMRStatus).PublishNursePF(episodeID)
			w !,episodeID
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).DeleteQueueTask()
ClassMethod DeleteQueueTask()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)
		s episodeID = obj.EpisodeID 
		if (obj.SchemeType = "CREATEADM")
		{
			s status = ##Class(DHCEPRFS.INST.AdmTaskQueue).%DeleteId(rowID)	
			w !,rowID
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).DeleteCancelTask()
ClassMethod DeleteCancelTask()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
		s episodeID = obj.EpisodeID
		s flag = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).CheckEpisodeCancel(episodeID)
		if (flag = "1")
		{
			w !,episodeID
			s status = ##Class(DHCEPRFS.INST.AdmTaskSucceed).%DeleteId(rowID)
		}
	}
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)
		s episodeID = obj.EpisodeID
		s flag = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).CheckEpisodeCancel(episodeID)
		if (flag = "1")
		{
			w !,episodeID
			s status = ##Class(DHCEPRFS.INST.AdmTaskQueue).%DeleteId(rowID)
		}
	}	
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskExecD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(rowID)
		s episodeID = obj.EpisodeID
		s flag = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).CheckEpisodeCancel(episodeID)
		if (flag = "1")
		{
			w !,episodeID
			s status = ##Class(DHCEPRFS.INST.AdmTaskExec).%DeleteId(rowID)
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).DeleteCancelEpisode()
ClassMethod DeleteCancelEpisode()
{
	s mrEpisodeID = ""
	for {
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeD(mrEpisodeID))
		q:(mrEpisodeID = "")
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)	
		s episodeID = obj.EpisodeID
		
		s flag = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).CheckEpisodeCancel(episodeID)
		if (flag = "1")
		{
			w !,episodeID
			TSTART
			//b 
			d obj.%Close()
			s status = ##Class(DHCEPRFS.INST.MREpisode).%DeleteId(mrEpisodeID)
			if ('$$$ISOK(status))
			{
				TROLLBACK
			}
			
			s rowID = ""
			s rowID = $o(^DHCEPRFS.INST.MREpisodePatI("IdxMREpisodeID"," "_mrEpisodeID,rowID))
			s status = ##Class(DHCEPRFS.INST.MREpisodePat).%DeleteId(rowID)
			if ('$$$ISOK(status))
			{
				TROLLBACK
			}
			
			s rowID = ""
			s rowID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_mrEpisodeID,rowID))
			s status = ##Class(DHCEPRFS.INST.MREpisodeFP).%DeleteId(rowID)
			if ('$$$ISOK(status))
			{
				TROLLBACK
			}
			
			s rowID = ""
			s rowID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_mrEpisodeID,rowID))
			s status = ##Class(DHCEPRFS.INST.MREpisodeFee).%DeleteId(rowID)
			if ('$$$ISOK(status))
			{
				TROLLBACK
			}
			
			s version = ""
			for {
				s version = $o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_mrEpisodeID,version))
				q:(version = "")
				s versionID = ""
				s versionID = $o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_mrEpisodeID,version,versionID))
				s status = ##Class(DHCEPRFS.INST.MRVersion).%DeleteId(versionID)
				if ('$$$ISOK(status))
				{
					TROLLBACK
				}
				
				
			}
			TCOMMIT
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateExecVersionType()
ClassMethod UpdateExecVersionType()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskExecD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(rowID)	
		s versionTypeCode = obj.VersionTypeCode
		s:(versionTypeCode = $c(0)) versionTypeCode = ""
		s schemeType = obj.SchemeType
		if (schemeType = "CREATEPRIVACY01")
		{
			s obj.VersionTypeCode = "CREATEPRIVACY01"
			d obj.%Save()	
		}
	}
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)	
		s versionTypeCode = obj.VersionTypeCode
		s:(versionTypeCode = $c(0)) versionTypeCode = ""
		s schemeType = obj.SchemeType
		if (schemeType = "CREATEPRIVACY01")
		{
			s obj.VersionTypeCode = "CREATEPRIVACY01"
			d obj.%Save()	
		}
	}
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)	
		s versionTypeCode = obj.VersionTypeCode
		s:(versionTypeCode = $c(0)) versionTypeCode = ""
		s schemeType = obj.SchemeType
		if (schemeType = "CREATEPRIVACY01")
		{
			s obj.VersionTypeCode = "CREATEPRIVACY01"
			d obj.%Save()	
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateMREPMedRecordNo()
ClassMethod UpdateMREPMedRecordNo()
{
	s MREpisodePatID = ""
	for {
		s MREpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatD(MREpisodePatID))
		q:(MREpisodePatID = "")

		s objMREpisodePat = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(MREpisodePatID)
		s MedRecordNo = objMREpisodePat.MedRecordNo
		if ((MedRecordNo = "") || (MedRecordNo = $c(0)))
		{
			//b "s"
			s EpisodeID = objMREpisodePat.EpisodeID
			s PatientID = objMREpisodePat.PatientID
			
			s MedRecordNoUpdate = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(PatientID,"",EpisodeID)
			s objMREpisodePat.MedRecordNo = MedRecordNoUpdate
			b "01"
			s sc = objMREpisodePat.%Save()
			w !,MedRecordNoUpdate
		}
	}
}

/// d ##Class(DHCEPRFS.Tool.UpdateData).ChechContinuePrint()	
ClassMethod ChechContinuePrint()
{
	s count = 0
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.MREpisodeD(rowID))
		q:(rowID = "")
		s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(rowID)		
		s EpisodeID = objMREpisode.EpisodeID
		//s MRPatientID = objMREpisode.MRPatientID
		//s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
		//s PatientID = objMRPatient.PatientID
		
		s needPrint = ##class(DHCEPRFS.BL.HISInfo.BLEPRInfo).NeedPrint(EpisodeID,"512")
		
		s AttachmentNeedPrint = ##class(DHCEPRFS.BL.HISInfo.BLEPRInfo).NeedPrint(EpisodeID,"1425")
		
		if ((AttachmentNeedPrint = "1") && (needPrint '= "1"))
		{
			s count = count + 1
			d ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",EpisodeID,"49")
			w !,count_"  EpisodeID= "_EpisodeID
		}
	}
}

/// d ##Class(DHCEPRFS.Tool.UpdateData).UpdateAddChildTask()
ClassMethod UpdateAddChildTask()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.MREpisodeD(rowID))
		q:(rowID = "")	
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(rowID)
		s EpisodeID = obj.EpisodeID
		
				//将新生儿加入队列生成
		s childEpisodeID = 	""
		for {
			s childEpisodeID = $o(^PAADMi("Mother",EpisodeID,childEpisodeID)) 	
			q:(childEpisodeID = "")
			
			s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC", childEpisodeID, "50")
			w !,"add to queue succeed, queueID= "_admTaskQueueID
		}
	}
}

/// d ##Class(DHCEPRFS.Tool.UpdateData).CheckDuplicateMedRecordNo()
ClassMethod CheckDuplicateMedRecordNo()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.MRPatientD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(rowID)
		s medRecordNo = obj.MedRecordNo
		s regNo = obj.RegNo
		s name = obj.Name
		
		s ret = $d(^CacheTemp("dhceprfs-debug-2016-1-28",medRecordNo))
		//病案号已存在
		if (ret)
		{
			w !,regNo_"^"_medRecordNo_"^"_name
			w !,"Duplicate  "_^CacheTemp("dhceprfs-debug-2016-1-28",medRecordNo)
		}
		else
		{
			s ^CacheTemp("dhceprfs-debug-2016-1-28",medRecordNo) = regNo_"^"_medRecordNo_"^"_name
		}
	}
}

/// d ##Class(DHCEPRFS.Tool.UpdateData).UpdateTransDept()
ClassMethod UpdateTransDept()
{
	s mrEpisodeID = ""
	for {
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeD(mrEpisodeID))
		q:(mrEpisodeID = "")
		
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)	
		s episodeID = obj.EpisodeID	
		s TransDept =$P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).TransDeptDetail(episodeID),"^",2)
		s TransDeptID = $P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).TransDeptDetail(episodeID),"^",1)
		s obj.TransDept = TransDept
		s obj.TransDeptID = TransDeptID
		s sc = obj.%Save()
		w !,obj.%Id()_"   "_episodeID_"  "_TransDept_"  "_TransDeptID
	}
}

/// d ##Class(DHCEPRFS.Tool.UpdateData).UpdateInsuranceType()
ClassMethod UpdateInsuranceType()
{
	s mrEpisodeID = "37000"
	for {
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeD(mrEpisodeID))
		q:(mrEpisodeID = "")
		
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)	
		s episodeID = obj.EpisodeID
		
		//s Glossary = ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(episodeID,"HDSD00.11")
		
		s InsuranceType = ##Class(EPRservice.BOScatterData).GetDataByGlossary(episodeID,"HDSD00.11.1249")
		s InsuranceTypeCode = ##Class(EPRservice.BOScatterData).GetDataByGlossary(episodeID,"HDSD00.11.1248")
		s PayModeCode = ##Class(EPRservice.BOScatterData).GetDataByGlossary(episodeID,"HDSD00.11.117")
		
		s obj.InsuranceType = InsuranceType
		s obj.InsuranceTypeCode = InsuranceTypeCode
		s obj.PayModeCode = PayModeCode
		s sc = obj.%Save()
		w !,obj.%Id()_"   "_episodeID_"  "_InsuranceType_"  "_InsuranceTypeCode_"  "_PayModeCode
	}
}

/// d ##Class(DHCEPRFS.Tool.UpdateData).UpdatePageStatus(99999,100000)
ClassMethod UpdatePageStatus(AStartIndex, AEndIndex)
{
	s psItemID = ##Class(DHCEPRFS.BL.BLMRItem).GetItemIDByType("PS","0")
	
	s rowID = AStartIndex
	for {
		s rowID = $o(^DHCEPRFS.INST.MRLogD(rowID))
		q:(rowID="")
		q:(AEndIndex'="")&&(rowID>AEndIndex)
			
		s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(rowID)
		continue:(objMRLog = "")
		
		/*
		if (objMRLog.PageStatus'="")
		{
			w !,"rowID:"_rowID_", no update"
			continue
		}
		*/
		
		s mrEpisodeID = objMRLog.MREpisodeID
		s mrStatus = objMRLog.MRStatus
		
		if (mrStatus = "SCANNED")
		{
			s objMRLog.PageStatus = "SCANNED"
			
			s operInfo = ..GetOperateInfo(rowID,"SCAN")
			if operInfo = "" b
			s objMRLog.PageModifyDate = $p(operInfo,"#",1)
			s objMRLog.PageModifyTime = $p(operInfo,"#",2)
			s objMRLog.PageModifyUserID = $p(operInfo,"#",3)
			
			w !,"rowID:"_rowID_", "
			w objMRLog.%Save()
			continue
		}
		elseif (mrStatus = "ARRANGED")
		{
			
			s objMRLog.PageStatus = "ARRANGED"
			
			s operInfo = ..GetOperateInfo(rowID,"ARRANGE")
			if operInfo = "" b
			s objMRLog.PageModifyDate = $p(operInfo,"#",1)
			s objMRLog.PageModifyTime = $p(operInfo,"#",2)
			s objMRLog.PageModifyUserID = $p(operInfo,"#",3)
			
			w !,"rowID:"_rowID_", "
			w objMRLog.%Save()
			continue
		}
		elseif (mrStatus = "REPLACED")
		{
			s objMRLog.PageStatus = "REPLACED"
			
			s operInfo = ..GetOperateInfo(rowID,"REPLACE")
			if operInfo = "" b
			s objMRLog.PageModifyDate = $p(operInfo,"#",1)
			s objMRLog.PageModifyTime = $p(operInfo,"#",2)
			s objMRLog.PageModifyUserID = $p(operInfo,"#",3)
			
			w !,"rowID:"_rowID_", "
			w objMRLog.%Save()
			continue
		}
		elseif (mrStatus = "REVIEWED")||(mrStatus = "CATALOGED")
		{
			s psCount = ..GetPSItemCount(mrEpisodeID,psItemID)
			if (psCount > 0)
			{
				s objMRLog.PageStatus = "SCANNED"
				
				s operInfo = ..GetOperateInfo(rowID,"SCAN")
				if operInfo = "" b
				s objMRLog.PageModifyDate = $p(operInfo,"#",1)
				s objMRLog.PageModifyTime = $p(operInfo,"#",2)
				s objMRLog.PageModifyUserID = $p(operInfo,"#",3)
			
				w !,"rowID:"_rowID_", "
				w objMRLog.%Save()
				continue
			}
			else
			{
				s actionID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",rowID," REPLACE",""))
				if (actionID '= "")
				{
					s objMRLog.PageStatus = "REPLACED"
					
					s operInfo = ..GetOperateInfo(rowID,"REPLACE")
					if operInfo = "" b
					s objMRLog.PageModifyDate = $p(operInfo,"#",1)
					s objMRLog.PageModifyTime = $p(operInfo,"#",2)
					s objMRLog.PageModifyUserID = $p(operInfo,"#",3)
				
					w !,"rowID:"_rowID_", "
					w objMRLog.%Save()
					continue
				}
				
				s actionID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",rowID," ARRANGE",""))
				if (actionID '= "")
				{
					s objMRLog.PageStatus = "ARRANGED"
					
					s operInfo = ..GetOperateInfo(rowID,"ARRANGE")
					if operInfo = "" b
					s objMRLog.PageModifyDate = $p(operInfo,"#",1)
					s objMRLog.PageModifyTime = $p(operInfo,"#",2)
					s objMRLog.PageModifyUserID = $p(operInfo,"#",3)
					
					w !,"rowID:"_rowID_", "
					w objMRLog.%Save()
					continue
				}
				
				s actionID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",rowID," SCAN",""))
				if (actionID '= "")
				{
					s objMRLog.PageStatus = "SCANNED"
					
					s operInfo = ..GetOperateInfo(rowID,"SCAN")
					if operInfo = "" b
					s objMRLog.PageModifyDate = $p(operInfo,"#",1)
					s objMRLog.PageModifyTime = $p(operInfo,"#",2)
					s objMRLog.PageModifyUserID = $p(operInfo,"#",3)
					
					w !,"rowID:"_rowID_", "
					w objMRLog.%Save()
					continue
				}
				
				s objMRLog.PageModifyDate = objMRLog.ModifyDate
				s objMRLog.PageModifyTime = objMRLog.ModifyTime
				s objMRLog.PageModifyUserID = objMRLog.ModifyUserID
				s objMRLog.PageStatus = "TOSCAN"
				
				w !,"rowID:"_rowID_", "
				w objMRLog.%Save()
				continue
			}
		}
		
		w !,"rowID:"_rowID_", no update"
	}
}

ClassMethod GetOperateInfo(mrLogID, action) As %String
{
	s detailID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," "_action,""),-1)
	if (detailID="")&&(action="REPLACE")
	{
		s detailID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," CONFIRMSCAN",""),-1)
	}
	q:(detailID="") ""
	
	s obj = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_detailID)
	s a = obj.ActDate_"#"_obj.ActTime_"#"_obj.ActUserID
	//b
	q a
}

ClassMethod GetPSItemCount(mrEpisodeID, psItemID) As %Integer
{
	s mrVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(mrEpisodeID,"0","")
	q:(mrVersionID="") "0"
		
	s mrVerItemID = ##Class(DHCEPRFS.BL.BLMRVerItem).GetMRVerItemID(mrVersionID,psItemID)
	q:(mrVerItemID="") "0"
	
	s obj = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
	q:(obj="") "0"
	
	q obj.TotCount
}

/// debug: d ##class(DHCEPRFS.Tool.UpdateData).UpdateMRPatientAlias()
ClassMethod UpdateMRPatientAlias()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.MRPatientD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(rowID)	
		s name = obj.Name
		s obj.AliasName = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(name,3,"")
		s obj.AliasNameInitial = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(name,4,"")
		s sc = obj.%Save()
		w !,+sc_" MRPatientID="_rowID_" Name="_name_" AliasName="_obj.AliasName_" AliasNameInitial="_obj.AliasNameInitial
	}
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.MREpisodePatD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(rowID)	
		s name = obj.Name
		s obj.AliasName = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(name,3,"")
		s obj.AliasNameInitial = ##Class(DHCEPRFS.Util.StringHelper).GetCNCODE(name,4,"")
		s sc = obj.%Save()
		w !,+sc_" MREpisodePatID="_rowID_" Name="_name_" AliasName="_obj.AliasName_" AliasNameInitial="_obj.AliasNameInitial
	}
	
	w !,##class(DHCEPRFS.INST.MRPatient).%BuildIndices()
	w !,##class(DHCEPRFS.INST.MREpisodePat).%BuildIndices()
}

ClassMethod DeleteOutPatientAdm()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)
		s episodeID = obj.EpisodeID
		//就诊类型
		s PAAdmType = $p($g(^PAADM(episodeID)),"^",2)   
			
		if (PAAdmType = "O")
		{
			b "s"
			&sql(delete from DHCEPRFS_INST.AdmTaskQueue where id = :rowID)
		}
		
	}
}

/// debug: d ##class(DHCEPRFS.Tool.UpdateData).UpdateNoPlanAgainOp("59000")
ClassMethod UpdateNoPlanAgainOp(mrEpisodeID)
{
	//s mrEpisodeID = ""
	for {
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeD(mrEpisodeID))
		q:(mrEpisodeID = "")
		
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)	
		s episodeID = obj.EpisodeID
		s noPlanAgainOp = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).NoPlanAgainOp(episodeID)
		s obj.NoPlanAgainOp = noPlanAgainOp
		s sc = obj.%Save()
		w !,obj.%Id()_"   "_episodeID_"  "_noPlanAgainOp
	}
}

/// 删除多余未扫描录入就诊
/// debug: d ##class(DHCEPRFS.Tool.UpdateData).DeleteDuplicateMREpisode()
ClassMethod DeleteDuplicateMREpisode()
{
	k ^CacheTemp("yang-debug")
	s totalCount = 0
	s MedRecordID = " "_$c(0)
	for {
		//b "s"
		s MedRecordID = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMain"," DHC", " N",MedRecordID))	
		q:(MedRecordID = "")
		
		s mrMedRecordID = ""
		for {
			s mrMedRecordID = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMain"," DHC", " N",MedRecordID,mrMedRecordID))	
			q:(mrMedRecordID = "")
			
			s count = 0
			s countDate = 0
			s mrEpisodeID = ""
			for {
				s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRMedRecordID"," "_mrMedRecordID,mrEpisodeID))	
				q:(mrEpisodeID = "")
				//b "s"
				s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
				s admDate = objMREpisode.AdmDate
				s disDate = objMREpisode.DisDate
				s episodeID = objMREpisode.EpisodeID
				if ($e(episodeID,1,2) = "VE")
				{
					s count = count + 1
					if (count > 1 )
					{
						s countDate = countDate + 1
						s totalCount = totalCount + 1
						//w !,totalCount_"@"_countDate_"@"_MedRecordID_"@"_mrMedRecordID_"|"_mrEpisodeID_"|"_admDate_"|"_disDate
						s ^CacheTemp("yang-debug",mrMedRecordID,admDate,disDate) = MedRecordID

					}
				}
			}
		}
	}
	
	s mrMedRecord = ""
	for {
		s mrMedRecord = $o(^CacheTemp("yang-debug",mrMedRecord))
		q:(mrMedRecord = "")
		s count = 0
		s mrEpisodeID = ""
		for {
			s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRMedRecordID"," "_mrMedRecord,mrEpisodeID))	
			q:(mrEpisodeID = "")
			
			s count = count + 1
			if (count = 1)
			{
				s flag = "false"
				//检查是否扫描
				s mrLogID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_mrEpisodeID,""))
				s detail = ""
				for {
					s detail = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",mrLogID,detail))
					q:(detail = "")
					
					s sub = ""
					for {
						s sub = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",mrLogID,detail,sub))
						q:(sub = "")
						s detailID = mrLogID_"||"_sub
						s objMRLogDetail = ##class(DHCEPRFS.INST.MRLogDetail).%OpenId(detailID)
						if (objMRLogDetail.MRAction = "SCAN")
						{
							s flag = "true"
							q
						}
					}	
					
					if (flag = "false")
					{
						s objMRMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(mrMedRecord)
						s MedRecordNo = objMRMedRecord.MedRecordNo
						b "01"
						//删除
						&sql(delete from DHCEPRFS_INST.MREpisode where id = :mrEpisodeID)
						&sql(delete from DHCEPRFS_INST.MREpisodePat where MREpisodeID = :mrEpisodeID)
						
						&sql(delete from DHCEPRFS_INST.MREpisodeFP where MREpisodeID = :mrEpisodeID)
						&sql(delete from DHCEPRFS_INST.MREpisodeFee where MREpisodeID = :mrEpisodeID)
						b "02"
						q
					}
				}
			}
		}
	}
}

/// debug: d ##class(DHCEPRFS.Tool.UpdateData).DeleteMREpisode()
ClassMethod DeleteMREpisode()
{
	
	s mrMedRecord = ""
	for {
		s mrMedRecord = $o(^CacheTemp("yang-debug",mrMedRecord))
		q:(mrMedRecord = "")
		s count = 0
		s mrEpisodeID = ""
		for {
			s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRMedRecordID"," "_mrMedRecord,mrEpisodeID))	
			q:(mrEpisodeID = "")
			
			s count = count + 1
			if (count = 1)
			{
				s flag = "false"
				//检查是否扫描
				s mrLogID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_mrEpisodeID,""))
				s detail = ""
				for {
					s detail = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",mrLogID,detail))
					q:(detail = "")
					
					s sub = ""
					for {
						s sub = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",mrLogID,detail,sub))
						q:(sub = "")
						s detailID = mrLogID_"||"_sub
						s objMRLogDetail = ##class(DHCEPRFS.INST.MRLogDetail).%OpenId(detailID)
						if (objMRLogDetail.MRAction = "SCAN")
						{
							s flag = "true"
							q
						}
					}	
					
					if (flag = "false")
					{
						b "s"
						//删除
						&sql(delete from DHCEPRFS_INST.MREpisode where id = :mrEpisodeID)
						&sql(delete from DHCEPRFS_INST.MREpisodePat where MREpisodeID = :mrEpisodeID)
						
						&sql(delete from DHCEPRFS_INST.MREpisodeFP where MREpisodeID = :mrEpisodeID)
						&sql(delete from DHCEPRFS_INST.MREpisodeFee where MREpisodeID = :mrEpisodeID)
					}
				}
			}
		}
	}
}

/// 更新扫描查询不到就诊
/// debug: d ##class(DHCEPRFS.Tool.UpdateData).UpdateMREpisodePatNoMedRecord()
ClassMethod UpdateMREpisodePatNoMedRecord()
{
	s mrEpisodePatID = ""
	for {
		s mrEpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatI("IdxMedRecordNo"," ",mrEpisodePatID))	
		q:(mrEpisodePatID = "")
		s objMREpisodePat = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(mrEpisodePatID)
		if ((objMREpisodePat.RegNo = "") || (objMREpisodePat.RegNo = $c(0)))
		{
			//b "s"
							//更新数据
					s mrPatientID = objMREpisodePat.MRPatientID
					s mrMedRecordID = objMREpisodePat.MRMedRecordID
					s objMRMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(mrMedRecordID)
					s medRecordNo = objMRMedRecord.MedRecordNo
					d ##class(DHCEPRFS.BL.BLMRPatient).UpdateFSMREpisodePat(mrEpisodePatID,mrPatientID,	medRecordNo)
	
		}
	}
}

/// debug: d ##class(DHCEPRFS.Tool.UpdateData).BatchAddEpisode2QCheck("2015-9-1","2017-2-1")
ClassMethod BatchAddEpisode2QCheck(AStartDate As %String, AEndDate As %String)
{
    s AStartDate=$zdh(AStartDate,3)
    s AEndDate=$zdh(AEndDate,3)
    q:(AStartDate="") "-1"
	q:(AEndDate="") "-1"
   
   	s count = 0
   	for PAADMDischgDate=AStartDate:1:AEndDate
    {
    	s PAADMRowID="" 
    	for {
    		s PAADMRowID=$o(^PAADMi("DischDate",PAADMDischgDate,PAADMRowID)) 
    		q:(PAADMRowID="")
    		s episodeID = PAADMRowID
    		//是否是取消的就诊
    		s flag = $p(^PAADM(episodeID),"^",20)
    		continue:(flag = "c")
    		continue:(flag = "C")
    		//是否住院的就诊（去除门诊急诊）
    		s paadmType = $p(^PAADM(episodeID),"^",2)
    		continue:(paadmType '= "I")
    		//去除库里面有的
    		s rowID = ""
    		s rowID = $O(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID", " DHC", " "_episodeID, "")) 
    		if (rowID = "")
    		{
    			s count = count + 1
    			w !, " count: "_count_" episodeID: "_episodeID
    			w !, " count: "_count_" episodeID: "_episodeID_"   "_##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",episodeID,"50","","N","","","")
    		}
    	}
    }
}

/// 宁医附院用
/// debug: d ##class(DHCEPRFS.Tool.UpdateData).BatchAddEpisode2Queue("2015-6-1","2015-6-1")
ClassMethod BatchAddEpisode2Queue(AStartDate As %String, AEndDate As %String)
{
    s AStartDate=$zdh(AStartDate,3)
    s AEndDate=$zdh(AEndDate,3)
    q:(AStartDate="") "-1"
	q:(AEndDate="") "-1"
   
   	s count = 0
   	for PAADMDischgDate=AStartDate:1:AEndDate
    {
    	s PAADMRowID="" 
    	for {
    		s PAADMRowID=$o(^PAADMi("DischDate",PAADMDischgDate,PAADMRowID)) 
    		q:(PAADMRowID="")
    		s episodeID = PAADMRowID
    		//是否是取消的就诊
    		s flag = $p(^PAADM(episodeID),"^",20)
    		continue:(flag = "c")
    		continue:(flag = "C")
    		//是否住院的就诊（去除门诊急诊）
    		s paadmType = $p(^PAADM(episodeID),"^",2)
    		continue:(paadmType '= "I")
    		s count = count + 1
    		w !, " count: "_count_" episodeID: "_episodeID
    		w !, " count: "_count_" episodeID: "_episodeID_"   "_##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",episodeID,"50","","N","","","")
    	}
    }
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateMRMedRecord()
ClassMethod UpdateMRMedRecord()
{
	s MREpisodePatID = ""
	for {
		s MREpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatD(MREpisodePatID))
		q:(MREpisodePatID = "")

		s objMREpisodePat = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(MREpisodePatID)
		s MedRecordNo = objMREpisodePat.MedRecordNo
		s MRPatientID = objMREpisodePat.MRPatientID
		//是否存在
		s mrMedRecordID = ""
		s mrMedRecordID = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo"," DHC"," "_MedRecordNo,mrMedRecordID))
		if (mrMedRecordID = "")
		{
			s obj = ##class(DHCEPRFS.INST.MRMedRecord).%New()
			s obj.CreateDate = $p($h,",",1)
			s obj.CreateTime = $p($h,",",2)
			s obj.LastModifyDate = $p($h,",",1)
			s obj.LastModifyTime = $p($h,",",2)
			s obj.MedRecordNo = MedRecordNo
			s obj.MRPatientID = MRPatientID
			s obj.SysCode = "DHC"
			s sc = obj.%Save()
			s mrMedRecordID = obj.%Id()	
		}
		//b "s"
		if ((objMREpisodePat.MRMedRecordID = "") || (objMREpisodePat.MRMedRecordID = $c(0)))
		{
			s objMREpisodePat.MRMedRecordID = mrMedRecordID	
			s sc = objMREpisodePat.%Save()
		}
		s mrEpisodeID = objMREpisodePat.MREpisodeID
		s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		if ((objMREpisode.MRMedRecordID = "") || (objMREpisode.MRMedRecordID = $c(0)))
		{
			s objMREpisode.MRMedRecordID = mrMedRecordID	
			s sc = objMREpisode.%Save()
		}
		w !,mrEpisodeID
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateMREpisodeID()
ClassMethod UpdateMREpisodeID()
{
	s MREpisodePatID = ""
	for {
		s MREpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatD(MREpisodePatID))
		q:(MREpisodePatID = "")

		s objMREpisodePat = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(MREpisodePatID)
		s MREpisodeID = objMREpisodePat.MREpisodeID
		if ((MREpisodeID = "") || (MREpisodeID = $c(0)))
		{
			b "s"
			s EpisodeID = objMREpisodePat.EpisodeID
			s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_EpisodeID,""))
			
			s objMREpisodePat.MREpisodeID = mrEpisodeID
			s sc = objMREpisodePat.%Save()
			w !,MREpisodePatID
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateMREpisodePat()
ClassMethod UpdateMREpisodePat()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.MREpisodeD(rowID))
		q:(rowID = "")
		
		//判断是否在DHCEPRFS.INST.MREpisodePat存在	
		s mrEpisodePatID = ""
		s mrEpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatI("IdxMREpisodeID"," "_rowID,mrEpisodePatID))
		continue:(mrEpisodePatID '= "")
		s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(rowID)
		s AMRPatientID = objMREpisode.MRPatientID
		s AEpisodeID = objMREpisode.EpisodeID
		s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(AMRPatientID)
		s APatientID = objMRPatient.PatientID
		s ASysCode = objMRPatient.SysCode
		s AMRMedRecordID = objMREpisode.MRMedRecordID
	
		s mrEpisodePatID = ##class(DHCEPRFS.BL.BLMRPatient).CreateMRPatient(APatientID, ASysCode,AEpisodeID,AMRPatientID,AMRMedRecordID)
		w !,mrEpisodePatID
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).AdjustMRItem()
ClassMethod AdjustMRItem()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.META.MRItemD(rowID),-1)
		q:(rowID = "")
		continue:((+rowID) < 120)
		s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(rowID)
		if (obj.Type = "PS")
		{
			//b "s"
			s obj.TypeParams = (+obj.TypeParams) + 1
			s obj.Sequence = (+obj.Sequence) + 1
			d obj.%Save()
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).CreateOneByEpisodeID(7520325)
ClassMethod CreateOneByEpisodeID(AEpisodeID)
{
	s flag = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).CheckEpisodeCancel(AEpisodeID)
	if (flag = "0")
	{
		w !,##class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",AEpisodeID,"50")	
		//判断是否是产科婴儿，婴儿没有病案首页，不需要屏蔽隐私，否则队列中隐私项目为空会卡住
		//通过是否有病案号(新生婴儿没有病案号)
		s medRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetMedNo(AEpisodeID)
		s:(medRecordNo = $c(0)) medRecordNo = ""
		if (medRecordNo '= "")
		{
			w !,"Privacy "_##class(DHCEPRFS.BL.BLAdmTaskQueue).CreatePrivacyLevel01("DHC",AEpisodeID,"50")
		}
			
		s ret = ##Class(DHCEPRFS.BL.HISInfo.BLPISInfo).HasPISToPrint(AEpisodeID)
		if (ret = "1")
		{
			d ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishPIS(AEpisodeID)	
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateOneMREpisodeInfo()
ClassMethod UpdateOneMREpisodeInfo(AEpisodeID)
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_AEpisodeID,rowID))
		q:(rowID = "")
		
		d ##class(DHCEPRFS.BL.BLUpdateMrEpisode).UpdateMrEpisodeData(rowID)
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateMREpisodeInfo(196200)
/// //196200
/// //47000
ClassMethod UpdateMREpisodeInfo(AID)
{
		
		s rowID = AID
		for {
			s rowID = $o(^DHCEPRFS.INST.MREpisodeD(rowID),-1)
			q:(rowID = "")
			d ##class(DHCEPRFS.BL.BLUpdateMrEpisode).UpdateMrEpisodeData(rowID)	
			w !,rowID
		}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).RecreateSpecial()
ClassMethod RecreateSpecial()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskExecD(rowID))
		q:(rowID = "")
		//b "s"
		s obj = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(rowID)	
		s TaskType = obj.TaskType
		s:(TaskType = $c(0)) TaskType = ""
		if (TaskType = "S")
		{
			
			s count = count + 1
			s entity = ##class(DHCEPRFS.Entity.EAdmTaskExec).%New()
			s entity.ID = rowID
			s entity.SysCode = obj.SysCode
			s entity.PatientID = obj.PatientID
			s entity.EpisodeID = obj.EpisodeID
			s entity.MedRecordNo = obj.MedRecordNo
			s entity.RegNo = obj.RegNo
			s entity.IPRecordNo = obj.IPRecordNo
			s entity.OPRecordNo = obj.OPRecordNo
			s entity.EPRecordNo = obj.EPRecordNo
			s entity.Priority = obj.Priority
			s entity.AdmDate = obj.AdmDate
			s entity.CandidateDate = obj.CandidateDate
			s entity.CandidateTime = obj.CandidateTime
			s entity.TaskDate = obj.TaskDate
			s entity.TaskTime = obj.TaskTime
			s entity.TaskRemark = obj.TaskRemark
			s entity.IP = obj.IP
			s entity.UserID = obj.UserID
			s entity.SchemeType = obj.SchemeType
			s entity.TaskType = obj.TaskType
			s entity.CreateCount = obj.CreateCount
			s entity.RemarkDate = obj.RemarkDate
			s entity.RemarkTime = obj.RemarkTime
			w !,count_"  "_##class(DHCEPRFS.BL.BLAdmTaskExec).MoveTaskExecToQueue(entity)
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).ANCreate("2011-1-1","2014-7-31")
/// d ##class(DHCEPRFS.Tool.UpdateData).ICUCreate("2014-8-1","2015-1-31")
ClassMethod ICUCreate(AStartDate As %String, AEndDate As %String)
{
	/// 妇科西（无患者）		
	d ..ICUOneCreate("1788",AStartDate,AEndDate)
	/// 妇科东三			
	d ..ICUOneCreate("1852",AStartDate,AEndDate)
	/// 妇科东四			
	d ..ICUOneCreate("1477",AStartDate,AEndDate)
	/// 妇科东五			
	d ..ICUOneCreate("1853",AStartDate,AEndDate)
	/// 妇科微创中心西（无患者）	
	d ..ICUOneCreate("1761",AStartDate,AEndDate)
	/// 妇科微创中心东（无患者）		
	d ..ICUOneCreate("1762",AStartDate,AEndDate)
	/// 妇科微创西一		
	d ..ICUOneCreate("1883",AStartDate,AEndDate)
	/// 妇科微创西二 		
	d ..ICUOneCreate("1884",AStartDate,AEndDate)
	/// 妇科微创西三 		
	d ..ICUOneCreate("1917",AStartDate,AEndDate)
	/// 妇科东三特需			
	d ..ICUOneCreate("1933",AStartDate,AEndDate)
	/// 妇科东四特需			
	d ..ICUOneCreate("1935",AStartDate,AEndDate)
	/// 妇科东五特需			
	d ..ICUOneCreate("1937",AStartDate,AEndDate)
	/// 产科西（无患者）			
	d ..ICUOneCreate("1759",AStartDate,AEndDate)
	/// 产科东			
	d ..ICUOneCreate("1862",AStartDate,AEndDate)
	/// 产科东一 			
	d ..ICUOneCreate("1758",AStartDate,AEndDate)
	/// 产科东二			
	d ..ICUOneCreate("1854",AStartDate,AEndDate)
	/// 产科东六			
	d ..ICUOneCreate("1855",AStartDate,AEndDate)
	/// 产科东七			
	d ..ICUOneCreate("1856",AStartDate,AEndDate)
	/// 产科东八			
	d ..ICUOneCreate("1858",AStartDate,AEndDate)
	/// 产科东九			
	d ..ICUOneCreate("1859",AStartDate,AEndDate)
	/// 产科东一特需		
	d ..ICUOneCreate("1939",AStartDate,AEndDate)
	/// 产科东二特需		
	d ..ICUOneCreate("1941",AStartDate,AEndDate)
	/// 产科东六特需		
	d ..ICUOneCreate("1943",AStartDate,AEndDate)
	/// 产科东七特需		
	d ..ICUOneCreate("1857",AStartDate,AEndDate)
	/// 产科东八特需		
	d ..ICUOneCreate("1945",AStartDate,AEndDate)
	/// 产科东九特需		
	d ..ICUOneCreate("1947",AStartDate,AEndDate)
	/// 儿科东				
	d ..ICUOneCreate("1760",AStartDate,AEndDate)
	/// 妇科肿瘤东（无患者）	
	d ..ICUOneCreate("1504",AStartDate,AEndDate)
	/// 妇科肿瘤西（无患者）		
	d ..ICUOneCreate("1763",AStartDate,AEndDate)
	/// 妇科肿瘤西一		
	d ..ICUOneCreate("1880",AStartDate,AEndDate)
	/// 妇科肿瘤西二		
	d ..ICUOneCreate("1881",AStartDate,AEndDate)
	/// 妇科肿瘤西三		
	d ..ICUOneCreate("1905",AStartDate,AEndDate)
	/// 妇科肿瘤西一特需		
	d ..ICUOneCreate("1969",AStartDate,AEndDate)
	/// 妇科肿瘤西二特需		
	d ..ICUOneCreate("1971",AStartDate,AEndDate)
	/// 妇科肿瘤西三特需		
	d ..ICUOneCreate("1973",AStartDate,AEndDate)
	/// 计划生育西（无患者） 			
	d ..ICUOneCreate("1538",AStartDate,AEndDate)
	/// 计划生育东 （无患者）			
	d ..ICUOneCreate("1765",AStartDate,AEndDate)
	/// 生殖调节（计划生育）*			
	//d ..ICUOneCreate("1539",AStartDate,AEndDate)
	/// 生殖调节（计划生育）#			
	//d ..ICUOneCreate("1541",AStartDate,AEndDate)
	/// 生殖调节（计育）特需*			
	//d ..ICUOneCreate("1543",AStartDate,AEndDate)
	/// 计生西一 			
	d ..ICUOneCreate("1882",AStartDate,AEndDate)
	/// 计生西二 			
	d ..ICUOneCreate("1918",AStartDate,AEndDate)
	/// 计生西二特需 			
	d ..ICUOneCreate("1951",AStartDate,AEndDate)
	/// 乳腺外科西 			
	d ..ICUOneCreate("1559",AStartDate,AEndDate)
	/// 男科女性泌尿东（无患者）		
	d ..ICUOneCreate("1519",AStartDate,AEndDate)
	/// 男科女性泌尿西（无患者）		
	d ..ICUOneCreate("1764",AStartDate,AEndDate)
	/// ICU东（无患者）		
	d ..ICUOneCreate("1784",AStartDate,AEndDate)
	/// ICU西（无患者）				
	d ..ICUOneCreate("1786",AStartDate,AEndDate)
	/// 儿保眼科（无患者）			
	d ..ICUOneCreate("1958",AStartDate,AEndDate)
	/// 产后保健			
	d ..ICUOneCreate("1960",AStartDate,AEndDate)
}

ClassMethod ICUOneCreate(ACTLocID As %String, AStartDate As %String, AEndDate As %String) As %String
{
	s:(ACTLocID = $c(0)) ACTLocID = ""
	s param = "^^"_ACTLocID_"^^"_AStartDate_"^^"_AEndDate_"^^^^^^"
	s filterParam = "^^^^^^^^^^"
	s ds = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLEpisodeInfo:GetPatientList")
	s sc = ds.Execute(param,filterParam)
	
	while (ds.Next())
	{
		s episodeID = ds.Data("PAADM")
		q:(episodeID = "")
		
		s flag = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).CheckEpisodeCancel(episodeID)
		if (flag = "0")
		{
			s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasICUToPrint(episodeID)
			if (ret="1")
			{
				w !,##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishICU(episodeID)
			}
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).ANCreate("2011-1-1","2014-7-31")
/// d ##class(DHCEPRFS.Tool.UpdateData).ANCreate("2014-8-1","2014-12-31")
ClassMethod ANCreate(AStartDate As %String, AEndDate As %String)
{
	/// 妇科西（无患者）		
	d ..ANOneCreate("1788",AStartDate,AEndDate)
	/// 妇科东三			
	d ..ANOneCreate("1852",AStartDate,AEndDate)
	/// 妇科东四			
	d ..ANOneCreate("1477",AStartDate,AEndDate)
	/// 妇科东五			
	d ..ANOneCreate("1853",AStartDate,AEndDate)
	/// 妇科微创中心西（无患者）	
	d ..ANOneCreate("1761",AStartDate,AEndDate)
	/// 妇科微创中心东（无患者）		
	d ..ANOneCreate("1762",AStartDate,AEndDate)
	/// 妇科微创西一		
	d ..ANOneCreate("1883",AStartDate,AEndDate)
	/// 妇科微创西二 		
	d ..ANOneCreate("1884",AStartDate,AEndDate)
	/// 妇科微创西三 		
	d ..ANOneCreate("1917",AStartDate,AEndDate)
	/// 妇科东三特需			
	d ..ANOneCreate("1933",AStartDate,AEndDate)
	/// 妇科东四特需			
	d ..ANOneCreate("1935",AStartDate,AEndDate)
	/// 妇科东五特需			
	d ..ANOneCreate("1937",AStartDate,AEndDate)
	/// 产科西（无患者）			
	d ..ANOneCreate("1759",AStartDate,AEndDate)
	/// 产科东			
	d ..ANOneCreate("1862",AStartDate,AEndDate)
	/// 产科东一 			
	d ..ANOneCreate("1758",AStartDate,AEndDate)
	/// 产科东二			
	d ..ANOneCreate("1854",AStartDate,AEndDate)
	/// 产科东六			
	d ..ANOneCreate("1855",AStartDate,AEndDate)
	/// 产科东七			
	d ..ANOneCreate("1856",AStartDate,AEndDate)
	/// 产科东八			
	d ..ANOneCreate("1858",AStartDate,AEndDate)
	/// 产科东九			
	d ..ANOneCreate("1859",AStartDate,AEndDate)
	/// 产科东一特需		
	d ..ANOneCreate("1939",AStartDate,AEndDate)
	/// 产科东二特需		
	d ..ANOneCreate("1941",AStartDate,AEndDate)
	/// 产科东六特需		
	d ..ANOneCreate("1943",AStartDate,AEndDate)
	/// 产科东七特需		
	d ..ANOneCreate("1857",AStartDate,AEndDate)
	/// 产科东八特需		
	d ..ANOneCreate("1945",AStartDate,AEndDate)
	/// 产科东九特需		
	d ..ANOneCreate("1947",AStartDate,AEndDate)
	/// 儿科东				
	d ..ANOneCreate("1760",AStartDate,AEndDate)
	/// 妇科肿瘤东（无患者）	
	d ..ANOneCreate("1504",AStartDate,AEndDate)
	/// 妇科肿瘤西（无患者）		
	d ..ANOneCreate("1763",AStartDate,AEndDate)
	/// 妇科肿瘤西一		
	d ..ANOneCreate("1880",AStartDate,AEndDate)
	/// 妇科肿瘤西二		
	d ..ANOneCreate("1881",AStartDate,AEndDate)
	/// 妇科肿瘤西三		
	d ..ANOneCreate("1905",AStartDate,AEndDate)
	/// 妇科肿瘤西一特需		
	d ..ANOneCreate("1969",AStartDate,AEndDate)
	/// 妇科肿瘤西二特需		
	d ..ANOneCreate("1971",AStartDate,AEndDate)
	/// 妇科肿瘤西三特需		
	d ..ANOneCreate("1973",AStartDate,AEndDate)
	/// 计划生育西（无患者） 			
	d ..ANOneCreate("1538",AStartDate,AEndDate)
	/// 计划生育东 （无患者）			
	d ..ANOneCreate("1765",AStartDate,AEndDate)
	/// 生殖调节（计划生育）*			
	//d ..ANOneCreate("1539",AStartDate,AEndDate)
	/// 生殖调节（计划生育）#			
	//d ..ANOneCreate("1541",AStartDate,AEndDate)
	/// 生殖调节（计育）特需*			
	//d ..ANOneCreate("1543",AStartDate,AEndDate)
	/// 计生西一 			
	d ..ANOneCreate("1882",AStartDate,AEndDate)
	/// 计生西二 			
	d ..ANOneCreate("1918",AStartDate,AEndDate)
	/// 计生西二特需 			
	d ..ANOneCreate("1951",AStartDate,AEndDate)
	/// 乳腺外科西 			
	d ..ANOneCreate("1559",AStartDate,AEndDate)
	/// 男科女性泌尿东（无患者）		
	d ..ANOneCreate("1519",AStartDate,AEndDate)
	/// 男科女性泌尿西（无患者）		
	d ..ANOneCreate("1764",AStartDate,AEndDate)
	/// ICU东（无患者）		
	d ..ANOneCreate("1784",AStartDate,AEndDate)
	/// ICU西（无患者）				
	d ..ANOneCreate("1786",AStartDate,AEndDate)
	/// 儿保眼科（无患者）			
	d ..ANOneCreate("1958",AStartDate,AEndDate)
	/// 产后保健			
	d ..ANOneCreate("1960",AStartDate,AEndDate)
}

ClassMethod ANOneCreate(ACTLocID As %String, AStartDate As %String, AEndDate As %String) As %String
{
	s:(ACTLocID = $c(0)) ACTLocID = ""
	s param = "^^"_ACTLocID_"^^"_AStartDate_"^^"_AEndDate_"^^^^^^"
	s filterParam = "^^^^^^^^^^"
	s ds = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLEpisodeInfo:GetPatientList")
	s sc = ds.Execute(param,filterParam)
	
	while (ds.Next())
	{
		s episodeID = ds.Data("PAADM")
		q:(episodeID = "")
		
		s flag = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).CheckEpisodeCancel(episodeID)
		if (flag = "0")
		{
			//w !,..Create("DHC",episodeID,"50")	
			//判断是否是产科婴儿，婴儿没有病案首页，不需要屏蔽隐私，否则队列中隐私项目为空会卡住
			//通过是否有病案号(新生婴儿没有病案号)
			//s medRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetMedNo(episodeID)
			//s:(medRecordNo = $c(0)) medRecordNo = ""
			//if (medRecordNo '= "")
			//{
			//	w !,"Privacy "_..CreatePrivacyLevel01("DHC",episodeID,"50")
			//}
			w !,##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishAN(episodeID)
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).LocCreate("2011-1-1","2014-7-31")
/// d ##class(DHCEPRFS.Tool.UpdateData).LocCreate("2014-8-1","2014-12-31")
/// d ##class(DHCEPRFS.Tool.UpdateData).LocCreate("2015-1-1","2015-2-28")
/// d ##class(DHCEPRFS.Tool.UpdateData).LocCreate("2015-3-1","2015-3-10")
ClassMethod LocCreate(AStartDate As %String, AEndDate As %String)
{
	/// 妇科西（无患者）		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1788",AStartDate,AEndDate)
	/// 妇科东三			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1852",AStartDate,AEndDate)
	/// 妇科东四			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1477",AStartDate,AEndDate)
	/// 妇科东五			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1853",AStartDate,AEndDate)
	/// 妇科微创中心西（无患者）	
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1761",AStartDate,AEndDate)
	/// 妇科微创中心东（无患者）		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1762",AStartDate,AEndDate)
	/// 妇科微创西一		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1883",AStartDate,AEndDate)
	/// 妇科微创西二 		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1884",AStartDate,AEndDate)
	/// 妇科微创西三 		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1917",AStartDate,AEndDate)
	/// 妇科东三特需			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1933",AStartDate,AEndDate)
	/// 妇科东四特需			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1935",AStartDate,AEndDate)
	/// 妇科东五特需			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1937",AStartDate,AEndDate)
	/// 产科西（无患者）			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1759",AStartDate,AEndDate)
	/// 产科东			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1862",AStartDate,AEndDate)
	/// 产科东一 			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1758",AStartDate,AEndDate)
	/// 产科东二			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1854",AStartDate,AEndDate)
	/// 产科东六			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1855",AStartDate,AEndDate)
	/// 产科东七			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1856",AStartDate,AEndDate)
	/// 产科东八			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1858",AStartDate,AEndDate)
	/// 产科东九			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1859",AStartDate,AEndDate)
	/// 产科东一特需		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1939",AStartDate,AEndDate)
	/// 产科东二特需		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1941",AStartDate,AEndDate)
	/// 产科东六特需		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1943",AStartDate,AEndDate)
	/// 产科东七特需		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1857",AStartDate,AEndDate)
	/// 产科东八特需		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1945",AStartDate,AEndDate)
	/// 产科东九特需		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1947",AStartDate,AEndDate)
	/// 儿科东				
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1760",AStartDate,AEndDate)
	/// 妇科肿瘤东（无患者）	
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1504",AStartDate,AEndDate)
	/// 妇科肿瘤西（无患者）		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1763",AStartDate,AEndDate)
	/// 妇科肿瘤西一		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1880",AStartDate,AEndDate)
	/// 妇科肿瘤西二		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1881",AStartDate,AEndDate)
	/// 妇科肿瘤西三		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1905",AStartDate,AEndDate)
	/// 妇科肿瘤西一特需		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1969",AStartDate,AEndDate)
	/// 妇科肿瘤西二特需		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1971",AStartDate,AEndDate)
	/// 妇科肿瘤西三特需		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1973",AStartDate,AEndDate)
	/// 计划生育西（无患者） 			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1538",AStartDate,AEndDate)
	/// 计划生育东 （无患者）			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1765",AStartDate,AEndDate)
	/// 生殖调节（计划生育）*			
	//w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1539",AStartDate,AEndDate)
	/// 生殖调节（计划生育）#			
	//w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1541",AStartDate,AEndDate)
	/// 生殖调节（计育）特需*			
	//w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1543",AStartDate,AEndDate)
	/// 计生西一 			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1882",AStartDate,AEndDate)
	/// 计生西二 			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1918",AStartDate,AEndDate)
	/// 计生西二特需 			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1951",AStartDate,AEndDate)
	/// 乳腺外科西 			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1559",AStartDate,AEndDate)
	/// 男科女性泌尿东（无患者）		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1519",AStartDate,AEndDate)
	/// 男科女性泌尿西（无患者）		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1764",AStartDate,AEndDate)
	/// ICU东（无患者）		
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1784",AStartDate,AEndDate)
	/// ICU西（无患者）				
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1786",AStartDate,AEndDate)
	/// 儿保眼科（无患者）			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1958",AStartDate,AEndDate)
	/// 产后保健			
	w ##Class(DHCEPRFS.BL.BLAdmTaskQueue).LocCreate("1960",AStartDate,AEndDate)
}

/// d ##class(DHCEPRFS.Tool.UpdateData).RecreateToday()
ClassMethod RecreateToday()
{
	
	s date = $p($h,",",1)
	s time = ""
	for {
		s time = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxTypeSucceedDateTime"," N",date,time))
		q:(time = "")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxTypeSucceedDateTime"," N",date,time,rowID))
			q:(rowID = "")
			s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
			s schemeType = obj.SchemeType
			s:(schemeType = $c(0)) schemeType = ""
			if (schemeType = "")
			{
				w !,##Class(DHCEPRFS.BL.BLAdmTaskSucceed).Recreate(rowID)	
			}
		}	
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).RecreateBUltra()
ClassMethod RecreateBUltra()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID),-1)
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)	
		s schemeType = obj.SchemeType
		s:(schemeType = $c(0)) schemeType = ""
		if (schemeType = "CREATEBULTRA")
		{
			s episodeID = obj.EpisodeID
			s count = count + 1
			w !,count_"   "_episodeID_"    "_##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishBUltra(episodeID)
			
			s count = count + 1
			//q:(count = 100)
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).RecreateLIS()
ClassMethod RecreateAN()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)	
		s schemeType = obj.SchemeType
		s:(schemeType = $c(0)) schemeType = ""
		if (schemeType = "")
		{
			s episodeID = obj.EpisodeID
			s count = count + 1
			w !,count_"   "_episodeID_"    "_##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishAN(episodeID)
			
			s count = count + 1
			//q:(count = 100)
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).RecreatePIS()
ClassMethod RecreatePIS()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)	
		s schemeType = obj.SchemeType
		s:(schemeType = $c(0)) schemeType = ""

		if (schemeType = "")
		{
			s episodeID = obj.EpisodeID
			s ret = ##Class(DHCEPRFS.BL.HISInfo.BLPISInfo).HasPISToPrint(episodeID)
			continue:(ret = "0")
			
			//##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(2461996)
			s DisDate = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(episodeID)
			s DisDate = $p(DisDate,",",1)
			continue:(DisDate < $zdh("2014-8-1",3))
		
			s count = count + 1
			w !,count_"   "_episodeID_"    "_##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishPIS(episodeID)	
			
			//q:(count = 100)
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).RecreateLIS()
ClassMethod RecreateLIS()
{
	s rowID = ""
	s count = 0
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID))
		q:(rowID = "")
		
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)	
		s schemeType = obj.SchemeType
		s:(schemeType = $c(0)) schemeType = ""
		if (schemeType = "")
		{
			s episodeID = obj.EpisodeID
			s ret = ##Class(DHCEPRFS.BL.HISInfo.BLLISInfo).HasCSLISReport(episodeID)
			continue:(ret = "0")
			s count = count + 1
			w !,count_"   "_episodeID_"    "_##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishLIS(episodeID)	
			
			s count = count + 1
			//q:(count = 100)
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).FileMasterDeleteSchemeType()
ClassMethod FileMasterDeleteSchemeType()
{
	s start = $h
	
	s count = 0, ecount1 = 0, ecount2 = 0
	
	s mrVerItemID = ""
	for {
		s mrVerItemID = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID))
		q:(mrVerItemID = "")
		s detailNum = ""
		for {
			s detailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum))
			q:(detailNum = "")
			//不为0的不需要更新
			continue:(detailNum>0)
			s subID = ""
			s subID = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum,subID))
			q:(subID = "")
			s mrVerItemDetailID = mrVerItemID_"||"_subID
			//b "s"
			s obj = ##class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
			s FileMasterPath = obj.FileMasterPath
			
			s obj2 = ##class(DHCEPRFS.INST.FileMaster).%OpenId(obj.FileMasterID)
			s FileMasterPath2 = obj2.FileMasterName
			
			s newPath = ""
			s count1 = $l(FileMasterPath,"-")
			s count2 = $l(FileMasterPath,"_")
			if (count1 = 3)
			{
				//扫描文件
				continue
			}
			elseif (count2 = 7)
			{
				//生成文件
				continue			
			}
			elseif (count2 = 8)
			{
				continue	
			}
			elseif (count2 = 9)
			{
				if ($p(FileMasterPath,"_",9) = "CREATEPRIVACY01.pdf")
				{
					//b "s"
					continue	
				}	
				else
				{
					//b "s"
					//s newPath = $p(FileMasterPath2,"_",1)
					//s newPath = newPath_"_"_$p(FileMasterPath2,"_",2)
					//s newPath = newPath_"_"_$p(FileMasterPath2,"_",3)
					//s newPath = newPath_"_"_$p(FileMasterPath2,"_",4)
					//s newPath = newPath_"_"_$p(FileMasterPath2,"_",5)
					//s newPath = newPath_"_"_$p(FileMasterPath2,"_",6)
					//s newPath = newPath_"_"_$p(FileMasterPath2,"_",7)
					//s newPath = newPath_"_"_$p(FileMasterPath2,"_",8)
					//s newPath = newPath_".pdf"

					//s obj2.FileMasterName = newPath
					//s sc = obj2.%Save()
					//if ($$$ISERR(sc))
					//{
						//b	
					//}
					
					s newPath = $p(FileMasterPath,"_",1)
					s newPath = newPath_"_"_$p(FileMasterPath,"_",2)
					s newPath = newPath_"_"_$p(FileMasterPath,"_",3)
					s newPath = newPath_"_"_$p(FileMasterPath,"_",4)
					s newPath = newPath_"_"_$p(FileMasterPath,"_",5)
					s newPath = newPath_"_"_$p(FileMasterPath,"_",6)
					s newPath = newPath_"_"_$p(FileMasterPath,"_",7)
					s newPath = newPath_"_"_$p(FileMasterPath,"_",8)
					s newPath = newPath_".pdf"

					s obj.FileMasterPath = newPath
					s sc = obj.%Save()
					if ($$$ISERR(sc))
					{
						//b	
					}
					
					s count = count + 1
					w !,count_", "_mrVerItemDetailID_", "_newPath	
				}
			}
		}
		
		s end = $h
			
		//w !,"totcount:"_count

	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateFileMasterPath()
ClassMethod UpdateFileMasterPath()
{
	s count = 0
	s mrVerItemID = ""
	for {
		s mrVerItemID = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID))
		q:(mrVerItemID = "")
		s detailNum = ""
		for {
			s detailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum))
			q:(detailNum = "")
			//不为0的不需要更新
			continue:(detailNum > 0)
			s subID = ""
			s subID = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum,subID))
			q:(subID = "")
			s mrVerItemDetailID = mrVerItemID_"||"_subID
			s obj = ##class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
			s FileMasterPath = obj.FileMasterPath
			s a = $p(FileMasterPath,"_",8)
			if ((a = "") || (a = $c(0)))
			{
				s c = $p(FileMasterPath,"0-0",1)_"0-0"_"_0"_$p(FileMasterPath,"0-0",2)
				s obj.FileMasterPath = c
				d obj.%Save()
				s count = count + 1
				w count
			}
		}
	}
}

ClassMethod UpdateMRLogDetail()
{
	s count = 0
	s mrlogRowID = ""
	for {
		s mrlogRowID = $o(^DHCEPRFS.INST.MRLogD(mrlogRowID))
		q:(mrlogRowID="")
		s obj = ##class(DHCEPRFS.INST.MRLog).%OpenId(mrlogRowID)
		s mrEpisodeID = obj.MREpisodeID
		
		s detailNum = ""
		for {
			s detailNum = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",mrlogRowID,detailNum))
			q:(detailNum = "")
			s subID = ""
			for {
				s subID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",mrlogRowID,detailNum,subID))
				q:(subID = "")
				s rowID = mrlogRowID_"||"_subID
				s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(rowID)
				s objMRLogDetail.MREpisodeID = mrEpisodeID
				s count = count + 1
				s sc = objMRLogDetail.%Save()
				w !,count
			}	
		}
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateAge()
ClassMethod UpdateAge()
{
	s rowID = ""

	for {
		s rowID = $o(^DHCEPRFS.INST.MREpisodeD(rowID))
		q:(rowID = "")	
		s obj = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(rowID)
		s episodeID = obj.EpisodeID
		s mrPatientID = obj.MRPatientID
		
		s objP = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
		continue:(objP = "")
		
		s age = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).%OpenId(episodeID)
		if ((age '= "") || (age '= $c(0)))
		{
			s objP.Age = $p(age,"^",1)	
			s objP.AgeMonth = $p(age,"^",2)	
			s objP.AgeDay = $p(age,"^",3)	
		}
		else
		{
			s objP.Age = ""
			s objP.AgeMonth = ""
			s objP.AgeDay = ""		
		}

		s status = objP.%Save()
		w !,"Update Age "_mrPatientID
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateTaskType()
ClassMethod UpdateTaskType()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
		s Priority = obj.Priority
		if (+Priority < 100)
		{
			s obj.TaskType = "N"	
		}	
		elseif ((+Priority >= 100)&&(+Priority < 1000))
		{
			s obj.TaskType = "G"	
		}
		elseif ((+Priority >= 1000)&&(+Priority < 2000))
		{
			s obj.TaskType = "O"	
		}
			elseif (+Priority >= 2000)
		{
			s obj.TaskType = "S"	
		}
		
		s status = obj.%Save()
		w !,"UpdateAdmTaskSuccee "_obj.EpisodeID_" "_obj.TaskType
	}
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)
		s Priority = obj.Priority
		if (+Priority < 100)
		{
			s obj.TaskType = "N"	
		}	
		elseif ((+Priority >= 100)&&(+Priority < 1000))
		{
			s obj.TaskType = "G"	
		}
		elseif ((+Priority >= 1000)&&(+Priority < 2000))
		{
			s obj.TaskType = "O"	
		}
			elseif (+Priority >= 2000)
		{
			s obj.TaskType = "S"	
		}
		
		s status = obj.%Save()
		w !,"UpdateAdmTaskQueue "_obj.EpisodeID_" "_obj.TaskType
	}
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.AdmTaskExecD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(rowID)
		s Priority = obj.Priority
		if (+Priority < 100)
		{
			s obj.TaskType = "N"	
		}	
		elseif ((+Priority >= 100)&&(+Priority < 1000))
		{
			s obj.TaskType = "G"	
		}
		elseif ((+Priority >= 1000)&&(+Priority < 2000))
		{
			s obj.TaskType = "O"	
		}
			elseif (+Priority >= 2000)
		{
			s obj.TaskType = "S"	
		}
		
		s status = obj.%Save()
		w !,"UpdateAdmTaskExec "_obj.EpisodeID_" "_obj.TaskType
	}
	
	d ##class(DHCEPRFS.INST.AdmTaskSucceed).%BuildIndices()
	d ##class(DHCEPRFS.INST.AdmTaskExec).%BuildIndices()
	d ##class(DHCEPRFS.INST.AdmTaskQueue).%BuildIndices()
}

/// 老项目更新MrEpisode表中的主治医师
ClassMethod UpdateMREpisodeAttendingDoc()
{
	s count = 0
	s mrEpisodeID = ""

	for {
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeD(mrEpisodeID))
		q:(mrEpisodeID = "")	
		s obj = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)

		s episodeID = obj.EpisodeID
		s Glossary = ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(episodeID,"HDSD00.11")

		s obj.AttendingDocID = Glossary.GetAt("HDSD00.11.577")
		s obj.AttendingDoc = Glossary.GetAt("HDSD00.11.138")

		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			s count = count + 1
			w !,count_"  "_obj.%Id()
		}
		else
		{
			w !,"error"
		}
	}
}

/// d ##Class(DHCEPRFS.Tool.UpdateData).UpdateMREpisodeAndFP()
ClassMethod UpdateMREpisodeAndFP()
{
	s count = 0
	s mrEpisodeID = ""
	for {
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeD(mrEpisodeID))
		q:(mrEpisodeID = "")	
		s obj = ##class(DHCEPRFS.INST.MREpisodeUpdateTask).%New()
		s obj.MREpisodeID = mrEpisodeID
		s obj.TaskDate = $p($h,",",1)
		s obj.TaskTime = $p($h,",",2)
		s obj.Priority = "50"
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			s count = count + 1
			w !,count_"  "_obj.%Id()
		}
		else
		{
			w !,"error"
		}
	}
	//d ##class(DHCEPRFS.INST.MREpisodeUpdateTask).%BuildIndices()
}

/// debug: d ##Class(DHCEPRFS.Tool.UpdateData).UpdateFP()
ClassMethod UpdateFP()
{
		s count = 0
	s mrEpisodeID = ""
	for {
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeD(mrEpisodeID),-1)
		q:(mrEpisodeID = "")	
					s count = count + 1
			w !,count_"  "_##Class(DHCEPRFS.BL.BLMREpisodeFP).UpdateMREpisodeFP(mrEpisodeID)	
	}
}

/// debug: d ##Class(DHCEPRFS.Tool.UpdateData).UpdateMREpisodeFP(1000)
ClassMethod UpdateMREpisodeFP(ACount As %String)
{
	s count = 0
	s mrEpisodeID = ""
	for {
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeD(mrEpisodeID))
		q:(mrEpisodeID = "")
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		s mrPatientID = obj.MRPatientID
		s episodeID = obj.EpisodeID
		s sysCode = obj.SysCode
		
		s ret = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_mrEpisodeID,""))
		//b "2"
		continue:(ret'="")
		w !,##Class(DHCEPRFS.BL.BLMREpisodeFP).CreateMREpisodeFP(mrPatientID, episodeID, sysCode)
		s count = count + 1
		//b "s"
		q:(count = ACount)
	}
}

/// debug: d ##Class(DHCEPRFS.Tool.UpdateData).UpdatePriority()
ClassMethod UpdatePriority()
{
	//更新待生成队列
	&sql(update DHCEPRFS_INST.AdmTaskQueue set Priority = 50)
	w !,SQLCODE
	//更新生成队列
	&sql(update DHCEPRFS_INST.AdmTaskExec set Priority = 50)
	w !,SQLCODE
	//更新完成队列
	&sql(update DHCEPRFS_INST.AdmTaskSucceed set Priority = 50)
	w !,SQLCODE
}

/// debug: d ##Class(DHCEPRFS.Tool.UpdateData).UpdateQueueDateTimeIndex()
ClassMethod UpdateQueueDateTimeIndex()
{
	d ##class(DHCEPRFS.INST.AdmTaskExec).%BuildIndices()
	d ##class(DHCEPRFS.INST.AdmTaskQueue).%BuildIndices()
	d ##class(DHCEPRFS.INST.AdmTaskSucceed).%BuildIndices()
}

/// debug: d ##Class(DHCEPRFS.Tool.UpdateData).UpdateQueryUser()
ClassMethod UpdateQueryUser()
{
	&sql(update DHCEPRFS_META.QueryUser set Type = 'TEMP' where Type = '')
	w !,SQLCODE	
	
	d ##class(DHCEPRFS.META.QueryUser).%BuildIndices()
}

/// debug: d ##Class(DHCEPRFS.Tool.UpdateData).UpdateAdmTask()
ClassMethod UpdateAdmTask()
{
	s priority = ""
 	for {
		s priority =  $o(^DHCEPRFS.INST.AdmTaskExecI("IdxPriority", priority))
		//b "s"
		q:(priority = "")
		s rowID = ""
		for {
			//b "s"
			s rowID = $o(^DHCEPRFS.INST.AdmTaskExecI("IdxPriority", priority, rowID))
			q:(rowID = "")
			s obj = ##class(DHCEPRFS.INST.AdmTaskExec).%OpenId(rowID)
			s patientID = obj.PatientID
			s obj.MedRecordNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID)
			s obj.RegNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(patientID)
			s status = obj.%Save()
			d obj.%Close()
		}
 	}
 	
 	s priority = ""
 	for {
		s priority =  $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxPriority", priority))
		//b "s"
		q:(priority = "")
		s rowID = ""
		for {
			//b "s"
			s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxPriority", priority, rowID))
			q:(rowID = "")
			s obj = ##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(rowID)
			s patientID = obj.PatientID
			s obj.MedRecordNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID)
			s obj.RegNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(patientID)
			s status = obj.%Save()
			d obj.%Close()
		}
 	}

	s rowID = ""
	for {
		//b "s"
		s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
		s patientID = obj.PatientID
		s obj.MedRecordNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID)
		s obj.RegNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(patientID)
		s status = obj.%Save()
		d obj.%Close()
	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).GetScanLogAverageCount()
ClassMethod GetScanLogAverageCount()
{
 	s flagAction = "SCAN"
 	s count = 0
 	s total = 0
 	s date = ""
 	for {
	 	s date = $O(^DHCEPRFS.INST.MRLogDtlFinalI("IdxMRAction"," "_flagAction,date))
	 	q:(date = "")
	 	s time = ""
	 	for {
	 		s time = $O(^DHCEPRFS.INST.MRLogDtlFinalI("IdxMRAction"," "_flagAction,date,time))
	 		q:(time ="")
	 	
	 		s detailLogFinalID = ""
	 		for {
		 		s detailLogFinalID = $O(^DHCEPRFS.INST.MRLogDtlFinalI("IdxMRAction"," "_flagAction,date,time,detailLogFinalID))
	 			q:(detailLogFinalID ="")
	 			
	 			s objDetailLogFinal = ##Class(DHCEPRFS.INST.MRLogDtlFinal).%OpenId(detailLogFinalID)
	 			continue:(objDetailLogFinal="")
	 			
	 			s actPages = objDetailLogFinal.ActPages
	 			if (+actPages<1000){
		 			s count = count + 1
		 			s total = +total + +actPages
		 			s avg = (+total)/(+count)
		 			w !,"count:"_count_" avg:"_avg_" number:"_actPages
		 		}
	 		}
	 	}
 	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).GetScanLogBigNumberCount()
ClassMethod GetScanLogBigNumberCount()
{
 	s flagAction = "SCAN"
 	s count = 0
 	s date = ""
 	for {
	 	s date = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date))
	 	q:(date = "")
	 	s time = ""
	 	for {
	 		s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time))
	 		q:(time ="")
	 	
	 		s rowID = ""
	 		for {
		 		s rowID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,rowID))
	 			q:(rowID ="")
	 			s subID = ""
	 			for {
		 			s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,rowID,subID))
	 				q:(subID ="")
	 				s objDetailLog = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(rowID_"||"_subID)
	 				continue:(objDetailLog="")
	 			
	 				s actPages = objDetailLog.ActPages
	 				if (+actPages>1000){
		 				s count = count + 1
		 				w !,"count:"_count_" number:"_actPages
		 			}
	 			}
	 		}
	 	}
 	}
}

/// d ##class(DHCEPRFS.Tool.UpdateData).UpdateScanLogBigNumber()
ClassMethod UpdateScanLogBigNumber()
{
 	s flagAction = "SCAN"
 	s count = 0
 	s date = ""
 	for {
	 	s date = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date))
	 	q:(date = "")
	 	s time = ""
	 	for {
	 		s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time))
	 		q:(time ="")
	 	
	
	 		s rowID = ""
	 		for {
		 		s rowID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,rowID))
	 			q:(rowID ="")
	 			s subID = ""
	 			for {
		 			s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,rowID,subID))
	 				q:(subID ="")
	 				s objDetailLog = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(rowID_"||"_subID)
	 				continue:(objDetailLog="")
	 			
	 				s actPages = objDetailLog.ActPages
	 				if (+actPages>100){
		 				s count = count + 1
		 				s objDetailLog.ActPages = 15
		 				s sc = objDetailLog.%Save()
		 				w !,"count:"_count_" number:"_actPages
	 				}
		 		}
	 		}
	 	}
 	}
}

/// w ##Class(DHCEPRFS.Tool.UpdateData).GetActPages("294138")
ClassMethod GetActPages(argMREpisodeID As %String) As %String
{
	Set ReturenValue="",TotalCount=0,ActPages=0
	Set Version=""
	for  
	{
		Set Version=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_argMREpisodeID,Version))
		Quit:Version=""	
		Set INSTMRVersionID=""
		for
		{
			Set INSTMRVersionID=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_argMREpisodeID,Version,INSTMRVersionID))
			Quit:INSTMRVersionID=""
			Set MRItemID=""
			for  
			{
				Set MRItemID=$o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_INSTMRVersionID,MRItemID))
				Quit:MRItemID=""
				Set INSTMRVerItemID=""
				for  
				{
				    Set INSTMRVerItemID=$o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_INSTMRVersionID,MRItemID,INSTMRVerItemID))
				    Quit:INSTMRVerItemID=""
					Set objINSTMRVerItem=##Class(DHCEPRFS.INST.MRVerItem).%OpenId(INSTMRVerItemID)		
					Set objCTMRItem=##Class(DHCEPRFS.META.MRItem).%OpenId(objINSTMRVerItem.MRItemID)
					continue:objCTMRItem.Type'="PS"
					Set TotalCount=objINSTMRVerItem.TotCount
					Set ActPages=ActPages+TotalCount
										
					d objCTMRItem.%Close()
					d objINSTMRVerItem.%Close()
					Set objCTMRItem=""
					Set objINSTMRVerItem=""			
				}
			}			
		}
		Set ReturenValue=ActPages
	}
	Quit ReturenValue
}

/// d ##Class(DHCEPRFS.Tool.UpdateData).UpdateActPages("292564")
ClassMethod UpdateActPages(argMREpisodeID As %String)
{
	
	Set TrueActPages=..GetActPages(argMREpisodeID)
	w " TrueActPages :",TrueActPages,!

	
	Set MRLogDtlFinalRowID=""
	Set MRLogDtlFinalRowID=$o(^DHCEPRFS.INST.MRLogDtlFinalI("IdxMain"," "_argMREpisodeID," SCAN",MRLogDtlFinalRowID))
	If MRLogDtlFinalRowID'=""
	{
		Set objMRLogDtlFinal=##Class(DHCEPRFS.INST.MRLogDtlFinal).%OpenId(MRLogDtlFinalRowID)
		Set ActPages=objMRLogDtlFinal.ActPages
		w "-SCAN objMRLogDtlFinal :",ActPages," ID:"_MRLogDtlFinalRowID,!
		
		if (TrueActPages'=ActPages)
		{
			w "---Before Update, ActPages is "_objMRLogDtlFinal.ActPages,!
			Set objMRLogDtlFinal.ActPages=TrueActPages
			w "---Status: ", objMRLogDtlFinal.%Save(),!
			w "---after Update, ActPages is "_objMRLogDtlFinal.ActPages,!
		}
		d objMRLogDtlFinal.%Close()
		s objMRLogDtlFinal=""
	}

	Set MRLogDtlFinalRowID=""
	Set MRLogDtlFinalRowID=$o(^DHCEPRFS.INST.MRLogDtlFinalI("IdxMain"," "_argMREpisodeID," ARRANGE",MRLogDtlFinalRowID))
	If MRLogDtlFinalRowID'=""
	{
		Set objMRLogDtlFinal=##Class(DHCEPRFS.INST.MRLogDtlFinal).%OpenId(MRLogDtlFinalRowID)
		Set ActPages=objMRLogDtlFinal.ActPages
		w "-ARRANGED objMRLogDtlFinal :",ActPages," ID  :"_MRLogDtlFinalRowID,!
		if (TrueActPages'=ActPages)
		{
			w "---Before Update, ActPages is "_objMRLogDtlFinal.ActPages,!
			Set objMRLogDtlFinal.ActPages=TrueActPages
			w "---Status: ", objMRLogDtlFinal.%Save(),!
			w "---after Update, ActPages is "_objMRLogDtlFinal.ActPages,!
		}
		d objMRLogDtlFinal.%Close()
		s objMRLogDtlFinal=""

	}
		
	Set ChildSub=""
	for
	{
		Set ChildSub=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",argMREpisodeID," SCAN",ChildSub),-1)
		Quit:ChildSub=""
		
		If ChildSub'=""
		{
			Set objMRLogDetail=##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(argMREpisodeID_"||"_ChildSub)
			Set ActPages=objMRLogDetail.ActPages
			w "-SCAN objMRLogDetail :",ActPages," ID :"_argMREpisodeID_"||"_ChildSub,!
			if (TrueActPages'=ActPages)
			{
				w "---Before Update, ActPages is "_objMRLogDetail.ActPages,!
				Set objMRLogDetail.ActPages=TrueActPages
				w "---Status: ", objMRLogDetail.%Save(),!
				w "---after Update, ActPages is "_objMRLogDetail.ActPages,!
			}
			d objMRLogDetail.%Close()
			s objMRLogDetail=""
		}
	}

	Set ChildSub=""
	for
	{
		Set ChildSub=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",argMREpisodeID," ARRANGE",ChildSub),-1)
		Quit:ChildSub=""
		
		If ChildSub'=""
		{
			Set objMRLogDetail=##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(argMREpisodeID_"||"_ChildSub)
			Set ActPages=objMRLogDetail.ActPages
			w "-ARRANGED objMRLogDetail :",ActPages," ID :"_argMREpisodeID_"||"_ChildSub,! 
			if (TrueActPages'=ActPages)
			{
				w "---Before Update, ActPages is "_objMRLogDetail.ActPages,!
				Set objMRLogDetail.ActPages=TrueActPages
				w "---Status: ", objMRLogDetail.%Save(),!
				w "---after Update, ActPages is "_objMRLogDetail.ActPages,!
			}
			d objMRLogDetail.%Close()
			s objMRLogDetail=""
		}
	}
	Quit
}

/// w ##Class(DHCEPRFS.Tool.UpdateData).UpdateActPageByDate("2015-01-21")
ClassMethod UpdateActPageByDate(argDate As %String) As %String
{
	//set actDate=$zdh(argDate,3)
	set actDate=$h-1
	Set count=0
	set actTime = ""
	for
	{
		Set actTime=$o(^DHCEPRFS.INST.MRLogDtlFinalI("IdxActDateTime",actDate,actTime))
		Quit:actTime=""
		
		Set Rowid=""
		for
		{
			Set Rowid=$o(^DHCEPRFS.INST.MRLogDtlFinalI("IdxActDateTime",actDate,actTime,Rowid))
			Quit:Rowid=""
			
			Set obj=##Class(DHCEPRFS.INST.MRLogDtlFinal).%OpenId(Rowid)
		
			//w "MREpisodeID: ",obj.MREpisodeID," TrueActpages :",..UpdateActPages(obj.MREpisodeID)
			s obj2=##Class(DHCEPRFS.INST.MREpisode).%OpenId(obj.MREpisodeID)
			continue:(obj2="")
			
			w "**********************************************************************",!
			w "  MedRecordNo : ",obj2.MedRecordNo
			d ..UpdateActPages(obj.MREpisodeID)
			d obj.%Close()
			Set obj=""
			
			d obj2.%Close()
			Set obj2=""
			
			Set count=count+1
			
			//b
		}
	}
	quit count
}

/// desc:把原在META.QueryUserCate中的Category信息，转储到META.QueryUserCateDetail中,1拆多行
/// w ##Class(DHCEPRFS.Tool.UpdateData).TransferUserCate2Detail()
/// SELECT sum((length(CateCode)-length(replace(catecode,'#','')))/2) FROM dhceprfs_meta.queryusercate 
/// WHERE QueryUserID IN (SELECT ID FROM  dhceprfs_meta.queryuser);
/// SELECT count(*) FROM dhceprfs_meta.queryusercatedetail 两个SQL验证是否插入数量与原数量相等
ClassMethod TransferUserCate2Detail() As %String
{
	s userRowID=""
	s i=0
	for {
		s userRowID = $o(^DHCEPRFS.META.QueryUserD(userRowID))
		q:(userRowID="")
		s i=i+1
		s cateRowID=""
		s cateRowID=$o(^DHCEPRFS.META.QueryUserCateI("IdxQueryUserID"," "_userRowID,""))
		continue:(cateRowID="")
		s objUserCate=##class(DHCEPRFS.META.QueryUserCate).%OpenId(cateRowID)
		s ret=##Class(DHCEPRFS.BL.BLQueryUser).AddUserCategoryDetail(objUserCate.CateCode,objUserCate.QueryUserID)
	}
	quit "OK"_i_"人"
}

/// desc:把原在META.QueryUserMedNO中的MedrecordNO信息，转储到META.QueryUserMedRecord中,1拆多行
/// w ##Class(DHCEPRFS.Tool.UpdateData).TransferUserMedRecordNO2New()
ClassMethod TransferUserMedRecordNO2New() As %String
{
	s userRowID=""
	s i=0
	for {
		s userRowID = $o(^DHCEPRFS.META.QueryUserD(userRowID))
		q:(userRowID="")
		s i=i+1
		s medNoRowID=""
		s medNoRowID=$o(^DHCEPRFS.META.QueryUserMedNoI("IdxQueryUserID"," "_userRowID,""))
		continue:(medNoRowID="")
		s objUserMedNo=##class(DHCEPRFS.META.QueryUserMedNo).%OpenId(medNoRowID)
		s ret=##Class(DHCEPRFS.BL.BLQueryUser).AddUserMed(objUserMedNo.MedNos,objUserMedNo.QueryUserID)
	}
	quit "OK"_i_"人"
}

/// Desc: 增加综合查询结果列、查询字段、查询分类
/// Debug: d ##Class(DHCEPRFS.Tool.UpdateData).AddResultColumn()
ClassMethod AddResultColumn()
{
	 //Add MedRecordFlowInfo QueryCategory
	s sc=$$InitOneQueryCategory("MedRecordFlowInfo","病案流通信息","5","Y")
	
	//Add QueryField
	s sc = $$InitOneQueryField("IsCreated", "已生成", "TXT", "", "MedRecordFlowInfo", "186", "Y")
	s sc = $$InitOneQueryField("IsScanned", "已扫描", "TXT", "", "MedRecordFlowInfo", "187", "Y")
	s sc = $$InitOneQueryField("IsHavePDF", "已有PDF", "TXT", "", "MedRecordFlowInfo", "188", "Y")
	
	//Add ResultColumn
	s sc=$$InitOneResultColumn("IsCreated", "已生成","Y")
	s sc=$$InitOneResultColumn("IsScanned", "已扫描","Y")
	s sc=$$InitOneResultColumn("IsHavePDF", "已有PDF","Y")
	
InitOneQueryCategory(argCategoryName,argCategoryDesc,argSequence,argIsActive)
	s rowid=""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryCategory
		where CategoryName = :argCategoryName)
	if (rowid = "")
	{
		&sql(INSERT INTO DHCEPRFS_META.QueryCategory(CategoryName,CategoryDesc,Sequence,IsActive) 
			VALUES (:argCategoryName,:argCategoryDesc,:argSequence,:argIsActive))
	}
	q "1"
InitOneResultColumn(argColName,argColDesc,argIsActive)
	s rowid=""
	&sql(select ID into :rowid from DHCEPRFS_META.ResultColumn
		where ColName = :argColName)
	if (rowid = "")
	{
		&sql(INSERT INTO DHCEPRFS_META.ResultColumn(ColName,ColDesc,IsActive) 
			VALUES (:argColName,:argColDesc,:argIsActive))
	}
	q "1"
	
InitOneQueryField(argFieldName,argFieldDesc,argFieldType,argFieldInterface,argCategoryName,argSequence,argIsActive)
	s categoryID = ""
	&sql(select ID into :categoryID from DHCEPRFS_META.QueryCategory
		where CategoryName = :argCategoryName)
	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryFields
		where FieldName = :argFieldName)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.QueryFields (FieldName,FieldDesc,FieldType,FieldInterface,CategoryID,Sequence,IsActive) 
			values (:argFieldName,:argFieldDesc,:argFieldType,:argFieldInterface,:categoryID,:argSequence,:argIsActive))
	}
	
	q "1"
}

/// Desc: 更新基础数据生命周期配置表的字段
/// Debug: d ##class(DHCEPRFS.Tool.UpdateData).UpdateMetaLCFields()
ClassMethod UpdateMetaLCFields()
{
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.SysOption","OptionDesc,OptionName,OptionType,OptionValue")
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.MRAction","ActionCode,ActionName,CategoryCode,CategoryName,IsActive,OrderNo")
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.RecordCheck","CheckDesc,CheckName,CheckType,CheckURL,IsValid,Sequence")
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.CTItemType","TypeCode,TypeName,TypeDesc,CSPPath,Sequence,InvokeType,ProductSource")
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.MRItem","Name,Code,Description,MRSubCategoryID,Type,TypeParams,Source,Sequence,Attachment,AttachType")
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.MRCategory","Name,Code,Description,Sequence")
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.MRSubCategory","Name,Code,Description,MRCategoryID,Sequence,TypeParam")
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.MRStatus","StatusCode,StatusName,IsActive")
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.MRTransition","PrevStatusCode,ActionCode,PostStatusCode,IsActive")
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.MRChargeType","ChargeTypeCode,ChargeTypeName")
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.PrintScheme","SchemeName,SchemeDesc,SchemeType,SchemeOrder,SchemeItems,IsDefault,IsCreate,CreateUserID,CreateDate,CreateTime,ModifyUserID,ModifyDate,ModifyTime,CheckItems,IsAvailable")
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.QRCodeInfo","Name,Description,ClassName,ClassProperty,ClassPropertyType,Enable,Sequence,CustemNoteInfo")
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.QueryFunction","FuncName,FuncDesc,ParentID,Notes,IsAvailable")
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.EstimatePagesItem","ItemCode,ItemName,ItemDesc,TypeParam,Type,Available,Sequence,RelatedItems")
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.FileStoreConfig","StartDate,EndDate,FileServerIP,VirtualDir,NameSpace")
UpdateMetaLCFields(argTableName,argFields)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.ConfigMetaLC
		where TableName = :argTableName)
	
	w !,rowid
	if (rowid '= "")
	{
		&sql(update DHCEPRFS_META.ConfigMetaLC set Fields = :argFields 
			where TableName = :argTableName)
	}
	q "1"
}

/// Desc: 更新基础数据生命周期配置表
/// Debug: d ##class(DHCEPRFS.Tool.UpdateData).UpdateConfigMetaLC()
ClassMethod UpdateConfigMetaLC()
{
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.CTItemInvokeType","归档项目生成调用方式","DHCEPRFS.BL.BLMetaLCQuery","GetCTItemInvokeType","Y","InvokeTypeCode,InvokeTypeName")
	
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.CTItemType","TypeCode,TypeName,TypeDesc,CSPPath,Sequence,ProductSource,InvokeType,TypeURL,TypeClass,TypeMethod,TypeFTPConfig,TypeNote,TypeFlag,CreateType,Company,ProductTeam,CreateTypeSub")
	
InitConfigMetaLC(argTableName,argConfigName,argClassName,argQueryFunction,argIsActive,argFields)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.ConfigMetaLC
		where TableName = :argTableName)
	
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.ConfigMetaLC (TableName,ConfigName,ClassName,QueryFunction,IsActive,Fields) 
			values (:argTableName, :argConfigName, :argClassName, :argQueryFunction, :argIsActive, :argFields))
	}
	
	q "1"
UpdateMetaLCFields(argTableName,argFields)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.ConfigMetaLC
		where TableName = :argTableName)
	
	w !,rowid
	if (rowid '= "")
	{
		&sql(update DHCEPRFS_META.ConfigMetaLC set Fields = :argFields 
			where TableName = :argTableName)
	}
	q "1"
}

/// Desc: 更新基础数据生命周期配置表
/// Debug: d ##class(DHCEPRFS.Tool.UpdateData).UpdateConfigMetaLCV2()
ClassMethod UpdateConfigMetaLCV2()
{
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.CustomDic","自定义字典","DHCEPRFS.BL.BLMetaLCQuery","GetCustomDic","Y","CtmDictCode,CtmDictDesc,CtmDictAlias,CtmDictType,CtmIsActive,CtmIndex")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.QueryFields","归档查询字段","DHCEPRFS.BL.BLMetaLCQuery","GetQueryFields","Y","FieldName,FieldDesc,FieldType,FieldInterface,CategoryID,Sequence,IsActive")
	s sc=$$InitConfigMetaLC("DHCEPRFS.META.ResultColumn","综合查询结果列","DHCEPRFS.BL.BLMetaLCQuery","GetResultColumn","Y","ColDesc,ColName,IsActive")
	
	s sc=$$UpdateMetaLCFields("DHCEPRFS.META.MRItem","Name,Code,Description,MRSubCategoryID,Type,TypeParams,Source,Sequence,Attachment,AttachType,SubFlag")
	
InitConfigMetaLC(argTableName,argConfigName,argClassName,argQueryFunction,argIsActive,argFields)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.ConfigMetaLC
		where TableName = :argTableName)
	
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.ConfigMetaLC (TableName,ConfigName,ClassName,QueryFunction,IsActive,Fields) 
			values (:argTableName, :argConfigName, :argClassName, :argQueryFunction, :argIsActive, :argFields))
	}
	
	q "1"
UpdateMetaLCFields(argTableName,argFields)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.ConfigMetaLC
		where TableName = :argTableName)
	
	w !,rowid
	if (rowid '= "")
	{
		&sql(update DHCEPRFS_META.ConfigMetaLC set Fields = :argFields 
			where TableName = :argTableName)
	}
	q "1"
}

/// d ##Class(DHCEPRFS.Tool.UpdateData).AddOldCreateByDate("2016-11-1","2016-11-1")
/// Desc: 将单项生成的就诊号加入老病历生成队列
ClassMethod AddOldCreateByDate(AStartDate As %String, AEndDate As %String) As %String
{
	s result = ""
	s AStartDate = $zdh(AStartDate,3)
	s AEndDate = $zdh(AEndDate,3)
	if ((AStartDate '= "") && (AEndDate '= ""))
	{
		s DisDate = AStartDate - 1
		for {
			s DisDate = $o(^PAADMi("DischDate",DisDate))
			q:(DisDate = "")
			q:(DisDate > AEndDate)
			
			s PAADMRowID = ""
			for {	
				s PAADMRowID = $o(^PAADMi("DischDate",DisDate,PAADMRowID))
				q:(PAADMRowID = "")
				s PAAdmType = $p($g(^PAADM(PAADMRowID)),"^",2)
				//判断是否是"住院"
				if (PAAdmType = "I")
				{
					s ret = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).CheckEpisodeCancel(PAADMRowID)
					//"0"代表未取消，"1"代表取消
					if (ret = "0")
					{
						//d ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishTemp01(PAADMRowID)
						d ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus4OLD(PAADMRowID,"CREATETEMP01")
						w !,PAADMRowID
					}						
				}				
			}
		}	
	}
}

/// d ##Class(DHCEPRFS.Tool.UpdateData).AddHasANCreateByDate("2016-11-1","2016-11-1")
/// Desc: 将温岭漏掉的麻醉单重新单项生成
ClassMethod AddHasANCreateByDate(AStartDate As %String, AEndDate As %String) As %String
{
	s sysCode = "DHC"
	s priority = "50"
	s AStartDate = $zdh(AStartDate,3)
	s AEndDate = $zdh(AEndDate,3)
	for succeedDate = AStartDate:1:AEndDate
	{
		s succeedTime = ""
		for {
			s succeedTime = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxSucceedDateTime",succeedDate,succeedTime))
			q:(succeedTime="")
			s rowID = ""
			for {
				s rowID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxSucceedDateTime",succeedDate,succeedTime,rowID))
				q:(rowID ="")
				s obj = ##class(DHCEPRFS.INST.AdmTaskSucceed).%OpenId(rowID)
				s episodeID = obj.EpisodeID
				//判断是否有麻醉单
				s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasANToPrint(episodeID)
				continue:(detailInfo < 1)
				s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create(sysCode, episodeID, priority, "CREATETEMP02","","")
				w !,episodeID
			}
		}
	}
}

}

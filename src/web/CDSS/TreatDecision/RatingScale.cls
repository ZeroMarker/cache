/// Description: CDSS客户端推荐评估量表方法集合
/// Creator: 范文凯
/// Date: 2020-02-19
Class web.CDSS.TreatDecision.RatingScale Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：范文凯
/// CreatDate: 2020-02-25
/// Description：保存数据 患者评估量表记录表
/// Table：WDT.CDSS.PatientRatingScale
/// Other: w ##class(web.DHCBL.CDSS.DHCDSSTreatmentDecision).SaveRatingData("1","","","","","10","")
ClassMethod SaveRatingData(PatientUserInfo As %String, Score As %String, Result As %String, Allvalue As %String, Grade As %String, MKBAssid As %String, Remarks As %String)
{
	s IDNO = $p(PatientUserInfo,"^",1)
	s PatientDR = $p(PatientUserInfo,"^",2)
	s VisitID = $p(PatientUserInfo,"^",3)
	s VisitType = $p(PatientUserInfo,"^",4)
	s UserName=$p(PatientUserInfo,"^",6)
	s CTLocDesc = $p(PatientUserInfo,"^",8)
	
	if IDNO'=""
	{
		//s RsDictID = $o(^WDT.CDSS.RatingScaleDictI("MKBAssDRIndex",MKBAssid,0))
		s obj=##class(WDT.CDSS.PatientRatingScale).%New()
		s obj.IDNO=IDNO
		s obj.PatientDR = PatientDR
		s obj.RatingDate = $ZDATETIME($H,3)
		s obj.VisitID = VisitID
		s obj.VisitType =VisitType
		s obj.RatingScaleNO = 1
		s obj.RatingRemarks = Remarks
		s obj.RatingScore = Score
		s obj.RatingDesc = Result
		s obj.RatingRank = Grade
		s obj.RatingValue  = Allvalue
		s obj.RatingUser = UserName
		s obj.RatingDept = CTLocDesc
		//d obj.RatingScaleDictDRSetObjectId(RsDictID)
		d obj.RatingScaleDictDRSetObjectId(MKBAssid)
		Ts
		s sc=obj.%Save()
		s id=obj.%Id()
		If $$$ISOK(sc)
		{
			d obj.%Close()
			s PMobj=##class(WDT.CDSS.PatPMTypeIndex).%New()
			s PMobj.IDNO=IDNO
			s PMobj.PatientDR=PatientDR
			s PMobj.VisitID=VisitID
			s PMobj.VisitType=VisitType
			s PMobj.DataType="评估表"
			s PMobj.IsLastUpdate=1
			d PMobj.%Save()
			d PMobj.%Close()
			Tc
			d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientUserInfo)
			//s result = "{success:'true'}" //
			s result="[{id:'"_id_"',desc:'疼痛评定量表',date:'2020-03-25',score:'"_Score_"',result:'"_Result_"'}]"
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s ^TMP("FWKRes") = result
		}
	}
	q result
}

ClassMethod DeleteRatingData(id As %String, PatientUserInfo As %String) As %String
{
	s sc = ##class(WDT.CDSS.PatientRatingScale).%DeleteId(id)
	s IDNO = $p(PatientUserInfo,"^",1)
	s PatientDR = $p(PatientUserInfo,"^",2)
	s VisitID = $p(PatientUserInfo,"^",3)
	s VisitType = $p(PatientUserInfo,"^",4)
	if $$$ISOK(sc)
	{
		s PMobj=##class(WDT.CDSS.PatPMTypeIndex).%New()
		s PMobj.IDNO=IDNO
		s PMobj.PatientDR=PatientDR
		s PMobj.VisitID=VisitID
		s PMobj.VisitType=VisitType
		s PMobj.DataType="评估表"
		s PMobj.IsLastUpdate=1
		d PMobj.%Save()
		d PMobj.%Close()
		d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientUserInfo)
		q "Y"
	}
	else
	{
		q "N"
	}
}

/// Creator：范文凯
/// CreatDate: 2020-03-02
/// Description：患者评估记录表的修改
/// Table：WDT.CDSS.RatingScaleDict  WDT.CDSS.PatientRatingScale
/// Input: PatientID(患者主索引) Score(评估表分数) Result(评估表结果)  Allvalue(评估表详细记录) Grade(评估表等级)  MKBAssid(知识库评估表ID)  Remarks(评估表备注描述)
/// Ouput: 保存成功返回成功的json串 失败返回失败json串并提示错误原因
/// Other: w ##class(web.DHCBL.CDSS.DHCDSSTreatmentDecision).EditRatingScale()
ClassMethod EditRatingScale(PatientID As %String, Score As %String, Result As %String, Allvalue As %String, Grade As %String, MKBAssid As %String, Remarks As %String, TableID As %String)
{
	/*if TableID = ""
	{
		s result = "{success:'false',errorinfo:'未指定评估记录表'}"  //返回错误信息
	}*/
	if PatientID'=""
	{
		//s RsDictID = $o(^WDT.CDSS.RatingScaleDictI("MKBAssDRIndex",MKBAssid,0))
		s TableID = $e(TableID,10,*)
		s obj=##class(WDT.CDSS.PatientRatingScale).%OpenId(TableID)
		s obj.RatingDate = $ZDATETIME($H,3) 
		s obj.RatingRemarks = Remarks
		s obj.RatingScore = Score
		s obj.RatingDesc = Result
		s obj.RatingRank = Grade
		s obj.RatingValue  = Allvalue
		Ts
		s sc=obj.%Save()
		s id=obj.%Id()
		If $$$ISOK(sc)
		{
			d obj.%Close()
			/*s eobj = ##class(WDT.CDSS.Assessment).%New()
			d eobj.PatientRSDRSetObjectId(id)
			s eobj.DHCDSSAValue =Allvalue
			s eobj.DHCDSSAScore =Score
			s eobj.DHCDSSADesc = Result
			s eobj.DHCDSSARank = Grade
			d eobj.%Save()
			d eobj.%Close()*/
			
			Tc
			//s result = "{success:'true'}" //
			s result="[{id:'"_id_"',desc:'疼痛评定量表',date:'2020-03-25',score:'"_Score_"',result:'"_Result_"'}]"
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	q result
}

ClassMethod EditRatingData(PatientUserInfo As %String, Score As %String, Result As %String, Allvalue As %String, Grade As %String, MKBAssid As %String, Remarks As %String, TableID As %String)
{
    s IDNO = $p(PatientUserInfo,"^",1)
	s PatientDR = $p(PatientUserInfo,"^",2)
	s VisitID = $p(PatientUserInfo,"^",3)
	s VisitType = $p(PatientUserInfo,"^",4)
	s UserName=$p(PatientUserInfo,"^",6)
	if IDNO'=""
	{
		s TableID = $e(TableID,10,*)
		s obj=##class(WDT.CDSS.PatientRatingScale).%OpenId(TableID)
		s obj.RatingDate = $ZDATETIME($H,3) 
		s obj.RatingRemarks = Remarks
		s obj.RatingScore = Score
		s obj.RatingDesc = Result
		s obj.RatingRank = Grade
		s obj.RatingUser = UserName
		s obj.RatingValue  = Allvalue
		Ts
		s sc=obj.%Save()
		s id=obj.%Id()
		If $$$ISOK(sc)
		{
			d obj.%Close()
			s PMobj=##class(WDT.CDSS.PatPMTypeIndex).%New()
			s PMobj.IDNO=IDNO
			s PMobj.PatientDR=PatientDR
			s PMobj.VisitID=VisitID
			s PMobj.VisitType=VisitType
			s PMobj.DataType="评估表"
			s PMobj.IsLastUpdate=1
			d PMobj.%Save()
			d PMobj.%Close()
			Tc
			d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientUserInfo)
			//s result = "{success:'true'}" //
			s result="{""id"":"""_id_""",""desc"":""疼痛评定量表"",""date"":""2020-03-25"",""score"":"""_Score_""",""result"":"""_Result_"""}"
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	q result
}

/// Creator:范文凯
/// CreatDate:2021-03-07
/// Description：提供CDSS2.0用户检索历史频次接口
/// Other: w ##class(web.CDSS.TreatDecision.RatingScale).GetDataForHistory("WKTest^WKTest^1^住院^6495^范文凯^111^信息部^1","User.MKBTerm120")
/// Creator:范文凯
/// CreatDate:2021-02-03
/// Description：提供CDSS2.0评估记录接口
/// Other: w ##class(web.CDSS.TreatDecision.RatingScale).GetPatientRatingScale("51074340^09966417^1^住院^5599^医生01^91109^JJYQXEHXMYKYLDY-锦江院区小儿呼吸免疫科医疗单元^1")
ClassMethod GetPatientRatingScale(PatientUserInfo As %String) As %String
{
	new (PatientUserInfo)
	s Config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416")
    s:Config="" Config = "1"
	s IDNO = $p(PatientUserInfo,"^",1)
	s PatientDR = $p(PatientUserInfo,"^",2)
	s VisitID = $p(PatientUserInfo,"^",3)
	s VisitType = $p(PatientUserInfo,"^",4)
	s UserName=$p(PatientUserInfo,"^",6)
	s RatingScaleID=""
	s jsonInfo = "["
	s RatingScaleIDStr = ""
	s TableDate1 = ""
	for
	{
		s resultinfo = "["
	    //日期索引
	    if ((Config=1)&(PatientDR'="")&(VisitID'=""))
	    {
		    s TableDate1 = $o(^WDT.CDSS.PatientRatingScaleI("RatingScaleIndex",PatientDR,VisitID," "_VisitType,TableDate1),-1)
			q:TableDate1=""
			s TableID1 = $o(^WDT.CDSS.PatientRatingScaleI("RatingScaleIndex",PatientDR,VisitID," "_VisitType,TableDate1,0))
			q:TableID1=""
			s RatingScaleDictDR1 = $lg($g(^WDT.CDSS.PatientRatingScaleD(TableID1)),7)
			if (RatingScaleIDStr'[RatingScaleDictDR1)
			{
				s RatingScaleIDStr = RatingScaleIDStr_","_RatingScaleDictDR1
				s RatingScaleName = $LISTGET($G(^CT.WDT.CDSS.AssBaseD(RatingScaleDictDR1)),3)
				s info = ..GetOneRatingScale(PatientUserInfo,RatingScaleDictDR1)
				s resultinfo = resultinfo_info_"]"
				//s jsonInfo =jsonInfo_"""Name""":_RatingScaleName_","""List"""":"_resultinfo_","
				s jsonInfo = jsonInfo_"{""Name"":"""_RatingScaleName_""",""ID"":"""_RatingScaleDictDR1_""",""List"":"_resultinfo_"},"
		    }
	    }
	    else
	    {
		    s TableDate1 = $o(^WDT.CDSS.PatientRatingScaleI("IDNORDateIndex",IDNO,TableDate1),-1)
			q:TableDate1=""
			s TableID1 = $o(^WDT.CDSS.PatientRatingScaleI("IDNORDateIndex",IDNO,TableDate1,0))
			q:TableID1=""
			s RatingScaleDictDR1 = $lg($g(^WDT.CDSS.PatientRatingScaleD(TableID1)),7)
			if (RatingScaleIDStr'[RatingScaleDictDR1)
			{
				s RatingScaleIDStr = RatingScaleIDStr_","_RatingScaleDictDR1
				s RatingScaleName = $LISTGET($G(^CT.WDT.CDSS.AssBaseD(RatingScaleDictDR1)),3)
				s info = ..GetOneRatingScale(PatientUserInfo,RatingScaleDictDR1)
				s resultinfo = resultinfo_info_"]"
				//s jsonInfo =jsonInfo_"""Name""":_RatingScaleName_","""List"""":"_resultinfo_","
				s jsonInfo = jsonInfo_"{""Name"":"""_RatingScaleName_""",""ID"":"""_RatingScaleDictDR1_""",""List"":"_resultinfo_"},"
		    }
		}
	}
	s jsonInfo = $e(jsonInfo,0,*-1)
	if (jsonInfo '= "")
	{
		q jsonInfo_"]"
	}
	else
	{
		q "[]"
	}
}

/// Creator:范文凯
/// CreatDate:2021-02-03
/// Description：提供CDSS2.0评估记录接口
/// Other: w ##class(web.CDSS.TreatDecision.RatingScale).GetPatientRatingScale()
ClassMethod GetOneRatingScale(PatientUserInfo As %String, RecordID As %String) As %String
{
	s Config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416")
    s:Config="" Config = "1"
	s IDNO = $p(PatientUserInfo,"^",1)
	s PatientDR = $p(PatientUserInfo,"^",2)
	s VisitID = $p(PatientUserInfo,"^",3)
	s VisitType = $p(PatientUserInfo,"^",4)
	s UserName=$p(PatientUserInfo,"^",6)
	//入参为患者索引号
	s json=""
	s TableID=""
	s TableDate=""
	if ((Config=1)&(PatientDR'="")&(VisitID'=""))
	{
		s num = 0
		for
		{
			s TableDate = $o(^WDT.CDSS.PatientRatingScaleI("RatingScaleIndex",PatientDR,VisitID," "_VisitType,TableDate),-1)
			q:TableDate=""
			s TableID = $o(^WDT.CDSS.PatientRatingScaleI("RatingScaleIndex",PatientDR,VisitID," "_VisitType,TableDate,0))
			if (RecordID'="")
			{
				s RatingScaleDictDR = $lg($g(^WDT.CDSS.PatientRatingScaleD(TableID)),7)
				continue:RecordID'=RatingScaleDictDR	
			}
			s showdata =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml($p($LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),8),",",1))
			s MKBAssBaseID = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),7)        //获得字典表的ID
			continue:MKBAssBaseID="" 
			if (MKBAssBaseID'="")
			{
				s MKBAssName = $LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBAssBaseID)),3)
				s NameLe = $l(MKBAssName)
				if (NameLe>14)
				{
					s MKBAssName = $e(MKBAssName,0,14)_"<br>"_$e(MKBAssName,15,*)
				}
				
			}
			else
			{
				s MKBAssName ="表名为空"
			}
			s score = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),12)
			s result = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),13)
			s remarks = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),11)
			s RatingUser = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),9)
			s allvalue = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),15)
	        s json=json_"{""score"":"""_score_""",""result"":"""_result_""",""remarks"":"""_remarks_""",""RatingUser"":"""_RatingUser_""",""showdata"":"""_showdata_""",""TableID"":"""_TableID_""",""allvalue"":"""_allvalue_"""},"
		}
	}
	else
	{
		s num = 0
		for
		{
			s TableDate = $o(^WDT.CDSS.PatientRatingScaleI("IDNORDateIndex",IDNO,TableDate),-1)
			q:TableDate=""
			s TableID = $o(^WDT.CDSS.PatientRatingScaleI("IDNORDateIndex",IDNO,TableDate,0))
			if (RecordID'="")
			{
				s RatingScaleDictDR = $lg($g(^WDT.CDSS.PatientRatingScaleD(TableID)),7)
				continue:RecordID'=RatingScaleDictDR	
			}
			s showdata =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml($p($LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),8),",",1))
			s MKBAssBaseID = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),7)        //获得字典表的ID
			continue:MKBAssBaseID="" 
			if (MKBAssBaseID'="")
			{
				s MKBAssName = $LISTGET($G(^CT.WDT.CDSS.AssBaseD(MKBAssBaseID)),3)
				s NameLe = $l(MKBAssName)
				if (NameLe>14)
				{
					s MKBAssName = $e(MKBAssName,0,14)_"<br>"_$e(MKBAssName,15,*)
				}
				
			}
			else
			{
				s MKBAssName ="表名为空"
			}
			s score = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),12)
			s result = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),13)
			s remarks = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),11)
			s RatingUser = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),9)
			s allvalue = $LISTGET($G(^WDT.CDSS.PatientRatingScaleD(TableID)),15)
	        s json=json_"{""score"":"""_score_""",""result"":"""_result_""",""remarks"":"""_remarks_""",""RatingUser"":"""_RatingUser_""",""showdata"":"""_showdata_""",""TableID"":"""_TableID_""",""allvalue"":"""_allvalue_"""},"
		}
	}
	s json = $e(json,0,*-1)
	q json
}

/// Creator:范文凯
/// CreatDate:2021-03-07
/// Description：提供CDSS2.0用户检索历史频次接口
/// Other: w ##class(web.CDSS.TreatDecision.RatingScale).GetDataForHistory("502^0000000258^1^住院^12175^医生01^ZYZY003^内分泌科^1","User.MKBTerm120")
ClassMethod GetDataForHistory(PatientInfo, tablename) As %String
{
	s BDPDAHUserID = $p(PatientInfo,"^",5)
	//s BDPDAHUserID = "6477" 
	s BDPCTLocDRID = $p(PatientInfo,"^",7)
	s combolimit=10,count=0	
	s QFlag = "false"
	s BDPDAFFrequency=""
	s jsonInfo = "["
	for
	{
		//Index TableLocUserFreqIdx On (BDPDAFTableName, BDPCTLocDR, BDPDAFUserID, BDPDAFFrequency);
		s BDPDAFFrequency = $o(^WDT.CDSS.DataFrequencyI("TableLocUserFreqIdx"," "_$ZCONVERT(tablename,"U"),BDPCTLocDRID,BDPDAHUserID,BDPDAFFrequency),-1) q:BDPDAFFrequency="" 
		//s BDPDAHDate=$o(^User.BDPDataHistoryI("TableUserDateIdx"," "_$ZCONVERT(tablename,"U"),BDPDAHUserID,BDPDAHDate),-1) q:BDPDAHDate="" 
		//q:BDPDAHDate=""
		q:QFlag="true"
		s RowId=""
		for
		{
			s RowId=$o(^WDT.CDSS.DataFrequencyI("TableLocUserFreqIdx"," "_$ZCONVERT(tablename,"U"),BDPCTLocDRID,BDPDAHUserID,BDPDAFFrequency,RowId),-1) q:RowId="" 
			s Desc=$listget($g(^WDT.CDSS.DataFrequencyD(RowId)),4)        /// 对应表数据描述 节点 4
			s ID=$listget($g(^WDT.CDSS.DataFrequencyD(RowId)),3)          /// 对应表数据ID 节点 3  BDPDAFDataReference 
			//s BDPDAFFrequency=$listget($g(^WDT.CDSS.DataFrequencyD(RowId)),5)
			s count=count+1
			s jsonInfo = jsonInfo_"{""Desc"":"""_Desc_""",""BDPDAFFrequency"":"""_BDPDAFFrequency_""",""ID"":"""_ID_"""},"
			if (count>combolimit)
			{
				s QFlag ="true"
				q 
			}
		}
				
	}
	s jsonInfo = $e(jsonInfo,0,*-1)
	if (jsonInfo '= "")
	{
		q jsonInfo_"]"
	}
	else
	{
		q "[]"
	}
}

/// Creator:dingyanan
/// CreatDate:2020-04-20
/// Description：获取患者家族史信息表信息 
/// Table：WDT.CDSS.FamilyHisInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型 Config配置信息（确定取数据的方式）
/// Output：按照固定格式返回患者家族史信息表的时间、名称、id
/// w ##class(web.CDSS.TreatDecision.RatingScale).GetFamilyHisInfoForEcharts("51074340^09966417^1^住院^5599^医生01^91109^JJYQXEHXMYKYLDY-锦江院区小儿呼吸免疫科医疗单元^1")
ClassMethod GetFamilyHisInfoForEcharts(PatientUserInfo As %String) As %String
{
	s IDNO = $p(PatientUserInfo,"^",1)
	s PatientDR = $p(PatientUserInfo,"^",2)
	s Config=1
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s FamilyHisInfo="",HisInfo=""
	if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
	{	
		s Relationship=0
		for
		{
			s Relationship =$o(^WDT.CDSS.FamilyHisInfoI("PatDRRelationIndex",PatientDR,Relationship)) q:Relationship=""
			s FamilyHisIDs="",GeneticDiseNames="",ProjectDataNames=""
			s FamilyHisID=0
			for
			{
				s FamilyHisID =$o(^WDT.CDSS.FamilyHisInfoI("PatDRRelationIndex",PatientDR,Relationship,FamilyHisID)) q:FamilyHisID=""
				s Relationship=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),4)
				s RelativeName=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),5)
				s GeneticDiseName=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),7)
				s ProjectDataName=##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(GeneticDiseName,"诊断")
				
				s:FamilyHisIDs'="" FamilyHisIDs=FamilyHisIDs_","_FamilyHisID
				s:FamilyHisIDs="" FamilyHisIDs=FamilyHisID
				s:GeneticDiseNames'="" GeneticDiseNames=GeneticDiseNames_","_GeneticDiseName
				s:GeneticDiseNames="" GeneticDiseNames=GeneticDiseName
				s:ProjectDataNames'="" ProjectDataNames=ProjectDataNames_","_$SELECT(ProjectDataName="":GeneticDiseName,1:ProjectDataName)
				s:ProjectDataNames="" ProjectDataNames=$SELECT(ProjectDataName="":GeneticDiseName,1:ProjectDataName)
			}	
			s HisInfo="{""FamilyHisID"":"""_FamilyHisIDs_""",""Relationship"":"""_Relationship_""",""RelativeName"":"""_RelativeName_""",""GeneticDiseName"":"""_GeneticDiseNames_""",""ProjectDataName"":"""_ProjectDataNames_"""}"	
			if (FamilyHisInfo="")
			{
				s FamilyHisInfo=HisInfo
			}
			else
			{
				s FamilyHisInfo=FamilyHisInfo_","_HisInfo
			}
			
		}
		
	}
	elseif (IDNO'="")  //患者主索引
	{
		s Relationship=0
		for
		{
			s Relationship =$o(^WDT.CDSS.FamilyHisInfoI("IDNORelationIndex",IDNO,Relationship)) q:Relationship=""
			s FamilyHisIDs="",GeneticDiseNames="",ProjectDataNames=""
			s FamilyHisID=0
			for
			{
				s FamilyHisID =$o(^WDT.CDSS.FamilyHisInfoI("IDNORelationIndex",IDNO,Relationship,FamilyHisID)) q:FamilyHisID=""
				s Relationship=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),4)
				s RelativeName=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),5)
				s GeneticDiseName=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),7)
				s ProjectDataName=##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(GeneticDiseName,"诊断")
				
				s:FamilyHisIDs'="" FamilyHisIDs=FamilyHisIDs_","_FamilyHisID
				s:FamilyHisIDs="" FamilyHisIDs=FamilyHisID
				s:GeneticDiseNames'="" GeneticDiseNames=GeneticDiseNames_","_GeneticDiseName
				s:GeneticDiseNames="" GeneticDiseNames=GeneticDiseName
				s:ProjectDataNames'="" ProjectDataNames=ProjectDataNames_","_$SELECT(ProjectDataName="":GeneticDiseName,1:ProjectDataName)
				s:ProjectDataNames="" ProjectDataNames=$SELECT(ProjectDataName="":GeneticDiseName,1:ProjectDataName)
			}	
			s HisInfo="{""FamilyHisID"":"""_FamilyHisIDs_""",""Relationship"":"""_Relationship_""",""RelativeName"":"""_RelativeName_""",""GeneticDiseName"":"""_GeneticDiseNames_""",""ProjectDataName"":"""_ProjectDataNames_"""}"	
			if (FamilyHisInfo="")
			{
				s FamilyHisInfo=HisInfo
			}
			else
			{
				s FamilyHisInfo=FamilyHisInfo_","_HisInfo
			}
			
		}
	}
	return "["_FamilyHisInfo_"]"
}

/// Creator: 范文凯
/// CreatDate: 2021-04-01
/// Description：获取该患者的既往史概述
/// Table：WDT.CDSS.PatientRatingScale
/// Other: w ##class(web.CDSS.TreatDecision.RatingScale).GetPastDiagForEcharts("WKTest1^WKTest1^1^住院^6465^丁亚男^111^信息部^1","")
ClassMethod GetPastDiagForEcharts(PatientInfo As %String) As %String
{
	if ($l(PatientInfo,"^")'=9)
	{
		q " "
	}
	s IDNO = $p(PatientInfo,"^",1)
	s PatientDR = $p(PatientInfo,"^",2)
	s VisitID = $p(PatientInfo,"^",3)
	s VisitType = $p(PatientInfo,"^",4)
	s Config = $p(PatientInfo,"^",9)
	if (Config)
	{	
		s TableID = $o(^WDT.CDSS.PatientVisitI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,""))
	}
	else
	{
		s TableID = $o(^WDT.CDSS.PatientVisitI("IDNOIndex"," "_IDNO,""))
	}
	q:TableID="" ""
	s PastInfo = $lg($g(^WDT.CDSS.PatientVisitD(TableID)),14)
	if (PastInfo = "")
	{
		q " "
	}
	else
	{
		q PastInfo
	}
}

/// Creator: 范文凯
/// CreatDate: 2021-04-01
/// Description：获取该患者的个人史概述
/// Table：WDT.CDSS.PatientRatingScale
/// Other: w ##class(web.CDSS.TreatDecision.RatingScale).GetPersonInfoForEcharts("WKTest1^WKTest1^1^住院^6465^丁亚男^111^信息部^1")
ClassMethod GetPersonInfoForEcharts(PatientInfo As %String) As %String
{
    if ($l(PatientInfo,"^")'=9)
	{
		q " "
	}
	s IDNO = $p(PatientInfo,"^",1)
	s PatientDR = $p(PatientInfo,"^",2)
	s VisitID = $p(PatientInfo,"^",3)
	s VisitType = $p(PatientInfo,"^",4)
	s Config = $p(PatientInfo,"^",9)
	if (Config)
	{	
		s TableID = $o(^WDT.CDSS.PatientVisitI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,""))
	}
	else
	{
		s TableID = $o(^WDT.CDSS.PatientVisitI("IDNOIndex"," "_IDNO,""))
	}
	q:TableID="" ""
	s PastInfo = $lg($g(^WDT.CDSS.PatientVisitD(TableID)),16)
	if (PastInfo = "")
	{
		q " "
	}
	else
	{
		q PastInfo
	}
}

/// Creator: 范文凯
/// CreatDate: 2021-04-01
/// Description：获取该患者的婚育史概述
/// Table：WDT.CDSS.PatientRatingScale
/// Other: w ##class(web.CDSS.TreatDecision.RatingScale).GetMarryInfoForEcharts("WKTest1^WKTest1^1^住院^6465^丁亚男^111^信息部^1")
ClassMethod GetMarryInfoForEcharts(PatientInfo As %String) As %String
{
	if ($l(PatientInfo,"^")'=9)
	{
		q " "
	}
	s IDNO = $p(PatientInfo,"^",1)
	s PatientDR = $p(PatientInfo,"^",2)
	s VisitID = $p(PatientInfo,"^",3)
	s VisitType = $p(PatientInfo,"^",4)
	s Config = $p(PatientInfo,"^",9)
	if (Config)
	{	
		s TableID = $o(^WDT.CDSS.PatientVisitI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,""))
	}
	else
	{
		s TableID = $o(^WDT.CDSS.PatientVisitI("IDNOIndex"," "_IDNO,""))
	}
	q:TableID="" ""
	s PastInfo = $lg($g(^WDT.CDSS.PatientVisitD(TableID)),17)
	if (PastInfo = "")
	{
		q " "
	}
	else
	{
		q PastInfo
	}
}

/// Creator: 范文凯
/// CreatDate: 2021-10-08
/// Description：获取该患者PatientViewJson
/// Table：WDT.CDSS.PatientRatingScale
/// Other: w ##class(web.CDSS.TreatDecision.RatingScale).GetPatientViewJson("12^0000000018^1^住院^18732^孟玉秀^ZYZY003^内分泌科^1")
ClassMethod GetPatientViewJson(PatientInfo As %String) As %String
{
	q:$l(PatientInfo,"^")'=9 "{}"
	q:PatientInfo="" "{}"
    s BasicJson={}
	d BasicJson.%Set("Sex",##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^性别"))
	d BasicJson.%Set("Symptom",##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^症状"))
	d BasicJson.%Set("Temperature",##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^体温"))
	d BasicJson.%Set("BloodPressure",##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^血压"))
	d BasicJson.%Set("HeartRate",##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^脉搏"))
	d BasicJson.%Set("Breathe",##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^呼吸"))
	d BasicJson.%Set("BloodOxygen",##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^血氧饱和度"))
	d BasicJson.%Set("PersonalInfo",..GetPersonInfoForEcharts(PatientInfo))
	d BasicJson.%Set("FamilyHisInfo",..GetFamilyHisInfoForEcharts(PatientInfo))
	d BasicJson.%Set("PastDiag",..GetPastDiagForEcharts(PatientInfo))
	d BasicJson.%Set("MarryInfo",..GetMarryInfoForEcharts(PatientInfo))
	//d result.%Push(BasicJson)
	q BasicJson.%ToJSON()
}

/// Function:是根据配置code 查询到配置的值
/// Editor：ZWW 2022-08-26【添加 空格作为分隔符分隔多个关键字匹配检索。如"高血压 冠心病 中国"】
/// Others:w ##class(web.CDSS.TreatDecision.RatingScale).DocumentRetrieval("高血压 冠心病 中国")
ClassMethod DocumentRetrieval(Desc) As %String
{
	s Result={"StandardWord":[],"Document":[]}
	s Desc=$zconvert(Desc,"U")
	s DescT=$replace(Desc," ","^")
	s Desc=$p(DescT,"^",1)
	s DescLen=$l(DescT,"^")
	
	//q Result.%ToJSON()
	s StandardArray=[]
	s DocumentArray=[]
	s num = 0
	s StandardWord=""
	if (Desc'="")
	{
		s RowID=""
		for
		{
			s RowID=$o(^CT.WDT.CDSS.SynSearchDictI("AbbreIndex",Desc,RowID))
			q:RowID=""
			s StandardWord=RowID
			//s StandardWord=$listget($g(^CT.WDT.CDSS.SynSearchDictD(RowID)),4)
			if (Desc'=StandardWord)&&(StandardArray.%ToJSON()'[StandardWord)
			{
				d StandardArray.%Push(StandardWord)
			}
		}
		for
		{
			s RowID=$o(^CT.WDT.CDSS.SynSearchDictI("PYCodeIndex"," "_Desc,RowID))
			q:RowID=""
			s StandardWord=$listget($g(^CT.WDT.CDSS.SynSearchDictD(RowID)),4)
			if (Desc'=StandardWord)&&(StandardArray.%ToJSON()'[StandardWord)
			{
				d StandardArray.%Push(StandardWord)
			}
		}
		d Result.%Set("StandardWord",StandardArray)
		//关键词匹配 文献名包含标准词
		//s:StandardWord="" StandardWord=Desc
		//s MatchArray=[]
		s MatchArray=[].%FromJSON(StandardArray.%ToJSON())
		d MatchArray.%Push(Desc)
		
		//临床指南
		s DocuMonth = ""
		for
		{
			q:num=10
			s DocuMonth = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","临床指南",DocuMonth),-1)
			q:DocuMonth=""
			s LiteID=""
			for
			{
				q:num=10
				s LiteID = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","临床指南",DocuMonth,LiteID))
				q:LiteID=""
				//中文文献名称
				s DocuDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),3)
				//英文文献名称
				s DocuEngDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),4)
				//文献路径
				s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),5)
				continue:DocuPath=""
				//文献关键词
				s DocuKeyWords=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),6)
				//关联诊断
				s JoinDisease=""
				s DiseaseDR=""
				for {
					s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",LiteID,DiseaseDR)) q:DiseaseDR=""
					s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
					if (JoinDisease=""){
						s JoinDisease=DiseaseDesc
					}else{
						s JoinDisease=JoinDisease_",<br>"_DiseaseDesc
					}
				}
				//判断包含	
				for i=0:1:MatchArray.%Size()-1
				{
					if ((DocuDesc[(MatchArray.%Get(i)))||(DocuEngDesc[(MatchArray.%Get(i)))||(DocuKeyWords[(MatchArray.%Get(i)))||(JoinDisease[(MatchArray.%Get(i))))
					{
						//Add By 赵文伟 2022-08-26 匹配检索多个关键字取交集
						s flag=1
						if (DescLen>1){
							for n=1:1:DescLen{
								s Desc=$p(DescT,"^",n)
								if '(DocuDesc[Desc) s flag=0
							}
							if (flag=1){
								s SearchDoc={}
								d SearchDoc.%Set("Desc",DocuDesc)
								d SearchDoc.%Set("ID",LiteID)
								d SearchDoc.%Set("DocuPath",DocuPath)
								d SearchDoc.%Set("Type","文献")
								d DocumentArray.%Push(SearchDoc)
								s num = num + 1
							}
						} else{
							s SearchDoc={}
							d SearchDoc.%Set("Desc",DocuDesc)
							d SearchDoc.%Set("ID",LiteID)
							d SearchDoc.%Set("DocuPath",DocuPath)
							d SearchDoc.%Set("Type","文献")
							d DocumentArray.%Push(SearchDoc)
							s num = num + 1
						}
#;						if (KeyWords'=""){
#;							if (DocuKeyWords[KeyWords){
#;								s SearchDoc={}
#;								d SearchDoc.%Set("Desc",DocuDesc)
#;								d SearchDoc.%Set("ID",LiteID)
#;								d SearchDoc.%Set("DocuPath",DocuPath)
#;								d SearchDoc.%Set("Type","文献")
#;								d DocumentArray.%Push(SearchDoc)
#;								s num = num + 1
#;							}
#;						} else{
#;							s SearchDoc={}
#;							d SearchDoc.%Set("Desc",DocuDesc)
#;							d SearchDoc.%Set("ID",LiteID)
#;							d SearchDoc.%Set("DocuPath",DocuPath)
#;							d SearchDoc.%Set("Type","文献")
#;							d DocumentArray.%Push(SearchDoc)
#;							s num = num + 1
#;
						
					}
				}
			}
		}
		//专题笔谈
		s DocuMonth = ""
		for
		{	
			q:num=10
			s DocuMonth = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","专题笔谈",DocuMonth),-1)
			q:DocuMonth=""
			s LiteID=""
			for
			{
				q:num=10
				s LiteID = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","专题笔谈",DocuMonth,LiteID))
				q:LiteID=""
				//中文文献名称
				s DocuDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),3)
				//英文文献名称
				s DocuEngDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),4)
				//文献路径
				s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),5)
				continue:DocuPath=""
				//文献关键词
				s DocuKeyWords=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),6)	
				//关联诊断
				s JoinDisease=""
				s DiseaseDR=""
				for {
					s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",LiteID,DiseaseDR)) q:DiseaseDR=""
					s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
					if (JoinDisease=""){
						s JoinDisease=DiseaseDesc
					}else{
						s JoinDisease=JoinDisease_",<br>"_DiseaseDesc
					}
				}
				//判断包含	
				for i=0:1:MatchArray.%Size()-1
				{
					if ((DocuDesc[(MatchArray.%Get(i)))||(DocuEngDesc[(MatchArray.%Get(i)))||(DocuKeyWords[(MatchArray.%Get(i)))||(JoinDisease[(MatchArray.%Get(i))))
					{
						s flag=1
						if (DescLen>1){
							for n=1:1:DescLen{
								s Desc=$p(DescT,"^",n)
								if '(DocuDesc[Desc) s flag=0
							}
							if (flag=1){
								s SearchDoc={}
								d SearchDoc.%Set("Desc",DocuDesc)
								d SearchDoc.%Set("ID",LiteID)
								d SearchDoc.%Set("DocuPath",DocuPath)
								d SearchDoc.%Set("Type","文献")
								d DocumentArray.%Push(SearchDoc)
								s num = num + 1
							}
						} else{
							s SearchDoc={}
							d SearchDoc.%Set("Desc",DocuDesc)
							d SearchDoc.%Set("ID",LiteID)
							d SearchDoc.%Set("DocuPath",DocuPath)
							d SearchDoc.%Set("Type","文献")
							d DocumentArray.%Push(SearchDoc)
							s num = num + 1
						}

					}
				}
			}
		}
		//综述
		s DocuMonth = ""
		for
		{	
			q:num=10
			s DocuMonth = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","综述",DocuMonth),-1)
			q:DocuMonth=""
			s LiteID=""
			for
			{
				q:num=10
				s LiteID = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","综述",DocuMonth,LiteID))
				q:LiteID=""
				//中文文献名称
				s DocuDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),3)
				//英文文献名称
				s DocuEngDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),4)
				//文献路径
				s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),5)
				continue:DocuPath=""
				//文献关键词
				s DocuKeyWords=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),6)	
				//关联诊断
				s JoinDisease=""
				s DiseaseDR=""
				for {
					s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",LiteID,DiseaseDR)) q:DiseaseDR=""
					s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
					if (JoinDisease=""){
						s JoinDisease=DiseaseDesc
					}else{
						s JoinDisease=JoinDisease_",<br>"_DiseaseDesc
					}
				}
				//判断包含	
				for i=0:1:MatchArray.%Size()-1
				{
					if ((DocuDesc[(MatchArray.%Get(i)))||(DocuEngDesc[(MatchArray.%Get(i)))||(DocuKeyWords[(MatchArray.%Get(i)))||(JoinDisease[(MatchArray.%Get(i))))
					{
						s flag=1
						if (DescLen>1){
							for n=1:1:DescLen{
								s Desc=$p(DescT,"^",n)
								if '(DocuDesc[Desc) s flag=0
							}
							if (flag=1){
								s SearchDoc={}
								d SearchDoc.%Set("Desc",DocuDesc)
								d SearchDoc.%Set("ID",LiteID)
								d SearchDoc.%Set("DocuPath",DocuPath)
								d SearchDoc.%Set("Type","文献")
								d DocumentArray.%Push(SearchDoc)
								s num = num + 1
							}
						} else{
							s SearchDoc={}
							d SearchDoc.%Set("Desc",DocuDesc)
							d SearchDoc.%Set("ID",LiteID)
							d SearchDoc.%Set("DocuPath",DocuPath)
							d SearchDoc.%Set("Type","文献")
							d DocumentArray.%Push(SearchDoc)
							s num = num + 1
						}
					}
				}
			}
		}
		//专题评论
		s DocuMonth = ""
		for
		{	
			q:num=10
			s DocuMonth = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","专题评论",DocuMonth),-1)
			q:DocuMonth=""
			s LiteID=""
			for
			{
				q:num=10
				s LiteID = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","专题评论",DocuMonth,LiteID))
				q:LiteID=""
				//中文文献名称
				s DocuDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),3)
				//英文文献名称
				s DocuEngDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),4)
				//文献路径
				s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),5)
				continue:DocuPath=""
				//文献关键词
				s DocuKeyWords=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),6)	
				//关联诊断
				s JoinDisease=""
				s DiseaseDR=""
				for {
					s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",LiteID,DiseaseDR)) q:DiseaseDR=""
					s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
					if (JoinDisease=""){
						s JoinDisease=DiseaseDesc
					}else{
						s JoinDisease=JoinDisease_",<br>"_DiseaseDesc
					}
				}
				//判断包含	
				for i=0:1:MatchArray.%Size()-1
				{
					if ((DocuDesc[(MatchArray.%Get(i)))||(DocuEngDesc[(MatchArray.%Get(i)))||(DocuKeyWords[(MatchArray.%Get(i)))||(JoinDisease[(MatchArray.%Get(i))))
					{
						s flag=1
						if (DescLen>1){
							for n=1:1:DescLen{
								s Desc=$p(DescT,"^",n)
								if '(DocuDesc[Desc) s flag=0
							}
							if (flag=1){
								s SearchDoc={}
								d SearchDoc.%Set("Desc",DocuDesc)
								d SearchDoc.%Set("ID",LiteID)
								d SearchDoc.%Set("DocuPath",DocuPath)
								d SearchDoc.%Set("Type","文献")
								d DocumentArray.%Push(SearchDoc)
								s num = num + 1
							}
						} else{
							s SearchDoc={}
							d SearchDoc.%Set("Desc",DocuDesc)
							d SearchDoc.%Set("ID",LiteID)
							d SearchDoc.%Set("DocuPath",DocuPath)
							d SearchDoc.%Set("Type","文献")
							d DocumentArray.%Push(SearchDoc)
							s num = num + 1
						}
					}
				}
			}
		}
		//论著
		s DocuMonth = ""
		for
		{	
			q:num=10
			s DocuMonth = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","论著",DocuMonth),-1)
			q:DocuMonth=""
			s LiteID=""
			for
			{
				q:num=10
				s LiteID = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","论著",DocuMonth,LiteID))
				q:LiteID=""
				//中文文献名称
				s DocuDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),3)
				//英文文献名称
				s DocuEngDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),4)
				//文献路径
				s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),5)
				continue:DocuPath=""
				//文献关键词
				s DocuKeyWords=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),6)	
				//关联诊断
				s JoinDisease=""
				s DiseaseDR=""
				for {
					s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",LiteID,DiseaseDR)) q:DiseaseDR=""
					s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
					if (JoinDisease=""){
						s JoinDisease=DiseaseDesc
					}else{
						s JoinDisease=JoinDisease_",<br>"_DiseaseDesc
					}
				}
				//判断包含	
				for i=0:1:MatchArray.%Size()-1
				{
					if ((DocuDesc[(MatchArray.%Get(i)))||(DocuEngDesc[(MatchArray.%Get(i)))||(DocuKeyWords[(MatchArray.%Get(i)))||(JoinDisease[(MatchArray.%Get(i))))
					{
						s flag=1
						if (DescLen>1){
							for n=1:1:DescLen{
								s Desc=$p(DescT,"^",n)
								if '(DocuDesc[Desc) s flag=0
							}
							if (flag=1){
								s SearchDoc={}
								d SearchDoc.%Set("Desc",DocuDesc)
								d SearchDoc.%Set("ID",LiteID)
								d SearchDoc.%Set("DocuPath",DocuPath)
								d SearchDoc.%Set("Type","文献")
								d DocumentArray.%Push(SearchDoc)
								s num = num + 1
							}
						} else{
							s SearchDoc={}
							d SearchDoc.%Set("Desc",DocuDesc)
							d SearchDoc.%Set("ID",LiteID)
							d SearchDoc.%Set("DocuPath",DocuPath)
							d SearchDoc.%Set("Type","文献")
							d DocumentArray.%Push(SearchDoc)
							s num = num + 1
						}
					}
				}
			}
		}
		//经验交流
		s DocuMonth = ""
		for
		{	
			q:num=10
			s DocuMonth = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","经验交流",DocuMonth),-1)
			q:DocuMonth=""
			s LiteID=""
			for
			{
				q:num=10
				s LiteID = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","经验交流",DocuMonth,LiteID))
				q:LiteID=""
				//中文文献名称
				s DocuDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),3)
				//英文文献名称
				s DocuEngDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),4)
				//文献路径
				s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),5)
				continue:DocuPath=""
				//文献关键词
				s DocuKeyWords=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),6)	
				//关联诊断
				s JoinDisease=""
				s DiseaseDR=""
				for {
					s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",LiteID,DiseaseDR)) q:DiseaseDR=""
					s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
					if (JoinDisease=""){
						s JoinDisease=DiseaseDesc
					}else{
						s JoinDisease=JoinDisease_",<br>"_DiseaseDesc
					}
				}
				//判断包含	
				for i=0:1:MatchArray.%Size()-1
				{
					if ((DocuDesc[(MatchArray.%Get(i)))||(DocuEngDesc[(MatchArray.%Get(i)))||(DocuKeyWords[(MatchArray.%Get(i)))||(JoinDisease[(MatchArray.%Get(i))))
					{
						s flag=1
						if (DescLen>1){
							for n=1:1:DescLen{
								s Desc=$p(DescT,"^",n)
								if '(DocuDesc[Desc) s flag=0
							}
							if (flag=1){
								s SearchDoc={}
								d SearchDoc.%Set("Desc",DocuDesc)
								d SearchDoc.%Set("ID",LiteID)
								d SearchDoc.%Set("DocuPath",DocuPath)
								d SearchDoc.%Set("Type","文献")
								d DocumentArray.%Push(SearchDoc)
								s num = num + 1
							}
						} else{
							s SearchDoc={}
							d SearchDoc.%Set("Desc",DocuDesc)
							d SearchDoc.%Set("ID",LiteID)
							d SearchDoc.%Set("DocuPath",DocuPath)
							d SearchDoc.%Set("Type","文献")
							d DocumentArray.%Push(SearchDoc)
							s num = num + 1
						}
					}
				}
			}
		}
		//病历报告
		s DocuMonth = ""
		for
		{	
			q:num=10
			s DocuMonth = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","病历报告",DocuMonth),-1)
			q:DocuMonth=""
			s LiteID=""
			for
			{
				q:num=10
				s LiteID = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","病历报告",DocuMonth,LiteID))
				q:LiteID=""
				//中文文献名称
				s DocuDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),3)
				//英文文献名称
				s DocuEngDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),4)
				//文献路径
				s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),5)
				continue:DocuPath=""
				//文献关键词
				s DocuKeyWords=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),6)	
				//关联诊断
				s JoinDisease=""
				s DiseaseDR=""
				for {
					s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",LiteID,DiseaseDR)) q:DiseaseDR=""
					s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
					if (JoinDisease=""){
						s JoinDisease=DiseaseDesc
					}else{
						s JoinDisease=JoinDisease_",<br>"_DiseaseDesc
					}
				}
				//判断包含	
				for i=0:1:MatchArray.%Size()-1
				{
					if ((DocuDesc[(MatchArray.%Get(i)))||(DocuEngDesc[(MatchArray.%Get(i)))||(DocuKeyWords[(MatchArray.%Get(i)))||(JoinDisease[(MatchArray.%Get(i))))
					{
						s flag=1
						if (DescLen>1){
							for n=1:1:DescLen{
								s Desc=$p(DescT,"^",n)
								if '(DocuDesc[Desc) s flag=0
							}
							if (flag=1){
								s SearchDoc={}
								d SearchDoc.%Set("Desc",DocuDesc)
								d SearchDoc.%Set("ID",LiteID)
								d SearchDoc.%Set("DocuPath",DocuPath)
								d SearchDoc.%Set("Type","文献")
								d DocumentArray.%Push(SearchDoc)
								s num = num + 1
							}
						} else{
							s SearchDoc={}
							d SearchDoc.%Set("Desc",DocuDesc)
							d SearchDoc.%Set("ID",LiteID)
							d SearchDoc.%Set("DocuPath",DocuPath)
							d SearchDoc.%Set("Type","文献")
							d DocumentArray.%Push(SearchDoc)
							s num = num + 1
						}
					}
				}
			}
		}
		//学术动态
		s DocuMonth = ""
		for
		{	
			q:num=10
			s DocuMonth = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","学术动态",DocuMonth),-1)
			q:DocuMonth=""
			s LiteID=""
			for
			{
				q:num=10
				s LiteID = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","学术动态",DocuMonth,LiteID))
				q:LiteID=""
				//中文文献名称
				s DocuDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),3)
				//英文文献名称
				s DocuEngDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),4)
				//文献路径
				s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),5)
				continue:DocuPath=""
				//文献关键词
				s DocuKeyWords=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),6)	
				//关联诊断
				s JoinDisease=""
				s DiseaseDR=""
				for {
					s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",LiteID,DiseaseDR)) q:DiseaseDR=""
					s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
					if (JoinDisease=""){
						s JoinDisease=DiseaseDesc
					}else{
						s JoinDisease=JoinDisease_",<br>"_DiseaseDesc
					}
				}
				//判断包含	
				for i=0:1:MatchArray.%Size()-1
				{
					if ((DocuDesc[(MatchArray.%Get(i)))||(DocuEngDesc[(MatchArray.%Get(i)))||(DocuKeyWords[(MatchArray.%Get(i)))||(JoinDisease[(MatchArray.%Get(i))))
					{
						s flag=1
						if (DescLen>1){
							for n=1:1:DescLen{
								s Desc=$p(DescT,"^",n)
								if '(DocuDesc[Desc) s flag=0
							}
							if (flag=1){
								s SearchDoc={}
								d SearchDoc.%Set("Desc",DocuDesc)
								d SearchDoc.%Set("ID",LiteID)
								d SearchDoc.%Set("DocuPath",DocuPath)
								d SearchDoc.%Set("Type","文献")
								d DocumentArray.%Push(SearchDoc)
								s num = num + 1
							}
						} else{
							s SearchDoc={}
							d SearchDoc.%Set("Desc",DocuDesc)
							d SearchDoc.%Set("ID",LiteID)
							d SearchDoc.%Set("DocuPath",DocuPath)
							d SearchDoc.%Set("Type","文献")
							d DocumentArray.%Push(SearchDoc)
							s num = num + 1
						}
					}
				}
			}
		}
		//评论
		s DocuMonth = ""
		for
		{	
			q:num=10
			s DocuMonth = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","评论",DocuMonth),-1)
			q:DocuMonth=""
			s LiteID=""
			for
			{
				q:num=10
				s LiteID = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex","评论",DocuMonth,LiteID))
				q:LiteID=""
				//中文文献名称
				s DocuDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),3)
				//英文文献名称
				s DocuEngDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),4)
				//文献路径
				s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),5)
				continue:DocuPath=""
				//文献关键词
				s DocuKeyWords=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),6)	
				//关联诊断
				s JoinDisease=""
				s DiseaseDR=""
				for {
					s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",LiteID,DiseaseDR)) q:DiseaseDR=""
					s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
					if (JoinDisease=""){
						s JoinDisease=DiseaseDesc
					}else{
						s JoinDisease=JoinDisease_",<br>"_DiseaseDesc
					}
				}
				//判断包含	
				for i=0:1:MatchArray.%Size()-1
				{
					if ((DocuDesc[(MatchArray.%Get(i)))||(DocuEngDesc[(MatchArray.%Get(i)))||(DocuKeyWords[(MatchArray.%Get(i)))||(JoinDisease[(MatchArray.%Get(i))))
					{
						s flag=1
						if (DescLen>1){
							for n=1:1:DescLen{
								s Desc=$p(DescT,"^",n)
								if '(DocuDesc[Desc) s flag=0
							}
							if (flag=1){
								s SearchDoc={}
								d SearchDoc.%Set("Desc",DocuDesc)
								d SearchDoc.%Set("ID",LiteID)
								d SearchDoc.%Set("DocuPath",DocuPath)
								d SearchDoc.%Set("Type","文献")
								d DocumentArray.%Push(SearchDoc)
								s num = num + 1
							}
						} else{
							s SearchDoc={}
							d SearchDoc.%Set("Desc",DocuDesc)
							d SearchDoc.%Set("ID",LiteID)
							d SearchDoc.%Set("DocuPath",DocuPath)
							d SearchDoc.%Set("Type","文献")
							d DocumentArray.%Push(SearchDoc)
							s num = num + 1
						}
					}
				}
			}
		}
		//无类型
		s DocuMonth = ""
		for
		{	
			q:num=10
			s DocuMonth = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex",-100000000000000,DocuMonth),-1)
			q:DocuMonth=""
			s LiteID=""
			for
			{
				q:num=10
				s LiteID = $o(^CT.WDT.CDSS.DocuManageI("DocuTypeIndex",-100000000000000,DocuMonth,LiteID))
				q:LiteID=""
				//中文文献名称
				s DocuDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),3)
				//英文文献名称
				s DocuEngDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),4)
				//文献路径
				s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),5)
				continue:DocuPath=""
				//文献关键词
				s DocuKeyWords=$lg($g(^CT.WDT.CDSS.DocuManageD(LiteID)),6)	
				//关联诊断
				s JoinDisease=""
				s DiseaseDR=""
				for {
					s DiseaseDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuDiseaseIndex",LiteID,DiseaseDR)) q:DiseaseDR=""
					s DiseaseDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
					if (JoinDisease=""){
						s JoinDisease=DiseaseDesc
					}else{
						s JoinDisease=JoinDisease_",<br>"_DiseaseDesc
					}
				}
				//判断包含	
				for i=0:1:MatchArray.%Size()-1
				{
					if ((DocuDesc[(MatchArray.%Get(i)))||(DocuEngDesc[(MatchArray.%Get(i)))||(DocuKeyWords[(MatchArray.%Get(i)))||(JoinDisease[(MatchArray.%Get(i))))
					{
						s flag=1
						if (DescLen>1){
							for n=1:1:DescLen{
								s Desc=$p(DescT,"^",n)
								if '(DocuDesc[Desc) s flag=0
							}
							if (flag=1){
								s SearchDoc={}
								d SearchDoc.%Set("Desc",DocuDesc)
								d SearchDoc.%Set("ID",LiteID)
								d SearchDoc.%Set("DocuPath",DocuPath)
								d SearchDoc.%Set("Type","文献")
								d DocumentArray.%Push(SearchDoc)
								s num = num + 1
							}
						} else{
							s SearchDoc={}
							d SearchDoc.%Set("Desc",DocuDesc)
							d SearchDoc.%Set("ID",LiteID)
							d SearchDoc.%Set("DocuPath",DocuPath)
							d SearchDoc.%Set("Type","文献")
							d DocumentArray.%Push(SearchDoc)
							s num = num + 1
						}
					}
				}
			}
		}
		
		d Result.%Set("Document",DocumentArray)
		//文献关联诊断匹配   文献关联诊断=标准词
	}
	q Result.%ToJSON()
}

/// Other:w ##class(web.CDSS.TreatDecision.RatingScale).removeHtmlTags(str)
ClassMethod removeHtmlTags(str As %String)
{
	s str=$replace(str,"span","p")
	s str=$replace(str,"</p>","")
	s str=$replace(str,"<br/>","")
    while str["<p"
	{
		s str=$replace(str,($e(str,$locate(str,"<p"),($locate(str,"\"">"))+1)),"")
	}
	//增加换行符
	s str=$Replace(str,")","）")
	s str=$Replace(str,"(","（")
	s n = $LOCATE(str,"（[0-9]）+")
	b ;
	q str
}

/// Creator:范文凯
/// CreatDate:2021-02-20
/// Description：提供CDSS2.0联想查询接口
/// Other: w ##class(web.CDSS.TreatDecision.RatingScale).GetRelatedSearch("文献","肺炎")
/// Creator:范文凯
/// CreatDate:2021-02-20
/// Description：提供CDSS2.0联想查询接口
/// Other: w ##class(web.CDSS.TreatDecision.RatingScale).GetRelatedSearchV2("诊断","板腺囊肿")
ClassMethod GetRelatedSearchV2(SearchType As %String, SearchDesc As %String) As %String
{
	n (SearchDesc,SearchType)
	s num = 0
	if (SearchDesc = "")
	{
		q "[]"
	}
	s jsonInfo = "["
	if (SearchType = "诊断")
	{
		if ($d(^CT.WDT.CDSS.TermI("DescIndex",120,SearchDesc)))
		{
			s num = num + 1
			s TermID = $o(^CT.WDT.CDSS.TermI("DescIndex",120,SearchDesc,""))
			s Status = $lg($g(^CT.WDT.CDSS.TermD(TermID)),14)
			s jsonInfo = jsonInfo_"{""Desc"":"""_SearchDesc_""",""ID"":"""_TermID_""",""Type"":"""_SearchType_""",""Status"":"""_Status_""",""TableName"":""CT.WDT.CDSS.Term120""},"
		}
		s TermID = ""
		for
		{
			q:num=10
			s TermID = $o(^CT.WDT.CDSS.TermI("BaseIndex",120,TermID))
			q:TermID=""
			s TermDesc = $lg($g(^CT.WDT.CDSS.TermD(TermID)),3)
			s Status = $lg($g(^CT.WDT.CDSS.TermD(TermID)),14)
			if (TermDesc[SearchDesc)
			{
				s jsonInfo = jsonInfo_"{""Desc"":"""_TermDesc_""",""ID"":"""_TermID_""",""Type"":"""_SearchType_""",""Status"":"""_Status_""",""TableName"":""CT.WDT.CDSS.Term120""},"
				s num = num + 1
			}
		}
	}
	elseif (SearchType = "检查")
	{
		if ($d(^CT.WDT.CDSS.TermI("DescIndex",122,SearchDesc)))
		{
			s num = num + 1
			s TermID = $o(^CT.WDT.CDSS.TermI("DescIndex",122,SearchDesc,""))
			s Status = $lg($g(^CT.WDT.CDSS.TermD(TermID)),14)
			s jsonInfo = jsonInfo_"{""Desc"":"""_SearchDesc_""",""ID"":"""_TermID_""",""Type"":"""_SearchType_""",""Status"":"""_Status_""",""TableName"":""CT.WDT.CDSS.Term122""},"
		}
		s TermID = ""
		for
		{
			q:num=10
			s TermID = $o(^CT.WDT.CDSS.TermI("BaseIndex",122,TermID))
			//b ;;
			q:TermID=""
			s TermDesc = $lg($g(^CT.WDT.CDSS.TermD(TermID)),3)
			s Status = $lg($g(^CT.WDT.CDSS.TermD(TermID)),14)
			if (TermDesc[SearchDesc)
			{
				s jsonInfo = jsonInfo_"{""Desc"":"""_TermDesc_""",""ID"":"""_TermID_""",""Type"":"""_SearchType_""",""Status"":"""_Status_""",""TableName"":""CT.WDT.CDSS.Term122""},"
				s num = num + 1
			}
		}
	}
	elseif (SearchType = "检验")
	{
		if ($d(^CT.WDT.CDSS.TermI("DescIndex",126,SearchDesc)))
		{
			s num = num + 1
			s TermID = $o(^CT.WDT.CDSS.TermI("DescIndex",126,SearchDesc,""))
			s Status = $lg($g(^CT.WDT.CDSS.TermD(TermID)),14)
			s jsonInfo = jsonInfo_"{""Desc"":"""_SearchDesc_""",""ID"":"""_TermID_""",""Type"":"""_SearchType_""",""Status"":"""_Status_""",""TableName"":""CT.WDT.CDSS.Term126""},"
		}
		s TermID = ""
		for
		{
			q:num=10
			s TermID = $o(^CT.WDT.CDSS.TermI("BaseIndex",126,TermID))
			//b ;;
			q:TermID=""
			s TermDesc = $lg($g(^CT.WDT.CDSS.TermD(TermID)),3)
			s Status = $lg($g(^CT.WDT.CDSS.TermD(TermID)),14)
			if (TermDesc[SearchDesc)
			{
				s jsonInfo = jsonInfo_"{""Desc"":"""_TermDesc_""",""ID"":"""_TermID_""",""Type"":"""_SearchType_""",""Status"":"""_Status_""",""TableName"":""CT.WDT.CDSS.Term126""},"
				s num = num + 1
			}
		}
	}
	elseif (SearchType = "手术" )
	{
		if ($d(^CT.WDT.CDSS.TermI("DescIndex",123,SearchDesc)))
		{
			s num = num + 1
			s TermID = $o(^CT.WDT.CDSS.TermI("DescIndex",123,SearchDesc,""))
			s Status = $lg($g(^CT.WDT.CDSS.TermD(TermID)),14)
			s jsonInfo = jsonInfo_"{""Desc"":"""_SearchDesc_""",""ID"":"""_TermID_""",""Type"":"""_SearchType_""",""Status"":"""_Status_""",""TableName"":""CT.WDT.CDSS.Term123""},"
		}
		s TermID = ""
		for
		{
			q:num=10
			s TermID = $o(^CT.WDT.CDSS.TermI("BaseIndex",123,TermID))
			//b ;;
			q:TermID=""
			s TermDesc = $lg($g(^CT.WDT.CDSS.TermD(TermID)),3)
			s Status = $lg($g(^CT.WDT.CDSS.TermD(TermID)),14)
			if (TermDesc[SearchDesc)
			{
				s jsonInfo = jsonInfo_"{""Desc"":"""_TermDesc_""",""ID"":"""_TermID_""",""Type"":"""_SearchType_""",""Status"":"""_Status_""",""TableName"":""CT.WDT.CDSS.Term123""},"
				s num = num + 1
			}
		}
	}
	elseif (SearchType = "评估表" )
	{
		s AssDesc = ""
		s Status = 2
		for
		{
			q:num=10
			s AssDesc = $e($o(^CT.WDT.CDSS.AssBaseI("DescIndex"," "_AssDesc)),2,*)
			q:AssDesc=""
			s AssDR = $o(^CT.WDT.CDSS.AssBaseI("DescIndex"," "_$ZCONVERT(AssDesc,"U"),0))
			//s $o(^CT.WDT.CDSS.AssBaseI("DescIndex"," "_$ZCONVERT(RatingScaleName,"U"),0))
			if (AssDesc[$ZCONVERT(SearchDesc,"U"))
			{
				s jsonInfo = jsonInfo_"{""Desc"":"""_AssDesc_""",""ID"":"""_AssDR_""",""Type"":"""_SearchType_""",""Status"":"""_Status_""",""TableName"":""CT.WDT.CDSS.AssBase""},"
				s num = num + 1
			}
		}
	}
	
	s jsonInfo = $e(jsonInfo,0,*-1)
	if (jsonInfo '= "")
	{
		q jsonInfo_"]"
	}
	else
	{
		q "[]"
	}
}

/// Creator：阚延新
/// CreatDate: 2022-2-18
/// Description：根据知识库描述和类型，获取对接方数据的所有代码和描述
/// Table:desc 知识库描述，type 数据类型,codeFlag-代码标识，如果代码标识不为空，则返回描述+代码，如果为空则只返回描述
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.TreatDecision.RatingScale).GetAllProjectDataName("心电图",""，"")
ClassMethod GetAllProjectDataName(desc As %String, type As %String = "", hisLocID As %String = "") As %String
{
	s result=""
	q:desc="" ""
	s hosp=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401")  //医院id
	q:hosp="" ""
	s typeid=""  //对接方字典分类表id 
	s result=[]
	if (type'="")  //如果入参数据类型不为空
	{	
		//如果入参是标准的类型名称，则通过对接方字典分类表的名称索引取id	
		s typeid=$o(^CT.WDT.CDSS.ConClassDictI("DescIndex"," "_$ZCONVERT(type,"U"),0))	
		s:typeid'="" typeid=$case(typeid,"1":"诊断","2":"检查检验","3":"检查检验","4":"药品","5":"手术","6":"护理","7":"频率","8":"体征信息","9":"检验标本","10":"用法","11":"单位","12":"科室","13":"检查检验","14":"输血品","15":"中药",:"")
		//如果入参不是标准的类型名称,则单独处理
		s:typeid="" typeid=$case(type,"诊断":"诊断","药品":"药品","药物":"药品","手术":"手术","检查":"检查检验","检验":"检查检验","体征":"体征信息","检验医嘱":"检查检验","输血":"输血品","护理":"护理","频率":"频率","体征信息":"体征信息","检验标本":"检验标本","用法":"用法","单位":"单位","科室":"科室","输血品":"输血品","中药":"中药","中医诊断":"中医诊断","中医证型":"中医证型",:"")
	}
	s HospAreaDR=""
	if (hisLocID'="")		//由his科室id得到所属院区
	{
		s DeptID=$o(^CF.WDT.CDSS.DeptDictI("DeptIDIndex"," "_$zconvert(hisLocID,"U"),""))
		if (DeptID'="")
		{
			s HospAreaDR=$LISTGET($G(^CF.WDT.CDSS.DeptDictD(DeptID)),10)		//院区id
		}
	}
	
	s IntDictDesc="",IntDictCode=""
	if (typeid="")	//传的类型为空
	{
		s typedr=""
		for
		{
			s typedr=$o(^CT.WDT.CDSS.ContrastDictI("DictDRIndex",hosp,typedr))
			q:typedr=""
			//s typedr = "检查检验"
			s typedrs=$case(typedr,"诊断":"1","检查检验":"2,3,13","药品":"4","手术":"5","护理":"6","频率":"7","检验标本":"9","用法":"10","单位":"11","科室":"12","输血品":"14","中药":"15","中医诊断":"16","中医证型":"17",:"")
			for i=1:1:$l(typedrs,",")
			{
				s typedesc=$p(typedrs,",",i)
				s DictiClassMapping=$lg($g(^CT.WDT.CDSS.ConClassDictD(typedesc)),5)	//对照CDSS字典名
				s DictID=##class(web.CDSS.IMP.ContrastDict).GetDictIDCodeDesc(DictiClassMapping,"",desc)
				
				if (DictID'="")		//知识库数据存在
				{
					s DictDR=""
					for
					{
						s DictDR=$o(^CT.WDT.CDSS.ContrastDictI("DictDRIndex",hosp,typedr,DictDR))
						q:DictDR=""
						s DictIDs=","_DictID_","
						s DictDRs=","_DictDR_","
						CONTINUE:DictDRs'[DictIDs
						s ID=0
						for
						{
							s ID=$o(^CT.WDT.CDSS.ContrastDictI("DictDRIndex",hosp,typedr,DictDR,ID))
							q:ID=""
							s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
							if (typedr="检查检验")
							{
								s ExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(IntDictDR)),4)
								if (ExamType="检查")
								{
									continue:typedesc'=2
								}
								if (ExamType="检验项目")
								{
									continue:typedesc'=3
								}
								if (ExamType="检验医嘱")
								{
									continue:typedesc'=13
								}
							}
							if (HospAreaDR'="")
							{
								if (IntDictDR'="")
								{
									s HospArea=$o(^CT.WDT.CDSS.ConDictConAreaI("InterDictDRIndex",typedr,IntDictDR,""))
									if (HospArea'="")
									{
										s ConDictConAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",typedr,IntDictDR,HospAreaDR,""))
										continue:ConDictConAreaID=""
									}

								}
							}
							s IntDictCode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),5)	//对接方字典代码
							s IntDictDesc=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),6)	//对接方描述  	 
							s OneDictItem = {}
							d OneDictItem.%Set("ItemName",IntDictDesc)
							d OneDictItem.%Set("ItemCode",IntDictCode)
							d result.%Push(OneDictItem)	
						}
					}
				}
			}
		}
	}
	else
	{
		s typedrs=$case(typeid,"诊断":"1","检查检验":"2,3,13","药品":"4","手术":"5","护理":"6","频率":"7","检验标本":"9","用法":"10","单位":"11","科室":"12","输血品":"14","中药":"15","中医诊断":"16","中医证型":"17",:"")
		for i=1:1:$l(typedrs,",")
		{
			s typedesc=$p(typedrs,",",i)
			s DictiClassMapping=$lg($g(^CT.WDT.CDSS.ConClassDictD(typedesc)),5)	//对照CDSS字典名
			s DictID=##class(web.CDSS.IMP.ContrastDict).GetDictIDCodeDesc(DictiClassMapping,"",desc)
			if (DictID'="")		//知识库数据存在
			{
				s DictDR=""
				for
				{
					s DictDR=$o(^CT.WDT.CDSS.ContrastDictI("DictDRIndex",hosp,typeid,DictDR))
					q:DictDR=""
					s DictIDs=","_DictID_","
					s DictDRs=","_DictDR_","
					CONTINUE:DictDRs'[DictIDs
					s ID=0
					for
					{
						s ID=$o(^CT.WDT.CDSS.ContrastDictI("DictDRIndex",hosp,typeid,DictDR,ID))
						q:ID=""
						s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
						if (typeid="检查检验")
						{
							s ExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(IntDictDR)),4)
							if (ExamType="检查")
							{
								continue:typedesc'=2
							}
							if (ExamType="检验项目")
							{
								continue:typedesc'=3
							}
							if (ExamType="检验医嘱")
							{
								continue:typedesc'=13
							}
						}
						if (HospAreaDR'="")
						{
							s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
							if (IntDictDR'="")
							{
								s HospArea=$o(^CT.WDT.CDSS.ConDictConAreaI("InterDictDRIndex",typeid,IntDictDR,""))
								if (HospArea'="")
								{
									s ConDictConAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",typeid,IntDictDR,HospAreaDR,""))
									continue:ConDictConAreaID=""
								}

							}
						}
						s IntDictCode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),5)	//对接方字典代码
						s IntDictDesc=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),6)	//对接方描述  	 
						s OneDictItem = {}
						d OneDictItem.%Set("ItemName",IntDictDesc)
						d OneDictItem.%Set("ItemCode",IntDictCode)
						d result.%Push(OneDictItem)	
					}
				}
			}
		}
	}
	q result.%ToJSON()
}

/// Other: w ##class(web.CDSS.TreatDecision.RatingScale).getAllSelection(^TMP("FWK111"))
ClassMethod getAllSelection(ItemList As %String)
{
	s ^TMP("FWK111")=ItemList
	s ItemList=$REPLACE(ItemList,":""}",":""""}")
	s ItemList=$REPLACE(ItemList,":"",",":"""",")
	s ResuleList=[]
	s ItemList=[].%FromJSON(ItemList)
	for ItemListIndex=0:1:(ItemList.%Size()-1)
	{
		s OneList={}
		s ItemName = ItemList.%Get(ItemListIndex).%Get("ItemName")
		continue:(ItemName=""||ItemName="血糖测定")
	    s ProjectList = ..GetAllProjectDataName(ItemName,"检查")
		s ProjectList = [].%FromJSON(ProjectList)
		continue:(ProjectList.%Size()=0)
		d OneList.%Set("ItemName",ItemName)
		d OneList.%Set("ProjectList",ProjectList)
		d ResuleList.%Push(OneList)
	}
	q ResuleList.%ToJSON()
}

/// 当医嘱在字典对照中未匹配时，开启自动匹配
/// Other: w ##class(web.CDSS.TreatDecision.RatingScale).AutoMatchOrder(^TMP("FWK111"))
ClassMethod AutoMatchOrder(OrderName, HospID, OrderType) As %String
{
}

}

Import SQLUser

/// Creator: 	bianshuai
/// CreateDate: 2017-04-19
/// Descript: 	webservice交互命令工厂
Class web.DHCSTPHCMActionFactory Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// W ##Class(web.DHCSTPHCMActionFactory).AcitonProxy(Action, EpisodeID, OutBinStream)
ClassMethod AcitonProxy(action As %String, Params As %String, ByRef OutData As %GlobalCharacterStream) As %String
{
	n (action, Params, OutData)
	//定义错误处理函数
	//s $ZT="ERROR"
	
	if (action = "PatLabItem")
	{
		/// 病人检验项目
		s EpisodeID=$p(Params,"^",1)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMPatBaseInfo).JsGetLabItemStream(EpisodeID))
	}
	elseif(action = "PatLabItemDet")  
	{
		/// 病人检验项目指标
		s EpisodeID=$p(Params,"^",1)
		s reportID=$p(Params,"^",2)
		d OutData.CopyFrom(##Class(web.DHCSTPHCMPatBaseInfo).JsGetLabItemDetStream(EpisodeID, reportID))
	}
	elseif(action = "PatLisItem")  
	{
		/// 病人检查项目
		s EpisodeID=$p(Params,"^",1)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMPatBaseInfo).GetLisItemStream(EpisodeID))
	}
	elseif(action = "PatLisItemDet")  
	{
		/// 病人检查结果
		s OeordItem=$p(Params,"^",1)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMPatBaseInfo).GetLisItemDetStream(OeordItem))
	}
	elseif(action = "PatEmrImage")  
	{
		/// 电子病历
		s EpisodeID=$p(Params,"^",1)
		d OutData.CopyFrom(##Class(web.DHCSTPHCMPatBaseInfo).GetPatEmrImageDetial(EpisodeID))
		
	}
	elseif(action = "logon")
	{
		///登陆
		s userName=$p(Params,"^",1) 
		s password=$p(Params,"^",2) 
		d OutData.CopyFrom(##Class(web.DHCSTPHCMLogon).logon(userName,password))
		
	}
	elseif(action = "PatLocList")
	{
		///科室病人列表

		s LgLocID=$p(Params,"^",1)	
		d OutData.CopyFrom(##Class(web.DHCSTPHCMAPPPatManage).QueryLocPatientList(LgLocID))

    }
    elseif(action = "GetMonLevel")
	{
		///获取监护级别列表
		d OutData.CopyFrom(##Class(web.DHCSTPHCMAPPPatManage).QueryMonLevel())

	}
	
	elseif(action = "SaveConcernPat")
	{
		///保存重点关注患者
		s mLevelID=$p(Params,"#",1)
		s empPatDataList=$p(Params,"#",2)
		d OutData.CopyFrom(##Class(web.DHCSTPHCMAPPPatManage).saveEmpPat(mLevelID,empPatDataList))

	}
	elseif(action = "GetConcernInfo")
	{
		///获取重点关注患者相关信息
		s admDr=$p(Params,"^",1)
		d OutData.CopyFrom(##Class(web.DHCSTPHCMAPPPatManage).getEmpPatInfo(admDr))
	}
	elseif(action = "GetDiag")
	{
		///获取病人的诊断
		s PatID=$p(Params,"^",1)
		d OutData.CopyFrom(##Class(web.DHCSTPHCMAPPPatManage).QueryAppDiagtList(PatID))

	}
	elseif(action = "GetPatOrder")
	{
		///获取医嘱信息
		s startDate=$p(Params,"^",1)
		s stopDate=$p(Params,"^",2)
		s AdmDr=$p(Params,"^",3)
		s priCodeString=$p(Params,"^",4)	
		s OeFlagString=$p(Params,"^",5)
		s orderTypeString=$p(Params,"^",6)	
		d OutData.CopyFrom(##Class(web.DHCSTPHCMAPPPatManage).GetPatOEInfoNew(startDate,stopDate,AdmDr,priCodeString,OeFlagString,orderTypeString))


	}
	
    elseif(action = "GetMonScopeList")
    {
	    ///获取监护范围列表
	    s monSubClassID=$p(Params,"^",1)
	    s monLevelID=$p(Params,"^",2)
	    d OutData.CopyFrom(##Class(web.DHCSTPHCMAPPPatManage).getMonScopeList(monSubClassID,monLevelID))
	    
	 }
	elseif(action="GetMonItemlist")
	  {
	   ///获取监护项目列表
	   s monSubClassID=$P(Params,"^",1)
	   s monLevelID=$p(Params,"^",2)
	   d OutData.CopyFrom(##Class(web.DHCSTPHCMAPPPatManage).getMonItemList(monSubClassID,monLevelID))	  
	 }
	 
   elseif(action="SaveMedMonInfo")
	 {
		 ///保存药学监护
		 s monID=$p(Params,"#",1)
		 s monMInfoList=$p(Params,"#",2)
		 d OutData.CopyFrom(##Class(web.DHCSTPHCMAPPPatManage).saveMedMonInfo(monID,monMInfoList))
		 
		 }
	elseif(action="GetPatMonList")
	{
		 ///获取监护记录
		 s monLevId =$p(Params,"^",1)
		 s admDr =$p(Params,"^",2)
		 s startDate=$p(Params,"^",3)
		 s stopDate=$p(Params,"^",4)
		 d OutData.CopyFrom(##Class(web.DHCSTPHCMAPPPatManage).GetPatMonList(monLevId,admDr,startDate,stopDate))
	}
	
	elseif(action="GetPatMonScopeList")
	{
		///获取已经选中的监护范围
		 s monId =$p(Params,"^",1)
		 d OutData.CopyFrom(##Class(web.DHCSTPHCMAPPPatManage).GetPatMonScopeList(monId))
		
		}
	elseif(action ="GetPatMonItemList")
	{
		///获取已经选中的监护项目
		 s monId =$p(Params,"^",1)
		 d OutData.CopyFrom(##Class(web.DHCSTPHCMAPPPatManage).GetPatMonItemList(monId))
		
		}
	elseif(action="GetMonImpLabsAndGuidCon")
	{
		///获取检验检查和病情转归情况
		s monId =$p(Params,"^",1)
		d OutData.CopyFrom(##Class(web.DHCSTPHCMAPPPatManage).GetMonImpLabsAndGuidCon(monId))
		}
		
		elseif(action = "InsMedAdvDetail")  
	{
	    //保存修改用药建议
	   s medAdvID=$p(Params,"!",1)
	   s medAdvContentList=$p(Params,"!",2)
	   d OutData.Write(##class(web.DHCSTPHCMMEDADV).InsPHMedAdvDetail(medAdvID,medAdvContentList))
	}
	elseif(action = "GetAdvMesByOeori")  
	{
	    //获取用药建议信息
	   s oeori=$p(Params,"^",1)
	   d OutData.Write(##class(web.DHCSTPHCMMEDADV).GetAdvMesByOeori(oeori))
	}
	elseif(action = "QueryAppDiagtList")  
	{
		/// 诊断信息本次/历次
		s offet=$p(Params,"!",1)
		s limit=$p(Params,"!",2)
		s PatID=$p(Params,"!",3)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMDIAGLIST).QueryAppDiagtList(offet,limit,PatID))
	}
	 elseif(action = "QueryAllergyList")  
	{
		/// 过敏记录信息
		s offet=$p(Params,"^",1)
		s limit=$p(Params,"^",2)
		s RegNo=$p(Params,"^",3)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMALLERGYLIST).QueryAllergyList(offet,limit,RegNo))
	}
	 elseif(action = "QueryPhConsult")  
	{
		/// 咨询信息
		s offet=$p(Params,"!",1)
		s limit=$p(Params,"!",2)
		s strParam=$p(Params,"!",3)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMCONSULTREPLY).QueryPhConsult(offet,limit,strParam))
	}
    elseif(action = "GetAllLoc")  
	{
     /// 获取科室
		s offet=$p(Params,"^",1)
		s limit=$p(Params,"^",2)
		s params=$p(Params,"^",3)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMCONSULTREPLY).GetAllLoc(offet,limit,params))
	}
	elseif(action = "setConsultComplete")  
	{
	    //修改状态
	   s consultID=$p(Params,"^",1)
	   s consComFlag=$p(Params,"^",2) 
	   d OutData.Write(##class(web.DHCSTPHCMCONSULTREPLY).setConsultComplete(consultID,consComFlag))
	}
	
	elseif(action = "QueryConsultBakDetList")  
	{
		///回复信息
		s offet=$p(Params,"^",1)
		s limit=$p(Params,"^",2)
		s consultID=$p(Params,"^",3)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMCONSULTREPLY).QueryConsultBakDetList(offet,limit,consultID))
	}
	elseif(action = "InsertConDet")  
	{
	    //消息回复
	   s consultID=$p(Params,"^",1)
	   s consUserID=$p(Params,"^",2)
	   s consDesc=$p(Params,"^",3)  
	   d OutData.Write(##class(web.DHCSTPHCMCONSULTREPLY).InsertConDet(consultID,consUserID,consDesc))
	}
	elseif(action = "getGuiScopePatCode")  
	{
	   ///获取指导范围
	   s ModType=$p(Params,"^",1)
	   s SubModType=$p(Params,"^",2)
	   s PatCode=$p(Params,"^",3)
       d OutData.CopyFrom(##Class(web.DHCSTPHCMEDUCATION).getGuiScopePatCode(ModType, SubModType, PatCode))
	}
	elseif(action = "GetPatOEInfo")  
	{
		///获取医嘱信息
		s rows=$p(Params,"^",1)
		s page=$p(Params,"^",2)
		s AdmDr=$p(Params,"^",3)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMEDUCATION).GetPatOEInfo(rows,page,AdmDr))
	}
	elseif(action = "getMedEducation")  
	{
		///获取New/Out院信息
		s AdmDr=$p(Params,"^",1)
		s curStatus=$p(Params,"^",2)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMEDUCATION).getMedEducation(AdmDr,curStatus))
	}
	elseif(action = "getMedEducationByEduID")  
	{
		///获取In院信息
		s medEduID=$p(Params,"^",1)
		s curStatus=$p(Params,"^",2)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMEDUCATION).getMedEducationByEduID(medEduID,curStatus))
	}
		elseif(action = "getMedEduDrgItm")    
	{
		///获取关注药品
		s medEduID=$p(Params,"^",1)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMEDUCATION).getMedEduDrgItm(medEduID))
	}
	
	elseif(action = "getMedEduRecord")  
	{
		///获取住院历史记录信息
		s offet=$p(Params,"^",1)
		s limit=$p(Params,"^",2)
		s AdmDr=$p(Params,"^",3)
		s curStatus="In" //$p(Params,"^",4)
		s startDate=$p(Params,"^",4)
		s endDate=$p(Params,"^",5)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMEDUCATION).getMedEduRecord(offet,limit,AdmDr,curStatus,startDate,endDate))
	}
	
	elseif(action = "getMeduGuid")  
	{
	    //通过medEduID获取指导信息
	   s medEduID=$p(Params,"^",1)
	   d OutData.CopyFrom(##class(web.DHCSTPHCMEDUCATION).getMeduGuid(medEduID))
	}
	elseif(action = "SaveMedEducation")  
	{
	   //保存修改用药教育
	   s medEduID=$p(Params,"#",1)
	   s medEduDataList=$p(Params,"#",2)
	   d OutData.Write(##class(web.DHCSTPHCMEDUCATION).SaveMedEducation(medEduID,medEduDataList))
	}
	
	elseif(action = "GetPatInfoByEmr")  
	{
	   //电子病例获取不良嗜好
	   s EpisodeID=$p(Params,"#",1)
	   d OutData.Write(##class(web.DHCSTPHCMEDUCATION).GetPatInfoByEmr(EpisodeID))
	}
    elseif(action = "GetPatInMRDiagnos")  
	{
	   //电子病例获取诊断信息
	   s EpisodeID=$p(Params,"#",1)
	   d OutData.Write(##class(web.DHCSTPHCMCOMMON).GetMRDiagnosByEpisodeID(EpisodeID))
	}
	elseif(action = "GetCheOEInfo")  
	{
	   //药品指标药品信息
	   s rows=$p(Params,"^",1)
	   s page=$p(Params,"^",2)
	   s EpisodeID=$p(Params,"^",3)
	   d OutData.CopyFrom(##class(web.DHCSTPHCMedIndexMonitoringInquiry).GetCheOEInfo(rows,page,EpisodeID))
	}
	
	elseif(action = "InspectionItems")  
	{
	   //药品指标指标信息
	   s EpisodeID=$p(Params,"^",1)
	   s incidesc=$p(Params,"^",2)
	   d OutData.CopyFrom(##class(web.DHCSTPHCMedIndexMonitoringInquiry).InspectionItems(EpisodeID,incidesc))
	}
	///医学查房
	elseif(action = "SaveMedWdRdInfor")  
	{
	   //保存医学查房信息
	   s cliPatID=$p(Params,"#",1)
	   s CPAdmDr=$p(Params,"#",2)
	   s cpDataList=$p(Params,"#",3)
	   s InsFlag=$p(Params,"#",4)   /// 首次查房 N , 日常查房 D
	   d OutData.Write(##class(web.DHCSTPHCMMedicalWardRound).SaveMedWdRdInfor(cliPatID,CPAdmDr,cpDataList,InsFlag))
	}
	elseif(action = "MedWdRdFInfor")  
	{
	   // 加载首次查房的信息
	   s AdmDr=Params
	   d OutData.CopyFrom(##class(web.DHCSTPHCMMedicalWardRound).GetMedWdRdFInfor(AdmDr,"first"))
	}
	elseif(action = "PatCompDiagnose")  
	{
	   // 加载病人的主诉和诊断信息
	   s AdmDr=Params
	   d OutData.Write(##class(web.DHCSTPHCMMedicalWardRound).GetCompDiagnose(AdmDr))
	}
	elseif(action = "MedWdRdDInfor")  
	{
		///获取医学查房日常查房信息
		s Rowid=Params
    	d OutData.Write(##Class(web.DHCSTPHCMMedicalWardRound).GetMedWdRdDInfor(Rowid))
	}
	elseif(action = "MedWdRdDRecord")  
	{
		///获取医学查房日常查房历史记录
		s rows=$p(Params,"^",1)
		s page=$p(Params,"^",2)
		s AdmDr=$p(Params,"^",3)
		s startDate=$p(Params,"^",4)
		s endDate=$p(Params,"^",5)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMMedicalWardRound).GetMedWdRdRecord(rows,page,AdmDr,startDate,endDate))
	}
	
    ///药学查房
    elseif(action = "PhaWdRdInfor")  
	{
	   // 加载出院/新入院患者信息
	   s AdmDr=$p(Params,"^",1)
	   s curStatus=$p(Params,"^",2)
	   d OutData.CopyFrom(##class(web.DHCSTPHCMPharmacywardround).GetPhaWardRound(AdmDr,curStatus))
	}
	
	 elseif(action = "GetWRDrgItm")  
	{
	   // 初始化重点关注药品的信息
	   s wardRoundID=Params
	   d OutData.CopyFrom(##class(web.DHCSTPHCMPharmacywardround).getWRDrgItm(wardRoundID))
	}
	
	 elseif(action = "getWRGuidance")  
	{
	   // 获取指导范围信息
	   s wardRoundID=Params
	   d OutData.CopyFrom(##class(web.DHCSTPHCMPharmacywardround).getWRGuidance(wardRoundID))
	}
	
    elseif(action = "GetPatInfoFromEmr")  
	{
	   // 加载病人 现病史 既往病史 个人史及家族史 过敏史 入院诊断(电子病历获取)
	   s EpisodeID=Params
	   d OutData.Write(##class(web.DHCSTPHCMPharmacywardround).GetPatInfoFromEmr(EpisodeID))
	}
	 elseif(action = "SavePhaWdRdInfor")  
	{
	   //保存药学查房信息
	   s wardRoundID=$p(Params,"#",1)
	   s wrDataList=$p(Params,"#",2)
	   d OutData.Write(##class(web.DHCSTPHCMPharmacywardround).SavePhaWdRdInfor(wardRoundID,wrDataList))
	}
	elseif(action = "PhaWardRecord")  
	{
		///获取药学查房住院期间患者历史记录
		s rows=$p(Params,"^",1)
		s page=$p(Params,"^",2)
		s AdmDr=$p(Params,"^",3)
		s startDate=$p(Params,"^",4)
		s endDate=$p(Params,"^",5)
    	d OutData.CopyFrom(##Class(web.DHCSTPHCMPharmacywardround).GetPhaWardRecord(rows,page,AdmDr,startDate,endDate))
	}
	elseif(action = "GetInPhaWardRound")  
	{
		///获取药学查房住院期间患者治疗方案信息
	   s Rowid=Params
	   d OutData.Write(##class(web.DHCSTPHCMPharmacywardround).GetInPhaWardRound(Rowid))
	}
	elseif(action = "PerService")  
	{
	    /// 个人药学服务列表
		s EpisodeID=$p(Params,"^",1)
		d OutData.CopyFrom(##Class(web.DHCSTPHCMPERPHARSERVICE).jsonPerPharSerPad(EpisodeID))
	}
	elseif(action = "PerServiceDet")  
	{
	    /// 个人药学服务明细
		s bsType=$p(Params,"^",1)
		s bsPoint=$p(Params,"^",2)
		d OutData.Write(##Class(web.DHCSTPHCMPERPHARSERVICE).jsonPerPharSerDetPad(bsType, bsPoint))
	}
	elseif(action = "GetSysConFTP")
	{
	    /// 获取系统FTP地址
		d OutData.Write(##Class(web.DHCSTPHCMPatBaseInfo).jsonGetSysConFTP())
	}
	Q ""
ERROR			
	//d argOutData.Write("[]")	 	        
	Q ""
}

}

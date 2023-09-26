/// Creator:李欣
/// Desc:旧表数据导入到新表中
/// Date:20180404
Class web.DHCBL.MKB.MKBDataImport Extends %RegisteredObject
{

/// 导入global
/// d ##class(web.DHCBL.MKB.MKBDataImport).InData()
ClassMethod InData()
{
	d $SYSTEM.OBJ.ImportDir("E:\","MKBData20190619.gof")
}

/// 上线部署导完数据后执行生成辅助数据
/// IndexFlag——""：中心词生成全文索引，1:中心词+属性内容生成全文索引，2:不生成全文索引
/// d ##class(web.DHCBL.MKB.MKBDataImport).DoAfterImport(IndexFlag)
ClassMethod DoAfterImport(IndexFlag As %String = "")
{
	d DISABLE^%NOJRN
	w ##class(web.DHCBL.MKB.MKBKLMappingDetail).CreateAllRepeatIndex()
	w ";规则管理数据处理",!
	
	d ##class(web.DHCBL.MKB.MKBMappingRely).RegenerateAll()
	w "规则管理MappingRely方法执行完毕",!
		
	d ##class(web.DHCBL.MKB.MKBStructIndex).GenerateIndex()
	w ";数据处理工厂全文检索",!
	
	if (IndexFlag'="2")
	{
		d ##class(web.DHCBL.MKB.BDPMKBIndex).SaveTermIdx(IndexFlag)
		w ";全文检索索引",!
	}
	;d ##class(web.DHCBL.MKB.MKBDataImport).LocConMigrate()
	;w ";规则管理-安贞科室对照---->科室对照",!
	d ENABLE^%NOJRN

	w "over"
}

/// 规则管理-安贞科室对照---->科室对照
/// w ##class(web.DHCBL.MKB.MKBDataImport).LocConMigrate()
ClassMethod LocConMigrate()
{
	k ^User.MKBLocContrastD
	k ^User.MKBLocContrastI
	
	s result=""
	s MKBKLMBRowId=$O(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))
	q:(MKBKLMBRowId="") "规则管理下没有安贞科室对照"
	s ProMFChild=$O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowId," 专业科室",0))
	s RealMFChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowId," 实际科室",0))	
	q:(ProMFChild="")||(RealMFChild="") "安贞科室对照里没有专业科室或实际科室列"
	s RowNum=0
	for
	{
		s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowId,RowNum))
		q:RowNum=""
		
		s ProMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMBRowId_"||"_ProMFChild,0))
		s RealMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMBRowId_"||"_RealMFChild,0))
		
		continue:ProMDRowId=""||RealMDRowId=""
		s ProTermId=$LG($G(^User.MKBKLMappingDetailD(ProMDRowId)),2)
		s RealTermId=$LG($G(^User.MKBKLMappingDetailD(RealMDRowId)),2)				
		continue:ProTermId=""||RealTermId=""
		s ProLocDesc = $LG($G(^User.MKBTermD(ProTermId)),3)    //专业科室描述
		s RealLocDesc = $LG($G(^User.MKBTermD(RealTermId)),3)	//实际科室描述 
		s CTLocID =""
		s:RealLocDesc'="" CTLocID = $O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RealLocDesc),0))
		continue:CTLocID=""		
		s obj=##class(User.MKBLocContrast).%New()
		d obj.MKBCTLocDrSetObjectId(CTLocID)
		d obj.MKBLocDrSetObjectId(ProTermId)
		s sc= obj.%Save()
		IF $$$ISOK(sc){
			s:result'="" result=result_","
			s result=result_ProLocDesc_"对照"_RealLocDesc
		}
	}
	if (result'="")
	{
		s result=result_"失败"
	}
	else
	{
		s result="科室对照完成"		
	}
	q result
}

/// Creator:李欣	
/// Desc:导入所有数据
/// d ##class(web.DHCBL.MKB.MKBDataImport).ImportAll()
ClassMethod ImportAll()
{
	k ^TMP("MKB","TPDCode")
	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermBase()
	//在TKBTremBaseField 表上建ParRefIndex索引,buildindices()
	//d ##class(User.//在TKBTremBaseField).%BuildIndices()
	//Index ParRefIndex On ParRef As Exact;

	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTerm()
	d ##class(web.DHCBL.MKB.MKBDataImport).LastLevel()
	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermBaseCat()
	//在TKBTremExtendCat表ParRef索引,buildindices()
	//d ##class(User.TKBTremExtendCat).%BuildIndices()
	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermProperty()
	d ##class(web.DHCBL.MKB.MKBDataImport).SetTreeSData()

	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermProDetail()
	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermProDetailLastLevel()
	
	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermProDetailP()
	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermExtendProVal()
	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermBaseProperty()

	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermProDetailS()
	d ##class(web.DHCBL.MKB.MKBDataImport).TKBTremBaseField()
	//d ##class(web.DHCBL.MKB.MKBDataImport).TKBTremItm()
	/***********************在TKBTremCom表建立Tre\Type索引，BuildIndices********************************/
	//d ##class(User.TKBTremCom).%BuildIndices()
	d ##class(web.DHCBL.MKB.MKBDataImport).TKBTremCom()
	d ..DealSProDesc()
	d ..ClearTSLastLevel()
	d ##class(web.DHCBL.MKB.MKBDataImport).ReBuildZSMForJPX()
	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermBaseSeq()
	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermBasePropertySeq()
	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermSeq()
	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermProDetailSeq()
	d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermPropertySeq()
	d ##class(web.DHCBL.MKB.MKBDataImport).BJICD()
	d ##class(web.DHCBL.MKB.MKBDataImport).HisICD()
	d ##class(web.DHCBL.MKB.MKBDataImport).SetCS()
	
	d ##class(web.DHCBL.MKB.ICDRelationData).HISICD()
	d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).SaveData2()
	d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).SaveData3()
	d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).SaveData4()
	d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).SaveData5()
	w ##class(web.DHCBL.MKB.MKBTermProDetail).SaveTermIdx()
}

/// Creator:李欣	
/// Desc:k掉医用知识库所有数据
/// d ##class(web.DHCBL.MKB.MKBDataImport).Kill()
ClassMethod Kill()
{
	b ;确定要删除知识库的所有数据吗？确定的话输 g 不确定输 q
	;d ..DeleteMKBTermBase()
	//知识库注册
	k ^User.MKBTermBaseD	//术语库注册表 
	k ^User.MKBTermBaseI	//术语库注册表 
	k ^User.MKBTermBasePropertyI	//术语库注册属性表 
	k ^User.MKBTermBasePropertyD	//术语库注册属性表
	k ^User.MKBTermBasePropertyC	//术语库注册属性表	
 	k ^User.MKBTermBaseExtendProI	//术语库注册扩展属性表
 	
 	//知识管理
 	k ^User.MKBTermD	//术语表
 	k ^User.MKBTermI	//术语表
	k ^User.MKBTermPropertyD	//术语维护属性表
	k ^User.MKBTermPropertyI	//术语维护属性表
	k ^User.MKBTermPropertyC	//术语属性表
	k ^User.MKBTermExtendProI	//术语扩展属性表
	k ^User.MKBTermProDetailD	//术语属性内容表
	k ^User.MKBTermProDetailI	//术语属性内容表
	k ^User.MKBTermExtendProValD	//扩展属性值表
	k ^User.MKBTermExtendProValI	//扩展属性值表
	;k ^User.MKBBookMarksD      //收藏夹
	;k ^User.MKBBookMarksI     //收藏夹
	
	//规则管理
	k ^User.MKBKLMappingDetailD
	k ^User.MKBKLMappingDetailI
	k ^User.MKBKLMappingBaseD
	k ^User.MKBKLMappingBaseI
	k ^User.MKBKLMappingBaseC
	k ^User.MKBKLMappingBaseFieldI
	//评估表
	k ^User.MKBAssessmentBaseD
	k ^User.MKBAssessmentBaseI
	k ^User.MKBAssessmentBaseC
	k ^User.MKBAssessmentBaseFieldI
	k ^User.MKBAssessmentScoringRulesI
	
	//接口管理表
	k ^User.MKBInterfaceManageD
	k ^User.MKBInterfaceManageI
	//业务执行表
	k ^User.MKBBusExecuteD
	k ^User.MKBBusExecuteI
	
	//文献管理
	k ^User.MKBDocManageD	
	k ^User.MKBDocManageI	
	
	//批处理
	k ^User.MKBBatchProcessD
	k ^User.MKBBatchProcessI
	
	//用户使用习惯
	/*k ^User.BDPUserHabitHisUiD	
	k ^User.BDPUserHabitHisUiI
	k ^User.BDPDataHistoryD
	k ^User.BDPDataHistoryI
	k ^User.BDPDataFrequencyD
	k ^User.BDPDataFrequencyI*/
	
	///数据处理工厂
	k ^User.MKBStructuredDataD
	k ^User.MKBStructuredDataI
	k ^User.MKBStructuredDataResultI
	k ^User.MKBStructuredDataLocI
	k ^User.MKBStructuredDataOtherI
	k ^User.MKBStructuredBaseD
	k ^User.MKBStructuredBaseI
	
	//ICD对照
	k ^User.MKBICDContrastD
	k ^User.MKBICDContrastI
	k ^User.MKBICDContrastResultI
	
	///HISICD对照
	k ^User.MKBHISICDContrastD
	k ^User.MKBHISICDContrastI
	k ^User.MKBHISICDContrastResultI
	
	//后台引用表
	k ^User.MKBReferenceD	//引用表
	k ^User.MKBReferenceI	//引用表
	k ^User.MKBMappingSortRelyD
	k ^User.MKBMappingSortRelyI
	k ^User.MKBMappingTermRelyD
	k ^User.MKBMappingTermRelyI
	k ^User.MKBDataStatisticsD
	k ^User.MKBDataStatisticsI	
	k ^User.MKBICDRelyD
	k ^User.MKBICDRelyI
	
	//全文索引
	k ^User.BDPMKBIndexD
	k ^User.BDPMKBIndexI
	
	//各版本手术对照
	k ^User.MKBOperationContrastD
	k ^User.MKBOperationContrastI
	k ^User.MKBOperationResultI
	
	//平台配置
	k ^User.MKBConfigD
	k ^User.MKBConfigI
	
	;k ^User.SDSStructDiagnosD
	;k ^User.SDSStructDiagnosI
	;k ^User.SDSStructDiagnosLogD
	;k ^User.SDSStructDiagnosLogI
	;k ^User.SDSStructDiagnosLinkD
	;k ^User.SDSStructDiagnosLinkI
	;k ^User.SDSStructDiagnosApplyD
	;k ^User.SDSStructDiagnosApplyI
	;k ^User.SDSAssessmentD
	;k ^User.SDSAssessmentI
	;k ^User.SDSStructDiagnosICDD
	;k ^User.SDSStructDiagnosICDI
	;k ^User.SDSStructDiagnosMasterD
	;k ^User.SDSStructDiagnosMasterI
}

/// Creator:李欣	
/// Desc：删除TermBase表数据及对应的菜单数据
ClassMethod DeleteMKBTermBase()
{
	s MKBTBRowId = 0
	for
	{
		s MKBTBRowId = $O(^User.MKBTermBaseD(MKBTBRowId))
		q:MKBTBRowId=""
		w $LG($G(^User.MKBTermBaseD(MKBTBRowId)),3),!
		s Code = $LG($G(^User.MKBTermBaseD(MKBTBRowId)),2) 
		s menuID=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM."_$ZCONVERT(Code,"U"),0))
		d ##class(User.MKBTermBase).%DeleteId(MKBTBRowId)
		d ##class(User.BDPMenu).%DeleteId(menuID)
	}
}

/// 李欣 20180912
/// Desc : 重新生成全文检索的global
/// d ##class(web.DHCBL.MKB.MKBDataImport).ReBuildMKBIndex()
ClassMethod ReBuildMKBIndex()
{
	k ^User.BDPMKBIndexD
	k ^User.BDPMKBIndexI
	d ##class(web.DHCBL.MKB.BDPMKBIndex).SaveTermIdx()
}

/// Creator:李欣	
/// Desc:导出医用知识库global
/// d ##class(web.DHCBL.MKB.MKBDataImport).ExportMKBGlobal()
ClassMethod ExportMKBGlobal()
{
	k CList
	k myIdx
	
	//知识库注册
	s CList($i(CList))= "User.MKBTermBaseD.GBL"  //术语库注册表
    s CList($i(CList))= "User.MKBTermBaseI.GBL" //术语库注册表
    s CList($i(CList))= "User.MKBTermBasePropertyI.GBL"  //术语库注册属性表 
    s CList($i(CList))= "User.MKBTermBasePropertyD.GBL" //术语库注册属性表 
    s CList($i(CList))= "User.MKBTermBasePropertyC.GBL" //术语库注册属性表 
    s CList($i(CList))= "User.MKBTermBaseExtendProI.GBL" //术语库注册扩展属性表
    //知识管理
    s CList($i(CList))= "User.MKBTermD.GBL"  //术语表
    s CList($i(CList))= "User.MKBTermI.GBL"  //术语表
	s CList($i(CList))= "User.MKBTermPropertyD.GBL"  //术语维护属性表
	s CList($i(CList))= "User.MKBTermPropertyI.GBL"  //术语维护属性表
	s CList($i(CList))= "User.MKBTermPropertyC.GBL"  //术语属性表
	s CList($i(CList))= "User.MKBTermExtendProI.GBL" //术语扩展属性表
	s CList($i(CList))= "User.MKBTermProDetailD.GBL" //术语属性内容表
	s CList($i(CList))= "User.MKBTermProDetailI.GBL" //术语属性内容表
	s CList($i(CList))= "User.MKBTermExtendProValD.GBL" //扩展属性值表
	s CList($i(CList))= "User.MKBTermExtendProValI.GBL" //扩展属性值表
	;s CList($i(CList))= "User.MKBBookMarksD.GBL"   //收藏夹
	;s CList($i(CList))= "User.MKBBookMarksI.GBL"
	//规则管理
	s CList($i(CList))= "User.MKBKLMappingBaseD.GBL"
	s CList($i(CList))= "User.MKBKLMappingBaseI.GBL"
	s CList($i(CList))= "User.MKBKLMappingBaseC.GBL"
	s CList($i(CList))= "User.MKBKLMappingBaseFieldI.GBL"
	s CList($i(CList))= "User.MKBKLMappingDetailD.GBL"
	s CList($i(CList))= "User.MKBKLMappingDetailI.GBL"
	//评估表
	s CList($i(CList))= "User.MKBAssessmentBaseD.GBL"
	s CList($i(CList))= "User.MKBAssessmentBaseI.GBL"
	s CList($i(CList))= "User.MKBAssessmentBaseC.GBL"
	s CList($i(CList))= "User.MKBAssessmentBaseFieldI.GBL"		
	s CList($i(CList))= "User.MKBAssessmentScoringRulesI.GBL"
	
	//接口管理表
	s CList($i(CList))= "User.MKBInterfaceManageD.GBL"
	s CList($i(CList))= "User.MKBInterfaceManageI.GBL"
	//业务执行表
	s CList($i(CList))= "User.MKBBusExecuteD.GBL"
	s CList($i(CList))= "User.MKBBusExecuteI.GBL"
	//文献管理
	s CList($i(CList))= "User.MKBDocManageD.GBL"
	s CList($i(CList))= "User.MKBDocManageI.GBL"	
	
	//批处理
	s CList($i(CList))= "User.MKBBatchProcessD.GBL"
	s CList($i(CList))= "User.MKBBatchProcessI.GBL"
	
	///数据处理工厂
	s CList($i(CList))= "User.MKBStructuredDataD.GBL"
	s CList($i(CList))= "User.MKBStructuredDataI.GBL"
	s CList($i(CList))= "User.MKBStructuredDataResultI.GBL"
	s CList($i(CList))= "User.MKBStructuredDataLocI.GBL"
	s CList($i(CList))= "User.MKBStructuredDataOtherI.GBL"
	s CList($i(CList))= "User.MKBStructuredBaseD.GBL"
	s CList($i(CList))= "User.MKBStructuredBaseI.GBL"
	
	//各版本ICD对照
	s CList($i(CList))= "User.MKBICDContrastD.GBL"
	s CList($i(CList))= "User.MKBICDContrastI.GBL"
	s CList($i(CList))= "User.MKBICDContrastResultI.GBL"
	
	//HIS ICD对照
	s CList($i(CList))= "User.MKBHISICDContrastD.GBL"
	s CList($i(CList))= "User.MKBHISICDContrastI.GBL"
	s CList($i(CList))= "User.MKBHISICDContrastResultI.GBL"
	
	//后台引用表
	s CList($i(CList))= "User.MKBReferenceD.GBL"
	s CList($i(CList))= "User.MKBReferenceI.GBL"
	s CList($i(CList))= "User.MKBMappingSortRelyD.GBL"
	s CList($i(CList))= "User.MKBMappingSortRelyI.GBL"
	s CList($i(CList))= "User.MKBMappingTermRelyD.GBL"
	s CList($i(CList))= "User.MKBMappingTermRelyI.GBL"
	s CList($i(CList))= "User.MKBDataStatisticsD.GBL"
	s CList($i(CList))= "User.MKBDataStatisticsI.GBL"
	s CList($i(CList))= "User.MKBICDRelyD.GBL"
	s CList($i(CList))= "User.MKBICDRelyI.GBL"
	
	//各版本手术对照
	s CList($i(CList))= "User.MKBOperationContrastD.GBL"
	s CList($i(CList))= "User.MKBOperationContrastI.GBL"
	s CList($i(CList))= "User.MKBOperationResultI.GBL"
	
	//平台配置
	s CList($i(CList))= "User.MKBConfigD.GBL"
	s CList($i(CList))= "User.MKBConfigI.GBL"
	//全文索引表
	;s CList($i(CList))= "User.BDPMKBIndexD.GBL"
	;s CList($i(CList))= "User.BDPMKBIndexI.GBL"
	
	//结构化诊断相关
	/*
	s CList($i(CList))= "User.SDSStructDiagnosD.GBL"
	s CList($i(CList))= "User.SDSStructDiagnosI.GBL"
	s CList($i(CList))= "User.SDSStructDiagnosLogD.GBL"
	s CList($i(CList))= "User.SDSStructDiagnosLogI.GBL"
	s CList($i(CList))= "User.SDSStructDiagnosLinkD.GBL"
	s CList($i(CList))= "User.SDSStructDiagnosLinkI.GBL"
	s CList($i(CList))= "User.SDSStructDiagnosApplyD.GBL"
	s CList($i(CList))= "User.SDSStructDiagnosApplyI.GBL"
	s CList($i(CList))= "User.SDSAssessmentD.GBL"
	s CList($i(CList))= "User.SDSAssessmentI.GBL"
	s CList($i(CList))= "User.SDSStructDiagnosICDD.GBL"
	s CList($i(CList))= "User.SDSStructDiagnosICDI.GBL"
	s CList($i(CList))= "User.SDSStructDiagnosMasterD.GBL"
	s CList($i(CList))= "User.SDSStructDiagnosMasterI.GBL"
	*/
		
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = "D:\MKBGlobal\NewTable\MKBData"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	s time = $zd(+$H-10,3)
	w time,!
	s filename = "D:\MKBGlobal\NewTable\MKBData"_time_".gof"
	s filename = $tr(filename,"-","")
	s flag = ##class(%Library.File).Exists(filename,"")
	d:flag=1 ##class(%Library.File).ComplexDelete(filename,"")
	d ..CalcuKnoNum()
}

/// Creator:李欣	
/// Desc:计算知识量
/// d ##class(web.DHCBL.MKB.MKBDataImport).CalcuKnoNum()
ClassMethod CalcuKnoNum()
{
	s MKBTBRowId=0
	for
	{
		s MKBTBRowId=$O(^User.MKBTermBaseD(MKBTBRowId))	
		q:MKBTBRowId=""
		
		s MKBTRowId=0
		for
		{
			s MKBTRowId=$O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))	
			q:MKBTRowId=""
			
			s num=0
			s MKBTPRowId=0
			for
			{
				s MKBTPRowId=$O(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId))
				q:MKBTPRowId=""
				
				s MKBTPDRowId=0
				for
				{
					s MKBTPDRowId=$O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
					q:MKBTPDRowId=""
					
					s num=num+1	
				}	
			}
			s obj = ##class(User.MKBTerm).%OpenId(MKBTRowId)
			s obj.MKBTDetailCount=num
			d obj.%Save()
		}
		
	}
}

/// Creator:谷雪萍
/// CreatDate:2020-04-24
/// Description:保存频次数据
/// Table:User.BDPDataFrequency
/// Input:RowId-表数据的id，Desc-表数据的描述，TableName-表名，UserId-用户id，LocId-科室id
/// Return:0-保存失败，1-保存成功
/// w ##class(web.DHCBL.MKB.MKBDataImport).SaveFrequencyData(UserId, LocId, TableName, RowId, Desc)
ClassMethod SaveFrequencyData(UserId, LocId, TableName, RowId, Desc) As %String
{
	q:(TableName="")||(RowId="")||(Desc="")||(UserId="")||(LocId="") 0
	s result=""
	s obj = ##class(User.BDPDataFrequency).%New()
	d obj.BDPCTLocDRSetObjectId(LocId)	
	d obj.BDPDAFUserIDSetObjectId(UserId)
	s obj.BDPDAFDataReference = RowId
	s obj.BDPDAFDesc = Desc
	s obj.BDPDAFFrequency = 1
	s obj.BDPDAFTableName = TableName
	s sc = obj.%Save()
	do obj.%Close()
	if $$$ISOK(sc)  //保存成功
	{
		s result = 1
	}
	else
	{
		s result = 0
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2020-04-24
/// Description:初始化医用知识库频次
/// Table:User.BDPDataFrequency
/// Input:UserId-用户id，LocId-科室id
/// Return:频次保存失败/频次保存成功
/// d ##class(web.DHCBL.MKB.MKBDataImport).SaveFrequency(UserId, LocId)
ClassMethod SaveFrequency(UserId, LocId)
{
	q:(UserId="")||(LocId="") "没有获取到用户ID和科室ID，频次保存失败!"

	s result=""
	s flag=1 //错误标识	
	TS
	
	//遍历知识库注册
	s MKBTBRowId = 0
	for
	{
		s MKBTBRowId = $O(^User.MKBTermBaseD(MKBTBRowId))
		q:(MKBTBRowId="")||(flag=0)
		
		//如果频次表中没有该数据
		if ($D(^User.BDPDataFrequencyI("TableReferenceIdx"," USER.MKBTERMBASE"," "_MKBTBRowId))=0)
		{
			s MKBTBDesc = $LG($G(^User.MKBTermBaseD(MKBTBRowId)),3)
			continue:MKBTBDesc=""
			s TableName = "User.MKBTermBase"
			s flag=..SaveFrequencyData(UserId,LocId,TableName,MKBTBRowId,MKBTBDesc)
			if (flag=0)
			{
				s result="频次保存失败：知识库注册-"_MKBTBRowId
				q 
			}
		}
		
		//遍历公有属性
		s MKBTBPRowId = 0
		for
		{
			s MKBTBPRowId = $O(^User.MKBtermBasePropertyI("BaseTermIdx",MKBTBRowId,MKBTBPRowId))
			q:(MKBTBPRowId="")||(flag=0)
			
			//如果频次表中没有该数据
			if ($D(^User.BDPDataFrequencyI("TableReferenceIdx"," USER.MKBTERMBASEPROPERTY"_MKBTBRowId," "_MKBTBPRowId))=0)
			{
				s MKBTBPDesc = $LG($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),3)
				continue:MKBTBPDesc=""
				s TableName = "User.MKBTermBaseProperty"_MKBTBRowId
				s flag=..SaveFrequencyData(UserId,LocId,TableName,MKBTBPRowId,MKBTBPDesc)
				if (flag=0)
				{
					s result="频次保存失败：知识库注册属性-"_MKBTBPRowId
					q 
				}	
			}	
		}
		
		//遍历术语
		s MKBTRowId = 0
		for
		{
			s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
			q:(MKBTRowId="")||(flag=0)
			
			if ($D(^User.BDPDataFrequencyI("TableReferenceIdx"," USER.MKBTERM"_MKBTBRowId," "_MKBTRowId))=0)
			{
				s MKBTDesc = $LG($G(^User.MKBTermD(MKBTRowId)),3)
				continue:MKBTDesc=""
				s TableName = "User.MKBTerm"_MKBTBRowId
				s flag=..SaveFrequencyData(UserId,LocId,TableName,MKBTRowId,MKBTDesc)
				if (flag=0)
				{
					s result="频次保存失败：术语-"_MKBTRowId
					q 
				}	
			}
			
			//遍历术语属性
			s MKBTPRowId=0
			for
			{
				s MKBTPRowId = $O(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId))
				q:(MKBTPRowId="")||(flag=0)
				
				if ($D(^User.BDPDataFrequencyI("TableReferenceIdx"," USER.MKBTERMPROPERTY"_MKBTRowId," "_MKBTPRowId))=0)
				{
					s MKBTPDesc = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),3)
					continue:MKBTPDesc=""
					s TableName = "User.MKBTermProperty"_MKBTRowId
					s flag=..SaveFrequencyData(UserId,LocId,TableName,MKBTPRowId,MKBTPDesc)
					if (flag=0)
					{
						s result="频次保存失败：术语属性-"_MKBTPRowId
						q 
					}		
				}
				s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4) //属性类型
				continue:(MKBTPType'="L")&(MKBTPType'="T") //如果不是列表和树形不需要执行下面内容
				//遍历属性内容
				s MKBTPDRowId = 0
				for
				{
					s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
					q:(MKBTPDRowId="")||(flag=0)
					
					if ($D(^User.BDPDataFrequencyI("TableReferenceIdx"," USER.MKBTERMPRODETAIL"_MKBTPRowId," "_MKBTPDRowId))=0)
					{
						s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
						continue:MKBTPDDesc=""
						s TableName = "User.MKBTermProDetail"_MKBTPRowId
						s flag=..SaveFrequencyData(UserId,LocId,TableName,MKBTPDRowId,MKBTPDDesc)
						if (flag=0)
						{
							s result="频次保存失败：术语属性内容-"_MKBTPDRowId
							q 
						}		
					}

					
				}
				
			}
		}
	}
	
	if (result'="")
	{
		Trollback
	}
	else
	{
		TC	
		s result="频次保存成功！"
	}
	q result
}

/// Creator:李欣	
/// Desc:导入TermBase表数据
/// d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermBase()
ClassMethod MKBTermBase()
{
	s result=""
	s TKBID = 0
	for
	{
		s TKBID = $o(^User.TKBTremBaseD(TKBID))	
		q:TKBID=""
		s MKBObj = ##class(User.MKBTermBase).%New()
		s TKBObj = ##class(User.TKBTremBase).%OpenId(TKBID)
		s MKBObj.MKBTBCode = TKBObj.TKBTRBCode
		s MKBObj.MKBTBDesc = TKBObj.TKBTRBDesc
		s MKBObj.MKBTBFlag = TKBObj.TKBTRBFlag
		s MKBObj.MKBTBNote = TKBObj.TKBTRBNote
		s MKBObj.MKBTBPYCode = TKBObj.TKBTRBPYCode
		s MKBObj.MKBTBSequence = TKBObj.TKBTRBSequence
		s MKBObj.MKBTBSource = TKBObj.TKBTRBSource
		s MKBObj.MKBTBType = TKBObj.TKBTRBType
		s MKBObj.MKBTBVersion = TKBObj.TKBTRBVersion
		d MKBObj.%Save()
		s MKBObjRowId = MKBObj.%Id()
		
		s menuobj=##class(User.BDPMenu).%New()
   		s menuobj.Code = "dhc.bdp.mkb.mtm."_MKBObj.MKBTBCode           
		s menuobj.Caption = MKBObj.MKBTBDesc   
		s menuobj.LinkFuntionDR=""   
		if (MKBObj.MKBTBDesc="诊断_ICD相关业务"){
   			s menuobj.LinkUrl = "dhc.bdp.mkb.mkbicdrelation.csp" 
   		}else{
	   		s menuobj.LinkUrl = "dhc.bdp.mkb.mkblistterm.csp" 
	   	}     
		s ParentMenuDr=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM",0))
		d menuobj.ParentMenuDrSetObjectId(ParentMenuDr)
		s menuobj.Sequence = MKBObj.MKBTBSequence //##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence(ParentMenuDr)
		s menuobj.ValueExpression="&base="_MKBObjRowId
		//s menuobj.actMenuBDP="1"
		//s menuobj.actMenuAutItem="1"
		//s menuobj.actMenuAutData="1"
		s menuobj.ActiveFlag="1^1^1"
		s menuobj.IsMKBMenu="Y"
		s menuobj.UpdateDate = +$p($h,",",1)
		s menuobj.UpdateTime = +$p($h,",",2)
		d menuobj.UpdateUserSetObjectId(1)
		
		s sc = menuobj.%Save()
   			
		d TKBObj.%Close()
		if $$$ERROR(sc)
		{
			s code = $SYSTEM.Status.GetErrorText(sc)
			b
		}
	}
}

/// TKBTremBaseExtend->MKBTermBaseProperty
/// TKBTremBaseExtendCat->MKBTermBaseExtendPro
/// Creator:李欣	
/// Desc:导入TermBaseProperty表及TermBaseExtendPro表数据	
/// Other:d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermBaseProperty()
ClassMethod MKBTermBaseProperty()
{
	//TS
	s TKBTBRowId =0 //User.TKBTremBase表RowId
	for
	{
		s TKBTBRowId = $o(^User.TKBTremBaseD(TKBTBRowId)) //遍历User.TKBTremBase表
		q:TKBTBRowId=""
		s TKBTBDesc = $LG($G(^User.TKBTremBaseD(TKBTBRowId)),3) //User.TKBTremBase表描述
		s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," "_TKBTBDesc,0)) //通过MKBTermBase表DescIndex索引获取新表中RowId
		s TKBTBERowId = 0 //TKBTremBaseExtend表RowId
		for
		{
			s TKBTBERowId = $o(^User.TKBTremBaseExtendI("TremBaseIdx",TKBTBRowId,TKBTBERowId)) //通过BaseDR索引取出所有有效数据
			q:TKBTBERowId=""
			s TKBTBEObj = ##class(User.TKBTremBaseExtend).%OpenId(TKBTBERowId) //原User.TKBTremExtend表对象
			s MKBTBPObj = ##class(User.MKBTermBaseProperty).%New()	//新建User.MKBTermBase表对象
			
			d MKBTBPObj.MKBTBPBaseDrSetObjectId(MKBTBRowId)
			s MKBTBPObj.MKBTBPCode = TKBTBEObj.TKBTRBECode
			s MKBTBPObj.MKBTBPDesc = TKBTBEObj.TKBTRBEDesc
			s MKBTBPObj.MKBTBPFlag = TKBTBEObj.TKBTRBEFlag
			s MKBTBPObj.MKBTBPName = TKBTBEObj.TKBTRBEName
		
			if (TKBTBEObj.TKBTRBEType="C")
			{
				s MKBTBPObj.MKBTBPType = "P" 	
			}
			elseif (TKBTBEObj.TKBTRBEType="S")
			{
				continue:TKBTBEObj.TKBTRBESourceDr=""
				s MKBTBPObj.MKBTBPType = "S"
				s TKBBaseDesc = $LG($G(^User.TKBTremBaseD(TKBTBEObj.TKBTRBESourceDr.%Id())),3)	
				s MKBTBID = $O(^User.MKBTermBaseI("DescIndex"," "_TKBBaseDesc,0))
				s MKBTBPObj.MKBTBPConfig = MKBTBID
			}
			else
			{
				s MKBTBPObj.MKBTBPType = TKBTBEObj.TKBTRBEType	
			}
			
			
			d TKBTBEObj.%Close()
			s sc = MKBTBPObj.%Save()
			If $$$ERROR(sc)
			{
				s code = $SYSTEM.Status.GetErrorText(sc)
				b
			}
			
			if (MKBTBPObj.MKBTBPType="S")
			{
				if (MKBTBPObj.MKBTBPConfig="")
				{
					b	
				}
				s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","BP",MKBTBPObj.%Id(),"B",MKBTBPObj.MKBTBPConfig)
				if (result["error")
				{
					b	
				}	
			}
			s MKBTBPRowId = MKBTBPObj.%Id()
			// TKBTremBaseExtendCat->MKBTermBaseExtendPro
			s TKBTBECChildSub=0
			for
			{
				s TKBTBECChildSub = $O(^User.TKBTremBaseExtendCatI("ParRefIndex",TKBTBERowId,TKBTBECChildSub)) //根据建立在BaseExtendCat表BaseExtendDr上的索引获取所有相关子表数据
				q:TKBTBECChildSub=""
				s TKBTBECRowId = TKBTBERowId_"||"_TKBTBECChildSub
				s TKBTBECObj = ##class(User.TKBTremBaseExtendCat).%OpenId(TKBTBECRowId) //原User.TKBTremBaseExtendCat表对象
				if (TKBTBECObj.TKBTRBECType="U")
				{
					continue	
				}
				if (TKBTBECObj.TKBTRBECType="S")||(TKBTBECObj.TKBTRBECType="SD")
				{
					if ($D(^User.TKBTremBaseD(TKBTBECObj.TKBTRBECConfig))=0)
					{
						continue	
					}	
				}
				s MKBTBEPObj = ##class(User.MKBTermBaseExtendPro).%New(MKBTBPRowId) //新建User.MKBTermBaseExtendPro表对象
				d MKBTBEPObj.ParRefSetObjectId(MKBTBPRowId)
				s MKBTBEPObj.MKBTBEPName = TKBTBECObj.TKBTRBECName
				
				s MKBTBEPObj.MKBTBEPType = TKBTBECObj.TKBTRBECType
				if (TKBTBECObj.TKBTRBECType="T")
				{
					s MKBTBEPObj.MKBTBEPType = "TX"	
				}
				s MKBTBEPObj.MKBTBEPConfig = TKBTBECObj.TKBTRBECConfig
				if (TKBTBECObj.TKBTRBECType="S")||(TKBTBECObj.TKBTRBECType="SD")
				{
					s BaseID=TKBTBECObj.TKBTRBECConfig
					s BaseDesc = $LG($G(^User.TKBTremBaseD(BaseID)),3)
					s MKBBaseID = $O(^User.MKBTermBaseI("DescIndex"," "_BaseDesc,0)) //通过MKBTermBase表DescIndex索引获取新表中RowId
					s MKBTBEPObj.MKBTBEPConfig = MKBBaseID
					s MKBTBEPObj.MKBTBEPType = TKBTBECObj.TKBTRBECType
					
				}
				d TKBTBECObj.%Close()
				s code = ""
				
				d MKBTBEPObj.%Save()
				/*引用表数据维护*/
				if (MKBTBEPObj.MKBTBEPType="S")
				{
					s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","BE",MKBTBEPObj.%Id(),"B",MKBTBEPObj.MKBTBEPConfig)
					if (result["error")
					{
						b	
					}
				}
			}	
		}
	}
	w "MKBTermBaseProperty",!
}

/// Half TKBTremBaseFiled->MKBTermBaseProperty
/// Creator:李欣	
/// Desc:将TKBTremBaseFiled表中标识为空的数据导入TermBaseProperty表中
/// Other:d ##class(web.DHCBL.MKB.MKBDataImport).TKBTremBaseField()
ClassMethod TKBTremBaseField()
{
	S TKBTBRowId = 0
	FOR
	{
		
		S TKBTBRowId = $O(^User.TKBTremBaseFieldI("ParRefIndex",TKBTBRowId))
		Q:TKBTBRowId=""
		S TKBTRDesc=$LG($G(^User.TKBTremBaseD(TKBTBRowId)),3)
		S MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," "_TKBTRDesc,0)) //根据描述获取新医用知识库User.MKBTermBase表对应RowId
		
		S ChildSub = 0
		FOR
		{
			S ChildSub = $O(^User.TKBTremBaseFieldI("ParRefIndex",TKBTBRowId,ChildSub))
			Q:ChildSub=""
			S TKBTBFRowId = TKBTBRowId_"||"_ChildSub
			
			S TKBTBFObj = ##class(User.TKBTremBaseField).%OpenId(TKBTBFRowId) //打开原有字段表对象
			
			I (TKBTBFObj.TKBTRBFlag'="")
			{
				Continue	
			}
			I (TKBTBFObj.TKBTRBType="U")
			{
				Continue	
			}
			I (TKBTBFObj.TKBTRBType="S")
			{
				S BaseID = TKBTBFObj.TKBTRBConfig
				IF (BaseID="")||($D(^User.TKBTremBaseD(BaseID))=0)
				{
					Continue	
				}
			}
			S MKBTBPObj = ##class(User.MKBTermBaseProperty).%New()
			S MKBTBPObj.MKBTBPCode = TKBTBFObj.TKBTRBCode
			s MKBTBPObj.MKBTBPConfig=TKBTBFObj.TKBTRBConfig
			S MKBTBPObj.MKBTBPDesc = TKBTBFObj.TKBTRBDesc
			if (TKBTBFObj.TKBTRBDesc="部位")
			{
				S MKBTBPObj.MKBTBPDesc = TKBTBFObj.TKBTRBDesc_"字段"	
			}
			
			s MKBTBPObj.MKBTBPType = TKBTBFObj.TKBTRBType
			//w TKBTBFObj.TKBTRBDesc,!
			D MKBTBPObj.MKBTBPBaseDrSetObjectId(MKBTBRowId)
			S MKBTBPObj.MKBTBPName = MKBTBPObj.MKBTBPDesc
			S MKBTBPObj.MKBTBPFlag = TKBTBFObj.TKBTRBFlag 
			if (TKBTBFObj.TKBTRBType="S")
			{
				S BaseID = TKBTBFObj.TKBTRBConfig
				S BaseDesc = $LG($G(^User.TKBTremBaseD(BaseID)),3)
				S MKBBaseID = $O(^User.MKBTermBaseI("DescIndex"," "_BaseDesc,0))
				S MKBTBPObj.MKBTBPConfig=MKBBaseID
			}
			if (TKBTBFObj.TKBTRBType="T")
			{
				s MKBTBPObj.MKBTBPType = "TX"
			}

			
			s sc=MKBTBPObj.%Save()
			/*引用表数据维护*/
			if (MKBTBPObj.MKBTBPType="S")
			{
				s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","BP",MKBTBPObj.%Id(),"B",MKBTBPObj.MKBTBPConfig)
				if (result["error")
				{
					b	
				}
			}
			/*引用表数据维护*/
			if $$$ERROR(sc)
			{
				s code = $SYSTEM.Status.GetErrorText(sc)
				b	
			}
			s MKBTRowId = 0
			for
			{
				//b
				//w $LG($G(^User.MKBTermD(MKBTRowId)),3),TKBTBFObj.TKBTRBDesc,!

				s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
				q:MKBTRowId=""
							
				s MKBTPObj = ##class(User.MKBTermProperty).%New()
				s MKBTPObj.MKBTPCode = TKBTBFObj.TKBTRBCode
				/*if ($D(^User.MKBTermPropertyI("DescIndex",MKBTRowId," "_$ZCONVERT(TKBTBFObj.TKBTRBDesc,"U")))'=0)
				{
					s MKBTPObj.MKBTPDesc = TKBTBFObj.TKBTRBDesc_"1"
				}*/
				s MKBTPObj.MKBTPDesc = TKBTBFObj.TKBTRBDesc
				if ($D(^User.MKBTermPropertyI("DescIndex",MKBTRowId," "_MKBTPObj.MKBTPDesc))'=0)
				{
					s MKBTPObj.MKBTPDesc = MKBTPObj.MKBTPDesc_"字段"
				}
				/*
				if (TKBTBFObj.TKBTRBDesc="部位")
				{
					s MKBTPObj.MKBTPDesc = TKBTBFObj.TKBTRBDesc_"字段"
				}
				*/
				s MKBTPObj.MKBTPConfig = TKBTBFObj.TKBTRBConfig
				s MKBTPObj.MKBTPDefinedNode = ""
				s MKBTPObj.MKBTPFlag = TKBTBFObj.TKBTRBFlag 
				s MKBTPObj.MKBTPName = TKBTBFObj.TKBTRBDesc
				d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId) 
				s MKBTPObj.MKBTPType = TKBTBFObj.TKBTRBType
				if (MKBTPObj.MKBTPType="T")
				{
					s MKBTPObj.MKBTPType = "TX"	
				}
				s MKBTPObj.MKBTPPublic = "Y"
				if (TKBTBFObj.TKBTRBType="S")
				{
					S BaseID = TKBTBFObj.TKBTRBConfig
					S BaseDesc = $LG($G(^User.TKBTremBaseD(BaseID)),3)
					S MKBBaseID = $O(^User.MKBTermBaseI("DescIndex"," "_BaseDesc,0))
					S MKBTPObj.MKBTPConfig=MKBBaseID
				}	
				//w MKBTPObj.MKBTPDesc
				s sc = MKBTPObj.%Save()
				if $$$ERROR(sc)
				{
					s error = $SYSTEM.Status.GetErrorText(sc)
					b ;MKBTPObj		
				}
				
				if (MKBTPObj.%Id()="")
				{
					b ;MKBTPObj空
				}
				/*引用表数据维护*/
				if (MKBTPObj.MKBTPType="S")
				{
					s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","P",MKBTPObj.%Id(),"B",MKBTPObj.MKBTPConfig)
					if (result["error")
					{
						b	
					}
				}
				/*引用表数据维护*/
				s TKBTRowId = ..GetOldTermID(MKBTRowId)
				if ($D(^TKBTREMITMi(0,"Link",TKBTRowId,TKBTBFRowId))=0)
				{
					continue	
				}
				else
				{
					s TKBTIRowId = $O(^TKBTREMITMi(0,"Link",TKBTRowId,TKBTBFRowId,0))
					s TKBTISource = $P($G(^TKBTREMITM(TKBTIRowId)),"^",3)
					s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
					s MKBTPDObj.MKBTPDCode = MKBTPObj.MKBTPType_"00000001"
					s MKBTPDObj.MKBTPDDesc = TKBTISource
					d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPObj.%Id())
					if (MKBTPObj.MKBTPType="S")
					{
						s MKBTPDObj.MKBTPDDesc = ..GetNewTermID(TKBTISource)
						//w TKBTISource,!
					}
					d MKBTPDObj.%Save()
					/*引用表数据维护*/
					if (MKBTPObj.MKBTPType="S")
					{
						s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","D",MKBTPDObj.%Id(),"T",MKBTPDObj.MKBTPDDesc)	
						if (result["error")
						{
							b	
						}
					}
					/*引用表数据维护*/
				}
			}
		}	
	}
}

/// TKBTrem->MKBTerm
/// Creator:李欣	
/// Desc:导入MKBTerm表数据
/// d ##class(web.DHCBL.MKB.MKBDataImport).MKBTerm()
ClassMethod MKBTerm()
{
	s TKBTBRowId=0
	for
	{
		s TKBTBRowId = $O(^User.TKBTremBaseD(TKBTBRowId))
		q:TKBTBRowId=""
		
		s TKBTBDesc = $LG($G(^User.TKBTremBaseD(TKBTBRowId)),3)
		s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," "_TKBTBDesc,0))
		
		s TKBTRowId=0
		for
		{
			s TKBTRowId=$O(^TKBTREMi(0,"Base",TKBTBRowId,TKBTRowId))
			q:TKBTRowId=""
			
			s TKBTObj = ##class(User.TKBTrem).%OpenId(TKBTRowId)
			s MKBTObj = ##class(User.MKBTerm).%New()
			
			d MKBTObj.MKBTBaseDRSetObjectId(MKBTBRowId)
			s MKBTObj.MKBTCode=TKBTObj.TKBTRBCode
			s MKBTObj.MKBTDesc=TKBTObj.TKBTRBDesc
			s MKBTObj.MKBTNote=TKBTObj.TKBTRBNote
			s MKBTObj.MKBTPYCode=TKBTObj.TKBTRBPYCode
			
			s sc=MKBTObj.%Save()
			if $$$ERROR(sc)
			{
				s code = $SYSTEM.Status.GetErrorText(sc)
				b			
			}
		}	
	}
}

/// MKBTerm-上级分类
/// Creator:李欣	
/// Desc:为MKBTerm表导入上级分类
/// d ##class(web.DHCBL.MKB.MKBDataImport).LastLevel()
ClassMethod LastLevel()
{
	s MKBTBRowId = 0
	for
	{
		s MKBTBRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId)) //通过医用知识库表rowid遍历术语库表数据
		q:MKBTBRowId=""
		
		s MKBTBDesc = $LG($G(^User.MKBTermBaseD(MKBTBRowId)),3) //获取医用知识库表描述
		s TKBTBRowId = $O(^User.TKBTremBaseI("DescIndex"," "_MKBTBDesc,0))	//获取旧医用知识库表RowId
		s MKBTRowId=0
		for
		{
			s MKBTRowId=$O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
			q:MKBTRowId=""
			s MKBTDesc = $LG($G(^User.MKBTermD(MKBTRowId)),3)	//知识库表描述
			if (MKBTDesc="") //诊断中心此为空
			{
				d ##class(User.MKBTerm).%DeleteId(MKBTRowId)
				continue	
			}
			//S MKBTDesc= $ZCONVERT(MKBTDesc,"U")
			s MKBTCode = $LG($G(^User.MKBTermD(MKBTRowId)),2)
			s MKBTCode = $ZCONVERT(MKBTCode,"U")
			s TKBTRowId = $O(^TKBTREMi(0,"Code",TKBTBRowId,MKBTCode,0))	//旧知识库表RowId
			s TKBTLast = $P($G(^TKBTREM(TKBTRowId)),"^",4) 
			if (TKBTLast="") //列表型Last Level为空
			{
				Continue	
			}
			s TKBLastDesc = $P($G(^TKBTREM(TKBTLast)),"^",2)
			s TKBLaseCode = $P($G(^TKBTREM(TKBTLast)),"^",1)
			s TKBLaseCode = $ZCONVERT(TKBLaseCode,"U")
			s MKBLast = $O(^User.MKBTermI("CodeIndex",MKBTBRowId," "_TKBLaseCode,0))
			
			if (MKBLast'="")
			{
				s obj=##class(User.MKBTerm).%OpenId(MKBTRowId)
				d obj.MKBTLastLevelSetObjectId(MKBLast)
				s sc=obj.%Save()
				if $$$ERROR(sc)
				{
					s code = $SYSTEM.Status.GetErrorText(sc)
					b	;code
				}	
			}	
		}
	}
}

/// MKBTermBaseCatDr
/// Creator:李欣	
/// Desc:添加术语分类字段
/// d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermBaseCat()
ClassMethod MKBTermBaseCat()
{
	s MKBBaseID = 0
	for
	{
		s MKBBaseID = $O(^User.MKBTermBaseD(MKBBaseID))
		q:MKBBaseID=""
		
		s obj = ##class(User.MKBTermBase).%OpenId(MKBBaseID)
		s MKBDesc = obj.MKBTBDesc
		s TKBBaseID = $O(^User.TKBTremBaseI("DescIndex"," "_MKBDesc,0))
		s TKBCatDr = $LG($G(^User.TKBTremBaseD(TKBBaseID)),11)
		if (TKBCatDr[",")
		{
			for i=1:1:$l(TKBCatDr,",")
			{
				s tcatdr = $p(TKBCatDr,",",i)
				s tcode =  $ZCONVERT($P($G(^TKBTREM(tcatdr)),"^",1),"U")
				s CatBaseDr = $O(^User.MKBTermBaseI("DescIndex"," 功能_术语分类",0))
				s mcatdr = $O(^User.MKBTermI("CodeIndex",CatBaseDr," "_tcode,0))
				/*引用表数据维护*/
				s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","B",MKBBaseID,"T",mcatdr)
				if (result["error")||(mcatdr="")
				{
					b	;(result["error")||(mcatdr="")
				}
				/*引用表数据维护*/
				s:obj.MKBTBCatDr'="" obj.MKBTBCatDr=obj.MKBTBCatDr_","_mcatdr
				s:obj.MKBTBCatDr="" obj.MKBTBCatDr=mcatdr
			}	
		}
		else
		{
			s TKBCatCode = $ZCONVERT($P($G(^TKBTREM(TKBCatDr)),"^",1),"U")
			s CatBaseDr = $O(^User.MKBTermBaseI("DescIndex"," 功能_术语分类",0))
			s MKBCatDr = $O(^User.MKBTermI("CodeIndex",CatBaseDr," "_TKBCatCode,0))
			s obj.MKBTBCatDr = MKBCatDr	
			/*引用表数据维护*/
			s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","B",MKBBaseID,"T",MKBCatDr)
			if (result["error")||(MKBCatDr="")
			{
				b	;(result["error")||(MKBCatDr"")
			}
			/*引用表数据维护*/
			
		}
		
		//w "TKB:",$P($G(^TKBTREM(TKBCatDr)),"^",2),":",MKBDesc,$LG($G(^User.TKBTermD(MKBCatDr)),2),!
		d obj.%Save()
	}
}

/// TKBTremExtend->MKBTermProperty
/// Creator:李欣	
/// Desc:导入MKBTermProperty表数据
/// d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermProperty()
ClassMethod MKBTermProperty()
{
	s MKBTRowId = 0
	for
	{
		s MKBTRowId=$O(^User.MKBTermD(MKBTRowId)) //遍历新知识库数据为其添加属性	
		q:MKBTRowId=""
		
		s MKBTCode=$LG($G(^User.MKBTermD(MKBTRowId)),2) 
		s MKBTCode=$ZCONVERT(MKBTCode,"U")
		s MKBTBaseDR=$LG($G(^User.MKBTermD(MKBTRowId)),4)
		s MKBTBaseDRDesc = $LG($G(^User.MKBTermBaseD(MKBTBaseDR)),3)
		s TKBBaseDR = $O(^User.TKBTremBaseI("DescIndex"," "_MKBTBaseDRDesc,0))
		S TKBTRowId = $O(^TKBTREMi(0,"Code",TKBBaseDR,MKBTCode,0)) //获取对应的旧知识库rowid
		
		s TKBTERowId=0
		for
		{
			s TKBTERowId = $O(^TKBTREEXTi(0,"Tre",TKBTRowId,TKBTERowId))
			q:TKBTERowId=""
			
			s TKBTEObj=##class(User.TKBTremExtend).%OpenId(TKBTERowId)
			if (TKBTEObj.TKBTEDesc="未配置")
			{
				//w "未配置没了",!
				continue	
			}
			if (TKBTEObj.TKBTEType="CT") //映射数据删除
			{
				continue	
			}
			if (TKBTEObj.TKBTEType="S")
			{
				if (TKBTEObj.TKBTEDATSOU="") //来源为空为无效数据
				{
					w TKBTERowId,"来源为空为无效数据",!
					Continue	
				}
				else
				{
					s TKBTEDATSOU = TKBTEObj.TKBTEDATSOU.%Id()
					if ($D(^User.TKBTremBaseD(TKBTEDATSOU))=0) //不存在此项被引用的术语库
					{
						w TKBTERowId,"//不存在此项被引用的术语库1",!
						Continue	
					}	
				}	
			}	
			if (TKBTEObj.TKBTEType="T")
			{	
				if (TKBTEObj.TKBTEDATSOU'="")	//树形选择了引用术语
				{
					s TKBTEDATSOU = TKBTEObj.TKBTEDATSOU.%Id()
					if ($D(^User.TKBTremBaseD(TKBTEDATSOU))=0) //不存在此项被引用的术语库
					{
						w TKBTERowId,"//不存在此项被引用的术语库2",!
						Continue	
					}
					if (TKBTEObj.TKBTEDefinedNode'="") //判断起始节点是否在新表中存在对应数据
					{
						if ($D(^TKBTREMi(0,"Base",TKBTEDATSOU,TKBTEObj.TKBTEDefinedNode))=0) //在原表中是否存在此数据
						{
							w TKBTERowId,"//在原表中是否存在此数据",!
							b
							continue	
						}
						s DefinedCode = $ZCONVERT($P($G(^TKBTREM(TKBTEObj.TKBTEDefinedNode)),"^",1),"U")
						s DefinedBaseDesc = $LG($G(^User.TKBTremBaseD(TKBTEDATSOU)),3)
						s MKBDefinedBaseID = $O(^User.MKBTermBaseI("DescIndex"," "_DefinedBaseDesc,0))
						s MKBTEDefinedId = $O(^User.MKBTermI("CodeIndex",MKBDefinedBaseID," "_DefinedCode,0))
						if (MKBTEDefinedId="") //新表中不存在此条术语
						{
							w TKBTERowId,"//新表中不存在此条术语",!
							b
							Continue	
						}
					}	
				}	
			}
			s MKBTPObj = ##class(User.MKBTermProperty).%New()
			s MKBTPObj.MKBTPCode = TKBTEObj.TKBTECode
			if (MKBTPObj.MKBTPCode="")
			{
				s MKBTPObj.MKBTPCode=TKBTEObj.TKBTEDesc	
			}
			s MKBTPObj.MKBTPDesc = TKBTEObj.TKBTEDesc
			s MKBTPObj.MKBTPType = TKBTEObj.TKBTEType
			d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
			s MKBTPObj.MKBTPFlag = TKBTEObj.TKBTEFlag
			s MKBTPObj.MKBTPConfig = ""
			s MKBTPObj.MKBTPDefinedNode = ""
			
			if (TKBTEObj.TKBTEPublic'="")
			{
				s MKBTPObj.MKBTPPublic=TKBTEObj.TKBTEPublic	
			}
			else
			{
				s MKBTPObj.MKBTPPublic = "N"	
			}
			if (TKBTEObj.TKBTEType="T") //类型为树
			{
				s MKBTPObj.MKBTPType = TKBTEObj.TKBTEType
				if (TKBTEObj.TKBTEDATSOU'="") //引用来源不为空
				{
					if (TKBTEObj.TKBTEDefinedNode="") //定义节点为空
					{
						s TKBDATSOUDesc = $LG($G(^User.TKBTremBaseD(TKBTEObj.TKBTEDATSOU.%Id())),3)
						s MKBDARSOU=""
						s MKBDARSOU = $O(^User.MKBTermBaseI("DescIndex"," "_TKBDATSOUDesc,0))
						w MKBDARSOU,!
						if (MKBDARSOU="")
						{
							b	;MKBDARSOU
						}
						s MKBTPObj.MKBTPType = "S"
						s MKBTPObj.MKBTPDefinedNode=""	
						s MKBTPObj.MKBTPConfig=MKBDARSOU
					}
					else //定义节点不为空，获取新表中定义节点对应的id及引用来源对应id
					{
						s DefinedCode = $ZCONVERT($P($G(^TKBTREM(TKBTEObj.TKBTEDefinedNode)),"^",1),"U")
						s DefinedBaseDesc = $LG($G(^User.TKBTremBaseD(TKBTEDATSOU)),3)
						s MKBDefinedBaseID = $O(^User.MKBTermBaseI("DescIndex"," "_DefinedBaseDesc,0))
						s MKBTEDefinedId = $O(^User.MKBTermI("CodeIndex",MKBDefinedBaseID," "_DefinedCode,0))
						s MKBTPObj.MKBTPType = "S"
						s MKBTPObj.MKBTPConfig=MKBDefinedBaseID
						if (MKBTEDefinedId="")
						{
							b	
						}
						d MKBTPObj.MKBTPDefinedNodeSetObjectId(MKBTEDefinedId)
						
					}
				}	
				else //引用来源为空，子定义节点必为空
				{
					s MKBTPObj.MKBTPConfig = ""	
					s MKBTPObj.MKBTPDefinedNode = ""
				}
			}
			if (TKBTEObj.TKBTEType="S") //类型为引用术语的
			{
				s MKBTPObj.MKBTPType="S"
				s TKBDATSOUDesc = $LG($G(^User.TKBTremBaseD(TKBTEObj.TKBTEDATSOU.%Id())),3)
				s MKBDARSOU = $O(^User.MKBTermBaseI("DescIndex"," "_TKBDATSOUDesc,0))
				s MKBTPObj.MKBTPConfig = MKBDARSOU
			}
			if (TKBTEObj.TKBTEType="C")
			{
				s MKBTPObj.MKBTPType = "P"
				s MKBTPObj.MKBTPConfig = ""
				s MKBTPObj.MKBTPDefinedNode = ""	
			}
			if (TKBTEObj.TKBTEName="")
			{
				s MKBTPObj.MKBTPName = MKBTPObj.MKBTPDesc	
			}
			else
			{
				s MKBTPObj.MKBTPName = TKBTEObj.TKBTEName	
			}
			if (MKBTPObj.MKBTPType="T")
			{
				//w MKBTPObj.MKBTPConfig,"||",MKBTPObj.MKBTPDefinedNode,!	
			}
			s sc = MKBTPObj.%Save()
			/*引用表数据维护*/
			/*if (MKBTPObj.MKBTPDefinedNode'="")
			{
				s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","P",MKBTPObj.%Id(),"D",MKBTPObj.MKBTPDefinedNode.%Id())	
				if (result["error")
				{
					b	
				}
			}*/
			if (MKBTPObj.MKBTPType="S")
			{
				s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","P",MKBTPObj.%Id(),"B",MKBTPObj.MKBTPConfig)	
				if (result["error")
				{
					b	
				}
				if (MKBTPObj.MKBTPDefinedNode'="")
				{
					s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","P",MKBTPObj.%Id(),"T",MKBTPObj.MKBTPDefinedNode.%Id())	
					if (result["error")
					{
						b	
					}		
				}

			}
			
			/*引用表数据维护*/
			if $$$ERROR(sc)
			{
				s code = $SYSTEM.Status.GetErrorText(sc)	
			}
			/******************TKBTremExtendCat->MKBTermExtendPro************************/
			//在TKBTremExtendCat表ParRef 上建索引,buildindices()
			//d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermProperty()
			s MKBTPRowId = MKBTPObj.%Id()
			//TKBTERowId
			s Childsub = 0
			for
			{
				s Childsub = $O(^TKBTREEXT(0,"Par",TKBTERowId,Childsub))
				q:Childsub=""
				
				s TKBTECRowId=TKBTERowId_"||"_Childsub
				s TKBTECObj = ##class(User.TKBTremExtendCat).%OpenId(TKBTECRowId)
				if (TKBTECObj.TKBTECType="U") //上传文档类型数据删除
				{
					//w TKBTECRowId,"上传文档类型数据删除",!
					continue	
				}
				if (TKBTECObj.TKBTECType="S")
				{
					if (TKBTECObj.TKBTECConfig="")
					{
						w TKBTECRowId,"引用类型未选择来源",!
						continue		
					}
					else
					{
						s TKBTECConfig = TKBTECObj.TKBTECConfig
						if ($D(^User.TKBTremBaseD(TKBTECConfig))=0)
						{
							w TKBTECRowId,"引用的术语库不存在（原表）",! //1原表存在新表一定存在	
							b
							Continue
						}		
					}
				}
				if (TKBTECObj.TKBTECType="SD")
				{
					if (TKBTECObj.TKBTECConfig="")
					{
						w TKBTECRowId,"引用属性内容类型未选择来源",!
						continue	
					}
					else
					{
						s TKBTECConfig = TKBTECObj.TKBTECConfig
						if ($D(^User.TKBTremBaseD(TKBTECConfig))=0)
						{
							w TKBTECRowId,"引用的术语库不存在（原表）",! //原表存在新表一定存在	
							Continue
						}	
					}	
				}
				
				s MKBTEPObj = ##class(User.MKBTermExtendPro).%New(MKBTPRowId)
				d MKBTEPObj.ParRefSetObjectId(MKBTPRowId)
				s MKBTEPObj.MKBTEPName = TKBTECObj.TKBTECName
				s MKBTEPObj.MKBTEPType=TKBTECObj.TKBTECType
				s MKBTEPObj.MKBTEPConfig=TKBTECObj.TKBTECConfig	
				if (TKBTECObj.TKBTECType="S")||(TKBTECObj.TKBTECType="SD")
				{
					
					s TKBTECConfig = TKBTECObj.TKBTECConfig	//查找在新表中对应的BaseID
					s TKBTECConfigDesc = $LG($G(^User.TKBTremBaseD(TKBTECConfig)),3)
					s MKBTEPConfig = $O(^User.MKBTermBaseI("DescIndex"," "_TKBTECConfigDesc,0))
					if (MKBTEPConfig="")
					{
						b //MKBTEPConfig=""	
					}
					s MKBTEPObj.MKBTEPType=TKBTECObj.TKBTECType
					s MKBTEPObj.MKBTEPConfig = MKBTEPConfig
				}
				if (TKBTECObj.TKBTECType="T")
				{
					s MKBTEPObj.MKBTEPType = "TX"	
				}
				
				s sc = MKBTEPObj.%Save()
				/*引用表数据维护*/
				if (MKBTEPObj.MKBTEPType="S")
				{
					s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","E",MKBTEPObj.%Id(),"B",MKBTEPObj.MKBTEPConfig)	
					if (result["error")
					{
						b	
					}
				}
				/*引用表数据维护*/
				if $$$ERROR(sc)
				{
					s code = $SYSTEM.Status.GetErrorText(sc)
					b ;error2	
				}
			}
		}
	}
	w 64
}

/// Creator:李欣
/// CreatDate:20180510
/// Input：ParentID 父节点Id，cat 属性ID ，base术语库注册ID ，leval级别
/// Return：flag  :1保存数据失败，"" 保存成功。
/// Description:属性格式为树形并且选择了数据来源定义了初始节点，则要把对应的术语数据保存到术语明细表里
/// w ##class(web.DHCBL.MKB.MKBTermProperty).SaveTreeSou("14","2","1284448","1")
ClassMethod SaveTreeSou(ParentID As %String, base As %String, cat As %String, leval As %String) As %String
{
    q:(ParentID="")||(base="")||(cat="") ""
    if (ParentID="CatTreeRoot") s ParentID=-100000000000000
    s MKBTPDLevel=leval
    s flag =""
    s myRowID=0
    for {
        s myRowID=$o(^User.MKBTermI("ParentIndex",base,ParentID,myRowID))
        if (..IsSExist(cat,myRowID)="Y")
        {
	    	;w "重复",!
	    	continue    
	    }
        q:(myRowID="")||(flag=1)
        s myObj=##Class(User.MKBTerm).%OpenId(myRowID,0)
        if $IsObject(myObj)
        {
            s MKBTCode=myObj.MKBTCode
            s MKBTDesc = myObj.%Id()
            s MKBTLastLevel=""
            if $IsObject(myObj.MKBTLastLevel){
                s MKBTLastLevel = myObj.MKBTLastLevel.%Id()
            }
            s MKBTNote =  myObj.MKBTNote
            d myObj.%Close()
            
            s MKBTPDLastLevel=""   //术语明细表上级分类 
            if (MKBTLastLevel'="")  //术语表上级分类
            {
                s parentCode=$listget($g(^User.MKBTermD(MKBTLastLevel)),2)  //术语表上级分类的代码
                s:parentCode'="" parentCode=$ZCONVERT(parentCode,"U") //转换成大写
                s MKBTPDLastLevel=$o(^User.MKBTermProDetailI("CodeIndex",cat," "_parentCode,0))   //术语明细表上级分类-通过code找术语明细表的ID
            }
            
            s DetObj=##class(User.MKBTermProDetail).%New()
            s DetObj.MKBTPDCode=..GenerateTPDCode()
            s DetObj.MKBTPDDesc=myObj.%Id()
            d DetObj.MKBTPDProDRSetObjectId(cat) //属性Dr
            s DetObj.MKBTPDLevel=MKBTPDLevel
            d DetObj.MKBTPDLastLevelSetObjectId(MKBTPDLastLevel)
            s DetObj.MKBTPDRemark=MKBTNote
            //s eobjDetail.MKBTPDExtend=##class(web.DHCBL.MKB.MKBTermProperty).FindThreeExtendStr(base,cat,myRowID)   //获取展示名、别名、拼音码的数据 谷雪萍 2018-03-08 
            //s detailResult=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobjDetail)
            s sc = DetObj.%Save()
            if $$$ISOK(sc)
            {
                s nextLevel=MKBTPDLevel+1            
                s flag=..SaveTreeSou(myRowID,base,cat,nextLevel)
                s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","D",DetObj.%Id(),"T",myObj.%Id())	
				if (result["error")
				{
					b	
				}
            }
            else
            {
	            b
	            s flag = 1
            }
        }
    }

    q flag
}

/// w ##class(web.DHCBL.MKB.MKBDataImport).GenerateTPDCode()
ClassMethod GenerateTPDCode()
{
	if ($D(^TMP("MKB","TPDCode"))=0)
	{
		s code = "P00000001"	
	}
	else
	{
		s pre = $O(^TMP("MKB","TPDCode",""),-1)
		s pre = $E(pre,"2",$L(pre))	
		s code = pre+1
		s codelen = $L(code)
		for i=codelen:1:7
		{
			s code = "0"_code	
		}
		s code = "P"_code
	}
	s ^TMP("MKB","TPDCode",code)=""
	q code
}

/// Creator:李欣
/// CreatDate:20180510
/// Input：ParentID 父节点Id，cat 属性ID ，base术语库注册ID ，leval级别
/// Return：flag  :1保存数据失败，"" 保存成功。
/// Description:属性格式为树形并且选择了数据来源定义了初始节点，则要把对应的术语数据保存到术语明细表里
/// w ##class(web.DHCBL.MKB.MKBTermProperty).SaveTreeSou("14","2","1284448")
ClassMethod SaveTreeSou2(ParentID As %String, base As %String, cat As %String) As %String
{
    q:(ParentID="")||(base="")||(cat="") ""
    if (ParentID="CatTreeRoot") s ParentID=-100000000000000
    s flag =""
    s myRowID=0
    for {
        s myRowID=$o(^User.MKBTermI("ParentIndex",base,ParentID,myRowID))
        if (..IsSExist(cat,myRowID)="Y")
        {
	    	;w "重复",!
	    	continue    
	    }
        q:(myRowID="")||(flag=1)
        s myObj=##Class(User.MKBTerm).%OpenId(myRowID)
        if $IsObject(myObj)
        {
            s MKBTCode=myObj.MKBTCode
            s MKBTDesc = myObj.%Id()
            s MKBTNote =  myObj.MKBTNote
            d myObj.%Close()
            
            s DetObj=##class(User.MKBTermProDetail).%New()
            s DetObj.MKBTPDCode=..GenerateTPDCode()
            s DetObj.MKBTPDDesc=myObj.%Id()
            d DetObj.MKBTPDProDRSetObjectId(cat) //属性Dr
            s DetObj.MKBTPDRemark=MKBTNote
            //s eobjDetail.MKBTPDExtend=##class(web.DHCBL.MKB.MKBTermProperty).FindThreeExtendStr(base,cat,myRowID)   //获取展示名、别名、拼音码的数据 谷雪萍 2018-03-08 
            //s detailResult=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobjDetail)
            s sc = DetObj.%Save()
            if $$$ISOK(sc)
            {          
                s flag=..SaveTreeSou2(myRowID,base,cat)
                s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","D",DetObj.%Id(),"T",myObj.%Id())	
				if (result["error")
				{
					b	
				}
            }
            else
            {
	            b
	            s flag = 1
            }
        }
    }

    q flag
}

/// Desc:判断属性内容中是否已有该内容
ClassMethod IsSExist(ProId, TermID)
{
	s result=""
	s MKBTPDRowId = 0
	for
	{
		s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",ProId,MKBTPDRowId))
		q:MKBTPDRowId=""
		s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		if (MKBTPDDesc=TermID)
		{
			s result = "Y"	
		}	
	}	
	q result
}

/// w ##class(web.DHCBL.MKB.MKBDataImport).GetOldExtID(886)
ClassMethod GetOldExtID(ProId)
{
	s MKBTPCode = $LG($G(^User.MKBTermPropertyD(ProId)),2)
	s MKBTRowId = $LG($G(^User.MKBTermPropertyD(ProId)),6)
	s TKBTRowId = ..GetOldTermID(MKBTRowId)
	s TKBExtID = $O(^TKBTREEXTi(0,"Code",TKBTRowId,$ZCONVERT(MKBTPCode,"U"),0))
	q TKBExtID
}

/// Desc:所有选择了数据来源的树形数据转移
ClassMethod SetTreeSData()
{

	s MKBTPRowId = 0
	for
	{
		s MKBTPRowId = $O(^User.MKBTermPropertyD(MKBTPRowId))
		q:MKBTPRowId=""
		
		s TKBExtID = ..GetOldExtID(MKBTPRowId)
		s TKBExtType = $P($G(^TKBTREEXT(TKBExtID)),"^",3)
		s MKBTPType = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
		s MKBTPConfig = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),5)
		s MKBTPDefined = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),10)
		s MKBTBType = ""
		if (MKBTPConfig'="")
		{
			s MKBTBType = $LG($G(^User.MKBTermBaseD(MKBTPConfig)),4)	
		}
		
		if (MKBTPType="S")&&(MKBTPConfig'="")&&(MKBTBType="T")&&(TKBExtType="T")
		{	
			if (MKBTPDefined="")  //如果没有定义起始节点,则默认所有的数据都复制过来
            {
                s MKBTPDefined="CatTreeRoot"               
            }
            /*else  //先保存初始节点
            {
                s MKBTPDCode="",MKBTPDDesc="",MKBTPDRemark=""
                s myObj=##Class(User.MKBTerm).%OpenId(MKBTPDefined)
                if $IsObject(myObj)
                {
                    s MKBTPDCode = myObj.MKBTCode
                    s MKBTPDDesc = MKBTPDefined
                    s MKBTPDRemark =  myObj.MKBTNote
                    d myObj.%Close()

                }
                
                if (MKBTPDCode'="")&(MKBTPDDesc'="")&(MKBTPRowId'="")
                {	                   
                	s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
                	s MKBTPDObj.MKBTPDCode = MKBTPDCode
                	s MKBTPDObj.MKBTPDDesc = MKBTPDefined
                	s MKBTPDObj.MKBTPDLevel = 1
                	d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPRowId)
                	s MKBTPDObj.MKBTPDRemark=  MKBTPDRemark   	                        
                    d MKBTPDObj.%Save()
                }
            }*/
			s treeSaveflag=..SaveTreeSou(MKBTPDefined,MKBTPConfig,MKBTPRowId,2)
            if (treeSaveflag=1)
            {
            	b ;保存失败 	   
            }
            w MKBTPRowId,treeSaveflag,!
		}	
		s MKBTPDRowId=0
		for
		{
			s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
			q:MKBTPDRowId=""
			s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","D",MKBTPDRowId,"T",$LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3))	
			if (result["error")
			{
				b	
			}
		}
	}
	w 1
}

/// TKBTremExtendDetail->MKBTermProDetail
/// Creator:李欣	
/// Desc:导入MKBTermProDetail表数据
/// d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermProDetail()
ClassMethod MKBTermProDetail()
{
	s MKBTPRowId = 0
	for
	{
		s MKBTPRowId = $O(^User.MKBTermPropertyD(MKBTPRowId))	
		q:MKBTPRowId=""
		
		s MKBTPTermDR = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),6)
		s MKBTPCode = $ZCONVERT($LG($G(^User.MKBTermPropertyD(MKBTPRowId)),2),"U")
		s TKBTRowId = ..GetOldTermID(MKBTPTermDR)
		s TKBTERowId = $O(^TKBTREEXTi(0,"Code",TKBTRowId,MKBTPCode,0))
		if ($P($G(^TKBTREEXT(TKBTERowId)),"^",3)="T")&&($P($G(^TKBTREEXT(TKBTERowId)),"^",4)'="")
		{
			w "树形啦啦啦啦",!
			continue	
			
		}		

		
		s MKBTPCode = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),2)
		s MKBTPCode = $ZCONVERT(MKBTPCode,"U")
		s MKBTPBaseDr = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),6)	//新术语表指针
		s MKBTPBaseCode = $LG($G(^User.MKBTermD(MKBTPBaseDr)),2)	//新术语表代码	
		s MKBTPBaseCode = $ZCONVERT(MKBTPBaseCode,"U")
		s MKBTBaseDr = $LG($G(^User.MKBTermD(MKBTPBaseDr)),4) //新注册术语库表指针
		
		s MKBTBaseDesc = $LG($G(^User.MKBTermBaseD(MKBTBaseDr)),3)	//新注册术语库表描述
		s TKBTBaseDr = $O(^User.TKBTremBaseI("DescIndex"," "_MKBTBaseDesc,0))	//旧注册术语库表描述
		s TKBTEBaseDr = $O(^TKBTREMi(0,"Code",TKBTBaseDr,MKBTPBaseCode,0))	//旧术语表指针
		s TKBTERowId = $O(^TKBTREEXTi(0,"Code",TKBTEBaseDr,MKBTPCode,0))
		
		s TKBTEDRowId = 0
		for
		{
			s TKBTEDRowId = $O(^TKBTREEXTDTLi(0,"Ext",TKBTERowId,TKBTEDRowId))
			q:TKBTEDRowId=""
			
			s TKBTEDObj = ##class(User.TKBTremExtendDetail).%OpenId(TKBTEDRowId)
			s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
			
			s MKBTPDObj.MKBTPDCode = TKBTEDObj.TKBTDCode
			s MKBTPDObj.MKBTPDDesc = TKBTEDObj.TKBTDDesc
			s MKBTPDObj.MKBTPDLevel = TKBTEDObj.TKBTDLevel
			d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPRowId)
			s MKBTPDObj.MKBTPDRemark = TKBTEDObj.TKBTDRemark
			s MKBTPDObj.MKBTPDActiveFlag = TKBTEDObj.TKBTDActiveFlag
			d MKBTPDObj.%Save()
		}
	}
}

/// MKBTermProDetail:LastLevel
/// Creator:李欣	
/// Desc:为MKBTermProDetail表导入上级分类
/// d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermProDetailLastLevel()
ClassMethod MKBTermProDetailLastLevel()
{
	s MKBTPDRowId = 0
	for
	{
		s MKBTPDRowId = $O(^User.MKBTermProDetailD(MKBTPDRowId))	
		q:MKBTPDRowId=""
		
		s MKBTPRowId = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),6)
		s MKBTPType = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
		continue:MKBTPType="S"
		s MKBTPDCode = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),2)
		s MKBTPDCode = $ZCONVERT(MKBTPDCode,"U")
		s MKBTPRowId = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),6)
		s MKBTPCode  = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),2) //新属性表代码
		s MKBTPCode = $ZCONVERT(MKBTPCode,"U")
		s MKBTRowId = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),6) //新术语维护表id
		s MKBTCode = $LG($G(^User.MKBTermD(MKBTRowId)),2) //新术语表代码
		s MKBTCode = $ZCONVERT(MKBTCode,"U")
		s MKBTBRowId = $LG($G(^User.MKBTermD(MKBTRowId)),4)	//新术语库注册表id
		s MKBTBDesc = $LG($G(^User.MKBTermBaseD(MKBTBRowId)),3)
		s MKBTBDesc = $ZCONVERT(MKBTBDesc,"U")
		s TKBTBRowId  = $O(^User.TKBTremBaseI("DescIndex"," "_MKBTBDesc,0)) //旧术语库注册表id
		s TKBTRowId = $O(^TKBTREMi(0,"Code",TKBTBRowId,MKBTCode,0))	//旧术语表id
		s TKBTERowId = $O(^TKBTREEXTi(0,"Code",TKBTRowId,MKBTPCode,0)) //旧属性表id
		s TKBTEDRowId = $O(^TKBTREEXTDTLi(0,"Code",TKBTERowId,MKBTPDCode,0)) //旧属性内容表id
		
		s TKBTEDLastLevel = $P($G(^TKBTREEXTDTL(TKBTEDRowId)),"^",3)
		continue:TKBTEDLastLevel=""
		if (..DetIsLeagal(TKBTEDLastLevel)="N")
		{
			d ##class(User.MKBTermProDetail).%DeleteId(MKBTPDRowId)	
			continue
		}
		s MKBTPDLastLevel = ..GetNewDetId(TKBTEDLastLevel)
		if (MKBTPDLastLevel="un")
		{
			d ##class(User.MKBTermProDetail).%DeleteId(MKBTPDRowId)	
			continue	
		}
		s obj = ##class(User.MKBTermProDetail).%OpenId(MKBTPDRowId)
		d obj.MKBTPDLastLevelSetObjectId(MKBTPDLastLevel)
		s sc = obj.%Save()
		if $$$ERROR(sc)
		{
			s code = $SYSTEM.Status.GetErrorText(sc)
			b	
		}
	}
}

/// Creator:李欣	
/// Desc:处理MKBTermProDetail表中引用术语类型的属性内容
/// d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermProDetailS()
ClassMethod MKBTermProDetailS()
{
	s MKBTPRowId = 0
	for
	{
		s MKBTPRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId))
		q:MKBTPRowId=""
		s Type = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
		continue:Type'="S"
		s MKBTPConfig = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),5)
		s MKBTBType = $LG($G(^User.MKBTermBaseD(MKBTPConfig)),4)
		if (MKBTBType="L")||(MKBTBType="T")
		{
			s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0))
			s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
			
			if (MKBTPDDesc = "")
			{
				w "引用属性未取值",!
				continue	
			}
			if (MKBTPDDesc'[",")
			{
				s TKBTRowId = MKBTPDDesc
				if ($D(^TKBTREM(TKBTRowId))=0)
				{
					w "引用的术语在原表中不存在",!
					continue	
				}
				s TKBTCode = $P($G(^TKBTREM(TKBTRowId)),"^",1)
				s TKBTCode = $ZCONVERT(TKBTCode,"U")
				s TKBTBRowId = $P($G(^TKBTREM(TKBTRowId)),"^",3)
				if ($D(^User.TKBTremBaseD(TKBTBRowId))=0)
				{
					w "引用的术语库在原表中不存在",!
					continue
				}
				s TKBTBDesc = $LG($G(^User.TKBTremBaseD(TKBTBRowId)),3)
				s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," "_TKBTBDesc,0))
				s MKBTRowId = $O(^User.MKBTermI("CodeIndex",MKBTBRowId," "_TKBTCode,0))
				if (MKBTRowId="")
				{
					w "引用的术语在新表中存在",!
					continue
				}
				s obj = ##class(User.MKBTermProDetail).%OpenId(MKBTPDRowId)	
				s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
				s MKBTPDObj.MKBTPDCode = "D"_MKBTPRowId_"1"
				s MKBTPDObj.MKBTPDDesc = MKBTRowId
				d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPRowId)
				s MKBTPDObj.MKBTPDActiveFlag = obj.MKBTPDActiveFlag
				s MKBTPDObj.MKBTPDLastLevel = obj.MKBTPDLastLevel
				s MKBTPDObj.MKBTPDLevel = obj.MKBTPDLevel
				s MKBTPDObj.MKBTPDRemark = obj.MKBTPDRemark
				s sc = MKBTPDObj.%Save()
				if $$$ERROR(sc)
				{
					s code = $SYSTEM.Status.GetErrorText(sc)
					b	
				}	
				s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","D",MKBTPDObj.%Id(),"T",MKBTPDObj.MKBTPDDesc)
				if (result["error")
				{
					b ;reuslt[error	
				}
				d ##class(User.MKBTermProDetail).%DeleteId(MKBTPDRowId)

			}
			else
			{
				s obj = ##class(User.MKBTermProDetail).%OpenId(MKBTPDRowId)	
				for i=1:1:$L(MKBTPDDesc,",")
				{
					s desc = $P(MKBTPDDesc,",",i)
					s TKBTRowId = desc
					if ($D(^TKBTREM(TKBTRowId))=0)
					{
						w "引用的术语在原表中不存在",!
						continue	
					}
					s TKBTCode = $P($G(^TKBTREM(TKBTRowId)),"^",1)
					s TKBTCode = $ZCONVERT(TKBTCode,"U")
					s TKBTBRowId = $P($G(^TKBTREM(TKBTRowId)),"^",3)
					if ($D(^User.TKBTremBaseD(TKBTBRowId))=0)
					{
						w "引用的术语库在原表中不存在",!
						continue
					}
					s TKBTBDesc = $LG($G(^User.TKBTremBaseD(TKBTBRowId)),3)
					s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," "_TKBTBDesc,0))
					s MKBTRowId = $O(^User.MKBTermI("CodeIndex",MKBTBRowId," "_TKBTCode,0))
					if (MKBTRowId="")
					{
						w "引用的术语在新表中存在",!
						continue
					}
					s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
					s MKBTPDObj.MKBTPDCode = ..GenerateTPDCode()
					s MKBTPDObj.MKBTPDDesc = MKBTRowId
					d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPRowId)
					s MKBTPDObj.MKBTPDActiveFlag = obj.MKBTPDActiveFlag
					s MKBTPDObj.MKBTPDLastLevel = obj.MKBTPDLastLevel
					s MKBTPDObj.MKBTPDLevel = obj.MKBTPDLevel
					s MKBTPDObj.MKBTPDRemark = obj.MKBTPDRemark
					
					s sc = MKBTPDObj.%Save()
					if $$$ERROR(sc)
					{
						s code = $SYSTEM.Status.GetErrorText(sc)
						b	
					}
					s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","D",MKBTPDObj.%Id(),"T",MKBTRowId)
					if (result["error")
					{
						b ;reuslt[error	
					}
					if (i=$L(MKBTPDDesc,","))
					{
						d ##class(User.MKBTermProDetail).%DeleteId(MKBTPDRowId)	
					}
					
				}
			}	
		}
	}
}

/// Creator:李欣	
/// Desc:处理MKBTermProDetail表中引用属性类型的属性内容
/// d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermProDetailP()
ClassMethod MKBTermProDetailP()
{
	s MKBTPRowId = 0
	for
	{
		s MKBTPRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId))
		q:MKBTPRowId=""	
		s Type = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
		continue:Type'="P"
		s MKBTPDRowId = 0
		for
		{
			s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
			q:MKBTPDRowId=""
			
			s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
			if (MKBTPDDesc = "")
			{
				w "引用属性未取值",!
				continue	
			}
			if (MKBTPDDesc'[",")	//只有一组值
			{
				s MKBTPDObj = ##class(User.MKBTermProDetail).%OpenId(MKBTPDRowId)
				s MKBTPDObj.MKBTPDDesc=""
				s desc = MKBTPDDesc 
				if ($L(desc)-$L($TR(desc,"&",""))=1)
				{
					s TKBExt = $P(desc,"&",1)
					s TKBType = $P(desc,"&",2)
					if ($P(^TKBTREEXT(TKBExt),"^",2)="未配置")
					{
						;w "未配置",!
						b
						d ##class(User.MKBTermProDetail).%DeleteId(MKBTPDRowId)	
						continue	
					}
					
					if (..ExtIsLeagal(TKBExt)="N")
					{
						w "引用的属性不合法",!
						continue	
					}
					s MKBExt = ..GetNewExtId(TKBExt)
					if (MKBExt="")
					{
						w "引用的属性在新表中不存在",!
						continue	
					}
					
					s MKBTPDObj.MKBTPDDesc=MKBExt_"&"_TKBType
				
					if (MKBTPDObj.MKBTPDDesc="")
					{
						d ##class(User.MKBTermProDetail).%DeleteId(MKBTPDRowId)	
					}
					else
					{
						s sc = MKBTPDObj.%Save()
						if $$$ERROR(sc)
						{
							s code = $SYSTEM.Status.GetErrorText(sc)
							b	;2
						} 	
					}
				}
				elseif ($L(desc)-$L($TR(desc,"&",""))=2)
				{
					s TKBExt = $P(desc,"&",1)
					s TKBType = $P(desc,"&",2)
					s TKBDet = $P(desc,"&",3)
					if ($P($G(^TKBTREEXT(TKBExt)),"^",2)="未配置")
					{
						;w "未配置",!
						d ##class(User.MKBTermProDetail).%DeleteId(MKBTPDRowId)	
						continue	
					}
					if (..ExtIsLeagal(TKBExt)="N")
					{
						w "引用的属性不合法",!
						continue	
					}
					s MKBExt = ..GetNewExtId(TKBExt)
					if (TKBDet="undefined")
					{
						s MKBDet=""	
					}
					else
					{
						if (..DetIsLeagal(TKBDet)="N")
						{
							w TKBDet,$P($G(^TKBTREEXTDTL(TKBDet)),"^",2),"引用的属性内容不合法",!
							continue	
						}
						s MKBDet = ..GetNewDetId(TKBDet)
					}
					if (MKBExt="")||(MKBDet="un")
					{
						w "引用的属性或属性内容在新表中不存在",!	
						continue
					}
					
					s MKBTPDObj.MKBTPDDesc=MKBExt_"&"_TKBType_"&"_MKBDet
					if (MKBTPDObj.MKBTPDDesc="")
					{
						d ##class(User.MKBTermProDetail).%DeleteId(MKBTPDRowId)	
					}
					else
					{
						s sc = MKBTPDObj.%Save()
						if $$$ERROR(sc)
						{
							s code = $SYSTEM.Status.GetErrorText(sc)
							b	;2
						} 	
					}
					
				}
			}
			else	//包含多组引用
			{
				s MKBTPDObj = ##class(User.MKBTermProDetail).%OpenId(MKBTPDRowId)
				s MKBTPDObj.MKBTPDDesc=""
				for i=1:1:$L(MKBTPDDesc,",")
				{
					s desc = $P(MKBTPDDesc,",",i)
					if ($L(desc)-$L($TR(desc,"&",""))=1)
					{
						s TKBExt = $P(desc,"&",1)
						s TKBType = $P(desc,"&",2)
						if (..ExtIsLeagal(TKBExt)="N")
						{
							w "引用的属性不合法",!
							continue	
						}
				
						s MKBExt = ..GetNewExtId(TKBExt)
						if (MKBExt="")
						{
							w MKBExt,$P($G(^TKBTREEXTDTL(TKBDet)),"^",2),"引用的属性在新表中不存在",!
							continue	
						}
						s:MKBTPDObj.MKBTPDDesc'="" MKBTPDObj.MKBTPDDesc=MKBTPDObj.MKBTPDDesc_","_MKBExt_"&"_TKBType
						s:MKBTPDObj.MKBTPDDesc="" MKBTPDObj.MKBTPDDesc=MKBExt_"&"_TKBType
					}
					elseif ($L(desc)-$L($TR(desc,"&",""))=2)
					{
						s TKBExt = $P(desc,"&",1)
						s TKBType = $P(desc,"&",2)
						s TKBDet = $P(desc,"&",3)
						if (..ExtIsLeagal(TKBExt)="N")
						{
							w "引用的属性不合法",!
							continue	
						}
						s MKBExt = ..GetNewExtId(TKBExt)
						if (TKBDet="undefined")
						{
							if (MKBExt=13036)
							{
								b	
							}
							s MKBDet = ""	
						}
						else
						{
							if (..DetIsLeagal(TKBDet)="N")
							{
								w TKBDet,$P($G(^TKBTREEXTDTL(TKBDet)),"^",2),"引用的属性内容不合法",!
								continue	
							}	
							s MKBDet = ..GetNewDetId(TKBDet)
						}		
						if (MKBExt="")||(MKBDet="un")
						{
							w "引用的属性或属性内容在新表中不存在",!	
							continue
						}
						s:MKBTPDObj.MKBTPDDesc'="" MKBTPDObj.MKBTPDDesc=MKBTPDObj.MKBTPDDesc_","_MKBExt_"&"_TKBType_"&"_MKBDet
						s:MKBTPDObj.MKBTPDDesc="" MKBTPDObj.MKBTPDDesc=MKBExt_"&"_TKBType_"&"_MKBDet
					}	
					
				}
				if (MKBTPDObj.MKBTPDDesc="")
				{
					w "引用的多组id在新表中都不存在",!
					continue	
				}	
				s sc = MKBTPDObj.%Save()
				if $$$ERROR(sc)
				{
					s code = $SYSTEM.Status.GetErrorText(sc)
					b	;3
				} 
			}
		}
	}
}

/// Creator:李欣	
/// Desc:判断旧表中的属性内容id是否合法
/// w ##class(web.DHCBL.MKB.MKBDataImport).DetIsLeagal(74463)
ClassMethod DetIsLeagal(TKBDetID)
{
	if ($D(^TKBTREEXTDTL(TKBDetID))=0)
	{
		q "N"	
	}
	s TKBTEID = $P($G(^TKBTREEXTDTL(TKBDetID)),"^",5)
	q ..ExtIsLeagal(TKBTEID)
}

/// Creator:李欣	
/// Desc:判断旧表中的属性id是否合法
ClassMethod ExtIsLeagal(TKBExtID)
{
	if ($D(^TKBTREEXT(TKBExtID))=0)
	{
		q "N"	
	}
	s TKBTID = $P($G(^TKBTREEXT(TKBExtID)),"^",5)
	if ($D(^TKBTREM(TKBTID))=0)
	{
		q "N"	
	}
	s TKBTBID = $P($G(^TKBTREM(TKBTID)),"^",3)
	if ($D(^User.TKBTremBaseD(TKBTBID))=0)
	{
		q "N"	
	}
	q "Y"
}

/// 获取新表中对应的ExtId
/// Creator:李欣	
/// Desc:获取新表中对应的属性ID
/// w ##class(web.DHCBL.MKB.MKBDataImport).GetNewExtId()
ClassMethod GetNewExtId(TKBTEID)
{
	if (TKBTEID="")
	{
		q ""	
	}
	s TKBTECode = $P($G(^TKBTREEXT(TKBTEID)),"^",1)
	s TKBTECode = $ZCONVERT(TKBTECode,"U")
	s TKBTID = $P(^TKBTREEXT(TKBTEID),"^",5)
	s TKBTCode = $P($G(^TKBTREM(TKBTID)),"^",1)
	s TKBTCode = $ZCONVERT(TKBTCode,"U")
	s TKBTBID = $P($G(^TKBTREM(TKBTID)),"^",3)
	s TKBTBCode = $LG($G(^User.TKBTremBaseD(TKBTBID)),2)
	s TKBTBCode = $ZCONVERT(TKBTBCode,"U")
	s MKBTBID = $O(^User.MKBTermBaseI("CodeIndex"," "_TKBTBCode,0))
	if (MKBTBID="")
	{
		q ""	
	}
	s MKBTID = $O(^User.MKBTermI("CodeIndex",MKBTBID," "_TKBTCode,0))
	if (MKBTID="")
	{
		q ""	
	}
	s MKBTPID = $O(^User.MKBTermPropertyI("CodeIndex",MKBTID," "_TKBTECode,0))
	if (MKBTPID="")
	{
		q ""	
	}
	q MKBTPID
}

/// Creator:李欣	
/// Desc:获取新表中对应的属性内容ID
/// d ##class(web.DHCBL.MKB.MKBDataImport).GetNewDetId()
ClassMethod GetNewDetId(TKBTEDID)
{
	s TKBTEDCode = $P($G(^TKBTREEXTDTL(TKBTEDID)),"^",1)
	s TKBTEID = $P($G(^TKBTREEXTDTL(TKBTEDID)),"^",5)
	s MKBTPID = ..GetNewExtId(TKBTEID)
	if (MKBTPID="")
	{
		q "un"	
	}
	s MKBTPDID = $O(^User.MKBTermProDetailI("CodeIndex",MKBTPID," "_TKBTEDCode,0))
	if (MKBTPDID="")
	{
		q "un"	
	}
	q MKBTPDID
}

/// ShortDesc:TKBTremExtendVal->MKBTermExtendProVal
/// Creator:李欣	
/// Desc:导入MKBTermExtendProVal表数据
/// d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermExtendProVal()
/// 	k ^User.MKBTermExtendProValD	//扩展属性值表
/// 	k ^User.MKBTermExtendProValI	//扩展属性值表
ClassMethod MKBTermExtendProVal()
{
	s TKBTEDRowId = 0
	for
	{
		s TKBExt=""
		s MKBExt=""
		s TKBTEDRowId = $O(^TKBTREEXTVALi(0,"Val",TKBTEDRowId))
		q:TKBTEDRowId=""
		
		if (..DetIsLeagal(TKBTEDRowId)="N")
		{
			continue	
		}
		s MKBDet = ..GetNewDetId(TKBTEDRowId)
		s TKBTECRowId = 0
		for
		{
			s TKBTECRowId = $O(^TKBTREEXTVALi(0,"Val",TKBTEDRowId,TKBTECRowId))
			q:TKBTECRowId=""
			continue:TKBTECRowId'["||"
			s TKBExt = $P(TKBTECRowId,"||",1)
			s TKBExtChild =$P(TKBTECRowId,"||",2)
			if (..ExtIsLeagal(TKBExt)="N")
			{
				w "属性不存在",!
				continue	
			}
			s MKBExt = ..GetNewExtId(TKBExt)
			if (MKBExt="")
			{
				w "在新表中未找到对应的属性id",!
				continue	
			}
			if ($D(^TKBTREEXT(TKBExt,"Cat",TKBExtChild))=0)
			{
				w "扩展属性不存在",!
				continue	
			}
			
			s TKBTECName = $P($G(^TKBTREEXT(TKBExt,"Cat",TKBExtChild)),"^",1)
			s TKBTECName = $ZCONVERT(TKBTECName,"U")
			s MKBTECChildSub = $O(^User.MKBTermExtendProI("NameIndex",MKBExt," "_TKBTECName,0))
			if (MKBTECChildSub="")
			{
				w "扩展属性在新表中不存在",!
				continue	
			}
			s MKBTECRowId = MKBExt_"||"_MKBTECChildSub
			s TKBTEVRowId = 0
			for
			{
				s TKBTEVRowId = $O(^TKBTREEXTVALi(0,"Val",TKBTEDRowId,TKBTECRowId,TKBTEVRowId))
				q:TKBTEVRowId=""
				s TKBTEVValue = $P($G(^TKBTREEXTVAL(TKBTEVRowId)),"^",3)
				s MKBTEPVObj = ##class(User.MKBTermExtendProVal).%New()
				d MKBTEPVObj.MKBTEPVDetailDrSetObjectId(MKBDet)
				d MKBTEPVObj.MKBTEPVExtendDrSetObjectId(MKBTECRowId)	
				s MKBTEPVObj.MKBTEPVValue = TKBTEVValue
				s sc = MKBTEPVObj.%Save()
				if $$$ERROR(sc)
				{
					b	;
					continue	
				}
			}
		}
		
	}
}

/*/// ShortDesc:TKBTremItm->MKBTermProDetail
/// Creator:李欣	
/// Desc:将TKBTremItm表数据导入MKBTermProDetail表中
/// d ##class(web.DHCBL.MKB.MKBDataImport).TKBTremItm()
ClassMethod TKBTremItm()
{
	s i=0
	s TKBTRowId = 0
	for
	{
		s TKBTRowId = $O(^TKBTREMITMi(0,"Link",TKBTRowId))	
		q:TKBTRowId=""
		
		if ($D(^TKBTREM(TKBTRowId))=0)
		{
			w "此术语已不存在",!
			continue	
		}
		s TKBTCode = $P(^TKBTREM(TKBTRowId),"^",1)
		s TKBTCode = $ZCONVERT(TKBTCode,"U")
		s TKBTBRowId = $P(^TKBTREM(TKBTRowId),"^",3)
		if ($D(^User.TKBTremBaseD(TKBTBRowId))=0)
		{
			w "此术语库已不存在",!
			continue	
		}
		s TKBTBDesc = $LG($G(^User.TKBTremBaseD(TKBTBRowId)),3)
		s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," "_TKBTBDesc,0))
		s MKBTRowId = $O(^User.MKBTermI("CodeIndex",MKBTBRowId," "_TKBTCode,0))
		if (MKBTRowId="")
		{
			w "此术语在新表中不存在",!
			continue	
		}
		s TKBTBFRowId = 0
		for
		{
			s TKBTBFRowId = $O(^TKBTREMITMi(0,"Link",TKBTRowId,TKBTBFRowId))
			q:TKBTBFRowId=""
			continue:TKBTBFRowId["17||"
			continue:TKBTBFRowId["9||"
			s TKBTBID = $P(TKBTBFRowId,"||",1)
			if ($D(^User.TKBTremBaseD(TKBTBID))=0)
			{
				w "术语库中不存在",!

				continue	
			}
			s TKBTBDesc = $LG($G(^User.TKBTremBaseD(TKBTBID)),3)
			s MKBTBID = $O(^User.MKBTermBaseI("DescIndex"," "_TKBTBDesc,0))
			s TKBTBFChildSub = $P(TKBTBFRowId,"||",2)
			if ($D(^User.TKBTremBaseD(TKBTBID,"ChildField",TKBTBFChildSub))=0)
			{
				w "该字段在原表中不存在",!
				continue	
			}
			s TKBTBFFlag = $LG(^User.TKBTremBaseD(TKBTBID,"ChildField",TKBTBFChildSub),7)
			if (TKBTBFFlag'="")
			{
				continue	
			}
			s TKBTBFCode = $LG(^User.TKBTremBaseD(TKBTBID,"ChildField",TKBTBFChildSub),2)
			s TKBTBFCode = $ZCONVERT(TKBTBFCode,"U")
			s TKBTBFDesc = $LG(^User.TKBTremBaseD(TKBTBID,"ChildField",TKBTBFChildSub),3)
			s TKBTBFType = $LG(^User.TKBTremBaseD(TKBTBID,"ChildField",TKBTBFChildSub),4)
			s TKBTBFConfig = $LG(^User.TKBTremBaseD(TKBTBID,"ChildField",TKBTBFChildSub),6)
			s MKBTBPRowId = $O(^User.MKBTermBasePropertyI("CodeIndex",MKBTBID," "_TKBTBFCode,0))
			if (MKBTBPRowId="")
			{
				w "该字段在新表中不存在",!
				continue
			}
			s TKBTIRowId = $O(^TKBTREMITMi(0,"Link",TKBTRowId,TKBTBFRowId,0))
			s TermID = ""
			if (TKBTBFType="S")
			{
				s TremID=$P($G(^TKBTREMITM(TKBTIRowId)),"^",3)
				s TremCode = $ZCONVERT($P($G(^TKBTREM(TremID)),"^",1),"U")
				if ($D(^TKBTREM(TremID))=0)
				{
					w "引用的术语不存在了",!
					continue	
				}
				s TremBaseID = $P($G(^TKBTREM(TremID)),"^",3)
				if ($D(^User.TKBTremBaseD(TremBaseID))=0)
				{
					w "引用的术语库不存在了",!
					continue	
				}
				s TremBaseDesc = $LG($G(^User.TKBTremBaseD(TremBaseID)),3)
				s TermBaseID = $O(^User.MKBTermBaseI("DescIndex"," "_TremBaseDesc,0))
				s TermID = $O(^User.MKBTermI("CodeIndex",TermBaseID," "_TremCode,0))
				if (TermID="")
				{
					w "引用的术语在新表中不存在了",!
					continue	
				}
			}
			s MKBTPObj = ##class(User.MKBTermProperty).%New()
			s MKBTPObj.MKBTPCode = TKBTBFDesc
			s MKBTPObj.MKBTPDesc = TKBTBFDesc
			s MKBTPObj.MKBTPName = MKBTPObj.MKBTPDesc
			s MKBTPObj.MKBTPPublic = "N"
			s MKBTPObj.MKBTPType = TKBTBFType
			s MKBTPObj.MKBTPConfig = TKBTBFConfig
			if (TKBTBFType="S")
			{
				s TremID=$P($G(^TKBTREMITM(TKBTIRowId)),"^",3)
				s TremCode = $ZCONVERT($P($G(^TKBTREM(TremID)),"^",1),"U")
				s TremBaseID = $P($G(^TKBTREM(TremID)),"^",3)
				s TremBaseDesc = $LG($G(^User.TKBTremBaseD(TremBaseID)),3)
				s TermBaseID = $O(^User.MKBTermBaseI("DescIndex"," "_TremBaseDesc,0))
				s MKBTPObj.MKBTPConfig = TermBaseID
			}
			d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
			s sc = MKBTPObj.%Save()
			if $$$ERROR(sc)
			{
				s code = $SYSTEM.Status.GetErrorText(sc)
				b	
			}
			s MKBTPID = MKBTPObj.%Id()
			s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
			d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPID)
			s MKBTPDObj.MKBTPDCode = TKBTBFType_"000000"_i
			s MKBTPDObj.MKBTPDDesc = $P($G(^TKBTREMITM(TKBTIRowId)),"^",3)
			if (TKBTBFType="S")
			{
				s TremID=$P($G(^TKBTREMITM(TKBTIRowId)),"^",3)
				s TremCode = $ZCONVERT($P($G(^TKBTREM(TremID)),"^",1),"U")
				s TremBaseID = $P($G(^TKBTREM(TremID)),"^",3)
				s TremBaseDesc = $LG($G(^User.TKBTremBaseD(TremBaseID)),3)
				s TermBaseID = $O(^User.MKBTermBaseI("DescIndex"," "_TremBaseDesc,0))
				s TermID = $O(^User.MKBTermI("CodeIndex",TermBaseID," "_TremCode,0))
				s MKBTPDObj.MKBTPDDesc = TermID	
			}
			s MKBTPDObj.MKBTPDActiveFlag="Y"
			s sc = MKBTPDObj.%Save()
			if $$$ERROR(sc)
			{
				s code = $SYSTEM.Status.GetErrorText(sc)	
				b
			}
			s i = i + 1
		}
	}
}
*/
/// TKBTremCom->MKBTermProperty
/// Creator:李欣	
/// Desc:将TKBTremCom表数据导入MKBTermProperty表中
/// d ##class(web.DHCBL.MKB.MKBDataImport).TKBTremCom()
ClassMethod TKBTremCom()
{
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断学_临床使用诊断",0))
	s MKBTBPObj = ##class(User.MKBTermBaseProperty).%New()
	
	d MKBTBPObj.MKBTBPBaseDrSetObjectId(MKBTBRowId)
	s MKBTBPObj.MKBTBPCode = "AliasAndCom"
	s MKBTBPObj.MKBTBPDesc = "别名"
	s MKBTBPObj.MKBTBPFlag = "AL"
	s MKBTBPObj.MKBTBPName = "别名"
	s MKBTBPObj.MKBTBPType = "L"
	s sc = MKBTBPObj.%Save()
	if $$$ERROR(sc)
	{
		b	
	}
	s MKBTBPRowId = MKBTBPObj.%Id()
	
	s MKBTBEObj = ##class(User.MKBTermBaseExtendPro).%New(MKBTBPRowId)
	d MKBTBEObj.ParRefSetObjectId(MKBTBPRowId)
	s MKBTBEObj.MKBTBEPName = "检索码"
	s MKBTBEObj.MKBTBEPType = "TX"
	s sc = MKBTBEObj.%Save()
	if $$$ERROR(sc)
	{
		b	
	}
	/***********************在Tre\Type上建索引，BuildIndices********************************/
	s TKBTRowId = 0
	for
	{
		s TKBTRowId = $O(^TKBTRECOMi(0,"TreType",TKBTRowId))
		q:TKBTRowId=""
		
		if ($D(^TKBTREM(TKBTRowId))=0)
		{
			w "术语在原表中不存在",!
			continue	
		}	
		s TKBTCode = $ZCONVERT($P($G(^TKBTREM(TKBTRowId)),"^",1),"U")
		s TKBTBRowId = $P($G(^TKBTREM(TKBTRowId)),"^",3)
		if ($D(^User.TKBTremBaseD(TKBTBRowId))=0)
		{
			w "术语库在原表中不存在",!
			continue	
		}
		s TKBTBDesc = $LG($G(^User.TKBTremBaseD(TKBTBRowId)),3)
		s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," "_TKBTBDesc,0))
		s MKBTRowId = $O(^User.MKBTermI("CodeIndex",MKBTBRowId," "_TKBTCode,0))
		
		w $LG($G(^User.MKBTermD(MKBTRowId)),3),!
		s MKBTPObj = ##class(User.MKBTermProperty).%New()
		s MKBTPObj.MKBTPCode = "别名"
		s MKBTPObj.MKBTPDesc = "别名"
		s MKBTPObj.MKBTPName = "别名"
		s MKBTPObj.MKBTPPublic = "Y"
		s MKBTPObj.MKBTPFlag = "AL"
		s MKBTPObj.MKBTPType = "L"
		d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
		s sc = MKBTPObj.%Save()
		if $$$ERROR(sc)
		{
			s code = $SYSTEM.Status.GetErrorText(sc)
			b	
		}
		s MKBTPRowId =MKBTPObj.%Id()
		w "别名",MKBTPRowId,!
		s MKBTEPObj = ##class(User.MKBTermExtendPro).%New(MKBTPRowId)
		d MKBTEPObj.ParRefSetObjectId(MKBTPRowId)
		s MKBTEPObj.MKBTEPType = "TX"
		s MKBTEPObj.MKBTEPName = "检索码"
		s MKBTEPObj.MKBTEPConfig=""
		s sc = MKBTEPObj.%Save()
		if $$$ERROR(sc)
		{
			s code = $SYSTEM.Status.GetErrorText(sc)
			b
		}
		s MKBTEPRowId = MKBTEPObj.%Id()
		s i=1
		if ($D(^TKBTRECOMi(0,"TreType",TKBTRowId,"C"))'=0)
		{
			s TKBTCRowId = 0
			for
			{
				s TKBTCRowId =$O(^TKBTRECOMi(0,"TreType",TKBTRowId,"C",TKBTCRowId))
				q:TKBTCRowId=""
				s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
				s MKBTPDObj.MKBTPDActiveFlag = "Y"
				s MKBTPDObj.MKBTPDCode = "C000000"_i
				s MKBTPDObj.MKBTPDDesc = $P($G(^TKBTRECOM(TKBTCRowId)),"^",3)
				s MKBTPDObj.MKBTPDSequence = i
				d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPRowId)
				s sc = MKBTPDObj.%Save()
				if $$$ERROR(sc)
				{
					s code = $SYSTEM.Status.GetErrorText(sc)
					b	
				}	
				s i =i+1
				s MKBTPDRowId = MKBTPDObj.%Id()
				s TKBTEPVObj =##class(User.MKBTermExtendProVal).%New()
				d TKBTEPVObj.MKBTEPVDetailDrSetObjectId(MKBTPDRowId)
				d TKBTEPVObj.MKBTEPVExtendDrSetObjectId(MKBTEPRowId)
				if ($D(^TKBTREKEYi(0,"Tre","C",TKBTCRowId))=0)
				{
					s jsm = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($P($G(^TKBTRECOM(TKBTCRowId)),"^",3))
				}
				else
				{
					s TKBTKRowId = $O(^TKBTREKEYi(0,"Tre","C",TKBTCRowId,0))
					s jsm = $P($G(^TKBTREKEY(TKBTKRowId)),"^",3)	
				}
				if (jsm="")
				{
					
				}
				s TKBTEPVObj.MKBTEPVValue = jsm
				s sc=TKBTEPVObj.%Save()
				if $$$ERROR(sc)
				{
					s code =$SYSTEM.Status.GetErrorText(sc)
					b	
				}
			}
		}
		if ($D(^TKBTRECOMi(0,"TreType",TKBTRowId,"A"))'=0)
		{
			s TKBTCRowId=0
			for
			{
				s TKBTCRowId=$O(^TKBTRECOMi(0,"TreType",TKBTRowId,"A",TKBTCRowId))
				q:TKBTCRowId=""
				s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
				s MKBTPDObj.MKBTPDActiveFlag = "Y"
				s MKBTPDObj.MKBTPDCode = "A000000"_i
				s MKBTPDObj.MKBTPDDesc = $P($G(^TKBTRECOM(TKBTCRowId)),"^",3)
				s MKBTPDObj.MKBTPDSequence = i
				d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPRowId)
				s sc = MKBTPDObj.%Save()
				if $$$ERROR(sc)
				{
					s code = $SYSTEM.Status.GetErrorText(sc)
					b	
				}	
				s i =i+1
				s MKBTPDRowId = MKBTPDObj.%Id()
				s TKBTEPVObj =##class(User.MKBTermExtendProVal).%New()
				d TKBTEPVObj.MKBTEPVDetailDrSetObjectId(MKBTPDRowId)
				d TKBTEPVObj.MKBTEPVExtendDrSetObjectId(MKBTEPRowId)
				if ($D(^TKBTREKEYi(0,"Tre","C",TKBTCRowId))=0)
				{
					s jsm = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($P($G(^TKBTRECOM(TKBTCRowId)),"^",3))
				}
				else
				{
					s TKBTKRowId = $O(^TKBTREKEYi(0,"Tre","A",TKBTCRowId,0))
					s jsm = $P($G(^TKBTREKEY(TKBTKRowId)),"^",3)	
				}
				if (jsm="")
				{
					b	
				}
				s TKBTEPVObj.MKBTEPVValue = jsm
				s sc=TKBTEPVObj.%Save()
				if $$$ERROR(sc)
				{
					s code =$SYSTEM.Status.GetErrorText(sc)
					b	
				}
			}	
		}
	}
}

/// Creator:李欣	
/// Desc:为解剖学_主要部位重新生成展示名列
/// d ##class(web.DHCBL.MKB.MKBDataImport).ReBuildZSMForJPX()
ClassMethod ReBuildZSMForJPX()
{
	S MKBTBRowId =$O(^User.MKBTermBaseI("DescIndex"," 解剖学_主要部位",0))
	s MKBTRowId=0
	s i=0
	for
	{
		s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s MKBTPObj = ##class(User.MKBTermProperty).%New()
		s MKBTPObj.MKBTPCode = "展示名"
		s MKBTPObj.MKBTPDesc = "展示名"
		s MKBTPObj.MKBTPName = "展示名"
		s MKBTPObj.MKBTPPublic = "N"
		d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
		s MKBTPObj.MKBTPType = "TX"
		s sc=MKBTPObj.%Save()
		if $$$ERROR(sc)
		{
			s code=$SYSTEM.Status.GetErrorText(sc)
			b	
		}
		s MKBTPRowId = MKBTPObj.%Id()
		s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
		s MKBTPDObj.MKBTPDActiveFlag="Y"
		s MKBTPDObj.MKBTPDCode="TX000000"_i
		s MKBTPDObj.MKBTPDDesc=$LG($G(^User.MKBTermD(MKBTRowId)),3)
		d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPRowId)
		s sc=MKBTPDObj.%Save()
		if $$$ERROR(sc)
		{
			s code = $SYSTEM.Status.GetErrorText(sc)
			b	
		}
	}
}

/// MKBTermBase->Sequence
/// Creator:李欣	
/// Desc:为MKBTermBase生成顺序索引
/// d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermBaseSeq()
ClassMethod MKBTermBaseSeq()
{
	s MKBTBRowId=0
	for i=1:1
	{
		s MKBTBRowId=$O(^User.MKBTermBaseD(MKBTBRowId))
		q:MKBTBRowId=""
		
		s obj=##class(User.MKBTermBase).%OpenId(MKBTBRowId)
		s obj.MKBTBSequence=i
		d obj.%Save()
	}
}

/// MKBTermBaseProperty->Sequence
/// Creator:李欣	
/// Desc:为MKBTermBaseProperty生成顺序索引
/// d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermBasePropertySeq()
ClassMethod MKBTermBasePropertySeq()
{
	s MKBTBRowId=0
	for
	{
		s MKBTBRowId=$O(^User.MKBTermBasePropertyI("TermBaseIdx",MKBTBRowId))	
		q:MKBTBRowId=""
		
		s MKBTBPRowId=0
		s i=1
		for
		{
			s MKBTBPRowId=$O(^User.MKBTermBasePropertyI("TermBaseIdx",MKBTBRowId,MKBTBPRowId))
			q:MKBTBPRowId=""
			
			s MKBTBPObj = ##class(User.MKBTermBaseProperty).%OpenId(MKBTBPRowId)
			s MKBTBPObj.MKBTBPSequence=i
			s sc=MKBTBPObj.%Save()
			if $$$ERROR(sc)
			{
				s code=$SYSTEM.Status.GetErrorText(sc)
				b	
			}
			s i=i+1
		}
	}
}

/// MKBTerm->Sequence
/// Creator:李欣	
/// Desc:为MKBTerm生成顺序索引
/// d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermSeq()
ClassMethod MKBTermSeq()
{
	s MKBTBRowId=0
	for
	{
		s MKBTBRowId=$O(^User.MKBTermI("BaseIndex",MKBTBRowId))
		q:MKBTBRowId=""
		
		s i=1
		s MKBTRowId=0
		for
		{
			s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
			q:MKBTRowId=""
			s MKBTObj=##class(User.MKBTerm).%OpenId(MKBTRowId)
			s MKBTObj.MKBTSequence=i	
			s sc=MKBTObj.%Save()
			if $$$ERROR(sc)
			{
				s code=$SYSTEM.Status.GetErrorText(sc)
				b	
			}
			s i=i+1	
		}
		
	}
}

/// MKBTermProperty->Sequence
/// Creator:李欣	
/// Desc:为MKBTermProperty生成顺序索引
/// d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermPropertySeq()
ClassMethod MKBTermPropertySeq()
{
	s MKBTRowId=0
	for
	{
		s MKBTRowId=$O(^User.MKBTermPropertyI("TermIndex",MKBTRowId))
		q:MKBTRowId=""
		
		s i=1
		s MKBTPRowId=0
		for
		{
			s MKBTPRowId=$O(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId))
			q:MKBTPRowId=""
			
			s MKBTPObj=##class(User.MKBTermProperty).%OpenId(MKBTPRowId)
			s MKBTPObj.MKBTPSequence=i	
			s sc=MKBTPObj.%Save()
			if $$$ERROR(sc)
			{
				s code=$SYSTEM.Status.GetErrorText(sc)
				b	
			}
			s i=i+1
		}	
	}
}

/// MKBTermProDetail->Sequence
/// Creator:李欣	
/// Desc:为MKBTermProDetail生成顺序索引
/// d ##class(web.DHCBL.MKB.MKBDataImport).MKBTermProDetailSeq()
ClassMethod MKBTermProDetailSeq()
{
	s MKBTPRowId=0
	for
	{
		s MKBTPRowId=$O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId))
		q:MKBTPRowId=""
		
		s i=1
		s MKBTPDRowId=0
		for
		{
			s MKBTPDRowId=$O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
			q:MKBTPDRowId=""
			
			s MKBTPDObj = ##class(User.MKBTermProDetail).%OpenId(MKBTPDRowId)
			if (MKBTPDObj.MKBTPDSequence'="")
			{
				continue	
			}
			s MKBTPDObj.MKBTPDSequence=i
			s sc=MKBTPDObj.%Save()
			if $$$ERROR(sc)
			{
				s code=$SYSTEM.Status.GetErrorText(sc)
				b	
			}
			s i=i+1
		}	
	}
}

/// Desc:为北京版ICD添加中文释义及ICD编码公有属性，将原Code值赋给ICD编码属性，将Desc赋给中文释义
/// Creator：李欣
/// CreateDate:20180508
/// Debug:d ##class(web.DHCBL.MKB.MKBDataImport).BJICD()
ClassMethod BJICD()
{
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断_ICD10北京码",0))
	
	s MKBTBPObj = ##class(User.MKBTermBaseProperty).%New()
	d MKBTBPObj.MKBTBPBaseDrSetObjectId(MKBTBRowId)
	s MKBTBPObj.MKBTBPCode = "BP"_MKBTBRowId_"1"
	s MKBTBPObj.MKBTBPDesc = "中文释义"
	s MKBTBPObj.MKBTBPName = "中文释义"
	s MKBTBPObj.MKBTBPType = "TX"
	d MKBTBPObj.%Save()
	
	s MKBTBPObj = ##class(User.MKBTermBaseProperty).%New()
	d MKBTBPObj.MKBTBPBaseDrSetObjectId(MKBTBRowId)
	s MKBTBPObj.MKBTBPCode = "BP"_MKBTBRowId_"2"
	s MKBTBPObj.MKBTBPDesc = "ICD编码"
	s MKBTBPObj.MKBTBPName = "ICD编码"
	s MKBTBPObj.MKBTBPType = "TX"
	d MKBTBPObj.%Save()
	
	s MKBTRowId = 0
	
	for
	{
		s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		s i=1
		s MKBTPObj = ##class(User.MKBTermProperty).%New()
		s MKBTPObj.MKBTPCode = "P"_MKBTRowId_i
		s MKBTPObj.MKBTPDesc = "中文释义"
		s MKBTPObj.MKBTPPublic = "Y"
		d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
		s MKBTPObj.MKBTPType = "TX"
		s MKBTPObj.MKBTPName = "中文释义"
		d MKBTPObj.%Save()
		
		s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
		s MKBTPDObj.MKBTPDCode = "D"_MKBTRowId_i_"1"
		s MKBTPDObj.MKBTPDDesc = $LG($G(^User.MKBTermD(MKBTRowId)),3)
		d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPObj.%Id())
		d MKBTPDObj.%Save()
		s i=i+1
		
		s MKBTPObj = ##class(User.MKBTermProperty).%New()
		s MKBTPObj.MKBTPCode = "P"_MKBTRowId_i_"2"
		s MKBTPObj.MKBTPDesc = "ICD编码"
		s MKBTPObj.MKBTPPublic = "Y"
		d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
		s MKBTPObj.MKBTPType = "TX"
		s MKBTPObj.MKBTPName = "ICD编码"
		d MKBTPObj.%Save()
		
		s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
		s MKBTPDObj.MKBTPDCode = "D"_MKBTRowId_i_"1"
		s MKBTPDObj.MKBTPDDesc = $LG($G(^User.MKBTermD(MKBTRowId)),2)
		d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPObj.%Id())
		d MKBTPDObj.%Save()
	}
}

/// Desc:国际码中心词改为描述编码放在属性里
/// Creator：李欣
/// CreateDate:20180508
/// Debug:d ##class(web.DHCBL.MKB.MKBDataImport).NationICD()
ClassMethod NationICD()
{
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断_ICD10国际码",0))
	
	s MKBTBPObj = ##class(User.MKBTermBaseProperty).%New()
	d MKBTBPObj.MKBTBPBaseDrSetObjectId(MKBTBRowId)
	s MKBTBPObj.MKBTBPCode = "BP"_MKBTBRowId_"2"
	s MKBTBPObj.MKBTBPDesc = "ICD编码"
	s MKBTBPObj.MKBTBPName = "ICD编码"
	s MKBTBPObj.MKBTBPType = "TX"
	d MKBTBPObj.%Save()
	
	s MKBTRowId = 0
	
	for
	{
		s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		s i=1
		
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 中文释义字段",0))
		s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0))
		s tmp = $LG($G(^User.MKBTermD(MKBTRowId)),3)
		s MKBTObj = ##class(User.MKBTerm).%OpenId(MKBTRowId)
		s MKBTObj.MKBTDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		d MKBTObj.%Save()
		
		s MKBTPObj = ##class(User.MKBTermProperty).%New()
		s MKBTPObj.MKBTPCode = "P"_MKBTRowId_i_"1"
		s MKBTPObj.MKBTPDesc = "ICD编码"
		s MKBTPObj.MKBTPPublic = "Y"
		d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
		s MKBTPObj.MKBTPType = "TX"
		s MKBTPObj.MKBTPName = "ICD编码"
		d MKBTPObj.%Save()
		
		s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
		s MKBTPDObj.MKBTPDCode = "D"_MKBTRowId_i_"1"
		s MKBTPDObj.MKBTPDDesc = tmp
		d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPObj.%Id())
		d MKBTPDObj.%Save()
	}
}

/// Desc:MRCICDDx 数据导入术语库中
/// Creator：李欣
/// CreateDate:20180508
/// Debug:d ##class(web.DHCBL.MKB.MKBDataImport).HisICD()
ClassMethod HisICD()
{
	s MKBTBObj = ##class(User.MKBTermBase).%New()
	s MKBTBObj.MKBTBCode = "ZD_ICDHIS码"
	s MKBTBObj.MKBTBDesc = "诊断_ICDHIS码"
	s MKBTBObj.MKBTBPYCode = "ZDICDHISM"
	s MKBTBObj.MKBTBType = "L"
	s t = $O(^User.MKBTermBaseI("DescIndex"," 诊断_ICD10国际码",0))
	s MKBTBObj.MKBTBCatDr = $LG($G(^User.MKBTermBaseD(t)),9)
	s MKBTBObj.MKBTBSequence = $O(^User.MKBTermBaseI("SeqIndex",""),-1)
	d MKBTBObj.%Save()
	
	s MKBTBRowId = MKBTBObj.%Id()
	
	s menuobj=##class(User.BDPMenu).%New()
	s menuobj.Code = "dhc.bdp.mkb.mtm."_MKBTBObj.MKBTBCode           
	s menuobj.Caption = MKBTBObj.MKBTBDesc   
	s menuobj.LinkFuntionDR=""      
   	s menuobj.LinkUrl = "dhc.bdp.mkb.mkblistterm.csp"  
	s ParentMenuDr=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM",0))
	d menuobj.ParentMenuDrSetObjectId(ParentMenuDr)
	s menuobj.Sequence = MKBTBObj.MKBTBSequence //##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence(ParentMenuDr)
	s menuobj.ValueExpression="&base="_MKBTBRowId
	s menuobj.ActiveFlag="1^1^1"
	s menuobj.IsMKBMenu="Y"
	s menuobj.UpdateDate = +$p($h,",",1)
	s menuobj.UpdateTime = +$p($h,",",2)
	d menuobj.UpdateUserSetObjectId(1)
	s sc = menuobj.%Save()
	
	s MKBTBPObj = ##class(User.MKBTermBaseProperty).%New()
	d MKBTBPObj.MKBTBPBaseDrSetObjectId(MKBTBRowId)
	s MKBTBPObj.MKBTBPCode = "BP"_MKBTBRowId_"1"
	s MKBTBPObj.MKBTBPDesc = "中文释义"
	s MKBTBPObj.MKBTBPName = "中文释义"
	s MKBTBPObj.MKBTBPType = "TX"
	d MKBTBPObj.%Save()
	
	s MKBTBPObj = ##class(User.MKBTermBaseProperty).%New()
	d MKBTBPObj.MKBTBPBaseDrSetObjectId(MKBTBRowId)
	s MKBTBPObj.MKBTBPCode = "BP"_MKBTBRowId_"2"
	s MKBTBPObj.MKBTBPDesc = "ICD编码"
	s MKBTBPObj.MKBTBPName = "ICD编码"
	s MKBTBPObj.MKBTBPType = "TX"
	d MKBTBPObj.%Save()
	
	
	s MRCRowId = 0
	s i=1
	for
	{
		s MRCRowId = $O(^MRC("ID",MRCRowId))
		q:MRCRowId=""
		
		s MKBTObj = ##class(User.MKBTerm).%New()
		s MKBTObj.MKBTCode = $P($G(^MRC("ID",MRCRowId)),"^",1)
		s MKBTObj.MKBTDesc = $P($G(^MRC("ID",MRCRowId)),"^",2)
		s MKBTObj.MKBTPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTObj.MKBTDesc)
		s MKBTObj.MKBTSequence = i
		d MKBTObj.MKBTBaseDRSetObjectId(MKBTBRowId)
		s sc = MKBTObj.%Save()
		if $$$ERROR(sc)
		{
			b	;1
		}
		
		s MKBTRowId = MKBTObj.%Id()
		s i = i+1
		
		s MKBTPObj = ##class(User.MKBTermProperty).%New()
		s MKBTPObj.MKBTPCode = "P"_MKBTRowId_"1"
		s MKBTPObj.MKBTPDesc = "中文释义"
		s MKBTPObj.MKBTPPublic = "Y"
		d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
		s MKBTPObj.MKBTPType = "TX"
		s MKBTPObj.MKBTPName = "中文释义"
		s sc = MKBTPObj.%Save()
		if $$$ERROR(sc)
		{
			b	;2
		}
		
		s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
		s MKBTPDObj.MKBTPDCode = "D"_MKBTRowId_"1"
		s MKBTPDObj.MKBTPDDesc = $P($G(^MRC("ID",MRCRowId)),"^",2)
		d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPObj.%Id())
		s sc = MKBTPDObj.%Save()
		if $$$ERROR(sc)
		{
			b	;3
		}
		
		s MKBTPObj = ##class(User.MKBTermProperty).%New()
		s MKBTPObj.MKBTPCode = "P"_MKBTRowId_"2"
		s MKBTPObj.MKBTPDesc = "ICD编码"
		s MKBTPObj.MKBTPPublic = "Y"
		d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
		s MKBTPObj.MKBTPType = "TX"
		s MKBTPObj.MKBTPName = "ICD编码"
		s sc = MKBTPObj.%Save()
		if $$$ERROR(sc)
		{
			b	;4
		}
		s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
		s MKBTPDObj.MKBTPDCode = "D"_MKBTRowId_"1"
		s MKBTPDObj.MKBTPDDesc = $P($G(^MRC("ID",MRCRowId)),"^",4)
		d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPObj.%Id())
		s sc = MKBTPDObj.%Save()
		if $$$ERROR(sc)
		{
			b	;5
		}
		
	}
}

/// Desc:将所有树形引用术语的内容上下级存入，所有上级及级别清空
ClassMethod DealSProDesc()
{
	s MKBTPRowId = 0
	for
	{
		s MKBTPRowId = $O(^User.MKBTermPropertyD(MKBTPRowId))
		q:MKBTPRowId=""	
		
		s MKBTPType = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
		s MKBTPConfig = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),5)
		continue:MKBTPType'="S"
		s MKBTBType = $LG($G(^User.MKBTermBaseD(MKBTPConfig)),4)
		continue:MKBTBType'="T"
		
		k a
		s MKBTPDRowId = 0
		for
		{
			s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
			q:MKBTPDRowId=""	
			
			s a(MKBTPDRowId)=""
		}
		
		s MKBTPDRowId = 0
		for
		{
			s MKBTPDRowId = $O(a(MKBTPDRowId))
			q:MKBTPDRowId=""
			
			s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
			if ($D(^User.MKBTermI("ParentIndex",MKBTPConfig,MKBTPDDesc))'=0)
			{
				s flag = ..SaveTreeSou2(MKBTPDDesc,MKBTPConfig,MKBTPRowId)
				if (flag=1)
				{
					b	
				}
			}
			s TempId = MKBTPDDesc
			while($LG($G(^User.MKBTermD(TempId)),5)'="")
			{
				
				s Last = $LG($G(^User.MKBTermD(TempId)),5)
				if (..IsSExist(MKBTPRowId,Last)'="Y")
				{
					s Obj = ##class(User.MKBTermProDetail).%New()
					s Obj.MKBTPDCode = $LG($G(^User.MKBTermD(TempId)),2)
					s Obj.MKBTPDDesc = Last
					d Obj.MKBTPDProDRSetObjectId(MKBTPRowId)
					s sc = Obj.%Save()
					if $$$ERROR(sc)
					{
						b ;scerror	
					}	
					s result = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","D",Obj.%Id(),"T",Last)
					if (result["error")
					{
						b ;reuslt[error	
					}
				}
				s TempId=Last
			}
		}
		
		
	}
}

/// 清除引用术语类型上级分类重新赋值
ClassMethod ClearTSLastLevel()
{
	s MKBTPRowId = 0
	for
	{
		s MKBTPRowId = $O(^User.MKBTermPropertyD(MKBTPRowId))
		q:MKBTPRowId=""	
		
		s MKBTPType = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
		s MKBTPConfig = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),5)
		continue:MKBTPType'="S"
		s MKBTBType = $LG($G(^User.MKBTermBaseD(MKBTPConfig)),4)
		continue:MKBTBType'="T"
		
		s MKBTPDRowId = 0
		for
		{
			s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
			q:MKBTPDRowId=""	
			
			s obj = ##class(User.MKBTermProDetail).%OpenId(MKBTPDRowId)
			s obj.MKBTPDLastLevel=""
			s obj.MKBTPDLevel=""
			d obj.%Save()
		}
	}
}

/// 插入程合贵需要的测试数据
/// d ##class(web.DHCBL.MKB.MKBDataImport).SetCS()
ClassMethod SetCS()
{
	s MKBTRowId = $O(^User.MKBTermI("DescIndex",5," 肺及支气管恶性肿瘤",0))
	
	s MKBTObj = ##class(User.MKBTerm).%OpenId(MKBTRowId)
	s MKBTObj.MKBTNote = "肺癌是发病率和死亡率增长最快，对人群健康和生命威胁最大的恶性肿瘤之一。近50年来许多国家都报道肺癌的发病率和死亡率均明显增高，男性肺癌发病率和死亡率均占所有恶性肿瘤的第一位，女性发病率占第二位，死亡率占第二位。肺癌的病因至今尚不完全明确，大量资料表明，长期大量吸烟与肺癌的发生有非常密切的关系。已有的研究证明：长期大量吸烟者患肺癌的概率是不吸烟者的10～20倍，开始吸烟的年龄越小，患肺癌的几率越高。此外，吸烟不仅直接影响本人的身体健康，还对周围人群的健康产生不良影响，导致被动吸烟者肺癌患病率明显增加。城市居民肺癌的发病率比农村高，这可能与城市大气污染和烟尘中含有致癌物质有关。因此应该提倡不吸烟，并加强城市环境卫生工作。"
	d MKBTObj.%Save()
	
	s MKBTPObj = ##class(User.MKBTermProperty).%New()
	s MKBTPObj.MKBTPCode = "TP00000001"
	s MKBTPObj.MKBTPDesc = "文本测试"
	s MKBTPObj.MKBTPType = "TX"
	d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
	s MKBTPObj.MKBTPPublic = ""
	d MKBTPObj.%Save()
	s MKBTPRowId = MKBTPObj.%Id()
	
	s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
	s MKBTPDObj.MKBTPDCode = "TPD0000001"
	s MKBTPDObj.MKBTPDDesc = "文本测试"
	d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPRowId)
	d MKBTPDObj.%Save()
	
	
	s MKBTPObj = ##class(User.MKBTermProperty).%New()
	s MKBTPObj.MKBTPCode = "TP00000002"
	s MKBTPObj.MKBTPDesc = "多行文本测试"
	s MKBTPObj.MKBTPType = "TA"
	d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
	s MKBTPObj.MKBTPPublic = ""
	d MKBTPObj.%Save()
	s MKBTPRowId = MKBTPObj.%Id()
	
	s MKBTPDObj = ##class(User.MKBTermProDetail).%New()
	s MKBTPDObj.MKBTPDCode = "TPD0000001"
	s MKBTPDObj.MKBTPDDesc = "多行文本测试"
	d MKBTPDObj.MKBTPDProDRSetObjectId(MKBTPRowId)
	d MKBTPDObj.%Save()
	
	
	s MKBTPObj = ##class(User.MKBTermProperty).%New()
	s MKBTPObj.MKBTPCode = "TP00000003"
	s MKBTPObj.MKBTPDesc = "下拉框测试"
	s MKBTPObj.MKBTPType = "C"
	s MKBTPObj.MKBTPConfig = "1"
	d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
	s MKBTPObj.MKBTPPublic = ""
	d MKBTPObj.%Save()
	s MKBTPRowId = MKBTPObj.%Id()
	

	s MKBTPObj = ##class(User.MKBTermProperty).%New()
	s MKBTPObj.MKBTPCode = "TP00000004"
	s MKBTPObj.MKBTPDesc = "单选框测试"
	s MKBTPObj.MKBTPType = "R"
	s MKBTPObj.MKBTPConfig = "1"
	d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
	s MKBTPObj.MKBTPPublic = ""
	d MKBTPObj.%Save()
	s MKBTPRowId = MKBTPObj.%Id()
	
	
	s MKBTPObj = ##class(User.MKBTermProperty).%New()
	s MKBTPObj.MKBTPCode = "TP00000005"
	s MKBTPObj.MKBTPDesc = "多选框测试"
	s MKBTPObj.MKBTPType = "CB"
	s MKBTPObj.MKBTPConfig = "1"
	d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
	s MKBTPObj.MKBTPPublic = ""
	d MKBTPObj.%Save()
	s MKBTPRowId = MKBTPObj.%Id()
	
	
	s MKBTPObj = ##class(User.MKBTermProperty).%New()
	s MKBTPObj.MKBTPCode = "TP00000006"
	s MKBTPObj.MKBTPDesc = "表单测试"
	s MKBTPObj.MKBTPType = "F"
	s MKBTPObj.MKBTPConfig = "1"
	d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
	s MKBTPObj.MKBTPPublic = ""
	d MKBTPObj.%Save()
	s MKBTPRowId = MKBTPObj.%Id()
		
	
	s MKBTPObj = ##class(User.MKBTermProperty).%New()
	s MKBTPObj.MKBTPCode = "TP00000007"
	s MKBTPObj.MKBTPDesc = "引用属性测试"
	s MKBTPObj.MKBTPType = "P"
	s MKBTPObj.MKBTPConfig = ""
	d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
	s MKBTPObj.MKBTPPublic = ""
	d MKBTPObj.%Save()
	s MKBTPRowId = MKBTPObj.%Id()
	
	
	s MKBTPObj = ##class(User.MKBTermProperty).%New()
	s MKBTPObj.MKBTPCode = "TP00000008"
	s MKBTPObj.MKBTPDesc = "引用属性内容测试"
	s MKBTPObj.MKBTPType = "SD"
	s MKBTPObj.MKBTPConfig = ""
	d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
	s MKBTPObj.MKBTPPublic = ""
	d MKBTPObj.%Save()
	s MKBTPRowId = MKBTPObj.%Id()
	
	
	s MKBTPObj = ##class(User.MKBTermProperty).%New()
	s MKBTPObj.MKBTPCode = "TP00000009"
	s MKBTPObj.MKBTPDesc = "引用属性内容测试"
	s MKBTPObj.MKBTPType = "SD"
	s MKBTPObj.MKBTPConfig = ""
	d MKBTPObj.MKBTPTermDrSetObjectId(MKBTRowId)
	s MKBTPObj.MKBTPPublic = ""
	d MKBTPObj.%Save()
	s MKBTPRowId = MKBTPObj.%Id()
}

/// 获取旧表中对应的TermId
ClassMethod GetOldTermID(MKBTRowId)
{
	q:MKBTRowId="" ""
	s MKBTCode = $ZCONVERT($LG($G(^User.MKBTermD(MKBTRowId)),2),"U")
	s MKBTBRowId = $LG($G(^User.MKBTermD(MKBTRowId)),4)
	s MKBTBDesc = $LG($G(^User.MKBTermBaseD(MKBTBRowId)),3)
	s TKBTBRowId = $O(^User.TKBTremBaseI("DescIndex"," "_MKBTBDesc,0))
	s TKBTRowId = $O(^TKBTREMi(0,"Code",TKBTBRowId,MKBTCode,0))
	q TKBTRowId
}

/// 获取新表中对应的TermId
ClassMethod GetNewTermID(TKBTRowId)
{
	q:TKBTRowId="" ""
	s TKBTCode = $P($G(^TKBTREM(TKBTRowId)),"^",1)
	s TKBTCode = $ZCONVERT(TKBTCode,"U")
	s TKBTBRowId = $P($G(^TKBTREM(TKBTRowId)),"^",3)
	if ($D(^TKBTREM(TKBTRowId))=0)
	{
		q ""	
	}
	s TKBTBDesc = $LG($G(^User.TKBTremBaseD(TKBTBRowId)),3)
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," "_TKBTBDesc,0))
	s MKBTRowId = $O(^User.MKBTermI("CodeIndex",MKBTBRowId," "_TKBTCode,0))
	q MKBTRowId
}

}

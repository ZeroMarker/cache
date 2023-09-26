/// 名称:导出医用知识库数据
/// 编写者：基础平台组-张云越 
/// 编写日期: 2019-09-12
Class web.DHCBL.MKB.ExportMKBData Extends %RegisteredObject
{

/// Creator:张云越
/// CreatDate:2019-09-27
/// Description：批处理数据导出
/// Table： User.MKBBatchProcess
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportBatchProcessData("D:\测试\")
ClassMethod ExportBatchProcessData(filePath As %String)
{
	d $system.OBJ.Export("^User.MKBBatchProcessD.GBL",filePath_"User.MKBBatchProcessD.gof")
	d $system.OBJ.Export("^User.MKBBatchProcessI.GBL",filePath_"User.MKBBatchProcessI.gof")
	q "{success:'true',info:'2'}"
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-24
/// Description：导出医用知识库global
/// Table： 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportMKBGlobal("D:\测试\")
ClassMethod ExportMKBGlobal(filePath As %String)
{
	k CList
	k myIdx
	s CList($i(CList))= "User.MKBTermBaseD.GBL"  //术语库注册表
    s CList($i(CList))= "User.MKBTermBaseI.GBL" //术语库注册表
    s CList($i(CList))= "User.MKBTermBasePropertyI.GBL"  //术语库注册属性表 
    s CList($i(CList))= "User.MKBTermBasePropertyD.GBL" //术语库注册属性表 
    s CList($i(CList))= "User.MKBTermBasePropertyC.GBL" //术语库注册属性表 
    s CList($i(CList))= "User.MKBTermBaseExtendProI.GBL" //术语库注册扩展属性表
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
	s CList($i(CList))= "User.MKBBookMarksD.GBL"
	s CList($i(CList))= "User.MKBKLMappingBaseD.GBL"
	s CList($i(CList))= "User.MKBKLMappingBaseI.GBL"
	s CList($i(CList))= "User.MKBKLMappingBaseC.GBL"
	s CList($i(CList))= "User.MKBKLMappingBaseFieldI.GBL"
	s CList($i(CList))= "User.MKBKLMappingDetailD.GBL"
	s CList($i(CList))= "User.MKBKLMappingDetailI.GBL"
	s CList($i(CList))= "User.MKBAssessmentBaseD.GBL"
	s CList($i(CList))= "User.MKBAssessmentBaseI.GBL"
	s CList($i(CList))= "User.MKBAssessmentBaseC.GBL"
	s CList($i(CList))= "User.MKBAssessmentBaseFieldI.GBL"
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
	
	s CList($i(CList))= "User.MKBReferenceD.GBL"
	s CList($i(CList))= "User.MKBReferenceI.GBL"
	s CList($i(CList))= "User.MKBDocManageD.GBL"
	s CList($i(CList))= "User.MKBDocManageI.GBL"
	s CList($i(CList))= "User.MKBMappingSortRelyD.GBL"
	s CList($i(CList))= "User.MKBMappingSortRelyI.GBL"
	s CList($i(CList))= "User.MKBMappingTermRelyD.GBL"
	s CList($i(CList))= "User.MKBMappingTermRelyI.GBL"
	s CList($i(CList))= "User.MKBDataStatisticsD.GBL"
	s CList($i(CList))= "User.MKBDataStatisticsI.GBL"
	
	
	s CList($i(CList))= "User.MKBStructuredDataD.GBL"
	s CList($i(CList))= "User.MKBStructuredDataI.GBL"
	s CList($i(CList))= "User.MKBStructuredDataResultI.GBL"
	s CList($i(CList))= "User.MKBStructuredDataLocI.GBL"
	s CList($i(CList))= "User.MKBStructuredDataOtherI.GBL"
	
	s CList($i(CList))= "User.MKBICDContrastD.GBL"
	s CList($i(CList))= "User.MKBICDContrastI.GBL"
	s CList($i(CList))= "User.MKBICDContrastResultI.GBL"
		
	s CList($i(CList))= "User.MKBHISICDContrastD.GBL"
	s CList($i(CList))= "User.MKBHISICDContrastI.GBL"
	s CList($i(CList))= "User.MKBHISICDContrastResultI.GBL"
	
	s CList($i(CList))= "User.MKBICDRelyD.GBL"
	s CList($i(CList))= "User.MKBICDRelyI.GBL"
	
	
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	;s filename = "D:\MKBGlobal\NewTable\MKBData"_time_".gof"
	s filename = filePath_"MKBData"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	s time = $zd(+$H-10,3)
	w time,!
	;s filename = "D:\MKBGlobal\NewTable\MKBData"_time_".gof"
	s filename = filePath_"MKBData"_time_".gof"
	s filename = $tr(filename,"-","")
	s flag = ##class(%Library.File).Exists(filename,"")
	d:flag=1 ##class(%Library.File).ComplexDelete(filename,"")
	d ##class(web.DHCBL.MKB.MKBDataImport).CalcuKnoNum()
	s result = "{success:'true',info:'1'}"
	q result
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-24
/// Description：医用知识库global批量导出
/// Table： 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportGlobals("D:\测试\")
ClassMethod ExportGlobals(filePath As %String)
{
	d $system.OBJ.Export("^User.MKBTermBaseD.GBL",filePath_"User.MKBTermBaseD.gof")
	d $system.OBJ.Export("^User.MKBTermBaseI.GBL",filePath_"User.MKBTermBaseI.gof")
	d $system.OBJ.Export("^User.MKBTermBasePropertyI.GBL",filePath_"User.MKBTermBasePropertyI.gof")
	d $system.OBJ.Export("^User.MKBTermBasePropertyD.GBL",filePath_"User.MKBTermBasePropertyD.gof")
	d $system.OBJ.Export("^User.MKBTermBasePropertyC.GBL",filePath_"User.MKBTermBasePropertyC.gof")
	d $system.OBJ.Export("^User.MKBTermBaseExtendProI.GBL",filePath_"User.MKBTermBaseExtendProI.gof")
	d $system.OBJ.Export("^User.MKBTermD.GBL",filePath_"User.MKBTermD.gof")
	d $system.OBJ.Export("^User.MKBTermI.GBL",filePath_"User.MKBTermI.gof")
	d $system.OBJ.Export("^User.MKBTermPropertyD.GBL",filePath_"User.MKBTermPropertyD.gof")
	d $system.OBJ.Export("^User.MKBTermPropertyI.GBL",filePath_"User.MKBTermPropertyI.gof")
	d $system.OBJ.Export("^User.MKBTermPropertyC.GBL",filePath_"User.MKBTermPropertyC.gof")
	d $system.OBJ.Export("^User.MKBTermExtendProI.GBL",filePath_"User.MKBTermExtendProI.gof")
	d $system.OBJ.Export("^User.MKBTermProDetailD.GBL",filePath_"User.MKBTermProDetailD.gof")
	d $system.OBJ.Export("^User.MKBTermProDetailI.GBL",filePath_"User.MKBTermProDetailI.gof")
	d $system.OBJ.Export("^User.MKBTermExtendProValD.GBL",filePath_"User.MKBTermExtendProValD.gof")
	d $system.OBJ.Export("^User.MKBTermExtendProValI.GBL",filePath_"User.MKBTermExtendProValI.gof")
	d $system.OBJ.Export("^User.MKBReferenceD.GBL",filePath_"User.MKBReferenceD.gof")
	d $system.OBJ.Export("^User.MKBReferenceI.GBL",filePath_"User.MKBReferenceI.gof")
	d $system.OBJ.Export("^User.MKBDocManageD.GBL",filePath_"User.MKBDocManageD.gof")
	d $system.OBJ.Export("^User.MKBDocManageI.GBL",filePath_"User.MKBDocManageI.gof")
	d $system.OBJ.Export("^User.BDPUserHabitHisUiI.GBL",filePath_"User.BDPUserHabitHisUiI.gof")
	d $system.OBJ.Export("^User.BDPDataHistoryD.GBL",filePath_"User.BDPDataHistoryD.gof")
	d $system.OBJ.Export("^User.BDPDataHistoryI.GBL",filePath_"User.BDPDataHistoryI.gof")
	d $system.OBJ.Export("^User.BDPUserHabitHisUiD.GBL",filePath_"User.BDPUserHabitHisUiD.gof")
	d $system.OBJ.Export("^User.MKBKLMappingDetailD.GBL",filePath_"User.MKBKLMappingDetailD.gof")
	d $system.OBJ.Export("^User.MKBKLMappingDetailI.GBL",filePath_"User.MKBKLMappingDetail.gof")
	d $system.OBJ.Export("^User.MKBKLMappingBaseD.GBL",filePath_"User.MKBKLMappingBaseD.gof")
	d $system.OBJ.Export("^User.MKBKLMappingBaseI.GBL",filePath_"User.MKBKLMappingBaseI.gof")
	d $system.OBJ.Export("^User.MKBKLMappingBaseC.GBL",filePath_"User.MKBKLMappingBaseC.gof")
	d $system.OBJ.Export("^User.MKBKLMappingBaseFieldI.GBL",filePath_"User.MKBKLMappingBaseFieldI.gof")
	d $system.OBJ.Export("^User.MKBAssessmentBaseD.GBL",filePath_"User.MKBAssessmentBaseD.gof")
	d $system.OBJ.Export("^User.MKBAssessmentBaseI.GBL",filePath_"User.MKBAssessmentBaseI.gof")
	d $system.OBJ.Export("^User.MKBAssessmentBaseC.GBL",filePath_"User.MKBAssessmentBaseC.gof")
	d $system.OBJ.Export("^User.MKBAssessmentBaseFieldI.GBL",filePath_"User.MKBAssessmentBaseFieldI.gof")
	d $system.OBJ.Export("^User.BDPMKBIndexD.GBL",filePath_"User.BDPMKBIndexD.gof")
	d $system.OBJ.Export("^User.BDPMKBIndexI.GBL",filePath_"User.BDPMKBIndexI.gof")
	d $system.OBJ.Export("^User.MKBDataStatisticsD.GBL",filePath_"User.MKBDataStatisticsD.gof")
	d $system.OBJ.Export("^User.MKBMappingTermRelyD.GBL",filePath_"User.MKBMappingTermRelyD.gof")
	d $system.OBJ.Export("^User.MKBMappingSortRelyD.GBL",filePath_"User.MKBMappingSortRelyD.gof")
	d $system.OBJ.Export("^User.MKBDataStatisticsI.GBL",filePath_"User.MKBDataStatisticsI.gof")
	d $system.OBJ.Export("^User.MKBMappingTermRelyI.GBL",filePath_"User.MKBMappingTermRelyI.gof")
	;d $system.OBJ.Export("^User.MKBStructuredDataD.GBL",filePath_"User.MKBStructuredDataD.gof")
	d $system.OBJ.Export("^User.MKBStructuredDataI.GBL",filePath_"User.MKBStructuredDataI.gof")
	d $system.OBJ.Export("^User.MKBStructuredDataResultI.GBL",filePath_"User.MKBStructuredDataResultI.gof")
	d $system.OBJ.Export("^User.MKBStructuredDataLocI.GBL",filePath_"User.MKBStructuredDataLocI.gof")
	d $system.OBJ.Export("^User.MKBStructuredDataOtherI.GBL",filePath_"User.MKBStructuredDataOtherI.gof")
	d $system.OBJ.Export("^User.MKBStructuredDataD.GBL",filePath_"User.MKBStructuredDataD.gof")
	
	q "{success:'true',info:'46'}"
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：把数据处理工厂中，匹配到的ICD中文描述和MRC中的中文描述对比得到的rowid重新赋值
/// Table：User.MKBStructuredData 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportICDDesc("D:\测试\","49.csv")
ClassMethod ExportICDDesc(filePath As %String, fileName As %String)
{
	s sum=0
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	d file.WriteLine("Rowid"_","_"Desc"_","_"中文描述"_","_"ICD")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s Desc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s OldMRCRowid=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
		if OldMRCRowid=""
		{
			s SignDesc=""
			s OldMRCICD=""
		}
		else
		{
			s OldMRCDesc=$p($g(^MRC("ID",OldMRCRowid)),"^",2)
			s SignDesc=$replace(OldMRCDesc,",","，")
			s OldMRCICD=$p($g(^MRC("ID",OldMRCRowid)),"^",4)
		}
		d file.WriteLine(MKBSDRowid_","_Desc_","_SignDesc_","_OldMRCICD)
		s sum=sum+1
	}
	d file.%Save()
	d file.%Close()
	k file
	;s result= "{success:'false',info:'"_sum_"'}"
	s result = "{sum:'"_sum_"'}"
	q result
}

/// Creator:张云越
/// CreatDate:2019-11-1
/// Description：把数据处理工厂中，匹配到的ICD中文描述和MRC中的中文描述对比得到的rowid重新赋值(适用于谷歌)
/// Table：User.MKBStructuredData 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportICDDescChrome()
ClassMethod ExportICDDescChrome()
{
	s sum=0
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\数据处理工厂数据对应MRC的ICD和描述"_time_".csv"
	s filename = "数据处理工厂数据对应MRC的ICD和描述"_time_".csv"
		
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.WriteLine("Rowid"_","_"Desc"_","_"中文描述"_","_"ICD")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s Desc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s OldMRCRowid=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
		if OldMRCRowid=""
		{
			s SignDesc=""
			s OldMRCICD=""
		}
		else
		{
			s OldMRCDesc=$p($g(^MRC("ID",OldMRCRowid)),"^",2)
			s SignDesc=$replace(OldMRCDesc,",","，")
			s OldMRCICD=$p($g(^MRC("ID",OldMRCRowid)),"^",4)
		}
		d file.WriteLine(MKBSDRowid_","_Desc_","_SignDesc_","_OldMRCICD)
		s sum=sum+1
	}
	d file.%Save()
	d file.%Close()
	k file

	q filename
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：导出数据处理工厂icd为00000和icd为空的诊断到excel(谷歌)
/// Table：User.MKBStructuredData MRCICDDx
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportIcdIsNullChrome()
ClassMethod ExportIcdIsNullChrome()
{
	s sum=0
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\数据处理工厂数据ICDIsNull"_time_".csv"
	s filename = "数据处理工厂数据ICDIsNull"_time_".csv"
		
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.WriteLine("诊断名,ICD编码,标记,Rowid")
	s MKBSDRowid=0
	for
	{
		s (MKBSDDiag,MKBSDMDr,MKBSDMergeFlag,MKBSDICD)=""
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
		s MKBSDMergeFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)    //MRC指向
		if MKBSDMDr'=""
		{
			s MKBSDMrc=$p($g(^MRC("ID",MKBSDMDr)),"^",2)                    //MRC中文描述
			s MKBSDICD=$p($g(^MRC("ID",MKBSDMDr)),"^",4)                   //ICD
		}
		else
		{
			s MKBSDMrc=""
			s MKBSDICD=""
		}
		if (MKBSDICD="00000")||(MKBSDICD="")||(MKBSDICD["-")
		{
			
			s:MKBSDICD="00000" ICD="'"_MKBSDICD
			s:MKBSDICD'="00000" ICD=MKBSDICD
			d file.WriteLine(MKBSDDiag_","_ICD_","_MKBSDMergeFlag_","_MKBSDRowid)
			s sum=sum+1
		}
	}
	d file.%Save()
	d file.%Close()
	k file
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：导出数据处理工厂icd为00000和icd为空的诊断到excel
/// Table：User.MKBStructuredData MRCICDDx
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportIcdIsNull("D:\测试\","ICD为空.csv")
ClassMethod ExportIcdIsNull(filePath As %String, fileName As %String)
{
	s sum=0
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	d file.WriteLine("诊断名,ICD编码,标记,Rowid")
	s MKBSDRowid=0
	for
	{
		s (MKBSDDiag,MKBSDMDr,MKBSDMergeFlag,MKBSDICD)=""
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
		s MKBSDMergeFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)    //MRC指向
		if MKBSDMDr'=""
		{
			s MKBSDMrc=$p($g(^MRC("ID",MKBSDMDr)),"^",2)                    //MRC中文描述
			s MKBSDICD=$p($g(^MRC("ID",MKBSDMDr)),"^",4)                   //ICD
		}
		else
		{
			s MKBSDMrc=""
			s MKBSDICD=""
		}
		if (MKBSDICD="00000")||(MKBSDICD="")||(MKBSDICD["-")
		{
			
			s:MKBSDICD="00000" ICD="'"_MKBSDICD
			s:MKBSDICD'="00000" ICD=MKBSDICD
			d file.WriteLine(MKBSDDiag_","_ICD_","_MKBSDMergeFlag_","_MKBSDRowid)
			s sum=sum+1
		}
	}
	d file.%Save()
	d file.%Close()
	k file
	q sum
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：导出拼音排序后的糖尿病(谷歌)
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).SeqTNBChrome()
ClassMethod SeqTNBChrome()
{
	k temppytnb
	s sum=0
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\数据处理工厂拼音排序后的糖尿病"_time_".csv"
	s filename = "数据处理工厂拼音排序后的糖尿病"_time_".csv"

	s file=##class(%File).%New(P)
	d file.Open("NWS")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s PY=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),19)
		s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		if Diag["糖尿病"
		{
			s temppytnb(PY,MKBSDRowid)=""
		}
	}
	
	s py=""
	for
	{
		s py=$o(temppytnb(py))
		q:py=""
		s rowid=0
		for
		{
			s rowid=$o(temppytnb(py,rowid))
			q:rowid=""
			s Diag=$lg($g(^User.MKBStructuredDataD(rowid)),2)
			d file.Write(Diag)
			d file.WriteLine()
			s sum=sum+1
		}	
	}
	d file.%Save()
	d file.%Close()
	s result = "{sum:'"_sum_"'}"
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：导出拼音排序后的糖尿病
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).SeqTNB("D:\测试\","拼音排序tnb.csv")
ClassMethod SeqTNB(filePath As %String, fileName As %String)
{
	k temppytnb
	s sum=0
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s PY=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),19)
		s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		if Diag["糖尿病"
		{
			s temppytnb(PY,MKBSDRowid)=""
		}
	}
	
	s py=""
	for
	{
		s py=$o(temppytnb(py))
		q:py=""
		s rowid=0
		for
		{
			s rowid=$o(temppytnb(py,rowid))
			q:rowid=""
			s Diag=$lg($g(^User.MKBStructuredDataD(rowid)),2)
			d file.Write(Diag)
			d file.WriteLine()
			s sum=sum+1
		}	
	}
	d file.%Save()
	d file.%Close()
	s result = "{sum:'"_sum_"'}"
	q result
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：导出不在数据处理工厂中的His诊断(谷歌)
/// Table：User.MKBStructuredData MRCICDDx
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).InMRCNotInSDChrome()
ClassMethod InMRCNotInSDChrome()
{
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\不在数据处理工厂的His诊断"_time_".csv"
	s filename = "不在数据处理工厂的His诊断"_time_".csv"

	s file=##class(%File).%New(P)
	d file.Open("NSW")
	s sum=0
	s MRCRowid=0
	for
	{
		s MRCRowid=$o(^MRC("ID",MRCRowid))
		q:MRCRowid=""
		s MRCDesc=$p($g(^MRC("ID",MRCRowid)),"^",2)
		if '$d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_MRCDesc))
		{
			s sum = sum+1
			;w MRCDesc,!
			s MRCDesc=$replace(MRCDesc,",","，")
			d file.WriteLine(MRCDesc)
		}
	}
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：导出不在数据处理工厂中的His诊断
/// Table：User.MKBStructuredData MRCICDDx
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).InMRCNotInSD("D:\测试\","HIS诊断未在处理工厂中的.csv")
ClassMethod InMRCNotInSD(filePath As %String, fileName As %String)
{
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NSW")
	s sum=0
	s MRCRowid=0
	for
	{
		s MRCRowid=$o(^MRC("ID",MRCRowid))
		q:MRCRowid=""
		s MRCDesc=$p($g(^MRC("ID",MRCRowid)),"^",2)
		if '$d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_MRCDesc))
		{
			s sum = sum+1
			;w MRCDesc,!
			s MRCDesc=$replace(MRCDesc,",","，")
			d file.WriteLine(MRCDesc)
		}
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：导出数据处理工厂频次大于2的数据(谷歌)
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportFre2Chrome()
ClassMethod ExportFre2Chrome()
{
	s sum=0
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\数据处理工厂频次大于2的数据"_time_".csv"
	s filename = "数据处理工厂频次大于2的数据"_time_".csv"

	s file=##class(%File).%New(P)
	d file.Open("NWS")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s Status=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)  //处理状态
		;s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
		s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
		if MKBSDMDr'=""
		{
			s MKBSDMrc=$p($g(^MRC("ID",MKBSDMDr)),"^",2)                    //MRC中文描述
			s MKBSDICD=$p($g(^MRC("ID",MKBSDMDr)),"^",4)                   //ICD
		}
		else
		{
			s MKBSDMrc=""
			s MKBSDICD=""
		}
		s ResultStr=""
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
			q:MKBSDRRowid=""
			
			s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
			s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
			s Result=##class(web.DHCBL.MKB.MKBStructedDiag).GetChiForStrucIDs(MKBSDResultID,MKBSDResultTermdr)
			s:ResultStr'="" ResultStr=ResultStr_"||"_Result
			s:ResultStr="" ResultStr=Result
		}
		s ResultStr=$tr(ResultStr,",","，")
		s MKBSDLocs=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)  //科室串
		s MKBSDLocStr=""
		if MKBSDLocs'=""
		{
			s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
			s loclen=$l(MKBSDLocs,",")
			for i=1:1:loclen
			{
				s Proid=$p(MKBSDLocs,",",i)
				s ProLocDesc=$lg($g(^User.MKBTermD(Proid)),3)
				s:MKBSDLocStr'="" MKBSDLocStr=MKBSDLocStr_"、"_ProLocDesc
				s:MKBSDLocStr="" MKBSDLocStr=ProLocDesc
			}
		}
		s AliasStr=""
		if ($D(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid)))  //存在别名
		{
			s MKBSDORowid=0
			for
			{
				s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid,MKBSDORowid))
				q:MKBSDORowid=""
				s MKBSDOAlias=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
				s:AliasStr'="" AliasStr=AliasStr_"、"_MKBSDOAlias
				s:AliasStr="" AliasStr=MKBSDOAlias
			}
		}
		s OtherStr=""
		if ($D(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid)))  //存在其他描述
		{
			s MKBSDORowid=0
			for
			{
				s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid,MKBSDORowid))
				q:MKBSDORowid=""
				s MKBSDOOther=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
				s:OtherStr'="" OtherStr=OtherStr_"、"_MKBSDOOther
				s:OtherStr="" OtherStr=MKBSDOOther
			}
		}
		s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
		s SumLoc=0
		s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
		if SumLoc>=2
		{
			s sum=sum+1
			d file.Write(MKBSDDiag_",")
			d file.Write(ResultStr_",")
			d file.Write(MKBSDICD_",")
			d file.Write(MKBSDMrc_",")
			d file.Write(AliasStr_",")
			d file.Write(OtherStr_",")
			d file.Write(MKBSDLocStr_",")
			d file.Write(Status_",")
			d file.Write(SumLoc_",")
			d file.WriteLine()
		}
	}
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：导出数据处理工厂频次大于2的数据
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportFre2("D:\测试\","数据处理工厂频次大于2的诊断.csv")
ClassMethod ExportFre2(filePath As %String, fileName As %String)
{
	s sum=0
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s Status=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)  //处理状态
		;s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
		s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
		if MKBSDMDr'=""
		{
			s MKBSDMrc=$p($g(^MRC("ID",MKBSDMDr)),"^",2)                    //MRC中文描述
			s MKBSDICD=$p($g(^MRC("ID",MKBSDMDr)),"^",4)                   //ICD
		}
		else
		{
			s MKBSDMrc=""
			s MKBSDICD=""
		}
		s ResultStr=""
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
			q:MKBSDRRowid=""
			
			s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
			s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
			s Result=##class(web.DHCBL.MKB.MKBStructedDiag).GetChiForStrucIDs(MKBSDResultID,MKBSDResultTermdr)
			s:ResultStr'="" ResultStr=ResultStr_"||"_Result
			s:ResultStr="" ResultStr=Result
		}
		s ResultStr=$tr(ResultStr,",","，")
		s MKBSDLocs=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)  //科室串
		s MKBSDLocStr=""
		if MKBSDLocs'=""
		{
			s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
			s loclen=$l(MKBSDLocs,",")
			for i=1:1:loclen
			{
				s Proid=$p(MKBSDLocs,",",i)
				s ProLocDesc=$lg($g(^User.MKBTermD(Proid)),3)
				s:MKBSDLocStr'="" MKBSDLocStr=MKBSDLocStr_"、"_ProLocDesc
				s:MKBSDLocStr="" MKBSDLocStr=ProLocDesc
			}
		}
		s AliasStr=""
		if ($D(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid)))  //存在别名
		{
			s MKBSDORowid=0
			for
			{
				s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid,MKBSDORowid))
				q:MKBSDORowid=""
				s MKBSDOAlias=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
				s:AliasStr'="" AliasStr=AliasStr_"、"_MKBSDOAlias
				s:AliasStr="" AliasStr=MKBSDOAlias
			}
		}
		s OtherStr=""
		if ($D(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid)))  //存在其他描述
		{
			s MKBSDORowid=0
			for
			{
				s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid,MKBSDORowid))
				q:MKBSDORowid=""
				s MKBSDOOther=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
				s:OtherStr'="" OtherStr=OtherStr_"、"_MKBSDOOther
				s:OtherStr="" OtherStr=MKBSDOOther
			}
		}
		s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
		s SumLoc=0
		s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
		if SumLoc>=2
		{
			s sum=sum+1
			d file.Write(MKBSDDiag_",")
			d file.Write(ResultStr_",")
			d file.Write(MKBSDICD_",")
			d file.Write(MKBSDMrc_",")
			d file.Write(AliasStr_",")
			d file.Write(OtherStr_",")
			d file.Write(MKBSDLocStr_",")
			d file.Write(Status_",")
			d file.Write(SumLoc_",")
			d file.WriteLine()
		}
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：备份安贞科室对照界面数据(谷歌)
/// Table：User.MKBKLMappingBaseField User.MKBKLMappingBase User.MKBTerm
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).BackupAnzhenLocContrastChrome()
ClassMethod BackupAnzhenLocContrastChrome()
{
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\安贞科室对照"_time_".csv"
	s filename = "安贞科室对照"_time_".csv"

	s file=##class(%File).%New(P)
	d file.Open("WSN")
	d file.WriteLine("专业科室"_","_"实际科室")
	s sum=0
	s MKBMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))
	
	s MKBMBFRowid1=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowid," 专业科室",0))
	s MKBMBFRowid2=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowid," 实际科室",0))
	
	s ProFeild=MKBMBRowid_"||"_MKBMBFRowid1
	s RelFeild=MKBMBRowid_"||"_MKBMBFRowid2
	s MKBKLNum=0
	for
	{
		s MKBKLNum=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBMBRowid,MKBKLNum))
		q:MKBKLNum=""
		s sum=sum+1
		s MKBProRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBKLNum,ProFeild,0))   //专业科室
		s MKBRelRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBKLNum,RelFeild,0))  //实际科室
		
		s Prodr=$lg($g(^User.MKBKLMappingDetailD(MKBProRowid)),2)
		s Reldr=$lg($g(^User.MKBKLMappingDetailD(MKBRelRowid)),2)
		
		s Pro=$lg($g(^User.MKBTermD(Prodr)),3)
		s Rel=$lg($g(^User.MKBTermD(Reldr)),3)
		d file.WriteLine(Pro_","_Rel)
	}
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：备份安贞科室对照界面数据
/// Table：User.MKBKLMappingBaseField User.MKBKLMappingBase User.MKBTerm
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).BackupAnzhenLocContrast("D:\测试\","安贞科室对照.csv")
ClassMethod BackupAnzhenLocContrast(filePath As %String, fileName As %String)
{
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("WSN")
	d file.WriteLine("专业科室"_","_"实际科室")
	s sum=0
	s MKBMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))
	
	s MKBMBFRowid1=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowid," 专业科室",0))
	s MKBMBFRowid2=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowid," 实际科室",0))
	
	s ProFeild=MKBMBRowid_"||"_MKBMBFRowid1
	s RelFeild=MKBMBRowid_"||"_MKBMBFRowid2
	s MKBKLNum=0
	for
	{
		s MKBKLNum=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBMBRowid,MKBKLNum))
		q:MKBKLNum=""
		s sum=sum+1
		s MKBProRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBKLNum,ProFeild,0))   //专业科室
		s MKBRelRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBKLNum,RelFeild,0))  //实际科室
		
		s Prodr=$lg($g(^User.MKBKLMappingDetailD(MKBProRowid)),2)
		s Reldr=$lg($g(^User.MKBKLMappingDetailD(MKBRelRowid)),2)
		
		s Pro=$lg($g(^User.MKBTermD(Prodr)),3)
		s Rel=$lg($g(^User.MKBTermD(Reldr)),3)
		d file.WriteLine(Pro_","_Rel)
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：导出还未对照的实际科室(谷歌)
/// Table：User.MKBKLMappingBaseField User.MKBKLMappingBase User.MKBTerm
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).FindRealProLocChrome()
ClassMethod FindRealProLocChrome()
{
	;s Path="D:\工作\2019-04-15\ProLoc\"
	s sum=0
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\未对照的实际科室"_time_".csv"
	s filename = "未对照的实际科室"_time_".csv"

	s file=##class(%File).%New(P)
	//s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s MKBTDesc=""
	s MKBProDesc=$zstrip(MKBTDesc,"<>W")
	s MKBKLMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))   //安贞科室对照basedr
	s MKBKLMFProRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 专业科室",0))
	s MKBKLMFRelRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 实际科室",0))
	;Index RowNumIndex On (MKBKMDKMBaseDr As Exact, MKBKMDRowNum As Exact);
	s MKBNumRowid=0
	for
	{
		s MKBNumRowid=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowid,MKBNumRowid))
		q:MKBNumRowid=""
		;Index ValIndex On (MKBKMDRowNum As Exact, MKBKMDKMBaseFieldDr As Exact);
		s ProLocRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBNumRowid,MKBKLMBRowid_"||"_MKBKLMFProRowid,0)) // 专业科室rowid
		s RelLocRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBNumRowid,MKBKLMBRowid_"||"_MKBKLMFRelRowid,0))  //实际科室rowid
		
		s ProLocdr=$lg($g(^User.MKBKLMappingDetailD(ProLocRowid)),2)
		s RelLocdr=$lg($g(^User.MKBKLMappingDetailD(RelLocRowid)),2)
		
		s ProLocDesc=$lg($g(^User.MKBTermD(ProLocdr)),3)
		s RelLocDesc=$lg($g(^User.MKBTermD(RelLocdr)),3)
		
		s Pro(ProLocDesc)=""
		s Rel(RelLocDesc)=""
	}
	
	s SumPro=0
	s m=0
	for
	{
		s m=$o(Pro(m))
		q:m=""
		s SumPro=SumPro+1
	}
	s SumRel=0
	s n=0
	for
	{
		s n=$o(Rel(n))
		q:n=""
		s SumRel=SumRel+1
	}
	
	/*
	s MKBTDesc=""
	for
	{
		s MKBTDesc=$o(^User.MKBTermI("DescIndex",MKBTBRowid,MKBTDesc))   //遍历Term表专业科室
		q:MKBTDesc=""
		s Desc=$zstrip(MKBTDesc,"<>W")
		continue:$d(Pro(Desc))
		d file.Write(MKBTDesc)
		d file.WriteLine()
	}
	d file.%Save()
	d file.%Close()
	*/
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 科室_安贞",0))
	s MKBTDesc=""
	for
	{
		
	//User.MKBTermI("BaseIndex")
		s MKBTDesc=$o(^User.MKBTermI("DescIndex",MKBTBRowid,MKBTDesc))   //遍历Term表实际科室
		q:MKBTDesc=""
		s Desc=$zstrip(MKBTDesc,"<>W")
		continue:$d(Rel(Desc))
		s sum=sum+1
		d file.Write(MKBTDesc)
		d file.WriteLine()
	}
	;b
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：导出还未对照的实际科室
/// Table：User.MKBKLMappingBaseField User.MKBKLMappingBase User.MKBTerm
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).FindRealProLoc("D:\测试\","还未对照的实际科室.csv")
ClassMethod FindRealProLoc(filePath As %String, fileName As %String)
{
	;s Path="D:\工作\2019-04-15\ProLoc\"
	s sum=0
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s MKBTDesc=""
	s MKBProDesc=$zstrip(MKBTDesc,"<>W")
	s MKBKLMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))   //安贞科室对照basedr
	s MKBKLMFProRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 专业科室",0))
	s MKBKLMFRelRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 实际科室",0))
	;Index RowNumIndex On (MKBKMDKMBaseDr As Exact, MKBKMDRowNum As Exact);
	s MKBNumRowid=0
	for
	{
		s MKBNumRowid=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowid,MKBNumRowid))
		q:MKBNumRowid=""
		;Index ValIndex On (MKBKMDRowNum As Exact, MKBKMDKMBaseFieldDr As Exact);
		s ProLocRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBNumRowid,MKBKLMBRowid_"||"_MKBKLMFProRowid,0)) // 专业科室rowid
		s RelLocRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBNumRowid,MKBKLMBRowid_"||"_MKBKLMFRelRowid,0))  //实际科室rowid
		
		s ProLocdr=$lg($g(^User.MKBKLMappingDetailD(ProLocRowid)),2)
		s RelLocdr=$lg($g(^User.MKBKLMappingDetailD(RelLocRowid)),2)
		
		s ProLocDesc=$lg($g(^User.MKBTermD(ProLocdr)),3)
		s RelLocDesc=$lg($g(^User.MKBTermD(RelLocdr)),3)
		
		s Pro(ProLocDesc)=""
		s Rel(RelLocDesc)=""
	}
	
	s SumPro=0
	s m=0
	for
	{
		s m=$o(Pro(m))
		q:m=""
		s SumPro=SumPro+1
	}
	s SumRel=0
	s n=0
	for
	{
		s n=$o(Rel(n))
		q:n=""
		s SumRel=SumRel+1
	}
	
	/*
	s MKBTDesc=""
	for
	{
		s MKBTDesc=$o(^User.MKBTermI("DescIndex",MKBTBRowid,MKBTDesc))   //遍历Term表专业科室
		q:MKBTDesc=""
		s Desc=$zstrip(MKBTDesc,"<>W")
		continue:$d(Pro(Desc))
		d file.Write(MKBTDesc)
		d file.WriteLine()
	}
	d file.%Save()
	d file.%Close()
	*/
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 科室_安贞",0))
	s MKBTDesc=""
	for
	{
		
	//User.MKBTermI("BaseIndex")
		s MKBTDesc=$o(^User.MKBTermI("DescIndex",MKBTBRowid,MKBTDesc))   //遍历Term表实际科室
		q:MKBTDesc=""
		s Desc=$zstrip(MKBTDesc,"<>W")
		continue:$d(Rel(Desc))
		s sum=sum+1
		d file.Write(MKBTDesc)
		d file.WriteLine()
	}
	;b
	d file.%Save()
	d file.%Close()
	q sum
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：通过科室对照，把专业科室对应的诊断导出到excel(谷歌)
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportDiagOfProLocChrome()
ClassMethod ExportDiagOfProLocChrome()
{
	;s Path="D:\工作\2019-04-15\ProLoc\"
	;诊断短语，结构化结果，ICD，ICD中文释义，频次，专业科室
	s sum = 0
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\专业科室对应诊断"_time_".csv"
	s filename = "专业科室对应诊断"_time_".csv"

	s file=##class(%File).%New(P)
	//s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	d file.Write("诊断"_",")
	d file.Write("结构化结果"_",")
	d file.Write("ICD"_",")
	d file.Write("ICD中文释义"_",")
	d file.Write("频次"_",")
	d file.Write("专业科室")
	d file.WriteLine()
	s SumOfPro=0

	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s MKBTDesc=""
	for
	{
		s MKBTDesc=$o(^User.MKBTermI("DescIndex",MKBTBRowid,MKBTDesc))   //遍历Term表专业科室
		q:MKBTDesc=""
		
		k ^UUU
		s SumOfPro=SumOfPro+1

		s MKBProDesc=$zstrip(MKBTDesc,"<>W")
		s MKBKLMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))   //安贞科室对照basedr
		s MKBKLMFProRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 专业科室",0))
		s MKBKLMFRelRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 实际科室",0))
		;Index RowNumIndex On (MKBKMDKMBaseDr As Exact, MKBKMDRowNum As Exact);
		s MKBNumRowid=0
		for
		{
			s MKBNumRowid=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowid,MKBNumRowid))
			q:MKBNumRowid=""
			;Index ValIndex On (MKBKMDRowNum As Exact, MKBKMDKMBaseFieldDr As Exact);
			s ProLocRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBNumRowid,MKBKLMBRowid_"||"_MKBKLMFProRowid,0)) // 专业科室rowid
			s RelLocRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBNumRowid,MKBKLMBRowid_"||"_MKBKLMFRelRowid,0))  //实际科室rowid
			
			s ProLocdr=$lg($g(^User.MKBKLMappingDetailD(ProLocRowid)),2)
			s RelLocdr=$lg($g(^User.MKBKLMappingDetailD(RelLocRowid)),2)
			
			s ProLocDesc=$lg($g(^User.MKBTermD(ProLocdr)),3)
			s RelLocDesc=$lg($g(^User.MKBTermD(RelLocdr)),3)
			if (ProLocDesc=MKBProDesc)      //Term表专业科室和科室对照专业科室相同
			{
				
				s MKBSDRowId=0
				for
				{
					s MKBSDRowId=$O(^User.MKBStructuredDataLocI("LocIndex"," "_$ZCONVERT(RelLocDesc,"U"),MKBSDRowId))
					q:MKBSDRowId=""
					
					s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),2) 
					s ^UUU(Diag,MKBSDRowId)=""	
				}
				/*
				s MKBSDRowid=0
				for
				{
					s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
					q:MKBSDRowid=""
					s MKBSDLRowid=0
					for
					{
						s MKBSDLRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid))
						q:MKBSDLRowid=""
						s Loc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),2)
						if (Loc=RelLocDesc)               //数据处理工厂的实际科室和科室对照实际科室相同
						{
							s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)    //获取诊断
							s ^UUU(Diag,MKBSDRowid)=""
						}
					}
				}
				*/
			}
		}
		
		s Desc=""
		for
		{
			s Desc=$o(^UUU(Desc))
			q:Desc=""
			
			s MKBSDRowid=$o(^UUU(Desc,0))
			s MKBSDRRowid=0
			s str=""
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
				q:MKBSDRRowid=""
				s Result=""
				s ResultId=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
				s Termdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
				s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(ResultId,Termdr)
				s:str'="" str=str_"||"_Result
				s:str="" str=Result
			}
			s string=$tr(str,",","，")
			s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
			if MKBSDMDr'=""
			{
				s MKBSDMrc=$p($g(^MRC("ID",MKBSDMDr)),"^",2)                    //MRC中文描述
				s MKBSDICD=$p($g(^MRC("ID",MKBSDMDr)),"^",4)                   //ICD
			}
			else
			{
				s MKBSDMrc=""
				s MKBSDICD=""
			}
			s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
			s sum = sum+1
			d file.Write(Desc_",")
			d file.Write(string_",")
			d file.Write(MKBSDICD_",")
			d file.Write(MKBSDMrc_",")
			d file.Write(SumLoc_",")
			d file.Write(MKBTDesc)
			d file.WriteLine()
		}


	}
	
	
	//w "专业科室一共"_SumOfPro,!
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：通过科室对照，把专业科室对应的诊断导出到excel
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportDiagOfProLoc("D:\测试\","专业科室诊断.csv")
ClassMethod ExportDiagOfProLoc(filePath As %String, fileName As %String)
{
	;s Path="D:\工作\2019-04-15\ProLoc\"
	;诊断短语，结构化结果，ICD，ICD中文释义，频次，专业科室
	s sum = 0
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	d file.Write("诊断"_",")
	d file.Write("结构化结果"_",")
	d file.Write("ICD"_",")
	d file.Write("ICD中文释义"_",")
	d file.Write("频次"_",")
	d file.Write("专业科室")
	d file.WriteLine()
	s SumOfPro=0

	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s MKBTDesc=""
	for
	{
		s MKBTDesc=$o(^User.MKBTermI("DescIndex",MKBTBRowid,MKBTDesc))   //遍历Term表专业科室
		q:MKBTDesc=""
		
		k ^UUU
		s SumOfPro=SumOfPro+1

		s MKBProDesc=$zstrip(MKBTDesc,"<>W")
		s MKBKLMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))   //安贞科室对照basedr
		s MKBKLMFProRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 专业科室",0))
		s MKBKLMFRelRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 实际科室",0))
		;Index RowNumIndex On (MKBKMDKMBaseDr As Exact, MKBKMDRowNum As Exact);
		s MKBNumRowid=0
		for
		{
			s MKBNumRowid=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowid,MKBNumRowid))
			q:MKBNumRowid=""
			;Index ValIndex On (MKBKMDRowNum As Exact, MKBKMDKMBaseFieldDr As Exact);
			s ProLocRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBNumRowid,MKBKLMBRowid_"||"_MKBKLMFProRowid,0)) // 专业科室rowid
			s RelLocRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBNumRowid,MKBKLMBRowid_"||"_MKBKLMFRelRowid,0))  //实际科室rowid
			
			s ProLocdr=$lg($g(^User.MKBKLMappingDetailD(ProLocRowid)),2)
			s RelLocdr=$lg($g(^User.MKBKLMappingDetailD(RelLocRowid)),2)
			
			s ProLocDesc=$lg($g(^User.MKBTermD(ProLocdr)),3)
			s RelLocDesc=$lg($g(^User.MKBTermD(RelLocdr)),3)
			if (ProLocDesc=MKBProDesc)      //Term表专业科室和科室对照专业科室相同
			{
				
				s MKBSDRowId=0
				for
				{
					s MKBSDRowId=$O(^User.MKBStructuredDataLocI("LocIndex"," "_$ZCONVERT(RelLocDesc,"U"),MKBSDRowId))
					q:MKBSDRowId=""
					
					s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),2) 
					s ^UUU(Diag,MKBSDRowId)=""	
				}
				/*
				s MKBSDRowid=0
				for
				{
					s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
					q:MKBSDRowid=""
					s MKBSDLRowid=0
					for
					{
						s MKBSDLRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid))
						q:MKBSDLRowid=""
						s Loc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),2)
						if (Loc=RelLocDesc)               //数据处理工厂的实际科室和科室对照实际科室相同
						{
							s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)    //获取诊断
							s ^UUU(Diag,MKBSDRowid)=""
						}
					}
				}
				*/
			}
		}
		
		s Desc=""
		for
		{
			s Desc=$o(^UUU(Desc))
			q:Desc=""
			
			s MKBSDRowid=$o(^UUU(Desc,0))
			s MKBSDRRowid=0
			s str=""
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
				q:MKBSDRRowid=""
				s Result=""
				s ResultId=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
				s Termdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
				s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(ResultId,Termdr)
				s:str'="" str=str_"||"_Result
				s:str="" str=Result
			}
			s string=$tr(str,",","，")
			s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
			if MKBSDMDr'=""
			{
				s MKBSDMrc=$p($g(^MRC("ID",MKBSDMDr)),"^",2)                    //MRC中文描述
				s MKBSDICD=$p($g(^MRC("ID",MKBSDMDr)),"^",4)                   //ICD
			}
			else
			{
				s MKBSDMrc=""
				s MKBSDICD=""
			}
			s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
			s sum = sum+1
			d file.Write(Desc_",")
			d file.Write(string_",")
			d file.Write(MKBSDICD_",")
			d file.Write(MKBSDMrc_",")
			d file.Write(SumLoc_",")
			d file.Write(MKBTDesc)
			d file.WriteLine()
		}


	}
	
	
	//w "专业科室一共"_SumOfPro,!
	q sum
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：导出需要分词的诊断(谷歌)
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).GetFenCi2ExcelChrome()
ClassMethod GetFenCi2ExcelChrome()
{
	s sum=0
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\需要分词的诊断"_time_".csv"
	s filename = "需要分词的诊断"_time_".csv"

	s file=##class(%File).%New(P)
	//s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s Seg=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),9)
		if Seg=""
		{
			
			s Diag=$zstrip(Diag,"<>W")
			d file.Write(Diag)
			d file.WriteLine()
			s sum=sum+1
		}
	}
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：导出需要分词的诊断
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).GetFenCi2Excel("D:\测试\","需要分词的诊断.csv")
ClassMethod GetFenCi2Excel(filePath As %String, fileName As %String)
{
	s sum=0
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s Seg=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),9)
		if Seg=""
		{
			
			s Diag=$zstrip(Diag,"<>W")
			d file.Write(Diag)
			d file.WriteLine()
			s sum=sum+1
		}
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：导出数据处理工厂实际科室(谷歌)
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportRealLocChrome()
ClassMethod ExportRealLocChrome()
{
	s sum=0
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\数据处理工厂实际科室"_time_".csv"
	s filename = "数据处理工厂实际科室"_time_".csv"

	s file=##class(%File).%New(P)
	//s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	s n=""
	for
	{
		s n=$o(^TEMPLoc(n))
		q:n=""
		s sum=sum+1
		d file.Write(n)
		d file.WriteLine()
	}
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：导出数据处理工厂实际科室
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportRealLoc("D:\测试\","数据处理工厂实际科室.csv")
ClassMethod ExportRealLoc(filePath As %String, fileName As %String)
{
	s sum=0
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	s n=""
	for
	{
		s n=$o(^TEMPLoc(n))
		q:n=""
		s sum=sum+1
		d file.Write(n)
		d file.WriteLine()
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：按照实际科室导出数据处理工厂诊断(谷歌)
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportDiagByLocChrome()
ClassMethod ExportDiagByLocChrome()
{
	;s path="D:\工作\2019-04-15\loc\"
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\按实际科室数据处理工厂诊断"_time_".csv"
	s filename = "按实际科室数据处理工厂诊断"_time_".csv"

	s file=##class(%File).%New(P)
	//s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	d file.Write("诊断短语"_","_"结构化结果"_","_"ICD"_","_"ICD中文释义"_","_"频次"_","_"科室")
	d file.WriteLine()
	s sum=0
	s Loc=""
	for
	{
		s Loc=$o(^TEMPLoc(Loc))
		q:Loc=""
		s sum=sum+1
		k ^TEMPDIAG
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
			q:MKBSDRowid=""
			s FreCount=0
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDRRowid))
				q:MKBSDRRowid=""
				s RealLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDRRowid)),2)
				s RealFre=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDRRowid)),3)
				if RealLoc=Loc
				{
					s FreCount=FreCount+RealFre
					s ^TEMPDIAG(FreCount,MKBSDRowid)=""
				}
			}
		}


		s Fre=""
		for
		{
			s Fre=$o(^TEMPDIAG(Fre),-1)
			q:Fre=""
			s Rowid=0
			for
			{
				s Rowid=$o(^TEMPDIAG(Fre,Rowid))
				q:Rowid=""
				s diag=""
				s diag=$lg($g(^User.MKBStructuredDataD(Rowid)),2)
				s MRCdr=$lg($g(^User.MKBStructuredDataD(Rowid)),11)
				if MRCdr'=""
				{
					s MRCDesc=$p($g(^MRC("ID",MRCdr)),"^",2)
					s ICD=$p($g(^MRC("ID",MRCdr)),"^",4)
				}
				else
				{
					s MRCDesc=""
					s ICD=""
				}
				s result=""
				s rowid=0
				for
				{
					s rowid=$o(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",rowid))
					q:rowid=""
					s termdr=""
					s resultid=""
					s resultdesc=""
					s resultid=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",rowid)),2)
					s termdr=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",rowid)),4)
					s resultdesc=##class(web.DHCBL.MKB.MKBStructedDiag).GetChiForStrucIDs(resultid,termdr)
					s:result'="" result=result_"||"_resultdesc
					s:result="" result=resultdesc
				}
				if Fre>=5
				{
					s diag=$tr(diag,",","，")
					s result=$tr(result,",","，")
					d file.Write(diag_",")
					d file.Write(result_",")
					d file.Write(ICD_",")
					d file.Write(MRCDesc_",")
					d file.Write(Fre_",")
					d file.Write(Loc)
					d file.WriteLine()
				}
			}
		}
		d file.%Save()
		d file.%Close()
	}
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：按照实际科室导出数据处理工厂诊断
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportDiagByLoc("D:\测试\","数据处理工厂按实际科室导出诊断短语.csv")
ClassMethod ExportDiagByLoc(filePath As %String, fileName As %String)
{
	;s path="D:\工作\2019-04-15\loc\"
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	d file.Write("诊断短语"_","_"结构化结果"_","_"ICD"_","_"ICD中文释义"_","_"频次"_","_"科室")
	d file.WriteLine()
	s sum=0
	s Loc=""
	for
	{
		s Loc=$o(^TEMPLoc(Loc))
		q:Loc=""
		s sum=sum+1
		k ^TEMPDIAG
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
			q:MKBSDRowid=""
			s FreCount=0
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDRRowid))
				q:MKBSDRRowid=""
				s RealLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDRRowid)),2)
				s RealFre=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDRRowid)),3)
				if RealLoc=Loc
				{
					s FreCount=FreCount+RealFre
					s ^TEMPDIAG(FreCount,MKBSDRowid)=""
				}
			}
		}


		s Fre=""
		for
		{
			s Fre=$o(^TEMPDIAG(Fre),-1)
			q:Fre=""
			s Rowid=0
			for
			{
				s Rowid=$o(^TEMPDIAG(Fre,Rowid))
				q:Rowid=""
				s diag=""
				s diag=$lg($g(^User.MKBStructuredDataD(Rowid)),2)
				s MRCdr=$lg($g(^User.MKBStructuredDataD(Rowid)),11)
				if MRCdr'=""
				{
					s MRCDesc=$p($g(^MRC("ID",MRCdr)),"^",2)
					s ICD=$p($g(^MRC("ID",MRCdr)),"^",4)
				}
				else
				{
					s MRCDesc=""
					s ICD=""
				}
				s result=""
				s rowid=0
				for
				{
					s rowid=$o(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",rowid))
					q:rowid=""
					s termdr=""
					s resultid=""
					s resultdesc=""
					s resultid=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",rowid)),2)
					s termdr=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",rowid)),4)
					s resultdesc=##class(web.DHCBL.MKB.MKBStructedDiag).GetChiForStrucIDs(resultid,termdr)
					s:result'="" result=result_"||"_resultdesc
					s:result="" result=resultdesc
				}
				if Fre>=5
				{
					s diag=$tr(diag,",","，")
					s result=$tr(result,",","，")
					d file.Write(diag_",")
					d file.Write(result_",")
					d file.Write(ICD_",")
					d file.Write(MRCDesc_",")
					d file.Write(Fre_",")
					d file.Write(Loc)
					d file.WriteLine()
				}
			}
		}
		d file.%Save()
		d file.%Close()
	}
	q sum
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：把数据处理工厂诊断短语 结构化结果 ICD ICD中文释义 科室等导出   按频次排序(谷歌)
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportFactoryDataChrome()
ClassMethod ExportFactoryDataChrome()
{
	s sum = 0
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\按频次排序数据处理工厂数据"_time_".csv"
	s filename = "按频次排序数据处理工厂数据"_time_".csv"

	s file=##class(%File).%New(P)
	//s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	d file.Write("诊断短语"_","_"结构化结果"_","_"ICD"_","_"ICD中文释义"_","_"科室"_","_"频次")
	d file.WriteLine()
	s MKBSDFre=""
	for
	{
		s MKBSDFre=$o(^User.MKBStructuredDataI("TotalFreqIndex",MKBSDFre),-1)
		q:MKBSDFre=""
		s MKBSDDesc=""
		for
		{
			s MKBSDDesc=$o(^User.MKBStructuredDataI("TotalFreqIndex",MKBSDFre,MKBSDDesc))
			q:MKBSDDesc=""
			s sum = sum+1
			s Diag=$tr(MKBSDDesc,",","，")
			d file.Write(Diag_",")                             //第一列    描述
			s d=$zconvert(MKBSDDesc,"U")
			s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_d,0))
			continue:MKBSDRowid="" //2019-8-15添加该行
			s MKBSDMRC=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
			s ICDDesc=""
			s ICDCode=""
			if MKBSDMRC'=""
			{
				s ICDDesc=$p($g(^MRC("ID",MKBSDMRC)),"^",2)
				s ICDCode=$p($g(^MRC("ID",MKBSDMRC)),"^",4)
			}
			s MKBSDResultID=""
			s MKBSDResultTermdr=""
			s Result=""
			
			s ResultString=""
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
				q:MKBSDRRowid=""
				s MKBSDResultID=""
				s MKBSDResultTermdr=""
				s Result=""
				s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
				s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
				if MKBSDResultTermdr'=""
				{
					s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBSDResultID,MKBSDResultTermdr)
					s Result=$tr(Result,",","，")
				}
				if ResultString'=""
				{	
					 s ResultString=ResultString_"||"_Result
				}
				s:ResultString="" ResultString=Result
				
			}
			if ResultString'=""                                //第二列 结构化结果
			{
				d file.Write(ResultString)
			}
			d file.Write(",")
			if ICDCode'=""
			{
				d file.Write(ICDCode)              //第三列  ICD
			}
			d file.Write(",")
			if ICDDesc'=""
			{
				d file.Write(ICDDesc)              //第四列  ICD中文描述
			}
			d file.Write(",")
			s LocString=""
			s LocRowid=0
			for
			{
				s LocRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid))
				q:LocRowid=""
				s Loc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid)),2)
				s:LocString'="" LocString=LocString_"，"_Loc
				s:LocString="" LocString=Loc
			}
			
			if LocString'=""
			{
				d file.Write(LocString)                       //第五列   科室
			}
			d file.Write(",")
			
			if MKBSDFre'=""
			{
				d file.Write(MKBSDFre)
			}
			d file.WriteLine()
		}
	}
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：把数据处理工厂诊断短语 结构化结果 ICD ICD中文释义 科室等导出   按频次排序
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportFactoryData("D:\测试\","数据处理工厂诊断短语.csv")
ClassMethod ExportFactoryData(filePath As %String, fileName As %String)
{
	s sum = 0
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	d file.Write("诊断短语"_","_"结构化结果"_","_"ICD"_","_"ICD中文释义"_","_"科室"_","_"频次")
	d file.WriteLine()
	s MKBSDFre=""
	for
	{
		s MKBSDFre=$o(^User.MKBStructuredDataI("TotalFreqIndex",MKBSDFre),-1)
		q:MKBSDFre=""
		s MKBSDDesc=""
		for
		{
			s MKBSDDesc=$o(^User.MKBStructuredDataI("TotalFreqIndex",MKBSDFre,MKBSDDesc))
			q:MKBSDDesc=""
			s sum = sum+1
			s Diag=$tr(MKBSDDesc,",","，")
			d file.Write(Diag_",")                             //第一列    描述
			s d=$zconvert(MKBSDDesc,"U")
			s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_d,0))
			continue:MKBSDRowid="" //2019-8-15添加该行
			s MKBSDMRC=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
			s ICDDesc=""
			s ICDCode=""
			if MKBSDMRC'=""
			{
				s ICDDesc=$p($g(^MRC("ID",MKBSDMRC)),"^",2)
				s ICDCode=$p($g(^MRC("ID",MKBSDMRC)),"^",4)
			}
			s MKBSDResultID=""
			s MKBSDResultTermdr=""
			s Result=""
			
			s ResultString=""
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
				q:MKBSDRRowid=""
				s MKBSDResultID=""
				s MKBSDResultTermdr=""
				s Result=""
				s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
				s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
				if MKBSDResultTermdr'=""
				{
					s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBSDResultID,MKBSDResultTermdr)
					s Result=$tr(Result,",","，")
				}
				if ResultString'=""
				{	
					 s ResultString=ResultString_"||"_Result
				}
				s:ResultString="" ResultString=Result
				
			}
			if ResultString'=""                                //第二列 结构化结果
			{
				d file.Write(ResultString)
			}
			d file.Write(",")
			if ICDCode'=""
			{
				d file.Write(ICDCode)              //第三列  ICD
			}
			d file.Write(",")
			if ICDDesc'=""
			{
				d file.Write(ICDDesc)              //第四列  ICD中文描述
			}
			d file.Write(",")
			s LocString=""
			s LocRowid=0
			for
			{
				s LocRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid))
				q:LocRowid=""
				s Loc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid)),2)
				s:LocString'="" LocString=LocString_"，"_Loc
				s:LocString="" LocString=Loc
			}
			
			if LocString'=""
			{
				d file.Write(LocString)                       //第五列   科室
			}
			d file.Write(",")
			
			if MKBSDFre'=""
			{
				d file.Write(MKBSDFre)
			}
			d file.WriteLine()
		}
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：把语料库的新建数据导出到excel(谷歌)
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportLibraryNewtoExcelChrome()
ClassMethod ExportLibraryNewtoExcelChrome()
{
	;^TEMPPPP("NotInFactoryAndNotMatchMRC",MKBSDRowid)
	;^TEMPPPP("NotInFactoryButMatchMRC",MKBSDRowid)
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\语料库的新建数据"_time_".csv"
	s filename = "语料库的新建数据"_time_".csv"

	s file=##class(%File).%New(P)
	//s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	s NodeSum=0
	s node=""
	for
	{
		s node=$o(^TEMPPPP(node))
		q:node=""
		s NodeSum=NodeSum+1
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^TEMPPPP(node,MKBSDRowid))
			q:MKBSDRowid=""
			s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s Desc=##class(web.DHCBL.MKB.MKBStructedDiag).EvalJSON(MKBSDDesc)
			d file.Write(Desc)
			d file.WriteLine()
			//b:MKBSDDesc="先天性肺动脉瓣钙化中度狭窄"
		}
	}
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：把语料库的新建数据导出到excel
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportLibraryNewtoExcel("D:\测试\","语料库.csv")
ClassMethod ExportLibraryNewtoExcel(filePath As %String, fileName As %String)
{
	;^TEMPPPP("NotInFactoryAndNotMatchMRC",MKBSDRowid)
	;^TEMPPPP("NotInFactoryButMatchMRC",MKBSDRowid)
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	s NodeSum=0
	s node=""
	for
	{
		s node=$o(^TEMPPPP(node))
		q:node=""
		s NodeSum=NodeSum+1
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^TEMPPPP(node,MKBSDRowid))
			q:MKBSDRowid=""
			s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s Desc=##class(web.DHCBL.MKB.MKBStructedDiag).EvalJSON(MKBSDDesc)
			d file.Write(Desc)
			d file.WriteLine()
			//b:MKBSDDesc="先天性肺动脉瓣钙化中度狭窄"
		}
	}
	d file.%Save()
	d file.%Close()
	q NodeSum
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：导出^TMPSTRUCHISDESC(谷歌)
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).WriteTMPSTRUCDESCToExcelChrome()
ClassMethod WriteTMPSTRUCDESCToExcelChrome()
{
	s num = 0
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\^TMPSTRUCHISDESC数据"_time_".csv"
	s filename = "^TMPSTRUCHISDESC数据"_time_".csv"

	s file=##class(%File).%New(P)
	//s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	;^TMPSTRUCHISDESC(LocDesc,Fre,Diag)
	
	//2019-8-16新增
	d file.Write("科室")
	d file.Write(",")
	d file.Write("诊断")
	d file.Write(",")
	d file.Write("频次")
	d file.WriteLine()
	
	
	s LocDesc=""
	for
	{
		s LocDesc=$o(^TMPSTRUCHISDESC(LocDesc))
		q:LocDesc=""
		s Fre=""
		for
		{
			s Fre=$o(^TMPSTRUCHISDESC(LocDesc,Fre),-1)
			q:Fre=""
			s Diag=""
			for
			{
				s Diag=$o(^TMPSTRUCHISDESC(LocDesc,Fre,Diag))
				q:Diag=""
				s num=num+1
				d file.Write(LocDesc)
				d file.Write(",")
				d file.Write(Fre)
				d file.Write(",")
				d file.Write(Diag)
				d file.WriteLine()
			}
			
		}
		
	}
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：导出^TMPSTRUCHISDESC
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).WriteTMPSTRUCDESCToExcel("D:\测试\","TMPSTRUCHISDESC.csv")
ClassMethod WriteTMPSTRUCDESCToExcel(filePath As %String, fileName As %String)
{
	s num = 0
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	;^TMPSTRUCHISDESC(LocDesc,Fre,Diag)
	
	//2019-8-16新增
	d file.Write("科室")
	d file.Write(",")
	d file.Write("诊断")
	d file.Write(",")
	d file.Write("频次")
	d file.WriteLine()
	
	
	s LocDesc=""
	for
	{
		s LocDesc=$o(^TMPSTRUCHISDESC(LocDesc))
		q:LocDesc=""
		s Fre=""
		for
		{
			s Fre=$o(^TMPSTRUCHISDESC(LocDesc,Fre),-1)
			q:Fre=""
			s Diag=""
			for
			{
				s Diag=$o(^TMPSTRUCHISDESC(LocDesc,Fre,Diag))
				q:Diag=""
				s num=num+1
				d file.Write(LocDesc)
				d file.Write(",")
				d file.Write(Fre)
				d file.Write(",")
				d file.Write(Diag)
				d file.WriteLine()
			}
			
		}
		
	}
	d file.%Save()
	d file.%Close()
	q num
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：把^TMPInter中的内容输出到excel，科室子集文件(谷歌)
/// Table：User.MKBKLMappingBase User.MKBKLMappingBaseField User.MKBKLMappingDetail User.MKBTerm
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).Write2ExcelChrome()
ClassMethod Write2ExcelChrome()
{
	s num = 0
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\^TMPInter数据"_time_".csv"
	s filename = "^TMPInter数据"_time_".csv"

	s file=##class(%File).%New(P)
	//s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	d file.Write("诊断中心词")
	d file.Write(",")
	d file.Write("原始诊断")
	d file.Write(",")
	d file.Write("频次")
	d file.Write(",")
	d file.Write("结构化结果")
	d file.WriteLine()
	s sortfre=""
	for
	{
		s sortfre=$o(^TMPSortCenterid(sortfre),-1)
		q:sortfre=""
		s desc=""
		for
		{
			s desc=$o(^TMPSortCenterid(sortfre,desc))
			q:desc=""
			d file.Write(desc)
			d file.Write(",")
			d file.WriteLine()
			s diag=""
			for
			{
				s diag=$o(^TMPInter(desc,diag))
				q:diag=""
				s num = num+1
				s fre=$o(^TMPInter(desc,diag,0))
				s StructResult=$o(^TMPInter(desc,diag,fre,""))
				d file.Write(",")
				d file.Write(diag)
				d file.Write(",")
				d file.Write(fre)
				d file.Write(",")
				d file.Write(StructResult)
				d file.WriteLine()
			}
		}
	}
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：把^TMPInter中的内容输出到excel，科室子集文件
/// Table：User.MKBKLMappingBase User.MKBKLMappingBaseField User.MKBKLMappingDetail User.MKBTerm
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).Write2Excel("D:\测试\","科室子集文件.csv")
ClassMethod Write2Excel(filePath As %String, fileName As %String)
{
	s num = 0
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	d file.Write("诊断中心词")
	d file.Write(",")
	d file.Write("原始诊断")
	d file.Write(",")
	d file.Write("频次")
	d file.Write(",")
	d file.Write("结构化结果")
	d file.WriteLine()
	s sortfre=""
	for
	{
		s sortfre=$o(^TMPSortCenterid(sortfre),-1)
		q:sortfre=""
		s desc=""
		for
		{
			s desc=$o(^TMPSortCenterid(sortfre,desc))
			q:desc=""
			d file.Write(desc)
			d file.Write(",")
			d file.WriteLine()
			s diag=""
			for
			{
				s diag=$o(^TMPInter(desc,diag))
				q:diag=""
				s num = num+1
				s fre=$o(^TMPInter(desc,diag,0))
				s StructResult=$o(^TMPInter(desc,diag,fre,""))
				d file.Write(",")
				d file.Write(diag)
				d file.Write(",")
				d file.Write(fre)
				d file.Write(",")
				d file.Write(StructResult)
				d file.WriteLine()
			}
		}
	}
	d file.%Save()
	d file.%Close()
	q num
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：导出科室常用诊断(谷歌)
/// Table：User.MKBKLMappingBase User.MKBKLMappingBaseField User.MKBKLMappingDetail User.MKBTerm
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportDataChrome()
ClassMethod ExportDataChrome()
{
	k loc
	k fre
	s MKBMBRowId=$O(^User.MKBKLMappingBaseI("DescIndex"," 科室常用诊断",0))
	b:MKBMBRowId=""
	
	s Diagchild=$O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 诊断",0))
	s Frechild=$O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 频次",0))
	s LocChild=$O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 科室",0))
	
	s RowNum=0
	for
	{
		s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBMBRowId,RowNum))
		q:RowNum=""
		
		;s LocMDRowID=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBMBRowId,RowNum,0))
		s LocMDRowID=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_LocChild,0))
		s LocTermID=$LG($G(^User.MKBKLMappingDetailD(LocMDRowID)),2)
		s LocDesc = $LG($G(^User.MKBTermD(LocTermID)),3)
		s loc(LocDesc,RowNum)=""
	}
	s num=0
	s locDesc=""
	for
	{
		s locDesc=$O(loc(locDesc))
		q:locDesc=""
		k fre
		;s path="D:\loc\"_locDesc_".csv"
		s time = $zd(+$H,3)
		s time = $tr(time,"-","")
		s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
		s Disk=$p(Path,":",1) //截取盘符
		s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\科室常用诊断"_time_".csv"
		s filename = "科室常用诊断"_time_".csv"

		s file=##class(%File).%New(P)
		//s file=##class(%File).%New(filePath_fileName)
		d file.Open("NWS")
		//Excel名
		d file.Write("中心词"_","_"频次")
		d file.WriteLine()
		s RowNum=0
		for
		{	
			s RowNum = $O(loc(locDesc,RowNum))
			q:RowNum=""
			
			s DiagMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_Diagchild,0))
			continue:DiagMDRowId=""
			s DiagDescId = $LG($G(^User.MKBKLMappingDetailD(DiagMDRowId)),2)
			s DiagDesc = $LG($G(^User.MKBTermD(DiagDescId)),3)
			 
			
			s FreMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_Frechild,0))
			s Fre = $LG($G(^User.MKBKLMappingDetailD(FreMDRowId)),2)
			s num=num+1
			s fre(Fre,DiagDesc)=""
			
		}
		s f=""
		for
		{
			s f=$o(fre(f),-1)
			q:f=""
			s d=""
			for
			{
				s d=$o(fre(f,d))
				q:d=""
				d file.Write(d_","_f)
				d file.WriteLine()
			}
		}
		d file.%Save()
		d file.%Close()
	}
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：导出科室常用诊断
/// Table：User.MKBKLMappingBase User.MKBKLMappingBaseField User.MKBKLMappingDetail User.MKBTerm
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportData("D:\测试\","科室常用诊断.csv")
ClassMethod ExportData(filePath As %String, fileName As %String)
{
	k loc
	k fre
	s MKBMBRowId=$O(^User.MKBKLMappingBaseI("DescIndex"," 科室常用诊断",0))
	b:MKBMBRowId=""
	
	s Diagchild=$O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 诊断",0))
	s Frechild=$O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 频次",0))
	s LocChild=$O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 科室",0))
	
	s RowNum=0
	for
	{
		s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBMBRowId,RowNum))
		q:RowNum=""
		
		;s LocMDRowID=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBMBRowId,RowNum,0))
		s LocMDRowID=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_LocChild,0))
		s LocTermID=$LG($G(^User.MKBKLMappingDetailD(LocMDRowID)),2)
		s LocDesc = $LG($G(^User.MKBTermD(LocTermID)),3)
		s loc(LocDesc,RowNum)=""
	}
	s num=0
	s locDesc=""
	for
	{
		s locDesc=$O(loc(locDesc))
		q:locDesc=""
		k fre
		;s path="D:\loc\"_locDesc_".csv"
		s file=##class(%File).%New(filePath_fileName)
		d file.Open("NWS")
		//Excel名
		d file.Write("中心词"_","_"频次")
		d file.WriteLine()
		s RowNum=0
		for
		{	
			s RowNum = $O(loc(locDesc,RowNum))
			q:RowNum=""
			
			s DiagMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_Diagchild,0))
			continue:DiagMDRowId=""
			s DiagDescId = $LG($G(^User.MKBKLMappingDetailD(DiagMDRowId)),2)
			s DiagDesc = $LG($G(^User.MKBTermD(DiagDescId)),3)
			 
			
			s FreMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_Frechild,0))
			s Fre = $LG($G(^User.MKBKLMappingDetailD(FreMDRowId)),2)
			s num=num+1
			s fre(Fre,DiagDesc)=""
			
		}
		s f=""
		for
		{
			s f=$o(fre(f),-1)
			q:f=""
			s d=""
			for
			{
				s d=$o(fre(f,d))
				q:d=""
				d file.Write(d_","_f)
				d file.WriteLine()
			}
		}
		d file.%Save()
		d file.%Close()
	}
	q num
}

/// Creator:张云越
/// CreatDate:2019-11-6
/// Description：把数据处理工厂中，没有匹配到mrC的数据导出到excel(谷歌)
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportNoMRCChrome() 
ClassMethod ExportNoMRCChrome()
{
	s sum=0
	s time = $zd(+$H,3)
	s time = $tr(time,"-","")
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\数据处理工厂中未匹配MRC"_time_".csv"
	s filename = "数据处理工厂中未匹配MRC"_time_".csv"

	s file=##class(%File).%New(P)
	//s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		
		s mrcdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
		if mrcdr=""
		{
			s sum=sum+1
			s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s desc=##class(web.DHCBL.BDP.FunLib).EvalJSON(Diag)
			d file.Write(desc)
			d file.WriteLine()
		}
	}
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：把数据处理工厂中，没有匹配到mrC的数据导出到excel
/// Table：User.MKBStructuredData
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).ExportNoMRC("D:\","未匹配.csv") 
ClassMethod ExportNoMRC(filePath As %String, fileName As %String)
{
	s sum=0
	s file=##class(%File).%New(filePath_fileName)
	d file.Open("NWS")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		
		s mrcdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
		if mrcdr=""
		{
			s sum=sum+1
			s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s desc=##class(web.DHCBL.BDP.FunLib).EvalJSON(Diag)
			d file.Write(desc)
			d file.WriteLine()
		}
	}
	d file.%Save()
	d file.%Close()
	q sum
}

}

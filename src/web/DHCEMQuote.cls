/// 引用检查，检验，药品
Class web.DHCEMQuote Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      zhouxin
/// CreatDate：    2019-03-09
/// Description:： 查询检验医嘱记录
/// Output:     EpisodeDate:就诊日期,DeptDesc:就诊科室,OEordItemRowID:医嘱ID,OEordItemDesc:医嘱名称,LabEpisodeNo:标本号,
///             SpecimenDesc:标本类型,CollectionDate:标本采集日期,CollectionTime:标本采集时间
///             AuthorisationDate:标本审核日期,AuthorisationTime:标本审核时间,
/// Others：       w ##class(web.DHCEMQuote).list("2")
ClassMethod listLis(EpisodeIDs = "", StDate = "", EndDate = "", type As %String = "", PrenatalScreening = "", Exception = "")
{
  
	n (EpisodeIDs,type,StDate,EndDate,PrenatalScreening,Exception,%request,%session)
	
	s start=##class(web.DHCEMQuote).GetStartRow()
	s end=##class(web.DHCEMQuote).GetEndRow()
	
	s:+PrenatalScreening'=0 EpisodeIDs=##class(web.DHCEMQuote).getAdmStr(EpisodeIDs)

	s AuthStDate=""
	s AuthEdDate=""
	i type="today" d
	.s AuthStDate=+$h,AuthEdDate=+$h
	
	i type="3day" d
	.s AuthStDate=+$h-2,AuthEdDate=+$h
	
	i type="week" d
	.s AuthStDate=+$h-6,AuthEdDate=+$h
	
	i type="lastadm" d
	.s EpisodeIDs=##class(web.DHCEMQuote).getLastAdm(EpisodeIDs)
	q:+EpisodeIDs=0 ##class(web.DHCEMQuote).EmptyDataGrid()
	
	s titlestr="EpisodeDate^EpisodeID^DeptDesc^OEordItemRowID^OEordItemDesc^LabEpisodeNo^SpecimenDesc"
	s titlestr=titlestr_"^CollectionDate^CollectionTime^AuthorisationDate^AuthorisationTime"
	s count=0
	w "{""rows"":["
	s length = $l(EpisodeIDs,",")
	for I=1:1:length
	{
		s episodeId = $p(EpisodeIDs,",",I)
		s tmpStDate = $Case(StDate,"":$p($g(^PAADM(episodeId)),"^",6),:$zdh(StDate,3))
		s tmpEndDate = $Case(EndDate,"":$P($G(^PAADM(episodeId)),"^",17),:$zdh(EndDate,3))
		s:(tmpEndDate = "") tmpEndDate = $p($h,",",1)
		//s episodeDate = $ZD($p($g(^PAADM(episodeId)),"^",6),3)	
		s episodeDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml($p($g(^PAADM(episodeId)),"^",6)) 	
		s deptId = $p(^PAADM(episodeId),"^",4)
		s deptDesc = $Case(deptId,"":"",:$p(^CTLOC(deptId),"^",2))
		s:($f(deptDesc,"-") '= 0) deptDesc = $p(deptDesc,"-",2)
		s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectLISItemListByDate")
		d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		While (ds.Next())
		{
			s AuthorisationDate=ds.Data("AuthorisationDate")
			s:+AuthorisationDate'=0 AuthorisationDate=$zdh(AuthorisationDate,3)
			//w ds.Data("OEordItemDesc"),!
			continue:(AuthStDate'="")&&(AuthStDate=AuthEdDate)&&(AuthStDate'=AuthorisationDate) //当天
			continue:(AuthStDate'="")&&(AuthStDate'=AuthEdDate)&&((AuthStDate>AuthorisationDate)||(AuthEdDate<AuthorisationDate)) //当天
			continue:##class(web.DHCEMQuote).checkException(Exception,ds.Data("OEordItemRowID"))=1
			s count=count+1
			continue:(count<start)||(count>end)
			s AuthorisationDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(AuthorisationDate) 
			w $case(count,start:"",:",")
			s OEordItemDesc=ds.Data("OEordItemDesc")
			s SpecimenDesc=ds.Data("SpecimenDesc")
			s $p(rowData,"^",1)=episodeDate
			s $p(rowData,"^",2)=episodeId
			s $p(rowData,"^",4)=ds.Data("OEordItemRowID")
			s $p(rowData,"^",6)=ds.Data("LabEpisodeNo")
			s $p(rowData,"^",8)=ds.Data("CollectionDate")
			s $p(rowData,"^",9)=ds.Data("CollectionTime")
			s $p(rowData,"^",10)=AuthorisationDate //ds.Data("AuthorisationDate")
			s $p(rowData,"^",11)=ds.Data("AuthorisationTime")
			;双语改造：医嘱名称,标本类型,就诊科室
			s deptDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",deptDesc)
			s OEordItemDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.ARCItmMast","ARCIMDesc","",OEordItemDesc)
			s SpecimenDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTSpecimen","IName","",SpecimenDesc)
			s $p(rowData,"^",3)=deptDesc
			s $p(rowData,"^",5)=OEordItemDesc
			s $p(rowData,"^",7)=SpecimenDesc
			
			w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,rowData)	
		
		}		
	}
    w "],""total"":"_count_"}"
	q ""
}

/// 获取病人50周前就诊记录
/// w ##class(web.DHCEMQuote).getAdmStr("27232103")
ClassMethod getAdmStr(EpisodeIDs)
{
	n (EpisodeIDs)
	s retStr="",count=0
	s APatientID=$p(^PAADM(+EpisodeIDs),"^",1)
	set typeRowID=""
	for {
 		set typeRowID = $o(^PAPERdr(APatientID,"ADM",typeRowID))
 		q:(typeRowID = "")
 		set episodeID = ""
 		for {
	 		s episodeID = $o(^PAPERdr(APatientID,"ADM",typeRowID,episodeID))
	 		q:(episodeID = "")
	 		s admDate=$p($g(^PAADM(episodeID)),"^",6)
	 		continue:##class(web.DHCEMQuote).CheckQuoteDateScope(admDate)=0
	 		s count=count+1
	 		s $p(retStr,",",count)=episodeID
 		}	
	}
	q retStr
}

/// 获取病人上次就诊adm
/// w ##class(web.DHCEMQuote).getLastAdm("27232103")
ClassMethod getLastAdm(EpisodeIDs)
{
	n (EpisodeIDs)
	s type=$p($g(^PAADM(+EpisodeIDs)),"^",2)
	s APatientID=$p($g(^PAADM(+EpisodeIDs)),"^",1)
	q +$o(^PAPERdr(APatientID,"ADM",type,+EpisodeIDs),-1)
}

/// 判断检验结果是否有异常
/// w ##class(web.DHCEMQuote).checkException("2")
ClassMethod checkException(Exception = "", orditm)
{
	n (Exception,orditm)
	q:+Exception=0 0
	s ret=1
	s length = $l(orditm,",")
	for I=1:1:length
	{
		q:ret'=1
		s OeordID = $p(orditm,",",I)
		s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectReportByOeordID")
		d ds.Execute(OeordID)
		While (ds.Next())
		{
			s:ds.Data("AbnorFlag")'="" ret=0
			q:ret'=1
		}
	}		
	q ret
}

/// Creator：      zhouxin
/// CreatDate：    2019-03-09
/// Description:： 取检验子项
/// Output:     ItemDesc:描述,Synonym:英文缩写,ItemResult:结果,ItemUnit:单位,AbnorFlag:异常标记,ItemRanges:范围值
/// Others：       w ##class(web.DHCEMQuote).listLisSub("25655591||10")
ClassMethod listLisSub(OeordIDs = "")
{
  
	n (OeordIDs,%request)
	s ^yytemp("1")=$lb(OeordIDs,%request)
	q:+OeordIDs=0 "{""total"":0,""rows"":[]}" //##class(web.DHCPUECommon).EmptyDataGrid() //hxy 2021-01-13
	//s start=##class(web.DHCPUECommon).GetStartRow()
	//s end=##class(web.DHCPUECommon).GetEndRow()
	
	s titlestr="OeordID#ItemDesc#Synonym#ItemResult#ItemUnit#AbnorFlag#ItemRanges#OeordID"
	s count=0
	w "{""rows"":["
	s length = $l(OeordIDs,",")
	for I=1:1:length
	{

		s OeordID = $p(OeordIDs,",",I)
	    b ;1
		s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectReportByOeordID")
		d ds.Execute(OeordID)
		While (ds.Next())
		{
	
			s count=count+1
			//continue:(count<start)||(count>end)
			
			w $case(count,1:"",:",")
			s $p(rowData,"#",1)=OeordID
			s $p(rowData,"#",2)=ds.Data("ItemDesc")
			s $p(rowData,"#",3)=ds.Data("Synonym")
			s $p(rowData,"#",4)=ds.Data("ItemResult")
			s $p(rowData,"#",5)=ds.Data("ItemUnit")
			s $p(rowData,"#",6)=ds.Data("AbnorFlag")
			s $p(rowData,"#",7)=ds.Data("ItemRanges")
			s $p(rowData,"#",8)=OeordID
			w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,rowData,"#")	
		
		}		
	}
    w "],""total"":"_count_"}"
	q ""
}

/// //////////////////////////////////////////////////////////////////////PACS////////////////////
/// Creator：      zhouxin
/// CreatDate：    2019-03-09
/// Description:： 查询检验医嘱记录
/// Output:        EpisodeDate:就诊日期,EpisodeSection:就诊科室,EpisodeItemName:医嘱名称,OrdCreateDate:下医嘱日期,OrdCreateTime:下医嘱时间,OEOrdItemDR:医嘱ID,RptRowID:报告ID	
/// Others：       w ##class(web.DHCEMQuote).listPacs("2")
ClassMethod listPacs(EpisodeIDs = "", type As %String = "", NT = "")
{
  
	n (EpisodeIDs,type,NT,%request,%session)
	q:+EpisodeIDs=0 ##class(web.DHCEMQuote).EmptyDataGrid()
	s start=##class(web.DHCEMQuote).GetStartRow()
	s end=##class(web.DHCEMQuote).GetEndRow()
	
	s StDate=""
	s EdDate=""
	i type="today" d
	.s StDate=+$h,EdDate=+$h
	
	i type="3day" d
	.s StDate=+$h-2,EdDate=+$h
	
	i type="week" d
	.s StDate=+$h-6,EdDate=+$h
	
	i type="lastadm" d
	.s EpisodeIDs=##class(web.DHCEMQuote).getLastAdm(EpisodeIDs)
	
	s:+NT'=0 EpisodeIDs=##class(web.DHCEMQuote).getAdmStr(EpisodeIDs)
	q:+EpisodeIDs=0 ##class(web.DHCEMQuote).EmptyDataGrid()
	
	s titlestr="EpisodeDate^EpisodeID^DeptDesc^ItemName^OrdCreateDate^OrdCreateTime^OEOrdItemDR"
	s titlestr=titlestr_"^RptRowID^RrtDate^RrtTime^Img^ImgUrl"
	s count=0
	w "{""rows"":["
	s length = $l(EpisodeIDs,",")
	for I=1:1:length
	{
		s episodeId = $p(EpisodeIDs,",",I)
		s tmpStDate = $p($g(^PAADM(episodeId)),"^",6)
		s tmpEndDate = $P($G(^PAADM(episodeId)),"^",17)
		s:(tmpEndDate = "") tmpEndDate = $p($h,",",1)
		s episodeDate = $p($g(^PAADM(episodeId)),"^",6)
		s:+episodeDate'=0 episodeDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(episodeDate)		/// 格式化就诊日期	
		s deptId = $p(^PAADM(episodeId),"^",4)
		s deptDesc = $Case(deptId,"":"",:$p(^CTLOC(deptId),"^",2))
		S deptDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",deptDesc)
		s:($f(deptDesc,"-") '= 0) deptDesc = $p(deptDesc,"-",2)
		s ds = ##Class(%Library.ResultSet).%New("web.DHCRisclinicQueryEPR:SelectPACSItemListByDate")
		d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		While (ds.Next())
		{
			s RrtDate=ds.Data("RrtDate")
			s:+RrtDate'=0 RrtDate=$zdh(RrtDate,3)
			
			continue:(StDate'="")&&(StDate=EdDate)&&(StDate'=RrtDate) //当天
			continue:(StDate'="")&&(StDate'=EdDate)&&((StDate>RrtDate)||(EdDate<RrtDate)) //当天
			s count=count+1
			continue:(count<start)||(count>end)
			
			s OrdCreateDate=ds.Data("OrdCreateDate")
			s:+OrdCreateDate'=0 OrdCreateDate=$zdh(OrdCreateDate,3)
			s:+OrdCreateDate'=0 OrdCreateDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(OrdCreateDate) /// 格式化医嘱日期
			s:+RrtDate'=0 RrtDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(RrtDate)					/// 格式化报告日期
			w $case(count,start:"",:",")
			s ItemName=ds.Data("ItemName")
			s $p(rowData,"^",1)=episodeDate
			s $p(rowData,"^",2)=episodeId
			s $p(rowData,"^",3)=deptDesc
			s $p(rowData,"^",5)=OrdCreateDate /// ds.Data("OrdCreateDate")
			s $p(rowData,"^",6)=ds.Data("OrdCreateTime")
			s Oeori=ds.Data("OEOrdItemDR")
			i $o(^DHCAPREP(0,"OrdItem",Oeori,"")) D
			.s $p(rowData,"^",4)=##Class(web.DHCAPPInterface).GetExaReqItemDesc(Oeori,"")
			s $p(rowData,"^",7)=ds.Data("OEOrdItemDR")
			s $p(rowData,"^",8)=ds.Data("RptRowID")
			s $p(rowData,"^",9)=RrtDate      ///ds.Data("RrtDate")
			s $p(rowData,"^",10)=ds.Data("RrtTime")
			s ItemName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.ARCItmMast","ARCIMDesc","",ItemName)
			s $p(rowData,"^",4)=ItemName
			s Img=..GetImg(ds.Data("OEOrdItemDR"),ds.Data("RptRowID")) //hxy 2021-02-03 st
			s $p(rowData,"^",11)=Img //ed
			s $p(rowData,"^",12)=ds.Data("ImgURL") //hxy 2021-02-01
			w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,rowData)	
		
		}		
	}
    w "],""total"":"_count_"}"
	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2019-03-09
/// Description:： 取PACS子项
/// Output:        ExamDesc 检查所见,strResult 诊断意见,strOrderName 检查方法
/// Others：       w ##class(web.DHCEMQuote).listPacsSub("1||8^1||5")
ClassMethod listPacsSub(OeordIDs = "")
{
  
	n (OeordIDs,%request)
	q:+OeordIDs=0 ##class(web.DHCEMQuote).EmptyDataGrid()

	s titlestr="OeordID^ExamDesc^strResult^strOrderName"
	s count=0
	w "{""rows"":["
	s length = $l(OeordIDs,"^")
	for I=1:1:length
	{

		s OeordID = $p(OeordIDs,"^",I)
	
		s ds = ##Class(%Library.ResultSet).%New("web.DHCRisclinicQueryEPR:SelectReportByOeordID")
		d ds.Execute(OeordID)
		While (ds.Next())
		{
	
			s count=count+1
			w $case(count,1:"",:",")
			s $p(rowData,"^",1)=OeordID
			s $p(rowData,"^",2)=##class(ext.util.String).Replace(ds.Data("ExamDesc"),$c(10),"")
			s $p(rowData,"^",3)=##class(ext.util.String).Replace(ds.Data("strResult"),$c(10),"")
			s $p(rowData,"^",4)=##class(ext.util.String).Replace(ds.Data("strOrderName"),$c(10),"")
			s $p(rowData,"^",8)=OeordID
			w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,rowData)	
		
		}		
	}
    w "],""total"":"_count_"}"
	q ""
}

/// //////////////////////////////////////////////////////////////////////ORDERS////////////////////
/// Creator：      zhouxin
/// CreatDate：    2019-03-10
/// Description:： 查询医嘱信息
/// Others：       w ##class(web.DHCEMQuote).listOrder("2")
ClassMethod listOrder(EpisodeIDs = "", type As %String = "")
{
  
	n (EpisodeIDs,type,%request,%session)
	q:+EpisodeIDs=0 ##class(web.DHCEMQuote).EmptyDataGrid()
	s start=##class(web.DHCEMQuote).GetStartRow()
	s end=##class(web.DHCEMQuote).GetEndRow()
	
	
	
	s titlestr="OrdCreateDate^ArcimDesc^DoseQty^Dura^Instr^PHFreq^DoseUnit^OrdStatus^mOeori^Oeori"
	s count=0
	w "{""rows"":["
	s length = $l(EpisodeIDs,",")
	for I=1:1:length
	{
		s episodeId = $p(EpisodeIDs,",",I)

		s ds = ##Class(%Library.ResultSet).%New("web.DHCEMQuote:GetOrdByAdm")
		d ds.Execute(episodeId,"","","","","","","",type)
		While (ds.Next())
		{
			s count=count+1
			continue:(count<start)||(count>end)
			
			w $case(count,start:"",:",")
			
			s ArcimDesc=ds.Data("ArcimDesc")
			s OrdStatus=ds.Data("OrdStatus")
			s DoseUnit=ds.Data("DoseUnit")
			s Instr=ds.Data("Instr")
			s $p(rowData,"^",1)=ds.Data("OrdCreateDate")
			s $p(rowData,"^",3)=ds.Data("DoseQty")
			s $p(rowData,"^",4)=ds.Data("Dura")
			s Instr=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.PHCInstruc","PHCINDesc1","",Instr)
			s $p(rowData,"^",5)=Instr
			s $p(rowData,"^",6)=ds.Data("PHFreq")
			
			s $p(rowData,"^",9)=ds.Data("mOeori")
			s $p(rowData,"^",10)=ds.Data("OEItemID")
			s ArcimDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.ARCItmMast","ARCIMDesc","",ArcimDesc)
			s OrdStatus=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.OECOrderStatus","OSTATDesc","",OrdStatus)
			s DoseUnit=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTUOM","CTUOMDesc","",DoseUnit)
			s $p(rowData,"^",2)=ArcimDesc
			s $p(rowData,"^",7)=DoseUnit
			s $p(rowData,"^",8)=OrdStatus
			w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,rowData)	
		
		}		
	}
    w "],""total"":"_count_"}"
	q ""
}

/// Desc:		诊断列表
/// Input:		AEpisodeId 就诊ID
/// Output:  	json
/// Debug:		w ##Class(web.DHCEMQuote).ListDiagns(2)
ClassMethod ListDiagns(EpisodeIDs As %String) As %String
{
	n (EpisodeIDs,%request,%session)
	q:+EpisodeIDs=0 ##class(web.DHCEMQuote).EmptyDataGrid()
	s start=##class(web.DHCEMQuote).GetStartRow()
	s end=##class(web.DHCEMQuote).GetEndRow()
	
	s titlestr="ARowID^ADiagnosType^ADiagnosName^AEvaluationDesc^AICDCode^AEffectsDesc^ALevel^AUserName^ADateTime^ADemo^mainMRID^SDSDesc"
	s count=0
	s length = $l(EpisodeIDs,",")
	
	w "{""rows"":["
	for I=1:1:length
	{
		s episodeId = $p(EpisodeIDs,",",I)
		s ds = ##Class(%Library.ResultSet).%New("web.DHCEMQuote:GetMRDiagnosList")
		d ds.Execute(episodeId,"")
		While (ds.Next())
		{
			s count=count+1
			continue:(count<start)||(count>end)
			w $case(count,start:"",:",")
			s ADiagnosName=ds.Data("ADiagnosName")
			s ADiagnosType=ds.Data("ADiagnosType")
			s AEvaluationDesc=ds.Data("AEvaluationDesc")
			s AUserName=ds.Data("AUserName")
			s $p(rowData,"^",1)=ds.Data("ARowID")
			s $p(rowData,"^",5)=ds.Data("AICDCode")
			s $p(rowData,"^",6)=ds.Data("AEffectsDesc")
			s $p(rowData,"^",7)=ds.Data("ALevel")
			s $p(rowData,"^",9)=ds.Data("ADateTime")
			s $p(rowData,"^",10)=ds.Data("ADemo")
			s $p(rowData,"^",11)=ds.Data("mainMRID")
			s $p(rowData,"^",12)=ds.Data("SDSDesc")
			s ADiagnosName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.MRCICDDx","MRCIDDesc","",ADiagnosName)	
			s ADiagnosType=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.MRCDiagnosType","DTYPDesc","",ADiagnosType)	
			s AEvaluationDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.MRCDiagnosStatus","DSTATDesc","",AEvaluationDesc)
			s AUserName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.SSUser","SSUSRName","",AUserName)
			s $p(rowData,"^",3)=ADiagnosName
			s $p(rowData,"^",2)=ADiagnosType
			s $p(rowData,"^",4)=AEvaluationDesc
			s $p(rowData,"^",8)=AUserName
			
			w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,rowData)
			
		}
	}
	w "],""total"":"_count_"}"
	q ""
}

/// Desc:		病理列表
/// Input:		AEpisodeId 就诊ID
/// Output:  	json
/// Debug:		w ##Class(web.DHCEMQuote).ListPatHology(1951)
ClassMethod ListPatHology(EpisodeIDs As %String) As %String
{
	n (EpisodeIDs,%request,%session)
	q:+EpisodeIDs=0 ##class(web.DHCEMQuote).EmptyDataGrid()
	s start=1 //##class(web.DHCEMQuote).GetStartRow()
	s end=10 //##class(web.DHCEMQuote).GetEndRow()
	
	s titlestr="tmid^SpeInfo^ordername^AppDate^AppTime"

#;	zn "DHC-PIS"
#;	k PatHologList
#;	for I=1:1:$l(EpisodeIDs,",")
#;	{
#;		s episodeId = $p(EpisodeIDs,",",I)
#;		s result = ##class(%ResultSet).%New("Src.DPIS3OutInterface:GetAppInfoByAdm")
#;		d result.Execute(episodeId)
#;		s columCount = result.GetColumnCount()
#;		while result.%Next()
#;		{
#;			s count = count + 1
#;			s rowData=""
#;			s $p(rowData,"^",1)=result.Data("tmid")
#;			s $p(rowData,"^",2)=result.Data("SpeInfo")
#;			s $p(rowData,"^",3)=result.Data("ordername")
#;			s $p(rowData,"^",4)=result.Data("AppDate")
#;			s $p(rowData,"^",5)=result.Data("AppTime")
#;			s PatHologList($zdh(result.Data("AppDate"),3),$zth(result.Data("AppTime"),1),count)=rowData
#;			
#;		}
#;		d result.Close()
#;	}
#;	zn "DHC-APP"
	
	k PatHologList
	s count=0
	for I=1:1:$l(EpisodeIDs,",")
	{
		s episodeId = $p(EpisodeIDs,",",I)		
		s StudyData=##class(PISService.PISApply).GetStudyInfo("AdmNo",episodeId)
		continue:$p(StudyData,"^",1)="-1"
		//转化对象，获取检查信息
		s StudyArrayObj = ##class(PISService.Util.XMLCOM.JOSNUtils).%New().FromJSON(StudyData)
		for j=0:1:(StudyArrayObj.Size()-1) {
			;s ApplyNo=StudyArrayObj.Get(j).ApplyNo
			s HISOrderID=StudyArrayObj.Get(j).HISOrderID
			s ApplyOrderName=StudyArrayObj.Get(j).ApplyOrderName
			s Specimen=StudyArrayObj.Get(j).Specimen
			s ApplyDate=StudyArrayObj.Get(j).ApplyDate
			s ApplyTime=StudyArrayObj.Get(j).ApplyTime
			s count = count + 1
			s rowData=""
			s $p(rowData,"^",1)=HISOrderID
			s $p(rowData,"^",2)=Specimen
			s $p(rowData,"^",3)=ApplyOrderName
			s $p(rowData,"^",4)=ApplyDate
			s $p(rowData,"^",5)=ApplyTime
			s PatHologList($zdh(ApplyDate,3),$zth(ApplyTime,1),count)=rowData
		}			
	}

	//倒序排序输出
	s count=0
	w "{""rows"":["
	s date="" f  s date=$o(PatHologList(date)) q:date=""  d
	.s time="" f  s time=$o(PatHologList(date,time)) q:time=""  d
	..s i="" f  s i=$o(PatHologList(date,time,i)) q:i=""  d
	...s AppDate=$p(PatHologList(date,time,i),"^",4)
	...s:AppDate'="" AppDate=$zdh(AppDate,3)
	...s $p(PatHologList(date,time,i),"^",4)=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(AppDate) 
	...s count=count+1
	...q:(count<start)||(count>end)
	...w $case(count,start:"",:",")
	...s rowData=PatHologList(date,time,i)
	...s ordName=$p(rowData,"^",3)
	...s $p(rowData,"^",3)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.ARCItmMast","ARCIMDesc","",ordName)
	...w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,rowData)
	w "],""total"":"_count_"}"
	k PatHologList
	
	q ""
}

/// Desc:       取病理子项
/// Input:      Tmrowid:申请单号
/// OutPut:     Diagnosis:病理诊断,Seeing:检查所见,RptDate:发报告日期,RptTime:发报告时间,PathId:病理号
/// w ##Class(web.DHCEMQuote).ListPatHologySub("1760||8")
ClassMethod ListPatHologySub(Tmrowid As %String) As %String
{
	s json = ""
	s count = 0
	q:(Tmrowid = "") "{""total"":0,""rows"":["_json_"]}"
	s start=1
	s end=10
	s res=##class(PISService.API.DHCPISReport).GetReportInfoByOrderID(Tmrowid)
	;Output：  病理号^^^病理诊断^^^检查所见^^^发报告日期^^^发报告时间^^^医生Code@@@@病理号^^^病理诊断^^^检查所见^^^发报告日期^^^发报告时间^^^医生Code
	s titlestr="PathId^Diagnosis^Seeing^RptDate"
	w "{""rows"":["
	for i=1:1:$l(res,"@@@@")
	{
		s result=$p(res,"@@@@",i)
		continue:result=""
		s rowData=""
		s $p(rowData,"^",1)=$p(result,"^",1)
		s $p(rowData,"^",2)=$p(result,"^",4)
		s $p(rowData,"^",3)=$p(result,"^",7)
		s $p(rowData,"^",4)=$p(result,"^",10)
		s count=count+1
		continue:(count<start)||(count>end)
		w $case(count,start:"",:",")
		w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,rowData)
	}
	w "],""total"":"_count_"}"	
	q ""
}

/// Desc:       取病理子项
/// Input:      Tmrowid:申请单号
/// OutPut:     Diagnosis:病理诊断,Seeing:检查所见,RptDate:发报告日期,RptTime:发报告时间,PathId:病理号
ClassMethod ListPatHologySubOld(Tmrowid As %String) As %String
{
	s json = ""
	s count = 0
	q:(Tmrowid = "") "{""total"":0,""rows"":["_json_"]}"
	s format=##class(web.DHCAPPCommonUtil).DateFormat() /// 日期格式
	d $zu(5,"DHC-PIS")
	s result = ##class(%ResultSet).%New("Src.DPIS3OutInterface:GetRptInfoByTmrowid")
	d result.Execute(Tmrowid)
	s columCount = result.GetColumnCount()
	while result.%Next()
	{
		s:(json'= "") json = json_","
		s json = json_"{"
		s json = json_"""Tmrowid"":"""_Tmrowid_""","
		for k=1:1:columCount
		{
			s:(k '= 1) json = json_","
			s val=result.Data(result.GetColumnName(k))
			/// 日期格式化
			i result.GetColumnName(k)="RptDate" d
			.i val["-" s val=$zdh(val,3)
			.s date = $zd(val,format)
			.i format=4 D
			..s date = $zd(val,format)
			..s $p(date,"/",3)=+$zd(val,3)
			.s val=date
			s json = json_""""_result.GetColumnName(k)_""":"""_val_""""
		}
		s json = json_"}"
		s count = count + 1
	}
	d result.Close()
	d $zu(5,"DHC-APP")
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

/// d ##class(web.DHCEMQuote).GetStartRow()
/// Creator：      zhouxin
/// CreatDate：    2019-03-09
/// Description:   返回起始行数
ClassMethod GetStartRow() As %String
{
	s page=+$g(%request.Data("page",1))
	s rows=+$g(%request.Data("rows",1))
	q:page=0 1
	q (page-1)*rows+1
}

/// d ##class(web.DHCEMQuote).GetEndRow()
/// Creator：      zhouxin
/// CreatDate：    2019-03-09
/// Description:   返回结束行数
ClassMethod GetEndRow() As %String
{
	s page=+$g(%request.Data("page",1))
	s rows=+$g(%request.Data("rows",1))
	q:page=0 9999
	q page*rows
}

/// d ##class(web.DHCEMQuote).EmptyDataGrid()
/// Creator：      zhouxin
/// CreatDate：    2019-03-09
/// Description:   返回空的数据
ClassMethod EmptyDataGrid() As %String
{
	w "{""total"":0,""rows"":[]}"
	q ""
}

/// Description: 判断所有引用的医嘱日期是否在有效的范围内
/// w ##class(web.DHCEMQuote).CheckQuoteDateScope(date)
ClassMethod CheckQuoteDateScope(date, lastPeriod = "") As %String
{
	
	s:+lastPeriod=0 lastPeriod=+$h
	s week=$SYSTEM.SQL.DATEDIFF("week",date,lastPeriod)
	q:week>48 0
	q 1
}

/// Desc:       取患者就诊列表
/// Creator:    zhouxin
/// CreateDate: 2014-8-19
/// Input:      EpisodeID 患者就诊id
/// OutPut:     j患者就诊信息
/// Debug:      w ##Class(web.DHCEMQuote).GetAdmList(2)
ClassMethod GetAdmList(EpisodeID As %String) As %String
{
	
	q:+EpisodeID=0 ##class(web.DHCEMQuote).EmptyDataGrid()
	s PatientId=$p(^PAADM(EpisodeID),"^",1)
	s start=##class(web.DHCEMQuote).GetStartRow()
	s end=##class(web.DHCEMQuote).GetEndRow()
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) //hxy 2020-06-11 st
    s LgHospID=$p($g(^CTLOC(+PatLocID)),"^",22) //ed
	//s FLastPeriod=+##class(web.DHCPUECommon).GetCollateLastPeriodDate(EpisodeID)

	s titlestr="EpisodeID^MedicareNo^EpisodeDate^EpisodeTime^Diagnosis^EpisodeType^EpisodeDeptDesc^MainDocName"
	
	k dataList
	
	
		s count=0
		s ds = ##Class(%Library.ResultSet).%New("EMRservice.HISInterface.EpisodeInfo:GetEpisodeListByPID")
		d ds.Execute(PatientId)
		While (ds.Next())
		{
			s date=ds.Data("EpisodeDate")
			//s date=$zdh(date,3)
			s dateFlag=1
			//s:+FLastPeriod'=0 dateFlag=##class(web.DHCPUECommon).CheckQuoteDateScope(date,FLastPeriod)
			//continue:(+FLastPeriod'=0)&&(dateFlag=0)
			s $p(rowData,"^",1)=ds.Data("EpisodeID")
			s $p(rowData,"^",2)=ds.Data("MedicareNo")
			s $p(rowData,"^",3)=ds.Data("EpisodeDate")
			s $p(rowData,"^",4)=ds.Data("EpisodeTime")
			s Diagnosis=ds.Data("Diagnosis")
			s Diagnosis=##class(web.DHCEMCommonUtil).GetTransDesc("User.MRCICDDx","MRCIDDesc","",Diagnosis)
			s $p(rowData,"^",5)=Diagnosis
			s $p(rowData,"^",6)=ds.Data("EpisodeType")
			s DeptDesc=ds.Data("EpisodeDeptDesc")
			s DeptDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",DeptDesc)
			s $p(rowData,"^",7)=DeptDesc
			
			s DocName=ds.Data("MainDocName")
			s DocName=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",DocName)
			s $p(rowData,"^",8)=DocName
			s CurEpisodeID=ds.Data("EpisodeID") //hxy 2020-06-11 st
			s CurPatLocID=$p(^PAADM(CurEpisodeID),"^",4) 
    		s CurHospID=$p($g(^CTLOC(+CurPatLocID)),"^",22)
			continue:CurHospID'=LgHospID //ed
			s count=count+1	
			s dataList(count)=rowData
		}		
	
	s count=0
	w "{""rows"":["
	s i=0 f  s i=$o(dataList(i)) q:i=""  d
	.s count=count+1
	.q:(count<start)||(count>end)
	.w $case(count,start:"",:",")
	.s rowData=dataList(i)
	.w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,rowData)
    w "],""total"":"_count_"}"
    k dataList
	q ""
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLOrderData", "GetOrdByAdm", "1687", "","","","","","","","N")
Query GetOrdByAdm(EpisodeID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OrdStat As %String = "", ordPriority As %String = "", ParOEItemID As %String = "") As %Query(ROWSPEC = "OrdCreateDate:%String,OrdCreateTime:%String,OrdStartDate:%String,OrdStartTime:%String,ArcimDesc:%String,DoseQty:%String,DoseUnit:%String,Priority:%String,PHFreq:%String,Instr:%String,Doctor:%String,OrdStatus:%String,Dura,OEItemID:%String,PatientID:%String,SeqNo:%String,QtyPackUOM:%String,PackUOMDesc:%String,PrescNo:%String,dstatus:%String,LabEpisodeNo:%String,OrdLabSpec:%String,OrdXDate:%String,OrdXTime:%String,OrdSkinTest:%String,OrdAction:%String,OrdDepProcNotes:%String,OrdBilled:%String,OrdSkinTestResult:%String,OEORIQty:%String,OEORIPhQty:%String,RecipeInfo:%String,Reflag:%String,Pqty:%String,Pqtydesc:%String,OEORIInsDat:%String,OEORIInsTim:%String,TypeClass:%String,mOeori:%String")
{
}

ClassMethod GetOrdByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdByAdmExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

/// Creator:      郭荣勇
/// CreatDate:    2009.02.20
/// Description:  查找本次就诊的所有医嘱
/// Table:        OEC_OrderCategory
/// Input:        EpisodeID:就诊指针, SearchStartDate:开始日期,SearchEndDate:截止日期
/// CategoryID:	  大类指针, SubsortID:子类指针
/// Return:       
/// Others:       
ClassMethod GetOrdByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OrdStat As %String = "", ordPriority As %String = "", ParOEItemID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (SearchStartDate'="")&&(SearchEndDate'="")&&((SearchEndDate-SearchStartDate)>365) Quit
	
	s RetNum=..GetOrdItem(repid,EpisodeID,SearchStartDate,SearchEndDate,CategoryID,SubsortID,"",LongOrd,ShortOrd,OrdStat,ordPriority)
	s i=0
	s SeqNo=1
	s SubSeqCount=1
	f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
	.s Data=^CacheTempFHQ(repid,i)
	.s OEItemID=$list(Data,14)
	.s OEItemIDChildsub=+$P($list(Data,14),"||",2)
	.i $d(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),11)) s LinkOrderItemChildsub=$P($p(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),11),"^",39),"||",2)
	.if $G(LinkOrderItemChildsub)="" d
	..s ^CacheTemp("DHCFindOrdItem",$j,"master",OEItemIDChildsub)=Data
	.e  d
	..if '$D(^CacheTemp("DHCFindOrdItem",$j,"master",LinkOrderItemChildsub)) d
	...s ^CacheTemp("DHCFindOrdItem",$j,"master",LinkOrderItemChildsub)=""
	..s ^CacheTemp("DHCFindOrdItem",$j,"master",LinkOrderItemChildsub,"sub",OEItemIDChildsub)=Data
	
	s SeqNo=0
	s mas=0 for  s mas=$O(^CacheTemp("DHCFindOrdItem",$j,"master",mas)) q:mas=""  d
	. s s1=^CacheTemp("DHCFindOrdItem",$j,"master",mas)
	. s PSeq=$p(mas,"||",2)
	. i s1'="" d 
	. . s SeqNo=SeqNo+1
	. . s $List(s1,16)=SeqNo
	. . i ParOEItemID="" d
	. . . s Data=s1
	. . . d OutputRow
	. s SubSeqCount=0
	. s sub=0  for  s sub=$O(^CacheTemp("DHCFindOrdItem",$j,"master",mas,"sub",sub)) q:sub=""  d
	. . s s2=^CacheTemp("DHCFindOrdItem",$j,"master",mas,"sub",sub)
	. . i s1="" d
	. . . s SeqNo= SeqNo+1
	. . . s $List(s2,16)=SeqNo
	. . . i ParOEItemID="" d
	. . . . s Data=s2
	. . . . d OutputRow
	. . e  d
	. . . s PSeq=$p(sub,"||",2)
	. . . s SubSeqCount=SubSeqCount+1
	. . . s SubSeqNo=SeqNo_"."_SubSeqCount
	. . . s $List(s2,16)=SubSeqNo
	. . . s $List(s2,33)="Child"
	. . . i ParOEItemID="" d
	. . . . s:($List(^CacheTemp(repid,ind-SubSeqCount),33)="") $List(^CacheTemp(repid,ind-SubSeqCount),33)="Parent"
	. . . . s Data=s2
	. . . . d OutputSubRow
	. . . . //s ind = ind + 1
	. . . i ParOEItemID = $List(s1,14) d
	. . . . s Data=s2
	. . . . d OutputSubRow
	
	
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
	k ^CacheTemp("DHCFindOrdItem",$j,"master")
 quit $$$OK
OutputRow
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
OutputSubRow
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetOrdByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdByAdmExecute ]
{
 s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

ClassMethod GetOrdItem(repid As %Integer = 0, AdmId As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", ArcId As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OrdStat As %String = "", ordPriority As %String = "") As %Integer
{
	//Add By 20130423	
	i ordPriority="S" s ordPriority="S^OMST"
	i ordPriority="N" s ordPriority="NORM^OM^ONE"
	i ordPriority="O" s ordPriority="OUT"
	i ordPriority="Z" s ordPriority="ZCY"
	
	s ^RP("benCiItm")=LongOrd_"^"_ShortOrd
	s del="^",AdmType="",RetNum=0
	q:($g(AdmId)="") RetNum
	q:'$d(^OEORD(0,"Adm",AdmId)) RetNum	
	s OrdId1=$o(^OEORD(0,"Adm",AdmId,0))
	s PatientID=$P(^PAADM(AdmId),"^",1)
	q:OrdId1=""
	//Add By 20130423	
	s TempPAQUE1 = ""
	
	s OrdId2=0
	s OrdCreateDate="",OrdCreateTime="",OrdStartDate="",OrdStartTime="",ArcimDesc="",RecipeInfo="",Reflag=""
	f  s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2)) q:OrdId2=""  d
	.s OEItemID=OrdId1_"||"_OrdId2
	.s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
	.s ordstr2=$g(^OEORD(OrdId1,"I",OrdId2,2))
	.s ordstr3=$g(^OEORD(OrdId1,"I",OrdId2,3))
	.s ordstr5=$g(^OEORD(OrdId1,"I",OrdId2,5))
	.s ordstr9=$g(^OEORD(OrdId1,"I",OrdId2,9))
	.s ordstr11=$g(^OEORD(OrdId1,"I",OrdId2,11))
	.s OEORIQty=$p(ordstr1,"^",18)
	.s OEORIPhQty=$p(ordstr1,"^",12)
	
	.s ordStatDR=$p($g(^OEORD(OrdId1,"I",OrdId2,1)),"^",13) //hxy 2020-04-28 st
	.Q:(ordStatDR="")
	.s ordStatCode=$P($g(^OEC("OSTAT",ordStatDR)),"^",1)
	.s ordStatDesc=$P($g(^OEC("OSTAT",ordStatDR)),"^",2)
	.Q:((ordStatCode="U")&&(ordStatDesc="作废"))
	.Q:((ordStatCode="C")&&(ordStatDesc="撤销")) //ed	
		
	.//Add By 20130423
	.s PriorityDR=$p(ordstr1,del,8)
	.s:$g(PriorityDR)="" Priority="",PriorityCode=""
	.s:$g(PriorityDR)'="" Priority=$p(^OECPR(PriorityDR),del,2),PriorityCode=$p(^OECPR(PriorityDR),del,1)	
	.Q:(ordPriority'="")&&(("^"_ordPriority_"^")'[("^"_PriorityCode_"^"))&&(ordPriority'="ZCY")
	
	.;医嘱过滤参数FilterOrder  Add By Lina 2017-01-22
	.s filterOrder = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("FilterOrder")
	.s:(filterOrder = "") filterOrder = "N^N^N"
	.;过滤作废医嘱
	.i ($p(filterOrder,"^",1)="Y"){
		.s ordStatDR=$p($g(^OEORD(OrdId1,"I",OrdId2,1)),"^",13)
		.Q:(ordStatDR="")
	    .s ordStatCode=$P($g(^OEC("OSTAT",ordStatDR)),"^",1)
	    .s ordStatDesc=$P($g(^OEC("OSTAT",ordStatDR)),"^",2)
	    .Q:((ordStatCode="U")&&(ordStatDesc="作废"))
	.}
	.;过滤停止医嘱
	.i ($p(filterOrder,"^",2)="Y"){
		.s ordStatDR=$p($g(^OEORD(OrdId1,"I",OrdId2,1)),"^",13)
		.Q:(ordStatDR="")
	    .s ordStatCode=$P($g(^OEC("OSTAT",ordStatDR)),"^",1)
	    .s ordStatDesc=$P($g(^OEC("OSTAT",ordStatDR)),"^",2)
	    .Q:((ordStatCode="D")&&(ordStatDesc="停止"))
    .}
    .;过滤非医生所下医嘱(护士补录医嘱等)
    .i ($p(filterOrder,"^",3)="Y"){
		.s ordUserAdd=$p($g(^OEORD(OrdId1,"I",OrdId2,7)),"^",1)
		.Q:(ordUserAdd="")
	    .s SSUSRCareProvDR=$p($G(^SSU("SSUSR",ordUserAdd)),"^",14)
	    .Q:(SSUSRCareProvDR="")
	    .s CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)
	    .s CTCPTInternalType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
	    .Q:(CTCPTInternalType'="DOCTOR")
	.}
	.s doctor=$p(ordstr1,del,11)
	.s:$g(doctor)'="" doctor=$p(^CTPCP(doctor,1),del,2)
	.s:$g(doctor)="" doctor=""
	.
	.;中草药处理	
	.s PrescNo=$p(ordstr1,del,14)  //处方号
	.s ArcimId=$p(ordstr1,del,2)
	.q:((ArcId'="")&(ArcimId'=ArcId))
    .s ZCYCheckNum=##Class(EMRservice.BL.BLOrderData).ZCYCheckByArcimId(ArcimId)
    .;临时医嘱里面过滤中草药
    .//q:(ordPriority["NORM")&&(ZCYCheckNum="1")
    .;出院带药里面过滤中草药 Add By Lina 2017-01-20
	.q:(ordPriority["OUT")&&(ZCYCheckNum="1")
	.i (ZCYCheckNum="1")&&((PriorityCode["NORM")||(PriorityCode["OUT")||(PriorityCode["STAT"))&&(ordPriority="ZCY") d  q
	..i (TempPAQUE1 '[ PrescNo) d
	...s TempPAQUE1=TempPAQUE1_"^"_PrescNo	
	...s OrdMainId=OrdId1
	...s tmpVal = PrescNo,ZCYOrdId2=0,ZCYRecipeInfo="",ZCYArcimDesc="",ZCYPackQty=""	,ZCYOrderQty="",ZCYOrderUOM="",ZCYPHCFRDesc="",ZCYPHDurationDesc="",num=0
	...f  s ZCYOrdId2=$o(^OEORD(0,"PrescNo",tmpVal,OrdMainId,ZCYOrdId2)) q:ZCYOrdId2=""  d
	....s ZCYordstr1=$g(^OEORD(OrdMainId,"I",ZCYOrdId2,1))
	....s ZCYordstr2=$g(^OEORD(OrdMainId,"I",ZCYOrdId2,2))
	....s ZCYArcimId=$p(ZCYordstr1,del,2)
	....s ZCYArcStr=##class(web.DHCFBArcimGet).GetArcimById(ZCYArcimId)	 	
	....q:ZCYArcStr=""
	....s OrdStatusDR=$p(ordstr1,del,13)	
	....s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),del,2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),del,1)
	....s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
	....Q:(OrdStat'="")&&(OrdStatusCode=OrdStat)    ;东方医院不显示停止的医嘱
	....s TempZCYArcimDesc=$p(ZCYArcStr,del,3)
	....s TempZCYArcimDesc=$p(TempZCYArcimDesc,"(",1)
	....i TempZCYArcimDesc["[" s TempZCYArcimDesc=$p(TempZCYArcimDesc,"[",1)
	....s length = $length(TempZCYArcimDesc)	
	....s ZCYArcimDesc=ZCYArcimDesc_TempZCYArcimDesc
	....s ZCYOEORIQty=$p(ZCYordstr1,"^",18)	     
    ....s ZCYDoseQty=$p(ZCYordstr2,del,1),ZCYDoseUnit=$p(ZCYordstr2,del,3)
	....s:ZCYDoseUnit'="" ZCYDoseUnit=$p(^CT("UOM",ZCYDoseUnit),del,2)
	....s ZCYArcimDesc=ZCYArcimDesc_" "_ZCYDoseQty_ZCYDoseUnit_","
	....s num=num+1
	....s Restvalue=num/4   
	...//根据医嘱状态过滤中草药医嘱
	...s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),del,2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),del,1)
	...s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
	...Q:(OrdStat'="")&&(OrdStat'[(" "_OrdStatusCode_" "))
	
	...s Queid=""
	...s Queid=$o(^PAQUE1(0,"PrescNo",tmpVal,Queid))	
	...s ZCYPAQUE1Value=^PAQUE1(Queid,"DHC")	
	...s ZCYPHFreq=$p(ZCYPAQUE1Value,del,9)	
	...s ZCYPHCFRDesc=$p(^PHCFR(ZCYPHFreq),del,3)
	...s ZCYPHDurationDR=$p(ZCYPAQUE1Value,del,10)
	...s ZCYPHDurationDesc=$p(^PHCDU(ZCYPHDurationDR),del,2)
	...s ZCYOrderQty=$p(ZCYPAQUE1Value,del,13)
	...s ZCYOrderUOM=$p(ZCYPAQUE1Value,del,14)	
    ...s OrdCreateDate=$p(ordstr3,del,7),OrdCreateDate=$zd(OrdCreateDate,3)
	...s OrdCreateTime=$p(ordstr1,del,17),OrdCreateTime=$zt(OrdCreateTime,2) ;,OrdCreateDate=OrdCreateDate_" "_OrdCreateTime
	...s OrdStartDate=$p(ordstr1,del,9),OrdStartDate=$zd(OrdStartDate,3)
	...s OrdStartTime=$p(ordstr1,del,10),OrdStartTime=$zt(OrdStartTime),OrdStartDate=OrdStartDate_" "_OrdStartTime	
	...s DoseQty=ZCYOrderQty
	...s DoseUnit=ZCYOrderUOM
	...s TempordPriority="ZCY"
	...s Instr=$p(ZCYordstr2,del,7)
	...s:$g(Instr)'="" Instr=$p(^PHCIN(Instr),del,2)
	...s:$g(Instr)="" Instr=""
	...s ZCYRecipeInfo = ZCYPHDurationDesc_"付,每付"_ZCYOrderQty_ZCYOrderUOM_","_ZCYPHCFRDesc
	...s ArcimDesc=$e(ZCYArcimDesc,0,$l(ZCYArcimDesc)-1)
	...s RecipeInfo=ZCYRecipeInfo
	...s PHFreq=$p(^PHCFR(ZCYPHFreq),del,4)
	...S RetNum=RetNum+1	
	
	...S ^CacheTempFHQ(repid,RetNum)=$LB(OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,OEItemID,PatientID,OrderSeqNo,QtyPackUOM,PackUOMDesc,PrescNo,dstatus,LabEpisodeNo,OrdLabSpec,OrdXDate,OrdXTime,OrdSkinTest,OrdAction,OrdDepProcNotes,OrdBilled,OrdSkinTestResult,OEORIQty,OEORIPhQty,RecipeInfo,Reflag)
	.q:(ordPriority="ZCY")
		
	.s ArcimId=$p(ordstr1,del,2)
	.q:((ArcId'="")&(ArcimId'=ArcId))
	
	.s ArcStr=##class(web.DHCFBArcimGet).GetArcimById(ArcimId)
	.q:ArcStr=""
	
	.s OrderType="",PHPrescType="",TypeClass=""
	.s ItemCatDR=$p($g(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1)),"^",10)
	.i ItemCatDR'="" s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	.i ItemCatDR'="" s OeOrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)
	.i ItemCatDR s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR)
	.i OrderType="R" d
	..i PHPrescType="3" s TypeClass="草药"
	..e  s TypeClass="西药"
	
	.e  i OrderType="L" s TypeClass="检验"
	.e  i $g(ArcService)="S" s TypeClass="检查"
	.e  s TypeClass="其他"
		
	.s ArcimCode=$p(ArcStr,del,2),ArcimDesc=$p(ArcStr,del,3)
	.i $o(^DHCAPREP(0,"OrdItem",OEItemID,"")) D
	..s ArcimDesc = ##Class(web.DHCAPPInterface).GetExaReqItemDesc(OEItemID,"")
	.s OrdCreateDate=$p(ordstr3,del,7) //,OrdCreateDate=$zd(OrdCreateDate,3)
	.s OrdCreateDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(OrdCreateDate) /// 转化日期格式
	.s OrdCreateTime=$p(ordstr1,del,17),OrdCreateTime=$zt(OrdCreateTime,2)
	.s OrdStartDate=$p(ordstr1,del,9),OrdStartDate=$zd(OrdStartDate,3)
	.s OrdStartTime=$p(ordstr1,del,10),OrdStartTime=$zt(OrdStartTime)
	.s OEORIInsDat=$p(ordstr1,del,19)
	.s OEORIInsTim=$p(ordstr1,del,20)
	.s PrescNo=$p(ordstr1,del,14)
	.s DoseQty=$p(ordstr2,del,1),DoseUnit=$p(ordstr2,del,3)
	.s:(DoseQty="") DoseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OEItemID) 
	.//guorongyong start 2008-11-25
	.s OrdcatDR=""
	.s SubsortDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),del,10)
	.s:SubsortDR'="" OrdcatDR=$p(^ARC("IC",SubsortDR),del,8)
	.Q:(SubsortID'="")&&(SubsortID'=SubsortDR)
	.Q:(CategoryID'="")&&(CategoryID'=OrdcatDR)
	.Q:(SearchStartDate'="")&&(SearchEndDate'="")&&(($zdh(OrdStartDate,3)<SearchStartDate)||($zdh(OrdStartDate,3)>SearchEndDate))
	.s OrderSeqNo=$p(ordstr3,del,4)
	.Q:((OrderSeqNo = 1000)||(OrderSeqNo = 1001))
	
	.s:DoseUnit'="" DoseUnit=$p(^CT("UOM",DoseUnit),del,2)
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),""))
	.s dsp="",QtySum=0
    .for  s dsp=$o(^DHCOEDISQTY(0,"OEORI",OEItemID,dsp)) q:dsp=""  do
    ..s Qty=$p(^DHCOEDISQTY(dsp),"^",5)
    ..s QtySum=QtySum+Qty
    .s QtySum=##Class(EMRservice.BL.BLOrderData).getPackQty(inci,QtySum)     //大包装  数量+单位
    .s Pqty=$p(QtySum,"^",1)
    .s Pqtydesc=$p(QtySum,"^",2)
	.s PriorityDR=$p(ordstr1,del,8)
	.s:$g(PriorityDR)="" Priority="",PriorityCode=""
	.s:$g(PriorityDR)'="" Priority=$p(^OECPR(PriorityDR),del,2),PriorityCode=$p(^OECPR(PriorityDR),del,1)
	.;w !,Priority_"^"_PriorityCode
	.Q:(LongOrd="on")&&(ShortOrd'="on")&&(PriorityCode'="S")
	.Q:(ShortOrd="on")&&(LongOrd'="on")&&(PriorityCode'="NORM")
	.Q:(OrdStat="on")&&(LongOrd'="on")&&(ShortOrd'="on")&&(PriorityCode'="OUT")
	.s PHFreqDR=$p(ordstr2,del,4)
	.//i ($g(PHFreqDR)'="")&&($d(^PHCFR(PHFreqDR))) D
	.//.s PHFreq=$p(^PHCFR(PHFreqDR),del,1)
	.//.s PHFreqDesc=$p(^PHCFR(PHFreqDR),del,3)
	.//.s WeekFlag=$P(^PHCFR(PHFreqDR),"^",9)
	.//.i WeekFlag="Y" D
	.//..s OrderFreqWeek=$p($g(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",55)
	.//..s PHFreq=PHFreq_"-"_$TR(OrderFreqWeek,"|","")
	.//..s PHFreqDesc=PHFreqDesc_"-"_$TR(OrderFreqWeek,"|","")
	.//s:$g(PHFreq)="" PHFreq="",PHFreqDesc=""
	.//s PHFreq=PHFreqDesc
	.s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(OrdId1_"||"_OrdId2,"^")
	.s PHFreq=$List(OrdFreqInfo,2)
	.s PHFreq=$REPLACE(PHFreq,"^","-")
	.;i OrderType'="R" s PHFreq=""
	.s Instr=$p(ordstr2,del,7)
	.s:$g(Instr)'="" Instr=$p(^PHCIN(Instr),del,2)
	.s:$g(Instr)="" Instr=""
	.s OrdStatusDR=$p(ordstr1,del,13)
	
	.s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),del,2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),del,1)
	.s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
	.Q:(OrdStat'="")&&(OrdStatusCode=OrdStat)    ;东方医院不显示停止的医嘱
	
	.s Dura=$p(ordstr2,del,6)
	.if ($g(Dura)'="")  d
	..s:($d(^PHCDU(Dura))) Dura=$p(^PHCDU(Dura),del,3)
	.s:$g(Dura)="" Dura=""
	.s doctor=$p(ordstr1,del,11)
	.s:$g(doctor)'="" doctor=$p(^CTPCP(doctor,1),del,2)
	.s:$g(doctor)="" doctor=""
	.s QtyPackUOM=$p(ordstr9,del,4)
	.s PackUOMDesc=""
	.s BillingUOMDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),8),"^",14)
	.if BillingUOMDR'="" s PackUOMDesc=$p(^CT("UOM",BillingUOMDR),"^",2)
	.s HaveDispensing=0,dstatus=""
	.s dis=0  f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OEItemID,dis)) Q:dis=""  d
	..s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
	..s HaveDispensing=1
	.i HaveDispensing=1 d
	..i dstatus="C" s dstatus="已发"
	..i dstatus="TC" s dstatus="未发"
	..i dstatus=""  s dstatus="未打包"
	.;条码号,标本
	.s LabEpisodeNo=$p(ordstr3,del,20) ;
	.s OrdLabSpec=##Class(web.DHCOEOrdItem).GetLabSpec(OEItemID)
	.;停医嘱日期,停医嘱时间
	.s OrdXDate=$p(ordstr3,del,34)
	.if OrdXDate'="" s OrdXDate=$zd(OrdXDate,3)
	.s OrdXTime=$p(ordstr2,del,15)
	.if OrdXTime'="" s OrdXTime=$zt(OrdXTime,2)
	.;皮试,皮试备注,备注,
	.s OrdSkinTest=$p(ordstr5,del,2)
	.s OrdAction=$p(ordstr11,del,21)
	.i OrdAction'="" s OrdAction=$P($G(^OEC("ACT",OrdAction)),"^",2) 
	.s OrdDepProcNotes=$g(^OEORD(OrdId1,"I",OrdId2,"DEP",1))
	.s OrdBilled=$p(ordstr3,"^",5)
	.s abnorm=$p($g(^OEORD(OrdId1,"I",OrdId2,11)),"^",3)
	.s OrdSkinTestResult=""
	.i OrdSkinTest="Y" d
	..i abnorm="Y" s OrdSkinTestResult="皮试:阳性"
	..else  if (abnorm="N")  s OrdSkinTestResult="皮试:阴性"
	.s mOeori=..GetMainOeori(OEItemID) /// 主医嘱ID
	.;
	.S RetNum=RetNum+1
	.S ^CacheTempFHQ(repid,RetNum)=$LB(OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,OEItemID,PatientID,OrderSeqNo,QtyPackUOM,PackUOMDesc,PrescNo,dstatus,LabEpisodeNo,OrdLabSpec,OrdXDate,OrdXTime,OrdSkinTest,OrdAction,OrdDepProcNotes,OrdBilled,OrdSkinTestResult,OEORIQty,OEORIPhQty,RecipeInfo,Reflag,Pqty,Pqtydesc,OEORIInsDat,OEORIInsTim,TypeClass,mOeori)
	
	q RetNum
}

/// Creator：      Candy
/// CreateDate：   2011-10-27
/// Description:： According to PEpisodeID search for MRDiagnos List
/// Table： MR_Diagnos
/// Input： PEpisodeID
/// Output：ARowID:诊断ID
///         AMRADMRowId
///         ADiaSubID
///         ADiagnosTypeID:类型ID
///         ADiagnosType:类型名称,
///         AIcdID:诊断ICDID
///         ADiagnosName:诊断名称
///         ADemo:备注
///         AEvaluation:状态属性,
///         AEvaluationDesc:状态属性名称
///         ICDCode 诊断代码
///         AEffects:转归属性
///         AEffectsDesc:转归属性名称,
///         ALevel:级别,ASquence:顺序,AUserName:医生,ADateTime:时间
/// Others：do ##class(%ResultSet).RunQuery("web.DHCEMQuote","GetMRDiagnosList","22","")
Query GetMRDiagnosList(PEpisodeID As %String, PTypeID As %String) As %Query(ROWSPEC = "ARowID:%String,AMRADMRowId:%String,ADiaSubID:%String,ADiagnosTypeID:%String,ADiagnosType:%String,AICDID:%String,ADiagnosName:%String,ADemo:%String,AEvaluation:%String,AEvaluationDesc:%String,AICDCode:%String,AEffects:%String,AEffectsDesc:%String,ALevel:%String,ASquence:%String,AUserName:%String,ADateTime:%String,mainMRID:%String,SDSDesc:%String")
{
}

ClassMethod GetMRDiagnosListExecute(ByRef qHandle As %Binary, PEpisodeID As %String, PTypeID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)

 	s ind = 1
    s MRADMRowId = $p($g(^PAADM(PEpisodeID)),"^",61)
    q:(MRADMRowId = "") $$$OK
	s DiaSubID = "0" 
	for {
	   s DiaSubID = $o(^MR(MRADMRowId,"DIA",DiaSubID))
	   q:(DiaSubID = "")
	   s MRRowId = MRADMRowId_"||"_DiaSubID
	   //诊断类型
	   s TypeID = $g(^MR(MRADMRowId,"DIA",DiaSubID,"TYP",1))
	   continue:((PTypeID '= TypeID) && (PTypeID '= "") && (PTypeID '= $c(0)))  
	   s TypeDesc = ""
	   s:(TypeID '="") TypeDesc = $p($g(^MRC("DTYP",TypeID)),"^",2)
	   //诊断
	   s ICDID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",1)
	   s ICDDesc = ""
	   s ICDCode = ""
	   if (ICDID '= "")&&(ICDID '= $c(0))
	   {
	       s ICDDesc = $p(^MRC("ID",ICDID),"^",2)
	       s ICDCode = $p(^MRC("ID",ICDID),"^",4)
	   }
	   //非ICD
	   s DemoDesc = $g(^MR(MRADMRowId,"DIA",DiaSubID,"DES",1))
	   if (($d(^MR(MRADMRowId,"DIA",DiaSubID,"DES",1))'=0) && (ICDDesc = ""))
	   { 
	       s ICDDesc = $g(^MR(MRADMRowId,"DIA",DiaSubID,"DES",1))
	       s ICDCode = "" 
	   }
	   //级别
	   s Level = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",1)
	   //顺序
	   s Sequence = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",2)
	   
	   if $d(^MR(MRADMRowId,"DIA",DiaSubID,"EPR"))'=0
	   {
	      s EvaluationID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",9)
          s EffectsID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",4)
	   }
	   else 
	   {
		   s EvaluationID = ""
		   s EffectsID =""
	   }
	   //状态属性
       s EvaluationDesc =""
       if (EvaluationID '="") && (EvaluationID '="0") {s EvaluationDesc =$p($g(^MRC("DSTAT",EvaluationID)),"^",2)}
       B //FFF
       //转归属性
       s EffectsDesc = ""
       if (EffectsID '= "") && (EffectsID '= "0") {s EffectsDesc = $Li($g(^DHCEPRM.CustomDictionaryD(EffectsID)),4)}
	   //日期时间
	   s Date = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",7)
	   s:(Date '= "") Date = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(Date,"date") //$ZD(Date,3)
	   s Time = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",8)
	   s:(Time '="") Time = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(Time,"time") //$ZT(Time)
	   s DateTime = Date_" "_Time
	   //医生
	   s UserID =  $p(^MR(MRADMRowId,"DIA",DiaSubID),"^",12)
	   s:(UserID '="") UserName = $p($g(^SSU("SSUSR",UserID)),"^",2)
	   
	   s mainMRID = $p(^MR(MRADMRowId,"DIA",DiaSubID),"^",15)
	   i mainMRID = "" s mainMRID=MRADMRowId_"||"_DiaSubID
	   
	   s RowID=MRADMRowId_"||"_DiaSubID
	   ;结构化诊断信息返回
	   s ADMNo=$p(^PAADM(PEpisodeID),"^",81)   
 	   s SDSInfo=##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetStructDiagnos(ADMNo,RowID)
       s SDSDesc=$P(SDSInfo,"^",4)
 
	   s data = $lb(RowID,MRADMRowId,DiaSubID,TypeID,TypeDesc,ICDID,ICDDesc,DemoDesc,EvaluationID,EvaluationDesc,ICDCode,EffectsID,EffectsDesc,Level,Sequence,UserName,DateTime,mainMRID,SDSDesc)
	   s ^CacheTemp(repid,ind) = data
	   s ind=ind+1  	 
	} 
	Quit $$$OK
}

ClassMethod GetMRDiagnosListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRDiagnosListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRDiagnosListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRDiagnosListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Liang Qiang
/// CreatDate:2009-04-13
/// Description:取关联医嘱主医嘱的Rowid
/// Input:oe_orditmRowid
/// Ouput:关联医嘱主医嘱的Rowid
/// Return:关联医嘱主医嘱的Rowid
/// Others:
ClassMethod GetMainOeori(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:loeori'="" loeori
 	Q oeori
}

/// w ##class(web.DHCEMQuote).GetImg("237")
ClassMethod GetImgOld(RptRowID As %String)
{
	n (RptRowID)
	s ret=""
	q:RptRowID="" ""
	s StudyNo=$p(^DHCRBStudy("Report",RptRowID),"^")
	s IshasImg=""
	i (StudyNo'="") d
	.s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,0))   ;
	.s IshasImg=##class(web.DHCAPPSeePatPacs).GetImageStatus(StudyNo)
	.i Imgrowid'="" s IshasImg="Y"
	.s:IshasImg="Y" ret="图像"
	q ret
}

/// w ##class(web.DHCEMQuote).GetImgNew("146||32","237")
/// w ##class(web.DHCEMQuote).GetImgNew("146||152","359")
ClassMethod GetImg(OrdItemDR As %String, RptRowID As %String)
{
	n (OrdItemDR,RptRowID)
	s ret=""
	q:(RptRowID="")||(RptRowID="") ""
	s StudyNo=$p(^DHCRBStudy("Report",RptRowID),"^")
	s ExamID = StudyNo
	s Position="",RepPartID="",PartDesc=""
	s ARRowID=$o(^DHCAPREP(0,"OrdItem",OrdItemDR,""))
	s ARChildSub=""
	for {
		s ARChildSub=$o(^DHCAPREP(ARRowID,"AR",ARChildSub)) 
		q:ARChildSub=""
		s OEORIId = $p(^DHCAPREP(ARRowID,"AR",ARChildSub),"^",3)
		continue:OEORIId=""
		if ('$d(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA"))){
			s RepPartID=""
			for{
				s RepPartID= $o(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA",RepPartID))
				q:RepPartID=""
				s ReqPartStatus = $p(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA",RepPartID),"^",2)
				Continue:ReqPartStatus="D" //D为停止状态
				s PartID = $p(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA",RepPartID),"^",1)
				Continue:PartID=""
				s PartItmDesc = $p($g(^DHCAPPART(PartID)),"^",2) 
				s:PartDesc'="" PartDesc=PartDesc_"+"_PartItmDesc
				s:PartDesc="" PartDesc=PartItmDesc
				s:Position'="" Position=Position_"@@"_PartItmDesc
				s:Position="" Position=PartItmDesc
			}
		}
	}
	s ExamStatus=##Class(web.DHCAPPInterface).GetExaReqItmStatus(OrdItemDR,ExamID,Position)
	s IshasImg=""
	i (StudyNo'="") d
	.s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,0))   ;
	.s IshasImg=##class(web.DHCAPPSeePatPacs).GetImageStatus(StudyNo)
	.i Imgrowid'="" s IshasImg="Y"
	i ((ExamStatus="RP")||(ExamStatus="RD")) d   ;默认检查完成后才能查看报告和图像
	.s ret="图像"  ; s:IshasImg="Y" ret="图像"  ;2023-02-03 cy 匹配患者检查报告信息列表显示内容
	s ret=##class(web.DHCEMCommonUtil).GetTrans("dhcem.quote.csp",ret)
	q ret
}

}

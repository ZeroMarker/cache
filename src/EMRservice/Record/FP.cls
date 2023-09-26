Class EMRservice.Record.FP Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	病案首页是否有院内感染的诊断
/// 		判断标准：出院诊断包含“感染”且入院情况为“无”
/// Debug:	w ##Class(EMRservice.Record.FP).HasNosocomialInfection("10883462")
ClassMethod HasNosocomialInfection(AEpisodeID As %String, ANeedAllDiag As %String = "1") As %String
{
	s hospital = ##Class(EMRservice.BOSysOption).GetValueByName("HospitalName")
	if (hospital = "BJXHYY")
	{
		q ..HasNosoInfectionXH(AEpisodeID, ANeedAllDiag)
	}
	else
	{
		q ..HasNosoInfection(AEpisodeID, ANeedAllDiag)
	}
}

ClassMethod HasNosoInfection(AEpisodeID As %String, ANeedAllDiag As %String = "1") As %String
{
	s ret = "0", infectionDiag = ""
	
	s gCate = "HDSD00.11"
	s gList = "HDSD00.11.024|HDSD00.11.304"
	s gList = gList_"^"_"HDSD00.11.021|HDSD00.11.305"
	s gList = gList_"^"_"HDSD00.11.306|HDSD00.11.309"
	s gList = gList_"^"_"HDSD00.11.310|HDSD00.11.313"
	s gList = gList_"^"_"HDSD00.11.314|HDSD00.11.317"
	s gList = gList_"^"_"HDSD00.11.318|HDSD00.11.321"
	s gList = gList_"^"_"HDSD00.11.322|HDSD00.11.325"
	s gList = gList_"^"_"HDSD00.11.326|HDSD00.11.329"
	s gList = gList_"^"_"HDSD00.11.330|HDSD00.11.333"
	s gList = gList_"^"_"HDSD00.11.334|HDSD00.11.337"
	s gList = gList_"^"_"HDSD00.11.338|HDSD00.11.341"
	s gList = gList_"^"_"HDSD00.11.342|HDSD00.11.345"
	s gList = gList_"^"_"HDSD00.11.346|HDSD00.11.349"
	s gList = gList_"^"_"HDSD00.11.350|HDSD00.11.353"
	s gList = gList_"^"_"HDSD00.11.354|HDSD00.11.357"
	s gList = gList_"^"_"HDSD00.11.358|HDSD00.11.361"
	
	s gCateID = $o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_gCate,""))
	q:(gCateID = "") ret_"^"_infectionDiag
	
	s count = $L(gList,"^")
	for i = 1:1:count
	{
		s g = $p(gList,"^",i)
		continue:(g = "")
		continue:($l(g,"|") '= 2)
		
		s diag = $p(g, "|", 1)
		s cond = $p(g, "|", 2)
		
		s diagid = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_diag," "_gCateID,""))
		continue:(diagid = "")
		
		s condid = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_cond," "_gCateID,""))
		continue:(condid = "")
		
		s value1 = ##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryID(AEpisodeID,diagid)
		s:(value1 '= "") value1 = value1.GetNext("")
		//continue:($f(value1,"感染") = 0)
		continue:(value1 = "")||(value1 = "Null")
		s isInf = ##class(DHCMed.NINFService.Srv.Interface).isInfDiaByKeys(value1)
		continue:(isInf = "0")

		s value2 = ##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryID(AEpisodeID,condid)
		s:(value2 '= "") value2 = value2.GetNext("")
		continue:($f(value2,"无") = 0)
		
		s ret = "1"
		if (infectionDiag = "") 
		{	s infectionDiag = value1}
		else
		{	s infectionDiag = infectionDiag_","_value1}
		
		quit:(ANeedAllDiag = "0")
	}
	
	q ret_"^"_infectionDiag
}

ClassMethod HasNosoInfectionXH(AEpisodeID As %String, ANeedAllDiag As %String = "1") As %String
{
	s ret = "0",infectionDiag = ""
	
	s gCate = "HDSD00.11"
	
	//主要诊断、其他诊断01-15
	s gList = "HDSB05.10.056|HDSB05.10.058"
	s gList = gList_"^"_"HDSB05.10.059|HDSB05.10.505"
	s gList = gList_"^"_"HDSB05.10.506|HDSB05.10.508"
	s gList = gList_"^"_"HDSB05.10.510|HDSB05.10.512"
	s gList = gList_"^"_"HDSB05.10.514|HDSB05.10.516"
	s gList = gList_"^"_"HDSB05.10.518|HDSB05.10.520"
	s gList = gList_"^"_"HDSB05.10.522|HDSB05.10.524"
	s gList = gList_"^"_"HDSB05.10.526|HDSB05.10.528"
	s gList = gList_"^"_"HDSB05.10.530|HDSB05.10.532"
	s gList = gList_"^"_"HDSB05.10.534|HDSB05.10.536"
	s gList = gList_"^"_"HDSB05.10.538|HDSB05.10.540"
	s gList = gList_"^"_"HDSB05.10.542|HDSB05.10.544"
	s gList = gList_"^"_"HDSB05.10.546|HDSB05.10.548"
	s gList = gList_"^"_"HDSB05.10.550|HDSB05.10.552"
	s gList = gList_"^"_"HDSB05.10.554|HDSB05.10.556"
	s gList = gList_"^"_"HDSB05.10.558|HDSB05.10.560"
	
	s gCateID = $o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_gCate,""))
	q:(gCateID = "") ret_"^"_infectionDiag
	
	s count = $L(gList,"^")
	for i = 1:1:count
	{
		s g = $p(gList,"^",i)
		continue:(g = "")
		continue:($l(g,"|") '= 2)
		
		s diag = $p(g, "|", 1)
		s cond = $p(g, "|", 2)
		
		//s diagid = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_diag,""))
		s diagid = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_diag," "_gCateID,""))
		continue:(diagid = "")
		
		//s condid = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_cond,""))
		s condid = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_cond," "_gCateID,""))
		continue:(condid = "")
		
		//b "s"
		s value1 = ##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryID(AEpisodeID,diagid)
		s:(value1 '= "") value1 = value1.GetNext("")
		//continue:($f(value1,"感染") = 0)
		continue:(value1 = "")||(value1 = "Null")
		s isInf = ##class(DHCMed.NINFService.Srv.Interface).isInfDiaByKeys(value1)
		continue:(isInf = "0")
		
		s value2 = ##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryID(AEpisodeID,condid)
		s:(value2 '= "") value2 = value2.GetNext("")
		continue:($f(value2,"无") = 0)
		
		s ret = 1
		if (infectionDiag = "") 
		{	s infectionDiag = value1}
		else
		{	s infectionDiag = infectionDiag_","_value1}
		
		quit:(ANeedAllDiag = "0")
	}
	
	q ret_"^"_infectionDiag
}

/// Desc:	获取指定日期内病案首页有院内感染诊断的患者List
/// Input：	AStartDisDate 开始日期，Cache内部格式，整数值
/// 		AEndDisDate   结束日期，Cache内部格式，整数值
/// 			ADateType	  日期类型，D 出院日期，A 入院日期
/// Debug:	w ##Class(EMRservice.Record.FP).GetNosocomialInfectionList("64200","64211","D")
/// 		w ##Class(EMRservice.Record.FP).GetNosocomialInfectionList("64200","64211","A")
ClassMethod GetNosocomialInfectionList(AStartDisDate As %String, AEndDisDate As %String, ADateType As %String = "D") As %List
{
	s retList = ""
	
	q:(AStartDisDate > AEndDisDate) retList
	
	for date = AStartDisDate:1:AEndDisDate
	{
		s admID = ""
		for {
			if (ADateType = "A")
			{
				s admID = $o(^PAADMi("PAADM_AdmDate",date,admID))
			}
			else
			{
				s admID = $o(^PAADMi("DischDate",date,admID))
			}
			q:(admID = "")
			
			s type= $p(^PAADM(admID),"^",2)
			continue:(type '= "I")  //住院
			
			continue:($d(^PAADMi("PAADM_VisitStatus","C",admID)) '= 0)	//是否取消
			
			s hasInfection = ..HasNosocomialInfection(admID,"0")
			s hasInfection = $p(hasInfection,"^",1)
			continue:(hasInfection '= "1")
			
			s retList = retList_$lb(admID)
		}
	}
	
	q retList
}

/// Desc:	病案首页是否有院内感染的诊断
/// 		判断标准：出院诊断包含“感染”且入院情况为“无”
/// Debug:	w ##Class(EMRservice.Record.FP).HasRareDiseases("10883462")
ClassMethod HasRareDiseases(AEpisodeID As %String, ANeedAllDiag As %String = "1") As %String
{
	s hospital = ##Class(EMRservice.BOSysOption).GetValueByName("HospitalName")
	if (hospital = "BJXHYY")
	{
		q ..HasRDsXH(AEpisodeID, ANeedAllDiag)
	}
	else
	{
		q ..HasRDs(AEpisodeID, ANeedAllDiag)
	}
}

ClassMethod HasRDs(AEpisodeID As %String, ANeedAllDiag As %String = "1") As %String
{
	s ret = "0", rdDiag = ""
	
	s gCate = "HDSD00.11"
	s gList = "HDSD00.11.024|HDSD00.11.304"
	s gList = gList_"^"_"HDSD00.11.021|HDSD00.11.305"
	s gList = gList_"^"_"HDSD00.11.306|HDSD00.11.309"
	s gList = gList_"^"_"HDSD00.11.310|HDSD00.11.313"
	s gList = gList_"^"_"HDSD00.11.314|HDSD00.11.317"
	s gList = gList_"^"_"HDSD00.11.318|HDSD00.11.321"
	s gList = gList_"^"_"HDSD00.11.322|HDSD00.11.325"
	s gList = gList_"^"_"HDSD00.11.326|HDSD00.11.329"
	s gList = gList_"^"_"HDSD00.11.330|HDSD00.11.333"
	s gList = gList_"^"_"HDSD00.11.334|HDSD00.11.337"
	s gList = gList_"^"_"HDSD00.11.338|HDSD00.11.341"
	s gList = gList_"^"_"HDSD00.11.342|HDSD00.11.345"
	s gList = gList_"^"_"HDSD00.11.346|HDSD00.11.349"
	s gList = gList_"^"_"HDSD00.11.350|HDSD00.11.353"
	s gList = gList_"^"_"HDSD00.11.354|HDSD00.11.357"
	s gList = gList_"^"_"HDSD00.11.358|HDSD00.11.361"
	
	s gCateID = $o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_gCate,""))
	//b ;gCateID
	q:(gCateID = "") ret_"^"_rdDiag
	
	s count = $L(gList,"^")
	for i = 1:1:count
	{
		s g = $p(gList,"^",i)
		continue:(g = "")
		continue:($l(g,"|") '= 2)
		
		s diag = $p(g, "|", 1)
		s cond = $p(g, "|", 2)
		
		s diagid = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_diag," "_gCateID,""))
		continue:(diagid = "")
		
		s condid = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_cond," "_gCateID,""))
		continue:(condid = "")
		s value1 = ##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryID(AEpisodeID,diagid)
		s:(value1 '= "") value1 = value1.GetNext("")
		//continue:($f(value1,"¸ÐÈ¾") = 0)
		//b ;value1
		continue:(value1 = "")||(value1 = "Null")
		
		s isRD = ##class(DHCMed.RDService.Service).CheckDiagnosTextToRD(AEpisodeID,value1)
		continue:(isRD = "0")

		
		s ret = "1"
		if (rdDiag = "") 
		{	s rdDiag = value1}
		else
		{	s rdDiag = rdDiag_","_value1}
		
		quit:(ANeedAllDiag = "0")
	}
	
	q ret_"^"_rdDiag
}

ClassMethod HasRDsXH(AEpisodeID As %String, ANeedAllDiag As %String = "1") As %String
{
	s ret = "0",rdDiag = ""
	
	s gCate = "HDSD00.11"
	
	//主要诊断、其他诊断01-15
	s gList = "HDSB05.10.056|HDSB05.10.058"
	s gList = gList_"^"_"HDSB05.10.059|HDSB05.10.505"
	s gList = gList_"^"_"HDSB05.10.506|HDSB05.10.508"
	s gList = gList_"^"_"HDSB05.10.510|HDSB05.10.512"
	s gList = gList_"^"_"HDSB05.10.514|HDSB05.10.516"
	s gList = gList_"^"_"HDSB05.10.518|HDSB05.10.520"
	s gList = gList_"^"_"HDSB05.10.522|HDSB05.10.524"
	s gList = gList_"^"_"HDSB05.10.526|HDSB05.10.528"
	s gList = gList_"^"_"HDSB05.10.530|HDSB05.10.532"
	s gList = gList_"^"_"HDSB05.10.534|HDSB05.10.536"
	s gList = gList_"^"_"HDSB05.10.538|HDSB05.10.540"
	s gList = gList_"^"_"HDSB05.10.542|HDSB05.10.544"
	s gList = gList_"^"_"HDSB05.10.546|HDSB05.10.548"
	s gList = gList_"^"_"HDSB05.10.550|HDSB05.10.552"
	s gList = gList_"^"_"HDSB05.10.554|HDSB05.10.556"
	s gList = gList_"^"_"HDSB05.10.558|HDSB05.10.560"
	
	s gCateID = $o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_gCate,""))
	//;b ;gCateID
	q:(gCateID = "") ret_"^"_rdDiag
	
	s count = $L(gList,"^")
	for i = 1:1:count
	{
		s g = $p(gList,"^",i)
		continue:(g = "")
		continue:($l(g,"|") '= 2)
		
		s diag = $p(g, "|", 1)
		s cond = $p(g, "|", 2)
		
		s diagid = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_diag,""))
		//s diagid = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_diag," "_gCateID,""))
		;b ;diagid
		continue:(diagid = "")
		
		s condid = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_cond,""))
		//s condid = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_cond," "_gCateID,""))
		continue:(condid = "")
		

		s value1 = ##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryID(AEpisodeID,diagid)
		s:(value1 '= "") value1 = value1.GetNext("")

		continue:(value1 = "")||(value1 = "Null")

		s isRD = ##class(DHCMed.RDService.Service).CheckDiagnosTextToRD(AEpisodeID,"^^"_value1)
		continue:(isRD = "0")

		s ret = 1
		if (rdDiag = "") 
		{	s rdDiag = value1}
		else
		{	s rdDiag = rdDiag_","_value1}
		
		quit:(ANeedAllDiag = "0")
	}
	
	q ret_"^"_rdDiag
}

}

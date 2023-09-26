/// 包装，对外提供服务
Class EPRservice.ASR.BOASRInterface Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "BOASRInterface";

ClassMethod GetEpisodeSetByPID(PID As %String) As %String [ WebMethod ]
{
	//s PID = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(PID)
	q:(PID="") ""
	set ret = ""
	set typeRowID = "0"
	for {
		set typeRowID = $o(^PAPERdr(PID,"ADM",typeRowID))
	 	q:(typeRowID = "")
	 	
	 	set episodeID = "0"
	 	for {
		 	s episodeID = $o(^PAPERdr(PID,"ADM",typeRowID,episodeID))
		 	q:(episodeID = "")
		 	s ret = ret_"^"_episodeID
		}
	}
	q $e(ret,2,$l(ret))
}

ClassMethod GetASREpisodeList(EpisodeID As %String, StDate As %String, EndDate As %String, AStartPage As %String, AEndPage As %String, APFlag As %String = "1") As EPRservice.dataset.EASREpisodeListDataSet [ WebMethod ]
{
	//s ^eprlwx("Start") = StDate
	//s ^eprlwx("End") = EndDate
	//<+> added on 2013-04-12 BY CYY, 处理默认非法默认日期，如 2012/1/1 为2012-1-1
	s StDate = $p(StDate, " ", 1)
	s StDate = $Tr(StDate, "/","-")
	s EndDate = $p(EndDate, " ", 1)
	s EndDate = $Tr(EndDate, "/","-")
	
	s result=##Class(EPRservice.dataset.EASREpisodeListDataSet).%New()
	d result.SetArgs(EpisodeID,StDate,EndDate,AStartPage,AEndPage,APFlag)
	q result
}

ClassMethod GetASResult(ASRowID As %String) As %String [ WebMethod ]
{
	q:(ASRowID="") ""
	s obj = ##Class(EPRinstance.ASR.ASREpisodeList).%OpenId(ASRowID)
	q obj.ResultText.Read(32000)
	q ""
}

ClassMethod CreateASREpisodeList(AEpisodeID As %String, ACurrPath As %String, AFileLST As %ArrayOfDataTypes) As %String [ WebMethod ]
{
	q:AEpisodeID="" "-1"
	
	s retValue = ""
	for fcnt = 0:1:AFileLST.Count()-1 {
		/*s ^lwx(fcnt) = AFileLST.GetAt(fcnt)
		s ^lwx(fcnt_"#1") = $p(AFileLST.GetAt(fcnt)," ",1)
		s ^lwx(fcnt_"#2") = $p(AFileLST.GetAt(fcnt)," ",2)
		s ^lwx(fcnt_"#3") = $p(AFileLST.GetAt(fcnt)," ",3)
		s ^lwx(fcnt_"#4") = $p(AFileLST.GetAt(fcnt)," ",4)*/
		//q:($g(AFileLST.GetAt(fcnt),"")="") 
		s fName = $p(AFileLST.GetAt(fcnt)," ",4)
		//s ^lwx("debug1") = "s1"
		s isExist = $o(^DHCEPRI.ASREpisodeListI("IdxFileName", " "_AEpisodeID, " "_$ZCVT(fName,"U"),""))
		//s ^lwx(fcnt) = isExist
		if ('isExist)
		{
			s objASREL = ##Class(EPRinstance.ASR.ASREpisodeList).%New()
			s objASREL.EpisodeID = AEpisodeID
			s objASREL.CreateDate = $zdh($p(AFileLST.GetAt(fcnt)," ",1),3)
			s objASREL.CreateTime = $zth($p(AFileLST.GetAt(fcnt)," ",2))
			s objASREL.FilePath = "/"_ACurrPath_"/"_fName
			s objASREL.FileName = fName
			s objASREL.Recognized = 0
			//s ^lwx(fcnt_"#write") = objASREL.ResultText.Write("")
			if (objASREL.%Save())
			{
				s retValue = retValue_"1"
			}
			k objASREL
		}
	}
	//s ^lwx("debug4") = retValue
	q retValue
}

/// d ##class(EPRservice.ASR.BOASRInterface).RecASRResult()
ClassMethod RecASRResult(ASRowID As %String, ARetTest As %String) As %String [ WebMethod ]
{
	q:(ASRowID="") "-1"
	s $ZTRAP = "TypeHandle"
	
	s obj = ##Class(EPRinstance.ASR.ASREpisodeList).%OpenId(ASRowID)
	s obj.Recognized = 1
	
	d obj.ResultText.Rewind()
	//try
	//{
		if $f(ARetTest.%ClassName(),"Stream")
		{
			d obj.ResultText.CopyFrom(ARetTest)
		}
		
	
	if '(obj.%Save()) { Quit "-1" }
	q "1"
	
TypeHandle
	d obj.ResultText.Write(ARetTest)
	if '(obj.%Save()) { Quit "-1" }
	q "1"
}

ClassMethod SetAliasName(ASRowID As %String, AliasName As %String) As %String [ WebMethod ]
{
	q:(ASRowID ="") "-1"
	s obj = ##Class(EPRinstance.ASR.ASREpisodeList).%OpenId(ASRowID)
	s obj.AliasName = AliasName
	if '(obj.%Save())
	{
		Quit "-1"
	}
	
	q "1"
}

ClassMethod GetPapmiNo(APatientID As %String) As %String [ WebMethod ]
{
	q:(($d(APatientID)=0)||(APatientID="")) ""
	q $P($g(^PAPER(APatientID,"PAT",1)),"^",1)
}

}

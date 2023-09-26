Class DHCEPRFS.ThirdParty.BL.BLGetURLCommon Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetURL(AEpisodeID As %String, ATypeCode As %String) As %String
{
	if (ATypeCode = "CG68")
	{
		//检查 //心电图
		s ret = ..GetRISURL(AEpisodeID)
		q ret
	}
	elseif (ATypeCode = "CG67")
	{
		//病理
		s ret = ..GetPISURL(AEpisodeID)
		q ret	
	}
	else
	{
		q ""	
	}
}

ClassMethod GetRISURL(AEpisodeID As %String) As %String
{
	s ss=##Class(RISService.InvokeRISService).GetRISWEBURLByPaadmdr(AEpisodeID)
	s ret = ss.Read()
	q ret
}

ClassMethod GetPISURL(AEpisodeID As %String) As %String
{
	//切换PIS名字空间
	s eprNameSpace = $ZUTIL(5)
	s pisNameSpace = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("PISNameSpace")  
	S pisNameSpace = $p($g(pisNameSpace),"^",1)
	s:(pisNameSpace="") pisNameSpace="PIS"
	
	d $ZUTIL(5,pisNameSpace)
    s ret=##Class(PISApp.PISService).GetRptrulByPaadmdr(AEpisodeID)
    d $ZUTIL(5,eprNameSpace)
	
	q ret
}

}

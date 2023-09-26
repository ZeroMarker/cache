Class DHCEPRFS.BL.HISInfo.BLPISInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:   是否有病理报告单需要打印
/// Debug:  w ##Class(DHCEPRFS.BL.HISInfo.BLPISInfo).HasPISToPrint("8477278")
ClassMethod HasPISToPrint(AEpisodeID) As %String
{
    s ret = ..GetPISPDFPath(AEpisodeID)   
    if (ret="") 
    {
	    q "0"
    }
    else
    {
        q "1"
    }
}

/// Desc:   获取病理PDF路径，多个路径以^分隔
/// Debug:  w ##Class(DHCEPRFS.BL.HISInfo.BLPISInfo).GetPISPDFPathOld("8477278")
ClassMethod GetPISPDFPathOld(AEpisodeID) As %String
{
    s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
    s ret = ""
    s pisNameSpace = "PIS"  //HIS8.4之前是PIS，8.4之后（包括8.4）是DHC-PIS
    s curNameSpace = $zu(5)
    zn pisNameSpace
    if ((hospitalFlag = ""))
    {
        s ret = ##class(Src.DHCPisTest).GetPdfInfoByPaadmdr(AEpisodeID)
        //s ret = ##class(Src.DHCPisInterface).ReportByAdmdrString(AEpisodeID)
    }
    else
    {
	    //d ##class(%ResultSet).RunQuery("Src.PIS3Interface","GetRptByAdm","8477278")
        Set rset = ##class(%ResultSet).%New("Src.PIS3Interface:GetRptByAdm")
        Set sc = rset.Execute(AEpisodeID)
        While (rset.Next()) {
            s file = rset.GetDataByName("filePath")  //rset.GetData(3),!        
            continue:(file="")||(file=$C(0))
            if (ret="") 
            {
	            s ret=file
            }
            else
            {
	            s ret = ret_"^"_file
	        }
        }
    }
    zn curNameSpace
    q ret
}

/// Desc: 2023-02-10 yangshun 标板提供的获取病历报告的方法
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLPISInfo).GetPISPDFPath("")
ClassMethod GetPISPDFPath(AEpisodeID) As %String
{
	s retStr = ##class(PISService.API.DHCPISReport).GetReportInfoByAdmNoToEMR(AEpisodeID)
	s len = $L(retStr,"^")
	s ret = ""
	for i=1:1:len
	{
		s str = $P(retStr,"^",i)
		if (str'="")
		{
			if (ret="")
			{
				s ret = str
			}
			else
			{
				s ret = ret_"^"_str
			}
		}
	}
	q ret
}

}

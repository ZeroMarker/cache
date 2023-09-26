Class DHCEPRFS.BL.HISInfo.BLCPWInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	获取临床路径报告ID
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLCPWInfo).GetPathWayID("3941487")
ClassMethod GetPathWayIDOld(AEpisodeID As %String) As %String
{
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	//HIS 8.3后新增的类方法，有效则执行，无效则采用老方法
	s validFlag = ##class(websys.Conversions).IsValidMethodName("DHCMA.CPW.IO.ToDoc","GetCPWInfoByAdm")
	
	if (validFlag){
		s pathWayStatus = ##class(DHCMA.CPW.IO.ToDoc).GetCPWInfoByAdm(AEpisodeID)
		q:(pathWayStatus="") ""
		if (hospitalFlag="QZSDSYY") //兼容衢州市第三医院项目 采用第五个位置获取ID
		{
			s pathWayID = $p(pathWayStatus,$c(1),5)
			s ret = pathWayID
		}
		else{
			s CPWStatus = $p(pathWayStatus,$c(1),4)
			s ret = $S(CPWStatus="入径":1,CPWStatus="出径":2,CPWStatus="完成":3,1:"")
		}
	}
	else
	{
		s pathWayStatus = ##Class(web.DHCCPW.MR.Interface).GetPathWayStatus(AEpisodeID)
		q:(pathWayStatus="") ""
	
		s pathWayID = $p(pathWayStatus,$c(1),1)
		s ret = pathWayID
	}
	q ret
}

/// Desc: 2023-2-10 yangshun 标板提供的临床路径判断方法
ClassMethod GetPathWayID(AEpisodeID As %String) As %String
{
	s ret = ""
	s flag = ##class(DHCMA.CPW.CPS.InterfaceSrv).GetCPWStatus(AEpisodeID)
	s:((flag="I")||(flag="O")||(flag="C")) ret = "1"
	q ret
}

}

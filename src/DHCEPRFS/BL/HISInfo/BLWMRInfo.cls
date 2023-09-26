Class DHCEPRFS.BL.HISInfo.BLWMRInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	进行病案回收,第二个参数通过下面的sql查询到回收对应的ID，第四个参数UserID不能为空
/// select * from DHCWMR_SS.WorkFItem where WFISysOpera='RC'
ClassMethod OperationByEpisodeID(AEpisodeID As %String, AUserID As %String) As %String
{
	//3.0版
	//s ret = ##class(DHCWMR.SSService.OperationSrv).OperationByEpisodeID(AEpisodeID,"1||2","","1")
	
	//4.0版
	//s ret = ##class(DHCWMR.IO.OutService).OperByEpisodeID(AEpisodeID,"RC",AUserID)
	q ret
}

/// 已归档(电子病历不能修改)返回1;
/// 未归档(电子病历可以修改)返回0;
/// 其他返回负值
/// debug: w ##class(DHCEPRFS.BL.HISInfo.BLWMRInfo).GetMRAchiveStatus(15119600)	
ClassMethod GetMRAchiveStatus(AEpisodeID As %String)
{
	try
	{
		s ret = "0"
		s ret = ##class(DHCWMR.IO.ToHistorySrv).IGetMrArchiveStatus(AEpisodeID)	
	}
	catch
	{
		w " ##class(DHCWMR.IO.ToHistorySrv).IGetMrArchiveStatus("_AEpisodeID_")  error!!",!
		s ret = "1"	
	}
	q ret
}

/// Desc:	更新病案流转状态 
ClassMethod UpdateStatus(EpisodeID As %String, ItemDr As %String, UserID As %String, sDtlList As %String) As %String
{
	s sc = ##Class(web.DHCWMRService).IUpdateStatusOfMR(EpisodeID, ItemDr, UserID, sDtlList)
	q sc
}

ClassMethod GetAllDiag(AEpisodeID As %String) As %String
{
	s retArray = ##Class(%ArrayOfDataTypes).%New()
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterfaceList).getFrontPageICDList(AEpisodeID,"D")
	
	s OutCount = 0,  AdmCount = 0, PharCount = 0, InjuryCount = 0, InfectCount = 0, OtherCount = 0
	s DiagCount = $l(Diagnose,$C(1))
	for i=1:1:DiagCount
	{
		s CurDiag = $P(Diagnose,$C(1),i)
		s DiagType = $P(CurDiag,$C(2),4)
		if (DiagType = "门诊诊断")
		{
			s value = CurDiag
			s OutCount = OutCount + 1			
			d retArray.SetAt(value, "OUT"_OutCount)
		}
		elseif (DiagType = "入院诊断")
		{
			s value = CurDiag
			s AdmCount = AdmCount + 1
			d retArray.SetAt(value, "ADM"_AdmCount)
		}
		elseif (DiagType = "4")
		{
			s value = CurDiag
			s PharCount = PharCount + 1
			d retArray.SetAt(value, "Phar"_PharCount)
		}
		elseif (DiagType = "5")
		{
			s value = CurDiag
			s InjuryCount = InjuryCount + 1
			d retArray.SetAt(value, "Inj"_InjuryCount)
			}
		elseif (DiagType = "3")
		{
			s value = CurDiag
			s InfectCount = InfectCount + 1
			d retArray.SetAt(value, "Inf"_InfectCount)
			}
		elseif (DiagType = "1")
		{
			s value = CurDiag
			d retArray.SetAt(value, "Main")
			}
		elseif (DiagType = "2")
		{
			s value = CurDiag
			s OtherCount = OtherCount + 1
			d retArray.SetAt(value, "Other"_OtherCount)
			}		
	}
	q retValue
}

ClassMethod GetAllOper(AEpisodeID As %String) As %String
{
	q:(AEpisodeID="") ""
	s retArray = ##Class(%ArrayOfDataTypes).%New()
	s Operation = ##Class(web.DHCWMRCodingInterfaceList).getFrontPageICDList(AEpisodeID,"O/1")
	
	s OperCount = 0
	s OperationCount = $l(Operation,$C(1))
	for i=1:1:OperationCount
	{
		s CurOper = $P(Operation,$C(1),i)
		s value = CurOper
		s OperCount = OperCount + 1			
		d retArray.SetAt(value, "Oper"_OperCount)
			
	}	
	q retValue
}

ClassMethod GetAllMani(AEpisodeID As %String) As %String
{
	q:(AEpisodeID="") ""
	s retArray = ##Class(%ArrayOfDataTypes).%New()
	s Manipulate = ##Class(web.DHCWMRCodingInterfaceList).getFrontPageICDList(AEpisodeID,"O/2")
	
	s OperCount = 0
	s ManiCount = $l(Manipulate,$C(1))
	for i=1:1:ManiCount
	{
		s CurOper = $P(Manipulate,$C(1),i)
		s value = CurOper
		s OperCount = OperCount + 1			
		d retArray.SetAt(value, "Oper"_OperCount)
			
	}	
	q retValue
}

/// 获取状态接口
/// debug: w ##class(DHCEPRFS.BL.HISInfo.BLWMRInfo).GetMrStatusString(7958391)
ClassMethod GetMrStatusString(Paadm As %String) As %String
{
	//s ret = ##Class(web.DHCWMRService).GetMrStatusString(Paadm)	
	s ret = ##class(DHCWMR.IO.ToHistorySrv).GetMrStatusString(Paadm)

	q ret
}

/// 获取最后状态接口
/// debug: w ##class(DHCEPRFS.BL.HISInfo.BLWMRInfo).GetLastMrStatus(7958391)
ClassMethod GetLastMrStatus(Paadm As %String) As %String
{
	s ret = ..GetMrStatusString(Paadm)
	s length = $l(ret,$c(1))
	q $p(ret,$c(1),length)
}

/// CreatDate：  2014-09-04
/// Service User:电子病历组
/// Description：通过病案号取就诊号
/// Table：      
/// Input：      MrNO：病案号 MrType:病案类型(住院病案：7，门诊病案：6 ，急诊病案：101)
/// Debug: 		 w ##class(DHCEPRFS.BL.HISInfo.BLWMRInfo).IGetEpisodeIDsByMrNo("90541902","7")
/// Return：     episodeID string
ClassMethod IGetEpisodeIDsByMrNo(aMrNo As %String, aMrType As %String) As %String
{
	s ret = ""
	//s episodeList = ##class(web.DHCWMRService).IGetEpisodeIDsByMrNo(aMrNo,aMrType,"")
	s episodeList = ##class(DHCWMR.IO.ToHistorySrv).IGetEpisodeIDsByMrNo(aMrNo,aMrType,"")
	if (($p(episodeList,":",1) '= "-2") && ($p(episodeList,":",1) '= "-1"))
	{
		for index=1:1:$listlength(episodeList)
		{
			if (ret = "")
			{
				s ret = $list(episodeList,index)	
			}
			else
			{
				s ret = ret_"^"_$list(episodeList,index)	
			}
		}
	}
	q ret
}

/// Debug: 		 w ##class(DHCEPRFS.BL.HISInfo.BLWMRInfo).IGetEpisodeIDsByMrNoAllString("90541902")
ClassMethod IGetEpisodeIDsByMrNoAllString(AMedRecordNo As %String)
{
	s ret = ""
	s in = ..IGetEpisodeIDsByMrNo(AMedRecordNo,"7")
	s:((in '= "") && ($p(in,":",1) '= "-2") && ($p(in,":",1) '= "-1")) ret = in
	
	s out = ..IGetEpisodeIDsByMrNo(AMedRecordNo,"6")
	if ((out '="") && ($p(out,":",1) '= "-2") && ($p(out,":",1) '= "-1"))
	{
		if (ret = "")
		{
			s ret = out
		}	
		else
		{
			s ret = ret_"^"_out	
		}
	}
	
	s e = ..IGetEpisodeIDsByMrNo(AMedRecordNo,"101")
	if ((e '="") && ($p(e,":",1) '= "-2") && ($p(e,":",1) '= "-1"))
	{
		if (ret = "")
		{
			s ret = e
		}	
		else
		{
			s ret = ret_"^"_e	
		}
	}
	
	q ret
}

}

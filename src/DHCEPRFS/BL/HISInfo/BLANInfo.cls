Class DHCEPRFS.BL.HISInfo.BLANInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	是否有麻醉记录单需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasANToPrint("16657261")
ClassMethod HasANToPrint(AEpisodeID) As %String
{
    s ret = ..GetANPDFPath(AEpisodeID)
    q:(ret '= "") "1"
    q "0"
}

/// Desc:	获取麻醉记录单PDF路径
/// Debug:  w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetANPDFPath("16657261")
ClassMethod GetANPDFPath(AEpisodeID As %String) As %String
{
	s ret = ""
    s ret = ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,"")
    s ret = $replace(ret,$c(0),"^")
	q ret
}

/// Desc:	是否有手术清点单需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasOPCountToPrint("5366809")
ClassMethod HasOPCountToPrint(AEpisodeID) As %String
{
	 s ret = ..GetOperCountPath(AEpisodeID)
     q:(ret '= "") "1"
     q "0"
}

/// Desc:	获取手术清点单PDF路径
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetOperCountPath("1160568")
ClassMethod GetOperCountPath(AEpisodeID As %String) As %String
{
	s ret = ""
    s ret = ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,"")
    s ret = $replace(ret,$c(0),"^")
	q ret
}

/// Desc:	是否有手术术前访视记录需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasPREToPrint("16657261")
ClassMethod HasPREToPrint(AEpisodeID) As %String
{
	s result = ..GetPREPDFPath(AEpisodeID)
    q:(result '= "") "1"  
	q "0"
}

/// Desc:	获取手术术前访视PDF路径
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetPREPDFPath("1160568")
ClassMethod GetPREPDFPath(AEpisodeID As %String) As %String
{
	s ret = ""
    s ret = ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,"")
    s ret = $replace(ret,$c(0),"^")
	q ret
}

/// Desc:	是否有手术术后访视记录需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasPOSTToPrint("16657261")
ClassMethod HasPOSTToPrint(AEpisodeID) As %String
{
	s result = ..GetANPDFPath(AEpisodeID)
    q:(result '= "") "1"  
	q "0"
}

/// Desc:	获取手术术后访视PDF路径
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetPOSTPDFPath("1160568")
ClassMethod GetPOSTPDFPath(AEpisodeID As %String) As %String
{
	s ret = ""
    s ret = ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,"")
    s ret = $replace(ret,$c(0),"^")
	q ret
}

/// Desc:	是否有麻醉前访视需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasPrevVisitToPrint("7549040")
ClassMethod HasPrevVisitToPrint(AEpisodeID) As %String
{
	s result = ..GetPrevVisitPath(AEpisodeID)
    q:(result '= "") "1"  
	q "0"
}

/// Desc:	获取麻醉前访视PDF路径
/// Debug:  w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetPrevVisitPath("16657261")
ClassMethod GetPrevVisitPath(AEpisodeID As %String) As %String
{
	s ret = ""
    s ret = ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,"")
    s ret = $replace(ret,$c(0),"^")
	q ret
}

/// Desc:	是否有麻醉后访视需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasPostVisitToPrint("7549040")
ClassMethod HasPostVisitToPrint(AEpisodeID) As %String
{
	s result = ..GetPOSTPDFPath(AEpisodeID)
    q:(result '= "") "1"  
	q "0"
}

/// Desc:   获取麻醉后访视PDF路径
/// Debug:  w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetPostVisitPath("16657261")
ClassMethod GetPostVisitPath(AEpisodeID) As %String
{
	s ret = ""
    s ret = ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,"")
    s ret = $replace(ret,$c(0),"^")
	q ret
}

/// Desc:	是否有手术安全核查表需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasOPSPDFToPrint("7549040")
ClassMethod HasOPSPDFToPrint(AEpisodeID) As %String
{
	s result = ..GetOPSPDFPath(AEpisodeID)
    q:(result '= "") "1"  
	q "0"
}

/// Desc:	获取手术安全核查表PDF路径
/// Debug:  w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetOPSPDFPath("16657261")
ClassMethod GetOPSPDFPath(AEpisodeID As %String) As %String
{
	s ret = ""
    s ret = ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,"")
    s ret = $replace(ret,$c(0),"^")
	q ret
}

/// Desc:	是否CHA手术风险评估需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasCHARecordToPrint("7549040")
ClassMethod HasCHARecordToPrint(AEpisodeID) As %String
{
	s result = ..GetCHARecordPath(AEpisodeID)
    q:(result '= "") "1"  
	q "0"
}

/// Desc:	获取CHA手术风险评估PDF路径
/// Debug:  w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetCHARecordPath("16657261")
ClassMethod GetCHARecordPath(AEpisodeID As %String) As %String
{
	s ret = ""
    s ret = ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,"")
    s ret = $replace(ret,$c(0),"^")
	q ret
}

/// Desc:	是否有手术护理记录单需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasANHLToPrint("7549040")
ClassMethod HasANHLToPrint(AEpisodeID) As %String
{
	s result = ..GetANHLPath(AEpisodeID)
    q:(result '= "") "1"  
	q "0"
}

/// Desc:	获取手术护理记录单PDF路径
/// Debug:  w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetANHLPath("16657261")
ClassMethod GetANHLPath(AEpisodeID As %String) As %String
{
	s ret = ""
    s ret = ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,"")
    s ret = $replace(ret,$c(0),"^")
	q ret
}

/// Desc:	是否有恢复室记录单需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasPACUToPrint("7549040")
ClassMethod HasPACUToPrint(AEpisodeID) As %String
{
	s ret = ..GetPACUPath(AEpisodeID)
    q:(ret '= "") "1"
    q "0"
}

/// Desc:	获取恢复室记录单PDF路径
/// Debug:  w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetPACUPath("16657261")
ClassMethod GetPACUPath(AEpisodeID As %String) As %String
{
	s ret = ""
    s ret = ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,"")
    s ret = $replace(ret,$c(0),"^")
	q ret
}

/// Desc:	是否有重症监护护理单需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasICUToPrint("7549040")
ClassMethod HasICUToPrint(AEpisodeID) As %String
{
	s result = ..GetICUPDFPath(AEpisodeID)
	q:(result '= "") "1"  
	q "0"
}

/// Desc:	获取重症监护单PDF路径
/// Debug:  w ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetICUPDFPath("16657261")
ClassMethod GetICUPDFPath(AEpisodeID As %String) As %String
{
	s ret = ""
    s ret = ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,"")
    s ret = $replace(ret,$c(0),"^")
	q ret
}

// 以下为2023-2-12 标板新增的手麻、重症的判断方法

/// w ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,"类别")
/// 类别：术前访视记录单、术后访视记录单、麻醉记录单、恢复室记录单、手术清点单、手术安全核查表、CHA手术风险评估、重症监护记录单
/// 类别代码对照：/// 对应CT_AN.DataModule表内ArchiveCode字段
/// 麻醉记录单：
Parameter MZJLD = "AnaestRecord";

/// 手术清点单：
Parameter SSQDD = "OperCount";

/// 术前访视：
Parameter SSSQFS = "OperVisit";

/// 麻醉前访视：
Parameter MZQFS = "PrevANVisit";

/// 麻醉后访视：
Parameter MZHFS = "PostANVisit";

/// 手术风险评估：
Parameter SSFXPG = "OperRiskAssessment";

/// 手术安全核查：
Parameter SSAQHC = "OperSafetyCheck";

/// 恢复室记录单：
Parameter HFSJLD = "PACUNurseRecord";

/// 重症监护单类别代码
Parameter ZZJHD = "DHCICU";

/// 获取麻醉记录单路径
ClassMethod GetAnaestRecordPathNew(AEpisodeID As %String) As %String
{
	q ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,..#MZJLD)
}

/// 麻醉记录是否打印
ClassMethod HasAnaestRecordToPrintNew(AEpisodeID As %String) As %String
{
	s ret = ..GetAnaestRecordPathNew(AEpisodeID)
	q:(ret '= "") "1"
    q "0"
}

/// 获取手术清点单路径
ClassMethod GetOPCountPathNew(AEpisodeID As %String) As %String
{
	q ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,..#SSQDD)
}

/// 手术清点单是否打印
ClassMethod HasOPCountToPrintNew(AEpisodeID As %String) As %String
{
	s ret = ..GetOPCountPathNew(AEpisodeID)
	q:(ret '= "") "1"
    q "0"
}

/// 获取术前访视路径
ClassMethod GetPREPDFPathNew(AEpisodeID As %String) As %String
{
	q ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,..#SSSQFS)
}

/// 术前访视是否打印
ClassMethod HasPREToPrintNew(AEpisodeID As %String) As %String
{
	s ret = ..GetPREPDFPathNew(AEpisodeID)
	q:(ret '= "") "1"
    q "0"
}

/// 获取麻醉前访视路径
ClassMethod GetPrevVisitPDFPathNew(AEpisodeID As %String) As %String
{
	q ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,..#MZQFS)
}

/// 麻醉前访视是否打印
ClassMethod HasPrevVisitToPrintNew(AEpisodeID As %String) As %String
{
	s ret = ..GetPrevVisitPDFPathNew(AEpisodeID)
	q:(ret '= "") "1"
    q "0"
}

/// 获取麻醉后访视路径
ClassMethod GetPostANVisitPathNew(AEpisodeID As %String) As %String
{
	q ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,..#MZHFS)
}

/// 麻醉后访视是否打印
ClassMethod HasPostANVisitToPrintNew(AEpisodeID As %String) As %String
{
	s ret = ..GetPostANVisitPathNew(AEpisodeID)
	q:(ret '= "") "1"
    q "0"
}

/// 获取手术风险评估路径
ClassMethod GetOperRiskAssessmentPathNew(AEpisodeID As %String) As %String
{
	q ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,..#SSFXPG)
}

/// 手术风险评估是否打印
ClassMethod HasOperRiskAssessmentToPrintNew(AEpisodeID As %String) As %String
{
	s ret = ..GetOperRiskAssessmentPathNew(AEpisodeID)
	q:(ret '= "") "1"
    q "0"
}

/// 获取手术安全核查路径
ClassMethod GetOperSafetyCheckPathNew(AEpisodeID As %String) As %String
{
	q ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,..#SSAQHC)
}

/// 手术安全核查是否打印
ClassMethod HasOperSafetyCheckToPrintNew(AEpisodeID As %String) As %String
{
	s ret = ..GetOperSafetyCheckPathNew(AEpisodeID)
	q:(ret '= "") "1"
    q "0"
}

/// 获取恢复室记录单路径
ClassMethod GetPACUNurseRecordPathNew(AEpisodeID As %String) As %String
{
	q ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,..#HFSJLD)
}

/// 恢复室记录单是否打印
ClassMethod HasPACUNurseRecordToPrintNew(AEpisodeID As %String) As %String
{
	s ret = ..GetPACUNurseRecordPathNew(AEpisodeID)
	q:(ret '= "") "1"
    q "0"
}

/// 获取重症监护单路径
ClassMethod GetDHCICUPathNew(AEpisodeID As %String) As %String
{
	q ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm(AEpisodeID,..#ZZJHD)
}

/// 重症监护单是否打印
ClassMethod HasDHCICUToPrintNew(AEpisodeID As %String) As %String
{
	s ret = ..GetDHCICUPathNew(AEpisodeID)
	q:(ret '= "") "1"
    q "0"
}

}

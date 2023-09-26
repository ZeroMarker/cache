/// web.QseService
Class web.QseService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "QseService";

//Parameter LOCATION = "http://192.168.1.101/trakcare/trak/web";

/// http://192.168.1.101/trakcare/trak/web/web.QseService.cls
/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/clinc";

/// TODO: add arguments and implementation.
/// Test
ClassMethod Test() As %String [ WebMethod ]
{
	Quit "Test"
}

ClassMethod GetCurrAdm(RegNo As %String) As %String [ WebMethod ]
{
	s Adm=##class(web.DHCNURPDAQUEXCUTE).GetCurrAdm(RegNo)
    s Ret=""
	if Adm'="" {
		s str=##class(web.DHCPdaComm).NurPatInfo(Adm)
		s Ret=Adm_"$"_str
		}
	q Ret
}

ClassMethod GetObserItm(Grp As %String) As %String [ WebMethod ]
{
	s Ret=##class(web.DHCPdaComm).GetObservationItm(Grp)
	q Ret
}

ClassMethod GetOldReqNo(disprow As %String) As %String [ WebMethod ]
{
	//s ^TMP(0)=disprow            GetOldReqno
	s ret=##class(web.DHCPdaPhReq).GetOldReqno(disprow)
	q ret
}

ClassMethod PhReqInsertDetail(data As %String) As %String [ WebMethod ]
{
	s ret=##class(web.DHCPdaPhReq).InsDetail2(data)
	q ret
}

ClassMethod PhReqUpdateQty(Rw As %String, Qty As %String, User As %String) As %String [ WebMethod ]
{
	s ret=##class(web.DHCPdaPhReq).UpdateQty(Rw,Qty,User)
	q ret
}

ClassMethod ReqChangeStat(Rw As %String, Stat As %String, User As %String) As %String [ WebMethod ]
{
	s ret=##class(web.DHCPdaPhReq).ChangeStat(Rw,Stat,User)
	q ret
}

ClassMethod GetMaxRetReqNo() As %String [ WebMethod ]
{
	s ret=##class(web.DHCPdaPhReq).GetMaxRetReqNo()
	q ret
}

ClassMethod ExcuteOrd(Parr As %String) As %String [ WebMethod ]
{
	//s ^TMP(0)=Parr
	s ln=$L(Parr,"!")
	//s ^TMP(0)=$H
	for i=1:1:ln
	{
		s paritem=$P(Parr,"!",i)
	   if paritem'="" s ret=##class(web.DHCPdaNurComm).UpdateExecStat(paritem)
	}
	//s ret=""
	//s ^TMP(1)=$H
	q ret
}

ClassMethod SetDisconOrd(OrdRow As %String, User As %String) As %String [ WebMethod ]
{
	s ln=$L(OrdRow,"!")
	//s ^TMP(0)=$H
	for i=1:1:ln
	{
     s Orw=$P(OrdRow,"!",i)
  s oeorirow=$P(OrdRow,"||",1)_"||"_$P(OrdRow,"||",2)
	 s ret=##class(web.DHCPdaNurComm).SetDisconOrder(oeorirow,User)
	}
	q ret
}

ClassMethod UndoDisconOrd(OrdRow As %String, User As %String) As %String [ WebMethod ]
{
	s ln=$L(OrdRow,"!")
	//s ^TMP(0)=$H
	for i=1:1:ln
	{
     s Orw=$P(OrdRow,"!",i)
	 s ret=##class(web.DHCPdaNurComm).UndoDisconOrder(Orw,User)
	}
	q ret
}

ClassMethod UnExcute(oeoriId As %String, arcicId As %String, oecprDesc As %String, userId As %String) As %String [ WebMethod ]
{
	s ln=$L(oeoriId,"!")
	s ^TMP(1)=oeoriId
	for i=1:1:ln-1
	{
     s Orw=$P(oeoriId,"!",i)
     s ^TMP(2)=Orw
	 s ret=##class(web.DHCPdaNurComm).UndoUpdateExecStat(Orw, arcicId, oecprDesc, userId)
	}
	q ret
}

ClassMethod GetDataOrdItem(WardLoc As %String, Adm As %String, Excute As %String, UnExcute As %String, scroll As %String, UserId As %String, VarTyp) As %String [ WebMethod ]
{
 //New result
  if Adm'="0" s Adm=##class(web.DHCNURPDAQUEXCUTE).GetCurrAdm(Adm)
  if (WardLoc="")&(Adm="") q -1
  //s VarTyp="CQSYD"
  if VarTyp="-1" s VarTyp=""

  s ^TMP2=$LB(WardLoc,Adm ,Excute,UnExcute,scroll,UserId,VarTyp)
  //if VarTyp'="-1" {
 // s RetStr=##class(web.DHCNURPDAExcuteQuery).GetOrdData(WardLoc,Adm ,Excute,UnExcute,scroll,UserId,VarTyp)
 // }else{
  s RetStr=##class(web.DHCNURPDAQUEXCUTE).GetOrdData(WardLoc,Adm ,Excute,UnExcute,scroll,UserId,VarTyp)
  //}
  //s ret=##class(web.DHCPdaComm).GetOrdColor() // s ^TMP(0)=RetStr
 // Do result.SetArgs(WardLoc,Adm,Excute,UnExcute,scroll,UserId)
 q RetStr
}

ClassMethod GetPhReqData(StDate As %String, EndDate As %String, RequestNo As %String, Ward As %String, Status As %String) As %String [ WebMethod ]
{
 //New result
  s StDate=$ZDH(StDate,3)
  s EndDate=$ZDH(EndDate,3)
 //s ^TMP2=$LB(StDate, EndDate , RequestNo, Ward , Status)
  // q "sdfsdf"
  s RetStr=##class(web.DHCNURPDAQUEXCUTE).GetPhReqData(StDate, EndDate , RequestNo, Ward , Status)
  //s ret=##class(web.DHCPdaComm).GetOrdColor() // s ^TMP(0)=RetStr
 // Do result.SetArgs(WardLoc,Adm,Excute,UnExcute,scroll,UserId)
 q RetStr
}

//ClassMethod GetReqDrug(StDate As %String, EndDate As %String, RequestNo As %String, Ward As %String, Status As %String) As web.PdaReqDrugNo [ WebMethod ]

//{

//New result

// s result=##class(web.PdaReqDrugNo).%New()

// s StDate=$ZDH(StDate,3)

// s EndDate=$ZDH(EndDate,3)

// s ^TMP1=$LB(StDate, EndDate , RequestNo, Ward , Status)

// Do result.SetArgs(StDate, EndDate , RequestNo, Ward , Status)

// q result

//}

//ClassMethod GetOrdItem(StDateStr As %String, EDateStr As %String, Adm As %String, OECCat As %String, longord As %String, lsord As %String, Excute As %String, UnExcute As %String, scroll As %String) As web.PDAOrdData [ WebMethod ]

//{

//New result

// s result=##class(web.PDAOrdData).%New()

// s StDateStr=$ZDH(StDateStr,4)

// s EDateStr=$ZDH(EDateStr,4)

// s OECCat=""

//s ^TMP1=$LB(StDateStr, EDateStr, Adm , OECCat, longord , lsord, Excute , UnExcute , scroll)

// Do result.SetArgs(StDateStr, EDateStr, Adm , OECCat, longord , lsord, Excute , UnExcute , scroll)

// q result

//}

//ClassMethod GetOrcat() As web.PdaOrdCat [ WebMethod ]

//{

//New result

// s result=##class(web.PdaOrdCat).%New()

// Do result.SetArgs()

// q result

//}

//ClassMethod GetPrior() As web.PdaQueryPrior [ WebMethod ]

//{

//New result

// s result=##class(web.PdaQueryPrior).%New()

//Do result.SetArgs()

// q result/

//}

//ClassMethod GetLogonLoc(UserId As %String) As web.PDALOGONLOC [ WebMethod ]

//{

//New result

// s result=##class(web.PDALOGONLOC).%New()

//Do result.SetArgs(UserId)

//q result

//}

//ClassMethod GetMeth() As web.PdaQueryInstr [ WebMethod ]

//{

//New result

//s result=##class(web.PdaQueryInstr).%New()

//Do result.SetArgs()

//q result

//}

//ClassMethod GetPhcInstr() As web.PdaQueryInstr [ WebMethod ]

//{

//New result

// s result=##class(web.PdaQueryInstr).%New()

//Do result.SetArgs()

//q result

//}

//ClassMethod GetOrdStat() As web.PdaQueryOrdStat [ WebMethod ]

//{

//New result

// s result=##class(web.PdaQueryOrdStat).%New()

//Do result.SetArgs()

//q result

//}

//ClassMethod GetTimePoint() As web.PDATHREETIME [ WebMethod ]

//{

//New result

//s result=##class(web.PDATHREETIME).%New()

//Do result.SetArgs()

//q result

//}

ClassMethod GetObserData(Adm As %String, CDate As %String, CTime As %String, Grp As %String) As %String [ WebMethod ]
{
 //New result  GetObserData
 s ^TMP(0)=$LB(Adm,CDate,CTime,Grp)
 s CDate=$ZDH(CDate,3)
 if CTime'="" s CTime=$ZTH(CTime,3)
 e  s CTime=$P($H,",",2)
 s result=##class(web.DHCNURPDAQUEXCUTE).GetObserData(Adm, CDate, CTime,Grp)
 q result
}

//ClassMethod GetThreeData(Adm As %String, CDate As %String, CTime As %String) As web.PDATHREEDATA [ WebMethod ]

//{

//New result

// s CDate=$ZDH(CDate,4)

//s CTime=$ZTH(CTime,3)

//s result=##class(web.PDATHREEDATA).%New()

//Do result.SetArgs(Adm, CDate, CTime)

//q result

//}

ClassMethod GetUserId(UserCode As %String, Pin As %String) As %String [ WebMethod ]
{
	
	s ret=##class(web.DHCPdaNurComm).Logon( UserCode,Pin)
	q ret
}

ClassMethod GetCodeData(UserId As %String, GrpCode As %String) As %String [ WebMethod ]
{
	s querytyp=##class(web.DHCNURPDAQUEXCUTE).GetQueryTyp(GrpCode,UserId)
	s ret=##class(web.DHCNURPDAQUEXCUTE).GetCodeData(UserId)
	//s ^TMP(0)=ret
	q ret_"%"_querytyp
}

ClassMethod GetLogonCtLoc(UserId As %String) As %String [ WebMethod ]
{
	//q "OStat_rowid:1|OStat_Desc:核实|Sel:|OStat_rowid:3|OStat_Desc:On Hold|Sel:|OStat_rowid:4|OStat_Desc:停止|Sel:|OStat_rowid:5|OStat_Desc:Pre-Order|Sel:|OStat_rowid:6|OStat_Desc:执行|Sel:|OStat_rowid:7|OStat_Desc:In Queue|Sel:|OStat_rowid:8|OStat_Desc:Post-Operation Order|Sel:|OStat_rowid:9|OStat_Desc:Postponed|Sel:|OStat_rowid:11|OStat_Desc:未激活|Sel:|OStat_rowid:12|OStat_Desc:In Progress|Sel:|"
	s ret=##class(web.DHCNURPDAQUEXCUTE).Getlogonctloc(UserId)
	//s ^TMP(0)=ret
	q ret
}

ClassMethod GetReasonNotAvail(QueryName As %String) As %String [ WebMethod ]
{
	//q "OStat_rowid:1|OStat_Desc:核实|Sel:|OStat_rowid:3|OStat_Desc:On Hold|Sel:|OStat_rowid:4|OStat_Desc:停止|Sel:|OStat_rowid:5|OStat_Desc:Pre-Order|Sel:|OStat_rowid:6|OStat_Desc:执行|Sel:|OStat_rowid:7|OStat_Desc:In Queue|Sel:|OStat_rowid:8|OStat_Desc:Post-Operation Order|Sel:|OStat_rowid:9|OStat_Desc:Postponed|Sel:|OStat_rowid:11|OStat_Desc:未激活|Sel:|OStat_rowid:12|OStat_Desc:In Progress|Sel:|"
	
	s ^TMP(0)=QueryName	 //s retStr=..GetQueryData("web.DHCPDABEDMANAGE:GetOrcat",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetPhcin",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetOecpr",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetOrdStat",user)_"$"_..GetSchCond(user)
    s ret=##class(web.DHCNURPDAQUEXCUTE).GetQueryData(QueryName,"")

	q ret
}

ClassMethod GetQueryData(QueryName As %String, Par1 As %String) As %String [ WebMethod ]
{
	//q "OStat_rowid:1|OStat_Desc:核实|Sel:|OStat_rowid:3|OStat_Desc:On Hold|Sel:|OStat_rowid:4|OStat_Desc:停止|Sel:|OStat_rowid:5|OStat_Desc:Pre-Order|Sel:|OStat_rowid:6|OStat_Desc:执行|Sel:|OStat_rowid:7|OStat_Desc:In Queue|Sel:|OStat_rowid:8|OStat_Desc:Post-Operation Order|Sel:|OStat_rowid:9|OStat_Desc:Postponed|Sel:|OStat_rowid:11|OStat_Desc:未激活|Sel:|OStat_rowid:12|OStat_Desc:In Progress|Sel:|"
	s ^TMP(0)=$LB(QueryName,Par1)
	if Par1="0" s Par1=""
		 //s retStr=..GetQueryData("web.DHCPDABEDMANAGE:GetOrcat",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetPhcin",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetOecpr",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetOrdStat",user)_"$"_..GetSchCond(user)
    s ret=##class(web.DHCNURPDAQUEXCUTE).GetQueryData(QueryName,Par1)
 	q ret
}

ClassMethod SetSchCon(Parr As %String, UserId As %String) As %String [ WebMethod ]
{
	//q "OStat_rowid:1|OStat_Desc:核实|Sel:|OStat_rowid:3|OStat_Desc:On Hold|Sel:|OStat_rowid:4|OStat_Desc:停止|Sel:|OStat_rowid:5|OStat_Desc:Pre-Order|Sel:|OStat_rowid:6|OStat_Desc:执行|Sel:|OStat_rowid:7|OStat_Desc:In Queue|Sel:|OStat_rowid:8|OStat_Desc:Post-Operation Order|Sel:|OStat_rowid:9|OStat_Desc:Postponed|Sel:|OStat_rowid:11|OStat_Desc:未激活|Sel:|OStat_rowid:12|OStat_Desc:In Progress|Sel:|"
	s ret=##class(web.DHCNURPDAQUEXCUTE).SetSchCond(Parr,UserId)
	//s ^TMP(0)=ret
	q ret
}

//ClassMethod GetWardBed(Loc As %String) As web.QPdaWardBed [ WebMethod ]

//{

//s result=##class(web.QPdaWardBed).%New()

//Do result.SetArgs(Loc)

//q result

//}

ClassMethod InsertData(datastr As %String, Grp As %String = "-1") As %String [ WebMethod ]
{
	s ln=$L(datastr,"|")
	s setstr=##class(web.DHCTHREEEX).GetSingleTempdata()
	s tempid=$P(setstr,"^",3)
	s wultempid=$P(setstr,"^")
	//if Grp'="-1"  s StrTime=$ZT($P($H,",",2),3)
	for i=1:1:ln-1
	{
    s Value=""
    s str=$P(datastr,"|",i)
    s RowId=$P(str,"^",1)
	s StrItem=$P(str,"^",2)
	s StrDate=$P(str,"^",3)
    s StrTime=$P(str,"^",4)
    if (StrTime="-1") s StrTime=$ZT($P($H,",",2),3)
	s StrUser=$P(str,"^",5)
	s Value=$P(str,"^",6)
	
	if StrItem=wultempid{
	  s ret=##class(web.DHCTHREEE).InsertDesc(RowId, tempid, StrDate, StrTime, StrUser, Value )
		}
	s ret=##class(web.DHCTHREEE).InsertData(RowId, StrItem, StrDate, StrTime, StrUser, Value )
	}
	q ret
}

ClassMethod SaveOrdColor(Para As %String) As %String [ WebMethod ]
{
	s ^TMP(0)=Para
	s ret=##class(web.DHCPdaComm).OrdColorSet(Para)
	q ret
}

ClassMethod GetPatInfo(Row As %String) As %String [ WebMethod ]
{
	//s ^TMP(0)=Para
	s ret=##class(web.DHCPdaComm).NurPatInfo(Row)
	q ret
}

ClassMethod GetPPatInfo(RegNo As %String) As %String [ WebMethod ]
{
	//s ^TMP(0)=Para
	if Adm'="0" s RegNo=##class(web.DHCNURPDAQUEXCUTE).GetCurrAdm(RegNo)
	s ret=##class(web.DHCPdaComm).NurPatInfo(Row)
	q retRegNo
}

ClassMethod GetOrdColor() As %String [ WebMethod ]
{
	s ret=##class(web.DHCPdaComm).GetOrdColor()
	if ret="" q "-1"
	q ret
}

ClassMethod GetPdaHead() As %String [ WebMethod ]
{
	s ret=##class(web.DHCNURPDAQUEXCUTE).GetPdaHead()
	q ret
}

ClassMethod ChangeBed(Adm As %String, BedDr As %String, PreBedDr As %String, User As %String) As %String [ WebMethod ]
{
	s ^TMP(0)=$LB(Adm, BedDr, PreBedDr, User)
	s ret=##class(web.DHCPdaComm).UpdateBed(Adm, BedDr, PreBedDr, User)
	q ret
}

ClassMethod BedOccupy(BedDr As %String, User As %String, StDate As %String, StTime As %String, ToDate As %String, ToTime As %String, ReasonDr As %String) As %String [ WebMethod ]
{
  //标记占床
	s ^TMP(11)=$LB(BedDr, User, StDate, StTime, ToDate , ToTime , ReasonDr)
	s ret=##class(web.DHCPdaComm).BedOccupy(BedDr, User, StDate, StTime, ToDate , ToTime , ReasonDr)
	q ret
}

ClassMethod GetSystTime() As %String [ WebMethod ]
{
	s date=$ZD(+$H,3)
	s week=$ZD(+$H,10)
	s tim=$P($H,",",2)
	s tim=$ZT(tim)
 q date_"^"_week_"^"_tim
}

ClassMethod GetPatValue(Adm As %String, StDate As %String, EndDate As %String) As %String [ WebMethod ]
{
	s StDate=$ZDH(StDate,3)
	s EndDate=$ZDH(EndDate,3)
	s ret=##class(web.DHCPdaComm).GetPatValue(Adm, StDate, EndDate)
	q ret
}

ClassMethod Init(UserId As %String) As %String [ WebMethod ]
{
 //初始化
	s ret=##class(web.DHCPdaComm).Init(UserId)
	s ret=##class(web.DHCPdaNurComm).GetSystTime()
	s emr=##class(web.DHCPdaNurComm).GetEmrInterface()
	q ret_"|"_emr
}

ClassMethod GetQueryTyp(Grp As %String, UserId As %String) As %String [ WebMethod ]
{
 //New result  GetObserData
 s ^TMP(0)=$LB(Grp,UserId)
 s result=##class(web.DHCNURPDAQUEXCUTE).GetQueryTyp(Grp,UserId)
 q result
}

ClassMethod GetObInOutTime(Adm As %String, Date As %String, Grp As %String) As %String [ WebMethod ]
{
	
	s itmstr=##class(web.DHCPdaComm).GetObserTime(Adm,Date,Grp)
	q itmstr
}

ClassMethod EvalPatInfo(EpisodeId As %String) As %String [ WebMethod ]
{
	s str=##class(web.DHCPdaComm).EvalPatInfo(EpisodeId)
	q str
}

ClassMethod GetOutInAmount(Adm As %String, StDate As %String, StTim As %String, EndDate As %String, EndTim As %String, Grp As %String = "") As %String [ WebMethod ]
{
 //出入量汇总 [ WebMethod ]
	//s StDate=$ZDH(StDate,3),StTim=$ZTH(StTim,3),EndDate=$ZDH(EndDate,3),EndTim=$ZTH(EndTim,3)
	s str=##class(web.DHCPdaObserData).GetOutInData(Adm,StDate,StTim,EndDate,EndTim, Grp)
	q str
}

}

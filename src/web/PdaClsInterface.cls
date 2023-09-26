Class web.PdaClsInterface Extends %RegisteredObject
{

ClassMethod GetObserItm(Grp As %String) As %String
{
	s Ret=##class(web.DHCPdaComm).GetObservationItm(Grp)
	q Ret
}

ClassMethod PDAVersion() As %String [ WebMethod ]
{
	s ret="1.0.0.5"
	q ret
}

ClassMethod GetOldReqNo(disprow As %String) As %String
{
	//s ^TMP(0)=disprow            GetOldReqno
	s ret=##class(web.DHCPdaPhReq).GetOldReqno(disprow)
	q ret
}

ClassMethod GetQueryData1(QueryName, parrm) As %String [ WebMethod ]
{
   //s a=##class(HandPhone.PhoneDocApp).GetQueryData()
	 //s QueryName="web.PdaClsInterface:GetLongOrdData"
	// s parrm="Adm:914!StartDate:2010-09-20!EndDate:2010-09-20!ChangeDate:1!stop:1^0"
	 // s funname="addLab"
	  //s ^TT("a")=QueryName
	  s l=$L(parrm,"!")
	  s pp=""
	  f i=1:1:l
	  {
	    s itm=$P(parrm,"!",i)
	    s p=$P(itm,"$",1)
	    s v=$P(itm,"$",2)
	    s @p=v
	    b
	    if i<l s pp=pp_p_","
	    e  s pp=pp_p 
	    
	    b
	  }
	  Set rset = ##class(%Library.ResultSet).%New(QueryName)
	  Set columns = rset.GetColumnCount()
	// Execute the query
	 b
	 s sc = rset.Execute(@pp)
  s QueryName=$TR(QueryName,":","&")
   s ret=$P(QueryName,"&",2)_"&"
  s i=0
  While (rset.Next()) {
       i (i=0){
        For col = 1:1:columns {
            s ret=ret_rset.GetColumnName(col)_"&"
        }
       }
       s coldata=""
       For col = 1:1:columns {
	        s bb=$TR(rset.GetData(col),"^","#")
            s coldata=coldata_bb_"^"
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>150  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 b
 s a=$TR(ret,$C(1),"@")
 s a=$TR(a,$C(2),"!")
 s a=$TR(a,$C(3),"$")
 q a
}

ClassMethod GetData(mth As %String, parrm As %String) As %String
{
  //s a=##class(web.PdaClsInterface).GetData()
   //mth="##class(web.DHCMGNurComm).GetLoc"
  // q 1
   //s parrm=""
  // s ^TMP("qse")=mth_"^"_parrm
  // s mth="web.DHCPdaNurComm:GetLabOrdItem1"  ,parrm="ordstr:20_24!^"
   s mth="##class("_$P(mth,":")_")."_$P(mth,":",2)
   s l=$L(parrm,"^")

   s pp=""

   if $F(parrm,"^")'=0
   {
	   f i=1:1:l
	   {
	     s itm=$P(parrm,"^",i)
	     if itm="" continue
	     	 //  s ^TMP("aa")="ffff"

	     s p=$P(itm,":",1)
	     s v=$P(itm,":",2)
	     s @p=v
	     if pp'="" s pp=pp_p_","
	     e  s pp=pp_p 
	     b //
	   }
   }
   	s mth=mth_"("_pp_")"
   	
	b
	q @mth
}

ClassMethod PhReqInsertDetail(data As %String) As %String
{
	s ret=##class(web.DHCPdaPhReq).InsDetail2(data)
	q ret
}

ClassMethod PhReqUpdateQty(Rw As %String, Qty As %String, User As %String) As %String
{
	s ret=##class(web.DHCPdaPhReq).UpdateQty(Rw,Qty,User)
	q ret
}

ClassMethod ReqChangeStat(Rw As %String, Stat As %String, User As %String) As %String
{
	s ret=##class(web.DHCPdaPhReq).ChangeStat(Rw,Stat,User)
	q ret
}

ClassMethod GetMaxRetReqNo() As %String
{
	s ret=##class(web.DHCPdaPhReq).GetMaxRetReqNo()
	q ret
}

ClassMethod ExcuteOrd(Parr As %String) As %String
{
	//s ^TMP(0)=Parr
	//s Parr="Y^^^69^2701||908||1^^!"   //
	s ln=$L(Parr,"!")
	//s ^TMP(0)=$H
	for i=1:1:ln
	{
		s paritem=$P(Parr,"!",i)
		if (paritem="") continue
		s row=$P(paritem,"^",5)
        s oew=$P(row,"||",1),ordsub=$P(row,"||",2),exechl=$P(row,"||",3)
		s a=##class(web.DHCPdaNurComm).execRelation(paritem)
		s exflag=""
		if exechl'="" s exflag=##class(web.DHCPdaNurComm).GetExcuteNur(oew,ordsub,exechl)
		s exesusr=""
		if ($G(exflag)'="")
		{
		   s exesusr=$P(exflag,"|",2)
		}
		if exesusr'="" continue
	    if paritem'="" s ret=##class(web.DHCPdaNurComm).UpdateExecStat(paritem)
	}
	//s ret=""
	//s ^TMP(1)=$H
	q 0
}

ClassMethod SetDisconOrd(OrdRow As %String, User As %String) As %String
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

ClassMethod UndoDisconOrd(OrdRow As %String, User As %String) As %String
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

ClassMethod UnExcute(oeoriId As %String, arcicId As %String, oecprDesc As %String, userId As %String) As %String
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

ClassMethod GetCurrAdm(RegNo As %String, LocDr As %String) As %String
{
	s Adm=##class(web.DHCNURPDAQUEXCUTE).GetCurrAdm(RegNo,LocDr)
    s Ret=""
	if Adm'="" {
		s str=##class(web.DHCPdaComm).NurPatInfo(Adm)
		s Ret=Adm_"$"_str
		}
	q Ret
}

ClassMethod GetDataOrdItem(WardLoc As %String, Adm As %String, Excute As %String, UnExcute As %String, scroll As %String, UserId As %String, VarTyp, LocDr As %String) As %String
{
 //New result
  n
  if Adm'="0" s Adm=##class(web.DHCNURPDAQUEXCUTE).GetCurrAdm(Adm,LocDr)
  if (WardLoc="")&(Adm="") q -1
  //s VarTyp="CQSYD"
  if VarTyp="-1" s VarTyp=""
  if $P(VarTyp,"@")'=""  s VarTyp=$P(VarTyp,"@",2)
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

ClassMethod GetPhReqData(StDate As %String, EndDate As %String, RequestNo As %String, Ward As %String, Status As %String) As %String
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

//ClassMethod GetReqDrug(StDate As %String, EndDate As %String, RequestNo As %String, Ward As %String, Status As %String) As web.PdaReqDrugNo 

//{

//New result

// s result=##class(web.PdaReqDrugNo).%New()

// s StDate=$ZDH(StDate,3)

// s EndDate=$ZDH(EndDate,3)

// s ^TMP1=$LB(StDate, EndDate , RequestNo, Ward , Status)

// Do result.SetArgs(StDate, EndDate , RequestNo, Ward , Status)

// q result

//}

//ClassMethod GetOrdItem(StDateStr As %String, EDateStr As %String, Adm As %String, OECCat As %String, longord As %String, lsord As %String, Excute As %String, UnExcute As %String, scroll As %String) As web.PDAOrdData 

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

//ClassMethod GetOrcat() As web.PdaOrdCat 

//{

//New result

// s result=##class(web.PdaOrdCat).%New()

// Do result.SetArgs()

// q result

//}

//ClassMethod GetPrior() As web.PdaQueryPrior 

//{

//New result

// s result=##class(web.PdaQueryPrior).%New()

//Do result.SetArgs()

// q result/

//}

//ClassMethod GetLogonLoc(UserId As %String) As web.PDALOGONLOC 

//{

//New result

// s result=##class(web.PDALOGONLOC).%New()

//Do result.SetArgs(UserId)

//q result

//}

//ClassMethod GetMeth() As web.PdaQueryInstr 

//{

//New result

//s result=##class(web.PdaQueryInstr).%New()

//Do result.SetArgs()

//q result

//}

//ClassMethod GetPhcInstr() As web.PdaQueryInstr 

//{

//New result

// s result=##class(web.PdaQueryInstr).%New()

//Do result.SetArgs()

//q result

//}

//ClassMethod GetOrdStat() As web.PdaQueryOrdStat 

//{

//New result

// s result=##class(web.PdaQueryOrdStat).%New()

//Do result.SetArgs()

//q result

//}

//ClassMethod GetTimePoint() As web.PDATHREETIME 

//{

//New result

//s result=##class(web.PDATHREETIME).%New()

//Do result.SetArgs()

//q result

//}

ClassMethod GetObserData(Adm As %String, CDate As %String, CTime As %String, Grp As %String) As %String
{
 //New result  s a=##class(web.PdaClsInterface).GetObserData()
 s ^TMP(0)=$LB(Adm,CDate,CTime,Grp)
 s CDate=$ZDH(CDate,3)
 if CTime'="" s CTime=$ZTH(CTime,3)
 e  s CTime=$P($H,",",2)
 s result=##class(web.DHCNURPDAQUEXCUTE).GetObserData(Adm, CDate, CTime,Grp)
 q result
}

//ClassMethod GetThreeData(Adm As %String, CDate As %String, CTime As %String) As web.PDATHREEDATA 

//{

//New result

// s CDate=$ZDH(CDate,4)

//s CTime=$ZTH(CTime,3)

//s result=##class(web.PDATHREEDATA).%New()

//Do result.SetArgs(Adm, CDate, CTime)

//q result

//}

ClassMethod GetUserId(UserCode As %String, Pin As %String) As %String
{
	
	s ret=##class(web.DHCPdaNurComm).Logon( UserCode,Pin)
	q ret
}

ClassMethod GetCodeData(UserId As %String, GrpCode As %String) As %String
{
	s querytyp=##class(web.DHCNURPDAQUEXCUTE).GetQueryTyp(GrpCode,UserId)
	s ret=##class(web.DHCNURPDAQUEXCUTE).GetCodeData(UserId)
	//s ^TMP(0)=ret
	q ret_"%"_querytyp
}

ClassMethod GetLogonCtLoc(UserId As %String) As %String
{
	//q "OStat_rowid:1|OStat_Desc:核实|Sel:|OStat_rowid:3|OStat_Desc:On Hold|Sel:|OStat_rowid:4|OStat_Desc:停止|Sel:|OStat_rowid:5|OStat_Desc:Pre-Order|Sel:|OStat_rowid:6|OStat_Desc:执行|Sel:|OStat_rowid:7|OStat_Desc:In Queue|Sel:|OStat_rowid:8|OStat_Desc:Post-Operation Order|Sel:|OStat_rowid:9|OStat_Desc:Postponed|Sel:|OStat_rowid:11|OStat_Desc:未激活|Sel:|OStat_rowid:12|OStat_Desc:In Progress|Sel:|"
	s ret=##class(web.DHCNURPDAQUEXCUTE).Getlogonctloc(UserId)
	//s ^TMP(0)=ret
	q ret
}

ClassMethod GetReasonNotAvail(QueryName As %String) As %String
{
	//q "OStat_rowid:1|OStat_Desc:核实|Sel:|OStat_rowid:3|OStat_Desc:On Hold|Sel:|OStat_rowid:4|OStat_Desc:停止|Sel:|OStat_rowid:5|OStat_Desc:Pre-Order|Sel:|OStat_rowid:6|OStat_Desc:执行|Sel:|OStat_rowid:7|OStat_Desc:In Queue|Sel:|OStat_rowid:8|OStat_Desc:Post-Operation Order|Sel:|OStat_rowid:9|OStat_Desc:Postponed|Sel:|OStat_rowid:11|OStat_Desc:未激活|Sel:|OStat_rowid:12|OStat_Desc:In Progress|Sel:|"
	
	s ^TMP(0)=QueryName	 //s retStr=..GetQueryData("web.DHCPDABEDMANAGE:GetOrcat",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetPhcin",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetOecpr",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetOrdStat",user)_"$"_..GetSchCond(user)
    s ret=##class(web.DHCNURPDAQUEXCUTE).GetQueryData(QueryName,"")

	q ret
}

ClassMethod GetQueryData(QueryName As %String, Par1 As %String) As %String
{
	//q "OStat_rowid:1|OStat_Desc:核实|Sel:|OStat_rowid:3|OStat_Desc:On Hold|Sel:|OStat_rowid:4|OStat_Desc:停止|Sel:|OStat_rowid:5|OStat_Desc:Pre-Order|Sel:|OStat_rowid:6|OStat_Desc:执行|Sel:|OStat_rowid:7|OStat_Desc:In Queue|Sel:|OStat_rowid:8|OStat_Desc:Post-Operation Order|Sel:|OStat_rowid:9|OStat_Desc:Postponed|Sel:|OStat_rowid:11|OStat_Desc:未激活|Sel:|OStat_rowid:12|OStat_Desc:In Progress|Sel:|"
	s ^TMP(0)=$LB(QueryName,Par1)
	if Par1="0" s Par1=""
		 //s retStr=..GetQueryData("web.DHCPDABEDMANAGE:GetOrcat",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetPhcin",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetOecpr",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetOrdStat",user)_"$"_..GetSchCond(user)
    s ret=##class(web.DHCNURPDAQUEXCUTE).GetQueryData(QueryName,Par1)
 	q ret
}

ClassMethod SetDanJuDate(parr As %String, user As %String) As %String
{
  s ret=##class(web.DHCNURPDAQUEXCUTE).SetVarTyp(parr,user)
  q 0
}

ClassMethod SetSchCon(Parr As %String, UserId As %String) As %String
{
	//q "OStat_rowid:1|OStat_Desc:核实|Sel:|OStat_rowid:3|OStat_Desc:On Hold|Sel:|OStat_rowid:4|OStat_Desc:停止|Sel:|OStat_rowid:5|OStat_Desc:Pre-Order|Sel:|OStat_rowid:6|OStat_Desc:执行|Sel:|OStat_rowid:7|OStat_Desc:In Queue|Sel:|OStat_rowid:8|OStat_Desc:Post-Operation Order|Sel:|OStat_rowid:9|OStat_Desc:Postponed|Sel:|OStat_rowid:11|OStat_Desc:未激活|Sel:|OStat_rowid:12|OStat_Desc:In Progress|Sel:|"
	s ret=##class(web.DHCNURPDAQUEXCUTE).SetSchCond(Parr,UserId)
	//s ^TMP(0)=ret
	q ret
}

//ClassMethod GetWardBed(Loc As %String) As web.QPdaWardBed 

//{

//s result=##class(web.QPdaWardBed).%New()

//Do result.SetArgs(Loc)

//q result

//}

ClassMethod getItmDr(itemcode As %String) As %String
{
  //n (itemcode)
    s itemcode=$ZConvert(itemcode,"U")
    s rw=$O(^MRC("OBITM",0,"Code",itemcode,""))
   q rw
}

ClassMethod InsertData(datastr As %String, Grp As %String = "-1") As %String
{
	s ln=$L(datastr,"|")
	//s setstr=##class(web.DHCTHREEEX).GetSingleTempdata()
	s tempid=..getItmDr("Item1")
	s wultempid=..getItmDr("Item22")
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

ClassMethod SaveOrdColor(Para As %String) As %String
{
	s ^TMP(0)=Para
	s ret=##class(web.DHCPdaComm).OrdColorSet(Para)
	q ret
}

ClassMethod GetPatInfo(Row As %String) As %String
{
	//s ^TMP(0)=Para
	s ret=##class(web.DHCPdaComm).NurPatInfo(Row)
	q ret
}

ClassMethod GetPPatInfo(RegNo As %String) As %String
{
	//s ^TMP(0)=Para
	if Adm'="0" s RegNo=##class(web.DHCNURPDAQUEXCUTE).GetCurrAdm(RegNo)
	s ret=##class(web.DHCPdaComm).NurPatInfo(Row)
	q retRegNo
}

ClassMethod GetOrdColor() As %String
{
	s ret=##class(web.DHCPdaComm).GetOrdColor()
	if ret="" q "-1"
	q ret
}

ClassMethod GetPdaHead() As %String
{
	s ret=##class(web.DHCNURPDAQUEXCUTE).GetPdaHead()
	q ret
}

ClassMethod ChangeBed(Adm As %String, BedDr As %String, PreBedDr As %String, User As %String) As %String
{
	s ^TMP(0)=$LB(Adm, BedDr, PreBedDr, User)
	s ret=##class(web.DHCPdaComm).UpdateBed(Adm, BedDr, PreBedDr, User)
	q ret
}

ClassMethod BedOccupy(BedDr As %String, User As %String, StDate As %String, StTime As %String, ToDate As %String, ToTime As %String, ReasonDr As %String) As %String
{
  //标记占床
	s ^TMP(11)=$LB(BedDr, User, StDate, StTime, ToDate , ToTime , ReasonDr)
	s ret=##class(web.DHCPdaComm).BedOccupy(BedDr, User, StDate, StTime, ToDate , ToTime , ReasonDr)
	q ret
}

ClassMethod GetSystTime() As %String
{
	s date=$ZD(+$H,3)
	s week=$ZD(+$H,10)
	s tim=$P($H,",",2)
	s tim=$ZT(tim)
 q date_"^"_week_"^"_tim
}

ClassMethod GetPatValue(Adm As %String, StDate As %String, EndDate As %String) As %String
{
	s StDate=$ZDH(StDate,3)
	s EndDate=$ZDH(EndDate,3)
	s ret=##class(web.DHCPdaComm).GetPatValue(Adm, StDate, EndDate)
	q ret
}

ClassMethod NurInit(UserId As %String) As %String
{
 //初始化
	s ret=##class(web.DHCPdaComm).Init(UserId)
	s ret=##class(web.DHCPdaNurComm).GetSystTime()
	s emr=##class(web.DHCPdaNurComm).GetEmrInterface()
	q ret_"|"_emr
}

ClassMethod GetQueryTyp(Grp As %String, UserId As %String) As %String
{
 //New result  GetObserData
 s ^TMP(0)=$LB(Grp,UserId)
 s result=##class(web.DHCNURPDAQUEXCUTE).GetQueryTyp(Grp,UserId)
 q result
}

ClassMethod GetObInOutTime(Adm As %String, Date As %String, Grp As %String) As %String
{
	
	s itmstr=##class(web.DHCPdaComm).GetObserTime(Adm,Date,Grp)
	q itmstr
}

ClassMethod EvalPatInfo(EpisodeId As %String) As %String
{
	s str=##class(web.DHCPdaComm).EvalPatInfo(EpisodeId)
	q str
}

ClassMethod GetOutInAmount(Adm As %String, StDate As %String, StTim As %String, EndDate As %String, EndTim As %String, Grp As %String = "") As %String
{
 //出入量汇总 
	//s StDate=$ZDH(StDate,3),StTim=$ZTH(StTim,3),EndDate=$ZDH(EndDate,3),EndTim=$ZTH(EndTim,3)
	s str=##class(web.DHCPdaObserData).GetOutInData(Adm,StDate,StTim,EndDate,EndTim, Grp)
	q str
}

ClassMethod GetLongOrdData(Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String, stop As %String = "0") As %String
{
  //长嘱
		s ret=##class(web.DHCPdaLongTimeOrd).GetOrdLongData(Adm, StartDate, EndDate , ChangeDate,stop)
   q ret
}

ClassMethod GetTempOrdData(Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String, stop As %String = "0") As %String
{
  //短嘱
	s ret=##class(web.DHCPdaTempOrd).GetOrdTempData(Adm, StartDate, EndDate , ChangeDate,stop)
    q ret
}

ClassMethod GetArcimBasinfo(ORW) As %String
{
  //医嘱信息s a=##class(web.PdaClsInterface).GetArcimBasinfo
	s Oew=$P(ORW,"||"),Chl=$P(ORW,"||",2)
	s exechl=$P(ORW,"||",3)
	s ret=##class(web.DHCPdaLongTimeOrd).GetArcimBasinfo(Oew,Chl,exechl)
	q ret
}

ClassMethod GetErpNormData(APatientID As %String, AEpisodeID As %String, AEpisodeType As %String, AChartItemID As %String, AChartItemType As %String, ACategoryType As %String, ACategoryID As %String) As EPRservice.entity.EInstanceData
{
    s a=##class(EPRservice.BOInstanceData).GetNormalData(APatientID, AEpisodeID , AEpisodeType, AChartItemID, AChartItemType, ACategoryType, ACategoryID)
    q a
}

ClassMethod SaveEprData(AEInstanceData As EPRservice.entity.EInstanceData) As EPRservice.entity.EInstanceData
{
	/*
	s TmpStrText="",StrText=""
	k ^CacheTemp("TmpStream")
	While (AEInstanceData.InstanceData.AtEnd = 0) 
	{
		Set len = 1024
		set TmpStrText= AEInstanceData.InstanceData.Read(len)
		set StrText= StrText_TmpStrText  
	}
	s ^CacheTemp("TmpStream")=StrText
	*/
    s a=##class(EPRservice.BOInstanceData).SaveData(AEInstanceData)
    q a
}

ClassMethod ChangeStatus(parInstanceID As %String, parStatus As %String) As %String
{
    s a=##class(EPRservice.BOInstanceData).ChangeStatus(parInstanceID, parStatus )
    q a
}

ClassMethod GetEprBlRecord(RecId As %String) As %String
{
   s ret=##class(web.DHCPdaComm).GetBlRecord(RecId)
   q ret
}

ClassMethod GetEprRecordId(EpisodeID As %String, CharItemId As %String) As %String
{
   s ret=##class(EPRinstance.ECRecord).GetECRecordID("",EpisodeID,CharItemId)
   q ret
}

ClassMethod GetEprDataById(AtId As %String) As EPRservice.entity.EInstanceData
{
	s instdata=##class(EPRservice.BOInstanceData).GetDataByID(AtId)
	q instdata
}

ClassMethod SaveEprMulitData(AEinstanceData As EPRservice.entity.EInstanceData) As EPRservice.entity.EInstanceData
{
   s insta=##class(EPRservice.BOInstanceData).SaveMultipleData(AEinstanceData)
   q insta
}

ClassMethod GetEprMultiData(APatientID As %String, AEpisodeID As %String, AChartItemID As %String, AChartItemType As %String, AChartListNo As %String, ATemplateID As %String, ACategoryID As %String, ACategoryType As %String) As EPRservice.entity.EInstanceData
{
   s insta=##class(EPRservice.BOInstanceData).GetMultipleData(APatientID , AEpisodeID, AChartItemID , AChartItemType , AChartListNo , ATemplateID, ACategoryID, ACategoryType)
   q insta
}

ClassMethod GetUserGrp(User As %String, logloc As %String) As %String
{
  //2008-11-11
	s grp=##class(web.DHCPdaNurComm).GetUserGrp(User,logloc)
	q grp
}

ClassMethod GetOrdData(parr As %String) As %String
{
    // 短嘱
   //Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String, stop As %String = "0"
	s ret=##class(web.DHCPdaTempOrd).GetOrddta(parr)
    q ret
}

ClassMethod GetRadiaNotes(Row As %String) As %String
{
	//取报告
   s ret=##class(web.DHCPdaTempOrd).GetRadiaNote(Row)
   q ret
}

ClassMethod GetCHMCode(para As %Library.String = "") As %String
{
	///取中草药代码 Chinese Herbal Medicine Entry   w ##Class(web.PdaClsInterface).GetCHMCode()
	s duration=##Class(web.DHCNURPDAQUEXCUTE).GetQueryData("web.DHCDocPDAOrderEntryCM:LookUpDuration","")
	s frequence=##Class(web.DHCNURPDAQUEXCUTE).GetQueryData("web.DHCDocPDAOrderEntryCM:LookUpFrequence","")
	s instr=##Class(web.DHCNURPDAQUEXCUTE).GetQueryData("web.DHCDocPDAOrderEntryCM:LookUpInstr","")
	s cookMode=##Class(web.DHCNURPDAQUEXCUTE).GetQueryData("web.DHCDocPDAOrderEntryCM:LookUpCookMode","")
	s prior=##Class(web.DHCNURPDAQUEXCUTE).GetQueryData("web.DHCDocPDAOrderEntryCM:LookUpOrderPrior","")
	s recLoc=##Class(web.DHCNURPDAQUEXCUTE).GetQueryData("web.DHCDocPDAOrderEntryCM:LookUpCookRecLoc","")
	s itemInstr=##Class(web.DHCNURPDAQUEXCUTE).GetQueryData("web.DHCDocPDAOrderEntryCM:LookUpItemInstr","")
	s retStr=duration_"!"_frequence_"!"_instr_"!"_cookMode_"!"_prior_"!"_recLoc_"!"_itemInstr
	q retStr
}

ClassMethod GetCHMDefaultPara(para As %Library.String = "") As %String
{
	s retStr=##Class(web.DHCDocPDAOrderEntryCM).GetCHMDefaultPara(para)
	q retStr
}

ClassMethod GetCHMItem(para As %Library.String = "") As %Library.String
{
	///由代码安全组取草药项目 w ##Class(web.PdaClsInterface).GetCHMItem("gc^100")
	s retStr=##Class(web.DHCDocPDAOrderEntryCM).GetCHMItem(para)
	q retStr
}

ClassMethod SaveOrderItemsCM(Adm As %String = "", OrdItemStr As %String = "", User As %String = "", Loc As %String = "", Doc As %String = "") As %String
{
	///审核中草药医嘱
	s retStr=##Class(web.DHCDocPDAOrderEntryCM).SaveOrderItemsCM(Adm,OrdItemStr,User,Loc,Doc)
	q retStr
}

}

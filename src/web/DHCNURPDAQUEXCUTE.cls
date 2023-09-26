Import SQLUser

/// web.DHCNURPDAQUEXCUTE
Class web.DHCNURPDAQUEXCUTE Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1363;

ClassMethod GetExcuteStr(Oew, OrdSub, ExceChl)
{
	n (Oew,OrdSub,ExceChl)
	s ret=0
	if ExceChl="" s ret=0
	 if ExceChl'=""{
		s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",19) i DateEx'="" s DateEx(Oew,OrdSub)=$ZD(DateEx,3)  ;nursing execute
	    s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",20)  i TimeEx'=""  s TimeEx(Oew,OrdSub)=$ZT(TimeEx,2)
	    s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",15)
	   if CPTExDR'="" s ret=1
	   else  s ret=0
	 }
	q ret
}

ClassMethod GetExcuteFlag(Oew, OrdSub, ExceChl)
{
 //判断护士是否需要执行该医嘱
	n (Oew,OrdSub,ExceChl)
	s ret=0
	s ExDate=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",1)
    s ExTime=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",2)
    s exdt=..GetAbsTime(ExDate_","_ExTime)
    s xstr=..GetXDtim(Oew,OrdSub)
    s Xdate=$P(xstr,"|"),Xtime=$P(xstr,"|",2)
    s xdt=..GetAbsTime(Xdate_","_Xtime)
    if exdt'="" d
    .s ret=1 //如果执行时间大于停止时间不执行 ret 等于1 已停
    e  d
    .s ret=0   //未停需执行或已执行
	q ret
}

ClassMethod PRX(Oew, OrdSub)
{
	  n (Oew,OrdSub)
	  ; ^OEORD({OE_Order.OEORD_RowId},"I",{OE_OrdItem.OEORI_Childsub}, "ST",{ST_Childsub})
	   s STR=""
	   s chl=""  f  s chl=$O(^OEORD(Oew,"I",OrdSub, "ST",chl)) q:chl=""  d
	   .s statDR=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",3)
	   .s xdate=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",1)
	   .s xtime=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",2)
	   .s cdoc=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",4)
	   .if (statDR=4)&(cdoc="") s STR=$ZD(xdate,3)_"|"_$ZT(xtime,2)_"|"_""
	   .i (statDR=4)&((cdoc'=""))  s STR=$ZD(xdate,3)_"|"_$ZT(xtime,2)_"|"_$P(^SSU("SSUSR",cdoc),"^",2)
	   q $G(STR)
}

ClassMethod SingNur(Oew, OrdSub)
{
	 n (Oew,OrdSub)
	 s oeoriId=Oew_"||"_OrdSub
	 
	 	s xOrdExecStr=##Class(web.DHCNurCom).GetXOrdExecInfo(oeoriId)
	 //	if xOrdExecStr'="^^"  w !,xOrdExecStr,"-",oeoriId
	 i xOrdExecStr'="^^" d
	 .s a=xOrdExecStr
	 .s nursestdr=$P(a,"^",1)
	 .i nursestdr'="" s nursestop=$P($g(^SSU("SSUSR",nursestdr)),"^",2) //ypz 060806 add $g
	 .s nursestopDate=$ZD($P(a,"^",2),3) 
	 .s nursestopTime=$ZT($P(a,"^",3),2)
	 .s nurstr=nursestopDate_"|"_nursestopTime_"|"_$G(nursestop)
	 .b
	 q $G(nurstr)
}

ClassMethod GetCurrAdm(RegNo) As %String
{
  	n (RegNo)
  	q:(RegNo="")||(RegNo["-") ""
  	s nvar=""
	s ln=$L(RegNo)
	s le=8-ln
	s $P(nvar,"0",le)=RegNo
	s papmi=""
	s CurrAdm=0
	f  s papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,papmi)) q:papmi=""  d
	.s name=$p(^PAPER(papmi,"ALL"),"^",1)
	.s Adm=""
	.f  s Adm=$o(^PAPERdr(papmi,"ADM","I",Adm)) q:Adm=""  d  	
	..;s visitstatus=$p(^PAADM(Adm),"^",20)
	..;q:visitstatus'="A"
	..s Typ=$p(^PAADM(Adm),"^",2)
	..q:Typ'="I"
	..if Adm>CurrAdm  s CurrAdm=Adm
	if CurrAdm=0 s CurrAdm=""
	q CurrAdm
}

ClassMethod SetVarTyp(parr As %String, user As %String) As %String
{
  //按单据查询设置时间 080911 qse
  	s ^DHCPdaNurSCHSet("schSet","StDatTim",user)=$P(parr,"|",1)
	s ^DHCPdaNurSCHSet("schSet","EndDatTim",user)=$P(parr,"|",2)
  q 0
}

ClassMethod SetSchCond(parr, user) As %String
{
 //保存查询条件设置
    s flag=$P(parr,"~",2)
    if flag="Current"{
	s ^DHCPdaNurSCHSet("schSet","OrdCat",user)=$P(parr,"|",2)
	s ^DHCPdaNurSCHSet("schSet","Prior",user)=$P(parr,"|",1)
	s ^DHCPdaNurSCHSet("schSet","OrdStat",user)=$P(parr,"|",3)
	s ^DHCPdaNurSCHSet("schSet","PhcIn",user)=$P(parr,"|",4)
	s ^DHCPdaNurSCHSet("schSet","StDatTim",user)=$P(parr,"|",5)
	s ^DHCPdaNurSCHSet("schSet","EndDatTim",user)=$P(parr,"|",6)
    }else{
	s ^DHCPdaNurSCHSet("default","OrdCat",user)=$P(parr,"|",2)
	s ^DHCPdaNurSCHSet("default","Prior",user)=$P(parr,"|",1)
	s ^DHCPdaNurSCHSet("default","OrdStat",user)=$P(parr,"|",3)
	s ^DHCPdaNurSCHSet("default","PhcIn",user)=$P(parr,"|",4)
	s ^DHCPdaNurSCHSet("default","StDatTim",user)=$P(parr,"|",5)
	s ^DHCPdaNurSCHSet("default","EndDatTim",user)=$P(parr,"|",5)
	}
	q 0
}

ClassMethod GetSchCond(user) As %String
{
 //提取条件
    s ret=""
	if '$D(^DHCPdaNurSCHSet("default","Prior",user)) q 0
	s ret=ret_^DHCPdaNurSCHSet("default","Prior",user)_"|"_^DHCPdaNurSCHSet("default","OrdCat",user)
	s ret=ret_"|"_^DHCPdaNurSCHSet("default","OrdStat",user)
	s ret=ret_"|"_^DHCPdaNurSCHSet("default","PhcIn",user)
	s ret=ret_"|"_$ZD(+$H,3)_",00:00:00"
	s ret=ret_"|"_$ZD(+$H,3)_",23:59:00"
	//s ret=ret_"|"_^DHCPdaNurSCHSet("default","StDatTim",user)  //$ZD(+$H,3)_",00:00:00"
	//s ret=ret_"|"_^DHCPdaNurSCHSet("default","EndDatTim",user)  //$ZD(+$H,3)_",23:59:00"
	q ret
}

ClassMethod GetPhReqData(StDate As %String, EndDate As %String, RequestNo As %String, Ward As %String, Status As %String) As %String
{
   n (StDate, EndDate, RequestNo, Ward , Status)
   //s StDate=$List(^TMP2,1)
   //s EndDate=$List(^TMP2,2)
   //s RequestNo=$List(^TMP2,3)
   //s ward=$List(^TMP2,4)
  // s Status=$List(^TMP2,5)
   
   s QueryName="web.DHCPdaReturnDrug:GetRequestDrug"
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()
   
 // Execute the query
    s sc = rset.Execute(StDate, EndDate, RequestNo, Ward , Status)

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
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>300  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 b
 q ret
}

ClassMethod GetQueryTyp(Grp As %String, UserId As %String) As %String
{
   n (Grp,UserId)
   s QueryName="web.DHCNurCom:GetQueryType"
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()

 // Execute the query
    s sc = rset.Execute(Grp,UserId)

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
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>500  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 q ret
}

ClassMethod GetObserData(Adm As %String, CDate As %String, CTime As %String, Grp As %String) As %String
{
   n (Adm , CDate, CTime,Grp)
   s QueryName="web.DHCPdaObserData:GetListItemData"
   //q "web.DHCNURPDAQUEXCUTE:GetPatOrdItem"
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()

 // Execute the query
    s sc = rset.Execute(Adm , CDate, CTime,Grp)

   s QueryName=$TR(QueryName,":","&")
   s ret=$P(QueryName,"&",2)_"&"
  s i=0
  b
  While (rset.Next()) {
       i (i=0){
        For col = 1:1:columns {
            s ret=ret_rset.GetColumnName(col)_"&"
        }
       }
       s coldata=""
       For col = 1:1:columns {
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>500  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 b
 q ret
}

ClassMethod GetOrdData(WardLoc As %String, Adm As %String, Excute As %String, UnExcute As %String, scroll As %String, UserId As %String, VarTyp As %String) As %String
{
   n (WardLoc, Adm, Excute , UnExcute , scroll, UserId,VarTyp)
   s QueryName="web.DHCNURPDAQUEXCUTE:GetPatOrdItem"
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()
 // Execute the query
    s sc = rset.Execute(WardLoc, Adm, Excute , UnExcute , scroll, UserId,VarTyp)
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
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>50  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 q ret
}

ClassMethod GetQueryData(QueryName, Parr) As %String
{
   n (QueryName,Parr)
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()

 // Execute the query
   if $L(Parr,"^")&(Parr'="")=1
   {
    s sc = rset.Execute(Parr)
   }
   if (Parr=""){
   Set sc = rset.Execute()
   }
   s QueryName=$TR(QueryName,":","&")

 // Now fetch the results
   s ret=$P(QueryName,"&",2)_"&"
  s i=0
  While (rset.Next()) {
       i (i=0){
        For col = 1:1:columns {
	        if rset.GetColumnName(col)="ItemData" continue
            s ret=ret_rset.GetColumnName(col)_"&"
        }
       }
       s coldata=""
       For col = 1:1:columns {
	        if rset.GetColumnName(col)="ItemData" continue
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>500  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 b
 q ret
}

ClassMethod GetCodeData(user) As %String
{
	set retStr=""
	//GetPhcinGetOrdStatGetOecpr
	s retStr=..GetQueryData("web.DHCPDABEDMANAGE:GetOrcat",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetPhcin",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetOecpr",user)_"!"_..GetQueryData("web.DHCPDABEDMANAGE:GetOrdStat",user)_"%"_..GetSchCond(user)
	//s retStr=..GetQueryData("GetOrdStat")
 q retStr
}

ClassMethod GetCode(user) As %String
{
	set retStr=""
	//GetPhcinGetOrdStatGetOecpr
	s retStr=..GetQueryData("web.DHCPdaNurComm:GetOrcat",user)_"!"_..GetQueryData("web.DHCPdaNurComm:GetPhcin",user)_"!"_..GetQueryData("web.DHCPdaNurComm:GetOecpr",user)_"!"_..GetQueryData("web.DHCPdaNurComm:GetPhFreq",user)
	//s retStr=..GetQueryData("GetOrdStat")
 q retStr
}

ClassMethod Getlogonctloc(UserId) As %String
{
	s retStr=..GetQueryData("web.DHCPdaNurComm:logonctloc",UserId)
	q retStr
}

ClassMethod GetPatOrdItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatOrdItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetPatOrdItemExecute(ByRef qHandle As %Binary, WardLoc As %String, Adm As %String, Excute As %String, UnExcute As %String, scroll As %String, UserId As %String, VarTyp As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0) 
 	k ^TMP("jj")
 	//if Adm="" Quit $$$OK
 	//s^TMP1=<<$LB("1029171","false","true","false","10374")>>
 	s WardLoc=$List(^TMP2,1)
 	//s Adm=3639347  //3648797  //2852454
 	s Adm=$List(^TMP2,2)
 	//s ^TMP9(9)=$LB(Adm,Excute,UnExcute,scroll,UserId)
 	s Excute=$List(^TMP2,3),UnExcute=$List(^TMP2,4),scroll=$List(^TMP2,5),UserId=$List(^TMP2,6) ,VarTyp=$List(^TMP2,7)
 	//s Adm=$List(^TMP2,2)
 	i VarTyp["@" s VarTyp=$P(VarTyp,"@",2)
 	s Count=0 //记录医嘱条数
 	if Adm'="0" {
	 	d GetOrdItem(Adm,Excute,UnExcute,scroll,UserId,"",.Count,VarTyp)
	    // k ^DHCPdaNurSCHSet("schSet") //清除当前查询条件
 	}
 	if Adm'="0"  Quit $$$OK
 	if Adm="0"{
 	s retStr=##class(web.DHCPdaComm).GetWardPat(WardLoc) //..GetQueryData("web.DHCNurIpComm:GetWardBed",WardLoc)
 	  if retStr'=""{
	 	  s ln=$L(retStr,"!")
	 	  b
	 	  for i=1:1:ln-1
	 	  {
		    s RowData=$P(retStr,"!",i)
		    s Adm=$P(RowData,"^",2)
		    s PatName=$P(RowData,"^")
		    d GetOrdItem(Adm,Excute,UnExcute,scroll,UserId,PatName,.Count,VarTyp)
		  }
		 // k ^DHCPdaNurSCHSet("schSet") //清除当前查询条件

 	   }
 	}
 	if retStr="" Quit $$$OK
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

GetOrdItem(Adm,Excute,UnExcute,scroll,UserId,PatName,Count,VarTyp)
    {
	if PatName="" {
		s papmiId=+^PAADM(Adm)
		s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	}
	//s PatName=+PatName
	
	s DefOrdStat=$G(^DHCPdaNurSCHSet("schSet","OrdStat",UserId))
    s DefOrdPrior=$G(^DHCPdaNurSCHSet("schSet","Prior",UserId))
    s DefOrdCat=$G(^DHCPdaNurSCHSet("schSet","OrdCat",UserId))
    s DefOrdPhcin=$G(^DHCPdaNurSCHSet("schSet","PhcIn",UserId))
    s DefOrdStDatTim=$G(^DHCPdaNurSCHSet("schSet","StDatTim",UserId))
    s DefOrdEndDatTim=$G(^DHCPdaNurSCHSet("schSet","EndDatTim",UserId))
     //;;b
    if (VarTyp'=""){
	  s DefOrdStat="^"_$g(^DHCCLNurseExec("VarDef",0,VarTyp,"OrdStat"))_"^"
      s DefOrdPrior="^"_$g(^DHCCLNurseExec("VarDef",0,VarTyp,"OecPr"))_"^"
      s DefOrdCat="^"_$g(^DHCCLNurseExec("VarDef",0,VarTyp,"OrCat"))_"^"
      s DefOrdPhcin="^"_$g(^DHCCLNurseExec("VarDef",0,VarTyp,"PhcIn"))_"^"
	    }
    if '$D(^DHCPdaNurSCHSet("schSet","OrdStat",UserId))
    {  //取默认值
	   if (VarTyp=""){
	   	s DefOrdStat=$G(^DHCPdaNurSCHSet("default","OrdStat",UserId))
        s DefOrdPrior=$G(^DHCPdaNurSCHSet("default","Prior",UserId))
        s DefOrdCat=$G(^DHCPdaNurSCHSet("default","OrdCat",UserId))
        s DefOrdPhcin=$G(^DHCPdaNurSCHSet("default","PhcIn",UserId))
        }
	   if DefOrdStDatTim="" {
		    s DefOrdStDatTim=$ZD(+$H,3)_",00:00:00"  //$G(^DHCPdaNurSCHSet("default","StDatTim",UserId))
            s DefOrdEndDatTim=$ZD(+$H,3)_",23:59:00"  //$G(^DHCPdaNurSCHSet("default","EndDatTim",UserId))
	   }
	}
   s ToDay=$P($H,",",1)
   if (DefOrdStDatTim'="" )
    {
	    s DefStDate=$P(DefOrdStDatTim,","),DefStTim=$P(DefOrdStDatTim,",",2)
        if DefStDate'="" s DefStDate=$ZDH(DefStDate,3)
        e  s DefStDate=ToDay
        if DefStTim'="" s DefStTim=$ZTH(DefStTim)
        e  s DefStTim=0
        if DefOrdStDatTim'="" s DefOrdStDatTim=DefStDate_","_DefStTim
    }
    if (DefOrdEndDatTim'="")
    {
	     s DefEnDate=$P(DefOrdEndDatTim,","),DefEnTim=$P(DefOrdEndDatTim,",",2)
         if DefEnDate'="" s DefEnDate=$ZDH(DefEnDate,3)
         e  s DefEnDate=ToDay
         if DefEnTim'="" s DefEnTim=$ZTH(DefEnTim)
         e  s DefEnTim=86400
         if DefOrdEndDatTim'="" s DefOrdEndDatTim=DefEnDate_","_DefEnTim
    }
    s DefOrdStDatTim=..GetAbsTime(DefOrdStDatTim)
	s DefOrdEndDatTim=..GetAbsTime(DefOrdEndDatTim)
	s Oew=$O(^OEORD(0,"Adm",Adm,""))
	q:Oew=""
    if DefOrdStDatTim="" s DefOrdStDatTim=ToDay_","_"0"
    if DefOrdEndDatTim="" s DefOrdEndDatTim=ToDay_","_"86400"
    if $D(^DHCPdaNurSCHSet("schSet"))=99
    { 
    	//默认取当天数据
    	s DefOrdStDatTim=ToDay_","_"0"
	    s DefOrdEndDatTim=ToDay_","_"86400"
	    s DefStDate=ToDay
	    s DefEnDate=ToDay
	}
   // ^OEORDi(0,"NotExecE",{OE_Order.OEORD_RowId},{OEORE_ExStDate},   +{OEORE_ExStTime},{OE_OrdItem.OEORI_Childsub},{OEORE_Childsub})
   ///创建索引
  // b  //
   // d ##class(web.DHCPdaComm).CreatOrdExecIndex(Oew,DefStDate,DefEnDate)
    k ^OrdSubExec("tem",UserId)
    f Date=DefStDate:1:DefEnDate d
    .s Extim="" f  s Extim=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim)) q:Extim=""  d
    ..s OrdSub=""  f  s OrdSub=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim,OrdSub)) q:OrdSub=""  d
	...s StDtTim=(Date_","_Extim)
	...s StDtTim=..GetAbsTime(StDtTim)
	...if ((StDtTim<DefOrdStDatTim)!(StDtTim>DefOrdEndDatTim)) q
	...s seqno=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)
	...s seqno=$P($G(^OEORD(Oew,"I",OrdSub,11)),"^",39) //trakcare 
	...s seq=..GetSeqno(Oew,OrdSub)
	...s seq1=$P(seq,"^",1),seq2=$P(seq,"^",2)
    ...s ExceChl=""  f  s ExceChl=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim,OrdSub,ExceChl)) q:ExceChl=""  d
	....s Stdate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9) //StDate
	....//q:Stdate'=Date  //不是当天的医嘱就过滤 //080708 qse
    ....s OrdSubExec(Oew,OrdSub,ExceChl)=seq1_"^"_seq2_"^"_Date_"^"_Extim
    ....//s ^QOrdSubExec(Oew,OrdSub,ExceChl)=seq1_"^"_seq2_"^"_Date_"^"_Extim
    s OrdSub=""  f  s OrdSub=$O(OrdSubExec(Oew,OrdSub)) q:(OrdSub="")!(Count>500)  d
	.s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期?
	.s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	.s StDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)  ;要求执行日期?
	.s StTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)
	.s StDtTim=(StDate_","_StTime)
	.s StDtTim=..GetAbsTime(StDtTim)
	.s Meth="",DoseQty="",PHFreq=""
	.s OrdStatusDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)
	.s dispstat=""
	.s OrdStatus="^"_OrdStatusDR_"^"
	.if (DefOrdStat'[OrdStatus)&(DefOrdStat'="") q  ///------------------
	.s OrdStat=$P(^OEC("OSTAT",OrdStatusDR),"^",2)
	.s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	.i PriorDR="" q //
	.s Prior="^"_PriorDR_"^"
	.s PriorCode=$P(^OECPR(PriorDR),"^",1)
	.if (DefOrdPrior'[Prior)&(DefOrdPrior'="") q  ///------------------
	.i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)  
	.e  q     ///PriorDR --10--自备药长期医嘱
	.s Priority=PriorDes
	.q:Priority="取药医嘱"  //by liulei 20091215
	.s PriorDes="^"_PriorDes_"^"
	.s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	.s ARCIMRowid=$P(ArcimDR,"||",1)
	.s ARCIMSub=$P(ArcimDR,"||",2) 
	.s ArcimDesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)
	.s ArcimDesc=$TR(ArcimDesc,":"," ")
	.s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	.q:(ItemCatDR="")
	.s OrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)    ;ARc_Itemcat
	.s ExceCatDr=$P(^ARC("IC",ItemCatDR),"^",9) 
	.s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
	.if OrdTyp="L" q   ///检验医嘱不往下走 衢州医院即可检验会加频次 add by liulei 20091228
	.s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
	.q:PHFreqDR=""
	.if ExceCatDr'=""  s ExceCat=$P(^OEC("EXEC",ExceCatDr),"^",1) //是否执行类
	.s CatDR="^"_OrdCatDR_"^"
	.if VarTyp'="" s CatDR="^"_ItemCatDR_"^"
    .if (DefOrdCat'[CatDR)&(DefOrdCat'="") q ///------------------
	.s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	.if MethDR'="" s Phcin="^"_MethDR_"^"
	.if ($G(Phcin)'="")&(DefOrdPhcin'[$G(Phcin))&(DefOrdPhcin'="") q ///------------------
	.i MethDR'="" s Meth=$P(^PHCIN(MethDR),"^",2)  
	.//i (OrdCatDR'=OECCat)&(OECCat'="") q
	.s Notes=""
	.i $G(Notes)="" s Notes=""
    .f rnum=1:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	..s Notes=Notes_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
	.s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
	.s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
	.q:user=""
	.q:'$D(^SSU("SSUSR",user))
	.if Notes'=""  s Notes=$TR(Notes,":","*")
	.s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	.q:DoctorDr=""  ;s Notes=$G(^OEORD(Oew,"I", OrdSub,"DEP",1))
	.s truedoc=0
	.s DocLoc="" //2005-12-3 qse add///////////////////////////////////////
	.i DoctorDr'=""  s Doctor=$P(^CTPCP(DoctorDr,1),"^",2) ;write doctor oeori_doctor_dr
	.e  s Doctor=""
    .if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
	.if '$D(^CT("CPT",CpTypDR)) //w !,DoctorDr
	.q:'$D(^CT("CPT",CpTypDR))
	.i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	.//q:CpTyp="NURSE" //add by liulei 20091217
	.//q:(OrdCatDR=49)!(OrdCatDR=52)   //材料,收费
	.s OrdCat=$P(^OEC("ORCAT",OrdCatDR),"^",1)    ;OEC_OrderCategory           ARCIC_OrdCat_DR 
    .i (PHFreqDR'="") d
	..s PHFreq=$P($G(^PHCFR(PHFreqDR)),"^",3) 
	.e  s PHFreq=""  ;table       PHC_Freq
	.s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3  ) ;CT_UOM                      OEORI_Unit_DR
	.i UOMDR'="" s UOM=$P(^CT("UOM",UOMDR),"^",2)  
	.e  s UOM="" 
	.s StopStr=""
	.s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
    .if (DoseQty'="")&($P(DoseQty,".")="") s DoseQty="0"_DoseQty_UOM
	.if DoseQty'="" s DoseQty=DoseQty_UOM
	.s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
	.if OrdStat="停止" s StopStr=..SingNur(Oew,OrdSub)  //停止处理人
	.s count=0
	.s Discon=""
	.s RefusePhFlag=""
	.//if OrdStat="停止" s Discon=##class(web.DHCPdaComm).GetDisconFlag(Oew,OrdSub) 
	.//if OrdTyp="R"  s RefusePhFlag=##class(web.DHCPdaComm).GetPhRefuseFlag(Oew,OrdSub)
	.s ExceChl=""  f  s ExceChl=$O(OrdSubExec(Oew,OrdSub,ExceChl)) q:ExceChl=""  d
	..s ExceStr=..GetExcuteStr(Oew,OrdSub,ExceChl)
	..s OEEx=^OEORD(Oew,"I",OrdSub,"X",ExceChl)
    ..s skintest=$p($g(^OEORD(Oew,"I",OrdSub,5)),"^",2)
    ..s dispstat="",ExFlag=""
    ..if (OrdStat="停止") s ExFlag=..GetExcuteFlag(Oew,OrdSub,ExceChl)
    ..s ExceUsr="",DateEx="",TimeEx=""
    ..s disCpt=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",15)
    ..//s ColorFlag=..GetOrdColor(OrdStat,OrdTyp,PriorCode,RefusePhFlag,disCpt,OrdSub) 
	..if ^DHCOEOrdPrintSet("L","OrdTyp")[PriorDes s dispstat=dispstat_"长 "
	..if ^DHCOEOrdPrintSet("OrdTyp")[PriorDes s dispstat=dispstat_"临 "
	..if (OrdStat="停止")&(StopStr="")&(ExceStr=0)&(ExFlag="1") s dispstat=dispstat_"停止需处理"
	..//if (OrdStat="停止")&(NurXDate="")&(ExceStr'=0) s dispstat=dispstat_"已执行"
	..if (OrdStat="停止")&(StopStr'="")&(ExceStr=0)&(ExFlag="1") s dispstat=dispstat_"停止已处理"
	..if ((OrdStat'="停止")&(ExceStr=0))!((OrdStat="停止")&(ExceStr=0)&(ExFlag="0")) s dispstat=dispstat_"未执行"
	..if (ExceStr=1) s dispstat=dispstat_"已执行"
	..if skintest="Y" d
	...s dispstat=dispstat_" 皮试"
	...s SkinFlag=$p(^OEORD(Oew,"I",OrdSub,11),"^",3)
	...if (dispstat["已执行") d
	....if (SkinFlag="Y") s dispstat=dispstat_"(+)"
	....e  s dispstat=dispstat_"(-)"
	..s flow=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",22) ;长期医嘱开医嘱日期
    ..q:(flow'="")&(scroll'="true")&(OrdStat'="停止")
    ..if (flow'="") s dispstat=dispstat_" 滚"
    ..q:(Excute="true")&(UnExcute'="true")&(dispstat["未执行")
    ..q:(Excute="true")&(UnExcute'="true")&(dispstat["需处理")
    ..q:(UnExcute="true")&(Excute'="true")&(dispstat["已执行")
    ..q:(UnExcute="true")&(Excute'="true")&(dispstat["已处理")
    ..s seq1=$P(OrdSubExec(Oew,OrdSub,ExceChl),"^",1),seq2=$P(OrdSubExec(Oew,OrdSub,ExceChl),"^",2),Date=$P(OrdSubExec(Oew,OrdSub,ExceChl),"^",3),Extim=$P(OrdSubExec(Oew,OrdSub,ExceChl),"^",4)
    ..s ExDate=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",1)
    ..s Num(ExDate,seq1,OrdSub)=$G(Num(ExDate,seq1,OrdSub))+1
    ..s ExTime=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",2)
    ..s ExDateTime=$P($ZD(Date,3),"-",3)_"."_+$zt(ExTime)
    ..//if dispstat["已处理" w !,StopStr b
    ..s ExceCptDr=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",15)
    ..if ExceCptDr'="" s ExceUsr=$P(^CTPCP(ExceCptDr,1),"^",2)
    ..s oeoreId=Oew_"||"_OrdSub_"||"_ExceChl
    ..s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
    ..i dhcoreId'="" d
		...s AuditUserDr=$p($G(^DHCOrdExec(dhcoreId)),"^",18)
		...i AuditUserDr'="" d
		....s AuditUser=$P($G(^SSU("SSUSR",AuditUserDr)),"^",2)
		....s ExceUsr=ExceUsr_","_AuditUser
    ..if skintest="Y" d   //liulei 2011-05-05
    ...s dhcoriId=$o(^DHCORDItem(0,Oew_"||"_OrdSub,""))
    ...q:dhcoriId=""
    ...s SkinTestAuditCtcpDr=$P(^DHCORDItem(dhcoriId),"^",13)
    ...i SkinTestAuditCtcpDr'="" d
    ....s ExceUsr=ExceUsr_"/"_$P(^CTPCP(SkinTestAuditCtcpDr,1),"^",2) //liulei 2011-05-05
	..s RowId=Oew_"||"_OrdSub_"||"_ExceChl
	..s ORW=Oew_"||"_OrdSub
    ..s DisIndex=""
    ..s DisIndex=..GetDispIndex(dispstat)
    ..//药物即刻医嘱执行完颜色转变
    ..if (OrdTyp="R")&(OrdStat'="停止")&(ExceCptDr'="")&(PriorCode="STAT") s ColorFlag=0
   	..//seq1_"^"_seq2_"^"_Date_"^"_Extim
   	..//if //d OutRow2(PatName,ArcimDesc,$G(Meth),$G(DoseQty),$G(PHFreq),"","",ORW,$G(Notes),$G(dispstat),DisIndex,ColorFlag,Priority)
   	..s Name=PatName
   	..s Time=ExDateTime
   	..if seq2'=0 d
   	...if ArcimDesc'["●" s ArcimDesc="●"_ArcimDesc
   	...s Name=""
   	...s Time=""
   	..s Count=Count+1
   	..s ORW=RowId
   	..s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",19) i DateEx'="" s DateEx=$ZD(DateEx,3)  ;nursing execute
	..s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",20)  i TimeEx'=""  s TimeEx=$ZT(TimeEx,2)
	..s DatExTim=$G(DateEx)_" "_$G(TimeEx)  //执行日期 时间
	.. //停止医嘱处理
	..if StopStr'="" d
	...s dispdate=$P(StopStr,"|"),disptime=$P(StopStr,"|",2),dispnur=$P(StopStr,"|",3)
	...if ExceUsr="" s ExceUsr=dispnur, DatExTim=dispdate_""_disptime
   	..s sort(seq1,$G(ExDateTime))=$G(sort(seq1,$G(ExDateTime)))+1
   	..if seq2'="0" s seq=seq1_"."_(sort(seq1,$G(ExDateTime))-1)  //seq1  //seq2
   	..e  s seq=seq1
   	..s ColorFlag=..GetColorFlag(dispstat,Priority)
   	..
   	..s ^OrdSubExec("tem",UserId,Date,Num(ExDate,seq1,OrdSub),seq1,seq2,Count)=$LB(Name,ArcimDesc,$G(Meth),$G(DoseQty),$G(PHFreq),$G(Time),$G(ExceUsr),ORW,$G(Notes),$G(dispstat),DisIndex,ColorFlag,Priority,seq1,seq,DatExTim,OrdStat) //d OutRow2("","","",$G(DoseQty),"",$G(ExDateTime),$G(ExceUsr),RowId,$G(Notes),$G(dispstat),DisIndex,ColorFlag,Priority)
  
   ///////////////////////////////////////////////////////////
    s Date=""  f  s Date=$O(^OrdSubExec("tem",UserId,Date)) q:Date=""  d
    .s Extim=""  f  s Extim=$O(^OrdSubExec("tem",UserId,Date,Extim)) q:Extim=""  d
    ..s seq1=""  f  s seq1=$O(^OrdSubExec("tem",UserId,Date,Extim,seq1)) q:seq1=""  d
    ...s seq2=""  f  s seq2=$O(^OrdSubExec("tem",UserId,Date,Extim,seq1,seq2)) q:seq2=""  d
    ....s OrdSub="" f  s OrdSub=$O(^OrdSubExec("tem",UserId,Date,Extim,seq1,seq2,OrdSub)) q:OrdSub=""  d
    .....s Data=^OrdSubExec("tem",UserId,Date,Extim,seq1,seq2,OrdSub)
    .....d OutRow2(Data)
    /////////////////////////////////////////////////////////////////////
    f Date=DefStDate:1:DefEnDate d
    .s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"StDt",Date,Oew,OrdSub)) q:OrdSub=""  d
	..s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)
	..q:PHFreqDR'=""
	..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期?
	..s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	..s StDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)  ;要求执行日期?
	..s StTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)
	..s StDtTim=(StDate_","_StTime)
	..s StDtTim=..GetAbsTime(StDtTim)
	..s Meth="",DoseQty="",PHFreq=""
	..s OrdStatusDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)
	..s dispstat=""
	..s OrdStatus="^"_OrdStatusDR_"^"
	..if (DefOrdStat'[OrdStatus)&(DefOrdStat'="") q
	..s OrdStat=$P(^OEC("OSTAT",OrdStatusDR),"^",2)
	..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	..i PriorDR="" q //
	..s Prior="^"_PriorDR_"^"
	..s PriorCode=$P(^OECPR(PriorDR),"^",1)
	..if (DefOrdPrior'[Prior)&(DefOrdPrior'="") q
	..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2) 
	..e  q     ///PriorDR --10--自备药长期医嘱
	..s Priority=PriorDes
	..s PriorDes="^"_PriorDes_"^"
	..//q:(^DHCOEOrdPrintSet("L","OrdTyp")'[PriorDes)&(longord="true")&(lsord'="true")
	..//q:(^DHCOEOrdPrintSet("OrdTyp")'[PriorDes)&(lsord="true")&(longord'="true")
	..s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	..s ARCIMRowid=$P(ArcimDR,"||",1)
	..s ARCIMSub=$P(ArcimDR,"||",2) 
	..s ArcimDesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)
	..s ArcimDesc=$TR(ArcimDesc,":"," ")
	..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	..q:(ItemCatDR="")
	..s OrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)    ;ARc_Itemcat
	..s ExceCatDr=$P(^ARC("IC",ItemCatDR),"^",9) 
	..s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
	..//s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
	..//q:(PHFreqDR'="")&&(Priority'="临时医嘱")  //by liulei 20091217
    ..//if OrdTyp="R" q   ///药物医嘱不往下走
	..if (OrdTyp'="R")&((StDtTim<DefOrdStDatTim)!(StDtTim>DefOrdEndDatTim)) q
	..if ExceCatDr'=""  s ExceCat=$P(^OEC("EXEC",ExceCatDr),"^",1) //是否执行类
	..s CatDR="^"_OrdCatDR_"^"
    ..if VarTyp'="" s CatDR="^"_ItemCatDR_"^"
    ..if (DefOrdCat'[CatDR)&(DefOrdCat'="") q
	..//i (OrdCatDR'=OECCat)&(OECCat'="") q
	..s Notes=""
	..i $G(Notes)="" s Notes=""
    ..f rnum=1:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	...s Notes=Notes_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
	..s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
	..s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
	..q:user=""
	..q:'$D(^SSU("SSUSR",user))
	..if Notes'=""  s Notes=$TR(Notes,":","*")
	..s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	..q:DoctorDr=""  ;s Notes=$G(^OEORD(Oew,"I", OrdSub,"DEP",1))
	..s truedoc=0
	..s DocLoc="" //2005-12-3 qse add///////////////////////////////////////
	..i DoctorDr'=""  s Doctor=$P(^CTPCP(DoctorDr,1),"^",2) ;write doctor oeori_doctor_dr
	..e  s Doctor=""
    ..if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
	..if '$D(^CT("CPT",CpTypDR)) //w !,DoctorDr
	..q:'$D(^CT("CPT",CpTypDR))
	..i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp	..s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
   	..//q:CpTyp="NURSE" //add by liulei 20091217
   	..s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
    ..i (PHFreqDR'="") d
	...s PHFreq=$P($G(^PHCFR(PHFreqDR)),"^",3) 
	..e  s PHFreq=""  ;table       PHC_Freq
	..s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3  ) ;CT_UOM                      OEORI_Unit_DR
	..i UOMDR'="" s UOM=$P(^CT("UOM",UOMDR),"^",2)  
	..e  s UOM="" 
	..s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
    ..if (DoseQty'="")&($P(DoseQty,".")="") s DoseQty="0"_DoseQty_UOM
	..if DoseQty'="" s DoseQty=DoseQty_UOM
	..s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
	..s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	..if MethDR'="" s Phcin="^"_MethDR_"^"
	..if ($G(Phcin)'="")&(DefOrdPhcin'[$G(Phcin))&(DefOrdPhcin'="") q
	..i MethDR'="" s Meth=$P(^PHCIN(MethDR),"^",2)  
	..s StopStr=..SingNur(Oew,OrdSub)
	..s count=0
	..s Discon=""
	..s RefusePhFlag=""
	..//if OrdStat="停止" s Discon=##class(web.DHCPdaComm).GetDisconFlag(Oew,OrdSub) 
	..//if OrdTyp="R"  s RefusePhFlag=##class(web.DHCPdaComm).GetPhRefuseFlag(Oew,OrdSub)
	..if (OrdTyp'="R")&((StDtTim<DefOrdStDatTim)!(StDtTim>DefOrdEndDatTim)) q
	..//s ColorFlag=..GetOrdColor(OrdStat,OrdTyp,PriorCode,RefusePhFlag,StopStr,OrdSub)
    ..//if OrdSub=431 b
	..s ExceChl=0,ExceChl=$O(^OEORD(Oew,"I",OrdSub,"X",ExceChl))
	..s ExceUsr="",DatExTim=""
    ..if ExceChl'="" d
    ...s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",19) i DateEx'="" s DateEx=$ZD(DateEx,3)  ;nursing execute
	...s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",20)  i TimeEx'=""  s TimeEx=$ZT(TimeEx,2)
	...s DatExTim=$G(DateEx)_" "_$G(TimeEx)  //执行日期 时间
    ...s ExceCptDr=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",15)
    ...if ExceCptDr'="" s ExceUsr=$P(^CTPCP(ExceCptDr,1),"^",2)
    ...s oeoreId=Oew_"||"_OrdSub_"||"_ExceChl
    ...s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
    ...i dhcoreId'="" d
		....s AuditUserDr=$p($G(^DHCOrdExec(dhcoreId)),"^",18)
		....i AuditUserDr'="" d
		.....s AuditUser=$P($G(^SSU("SSUSR",AuditUserDr)),"^",2)
		.....s ExceUsr=ExceUsr_","_AuditUser
	..s dispstat=""
	..s skintest=$p($g(^OEORD(Oew,"I",OrdSub,5)),"^",2)
	..s oecprCode=$P(^OECPR(PriorDR),"^",1)
	..if ^DHCOEOrdPrintSet("L","OrdTyp")[PriorDes s dispstat=dispstat_"长 "
	..if ^DHCOEOrdPrintSet("OrdTyp")[PriorDes s dispstat=dispstat_"临 "
	..if (OrdStat="停止")&(StopStr="") s dispstat=dispstat_"停止需处理"
	..if (OrdStat="停止")&(StopStr'="") s dispstat=dispstat_"停止已处理"
	..if (OrdStat'="停止")&($G(ExceUsr)="") s dispstat=dispstat_"未执行"
	..if (OrdStat'="停止")&($G(ExceUsr)'="") s dispstat=dispstat_"已执行"
	..if skintest="Y" d
	...s dispstat=dispstat_" 皮试"
	...s SkinFlag=$p(^OEORD(Oew,"I",OrdSub,11),"^",3)
	...if (SkinFlag="Y")&(dispstat["已执行") s dispstat=dispstat_"(+)"
	...e  s dispstat=dispstat_"(-)"
	...s dhcoriId=$o(^DHCORDItem(0,Oew_"||"_OrdSub,""))
	...q:dhcoriId=""
	...s SkinTestAuditCtcpDr=$P(^DHCORDItem(dhcoriId),"^",13)
	...s SkinTestAuditCtcpDr=""
	...i SkinTestAuditCtcpDr'="" d
	....s ExceUsr=ExceUsr_"/"_$P(^CTPCP(SkinTestAuditCtcpDr,1),"^",2)
	..s flow=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",22) ;长期医嘱开医嘱日期
    ..q:(flow'="")&(scroll'="true")&(OrdStat'="停止")
    ..if flow'="" s dispstat=dispstat_" 滚"
    ..q:(Excute="true")&(UnExcute'="true")&(dispstat["未执行")
    ..q:(Excute="true")&(UnExcute'="true")&(dispstat["需处理")
    ..q:(UnExcute="true")&(Excute'="true")&(dispstat["已执行")
    ..q:(UnExcute="true")&(Excute'="true")&(dispstat["已处理")
    ..s RowId=Oew_"||"_OrdSub
    ..s ExDateTime=""
    ..s DisIndex=0
    ..s DisIndex=..GetDispIndex(dispstat)
    ..s seqno=..GetSeqno(Oew,OrdSub)
    ..//q:$P(seqno,"^",2)'=0
    ..s seq1=$P(seqno,"^",2)   //$P(seqno,"^",1)
    ..s seq2=$P(seqno,"^",1)    //$P(seqno,"^",2)
    ..s ColorFlag=..GetColorFlag(dispstat,Priority)
    ..s Data=$LB(PatName,ArcimDesc,$G(Meth),$G(DoseQty),$G(PHFreq),$G(ExDateTime),$G(ExceUsr),RowId,$G(Notes),$G(dispstat),DisIndex,ColorFlag,Priority,seq1,seq2,DatExTim,OrdStat)
    ..d OutRow2(Data)
    }
OutRow2(Data)  //ArcimDesc,Meth,Dose,Freq,StDateTime,RowId,Mem
	//set Data=$lb(PatName,ArcimDesc,Meth,DoseQty,PHFreq,ExDateTime,ExceUsr,RowId,Notes,dispstat,DisIndex,ColorFlag,Priority)
 	Set ^CacheTemp(repid,ind)=Data
 	s ^TMP("jj",ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetColorFlag(disp, prior) As %String
{
  n (disp, prior)
   s color="252,121,3"
   if (disp["长")&(disp["未执行")&(disp'["滚")  s color="255,128,128" ///新开长嘱
   if (disp["临")&(disp["未执行")&(prior["临") s color="255,255,128"  //新开临嘱
   if (disp["临")&(disp["未执行")&(prior["即")   s color="0,192,0" //新开即刻
   if (disp["停止需处理")  s color="0,192,192" //停止需处理
   if (disp["停止已处理") s color="128,128,255"
   if (disp["皮试") s color="255,0,0"
   if (disp["已执行") s color="192,192,255"
   q color
}

ClassMethod GetSeqno(Oew, OrdSub) As %String
{
  //医嘱关联号
	n (Oew,OrdSub)
	s seq1=0,seq2=0
	if $G(^TMP("Hospital"))'="AZ"  d
	.s seqno=$P($G(^OEORD(Oew,"I",OrdSub,11)),"^",39) //trakcare 
	.if seqno'="" d
	..s seq1=$P(seqno,"||",2)
	..s seq2=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)
	.e  d
	..s seq2=0
	..s seq1=OrdSub 
    if $G(^TMP("Hospital"))="AZ"  d
	.s seqno=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)
	.if $P(seqno,".",2)'="" d
	..s seq1=$P(seqno,"."),seq2=$P(seqno,".",2)
	.e  s seq1=seqno,seq2=0
 q seq1_"^"_seq2
}

ClassMethod GetOrdColor(OrdStat, OrdType, PriorCode, RefusePhFlag, NurStp, OrdSub) As %String
{
  n (OrdStat,OrdType,PriorCode,RefusePhFlag,NurStp,OrdSub)
  s flag="White"
  s TM("White")=0
  s TM("Yellow")=1
  s TM("Green")=2
  s TM("Pink")=6
  s TM("GrassGr")=3
  s TM("Red")=4
  s TM("Blue")=5
  s TM("Purple")=7
  if (OrdType="L")&(PriorCode="STAT") s flag="Yellow"
  if (OrdType="R")&(PriorCode="STAT") s flag="Green"
  if (OrdType="R")&(RefusePhFlag="R") s flag="Pink"
  if (OrdType="R")&(PriorCode="ONCE") s flag="GrassGr"
  if (OrdStat="停止")&(NurStp="") s flag="Red"
  if (OrdStat="停止")&(NurStp'="") S flag="Blue"
  q TM(flag)
}

ClassMethod GetAbsTime(dt As %String) As %String
{
 //将日期时间转换成秒
  n (dt)
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

ClassMethod GetDispIndex(disp) As %String
{
   n (disp)
   //s disp="长 已执行 皮试(-)"
  if (disp["长")&(disp'["滚") s item="首次长期医嘱"
  if (disp["滚") s item="滚动医嘱"
  if (disp["临") s item="临时医嘱"
  if (disp["临即") s item="即刻医嘱"
  if (disp["皮试") s item="皮试医嘱" 
  if disp["皮试 (+)" s item="皮试阳性"
  if disp["皮试 (-)" s item="皮试阴性"
  if disp["停止需处理" s item="停止需处理"
  if disp["停止已处理" s item="停止已处理"
  s i=""  f  s i=$O(^DHCPdaOrdItemColor("ItemColor",i)) q:i=""  d
  .if $D(^DHCPdaOrdItemColor("ItemColor",i,item)) s ret=^DHCPdaOrdItemColor("ItemColor",i,item)
  // bif $D(^DHCPdaOrdItemColor("ItemColor",item)) q ^DHCPdaOrdItemColor("ItemColor",item)
 q $G(ret)
}

ClassMethod GetPdaHead() As %String
{
	k ^TMP("PdaHead")
	//标题，列宽，是否显示，位置(左 中 右)，绑定字段,实际的位置
	s ^TMP("PdaHead",1, "Select")="选择^60^Y^1^"
	s ^TMP("PdaHead",2, "seqno")="关联^70^Y^3^seq2^14"
	s ^TMP("PdaHead",3, "PatName")="姓名^110^Y^1^PatName^0"
	s ^TMP("PdaHead",4, "ArcimDesc")="医    嘱^300^Y^3^ArcimDesc^1"
	s ^TMP("PdaHead",5, "FreqTim")="时间^80^Y^1^FreqTim^5"
	s ^TMP("PdaHead",6, "ExceUsr")="执行人^100^Y^1^ExceUsr^6"
	s ^TMP("PdaHead",7, "DatExTim")="执行时间^120^Y^3^DatExTim^15"
	s ^TMP("PdaHead",8, "Meth")="用法^80^Y^1^Meth^2"
	s ^TMP("PdaHead",9, "Dose")="剂量^80^Y^1^Dose^3"
	s ^TMP("PdaHead",10, "Freq")="频次^80^Y^1^Freq^4"
	s ^TMP("PdaHead",11, "RowId")="RowId^0^Y^1^RowId^7"
	s ^TMP("PdaHead",12, "Note")="备  注^80^Y^1^Note^8"
	s ^TMP("PdaHead",13, "Priority")="优先级^120^Y^3^Priority^12"
	s ^TMP("PdaHead",14, "DispStat")="处置状态^120^Y^3^DispStat^9"
	s ^TMP("PdaHead",15, "DisIndex")="disind^0^Y^3^DisIndex^10"
	s ^TMP("PdaHead",16, "ColorFlag")="ColorFlag^0^Y^3^ColorFlag^11"
	s ^TMP("PdaHead",17, "seqno")="seq^0^Y^3^seq^13"
	s ^TMP("PdaHead",18, "OrdStat")="医嘱状态^120^Y^3^OrdStat^16"
	
	s valStr=""
	s rw=""  f  s rw=$O(^TMP("PdaHead",rw)) q:rw=""  d
	.s val=""  f  s val=$O(^TMP("PdaHead",rw,val)) q:val=""  d
	..s valStr=valStr_^TMP("PdaHead",rw,val)_"$"
  q valStr
}

ClassMethod Get90PdaHead() As %String
{
	k ^TMP("PdaHead")
	//标题，列宽，是否显示，位置(左 中 右)，绑定字段,实际的位置
	s ^TMP("PdaHead",1, "Select")="选择^30^Y^1^"
	s ^TMP("PdaHead",2, "seqno")="关联^35^Y^3^seq2^14"
	s ^TMP("PdaHead",3, "PatName")="姓名^45^Y^1^PatName^0"
	s ^TMP("PdaHead",4, "ArcimDesc")="医    嘱^200^Y^3^ArcimDesc^1"
	s ^TMP("PdaHead",5, "FreqTim")="时间^80^Y^1^FreqTim^5"
	s ^TMP("PdaHead",6, "ExceUsr")="执行人^100^Y^1^ExceUsr^6"
	s ^TMP("PdaHead",7, "DatExTim")="执行时间^120^Y^3^DatExTim^15"
	s ^TMP("PdaHead",8, "Meth")="用法^80^Y^1^Meth^2"
	s ^TMP("PdaHead",9, "Dose")="剂量^80^Y^1^Dose^3"
	s ^TMP("PdaHead",10, "Freq")="频次^80^Y^1^Freq^4"
	s ^TMP("PdaHead",11, "RowId")="RowId^0^Y^1^RowId^7"
	s ^TMP("PdaHead",12, "Note")="备  注^80^Y^1^Note^8"
	s ^TMP("PdaHead",13, "Priority")="优先级^120^Y^3^Priority^12"
	s ^TMP("PdaHead",14, "DispStat")="处置状态^120^Y^3^DispStat^9"
	s ^TMP("PdaHead",15, "DisIndex")="disind^0^Y^3^DisIndex^10"
	s ^TMP("PdaHead",16, "ColorFlag")="ColorFlag^0^Y^3^ColorFlag^11"
	s ^TMP("PdaHead",17, "seqno")="seq^0^Y^3^seq^13"
	s ^TMP("PdaHead",18, "OrdStat")="医嘱状态^120^Y^3^OrdStat^16"
	
	s valStr=""
	s rw=""  f  s rw=$O(^TMP("PdaHead",rw)) q:rw=""  d
	.s val=""  f  s val=$O(^TMP("PdaHead",rw,val)) q:val=""  d
	..s valStr=valStr_^TMP("PdaHead",rw,val)_"$"
  q valStr
}

ClassMethod GetPatOrdItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatOrdItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetPatOrdItem(WardLoc As %String, Adm As %String, Excute As %String, UnExcute As %String, scroll As %String, UserId As %String, VarTyp As %String) As %Query(ROWSPEC = "PatName,ArcimDesc,Meth,Dose,Freq,FreqTim,ExceUsr,RowId,Note,DispStat,DisIndex,ColorFlag,Priority,seq,seq2,DatExTim,OrdStat")
{
}

ClassMethod GetXDtim(Oew, OrdSub) As %String
{
	  n (Oew,OrdSub)
	  ; ^OEORD({OE_Order.OEORD_RowId},"I",{OE_OrdItem.OEORI_Childsub}, "ST",{ST_Childsub})
	   s STR=""
	   s chl=""  f  s chl=$O(^OEORD(Oew,"I",OrdSub, "ST",chl)) q:chl=""  d
	   .s statDR=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",3)
	   .s xdate=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",1)
	   .s xtime=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",2)
	   .s cdoc=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",4)
	   .if (statDR=4)&(cdoc="") s STR=xdate_"|"_xtime_"|"_""
	   .i (statDR=4)&((cdoc'=""))  s STR=xdate_"|"_xtime_"|"_$P(^SSU("SSUSR",cdoc),"^",2)
	   q $G(STR)
}

ClassMethod GetOrdNo(Adm As %String) As %String
{
	;w ##class(web.DHCNURPDAQUEXCUTE).GetOrdNo("2457776")
   s count=0 //记录未执行医嘱数
   s Oew=$O(^OEORD(0,"Adm",Adm,""))
   q:Oew="" 0
   //s StDate=+$h-1,EnDate=+$h
   //f Date=StDate:1:EnDate d
   s Date=+$h
   s Extim="" f  s Extim=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim)) q:Extim=""  d
   .s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim,OrdSub)) q:OrdSub=""  d
   ..s SeqNo=$P(^OEORD(Oew,"I",OrdSub,3),"^",4)
   ..q:(SeqNo[".")
   ..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8) 
   ..q:PriorDR="" 
   ..s PriorDes=$P(^OECPR(PriorDR),"^",2)
   ..q:PriorDes="取药医嘱"
   ..s MethDr=$p(^OEORD(Oew,"I",OrdSub,2),"^",7)
   ..s MethId="^"_^DHCCLNurseExec("VarDef","CQSYD","PhcIn")_"^"_^DHCCLNurseExec("VarDef","SYD","PhcIn")_"^"
   ..q:MethId'[("^"_MethDr_"^")
   ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(Oew_"||"_OrdSub)
   ..q:ordStatCode="D" //跳过停止医嘱
   ..//s subcat=##class(web.DHCSETIMAGE).GetItemCatDr(Oew,OrdSub)
   ..//s oecatId="^"_$g(^DHCCLNurseExec("VarDef","drSYD*","OrCat"))_"^"  //医嘱子类
   ..s ExceChl=""  f  s ExceChl=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim,OrdSub,ExceChl)) q:ExceChl=""  d
   ...s ExceStr=..GetExcuteStr(Oew,OrdSub,ExceChl)
   ...q:ExceStr=1
   ...s count=count+1
   ..
   .
   q count
}

ClassMethod GetOrdExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	if Adm="" 	Quit $$$OK
 	s Date=$P($h,",",1)
 	s Oew=$O(^OEORD(0,"Adm",Adm,""))
 	if Oew="" Quit $$$OK
 	s Date=+$h
    s Extim="" f  s Extim=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim)) q:Extim=""  d
    .s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim,OrdSub)) q:OrdSub=""  d
    ..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8) 
    ..q:PriorDR="" 
    ..s PriorDes=$P(^OECPR(PriorDR),"^",2)
    ..q:PriorDes="取药医嘱"
    ..s MethDr=$p(^OEORD(Oew,"I",OrdSub,2),"^",7)
    ..s MethId="^"_^DHCCLNurseExec("VarDef",0,"CQSYD","PhcIn")_"^"_^DHCCLNurseExec("VarDef",0,"SYD","PhcIn")_"^"
    ..q:MethId'[("^"_MethDr_"^")
    ..s Meth=$P(^PHCIN(MethDr),"^",2)
    ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(Oew_"||"_OrdSub)
    ..q:ordStatCode="D" //跳过停止医嘱
    ..s ArcimDR=$P(^OEORD(Oew,"I",OrdSub,1),"^",2)
    ..s ARCIMRowid=$P(ArcimDR,"||",1)
	..s ARCIMSub=$P(ArcimDR,"||",2)
	..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)
    ..s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
    ..q:OrdTyp'="R" //非药品医嘱
	..s ArcimDes=$P(^ARCIM(ARCIMRowid,ARCIMSub,1),"^",2)
    ..s SeqNo=$P(^OEORD(Oew,"I",OrdSub,3),"^",4)
    ..i SeqNo["." s ArcimDes="●"_ArcimDes
    ..s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)
    ..s UomDr=$P(^OEORD(Oew,"I",OrdSub,2),"^",3)
    ..i UomDr'="" s Uom=$P(^CT("UOM",UomDr),"^",2)
    ..i DoseQty'="" s Dose=DoseQty_Uom
    ..e  s Dose="0"_Uom
    ..s PHFreqDr=$P(^OEORD(Oew,"I",OrdSub,2),"^",4)
    ..q:PHFreqDr=""
    ..s PHFreq=$P(^PHCFR(PHFreqDr),"^",3)
    ..s PriorityDr=$P(^OEORD(Oew,"I",OrdSub,1),"^",8) 
    ..q:PriorityDr=""
    ..s Priority=$P(^OECPR(PriorityDr),"^",2)
    ..s ExecUser="",ExecDatTim=""
    ..s ExceChl=""  f  s ExceChl=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim,OrdSub,ExceChl)) q:ExceChl=""  d
    ...s ExecUserDr=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",15)
    ...s ExecDate=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",19)
    ...s ExecTime=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",20) 
    ...i ExecUserDr'="" d
    ....s ExecUser=$P(^CTPCP(ExecUserDr,1),"^",2)
    ....s ExecDatTim=$ZD(ExecDate,3)_" "_$ZT(ExecTime)
    ...d OutRow3
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow3
    Set Data=$LB($G(SeqNo),$G(ArcimDes),$G(ExecUser),$G(ExecDatTim),$G(Dose),$G(Meth),$G(PHFreq),$G(Priority))   
    Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetOrd(Adm As %String) As %Query(ROWSPEC = "SeqNo,ArcimDes,ExecUser,ExecDatTim,Dose,Meth,PHFreq,Priority")
{
}

Query GetPhaOrd(Adm As %String) As %Query(ROWSPEC = "SeqNo,ArcimDes,ExecUser,ExecDatTim,Dose,Meth,PHFreq,Priority")
{
}

ClassMethod GetPhaOrdExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	if Adm="" 	Quit $$$OK
 	s Date=$P($h,",",1)
 	s Oew=$O(^OEORD(0,"Adm",Adm,""))
 	q:Oew=""
 	s Date=+$h
    s Extim="" f  s Extim=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim)) q:Extim=""  d
    .s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim,OrdSub)) q:OrdSub=""  d
    ..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8) 
    ..q:PriorDR="" 
    ..s PriorDes=$P(^OECPR(PriorDR),"^",2)
    ..q:PriorDes="取药医嘱"
    ..s MethDr=$p(^OEORD(Oew,"I",OrdSub,2),"^",7)
    ..s MethId="^"_^DHCCLNurseExec("VarDef",0,"KFD","PhcIn")_"^"
    ..q:MethId'[("^"_MethDr_"^")
    ..s Meth=$P(^PHCIN(MethDr),"^",2)
    ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(Oew_"||"_OrdSub)
    ..q:ordStatCode="D" //跳过停止医嘱
    ..s ArcimDR=$P(^OEORD(Oew,"I",OrdSub,1),"^",2)
    ..s ARCIMRowid=$P(ArcimDR,"||",1)
	..s ARCIMSub=$P(ArcimDR,"||",2)
	..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)
    ..s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
    ..q:OrdTyp'="R" //非药品医嘱
	..s ArcimDes=$P(^ARCIM(ARCIMRowid,ARCIMSub,1),"^",2)
    ..s SeqNo=$P(^OEORD(Oew,"I",OrdSub,3),"^",4)
    ..i SeqNo["." s ArcimDes="●"_ArcimDes
    ..s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)
    ..s UomDr=$P(^OEORD(Oew,"I",OrdSub,2),"^",3)
    ..i UomDr'="" s Uom=$P(^CT("UOM",UomDr),"^",2)
    ..i DoseQty'="" s Dose=DoseQty_Uom
    ..e  s Dose="0"_Uom
    ..s PHFreqDr=$P(^OEORD(Oew,"I",OrdSub,2),"^",4)
    ..q:PHFreqDr=""
    ..s PHFreq=$P(^PHCFR(PHFreqDr),"^",3)
    ..s PriorityDr=$P(^OEORD(Oew,"I",OrdSub,1),"^",8) 
    ..q:PriorityDr=""
    ..s Priority=$P(^OECPR(PriorityDr),"^",2)
    ..s ExecUser="",ExecDatTim=""
    ..s ExceChl=""  f  s ExceChl=$O(^OEORDi(0,"NotExecE",Oew,Date,Extim,OrdSub,ExceChl)) q:ExceChl=""  d
    ...s ExecUserDr=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",15)
    ...s ExecDate=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",19)
    ...s ExecTime=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",20) 
    ...i ExecUserDr'="" d
    ....s ExecUser=$P(^CTPCP(ExecUserDr,1),"^",2)
    ....s ExecDatTim=$ZD(ExecDate,3)_" "_$ZT(ExecTime)
    ...d OutRow4
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow4
    Set Data=$LB($G(SeqNo),$G(ArcimDes),$G(ExecUser),$G(ExecDatTim),$G(Dose),$G(Meth),$G(PHFreq),$G(Priority))   
    Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPhaOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhaOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetPhaOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhaOrdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="DHCNURPDAQUEXCUTEDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCNURPDAQUEXCUTED</DataLocation>
<DefaultData>DHCNURPDAQUEXCUTEDefaultData</DefaultData>
<IdLocation>^web.DHCNURPDAQUEXCUTED</IdLocation>
<IndexLocation>^web.DHCNURPDAQUEXCUTEI</IndexLocation>
<StreamLocation>^web.DHCNURPDAQUEXCUTES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

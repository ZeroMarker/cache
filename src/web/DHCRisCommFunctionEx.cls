Import SQLUser

/// action patient data from TrakCare
/// 2014-06-19--sunyi
/// 修改 VeriedOrditem函数 修正了取消登记更新 停医嘱日期与时间错误
/// 增加 医生站判断护士打印预约单接口NursePrintFlag
/// 类 web.DHCRisCommFunctionEx
/// 功能说明：封装病人信息的业务数据的类，包括病人的基本信息，医嘱信息等等
/// 作者：龚平
/// 日期：2007-03-02
/// 
Class web.DHCRisCommFunctionEx Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 257;

/// 函数名称：GetPaadmInfo
/// 功能：根据PAADM.ROWID 获得病人的基本信息
/// 输入参数：Pa_adm.rowid
/// 返回：病人的基本信息
/// 作者：龚平
/// 日期：2007-03-02
/// w ##class(web.DHCRisCommFunctionEx).GetPaadmInfo("464")
ClassMethod GetPaadmInfo(paadmdr As %String) As %String
{
     n (paadmdr)
     s (RegNo,Name,strDOB,strAge,SexDesc,patienttype,typedesc,LocName,IPNO,wardname,bedname,Locdr,SexDr,WardDr)=""
     s (roomdesc,feetype,Docdr,DocName,Telphone,Height,Weight,Adress,SafetynetCardNo,papatmasmdr,WorkUnit)=""
     s (ID1,OccupationDR,OccupationDesc,beddr,AdmDate,AdmTime,OPNO,MedicareNo,InsuraceNo,CardNo,feetypeCode,PinYin)=""
     s (SSURowid,AppLocDR,AppLocName,DHCRisSystemInfo,DHCRisVersion,Admloc,EpissubtypeDR,Epissubtype,stay,UseKnowledge)=""
     s ^TEMPDHCRis("GetPaadmInfo")=paadmdr
     if (paadmdr'="")
     {
       i $d(^PAADM(paadmdr))
       {
       s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
       ;s ^DHCRISTEMP("papatmasmdr")=papatmasmdr_"^"_paadmdr        
       s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
       ;q:RegNo=""  
       s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
       s PinYin=..HZtoPin(Name)
       s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
       s CardNo=""
       i papatmasmdr'="" s CardNo=..GetCardNobyPatDR(papatmasmdr)
       i $g(^PAPER(papatmasmdr,"PAT",3))'="" d
     	 .s SafetynetCardNo=$p(^PAPER(papatmasmdr,"PAT",3),"^",4)
       i DOB="" d
 	 	.s strDOB=""
 	 	.s strAge=""
 	   e  d
        .;s strDOB=$ZD(DOB,3)
        .s strDOB=##class(websys.Conversions).DateLogicalToHtml(DOB)
        .;s strToday=$ZD(+$h,3)
        .;s strAge=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
        .s strAge= ##class(web.DHCBillInterface).GetPapmiAge(papatmasmdr,paadmdr) //##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
        .;s year=$p(strDOB,"-",1)
        .;s Month=$p(strDOB,"-",2)
        .;s day=$p(strDOB,"-",3)
        .;s strDOB=day_"/"_Month_"/"_year
       s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
       i SexDr'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)
       s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
       s typedesc=##class(web.DHCRisCommFunction).GetTypeDesc(patienttype)
       ;s ExitCls=..IsValidClassName("web.DHCBillInterface")
       ;i ExitCls=1 s strAge=##class(web.DHCBillInterface).GetPapmiAge(papatmasmdr,paadmdr)
  	   s Locdr=$p(^PAADM(paadmdr),"^",4)
  	   s AdmDate=$p(^PAADM(paadmdr),"^",6)
  	   s AdmDate=$zd(AdmDate,3)
  	   s AdmTime=$p(^PAADM(paadmdr),"^",7)
  	   s AdmTime=$zt(AdmTime,1)
       i $g(Locdr)'="" d
       .s LocName=$p(^CTLOC(Locdr),"^",2)
       .i $f(LocName,"-")>0 d
       ..s LocName=$p(LocName,"-",2)
       ..s Admloc=LocName
       s IPNO=##class(web.DHCRisCommFunctionEx).GetIPNO(papatmasmdr)   //获得住院号
       s OPNO=$p($g(^PAPER(papatmasmdr,"PER",4)),"^",4) 
       s Roomdr=$p(^PAADM(paadmdr),"^",69)
       i Roomdr'="" s roomdesc=$p(^PAROOM(Roomdr),"^",2)
       s WardDr=$p(^PAADM(paadmdr),"^",70)
       i WardDr'=""  d
       .s wardname=$p(^PAWARD(WardDr),"^",2)
       .s wardname1=$p(wardname,"-",2)
       .i wardname1="" s wardname1=$p(wardname,"-",1)
       .s wardname=wardname1
       s EpissubtypeDR=$p(^PAADM(paadmdr,1),"^",6)
	   i EpissubtypeDR'="" d 
	   .s Epissubtype=$p($g(^PAC("SUBT",EpissubtypeDR)),"^",2)
       s DHCRisSystemInfo=##class(web.DHCRisCodeTableAdd).GetSystemParam()
       s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
       s UseKnowledge=$P($g(DHCRisSystemInfo),"^",19)
       i (DHCRisVersion="BJ_XH")
       {
	      i patienttype="I" d
	      .s LocName=wardname 
	      i (EpissubtypeDR="8")!(EpissubtypeDR="10")
	      {
		     s Epissubtype="特需" 
		  }
	   }
	   
	   s patlvlinfo="",EncryptLevel="",PatLevel=""
	   s patlvlinfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papatmasmdr,.ErrMsg)   //7.2以下老库没有此函数
   	   i patlvlinfo'="" d
       .s EncryptLevel=$p(patlvlinfo,"^",1)   //保密级别
       .s PatLevel=$p(patlvlinfo,"^",2)       //病人级别
	   s stay =##class(web.DHCADMVisitStat).GetPatCurStat(paadmdr) 
	   i stay'="" s stay=$zcvt($p(stay,"^",1),"U")
       s beddr=$p(^PAADM(paadmdr),"^",73)
       s bedname=""
       i beddr'=""  d 
       .s wardrowid=$p(beddr,"||",1)
       .s bedchildsub=$p(beddr,"||",2)
       .i $g(bedchildsub)'="" s bedname=$p($g(^PAWARD(wardrowid,"BED",bedchildsub)),"^",1)
       s admreasondr=$p(^PAADM(paadmdr,1),"^",7)
       i admreasondr'="" d
       .s feetypeCode=$p(^PAC("ADMREA",admreasondr),"^",1) 
       .s feetype=$p($g(^PAC("ADMREA",admreasondr)),"^",2)   ;费别
       ;s Docdr=$p(^PAADM(paadmdr),"^",9) ;;benna added
       ;i $g(Docdr)'="" s DocName=$p($g(^CTPCP(Docdr,1)),"^",2)
       s OrdRowid="",ChildsubID=""
       s OrdRowid=$o(^OEORD(0,"Adm",paadmdr,OrdRowid))
       i OrdRowid'="" s ChildsubID=$o(^OEORD(OrdRowid,"I",ChildsubID),-1)
       i ChildsubID'="" s Docdr=$p($g(^OEORD(OrdRowid,"I",ChildsubID,1)),"^",11) ;下医嘱医生
       i Docdr'="" s DocName=$p(^CTPCP(Docdr,1),"^",2) 
       i $g(Docdr)'="" d
	   .s SSURowid=$o(^SSU("SSUSR",0,"CTPCP",Docdr,-1))
	   .i SSURowid'="" s AppLocDR=$p($g(^SSU("SSUSR",SSURowid)),"^",4)
	   .i AppLocDR'="" s AppLocName=$p($g(^CTLOC(AppLocDR)),"^",2)
	   .i $f(AppLocName,"-")>0 d
	   ..s AppLocName=$p(AppLocName,"-",2)
       ;s DocName=..GetAppDocbyAdm(paadmdr) ;sy
       s mradmdr=$p(^PAADM(paadmdr),"^",61)
       i $g(mradmdr)'="" d
       .s Height=$p(^MR(mradmdr,"PRO",1),"^",20)
       .s Weight=$p(^MR(mradmdr,"PRO",1),"^",27)
       s Telphone=$p($g(^PAPER(papatmasmdr,"PER",1)),"^",11) 
       s Adress=$g(^PAPER(papatmasmdr,"PER","ADD",1)) 
       s WorkUnit=$p($g(^PAPER(papatmasmdr,"PER",4)),"^",18)   ;工作单位
       ; pa_person set paper_id=:ID1,paper_telh=:TelNo,paper_stnameline1=:Adress,PAPER_Occupation_DR=:OccupationDR 
       s ID1=$p($g(^PAPER(papatmasmdr,"ALL")),"^",9)  ;身份证
       s OccupationDR="",OccupationDesc=""
       s OccupationDR=$p($g(^PAPER(papatmasmdr,"PER",2)),"^",6)  
       i OccupationDR'="" s OccupationDesc=$p($g(^CT("OCC",OccupationDR)),"^",2)   ;职业 
       ;s MedicareNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",22)  //病历号
       ;i MedicareNo="" s MedicareNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(paadmdr,.ErrMsg)  ;取病案组病案号
       ;s MedicareNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(paadmdr,.ErrMsg)  ;取病案组病案号
       s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadmdr,patienttype,.ErrMsg)
       ;s InsuraceNo=$p($g(^PAPER(papatmasmdr,"ALL")),"^",19)   //医疗保险号
       }
    }
    s Info=RegNo_"^"_Name_"^"_strDOB_"^"_strAge_"^"_$g(SexDesc)_"^"_patienttype_"^"_typedesc_"^"_$g(LocName)_"^"_IPNO_"^"_wardname_"^"_bedname_"^"_$g(Locdr)_"^"_SexDr_"^"_WardDr_"^"_roomdesc_"^"_feetype_"^"_Docdr_"^"_DocName_"^"_Telphone_"^"_Height_"^"_Weight_"^"_Adress_"^"_SafetynetCardNo_"^"_papatmasmdr_"^"_WorkUnit_"^"_ID1_"^"_OccupationDR_"^"_OccupationDesc_"^"_beddr_"^"_AdmDate_"^"_AdmTime_"^"_OPNO_"^"_$g(MedicareNo)_"^"_$g(InsuraceNo)_"^"_CardNo_"^"_feetypeCode_"^"_$g(admreasondr)_"^"_PinYin_"^"_AppLocName_"^"_Admloc_"^"_Epissubtype_"^"_stay_"^"_feetype_"^"_$g(EncryptLevel)_"^"_$g(PatLevel)_"^"_$g(UseKnowledge)
    q Info
}

/// 函数名称：GetDiagnose
/// 功能：根据PAADM.ROWID 获得病人的当前就诊临床诊断
/// 输入参数：Pa_adm.rowid
/// 返回：诊断信息
/// 作者：龚平
/// 日期：2007-03-02
ClassMethod GetDiagnose(paadmdr) As %String
{
	n (paadmdr)
	s admIDCDesc="",IDCDesc="",CodeDesc="",Index=0 
	q:paadmdr="" ""
	if $d(^PAADM(paadmdr))
	{
      s mradmdr=$p(^PAADM(paadmdr),"^",61)
      s diachildsub=0  f  s diachildsub=$o(^MR(mradmdr,"DIA",diachildsub)) q:(diachildsub="")  d
      .s CodeDesc="",mrdesc=""     
      .s Index=Index+1
      .s IDCCodeDR=$p($g(^MR(mradmdr,"DIA",diachildsub)),"^",1)
      .i $g(IDCCodeDR)'=""  d
      ..s CodeDesc=$p($g(^MRC("ID",IDCCodeDR)),"^",2)
      .s ICDCommSub=0
	  .s ICDCommSub=$o(^MR(mradmdr,"DIA",diachildsub,"DES",ICDCommSub))
	  .if ICDCommSub'="" s mrdesc=$p($g(^MR(mradmdr,"DIA",diachildsub,"DES",ICDCommSub)),"^",1)
	  .s IDCDesc=Index_":"_CodeDesc_" "_mrdesc
      .s admIDCDesc=admIDCDesc_" "_IDCDesc
	}
    q admIDCDesc
}

/// 函数名称：GetOeorditminfo
/// 功能：根据医嘱的ROWID 获得医嘱基本信息
/// 输入参数：oeorditem.parref,oeorditem.childsub
/// 返回：医嘱的信息
/// 作者：龚平
/// 日期：2007-03-02
/// 修订:
/// s Info=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(345, 566)
ClassMethod GetOeorditminfo(OrderRowid, itemsub, bodyDR As %String = "") As %String
{
	n (OrderRowid, itemsub,bodyDR)
    s (strOrderName,strDate,strTime,requestdoc,strAccessionNum,SGroupDesc,subCatDesc,CatDesc,ifbed,price)=""
    s (Num,TotalPrice,billed,ItemStatusCode,Date1,Time1,ItemStatusCode,ServerMaterial,RecLocdr,ResultFlag,RecLocDesc,AutoInputFee,EndInputFee,strOrderNameL,BodyDesc)=""
    s (DHCRisVersion,DHCRisSystemInfo,paadmdr,patienttype,CheckEntryFlag,ApptUser,ExterFalg,PaymentDoc,FileVersion,xrowid)=""
    s (BodyPart,ungent,ServerGroupDR,SGInfo)=""
    s BillDesc="未收费"
    ;w !,OrderRowid_"||"_itemsub_"**"_bodyDR
    s oeorditemdr=OrderRowid_"||"_itemsub 
    if (OrderRowid'="")&(itemsub'="")
    {
      if $d(^OEORD(OrderRowid,"I",itemsub,1))
      {
    	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    	q:'$d(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1)) ""
    	s DHCRisSystemInfo=##class(web.DHCRisCodeTableAdd).GetSystemParam()
        s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
        s FileVersion=$p(DHCRisSystemInfo,"^",16)
        i (DHCRisVersion="BJ_XH")
        {
	      //(体位+部位+实际的名称)  
	      s strOrderName=##class(web.DHCRisApplicationBill).GetAppItemName(oeorditemdr)
	      s strOrderNameL=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	      s BodyDesc=$p($g(^DHCRISAPPINFOS("APPLICATIONBILL",oeorditemdr)),"^",5)
    	  i BodyDesc'="" s BodyDesc=..SetSelBodyPart(BodyDesc)
	    }
	    else
	    {
		    s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)  
			if (bodyDR'="")
			{
				s bodyDesc=$p($g(^DHCAPPART(bodyDR)),"^",2)
			}
			if ($g(bodyDesc)'="")
			{
				s strOrderName=strOrderName_"("_bodyDesc_")"
			}
		}
		
        s strEnOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",3)  
        s paadmdr=$p(^OEORD(OrderRowid),"^",1)
        i paadmdr'="" s patienttype=$p(^PAADM(paadmdr),"^",2)  
    	s Date1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  ;医嘱日期 OEORI_Date
		s strDate=##class(websys.Conversions).DateLogicalToHtml(Date1)   ;$zd(Date1,3)
		s Time1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",17) ;医嘱的开始时间
    	s strTime=##class(websys.Conversions).TimeLogicalToHtml(Time1)  ;$zt(Time1,1)
		s RecLocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
		if RecLocdr'="" d
		.s RecLocDesc=$p(^CTLOC(RecLocdr),"^",2)
		.i $f(RecLocDesc,"-")>0 d
		..s RecLocDesc=$p(RecLocDesc,"-",2)
		;s ssusrdr=$p(^OEORD(OrderRowid,"I",itemsub,7),"^",1) ;下医嘱医生
		;if ssusrdr'="" s requestdoc=$p(^SSU("SSUSR",ssusrdr),"^",2)         ; request doctor
		s caredr=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",11) ;下医嘱医生
		if caredr'="" s requestdoc=$p(^CTPCP(caredr,1),"^",2)
		s strAccessionNum=$p($g(^OEORD(OrderRowid,"I",itemsub,8)),"^",19) 
    	;s ServerGroupDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),8),"^",7)
    	;i ServerGroupDR'="" s SGroupDesc=$p($g(^RBC("SG",ServerGroupDR)),"^",2)
    	s SGInfo=..GetServiceGroup(arcimid,bodyDR)
    	;w !,arcimid_"**"_bodyDR_"**"_SGInfo
    	i SGInfo'="" d
    	.s ServerGroupDR=$p($g(SGInfo),"^",1)
    	.s SGroupDesc=$p($g(SGInfo),"^",2)
    	s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
		s OrdCatDr=$p(^ARC("IC",ItmCatDR),"^",8)
		s subCatDesc=$p(^ARC("IC",ItmCatDR),"^",2) ; 医嘱子类
		s CatDesc=$p(^OEC("ORCAT",OrdCatDr),"^",2) ; 医嘱大类
		s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
		i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
		s ifbed=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",16)
    	s DHCRisSystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    	s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    	s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
    	;b //01
    	;s price=##class(web.DHCRisCommFunction).GetItemPrice(oeorditemdr)
	  	;s TotalPrice=price*Num
	  	;i TotalPrice="" s TotalPrice=0
	  	;i bodyDR'="" d
	  	;b //02
	  	s price="",TotalPrice=""
	  	i bodyDR'="" d
	  	.s TotalPrice=##Class(web.DHCAPPInterface).GetExaReqPartCost(oeorditemdr,bodyDR)
	  	.s TotalPrice=$p(TotalPrice,"^",1)
	  	e  d
	  	.s price=##class(web.DHCRisCommFunction).GetItemPrice(oeorditemdr)
	  	.s TotalPrice=price*Num
	  	.i TotalPrice="" s TotalPrice=0
	  	s TotalPrice=TotalPrice_"元"
	  	s BillInfo=""
	  	s BillInfo=..GetBillStatus(OrderRowid,itemsub,FileVersion,ItemStatusCode)
	  	i BillInfo'="" 
	  	{
		  s BillDesc=$p($g(BillInfo),"^",1)
		  s billed=$p($g(BillInfo),"^",2)
		}
		s AutoInputFee=$P($g(^OEORD(OrderRowid,"I",itemsub,"DHC")),"^",25) ;"需要另划价标志"
		s AutoInputFee="Y"
		;i AutoInputFee="Y"
		;{
			;s price=0,Num=0,TotalPrice="0元"	
		;}
		s EndInputFee=$P($g(^OEORD(OrderRowid,"I",itemsub,"DHC")),"^",26)  ;"已另划价标识"
		s CheckEntryFlag=$P($g(^OEORD(OrderRowid,"I",itemsub,"DHC")),"^",30) ;检查已补录标识
		s ResultFlag=$p($g(^OEORD(OrderRowid,"I",itemsub,11)),"^",5)   ;医嘱结果状态
		s ungent=$p($g(^OEORD(OrderRowid,"I",itemsub,11)),"^",55)
		if (ungent="")
		{
			s ungent=##class(web.DHCAPPInterface).GetEmgFlag(oeorditemdr)
		}
		s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
		s ItemCode=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",1)
		s BodyPart=$g(^OEORD(OrderRowid,"I",itemsub,"DEP")) ;取医生站填写的部位
		s ExterFalg=##class(web.DHCRisWorkBenchDoEx).HasExternalBK(oeorditemdr,bodyDR)
		s PaymentDoc=..GetPaymentDoc(oeorditemdr)
		s GetResultFlag=##class(web.DHCRisCommFunctionEx).GetResultFlag(OrderRowid,itemsub)
		
		
      }
    }
	s retinfo=strOrderName_"^"_strDate_"^"_strTime_"^"_requestdoc_"^"_strAccessionNum_"^"_SGroupDesc_"^"_subCatDesc_"^"_CatDesc_"^"_ifbed_"^"_price_"^"_Num_"^"_TotalPrice_"^"_billed_"^"_$g(ItemStatusCode)_"^"_Date1_"^"_Time1_"^"_$g(ItemStatusCode)_"^"_$g(ServerMaterial)_"^"_RecLocdr_"^"_$g(ResultFlag)_"^"_RecLocDesc_"^"_$g(ItemCode)_"^"_$g(ItmCatDR)_"^"_$g(OrdCatDr)_"^"_AutoInputFee_"^"_EndInputFee_"^"_BillDesc_"^"_strOrderNameL_"^"_BodyDesc_"^"_CheckEntryFlag_"^"_ApptUser_"^"_ExterFalg_"^"_PaymentDoc_"^"_BodyPart_"^"_ungent_"^"_ServerGroupDR_"^"_$g(strEnOrderName)_"^"_$g(GetResultFlag)
	q retinfo
}

/// 函数名称：GetRegInfo
/// 功能：根据医嘱的ROWID 获得登记信息
/// 输入参数：oeorditem.rowid
/// 返回：医嘱登记信息
/// 作者：龚平
/// 日期：2007-03-02
/// s Info=##class(web.DHCRisCommFunctionEx).GetRegInfo("3||4", "206")
ClassMethod GetRegInfo(oeorditemdr As %String, bodypartcode As %String = "") As %String
{
	s ^TMPRIS=oeorditemdr
	n (oeorditemdr,bodypartcode)
	s (StudyNo,strRegDate,strRegTime,Index,EQDesc,MainDoc,AssDoc,RoomDesc,RoomDr,EQDescdr)=""
	s (No,ssuserdr,MainDocDr,assDocDr,BodyInfo,Num,EQGroupDesc,EQGroupDr,strRegDate4,Urgentflag,RegDoc,RegDocdr)=""
	s (RoomIndex,GroupIndex,IndexTypeDR,IndexTypeDesc)=""
    if (oeorditemdr'="")
    {
	  s regrowid="" f  s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,regrowid))   Q:regrowid=""  D ; 登记的表中获得检查号
	  .;w !,regrowid
	  .s isThisRegrowid="N" 
	  .s ChildSub=0  f  s ChildSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub)) q:ChildSub=""  d
	  ..s BodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub),"^",1) 
	  ..if ((BodyDr=bodypartcode)&&(BodyDr'="")) d
	  ...s isThisRegrowid="Y"
	  .if (isThisRegrowid="Y")||(bodypartcode="") d
	  ..s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
	  ..s RegDate=$p(^DHCPACRegInfo(regrowid),"^",8)
	  ..i RegDate'="" d 
	  ...s strRegDate=##class(websys.Conversions).DateLogicalToHtml(RegDate) ;$zd(RegDate,3)
	  ...s strRegDate4=$zd(RegDate,4)
	  ..s RegTime=$p(^DHCPACRegInfo(regrowid),"^",9)
	  ..i RegTime'="" s strRegTime= ##class(websys.Conversions).TimeLogicalToHtml(RegTime) ;$zt(RegTime,1)
	  ..s RegDocdr=$p($g(^DHCPACRegInfo(regrowid)),"^",7)
	  ..i RegDocdr'="" d
	  ...s RegDoc=$p($g(^SSU("SSUSR",RegDocdr)),"^",2)
	  ..s MainDocDr=$p(^DHCPACRegInfo(regrowid),"^",5)
	  ..i MainDocDr'="" d 
	  ...s MainDoc=$p($g(^CTPCP(MainDocDr,1)),"^",2)
	  ...s ssuserdr=$o(^SSU("SSUSR",0,"CTPCP",MainDocDr,0))
	  ..s assDocDr=$p(^DHCPACRegInfo(regrowid),"^",6)
	  ..i assDocDr'="" s AssDoc=$p($g(^CTPCP(assDocDr,1)),"^",2)
	  ..s Index=$p(^DHCPACRegInfo(regrowid),"^",15)
	  ..s EQDescdr=$p(^DHCPACRegInfo(regrowid),"^",14)
	  ..i EQDescdr'="" s EQDesc=$p($g(^RBC("EQ",EQDescdr)),"^",2)
	  ..s RoomDr=$p(^DHCPACRegInfo(regrowid),"^",16)
	  ..i RoomDr'="" s RoomDesc=$p($g(^DHCRBC("Room",RoomDr)),"^",2)
	  ..s EQGroupDr=$p(^DHCPACRegInfo(regrowid),"^",17)
      ..i EQGroupDr'="" s EQGroupDesc=$p($g(^RBC("GRP",EQGroupDr)),"^",2)
	  ..s Nodr=$p(^DHCPACRegInfo(regrowid),"^",3) 
	  ..i Nodr'="" s No=$p($g(^DHCPACRegInfoNO("NO",0,Nodr)),"^",3)
	  ..s ReportInfo=$p(^DHCPACRegInfo(regrowid),"^",19)
	  ..s Urgentflag=$p(^DHCPACRegInfo(regrowid),"^",26)
	  ..s RoomIndex=$p($g(^DHCPACRegInfo(regrowid)),"^",24)
	  ..s GroupIndex=$p($g(^DHCPACRegInfo(regrowid)),"^",28)
	  ..s IndexTypeDR=$p($g(^DHCPACRegInfo(regrowid)),"^",30)
	  ..i IndexTypeDR'="" s IndexTypeDesc=$p($g(^DHCRBCIndexType(IndexTypeDR)),"^",2) 
	  ..s BodyInfo="",Num=0
	  ..s ChildSub=0  f  s ChildSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub)) q:ChildSub=""  d
	  ...s BodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub),"^",1) 
	  ...I bodypartcode'=""  S BodyDr=bodypartcode 
	  ...s Num=Num+1
	  ...s PartDesc=$p($g(^DHCAPPART(BodyDr)),"^",2)
	  ...s BodyInfo=PartDesc
	  ...e  s BodyInfo=""
    }
     s OrderRowid=$p(oeorditemdr,"||",1)
	 s itemsub=$p(oeorditemdr,"||",2)
	 s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	 s papatmasmdr=$p(^PAADM(paadmdr),"^",1) 
     s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
     ;s UsePrice=##class(web.UDHCAccManageCLS7).GetAccInfoByPAPMI(RegNo,"")
	 s AccUsePrice="" ;$p(UsePrice,"^",3)_"元"
	 s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub,bodypartcode)
	 s BilledDesc=$p(ordInfo,"^",27)
	s Info=StudyNo_"^"_strRegDate_"^"_strRegTime_"^"_Index_"^"_EQDesc_"^"_MainDoc_"^"_AssDoc_"^"_RoomDesc_"^"_RoomDr_"^"_EQDescdr_"^"_EQGroupDesc_"^"_EQGroupDr_"^"_No_"^"_ssuserdr_"^"_MainDocDr_"^"_assDocDr_"^"_BodyInfo_"^"_Num_"^"_$g(ReportInfo)_"^"_$g(strRegDate4)_"^"_Urgentflag_"^"_GroupIndex_"^"_RoomIndex_"^"_RegDoc_"^"_IndexTypeDR_"^"_IndexTypeDesc_"^"_AccUsePrice_"^"_BilledDesc
   
    
	q $g(Info)
}

/// 函数名称：GetRegInfo
/// 功能：根据医嘱的ROWID 获得登记信息
/// 输入参数：oeorditem.rowid
/// 返回：医嘱登记信息
/// 作者：龚平
/// 日期：2007-03-02
ClassMethod GetNewRegInfo(oeorditemdr As %String) As %String
{
	s ^TMPRIS=oeorditemdr
	n (oeorditemdr,bodypartcode)
	s (StudyNo,strRegDate,strRegTime,Index,EQDesc,MainDoc,AssDoc,RoomDesc,RoomDr,EQDescdr)=""
	s (No,ssuserdr,MainDocDr,assDocDr,BodyInfo,Num,EQGroupDesc,EQGroupDr,strRegDate4,Urgentflag,RegDoc,RegDocdr)=""
	s (RoomIndex,GroupIndex,IndexTypeDR,IndexTypeDesc)=""
	
    if (oeorditemdr'="")
    {
	  s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))  ; 登记的表中获得检查号
	  i (regrowid'="")
	  {
		  i $d(^DHCPACRegInfo(regrowid)) d 
		  .s ^DHCPACRegInfo(regrowid)=$g(^DHCPACRegInfo(regrowid))
		  .s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
		  .s RegDate=$p(^DHCPACRegInfo(regrowid),"^",8)
		  .i RegDate'="" d 
		  ..s strRegDate=$zd(RegDate,3)
		  ..s strRegDate4=$zd(RegDate,4)
		  .s RegTime=$p(^DHCPACRegInfo(regrowid),"^",9)
		  .i RegTime'="" s strRegTime=$zt(RegTime,1)
		  .s RegDocdr=$p($g(^DHCPACRegInfo(regrowid)),"^",7)
		  .i RegDocdr'="" d
		  ..s RegDoc=$p($g(^SSU("SSUSR",RegDocdr)),"^",2)
		  .s MainDocDr=$p(^DHCPACRegInfo(regrowid),"^",5)
		  .i MainDocDr'="" d 
		  ..s MainDoc=$p($g(^CTPCP(MainDocDr,1)),"^",2)
		  ..s ssuserdr=$o(^SSU("SSUSR",0,"CTPCP",MainDocDr,0))
	      .s assDocDr=$p(^DHCPACRegInfo(regrowid),"^",6)
		  .i assDocDr'="" s AssDoc=$p($g(^CTPCP(assDocDr,1)),"^",2)
	      .s Index=$p(^DHCPACRegInfo(regrowid),"^",15)
		  .s EQDescdr=$p(^DHCPACRegInfo(regrowid),"^",14)
		  .i EQDescdr'="" s EQDesc=$p($g(^RBC("EQ",EQDescdr)),"^",2)
		  .s RoomDr=$p(^DHCPACRegInfo(regrowid),"^",16)
		  .i RoomDr'="" s RoomDesc=$p(^DHCRBC("Room",RoomDr),"^",2)
		  .s EQGroupDr=$p(^DHCPACRegInfo(regrowid),"^",17)
		  .i EQGroupDr'="" s EQGroupDesc=$p($g(^RBC("GRP",EQGroupDr)),"^",2)
		  .s Nodr=$p(^DHCPACRegInfo(regrowid),"^",3) 
		  .i Nodr'="" s No=$p($g(^DHCPACRegInfoNO("NO",0,Nodr)),"^",3)
		  .s ReportInfo=$p(^DHCPACRegInfo(regrowid),"^",19)
		  .s Urgentflag=$p(^DHCPACRegInfo(regrowid),"^",26)
		  .s RoomIndex=$p($g(^DHCPACRegInfo(regrowid)),"^",24)
		  .s GroupIndex=$p($g(^DHCPACRegInfo(regrowid)),"^",28)
		  .s IndexTypeDR=$p($g(^DHCPACRegInfo(regrowid)),"^",30)
		  .i IndexTypeDR'="" s IndexTypeDesc=$p($g(^DHCRBCIndexType(IndexTypeDR)),"^",2) 
		  .; 取登记部位的信息
		  .s BodyInfo="",Num=0
		  .s ChildSub=0  f  s ChildSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub)) q:ChildSub=""  d
		  ..s BodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub),"^",1) 
		  ..i BodyDr'="" d
		  ...s Num=Num+1
		  ...;s BodyDesc=$p(^MRC("BODP",BodyDr),"^",2)
		  ...s PartDesc=$p(^DHCAPPART(BodyDr),"^",2)
		  ...;w !,"PartDesc="_PartDesc
		  ...s BodyInfo=BodyInfo_PartDesc
	  }
    }
    if (BodyInfo'=""){
	s Info=StudyNo_"^"_strRegDate_"^"_strRegTime_"^"_Index_"^"_EQDesc_"^"_MainDoc_"^"_AssDoc_"^"_RoomDesc_"^"_RoomDr_"^"_EQDescdr_"^"_EQGroupDesc_"^"_EQGroupDr_"^"_No_"^"_ssuserdr_"^"_MainDocDr_"^"_assDocDr_"^"_BodyInfo_"^"_Num_"^"_$g(ReportInfo)_"^"_$g(strRegDate4)_"^"_Urgentflag_"^"_GroupIndex_"^"_RoomIndex_"^"_RegDoc_"^"_IndexTypeDR_"^"_IndexTypeDesc
    } 
    else{
	s Info=""_"^"_strRegDate_"^"_strRegTime
	    }
	q Info
}

/// 函数名称：GetRegInfobyrowid
/// 功能：根据DHCRB_RegInfo.ROWID 获得登记信息
/// 输入参数：DHCRB_RegInfo.ROWID
/// 返回：医嘱登记信息
/// 作者：龚平
/// 日期：2007-03-02
/// s aa=##class(web.DHCRisCommFunctionEx).GetRegInfobyrowid(1111110)
ClassMethod GetRegInfobyrowid(regrowid As %String) As %String
{
	n (regrowid)
    s (StudyNo,strRegDate,strRegTime,Index,EQDesc,MainDoc,AssDoc,oeorditemdr,paadmdr)=""
    s (RoomDesc,EQDescdr,RoomDr,EQGroupDesc,EQGroupDr,No,BodyDesc,RegDate,Urgentflag,RegDoc,RegDocdr)=""
	i regrowid'="" d
	.q:$d(^DHCPACRegInfo(regrowid))=0 
	.s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
	.s RegDocdr=$p($g(^DHCPACRegInfo(regrowid)),"^",7)
	.i RegDocdr'="" s RegDoc=$p($g(^SSU("SSUSR",RegDocdr)),"^",2)
	.s RegDate=$p(^DHCPACRegInfo(regrowid),"^",8)
	.s strRegDate=$zd(RegDate,3)
	.s RegTime=$p(^DHCPACRegInfo(regrowid),"^",9)
	.s strRegTime=$zt(RegTime,1)
	.s MainDocDr=$p(^DHCPACRegInfo(regrowid),"^",5)
	.i MainDocDr'="" s MainDoc=$p(^CTPCP(MainDocDr,1),"^",2)
    .s assDocDr=$p(^DHCPACRegInfo(regrowid),"^",6)
	.i assDocDr'="" s AssDoc=$p(^CTPCP(assDocDr,1),"^",2)
    .s Index=$p(^DHCPACRegInfo(regrowid),"^",15)
	.s EQDescdr=$p(^DHCPACRegInfo(regrowid),"^",14)
	.i EQDescdr'="" s EQDesc=$p($g(^RBC("EQ",EQDescdr)),"^",2)
	.s oeorditemdr=$p(^DHCPACRegInfo(regrowid),"^",11)
	.s paadmdr=$p(^DHCPACRegInfo(regrowid),"^",10)
	.s RoomDr=$p(^DHCPACRegInfo(regrowid),"^",16)
	.i RoomDr'="" s RoomDesc=$p(^DHCRBC("Room",RoomDr),"^",2)
	.s EQGroupDr=$p(^DHCPACRegInfo(regrowid),"^",17)
	.i EQGroupDr'="" s EQGroupDesc=$p(^RBC("GRP",EQGroupDr),"^",2)
	.s Nodr=$p(^DHCPACRegInfo(regrowid),"^",3) 
	.i Nodr'="" s No=$p(^DHCPACRegInfoNO("NO",0,Nodr),"^",3) 
	.s Urgentflag=$p(^DHCPACRegInfo(regrowid),"^",26)
	.s BodyDesc=""
	.s ChildSub=0  f  s ChildSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub)) q:ChildSub=""  d
	..s BodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub),"^",1) 
	..i BodyDr'="" d
	...s BodyDesc=$p(^MRC("BODP",BodyDr),"^",2)
   	s Info=StudyNo_"^"_strRegDate_"^"_strRegTime_"^"_Index_"^"_EQDesc_"^"_$g(MainDoc)_"^"_$g(AssDoc)_"^"_oeorditemdr_"^"_paadmdr_"^"_RoomDesc_"^"_EQDescdr_"^"_RoomDr_"^"_EQGroupDesc_"^"_EQGroupDr_"^"_No_"^"_BodyDesc_"^"_RegDate_"^"_Urgentflag_"^"_RegDoc
	q Info
}

/// 函数名称：GetPatientInfo
/// 功能：根据登记号获得登记信息
/// 输入参数：RegNo：登记号
/// 返回：病人的基本信息
/// 作者：龚平
/// 日期：2007-03-02
ClassMethod GetPatientInfo(RegNo)
{

	 &sql(select Max(PAADM_Rowid) into :paadmdr  from PA_Adm where PAADM_PAPMI_DR->PAPMI_No=:RegNo )
     if ($g(paadmdr)'="")
     {
     s papatmasmdr=$p(^PAADM(paadmdr),"^",1)        
     s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
     s DOB=$p(^PAPER(papatmasmdr,"ALL"),"^",6)
     s strDOB=""
     i DOB'="" s strDOB=$zd(DOB,3)
     i strDOB="1840-12-31" s strDOB="" 
     s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
     s SexDesc=$p(^CT("SEX",SexDr),"^",2)
     s Type=$p(^PAADM(paadmdr),"^",2) ;病人类型
     s Locdr=$p(^PAADM(paadmdr),"^",4)
     s LocName=$p(^CTLOC(Locdr),"^",2) 
	 q Name_"^"_SexDesc_"^"_Type_"^"_$g(strDOB)_"^"_$g(LocName)
     }
     else
     {
	   q "^^^^"
     }
}

/// 函数名称：UpdataOrdInfo
/// 功能：更新医嘱状态
/// 输入参数：OrditmRowid, Status
/// 返回：SQLCODE
/// 作者：龚平
/// 日期：2007-03-02
/// ##class(web.DHCRisCommFunctionEx).UpdataOrdInfo(OrditmRowid, Status)
ClassMethod UpdataOrdInfo(OrditmRowid As %String, Status As %String, UserId As %String = "")
{
	s (FileVersion,DHCRisSystemInfo)=""
	s DHCRisSystemInfo=##class(web.DHCRisCodeTableAdd).GetSystemParam()
	s FileVersion=$p($g(DHCRisSystemInfo),"^",16)
	
	if ((FileVersion="V6.9")!(FileVersion=""))
	{
		s statdr=$o(^OEC("OSTAT",0,"Code",Status,0))
        &sql(update OE_OrdItem set OEORI_ItemStat_DR=:statdr where OEORI_RowId=:OrditmRowid)
        s CurrDate=$p($h,",",1)
        s CurrTime=$p($h,",",2)
        &sql(insert into OE_OrdStatus (ST_ParRef,ST_Date,ST_Time,ST_Status_DR)values (:OrditmRowid,:CurrDate,:CurrTime,:statdr)) 
	}
	else
	{
	    i Status="E" d
        .s SQLCODE=##class(appcom.OEOrdItem).Execute(OrditmRowid,UserId)
        else  if Status="V" d
        .s SQLCODE= ##class(appcom.OEOrdItem).Verify(OrditmRowid,UserId)	
	}
   
   q SQLCODE
}

// 

ClassMethod CreateNewPatientID(uid As %Library.String = "")
{
  ;i '$d(^DHCRisPNOLen) s ^DHCRisPNOLen=8	
  s mn=""	
  Set AdmDate=+$H,AdmTime=$P($H,",",2)		
  &sql(insert into SQLUSER.PA_Person
	 (paper_ageday,paper_agemth,paper_ageyr,
	  paper_langprim_dr,paper_dob,paper_name,
	  paper_sex_dr,paper_age,paper_userupdate,paper_soundex1,
	  paper_updatedate,paper_updatetime,paper_estdob,paper_dateadded,
	  paper_useradded_dr,paper_incompleteregistration)
	  values('','','','2','60124','未用','3','|||||||||||0|0|0','2','未用00',
	  :AdmDate,:AdmTime,'N',:AdmDate,:uid,'N')) 
  i SQLCODE=0 d
  .s mid=^PAPER(0)   //人的最大id
  .i $d(^PAPER(0,"CNT","I")) d
  ..s mno=^PAPER(0,"CNT","I") //最大登记号
  .e  d
  ..s mno=0
  .s ^PAPER(0,"CNT","I")=mno+1
  .s mn=mno+1
  .s len=..GetRegNoLength()
  .s count=len-$l(mno+1)
  .f i=0:1:count-1 d
  ..s mn = "0"_mn
  .&sql(update SQLUSER.pa_patmas
	                  set papmi_No=:mn,
	                      papmi_ipno=:mn,
	                      papmi_opno=:mn
	                where papmi_rowid=:mid
	              )
 q mn
}

Query QueryByPatientName(InName As %String, RocLocID As %String) As %Query(ROWSPEC = "RegNo:%String,Name:%String,DOB:%String,SexDesc:%String,IPNO:%String,Telphone:%String,Adress:%String,SexDr:%String,No:%String,Age:%String,WorkUnit:%String,ID1:%String,OccupationDR:%String,OccupationDesc:%String,OPNO:%String")
{
}

ClassMethod QueryByPatientNameExecute(ByRef qHandle As %Binary, InName As %String, RocLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s Isfirst=1
	s ^tmpGP1=InName_"^"_RocLocID
	s DHCRisSystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    s InName=$ZCONVERT(InName,"U")
	s flag="N"
	s GetName=InName f  s GetName=$o(^PAPERi("PAPER_PatName",GetName)) q:(GetName="")&(flag="Y")  d
	.if InName="" s flag="Y" q
	.;w !,GetName
	.if (GetName'[InName)&(Isfirst'=1) s flag="Y" q
	.i Isfirst=1 s GetName=InName
	.s Isfirst=Isfirst+1
	.s GetName=$ZCONVERT(GetName,"U")
	.;w !,GetName
	.s (RegNo,Name1,DOB,SexDesc,IPNO,Telphone,Adress,SafetynetCardNo)=""
	.s NoRowid=0 f  s NoRowid=$o(^PAPERi("PAPER_PatName",GetName,NoRowid))  q:NoRowid=""  d
	..s RegNo=$p(^PAPER(NoRowid,"PAT",1),"^",1)
	..s Name1=$p(^PAPER(NoRowid,"ALL"),"^",1)
    ..s DOB=$p(^PAPER(NoRowid,"ALL"),"^",6)
    ..;s strToday=+$h
    ..i DOB="" d
 	...s strDOB=""
 	...s Age=""
 	..e  d
    ...s strDOB=$ZD(DOB,3)
    ...s strToday=$ZD(+$h,3)
    ...s Age=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
    ...s year=$p(strDOB,"-",1)
    ...s Month=$p(strDOB,"-",2)
    ...s day=$p(strDOB,"-",3)
    ...s strDOB=day_"/"_Month_"/"_year
    ..s SexDr=$p(^PAPER(NoRowid,"ALL"),"^",7)
    ..s SexDesc=$p(^CT("SEX",SexDr),"^",2)
    ..s Telphone=$p(^PAPER(NoRowid,"PER",1),"^",11) 
    ..s Adress=$g(^PAPER(NoRowid,"PER","ADD",1))  
    ..s WorkUnit=$p($g(^PAPER(NoRowid,"PER",4)),"^",18)
    ..; pa_person set paper_id=:ID1,paper_telh=:TelNo,paper_stnameline1=:Adress,PAPER_Occupation_DR=:OccupationDR 
    ..s ID1=$p(^PAPER(NoRowid,"ALL"),"^",9)
    ..s OPNO=$p($g(^PAPER(NoRowid,"PER",4)),"^",4)
    ..s OccupationDR="",OccupationDesc=""
    ..s OccupationDR=$p($g(^PAPER(NoRowid,"PER",2)),"^",6)
    ..i OccupationDR'="" s OccupationDesc=$p($g(^CT("OCC",OccupationDR)),"^",2)    
    ..//papmi_medicare=:InMedicare,
    ..//papmi_medicarestring=:OpMedicare,
    ..//papmi_secondphone=:WorkUnits
    ..s IPNO=##class(web.DHCRisCommFunctionEx).GetIPNO(NoRowid)   //获得住院号
    ..s No=""
    ..s Noinfo=##class(web.DHCRisNewPatient).GetNo(RegNo,"",RocLocID)
	..s No=$p(Noinfo,"^",1)_$p(Noinfo,"^",2)
	..;w !,Name1_"^"_OPNO_"^"_NoRowid_"^"_RegNo
	..s OPNO=$p($g(^PAPER(NoRowid,"PER",4)),"^",4) 
 	..;s Age=""
    ..;&sql(select  PAPER_Age into :Age from PA_Person where PAPER_RowId=:NoRowid)
    ..;s Age=$P(Age,"|",12)
   	..Do OutRowL4
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutRowL4
    set Data=$lb(RegNo,Name1,strDOB,SexDesc,IPNO,Telphone,Adress,SexDr,No,Age,WorkUnit,ID1,OccupationDR,OccupationDesc,OPNO)
   	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

ClassMethod QueryByPatientNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByPatientNameExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryByPatientNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByPatientNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod UpdatePatientName()
{
	q 
    s rowid=0 for  s rowid=$o(^CTPCP(rowid)) q:rowid=""  d
    .s Name=$p(^CTPCP(rowid,1),"^",2)
    .s Name=$p(Name,$C(13,10),1)
    .s Id=$p(^CTPCP(rowid,1),"^",3)
    .s Id=$p(Id,$C(13,10),1)
    .s ^tmpName=rowid_"^"_Name_"^"_Id
    .w !,^tmpName
    .&sql(update CT_CareProv set CTPCP_Desc=:Name,CTPCP_Id=:Id where CTPCP_RowId =:rowid)
    
    ;-------------------------------
    ; ^DHCTARI({TARI_RowId}) 
    s rowid=0 for  s rowid=$o(^DHCTARI(rowid)) q:rowid=""  d
    .s Desc=$p(^DHCTARI(rowid),"^",2)
    .s Desc=$p(Desc,$C(13,10),1)
    .s ^tmpName=rowid_"^"_Desc
    .w !,^tmpName
    .&sql(update DHC_TarItem set TARI_Desc=:Desc where TARI_RowId =:rowid)
}

Query QueryAgeUnit() As %Query(ROWSPEC = "TDesc:%String,TCode:%String")
{
}

ClassMethod QueryAgeUnitExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	Set ^CacheTemp(repid,1)=$lb("Years","年")
 	Set ^CacheTemp(repid,2)=$lb("Months","月")
 	Set ^CacheTemp(repid,3)=$lb("Days","天")
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryAgeUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAgeUnitExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryAgeUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAgeUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryWardInfo(Desc As %String) As %Query(ROWSPEC = "TWardName:%String,TRowid:%String")
{
}

ClassMethod QueryWardInfoExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	s Desc=$tr(Desc,$c(0))
	
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	Set RowId=0	f  s RowId=$o(^PAWARD(RowId)) q:RowId=""  d
	.i $g(^PAWARD(RowId))'="" d 
	..s GetDesc=$p(^PAWARD(RowId),"^",2)
	..i (GetDesc[Desc) d
	...Do OutWardRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutWardRow
	set Data=$lb(GetDesc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryWardInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryWardInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWardInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ////////////////////////
Query QueryBed(WardRowid As %String, Code As %String) As %Query(ROWSPEC = "TBedDesc:%String,TRowid:%String")
{
}

ClassMethod QueryBedExecute(ByRef qHandle As %Binary, WardRowid As %String, Code As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i WardRowid="" s qHandle=$lb(0,repid,0)
	Quit:WardRowid="" $$$OK
	Set RowId=0	f  s RowId=$o(^PAWARD(WardRowid,"BED",RowId)) q:RowId=""  d
	.s GetCode=$p(^PAWARD(WardRowid,"BED",RowId),"^",1) 
	.i (GetCode[Code) d
	..s BedRowid=WardRowid_"||"_RowId
	..Do OutBedRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutBedRow
	set Data=$lb(GetCode,BedRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryBedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBedExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryBedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetIPNO(NoRowid) As %String
{
	s IPNO=""
	s DHCRisSystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    i (DHCRisVersion="DT_SY") d  
    .s IPNO=$p($g(^PAPER(NoRowid,"PAT",3)),"^",4) //病案号
    else  d 
    .s IPNO=$p($g(^PAPER(NoRowid,"PAT",1)),"^",22)
    .;取病案系统接口,HosptialID暂时未取得,需要实现
    .;s HosptialID=""
    .;if $d(%session) s HosptialID=%session.Data("LOGON.HOSPID")
    .;Set IPNO=##Class(web.DHCWMRService).IGetMrNoByPatientID(NoRowid,HosptialID)
    q IPNO
}

// d ##class(%ResultSet).RunQuery("web.DHCRisCommFunctionEx","QueryByPatientNo","00007802","")

Query QueryByPatientNo(RegNo As %String, RocLocID As %String) As %Query(ROWSPEC = "RegNo:%String,Name:%String,DOB:%String,SexDesc:%String,IPNO:%String,Telphone:%String,Adress:%String,SexDr:%String,No:%String,Age:%String,WorkUnit:%String,ID1:%String,OccupationDR:%String,OccupationDesc:%String,patienttype:%String,typedesc:%String,wardname:%String,wardDr:%String,BedDesc:%String,BedDr:%String,AdmDate:%String,AdmTime:%String,paadmrowid:%String,LocDr:%String,OPNO:%String")
{
}

ClassMethod QueryByPatientNoExecute(ByRef qHandle As %Binary, RegNo As %String, RocLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    i RegNo=""  Set qHandle=$lb(0,repid,0)
    Quit:RegNo="" $$$OK
	
	s Isfirst=1
	s DHCRisSystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    s GetNOLen=##class(web.DHCRisCommFunctionEx).GetRegNoLength()
    s len=$l(RegNo)
    for i=len:1:GetNOLen-1  d
    .s RegNo="0"_RegNo
	s RegNo=$ZCONVERT(RegNo,"U")
	s NoRowid=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	if NoRowid=""  Set qHandle=$lb(0,repid,0)
	q:NoRowid="" $$$OK
    
    s RegNo=$p(^PAPER(NoRowid,"PAT",1),"^",1)
	s Name1=$p(^PAPER(NoRowid,"ALL"),"^",1)
    s DOB=$p(^PAPER(NoRowid,"ALL"),"^",6)
    i DOB="" d
 	.s strDOB=""
 	.s Age=""
 	e  d
    .s strDOB=$ZD(DOB,3)
    .s strToday=$ZD(+$h,3)
    .s Age=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
    .s year=$p(strDOB,"-",1)
    .s Month=$p(strDOB,"-",2)
    .s day=$p(strDOB,"-",3)
    .s strDOB=day_"/"_Month_"/"_year
    s SexDr=$p(^PAPER(NoRowid,"ALL"),"^",7)
    s SexDesc=$p(^CT("SEX",SexDr),"^",2)
    s Telphone=$p(^PAPER(NoRowid,"PER",1),"^",11) 
    s Adress=$g(^PAPER(NoRowid,"PER","ADD",1))  
    s WorkUnit=$p($g(^PAPER(NoRowid,"PER",4)),"^",18)
    s ID1=$p(^PAPER(NoRowid,"ALL"),"^",9)
    s OPNO=$p($g(^PAPER(NoRowid,"PER",4)),"^",4)
    s OccupationDR="",OccupationDesc=""
    s OccupationDR=$p($g(^PAPER(NoRowid,"PER",2)),"^",6)
    i OccupationDR'="" s OccupationDesc=$p($g(^CT("OCC",OccupationDR)),"^",2)    
    s IPNO=##class(web.DHCRisCommFunctionEx).GetIPNO(NoRowid)   //获得住院号
    s No=""
    s Noinfo=##class(web.DHCRisNewPatient).GetNo(RegNo,"",RocLocID)
	s No=$p(Noinfo,"^",1)_$p(Noinfo,"^",2)
	s OPNO=$p($g(^PAPER(NoRowid,"PER",4)),"^",4)
	Do NOOutRowL4
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
NOOutRowL4
    set Data=$lb(RegNo,Name1,strDOB,SexDesc,IPNO,Telphone,Adress,SexDr,No,Age,WorkUnit,ID1,OccupationDR,OccupationDesc,OPNO)
   	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

ClassMethod QueryByPatientNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByPatientNoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryByPatientNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByPatientNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// s Len=##class(web.DHCRisCommFunctionEx).GetRegNoLength()

ClassMethod GetRegNoLength() As %String
{
  s PATCFid="",len=8
  s PATCFid=$o(^CF("PATCF",""))
  i PATCFid'="" s len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
  q len
}

// 根据别名查询IDC描述

// d ##class(%ResultSet).RunQuery("web.DHCRisCommFunctionEx","QueryIDCWithAlias","EJBCX")

Query QueryIDCWithAlias(desc As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "desc:%String,ICDROWID:%String,code:%String")
{
}

ClassMethod QueryIDCWithAliasClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QueryIDCWithAliasFetch ]
{
 Set repid=$LIST(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryIDCWithAliasExecute(ByRef QHandle As %Library.Binary, desc As %Library.String) As %Library.Status
{
	s desc=$ZCONVERT(desc,"U")
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    s Description="",Code=""
  s CircleFlag=1
  s tmpAilas=$o(^MRC("ID",0,"ALIAS",$$ALPHAUP^SSUTIL4(desc)),-1)
	f  s tmpAilas=$o(^MRC("ID",0,"ALIAS",$$ALPHAUP^SSUTIL4(tmpAilas))) q:((tmpAilas="")!(CircleFlag'=1))  d
	.if ($e($$ALPHAUP^SSUTIL4(tmpAilas),1,$l($$ALPHAUP^SSUTIL4(desc)))'=$$ALPHAUP^SSUTIL4(desc)) d
	..s CircleFlag=0
	.q:CircleFlag'=1
  .s ICDRowid=""  
  .f  s ICDRowid=$o(^MRC("ID",0,"ALIAS",$$ALPHAUP^SSUTIL4(tmpAilas),ICDRowid)) q:ICDRowid=""  d
  ..s Description=$p(^MRC("ID",ICDRowid),"^",2)
	..s Code=$p(^MRC("ID",ICDRowid),"^",1)
	..Do OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	 set Data=$lb(Description,ICDRowid,Code)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	 Quit
}

ClassMethod QueryIDCWithAliasFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QueryIDCWithAliasExecute ]
{
 Set AtEnd=$LIST(QHandle,1)
 Set repid=$LIST(QHandle,2)
 Set ind=$LIST(QHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 电子病历接口   ---------------
/// CS 版本
ClassMethod GetEPRV1Element(paadm, eleCode, isGetCode)
{
 s ret=##class(DHC.EPR.FPInterface.ExportTable).GetItemDataValueV1ForStat(paadm,eleCode,isGetCode)
 q ret
}

// s Desc=##class(web.DHCRisCommFunctionEx).GetEPRV2Element(paadm, eleCode, isGetCode)

/// BS 版本-----------
ClassMethod GetEPRV2Element(paadm, eleCode, isGetCode)
{
  n (paadm, eleCode, isGetCode)
 //s ret=##class(EPRmeta.FPInterface.ExportTable).GetItemDataValueV2ForStat(paadm,eleCode,isGetCode)
 s ret=##class(EPRservice.BOScatterData).GetScatterData(paadm, eleCode, isGetCode)
 s Desc4=$p(ret,"^",2)
 q Desc4
}

/// ///////////////根据PA_PATMAS 获得卡号 
ClassMethod GetCardNobyPatDR(Patmasdr As %String)
{
	n (Patmasdr)
	s CardNo=""
	s RowId=0  f  s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",Patmasdr,RowId)) q:RowId=""  d
	.s ActiveFlag=$p($g(^DHCCARD("CF",RowId)),"^",10)
	.i ActiveFlag="N" d  
	..s CardNo=$p($g(^DHCCARD("CF",RowId)),"^",2)
	q CardNo
}

ClassMethod StopOrderItem(oeorditemrowid As %String, userid As %String) As %String
{
    s (FileVersion,DHCRisSystemInfo)=""
	s DHCRisSystemInfo=##class(web.DHCRisCodeTableAdd).GetSystemParam()
	s FileVersion=$p($g(DHCRisSystemInfo),"^",16)
	
	if ((FileVersion="V6.9")!(FileVersion=""))
	{
	   s ret=##class(web.DHCOEOrdItem).Stop(oeorditemrowid,userid)
	}
	else
	{
	   s ret=##class(appcom.OEOrdItem).Stop(oeorditemrowid,userid)
	}
  
 
    s ret=##class(web.DHCRisCommFunctionEx).UpdateGlobal(oeorditemrowid)
    s ret=##class(web.DHCRisCommFunctionEx).UpdateOrdName(oeorditemrowid)

  q ret
}

ClassMethod VeriedOrditem(oeorditemrowid As %String, userid As %String) As %String
{
  s (FileVersion,DHCRisSystemInfo)=""
  s DHCRisSystemInfo=##class(web.DHCRisCodeTableAdd).GetSystemParam()
  s FileVersion=$p($g(DHCRisSystemInfo),"^",16)
	
  if ((FileVersion="V6.9")!(FileVersion=""))
  {
	 s CurrDate=$p($h,",",1)
     s CurrTime=$p($h,",",2)
     s DoctorRowId=""
     s statdr=$o(^OEC("OSTAT",0,"Code","V",0))
     &sql(insert into OE_OrdStatus (ST_ParRef,ST_Date,ST_Time,ST_Status_DR,ST_User_DR )values (:oeorditemrowid,:CurrDate,:CurrTime,:statdr,:userid))
   
     i userid'="" s DoctorRowId=$p($g(^SSU("SSUSR",userid)),"^",14)  
     //&SQL(Update SQLUser.OE_OrdItem set OEORI_Xdate=:CurrDate,OEORI_Xtime=:CurrTime,OEORI_XCTCP_DR=:DoctorRowId,OEORI_ItemStat_DR=:statdr where OEORI_rowid=:oeorditemrowid)  
     &SQL(Update SQLUser.OE_OrdItem set OEORI_XCTCP_DR=:DoctorRowId,OEORI_ItemStat_DR=:statdr where OEORI_rowid=:oeorditemrowid)  
     q SQLCODE
  }
  else
  {
	  s ret=##class(appcom.OEOrdItem).Verify(oeorditemrowid,userid)
	  q ret
  }
  
  
  //
}

// 修正汉字转换拼音的错误

// ab中b   a b zhong b

// 

ClassMethod SetHZPin(Hz As %String, Pin As %String) As %String
{
	s Len=$l(Hz)
	for i=1:1:Len d 
	.s PerHz=$e(Hz,i)
	.i $A(PerHz)>255 d   ; 只处理汉字
	..s PerPin=$p(Pin," ",i)
	..;s ^DHCRisHZPin(PerHz)=PerPin
	..s ^RISHZPYK(PerHz)=PerPin
	q Len
}

ClassMethod GetPerHZPin(perHz As %String) As %String
{
	s GetPin=perHz
    if $A(perHz)>255 d
    .s GetPin=$g(^DHCRisHZPin(perHz))
	q GetPin
}

// 更新检查目的

// d ##class(web.DHCRisCommFunctionEx).UpdateGlobal("26784||17")

ClassMethod UpdateGlobal(oeorditemrowid)
{
    //获得检查目的
	s GLOBAL=##class(web.DHCRisApplicationBill).GetGlobal(oeorditemrowid)
	s len=$l(GLOBAL)
	s AppRowid=$o(^DHCRBAppOrdi(0,oeorditemrowid,0))
	if AppRowid'="" d 
	.s XMLConent=^DHCRBApp("Bill",AppRowid,"XMLContent")
	.s Num=$l(XMLConent,GLOBAL)
	.s TotalXMLConent=""
	.for i=1:1:Num d
	..s perConent=$p(XMLConent,GLOBAL,i)
	..i ((i=1)!(i=Num)) d
	...s GLOBAL1=""
	..else  d
	...s GLOBAL1=GLOBAL
	..s TotalXMLConent=TotalXMLConent_perConent_GLOBAL1
	.s ^DHCRBApp("Bill",AppRowid,"XMLContent")=TotalXMLConent
    .;-----------------------------------------------------
    .s htmlConent=^DHCRBApp("Bill",AppRowid,"html")
	.s Num=$l(htmlConent,GLOBAL)
	.s TotalhtmlConent=""
	.for i=1:1:Num d
	..s perConent=$p(htmlConent,GLOBAL,i)
	..i ((i=1)!(i=Num)) d
	...s GLOBAL1=""
	..else  d
	...s GLOBAL1=GLOBAL		
	..s TotalhtmlConent=TotalhtmlConent_perConent_GLOBAL1
	..s ^DHCRBApp("Bill",AppRowid,"html")=TotalhtmlConent
	q 0
}

// 更新医嘱项目显示的内容

// s ret=##class(web.DHCRisCommFunctionEx).UpdateOrdName("57771||4")

ClassMethod UpdateOrdName(oeorditemrowid)
{
  
    s ^tmp1111=oeorditemrowid
    s OrderRowid=$p(oeorditemrowid,"||",1)
	s itemsub=$p(oeorditemrowid,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	s perOrdOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	s AppRowid=$o(^DHCRBAppOrdi(0,oeorditemrowid,0))
	if AppRowid'="" d 
	.s XMLConent=^DHCRBApp("Bill",AppRowid,"XMLContent")
	.s perConent1=$p(XMLConent,"<OrdName>",1)
	.s perConnet2=$p(XMLConent,"<OrdName>",2)
	.s GetAllOrdName=$p(perConnet2,"</OrdName>",1)
	.s LeftStr=$p(perConnet2,"</OrdName>",2)
    .; 获得的医嘱列表中删除对应的医嘱，可能在医嘱列表有重复的医嘱名称
	.s Num=$l(GetAllOrdName,perOrdOrderName)
	.s NeedAllOrdName=""
	.for i=1:1:Num d
	..s perConent=$p(GetAllOrdName,perOrdOrderName,i)
	..i ((i=1)!(i=Num)) d
	...s OrderName=""
	..else  d
	...s OrderName=perOrdOrderName
	..s NeedAllOrdName=NeedAllOrdName_perConent_OrderName
	.s bb=perConent1_"<OrdName>"_NeedAllOrdName_"</OrdName>"_LeftStr
	.s ^DHCRBApp("Bill",AppRowid,"XMLContent")=perConent1_"<OrdName>"_NeedAllOrdName_"</OrdName>"_LeftStr
 q 0
}

/// 函数 GetPrintAppBillContent
/// 功能 获取申请单的打印内容
/// 参数：oeorditemrowid 医嘱ROWID 
/// 作者: gongping 
/// 日期：2011-04-22
ClassMethod GetPrintAppBillContent(oeorditemrowid As %String) As %String
{
	s PrintConent=""
	s OrderRowid=$p(oeorditemrowid,"||",1)
	s itemsub=$p(oeorditemrowid,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	s AppRowid=$o(^DHCRBAppOrdi(0,oeorditemrowid,0))
	q:(AppRowid="") PrintConent
	if AppRowid'="" d 
	.s PrintConent=$g(^DHCRBApp("Bill",AppRowid,"PrintParam"))
	q PrintConent
}

ClassMethod ImportExcelData(Info As %String) As %String
{
	s ^DHCRis("Info")=Info
	s ArcItmCode=$p($g(Info),"^",1)
	s Location=$p($g(Info),"^",2)
	s Telphone=$p($g(Info),"^",3)
	s AutoIuputFee=$p($g(Info),"^",4)
    s AppointDesc=$p($g(Info),"^",5)
    s IsEmpty=$p($g(Info),"^",6)
    s AppLoc=$p($g(Info),"^",7)
    s ServiceGroup=$p($g(Info),"^",8)
    s ExamTime=$p($g(Info),"^",10)
    
    s ArcItmRowid="" ,SubscriptID="",VersionID="",AppMRowid="",DIPRowid="",GetArcItmRowid=""
    
    i ArcItmCode'="" d
     .s SubscriptID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),0))
     .i SubscriptID'="" d
     ..s VersionID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),SubscriptID,0))
     ..i VersionID'="" s ArcItmRowid=SubscriptID_"||"_VersionID
     ..s DIPRowid=$o(^DHCRBCItemBookProperTypei(ArcItmRowid,0))
     ..i DIPRowid'="" s GetArcItmRowid=$p(^DHCRBCItemBookProperty(DIPRowid),"^",1)
     
    i AppointDesc'="" d
    .s AppMethodID=0 f  s AppMethodID=$o(^DHCRBCAppointMethod(AppMethodID)) q:(AppMethodID="")  d
    ..s AppDesc=$p(^DHCRBCAppointMethod(AppMethodID),"^",2)
    ..i (AppDesc=AppointDesc) s AppMRowid=AppMethodID

    i (AutoIuputFee="是")
    {
	   s AutoIuputFee="Y" 
	}
	else
	{  
	   s AutoIuputFee="N"
	}
	
	i (IsEmpty="是")
	{
	   s IsEmpty="Y"
	}
	else
	{
	   s IsEmpty="N"	
	}
     
	i (ArcItmRowid=GetArcItmRowid)
	{
	    &sql(update DHCRBC_ItemBookProperty set DIBP_AppointMethod_ID=:AppMRowid,DIBP_AutoInputFee=:AutoIuputFee,
	                 DIBP_IsEmpty=:IsEmpty,DIBP_Location=:Location,DIPB_Telphone=:Telphone,DIPB_AppLocation=:AppLoc,
	                 DIPB_Time=:ExamTime where DIBP_ARCItmMast_DR =:ArcItmRowid)
	}
	else
	{
	    &sql(insert into DHCRBC_ItemBookProperty (DIBP_ARCItmMast_DR,DIBP_AppointMethod_ID,DIBP_AutoInputFee,DIBP_IsEmpty,DIBP_Location,DIPB_Telphone,DIPB_AppLocation,DIPB_Time)
	       values (:ArcItmRowid,:AppMRowid,:AutoIuputFee,:IsEmpty,:Location,:Telphone,:AppLoc,:ExamTime))
	} 
	  
	 i ServiceGroup'="" d
	 .s ServiceGroupId=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(ServiceGroup),0))
	 .s ServiceGroupId1=""
	 .i ServiceGroupId'="" d
     ..&sql(update  ARC_ItmMast(ARCIM_ServiceGroup_DR) values (:ServiceGroupId1) where  ARCIM_RowId=:ArcItmRowid)

	 
	q SQLCODE
}

/// 函数名称：GetAppDocbyAdm
/// 功能：根据PAADM.ROWID 获得病人的当前申请医生
/// 输入参数：Pa_adm.rowid
/// 返回：申请医生姓名
/// 作者：孙毅
/// 日期：2011-08-22
ClassMethod GetAppDocbyAdm(paadmdr As %String) As %String
{
  s ^t=paadmdr
  s OrdRowid=""	,ChildsubID="",Docdr="",DocName=""
  s OrdRowid=$o(^OEORD(0,"Adm",paadmdr,OrdRowid))
  i OrdRowid'="" s ChildsubID=$o(^OEORD(OrdRowid,"I",ChildsubID),-1)
  i ChildsubID'="" s Docdr=$p($g(^OEORD(OrdRowid,"I",ChildsubID,1)),"^",11) ;下医嘱医生
  i Docdr'="" s DocName=$p(^CTPCP(Docdr,1),"^",2) 
  q DocName
}

/// 函数 GetPrintAppIndex
/// 功能 获取申请单的打印次数
/// 参数：OrdItemID 医嘱Rowid 
/// 作者: sunyi
/// 日期：2011-08-22
ClassMethod GetPrintAppIndex(OrdItemID) As %String
{
	q:(OrdItemID="") ""
	s Count=0
    s Count=$l(OrdItemID,"@")

	for i=1:1:Count 
    {
	  s perOrditemRowid="" 
	  s perOrditemRowid=$p(OrdItemID,"@",i)
	  i $g(^DHCRisPrintAppIndex(perOrditemRowid))="" s ^DHCRisPrintAppIndex(perOrditemRowid)=0
	  s CurrentIndex=^DHCRisPrintAppIndex(perOrditemRowid)+1
	  s ^DHCRisPrintAppIndex(perOrditemRowid)=CurrentIndex
    }
    
	q CurrentIndex
}

ClassMethod SetPrintAppIndex(OrdItemID) As %String
{
   s Index=""
   q:(OrdItemID="")
   s Index=$g(^DHCRisPrintAppIndex(OrdItemID))
   q Index
}

/// 根据登记号获得卡号 sy 20090824
ClassMethod GetCardNofromRegNo(RegNo As %String) As %String
{
	
	s RegNo=$ZCONVERT(RegNo,"U")
	s PatRowid="",CardNo=""
	s PatRowid=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	i PatRowid'="" d
	.s CardRowid=""
	.s CardRowid=$o(^DHCCARDi("CF",0,"PAPMIDR",PatRowid,0))
	.i CardRowid'="" d
	..s CardNo=$p($g(^DHCCARD("CF",CardRowid)),"^",2)
  
	q CardNo
}

/// 获取登记号下所有对应的卡号   yaobo  20110418 
/// ^80015890,注册医疗卡,N,^80041293,注册医疗卡,N,  (卡号信息的格式)
ClassMethod GetCardInfoByRegNo(RegNo As %String) As %String
{
    s RegNo=$ZCONVERT(RegNo,"U")
	s PatRowid="",CardNo=""
	s PatRowid=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	i PatRowid'="" d
	.s CardRowid="",CardInfo=""
	.s CardTypeDesc="",CardNo="",CardFlag="",IDCardNo=""  ;卡类型ID，卡号，卡有效性，身份证号
	
    .f  s CardRowid=$o(^DHCCARDi("CF",0,"PAPMIDR",PatRowid,CardRowid)) q:CardRowid=""  d
	..s tempCard=$g(^DHCCARD("CF",CardRowid))
	..s CardNo=$p(tempCard,"^",2)
	..s CardTypeId=$p(tempCard,"^",16)
	..s CardTypeDesc=$p(^DHCCARDTYPEDef(CardTypeId),"^",2) 
	..s CardFlag=$p(tempCard,"^",10)   ;
	..s IDCardNo=$p(tempCard,"^",5)
	..s CardInfo=CardInfo_"^"_CardNo_","_CardTypeDesc_","_CardFlag_","_IDCardNo
  
	q CardInfo
}

/// 函数 GetPatInfo
/// 功能 获得病人相关信息
/// 参数：OrdItemID 医嘱Rowid 
/// 作者: sunyi
/// 日期：2011-09-22
/// w ##class(web.DHCRisCommFunctionEx).GetPatInfo("3963||4")
ClassMethod GetPatInfo(OrdItemID As %String) As %String
{
	q:(OrdItemID="") "0"
	s (OeordRowid,Paadmdr,PatInfo,PatType)=""
	s OeordRowid=$p(OrdItemID,"||",1)
	
	i (OeordRowid'="")
	{
	  s Paadmdr=$p(^OEORD(OeordRowid),"^",1)
	  i (Paadmdr'="")
	  {
		 s PatInfo=..GetPaadmInfo(Paadmdr)
		 i (PatInfo'="")
		 {
		    s PatType=$p(PatInfo,"^",6)	 
		 }
	  }
	  	
	}
	
	q PatType
}

/// 函数 UpdateOrdStatus
/// 功能 更新RIS的医嘱信息
/// 参数：报告医生ID,检查号,报告状态
/// 作者: sunyi
/// 日期：2011-09-23
ClassMethod UpdateOrdStatus(Userid, StudyNo, ResultStatus)
{
 s rowid=0 f  s rowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,rowid)) q:rowid=""  d
 .s oeorditemrowid=$p(^DHCPACRegInfo(rowid),"^",11)
 .d ##class(web.DHCRisCommFunctionEx).UpdataOrdRISInfo(Userid, oeorditemrowid, "", "E", ResultStatus)
}

ClassMethod UpdataOrdRISInfo(Userid As %String, OrditmRowids As %String, ChildSub As %String, Status As %String, ResultStatus As %String, PAADMDR = "")
{
	s Oeodrowid=$p(OrditmRowids,"||",1)
    s OeodChild=$p(OrditmRowids,"||",2)
    s CurrDate=$p($h,",",1)
    s CurrTime=$p($h,",",2)
    s ChildSub=$p(ChildSub,$c(0))
    s statdr=$o(^OEC("OSTAT",0,"Code","E",0))
    
    &sql(update OE_OrdItem(OEORI_ItemStat_DR,OEORI_ResultFlag)values(:statdr,'V') where OEORI_RowId=:OrditmRowids)
    &sql(insert into OE_OrdStatus (ST_ParRef,ST_Date,ST_Time,ST_Status_DR,ST_User_DR )values (:OrditmRowids,:CurrDate,:CurrTime,:statdr,:Userid))
    
    q SQLCODE
}

/// 函数 GetBodyPartCode
/// 功能 得到身体部位代码
/// 参数:
/// 作者: sunyi
/// 日期：2011-08-22
ClassMethod GetBodyPartCode() As %String
{
	i $g(^DHCRisPrintAppIndex("DHCRisBodyPartsCode"))="" s ^DHCRisPrintAppIndex("DHCRisBodyPartsCode")=5
	s CurrentIndex=^DHCRisPrintAppIndex("DHCRisBodyPartsCode")+1
	s ^DHCRisPrintAppIndex("DHCRisBodyPartsCode")=CurrentIndex
	q CurrentIndex
}

/// do ##class(web.DHCRisCommFunctionEx).ImportBodyPartData("^肝")
ClassMethod ImportBodyPartData(Info As %String) As %String
{
	s ^DHCRis("BodyPartInfo11")=Info
	
	s ArcItmCode=$p($g(Info),"^",1)
	s BodyParts=$p($g(Info),"^",2)
    
    s BodyCode=""
    
    if (BodyParts'="")
    {
		s len=$L(BodyParts,",")
		f s=1:1:len d
		.s BodyParts1=$p(BodyParts,",",s)
		.q:(BodyParts1="")
		.q:(BodyParts1="-")
		.s BodyPartDesc=$p(BodyParts1,"-",1)
		.i BodyPartDesc'="" s BodyParts1=BodyPartDesc
		.s MrcRowid=""
		.s MrcRowid=$o(^MRC("BODP",0,"Desc",$$ALPHAUP^SSUTIL4(BodyParts1),""))
		.i MrcRowid'="" d
		..&sql(update MRC_BodyParts set BODP_Desc=:BodyParts1 where BODP_RowId =:MrcRowid)
		.e  d
		..s BodyCode=..GetBodyPartCode()
		..&sql(insert into MRC_BodyParts (BODP_Code,BODP_Desc) values (:BodyCode,:BodyParts1))
		
	}
	 
	q SQLCODE
}

/// 导入DHCRBC_Orditem_BodyPart数据
/// do ##class(web.DHCRisCommFunctionEx).OrdItemBodyPartSet("FS0126^双侧,")
ClassMethod OrdItemBodyPartSet(Info As %String) As %String
{
	s ^DHCRis("SetOrdItemBody")=Info
	
	s ArcItmCode=$p($g(Info),"^",1)
	s BodyParts=$p($g(Info),"^",2)
	
	s ArcItmRowid="" ,SubscriptID="",VersionID=""
	
	i ArcItmCode'="" d
     .s SubscriptID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),0))
     .i SubscriptID'="" d
     ..s VersionID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),SubscriptID,0))
     ..i VersionID'="" s ArcItmRowid=SubscriptID_"||"_VersionID 
    
    i (BodyParts'="")&&(ArcItmRowid'="") 
    {
       s len=$L(BodyParts,",")
	   f s=1:1:len d
	   .s BodyParts1=$p(BodyParts,",",s)
	   .q:(BodyParts1="")
	   .s MrcRowid=""
	   .s MrcRowid=$o(^MRC("BODP",0,"Desc",$$ALPHAUP^SSUTIL4(BodyParts1),""))
	   .i MrcRowid'="" d
	   ..s bWrite=1
	   ..&sql(select count(*) into:bWrite from DHCRBC_Orditem_BodyPart where ((DOB_ItmMast_DR=:ArcItmRowid) and (DOB_BodyPart_DR=:MrcRowid)))
	   ..i (bWrite=0) d
       ...&sql(insert into DHCRBC_Orditem_BodyPart (DOB_ItmMast_DR,DOB_BodyPart_DR) values (:ArcItmRowid,:MrcRowid))
		
    }	
	
	q SQLCODE
}

/// 导入DHCRBC_Orditem_BodyPart数据
/// 增加更新部位排斥标记
/// do ##class(web.DHCRisCommFunctionEx).SetOrdItemBodyPartNEW("WL0075^胆-2,肝-2,脾-1,胰-3")
ClassMethod OrdItemBodyPartSetNEW(Info As %String) As %String
{
	s ^DHCRis("SetOrdItemBody")=Info
	
	s ArcItmCode=$p($g(Info),"^",1)
	s BodyParts=$p($g(Info),"^",2)
	
	s ArcItmRowid="" ,SubscriptID="",VersionID=""
	
	i ArcItmCode'="" d
     .s SubscriptID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),0))
     .i SubscriptID'="" d
     ..s VersionID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),SubscriptID,0))
     ..i VersionID'="" s ArcItmRowid=SubscriptID_"||"_VersionID 
    
    i (BodyParts'="")&&(ArcItmRowid'="") 
    {
       s len=$L(BodyParts,",")
	   f s=1:1:len d
	   .s BodyParts1=$p(BodyParts,",",s)
	   .i (BodyParts1'="")&(BodyParts1'="-") d
	   ..s BodyPart=$p($g(BodyParts1),"-",1)
	   ..s ExclusionFlag=$p($g(BodyParts1),"-",2)
	   ..s MrcRowid=""
	   ..s MrcRowid=$o(^MRC("BODP",0,"Desc",$$ALPHAUP^SSUTIL4(BodyPart),""))
	   ..i (MrcRowid'="")&(ExclusionFlag'="") d
	   ...s bWrite=""
	   ...&sql(select count(*) into:bWrite from DHCRBC_Orditem_BodyPart where ((DOB_ItmMast_DR=:ArcItmRowid) and (DOB_BodyPart_DR=:MrcRowid)))
	   ...i (bWrite=1) d
	   ....&sql(update DHCRBC_Orditem_BodyPart(DOB_ItmMast_DR,DOB_BodyPart_DR,DOB_ExclusionFlag)values(:ArcItmRowid,:MrcRowid,:ExclusionFlag) where ((DOB_ItmMast_DR=:ArcItmRowid) and (DOB_BodyPart_DR=:MrcRowid)))
	   ...i (bWrite=0) d
       ....&sql(insert into DHCRBC_Orditem_BodyPart (DOB_ItmMast_DR,DOB_BodyPart_DR,DOB_ExclusionFlag) values (:ArcItmRowid,:MrcRowid,:ExclusionFlag))
	   q SQLCODE
    }
}

/// DHCRBC_BodyPart_Posture
/// 设置身体部位与体位关联
/// do ##class(web.DHCRisCommFunctionEx).ProuseBodyPartSet("双侧-1,其他-1^1,2,3")
ClassMethod ProuseBodyPartSet(Info As %String) As %String
{
	s BodyParts=$p($g(Info),"^",1)
	s Postures=$p($g(Info),"^",2)
    
    s BodyCode=""
    
    if (BodyParts'="")&(Postures'="")
    {
		s Blen=$L(BodyParts,",")
		s Plen=$L(Postures,",")
		f s=1:1:Blen d
		.s BodyParts1=$p(BodyParts,",",s)
		.q:(BodyParts1="")
		.q:(BodyParts1="-")
		.s BodyPartDesc=$p(BodyParts1,"-",1)
		.i BodyPartDesc'="" s BodyParts1=BodyPartDesc
		.s MrcRowid=""
		.s MrcRowid=$o(^MRC("BODP",0,"Desc",$$ALPHAUP^SSUTIL4(BodyParts1),""))
		.i MrcRowid'="" d
		..f i=1:1:Plen d
		...s PostureDesc=$p(Postures,",",i)
		...q:(PostureDesc="")
		...;w !,MrcRowid_"----"_PostureDesc
	    ...s bWrite=""
	    ...&sql(select count(*) into:bWrite from DHCRBC_BodyPart_Posture where ((DBP_BodyPart_DR=:MrcRowid) and (DBP_Desc=:PostureDesc)))
	    ...i (bWrite=0) d
        ....&sql(insert into DHCRBC_BodyPart_Posture(DBP_BodyPart_DR,DBP_Desc) values (:MrcRowid,:PostureDesc))
	}
	
	q SQLCODE
}

ClassMethod GetBilledDesc(Code As %String) As %String
{
    s BilledDesc=""
	if (Code="P") d
	.s BilledDesc="已收费"
	else  if (Code="TB") d
	.s BilledDesc="未账单"   ;开医嘱未账单
	else  if (Code="B") d 
	.s BilledDesc="已账单"   ;已账单未缴费
	else  d 
	 .s BilledDesc="未收费"  ;停医嘱
	q BilledDesc
}

ClassMethod SetSelBodyPart(BodyDesc As %String)
{
	s BodyInfo="",BodyPartDesc=""
	
	i (BodyDesc'="")
	{
		s num=$l(BodyDesc,"&")
		f i=1:1:num  d
		.s BodyPartDesc=$p(BodyDesc,"&",i)
		.q:(BodyPartDesc="")
		.i BodyInfo="" s BodyInfo=BodyPartDesc
		.e  d
		..s BodyInfo=BodyInfo_"、"_BodyPartDesc
	}  
	
    q BodyInfo
}

/// 汉字转换拼音的函数
/// w ##class(web.DHCRisCommFunctionEx).HZtoPin("孙毅")
ClassMethod HZtoPin(HZ As %String) As %String
{
	s Pin=""
	s count=$l(HZ)
	for i=1:1:count d
	.s perHZ=$e(HZ,i)
	.s perPin=$g(^RISHZPYK(perHZ))
	.i Pin="" d
	..s Pin=perPin
	.else  d
	..s Pin=Pin_" "_perPin
	..s Pin=$ZCONVERT(Pin,"U")
	q Pin
}

ClassMethod ImportMemoInfo(Info As %String)
{
	s ArcItmCode=$p($g(Info),"^",1)
	s Memo=$p($g(Info),"^",2)
	;s Memo=$p(^DHCRBApp("Memo",7),"^",2)
	
	s ArcItmRowid="" ,SubscriptID="",VersionID=""
	
	i ArcItmCode'="" d
     .s SubscriptID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),0))
     .i SubscriptID'="" d
     ..s VersionID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),SubscriptID,0))
     ..i VersionID'="" s ArcItmRowid=SubscriptID_"||"_VersionID 
     
    i (ArcItmRowid'="")
    {
	    s bWrite=""
	    &sql(select count(*) into:bWrite from DHCRB_Memo where (DM_ARCItmMast_DR=:ArcItmRowid))
	    i (bWrite=0) d
	    .&sql(Insert into DHCRB_Memo(DM_ARCItmMast_DR)values(:ArcItmRowid))
	    .s srowid=$p(%ROWID,$c(1))
	    .i srowid'="" d
	    ..s $p(^DHCRBApp("Memo",srowid),"^",2)=Memo
	    e  d
	    .s Rowid=""
	    .s Rowid=$o(^DHCRBAppi("Memo-ItMast",ArcItmRowid,0))
	    .i Rowid'="" d
	    ..s $p(^DHCRBApp("Memo",Rowid),"^",2)=Memo
	    ..s SQLCODE="0"
	    
	    q SQLCODE
	}
}

/// 在第三方RIS预约时获取平台设置的检查号
/// w ##class(web.DHCRisCommFunctionEx).GetStudyNo("1||2")
ClassMethod GetStudyNo(oeorditemrowid As %String) As %String
{
	q:(oeorditemrowid="") ""
	s StudyNo=""
	s StudyNo=$g(^DHCRISSTUDYINFOTMEP(oeorditemrowid))
	q StudyNo
}

/// 获取补录费用操作员
/// w ##class(web.DHCRisCommFunctionEx).GetPaymentDoc("67||303")
ClassMethod GetPaymentDoc(oeorditemrowid As %String) As %String
{
	q:(oeorditemrowid="") ""
	s OrderRowid=$p(oeorditemrowid,"||",1)
	s itemsub=$p(oeorditemrowid,"||",2)
	s (CheckEntryStr,PaymentUser,OeoritemID,UserRowid)=""
	
	/*s CheckEntryStr=$P($g(^OEORD(OrderRowid,"I",itemsub,"DHC")),"^",31)
	
	i CheckEntryStr'="" d
	.s OeoritemID=$p($g(CheckEntryStr),"*",1)
	.i OeoritemID'="" d
	..s UserRowid=$P($g(^OEORD($p(OeoritemID,"||",1),"I",$p(OeoritemID,"||",2),7)),"^",1)
	..i UserRowid'="" s PaymentUser=$p($g(^SSU("SSUSR",UserRowid)),"^",2)*/
	
	q PaymentUser
}

/// do ##class(web.DHCRisCommFunctionEx).ImportNewMemo("FS0004^CS005")
ClassMethod ImportNewMemo(Info As %String)
{
	S ^TempRispan("2016-08-11-18")=Info
	s ArcItmCode=$p($g(Info),"^",1)
	s Code=$p($g(Info),"^",2)
	s UseMethodDR=$p($g(Info),"^",3)
	s BodyPartCode=$p($g(Info),"^",4)
	s MTRowid=$o(^DHCRBCAppi("Memo-Template",0,"Code",$$ALPHAUP^SSUTIL4(Code),0)) 
	s ArcItmRowid="" ,SubscriptID="",VersionID=""
	
	i ArcItmCode'="" d
     .s SubscriptID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),0))
     .i SubscriptID'="" d
     ..s VersionID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),SubscriptID,0))
     ..i VersionID'="" s ArcItmRowid=SubscriptID_"||"_VersionID 
     S AppPartRowID=""
     i (BodyPartCode'="") d
	.s AppPartRowID=$o(^DHCAPPART(0,"Code",BodyPartCode,AppPartRowID))   
    q:(AppPartRowID="")
    i (ArcItmRowid'="")
    {
	    s bWrite=""
	    &sql(select count(*) into:bWrite from DHCRB_Memo where (DM_ARCItmMast_DR=:ArcItmRowid and DM_BodyPart_DR=:AppPartRowID))
	    i (bWrite=0) d
	    .&sql(Insert into DHCRB_Memo(DM_ARCItmMast_DR,DM_MTemplate_DR,DM_UseMethod_DR,DM_BodyPart_DR)values(:ArcItmRowid,:MTRowid,:UseMethodDR,:AppPartRowID))
	    e  d
	    .&sql(update DHCRB_Memo Set DM_MTemplate_DR=:MTRowid,DM_UseMethod_DR=:UseMethodDR where DM_ARCItmMast_DR =:ArcItmRowid and DM_BodyPart_DR=:AppPartRowID)
	    q SQLCODE
	}
}

/// do ##class(web.DHCRisCommFunctionEx).GetRISInfo("68238||526")
ClassMethod GetRISInfo(oeorditemdr As %String) As %String
{
	n (oeorditemdr)
	s (StudyNo,strRegDate,strRegTime,MainDoc,StudyNo,GetRptDocName,GetRptDate,GetRptTime)=""
	s (GetVerifyDocName,GetVerifyDate,GetVerifyTime,ReportUrl)=""
	
    if (oeorditemdr'="")
    {
	  s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,"")) 
	  i (regrowid'="")
	  {
		  i $d(^DHCPACRegInfo(regrowid)) d 
		  .s ^DHCPACRegInfo(regrowid)=$g(^DHCPACRegInfo(regrowid))
		  .s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
		  .s RegDate=$p($g(^DHCPACRegInfo(regrowid)),"^",8)
		  .i RegDate'="" s strRegDate=$zd(RegDate,3)
		  .s RegTime=$p($g(^DHCPACRegInfo(regrowid)),"^",9)
		  .i RegTime'="" s strRegTime=$zt(RegTime,1)
		  .s MainDocDr=$p($g(^DHCPACRegInfo(regrowid)),"^",5)
		  .i MainDocDr'="" s MainDoc=$p($g(^CTPCP(MainDocDr,1)),"^",2)
		  .i StudyNo'="" d
		  ..s ReportUrl=..GetReportUrl(oeorditemdr,StudyNo)
		  ..s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""))
		  ..i Rptrowid'="" d
		  ...s GetRptDocDR=$p($g(^DHCRBStudy("Report",Rptrowid)),"^",8)
          ...i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
          ...s GetRptDate=$p($g(^DHCRBStudy("Report",Rptrowid)),"^",9)
          ...i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
          ...s GetRptTime=$p($g(^DHCRBStudy("Report",Rptrowid)),"^",10)
          ...i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
          ...s GetVerifyDocDR=$p($g(^DHCRBStudy("Report",Rptrowid)),"^",11)
          ...i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
          ...s GetVerifyDate=$p($g(^DHCRBStudy("Report",Rptrowid)),"^",12)
          ...i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
          ...s GetVerifyTime=$p($g(^DHCRBStudy("Report",Rptrowid)),"^",13)
          ...i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
	  }
	  
	  s Info=StudyNo_"^"_strRegDate_"^"_strRegTime_"^"_MainDoc_"^"_GetRptDocName_"^"_GetRptDate_"^"_GetRptTime_"^"_GetVerifyDocName_"^"_GetVerifyDate_"^"_GetVerifyTime_"^"_ReportUrl
    }
	
	q Info
}

/// do ##class(web.DHCRisCommFunctionEx).GetReportUrl("70113||275","U20130717-003")
ClassMethod GetReportUrl(oeorditemdr As %String, StudyNo As %String, UserID As %String = "") As %String
{
    s (ResInfo,ReportFullFil,RhasReg,RRegParam,RhasStudyNo,RStuyParam)=""
    s (RDelim,ImageFullFile,IhasReg,IRegParam,IhasStudyNo,IStudyNoParam)=""
    s (IDelim,RhasOParam,IOtherParam,OrdRowid,EpisodeID,papatmasmdr,RegNo,RptParm,itemsub)=""
    s (OEOrdItem,LocDr)=""
    i UserID="" s UserID="1"
    
    q:(oeorditemdr="") ""
    s OrdRowid=$p(oeorditemdr,"||",1)
    s itemsub=$p(oeorditemdr,"||",2)
    s LocDr=$p(^OEORD(OrdRowid,"I",itemsub,3),"^",6)
    s EpisodeID=$p($g(^OEORD(OrdRowid)),"^",1)
    s papatmasmdr=$p(^PAADM(EpisodeID),"^",1)
    s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
    
	s ClinicDr=0
	s ClinicDr=$o(^DHCRBCi("LocClinicSet",LocDr,ClinicDr)) q:(ClinicDr="") ""
	s ReportFullFil=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",2)
	s RhasReg=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",3)
	s RRegParam=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",4)
	s RhasStudyNo=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",5)
	s RStuyParam=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",6)
	s RDelim=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",7)
	s ImageFullFile=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",8)
	s IhasReg=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",9)
	s IRegParam=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",10)
	s IhasStudyNo=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",11)
	s IStudyNoParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",12)
	s IDelim=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",13)
	s RhasOParam=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",14)
	s IOtherParam=$P($g(^DHCRBC("ClinicSet",ClinicDr)),"^",15)
	
	if (RhasReg="Y")
	{
		s RptParm=RRegParam_""_RegNo
	}
	if (RDelim'="")
	{
		s RptParm=RptParm_""_RDelim
	}
	if (RhasStudyNo="Y")
	{
	    s RptParm=RptParm_""_StudyNo
	}
	if (RhasOParam="Y")
	{
	   if (IOtherParam="DHCC")
	   {
	      //s OEOrdItem=StudyNo
	     s RptParm="&LID="_LocDr_"&SID="_StudyNo_"&OID="_oeorditemdr_"&USERID="_UserID
	   }elseif (IOtherParam="?OID=")
	   {
		   s RptParm="?OID="_oeorditemdr_"&USERID="_UserID
	   }
	   else
	   {
		  s OEOrdItem=OrdRowid_"_"_itemsub
	   }	
	   
	   //s RptParm=OrdRowid_"_"_itemsub   
	  
	}
	
	s RptParm=ReportFullFil_""_RptParm
	
	if (ReportFullFil="RptView.DLL")
	{
		s RptParm="RptView.DLL"
	}
	if (ReportFullFil="PISRptView.DLL")
	{
		s RptParm="PISRptView.DLL"
	}
	
	q RptParm
}

// do ##class(web.DHCRisCommFunctionEx).GetReportImage("U20120702-003")

ClassMethod GetReportImage(StudyNo As %String) As %String
{
	q:(StudyNo="") ""
	s (IP,Port,User,Pwd,ftpInfo,FTPURL,ImgName,MediumDR,MediumName)=""
	s (Info,ImageUrl)=""
	
	s ftpInfo=##class(web.DHCRisclinicQueryOEItemDo).GetFTPByStudyNo(StudyNo)
	s IP=$p($g(ftpInfo),"^",1)
	s Port=$p($g(ftpInfo),"^",2)
	s User=$p($g(ftpInfo),"^",3)
	s Pwd=$p($g(ftpInfo),"^",4)
	s FTPURL="ftp://"_User_":"_Pwd_"@"_IP
	s ImgDR="" f  s ImgDR=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,ImgDR)) q:(ImgDR="")  d
	.s ImgName=$p(^DHCRBStudy(0,"StudyImages",ImgDR),"^",1)
	.s MediumDR = $p(^DHCRBStudy(0,"StudyImages",ImgDR),"^",6)
	.i MediumDR'=""  s MediumName = $p(^DHCRBCServer("Medium",MediumDR),"^",2)
	.s ImageUrl=FTPURL_"\"_MediumName_ImgName
	.i Info="" d
	..s Info=ImageUrl
	.e  d
	..s Info=Info_"^"_ImageUrl
	q Info
}

// do ##class(web.DHCRisCommFunctionEx).GetRptURL("76991||1","U20120702-003")

ClassMethod GetRptURL(oeorditemdr As %String = "", StudyNo As %String) As %String
{
	q:(StudyNo="") ""
	
	s (IP,Port,User,Pwd,FTPURL)=""
	s ftpInfo=##class(web.DHCRisclinicQueryOEItemDo).GetFTPByStudyNo(StudyNo)
	s IP=$p($g(ftpInfo),"^",1)
	s Port=$p($g(ftpInfo),"^",2)
	s User=$p($g(ftpInfo),"^",3)
	s Pwd=$p($g(ftpInfo),"^",4)
	s FTPURL="ftp://"_User_":"_Pwd_"@"_IP
	
	s FullFilePath="",RptRowId="",StatusCode="",StatusDR=""
	s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId),-1)
	q:(RptRowId="") ""
	s ReportID=$p($g(^DHCRBStudy("Report",RptRowId)),"^",2)
	s StatusDR=$p($g(^DHCRBStudy("Report",RptRowId)),"^",4)
	s StatusCode=""
	i (StatusDR'="")
	{ 
	   s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	}
	i StatusCode="S" d
    .s FullFilePath=""
	.s RptFileRowid=$o(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid))
	.i (RptFileRowid'="") d
	..s FullFileName = $P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",1)
	..q:(FullFileName="")
	..s MediumDR=$P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",3)
	..q:(MediumDR="")
	..s MediumName = $p(^DHCRBCServer("Medium",MediumDR),"^",2)
	..s FullFilePath=""
	..s FullFilePath=FTPURL_"/"_MediumName_FullFileName  
	.q:(FullFilePath="") 
	
	q FullFilePath
}

// 函数 GetBillStatus  获取医嘱的收费状态

ClassMethod GetBillStatus(OrderRowid, itemsub, FileVersion As %String = "", ItemStatusCode As %String = "") As %String
{
	s BillDesc="",billed="",Info=""
	s paadmRowid=$p(^OEORD(OrderRowid),"^",1) 
	s patienttype=$p(^PAADM(paadmRowid),"^",2) ;病人类型
	
	if (FileVersion'="V7.0")
	{
	  	i (patienttype="I")&(ItemStatusCode="E")
	  	{
		   s BillDesc="已收费"	
		   s billed="P"
		}
		else
		{
		   s billed=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",5)
		   i billed'="" s BillDesc=..GetBilledDesc(billed)
		}
	 }
	 else
	 {
	  	 i (patienttype="I")
	  	 {
	        s xrowid=$o(^OEORD(OrderRowid,"I",itemsub,"X",0))
	        i xrowid'="" d
	        .s billed=$p(^OEORD(OrderRowid,"I",itemsub,"X",xrowid),"^",6) 
	        .i billed'="" s BillDesc=..GetBilledDesc(billed)
	  	 }
	     else
	     {
	        s billed=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",5)
	        i billed'="" s BillDesc=..GetBilledDesc(billed)
	     }
	 }
	    
	 s Info=BillDesc_"^"_billed
	 	
	 q Info
}

/// do ##class(web.DHCRisCommFunctionEx).BodyPartsInterface("59866||688")
ClassMethod BodyPartsInterface(OEOrdItemID As %String) As %String
{
	q:(OEOrdItemID="") "-"
	s (arcimid,BInfo,PInfo,value,PostureDR)=""
	s OrderRowid=$p(OEOrdItemID,"||",1)
	s itemsub=$p(OEOrdItemID,"||",2)
	
	s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	i (arcimid'="")
	{
	   s Rowid="" f  s Rowid=$o(^DHCRBCi("ItemToBodyPart",0,arcimid,Rowid))  q:Rowid=""  d
	   .s (BodyPartDR,BodyPart)=""
	   .s BodyPartDR=$p($g(^DHCRBC("ItemToBodyPart",Rowid)),"^",2)
	   .i BodyPartDR'="" d
	   ..s BodyPart=$p($g(^MRC("BODP",BodyPartDR)),"^",2)
	   ..f  s PostureDR=$o(^DHCRBCi("PosturetoBodyPart",0,BodyPartDR,PostureDR)) q:PostureDR=""  d
	   ...s Posture=""
	   ...s Posture=$p($g(^DHCRBC("PosturetoBodyPart",PostureDR)),"^",2)
	   ...i PInfo="" s PInfo=Posture
       ...e  d
       ....s PInfo=PInfo_"、"_Posture
	   ..i BInfo="" s BInfo=BodyPart
       ..e  d
       ...s BInfo=BInfo_"、"_BodyPart
       
	}
	
	s value=PInfo_"^"_BInfo
	
	q value
}

/// w ##class(web.DHCRisCommFunctionEx).GetHISInfotoRIS("20017||3877")
ClassMethod GetHISInfotoRIS(oeorditemdr As %String) As %String
{
	s (NoDR,No,LocIndex,SIndex,BodyPartDR,BodyPartCode,CodeInfo)=""
	s Info="^^^"
	if (oeorditemdr'="")
    {
	  s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,"")) 
	  i (regrowid'="")
	  {
		  i $d(^DHCPACRegInfo(regrowid)) d 
		  .s StudyNo=$p($g(^DHCPACRegInfo(regrowid)),"^",2)
		  .i StudyNo'="" s SIndex=$p(StudyNo,"-",2)
		  .s NoDR=$p($g(^DHCPACRegInfo(regrowid)),"^",3)
		  .i NoDR'="" s No=$p($g(^DHCPACRegInfoNO("NO",0,NoDR)) ,"^",3)
		  .s LocIndex=$p($g(^DHCPACRegInfo(regrowid)),"^",15)
		  .s ChildSub="" f  s ChildSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub)) q:ChildSub=""  d
		  ..s BodyPartDR=$p(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub),"^",1)
		  ..i BodyPartDR'=""  s BodyPartCode=$p(^MRC("BODP",BodyPartDR),"^",1)
		  ..i CodeInfo="" s CodeInfo=BodyPartCode
		  ..e  d
		  ...s CodeInfo=CodeInfo_"&"_BodyPartCode
		       
	  }
	  
	  s Info=No_"^"_SIndex_"^"_LocIndex_"^"_CodeInfo
    }
    
    q Info
}

/// w ##class(web.DHCRisCommFunctionEx).NoBookedSvrGroup("76984||3")
ClassMethod NoBookedSvrGroup(oeorditemdr As %String) As %String
{
	s NBKSvr="N"
	q:(oeorditemdr="") NBKSvr
	
	s OrderRowid=$p(oeorditemdr,"||",1)
	s itemsub= $p(oeorditemdr,"||",2)
	s arcimid="",ServiceGroupDR="",ServiceDesc=""
	
	if $d(^OEORD(OrderRowid,"I",itemsub,1))
	{
		s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
		i arcimid'="" s ServiceGroupDR=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),8)),"^",7)
		i ServiceGroupDR'="" s ServiceDesc=$p($g(^RBC("SG",ServiceGroupDR)),"^",2)
		i ServiceDesc="不需预约"  s NBKSvr="Y"
	}
	
	q NBKSvr
}

/// 提交表单
ClassMethod insertFormData(input As %String, OEorditemID As %String) As %String
{
	s Count=$l(OEorditemID,"@")
    for i=1:1:Count 
    {
      s perOrditemRowid=$p($g(OEorditemID),"@",i)
	  s ^DHCRISTOOTHNUM(perOrditemRowid)=input
    }
	s resultString="{success:'true',msg:'ok'}"
	q resultString //返回数据
}

ClassMethod GetToothData(OEorditemID As %String = "") As %String
{
	s ToothData=""
	q:(OEorditemID="") ToothData
	s pOEorditemID=$p($g(OEorditemID),"@",1)
	s ToothData=$g(^DHCRISTOOTHNUM(pOEorditemID))
	q ToothData
}

/// d ##class(web.DHCRisCommFunctionEx).SetPK()
ClassMethod SetPK()
{
	s Info="A^B^C^D^E^F^G^H^I^J^K^L^M^N^O^P^Q^R^S^T^U^V^W^X^Y^Z"
	s Info1="a^b^c^d^e^f^g^h^i^j^k^l^m^n^o^p^q^r^s^t^u^v^w^s^y^z"
	s Info2="0^1^2^3^4^5^6^7^8^9"
	s Infos=Info_"^"_Info1_"^"_Info2
	s count=$l(Infos,"^")
	f i=1:1:count d
    .s PH=$p(Infos,"^",i)
	.s ^RISHZPYK(PH)=PH
	q
}

/*ClassMethod IsBooked(EpsodeId As %String) As %String
{
 	n (EpsodeId)
 	s BKDate=+$h
 	
 	Quit:EpsodeId="" 
 	s Info="",IsConflict="N",ret=""
	s OrderRowid=""
	s OrderRowid=$o(^OEORD(0,"Adm",EpsodeId,OrderRowid))
  	i $g(OrderRowid)="" Set qHandle=$lb(0,repid,0)
 	q:$g(OrderRowid)="" $$$OK
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s IsReg="",IsBook=""
	.s OrdItemRowid=OrderRowid_"||"_itemsub
	.s IsReg=..GetRegFlag(OrdItemRowid)
	.q:(IsReg="Y")
	.s IsBook=..GetBKFlagbyDate(OrdItemRowid,BKDate)
	.i IsBook="Y" s IsConflict="Y"
	.i IsConflict="Y" BREAK:IsConflict
	
    q IsConflict
}

/// w ##class(web.DHCRisCommFunctionEx).GetBKFlagbyDate("20017||3870")
ClassMethod GetBKFlagbyDate(oeorditemdr As %String, InDate As %String) As %String
{
	s BOOK="N",Rowid="",CancelFlag="",ERowid=""
	q:(oeorditemdr="") BOOK
	
	s Rowid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,Rowid))
	i Rowid'="" s CancelFlag=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",7) 
	i ((Rowid'="")&(CancelFlag'="Cancel")) d
	.s ResSchduleID=""
	.s ResSchduleID=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",2)
	.q:(ResSchduleID="")
	.s Date=""
	.s Date=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",16)
	.i ((Date'="")&(InDate=Date)) s BOOK="Y"
	.i BOOK="Y"  BREAK:BOOK
	
	i BOOK="N"  d
	.s Date=""
	.s ERowid=$o(^DHCRBCExternalBookInfoi("OrdItemID",oeorditemdr,ERowid))
	.i ERowid'="" s Date=$p($g(^DHCRBCExternalBookInfo(ERowid)),"^",8)
	.i ((Date'="")&(InDate=Date)) s BOOK="Y"
	.i BOOK="Y"  BREAK:BOOK
	
	q BOOK
}*/
/// w ##class(web.DHCRisCommFunctionEx).IsBooked("20019")
/// 根据就诊ID查询是否有预约的医嘱
/// 入参:EpsodeId
/// 返回值:有-1  无-0
/// w ##class(web.DHCRisCommFunctionEx).IsBooked("20019")
ClassMethod IsBooked(EpsodeId As %String) As %String
{
    s Info="",IsConflict="0",ret="",Count=0
 	q:(EpsodeId="")
 
	s OrderRowid=""
	s OrderRowid=$o(^OEORD(0,"Adm",EpsodeId,OrderRowid))
    q:(OrderRowid="")
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s IsReg="",IsBook=""
	.s OrdItemRowid=""
	.s OrdItemRowid=OrderRowid_"||"_itemsub
	.s IsReg=..GetRegFlag(OrdItemRowid)
	.q:(IsReg="Y")
	.s IsBook=..GetBKFlagbyDate(OrdItemRowid)
	.i IsBook="Y" s Count=Count+1
	i Count>=1  s IsConflict="1"
	
    q IsConflict
}

/// do ##class(web.DHCRisCommFunctionEx).GetBKFlagbyDate("20017||3870")
ClassMethod GetBKFlagbyDate(oeorditemdr As %String) As %String
{
	s BOOK="N",Rowid="",CancelFlag="",ERowid=""
	s oeorditemdr=$p($g(oeorditemdr),"@",1)
	q:(oeorditemdr="") BOOK
	
	s Rowid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,Rowid))
	i Rowid'="" s CancelFlag=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",7) 
	i ((Rowid'="")&(CancelFlag'="Cancel")) d
	.s ResSchduleID=""
	.s ResSchduleID=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",2)
	.q:(ResSchduleID="")
	.s BOOK="Y" 
	.i BOOK="Y" BREAK:BOOK
	
	i BOOK="N"  d
	.s Date=""
	.s ERowid=$o(^DHCRBCExternalBookInfoi("OrdItemID",oeorditemdr,ERowid))
	.i ERowid'="" s BOOK="Y"
	.i BOOK="Y" BREAK:BOOK
	
	q BOOK
}

/// w ##class(web.DHCRisCommFunctionEx).GetRegFlag("20017||3894")
ClassMethod GetRegFlag(oeorditemdr As %String) As %String
{
	 s RegFlag="N"
	 q:(oeorditemdr="") RegFlag
     
	 s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))  ; 登记的表中获得检查号
	 i regrowid'=""  s RegFlag="Y"
     q RegFlag
}

/// do ##class(web.DHCRisCommFunctionEx).ExistMemo("75911||57")
ClassMethod ExistMemo(OEOrdItemID As %String) As %String
{
	q:(OEOrdItemID="")
	s OEOrdItemID=$p(OEOrdItemID,"@",1)
	
	s OrderRowid=$p(OEOrdItemID,"||",1)
	s itemsub=$p(OEOrdItemID,"||",2)
	s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	s Memo="",MRowid="",MTRowid="",ERowid=""
	s IsExist="N"
	
	i arcimid'="" d
	.s MRowid=$o(^DHCRBAppi("Memo-ItMast",arcimid,0))
	.i MRowid'="" d
	..s MTRowid=$p($g(^DHCRBApp("Memo",MRowid)),"^",4)
	..i MTRowid'=""  s Memo=$p($g(^DHCRBCApp("Memo-Template",MTRowid)),"^",3)
	..i Memo="" s Memo=$p($g(^DHCRBApp("Memo",MRowid)),"^",2)
	..i Memo'="" s IsExist="Y"
	
	i ((Memo="")!(Memo=" ")) d
	.s ERowid=$o(^DHCRBCExternalBookInfoi("OrdItemID",OEOrdItemID,ERowid))
	.i ERowid'="" s Memo=$p($g(^DHCRBCExternalBookInfo(ERowid)),"^",10)
	.i Memo'="" s IsExist="Y"
	
	q IsExist
}

/// w ##class(web.DHCRisCommFunctionEx).NursePrintFlag("70113||280")
ClassMethod NursePrintFlag(OEOrdItemID) As %String
{
	s Print="",ret=""
	q:(OEOrdItemID="")
	
	s ret=##class(web.DHCRisWardQuery).IsPrint(OEOrdItemID)
	i ret="Y" s Print=1
	e  s Print=0
	
	q Print
}

/// w ##class(web.DHCRisCommFunctionEx).GetNoPrintBKInterface(EpsodeId)
/// 根据就诊ID查询已预约的并且预约日期>=当天的核实医嘱
/// 入参:EpsodeId
/// 返回值:有-1  无-0
/// w ##class(web.DHCRisCommFunctionEx).GetNoPrintBKInterface("20019")
ClassMethod GetNoPrintBKInterface(EpsodeId As %String) As %String
{
    s Info="",IsConflict="0",ret="",Count=0
 	q:(EpsodeId="")
 
	s OrderRowid=""
	s OrderRowid=$o(^OEORD(0,"Adm",EpsodeId,OrderRowid))
    q:(OrderRowid="")
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s IsReg="",IsBook="",ItemStatDR="",ItemStatusCode=""
	.s ItemStatDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13) ; 医嘱状态
	.i ItemStatDR'="" s ItemStatusCode=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
	.q:(ItemStatusCode'="V")
	.s OrdItemRowid=""
	.s OrdItemRowid=OrderRowid_"||"_itemsub
	.s IsReg=..GetRegFlag(OrdItemRowid)
	.q:(IsReg="Y")
	.s IsBook=..GetBKNoPrintFlag(OrdItemRowid)
	.i IsBook="Y" s Count=Count+1
	i Count>=1  s IsConflict="1"
	
    q IsConflict
}

/// do ##class(web.DHCRisCommFunctionEx).GetBKNoPrintFlag("20017||3870")
ClassMethod GetBKNoPrintFlag(oeorditemdr As %String) As %String
{
	s BOOK="N",Rowid="",CancelFlag="",ERowid=""
	s BKDate=+$h
	q:(oeorditemdr="") BOOK
	
	s Rowid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,Rowid))
	i Rowid'="" s CancelFlag=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",7) 
	i ((Rowid'="")&(CancelFlag'="Cancel")) d
	.s ResSchduleID=""
	.s ResSchduleID=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",2)
	.q:(ResSchduleID="")
	.s GetBKDate=""
	.s GetBKDate=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
	.q:((GetBKDate'="")&(GetBKDate<BKDate)&('$d(^DHCRISORDITEMPRINTED(oeorditemdr))))
	.s BOOK="Y" 
	.i BOOK="Y" BREAK:BOOK
	
	i BOOK="N"  d
	.s GetBKDate=""
	.s ERowid=$o(^DHCRBCExternalBookInfoi("OrdItemID",oeorditemdr,ERowid))
	.i ERowid'="" s GetBKDate=$p($g(^DHCRBCExternalBookInfo(ERowid)),"^",5)
	.q:((GetBKDate'="")&(GetBKDate<BKDate)&('$d(^DHCRISORDITEMPRINTED(oeorditemdr))))
	.i ERowid'="" s BOOK="Y"
	.i BOOK="Y" BREAK:BOOK
	
	q BOOK
}

/// w ##class(web.DHCRisCommFunctionEx).IsServiceItm("20017||3870")
ClassMethod IsServiceItm(oeorditemdr As %String) As %String
{
   
    s Ser="N"
	q:(oeorditemdr="") Ser
	s (OrderRowid,itemsub,arcimid,ServerMaterial)="" 
    s OrderRowid=$p(oeorditemdr,"||",1)
    s itemsub=$p(oeorditemdr,"||",2)
    s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2) 
    q:(arcimid="") Ser
    s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
    i ServerMaterial="S" s Ser="Y"
    q Ser
}

/// w ##class(web.DHCRisCommFunctionEx).ExistStopItem("20017||3870")
/// 函数名称:ExistStopItem
/// 功能:判断传入医嘱是否存在停止医嘱
/// 入参:医嘱ID@医嘱ID@....
/// 返回值: 是-Y 否-N
/// 日期:2014-08-14
/// 作者:sunyi
ClassMethod ExistStopItem(OEOrdItmIDArray As %String) As %String
{
   
     s Exit="N"
     s countArray=0
	 s countArray=$l(OEOrdItmIDArray,"@")
     for j=1:1:countArray 
     {  
        q:(Exit="Y")
        s orderItemBody=$p(OEOrdItmIDArray,"@",j)
        s perOrditemID=$p(orderItemBody,"$",1)
        if (perOrditemID="")
        {
	        continue
        }
        s OrderRowid=$p(perOrditemID,"||",1)
        s itemsub=$p(perOrditemID,"||",2)
        s ItemStatDR=""
        s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
		i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
		i ItemStatusCode="D" s Exit="Y"
     }
     
     q Exit
}

/// CreatDate:    2009.04.01
/// Description:  对中文做utf-8转换,解决P8中文传递参数时的 bug
/// Table:       
/// Input:        InStr:字符串
/// Others:       为了解决P8版本汉字模糊查询翻页后无法正常显示的问题
/// 在在组件使用该类方法得到值及Query中执行查询前进行该转换  
/// Return:       装换后的字符串
ClassMethod UnEscape(InStr As %String) As %String
{
	s num=1,retStr="",tmpNum=1
	f num=1:1:$l(InStr,"%") d
	.s char=$p(InStr,"%",num)
	.i num=1 d
	..s retStr=$e(char,1,$l(char))
	.e  d
	..i $e(char,1,1)'="u" d
	...s retStr=retStr_$char($zhex($e(char,1,2)))_$e(char,3,$l(char))
	..e  d
	...s retStr=retStr_$char($zhex($e(char,2,5)))_$e(char,6,$l(char))
	q retStr
}

/// 函数:GetServiceGroup
/// 入参:医嘱项ID
/// 返回值:服务组ID^服务组
/// 作者:sunyi 2014-12-26
/// w ##class(web.DHCRisCommFunctionEx).GetServiceGroup("10446||1","192")
ClassMethod GetServiceGroup(arcimid, bodyRowid As %String = "") As %String
{
	s SerGroup="",SerGroupDR="",BPRowid="",Info="",SerID="",SerDesc=""
	s Find=0
	
	if (bodyRowid'="")
	{
		;b //01
		s bookparamRowid=""
		s bookparamRowid=$o(^User.DHCRBCBookParamI("IndexItemBody",arcimid,bodyRowid,0))
		if (bookparamRowid'="")
		{
			;b //03
			s child=""
			for 
			{
				s child=$o(^User.DHCRBCBookParamD(bookparamRowid,"BPChild",child))
				;b //04
				q:(child="")
				s SerGroupDR=$lg($g(^User.DHCRBCBookParamD(bookparamRowid,"BPChild",child)),2)
				;b //02
				i SerGroupDR'=""  s SerGroup=$p($g(^RBC("SG",SerGroupDR)),"^",2)
				i SerID="" s SerID=SerGroupDR
				e  s SerID=SerID_","_SerGroupDR
				i SerDesc="" s SerDesc=SerGroup
				e  s SerDesc=SerDesc_","_SerGroup
			}
			
		}
		
	}
	else //if (SerID="")
	{
		s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
		i (BPRowid'="")
		{
		  s SubRowid="" f  s SubRowid=$o(^DHCRBCItemBookPropertySG("ServiceGroup",BPRowid,SubRowid)) q:(SubRowid="")  d
		  .s (Rowid,SerGroupDR,SerGroup)=""
		  .s Rowid=BPRowid_"||"_SubRowid
		  .s SerGroupDR=$p($g(^DHCRBCItemBookPropertySG("ServiceGroup",BPRowid,SubRowid)),"^",4)
		  .i SerGroupDR'="" s SerGroup=$p($g(^RBC("SG",SerGroupDR)),"^",2)
		  .i SerID="" s SerID=SerGroupDR
		  .e  d
		  ..s SerID=SerID_","_SerGroupDR
		  .i SerDesc="" s SerDesc=SerGroup
		  .e  d
		  ..s SerDesc=SerDesc_","_SerGroup
		  .s Find=1
		}
	
		/*
		if (Find=0)
		{
			s SerID=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),8),"^",7)
	        i SerID'="" s SerDesc=$p($g(^RBC("SG",SerID)),"^",2)
		}
		*/
	}
	
	s Info=SerID_"^"_SerDesc
	q Info
}

/// w ##class(web.DHCRisCommFunctionEx).GetServicebySerID("6@7@8@9")
ClassMethod GetServicebySerID(SerRowidArray As %String) As %String
{
	 s ServiceCount=0
	 s ServiceCount=$l(SerRowidArray,"@")
	 s Info=""
     for t=1:1:ServiceCount 
     {
	     s perSer="" 
	     s perSer=$p(SerRowidArray,"@",t)
	     i perSer'="" d
	     .i Info="" s Info=$p($g(^RBC("SG",perSer)),"^",2)
	     .e  d
	     ..s Info=Info_"@"_$p($g(^RBC("SG",perSer)),"^",2)
	 }
	q Info
}

/// w ##class(web.DHCRisCommFunctionEx).GetDigitalDateFormat("17/01/2015")
/// w ##class(web.DHCRisCommFunctionEx).GetDigitalDateFormat("17/01/2015")
ClassMethod GetDigitalDateFormat(Date As %String) As %String
{
	s DMYCount=0
	s YMDCount=0
	
	i (Date'="")
	{
		s DMYCount=$l(Date,"-")
		s YMDCount=$l(Date,"/")
		i DMYCount=3 d
		.s Date=$zdh(Date,3)
		i YMDCount=3 d
		.s Date=$zdh(Date,4)
	}else
	{
		s Date=$p($h,",",1)
	}
	
	q Date
}

/// w ##class(web.DHCRisCommFunctionEx).GetLocBookSet("83")
ClassMethod GetLocBookSet(LocDR) As %String
{
	s StartBk="N"
	q:(LocDR="") StartBk
	
	s LocParamRowid=""
	s LocParamRowid=$o(^DHCRBC("Loc",LocDR,LocParamRowid))
	i LocParamRowid'="" s StartBk=$P($g(^DHCRBC("LocParam",LocParamRowid)),"^",24)
	
	q StartBk
}

/// w ##class(web.DHCRisCommFunctionEx).Replace("abcdefghijklmn&KeyEnter;opqrstuvwxyz","&KeyEnter;","\n")
ClassMethod Replace(Strings, Str, Rep) As %String [ Language = basic ]
{
	   
	   return Replace(Strings,Str,Rep)
}

/// Check if query exists for a class
/// w ##class(websys.Conversions).IsValidMethodName("web.1","EventLog")
ClassMethod IsValidMethodName(classname As %Library.String, methodname As %Library.String) As %Library.Boolean
{
	n (classname, methodname)
	s $ZT="ERROR^DHCSSERR"
	q:((classname="")||(methodname="")) 0
	s myobj=##class(%Dictionary.CompiledMethod).%OpenId(classname_"||"_methodname)
	s myrtn=0
	i ($IsObject(myobj)){
		s myobj=""
		s myrtn = 1
	}
	q myrtn
}

/// Check if query exists for a class
ClassMethod IsValidQueryName(classname As %Library.String, queryname As %Library.String) As %Library.Boolean
{
	n (classname, queryname)
	s $ZT="ERROR^DHCSSERR"
	;q $$$OK
	
	q:((classname="")||(queryname="")) 0
	
	s myobj=##class(%Dictionary.CompiledQuery).%OpenId(classname_"||"_queryname)
	s myrtn=0
	
	i ($IsObject(myobj)){
		s myobj=""
		s myrtn = 1
	}
	q myrtn
}

ClassMethod IsValidClassName(classname As %Library.String) As %Library.Boolean
{
	n (classname)
	s $ZT="ERROR^DHCSSERR"
	q:(classname="") 0
	s myobj=##class(%Dictionary.CompiledClass).%OpenId(classname)
	s myrtn=0
	i ($IsObject(myobj)){
		s myobj=""
		s myrtn = 1
	}
	q myrtn
}

/// Get the computer name from the ip address.
/// w ##class(web.DHCRisCommFunctionEx).GetComputerName("127.0.0.1")
ClassMethod GetComputerName(ip As %Library.String) As %Library.String
{
	n (ip)
	; w ##class(websys.Conversions).GetComputerName("172.21.21.2")
	s $ZT="ERROR^DHCSSERR"
	
	s mycompname=""
	
	q:(ip="") mycompname
	set bin = $zu(54,1,ip)
	s mycompinfo = $zu(54,14,bin)
	s mycompname = $p(mycompinfo,",",2)
	
	q mycompname
}

/// 获取检查状态
/// do ##class(web.DHCRisCommFunctionEx).GetLoctStatusList()
ClassMethod GetLoctStatusList() As %String
{
	s ret="A"_$C(1)_"申请"_"^"_"B"_$C(1)_"预约"_"^"_"I"_$C(1)_"登记"_"^"_"O"_$C(1)_"检查完成"_"^"
	s ret=ret_"V"_$C(1)_"审核"_"^"_"CA"_$C(1)_"取消登记"_"^"_"R"_$C(1)_"已录入"_"^"_"IM"_$C(1)_"已有图像"
	q ret
}

/// ZT001994^^^^自动预约^N^^病房01诊室，病房02诊室，病房03诊室，病房04诊室，病房05诊室，病房06诊室，病房07诊室，妇产超声1诊室，妇产超声2诊室，病房08诊室，病房10诊室，病房11诊室，妇产超声3诊室，门诊负一楼01诊室，门诊负一楼02诊室，门诊负一楼04诊室，门诊负一楼05诊室，门诊负一楼06诊室，门诊负一楼08诊室，门诊负一楼07诊室，门诊负一楼09诊室，门诊负一楼10诊室，门诊负一楼11诊室，门诊负一楼12诊室，门诊负一楼13诊室，门诊负一楼14诊室，门诊负一楼15诊室，门诊负一楼16诊室，门诊负一楼18诊室，门诊负一楼19诊室，门诊负一楼20诊室，东院高干病房楼1，东院高干病房楼2，东院高干病房楼3，东院高干病房楼4^
/// w ##class(web.DHCRisCommFunctionEx).ImportBSExcelData("WL0053^123^63492189^N^自动预约^N^^Vivi7组,IU22组^")
ClassMethod ImportBSExcelData(Info As %String) As %String
{
	s ^DHCRis("BSInfo")=Info
	s ArcItmCode=$p($g(Info),"^",1)
	s Location=$p($g(Info),"^",2)
	s Telphone=$p($g(Info),"^",3)
	s AutoIuputFee=$p($g(Info),"^",4)
    s AppointDesc=$p($g(Info),"^",5)
    s IsEmpty=$p($g(Info),"^",6)
    s AppLoc=$p($g(Info),"^",7)
    s ServiceGroup=$p($g(Info),"^",8)
    s ExamTime=$p($g(Info),"^",9)
    
    s ArcItmRowid="" ,SubscriptID="",VersionID="",AppMRowid="",DIPRowid="",GetArcItmRowid=""
    s SerGroupCount=0
    
    i ArcItmCode'="" d
     .s SubscriptID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),0))
     .i SubscriptID'="" d
     ..s VersionID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),SubscriptID,0))
     ..i VersionID'="" s ArcItmRowid=SubscriptID_"||"_VersionID
     ..s DIPRowid=$o(^DHCRBCItemBookProperTypei(ArcItmRowid,0))
     ..i DIPRowid'="" s GetArcItmRowid=$p(^DHCRBCItemBookProperty(DIPRowid),"^",1)
     
    i AppointDesc'="" d
    .s AppMethodID=0 f  s AppMethodID=$o(^DHCRBCAppointMethod(AppMethodID)) q:(AppMethodID="")  d
    ..s AppDesc=$p(^DHCRBCAppointMethod(AppMethodID),"^",2)
    ..i (AppDesc=AppointDesc) s AppMRowid=AppMethodID

    i (AutoIuputFee="是")
    {
	   s AutoIuputFee="Y" 
	}
	else
	{  
	   s AutoIuputFee="N"
	}
	
	i (IsEmpty="是")
	{
	   s IsEmpty="Y"
	}
	else
	{
	   s IsEmpty="N"	
	}
    
    s ParentRefRowid=""
	i (ArcItmRowid=GetArcItmRowid)
	{
	    &sql(update DHCRBC_ItemBookProperty set DIBP_AppointMethod_ID=:AppMRowid,DIBP_AutoInputFee=:AutoIuputFee,
	                 DIBP_IsEmpty=:IsEmpty,DIBP_Location=:Location,DIPB_Telphone=:Telphone,DIPB_AppLocation=:AppLoc,
	                 DIPB_Time=:ExamTime where DIBP_ARCItmMast_DR =:ArcItmRowid)
	    
	}
	else
	{
	    &sql(insert into DHCRBC_ItemBookProperty (DIBP_ARCItmMast_DR,DIBP_AppointMethod_ID,DIBP_AutoInputFee,DIBP_IsEmpty,DIBP_Location,DIPB_Telphone,DIPB_AppLocation,DIPB_Time)
	       values (:ArcItmRowid,:AppMRowid,:AutoIuputFee,:IsEmpty,:Location,:Telphone,:AppLoc,:ExamTime))
	    
	} 
	&sql(delete from DHCRBC_ItemBookProperty_ServiceG where DIPS_ArcItem_DR=:ArcItmRowid)
	s ParentRefRowid=$p(%ROWID,$c(1))
	
	i (ParentRefRowid'="")
	{
		i ServiceGroup'="" d
		.s SerGroupCount=$l(ServiceGroup,",")
		.f i=1:1:SerGroupCount d
		..s ServiceGroupId=""
		..s perServiceGroup=$p(ServiceGroup,",",i)
	    ..s ServiceGroupId=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(perServiceGroup),0))
	    ..i ServiceGroupId'="" d
	    ...s SameCount=0
	    ...&sql(select count(*) into :SameCount from DHCRBC_ItemBookProperty_ServiceG 
	         where DIPS_ArcItem_DR=:ArcItmRowid And DIPS_ServiceGroup_DR=:ServiceGroupId)
	    ...i SameCount=0 d
	    ....&sql(Insert into DHCRBC_ItemBookProperty_ServiceG(DIPS_ParentRef,DIPS_ArcItem_DR,DIPS_ServiceGroup_DR) values(:ParentRefRowid,:ArcItmRowid,:ServiceGroupId))	
	}
    s ServiceGroupId1=""
    &sql(update  ARC_ItmMast(ARCIM_ServiceGroup_DR) values (:ServiceGroupId1) where  ARCIM_RowId=:ArcItmRowid)
	q SQLCODE
}

/// w ##class(web.DHCRisCommFunctionEx).GetPWDbyUser("demo")
ClassMethod GetPWDbyUser(UserCode) As %String
{
	s Rowid="",PWD=""
	s Rowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),Rowid))  
	i Rowid'="" d
	.s PWD=$p($g(^SSU("SSUSR",Rowid)),"^",3)
	.s persistPWD=##class(web.Util.Encryption).MD5HexStr(PWD)
	q persistPWD_"^"_dd1_"^"_dd2
}

ClassMethod H(A) As %String
{
       
        s OrderRowid=$p(A,"||",1)
        s itemsub=$p(A,"||",2)
	    s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
		i ItemStatDR'="" s ItemStatusCode=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
		q ItemStatusCode
}

/// w ##class(web.DHCRisCommFunctionEx).GetArcItemID("285||5")
ClassMethod GetArcItemID(oeorditemdr As %String) As %String
{
	s arcimid="",OrderRowid="",arcimid=""
	q:(oeorditemdr="") ""
	s OrderRowid=$p($g(oeorditemdr),"||",1)
	s itemsub=$p($g(oeorditemdr),"||",2)
	s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	q arcimid
}

/// w ##class(web.DHCRisCommFunctionEx).GetPatmasDR("321")
ClassMethod GetPatmasDR(paadmdr As %String) As %String
{
	 s papatmasmdr=""
	 if (paadmdr'="")
     {
       i $d(^PAADM(paadmdr))
       {
         s papatmasmdr=$p($g(^PAADM(paadmdr)),"^",1)
       }
     }  
     q papatmasmdr
}

/// w ##class(web.DHCRisCommFunctionEx).GetBookFormatParam("2015-09-22 10:00:00-12:00:00")
ClassMethod GetBookFormatParam(Info As %String) As %String
{
	s Param=""
	q:(Info="") Param
	
	s Date="",Stime="",EndTime=""
	
	if (Info'="")
	{
		s Date=$p(Info," ",1)
		i Date'="" s Date=..GetDigitalDateFormat(Date) 
		s TmpInfo=""
		s TmpInfo=$p(Info," ",2)
		i TmpInfo'="" d
		.s Stime=$p(TmpInfo,"-",1)
		.i Stime'="" s Stime=$zth(Stime,"1")
		.s EndTime=$p(TmpInfo,"-",2)
		.i EndTime'="" s EndTime=$zth(EndTime,"1")
		.s Param=Date_"^"_Stime_"^"_EndTime
		
	}
	
	q Param
}

/// w ##class(web.DHCRisCommFunctionEx).GetWardbyItemID("3","111")
ClassMethod GetWardbyItemID(InOrderRowid, InItemsub) As %String
{
	 s admLocDR=""
	 s GetWardRowid=""
	 q:(InOrderRowid="") GetWardRowid
	 q:(InItemsub="") GetWardRowid
     s admLocDR=$p($g(^OEORD(InOrderRowid,"I",InItemsub,9)),"^",2)
     i admLocDR'="" d
     .s GetWardRowid=0
     .s GetWardRowid=$o(^PAWARD(0,"WARD_LocationDR",admLocDR,GetWardRowid))
     q GetWardRowid
}

/// w ##class(web.DHCRisCommFunctionEx).GetLocbyRowid("83")
ClassMethod GetLocbyRowid(LocDR) As %String
{
	s Loc=""
	if LocDR'="" d
	.s Loc=$p($g(^CTLOC(LocDR)),"^",2)
	q Loc
}

/// 功能：根据医嘱的ROWID判断医嘱+部位是否登记
/// 输入参数：oeorditem.rowid
/// 返回：医嘱登记信息
/// w ##class(web.DHCRisCommFunctionEx).GetRegInfoNew("2||95")
ClassMethod GetRegInfoNew(oeorditemdr As %String) As %String
{
	s ^TMPRIS=oeorditemdr
	n (oeorditemdr)
	s (BodyInfo,Num,Info)=""
    if (oeorditemdr'="")
    {
	  s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))  ; 登记的表中获得检查号
	 
	  i (regrowid'="")
	  {
		  i $d(^DHCPACRegInfo(regrowid)) d 
		  .s BodyInfo="",Num=0
		  .s ChildSub=0  f  s ChildSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub)) q:ChildSub=""  d
		  ..s BodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub),"^",1)
		  ..i BodyDr'="" d
		  ...s Num=Num+1
		  ...;s BodyDesc=$p(^MRC("BODP",BodyDr),"^",2)
		  ...s PartDesc=$p(^DHCAPPART(BodyDr),"^",2)
		  ...s BodyInfo=BodyDr_":"_PartDesc
	  }
    }
	s Info=BodyInfo
	q Info
}

/// wf 20160729 取医嘱信息，传入(医嘱+部位) 
/// 入参(医嘱 $ 部位 , 部位 @ 医嘱 ....)
/// w ##class(web.DHCRisCommFunctionEx).getOrderItemInfo("")
ClassMethod getOrderItemInfo(orderBodyList) As %String
{
	s ^TempDHCRis("getOrderItemInfo")=orderBodyList
	s ret=""
	q:(orderBodyList="") ret
	
	s (papatmasmdr,paAmdDr,RegNo,Name,PinYin,strDOB,SexDesc,patienttype,IPNO,Telphone,ungent)=""
	//s patmasmdr=$p(^PAADM(paadmdr),"^",1)
	s orderBodyListDesc=""
	s orderLen=$l(orderBodyList,"@")
	for len=1:1:orderLen
	{
		s orderBodyDesc=""
		s orderBody=$p(orderBodyList,"@",len)
		if (orderBody'="")
		{
			;w !,orderBody
			s Oeorditemdr=$p(orderBody,"$",1)
			;w !,Oeorditemdr
			if (Oeorditemdr'="")
			{
				s paAmdDr=$p(^OEORD($p(Oeorditemdr,"||",1)),"^",1)
				if (ungent="")
				{
					s ungent=$p($g(^OEORD($p(Oeorditemdr,"||",1),"I",$p(Oeorditemdr,"||",2),11)),"^",55)
					if (ungent="")
					{
						s ungent=##class(web.DHCAPPInterface).GetEmgFlag(Oeorditemdr)
					}
				}
				s papatmasmdr=$p(^PAADM(paAmdDr),"^",1)
				s arcimid=$p($g(^OEORD($p(Oeorditemdr,"||",1),"I",$p(Oeorditemdr,"||",2),1)),"^",2)
				s arcitmdesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
				s orderBodyDesc=arcitmdesc
				s bodyAllDesc=""
				s bodyList=$p(orderBody,"$",2)
				s lenofBody=$l(bodyList,",")
				for numofBody=1:1:lenofBody
				{
					s bodyDr=$p(bodyList,",",numofBody)
					if (bodyDr'="")
					{
						s PartDesc=$p(^DHCAPPART(bodyDr),"^",2)
						if (bodyAllDesc="")
						{
							s bodyAllDesc=PartDesc
						}
						else
						{
							s bodyAllDesc=bodyAllDesc_","_PartDesc
						}
					}
				}
				if (bodyAllDesc'="")
				{
					s orderBodyDesc=orderBodyDesc_"("_bodyAllDesc_")"
				}
			}
			
		}
		;w !,orderBodyDesc,!
		if (orderBodyDesc'="")
		{
			if (orderBodyListDesc="")
			{
				s orderBodyListDesc=orderBodyDesc
			}
			else
			{
				s orderBodyListDesc=orderBodyListDesc_"; "_orderBodyDesc
			}
		}
		;w !,orderBodyListDesc
	}
	
	if (papatmasmdr'="")
	{
		s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
    	s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
       	s PinYin=..HZtoPin(Name)
       	s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
       	i DOB="" d
 	 	.s strDOB=""
 	 	.s strAge=""
 	  	e  d
        .s strDOB=##class(websys.Conversions).DateLogicalToHtml(DOB)
        .;s strToday=$ZD(+$h,3)
        .s strAge=##class(web.DHCBillInterface).GetPapmiAge(papatmasmdr,paAmdDr) //##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
       	s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
       	i SexDr'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)
       	s patienttype=$p(^PAADM(paAmdDr),"^",2) ;病人类型
       	s IPNO=##class(web.DHCRisCommFunctionEx).GetIPNO(papatmasmdr)   //获得住院号
		s Telphone=$p($g(^PAPER(papatmasmdr,"PER",1)),"^",11) 
		s mradmdr=$p(^PAADM(paAmdDr),"^",61)
       	i $g(mradmdr)'="" d
       	.s Height=$p(^MR(mradmdr,"PRO",1),"^",20)
      	.s Weight=$p(^MR(mradmdr,"PRO",1),"^",27)
		
	}
 	s ret=RegNo_"^"_Name_"^"_PinYin_"^"_strDOB_"^"_SexDesc_"^"_patienttype_"^"_IPNO_"^"_Telphone_"^"_orderBodyListDesc_"^"_$g(ungent)_"^"_$g(Weight)
	q ret
}

/// wf 20160730 传入医嘱 返回医嘱信息(拼接体位、后处理和部位)
///  w ##Class(web.DHCRisCommFunctionEx).GetOrderDesc("2||95")
ClassMethod GetOrderDesc(orditem As %String) As %String
{
	s ^TempDHCRis("GetOrderDesc")=orditem
	n (orditem)
	s arReqID=$o(^DHCAPREP(0,"OrdItem",orditem,""))
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",orditem,arReqID,""))
	Q:CH="" ""
	Q:'$d(^DHCAPREP(arReqID,"AR",CH)) ""
	s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)        ///医嘱项目ID
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) ///医嘱项代码
	s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) ///医嘱项名称
	
	s PosiDesc=""
	s PosiID=$p(^DHCAPREP(arReqID,"AR",CH),"^",2)     	   ///体位ID
	s:PosiID'="" PosiDesc=$p(^DHCAPPOS(PosiID),"^",2)	   ///体位
	
	s PartList=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=+$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1) ///部位ID
	.Q:PartID=0
	.s PartDesc=$p($g(^DHCAPPART(PartID)),"^",2) 				 ///部位
	.i PartList="" s PartList=PartDesc
	.E  s PartList=PartList_","_PartDesc
	
	
	s DispMList=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"DI",Sub)) Q:Sub=""  D
	.s DispMID=$p(^DHCAPREP(arReqID,"AR",CH,"DI",Sub),"^",1) ///后处理ID
	.Q:DispMID=""
	.s DispMDesc=$p($g(^DHCAPDIM(DispMID)),"^",2) 				  ///后处理描述
	.i DispMList'="" s DispMList=DispMList_"!"_DispMID_":"_DispMDesc
	.E  s DispMList=DispMID_":"_DispMDesc
	
	;s ListData=arcimid_":"_arcitmdesc_"^"_PosiID_":"_PosiDesc_"^"_PartList_"^"_DispMList
	if (PartList'="")
	{
		s ret=arcitmdesc_"("_PartList_")"
	}
	else
	{
		s ret=arcitmdesc
	}
	q ret
}

/// 入参:医嘱rowid串@  (有可能含部位)
/// 返回值:服务组ID^服务组ID
/// 作者:wf 20160801
/// w ##class(web.DHCRisCommFunctionEx).GetSameServiceGroup("1635||13@1635||14")
ClassMethod GetSameServiceGroup(orderItemList) As %String
{
	s ^DHCRisTemp("GetSameServiceGroup")=orderItemList
	/*s serviceGrouplist=""
	s serviceGroupOrderList=""
	
	s numOfOrder=0
	for lenOfList=1:1:$l(orderItemList,"@")
	{
		s orderItemRowid=$p(orderItemList,"@",lenOfList)
		if (orderItemRowid'="")
		{
			s numOfOrder=numOfOrder+1
			s arcimid=$p($g(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),1)),"^",2)
			s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
			i (BPRowid'="")
			{
			  s SubRowid="" f  s SubRowid=$o(^DHCRBCItemBookPropertySG("ServiceGroup",BPRowid,SubRowid)) q:(SubRowid="")  d
			  .s (Rowid,SerGroupDR,SerGroup)=""
			  .s Rowid=BPRowid_"||"_SubRowid
			  .s SerGroupDR=$p($g(^DHCRBCItemBookPropertySG("ServiceGroup",BPRowid,SubRowid)),"^",4)
			  .if ($d(serviceGroupOrderList(SerGroupDR))) d
			  ..s serviceGroupOrderList(SerGroupDR)=serviceGroupOrderList(SerGroupDR)_"^"_orderItemRowid
			  .e  d
			  ..s serviceGroupOrderList(SerGroupDR)=orderItemRowid
			}
		}
	}
	
	s serviceGroupDr=""  f  s serviceGroupDr=$o(serviceGroupOrderList(serviceGroupDr)) q:(serviceGroupDr="")  d
	.if ($l(serviceGroupOrderList(serviceGroupDr),"^")=numOfOrder) d
	..if serviceGrouplist="" d
	...s serviceGrouplist=serviceGroupDr
	..e  d
	...s serviceGrouplist=serviceGrouplist_"^"_serviceGroupDr
	k serviceGroupOrderList
	q serviceGrouplist
	*/
	
	s serviceGrouplist=""
	s serviceGroupOrderList=""
	s number=0
	for lenOfList=1:1:$l(orderItemList,"@")
	{
		
		s orderBodyList=$p(orderItemList,"@",lenOfList)
		if (orderBodyList'="")
		{
			
			s orderRowid=$p(orderBodyList,"$",1)
			s arcimid=$p($g(^OEORD($p(orderRowid,"||",1),"I",$p(orderRowid,"||",2),1)),"^",2)
			s bodyList=$p(orderBodyList,"$",2)
			if (bodyList'="")   //有部位
			{
				for lenOfBody=1:1:$l(bodyList,",")
				{
					s bodyRowid=$p(bodyList,",",lenOfBody)
					if (bodyRowid'="")
					{
						s number=number+1
						s serviceList=..GetServiceGroup(arcimid,bodyRowid)
						b //01
						s serviceGroupList=$p(serviceList,"^",1)
						for i=1:1:$l(serviceGroupList,",")
						{
							s SerGroupDR=$p(serviceGroupList,",",i)
							if (SerGroupDR'="")
							{
								if ($d(serviceGroupOrderList(SerGroupDR))) d
								.s serviceGroupOrderList(SerGroupDR)=serviceGroupOrderList(SerGroupDR)_"^"_number
								e  d
								.s serviceGroupOrderList(SerGroupDR)=number
							}
						}
					}
				}
			}
			else    //没有部位
			{
				s number=number+1
				s serviceList=..GetServiceGroup(arcimid,"")
				s serviceGroupList=$p(serviceList,"^",1)
				for i=1:1:$l(serviceGroupList,",")
				{
					s SerGroupDR=$p(serviceGroupList,",",i)
					if (SerGroupDR'="")
					{
						if ($d(serviceGroupOrderList(SerGroupDR))) d
						.s serviceGroupOrderList(SerGroupDR)=serviceGroupOrderList(SerGroupDR)_"^"_number
						e  d
						.s serviceGroupOrderList(SerGroupDR)=number
					}
				}
					
					
			}	
		}
	}
	
	s serviceGroupDr=""  f  s serviceGroupDr=$o(serviceGroupOrderList(serviceGroupDr)) q:(serviceGroupDr="")  d
	.if ($l(serviceGroupOrderList(serviceGroupDr),"^")=number) d
	..if serviceGrouplist="" d
	...s serviceGrouplist=serviceGroupDr
	..e  d
	...s serviceGrouplist=serviceGrouplist_"^"_serviceGroupDr
	
	//找不到服务组，就找增强服务组
	/*
	if (serviceGrouplist="")
	{
		s serviceGroupDr=""  f  s serviceGroupDr=$o(serviceGroupOrderList(serviceGroupDr)) q:(serviceGroupDr="")  d
		.s serviceGroupDesc=$p($g(^RBC("SG",serviceGroupDr)),"^",2)
		.i serviceGroupDesc["增强" d
		..if serviceGrouplist="" d
		...s serviceGrouplist=serviceGroupDr
		..e  d
		...s serviceGrouplist=serviceGrouplist_"^"_serviceGroupDr
	}
	*/
	k serviceGroupOrderList
	q serviceGrouplist
}

/// Descript: 根据医嘱项获取部位树
ClassMethod GetPartDispChildenByArc(itmmastid As %String) As %String
{
	n (itmmastid)
    ///  是否存在孩子节点
    s ALDID=$o(^DHCAPARCDI(0,"Arc",itmmastid,""))
	Q:ALDID="" ""
	s count=0
	///  有孩子节点的初始化时收缩
	/// w ","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign()
	w ",""children"":["
	s ALDID=0
	f  s ALDID=$o(^DHCAPARCDI(0,"Arc",itmmastid,ALDID)) Q:ALDID=""  D
	.s DispMID=$p(^DHCAPARCDI(ALDID),"^",2)
	.Q:'$d(^DHCAPDIM(DispMID))
	.;Q:$p(^DHCAPDIM(DispMID),"^",3)'="Y"
	.s DispMCode=$p(^DHCAPDIM(DispMID),"^",1)  ///后处理方法代码
	.s DispMDesc=$p(^DHCAPDIM(DispMID),"^",2)  ///后处理方法描述
	.Q:$D(TreeLeafNote(DispMID))
	.s TreeLeafNote(DispMID)=DispMDesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(DispMID,DispMDesc)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(DispMID,DispMDesc)
	.w "}"
	w "]"
	Q ""
}

/// w ##class(web.DHCRisCommFunctionEx).GetPartTreeChildenByArc("11214||1")
/// Descript: 根据医嘱项获取部位树
ClassMethod GetPartTreeChildenByArc(itmmastid As %String) As %String
{
	n (itmmastid)
    ///  是否存在孩子节点
    s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,""))
	Q:TraID="" ""
	s count=0
	///  有孩子节点的初始化时收缩
	/// w ","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign()
	w ",""children"":["
	s TraID=""
	f  s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID)) q:TraID=""  d
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) q:CH=""  d
	..s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	..Q:'$D(^DHCAPPART(PartID))
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2)   /// 部位
	..Q:$D(TreeLeafNote(PartID))
	..s TreeLeafNote(PartID)=PartDesc
	..
	..s count = count+1
	..i count=1 d
	...w ##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(PartID,PartDesc)
	..e  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(PartID,PartDesc)
	..w "}"
	w "]"
	Q ""
}

/// wf 20160729 取医嘱项目描述，传入(医嘱+部位) 
/// 入参(医嘱 $ 部位 , 部位 @ 医嘱 ....)
/// w ##class(web.DHCRisCommFunctionEx).getOrderItemDesc("378||9$@384||11$@673||5$")
ClassMethod getOrderItemDesc(orderBodyList) As %String
{
	s orderBodyListDesc=""
	s orderLen=$l(orderBodyList,"@")
	for len=1:1:orderLen
	{
		s orderBodyDesc=""
		s orderBody=$p(orderBodyList,"@",len)
		if (orderBody'="")
		{
			;w !,orderBody
			s Oeorditemdr=$p(orderBody,"$",1)
			;w !,Oeorditemdr
			if (Oeorditemdr'="")
			{
				;s paAmdDr=$p(^OEORD($p(Oeorditemdr,"||",1)),"^",1)
				;s papatmasmdr=$p(^PAADM(paAmdDr),"^",1)
				s arcimid=$p($g(^OEORD($p(Oeorditemdr,"||",1),"I",$p(Oeorditemdr,"||",2),1)),"^",2)
				s arcitmdesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
				s orderBodyDesc=arcitmdesc
				s bodyAllDesc=""
				s bodyList=$p(orderBody,"$",2)
				s lenofBody=$l(bodyList,",")
				for numofBody=1:1:lenofBody
				{
					s bodyDr=$p(bodyList,",",numofBody)
					if (bodyDr'="")
					{
						s PartDesc=$p($g(^DHCAPPART(bodyDr)),"^",2)
						if (bodyAllDesc="")
						{
							s bodyAllDesc=PartDesc
						}
						else
						{
							s bodyAllDesc=bodyAllDesc_","_PartDesc
						}
					}
				}
				if (bodyAllDesc'="")
				{
					s orderBodyDesc=orderBodyDesc_"("_bodyAllDesc_")"
				}
			}
			
		}
		;w !,orderBodyDesc,!
		if (orderBodyDesc'="")
		{
			if (orderBodyListDesc="")
			{
				s orderBodyListDesc=orderBodyDesc
			}
			else
			{
				s orderBodyListDesc=orderBodyListDesc_"; "_orderBodyDesc
			}
		}
		;w !,orderBodyListDesc
	}
	
	q orderBodyListDesc
}

/// w ##class(web.DHCRisCommFunctionEx).GetServiceGroup("4488||1","2405")
ClassMethod GetBookParam(arcimid, bodyRowid As %String = "") As %String
{
	s ^DHCRisTempwf("GetBookParam")=arcimid_"^"_bodyRowid
	s BPRowid="",appointMethodID="",appointMethodDesc=""
	if (bodyRowid'="")
	{
		s bookparamRowid=""
		s bookparamRowid=$o(^User.DHCRBCBookParamI("IndexItemBody",arcimid,bodyRowid,0))
		if (bookparamRowid'="")
		{
			s appointMethodID=$lg(^User.DHCRBCBookParamD(bookparamRowid),5)
		}
		
	}
	
	if (appointMethodID="")
	{
		s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
		i (BPRowid'="")
		{
		   s appointMethodID=$p($g(^DHCRBCItemBookProperty(BPRowid)),"^",2)
		}
	
		
	}
	
	if (appointMethodID'="")
	{
		s appointMethodDesc=$p($g(^DHCRBCAppointMethod(appointMethodID)),"^",2)
	}
	
	s info=appointMethodID_"^"_appointMethodDesc
	q info
}

/// /;第三方回传报告状态
/// w ##class(web.DHCRisCommFunctionEx).GetResultFlag("8","1")
ClassMethod GetResultFlag(OrderRowid, itemsub As %String) As %String
{
	s temp("Flag")=OrderRowid_""_itemsub
	s ResultFlag=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",5)
	;w !,"ResultFlag="_ResultFlag
    i ResultFlag'="" s RERowid=$o(^OEC("RESST",0,"Code",$$ALPHAUP^SSUTIL4(ResultFlag),""))
    i RERowid'="" s Complete=$p($g(^OEC("RESST",RERowid)),"^",2)
    Q $g(Complete)
}

//  w ##class(web.DHCRisCommFunctionEx).getDivideFlag("")

ClassMethod getDivideFlag(orderItemRowid As %String) As %String
{
	Set $ZT="ERRORDivideFlag"	
	s ^DHCRisTemp("getDivideFlag")=orderItemRowid
	s ret="Y"
	q:(orderItemRowid="") ret
	s arcimRowid=$p(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),1),"^",2)
	q:(arcimRowid="") ret
	s ret=##Class(web.DHCAPPExaRepCom).GetItemTarFlag(arcimRowid) 
	q ret
	
ERRORDivideFlag
	q "Y"
}

// 获取界面显示日期

// 入参为日期和当天的差值

// w ##class(web.DHCRisCommFunctionEx).getDateHtml("")

ClassMethod getDateHtml(num) As %String
{
	s num=+num
	q ##class(websys.Conversions).DateLogicalToHtml($h+num)
}

/// 函数名称：ChangeDateToHtml
/// 功能：	 转换cache日期格式显示格式
/// 输入参数： cache日期
/// 返回：  
/// 作者：wf
/// 日期：2020-2-25
/// w ##class(web.DHCRisCommFunctionEx).ChangeDateToHtml()
ClassMethod ChangeDateToHtml(dateDig) As %String
{
	s $zt="dateChangeError"
	
	s retDateHtml=""
	if ( ##class(websys.Conversions).IsValidMethodName("websys.Conversions","DateLogicalToHtml"))
	{
		s retDateHtml=##class(websys.Conversions).DateLogicalToHtml(dateDig)
	}
	else
	{
		s retDateHtml=$zd(dateDig,3)
	}
	
	q retDateHtml
dateChangeError

	q ""
}

}

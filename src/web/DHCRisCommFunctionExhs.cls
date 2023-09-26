Import SQLUser

/// action patient data from TrakCare
/// 
/// 类 web.DHCRisCommFunctionEx
/// 功能说明：封装病人信息的业务数据的类，包括病人的基本信息，医嘱信息等等
/// 作者：龚平
/// 日期：2007-03-02
/// websys.Abstract
Class web.DHCRisCommFunctionExhs Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 254;

/// 函数名称：GetPaadmInfo
/// 功能：根据PAADM.ROWID 获得病人的基本信息
/// 输入参数：Pa_adm.rowid
/// 返回：病人的基本信息
/// 作者：龚平
/// 日期：2007-03-02
/// d ##class(web.DHCRisCommFunctionEx).GetPaadmInfo(25082)
ClassMethod GetPaadmInfo(paadmdr As %String) As %String
{
     n (paadmdr)
     s (RegNo,Name,strDOB,strAge,SexDesc,patienttype,typedesc,LocName,IPNO,wardname,bedname,Locdr,SexDr,WardDr)=""
     s (roomdesc,feetype,Docdr,DocName,Telphone,Height,Weight,Adress,SafetynetCardNo,papatmasmdr,WorkUnit)=""
     s (ID1,OccupationDR,OccupationDesc,beddr,AdmDate,AdmTime,OPNO,MedicareNo,InsuraceNo,CardNo,feetypeCode)=""
     if (paadmdr'="")
     {
       i $d(^PAADM(paadmdr))
       {
       s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
       ;s ^DHCRISTEMP("papatmasmdr")=papatmasmdr_"^"_paadmdr        
       s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
       ;q:RegNo=""  
       s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
       s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
       s CardNo=""
       i papatmasmdr'="" s CardNo=..GetCardNobyPatDR(papatmasmdr)
       i $g(^PAPER(papatmasmdr,"PAT",3))'="" d
     	 .s SafetynetCardNo=$p(^PAPER(papatmasmdr,"PAT",3),"^",4)
       i DOB="" d
 	 	.s strDOB=""
 	 	.s strAge=""
 	   e  d
        .s strDOB=$ZD(DOB,3)
        .s strToday=$ZD(+$h,3)
        .s strAge=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
        .s year=$p(strDOB,"-",1)
        .s Month=$p(strDOB,"-",2)
        .s day=$p(strDOB,"-",3)
        .s strDOB=day_"/"_Month_"/"_year
       s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
       i SexDr'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)
       s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
       s typedesc=##class(web.DHCRisCommFunction).GetTypeDesc(patienttype)
  	   s Locdr=$p(^PAADM(paadmdr),"^",4)
  	   s AdmDate=$p(^PAADM(paadmdr),"^",6)
  	   s AdmDate=$zd(AdmDate,3)
  	   s AdmTime=$p(^PAADM(paadmdr),"^",7)
  	   s AdmTime=$zt(AdmTime,1)
       i $g(Locdr)'="" d
       .s LocName=$p(^CTLOC(Locdr),"^",2)
       .i $f(LocName,"-")>0 d
       ..s LocName=$p(LocName,"-",2)
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
       s Docdr=$p(^PAADM(paadmdr),"^",9) ;;benna added
       i $g(Docdr)'="" s DocName=$p($g(^CTPCP(Docdr,1)),"^",2)
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
       s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadmdr,patienttype,.ErrMsg)
       s InsuraceNo=$p($g(^PAPER(papatmasmdr,"ALL")),"^",19)   //医疗保险号
       }
    }
    s Info=RegNo_"^"_Name_"^"_strDOB_"^"_strAge_"^"_$g(SexDesc)_"^"_patienttype_"^"_typedesc_"^"_$g(LocName)_"^"_IPNO_"^"_wardname_"^"_bedname_"^"_$g(Locdr)_"^"_SexDr_"^"_WardDr_"^"_roomdesc_"^"_feetype_"^"_Docdr_"^"_DocName_"^"_Telphone_"^"_Height_"^"_Weight_"^"_Adress_"^"_SafetynetCardNo_"^"_papatmasmdr_"^"_WorkUnit_"^"_ID1_"^"_OccupationDR_"^"_OccupationDesc_"^"_beddr_"^"_AdmDate_"^"_AdmTime_"^"_OPNO_"^"_$g(MedicareNo)_"^"_$g(InsuraceNo)_"^"_CardNo_"^"_feetypeCode
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
	s admIDCDesc="",IDCDesc="",CodeDesc="",Index=0 
    s mradmdr=$p(^PAADM(paadmdr),"^",61)
    s diachildsub=0  f  s diachildsub=$o(^MR(mradmdr,"DIA",diachildsub)) q:(diachildsub="")  d
    .s CodeDesc="",mrdesc=""     
    .s Index=Index+1
    .s IDCCodeDR=$p(^MR(mradmdr,"DIA",diachildsub),"^",1)
    .i $g(IDCCodeDR)'=""  d
    ..s CodeDesc=$p($g(^MRC("ID",IDCCodeDR)),"^",2)
    .s ICDCommSub=0
	.s ICDCommSub=$o(^MR(mradmdr,"DIA",diachildsub,"DES",ICDCommSub))
	.if ICDCommSub'="" s mrdesc=$p(^MR(mradmdr,"DIA",diachildsub,"DES",ICDCommSub),"^",1)
	.s IDCDesc=Index_":"_CodeDesc_" "_mrdesc
    .s admIDCDesc=admIDCDesc_" "_IDCDesc
    q admIDCDesc
}

/// 函数名称：GetOeorditminfo
/// 功能：根据医嘱的ROWID 获得医嘱基本信息
/// 输入参数：oeorditem.parref,oeorditem.childsub
/// 返回：医嘱的信息
/// 作者：龚平
/// 日期：2007-03-02
/// s Info=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid, itemsub)
ClassMethod GetOeorditminfo(OrderRowid, itemsub) As %String
{
    s requestdoc="",ItemStatusCode="",SGroupDesc=""
    s oeorditemdr=OrderRowid_"||"_itemsub 
    s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    s Date1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  ;医嘱日期 OEORI_Date
	s strDate=$zd(Date1,3)
	;s Time1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",10) ;医嘱的开始时间 ,modified by benna 20070108
	s Time1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",17) ;医嘱的开始时间
	s strTime=$zt(Time1,1)
	s RecLocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
	if RecLocdr'="" d
	.s RecLocDesc=$p(^CTLOC(RecLocdr),"^",2)
	.i $f(RecLocDesc,"-")>0 d
	..s RecLocDesc=$p(RecLocDesc,"-",2)
	s ssusrdr=$p($g(^OEORD(OrderRowid,"I",itemsub,7)),"^",1) ;下医嘱医生
	if ssusrdr'="" s requestdoc=$p(^SSU("SSUSR",ssusrdr),"^",2)         ; request doctor
	s strAccessionNum=$p($g(^OEORD(OrderRowid,"I",itemsub,8)),"^",19) 
    s ServerGroupDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),8),"^",7)
    i ServerGroupDR'="" s SGroupDesc=$p($g(^RBC("SG",ServerGroupDR)),"^",2)
    s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
	s OrdCatDr=$p(^ARC("IC",ItmCatDR),"^",8)
	s subCatDesc=$p(^ARC("IC",ItmCatDR),"^",2) ; 医嘱子类
	s CatDesc=$p(^OEC("ORCAT",OrdCatDr),"^",2) ; 医嘱大类
	s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	s ifbed=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",16)
	
	;安贞，哈医大，廊坊，友谊门诊这些medtrak计费的,price=$$getprice1^CHOPOrderEntry(arcim,today)
	;s priceinfo=GetOrderPrice^DHCPRICE
	;s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcimid, SttDate, "", "", "", "")
	;s priceinfo="19.8"_"^"
	;s price=$p(priceinfo,"^",1)
	;s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
	;s TotalPrice=price*Num
	s price="",Num="",TotalPrice=""
    s DHCRisSystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
    s TotalPrice=""
    if (DHCRisVersion="SG_YB")!(DHCRisVersion="BJ_JST")!(DHCRisVersion="DT_SY")!(DHCRisVersion="NB_MZ")!(DHCRisVersion="AH_SL")!(DHCRisVersion="DHCC")!(DHCRisVersion="BJ_ZYY")  d
	.s SttDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	.s OEPrice=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	.s paadmdr=$p(^OEORD(OrderRowid),"^",1)  
	.s instypedr=$p(^PAADM(paadmdr,1),"^",7) 
	.;zn "websource"
	.s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", instypedr, arcimid, SttDate, "", "", "", OEPrice)
	.;zn "RIS"
	.s price=$p(priceinfo,"^",1)
	.s TotalPrice=price*Num
	.i TotalPrice="" s TotalPrice=0
	.s TotalPrice=TotalPrice_"元"
	s billed=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",5)
	s ResultFlag=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",5)   ;医嘱结果状态
	s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
	s retinfo=strOrderName_"^"_strDate_"^"_strTime_"^"_requestdoc_"^"_strAccessionNum_"^"_SGroupDesc_"^"_subCatDesc_"^"_CatDesc_"^"_ifbed_"^"_price_"^"_Num_"^"_TotalPrice_"^"_billed_"^"_$g(ItemStatusCode)_"^"_Date1_"^"_Time1_"^"_$g(ItemStatusCode)_"^"_$g(ServerMaterial)_"^"_RecLocdr_"^"_$g(ResultFlag)_"^"_RecLocDesc
	q retinfo
}

/// 函数名称：GetRegInfo
/// 功能：根据医嘱的ROWID 获得登记信息
/// 输入参数：oeorditem.rowid
/// 返回：医嘱登记信息
/// 作者：龚平
/// 日期：2007-03-02
ClassMethod GetRegInfo(oeorditemdr As %String) As %String
{
	s ^oe=oeorditemdr
	s MainDoc="",AssDoc="",EQGroupDesc="",EQGroupDr="",No=""
	s regrowid="",StudyNo="",strRegDate="",strRegTime="",Index="",EQDesc="",RoomDesc="",RoomDr="",EQDescdr=""
	s ssuserdr="",MainDocDr="",assDocDr="",BodyInfo="",Num="",ReportInfo=""
	s Info=StudyNo_"^"_strRegDate_"^"_strRegTime_"^"_Index_"^"_EQDesc_"^"_MainDoc_"^"_AssDoc_"^"_RoomDesc_"^"_RoomDr_"^"_EQDescdr_"^"_EQGroupDesc_"^"_EQGroupDr_"^"_No_"^"_ssuserdr_"^"_MainDocDr_"^"_assDocDr_"^"_BodyInfo_"^"_Num
	q:oeorditemdr="" Info
	s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))  ; 登记的表中获得检查号
	i regrowid '="" d 
	.s ^DHCPACRegInfo(regrowid)=$g(^DHCPACRegInfo(regrowid))
	.s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
	.s RegDate=$p(^DHCPACRegInfo(regrowid),"^",8)
	.s strRegDate=$zd(RegDate,3)
	.s RegTime=$p(^DHCPACRegInfo(regrowid),"^",9)
	.s strRegTime=$zt(RegTime,1)
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
	.; 取登记部位的信息
	.s BodyInfo="",Num=0
	.s ChildSub=0  f  s ChildSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub)) q:ChildSub=""  d
	..s BodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub),"^",1) 
	..i BodyDr'="" d
	...s Num=Num+1
	...s BodyDesc=$p(^MRC("BODP",BodyDr),"^",2)
	...s BodyInfo=BodyInfo_BodyDr_":"_BodyDesc_"~"
	s Info=StudyNo_"^"_strRegDate_"^"_strRegTime_"^"_Index_"^"_EQDesc_"^"_MainDoc_"^"_AssDoc_"^"_RoomDesc_"^"_RoomDr_"^"_EQDescdr_"^"_EQGroupDesc_"^"_EQGroupDr_"^"_No_"^"_ssuserdr_"^"_MainDocDr_"^"_assDocDr_"^"_BodyInfo_"^"_Num_"^"_$g(ReportInfo)
	q Info
}

/// 函数名称：GetRegInfobyrowid
/// 功能：根据DHCRB_RegInfo.ROWID 获得登记信息
/// 输入参数：DHCRB_RegInfo.ROWID
/// 返回：医嘱登记信息
/// 作者：龚平
/// 日期：2007-03-02
ClassMethod GetRegInfobyrowid(regrowid As %String) As %String
{
	s StudyNo="",strRegDate="",strRegTime="",Index="",EQDesc="",oeorditemdr="",RoomDesc="",EQGroupDesc="",EQGroupDr="",No=""
	s BodyDesc=""
	i regrowid '="" d 
	.s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
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
	.s BodyDesc=""
	.s ChildSub=0  f  s ChildSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub)) q:ChildSub=""  d
	..s BodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,ChildSub),"^",1) 
	..i BodyDr'="" d
	...s BodyDesc=$p(^MRC("BODP",BodyDr),"^",2)
   	s Info=StudyNo_"^"_strRegDate_"^"_strRegTime_"^"_Index_"^"_EQDesc_"^"_$g(MainDoc)_"^"_$g(AssDoc)_"^"_oeorditemdr_"^"_paadmdr_"^"_RoomDesc_"^"_EQDescdr_"^"_RoomDr_"^"_EQGroupDesc_"^"_EQGroupDr_"^"_No_"^"_BodyDesc_"^"_RegDate
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
/// 
ClassMethod UpdataOrdInfo(OrditmRowid, Status)
{
   s statdr=$o(^OEC("OSTAT",0,"Code",Status,0))
   &sql(update OE_OrdItem set OEORI_ItemStat_DR=:statdr where OEORI_RowId=:OrditmRowid)
   s CurrDate=$p($h,",",1)
   s CurrTime=$p($h,",",2)
   &sql(insert into OE_OrdStatus (ST_ParRef,ST_Date,ST_Time,ST_Status_DR)values (:OrditmRowid,:CurrDate,:CurrTime,:statdr))
  q SQLCODE
}

// 函数 CreateNewPatientID

// 功能：生成一个新的登记号，当前病人的最大号加1

// uid:传入1 

//  作者龚平

ClassMethod CreateNewPatientID(uid As %Library.String = "")
{
  s mn=""	
  Set AdmDate=+$H,AdmTime=$P($H,",",2)		
  &sql(insert into SQLUSER.PA_Person
	 (paper_ageday,paper_agemth,paper_ageyr,
	  paper_langprim_dr,paper_dob,paper_name,
	  paper_sex_dr,paper_age,paper_userupdate,paper_soundex1,
	  paper_updatedate,paper_updatetime,paper_estdob,paper_dateadded,
	  paper_useradded_dr,paper_incompleteregistration)
	  values("","","","2","60124","未用","3","|||||||||||0|0|0","2","未用00",
	  :AdmDate,:AdmTime,"N",:AdmDate,:uid,"N")) 
  i SQLCODE=0 d
  .s mid=^PAPER(0)   //人的最大id
  .i $d(^PAPER(0,"CNT","I")) d
  ..s mno=^PAPER(0,"CNT","I") //最大登记号
  .e  d
  ..s mno=0
  .s ^PAPER(0,"CNT","I")=mno+1
  .s mn=mno+1
  .s count=8-$l(mno+1)
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

// 

Query QueryByPatientName(InName As %String, RocLocID As %String) As %Query(ROWSPEC = "RegNo:%String,Name:%String,DOB:%String,SexDesc:%String,IPNO:%String,Telphone:%String,Adress:%String,SexDr:%String,No:%String,Age:%String,WorkUnit:%String,ID1:%String,OccupationDR:%String,OccupationDesc:%String,OPNO:%String")
{
}

// 韶关，大同的住院号 SafetynetCardNo=$p(^PAPER(NoRowid,"PAT",3),"^",4)

// JST，TRAKCARE 

// 

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
    ..s WorkUnit=$p(^PAPER(NoRowid,"PER",4),"^",18)
    ..; pa_person set paper_id=:ID1,paper_telh=:TelNo,paper_stnameline1=:Adress,PAPER_Occupation_DR=:OccupationDR 
    ..s ID1=$p(^PAPER(NoRowid,"ALL"),"^",9)
    ..s OPNO=$p(^PAPER(NoRowid,"PER",4),"^",4)
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
	..s OPNO=$p(^PAPER(NoRowid,"PER",4),"^",4) 
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

/* 查询：QueryPadmType
/  功能：查询病人类型
   传入参数：空
   返回结果:病人类型，ROWID 
*/
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

// 查询病区信息

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

// 获得医院的住院号

// s IPNO=##class(web.DHCRisCommFunctionEx).GetIPNO(rowid)

ClassMethod GetIPNO(NoRowid) As %String
{
	s IPNO=""
	s DHCRisSystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    i (DHCRisVersion="DT_SY") d  
    .s IPNO=$p($g(^PAPER(NoRowid,"PAT",3)),"^",4) //病案号
    else  d 
    .s IPNO=""
    q IPNO
}

// 韶关，大同的住院号 SafetynetCardNo=$p(^PAPER(NoRowid,"PAT",3),"^",4)

// JST，TRAKCARE 

// 

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
    
	s RegNo=$ZCONVERT(RegNo,"U")
	s NoRowid=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	if NoRowid=""  Set qHandle=$lb(0,repid,0)
	q:NoRowid="" $$$OK

	s Name1=$p(^PAPER(NoRowid,"ALL"),"^",1)
	s SexDr=$p(^PAPER(NoRowid,"ALL"),"^",7)
	s SexDesc=$p(^CT("SEX",SexDr),"^",2)
    s WorkUnit=$p(^PAPER(NoRowid,"PER",4),"^",18)
  
	s DOB=$p(^PAPER(NoRowid,"ALL"),"^",6)
    i DOB="" d
 	.s strDOB=""
 	.s Age=""
 	e  d
    .s strDOB=$ZD(DOB,3)
    .s strToday=$ZD(+$h,3)
    .s Age=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)

    s ID=$p(^PAPER(NoRowid,"ALL"),"^",9)
    s TelNo=$p(^PAPER(NoRowid,"PER",1),"^",11)
    s OccupationDR=$p($g(^PAPER(NoRowid,"PER",2)),"^",6)
    s Occupation=""
    i OccupationDR'="" s Occupation=$p(^CT("OCC",OccupationDR),"^",2) 
    s Adress=$g(^PAPER(NoRowid,"PER","ADD",1))
    
    s hasadm=0,paadmrowid="",patienttype="",typedesc="",wardname="",BedDesc="",AdmDate="",AdmTime="",OPNO="",No="",LocDr=""
	s paadmtype="" f  s paadmtype=$o(^PAPERdr(NoRowid,"ADM",paadmtype)) q:paadmtype=""  d
	.s paadmrowid=0 f  s paadmrowid=$o(^PAPERdr(NoRowid,"ADM",paadmtype,paadmrowid)) q:paadmrowid=""  d
	..;s (RegNo,DOB,SexDesc,IPNO,Telphone,Adress,SafetynetCardNo)=""
	..s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmrowid)
    ..s IPNO=$p(PatInfo,"^",9)
    ..s patienttype=$p(PatInfo,"^",6)
    ..s typedesc=$p(PatInfo,"^",7)
    ..s wardname=$p(PatInfo,"^",10)
    ..s wardDr=$p(PatInfo,"^",6)
    ..s BedDesc=$p(PatInfo,"^",11)
    ..s BedDr=$p(PatInfo,"^",29)
    ..s AdmDate=$p(PatInfo,"^",30)
    ..s AdmTime=$p(PatInfo,"^",31)
    ..s OPNO=$p(PatInfo,"^",32)
    ..s Noinfo=##class(web.DHCRisNewPatient).GetNo(RegNo,"",RocLocID)
	..s No=$p(Noinfo,"^",1)_$p(Noinfo,"^",2)
	..s LocDr=$p(PatInfo,"^",12)
	..s hasadm=1
  	..Do NOOutRowL4
   if hasadm=0 Do NOOutRowL4
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
NOOutRowL4
    set Data=$lb(RegNo,Name1,strDOB,SexDesc,IPNO,Telphone,Adress,SexDr,No,Age,WorkUnit,ID1,OccupationDR,OccupationDesc,patienttype,typedesc,wardname,wardDr,BedDesc,BedDr,AdmDate,AdmTime,paadmrowid,LocDr,OPNO)
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

}

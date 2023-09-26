Import SQLUser

/// 配液单跟踪
Class web.DHCSTPIVAORDGRP Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetOrdGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcItmCatExecute ]
{
	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		S AtEnd=1
 		S Row=""
 	}
 	Else {				
 		S Row=^CacheTemp(repid,ind)
 	}
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

ClassMethod GetOrdGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArcItmCatExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

ClassMethod GetOrdGrpExecute(ByRef qHandle As %Binary, displocrowid, tStartDate, tEndDate, tWardID, tBarCode As %String, tPatNo) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1	
	
	//S tBarCode=""
	S tPLocID=displocrowid
	Q:(tPLocID="")&(tBarCode="") $$$OK
	Q:(tStartDate="")&(tBarCode="") $$$OK
	Q:(tEndDate="")&(tBarCode="") $$$OK
	Q:(tWardID="")&(tBarCode="") $$$OK
	S PID=##class(web.DHCSTPIVAQUERY).NewPid()
 
	F date=tStartDate:1:tEndDate d
	.Q:tWardID=""
    .s WardLocDr=$p(^PAWARD(tWardID),"^",5)
    .Q:WardLocDr=""
    .S DspId=""
    .//F  s DspId=$O(^DHCOEDISQTY(0,"REC",tPLocID,date,"TC",WardLocDr,DspId)) q:DspId=""  d //zhouyg 20150624 改为如下
    .F  s DspId=$O(^DHCOEDISQTY(0,"REC",tPLocID,date,"TC",WardLocDr,0,DspId)) q:DspId=""  d
    ..s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
    ..s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针
    ..s ord=$p(OrdItmRowid,"||",1)
    ..s chl=$p(OrdItmRowid,"||",2)
	..S oeori=ord_"||"_chl
    ..Q:'$D(^OEORD(ord))
    ..S adm=$p(^OEORD(ord),"^",1)  
    ..Q:adm=""
    ..S admward=$p(^PAADM(adm),"^",70)  ;病人所在病房
    ..S amdtype=$p($g(^PAADM(adm)),"^",2)
    ..Q:amdtype'="I"  ;过滤非住院病人 
	..Q:admward'=tWardID
	..S pat=##class(web.DHCSTPIVA).GetPat(adm)
	..S ipno=$P(pat,"^",1)
	..Q:(tPatNo'="")&(tPatNo'=ipno)
	..S bedid=$P(^PAADM(adm),"^",73)
	..S bed=$P(^PAWARD(+bedid,"BED",$p(bedid,"||",2)),"^",1)
	..//Q:##Class(web.DHCSTPIVA).IfQuitAdmStatusD(adm)=1	//已经结算退出                           
    ..
    ..S moeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)	/// 主医嘱
    ../// 非执行医嘱
	..//Q:$O(^OEORD(ord,"I",chl,"X",0))=""
	../// 医嘱状态
	..//S oestate=##class(web.DHCSTPIVA).GetOeState(oeori)
	..//S oestate=$P(oestate,"^",1)
 	..//Q:(oestate'="V")&(oestate'="E")
 	../// 无配液标记
 	..//Q:##Class(web.DHCSTPIVA).IfQuitPIVA(oeori)=1 //zhouyg 20150624 注释
 	../// 优先级
	..S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
	..S pridr=$P(pri,"^",1)
	..Q:pridr=""
	..Q:$O(^PIVAO(0,"OECPR",tPLocID,pridr,""))=""  	/// 没有维护科室配液的医嘱优先级
 	../// 配伍审核
 	..S chstr=##class(web.DHCSTPIVA).GetPassResult(moeori)
 	..S PivaAuditFlag=$p(chstr,",",4)
	..S dodis=""
 	..S dspstatus=$p(^DHCOEDISQTY(DspId),"^",7)
 	..//Q:dspstatus'="TC"	/// 已经确认
	..S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
	..S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
	..S pog=$O(^PIVA(0,"OEGRP",mdodis,grpno,""))
	..Q:pog=""
	..S batno=$p(^PIVA(+pog),"^",3)
	..S index=date_"^"_bed_"^"_batno_"^"_pog
	..S ^TMP("PIVA",PID,"ORGGRPDATA",index)=""
	//
	s index=""
	f  s index=$o(^TMP("PIVA",PID,"ORGGRPDATA",index)) q:index=""  d
	.s date=$p(index,"^",1)
	.s batno=$p(index,"^",3)
	.s Pog=$p(index,"^",4)
	.S PogSub="0"
 	.F  S PogSub=$O(^PIVA(Pog,"I",PogSub)) Q:PogSub=""  D
 	..S Dsp=$P(^PIVA(Pog,"I",PogSub),"^",1)
 	..Q:Dsp=""
 	..S Oeori=$P($G(^DHCOEDISQTY(Dsp)),"^",1)
 	..S GrpNo=$p(^PIVA(Pog),"^",2)
    ..D OutputData
	..
    //按条码查找
    
	I (tBarCode'="")&(tWardID="")&(tPatNo="") D
	.//S MOeord=$P(tBarCode,"-",1)
	.//S MOeSub=$P(tBarCode,"-",2)
	.//S GrpNo=$P(tBarCode,"-",3)
	.//Q:(MOeord="")!(MOeSub="")!(GrpNo="")
	.//S MOeori=MOeord_"||"_MOeSub
	.S Mdodis=tBarCode
	.S MOeori=$P($G(^DHCOEDISQTY(Mdodis)),"^",1)
	.S GrpNo=$O(^PIVA(0,"OEGRP",Mdodis,""))
	.Q:GrpNo=""
	.S Pog=$O(^PIVA(0,"OEGRP",Mdodis,GrpNo,""))
	.Q:Pog=""
	.S batno=$p(^PIVA(Pog),"^",3)
	.S grpno=GrpNo
	.S MOeord=$P(MOeori,"||",1)
	.S MOeSub=$P(MOeori,"||",2)
	.S moeori=MOeord_"||"_MOeSub
	.S date=$p(^OEORD(MOeord,"I",MOeSub,1),"^",9)
	.S PogSub="0"
 	.F  S PogSub=$O(^PIVA(Pog,"I",PogSub)) Q:PogSub=""  D
 	..S Dsp=$P(^PIVA(Pog,"I",PogSub),"^",1)
 	..Q:Dsp=""
 	..S Oeori=$P($G(^DHCOEDISQTY(Dsp)),"^",1)
 	..D OutputData
	..
	k ^TMP("PIVA",PID,"ORGGRPDATA")
 	Q $$$OK
	
OutputData
 	S Oeord=$P(Oeori,"||",1)
 	S OeSub=$P(Oeori,"||",2)
 	Q:(Oeord="")!(OeSub="")
 	S incitm=##class(web.DHCSTPIVA).GetIncItm(Oeori)
 	S inci=$P(incitm,"^",1)
 	S inciDesc=$P(incitm,"^",3)
 	S dosageml=##class(web.DHCSTPIVA).GetDosageML(Oeori)
 	S:dosageml="" dosageml=##class(web.DHCSTPIVA).GetDosage(Oeori)
 	S spec=##class(web.DHCSTCOMINC).GetSpec(inci)
    S qty=$P(^DHCOEDISQTY(Dsp),"^",11)
	S uomdr=$P(^DHCOEDISQTY(Dsp),"^",6)
	S uomdesc="*"
	I uomdr'="" S uomdesc=$P($G(^CT("UOM",uomdr)),"^",2)
	S sttdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date,"PIVA")
	S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(Dsp,GrpNo)
	D OutputRow
	Q

OutputRow
	S Data=$lb(Oeori,inciDesc,spec,dosageml,qty,uomdesc,batno,sttdate,grpno,mdodis)
 	S ^CacheTemp(repid,ind)=Data	
 	S ind=ind+1
 	Q
}

Query GetOrdGrp(displocrowid, tStartDate, tEndDate, tWardID, tBarCode, tPatNo) As %Query(ROWSPEC = "tbOeori:%String,tbItmName:%String,tbSpec:%String,tbDosQty:%String,tbQty:%String,tbUom:%String,tbBatno:%String,tbOrdSttDate:%String,tbGrpNo:%String,tbMoeori:%String")
{
}

/// Descript:根据条码查配液单信息
/// CreateDate:20101217
/// Creater:		zhouyg
ClassMethod GetRecordByBar(BarCode As %String) As %String
{
	N (BarCode)
	Q:BarCode="" ""
	Q:$l(BarCode,"-")'=3 ""
	S MOeord=$P(BarCode,"-",1)
	S MOeSub=$P(BarCode,"-",2)
	s MOeExe=$P(BarCode,"-",3)
	S GrpNo=$P(BarCode,"-",4)
	Q:(MOeord="")!(MOeSub="")!(MOeExe="")!(GrpNo="") ""
	S MOeori=MOeord_"||"_MOeSub
	s MOeore=MOeord_"||"_MOeSub_"||"_MOeExe
	s MDspId=$o(^DHCOEDISQTY(0,"OEORE",MOeore,""))
	s Pog=$o(^PIVA(0,"OEGRP",MDspId,GrpNo,""))
	Q:Pog="" ""
	Q:'$d(^PIVA(Pog)) ""
	S pdata=^PIVA(Pog)
	S phac=$P(pdata,"^",10)
	S prtno=""
	S ward=""
	I $D(^DHCPHAC(phac)) D
	.S prtno=$P(^DHCPHAC(phac),"^",14)	/// 打印单号
	.S ward=$P(^DHCPHAC(phac),"^",4)	/// 病区
	.I ward'="" S ward=$P($G(^PAWARD(ward)),"^",2)
	i $f(ward,"-") S ward=$p(ward,"-",2)
	S patstr=##class(web.DHCSTPIVA).GetOeInfoByMoeori(MOeori)	/// 病人信息 bed_"^"_paname_"^"_ipno_"^"_age_"^"_sex_"^"_Weight
	S bed=$p(patstr,"^",1)  //床号
	S patname=$p(patstr,"^",2) //姓名
	S patno=$p(patstr,"^",3)  //登记号
	S age=$p(patstr,"^",4)  //年龄
	S sex=$p(patstr,"^",5)  //性别
	S weight=$p(patstr,"^",6)  //体重
	S batno=$P(pdata,"^",3) //批号
	S odate=$P(pdata,"^",4)
	S:odate'="" odate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(odate,"PIVA")
	S otime=$P(pdata,"^",5)
	S:otime'="" otime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(otime,"PIVA")
	S pri=##class(web.DHCSTPIVA).GetOePriority(MOeori)	/// 优先级
	S priDesc=$P(pri,"^",3)
	S freq=##class(web.DHCSTPIVA).GetFreq(MOeori)
	S freq=$P(freq,"^",2)
	S (cprintno,cprintnum,cprintdatetime)=""
	S pcp=$P(pdata,"^",15)
	I pcp'="" D
 	.I $D(^PIVACP(pcp)) D
 	..S cprintno=$P(^PIVACP(pcp),"^",1)	/// 取消打印单号
 	..S cprintdate=$P(^PIVACP(pcp),"^",3)
 	..S cprinttime=$P(^PIVACP(pcp),"^",4)
 	..S:cprintdate'="" cprintdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(cprintdate,"PIVA")
 	..S:cprinttime'="" cprinttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(cprinttime,"PIVA")
 	..S cprintdatetime=cprintdate_" "_cprinttime
 	..S cprintnum=$P(pdata,"^",16)	/// 取消打印序号
 	S SeqNo=$P($G(^OEORD(MOeord,"I",MOeSub,3)),"^",4)		/// 关联医嘱号
 	S ordxdate=$P(^OEORD(MOeord,"I",MOeSub,3),"^",34)		//停医嘱日期
 	S ordxtime=$P(^OEORD(MOeord,"I",MOeSub,2),"^",15)		
 	I ordxdate'="" s ordxdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ordxdate,"PIVA")
	I ordxtime'="" s ordxtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ordxtime,"PIVA")
	S ordxdt=ordxdate_" "_ordxtime
	S orddate=$P(^OEORD(MOeord,"I",MOeSub,3),"^",7)			///下医嘱日期
 	S ordtime=$P(^OEORD(MOeord,"I",MOeSub,1),"^",17)
 	I orddate'="" s orddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(orddate,"PIVA")
	I ordtime'="" s ordtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ordtime,"PIVA")
	S orddt=orddate_" "_ordtime
	//S oestate=##class(web.DHCSTPIVA).GetOeState(MOeori)		///医嘱状态
	S oestate=##class(web.DHCSTPIVA).GetOrdExeState(MOeore)		///执行记录状态 zhouyg 20151110
 	S oestdesc=$P(oestate,"^",2)
 	S cstat=##class(web.DHCSTPIVA).GetPSName(Pog)
 	S spec=$P(pdata,"^",8)
 	I spec="R" S SpecDesc="拒绝"
 	E  S SpecDesc="正常"
 	S instruc=##class(web.DHCSTPIVA).GetInstruc(MOeori)	/// 用法
 	S prtnum=$P(pdata,"^",11)
 	S CuserID=$P(pdata,"^",12)
 	S CDate=$P(pdata,"^",13)
 	I CDate'="" S CDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CDate,"PIVA")
 	S CTime=$P(pdata,"^",14)
 	I CTime'="" S CTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(CTime,"PIVA")
 	S CDT=CDate_" "_CTime
 	S CuserName=""
 	I CuserID'="" S CuserName=$P($G(^SSU("SSUSR",CuserID)),"^",2)
 	S RetStr1=Pog_"^"_MOeori_"^"_GrpNo_"^"_SeqNo_"^"_ward_"^"_bed_"^"_patname_"^"_patno
 	S RetStr2=age_"^"_sex_"^"_weight_"^"_batno_"^"_priDesc_"^"_freq_"^"_cprintno_"^"_cprintnum
 	S RetStr3=cprintdatetime_"^"_orddt_"^"_ordxdt_"^"_oestdesc_"^"_cstat_"^"_SpecDesc_"^"_instruc_"^"_odate
 	S RetStr4=otime_"^"_prtno_"^"_prtnum_"^"_CuserName_"^"_CDT
 	S RetStr=RetStr1_"^"_RetStr2_"^"_RetStr3_"^"_RetStr4
	Q RetStr
}

/// 流程跟踪
ClassMethod GetPogTransFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcItmCatExecute ]
{
	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		S AtEnd=1
 		S Row=""
 	}
 	Else {				
 		S Row=^CacheTemp(repid,ind)
 	}
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

ClassMethod GetPogTransClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArcItmCatExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

ClassMethod GetPogTransExecute(ByRef qHandle As %Binary, tBarCode As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	I tBarCode="" S qHandle=$lb(0,repid,0) Q $$$OK
    S Mdodis=tBarCode
    s ^lq("tBarCode")=tBarCode
    I '$d(^DHCOEDISQTY(Mdodis))  Q $$$OK
	S MOeori=$P($G(^DHCOEDISQTY(Mdodis)),"^",1)
	//S MOeori=MOeord_"||"_MOeSub
	S GrpNo=$O(^PIVA(0,"OEGRP",Mdodis,""))
	S Pog=$O(^PIVA(0,"OEGRP",Mdodis,GrpNo,""))
	Q:Pog="" $$$OK
	S PogsSub="0"
 	F  S PogsSub=$O(^PIVA(Pog,"S",PogsSub)) Q:PogsSub=""  D
 	.S psID=$P(^PIVA(Pog,"S",PogsSub),"^",2)
 	.S (psName,psNumber)=""
 	.I psID'="" D
 	..S psName=$P($G(^PIVAS(psID)),"^",2)
 	..S psNumber=$P($G(^PIVAS(psID)),"^",1)
 	.S psUser=$P(^PIVA(Pog,"S",PogsSub),"^",3)
 	.I psUser'="" S psUser=$P($G(^SSU("SSUSR",psUser)),"^",2)
 	.S psDate=$P(^PIVA(Pog,"S",PogsSub),"^",4)
 	.I psDate'="" S psDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(psDate,"PIVA")
 	.S psTime=$P(^PIVA(Pog,"S",PogsSub),"^",5)
 	.I psTime'="" S psTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(psTime,"PIVA")
 	.S psDT=psDate_" "_psTime
	.D OutputTran
 	Q $$$OK
OutputTran
	S Data=$lb(psName,psNumber,psUser,psDT)
 	S ^CacheTemp(repid,ind)=Data	
 	S ind=ind+1
 	Q
}

Query GetPogTrans(tBarCode As %String) As %Query(ROWSPEC = "tbState:%String,tbCnumber:%String,tbUser:%String,tbDateTime:%String")
{
}

}

Class web.UDHCStopOrderLook Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Collect(oeitm)
{
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s err=$$Collect^SMLPrescLook(oeitm)
	zn oldnamespace
	q err
}

ClassMethod GetAdmOrderC(NowAdm, Arcim, dayflag, longflag, shortflag, user, lulocdes, QueryStartDate, QueryEndDate, AllowStopOtherLoc As %String = "")
{
	;d ##class(web.UDHCStopOrderLook).GetAdmOrderC(360773,"","on","on","on","590","血液内科医疗单元","","")
	;s ^zhou("GetAdmOrderC")=NowAdm_","_Arcim_","_dayflag_","_longflag_","_shortflag_","_user_","_lulocdes_","_QueryStartDate_","_QueryEndDate

	n (NowAdm,Arcim,dayflag,longflag,shortflag,user,lulocdes,QueryStartDate,QueryEndDate,AllowStopOtherLoc,%session)
	s Hospital=..%GetConfig("CurrentHospital")
	s CMSubCategory=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
	s HospitalCode=$P(Hospital,"^",1)
	s LogonLocID=%session.Get("LOGON.CTLOCID")
	s LogonLanID="",UserLanguage=""
	set UserRowId=%session.Get("LOGON.USERID")
	s SSUSRCTLANDR=$p($g(^SSU("SSUSR",UserRowId)),"^",13)
	i SSUSRCTLANDR'=""{
		s LogonLanID=SSUSRCTLANDR
		s UserLanguage=$p(^SS("LAN",SSUSRCTLANDR),"^",1)
	}
	if user="" s user=UserRowId
	
	s luloc=""
	s lulocdes=$g(lulocdes)
	i lulocdes'="" s luloc=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(lulocdes),""))  
	i ($g(longflag)="on")!(+$g(longflag)=1) s longflag=1
	e  s longflag=0
	
	i ($g(shortflag)="on")!(+$g(shortflag)=1)  s shortflag=1 
	e  s shortflag=0 
	
	i ($g(dayflag)="on")!(+$g(dayflag)=1)  s dayflag=1,longflag=1,shortflag=1
	e  s dayflag=0

	if QueryStartDate="" s QueryStartDate=..%SysDate()
	if QueryEndDate="" s QueryEndDate=..%SysDate()

	q:$g(NowAdm)="" -1
	
	s AdmType=$P($g(^PAADM(NowAdm)),"^",2)
	s visstat=$p(^PAADM(NowAdm),"^",20)

	;已经出院结算的患者不能处理医嘱,留观的离院可以停医嘱退费
	s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(NowAdm)
	i " 1 2 "[(" "_PatCurStat_" ") s IsStayFlag=1
	e  s IsStayFlag=0
	q:(IsStayFlag'=1)&($g(visstat)="D") -1
	s ord="" s ord=$o(^OEORD(0,"Adm",NowAdm,ord)) q:ord="" -1
	
	k ^CacheTemp($j,"StopOrderSpecItem")
	if Arcim'="" d
	.s chl=0 f  s chl=$o(^OEORD(ord,"I",chl)) q:chl=""  d 
	..q:'$d(^OEORD(ord,"I",chl))         ;
	..q:$d(^DHCOPIPADMCON("OPADMORDER","OPAdm",NowAdm,ord_"||"_chl))     ; 门急诊费用转住院后不允许停医嘱
	..s Arcimid=$p($g(^OEORD(ord,"I",chl,1)),"^",2) 
	..//有申请单号的不能停止
	..q:##class(DHCDoc.Interface.Inside.Invoke).GetTmInfoByOrderRowId(ord_"||"_chl)'=""
	..s stat=$p($g(^OEORD(+ord,"I",+chl,1)),"^",13)
	..i stat s stat=$p($g(^OEC("OSTAT",stat)),"^")
	..Q:(stat'="V")&(stat'="I") 
	
	..q:$g(Arcimid)=""
	..s ARCimDesc=$p(^ARCIM($p(Arcimid,"||",1),$p(Arcimid,"||",2),1),"^",2)       ;医嘱名称
	..q:(Arcim'=ARCimDesc)
	..s MasterOrderDR=""
	..i $d(^OEORD(ord,"I",chl,11)) s MasterOrderDR=$p(^OEORD(ord,"I",chl,11),"^",39)
	..i MasterOrderDR'="" d
	...s ^CacheTemp($j,"StopOrderSpecItem",MasterOrderDR)=""
	...s chl1=0  f  s chl1=$O(^OEORDi(0,"OEORI",ord,MasterOrderDR,chl1)) q:chl1=""  d
	....s ^CacheTemp($j,"StopOrderSpecItem",ord_"||"_chl1)="" 
	..e  d
	...s ^CacheTemp($j,"StopOrderSpecItem",ord_"||"_chl)="" 
	...s chl1=0  f  s chl1=$O(^OEORDi(0,"OEORI",ord,ord_"||"_chl,chl1)) q:chl1=""  d
	....s ^CacheTemp($j,"StopOrderSpecItem",ord_"||"_chl1)=""  

	s i=0
	s chl=0 f  s chl=$o(^OEORD(ord,"I",chl)) q:chl=""  d          ;
	.k UserDR,UserName
	.q:'$d(^OEORD(ord,"I",chl))
	.//有申请单号的不能停止
	.q:##class(DHCDoc.Interface.Inside.Invoke).GetTmInfoByOrderRowId(ord_"||"_chl)'=""
	.s stat=$p($g(^OEORD(+ord,"I",+chl,1)),"^",13)
	.i stat s stat=$p($g(^OEC("OSTAT",stat)),"^")
	.Q:(stat'="V")&(stat'="I") 
	.q:$d(^DHCOPIPADMCON("OPADMORDER","OPAdm",NowAdm,ord_"||"_chl))     ; 门急诊费用转住院后不允许停医嘱
	.s Arcimid=$p($g(^OEORD(ord,"I",chl,1)),"^",2) 
	.q:$g(Arcimid)=""
	.q:'$D(^OEORD(ord,"I",chl,3))
	.;
	.s Sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)
	.q:(QueryStartDate'="")&&(Sttdate<QueryStartDate)
	.q:(QueryEndDate'="")&&(Sttdate>QueryEndDate)
	.;                     
	.s PriorityDR=$p(^OEORD(ord,"I",chl,1),"^",8)              ;医嘱优先级
	.s PriorityCode=""
	.i PriorityDR'="" s PriorityCode=$P(^OECPR(PriorityDR),"^",1)
	.q:(longflag=0)&((PriorityCode="S")!(PriorityCode="OMST"))          ;longflag=0,不保留长期医嘱
	.q:(shortflag=0)&((PriorityCode'="S")&&(PriorityCode'="OMST"))  ;shortflag=0,不保留短期医嘱
	.q:(dayflag=1)&($g(Sttdate)'=..%SysDate())                        ;flag=1时?只保留当天的医嘱
	.s reploc=$p(^OEORD(ord,"I",chl,3),"^",6)                  ;医嘱接收位置
	.s MasterOrdItemRowId=""
	.i $d(^OEORD(ord,"I",chl,11)) s MasterOrdItemRowId=$p(^OEORD(ord,"I",chl,11),"^",39)
	.//没权限开立，但是有可能是绑定的医嘱
	.Q:((HospitalCode'="SHHSPD")&&(..usersecurity(user,Arcimid)=100)&&(MasterOrdItemRowId=""))  ;根据默认安全组的开医嘱权限?确定其停医嘱的权限
	.i $g(PriorityDR)'="" s priortycode=$p(^OECPR(PriorityDR),"^",1)
	.s priortycode=$g(priortycode) 
	.q:'$d(^ARCIM($P(Arcimid,"||",1),$P(Arcimid,"||",2),1))   
	.s ARCimDesc=$p(^ARCIM($p(Arcimid,"||",1),$p(Arcimid,"||",2),1),"^",2)        ;医嘱名称
	.s ARCimDesc=$p(^ARCIM($p(Arcimid,"||",1),$p(Arcimid,"||",2),1),"^",2)       ;医嘱名称
	.q:(Arcim'=ARCimDesc)&&(Arcim'="")
	.s arctpdr=$p(^ARCIM($p(Arcimid,"||",1),$p(Arcimid,"||",2),1),"^",10)
	.s arctype=$p(^ARC("IC",arctpdr),"^",7) ;ARC_ItemCat 表中的ARCIC_Ordertype ,="R"是药物
	.;                                                       
	.s findspecitem=1
	.i $d( ^CacheTemp($j,"StopOrderSpecItem")) d
	..s findspecitem=0
	..i $d( ^CacheTemp($j,"StopOrderSpecItem",ord_"||"_chl)) s findspecitem=1
	.q:findspecitem=0
	.;
	.;q:(Arcim'="")&(Arcim'=ARCimDesc)
	.q:'$d(^OEORD(ord,"I",chl,1))
	.;
	.s xintmp=$p(^OEORD(ord,"I",chl,1),"^",13)
	.q:$g(xintmp)=""
	.q:'$d(^OEC("OSTAT",xintmp))
	.; 
	.Q:'$d(^OEORD(ord,"I",chl,3))
	.s oeitem=ord_"||"_chl
	.;门诊如果先停医嘱后退费的模式,需要设置可显示的子类   2009.11.13 周志强
	.s PayStatus=$p(^OEORD(ord,"I",chl,3),"^",5)
	.Q:..IsPayCanStopOrder(oeitem)=1
	.;
	.s HourOrderFlag=..HourOrder(oeitem)
	.;;医嘱核实,未核实,停止状态
	.s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",1)            
	.Q:(oeflag="I")
	.Q:(oeflag="E")
	.Q:(oeflag="U")
	.;//20160512 修改为不允许看下已停止的小时医嘱
	.Q:(oeflag="D") //&&(HospitalCode'="SHHSPD")&&(HourOrderFlag'="1")
	.;  
	.s XUserDR=""
	.i $d(^OEORD(ord,"I",chl,7)) s XUserDR=$p(^OEORD(ord,"I",chl,7),"^",1)                                  ;下医嘱人ID
	.s XUserName=""
	.s:$g(XUserDR)'="" XUserName=$p(^SSU("SSUSR",XUserDR),"^",2)                                 ;下医嘱人的Initials
	.s adduser=$P($G(^OEORD(ord,"I",chl,7)),"^",1)
	.s AddLoc=$p($g(^OEORD(ord,"I",chl,7)),"^",2)
	.s AddUserInternalType=..GetCareProvType(adduser)
  	.s StopUserInternalType=..GetCareProvType(user)
  	.q:(StopUserInternalType'=AddUserInternalType)&&(AddUserInternalType'="")
	.s AddLocId=$p($g(^OEORD(ord,"I",chl,7)),"^",2) //科室扩展设置-》医嘱只能本科室停止
	.s OnlyThisDepStopFlag=0
	.s:AddLocId'="" OnlyThisDepStopFlag=$P($G(^CTLOC(AddLocId,"DHC")),"^",14)
	.q:(LogonLocID'=AddLocId)&&(OnlyThisDepStopFlag=1)
	.s Sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)
	.i $g(Sttdate)'="" s Sttdate=..%ZD(Sttdate) //$ZD(Sttdate,3)
	.s Stttime=$p(^OEORD(ord,"I",chl,1),"^",10)
	.i $g(Stttime)'="" s Stttime=..%ZT(Stttime,1)
	.s Enddate=$p($g(^OEORD(ord,"I",chl,9)),"^",9)
	.i Enddate'="" s Enddate=..%ZD(Enddate) //$zd(Enddate,4) 
	.s Endtime=$p($g(^OEORD(ord,"I",chl,9)),"^",10)
	.i Endtime'="" s Endtime=..%ZT(Endtime,3)
	.
	.;长期医嘱首次医嘱的开始日期时间
	.s oeorifillerno=$p($g(^OEORD(ord,"I",chl,9)),"^",12) 
	.i oeorifillerno="" d
	..s FirSttdate=Sttdate
	..s FirStttime=Stttime
	.e  d
	..s FirOeorRowid=$p(oeorifillerno,"!!",1)
	..i FirOeorRowid'="" d
	...s FirSttdate=$p($g(^OEORD($p(FirOeorRowid,"||",1),"I",$p(FirOeorRowid,"||",2),1)),"^",9)
	...s FirSttdate=..%ZD(FirSttdate) //$ZD(FirSttdate,3)
	...s FirStttime=$p($g(^OEORD($p(FirOeorRowid,"||",1),"I",$p(FirOeorRowid,"||",2),1)),"^",10)
	...i $g(FirStttime)'="" s FirStttime=..%ZT(FirStttime,1)
	.;
	.s replocdesc=$p(^CTLOC(reploc),"^",2)
	.i $f(replocdesc,"-")  s replocdesc=$p(replocdesc,"-",2)
	.s freqdesc="",durdesc="",instdesc=""
	.i $D(^OEORD(ord,"I",chl,2)) d                         
	..i $p(^OEORD(ord,"I",chl,2),"^",4)="" s freqdesc=""           
	..e  s freqdesc=$p(^PHCFR($p(^OEORD(ord,"I",chl,2),"^",4)),"^",3)          ;用药频率                
	..i $p(^OEORD(ord,"I",chl,2),"^",6)="" s durdesc=""
	..e  s durdesc=$p(^PHCDU($p(^OEORD(ord,"I",chl,2),"^",6)),"^",3)           ;用药疗程
	..i $p(^OEORD(ord,"I",chl,2),"^",7)="" s instdesc=""
	..e  s instdesc=$p(^PHCIN($p(^OEORD(ord,"I",chl,2),"^",7)),"^",2)           ;用法
	..i $f(instdesc,"-")  s instdesc=$p(instdesc,"-",2)
	.;
	.s doseuom="",ordtype="",oeflagDesc=""
	.if (UserLanguage="EN") d
	..s ARCimDesc=##class(web.DHCDocOrderCommon).GetForeignName(Arcimid)
	..s doseuomrowid=$p(^OEORD(ord,"I",chl,2),"^",3)
	..s doseuom=##class(web.DHCDocOrderCommon).GetUOMDesc(doseuomrowid,UserLanguage) 
	.s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(ord_"||"_chl)
	.s ARCimDesc=ARCimDesc_ReqPartDesc
	.s ordtypeid=$p(^OEORD(ord,"I",chl,1),"^",8)
	.i (ordtypeid'="") d
	..s ordtype=$p(^OECPR(ordtypeid),"^",2)
	..s ordtype=##class(web.DHCDocUtil).GetTranslatedStr(LogonLanID,ordtype)
	.s oeflagid=$p(^OEORD(ord,"I",chl,1),"^",13)
	.i oeflagid'="" d
	..s oeflagDesc=$p(^OEC("OSTAT",oeflagid),"^",2) 
	..s oeflagDesc=##class(web.DHCDocUtil).GetTranslatedStr(LogonLanID,oeflagDesc)
	.s durdesc=##class(web.DHCDocUtil).GetTranslatedStr(LogonLanID,durdesc)
	.s freqdesc=##class(web.DHCDocUtil).GetTranslatedStr(LogonLanID,freqdesc)
	.s instdesc=##class(web.DHCDocUtil).GetTranslatedStr(LogonLanID,instdesc)
	.;
	.s locex=..getlocEx(ord,chl,NowAdm)
	.s adddocname=""
	.s adddocrowid=$p(^OEORD(ord,"I",chl,1),"^",11)    //OEORI_Doctor_DR
	.i adddocrowid'="" s adddocname=$P(^CTPCP(adddocrowid,1),"^",2) 
	.;
	.i ($g(arctype)="R") d
	..;w !,"d" ;-------------------------------药物---------------------------------------------------------  
	..s HaveDispensing=0
	..s oeori=ord_"||"_chl
	..d setdruglist()
	. e  d  ;-------------------------------非药物-------------------------------------------
	..s i=i+1
	..s dstatus=""
	..s dis=$O(^DHCOEDISQTY(0,"OEORI",ord_"||"_chl,0))
	..if $g(dis)'="" d
	...s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
	..s status(i)=""
	..i dstatus="C" s status(i)="已发"
	..i dstatus="TC" s status(i)="未发"
	..i dstatus=""  s status(i)="未打包"
	..s user(i)=adduser
	..s xuserid(i)=$g(XUserDR)
	..s xusername(i)=$g(XUserName) 
	..s locord(i)=$G(AddLoc)
	..s sttd(i)=Sttdate
	
	..s arcdesc(i)=ARCimDesc
	..s ordch(i)=ord_"||"_chl                                                    ;医嘱名称
	..s seqno(i)=$p(^OEORD(ord,"I",chl,3),"^",4)                                 ;医嘱序号     
	..s presc(i)=$p(^OEORD(ord,"I",chl,1),"^",14)                                ;医嘱处方号
	..s enddate(i)=Enddate
	..s endtime(i)=Endtime
	..i $p(^OEORD(ord,"I",chl,1),"^",8)'="" d
	...s ordtype(i)=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",2)             ;医嘱优先级代码  
	..e  s ordtype(i)=""
	..s oeflag(i)=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",2)       ;医嘱核实?未核实?停止状态 
	..s date(i)=..%ZD($p(^OEORD(ord,"I",chl,3),"^",7)) //$zd($p(^OEORD(ord,"I",chl,3),"^",7),3)    						 ;OEORI_Date 下医嘱时间
	..s OEORIOEORIDR(i)=""
	..i $d(^OEORD(ord,"I",chl,11)) s OEORIOEORIDR(i)=$p(^OEORD(ord,"I",chl,11),"^",39)
	..//q:$d(^OEORD(ord,"I",chl,2))=0 
	..s dosage(i)=$p($g(^OEORD(ord,"I",chl,2)),"^",1)
	..s qty(i)=$p(^OEORD(ord,"I",chl,1),"^",12) 
	..s freq(i)=freqdesc
	..s inst(i)=instdesc
	..s patientsort(i)=$p(^PAADM(NowAdm),"^",2)  //cwg061028
	..s docloc(i)=$P(locex,"^"),exflag(i)=$P(locex,"^",2),xtsj(i)=$P(locex,"^",3),zxr(i)=$P(locex,"^",4)
	..s usemethod(i)=""
	.i ($g(arctype)'="R") s status(i)=""
	.s docloc(i)=$P(locex,"^")
	.s reploc(i)=replocdesc
	.s adddoc(i)=adddocname
	.s spec(i)=##class(web.DHCOEOrdItem).GetLabSpec(oeitem)
	.;判断是否护士执行状态 1:执行  0:未执行 	2:退回
	.s NurseExecStatus(i)=##class(web.DHCNurCom).IfExecOrder(oeitem)
	.i NurseExecStatus(i)=0 s NurseExecStatus(i)="未执行"
	.i NurseExecStatus(i)=1 s NurseExecStatus(i)="已执行"
	.i NurseExecStatus(i)=2 s NurseExecStatus(i)="已退回"
	.s FirstSttdate(i)=FirSttdate
	.s FirstStttime(i)=FirStttime
	.s Notes(i)=$g(^OEORD(ord,"I",chl,"DEP",1))                                 ;备注 gsb2008-12-1
	.s CMFlag="N"  
	.if ((("^"_CMSubCategory_"^")[("^"_arctpdr_"^"))&&(CMSubCategory'="")) s CMFlag="Y"
	.if CMFlag="Y" d
	..if $G(presc(i))'=""  d
	...s PrescRowid=$O(^PAQUE1(0,"PrescNo",$G(presc(i)),""))
	...s Notes(i)=$P($G(^PAQUE1(PrescRowid,"DHC")),"^",21)

	s tmpid=$I(^mPLIST)
	F j=1:1:i d
	.s ret=""
	.s CanStopLoc="Y"
	.if ($G(luloc)'="")&&($G(luloc)'=$G(locord(j))) s CanStopLoc="N"
	.Q:CanStopLoc="N"
	.s ^mPLIST(tmpid,j)=$lb(seqno(j),arcdesc(j),ordtype(j),oeflag(j),date(j),status(j),qty(j),reploc(j),presc(j),dosage(j),freq(j),inst(j),ordch(j),$g(sttd(j)),$g(xuserid(j)),$g(xusername(j)),$g(OEORIOEORIDR(j)),$g(usemethod(j)),$G(docloc(j)),$G(exflag(j)),$g(enddate(j)),$g(endtime(j)),$g(adddoc(j)),$g(spec(j)),$g(NurseExecStatus(j)),$g(FirstSttdate(j)),$g(FirstStttime(j)),$g(Notes(j)))
	q tmpid
setdruglist()
	s i=i+1
	s dstatus=""
	s dis=$O(^DHCOEDISQTY(0,"OEORI",oeori,0))
	if $g(dis)'="" {
		/*
		s inclbid=$p(^OEORD(ord,"I",chl,"X",ex,"D",dis),"^",2)                       ;INCLB_RowId
		s inci=$p(inclbid,"||",1)
		s qty(i)=$p(^OEORD(ord,"I",chl,"X",ex,"D",dis),"^",1)                      ;发药数量       
		s uom(i)=$p(^CT("UOM",$p(^INCI(inci,1),"^",10)),"^",2)  ;药品基本库存单位
		*/
		s dis1=0
		f  s dis1=$o(^DHCOEDISQTY(0,"OEORI",oeori,dis1)) q:dis1=""  d
		.s qty(i)=+$g(qty(i))+$p(^DHCOEDISQTY(dis1),"^",2)
		s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
		//s qty(i)=$p(^DHCOEDISQTY(dis),"^",2)
		s uom(i)=$p(^DHCOEDISQTY(dis),"^",6)
		if uom(i)'="" s uom(i)=$p(^CT("UOM",uom(i)),"^",2)  ;药品基本库存单位
		s qty(i)=qty(i)_" "_uom(i)
		
		
	}else{
		s qty(i)=""
	}
	s user(i)=adduser
	s locord(i)=$G(AddLoc)
	s sttd(i)=Sttdate
	i dstatus="C" s status(i)="已发"
	i dstatus="TC" s status(i)="未发"
	i dstatus=""  s status(i)="未打包"

	s xuserid(i)=$g(XUserDR)
	s xusername(i)=$g(XUserName) 
	s arcdesc(i)=ARCimDesc
	s OEORIOEORIDR(i)="" 
	i $d(^OEORD(ord,"I",chl,11)) s OEORIOEORIDR(i)=$p(^OEORD(ord,"I",chl,11),"^",39)
	s ordch(i)=ord_"||"_chl                                                    ;医嘱名称
	s seqno(i)=$p(^OEORD(ord,"I",chl,3),"^",4)                                 ;医嘱序号     
	s presc(i)=$p(^OEORD(ord,"I",chl,1),"^",14)                                ;医嘱处方号
	s date(i)=..%ZD($p(^OEORD(ord,"I",chl,3),"^",7)) //$zd($p(^OEORD(ord,"I",chl,3),"^",7),3)    ;下医嘱时间
	s enddate(i)=Enddate
	s endtime(i)=Endtime
	s dosage(i)=$p(^OEORD(ord,"I",chl,2),"^",1)                                ;用药剂量
	i $p(^OEORD(ord,"I",chl,2),"^",3)'="" s doseuom(i)=$p(^CT("UOM",$p(^OEORD(ord,"I",chl,2),"^",3)),"^",2)          ;剂量单位
	e  s doseuom(i)=""
	s freq(i)=freqdesc             ;用药频率                
	s dur(i)=durdesc               ;用药疗程
	s inst(i)=instdesc             ;用法
	s ordtype(i)=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",2)          ;医嘱优先级代码 
	s oeflag(i)=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",2)    ;医嘱核实?未核实?停止状态     
	;s price(i)=$$getprice(inci,sttdate)
	s dosage(i)=dosage(i)_" "_doseuom(i)
	s docloc(i)=$P(locex,"^"),exflag(i)=$P(locex,"^",2),xtsj(i)=$P(locex,"^",3),zxr(i)=$P(locex,"^",4)
	s usemethod(i)=""
	s spec(i)=""
	Q 0
}

/// creator:郭荣勇
/// desc:门诊如果退费需要停医嘱,则返回可停标识;对于不需要停医嘱的,在界面不显示并控制不能停止
///      对于先诊疗后收费的模式,药品发药,治疗,材料护士执行视同收费状态
///     住院根据医生站的配置判断
/// date:2013-11-27
/// output:0 可以停止,1 不能停止
ClassMethod IsPayCanStopOrder(oeitem As %String)
{
	;先停医嘱再退费的子类,不用,走退费需停医嘱的配置
	;s CFOPStopPaidItemCat=..%GetConfig("OPStopPaidItemCat")
	;if CFOPStopPaidItemCat'="" s CFOPStopPaidItemCat="^"_CFOPStopPaidItemCat_"^"
	s CFIPStopPaidOrder=..%GetConfig("IPStopPaidOrder")
	s myrtn=0
	Q:oeitem="" 0
	s AdmId=$p(^OEORD(+oeitem),"^",1)
	s AdmDepDr=$p($g(^PAADM(AdmId)),"^",4)
	s AdmDepHospId=$p(^CTLOC(AdmDepDr),"^",22)
	s AdmType=$p(^PAADM(AdmId),"^",2)
	s Arcimid=$p($g(^OEORD(+oeitem,"I",$p(oeitem,"||",2),1)),"^",2) 
	s arctpdr=$p(^ARCIM($p(Arcimid,"||",1),$p(Arcimid,"||",2),1),"^",10)
	Q:arctpdr="" 0
	s UserEMVirtualtLong=##Class(web.DHCDocOrderVirtualLong).GetUserEMVirtualtLong(AdmId)
	;免费药标识
	s HospID=##class(DHCDoc.Common.Hospital).GetAffiliatedHospitalId(AdmId)
	s ARCIMFreeDurgFlag=##class(web.DHCDocOrderCommon).GetARCIMFreeDurgFlag(Arcimid,HospID)
	;药理实验项目是否直接计费
	//s CFEntryOrdBillPad=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("EntryOrdBillPad")
	;药理项目已经收费停医嘱查询能作废和停医嘱
	s PilotProflag=$p($G(^OEORD(+oeitem,"I",$p(oeitem,"||",2),"DHC")),"^",10)
	//Q:(CFEntryOrdBillPad=1)&&(PilotProflag'="") 0
	s PAADMType=$p($g(^PAADM(AdmId)),"^",2)
    s OPOrdAutoBilled=$g(^DHCDocPilotSeting(AdmDepHospId,"OPOrdAutoBilled"))
    if ((PAADMType="O")&&(OPOrdAutoBilled="Y")&&(PilotProflag'=""))||(ARCIMFreeDurgFlag="Y"){
		s OrderType=$P(^ARC("IC",arctpdr),"^",7)
	    Q:(OrderType="L")||(##class(web.DHCDocOrderCommon).GetItemServiceFlag(Arcimid)=1) 0
	    //检验医嘱自动绑定的医嘱也能停止
	    s LLabEpisodeNoStr=$P($G(^OEORD(+oeitem,"I",$p(oeitem,"||",2),"DHC")),"^",22)
	    Q:(LLabEpisodeNoStr'="") 0
	    s OrdPackQtyInfo=##class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(oeitem)
	    s dstatus=$p(OrdPackQtyInfo,"^",9)
	    ;dstatus等于空也可以停止医嘱，非药品医嘱如果执行后面方法也会阻断其继续停止
	    Q:(dstatus="未发")||(dstatus="全退")||(dstatus="") 0
	}
	;门诊已经预结算的医嘱不能作废和停医嘱
	s TPFlag=##class(web.DHCOPBillChargExcepiton).CheckTPFlagByOEORIDR(oeitem)
	Q:(AdmType'="I")&(TPFlag=1) 1
	s OrderBilled=$P($G(^OEORD(+oeitem,"I",$p(oeitem,"||",2),3)),"^",5)
	s CFOPJFNeedStopItemCatStr="",CFOPJFNeedStopFlag=0
    ;留观
    #; s IsStayFlag=0
    #; s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(AdmId)
	#; i " 1 2 "[(" "_PatCurStat_" ") s IsStayFlag=1
	s IsStayFlag=$P($G(^OEORD(+oeitem,"I",$p(oeitem,"||",2),"DHC")),"^",17)
	;急诊流水患者先开立医嘱并缴费后转留观,退费走普通门诊退费申请
	if (OrderBilled="P")&&(IsStayFlag=1){
		Q 1
	}
	s AsPayFlag=0
	s ReadyToBill=$p($g(^OEORD(+oeitem,"I",$p(oeitem,"||",2),12)),"^",26) 
	i (AdmType'="I")&((ReadyToBill="Y")||(IsStayFlag=1))&((..IsDspDrug(oeitem)=1)||(+..IsOrdExec(oeitem)>0)) s AsPayFlag=1
	if (AdmType'="I")&(IsStayFlag'=1)&((OrderBilled="P")||(AsPayFlag=1)) {
		if (CFOPJFNeedStopFlag=0)||((CFOPJFNeedStopFlag=1)&(CFOPJFNeedStopItemCatStr[($c(2)_arctpdr_$c(2)))) s myrtn=1
		s ArcimId=$p($g(^OEORD(+oeitem,"I",$p(oeitem,"||",2),1)),"^",2)
		s type=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
		if (type'="Other")&&(OrderBilled="P") s myrtn=1
	}
	if (AdmType="I")&(OrderBilled="P")&(CFIPStopPaidOrder'="1") s myrtn=1
	//急诊留观患者 收费模式为普通收费模式，已收费医嘱不能停止
	s StayPayMode=##class(web.DHCBillInterface).IGetStayPayMode(AdmDepHospId)
	if (StayPayMode=0)&&(IsStayFlag=1)&&(OrderBilled="P") {
		if (CFOPJFNeedStopFlag=0)||((CFOPJFNeedStopFlag=1)&(CFOPJFNeedStopItemCatStr[($c(2)_arctpdr_$c(2)))) s myrtn=1
	}
	;调用计费组接口,如果留观是使用的押金收费的模式,护士执行后不可以停止医嘱
	//i (StayPayMode=1)&&(+..IsOrdExec(oeitem)>0)&&(IsStayFlag=1) s myrtn=1
	i (UserEMVirtualtLong=0)&&(+..IsOrdExec(oeitem)>0) s myrtn=1
	//---------end----------
	Q myrtn
}

/// creator:郭荣勇
/// date:2012-03-31
/// desc:医嘱是否有过发药
/// output:1 有发药;0 没有发药
/// other:
/// w ##class(web.UDHCStopOrderLook).IsDspDrug("599||1")
ClassMethod IsDspDrug(oeitm As %String) As %String
{
	n (oeitm)
	s dstatusFlag=0
	s dspQty=0,refundQty=0
	s dis=0 for {
		s dis=$O(^DHCOEDISQTY(0,"OEORI",oeitm,dis)) q:dis=""
		s dstatus="",dsqty=0
		if $g(dis)'="" {
			s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
			s dsqty=$p(^DHCOEDISQTY(dis),"^",5)
		}
		if dstatus="C" s dspQty=dspQty+dsqty  //s dstatusFlag=1
		if dstatus="R" s refundQty=refundQty+dsqty
		//q:dstatusFlag=1	
	}
	if (dspQty>refundQty) s dstatusFlag=1 
	q dstatusFlag
}

/// creator:郭荣勇
/// date:2012-03-31
/// desc:医嘱是否有执行过
/// output:1 有执行;0 没有执行;2 完全执行
/// other:
/// w ##class(web.UDHCStopOrderLook).IsOrdExec("599||1")
ClassMethod IsOrdExec(oeoriId As %String = "")
{
	s retStr=0
	q:(oeoriId="")!(+oeoriId=0)!(+$P(oeoriId,"||",2)=0) retStr
	s oeordId=+$P(oeoriId,"||")
	s oeoriSub=$P(oeoriId,"||",2)
	s ordExecNum=$G(^OEORD(oeordId,"I",oeoriSub,"X",0))
	q:((ordExecNum=0)||(ordExecNum="")) retStr
	s oeoreSub=0
	s ordNum=0
	s ordExecNum=0
	f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
	.s ordNum=ordNum+1
	.s orderStatDr=$P($G(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16)
	.q:orderStatDr=""
	.q:$P($G(^OEC("STAT",orderStatDr)),"^")'="F"
	.s CTPCPDr=$P($G(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",15)
	.q:CTPCPDr=""
	.s ordExecNum=ordExecNum+1
	i (ordExecNum'=0)&(ordNum'=0) {
		i (ordExecNum=ordNum) s retStr=2
		e  s retStr=1
	}
	q retStr
}

ClassMethod GetPNameRegNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", Adm As %String = "")
{
	q:Adm="" ""
	q:'$d(^PAADM(Adm)) ""
	s papmidr=$p(^PAADM(Adm),"^",1)
	&sql(select papmi_no,papmi_name into :pname,:Regno from SQLUser.PA_PatMas where papmi_rowid=:papmidr)
 s padmdate=$p(^PAADM(Adm),"^",6)  //dj080904
 s padmdate=$ZD(padmdate,4)
 s curdate=$ZD($H,4)
	q pname_"^"_Regno_"^"_padmdate_"^"_curdate
}

ClassMethod Getdocloc(user, Loc, oeoriRowId)
{
	n (user,Loc,oeoriRowId)
	s res="Y"
	q:Loc="" "Y"
	;q:user="" "N"
	;没有用户代表系统生成的医嘱
	q:user="" "Y"
	
	/*特殊处理通过医嘱子类写死，显示不受传入科室控制的医嘱 start
	s ord=$p(oeoriRowId,"||",1)
	s chl=$p(oeoriRowId,"||",2)
	s Arcimid=$p($g(^OEORD(ord,"I",chl,1)),"^",2)
	s ItemCatRowId=$p($g(^ARCIM($p(Arcimid,"||",1),$p(Arcimid,"||",2),1)),"^",10)
	s ARCICCode=$p(^ARC("IC",ItemCatRowId),"^",1)
	Q:(ARCICCode="HL02")||(ARCICCode="HL03") "Y"
	end guorongyong*/
	
	s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	q:DoctorDr="" "N"
	s truedoc=0
	
	s DocLoc=0 f  s DocLoc=$O(^RB("RES",0,"CTPCP",DoctorDr,DocLoc)) q:DocLoc=""  d
	.if Loc=DocLoc  s truedoc=1
	i truedoc'=1 s res="N" 
	q res
}

ClassMethod HourOrder(OrderItemRowId)
{
	n (OrderItemRowId)
	s ArcimRowId=$p(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),1),"^",2)
	s BillUomRowId=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),8)),"^",14)
	s BillUomCode=""
	s:+BillUomRowId'=0 BillUomCode=$p($g(^CT("UOM",BillUomRowId)),"^")
	s BillUomCode=$zcvt($g(BillUomCode),"U")
	Q:BillUomCode="HOUR" 1
	Q 0
}

ClassMethod PreStopOrder(oeitm, STDateN, STTimeN)
{
	n (oeitm, STDateN, STTimeN)
	s SQLCODESum=0
	
	TS
	&sql(update SQLUser.OE_orditem set OEORI_enddate=:STDateN,OEORI_endtime=:STTimeN where OEORI_rowid=:oeitm)
	s SQLCODESum=SQLCODESum+SQLCODE
	
	s Sub=$O(^OEORDi(0,"OEORI",+oeitm,oeitm,0))
	While (Sub'="") {
		s SubRowId=+oeitm_"||"_Sub
		
        &sql(update SQLUser.OE_orditem set OEORI_enddate=:STDateN,OEORI_endtime=:STTimeN where OEORI_rowid=:SubRowId)
        s SQLCODESum=SQLCODESum+SQLCODE
        if SQLCODESum quit

		s Sub=$O(^OEORDi(0,"OEORI",+oeitm,oeitm,Sub))
	}
	if SQLCODESum {
		TRO
	}else{
		TC
	}
	q SQLCODESum
}

ClassMethod ReturnDisp(oedis, qty, retreason As %String) As %String
{
	q:$g(oedis)="" -1
	s ord=+oedis,itm=$p(oedis,"||",2),exe=$p(oedis,"||",3),dis=$p(oedis,"||",4)
	s s=$g(^OEORD(ord,"I",itm,"X",exe,"D",dis))
	q:s="" -2
	s dispedqty=+$p(s,"^",1)                ;dispensed qty
	s returnedqty=+$p(s,"^",7)              ;returned qty
	s returnable=dispedqty-returnedqty      ;the qty allowed to return
	q:returnable'>0 -3                       ;if returnable is negative then quit
	q:returnable<qty -4    
	;         
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	;
	s err=$$select^MVBOEDIS(oedis),PLIST(11)=qty+returnedqty
	s err=$$update^MVBOEDIS(oedis)
	;Update OE_OrdItem Which will be used when bill this oeitm
	s oeitm=ord_"||"_itm            ;oe_orditem rowid
	s err=$$select^MVBOEITM(oeitm) 
	s PLIST(91)=qty+returnedqty         ;OEORI_RefundQty
	s PLIST(95)=retreason       ;OEORI_ReasonRefund_DR - 
	s PLIST(96)="Y"          ;OEORI_ReturnToStock
	s err=$$update^MVBOEITM(oeitm) 
	zn oldnamespace  ; Restore the namespace
	
	q 0
}

/// 撤销医嘱,在医生刚开完医嘱发现有问题的时候,可以作废医嘱,医嘱单不打印
ClassMethod RevokeOrderItem(OrdList, UserID) As %String
{
	;w ##class(web.UDHCStopOrderLook).RevokeOrderItem("6||99&&&","6496")
	s ^TMPgry("RevokeOrderItem")=OrdList_","_UserID
	n (OrdList,UserID)
	Q:($g(OrdList)="")||($g(UserID)="") -100
	set execsum=0
	set err=0
	for i=1:1:$l(OrdList,"^") {
		set oeitmStr=$p(OrdList,"^",i)
		set oeitm=$p(oeitmStr,"&",1)
		if oeitm="" set err=-100 quit
		set obj=##class(User.OEOrdItem).%OpenId(oeitm)
		if '$IsObject(obj) set err=-100 quit			//医嘱不存在
		set OEORIBilled=obj.OEORIBilled
		if OEORIBilled="P" set err=-102 quit     		//已经收费
		set OEORIUserAdd=obj.OEORIUserAddGetObjectId()
		if OEORIUserAdd'=UserID set err=-103 quit     	//作废医嘱要和下医嘱人一致
		set OEORIItemStatDR=obj.OEORIItemStatDR
		set OEORIItemStateCode="",OEORIItemStateDesc=""
		if $IsObject(OEORIItemStatDR) {
			set OEORIItemStateRowId=OEORIItemStatDR.%Id()
			set OEORIItemStateCode=OEORIItemStatDR.OSTATCode
			set OEORIItemStateDesc=OEORIItemStatDR.OSTATDesc
		}
		if (OEORIItemStateCode'="V")&&(OEORIItemStateCode'="U") set err=-104 quit   //非核实状态的医嘱不能作废
		
		;add by zhouzq 2010.03.09
		s dstatus=""
		s dis=$O(^DHCOEDISQTY(0,"OEORI",oeitm,0))
		if $g(dis)'="" s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
		i dstatus="C" set err=-105 quit 				//已经发药
		;&sql(select count(*) into :execsum from SQLUser.OE_OrdExec where oeore_oeori_parref=:oeitm order by oeore_rowid)
		;if execsum>0 set err=-105 quit                 //已经执行的医嘱不能作废
    	if ..IsPayCanStopOrder(oeitm)=1 set err=-200 quit
		
		set OEORIFillerNo=obj.OEORIFillerNo
		set SttDate=obj.OEORISttDat
		set FreqDr=obj.OEORIPHFreqDRGetObjectId()
		TS
		;判断是否首次医嘱产生的医嘱
		s PreIsFirstOrder="N"
		s PreCopeOrder=$p(OEORIFillerNo,"!!",2)
		B ;0
		if PreCopeOrder'="" {
			s PreCopeOrderFillerNoStr=$p($g(^OEORD(+PreCopeOrder,"I",$p(PreCopeOrder,"||",2),9)),"^",12)
			s PreFirstOrder=$p(PreCopeOrderFillerNoStr,"!!",2)
			if PreFirstOrder="" {
				s PreIsFirstOrder="Y"
			}	
		}else{
			s inter=..GetInterOfFreqOrd(FreqDr,+$h)
			s ChildSub=0
			for {
				s ChildSub=$o(^OEORDi(0,"StDt",SttDate+inter,+oeitm,ChildSub)) 
				q:((ChildSub="")||(err'=0))
				b ;0
				s OrderFillerNoStr=$p($g(^OEORD(+oeitm,"I",ChildSub,9)),"^",12)
				if OrderFillerNoStr="" continue
				s OrderFillerNo=$p(OrderFillerNoStr,"!!",1)
				if (OrderFillerNo'=oeitm) continue
				s AutoFirstOrder=+oeitm_"||"_ChildSub
				s err=..RevokeOrderItem(AutoFirstOrder,UserID)
			}
		}
		
		i err {
			Trollback
			s err=-108
			break
		}

		if (OEORIFillerNo'="")&&(OEORIItemStateCode="V")&&(PreIsFirstOrder="N") set err=-106 quit   //滚出来的核实医嘱不能作废
		&sql(select OSTAT_RowId into :OSTATRowId from SQLUser.OEC_OrderStatus where OSTAT_Code='U')
		do obj.OEORIItemStatDRSetObjectId(OSTATRowId)
		if OEORIBilled="B" set obj.OEORIBilled="I"
		set sc=obj.%Save()
		If $$$ISERR(sc) {
			Trollback
			set err=-100
			break
		}
		do obj.%Close()
		
		s err=##class(web.DHCOEOrdItem).UpdateStatus(oeitm,UserID,OSTATRowId)
		i err {
			Trollback
			s err=-107
			break
		}
		
		d ##class(web.DHCOEDispensing).Return(oeitm)
		
		s Sub=$O(^OEORDi(0,"OEORI",+oeitm,oeitm,0))
		While (Sub'="") {
			s SubRowId=+oeitm_"||"_Sub
			s err=##class(web.DHCOEOrdItem).UpdateStatus(SubRowId,UserID,OSTATRowId)
			if err {
				break
			}
			d ##class(web.DHCOEDispensing).Return(SubRowId)
			s Sub=$O(^OEORDi(0,"OEORI",+oeitm,oeitm,Sub))
		}
		
		i err {
			Trollback
			s err=-101
			break
		}
		;
		
		
	 	if err=0 TC
	 }
	 Q err
}

ClassMethod GetInterOfFreqOrd(FreqDr As %String, currtoday As %String) As %String
{
    n (FreqDr,currtoday)
    s inter=1
    Q:FreqDr="" inter
    Set FreqCode=""
    If FreqDr'="" Set FreqCode=$ZCVT($p($g(^PHCFR(FreqDr)),"^"),"U")
    If FreqCode="QOD" Set inter=2
	Set WeekFlag=$P($g(^PHCFR(+$g(FreqDr),"DHC")),"^",1)
	if ($g(WeekFlag)=1)&&(FreqDr'="") d
	.Set CurrWeek=$ZD(+currtoday,10)
	.If CurrWeek=0 Set CurrWeek=7
	.Set nextweek="",minweek=""
	.Set childsub=0  f  s childsub=$O(^PHCFR(FreqDr,"OPDT",childsub)) Q:childsub=""  d
	..Set time=$p(^PHCFR(FreqDr,"OPDT",childsub),"^",1)
	..Set week=$p(^PHCFR(FreqDr,"OPDT",childsub),"^",2)
	..if minweek="" s minweek=week
	..else  if minweek>week Set minweek=week 
	..Q:week<=CurrWeek
	..i nextweek="" s nextweek=week
	..e  i nextweek>week s nextweek=week
	.if nextweek="" s nextweek=minweek
	.if nextweek>CurrWeek Set inter=nextweek-CurrWeek
	.if nextweek<=CurrWeek Set inter=(7-CurrWeek)+nextweek
	
	Q inter
}

/// 停长嘱,自动停止前一天的医嘱,可用于"静脉配液中心"
/// Example: w ##class(web.UDHCStopOrderLook).StopAppOrder("217889||739","291",40562)
ClassMethod StopAppOrder(AppItemRowid, UserID, STTimeN)
{
	s Hospital=..%GetConfig("CurrentHospital")
 	s HospitalCode=$P(Hospital,"^",1)
	
	if HospitalCode'="BJDTYY" Quit 0
	
	s err=0
	
	// 只处理当天的情况
	s OEORIRowid=$p(AppItemRowid,"||",1)
	s OEORISub=$p(AppItemRowid,"||",2)
	s OEORISttDate=$P($G(^OEORD(OEORIRowid,"I",OEORISub,1)),"^",9)
	q:OEORISttDate'=..%SysDate() 0
	
	// 医生站设置->静脉配液中心设置
	s IPDosingRecLoc=##Class(DHCDoc.DHCDocConfig.DocConfig).GetDosingRecLocStr("IPDosingRecLoc")
	s RecDepDR=$P($G(^OEORD(OEORIRowid,"I",OEORISub,3)),"^",6)
	s TempIPDosingRecLoc="^"_IPDosingRecLoc_"^"
	q:(TempIPDosingRecLoc'[RecDepDR) err
	
	if HospitalCode="BJDTYY" {
		// 因为地坛把口服药药房也做到了配液中心的设置里
		// 药房配置
		s ArcimRowid=$P($G(^OEORD(OEORIRowid,"I",OEORISub,1)),"^",2)
		s ItemCatRowId=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
		s findgroupcode=""
		s group=0  f  s group=$O(^DHCSTDRUGGRP(group)) Q:group=""  d
		.s groupcode=$P(^DHCSTDRUGGRP(group),"^",1)
		.s itm=0  f  s itm=$O(^DHCSTDRUGGRP(group,"I",itm)) Q:(itm="")||(findgroupcode'="")  d
		..s OrdCatDr=$P(^DHCSTDRUGGRP(group,"I",itm),"^",1)
		..i ItemCatRowId=OrdCatDr s findgroupcode=groupcode
		if findgroupcode="" Quit err
	 	if (findgroupcode="KFBY")||(findgroupcode="KFFY") Quit err
	}

	// 停止源医嘱
	s OrderFillerNoStr=$p($g(^OEORD(+AppItemRowid,"I",$p(AppItemRowid,"||",2),9)),"^",12)
	s AppOrderRowid=$p(OrderFillerNoStr,"!!",2)
	s err=..discon(AppOrderRowid,UserID)
	s err=..Collect(AppOrderRowid) //里面包括执行自动的没有发药的药品退药
	//w "AppOrderRowid=="_AppOrderRowid,!
	q err
}

/// 判断医嘱是否可撤销
ClassMethod isCanCancel(OrItemID) As %String
{
	s Adm=$p(^OEORD(+OrItemID),"^",1)
	s AdmType=$P($G(^PAADM(Adm)),"^",2)
	if (AdmType="E"){
		;1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
 		s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(Adm)
 		s VisitStatus=$p($g(^PAADM(Adm)),"^",20)
 		i (" 1 2 "[(" "_GetStayStatusFlag_" ")) {
	 		s flag=##class(web.DHCDocMainOrderInterface).HiddenMenuFlag(Adm)
	 		Q:((flag'=0)&&(flag'="2.5")) 1
	 	}
	}
	;需要控制执行的医嘱优先级
	s CFStopExecOrderPriorStr=..%GetConfig("StopExecOrderPrior")
	if CFStopExecOrderPriorStr'="" s CFStopExecOrderPriorStr="^"_CFStopExecOrderPriorStr_"^"
 	;判断是执行过的医嘱则不可以停医嘱
	s PriorityCode=""
	s PriorityDr=$p(^OEORD(+OrItemID,"I",$p(OrItemID,"||",2),1),"^",8)
	i PriorityDr'="" s PriorityCode=$p(^OECPR(PriorityDr),"^",1)
	if CFStopExecOrderPriorStr[("^"_PriorityDr_"^") {
		;由护士站提供接口判断
		s NurseExecStatus=##class(web.DHCNurCom).IfExecOrder(oeitm)
		if NurseExecStatus=1  Q ##Class(web.DHCDocInPatPortalCommon).GetMsg("-300")
	}
	;停止的医嘱子类不属于需要先停医嘱再退费的配置子类串,判断收费状态
    ;计费组配置,Return:1!例外子类串 表示需要医生停止医嘱才能退费,0 表示医生不需要停止医嘱就能退费
    s HavePayOrd=""
	if ..IsPayCanStopOrder(OrItemID)=1 {
		if HavePayOrd=""  s HavePayOrd=OrItemID
		else  s HavePayOrd=HavePayOrd_"^"_OrItemID
	}
	Q:HavePayOrd'="" ##Class(web.DHCDocInPatPortalCommon).GetMsg("-200")
	/*如果检查有申请单号,则不能取消*/
	s TmInfoStr=""
	s TmInfo=##class(DHCDoc.Interface.Inside.Invoke).GetTmInfoByOrderRowId(OrItemID)
	if (TmInfo'=""){
		s arcim=$P(^OEORD(+OrItemID,"I",$p(OrItemID,"||",2),1),"^",2)
	    s arcimDesc=$P($G(^ARCIM(+arcim,$P(arcim,"||",2),1)),"^",2)
		i TmInfoStr="" s TmInfoStr=arcimDesc
		e  s TmInfoStr=TmInfoStr_","_arcimDesc
	}
	Q:TmInfoStr'="" TmInfoStr_"已有申请单号,不能撤销!"
	;实库库管进行了医嘱提取，需要经过高值材料库管员退货确认
	if ("N"=##class(web.DHCSTMHUI.PCHCOLLSM).GetRetFlag(OrItemID)) {
		Q ##Class(web.DHCDocInPatPortalCommon).GetMsg("-210")
	}
	Q 0
}

/// w ##class(web.UDHCStopOrderLook).StopOrderBroker("7945||10","17473","","N")
ClassMethod StopOrderBroker(OrdList As %String = "", UserID As %String = "", PinNum As %String, PWFlag As %String = "Y", ExpStr As %String = "")
{
	n (OrdList,UserID,PinNum,PWFlag,ExpStr,%session)
	s ErrMsg=""
	s ErrCode=..StopOrder("","",OrdList,UserID,PinNum,PWFlag,ExpStr,.ErrMsg)
	Q ErrCode_"^"_ErrMsg
}

/// w ##class(web.UDHCStopOrderLook).StopOrder("""","""",""463||5&&&??"",""6"",""1"",""Y"")
ClassMethod StopOrder(itmjs As %Library.String = "", itmjsex As %Library.String = "", OrdList As %String = "", UserID As %String = "", PinNum As %String, PWFlag As %String = "Y", ExpStr As %String = "", ByRef ErrMsg As %String = "")
{
 s ^zhou("StopOrder")="w ##class(web.UDHCStopOrderLook).StopOrder("""","""","""_OrdList_""","""_UserID_""","""_PinNum_""","""_PWFlag_""")"
 //重新组织停医嘱串,根据配置停主医嘱
 s StopGroupOrder=..%GetConfig("StopGroupOrder")
 //需要控制执行的医嘱优先级
 s CFStopExecOrderPriorStr=..%GetConfig("StopExecOrderPrior")
 if CFStopExecOrderPriorStr'="" s CFStopExecOrderPriorStr="^"_CFStopExecOrderPriorStr_"^"
 
 s Hospital=..%GetConfig("CurrentHospital")
 s HospitalCode=$P(Hospital,"^",1)
 ;lxz
 s HavePayOrd=""
 s TmInfoStr=""
 s OrdListStr=""
 s err=0
 s OrdList=##Class(web.UDHCStopOrderLook).GetAppenOrdInfo(OrdList)
 s LocID=""
 if (ExpStr'=""){				
		s LocID=$p(ExpStr,"^",4)	
	}
 k ^TMPUpSTDateTime
 s Len=$l(OrdList,"^")
 for i=1:1:Len
 {
	s OrderItemStr=$p(OrdList,"^",i)
	s OrderItemStr=$REPLACE(OrderItemStr,"!","&")
	s OrItemID=$p(OrderItemStr,"&",1)    //不能改医嘱ID为第一位的位置
	continue:OrItemID=""
	s StartDate=$p(OrderItemStr,"&",2)
	s StartTime=$p(OrderItemStr,"&",3)
	s OEORIServiceOrdDR=$p($g(^OEORD(+OrItemID,"I",$p(OrItemID,"||",2),"DHC")),"^",54)
	if (OEORIServiceOrdDR'="") {
		if ..IsPayCanStopOrder(OEORIServiceOrdDR)=0 {
			s OrderItemStr=OEORIServiceOrdDR_"&"_StartDate_"&"_StartTime
		}
	}
	//continue:OEORIServiceOrdDR'=""
	;s OrdLinkRowId=$p(OrderItemStr,"&",4)
	;s OrdLinkRowId=$tr(OrdLinkRowId," ","")
	;不必从界面取的关联医嘱RowId   zhouzq 2010.07.21
	s OrdLinkRowId=$p($g(^OEORD(+OrItemID,"I",$p(OrItemID,"||",2),11)),"^",39)
    if (OrdLinkRowId'["||") s OrdLinkRowId=""
    ;批量补录的子医嘱可单独取消/作废
	s OEORINurseBatchAdd=$p($g(^OEORD(+OrItemID,"I",$p(OrItemID,"||",2),"DHC")),"^",60)
	if (OEORINurseBatchAdd="Y") s OrdLinkRowId=""
	s OrderBilled=$P($G(^OEORD(+OrItemID,"I",$p(OrItemID,"||",2),3)),"^",5)
	s Arcimid=$p($g(^OEORD(+OrItemID,"I",$p(OrItemID,"||",2),1)),"^",2) 
	s arctpdr=$p(^ARCIM($p(Arcimid,"||",1),$p(Arcimid,"||",2),1),"^",10)
    ;停止的医嘱子类不属于需要先停医嘱再退费的配置子类串,判断收费状态
    ;计费组配置,Return:1!例外子类串 表示需要医生停止医嘱才能退费,0 表示医生不需要停止医嘱就能退费
	if ..IsPayCanStopOrder(OrItemID)=1 {
		if HavePayOrd=""  s HavePayOrd=OrItemID
		else  s HavePayOrd=HavePayOrd_"^"_OrItemID
	}
	/*如果检查有申请单号,则不能取消*/
	s TmInfo=##class(DHCDoc.Interface.Inside.Invoke).GetTmInfoByOrderRowId(OrItemID)
	if (TmInfo'=""){
		s arcim=$P(^OEORD(+OrItemID,"I",$p(OrItemID,"||",2),1),"^",2)
	    s arcimDesc=$P($G(^ARCIM(+arcim,$P(arcim,"||",2),1)),"^",2)
		i TmInfoStr="" s TmInfoStr=arcimDesc
		e  s TmInfoStr=TmInfoStr_","_arcimDesc
	}
	;if (OrdLinkRowId'="")&&(OrdList[(OrdLinkRowId_"&")) continue
	if (StopGroupOrder=1)&&(OrdLinkRowId'="")&&(OrdList'[(OrdLinkRowId_"&")) s OrderItemStr=OrdLinkRowId_"&"_StartDate_"&"_StartTime_"&"_""
	//continue:OrdListStr[(OrderItemStr)
	if OrdListStr="" s OrdListStr=OrderItemStr
	else  s OrdListStr=OrdListStr_"^"_OrderItemStr
	if (OrdLinkRowId'="") s ^TMPUpSTDateTime(OrdLinkRowId)=OrdLinkRowId_"^"_StartDate_"^"_StartTime
	//实库库管进行了医嘱提取，需要经过高值材料库管员退货确认
	if ("N"=##class(web.DHCSTMHUI.PCHCOLLSM).GetRetFlag(OrItemID)) {
		s ErrMsg=..%GetErrCodeMsg("-100010")
		s err="-100010" //-210
	}
 }
 q:err<0 err
 //多科会诊申请产生的多条医嘱需要同时撤销/作废
 s AppendOrdListStr=##class(appcom.OEOrdItem).GetCstRelOeori(OrdListStr)
 if (AppendOrdListStr'=""){
	s OrdList=OrdList_"^"_AppendOrdListStr
 }
 ;lxz
 if HavePayOrd'="" {
	 s ErrMsg=..%GetErrCodeMsg("-100071")
	 Q "-100071" //-200
 }
 if (TmInfoStr'="") {
	 s ErrMsg=TmInfoStr_" "_..%GetErrCodeMsg("-100072")
	 Q "-100072"
	 //Q "-2000^"_TmInfoStr
 }
 s OrdList=OrdListStr
 s len=$l(OrdList,"^")
 s PilotOrdList=""
 s OPOrdAutoBilled=""	//$g(^DHCDocPilotSeting("OPOrdAutoBilled"))
 s adm=""
 s err=0
 if PWFlag="Y" s err=##Class(web.DHCOEOrdItem).PinNumberValid(UserID,PinNum)
 if (err'=0) {
	 s ErrMsg=..%GetErrCodeMsg("-100029")
	 Q "-100029" //err
 }
 TS
 for i=1:1:len
 {
	/*  
	 s oeitm=$p(OrdList,"^",i)
	 q:oeitm=""
	 s err=..discon(oeitm, UserID, PinNum)
	 i err'=0 quit  
	 s err=..Collect(oeitm)
	 */
	s TotString=$p(OrdList,"^",i)
	s oeitm=$p(TotString,"&",1)
	s STDate=$p(TotString,"&",2)
	s STTime=$p(TotString,"&",3)
	s OrdLinkID=$p(TotString,"&",4)
	if (OrdLinkID'["||") s OrdLinkID=""
	continue:oeitm=""
	s adm=$p(^OEORD(+oeitm),"^",1)
	s AdmDepDr=$p($g(^PAADM(adm)),"^",4)
	s AdmDepHospId=$p(^CTLOC(AdmDepDr),"^",22)
	s OPOrdAutoBilled=$g(^DHCDocPilotSeting(AdmDepHospId,"OPOrdAutoBilled"))
	//控制预停成组医嘱?如果主医嘱预停则子医嘱必须预停 09-03-26
	//s ^TMPUpSTDateTime(oeitm)=oeitm_"^"_STDate_"^"_STTime
	if $tr(OrdLinkID," ","")'="" {
		if ($g(STDate)="")&&($p(^TMPUpSTDateTime(OrdLinkID),"^",2)'="")  {
			s STDate=$p(^TMPUpSTDateTime(OrdLinkID),"^",2)
		}
		if ($g(STTime)="")&&($p(^TMPUpSTDateTime(OrdLinkID),"^",3)'="")  {
			s STTime=$p(^TMPUpSTDateTime(OrdLinkID),"^",3)
		}
	}
	//判断是执行过的医嘱则不可以停医嘱  郭荣勇 2008-06-30 长期医嘱不需要此控制
	s PriorityCode=""
	s PriorityDr=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",8)
	i PriorityDr'="" s PriorityCode=$p(^OECPR(PriorityDr),"^",1)
	
	if CFStopExecOrderPriorStr[("^"_PriorityDr_"^") {
		;由护士站提供接口判断
		s NurseExecStatus=##class(web.DHCNurCom).IfExecOrder(oeitm)
		if NurseExecStatus=1 {
			 s ErrMsg=..%GetErrCodeMsg("-100073")
			 s err="-100073"  //-300
			 Q
		}
	}
	//如果已经缴费的医嘱 不允许停医嘱
	s Billed=$p($G(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3)),"^",5)
	s Arcimid=$P(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",2)
	s ARCIMFreeDurgFlag=##class(web.DHCDocOrderCommon).GetARCIMFreeDurgFlag(Arcimid,AdmDepHospId)
	s CFGValue=##Class(web.PilotProject.DHCDocPPGroupSeting).GetCFGValue(AdmDepHospId,"OPOrdAutoBilled")
	s OEORIPEProjectDR=$P(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DHC"),"^",10)
	if ((Billed="P")&&(ARCIMFreeDurgFlag'="Y")){
		if ((CFGValue="Y")&&(OEORIPEProjectDR'="")){
			//满足临床试验自动结算与退费的条件可以退费
		}
		else {
			s ErrMsg=..%GetErrCodeMsg("-100046")
			s err="-100046"  //-300
			q 
		}
	}
	
	i $g(STDate)="" s STDateN=..%SysDate()
	e  s STDateN=..%ZDH(STDate) //$zdh(STDate,4)
	
	i $g(STTime)="" d  s STTimeN=..%SysTime()
	e  s STTimeN=..%ZTH(STTime)
	

	//&SQL(Select OEORI_OEORI_DR into :LinkOrderItem From SQLUser.OE_OrdItem Where OEORI_RowId=:oeitm)
	//if LinkOrderItem="" {
		s HourOrderFlag=..HourOrder(oeitm)
		i (STDateN=..%SysDate()) {				//当即停止医嘱
			s err=..discon(oeitm,UserID,.ErrMsg)
			i err'=0 quit
			s err=..Collect(oeitm)
			;将发往配液中心的前一条医嘱一起停止
			s err=..StopAppOrder(oeitm,UserID,STTimeN)
			;将提前生成医嘱停止
			s err=..StopNextOrder(oeitm,UserID,STTimeN)
			i err'=0 q
		}elseif (STDateN>+$h) {   		//预停长期医嘱
			s err=..PreStopOrder(oeitm,STDateN,STTimeN)
			;s err=..PreStopNextOrder(oeitm,STDateN,STTimeN)
		}elseif (HourOrderFlag=1){		//停小时医嘱
			s err=..PreStopOrder(oeitm,STDateN,STTimeN)
		}
	/*}else{
		i (STDateN=..%SysDate()) d //当即停止医嘱
		.s err=..discon(LinkOrderItem, UserID)
		.i err'=0 quit
		.s err=..Collect(LinkOrderItem)
		e  i (STDateN>+$h) d //预停长期医嘱
		.s err=..PreStopOrder(LinkOrderItem,STDateN,STTimeN)  
 }*/
 	if (OPOrdAutoBilled="Y"){
	 	s adm=$p(^OEORD(+oeitm),"^",1)
	 	s PAADMType=$p($g(^PAADM(adm)),"^",2)
	 	if (PAADMType="O"){
			s PPRowID=$p($G(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DHC")),"^",10)
			if (PPRowID'="") {
				i PilotOrdList="" s PilotOrdList=oeitm
				e  s PilotOrdList=PilotOrdList_"^"_oeitm
				s Sub=$O(^OEORDi(0,"OEORI",+oeitm,oeitm,0))
				While (Sub'=""){
					s PPRowID=$p($G(^OEORD(+oeitm,"I",Sub,"DHC")),"^",10)
					if (PPRowID'="") {
						s SubRowId=+oeitm_"||"_Sub
						i PilotOrdList="" s PilotOrdList=SubRowId
						else  if (("^"_PilotOrdList_"^")'[("^"_SubRowId_"^")) s PilotOrdList=PilotOrdList_"^"_SubRowId
					}
					s Sub=$O(^OEORDi(0,"OEORI",+oeitm,oeitm,Sub))
				}
			}
		}
	}
	//医嘱闭环状态
	s StatusCode="STOP"
	s ItmCat=$p($g(^ARCIM($p(Arcimid,"||",1),$p(Arcimid,"||",2),1)),"^",10)
	s OrdType=$p($g(^ARC("IC",ItmCat)),"^",7)	;ARCIC_OrderType	
	if (OrdType="R" ){
		d ##class(DHCDoc.Interface.Inside.Invoke).UpdExaReqItmStatus(StatusCode,"",UserID,oeitm,LocID)
		}
	if (PAADMType="E"){
		//撤销医疗结算
		s err=##class(appcom.OEOrdItem).CancelDoctorDischarge(OrItemID,UserID)
		if +err'=0 {
		}
	}
 }
 k ^TMPUpSTDateTime
 if err'=0{
	TRO
	Q err
 }
 if (PilotOrdList'=""){
	 s rtn=##class(web.DHCBillInterface).IsPilotOPRefundForOrder(PilotOrdList)
	 s err=$p(rtn,"@",1)
	 i err=-104 s err=0	//若没有维护相关折扣，让其正常撤销
	 if err'=0{
		TRO
		s ErrMsg=..%GetErrCodeMsg("-100074")_err
		Q err
	 }
 }
 s rtn=##Class(web.UDHCJFBILL).BILLN(adm,UserID,"")
 s OrdList=$replace(OrdList,"&","!")
 //s rtn=##Class(web.DHCAntCombined).StopAntOrder(adm,OrdList)
 s rtn=##Class(DHCAnt.KSS.Combined).StopAntOrder(adm,OrdList)
 /*集成平台接口
 Set OrdList=##class(DHCIntergration.Common.Method.Base).ReplaceStr(OrdList,"&&","^")
 d ##class(web.DHCBL.CI.ServiceBuilder).OPOEORIService("OPCRefund",OrdList)
 */
 TC
 q err
}

ClassMethod UpSTDateTime(oeitm As %String, STDate As %String, STTime As %String) As %String
{
	n (oeitm, STDate, STTime)
	q:$g(oeitm)="" 0
	q:($g(STDate)="")&($g(STTime)="") 0	
	
	i $g(STDate)="" s STDate=..%SysDate()
	e  s STDate=$zdh(STDate,4)
	
	i $g(STTime)="" s STTime=..%SysTime()
	e  s STTime=..%ZTH(STTime)
	
	s SQLCODESum=0
	
	TS
	&sql(update SQLUser.OE_orditem set OEORI_Xdate=:STDate,OEORI_Xtime=:STTime 	where OEORI_rowid=:oeitm)
	s SQLCODESum=SQLCODESum+SQLCODE
	
	s Sub=$O(^OEORDi(0,"OEORI",+oeitm,oeitm,0))
	While (Sub'="") {
		s SubRowId=+oeitm_"||"_Sub
		
        &sql(update SQLUser.OE_orditem set OEORI_Xdate=:STDate,OEORI_Xtime=:STTime 	where OEORI_rowid=:SubRowId)
        s SQLCODESum=SQLCODESum+SQLCODE
        if SQLCODESum quit

		s Sub=$O(^OEORDi(0,"OEORI",+oeitm,oeitm,Sub))
	}
	if SQLCODESum {
		TRO
	}else{
		TC
	}
	
	q SQLCODESum
}

ClassMethod discon(oeitm, user, ByRef ErrMsg As %String = "")
{
	n (oeitm,user,ErrMsg)
	s oeitm=$p(oeitm,"||",1,2)
	s stat=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",13)
	i stat s stat=$p($g(^OEC("OSTAT",stat)),"^")
	Q:stat="D" 0					
	if (stat'="V")&(stat'="I") {
		s ErrMsg=##Class(web.DHCDocInPatPortalCommon).GetMsg("-100045")
		Q "-100045"      ;-5 原医嘱不是核实状态
	}
	&SQL(Select OEORI_OEORD_Parref->OEORD_Adm_DR->PAADM_Type Into :AdmType From SQLUser.OE_OrdItem Where OEORI_RowId=:oeitm)
	s oebilled=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),3)),"^",5)
	i oebilled s oebilled=$p(oebilled,$c(1),1)
	if (oebilled="P")&&(AdmType="InPatient") {
		Q -2   	;住院当计费状态为PAID时?不能停医嘱
	}
	if (+..IsOrdExec(oeitm)>0) {
		s ErrMsg=..%GetErrCodeMsg("-100071")
		//##Class(web.DHCDocInPatPortalCommon).GetMsg("-100071")
		Q "-100071" //-200
	}
	s ret=##Class(web.DHCOEOrdItem).Stop(oeitm,user,1,"",.ErrMsg)
	q:ret -6
	Q ret
}

ClassMethod getlocEx(oew, chl, NowAdm) As %String
{
	n (oew,chl,NowAdm,WardNurse,doctor,nurse)
	//原来是处理住院信息项目上特殊使用
	s AddLoc=$p($g(^OEORD(oew,"I",chl,7)),"^",2)
	s DocLoc=""
	i AddLoc'="" s DocLoc=$P(^CTLOC(AddLoc),"^",2)
	if DocLoc["-" s DocLoc=$P(DocLoc,"-",2)
	q $G(DocLoc)_"^"_$G(flag)_"^"_""_"^"_""
	s zycat=0
	s OeorIDr=oew_"||"_chl
	&sql(select PAADM_DepCode_DR,PAADM_CurrentWard_DR into :AdmLoc,:AdmWard from SQLUser.Pa_Adm where paadm_rowid=:NowAdm)
	i AdmWard'="" s WardNurse=$p(^PAWARD(AdmWard),"^",5)
	i $d(^OEORD(oew,"I",chl,1))  d
	.s DoctorDr=$P($G(^OEORD(oew,"I",chl,1)),"^",11)
	s doctor=""
	s nurse=""
	s DocLoc=""
	i $g(DoctorDr)'="" d
	.f  s DocLoc=$O(^RB("RES",0,"CTPCP",DoctorDr,DocLoc)) q:'$O(^RB("RES",0,"CTPCP",DoctorDr,DocLoc))  d
	..s doctor=DocLoc
	..q:AdmLoc=DocLoc
	i $g(doctor)'="" s DocLoc=doctor
	i $g(DoctorDr)="" s DocLoc=$g(WardNurse)
	s flag="N"
	
	q $G(DocLoc)_"^"_$G(flag)_"^"_""_"^"_""
}

ClassMethod getprice(INCITM, STTDATE)
{
	n (INCITM,STTDATE)
	;-------calculate the retail price-------------------
	s STTDATE=STTDATE+1
	s excudate=$o(^INASP(0,"INCI",INCITM,STTDATE),-1)
	q:excudate="" 0
	s adjrow=$o(^INASP(0,"INCI",INCITM,excudate,""))
	s PRICE=$p(^INASP(adjrow),"^",7)
	;----------------------------------------------------------          
	q PRICE
}

ClassMethod usersecurity(user, Arcimid)
{
	i $g(user)="" q -100
	s Arcimid=$p(Arcimid,"||")
	s ssgroup=%session.Get("LOGON.GROUPID")
	;s ssgroup=$p(^SSU("SSUSR",user),"^",5)
	s ordcat=$p(^ARC("IC",$p(^ARCIM(Arcimid,1,1),"^",10)),"^",8)
	&sql(select * from SQLUser.SS_GroupOrderCategory where SSORD_ParRef=:ssgroup and SSORD_OrdCat_DR=:ordcat)
	q SQLCODE
}

/// Creator:      徐鹏
/// CreatDate:    2010.06.24
/// Description:  将医嘱本日后已经提前产生的医嘱停止
/// Table:        INC_ItmLoc
/// Input:        oeitm:医嘱RowId   UserID:用户ID   STTimeN:开始时间
/// Return:      
/// Others:       w ##class(web.UDHCStopOrderLook).StopNextOrder("747886||227","1312",40562) 
ClassMethod StopNextOrder(oeitm As %String, UserID As %String, STTimeN As %String)
{
	s err=0

	s PriorityDR=$p(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1),"^",8)
	s PriorityCode=""
	if PriorityDR'="" s PriorityCode=$P($g(^OECPR(PriorityDR)),"^",1)
	if ((PriorityCode="S")||(PriorityCode="OMST")) {
	
		s CurrentOrderFillerNoStr=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),9)),"^",12)
		s CurrentOrderFillerNo=$p(CurrentOrderFillerNoStr,"!!",1)
		s OrderRowid=+oeitm
		s LastDate=$o(^OEORDi(0,"StDtTm1",OrderRowid,""),-1)
		f SttDate=..%SysDate()+1:1:LastDate q:err'=0  d
		.s ChildSub=0
		.f  s ChildSub=$o(^OEORDi(0,"StDt",SttDate,OrderRowid,ChildSub)) q:((ChildSub="")||(err'=0))  d
		..s OrderFillerNoStr=$p($g(^OEORD(OrderRowid,"I",ChildSub,9)),"^",12)
		..q:OrderFillerNoStr=""
		..s OrderFillerNo=$p(OrderFillerNoStr,"!!",1)
		..q:(OrderFillerNo'=oeitm)&(OrderFillerNo'=CurrentOrderFillerNo)
		..s NextOrder=OrderRowid_"||"_ChildSub
		..s err=..discon(NextOrder,UserID)
		..q:err'=0
		..s err=..Collect(NextOrder) //里面包括执行自动的没有发药的药品退药
	}
	q err
	
   /*	
  i (STDateN=..%SysDate()) {   //当即停止医嘱
   s itmsource=$p(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),9),"^",12)
   s PriorityDR=$p(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1),"^",8)
   s PriorityCode=""
   if PriorityDR'="" {
    s PriorityCode=$P($g(^OECPR(PriorityDR)),"^",1)
   }
   if ((PriorityCode="S")||(PriorityCode="OMST")) {
    if itmsource'="" s Firstoeitm=$P(itmsource,"!!",1)
    else  s Firstoeitm=oeitm
    s substopoeitm=+$p(oeitm,"||",2)-1
    for {
     s substopoeitm=$o(^OEORD(+oeitm,"I",substopoeitm)) q:substopoeitm=""
     s Sinceitmsource=$p($g(^OEORD(+oeitm,"I",substopoeitm,9)),"^",12)
     s FirstSinceitmsource=$P(Sinceitmsource,"!!",1)
     s CheckSelfID=+oeitm_"||"_substopoeitm
     if (FirstSinceitmsource'=Firstoeitm)&&(CheckSelfID'=Firstoeitm) continue
     s stopoeitm=+oeitm_"||"_substopoeitm
     s stoperr=..discon(stopoeitm,UserID)
     i stoperr'=0 quit
     s stoperr=..Collect(stopoeitm)
    }
   }else {
    s stoperr=..discon(oeitm,UserID)
    i stoperr'=0 quit
    s stoperr=..Collect(oeitm)
   }
  }elseif (STDateN>+$h) {   //预停长期医嘱
   s stoperr=..PreStopOrder(oeitm,STDateN,STTimeN)
  }
  */
}

/// Creator:      徐鹏
/// CreatDate:    2010.06.24
/// Description:  将医嘱预停时间后已经提前产生的医嘱停止
/// Table:        INC_ItmLoc
/// Input:        oeitm:医嘱RowId   UserID:用户ID   STTimeN:开始时间
/// Return:      
/// Others:       w ##class(web.UDHCStopOrderLook).PreStopNextOrder("747886||251","1312",40562)
ClassMethod PreStopNextOrder(oeitm As %String, STDateN As %String, STTimeN As %String)
{
	s err=0
	s CurrentOrderFillerNoStr=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),9)),"^",12)
	s CurrentOrderFillerNo=$p(CurrentOrderFillerNoStr,"!!",1)
	s OrderRowid=+oeitm
	s LastDate=$o(^OEORDi(0,"StDtTm1",OrderRowid,""),-1)
	f SttDate=..%SysDate():1:LastDate q:err'=0  d
	.s ChildSub=0
	.f  s ChildSub=$o(^OEORDi(0,"StDt",SttDate,OrderRowid,ChildSub)) q:((ChildSub="")||(err'=0))  d
	..s OrderFillerNoStr=$p($g(^OEORD(OrderRowid,"I",ChildSub,9)),"^",12)
	..q:OrderFillerNoStr=""
	..s OrderFillerNo=$p(OrderFillerNoStr,"!!",1)
	..q:(OrderFillerNo'=oeitm)&(OrderFillerNo'=CurrentOrderFillerNo)
	..s NextOrder=OrderRowid_"||"_ChildSub
	..s SQLCODE=..PreStopOrder(NextOrder, STDateN, STTimeN)
	..i SQLCODE'=0  s err=SQLCODE
	..i (SttDate>(STDateN-1))  q:err'=0  d
	...s err=..discon(NextOrder,UserID,STTimeN)
	...q:err'=0
	...s err=..Collect(NextOrder) //里面包括执行自动的没有发药的药品退药
	..q:err'=0
	q err
}

/// 用户的医护人员类别,医生/护士
/// w ##class(web.UDHCStopOrderLook).GetCareProvType(2610)
ClassMethod GetCareProvType(UserID)
{
	q:UserID="" ""
	s DoctorDR=$P(^SSU("SSUSR",UserID),"^",14)
	q:DoctorDR="" ""
	s CareProvTypeDR=$p($g(^CTPCP(DoctorDR,1)),"^",4)
	q:CareProvTypeDR="" ""
	s InternalType=$p($g(^CT("CPT",CareProvTypeDR)),"^",4)
	q InternalType
}

/// 按医嘱,撤销一组医嘱的执行记录
/// w ##class(web.UDHCStopOrderLook).StopOrdersBySpecOrder(210,2610,"","")
ClassMethod StopOrdersBySpecOrder(OeoriRowid, UserID, STDateN As %String = "", STTimeN As %String = "", Loc As %String = "", IsBillN As %String = "Y")
{
	s OrderRowid=$p(OeoriRowid,"||",1)
	s AutoOeoriSub=$p(OeoriRowid,"||",2)
	s LocStr=Loc
	if (Loc'=""){
		s LinkLoc=##Class(web.DHCDocOrderCommon).GetLocLinkLocation(Loc)
		if (LinkLoc'=""){
			s LocStr=LocStr_"^"_LinkLoc
		}
	}
	i STDateN="" s STDateN=..%SysDate()+1
	i STTimeN="" s STTimeN=..%SysTime()

	s XExecDateStr=""
	;出院\转科医嘱自动停止当日0点之后的所有执行记录
	s DealExecStartOnZeroBySpecOrder=##class(web.DHCDocConfig).GetDHCCTLOCFieldValue(Loc,31)
	if (DealExecStartOnZeroBySpecOrder=1){
		s XExecDateStr=..%ZD(STDateN)_" "_..%ZT(0)
	}
	s SSUSRHospitalDR=$p($g(^SSU("SSUSR",UserID)),"^",98)
	//停医嘱强制停止执行的子类
	s StopAllExecItemCat=..%GetConfig("StopAllExecItemCat",SSUSRHospitalDR) //$g(^DHCDocConfig("StopAllExecItemCat"))
	s StopAllExecItemCat="^"_StopAllExecItemCat_"^"
	s err=0
		
	s PriorityDR=0
	f  s PriorityDR=$o(^OEORDi(0,"Priority",OrderRowid,PriorityDR)) q:PriorityDR=""  d
	.s PriorityCode=""
	.i PriorityDR'="" s PriorityCode=$P(^OECPR(PriorityDR),"^",1)
	.q:##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)'=1
	.s ChildSub=0
	.f  s ChildSub=$o(^OEORDi(0,"Priority",OrderRowid,PriorityDR,ChildSub)) q:((ChildSub>=AutoOeoriSub)||(ChildSub="")||(err'=0))  d
	..s OrderStatus=$p(^OEC("OSTAT",$p(^OEORD(OrderRowid,"I",ChildSub,1),"^",13)),"^",1)   
	..Q:($g(OrderStatus)="I")||($g(OrderStatus)="U")
	..//当天执行记录强制停止子类
	..s itemrowid=$p($g(^OEORD(+OrderRowid,"I",ChildSub,1)),"^",2)
	..s ItemCatRowId=+$p($g(^ARCIM(+$g(itemrowid),1,1)),"^",10)
	..s StopAllExecFlag=0
	..i StopAllExecItemCat[("^"_ItemCatRowId_"^") s StopAllExecFlag=1
	..//如果强制停止子类是停止状态的，且无需要处理的执行记录，则不进行执行记录处理
	..if ((StopAllExecFlag=1)&&(OrderStatus="D")) d
	...;s OrdSttDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",9)
	...if (##class(web.DHCOEOrdItem).CheckOrdIsExecByDateT(OrderRowid_"||"_ChildSub,STDateN)'=1) s StopAllExecFlag=0
	
	..//已停医嘱若停医嘱时间小于STDateN,需处理.否则不处理
	..s DealWithStoppedOrdFlag=0
	..s OEORIXDate=$p($g(^OEORD(+OrderRowid,"I",ChildSub,3)),"^",34)
	..s OEORIXTime=$p($g(^OEORD(+OrderRowid,"I",ChildSub,2)),"^",15)
	..if (OrderStatus="D")&&((OEORIXDate>STDateN)||((OEORIXDate=STDateN)&&(OEORIXTime>STTimeN))) s DealWithStoppedOrdFlag=1
	..Q:($g(OrderStatus)="D")&&(DealWithStoppedOrdFlag'=1)
	..//Q:($g(OrderStatus)="D")&&(StopAllExecFlag'=1)
	..//Q:(OrderStatus'="V")
	..s groupid=$p($g(^OEORD(+OrderRowid,"I",ChildSub,11)),"^",39)
	..Q:groupid'=""
	..s arcim=$P(^OEORD(OrderRowid,"I",ChildSub,1),"^",2)
	..s ARCIMExtInfo=##class(DHCDoc.DHCDocConfig.ARCIMExt).getARCIMConfig(arcim)
	..s arcimnotstop=$P(ARCIMExtInfo,"^",2) ;对标记的为非停止的医嘱不进行处理
	..Q:arcimnotstop=1
	..s OEORIRowid=OrderRowid_"||"_ChildSub
	..s AddUserDR=$P($G(^OEORD(OrderRowid,"I",ChildSub,7)),"^",1)
  	..s AddInternalType=..GetCareProvType(AddUserDR)
  	..s StopInternalType=..GetCareProvType(UserID)
  	..s AddUserDeptDr=$P($G(^OEORD(OrderRowid,"I",ChildSub,7)),"^",2)
  	..q:(LocStr'="")&&(("^"_LocStr_"^")'[("^"_AddUserDeptDr_"^"))
  	..s OEORIEndDate=$P($G(^OEORD(OrderRowid,"I",ChildSub,9)),"^",9)
  	..s OEORIEndTime=$P($G(^OEORD(OrderRowid,"I",ChildSub,9)),"^",10)
  	..//预停医嘱如果预停时间小于停止时间,则不做处理
  	..Q:(OEORIEndDate'="")&&(OEORIEndTime'="")&&((OEORIEndDate<STDateN)||((OEORIEndDate=STDateN)&&(OEORIEndTime<STTimeN)))
  	..//q:StopInternalType'=AddInternalType
	..//s ret=##Class(web.DHCOEOrdItem).Stop(OEORIRowid,UserID,STTimeN)
	..s ExpStr=DealWithStoppedOrdFlag_"^^"_XExecDateStr
	..s ret=##class(appcom.OEOrdItem).Stop(OEORIRowid,UserID,STDateN,STTimeN,StopAllExecFlag,IsBillN,ExpStr)
	..i ret=0 d //被全排斥停止的医嘱需要加标志,供医嘱浏览使用
	...s $P(^OEORD(OrderRowid,"I",ChildSub,"DHC"),"^",61)=OeoriRowid
	q err
}

/// 停医嘱是否停止子医嘱
ClassMethod GetStopGroupOrder(UserID As %Library.String)
{
	s StopGroupOrder=..%GetConfig("StopGroupOrder")
	i UserID'="" {
		s DoctorType=""
		s UserDocId=$p($g(^SSU("SSUSR",UserID)),"^",14)
		i UserDocId'="" s DoctorType=##class(web.SSUser).GetDefaultCareProviderType(UserID)
		i DoctorType="DOCTOR" s StopGroupOrder=1
	}
	Q StopGroupOrder
}

/// 获取关联的绑定费用总入口
ClassMethod GetAppenOrdInfo(OrdList) As %String
{
	n (OrdList)
	q:(OrdList="") OrdList
	s AppendOrdListStr=##Class(web.UDHCStopOrderLook).GetSerialNumAppenOrdInfo(OrdList)
	if (AppendOrdListStr'=""){
		s OrdList=OrdList_"^"_AppendOrdListStr
	}
	s AppendOrdListStr=##Class(web.UDHCStopOrderLook).GetLabAppenOrdInfo(OrdList)
	if (AppendOrdListStr'=""){
		s OrdList=OrdList_"^"_AppendOrdListStr
	}
	q OrdList
}

/// 获取通过绑定来源关联的绑定费用信息
/// w ##Class(web.UDHCStopOrderLook).GetSerialNumAppenOrdInfo("797||23!01/08/2022!16:17:06")
ClassMethod GetSerialNumAppenOrdInfo(OrdList As %String) As %String
{
	n (OrdList)
	s ^TEMPtan("GetSerialNumAppenOrdInfo")=OrdList
	s OrdListStr=""
	s Ord=+OrdList
	s EpisodeID=$P(^OEORD(Ord),"^",1)
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s Seq="!"
	//^OEORDi(0,"IndexSerialNum",{OEORI_SerialNum},{OEORI_OEORD_ParRef},{OEORI_Childsub})
	// s BindSourceSerialNumStr=$P($G(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",76)
	// s SerialNum=$p($g(^OEORD(+OrdId1,"I",OrdId2,"DHC")),"^",75)
	s len=$l(OrdList,"^")
	for i=1:1:len {
		s TotString=$p(OrdList,"^",i)
		s oeitm=$p(TotString,Seq,1)
		continue:""=$g(^OEORD(+oeitm,"I",$P(oeitm,"||",2),1))
		s PriorityDR = $p($g(^OEORD(+oeitm,"I",$P(oeitm,"||",2),1)),"^",8)
		s StDate=$p($g(^OEORD(+oeitm,"I",$P(oeitm,"||",2),1)),"^",9)
		s SerialNum=$p($g(^OEORD(+oeitm,"I",$P(oeitm,"||",2),"DHC")),"^",75)
		continue:(SerialNum="")
		s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
		if ISLongOrderPrior {
			s StopDate=$p(TotString,Seq,2)
			s StopDate=$s(StopDate="":..%SysDate(),1:$zdh(StopDate,##class(websys.Conversions).DateFormat()))
			s StopTime=$p(TotString,Seq,3)
			
			s StopTime=$s(StopTime="":..%SysTime(),1:..%ZTH(StopTime))
		}else{
			s StopDate=..%SysDate()
			s StopTime=..%SysTime()
		}
		#; if ('$D(^OEORDi(0,"OrdItem",+oeitm,$P(oeitm,"||",2),StopDate))){
		#; 	s myStopDate=$O(^OEORDi(0,"OrdItem",+oeitm,$P(oeitm,"||",2),StopDate))
		#; 	if (myStopDate=""){
		#; 		s myStopDate=$O(^OEORDi(0,"OrdItem",+oeitm,$P(oeitm,"||",2),StopDate),-1)
		#; 	}
		#; 	if (myStopDate'=""){
		#; 		s StopDate=myStopDate
		#; 	}
		#; }
		
		s SerialNumArr("StDate",StDate,SerialNum)=oeitm_"!"_StopDate_"!"_StopTime
		s SerialNumArr("StopDate",StopDate,SerialNum)=oeitm_"!"_StopDate_"!"_StopTime
		s SerialNumArr("SerialNum",SerialNum)=oeitm_"!"_StopDate_"!"_StopTime
	}
	
	if ('$D(SerialNumArr)){
		return ""
	}
	/// 1、找到所有符合停止日期条件且包含了需要停止医嘱流水号的绑定医嘱列表
	///	^OEORDi(0,"Date",{OE_Order.OEORD_RowId},{OEORE_ExStDate},+{OEORE_ExStTime},{OE_OrdItem.OEORI_Childsub},{OEORE_Childsub})
	/// ^OEORDi(0,"ARCIM",{OE_Order.OEORD_RowId},{OEORI_ItmMast_DR},{OEORI_SttDat},{OEORI_Childsub})
	/// 绑定时按照开始时间进行的绑定，这里也可以使用同样的规则进行绑定撤销
	/// ^OEORDi(0,"StDtTm1",{OE_Order.OEORD_RowId},{OEORI_SttDat},+{OEORI_SttTim},{OEORI_Childsub})
	k BindSourceOrdArr,LoopOrdArr
	s LoopStDate=""
	for {
		s LoopStDate=$O(SerialNumArr("StDate",LoopStDate))
		q:(LoopStDate="")
		s LoopStTime=""
		for {
			s LoopStTime=$O(^OEORDi(0,"StDtTm1",Ord,LoopStDate,LoopStTime))
			q:(LoopStTime="")
			s Sub=""
			for {
				s Sub=$O(^OEORDi(0,"StDtTm1",Ord,LoopStDate,LoopStTime,Sub))
				q:(Sub="")
				
				d BulidBindSourceOrd
			}
		}
	}
	/// 2、验证绑定医嘱列表是否符合合并停止条件
	s BindItemID=""
	for {
		s BindItemID=$O(BindSourceOrdArr(BindItemID))
		q:(BindItemID="")
		s Sub=$P(BindItemID,"||",2)
		s StopDate=""	//..%SysDate()	//$p($g(^OEORD(+oeitm,"I",$P(oeitm,"||",2),1)),"^",9)	//SttDate
		s StopTime=""	//..%SysTime() //$p($g(^OEORD(+oeitm,"I",$P(oeitm,"||",2),1)),"^",9)	//SttTime
		s BindSourceStr=$P($G(^OEORD(Ord,"I",Sub,"DHC")),"^",76)
		s NeedStop=1
		for i=1:1:$L(BindSourceStr,"@") {
			s OneBindSource=$P(BindSourceStr,"@",i)
			continue:(OneBindSource="")
			if '$D(^OEORDi(0,"IndexSerialNum",OneBindSource)){
				continue
			}
			s Sub=$O(^OEORDi(0,"IndexSerialNum",OneBindSource,Ord,0))
			s StatusID = $p(^OEORD(Ord,"I",Sub,1),"^",13) 
			s StatusCode="V"
			if (StatusID'=""){
				s StatusCode=$p(^OEC("OSTAT",StatusID),"^",1)
			}
			if ("UCD"'[StatusCode){
				if ('$D(SerialNumArr("SerialNum",OneBindSource))){
					s NeedStop=0
					quit
				}
				s SerialXDate=$p(SerialNumArr("SerialNum",OneBindSource),"!",2)
				s SerialXTime=$p(SerialNumArr("SerialNum",OneBindSource),"!",3)
			}else{
				s SerialXDate=$p(^OEORD(Ord,"I",Sub,3),"^",34)
				s SerialXTime=$p(^OEORD(Ord,"I",Sub,2),"^",15)
			}
			if (StopDate=""){
				s StopDate=SerialXDate,StopTime=SerialXTime
			}
			
			if (SerialXDate>StopDate)||((SerialXDate=StopDate)&&(SerialXTime>StopTime)){
				s StopDate=SerialXDate,StopTime=SerialXTime
			}
			
			
		}
		if (NeedStop=0){
			continue
		}
		if (OrdListStr=""){
			s OrdListStr=BindItemID_"!"_..%ZD(StopDate)_"!"_..%ZT(StopTime)
		}else{
			s OrdListStr=OrdListStr_"^"_BindItemID_"!"_..%ZD(StopDate)_"!"_..%ZT(StopTime)
		}

	}
	
	Return OrdListStr

BulidBindSourceOrd
	if ($D(LoopOrdArr(Sub))){q}
	s LoopOrdArr(Sub)=""
	s StatusID = $p(^OEORD(Ord,"I",Sub,1),"^",13) 
	s PriorityDR = $p($g(^OEORD(Ord,"I",Sub,1)),"^",8)
	s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
	if (StatusID'=""){
		s StatusCode=$p(^OEC("OSTAT",StatusID),"^",1)
		q:("UCD"[StatusCode)
	}
	
	#; s ExeID=$O(^OEORDi(0,"Date",Ord,StopDate,ExStTime,Sub,0))
	#; s ExecStateDR= $p(^OEORD(Ord,"I",Sub,"X",ExeID),"^",16)
	;已经收费的不算在规则内
	s OrdBilled=$P($G(^OEORD(+Ord,"I",Sub,3)),"^",5)
	q:OrdBilled="P"
	s OrderMasterRowId=$P($G(^OEORD(Ord,"I",Sub,11)),"^",39)
	q:OrderMasterRowId'=""
	s BindSource=$p($g(^OEORD(Ord,"I",Sub,"DHC")),"^",41)
	q:(BindSource="")
	s BindSourceStr=$P($G(^OEORD(Ord,"I",Sub,"DHC")),"^",76)
	q:(BindSourceStr="")
	s FindBindSourceFlag=0
	for i=1:1:$L(BindSourceStr,"@") {
		s OneBindSource=$P(BindSourceStr,"@",i)
		continue:(OneBindSource="")
		continue:'$D(^OEORDi(0,"IndexSerialNum",OneBindSource))
		if ($D(SerialNumArr("SerialNum",OneBindSource))){
			s FindBindSourceFlag=1
			quit
		}
	}
	q:(FindBindSourceFlag=0)
	s BindSourceOrdArr(Ord_"||"_Sub)=""
	q
}

/// w ##Class(web.UDHCStopOrderLook).GetLabAppenOrdInfo("3523||9^3523||10")
ClassMethod GetLabAppenOrdInfo(OrdList As %String) As %String
{
	///tanjishan 停止检验时，连带检验带出来的费用一并停止掉
	//先预取出所有的带出来的费用
	n (OrdList)
	s OrdListStr=""
	s Ord=+OrdList
	s EpisodeID=$P(^OEORD(Ord),"^",1)
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s Seq="!"
	
	s len=$l(OrdList,"^")
	k LLabEpisodeNoArr
	s LabEpisodeNoStr=""
	s NeedUpdateLabNoStr=""
	for i=1:1:len {
		s TotString=$p(OrdList,"^",i)
		s oeitm=$p(TotString,Seq,1)
		s StartDate=$p(TotString,Seq,2)
		s StartTime=$p(TotString,Seq,3)
		///格式化数据，防止OrdList只传进来了id串
		s $p(OrdList,"^",i)=oeitm_Seq_StartDate_Seq_StartTime
		s LabEpisodeNo=$P($G(^OEORD(+oeitm,"I",$P(oeitm,"||",2),3)),"^",20)
		continue:LabEpisodeNo=""
		if (LabEpisodeNoStr="") s LabEpisodeNoStr=LabEpisodeNo_Seq_StartDate_Seq_StartTime_Seq_oeitm
		else  s LabEpisodeNoStr=LabEpisodeNoStr_"^"_LabEpisodeNo_Seq_StartDate_Seq_StartTime_Seq_oeitm
	}
	 
	if (LabEpisodeNoStr=""){
		q OrdListStr
	}
	s len=$l(LabEpisodeNoStr,"^")
	for loop=1:1:2{
		s Sub=0
		for {
			s Sub=$O(^OEORD(Ord,"I",Sub))
			q:Sub=""
			s LLabEpisodeNoStr=$P($G(^OEORD(Ord,"I",Sub,"DHC")),"^",22)
			s LLabEpisodeNo=$P($G(^OEORD(Ord,"I",Sub,3)),"^",20)
			s ArcimDr=$P($G(^OEORD(Ord,"I",Sub,1)),"^",2)
			continue:ArcimDr=""
			s StatCode=""
			s OrdStat=$P($G(^OEORD(+Ord,"I",Sub,1)),"^",13) 
			i OrdStat'="" s StatCode=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
			Continue:(StatCode'="V")&&(StatCode'="E")
			s ItemCatRowid=$p($g(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1)),"^",10)
			s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
			if (loop=1){
				//第一层循环只遍历检验类医嘱
				continue:(LLabEpisodeNo="")
				continue:(OrderType'="L")
				if ((OrdList_Seq)'[(Ord_"||"_Sub_Seq)){
					///找到所有不需要停止的检验医嘱
					s LLabEpisodeNoArr(LLabEpisodeNo)=""
				}
				continue
			}
			;已经收费的不算在规则内
			s OrdBilled=$P($G(^OEORD(+Ord,"I",Sub,3)),"^",5)
			continue:OrdBilled="P"
			//第二层循环只遍历因检验带出的费用
			continue:(LLabEpisodeNoStr="")
			continue:(OrderType="L")
			s OrderMasterRowId=$P($G(^OEORD(Ord,"I",Sub,11)),"^",39)
			continue:OrderMasterRowId'=""
			/*
			LLabEpisodeNoStr为当前遍历的材料类费用关联的条码号
			*/
			s FindSameLabNo=0
			for i=1:1:$length(LLabEpisodeNoStr,$C(1)){
				s LLabEpisodeNo=$P(LLabEpisodeNoStr,$C(1),i)
				if $D(LLabEpisodeNoArr(LLabEpisodeNo)){
					//如果关联的检验还有存在有效医嘱
					//则这条材料不需要停止
					s FindSameLabNo=1
				}
			}
			continue:(FindSameLabNo=1)
			if OrdListStr="" s OrdListStr=Ord_"||"_Sub_Seq_StartDate_Seq_StartTime_Seq
			else  s OrdListStr=OrdListStr_"^"_Ord_"||"_Sub_Seq_StartDate_Seq_StartTime_Seq
		}
	}
	
	q OrdListStr
}

/// w ##Class(web.UDHCStopOrderLook).UpdateLabNoStr("647||5")
ClassMethod UpdateLabNoStr(NeedUpdateLabNoStr As %String) As %String
{
	s Ord=+NeedUpdateLabNoStr
	q:Ord=0 0
	s EpisodeID=$P(^OEORD(Ord),"^",1)
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	if (AdmType="I"){
		s Seq="&"
	}else{
		s Seq="!"
	}
	///tanjishan 2016-02-29
	s len=$length(NeedUpdateLabNoStr,"^")
	for i=1:1:len
	{
		//s NeedUpdateLabNoStr=Ord_"||"_Sub_"&"_LabLinkOrdID_"&"_NewLabEpisodeNoStr 
		s OneNeedUpdateLabNoStr=$P(NeedUpdateLabNoStr,"^",i)
		s LinkFeeOrd=$P(OneNeedUpdateLabNoStr,Seq,1)
		s MainOrd=$P(OneNeedUpdateLabNoStr,Seq,2)
		s NewLabEpisodeNoStr=$P(OneNeedUpdateLabNoStr,Seq,3)
		continue:(LinkFeeOrd="")||(MainOrd="")||(NewLabEpisodeNoStr="")
		s StatCode=""
		s OrdStat=$P($G(^OEORD(+MainOrd,"I",$p(MainOrd,"||",2),1)),"^",13) 
		i OrdStat'="" s StatCode=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
		Continue:StatCode'="D"
		s $p(^OEORD(+LinkFeeOrd,"I",$p(LinkFeeOrd,"||",2),"DHC"),"^",22)=NewLabEpisodeNoStr
	}
	////tanjishan 2016-02-29 end
	q 0
}

}

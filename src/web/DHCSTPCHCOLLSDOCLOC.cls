Include webimport

IncludeGenerator webimport

/// 2007-04-24
Class web.DHCSTPCHCOLLSDOCLOC Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 667;

/// Creator:zhangdongmei
/// CreatDate:2012-02-28
/// Descriprtion:整理医生科室待发药信息,直接从配药表检索数据
/// Table:DHC_oedispensing , OE_OrdItem
/// Input:发药科室id,开始日期,结束日期,发药人id, 
/// 发药类别,医生科室id,登记号
/// Output:npid 进程号
/// Others:save the data into temporary global
ClassMethod CollectDisp(LocId As %String, DateFrom As %String, DateTo As %String, User As %String, DispCat As %String, DoctorLoc As %String, RegNo As %String, incidr As %String) As %Integer
{
 ;save the data into temporary global
 n (LocId,DateFrom,DateTo,User,DispCat,DoctorLoc,RegNo,incidr,%session)
 s npid=##class(web.DHCSTPCHCOLLS).NewPid() ; 
 s HospID=$p($g(^CTLOC(LocId)),"^",22)
 s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)    //进价规则
 k ^TMP("dhcpha",npid,"D","DispCat")
 s i=0
 f Date=DateFrom:1:DateTo d
 .s WardLoc="" 
 .f  s WardLoc=$o(^DHCOEDISQTY(0,"REC",LocId,Date,"TC",WardLoc)) q:WardLoc=""  d
 ..s num=1
 ..f  s DspCatCode=$p(DispCat,"^",num) q:DspCatCode=""  d
 ...s num=num+1
 ...s Cat=DspCatCode
 ...s DspCatCode=$$ALPHAUP^SSUTIL4(DspCatCode)
 ...s DspId=0
 ...f  s DspId=$o(^DHCOEDISQTY(0,"REC",LocId,Date,"TC",WardLoc,DspCatCode,DspId)) q:DspId=""  d
 ....s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
 ....s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针
 ....s AdmDr=$p(^DHCOEDISQTY(DspId),"^",26)
 ....q:AdmDr=""
 ....s AdmWard=$p(^PAADM(AdmDr),"^",70)         ;病人当前病房
 ....s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
 ....i AdmType="E" s emPayStayFlag=##class(web.DHCSTCOMMONSRV).GetPayStayStatus(OrdItmRowid)
 ....e  s emPayStayFlag=""
 ....q:(AdmType'="I")&&(AdmType'="E")           ;过滤非住院病人与急诊留观
 ....q:(AdmType="E")&&(emPayStayFlag'="Y")    
 ....s Ord=+OrdExeRowid
 ....s Chl=$p(OrdExeRowid,"||",2)
 ....s OreChl=$p(OrdExeRowid,"||",3)
 ....q:Ord=""
 ....q:Chl=""
 ....q:'$d(^OEORD(Ord))
 ....q:'$d(^OEORD(Ord,"I",Chl,7))
 ....s PriorDr=$p(^OEORD(Ord,"I",Chl,1),"^",8) 
 ....q:PriorDr=""                                       ;优先级不存在的不予发放 2006-05-27 
 ....s Priority=$p(^OECPR(PriorDr),"^",1)           ;医嘱优先级代码              
 ....q:Priority["OM" ;自备药以及嘱托
 ....s PriDesc=##class(PHA.COM.Data.Base).OrdPriDesc(PriorDr)
 ....s Doctor=$p($g(^OEORD(Ord,"I",Chl,7)),"^",1)
 ....i AdmType="E" s DoctorLocId=##class(web.DHCSTCOMMONSRV).GetEMLoc(AdmDr)
 ....e  s DoctorLocId=##class(PHA.IP.COM.Method).GetDspToLoc(DspId) //$p(^OEORD(Ord,"I",Chl,7),"^",2)
 ....//s DoctorLocId = ##class(PHA.IP.COM.Method).GetDspToLoc(DspId)  
 ....q:DoctorLocId'=DoctorLoc       ;医生科室?
 ....q:($lg(##class(PHA.IP.COM.Method).GetOrderDispWay(Ord_"||"_Chl),1)'= "BASEDISP")&&(AdmType'="E")
 ....q:##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)=0 ;判断执行记录状态是否可配药
 ....s PapmiDr=$p(^PAADM(AdmDr),"^",1) 
 ....q:PapmiDr=""
 ....s PatRegNo=$p(^PAPER(PapmiDr,"PAT",1),"^",1)    ;登记号
 ....q:(RegNo'="")&(RegNo'=PatRegNo)
 ....s PatName=$p(^PAPER(PapmiDr,"ALL"),"^",1)      ;姓名  
 ....s PatDob=$p( ^PAPER(PapmiDr,"ALL"),"^",6)
 ....s PatAge=""
 ....s PatAge=##class(PHA.FACE.IN.Com).GetAge(PapmiDr,AdmDr) //年龄统一调用接口wyx 2015-01-29
 ....;q:##class(web.DHCSTPCHCOLLS2).SkinTest(ord_"||"_chl)<0 ;检查是否需要皮试?
 ....s Inci=##class(web.DHCSTKUTIL).OrdItmInci(OrdItmRowid)
 ....q:(incidr'="")&(Inci'=incidr)
 ....q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(DspId)   ;被拒绝发放
 ....q:##class(web.DHCSTKUTIL).GetOrdAuditResult(DspId, "I")'="Y"
 ....s Bed=$p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(AdmDr,$s(AdmType'="E":WardLoc,1:"")),"^",2) // 当前床号
 ....s DepLoc=$p(^PAADM(AdmDr),"^",4)
 ....s DepLocDesc=##class(PHA.COM.Data.Base).LocDesc(DepLoc)             
 ....s ArcimId=$p(^OEORD(Ord,"I",Chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
 ....s ArcCatId=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)        ;医嘱子类RowId
 ....s ArcCatCode=$p(^ARC("IC",ArcCatId),"^",1)                                 ;医嘱子类代码
 ....;s Cat=##Class(web.DHCSTPCHCOLLS).GetCat(ArcCatCode)              ;医嘱子类对应的发药类别
 ....;q:##Class(web.DHCSTPCHCOLLS).CatInList(DispCat,Cat)=0             ;发药类别不在指定的类别里
 ....s OrderStatusDr=$p(^OEORD(Ord,"I",Chl,"X",OreChl,"BILL"),"^",1)  ;医嘱状态
 ....s OeFlag=$p(^OEC("OSTAT",OrderStatusDr),"^",1)          ;医嘱核实、未核实、停止状态
 ....s ordStatusDesc = ##class(PHA.COM.Data.Base).OrdStatusDesc(OrderStatusDr)
 ....s PhcdfDr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",12)
 ....s admReasonId=$p($g(^OEORD(Ord,"I",Chl,11)),"^",18)
 ....s OfficialCode=##class(PHA.FACE.IN.Com).GetInsuCode(ArcimId,admReasonId,HospID)
 ....s ArcimDesc=##class(PHA.COM.Data.Base).ArcimDesc(ArcimId)
 ....s DspQty=$p(^DHCOEDISQTY(DspId),"^",11) 
 ....s UomDr=$p(^INCI(Inci,1),"^",10)
 ....s Uom=##class(PHA.COM.Data.Base).UomDesc(UomDr)    
 ....s feepoint=##Class(web.DHCSTPCHCOLLS2).GetFeePoint(ArcCatId_"^"_Priority_"^"_OrdItmRowid)  
 ....s visitStatus = $p($g(^PAADM(AdmDr)), "^", 20)
 ....s exStr="^"_DspId
 ....s SalePrice=##Class(web.DHCSTPRICE).GetSp(Inci,Date,"",HospID,"",exStr)
 ....s BatchNo=""
 ....i RuleFlag=3 d
 .....i feepoint=1 d
 ......s DspIdBat=$o(^DHCOEDISQTY(DspId,"I","0"))
 ......q:DspIdBat=""
 ......s firstinclb=$p(^DHCOEDISQTY(DspId,"I",DspIdBat),"^",1)
 ......s firstbatsp=$p(^DHCOEDISQTY(DspId,"I",DspIdBat),"^",4)
 ......s Sp=+##class(web.DHCSTPRICE).GetSp(firstinclb,+$h,"",HospID,$p($h,",",2))
 ......i firstbatsp'=Sp d
 .......s Sp=firstbatsp
 .......s $p(^DHCOEDISQTY(DspId,"I",DspIdBat),"^",4)=firstbatsp ; 批次价发生售价,且发药计费时,修改打包批次表价格,yunhaibao20170122
 .....s BatchNo=##class(web.DHCSTPCHCOLLS).GetBatInfoByDsp(DspId)
 ....//s DoseQty=$p(^OEORD(Ord,"I",Chl,2),"^",1)    ;剂量
 ....S orditm=Ord_"||"_Chl
 ....s DoseQty=##class(web.DHCSTCOMMONORDER).OeoriDosage(orditm)
 ....s TolPrice=SalePrice*DspQty  ;金额
 ....s OeoriDate=$p(^OEORD(Ord,"I",Chl,3),"^",7)
 ....s TimeOrd=$p(^OEORD(Ord,"I",Chl,1),"^",17) 
 ....s DateTime=OeoriDate_","_TimeOrd ;开方时间
 ....s Doctor=$p(##class(PHA.COM.Order).OeoriDoctor(OrdItmRowid),"^",2) ;开单医生
 ....s Type=##class(PHA.COM.Data.Base).OrdPriDesc(PriorDr) ;医嘱类型
 ....s GeneDesc=$lg(##class(PHA.COM.Drug).GetGeneric(Inci),3) ;通用名
 ....s PhcForm=$lg(##class(PHA.COM.Drug).GetForm(Inci),3)   ;剂型 
 ....s Specifaction=##class(PHA.COM.Drug).GetSpec(Inci) ;规格
 ....s Manf=$lg(##class(PHA.COM.Drug).GetManf(Inci),3)  ;厂家
 ....s Goods=##class(web.DHCSTKUTIL).StkBin(OrdItmRowid) ;货位号  
 ....;--------------------------------------
 ....s FreqDr=$p($g(^OEORD(Ord,"I",Chl,2)),"^",4)
 ....s Freq=##class(PHA.COM.Data.Base).FreqDesc(FreqDr)
 ....s InstrDr=$p($g(^OEORD(Ord,"I",Chl,2)),"^",7)
 ....s Instr=##class(PHA.COM.Data.Base).InstDesc(InstrDr)
 ....i $f(Instr,"-") s Instr=$p(Instr,"-",2)   ;用法
 ....s DuraDr=$p($g(^OEORD(Ord,"I",Chl,2)),"^",6)
 ....s Dura=##class(PHA.COM.Data.Base).DuratDesc(DuraDr)
 ....s Presno=$p(^OEORD(Ord,"I",Chl,1),"^",14) ;处方号
 ....i Presno'="" d
 .....s Diagnose=##class(PHA.FACE.IN.Com).GetMRDiagnosDesc(Presno,", ")
 ....e  s Diagnose=""
 ....s GetAction=##class(web.DHCSTPCHCOLLS2).SkinTest2(OrdItmRowid) ;lq 2007-10-19 备注(皮试结果)
 ....;s insutype=##Class(web.DHCSTPCHCOLLS).GetYBType(adm) ;患者医保类别
 ....s InsuType=$g(OfficialCode) ;药医保类别     
 ....s Audited=$p(^DHCOEDISQTY(DspId),"^",17)
 ....s CollStat=""
 ....s data1=npid_"^"_InsuType_"^"_DepLoc_"^"_Bed_"^"_PatName_"^"_PatRegNo
 ....s data2=ArcimDesc_"^"_DspQty_"^"_Uom_"^"_SalePrice_"^"_OeFlag_"^"_PriDesc
 ....s data3=DoseQty_"^"_Freq_"^"_Instr_"^"_Dura_"^"_Presno_"^"_DspId_"^"_OrdItmRowid_"^"_AdmDr_"^"_DepLocDesc
 ....s data4=TolPrice_"^"_DateTime_"^"_PatAge_"^"_GeneDesc_"^"_PhcForm_"^"_Specifaction_"^"_Manf_"^"_Doctor_"^"_Type_"^"_Goods_"^"_Diagnose_"^"_Audited
 ....s data5=GetAction_"^"_Inci_"^"_LocId_"^"_BatchNo_"^"_CollStat_"^"_ordStatusDesc
 ....s j=AdmDr_"^"_Date_"^"_OrdItmRowid 
 ....i '$d(^TMP("dhcpha",npid,"D","DispCat",Cat,j))  d
 .....s ^TMP("dhcpha",npid,"D","DispCat",Cat,j)=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5
 .....s i=i+1
 ....e  d
 .....s $p(^TMP("dhcpha",npid,"D","DispCat",Cat,j),"^",8)=+$p(^TMP("dhcpha",npid,"D","DispCat",Cat,j),"^",8)+DspQty
 .....s $p(^TMP("dhcpha",npid,"D","DispCat",Cat,j),"^",18)=$p(^TMP("dhcpha",npid,"D","DispCat",Cat,j),"^",18)_","_DspId
 .....s $p(^TMP("dhcpha",npid,"D","DispCat",Cat,j),"^",22)=+$p(^TMP("dhcpha",npid,"D","DispCat",Cat,j),"^",22)+TolPrice
 ..... 
 .....//i BatchNo'="" d
 .....//.s tmpBatchString=$p(^TMP("dhcpha",npid,"DispCat",Cat,j),"^",37)
 .....//.s chkoutstring=##class(web.DHCSTPCHCOLLS).CheckExistString(tmpBatchString,BatchNo,",")
 .....//.s $p(^TMP("dhcpha",npid,"DispCat",Cat,j),"^",37)=$p(^TMP("dhcpha",npid,"DispCat",Cat,j),"^",37)_","_chkoutstring
 ....i (((feepoint=1)&&(AdmType="E"))||(visitStatus="P")) d
 .....s ret=##Class(web.DHCSTPCHCOLLS).AddAdmOrdItm(npid,Cat,AdmDr,OrdExeRowid,DspQty)  ;2007-01-08
 ....//i $d(^TMP("dhcpha",npid,"DOCTOTAL",Inci)) d 
 ....//.s $p(^TMP("dhcpha",npid,"DOCTOTAL",Inci),"^",8)=$p(^TMP("dhcpha",npid,"DOCTOTAL",Inci),"^",8)+DspQty
 ....//.s $p(^TMP("dhcpha",npid,"DOCTOTAL",Inci),"^",22)=$p(^TMP("dhcpha",npid,"DOCTOTAL",Inci),"^",22)+TolPrice
 ....//e  d
 ....//.s ^TMP("dhcpha",npid,"DOCTOTAL",Inci)= data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5
 .....
 ....
 
 i i>0 s ^TMP("dhcpha",npid,"D","DISPM")=LocId_"^"_DateFrom_"^"_DateTo_"^"_User
 i i>0 q npid    ; return the process ID
 q ""
}

/// CollectUserRowid : 发药人 , operatUserId : 配药人 , auditUserId : 核对人
/// w ##class(web.DHCSTPCHCOLLSDOCLOC).SaveDisp("","","KF","971802","4638")
ClassMethod SaveDisp(itmjs = "", itmjsex = "", phactype, pid, CollectUserRowid, DocLocRowid = "", operatUserId = "", auditUserId = "") As %String
{
 n (itmjs,itmjsex,phactype,pid,CollectUserRowid,DocLocRowid,operatUserId,auditUserId)
 //s ^zhxl("SaveDisp")=$lb(itmjs,itmjsex,phactype,pid,CollectUserRowid,DocLocRowid,operatUserId)
 s phactype=$g(phactype) 
 s datamain=^TMP("dhcpha",pid,"D","DISPM")
 s datefrom=$p(datamain,"^",2)
 s dateto=$p(datamain,"^",3)
 s ward=""
 s loc=$p(datamain,"^",1)
 i operatUserId'="" s user = operatUserId
 e  s user = CollectUserRowid
 s phacpdate=+$h
 s phacptime=$p($h,",",2)
 s phacstatus="Print"
 s HospID=""
 i loc'="" d
 .s HospID=$p($g(^CTLOC(loc)),"^",22)
 s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)    //进价规则
 s phaLocId= $o(^DHCPL(0,"Loc",loc,""))
 s Params="^"_loc_"^^"_HospID
 s NeedSkinTest=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP","SKINTESTFLAG",Params) 
 s j=0
 s phacrowid=""
 k SaveDataData
 s i=""
 f  s i=$o(^TMP("dhcpha",pid,"D","DispCat",phactype,i)) q:i=""  d
 .s data=^TMP("dhcpha",pid,"D","DispCat",phactype,i)
 .s adm=$p(i,"^",1)
 .q:$d(^TMP("DHCST","web.DHCSTPCHCOLLS","AdmOweFee",pid,adm))
 .s DateDosing=$p(i,"^",2)
 .s OrdItmRowid=$p(i,"^",3)
 .s canDisp=1
 .i ($p(^PAADM(adm),"^",2)="E")&&(NeedSkinTest="Y") d
 ..s skinTestValue=$p(##class(web.DHCSTCOMMONORDER).OeoriSkinTest(OrdItmRowid),"^",1)
 ..i skinTestValue<0 s canDisp=-1
 .q:canDisp'=1
 .s bed=$p(data,"^",4)
 .s oedis=$p(data,"^",19)
 .s dodis=$p(data,"^",18)    ;该位置使用dhc_oedispensing的rowid
 .s dodis=##class(web.DHCSTPCHCOLLS).ReGetDodis(dodis,+OrdItmRowid,$p(OrdItmRowid,"||",2))  ;重新获取配药记录串
 .q:dodis=""
 .s prescno=$p(data,"^",17)
 .s qty=$p(data,"^",8)
 .s saleprice=$p(data,"^",10)      
 .s ordstatus=$p(data,"^",11)
 .s admloc=$p(data,"^",3)
 .s DataStr=^TMP("dhcpha",pid,"D","DispCat",phactype,i)  ///add by hulihua20140108
 .s DspIdStr=$p(DataStr,"^",18)
 .q:$d(^TMP("dhcpha",pid,"D","DispCat","Filter",DspIdStr)) ;过滤没有选择的医嘱
 .i phacrowid="" s phacrowid=$$CreatePhaCollected()
 .s dodisLen=$l(dodis,",")
 .s dodisI=0
 .f dodisI=1:1:dodisLen d
 ..s errDispCode=""
 ..s dspId=$p(dodis,",",dodisI)
 ..q:dspId=""
 ..s dispRet=##class(web.DHCINPHA.Disp.Save).Dispensing(phacrowid,dspId,OrdItmRowid,RuleFlag,"","DOCLOCDISP")
 ..i $p(dispRet,"^",1)="-1" d
 ...s errDispCode=dispRet
 ...i errDispCode["库存不足" s SaveDataData("NoStock",pid,dspId)="" // 数组回滚不消失
 ..q:errDispCode'=""
 ..//i RuleFlag=3 d // 未医嘱改造的程序,先注释
 ..//.S Err=##class(web.DHCSTPCHCOLLS).DispensingByBatch(phacrowid,dodis,OrdItmRowid)
 ..//e  d
 ..//.S Err=##class(web.DHCSTPCHCOLLS).Dispensing(phacrowid,dodis,OrdItmRowid) //2 处理发药及库存系列表
 ..s j=j+1 
 i $d(SaveDataData) d
 .merge ^TMP("DHCST","web.DHCINPHA.Disp.Save","SaveData","NoStock",pid)=SaveDataData("NoStock",pid)
 k SaveDataData
 i j=0 d
 .&sql(delete from dhc_phacollected where dhc_phacollect_rowid=:phacrowid )
 q:j=0 0
 i phacrowid>0 s ret=$$Collect(phacrowid,CollectUserRowid) ;make collect flag
 ;s ret=##class(web.DHCSTPCHCOLLS).SendHX(phacrowid) //华西传送老HIS接口
 
 i phacrowid>0 d  ;发药后立即做账单
 .s ret=##Class(web.DHCINPHA.Disp.Save).MakeBill(phacrowid)
 .job ##class(web.DHCST.HERP).SendData(phacrowid,"P","")   // 插入HERP中间表 add by liangjiaquan 2018-11-27
 .job ##class(PHA.IN.Narc.Com).SaveNarcDisp("P"_"^"_phacrowid_"^"_CollectUserRowid_"^"_("")_"^"_(""), "") // 毒麻药品发药自动登记 2021-09-16
 q $g(phacrowid)
 
CreatePhaCollected()
 k PLIST
 s PLIST(2)=$g(loc)
 s PLIST(5)=$g(ward)
 s PLIST(6)=$g(operatUserId)
 s PLIST(7)=$g(phacstatus)
 s PLIST(8)=$g(phacpdate)
 s PLIST(9)=$g(phacptime)
 s PLIST(19)=$g(phacpdate)
 s PLIST(20)=$g(phacptime)
 s PLIST(11)=$g(datefrom)
 s PLIST(12)=$g(dateto)
 s PLIST(13)=$g(phactype)
 s PLIST(14)=$g(CollectUserRowid)
 s PLIST(15)=##class(web.DHCST.Common.AppCommon).GetAppNo(##class(web.DHCINPHA.Disp.Save).%GetParameter("AppName"),"",loc)
 s PLIST(50)=DocLocRowid
 s PLIST(51)=$g(user)
 s PLIST(54)=$g(auditUserId)
 &sql(INSERT INTO DHC_PHACollected VALUES :PLIST())
 q:SQLCODE -1
 q +$g(%ROWID)
    
Collect(phacdr, Nurse)
 n (phacdr,Nurse,secUserFlag)
 s Nurse=$g(Nurse)
 i '$d(^DHCPHAC(phacdr)) q -1
 ; calculate the rowcount of items 
 s phacdate=+$h
 s phactime=$p($h,",",2)
 s phaci="" 
 s cnt=0 
 f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
 .s cnt=cnt+1
 .
 
 s ret=0 
 i cnt=0 d
 . &sql(DELETE FROM DHC_PHACollected WHERE DHC_PHACollect_RowID=:phacdr)
 . s phacdr=""
 e  d
 .s code="Collect"
 . &sql(UPDATE DHC_PHACollected SET DHC_PHACounts=:cnt,DHC_PHACollectStatus=:code,
     DHC_PHACollectDate=:phacdate,
     DHC_PHACollectTime=:phactime,
     DHC_PHACollectUser=:Nurse WHERE DHC_PHACollect_RowID=:phacdr)
 . i SQLCODE'=0 s ret=-2
 q ret
DelOrdItmAuditFlag(phac)
 n (phac)
 s i=0
 s phaloc=$p(^DHCPHAC(phac),"^",1)
 s ward=$p(^DHCPHAC(phac),"^",4)
 q:ward="" 0
 s dispcat=$p(^DHCPHAC(phac),"^",12)
 q:dispcat="" 0
 s ch=0
 f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  d
 .s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)
 .s orditm=$p(oedis,"||",1,2)
 .w orditm,!
 .s dd=""
 .s ret=0
 .f  s dd=$o(^DHCCLNurseExec("SendMedic",phaloc,dd)) q:(dd="")!(ret>0)  d
 ..i $d(^DHCCLNurseExec("SendMedic",phaloc,dd,ward,dispcat,orditm))  k ^DHCCLNurseExec("SendMedic",phaloc,dd,ward,dispcat,orditm) s ret=1  
 .s i=i+1
 q i
}

ClassMethod KillTmpAfterSave(itmjs As %Library.String = "", itmjsex As %Library.String = "", pid As %String)
{
 k ^TMP("dhcpha",pid,"D","DispCat")
 d ..CLEARTMP(pid,"DOCTOTAL")
 q 0
}

ClassMethod CLEARTMP(pid, PAR As %String) As %String
{
 k ^TMP("dhcpha",pid,PAR)
}

ClassMethod CollectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CollectExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod CollectExecute(ByRef qHandle As %Binary, displocrowid As %String, startdate As %String, enddate As %String, userid As %String, dispcatlist As %String, doctorlocrowid As %String, RegNo As %String, incirowid As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 ;
 q:displocrowid="" $$$OK
 q:startdate="" $$$OK
 q:enddate="" $$$OK
 q:doctorlocrowid="" $$$OK
 
 Do ResetVariables
 s PID=..CollectDisp(displocrowid,startdate,enddate,userid,dispcatlist,doctorlocrowid,RegNo,incirowid)
 q:PID="" $$$OK    // no Process ID returned
 ;
 Do OutputRow
 ;
 Quit $$$OK
 
OutputRow
 s TmpCat=""
 f  s TmpCat=$o(^TMP("dhcpha",PID,"D","DispCat",TmpCat)) q:TmpCat=""  d
 .s SubStr=""
 .f  s SubStr=$o(^TMP("dhcpha",PID,"D","DispCat",TmpCat,SubStr)) q:SubStr=""  d
 ..s dispitm=^TMP("dhcpha",PID,"D","DispCat",TmpCat,SubStr)
 ..s AdmDr=$p(SubStr,"^",1)
 ..s DateDosing=$p(SubStr,"^",2)
 ..s OrdItmRowid=$p(SubStr,"^",3)
 ..s issutype=$p(dispitm,"^",2)
 ..s admloc=$p(dispitm,"^",21) 
 ..s bedno=$p(dispitm,"^",4)
 ..s paname=$p(dispitm,"^",5)
 ..s registerno=$p(dispitm,"^",6)
 ..s arcimdesc=$p(dispitm,"^",7)
 ..s qty=$p(dispitm,"^",8)
 ..s uom=$p(dispitm,"^",9)
 ..s sp=$p(dispitm,"^",10)
 ..s sp=$fn(sp,"",4)
 ..s ordstatus=$p(dispitm,"^",11)
 ..i ordstatus="V" s ordstatus=##class(PHA.COM.Base).Get("核实")
 ..s phatype=$p(dispitm,"^",12)
 ..s dosage=$p(dispitm,"^",13)
 ..s freq=$p(dispitm,"^",14)
 ..s instr=$p(dispitm,"^",15)
 ..s duration=$p(dispitm,"^",16)
 ..s prescno=$p(dispitm,"^",17)
 ..s batno =$p(dispitm,"^",37)
 ..s ordis =$p(dispitm,"^",19)
 ..s tolp=$p(dispitm,"^",22)
 ..s tolp=$fn(tolp,"",2)
 ..s dispitmdatetime=$p(dispitm,"^",23)
 ..s dispitmdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(dispitmdatetime,",",1),"IP")
 ..s dispitmtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(dispitmdatetime,",",2),"IP")
 ..s datetime=dispitmdate_" "_dispitmtime
 ..s Paold=$p(dispitm,"^",24)
 ..s genedesc=$p(dispitm,"^",25)
 ..s phcform=$p(dispitm,"^",26)
 ..s Specifaction=$p(dispitm,"^",27)
 ..s manf=$p(dispitm,"^",28)
 ..s manf=$p(manf,"-",2)
 ..s doctor=$p(dispitm,"^",29)
 ..s oetype=$p(dispitm,"^",30)
 ..s goods=$p(dispitm,"^",31)
 ..s diagnose=$p(dispitm,"^",32)
 ..s audited=$p(dispitm,"^",33)  //现在作为护士审核标志
 ..//i audited<0 s audited="N"
 ..//e  s audited="Y"
 ..s action=$p(dispitm,"^",34)
 ..s dspidstr=$p(dispitm,"^",18)
 ..s InciId=$p(dispitm,"^",35)
 ..s RecLocId=$p(dispitm,"^",36)
 ..s IL=$o(^INCI("IL_LOC",RecLocId,InciId,""))
 ..s InciQty=0 
 ..i IL'=""  d
 ...s Incil=InciId_"||"_IL
 ...s InciQty=##class(web.DHCSTSTKQTY).GetPhaQty(Incil,qty)  ;1,够发，0：不可发
 ...s:InciQty=0 InciQty="G" 
 ..s $p(Tstr,"^",7)=InciQty
 ..set Data=$lb(PID,issutype,admloc,bedno,paname,registerno,arcimdesc,qty,uom,sp,ordstatus,phatype,dosage,freq,instr,duration,prescno,batno,ordis,tolp,datetime,Paold,genedesc,phcform,Specifaction,manf,doctor,oetype,Goods,diagnose,audited,action,dspidstr,Tstr)
 ..Set ^CacheTemp(repid,ind)=Data  
 ..Set ind=ind+1
 .
 quit
 
ResetVariables
 set (PID,issutype,admloc,bedno,paname,registerno,arcimdesc,qty,uom,sp,ordstatus,phatype,dosage,freq,instr,duration,prescno,batno,ordis,tolp,datetime,Paold,genedesc,phcform,Specifaction,manf,doctor,oetype,Goods,diagnose,audited,action,dspidstr,Tstr)=""
 quit
}

ClassMethod CollectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CollectExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" { 
  Set AtEnd=1
  Set Row=""
 }
 Else      { 
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetDispDocLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDispDocLocExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// d ##class(web.DHCSTPCHCOLLSDOCLOC).GetLocDispType("98")
ClassMethod GetLocDispType(loc As %String) As %String
{
 q:loc="" ""
 s ret=""
 s plid=$o(^DHCPL(0,"Loc",loc,"")) 
 q:plid="" ""
 s chl="" 
 f  s chl=$o(^DHCPL(plid,"DIS",chl)) q:chl=""  d
 .s disptype=$p(^DHCPL(plid,"DIS",chl),"^",1)
 .s defaultflag=$p(^DHCPL(plid,"DIS",chl),"^",5)
 .s typecode=$p(^DHCSTDRUGGRP(disptype),"^",1)
 .s typedesc=$p(^DHCSTDRUGGRP(disptype),"^",2)
 .
 .i ret="" s ret=$g(typecode)_"^"_$g(typedesc)
 .e  s ret=ret_"!"_$g(typecode)_"^"_$g(typedesc)
 q ret
}

ClassMethod GetDispDocLocExecute(ByRef qHandle As %Binary, displocrowid As %String, StartDate As %String, EndDate As %String, dispcats As %String, StartTime As %String, EndTime As %String) As %Status
{
 
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 
 q:displocrowid="" $$$OK
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 
 Do InitVariables
 
 ;设置发药类别
 q:$g(dispcats)="" $$$OK
 s cnt=$l(dispcats,"^")
 f i=1:1:cnt d
 .Do InitCats(i,$p(dispcats,"^",i))
 
 
 s PID=..CollectDispDocLoc(displocrowid,StartDate,EndDate,StartTime,EndTime)
 
 q:PID="" $$$OK    // no Process ID returned
 s doclocdr=""
 f  s doclocdr=$o(^TMP("dhcpha",PID,"DocLoc","DispCat",doclocdr))  q:doclocdr=""  d
 .s doclocdesc=$p(^CTLOC(doclocdr),"^",2)
 .i $f(doclocdesc,"-") s doclocdesc=$p(doclocdesc,"-",2)
 .s catcode=""
 .d ClearCats      //zdm,2009-3-20
 .f  s catcode=$o(^TMP("dhcpha",PID,"DocLoc","DispCat",doclocdr,catcode)) q:catcode=""  d
 ..;w !,catcode_"ccc"
 ..Do SetCat(catcode)
 .Do OutPut
 .s i=i+1
 
 Quit $$$OK

SetCat(cat)
 i cat=catcode0  s catdesc0=1
 ;w !,cat_"||"_catcode0 ; lq 2007-10-17 注释 e ,放开后左边只能打勾最后一个待发药类型
 ;e  s catdesc0=0
 i cat=catcode1  s catdesc1=1
 ;e  s catdesc1=0
 i cat=catcode2  s catdesc2=1
 ;e  s catdesc2=0
 i cat=catcode3  s catdesc3=1
 ;e  s catdesc3=0
 i cat=catcode4  s catdesc4=1
 ;e  s catdesc4=0
 i cat=catcode5  s catdesc5=1
 ;e  s catdesc5=0
 i cat=catcode6  s catdesc6=1
 ;e  s catdesc6=0
 i cat=catcode7  s catdesc7=1
 ;e  s catdesc7=0
 i cat=catcode8  s catdesc8=1
 ;e  s catdesc8=0
 i cat=catcode9  s catdesc9=1
 ;e  s catdesc9=0
 Quit
 
InitCats(i,result)
 s i=i-1
 i i=0 d
 .s catcode0=result
 .s catdesc0=""
 i i=1 d
 .s catcode1=result
 .s catdesc1=""
 i i=2 d
 .s catcode2=result
 .s catdesc2=""
 i i=3 d
 .s catcode3=result
 .s catdesc3=""
 i i=4 d
 .s catcode4=result
 .s catdesc4=""
 i i=5 d
 .s catcode5=result
 .s catdesc5=""
 i i=6 d
 .s catcode6=result
 .s catdesc6=""
 i i=7 d
 .s catcode7=result
 .s catdesc7=""
 i i=8 d
 .s catcode8=result
 .s catdesc8=""
 i i=9 d
 .s catcode9=result
 .s catdesc9=""
 
 Quit
 
ClearCats
  ;zdm,2009-03-20
  Set (catdesc0,catdesc1,catdesc2,catdesc3,catdesc4,catdesc5,catdesc6,catdesc7,catdesc8,catdesc9)=""
  Quit
   
OutPut
    
 s Data=$lb(doclocdesc,catdesc0,catdesc1,catdesc2,catdesc3,catdesc4,catdesc5,catdesc6,catdesc7,catdesc8,catdesc9,doclocdr)
 s ^CacheTemp(repid,ind)=Data    
 Set ind=ind+1
 Quit
 
InitVariables
 set (doclocdesc,catdesc0,catdesc1,catdesc2,catdesc3,catdesc4,catdesc5,catdesc6,catdesc7,catdesc8,catdesc9,doclocdr)=""
 set (catcode0,catcode1,catcode2,catcode3,catcode4,catcode5,catcode6,catcode7,catcode8,catcode9)=""
 Quit
}

Query Collect(displocrowid As %String, StartDate As %String, EndDate As %String, userid As %String, dispcatlist As %String, doctorlocrowid As %String, RegNo As %String, incirowid As %String) As %Query(ROWSPEC = "TPID:%String,TInsuType:%String,TAdmLoc:%String,TBedNo:%String,TPaName:%String,TRegNo:%String,TDesc:%String,TQty:%String,TUom:%String,TSalePrice:%String,TOrdStatus:%String,TPhaCat:%String,TDoseQty:%String,TFreq:%String,TInstruction:%String,TDuration:%String,TPrescNo:%String,TBatchNo:%String,Toedis:%String,Tolp:%String,Tdatetime:%String,TPaold:%String,Tgenedesc:%String,Tphcform:%String,Tbarcode:%String,Tmanf:%String,Tdoctor:%String,Toetype:%String,Tgoods:%String,Tdiagnose:%String,Taudited:%String,Taction:%String,TDispIdStr:%String,Tstr:%String")
{
}

ClassMethod GetDispDocLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDispDocLocExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" { 
  Set AtEnd=1
  Set Row=""
 }
 Else      { 
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query GetDispDocLoc(displocrowid As %String, StartDate As %String, EndDate As %String, dispcats As %String, StartTime As %String, EndTime As %String) As %Query(ROWSPEC = "TDocLoc:%String,TCat0:%String,TCat1:%String,TCat2:%String,TCat3:%String,TCat4:%String,TCat5:%String,TCat6:%String,TCat7:%String,TCat8:%String,TCat9:%String,TDocLocRowID:%String")
{
}

ClassMethod CollectDispDocLoc(loc As %String, datefrom As %String, dateto As %String, st As %String, et As %String) As %Integer
{
 ;save the data into temporary global
 
 s npid=##class(web.DHCSTPCHCOLLS).NewPid() ; 
 
 s i=0
 k ^TMP("dhcpha",npid,"DocLoc","DispCat")
 s n=0
 f date=datefrom:1:dateto d
 .s WardLoc="" 
 .f  s WardLoc=$o(^DHCOEDISQTY(0,"REC",loc,date,"TC",WardLoc)) q:WardLoc=""  d
 ..s WardId=$o(^PAWARD(0,"WARD_LocationDR",WardLoc,""))
 ..s cat=""
 ..f  s cat=$o(^DHCOEDISQTY(0,"REC",loc,date,"TC",WardLoc,cat)) q:cat=""  d
 ...s DspId=0
 ...f  s DspId=$o(^DHCOEDISQTY(0,"REC",loc,date,"TC",WardLoc,cat,DspId)) q:DspId=""  d
 ....s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
 ....s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针
 ....s ord=+OrdExeRowid
 ....s chl=$p(OrdExeRowid,"||",2)
 ....s admId=$p(^OEORD(ord),"^",1)
 ....s admType=$p(^PAADM(admId),"^",2)
 ....s doctor=$p($g(^OEORD(ord,"I",chl,7)),"^",1)
 ....i admType="E" s doctorlocdr=##class(web.DHCSTCOMMONSRV).GetEMLoc(admId)
 ....e  s doctorlocdr=##class(PHA.IP.COM.Method).GetDspToLoc(DspId) //$p($g(^OEORD(ord,"I",chl,7)),"^",2) 
 ....q:doctorlocdr=""  ;医生科室
 ....// 过滤-病区发药\医生科室发药
 ....q:($lg(##class(PHA.IP.COM.Method).GetOrderDispWay(ord_"||"_chl),1)'= "BASEDISP")&&(admType'="E")
 ....q:$d(^TMP("dhcpha",npid,"DocLoc","DispCat",doctorlocdr,cat))  ;存在该医生科室该类别的发药记录，则不再处理
 ....s pr=$p(^OEORD(ord,"I",chl,1),"^",8) 
 ....q:pr=""                                ;优先级不存在的不予发放 
 ....s priority=$p(^OECPR(pr),"^",1) ;医嘱优先级代码
 ....q:priority["OM"  ;自备药以及嘱托
 ....;q:##class(web.DHCSTPCHCOLLS2).SkinTest(ord_"||"_chl)<0  ;检查是否需要皮试
 ....q:(admType'="I")&&(admType'="E")
 ....//q:(admType="I")&&(..CheckDocLoc(loc,doctorlocdr)=0)   ;该医生科室和发药科室不匹配，
 ....q:(admType="E")&&(##class(web.DHCSTCOMMONSRV).GetPayStayStatus(OrdItmRowid)'="Y")
 ....s ordtime=$p(^OEORD(ord,"I",chl,1),"^",17)    ;oeori_timeord,2007-12-26,lq,判断是否在要求的时间内
 ....q:(date=datefrom)&(ordtime'="")&(st'="")&(ordtime<st)
 ....q:(date=dateto)&(ordtime'="")&(et'="")&(ordtime>et)
 ....q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(DspId)   ;是否拒绝
 ....q:(##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)=0)  ;判断执行记录状态是否可配药
 ....q:##class(web.DHCSTKUTIL).GetOrdAuditResult(DspId, "I")'="Y"
 ....s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2) ;医嘱 ARC_ItmMast ARCIM_RowId
 ....s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
 ....q:inci=""
 ....i '$d(^TMP("dhcpha",npid,"DocLoc","DispCat",doctorlocdr,cat)) d
 .....s ^TMP("dhcpha",npid,"DocLoc","DispCat",doctorlocdr,cat)=1
 ....s i=i+1  
 ...
 ..
 . 
 i i>0 q npid    ; return the process ID
 q ""
}

ClassMethod CheckDocLoc(phaloc As %String, docloc As %String) As %Integer
{
 ;判断发药科室和医生科室是否存在对应关系
 q:phaloc="" 0
 q:docloc="" 0
 s ch=""
 s ch=$o(^CTLOC(phaloc,"LINK",0,"Loc",docloc,"")) q:ch="" 0
 q 1
}

ClassMethod GetDODIS(oeori As %String, NotAudit As %String) As %String
{
 //根据OsrdItmRowid查找其对应的DHC_OeDipensing记录
 //说明：
 //1.可能是多条
 //2.状态应当是"TC"的    
 //3.有可能需要有"审核"的限制
 n (oeori,NotAudit)
 q:oeori="" ""
 s ret="",result=""
 f  s ret=$o(^DHCOEDISQTY(0,"OEORI",oeori,ret))  q:ret=""  d
 . q:$p(^DHCOEDISQTY(ret),"^",7)'="TC"  //状态不是"TC"的不考虑
 . 
 . s ord=$p(oeori,"||",1),chl=$p(oeori,"||",2)
 . s priority=$p(^OEORD(ord,"I",chl,1),"^",8)
 . 
 . //审核控制
 . //q:(NotAudit'="1")&(##class(web.DHCSTPCHCOLLS).IfAuditByPriority(ord,chl,priority))&(##class(web.DHCSTPCHCOLLS).AuditedDodis(ret)=0)
 . q:(NotAudit'="1")&(##Class(web.DHCSTCOMMONSRV).IfAuditByPriority(ret)=0) //zhouyg 20141220)
 . i result="" s result=ret
 . e  s result=result_"|"_ret
 q result
}

Query DocDispTotal(PID As %String) As %Query(ROWSPEC = "TDesc:%String,TUom:%String,TDrugForm:%String,TQty:%String,TQtyBed:%String,TSp:%String,TBarcode:%String,TManufacture:%String,TIncstk:%String,TAmt:%String,TGeneric:%String,TPID:%String")
{
}

ClassMethod DocDispTotalExecute(ByRef qHandle As %Binary, PID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    q:PID="" $$$OK
    s AmtTotal=0
    /// 修改 2015-12-29 bianshuai
    s TmpCat=""
    f  s TmpCat=$o(^TMP("dhcpha",PID,"D","DispCat",TmpCat)) q:TmpCat=""  d
    .s SubStr=""
    .f  s SubStr=$o(^TMP("dhcpha",PID,"D","DispCat",TmpCat,SubStr)) q:SubStr=""  d
    ..s DataStr=^TMP("dhcpha",PID,"D","DispCat",TmpCat,SubStr)
    ..Q:TmpCat="Filter"
    ..s DspIdStr=$p(DataStr,"^",18)
    ..q:$d(^TMP("dhcpha",PID,"D","DispCat","Filter",DspIdStr))
    ..s DspQty=$p(DataStr,"^",8)
    ..s TolPrice=$p(DataStr,"^",22)
    ..s Inci=$p(DataStr,"^",35)
    ..i $d(^TMP("dhcpha",PID,"DOCTOTAL",Inci)) d 
    ...s $p(^TMP("dhcpha",PID,"DOCTOTAL",Inci),"^",8)=$p(^TMP("dhcpha",PID,"DOCTOTAL",Inci),"^",8)+DspQty
    ...s $p(^TMP("dhcpha",PID,"DOCTOTAL",Inci),"^",22)=$p(^TMP("dhcpha",PID,"DOCTOTAL",Inci),"^",22)+TolPrice
    ..e  d
    ...s ^TMP("dhcpha",PID,"DOCTOTAL",Inci)=^TMP("dhcpha",PID,"D","DispCat",TmpCat,SubStr)
    
    s inci=""
    f  s inci=$o(^TMP("dhcpha",PID,"DOCTOTAL",inci)) q:inci=""  d
    .s result=^TMP("dhcpha",PID,"DOCTOTAL",inci) 
    .
    .d outputdispitmtotal
    d outputdispitmtotalall
    k ^TMP("dhcpha",PID,"DOCTOTAL")
    q $$$OK
outputdispitmtotal
 ;s TCode=$p(result,"^",)
 s TDesc=$p(result,"^",7)
 s TQty=$p(result,"^",8)
 s TUom=$p(result,"^",9)
 S TSp=$p(result,"^",10)
 s TSp=$fn(TSp,"",4)
 s TQtyBed=""
 b //3
 s TDrugForm=$p(result,"^",26)
 s TBarcode=$p(result,"^",27)
 s TManufacture=$p(result,"^",28)
 i $f(TManufacture,"-") s TManufacture=$p(TManufacture,"-",2)
 s TIncstk=$p(result,"^",15)
 s TAmt=$p(result,"^",22)
 s TAmt=$fn(TAmt,"",2)
 s TGeneric=$p(result,"^",25)
 i $f(TGeneric,"-") s TGeneric=$p(TGeneric,"-",2)
 s AmtTotal=AmtTotal+TAmt
 s Data=$lb(TDesc,TUom,TDrugForm,TQty,TQtyBed,TSp,TBarcode,TManufacture,TIncstk,TAmt,TGeneric,PID)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
 
outputdispitmtotalall
 ;2007-8-30,zdm
 ;输出总金额
 
 s Data=$lb("总计","","","","","","","","",AmtTotal,"",PID)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DocDispTotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DocDispTotalExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod DocDispTotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DocDispTotalExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:        hulihua
/// CreatDate:      2014-05-18
/// Descriprtion:   发药前,根据选择,保存需过滤的医嘱Rowid
/// Table:          ^TMP("dhcpha",pid)
/// Input:          进程号,医嘱Rowid,标识:S -(SVAE) D -(Delete)
/// Output:
/// Others:
ClassMethod SaveToFilter(pid, oeori, flag)
{
   n (pid,oeori,flag)
   i flag="S" d
   .s ^TMP("dhcpha",pid,"D","DispCat","Filter",oeori)=""
   i flag="D" d 
   .i $d(^TMP("dhcpha",pid,"D","DispCat","Filter",oeori)) d
   ..k ^TMP("dhcpha",pid,"D","DispCat","Filter",oeori)
   .
   q 0
}

/// description: 控制全选与全消,存在此global,则不予发药
/// ##class(web.DHCINPHA.Disp.Query).SaveToFilter
ClassMethod SaveToFilterMulti(Pid, DspStrData, Flag)
{
    n (Pid, DspStrData, Flag)
    q:Pid="" ""
    s dspStrLen=$l(DspStrData,"^")
    s dspStrI=0
    f dspStrI=1:1:dspStrLen d
    .s dspStr=$p(DspStrData,"^",dspStrI)
    .q:dspStr=""
    .d ..SaveToFilter(Pid,dspStr,Flag)
    q 0
}

}

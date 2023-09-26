Import SQLUser

Class web.DHCMedPVMRepCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 49;

ClassMethod GetPVMByRowid(Rowid)
{
	n (Rowid)
	s s=$g(^DHCMedPVMRep(Rowid))
	s $p(s,"^",12)=##Class(web.DHCMedBaseCtl).GetCtlocStr($p(s,"^",12))
	s $p(s,"^",14)=##Class(web.DHCMedBaseCtl).GetUsrStr($p(s,"^",14))
	s:$p(s,"^",15)'="" $p(s,"^",15)=$zd($p(s,"^",15),3)
	s:$p(s,"^",16)'="" $p(s,"^",16)=$zt($p(s,"^",16))
	s $p(s,"^",17)=##Class(web.DHCMedBaseCtl).GetUsrStr($p(s,"^",17))
	s:$p(s,"^",18)'="" $p(s,"^",18)=$zd($p(s,"^",18),3)
	s:$p(s,"^",19)'="" $p(s,"^",19)=$zt($p(s,"^",19))
	s s=Rowid_"^"_s
	q s
}

/// 名称: UpdatePVM
/// 描述: 根据传入的字符串更新药物警戒报告
/// 编写者：cjb 
/// 编写日期: 2009-06-15
ClassMethod UpdatePVM(Instring)
{
    n (Instring)
    s MPVMRowid=$p(Instring,"^",1)      //Rowid
    s PLIST(2)=$p(Instring,"^",2)       //ReportNo
    s PLIST(3)=$p(Instring,"^",3)       //ReportType
    s PLIST(4)=$p(Instring,"^",4)       //ReportStatus
    s PLIST(5)=$p(Instring,"^",5)       //INCItmID
    s PLIST(6)=$p(Instring,"^",6)       //INCItmBatID
    s PLIST(7)=$p(Instring,"^",7)       //ReportQty
    s PLIST(8)=$p(Instring,"^",8)       //InStockQty
    s PLIST(9)=$p(Instring,"^",9)       //StockQty  8
    s PLIST(10)=$p(Instring,"^",10)     //Description
    s PLIST(11)=$p(Instring,"^",11)     //ResumeText
    s PLIST(12)=$p(Instring,"^",12)      //Opinion
    //s:PLIST(11)'="" PLIST(11)=$zdh(PLIST(11),3)
    s PLIST(13)=$p(Instring,"^",13)      //ReportLocID
    s PLIST(14)=$p(Instring,"^",14)      //ReportPlace
    s PLIST(15)=$p(Instring,"^",15)      //ReportUser
    s PLIST(16)=$p(Instring,"^",16)      //ReportDate
    s:PLIST(16)'="" PLIST(16)=$zdh(PLIST(16),4)
    s:PLIST(16)="" PLIST(16)=+$h
    s PLIST(17)=$p(Instring,"^",17)      //ReportTime
    s:PLIST(17)'="" PLIST(17)=$zth(PLIST(17))
    s:PLIST(17)="" PLIST(17)=$p($h,",",2)       
    s PLIST(18)=$p(Instring,"^",18)      //CheckUser
    //
    s PLIST(19)=$p(Instring,"^",19)      //CheckDate
    s:PLIST(19)'="" PLIST(19)=$zdh(PLIST(19),3)
    s PLIST(20)=$p(Instring,"^",20)      //CheckTime
    s:PLIST(20)'="" PLIST(20)=$zth(PLIST(20))
    s PLIST(21)=$p(Instring,"^",21)      //Text1
    s PLIST(22)=$p(Instring,"^",22)      //Text2
    i MPVMRowid="" d
    .&sql(insert into DHC_MedPVMReport values :PLIST())
    e  d
    .&sql(update DHC_MedPVMReport values :PLIST() where RowID=:MPVMRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

/// 名称: UpdateCheckPVM
/// 描述: 审核药物警戒报告
/// 编写者：cjb 
/// 编写日期: 2009-06-15
ClassMethod UpdateCheckPVM(MPVMRowid, Status, CheckUsr, CheckDate, CheckTime, Demo)
{
   s:CheckDate'="" CheckDate=$zdh(CheckDate,3)
   s:CheckDate="" CheckDate=+$h
   s:CheckTime'="" CheckTime=$zth(CheckTime) 
   s:CheckTime="" CheckTime=$p($h,",",2)
   &sql(update DHC_MedPVMReport set ReportStatus=:Status,CheckUser=:CheckUsr,CheckDate=:CheckDate,CheckTime=:CheckTime,ResumeText=:Demo where RowID=:MPVMRowid)
   q:SQLCODE SQLCODE
   s ret=$p(%ROWID,$c(1))
   q ret
}

ClassMethod UpdateOpinionDtlPVM(InString)
{
    n (InString)
    ;s PLIST(0)=$p(InString,"^",0)       //MEAS_ParRef                           
    ;s PLIST(1)=$p(InString,"^",1)       //Rowid                            
    ;s PLIST(2)=$p(InString,"^",2)       //ChildSub                         
    s PLIST(0)=$p(InString,"^",1)        //ParRef                           
    q:PLIST(0)="" -100
    s ChildSub=$p(InString,"^",2)        //ChildSub                         
    s PLIST(3)=$p(InString,"^",3)        //DescriptionDr        处理意见          
    s PLIST(4)=$p(InString,"^",4)        //UserDr        操作人              
    s PLIST(5)=$p(InString,"^",5)        //Date        操作日期          
    s:PLIST(5)'="" PLIST(5)=$zdh(PLIST(5),3)
    s:PLIST(5)="" PLIST(5)=+$h
    s PLIST(6)=$p(InString,"^",6)        //Time        操作时间          
    s:PLIST(6)'="" PLIST(6)=$zth(PLIST(6))
    s:PLIST(6)="" PLIST(6)=$p($h,",",2)
    s PLIST(7)=$p(InString,"^",7)      //Demo        备注                
    s ParRef=PLIST(0)
    i ChildSub="" d
    .&sql(Insert into dhc_medpvmreportdtl values :PLIST())
    e  d
    .&sql(update dhc_medpvmreportdtl values :PLIST() where Parref=:ParRef and ChildSub=:ChildSub)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

/// 名称: ItmBat
/// 描述: 根据药物Rowid，传入的药物批号模糊查询
/// 查询：批号，药物有效期，生产厂家 
/// 编写者：cjb 
/// 编写日期: 2009-06-15
ClassMethod ItmBat(itmID, BatNo)
{
  //itmID :库存项rowid
  n (itmID,BatNo)
  s itmID=+itmID
  s BatNo=$$ALPHAUP^SSUTIL4(BatNo)
  q:itmID="" ""
  s ret=""
  i itmID'=0 d    //批号为空查询该rowid的所有批次
  .s batsub=0
  .f  s batsub=$o(^INCI(itmID,"IB",batsub)) q:batsub=""  d  //表inc_itmbat
  ..s batInfo=$g(^INCI(itmID,"IB",batsub))
  ..s BatNoM=$p(batInfo,"^",1)
  ..q:((BatNo'="")&(BatNoM'[BatNo))
  ..s incib=itmID_"||"_batsub
  ..s ManfDesc=..GetManf(incib,"")    //获得生产厂家
  ..s UOM=..GetCTUom(itmID,+$h)       //单位
  ..s Price=+$fn(..GetPriceElse(itmID,+$h,UOM),"+")  //价格
  ..//s Price=+$fn(..GetPriceByIncItm(itmID,+$h),"+")  //价格
  ..s:UOM'="" UOM=$p($g(^CT("UOM",UOM)),"^",2)
  ..s CSC=..GetCSC(itmID,+$h)         //剂型
  ..s:CSC'="" CSC=$p($g(^INC("SC",CSC)),"^",2)
  ..s ret=ret_$c(1)_incib_"^"_batInfo_"^"_ManfDesc_"^"_Price_"^"_UOM_"^"_CSC
  // 否则查询以BatNo开头的批号
  /*
  e  d
  .i $d(^INCI("IB_NO",BatNo,itmID)) d
  ..s batsub=0
  ..f  s batsub=$o(^INCI("IB_NO",BatNo,itmID,batsub))  q:batsub=""  d
  ...s incib=itmID_"||"_batsub
  ...s batInfo=$g(^INCI(itmID,"IB",batsub))
  ...s ret=ret_$c(1)_incib_"^"_batInfo
  .s len=$l(BatNo)
  .s tmpBatNo=BatNo
  .f  s tmpBatNo=$o(^INCI("IB_NO",tmpBatNo))  q:$e(tmpBatNo,1,len)'=BatNo  d
  ..s batsub=0
  ..f  s batsub=$o(^INCI("IB_NO",tmpBatNo,itmID,batsub))  q:batsub=""  d
  ...s incib=itmID_"||"_batsub
  ...s ManfDesc=..GetManf(incib,"")
  ...s batInfo=$g(^INCI(itmID,"IB",batsub))
  ...s Price=+$fn(..GetPriceByIncItm(itmID,+$h),"+")
  ...s UOM=..GetCTUom(itmID,+$h)
  ...s:UOM'="" UOM=$p($g(^CT("UOM",UOM)),"^",2)
  ...s CSC=..GetCSC(itmID,+$h)         //剂型
  ...s:CSC'="" CSC=$p($g(^INC("SC",CSC)),"^",2)
  ...s ret=ret_$c(1)_incib_"^"_batInfo_"^"_ManfDesc_"^"_Price_"^"_UOM_"^"_CSC
  */
  q ret
}

//w $$ItmDets^DHCMedPVMCom("02")  药箅子[1个]

/// 名称: ItmDets
/// 描述: 根据药物的名称模糊查询
/// 查询：表inc_itm的信息 
/// 编写者：cjb 
/// 编写日期: 2009-06-15 
ClassMethod ItmDets(itmDesc)
{
  n (itmDesc)
  s itmDesc=$$ALPHAUP^SSUTIL4(itmDesc)
  q:itmDesc="" -1
  //汉字
  i $d(^INCI(0,"Desc",itmDesc)) d
  .s ItmRowId=""
  .f  s ItmRowId=$o(^INCI(0,"Desc",itmDesc,ItmRowId))  q:ItmRowId=""  d  
  ..s ^CacheTemp($j,"INCItm",ItmRowId)=..GetItmDetsById(ItmRowId)
  //
  s ItmRowId=""
  s tmpDesc=itmDesc
  s len=$l(itmDesc)
  f  s tmpDesc=$o(^INCI(0,"Desc",tmpDesc))  q:$e(tmpDesc,1,len)'=itmDesc  d
  .s ItmRowId=""
  .f  s ItmRowId=$o(^INCI(0,"Desc",tmpDesc,ItmRowId))  q:ItmRowId=""  d
  ..s ^CacheTemp($j,"INCItm",ItmRowId)=..GetItmDetsById(ItmRowId)
  //拼音
  i $d(^ARC("ALIAS",0,"Desc",itmDesc)) d
  .s tmpDesc1=""
  .f  s tmpDesc1=$o(^ARC("ALIAS",0,"Desc",itmDesc,tmpDesc1))  q:tmpDesc1=""  d
  ..s ARCRowId=""
  ..f  s ARCRowId=$o(^ARC("ALIAS",0,"Desc",itmDesc,tmpDesc1,ARCRowId))  q:ARCRowId=""  d  
  ...s ItmRowId=""
  ...f  s ItmRowId=$o(^INCI(0,"ARCIM_DR",ARCRowId,ItmRowId))  q:ItmRowId=""  d
  ....s ^CacheTemp($j,"INCItm",ItmRowId)=..GetItmDetsById(ItmRowId)
  //
  s tmpDesc=itmDesc
  f  s tmpDesc=$o(^ARC("ALIAS",0,"Desc",tmpDesc))  q:$e(tmpDesc,1,len)'=itmDesc  d
  .s tmpDesc1=""
  .f  s tmpDesc1=$o(^ARC("ALIAS",0,"Desc",tmpDesc,tmpDesc1))  q:tmpDesc1=""  d
  ..s ARCRowId=""
  ..f  s ARCRowId=$o(^ARC("ALIAS",0,"Desc",tmpDesc,tmpDesc1,ARCRowId))  q:ARCRowId=""  d  
  ...s ItmRowId=""
  ...s ARowId=+$p($g(^ARC("ALIAS",0,"Desc",tmpDesc,tmpDesc1,ARCRowId,1)),"^",1)
  ...f  s ItmRowId=$o(^INCI(0,"ARCIM_DR",ARowId,ItmRowId))  q:ItmRowId=""  d
  ....s ^CacheTemp($j,"INCItm",ItmRowId)=..GetItmDetsById(ItmRowId)
  q 1
}

ClassMethod GetItmDetsById(Rowid)
{
  n (Rowid)
  q:'$d(^INCI(Rowid,"1")) ""
  s s=$g(^INCI(Rowid,"1"))
  s s=Rowid_"^"_s
  q s
}

/// 2009-06-04 根据批号和日期查询厂家
/// 08-04-30以后上线医院用
/// 取DHC入库子表RowID
/// incib批号 (inclb:库存项批次表（inc_itmlcbt）RowID)
/// dah:日期
ClassMethod GetClbDHCIngri(incib, dah)
{
  //查找截止到某日期的最后一个入库单
  n (incib,dah)
  i dah="" s dah=+$h
  q:incib="" ""
  s tingr="",INGR="",grch=""
  f  s INGR=$o(^DHCINGR(0,"GRI_INCIB",incib,INGR),-1)  q:(tingr'="")!(INGR="")   d
  . s grdate=$p(^DHCINGR(INGR),"^",4)
  . s:grdate'>dah tingr=INGR
  . Q:tingr=""
  . S grch=$o(^DHCINGR(0,"GRI_INCIB",incib,INGR,""),-1)
  Q:grch="" ""
  s dhcingri=tingr_"||"_grch
  q dhcingri
}

/// 08-04-30以前上线医院用
/// 取DHC入库子表RowID
/// incib批号  (inclb:库存项批次表（inc_itmlcbt）RowID)
/// dah:日期
ClassMethod GetLastINGRI(incib, dah)
{
  n (incib,dah)
  i dah="" s dah=+$h
  q:incib="" ""
  s tingr="",INGR="",grch=""
  f  s INGR=$o(^INGRI("GRI_INCIB",incib,""),-1) q:(tingr'="")!(INGR="")  d
  .s grdate=$p(^INGR(INGR),"^",4)
  .s:grdate'>dah tingr=INGR
  .Q:tingr=""
  .S grch=$o(^INGRI("GRI_INCIB",incib,INGR,""),-1)
  Q:grch="" ""
  s INGRI=tingr_"||"_grch
  s DHCINGR=$o(^DHCINGR(0,"INGDRECITM",INGRI,"")) q:DHCINGR="" ""
  s DHCINGRCH=$o(^DHCINGR(0,"INGDRECITM",INGRI,DHCINGR,"")) q:DHCINGRCH="" ""
  S dhcingri=DHCINGR_"||"_DHCINGRCH
  q dhcingri
}

/// 取厂商
/// inclb:库存项批次表（inc_itmlcbt）RowID
/// dah:日期 w $$GetManf^DHCMedPVMCom("167||1","")
ClassMethod GetManf(incib, dah)
{
  n (incib,dah)
  //s ingri=..GetClbDHCIngri(incib,dah)	//08-04-30以后上线医院用
  s ingri=..GetLastINGRI(incib,dah)		//08-04-30以前上线医院用
  Q:ingri="" ""
  S INGR=$P(ingri,"||")
  S GRCH=$P(ingri,"||",2)
  Q:(INGR="")!(GRCH="") ""
  Q:'$D(^DHCINGR(INGR,"GRI",GRCH)) ""
  s Manf=$p(^DHCINGR(INGR,"GRI",GRCH),"^",29)
  q:Manf="" ""
  s ManfDesc=$p($g(^PHMNF(Manf)),"^",2)
  q ManfDesc
}

ClassMethod ItmBatByRowId(Rowid)
{
  n (Rowid)
  s Parref=$p(Rowid,"||")
  s Childsub=$p(Rowid,"||",2)
  q:'$d(^INCI(Parref,"IB",Childsub)) ""
  s ManfDesc=..GetManf(Rowid,"")
  //0820 增加药品显示内容
  s UOM=..GetCTUom(+Rowid,+$h)       //单位
  s Price=+$fn(..GetPriceElse(+Rowid,+$h,UOM),"+")  //价格
  s:UOM'="" UOM=$p($g(^CT("UOM",UOM)),"^",2)
  s CSC=..GetCSC(+Rowid,+$h)         //剂型
  s:CSC'="" CSC=$p($g(^INC("SC",CSC)),"^",2)
  //End 0820
  s ret=$g(^INCI(Parref,"IB",Childsub))_"^"_ManfDesc_"^"_UOM_"^"_Price_"^"_CSC
  s:$p(ret,"^",2)'="" $p(ret,"^",2)=$zd($p(ret,"^",2),3)
  s ret=$tr(ret,"/","-")
  s ret=$tr(ret,"^","/")
  q ret
}

/// 取DHC入库子表RowID w $$BatTrans^DHCMedPVMCom("409||5","","")
/// inclb:库存项批次表（inc_itmlcbt）RowID
/// dah:日期
ClassMethod BatTrans(incib, fd, td, loc)
{
  //表inc_itmbat的Rowid，fd,td日期
  n (incib,fd,td,loc)
  s num=0
  s:fd="" fd=(+$h)-365
  s:td="" td=+$h
  s inci=$P(incib,"||")
  s ilsub=""
  f  s ilsub=$O(^INCI("LB_IB",incib,inci,ilsub)) Q:ilsub=""  d //表inc_itmlcbt
  .s lbsub=""
  .f  s lbsub=$O(^INCI("LB_IB",incib,inci,ilsub,lbsub)) Q:lbsub=""  d
  ..s inclb=inci_"||"_ilsub_"||"_lbsub
  ..f dd=fd:1:td  d //日期
  ...s intr=""
  ...f  s intr=$O(^DHCINTR(0,"INCLB",inclb,dd,intr)) Q:intr=""  d //表DHC_InTrans
  ....s trtype=$P(^DHCINTR(intr),"^")
  ....Q:(trtype'="P")&(trtype'="F")&(trtype'="G") //P-住院发药,F-门诊发药,Y-住院退药，H-门诊退药
  ....s point=$P(^DHCINTR(intr),"^",9)
  ....q:+point=0
  ....s locdr=""
  ....I (trtype="P") D
  .....s phaID=$P(point,"||")
  .....s phasub=$P(point,"||",2)
  .....q:(phaID="")!(phasub="")
  .....S OEORI=$P($g(^DHCPHAC(phaID,"I",phasub)),"^",7)	//DHC_PHACollectItm 住院发药子表
  .....S OEORI=$P(OEORI,"||",1,2)
  .....s:OEORI'="" locdr=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"1")),"^",3)
  .....//w "locdr="_$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"1"),"^",3),!
  .....q:(loc'="")&(loc'=locdr)
  .....//s ^tmpItmBtOeOr(+OEORI)=""
  .....s ^CacheTemp("PVMOEORI",+OEORI)=""
  .....s num=num+1
  ....I (trtype="F") D
  .....S phdID=$P(point,"||")
  .....S phdsub=$P(point,"||",2)
  .....q:(phdID="")!(phdsub="")
  .....s OEORI=$P($g(^DHCPHDI(phdID,"PHDI",phdsub)),"^",5) //DHC_PHDISITEM 门诊发药二级子表
  .....s:OEORI'="" locdr=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"1")),"^",3)
  .....//w "locdr="_$p(^OEORD(+oeori,"I",$p(oeori,"||",2),"1"),"^",3),!
  .....q:(loc'="")&(loc'=locdr)
  .....//s ^tmpItmBtOeOr(+oeori)=""
  .....s ^CacheTemp("PVMOEORI",+OEORI)=""
  .....s num=num+1
  q num
}

/// 名称: QueryPaadmByItmBt
/// 描述: 取一段时间一种药物批号的所有科室医嘱
/// 查询：获得就诊rowid临时global
/// 编写者：cjb 
/// 编写日期: 2009-06-15 
ClassMethod QueryPaadmByItmBt(incib, fd, td)
{
  n (incib,fd,td)
  s num=0
  k ^CacheTemp("PVMOEORI")
  s num=..BatTrans(incib,fd,td,"")  //取一个批号的所有科室医嘱
  q:num=0 -1
  k ^CacheTemp($j,"ItmBtPaadm")
  s num=..BuildAdmList()            //根据OE_OrdItem.rowid组织就诊rowid
  k ^CacheTemp("PVMOEORI")
  q:num=0 -2
  q num
}

/// 名称: BuildAdmList
/// 描述: 根据OE_OrdItem.rowid组织就诊rowid
/// 查询：获得就诊rowid临时global
/// 编写者：cjb 
/// 编写日期: 2009-06-15
ClassMethod BuildAdmList()
{
  s AdmNum=0
  s rowid=0
  f  s rowid=$o(^CacheTemp("PVMOEORI",rowid)) q:rowid=""  d
  .s EpisodeID=$p($g(^OEORD(rowid)),"^",1)
  .s:EpisodeID'="" ^CacheTemp($j,"ItmBtPaadm",EpisodeID)=""
  .s AdmNum=AdmNum+1
  q AdmNum
}

/// 名称: QueryPaadmByItmLoc
/// 描述: 取一段时间一种药物inc=表inc_itm.rowid的loc科室医嘱
/// 查询：获得就诊rowid临时global
/// 编写者：cjb 
/// 编写日期: 2009-06-15
ClassMethod QueryPaadmByItmLoc(inc, fd, td, loc)
{
  n (inc,fd,td,loc)
  s num=0
  k ^CacheTemp("PVMOEORI")
  s BatString=..ItmBat(inc,"")  //一种药物的所有批号
  s BatLen=$l(BatString,$c(1))
  f iBulid=2:1:BatLen d
  .s incib=$P($p(BatString,$c(1),iBulid),"^",1)
  .s tmpnum=..BatTrans(incib,fd,td,loc)  //按科室取一种药物的使用医嘱
  .s num=num+tmpnum
  q:num=0 -1
  k ^CacheTemp($j,"ItmBtPaadm")
  s num=..BuildAdmList()
  k ^CacheTemp("PVMOEORI")
  q:num=0 -2
  q num
}

/// 名称: QueryA
/// 描述: 取一段时间 CtLoc报告科室 cStatus报告状态  cINCItm表inc_itm.rowid
/// Key报告描述关键字 cReportType报告类型
/// 查询：获得符合条件的药物警戒报告
/// 编写者：cjb 
/// 编写日期: 2009-06-15 
ClassMethod QueryA(DateFrom, DateTo, CtLoc, cStatus, cINCItm, Key, cReportType, Opinion)
{
  n (DateFrom, DateTo, CtLoc, cStatus, cINCItm, Key,cReportType,Opinion) 
  s i=0
  k PLIST,MLIST
  k ^CacheTemp($zn,$j)
  q:(DateTo="")!(DateFrom="") -1
  s DateFrom=$zdh(DateFrom,3)
  s DateTo=$zdh(DateTo,3)
  s cDate=DateFrom-1
  q:DateTo<DateFrom -100
    
  i CtLoc'=""  d GetByLoc // 所有科室报告的警戒报告
  i CtLoc="" d GetAll     // 某科室报告的警戒报告
  
  q i-1_"^"_$j  
 
  ///名称: GetByLoc
  ///描述: 查询某科室报告的警戒报告
  ///查询：获得符合条件的药物警戒报告
  ///编写者：cjb 
  ///编写日期: 2009-06-15  
GetByLoc
  f  s cDate=$o(^DHCMedPVMRep("0","DateLoc",cDate)) q:(cDate="")!(cDate>DateTo)  d
  .q:'$d(^DHCMedPVMRep("0","DateLoc",cDate,CtLoc)) 
  .s MPVMRowid=""
  .f  s MPVMRowid=$o(^DHCMedPVMRep("0","DateLoc",cDate,CtLoc,MPVMRowid)) q:MPVMRowid=""  d
  ..s s=$g(^DHCMedPVMRep(MPVMRowid))   //MEPDRowid
  ..s Status=$p(s,"^",3)
  ..s INCItm=$p(s,"^",4)
  ..s RepType=$p(s,"^",2)
  ..s tmpOpinion=$p(s,"^",11)
  ..//s Description=$p($$QueryByTypeCode^DHCMedDictory("PVMDescription",$p(s,"^",9)),"^",3)
  ..s Description=##Class(web.DHCMedDictoryCtl).GetByTypeCode("PVMDescription",$p(s,"^",9))
  ..q:cStatus'[Status
  ..q:(cINCItm'="")&&(cINCItm'=INCItm)
  ..q:(Key'="")&&(Description'[Key)
  ..q:(cReportType'="")&&(cReportType'=RepType)
  ..q:(Opinion'="")&(Opinion'=tmpOpinion)
  ..s ^CacheTemp($zn,$j,i)=MPVMRowid
  ..s i=i+1
  q
 
  ///名称: GetAll
  ///描述: 查询所有科室报告的警戒报告
  ///查询：获得符合条件的药物警戒报告
  ///编写者：cjb 
  ///编写日期: 2009-06-15     
GetAll
  f  s cDate=$o(^DHCMedPVMRep("0","DateLoc",cDate)) q:(cDate="")!(cDate>DateTo)  d
  .s CtLoc=""  f  s CtLoc=$o(^DHCMedPVMRep("0","DateLoc",cDate,CtLoc)) q:CtLoc=""  d
  ..s MPVMRowid=""
  ..f  s MPVMRowid=$o(^DHCMedPVMRep("0","DateLoc",cDate,CtLoc,MPVMRowid)) q:MPVMRowid=""  d
  ...s s=$g(^DHCMedPVMRep(MPVMRowid))
  ...s Status=$p(s,"^",3)
  ...s INCItm=$p(s,"^",4)
  ...s RepType=$p(s,"^",2)
  ...s tmpOpinion=$p(s,"^",11)
  ...s Description=##Class(web.DHCMedDictoryCtl).GetByTypeCode("PVMDescription",$p(s,"^",9))
  ...q:cStatus'[Status
  ...q:(cINCItm'="")&&(cINCItm'=INCItm)
  ...q:(Key'="")&&(Description'[Key)
  ...q:(cReportType'="")&&(cReportType'=RepType)
  ...q:(Opinion'="")&(Opinion'=tmpOpinion)
  ...s ^CacheTemp($zn,$j,i)=MPVMRowid
  ...s i=i+1
  q
}

/// 名称: GetDataByIndex
/// 描述: 根据进程号，取某条临时Global的药物警戒报告rowid
/// 查询：获得符合条件的药物警戒报告
/// 编写者：cjb 
/// 编写日期: 2009-06-15
ClassMethod GetDataByIndex(JIndex, CIndex)
{
     n (JIndex,CIndex)
     q:'$d(^CacheTemp($zn,JIndex,CIndex)) ""
     s MPVMRowid=$g(^CacheTemp($zn,JIndex,CIndex))
     q:+MPVMRowid=0 ""
     s tempIndex=$o(^CacheTemp($zn,JIndex,""),-1)     
     i $g(^CacheTemp($zn,JIndex,tempIndex))=MPVMRowid k ^CacheTemp($zn,JIndex)
     s s=..GetPVMByRowid(MPVMRowid)
     s $p(s,"^",3)=##Class(web.DHCMedDictoryCtl).GetByTypeCode("PVMReportType",$p(s,"^",3))
     s tmpStr=""
     i $p(s,"^",10)'="" d
     .f k=1:1:$l($p(s,"^",10),"/") d
     ..s:tmpStr'="" tmpStr=tmpStr_";"_##Class(web.DHCMedDictoryCtl).GetByTypeCode("PVMDescription",$p($p(s,"^",10),"/",k))
     ..s:tmpStr="" tmpStr=##Class(web.DHCMedDictoryCtl).GetByTypeCode("PVMDescription",$p($p(s,"^",10),"/",k))
     //s $p(s,"^",10)=##Class(web.DHCMedDictoryCtl).GetByTypeCode("PVMDescription",$p(s,"^",10))
     s $p(s,"^",10)=tmpStr
     s $p(s,"^",4)=##Class(web.DHCMedDictoryCtl).GetByTypeCode("PVMReportStatus",$p(s,"^",4))
     s $p(s,"^",12)=##Class(web.DHCMedDictoryCtl).GetByTypeCode("PVMOpinion",$p(s,"^",12))
     q s
}

/// 名称: GetOeoriByIncIt
/// 描述: 根据就诊rowid，表inc_itm.rowid查询表OE_OrdItem.rowid
/// 查询：获得符合条件医嘱相关信息，如医嘱类型，执行时间
/// 编写者：cjb 
/// 编写日期: 2009-06-15
ClassMethod GetOeoriByIncIt(EpisodeID, incit)
{
  n (EpisodeID,incit)
  s ARCIM=$p($g(^INCI(incit,"1")),"^",3)
  s num=0,s=""
  q:ARCIM="" s
  q:'$d(^OEORD(0,"Adm",+EpisodeID)) s
  s OEORD=$o(^OEORD(0,"Adm",+EpisodeID,""))
  q:'$d(^OEORDi(0,"ARCIM",+OEORD,ARCIM)) s
  s ordDate="" 
  f  s ordDate=$o(^OEORDi(0,"ARCIM",+OEORD,ARCIM,ordDate)) q:ordDate=""  d
  .s OEORISub=0 
  .f  s OEORISub=$o(^OEORDi(0,"ARCIM",+OEORD,ARCIM,ordDate,OEORISub)) q:OEORISub=""  d
  ..s OEORI=OEORD_"||"_OEORISub
  ..s TMP=..GetOrdsDetails(ARCIM,OEORI)  //由表OE_OrdItem.rowid及ARC_ItmMast.rowid查询医嘱相关信息
  ..s:TMP'="" s=s_TMP_$c(1)
  q s
}

/// 名称: GetOrdsDetails
/// 描述: 由表OE_OrdItem.rowid及ARC_ItmMast.rowid查询医嘱相关信息
/// 查询：获得符合条件医嘱相关信息，如医嘱类型，执行时间
/// 编写者：cjb 
/// 编写日期: 2009-06-15
ClassMethod GetOrdsDetails(ARCIM, OEORI)
{
  n (ARCIM,OEORI)
  s OEORD=$p(OEORI,"||",1)
  s OEORISub=$p(OEORI,"||",2)
  s phccat=..GetPhcCat(ARCIM)
  s ARCIMDesc=$p($g(^ARCIM(+ARCIM,"1",1)),"^",2)
  s sttDate=+$p($g(^OEORD(+OEORD,"I",+OEORISub,1)),"^",9)
  s ctuom=+$p($g(^ARCIM(+ARCIM,"1",1)),"^",4),uomDesc=""
  s:ctuom>0 uomDesc=$p($g(^CT("UOM",+ctuom)),"^",2)
  s InstrDR=+$p($g(^OEORD(+OEORD,"I",+OEORISub,2)),"^",7),InstrDesc=""
  s:InstrDR>0 InstrDesc=$p($g(^PHCIN(InstrDR)),"^",2)
  s DoseQty=+$p($g(^OEORD(+OEORD,"I",+OEORISub,2)),"^",1)
  s PhQtyOrd=+$p($g(^OEORD(+OEORD,"I",+OEORISub,1)),"^",12)  
  s PriorityDR=+$p($g(^OEORD(+OEORD,"I",+OEORISub,1)),"^",8),PriorityDesc=""
  s:PriorityDR>0 PriorityDesc=$p($g(^OECPR(PriorityDR)),"^",2)
  s PHFreqDR=+$p($g(^OEORD(+OEORD,"I",+OEORISub,2)),"^",4),PHFreqDesc=""
  s:PHFreqDR>0 PHFreqDesc=$p($g(^PHCFR(PHFreqDR)),"^",1)
  s DuratDR=+$p($g(^OEORD(+OEORD,"I",+OEORISub,2)),"^",6),DuratDays=1,DuratDesc=""
  s:DuratDR>0 DuratDays=+$p($g(^PHCDU(DuratDR)),"^",2),DuratDesc=$p($g(^PHCDU(DuratDR)),"^",3)
  s endDate=sttDate+DuratDays-1
  s sttDate=$zd(sttDate,3),endDate=$zd(endDate,3)
  s ItemStatDR=$p($g(^OEORD(+OEORD,"I",+OEORISub,1)),"^",13)
  s OrderStatus=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",3)
  s OrderStatusDesc=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",2)
  //医嘱医生
  s docDr=$p($g(^OEORD(+OEORD,"I",+OEORISub,7)),"^",1)
  s:+docDr'=0 docStr=docDr_"/"_$p($g(^SSU("SSUSR",docDr)),"^",1)_"/"_$p($g(^SSU("SSUSR",docDr)),"^",2)
  s ctSub=0,flag=0,CtDoc="",ctDocStr=""   //执行医生
  f  s ctSub=$o(^OEORD(+OEORD,"I",+OEORISub,"ST",ctSub)) q:(ctSub="")!(flag=1)  d
  .s Status=$p($g(^OEORD(+OEORD,"I",+OEORISub,"ST",ctSub)),"^",3)
  .s:(Status=1)!(Status=6) flag=1
  .s:flag=1 CtDoc=$p($g(^OEORD(+OEORD,"I",+OEORISub,"ST",ctSub)),"^",4)
  .s:+CtDoc'=0 ctDocStr=$p($g(^SSU("SSUSR",+CtDoc)),"^",2)
  //医嘱项描述 医嘱类型 医嘱开始日期 结束日期 医嘱频次  量 单位  使用方法   医嘱状态  下医嘱医生 执行医生
  s s=OEORI_$c(2)_ARCIMDesc_$c(2)_PriorityDesc_$c(2)_sttDate_$c(2)_endDate_$c(2)_PHFreqDesc_$c(2)_DoseQty_$c(2)_DuratDesc_$c(2)_InstrDesc_$c(2)_uomDesc_$c(2)_phccat_$c(2)_PhQtyOrd_$c(2)_OrderStatusDesc_$c(2)_docStr_$c(2)_ctDocStr
  q s
}

/// 名称: GetPhcCat
/// 描述: 由ARC_ItmMast.rowid取药理学分类信息
/// 查询：获得药学，药理相关信息
/// 编写者：cjb 
/// 编写日期: 2009-06-15
ClassMethod GetPhcCat(ARCIM)
{
  n (ARCIM) 
  s s=""
  s drgfrmrowid=$p(^ARCIM(+ARCIM,1,1),"^",12)        //PHC_DrgForm:药学形态
  s drugrowid=+drgfrmrowid                           //PHC_DrgMast药理学项
  q:drugrowid=0 s
  s psubcatrowid=$p(^PHCD(drugrowid,1),"^",3)        //PHC_SubCat药理学子分类
  //s pmincatrowid=$p(^PHCD(drugrowid,1),"^",6)        //PHC_MinorSubCat药理学最小分类
  s phccat=+psubcatrowid                             //phc_cat药理学分类
  s s=phccat_"/"_$p($g(^PHCC(phccat)),"^",1)_"/"_$p($g(^PHCC(phccat)),"^",2)
  q s
}

/// 名称: GetPriceByIncItm
/// 描述: 获得某时某中药物的价格
/// 查询：价格
/// 编写者：cjb 
/// 编写日期: 2009-07-02
ClassMethod GetPriceByIncItm(inci, dt)
{
  n (inci,dt)
  s dt=dt+1
  s excudate=$o(^INASP(0,"INCI",inci,dt),-1)
  q:excudate="" 0
  s adjrow=$o(^INASP(0,"INCI",inci,excudate,""))
  s PRICE=$p(^INASP(adjrow),"^",7)       
  q PRICE
}

ClassMethod GetPriceElse(inciid, stdate, uom)
{
  n (inciid,stdate,uom) 
  s price=0
  s stdate=stdate+1
  s excudate=stdate
  s buom=$p(^INCI(inciid,1),"^",10) ;base uom 
  i $g(uom)="" s uom=$p(^INCI(inciid,1),"^",10)                           ;base uom 
  s factor=..UOMFac(uom,buom)         ;get the conversion factor between uom and basic uom
  f  s excudate=$o(^INASP(0,"INCI",inciid,excudate),-1) q:excudate=""  d
  .q:price'=0
  .s adjrow="" 
  .f  s adjrow=$o(^INASP(0,"INCI",inciid,excudate,adjrow)) q:adjrow=""  d
  ..//s status=$p(^INASP(adjrow),"^",9)
  ..//i (status="Yes")!(status="Y") d
  ..s excudate=$p(^INASP(adjrow),"^",2)
  ..i stdate'<excudate d
  ...s price=$p(^INASP(adjrow),"^",7) s adjuom=$p(^INASP(adjrow),"^",10) s ctuomprice=$p(^INASP(adjrow),"^",11)
  ...i uom=$g(adjuom)  d
  ....s price=$g(ctuomprice)
  ...e  d
  ....s price=$g(price)*$g(factor)
  i $g(price)="" s price=0
  s price=$j($g(price),7,6)
  s price=+price
  q price
}

ClassMethod UOMFac(fr, to)
{
 n (fr,to)
 q:fr=to 1    ;if from-uom is as same as to-uom then return 1
 s rowid=""
 s rowid=$o(^CT("CTCF",0,"UOM",fr,to,rowid)) 
 i rowid'="" d       
 .s fac=$p(^CT("CTCF",rowid),"^",3)
 .s fac=$p(fac,$c(1))
 e  d
 .s fac=1
 q $g(fac)
}

/// 名称: GetCTUom
/// 描述: 获得药物计价单位
/// 查询：单位
/// 编写者：cjb 
/// 编写日期: 2009-07-02
ClassMethod GetCTUom(inci, dt)
{
  n (inci,dt)
  s dt=dt+1
  s excudate=$o(^INASP(0,"INCI",inci,dt),-1)
  q:excudate="" 0
  s adjrow=$o(^INASP(0,"INCI",inci,excudate,""))
  s UOM=$p(^INASP(adjrow),"^",10)       
  q UOM
}

/// 名称: GetCSC
/// 描述: 获得药物 剂型
/// 查询：单位
/// 编写者：cjb 
/// 编写日期: 2009-07-02
ClassMethod GetCSC(inci, dt)
{
  n (inci,dt)
  s dt=dt+1
  s excudate=$o(^INASP(0,"INCI",inci,dt),-1)
  q:excudate="" 0
  s adjrow=$o(^INASP(0,"INCI",inci,excudate,""))
  s CSC=$p(^INASP(adjrow),"^",8)       
  q CSC
}

ClassMethod GetPaadmBaseInfo(EpisodeID)
{
   n (EpisodeID)
   s TMP=..GetAdmInfo(+EpisodeID)
   s tmp=$g(^PAADM(+EpisodeID))
   s PAPER=+$p(tmp,"^",1)
   s papmino=$p(^PAPER(PAPER,"PAT",1),"^",1)
   s name=$p($g(^PAPER(PAPER,"ALL")),"^",1)
   s sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPER,"ALL")),"^",7))),"^",2)
   s birth=$p($g(^PAPER(PAPER,"ALL")),"^",6),birthdate=""
   i birth'="" s birthdate=$zd(birth,3)
   s age=..CalAge(birth,+$h)
   s TMP=TMP_"^"_papmino_"^"_name_"^"_sex_"^"_birthdate_"^"_age
   q TMP
}

ClassMethod CalAge(IBirth, IToday)
{
   n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
   s IBirth=$g(IBirth),IToday=$g(IToday)
   i IBirth>2980000 s IBirth=""
   i IBirth<0 s IBirth=""
   q:'$G(IBirth) ""
   s XBirth=$ZD(IBirth)
   s XToday=$ZD(IToday)
   s AgeMth=XToday-XBirth
   s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
   s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
   s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
   s AgeYear=CurrYear-BirthYear
   i AgeDay<0 d
   . s AgeMth=AgeMth-1
   . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
   . q:XToday'=2
   . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
   i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
   s $P(AgeYr,"|",12)=AgeYear
   s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
   i $p(AgeYr,"|",12)>0  d
   .s reage=$p(AgeYr,"|",12)_"岁"
   e  d
   .i AgeMth>0 d
   ..s reage=AgeMth_"月"
   .e  d
   ..s reage=AgeDay_"天"
   q reage
}

ClassMethod GetAdmInfo(EpisodeID)
{
    n (EpisodeID)
    q:'$d(^PAADM(+EpisodeID)) ""
    s LocDesc="",DocDesc="",WardDesc="",RoomDesc="",BedDesc="",DischgDate="",DischgTime=""
    s tmp=$g(^PAADM(+EpisodeID))
    s AdmType=$p(tmp,"^",2),AdmNo=$p(tmp,"^",81)
    s AdmDate=$zd($p(tmp,"^",6),3),AdmTime=$zt($p(tmp,"^",7))
    s papmi=+$p(tmp,"^",1),CTLoc=+$p(tmp,"^",4),Doc=+$p(tmp,"^",9)
    s Ward=+$p(tmp,"^",70),Room=+$p(tmp,"^",69),Bed=$p(tmp,"^",73)
    s:$p(tmp,"^",17)'="" DischgDate=$zd($p(tmp,"^",17),3),DischgTime=$zt($p(tmp,"^",18))
    
    s:CTLoc'=0 LocDesc=##class(web.DHCMedBaseCtl).GetCtlocStr(CTLoc)    
    s:Doc'=0 DocDesc=..GetUserByCTCP(Doc)
    s:Ward'=0 WardDesc=$p($g(^PAWARD(Ward)),"^",2)
    s:Room'=0 RoomDesc=$p($g(^PAROOM(Room)),"^",2)
    s:Bed'="" BedDesc=$p($g(^PAWARD(+Bed,"BED",$p(Bed,"||",2))),"^",1)
    
    s s=EpisodeID_"^"_AdmType_"^"_AdmNo_"^"_AdmDate_"^"_AdmTime_"^"_papmi_"^"_LocDesc_"^"_DocDesc_"^"_WardDesc_"^"_RoomDesc_"^"_BedDesc_"^"_DischgDate_"^"_DischgTime
    q s
}

ClassMethod GetUserByCTCP(CTCPDR)
{
    
   q:'$d(^CTPCP(CTCPDR)) ""
   s Code=$p($g(^CTPCP((CTCPDR),1)),"^",1)
   s Desc=$p($g(^CTPCP((CTCPDR),1)),"^",2)
   s ssusr=..GetSSUSERByCode(Code)
   s s=ssusr_"/"_Code_"/"_Desc
   q s
}

ClassMethod GetSSUSERByCode(SSUSRInitials)
{
   q:SSUSRInitials="" ""
   //^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP({SSUSR_Initials}),{SSUSR_RowId})
   //s SSUSRInitials=$ZCVT(SSUSRInitials,"U")
   s SSUSRInitials=$$ALPHAUP^SSUTIL4(SSUSRInitials)
   q:'$d(^SSU("SSUSR",0,"SSUSR_Initials",SSUSRInitials)) ""
   s ssusr=$o(^SSU("SSUSR",0,"SSUSR_Initials",SSUSRInitials,""),-1)
   q ssusr
}

ClassMethod QueryByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryByTypeExecute(ByRef qHandle As %Binary, Type As %String, Flag As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	;s ^WUQK(0)=Type_"/"_Flag
	;s:Type="" Type="EpidemicAppendixItem"
	;s:Flag="" Flag="Y"
	;s ^WUQK(1)=Type_"/"_Flag
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s iCount=$$QueryByType^DHCMedDictory(Type,Flag)
    zn CurrentNS
	q:iCount<0 $$$OK	
	f i=0:1:iCount d
	.s s=$g(PLIST(i))
	.d BuildDataDict

	Quit $$$OK
BuildDataDict      
	;set Data=$lb(id,code,desc,Fpfl,Lb)
	set Data=$lb("")
 	f iBuild=1:1:3 d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	s $li(Data,4)=$p(s,"^",8)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1 	
 	q
}

ClassMethod QueryByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByTypeExecute ]
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

/// 通过类型获取字典项目
Query QueryByType(Type As %String, Flag As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,Other:%String")
{
}

}

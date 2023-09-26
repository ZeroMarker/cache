Import sqluser

Class web.DHCSTSENDDATATOLC Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// d ##class(web.DHCSTSENDDATATOLC).GetPrescDATABYDailiy()

ClassMethod GetPrescDATABYDailiy() As %String
{
  s std=$p($h-1,",",1),edd=$p($h-1,",",1),stt=$zth("00:00:00",1),edt=$zth("23:59:59",1)
  s pid=..GetPRESCDATA(std,stt,edd,edt)
  d ..GetPrescDataMain("\\172.18.100.18\e$\Ygyy",pid)
  d ..GetPrescDataDetaliCFNRB("\\172.18.100.18\e$\Ygyy",pid)
  d ..GetPrescDataDetaliCFSFB("\\172.18.100.18\e$\Ygyy",pid)
  d ..GetPrescDataDetaliCFZDB("\\172.18.100.18\e$\Ygyy",pid)
  d ..GetPrescDataDetaliGHLSH("\\172.18.100.18\e$\Ygyy",pid)
  k ^DHCSTSENDDATAPRESCDATA("PRESCDATA",pid)
  k ^DHCSTSENDDATAPRESCDATA("PRESCDATACFNRB",pid)
  k ^DHCSTSENDDATAPRESCDATA("PRESCDDHCSTSENDDATATOLCATADETAILCFSFB",pid)
  k ^DHCSTSENDDATAPRESCDATA("PRESCDATACFZDB",pid)
  k ^DHCSTSENDDATAPRESCDATA("PRESCDATADETAILGHLSH",pid)
}

// d ##class(web.DHCSTSENDDATATOLC).GetPrescDATABYDailiySGDC("2013-01-26","00:00:00","2014-10-26","23:59:59","D:")

ClassMethod GetPrescDATABYDailiySGDC(Stdate, Sttime, Eddata, Edtime, Filname) As %String
{
  s std=$zdh($p(Stdate,",",1),3),edd=$zdh($p(Eddata,",",1),3),stt=$zth(Sttime,1),edt=$zth(Edtime,1)
  s pid=..GetPRESCDATA(std,stt,edd,edt)
  d ..GetPrescDataMain(Filname,pid)
  d ..GetPrescDataDetaliCFNRB(Filname,pid)
  d ..GetPrescDataDetaliCFSFB(Filname,pid)
  d ..GetPrescDataDetaliCFZDB(Filname,pid)
  d ..GetPrescDataDetaliGHLSH(Filname,pid)
  k ^DHCSTSENDDATAPRESCDATA("PRESCDATA",pid)
  k ^DHCSTSENDDATAPRESCDATA("PRESCDATADETAILCFSFB",pid)
  k ^DHCSTSENDDATAPRESCDATA("PRESCDATADETAILGHLSH",pid)
}

/// Creator:wyx
/// CreatDate:2012-11-02
/// Description:获取处方数据
/// Table:INC_Itm,PHC_Form
/// Input:
/// Return:处方数据
/// w ##class(web.DHCSTSENDDATATOLC).GetPRESCDATA(63158,0,63158,86399)
ClassMethod GetPRESCDATA(std, stt, edd, edt) As %String
{
 
 //s ^xuan("datattime",$zd($p($h,",",1),3),$zt($p($h,",",2),1))=""
 s pid=$i(^DHCSTSENDDATAPRESCDATA("PRESCDATA"))	
 k ^DHCSTSENDDATAPRESCDATA("PRESCDATA",pid)
 //s std=$zdh(Stdate,3),edd=$zdh(Eddata,3),stt=$zth(Sttime,1),edt=$zth(Edtime,1)
 //s std=$p($h-1,",",1),edd=$p($h-1,",",1),stt=$zth("00:00:00",1),edt=$zth("23:59:59",1)
 s paadmtime="",paadmdr="",mdata=""
 q:std>edd

 f mdata=std:1:edd d
 .s phl=""
 .f  s phl=$o(^PHDISPi(mdata,phl)) q:phl=""  d
 ..s phdrow=""
 ..f  s phdrow=$o(^PHDISPi(mdata,phl,phdrow)) q:phdrow=""  d
 ...s pfydate=$p(^PHDISP(phdrow),"^",3)
 ...s prescno=$p(^PHDISP(phdrow,2),"^",1)
 ...;s prescno=prescnonew_"^"_phdrow
 ...//b //1
 ...i prescno="O1312105504" s ^xuantmp("prescno11",prescno,phdrow)=""
 ...q:(pfydate'>"0")
 ...s adm="",phdi="",paadmdr=""
 ...//b //2
 ...f  s phdi=$o(^PHDI(phdrow,"PHDI",phdi)) q:phdi=""  d
 ....//b //3
 ....s orditm=$p(^PHDI(phdrow,"PHDI",phdi),"^",5)
 ....s ord=$p(orditm,"||",1)
 ....s itm=$p(orditm,"||",2)
 ....//i prescno="O1312105504" s ^xuantmp("prescno22",prescno,phdrow,orditm)=""
 ....s adm=+$P(^OEORD(ord),"^",1)
 ....i adm'="" s paadmdr=adm
 ...q:paadmdr=""
 ...s paadmtime=$p(^PAADM(paadmdr),"^",18)
 ...S padiagnose=""
 ...s padiagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(paadmdr,",") ;07-03-30
 ...//s padiagnosezy=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(paadmdr,",","Y") ;07-03-30
 ...//s padiagnose=padiagnose_","_padiagnosezy
 ...q:(mdata=std)&&(paadmtime'="")&&(paadmtime<stt)
 ...q:(mdata=edd)&&(paadmtime'="")&&(paadmtime>edt)
 ...//主信息
 ...q:($p(^PAADM(paadmdr),"^",2)'="O")&&($p(^PAADM(paadmdr),"^",2)'="E") //门诊急诊
 ...//i $p(^PAADM(paadmdr),"^",2)="O" s prescno=paadmdr_"_"_"OUT" //处方编码
 ...//i $p(^PAADM(paadmdr),"^",2)="E" s prescno=paadmdr_"_"_"EMER" //处方编码
 ...s departcode="4462"    //单位编码
 ...s dataeditno="1"       //数据版本号
 ...s happendate=$zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1) //环节发生时间
 ...s departarea="360000"   //业务所在行政区划
 ...s standno="1"    //标准版本号
 ...s hosdr="南昌市中西医结合医院"  //医疗机构名称
 ...s docdepdr=$p(^PAADM(paadmdr),"^",4) //医生所在科室
 ...s docdep="未知"
 ...i docdepdr'="" s docdep=$p($p(^CTLOC(docdepdr),"^",2),"-",2)
 ...//i docdep="" s ^xuantmp("docdep1",paadmdr)=docdepdr
 ...s ctcacdr=$p(^PAADM(paadmdr),"^",9)  
 ...s docdr=$p(^CTPCP(ctcacdr,1),"^",1) //医生编码
 ...s docdesc=$p(^CTPCP(ctcacdr,1),"^",2) //医生姓名
 ...s patcase=""       //病历号
 ...s patbedno=""       //床位号
 ...s papmas=$p(^PAADM(paadmdr),"^",1) //患者编号
 ...s patname=$p(^PAPER(papmas,"ALL"),"^",1) //患者姓名
 ...s patbob=$p(^PAPER(papmas,"ALL"),"^",6) //患者出生年
 ...s patage=$fn(((+$h)-patbob)/365,"",0) //患者年龄
 ...s patsexdr=$p(^PAPER(papmas,"ALL"),"^",7) //患者性别
 ...s sexdesc=$p(^CT("SEX",patsexdr),"^",2)  //患者性别描述
 ...i sexdesc="男" s patsex="1"
 ...e  i sexdesc="女" s patsex="2"
 ...e  s patsex="3"
 ...S PAPMIID=$P($G(^PAADM(paadmdr)),"^",1)
 ...s patinfo=..GetPatInfo(PAPMIID)
 ...s patfeetype=..GetPatFeetType($p(patinfo,"^",4))                      //患者费别
 ...s patcardno=""                         //患者卡号  ???
 ...s patybinfo=..GetInfoByAdm(paadmdr)
 ...s patcardno=$p(patybinfo,"^",4)                         //患者卡号
 ...//i patcardno="" s patcardno=" "
 ...//s ^xuantmp("2",pid,prescno)=patcardno
 ...s prescouttime=$zd(mdata,3)_" "_$zt(paadmtime,1)  //出具时间
 ...i $p(^PAADM(paadmdr),"^",2)="O" s presctype="1"    //处方类型
 ...i $p(^PAADM(paadmdr),"^",2)="E" s presctype="3"    //处方类型                      
 ...s prescspec="1"        //特殊用药说明
 ...i padiagnose [ "特殊" s prescspec=4  //特殊用药说明
 ...i padiagnose [ "慢性" s prescspec=2
 ...s prescspecdetail=""                 //特殊情况说明
 ...s patbobdate=..GetAge(papmas)         //患者出生日期
 ...s patbobtmp=$zd(patbob,3)
 ...s patbobdate=patbobtmp_" "_"00:00:00"
 ...//s ^DHCSTSENDDATAPRESCDATA("PRESCDATA",pid,prescno)=prescno_"^"_departcode_"^"_dataeditno_"^"_happendate_"^"_departarea_"^"_standno_"^"_hosdr_"^"_docdep_"^"_docdr_"^"_docdesc_"^"_patcase_"^"_patbedno_"^"_papmas_"^"_patname_"^"_patage_"^"_patsex_"^"_patfeetype_"^"_patcardno_"^"_prescouttime_"^"_presctype_"^"_prescspec_"^"_prescspecdetail_"^"_patbobdate
 ...s phdi=""
 ...//s j=1
 ...f  s phdi=$o(^PHDI(phdrow,"PHDI",phdi)) q:phdi=""  d
 ....s orditm="",ord="",itm="",durfact=""
 ....s orditm=$p(^PHDI(phdrow,"PHDI",phdi),"^",5)
 ....s ord=$p(orditm,"||",1)
 ....s itm=$p(orditm,"||",2)
 ....s oeorddr=ord
 ....s oeordsub=itm
 ....s retrowid=""
 ....//s orditmdd="1582205||6"
 ....//&sql(select PHRTI_Rowid into :retrowid from DHC_PHRETITM where PHRTI_OEORI_DR=:orditmdd)
 ....
 ....s reurntqty=$p(^PHDI(phdrow,"PHDI",phdi),"^",6)
 ....q:reurntqty'="" //过滤退药
 ....
 ....s prescno=$p(^OEORD(oeorddr,"I",oeordsub,1),"^",14)
 ....s ^DHCSTSENDDATAPRESCDATA("PRESCDATA",pid,prescno)=prescno_"^"_departcode_"^"_dataeditno_"^"_happendate_"^"_departarea_"^"_standno_"^"_hosdr_"^"_docdep_"^"_docdr_"^"_docdesc_"^"_patcase_"^"_patbedno_"^"_papmas_"^"_patname_"^"_patage_"^"_patsex_"^"_patfeetype_"^"_patcardno_"^"_prescouttime_"^"_presctype_"^"_prescspec_"^"_prescspecdetail_"^"_patbobdate
 ....
 ....//i prescno="O1312104250" b //444
 ....//明细信息
 ....s itmmast=$p(^OEORD(oeorddr,"I",oeordsub,1),"^",2)
 ....q:itmmast=""
 ....s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
 ....q:inci=""
 ....q:'$d(^INCI(inci))
 ....s incicode=$p(^INCI(inci,1),"^",1)  //药品编码
 ....s phcge=..GetPhcGenricByInci(inci) //药品名称（通用名）
 ....i phcge="" s phcge=$p(^INCI(inci,1),"^",2) //药品名称
 ....//i prescnonew="O1312045835" s ^xuantmp("prescno",prescno,phdrow,"PHDI",phdi)=phcge
 ....s weekqty="0"                       //周期数量
 ....q:'$d(^OEORD(oeorddr,"I",oeordsub,2))
 ....s instdr=$p(^OEORD(oeorddr,"I",oeordsub,2),"^",7)
 ....s inst=""
 ....i instdr'="" s inst=$p(^PHCIN(instdr),"^",2)  ;用法 
 ....s freqdr=$p(^OEORD(oeorddr,"I",oeordsub,2),"^",4)
 ....s freq=""
 ....i ((freqdr'="")&&($d(^PHCFR(freqdr)))) s freq=$p(^PHCFR(freqdr),"^",4)  ;用药频率
 ....s dosage=$p(^OEORD(oeorddr,"I",oeordsub,2),"^",1) ;用药剂量
 ....s dosageuomdr=$p(^OEORD(oeorddr,"I",oeordsub,2),"^",3)
 ....s dosageuom=""
 ....s:dosageuomdr'="" dosageuom=$p(^CT("UOM",dosageuomdr),"^",2)   ;剂量单位
 ....s firstdesc="用法:"_""_inst_"<br/>用量:"_freq_","_" 每次"_""_dosage_""_dosageuom  //用法用量
 ....//_"&lt;"_"br"_""_"&gt;"
 ....//s qty=$p(^PHDI(phdrow,"PHDI",phdi),"^",4)
 ....s qty=0
 ....s phdich=""
 ....f  s phdich=$o(^PHDI(phdrow,"PHDI",phdi,"INCLB",phdich)) q:phdich=""  d
 .....s phdichqty=$p(^PHDI(phdrow,"PHDI",phdi,"INCLB",phdich),"^",1)
 .....s qty=qty+phdichqty
 ....
 ....//i prescno="O1312075348" b //1111
 ....//s qty=$p(^OEORD(oeorddr,"I",oeordsub,1),"^",18)
 ....//s qty=..GetQtyPhcoll(oeorddr,oeordsub)
 ....
 ....//s ^xuantmp("mz1",oeorddr,oeordsub)=qty
 ....s unit=""
 ....//s qtyinfo=..getPackQty(inci,qty)
 ....//s qty=$p(qtyinfo,"^",1)       //药品数量
 ....//s unit=$p(qtyinfo,"^",2)      //药品单位 
 ....s buom=+$p(^INCI(inci,1),"^",10)  ; basic uom
 ....i buom'="" s unit=$p(^CT("UOM",buom),"^",2)
 ....//s totalprice=+$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",3)
 ....//s price=totalprice/qty
 ....s price=+$p(^OEORD(oeorddr,"I",oeordsub,2),"^",13)
 ....s price=$fn(price,"",4)          //药品单价
 ....s purtype="4"                //采购类型  待定？？
 ....s bwnum=""                   //本位码
 ....s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) 		//厂家    //生产企业
 ....s drugform=..GetForm(inci)   //剂型
 ....s spec=..GetSpec(inci)       //规格
 ....s packageunits=$p(^INCI(inci,3),"^",6)                        //包装单位
 ....s pacunitdesc=$p(^CT("UOM",packageunits),"^",2)               //包装单位
 ....s baseflagstr=..GetBaseFlag(inci)          //药品类别(基本药物标记)
 ....i baseflagstr="Y" s baseflag="1"
 ....e  s baseflag="2"
 ....s BuomStr=..GetIncBuom(inci)					//基本单位串
 ....S BuomDr=$P(BuomStr,"^",1)									    //基本单位ID
 ....s units=$P(BuomStr,"^",2)	                                  //基本单位 最小单位
 ....S PFac1=..UOMFac(packageunits,BuomDr)
 ....
 ....S BillUomStr=..GetArcBuomByInc(inci)			//计价单位串/
 ....S BillUomDr=$P(BillUomStr,"^",1)								//计价单位ID
 ....S BillUomDesc=$P(BillUomStr,"^",2)
 ....
 ....S PFac2=..UOMFac(BillUomDr,BuomDr)
 ....s purprice="" 
 ....s packqty=qty/PFac2                      //包装数量
 ....i BillUomDr=packageunits d
 .....s qty=qty/PFac2
 .....
 ....s unit=$p(^CT("UOM",BillUomDr),"^",2)
 ....//i prescno="O1312075348" b //2222
 ....s prescdrgform=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",12)
 ....s prescdrgmast=$p(prescdrgform,"||",1)
 ....q:prescdrgmast=""
 ....i prescdrgmast'=0 s prescpoisondr=+$p(^PHCD(prescdrgmast,1),"^",4)
 ....i prescdrgmast'=0 s prescstkcatsubdr=$p(^PHCD(prescdrgmast,1),"^",3) //药理学分类
 ....s prescstkcatsubcode=""
 ....s prescstkcatsubdesc=""
 ....s prescstkcatsubdrsub=$p(prescstkcatsubdr,"||",2)
 ....i (prescstkcatsubdr'="")&&(prescstkcatsubdrsub'="") s prescstkcatsubcode=$p(^PHCC(+prescstkcatsubdr,"SC",$p(prescstkcatsubdr,"||",2)),"^",1) //药理学分类code
 ....i (prescstkcatsubdr'="")&&(prescstkcatsubdrsub'="") s prescstkcatsubdesc=$p(^PHCC(+prescstkcatsubdr,"SC",$p(prescstkcatsubdr,"||",2)),"^",2) //药理学分类desc
 ....s prescphccstk=prescstkcatsubcode //_" "_prescstkcatsubdesc  //药理分类
 ....i prescstkcatsubdr'="" s prescphccstk=$g(^DHCSTPHCCSUBYG("sc",prescstkcatsubdr))
 ....i prescpoisondr'="" s poisondesc=$p(^PHCPO(prescpoisondr),"^",2)
 ....s dmtype=..CheckPoison(poisondesc)  //药品区分
 ....s incsc=$p(^INCI(inci,2),"^",2)
 ....q:$g(incsc)=""
 ....s incscg=$o(^DHCSCG("STKCAT",incsc,""))
 ....q:$g(incscg)=""    ;库存大类
 ....//s scgtype=$p(^DHCSCG(incscg),"^",3) ;库存类别
 ....//q:$g(scgtype)'="G" 
 ....//s drugspec=..GetSpec(inci) //规格
 ....s drugindidesc=$p(^DHCSCG(incscg),"^",2) ;类组  //药品分类
 ....s drugindicator=""
 ....q:(drugindidesc '[ "西药"=1)&&(drugindidesc '[ "中成药"=1)&&(drugindidesc '[ "中草药"=1)
 ....i drugindidesc [ "西药" s drugindicator="1"
 ....i drugindidesc [ "中成药" s drugindicator="2"  //????
 ....i drugindidesc [ "中草药" s drugindicator="3"
 ....s specinci=""                           //特殊药品？？？？
 ....;s facotor=1
 ....;i drugindicator="3" s facotor=..Getpaque(prescno)
 ....;s qty=qty*facotor
 ....i 
 ....
 ....s ^DHCSTSENDDATAPRESCDATA("PRESCDATACFNRB",pid,"CFNRB",prescno,"DETAILCFNRB",oeorddr,"I",oeordsub)=prescno_"^"_departcode_"^"_dataeditno_"^"_orditm_"^"_incicode_"^"_phcge_"^"_weekqty_"^"_firstdesc_"^"_qty_"^"_unit_"^"_price_"^"_purtype_"^"_bwnum_"^"_$p(manf,"-",2)_"^"_drugform_"^"_spec_"^"_pacunitdesc_"^"_baseflag_"^"_packqty_"^"_units_"^"_purprice_"^"_dmtype_"^"_drugindicator_"^"_specinci_"^"_prescphccstk
 ....//i prescnonew="O1312045835" s ^xuantmp("prescnoddd",facotor,prescnonew,oeorddr,oeordsub,paadmdr)=^DHCSTSENDDATAPRESCDATA("PRESCDATACFNRB",pid,"CFNRB",prescno,"DETAILCFNRB",j)
 ....//b //222
 ....//s j=j+1 
 ....//处方（医嘱）收费表 YY_YY_STEP_CFSFB
 ....//S oeori=oeorddr_"||"_oeordsub
 ....//s retJFstr=..GetPatInfoByoeori(oeori,"O",prescno)
 ....//s ^DHCSTSENDDATAPRESCDATA("PRESCDATADETAILCFSFB",pid,"CFSFB",prescno)=retJFstr 
 ....//b                       
 ....//处方（医嘱）收费表 YY_YY_STEP_CFSFB
 ....s retJFstr=..GetPatInfoByoeori("","O",prescno)
 ....s ^DHCSTSENDDATAPRESCDATA("PRESCDATADETAILCFSFB",pid,"CFSFB",prescno)=retJFstr 
 ....//i (oeorddr="1580920")||(oeorddr="1580921") s ^xuantmp("ggg",prescno,oeorddr,oeordsub)=""
 ...
 ...//处方（医嘱）收费表 YY_YY_STEP_CFSFB
 ...//s retJFstr=..GetPatInfoByAdm(paadmdr,"O")
 ...//s ^DHCSTSENDDATAPRESCDATA("PRESCDATADETAILCFSFB",pid,"CFSFB",prescno)=retJFstr
 ...//处方（医嘱）诊断表，YY_YY_STEP_CFZDB
 ...d ..DiagnosisRecord(paadmdr,pid)
 ...//就诊挂号表YY_YY_STEP_GHLSH
 ...d ..RegRecord(paadmdr,pid)

 //住院数据
 f mdata=std:1:edd d
 .s paadmdr=""
 .f  s paadmdr=$o(^PAADMi("DischDate",mdata,paadmdr)) q:paadmdr=""  d
 ..s paadmtime=$p(^PAADM(paadmdr),"^",18)
 ..q:(mdata=std)&&(paadmtime'="")&&(paadmtime<stt)
 ..q:(mdata=edd)&&(paadmtime'="")&&(paadmtime>edt)
 ..//主信息
 ..S padiagnose=""
 ..s padiagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(paadmdr,",") ;07-03-30
 ..//s padiagnosezy=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(paadmdr,",") ;07-03-30
 ..//s padiagnose=padiagnose_","_padiagnosezy
 ..q:$p(^PAADM(paadmdr),"^",2)'="I" //住院
 ..s prescno=paadmdr_"_"_"IN" //处方编码
 ..s departcode="4462"    //单位编码
 ..s dataeditno="1"       //数据版本号
 ..s happendate=$zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1) //环节发生时间
 ..s departarea="360000"   //业务所在行政区划
 ..s standno="1"    //标准版本号
 ..s hosdr="南昌市中西医结合医院"  //医疗机构名称
 ..s docdepdr=$p(^PAADM(paadmdr),"^",70) //医生所在病区
 ..s docdep="未知"
 ..i docdepdr'="" s docdep=$p($p(^PAWARD(docdepdr),"^",2),"-",2)
 ..//i docdep="" s ^xuantmp("docdep2",paadmdr)=docdepdr
 ..s ctcacdr=$p(^PAADM(paadmdr),"^",9)  
 ..s docdr=$p(^CTPCP(ctcacdr,1),"^",1) //医生编码
 ..s docdesc=$p(^CTPCP(ctcacdr,1),"^",2) //医生姓名
 ..S PAPMIID=$P($G(^PAADM(paadmdr)),"^",1)
 ..s admType = $P($G(^PAADM(paadmdr)),"^",2)
 ..S MedNo=##class(web.DHCSTInterfaceFromElse).GetMrNoByEpisodeID(paadmdr,admType)	//病案号
 ..s patcase=paadmdr
 ..i MedNo'="" d
 ...s patcase=MedNo       //病历号
 ..s patbednodr=$p(^PAADM(paadmdr),"^",73)
 ..s patbedno=""
 ..i patbednodr'="" s patbedno=$p(^PAWARD(+patbednodr,"BED",$p(patbednodr,"||",2)),"^",1)       //床位号
 ..s papmas=$p(^PAADM(paadmdr),"^",1) //患者编号
 ..s patname=$p(^PAPER(papmas,"ALL"),"^",1) //患者姓名
 ..s patbob=$p(^PAPER(papmas,"ALL"),"^",6) //患者出生年
 ..s patage=$fn(((+$h)-patbob)/365,"",0) //患者年龄
 ..s patsexdr=$p(^PAPER(papmas,"ALL"),"^",7) //患者性别
 ..s sexdesc=$p(^CT("SEX",patsexdr),"^",2)  //患者性别描述
 ..i sexdesc="男" s patsex="1"
 ..e  i sexdesc="女" s patsex="2"
 ..e  s patsex="3"
 ..S PAPMIID=$P($G(^PAADM(paadmdr)),"^",1)
 ..s patinfo=..GetPatInfo(PAPMIID)
 ..s patfeetype=..GetPatFeetType($p(patinfo,"^",4))                     //患者费别
 ..s patybinfo=..GetInfoByAdm(paadmdr)
 ..s patcardno=""
 ..s patcardno=$p(patybinfo,"^",4)                         //患者卡号
 ..//i patcardno="" s patcardno=" "
 ..s prescouttime=$zd(mdata,3)_" "_$zt(paadmtime,1)  //出具时间
 ..s presctype="2"    //处方类型
 ..s prescspec="1"        //特殊用药说明
 ..i padiagnose [ "特殊" s prescspec=4  //特殊用药说明
 ..i padiagnose [ "慢性" s prescspec=2
 ..s prescspecdetail=""                 //特殊情况说明
 ..s patbobdate=..GetAge(papmas)         //患者出生日期
 ..s patbobtmp=$zd(patbob,3)
 ..s patbobdate=patbobtmp_" "_"00:00:00"
 ..s ^DHCSTSENDDATAPRESCDATA("PRESCDATA",pid,prescno)=prescno_"^"_departcode_"^"_dataeditno_"^"_happendate_"^"_departarea_"^"_standno_"^"_hosdr_"^"_docdep_"^"_docdr_"^"_docdesc_"^"_patcase_"^"_patbedno_"^"_papmas_"^"_patname_"^"_patage_"^"_patsex_"^"_patfeetype_"^"_patcardno_"^"_prescouttime_"^"_presctype_"^"_prescspec_"^"_prescspecdetail_"^"_patbobdate
 ..
 ..s oeorddr=""
 ..
 ..f  s oeorddr=$o(^OEORD(0,"Adm",paadmdr,oeorddr)) q:oeorddr=""  d
 ...s oeordsub="0"
 ...s j=1
 ...f  s oeordsub=$o(^OEORD(oeorddr,"I",oeordsub)) q:oeordsub=""  d
 ....q:($p(^OEC("OSTAT",$p(^OEORD(oeorddr,"I",oeordsub,1),"^",13)),"^",1)'="V")&&($p(^OEC("OSTAT",$p(^OEORD(oeorddr,"I",oeordsub,1),"^",13)),"^",1)'="E")
 ....s orditm=oeorddr_"||"_oeordsub
 ....//明细信息
 ....s itmmast=$p(^OEORD(oeorddr,"I",oeordsub,1),"^",2)
 ....q:itmmast=""
 ....s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
 ....q:inci=""
 ....q:'$d(^INCI(inci))
 ....s incicode=$p(^INCI(inci,1),"^",1)  //药品编码
 ....s phcge=..GetPhcGenricByInci(inci) //药品名称（通用名）
 ....i phcge="" s phcge=$p(^INCI(inci,1),"^",2) //药品名称
 ....s weekqty="0"                       //周期数量
 ....q:'$d(^OEORD(oeorddr,"I",oeordsub,2))
 ....s instdr=$p(^OEORD(oeorddr,"I",oeordsub,2),"^",7)
 ....s inst=""
 ....i instdr'="" s inst=$p(^PHCIN(instdr),"^",2)  ;用法 
 ....s freqdr=$p(^OEORD(oeorddr,"I",oeordsub,2),"^",4)
 ....s freq=""
 ....i ((freqdr'="")&&($d(^PHCFR(freqdr)))) s freq=$p(^PHCFR(freqdr),"^",4)  ;用药频率
 ....s dosage=$p(^OEORD(oeorddr,"I",oeordsub,2),"^",1) ;用药剂量
 ....//w dosage,!
 ....s dosageuomdr=$p(^OEORD(oeorddr,"I",oeordsub,2),"^",3)
 ....s dosageuom=""
 ....s:dosageuomdr'="" dosageuom=$p(^CT("UOM",dosageuomdr),"^",2)   ;剂量单位
 ....s firstdesc="用法:"_""_inst_"<br/>用量:"_""_freq_","_" 每次"_""_dosage_""_dosageuom  //用法用量
 ....//_"&lt;"_"br"_""_"&gt;"
 ....//w firstdesc,!
 ....//s qty=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",4 )
 ....//s qty=$p(^OEORD(oeorddr,"I",oeordsub,1),"^",18)
 ....s qty=..GetQtyPhcoll(oeorddr,oeordsub)
 ....s unit=""
 ....s buom=+$p(^INCI(inci,1),"^",10)  ; basic uom
 ....i buom'="" s unit=$p(^CT("UOM",buom),"^",2)
 ....//s ^xuantmp("qty1",inci,oeorddr,"I",oeordsub)=qty
 ....//s qtyinfo=..getPackQty(inci,qty)
 ....//s qty=$p(qtyinfo,"^",1)       //药品数量
 ....//s unit=$p(qtyinfo,"^",2)      //药品单位 
 ....//s ^xuantmp("qty2",inci)=qty_"^"_unit
 ....//s totalprice=+$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",3)
 ....//s price=totalprice/qty
 ....s price=+$p(^OEORD(oeorddr,"I",oeordsub,2),"^",13)
 ....s price=$fn(price,"",4)          //药品单价
 ....s purtype="4"                //采购类型  待定？？
 ....s bwnum=""                   //本位码
 ....s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) 		//厂家    //生产企业
 ....s drugform=..GetForm(inci)   //剂型
 ....s spec=..GetSpec(inci)       //规格
 ....s packageunits=$p(^INCI(inci,3),"^",6)                        //包装单位
 ....s pacunitdesc=$p(^CT("UOM",packageunits),"^",2)               //包装单位
 ....s baseflagstr=..GetBaseFlag(inci)          //药品类别(基本药物标记)
 ....i baseflagstr="Y" s baseflag="1"
 ....e  s baseflag="2"
 ....s BuomStr=..GetIncBuom(inci)					//基本单位串
 ....S BuomDr=$P(BuomStr,"^",1)									    //基本单位ID
 ....s units=$P(BuomStr,"^",2)	                                  //基本单位 最小单位
 ....S PFac1=..UOMFac(packageunits,BuomDr)
 ....s packqty=qty*PFac1                       //包装数量
 ....s purprice=""                         //采购价
 ....
 ....s prescdrgform=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",12)
 ....s prescdrgmast=$p(prescdrgform,"||",1)
 ....q:prescdrgmast=""
 ....i prescdrgmast'=0 s prescpoisondr=+$p(^PHCD(prescdrgmast,1),"^",4)
 ....i prescdrgmast'=0 s prescstkcatsubdr=$p(^PHCD(prescdrgmast,1),"^",3) //药理学分类
 ....s prescstkcatsubcode=""
 ....s prescstkcatsubdesc=""
 ....s prescstkcatsubdrsub=$p(prescstkcatsubdr,"||",2)
 ....i (prescstkcatsubdr'="")&&(prescstkcatsubdrsub'="") s prescstkcatsubcode=$p(^PHCC(+prescstkcatsubdr,"SC",$p(prescstkcatsubdr,"||",2)),"^",1) //药理学分类code
 ....i (prescstkcatsubdr'="")&&(prescstkcatsubdrsub'="") s prescstkcatsubdesc=$p(^PHCC(+prescstkcatsubdr,"SC",$p(prescstkcatsubdr,"||",2)),"^",2) //药理学分类desc
 ....s prescphccstk=prescstkcatsubcode //_" "_prescstkcatsubdesc  //药理分类
 ....i prescstkcatsubdr'="" s prescphccstk=$g(^DHCSTPHCCSUBYG("sc",prescstkcatsubdr))
 ....i prescpoisondr'="" s poisondesc=$p(^PHCPO(prescpoisondr),"^",2)
 ....s dmtype=..CheckPoison(poisondesc)  //药品区分
 ....s incsc=$p(^INCI(inci,2),"^",2)
 ....q:$g(incsc)=""
 ....s incscg=$o(^DHCSCG("STKCAT",incsc,""))
 ....q:$g(incscg)=""    ;库存大类
 ....//s scgtype=$p(^DHCSCG(incscg),"^",3) ;库存类别
 ....//q:$g(scgtype)'="G" 
 ....//s drugspec=..GetSpec(inci) //规格
 ....s drugindidesc=$p(^DHCSCG(incscg),"^",2) ;类组  //药品分类
 ....s drugindicator=""
 ....q:(drugindidesc '[ "西药"=1)&&(drugindidesc '[ "中成药"=1)&&(drugindidesc '[ "中草药"=1)
 ....i drugindidesc [ "西药" s drugindicator="1"
 ....i drugindidesc [ "中成药" s drugindicator="2"  //????
 ....i drugindidesc [ "中草药" s drugindicator="3"
 ....s specinci=""                           //特殊药品？？？？
 ....s ^DHCSTSENDDATAPRESCDATA("PRESCDATACFNRB",pid,"CFNRB",prescno,"DETAILCFNRB",oeorddr,"I",oeordsub)=prescno_"^"_departcode_"^"_dataeditno_"^"_orditm_"^"_incicode_"^"_phcge_"^"_weekqty_"^"_firstdesc_"^"_qty_"^"_unit_"^"_price_"^"_purtype_"^"_bwnum_"^"_$p(manf,"-",2)_"^"_drugform_"^"_spec_"^"_pacunitdesc_"^"_baseflag_"^"_packqty_"^"_units_"^"_purprice_"^"_dmtype_"^"_drugindicator_"^"_specinci_"^"_prescphccstk
 ....s j=j+1                         
 ..//处方（医嘱）收费表 YY_YY_STEP_CFSFB
 ..s retJFstr=..GetPatInfoByAdm(paadmdr,"I")
 ..s ^DHCSTSENDDATAPRESCDATA("PRESCDATADETAILCFSFB",pid,"CFSFB",prescno)=retJFstr
 ..//处方（医嘱）诊断表，YY_YY_STEP_CFZDB
 ..d ..DiagnosisRecord(paadmdr,pid)
 ..//就诊挂号表YY_YY_STEP_GHLSH
 ..d ..RegRecord(paadmdr,pid)

 q pid
}

// w ##class(web.DHCSTSENDDATATOLC).GetPrescDataMain(filename)

// 处方（医嘱）表，YY_YY_STEP_CFB

ClassMethod GetPrescDataMain(filename, pid)
{
 //s ^xuan("datattime2",$zd($p($h,",",1),3),$zt($p($h,",",2),1))=""
 //s objStream=##class(%GlobalCharacterStream).%New()
 //Set currentIO = $$GetPDefIO^%NLS(3)
 //Do SetPDefIO^%NLS("UTF8",3)
 //Do SetPDefIO^%NLS("GB2312",3)
 s yeartime=$p($zd($p($h,",",1),3),"-",1)_$p($zd($p($h,",",1),3),"-",2)_$p($zd($p($h,",",1),3),"-",3)_$p($zt($p($h,",",2),1),":",1)_$p($zt($p($h,",",2),1),":",2)_$p($zt($p($h,",",2),1),":",3)
 s filename=filename_"\3601001081001_YY_YY_STEP_CFB_4462_"_yeartime_".xml"
 s Count=0
 Set objStream=##class(%FileCharacterStream).%New()
 Set objStream.Filename=filename //"\\172.21.21.40\d$\yyy.xml"
 d objStream.Clear()
 d objStream.TranslateTableSet("GB18030")
 d objStream.WriteLine("<?xml version='1.0' encoding='GB2312'?>")
 d objStream.WriteLine("<ROOT>")
 d objStream.WriteLine("<TABLENAME>")
 d objStream.WriteLine("YY_YY_STEP_CFB")
 d objStream.WriteLine("</TABLENAME>")
 s prescno=""
 f
 {
 s prescno=$o(^DHCSTSENDDATAPRESCDATA("PRESCDATA",pid,prescno))
 q:prescno=""
 s datastr=^DHCSTSENDDATAPRESCDATA("PRESCDATA",pid,prescno)
 s obj=##Class(web.DHCSTGETPRESCDATA).%New() 
 s obj.CFBH=$p(datastr,"^",1)
 s obj.DWBH=$p(datastr,"^",2)
 s obj.SJBBH=$p(datastr,"^",3)
 s obj.HJFSSJ=$p(datastr,"^",4)
 s obj.YWSZXZQH=$p(datastr,"^",5)
 s obj.BZBBH=$p(datastr,"^",6)
 s obj.YLJGMC=$p(datastr,"^",7)
 s obj.KBHBQ=$p(datastr,"^",8) 
 s obj.YSBH=$p(datastr,"^",9)
 s obj.YSMC=$p(datastr,"^",10) 
 s obj.BLH=$p(datastr,"^",11)
 s obj.CWH=$p(datastr,"^",12) 
 s obj.HZBH=$p(datastr,"^",13)
 s obj.HZMC=$p(datastr,"^",14)
 s obj.HZNL=$p(datastr,"^",15)
 s obj.XB=$p(datastr,"^",16)
 s obj.FB=$p(datastr,"^",17)
 //s ^xuantmp("1",pid,prescno)=$p(datastr,"^",18)
 s obj.HZKH=$p(datastr,"^",18)
 s obj.CJSJ=$p(datastr,"^",19)
 s obj.CFLX=$p(datastr,"^",20)
 s obj.HBFL=$p(datastr,"^",21)
 s obj.TSQKSM=$p(datastr,"^",22)
 s obj.CSRQ=$p(datastr,"^",23) 
 
 //s Status=obj.XMLExportToStream(.Xml)
 //s Status=obj.XMLExportToString(.Xml)
 //d objStream.CopyFrom(Xml)
 s Count=Count+1
 s Status=obj.XMLExportToStream(.Xml)
 			While (Xml.AtEnd = 0) {
				d objStream.WriteLine(Xml.Read())
			}
 }
 //Do SetPDefIO^%NLS(currentIO,3)
  d objStream.WriteLine("</ROOT>")
  d objStream.SaveStream()
  
  q "导出文件完成,记录数:"_Count
}

// w ##class(web.DHCSTSENDDATATOLC).GetPrescDataDetaliCFNRB()

// 处方（医嘱）内容表，YY_YY_STEP_CFNRB

ClassMethod GetPrescDataDetaliCFNRB(filename, pid)
{
 //s objStream=##class(%GlobalCharacterStream).%New()
  //Set currentIO = $$GetPDefIO^%NLS(3)
 //Do SetPDefIO^%NLS("UTF8",3)
 s yeartime=$p($zd($p($h,",",1),3),"-",1)_$p($zd($p($h,",",1),3),"-",2)_$p($zd($p($h,",",1),3),"-",3)_$p($zt($p($h,",",2),1),":",1)_$p($zt($p($h,",",2),1),":",2)_$p($zt($p($h,",",2),1),":",3)
 s filename=filename_"\3601001081001_YY_YY_STEP_CFNRB_4462_"_yeartime_".xml"
 Set objStream=##class(%FileCharacterStream).%New()
 Set objStream.Filename=filename //"D:\yyy2.xml"
 d objStream.Clear()
 d objStream.TranslateTableSet("GB18030")
 d objStream.WriteLine("<?xml version='1.0' encoding='GB2312'?>")
 d objStream.Write("<ROOT>")
 d objStream.Write("<TABLENAME>")
 d objStream.Write("YY_YY_STEP_CFNRB")
 d objStream.Write("</TABLENAME>")
 s prescno=""
 s Count=0
  f
 {
  s prescno=$o(^DHCSTSENDDATAPRESCDATA("PRESCDATACFNRB",pid,"CFNRB",prescno))
  q:prescno=""
  s ord=""
 f  
  {
   s ord=$o(^DHCSTSENDDATAPRESCDATA("PRESCDATACFNRB",pid,"CFNRB",prescno,"DETAILCFNRB",ord)) 
   q:ord=""
  s itm=""
 f  
  {
   s itm=$o(^DHCSTSENDDATAPRESCDATA("PRESCDATACFNRB",pid,"CFNRB",prescno,"DETAILCFNRB",ord,"I",itm)) 
   q:itm=""
   s datastr=^DHCSTSENDDATAPRESCDATA("PRESCDATACFNRB",pid,"CFNRB",prescno,"DETAILCFNRB",ord,"I",itm)
   s obj=##Class(web.DHCSTGETPRESCDATADETAILCFNRB).%New() 
   s obj.CFBH =$p(datastr,"^",1)
   s obj.DWBH =$p(datastr,"^",2)
   s obj.SJBBH =$p(datastr,"^",3)
   s obj.CFNRXH =$p(datastr,"^",4)
   s obj.YPBH =$p(datastr,"^",5)
   s obj.YPMC =$p(datastr,"^",6) //"" //
   s obj.ZQSL =$p(datastr,"^",7)
   s obj.YFYL =$p(datastr,"^",8) //"" //
   //w $p(datastr,"^",8),!
   s obj.YPSL =$p(datastr,"^",9)
   s obj.YPDW =$p(datastr,"^",10) //"" //
   s obj.YPDJ =$p(datastr,"^",11)
   s obj.CGLX =$p(datastr,"^",12)
   s obj.BWM =$p(datastr,"^",13)
   s obj.SCQY =$p(datastr,"^",14)
   s obj.JX =$p(datastr,"^",15)
   s obj.GG =$p(datastr,"^",16)
   s obj.BZDW =$p(datastr,"^",17) //"" //
   s obj.YPLX =$p(datastr,"^",18)
   s obj.BZSL =$p(datastr,"^",19)
   s obj.ZXDW =$p(datastr,"^",20) //"" //
   s obj.CGJ =$p(datastr,"^",21)
   s obj.YPQF =$p(datastr,"^",22)
   s obj.YPFL=$p(datastr,"^",23)
   s obj.TSYP =$p(datastr,"^",24)
   s obj.YLFL =$p(datastr,"^",25)
   //s Status=obj.XMLExportToStream(.Xml)
   //s Status=obj.XMLExportToString(.Xml)
   //d objStream.CopyFrom(Xml)
   s Count=Count+1
   s Status=obj.XMLExportToStream(.Xml)
 			While (Xml.AtEnd = 0) {
				d objStream.WriteLine(Xml.Read())
			}
      }
    }
  
 }
  //Do SetPDefIO^%NLS(currentIO,3)
  d objStream.Write("</ROOT>")
  d objStream.SaveStream()
  q "导出文件完成,记录数:"_Count
}

// w ##class(web.DHCSTSENDDATATOLC).GetPrescDataDetaliCFSFB()

// 处方（医嘱）收费表 YY_YY_STEP_CFSFB

ClassMethod GetPrescDataDetaliCFSFB(filename, pid)
{
 //s objStream=##class(%GlobalCharacterStream).%New()
  //Set currentIO = $$GetPDefIO^%NLS(3)
 //Do SetPDefIO^%NLS("UTF8",3)
 s yeartime=$p($zd($p($h,",",1),3),"-",1)_$p($zd($p($h,",",1),3),"-",2)_$p($zd($p($h,",",1),3),"-",3)_$p($zt($p($h,",",2),1),":",1)_$p($zt($p($h,",",2),1),":",2)_$p($zt($p($h,",",2),1),":",3)
 s filename=filename_"\3601001081001_YY_YY_STEP_CFSFB_4462_"_yeartime_".xml"
 Set objStream=##class(%FileCharacterStream).%New()
 Set objStream.Filename=filename //"D:\yyy3.xml" 
 d objStream.Clear()
 d objStream.TranslateTableSet("GB18030")
 d objStream.WriteLine("<?xml version='1.0' encoding='GB2312'?>")
 d objStream.Write("<ROOT>")
 d objStream.Write("<TABLENAME>")
 d objStream.Write("YY_YY_STEP_CFSFB")
 d objStream.Write("</TABLENAME>")
 s prescno=""
 s Count=0
 f  
 {
  s prescno=$o(^DHCSTSENDDATAPRESCDATA("PRESCDATADETAILCFSFB",pid,"CFSFB",prescno)) 
  q:prescno=""  
  s datastr=^DHCSTSENDDATAPRESCDATA("PRESCDATADETAILCFSFB",pid,"CFSFB",prescno)
  s obj=##Class(web.DHCSTGETPRESCDATADETAILCFSFB).%New() 
  s obj.CFBH =$p(datastr,"^",1)
  s obj.DWBH =$p(datastr,"^",2)
  s obj.SJBBH =$p(datastr,"^",3)
  s obj.ZCYFY =$p(datastr,"^",4)
  s obj.ZYFY =$p(datastr,"^",5)
  s obj.XYFY =$p(datastr,"^",6)
  s obj.HYFY =$p(datastr,"^",7)
  s obj.ZLFY =$p(datastr,"^",8)
  s obj.SSFY =$p(datastr,"^",9)
  s obj.CWFY =$p(datastr,"^",10)
  s obj.JCFY =$p(datastr,"^",11)
  s obj.HLFY =$p(datastr,"^",12)
  s obj.QTFY =$p(datastr,"^",13)
  s obj.ZJE =$p(datastr,"^",14)
  s obj.PZL =$p(datastr,"^",15)
  s obj.ZD =$p(datastr,"^",16) //"" //
  s obj.ZYTS =$p(datastr,"^",17)
  //s Status=obj.XMLExportToStream(.Xml)
  //s Status=obj.XMLExportToString(.Xml)
  //d objStream.CopyFrom(Xml)
  s Count=Count+1
  s Status=obj.XMLExportToStream(.Xml)
 			While (Xml.AtEnd = 0) {
				d objStream.WriteLine(Xml.Read())
			}
 }
 
 //Do SetPDefIO^%NLS(currentIO,3)
  d objStream.Write("</ROOT>")
  d objStream.SaveStream()
  q "导出文件完成,记录数:"_Count
}

// w ##class(web.DHCSTSENDDATATOLC).GetPrescDataDetaliCFZDB("D:\yyy5.xml")

// 处方（医嘱）诊断表，YY_YY_STEP_CFZDB

ClassMethod GetPrescDataDetaliCFZDB(filename, pid)
{
 //s objStream=##class(%GlobalCharacterStream).%New()
  //Set currentIO = $$GetPDefIO^%NLS(3)
 //Do SetPDefIO^%NLS("UTF8",3)
 s yeartime=$p($zd($p($h,",",1),3),"-",1)_$p($zd($p($h,",",1),3),"-",2)_$p($zd($p($h,",",1),3),"-",3)_$p($zt($p($h,",",2),1),":",1)_$p($zt($p($h,",",2),1),":",2)_$p($zt($p($h,",",2),1),":",3)
 s filename=filename_"\3601001081001_YY_YY_STEP_CFZDB_4462_"_yeartime_".xml"
 Set objStream=##class(%FileCharacterStream).%New()
 Set objStream.Filename=filename //"D:\yyy2.xml"
 d objStream.Clear()
 d objStream.TranslateTableSet("GB18030")
 d objStream.WriteLine("<?xml version='1.0' encoding='GB2312'?>")
 d objStream.Write("<ROOT>")
 d objStream.Write("<TABLENAME>")
 d objStream.Write("YY_YY_STEP_CFZDB")
 d objStream.Write("</TABLENAME>")
 s prescno=""
 s Count=0
 f  
 {
  s prescno=$o(^DHCSTSENDDATAPRESCDATA("PRESCDATACFZDB",pid,"CFZDB",prescno)) 
  q:prescno=""  
  s cnt=""
  f 
  { 
   s cnt=$o(^DHCSTSENDDATAPRESCDATA("PRESCDATACFZDB",pid,"CFZDB",prescno,"DETAILCFZDB",cnt)) 
   q:cnt=""  
   s datastr=^DHCSTSENDDATAPRESCDATA("PRESCDATACFZDB",pid,"CFZDB",prescno,"DETAILCFZDB",cnt)
   s obj=##Class(web.DHCSTGETPRESCDATADETAILCFZDB).%New() 
   s obj.CFBH =$p(datastr,"^",1)
   s obj.DWBH =$p(datastr,"^",2)
   s obj.SJBBH =$p(datastr,"^",3)
   s obj.ZDBM =$p($p(datastr,"^",4),".",1)
   s obj.ZDMC =$p(datastr,"^",5)
   s obj.ZQSL =$p(datastr,"^",6)
   //s Status=obj.XMLExportToStream(.Xml)
   //s Status=obj.XMLExportToString(.Xml)
   //d objStream.CopyFrom(Xml)
   s Count=Count+1
   s Status=obj.XMLExportToStream(.Xml)
 			While (Xml.AtEnd = 0) {
				d objStream.WriteLine(Xml.Read())
	                   }
	}
  }
  //Do SetPDefIO^%NLS(currentIO,3)
  d objStream.Write("</ROOT>")
  d objStream.SaveStream()
  q "导出文件完成,记录数:"_Count
}

// w ##class(web.DHCSTSENDDATATOLC).GetPrescDataDetaliGHLSH("D:\yyy6.xml")

// 就诊挂号表YY_YY_STEP_GHLSH

ClassMethod GetPrescDataDetaliGHLSH(filename, pid)
{
 //s objStream=##class(%GlobalCharacterStream).%New()
  //Set currentIO = $$GetPDefIO^%NLS(3)
 //Do SetPDefIO^%NLS("UTF8",3)
 s yeartime=$p($zd($p($h,",",1),3),"-",1)_$p($zd($p($h,",",1),3),"-",2)_$p($zd($p($h,",",1),3),"-",3)_$p($zt($p($h,",",2),1),":",1)_$p($zt($p($h,",",2),1),":",2)_$p($zt($p($h,",",2),1),":",3)
 s filename=filename_"\3601001081001_YY_YY_STEP_GHLSH_4462_"_yeartime_".xml"
 Set objStream=##class(%FileCharacterStream).%New()
 Set objStream.Filename=filename //"D:\yyy3.xml"
 d objStream.Clear()
 d objStream.TranslateTableSet("GB18030")
 d objStream.WriteLine("<?xml version='1.0' encoding='GB2312'?>")
 d objStream.Write("<ROOT>")
 d objStream.Write("<TABLENAME>")
 d objStream.Write("YY_YY_STEP_GHLSH")
 d objStream.Write("</TABLENAME>")
 s prescno=""
 s Count=0
 f  
  { 
   s prescno=$o(^DHCSTSENDDATAPRESCDATA("PRESCDATADETAILGHLSH",pid,"GHLSH",prescno)) 
   q:prescno=""  
   s datastr=^DHCSTSENDDATAPRESCDATA("PRESCDATADETAILGHLSH",pid,"GHLSH",prescno)
   s obj=##Class(web.DHCSTGETPRESCDATADETAILGHLSH).%New() 
   s obj.GHLSH =$p(datastr,"^",1)
   s obj.DWBH =$p(datastr,"^",2)
   s obj.BZBBH =$p(datastr,"^",3)
   s obj.SJBBH =$p(datastr,"^",4)
   s obj.GHSJ =$p(datastr,"^",5)
   s obj.THSJ =$p(datastr,"^",6)
   s obj.CFLX =$p(datastr,"^",7)
   //s Status=obj.XMLExportToStream(.Xml)
   //s Status=obj.XMLExportToString(.Xml)
   //d objStream.CopyFrom(Xml)
   s Count=Count+1
   s Status=obj.XMLExportToStream(.Xml)
 			While (Xml.AtEnd = 0) {
				d objStream.WriteLine(Xml.Read())
	                   } 
  }
 //Do SetPDefIO^%NLS(currentIO,3)
  d objStream.Write("</ROOT>")
  d objStream.SaveStream()
  q "导出文件完成,记录数:"_Count
}

// d ##class(web.DHCSTSENDDATATOLC).GetPrescDRUGMATDATABYMONTH()

ClassMethod GetPrescDRUGMATDATABYMONTH() As %String
{
 
 s lastmonenddr=$p($h,",",1)-1
 s lastmonenddesc=$zd(lastmonenddr,3)
 s lastmonstartdesc=$p(lastmonenddesc,"-",1)_"-"_$p(lastmonenddesc,"-",2)_"-"_"1"
 s lastmonstartdr=$zdh(lastmonstartdesc,3)
 
 s std=lastmonstartdr,edd=lastmonenddr,stt=$zth("00:00:00",1),edt=$zth("23:59:59",1)
	
 
  s pid=..GetPRESCDDRUMATDATA(std,stt,edd,edt)
  d ..GetPrescDrugMatData("\\172.18.100.18\e$\Ygyy",pid)
  k ^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid)
}

// d ##class(web.DHCSTSENDDATATOLC).GetPrescDRUGMATDATABYMONTHSGDC("2013-03-06","00:00:00","2013-03-06","23:59:59","D:")

ClassMethod GetPrescDRUGMATDATABYMONTHSGDC(Stdate, Sttime, Eddata, Edtime, Filname) As %String
{
 s std=$zdh(Stdate,3),edd=$zdh(Eddata,3),stt=$zth(Sttime,1),edt=$zth(Edtime,1)
  s pid=..GetPRESCDDRUMATDATA(std,stt,edd,edt)
  d ..GetPrescDrugMatData(Filname,pid)
  k ^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid)
}

/// Creator:wyx
/// CreatDate:2012-11-02
/// Description:获取药品（耗材）库存
/// Table:INC_Itm,DHC_INTRANS
/// Input:
/// Return:获取药品（耗材）库存
/// w ##class(web.DHCSTSENDDATATOLC).GetPRESCDDRUMATDATA()
ClassMethod GetPRESCDDRUMATDATA(std, stt, edd, edt) As %String
{
 s pid=$i(^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA"))
 k ^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid)
 //s objStream=##class(%GlobalCharacterStream).%New()
 //d objStream.Write("<ROOT>")
 //s lastmonenddr=$p($h,",",1)-1
 //s lastmonenddesc=$zd(lastmonenddr,3)
 //s lastmonstartdesc=$p(lastmonenddesc,"-",1)_"-"_$p(lastmonenddesc,"-",2)_"-"_"1"
 //s lastmonstartdr=$zdh(lastmonstartdesc,3)
 
 //s std=lastmonstartdr,edd=lastmonenddr,stt=$zth("00:00:00",1),edt=$zth("23:59:59",1)
	
 //s std=$zdh(Stdate,3),edd=$zdh(Eddata,3),stt=$zth(Sttime,1),edt=$zth(Edtime,1)
 s paadmtime="",paadmdr="",mdata=""
 q:std>edd
 s intrdr=""
 //ZYK-中药库 QXK-器械库  CYK-草药库	XYK-西药库
 s locdrstr="167^169^168^166"  //临时写死科室
 //入库（入库和退货），出库（转移入库和转移出库）
 f mdata=std:1:edd d
 .f  s intrdr=$o(^DHCINTR(0,"Date",mdata,intrdr)) q:intrdr=""  d 
 ..s intrtype=$p(^DHCINTR(intrdr),"^",1)
 ..s inclbdr=$p(^DHCINTR(intrdr),"^",7)
 ..s locdr=$p(^INCI(+inclbdr,"IL",$p(inclbdr,"||",2)),"^",1)
 ..q:$f(locdrstr,locdr)=0  
 ..q:$f("G,R,T,K",intrtype)=0
 ..
 ..s paadmtime=$p(^DHCINTR(intrdr),"^",3)
 ..q:(mdata=std)&&(paadmtime'="")&&(paadmtime<stt)
 ..q:(mdata=edd)&&(paadmtime'="")&&(paadmtime>edt)
 ..s departcode="4462"    //单位编码
 ..s dataeditno="1"       //数据版本号
 ..s workdate=$zd(mdata,3) //_" "_$zt(paadmtime,1) //发生时间
 ..s inci=$p(^DHCINTR(intrdr),"^",15) //药品(材料)编码
 ..s happendate=$zd($p($h,",",1),3) //_" "_$zt($p($h,",",2),1) //环节发生时间
 ..s departarea="360000"   //业务所在行政区划
 ..s incsc=$p(^INCI(inci,2),"^",2)
 ..q:$g(incsc)=""                              ;库存小类
 ..;s incscg=$o(^DHCSCG("^DHCSCG",incsc,"")) 
 ..s incscg=$o(^DHCSCG("STKCAT",incsc,""))
 ..q:$g(incscg)=""    ;库存大类
 ..s scgtype=$p(^DHCSCG(incscg),"^",3) ;库存类别
 ..q:(scgtype'="M")&&(scgtype'="G")
 ..i scgtype="G" s scgtypedesc="1"    //药品（耗材）分类
 ..i scgtype="M" s scgtypedesc="2"
 ..s incidesc=$p(^INCI(inci,1),"^",2) //药品（耗材）名称
 ..s intrqty=$p(^INCI(inci,1),"^",6)
 ..s intrqty=$p(^DHCINTR(intrdr),"^",6)
 ..//s intrqty=$p(^INCI(inci,1),"^",6)
 ..s intruom=$p(^DHCINTR(intrdr),"^",10)
 ..//s intruom=$p(^INCI(inci,1),"^",10)
 ..s intrsp=$p(^DHCINTR(intrdr),"^",14)        ;业务发生的售价
 ..//s intrsp=$p(^INCI(inci,1),"^",14)
 ..S PuomStr=..GetIncPuom(inci)		//入库单位串
 ..S PuomDr=$P(PuomStr,"^",1)									//入库单位ID
 ..S PuomDesc=$P(PuomStr,"^",2)									//入库单位描述
 ..S BuomStr=..GetIncBuom(inci)					//基本单位串
 ..S BuomDr=$P(BuomStr,"^",1)									//基本单位ID
 ..S BuomDesc=$P(BuomStr,"^",2)									//基本单位描述
 ..S PFac=..UOMFac(PuomDr,BuomDr)
 ..S PuomQty=0
 ..s PuomSP=0
 ..I PFac'=0  d
 ...i intruom=PuomDr d
 ....S PuomQty=intrqty
 ....s PuomSP=intrsp
 ...i intruom=BuomDr d 
 ....s PuomQty=intrqty/PFac      //入库单位数量
 ....s PuomSP=intrsp*PFac        //入库单位售价
 ..s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) 		//厂家    //生产企业						
 ..i manf="" s manf="不详"
 ..i incidesc [ "-" s postdesc=$p(incidesc,"-",2)                         //注册证产品名称
 ..e  s postdesc=incidesc
 ..s producttype=""                         //产品类别
 ..s postcode=..GetRemark(inci)               //注册证编号
 ..s postexpdate=" "                           //注册证有效期
 ..s brand=""                                 //品牌
 ..s gpesc=""                                  //规格型号
 ..s yyuom=""                                   //单位
 ..s bidprice=""                                //中标价
 ..s packqty=PFac                               //包装数量
 ..s inciworktype=""                               
 ..i (intrtype="G")||(intrtype="R")  d
 ...s inciworktype="1"                        //库存管理
 ..e  i (intrtype="T")||(intrtype="K")  d
 ...s inciworktype="2"                        //库存管理 
 ..s itmmast=$p(^INCI(inci,1),"^",3)
 ..s inciYBtypedr=""
 ..i itmmast'="" d
 ...s prescdrgform=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",12)
 ...s prescdrgmast=$p(prescdrgform,"||",1)
 ...i prescdrgmast'=0 s inciYBtypedr=+$p($g(^PHCD(prescdrgmast,4)),"^",2) //列入医保
 ..i inciYBtypedr="甲类" s inciYBtype="1"
 ..e  i inciYBtypedr="乙类" s inciYBtype="2"
 ..e  i inciYBtypedr="丙类" s inciYBtype="3"
 ..e  s inciYBtype="0"
 ..s purtype="4"                //采购类型  待定？？
 ..
 ..i manf [ "-" s manf=$p(manf,"-",2)
 ..i '$d(^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid,workdate,inci,inciworktype)) d 
 ...s ^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid,workdate,inci,inciworktype)=departcode_"^"_dataeditno_"^"_workdate_"^"_inci_"^"_happendate_"^"_departarea_"^"_scgtypedesc_"^"_incidesc_"^"_PuomQty_"^"_PuomSP_"^"_manf_"^"_postdesc_"^"_producttype_"^"_postcode_"^"_postexpdate_"^"_brand_"^"_gpesc_"^"_yyuom_"^"_bidprice_"^"_packqty_"^"_inciworktype_"^"_inciYBtype_"^"_purtype                        
 ..e  d
 ...s $p(^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid,workdate,inci,inciworktype),"^",9)=$p(^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid,workdate,inci,inciworktype),"^",9)+PuomQty
 ..
 ..
 //盘点
 
 s inci=""
 s mdata=$o(^DHCLOCTOT(0,"Date",edd),-1)
 s cnt=$l(locdrstr,"^")
 f i=1:1:cnt d
 .s locdr=$p(locdrstr,"^",i)
 .s HospID=$p($g(^CTLOC(locdr)),"^",22)
 .f  s inci=$o(^DHCLOCTOT(0,"Date",mdata,locdr,inci)) q:inci=""  d
 ..s departcode="4462"    //单位编码
 ..s dataeditno="1"       //数据版本号
 ..s workdate=$zd(mdata,3) //_" "_$zt(paadmtime,1) //发生时间
 ..s happendate=$zd($p($h,",",1),3) //_" "_$zt($p($h,",",2),1) //环节发生时间
 ..s departarea="360000"   //业务所在行政区划
 ..s incsc=$p(^INCI(inci,2),"^",2)
 ..q:$g(incsc)=""                              ;库存小类
 ..;s incscg=$o(^DHCSCG("^DHCSCG",incsc,"")) 
 ..s incscg=$o(^DHCSCG("STKCAT",incsc,""))
 ..q:$g(incscg)=""    ;库存大类
 ..s scgtype=$p(^DHCSCG(incscg),"^",3) ;库存类别
 ..q:(scgtype'="M")&&(scgtype'="G")
 ..i scgtype="G" s scgtypedesc="1"    //药品（耗材）分类
 ..i scgtype="M" s scgtypedesc="2"
 ..s incidesc=$p(^INCI(inci,1),"^",2) //药品（耗材）名称
 ..//s intrqty=$p(^DHCINTR(intrdr),"^",6)
 ..
 ..//s intrqty=$p(^INCI(inci,1),"^",6)
 ..//s intruom=$p(^DHCINTR(intrdr),"^",10)
 ..//s intruom=$p(^INCI(inci,1),"^",10)
 ..//s intrsp=$p(^DHCINTR(intrdr),"^",14)        ;业务发生的售价
 ..//s intrsp=$p(^INCI(inci,1),"^",14)
 ..S PuomStr=..GetIncPuom(inci)		//入库单位串
 ..S PuomDr=$P(PuomStr,"^",1)									//入库单位ID
 ..S PuomDesc=$P(PuomStr,"^",2)									//入库单位描述
 ..S BuomStr=..GetIncBuom(inci)					//基本单位串
 ..S BuomDr=$P(BuomStr,"^",1)									//基本单位ID
 ..s daydr=$o(^DHCLOCTOT(0,"Date",mdata,locdr,inci,""),-1)
 ..s intrqty=$p(^DHCLOCTOT(daydr),"^",4)
 ..s intruom=BuomDr
 ..S intrsp=##class(web.DHCSTPRICE).GetSp(inci,mdata,BuomDr,HospID,"","")
 ..//S intrsp=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,mdata,BuomDr)
 ..
 ..S BuomDesc=$P(BuomStr,"^",2)									//基本单位描述
 ..S PFac=..UOMFac(PuomDr,BuomDr)
 ..S PuomQty=0
 ..s PuomSP=0
 ..I PFac'=0  d
 ...i intruom=PuomDr d
 ....S PuomQty=intrqty
 ....s PuomSP=intrsp
 ...i intruom=BuomDr d 
 ....s PuomQty=intrqty/PFac      //入库单位数量
 ....s PuomSP=intrsp*PFac        //入库单位售价
 ..s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) 		//厂家    //生产企业						
 ..i manf="" s manf="不详"
 ..//i manf="" s ^xuantmp("SCQY")=""
 ..i incidesc [ "-" s postdesc=$p(incidesc,"-",2)                         //注册证产品名称
 ..e  s postdesc=incidesc
 ..s producttype=""                         //产品类别
 ..s postcode=..GetRemark(inci)               //注册证编号
 ..s postexpdate=""                           //注册证有效期
 ..s brand=""                                 //品牌
 ..s gpesc=""                                  //规格型号
 ..s yyuom=""                                   //单位
 ..s bidprice=""                                //中标价
 ..s packqty=PFac                               //包装数量                              
 ..s inciworktype="3"                        //库存管理 
 ..s itmmast=$p(^INCI(inci,1),"^",3)
 ..s inciYBtypedr=""
 ..i itmmast'="" d
 ...s prescdrgform=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",12)
 ...s prescdrgmast=$p(prescdrgform,"||",1)
 ...i prescdrgmast'=0 s inciYBtypedr=+$p($g(^PHCD(prescdrgmast,4)),"^",2) //列入医保
 ..i inciYBtypedr="甲类" s inciYBtype="1"
 ..e  i inciYBtypedr="乙类" s inciYBtype="2"
 ..e  i inciYBtypedr="丙类" s inciYBtype="3"
 ..e  s inciYBtype="0"
 ..s purtype="4"                //采购类型  待定？？
 ..i manf [ "-" s manf=$p(manf,"-",2)
 ..i '$d(^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid,workdate,inci,inciworktype)) d
 ...s ^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid,workdate,inci,inciworktype)=departcode_"^"_dataeditno_"^"_workdate_"^"_inci_"^"_happendate_"^"_departarea_"^"_scgtypedesc_"^"_incidesc_"^"_PuomQty_"^"_PuomSP_"^"_$p(manf,"-",2)_"^"_postdesc_"^"_producttype_"^"_postcode_"^"_postexpdate_"^"_brand_"^"_gpesc_"^"_yyuom_"^"_bidprice_"^"_packqty_"^"_inciworktype_"^"_inciYBtype_"^"_purtype                        
 ..e  d
 ...s $p(^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid,workdate,inci,inciworktype),"^",9)=$p(^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid,workdate,inci),"^",9)+PuomQty
 ..
 q pid
}

// w ##class(web.DHCSTSENDDATATOLC).GetPrescDrugMatData()

// YY_YY_STEP_YPKCGL

ClassMethod GetPrescDrugMatData(filename, pid)
{
 //s objStream=##class(%GlobalCharacterStream).%New()
 //Set currentIO = $$GetPDefIO^%NLS(3)
 //Do SetPDefIO^%NLS("UTF8",3)
 s yeartime=$p($zd($p($h,",",1),3),"-",1)_$p($zd($p($h,",",1),3),"-",2)_$p($zd($p($h,",",1),3),"-",3)_$p($zt($p($h,",",2),1),":",1)_$p($zt($p($h,",",2),1),":",2)_$p($zt($p($h,",",2),1),":",3)
 s filename=filename_"\3601001081001_YY_YY_STEP_YPKCGL_4462_"_yeartime_".xml"
 Set objStream=##class(%FileCharacterStream).%New()
 Set objStream.Filename=filename //"D:\yyy4.xml"
 d objStream.Clear()
 d objStream.TranslateTableSet("GB18030")
 d objStream.WriteLine("<?xml version='1.0' encoding='GB2312'?>")
 d objStream.Write("<ROOT>")
 d objStream.Write("<TABLENAME>")
 d objStream.Write("YY_YY_STEP_YPKCGL")
 d objStream.Write("</TABLENAME>")
 s mdata=""
 s Count=0
 f  
  {
    s mdata=$o(^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid,mdata)) 
    q:mdata=""  
    s inci="" 
    f
    {
	  s inci=$o(^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid,mdata,inci)) 
	  q:inci=""  
      s type=""
      f
      {
	   s type=$o(^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid,mdata,inci,type)) 
	   q:type="" 
       s datastr=^DHCSTSENDDATAPRESCDATA("PRESCDRUMATDATA",pid,mdata,inci,type)
       s obj=##Class(web.DHCSTPRESCDDRUMATDATA).%New()
       s obj.DWBH =$p(datastr,"^",1)
       s obj.SJBBH =$p(datastr,"^",2)
       s obj.FSSJ =$p(datastr,"^",3)
       s obj.YPBH =$p(datastr,"^",4)
       s obj.HJFSSJ =$p(datastr,"^",5)
       s obj.YWSZXZQH =$p(datastr,"^",6)
       s obj.YPHCFL =$p(datastr,"^",7)
       s obj.YPMC =$p(datastr,"^",8) //"" //
       s obj.SL =$p(datastr,"^",9)
       s obj.JG =$p(datastr,"^",10)
       s obj.SCQY =$p(datastr,"^",11) //"" //
       s obj.ZCZSPMC =$p(datastr,"^",12)
       s obj.CPLX =$p(datastr,"^",13)
       s obj.ZCZBH =$p(datastr,"^",14) //"" //
       s obj.ZCZYXQ =$p(datastr,"^",15)
       s obj.PP =$p(datastr,"^",16)
       s obj.GGLX =$p(datastr,"^",17)
       s obj.DW =$p(datastr,"^",18) //"" //
       s obj.ZBJ =$p(datastr,"^",19)
       s obj.BZSL =$p(datastr,"^",20)
       s obj.KCGL =$p(datastr,"^",21)
       s obj.LRYB =$p(datastr,"^",22)
       s obj.CGLX =$p(datastr,"^",23)
  
       //s Status=obj.XMLExportToStream(.Xml)
       //s Status=obj.XMLExportToString(.Xml)
       //d objStream.CopyFrom(Xml)
       s Count=Count+1
       s Status=obj.XMLExportToStream(.Xml)
 			While (Xml.AtEnd = 0) {
				d objStream.WriteLine(Xml.Read())
	                   }
      }
    }
  }
  //Do SetPDefIO^%NLS(currentIO,3)
  d objStream.Write("</ROOT>")
  d objStream.SaveStream()
 q "导出文件完成,记录数:"_Count
}

ClassMethod GetAge(papmidr As %String) As %String
{
	//根据患者rowid取出年龄
	n (papmidr)
	s argBirthday=$p(^PAPER(papmidr,"ALL"),"^",6)
 q:(+argBirthday=0) ""
 q:(+papmidr=0) ""
 s argAdmDate=$p($h,",",1)
 s tmpAge="",ageYears=0,ageMonths=0,ageDays=0,age=""
 s tmpAge=$$CalAge^at182(argBirthday,argAdmDate)
 i (tmpAge'="")&&($l(tmpAge,"|")'<14) d
 .s ageYears=$p(tmpAge,"|",12)
 .s ageMonths=$p(tmpAge,"|",13)
 .s ageDays=$p(tmpAge,"|",14)
 .i ageYears>5 s age=ageYears_"岁"
 .e  d
 ..i (ageYears'=0) s age=ageYears_"岁"_ageMonths_"月"
 ..e  d
 ...i (ageMonths'=0) s age=ageMonths_"月"_ageDays_"天"
 ...e  d
 ....i (ageDays>28) s age="1月"_(ageDays-28)_"天"
 ....e  s age=ageDays_"天"
 e  d
 .s age=""
 q age
}

ClassMethod GetPhcGenricByInci(inciid)
{
	 ;根据库存项ROWID获得药学项的通用名的描述
 n (inciid)
 q:inciid="" ""
 s phcgedesc=""
 s arcim=$p(^INCI(inciid,1),"^",3) q:arcim="" ""
 s sub=$p(arcim,"||",1) q:sub="" ""
 s ver=$p(arcim,"||",2)  q:ver="" ""
 q:($d(^ARCIM(sub,ver,1))=0)!($d(^ARCIM(sub,ver,1))=10) ""
 s drgfrm=$p(^ARCIM(sub,ver,1),"^",12) q:drgfrm="" ""
 s drgmst=+drgfrm q:drgmst="" ""
 i $d(^PHCD(drgmst,4)) d
 . s phcge=$p(^PHCD(drgmst,4),"^",1)
 . q:phcge=""
 . i $d(^PHCGE("GE",phcge)) d
 .. s phcgedesc=$p(^PHCGE("GE",phcge),"^",2)
 .
 q $g(phcgedesc)
}

ClassMethod GetForm(inci As %String) As %String
{
    n (inci)
    s phcform=""	    
    &sql(select inci_arcim_dr->arcim_phcdf_dr->phcdf_PHCF_DR->phcf_desc 
    into :phcform
    from inc_itm where inci_rowid=:inci)
    q $g(phcform)
}

ClassMethod GetSpec(inci As %String) As %String
{
	N (inci)
	S info=$O(^DHCITMINFO(0,"INCI",inci,""))
	Q:info="" ""
	Q:'$D(^DHCITMINFO(info)) ""
	S spec=$P(^DHCITMINFO(info),"^",27)
	Q spec
}

ClassMethod GetBaseFlag(inci As %String) As %String
{
	N (inci)
	S info=$O(^DHCITMINFO(0,"INCI",inci,""))
	Q:info="" ""
	Q:'$D(^DHCITMINFO(info)) ""
	S Baseflag=$P(^DHCITMINFO(info),"^",4)
	Q Baseflag
}

ClassMethod UOMFac(fr As %String, to As %String)
{
 //n (fr,to)
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

ClassMethod CheckPoison(poisondesc)
{
	 i poisondesc="" q 4
	 i poisondesc["麻醉" q 1
	 i poisondesc["一类精神" q 2
	 i poisondesc["二类精神" q 3
	 
	 q 4
}

ClassMethod GetPatInfo(papmidr)
{
 N (papmidr)
 Q:papmidr="" ""
 Q:'$D(^PAPER(papmidr))
 s sexdr=$p($g(^PAPER(papmidr,"ALL")),"^",7)
 s sex=""
 i sexdr'="" s sex=$p(^CT("SEX",sexdr),"^",2)
 s dob=$p($g(^PAPER(papmidr,"ALL")),"^",6)
 S CardID=$O(^DHCCARDi("CF",0,"PAPMIDR",papmidr,""),-1)
 S CardNo=""
 I CardID'="" S CardNo=$P($G(^DHCCARD("CF",CardID)),"^",2)
 S PayType=""
 S SocialStatusID=$P(^PAPER(papmidr,"PER",1),"^",10)
 I SocialStatusID'="" S PayType=$P($G(^CT("SS",SocialStatusID)),"^",2)
 S ret=sex_"^"_dob_"^"_CardNo_"^"_PayType
 Q ret
}

/// 按照ADMDR查询医保就诊信息
/// web.DHCINSUAdmInfoCtl.GetInfoByAdm(AdmRowid)
ClassMethod GetInfoByAdm(AdmRowid As %String) As %String
{
	
	;n (AdmRowid)
	q:AdmRowid="" -1
	q:$d(^DHCINADM("0","ADM",AdmRowid))=0 -100
	s InfoId="",flag=""
	s InfoId=$o(^DHCINADM("0","ADM",AdmRowid,InfoId),-1)
	s OutStr=..GetInfoById(InfoId)
	s GetInfoByAdm="1!"_OutStr
	q GetInfoByAdm
}

/// 按照ID取医保就诊信息
ClassMethod GetInfoById(InfoId As %String) As %String
{
	;n (InfoId)
	q ""
	zn "medsrc"
	s GetInfoById=$$GetInfoById^DHCINSUAdmInfo(InfoId)
	zn "dhc-app"
	q GetInfoById
}

ClassMethod GetRemark(inci As %String) As %String
{
	N (inci)
	S info=$O(^DHCITMINFO(0,"INCI",inci,""))
	Q:info="" ""
	Q:'$D(^DHCITMINFO(info)) ""
	S remark=$P(^DHCITMINFO(info),"^",10)
	Q remark
}

/// 根据就诊获取病人费用信息
/// input:admid,pattype(O门诊I住院)
/// output：patinfostr(信息拼接串)
/// debuger:w ##class(web.UDHCJFBaseCommon).GetPatInfoByAdm("2","O")
ClassMethod GetPatInfoByAdm(admid, pattype)
{
	//s guser=$g(%session.Data("LOGON.USERID"))
	s guser="user"
	k ^TMP("AdmTotal")
	s (sjbbh,zcyfy,zyfy,xyfy,hyfy,zlfy,ssfy,cwfy,jcfy,hlfy,qtfy,zje,pzl,zlts)=0
	s dwbh="4462"
	s zd=""
	s AdmDate=$p(^PAADM(+admid),"^",6)	
	s MRADMDR=$p($g(^PAADM(+admid)),"^",61)
	quit:MRADMDR="" return
	s MrSub=0 f  s MrSub=$o(^MR(+MRADMDR,"DIA",MrSub)) q:MrSub=""  d
		
 	.s DiagID=$p($g(^MR(MRADMDR,"DIA",MrSub)),"^",1)
 	.q:$g(DiagID)=""
 	.s DiagDesc=$P($g(^MRC("ID",DiagID)),"^",2)
 	.i DiagDesc["-" Set DiagDesc=$P(DiagDesc,"_",2)
 	.i zd="" Set zd=DiagDesc
 	.e  Set zd=zd_","_DiagDesc
 	i zd="" s zd="待查"	 
 	//s ^xuantmp("fee11",admid,pattype)=zje
	i pattype="O"  d ;门诊
	.//s ^xuantmp("fee22",admid,pattype)=zje
	.s invconrowid=""  f  s invconrowid=$o(^DHCBCI(0,"ADM",admid,invconrowid)) q:invconrowid=""  d
	..//s ^xuantmp("fee33",admid,invconrowid)=zje
	..s prtrowid=$p(^DHCBCI(invconrowid),"^",1)
	..s zje=zje+$p(^DHCINVPRT(prtrowid),"^",1)
	..//s ^xuantmp("fee",admid,invconrowid)=zje
	..s billrowid=$p(^DHCBCI(invconrowid),"^",2)
	..s Orderid="" f  s Orderid=$o(^DHCPB(billrowid,"O",Orderid)) q:Orderid=""  d 
	...s pzl=pzl+1
    ...s billdetailId=""  f  s billdetailId=$o(^DHCPB(billrowid,"O",Orderid,"D",billdetailId))  q:billdetailId=""  d    
    ....s BillTotal=$p(^DHCPB(billrowid,"O",Orderid,"D",billdetailId),"^",7)     ;详单金额
    ....q:$p(^DHCPB(billrowid,"O",Orderid,"D",billdetailId),"^",7)=""
    ....s TarDr=$p(^DHCPB(billrowid,"O",Orderid,"D",billdetailId),"^",3) ;取收费项指针
    ....s TarAccDr=$p(^DHCTARI(TarDr),"^",5)  ;取会计分类指针
    ....S TarAccCode=""
    ....I TarAccDr'="" D
    .....s TarAccCode=$p(^DHCTarC("AC",TarAccDr),"^",2)  ;会计分类代码
    ....i TarAccCode]"中成药,中草药,西药,化验费,治疗费,手术费,床位费,检查费,护理费" d
    .....s ^TMP("AdmTotal",guser,$j,TarAccCode)=$g(^TMP("AdmTotal",guser,$j,TarAccCode))+BillTotal
    ....e  d
    .....s ^TMP("AdmTotal",guser,$j,"其他")=$g(^TMP("AdmTotal",guser,$j,"其他"))+BillTotal
	.s zcyfy=+$g(^TMP("AdmTotal",guser,$j,"中成药"))
	.s zyfy=+$g(^TMP("AdmTotal",guser,$j,"中草药"))
	.s xyfy=+$g(^TMP("AdmTotal",guser,$j,"西药"))
	.s hyfy=+$g(^TMP("AdmTotal",guser,$j,"化验费"))
	.s zlfy=+$g(^TMP("AdmTotal",guser,$j,"治疗费"))
	.s ssfy=+$g(^TMP("AdmTotal",guser,$j,"手术费"))
	.s cwfy=+$g(^TMP("AdmTotal",guser,$j,"床位费"))
	.s jcfy=+$g(^TMP("AdmTotal",guser,$j,"检查费"))
	.s hlfy=+$g(^TMP("AdmTotal",guser,$j,"护理费"))
	.s qtfy=+$g(^TMP("AdmTotal",guser,$j,"其他"))
	.s admid=admid_"_"_"OUT"
	i pattype="I" d ;住院
	.s DischDate=$p(^PAADM(+admid),"^",3)
    .i DischDate=""  s DischDate=+$h
    .s zlts=DischDate-AdmDate
	.s billrowid=""  f  s billrowid=$o(^DHCPB(0,"ADM",+admid,billrowid)) q:billrowid=""  d
    ..s BillFlag=$p(^DHCPB(billrowid),"^",16)
    ..;q:BillFlag'="P"  ;只统计结算的  
    ..s PBAmount=$p(^DHCPB(billrowid),"^",8)
	..s zje=zje+PBAmount
	..s Orderid="" f  s Orderid=$o(^DHCPB(billrowid,"O",Orderid)) q:Orderid=""  d 
	...s pzl=pzl+1
    ...s billdetailId=""  f  s billdetailId=$o(^DHCPB(billrowid,"O",Orderid,"D",billdetailId))  q:billdetailId=""  d    
    ....s BillTotal=$p(^DHCPB(billrowid,"O",Orderid,"D",billdetailId),"^",7)     ;详单金额
    ....q:$p(^DHCPB(billrowid,"O",Orderid,"D",billdetailId),"^",7)=""
    ....s TarDr=$p(^DHCPB(billrowid,"O",Orderid,"D",billdetailId),"^",3) ;取收费项指针
    ....s TarAccDr=$p(^DHCTARI(TarDr),"^",5)  ;取会计分类指针
    ....S TarAccCode=""
    ....I TarAccDr'="" D
    .....s TarAccCode=$p(^DHCTarC("AC",TarAccDr),"^",2)  ;会计分类代码
    ....i TarAccCode]"中成药,中草药,西药,化验费,治疗费,手术费,床位费,检查费,护理费" d
    .....s ^TMP("AdmTotal",guser,$j,TarAccCode)=$g(^TMP("AdmTotal",guser,$j,TarAccCode))+BillTotal
    ....e  d
    .....s ^TMP("AdmTotal",guser,$j,"其他")=$g(^TMP("AdmTotal",guser,$j,"其他"))+BillTotal
	.s zcyfy=+$g(^TMP("AdmTotal",guser,$j,"中成药"))
	.s zyfy=+$g(^TMP("AdmTotal",guser,$j,"中草药"))
	.s xyfy=+$g(^TMP("AdmTotal",guser,$j,"西药"))
	.s hyfy=+$g(^TMP("AdmTotal",guser,$j,"化验费"))
	.s zlfy=+$g(^TMP("AdmTotal",guser,$j,"治疗费"))
	.s ssfy=+$g(^TMP("AdmTotal",guser,$j,"手术费"))
	.s cwfy=+$g(^TMP("AdmTotal",guser,$j,"床位费"))
	.s jcfy=+$g(^TMP("AdmTotal",guser,$j,"检查费"))
	.s hlfy=+$g(^TMP("AdmTotal",guser,$j,"护理费"))
	.s qtfy=+$g(^TMP("AdmTotal",guser,$j,"其他"))
	.s admid=admid_"_"_"IN"
	s patinfo=admid_"^"_dwbh_"^"_sjbbh_"^"_zcyfy_"^"_zyfy_"^"_xyfy_"^"_hyfy_"^"_zlfy_"^"_ssfy_"^"_cwfy_"^"_jcfy_"^"_hlfy_"^"_qtfy_"^"_zje_"^"_pzl_"^"_zd_"^"_zlts
	q patinfo
}

/// 转换门诊发药数量
ClassMethod getPackQty(inci, qty) As %String
{
	n (inci,qty)
	s result=""
	s buom=+$p(^INCI(inci,1),"^",10)  ; basic uom
	s puom=+$p(^INCI(inci,3),"^",6)  ; 
	i puom="" s puom=buom
	s buomdesc=$p(^CT("UOM",buom),"^",2)
	s puomdesc=$p(^CT("UOM",puom),"^",2)
	;
	s confac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
    i qty#confac=0 d
    .s qty=qty/confac
    .s inciuom=puomdesc
    .s inciuomId=puom
    e  d
    .s inciuom=buomdesc
    .s inciuomId=buom
	q qty_"^"_inciuom_"^"_inciuomId
}

/// Descript:	根据库存项ID取入库单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	入库单位ID^入库单位描述
ClassMethod GetIncPuom(InciDr)
{
 N (InciDr)
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S puomdr=$P(^INCI(InciDr,3),"^",6)
 Q:puomdr="" ""
 Q:'$D(^CT("UOM",puomdr)) ""
 S puomdesc=$P(^CT("UOM",puomdr),"^",2)
 Q puomdr_"^"_puomdesc
}

/// Descript:	根据库存项ID取基本单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	基本单位ID^基本单位描述
ClassMethod GetIncBuom(InciDr)
{
 N (InciDr)
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S buomdr=$P(^INCI(InciDr,1),"^",10)
 Q:buomdr="" ""
 Q:'$D(^CT("UOM",buomdr)) ""
 S buomdesc=$P(^CT("UOM",buomdr),"^",2)
 Q buomdr_"^"_buomdesc
}

/// Creator:      郭荣勇
/// CreatDate:    2010.10.20
/// Description:  查询病人诊断信息
ClassMethod DiagnosisRecord(EpisodeID, pid)
{
 if EpisodeID="" Set QHandle=$lb(0,repid,0) Quit $$$OK
	 s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	 if MRAdmRowid="" Set QHandle=$lb(0,repid,0) Quit $$$OK
	 s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	 s AdmNo=$p($g(^PAADM(EpisodeID)),"^",81)
	 s PapmiRowid=$p(^PAADM(EpisodeID),"^",1)
	 s OPNo="",IPNo=""
	 if PapmiRowid'="" {
		 S OPNo=$p(^PAPER(PapmiRowid,"PAT",1),"^",2)
		 S IPNo=$p(^PAPER(PapmiRowid,"PAT",1),"^",1)
	 }
	 if AdmType="I" d 
	 .s PutAdmType=1
	 .s prescno=paadmdr_"_"_"IN" //处方编码
	 else  i AdmType="E" d
	 .s PutAdmType=2
	 .s prescno=paadmdr_"_"_"EMER" //处方编码
	 else   d
	 .s PutAdmType=2
	 .s prescno=paadmdr_"_"_"OUT" 
	 s MRDiagnosStr="",myRtnDiagnosStr="",FindFlag=0
	 s num=0
	 s ChildSub=0
	 for {
		s ChildSub=$O(^MR(MRAdmRowid,"DIA",ChildSub))
		Q:ChildSub=""
		s MRRowid=MRAdmRowid_"||"_ChildSub
		s ICDCodeDR=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",1)
		s MRDIADate=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",7)
		s MRDIATime=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",8)
		;s MRDIAActive=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",1)
		s MRCIDDesc="",ICD9CMCode=""
		if ICDCodeDR'="" {
			s MRCIDDesc=$p($g(^MRC("ID",ICDCodeDR)),"^",2)
			s ICD9CMCode=$p($g(^MRC("ID",ICDCodeDR)),"^",4)
			s BillFlag3=$p($g(^MRC("ID",ICDCodeDR)),"^",15)
		}
		else
        {
	        s MRCIDDesc=$p($g(^MR(MRAdmRowid,"DIA",ChildSub,"DES",1)),"^",1)   
	         
         }
		//q:MRCIDDesc=""
		s MRCDiagTypCode="",MRCDiagTypDesc=""
		s TYPChildSub=0
		for {
			s TYPChildSub=$O(^MR(MRRowid,"DIA",ChildSub,"TYP",TYPChildSub))
			Q:TYPChildSub=""
			s MRCDiagTypID=$p($g(^MR(MRRowid,"DIA",ChildSub,"TYP",TYPChildSub)),"^",1)
			if MRCDiagTypID'="" {
				s MRCDiagTypCode=$p($g(^MRC("DTYP",MRCDiagTypID)),"^",1)
				s MRCDiagTypDesc=$p($g(^MRC("DTYP",MRCDiagTypID)),"^",2)
			}
			
			if (AdmType="I")||(AdmType="E") {
				if (MRCDiagTypCode="M")||(MRCDiagTypCode="DIS") {
					s FindFlag=1
					;do OutputRow1
					do OutputRowNCYGYY
				}
			}else{
			}
		}
		
		if MRDiagnosStr="" s MRDiagnosStr=MRRowid_$C(1)_MRCDiagTypDesc_$C(1)_MRDIADate_$C(1)_MRCIDDesc_$C(1)_ICD9CMCode
		else  s MRDiagnosStr=MRDiagnosStr_"^"_MRRowid_$C(1)_MRCDiagTypDesc_$C(1)_MRDIADate_$C(1)_MRCIDDesc_$C(1)_ICD9CMCode
	 }
	 
	 if FindFlag=0 {
		 for i=1:1:$l(MRDiagnosStr,"^") {
			 s DiagStr=$p(MRDiagnosStr,"^",i)
			 if (i=1){
			 	s MRCDiagTypCode="M"
			 	s MRCDiagTypDesc="主诊断"
			 }else{
				 s MRCDiagTypCode="PRE"
				 S MRCDiagTypDesc="Pre Admission"
			 }
			 s MRRowid=$p(DiagStr,$c(1),1)
			 ;s MRCDiagTypDesc=$p(DiagStr,$c(1),2)
			 s MRDIADate=$p(DiagStr,$c(1),3)
			 s MRCIDDesc=$p(DiagStr,$c(1),4)
			 s ICD9CMCode=$p(DiagStr,$c(1),5)
             i ICD9CMCode="" s ICD9CMCode="空"
			 ;do OutputRow1
			 do OutputRowNCYGYY
		 }
	 }

 //南昌阳光医药接口使用
OutputRowNCYGYY
	s num=num+1
	//处方编号
	s cfbh=prescno
	s cfbh=cfbh_"_"_num
	//单位编号
	s dwbh="4462"
	//数据版本号
	s sjbbh="1"
	//诊断编码
	i ICD9CMCode="" s ICD9CMCode="空"
	s zdbm=ICD9CMCode
	//诊断名称
	i MRCIDDesc="" s MRCIDDesc="空"
	s zdmc=MRCIDDesc
	//诊断序号
	s zqsl=num
	S PIDSTR=cfbh_"&"_dwbh_"&"_sjbbh_"&"_zdbm
	//I $D(^xuantmp("3","PRESCDATA",PIDSTR)) D
	//.s ^xuantmp("3","PRESCDATA",PIDSTR)=cfbh_"&"_dwbh_"&"_sjbbh_"&"_zdbm_"&"_"DOUBLE"
	//E  D
	//.s ^xuantmp("3","PRESCDATA",PIDSTR)=cfbh_"&"_dwbh_"&"_sjbbh_"&"_zdbm
	s ^DHCSTSENDDATAPRESCDATA("PRESCDATACFZDB",pid,"CFZDB",cfbh,"DETAILCFZDB",ICD9CMCode)=cfbh_"^"_dwbh_"^"_sjbbh_"^"_zdbm_"^"_zdmc_"^"_num
}

/// Creator:      郭荣勇
/// CreatDate:    2013.02.23
/// Description:  查询病人挂号记录
ClassMethod RegRecord(AdmRowId, pid)
{
  s AdmType=$p(^PAADM(AdmRowId),"^",2)
  i AdmType="O" s AdmType="1"
  e  i AdmType="I" s AdmType="2"
  e  i AdmType="E" s AdmType="3"
  //continue:" 1 3 "'[(" "_AdmType_" ")
  s AdmNo=$p($g(^PAADM(AdmRowId)),"^",81)
  s AdmDate=$p($g(^PAADM(AdmRowId)),"^",6)
  s AdmTime=$p($g(^PAADM(AdmRowId)),"^",7)
  s AdmDatTim=$zd(AdmDate,3)_" "_$zt(AdmTime,1)
  s UpdateDate=$p($g(^PAADM(AdmRowId,1)),"^",42)
  s UpdateTime=$p($g(^PAADM(AdmRowId,1)),"^",43)
  s LastUpdateDatTim=""
  i (UpdateDate'="")&&(UpdateTime'="") d 
  .s LastUpdateDatTim=$zd(UpdateDate,3)_" "_$zt(UpdateTime,1)
   //s ^xuantmp("1",AdmNo)=AdmRowId_"&"_UpdateDate_"&"_UpdateTime		
  //挂号流水号
  s ghlsh=AdmNo
  //单位编号
  s dwbh="4462"
  //标准版本号
  s bzbbh=1
  //数据版本号
  s sjbbh=1
  //挂号时间
  s ghsj=AdmDatTim
  //退号时间
  s thsj=LastUpdateDatTim
  //类型
  s cflx=AdmType
 s ^DHCSTSENDDATAPRESCDATA("PRESCDATADETAILGHLSH",pid,"GHLSH",ghlsh)=ghlsh_"^"_dwbh_"^"_bzbbh_"^"_sjbbh_"^"_ghsj_"^"_thsj_"^"_cflx
}

// w ##class(web.DHCSTSENDDATATOLC).GetPatFeetType()

ClassMethod GetPatFeetType(pattype)
{
  s type1="15^33^23^30"
  s type2="17^29^26^28"
  s type3="31^25"
  s type4="24"
  s type5=""
  s type6="10^13^22^19^32"
  s type7="34^11^20^16^18"
  s type8="" 
  s patfeetype="" 
  //s type9="27^21^14"
  s num1=$l(type1,"^")
  f cnt=1:1:num1 q:patfeetype'=""  d
  .i pattype=$p(type1,"^",cnt) s patfeetype="1"
  
  s num2=$l(type2,"^")
  f cnt=1:1:num2 q:patfeetype'=""  d
  .i pattype=$p(type2,"^",cnt) s patfeetype="2"
  
  s num3=$l(type3,"^")
  f cnt=1:1:num3 q:patfeetype'=""  d
  .i pattype=$p(type3,"^",cnt) s patfeetype="3"	
	
  s num4=$l(type4,"^")
  f cnt=1:1:num4 q:patfeetype'=""  d
  .i pattype=$p(type4,"^",cnt) s patfeetype="4"		

  s num6=$l(type6,"^")
  f cnt=1:1:num6 q:patfeetype'=""  d
  .i pattype=$p(type6,"^",cnt) s patfeetype="6"	
   
  s num7=$l(type7,"^")
  f cnt=1:1:num7 q:patfeetype'=""  d
  .i pattype=$p(type7,"^",cnt) s patfeetype="7"
  
  i patfeetype="" s patfeetype="9"
  q patfeetype
}

// w ##class(web.DHCSTSENDDATATOLC).GetNOPhccData()

ClassMethod GetNOPhccData() As %String
{

   s inci="0",i=0
   s file="/ppp.txt"
   c file:"E"
   OPEN file:("NRW"):5
   u file
   S del=$C(9)
   S tabstr="rowid"_del_"药品代码"_del_"名称"
   w !,tabstr
   k ^DHCSTHISTOHMIS("DRUGDICT")
   f  s inci=$o(^INCI(inci)) q:(inci="")||(inci="IB_NoX")||(inci="IB_EX")  d
   . s incsc=$p(^INCI(inci,2),"^",2)
   . s drugcode=$p(^INCI(inci,1),"^",1)	
   . s incidesc=$p(^INCI(inci,1),"^",2)	
   . q:$g(incsc)=""
   . s rArcimRowId=$p(^INCI(inci,1),"^",3) 
   . q:rArcimRowId=""
   . s rSubscript=$p(rArcimRowId,"||",1) 
   . s rVersion=$p(rArcimRowId,"||",2)
   . q:'$d(^ARCIM(rSubscript,rVersion,1))
   . s prescdrgform=$p(^ARCIM(rSubscript,rVersion,1),"^",12)
   . q:prescdrgform=""
   . s prescdrgmast=$p(prescdrgform,"||",1)
   . s prescstkcatsubdr=""
   . i prescdrgmast'=0 s prescstkcatsubdr=$p(^PHCD(prescdrgmast,1),"^",3) //药理学分类
   . q:prescstkcatsubdr'=""
   . S tabstr=inci_del_drugcode_del_incidesc
   . s ^DHCSTNOPHCCSUBCATtmp("nophcc",inci)=inci_"^"_drugcode_"^"_incidesc
   . S tabstr=$tr($tr(tabstr,$c(10)),$C(13))
   . w !,tabstr
   . s i=i+1
   c file 
  q i
}

/// 根据就诊获取病人费用信息
/// input:admid,pattype(O门诊I住院)
/// output：patinfostr(信息拼接串)
/// debuger:w ##class(web.DHCSTSENDDATATOLC).GetPatInfoByoeori("","O","O1312104250")
ClassMethod GetPatInfoByoeori(oeori, pattype, presno)
{
	//s guser=$g(%session.Data("LOGON.USERID"))
	s guser="user"
	k ^TMP("AdmTotal")
	s (zcyfy,zyfy,xyfy,hyfy,zlfy,ssfy,cwfy,jcfy,hlfy,qtfy,zje,pzl,zlts)=0
	s dwbh="4462"
	s sjbbh="1"
	
	i pattype="O"  d ;门诊
	.s oeord=""
	.f  s oeord=$o(^OEORD(0,"PrescNo",presno,oeord)) q:oeord=""  d
	..s oeorisub=0
	..f  s oeorisub=$o(^OEORD(0,"PrescNo",presno,oeord,oeorisub)) q:oeorisub=""  d
	...s oeori=oeord_"||"_oeorisub
	...s zd=""
	...S OPAdm=$p(^OEORD(+oeori),"^",1)
	...s AdmDate=$p(^PAADM(+OPAdm),"^",6)	
	...s MRADMDR=$p($g(^PAADM(+OPAdm)),"^",61)
	...quit:MRADMDR="" 
	...s MrSub=0 f  s MrSub=$o(^MR(+MRADMDR,"DIA",MrSub)) q:MrSub=""  d   	
 	....s DiagID=$p($g(^MR(MRADMDR,"DIA",MrSub)),"^",1)
 	....q:$g(DiagID)=""
 	....s DiagDesc=$P($g(^MRC("ID",DiagID)),"^",2)
 	....i DiagDesc["-" Set DiagDesc=$P(DiagDesc,"_",2)
 	....i zd="" Set zd=DiagDesc
 	....e  Set zd=zd_","_DiagDesc
 	...i zd="" s zd="待查"	 
	...s PBORowid=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",16)
	...;s oerowid=$p(^DHCPB(billrowid,"O",Orderid),"^",4)
	...s oepresno=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14)
	...q:presno'=oepresno
	...i PBORowid'=""  d
	....s billrowid=+PBORowid
	....i $d(^DHCPB(billrowid))'=0  d
	.....s Orderid=$p(PBORowid,"||",2)
	.....;s zje=$p(^DHCPB(+PBORowid),"^",8)	
	.....s pzl=pzl+1
    .....s billdetailId=""  f  s billdetailId=$o(^DHCPB(billrowid,"O",Orderid,"D",billdetailId))  q:billdetailId=""  d    
    ......s BillTotal=$p(^DHCPB(billrowid,"O",Orderid,"D",billdetailId),"^",7)     ;详单金额
    ......s zje=+zje+(+BillTotal)
    ......q:$p(^DHCPB(billrowid,"O",Orderid,"D",billdetailId),"^",7)=""
    ......s TarDr=$p(^DHCPB(billrowid,"O",Orderid,"D",billdetailId),"^",3) ;取收费项指针
    ......s TarAccDr=$p(^DHCTARI(TarDr),"^",5)  ;取会计分类指针
    ......S TarAccCode=""
    ......I TarAccDr'="" D
    .......s TarAccCode=$p(^DHCTarC("AC",TarAccDr),"^",2)  ;会计分类代码
    .......//w !,TarAccCode
    .......//b
    .......i "护理费 中成药 中草药 西药 化验费 治疗费 手术费 床位费 检查费"[TarAccCode d
    ........;b
    ........s ^TMP("AdmTotal",guser,$j,TarAccCode)=$g(^TMP("AdmTotal",guser,$j,TarAccCode))+BillTotal
    .......e  d
    ........s ^TMP("AdmTotal",guser,$j,"其他")=$g(^TMP("AdmTotal",guser,$j,"其他"))+BillTotal
	
	s zcyfy=+$g(^TMP("AdmTotal",guser,$j,"中成药"))
	s zyfy=+$g(^TMP("AdmTotal",guser,$j,"中草药"))
	s xyfy=+$g(^TMP("AdmTotal",guser,$j,"西药"))
	s hyfy=+$g(^TMP("AdmTotal",guser,$j,"化验费"))
	s zlfy=+$g(^TMP("AdmTotal",guser,$j,"治疗费"))
	s ssfy=+$g(^TMP("AdmTotal",guser,$j,"手术费"))
	s cwfy=+$g(^TMP("AdmTotal",guser,$j,"床位费"))
	s jcfy=+$g(^TMP("AdmTotal",guser,$j,"检查费"))
	s hlfy=+$g(^TMP("AdmTotal",guser,$j,"护理费"))
	s qtfy=+$g(^TMP("AdmTotal",guser,$j,"其他"))
	;s presno=presno_"_"_"OUT"
	
	s patinfo=presno_"^"_dwbh_"^"_sjbbh_"^"_zcyfy_"^"_zyfy_"^"_xyfy_"^"_hyfy_"^"_zlfy_"^"_ssfy_"^"_cwfy_"^"_jcfy_"^"_hlfy_"^"_qtfy_"^"_zje_"^"_pzl_"^"_zd_"^"_zlts
	q patinfo
}

ClassMethod GetQtyPhcoll(ordnew, chlnew)
{
	s qtysum=0
	s ex=0 f  s ex=$o(^OEORD(ordnew,"I",chlnew,"X",ex)) q:ex=""  d                     ;
	.s dis=0 f  s dis=$o(^OEORD(ordnew,"I",chlnew,"X",ex,"D",dis)) q:dis=""  s disp=^(dis) d   ;
	..//s stdfid=""  ;--------------------------------
	..//s stdfid=$o(^STDF("OEDI",ordnew_"||"_chlnew_"||"_ex_"||"_dis,stdfid))
	..//q:stdfid'=""  ;---------------------------------------------------------
	..s dstatus=$p(disp,"^",6)                                                   ;
	..//q:$g(dstatus)'="P"
    ..s qtysum=qtysum+$p(^OEORD(ordnew,"I",chlnew,"X",ex,"D",dis),"^",1)      ;qty(j,i)           ;发药数量  
 q qtysum
}

ClassMethod Getpaque(prescno)
{
  n (prescno)
  q:prescno="" "1"
  s queid=""
  s poptdr=""
  s poptdr=$o(^DHCPAQPT(0,"PrescNo",prescno,poptdr))
  q:poptdr="" "1"
  s factor=$p(^DHCPAQPT(poptdr),"^",17)
  q factor
}

/// Descript:	根据库存项ID取计价单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	计价单位ID^计价单位描述
ClassMethod GetArcBuomByInc(InciDr)
{
 N (InciDr)
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S ArcimDr=..GetArcim(InciDr)
 Q ..GetArcBuom(ArcimDr)
}

/// Descritpt:	取医嘱项相关信息
/// Creater：	Zhouyg
/// CreateDate:	20100302
/// Descript:	根据库存项ID取医嘱项ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	医嘱项ID
ClassMethod GetArcim(InciDr)
{
 N (InciDr)
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S ArcimDr=$P(^INCI(InciDr,1),"^",3)
 S Arcsub=$P(ArcimDr,"||",1)
 S Arcver=$P(ArcimDr,"||",2)
 Q:Arcsub="" ""
 Q:Arcver="" ""
 Q:'$D(^ARCIM(Arcsub,Arcver)) ""
 Q Arcsub_"||"_Arcver
}

/// Descript:	根据医嘱项ID取计价单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		ArcimDr-Arcim_rowid
/// Output:		Return
/// Return：	计价单位ID^计价单位描述
ClassMethod GetArcBuom(ArcimDr)
{
 N (ArcimDr)
 Q:ArcimDr="" ""
 S Arcsub=$P(ArcimDr,"||",1)
 S Arcver=$P(ArcimDr,"||",2)
 Q:Arcsub="" ""
 Q:Arcver="" ""
 Q:'$D(^ARCIM(Arcsub,Arcver)) ""
 S BillUomDr=$P(^ARCIM(Arcsub,Arcver,8),"^",14)
 Q:BillUomDr="" ""
 Q:'$D(^CT("UOM",BillUomDr)) ""
 S BillUomDesc=$P(^CT("UOM",BillUomDr),"^",2)
 Q BillUomDr_"^"_BillUomDesc
}

}

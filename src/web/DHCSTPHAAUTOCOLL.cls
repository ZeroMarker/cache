Class web.DHCSTPHAAUTOCOLL Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DispMain(phac As %String) As %String
{
	q:phac="" ""	
	s ward=$p(^DHCPHAC(phac),"^",4)    //病区dr
	s phaloc=$p(^DHCPHAC(phac),"^",1)  //药房dr
	s WARDSN=$p(^PAWARD(ward),"^",1)   //病区编码
	s GROUPNO=$p(^CTLOC(phaloc),"^",1) //药房编码
	s CONFIRMITME=""
	s CONFIRMOPER=""
	s SUBMITTIME=$zd($p(^DHCPHAC(phac),"^",2),3)_" "_$zt($p(^DHCPHAC(phac),"^",3))  //提交时间
	s PAGENO=phac
	s FLAG=""
	s str=WARDSN_"**"_GROUPNO_"**"_CONFIRMITME_"**"_CONFIRMOPER_"**"_SUBMITTIME_"**"_PAGENO_"**"_FLAG
	q str
}

ClassMethod DispItms(phac As %String) As %Library.ListOfObjects
{
	//创建发药明细数据结果集对象
	//SqlServer : ATF_YPXX
	n (phac)
	q:phac="" ""
	s xx=1
	s mylist=##class(%Library.ListOfObjects).%New()
	s tmps=..CreaPhaDataBJDT(phac)
	s cnt=$p(tmps,"^",1)
	s pid=$p(tmps,"^",2)
	i cnt>0 d
	.s oeori=""
	.f  s oeori=$O(^DHCPHAAUTOCOLLTEMP(pid,oeori)) q:oeori=""  d
	..s pha=^DHCPHAAUTOCOLLTEMP(pid,oeori)
	..
	..s INPATIENTNO=$p(pha,"^",1)
	..s PID=$p(pha,"^",2)
	..s NAME=$p(pha,"^",3)
	..s DEPTSN=$p(pha,"^",4)
	..s DEPTNAME=$p(pha,"^",5)
	..s WARDSN=$p(pha,"^",6)
	..s WARDNAME=$p(pha,"^",7)
	..s DOCTOR=$p(pha,"^",8)
	..s BEDNO=$p(pha,"^",9)
	..s COMMENT=$p(pha,"^",10)
	..s COMM2=$p(pha,"^",11)
	..s DRUGCODE=$p(pha,"^",12)
	..s DRUGNAME=$p(pha,"^",13)
	..s SPECIFICATION=$p(pha,"^",14)
	..s DOSAGE=$p(pha,"^",15)
	..;w !,oeori
	..s doseuomfac=..GetDoseUomFac(oeori)
	..s DOSAGE=DOSAGE*doseuomfac
	..w !,SPECIFICATION_"^"_DOSAGE
	..s DOSUNIT=$p(pha,"^",16)
	..s dispqty=$p(pha,"^",17)  //发药总数量
	..s eattimes=$p(pha,"^",18)
	..s FLAG=$p(pha,"^",19)
	..s ATFNO=$p(pha,"^",20)
	..s PRIFLAG=$p(pha,"^",21)
	..s PAGENO=$p(pha,"^",22)
	..s DETAILSN=$p(pha,"^",23)
	..s GENTIME=""
	..s MZFLAG=$p(pha,"^",25) 
	..s sttdate=$p(pha,"^",26)
	..s freqfac=$p(pha,"^",27)
	..
	..s phaci=$p(pha,"^",28)
	..
	..i +freqfac=0 s freqfac=1
	..
	..s eatcnt=..DispCnt(oeori,dispqty)  //服药次数
	..q:eatcnt=0    //如果dhc_oedispensing中没有记录则不予处理
	..
	..
	..
	..s AMOUNT=dispqty/eatcnt  //单次发药数量
	..
	..s eattimecnt=$l(eattimes,",")
	..
	..f i=1:1:eatcnt  d
	...
	...s OCCTIME=..EatDrugDateTime(oeori,i)
	...i OCCTIME="" d
	....s time=$p(eattimes,",",i)
	....s OCCTIME=$zd(sttdate,3)_" "_time_":00"
	...
	...s myobj=##class(dhcinterface.ATFYPXX).%New()
	...s myobj.INPATIENTNO = INPATIENTNO
	...s myobj.PID = PID
	...s myobj.NAME = NAME
	...s myobj.DEPTSN = DEPTSN
	...s myobj.DEPTNAME = DEPTNAME
	...s myobj.WARDSN = WARDSN
	...s myobj.WARDNAME = WARDNAME
	...s myobj.DOCTOR = DOCTOR
	...s myobj.BEDNO = BEDNO
	...s myobj.COMMENT = COMMENT
	...s myobj.COMM2 = COMM2
	...s myobj.DRUGCODE = DRUGCODE
	...s myobj.DRUGNAME = DRUGNAME
	...s myobj.SPECIFICATION = SPECIFICATION
	...s myobj.DOSAGE = DOSAGE
	...s myobj.DOSUNIT = DOSUNIT
	...s myobj.AMOUNT = AMOUNT
	...s myobj.OCCTIME = OCCTIME
	...s myobj.FLAG = FLAG
	...s myobj.ATFNO = ATFNO
	...s myobj.PRIFLAG = PRIFLAG
	...s myobj.PAGENO = PAGENO
	...s myobj.DETAILSN = DETAILSN
	...s myobj.GENTIME = GENTIME
	...s myobj.MZFLAG = MZFLAG
	...d mylist.Insert(myobj)
	...//s ^lq(phac,xx)=INPATIENTNO_"^"_PID_"^"_OCCTIME_"^"_DRUGCODE_"^"_DETAILSN
	...//s ^lq(phac,xx)=^lq(phac,xx)_"^"_NAME_"^"_DEPTSN_"^"_WARDNAME_"^"_DOCTOR_"^"_BEDNO
	...//s ^lq(phac,xx)=^lq(phac,xx)_"^"_COMMENT_"^"_COMM2_"^"_DRUGNAME_"^"_SPECIFICATION_"^"_DOSAGE
	...//s ^lq(phac,xx)=^lq(phac,xx)_"^"_DOSUNIT_"^"_AMOUNT_"^"_OCCTIME_"^"_FLAG_"^"_ATFNO
	...//s ^lq(phac,xx)=^lq(phac,xx)_"^"_PRIFLAG_"^"_PAGENO_"^"_GENTIME_"^"_MZFLAG
	...//s xx=xx+1
	..
	.
	q mylist
}

ClassMethod CreaPhaDataBJDT(phac As %String) As %String
{
 //根据发药单rowid生成摆药机中间表数据
 s nn=0
 s ch=0
 s pid=..Pid()
 k ^DHCPHAAUTOCOLLTEMP(pid) //清除临时global
 //
 f   s ch=$O(^DHCPHAC(phac,"I",ch)) q:ch=""  d
 .s phaci=phac_"||"_ch
 .s oeori=$p(^DHCPHAC(phac,"I",ch),"^",7)
 .s dispqty=$P(^DHCPHAC(phac,"I",ch),"^",6)  ;数量
 .i $d(^DHCPHAAUTOCOLLTEMP(pid,oeori)) d
 ..s $p(^DHCPHAAUTOCOLLTEMP(pid,oeori),"^",17)=$p(^DHCPHAAUTOCOLLTEMP(pid,oeori),"^",17)+dispqty
 .e  d
 ..s ord=+oeori
 ..s adm=$P(^OEORD(ord),"^",1)
 ..s data1=$$PaInfo(adm)
 ..;s
 ..s INPATIENTNO=$P(data1,"^",1)
 ..s PID=$P(data1,"^",2)
 ..s NAME=$P(data1,"^",3)
 ..;s SEX=$P(data1,"^",4)
 ..;s AGE=$P(data1,"^",5)
 ..s WARDSN=$P(data1,"^",6)
 ..s WARDNAME=$P(data1,"^",7)
 ..s BEDNO=$P(data1,"^",8)
 ..
 ..s DEPTSN=""
 ..s DEPTNAME=""
 ..s detp=$p(^DHCPHAC(phac,"I",ch),"^",11)
 ..i detp'="" s DEPTSN=$P($g(^CTLOC(detp)),"^",1)   ;科室编码
 ..i detp'="" s DEPTNAME=$P($g(^CTLOC(detp)),"^",2)  ;科室名称
 ..s data2=$$OrdInfo(oeori)
 ..s DOCTOR=$p(data2,"^",1)
 ..s COMMENT=$p(data2,"^",2)
 ..s DRUGCODE=$p(data2,"^",3)
 ..s DRUGNAME=$p(data2,"^",4)
 ..s SPECIFICATION=$p(data2,"^",5)
 ..s COMM2=""
 ..
 ..s DOSAGE=$p(data2,"^",6)
 ..s DOSUNIT=$p(data2,"^",7)
 ..
 ..s sttdate=$p(data2,"^",8)
 ..s eattimes=$p(data2,"^",9)
 ..s freqfac=$p(data2,"^",10)
 ..i +freqfac=0 s freqfac=1
 ..s FLAG=""
 ..s ATFNO=""
 ..s PRIFLAG="0"
 ..s PAGENO=phac
 ..s DETAILSN=oeori
 ..s GENTIME=""
 ..s MZFLAG="0"
 ..s nn=nn+1
 ..s x1=INPATIENTNO_"^"_PID_"^"_NAME_"^"_DEPTSN_"^"_DEPTNAME
 ..s x2=WARDSN_"^"_WARDNAME_"^"_DOCTOR_"^"_BEDNO_"^"_COMMENT
 ..s x3=COMM2_"^"_DRUGCODE_"^"_DRUGNAME_"^"_SPECIFICATION_"^"_DOSAGE
 ..s x4=DOSUNIT_"^"_dispqty_"^"_eattimes_"^"_FLAG_"^"_ATFNO
 ..s x5=PRIFLAG_"^"_PAGENO_"^"_DETAILSN_"^"_GENTIME_"^"_MZFLAG
 ..s x6=sttdate_"^"_freqfac
 ..
 ..s ^DHCPHAAUTOCOLLTEMP(pid,oeori)=x1_"^"_x2_"^"_x3_"^"_x4_"^"_x5_"^"_x6
 ..
 ..
 q nn_"^"_pid
PaInfo(adm) 
 //取病人的相关信息
 n (adm)
 q:adm="" ""
 s papmidr=$p($g(^PAADM(adm)),"^",1) q:papmidr="" ""
 s pano=$p($g(^PAPER(papmidr,"PAT",1)),"^",1) ;登记号
 s name=$p($g(^PAPER(papmidr,"ALL")),"^",1)
 s sexdr=$p($g(^PAPER(papmidr,"ALL")),"^",7)
 s sex=""
 i sexdr'="" s sex=$p(^CT("SEX",sexdr),"^",1)
 s dob=$p($g(^PAPER(papmidr,"ALL")),"^",6)
 s age=+$h-dob   ;days of age
 s ward=$p($g(^PAADM(adm)),"^",70)
 s bed=$p($g(^PAADM(adm)),"^",73)
 s wardcode="",warddesc="",bedno=""
 i ward'="" s wardcode=$p(^PAWARD(ward),"^",1), warddesc=$p(^PAWARD(ward),"^",2)
 i bed'="" s bedno=$p($g(^PAWARD(+bed,"BED",$P(bed,"||",2))),"^",1)  
 s padocno=$P(^PAPER(papmidr,"PAT",3),"^",4) ;登记号
 ;
 s result=pano_"^"_adm_"^"_name_"^"_sex_"^"_age_"^"_wardcode_"^"_warddesc_"^"_bedno
 q result  
OrdInfo(oeori) 
 //取医嘱的相关信息
 n (oeori)
 s ord=+oeori
 s chl=$p(oeori,"||",2)
 q:ord="" ""
 q:chl="" ""
 s useradd=$p($g(^OEORD(ord,"I",chl,7)),"^",1)
 i useradd'="" s useraddname=$p($g(^SSU("SSUSR",useradd)),"^",2 )
 i '$d(^OEORD(ord,"I",chl,2)) s instrdr=""
 e  s instrdr=$p(^OEORD(ord,"I",chl,2),"^",7)						;医嘱用法
 i instrdr'="" s instr=$p(^PHCIN(instrdr),"^",2)
 s instr=$g(instr)
 s arcim=$p(^OEORD(ord,"I",chl,1),"^",2) ;医嘱项rowid
 s inci=..GetINCI(arcim)
 s incicode=$p(^INCI(inci,1),"^",1) ;代码
 s incidesc=$p(^INCI(inci,1),"^",2) ;名称
 s spec=$p(^INCI(inci,3),"^",9)  ;规格
 
 
 ;s info=$O(^DHCITMINFO(0,"INCI",inci,""))
 ;i info'="" s spec=$P($G(^DHCITMINFO(info)),"^",27)
 s spec=$p(spec,"*")  //规格去掉"*"
 s spec=$tr(spec,"[","")
 s spec=$tr(spec,"]","")
 
 ;
 s doseqty=$p(^OEORD(ord,"I",chl,2),"^",1)						;处方量(剂量)
 s unitdr=$p(^OEORD(ord,"I",chl,2),"^",3)							
 s unit=""
 i unitdr'="" s unit=$p(^CT("UOM",unitdr),"^",2) ;处方量(剂量)单位
 s sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)					;医嘱开始日期
 s freqdr=$p(^OEORD(ord,"I",chl,2),"^",4)							;频率
 //w freqdr,!
 s freqfac=$p($g(^PHCFR(freqdr)),"^",2)
 i freqfac="" s freqfac=1
 s occtime=..GetFreqTime(freqdr)
 //
 s result=useraddname_"^"_instr_"^"_incicode_"^"_incidesc_"^"_spec_"^"_doseqty_"^"_unit_"^"_sttdate_"^"_occtime_"^"_freqfac
 q result
}

ClassMethod GetINCI(arcim As %String) As %String
{
 //根据医嘱项rowid取得库存项目的rowid
 n (arcim)
 s ARCIMsub=$p(arcim,"||",1)
 s ARCIMsub=$p(ARCIMsub,$c(1))
 s INCIrow=$o(^INCI(0,"ARCIM_DR",ARCIMsub,""))
 q $g(INCIrow)
}

ClassMethod OrdItmQty(orderitem As %String) As %String
{
 ;根据医嘱计算出该医嘱的药品"打包"数量(基本单位)
 ;08-03-27
 n (orderitem)
 s ord=$p(orderitem,"||",1),chl=$p(orderitem,"||",2)
 q:ord="" ""
 q:chl="" ""
 q:'$d(^OEORD(ord,"I",chl,1)) ""
 s arcim=$P(^OEORD(ord,"I",chl,1),"^",2)
 s qty=$P(^OEORD(ord,"I",chl,2),"^",1)
 s uom=$P(^OEORD(ord,"I",chl,2),"^",3)
 s recloc=$P(^OEORD(ord,"I",chl,3),"^",6)
 s packqty=$P(^OEORD(ord,"I",chl,9),"^",4)
 s arcim1=$p(arcim,"||")
 s inci=..GetINCI(arcim)
 s drgform=$p($g(^ARCIM(arcim1,1,1)),"^",12)
 i $g(packqty) d
 .s err=$$billqty^MVBOEITA(uom,arcim,packqty)
 .i err s qty=err
 s qty2=qty
 i qty<0 s qty2=-qty
 s qty1=$$calcqty^aOET7(drgform,uom,qty2)
 i qty<0 s qty1=-qty1
 w qty1
 q qty1
}

ClassMethod GetFreqTime(freq As %String) As %String
{
 ;取频次时间
 n (freq)
 q:$g(freq)="" ""
 s timestr=""
 s chl=0  
 f  s chl=$o(^PHCFR(freq,"DT",chl))  q:chl=""  d
 .s freqtime=$p(^PHCFR(freq,"DT",chl),"^",1)
 .i freqtime'="" s freqtime=$zt(freqtime,2)
 .;i $f(freqtime,":") s freqtime=$p(freqtime,":",1)   ;如08:00:00,取08
 .;s freqtime=freqtime_"00"
 .i timestr="" s timestr=freqtime
 .e  s timestr=timestr_","_freqtime
 q $g(timestr)
}

ClassMethod GetDispMain(phac As %String) As %Library.ListOfObjects
{
	//创建发药主信息结果集对象
	//SqlServer : atf_yp_page_no
	//create by lq 
	q:$g(phac)="" ""
	s dispmain=..DispMain(phac)
	q:dispmain="" ""
	s mylist=##class(%Library.ListOfObjects).%New()
	s myobj=##class(dhcinterface.ATFYPPAGENO).%New()
	
	s myobj.FLAG=$p(dispmain,"**",7)
	s myobj.PAGENO =$p(dispmain,"**",6)	
	s myobj.WARDSN =$p(dispmain,"**",1)
	s myobj.GROUPNO =$p(dispmain,"**",2)
	s myobj.CONFIRMTIME =$p(dispmain,"**",3)
	s myobj.CONFIRMOPER =$p(dispmain,"**",4)
	s myobj.SUBMITTIME =$p(dispmain,"**",5)
	
	d mylist.Insert(myobj)	
	
	q mylist
}

ClassMethod DispCnt(oeori As %String, dispQty As %String) As %Integer
{
	//根据本次发药取得发药的批数
	//oeori: 医嘱rowid
	//dispQty :发药数量 
	n (oeori,dispQty)
	s cnt=0
	//s phac=$p(phaci,"||",1) q:phac="" cnt
	//s ch=$p(phaci,"||",2) q:ch="" cnt
	//s oeori=$p($g(^DHCPHAC(phac,"I",ch)),"^",7) q:oeori="" cnt
	//
	s dsp=""
 f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,dsp)) q:(dsp="")!(dispQty'>0)   d
 .s type=$p(^DHCOEDISQTY(dsp),"^",13)
 .//s pointer=$p(^DHCOEDISQTY(dsp),"^",14)
 .s status=$p(^DHCOEDISQTY(dsp),"^",7)
 .s confqty=$p(^DHCOEDISQTY(dsp),"^",11)
 .i (status="C")&(type="P")&(confqty'>dispQty) d  //&(pointer=phaci) d
 ..s cnt=cnt+1
 ..s dispQty=dispQty-confqty
	q cnt
}

ClassMethod Pid() As %String
{
	q $I(^DHCSTAUTODISPENSING)
}

ClassMethod AutoCollDrugold() As %String
{
	//根据发药分类取药品数据 // ordtype : 发药分类代码 
	s ^TempWB(1)="1"
	s ordtype="YFBY"
 s pid=..Pid()
 s inci=0
 s i=0
	s mylist=##class(%Library.ListOfObjects).%New()
 f  s inci=$o(^INCI(inci)) q:+inci'>0  d
 .s arcim=$p(^INCI(inci,1),"^",3)
 .q:arcim=""
 .s sub=$p(arcim,"||",1)
 .s ver=$p(arcim,"||",2)
 .s itemcat=$p(^ARCIM(sub,ver,1),"^",10)
 .q:itemcat="" 
 .s drgGrp=$o(^DHCSTDRUGGRP(0,"ORDCAT",itemcat,""))
 .q:drgGrp=""
 .s drgGrpCode=$p(^DHCSTDRUGGRP(drgGrp),"^",1)
 .q:drgGrpCode'=ordtype
 .s ^TempWB(2)="2"
 .s code=$P(^INCI(inci,1),"^",1)
 .s desc=$P(^INCI(inci,1),"^",2)
 .s spec=##class(web.DHCSTKUTIL).GetSpec(inci)
 .s spec=$p(spec,"*")  //规格去掉"*"
 .s spec=$tr(spec,"[","")
 .s spec=$tr(spec,"]","")
 .s ^TempWB(3)="3"
 .s uom=$p(^INCI(inci,1),"^",10)
 .s uomdesc=$p(^CT("UOM",uom),"^",2)
 .s manf=##class(web.DHCSTKUTIL).GetManfNameByInci(inci)
 .s pycode=""
 .s ^TempWB(4)="4"
 .//s i=i+1
 .//s ^DHCPHAAUTOCOLLTEMP(pid,"DRUG",i)=code_"^"_desc_"^"_spec_"^"_uomdesc_"^"_manf_"^"_pycode
 .
 .s myobj=##class(dhcinterface.ATFHISDRUGINFO).%New()
 .s myobj.DRUGCODE=code
 .s myobj.DRUGNAME=desc
 .s myobj.SPECIFICATION=spec
 .s myobj.PACKNAME=uomdesc
 .s myobj.MANUFACTORY=manf
 .s myobj.PYCODE=pycode
 .d mylist.Insert(myobj)
 q mylist
}

ClassMethod AutoCollDrug() As %String
{
	//根据发药分类取药品数据 // ordtype : 发药分类代码 
	s ordtype="KFBY"
 s pid=..Pid()
 s inci=0
 s i=0
	s mylist=##class(%Library.ListOfObjects).%New()
 f  s inci=$o(^INCI(inci)) q:+inci'>0  d
 .s arcim=$p($g(^INCI(inci,1)),"^",3)
 .q:arcim=""
 .s sub=$p(arcim,"||",1)
 .s ver=$p(arcim,"||",2)
 .s itemcat=$p(^ARCIM(sub,ver,1),"^",10)
 .q:itemcat="" 
 .s drgGrp=$o(^DHCSTDRUGGRP(0,"ORDCAT",itemcat,""))
 .q:drgGrp=""
 .s drgGrpCode=$p(^DHCSTDRUGGRP(drgGrp),"^",1)
 .q:drgGrpCode'=ordtype
 .
 .s code=$P(^INCI(inci,1),"^",1)
 .s desc=$P(^INCI(inci,1),"^",2)
 .s spec=##class(web.DHCSTKUTIL).GetSpec(inci)
 .s spec=$p(spec,"*")  //规格去掉"*"
 .s spec=$p(spec,"/")
 .s spec=$p(spec,"\")
 .s spec=$tr(spec,"[","")
 .s spec=$tr(spec,"]","")
 .
 .s uom=$p(^INCI(inci,1),"^",10)
 .s uomdesc=$p(^CT("UOM",uom),"^",2)
 .s manf=##class(web.DHCSTKUTIL).GetManfNameByInci(inci)
 .s pycode=""
 .
 .//s i=i+1
 .//s ^DHCPHAAUTOCOLLTEMP(pid,"DRUG",i)=code_"^"_desc_"^"_spec_"^"_uomdesc_"^"_manf_"^"_pycode
 .
 .s myobj=##class(dhcinterface.ATFHISDRUGINFO).%New()
 .s myobj.DRUGCODE=code
 .s myobj.DRUGNAME=desc
 .s myobj.SPECIFICATION=spec
 .s myobj.PACKNAME=uomdesc
 .s myobj.MANUFACTORY=manf
 .s myobj.PYCODE=pycode
 .d mylist.Insert(myobj)
 q mylist
}

ClassMethod EatDrugDateTime(oeori As %String, serialno As %String) As %String
{
 //根据医嘱rowid,和顺序号取得oe_ordexec中的医嘱执行时间(date + time)
 n (oeori,serialno)
 s n=0
 s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
 s eatDateTime=""
 s exe=0
 f  s exe=$o(^OEORD(ord,"I",itm,"X",exe)) q:exe=""  d
 .s n=n+1
 .i serialno=n d
 ..s eatDate=$p(^OEORD(ord,"I",itm,"X",exe),"^",1)
 ..s eatTime=$p(^OEORD(ord,"I",itm,"X",exe),"^",2)
 ..s eatDateTime=$zd(eatDate,3)_" "_$zt(eatTime)
 q eatDateTime
}

ClassMethod tt() As %String
{
	//根据发药分类取药品数据 // ordtype : 发药分类代码 
	s ordtype="KFBY"
 s pid=..Pid()
 s inci=0
 s i=0
	s mylist=##class(%Library.ListOfObjects).%New()
 f  s inci=$o(^INCI(inci)) q:+inci'>0  d
 .s arcim=$p($g(^INCI(inci,1)),"^",3)
 .q:arcim=""
 .s sub=$p(arcim,"||",1)
 .s ver=$p(arcim,"||",2)
 .s itemcat=$p(^ARCIM(sub,ver,1),"^",10)
 .q:itemcat="" 
 .s drgGrp=$o(^DHCSTDRUGGRP(0,"ORDCAT",itemcat,""))
 .q:drgGrp=""
 .s drgGrpCode=$p(^DHCSTDRUGGRP(drgGrp),"^",1)
 .q:drgGrpCode'=ordtype
 .
 .s code=$P(^INCI(inci,1),"^",1)
 .s desc=$P(^INCI(inci,1),"^",2)
 .s spec=##class(web.DHCSTKUTIL).GetSpec(inci)
 .s spec=$p(spec,"*")  //规格去掉"*"
 .s spec=$p(spec,"/")
 .s spec=$p(spec,"\")
 .s spec=$tr(spec,"[","")
 .s spec=$tr(spec,"]","")
 .
 .s uom=$p(^INCI(inci,1),"^",10)
 .s uomdesc=$p(^CT("UOM",uom),"^",2)
 .s manf=##class(web.DHCSTKUTIL).GetManfNameByInci(inci)
 .s pycode=""
 .
 .s i=i+1
 .s ^DHCPHAAUTOCOLLTEMP(pid,"DRUG",i)=code_"^"_desc_"^"_spec_"^"_uomdesc_"^"_manf_"^"_pycode
 .
 .//s myobj=##class(dhcinterface.ATFHISDRUGINFO).%New()
 .//s myobj.DRUGCODE=code
 .//s myobj.DRUGNAME=desc
 .//s myobj.SPECIFICATION=spec
 .//s myobj.PACKNAME=uomdesc
 .//s myobj.MANUFACTORY=manf
 .//s myobj.PYCODE=pycode
 .//d mylist.Insert(myobj)
 //q mylist
 w pid,!
q i
}

ClassMethod GetDoseUomFac(OrditmRowid) As %String
{
   n (OrditmRowid)
   ;Description: 解决1/2片,
   ;如果剂量单位是最小单位，现在的剂量转换成等效单位
   ;如果剂量单位是等效单位，现在的剂量可以不变
   ;Input:OE_OrdItemRowid
   ;Output:fac - 转换因子
   ;Creator:lq   2009-03-06
   s ord=$p(OrditmRowid,"||",1)
   s chl=$p(OrditmRowid,"||",2)
   s fac=1
   s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  
   s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  
   s doseuom=$p(^CT("UOM",$p(^OEORD(ord,"I",chl,2),"^",3)),"^",2) 
   s buomdr=$p(^INCI(inci,1),"^",10)
   s buom=$p(^CT("UOM",buomdr),"^",2) 
   s OrderDrugFormRowid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",12)
   s eqchl=""
   f  s eqchl=$o(^PHCD($p(OrderDrugFormRowid,"||",1),"DF",$p(OrderDrugFormRowid,"||",2),"EQ",eqchl)) q:eqchl=""  d
   .s ctuomdr=$p(^PHCD($p(OrderDrugFormRowid,"||",1),"DF",$p(OrderDrugFormRowid,"||",2),"EQ",eqchl),"^",1)
   .s equom=$p(^CT("UOM",ctuomdr),"^",2) 
   .;q:equom'=doseuom
   .s eqqty=$p(^PHCD($p(OrderDrugFormRowid,"||",1),"DF",$p(OrderDrugFormRowid,"||",2),"EQ",eqchl),"^",2)
   .;w !,eqqty
   ;w !,doseuom_"^"_buom
   i doseuom'=buom d
   .;s fac=eqqty
   .s fac=1
   e  d 
   .;s fac=1
   .s fac=eqqty
   q fac
}

}

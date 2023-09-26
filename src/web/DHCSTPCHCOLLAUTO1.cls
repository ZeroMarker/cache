Include webimport

IncludeGenerator webimport

Class web.DHCSTPCHCOLLAUTO1 Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 159;

ClassMethod AutoCollect(displocrowid, wardrowid, StartDate, EndDate, Userid, ByWardFlag, LongOrdFlag, ShortOrdFlag, OutWithDrugFlag, DispCat, DoctorLocRowid, NotAudit, StartTime, EndTime, incirowid) As %String
{
	//循环发送全院医嘱
	//create by lq 
    s PID=..PCHCOLLS(displocrowid,wardrowid,StartDate,EndDate,Userid,ByWardFlag,LongOrdFlag,ShortOrdFlag,OutWithDrugFlag,DispCat,DoctorLocRowid,NotAudit,StartTime,EndTime,incirowid)
    q:PID="" ""
    s h=1
	f  s type=$p(DispCat,"^",h)  q:type=""  d
	.s rowcnt=$$GETDATA1(type,PID)
	.s h=h+1
	.;d Auto(DispCat,PID)
	q PID
GETDATA1(gettype1, pid)
	n (gettype1,pid)
	k ^TMP("dhcpha",pid,"D1")
	s gettype=$g(gettype1)
	s j=0
	s arcpj="" f  s arcpj=$o(^TMP("dhcpha",pid,"D","ADM",arcpj))  q:arcpj=""  d
	.s arcpjsub="" f  s arcpjsub=$o(^TMP("dhcpha",pid,"D","ADM",arcpj,arcpjsub)) q:arcpjsub=""  d  
	..i ^TMP("dhcpha",pid,"D","ARCCAT",arcpj,arcpjsub)=gettype d
	...s getoedis=^TMP("dhcpha",pid,"D","OEDIS",arcpj,arcpjsub)
	...s getord=$p(getoedis,"||",1)                                                       ;OEORD_RowId                                                                      
	...s getchl=$p(getoedis,"||",2)                                                       ;OEORI_ChildSub
	...q:$p(^OEORD(getord,"I",getchl,1),"^",8)=""    
	...s j=j+1
	...s getadm=^TMP("dhcpha",pid,"D","ADM",arcpj,arcpjsub)
	...s getbed=^TMP("dhcpha",pid,"D","BED",arcpj,arcpjsub)
	...s getpresc=^TMP("dhcpha",pid,"D","PRESC",arcpj,arcpjsub)
	...s getqty=^TMP("dhcpha",pid,"D","QTY",arcpj,arcpjsub)
	...s getprice=^TMP("dhcpha",pid,"D","PRICE",arcpj,arcpjsub)
	...s getdeploc=^TMP("dhcpha",pid,"D","DEPLOC",arcpj,arcpjsub)
	...s getoeflag=^TMP("dhcpha",pid,"D","OEFLAG",arcpj,arcpjsub)
	...s getaudited=$g(^TMP("dhcpha",pid,"D","AUDITED",arcpj,arcpjsub))      ; 0525 - if audited or not
	...;s getinci=$p(getinclbdr,"||",1)                                                    ;INCI_RowId
	...s getinci=^TMP("dhcpha",pid,"D","INCI",arcpj,arcpjsub)
	...
	...;s getincil=$p(getinclbdr,"||",2)                                                   ;INCIL_ChildSub
	...;s getinclb=$p(getinclbdr,"||",3)                                                   ;INCLB_ChildSub
	...;s getincibdr=$p(^INCI(getinci,"IL",getincil,"LB",getinclb),"^",1)                  ;INCIB_RowId
	...;s getincib=$p(getincibdr,"||",2)
	...
	...s getarcimid=$p(^OEORD(getord,"I",getchl,1),"^",2)                                 ;ARCIM_RowId 
	...s phcdfdr=$p(^ARCIM($p(getarcimid,"||",1),$p(getarcimid,"||",2),1),"^",12)
	...s officialcode=$p(^PHCD($p(phcdfdr,"||",1),4),"^",2) ;药医保类别  
	...s getpatnameid=$p(^PAADM(getadm),"^",1) 
	...s getaction=##class(web.DHCSTPCHCOLLS2).SkinTest2(getord_"||"_getchl) ;lq 2007-10-19 备注(皮试结果)
	...s getage=##class(web.DHCSTKUTIL).GetAge(getpatnameid) ;PA_PatMas PAPMI_RowId 
	...s sexdr=$p(^PAPER(getpatnameid,"ALL"),"^",7)
	...s sex=$p(^CT("SEX",sexdr),"^",2)                                     
	...s getarcim=$p(^ARCIM($p(getarcimid,"||",1),$p(getarcimid,"||",2),1),"^",2)
	...;i gettype="PJ" s i=getdeploc_"||"_getbed_"||"_getarcimid    
	...s i=getinci_"||"_getarcimid_"||"_getdeploc_"||"_getbed
	...s ^TMP("dhcpha",pid,"D1","SEX",i,j)=sex  ;性别
	...s ^TMP("dhcpha",pid,"D1","ARCIM",i,j)=getarcim       ;getarcim(i,j)                                                  ;医嘱名称
	...s ^TMP("dhcpha",pid,"D1","PATNAME",i,j)=$p(^PAPER(getpatnameid,"ALL"),"^",1)      ;getpatname(i,j)  
	...s ^TMP("dhcpha",pid,"D1","AGE",i,j)=getage                   ;年龄   
	...s ^TMP("dhcpha",pid,"D1","PATMRN",i,j)=$p(^PAPER(getpatnameid,"PAT",1),"^",1)     ;getpatmrn(i,j)                     ;病人登记号
	...;s ^TMP("dhcpha",pid,"D1","YBTYPE",i,j)=..GetYBType(getadm) ;患者医保类别
	...s ^TMP("dhcpha",pid,"D1","YBTYPE",i,j)=officialcode ;药医保类别 
	...s ^TMP("dhcpha",pid,"D1","PRESC",i,j)=getpresc                                    ;getpresc(i,j)                     ;医嘱处方号      
	...s ^TMP("dhcpha",pid,"D1","BED",i,j)=getbed                                        ;getbed(i,j)                     ;病人床号       
	...s ^TMP("dhcpha",pid,"D1","PRICE",i,j)=getprice                                    ;getprice(i,j)                     ;医嘱价格       
	...s ^TMP("dhcpha",pid,"D1","QTY",i,j)=getqty                                        ;getqty(i,j)                     ;医嘱数量
	...s ^TMP("dhcpha",pid,"D1","PAKUOM",i,j)=$p(^CT("UOM",$p(^INCI(getinci,1),"^",10)),"^",2)  ;getpakuom(i,j)              ;药品基本库存单位       
	...i $p(^OEORD(getord,"I",getchl,2),"^",6)="" s ^TMP("dhcpha",pid,"D1","DURA",i,j)="*"
	...e  s ^TMP("dhcpha",pid,"D1","DURA",i,j)=$p(^PHCDU($p(^OEORD(getord,"I",getchl,2),"^",6)),"^",1)   ;getdur(i,j)      ;用药疗程
	...i $p(^OEORD(getord,"I",getchl,2),"^",7)="" s ^TMP("dhcpha",pid,"D1","INST",i,j)="*"
	...e  s ^TMP("dhcpha",pid,"D1","INST",i,j)=$p(^PHCIN($p(^OEORD(getord,"I",getchl,2),"^",7)),"^",2)  ;getinst(i,j)      ;用法
	...i $f(^TMP("dhcpha",pid,"D1","INST",i,j),"-")  s ^TMP("dhcpha",pid,"D1","INST",i,j)=$p(^TMP("dhcpha",pid,"D1","INST",i,j),"-",2)      
	...i $p(^OEORD(getord,"I",getchl,2),"^",4)="" s ^TMP("dhcpha",pid,"D1","FREQ",i,j)="*"           
	...e  s ^TMP("dhcpha",pid,"D1","FREQ",i,j)=$p(^PHCFR($p(^OEORD(getord,"I",getchl,2),"^",4)),"^",1)    ;getfreq(i,j)    ;用药频率 
	...s ^TMP("dhcpha",pid,"D1","DOSAGE",i,j)=$p(^OEORD(getord,"I",getchl,2),"^",1)                      ;getdosage(i,j)   ;用药剂量
	...i $p(^OEORD(getord,"I",getchl,2),"^",3)="" s ^TMP("dhcpha",pid,"D1","UOM",i,j)="*"
	...e  s ^TMP("dhcpha",pid,"D1","UOM",i,j)=$p(^CT("UOM",$p(^OEORD(getord,"I",getchl,2),"^",3)),"^",2)   ;getuom(i,j)      ;剂量单位           
	...s ^TMP("dhcpha",pid,"D1","BATNO",i,j)=""       // ##class(web.DHCSTKUTIL).GetDODIS(getord_"||"_getchl)
	...s ^TMP("dhcpha",pid,"D1","OEFLAG",i,j)=getoeflag                                        ;getoeflag(i,j)               ;医嘱核实、未核实、停止状态
	...s ^TMP("dhcpha",pid,"D1","TYPE",i,j)=$p(^OECPR($p(^OEORD(getord,"I",getchl,1),"^",8)),"^",2)   ; getordtype(i,j)     ;医嘱优先级
	...s ^TMP("dhcpha",pid,"D1","DEPLOC",i,j)=$p(^CTLOC(getdeploc),"^",2)                        ;getdeploc(i,j)             ;病人所在科室
	...s ^TMP("dhcpha",pid,"D1","OE",i,j)=getoedis     ;----------------------;;;;;;
	...i $f(^TMP("dhcpha",pid,"D1","DEPLOC",i,j),"-")  s ^TMP("dhcpha",pid,"D1","DEPLOC",i,j)=$p(^TMP("dhcpha",pid,"D1","DEPLOC",i,j),"-",2)
	...s ^TMP("dhcpha",pid,"D1","AUDITED",i,j)=getaudited    ;20060525 if audited or not
	...;2007-7-23,zdm,增加通用名,剂型,规格,厂家,货位号,药品金额，开单医生，开单时间,诊断
	...s ^TMP("dhcpha",pid,"D1","GENERIC",i,j)=##class(web.DHCSTCOMMONSRV).getGeneric(getinci)
	...s ^TMP("dhcpha",pid,"D1","FORM",i,j)=##class(web.DHCSTCOMMONSRV).GetForm(getinci)
	...s ^TMP("dhcpha",pid,"D1","BARCODE",i,j)=##class(web.DHCSTCOMMONSRV).getBarcode(getinci)
	...s ^TMP("dhcpha",pid,"D1","MANFACTURE",i,j)=##class(web.DHCSTITMDESC).GetManfNameByInci(getinci)
	...;s ^TMP("dhcpha",pid,"D1","INCSTK",i,j)=##class(web.DHCSTCOMMONSRV).getIncStk(incil) //07-09-29 zhwh
	...s ^TMP("dhcpha",pid,"D1","INCSTK",i,j)=##class(web.DHCSTKUTIL).StkBin(getord_"||"_getchl) ;货位
	...s ^TMP("dhcpha",pid,"D1","AMT",i,j)=$g(getqty)*$g(getprice)
	...s ^TMP("dhcpha",pid,"D1","USERADD",i,j)=##class(web.DHCSTCOMMONSRV).getOrdDoctor(getord_"||"_getchl)
	...s oeoridate=$p(^OEORD(getord,"I",getchl,3),"^",7)
	...s timeord=$p(^OEORD(getord,"I",getchl,1),"^",17)
	...s datetime=oeoridate_","_timeord
	...s ^TMP("dhcpha",pid,"D1","DATATIME",i,j)=$zdt(datetime,3,1)
	...s ^TMP("dhcpha",pid,"D1","DIAGNOSE",i,j)=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(getadm,",")
	...s ^TMP("dhcpha",pid,"D1","ACTION",i,j)=$g(getaction) //2007-10-19
	...
	s num=0
	s j="" f  s j=$o(^TMP("dhcpha",pid,"D1","ARCIM",j))  q:j=""  d
	.s i="" f  s i=$o(^TMP("dhcpha",pid,"D1","ARCIM",j,i)) q:i=""  d
	..i ^TMP("dhcpha",pid,"D1","OEFLAG",j,i)="V" s ^TMP("dhcpha",pid,"D1","OEFLAG",j,i)="*"
	..i ^TMP("dhcpha",pid,"D1","OEFLAG",j,i)="D" s ^TMP("dhcpha",pid,"D1","OEFLAG",j,i)="停止"
	..s getinfo0=^TMP("dhcpha",pid,"D1","DEPLOC",j,i)_"&"_^TMP("dhcpha",pid,"D1","BED",j,i)_"&"_^TMP("dhcpha",pid,"D1","PATNAME",j,i)_"&"_^TMP("dhcpha",pid,"D1","PATMRN",j,i)
	..s getinfo1=^TMP("dhcpha",pid,"D1","ARCIM",j,i)_"&"_^TMP("dhcpha",pid,"D1","QTY",j,i)_"&"_^TMP("dhcpha",pid,"D1","PAKUOM",j,i)_"&"_^TMP("dhcpha",pid,"D1","PRICE",j,i)
	..s getinfo2=^TMP("dhcpha",pid,"D1","OEFLAG",j,i)_"&"_^TMP("dhcpha",pid,"D1","TYPE",j,i)_"&"_^TMP("dhcpha",pid,"D1","DOSAGE",j,i)_^TMP("dhcpha",pid,"D1","UOM",j,i)
	..s getinfo3=^TMP("dhcpha",pid,"D1","FREQ",j,i)_"&"_^TMP("dhcpha",pid,"D1","INST",j,i)_"&"_^TMP("dhcpha",pid,"D1","DURA",j,i)_"&"_^TMP("dhcpha",pid,"D1","PRESC",j,i)_"&"_^TMP("dhcpha",pid,"D1","BATNO",j,i)
	..s getinfo4=^TMP("dhcpha",pid,"D1","OE",j,i)_"&"_^TMP("dhcpha",pid,"D1","YBTYPE",j,i)_"&"_^TMP("dhcpha",pid,"D1","AUDITED",j,i)
	..s getinfo5=^TMP("dhcpha",pid,"D1","GENERIC",j,i)_"&"_^TMP("dhcpha",pid,"D1","FORM",j,i)_"&"_^TMP("dhcpha",pid,"D1","BARCODE",j,i)_"&"_^TMP("dhcpha",pid,"D1","MANFACTURE",j,i)
	..s getinfo6=^TMP("dhcpha",pid,"D1","INCSTK",j,i)_"&"_^TMP("dhcpha",pid,"D1","AMT",j,i)_"&"_^TMP("dhcpha",pid,"D1","USERADD",j,i)_"&"_^TMP("dhcpha",pid,"D1","DATATIME",j,i)_"&"_^TMP("dhcpha",pid,"D1","DIAGNOSE",j,i)
	..s getinfo7=^TMP("dhcpha",pid,"D1","AGE",j,i)_"&"_^TMP("dhcpha",pid,"D1","ACTION",j,i)_"&"_^TMP("dhcpha",pid,"D1","SEX",j,i)
	..s getMed=getinfo0_"&"_getinfo1_"&"_getinfo2_"&"_getinfo3_"&"_getinfo4_"&"_getinfo5_"&"_getinfo6_"&"_getinfo7
	..s num=num+1
	..;s mPLIST(num)=getMed
	..s ^TMP("dhcpha",pid,"DISPD",num)=getMed
	..
	..s nnn=$o(^TMP("dhcpha",pid,"DISPDTOTAL",""),-1)  ;2007-03-19
	..s nnn=$g(nnn)+1 ;2007-03-19
	..s ^TMP("dhcpha",pid,"DISPDTOTAL",nnn)=getMed ;2007-03-19
	.; 
	k ^TMP("dhcpha",pid,"D1")
	q num
Auto(DispCat,PID)
    s hh=1	
    s userid=$g(%session.Data("LOGON.USERID"))
	f  s type=$p(DispCat,"^",hh)  q:type=""  d
	.s phaid=..SAVEDATA("","",type,PID,userid,"")
	.s hh=hh+1
	q
}

ClassMethod PCHCOLLS(loc1 As %String, ward1 As %String, datefrom1 As %String, dateto1 As %String, user1 As %String, SpecialPha As %String, LFlag As %String, SFlag As %String, OutFlag As %String, DispCat As %String, DoctorLocRowid As %String, NotAudit As %String, timefrom1 As %String, timeto1 As %String, incidr As %String) As %Integer
{
 ;save the data into temporary global
 n (loc1,ward1,datefrom1,dateto1,user1,SpecialPha,LFlag,SFlag,OutFlag,DispCat,DoctorLocRowid,NotAudit,timefrom1,timeto1,incidr)
 ;
 s datefrom1=$zdh(datefrom1,4)
 s dateto1=$zdh(dateto1,4)
 s datefrom=datefrom1
 s dateto=dateto1 
 s timefrom=timefrom1
 s timeto=timeto1
 s tmpstr=SFlag  ; 临嘱"||"加急
 s SFlag=$p(tmpstr,"||",1)
 s EmOrdFlag=$p(tmpstr,"||",2)
 s PackFlag=$p(tmpstr,"||",3)
 s npid=..NewPid() ; 
 s ward=$g(ward1)  ; get rowid of ward 
 s loc=$g(loc1),user=$g(user1)
 i (SpecialPha="0")&(ward="") q -1  ; 病区为空
 i (SpecialPha="1")&(ward'="") q -1   ; 特殊药房发药（病区应不加限定）
 s i=0

 f date=datefrom:1:dateto d
 .s ord=""               ;
 .f  s ord=$o(^OEORDi(0,"LocStDtArr",loc,0,date,ord)) q:ord=""  d
 ..q:'$D(^OEORD(ord))
 ..s adm=$p(^OEORD(ord),"^",1)  
 ..q:adm=""
 ..s admward=$p(^PAADM(adm),"^",70)  ;病人所在病房                              
 ..q:(SpecialPha="0")&(admward'=ward) 
 ..
 ..//s AmtReult=##class(web.DHCSTPCHCOLLS2).IFGivePHC(adm,ward,SpecialPha)
 ..//q:AmtReult=-1  ;对欠费的处理   ..
 ..s AmtRet=##class(web.DHCSTPCHCOLLS2).CheckArrears(adm,loc,date,ord)
 ..q:AmtRet'="Y" ;对欠费的处理 (最新080725)  ..
 ..s chl="" f  s chl=$o(^OEORDi(0,"LocStDtArr",loc,0,date,ord,chl)) q:chl=""  d
 ...s panoflag=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
 ...
 ...//紧急发放控制
 ...//s Emergency=..Getpaque(adm,panoflag)
 ...//q:(EmOrdFlag="EmOrd")&(Emergency'="Y")           
 ...
 ...s OrdItmRowid=ord_"||"_chl 
 ...//s reploc=$p(^OEORD(ord,"I",chl,3),"^",6) q:+reploc'=+loc  ; the receive loc is not the specified loc                                  ;医嘱接收位置
 ...
 ...s pr=$p(^OEORD(ord,"I",chl,1),"^",8) q:pr=""    ;优先级不存在的不予发放 2006-05-27  
 ...
 ...s ordtime=$p(^OEORD(ord,"I",chl,1),"^",17)		;oeori_time,2007-07-23,zdm,判断是否在要求的时间内
 ...q:(date=datefrom)&(ordtime'="")&(timefrom'="")&(ordtime<timefrom)
 ...q:(date=dateto)&(ordtime'="")&(timeto'="")&(ordtime>timeto)
 ...
 ...s priority=$p(^OECPR(pr),"^",1)                 ;医嘱优先级代码
 ...q:priority="OM" ;自备药即刻
 ...q:priority="OMST" ;自备药长期
 ...;q:priority="PRN"  ;
 ...i LFlag="1"    q:priority'="S"       ;只处理长期医嘱
 ...i OutFlag="1"  q:priority'="OUT"      ;只处理出院带药
 ...;i SFlag="1"    q:(priority="S")!(priority="OUT")         ;只处理即刻医嘱和取药医嘱   
 ...;i OutFlag'="1"  q:priority="OUT"      ;在不选中"仅发出院代药"的情况下,不包括出院带药
 ...i SFlag="1"    q:(priority="S") ;华西出院带药归临嘱
 ...
 ...q:##class(web.DHCSTPCHCOLLS2).SkinTest(ord_"||"_chl)<0 		;not skintest,2006-05-13 added
 ...s doctor=$p(^OEORD(ord,"I",chl,7),"^",1)
 ...;s doctorloc=..DocLocRowid(doctor)
 ...
 ...s doctorloc=$p(^OEORD(ord,"I",chl,7),"^",2)   ;060725
 ...;i (SpecialPha="0")&(DoctorLocRowid="") q:..IfAuditByPriority(ord,chl,pr)   ;非医生科室发药执行审核检查
 ...
 ...i (SpecialPha="1")&(DoctorLocRowid'="")  q:(DoctorLocRowid'=doctorloc)  ; 实行医生科室发药时的控制
 ...i (SpecialPha="0")&(DoctorLocRowid="") q:(..DoctorLocRefuse(loc,doctorloc)=1) ;病区发药时过滤掉医生科室
 ...
 ...q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(OrdItmRowid)   ;被拒绝发放
 ...s dodis=..GetDODIS(OrdItmRowid,"1") q:dodis="" 								;dhc_oedispensing中无记录
 ...s bedid=$p(^PAADM(adm),"^",73)                                             ;PA_Beds RowId
 ...i bedid="" s bed=""
 ...e  s bed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)        ;病人床号
 ...s deploc=$p(^PAADM(adm),"^",4)                                             ;病人所在科室
 ...s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",1)          ;医嘱核实、未核实、停止状态
 ...q:oeflag="D"  ; Stoped Item excluded zhwh.05.11.01
 ...s sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)                                    ;Order Start Date     
 ...q:(oeflag'="V")&(oeflag'="E")
 ...s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
 ...s arccatid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)        ;医嘱子类RowId
 ...s catcode=$p(^ARC("IC",arccatid),"^",1)            ;arccat(j,i)              ;医嘱子类代码
 ...s cat=..GetCat(catcode)
 ...q:..CatInList(DispCat,cat)=0  ;If the cat not in the required cat list then quit
 ...;q:((..GetCat(catcode)="PJ")&(priority="ONCE"))
 ...s DspQty=..CalDspQty(dodis)   //计算发药数
 ...
 ...s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""
 ...q:(incidr'="")&(inci'=incidr)		;2007-8-21,zdm
 ...s AmtFlag=##class(web.DHCSTPCHCOLLS2).IfCollectDrugAllowed(adm,arccatid)  ;最终结算,则不发药
 ...q:AmtFlag=0
 ...; <--------片剂无须分开发则注释-------
 ...s qtypackuom=$p(^OEORD(ord,"I",chl,9),"^",4)
 ...q:(PackFlag="ISPACK")&(qtypackuom="")&(cat="PJ") ;整发 
 ...q:(PackFlag="NOPACK")&(qtypackuom'="")&(cat="PJ") ;片发 
 ...;------------------------------>
 ...s i=i+1                                                                  ;
 ...s j=deploc_"||"_bed_"||"_oeflag_"||"_priority_"||"_adm
 ...
 ...s ^TMP("dhcpha",npid,"D","ADM",j,i)=adm                                               ;adm(j,i)
 ...s ^TMP("dhcpha",npid,"D","OEDIS",j,i)=ord_"||"_chl                ;oedis(j,i)         ;        
 ...s ^TMP("dhcpha",npid,"D","PRESC",j,i)=$p(^OEORD(ord,"I",chl,1),"^",14)                ;presc(j,i)         ;医需处方号
 ...s ^TMP("dhcpha",npid,"D","QTY",j,i)=DspQty  		 ;qty(j,i)           ;发药数量        
 ...s ^TMP("dhcpha",npid,"D","BED",j,i)=bed    		;bed(j,i)                                                     ;病人床号
 ...s ^TMP("dhcpha",npid,"D","ARCCAT",j,i)=cat
 ...
 ...s ^TMP("dhcpha",npid,"D","PRICE",j,i)=..getprice(inci,sttdate)    ;price(j,i)           ;医嘱价格
 ...s ^TMP("dhcpha",npid,"D","OEFLAG",j,i)=oeflag       ;oeflag(j,i)                        ;医嘱核实、未核实、停止状态
 ...s ^TMP("dhcpha",npid,"D","DEPLOC",j,i)=deploc       ;deploc(j,i)                        ;病人所在科室       
 ...i ^TMP("dhcpha",npid,"D","BED",j,i)="" s ^TMP("dhcpha",npid,"D","BED",j,i)="*"   ;bed(j,i)
 ...s ^TMP("dhcpha",npid,"D","AUDITED",j,i)=$g(Audited) ;
 ...s ^TMP("dhcpha",npid,"D","INCI",j,i)=inci     ;库存项目rowid
 ...s ^TMP("dhcpha",npid,"D","DODIS",j,i)=dodis     ;DHC_OeDispensing
 ...s ^TMP("dhcpha",npid,"D","BATNO",j,i)=""
 ...;s ^TMP("dhcpha",npid,"D","USERPRIORITY",j,i)=$g(userpriority)
 ...s ret=..AddAdmOrdItm(npid,cat,adm,ord_"||"_chl,DspQty)  ;2007-01-08
 ...
 ...
 ..
 .
 i i>0 s ^TMP("dhcpha",npid,"DISPM")=loc_"^"_ward_"^"_datefrom_"^"_dateto_"^"_user1
 i i>0 q npid    ; return the process ID
 q ""
}

ClassMethod DoctorLocRefuse(phaloc, doctorloc)
{
 ;1:拒绝的医生科室 0:非拒绝的医生科室
 n (phaloc,doctorloc)
 &sql(select * from CT_LocLinkLocation where link_parref=:phaloc and link_ctloc_dr=:doctorloc)
 q:'SQLCODE 1
 q 0
}

ClassMethod GetDODIS(oeori As %String, NotAudit As %String = "") As %String
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
 . //q:(NotAudit'="1")&(..IfAuditByPriority(ord,chl,priority))&(..AuditedDodis(ret)=0)
 . q:(NotAudit'="1")&(##Class(web.DHCSTCOMMONSRV).IfAuditByPriority(ret)=0)	//zhouyg 20141220
 . i result="" s result=ret
 . e  s result=result_"^"_ret
 q result
}

ClassMethod IfAuditByPriority(ord As %String, itm As %String, priority As %String) As %String
{
  n (ord,itm,priority)
  ;q  1 -- 需审核   0 -- 不需审核
  s recloc=$P($g(^OEORD(ord,"I",itm,3)),"^",6)
  s doctorloc=$p(^OEORD(ord,"I",itm,7),"^",2)
  q:..DoctorLocRefuse(recloc,doctorloc)=1 0   //医生科室不需审核
  q 0
 
  ;#2.以下韶关的审核控制
  q:ord="" -1
  q:itm="" -1
  s recloc=$P($g(^OEORD(ord,"I",itm,3)),"^",6)
  q:recloc="" -1
  i (recloc="537") q 0
  i (recloc="540") q 0
  i (recloc="468") q 0
  i (recloc="506") q 0
  s priorityCode=$p($g(^OECPR(+priority)),"^",1)
  i priorityCode="OUT" q 0  //出院带药不需审核
  q 1
  //
}

ClassMethod AuditedDodis(dodis) As %String
{
	//dhc_oedispensing 记录是否审核
    q:dodis="" ""
	q:$p($g(^DHCOEDISQTY(dodis)),"^",17)="Y" 1
	q 0
}

ClassMethod CalDspQty(dodiss As %String) As %String
{
	//根据dodis串，汇总应发药数量
	n (dodiss)
	s totalQty=0
	s cnt=$l(dodiss,"^")
	f i=1:1:cnt d
	. s dodis=$p(dodiss,"^",i)
	. q:$p(^DHCOEDISQTY(dodis),"^",7)'="TC" 
	. s qty=$p(^DHCOEDISQTY(dodis),"^",11) 
	. s totalQty=totalQty+qty
	q totalQty
}

ClassMethod ReGetDodis(dodiss As %String, ord As %String, chl As %String) As %String
{
 //重新判断dhc_oedispensing状态
 n (dodiss,ord,chl)
 s result=""
 q:dodiss="" result
 s cnt=$l(dodiss,"^")
 f i=1:1:cnt d
 .s dodis=$p(dodiss,"^",i)
 .q:$p(^DHCOEDISQTY(dodis),"^",7)'="TC" 
 .
 .s pr=$p(^OEORD(ord,"I",chl,1),"^",8)  //医嘱优先级
 .
 .//s auditRequired=..IfAuditByPriority(ord,chl,pr)  //是否需审核
 .//q:auditRequired<0
 .//i auditRequired>0 q:..AuditedDodis(dodis)'=1  //要求审核的情况下,未审核时不予处理
 .q:##Class(web.DHCSTCOMMONSRV).IfAuditByPriority(dodis)=0	//zhouyg 20141220
 .i result="" s result=dodis
 .e  s result=result_"^"_dodis
 q result
}

ClassMethod GetCat(CATCODE As %String) As %String
{
 n (CATCODE)
 s CATCODE=$$ALPHAUP^SSUTIL4(CATCODE)
 s ordcatdr=$o(^ARC("IC",0,"Code",CATCODE,"")) q:ordcatdr="" ""
 s SDG=$o(^DHCSTDRUGGRP(0,"ORDCAT",ordcatdr,"")) q:SDG="" ""
 s dispcat=$p(^DHCSTDRUGGRP(SDG),"^",1)
 q dispcat
}

ClassMethod CatInList(dispcat, cat)
{
 n (dispcat, cat)
 s i=1
 s result=0
 f  s tmp=$p(dispcat,"^",i) q:(tmp="")!(result=1)  d
 . i cat=tmp s result=1 q
 . s i=i+1
 q result
}

ClassMethod getprice(INCITM As %String, STTDATE As %String) As %Currency
{
 n (INCITM,STTDATE)
 ;-------calculate the retail price-------------------
 s STTDATE=STTDATE+1
 s excudate=$o(^INASP(0,"INCI",INCITM,STTDATE),-1)
 q:excudate="" 0
 s adjrow=$o(^INASP(0,"INCI",INCITM,excudate,""))
 s PRICE=$p(^INASP(adjrow),"^",7)       
 q PRICE
}

ClassMethod AddAdmOrdItm(pid As %String, cat As %String, adm As %String, orditm As %String, qty As %String) As %String
{
 //2007-01-08
 //用来暂时存储"费用检查"使用的数据
 s orditemqty=orditm_$c(2)_qty
 i '$d(^TMP(pid,"ADMBILL",cat,adm)) d
 . s ^TMP(pid,"ADMBILL",cat,adm)=orditemqty
 e   d
 . s ^TMP(pid,"ADMBILL",cat,adm)=^TMP(pid,"ADMBILL",cat,adm)_"^"_orditemqty	
 
 s ^TMP(pid,"ORDITEMS",cat,orditm)=""   ;记录医嘱
 q ""
}

ClassMethod NewPid() As %String
{
 q $I(^DHCSTPHARMACY("COLL"))
}

ClassMethod SAVEDATA(phactype As %String, pid As %String, CollectUserRowid As %String, ifsend As %String) As %String
{
	
	n (phactype,pid,CollectUserRowid,ifsend)
	s phactype=$g(phactype)
	s retbill=..CheckIfDispAllowed(pid,phactype)  ;2007-01-08
	s phacdatefrom=$p(^TMP("dhcpha",pid,"DISPM"),"^",3)
	s phacdateto=$p(^TMP("dhcpha",pid,"DISPM"),"^",4)
	s phacward=$p(^TMP("dhcpha",pid,"DISPM"),"^",2)
	s phacloc=$p(^TMP("dhcpha",pid,"DISPM"),"^",1) i phacloc=""  s phacward="*"
	s phacuser=$p(^TMP("dhcpha",pid,"DISPM"),"^",5)
	s phacpdate=+$h
	s phacptime=$p($h,",",2)
	s phacstatus="Print"
	s j=0
	s HospID=""
	i phacloc'="" d
	.s HospID=$p($g(^CTLOC(phacloc)),"^",22)
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
	s phacrowid=""
	;
	s arcpj="" f  s arcpj=$o(^TMP("dhcpha",pid,"D","ADM",arcpj))  q:arcpj=""  d
	.s arcpjsub="" f  s arcpjsub=$o(^TMP("dhcpha",pid,"D","ADM",arcpj,arcpjsub)) q:arcpjsub=""  d 
	..i phactype=^TMP("dhcpha",pid,"D","ARCCAT",arcpj,arcpjsub) d        
	...;s phaciadm=^TMP("dhcpha",pid,"D","ADM",arcpj,arcpjsub)
	...;s phacibed=^TMP("dhcpha",pid,"D","BED",arcpj,arcpjsub)
	...s phacidis=^TMP("dhcpha",pid,"D","OEDIS",arcpj,arcpjsub)  ;OE_OrdItem
	...;q:##class(web.DHCSTPCHCOLLS2).OrdItmAudited(phacidis)<0    ;保存前判断是否审核
	...;q:..OrdItmAudited(phacidis)<0  ;未审核不予发药
	...q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(phacidis)>0   ; refused can not be saved
	...s DODIS=^TMP("dhcpha",pid,"D","DODIS",arcpj,arcpjsub) 		 ; DHC_OeDispensing
	...
	...
	...;q:phacistatus="D"  ;if orditem hase been stop then quit
	...;i (phacward'="") q:..OrdItmAudited(phacidis)<0   ; 医生科室发药不做审核的控制
	...q:..CheckOrditmAllowed(pid,phactype,phacidis)=0   ;2007-01-08  计费控制
	...
	...i phacrowid="" s phacrowid=$$CreatePhaCollected()
	...;当phacrowid=-1 主表插入失败时没有动作
	...//s Err=..Dispensing(phacrowid,DODIS,phacidis)
	...i RuleFlag=3 d
 	....S Err=##class(web.DHCSTPCHCOLLS).DispensingByBatch(phacrowid,DODIS,phacidis)
 	...e  d
 	....S Err=##class(web.DHCSTPCHCOLLS).Dispensing(phacrowid,DODIS,phacidis) //2 处理发药及库存系列表
	...q:Err=""
	...;i Err=7 s nostk=##class(web.DHCSTPCHCOLLS).CreateNoStock(DODIS,phacidis,pid)  //构造库存不足数据
	...q:Err'=0
	...;d Modifytobill(phacidis) //修改医嘱帐单状态   
	...s phactype=$p(^DHCPHAC(phacrowid),"^",12)
 	...;i phactype="ZCY" d CREATEFORFIND(DODIS)
	...s j=j+1
	...
	;
	i j=0 d
	. &sql(delete from dhc_phacollected where dhc_phacollect_rowid=:phacrowid )
	q:j=0 0
	;
	i phacrowid>0 s ret=$$Collect(phacrowid,CollectUserRowid) ;make collect flag
	
	i phacrowid>0 d     ;发药后立即做账单
	. ;s ret=..MakeBill(phacrowid)   ;2007-01-08
	. d ..killTmpBill(pid,phactype)  ;2007-01-08
	. 
	. //生成摆药机数据
	. //i ifsend=1 s ret=..SendToAuto(phacrowid)
	. //华西传送老HIS接口
	. ;s ret=##class(web.DHCSTPCHCOLLS).SendHX(phacrowid) 
	. //华西汇总全院大输液
	. i phactype="DSY"  d ..SetPrtTotal(phacrowid,phacuser) 
	q $g(phacrowid)

CREATEFORFIND(dhcoedis)
 ;以下构造饮片医嘱查询(组件)数据集   
 ;for bjzy  lq  2008-03-27
 n (dhcoedis)
 s m=1
 s oeori=$p(^DHCOEDISQTY(dhcoedis),"^",1) 
 s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
 s adm=$p(^OEORD(ord),"^",1)
 s no=$p(^OEORD(ord,"I",itm,1),"^",14)
 s queid=$o(^PAQUE1(0,"PrescNo",no,""))
 ;s queid="" f  s queid=$o(^PAQUE1(0,"QUE1_PAADM_DR",adm,queid)) q:queid=""  d
 ;s quno=$p(^PAQUE1(queid),"^",14) ;处方号
 q:'$d(^PAQUE1(queid,"DHC")) ;过滤非中草药
 ;q:quno'=no ;过滤非同一处方
 s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
 s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
 i +facotor>1 s cnt=+facotor-1
 e  s cnt=+facotor
 s qustdate=$p(^PAQUE1(queid,"DHC"),"^",4)
 f i=0:1:cnt d
 .i $d(^CREATEFORFIND(+qustdate+i)) d 
 ..s m=$o(^CREATEFORFIND(+qustdate+i,""),-1)+1
 .s ^CREATEFORFIND(+qustdate+i,m,ord_"||"_itm)=""
 q
 
Modifytobill(dodis)
  n (dodis)
  s ord=$p(dodis,"||",1),itm=$p(dodis,"||",2)
  i $p(^OEORD(ord,"I",itm,3),"^",5)="P" q 
  s $p(^OEORD(ord,"I",itm,3),"^",5)="TB" 
  q
   
CreatePhaCollected()
	k PLIST
	s PLIST(2)=$g(phacloc)
	s PLIST(5)=$g(phacward)
	s PLIST(6)=$g(phacuser)
	s PLIST(7)=$g(phacstatus)
	s PLIST(8)=$g(phacpdate)
	s PLIST(9)=$g(phacptime)
	s PLIST(11)=$g(phacdatefrom)
	s PLIST(12)=$g(phacdateto)
	s PLIST(13)=$g(phactype)
	s PLIST(15)=..GetDispNo($g(phacloc))
	&sql(INSERT INTO DHC_PHACollected VALUES :PLIST())
	q:SQLCODE -1
 	q +$g(%ROWID)
    
Collect(phacdr, Nurse)
	n (phacdr,Nurse)
	s Nurse=$g(Nurse)
	s Col="Collect"
	i '$d(^DHCPHAC(phacdr)) q -1
	; calculate the rowcount of items 
	s phacdate=+$h
	s phactime=$p($h,",",2)
	s phaci=0 
	s cnt=0 
	f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
	.s cnt=cnt+1
	.;s qty=$p(^DHCPHAC(phacdr,"I",phaci),"^",6)    ;not use
	.;s oedis=$p(^DHCPHAC(phacdr,"I",phaci),"^",7)  ;not use
	.;s oeflag=$p(^DHCPHAC(phacdr,"I",phaci),"^",10)    ;not use
	.;i oeflag="D"  d ##class(web.DHCSTPHARETURN).ReturnDisp(oedis,qty,"")  ;not use
	
	s ret=0 
	i cnt=0 d
	. &sql(DELETE FROM DHC_PHACollected WHERE DHC_PHACollect_RowID=:phacdr)
	. s phacdr=""
	e  d
	. &sql(UPDATE DHC_PHACollected SET DHC_PHACounts=:cnt,DHC_PHACollectStatus=:Col,
	                                DHC_PHACollectDate=:phacdate,
	                                DHC_PHACollectTime=:phactime,
	                                DHC_PHACollectUser=:Nurse WHERE DHC_PHACollect_RowID=:phacdr)
	.i SQLCODE'=0 s ret=-2
	q:ret<0 ret
	;i (phacdr'="") d ##class(web.DHCSTPCHCOLLS2).ReUpdateOedis(phacdr) ;再置oe_dispensing表的dsp_status为Collected,避免再发药    ;not use
	q ret
}

ClassMethod Dispensing(phac As %String, dhcoedis As %String, oeori As %String) As %String
{
 ;根据dhc_oedispensing记录处理发药
 ;1 找批次
 ;2 生成发药记录
 ;3 处理该发药记录的库存
 ;3.1 处理INC_ItmLcBt和INC_ItmLoc
 ;3.2 处理dhc_locdailytotal,dhc_locbtdailytotal,dhc_intrans
 //s status=$p(^DHCOEDISQTY(dhcoedis),"^",7) q:status'="TC" "" ;并非发药状态时退出
 //s oeori=$p(^DHCOEDISQTY(dhcoedis),"^",1) q:oeori="" ""
 s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
 q:'$d(^OEORD(ord,"I",itm)) ""
 s ordstatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)          ;医嘱核实、未核实、停止状态
 q:ordstatus="D" ""     ;医嘱已停
 
 //s confqty=$p(^DHCOEDISQTY(dhcoedis),"^",11) q:confqty'>0 ""
 //
 
 s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
 s recloc=$p(^OEORD(ord,"I",itm,3),"^",6) q:recloc="" ""
 s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),"")) q:inci="" ""
 s ch=$o(^INCI("IL_LOC",recloc,inci,"")) q:ch="" ""
 s incil=inci_"||"_ch
 
 l +^DHCOEDISPENSING(oeori):5  e  q -100   ;加锁
 s ordstatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)          ;医嘱核实、未核实、停止状态
 i ordstatus="D"  l -^DHCOEDISPENSING(oeori)  q -103     ;医嘱已停(再次判断)
 s dodiss=..ReGetDodis(dhcoedis,ord,itm)
 i dodiss="" l -^DHCOEDISPENSING(oeori) q ""
 s confqty=..CalDspQty(dodiss)
 i confqty=0 l -^DHCOEDISPENSING(oeori) q ""
 //s status=$p(^DHCOEDISQTY(dhcoedis),"^",7)
 //i status'="TC" l -^DHCOEDISPENSING(dhcoedis) q -102 ;并非发药状态时退出(再次判断)
 ;
 s err=0
 s cnt=$$SelClbQty(incil,confqty)
 s code="C"
 i cnt>0 d  ;数量够用
 . tstart
 . f i=1:1:cnt q:err>0  d
 . . s inclb=xINCLB(i)
 . . s qty=xQTY(i)
 . . s phaci=$$InsPhacItm(phac,ord,itm,inclb,qty,dhcoedis) ;生成发药记录
 . . i phaci="" s err=1 
 . . q:phaci=""
 . . s ret=..HandlePhaResQty(phaci)
 . . i ret<0 s err=2 
 . . q:ret<0
 . . s resultstk=##class(DHCSTPCHCOLLS2).DhcStkTab(phaci)  ;处理该笔发药记录的台帐库存
 . . i resultstk<0 s err=3 
 . . q:resultstk<0
 . . 
 . . s ret=##class(web.DHCST01).UPDINV1(inclb,-qty)  ;处理该笔发药批次和总库存
 . . i ret=0 s err=4 
 . . q:ret=0
 . . ;修改dhc_oedispensing的字段内容
 . . 
 . . //s dd=$p(^DHCPHAC(phac),"^",7),tt=$p(^DHCPHAC(phac),"^",8)  ;打印日期、时间
 . . //s user=$p(^DHCPHAC(phac),"^",5)
 . . //s type="P"
 . . //s pointer=phaci
 . . //s formerPointer=$p(^DHCOEDISQTY(dhcoedis),"^",14)
 . . //i formerPointer'="" s pointer=formerPointer_","_pointer
 . . //&sql(update DHC_OEDispensing set dsp_status=:code,dsp_date=:dd,dsp_time=:tt,dsp_user=:user,dsp_type=:type,dsp_pointer=:pointer where dsp_rowid=:dhcoedis)
 . . //i SQLCODE s err=5  
 . . //q:SQLCODE
 . . //
 . . i (phaci'="")&(dodiss'="") s ret=..UpdStatusForDODISS(phaci,dodiss)
 . . i ret<0 s err=7
 . . q:ret<0
 . . ;消掉保留数量(INC_ItmLoc.INCIL_ReservedQty)
 . . s ret=##class(web.DHCST01).UPDINVRESQTY(inci,recloc,-qty)
 . . i ret<0  s err=6 
 . . q:ret<0
 . i err>0 trollback
 . q:err>0
 . tcommit
 e  d  
 .s err=7  ;即库存不够的情况
	l -^DHCINCIL(incil)   ;incil去锁
	l -^DHCOEDISPENSING(oeori)  ;去锁
	q err

SelClbQty(incil, dspqty)
  ;按照发药数选择批次,PDELIM="!"
 n cnum,i,sumdqty,clbqty,k
 l +^DHCINCIL(incil):10  e  q 0
 s cnum=$$GetClbQtyObExp(incil)
 i cnum=0  l -^DHCINCIL(incil) q 0  
 s k=0
 s sumdqty=0
 s clbqty=dspqty
 k xINCLB,xQTY
 f i=1:1:cnum q:clbqty'>0   d
 . i Eqty(i)'<clbqty d
 . .s k=k+1
 . .s xINCLB(k)=CLB(i)
 . .s xQTY(k)=clbqty
 . .s clbqty=clbqty-xQTY(k)
 . .s sumdqty=$g(sumdqty)+xQTY(k)
 . e  d
 . .s k=k+1
 . .s xINCLB(k)=CLB(i)
 . .s xQTY(k)=Eqty(i)
 . .s clbqty=clbqty-xQTY(k)
 . .s sumdqty=$g(sumdqty)+xQTY(k)
 i sumdqty<dspqty q 0  //当所查到的可发批次库存之和<发药总数量,不予发药 2008-07-16
 q k

 
GetClbQtyObExp(incil) 
 ;INCLB按效期排序
 n num,tclb,tqty
 k CLB,Eqty 
 &sql(DECLARE CurrExp CURSOR FOR
 SELECT INCLB_ROWID,INCLB_PHYQTY-nvl(INCLB_DirtyQty,0) FROM INC_ITMLCBT 
 WHERE INCLB_INCIL_PARREF=:incil order by INCLB_INCIB_DR->INCIB_EXPDATE )
 &sql(open CurrExp)
 s num=0
 f  &sql(fetch CurrExp INTO :tclb,:tqty) q:SQLCODE  d                                                                            
 .;s tqty=$$CurQtyINCLB^DHCSTSTKQTY(tclb)
 .;s tqty=$$CuyInclbAvaQty^DHCSTSTKQTY(tclb,"")
 .i tqty>0 d
 ..s num=num+1
 ..s CLB(num)=tclb
 ..s Eqty(num)=tqty
 &sql(close CurrExp)
 q num

InsPhacItm(phacrowid,ord,itm,inclb,qty,dhcoedis) 
 n (phacrowid,ord,itm,inclb,qty,dhcoedis)
 s phaciadm=$P(^OEORD(ord),"^",1) ;adm_dr
 s phacipresc=$p(^OEORD(ord,"I",itm,1),"^",14)   ;处方号
 s phaciinci=inclb
 s PhcLocID=$p($g(^DHCPHAC(phacrowid)),"^",1)
 s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(PhcLocID)
 s HospID=$p(CustStr,"^",5)
 s CustID=$p(CustStr,"^",1)
 s exStr=ord_"||"_itm_"^"
 s phaciprice=##Class(web.DHCSTPRICE).GetSp(+phaciinci,+$h,"",HospID,"",exStr)
 //s phaciprice=##class(web.DHCSTCOMMONSRV).GetPriceElse(+phaciinci,+$h,"",HospID)
 s phacistatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)
 s phaciloc=$p(^PAADM(phaciadm),"^",4)   ;admloc
 s phacibed=$p(^PAADM(phaciadm),"^",4)  ;bedno
 s phaciqty=qty   ;发药数
 s j=$o(^DHCPHAC(phacrowid,"I",""),-1)+1   ;child sub
 s bedid=$p(^PAADM(phaciadm),"^",73)                                             ;PA_Beds RowId
 i bedid="" s phacibed=""
 e  s phacibed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)        ;病人床号
 ;
 s SpAmt=phaciprice*phaciqty
 S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+phaciinci)
 S StkTypeDesc=$P(CatGrpStr,"^",4)
 S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
 s SpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(SpAmt,Perv,"FmtSA",1)
 s PLIST(0)=$g(phacrowid)
 s PLIST(2)=$g(phaciadm)
 s PLIST(3)=$g(phacipresc)
 s PLIST(4)=$g(phaciinci)
 s PLIST(5)=+$g(phaciqty)
 s PLIST(6)=ord_"||"_itm      ;$g(phacidis)   ;oe_orditem
 s PLIST(7)=j
 s PLIST(10)=$g(phacibed)
 s PLIST(11)=+$g(phaciprice)
 s PLIST(12)=$g(phacistatus)
 s PLIST(13)=$g(phaciloc)
 //s PLIST(15)=$g(dhcoedis)   //此字段不再使用2008-05-14
 s PLIST(17)=+SpAmt
 &sql(INSERT INTO DHC_PHACollectItm VALUES PLIST())
 q:SQLCODE ""
 q %ROWID
}

ClassMethod UpdStatusForDODISS(phaci As %String, dodiss As %String) As %String
{
 //修改dhc_oedispensing的字段内容
 //phaci - dhc_phacollectitm.phaci_rowid
 //dodiss - dodis串
	n (phaci,dodiss)
	s err=0
	q:phaci="" err
	q:dodiss="" err
	//
	s phac=+phaci	
	s dd=$p($g(^DHCPHAC(phac)),"^",7),tt=$p($g(^DHCPHAC(phac)),"^",8)  ;打印日期、时间
	s user=$p($g(^DHCPHAC(phac)),"^",5)
	s type="P" 
	s code="C"  //"已发药状态"
	s pointer=phaci
	s cnt=$l(dodiss,"^")
	f i=1:1:cnt q:err'=0  d
	.s dhcoedis=$p(dodiss,"^",i) q:dhcoedis=""
	.s formerPointer=$p(^DHCOEDISQTY(dhcoedis),"^",14)
	.i formerPointer'="" s pointer=formerPointer_","_pointer
	.&sql(update DHC_OEDispensing set dsp_status=:code,dsp_date=:dd,dsp_time=:tt,
	  dsp_user=:user,dsp_type=:type,dsp_pointer=:pointer where dsp_rowid=:dhcoedis)
	.i SQLCODE'=0 s err=-1 q
	q err
}

ClassMethod HandlePhaResQty(phaci As %String) As %String
{
 //处理发药扣除数据...
 n (phaci)
 s phac=$P(phaci,"||",1)
 s ch=$p(phaci,"||",2)
 s ward=$p(^DHCPHAC(phac),"^",4)
 q:ward="" ""
 s wardloc=$p(^PAWARD(ward),"^",5  )
 q:wardloc="" ""
 s phaloc=$p(^DHCPHAC(phac),"^",1)
 s qty=$p(^DHCPHAC(phac,"I",ch),"^",6)
 s inci=+$p(^DHCPHAC(phac,"I",ch),"^",4)
 s pres=$o(^DHCPRES(0,"LOCINCIWARD",phaloc,inci,ward,"")  )	
 q:pres="" ""
 s resqty=$p(^DHCPRES(pres),"^",4)
 ;
 i resqty>qty d
 .s $p(^DHCPHAC(phac,"I",ch),"^",12)=qty
 .s newResqty=resqty-qty
 e  d
 .s $p(^DHCPHAC(phac,"I",ch),"^",12)=resqty
 .s newResqty=0
 ;
 s $p(^DHCPRES(pres),"^",4)=newResqty
 s ret=$$HandleResQtyInRet(phaloc,inci,wardloc,qty)
 q 1
HandleResQtyInRet(recloc, inci, wardloc, qty ) 
 ;查找reservedqty
 n (recloc,inci,wardloc,qty)
 s phar=""
 f  s phar=$o(^PHARET(0,"LOCINCIDEPT",recloc,inci,wardloc,phar)) q:(phar="")!(qty=0)  s data=^PHARET(phar) d
 .s resqty=$p(data,"^",21)
 .q:+resqty=0
 .
 .i resqty'<qty d
 .. s newresqty=resqty-qty
 .. s $p(^PHARET(phar),"^",21)=newresqty
 .. s qty=0
 .e  d
 .. s qty=qty-resqty
 .. s $p(^PHARET(phar),"^",21)=0
 q 0
}

ClassMethod GetDispNo(phaloc As %String) As %String
{
	//get prefix
	s phalocset=$o(^DHCPL(0,"Loc",phaloc,""))
	q:phalocset="" ""
	l +^DHCPL(phalocset):3
	s prefix=$P(^DHCPL(phalocset),"^",13)   
	s finaldate=$P(^DHCPL(phalocset),"^",15)   
	s countnum=$P(^DHCPL(phalocset),"^",12) 	
	i finaldate'=+$h d
	.s $P(^DHCPL(phalocset),"^",15)=+$h
	.s countnum=0
	s finaldate=$P(^DHCPL(phalocset),"^",15)   
	; s countnum=$P(^DHCPL(phalocset),"^",12) 	
	s countnum=countnum+1
	s $P(^DHCPL(phalocset),"^",12)=+countnum
	s dispno=prefix_$e($zd(finaldate,8),3,8)_$tr($j(countnum,4)," ","0")
	l -^DHCPL(phalocset)
	q dispno
}

ClassMethod KillTmpAfterSave(itmjs As %Library.String = "", itmjsex As %Library.String = "", pid As %String)
{
	d ..CLEARTMP(pid,"DISPM")	; 
	d ..CLEARTMP(pid,"DISPD")	; 
	d ..CLEARTMP(pid,"D")		; 
	q 0
}

ClassMethod CLEARTMP(pid, PAR As %String) As %String
{
 k ^TMP("dhcpha",pid,PAR)
 k ^TMP("dhcpha",pid)
}

ClassMethod killTmpBill(pid As %String, cat As %String)
{
	////2007-01-08
 q:$g(pid)=""                  //lrl
 q:$g(cat)=""                  //lrl
 k ^TMP(pid,"ORDITEMS",cat)
 k ^TMP(pid,"ADMBILL",cat)
}

ClassMethod CheckIfDispAllowed(pid As %String, cat As %String) As %String
{
 //2007-01-11
 //检查本次发药前病人的费用情况,若被控制,则不发药
 //
 s adm=""
 s code="C" , code1="N"
 f  s adm=$o(^TMP(pid,"ADMBILL",cat,adm)) q:adm=""  d
 .s str=^TMP(pid,"ADMBILL",cat,adm)
 .q:str="" 
 .s P5="",P9=""
 .s rtn=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(adm,str,"")   //lrl
 .q:rtn=0  ; ok
 .s P5=$p(rtn,"^",5),P9=$p(rtn,"^",9)          //lrl
 .i (P5=code)&(P9=code1) d                        //lrl
 .. s cnt=$l(str,"^")
 .. f xx=1:1:cnt d
 ... s xdata=$p(^TMP(pid,"ADMBILL",cat,adm),"^",xx)
 ... s xorditm=$p(xdata,$c(2),1)
 ... q:xorditm=""                           //lrl
 ... k ^TMP(pid,"ORDITEMS",cat,xorditm)
 q ""
}

ClassMethod CheckOrditmAllowed(pid As %String, cat As %String, oedis As %String) As %String
{
 //2007-01-08
 //检查医嘱是否允许发，1 - 可发 0 - 不可
 q:oedis="" 0
 q:cat="" 0
 s orditm=$p(oedis,"||",1,2)
 i $d(^TMP(pid,"ORDITEMS",cat,orditm)) q 1
 q 0
}

ClassMethod SetPrtTotal(phac As %String, userid As %String) As %String
{
 ///Description:构造全院发药汇总数据
 ///Creator: lq 08-11-06
 s chl=""
 s pid=$j
 s fdate=$p(^DHCPHAC(phac),"^",10)
 i fdate'="" s fdate=$zd(fdate,3)
 s tdate=$p(^DHCPHAC(phac),"^",11)
 i tdate'="" s tdate=$zd(tdate,3)
 s phalocdr=$p(^DHCPHAC(phac),"^",1)
 s phaloc=$p(^CTLOC(phalocdr),"^",2)
 f  s chl=$o(^DHCPHAC(phac,"I",chl)) q:chl=""  d
 .s inclb=$p(^DHCPHAC(phac,"I",chl),"^",4)
 .s incidesc=$p(^INCI(+inclb,1),"^",2)
 .s qty=$p(^DHCPHAC(phac,"I", chl),"^",6)
 .s spec=""
 .s uomdr=$p(^INCI(+inclb,1),"^",10)
 .s uom=$p(^CT("UOM",uomdr),"^",2)
 .s inci=+inclb
 .s generic=##Class(web.DHCSTCOMMONSRV).getGeneric(inci)
 .i $f(generic,"-") s generic=$p(generic,"-",2)
 .s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci)
 .i $f(manf,"-") s manf=$p(manf,"-",2)
 .i '$d(^TMP("dhcpha","PrtDSY",pid,userid,+inclb)) d
 ..s ^TMP("dhcpha","PrtDSY",pid,userid,inci)=generic_"^"_incidesc_"^"_spec_"^"_uom_"^"_qty_"^"_manf_"^"_inci_"^"_phaloc_"^"_fdate_"^"_tdate
 .e  d
 ..s $p(^TMP("dhcpha","PrtDSY",pid,userid,inci),"^",5)=$p(^TMP("dhcpha","PrtDSY",pid,userid,inci),"^",5)+qty
 q 0
}

ClassMethod ListPrtDSY(pid, userid, inci) As %String
{
	n (pid, userid , inci)
	s tmp=$o(^TMP("dhcpha","PrtDSY",pid,userid,inci))
	q:tmp="" ""
	s str=^TMP("dhcpha","PrtDSY",pid,userid,tmp)
	k ^TMP("dhcpha","PrtDSY",pid,userid,tmp)
	q str
}

ClassMethod KillPrtDSY(userid) As %String
{
	n (userid)
	i $d(^TMP("dhcpha","PrtDSY",$j,userid)) d
	.k ^TMP("dhcpha","PrtDSY",$j,userid)
	q $j
}

}

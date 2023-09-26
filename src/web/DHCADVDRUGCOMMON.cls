/// Creator: yangyongtao
/// CreateDate: 2016-05-24
/// Descript: 药品类
Class web.DHCADVDRUGCOMMON Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 民族
/// Creator:     yangyongtao
/// CreateDate:  2016-3-31
/// Table: 		 CT_Nation
/// Input:  	 
/// Return： 	 
/// Others:		 
/// Descritp:   
ClassMethod SelNation() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTNAT_RowId as NatDr,CTNAT_Desc as NatDesc FROM CT_Nation"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s NatDr = result.Data("NatDr")
		s NatDesc = result.Data("NatDesc")
		s:NatDesc["-" NatDesc=$p(NatDesc,"-",2)
		s tmp=NatDr_"^"_NatDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descript:  获取药品批号
/// Creator:     yangyongtao
/// CreateDate:  2016-4-12
/// Table: 		
/// Input:  	 报告表数据
/// Return： 	 数据id
/// Descript:w ##class(web.DHCADVDRUGCOMMON).getBatNoList("4||6")
ClassMethod getBatNoList(oeori As %String) As %String
{
	n (oeori)   //医嘱ID
	S pid=##class(web.DHCADVCOMMON).NewPid()
	s dsp=""
	s batno=""
	f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,dsp)) q:dsp=""  d
	.S status=$p(^DHCOEDISQTY(dsp),"^",7)
	.s type=$p(^DHCOEDISQTY(dsp),"^",13)
	.s pointor=$p(^DHCOEDISQTY(dsp),"^",14)
	.s main=+pointor
	.s ch=$p(pointor,"||",2)
	.i type="F" d
	..s sub=""
	..f  s sub=$o(^DHCPHDI(main,"PHDI",ch,"INCLB",sub)) q:sub=""  d
	...s inclb=$p(^DHCPHDI(main,"PHDI",ch,"INCLB",sub),"^",3)
	...s incib=$$CIBrow^at299(inclb)
	...q:incib=""
	...s batno=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",1)
	...s ^TMP("DHCADV","web.DHCADVDRUGCOMMON","getBatNoList",pid,batno)=batno
	...
	.i type="P" d
	..s sub=""
	..f  s sub=$o(^DHCPHAC(main,"I",ch,"B",sub)) q:sub=""  d
	...s inclb=$p(^DHCPHAC(main,"I",ch,"B",sub),"^",1)
	...s incib=$$CIBrow^at299(inclb)
	...q:incib=""
	...s batno=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",1)
	...s ^TMP("DHCADV","web.DHCADVDRUGCOMMON","getBatNoList",pid,batno)=batno
	d ..killTmpGlobal(pid)
    Q batno
}

/// Descript:获取病人医嘱信息 ^DHCOEDISQTY
/// W ##class(web.DHCADVDRUGCOMMON).GetPatOEInfo("10","1","43","")
ClassMethod GetPatOEInfo(rows As %String, page As %String, AdmDr As %String, InstruType As %String = "", inpdesc)
{
	N (rows,page,AdmDr,InstruType,inpdesc,%session)
	Q:AdmDr="" "-1"
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S ord=$o(^OEORD(0,"Adm",AdmDr,""))
	Q:ord="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	d ..killTmpGlobal(pid)
	S Num=0
    S chl=0 
    F  S chl=$o(^OEORD(ord,"I",chl)) q:(chl="")||(chl=0)  d
	.S orditm=ord_"||"_chl
	.S priDr=0
	.S:$d(^OEORD(ord,"I",chl,1)) priDr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    .Q:priDr=0 
    .S priorty=$p(^OECPR(priDr),"^",1) //医嘱优先级代码              
    .//Q:priorty["OM" //自备药
    .S priorty=$p(^OECPR(priDr),"^",2) //医嘱优先级
    .S StatDr=$p(^OEORD(ord,"I",chl,1),"^",13)
    .S OeFlag=$p(^OEC("OSTAT",StatDr),"^",1) 
	.//Q:(OeFlag'="V")&(OeFlag'="E")
	.S FillerNo=$p(^OEORD(ord,"I",chl,9),"^",12) //滚医嘱来源信息 OEORI_FillerNo
    .Q:(FillerNo'="")&(FillerNo'=orditm_"!!"_orditm)&(OeFlag'="D")  //长嘱非首日和截止日期的记录过滤
	.S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	.s MatchFlag=##class(web.DHCADVDRUGCOMMON).MatchAlias(ArcItmId,inpdesc) // 2021-01-26 cy 新增医嘱项检索
	.q:MatchFlag'="1"
	.S ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .Q:(ordertype'="R")
	.S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
    .S ArcimDesc=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2)  ; 取医嘱项名称，因为医嘱项和库存项存在一对多关系
	.;Q:$d(^TMP("DHCADV","web.DHCADVDRUGCOMMON","GetPatOEInfo",pid,Arcim))
	.;S ^TMP("DHCADV","web.DHCADVDRUGCOMMON","GetPatOEInfo",pid,ArcItmId)=ArcItmId
	.Q:inci=""  //医嘱名称
	.S incidesc=$p(^INCI(inci,1),"^",2) //药品名称
	.S dosage="",dosuomID="",doseuom="",freqdr="",freq="",instrudr="",instru="",durId="",duration=""
	.I $D(^OEORD(ord,"I",chl,2))  D
	..S dosage=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(ord_"||"_chl)  //sufan 2019-07-01 改调医生站接口//$p(^OEORD(ord,"I",chl,2),"^",1) //剂量
	..S dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	..S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) //剂量单位
	..S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) //OEORI_PHFreq_DR
    ..;S freq=$p($g(^PHCFR(freqdr)),"^",3) //频率				sufan  改调用接口2020-12-09
    ..s ordFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(ord_"||"_chl,"^","")
    ..s freqId = $List(ordFreqInfo,1)
				..s freq = $List(ordFreqInfo,2)
				..s freqCode =$List(ordFreqInfo,5)
				..S freq=$REPLACE(freq,"^","-")
    ..S instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    ..S instru=$p($g(^PHCIN(instrudr)),"^",2) //用法
    ..s durId=+$p(^OEORD(ord,"I",chl,2),"^",6)
    ..S duration=$p($g(^PHCDU(durId)),"^",3) //用药疗程
    .;S staDate=$p(^OEORD(ord,"I",chl,1),"^",9) //开始日期
    .S staDate=$p(^OEORD(ord,"I",$p(orditm,"||",2),1),"^",9)  //开始日期
    .S:staDate'="" staDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(staDate)
    .S endDate=$p(^OEORD(ord,"I",chl,3),"^",34) //结束日期
    .S:endDate'="" endDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(endDate)
    .Q:(InstruType="DZ")&&((instru'["滴注")&&(instru'["慢滴"))
    .S arcim=$p($g(^INCI(inci,1)),"^",3)
    .q:arcim=""
    .S phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) q:phcdf=""
    .s genenicdr=+$p($g(^PHCD(+phcdf,4)),"^",1)
    .s genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) //通用名
    .s formdr="",form=""
    .s:$d(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1)) formdr=$p(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1),"^",1)
    .s:formdr'="" form=$p(^PHCF(formdr),"^",2) //剂型
   
    .s manfdr="",manf=""
    .s manfList=##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci)  ;$p($g(^PHCD(+phcdf,2)),"^",4) //厂家
    .;s:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
    .s manfdr=$p(manfList,"^",1)
    .s manf=$p(manfList,"^",3)
    .;S:manf["-" manf=$p(manf,"-",2)
    .s apprdocu="",docunum=""
    .s itminfo=$o(^DHCITMINFO(0,"INCI",inci,""))
    .i itminfo'="" s apprdocu=$p(^DHCITMINFO(itminfo),"^",10) //批准文号
    .I apprdocu ["-"  S docunum=$p(apprdocu,"-",2)
    .I apprdocu ["-"  S apprdocu=$p(apprdocu,"-",1)
    .I docunum="undefined" S docunum=""
    .S apprdocu=apprdocu_"-"_docunum
    .;S spec="["_$p(^INCI(inci,3),"^",9)_"]" //规格
    .s spec=""
    .S:(itminfo'="")&&($p(^DHCITMINFO(itminfo),"^",27)'="") spec="["_$p(^DHCITMINFO(itminfo),"^",27)_"]"
    .s sub="",vendor=""
    .f  s sub=$o(^INCI(inci,"IB",sub))  q:sub=""  d
    ..q:+sub=0
    ..s list= ##class(web.DHCST.Common.DrugStkCommon).VendManfByIncIb(inci_"||"_sub) //查找批次供应商及厂家
    ..s:list'="" vendor=$p(list,"^",2) //查找批次供应商及厂家
    ..q:vendor'=""
    .s batno=..getBatNoList(orditm) //"AAAAAA" //批号
    .S statusID=""
    .S statusID=$o(^DHCOEDISQTY(0,"OEORI",orditm,statusID))
    .Q:statusID=""   //^DHCOEDISQTY
    .S status=$p(^DHCOEDISQTY(statusID),"^",7) //发药状态
    .s OrderPackQty=""
	.s:$d(^OEORD(ord,"I",chl,9)) OrderPackQty=$p(^OEORD(ord,"I",chl,9),"^",4)
	.S:(+OrderPackQty'=0)&&(+OrderPackQty<1) OrderPackQty="0"_$number(OrderPackQty)
	.;协议单位
	.S PackUOMDesc="",Phcdf="",BillUOMRowid=""
	.s ProtocolPackUOMDR=$p($g(^OEORD(ord,"I",chl,"DHC")),"^",13)
	.S:ProtocolPackUOMDR'="" PackUOMDesc=$p($g(^CT("UOM",ProtocolPackUOMDR)),"^",2)
	.s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ArcItmId) ;判断某医嘱项的结构模式 Y-一对多，N-一对一 
	.S:CheckCHNFlag="Y" Phcdf=$P($g(^ARCIM(+ArcItmId,$P(ArcItmId,"||",2),1)),"^",12)
	.S:Phcdf'="" BillUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
	.S:BillUOMRowid'="" PackUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillUOMRowid)
	.S:OrderPackQty'="" OrderPackQty=OrderPackQty_PackUOMDesc
	.S:CheckCHNFlag="Y" spec=""
    .;I priorty["STAT"  S priorty=$p(^OECPR(priDr),"^",2) //即刻医嘱
    .;I priorty["PRN"  S priorty=$p(^OECPR(priDr),"^",2) //PRN
    .;I priorty["NORM"  S priorty=$p(^OECPR(priDr),"^",2) //临时医嘱
    .;I priorty["ONE"  S priorty=$p(^OECPR(priDr),"^",2) //取药医嘱
    .;I priorty["S"  S priorty=$p(^OECPR(priDr),"^",2) //长期医嘱
    .;I priorty["OM"  S priorty=$p(^OECPR(priDr),"^",2) //自备药即刻
    .;I priorty["OUT"  S priorty=$p(^OECPR(priDr),"^",2) // 出院带药
    .;I priorty["OMST"  S priorty=$p(^OECPR(priDr),"^",2) // 自备药长期
    .Q:((priorty["S")||(priorty["NORM")||(priorty["OUT")||(priorty["临时医嘱"))&&(status'="C")  //如果状态为C为已发药
    .;Q:status'="C"  

	.S Num=Num+1
	
	.S ArcimDesc=##Class(web.DHCADVCOMMON).GetTransDesc("User.ARCItmMast","ARCIMDesc","",ArcimDesc)  ;2020-06-28 cy 名称
	.S genenic=##Class(web.DHCADVCOMMON).GetTransDesc("User.PHCGeneric","PHCGEName","",genenic)  ;2020-06-28 cy 通用名
	.S instru=##Class(web.DHCADVCOMMON).GetTransDesc("User.PHCInstruc","PHCINDesc1","",instru)  ;2020-06-28 cy 用法
	.S form=##Class(web.DHCADVCOMMON).GetTransDesc("User.PHCForm","PHCFDesc","",form)  ;2020-06-28 cy 剂型	
	.S ^TMP("DHCADV","web.DHCADVDRUGCOMMON","GetPatOrdItmInfo",pid,Num)=orditm_"^"_phcdf_"^"_ArcimDesc_"^"_dosage_doseuom_"^"_dosuomID_"^"_freqdr_"^"_freq_"^"_instrudr_"^"_instru_"^"_durId_"^"_duration_"^"_genenicdr_"^"_genenic_"^"_formdr_"^"_form_"^"_manfdr_"^"_manf_"^"_apprdocu_"^"_spec_"^"_batno_"^"_staDate_"^"_endDate_"^"_priorty_"^"_vendor_"^"_OrderPackQty_"^"_PackUOMDesc

	Q:Num=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="orditm^phcdf^incidesc^dosage^dosuomID^freqdr^freq^instrudr^instru^durId^duration^genenicdr^genenic^formdr^form^manfdr^manf^apprdocu^spec^batno^staDate^endDate^priorty^vendor^OrderPackQty^PackUOMDesc"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVDRUGCOMMON","GetPatOrdItmInfo",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCADV","web.DHCADVDRUGCOMMON","GetPatOrdItmInfo",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:获取不良反应字典信息
/// W ##class(web.DHCADVDRUGCOMMON).GetAdvEvent("2","1","感冒")
ClassMethod GetAdvEvent(rows As %String, page As %String, advEvtAlise As %String)
{
	N (rows,page,advEvtAlise)
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S pid=##class(web.DHCADVCOMMON).NewPid()
	d ..killTmpGlobal(pid)
	S Num=0
    S advEvtID=0 
    F  S advEvtID=$o(^DHCADVDRUGEV(advEvtID)) q:advEvtID=""  d
    .S advEvtCode=$p(^DHCADVDRUGEV(advEvtID),"^",1)  //代码
    .S advEvtDesc=$p(^DHCADVDRUGEV(advEvtID),"^",2)  //描述
    .Q:advEvtDesc'[advEvtAlise
	.S Num=Num+1
	.S ^TMP("DHCADV","web.DHCADVDRUGCOMMON","GetAdvEvent",pid,Num)=advEvtID_"^"_advEvtDesc

	Q:Num=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="AdrEvtID^AdrEvtDesc"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVDRUGCOMMON","GetAdvEvent",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCADV","web.DHCADVDRUGCOMMON","GetAdvEvent",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
    K ^TMP("DHCADV","web.DHCADVDRUGCOMMON","getBatNoList",pid)
	k ^TMP("DHCADV","web.DHCADVDRUGCOMMON","GetPatOrdItmInfo",pid)
	k ^TMP("DHCADV","web.DHCADVDRUGCOMMON","GetAdvEvent",pid)
}

/// Descritp:医院
/// Creator:     yangyongtao
/// CreateDate:  2017-02-20
ClassMethod SelCTHospital() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT HOSP_RowId as HospDr,HOSP_Desc as HospDesc FROM CT_Hospital"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s HospDr = result.Data("HospDr")
		s HospDesc = result.Data("HospDesc")
		s tmp=HospDr_"^"_HospDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Description: 医嘱项检索
/// Creator:     CongYue
/// CreateDate:  2021-01-26
/// Input:  	 ItmMastDR : 医嘱项ID ,  inputOrderDesc:检索描述 （方法取于web.DHCDocMain  MatchAlias()）
/// Return: 	 1 医嘱项符合检索信息   0 医嘱项不不符合检索信息
/// Others:		 w ##class(web.DHCADVDRUGCOMMON).MatchAlias()
ClassMethod MatchAlias(ItmMastDR, inputOrderDesc)
{
	N (ItmMastDR, inputOrderDesc)
	Q:inputOrderDesc="" 1
	S flag=0
	S tmpOrderDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)
	Q:tmpOrderDesc[inputOrderDesc 1
	S inputOrderDescUp = $zcvt(inputOrderDesc,"U")
	S aliasRowid=""
	F  S aliasRowid=$o(^ARC("ALIAS",0,"ARCIM",ItmMastDR,aliasRowid)) Q:(aliasRowid="")||(flag=1)  D
	.S aliasText=$p(^ARC("ALIAS",aliasRowid),"^",6)
	.S:$zcvt(aliasText,"U")[inputOrderDescUp flag=1
	Q flag
}

}

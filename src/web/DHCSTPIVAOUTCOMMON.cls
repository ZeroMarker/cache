Import sqluser

/// 门诊输液配药申请
Class web.DHCSTPIVAOUTCOMMON Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 统一取最大进程号
ClassMethod GetPIVAOUTPID() As %String
{
   s pid=$I(^DHCSTPIVAOUT("DHCSTPIVAOUT"))
   q pid
}

/// 取默认开始日期
ClassMethod GetPIVAStDate() As %String
{
   q $zd(+$h,4)
}

/// 取默认截止日期
ClassMethod GetPIVAEndDate() As %String
{
   q $zd(+$h,4)
}

ClassMethod GetPatInfo(RegNo) As %String
{
	 s ret=""
	 s nulldata=""
	 q:RegNo="" nulldata
	 q:'$d(^PAPERi("PAPMI_PatNo",RegNo)) nulldata
	 s papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	 q:papmi="" nulldata
	 s typestr="O^E"
	 s cnt=$l(typestr,"^")
	 s exit=0
	 s admvalue=""
	 f i=1:1:cnt d
	 .s admtype=$p(typestr,"^",i)
	 .s adm="" 
	 .f  s adm=$o(^PAPERdr(papmi,"ADM",admtype,adm),-1) q:(adm="")||(exit=1)  d
	 ..s exit=1
	 ..s admvalue=adm
	 i admvalue'="" d
	 .s ret=..GetAdmBasicInfo(admvalue)
	 q ret
}

/// 获取病人基本信息
ClassMethod GetAdmBasicInfo(adm) As %String
{
   q:adm="" ""
   s papmi=+$p(^PAADM(adm),"^",1)
   s perno=$p(^PAPER(papmi,"PAT",1),"^",2)
   s pname=$p(^PAPER(papmi,"ALL"),"^",1)
   s ptel=$p(^PAPER(papmi,"PER",1),"^",11)
   s paddress=$p($g(^PAPER(papmi,"PER",4)),"^",18)
   s getage=..GetAge(papmi) 
   s sexdr=$p(^PAPER(papmi,"ALL"),"^",7)
   s sex=$p(^CT("SEX",sexdr),"^",2)
   s company=$p(^PAPER(papmi,"PER",4),"^",18) //工作单位
   s cardNo=""
   s cfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,""),-1)
   i cfRowId'="" d
   .s cardNo=$p($g(^DHCCARD("CF",cfRowId)),"^",2)
   s admdate=""
   s admdate=$p(^PAADM(adm),"^",6)
   i admdate'="" s admdate=$zd(admdate,3)
   s diagnodesc=..GetMRDiagnosDesc(adm,",")
   s patW=..GetPatWeight(adm)
   s patH=..GetPatHeight(adm)
   s ward=""
   s admwarddr=$p(^PAADM(adm),"^",70)
   i admwarddr'="" d
   .s ward=$p(^PAWARD(admwarddr),"^",2)
   .i $f(ward,"-") s ward=$p(ward,"-",2)
   s billtype=""
   s typedr=+$p(^PAPER(papmi,"PER",1),"^",10)
   s:typedr'="" billtype=$p(^CT("SS",typedr),"^",2)

   ;
   s patstring=perno_"^"_pname_"^"_getage_"^"_sex_"^"_diagnodesc_"^"_patW_"^"_company_"^"_cardNo_"^"_admdate_"^"_ptel_"^"_paddress
   s patstring=patstring_"^"_billtype_"^"_patH_"^"_ward
   q patstring
}

/// 取医嘱诊断
ClassMethod GetMRDiagnosDesc(MRAdmRowid As %String, DelimStr As %String) As %String
{
	 q:MRAdmRowid="" ""
	 s MRAdmRowid=$p(^PAADM(MRAdmRowid),"^",61)
	 q:MRAdmRowid="" ""
	 s retval=""
	 s i=0
	 Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	 d obj.Execute(MRAdmRowid)
	 For  Quit:'obj.Next()  Do
	 .s Desc=obj.Data("MRDIAICDCodeDRDesc")
	 .s Rowid=obj.Data("ID")
	 .s CodeRowid=obj.Data("MRDIAICDCodeDR")
	 .s MRDesc=obj.Data("MRDIADesc")
	 .if MRDesc'="" s MRDesc=$LIST(MRDesc,1)
	 .i Desc="" s Desc=MRDesc
	 .e  d
	 ..i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
	 .s i=i+1
	 .s Desc=i_"."_Desc
	 .if retval="" s retval=Desc
	 .e  s retval=retval_DelimStr_Desc
	 d obj.Close()
	 q $ZCVT($g(retval),"O","JS")
}

/// Description:取患者体重
ClassMethod GetPatWeight(paadm) As %String
{
	Q:paadm="" ""
	Q:'$D(^PAADM(paadm)) ""
	S mradm=$P(^PAADM(paadm),"^",61)
	Q:mradm="" ""
	Q:'$D(^MR(mradm,"PRO",1)) ""
	S weight=$P(^MR(mradm,"PRO",1),"^",27)
	S:weight'="" weight=weight_"KG"
	Q weight
}

/// Description:取患者身高
ClassMethod GetPatHeight(paadm) As %String
{
	Q:paadm="" ""
	Q:'$D(^PAADM(paadm)) ""
	S mradm=$P(^PAADM(paadm),"^",61)
	Q:mradm="" ""
	Q:'$D(^MR(mradm,"PRO",1)) ""
	S Height=$P(^MR(mradm,"PRO",1),"^",20)
	S:Height'="" Height=Height_"CM"
	Q Height
}

/// Description:根据患者rowid取出年龄
ClassMethod GetAge(papmidr As %String) As %String
{
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
	 .i ageYears>3 s age=ageYears_"岁"
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

/// 获取安全组关联科室
ClassMethod GetStockPhlocDs(grpdr) As %String
{
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s h=0
	s sub=""
	f  s sub=$o(^SSU("SSGRP",grpdr,"ST",sub)) q:sub=""  d
	.s ctlocdr=$p(^SSU("SSGRP",grpdr,"ST",sub),"^",1)
	.s ctlocdesc=$p(^CTLOC(ctlocdr),"^",2)
	.s ctloctype=$p(^CTLOC(ctlocdr),"^",13)
	.q:ctloctype'="D"
	.s h=h+1
    .s data=ctlocdesc_"^"_ctlocdr
    .s ^TMP("dhcpha","DHCSTPIVAOUTCOMMON","GetStockPhlocDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTPIVAOUTCOMMON","GetStockPhlocDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTPIVAOUTCOMMON","GetStockPhlocDs",pid,h)
    .s phlocdesc=$p(data,"^",1)
    .s rowId=$p(data,"^",2)
    .
    .s phlocdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("phlocdesc",phlocdesc)
	.s rowId=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("rowId",rowId)
	.
	.s tmpstr=phlocdesc_rowId
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTPIVAOUTCOMMON","GetStockPhlocDs",pid)
	q ""
}

/// 获取急诊留观室
ClassMethod GetGetLgAreaDs() As %String
{
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s h=0
	s ret=""
	s ctloctype="EM"
	s ctlocdr=""
	f  s ctlocdr=$o(^CTLOC(0,"LocType",ctloctype,ctlocdr)) q:ctlocdr=""  d
	.s datefrom=$p(^CTLOC(ctlocdr),"^",24)
	.q:datefrom=""
	.q:(datefrom'="")&(datefrom>+$h)
	.s dateto=$p(^CTLOC(ctlocdr),"^",25)
	.q:(dateto'="")&(dateto'>+$h)
	.s warddr=$o(^PAWARD(0,"WARD_LocationDR",ctlocdr,""))
	.q:warddr=""
	.s flag=0
	.s roomsub=0 
	.f  s roomsub=$o(^PAWARD(warddr,"ROOM",roomsub)) q:(roomsub=0)||(roomsub="")  d
	..s roomdr=$p(^PAWARD(warddr,"ROOM",roomsub),"^",1)
	..q:roomdr=""
	..s flag=1
	.q:flag=0
	.s ctlocdesc=$p(^CTLOC(ctlocdr),"^",2)
	.i $F(ctlocdesc,"-") s ctlocdesc=$p(ctlocdesc,"-",2)
	.s h=h+1
    .s data=ctlocdesc_"^"_ctlocdr
    .s ^TMP("dhcpha","DHCSTPIVAOUTCOMMON","GetGetLgAreaDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTPIVAOUTCOMMON","GetGetLgAreaDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTPIVAOUTCOMMON","GetGetLgAreaDs",pid,h)
    .s locdesc=$p(data,"^",1)
    .s rowId=$p(data,"^",2)
    .
    .s locdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locdesc",locdesc)
	.s rowId=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("rowId",rowId)
	.
	.s tmpstr=locdesc_rowId
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTPIVAOUTCOMMON","GetGetLgAreaDs",pid)
	q ""
}

/// 获取病人登记号长度
ClassMethod GetPatRegNoLen()
{
	 s PatLen=$p(^CF("PATCF",1,3),"^",5)
	 q PatLen
}

/// 获取申请单是否已完成
/// 0 未完  1完成
ClassMethod GetReqCompStatus(dsprowid)
{
	s ret=0
	s pdis=""
	f  s pdis=$o(^PIVADIS(0,"DODIS",dsprowid,pdis)) q:pdis=""  d
	.s ret=1
	q ret
}

/// 获取护士配药申请信息
/// return:申请人^申请日期^申请时间
ClassMethod GetReqUserInfo(dsprowid)
{
	s pdis=""
	f  s pdis=$o(^PIVADIS(0,"DODIS",dsprowid,pdis)) q:pdis=""  d
	.s requser=$p(^PIVADIS(pdis),"^",6)
	.i requser'="" s requser=$p(^SSU("SSUSR",requser),"^",2)
	.s reqdate=$p(^PIVADIS(pdis),"^",4)
	.i reqdate'="" s reqdate=$zd(reqdate,3)
	.s reqtime=$p(^PIVADIS(pdis),"^",5)
	.i reqtime'="" s reqtime=$zt(reqtime,1)
	q $g(requser)_"^"_$g(reqdate)_"^"_$g(reqtime)
}

/// 获取自备药接收信息
/// return:接收人^接收日期^接收时间
ClassMethod GetReqRecInfo(dsprowid)
{
	s pdis=""
	f  s pdis=$o(^PIVADIS(0,"DODIS",dsprowid,pdis)) q:pdis=""  d
	.s requser=$p(^PIVADIS(pdis),"^",8)
	.i requser'="" s requser=$p(^SSU("SSUSR",requser),"^",2)
	.s reqdate=$p(^PIVADIS(pdis),"^",9)
	.i reqdate'="" s reqdate=$zd(reqdate,3)
	.s reqtime=$p(^PIVADIS(pdis),"^",10)
	.i reqtime'="" s reqtime=$zt(reqtime,1)
	q $g(requser)_"^"_$g(reqdate)_"^"_$g(reqtime)
}

/// 获取配伍审核信息
/// return:审核人^审核日期^审核时间^审核结果
ClassMethod GetAdtResultInfo(oeori)
{
	s ord=$p(oeori,"||",1)
	s itm=$p(oeori,"||",2)
    s data=$p(^OEORD(ord,"I",itm,7),"^",3)
    s adtuser=$p(data,",",1)
    i adtuser'="" s adtuser=$p(^SSU("SSUSR",adtuser),"^",2)
    s adtdate=$p(data,",",2)
    i adtdate'="" s adtdate=$zd(adtdate,3)
    s adttime=$p(data,",",3)
    i adttime'="" s adttime=$zt(adttime,1)
    s result=$p(data,",",4)
    i result="SHTG" s result="审核通过"
    i result="SHJJ" s result="审核拒绝"
    s prescno=$p(^OEORD(+ord,"I",itm,1),"^",14)
    i result="" d
    .i $d(^DHCPHORDM(0,"PrescNo",prescno)) d
    ..s result="有日志"
	q $g(adtuser)_"^"_$g(adtdate)_"^"_$g(adttime)_"^"_$g(result)
}

/// 取主医嘱Rowid
ClassMethod GetMainOeori(oeori As %String) As %String
{

	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	Q:'$D(^OEORD(ord,"I",chl,11)) ""
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:loeori'="" loeori
 	Q oeori
}

/// 取dodis的配液子表ID
ClassMethod GetOGrpI(dodis As %String) As %String
{

	S ogrp=$O(^PIVA(0,"DSP",dodis,""))
	Q:ogrp="" ""
	S sub=$O(^PIVA(0,"DSP",dodis,ogrp,""))
	Q ogrp_"||"_sub
}

/// 取状态Number
ClassMethod GetPSNumber(pog As %String) As %String
{

 	S ps=$P(^PIVA(pog),"^",6) /// 状态
 	Q:ps="" ""
 	Q:'$D(^PIVAS(ps)) ""
 	S psnumber=$P(^PIVAS(ps),"^",1)
 	Q psnumber
}

/// 医嘱优先级
ClassMethod GetOePriority(oeori As %String) As %String
{

	Q:oeori="" ""
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S pri=$P(^OEORD(ord,"I",itm,1),"^",8)
	Q:pri="" ""
	Q:'$D(^OECPR(pri)) ""
	S prcode=$P(^OECPR(pri),"^",1)
	S prdesc=$P(^OECPR(pri),"^",2)
	Q pri_"^"_prcode_"^"_prdesc
}

ClassMethod GetIncItm(oeori As %String) As %String
{

	Q:oeori="" ""
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S arcimid=$P(^OEORD(ord,"I",itm,1),"^",2)
 	Q:arcimid="" ""
 	S arcimm=$p(arcimid,"||",1)
 	Q:arcimm="" ""
 	S inci=$O(^INCI(0,"ARCIM_DR",arcimm,""))
 	Q:inci="" ""
 	Q:'$D(^INCI(inci,1)) ""
 	S itmcode=$P(^INCI(inci,1),"^",1)
 	S itmdesc=$P(^INCI(inci,1),"^",2)
 	S phccat=##Class(web.DHCSTCOMINC).GetPhcCatDesc(inci) //phccatID_"^"_phccatDesc
 	S phcsubcat=##Class(web.DHCSTCOMINC).GetPhcSCDesc(inci) //phcsubcatID_"^"_phcsubcatDesc
 	Q inci_"^"_itmcode_"^"_itmdesc_"^"_phccat_"^"_phcsubcat
}

/// Description:获取配液药品货位
/// Creator:Liang Qiang
/// CreatDate:2010-04-07
/// Input:科室ID,库存项ID
/// Output:药品货位
ClassMethod GetStkBin(ctlocdr, inci) As %String
{

	 q:ctlocdr="" ""
	 s ch=$o(^INCI("IL_LOC",ctlocdr,inci,""))
	 q:inci="" ""
	 q:ch="" ""
	 q:'$d(^INCI(inci,"IL",ch)) ""
	 s stkbin=+$p(^INCI(inci,"IL",ch),"^",2)
	 q:'$d(^INC("SB",stkbin)) ""
	 s stkbindesc=$p(^INC("SB",stkbin),"^",2)
	 q stkbindesc
}

/// 获取病人的基本信息,包括诊断信息
/// Creator:Liang Qiang
/// CreatDate:2010-04-07
/// Input:dhc_oedispensing ID
/// Return:病人的诊断信息 || 基本信息
ClassMethod GetPatInfoData(dodis) As %String
{
	s oeori=$p(^DHCOEDISQTY(dodis),"^",1)
	s adm=$p(^OEORD(+oeori),"^",1)
	s diag=##Class(web.DHCSTPIVAOUTCOMMON).GetMRDiagnosDesc(adm,"!")
	s infodata=##Class(web.DHCSTPIVAOUTCOMMON).GetAdmBasicInfo(adm)
	S Papmi=$p(^PAADM(adm),"^",1)
    S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",2) //登记号
    s pmi=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
    s age=##class(web.DHCSTKUTIL).GetAge(pmi,adm) //年龄统一调用接口wyx 2015-01-29
	s $p(infodata,"^",3)=age
	s infodata=diag_"||"_infodata
	q infodata
}

/// 获取病人的基本信息,包括诊断信息
/// Creator:Liang Qiang
/// CreatDate:2010-04-07
/// Input:oe_orditm RowID
/// Return:病人的诊断信息 || 基本信息
ClassMethod GetPatInfoDataByOrd(oeori) As %String
{
	s adm=$p(^OEORD(+oeori),"^",1)
	s diag=##Class(web.DHCSTPIVAOUTCOMMON).GetMRDiagnosDesc(adm,"!")
	s infodata=##Class(web.DHCSTPIVAOUTCOMMON).GetAdmBasicInfo(adm)
	s infodata=diag_"||"_infodata
	q infodata
}

/// 
/// Creator:Zhouyg
/// CreatDate:2010-12-22
/// 转换为基本数量
/// Input:医嘱rowid
/// Output:基本单位数量^基本单位
ClassMethod GetDosageBUom(oeori As %String) As %String
{

	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	Q:'$D(^OEORD(ord,"I",itm,2)) ""
	S dosqty=$P(^OEORD(ord,"I",itm,2),"^",1) //剂量
	S DosUnit=$p(^OEORD(ord,"I",itm,2),"^",3)
	S arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
	S arcimm=$P(arcim,"||",1)
	Q:arcimm="" ""
	S arcims=$P(arcim,"||",2)
	Q:arcims="" ""
	Q:'$D(^ARCIM(arcimm,arcims,1)) ""
	S phcdf=$P(^ARCIM(arcimm,arcims,1),"^",12)
	S phc=$P(phcdf,"||",1)
	Q:phc="" ""
	S formsub=$P(phcdf,"||",2)
	Q:formsub="" ""
	S BuomID=$P(^PHCD(phc,"DF",formsub,2),"^",4)
	Q:BuomID="" ""
	S BQty=+$P(^PHCD(phc,"DF",formsub,2),"^",5)
	Q:BQty=0 ""
	S BuomDesc=$P($G(^CT("UOM",BuomID)),"^",2)
	Q:DosUnit=BuomID dosqty_"^"_BuomDesc
	s eqsub="0",eqqty=0
	f  s eqsub=$O(^PHCD(phc,"DF",formsub,"EQ",eqsub)) q:eqsub=""  d
	.S equomdr=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1)
	.Q:equomdr'=DosUnit
	.s eqqty=+$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",2) //等效数量
	Q:eqqty=0 ""
	S RetQty=dosqty/(eqqty/BQty)
	I RetQty["." D
	.S RetQty=$FN(RetQty,"",1)
	Q RetQty_"^"_BuomDesc
}

/// 剂量是否整包装 1-是，0-否
ClassMethod GetCompFlag(oeori As %String) As %String
{

	S ord=$p(oeori,"||",1) Q:ord="" 0
	S itm=$p(oeori,"||",2) Q:itm="" 0
	Q:'$D(^OEORD(ord,"I",itm,1)) 0
	S DosUnit=$p(^OEORD(ord,"I",itm,2),"^",3)
	S arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
	S arcimm=$P(arcim,"||",1)
	Q:arcimm="" 0
	S arcims=$P(arcim,"||",2)
	Q:arcims="" 0
	S incidr=$O(^INCI(0,"ARCIM_DR",arcimm,""))
	Q:incidr="" 0
	Q:'$D(^INCI(incidr,1)) 0
	Q:'$D(^INCI(incidr,3)) 0
	S buom=$P(^INCI(incidr,1),"^",10)
	S puom=$P(^INCI(incidr,3),"^",6)
	Q:DosUnit=buom 1
	Q:DosUnit=puom 1
	Q:'$D(^ARCIM(arcimm,arcims,1)) ""
	S phcdf=$P(^ARCIM(arcimm,arcims,1),"^",12)
	S phc=$P(phcdf,"||",1)
	Q:phc="" 0
	S formsub=$P(phcdf,"||",2)
	Q:formsub="" 0
	S dosqty=$P(^OEORD(ord,"I",itm,2),"^",1)
	S bqty=$P(^PHCD(phc,"DF",formsub,2),"^",5)
	Q:bqty=0 0
	s eqsub="0",eqqty=0
	f  s eqsub=$O(^PHCD(phc,"DF",formsub,"EQ",eqsub)) q:eqsub=""  d
	.S equomdr=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1)
	.Q:equomdr'=DosUnit
	.s eqqty=+$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",2) //等效数量
	Q:eqqty=0 0
	S comp=dosqty/(eqqty/bqty)
	S comp=+comp
	Q:comp["." 0
	Q 1
}

/// 打印标志
ClassMethod GetPrintSign(oeori As %String) As %String
{

	Q:oeori="" ""
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
	S arcimm=$P(arcim,"||",1)
	Q:arcimm="" ""
	S arcims=$P(arcim,"||",2)
	Q:arcims="" ""
	Q:'$D(^ARCIM(arcimm,arcims,1)) ""
	S phcdf=$P(^ARCIM(arcimm,arcims,1),"^",12)
	S phc=$P(phcdf,"||",1)
	Q:phc="" ""
	Q:'$D(^PHCD(phc,1)) ""
	S phcsc=$p(^PHCD(phc,1),"^",3)
	Q:phcsc="" ""
	i $d(^PIVAPS(0,"PHCSC",phcsc)) d
	.S pps=$O(^PIVAPS(0,"PHCSC",phcsc,""))
	i $d(^PIVAPS(0,"PHCDF",phcdf)) d
	.S pps=$O(^PIVAPS(0,"PHCDF",phcdf,""))
	q:$g(pps)="" "" 
	S sign=$P(^PIVAPS(pps),"^",2)
	Q sign
}

/// Creator:Liang Qiang
/// CreatDate:2010-02-07
/// 剂量的单位如果不是"ml",则转换成"ml"  
/// Input:医嘱rowid
/// Output:剂量ml
ClassMethod GetDosageML(oeori As %String) As %String
{
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S dosqty=$P(^OEORD(ord,"I",itm,2),"^",1) //剂量
	S DosUnit=$p(^OEORD(ord,"I",itm,2),"^",3)
	S DosUom=""
	I $D(^CT("UOM",DosUnit)) S DosUom=$P(^CT("UOM",DosUnit),"^",2)
	Q:DosUom="" ""
	Q:DosUom="ml" ""
	;Q dosqty_"^"_DosUom
	S arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
	S arcimm=$P(arcim,"||",1)
	Q:arcimm="" ""
	S arcims=$P(arcim,"||",2)
	Q:arcims="" ""
	S incidr=$O(^INCI(0,"ARCIM_DR",arcimm,""))
	Q:incidr="" ""
	Q:'$D(^INCI(incidr,1)) ""
	Q:'$D(^INCI(incidr,3)) ""
	S buom=$P(^INCI(incidr,1),"^",10)
	S puom=$P(^INCI(incidr,3),"^",6)
	;Q:DosUnit=buom 1
	;Q:DosUnit=puom 1
	Q:'$D(^ARCIM(arcimm,arcims,1)) ""
	S phcdf=$P(^ARCIM(arcimm,arcims,1),"^",12)
	S phc=$P(phcdf,"||",1)
	Q:phc="" 0
	S formsub=$P(phcdf,"||",2)
	Q:formsub="" ""
	s eqsub="0"
	f  s eqsub=$O(^PHCD(phc,"DF",formsub,"EQ",eqsub)) q:eqsub=""  d
	.S equomdr=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1)
	.s equom=$P(^CT("UOM",equomdr),"^",2)
	.s eqqty=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",2) //等效数量
	.i equom="ml"  d
	..s mlqty=eqqty
	.i equom=DosUom d
	..s otherqty=eqqty
	;Q:$g(otherqty)="" ""
	Q:$g(mlqty)="" ""
    ;s qty=(dosqty/otherqty)*mlqty
	;
	i $g(otherqty)="" s qty=dosqty*mlqty
	i $g(otherqty)'="" s qty=(dosqty/otherqty)*mlqty
	Q qty_"ml"
}

/// 取医嘱的剂量
ClassMethod GetDosage(oeori As %String) As %String
{

	Q:oeori="" ""
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S dosqty=$P(^OEORD(ord,"I",itm,2),"^",1)
	S dosuom=$P(^OEORD(ord,"I",itm,2),"^",3)
	I dosuom'="" D
	.I $D(^CT("UOM",dosuom)) S dosuom=$P(^CT("UOM",dosuom),"^",2)
	Q dosqty_dosuom
}

/// 取药品规格
ClassMethod GetSpec(inci As %String) As %String
{

	S info=$O(^DHCITMINFO(0,"INCI",inci,""))
	Q:info="" ""
	Q:'$D(^DHCITMINFO(info)) ""
	S spec=$P(^DHCITMINFO(info),"^",27)
	Q spec
}

/// 医生
ClassMethod GetDoctor(oeori As %String) As %String
{
	Q:oeori="" ""
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S doctor=$P(^OEORD(ord,"I",itm,1),"^",11)
	Q:doctor="" ""
	Q:'$D(^CTPCP(doctor,1)) ""
	S doctor=$P(^CTPCP(doctor,1),"^",2)
	Q doctor
}

/// 取医嘱的频率
ClassMethod GetFreq(oeori As %String) As %String
{
	Q:oeori="" ""	
 	S freqcode=""
 	S ord=$P(oeori,"||",1) Q:ord="" freqcode
 	S chl=$P(oeori,"||",2) Q:chl="" freqcode
 	Q:'$D(^OEORD(ord,"I",chl,2)) freqcode
 	S freq=$P(^OEORD(ord,"I",chl,2),"^",4)
 	Q:freq="" ""
 	Q:'$D(^PHCFR(freq)) ""
 	S freqcode=$P(^PHCFR(freq),"^",1)
 	S freqdesc1=$P(^PHCFR(freq),"^",2)
 	S freqdesc2=$P(^PHCFR(freq),"^",3)
 	S freqdesc3=$P(^PHCFR(freq),"^",4)
 	Q freq_"^"_freqcode_"^"_freqdesc1_"^"_freqdesc2_"^"_freqdesc3
}

/// Creator:LiangQiang
/// CreatDate:2010-10-27
/// Description:判断医嘱是否有配液标记,
/// Input:医嘱rowid
/// Output: // 1:是 配液  0:否
ClassMethod IfPIVA(oeori As %String) As %String
{
	s ord=$p(oeori,"||",1)
	s chl=$p(oeori,"||",2)
	Q:'$d(^OEORD(ord,"I",chl,"DHC")) 0
 	s pivaflag=$p(^OEORD(ord,"I",chl,"DHC"),"^",16)
    i pivaflag="Y" s pivaflag=1
    i pivaflag="N" s pivaflag=0
    q pivaflag
}

/// 查询日期范围内的瓶签单号
ClassMethod FindLabelNoDs(Input, StPage, Limit) As %String
{
	s endpage=StPage+Limit  //结束行
	s stpage=StPage+1 //开始行
	s stdatestr=$p(Input,"^",1)
	s stdate=$p(stdatestr," ",1)
	s stdate=$zdh(stdate,4)
	s sttime=$p(stdatestr," ",2)
	s sttime=$zth(sttime,1)
	s eddatestr=$p(Input,"^",2)
	s enddate=$p(eddatestr," ",1)
	s enddate=$zdh(enddate,4)
	s endtime=$p(eddatestr," ",2)
	s endtime=$zth(endtime,1)
    s phalocdr=$p(Input,"^",3)
    s cnumber=$p(Input,"^",4)  ///流程标识号
    s checkflag=$p(Input,"^",5) ///查询状态标示

    s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
    s inpogspsdr=""
    s inpogspsstr=..GetPrevStatus(cnumber,phalocdr,"O")  ///获取上一状态
    s inpogspsdr=$p(inpogspsstr,"^",1)

    f date=stdate:1:enddate  d
    .s pogspsdr=""
    .f  s pogspsdr=$o(^PIVA(0,"LOCSTATE",phalocdr,date,pogspsdr)) q:pogspsdr=""  d
    ..q:(checkflag="")&(inpogspsdr'="")&(inpogspsdr'=pogspsdr)
    ..S psnumber=$P(^PIVAS(pogspsdr),"^",1)
    ..q:(checkflag'="")&(cnumber'="")&(cnumber>psnumber)
    ..q:$p(^PIVAS(pogspsdr),"^",9)'="O"   //bianshuai 2015-12-07 增加类型判断
	..s pogid=""
	..f  s pogid=$o(^PIVA(0,"LOCSTATE",phalocdr,date,pogspsdr,pogid)) q:pogid=""  d
 	...s pogno=$p(^PIVA(pogid),"^",16)
 	...s poguserdr=$p(^PIVA(pogid,"S",1),"^",3)  //第一条记录就是打签的记录,标签打印日期应取此处,yunhabao20151230
 	...s poguser=$p(^SSU("SSUSR",poguserdr),"^",2)
 	...s pogdate=$p(^PIVA(pogid),"^",4)
 	...s pogtime=$p(^PIVA(pogid),"^",5)
 	...s pogsdate=$p(^PIVA(pogid,"S",1),"^",4)  
 	...s pogstime=$p(^PIVA(pogid,"S",1),"^",5) //显示为打印时间
 	...q:(pogtime<sttime)&(date=stdate) //按照用药时间过滤
 	...q:(pogtime>endtime)&(date=enddate)
 	...s pogsdate=$zd(pogsdate,3)
 	...s pogstime=$zt(pogstime,1)
 	...Q:pogno=""
 	...s pogsdate=pogsdate_" "_pogstime
 	...s index=pogno_","_poguser
 	...s ^TMP("dhcpha","DHCSTPIVAOUTCOMMON","FindLabelNoDs",pid,"Index",index)=pogsdate
 	
 	s h=0
 	s index=""
 	f  s index=$o(^TMP("dhcpha","DHCSTPIVAOUTCOMMON","FindLabelNoDs",pid,"Index",index)) q:index=""  d
 	.s pogno=$p(index,",",1)
 	.s poguser=$p(index,",",2)
 	.s pogdate=^TMP("dhcpha","DHCSTPIVAOUTCOMMON","FindLabelNoDs",pid,"Index",index)
 	.s h=h+1
    .s data=pogno_"^"_poguser_"^"_pogdate
    .s ^TMP("dhcpha","DHCSTPIVAOUTCOMMON","FindLabelNoDs",pid,"Itm",h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTPIVAOUTCOMMON","FindLabelNoDs",pid,"Itm",h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTPIVAOUTCOMMON","FindLabelNoDs",pid,"Itm",h)
    .s pogno=$p(data,"^",1)
    .s poguser=$p(data,"^",2)
    .s pogdate=$p(data,"^",3)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s pogno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pogno",pogno)
    .s poguser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("poguser",poguser)
	.s pogdate=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("pogdate",pogdate)
	.
	.s tmpstr=pogno_poguser_pogdate
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("dhcpha","DHCSTPIVAOUTCOMMON","FindLabelNoDs",pid)
	q ""
}

//检查配液瓶签打印单号

//1-符合 0不符

ClassMethod ChkPrtNo(PrtNoStr, PrtNo) As %String
{
	q:PrtNoStr="" 1
	s chkflag=0
	s cnt=$l(PrtNoStr,",")
	f i=1:1:cnt d
	.s tmpno=$p(PrtNoStr,",",i)
	.i tmpno=PrtNo d
	..s chkflag=1
	q chkflag
}

//初始化配液状态字典表数据

ClassMethod InitPIVAStateNumber() As %String
{
	s psnum=""
	f  s psnum=$o(^PIVAS(0,"NUMBER",psnum)) q:psnum=""  d
	.s ps=""
	.f  s ps=$o(^PIVAS(0,"NUMBER",psnum,ps)) q:ps=""  d
	..s name=$p(^PIVAS(ps),"^",2)
	..s active="Y"
	..&sql(insert into PIVA_StateNumber (PSN_Number,PSN_Name,PSN_ActiveFlag) values (:psnum,:name,:active) )
	..
	q ""
}

/// 取下一个状态
ClassMethod GetNextStat(psdr, phlocdr, Type) As %String
{
	Q:psdr="" ""
	Q:phlocdr="" ""
	Q:'$D(^PIVAS(psdr)) ""
	S psnumber=$P(^PIVAS(psdr),"^",1)
	s nextps="",newnextnumber=""
	s nextnumber=psnumber
	f  S nextnumber=$O(^PIVAS(0,"FN","Y","N",nextnumber)) q:(nextnumber="")||(nextps'="")  d
	.s psdr=""
	.f  s psdr=$o(^PIVAS(0,"FN","Y","N",nextnumber,psdr)) q:(psdr="")||(nextps'="")  d
	..s locdr=$P(^PIVAS(psdr),"^",7)
	..s locType=$P(^PIVAS(psdr),"^",9)   //Bianshuai 2013815 增加类型判断
	..q:locdr'=phlocdr
	..q:locType'=Type
	..s nextps=psdr
	..s newnextnumber=nextnumber
	Q nextps_"^"_newnextnumber
}

/// 取当前数字的ID
ClassMethod GetCurrPSDrByNum(number, phlocdr, Type) As %String
{
	s ret=""
	S currpsdr=""
	F  S currpsdr=$O(^PIVAS(0,"NUMBER",number,currpsdr)) q:currpsdr=""  d
	.s locdr=$p(^PIVAS(currpsdr),"^",7)
	.q:locdr'=phlocdr
	.s loctype=$p(^PIVAS(currpsdr),"^",9)
	.q:loctype'=Type
	.s ret=currpsdr
	q ret
}

/// Description:构造树形结构
/// Creator:LiangQiang
ClassMethod GetReaTreeData(level, id, waycode) As %String
{
	
	s currlevel=level+1
	w "["
	s reasondr=""
	f  s reasondr=$o(^DHCPCREASON(0,"Level",waycode,id,reasondr)) q:reasondr=""  d
	.s catdesc=$p(^DHCPCREASON(reasondr),"^",2)
	.s leafflag="false"
	.i '$D(^DHCPCREASON(0,"Level",waycode,reasondr))  s leafflag="true"
	.w "{"_"id:'"_reasondr_"',text:'"_catdesc_"',leaf:"_leafflag_",level:'"_currlevel_"'}"
	.s next=$o(^DHCPCREASON(0,"Level",waycode,id,reasondr))
	.i (+next'=0) w ","

	q "]"
}

/// Descript:获取配液打包状态
/// Creator:BianShuai
ClassMethod GetPackFlag(dsprowid) As %String
{
	//n (dsprowid)
	S pdis=$o(^PIVADIS(0,"DODIS",dsprowid,""))
	q:pdis="" ""
	S pakcflag=$p(^PIVADIS(pdis),"^",3)
	q pakcflag
}

/// Descript:获取自备药标志
/// Creator:BianShuai
ClassMethod GetOMFlag(dsprowid) As %String
{
	//n (dsprowid)
	S pdis=$o(^PIVADIS(0,"DODIS",dsprowid,""))
	q:pdis="" ""
	S omedflag=$p(^PIVADIS(pdis),"^",7)
	q omedflag
}

/// Creator:Bian Shuai
/// Descript:返回当前液体状态
ClassMethod GetCurStat(dodis)
{
	S paname=""
	S pig=$O(^PIVA(0,"DSP",dodis,""))
	If pig'="" d
	.S psdr=$p(^PIVA(pig),"^",6)
	.Q:psdr=""
	.S paname=$p(^PIVAS(psdr),"^",2)
	
	If paname="" d
	.S pivareq=$o(^PIVADIS(0,"DODIS",dodis,""))
	.If pivareq=""  d
	..S paname="待申请"
	.Else  S paname="已申请"
	
	Q paname
}

/// 判断处方是否需要配液
/// Out:1 无需配液  0 需要配液
ClassMethod CheckPrescIfPIVA(PrescNo)
{

    S Ord=$o(^OEORD(0,"PrescNo",PrescNo,""))
    Q:Ord="" "0"
    S Itm=$o(^OEORD(0,"PrescNo",PrescNo,Ord,""))
    Q:Itm="" "0"
    S CheckFlag=##Class(web.DHCSTPIVA).IfQuitPIVA(Ord_"||"_Itm) //检查是否配液
    Q CheckFlag
}

/// Description:获取医嘱状态,判断是否可以配药,药房,配液通用,适用于新版医嘱规则
/// Input:医嘱执行表ID
/// Output:0 不可配  1 可配
/// CreatDate:2012-02-23
/// Creator:LiangQiang
ClassMethod GetOrdState(OrdExeRowid) As %String
{
	//n (OrdExeRowid)
	s Ord=$p(OrdExeRowid,"||",1)
	s Chl=$p(OrdExeRowid,"||",2)
	s Sub=$p(OrdExeRowid,"||",3)
	s ret=0
	q:Ord="" ret
    q:Chl="" ret
    q:'$d(^OEORD(Ord)) ret
    //q:'$d(^OEORD(Ord,"I",Chl,"X",Sub,"BILL")) ret
	//s OrderStatusDr=$p(^OEORD(Ord,"I",Chl,"X",Sub,"BILL"),"^",1)  ;医嘱状态
	//q:OrderStatusDr="" ret
    //s OeFlag=$p(^OEC("OSTAT",OrderStatusDr),"^",1)          ;医嘱核实、未核实、停止状态 
    //i (OeFlag'="V")&(OeFlag'="E")  Q ret				;执行记录的医嘱状态为停止的不发药
    s OreStatusDr=$p(^OEORD(Ord,"I",Chl,"X",Sub),"^",16)  ;护士执行状态
    q:OreStatusDr="" 1      ;zdm,2012-03-02,护士执行状态为空认为可配药？
    s AdminStatus=$p(^OEC("STAT",OreStatusDr),"^",1)  
    //i (AdminStatus="D")!(AdminStatus="C") Q ret
    i AdminStatus="D" Q ret
    Q 1
}

/// Description:获取取门诊配液有效的医嘱数量(基本单位)
/// Creator:LiangQiang
/// CreatDate:2013-07-12
/// Input:医嘱ord_item ID
/// Return:当前有效数量(总数-未发已停止执行数-已发已退药数)
ClassMethod GetPIVAOutValidQty(orditm) As %String
{
	s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	q:dsp="" 0
	//s ordqty=$p(^DHCOEDISQTY(dsp),"^",2)
	s ordqty=0
	s stopqty=0
	s dsp=""
	f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,dsp)) q:dsp=""  d
	.s ordexec=$p(^DHCOEDISQTY(dsp),"^",3)
	.s status=$p(^DHCOEDISQTY(dsp),"^",7)
	.s ordqty=ordqty+$p(^DHCOEDISQTY(dsp),"^",2)
	.q:status'="TC"  //只考虑未发药
	.s orestatusdr=$p(^OEORD($p(ordexec,"||",1),"I",$p(ordexec,"||",2),"X",$p(ordexec,"||",3)),"^",16) ;护士执行状态
    .q:orestatusdr=""
    .s AdminStatus=$p(^OEC("STAT",orestatusdr),"^",1)
    .q:AdminStatus'="D"  //只考虑停止执行
    .s qty=$p(^DHCOEDISQTY(dsp),"^",5)
    .s stopqty=stopqty+qty
    .
    s retqty=0
    s retrow=""
	f  s retrow=$o(^DHCPHRTIi(orditm,"ORDI",retrow)) q:retrow=""  d
	.s retsub=""
	.f  s retsub=$o(^DHCPHRTIi(orditm,"ORDI",retrow,retsub)) q:retsub=""  d
	..s curretqty=+$p($g(^DHCPHRTI(retrow,"RTI",retsub)),"^",3)
	..s retqty=retqty+curretqty

	s qty=ordqty-stopqty-retqty
	q qty
}

/// Descript:获取前一个状态  bianshuai 2015-12-02
ClassMethod GetPrevStatus(CurCNumber, PhLocID, Type) As %String
{
	Q:CurCNumber="" ""
	Q:PhLocID="" ""
	S PrevPs="",PrevNumber=""
	F  S CurCNumber=$O(^PIVAS(0,"FN","Y","N",CurCNumber),-1) Q:(CurCNumber="")||(PrevPs'="")  D
	.S psdr=""
	.F  S psdr=$o(^PIVAS(0,"FN","Y","N",CurCNumber,psdr)) Q:(psdr="")||(PrevPs'="")  D
	..S LocID=$P(^PIVAS(psdr),"^",7)
	..S LocType=$P(^PIVAS(psdr),"^",9)   //Bianshuai 2013815 增加类型判断
	..Q:LocID'=PhLocID
	..Q:LocType'=Type
	..S PrevPs=psdr
	..S PrevNumber=CurCNumber
	Q PrevPs_"^"_PrevNumber
}

}

Import SQLUser

/// 配液公共
Class web.DHCSTPIVA Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 医嘱优先级
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVA","LocOecpr",101)
Query LocOecpr(LocID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT PO_OECPR_Dr->OECPR_Desc,PO_OECPR_Dr->OECPR_Code,PO_OECPR_Dr FROM PIVA_Oecpr Where PO_Ctloc_Dr=:LocID and PO_rowid>0
}

/// 批次
Query BatNo(LocID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT distinct(PBT_BatNo) FROM PIVA_BatTime Where PBT_Ctloc_dr=:LocID  and PBT_RowID>0 Order By PBT_BatNo
}

/// 取消或拒绝的原因
Query OperReason(stype) As %SQLQuery(CONTAINID = 1)
{
SELECT POR_Desc,POR_Code,POR_RowID FROM PIVA_OperReason Where POR_Flag='Y' And POR_Type=:stype and POR_RowID>0
}

/// 配药状态
Query State(locdr) As %SQLQuery(CONTAINID = 1)
{
SELECT PS_Name,PS_Number,PS_RowID FROM PIVA_State Where PS_Flag='Y' and PS_TypeFlag='I' and PS_RowID>0 and ps_loc_dr=:locdr Order By PS_Number
}

/// 护士审核 1-已审核,=0-未审核
ClassMethod IfAuditByPriority(oeori As %String, priority As %String = "") As %String
{
   N (oeori,priority)
   //20141220 zhouyg 修改，改为只判断第一条，否则效率太低
   //s dhcDspId=$O(^DHCOEDISQTY(0,"OEORI",oeori,""))
   s dhcDspId=..GetFDspIDByOeori(oeori)	//zhouyg 20151103 改为判断第一条配液的记录
   q:dhcDspId="" 0
   s ret=##Class(web.DHCSTCOMMONSRV).IfAuditByPriority(dhcDspId)
   q ret
}

ClassMethod IfAuditByPriorityOld(oeori As %String, priority As %String) As %String
{
   N (oeori,priority)
   Q:oeori="" -1
   S ret=1
   S ord=+oeori
   S itm=$p(oeori,"||",2)
   S recloc=$P($g(^OEORD(ord,"I",itm,3)),"^",6)
   Q:recloc="" -2
   S plrowid=$o(^DHCPL(0,"Loc",recloc,""))
   S AduitNeed=""
   S:plrowid'="" AduitNeed=$p(^DHCPL(plrowid),"^",14)
   Q:AduitNeed'="Y" ret //不需审核,取配置

   S oepri=##class(web.DHCSTPIVA).GetOePriority(oeori)
   S priorCode=$P(oepri,"^",2)
   S priorCode=$ZCVT(priorCode,"U")
   q:priorCode="OM" ret
   q:priorCode="OMST" ret
   S ss=##class(web.DHCNurDrugAudit).GetAuditDrug(oeori)
   I $P(ss,"^",1)="" S ret=-5
   Q ret
}

/// 取主医嘱Rowid
ClassMethod GetMainOeori(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	Q:'$D(^OEORD(ord,"I",chl,11)) ""
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:loeori'="" loeori
 	Q oeori
}

/// 本医嘱是否关联医嘱 1-是；0-否
ClassMethod GetOISeqFlag(oeori As %String) As %String
{
	Q:oeori="" 0
 	N (oeori)
 	S ord=$p(oeori,"||",1) Q:ord="" 0
 	S chl=$p(oeori,"||",2) Q:chl="" 0
 	Q:'$D(^OEORD(ord,"I",chl,1)) 0
 	S glflag=0
 	S reploc=$P(^OEORD(ord,"I",chl,3),"^",6)
 	S linkorder=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:linkorder'="" 1
 	I linkorder="" D
 	.S tmpchl=""
 	.F  S tmpchl=$O(^OEORDi(0,"OEORI",ord,oeori,tmpchl)) Q:(tmpchl="")!(glflag=1)  d
 	..Q:'$D(^OEORD(ord,"I",tmpchl,3))
 	..Q:'$D(^OEORD(ord,"I",tmpchl,1))
 	..Q:$P(^OEORD(ord,"I",tmpchl,3),"^",6)'=reploc
 	..//7.0版本里去掉医嘱状态的判断,一组医嘱只要是停止一个医嘱就都停,此函数只判断是否关联医嘱不需看状态
 	..//S oestate=$p(^OEORD(ord,"I",tmpchl,1),"^",13)
 	..//Q:oestate=""
 	..//Q:'$D(^OEC("OSTAT",oestate))
 	..//S stcode=$P(^OEC("OSTAT",oestate),"^",1)
 	..//Q:(stcode'="V")&(stcode'="E")
 	..s glflag=1
 	q glflag
}

/// 检查所有关联医嘱,如果有任一个未打包的医嘱则所有关联医嘱保存到临时Global
ClassMethod SetSeqNoPacked(pid As %String, oeori As %String) As %String
{
	N (pid,oeori)
	Q:pid="" -1
	Q:oeori="" -1
 	Q:$D(^TMP("PIVA",pid,"NOQTY",oeori)) 0
 	S ord=$P(oeori,"||",1) Q:ord="" -1
 	S chl=$P(oeori,"||",2) Q:chl="" -1
 	Q:'$D(^OEORD(ord,"I",chl,1)) -1
 	Q:$O(^OEORD(ord,"I",chl,"X",0))="" 0 /// 非执行医嘱退出
 	S dspflag=1
 	S locdr=$P(^OEORD(ord,"I",chl,3),"^",6)
 	S linkorder=$P(^OEORD(ord,"I",chl,11),"^",39)
 	I linkorder'="" D
 	.S chl=$p(linkorder,"||",2)
 	.S oeori=ord_"||"_chl	/// 主医嘱Rowid
 	S priority=$P(^OEORD(ord,"I",chl,1),"^",8)
 	Q:priority="" -1
 	Q:'$D(^OECPR(priority)) -1
 	S priority=$P(^OECPR(priority),"^",1)
 	S priority=$ZCVT(priority,"U")
 	S dodis=##class(web.DHCSTKUTIL).GetDODIS(oeori)
 	/// 主医嘱未打包 ,自备药医嘱不计算
 	I (dodis="")&(priority'["OM") D
 	.S dspflag=0
 	.S:'$D(^TMP("PIVA",pid,"NOQTY",oeori)) ret=..SaveSeqNoPack(pid,oeori)
 	Q:dspflag=0 0
 	/// 子医嘱未打包判断
 	S gchl=""
 	F  S gchl=$O(^OEORDi(0,"OEORI",ord,oeori,gchl)) q:(gchl="")!(dspflag=0)  d
 	.Q:'$D(^OEORD(ord,"I",gchl,3))
 	.Q:'$D(^OEORD(ord,"I",gchl,1))
 	.Q:$P(^OEORD(ord,"I",gchl,3),"^",6)'=locdr
 	.S stat=$P(^OEORD(ord,"I",gchl,1),"^",13)
 	.Q:stat=""
 	.Q:'$D(^OEC("OSTAT",stat))
 	.S stcode=$P(^OEC("OSTAT",stat),"^",1)
 	.Q:(stcode'="V")&(stcode'="E")
 	.S priority=$P(^OEORD(ord,"I",gchl,1),"^",8)
 	.Q:priority=""
 	.Q:'$D(^OECPR(priority))
 	.S priority=$P(^OECPR(priority),"^",1)
 	.S priority=$ZCVT(priority,"U")
 	.Q:priority["OM"	/// 自备药医嘱不计算
 	.S goeori=ord_"||"_gchl
 	.S dodis=##class(web.DHCSTKUTIL).GetDODIS(goeori)
 	.I dodis="" D
 	..S dspflag=0
 	..S:'$D(^TMP("PIVA",pid,"NOQTY",oeori)) ret=..SaveSeqNoPack(pid,oeori)
 	q 0
}

ClassMethod SaveSeqNoPack(pid As %String, oeori As %String) As %String
{
	Q:oeori="" -1
	Q:pid="" -1
 	Q:$D(^TMP("PIVA",pid,"NOQTY",oeori)) 0
 	N (pid,oeori)
 	S num=0
 	S ord=$P(oeori,"||",1) Q:ord="" -1
 	S chl=$P(oeori,"||",2) Q:chl="" -1
 	Q:'$D(^OEORD(ord,"I",chl,1)) -1
 	Q:$O(^OEORD(ord,"I",chl,"X",0))="" -1	//非执行医嘱退出
 	S locdr=$P(^OEORD(ord,"I",chl,3),"^",6)
 	S linkorder=$P(^OEORD(ord,"I",chl,11),"^",39)
 	I linkorder'="" D
 	.S chl=$P(linkorder,"||",2)
 	.S oeori=ord_"||"_chl
 	S num=num+1
 	S ^TMP("PIVA",pid,"NOQTY",oeori)=oeori
	S gchl=""
	F  S gchl=$o(^OEORDi(0,"OEORI",ord,oeori,gchl)) Q:gchl=""  D
 	.Q:'$D(^OEORD(ord,"I",gchl,3))
 	.Q:'$D(^OEORD(ord,"I",gchl,1))
 	.Q:$P(^OEORD(ord,"I",gchl,3),"^",6)'=locdr
 	.S stat=$P(^OEORD(ord,"I",gchl,1),"^",13)
 	.Q:stat=""
 	.Q:'$D(^OEC("OSTAT",stat))
 	.S stcode=$P(^OEC("OSTAT",stat),"^",1)
 	.Q:(stcode'="V")&(stcode'="E")
 	.S toeori=ord_"||"_gchl
 	.S ^TMP("PIVA",pid,"NOQTY",toeori)=toeori
 	.S num=num+1
 	Q num
}

/// 关联医嘱打包1-打包,0-未打包
ClassMethod GetOrdNoPack(pid As %String, oeori As %String)
{
    
	Q:$D(^TMP("PIVA",pid,"NOQTY",oeori)) 0
	Q 1
}

/// 检查本医嘱是否打包1-打包,0-未打包
ClassMethod GetOItmNoPack(oeori As %String) As %String
{
	N (oeori)
 	S dodis=##class(web.DHCSTKUTIL).GetDODIS(oeori)
 	Q:dodis="" 0
 	Q 1
}

/// 检查要求皮试的医嘱,是否进行了皮试并且皮试为阴性  >=0  皮试正常 , -1 不正常，-6，未结果，-5 皮试(原液)
ClassMethod SkinTest(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" -1
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,5)) ""
	S SkinTestFlag=$P(^OEORD(ord,"I",itm,5),"^",2)
	I SkinTestFlag'="Y" D
	.S result=""
	E  D
	.S abnormal=$P(^OEORD(ord,"I",itm,11),"^",3)
	.S actiondr=$P(^OEORD(ord,"I",itm,11),"^",21)
	.I abnormal="N"  S result=1 
	.E  D
	..S result=-6 //未结果
	..i abnormal="Y" S result=-1  
	..I actiondr=1 S result=-5 //原液
	..I actiondr=2 S result=1  //免试
	Q result
}

/// Description:取皮试结果
/// Creator:Liang Qiang
/// CreatDate:2010-05-09
/// Input:医嘱Rowid
/// Output: 皮试(+)  皮试(-) 或  皮试()  或  皮试(原液)
ClassMethod SkinTestResult(oeori As %String) As %String
{
  n (oeori)
  s ret=""
  s skintest=..SkinTest(oeori)
  i skintest>0 s ret="皮试( - )"
  i skintest<0 s ret="皮试( + )"
  i skintest=-6 s ret="皮试(   )"
  i skintest=-5 s ret="皮试(原液)"
  Q ret
  //以下是之前的，以上的是最新修复的  2011-04-22
  s flag="Y"
  s ret=""
  s ord=$p(oeori,"||",1)
  s itm=$p(oeori,"||",2)
  s skintest=$p(^OEORD(ord,"I",itm,5),"^",2)
  s skintest=$p($g(^OEORD(ord,"I",itm,5)),"^",2)
  i skintest=flag d
  .s abnorm=$p($g(^OEORD(ord,"I",itm,11)),"^",3)
  .s skinTestCtcpDesc=""
  .s dhcoriId=$o(^DHCORDItem(0,ord,""))
  .q:dhcoriId="" 
  .s skinTestCtcpId=$p(^DHCORDItem(dhcoriId),"^",2)
  .i skinTestCtcpId="" q
  .s skinTestCtcpDesc=$p($g(^CTPCP(skinTestCtcpId,1)),"^",2)
  .s skinTestDate=$p(^DHCORDItem(dhcoriId),"^",3)
  .s skinTestTime=$p(^DHCORDItem(dhcoriId),"^",4)
  .i (abnorm="N") s ret=" (-)"_skinTestCtcpDesc
  .i (abnorm="Y") s ret=" (+)"_skinTestCtcpDesc
  .i (abnorm="") s ret=" ( )"
  q ret
}

/// 医嘱状态
ClassMethod GetOeState(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S oestate=$P(^OEORD(ord,"I",itm,1),"^",13)
	Q:oestate="" ""
	Q:'$D(^OEC("OSTAT",oestate)) ""
	S oestatecode=$P(^OEC("OSTAT",oestate),"^",1)
	S oestatedesc=$P(^OEC("OSTAT",oestate),"^",2)
	Q oestatecode_"^"_oestatedesc
}

/// Descript：	医嘱执行记录的医嘱状态
/// Creater：	zhouyg
/// CreateDate：20151109
/// Input：		医嘱执行ID
/// Return：	医嘱状态代码^医嘱状态描述
ClassMethod GetOrdExeState(OrdExeID As %String) As %String
{
	N (OrdExeID)
	Q:OrdExeID="" ""
	S ord=$p(OrdExeID,"||",1) Q:ord="" ""
	S itm=$p(OrdExeID,"||",2) Q:itm="" ""
	s exe=$p(OrdExeID,"||",3) Q:exe="" ""
	Q:'$D(^OEORD(ord,"I",itm,"X",exe,"BILL")) ""
	S oestate=$P(^OEORD(ord,"I",itm,"X",exe,"BILL"),"^",1)
	Q:oestate="" ""
	Q:'$D(^OEC("OSTAT",oestate)) ""
	S oestatecode=$P(^OEC("OSTAT",oestate),"^",1)
	S oestatedesc=$P(^OEC("OSTAT",oestate),"^",2)
	Q oestatecode_"^"_oestatedesc
}

/// 医嘱优先级
ClassMethod GetOePriority(oeori As %String) As %String
{
	N (oeori)
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

/// 配伍审核结果
ClassMethod GetPassResult(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S chstr=$P(^OEORD(ord,"I",itm,7),"^",3)
	Q chstr
}

/// 医嘱分类
ClassMethod GetArcItmCat(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S arcimid=$P(^OEORD(ord,"I",itm,1),"^",2)
 	Q:arcimid="" ""
 	S arcimm=$p(arcimid,"||",1)
 	Q:arcimm="" ""
 	S arcims=$p(arcimid,"||",2)
 	Q:arcims="" ""
 	Q:'$D(^ARCIM(arcimm,arcims,1)) ""
 	S arccatid=$p(^ARCIM(arcimm,arcims,1),"^",10)
 	Q:arccatid="" ""
 	Q:'$D(^ARC("IC",arccatid)) ""
 	S catcode=$P(^ARC("IC",arccatid),"^",1)
 	S catdesc=$P(^ARC("IC",arccatid),"^",2)
 	Q arccatid_"^"_catcode_"^"_catdesc
}

/// 取医嘱的频率
ClassMethod GetFreq(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""	
 	S freqcode=""
 	S ord=$P(oeori,"||",1) Q:ord="" freqcode
 	S chl=$P(oeori,"||",2) Q:chl="" freqcode
 	Q:'$D(^OEORD(ord,"I",chl,2)) freqcode
 	S freq=$P(^OEORD(ord,"I",chl,2),"^",4)
 	Q:freq="" ""
 	Q:'$D(^PHCFR(freq)) ""
 	S freqcode=$P(^PHCFR(freq),"^",1)
 	Q freq_"^"_freqcode
}

/// 取状态Number
ClassMethod GetPSNumber(pog As %String) As %String
{
 	N (pog)
 	S ps=$P(^PIVA(pog),"^",6) /// 状态
 	Q:ps="" ""
 	Q:'$D(^PIVAS(ps)) ""
 	S psnumber=$P(^PIVAS(ps),"^",1)
 	Q psnumber
}

/// 根据科室ID和取状态Number取该状态属性-是否减库
ClassMethod GetPSNumberProByLoc(ploc As %String, Number As %String) As %String
{
 	N (ploc ,Number)
 	s dispconfig=""
 	S psdr=""
 	F  S psdr=$O(^PIVAS(0,"NUMBER",Number,psdr)) q:psdr=""  d
 	.S locdr=$p(^PIVAS(psdr),"^",7)
 	.q:(locdr'="")&(locdr'=ploc)
 	.S intype=$p(^PIVAS(psdr),"^",9)
 	.q:intype'="I"
 	.S dispconfig=$p(^PIVAS(psdr),"^",6) 	
 	Q dispconfig
}

/// 根据科室ID和取状态Number取该状态属性2-排药是否是单独执行
ClassMethod GetPSSingleProByLoc(ploc As %String, Number As %String) As %String
{
 	N (ploc ,Number)
 	s singleflag=""
 	S psdr=""
 	F  S psdr=$O(^PIVAS(0,"NUMBER",Number,psdr)) q:psdr=""  d
 	.S locdr=$p(^PIVAS(psdr),"^",7)
 	.q:(ploc'="")&(locdr'=ploc)
 	.S intype=$p(^PIVAS(psdr),"^",9)
 	.q:intype'="I"
 	.S singleflag=$p(^PIVAS(psdr),"^",8) 
 	Q singleflag
}

/// 取状态描述
ClassMethod GetPSName(pog As %String) As %String
{
 	N (pog)
 	S ps=$P(^PIVA(pog),"^",6) /// 状态
 	Q:ps="" ""
 	Q:'$D(^PIVAS(ps)) ""
 	S psnumber=$P(^PIVAS(ps),"^",2)
 	Q psnumber
}

/// 取特殊状态
ClassMethod GetPOper(pog As %String) As %String
{
 	N (pog)
 	S poreason=""
 	S poper=$P(^PIVA(pog),"^",8) /// 状态
 	Q:poper="" ""
 	I poper'="N" D
 	.S por=$P(^PIVA(pog),"^",9)	/// 原因
 	.Q:por=""
 	.Q:'$D(^PIVAOR(por))
 	.S poreason=$P(^PIVAOR(por),"^",2)
 	Q poper_"^"_poreason
}

/// 判断是否非正常特殊状态
ClassMethod GetOePOper(oeori As %String) As %String
{
	N (oeori)
	S retstr=""
	S grpno=""
	F  s grpno=$O(^PIVA(0,"OEGRP",oeori,grpno)) Q:grpno=""  D
	.S pog=$O(^PIVA(0,"OEGRP",oeori,grpno,""))
	.S poper=..GetPOper(pog)
	.Q:poper=""
	.Q:$P(poper,"^")="N"
	.I retstr="" D
	..S retstr=grpno_"^"_poper
	.E  D
	..S retstr=retstr_"!"_grpno_"^"_poper
	Q retstr
}

/// 取dodis的配液子表ID
ClassMethod GetOGrpI(dodis As %String) As %String
{
	N (dodis)
	S ogrp=$O(^PIVA(0,"DSP",dodis,""))
	Q:ogrp="" ""
	S sub=$O(^PIVA(0,"DSP",dodis,ogrp,""))
	Q ogrp_"||"_sub
}

/// PIVA_BatTime取包含“空”批次的维护记录数
ClassMethod GetKBatNum() As %String
{
	N bnum,kstr
	S kstr="%空%"
	&SQL(Select count(PBT_RowID) Into :bnum From PIVA_BatTime Where PBT_BatNo Like :kstr)
	Q bnum
}

/// 根据批号取批次时间
ClassMethod GetTimeByBatNo(ploc As %String, btno As %String) As %String
{
	N (ploc,btno)
	S btime=""
	&SQL(Select PBT_TimeTo Into :btime From PIVA_BatTime Where PBT_Ctloc_Dr=:ploc And PBT_BatNo=:btno)
	Q btime
}

/// 根据OEORI_SttTim取批
/// w ##class(web.DHCSTPIVA).GetBatNoByTime(101,40000,10)
ClassMethod GetBatNoByTime(ploc As %String, btime As %String, warddr As %String = "") As %String
{
	N (ploc,btime,warddr)
	S batno=""
	//&SQL(Select PBT_BatNo Into :bno From PIVA_BatTime Where PBT_Ctloc_Dr=:ploc And PBT_TimeFrom<=:btime And PBT_TimeTo>=:btime)
	s pivabno=""
	&sql(DECLARE BatCursor CURSOR FOR 
	        SELECT PBT_BatNo,PBT_Ward_Dr Into :bno,:ward
	        FROM PIVA_BatTime
	        WHERE PBT_Ctloc_Dr=:ploc And PBT_TimeFrom<=:btime And PBT_TimeTo>=:btime)
	&sql(OPEN BatCursor)
	FOR { &sql(FETCH BatCursor)
	    QUIT:SQLCODE  
	    QUIT:batno'=""
	    i +warddr'=0 d
	    .s:warddr=ward batno=bno
	    e  d
	    .s batno=bno
	    i ward="" s pivabno=bno //不按病区的批次
	}
	&sql(CLOSE BatCursor)
	i batno="" s batno=bno
	Q batno
}

ClassMethod GetBatNoByTimeSeq(ploc As %String, btime As %String, seqflag As %String, warddr As %String = "") As %String
{
	N (ploc,btime,seqflag,warddr)
	S batno=""
	//&SQL(Select PBT_BatNo Into :bno From PIVA_BatTime Where PBT_Ctloc_Dr=:ploc And PBT_TimeFrom<=:btime And PBT_TimeTo>=:btime And PBT_SeqFlag=:seqflag)
	s pivabno=""
	&sql(DECLARE Bat1Cursor CURSOR FOR 
	        SELECT PBT_BatNo,PBT_Ward_Dr Into :bno,:ward
	        FROM PIVA_BatTime
	        WHERE PBT_Ctloc_Dr=:ploc And PBT_TimeFrom<=:btime And PBT_TimeTo>=:btime And PBT_SeqFlag=:seqflag)
	&sql(OPEN Bat1Cursor)
	FOR { &sql(FETCH Bat1Cursor)
	    QUIT:SQLCODE  
	    QUIT:batno'=""
	    i +warddr'=0 d
	    .s:warddr=ward batno=bno
	    e  d
	    .s batno=bno
	    i ward="" s pivabno=bno //不按病区的批次
	}
	&sql(CLOSE Bat1Cursor)
	i batno="" s batno=pivabno //当按病区取不到批次时,按不按病区分配批次,yunhaibao20160302
	Q batno
}

/// 根据频率取第几批
ClassMethod GetBatNoByFreq(ploc As %String, btime As %String, freq As %String, freqcode As %String, warddr As %String = "") As %String
{
	N (ploc,btime,freq,freqcode,grpno,warddr)
	S batno=""
	I freqcode="QD" {
		S batno=##class(web.DHCSTPIVA).GetBatNoByTime(ploc,btime,warddr)
	}
	ELSE {
		S pbf=$O(^PIVABF(0,"FREQGRP",ploc,freq,grpno,""))
		Q:pbf=""
		S batno=$P(^PIVABF("pbf"),"^",2)
	}
	Q batno
}

/// 取第几批配液
/// w ##class(web.DHCSTPIVA).GetBatNo(101,57600,1,9)
ClassMethod GetBatNo(ploc As %String, btime As %String, seqflag As %String, warddr As %String = "") As %String
{
	N (ploc,btime,seqflag,warddr)
	S knum=..GetKBatNum()
	S batno=""
	I seqflag=1 S seqflag="Y"
	E  S seqflag="N"
	I knum=0 {
		S batno=..GetBatNoByTime(ploc,btime,warddr)
	}
 	ELSE {
	 	S batno=..GetBatNoByTimeSeq(ploc,btime,seqflag,warddr)
 	}
 	Q batno
}

/*
/// 取医嘱的开始执行时间
ClassMethod GetSttime(oeori As %String, grpno As %String) As %String
{
	N (oeori)
	Q:oeori="" ""	
 	S sttime=""
 	S ord=$P(oeori,"||",1) Q:ord="" sttime
 	Q chl=$P(oeori,"||",2) Q:chl="" sttime
 	Q:'$D(^OEORD(ord,"I",chl,2)) sttime
 	S freq=$P(^OEORD(ord,"I",chl,2),"^",4)
 	Q:freq="" sttime
 	Q:'$D(^PHCFR(freq)) sttime
 	S pri=$P(^OEORD(ord,"I",chl,1),"^",8)
	Q:pri="" sttime
	Q:'$D(^OECPR(pri)) sttime
	S prcode=$P(^OECPR(pri),"^",2)
	S prcode=$ZCVT(prcode,"U")
 	S freqcode=$P(^PHCFR(freq),"^",1)
 	S freqcode=$ZCVT(freqcode,"U")
 	I freqcode'="QD" D
 	.S sttime=$P(^OEORD(ord,"I",chl,1),"^",10)
 	.I (prcode="S")!(prcode="OMST") S sttime="28800"
 	E  D
 	.S grpno=+grpno
 	.S:grpno=0 grpno=1
 	.S dhcori=$O(^DHCORDItem(0,oeori,""))
 	.Q:dhcori=""
 	.S sttimes=$P(^DHCORDItem(dhcori),"^",12)
 	.S sttime=$P(sttimes,",",grpno)
 	Q sttime
}
*/
/// 取修改后的批次
ClassMethod GetUpBatNo(oeori As %String, grpno As %String) As %String
{
	N (oeori,grpno)
	Q:oeori="" ""
	Q:grpno="" ""
	S pbu=$O(^PIVABU(0,"OEGRP",oeori,grpno,""),-1)
	Q:pbu="" ""
	S batno=$P(^PIVABU(pbu),"^",3)
	Q batno
}

ClassMethod GetIncItm(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S arcimid=$P(^OEORD(ord,"I",itm,1),"^",2)
 	Q:arcimid="" ""
 	S arcimm=$p(arcimid,"||",1)
 	Q:arcimm="" ""
 	s arcimsub=$p(arcimid,"||",2)
 	q:arcimsub="" ""
 	s arcitemcat=$p($g(^ARCIM(arcimm,arcimsub,1)),"^",10)
 	q:arcitemcat="" ""
 	s arcitmtype=$p($g(^ARC("IC",arcitemcat)),"^",7)
 	q:arcitmtype'="R" "" ; yunhaibao20170223,过滤非药品医嘱
 	S inci=$O(^INCI(0,"ARCIM_DR",arcimm,""))
 	Q:inci="" ""
 	Q:'$D(^INCI(inci,1)) ""
 	S itmcode=$P(^INCI(inci,1),"^",1)
 	S itmdesc=$P(^INCI(inci,1),"^",2)
 	S phccat=##Class(web.DHCSTCOMINC).GetPhcCatDesc(inci) //phccatID_"^"_phccatDesc
 	S phcsubcat=##Class(web.DHCSTCOMINC).GetPhcSCDesc(inci) //phcsubcatID_"^"_phcsubcatDesc
 	Q inci_"^"_itmcode_"^"_itmdesc_"^"_phccat_"^"_phcsubcat
}

/// 取医嘱的剂量
ClassMethod GetDosage(oeori As %String) As %String
{
	N (oeori)
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

/// 用法
ClassMethod GetInstruc(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S instruc=$P(^OEORD(ord,"I",itm,2),"^",7)
	Q:instruc="" ""
	Q:'$D(^PHCIN(instruc)) ""
	S instruc=$P(^PHCIN(instruc),"^",2)
	Q instruc
}

/// 用药疗程
ClassMethod GetDura(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S dura=$P(^OEORD(ord,"I",itm,2),"^",6)
	Q:dura="" ""
	Q:'$D(^PHCDU(dura)) ""
	S dura=$P(^PHCDU(dura),"^",1)
	Q dura
}

/// 医生
ClassMethod GetDoctor(oeori As %String) As %String
{
	N (oeori)
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

/// 打印标志
ClassMethod GetPrintSign(oeori As %String) As %String
{
	N (oeori)
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

/// 剂量是否整包装 1-是，0-否
ClassMethod GetCompFlag(oeori As %String) As %String
{
	N (oeori)
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
	//S eqsub=$O(^PHCD(phc,"DF",formsub,"EQ","0"))
	//Q:eqsub="" 0
	//S eqqty=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",2)
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

/// 根据登记号,取出病人信息:姓名、性别、年龄
ClassMethod GetPaInfo(itmjs As %Library.String = "", RegNo As %String) As %String
{
	N (RegNo,itmjs)
	Q:RegNo="" ""
    ;病人就诊号AdmNo
    S papmi=$O(^PAPERi("PAPMI_PatNo",RegNo,"")) ;病人信息表
    Q:papmi="" ""    
    S paname=$P(^PAPER(papmi,"ALL"),"^",1)
    S dob=$P(^PAPER(papmi,"ALL"),"^",6)
    S sex=$P(^PAPER(papmi,"ALL"),"^",7)
    I sex'="" D
    .I $D(^CT("SEX",sex)) S sex=$P(^CT("SEX",sex),"^",2)
	I dob'="" D
 	.S age=$FN((+$H-dob)/365,"",0)
 	.S dob=$ZD(dob,3)
 	.S dob=dob_"( "_age_"岁 )" 
	s result=paname_"^"_sex_"^"_dob
	s retval=itmjs_"('"_$ZCVT(result,"O","JS")_"');"
	&javascript<#(retval)#>
	Q result
}

/// 根据登记号取就诊信息
ClassMethod GetAdm(itmjs As %Library.String = "", RegNo As %String) As %Integer
{
	N (RegNo,itmjs)
	S result=""
	S papmi=$O(^PAPERi("PAPMI_PatNo",RegNo,""))
	Q:papmi="" ""
   
    S paname=$P(^PAPER(papmi,"ALL"),"^",1)
    S sex=$P(^PAPER(papmi,"ALL"),"^",7)
    I sex'="" D
    .I $D(^CT("SEX",sex)) S sex=$P(^CT("SEX",sex),"^",2)
	S adm="" F  S adm=$O(^PAPERdr(papmi,"ADM","I",adm),-1) Q:adm=""  D
	.I adm'="" D
	..S adm=+adm
	..Q:$P(^PAADM(adm),"^",2)'="I"      ; if not inpatient then quit
	..S depcodedr=$P(^PAADM(adm),"^",4)
	..s depDesc=""
	..I depcodedr'="" D
	...S:$D(^CTLOC(depcodedr)) depDesc=$P(^CTLOC(depcodedr),"^",2)
	..i $f(depDesc,"-") s depDesc=$p(depDesc,"-",2)
	..S admdate=$P(^PAADM(adm),"^",6)
	..I admdate>0 S admdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(admdate,"PIVA") 
	..S admtime=$P(^PAADM(adm),"^",7)
	..I admtime>0 S admtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(admtime,"PIVA")
	..s curWardDesc=""
	..S curWard=$P(^PAADM(adm),"^",70)
	..I curWard'="" D
	...S:$D(^PAWARD(+curWard)) curWardDesc=$P(^PAWARD(+curWard),"^",2)
	..i $f(curWardDesc,"-") s curWardDesc=$p(curWardDesc,"-",2)
	..S curBed=$P(^PAADM(adm),"^",73)
	..I curBed'="" D
	...S w=+curBed,b=$P(curBed,"||",2)
	...Q:(w="")!(b="")
	...S curBedcode=$p(^PAWARD(w,"BED",b),"^",1)
	..S doctor=$P(^PAADM(adm),"^",9)
	..I doctor'="" S doctor=$p(^CTPCP(doctor,1),"^",2 )
	.S xxx=adm_"&"_$g(curWardDesc)_" "_admdate_" "_admtime //_" * "_$g(curWardDesc)_" * "_$g(curBedcode)_" * "_doctor
	.I result="" D
	..S result=xxx
	.E  D
	..S result=result_"^"_xxx
	S retval=itmjs_"('"_$ZCVT(result,"O","JS")_"');"
	&javascript<#(retval)#>
	Q result
}

/// 取登记号和姓名
ClassMethod GetPat(adm As %String) As %String
{
	N (adm)
	Q:adm="" ""
	Q:'$D(^PAADM(adm)) ""
	S papmi=$p(^PAADM(adm),"^",1)
	Q:papmi="" ""
	Q:'$D(^PAPER(papmi,"ALL")) ""
	S paname=$P(^PAPER(papmi,"ALL"),"^",1)
	S ipno=$P(^PAPER(papmi,"PAT",1),"^",1)
	Q ipno_"^"_paname_"^"_papmi
}

/// 取下一个状态
ClassMethod GetNextStatOld(psdr As %String) As %String
{
	N (psdr)
	Q:psdr="" ""
	Q:'$D(^PIVAS(psdr)) ""
	S psnumber=$P(^PIVAS(psdr),"^",1)
	S nextnumber=$O(^PIVAS(0,"FN","Y","N",psnumber))
	Q:nextnumber="" ""
	S nextps=$O(^PIVAS(0,"NUMBER",nextnumber,""))
	Q nextps_"^"_nextnumber
}

/// 检查关联医嘱组中是否有itm医嘱 1-是，0-否
ClassMethod ChkExItm(oeori As %String, itmdr As %String) As %String
{
	N (oeori,itmdr)
	Q:oeori="" 0
	Q:itmdr="" 1
	s oeori=$p(oeori,"||",1,2)
 	S ord=$p(oeori,"||",1) Q:ord="" 0
 	S chl=$p(oeori,"||",2) Q:chl="" 0
 	Q:'$D(^OEORD(ord,"I",chl,1)) 0
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	S:loeori'="" oeori=loeori /// 主医嘱
 	Q:$P(..GetIncItm(oeori),"^",1)=itmdr 1
 	S ord=$p(oeori,"||",1)
 	S chl=$p(oeori,"||",2)
 	S lchl="",qflag=0
 	F  S lchl=$O(^OEORDi(0,"OEORI",ord,oeori,lchl)) Q:(lchl="")!(qflag=1)  D
 	.S loeori=ord_"||"_lchl
 	.S:$P(..GetIncItm(loeori),"^",1)=itmdr qflag=1
 	Q qflag
}

/// 检查关联医嘱组中是否有药学分类医嘱 1-是，0-否
ClassMethod ChkExPhcCat(oeori As %String, phccat As %String) As %String
{
	N (oeori,phccat)
	Q:oeori="" 0
	Q:phccat="" 1
 	S ord=$p(oeori,"||",1) Q:ord="" 0
 	S chl=$p(oeori,"||",2) Q:chl="" 0
 	Q:'$D(^OEORD(ord,"I",chl,1)) 0
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	S:loeori'="" oeori=loeori /// 主医嘱
 	S itmstr=..GetIncItm(oeori)
 	Q:$P(itmstr,"^",4)=phccat 1
 	S ord=$p(oeori,"||",1)
 	S chl=$p(oeori,"||",2)
 	S lchl="",qflag=0
 	F  S lchl=$O(^OEORDi(0,"OEORI",ord,oeori,lchl)) Q:(lchl="")!(qflag=1)  D
 	.S loeori=ord_"||"_lchl
 	.S itmstr=..GetIncItm(loeori)
 	.S:$P(itmstr,"^",4)=phccat qflag=1
 	Q qflag
}

/// 检查关联医嘱组中是否有药学子分类医嘱 1-是，0-否
ClassMethod ChkExPhcSubCat(oeori As %String, phcsubcat As %String) As %String
{
	N (oeori,phcsubcat)
	Q:oeori="" 0
	Q:phcsubcat="" 1
 	S ord=$p(oeori,"||",1) Q:ord="" 0
 	S chl=$p(oeori,"||",2) Q:chl="" 0
 	Q:'$D(^OEORD(ord,"I",chl,1)) 0
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	S:loeori'="" oeori=loeori /// 主医嘱
 	Q:$P(..GetIncItm(oeori),"^",6)=phcsubcat 1
 	S ord=$p(oeori,"||",1)
 	S chl=$p(oeori,"||",2)
 	S lchl="",qflag=0
 	F  S lchl=$O(^OEORDi(0,"OEORI",ord,oeori,lchl)) Q:(lchl="")!(qflag=1)  D
 	.S loeori=ord_"||"_lchl
 	.S:$P(..GetIncItm(loeori),"^",6)=phcsubcat qflag=1
 	Q qflag
}

/// ,phccat As %String,phcsubcat As %String
/// 格式化录入的简写打印单号pno<9999
ClassMethod GetFormatNo(phaloc As %String, pno As %String) As %String
{
	N (phaloc,pno)
	Q:+pno=0 pno
	Q:+pno>9999 pno
	S phalocset=$O(^DHCPL(0,"Loc",phaloc,""))
	Q:phalocset="" ""
	S prefix=$P(^DHCPL(phalocset),"^",13)   
	S finaldate=$P(^DHCPL(phalocset),"^",15)   
	S countnum=$P(^DHCPL(phalocset),"^",12) 	
	I countnum<pno S finaldate=finaldate-1
	S dispno=prefix_$E($ZD(finaldate,8),3,8)_$tr($j(pno,4)," ","0")
	Q dispno
}

/// 取液体总量
ClassMethod GetTotalLiquid(pog As %String) As %String
{
	N (pog)
	Q:pog="" 0
	S ret=0
	S sub="0"
	F  S sub=$O(^PIVA(pog,"I",sub)) Q:sub=""  D
	.S dsp=$P(^PIVA(pog,"I",sub),"^",1) Q:dsp=""
	.Q:'$D(^DHCOEDISQTY(dsp))
	.S oeori=$P(^DHCOEDISQTY(dsp),"^",1) Q:oeori=""
	.S ord=$p(oeori,"||",1) Q:ord=""
	.S itm=$p(oeori,"||",2) Q:itm=""
	.Q:'$D(^OEORD(ord,"I",itm,1))
	.S arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
	.S arcimm=$P(arcim,"||",1) Q:arcimm=""
	.S arcims=$P(arcim,"||",2) Q:arcims=""
	.Q:'$D(^ARCIM(arcimm,arcims,1))
	.S phcdf=$P(^ARCIM(arcimm,arcims,1),"^",12)
	.S phc=$P(phcdf,"||",1) Q:phc=""
	.S formsub=$P(phcdf,"||",2) Q:formsub=""
	.S eqsub=$O(^PHCD(phc,"DF",formsub,"EQ","0")) Q:eqsub=""
	.S equom=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1)
	.I equom'="" D
	..S:$D(^CT("UOM",equom)) equom=$P(^CT("UOM",equom),"^",2)
	.S equom=$ZCVT(equom,"U")
	.Q:equom'="ML"
	.S dosqty=$P(^OEORD(ord,"I",itm,2),"^",1)
	.S ret=ret+dosqty
	S ret=ret_"ml"
	Q ret
}

ClassMethod GetTotalLiquidOe(moeori As %String) As %String
{
	N (moeori)
	S ret=0
	Q:moeori="" ret
	S ord=$P(moeori,"||",1) Q:ord="" ret
	S itm=$P(moeori,"||",2) Q:itm="" ret
	Q:'$D(^OEORD(ord,"I",itm,1)) ret
	S ret=..GetLiquid(moeori)
	S gchl=0
	F  S gchl=$o(^OEORDi(0,"OEORI",ord,moeori,gchl)) Q:gchl=""  D
 	.S toeori=ord_"||"_gchl
	.s dosqty=..GetLiquid(toeori)
	.S ret=ret+dosqty
	S ret=ret_"ml"
	Q ret
}

ClassMethod GetLiquid(oeori As %String) As %String
{
	N (oeori)
	S ret=0
	S ord=$p(oeori,"||",1) Q:ord="" ret
	S itm=$p(oeori,"||",2) Q:itm="" ret
	Q:'$D(^OEORD(ord,"I",itm,1)) ret
	S arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
	S arcimm=$P(arcim,"||",1) Q:arcimm="" ret
	S arcims=$P(arcim,"||",2) Q:arcims="" ret
	Q:'$D(^ARCIM(arcimm,arcims,1)) ret
	S phcdf=$P(^ARCIM(arcimm,arcims,1),"^",12)
	S phc=$P(phcdf,"||",1) Q:phc="" ret
	S formsub=$P(phcdf,"||",2) Q:formsub="" ret
	S dosuomdr=$P(^OEORD(ord,"I",itm,2),"^",3)
	q:dosuomdr="" 0
	s dosuom=$P(^CT("UOM",dosuomdr),"^",2)
	S dosuom=$ZCVT(dosuom,"U")
	S dosuomqty=$P(^OEORD(ord,"I",itm,2),"^",1)
	q:dosuom="ML" dosuomqty
	
	s eqsub=0
	f  S eqsub=$O(^PHCD(phc,"DF",formsub,"EQ",eqsub)) Q:(eqsub="")||(eqsub=0)  d
	.S equom=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1)
	.I equom'="" D
	..S:$D(^CT("UOM",equom)) equom=$P(^CT("UOM",equom),"^",2)
	.S equom=$ZCVT(equom,"U")
	.Q:equom'="ML"
	.S equomqty=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",2)
	.S ret=dosuomqty*equomqty
	.
	
	Q +$g(ret)
}

/// 标签打印的病人信息
ClassMethod GetOeInfoByMoeori(moeori) As %String
{
	N (moeori)
	Q:moeori="" ""
	S ord=$P(moeori,"||",1)
	S sub=$P(moeori,"||",2)
	S adm=$P(^OEORD(ord),"^",1)	/// 病人 PAADM_Rowid
	S (bed,paname,ipno,age,sex)=""
	I adm'="" D
 	.S bedid=$P(^PAADM(adm),"^",73) /// 床号
 	.I bedid'="" D
 	..S wardid=$P(bedid,"||",1)
 	..S bedsub=$P(bedid,"||",2)
 	..I $D(^PAWARD(wardid,"BED",bedsub)) S bed=$P(^PAWARD(wardid,"BED",bedsub),"^",1)
 	.S papmi=$p(^PAADM(adm),"^",1) 
	.S paname=$P(^PAPER(papmi,"ALL"),"^",1)
	.S ipno=$P(^PAPER(papmi,"PAT",1),"^",1)
	.S padob=$P(^PAPER(papmi,"ALL"),"^",6)
	.//s:padob'="" age=$fn((+$h-padob)/365,"",0)
	.//S age=age_"岁"
	.S pmino=$p(^PAPER(papmi,"PAT",1),"^",2) //登记号
	.s pmi=$o(^PAPERi("PAPMI_PatNo",pmino,""))
    .s age=##class(web.DHCSTKUTIL).GetAge(pmi,adm) //年龄统一调用接口wyx 2015-01-29
	.S sex=$P(^PAPER(papmi,"ALL"),"^",7)
	.I sex'="" D
	..S:$D(^CT("SEX",sex)) sex=$P(^CT("SEX",sex),"^",2)
	Q bed_"^"_paname_"^"_ipno_"^"_age_"^"_sex
}

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

/// 医嘱是否执行 1-是，0-否
ClassMethod GetOeoreStat(oeori As %String, grpno As %String) As %String
{
	N (oeori,grpno)
	Q:oeori="" 0
	Q:grpno="" 0
	S ord=$p(oeori,"||",1) Q:ord="" 0
	S itm=$p(oeori,"||",2) Q:itm="" 0
	Q:'$D(^OEORD(ord,"I",itm,1)) 0
	Q:'$D(^OEORD(ord,"I",itm,"X",grpno)) 0
	S exedate=$P(^OEORD(ord,"I",itm,"X",grpno),"^",19)
	Q:exedate="" 0
	Q 1
}

/// 诊断
ClassMethod GetMRDiagnosDesc(AdmID As %String, DelimStr As %String) As %String
{
	s retval=""
	s i=0
	s MRAdmRowid=$p(^PAADM(AdmID),"^",61)
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MRAdmRowid)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRDesc=obj.Data("MRDIADesc")
    .i MRDesc'="" s MRDesc=$LIST(MRDesc,1)
	.i Desc="" s Desc=MRDesc
	.e  d
	..i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
	.Q:Desc=""
	.s i=i+1
	.s Desc=i_"."_Desc
	.if retval="" s retval=Desc
	.e  s retval=retval_DelimStr_Desc
	d obj.Close()
	q retval
	//q $ZCVT(retval,"O","JS")
}

/// 过敏史
ClassMethod GetPAAllergy(PatientID As %String, DelimStr As %String) As %String
{
	s retval=""
	s i=0
	Set obj=##class(%ResultSet).%New("web.PAAllergy:Find")
	d obj.Execute(PatientID,"ALG_InActive")
	For  Quit:'obj.Next()  Do
	.s Rowid=obj.Data("RowID")
	.s PhcGEname=obj.Data("PHCGEName")
	.s PhcDname=obj.Data("PHCDName")
	.s comm=$G(^PAPER(PatientID,"ALG",$P(Rowid,"||",2),"CMT",1))
    .S Desc=""
	.i PhcGEname'="" S Desc=PhcGEname
	.i PhcDname'="" D
	..I Desc="" S Desc=PhcDname
	..E  S Desc=Desc_","_PhcDname
	.I comm'="" D
	..I Desc="" S Desc=comm
	..E  S Desc=Desc_","_comm
	.Q:Desc=""
	.s i=i+1
	.s Desc=i_"."_Desc
	.if retval="" s retval=Desc
	.e  s retval=retval_DelimStr_Desc
	d obj.Close()
	Q retval
	//q $ZCVT(retval,"O","JS")
}

/// 根据oeori取病人基本信息和本次就诊信息
ClassMethod GetPatInfoByOeori(oeori As %String) As %String
{
	
	Q:oeori="" ""
	N (oeori)
	S paadm=..GetAdmByOeori(oeori)
	Q:paadm="" ""
	S painfo=..GetPatAdmInfo(paadm)
	Q painfo
}

/// 根据adm取病人基本信息和本次就诊信息
ClassMethod GetPatAdmInfo(adm As %String) As %String
{
	N (adm)
	Q:adm="" ""
	Q:'$D(^PAADM(adm)) ""
	S pat=..GetPat(adm)
	S regno=$P(pat,"^",1)	//登记号
	S paname=$P(pat,"^",2)	//姓名
	S papmi=$P(pat,"^",3)	//病人rowid
	S patinfo=..GetPaInfo("",regno)
	S pasex=$P(patinfo,"^",2)	//性别
	//S paage=$P(patinfo,"^",3)	//年龄
	s pmi=$o(^PAPERi("PAPMI_PatNo",regno,""))
    s paage=##class(web.DHCSTKUTIL).GetAge(pmi,adm) //年龄统一调用接口wyx 2015-01-29
	S paweight=..GetPatWeight(adm)	//体重
	S MRDiagnos=..GetMRDiagnosDesc(adm,$char(13,10))
	S PAAllergy=..GetPAAllergy(papmi,$char(13,10))
	S Data=regno_"^"_paname_"^"_pasex_"^"_paage_"^"_paweight_"^"_MRDiagnos_"^"_PAAllergy
	Q Data
}

/// 根据Oeori取病人 PAADM_Rowid
ClassMethod GetAdmByOeori(Oeori As %String) As %String
{
	N (Oeori)
	Q:Oeori="" ""
	S ord=$P(Oeori,"||",1)
	Q:ord="" ""
	Q:'$D(^OEORD(ord)) ""
	S adm=$P(^OEORD(ord),"^",1)
	Q adm
}

/// 根据Oeori取医嘱备注
ClassMethod GetOrdItmRemark(ordi As %String) As %String
{
	n (ordi)
	s ord=$p(ordi,"||",1)
	s item=$p(ordi,"||",2)
	q:ord="" ""
	q:item="" ""
	q:'$d(^OEORD(ord,"I",item)) ""
	s (num,memo)=""
	s num="0" f  s num=$o(^OEORD(ord,"I",item,"DEP",num)) q:num=""  d
	.s memo=memo_$g(^OEORD(ord,"I",item,"DEP",num))
	q memo
}

/// Creator:Liang Qiang
/// CreatDate:2010-02-07
/// 剂量的单位如果不是"ml",则转换成"ml"  
/// Input:医嘱rowid
/// Output:剂量ml
ClassMethod GetDosageML(oeori As %String) As %String
{
	N (oeori)
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

/// Creator:Liang Qiang
/// CreatDate:2009-08-07
/// Description:判断科室库存项Rowid查找所有批次库存量是否>该发药量(住院) 
/// Table:INC_ItmLcBt
/// Input:医嘱Rowid,科室Rowid,发药数量
/// Ouput:1: 可发药 0:不可发药
/// Others:
ClassMethod GetPhaQty(oeori, loc, dspqty) As %String
{
  n (oeori,loc,dspqty)
  s ord=+oeori
  s chl=$p(oeori,"||",2)
  s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2) 
  s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
  q:inci="" 0
  s ch=$o(^INCI("IL_LOC",loc,inci,""))
  q:ch="" 0
  s incil=inci_"||"_ch 
  s sumqty=0
  s chl=0
  f  s chl=$o(^INCI(+incil,"IL",$p(incil,"||",2),"LB",chl)) q:chl=""  d
  .s phyqty=$p(^INCI(+incil,"IL",$p(incil,"||",2),"LB",chl),"^",2)
  .s dirtyqty=$p(^INCI(+incil,"IL",$p(incil,"||",2),"LB",chl),"^",3)
  .s phyqty=+phyqty
  .s dirtyqty=+dirtyqty
  .s qty=phyqty-dirtyqty
  .q:qty'>0
  .s sumqty=sumqty+qty
  q:sumqty'<dspqty 1
  q:sumqty<dspqty 0
  q 0
}

/// Creator:Liang Qiang
/// CreatDate:2010-02-07
/// yunhaibao,20170307此科室组停用,统一调用web.DHCSTKUTIL.cls GetLocGroupQuery
Query GetLocGrp() As %SQLQuery(CONTAINID = 1)
{
 SELECT PLG_Desc,PLG_Rowid FROM PIVA_LocGrp
}

/// Creator:Liang Qiang
/// CreatDate:2010-02-07
/// Description:验证该病区是否属于该科室组
/// Input:科室组Rowid,以“G”字符结尾区分, ward病区rowid
/// Output:1-真,0-假
ClassMethod CheckWard(tWardID, ward) As %String
{
	n (tWardID,ward)
	s ret=0
	q:tWardID="" 1
    q:($f(tWardID,"G")=0)&(tWardID=ward) 1 
    q:($f(tWardID,"G")=0)&(tWardID'=ward) 0
    s ret=0
    s slg=+tWardID
	q:slg=0 1
	q:ward="" 1 
    s ret=0
    s sub=""
    f  s sub=$o(^DHCSLG(slg,"I",sub)) q:(sub="")||(ret=1)  d
    .s tmplocdr=$p(^DHCSLG(slg,"I",sub),"^",1)
    .s tmpwardr=$o(^PAWARD(0,"WARD_LocationDR",tmplocdr,""))
    .i tmpwardr=ward d
    ..s ret=1
    q ret
    /// 如下为piva_locgrp的判断,8.0.2已停用 
    s ret=0
    s plg=+tWardID
    s sub=""
    f  s sub=$o(^PLGR(plg,"I",sub)) q:sub=""  d
    .s tmplocdr=$p(^PLGR(plg,"I",sub),"^",3)
    .s tmpwardr=$o(^PAWARD(0,"WARD_LocationDR",tmplocdr,""))
    .i tmpwardr=ward d
    ..s ret=1
    q ret
}

/// Creator:Liang Qiang
/// CreatDate:2010-03-27
/// Description:取护士审核信息:人员-日期-时间
/// Input:医嘱Rowid
/// Output:护士审核信息:人员-日期-时间
ClassMethod GetAuditByWard(oeori As %String) As %String
{
   N (oeori)
   S ret=""
   Q:oeori="" ret
   S oepri=##class(web.DHCSTPIVA).GetOePriority(oeori)
   S priorCode=$P(oepri,"^",2)
   S priorCode=$ZCVT(priorCode,"U")
   Q:priorCode["OM" ret
   S AuditInfo=##class(web.DHCNurDrugAudit).GetAuditDrug(oeori)
   Q:$P(AuditInfo,"^",1)="" ret
   s auditor=$P(AuditInfo,"^",1)
   i auditor'="" s auditor=$p($g(^SSU("SSUSR",auditor)),"^",2) 
   s auditdate=$P(AuditInfo,"^",2)
   i auditdate'="" s auditdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(auditdate,"PIVA")
   s audittime=$P(AuditInfo,"^",3)
   i audittime'="" s audittime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(audittime,"PIVA")
   s AuditInfo=auditor_"^"_auditdate_"^"_audittime
   Q AuditInfo
}

/// Creator:Liang Qiang
/// CreatDate:2010-03-27
/// Description:取配液分类
/// Input:
/// Output:配液分类
ClassMethod GetPIVAOrdType() As %String
{
	q ..GetPivaCat()  ; hulihua 2016-12-21 采用新的配液类别
	s catstr=""
	s h=1
    s potyid="0"
    f  s potyid=$o(^PIVATY(potyid)) q:potyid=""  d
    .s catdr=$p(^PIVATY(potyid),"^",2)
    .s subcatdr=$p(^PIVATY(potyid),"^",1)
    .i (catdr'="")&(subcatdr="") d
    ..s catdesc=$p(^PHCC(catdr),"^",2)
    ..s catindex=catdr
    ..i catstr="" d
    ...s catstr=catdesc_"^"_catindex
    ..e  d
    ...s catstr=catstr_"!!"_catdesc_"^"_catindex
    .;
    .i subcatdr'="" d
    ..s subcat=$p(^PHCC(+subcatdr,"SC",$p(subcatdr,"||",2)),"^",2)
    ..s subcatindex=subcatdr
    ..i h=1 d
    ...s catstr=subcat_"^"_subcatindex
    ..e  d
    ...s catstr=catstr_"!!"_subcat_"^"_subcatindex
    ..s h=h+1
    .
    s cnt=$l(catstr,"!!")
    s catother="TPN"_"^"_"TPN"_"!!"_"其它"_"^"_"OTHER"
    i catstr'="" d
    .s catstr=catstr_"!!"_catother
    Q catstr
}

/// Creator:Liang Qiang
/// CreatDate:2010-03-27
/// Description:取得关联医嘱总剂量,
/// Input:医嘱Rowid
/// Output:剂量(Number)
ClassMethod GetOrdDosqty(oeori As %String) As %String
{
	N (oeori)
	S ret=0
	S ord=$p(oeori,"||",1) Q:ord="" ret
 	S chl=$p(oeori,"||",2) Q:chl="" ret
	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	S:loeori'="" oeori=loeori /// 主医嘱
 	S dosqty=$P(^OEORD(ord,"I",chl,2),"^",1)
 	S DosUnit=+$p(^OEORD(ord,"I",chl,2),"^",3)
	S DosUom=""
	I $D(^CT("UOM",DosUnit)) S DosUom=$P(^CT("UOM",DosUnit),"^",2)
	Q:DosUom="" ""
	s:DosUom'="ml" dosqty=..GetDosageML(oeori)
 	s ret=+dosqty
 	;w !,ord_"||"_chl_":"_ret
 	S ord=$p(oeori,"||",1)
 	S chl=$p(oeori,"||",2)
 	S lchl="",qflag=0
 	F  S lchl=$O(^OEORDi(0,"OEORI",ord,oeori,lchl)) Q:lchl=""  D
 	.S loeori=ord_"||"_lchl
 	.S dosqty=$P(^OEORD(ord,"I",lchl,2),"^",1)
 	.;w !,ord_"||"_lchl_":"_dosqty
 	.S DosUnit=$p(^OEORD(ord,"I",lchl,2),"^",3)
 	.Q:DosUnit=""
	.S DosUom=""
	.I $D(^CT("UOM",DosUnit)) S DosUom=$P(^CT("UOM",DosUnit),"^",2)
	.Q:DosUom=""
	.S:DosUom'="ml" dosqty=..GetDosageML(loeori)
	.;w !,ord_"||"_lchl_":"_dosqty
 	.S ret=ret+(+dosqty)
 	q ret
}

/// Creator:Liang Qiang
/// CreatDate:2010-03-27
/// Description:取得关联医嘱配液分类
/// Input:医嘱Rowid
/// Output:配液分类
/// w ##class(web.DHCSTPIVA).GetPivaType("1879||22")
ClassMethod GetPivaType(oeori As %String) As %String
{
	N (oeori)
	s oeori=$p(oeori,"||",1,2)
	q ..GetPivaCatType(oeori)  //hulihua 2016-12-21 采用新的配液类别
	s pivatype=""
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	;s test=..GetOrdDosqty(oeori)
 	Q:..GetOrdDosqty(oeori)'<650 "TPN^TPN"
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	S:loeori'="" oeori=loeori /// 主医嘱
 	S itmstr=..GetIncItm(oeori)
 	s phccat=$P(itmstr,"^",4)
 	s phcsubcat=$P(itmstr,"^",6)
 	s pivatype=$$ChkType(phccat,phcsubcat)
 	Q:pivatype'="" pivatype
 	S lchl="",qflag=0
 	F  S lchl=$O(^OEORDi(0,"OEORI",ord,oeori,lchl)) Q:(lchl="")!(qflag=1)  D
 	.S loeori=ord_"||"_lchl
 	.S itmstr=..GetIncItm(loeori)
 	.s phccat=$P(itmstr,"^",4)
 	.s phcsubcat=$P(itmstr,"^",6)
 	.s pivatype=$$ChkType(phccat,phcsubcat)
 	.s:pivatype'="" qflag=1
 	.
 	i pivatype="" s pivatype="OTHER^其它"
 	Q $g(pivatype)
 	
ChkType(phccat,phcsubcat)
    s retflag=""
    s potyid="0"
    f  s potyid=$o(^PIVATY(potyid)) q:(potyid="")||(retflag'="")  d
    .s catdr=$p(^PIVATY(potyid),"^",2)
    .s subcatdr=$p(^PIVATY(potyid),"^",1)
    .q:(catdr="")&(subcatdr="")	//20151030
    .i (subcatdr'="")&(subcatdr=phcsubcat) d
    ..s subcatdesc=$p(^PHCC(+subcatdr,"SC",$p(subcatdr,"||",2)),"^",2)
    ..s retflag=subcatdr _"^"_subcatdesc
    .i (subcatdr="")&(phccat=catdr)&(catdr'="") d
    ..s phccatdesc=$p(^PHCC(catdr),"^",2)
    ..s retflag=catdr_"^"_phccatdesc
 	q retflag
}

/// Creator:Liang Qiang
/// CreatDate:2010-03-30
/// Description:在配伍审核后获取医嘱配液分类
/// Input:主医嘱rowid
/// Output:配液分类Dr_"^"_配液分类
ClassMethod GetAuditedTypeOld(oeori)
{
   n (oeori)
   s ord=+oeori
   s chl=$p(oeori,"||",2)
   s datastr=$p(^OEORD(ord,"I",chl,7),"^",3)
   s ptypedr=$p(datastr,",",5)
   Q:ptypedr="" ""
   i ptypedr["TPN" Q "TPN^TPN"
   i ptypedr["OTHER" Q "OTHER^其它"
   i $f(ptypedr,"||") d
   .i $d(^PHCC(+ptypedr,"SC",$p(ptypedr,"||",2)))  d
   ..s catdesc=$p(^PHCC(+subcatdr,"SC",$p(subcatdr,"||",2)),"^",2)
   ..s catdr=subcatdr
   i '$f(ptypedr,"||") d
   .i $d(^PHCC(ptypedr))  d
   ..s catdesc=$p(^PHCC(ptypedr),"^",2)
   ..s catdr=ptypedr
   Q $g(catdr)_"^"_$g(catdesc)
}

/// Creator:Liang Qiang
/// CreatDate:2010-03-30
/// Description:不同医院按频次或分类特殊批号处理方法
/// Input:主医嘱rowid,配液分类,医嘱频率代码,接收科室rowid,关联医嘱序号
/// Output:批次
ClassMethod GetSpecialBatNo(moeori, ptype, freqcode, ploc, seqflag)
{
	n (moeori,ptype,freqcode,ploc,seqflag)
	;沈阳QD处理 - TPN 默认3 批14:00, 非TPN 按医嘱开始时间取批次
	Q:freqcode'="QD" ""
 	s ordtime=$P(^OEORD(+moeori,"I",$p(moeori,"||",2),1),"^",10) 
 	i ptype="" d
 	.s remark=##class(web.DHCSTPIVA).GetOrdItmRemark(moeori)
 	.i remark["TPN" d
 	..s ptype="TPN"
 	i ptype="TPN" d 
 	.s ordtime=$zth("14:00",1)
 	s adm=$p(^OEORD(+moeori),"^",1)
 	s ward=$P(^PAADM(adm),"^",70)
 	s batno=##class(web.DHCSTPIVA).GetBatNo(ploc,ordtime,seqflag,ward) 
    Q batno
}

/// Description:获取配液流程
/// Creator:Liang Qiang
/// CreatDate:2010-03-31
/// Input:
/// Output:配液流程Dr_"^"_配液流程_"||"_""
/// Update：2015-10-13 修改 配液状态执行界面要执行的状态规则，必须是选择的流程，不能是排药、配置，不能是系统流程，不能是返回流程
ClassMethod GetExeStates(LocDr = "") As %String
{
	//S pynumber="30"
	//S singleflag=##class(web.DHCSTPIVA).GetPSSingleProByLoc(LocDr,pynumber)
	//S singleflag=##class(web.DHCSTPIVA).GetPSSingleProByLoc("",pynumber)
	s pro=..GetPSSingleProByLoc(LocDr,"30")
	S str=""
	S number=0
	F  S number=$o(^PIVAS(0,"NUMBER",number)) Q:number=""  D
	.s psdr=""
	.f  S psdr=$o(^PIVAS(0,"NUMBER",number,psdr)) q:psdr=""  d
	..Q:'$D(^PIVAS(psdr))
	..s psLocdr=$P(^PIVAS(psdr),"^",7)
	..q:(psLocdr'=LocDr)&(LocDr'="")
	..S pstype=$P(^PIVAS(psdr),"^",9)
	..Q:pstype'="I"
	..Q:(pro="N")&(number=30)
	..q:(number=60)	//排药和配置必须在其单独功能界面执行
	..S psflag=$P(^PIVAS(psdr),"^",3)
	..q:psflag'="Y"
	..S pssysflag=$P(^PIVAS(psdr),"^",4)
	..q:pssysflag="Y"
	..S psretflag=$P(^PIVAS(psdr),"^",5)
	..q:psretflag="Y"
 	..S psname=$P(^PIVAS(psdr),"^",2)
 	..if str="" d
 	...s str=psname_"^"_number
 	..e  d
 	...s str=str_"!!"_psname_"^"_number
 	.
 	Q str
}

/// 获取某状态的使用标识
/// Output: Y / N 
ClassMethod GetStatesUseFlag(ploc, number) As %String
{
	n (ploc,number)
	s psflag="N"
	s psdr=""
	f  S psdr=$o(^PIVAS(0,"NUMBER",number,psdr)) q:psdr=""  d
	.S locdr=$p(^PIVAS(psdr),"^",7)
 	.q:(locdr'="")&(locdr'=ploc) 
 	.S intype=$p(^PIVAS(psdr),"^",9)
 	.q:intype'="I"
 	.S psflag=$P(^PIVAS(psdr),"^",3) 
	Q psflag
}

/// Description:获取配液药品货位
/// Creator:Liang Qiang
/// CreatDate:2010-04-07
/// Input:科室ID,库存项ID
/// Output:药品货位
ClassMethod GetStkBin(ctlocdr, inci) As %String
{
 n (ctlocdr,inci)
 q:ctlocdr="" ""
 s ch=$o(^INCI("IL_LOC",ctlocdr,inci,""))
 q:inci="" ""
 q:ch="" ""
 q:'$d(^INCI(inci,"IL",ch)) ""
 //s stkbin=+$p(^INCI(inci,"IL",ch),"^",2)
 //q:'$d(^INC("SB",stkbin)) ""
 //s stkbindesc=$p(^INC("SB",stkbin),"^",2)
 s incil=inci_"||"_ch
 s stkbindesc=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
 s stkbindesc=$p(stkbindesc,":",2)
 q stkbindesc
}

/// Description:获取科室批次串
/// Creator:Liang Qiang
/// CreatDate:2010-04-11
/// Input:科室Rowid
/// Output:科室批次串
ClassMethod GetBatNoStr(LocID As %String) As %String
{
	n (LocID)
	Q:LocID="" ""
	k ^TMP("PIVA",$j,"batstr")
	S batdr=0
	F  S batdr=$o(^PIVABT(batdr)) Q:batdr=""  D
	.S locdr=$p(^PIVABT(batdr),"^",4)
	.Q:locdr'=LocID
	.S batno=$p(^PIVABT(batdr),"^",3) 
	.S ^TMP("PIVA",$j,"batstr",batno)=""
	S str=""
	S batno=""
	F  S batno=$o(^TMP("PIVA",$j,"batstr",batno)) Q:batno=""  D
	.IF str="" d
	..S str=batno
	.else  d
	..S str=str_"!!"_batno
	k ^TMP("PIVA",$j,"batstr")
	Q str
}

/// Description:核对限制分类串
/// Creator:Liang Qiang
/// CreatDate:2010-04-15
/// Input:分类串,分类ID
/// Ouput:0-不符合, 1-符合
/// 
ClassMethod CheckLimitType(typestr As %String, typeID As %String) As %String
{
	n (typestr,typeID)
	q:typestr="" 1
	s ret=0
	s cnt=$l(typestr,"^")
	f i=1:1:cnt q:ret=1  d
	.s typedr=$p(typestr,"^",i)
	.i typedr=typeID d
	..s ret=1
	Q ret
}

/// Description:获取医嘱组状态执行人与时
/// Creator:Liang Qiang
/// CreatDate:2010-04-24
/// Input:医嘱组Rowid
/// Ouput:0-不符合, 1-符合
ClassMethod GetPSUser(pog As %String) As %String
{
	N (pog)
	S ps=$P(^PIVA(pog),"^",6) /// 状态
 	Q:ps="" ""
	s pochl=$o(^PIVA(0,"PS",ps,pog,""))
	Q:pochl="" ""
	s userdr=$p(^PIVA(pog,"S",pochl),"^",3)
	s user=$p(^SSU("SSUSR",userdr),"^",2)
	s psdate=$p(^PIVA(pog,"S",pochl),"^",4)
	s:psdate'="" psdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(psdate,"PIVA")
	s pstime=$p(^PIVA(pog,"S",pochl),"^",5)
	s:pstime'="" pstime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(pstime,"PIVA")
	s psString=user_"^"_psdate_" "_pstime
	Q psString
}

/// 取病人出院状态是否退出1-是，0-否
ClassMethod IfQuitAdmStatusD(adm As %String) As %String
{
	N (adm)
	S RetFlag=0
	//Q:adm="" RetFlag
	//Q:'$D(^PAADM(adm)) RetFlag
	//S visitstatus=$P(^PAADM(adm),"^",20)
	//I visitstatus="D" S RetFlag=1
	s AdmStatus=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(adm)
	i AdmStatus=0 d
	.s RetFlag=1
	Q RetFlag
}

/// 是否有该批次
ClassMethod CheckPLocBatNo(batno As %String, ploc As %String) As %String
{
	n (batno,ploc)
	&SQL(Select PBT_BatNo  From PIVA_BatTime Where PBT_BatNo = :batno And PBT_Ctloc_Dr=:ploc)
	Q:SQLCODE 1
	Q 0
}

/// Description:取配液日期,针对不同医院可能有不同的规则,特写此方法统一归类
/// Input:主医嘱rowid,批次,医嘱优先级,打签日期,医嘱日期,频次,发药科室ID
/// Output:配液日期
/// Creator:Liang Qiang
/// CreatDate:2010-05-20
ClassMethod GetPyDate(moeori, batno, pri, printdate, odate, freq, plocdr) As %String
{
    n (moeori,batno,pri,printdate,odate,freq,plocdr)
	//配液时间规则:
	//1。默认
	S pdate=printdate
	i (pri="长期医嘱") S pdate=printdate+1  //打签日期+1
	Q pdate
	//2。省立医院南区
	//长嘱分发时间如果<规定时间,则配液日期为打签日期+1
	//如果是QD,D批的长嘱配液时间为医嘱日期+1
	S pdate=printdate
	S battime=##class(web.DHCSTPIVA).GetTimeByBatNo(plocdr,batno)
	S timeflag=##class(web.DHCSTPIVA).GetOneTime()
	i (battime<timeflag)&(pri="长期医嘱") S pdate=printdate+1 
	i (batno="D")&(freq="Qd")&(pri="长期医嘱") S pdate=odate+1
	Q pdate
}

/// Description:获取医嘱当天执行截止时间
/// Creator:Liang Qiang
/// CreatDate:2010-04-24
ClassMethod GetOneTime() As %String
{
  Q $zth("13:31:00",1) //(安徽南区)
}

/// Description:总控制是否需要配液，统一方法，有需要过滤的可以统一加载进来
/// Creator:Liang Qiang
/// CreatDate:2011-04-22
/// Input:医嘱rowid
/// Output:0 可以配液 1 不可配液  2 不判断是否配液
ClassMethod IfQuitPIVA(oeori) As %String
{
   n (oeori)
   q 2	//zhouyg 20150624 此判断不再使用
   s ret=0
   s pivaflag=##class(web.DHCSTPCHCOLLS2).IfPIVA(oeori)  ///是否配液
   //i pivaflag'=1 s ret=1
   i pivaflag=0 s ret=1
   i pivaflag=1 s ret=0
   i pivaflag=2 s ret=2	//zhouyg 20150624
   //Q:ret'=0 1
   //s mainoeori=..GetMainOeori(oeori)
   //i ##class(web.DHCSTPIVA).GetOeSeqState(mainoeori)=1  s ret=1 //关联医嘱有任一停止的都退出
   //Q:ret'=0 1
   Q ret
}

/// Description:获取批次
ClassMethod GetInclbByDsp(dsp As %String) As %String
{
	n (dsp)
	s inclb=""
	s oeori=$p(^DHCOEDISQTY(dsp),"^",1)
	s phac=""
	f  s phac=$o(^DHCPHAC(0,"PHADSP",oeori,phac)) q:phac=""  d 
	.s phachl=""
	.f  s phachl=$o(^DHCPHAC(0,"PHADSP",oeori,phac,phachl))  q:phachl=""  d
	..s dodis=$p(^DHCPHAC(phac,"I",phachl),"^",13)
	..q:dodis'=dsp 
	..s inclb=$p( ^DHCPHAC(phac,"I",phachl),"^",4)
	q inclb
}

/// Description:获取单价
ClassMethod GetPriceByDsp(dsp As %String) As %String
{
	n (dsp)
	s price=0
	s oeori=$p(^DHCOEDISQTY(dsp),"^",1)
	s phac=""
	f  s phac=$o(^DHCPHAC(0,"PHADSP",oeori,phac)) q:phac=""  d 
	.s phachl=""
	.f  s phachl=$o(^DHCPHAC(0,"PHADSP",oeori,phac,phachl))  q:phachl=""  d
	..s dodis=$p(^DHCPHAC(phac,"I",phachl),"^",13)
	..q:dodis'=dsp 
	..s inclb=$p( ^DHCPHAC(phac,"I",phachl),"^",4) 
	..s qty=$p( ^DHCPHAC(phac,"I",phachl),"^",6)
	..s price=$p( ^DHCPHAC(phac,"I",phachl),"^",9)
	q price
}

/// Description:获取单价
ClassMethod GetPhaItm(dsp As %String) As %String
{
	n (dsp)
	s phaitm=""
	s oeori=$p(^DHCOEDISQTY(dsp),"^",1)
	s phac=""
	f  s phac=$o(^DHCPHAC(0,"PHADSP",oeori,phac)) q:phac=""  d 
	.s phachl=""
	.f  s phachl=$o(^DHCPHAC(0,"PHADSP",oeori,phac,phachl))  q:phachl=""  d
	..s dodis=$p(^DHCPHAC(phac,"I",phachl),"^",13)
	..q:dodis'=dsp 
	..s phaitm=phac_"||"_phachl
	q phaitm
}

/// Description:静脉打印停止标签时是否自动执行退药
ClassMethod IfExecRet(ctloc As %String) As %String
{
	n (ctloc)
	s plrowid=$o(^DHCPL(0,"Loc",ctloc,""))
	s prtret=$p(^DHCPL(plrowid),"^",30)
	q prtret
}

/// Descript:	判断关联医嘱是否有非"V"和"E"("核实"和"执行")医嘱状态
/// Creater:	zhouyg
/// CreateDate:	2011-04-29
/// input:		moeori-主医嘱
/// Return:		有任一个的非"V"和"E"就返回1，否则0
ClassMethod GetOeSeqState(moeori As %String) As %String
{
	N (moeori)
	S ret=1
	Q:moeori="" ret
	S ord=$P(moeori,"||",1) Q:ord="" ret
	S itm=$P(moeori,"||",2) Q:itm="" ret
	Q:'$D(^OEORD(ord,"I",itm,1)) ret
	S oestate=..GetOeState(moeori)
	S oestate=$P(oestate,"^",1)
 	Q:(oestate'="V")&(oestate'="E") ret
	S gchl=0,ret=0
	F  S gchl=$o(^OEORDi(0,"OEORI",ord,moeori,gchl)) Q:(gchl="")!(ret=1)  D
 	.S toeori=ord_"||"_gchl
 	.S oestate=..GetOeState(toeori)
	.S oestate=$P(oestate,"^",1)
 	.I (oestate'="V")&(oestate'="E") d
 	..s ret=1
 	..
	Q ret
}

ClassMethod GetPAAllergyStr(PatientID As %String, DelimStr As %String) As %String
{
	N (PatientID,DelimStr)
	s retval=""
	s i=0
	Set obj=##class(%ResultSet).%New("web.PAAllergy:Find")
	d obj.Execute(PatientID,"ALG_InActive")
	For  Quit:'obj.Next()  Do
	.s Rowid=obj.Data("RowID")
	.s PhcGEname=obj.Data("PHCGEName")
	.s PhcDname=obj.Data("PHCDName")
	.S AlgDesc=obj.Data("PACALGDesc")
	.s comm=$G(^PAPER(PatientID,"ALG",$P(Rowid,"||",2),"CMT",1))
    .S Desc=AlgDesc
    .I Desc="" S Desc=PhcGEname
    .I Desc="" S Desc=PhcDname
    .I Desc="" S Desc=comm
    .Q:Desc=""
    .S Desc=$$ALPHAUP^SSUTIL4(Desc)
	.if retval="" s retval=Desc
	.e  s retval=retval_DelimStr_Desc
	d obj.Close()
	Q retval
}

/// Descript: 取备注
/// Creater:	caoting
/// CreateDate:	2011-05-10
ClassMethod GetNotes(moeori As %String) As %String
{
	N (moeori)
	Q:moeori="" ""
	S ord=$P(moeori,"||",1) Q:ord="" ""
	S itm=$P(moeori,"||",2) Q:itm="" ""
	f rnum=1:1:$G(^OEORD(ord,"I",itm,"DEP",0)) d
    .s Notes=$G(Notes)_$G(^OEORD(ord,"I",itm,"DEP",rnum))
    i $G(Notes)="" s Notes=""
    ;w "Notes"_Notes
    Q Notes
}

/// 
/// Creator:Zhouyg
/// CreatDate:2010-12-22
/// 转换为基本数量
/// Input:医嘱rowid
/// Output:基本单位数量^基本单位
ClassMethod GetDosageBUom(moeori As %String) As %String
{
	N (moeori)
	S ord=$p(moeori,"||",1) Q:ord="" ""
	S itm=$p(moeori,"||",2) Q:itm="" ""
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

/// 取主配药表记录Rowid
/// Creator:Liang Qiang
/// CreatDate:2011-03-04
ClassMethod GetMainOEDispID(DspID, SeqNo) As %String
{
	N (DspID,SeqNo)
	Q:DspID="" ""
	S oeori=$p(^DHCOEDISQTY(DspID),"^",1)
	S moeori=..GetMainOeori(oeori)
	S dspdate=$p(^DHCOEDISQTY(DspID),"^",21)
 	S ord=$p(moeori,"||",1) Q:ord="" ""
 	S chl=$p(moeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	S dsp=$o(^DHCOEDISQTY(0,"SEQNO",moeori,dspdate,SeqNo,""))
 	Q dsp
}

/// 取医嘱配药标志
/// Creator:Liang Qiang
/// CreatDate:2011-03-28
/// Input:医嘱rowid
/// Output:是否TPN 1 - 是  0 -否
ClassMethod GetOrdTPNFlag(OrderItemRowId) As %String
{
	N (OrderItemRowId)
	s flag=$p(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),"DHC"),"^",12)
	q flag
}

ClassMethod GetOperReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperReasonExecute ]
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

ClassMethod GetOperReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperReasonExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

ClassMethod GetOperReasonExecute(ByRef qHandle As %Binary, opType As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	Q:opType="" $$$OK
	s PORID=""
	f  s PORID=$o(^PIVAOR(0,"TYPE",opType,PORID)) q:PORID=""  d
	.s PORFlag=$p(^PIVAOR(PORID),"^",4)
	.q:PORFlag'="Y"
	.s PORCode=$p(^PIVAOR(PORID),"^",1)
	.s PORDesc=$p(^PIVAOR(PORID),"^",2)
	.s Data=$lb(PORDesc,PORCode,PORID)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	Quit $$$OK
}

/// Descript:	取操作的原因
/// CreateDate:	2012-04-19
/// Creater:		zhouyg
/// Input:		opType-原因类型
/// Output：		$lb(原因描述,原因代码,原因ID)
Query GetOperReason(opType As %String) As %Query(ROWSPEC = "tbPORDesc:%String,tbPORCode:%String,tbPORID:%String")
{
}

/// 2015-11=10修改添加 patcolor,病人的颜色
ClassMethod GetColorType(pano, lpano, oeflag, auditstatus, patcolor, spec)
{
	n (pano,lpano,oeflag,auditstatus,patcolor,spec)
	i pano'=lpano d
 	.i patcolor="W" s patcolor="G"
 	.e  s patcolor="W"
 	s colortype=patcolor
 	i oeflag="停止" s colortype="P"
 	i (auditstatus="SHJJ")||(auditstatus="审核拒绝") s colortype="B"
 	i spec="R" s colortype="B"
 	q colortype_"^"_patcolor
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

/// 获取安全组关联科室
/// w ##CLASS(web.DHCSTPIVA).GetWardDs("n")
ClassMethod GetWardDs(filter = "") As %String
{
	n (filter)
	s filter=$$ALPHAUP^SSUTIL4(filter)
	s pid=$I(^DHCSTPIVA("COLL"))
	s h=0
	s warddr=0
	f  s warddr=$o(^PAWARD(warddr)) q:(warddr="")||(+warddr=0)  d
	.s warddesc=$p(^PAWARD(warddr),"^",2)
	.s locdr=$p(^PAWARD(warddr),"^",5)
	.q:locdr=""
	.s contactName=$$ALPHAUP^SSUTIL4($p(^CTLOC(locdr),"^",43))
	.q:(filter'="")&&(warddesc'[filter)&&(contactName'[filter)
	.s h=h+1
    .s data=warddesc_"^"_warddr
    .s ^TMP("DHCST","DHCSTPIVA","GetWardDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPIVA","GetWardDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPIVA","GetWardDs",pid,h)
    .s warddesc=$p(data,"^",1)
    .s rowId=$p(data,"^",2)
    .s warddesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("warddesc",warddesc)
	.s rowId=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("rowId",rowId)
	.
	.s tmpstr=warddesc_rowId
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("DHCST","DHCSTPIVA","GetWardDs",pid)
	q ""
}

/// 获取药学大类列表
ClassMethod GetPhcCatDs() As %String
{
	s pid=$I(^DHCSTPIVA("COLL"))
	s h=0
	s phccr=""
	f  s phccr=$o(^PHCC(phccr)) q:phccr=""  d
	.q:+phccr=0
	.s phccatdesc=$p(^PHCC(phccr),"^",2)
	.s h=h+1
    .s data=phccatdesc_"^"_phccr
    .s ^TMP("DHCST","DHCSTPIVA","GetPhcCatDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPIVA","GetPhcCatDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPIVA","GetPhcCatDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s drugcatdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugcatdesc",desc)
	.s drugcatrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("drugcatrowid",rowid)
	.
	.s tmpstr=drugcatdesc_drugcatrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("DHCST","DHCSTPIVA","GetPhcCatDs",pid)
	q ""
}

/// 获取药学子类列表
ClassMethod GetPhcSubCatDs(catdr) As %String
{
	q:catdr="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:'$d(^PHCC(catdr,"SC")) ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s pid=$I(^DHCSTPIVA("COLL"))
	s h=0
	s chl=0
	f  s chl=$o(^PHCC(catdr,"SC",chl) ) q:(chl="")||(chl=0)  d
	.s subdesc=$p(^PHCC(catdr,"SC",chl),"^",2)
	.s rowid=catdr_"||"_chl
	.s h=h+1
    .s data=subdesc_"^"_rowid
    .s ^TMP("DHCST","DHCSTPIVA","GetPhcSubCatDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPIVA","GetPhcSubCatDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPIVA","GetPhcSubCatDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s drugsubcatdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugsubcatdesc",desc)
	.s drugsubcatrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("drugsubcatrowid",rowid)
	.
	.s tmpstr=drugsubcatdesc_drugsubcatrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("DHCST","DHCSTPIVA","GetPhcSubCatDs",pid)
	q ""
}

/// Description:构造某分类药品信息
/// Creator:LiangQiang
ClassMethod GetDrugNameDs(input, startpage, limitpage) As %String
{
	
    s endpage=startpage+limitpage
	d killtmp
	s num=0
	&sql(DECLARE curtt CURSOR FOR
	        select distinct inca_inci_dr from inc_alias 
	         where %ALPHAUP(inca_text) %STARTSWITH %ALPHAUP(:input))  
	&sql(OPEN curtt)
	f  &sql(fetch curtt into :inci )  q:SQLCODE  d
	.q:##class(web.DHCSTITMDESC).CatType(inci)'="G"
	.s num=num+1
	.s ^TMP($j,"Itmrowid",num)=inci
	.s ^TMP($j,"Itmcode",num)=$p(^INCI(inci,1),"^",1)
	.s ^TMP($j,"Itmdesc",num)=$p(^INCI(inci,1),"^",2)
	.s uomdr=$p(^INCI(inci,1),"^",10)
	.s ^TMP($j,"ItmUO",num)="" i uomdr'="" s ^TMP($j,"ItmUO",num)=$p(^CT("UOM",+uomdr),"^",2)
	.
	q:num=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s maxrow=num
	s count=0
	f i=1:1:num  d 
	. s info=##class(web.DHCSTITMDESC).ListItms(i)
	.s incirowid=$p(info,"^",1)
	.s incicode=$p(info,"^",2)
	.s incidesc=$p(info,"^",3)
	.
	.s incirowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rowId",incirowid)
	.s incicode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("itmcode",incicode)
	.s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("itmdesc",incidesc)
	.s tmpstr=incirowid_incicode_incidesc
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.Q:(count<startpage)||(count>endpage)
	.i (count=1)||(count=startpage) w startString 
	.i (count<endpage)||(count<maxrow) w firstrow 
    .i (count=endpage)||(count=maxrow) w lastrow
    d killtmp
    q ""
    
   
killtmp
   	k ^TMP($j,"Itmrowid")
	k ^TMP($j,"Itmcode")
	k ^TMP($j,"Itmdesc")
	q
}

/// 获取安全组关联科室
ClassMethod GetStockPhlocDs(grpdr) As %String
{
	n (grpdr)	
	s pid=$I(^DHCSTPIVA("COLL"))
	s h=0
	s sub=""
	f  s sub=$o(^SSU("SSGRP",grpdr,"ST",sub)) q:sub=""  d
	.s ctlocdr=$p(^SSU("SSGRP",grpdr,"ST",sub),"^",1)
	.q:ctlocdr=""
	.q:'$d(^CTLOC(ctlocdr))
	.s ctlocdesc=$p(^CTLOC(ctlocdr),"^",2)
	.s ctloctype=$p(^CTLOC(ctlocdr),"^",13)
	.q:ctloctype'="D"
	.s h=h+1
    .s data=ctlocdesc_"^"_ctlocdr
    .s ^TMP("DHCST","DHCSTPIVA","GetStockPhlocDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPIVA","GetStockPhlocDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPIVA","GetStockPhlocDs",pid,h)
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
	k ^TMP("DHCST","DHCSTPIVA","GetStockPhlocDs",pid)
	q ""
}

/// 获取科室批次集,yunhaibao20160323,添加病区id
ClassMethod GetLocBatListDs(phalocdr, warddr = "") As %String
{
	n (phalocdr,warddr)
	s pid=$I(^DHCSTPIVA("COLL"))
	s h=0
	s rowid=0
	f  s rowid=$o(^PIVABT(rowid)) q:(rowid=0)||(rowid="")  d
	.s batno=$p(^PIVABT(rowid),"^",3)
	.s locdr=$p(^PIVABT(rowid),"^",4)
	.q:locdr'=phalocdr
	.s pivawarddr=$p(^PIVABT(rowid),"^",6)
	.q:(warddr'="")&&(warddr'=pivawarddr)
	.q:(warddr="")&(pivawarddr'="")
	.s h=h+1
    .s data=batno_"^"_rowid
    .s ^TMP("DHCST","DHCSTPIVABATTIME","GetLocBatListDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPIVABATTIME","GetLocBatListDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPIVABATTIME","GetLocBatListDs",pid,h)
    .s batno=$p(data,"^",1)
    .s batnorowid=$p(data,"^",2)
    .
    .s batno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("batno",batno)
	.s batnorowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("batnorowid",batnorowid)
	.
	.s tmpstr=batno_batnorowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("DHCST","DHCSTPIVABATTIME","GetLocBatListDs",pid)
	q ""
}

ClassMethod GetAuditedType(oeori)
{
	N (oeori)
	s oeori=$p(oeori,"||",1,2)
	q ..GetPivaCatType(oeori)  //hulihua 2016-12-21 采用新的配液类别
	s pivatype=""
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	;s test=..GetOrdDosqty(oeori)
 	Q:..GetOrdDosqty(oeori)'<650 "TPN^TPN"
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	S:loeori'="" oeori=loeori /// 主医嘱
 	S itmstr=..GetIncItm(oeori)
 	s phccat=$P(itmstr,"^",4)
 	s phcsubcat=$P(itmstr,"^",6)
 	s pivatype=$$ChkType1(phccat,phcsubcat)
 	Q:pivatype'="" pivatype
 	S lchl="",qflag=0
 	F  S lchl=$O(^OEORDi(0,"OEORI",ord,oeori,lchl)) Q:(lchl="")!(qflag=1)  D
 	.S loeori=ord_"||"_lchl
 	.S itmstr=..GetIncItm(loeori)
 	.s phccat=$P(itmstr,"^",4)
 	.s phcsubcat=$P(itmstr,"^",6)
 	.s pivatype=$$ChkType1(phccat,phcsubcat)
 	.s:pivatype'="" qflag=1
 	.
 	i pivatype="" s pivatype="OTHER^其它"
 	Q $g(pivatype)
 	
ChkType1(phccat,phcsubcat)
    s retflag=""
    s potyid="0"
    f  s potyid=$o(^PIVATY(potyid)) q:(potyid="")||(retflag'="")  d
    .s catdr=$p(^PIVATY(potyid),"^",2)
    .s subcatdr=$p(^PIVATY(potyid),"^",1)
    .q:(catdr="")&(subcatdr="")	//zhouyg 20151013 
    .i (subcatdr'="")&(subcatdr=phcsubcat) d
    ..s subcatdesc=$p(^PHCC(+subcatdr,"SC",$p(subcatdr,"||",2)),"^",2)
    ..s retflag=subcatdr _"^"_subcatdesc
    .i (subcatdr="")&(phccat=catdr)&(catdr'="") d
    ..s phccatdesc=$p(^PHCC(catdr),"^",2)
    ..s retflag=catdr_"^"_phccatdesc
 	q retflag
}

/// 取配置 ,获取某病区某子类药品所属优先顺序号和强制为第几批,
/// Creator:LiangQiang
/// CreatDate:2014-04-02
ClassMethod GetWardLevNo(warid, moeori) As %String
{
	  N (warid, moeori)
	  s ordernum="",batno=""
	  s existflag=0
	  s plbatr=""
	  f  s plbatr=$o(^PIVALBAT(0,"Ward",warid,plbatr)) q:(plbatr="")||(existflag=1)  d
	  .s sub=""
	  .f  s sub=$o(^PIVALBAT(plbatr,"Itm",sub)) q:(sub="")||(existflag=1)  d
	  ..s inci=$p(^PIVALBAT(plbatr,"Itm",sub),"^",1)
	  ..s existflag=##class(web.DHCSTPIVA).ChkExItm(moeori,inci)
	  ..i existflag=1  d
	  ...s ordernum=$p(^PIVALBAT(plbatr,"Itm",sub),"^",4)
	  ...s batno=$p(^PIVALBAT(plbatr,"Itm",sub),"^",3)  
	  q ordernum_"^"_batno
}

/// 取病区容量下限和上限
/// Input:病区ID,批次号
/// Output:容量下限^上限
/// Creator:LiangQiang
/// CreatDate:2014-04-02
ClassMethod GetWardCubage(warid, batno, phaloc) As %String
{
	  n (warid, batno,phaloc)
	  s min="",max=""
	  s plbatr=""
	  f  s plbatr=$o(^PIVALBAT(0,"Ward",warid,plbatr)) q:plbatr=""  d
	  .s loc=$p(^PIVALBAT(plbatr),"^",1)
	  .
	  .q:loc'=phaloc
	  .s cusub=""
	  .f  s cusub=$o(^PIVALBATCU(plbatr,"Cub",cusub)) q:cusub=""  d
	  ..s tmpbatno=$p(^PIVALBATCU(plbatr,"Cub",cusub),"^",2)
	  ..q:tmpbatno'=batno
	  ..s max=$p(^PIVALBATCU(plbatr,"Cub",cusub),"^",1)
	  ..s min=$p(^PIVALBATCU(plbatr,"Cub",cusub),"^",3)
	  .
	  q min_"^"_max
}

/// Descript： 	根据oeori取病人ID和就诊ID
/// Creater：	zhouyg
/// CreateDate：	2015-10-30
/// Input：		医嘱ID
/// Return：		病人ID^就诊ID
ClassMethod GetPatIDByOeori(oeori As %String) As %String
{
	Q:oeori="" ""
	N (oeori)
	S paadm=..GetAdmByOeori(oeori)
	Q:paadm="" ""
	S painfo=..GetPat(paadm)
	s papmi=$p(painfo,"^",3)
	s RetStr=papmi_"^"_paadm
	Q RetStr
}

/// Descript： 	根据医嘱ID取第一条配液的配药表ID
/// Creater：	zhouyg
/// CreateDate：2015-11-03
/// Input：		医嘱ID
/// Return：	DHC_OEDispensing的ID
ClassMethod GetFDspIDByOeori(oeori As %String) As %String
{
	n (oeori)
	q:oeori="" ""
	s dispID="",retStr=""
	f  s dispID=$o(^DHCOEDISQTY(0,"OEORI",oeori,dispID)) q:(dispID="")!(retStr'="")  d
	.s dspcat=$p(^DHCOEDISQTY(dispID),"^",27)	//dspcat=0才是配液
	.q:dspcat'=0
	.s OrdExeRowid=$p(^DHCOEDISQTY(dispID),"^",3)
	.s ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
	.q:ChkOrdState'=1
	.s retStr=dispID
	q retStr
}

/// Descript:   获取执行记录的正常打包标志
/// Creater:	hulihua
/// CreateDate:	2015-07-13
/// Table:      dhc_oedispensing
/// Input:      dispid-打包表的id
/// Output:		
/// Return：    N-否,Y-是
/// w ##class(web.DHCSTPIVA).GetPlogFlag("8556")
ClassMethod GetPlogFlag(dispid) As %String
{
	n (dispid)
	q:dispid="" ""
	s PlogFlag="",Result=""
	s PlogFlag=$p(^DHCOEDISQTY(dispid),"^",28)
	s:PlogFlag="E" Result="二次打包"
	s:PlogFlag="P" Result="静配打包"
	s:PlogFlag="Y" Result="护士打包"
	s:PlogFlag="N" Result=""
	q PlogFlag_"^"_Result
}

/// Descript:	根据医嘱ID或者执行记录ID取是否为静配打包药品
/// Creater:	hulihua
/// CreateDate:	2015-09-17
/// Table:      DHC_IncItmLoc
/// Input:		医嘱ID(OE_Orditem)或者执行记录ID(OE_OrdExec)都行
/// Output:		Return
/// Return：	Y-是静配直接打包药品,N或空-不是静配直接打包药品
/// w ##class(web.DHCSTPIVA).GetPivaPack("10||5")
/// w ##class(web.DHCSTPIVA).GetPivaPack("10||5||1")
ClassMethod GetPivaPack(OeoreID) As %Library.String
{
 N (OeoreID)
 S OeoriID=$p(OeoreID,"||",1,2)
 Q:OeoriID="" ""
 Q:OeoriID="" ""
 S ord=$p(OeoriID,"||",1)
 S sub=$p(OeoriID,"||",2)
 S ArcimDr=$p($G(^OEORD(ord,"I",sub,1)),"^",2) 
 Q:ArcimDr="" ""
 S Arcsub=$p(+ArcimDr,$c(1)) 
 S Arcver=$P(ArcimDr,"||",2)
 Q:Arcsub="" ""
 Q:Arcver="" ""
 Q:'$D(^ARCIM(Arcsub,Arcver)) ""
 S Inci=$o(^INCI(0,"ARCIM_DR",Arcsub,""))
 Q:Inci="" ""
 S PhaLoc=$p($G(^OEORD(ord,"I",sub,3)),"^",6)
 S Chl=$o(^INCI("IL_LOC",PhaLoc,Inci,0))
 S Incil=Inci_"||"_Chl
 S Incilid=$o(^DHCINCIL(0,"INCIL",Incil,""))
 Q:Incilid="" ""
 S PivaPack=$P($G(^DHCINCIL(Incilid)),"^",5)
 q PivaPack
}

/// creator:	 yunhaibao
/// createdate:	 20160407
/// description: 根据科室获取减库位于哪一步骤
/// w ##class(web.DHCSTPIVA).GetDispNumberByLoc(101)
ClassMethod GetDispNumberByLoc(phaloc)
{
	n (phaloc)	
	s phaloc=+phaloc
	q:phaloc=0 0
	s retpsdispnumber="0"
	s phapsnumber=""
	f  s phapsnumber=$o(^PIVAS(0,"LOCTYPENUMBER",phaloc,"I",phapsnumber),-1) q:(phapsnumber="")||(retpsdispnumber'="0")  d
	.s phapsrowid=$o(^PIVAS(0,"LOCTYPENUMBER",phaloc,"I",phapsnumber,""),-1)
	.s phapsdisp=$p(^PIVAS(phapsrowid),"^",6)
	.i phapsdisp="Y" s retpsdispnumber=phapsnumber
	q retpsdispnumber
}

/// creator:	yunhaibao
/// createdate:	20160413
/// description:根据科室id,门诊or住院(I/O),状态代码获取配液流程状态的id
/// 			统一口径
/// w ##class(web.DHCSTPIVA).GetPivaStateId(101,"I",10)
ClassMethod GetPivaStateId(phaLoc, pivaType, phaPsNumber)
{
	n (phaLoc,pivaType,phaPsNumber)
	q:'$d(^PIVAS(0,"LOCTYPENUMBER",phaLoc,pivaType,phaPsNumber)) ""
	q $o(^PIVAS(0,"LOCTYPENUMBER",phaLoc,pivaType,phaPsNumber,""))
}

/// creator: 	yunhaibao
/// createdate:	2017-02-07
/// description: 根据执行记录获取已退数量
/// w ##class(web.DHCSTPIVA).GetReturnedQtyByOeore("")
ClassMethod GetReturnedQtyByOeore(oeoreId As %String) As %String
{
	n (oeoreId)
	s SumQty=0
	q:+oeoreId=0 0
	s DspId=""
	f  s DspId=$o(^DHCOEDISQTY(0,"OEORE",oeoreId,DspId)) q:DspId=""  d
	.s Status=$p(^DHCOEDISQTY(DspId),"^",7)
	.q:Status'="R"
	.s RetQty=$p(^DHCOEDISQTY(DspId),"^",11)
	.s SumQty=SumQty+RetQty
	q SumQty
}

/// Descript:	根据医嘱配液医嘱组主表ID判断该组液体有几条医嘱
/// Creater:	hulihua
/// CreateDate:	2016-11-23
/// Table:      PIVA_OrdGrp 关联医嘱组主表、PIVA_OrdGrpItm 关联医嘱组子表
/// Input:		pog-配液医嘱组主表ID
/// Output:		
/// Return：	该组液体的数目
/// w ##class(web.DHCSTPIVA).GetPogNum("1")
ClassMethod GetPogNum(pogstr) As %Library.String
{
	N (pogstr)
	Q:pogstr="" 0
	s pog=$p(pogstr,"^",1)
	S pogsub="0",pognum=0
	F  S pogsub=$O(^PIVA(pog,"I",pogsub)) 	Q:pogsub=""  D
	.S dsp=$p(^PIVA(pog,"I",pogsub),"^",1)
	.//S oeori=$p(^DHCOEDISQTY(dsp),"^",3)
	.//S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(oeori)
	.//Q:ChkOrdState'=1
	.S pognum=pognum+1
	Q pognum
}

/// Description:获取新的配液分类
/// Creator:	hulihua
/// CreateDate:	2016-12-21
/// Table:      PIVA_OrderLink
/// Input:				
/// Output:		
/// Return：	新的配液分类    
/// w ##class(web.DHCSTPIVA).GetPivaCat()
ClassMethod GetPivaCat() As %String
{
	s catstr=""
	s h=1
    s potyid="0"
    f  s potyid=$o(^POLI(potyid)) q:potyid=""  d
    .s catdesc=$p(^POLI(potyid),"^",1)
    .s catindex=potyid
    .i catstr="" d
    ..s catstr=catdesc_"^"_catindex
    .e  d
    ..s catstr=catstr_"!!"_catdesc_"^"_catindex
    .
    s catother="其它"_"^"_"OTHER"
    i catstr'="" d
    .s catstr=catstr_"!!"_catother
    Q catstr
}

/// Description:通过医嘱ID获取该组液体的配液分类
/// Creator:	hulihua
/// CreateDate:	2016-12-20
/// Table:      PIVA_OrderLink、PIVA_OrderLinkInstruc、PIVA_OrderLinkItm、PIVA_OrderLinkOrder
/// Input:		oeori-医嘱ID		
/// Output:		
/// Return：	液体的配液分类    
/// w ##class(web.DHCSTPIVA).GetPivaCatType("1879||22")
ClassMethod GetPivaCatType(oeori As %String) As %String
{
	N (oeori)
	s pivatype=""
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	S:loeori'="" oeori=loeori /// 主医嘱
 	s pivatype="OTHER^其它"
 	//1、先通过用法获取到关联的所有的分类串
 	q:$o(^POLI(0))="" pivatype
 	S LinkInsStr=..GetPivaCatLinkIns(oeori)
 	q:LinkInsStr="" pivatype
 	//2、再通过液体的总量过滤掉串中不符合的分类串
 	S LiquidStr=..GetPivaCatLiquidStr(oeori,LinkInsStr)
  	//3、通过包含的药品的配液分类做最终判断
 	S pid=$I(^DHCSTPIVA("PIVA","web.DHCSTPIVA"))
 	s DrugPivaCats=..GetDrugPivaCats(oeori,pid)
 	s pivatypeIDStr=..GetPivaTypeByCat(LiquidStr,DrugPivaCats,pid)
 	q:pivatypeIDStr="" pivatype
 	i pivatypeIDStr["," d
 	.s pivatypeIDStr=$p(pivatypeIDStr,",",1)
 	i pivatypeIDStr'="" d
 	.s pivatype=pivatypeIDStr_"^"_$p(^POLI(pivatypeIDStr),"^",1)
 	q pivatype
}

/// Description:通过医嘱ID获取该组液体用法关联的配液分类
/// Creator:	hulihua
/// CreateDate:	2016-12-20
/// Table:      PIVA_OrderLink、PIVA_OrderLinkInstruc
/// Input:		oeori-医嘱ID		
/// Output:		
/// Return：	该组液体用法关联的配液分类,取出医嘱用法对应的分类以及没维护用法的分类  
/// w ##class(web.DHCSTPIVA).GetPivaCatType()
ClassMethod GetPivaCatLinkIns(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S instruc=$P(^OEORD(ord,"I",itm,2),"^",7)
	Q:instruc="" ""
	S pol=0,linkstr=""
	f  s pol=$o(^POLI(pol)) q:pol=""  d
	.s polSub=$o(^POLI(pol,"S",0))
	.i polSub="" d
	..s linkstr=$s(linkstr="":pol,1:linkstr_","_pol)
	.e  d
	..i $d(^POLI(0,"INSTRUCDR",instruc,pol)) D
	...s linkstr=$s(linkstr="":pol,1:linkstr_","_pol)
	q linkstr
}

/// Description:通过医嘱ID获取该组液体总量的配液分类串
/// Creator:	hulihua
/// CreateDate:	2016-12-20
/// Table:      PIVA_OrderLink
/// Input:		oeori-医嘱ID		
/// Output:		
/// Return：	该组液体总量的配液分类串    
/// w ##class(web.DHCSTPIVA).GetPivaCatType()
ClassMethod GetPivaCatLiquidStr(oeori As %String, PivaCatStr As %String) As %String
{
	N (oeori, PivaCatStr)
	Q:oeori="" ""
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
 	S TotalLiquid=..GetOrdDosqty(oeori)
 	s PivaCatLen=$l(PivaCatStr,",")
 	s LiquidStr=""
  	F i=1:1:PivaCatLen d
  	.S PivaCat=$p(PivaCatStr,",",i)
  	.S polminvolume=+$p(^POLI(PivaCat),"^",2)
	.S polmaxvolume=+$p(^POLI(PivaCat),"^",3)
	.Q:(polminvolume=0)&&(polmaxvolume'=0)&&(TotalLiquid>polmaxvolume)	//未维护最小量的只判断最大量
	.Q:(polmaxvolume=0)&&(polminvolume'=0)&&(TotalLiquid<polminvolume)	//未维护最大量的只判断最小量
	.Q:(polminvolume'=0)&&(polmaxvolume'=0)&&((TotalLiquid>polmaxvolume)||(TotalLiquid<polminvolume))
	.S LiquidStr=$s(LiquidStr="":PivaCat,1:LiquidStr_","_PivaCat)
	Q LiquidStr
}

/// Description:通过医嘱ID获取某条医嘱所维护的药品配液类别
/// Creator:	hulihua
/// CreateDate:	2016-12-20
/// Table:      
/// Input:		oeori-医嘱ID		
/// Output:		
/// Return：	药品配液类别    
/// w ##class(web.DHCSTPIVA).GetPivaCatType()
ClassMethod GetDrugPivaCatByOe(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S arcimid=$P(^OEORD(ord,"I",itm,1),"^",2)
 	Q:arcimid="" ""
 	S arcimm=$p(arcimid,"||",1)
 	Q:arcimm="" ""
	S DrugPivaCat=##class(web.DHCST.Common.DrugInfoCommon).GetDrugPivaCat(arcimid)
	q DrugPivaCat
}

/// Description:通过主医嘱ID获取一组医嘱所维护的所有药品配液类别
/// Creator:	hulihua
/// CreateDate:	2016-12-20
/// Table:      
/// Input:		moeori-医嘱ID		
/// Output:		
/// Return：	药品配液类别    
/// w ##class(web.DHCSTPIVA).GetPivaCats(moeori)
ClassMethod GetDrugPivaCats(moeori As %String, pid As %String) As %String
{
	N (moeori,pid)
	s ord=$p(moeori,"||",1)
	q:ord="" ""
	k ^TMP("PIVA","web.DHCSTPIVA","GetDrugPivaCats",pid)
	s PivaCat=..GetDrugPivaCatByOe(moeori)
	i PivaCat'="" d
	.s ^TMP("PIVA","web.DHCSTPIVA","GetDrugPivaCats",pid,PivaCat)=""
	s ord=$p(moeori,"||",1)
	S lchl="",qflag=0
 	F  S lchl=$O(^OEORDi(0,"OEORI",ord,moeori,lchl)) Q:lchl=""  D
 	.s loeori=ord_"||"_lchl
 	.s lPivaCat=..GetDrugPivaCatByOe(loeori)
 	.q:lPivaCat=""
 	.s ^TMP("PIVA","web.DHCSTPIVA","GetDrugPivaCats",pid,lPivaCat)=""
 	s PivaCatStr=""
 	s PivaCat="0"
 	f  s PivaCat=$o(^TMP("PIVA","web.DHCSTPIVA","GetDrugPivaCats",pid,PivaCat)) q:PivaCat=""  d
 	.s PivaCatStr=$s(PivaCatStr="":PivaCat,1:PivaCatStr_","_PivaCat)
 	k ^TMP("PIVA","web.DHCSTPIVA","GetDrugPivaCats",pid)
 	q PivaCatStr
}

/// Description:通过传入的配液分类串和药品配液分类串确定最终的配液分类
/// Creator:	hulihua
/// CreateDate:	2016-12-20
/// Table:      PIVA_OrderLink、PIVA_OrderLinkItm
/// Input:		PivaTypeStr(配液类别的字符串","连接),DrugPivaCats(药品配液类别字符串","连接),pid进程号	
/// Output:		
/// Return：	该组液体药品配液分类串    
/// w ##class(web.DHCSTPIVA).GetPivaTypeByCat()
ClassMethod GetPivaTypeByCat(PivaTypeStr As %String, DrugPivaCats As %String, pid As %String) As %String
{
	n (PivaTypeStr,DrugPivaCats,pid)	
	k ^TMP("PIVA","web.DHCSTPIVA","GetPivaTypeByCat",pid)
	s RetPivaType=""
	s n=0
	s PivaTypeLen=$l(PivaTypeStr,",")
  	F i=1:1:PivaTypeLen d
  	.s polid=$p(PivaTypeStr,",",i)
  	.q:polid=""
  	.i $O(^POLI(polid,"G",0))="" d
  	..s RetPivaType=$s(RetPivaType="":"",1:RetPivaType_","_polid) //没有维护药品分类
  	.e  d
  	..s polich="0"
  	..F  S polich=$O(^POLI(polid,"G",polich))  Q:polich=""  D
  	...S pivacatdr=$p(^POLI(polid,"G",polich),"^",4)
  	...S relation=$p(^POLI(polid,"G",polich),"^",5)
  	...I (relation=2)||(relation="")  D	//2或者
  	....s n=n+1
  	....s ^TMP("PIVA","web.DHCSTPIVA","GetPivaTypeByCat",pid,"PIVACAT",polid,n)=pivacatdr
  	...E  D
  	....i $d(^TMP("PIVA","web.DHCSTPIVA","GetPivaTypeByCat",pid,"PIVACAT",polid,n)) d
  	.....S ^TMP("PIVA","web.DHCSTPIVA","GetPivaTypeByCat",pid,"PIVACAT",polid,n)=$g(^TMP("PIVA","web.DHCSTPIVA","GetPivaTypeByCat",pid,"PIVACAT",polid,n))_"^"_pivacatdr
  	....e  d
  	.....S ^TMP("PIVA","web.DHCSTPIVA","GetPivaTypeByCat",pid,"PIVACAT",polid,n)=pivacatdr
  	s polid="0"
  	F  S polid=$o(^TMP("PIVA","web.DHCSTPIVA","GetPivaTypeByCat",pid,"PIVACAT",polid))  Q:polid=""  D
  	.S h="" ,retFlag=0
  	.F  S h=$o(^TMP("PIVA","web.DHCSTPIVA","GetPivaTypeByCat",pid,"PIVACAT",polid,h))  Q:(h="")||(retFlag'=0)  D
  	..S Data=^TMP("PIVA","web.DHCSTPIVA","GetPivaTypeByCat",pid,"PIVACAT",polid,h)
  	..q:Data=""
  	..s catFlag=1
  	..S Len=$l(Data,"^")
  	..F j=1:1:Len q:catFlag'=1  d
  	...s pivaCat=$p(Data,"^",j)
  	...q:pivaCat=""
  	...s strFlag=##Class(web.DHCSTCOMMO).FindInList(DrugPivaCats,pivaCat,",") 
  	...i strFlag=0 s catFlag=0
  	..i catFlag=1 d
  	...s retFlag=1
  	.i retFlag=1 d
  	..s RetPivaType=$s(RetPivaType="":polid,1:RetPivaType_","_polid)
  	k ^TMP("PIVA","web.DHCSTPIVA","GetPivaTypeByCat",pid)
  	q RetPivaType
}

/// Description:通过传入的配液分类串和药品配液分类确定最终的配液分类
/// Creator:	hulihua
/// CreateDate:	2016-12-20
/// Table:      PIVA_OrderLink、PIVA_OrderLinkItm
/// Input:				
/// Output:		
/// Return：	该组液体药品配液分类串    
/// w ##class(web.DHCSTPIVA).ChkTypeByCat("","3")
ClassMethod ChkTypeByCat(PivaCatStr As %String, DrugPivaCat As %String, pid As %String) As %String
{
	n (PivaCatStr,DrugPivaCat,pid)
	S pivatype=""
	I PivaCatStr="" D
 	.S polid=0
 	.F  S polid=$O(^POLI(0,"PIVACAT",DrugPivaCat,polid)) Q:polid=""  D
 	..S PivaCatStr=$s(PivaCatStr="":polid,1:PivaCatStr_","_polid)
 	.
 	S retflag="",polid="",n=0
 	S PivaCatLen=$l(PivaCatStr,",")
  	F i=1:1:PivaCatLen d
  	.S polid=$p(PivaCatStr,",",i)
  	.S polich=""
  	.F  S polich=$O(^POLI(polid,"G",polich))  Q:polich=""  D
  	..S pivacatdr=$p(^POLI(polid,"G",polich),"^",4)
  	..S relation=$p(^POLI(polid,"G",polich),"^",5)
  	..I relation=2  D	//2或者
  	...S n=n+1
  	...S ^TMP("PIVA","web.DHCSTPIVA","ChkTypeByCat",pid,"PIVACAT",polid,n)=pivacatdr
  	..E  D
  	...S ^TMP("PIVA","web.DHCSTPIVA","ChkTypeByCat",pid,"PIVACAT",polid,n)=^TMP("PIVA","web.DHCSTPIVA","ChkTypeByCat",pid,"PIVACAT",polid,n)_"^"_pivacatdr
  	..
  	.
  	
  	S polid="",pivatype=""
  	F  S polid=$o(^TMP("PIVA","web.DHCSTPIVA","ChkTypeByCat",pid,"PIVACAT",polid))  Q:polid=""  D
  	.S h=0,ret=0
  	.F  S h=$o(^TMP("PIVA","web.DHCSTPIVA","ChkTypeByCat",pid,"PIVACAT",polid,h))  Q:(h="")||(ret'=0)  D 
  	..S Data=^TMP("PIVA","web.DHCSTPIVA","ChkTypeByCat",pid,"PIVACAT",polid,h)
  	..S Len=$l(Data,"^")
  	..F j=1:1:Len d
  	...Q:ret'=0
  	...S pivacat=$p(Data,",",j)
  	...I DrugPivaCat=pivacat D
  	....S ret=1
  	....S pivatype=$s(pivatype="":polid,1:pivatype_","_polid)
  	..
  	.
  	Q:pivatype="" PivaCatStr
  	Q pivatype
}

/// Description:根据配置主表的Rowid取到收费医嘱串，可能是多个以"^"分隔
/// Creator:	hulihua
/// CreateDate:	2016-12-21
/// Table:      PIVA_OrderLink、PIVA_OrderLinkItm
/// Input:		oe_orditm				
/// Output:		
/// Return：	收费医嘱串   
/// w ##class(web.DHCSTPIVA).GetPivaOrdLink("386063||1723")
ClassMethod GetPivaOrdLink(moeori) As %String
{
	 n (moeori)
	 s ord=$P(moeori,"||")
	 S chl=$P(moeori,"||",2)
	 Q:'$D(^OEORD(ord,"I",chl,1)) ""
	 //配液分类
	 s ptypestr=##class(web.DHCSTPIVA).GetAuditedType(moeori)
	 s typeID=$p(ptypestr,"^",1)
	 s pol=typeID,retstr=""
	 s sub="0"
	 f  s sub=$o(^POLI(pol,"M",sub)) q:sub=""  d
     .s arci=$p(^POLI(pol,"M",sub),"^",1)
     .s qty=$p(^POLI(pol,"M",sub),"^",4)
     .s:+$g(qty)=0 qty=1
     .i retstr="" d
     ..s retstr=arci_"@"_qty
     .e  d
     ..s retstr=retstr_"^"_arci_"@"_qty
	 .
	 q $g(retstr)
}

/// Description:通过配液主表ID组合配液中心的医嘱优先级
/// Creator:	hulihua
/// CreateDate:	2017-01-19
/// Table:      
/// Input:		pog-配液主表ID
/// Output:
/// Return：    组合配液中心医嘱优先级
/// Others:
/// w ##class(web.DHCSTPIVA).GetPogPriority("5647")
ClassMethod GetPogPriority(pog As %String) As %String
{
	N (pog)
	Q:pog="" 0
	s ret=""
	S sub="0"
	F  S sub=$O(^PIVA(pog,"I",sub)) Q:sub=""  D
	.S dsp=$P(^PIVA(pog,"I",sub),"^",1) 
	.Q:dsp=""
	.Q:'$D(^DHCOEDISQTY(dsp))
	.S oeori=$P(^DHCOEDISQTY(dsp),"^",1) 
	.Q:oeori=""
	.S pri=..GetOePriority(oeori)	/// 优先级
	.s prcode=$P(pri,"^",2)	
	.S pri=$P(pri,"^",3)
	.Q:(ret'="")&&(ret[pri)
	.S ret=$s(ret="":pri,1:ret_","_pri)
	S:(ret="临时医嘱,自备药即刻")||(ret="自备药即刻,临时医嘱") ret="临时+自备药即刻"
	q ret
}

/// Descript:   根据医嘱ID和打包表ID获取该记录是第几天用药
/// Creator:	hulihua
/// CreateDate:	2016-11-17
/// Table:      OE_OrdItem,dhc_oedispensing
/// Input:      oeori-医嘱ID,moedisp-打包表的id
/// Output:		
/// Return：    当前用药第几天数
/// w ##class(web.DHCSTPIVA).GetDayNumByOeori("8556")
ClassMethod GetDayNumByOeori(oeori As %String, moedisp As %String) As %String
{
	N (oeori, moedisp)
	Q:oeori="" ""
	S startdsp=..GetFDspIDByOeori(oeori)
	S startdate=$p(^DHCOEDISQTY(startdsp),"^",21)
	S enddate=$p(^DHCOEDISQTY(moedisp),"^",21)
	S intervalday=enddate-startdate
	Q:intervalday=0 ""
	S ord=$P(oeori,"||",1) 
	Q:ord="" ""
 	S chl=$P(oeori,"||",2) 
 	Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,2)) ""
 	S freq=$P(^OEORD(ord,"I",chl,2),"^",4)
 	Q:freq="" ""
 	Q:'$D(^PHCFR(freq)) ""
 	S freqday=+$P(^PHCFR(freq),"^",5)
 	Q:freqday=0 ""
 	S inday=intervalday/freqday
    S:$F(inday,".") inday=$p(inday,".",1)+1
 	Q inday
}

/// w ##class(web.DHCSTPIVA).GetStateUser(127184,40)
ClassMethod GetStateUser(pog, cnumber)
{
	n (pog,cnumber)
	q:$g(pog)="" ""
	q:$g(cnumber)="" ""
	s ps=$O(^PIVAS(0,"NUMBER",cnumber,""))
	q:ps="" ""
	s chl=$o(^PIVA(0,"PS",ps,pog,""))
	q:chl="" ""
	s user=$p(^PIVA(pog,"S",chl),"^",3)
	i user'="" s user=$p(^SSU("SSUSR",user),"^",2)
	q user
}

/// 判断是不是新医嘱
ClassMethod CheckIfFristRecord(dsp)
{
	n (dsp)
	q:dsp="" 0
	s oeori=$p(^DHCOEDISQTY(dsp),"^",1)
	s dosdate=$p(^DHCOEDISQTY(dsp),"^",21)
	s sttdate=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),1),"^",9)
	q:dosdate=(sttdate+1) 1
	q 0
}

/// 获取标签标识
ClassMethod GetPogLabelSign(mdodis)
{
	n (mdodis)
	q:$g(mdodis)="" ""
	s PivaLabelSignDesc=""
	s dspstr=$g(^DHCOEDISQTY(+mdodis))
	q:dspstr="" ""
	s recloc=$p(dspstr,"^",24)
	s oeori=$p(dspstr,"^",1)
	s DrugInfo=..GetDrugInfoByOeori(oeori)
	s PivaLabelSign=$p(DrugInfo,3)
	s:PivaLabelSign'="" PivaLabelSignDesc=$p($g(^DHCSTSCDI(PivaLabelSign)),"^",2)
	i PivaLabelSignDesc="" s PivaLabelSignDesc=..GetOeoriSign(oeori)
	/// 子医嘱未打包判断
 	S gchl="",ord=+oeori
 	F  S gchl=$O(^OEORDi(0,"OEORI",ord,oeori,gchl)) q:(gchl="")!(PivaLabelSignDesc'="")  d
 	.s goeori=ord_"||"_gchl
 	.s dsp=$o(^DHCOEDISQTY(0,"OEORI",goeori,""))
 	.q:dsp=""
 	.s DrugInfo=..GetDrugInfoByOeori(goeori)
	.s PivaLabelSign=$p(DrugInfo,"^",3)
	.s:PivaLabelSign'="" PivaLabelSignDesc=$p($g(^DHCSTSCDI(PivaLabelSign)),"^",1)
	.i PivaLabelSignDesc="" s PivaLabelSignDesc=..GetOeoriSign(goeori)
	q PivaLabelSignDesc
}

/// 获取医嘱标识
ClassMethod GetOeoriSign(oeori)
{
	n (oeori)
	s ord=+oeori,itm=$p(oeori,"||",2)
	S arcitm=$P(^OEORD(ord,"I",itm,1),"^",2)
 	Q:arcitm="" ""
 	s arcsub=+arcitm,arcver=+$p(arcitm,"||",2)
	s PhcdRowid=$p(^ARCIM(arcsub,arcver,1),"^",12)
	s phcd=+PhcdRowid,phcdfsub=$p(PhcdRowid,"||",2)
	Q:phcd=0 ""
	s formdr=$p(^PHCD(+PhcdRowid,"DF",phcdfsub,1),"^",1)
	s phcdfeinfo=^PHCD(+PhcdRowid,"DF",phcdfsub,"DHC")
	s CriticalFlag=$p(phcdfeinfo,"^",9)
	q:CriticalFlag="Y" "▲"
	q ""
}

ClassMethod GetDrugInfoByOeori(oeori)
{
	n (oeori)
	q:$g(oeori)="" ""
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
 	s recloc=$P(^OEORD(ord,"I",itm,3),"^",6)
 	q:recloc="" ""
 	s incilsub=$o(^INCI("IL_LOC",recloc,inci,""))
 	s incil=inci_"||"_incilsub
 	s rowid=$o(^PIVAD(0,"INCIL",incil,""))
 	q:rowid="" ""
	s PivaDrugCat=$p(^PIVAD(rowid),"^",7)
	s PivaStoreCond=$p(^PIVAD(rowid),"^",8)
	s PivaLabelSign=$p(^PIVAD(rowid),"^",9)
	s PivaDrugUse=$p(^PIVAD(rowid),"^",10)
	s DrugInfo=PivaDrugCat_"^"_PivaStoreCond_"^"_PivaLabelSign_"^"_PivaDrugUse
	q DrugInfo
}

/// 获取标签分类分仓
ClassMethod GetPogDrugCat(mdodis)
{
	n (mdodis)
	q:$g(mdodis)="" ""
	s PivaDrugCatDesc=""
	s dspstr=$g(^DHCOEDISQTY(+mdodis))
	q:dspstr="" ""
	s recloc=$p(dspstr,"^",24)
	s oeori=$p(dspstr,"^",1)
	s DrugInfo=..GetDrugInfoByOeori(oeori)
	s PivaDrugCat=$p(DrugInfo,1)
	s:PivaDrugCat'="" PivaDrugCatDesc=$p($g(^DHCSTSCDI(PivaDrugCat)),"^",2)
	/// 子医嘱未打包判断
 	S gchl="",ord=+oeori
 	F  S gchl=$O(^OEORDi(0,"OEORI",ord,oeori,gchl)) q:(gchl="")!((PivaDrugCatDesc'="")&&((PivaDrugCatDesc'="P")))  d
 	.s goeori=ord_"||"_gchl
 	.s dsp=$o(^DHCOEDISQTY(0,"OEORI",goeori,""))
 	.q:dsp=""
 	.s DrugInfo=..GetDrugInfoByOeori(goeori)
	.s PivaDrugCat=$p(DrugInfo,"^",1)
	.s:PivaDrugCat'="" PivaDrugCatDesc=$p($g(^DHCSTSCDI(PivaDrugCat)),"^",1)
	.;b
	q PivaDrugCatDesc
}

ClassMethod GetPogStoreCond(pog)
{
	n (pog)
	s StoreCond=""
	S pogsub=0
	F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	.s dsp=$p(^PIVA(pog,"I",pogsub),"^",1)
	.s oeori=$p(^DHCOEDISQTY(dsp),"^",1)
	.s DrugInfo=..GetDrugInfoByOeori(oeori)
	.s PivaStoreCond=$p(DrugInfo,"^",2)
	.i StoreCond="" s StoreCond=PivaStoreCond
	.e  s StoreCond=StoreCond_","_PivaStoreCond
	q StoreCond
}

ClassMethod GetItmDesc(inci)
{
	n (inci)
	q:inci="" ""
	q:'$d(^INCI(inci,1)) ""
	s genestr=##Class(web.DHCST.Common.DrugInfoCommon).GetGene(inci)
    s incidesc=$p(genestr,"^",2)
    i incidesc="" d
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.s:incidesc["[" incidesc=$p(incidesc,"[",1) 
	s goodname=##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(inci)
	i goodname'="" d
	.s incidesc=incidesc_"-"_goodname
	e  d
	.s manfstr=##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci)
	.s manfdesc=$p(manfstr,"^",3)
	.s manfdesc=$tr(manfdesc,"""")
	.i manfdesc["-" s manfdesc=$p(manfdesc,"-",2)
	.i $l(manfdesc)>4 s manfdesc=$e(manfdesc,1,4)
	.s incidesc=incidesc_"-"_manfdesc_""
	q incidesc
}

ClassMethod GetSkinTestNew(oeori As %String) As %String
{
	N (oeori)
	s ord=+oeori
	s itm=$p(oeori,"||",2)
	s result=..GetSkinTest(oeori)
	q:result'="" result
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),""))
	q:inci="" result
 	Q result
}

/// 取皮试结果
ClassMethod GetSkinTest(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" -1
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,5)) ""
	S SkinTestFlag=$P(^OEORD(ord,"I",itm,5),"^",2)
	I SkinTestFlag'="Y" D
	.S result=""
	E  D
	.S abnormal=$P(^OEORD(ord,"I",itm,11),"^",3)
	.S actiondr=$P(^OEORD(ord,"I",itm,11),"^",21)
	.I abnormal="N"  S result=1 
	.E  D
	..S result=-6 //未结果
	..i abnormal="Y" S result=-1  
	..I actiondr=1 S result=-5 //原液
	..I actiondr=2 S result=10  //免试
	s:result="-6" result="未结果"
	s:result="-5" result="原液"
	s:result="10" result="免试"
	s:result="1" result="阴性"
	s:result="-1" result="阳性"
	Q result
}

/// 根据医嘱id获取滴速
ClassMethod GetSpeedFlow(oeori)
{
	n (oeori)
	s ord=+oeori,chl=$p(oeori,"||",2)
	s SpeedFlowRate=$p($g(^OEORD(ord,"I",chl,3)),"^",17)
	i SpeedFlowRate'="" d
	.s FlowRateUnit=""
	.s FlowRateUnitDR=$p($g(^OEORD(ord,"I",chl,6)),"^",8)
	.i FlowRateUnitDR'="" s FlowRateUnit=$p($g(^OEC("SFR",FlowRateUnitDR)),"^",2)
	.s:FlowRateUnit'="" SpeedFlowRate=SpeedFlowRate_" "_FlowRateUnit
	q SpeedFlowRate
}

Storage Default
{
<Data name="DHCSTPIVADefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTPIVAD</DataLocation>
<DefaultData>DHCSTPIVADefaultData</DefaultData>
<IdLocation>^web.DHCSTPIVAD</IdLocation>
<IndexLocation>^web.DHCSTPIVAI</IndexLocation>
<StreamLocation>^web.DHCSTPIVAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

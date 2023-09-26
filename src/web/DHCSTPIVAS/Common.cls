Import SQLUser

Include (PHA.COM.Base, web.DHCSTPIVAS.Base)

/// Description: 配液公共类
Class web.DHCSTPIVAS.Common Extends %RegisteredObject
{

/// 后台的多语言翻译
/// w ##class(web.DHCSTPIVAS.Common).Get("开始日期")
ClassMethod Get(item)
{
    s $zt = "Error"
    q ##class(PHA.COM.Base).Get(item)
Error
    s $zt = ""
    q item
}

/// creator:     yunhaibao
/// createdate:  2018-03-12
/// description: 配液中心生成单号
/// input:       stateName(流程名称)
/// others:      固定格式S10L1P20180503001,S+流程标识+L+科室Id+P+日期+流水号(3位)
/// w ##class(web.DHCSTPIVAS.Common).GetAppNo("50","101")
ClassMethod GetAppNo(stateNumber, locId)
{
    s lockRet=..Lock("GetAppNo",locId)
    q:lockRet<0 "-1^加锁失败"
    s appNo=##class(web.DHCST.Common.AppCommon).GetAppNo("DHCSTINPIVA","",locId)
    //s dataPre=$zd(+$h,8)
    //s preFix="S"_stateNumber_"L"_locId_"P"_dataPre
    //s appNo=preFix
    d ..UnLock("GetAppNo",locId)
    s appNo="S"_stateNumber_appNo
    q appNo
}

/// ##class(web.DHCST.Common.AppCommon).GetAppNo("DHCSTINREQ",1,100)
/// creator:     yunhaibao
/// createdate:  2018-03-08
/// description: 配液中心加锁
/// input:       lockName(表名),lockId(表Id)
/// output:      0(成功)非0(失败)
/// w ##class(web.DHCSTPIVAS.Common).Lock("DHCOEDispensing","1239847")
ClassMethod Lock(lockName, lockId)
{
    q:(lockName="")||(lockId="") ""
    l +^DHCSTPIVAS(lockName,lockId):2 e  q -1_"^"_"加锁失败"
    q 0
}

/// creator:     yunhaibao
/// createdate:  2018-03-08
/// description: 配液中心解锁
/// w ##class(web.DHCSTPIVAS.Common).UnLock("DHCOEDispensing","1239847")
ClassMethod UnLock(lockName, lockId)
{
    q:(lockName="")||(lockId="") ""
    l -^DHCSTPIVAS(lockName,lockId)
    q 0
}

/// description: 获取病人登记号长度
ClassMethod PatRegNoLen()
{
    s patNoLen=$p($g(^CF("PATCF",1,3)),"^",5)
    q patNoLen
}

/// description: 入参分割
ClassMethod Split()
{
    q "|@|"
}

/// description: 获取对应科室的所有批次
/// w ##class(web.DHCSTPIVAS.Common).PivasLocBatList(250)
ClassMethod PivasLocBatList(pivasLoc) As %String
{
    s retString=""
    s pbtId=0
    f  s pbtId=$o(^PIVABT(pbtId)) q:(pbtId=0)||(pbtId="")  d
    .s pbtLocDr=$p(^PIVABT(pbtId),"^",4)
    .q:pbtLocDr'=pivasLoc
    .s wardDr=$p(^PIVABT(pbtId),"^",6)
    .q:wardDr'=""
    .s batNo=$p(^PIVABT(pbtId),"^",3)
    .s PivasLocBatListArr(batNo)=pbtId_","_batNo
    s batNo=""
    f  s batNo=$o(PivasLocBatListArr(batNo)) q:batNo=""  d
    .s batData=PivasLocBatListArr(batNo)
    .i retString="" d
    ..s retString=batData
    .e  d
    ..s retString=retString_"^"_batData
    q retString
}

/// description: 获取对应配液中心的所有流程+停止
/// w ##class(web.DHCSTPIVAS.Common).PivasLocStateList(101)
ClassMethod PivasLocStateList(pivasLoc) As %String
{
    s retString=""
    s psNumber=""
    f  s psNumber=$o(^PIVAS(0,"LOCTYPENUMBER",pivasLoc,"I",psNumber)) q:psNumber=""  d
    .s psId=""
    .f  s psId=$o(^PIVAS(0,"LOCTYPENUMBER",pivasLoc,"I",psNumber,psId)) q:psId=""  d
    ..s psUse=$p(^PIVAS(psId),"^",3)
    ..q:psUse'="Y"
    ..s psRet=$p(^PIVAS(psId),"^",5)
    ..q:psRet="Y"
    ..s psDesc=$p(^PIVAS(psId),"^",2)
    ..s psStateData=psId_","_psNumber_","_psDesc
    ..s retString=$s(retString="":psStateData,1:retString_"^"_psStateData)
    q retString
}

/// description: 获取主医嘱Id
/// w ##class(web.DHCSTPIVAS.Common).GetMainOeori("2927||173")
ClassMethod GetMainOeori(oeori As %String) As %String
{
    Q:oeori="" ""
    S ordId=$p(oeori,"||",1) Q:ordId="" ""
    S ordItm=$p(oeori,"||",2) Q:ordItm="" ""
    Q:'$D(^OEORD(ordId,"I",ordItm,1)) ""
    //Q:'$D(^OEORD(ordId,"I",ordItm,11)) ""
    S linkOeori=$P($g(^OEORD(ordId,"I",ordItm,11)),"^",39)
    Q:linkOeori'="" linkOeori
    Q oeori
}

/// description: 获取打包表对应主医嘱的该用药日期轮次打包Id
/// w ##class(web.DHCSTPIVAS.Common).GetMainDspId(480840,1)
ClassMethod GetMainDspId(dspId, seqNo = "") As %String
{
    Q:dspId="" ""
    s oeore = $p(^DHCOEDISQTY(dspId),"^",3)
    s mOeore = ..GetMainOeore(oeore)
    s mDsp = $o(^DHCOEDISQTY(0,"OEORE",mOeore,""))
    q:mDsp="" dspId
    q mDsp
}

/// description: 获取等效单位中最小单位第一个单位的剂量的数量
/// ##class(web.DHCSTPIVAS.Common).GetDoseEqualQty()
ClassMethod GetDoseEqualQty(oeori) As %String
{
    S ord=$p(oeori,"||",1) Q:ord="" ""
    S itm=$p(oeori,"||",2) Q:itm="" ""
    Q:'$D(^OEORD(ord,"I",itm,1)) ""
    Q:'$D(^OEORD(ord,"I",itm,2)) ""
    S doseQty=$P(^OEORD(ord,"I",itm,2),"^",1) //剂量
    S doseUom=$p(^OEORD(ord,"I",itm,2),"^",3)
    S arcItm=$p(^OEORD(ord,"I",itm,1),"^",2)
    S arcVer=$P(arcItm,"||",1)
    Q:arcVer="" ""
    S arcSub=$P(arcItm,"||",2)
    Q:arcSub="" ""
    Q:'$D(^ARCIM(arcVer,arcSub,1)) ""
    S phcdfRowId=$P(^ARCIM(arcVer,arcSub,1),"^",12)
    S phcdId=$P(phcdfRowId,"||",1)
    Q:phcdId="" ""
    S phcdSub=$P(phcdfRowId,"||",2)
    Q:phcdSub="" ""
    S bUomId=$P(^PHCD(phcdId,"DF",phcdSub,2),"^",4)
    s eqSub="0",eqQty=""
    f  s eqSub=$O(^PHCD(phcdId,"DF",phcdSub,"EQ",eqSub)) q:(eqSub="")||(eqQty'="")  d
    .q:eqQty'=""
    .S eqUomDr=$P(^PHCD(phcdId,"DF",phcdSub,"EQ",eqSub),"^",1)
    .s eqQty=+$P(^PHCD(phcdId,"DF",phcdSub,"EQ",eqSub),"^",2) 
    s retQty=""
    i doseUom=bUomId s retQty=eqQty*doseQty
    e  s retQty=doseQty
    q retQty
}

/// description: 获取静配中心在处方点评方式中的ID
ClassMethod PivasWayCode()
{
    q $o(^DHCPCWAY(0,"Code","PIVAS",""))
}

/// description: 获取静配中心在药房配置中的统计日期
/// input:       locId-科室id,num-字段位置
/// w ##class(web.DHCSTPIVAS.Common).GetPhaSetDate("","")
ClassMethod GetPhaSetDate(locId, num)
{
    s curDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h)
    q:(locId="")||(num="") curDate
    s phaLocId=$o(^DHCPL(0,"Loc",locId,""))
    q:phaLocId="" curDate
    s configDate=$p(^DHCPL(phaLocId),"^",num)
    q:configDate="" curDate
    q ##class(web.DHCSTKUTIL).GetDate("","",configDate)
}

/// description: 验证病区是否属于该科室组
/// input:       科室组id,病区id
/// return:      1-符合条件
/// w ##class(web.DHCSTPIVAS.Common).CHeckLocGrp(locGrp,wardId)
ClassMethod CheckLocGrp(locGrpId, wardId)
{
    q:(locGrpId="")||(wardId="") 1
    s ret=0
    s slgSub=""
    f  s slgSub=$o(^DHCSLG(locGrpId,"I",slgSub)) q:(slgSub="")||(ret=1)  d
    .s wardLocDr=$p(^DHCSLG(locGrpId,"I",slgSub),"^",1)
    .s wardDr=$o(^PAWARD(0,"WARD_LocationDR",wardLocDr,""))
    .i wardId=wardDr d
    ..s ret=1
    q ret
}

/// creator:    yunhaibao
/// createdate: 2017-12-04
/// description:根据主医嘱ID获取当前配伍审核状态,医嘱审核表最后一条记录
///             n+1日期的记录以最后用药日期审核为准
/// input:      mOeori(主医嘱Id),mOeoriDate(用药日期),auditTimes(需审核的天数)
/// return:     结果代码(仅SHTG\SHJJ代表能否继续下一流程)^结果名称^Id^结果代码标识(YNASD)
/// w ##class(web.DHCSTPIVAS.Common).GetOrdPassState("156||30","65364","1","")
ClassMethod GetOrdPassState(mOeori, mOeoriDate = "", auditTimes = "", pivaLocId = "")
{
    q:mOeori="" ""
    s validDate=""
    i auditTimes'="" d
    .i auditTimes="1"  s validDate=""   // 审新医嘱
    .e  d
    ..s lastDate=..GetDoseDateByTimes(mOeori,auditTimes,pivaLocId)  
    ..i mOeoriDate>lastDate  s validDate=lastDate       // 审核前n天,则之后以第n天为审核依据
    ..e  s validDate=mOeoriDate
    e  s validDate=""
    s phaOrd=..GetValidPhaOrdId(mOeori,validDate)
    q:phaOrd="" ""
    q ..GetPhaOrdResult(phaOrd)
}

/// creator:    yunhaibao
/// createdate: 2017-12-14
/// description:根据审核表id获取拒绝原因,按原因id顺序,避免顺序不同
/// w ##class(web.DHCSTPIVAS.Common).GetOrdPassReason("9230")
ClassMethod GetOrdPassReason(phaOrd, delim = "") As %String
{
    q:phaOrd="" ""
    s reasonStr=""
    s phaOrdItm=""
    f  s phaOrdItm=$o(^DHCPHORDM(phaOrd,"I",phaOrdItm)) q:phaOrdItm=""  d
    .q:+phaOrdItm=0
    .s reasonDr=$p(^DHCPHORDM(phaOrd,"I",phaOrdItm),"^",3)
    .q:reasonDr=""
    .s GetOrdPassReasonArr(reasonDr)=""
    s reasonI=0,reasonDr=""
    f  s reasonDr=$o(GetOrdPassReasonArr(reasonDr)) q:reasonDr=""  d
    .s reasonI=reasonI+1
    .s reasonDesc=reasonI_"."_##class(PHA.COM.Data.Base).CNTSReasonDesc(reasonDr)
    .s reasonStr=$s(reasonStr="":reasonDesc,1:reasonStr_delim_reasonDesc)
    q reasonStr
}

/// description: 取病人出院状态是否退出
/// return:      1-是 0-否
ClassMethod IfQuitAdmStatusD(admId As %String) As %String
{
    S retFlag=0
    s admStatus=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(admId)
    i admStatus=0 d
    .s retFlag=1
    Q retFlag
}

/// descripiton: 医嘱子类
/// output:      id^代码^名称^类型
ClassMethod GetArcItmCatByOeori(oeori As %String) As %String
{
    Q:oeori="" ""
    S ord=$p(oeori,"||",1) Q:ord="" ""
    S itm=$p(oeori,"||",2) Q:itm="" ""
    Q:'$D(^OEORD(ord,"I",itm,1)) ""
    S arcItmId=$P(^OEORD(ord,"I",itm,1),"^",2)
    Q:arcItmId="" ""
    s arcItmCatStr=..GetArcItmCat(arcItmId)
    q arcItmCatStr
}

/// descripiton: 医嘱子类
/// w ##class(web.DHCSTPIVAS.Common).GetArcItmCat("1||1")
ClassMethod GetArcItmCat(arcItm As %String) As %String
{
    s pIndex = $lb("GetArcItmCat", arcItm), ret = "" 
    q:($d($$$PIVASVAR(pIndex), ret)) ret
    
    try{
        
        s arcVer = +$p(arcItm, "||", 1)
        s arcSub = +$p(arcItm, "||", 2)
        s arcItmCatId = $p($g(^ARCIM(arcVer, arcSub, 1)), "^", 10)
        q:(arcItmCatId = "")
        s data = $g(^ARC("IC",arcItmCatId))
        s arcItmCatCode = $p(data, "^", 1)
        s arcItmCatDesc = $p(data, "^", 2)
        s arcItmCatType = $p(data, "^", 7)
        s ret = $lts($lb(arcItmCatId, arcItmCatCode, arcItmCatDesc, arcItmCatType), "^")
    }catch(e){
    }
    s $$$PIVASVAR(pIndex) = ret
    q ret
}

/// description: 医嘱状态
/// w ##class(web.DHCSTPIVAS.Common).OeoriStat("27||1216")
ClassMethod OeoriStat(oeori As %String) As %String
{
    q:($d(^oddCOM("PHA.COM.Order", "m", "OeoriStat"))) ##class(PHA.COM.Order).OeoriStat(oeori)
    S oeStateId=$P($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",13)
    Q:oeStateId="" ""
    S oeStateCode=$P($g(^OEC("OSTAT",+oeStateId)),"^",1)
    S oeStateDesc=$P($g(^OEC("OSTAT",+oeStateId)),"^",2)
    Q oeStateCode_"^"_oeStateDesc
}

/// description: 验证执行记录状态是否为可发
ClassMethod CheckOeoreStat(oeore)
{
    q ##class(web.DHCSTCOMMONSRV).GetOrdState(oeore)
}

/// description: 获取医嘱的第一条打包记录
/// ##class(web.DHCSTPIVAS.Common).GetFirstDspIdByOeori
ClassMethod GetFirstDspIdByOeori(oeori As %String) As %String
{
    q:oeori="" ""
    s dispId="",firstDspId=""
    f  s dispId=$o(^DHCOEDISQTY(0,"OEORI",oeori,dispId)) q:(dispId="")!(firstDspId'="")  d
    .s dspCatCode=$p(^DHCOEDISQTY(dispId),"^",27)   //dspcat=0才是配液
    .q:dspCatCode'=0
    .s firstDspId=dispId
    q firstDspId
}

/// description: 验证是否护士已审核,按主医嘱
/// return:      1/0
/// ##class(web.DHCSTPIVAS.Common).NurseAudit
ClassMethod NurseAudit(mOeori)
{
   s mDspId=..GetFirstDspIdByOeori(mOeori)
   q:mDspId="" 0
   s auditRet=##Class(web.DHCSTCOMMONSRV).IfAuditByPriority(mDspId)
   q auditRet
}

/// description: 获取成组医嘱的配液大类
/// return:      多个配液分类以"^"分割
/// w ##class(web.DHCSTPIVAS.Common).GetOrdPivaCat("180||767")
ClassMethod GetOrdPivaCat(oeori)
{
    s ordPivaCat=""
    s mOeori=..GetMainOeori(oeori)
    Q:mOeori="" ""
    s ordPivaCat="^"
    //1.先通过用法获取到关联的所有的分类串
    q:$o(^POLI(0))="" ordPivaCat
    S instrPivaCats=..GetInstructPivaCats(mOeori) 
    q:instrPivaCats="" ordPivaCat
    //2.再通过液体量年龄等筛选不符合的分类串
    S singlePivaCats=..GetLinkSinglePivaCats(mOeori,instrPivaCats)
    //3.通过包含的药品的配液分类做最终判断
    s drugPivaCats=..GetDrugPivaCats(mOeori)
    s ordPivaCats=..GetFinalPivaCat(singlePivaCats,drugPivaCats)
    q:ordPivaCats="" ordPivaCat
    s catsLen=$l(ordPivaCats,",")
    s catsI=""
    f catsI=1:1:catsLen d
    .s catId=$p(ordPivaCats,",",catsI)
    .q:catId=""
    .s catOrdNum=+$p($g(^POLI(catId)),"^",4)
    .i ('$d(^POLI(catId,"G")))&&('$d(^POLI(catId,"S"))) s catOrdNum=catOrdNum+1000
    .s GetOrdPivaCatData(catOrdNum)=catId
    s ordCatNum=$o(GetOrdPivaCatData(""))
    q:ordCatNum="" ordPivaCat
    s ordCatId=$g(GetOrdPivaCatData(+ordCatNum))
    s POLI=$g(^POLI(+ordCatId))
    q ordCatId_"^"_##class(PHA.PIVAS.Data.Base).PIVAOrderLinkDesc(ordCatId)_"^"_$p(POLI,"^",5)
}

/// description: 该组液体用法关联的配液分类    
/// w ##class(web.DHCSTPIVAS.Common).GetInstructPivaCats("1176||481")
ClassMethod GetInstructPivaCats(mOeori As %String) As %String
{
    Q:mOeori="" ""
    S instruct=$P($g(^OEORD(+mOeori,"I",+$p(mOeori,"||",2),2)),"^",7)
    Q:instruct="" ""
    s recLoc=$p($g(^OEORD(+mOeori,"I",+$p(mOeori,"||",2),3)),"^",6)
    s hosp=$p($g(^CTLOC(+recLoc)),"^",22)
    S pol=0,linkStr=""
    f  s pol=$o(^POLI(pol)) q:pol=""  d
    .q:##class(PHA.FACE.IN.Com).GetShowDataFlag("PIVA_OrderLink",pol,hosp)'="Y"
    .s polSub=$o(^POLI(pol,"S",0))
    .i polSub="" d
    ..s linkStr=$s(linkStr="":pol,1:linkStr_","_pol)
    .e  d
    ..i $d(^POLI(0,"INSTRUCDR",instruct,pol)) D
    ...s linkStr=$s(linkStr="":pol,1:linkStr_","_pol)
    q linkStr
}

/// description: 该组液体总量的配液分类串    
/// w ##class(web.DHCSTPIVAS.Common).GetPivaCatType()
ClassMethod GetLiquidPivaCats(mOeori As %String, pivaCatStr As %String) As %String
{
    q:mOeori="" ""
    S totalLiquid=..OrderLiquid(mOeori)
    s catLen=$l(pivaCatStr,",")
    s liquidStr=""
    s i=""
    F i=1:1:catLen d
    .S pivaCat=$p(pivaCatStr,",",i)
    .S polMinVolume=+$p(^POLI(pivaCat),"^",2)
    .S polMaxVolume=+$p(^POLI(pivaCat),"^",3)
    .Q:(polMinVolume=0)&&(polMaxVolume'=0)&&(totalLiquid>polMaxVolume)  //未维护最小量的只判断最大量
    .Q:(polMaxVolume=0)&&(polMinVolume'=0)&&(totalLiquid<polMinVolume)  //未维护最大量的只判断最小量
    .Q:(polMinVolume'=0)&&(polMaxVolume'=0)&&((totalLiquid>polMaxVolume)||(totalLiquid<polMinVolume))
    .S liquidStr=$s(liquidStr="":pivaCat,1:liquidStr_","_pivaCat)
    Q liquidStr
}

/// description: 该组液体总量年龄等的配液分类串    
/// w ##class(web.DHCSTPIVAS.Common).GetLinkSinglePivaCats()
ClassMethod GetLinkSinglePivaCats(mOeori As %String, pivaCatStr As %String) As %String
{
    q:mOeori="" ""
    s adm=$p(^OEORD(+mOeori),"^",1)
    S totalLiquid=..OrderLiquid(mOeori)
    s age = ..GetAgeNum(adm)
    s catLen=$l(pivaCatStr,",")
    s retStr=""
    s i=""
    F i=1:1:catLen d
    .S pivaCat=$p(pivaCatStr,",",i)
    .q:(+pivaCat=0)
    .s poliData = ^POLI(pivaCat)
    .S polMinVolume=+$p(poliData,"^",2)
    .S polMaxVolume=+$p(poliData,"^",3)
    .S polMinAge=+$p(poliData,"^",7)
    .S polMaxAge=+$p(poliData,"^",8)
    .Q:(polMinVolume=0)&&(polMaxVolume'=0)&&(totalLiquid>polMaxVolume)  //未维护最小量的只判断最大量
    .Q:(polMaxVolume=0)&&(polMinVolume'=0)&&(totalLiquid<polMinVolume)  //未维护最大量的只判断最小量
    .Q:(polMinVolume'=0)&&(polMaxVolume'=0)&&((totalLiquid>polMaxVolume)||(totalLiquid<polMinVolume))
    .Q:(polMinAge=0)&&(polMaxAge'=0)&&(age>polMaxAge)
    .Q:(polMaxAge=0)&&(polMinAge'=0)&&(age<polMinAge)
    .Q:(polMinAge'=0)&&(polMaxAge'=0)&&((age>polMaxAge)||(age<polMinAge))
    .S retStr=$s(retStr="":pivaCat,1:retStr_","_pivaCat)
    Q retStr
}

/// description: 获取一组医嘱的对应药品的配液分类串
ClassMethod GetDrugPivaCats(mOeori)
{
    q:mOeori="" ""
    s mOrd=+mOeori
    s mOrdItm=+$p(mOeori,"||",2)
    q:(mOrd=0)||(mOrdItm=0) ""
    k GetDrugPivaCatsData
    s drugPivaCat=..GetDrugPivaCatByOeori(mOeori)
    i drugPivaCat'="" s GetDrugPivaCatsData(drugPivaCat)=""
    s ordItm=""
    f  s ordItm=$O(^OEORDi(0,"OEORI",mOrd,mOeori,ordItm)) Q:ordItm=""  D
    .s oeori=mOrd_"||"_ordItm
    .s drugPivaCat=..GetDrugPivaCatByOeori(oeori)
    .q:drugPivaCat=""
    .s GetDrugPivaCatsData(drugPivaCat)=""
    s pivaCatStr=""
    s drugPivaCat=""
    f  s drugPivaCat=$o(GetDrugPivaCatsData(drugPivaCat)) q:drugPivaCat=""  d
    .q:+drugPivaCat=0
    .s pivaCatStr=$s(pivaCatStr="":drugPivaCat,1:pivaCatStr_","_drugPivaCat)
    q pivaCatStr
}

/// description: 获取一条医嘱记录对应的配液分类
ClassMethod GetDrugPivaCatByOeori(oeori)
{
    s arcItmId=$P(^OEORD(+oeori,"I",+$p(oeori,"||",2),1),"^",2)
    Q:arcItmId="" ""
    S drugPivaCat=##class(web.DHCST.Common.DrugInfoCommon).GetDrugPivaCat(arcItmId)
    q drugPivaCat
}

/// description: 通过传入的配液分类串和药品配液分类串确定最终的配液分类
/// input:       pivaCats - 大类串, 70,71,72,79
///              drugPivaCats - 小类串, 2,5,6
///              w ##class(web.DHCSTPIVAS.Common).GetFinalPivaCat("70,71,72,79",6)
ClassMethod GetFinalPivaCat(pivaCats As %String, drugPivaCats As %String) As %String
{
    s finalCatList=""
    s drugPivaCatsList=$lfs(drugPivaCats,",")
    s pivaCatsLen=$l(pivaCats,",")
    f i=1:1:pivaCatsLen d
    .s polId=$p(pivaCats,",",i)
    .q:polId=""
    .i $O(^POLI(polId,"G",0))="" d
    ..s finalCatList=finalCatList_$lb(polId) //没有维护药品分类
    .e  d
    ..s poliCh=0
    ..F  S poliCh=$o(^POLI(polId,"G",poliCh),1,poliData)  q:poliCh=""  D
    ...S pivaCatDrStr=$p(poliData,"^",4)
    ...s inFlag=..IsListContains(drugPivaCatsList,$lfs(pivaCatDrStr,","))
    ...q:inFlag'="Y"
    ...q:$lf(finalCatList,polId)>0
    ...s finalCatList=finalCatList_$lb(polId) 
    q $lts(finalCatList, ",")
}

/// description: 获取一组医嘱的容积
/// mOeore,执行记录剂量可能不同
/// w ##class(web.DHCSTPIVAS.Common).OrderLiquid("1093||48","1093||48||1")
ClassMethod OrderLiquid(mOeori = "", mOeore = "")
{
    q:(mOeori="")&&(mOeore="") ""
    s liquid=0
    i mOeore="" d
    .s mOrd=+mOeori
    .s mOrdItm=+$p(mOeori,"||",2)
    .q:(mOrd=0)||(mOrdItm=0) 
    .s dosageLiquid=+(..OeoriDosageMl(mOeori))
    .s liquid=dosageLiquid
    .s ordItm=""
    .f  s ordItm=$O(^OEORDi(0,"OEORI",mOrd,mOeori,ordItm)) Q:ordItm=""  D
    ..s oeori=mOrd_"||"_ordItm
    ..s dosageLiquid=+(..OeoriDosageMl(oeori))
    ..S liquid=liquid+dosageLiquid
    e  d
    .s mOrd=+mOeore
    .s mOrdItm=+$p(mOeore,"||",2)
    .s mOrdExe=+$p(mOeore,"||",3)
    .q:(mOrd=0)||(mOrdItm=0) 
    .s dosageLiquid=+(..OeoriDosageMl(mOrd_"||"_mOrdItm,mOeore))
    .s liquid=dosageLiquid 
    .s ordItm=""
    .f  s ordItm=$O(^OEORDi(0,"OEORE",mOeore,mOrd,ordItm)) Q:ordItm=""  d
    ..s ordExe=""
    ..f  s ordExe=$o(^OEORDi(0,"OEORE",mOeore,mOrd,ordItm,ordExe)) q:ordExe=""  d
    ...s oeore=mOrd_"||"_ordItm_"||"_ordExe
    ...s dosageLiquid=+(..OeoriDosageMl(mOrd_"||"_ordItm,oeore))
    ...S liquid=liquid+dosageLiquid 
    q liquid
}

/// description: 计算一条医嘱的容量,返回值对应为ml
/// yunhaibao20190812,执行记录剂量可能不同,传执行记录Id按执行记录剂量计算
/// w ##class(web.DHCSTPIVAS.Common).OeoriDosageMl("1093||49","1093||49||1")
ClassMethod OeoriDosageMl(oeori, oeore = "")
{
    i oeore'="" s oeori=$p(oeore,"||",1,2) 
    s ordId=$p(oeori,"||",1) Q:ordId="" ""
    s ordItm=$p(oeori,"||",2) Q:ordItm="" ""
    q:'$d(^OEORD(ordId,"I",ordItm,1)) ""
    i oeore'="" s doseQty=$P($g(^OEORD(ordId,"I",ordItm,"X",$p(oeore,"||",3))),"^",4)
    e  s doseQty=$P($g(^OEORD(ordId,"I",ordItm,2)),"^",1)
    s doseUom=$p($g(^OEORD(ordId,"I",ordItm,2)),"^",3)
    q:(doseQty="")||(doseUom="") ""
    s arcim=$p(^OEORD(ordId,"I",ordItm,1),"^",2)
    s qtyML=..ConvertArcQtyUom(arcim, doseQty, doseUom, "ML")
    q:+qtyML=0 ""
    q qtyML_"ML"
}

/// description: 判断一组医嘱中是否包含该药品
/// return:      1-存在,0-不存在
/// w ##class(web.DHCSTPIVAS.Common).CheckOeoriIncExist("461||5569",8070)
ClassMethod CheckOeoriIncExist(mOeori, incId)
{
    s incDr=$p(..GetIncItmByOeori(mOeori,"N"),"^",1)
    q:incDr=incId 1
    s mOrd=+mOeori
    s exist=0
    s ordItm=""
    f  s ordItm=$O(^OEORDi(0,"OEORI",mOrd,mOeori,ordItm)) Q:(ordItm="")||(exist=1)  D
    .s oeori=mOrd_"||"_ordItm
    .s incDr=$p(..GetIncItmByOeori(oeori,"N"),"^",1)
    .i incDr=incId s exist=1
    q exist
}

/// description: 获取医嘱库存项信息
/// moreFlag:Y(拼接皮试以及标签标识)
ClassMethod GetIncItmByOeori(oeori, moreFlag = "Y")
{
    Q:oeori="" ""
    S arcItmId=$P($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",2)
    Q:arcItmId="" ""
    S incId=$O(^INCI(0,"ARCIM_DR",+arcItmId,""))
    Q:incId="" ""
    S incCode=$P($g(^INCI(+incId,1)),"^",1)
    S incDesc=##class(PHA.COM.Data.Base).InciDesc(incId)
    i moreFlag="Y" d
    .s skinTest=$p(##class(web.DHCSTCOMMONORDER).OeoriSkinTest(oeori),"^",2)
    .s itmAdd=$o(^DHCITMINFO(0,"INCI",incId,""))
    .s labelSign=$p($g(^DHCITMINFO(+itmAdd)),"^",116)
    .s incDesc=skinTest_labelSign_incDesc
    Q incId_"^"_incCode_"^"_incDesc
}

/// description: 根据医嘱项Id获取药品是主药\溶媒\辅药
/// P 主药,A 辅药,Y 溶媒,PY PYA ...
/// w ##class(web.DHCSTPIVAS.Common).GetDrugType("1||1")
ClassMethod GetDrugType(arcItm)
{
    s ret = ""
    s pIndex = $lb("GetDrugType", arcItm)
    q:($d($$$PIVASVAR(pIndex), ret)) ret
    
    try{
        s phcdRowId = $p(^ARCIM(+arcItm, +$p(arcItm, "||", 2), 1), "^", 12)
        q:(phcdRowId = "") 
        s phcdId = +phcdRowId
        s phcdSub = $p(phcdRowId, "||", 2)
        s phcdExtData = $g(^PHCD(+phcdId, "DF", phcdSub, "DHC"))
        s menstruumFlag=$p(phcdExtData, "^", 44)
        i menstruumFlag '= "Y" s menstruumFlag = ""
        s drugTypeId = $p(phcdExtData, "^", 18)
        s drugType = $s(+drugTypeId '= 0 : $p($g(^DHCSTSCDI(+drugTypeId)), "^", 1), 1: "")
        s ret = drugType _ menstruumFlag
    }catch(e){
    }
    
    s $$$PIVASVAR(pIndex) = ret
    q ret
}

/// description: 根据医嘱项Id获取药品在成组中的显示顺序
/// w ##class(web.DHCSTPIVAS.Common).GetDrugTypeShowIndex("572||1")
ClassMethod GetDrugTypeShowIndex(arcItm)
{
    s drugTypeIndex=9
    s drugType=..GetDrugType(arcItm)
    i drugType="P" s drugTypeIndex="1"                              // 主药
    e  i (drugType["A")&&(drugType["Y") s drugTypeIndex="2"         // 辅药+溶媒
    e  i drugType="A" s drugTypeIndex="3"                           // 辅药   
    e  i drugType="Y" s drugTypeIndex="4"                           // 溶媒
    e  s drugTypeIndex="9"                                          // 无
    q drugTypeIndex
}

/// description: 医嘱剂量
/// w ##class(web.DHCSTPIVAS.Common).OeoriDosage("1093||49")
ClassMethod OeoriDosage(oeori As %String) As %String
{
    q ##class(web.DHCSTCOMMONORDER).OeoriDosage(oeori)
}

/// Description:    执行记录剂量
/// OEORE_QtyAdmin: 对应药学基本单位剂量
/// OEORE_PhQtyOrd：医嘱选择的单位的剂量-这个才是科学的
/// w ##class(web.DHCSTPIVAS.Common).OeoriDosage("861||224")
ClassMethod OeoreDosage(oeore As %String) As %String
{
    s doseQty=$p($g(^OEORD(+oeore,"I",+$p(oeore,"||",2),"X",+$p(oeore,"||",3))),"^",4)
    s doseUom=$p($g(^OEORD(+oeore,"I",+$p(oeore,"||",2),2)),"^",3)
    q:(+doseQty=0)||(+doseUom=0) ""
    s doseQty=$fn(doseQty,"N")
    s doseUomDesc=##class(PHA.PIVAS.Data.Base).UomDesc(doseUom)
    q doseQty_doseUomDesc
}

/// description: 医嘱用法
ClassMethod OeoriInstruc(oeori As %String) As %String
{
    s instrucId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),2)),"^",7)
    q:instrucId="" ""
    s instrucDesc=##class(PHA.PIVAS.Data.Base).InstDesc(instrucId)
    q instrucId_"^"_instrucDesc
}

/// description: 医嘱频次
ClassMethod OeoriFreq(oeori As %String) As %String
{
    s str = ##class(PHA.COM.Order).OeoriFreq(oeori)
    q $p(str, "^", 1) _ "^" _ $p(str, "^", 3)
}

/// description: 医嘱疗程
ClassMethod OeoriDuration(oeori As %String) As %String
{
    s duratId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),2)),"^",4)
    q:duratId="" ""
    s durationDesc=##class(PHA.PIVAS.Data.Base).DuratDesc(duratId)
    q duratId_"^"_durationDesc
}

/// description: 开单医生
ClassMethod OeoriDoctor(oeori As %String) As %String
{
    s doctor=$P($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",11)
    q:doctor="" ""
    q doctor _ "^" _ ##class(PHA.PIVAS.Data.Base).CareProvDesc(doctor)
}

/// description: 体重
ClassMethod GetPatWeight(admId) As %String
{
    S mrAdmId=$P($g(^PAADM(admId)),"^",61)
    Q:mrAdmId="" ""
    S weight=$P(^MR(mrAdmId,"PRO",1),"^",27)
    i (weight'="")&&(+weight'=0) s weight=weight_"kg"
    Q weight
}

/// description: 身高
ClassMethod GetPatHeight(admId) As %String
{
    S mrAdmId=$P($g(^PAADM(admId)),"^",61)
    Q:mrAdmId="" ""
    S height=$P(^MR(mrAdmId,"PRO",1),"^",20)
    i (height'="")&&(+height'=0) s height=height_"cm"
    Q height
}

/// description: 体温单体重身高等
/// input:       admId:就诊id,obsItmCode:信息类型,obsDate:录入日期(空时取最新)
/// tables:      MR_Observations,MRC_ObservationItem
/// output:      数据(标准单位)
/// w ##class(web.DHCSTPIVAS.Common).GetMrObsItm(1143,"体重",64880)
ClassMethod GetMrObsItm(admId, obsItmCode, obsDate = "")
{
    i obsDate="" s obsDate=+$h+1
    e  s obsDate=obsDate+1
    Q:(admId="")||(obsItmCode="") ""
    Q:'$D(^PAADM(admId)) ""
    s obsValue=##class(Nur.Interface.OutSide.Temperature).getLastItemValue(admId, obsItmCode)
    i (obsValue'="")&&(+obsValue'=0) d
    .i ($ZCVT(obsItmCode,"U")="WEIGHT")&&($zcvt(obsValue,"U")'["KG") s obsValue=obsValue_"kg"
    .i ($ZCVT(obsItmCode,"U")="HEIGHT")&&($zcvt(obsValue,"U")'["CM") s obsValue=obsValue_"cm"
    q obsValue
}

/// description: 医嘱备注
ClassMethod OeoriRemark(oeori As %String) As %String
{
    s ordId=+$p(oeori,"||",1)
    s ordItm=+$p(oeori,"||",2)
    s (num,memo)=""
    s num="0" f  s num=$o(^OEORD(ordId,"I",ordItm,"DEP",num)) q:num=""  d
    .s memo=memo_$g(^OEORD(ordId,"I",ordItm,"DEP",num))
    q memo
}

/// description: 医嘱优先级
/// ##class(web.DHCSTPIVAS.Common).OeoriPriority()
ClassMethod OeoriPriority(oeori As %String) As %String
{
    S priority=$P($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",8)
    Q:priority="" ""
    S priCode=$P(^OECPR(priority),"^",1)
    S priDesc=##class(PHA.PIVAS.Data.Base).OrdPriDesc(priority)
    Q priority_"^"_priCode_"^"_priDesc
}

/// description: 判断一组药品整体的医嘱优先级,全为自备药则为自备药
/// ##class(web.DHCSTPIVAS.Common).OrdPriority()
ClassMethod OrdPriority(mOeori)
{
    s priorityStr=..OeoriPriority(mOeori)
    q:priorityStr'["OM" priorityStr
    s omFlag="1"
    s ordItm=""
    f  s ordItm=$o(^OEORDi(0,"OEORI",+mOeori,mOeori,ordItm)) Q:(ordItm="")||(omFlag="")  d
    .s priorityStr=..OeoriPriority(+mOeori_"||"_ordItm)
    .i priorityStr'["OM" s omFlag=""
    q priorityStr
}

/// description: 开医嘱时间
ClassMethod OeoriDateTime(oeori As %String) As %String
{
    q:oeori="" ""
    s oeoriDate=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),3)),"^",7)
    i oeoriDate'="" d
    .s oeoriDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(oeoriDate)
    .i oeoriDate["-" s oeoriDate=$p(oeoriDate,"-",2,3)
    .e  i oeoriDate["/" s oeoriDate=$p(oeoriDate,"/",1,2)
    s oeoriTime=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",17)
    i oeoriTime'="" s oeoriTime=$zt(oeoriTime,1)
    q oeoriDate_" "_oeoriTime
}

/// description: 成组医嘱标识符号
/// ##class(web.DHCSTPIVAS.Common).OeoriSign()
ClassMethod OeoriSign(num)
{
    q:num="-1" "┍"
    q:num="0" "│"
    q:num="1" "┕"
    q ""
}

/// description: 获取是否为打包状态
/// ##class(web.DHCSTPIVAS.Common).DspPackFlag()
ClassMethod DspPackFlag(mDspId)
{
    q:mDspId="" ""
    s packFlag=$p($g(^DHCOEDISQTY(mDspId)),"^",28)
    i (packFlag'="")&&(packFlag'="N") s packFlag="P"
    e  s packFlag=""    
    q packFlag
}

/// description: 根据打包表Id获取配液子表Id
/// ##class(web.DHCSTPIVAS.Common).OrdGrpItmRowId()
ClassMethod OrdGrpItmRowId(dspId)
{
    S pogId=$O(^PIVA(0,"DSP",+dspId,""))
    Q:pogId="" ""
    S pogItm=$O(^PIVA(0,"DSP",+dspId,pogId,""))
    Q pogId_"||"_pogItm
}

/// description: 判断配液批次是否存在选择的批次中
/// return:      1-存在,0-不存在
/// ##class(web.DHCSTPIVAS.Common).CheckBatNoList(batNoStr, batNo, split)
ClassMethod CheckBatNoList(batNoStr, batNo, split = ",")
{
    q:batNoStr="" 1
    s chkRet=0
    s batNoLen=$l(batNoStr,split)
    f batNoI=1:1:batNoLen q:chkRet=1  d
    .s batNoId=$p(batNoStr,split,batNoI)
    .q:batNoId=""
    .s tmpBatNo=$p($g(^PIVABT(batNoId)),"^",3)
    .i tmpBatNo=batNo d
    ..s chkRet=1
    q chkRet
}

/// description: 日期简写不带年份
/// ##class(web.DHCSTPIVAS.Common).DateShortFormat
ClassMethod DateShortFormat(dateLogical)
{
    q:dateLogical="" ""
    s dateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dateLogical)
    q:dateHtml["-" $p(dateHtml,"-",2,3)
    q:dateHtml["/" $p(dateHtml,"/",1,2)
}

/// description: 时间简写不带秒
/// ##class(web.DHCSTPIVAS.Common).TimeShortFormat
ClassMethod TimeShortFormat(timeLogical)
{
    q:timeLogical="" ""
    q $zt(timeLogical,2)
}

/// descirption: 进程号
ClassMethod NewPid()
{
    q ##class(web.DHCSTKUTIL).NewPid($this,"PIVA")
}

/// description: 获取减库标识,两个减库都要设置
ClassMethod PsDispFlag(locId, psNumber, packFlag = "")
{
    q:psNumber="" ""
    s psId=$o(^PIVAS(0,"LOCTYPENUMBER",locId,"I",psNumber,""))
    q:psId="" ""    
    i packFlag="" s dispFlag=$p(^PIVAS(psId),"^",6)
    e  i packFlag="P" s dispFlag=$p(^PIVAS(psId),"^",11)
    q dispFlag
}

/// description: 根据科室id,门诊or住院(I/O),状态代码获取配液流程状态的id
/// w ##class(web.DHCSTPIVAS.Common).GetPivaStateId(101,"I",10)
ClassMethod GetPivaStateId(locId, psType, psNumber)
{
    q:'$d(^PIVAS(0,"LOCTYPENUMBER",locId,psType,psNumber)) ""
    q $o(^PIVAS(0,"LOCTYPENUMBER",locId,psType,psNumber,""))
}

/// description: 根据当前配液状态获取下一状态的代码
ClassMethod GetNextPsState(psId, locId, psType, packFlag) As %String
{
    q:psId="" ""
    q:locId="" ""
    q:'$d(^PIVAS(psId)) ""
    S psNumber=$P(^PIVAS(psId),"^",1)
    s nextPsId="",nextPsNumber=""
    f  s psNumber=$O(^PIVAS(0,"FN","Y","N",psNumber)) q:(psNumber="")||(nextPsId'="")  d
    .s psDr=""
    .f  s psDr=$o(^PIVAS(0,"FN","Y","N",psNumber,psDr)) q:(psDr="")||(nextPsId'="")  d
    ..q:+psDr=0
    ..s psData=^PIVAS(psDr)
    ..s locDr=$P(psData,"^",7)
    ..s psTypeCode=$P(psData,"^",9) 
    ..s packIgnore= $P(psData,"^",10) 
    ..q:locDr'=locId
    ..q:psTypeCode'=psType
    ..q:(packFlag="P")&&(packIgnore="Y")
    ..s nextPsId=psDr
    ..s nextPsNumber=psNumber
    Q nextPsId_"^"_nextPsNumber
}

/// creator:    yunhaibao
/// createdate: 2018-03-05
/// description:根据主医嘱Id获取集中配置(配置间),判断优先级为(主药\主医嘱)
/// input:      mOeore(主医嘱Id)
/// output:     集中配置Id^集中配置代码^集中配置名称,取不到时返回没有子表数据的记录(代表普通)
/// w ##class(web.DHCSTPIVAS.Common).OrdWorkType("402||27||1")
ClassMethod OrdWorkType(mOeore)
{
    k OrdWorkTypeDATA
    s mOeori = $p(mOeore, "||", 1, 2)
    s mOrd=+mOeore
    s mOrdItm=+$p(mOeore,"||",2)
    s recLocId = ..GetOeoreRecLoc(mOeore, mOeore)
    s conTblId=$p(..OeoriConTable(mOeori, recLocId),"^",1)
    s instrucId=$p(..OeoriInstruc(mOeori),"^",1)
    s liquid=..OrderLiquid(mOeori)
    s oeori=mOeori
    d OeoriWorkType
    s ordItm = ""
    f  s ordItm = $o(^OEORDi(0, "OEORE", mOeore, mOrd, ordItm)) q:ordItm=""  d
    .s oeori = mOrd _ "||" _ ordItm
    .s conTblId=$p(..OeoriConTable(oeori, recLocId),"^",1)
    .d OeoriWorkType
    q:'$d(OrdWorkTypeDATA) ..NullWorkType(recLocId)
    s sortCode=$o(OrdWorkTypeDATA(""))
    s wtId=$o(OrdWorkTypeDATA(sortCode,""))
    q:wtId="" ..NullWorkType(recLocId)
    s PIVAWT=$g(^PIVAWT(wtId))
    q wtId_"^"_$p(PIVAWT,"^",2)_"^"_##class(PHA.PIVAS.Data.Base).PIVAWorkTypeDesc(wtId)
OeoriWorkType
    q:conTblId=""
    s oeoriWTStr=""
    s indexInstr="" // indexInstr字段空时索引为-100000
    f  s indexInstr=$o(^PIVAWTi("PCTInst",conTblId,indexInstr)) q:indexInstr=""  d
    .s pwtId=""
    .f  s pwtId=$o(^PIVAWTi("PCTInst",conTblId,indexInstr,pwtId)) q:pwtId=""  d
    ..q:+pwtId=0
    ..s PIVAWT=^PIVAWT(pwtId)
    ..q:$p(PIVAWT,"^",5)'="Y"
    ..s pwtLocId=$p(PIVAWT,"^",1)
    ..q:pwtLocId'=recLocId
    ..s pwtSort=$p(PIVAWT,"^",7)
    ..i pwtSort="" s pwtSort="ω" // 优先级
    ..s pwtSort=$j(pwtSort,10)
    ..s pwtItm=""
    ..f  s pwtItm=$o(^PIVAWTi("PCTInst",conTblId,indexInstr,pwtId,pwtItm)) q:(pwtItm="")  d
    ...q:+pwtItm=0
    ...s PIVAWTI=^PIVAWT(pwtId,"I",pwtItm)
    ...s pwtRel=$p(PIVAWTI,"^",3)
    ...s pwtLiquid=$p(PIVAWTI,"^",4)
    ...s pwtInstr=$p(PIVAWTI,"^",2)
    ...q:(pwtInstr'="")&&(pwtInstr'=instrucId)
    ...q:(pwtRel=">")&&(pwtLiquid'="")&&(+liquid<pwtLiquid)
    ...q:(pwtRel="<")&&(pwtLiquid'="")&&(+liquid>pwtLiquid)
    ...s OrdWorkTypeDATA(pwtSort,pwtId)=""
    q
}

/// creator:    yunhaibao
/// createdate: 2018-03-05
/// description:当医嘱获取不到集中配置时,返回一个子表为空的数据(定义为普通)
/// input:      mOeori(主医嘱Id)
/// output:     配置台Id^配置台名称
/// w ##class(web.DHCSTPIVAS.Common).NullWorkType(248)
ClassMethod NullWorkType(recLocId)
{
    s workTypeStr=""
    s pwtId=""
    f  s pwtId=$o(^PIVAWTi("LOC",recLocId,pwtId)) q:(pwtId="")||(workTypeStr'="")  d
    .q:+pwtId=0
    .s PIVAWT=^PIVAWT(pwtId)
    .q:$p(PIVAWT,"^",5)'="Y"
    .q:$p(PIVAWT,"^",6)'="Y"
    .s pwtCode=$p(PIVAWT,"^",2)
    .s pwtDesc=$p(PIVAWT,"^",3)
    .s workTypeStr=pwtId_"^"_pwtCode_"^"_##class(PHA.PIVAS.Data.Base).PIVAWorkTypeDesc(pwtId)
    q workTypeStr
}

/// creator:    yunhaibao
/// createdate: 2018-03-05
/// description:获取一条医嘱的配置台,一组药仅能属于一个配置台(主药\主医嘱\存在即为)
/// input:      mOeori(主医嘱Id)
/// output:     配置台Id^配置台名称
ClassMethod OeoriConTable(oeori, recLoc)
{
    s incId=$p(..GetIncItmByOeori(oeori,"N"),"^",1)
    s incCh=$o(^INCI("IL_LOC",recLoc,incId,""))
    q:incCh="" ""
    s dhcIncil=$o(^DHCINCIL(0,"INCIL",incId_"||"_incCh,""))
    q:dhcIncil="" ""
    s conTblId=$p(^DHCINCIL(dhcIncil),"^",37)
    s conTblDesc=$p($g(^PIVACT(+conTblId)),"^",3)
    q conTblId_"^"_conTblDesc
}

/// description: 根据主医嘱判断是否为关联医嘱
/// output:      Y/N
ClassMethod OrdSeqFlag(mOeori)
{
    q:mOeori="" "N"
    s mOrd=+$p(mOeori,"||",1) Q:mOrd=0 "N"
    s mOrdItm=+$p(mOeori,"||",2) Q:mOrdItm=0 "N"
    q:'$d(^OEORD(mOrd,"I",mOrdItm,1)) "N"
    s seqFlag="N"
    s recLocId=$p(^OEORD(mOrd,"I",mOrdItm,3),"^",6)
    s linkOeori=$p(^OEORD(mOrd,"I",mOrdItm,11),"^",39)
    q:linkOeori'="" "Y"
    i linkOeori="" d
    .s ordItm=""
    .f  s ordItm=$o(^OEORDi(0,"OEORI",mOrd,mOeori,ordItm)) Q:(ordItm="")!(seqFlag="Y")  d
    ..q:'$d(^OEORD(mOrd,"I",ordItm,3))
    ..q:'$d(^OEORD(mOrd,"I",ordItm,1))
    ..q:$p(^OEORD(mOrd,"I",ordItm,3),"^",6)'=recLocId
    ..s seqFlag="Y"
    q seqFlag
}

/// description: 判断批号是否符合所选条件
/// input:       batNoStr(id串,逗号分隔),描述
/// output:      Y/N
/// ##class(web.DHCSTPIVAS.Common).CheckBatNo("1,2,3,4","08")
ClassMethod CheckBatNo(batNoStr, batNo)
{
    q:batNoStr="" "N"
    s ret="N"
    s batNoStrLen=$l(batNoStr,",")
    s batNoI=""
    f batNoI=1:1:batNoStrLen q:ret="Y"  d
    .s tmpBatNoId=$p(batNoStr,",",batNoI)
    .q:+tmpBatNoId=0
    .s tmpBatNo=$p(^PIVABT(tmpBatNoId),"^",3)
    .i tmpBatNo=batNo d
    ..s ret="Y"
    q ret
}

/// description: 获取当前配液状态
/// input:       mDsp
/// output:      状态标识号^状态名称
/// ##class(web.DHCSTPIVAS.Common).CurPsState(1)
ClassMethod CurPsState(mDsp)
{
    s pog = $o(^PIVA(0, "DSP", mDsp, 0))
    q:(pog = "") ""
    s ps = $p(^PIVA(pog),"^",6)
    s psData = ^PIVAS(ps)
    s psNumber = $p(psData, "^", 1)
    s psName = $p(psData, "^", 2)
    q psNumber _ "^" _  ##class(PHA.COM.Data.Base).PIVASStateName(ps)
}

/// creator:    yunhaibao
/// createdate: 2017-12-14
/// description:截取字符串长度,中文占2,英文占1
/// input:      inputStr-字符串,length-截取长度,start-开始位置
/// w ##class(web.DHCSTPIVAS.Common).SubString("氯化钠(科伦)%123",6)
ClassMethod SubString(inputStr, length, start = 0)
{
    q:inputStr="" ""
    s inputLen=$l(inputStr)
    q:inputLen=0 ""
    s retStr=""
    s retLen=0
    s inputI=""
    f inputI=1:1:inputLen q:retLen>length  d
    .s iStr=$e(inputStr,inputI)
    .s iStrAsc=$ASCII(iStr)
    .s iStrLen=$s(iStrAsc>250:2,1:1)
    .s retLen=retLen+iStrLen
    .q:retLen>length
    .q:retLen<start
    .s retStr=$s(retStr="":iStr,1:retStr_iStr)
    q retStr
}

/// description: 根据流程代码获取该配液中心流程设置的Id
/// w ##class(web.DHCSTPIVAS.Common).LocPsIdByPsNumber(101,10)
ClassMethod LocPsIdByPsNumber(locId, psNumber)
{
    q:(locId="")||(psNumber="") ""
    &SQL(SELECT ps_rowid into :psId FROM PIVA_State WHERE PS_Number=:psNumber AND PS_Loc_Dr=:locId and PS_TypeFlag='I')
    q psId
}

/// description: 格式化数字,小于1补零
/// w ##class(web.DHCSTPIVAS.Common).FmtNum(101)
ClassMethod FmtNum(num)
{
    q $fn(num, "N")
}

/// description: 获取配液大类对应的收费项串
/// output:      医嘱项Id1@数量^医嘱项Id2@数量2
/// w ##class(web.DHCSTPIVAS.Common).GetLinkOrdByPivaCat(317)
ClassMethod GetLinkOrdByPivaCat(pivaCatId, packFlag = "", seqFlag = "")
{
    q:(pivaCatId = "") ""
    s pIndex = $lb("GetLinkOrdByPivaCat", pivaCatId, packFlag, seqFlag), ret = ""
    q:($d($$$PIVASVAR(pIndex), ret)) ret
    
    try{
        s lnkOrdStr=""
        s poloId=""
        f  s poloId=$o(^POLI(pivaCatId,"M",poloId)) q:poloId=""  d
        .q:+poloId=0
        .s POLIM=$G(^POLI(pivaCatId,"M",poloId))
        .s arcItmId=$p(POLIM,"^",1)
        .q:arcItmId=""
        .q:arcItmId'["||"
        .s qty=$p(POLIM,"^",4)
        .q:+qty=0
        .s poloPack=$p(POLIM,"^",6)
        .q:(poloPack="Y")&&(packFlag'="P")
        .q:(poloPack="N")&&(packFlag="P")
        .s poloSeq=$p(POLIM,"^",7)
        .q:(poloSeq'="")&&(seqFlag'=poloSeq)
        .s tmpData=arcItmId_"@"_qty
        .s lnkOrdStr=$s(lnkOrdStr="":tmpData,1:lnkOrdStr_"^"_tmpData)
        s ret = lnkOrdStr
    }catch(e){}
    
    s $$$PIVASVAR(pIndex) = ret
    q ret
}

/// description: 获取配液拒绝原因
/// w ##class(web.DHCSTPIVAS.Common).PogRefuseReason(150190)
ClassMethod PogRefuseReason(pogId)
{
    q:+pogId=0 ""
    s porId=$p($g(^PIVA(pogId)),"^",9)
    q ##class(PHA.COM.Data.Base).PIVAOperReasonDesc(porId)
    q $p($g(^PIVAOR(+porId)),"^",2)
}

/// description: 剂量非整包装
/// return:      (非整包)Y/N
/// w ##class(web.DHCSTPIVAS.Common).DosageCompFlag("1220||380",17)
ClassMethod DosageCompFlag(oeori, bUomId)
{
    s ordId=+oeori
    s ordItm=+$p(oeori,"||",2)
    s doseQty=$p($g(^OEORD(ordId,"I",ordItm,2)),"^",1)
    s doseUomId=$p($g(^OEORD(ordId,"I",ordItm,2)),"^",3)
    q:(doseQty="")||(doseUomId="") "N"
    q:(doseUomId=bUomId)&&(doseQty[".") "Y"
    q:(doseUomId=bUomId)&&(doseQty'[".") "N"
    s arcItmId=$p(^OEORD(ordId,"I",ordItm,1),"^",2)
    S phcdfId=$P($g(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1)),"^",12)
    q:+phcdfId=0 "N"
    s phcdId=+phcdfId
    s phcdfSub=$p(phcdfId,"||",2)
    s eqSub="0",eqQty=0
    f  s eqSub=$O(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqSub)) q:eqSub=""  d
    .s eqUomId=$P(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqSub),"^",1)
    .q:eqUomId'=doseUomId
    .s eqQty=+$P(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqSub),"^",2) //等效数量
    q:eqQty=0 "N"
    s compFlag=doseQty/eqQty
    q:compFlag["." "Y"
    Q "N"
}

/// description: 计算体表面积
/// w ##class(web.DHCSTPIVAS.Common).SurfaceArea(50000015)
ClassMethod CalcuSurfaceArea(patSex, patHeight, patWeight)
{
    s area=##class(web.DHCSTPIVAS.Formula).CalcuSurfaceArea(patSex, patHeight, patWeight)
    i area'="" s area=$j(area,"",$l($p(area,".",2)))_"㎡"
    q area
}

/// description: 病人基本信息,用于前台hover显示
/// input:       oeori医嘱id或执行记录Id
/// w ##class(web.DHCSTPIVAS.Common).PatBasicInfoHtml("2098||17")
ClassMethod PatBasicInfoHtml(oeori)
{
    s ordId=+oeori
    q:ordId=0 ""
    s admId=$p(^OEORD(ordId),"^",1)
    s patId=$p(^PAADM(admId),"^",1)
    q:patId="" ""
    s patName=$P(^PAPER(patId,"ALL"),"^",1)
    s patSex=$p($g(^PAPER(patId,"ALL")),"^",7)
    s patSex=$p($g(^CT("SEX",+patSex)),"^",2)
    s patAge=##class(PHA.FACE.IN.Com).GetAge(patId,admId)
    s patHeight=..GetMrObsItm(admId,"HEIGHT","")
    s patWeight=..GetMrObsItm(admId,"WEIGHT","")
    i patHeight="" s patHeight=..GetPatHeight(admId)
    i patWeight="" s patWeight=..GetPatWeight(admId)
    s patSurface=..CalcuSurfaceArea(patSex, patHeight, patWeight)
    s diag=##class(PHA.COM.Order).MrDiagnose(admId,"，")
    s allergy=##class(web.DHCSTCOMMONORDER).PatAllergy(patId,"，")
    
    s retHtml = ""
    s retHtml = retHtml _ "<table cellspacing='5'>"
    s retHtml = retHtml _ $$GetOneHtml(..Get("基本信息"), ..Get("姓名") _ ":" _ $$Span(patName) _ 
                                                         $$Span(..Get("性别")) _ ":" _ $$Span(patSex) _ 
                                                         $$Span(..Get("年龄")) _ ":" _ $$Span(patAge) _ 
                                                         $$Span(..Get("身高")) _ ":" _ $$Span(patHeight) _ 
                                                         $$Span(..Get("体重")) _ ":" _ $$Span(patWeight) _ 
                                                         $$Span(..Get("体表面积")) _ ":" _ $$Span(patSurface))
    s retHtml = retHtml _ $$GetOneHtml(..Get("诊断"), diag)
    s retHtml = retHtml _ $$GetOneHtml(..Get("过敏史"), allergy)
    s retHtml = retHtml _ "</table>"
    q retHtml

Span(info)
    q "<span style=padding-left:10px>" _ info _ "</span>"  
    
GetOneHtml(title, content)
    q:(content = "") ""
    s oneHtml = ""
    s oneHtml = oneHtml _ " <tr>"
    s oneHtml = oneHtml _ "     <td><div style='height:14px; margin-top:1px; margin-right:5px; border-left:5px solid #007ACF; float:left;'></div></td>"
    s oneHtml = oneHtml _ "     <td><b>" _ title _ "</b></td>"
    s oneHtml = oneHtml _ " </tr>"
    s oneHtml = oneHtml _ " <tr>"
    s oneHtml = oneHtml _ "     <td></td>"
    s oneHtml = oneHtml _ "     <td><div>" _ content _ "</div></td>"
    s oneHtml = oneHtml _ " </tr>"
    q oneHtml
}

/// creator:    yunhaibao
/// createdate: 2018-04-24
/// description:根据医嘱主医嘱id获取该关联医嘱对应得所有药品
/// input:      mOeori(主医嘱Id),delim(分隔符)
/// w ##class(web.DHCSTPIVAS.Common).GetOrderDrugsByPog("152343","</br>")
ClassMethod GetOrderDrugsByPog(pogId, delim = "^")
{
    q:pogId="" ""
    s retStr=""
    s pogItm=""
    f  s pogItm=$o(^PIVA(pogId,"I",pogItm)) q:pogItm=""  d
    .s dspId=$p(^PIVA(pogId,"I",pogItm),"^",1)
    .s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
    .s incDesc=$p(..GetIncItmByOeori(oeori),"^",3)
    .q:incDesc=""
    .s retStr=$s(retStr="":incDesc,1:retStr_delim_incDesc)
    q retStr
}

/// description: 获取配伍审核在处方点评类型中的Id
/// table:       DHC_PHCNTSWAY
/// w ##class(web.DHCSTPIVAS.Common).PIVASCNTSWAYID()
ClassMethod PIVASCNTSWAYID()
{
    &SQL(SELECT PWAY_RowID into :pwayId FROM DHC_PHCNTSWAY WHERE PWAY_Code='PIVAS' AND PWAY_Active='Y')
    q pwayId
}

/// description:静脉打印停止标签时是否自动执行退药
/// output:     Y(执行),否则不执行
/// w ##class(web.DHCSTPIVAS.Common).ExeRetOnPrt(101)
ClassMethod ExeRetOnPrt(locId As %String) As %String
{
    s hosp = $p(^CTLOC(locId), "^", 22)
    s params = $lts($lb("", locId, "", hosp), "^")
    q ##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTINPIVA", "Com.PrtStopRet", params)
}

/// description:计算为第几天用药
/// input:      mOeori(主医嘱Id),doseDate(本次用药日期)
/// return:     integer
/// w ##class(web.DHCSTPIVAS.Common).GetOeoriTimes("1019||25",64388)
ClassMethod GetTimesByDoseDate(mOeori As %String, doseDate As %String) As %String
{
    s times=1
    s firstDate=$o(^DHCOEDISQTY(0,"SEQNO",mOeori,""))
    q:+firstDate<=0 times
    q:firstDate=doseDate times
    s times=(doseDate-firstDate)+1
    s freqId=$p(..OeoriFreq(mOeori),"^",1)
    q:+freqId=0 times
    s freqDays=$p(^PHCFR(freqId),"^",5)
    i +freqDays>0 d // n天用药一次需另算
    .s times=(doseDate-firstDate)/freqDays+1
    q times
}

/// description:计算第几次用药的日期,涉及首日住院药房
/// input:      mOeori(主医嘱Id),doseDate(本次用药日期)
/// return:     integer
/// w ##class(web.DHCSTPIVAS.Common).GetDoseDateByTimes("230||578",1,248)
ClassMethod GetDoseDateByTimes(mOeori As %String, times As %String, pivaLocId = "") As %String
{
    s dspId="",firstDate=""
    f  s dspId=$o(^DHCOEDISQTY(0,"OEORI",mOeori,dspId)) q:(dspId="")||(firstDate'="")  d
    .q:+dspId=0
    .q:$p(^DHCOEDISQTY(dspId),"^",7)="R"
    .q:(pivaLocId'="")&&($p(^DHCOEDISQTY(dspId),"^",24)'=pivaLocId)
    .s firstDate=$p(^DHCOEDISQTY(dspId),"^",21)
    q:+firstDate<=0 "" // 第一天
    s timesDay=firstDate+(times-1) // 需要审核前这么多天
    s freqId=..GetOeoriFreqID(mOeori)
    q:+freqId=0 timesDay
    // 周频次
    s freqWeek=$p($g(^OEORD(+mOeori,"I",+$p(mOeori,"||",2),"DHC")),"^",55)
    .i freqWeek'="" d
    ..s timesDay=..GetWeekFreqTimesDate(freqWeek,times,$zd(firstDate,3))
    q:freqWeek'="" timesDay
    s freqDays=$p(^PHCFR(freqId),"^",5)
    i +freqDays>0 d 
    .s timesDay=firstDate+((times-1)*freqDays)
    q timesDay
}

/// description: 获取医嘱录入的滴速
/// w ##class(web.DHCSTPIVAS.Common).OeoriIvgttSpeed()
ClassMethod OeoriIvgttSpeed(oeori)
{
    s ordId=+oeori
    s ordItmId=+$p(oeori,"||",2)
    q:(ordId=0)||(+oeori=0) ""
    s flowSpeed=$p($g(^OEORD(ordId,"I",ordItmId,3)),"^",17)
    s flowUomDr=+$p($g(^OEORD(ordId,"I",ordItmId,6)),"^",8)
    s flowUomDesc=##class(PHA.PIVAS.Data.Base).SpeedFlowRateDesc(flowUomDr)
    q flowSpeed_flowUomDesc
}

/// description: 护士审核(是否已经护士审核)
/// w ##class(web.DHCSTPIVAS.Common).NurAuditFlagByMDsp(754578)
ClassMethod NurAuditFlagByMDsp(mDsp)
{
    s nurAuditFlag=$p($g(^DHCOEDISQTY(+mDsp)),"^",17)
    q $s(nurAuditFlag'="Y":"N",1:"Y")
}

/// description: 获取系统维护的假日
/// 基础平台类:   websys.Holiday
/// return:      假日代码^假日名称,非假日返回空
/// w ##class(web.DHCSTPIVAS.Common).FestivalDay("64769")
ClassMethod FestivalDay(festDate)
{
    q:+festDate=0 ""
    s festCode=""
    s festDesc=""
    Set solar = $zd(festDate,4)
    Set sy=$p(solar,"/",3),sm = $p(solar,"/",2),sd=$p(solar,"/"),sw=$zd(festDate,10)
    Set lunar = ##class(websys.CalendarUtil).ToLuner(solar)
    Set lm = $p(lunar,"*",2),ld=$p(lunar,"*",3)
    ;循环节日表
    Set RowId = 0,Img=""
    for{
        Set RowId = $O(^websys.HolidayD(RowId))
        Quit:RowId=""
        Set g = ^websys.HolidayD(RowId)
        Set active = $lg(g,7)
        Continue:(active'="Y")
        Set isLunar = $lg(g,5)
        Set hldDays = $lg(g,6)
        if isLunar="Y"{
            Set month = +lm, day=+ld
        }else{
            Set month = +sm, day=+sd
        }
        if (hldDays["月")&&(hldDays["周")&&(+hldDays=month){
            Set Len = $l(hldDays,",")
            For i=1:1:Len{
                Set hldDay = $p(hldDays,",",i)
                If (hldDay["月最后的周"){
                    ; 世界心脏日 9月最后的周7
                    Set week = +$p(hldDay,"月最后的周",2)#7
                    Set disDay = $zdh(sy_"-"_(month+1)_"-1",3)-$h   ;到下月一号不超过7天
                    if (week=sw)&&(disDay<7){
                        Set festCode=$lg(g,2)
                        Set festDesc=$lg(g,3)
                    }
                }       
                if (hldDay["月第")&&(hldDay["周周"){
                    ; 母亲节 5月第2周周7
                    Set week = +$p(hldDay,"周周",2)#7
                    Set timesWeek = +$p(hldDay,"月第",2)
                    Set disDay = $h - $zdh(sy_"-"_month_"-1",3)     ;一号到今天过了多少天,天数应该在7*(times-1)与7*times间
                    if (week=sw) && (disDay>(7*(timesWeek-1))) && (disDay<(7*timesWeek)){
                        Set festCode=$lg(g,2)
                        Set festDesc=$lg(g,3)
                    }   
                }
            } 
        }
        If (hldDays[month)&&(hldDays[day) {
            ;10-1,8-15
            Set Len = $l(hldDays,",")
            For i=1:1:Len{
                Set hldDay = $p(hldDays,",",i)
                if (+hldDay=month)&&(+$p(hldDay,"-",2)=day){
                        Set festCode=$lg(g,2)
                        Set festDesc=$lg(g,3)
                }
            }
        }
        Quit:(festCode'="")
    }
    q:festCode="" ""
    // 不放假的节日q 空?todo
    Quit festCode_"^"_festDesc
}

/// creator:    yunhaibao
/// createdate: 2018-07-23
/// description:获取配伍审核人
/// input:      mOeori(主医嘱Id),mOeoriDate(用药日期),auditTimes(需审核的天数)
/// return: SHTG,SHJJ,ZCDB,FZCDB,""
/// w ##class(web.DHCSTPIVAS.Common).GetOrdPassState("461||470","64786","2")
ClassMethod GetOrdPassUser(mOeori, mOeoriDate = "", auditTimes = "")
{
    //s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.Common","GetOrdPassState")=$lb(mOeori , mOeoriDate , auditTimes)
    q:mOeori="" ""
    s validDate=""
    i auditTimes'="" d
    .i auditTimes="1"  s validDate=""   // 审新医嘱
    .e  d
    ..s lastDate=..GetDoseDateByTimes(mOeori,auditTimes)    
    ..i mOeoriDate>lastDate  s validDate=lastDate       // 审核前n天,则之后以第n天为审核依据
    ..e  s validDate=mOeoriDate
    e  s validDate=""
    i validDate="" s phaOrd=$o(^DHCPHORDM(0,"OrdItem",mOeori,""),-1)
    e  s phaOrd=$o(^DHCPHORDM(0,"DateOrdItem",mOeori,validDate,""),-1)
    q:phaOrd="" ""
    s userId=$p(^DHCPHORDM(phaOrd),"^",1)
    s userName=##class(PHA.PIVAS.Data.Base).UserName(userId)
    q userId_"^"_userName
}

/// description: 获取对应配液流程的操作人员
ClassMethod GetStateUser(pogId, stateNum)
{
    s (userId,userName)=""
    q:pogId="" ""
    s pogsId=""
    f  s pogsId=$o(^PIVA(pogId,"S",pogsId)) q:(pogsId="")||(userId'="")  d
    .q:+pogsId=0
    .s pogsData=^PIVA(pogId,"S",pogsId)
    .s psId=$p(pogsData,"^",2)
    .s psNum=$p($g(^PIVAS(+psId)),"^",1)
    .q:psNum'=stateNum
    .s userId=$p(pogsData,"^",3)
    .s userName=##class(PHA.PIVAS.Data.Base).UserName(userId)
    q userId_"^"_userName
}

/// description: 比较打包状态(Y\E\P为打包)
/// input:       packFlag-空为全部
/// return:      Y-符合条件
/// ##class(web.DHCSTPIVAS.Common).CheckDspPack()
ClassMethod CheckDspPack(mDspId, packStr)
{
    q:packStr="" "Y"
    q:mDspId="" "N"
    s packFlag=$p($g(^DHCOEDISQTY(mDspId)),"^",28)
    i packFlag="" s packFlag="N"
    q:packStr[packFlag "Y"
    q "N"
}

/// description: 获取病人一些基本信息,用于前台直接临时调用,可能返回不止一个值,如需用到,前台split取
ClassMethod GetAdmInfo(admId)
{
    q:admId="" ""
    s patId=$p($g(^PAADM(admId)),"^",1)
    q patId
}

/// description: 根据指标名称获取Id
/// w ##class(web.DHCSTPIVAS.Common).GetDIIIdByDesc("TPN")
ClassMethod GetDIIIdByDesc(Desc)
{
    s id=""
    &SQL(SELECT DII_RowID into :id FROM PHC_DrgIngredIndex WHERE DII_Desc=:Desc )
    q id
}

/// description: 升序排序(冒泡法)
/// w ##class(web.DHCSTPIVAS.Common).AscOrder("13352,13440,13310",",")
ClassMethod AscOrder(orderStr, del)
{
    q:orderStr="" ""
    s orderLen=$l(orderStr,del)
    s orderList=$lfs(orderStr,del)
    f i=1:1:orderLen d
    .f j=1:1:orderLen-i d
    ..i $LIST(orderList,(j+1))<$LIST(orderList,j) d
    ...s tmp=$LIST(orderList,j)
    ...s $LIST(orderList,j)=$LIST(orderList,(j+1)),$LIST(orderList,(j+1))=tmp
    q $LTS(orderList,del)
}

/// description: 获取最后有效配伍审核的Id
/// w ##class(web.DHCSTPIVAS.Common).GetValidPhaOrdId("282||44","")
ClassMethod GetValidPhaOrdId(MOeori, DoseDate)
{
    s phaOrdId=""
    s phaOrd=""
    i DoseDate="" d
    .f  s phaOrd=$o(^DHCPHORDM(0,"OrdItem",MOeori,phaOrd),-1) q:(phaOrd="")||(phaOrdId'="")  d
    ..d CheckPhaOrd
    e  d
    .f  s phaOrd=$o(^DHCPHORDM(0,"DateOrdItem",MOeori,DoseDate,phaOrd),-1) q:(phaOrd="")||(phaOrdId'="")  d
    ..d CheckPhaOrd
    q phaOrdId
CheckPhaOrd
    s phaOrdData=$g(^DHCPHORDM(phaOrd))
    q:phaOrdData=""
    q:$p(phaOrdData,"^",9)'="PIVAS"
    q:$p(phaOrdData,"^",12)'=""
    q:$p(phaOrdData,"^",2)="D"
    s phaOrdId=phaOrd
    q
}

/// Description: 判断本组是否与上组药品相同,相同则序号在上组基础+1
/// 多久时间内有效(20min),20min内登录用户无操作
/// w ##class(web.DHCSTPIVAS.Common).CalcuScanNo(1499,711,125)
ClassMethod CalcuScanNo(PogId, UserId, PsId)
{
    q:(PogId="")||(UserId="")||(PsId="") 1
    s lastSerial=$o(^PIVA(0,"SUSCAN", PsId, UserId,""),-1)
    q:lastSerial="" 1
    s lastPogId=$o(^PIVA(0,"SUSCAN", PsId, UserId, lastSerial, ""),-1)
    q:lastPogId="" 1
    s lastPogSub=$o(^PIVA(0,"SUSCAN", PsId, UserId, lastSerial, lastPogId,""),-1)
    q:lastPogSub="" 1
    s pogsData=^PIVA(lastPogId,"S",lastPogSub)
    s pogsDate=$p(pogsData,"^",4)
    q:pogsDate'=+$h 1
    s pogsTime=$p(pogsData,"^",5)
    s leaveTime=$p($h,",",2)-pogsTime
    q:leaveTime>1200 1  // 20min无响应,重新计算
    k CalcuScanNoArr
    s pogItm=""
    f  s pogItm=$o(^PIVA(lastPogId,"I",pogItm)) q:pogItm=""  d
    .s dspId=$p(^PIVA(lastPogId,"I",pogItm),"^",1)
    .s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
    .s arcItmId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",2)
    .q:arcItmId=""
    .s CalcuScanNoArr(0,arcItmId)=""
    .s CalcuScanNoArr(1,arcItmId)=""
    s diffFlag=""
    s pogItm=""
    f  s pogItm=$o(^PIVA(PogId,"I",pogItm)) q:(pogItm="")||(diffFlag'="")  d
    .s dspId=$p(^PIVA(PogId,"I",pogItm),"^",1)
    .s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
    .s arcItmId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",2)
    .q:arcItmId=""
    .i '$d(CalcuScanNoArr(0,arcItmId)) s diffFlag=1 // 不一样
    .k CalcuScanNoArr(1,arcItmId)
    q:diffFlag'="" 1
    q:$d(CalcuScanNoArr(1)) 1
    s lastScanNo=+$p(pogsData,"^",10)
    q +lastScanNo+1
}

/// description: 获取主执行记录Id,逻辑同取主医嘱
/// w ##class(web.DHCSTPIVAS.Common).GetMainOeore("230||424||2")
ClassMethod GetMainOeore(Oeore As %String) As %String
{
    Q:Oeore="" ""
    S ordId=$p(Oeore,"||",1) Q:ordId="" ""
    S ordItm=$p(Oeore,"||",2) Q:ordItm="" ""
    s ordExe=$p(Oeore,"||",3) Q:ordExe="" ""
    S linkOeore=$P($g(^OEORD(ordId,"I",ordItm,"X",ordExe,"BILL")),"^",3)
    Q:linkOeore'="" linkOeore
    Q Oeore
}

/// Description: 获取周频次对应第time用药次数的日期
/// Input:       FreqWeek(周频次),Times(第N次用药,一天为1),FirstDate(开始日期)
/// Others:      可能存在1-3-5，首周没有1的情况 
/// w ##class(web.DHCSTPIVAS.Common).GetWeekFreqTimesDate("1|3|5|7",4,"2019-10-16")
ClassMethod GetWeekFreqTimesDate(FreqWeek, Times, FirstDate)
{
    s timesDateStr=..GetWeekFreqFirstDate(FreqWeek, Times, FirstDate)
    s timesDate=$p(timesDateStr,"^",1)
    s dirtyTimes=$p(timesDateStr,"^",2)
    q:timesDate'="" timesDate   // 首周
    s firstDateH=$zdh(FirstDate,3)
    s firstDay=$zd(firstDateH,10)
    i firstDay=0 s firstDay=7
    s monday=firstDateH-firstDay+1  
    s freqWeekSt=$p(FreqWeek,"|",1)
    s newTimes=Times-dirtyTimes
    s newDate=monday+7+freqWeekSt-1
    s timesDate=..GetWeekFreqLastDate(FreqWeek, newTimes, $zd(newDate,3))
    q timesDate
}

/// Description: 获取周频次对应第time用药次数的日期,firstdate对应为FreqDate首个日期
/// Input:       可能存在1-3-5，首周没有1的情况 
/// w ##class(web.DHCSTPIVAS.Common).GetWeekFreqLastDate("1|3|5",3,"2019-10-14")
ClassMethod GetWeekFreqLastDate(FreqWeek, Times, FirstDate)
{
    s firstDateH=$zdh(FirstDate,3)
    s weekLen=$l(FreqWeek,"|")
    s rem=Times#weekLen // 余数
    s div=Times\weekLen // 整数倍
    i rem=0 d 
    .s div=div-1
    .s rem=weekLen
    s firstDay=$zd(FirstDate,10)
    i firstDay=0 s firstDay=7
    s newDate=firstDateH+(div*7)+$p(FreqWeek,"|",rem)-1
    q newDate
}

/// Description: 获取周频次对应第time用药次数的首周日期以及占用次数
/// Return:      日期^占用次数
/// w ##class(web.DHCSTPIVAS.Common).GetWeekFreqFirstDate("1|3|5",1,"2019-10-15")
ClassMethod GetWeekFreqFirstDate(FreqWeek, Times, FirstDate)
{
    s FirstDateH=$zdh(FirstDate,3)
    s weekLen=$l(FreqWeek,"|")
    s firstDay=$zd(FirstDateH,10)
    i firstDay=0 s firstDay=7
    s monday=FirstDateH-firstDay+1  
    s firstCnt=0    // 首周次数
    f i=1:1:weekLen d
    .s iDay=$p(FreqWeek,"|",i)
    .s iDate=monday+iDay-1
    .i iDate>=FirstDateH d
    ..s firstCnt=firstCnt+1
    ..s CalcuWeekFreqDate("First",firstCnt)=iDate
    q $g(CalcuWeekFreqDate("First",Times))_"^"_firstCnt
}

/// Description: 按主药溶媒排序出医嘱
/// w ##class(web.DHCSTPIVAS.Common).GetOeoriStrOrderByMP("217||27")
ClassMethod GetOeoriStrOrderByMP(MOeori, Loc = "")
{
    s oeoriStr=""
    s oeori=MOeori
    s mOrd=+MOeori
    d MGetOeoriStrOrderByMP
    s ordItm=""
    f  s ordItm=$O(^OEORDi(0,"OEORI",mOrd,MOeori,ordItm)) Q:ordItm=""  D
    .s oeori=mOrd_"||"_ordItm
    .d MGetOeoriStrOrderByMP
    s index=""
    f  s index=$o(GetOeoriStrOrderByMPD(index)) q:index=""  d
    .s ordItm=""
    .f  s ordItm=$o(GetOeoriStrOrderByMPD(index,ordItm)) q:ordItm=""  d
    ..s oeori=mOrd_"||"_ordItm
    ..s oeoriStr=$s(oeoriStr="":oeori,1:oeoriStr_"^"_oeori)
    q oeoriStr
    
MGetOeoriStrOrderByMP
    q:$p(##class(web.DHCSTPIVAS.Common).GetArcItmCatByOeori(oeori),"^",4)'="R"
    s arcItm=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),1),"^",2)
    s index=..GetOeoriOrdIndex(oeori,Loc)
    s GetOeoriStrOrderByMPD(index,$p(oeori,"||",2))=""
    q
}

/// Description: 疗程超量原因
/// w ##class(web.DHCSTPIVAS.Common).OeoriExceedReason("95||1","")
ClassMethod OeoriExceedReason(Oeori, OEORDIDHC = "")
{
    i OEORDIDHC="" s OEORDIDHC=$g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),"DHC"))
    s reasonId=$p(OEORDIDHC,"^",33)
    q:reasonId="" ""
    q reasonId_"^"_$p($g(^DHCDocExceedReason(reasonId)),"^",2)
}

/// Description: 配液中心判断是否为化疗药
/// Return:      Y(是)
ClassMethod GetChemotherapeuticByArc(Arcim)
{
    q:Arcim'["||" ""
    s phcdfId=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(Arcim)
    q:phcdfId'["||" ""
    q $p($g(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),"DHC",2)),"^",10)
}

/// Description: 获取特殊人群
/// w ##class(web.DHCSTPIVAS.Common).GetPatSpec(396)
ClassMethod GetPatSpec(AdmId)
{
    q ..GetAdmSpec(AdmId)
}

/// Description: 将剂量转为指定单位的数量(输液药品单位基本为ml\mg)
///                  当没有mg时,根据g转换
/// Input:       Oeori(医嘱Id),UomDesc(需要转换成的单位名称)
/// Return:      
/// w ##class(web.DHCSTPIVAS.Common).GetDoseEqualQtyWithUom("466||61","ml")
ClassMethod GetDoseEqualQtyWithUom(Oeori, UomDesc) As %String
{
    
    s ord=$p(Oeori,"||",1) q:ord="" ""
    s itm=$p(Oeori,"||",2) q:itm="" ""
    s doseData=$g(^OEORD(ord,"I",itm,2))
    q:doseData="" ""
    s doseQty=$p(doseData,"^",1) //剂量
    s doseUom=$p(doseData,"^",3)
    s arcim=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
    q:arcim="" ""
    q ..ConvertArcQtyUom(arcim, doseQty, doseUom, UomDesc)
}

/// Description: 将药品数量与单位向指定单位转换,用于计算剂量或者药学成分含量用
///              针对医嘱,因此药学与等效即可              
/// Input:       Arcim(医嘱项Id),Qty(数量),UomDesc(单位)
/// Return:      转换后的数量(不带单位),无转换关系返回0
/// w ##class(web.DHCSTPIVAS.Common).ConvertArcQtyUom("5545||1",1,3,"ml")
ClassMethod ConvertArcQtyUom(Arcim, Qty, QtyUomId, UomDesc)
{
    k ConvertArcQtyUomDATA
    s UomDesc=$zcvt(UomDesc,"U")
    q:UomDesc="" ""
    #; @todo 使用翻译的形式可能存在风险, 单位入参无法确定为何种语言
    s QtyUomDesc=$zcvt($p($g(^CT("UOM",+QtyUomId)),"^",2),"U")
    q:QtyUomDesc=UomDesc Qty // 单位相同
    s phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(Arcim)
    q:phcdf="" ""
    S phcdId=$P(phcdf,"||",1),phcdForm=$P(phcdf,"||",2)
    s phcBUomId=$p(^PHCD(phcdId,"DF",phcdForm,2),"^",4)
    s phcBUomDesc=$zcvt($p($g(^CT("UOM",+phcBUomId)),"^",2),"U")    
    i phcBUomDesc="G" s ConvertArcQtyUomDATA("MG")=1000
    s nQty=Qty
    s eqSub=""
    f  s eqSub=$O(^PHCD(phcdId,"DF",phcdForm,"EQ",eqSub)) q:eqSub=""  d
    .q:+eqSub=0
    .s PHCDDFEQ=$g(^PHCD(phcdId,"DF",phcdForm,"EQ",eqSub))
    .s eqUomDr=+$p(PHCDDFEQ,"^",1)
    .s eqQty=+$p(PHCDDFEQ,"^",2)
    .q:(eqUomDr=0)||(eqQty=0)
    .s eqUomDesc=$zcvt($p($g(^CT("UOM",eqUomDr)),"^",2),"U")
    .q:eqUomDesc=""
    .s ConvertArcQtyUomDATA(eqUomDesc)=eqQty
    .i (QtyUomId'=phcBUomId)&&(QtyUomId=eqUomDr) s nQty=Qty/eqQty   // 不是药学基本单位时转为药学基本单位数
    q:UomDesc=phcBUomDesc nQty  // 单位等于药学基本
    q:'$d(ConvertArcQtyUomDATA) ""
    // 转指定单位
    s nEqQty=$g(ConvertArcQtyUomDATA(UomDesc))
    q:+nEqQty=0 ""
    q nQty*nEqQty
}

/// description: 计算BMI
/// w ##class(web.DHCSTPIVAS.Common).CalcuBMI(170,65)
ClassMethod CalcuBMI(patHeight, patWeight)
{
    q:(+patHeight=0)||(+patWeight=0) ""
    q $fn(patWeight/((patHeight/100)*(patHeight/100)),"",2)
}

/// Description: 获取知识库数据,此处做数据处理验证,保证静配调用均为可用非异常数据
/// w ##class(web.DHCSTPIVAS.Common).GetLibPhaMedTips(.a)
ClassMethod GetLibPhaMedTips(ByRef MedTips, Oeori)
{
    s $zt="ErrorGetLibPhaMedTips"
    k MedTips,MedTipsI
    //s medJson={"PreMet":[],"Usage":["口服，成人一次1粒，一日2次（早晚各一次）。儿童用量请咨询医师或药师"],"Indic":["用于减轻中度疼痛，如关节痛、神经痛、肌肉痛、偏头痛、头痛、痛经、牙痛，也可用于减轻普通感冒或流行性感冒引起的发热。"],"Contr":["活动期消化性溃疡患者禁用","孕妇及哺乳期妇女禁用","阿司匹林哮喘者禁用","对非甾体类抗炎药过敏者禁用"]}
    //s medJsonStr=medJson.%ToJSON()
    s medJsonStr=##class(web.DHCSTInterfacePHCMPASS).LibPhaMedTips(Oeori,"","Q1")
    // 序列化
    s medJson={}.%FromJSON(medJsonStr)
    i medJson.%GetTypeOf("PreMet")="array" d
    .s str=..GetStrFromArray(medJson.PreMet)
    .q:str=""
    .s MedTips($i(MedTipsI),"给药途径")=str
    i medJson.%GetTypeOf("Usage")="array" d
    .s str=..GetStrFromArray(medJson.Usage)
    .q:str=""
    .s MedTips($i(MedTipsI),"用法用量")=str
    i medJson.%GetTypeOf("Indic")="array" d
    .s str=..GetStrFromArray(medJson.Indic)
    .q:str=""
    .s MedTips($i(MedTipsI),"适应症")=str
    i medJson.%GetTypeOf("Contr")="array" d
    .s str=..GetStrFromArray(medJson.Contr)
    .q:str=""
    .s MedTips($i(MedTipsI),"禁忌症")=str
    q ""
ErrorGetLibPhaMedTips
    q ""
}

ClassMethod GetStrFromArray(ArrayData, Del = ",")
{
    s retStr=""
    s iter = ArrayData.%GetIterator()
    while iter.%GetNext(.key, .value) { 
        s retStr=$s(retStr="":value,1:retStr_Del_value)
    }
    q retStr
}

/// Description: 根据审核表Id获取结果
ClassMethod GetPhaOrdResult(PhaOrdId)
{
    q:PhaOrdId="" ""
    s DHCPHORDM=$g(^DHCPHORDM(PhaOrdId))
    s phNote=$p(DHCPHORDM,"^",6)
    s phaResult=$p(DHCPHORDM,"^",2)
    s phaAgree=$p(DHCPHORDM,"^",8)
    s phaDocNote=$p(DHCPHORDM,"^",7)    
    s phaStat=""
    i phaResult="Y" s phaStat="SHTG^审核通过^"_PhaOrdId_"^Y"
    e  i phaResult="N" d
    .i phaAgree="Y" s phaStat="SHJJ^审核拒绝(接受)^"_PhaOrdId_"^NY"
    .e  s phaStat="SHJJ^审核拒绝^"_PhaOrdId_"^N"
    e  i phaResult="A" d
    .s phaStat="^医生申诉^"_PhaOrdId_"^NA"
    e  d
    .s phaStat="^^"_PhaOrdId_"^"
    q phaStat
}

/// Description: 获取药师标注Id以及标注内容
/// CreateDate:  2019-12-13
/// Creator:     yunhaibao
/// w ##class(web.DHCSTPIVAS.Common).GetPhaOrdRemark("282||44")
ClassMethod GetPhaOrdRemark(MOeori, Split = "; ")
{
    s orderRemark = ##class(web.DHCSTPIVAS.Remark).Get("PIVASOrder", MOeori)
    s executeRemark = ##class(web.DHCSTPIVAS.Remark).Get("PIVASExecute", MOeori)
    s labelRemark = ##class(web.DHCSTPIVAS.Remark).Get("PIVASLabel", MOeori)    
    q ##class(web.DHCSTPIVAS.Common).ConnactString(Split, orderRemark, executeRemark, labelRemark)
}

/// Description: 判断配液子表是否为关联医嘱
/// Return:      Y/N
/// w ##class(web.DHCSTPIVAS.Common).IsPOGLink(1)
ClassMethod IsPOGLink(POGId)
{
    q:+POGId=0 "N"
    s retFlag="N"
    s itmCnt=0
    s pogItm=0
    f  s pogItm=$o(^PIVA(POGId,"I",pogItm)) q:(pogItm="")||(retFlag="Y")  d
    .s itmCnt=itmCnt+1
    .i itmCnt>1 s retFlag="Y" 
    q retFlag
}

/// Description: 获取配液医嘱需要收取的配置费,遇其他规则再增加
/// Output:      医嘱项Id1@数量^医嘱项Id2@数量2
/// w ##class(web.DHCSTPIVAS.Common).GetPOGLinkFee(40)
ClassMethod GetPOGLinkFee(POGID)
{
    k GetPOGLinkFeeDATA
    s mDsp=$P(^PIVA(POGID),"^",1)
    s mOeori=$p(^DHCOEDISQTY(mDsp),"^",1)
    s poliID=$p(..GetOrdPivaCat(mOeori),"^",1)
    q:(poliID = "") ""
    s packFlag=..DspPackFlag(mDsp)
    s seqFlag=..IsPOGLink(POGID)
    // 大类绑定的费用
    s poliOrd=""
    f  s poliOrd=$o(^POLI(poliID,"M",poliOrd)) q:poliOrd=""  d
    .q:+poliOrd=0
    .s POLIM=$G(^POLI(poliID,"M",poliOrd))
    .s arcim=$p(POLIM,"^",1)
    .q:arcim'["||"
    .s qty=$p(POLIM,"^",4)
    .q:+qty<=0
    .s poloPack=$p(POLIM,"^",6)
    .q:(poloPack="Y")&&(packFlag'="P")
    .q:(poloPack="N")&&(packFlag="P")
    .s poloSeq=$p(POLIM,"^",7)
    .q:(poloSeq'="")&&(seqFlag'=poloSeq)
    .s GetPOGLinkFeeDATA("DATA",arcim)=qty
    // 收费规则费用
    s ruleIDStr=$p(^POLI(poliID),"^",6)
    s ruleLen=$l(ruleIDStr,",")
    f i=1:1:ruleLen d
    .q:(packFlag = "P")
    .s ruleID=$p(ruleIDStr,",",i)
    .q:ruleID=""
    .s GetPOGLinkFeeDATA("FINAL",ruleID)="" // 记录符合条件的规则
    .s ruleItm=0
    .f  s ruleItm=$o(^CF.PHA.PIVAS.FeeRule(ruleID,"I",ruleItm)) q:ruleItm=""  d
    ..s FeeRuleIData=^CF.PHA.PIVAS.FeeRule(ruleID,"I",ruleItm)
    ..s type=$p(FeeRuleIData,"^",1)
    ..s operate=$p(FeeRuleIData,"^",2)
    ..s typeVal=$p(FeeRuleIData,"^",3)
    ..// 判断是否需要取药品等条件,决定后续是否取值
    ..i type="ARCIM" d
    ...s GetPOGLinkFeeDATA("R-ARCIM")="Y"
    ...// 包含某药的并列条件,不计算该药的规格
    ...i operate="[" s GetPOGLinkFeeDATA("V-N-MLSPEC",ruleID,typeVal)=""
    ..e  i type["MLSPEC" s GetPOGLinkFeeDATA("R-MLSPEC")="Y"
    ..e  i type["MLLIQUID" s GetPOGLinkFeeDATA("R-MLLIQUID")="Y"
    ..s GetPOGLinkFeeDATA("RULE",ruleID,ruleItm)=FeeRuleIData
    .
    // 遍历医嘱明细,记录相关条件
    s pogItm=0
    f  s pogItm=$o(^PIVA(POGID,"I",pogItm)) q:pogItm=""  d
    .s dspId=$p(^PIVA(POGID,"I",pogItm),"^",1)
    .s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
    .s arcim=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),1),"^",2)
    .i $d(GetPOGLinkFeeDATA("R-MLSPEC")) d
    ..s inci=$o(^INCI(0,"ARCIM_DR",+arcim,""),-1)
    ..s bUomId=$p(^INCI(inci,1),"^",10)
    ..s mlSpec=+..ConvertArcQtyUom(arcim,1,bUomId,"ML")
    ..s GetPOGLinkFeeDATA("D-MLSPEC",mlSpec,arcim)=""
    .s GetPOGLinkFeeDATA("D-ARCIM",arcim)=""
    i $d(GetPOGLinkFeeDATA("R-MLLIQUID")) d // 计算液体量
    .s liquid=..OrderLiquid("",$p(^DHCOEDISQTY(mDsp),"^",3))
    e  s liquid=""
    // 验证规则,符合条明细k一条,最终无数据时即为符合条件,这特么不是或者吗?
    s ruleID=0
    f  s ruleID=$o(GetPOGLinkFeeDATA("RULE",ruleID)) q:ruleID=""  d
    .// 先计算医嘱内排除某些药品的最大规格
    .s mlSpec="",mlSpecIndex="" 
    .f  s mlSpecIndex=$o(GetPOGLinkFeeDATA("D-MLSPEC",mlSpecIndex),-1) q:(mlSpecIndex="")||(mlSpec'="")  d
    ..s arcimIndex=""
    ..f  s arcimIndex=$o(GetPOGLinkFeeDATA("D-MLSPEC",mlSpecIndex,arcimIndex)) q:(arcimIndex="")||(mlSpec'="")  d
    ...q:$d(GetPOGLinkFeeDATA("V-N-MLSPEC",ruleID,arcimIndex))
    ...s mlSpec=mlSpecIndex
    .s mlSpec=+mlSpec
    .s ruleItm=0
    .f  s ruleItm=$o(GetPOGLinkFeeDATA("RULE",ruleID,ruleItm)) q:ruleItm=""  d
    ..s ruleItmData=GetPOGLinkFeeDATA("RULE",ruleID,ruleItm)
    ..s type=$p(ruleItmData,"^",1)
    ..s operate=$p(ruleItmData,"^",2)
    ..s typeVal=$p(ruleItmData,"^",3)
    ..i (type="ARCIM")&&(operate="[")&&($d(GetPOGLinkFeeDATA("D-ARCIM",typeVal))) d
    ...k GetPOGLinkFeeDATA("RULE",ruleID,ruleItm)
    ..i (type="ARCIM")&&(operate="]")&&('$d(GetPOGLinkFeeDATA("D-ARCIM",typeVal))) d
    ...k GetPOGLinkFeeDATA("RULE",ruleID,ruleItm)
    ..i (type="MLSPECMIN")&&(operate=">=")&&(mlSpec>=typeVal) d
    ...k GetPOGLinkFeeDATA("RULE",ruleID,ruleItm)
    ..i (type="MLSPECMAX")&&(operate="<")&&(mlSpec<typeVal) d
    ...k GetPOGLinkFeeDATA("RULE",ruleID,ruleItm)
    ..i (type="MLLIQUIDMIN")&&(operate=">=")&&(+liquid>=typeVal) d
    ...k GetPOGLinkFeeDATA("RULE",ruleID,ruleItm)
    ..i (type="MLLIQUIDMAX")&&(operate="<")&&(+liquid<typeVal) d
    ...k GetPOGLinkFeeDATA("RULE",ruleID,ruleItm)
    .i $d(GetPOGLinkFeeDATA("RULE",ruleID)) k GetPOGLinkFeeDATA("FINAL",ruleID)
    s ruleID=""
    f  s ruleID=$o(GetPOGLinkFeeDATA("FINAL",ruleID)) q:ruleID=""  d
    .s ruleLink=0
    .f  s ruleLink=$o(^CF.PHA.PIVAS.FeeRule(ruleID,"L",ruleLink)) q:ruleLink=""  d
    ..s FeeRuleLData=^CF.PHA.PIVAS.FeeRule(ruleID,"L",ruleLink)
    ..s arcim=$p(FeeRuleLData,"^",1)
    ..s qty=$p(FeeRuleLData,"^",2)
    ..i $d(GetPOGLinkFeeDATA("DATA",arcim)) d
    ...s GetPOGLinkFeeDATA("DATA",arcim)=GetPOGLinkFeeDATA("DATA",arcim)+qty
    ..e  s GetPOGLinkFeeDATA("DATA",arcim)=qty
    s retStr=""
    s arcim=""
    f  s arcim=$o(GetPOGLinkFeeDATA("DATA",arcim)) q:arcim=""  d
    .s qty=+GetPOGLinkFeeDATA("DATA",arcim)
    .q:qty<=0
    .s data=arcim_"@"_qty
    .s retStr=$s(retStr="":data,1:retStr_"^"_data)
    q retStr
}

/// Description: 是否护士已处理医嘱(接受、完成)
/// Return:      ^1:是否允许流程继续(N不允许)-拒绝不允许,如果住院药房科室配置设置需医嘱处理,则需要接受或完成可继续流程
///              ^2:医嘱处理状态(R\A\F\U)-U撤销处理
///              ^3:医嘱处理状态(护士拒绝、护士接受、护士完成)
/// Debug:       w ##class(web.DHCSTPIVAS.Common).GetNurseSeeType("53||112",248)
ClassMethod GetNurseSeeType(Oeori, LocId)
{
    q:Oeori="" ""
    s phaLocId=$o(^DHCPL(0,"Loc",LocId,""))
    s dealOrdFlag=$p($g(^DHCPL(+phaLocId)),"^",37)
    s seeFlag=""
    s seeType=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),"NUR")),"^",7)
    i seeType="U" s seeType=""
    s seeTypeDesc=$case(seeType,"A":"接受","F":"完成","R":"拒绝",:"未处理")
    i seeType="R" s seeFlag="N"
    i (dealOrdFlag="Y") d
    .i "AF"'[seeType s seeFlag="N"
    .i seeType="" s seeFlag="N"
    q seeFlag_"^"_seeType_"^"_seeTypeDesc
}

/// Description: 判断多药的条件
/// Input:       num - 1,2,3:指品种数,n:多药(大于1,2,3中的最大值的)
/// Return:      Y - 满足
ClassMethod FilterOrdDrugs(mOeori, num)
{
    s maxNum=3
    q:num="" "Y"
    s drugsNum = ..GetOrdDrugsNum(mOeori)
    q:(num '= "")&&(num '= "n")&&(num '= drugsNum) "N"
    q:(num = "n")&&(drugsNum<maxNum) "N"
    q "Y"
}

/// Description: 医嘱品种数 - 注意可能存在相同医嘱
ClassMethod GetOrdDrugsNum(mOeori)
{
    k GetOrdDrugsNumData
    s num = 0
    s arcim = $p($g(^OEORD(+mOeori, "I", $p(mOeori, "||", 2), 1)), "^", 2)
    i ..IsDrug(arcim) = "Y" d
    .s GetOrdDrugsNumData(arcim) = ""
    .s num = num + 1
    s ordItm =""
    f  s ordItm = $O(^OEORDi(0, "OEORI", +mOeori ,mOeori, ordItm)) q:ordItm=""  d
    .s oeori = +mOeori _ "||" _ ordItm
    .s arcim = $p($g(^OEORD(+mOeori, "I", ordItm, 1)), "^", 2)
    .q:..IsDrug(arcim)'="Y"
    .q:$d(GetOrdDrugsNumData(arcim))
    .s GetOrdDrugsNumData(arcim) = ""
    .s num=num+1
    q num
}

ClassMethod IsDrugDsp(dsp)
{
    s oeori = $p(^DHCOEDISQTY(dsp), "^", 1)
    s arcim = $p($g(^OEORD(+oeori, "I", $p(oeori, "||", 2), 1)), "^", 2)
    q ..IsDrug(arcim)
}

/// Description: 医嘱项是否为药品
ClassMethod IsDrug(arcim)
{
    s cat = $p($g(^ARCIM(+arcim, +$p(arcim, "||" ,2), 1)), "^", 10)
    q:cat="" ""
    q:$p($g(^ARC("IC", +cat)), "^", 7)="R" "Y"
    q ""
}

/// Description: 特殊人群
ClassMethod GetAdmSpec(adm)
{
    s mrAdm = $p(^PAADM(adm), "^", 61)  
    s specList = $p($g(^MR(mrAdm,"DHC")), "^", 8)
    s specStr = ""
    f i = 1 : 1 : $l(specList, "!") d
    .s specId = $p(specList, "!", i)
    .i specId = "" q
    .s specDesc = ##class(PHA.PIVAS.Data.Base).SpecialCrowdDesc(specId)
    .s specStr = $s(specStr = "" : specDesc, 1 : specStr _ " , " _ specDesc)
    q specStr
}

/// Description: 流程字典
/// Debug:       w ##class(web.DHCSTPIVAS.Common).MakePSDict(802,.PSDict)
ClassMethod GetPSDict(loc, Output GetPSDictData)
{
    k GetPSDictData
    s psNumber=""
    f  s psNumber=$o(^PIVAS(0,"LOCTYPENUMBER",loc,"I",psNumber)) q:psNumber=""  d
    .s psId=""
    .f  s psId=$o(^PIVAS(0,"LOCTYPENUMBER",loc,"I",psNumber,psId)) q:psId=""  d
    ..q:+psId=0
    ..s PIVAS=^PIVAS(psId)
    ..q:$p(PIVAS,"^",3)'="Y"
    ..q:$p(PIVAS,"^",5)="Y"
    ..s GetPSDictData("DICT",psNumber)=psId     // 配液流程
    ..i $p(PIVAS,"^",10)'="Y" d 
    ...s GetPSDictData("PACKDICT",psNumber)=psId    // 打包流程
    q 0
}

/// Description: 条码转换为执行记录Id
ClassMethod BarCodeToOeore(barCode)
{
    s barCode = $p(barCode, "-", 1, 3)
    q $replace(barCode,"-","||")
}

/// Description: 条码转换为配液表Id
ClassMethod BarCodeToPog(barCode)
{
    s oeore=..BarCodeToOeore(barCode)
    q:oeore="" ""
    s dsp = $o(^DHCOEDISQTY(0, "OEORE", oeore, ""))
    q:dsp="" ""
    s pog = $o(^PIVA(0, "DSP", dsp, 0))
    q pog
}

/// Description: 执行记录Id转换为条码
ClassMethod OeoreToBarCode(oeore)
{
    q $replace(oeore,"||","-")
}

/// Description: 某药是否在配液医嘱内
/// w ##class(web.DHCSTPIVAS.Common).IsInciInPog(1523)
ClassMethod IsInciInPog(pog, inci)
{
    q:inci="" "Y"
    s ret = "N"
    s pogItm = ""
    f  s pogItm = $o(^PIVA(pog, "I", pogItm)) q:(pogItm = "")||(ret = "Y")  d
    .s dspId = $p(^PIVA(pog, "I", pogItm), "^", 1)
    .s oeori = $p(^DHCOEDISQTY(dspId), "^", 1)
    .s arcim = $p($g(^OEORD(+oeori, "I", $p(oeori, "||", 2), 1)), "^", 2)
    .s itmInci = $o(^INCI(0, "ARCIM_DR", +arcim, ""))
    .i inci = itmInci s ret = "Y"
    q ret
}

/// Description: 某药是否在关联医嘱内
/// w ##class(web.DHCSTPIVAS.Common).IsInciInOrder()
ClassMethod IsInciInOrder(mOeori, inci)
{
    q:(inci = "") "Y"
    s arcim = $p(^INCI(inci, 1), "^", 3)
    q:(arcim = $p($g(^OEORD(+mOeori, "I", $p(mOeori, "||", 2), 1)), "^", 2)) "Y"    
    s ret = "N"
    s itm = 0
    for {
        q:(ret = "Y")
        s itm = $o(^OEORDi(0, "OEORI", +mOeori, mOeori, itm))
        q:(itm = "")
        i arcim = $p($g(^OEORD(+mOeori, "I", +itm, 1)), "^", 2) s ret = "Y"
    }
    q ret
}

ClassMethod GetPogItmCnt(pog)
{
    s i = 0
    s itm = 0
    f  s itm = $o(^PIVA(pog, "I", itm)) q:itm=""  d
    .s i = i + 1
    q i
}

ClassMethod IsQtyEnough(loc, inci, qty)
{
    s chl = $o(^INCI("IL_LOC", loc, inci, ""))
    q:chl="" "N"
    s ret = ##class(web.DHCSTSTKQTY).GetPhaQty(inci _ "||" _ chl, qty)
    q:ret=1 "Y"
    q "N"
}

ClassMethod GetSignNum(cnt, num)
{
    q:cnt=1 ""
    q:(cnt = num) 1
    q:(num = 1) -1
    q 0
}

ClassMethod GetWorkTypeByPog(pog)
{
    s pogData = $g(^PIVA(pog))
    s workType = $p(pogData, "^", 24)
    q:(workType '= "")&&($d(^PIVAWT(workType))) workType
    s mDsp = $p(pogData, "^", 1)
    s mOeore = $p(^DHCOEDISQTY(mDsp), "^", 3)
    q $p(..OrdWorkType(mOeore),"^",1)
}

/// Description: 取药品显示顺序     
ClassMethod GetOeoriOrdIndex(oeori, loc)
{
    s sign = 2
    s arcim = $p($g(^OEORD(+oeori, "I", +$p(oeori,"||",2), 1)), "^", 2)
    s typeIndex = ..GetDrugTypeIndex(arcim)
    i typeIndex = "" s typeIndex = $p(oeori, "||", 2)*1000
    s inci = $o(^INCI(0, "ARCIM_DR", +arcim, ""))
    s ordCode = ..GetIncilOrdCode(inci, loc)
    i ordCode '= "" s sign = 1
    i ordCode = "" s ordCode = $$$MaxStr
    s index = sign _ " || " _  $j(ordCode, 10) _ " " _ $j(typeIndex, 10)
    q index
}

ClassMethod GetDrugTypeIndex(arcim)
{
    s phcdf = $p(^ARCIM(+arcim, +$p(arcim, "||", 2), 1), "^", 12)
    s phcd = +phcdf
    s sub = +$p(phcdf, "||", 2)
    s menstruumFlag = $p($g(^PHCD(phcd, "DF", sub, "DHC")), "^", 44)
    i menstruumFlag '= "Y" s menstruumFlag = ""
    s drugType = $p($g(^PHCD(phcd, "DF", sub, "DHC")), "^", 18)
    s drugType = $s(+drugType '= 0: $p($g(^DHCSTSCDI(+drugType)), "^", 1), 1: "")
    q:(drugType = "P") 1
    q:(menstruumFlag = "Y") 2
    q ""
}

ClassMethod GetIncilOrdCode(inci, loc)
{
    s inciCh = $o(^INCI("IL_LOC", loc, inci, ""))
    q:(inciCh = "") ""
    s incil = inci _ "||" _ inciCh
    s dhcIncil = $o(^DHCINCIL(0, "INCIL", incil, ""))
    q:(dhcIncil = "") ""
    q $p($g(^DHCINCIL(dhcIncil, "PIVAS")), "^", 4)
}

/// Description: 获取排序后的医嘱ID信息
/// Debug:       w ##class(web.DHCSTPIVAS.Common).GetSortedOeoreLB("102||67||3")
ClassMethod GetSortedOeoreLB(mOeore)
{
    k calcData
    s mOrd = +mOeore
    s oeore = mOeore
    d SetSortedOeoreArr
    s itm = ""
    f  s itm = $o(^OEORDi(0, "OEORE", mOeore, mOrd, itm)) q:itm=""  d
    .s exe = ""
    .f  s exe = $o(^OEORDi(0, "OEORE", mOeore, mOrd, itm, exe)) q:exe=""  d
    ..s oeore = mOrd _ "||" _ itm _ "||" _ exe
    ..d SetSortedOeoreArr
    s retLB = ""
    s ordCodeIndex = ""
    f  s ordCodeIndex = $o(calcData(ordCodeIndex)) q:ordCodeIndex=""  d
    .s num = ""
    .f  s num = $o(calcData(ordCodeIndex, num)) q:num=""  d
    ..s oeore = $g(calcData(ordCodeIndex, num))
    ..s retLB = retLB _ $lb(oeore)
    q retLB
SetSortedOeoreArr
    s oeori = $p(oeore, "||", 1, 2)
    q:($p(..GetArcItmCatByOeori(oeori), "^", 4) '= "R")
    s dsp = $o(^DHCOEDISQTY(0, "OEORE", oeore, 0))
    q:(dsp = "")
    s recLoc = $p(^DHCOEDISQTY(dsp), "^", 24)
    s ordCodeIndex = ..GetOeoriOrdIndex(oeori, recLoc)
    s calcData(ordCodeIndex, $i(GetSortedOeoreArr)) = oeore
    q
}

ClassMethod GetSortedOeoreLBByPog(pog)
{
    s retLB = ""
    s itm = 0
    f  s itm = $o(^PIVA(pog, "I", itm)) q:itm=""  d
    .s dsp = $p(^PIVA(pog, "I", itm), "^", 1)
    .s dspData = $g(^DHCOEDISQTY(dsp))
    .s oeore = $p(dspData, "^", 3)
    .s retLB = retLB _ $lb(oeore)
    q retLB
}

/// w ##class(web.DHCSTPIVAS.Common).GetOeoreStrByPog()
ClassMethod GetOeoreStrByPog(pog)
{
    s retStr = ""
    s itm = 0
    f  s itm = $o(^PIVA(pog, "I", itm)) q:itm=""  d
    .s dsp = $p(^PIVA(pog, "I", itm), "^", 1)
    .s dspData = $g(^DHCOEDISQTY(dsp))
    .s oeore = $p(dspData, "^", 3)
    .s dspQty = $p(dspData, "^", 5)
    .i (retStr = "") d
    ..s retStr = oeore_$c(2)_dspQty
    .e  d
    ..s retStr = retStr _"^"_ oeore_$c(2)_dspQty
    q retStr
}

ClassMethod GetDrugsArr(oeoreLB, qtyFlag = "") As %DynamicArray
{
    s retArr=[]
    q:(oeoreLB = "") retArr
    s len = $ll(oeoreLB)
    f i = 1 : 1 : len d
    .s oeore = $lg(oeoreLB, i)
    .q:(oeore = "")
    .s dsp = $o(^DHCOEDISQTY(0, "OEORE", oeore, 0))
    .q:(dsp = "")
    .s dspData = ^DHCOEDISQTY(dsp)
    .s oeori = $p(dspData, "^", 1)
    .s oeore = $p(dspData, "^", 3)
    .s qty = $fn($p(dspData,"^",11), "N")
    .s inciStr =  ..GetIncItmByOeori(oeori, "")
    .s inciDesc = $p(inciStr, "^", 3)
    .i inciDesc = "" q
    .s inci = $p(inciStr, "^", 1)
    .s bUom = $p(^INCI(inci, 1), "^", 10)
    .s bUomDesc = ##class(PHA.PIVAS.Data.Base).UomDesc(bUom)
    .i ($g(%zwebDHCSTPIVASCommon("IsOeoriDosage")) = $$$YES)  s dosage = ..OeoriDosage($p(oeori, "||", 1, 2))
    .e  s dosage = ..OeoreDosage(oeore)
    .s priCode= $p(..OeoriPriority(oeori),"^",2)
    .s compFlag = ..DosageCompFlag(oeori, bUom)
    .s skinTest=$p(##class(web.DHCSTCOMMONORDER).OeoriSkinTest(oeori),"^",2)
    .s oeoriRemark = ..OeoriRemark(oeori)
    .s arcim = $p(^INCI(inci, 1), "^", 3)
    .s drugType = ..GetDrugType(arcim)
    .i (drugType [ "Y")&&(qty > 1) s moreFlag = "Y"
    .e  s moreFlag = "" 
    .s inciObj = {}
    .s inciObj.inciDesc = inciDesc
    .s inciObj.dosage = dosage
    .s inciObj.omFlag = $s(priCode [ "ZT" : "ZT" ,  priCode [ "OM" : "OM" , 1 : "")
    .s inciObj.skinTest = skinTest
    .s inciObj.moreFlag = moreFlag
    .s inciObj.compFlag = compFlag
    .s inciObj.ordRemark = oeoriRemark
    .s inciObj.qtyUom = qty_bUomDesc
    .d retArr.%Push(inciObj)
    q retArr
}

/// w ##class(web.DHCSTPIVAS.Common).GetPogDrugsArr()
ClassMethod GetPogDrugsArr(pog, qtyFlag = "")
{
    s oeoreLB = ..GetSortedOeoreLBByPog(pog)
    q ..GetDrugsArr(oeoreLB, qtyFlag).%ToJSON()
}

/// w ##class(web.DHCSTPIVAS.Common).GetOeoreDrugsArr("180||80||1")
ClassMethod GetOeoreDrugsArr(mOeore, qtyFlag = "")
{
    s oeoreLB = ..GetSortedOeoreLB(mOeore)
    q ..GetDrugsArr(oeoreLB, qtyFlag).%ToJSON()
}

/// Description: 执行记录状态
ClassMethod OeoreStat(oeore As %String) As %String
{
    s ord = $p(oeore, "||", 1)
    s itm = $p(oeore, "||", 2)
    s exe = $p(oeore, "||", 3)
    s status = $p(^OEORD(ord, "I", itm, "X", exe), "^", 16)
    q:(status = "") "^" _ ##class(PHA.COM.Base).Get("未执行")
    s statusData = $g(^OEC("STAT", +status))
    q $p(statusData, "^", 1, 2)
}

/// Description: 获取配置费
/// w ##class(web.DHCSTPIVAS.Common).GetLinkFeeAmt(1)
ClassMethod GetLinkFeeAmt(pog)
{
    s loc = $p(^PIVA(pog), "^", 7)
    s hosp = $p(^CTLOC(loc), "^", 22)
    s retAmt = 0
    s link = 0
    f  s link = $o(^PIVA(pog, "O", link)) q:link=""  d
    .s oeori = $p(^PIVA(pog, "O", link), "^", 1)
    .s oeoriStat = $p($g(^OEORD(+oeori, "I", +$p(oeori, "||", 2), 1)), "^", 13)
    .q:(oeoriStat = "")
    .s oeoriStatCode = $p($g(^OEC("OSTAT", +oeoriStat)), "^", 1)
    .q:(oeoriStatCode '= "V")&&(oeoriStatCode '= "E")
    .s arcim = $p($g(^OEORD(+oeori, "I", +$p(oeori,"||",2),1)), "^", 2)
    .s qty = $P(^OEORD(+oeori, "I", +$p(oeori, "||", 2), 1), "^", 12)
    .s oeoriDate = $P(^OEORD(+oeori, "I", +$p(oeori, "||", 2), 3), "^", 7)
    .s sp = ..GetArcimSp(arcim, oeoriDate, hosp)
    .s spAmt = sp * qty
    .s retAmt = retAmt + spAmt
    q retAmt
}

/// Description: 根据医嘱项取收费项价格
ClassMethod GetArcimSp(arcim, date, hosp)
{
    s pIndex = $lb("GetArcimSp", arcim, date, hosp), ret = ""
    q:($d($$$PIVASVAR(pIndex), ret)) ret
    
    s tar = ..GetTarByArcim(arcim, date)
    if (tar '= ""){
        s sp = ..GetTarSp(tar,date,hosp)
        s ret = sp
    }
    
    s $$$PIVASVAR(pIndex) = ret
    q ret
}

/// Description: 根据医嘱项取收费项
ClassMethod GetTarByArcim(arcim, date)
{
    s tar=$o(^DHCOLT(0,"ARTTA",arcim,"")) 
    q tar
}

/// Description: 取某日医嘱项对应的收费项的价格
ClassMethod GetTarSp(tar, date, hosp)
{
    s spStr=##class(web.UDHCJFPRICE).GetItmPrice(tar, date, "", "", "", hosp, "")
    q $p(spStr,"^",1)
}

/// Description: 科室是否存在于某科室组
ClassMethod IsInLocGrp(locGrp, loc)
{
    q:(locGrp = "")||(loc = "") ""
    q:$d(^DHCSLG(0,"LOC",loc,locGrp)) "Y"
    q ""
}

/// Description: 获取批次修改类型
/// Return:      U - 用户修改, S - 系统排批
ClassMethod GetBatUpdType(mDsp)
{
    s seqNo = $p(^DHCOEDISQTY(mDsp), "^", 4)
    s pbu = $o(^PIVABU(0, "OEGRP", mDsp, seqNo, ""), -1)
    q:(pbu = "") ""
    s remark = $p($g(^PIVABU(pbu)),"^",8)
    q:(remark [ "用户修改") "U"
    q:(remark [ "系统修改") "S" 
    q:(remark [ "延迟")&&(remark [ "护士") "N"
    q ""
}

/// Description: 是否允许修改批次
/// Return:      Y - 允许
ClassMethod CanBatNoUpdate(mDsp)
{
    s pog = $o(^PIVA(0, "DSP", mDsp, ""))
    q:(pog = "") "Y"
    s ps = $p(^PIVA(pog), "^", 6)
    s psNumber = $p($g(^PIVAS(ps)),"^",1)
    q:(psNumber >= 60) "N"
    q "Y"
}

/// Description: 获取床位所在楼层
ClassMethod GetBedFloor(bed)
{
    s room = $p($g(^PAWARD(+bed ,"BED", +$p(bed, "||", 2))), "^", 3)
    q:(+room = 0) ""
    s floor = $p($g(^PAROOM(room)), "^", 11)
    q:(+floor = 0) ""
    s floorDesc= $p($g(^CT("CTLB", +floor, "Floor", +$p(floor, "||", 2))), "^", 1)
    q $lb(floor, floorDesc)
}

/// Description: 医嘱是否为药品
ClassMethod IsDrugOrder(oeori)
{
    q:'$d(^DHCOEDISQTY(0,"OEORI",oeori)) ""
    s arcim = $p($g(^OEORD(+oeori, "I", +$p(oeori, "||", 2), 1)), "^", 2)
    q ..IsDrug(arcim)
}

ClassMethod GetMainDrugOeori(oeori)
{
    s mOeori = ..GetMainOeori(oeori)
    q:(..IsDrugOrder(mOeori) = "Y") mOeori 
    s ret = ""
    s ord = +mOeori, itm = 0
    for {
        s itm = $o(^OEORDi(0, "OEORI", ord, mOeori, itm))
        q:(itm = "")
        if (..IsDrugOrder(ord _ "||" _ itm) = "Y"){
            return ord _ "||" _ itm
        }
    }
    q ""
}

/// Description: 医嘱是否已经发药
ClassMethod IsOrderDisped(pog)
{
    q ..GetOrderDspStatus(pog, "C")
}

/// Description: 医嘱是否已经退药
/// w ##class(web.DHCSTPIVAS.Common).IsOrderReturned(122105)
ClassMethod IsOrderReturned(pog)
{
    q ..GetOrderDspStatus(pog, "R")
}

ClassMethod GetOrderDspStatus(pog, status)
{
    s itm = 0
    for {
        s itm = $o(^PIVA(pog, "I", itm), 1, data)
        q:(itm = "")
        s dsp = $p(data, "^", 1)
        s dspData = $g(^DHCOEDISQTY(dsp))
        s oeori = $p(dspData, "^", 1)
        s oeore = $p(dspData, "^", 3)
        continue:(..OeoriPriority(oeori) [ "OM")
        if (status = "R"){
            s lastDsp = $o(^DHCOEDISQTY(0, "OEORE", oeore, ""), -1)
            s dspData = $g(^DHCOEDISQTY(lastDsp))
        }
        if ($p(dspData, "^", 7) = status) {
            return "Y"
        }
    }
    q "N"
}

/// Description: 获取第一个不是自备药的执行记录ID
ClassMethod GetNotOMOeore(mOeore)
{
    s oeoreLB = ..GetOeoreLB(mOeore)
    for i = 1 : 1 : $ll(oeoreLB){
        s oeore = $lg(oeoreLB, i)
        s oeori = $p(oeore, "||", 1, 2)
        if (..OeoriPriority(oeori) '[ "OM") {
            return oeore
        }
    }
    q ""
}

/// Description: 以某固定分隔符拼接多个字符
/// Debug:       w ##class(web.DHCSTPIVAS.Common).ConnactString("; ", 1,2,3,4)
ClassMethod ConnactString(split = ",", pArgs...)
{
    s ret = ""
    for i = 1 : 1 : pArgs {
        s str = pArgs(i)
        continue:(str = "")
        s ret = $s(ret = "" : str , 1 : ret _ split _ str)
    }
    q ret
}

/// Description: 获取药品医嘱成组执行记录
ClassMethod GetOeoreLB(mOeore)
{
    s retLB = ""
    s mOrd = +mOeore
    s oeore = mOeore
    d SetOeoreArr
    s itm = ""
    f  s itm = $o(^OEORDi(0, "OEORE", mOeore, mOrd, itm)) q:itm=""  d
    .s exe = ""
    .f  s exe = $o(^OEORDi(0, "OEORE", mOeore, mOrd, itm, exe)) q:exe=""  d
    ..s oeore = mOrd _ "||" _ itm _ "||" _ exe
    ..d SetOeoreArr
    q retLB
SetOeoreArr
    s oeori = $p(oeore, "||", 1, 2)
    q:($p(..GetArcItmCatByOeori(oeori), "^", 4) '= "R")
    s dsp = $o(^DHCOEDISQTY(0, "OEORE", oeore, 0))
    q:(dsp = "")
    s retLB = retLB _ $lb(oeore)
    q
}

/// Description: 符合条件的自动打包
ClassMethod NeedPack(mOeore)
{
    s oeoreLB = ..GetOeoreLB(mOeore)
    for i = 1 : 1 : $ll(oeoreLB){
        s oeore = $lg(oeoreLB, i)
        s oeori = $p(oeore, "||", 1, 2)
        if (..OeoriPriority(oeori) [ "OM") {
            return "Y"
        }
    }
    q ""
}

/// Description: list中是否包含数据,无序
/// Debug:       w ##class(web.DHCSTPIVAS.Common).IsListContains($lb(7,19),$lb(7))
ClassMethod IsListContains(origList, conList)
{
    q:(conList = "")||(origList = "") "N"
    s origLen = $ll(origList)
    s conLen = $ll(conList)
    q:(conLen > origLen) "N"
    for i = 1 : 1 : conLen {
        s str = $lg(conList, i)
        if ($lf(origList, str) = 0){
            return "N"
        }
    }
    q "Y"
}

/// Description: 获取年龄, 转换为岁
/// Output:      Float
/// Debug:       w ##class(web.DHCSTPIVAS.Common).GetAgeNum(198)
ClassMethod GetAgeNum(adm)
{
    q:($d(%DHCSTPIVASCommon(adm), ret)) ret 
    s age = ##class(PHA.FACE.IN.Com).GetAge($p($g(^PAADM(adm)), "^", 1), adm)
    s age = ..AgeToNum(age)
    s %DHCSTPIVASCommon(adm) = age
    q age
}

/// Description: 年龄转数字形式,用于计算大类和配置费,主要用于儿童判断, 天以30算 (其实用不上)
/// Debug:       w ##class(web.DHCSTPIVAS.Common).AgeToNum("8岁6月18天")
///              w ##class(web.DHCSTPIVAS.Common).AgeToNum("8岁30天")
///              w ##class(web.DHCSTPIVAS.Common).AgeToNum("6月18天")
ClassMethod AgeToNum(age)
{
    q:(+age = 0) ""
    s ret = 0
    if (age [ "岁") {
        s ret = ret + $p(age, "岁", 1)
    }
    if (age [ "月") {
        s tmp = $p(age, "月", 1)
        if (tmp [ "岁"){
            s tmp = $p(tmp, "岁", 2)
        }
        s ret = ret + (tmp / 12)
    }   
    if (age [ "天") {
        s tmp = $p(age, "天", 1)
        if (tmp [ "岁"){
            s tmp = $p(tmp, "岁", 2)
        }
        if (tmp [ "月"){
            s tmp = $p(tmp, "月", 2)
        }
        s ret = ret + (tmp / 30 / 12)
    }
    q +$fn(ret, "N", 4)
}

ClassMethod MaxDecimal(decimal, num)
{
    q:(num '[ ".") decimal
    s tmpDecimal = $l($p(num, ".", 2))
    if (tmpDecimal > decimal){
        return tmpDecimal
    }
    q decimal
}

/// Description: 取减库标识
/// Return:      80^90
/// w ##class(web.DHCSTPIVAS.Common).GetDispPsStr(89,"I")
ClassMethod GetDispPsStr(loc, type)
{
    &SQL(
        SELECT PS_Number INTO :psNumber1 FROM PIVA_State WHERE PS_Loc_Dr = :loc AND PS_TypeFlag = :type AND PS_DispFlag = 'Y'
    )
    &SQL(
        SELECT PS_Number INTO :psNumber2 FROM PIVA_State WHERE PS_Loc_Dr = :loc AND PS_TypeFlag = :type AND PS_PackDisp = 'Y'
    )
    q psNumber1 _ "^" _ psNumber2
}

/// Description: 获取此流程是否需要收配置费
/// Debug:       w ##class(web.DHCSTPIVAS.Common).GetPsFeeFlag(123,80)
ClassMethod GetPsFeeFlag(loc, psNumber)
{
    q:(psNumber = "") ""
    s ps = $o(^PIVAS(0, "LOCTYPENUMBER", loc, "I", psNumber, ""))
    q:(ps = "") ""  
    q $p($g(^PIVAS(ps)), "^", 12)
}

/// Description: 获取收费规则的关联关系
/// Return:      AND OR
/// Debug:       w ##class(web.DHCSTPIVAS.Common).GetFeeRuleRelation(5)
ClassMethod GetFeeRuleRelation(rule)
{
    s itm = $o(^CF.PHA.PIVAS.FeeRule(rule, "I", 0), 1, itmData)
    q:(itm = "") "AND"
    s relation = $p(itmData, "^", 4)
    if (relation = ""){
        s relation = "AND"
    }
    q relation
}

/// Description: 获取医嘱全部备注
ClassMethod GetOrderRemark(mOeori)
{
    s ret = ""
    s remark = ..OeoriRemark(mOeori)
    if (remark '= ""){
        s ret = ret _ $lb(remark)
    }
    s itm = 0
    for {
        s itm = $o(^OEORDi(0, "OEORI", +mOeori, mOeori, itm)) q:(itm = "")
        s oeori = +mOeori _ "||" _ itm
        s remark = ..OeoriRemark(mOeori)
        if (remark '= "")&&($lf(ret, remark) = 0){
            s ret = ret _ $lb(remark)
        }
    }
    q $lts(ret, ";")
}

/// Description: 仅用于静配调用知识库前的获取药品代码和名称
/// Debug:       w ##class(web.DHCSTPIVAS.Common).GetOrdInciArrJson("828||101")
ClassMethod GetOrdInciArrJson(mOeori)
{
    s ret = []
    s ord = +mOeori
    s setOeori = mOeori
    d SetGetOrdInciArrJson
    s itm = 0
    for {
        s itm = $o(^OEORDi(0, "OEORI", +mOeori, mOeori, itm)) q:(itm = "")
        s setOeori = ord _ "||" _ itm
        d SetGetOrdInciArrJson
    }   
    q ret.%ToJSON()
SetGetOrdInciArrJson
    q:(..IsDrugOrder(setOeori) '= "Y")
    s arcim = $p($g(^OEORD(ord, "I", $p(setOeori, "||", 2), 1)), "^", 2)
    q:(arcim = "")
    s inci = $o(^INCI(0, "ARCIM_DR", +arcim, ""))
    q:(inci = "")
    s rowData = {}
    s rowData.inciCode = $p($g(^INCI(inci, 1)), "^", 1)
    s rowData.inciDesc = $P($g(^INCI(inci, 1)), "^", 2)
    d ret.%Push(rowData)
    q
}

/// Description: 获取自动打包的批次
/// Debug:      w ##class(web.DHCSTPIVAS.BatUpdate).GetAutoPackBatNoList(89)        
ClassMethod GetAutoPackBatNoList(pLoc)
{
    s ret = ""
    &SQL( 
        DECLARE cBatNo CURSOR FOR 
        SELECT PBT_BatNo
        FROM PIVA_BatTime WHERE PBT_Ctloc_Dr = :pLoc AND PBT_AutoPack = 'Y'
    )
    &SQL(OPEN cBatNo)
    for {
        &SQL(FETCH cBatNo into :batNo) q:(SQLCODE '= 0)
        s ret = ret _ $lb(batNo)
    } 
    &SQL(CLOSE cBatNo) 
    q ret
}

/// Description: 收费上限,决定是否需要收取费用,如果超限则收取至上限即停止
///              LnkOrdStr 是已经汇总后的数量合计了
/// Debug:       w ##class(web.DHCSTPIVAS.Common).FiltFeeLimit("24659||1@1",34700383,65441,"2")
ClassMethod FiltFeeLimit(lnkOrdStr, ord, dateH, hosp)
{
    k calcData
    s len = $l(lnkOrdStr, "^")
    for i = 1 : 1 : len {
        s lnkOrd = $p(lnkOrdStr, "^", i)
        continue:(lnkOrd = "")
        s arcim = $p(lnkOrd, "@", 1)
        s qty = $p(lnkOrd, "@", 2)
        continue:(+qty = 0)
        continue:(arcim '[ "||")
        s feeCfg = $o(^CF.PHA.PIVAS.FeeCfgi("Arcim",arcim,""))
        if (feeCfg = ""){
            /* 没限制, 按原规则收 */
            s calcData(arcim) = qty
        }else{
            s maxTimes = $lg(^CF.PHA.PIVAS.FeeCfg(feeCfg), 3)
            if (maxTimes = ""){
                s calcData(arcim) = qty
            }else{
                s hasQty = ..GetHasFeeQty(arcim, ord, dateH)
                if (hasQty < maxTimes){
                    s calcData(arcim) = qty
                }
            }
        }
    }
    s ret = ""
    s arcim = ""
    for {
        s arcim = $o(calcData(arcim), 1, qty) q:(arcim = "")
        s rowData = arcim _ "@" _ qty
        s ret = $s(ret = "" : rowData , 1 : ret _ "^" _ rowData)
    }
    q ret
}

/// Description: 获取某一配置费某日已收取个数
///              每个医嘱的数量就是1,毋庸置疑
ClassMethod GetHasFeeQty(arcim, ord, dateH)
{
    s ret = 0
    s itm = 0 
    for {
        s itm = $o(^OEORDi(0,"ARCIM", ord, arcim, dateH, itm)) q:(itm = "")
        s oeori = ord _ "||" _ itm
        s state = $p($g(^OEORD(ord, "I", itm, 1)), "^", 13)
        continue:(state = "")
        s stateCode = $p($g(^OEC("OSTAT", state)), "^", 1)
        continue:(stateCode '= "V")&&(stateCode '= "E")
        s ret = ret + 1
    }
    q ret
}

/// Description: 批次是否能够修改
ClassMethod CanBatBeUpdated(mDsp) As %Boolean
{
    s pog = $o(^PIVA(0, "DSP", mDsp, 0))
    q:(pog = "") $$$YES
    s ps = $p(^PIVA(pog), "^", 6)
    s psNumber = $p(^PIVAS(ps), "^", 1)
    q:(+psNumber < 60) $$$YES
    q $$$NO
}

/// Description: 批次能够在打包与配液之间转换
ClassMethod CanBatChangePack(mDsp) As %Boolean
{
    s pog = $o(^PIVA(0, "DSP", mDsp, 0))
    q:(pog = "") $$$YES
    s ps = $p(^PIVA(pog), "^", 6)
    s psNumber = $p(^PIVAS(ps), "^", 1)
    q:(+psNumber < 60) $$$YES
    q $$$NO
}

/// Description: 执行的各流程中是否需要的判断的条件
///              指停止执行记录, 护士拒绝, 预停等
/// w ##class(web.DHCSTPIVAS.Common).GetNeedStopState("147548")
ClassMethod GetNeedStopState(pog, psNumber)
{
    q:(psNumber > 80) $$$OK
    s pogData = $g(^PIVA(pog))
    s ps = $p(pogData, "^", 6)
    s loc = $p(pogData, "^", 7)
    s mDsp = $p(pogData, "^", 1)
    s mDspData = ^DHCOEDISQTY(mDsp)
    s mOeori = $p(mDspData, "^", 1)
    s mOeore = $p(mDspData, "^", 3)
    s adm = $p(^OEORD(+mOeori), "^", 1)
    s packFlag=##class(web.DHCSTPIVAS.Common).DspPackFlag(mDsp)
    q:(psNumber > 60)&&(packFlag '= "P") $$$OK
    
    q:(..CheckOeoreStat(mOeore) '= 1) "-1^" _ ##class(PHA.COM.Base).Get("执行记录已停止")
    q:($p(..GetNurseSeeType(mOeori,loc), "^", 1) = "N") "-1^" _ ##class(PHA.COM.Base).Get("护士医嘱处理结果为拒绝")
    q:(..IsOrderPreStop(mOeore) = $$$YES) "-1^"_##class(PHA.COM.Base).Get("预停医嘱")
    q:(..IsDischarged(adm) = $$$YES) "-1^"_##class(PHA.COM.Base).Get("已出院")

    q $$$OK
}

/// Description: 是否为预停医嘱, 且在预停时间之后
/// w ##class(web.DHCSTPIVAS.Common).IsOrderPreStop("147548")
ClassMethod IsOrderPreStop(oeore) As %Boolean
{
    s ord = $p(oeore, "||", 1), itm = $p(oeore, "||", 2), exe = $p(oeore, "||", 3)
    s data = $g(^OEORD(ord, "I", itm, 9))
    s endDate = $p(data, "^", 9), endTime = $p(data, "^", 10)  
    q:(endDate = "") $$$NO
    s oeoreData = $g(^OEORD(ord, "I", itm, "X", exe))
    s exStDate = $p(oeoreData, "^", 1)
    s exStTime = $p(oeoreData, "^", 2)
    q:(exStDate > endDate) $$$YES
    q:(exStDate = endDate)&&(exStTime > endTime) $$$YES
    q $$$NO
}

/// Description: 静配系统参数等是否维护正常
/// w ##class(web.DHCSTPIVAS.Common).GetSystemStat(89)
ClassMethod GetSystemStat(loc) As %String
{
    s pIndex = $lb("IsSystemNormal", loc)
    q:($d($$$PIVASVAR(pIndex), ret)) ret
    s records = 0
    &SQL(
        SELECT COUNT(1) INTO :records
        FROM SQLUser.PIVA_State
        WHERE PS_Loc_Dr = :loc
          AND PS_TypeFlag = 'I'
          AND PS_Flag = 'Y'
          AND ((PS_DispFlag = 'Y') OR (PS_PackDisp = 'Y' AND PS_PackIgnore != 'Y'))
    )
    if (records >= 2){
        s ret = $$$OK
    }else{
        s ret = "-1^" _ ##class(PHA.COM.Base).Get("请先在「配液流程定制」中设置【配液减库】【打包减库】")
    }
    s $$$PIVASVAR(pIndex) = ret
    q ret
}

/// Description: 取一组执行记录中对应在打包表的第一条记录, 不一定是主医嘱的
/// w ##class(web.DHCSTPIVAS.Common).GetOneDspByOeore("115||7||2")
ClassMethod GetOneDspByOeore(oeore, mOeore = "") As %String
{
    q:(oeore = "") ""
    if (mOeore = ""){
        s mOeore = ..GetMainOeore(oeore)
    }
    s dsp = $o(^DHCOEDISQTY(0, "OEORE", mOeore, 0))
    q:(dsp '= "")&&(..IsDrugDsp(dsp) = "Y") dsp
    s mOrd = +mOeore
    s ordItm = ""
    for {
        s ordItm = $o(^OEORDi(0, "OEORE", mOeore, mOrd, ordItm)) q:(ordItm = "")
        s ordExe = 0
        for {
            s ordExe = $o(^OEORDi(0, "OEORE", mOeore, mOrd, ordItm, ordExe)) q:(ordExe = "")
            s oeore = mOrd _ "||" _ ordItm _ "||" _ ordExe
            s dsp = $o(^DHCOEDISQTY(0, "OEORE", oeore, 0))
            return:(dsp '= "")&&(..IsDrugDsp(dsp) = "Y") dsp
        }   
    }
    q ""
}

ClassMethod GetOeoreRecLoc(oeore, mOeore = "")
{
    s dsp = ..GetOneDspByOeore(oeore, mOeore)
    q:(dsp = "") ""
    q $p($g(^DHCOEDISQTY(dsp)), "^", 24)
}

/// Description: 根据单号获取第一个配液主表ID, 按院区判断, 接收时的登录尔科室为病区
ClassMethod GetFirstPogByNo(pogsNo, loc)
{
    q:(pogsNo = "")||(loc = "") ""
    s hosp = $p($g(^CTLOC(loc)), "^", 2)
    s pog = 0
    for {
        s pog = $o(^PIVA(0, "PogsNo", pogsNo, pog)) q:(pog = "")
        s pogLoc = $p(^PIVA(pog), "^", 7)
        s pogHosp = $p($g(^CTLOC(pogLoc)), "^", 2)
        return:(pogHosp = hosp) pog
    }
    q ""
}

/// Description: 是否被配液拒绝
/// Debug:       w ##class(web.DHCSTPIVAS.Common).IsPivasRefused(213)
ClassMethod IsPivasRefused(dsp) As %Boolean
{
    s pog = $o(^PIVA(0, "DSP", dsp, 0))
    q:(pog = "") $$$NO
    q:($p($g(^PIVA(pog)), "^", 8) = "R") $$$YES
    q $$$NO
}

/// description: 获取对应科室的所有批次, 用于构建前端勾选
/// w ##class(web.DHCSTPIVAS.Common).GetPivasLocBatJson("string",89)
ClassMethod GetPivasLocBatJson(retType = "", pivasLoc)
{
    s retArr = []
    s id = 0
    for {
        s id = $o(^PIVABT(id), 1, idData) q:(id = "")
        continue:(pivasLoc '= $p(idData, "^", 4))
        s ward = $p(idData, "^", 6)
        #; 标库暂不支持按病区, 未经过完整测试
        continue:(ward '= "") 
        s batNoDesc = $p(idData, "^", 3)
        continue:(batNoDesc = "")
        s index = batNoDesc
        s mGetPivasLocBatJsonI(index, id) = idData
    }
    s index = ""
    for {
        s index = $o(mGetPivasLocBatJsonI(index)) q:(index = "")
        s id = ""
        for {
            s id = $o(mGetPivasLocBatJsonI(index, id), 1, idData) q:(id = "")
            s batNoDesc = $p(idData, "^", 3)
            s startTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(idData, "^", 1))
            s endTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(idData, "^", 2))
            s seq = $p(idData, "^", 5)
            s pri = $p(idData, "^", 8)
            
            s info = startTime _ " ~ " _ endTime
            if (seq = "Y"){
                s info = info _ "</br>" _ ..Translate("关联医嘱")  // @translate
            }
            if (seq = "N"){
                s info = info _ "</br>" _ ..Translate("非关联医嘱")  // @translate
            }
            if (pri '= "") {
                s info = info _ "</br>" _ $p($g(^OECPR(pri)), "^", 2)
            }
            s autoPack = $p(idData, "^", 10)
            if (autoPack = "Y"){
                s info = info _ "</br>" _ ..Translate("排批时自动打包")  // @translate
            }
            s remark = $p(idData, "^", 9)            
            if (remark '= ""){
                s info = info _ "</br>" _ remark
            }
            
            d retArr.%Push({
                "batNoID": (id),
                "batNoDesc": (batNoDesc),
                "info": (info)
            })
        }
    }
    q:($zcvt(retType, "U") [ "STRING") retArr.%ToJSON()
    q retArr
}

/// description: 医嘱状态代码
ClassMethod GetOeoriStatCode(oeori As %String) As %String
{
    s oeStateId = $p($g(^OEORD(+oeori, "I", +$p(oeori, "||", 2), 1)), "^", 13)
    q:(oeStateId = "") ""
    q $p($g(^OEC("OSTAT", +oeStateId)), "^", 1)
}

ClassMethod GetOeoriFreqID(oeori As %String) As %String
{
    q $p($g(^OEORD(+oeori, "I", +$p(oeori,"||", 2), 2)), "^", 4) ; OEORI_PHFreq_DR
}

/// Description: 获取图标组ID
ClassMethod GetChartBookID(description = "DHC.Doctor.DHCEMRbrowse")
{
    &SQL(SELECT ID INTO :rowID FROM epr.ChartBook WHERE Description = :description)
    q $g(rowID)
}

ClassMethod Translate(pStr, pageCode = "PHA.PIVAS.TRANSLATE")
{
    if (pageCode = ""){
        s pageCode = "PHA.IN.TRANSLATE"
    }
    q ##class(PHA.FACE.IN.Com).Translate(pageCode, pStr)
}

/// 模式替换
/// w ##class(PHA.OPIVAS.COM.Method).ReplaceTrans("handle trans fail, reason maybe stock is not en, the drug is  {{drugName}}", $lb("{{drugName}}", inciDesc))
ClassMethod ReplaceData(pStr...)
{
    s ret = pStr(1)
    #; 如果只有一个{{}}, 且第二个参数是string, 则直接replace
    for i = 2 : 1 : pStr{
        s value = pStr(i)
        s from = $lg(value, 1)
        s to = $lg(value, 2)
        s ret = $replace(ret, from, to)
    }
    q ret
}

/// w ##class(PHA.OPIVAS.COM.Method).ReplaceTranslation("-1^处理台账失败,可能原因库存不足, 药品为{{drugName}}", $lb("{{drugName}}", inciDesc))
ClassMethod ReplaceTranslation(pStr...)
{
    s pStr(1) = ..Translate(pStr(1))
    #; s a=##class(web.DHCSTPIVAS.Common).ReplaceTranslation("-2^存储数据失败, 错误信息为{{info}}", $lb("{{info}}", $tr(%msgInfo, "^", "~"))) 
    q ..ReplaceData(pStr...)
}

ClassMethod GetSqlError(type)
{
    s text = "插入失败, 错误信息为"
    s text = "更新失败, 错误信息为"
    s text = "删除失败, 错误信息为"
    s text = "查询失败, 错误信息为"
    q "插入失败, 错误信息为" _ $tr($g(%msg), "<^>", "[~]")
}

/// Description: 是否已结算出院, 结算出院后不允许在配液, 开单计费也不允许
///              新入院流程, F: 护士办理出院, T: 结束费用调整
/// Return:      $$$YES 已出院, $$$NO 在院
ClassMethod IsDischarged(adm) As %Boolean
{
    s visitStatus = $p(^PAADM(adm), "^", 20)
    q:(visitStatus = "C") $$$YES
    if (^DHCDishChargeSet("Disch", "ifGetAdmDateTimeByBed")){
        s dischargeStatus = ##class(web.DHCSTInterfaceFromElse).GetCurrentDischargeStatus(adm)
        if ((dischargeStatus = "F") || (dischargeStatus = "T")) {
            return $$$YES
        }
    }else{
        q:(visitStatus = "D") $$$YES
    }
    q $$$NO
}

/// Description: 执行记录是否已计费
///              接口判断为 ##class(PHA.FACE.IN.Com).GetOeoriBilled(), 但内部有翻译影响效率
ClassMethod IsOeoreBilled(oeore)
{
    s billed = $p(^OEORD(+oeore, "I", $p(oeore, "||", 2), "X", $p(oeore, "||", 3)), "^", 6)	
    q:(billed = "TB") $$$NO
    q $$$YES
}

}

Include webimport

IncludeGenerator webimport

Class web.DHCSTPCHCOLLAUTO3 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCSTPCHCOLLAUTO3).AutoCollectDisp("基数药")
ClassMethod AutoCollectDisp(input)
{
    n (input)
    n datefrom,dateto,timefrom,timeto,docflag,autoDisp,dispflag
    n mechine,wardString,priorityString,dispcat,userid,ii,cnt,loc,locdr
    s datefrom=+$h-7
    s dateto=+$h
    s timefrom=""
    s timeto=""
    s docflag=""
    s autoDisp=1
    s dispflag=0
    s mechine=1
    s wardString=""
    s priorityString=""
    s dispcat=""
    s userid=1
    k loclist
    s locstr=..GetBaseDrugLocStr(input)
    s user="" ;
    s cnt=$l(locstr,"^")
    f ii=1:1:cnt d
    .s loc=$p(locstr,"^",ii)
    .q:loc=""
    .s ret= ..CollectDisp(datefrom, dateto, timefrom, timeto, loc, docflag, autoDisp, userid, dispflag, wardString, mechine, priorityString,dispcat)
    q ii
}

ClassMethod CollectDisp(datefrom, dateto, timefrom, timeto, loc, docflag = "", autoDisp = "0", userid, dispflag, wardString, mechine = 0, priorityString, dispcat = "") As %String
{
    n (datefrom,dateto,timefrom,timeto ,loc, docflag ,autoDisp ,userid,dispflag,wardString,mechine,priorityString,dispcat)
    q:loc="" ""
    s PhacLoc=loc 
    i PhacLoc'="" d
    .s HospID=$p($g(^CTLOC(PhacLoc)),"^",22)
    s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID) //进价规则
    
    s npid=##class(web.DHCSTPCHCOLLS).NewPid()   
    f date=datefrom:1:dateto d
    .s adm=""
    .f  s adm=$o(^DHCOEDISQTY(0,"ADM",loc,date,"TC",adm)) q:adm=""  d
    ..s dsp=""
    ..f  s dsp=$o(^DHCOEDISQTY(0,"ADM",loc,date,"TC",adm,dsp)) q:dsp=""  d
    ...q:(+$o(^DHCOEDISQTY(dsp, "I", 0))=0)
    ...s addDate = $p(^DHCOEDISQTY(dsp),"^",15)
    ...s addTime = $p(^DHCOEDISQTY(dsp),"^",16)
    ...q:(addDate=+$h)&&(($p($h, ",", 2) - addTime) < 60) //  减少开单与任务并发的冲突
    ...s WardId=$p(^DHCOEDISQTY(dsp),"^",22)
    ...s PhacType=$p(^DHCOEDISQTY(dsp),"^",27)
    ...q:PhacType=""
    ...s AdmDr=$p(^DHCOEDISQTY(dsp),"^",26)
    ...q:AdmDr=""
    ...s datedos=$p(^DHCOEDISQTY(dsp),"^",21)
    ...s OrdItmRowid=$p(^DHCOEDISQTY(dsp),"^",1)
    ...s DoctorLoc=$p(^OEORD(+OrdItmRowid,"I",$p(OrdItmRowid,"||",2),7),"^",2)          
    ...//s doclocflag=..DoctorLocRefuse(loc,DoctorLoc) // 屏蔽,基数药本身为病区,也用不上医生科室发药
    ...//i doclocflag=1 d
    ...//.s WardId=DoctorLoc
    ...s j=AdmDr_"^"_datedos_"^"_OrdItmRowid  
    ...i '$d(^||TMP("dhcpha",npid,"DispCat",WardId,PhacType,j))  d
    ....s ^||TMP("dhcpha",npid,"DispCat",WardId,PhacType,j)=dsp
    ...e  d
    ....s $p(^||TMP("dhcpha",npid,"DispCat",WardId,PhacType,j),"^",1)=$p(^||TMP("dhcpha",npid,"DispCat",WardId,PhacType,j),"^",1)_","_dsp

    s Err=0,collString=""
    s ward=""
    f  s ward=$o(^||TMP("dhcpha",npid,"DispCat",ward)) q:ward=""  d
    .s type=""
    .f  s type=$o(^||TMP("dhcpha",npid,"DispCat",ward,type)) q:type=""  d
    ..s index="" 
    ..s PhacRowid="",Err="",j=0
    ..f  s index=$o(^||TMP("dhcpha",npid,"DispCat",ward,type,index)) q:(index="")  d
    ...s AdmDr=$p(index,"^",1)
    ...s DateDosing=$p(index,"^",2)
    ...s OrdItmRowid=$p(index,"^",3)
    ...s DspIdStr=$p(^||TMP("dhcpha",npid,"DispCat",ward,type,index),"^",1)
    ...s WardLocId=ward
    ...s WardId=$o(^PAWARD(0,"WARD_LocationDR",WardLocId,""))
    ...s WardRowid=WardId
    ...q:..CheckOrditmAllowedNew(npid,OrdItmRowid,loc)=0      ;计费控制 TODO
    ...s DspIdStr=##class(web.DHCSTPCHCOLLS).ReGetDodis(DspIdStr,+OrdItmRowid,$p(OrdItmRowid,"||",2))  ;重新获取配药记录串
    ...q:DspIdStr=""
    ...s allowflag=##class(web.DHCSTPCHCOLLS).CheckAllowFlag(DspIdStr,npid)   ;1--够发  0-不可发 
    ...q:allowflag'="1"
    ...i PhacRowid=""  d
    ....s listdata=PhacLoc_"^"_WardRowid_"^"_userid_"^"_datefrom_"^"_dateto_"^"_type
    ....s $p(listdata,"^",11)=userid
    ....;s PhacRowid=##class(web.DHCSTPCHCOLLS).CreatePhaCollected(listdata)
    ....s PhacRowid=##class(web.DHCINPHA.Disp.Save).InsertDHCPHACollected(listdata)
    ...q:PhacRowid="" ;主表插入失败
    ...;i RuleFlag=3 d
    ...;.s Err=##class(web.DHCSTPCHCOLLS).DispensingByBatch(PhacRowid,DspIdStr,OrdItmRowid)
    ...;e  d
    ...;.s Err=##class(web.DHCSTPCHCOLLS).Dispensing(PhacRowid,DspIdStr,OrdItmRowid)
    ...s Err=##class(web.DHCINPHA.Disp.Save).Dispensing(PhacRowid, DspIdStr, OrdItmRowid, RuleFlag)
    ..i collString="" d
    ... s collString=PhacRowid
    ..e  d
    ...s collString=collString_"A"_PhacRowid
    s collString=..GetDistinctPhacs(npid,collString)
    f xx=1:1:$l(collString,"A") d
    .s xphac=$P(collString,"A",xx)
    .s ret=..XCollect(xphac,userid,dispflag)
    k ^||TMP("dhcpha",npid,"DispCat")
    k ^TMP(npid,"ADMBILLAMT")
    k ^TMP(npid,"PHABILL")       ;计费控制所用
    q collString_"*"_npid
}

/// description:将串中的值唯一化
/// arguments:
///   pid  - 进程号
ClassMethod GetDistinctPhacs(pid, collString) As %String
{
 n (pid,collString)
 
 s dispcnt=$l(collString,"A")
 f i=1:1:dispcnt d
 .s phac=$p(collString,"A",i)
 .q:phac=""
 .q:'$d(^DHCPHAC(phac))
 .i +$o(^DHCPHAC(phac,"I",""))<1 d
 ..&sql(DELETE FROM DHC_PHACollected WHERE DHC_PHACollect_RowID=:phac)
 .q:+$o(^DHCPHAC(phac,"I",""))<1
 .s calcData(phac) = ""

 s phac="",phacs=""
 f  s phac=$O(calcData(phac)) q:phac=""  d
 .i phacs="" s phacs=phac
 .e  s phacs=phacs_"A"_phac
    
 q phacs
}

ClassMethod XCollect(phacdr, Nurse, dispflag)
{
    n (phacdr,Nurse,dispflag)
    s Nurse=$g(Nurse)
    q:phacdr="" ""
    i '$d(^DHCPHAC(phacdr)) q -1
    ; calculate the rowcount of items 
    s phacdate=+$h
    s phactime=$p($h,",",2)
    s phaci="" 
    s cnt=0 
    f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
    .s cnt=cnt+1
    s ret=0 
    i cnt=0 d
    . &sql(DELETE FROM DHC_PHACollected WHERE DHC_PHACollect_RowID=:phacdr)
    . i SQLCODE'=0 d
    . . ;s xxxx=$O(^zhwh(100,""),-1)+1  s ^zhwh(100,xxxx)=phacdr_"^"_SQLCODE
    . s phacdr=""
    e  d
    .i dispflag="1"  d
    ..&sql(UPDATE DHC_PHACollected SET DHC_PHACounts=:cnt WHERE DHC_PHACollect_RowID=:phacdr)
    .e  d
    ..s code="Collect"
    ..&sql(UPDATE DHC_PHACollected SET DHC_PHACounts=:cnt,DHC_PHACollectStatus=:code,DHC_PHACollectUser=:Nurse,DHC_PHACollectDate=:phacdate,DHC_PHACollectTime=:phactime WHERE DHC_PHACollect_RowID=:phacdr)
    ..// 调医嘱闭环
    ..i SQLCODE=0 d
    ...d ##class(PHA.IP.COM.Face).UpdateSystemStatus4PhaCollect(phacdr, "PHADISP", Nurse) // 医嘱闭环, 配药
    ...d ##class(PHA.IP.COM.Face).UpdateSystemStatus4PhaCollect(phacdr, "PHACOL", Nurse)  // 医嘱闭环, 发药
    .i SQLCODE'=0 s ret=-2 q
    q ret
}

ClassMethod CheckOrditmAllowedNew(pid As %String, oeori As %String, loc As %String) As %String
{
 //检查医嘱是否允许发，1 - 可发 0 - 不可
 n (pid,oeori,loc)
 ;zdm,2012-03-07,增加住院药房欠费管理设置判断
 s para=##Class(web.DHCSTPHALOC).GetPhaflag(loc)
 s AduitBill=$p(para,"^",23)
 q:AduitBill'="Y" 1    ;设置如果是不控制，则欠费也允许发药 //wyx 2015-03-05注释，按照新的欠费控制
 ;
 s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
 s adm=$p(^OEORD(ord),"^",1)
 i '$d(^TMP("DHCST","web.DHCSTPCHCOLLS","PHABILL",pid,adm)) q 1
 q 0
}

/// w ##class(web.DHCSTPCHCOLLAUTO3).GetBaseDrugLocStr("基数药")
ClassMethod GetBaseDrugLocStr(input As %String = "")
{
    i input="" s input="基数药"
    s LocGrpDesc="%"_input_"%"   
    s Rowid=""
    
    &SQL(declare cura cursor for select SLG_RowId into :Rowid  from DHC_StkLocGroup 
        where %ALPHAUP(SLG_Type) = 'G' And SLG_Desc like :LocGrpDesc)
    &sql(open cura) 
    
    s locstr=""
    s DHCLocDr=""
    f  &sql(fetch cura into :Rowid ) q:SQLCODE  d
    .q:Rowid="" 
    .s DHCLocDr=""
    .f  s DHCLocDr=$o(^DHCLOC(0,"SLG",Rowid,DHCLocDr)) q:DHCLocDr=""  d
    ..s ctloc=$p(^DHCLOC(DHCLocDr),"^",1)
    ..i locstr="" s locstr=ctloc
    ..e  s locstr=locstr_"^"_ctloc
     &sql(close cura)
    q locstr
}

ClassMethod DoctorLocRefuse(phaloc, doctorloc)
{
 n (phaloc,doctorloc)
 s linki=$o(^CTLOC(phaloc,"LINK",0,"Loc",doctorloc,""))
 q:linki'="" 1
 q 0
}

}

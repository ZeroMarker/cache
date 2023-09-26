Import sqluser

Class web.DHCST.StkMonReportPrint Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:20151217
/// description:月报打印,通用格式
/// w ##class(%ResultSet).RunQuery("web.DHCST.StkMonReportPrint","QueryMonRepCover","322")
Query QueryMonRepCover(monid, cacuflag = "") As websys.Query(ROWSPEC = "cacu,first,second,third,grpdesc,amt,amtsum") [ SqlProc ]
{
}

ClassMethod QueryMonRepCoverExecute(ByRef qHandle As %Binary, monid, cacuflag = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:monid="" $$$OK
 	s pid=..NewPid()
 	//s $zt="ErrorQueryMonRepCover"
 	k ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid)
	s HospId=""
	i cacuflag="true" s rows=..CalStkMonDetailSp(monid,pid)   //售价统计
	e  s rows=..CalStkMonDetailRp(monid,pid)   //进价统计
	q:rows'>0 $$$OK
	s locrowid=$p(^DHCSM(monid),"^",1)
	s startdate=$p(^DHCSM(monid),"^",3)
	s todate=$p(^DHCSM(monid),"^",4)
	s stkgrpstr=..GetStkCatGrpByLoc(locrowid)
	q:stkgrpstr="" $$$OK
	s stkgrplist=$lfs(stkgrpstr)
	s stkgrplength=$l(stkgrpstr,",")
	s stkgrpi=""
	f stkgrpi=1:1:stkgrplength d
	.s stkgrpindex=stkgrpi_"-"_$p(stkgrpstr,",",stkgrpi) //stkgrpi-决定横向排序
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,"1-一","A-上期库存金额","1-药　　品　　类　　组",stkgrpindex)=""
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,"4-四","V-本期库存金额","1-药　　品　　类　　组",stkgrpindex)=""
	s grpdesc=""
	f  s grpdesc=$o(^TMP("DHCST","StkMonReportPrint","CalStkMonDetail",pid,monid,grpdesc)) q:grpdesc=""  d	
	.s In=0,Out=0,LastAmt=0,Amt=0,RecAmt=0,RetAmt=0,TroAmt=0,TriAmt=0,AdjAmt=0,ConAmt=0
	.s DisAmt=0,DspAmt=0,AspAmt=0,GiftRecAmt=0,PhaRetAspAmt=0,RetAspAmt=0,PhaRetAmt=0,giftTrfAmt=0
	.s chgRecAmt=0,chgRetAmt=0,mRecAmt=0,stktkAdjAmt=0,manuXAmt=0,manuMAmt=0,phoRetAspAmt=0,trfIAspAmt= 0
	.s DspAmtP=0, DspAmtF=0, DspAmtS=0,PhaRetAmtY=0,PhaRetAmtH=0,PhaRetAmtZ=0
	.s PAdjAmt=0,MAdjAmt=0,PStkAmt=0,MStkAmt=0,PRetAspAmt=0,MRetAspAmt=0,PAspAmt=0,MAspAmt=0
	.s MPhaRetAspAmt=0,PPhaRetAspAmt=0,MphoRetAspAmt=0,PphoRetAspAmt=0
	.s PtrfIAspAmt=0,MtrfIAspAmt=0,PRetAspAmt=0,MRetAspAmt=0,PrecAspAmt=0,MrecAspAmt=0
	.s (PAspAmtSum,MAspAmtSum,PRetAspAmtSum,MRetAspAmtSum,PAdjAmtSum,MAdjAmtSum,PStkAmtSum,MStkAmtSum,LastAmtSum,AmtSum,RecAmtSum)=0
	.s (RetAmtSum,TroAmtSum,TriAmtSum,AdjAmtSum,ConAmtSum,DisAmtSum,DspAmtSum,AspAmtSum,PhaRetAmtSum,RetAspAmtSum,PhaRetAspAmtSum)=0
	.s (GiftRecAmtSum,giftTrfAmtSum,chgRecAmtSum,chgRetAmtSum,mRecAmtSum,stktkAdjAmtSum,manuXAmtSum,manuMAmtSum,phoRetAspAmtSum,PTrfIAspAmtSum,MTrfIAspAmtSum)=0
	.s (InSum,OutSum,DispFAmtSum,DispPAmtSum,PhaRetYAmtSum,PhaRetHAmtSum,MonInAmtSum,MonOutAmtSum,PRecAspAmtSum,MRecAspAmtSum)=0
	.s (PphoRetAspAmtSum,MphoRetAspAmtSum,PPhaRetAspAmtSum,MPhaRetAspAmtSum)=0
	.s cat="" 
	.f  s cat=$o(^TMP("DHCST","StkMonReportPrint","CalStkMonDetail",pid,monid,grpdesc,cat)) q:cat=""  d
	..s nn=0
	..f  s nn=$o(^TMP("DHCST","StkMonReportPrint","CalStkMonDetail",pid,monid,grpdesc,cat,nn)) q:nn=""  d
	...s amt=^TMP("DHCST","StkMonReportPrint","CalStkMonDetail",pid,monid,grpdesc,cat,nn)
	...s LastAmt=$g(LastAmt)+$p(amt,"^",1)
	...s Amt=$g(Amt)+$p(amt,"^",2)
	...s RecAmt=$g(RecAmt)+$p(amt,"^",3)
	...s RetAmt=$g(RetAmt)+$p(amt,"^",4)
	...s TroAmt=$g(TroAmt)+$p(amt,"^",5)
	...s TriAmt=$g(TriAmt)+$p(amt,"^",6)
	...s AdjAmt=$g(AdjAmt)+$p(amt,"^",7)
	...i +$p(amt,"^",7)<0 s MAdjAmt=MAdjAmt+$p(amt,"^",7)
	...e  s PAdjAmt=PAdjAmt+$p(amt,"^",7)
	...s ConAmt=$g(ConAmt)+$p(amt,"^",8)
	...s DisAmt=$g(DisAmt)+$p(amt,"^",9)
	...s DspAmtP=$G(DspAmtP)+$p(amt,"^",11)
	...s DspAmtF=$G(DspAmtF)+$p(amt,"^",13)
	...s DspAmtS=$G(DspAmtS)+$p(amt,"^",14)
	...s DspAmt=$g(DspAmt)+$p(amt,"^",11)+$p(amt,"^",13)+$p(amt,"^",14)   //发药(门诊、住院汇总)
	...s AspAmt=$g(AspAmt)+$p(amt,"^",10)
	...i +$p(amt,"^",10)<0 s MAspAmt=MAspAmt+$p(amt,"^",10)
	...e  s PAspAmt=PAspAmt+$p(amt,"^",10)
	...s PhaRetAmtY=$G(PhaRetAmtY)+$p(amt,"^",12)
	...s PhaRetAmtH=$G(PhaRetAmtH)+$p(amt,"^",15)
	...s PhaRetAmtZ=$G(PhaRetAmtZ)+$p(amt,"^",16)
	...s PhaRetAmt=$g(PhaRetAmt)+$p(amt,"^",12)+$p(amt,"^",15)+$p(amt,"^",16)  //退药(门诊、住院汇总)
	...s GiftRecAmt=$g(GiftRecAmt)+$p(amt,"^",17)
	...s RetAspAmt=$g(RetAspAmt)+$p(amt,"^",18)
	...i +$p(amt,"^",18)<0 s MRetAspAmt=MRetAspAmt+$p(amt,"^",18)
	...e  s PRetAspAmt=PRetAspAmt+$p(amt,"^",18)
	...i +$p(amt,"^",19)<0 s MPhaRetAspAmt=MPhaRetAspAmt+$p(amt,"^",19)
	...e  s PPhaRetAspAmt=PPhaRetAspAmt+$p(amt,"^",19)
	...s giftTrfAmt=giftTrfAmt+$p(amt,"^",20)
	...s chgRecAmt=chgRecAmt+$p(amt,"^",21)
	...s chgRetAmt=chgRetAmt+$p(amt,"^",22)
	...s mRecAmt = mRecAmt+$p(amt,"^",23)
	...s stktkAdjAmt=stktkAdjAmt+$p(amt,"^",24)  
	...i +$p(amt,"^",24)<0 s MStkAmt=MStkAmt+$p(amt,"^",24)
	...e  s PStkAmt=PStkAmt+$p(amt,"^",24)
	...s manuXAmt=manuXAmt+$p(amt,"^",25)  
	...s manuMAmt=manuMAmt+$p(amt,"^",26)   
	...i +$p(amt,"^",27)<0 s MphoRetAspAmt=MphoRetAspAmt+$p(amt,"^",27)
	...e  s PphoRetAspAmt=PphoRetAspAmt+$p(amt,"^",27)
	...i +$p(amt,"^",28)<0 s MtrfIAspAmt=MtrfIAspAmt+$p(amt,"^",28)
	...e  s PtrfIAspAmt=PtrfIAspAmt+$p(amt,"^",28)
	...i +$p(amt,"^",29)<0 s MrecAspAmt=MrecAspAmt+$p(amt,"^",29)
	...e  s PrecAspAmt=PrecAspAmt+$p(amt,"^",29) 
	.s In=RecAmt+TriAmt+PhaRetAmt+$G(manuXAmt)+PrecAspAmt+PtrfIAspAmt+PphoRetAspAmt+PPhaRetAspAmt
	.s Out=RetAmt+TroAmt+ConAmt+DisAmt+DspAmt+$g(manuMAmt)+MrecAspAmt+MtrfIAspAmt+MphoRetAspAmt+MPhaRetAspAmt
	.i AdjAmt>0 s In=In+AdjAmt
	.e  s Out=Out+AdjAmt
	.i stktkAdjAmt>0 s In=In+stktkAdjAmt
	.e  s Out=Out+stktkAdjAmt
	.i AspAmt>0 s In=In+AspAmt
	.e  s Out=Out+AspAmt
	.i RetAspAmt>0 s In=In+RetAspAmt
	.e  s Out=Out+RetAspAmt
	.s PAdjAmtSum=PAdjAmtSum+PAdjAmt
	.s MAdjAmtSum=MAdjAmtSum+MAdjAmt
	.s PStkAmtSum=PStkAmtSum+PStkAmt
	.s MStkAmtSum=MStkAmtSum+MStkAmt
	.s PRetAspAmtSum=PRetAspAmtSum+PRetAspAmt
	.s MRetAspAmtSum=MRetAspAmtSum+MRetAspAmt
	.s PAspAmtSum=PAspAmtSum+PAspAmt
	.s MAspAmtSum=MAspAmtSum+MAspAmt
	.s PTrfIAspAmtSum=PTrfIAspAmtSum+PtrfIAspAmt
	.s MTrfIAspAmtSum=MTrfIAspAmtSum+MtrfIAspAmt
	.s PRecAspAmtSum=PRecAspAmtSum+PrecAspAmt
	.s MRecAspAmtSum=MRecAspAmtSum+MrecAspAmt
	.s PphoRetAspAmtSum=PphoRetAspAmtSum+PphoRetAspAmt
	.s MphoRetAspAmtSum=MphoRetAspAmtSum+MphoRetAspAmt
	.s PPhaRetAspAmtSum=PPhaRetAspAmtSum+PPhaRetAspAmt
	.s MPhaRetAspAmtSum=MPhaRetAspAmtSum+MPhaRetAspAmt
	.s LastAmtSum=LastAmtSum+LastAmt,AmtSum=AmtSum+Amt,RecAmtSum=RecAmtSum+RecAmt,RetAmtSum=RetAmtSum+RetAmt
	.s TroAmtSum=TroAmtSum+TroAmt,TriAmtSum=TriAmtSum+TriAmt,AdjAmtSum=AdjAmtSum+AdjAmt,ConAmtSum=ConAmtSum+ConAmt
	.s DisAmtSum=DisAmtSum+DisAmt,DspAmtSum=DspAmtSum+DspAmt,AspAmtSum=AspAmtSum+AspAmt,PhaRetAmtSum=PhaRetAmtSum+PhaRetAmt
	.s RetAspAmtSum=RetAspAmtSum+RetAspAmt,GiftRecAmtSum=GiftRecAmtSum+GiftRecAmt,manuMAmtSum=manuMAmtSum+manuMAmt
	.s giftTrfAmtSum=giftTrfAmtSum+giftTrfAmt,chgRecAmtSum=chgRecAmtSum+chgRecAmt,chgRetAmtSum=chgRetAmtSum+chgRetAmt
	.s mRecAmtSum=mRecAmtSum+mRecAmt,stktkAdjAmtSum=stktkAdjAmtSum+stktkAdjAmt,manuXAmtSum=manuXAmtSum+manuXAmt
	.s InSum=InSum+In,OutSum=OutSum+Out
	.s DispFAmtSum=$g(DispFAmtSum)+DspAmtF  //门诊发药
	.s DispPAmtSum=$g(DispPAmtSum)+DspAmtP  //住院发药
	.s PhaRetYAmtSum=$g(PhaRetYAmtSum)+PhaRetAmtY //住院退药
	.s PhaRetHAmtSum=$g(PhaRetHAmtSum)+PhaRetAmtH  //门诊退药
	.s LastAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(LastAmt,HospId)
	.s Amt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(Amt,HospId)
	.s LastAmtSum=##class(web.DHCST.Common.AppCommon).FormatSpAmt(LastAmtSum,HospId)
	.s AmtSum=##class(web.DHCST.Common.AppCommon).FormatSpAmt(AmtSum,HospId)
	.//按规则汇总数据
	.s first="1-一"
	.s second="A-上期库存金额"
	.s grpstr=""
	.q:$lf(stkgrplist,grpdesc)=0
	.s grpstr=$lf(stkgrplist,grpdesc)_"-"_grpdesc
	.s third="1-药　　品　　类　　组"
	.q:grpstr=""  
	.s MonInAmtSum=0
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=LastAmtSum
	.s first="2-二　　　收　　　方"
	.s second="B-采购入库"
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=RecAmtSum+GiftRecAmtSum+chgRecAmtSum
	.s MonInAmtSum=MonInAmtSum+RecAmtSum+GiftRecAmtSum+chgRecAmtSum
	.s second="C-转移入库"
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=TriAmtSum
	.s MonInAmtSum=MonInAmtSum+TriAmtSum
	.s second="D-住院退药"  
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=PhaRetYAmtSum
	.s MonInAmtSum=MonInAmtSum+PhaRetYAmtSum
	.s second="E-门诊退药"  
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=PhaRetHAmtSum
	.s MonInAmtSum=MonInAmtSum+PhaRetHAmtSum
	.s second="F-调价增值"  
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=PAspAmtSum
	.s MonInAmtSum=MonInAmtSum+PAspAmtSum
	.s second="G-盘存增值"  
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=PStkAmtSum
	.s MonInAmtSum=MonInAmtSum+PStkAmtSum
	.s second="H-调整增值"  
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=PAdjAmtSum 
	.s MonInAmtSum=MonInAmtSum+PAdjAmtSum
	.s second="I-其它盈利损益"   //包括退货,入库,转移入库,住院门诊的调价损益
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=PTrfIAspAmtSum+PRecAspAmtSum+PphoRetAspAmtSum+PPhaRetAspAmtSum+PRetAspAmtSum
	.s MonInAmtSum=MonInAmtSum+PTrfIAspAmtSum+PRecAspAmtSum+PphoRetAspAmtSum+PPhaRetAspAmtSum+PRetAspAmtSum
	.s second="J-收方合计金额"  
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=MonInAmtSum
	.s second="K-( 一 + 二 ) 合计"  
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCoverSum",pid,second,grpstr)=MonInAmtSum+LastAmtSum
	.////////////////////////////////////////////////////////////////////////
	.s MonOutAmtSum=0
	.s first="3-三　　　支　　　方"
	.s second="L-退货出库"
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=RetAmtSum
	.s MonOutAmtSum=MonOutAmtSum+RetAmtSum
	.s second="M-转移出库"
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=TroAmtSum
	.s MonOutAmtSum=MonOutAmtSum+TroAmtSum
	.s second="N-住院发药"  
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=DispPAmtSum
	.s MonOutAmtSum=MonOutAmtSum+DispPAmtSum
	.s second="O-门诊发药"    
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=DispFAmtSum
	.s MonOutAmtSum=MonOutAmtSum+DispFAmtSum
	.s second="P-调价减值"   
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=MAspAmtSum
	.s MonOutAmtSum=MonOutAmtSum+MAspAmtSum
	.s second="Q-盘存减值"  
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=MStkAmtSum
	.s MonOutAmtSum=MonOutAmtSum+MStkAmtSum
	.s second="R-调整减值"  
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=MAdjAmtSum
	.s MonOutAmtSum=MonOutAmtSum+MAdjAmtSum
	.s second="S-报损支出"   
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=DisAmtSum
	.s MonOutAmtSum=MonOutAmtSum+DisAmtSum
	.s second="T-其它亏损损益"  //包括退货,入库,转移入库,住院门诊的调价损益
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=MTrfIAspAmtSum+MRecAspAmtSum+MphoRetAspAmtSum+MPhaRetAspAmtSum+MRetAspAmtSum
	.s MonOutAmtSum=MonOutAmtSum+MTrfIAspAmtSum+MRecAspAmtSum+MphoRetAspAmtSum+MPhaRetAspAmtSum+MRetAspAmtSum
	.s second="U-支出合计金额"  
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=MonOutAmtSum
	.s first="4-四"
	.s second="V-本期库存金额"
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpstr)=AmtSum
	.s second="W-( 三 + 四 ) 合计"  
	.s ^TMP("DHCST","StkMonReportPrint","QueryMonRepCoverSum",pid,second,grpstr)=-AmtSum+MonOutAmtSum
	s first=""
	f  s first=$o(^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first)) q:first=""  d
	.s second=""
	.f  s second=$o(^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second)) q:second=""  d
	..s third=""
	..f  s third=$o(^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third)) q:third=""  d
	...s grpdesc=""
	...f  s grpdesc=$o(^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpdesc)) q:grpdesc=""  d
	....s amt=+^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid,first,second,third,grpdesc)
	....s amtsum=0
	....s cacu=""
	....i (first["一")||(first["二") s cacu="K-( 一 + 二 ) 合计" 
	....i (first["三")||(first["四") s cacu="W-( 三 + 四 ) 合计" 
	....s amtsum=+$g(^TMP("DHCST","StkMonReportPrint","QueryMonRepCoverSum",pid,cacu,grpdesc))
	....i amtsum<0 s amtsum=-amtsum
	....i amt<0 s amt=-amt
	....s Data=$lb(cacu,first,second,third,grpdesc,amt,amtsum)
	....s ^CacheTemp(repid,ind)=Data    
	....s ind=ind+1
	k ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid)
	k ^TMP("DHCST","StkMonReportPrint","CalStkMonDetail",pid)
	k ^TMP("DHCST","StkMonReportPrint","QueryMonRepCoverSum",pid)
 	q $$$OK
ErrorQueryMonRepCover
 	k ^TMP("DHCST","StkMonReportPrint","QueryMonRepCover",pid)
	k ^TMP("DHCST","StkMonReportPrint","CalStkMonDetail",pid)
	k ^TMP("DHCST","StkMonReportPrint","QueryMonRepCoverSum",pid)
	q $$$OK
}

/// 按类组汇总
/// input:月报id,进程号,汇总方式
/// INCI-按药品,STKCAT-按库存分类,STKCATGRP-按类组,默认类组
ClassMethod CalStkMonDetailSp(sm As %String, pid As %String) As %String
{
 n (sm,pid)
 s n=0
 k ^TMP("DHCST","StkMonReportPrint","CalStkMonDetail",pid,sm)
 s ch=""
 f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d   
 .s data=^DHCSM(sm,"R",ch)  
 .s rowid=sm_"||"_ch  ;rowid
 .s inci=$p(data,"^",3)    ;inci  
 .s stkcat=$p(^INCI(inci,2),"^",2)         ;cat dr
 .q:stkcat=""
 .s stkcatgrpstr=##class(web.DHCST.Common.DrugInfoCommon).StkCatGrpStr(stkcat)
 .s grpdesc=$p(stkcatgrpstr,"^",2)
 .q:grpdesc=""
 .s amount=$p(data,"^",7)  ;amount
 .s lastAmount=$p(data,"^",10)    ;amount of last month
 .s statrowid=$o(^SMSTAT(0,"SMR",rowid,""))
 .i $g(statrowid)'=""  d
 ..s aaa=$G(^SMSTAT(statrowid))  //月报明细数据
 ..s recAmt=$p(aaa,"^",3)	//入库
 ..s retAmt=$p(aaa,"^",5)	//退货
 ..s trOAmt=$p(aaa,"^",7)	//转出
 ..s trIAmt=$p(aaa,"^",9)	//转入
 ..s adjAmt=$p(aaa,"^",11)	//调整
 ..s conAmt=$p(aaa,"^",13)	//消耗
 ..s disposAmt=$p(aaa,"^",15)	//报损
 ..s aspAmt=$p(aaa,"^",18)	//调价损益
 ..s phaDspAmtP=$p(aaa,"^",17)	//住院发药
 ..s phaRetAmtY=$p(aaa,"^",20)	//住院退药
 ..s phaDspAmtF=$p(aaa,"^",22)	//门诊发药
 ..s phaDspAmtS=$p(aaa,"^",24)  //门诊发药(非正常)
 ..s phaRetAmtH=$p(aaa,"^",26)  //门诊退药
 ..s phaRetAmtZ=$p(aaa,"^",28)  //门诊退药(非正常)
 ..s giftRecAmt=$p(aaa,"^",30)  //赠品入库
 ..s giftTrfAmt=$p(aaa,"^",32)  //赠品出库
 ..s chgRecAmt=$p(aaa,"^",34)	//调价换票入库
 ..s chgRetAmt=$p(aaa,"^",36)	//调价换票退货
 ..s retAspAmt=$p(aaa,"^",37) 	//退货损益
 ..s phaRetAspAmt=$p(aaa,"^",38)	//住院退药损益
 ..s mRecAmt=$p(aaa,"^",40)	//制剂入库
 ..s stktkAdjAmt=$p(aaa,"^",42)	//盘点调整
 ..s manuXAmt=$p(aaa,"^",44) //制剂生产
 ..s manuMAmt=$p(aaa,"^",46) //制剂生成
 ..s phoRetAspAmt=$p(aaa,"^",47)  //门诊退药损益
 ..s trfIAspAmt=$p(aaa,"^",48) //转移入库损益
 ..s recAspAmt=0 //入库损益,售价为0
 .s n=n+1
 .s amt=$g(lastAmount)
 .s amt=amt_"^"_$g(amount)
 .s amt=amt_"^"_$g(recAmt)
 .s amt=amt_"^"_$g(retAmt)
 .s amt=amt_"^"_$g(trOAmt)
 .s amt=amt_"^"_$g(trIAmt)
 .s amt=amt_"^"_$g(adjAmt)
 .s amt=amt_"^"_$g(conAmt)
 .s amt=amt_"^"_$g(disposAmt)
 .s amt=amt_"^"_$g(aspAmt)
 .s amt=amt_"^"_$g(phaDspAmtP)
 .s amt=amt_"^"_$g(phaRetAmtY)
 .s amt=amt_"^"_$g(phaDspAmtF)
 .s amt=amt_"^"_$g(phaDspAmtS)
 .s amt=amt_"^"_$g(phaRetAmtH)
 .s amt=amt_"^"_$g(phaRetAmtZ)
 .s amt=amt_"^"_$g(giftRecAmt)
 .s amt=amt_"^"_$g(retAspAmt)
 .s amt=amt_"^"_$g(phaRetAspAmt)
 .s amt=amt_"^"_$g(giftTrfAmt)
 .s amt=amt_"^"_$g(chgRecAmt)
 .s amt=amt_"^"_$g(chgRetAmt)
 .s amt=amt_"^"_$g(mRecAmt)
 .s amt=amt_"^"_$g(stktkAdjAmt)
 .s amt=amt_"^"_$g(manuXAmt)
 .s amt=amt_"^"_$g(manuMAmt)
 .s amt=amt_"^"_$g(phoRetAspAmt)
 .s amt=amt_"^"_$g(trfIAspAmt)
 .s amt=amt_"^"_$g(recAspAmt)
 .s ^TMP("DHCST","StkMonReportPrint","CalStkMonDetail",pid,sm,grpdesc,stkcat,n)=amt 
 q n
}

/// 按分类汇总统计月报明细数据(进价)
/// Author:zhwh
/// Date:2012-11-06
/// Argu:
///  sm - 月报主表rowid
///  catdr - 库存分类rowid
/// Return:
///    记录数
/// Table List:
///   DHC_StkMonReport
///   DHC_StkMonStatIn
ClassMethod CalStkMonDetailRp(sm As %String, pid As %String) As %String
{
 n (sm,pid)
 s n=0
 k ^TMP("DHCST","StkMonReportPrint","CalStkMonDetail",pid,sm)
 s ch=""
 f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d    
 .s data=^DHCSM(sm,"R",ch)  
 .s rowid=sm_"||"_ch                ;rowid
 .s inci=$p(data,"^",3)                  ;inci   
 .s stkcat=$p(^INCI(inci,2),"^",2)         ;cat dr
 .q:stkcat=""
 .s stkcatgrpstr=##class(web.DHCST.Common.DrugInfoCommon).StkCatGrpStr(stkcat)
 .s grpdesc=$p(stkcatgrpstr,"^",2)
 .q:grpdesc="" 
 .s amount=$p(data,"^",8)                ;amount
 .s lastAmount=$p(data,"^",11)           ;amount of last month
 .s statinrowid=$o(^SMSTATI(0,"SMR",rowid,""))
 .i $g(statinrowid)'=""  d
 ..s aaa=$G(^SMSTATI(statinrowid))
 ..s recAmt=$p(aaa,"^",3)
 ..s retAmt=$p(aaa,"^",5)
 ..s trOAmt=$p(aaa,"^",7)
 ..s trIAmt=$p(aaa,"^",9)
 ..s adjAmt=$p(aaa,"^",11)
 ..s conAmt=$p(aaa,"^",13)
 ..s disposAmt=$p(aaa,"^",15)
 ..s aspAmt=$p(aaa,"^",18)
 ..s phaDspAmtP=$p(aaa,"^",17)
 ..s phaRetAmtY=$p(aaa,"^",20)
 ..s phaDspAmtF=$p(aaa,"^",30)
 ..s phaDspAmtS=$p(aaa,"^",32)
 ..s phaRetAmtH=$p(aaa,"^",34)
 ..s phaRetAmtZ=$p(aaa,"^",36)
 ..s giftRecAmt=$p(aaa,"^",22)  //赠品入库
 ..s giftTrfAmt=$p(aaa,"^",24)  //赠品出库
 ..s chgRecAmt=$p(aaa,"^",26)
 ..s chgRetAmt=$p(aaa,"^",28)
 ..s trfIAspAmt=$p(aaa,"^",38) //转移入库调价损益
 ..s retAspAmt=$p(aaa,"^",39)  //退货调价损益
 ..s stktkAdjAmt=$p(aaa,"^",41)  //盘点调整
 ..s manuXAmt=$p(aaa,"^",44)
 ..s manuMAmt=$p(aaa,"^",46)
 ..s mRecAmt=$p(aaa,"^",47)
 ..s phoRetAspAmt=$p(aaa,"^",48)  //门诊退药调价损益
 ..s phaRetAspAmt=$p(aaa,"^",49)  //住院退药调价损益
 ..s recAspAmt=$p(aaa,"^",37)  //入库损益
 .s n=n+1
 .s amt=$g(lastAmount)
 .s amt=amt_"^"_$g(amount)
 .s amt=amt_"^"_$g(recAmt)
 .s amt=amt_"^"_$g(retAmt)
 .s amt=amt_"^"_$g(trOAmt)
 .s amt=amt_"^"_$g(trIAmt)
 .s amt=amt_"^"_$g(adjAmt)
 .s amt=amt_"^"_$g(conAmt)
 .s amt=amt_"^"_$g(disposAmt)
 .s amt=amt_"^"_$g(aspAmt)
 .s amt=amt_"^"_$g(phaDspAmtP)
 .s amt=amt_"^"_$g(phaRetAmtY)
 .s amt=amt_"^"_$g(phaDspAmtF)
 .s amt=amt_"^"_$g(phaDspAmtS)
 .s amt=amt_"^"_$g(phaRetAmtH)
 .s amt=amt_"^"_$g(phaRetAmtZ)
 .s amt=amt_"^"_$g(giftRecAmt)
 .s amt=amt_"^"_$g(retAspAmt)
 .s amt=amt_"^"_$g(phaRetAspAmt)
 .s amt=amt_"^"_$g(giftTrfAmt)
 .s amt=amt_"^"_$g(chgRecAmt)
 .s amt=amt_"^"_$g(chgRetAmt)
 .s amt=amt_"^"_$g(mRecAmt)
 .s amt=amt_"^"_$g(stktkAdjAmt)
 .s amt=amt_"^"_$g(manuXAmt)
 .s amt=amt_"^"_$g(manuMAmt)
 .s amt=amt_"^"_$g(phoRetAspAmt)
 .s amt=amt_"^"_$g(trfIAspAmt)
 .s amt=amt_"^"_$g(recAspAmt)
 .s ^TMP("DHCST","StkMonReportPrint","CalStkMonDetail",pid,sm,grpdesc,stkcat,n)=amt 
 q n
}

ClassMethod NewPid()
{
	q $i(^DHCSTPID("StkMonReportPrint"))
}

/// 获取科室类组
/// w ##class(web.DHCST.StkMonReportPrint).GetStkCatGrpByLoc(100)
ClassMethod GetStkCatGrpByLoc(LocId)
{
	n (LocId)
	q:LocId="" ""
	s StkCatGrpStr=""
	s StkType=..sssCode()
	s SLCGRowid=""
	f  s SLCGRowid=$o(^DHCSLCG(0,"CTLOC",LocId,StkType,SLCGRowid)) q:SLCGRowid=""  d
	.s StkGrpDr=$p($G(^DHCSLCG(SLCGRowid)),"^",2)
	.q:StkGrpDr=""
	.s StkGrpDesc=$p(^DHCSCG(StkGrpDr),"^",2)
	.i StkCatGrpStr="" s StkCatGrpStr=StkGrpDesc
	.e  s StkCatGrpStr=StkCatGrpStr_","_StkGrpDesc
	q StkCatGrpStr
}

}

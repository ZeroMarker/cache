Include webimport

IncludeGenerator webimport

Class web.DHCBldReqLabInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetLabInfoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", curId As %Library.String = "")
{
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set MEDDATA=Config.DataNamespace
 Set LABDATA=Config.LabDataNamespace
 Set CurrentNS=$ZNSPACE
 zn MEDDATA
 ;curId:"debtor^AdmId"
 s debtorDR=$p(curId,"^")
 i '$l(debtorDR) d
 .s admId=$p(curId,"^",2)
 .s papmiId=+^PAADM(admId)
 .s debtorDR=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
 
 ZN LABDATA		
  s bldGpId=""
  i $d(^TDEB(debtorDR)) s bldGpId=$p(^TDEB(debtorDR),"\",4)
  s BG="",Rh=""
  i $l(bldGpId) d
  .s BG=$p(^TTAB("BB-BG",bldGpId),"\",2)_"型"
  .i $p(^TTAB("BB-BG",bldGpId),"\",3)="P" s Rh="阳性"
  .i $p(^TTAB("BB-BG",bldGpId),"\",3)="N" s Rh="阴性"
  ;s dt=0
  ;i Rh="" d   ;Rh  K0010
  ;.s res=$$getResult(debtorDR,"K0010")
  ;.i $l(res) d
  ;..i +$p(res,"^",1)>dt s Rh=$p(res,$c(1),2),dt=+$p(res,"^",1)
  ;RBC	A0080	A2320  B0120 B1940
  s dt=0,RBC=""
  s res=$$getResult(debtorDR,"A0080")
  i $l(res) d
  .i +$p(res,"^",1)>dt s RBC=$p(res,$c(1),2),dt=+$p(res,"^",1)
  s res=$$getResult(debtorDR,"A2320")
  i $l(res) d
  .i +$p(res,"^",1)>dt s RBC=$p(res,$c(1),2),dt=+$p(res,"^",1)
  s res=$$getResult(debtorDR,"B0120")
  i $l(res) d
  .i +$p(res,"^",1)>dt s RBC=$p(res,$c(1),2),dt=+$p(res,"^",1)
  s res=$$getResult(debtorDR,"B1940")
  i $l(res) d
  .i +$p(res,"^",1)>dt s RBC=$p(res,$c(1),2),dt=+$p(res,"^",1)
  ;HCT	A0100 A2340 B0140 B1960
  s dt=0,HCT=""
  s res=$$getResult(debtorDR,"A0100")
  i $l(res) d
  .i +$p(res,"^",1)>dt s HCT=$p(res,$c(1),2),dt=+$p(res,"^",1)
  s res=$$getResult(debtorDR,"A2340")
  i $l(res) d
  .i +$p(res,"^",1)>dt s HCT=$p(res,$c(1),2),dt=+$p(res,"^",1)
  s res=$$getResult(debtorDR,"B0140")
  i $l(res) d
  .i +$p(res,"^",1)>dt s HCT=$p(res,$c(1),2),dt=+$p(res,"^",1)
  s res=$$getResult(debtorDR,"B1960")
  i $l(res) d
  .i +$p(res,"^",1)>dt s HCT=$p(res,$c(1),2),dt=+$p(res,"^",1)
  ;Hb	A0960
  s dt=0,HGB=""
  s res=$$getResult(debtorDR,"A0960")
  i $l(res) d
  .i +$p(res,"^",1)>dt s HGB=$p(res,$c(1),2),dt=+$p(res,"^",1)
  ;PLT	A0150 A2390 B0190 B2010
  s dt=0,PLT=""
  s res=$$getResult(debtorDR,"A0150")
  i $l(res) d
  .i +$p(res,"^",1)>dt s PLT=$p(res,$c(1),2),dt=+$p(res,"^",1)
  s res=$$getResult(debtorDR,"A2390")
  i $l(res) d
  .i +$p(res,"^",1)>dt s PLT=$p(res,$c(1),2),dt=+$p(res,"^",1)
  s res=$$getResult(debtorDR,"B2010")
  i $l(res) d
  .i +$p(res,"^",1)>dt s PLT=$p(res,$c(1),2),dt=+$p(res,"^",1)
  s res=$$getResult(debtorDR,"B0190")
  i $l(res) d
  .i +$p(res,"^",1)>dt s PLT=$p(res,$c(1),2),dt=+$p(res,"^",1)
  ;ALT	A2160 C0410
  s dt=0,ALT=""
  s res=$$getResult(debtorDR,"A2160")
  i $l(res) d
  .i +$p(res,"^",1)>dt s ALT=$p(res,$c(1),2),dt=+$p(res,"^",1)
  s res=$$getResult(debtorDR,"C0410")
  i $l(res) d
  .i +$p(res,"^",1)>dt s ALT=$p(res,$c(1),2),dt=+$p(res,"^",1)
  ;HBsAg	C0760
  s dt=0,HBsAg=""
  s res=$$getResult(debtorDR,"C0760")
  i $l(res) d
  .i +$p(res,"^",1)>dt s HBsAg=$p(res,$c(1),2),dt=+$p(res,"^",1)
  ;HBsAb	C0770
  s dt=0,AntiHBs=""
  s res=$$getResult(debtorDR,"C0770")
  i $l(res) d
  .i +$p(res,"^",1)>dt s AntiHBs=$p(res,$c(1),2),dt=+$p(res,"^",1)
  ;HBeAg	C0780
  s dt=0,HBeAg=""
  s res=$$getResult(debtorDR,"C0780")
  i $l(res) d
  .i +$p(res,"^",1)>dt s HBeAg=$p(res,$c(1),2),dt=+$p(res,"^",1)
  ;HBeAb	C0790
  s dt=0,AntiHBe=""
  s res=$$getResult(debtorDR,"C0790")
  i $l(res) d
  .i +$p(res,"^",1)>dt s AntiHBe=$p(res,$c(1),2),dt=+$p(res,"^",1)
  ;HBcAb	C0800
  s dt=0,AntiHBc=""
  s res=$$getResult(debtorDR,"C0800")
  i $l(res) d
  .i +$p(res,"^",1)>dt s AntiHBc=$p(res,$c(1),2),dt=+$p(res,"^",1)
  ;Anti-HCV	E0040
  s dt=0,AntiHCV=""
  s res=$$getResult(debtorDR,"E0040")
  i $l(res) d
  .i +$p(res,"^",1)>dt s AntiHCV=$p(res,$c(1),2),dt=+$p(res,"^",1)
  ;Anti-HIV	E0020
  s dt=0,AntiHIV=""
  s res=$$getResult(debtorDR,"E0020")
  i $l(res) d
  .i +$p(res,"^",1)>dt s AntiHIV=$p(res,$c(1),2),dt=+$p(res,"^",1)
  ;梅毒	D0570
  s dt=0,MD=""
  s res=$$getResult(debtorDR,"D0570")
  i $l(res) d
  .i +$p(res,"^",1)>dt s MD=$p(res,$c(1),2),dt=+$p(res,"^",1)
  
  zn CurrentNS
  
  s retStr=BG_"^"_Rh_"^"_RBC_"^"_HCT_"^"_HGB_"^"_PLT_"^"_ALT_"^"_HBsAg_"^"_AntiHBs_"^"_HBeAg_"^"_AntiHBe_"^"_AntiHBc_"^"_AntiHCV_"^"_AntiHIV_"^"_MD

  s retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
  &javascript<#(retval)#>
  q retStr

getResult(debtor,tc)  ;TrakCare
  s ret=""
  i '$d(^TDHCOldResult(1,debtor,tc)) q ret
  i $d(^TDHCOldResult(1,debtor,tc)) d
  .s dd=$o(^TDHCOldResult(1,debtor,tc,""),-1)
  .i '$l(dd) q
  .s tt=$o(^TDHCOldResult(1,debtor,tc,dd,""),-1)
  .i '$l(tt) q
  .s x1=$o(^TDHCOldResult(1,debtor,tc,dd,tt,""),-1)
  .i '$l(x1) q
  .s x2=$o(^TDHCOldResult(1,debtor,tc,dd,tt,x1,""),-1)
  .i '$l(x2) q
  .s x3=$o(^TDHCOldResult(1,debtor,tc,dd,tt,x1,x2,""),-1)
  .i '$l(x3)
  .i '$d(^TEPI(x1,1,x2,x3,"DATA",tc)) q
  .s ret=$p(^TEPI(x1,1,x2,x3,"DATA",tc),"\",1)
   s itmtype=$p(^TTAB("TC",tc),"\",3)
   i itmtype["N" d    ;numeric
   .s decimal=$e(itmtype,2)
   .i decimal="" s decimal="0"
   .s temres=$$CheckResDecimal^CHDhcLabReport(ret,decimal)
   .s ret=temres_$c(1)_temres
   ;文本
   i itmtype["X" d
   .s ret=ret_$c(1)_ret
   ;标准备注
   i itmtype["S" d
   .s preres=""
   .i $l(ret),$d(^TTAB("TC",tc,2,ret,1))  d
   ..s preres=$g(^TTAB("TC",tc,2,ret,1))
   .s ret=ret_$c(1)_preres
   ;血型
   i itmtype["B" d
   .s preres=""
   .i $l(ret),$d(^TTAB("BB-BG",ret)) d
   ..s preres=$p(^TTAB("BB-BG",ret),"\",1)
   .s ret=ret_$c(1)_preres
   ;安贞阴阳性处理
   s unit=$p(^TTAB("TC",tc),"\",2)
   ;转换类型
   i $p(^TTAB("TC",tc),"\",7)="Y" d
   .s tret=ret
   .s ret=$$standdata(tc,x1,ret)
   .s ret=tret_ret_$c(1)_ret
   s tt=$tr($zt(tt),":")
   i $l(ret) s ret=dd_tt_"^"_ret_" "_unit
   q ret


standdata(itmcode,labno,res)  ;求正常值 
  s itmcode=$g(itmcode),res=$g(res)
  s sex=$P($g(^TEPI(labno)),"\",3)
  s age=$P($g(^TEPI(labno)),"\",25)
  s age=+age
  i sex="" s sex="M"
  s itmcode=$g(itmcode) 
  s ranges=""
  s tvalue=$$ranges^LVBVIS1(itmcode,age,sex,"",0,"","")
  s lowvalue=$p(tvalue,$c(1),1)
  s hvalue=$p(tvalue,$c(1),2)
  i $tr(tvalue,$c(1))'="" d
  .s ranges="{"_lowvalue_"-"_hvalue_"}"
  .s ranges=$tr(ranges,$c(1))
  i res'="" d
  .s res=$tr(res,">,<")
  .i ranges'="" d
  ..i $p(^TTAB("TC",itmcode),"\",7)="Y" d
  ...s res1="0"
  ...i $e(ranges,2)="-" d
  ....s low=$tr($p(ranges,"-",1,2),"{"),high=$tr($p(ranges,"-",3,4),"}")
  ....i res<low s res1="1"
  ....i res>high s res1="1"
  ...i $d(^TTAB("TC",itmcode,2,res1)),$d(^TTAB("TC",itmcode,2,res1,1)) d
  ....s ranges=^TTAB("TC",itmcode,2,res1,1)
  q ranges
}

}

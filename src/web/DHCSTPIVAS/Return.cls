/// creator: 	yunhaibao
/// createdate: 2018-08-13
/// description:配液退药
/// 实际流程:进仓前在系统进行配置,后打印停止签,在需配置的药品中挑选出停止签的,因此此类退药??
Class web.DHCSTPIVAS.Return Extends web.DHCSTPIVAS.Common
{

/// creator:	yunhaibao
/// createdate: 2018-08-13
/// description:获取待退药病人列表
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Return","QueryPat",^PHATMP("MYQ","web.DHCSTPIVAS.Return","QueryPat"))
Query QueryPat(inputStr = "") As websys.Query(ROWSPEC = "admId,patId,patNo,patName,bedNo,wardDesc,wardId")
{
}

ClassMethod QueryPatExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:inputStr="" $$$OK
	s retData=..GetNeedReturnData(inputStr,"QueryPat")
	s pid=$p(retData,"^",1)
	s sortIndex=""
	f  s sortIndex=$o(^||TMP("DHCST",$ClassName(),"GetNeedReturnData","QueryPat",pid,sortIndex)) q:sortIndex=""  d
	.s count=""
	.f  s count=$o(^||TMP("DHCST",$ClassName(),"GetNeedReturnData","QueryPat",pid,sortIndex,count)) q:count=""  d
	..s data=^||TMP("DHCST",$ClassName(),"GetNeedReturnData","QueryPat",pid,sortIndex,count)
	..s ^CacheTemp(repid,ind)=$lfs(data,"^")    
	..s ind=ind+1	
	k ^||TMP("DHCST",$ClassName(),"GetNeedReturnData","QueryPat",pid)
	q $$$OK
}

/// creator:	yunhaibao
/// createdate: 2018-08-13
/// description:获取待退药明细列表,不分页
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Return","QueryOrdExe","186^^2022-08-28^2022-12-21^^^1655")
Query QueryOrdExe(inputStr = "") As websys.Query(ROWSPEC = "mDsp,dspId,doseDateTime,incCode,incDesc,dspQty,canRetQty,incSpec,manfDesc,sp,spAmt,oeoriSign,batNo,bUomDesc,psState,psNumber,packFlag,dspSubId,phacItmLbId")
{
}

ClassMethod QueryOrdExeExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	//s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.Return","QueryOrdExe")=inputStr
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:inputStr="" $$$OK
	s retData=..GetNeedReturnData(inputStr,"QueryOrdExe")
	s pid=$p(retData,"^",1)
	s sortIndex=""
	f  s sortIndex=$o(^||TMP("DHCST",$ClassName(),"GetNeedReturnData","QueryOrdExe",pid,sortIndex)) q:sortIndex=""  d
	.s mDsp=""
	.f  s mDsp=$o(^||TMP("DHCST",$ClassName(),"GetNeedReturnData","QueryOrdExe",pid,sortIndex,mDsp)) q:mDsp=""  d
	..q:+mDsp=0
	..s mDspCnt=+$g(^||TMP("DHCST",$ClassName(),"GetNeedReturnData","QueryOrdExe","MDspCnt",pid,mDsp))
	..s dspId="",dspCnt=0
	..f  s dspId=$o(^||TMP("DHCST",$ClassName(),"GetNeedReturnData","QueryOrdExe",pid,sortIndex,mDsp,dspId)) q:dspId=""  d
	...q:+dspId=0
	...s data=^||TMP("DHCST",$ClassName(),"GetNeedReturnData","QueryOrdExe",pid,sortIndex,mDsp,dspId)
	...s dspCnt=dspCnt+1
	...s oeoriSign=""
	...i dspCnt'=1 d
	....s oeoriSign=##class(web.DHCSTPIVAS.Common).OeoriSign(0)
	...i dspCnt=1 s oeoriSign=##class(web.DHCSTPIVAS.Common).OeoriSign(-1)
	...i dspCnt=mDspCnt s oeoriSign=##class(web.DHCSTPIVAS.Common).OeoriSign(1)
	...i mDspCnt=1 s oeoriSign=""
	...s $p(data,"^",12)=oeoriSign
	...s ^CacheTemp(repid,ind)=$lfs(data,"^")    
	...s ind=ind+1	
	k ^||TMP("DHCST",$ClassName(),"GetNeedReturnData","QueryOrdExe",pid)
	k ^||TMP("DHCST",$ClassName(),"GetNeedReturnData","QueryOrdExe","MDspCnt",pid)
	q $$$OK
}

/// description: 获取需退药数据
/// input:		 ^1:配液中心Id,^2:病区Id,^3:用药开始日期,^4:用药结束日期,^5:登记号,^6:条码
/// 目前静配没用医生科室发药
/// w ##class(web.DHCSTPIVAS.Return).GetNeedReturnData("101^^2018-08-01^2018-08-13","QueryPat")
ClassMethod GetNeedReturnData(inputStr, queryType)
{
	s PivaLocId=$p(inputStr,"^",1)
	s WardId=$p(inputStr,"^",2)
	s StartDate=$p(inputStr,"^",3)
	s EndDate=$p(inputStr,"^",4)
	s PatNo=$p(inputStr,"^",5)
	s BarCode=$p(inputStr,"^",6)
	s admIdStr=$p(inputStr,"^",7)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s BarCode=$Replace(BarCode,"-","||")
	q:PivaLocId="" ""
	s HospId=$p(^CTLOC(PivaLocId),"^",22)
	s PatId=""
	&SQL(SELECT PAPMI_RowId1 into :PatId FROM PA_PatMas WHERE PAPMI_No=:PatNo)	
	s pid=..NewPid()
	s count=0
	i 1=1 d
	.s calcuDate=""
	.f calcuDate=StartDate:1:EndDate d
	..i admIdStr'="" d
	...s admIdLen=$l(admIdStr,",")
	...s admI=""
	...f admI=1:1:admIdLen d
	....s admId=$p(admIdStr,",",admI)
	....q:admId=""
	....s patId=$p(^PAADM(admId),"^",1)
	....s admStatus=##Class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(admId)
	....q:admStatus=0
	....s dspId=""
	....f  s dspId=$o(^DHCOEDISQTY(0,"ADM",PivaLocId,calcuDate,"C",admId,dspId)) q:dspId=""  d
	.....q:+dspId=0
	.....d CheckDspData
	..e  d
	...s admId=""
	...f  s admId=$o(^DHCOEDISQTY(0,"ADM",PivaLocId,calcuDate,"C",admId)) q:(admId="")  d
	....q:+admId=0
	....q:((queryType="QueryPat")&&($d(GetNeedReturnDataArr("AdmId",admId))))
	....s patId=$p(^PAADM(admId),"^",1)
	....q:(PatId'="")&&(PatId'=patId)
	....// 过滤-出院
	....s admStatus=##Class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(admId)
	....//w "admId:"_admId_" admStatus:"_admStatus,!
	....q:admStatus=0
	....s dspId=""
	....f  s dspId=$o(^DHCOEDISQTY(0,"ADM",PivaLocId,calcuDate,"C",admId,dspId)) q:(dspId="")||((queryType="QueryPat")&&($d(GetNeedReturnDataArr("AdmId",admId))))  d
	.....q:+dspId=0
	.....d CheckDspData
	e  d
	.// 条码为空可快速定位
	q pid
CheckDspData
	s grpNo=$p(^DHCOEDISQTY(dspId),"^",4)
	s mDsp=##class(web.DHCSTPIVAS.Common).GetMainDspId(dspId,grpNo)
	s mOeore=$p(^DHCOEDISQTY(mDsp),"^",3)
	q:(BarCode'="")&&(BarCode'=mOeore)
	s psStateStr=##class(web.DHCSTPIVAS.Common).CurPsState(mDsp)
	s psState=$p(psStateStr,"^",2)
	s psNumber=$p(psStateStr,"^",1)
	s packFlag=##class(web.DHCSTPIVAS.Common).DspPackFlag(mDsp)
	//过滤配置后，未置可退的药品且未打包药品不显示
	s ExcFlag=##class(PHA.FACE.OUT.Method).IfOeoreHas60(mOeore)
	s reqNeedAudit=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",PivaLocId,"","ReqNeedAudit")	// 非打包药品是否需要置可退
	q:(reqNeedAudit="Y")&&(ExcFlag="Y")&&(packFlag="")
	//过滤打包药品未置为可退（参数设置了仅置为可退后才能申请"Y"）
	s pogId=$o(^PIVA(0,"DSP",mDsp,""))
	s packReqNeedAudit=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",PivaLocId,"","PackReqAudit")
	s psNumber=$p(##class(web.DHCSTPIVAS.Common).CurPsState(mDsp),"^",1)
	q:(packReqNeedAudit="Y")&&(packFlag="P")&&(psNumber>=85)&&($p(^PIVA(pogId),"^",28)'="Y")
	// 过滤条件病区
	s wardLocId=$p(^DHCOEDISQTY(dspId),"^",22)
	s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
	q:(WardId'="")&&(WardId'=wardId)
	s oeore=$p(^DHCOEDISQTY(dspId),"^",3)
	q:oeore="" 
	s oeoreStatusDr=$p(^OEORD(+oeore,"I",+$p(oeore,"||",2),"X",$p(oeore,"||",3)),"^",16)
	q:oeoreStatusDr=""
	s oeoreStatus=$p(^OEC("STAT",oeoreStatusDr),"^",1) 
	// 过滤-停止执行可做申请 
	q:(oeoreStatus'="D")
	s phacItmId=$p(^DHCOEDISQTY(dspId),"^",14)
	q:+phacItmId=0
	s phacId=+phacItmId
	s phacItm=$p(phacItmId,"||",2)
	s canRet=""
	s phacItmLb=""
	f  s phacItmLb=$o(^DHCPHAC(phacId,"I",phacItm,"B",phacItmLb))  q:phacItmLb=""  d
	.q:+phacItmLb=0
	.s phacItmLbId=phacId_"||"_phacItm_"||"_phacItmLb
	.s phacItmLbData=^DHCPHAC(phacId,"I",phacItm,"B",phacItmLb)
	.s dspSubId=$P(phacItmLbData,"^",7)
	.s inclb=$p(phacItmLbData,"^",1)
	.s dspQty=$p(phacItmLbData,"^",2)
	.s reqedQty=##class(web.DHCSTRETREQUEST).GetReqQtyByPhacLb(phacItmLbId)   // 已申请未退
	.q:reqedQty>0
	.s retedQty=##class(web.DHCSTPHARETURN).ReturnedQtyByPhacLb(phacItmLbId) // 已退药数量
	.s canRetQty=dspQty-retedQty							   		  // 还可退数量
	.q:canRetQty<=0
	.s canRet=1
	.q:queryType="QueryPat"
	.i queryType="QueryOrdExe" d
	..// 查询医嘱明细
    ..s doseDate=$p(^DHCOEDISQTY(mDsp),"^",21)
    ..s doseTime=$p(^DHCOEDISQTY(mDsp),"^",20)
    ..s doseDTHtml=##class(web.DHCSTPIVAS.Common).DateShortFormat(doseDate)_" "_##class(web.DHCSTPIVAS.Common).TimeShortFormat(doseTime)
	..s dspDate=$p(^DHCPHAC(phacId),"^",7)
	..s incId=+inclb
	..s incCode=$P(^INCI(incId,1),"^",1)
	..s incDesc=##class(PHA.PIVAS.Data.Base).InciDesc(incId)
	..s bUomId=$p(^INCI(incId,1),"^",10)
	..s bUomDesc=##class(PHA.PIVAS.Data.Base).UomDesc(bUomId)
	..s incSpec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",incId)
	..s manfDesc=$lg(##class(PHA.COM.Drug).GetManf(incId), 3)
	..s pogId=$o(^PIVA(0,"DSP",mDsp,""))
	..s batNo=$s(pogId'="":$p(^PIVA(pogId),"^",3),1:"")
	..s sp=$P(phacItmLbData,"^",5)
	..s spAmt=$P(phacItmLbData,"^",6)
	..s oeoriSign=""
	..s dspQty=$fn(dspQty,"",$l($p(dspQty,".",2)))
	..s canRetQty=$fn(canRetQty,"",$l($p(canRetQty,".",2)))
	..s spAmt=$fn(spAmt,"",$l($p(spAmt,".",2)))
	..s sp=$fn(sp,"",$l($p(sp,".",2)))
	..s data1=mDsp_"^"_dspId_"^"_doseDTHtml_"^"_incCode_"^"_incDesc
	..s data2=dspQty_"^"_canRetQty_"^"_incSpec_"^"_manfDesc_"^"_sp
	..s data3=spAmt_"^"_oeoriSign_"^"_batNo_"^"_bUomDesc_"^"_psState
	..s data4=psNumber_"^"_packFlag_"^"_dspSubId_"^"_phacItmLbId
	..s data=data1_"^"_data2_"^"_data3_"^"_data4
	..s sortIndex=doseDate_"||"_doseTime
	..s ^||TMP("DHCST",$ClassName(),"GetNeedReturnData",queryType,pid,sortIndex,mDsp,dspSubId)=data
	..s ^||TMP("DHCST",$ClassName(),"GetNeedReturnData",queryType,"MDspCnt",pid,mDsp)=1+$g(^||TMP("DHCST",$ClassName(),"GetNeedReturnData",queryType,"MDspCnt",pid,mDsp))	
	q:canRet=""
	i queryType="QueryPat" d
	.// 查询病人,查到就退出
	.s patNo=$P(^PAPER(patId,"PAT",1),"^",1)
	.s patName=$p(^PAPER(patId,"ALL"),"^",1)
	.s bedId=$P(^PAADM(admId),"^",73)
	.i bedId'="" s bedNo=$P(^PAWARD(+bedId,"BED",+$p(bedId,"||",2)),"^",1)
	.e  s bedNo="*"
	.s wardDesc=##class(PHA.PIVAS.Data.Base).WardDesc(wardId)
	.s sortIndex=wardDesc_"||"_bedNo_"||"_bedId_"||"_patId
	.s data1=admId_"^"_patId_"^"_patNo_"^"_patName_"^"_bedNo
	.s data2=wardDesc_"^"_wardId
	.s data=data1_"^"_data2
	.
	.s ^||TMP("DHCST",$ClassName(),"GetNeedReturnData",queryType,pid,sortIndex,count)=data
	.s GetNeedReturnDataArr("AdmId",admId)=""
	q
}

/// description: 执行退药
ClassMethod Return(recLocId, userId, inputData)
{
	s exeRet=##class(web.DHCSTPHARETURN).ExecReturn(recLocId,userId,"", inputData)
	s isSucc=$p(exeRet,"^",1)
	q:isSucc="success" "0|$|"_$p(exeRet,"^",2)
	s errCode=$p(exeRet,"^",2)
	i errCode="-9" s errCode=..Translate("存在未退申请单不允许直接退药")  // @translate
	e  i errCode="-3" s errCode=..Translate("存在药品退药数量大于可退数量")  // @translate
	e  i errCode="-4" s errCode=..Translate("该患者已做完最终结算")  // @translate
	e  i errCode="-11" s errCode=..Translate("该患者已中途结算")  // @translate
	e  i errCode="-12" s errCode=..Translate("存在执行记录状态不是停止执行或撤销执行的药品")  // @translate
	e  s errCode=..ReplaceTranslation("退药失败,错误信息为{{reason}}", $lb("{{reason}}", errCode)) // @translate
	q "-1|$|"_errCode
}

/// description: 扫描退药前验证,仅验证并给与提示是否退药,限制性验证在退药过程
/// w ##class(web.DHCSTPIVAS.Return).CheckScan("280||191||47")
ClassMethod CheckScan(barCode)
{
	s mOeore=##class(web.DHCSTPIVAS.Common).BarCodeToOeore(barCode)
	q:mOeore="" 0
	s mDsp=$o(^DHCOEDISQTY(0,"OEORE",mOeore,""))
	q:mDsp="" 0
	s psStateStr=##class(web.DHCSTPIVAS.Common).CurPsState(mDsp)
	s psState=$p(psStateStr,"^",2)
	s psNumber=$p(psStateStr,"^",1)
	s packFlag=##class(web.DHCSTPIVAS.Common).DspPackFlag(mDsp)
	q:(psNumber>50)&(packFlag="") "-1|$|" _ ..Translate("非打包药品已配置")	// @translate
	q 0
}

/// description: 扫描退药,PDA及PC
/// input:		 calcuTmp(1:汇总已退合计)
/// debug:		 w ##class(web.DHCSTPIVAS.Return).ReturnByBarCode("180-709-1",711,89,1,"",1)
ClassMethod ReturnByBarCode(barCode, userId, locId, reasonId, pid = "", calcuTmp = "")
{
	q:userId="" "-1|$|" _ ..Translate("用户Id为空") // @translate
	q:locId="" "-1|$|" _ ..Translate("登陆科室Id为空") // @translate
	//q:reasonId="" "-1|$|退药原因为空"
	Q:(barCode["-")&&($l(barCode,"-")'=3) -1_"|$|" _ ..Translate("标签长度错误") // @translate
	Q:barCode="" -1_"|$|" _ ..Translate("标签为空") // @translate
	s mOeore=##class(web.DHCSTPIVAS.Common).BarCodeToOeore(barCode)
	S ord=$p(mOeore,"||",1)
	S itm=$p(mOeore,"||",2)
	s exe=$p(mOeore,"||",3)
	S mOeori=ord_"||"_itm
	s mDsp=$o(^DHCOEDISQTY(0,"OEORE",mOeore,""))
	q:mDsp="" -1_"|$|" _ ..Translate("标签错误,获取不到医嘱信息") // @translate
	s pogId=$o(^PIVA(0,"DSP",mDsp,""))
	Q:pogId="" -1_"|$|" _ ..Translate("尚未打印标签") // @translate
	Q:'$d(^PIVA(pogId)) -1_"|$|" _ ..Translate("无此标签") // @translate
 	s recLocId=$p(^DHCOEDISQTY(mDsp),"^",24)
 	q:locId'=recLocId "-1|$|" _ ..Translate("标签非本配液中心调配") // @translate
	s oeoreStatusDr=+$p(^OEORD(+ord,"I",+itm,"X",exe),"^",16)
	s oeoreStatus=$p($g(^OEC("STAT",oeoreStatusDr)),"^",1) 
	q:(oeoreStatus'="D") "-1|$|" _ ..Translate("执行记录未停止") // @translate
	q:(##class(web.DHCSTPIVAS.Common).IsOrderReturned(pogId) = "Y") "-1|$|" _ ..Translate("已退药") // @translate
	q:(##class(web.DHCSTPIVAS.Common).IsOrderDisped(pogId) '= "Y") "-1|$|" _ ..Translate("未发药") // @translate
	s admId=$p(^OEORD(ord),"^",1)
	s admStatus=##Class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(admId)	
	q:admStatus=0 "-1|$|" _ ..Translate("已出院") // @translate
	// 最终结算??
	// 加锁
   	s lockRet=##class(web.DHCSTPIVAS.Common).Lock("DHCOEDispensing",mDsp)
	q:lockRet'=0 lockRet 	
	s inputData=""
	s pogItm=""
	f  s pogItm=$o(^PIVA(pogId,"I",pogItm)) q:pogItm=""  d
	.q:+pogItm=0
	.s dspId=$p(^PIVA(pogId,"I",pogItm),"^",1)
	.s phacItmId=$p(^DHCOEDISQTY(dspId),"^",14)
	.q:+phacItmId=0
	.s phacId=+phacItmId
	.s phacItm=$p(phacItmId,"||",2)
	.s phacItmLb=""
	.f  s phacItmLb=$o(^DHCPHAC(phacId,"I",phacItm,"B",phacItmLb))  q:phacItmLb=""  d
	..q:+phacItmLb=0
	..s phacItmLbId=phacId_"||"_phacItm_"||"_phacItmLb
	..s phacItmLbData=^DHCPHAC(phacId,"I",phacItm,"B",phacItmLb)
	..s dspSubId=$P(phacItmLbData,"^",7)
	..s inclb=$p(phacItmLbData,"^",1)
	..s dspQty=$p(phacItmLbData,"^",2)
	..s reqedQty=##class(web.DHCSTRETREQUEST).GetReqQtyByPhacLb(phacItmLbId)   // 已申请未退
	..q:reqedQty>0
	..s retedQty=##class(web.DHCSTPHARETURN).ReturnedQtyByPhacLb(phacItmLbId) // 已退药数量
	..s canRetQty=dspQty-retedQty						   		  // 还可退数量
	..q:canRetQty<=0
	..s canRetData=dspId_"^"_canRetQty_"^"_reasonId_"^"_dspSubId_"^"_phacItmLbId
	..s inputData=$s(inputData="":canRetData,1:inputData_","_canRetData)
	i inputData=""  d ##class(web.DHCSTPIVAS.Common).UnLock("DHCOEDispensing",mDsp)	q "-1|$|" _ ..Translate("不需要退药")  // @translate
	s ret=..Return(locId, userId, inputData)
	d ##class(web.DHCSTPIVAS.Common).UnLock("DHCOEDispensing",mDsp)	
	i $p(ret,"|$|",1)=0 d
	.s labelData=##class(web.DHCSTPIVAS.PrintCom).GetLabelJson(pogId).%ToJSON()
	.s $p(ret,"|$|",2)=labelData
	.i pid="" s pid=..NewPid()
	.i calcuTmp=1 d ..CalcuTmpReturn(pid,inputData)
	.s $p(ret,"|$|",3)=pid
 	q ret
}

/// description: 临时global累计已退合计
ClassMethod CalcuTmpReturn(pid, inputData)
{
	s len=$l(inputData,",")
	s i=""
	f i=1:1:len d
	.s iData=$p(inputData,",",i)
	.q:iData=""
	.s dspId=$p(iData,"^",1)
	.s qty=$p(iData,"^",2)
	.s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
	.s arcItmId=$P($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",2)
	.i '$d(^TMP("DHCST",$ClassName(),"CalcuTmpReturn","Arcim",pid,arcItmId)) d
	..s ^TMP("DHCST",$ClassName(),"CalcuTmpReturn","Arcim",pid,arcItmId)=qty
	.e  d
	..s ^TMP("DHCST",$ClassName(),"CalcuTmpReturn","Arcim",pid,arcItmId)=qty+^TMP("DHCST",$ClassName(),"CalcuTmpReturn","Arcim",pid,arcItmId)
	s mDsp=$p($p(inputData,",",1),"^",1)
	s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
	s ^TMP("DHCST",$ClassName(),"CalcuTmpReturn","Ward",pid,wardLocId)=1+$g(^TMP("DHCST",$ClassName(),"CalcuTmpReturn","Ward",pid,wardLocId))
	q pid
}

/// description: 输出病区合计
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Return","CalcuTmpWard","100000")
Query CalcuTmpWard(pid = "") As websys.Query(ROWSPEC = "wardId,wardDesc,wardRetCnt")
{
}

ClassMethod CalcuTmpWardExecute(ByRef qHandle As %Binary, pid = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:pid="" $$$OK
	s wardLocId=""
	f  s wardLocId=$o(^TMP("DHCST",$ClassName(),"CalcuTmpReturn","Ward",pid,wardLocId)) q:wardLocId=""  d
	.s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
	.q:wardId=""
	.s wardDesc=##class(PHA.COM.Data.Base).LocDesc(wardLocId)
	.s wardRetCnt=+$g(^TMP("DHCST",$ClassName(),"CalcuTmpReturn","Ward",pid,wardLocId))
	.s ^CacheTemp(repid,ind)=$lb(wardId,wardDesc,$fn(wardRetCnt,"N"))    
	.s ind=ind+1	
	q $$$OK
}

/// description: 输出药品合计
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Return","CalcuTmpArcim","100000")
Query CalcuTmpArcim(pid = "") As websys.Query(ROWSPEC = "arcItmId,arcItmDesc,qty")
{
}

ClassMethod CalcuTmpArcimExecute(ByRef qHandle As %Binary, pid = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:pid="" $$$OK
	s arcItmId=""
	f  s arcItmId=$o(^TMP("DHCST",$ClassName(),"CalcuTmpReturn","Arcim",pid,arcItmId)) q:arcItmId=""  d
	.s arcItmDesc=##class(PHA.COM.Data.Base).ArcimDesc(arcItmId)
	.s qty=+$g(^TMP("DHCST",$ClassName(),"CalcuTmpReturn","Arcim",pid,arcItmId))
	.s ^CacheTemp(repid,ind)=$lb(arcItmId,arcItmDesc,$fn(qty,"N"))    
	.s ind=ind+1	
	q $$$OK
}

/// description: 清除累计已退合计
ClassMethod KillCalcuTmpReturn(pid)
{
	q:pid="" ""
	k ^TMP("DHCST",$ClassName(),"CalcuTmpReturn","Ward",pid)
	k ^TMP("DHCST",$ClassName(),"CalcuTmpReturn","Arcim",pid)
	q ""
}

/// description: 进程号
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"PIVA")
}

}

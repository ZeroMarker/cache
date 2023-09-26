/// 名称:  DHCLabResultStatus
/// 描述:  获取指定项目结果状态
/// 编写者：liuzf
/// 编写日期: 2010-04-02
Class web.DHCLabResultStatus Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, ProcedureBlock ]
{

/// Creator：      liuzf 
/// CreateDate：   2010-04-02
/// Description:： 根据Adm号,化验项目对照码取结果状态
/// Table： EP_VisitTestSetData
/// Input： Adm号,化验项目对照码
/// Output：0：否(异常)；1：是(正常)；2：未查；3：未回
/// Return：无        
/// Others：无    	
ClassMethod GetTCResultByAdmId(admId As %String, TCSync As %String) As %String
{
  s admId=$g(admId),TCSync=$g(TCSync)
  s ret=2
  ///根据项目对照码查询医嘱套代码
  Kill ^TMP($J)
  Set tc="" For  Set tc=$Order(^TTABi("TC","NNL",TCSync,tc)) Quit:tc=""  Do
  .Set ts="" For  Set ts=$Order(^TTAB("TC",tc,1,ts)) Quit:ts=""  Do
  ..Set ^TMP($J,"TS",ts)=""  
  
  //取admId项目检验医嘱
  s ordRowid=$o(^OEORD(0,"Adm",admId,""))
  i ordRowid="" q ret
  s childsub="" f  s childsub=$o(^OEORD(ordRowid,"I",childsub)) q:childsub=""  d
  .i '$d(^OEORD(ordRowid,"I",childsub,3)) q
  .s labno=$p(^OEORD(ordRowid,"I",childsub,3),"^",20)
  .q:'$l(labno)
  
  .s armRowid=$p(^OEORD(ordRowid,"I",childsub,1),"^",2)
  .q:armRowid="" 
  .s armId=$p(armRowid,"||",1)
  .s armchl=$p(armRowid,"||",2)
  .s Id=0 f  s Id=$o(^ARCIM(armId,armchl,"EXT",Id)) q:Id=""  d
  ..s ts=$p(^ARCIM(armId,armchl,"EXT",Id),"^",4)
  ..i $d(^TMP($J,"TS",ts)) s ret=3
  ..//医嘱合并处理？？？？
    
  .s labts=$p(^OEORD(ordRowid,"I",childsub,3),"^",35)
  .q:'$l(labts)
  .s ts=$p(labts,"||",2)
  .s tscnt=$p(labts,"||",3)
  .i '$d(^TMP($J,"TS",ts)) q
  .s ^TMP($J,"TSROWID",labno,ts,tscnt)=""
  i '$d(^TMP($J,"TSROWID")) q ret

  s labno="" f  s labno=$o(^TMP($J,"TSROWID",labno)) q:labno=""  d
  .s ts="" f  s ts=$o(^TMP($J,"TSROWID",labno,ts)) q:ts=""  d
  ..s tscnt="" f  s tscnt=$o(^TMP($J,"TSROWID",labno,ts,tscnt)) q:tscnt=""  d
  ...s tc="" f  s tc=$o(^TEPI(labno,1,ts,tscnt,"DATA",tc)) q:tc=""  d
  ....i '$d(^TTABi("TC","NNL",TCSync,tc)) q
  ....s ADate=$p(^TEPI(labno,1,ts,tscnt),"\",4)
  ....s ATime=$p(^TEPI(labno,1,ts,tscnt),"\",5)
  ....s Result=$p(^TEPI(labno,1,ts,tscnt,"DATA",tc),"\",1)
  ....S ^TMP($J,"RESULT",ADate,ATime)=labno_"^"_tc_"^"_Result
  
  s ret=3
  i '$d(^TMP($J,"RESULT")) q ret
  
  s ADate=$o(^TMP($J,"RESULT",""),-1)
  s ATime=$o(^TMP($J,"RESULT",ADate,""),-1)
  s labno=$p(^TMP($J,"RESULT",ADate,ATime),"^",1)
  s tc=$p(^TMP($J,"RESULT",ADate,ATime),"^",2)
  s Result=$p(^TMP($J,"RESULT",ADate,ATime),"^",3)
  s Flag=##Class(web.DHCLabResultStatus).CheckResultStatus(labno,tc,Result,ADate)
  k ^TMP($J)
  s ret=1
  i Flag'="" s ret=0
  q ret
}

/// Creator:      liuzf
/// CreatDate:    20100408
/// Description:  判断医嘱结果状态是否异常
/// Table:        CT_TestCode,CT_TestCodeRanges
/// Input:        检验RowID
/// Output:       
/// Return:       0：无异常结果；1：有异常结果
/// Others:   
ClassMethod checkTSResultStatus(tsrowid As %String) As %String
{
  s tsrowid=$g(tsrowid)
  s labno=$p(tsrowid,"||",1)
  s ts=$p(tsrowid,"||",2)
  s tscnt=$p(tsrowid,"||",3)
  s ret="0"
  i '$d(^TEPI(labno,1,ts,tscnt)) q ret
  s tc="" f  s tc=$o(^TEPI(labno,1,ts,tscnt,"DATA",tc)) q:(tc="")!(ret=1)  d
  .s Result=$p(^TEPI(labno,1,ts,tscnt,"DATA",tc),"\",1)
  .s ADate=$p(^TEPI(labno,1,ts,tscnt),"\",4)
  .s Flag=##Class(web.DHCLabResultStatus).CheckResultStatus(labno,tc,Result,ADate)
  .i Flag'="" s ret="1"
  q ret
}

/// Creator:      huhm
/// CreatDate:    20100203
/// Description:  判断结果状态
/// Table:        CT_TestCode,CT_TestCodeRanges
/// Input:        检验号,项目,结果,结果日期
/// Output:       
/// Return:       结果,异常提示
/// Others:   
ClassMethod CheckResultStatus(epis As %String, tc As %String, res As %String, ResDate As %String) As %String
{

 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set LABDATA=Config.LabDataNamespace
 Set CurrentNS=$ZNSPACE

  s epis=$g(epis),tc=$g(tc),res=$g(res),ResDate=$g(ResDate)
  s ItmType=$p(^TTAB("TC",tc),"\",3)
  s SpecDr=$p(^TEPI(epis),"\",3)
  s Age=$p(^TEPI(epis),"\",25)
  s CondDr=$p(^TEPI(epis,0),"\",17)
  s (Pregn,loc,mi,weeks)=""
  s Ptype="0"
  s RetValue=""
  //N
  i $e(ItmType,1)="N" d
  .zn LABDATA
  .s RangStr=$$ranges^LVBVIS1(tc,Age,SpecDr,Pregn,Ptype,ResDate,CondDr,loc,mi,weeks)  ;6.4
  .zn CurrentNS
  .s RetValue=$$NumericFlag(res,RangStr)
  //S
  i ItmType="S" s RetValue=$$StandardFlag(tc,res)
  //X
  i ItmType="X" s RetValue=$$FreeTextFlag(tc,res)
  //B2
  q RetValue 

 ///数字结果
NumericFlag(ItmRes,ItmRanges)
	s ItmRes=$g(ItmRes),ItmRanges=$g(ItmRanges)
	s (retvalue,retranges,retcolor)=""
	s ResLow=$p(ItmRanges,$c(1),1),ResHigh=$p(ItmRanges,$c(1),2)
    s ItmRes=$tr(ItmRes,"><")
    ///返回范围值
	s Ranges=""
	s RangSta="(",RangEnd=")"
	i ResLow="",ResHigh="" d 
	.s Ranges="" 
	i "<>"[$e(ResLow) d 
	.s Ranges=RangSta_ResLow_RangEnd
	e  d
	.s Ranges=RangSta_ResLow_"-"_ResHigh_RangEnd
    ///
	i Ranges="" q ""  //范围值为空
	i '$ISVALIDNUM(ItmRes) q "" //结果不为数字
	;normal check
	s ResFlag="N"
	s rang=ResLow_ResHigh
	i $l(rang) d
	.i (rang'["<")&(rang'[">") d
	..i ItmRes<ResLow s ResFlag="L" q
	..i ItmRes>ResHigh s ResFlag="H" q
	.i (rang["<") d
	..s lowflag=$$res^LVBVIS1(rang) ;$p(rang,"<",2) modify 20070914
	..i ItmRes>lowflag s ResFlag="H" 
	.i (rang[">") d
	..s highflag=$$res^LVBVIS1(rang) ;$p(rang,">",2) modify 20070914
	..i ItmRes<highflag s ResFlag="L"	
	i ResFlag="N" q "" 
	q ResFlag  
	
	///标准备注型	
StandardFlag(tc,ItmRes)
	i '$l(ItmRes) q ""
    s RetValue=""
    i $d(^TTAB("TC",tc,2,ItmRes)) s RetValue=$p(^TTAB("TC",tc,2,ItmRes),"\",1)
    i RetValue'="A" s RetValue=""
    q RetValue
    
	///文本类型
FreeTextFlag(ItmCode,ItmRes)
    s flag="N"
    s RetValue=""
    s std="" f  s std=$o(^TTAB("TC",ItmCode,2,std)) q:std=""  d
    .i $p(^TTAB("TC",ItmCode,2,std),"\",1)="A" d
    ..i $d(^TTAB("TC",ItmCode,2,std,1)),ItmRes[$g(^TTAB("TC",ItmCode,2,std,1)) s flag="A"
    i flag="A" s RetValue="A"
    q RetValue
}

/// Creator:      liuzf
/// CreatDate:    20110328
/// Description:  获取标本拒收信息和标本取消信息
/// Table:        DHC_RejectSpecimen,DHC_TSTrans
/// Input:        医嘱RowID,labno
/// Output:       
/// Return:       标本拒收信息和标本取消信息
/// Others:   
ClassMethod checkTSMemo(OrdRowID As %String, labno As %String) As %String
{
 i '$l(labno) q ""
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set LABDATA=Config.LabDataNamespace
 Set CurrentNS=$ZNSPACE
 s OrderId=$p(OrdRowID,"||",1)
 s childsub=$p(OrdRowID,"||",2)
 s arcim=$p(^OEORD(OrderId,"I",childsub,1),"^",2)
 s ItmStat=$p(^OEORD(OrderId,"I",childsub,1),"^",13)
 i ItmStat=4 q "【停止】"
 //liuzf 新提示 20131024--->
 i ItmStat=2 q "【作废】"
 i ItmStat=12 q "【撤销】"
  
 s ord=$g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),"EXT",0))
 s ts=""
 i $l(ord),$d(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),"EXT",ord)) s ts=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),"EXT",ord),"^",4)
 s tscnt=1
 s ret=""
 i '$l(ts) q ret

 i $p($g(^TEPI(labno,1,ts,tscnt)),"\",31)="C" s ret="【已登记】"
 i $p($g(^TEPI(labno,1,ts,tscnt)),"\",31)="E" s ret="【已初审】"
 i $p($g(^TEPI(labno,1,ts,tscnt)),"\",31)="A" s ret="【已发报告】"
 s isModify=""  //报告取消修改
 i ##Class(web.DHCLabPortal).IsModify(OrdRowID,"") {
 	s ret=ret_"【修改】"
 }
 
 i $d(^TEPI(labno,1,ts,tscnt)) q ret
 
  i $d(^[LABDATA]DHCRS(labno,ts,tscnt)) s ret=$p(^[LABDATA]DHCRS(labno,ts,tscnt),"\",11)
  i $l(ret) s ret="{拒收}"_ret
  i $l(ret) q ret
  i $d(^[LABDATA]DHCTSTrans(labno,ts,tscnt)) d
  .s time=""
  .s date=$o(^[LABDATA]DHCTSTrans(labno,ts,tscnt,""),-1)
  .i $l(date) s time=$o(^[LABDATA]DHCTSTrans(labno,ts,tscnt,date,""),-1)
  .i $l(date),$l(time) s ret=$p(^[LABDATA]DHCTSTrans(labno,ts,tscnt,date,time),"\",4)
  .i $l(ret) s ret="{取消}"_ret
  
  
  q ret
}

/// Creator:      liuzf
/// CreatDate:    20110328
/// Description:  获取标本拒收信息和标本取消信息
/// Table:        DHC_RejectSpecimen,DHC_TSTrans
/// Input:        医嘱RowID,labno
/// Output:       
/// Return:       标本拒收信息和标本取消信息
/// Others:   
ClassMethod checkReportStatus(LabTestSetRow As %String) As %String
{
				    s ResultStus="送检中"
				    i $l(LabTestSetRow)
				    {
					    s ResEpis=$p(LabTestSetRow,"||",1)
					    s ResTS=$p(LabTestSetRow,"||",2)
					    s ResTSCNT=$p(LabTestSetRow,"||",3)
					    i $l(ResEpis),$l(ResTS),$l(ResTSCNT)
					    {
						    s ResFlag=$p($g(^TEPI(ResEpis,1,ResTS,ResTSCNT)),"\",31)
						    i ResFlag="C" s ResultStus="检验中"
						    i ResFlag="E" s ResultStus="审核中"
						    i ResFlag="H" s ResultStus="复查中"
						    i ResFlag="A" s ResultStus="已审核"
					    }
				    }
}

}

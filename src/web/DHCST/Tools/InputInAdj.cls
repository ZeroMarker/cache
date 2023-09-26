Import sqluser

/// Author : MYQ
/// CreatDate : 20161215
/// description : BS版本药库导入库存调整程序
/// model: 科室名称	药品代码	药品名称	单位	数量	调整原因(必填)	
/// others:导入前请仔细核对文件为制表符格式的txt文件
/// rules : 默认先调整近效期批次(增加库存时都加到近效期上,减少库存从近效期开始减少)
/// 
/// windows路径:w ##class(web.DHCST.Tools.InputInAdj).ImportInAdj("C:\KCTZBuom.txt","")
/// 小机路径:w ##class(web.DHCST.Tools.InputInAdj).ImportInAdj("/tmp/stockrec.txt","")
Class web.DHCST.Tools.InputInAdj Extends (%RegisteredObject, %XML.Adaptor, web.DHCST.StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTSTOCKADJ";

/// 执行导入的总入口
ClassMethod ImportInAdj(fileName As %String, sub As %String = "") As %String
{
  n (fileName,sub)
  i sub="" s sub="web.DHCST.Tools.InputInAdj"
  s p=$zn
  k ^zTSA(p,sub)
  s ret=##class(web.DHCST.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  s inadj=""
  s i=1
  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .s cnt=cnt+1
  .tstart
  .s msg=""
  .i inadj="" d
  ..s inadj=..CreateInAdj(rowStr,.msg)
  .i inadj>0 w "调整单Rowid:"_inadj,!
  .e  d
  ..w inadj,!
  ..q
  .s ret=..InputInAdjItm(rowStr,.msg,inadj)
  .w "第"_cnt_"条记录,"_msg,!
  .i ret=0 d
  ..tcommit
  ..s successCnt=successCnt+1
  .e  d
  .. tro
  k ^zTSA(p,sub)  //删除临时global
  q "总记录数:"_cnt_",成功记录数:"_successCnt
}

/// 生成调整单主表
ClassMethod CreateInAdj(rowStr As %String, msg As %String) As %String
{
	n (rowStr,msg)
	s colNoStr=""
	s rowStr=$tr(rowStr,$c(13,10))
	s rowStr=$tr(rowStr," ","")
	s ret=0
	s del="^"
	///生成调整单主表
	s LocId=""
	s LocDesc=$p(rowStr,del,1)  //科室名称
	i LocDesc="" s ret="科室名称为空"
	q:ret'=0 ret
	s LocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),0))
	i +LocId>0 d
	.s ret=0
	e  d
	.s ret="此科室在系统中不存在"
	q:ret'=0 ret
	s hosp=$p(^CTLOC(LocId),"^",22)
	s UserId=""
	s UserName="demo"
	&sql(select ssusr_rowid into :UserID from ss_user where ssusr_initials=:UserName)
	s UserId=$g(UserID)
	i +UserId=0 d
	.s ret="没有取到userid"
	q:ret'=0 ret
	
	s Code=$p(rowStr,del,2)  //药品代码
	s IncId=""
	s IncId=##class(PHA.IN.COM.Method).GetInciByCode(Code,hosp)
	i +IncId=0 d
	.s ret="不存在该药品"_Code
	q:ret'=0 ret
	
	s incscdr=$p(^INCI(IncId,2),"^",2)	//库存分类
	s adjScg=$o(^DHCSCG("STKCAT",incscdr,""))	
	i +adjScg=0 d
	.s ret="不存在和该药品对应的类组"_Code
	q:ret'=0 ret
	
	s adjrecson=$p(rowStr,del,6)	//调整原因
	q:adjrecson="" "-1^原因为空"
	s adjreasonid=..GetReason(adjrecson,hosp)
	i adjreasonid="" d
	.s ret="不存在该原因"_adjrecson
	q:ret'=0 ret
	
	s adjStkType=..sssCode()  //库存类型
	s adjInst=""  //盘点主表rowid(DHC_INStktk)
	s adjComp="Y" //完成标志
	s adjState="10"  //调整单状态	10-未审核,20-审核
	s remark=""	 //备注(备注的文本行之间须用$c(1)分隔)
 	
	s MData=LocId_"^"_UserId_"^"_adjreasonid_"^"_adjScg_"^"_adjStkType_"^"_adjInst_"^"_adjComp_"^"_adjState_"^"_remark
	
	s inadjret=##class(web.DHCST.DHCINAdj).Update("",MData)
	
	q inadjret
}

/// 处理每一行数据,生成调整单子表明细
/// 
ClassMethod InputInAdjItm(rowStr As %String, msg As %String, inadj As %String) As %String
{
	n (rowStr,msg,inadj)

	s rowStr=$tr(rowStr,$c(13,10))
	s rowStr=$tr(rowStr," ","")
	s ret=0
	s del="^"
	s npid=..NewPid()
	
  	///插入子表信息
  	s LocId=""
	s LocDesc=$p(rowStr,del,1)  //科室名称
	i LocDesc="" s ret="科室名称为空"
	q:ret'=0 ret
	s LocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),0))
	i +LocId>0 d
	.s ret=0
	e  d
	.s ret="此科室在系统中不存在"
	.s msg="此科室在系统中不存在"_LocDesc
	q:ret'=0 ret
  	s hosp=$p(^CTLOC(LocId),"^",22)
  	s incicode=$p(rowStr,del,2)  //药品代码
	s IncId=""
	s IncId=##class(PHA.IN.COM.Method).GetInciByCode(incicode,hosp)
	i +IncId=0 d
	.s ret="不存在该药品"_incicode
	.s msg="不存在该药品"_incicode
	q:ret'=0 ret
  	
  	s incidesc=$p(rowStr,del,3)  //药品名称
  	s buom=$p(^INCI(IncId,1),"^",10)	//基本单位
  	s adjqty=$p(rowStr,del,5)  //调整数量
  	s pnflag=""	//正负库存标记
  	i adjqty<0 d
  	.s pnflag="-"
  	.s adjqty=-adjqty
  	s adjuomDesc=$p(rowStr,del,4)  //调整单位
  	s adjuom=""
  	i adjuomDesc'="" d
  	. &SQL(SELECT ctuom_rowid into :adjuom FROM CT_UOM WHERE CTUOM_Desc=:adjuomDesc)
  	s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(adjuom,buom)
  	s badjqty=adjqty*fac 	//基本单位对应的调整数量
  	s enoughflag=..GetInclbQty(IncId,badjqty,LocId,npid,pnflag)
  	i enoughflag'=1 d
  	.s ret="该药品现在库存不足调整"_incidesc
  	.s msg="该药品现在库存不足调整"_incidesc
  	q:ret'=0 ret
  	s insti="",rp="",sp="",rpAmt="",spAmt=""
  	s inclb="0"
  	f  s inclb=$o(^TMP("DHCST","web.DHCST.Tools.InputInAdj","GetInclbQtyFin",npid,inclb)) q:inclb=""  d
  	.s logqty=pnflag_$p(^TMP("DHCST","web.DHCST.Tools.InputInAdj","GetInclbQtyFin",npid,inclb),"^",1)	//该批次可以调整的数量(基本单位对应)
  	.s adjuomqty=+$fn((logqty/fac),"",2)	//调整单位对应数量
  	.s uom=buom		//调整单位默认为基本单位
  	.i adjuomqty=$p(adjuomqty,".",1) d
  	..s logqty=adjuomqty
  	..s uom=adjuom
  	.s ItmData=inclb_"^"_logqty_"^"_uom_"^"_rp_"^"_sp_"^"_rpAmt_"^"_spAmt_"^"_insti
	.s ret=##class(web.DHCST.DHCINAdjItm).Update("",inadj,ItmData)
	.i ret'=0 d
	..s msg="保存调整明细失败"_incidesc
	.
	
	k ^TMP("DHCST","web.DHCST.Tools.InputInAdj","GetInclbQtyFin",npid)
	
	q ret
}

/// 根据 BS发药取批次库存ID 程序改编
/// 临时global定义规则
/// w ##class(web.DHCST.Tools.InputInAdj).GetInclbQty(39,500,273,1)
ClassMethod GetInclbQty(inc As %Library.String = "", newqty As %Library.String = "", ctloc As %Library.String = "", pid, pnflag)
{
    s clb="0",val=0
    s cil=""
    q:'$d(^INCI("IL_LOC",ctloc,inc)) 0
    k ^TMP("DHCST","web.DHCST.Tools.InputInAdj","GetInclbQty",pid)
    s stkflag=0
    s cil=$o(^INCI("IL_LOC",ctloc,inc,""))
    f  s clb=$o(^INCI(inc,"IL",cil,"LB",clb)) q:(clb="")!(newqty=0)!(clb="0")  d
    .s incqty=0,inclb=""
    .s inclb=inc_"||"_cil_"||"_clb
    .s incibrowid=""
    .s incibrowid=$P(^INCI(inc,"IL",cil,"LB",clb),"^",1)
    .s cib=""
    .s cib=$p(incibrowid,"||",2)
    .s xqdate="",xqcyday=0
    .s xqdate=+$p(^INCI(inc,"IB",cib),"^",2)
    .q:(xqdate'=0)&&(xqdate<+$h) //yunhaibao,过滤效期 
    .q:'$d(^DHCINCLB(0,"LB",inclb))
	.s dhcinclb=$o(^DHCINCLB(0,"LB",inclb,""),-1)
	.s inclbactive=$p($g(^DHCINCLB(dhcinclb)),"^",2)
	.q:inclbactive'="Y" //yunhaibao20151231,过滤不可用
    .i (xqdate=0)!(xqdate="")  d
    ..s xqdate=+$h+500
    .i xqdate=+$h s xqcyday=1
    .e  s xqcyday=xqdate-(+$h)
    .s incqty=##CLASS(web.DHCSTSTKQTY).GetCurQtyINCLB(inclb)
    .q:incqty'>0
    .s ^TMP("DHCST","web.DHCST.Tools.InputInAdj","GetInclbQty",pid,xqcyday,inclb)=incqty
    . 
    s currxq=""
    f  s currxq=$o(^TMP("DHCST","web.DHCST.Tools.InputInAdj","GetInclbQty",pid,currxq)) q:(currxq="")!(newqty=0)  d
    .s xqclb=""
    .f  s xqclb=$o(^TMP("DHCST","web.DHCST.Tools.InputInAdj","GetInclbQty",pid,currxq,xqclb)) q:(xqclb="")!(newqty=0)  d
    ..s xqclbqty=0
    ..s xqclbqty=$g(^TMP("DHCST","web.DHCST.Tools.InputInAdj","GetInclbQty",pid,currxq,xqclb))
    ..i (xqclbqty'<newqty)||(pnflag="")  d
    ...s $p(^TMP("DHCST","web.DHCST.Tools.InputInAdj","GetInclbQtyFin",pid,xqclb),"^",1)=newqty
	...s newqty=0  
	...s stkflag=1  
	..e  d
	...s $p(^TMP("DHCST","web.DHCST.Tools.InputInAdj","GetInclbQtyFin",pid,xqclb),"^",1)=xqclbqty                                         
	...s newqty=newqty-xqclbqty
	.
	
	k ^TMP("DHCST","web.DHCST.Tools.InputInAdj","GetInclbQty",pid)
    q stkflag
}

/// w ##class(web.DHCST.Tools.InputInAdj).NewPid()
ClassMethod NewPid()
{
	
	q $I(^DHCSTPID("InputInAdj"))
}

/// w ##class(web.DHCST.Tools.InputInAdj).GetReason("报损",2)
ClassMethod GetReason(desc, hosp)
{
	s ret=""
	s sqlStr="SELECT ADJ_RowId AS rowID FROM INC_ReasonForAdjustment WHERE ADJ_StkType='G'"_
			 " AND ADJ_Desc='"_desc_"'" 
	q ##class(PHA.COM.Method).IsSQLDataExist(sqlStr,"INC_ReasonForAdjustment",hosp)
}

}

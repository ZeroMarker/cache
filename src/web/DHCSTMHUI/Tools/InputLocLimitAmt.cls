Import sqluser

/// 科室限额批量导入
/// 20190102 lihui
/// w ##class(web.DHCSTMHUI.Tools.InputLocLimitAmt).StartInput("D:\wzkf01.txt")
Class web.DHCSTMHUI.Tools.InputLocLimitAmt Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

ClassMethod StartInput(fileName As %String, sub As %String = "") As %String
{
	n (fileName,sub)
  
  i sub="" s sub="LocLimitAmt"
  s p=$zn
  s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s (successCnt,failcnt)=0
  s Ingdrec=""
  
  s ret=0,failstr="",mainfailstr=""
  s i=2
  f  s i=$O(^zTSA(p,sub,i)) q:(i="")  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .w rowStr,!
  .s cnt=cnt+1
  .tstart
  .s msg=""
  .s LrlRowid=..CreateLocLimitAmt(rowStr,.msg)
  .i LrlRowid<0 d
  ..w msg,!
  ..tro
  ..s failcnt=failcnt+1
  ..s mainfailstr=mainfailstr_";"_msg
  .q:LrlRowid<0
  .s ret=..InputLocLimitAmtItm(rowStr,.msg,LrlRowid)
  .i ret=0 d
  ..tcommit
  ..s successCnt=successCnt+1
  .e  d
  ..tro
  ..d ..SetErr(i,msg)
  ..w msg,!
  ..s failcnt=failcnt+1
  ..s failstr=failstr_";"_msg
  .w "",!
  w "失败信息:"_failstr,!
  w "",!
  w "主失败信息:"_mainfailstr,!
  k ^zTSA(p,sub)  //删除临时global
  q cnt_"^"_successCnt_"^"_failcnt
}

/// 生成主表
ClassMethod CreateLocLimitAmt(rowStr As %String, msg As %String) As %String
{
  n (rowStr,msg)
  
  s colNoStr=""
  s rowStr=$tr(rowStr,$c(13,10))
  s rowStr=$tr(rowStr," ","")
  
  s ret=0
  s del="^"
  
  ///生成主表
  s LocId=""
  s LocDesc=$p(rowStr,del,..Col("LocDesc") ) ;科室名称
  i LocDesc="" s ret=-1 s msg="科室名称为空"
  q:ret<0 ret
  
  s LocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),0))
  i +LocId>0 d
  .s ret=0
  e  d
  .s ret=-2  
  .s msg=LocDesc_"此科室在系统中不存在"
  q:ret<0 ret
  s LrlRowid=""
  &sql(SELECT LRL_RowId into:LrlRowid FROM DHC_LocReqLimit WHERE LRL_CTLoc_DR=:LocId)
  i LrlRowid>0 q LrlRowid
  
  s LocLimitamt=$p(rowStr,del,..Col("LocLimitamt") ) ;科室限制金额
  i LocLimitamt="" s ret=-3 s msg=LocDesc_"科室限制金额为空"
  q:ret<0 ret
  
  s scg=$p(rowStr,del,..Col("scg") ) ; 类组
  s incsc=$p(rowStr,del,..Col("incsc") ) ; 库存分类
  s incicode=$p(rowStr,del,..Col("incicode") ) ; 物资代码
  s SumTypeId=""
  i scg'="" d
  .s SumTypeId=0
  e  i incsc'="" d
  .s SumTypeId=1
  e  i incicode'="" d
  .s SumTypeId=2
  i SumTypeId="" s ret=-4  s msg=LocDesc_"类组/库存分类/物资代码都为空,必须选择其一"
  s StartDate=+$h
  s EndDate=StartDate+360
  &sql(INSERT INTO DHC_LocReqLimit (LRL_CTLoc_DR, LRL_StartDate, LRL_EndDate, LRL_ReqAmt, LRL_LimitType) 
  		VALUES (:LocId,:StartDate,:EndDate,:LocLimitamt,:SumTypeId))
   i SQLCODE'=0  d
   .s ret=-4   
   .s msg=LocDesc_"主表插入失败"
   e  d
   .s LrlRowid=$g(%ROWID)
   q:ret<0 ret
   
   q LrlRowid
}

/// 处理一行数据
ClassMethod InputLocLimitAmtItm(rowStr As %String, msg As %String, LrlRowid As %String) As %String
{
  n (rowStr,msg,LrlRowid)

  s colNoStr=""
  s rowStr=$tr(rowStr,$c(13,10))
  s rowStr=$tr(rowStr," ","")
  q:LrlRowid<0 -1  ;主表id没取到
  s ret=0
  s del="^"
  s LocDesc=$p(rowStr,del,..Col("LocDesc") ) ;科室名称
  s scg=$p(rowStr,del,..Col("scg") ) ;类组
  s incsc=$p(rowStr,del,..Col("incsc") ) ;库存分类
  s incicode=$p(rowStr,del,..Col("incicode") ) ;物资代码
  s incidesc=$p(rowStr,del,..Col("incidesc") ) ;物资名称
  s alllimitqty=$p(rowStr,del,..Col("alllimitqty") )   ;总限制数量
  s limitqty=$p(rowStr,del,..Col("limitqty") )   ;单次限制数量
  s uom=$p(rowStr,del,..Col("uom") )   ;入库单位
  s limitamt=$p(rowStr,del,..Col("limitamt") )   ;限制金额
  s Lrlitmid=""
  // 类组
  i scg'=""
  	{
	  	s scgid=$o(^DHCSCG(0,"TYPE","M",scg,""))
	  	i scgid="" d
	  	.s ret=-2
	  	.s msg=LocDesc_"类组:"_scg_"系统不存在"
	  	q:ret<0 ret
	  	s IfNearestScg=##class(web.DHCSTMHUI.LocLimitAmt).IfNearestScg(scgid)
	  	i IfNearestScg="N" d
	  	.s ret=-2
	  	.s msg=LocDesc_"类组:"_scg_"非底层类组"
	  	q:ret<0 ret
	  	s configType=0
	  	s datastr=LrlRowid_"^^"_scgid_"^^^^"_configType
	  	s check=..CheckExistsConfig(datastr)
	  	i check'="" d
	  	.s ret=-3
	  	.s msg=LocDesc_"类组:"_scg_"已维护"
	  	q:ret<0 ret
	  	s Chl=1+$o(^DHCLRL(LrlRowid,"LRLI",""),-1)
	  	
	  	&sql(INSERT INTO DHC_LocItmLimitAmt (LRLI_ParRef, LRLI_ChildSub, LRLI_ReqAmt, LRLI_Scg_Dr, LRLI_LimitType) VALUES (:LrlRowid,:Chl,:limitamt,:scgid,:configType))
	  	i SQLCODE'=0  d
	  	.s ret=-4
	  	.s msg=LocDesc_"类组:"_scg_"插入子表失败"
	  	q:ret<0 ret
	  	s Lrlitmid=$p($g(%ROWID),$c(1))
	}
  q:ret<0 ret
  q:Lrlitmid'="" ret
  
  // 库存分类
  i incsc'=""
  	{
	  	s incscid=$o(^INC("SC",0,"Desc",$$ALPHAUP^SSUTIL4(incsc),0))
	  	i incscid="" d
	  	.s ret=-5
	  	.s msg=LocDesc_"库存分类:"_incsc_"系统不存在"
	  	q:ret<0 ret
	  	s configType=1
	  	s datastr=LrlRowid_"^^^"_incscid_"^^^"_configType
	  	s check=..CheckExistsConfig(datastr)
	  	i check'="" d
	  	.s ret=-6
	  	.s msg=LocDesc_"库存分类:"_incsc_"已维护"
	  	q:ret<0 ret
	  	s Chl=1+$o(^DHCLRL(LrlRowid,"LRLI",""),-1)
	  	&sql(INSERT INTO DHC_LocItmLimitAmt (LRLI_ParRef, LRLI_ChildSub, LRLI_ReqAmt, LRLI_Cat_Dr, LRLI_LimitType) VALUES (:LrlRowid,:Chl,:limitamt,:incscid,:configType))
	  	i SQLCODE'=0  d
	  	.s ret=-7
	  	.s msg=LocDesc_"库存分类:"_incsc_"插入子表失败"
	  	q:ret<0 ret
	  	s Lrlitmid=$p($g(%ROWID),$c(1))
	}
  q:ret<0 ret
  q:Lrlitmid'="" ret
  
  // 库存项
  i incicode'=""
  	{
		s IncId=""
		s IncId=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(incicode)_"Z",""))
		i IncId="" d
		.s ret=-8
		.s msg=LocDesc_"物资代码:"_incicode_"无效"
		q:ret<0 ret
		s configType=2
		s datastr=LrlRowid_"^^^^^"_IncId_"^"_configType
		s check=..CheckExistsConfig(datastr)
		i check'="" d
		.s ret=-9
		.s msg=LocDesc_"物资:"_incicode_"已维护"
		q:ret<0 ret

		s UomId=""
		&sql(select CTUOM_RowId into :UomId from ct_uom where CTUOM_Desc=:uom)
		i SQLCODE'=0 d
		.s ret=-10
		.s msg=LocDesc_"物资代码:"_incicode_"的单位系统不存在"
		q:ret<0 ret
		s BUomId=$p(^INCI(IncId,1),"^",10)
		s PUomId=$p(^INCI(IncId,3),"^",6)
		i UomId'=BUomId,UomId'=PUomId d
		.s ret=-11
		.s msg="不是"_LocDesc_"物资代码:"_incicode_"的单位"
		q:ret<0 ret
		s (tmpReqQty,tmpOnceReqQty)=0
		i UomId=BUomId d
		.s tmpReqQty=alllimitqty
		.s tmpOnceReqQty=limitqty
		e  d
		.s pfac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,UomId)
		.s tmpReqQty=alllimitqty*pfac
		.s tmpOnceReqQty=limitqty*pfac
		
		s Chl=1+$o(^DHCLRL(LrlRowid,"LRLI",""),-1)
		&sql(INSERT INTO DHC_LocItmLimitAmt (LRLI_ParRef, LRLI_ChildSub, LRLI_ReqAmt, LRLI_Inci_Dr, LRLI_LimitType,LRLI_OnceReqQty, LRLI_ReqQty, LRLI_CTUOM_DR) VALUES (:LrlRowid,:Chl,:limitamt,:IncId,:configType,:tmpOnceReqQty,:tmpReqQty,:BUomId))
		i SQLCODE'=0  d
		.s ret=-12
		.s msg=LocDesc_"物资代码:"_incicode_"插入子表失败"
		q:ret<0 ret
		s Lrlitmid=$p($g(%ROWID),$c(1))
	}
  q:ret<0 ret
  q:Lrlitmid'="" ret
  
  
  q ret
}

/// 判断记录是否重复
/// 20181227 lihui
/// return: 空 不重复;其他重复
ClassMethod CheckExistsConfig(datas)
{
	n (datas)
	s LRLrowid=$p(datas,"^",1)  ;
	s scg=$p(datas,"^",3)
	s CatId=$p(datas,"^",4)
	s reqamt=$p(datas,"^",5)
	s inci=$p(datas,"^",6)
	s configType=$p(datas,"^",7)
	
	s ret=""
	i configType=0 d
	.s chl=$o(^DHCLRL(0,"Scg",scg,LRLrowid,0))
	.i chl'="" s ret=LRLrowid_"||"_chl
	i configType=1 d
	.s chl=$o(^DHCLRL(0,"Cat",CatId,LRLrowid,0))
	.i chl'="" s ret=LRLrowid_"||"_chl
	i configType=2 d
	.s chl=$o(^DHCLRL(0,"Inci",inci,LRLrowid,0))
	.i chl'="" s ret=LRLrowid_"||"_chl
	q ret
}

/// 取出列在串中的位置
ClassMethod Col(colname As %String) As %String
{
	n (colname)
   //"科室名称^科室限制金额^类组^库存分类^限制金额^物资代码^物资名称^规格^单位^单次限制数量^总限制数量"
   s cols="LocDesc^LocLimitamt^scg^incsc^limitamt^incicode^incidesc^spec^uom^limitqty^alllimitqty"
	s cnt=$l(cols,"^")
	s ret=0
	f i=1:1:cnt q:ret>0  d
	.i $p(cols,"^",i)=colname s ret=i q
	q ret
}

ClassMethod ErrId() As %String
{
	s i=$o(^TMP("input_stockrec",$j,""),-1)+1	
	q i
}

ClassMethod SetErr(row As %String, errinfo As %String)
{
	n (row,errinfo)
	s ^TMP("input_stockrec",$j,..ErrId())="第"_row_"行错误:"_errinfo
}

}

Import sqluser

/// 库存请求单模板导入
/// Author:zhangxiao
/// Date:2016-6-23
/// w ##class(web.DHCSTMHUI.Tools.ReqTemplateInput).StartInput("文件名","")
/// w ##class(web.DHCSTMHUI.Tools.ReqTemplateInput).StartInput("D:\code.txt","")
Class web.DHCSTMHUI.Tools.ReqTemplateInput Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 执行导入的总入口
/// fileName: .Txt文件(Tab分隔符
ClassMethod StartInput(fileName As %String, sub As %String = "") As %String
{
	n (fileName,sub)
  
  i sub="" s sub="ReqTemplate"
  s p=$zn
  s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  s req=""
  
  ;
  s i=1
  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
  .;b
  .s rowStr=$G(^zTSA(p,sub,i))
  .w rowStr,!
  .;q
  .s cnt=cnt+1
  .;w cnt,!
  .tstart
  .s msg=""
  .i req="" d
  ..s req=..CreateRequest(rowStr,.msg)
  .w req,!
  .s ret1=..InputReqItm(rowStr,.msg,req)
  .w ret1,!
  .w !
  .i ret1=0 d
  ..tcommit
  ..s successCnt=successCnt+1
  .e  d
  .. tro
  .. d ..SetErr(i,msg)
  ..
  s ret=##class(web.DHCSTMHUI.INRequest).SetComp(req)
  k ^zTSA(p,sub)  //删除临时global
  q cnt_"^"_successCnt
}

/// 处理一行数据
ClassMethod InputReqItm(rowStr As %String, msg As %String, req As %String) As %String
{
  n (rowStr,msg,req)
  
  s colNoStr=""
  s rowStr=$tr(rowStr,$c(13,10))
  s rowStr=$tr(rowStr," ","")
  q:req<0 -9  ;主表id没取到
  s ret=0
  s del="^"	
  
   ///插入子表信息
  s Code=$p(rowStr,del,..Col("Code") ) ;物资代码
  s Desc=$p(rowStr,del,..Col("Desc") ) ;物资名称
  s Qty=$p(rowStr,del,..Col("Qty") )   ;数量
  s Uom=$p(rowStr,del,..Col("Uom") )   ;单位
  
  //库存项id
  s inci=""
  s inci=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(Code)_"Z",""))
  i inci="" d
  .s ret=-10 ;此代码无效
  q:ret<0 ret
  
  
  s UomId=""
  &sql(select CTUOM_RowId into :UomId from ct_uom where CTUOM_Desc=:Uom)
  i SQLCODE'=0 d
  .s ret=-11  ;单位不存在
  .s msg="单位不存在"

  q:ret<0 ret
  
  s BUomId=$p(^INCI(inci,1),"^",10)
  s PUomId=$p(^INCI(inci,3),"^",6)
  i UomId'=BUomId,UomId'=PUomId  s ret=-12
  q:ret<0 ret
  
  //类组
  s scg=""
  s scgdesc=$p(rowStr,del,..Col("scgdesc") )
  i scgdesc="" s ret=-13 ;类组名称为空
  q:ret<0 ret
  &sql(select SCG_Rowid into :scg from DHC_StkCatGroup where SCG_Desc=:scgdesc)
  i +scg>0 d
  .s ret=0
  e  d
  .s ret=-14  ;此类组名称在系统中不存在
  q:ret<0 ret 
  //插入子表信息
  s reqdate=$p(^INRQ(req),"^",2)
  s ch=$o(^INRQ(req,"RQI",""),-1)+1
  &sql(insert into in_reqitm (inrqi_inrq_parref,inrqi_childsub,inrqi_inci_dr,inrqi_reqqty,inrqi_ctuom_dr,inrqi_date)
    values(:req,:ch,:inci,:Qty,:UomId,:reqdate) )
  i SQLCODE'=0  s ret=-15
  q:ret<0 ret
  s reqitmid=req_"||"_ch
  s colremark="",SpecDesc=""
  &sql(insert into dhc_inreqitm (INRQI_INRQI_DR,INRQI_Remark,INRQI_SpecList) values (:reqitmid,:colremark,:SpecDesc))
  i SQLCODE'=0 s ret=-16
  q:ret<0 ret
   
   q ret
}

/// 生成库存请求主表
ClassMethod CreateRequest(rowStr As %String, msg As %String) As %String
{
  n (rowStr,msg)
  
  s colNoStr=""
  s rowStr=$tr(rowStr,$c(13,10))
  s rowStr=$tr(rowStr," ","")
  
  s ret=0
  s del="^"
  
  ///生成库存请求主表
  //供给科室
  s frLoc=""
  s frLocDesc=$p(rowStr,del,..Col("frLoc") ) ;供给科室
  i frLocDesc="" s ret=-1 ;科室名称为空
  q:ret<0 ret
  
  s frLoc=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(frLocDesc),0))
  i +frLoc>0 d
  .s ret=0
  e  d
  .s ret=-2  ;此科室在系统中不存在
  q:ret<0 ret
  
  //请求科室
  s toLoc=""
  s toLocDesc=$p(rowStr,del,..Col("toLoc") ) ;请求科室
  i toLocDesc="" s ret=-1 ;科室名称为空
  q:ret<0 ret
  
  s toLoc=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(toLocDesc),0))
  i +toLoc>0 d
  .s ret=0
  e  d
  .s ret=-2  ;此科室在系统中不存在
  q:ret<0 ret
  
  //类组
  s scg=""
  s scgdesc=$p(rowStr,del,..Col("scgdesc") )
  i scgdesc="" s ret=-3 ;类组名称为空
  q:ret<0 ret
  &sql(select SCG_Rowid into :scg from DHC_StkCatGroup where SCG_Desc=:scgdesc)
  i +scg>0 d
  .s ret=0
  e  d
  .s ret=-4  ;此类组名称在系统中不存在
  q:ret<0 ret 
  
  //模板名称(备注)
  s Template=""
  s Template=$p(rowStr,del,..Col("Template") )
  q:Template="" -5  ;没有模板名称
  s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
  s remark=$LFS(Template,memoDelim) //将备注串( $c(3)分隔 )转换为list
 
  //制单人
  s UserId=""
  s UserName="demo"
  &sql(select ssusr_rowid into :UserID from ss_user where ssusr_initials=:UserName)
  s UserId=$g(UserID)
  i +UserId=0 d
  .s ret=-6  ;没有取到userid
  q:ret<0 ret
  
  //临时请求单的时候
  s status="O"
  //申领计划
  //s status="C"
  
  //模板标志
  s tempFlag="Y"
  // 申领计划标志
  s reqType=status
  s RelateReq=""
  
  
  
  s dd=+$h
  s tt=$p($h,",",2)
  //插入主表信息
  s AppName=##class(web.DHCSTMHUI.INRequest).%GetParameter("AppName")
  s reqNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,scg,toLoc)  //取单号
  q:reqNo="" -7 //生成单号失败
  &sql(insert into IN_Request(inrq_recLoc_dr,inrq_reqloc_dr,inrq_date,inrq_time,inrq_ssusr_dr,inrq_status,INRQ_Remarks)
  values (:toLoc,:frLoc,:dd,:tt,:UserId,:status,:remark) )
  i SQLCODE'=0  s err=-8 q -8
  s req=%ROWID
  //插入主表附加表
  &sql(insert into DHC_INRequest(INRQ_Type,INRQ_INRQ_DR,INRQ_SCG_DR,INRQ_Template,INRQ_RelateReq_DR)values(:reqType,:req,:scg,:tempFlag,:RelateReq) )
  i SQLCODE'=0  s err=-8 q -8
  &sql(update IN_Request set inrq_no=:reqNo where %ID=:req)
  i SQLCODE'=0  s err=-8 q -8

  ;s ret=##class(web.DHCSTMHUI.INRequest).SetComp(req)
  ;q:ret'=0 -9  //请求单完成失败
   
  q req
}

/// 取出列在串中的位置
ClassMethod Col(colname As %String) As %String
{
	n (colname)
   //此处为导入数据的排列顺序
   //"供给科室^请求科室^类组^模板名称^代码^名称^数量^单位"
   s cols="frLoc^toLoc^scgdesc^Template^Code^Desc^Qty^Uom"
	s cnt=$l(cols,"^")
	s ret=0
	f i=1:1:cnt q:ret>0  d
	.i $p(cols,"^",i)=colname s ret=i q
	q ret
}

ClassMethod ErrId() As %String
{
	s i=$o(^TMP("input_ReqTemplate",$j,""),-1)+1	
	q i
}

ClassMethod SetErr(row As %String, errinfo As %String)
{
	n (row,errinfo)
	s ^TMP("input_ReqTemplate",$j,..ErrId())="第"_row_"行错误:"_errinfo
}

}

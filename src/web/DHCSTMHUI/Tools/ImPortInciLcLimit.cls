Import sqluser

/// 科室库存上下限信息导入
/// Author: lihui
/// Date: 20171112
/// w ##class(web.DHCSTMHUI.Tools.ImPortInciLcLimit).StartInput("D:\stoclimit.txt")
Class web.DHCSTMHUI.Tools.ImPortInciLcLimit Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 执行导入的总入口
/// fileName: .Txt文件(Tab分隔符
ClassMethod StartInput(fileName As %String) As %String
{
  n (fileName)
  s sub="LocStockLimit"
  s p=$zn
  s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  
  s i=1
  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .w rowStr,!
  .s cnt=cnt+1
  .tstart
  .s msg=""
  .s ret1=..InputIncItm(rowStr,.msg)
  .w ret1,!
  .w !
  .i ret1=0 d
  ..tcommit
  ..s successCnt=successCnt+1
  .e  d
  .. tro
  ..w msg,!
  ..d ..SetErrLimit(i,msg)
  ..
  k ^zTSA(p,sub)  //删除临时global
  q cnt_"^"_successCnt
}

ClassMethod ErrIdLimit() As %String
{
 s NowDate=$zd(+$h,3)
 s i=$o(^TMP("input_incilclimit",NowDate,""),-1)+1
 q i
}

ClassMethod SetErrLimit(row As %String, errinfo As %String)
{
	n (row,errinfo)
	s NowDate=$zd(+$h,3),NowTime=..TL2H($p($h,",",2))
	s ^TMP("input_incilclimit",NowDate,..ErrIdLimit(),NowTime)="第"_row_"行错误:"_errinfo
}

/// 处理一行数据
ClassMethod InputIncItm(rowStr As %String, msg As %String) As %String
{
  n (rowStr,msg)

  s colNoStr=""
  s rowStr=$tr(rowStr,$c(13,10))
  s rowStr=$tr(rowStr," ","")
  s ret=0
  s del="^"
  
  ///插入子表信息
  s LocDesc=$p(rowStr,del,..Col("loc") ) ;科室
  i LocDesc="" s ret=-1 s msg="科室名称为空"
  q:ret<0 ret
  
  s Code=$p(rowStr,del,..Col("code") ) ;物资代码
  s LocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),0))
  i +LocId>0 d
  .s ret=0
  e  d
  .s ret=-2  s msg=LocDesc_"此科室在系统中不存在,物资代码为"_Code
  q:ret<0 ret
  
  s IncId=""
  s IncId=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(Code)_"Z",""))
  i IncId="" d
  .s ret=-3 s msg=Code_"代码无效"
  q:ret<0 ret
  s chl=$o(^INCI("IL_LOC",LocId,IncId,""))
  i chl="" s ret=-4  s msg=LocDesc_"没有入库过"_Code  q ret
  s incil=IncId_"||"_chl
  
  s maxqty=$p(rowStr,del,..Col("maxqty") )   ;库存上限
  s maxqty=+maxqty
  s minqty=$p(rowStr,del,..Col("minqty") )   ;库存下限
  s minqty=+minqty
  i (maxqty<minqty) s ret=-5 s msg=Code_"库存上限小于库存下限"  q ret
  s levelqty=$p(rowStr,del,..Col("levelqty") )   ;标准库存
   
  &sql(UPDATE INC_ItmLoc SET INCIL_MaxQty=:maxqty, INCIL_MinQty=:minqty, INCIL_RepQty=:levelqty  WHERE INCIL_RowId=:incil)
   i SQLCODE'=0  d
   .s ret=-6  s msg=Code_"更新失败"
   q:ret<0 ret
    
  q ret
}

/// 取出列在串中的位置
ClassMethod Col(colname As %String) As %String
{
    n (colname)
    s cols=..cols()
    s cnt=$l(cols,"^")
    s ret=0
    f i=1:1:cnt q:ret>0  d
    .i $p(cols,"^",i)=colname s ret=i q
    q ret
}

/// 缺省的文件标题名称字符串("^"分隔)
ClassMethod cols() As %String
{
  s cols="loc^code^desc^puom^maxqty^minqty^levelqty"
  q cols
}

}

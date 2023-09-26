Import sqluser

/// 导入物资请领供应仓库配置DHC_StockTransferLocConf
/// Author:zhangxiao
/// Date:2018-1-25
/// w ##class(web.DHCSTMHUI.Tools.StockTransferLocInput).StartInput("D:\aa.txt","")
Class web.DHCSTMHUI.Tools.StockTransferLocInput Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 执行导入的总入口
/// fileName: .Txt文件(Tab分隔符
ClassMethod StartInput(fileName As %String, sub As %String) As %String
{
  n (fileName,sub)
  
  i sub="" s sub="StockTransferLoc"
  s p=$zn
  s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
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
  .s ret1=..InputIncItm(rowStr,.msg)
  .w !,ret1
  .w !
  .i ret1=0 d
  ..tcommit
  ..s successCnt=successCnt+1
  .e  d
  .. tro
  .. d ..SetErr(i,msg)
  ..
  k ^zTSA(p,sub)  //删除临时global
  q cnt_"^"_successCnt
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
  s ToLocDesc=$p(rowStr,del,..Col("ToLocDesc") )       ;请求科室
  s FrLocDesc=$p(rowStr,del,..Col("FrLocDesc") )       ;供应仓库
  
  q:(ToLocDesc="") -1  ;科室为空
  q:(FrLocDesc="") -2  ;科室为空
  
  s ToLocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(ToLocDesc),0))
  i +ToLocId>0 d
  .s ret=0
  e  d
  .s ret=-3  ;此科室在系统中不存在
  q:ret<0 ret
  
  s FrLocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(FrLocDesc),0))
  i +FrLocId>0 d
  .s ret=0
  e  d
  .s ret=-4  ;此科室在系统中不存在
  q:ret<0 ret
  
  s Stlocid=""
  &sql(select STLOC_RowId into:Stlocid from DHC_StockTransferLocConf where STLOC_CTLOC_DR=:ToLocId and STLOC_FrLoc_DR=:FrLocId)
  i +Stlocid>0 d
  .s ret=-5    ;存在配置信息
  q:ret<0 ret
  
 
  &sql(insert into DHC_StockTransferLocConf(STLOC_CTLOC_DR,STLOC_FrLoc_DR) values(:ToLocId,:FrLocId))
  i SQLCODE'=0  d
  .s ret=-6
  q:ret<0 ret
   
  
  q ret
}

/// 取出列在串中的位置
ClassMethod Col(colname As %String) As %String
{
	n (colname)
   //此处为导入数据的排列顺序
   //"请求科室^供应商仓库"
   s cols="ToLocDesc^FrLocDesc"
	s cnt=$l(cols,"^")
	s ret=0
	f i=1:1:cnt q:ret>0  d
	.i $p(cols,"^",i)=colname s ret=i q
	q ret
}

ClassMethod ErrId() As %String
{
	
 s i=$o(^TMP("input_StockTransferLoc",$j,""),-1)+1	
 q i
}

ClassMethod SetErr(row As %String, errinfo As %String)
{
	n (row,errinfo)
  s ^TMP("input_StockTransferLoc",$j,..ErrId())="第"_row_"行错误:"_errinfo
}

}

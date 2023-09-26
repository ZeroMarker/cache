Import sqluser

/// HIS系统与物资库科室对照信息导入
/// Author:zhangxiao
/// Date:2013-12-30
/// w ##class(web.DHCSTMHUI.Tools.LocCompareInput).StartInput("文件名","")
/// w ##class(web.DHCSTMHUI.Tools.LocCompareInput).StartInput("D:\loccompare.txt","")
Class web.DHCSTMHUI.Tools.LocCompareInput Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 执行导入的总入口
/// fileName: .Txt文件(Tab分隔符
ClassMethod StartInput(fileName As %String, sub As %String) As %String
{
  n (fileName,sub)
  
  i sub="" s sub="LocCompare"
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
  s Desc=$p(rowStr,del,..Col("Desc") )        ;科室名称
  s HISCode=$p(rowStr,del,..Col("HISCode") )   ;HIS科室代码
  s HISDesc=$p(rowStr,del,..Col("HISDesc") )   ;HIS科室名称
  i Desc="" d
  .s ret=-1 ;没有科室名称
  q:ret<0 ret
  i HISCode="" d
  .s ret=-2 ;没有HIS科室代码
  q:ret<0 ret
  i HISDesc="" d
  .s ret=-3 ;没有HIS科室名称
  q:ret<0 ret
  s LocId=""
  s LocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))
  i LocId="" d
  .s ret=-4   ;科室名称无效
  q:ret<0 ret
  s Code=""
  s Code=$p(^CTLOC(LocId),"^",1)
  i Code="" d
  .s ret=-5  ;科室代码未取到
  q:ret<0 ret
  s RowId=""
  s RowId=$o(^DHCHVMLL(0,"HISLOCCODE",HISCode,0))
  i RowId'="" d
  .s ret=-6  ;此科室已经维护
  q:ret<0 ret
  &sql(insert into DHC_HVMat_LocCheckList (LC_HISLocCode,LC_HISLocDesc,LC_CTLocCode,LC_CTLocDesc,LC_CTLOC_DR) values (:HISCode,:HISDesc,:Code,:Desc,:LocId))
  i SQLCODE'=0  d
  .s ret=-7  ;插入失败
  q:ret<0 ret
  
  
  q ret
}

/// 取出列在串中的位置
ClassMethod Col(colname As %String) As %String
{
	n (colname)
   //此处为导入数据的排列顺序
   //"科室名称^HIS科室代码^HIS科室名称"
   s cols="Desc^HISCode^HISDesc"
	s cnt=$l(cols,"^")
	s ret=0
	f i=1:1:cnt q:ret>0  d
	.i $p(cols,"^",i)=colname s ret=i q
	q ret
}

ClassMethod ErrId() As %String
{
	
 s i=$o(^TMP("input_loccompare",$j,""),-1)+1	
 q i
}

ClassMethod SetErr(row As %String, errinfo As %String)
{
	n (row,errinfo)
  s ^TMP("input_loccompare",$j,..ErrId())="第"_row_"行错误:"_errinfo
}

}

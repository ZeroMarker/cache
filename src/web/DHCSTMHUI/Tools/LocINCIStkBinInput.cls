Import sqluser

/// 根据科室 和物资代码 和货位名称在科室库存表(INC_ItmLoc)里插入关联关系
///   Author:zhangxiao
///   Date:2015-8-3
/// w ##class(web.DHCSTMHUI.Tools.LocINCIStkBinInput).StartInput("文件名","")
/// w ##class(web.DHCSTMHUI.Tools.LocINCIStkBinInput).StartInput("D:\stkbin.txt","")
Class web.DHCSTMHUI.Tools.LocINCIStkBinInput Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 执行导入的总入口
/// fileName: .Txt文件(Tab分隔符
ClassMethod StartInput(fileName As %String, sub As %String) As %String
{
  n (fileName,sub)
  
  i sub="" s sub="LocStkBin"
  s p=$zn
  s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  ;
  s i=1 ;去除标题，从1开始
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
  s INCCode=$p(rowStr,del,..Col("INCCode") ) ;库存项代码
  q:INCCode="" -4  ;库存项代码为空
  s inci=""
  ;s inci=$o(^INCI(0,"Code",$$ALPHAUP(INCCode),0))
  &sql(select INCI_RowId into :inci from inc_itm where INCI_Code=:INCCode)
  q:inci="" -1   ;库存项代码错误
  s LocDesc=$p(rowStr,del,..Col("LocDesc") ) ;科室名称
  i LocDesc="" s ret=-2 ;科室名称为空
  q:ret<0 ret
  s LocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),0)) ;科室id
  s Desc=$p(rowStr,del,..Col("Desc") ) ;货位名称
  s id=$o(^INC("SB",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0)) ;货位码id
  
  s stkcode=""
  i id'="" d
  .s stkcode=$p(^INC("SB",id),"^",1)
  .s codetmp=+LocId_"P" 
  .i stkcode'[codetmp d
  ..s ret=-6
  q:ret<0 ret  ;货位码在别的科室已经维护 
  
  i id="" d
  .s id=..InPutStkBin(LocId,Desc)
  q:id="" -3  
  q:+id<0 -3  ;货位码插入失败
  &sql(update INC_ItmLoc set INCIL_INCSB_DR=:id where INCIL_INCI_ParRef=:inci and INCIL_CTLOC_DR=:LocId)
  i SQLCODE'=0  d
  .s ret=-5
  
  
  q ret
}

/// 取出列在串中的位置
ClassMethod InPutStkBin(LocId As %String, Desc As %String) As %String
{
  n (LocId,Desc)
  i ##class(web.DHCSTMHUI.Common.AppCommon).Lock("User.INCStkBin")<0 s ret=-99
  i +LocId>0 d
  .s Code=..GetNextCode(LocId)  //自动生成代码(代码包含“科室”信息)
  e  d
  .s ret=-2  ;不存在此科室
  q:ret<0 ret
   &sql(insert into inc_stkbin (incsb_code,incsb_desc) values (:Code,:Desc))
  i SQLCODE'=0  d
  .s ret=-3 
  q:ret<0 ret
  d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("User.INCStkBin") 
  q $p($g(%ROWID),$c(1))
}

/// 取出列在串中的位置
ClassMethod Col(colname As %String) As %String
{
	n (colname)
   //此处为导入数据的排列顺序
   //"项代码^库存项名称^库存科室名称^货位名称"
   s cols="INCCode^INCDesc^LocDesc^Desc"
	s cnt=$l(cols,"^")
	s ret=0
	f i=1:1:cnt q:ret>0  d
	.i $p(cols,"^",i)=colname s ret=i q
	q ret
}

/// 自动生成某科室新的货位代码
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///   Loc  - 科室rowid
/// Return:  
///   货位代码字符串 
ClassMethod GetNextCode(Loc As %String) As %String
{
 n (Loc)
 s ch=+Loc_"P"
 s max=""
 &sql(select  max(to_number($PIECE(incsb_code,:ch,2))) into :max from inc_stkbin  where incsb_code %STARTSWITH :ch)
 s max=max+1
 q ch_max
}

ClassMethod ErrId() As %String
{
	
 s i=$o(^TMP("input_locitmstkbin",$j,""),-1)+1	
 q i
}

ClassMethod SetErr(row As %String, errinfo As %String)
{
	n (row,errinfo)
  s ^TMP("input_locitmstkbin",$j,..ErrId())="第"_row_"行错误:"_errinfo
}

}

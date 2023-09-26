Import sqluser

/// w ##class(web.DHCSTMHUI.Tools.InputYGCGDataInfo).StartInputSC("文件名","")
/// w ##class(web.DHCSTMHUI.Tools.InputYGCGDataInfo).StartInputSC("F:\YGCG.txt","")
Class web.DHCSTMHUI.Tools.InputYGCGDataInfo Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 四川阳光采购 执行导入的总入口
/// fileName: .Txt文件(Tab分隔符
ClassMethod StartInputSC(fileName As %String, sub As %String) As %String
{
  n (fileName,sub)
  s version="HISUI"  ; EXT 类型
  i sub="" s sub="MSunPurPlansc"
  s p=$zn
  if version="HISUI" d
  .s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(fileName,sub,p)
  if version="EXT" d
  .s ret=##class(web.DHCSTM.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  if version="HISUI"{
	  s i=1
	  f  s i=$O(^TMPDHCSTMINPUT(p,sub,i)) q:i=""  d
	  .s rowStr=$G(^TMPDHCSTMINPUT(p,sub,i))
	  .w rowStr,!
	  .s cnt=cnt+1
	  .tstart
	  .s msg=""
	  .s ret1=..InputComInfosc(rowStr,.msg)
	  .i ret1=0 d
	  ..tcommit
	  ..s successCnt=successCnt+1
	  .e  d
	  .. tro
	  .. d ..SetErrsc(i,msg)
	  ..
	  k ^TMPDHCSTMINPUT(p,sub)  //删除临时global
  }
  else{
	s i=1
	  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
	  .s rowStr=$G(^zTSA(p,sub,i))
	  .w rowStr,!
	  .s cnt=cnt+1
	  .tstart
	  .s msg=""
	  .s ret1=..InputComInfosc(rowStr,.msg)
	  .i ret1=0 d
	  ..tcommit
	  ..s successCnt=successCnt+1
	  .e  d
	  .. tro
	  .. d ..SetErrsc(i,msg)
	  ..
	  k ^zTSA(p,sub)  //删除临时global 
	 
	 }
  q cnt_"^"_successCnt
}

/// 处理一行数据 四川
ClassMethod InputComInfosc(rowStr As %String, msg As %String) As %String
{
	n (rowStr,msg)
	s colNoStr=""
	s rowStr=$tr(rowStr,$c(13,10))
	s rowStr=$tr(rowStr," ","")

	s ret=0
	s del="^"
	s InciCode=$p(rowStr,del,..Colsc("InciCode") ) ;物资代码
	i InciCode="" d
	.s ret=-1 
	.s msg="本院物资代码不能为空"
	q:ret<0 ret
	s GoodsId=$p(rowStr,del,..Colsc("GoodsId") ) ;采购平台产品编码
	i GoodsId="" d
	.s ret=-3 
	.s msg="采购平台产品编码不能为空"
	q:ret<0 ret
	
	
	s IncId=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(InciCode)_"Z",""))
	i IncId="" d
	.s ret=-5 
	.s msg="此物资代码无效"
	q:ret<0 ret
	s Matrowid=$o(^DHCMatPurCataLog(0,"GoodsId",GoodsId,0))
	i Matrowid="" d
	.s ret=-5
	.s msg="此产品编码无效"
	q:ret<0 ret
	
	
	s PurItmRelDr=$o(^DHCItmPCRelation(0,"INCI",IncId,0))
	s tmpIncid=$o(^DHCItmPCRelation(0,"LOG",Matrowid,""))
	i (PurItmRelDr'="")||(tmpIncid'="") d
	.s ret=-7
	.s msg="物资代码"_InciCode_"或者商品代码"_GoodsId_"已存在对照关系"
		
	&sql(insert into SQLUser.DHC_ItmPurCataRelations(ItmPCR_INCI_DR,ItmPCR_PurCata_DR) values (:IncId,:Matrowid))
	i SQLCODE'=0  d
	.s ret=-9
	.s msg="对照关系插入失败"
	q:ret<0 ret
	q ret
}

/// 取出列在串中的位置 四川
ClassMethod Colsc(colname As %String) As %String
{
	n (colname)
   //此处为导入数据的排列顺序
   //"物资代码^采购平台产品编码^采购平台规格型号编号"
   s cols="InciCode^GoodsId"
	s cnt=$l(cols,"^")
	s ret=0
	f i=1:1:cnt q:ret>0  d
	.i $p(cols,"^",i)=colname s ret=i q
	q ret
}

ClassMethod ErrIdsc() As %String
{
	
 s i=$o(^TMP("input_msunpurplansc",$j,""),-1)+1	
 q i
}

ClassMethod SetErrsc(row As %String, errinfo As %String)
{
	n (row,errinfo)
  s ^TMP("input_msunpurplansc",$j,..ErrIdsc())="第"_row_"行错误:"_errinfo
}

/// 四川阳光采购 批量对照企业
/// fileName: .Txt文件(Tab分隔符
/// w ##class(web.DHCSTMHUI.Tools.InputYGCGDataInfo).StartInputComSC("D:\testcom.txt","")
ClassMethod StartInputComSC(fileName As %String, sub As %String) As %String
{
  n (fileName,sub)
  
  s version="HISUI"  ; EXT 类型
  
  i sub="" s sub="MSunPurPlanComsc"
  s p=$zn
  if version="HISUI" d
  .s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(fileName,sub,p)
  if version="EXT" d
  .s ret=##class(web.DHCSTM.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  if version="HISUI" {
	  s i=2
	  f  s i=$O(^TMPDHCSTMINPUT(p,sub,i)) q:i=""  d
	  .s rowStr=$G(^TMPDHCSTMINPUT(p,sub,i))
	  .w rowStr,!
	  .s cnt=cnt+1
	  .tstart
	  .s msg=""
	  .s ret1=..InputComLinksc(rowStr,.msg)
	  .i ret1=0 d
	  ..tcommit
	  ..s successCnt=successCnt+1
	  .e  d
	  .. tro
	  .. d ..SetErrComsc(i,msg)
	  ..
	  k ^TMPDHCSTMINPUT(p,sub)  //删除临时global
  }
  else{
	s i=2
	  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
	  .s rowStr=$G(^zTSA(p,sub,i))
	  .w rowStr,!
	  .s cnt=cnt+1
	  .tstart
	  .s msg=""
	  .s ret1=..InputComLinksc(rowStr,.msg)
	  .i ret1=0 d
	  ..tcommit
	  ..s successCnt=successCnt+1
	  .e  d
	  .. tro
	  .. d ..SetErrComsc(i,msg)
	  ..
	  k ^zTSA(p,sub)  //删除临时global
	}
  q cnt_"^"_successCnt
}

/// 处理一行数据 四川
ClassMethod InputComLinksc(rowStr As %String, msg As %String) As %String
{
	n (rowStr,msg)
	s colNoStr=""
	s rowStr=$tr(rowStr,$c(13,10))
	s rowStr=$tr(rowStr," ","")

	s ret=0
	s del="^"
	s HISComType=$p(rowStr,del,..ComColsc("HISComType") ) ;企业类型
	i HISComType="" d
	.s ret=-1 
	.s msg="HIS企业类型不能为空"
	q:ret<0 ret
	i "VMC"'[HISComType d
	.s ret=-1 
	.s msg="HIS企业类型不正确(V供应商M生产商C配送商)"
	q:ret<0 ret
	s HISComId=$p(rowStr,del,..ComColsc("HISComId") ) ;HIS企业ID
	i HISComId="" d
	.s ret=-1 
	.s msg="本院HIS企业ID不能为空"
	q:ret<0 ret
	
	s HISCom=$p(rowStr,del,..ComColsc("HISCom") ) ;HIS企业名称
	i HISCom="" d
	.s ret=-1 
	.s msg="本院HIS企业名称不能为空"
	q:ret<0 ret
	
	s companyId=$p(rowStr,del,..ComColsc("companyId") ) ;采购平台企业ID
	i companyId="" d
	.s ret=-3 
	.s msg="采购平台企业ID不能为空"
	q:ret<0 ret
	
	
	s companyName=$p(rowStr,del,..ComColsc("companyName") ) ;平台企业名称
	s DHCPCRowId=$o(^PURCOMCAT(0,"CODE",companyId,""))
	i DHCPCRowId="" d
	.s ret=-4
	.s msg=companyName_"系统不存在"
	
	s tmpDHCPCRowId=$o(^PURCOMCAT(0,"TYPEPOINT",HISComType,HISComId,""))
	i tmpDHCPCRowId'="" d
	.s ret=-5
	.s msg=HISCom_"系统已存在对照"
	
	s TmpHisPoint=$p(^PURCOMCAT(DHCPCRowId),"^",18)
	i TmpHisPoint'="" d
	.s ret=-6
	.s msg=companyName_"系统已存在对照"
	
	&sql(UPDATE DHC_PurComCatalog SET DHCPC_Pointer=:HISComId,DHCPC_Type=:HISComType WHERE DHCPC_RowId=:DHCPCRowId )
	i SQLCODE'=0  d
	.s ret=-9
	.s msg="对照关系插入失败"
	q:ret<0 ret
	q ret
}

/// 取出列在串中的位置 四川
ClassMethod ComColsc(colname As %String) As %String
{
	n (colname)
    //此处为导入数据的排列顺序
    //"HIS企业类型^HIS企业ID^HIS企业名称^平台企业编号^平台企业名称"
    s cols="HISComType^HISComId^HISCom^companyId^companyName"
	s cnt=$l(cols,"^")
	s ret=0
	f i=1:1:cnt q:ret>0  d
	.i $p(cols,"^",i)=colname s ret=i q
	q ret
}

ClassMethod ErrIdComsc() As %String
{
	
 s i=$o(^TMP("input_msunpurplancomsc",$j,""),-1)+1	
 q i
}

ClassMethod SetErrComsc(row As %String, errinfo As %String)
{
	n (row,errinfo)
  s ^TMP("input_msunpurplancomsc",$j,..ErrIdComsc())="第"_row_"行错误:"_errinfo
}

/// 深圳阳光采购 执行导入的总入口
/// fileName: .Txt文件(Tab分隔符
ClassMethod StartInput(fileName As %String, sub As %String) As %String
{
  n (fileName,sub)
  
  i sub="" s sub="MSunPurPlan"
  s p=$zn
  s ret=##class(web.DHCSTM.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  ;
  s i=1
  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .w rowStr,!
  .s cnt=cnt+1
  .;w cnt,!
  .tstart
  .s msg=""
  .s ret1=..InputComInfo(rowStr,.msg)
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
ClassMethod InputComInfo(rowStr As %String, msg As %String) As %String
{
	n (rowStr,msg)
	s colNoStr=""
	s rowStr=$tr(rowStr,$c(13,10))
	s rowStr=$tr(rowStr," ","")

	s ret=0
	s del="^"
	s InciCode=$p(rowStr,del,..Col("InciCode") ) ;物资代码
	i InciCode="" d
	.s ret=-1 
	.s msg="本院物资代码不能为空"
	q:ret<0 ret
	s GoodsId=$p(rowStr,del,..Col("GoodsId") ) ;采购平台产品编码
	i GoodsId="" d
	.s ret=-3 
	.s msg="采购平台产品编码不能为空"
	q:ret<0 ret
	s SubCodeId=$p(rowStr,del,..Col("SubCodeId") ) ;采购平台规格型号编号
	i SubCodeId="" d
	.s ret=-4
	.s msg="采购平台规格型号编号不能为空"
	q:ret<0 ret
	s IncId=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(InciCode)_"Z",""))
	i IncId="" d
	.s ret=-5 
	.s msg="此物资代码无效"
	q:ret<0 ret
	s Matrowid=$o(^DHCMatPurCataLog(0,"GoodsId",GoodsId,0))
	i Matrowid="" d
	.s ret=-5
	.s msg="此产品编码无效"
	q:ret<0 ret
	s SMLCh=$o(^DHCMatPurCataLog(0,"SubCode",SubCodeId,Matrowid,0))
	i SMLCh="" d
	.s ret=-6
	.s msg="此规格型号编号无效"
	q:ret<0 ret
	s PurItmRelDr=$o(^DHCItmPCRelation(0,"INCI",IncId,0))
	i PurItmRelDr'="" d
	.s ret=-7
	.s msg="物资代码"_InciCode_"已存在对照关系"
	s SMLRowId=Matrowid_"||"_SMLCh
	&sql(insert into SQLUser.DHC_ItmPurCataRelations(ItmPCR_INCI_DR,ItmPCR_PurCata_DR,ItmPCR_SML_DR) values (:IncId,:Matrowid,:SMLRowId))
	i SQLCODE'=0  d
	.s ret=-9
	.s msg="对照关系插入失败"
	q:ret<0 ret
	q ret
}

/// 取出列在串中的位置
ClassMethod Col(colname As %String) As %String
{
	n (colname)
   //此处为导入数据的排列顺序
   //"物资代码^采购平台产品编码^采购平台规格型号编号"
   s cols="InciCode^GoodsId^SubCodeId"
	s cnt=$l(cols,"^")
	s ret=0
	f i=1:1:cnt q:ret>0  d
	.i $p(cols,"^",i)=colname s ret=i q
	q ret
}

ClassMethod ErrId() As %String
{
	
 s i=$o(^TMP("input_msunpurplan",$j,""),-1)+1	
 q i
}

ClassMethod SetErr(row As %String, errinfo As %String)
{
	n (row,errinfo)
  s ^TMP("input_msunpurplan",$j,..ErrId())="第"_row_"行错误:"_errinfo
}

}

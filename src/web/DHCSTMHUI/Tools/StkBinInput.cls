Import sqluser

/// 货位码信息导入程序
///   Author:zhangxiao
///   Date:2013-12-27
Class web.DHCSTMHUI.Tools.StkBinInput Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 处理一行数据
ClassMethod InputItm(RowObj) As %String
{
	n (RowObj)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s LocDesc=RowObj.%Get("科室名称")
	s Desc=RowObj.%Get("货位名称")
	s LocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),0))
	i +LocId>0 d
	.s Code=..GetNextCode(LocId)  //自动生成代码(代码包含“科室”信息)
	e  d
	.d RtnObj.Err(-1,"","不存在此科室!","",0)
	q:RtnObj.success'=0 RtnObj
	s id=##class(web.DHCSTMHUI.INCStkBin).GetStkBinByDesc(LocId,Desc)
	i id'="" d RtnObj.Err(-1,"","货位名称重复!","",0)
	q:RtnObj.success'=0 RtnObj

	&sql(insert into inc_stkbin (incsb_code,incsb_desc) values (:Code,:Desc))
	i SQLCODE'=0  d
	.d RtnObj.Err(-1,"","货位插入失败!")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
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

}

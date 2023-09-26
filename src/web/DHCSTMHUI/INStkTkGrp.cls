Import sqluser

Class web.DHCSTMHUI.INStkTkGrp Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	插入盘点科室管理组
/// Creator:	lxt
/// CreateDate:	2020-07-24
/// Table:		DHC_InStkTk
/// Input:		账盘单id，管理组串
/// Return：	
ClassMethod InsStktkManGrp(Inst As %String, manGrpStr As %String) As RtnObj
{
	n (Inst,manGrpStr)
	s RtnObj=##class(RtnObj).%New()
	i Inst="" q RtnObj.Err(-301,"","插入盘点科室管理组时盘点单主表为空!","",0)
	i manGrpStr="" q RtnObj.Err(-302,"","插入盘点科室管理组时管理组为空!","",0)
	
	f i=1:1:$l(manGrpStr,",") q:RtnObj.success'=0  d
	.s manGrp=$p(manGrpStr,",",i)
	.s ch=$O(^DHCINST(Inst,"TG",""),-1)+1
	.&sql(insert into DHC_InStkTkGrp(TG_INST_Parref,TG_Childsub,TG_LMG_DR) values (:Inst,:ch,:ManGrp))
	.i SQLCODE'=0 d RtnObj.Err(-303,"","DHC_InStkTkGrp表插入错误SQLCODE:"_SQLCODE_",msg:"_%msg) 
	
	q RtnObj
}

/// 删除
/// Authro:zhwh
/// Date:2012-08-02
/// Argu:
/// StktkManGrp - 
/// Return:
///  0 - sucess
///  <0 - failure
ClassMethod Delete(StktkManGrp As %String) As %String
{
	//锁定
  q:##class(web.DHCSTMHUI.Common.AppCommon).Lock("User.DHCInStkTkGrp"_StktkManGrp)<0 -99  
  
  //判断是否可删除
  i ..AllowDel(StktkManGrp)<0 d ..uLock(StktkManGrp) q -1
  //删除
  &sql(delete from DHC_InStkTkGrp where %ID=:StktkManGrp)
  d ..uLock(StktkManGrp)
  i SQLCODE'=0   q -2
  q SQLCODE
}

/// 判断是否允许删除
/// Authro:zhwh
/// Date:2012-08-02
/// Argu:
/// StktkManGrp - 
/// Return:
///  0 - 允许
///  <0 - 不允许
ClassMethod AllowDel(StktkManGrp As %String) As %String
{
  n (StktkManGrp)
  s inst=+StktkManGrp
  q ##class(web.DHCSTMHUI.INStkTk).AllowDel(inst)
}

/// 解锁
/// Authro:zhwh
/// Date:2012-08-02
/// Argu:
///    StktkManGrp - 盘点管理组rowid
/// 
ClassMethod uLock(StktkManGrp As %String)
{
  q:StktkManGrp=""
  d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("User.DHCInStkTkGrp"_StktkManGrp)
  q
}

/// 盘点管理组列表
/// Author:zhangdongmei
/// Date:2012-08-28
/// Argu:盘点主表id
/// Return:
/// 盘点管理组列表
ClassMethod GetStkTkGrp(inst As %String) As %String
{
  i inst="" q ""
  s data=""
  s chl=0
  
  f  s chl=$o(^DHCINST(inst,"TG",chl)) q:chl=""  d
  .s lmgId=$p(^DHCINST(inst,"TG",chl),"^",1)
  .s lmgDesc=$p(^DHCLMG(lmgId),"^",3)
  .i data="" d
  ..s data=lmgId_"^"_lmgDesc
  .e  d
  ..s data=data_","_lmgId_"^"_lmgDesc
  .
  
  q data
}

ClassMethod GetLocStkTkGrp(inst As %String) As %String
{
  i inst="" q ""
  s Loc=""
  &sql(select INST_CTLOC_DR into :Loc from DHC_InStkTk where INST_RowId=:inst)
 
  q Loc
}

/// Descript:	盘点管理组列表
/// Creator:	lxt
/// CreateDate:	2020-07-24
/// Table:		
/// Input:		主单id
/// Return：	
ClassMethod DHCSTInStkTkGrp(Inst As %String) As %String
{
	n (Inst)
	s ManGrpStr=""
	
	s ch=0
	f  s ch=$o(^DHCINST(Inst,"TG",ch)) q:ch=""  d
	.s ManGrpId=$p(^DHCINST(Inst,"TG",ch),"^",1)
	.s ManGrpStr=ManGrpStr_"^"_ManGrpId
	
	i ManGrpStr'="" s ManGrpStr=ManGrpStr_"^"
	
	q ManGrpStr
}

}

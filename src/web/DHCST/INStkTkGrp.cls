Import sqluser

Class web.DHCST.INStkTkGrp Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 盘点主表插入时插入盘点的管理组表
/// Author:zhwh
/// Date:2012-08-02
/// Argu:
/// StktkGrp  -盘点管理组rowid
/// Inst - 盘点主表rowid
/// ManGrp - 管理组rowid
/// Return:
/// 0 - success
/// <0 -failuer
ClassMethod Update(StktkGrp As %String, Inst As %String, ManGrp As %String, WithOutSelectLMGFlag As %String) As %String
{
 q:ManGrp="" -100
 q:Inst="" -101
 
 i WithOutSelectLMGFlag="Y" s WithOutSelectLMGFlag="N"
 e  s WithOutSelectLMGFlag="Y"
 i StktkGrp="" d
 .
 .//科室检查
 .s instktkLoc=$p(^DHCINST(Inst),"^",5)
 .s manGrpLoc=$p(^DHCLMG(ManGrp),"^",1)
 .i instktkLoc'=manGrpLoc s result=-102 q   //科室不一致
 .
 .s ch=$O(^DHCINST(Inst,"TG",""),-1)+1
 .&sql(insert into DHC_InStkTkGrp(TG_INST_Parref,TG_Childsub,TG_LMG_DR,TG_IFInclud) values (:Inst,:ch,:ManGrp,:WithOutSelectLMGFlag) )
 .i SQLCODE'=0 s result=-1
 .s result=%ROWID	
 e  d
 .&sql(update DHC_InStkTkGrp set TG_LMG_DR=:ManGrp ,TG_IFInclud=:WithOutSelectLMGFlag where %ID=:StktkGrp  )
 .i SQLCODE'=0 s result=-2	
 .e   s result=StktkGrp
 q result
}

/// 取盘点管理组信息串("^"分隔)
/// Author:zhwh
/// Date:2012-08-02
/// Argu:
/// StktkManGrp - 盘点管理组rowid
/// Return：
/// 盘点管理组信息串("^"分隔)
ClassMethod Select(StktkManGrp As %String) As %String
{
 n (StktkManGrp)
 k PLIST
 s result=""
 &sql(select * into :PLIST() from DHC_InStkTkGrp where %ID=:StktkManGrp)
 q:SQLCODE result
 s cnt=$o(PLIST(""),-1)
 f i=1:1:cnt d
 .i result="" s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 q result
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
  q:##class(web.DHCST.Common.AppCommon).Lock("User.DHCInStkTkGrp"_StktkManGrp)<0 -99  
  
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
  q ##class(web.DHCST.INStkTk).AllowDel(inst)
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
  d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCInStkTkGrp"_StktkManGrp)
  q
}

/// 盘点管理组列表
/// Author:zhangdongmei
/// Date:2012-08-28
/// Argu:盘点主表id
/// Return:
/// 盘点管理组列表
/// w ##class(web.DHCST.INStkTkGrp).GetStkTkGrp(23)
ClassMethod GetStkTkGrp(inst As %String) As %String
{
  i inst="" q ""
  s data=""
  s chl=0
  f  s chl=$o(^DHCINST(inst,"TG",chl)) q:chl=""  d
  .s lmgId=$p(^DHCINST(inst,"TG",chl),"^",1)
  .s InInclude=$p(^DHCINST(inst,"TG",chl),"^",2)
  .s lmgDesc=$p(^DHCLMG(lmgId),"^",3)
  .i data="" d
  ..s data=lmgId_"^"_lmgDesc_"^"_InInclude
  .e  d
  ..s data=data_","_lmgId_"^"_lmgDesc_"^"_InInclude
  .
  q data
}

/// 盘点管理组列表
/// Authro:zhwh
/// Date:2012-08-02
/// Argu:
///    INST - 盘点主表rowid(DHC_INStkTk)
Query DHCSTInStkTkGrp(INST As %String) As %SQLQuery(CONTAINID = 1)
{
 select %ID,tg_lmg_dr lmg,tg_lmg_dr->lmg_desc,TG_IFInclud IFInclud from dhc_instktkgrp where TG_INST_PARREF=:INST
}

}

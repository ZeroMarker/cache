Import sqluser

Class web.DHCST.DHCLocManGrp Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 插入或更新1条科室管理组记录
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///   Lmg - 科室管理组rowid
///   code - 科室管理组
///   desc -货位名称
/// Return ：
///  >0 - 管理组记录rowid
///  <0 - 插入或更新失败
///  
ClassMethod Update(Lmg As %String, Loc As %String, code As %String, desc As %String) As %String
{
  q:Loc="" -100   //科室rowid不可为空
  s err=0
  i ##class(web.DHCST.Common.AppCommon).Lock("User.DHCLocManGrp")<0 s err=-99
  ts
  i Lmg="" d
  .&sql(insert into dhc_locmangrp (lmg_ctloc_dr,lmg_code,lmg_desc) values (:Loc,:code,:desc))
  .i SQLCODE'=0  tro  s err=-1  q
  .s Lmg=%ROWID
  e   d
  .&sql(update dhc_locmangrp set lmg_code=:code, lmg_desc=:desc where %ID=:Lmg  )
  .i SQLCODE'=0 tro  s err=-2  q
  .
  i err=0 tc
  i err'=0 tro
  
  d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCLocManGrp") 
  q:err<0 err
  q Lmg
}

/// 取1条科室管理组记录值
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///   Lmg - 科室管理组rowid
/// Return ：
/// 科室管理组记录值串("^"分隔)
ClassMethod Select(Lmg As %String) As %String
{
 k PLIST
 s result=""
 &sql(select * into :PLIST() from DHC_LocManGrp where %ID=:Lmg )
 q:SQLCODE'=0 result
 s cnt=$o(PLIST(""),-1)
 f i=1:1:cnt d
 .i result=""  s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 q result
}

/// 删除一条科室管理组
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///   Lmg - 科室管理组rowid
/// Return
///  0 - success
///  <0 - failure
ClassMethod Delete(Lmg As %String) As %String
{
 //	
 q:##class(web.DHCST.Common.AppCommon).Lock("User.DHCLocManGrp")<0 -99
 
 q:..AllowDel(Lmg)<0 q -1
 //
 s err=0
 &sql(delete from dhc_locmangrp where %ID = :Lmg)
 i SQLCODE'=0 s err=-2 
 d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCLocManGrp") 
 q err
}

/// 允许删除
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///   Lmg - 科室管理组rowid
/// Return
///  0 - 允许
///  <0 - 不允许
ClassMethod AllowDel(Lmg As %String) As %String
{
  s incil=$O(^DHCINCIL(0,"LMG",Lmg,""))
  i incil'="" q -1
  q 0
}

/// 检索科室的管理组列表
/// Auhro:zhwh
/// Date:2012-07-25
/// Argu:
///   Loc -科室rowid
/// 
Query LocManGrp(Loc As %String) As %SQLQuery(CONTAINID = 1)
{
  SELECT %ID rowid,LMG_CTLOC_DR,LMG_Code,LMG_Desc FROM DHC_LocManGrp
   Where LMG_CTLOC_DR=nvl(:Loc,LMG_CTLOC_DR)
}

}

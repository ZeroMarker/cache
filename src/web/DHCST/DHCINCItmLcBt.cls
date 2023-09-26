Import sqluser

Class web.DHCST.DHCINCItmLcBt Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 插入或更新批次附加表
/// 	Author:zhwh
/// 	Date:2012-08-08
/// 	Argu:
/// 	  inclb -库存批次rowid
/// 	  data - 数据串("^"分隔)
/// 	Return:
/// 	  0 -success
/// 	  <0 -failure
ClassMethod Update(inclb As %String, data As %String) As %String
{
 q:inclb="" -100
 s active=$P(data,"^",1)  //活动标志
 s ret=0
 q:##class(web.DHCST.Common.AppCommon).Lock("User.DHCINCItmLcBt"_inclb)<0 -99
 s dhcInclb=..GetExClb(inclb)
 i dhcInclb="" d   //没有附加表记录
 .&sql(insert into dhc_incitmlcbt (inclb_lb_dr,inclb_active) values (:inclb,:active))
 .i SQLCODE'=0 s ret=-1 q 
 e  d
 .&sql(update dhc_incitmlcbt set inclb_active=:active where %ID=:dhcInclb)
 .i SQLCODE'=0 s ret=-2 q 
 .
 d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCINCItmLcBt"_inclb)
 q ret
}

///  取库存批次附加表的记录数据串
/// 	Author:zhwh
/// 	Date:2012-08-08
/// 	Argu:
/// 	  inclb -  库存批次rowid
/// 	Return:
/// 	 
ClassMethod Select(inclb As %String) As %String
{
 n (inclb)
 k PLIST
 s result=""
 s dhcInclb=..GetExClb(inclb)
 q:dhcInclb="" result
 &sql(select * into :PLIST() from DHC_INCItmLcBt where %ID=:dhcInclb )
 q:SQLCODE'=0 result
 s cnt=$o(PLIST(""),-1)
 f i=1:1:cnt d
 .i result=""  s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 .
 q result
}

/// 删除库存批次的附加表记录
/// Author:zhwh
/// Date:2012-08-08
/// Argu:
/// 	inclb - INC_ItmLCbt记录的rowid
/// Return:
///    0 -success
///    < 0 -failure
ClassMethod Delete(inclb As %String) As %String
{
 n (inclb)
 s dhcInclb=..GetExClb(inclb)
 q:dhcInclb="" 0
 s err=0
 q:##class(web.DHCST.Common.AppCommon).Lock("User.DHCINCItmLcBt"_inclb)<0 -99
 &sql(delete from dhc_incitmlcbt where %id=:dhcInclb)
 i SQLCODE'=0 s err=-1
 d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCINCItmLcBt"_inclb)
 q err
}

/// 取DHC_INCItmLcBt记录的附加表记录
/// Author:zhwh
/// Date:2012-08-08
/// Argu:
/// 	inclb - INC_ItmLCbt记录的rowid
/// Return:
///   附加表记录rowid
///   
ClassMethod GetExClb(inclb As %String) As %String
{
 n (inclb)
 s dhcInclb=$O(^DHCINCLB(0,"LB",inclb,""))
 q dhcInclb
}

/// Descript: 	增加批次扩展记录
/// Creater:	zhouyg
/// CreateDate:	2014-07-07(20141212)
/// Input:		inclb -库存批次rowid
/// Return: 	扩展批次ID
ClassMethod Insert(inclb As %String) As %String
{
 q:inclb="" -100
 s active="Y"  //活动标志
 s ret=0
 q:##class(web.DHCST.Common.AppCommon).Lock("User.DHCINCItmLcBt"_inclb)<0 -99
 s dhcInclb=..GetExClb(inclb)
 i dhcInclb="" d   //没有附加表记录
 .&sql(insert into dhc_incitmlcbt (inclb_lb_dr,inclb_active) values (:inclb,:active))
 .i SQLCODE'=0 s ret=-1 q 
 .s dhcInclb=$p(%ROWID,$c(1))
 d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCINCItmLcBt"_inclb)
 q dhcInclb
}

}

Import sqluser

/// Description:配液分类维护和收费项关联表操作相关(采用面向对象的形式)
/// Creator:    hulihua
/// CreateDate: 2016-12-16
/// Table:      PIVA_OrderLink、PIVA_OrderLinkInstruc、PIVA_OrderLinkItm
Class web.DHCSTPIVASETPIVACATSQL Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:保存或者更新配液分类主表信息
/// Creator:	hulihua
/// CreateDate:	2016-12-16
/// Table:      PIVA_OrderLink
/// Input:		配液分类主表ID^配液分类描述
/// Output:
/// Return：    0,成功
/// 			-1,	配液分类描述为空
/// 			-2,	操作表失败
/// w ##class(web.DHCSTPIVASETPIVACATSQL).SaveOrUpdate("")
ClassMethod SaveOrUpdate(str, savetype)
{
	s ID=$p(str,"^",1)
	s PolDesc=$p(str,"^",2)
	s POLMinVolume=$p(str,"^",3)
	s POLMaxVolume=$p(str,"^",4)
	q:(savetype=1)&&(PolDesc="") -1
	q:(savetype=2)&&(POLMinVolume="")&&(POLMaxVolume="") -1
	s $ZT="Error^DHCSTERROR"                        //增加错误处理
	i +ID=0 
	{ 
		s obj=##class(User.PIVAOrderLink).%New()
	}else{
		s obj=##class(User.PIVAOrderLink).%OpenId(ID)
		d obj.%Reload()
	}
	s:savetype=1 obj.POLDesc=PolDesc
	s obj.POLMinVolume=POLMinVolume
	s obj.POLMaxVolume=POLMaxVolume
	s sc=obj.%Save()
	i $$$ISERR(sc) q -2   
	q 0
}

/// Description:保存或者更新配液分类关联用法子表信息
/// Creator:	hulihua
/// CreateDate:	2016-12-19
/// Table:      PIVA_OrderLinkInstruc
/// Input:		配液分类主表ID^配液需关联用法ID
/// Output:
/// Return：    大于0,成功
/// 			-1,	关联用法为空
/// 			-2,	操作表失败
/// w ##class(web.DHCSTPIVASETPIVACATSQL).SaveOrUpdateLinkIns("")
ClassMethod SaveOrUpdateLinkIns(str)
{
	s ID=$p(str,"^",1)
	s PolSid=$p(str,"^",2)
	s InstrucDr=$p(str,"^",3)
	q:InstrucDr="" -1
	s $ZT="Error^DHCSTERROR"                        //增加错误处理
	i +PolSid=0  d 
	.s obj=##class(User.PIVAOrderLinkInstruc).%New()
	.s obj.POLSPOLParRef=##class(User.PIVAOrderLink).%OpenId(ID)
 	.s ch=$o(^POLI(ID,"S",""),-1)+1
 	.s obj.POLSChildsub=ch
	e  d
	.s obj=##class(User.PIVAOrderLinkInstruc).%OpenId(PolSid)
	.d obj.%Reload()
	q:$d(^POLI(0,"INSTRUCDR",InstrucDr,ID)) -11
	s obj.POLSPHCInstrucDr=##class(User.PHCInstruc).%OpenId(InstrucDr)
	s sc=obj.%Save()
	i $$$ISERR(sc) q -2 
	q obj.%Id()
}

/// Description:删除配液分类关联用法子表信息
/// Creator:	hulihua
/// CreateDate:	2016-12-19
/// Table:      PIVA_OrderLinkInstruc
/// Input:		配液类别关联用法子表ID
/// Output:
/// Return：    大于0,成功
/// 			-1,	关联用法为空
/// 			-2,	操作表失败
/// w ##class(web.DHCSTPIVASETPIVACATSQL).DeleteLinkIns("")
ClassMethod DeleteLinkIns(str)
{
	&sql(delete from PIVA_OrderLinkInstruc where POLS_RowID=:str)
	i SQLCODE'=0 q -2
	q 0
}

/// Description:保存或者更新配液分类关联用法子表信息
/// Creator:	hulihua
/// CreateDate:	2016-12-19
/// Table:      PIVA_OrderLinkItm
/// Input:		配液类别主表ID^关联药品配液类别子表ID^需关联药品配液分类ID
/// Output:
/// Return：    大于0,成功
/// 			-1,	关联用法为空
/// 			-2,	操作表失败
/// 			-11,已存在,该分类的维护只能是或者的关系
/// w ##class(web.DHCSTPIVASETPIVACATSQL).SaveOrUpdateLinkItm("")
ClassMethod SaveOrUpdateLinkItm(str)
{
	s ID=$p(str,"^",1)
	s PolIid=$p(str,"^",2)
	s PivaCatDr=$p(str,"^",3)
	q:PivaCatDr="" -1
	s RelationFlag=$p(str,"^",4)
	q:RelationFlag="" -3
	s $ZT="Error^DHCSTERROR"                        //增加错误处理
	i +PolIid=0  d 
	.s obj=##class(User.PIVAOrderLinkItm).%New()
	.s obj.POLIPOLParRef=##class(User.PIVAOrderLink).%OpenId(ID)
 	.s ch=$o(^POLI(ID,"G",""),-1)+1
 	.s obj.POLIChildsub=ch
	e  d
	.s obj=##class(User.PIVAOrderLinkItm).%OpenId(PolIid)
	.d obj.%Reload()
	q:$d(^POLI(0,"PIVACAT",PivaCatDr,ID)) -11
	s obj.POLIPHCPivaCatDr=##class(User.DHCPHCPivaCat).%OpenId(PivaCatDr)
	s obj.POLIPivaCatRelation=RelationFlag
	s sc=obj.%Save()
	i $$$ISERR(sc) q -2 
	q obj.%Id()
}

/// Description:删除配液分类关联用法子表信息
/// Creator:	hulihua
/// CreateDate:	2016-12-19
/// Table:      PIVA_OrderLinkItm
/// Input:		配液类别关联药品配液分类子表ID
/// Output:
/// Return：    大于0,成功
/// 			-1,	关联用法为空
/// 			-2,	操作表失败
/// w ##class(web.DHCSTPIVASETPIVACATSQL).DeleteLinkItm("")
ClassMethod DeleteLinkItm(str)
{
	&sql(delete from PIVA_OrderLinkItm where POLI_RowID=:str)
	i SQLCODE'=0 q -2
	q 0
}

/// Description:保存或者更新配液分类关联收费项医嘱子表
/// Creator:	hulihua
/// CreateDate:	2016-12-20
/// Table:      PIVA_OrderLinkOrder
/// Input:		配液类别主表ID^关联收费项医嘱子表ID^需关联收费项医嘱ID^需关联收费项医嘱数量
/// Output:
/// Return：    大于0,成功
/// 			-1,	收费项医嘱为空
/// 			-2,	操作表失败
/// 			-3,	收费项医嘱数量为空或0
/// w ##class(web.DHCSTPIVASETPIVACATSQL).SaveOrUpdateLinkItm("")
ClassMethod SaveOrUpdateLinkOrder(str)
{
	s ID=$p(str,"^",1)
	s PolOid=$p(str,"^",2)
	s OrderDr=$p(str,"^",3)
	q:OrderDr="" -1
	s AddQty=+$p(str,"^",4)
	q:AddQty=0 -3
	s $ZT="Error^DHCSTERROR"                        //增加错误处理
	i +PolOid=0  d 
	.s obj=##class(User.PIVAOrderLinkOrder).%New()
	.s obj.POLOPOLParRef=##class(User.PIVAOrderLink).%OpenId(ID)
 	.s ch=$o(^POLI(ID,"M",""),-1)+1
 	.s obj.POLOChildsub=ch
	e  d
	.s obj=##class(User.PIVAOrderLinkOrder).%OpenId(PolOid)
	.d obj.%Reload()
	&SQL(SELECT * FROM PIVA_OrderLinkOrder WHERE POLO_POL_ParRef=:ID AND POLO_Arcim_Dr=:OrderDr)
	q:SQLCODE=0 -11
	s obj.POLOArcimDr=##class(User.ARCItmMast).%OpenId(OrderDr)
	s obj.POLOAddQty=AddQty
	s sc=obj.%Save()
	i $$$ISERR(sc) q -2 
	q obj.%Id()
}

/// Description:删除配液分类关联收费项医嘱子表
/// Creator:	hulihua
/// CreateDate:	2016-12-20
/// Table:      PIVA_OrderLinkOrder
/// Input:		配液类别关联关联收费项医嘱子表ID
/// Output:
/// Return：    大于0,成功
/// 			-1,	收费项医嘱为空
/// 			-2,	操作表失败
/// w ##class(web.DHCSTPIVASETPIVACATSQL).DeleteLinkOrder("")
ClassMethod DeleteLinkOrder(str)
{
	&sql(delete from PIVA_OrderLinkOrder where POLO_RowID=:str)
	i SQLCODE'=0 q -2
	q 0
}

/// Description:删除配液分类主表
/// Creator:	yunhaibao
/// CreateDate:	2017-02-08
/// Table:      PIVA_OrderLink
/// Input:		配液类别关联关联收费项医嘱子表ID
/// w ##class(web.DHCSTPIVASETPIVACATSQL).DeletePIVAOrderLink("")
ClassMethod DeletePIVAOrderLink(str)
{
	&sql(delete from PIVA_OrderLink where POL_Rowid=:str)
	i SQLCODE'=0 q -2
	q 0
}

}

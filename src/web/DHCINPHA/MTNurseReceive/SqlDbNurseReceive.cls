/// Description:护士签收表操作相关(采用面向对象的形式)
/// Creator:    hulihua
/// CreateDate: 2016-10-24
/// Table:      DHC_PHBox
Class web.DHCINPHA.MTNurseReceive.SqlDbNurseReceive Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:更新物流箱护士签收信息
/// Creator:	hulihua
/// CreateDate:	2016-10-24
/// Table:      DHC_PHBox
/// Input:		物流箱ID，签收人ID
/// Output:
/// Return：    0,成功
/// 			-1,	操作表失败，-2调用新产品组接口失败
/// w ##class(web.DHCINPHA.MTNurseReceive.SqlDbNurseReceive).UpdatePHBoxInfo("4^9")
ClassMethod UpdatePHBoxInfo(str)
{
	n (str)
	s phbid=$p(str,"^",1)
	s wardhanduser=$p(str,"^",2)
	s sysdate=+$h
	s systime=$p($h,",",2)
	s $ZT="Error^DHCSTERROR"                        //增加错误处理
	s obj=##class(User.DHCPHBox).%OpenId(phbid)
	d obj.%Reload()
	s obj.PHBUserWardHandDr=##class(User.SSUser).%OpenId(wardhanduser,0)
	s obj.PHBDateWardHand=sysdate
	s obj.PHBTimeWardHand=systime
	s obj.PHBStatus=70
	s sc=obj.%Save()
	i $$$ISERR(sc) q -1
	//以下为调用配送改变状态接口
	s err=0
	s phloc=$p(^DHCPHBOX(phbid),"^",15)
	s HospId=$p($g(^CTLOC(phloc)),"^",22)
	s Params="^"_phloc_"^"_wardhanduser_"^"_HospId
	s ParamPropStr=##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetParamProp(Params)
	s InvokPatchFlag=$p(ParamPropStr,"^",6)
	i InvokPatchFlag="Y"  d
	.s ret=##class(web.DHCSTInterfacePH).UpdReqDispatch(phbid,wardhanduser)
	.s:ret'=0 err=-2  
	q err
}

}

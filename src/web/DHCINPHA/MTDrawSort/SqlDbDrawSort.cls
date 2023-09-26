/// Description:备药规则维护表操作相关(采用面向对象的形式)
/// Creator:    hulihua
/// CreateDate: 2016-10-07
/// Table:      DHC_PHSendLoc
Class web.DHCINPHA.MTDrawSort.SqlDbDrawSort Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:保存或者更新备药规则信息
/// Creator:	hulihua
/// CreateDate:	2016-10-07
/// Table:      DHC_PHDrawSort
/// Input:		备药规则主表ID^药房科室ID^规则代码^规则描述
/// Output:
/// Return：    0,成功
/// 			-1,	药房科室、规则代码或者规则描述为空
/// 			-2,	操作表失败
/// w ##class(web.DHCINPHA.MTDrawSort.SqlDbDrawSort).SaveOrUpdate("0^98^02^规则2")
ClassMethod SaveOrUpdate(str)
{
	s $ZT="Error^DHCSTERROR"  //增加错误处理
	s ID=$p(str,"^",1)
	s PhLoc=$p(str,"^",2)
	s DSCode=$p(str,"^",3)
	s DSDesc=$p(str,"^",4)
	q:(PhLoc="")||(DSCode="")||(DSDesc="") -1
	q:$d(^DHCPHDWSORTi("Code",DSCode)) -11
	q:$d(^DHCPHDWSORTi("Desc",DSDesc)) -12
	TStart
	i +ID=0 
	{ 
		s obj=##class(User.DHCPHDrawSort).%New()
		s obj.PHDWSPHLocDr=##class(User.CTLoc).%OpenId(PhLoc,0)
	}else{
		s obj=##class(User.DHCPHDrawSort).%OpenId(ID)
		d obj.%Reload()
	}

	s obj.PHDWSCode=DSCode
	s obj.PHDWSDesc=DSDesc
	s sc=obj.%Save()
	i $$$ISERR(sc) TRollback
	i $$$ISERR(sc) q -2  
	TCOMMIT 
	q 0
}

/// Description:保存或者更新备药规则明细信息
/// Creator:	hulihua
/// CreateDate:	2016-10-14
/// Table:      DHC_PHDrawSort、DHC_PHDrawSortItm、INC_StkBin
/// Input:		备药规则主表ID^备药规则明细ID^SN^货位码ID
/// Output:
/// Return：    0,成功
/// 			-2,	操作表失败
/// w ##class(web.DHCINPHA.MTDrawSort.SqlDbDrawSort).SaveOrUpdateDeatil("4^^2^9")
ClassMethod SaveOrUpdateDeatil(str)
{
	s ID=$p(str,"^",1)
	s DSiId=$p(str,"^",2)
	s DSiSN=$p(str,"^",3)
	s DSiSBId=$p(str,"^",4)
	s $ZT="Error^DHCSTERROR"                        //增加错误处理
	i DSiId="" 
	{ 
		s obj=##class(User.DHCPHDrawSortItm).%New(ID)
		d obj.PHDWSIPHDWSParrefSetObjectId(ID)
	}else{
		s obj=##class(User.DHCPHDrawSortItm).%OpenId(DSiId)
		d obj.%Reload()
	}
	s obj.PHDWSISN=DSiSN
	s obj.PHDWSIIncsbDr=##class(User.INCStkBin).%OpenId(DSiSBId,0)
	s sc=obj.%Save()
	i $$$ISERR(sc) q -2   
	q 0
}

/// Description:删除备药排序规则记录
/// Creator:	hulihua
/// CreateDate:	2016-10-14
/// Table:      DHC_PHDrawSort
/// Input:
/// Output:
/// Return：    成功:0, 失败:非0
/// w ##class(web.DHCINPHA.MTDrawSort.DrawSortQuery).Delete("1")
ClassMethod Delete(Id) As %Integer
{
	n (Id)
	q:+Id=0 -1
    q:'$d(^DHCPHDWSORT(Id)) -2
    s Err=0
    s $ZT="Error^DHCSTERROR"                        //增加错误处理
	s obj=##class(User.DHCPHDrawSort).%DeleteId(Id)
	q 0
}

}

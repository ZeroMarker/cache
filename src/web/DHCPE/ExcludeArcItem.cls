/// 名称: 排斥项目
/// 编写者：xy
/// 编写日期: 2021-03-18
Class web.DHCPE.ExcludeArcItem Extends %RegisteredObject
{

/// Description: 是否存在排斥项目
/// Table：排斥项目表 DHC_PE_ExcludeArcItem
/// Input: ARCIMID(项目ID), EXARCIMID(排斥项目ID)
/// Return：
/// Creator：xy 
/// CreatDate：20210318
/// debug:w ##class(web.DHCPE.ExcludeArcItem).IsExcludeArcItem("3130||1","3646||1")
ClassMethod IsExcludeArcItem(ARCIMID As %Library.String = "", EXARCIMID As %Library.String = "")
{
	k ^tempdhcpe("IsExcludeArcItem")
	s ^tempdhcpe("IsExcludeArcItem")=ARCIMID_"^"_EXARCIMID
	s flag=0
	s id=0
    f  s id=$O(^User.DHCPEExcludeArcItemI("EAArcItemIndex",ARCIMID,id)) q:(id="")||(flag=1)  d
    .s ExArcItemDR=$LG($G(^User.DHCPEExcludeArcItemD(id)),3)
    .i ExArcItemDR=EXARCIMID s flag=1
    Q:flag=1 flag
   	s id=0
    f  s id=$O(^User.DHCPEExcludeArcItemI("EAExArcItemIndex",ARCIMID,id)) q:(id="")||(flag=1)  d
    .s ArcItemDR=$LG($G(^User.DHCPEExcludeArcItemD(id)),2)
    .i ArcItemDR=EXARCIMID s flag=1
    q flag
}

/// Description: 保存排斥项目
/// Table：排斥项目表 DHC_PE_ExcludeArcItem
/// Input: ID(数据ID), ARCIMID(项目ID),EXARCIMID(排斥项目ID)
/// Return：
/// Creator：xy 
/// CreatDate：20210318
/// debug:w ##class(web.DHCPE.ExcludeArcItem).SaveExcludeArcItem()
ClassMethod SaveExcludeArcItem(ID As %Library.String = "", ARCIMID As %Library.String = "", EXARCIMID As %Library.String = "")
{
	q:ARCIMID="" ""
	q:EXARCIMID="" ""
	if ID="" d
	.s obj=##class(User.DHCPEExcludeArcItem).%New()
	e  d
	.s obj=##class(User.DHCPEExcludeArcItem).%OpenId(ID)
	
	d obj.EAArcItemDRSetObjectId(ARCIMID)
	d obj.EAExArcItemDRSetObjectId(EXARCIMID)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

/// Description: 删除排斥项目
/// Table：排斥项目表 DHC_PE_ExcludeArcItem
/// Input: ID（数据ID）
/// Return：
/// Creator：xy 
/// CreatDate：20210318
/// debug:w ##class(web.DHCPE.ExcludeArcItem).DeleteExcludeArcItem()
ClassMethod DeleteExcludeArcItem(ID)
{
	s obj=##class(User.DHCPEExcludeArcItem).%New()
	s sc=obj.%DeleteId(ID)
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

/// Description: 查询排斥项目
/// Table：排斥项目表 DHC_PE_ExcludeArcItem
/// Creator：xy 
/// CreatDate：20210318
/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.ExcludeArcItem","FindExcludeArcItem","3130||1")
Query FindExcludeArcItem(ARCIMID As %Library.String = "") As websys.Query(ROWSPEC = "id:%String,ArcItemDR:%String,ArcItemDesc:%String,ExArcItemDR:%String,ExArcItemDesc:%String")
{
}

ClassMethod FindExcludeArcItemExecute(ByRef qHandle As %Binary, ARCIMID As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    if (ARCIMID=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
    
    s id=0
    f  s id=$O(^User.DHCPEExcludeArcItemI("EAArcItemIndex",ARCIMID,id)) q:id=""  d
    .s ArcItemDR=$LG($G(^User.DHCPEExcludeArcItemD(id)),2)
    .s ArcItemDRDesc="" 
    .i ArcItemDR'="" s ArcItemDRDesc=$p($g(^ARCIM($p(ArcItemDR,"||",1),$p(ArcItemDR,"||",2),1)),"^",2)
    .s ExArcItemDR=$LG($G(^User.DHCPEExcludeArcItemD(id)),3)
    .s ExArcItemDRDesc="" 
    .i ExArcItemDR'="" s ExArcItemDRDesc=$p($g(^ARCIM($p(ExArcItemDR,"||",1),$p(ExArcItemDR,"||",2),1)),"^",2)
    .s ^CacheTemp(repid,ind)=$lb(id,ArcItemDR,ArcItemDRDesc,ExArcItemDR,ExArcItemDRDesc)
    .s ind=ind+1
   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

}

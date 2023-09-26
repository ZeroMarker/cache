Class web.DHCPRESCLocTemp Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function:输出所有模板
/// Creator: huanghongping
/// CreateDate: 2021/9/24
/// Table: CF_PHA_PREADT.CtlocTemp
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCPRESCLocTemp","GetAllTemplate","","")
Query GetAllTemplate(SearchStr As %String, ActiveFlag As %String) As websys.Query(ROWSPEC = "RowID:%String,PLTCode:%String,PLTDesc:%String,PLTFlag:%String")
{
}

ClassMethod GetAllTemplateExecute(ByRef qHandle As %Binary, SearchStr As %String, ActiveFlag As %String) As %Status
{
	n (qHandle,SearchStr,ActiveFlag)
	s repid=$i(^CacheTemp)
    s ind=1
    ///代码开始
	s RowID=""
	f
	{
		s RowID=$o(^CF.PHA.PREADT.CtlocTempD(RowID),-1) q:RowID=""
		s PLTCode=$lg(^CF.PHA.PREADT.CtlocTempD(RowID),2)    //模板代码
		s PLTDesc=$lg(^CF.PHA.PREADT.CtlocTempD(RowID),3)	//模板名称
		i ((PLTCode'[SearchStr)&(PLTDesc'[SearchStr))
		{
			continue	
		}
		s PLTFlag=$lg(^CF.PHA.PREADT.CtlocTempD(RowID),4)
		i ((PLTFlag'=ActiveFlag)&(ActiveFlag'=""))
		{
			continue	
		}
		s:PLTFlag="Y" PLTFlag="是"	//模板是否激活
		s:PLTFlag="N" PLTFlag="否"
		d OutputRow		
	}
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s Data=$lb(RowID,PLTCode,PLTDesc,PLTFlag)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

/// Function:输出所有关联科室
/// Creator: huanghongping
/// CreateDate: 2021/9/24
/// Table: CF_PHA_PREADT.LocTempLink
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCPRESCLocTemp","GetAllPLCtLoc","1")
Query GetAllPLCtLoc(mID As %String) As websys.Query(ROWSPEC = "LocCode:%String,LocName:%String,ID:%String")
{
}

ClassMethod GetAllPLCtLocExecute(ByRef qHandle As %Binary, mID As %String) As %Status
{
	n (mID,qHandle)
	s repid=$i(^CacheTemp)
    s ind=1
    ///代码开始
    q:mID=""
	s ID=""
	f
	{
		s ID=$o(^CF.PHA.PREADT.LocTempLinkI("PTLItemDRIndex",mID,ID),-1) q:ID=""
		s PTLLocDr=$lg(^CF.PHA.PREADT.LocTempLinkD(ID),3)
		s LocCode=$p(^CTLOC(PTLLocDr),"^",1)
		s LocName=$p(^CTLOC(PTLLocDr),"^",2)
		d OutputLink	
	}
	
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutputLink
	s Data=$lb(LocCode,LocName,ID)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

/// Function:保存模板
/// Creator: huanghongping
/// CreateDate: 2021/9/24
/// Table: CF_PHA_PREADT.CtlocTemp
/// Debug:
ClassMethod TemplateSave(mParam)
{
	n (mParam)
	s Err=0
	f i=1:1:$L(mParam,"$$") 
	{
		q:Err'=0
		s mData=$p(mParam,"$$",i)
		s Err=..isExist(mData)                                                // 重复性判断
		q:Err'=0
		s Err=$case($p(mData,"^",1),"":..InsertTemplate(mData),:..UpdateTemplate(mData))	  //主键ID不存在就插入，存在就修改	
	}
	q Err
}

/// Creator: 		huanghongping
/// CreateDate: 	2021-09-24
/// 判断模板表代码是否重复
/// Table: CF_PHA_PREADT.CtlocTemp
/// Others:^CF.PHA.PREADT.CtlocTempI("PLTCodeIndex","hhgfhg",4)=""
/// Debug: w ##class(web.DHCPRESCLocTemp).isExist("2^HHPPTl^黄红平模板^Y")
ClassMethod isExist(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)
	s PLTCode=$p(mParam,"^",2)
	s PLTDesc=$p(mParam,"^",3)
	s PLTFlag=$p(mParam,"^",4)
	/// 新记录
	q:(ID="")&($d(^CF.PHA.PREADT.CtlocTempI("PLTCodeIndex",PLTCode))) "-1" //代码重复
	q:(ID="")&($d(^CF.PHA.PREADT.CtlocTempI("PLTDescIndex",PLTDesc))) "-2" //名字重复
	
	/// 修改记录
	q:ID="" 0
	s TepCode=$lg(^CF.PHA.PREADT.CtlocTempD(ID),2)
	q:(TepCode'=PLTCode)&($d(^CF.PHA.PREADT.CtlocTempI("PLTCodeIndex",PLTCode))) "-1" //代买重复
	s TepDesc=$lg(^CF.PHA.PREADT.CtlocTempD(ID),3)
	q:(TepDesc'=PLTDesc)&($d(^CF.PHA.PREADT.CtlocTempI("PLTDescIndex",PLTDesc))) "-2" //名字重复
	q 0
}

/// Creator: 		huanghongping
/// CreateDate: 	2021-09-25
/// 插入模板
/// Others:^CF.PHA.PREADT.CtlocTempI("PLTCodeIndex","hhgfhg",4)=""
/// Table: CF_PHA_PREADT.CtlocTemp
/// Debug: w ##class(web.DHCPRESCLocTemp).InsertTemplate("^HHPPTl^黄红平模板^Y")
ClassMethod InsertTemplate(mParam)
{
	n (mParam)
	s PLTCode=$p(mParam,"^",2)
	s PLTDesc=$p(mParam,"^",3)
	s PLTFlag=$p(mParam,"^",4)
	ts
	&SQL(INSERT INTO SQLUser.CF_PHA_PREADT.CtlocTemp ( PLT_Code, PLT_Desc, PLT_Flag)
VALUES ( :PLTCode,:PLTDesc,:PLTFlag)) 
	i (SQLCODE=0)
	{
	 tc   
    }
    else
    {
	 tro   
    }
    q SQLCODE
}

/// Creator: 		huanghongping
/// CreateDate: 	2021-09-25
/// 修改模板
/// Others:^CF.PHA.PREADT.CtlocTempI("PLTCodeIndex","hhgfhg",4)=""
/// Table: CF_PHA_PREADT.CtlocTemp
/// Debug: w ##class(web.DHCPRESCLocTemp).UpdateTemplate("2^HHPPTl^黄红平模板^Y")
ClassMethod UpdateTemplate(mParam)
{
	n (mParam)
	s ID=$p(mParam,"^",1)
	s PLTCode=$p(mParam,"^",2)
	s PLTDesc=$p(mParam,"^",3)
	s PLTFlag=$p(mParam,"^",4)
	ts
	&SQL(UPDATE SQLUser.CF_PHA_PREADT.CtlocTemp
	SET
	PLT_Code = :PLTCode,
	PLT_Desc = :PLTDesc,
	PLT_Flag = :PLTFlag
	WHERE
 	PLT_RowID = :ID)
 	i (SQLCODE=0)
	{
	 	tc   
    }
    else
    {
	 	tro   
    }
    q SQLCODE
}

/// Creator: 		huanghongping
/// CreateDate: 	2021-09-25
/// 删除模板
/// Others:^CF.PHA.PREADT.CtlocTempI("PLTCodeIndex","hhgfhg",4)=""
/// Table: CF_PHA_PREADT.CtlocTemp
/// Debug: w ##class(web.DHCPRESCLocTemp).DeleteTemplate("3")
ClassMethod DeleteTemplate(ID)
{
	n (ID)
    
    s Flag=..DeleteTemplateCtloc(ID)
    i ((Flag=0)||(Flag=100))
    {
		ts
		&SQL(DELETE From SQLUser.CF_PHA_PREADT.CtlocTemp WHERE PLT_RowID =:ID)
    	i (SQLCODE=0)
    	{
			tc	
		}
		else
		{
			tro	
		}	    
	}
    
 	q SQLCODE
}

/// Creator: 		huanghongping
/// CreateDate: 	2021-09-25
/// 删除模板的关联科室
/// Others:^CF.PHA.PREADT.CtlocTempI("PLTCodeIndex","hhgfhg",4)=""
/// Table: CF_PHA_PREADT.CtlocTemp
/// Debug: w ##class(web.DHCPRESCLocTemp).DeleteTemplateCtloc("3")
ClassMethod DeleteTemplateCtloc(ID)
{
	n (ID)
	ts
	&SQL(DELETE FROM SQLUser.CF_PHA_PREADT.LocTempLink WHERE PTL_Item_DR=:ID)
	i (SQLCODE=0)
	{
		tc
		
	}
	else{
		tro	
	}
	q SQLCODE
}

/// Creator: 		huanghongping
/// CreateDate: 	2021-09-25
/// 保存关联科室
/// Others:$o(^CTLOC(0,"Desc","天","")) ^CF.PHA.PREADT.LocTempLinkI("PTLCTlocIndex",16,105,69)
/// Table: CF_PHA_PREADT.LocTempLink
/// Debug: w ##class(web.DHCPRESCLocTemp).SaveTempCtloc("11",^jghl)
ClassMethod SaveTempCtloc(mID, mParam)
{
	n (mID,mParam)
	s Err="0"
 //	ts
	f i=1:1:$l(mParam,"$$")
	{
		s mData=$p(mParam,"$$",i)
		s Err=..isCTlocExist(mID,mData)                                                // 重复性判断
		q:Err'=0
 //		s $zt="Error"
		s Err=$case($p(mData,"^",2),"":..InsertCtloc(mID,mData),:..UpdateCtloc(mID,mData))	  //主键ID不存在就插入，存在就修改	
 //		tc
		
	}
	q Err
 // Error 
 //		tro
 // 	q $ze
 //
}

/// Creator: 		huanghongping
/// CreateDate: 	2021-09-25
/// 删除关联科室
/// Others:$o(^CTLOC(0,"Desc","天",""))
/// Table: CF_PHA_PREADT.LocTempLink
/// Debug: w ##class(web.DHCPRESCLocTemp).SaveTempCtloc("7^")
ClassMethod DeleteTempCtloc(ID)
{
	n (ID)
	q:ID="" "0"
	ts
	&SQL(DELETE FROM SQLUser.CF_PHA_PREADT.LocTempLink WHERE ID=:ID)
	i (SQLCODE=0)
	{
		tc
		q "0"	
	}
	else
	{
		tro
		q "-1"	
	}
}

/// Creator: 		huanghongping
/// CreateDate: 	2021-09-24
/// 判断模板关联科室是否重复
/// Table: CF_PHA_PREADT.CtlocTemp
/// Others:^CF.PHA.PREADT.CtlocTempI("PLTCodeIndex","hhgfhg",4)=""
/// Debug: w ##class(web.DHCPRESCLocTemp).isCTlocExist("14","呼吸内科^""")
ClassMethod isCTlocExist(mID, mData)
{
	s LocName=$p(mData,"^",1)
	s LocName=$$ALPHAUP^SSUTIL4(LocName)
	q:LocName="" "-2"   //输入为空
	s LocID=$o(^CTLOC(0,"Desc",LocName,""))
	q:LocID="" "-3"     //科室不存在
	
	//$$ALPHAUP({CTLOC_Desc})
	s ID=$p(mData,"^",2)
	/// 新记录
	q:(ID="")&($d(^CF.PHA.PREADT.LocTempLinkI("PTLCTlocIndex",mID,LocID))) "-1" //科室重复

	
	/// 修改记录
	q:ID="" 0
	s TepID=$lg(^CF.PHA.PREADT.LocTempLinkD(ID),3)
	q:(TepID'=LocID)&($d(^CF.PHA.PREADT.LocTempLinkI("PTLCTlocIndex",mID,LocID))) "-1" //科室重复
	q 0
}

/// Creator: 		huanghongping
/// CreateDate: 	2021-09-25
/// 关联科室插入
/// Others: $$ALPHAUP^SSUTIL4("急诊ICU[分院]")
/// Debug: 	w ##class(web.DHCPRESCLocTemp).InsertCtloc()
ClassMethod InsertCtloc(mID, mData)
{
	s LocName=$p(mData,"^",1)
	s LocName=$$ALPHAUP^SSUTIL4(LocName)       //去掉特殊字符
	s LocID=$o(^CTLOC(0,"Desc",LocName,""))
	ts
	&SQL(INSERT INTO SQLUser.CF_PHA_PREADT.LocTempLink (PTL_Item_DR, PTL_Loc_DR)
			VALUES ( :mID, :LocID))
	i (SQLCODE=0)
	{
		tc	
	}
	else
	{
		tro	
	}
	q SQLCODE
}

/// 关联科室修改
/// Creator: 		huanghongping
/// CreateDate: 	2021-09-29
/// Others: $$ALPHAUP^SSUTIL4("急诊ICU[分院]")
ClassMethod UpdateCtloc(mID, mData)
{
	s LocName=$p(mData,"^",1)
	s LocName=$$ALPHAUP^SSUTIL4(LocName)    //去掉[分院]的中括号
	s LocID=$o(^CTLOC(0,"Desc",LocName,""))
	s ItemID=$p(mData,"^",2)
	ts
	&SQL(UPDATE SQLUser.CF_PHA_PREADT.LocTempLink
					SET 
						PTL_Item_DR = :mID,
						PTL_Loc_DR = :LocID

					WHERE ID =:ItemID)
	i (SQLCODE=0)
	{
		tc	
	}
	else
	{
		tro	
	}
	
    q SQLCODE
}

}

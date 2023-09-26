Class web.DHCEQCBenefitItem Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 新增分析项目信息
ClassMethod CreateDHCEQCBenefitItem(DHCEQCBenefitItemInfo) As %String
{
	n BIRowID,BICode,BIDesc,BIMinScore,BIMaxScore,BIRemark,BIInvalidFlag
	s BIRowID=$p(DHCEQCBenefitItemInfo,"^",1)
	s BICode=$p(DHCEQCBenefitItemInfo,"^",2)
	s BIDesc=$p(DHCEQCBenefitItemInfo,"^",3)
	s BIMinScore=$p(DHCEQCBenefitItemInfo,"^",4)
	s BIMaxScore=$p(DHCEQCBenefitItemInfo,"^",5)
	s BIRemark=$p(DHCEQCBenefitItemInfo,"^",6)
	s BIInvalidFlag=$p(DHCEQCBenefitItemInfo,"^",7)
	;避免插入重复数据
	&SQL(select BI_RowID  into :RowIDFind from SQLUser.DHC_EQCBenefitItem where BI_Code=:BICode)
	if (RowIDFind="")
	{&SQL(Insert into SQLUser.DHC_EQCBenefitItem(BI_Code,BI_Desc,BI_MinScore,BI_MaxScore,BI_Remark,BI_InvalidFlag)
		values(:BICode,:BIDesc,:BIMinScore,:BIMaxScore,:BIRemark,:BIInvalidFlag))
		if SQLCODE=0
		{
			q "新增成功,ROWID:"_%ROWID
		}else{
			q "新增失败，SQLCODE:"_SQLCODE
		}
	}
	else 
	{
		q "该数据已存在！"
		
	}
}

/// 更新分析项目信息
/// DHCEQCBenefitItemInfo="BIRowID_^_BICode_^BIDesc_^_BIMinScore_^_BIMaxScore_^_BIRemark_^_BIInvalidFlag"
/// s DHCEQCBenefitItemInfo="3^003^设备003^60^99^测试003^Y"
/// w ##class(web.DHCEQCBenefitItem).SaveDHCEQCBenefitItem(DHCEQCBenefitItemInfo)
ClassMethod UpdateDHCEQCBenefitItem(DHCEQCBenefitItemInfo) As %String
{
	n BIRowID,BICode,BIDesc,BIMinScore,BIMaxScore,BIRemark,BIInvalidFlag
	s BIRowID=$p(DHCEQCBenefitItemInfo,"^",1)
	s BICode=$p(DHCEQCBenefitItemInfo,"^",2)
	s BIDesc=$p(DHCEQCBenefitItemInfo,"^",3)
	s BIMinScore=$p(DHCEQCBenefitItemInfo,"^",4)
	s BIMaxScore=$p(DHCEQCBenefitItemInfo,"^",5)
	s BIRemark=$p(DHCEQCBenefitItemInfo,"^",6)
	s BIInvalidFlag=$p(DHCEQCBenefitItemInfo,"^",7)
		
	&SQL(update SQLUser.DHC_EQCBenefitItem
		Set BI_Code = :BICode,
		BI_Desc = :BIDesc,
		BI_MinScore = :BIMinScore,
		BI_MaxScore = :BIMaxScore,
		BI_Remark = :BIRemark,
		BI_InvalidFlag = :BIInvalidFlag
		Where BI_RowID =:BIRowID)
			
		if SQLCODE=0{
			q "更新成功,RowID:"_%ROWID
		}else{
			q "更新失败"
		}
}

/// 删除分析项目信息
ClassMethod DeleteDHCEQCBenefitItem(BIRowID)
{
	&sql(delete from SQLUser.DHC_EQCBenefitItem Where BI_RowID=:BIRowID)
	if SQLCODE=0{
		q "删除成功,RowID:"_%ROWID
	}else{
		q "删除失败，SQLCODE:"_SQLCODE
	}
}

/// Add by CSJ 2017-08-23
/// 描述：根据分析项目代码和功能名称查找分析项目表信息
/// 入参：VarBICode：分析项目代码，VarBIDesc：功能名称
/// d ##class(%ResultSet).RunQuery("web.DHCEQCBenefitItem","GetDHCEQCBenefitItem","")
Query GetDHCEQCBenefitItem(VarBICode As %String = "", VarBIDesc As %String = "") As %Query(ROWSPEC = "BIRowID:%String,BICode:%String,BIDesc:%String,BIMinScore:%String,BIMaxScore:%String,BIRemark:%String,BIInvalidFlag:%String")
{
}

ClassMethod GetDHCEQCBenefitItemExecute(ByRef qHandle As %Binary, VarBICode As %String = "", VarBIDesc As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	//if $g(VarBICode)'="" d
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCBenefitItem",rowid))  quit:rowid=""  d
	.s DHCEQCBenefitItemInfo=^DHCEQCCode("DHCEQCBenefitItem",rowid)
	.s BIRowID=rowid
	.s BICode=$p(DHCEQCBenefitItemInfo,"^",1)
	.q:(VarBICode'=BICode)&&(VarBICode'="") //VarBICode为空查询全部，VarBICode则查询该条记录
	.s BIDesc=$p(DHCEQCBenefitItemInfo,"^",2)
	.q:(VarBIDesc'=BIDesc)&&(VarBIDesc'="") //VarBIDesc为空查询全部，VarBIDesc则查询该条记录
	.s BIMinScore=$p(DHCEQCBenefitItemInfo,"^",3)
	.s BIMaxScore=$p(DHCEQCBenefitItemInfo,"^",4)
	.s BIRemark=$p(DHCEQCBenefitItemInfo,"^",5)
	.s BIInvalidFlag=$p(DHCEQCBenefitItemInfo,"^",6)
	.d OutputRowGetDHCEQCBenefitItem
	Quit $$$OK
	
OutputRowGetDHCEQCBenefitItem
	s Data=$lb(BIRowID,BICode,BIDesc,BIMinScore,BIMaxScore,BIRemark,BIInvalidFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetDHCEQCBenefitItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDHCEQCBenefitItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDHCEQCBenefitItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDHCEQCBenefitItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*
/// 无效标记下拉菜单方式
ClassMethod CreateCbo(name, width) As %String
{
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value='Y'>有效</option>"
	w "<option value='N'>无效</option>"
	w "</select>",!
}
*/
}

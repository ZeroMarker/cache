/// Description：HIS-Location与HR-组织关联关系表 导入
/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-07-27
Class web.BDPExt.CTDepartmentLocationBLL Extends %RegisteredObject
{

/// Description：HIS-Location与HR-组织关联关系表 导入保存方法
/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-07-28
/// Table: User.CTDepartmentLocation
ClassMethod SaveEntity(Ceobj As web.BDPExt.CTDepartmentLocationEntity) As %String
{
	s result=""
	if $IsObject(Ceobj)
	{
		s:Ceobj.DEPRowId'="" Ceobj.DEPLDeptDR=$o(^User.CTDepartmentI("DEPRowIdRef",Ceobj.DEPRowId,0))
		if (Ceobj.DEPLLocSource="CT_Loc")
		{
			s:Ceobj.DEPLLocCode'="" Ceobj.DEPLLocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.DEPLLocCode),0))
		}
		if (Ceobj.DEPLParentLocSource="CT_Loc")
		{
			s:Ceobj.DEPLParentLocCode'="" Ceobj.DEPLParentLocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.DEPLParentLocCode),0))
		}
		s flag=##class(web.DHCBL.CT.CTDepartmentLocation).FormValidate("",Ceobj.DEPLDeptDR,Ceobj.DEPLLocSource,Ceobj.DEPLLocID,Ceobj.DEPLLocCode)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			s obj=##class(User.CTDepartmentLocation).%New()
			d obj.DEPLDeptDRSetObjectId(Ceobj.DEPLDeptDR)			//HR组织部门表id
			s obj.DEPLLocSource=Ceobj.DEPLLocSource			//Location来源
			if (Ceobj.DEPLLocSource="CT_Loc")
			{
				s obj.DEPLLocID=Ceobj.DEPLLocID			//Location rowid
			}
			else
			{
				s obj.DEPLLocCode=Ceobj.DEPLLocCode		//Location代码
				s obj.DEPLLocDesc=Ceobj.DEPLLocDesc		//Location名称
			}
			s obj.DEPLParentLocSource=Ceobj.DEPLParentLocSource		//上级Location来源
			if (Ceobj.DEPLParentLocSource="CT_Loc")
			{
				s obj.DEPLParentLocID=Ceobj.DEPLParentLocID			//上级Location rowid
			}
			else
			{
				s obj.DEPLParentLocCode=Ceobj.DEPLParentLocCode		//上级Location代码
				s obj.DEPLParentLocDesc=Ceobj.DEPLParentLocDesc		//上级Location名称
			}
			if (Ceobj.DEPLLocSource'="CT_Loc")		//非CT_Loc表的数据才保存日期
			{
				s obj.DEPLDateFrom=+$h	//开始日期
			}
			TS
			s sc=obj.%Save()
			if (sc=1)
			{
				TC
				s id=obj.%Id()
				s result="{success:'true',id:'"_id_"'}"
				
				//推送ID到MDM
				d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptLinkOrg).SendCTDeptLinkOrg(id)
				
				d:Ceobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_DepartmentLocation","User.CTDepartmentLocation","HIS-Location与HR-组织关联关系",Ceobj.ID,Ceobj.DEPDesc,"U",Ceobj,bobj)
				d:Ceobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_DepartmentLocation","User.CTDepartmentLocation","HIS-Location与HR-组织关联关系",id,Ceobj.DEPDesc,"A",Ceobj)
			}
			else
			{
				TRO
				s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			}
		}
	}
	else
	{
		s result= "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

}

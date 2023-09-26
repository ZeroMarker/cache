/// 创建者：李阳
/// 创建日期：2011-07-06
/// 功能：准备数据之用
Class DHCMed.EPDService.PrepareData Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 保存传染病字典信息
/// 参数：
/// Main：DHCMed.EPD.Infection表中的数据
/// Alias:DHCMed.EPD.InfectionAlias表中的数据，用$c(1)分割
/// 返回值：新生成DHCMed.EPD.Infection的ID值
ClassMethod SaveInfectionData(Main, Alias) As %String
{
	n (Main, Alias)	
	TStart
	Set MainID=##class(DHCMed.EPD.Infection).Update(Main, "^")
	For i=1:1:$l(Alias,$c(1))
	{
		Set row=$p(Alias,$c(1))
		If (row'="")
		{
			Set $p(row,"^",1)=MainID
			Set AliasID=##class(DHCMed.EPD.InfectionAlias).Update(row)
		}
	}
	Quit MainID
}

ClassMethod KillAllInfection()
{
	Kill ^DHCMed.EPDC
	Kill ^DHCMed.EPDCi
	Quit "OK"
}

/// w ##class(DHCMed.EPDService.PrepareData).InitMenuItems()
ClassMethod InitMenuItems()
{
		w "************初始化传染病菜单*************",!
		//1:Rowid 2:ProCode 3:ProName 4:ProVersion 5:IconClass 6:ShowIndex 7:ProActive 8:ProResume
		Set IsActive="",ProID=""
		For {
			Set IsActive=$o(^DHCMed.SS.ProductsI("ProductActive","EPD",IsActive))
			Quit:IsActive=""
			Set ProID=$o(^DHCMed.SS.ProductsI("ProductActive","EPD",IsActive,0))
		}
		//Todo：增加图标
		If ProID="" {
			Set InputStr="^EPD^传染病管理系统^v3.2.1^icon-epidemic^3^1^"
			set id=##class(DHCMed.SS.Products).Update(InputStr)
		}Else{
			Set InputStr=ProID_"^EPD^传染病管理系统^v3.2.1^icon-epidemic^3^1^"
			set id=##class(DHCMed.SS.Products).Update(InputStr)
		}
		
		m ^DHCMed.SS.MenusDTMP=^DHCMed.SS.MenusD
		m ^DHCMed.SS.MenusITMP=^DHCMed.SS.MenusI
		&SQL(DELETE FROM DHCMed_SS.Menus WHERE ProductDr=:ProID)
		
		//1:Rowid 2:MenuCode 3:MenuCaption 4:LinkUrl 5:Expression 6:ProductDr 7:ShowIndex 8:IconClass 9:ParentMenuDr
		set mid=##class(DHCMed.SS.Menus).Update("^EpdBaseDic^传染病字典维护^^^"_id_"^1^icon-menu^")
		set mnuid=##class(DHCMed.SS.Menus).Update("^EpdReport^传染病字典维护^dhcmed.epd.infectionmanage.csp^^"_id_"^101^icon-menu^"_mid)
		set mnuid=##class(DHCMed.SS.Menus).Update("^EpdAppendixManage1^传染病附卡维护^dhcmed.epd.appendixmanage.csp^^"_id_"^102^icon-menu^"_mid)
		
		set mid=##class(DHCMed.SS.Menus).Update("^EpdStat^查询统计^^^"_id_"^2^icon-menu^")
		set mnuid=##class(DHCMed.SS.Menus).Update("^EpdStaByDateLoc1^传染病报告查询^dhcmed.epd.querybydateloc.csp^&LocFlag=1^"_id_"^201^icon-menu^"_mid)
		set mnuid=##class(DHCMed.SS.Menus).Update("^EpdQryByDate1^传染病统计^dhcmed.epd.stabydateloc.csp^^"_id_"^202^icon-menu^"_mid)
		set mnuid=##class(DHCMed.SS.Menus).Update("^EpdOPStat^门诊传染病统计^dhcmed.epd.opepdsta.csp^^"_id_"^203^icon-menu^"_mid)
		set mnuid=##class(DHCMed.SS.Menus).Update("^OPDOCLog^门诊日志^websys.default.csp^&WEBSYS.TCOMPONENT=DHCOPDOCLog^"_id_"^204^icon-menu^"_mid)

		set mid=##class(DHCMed.SS.Menus).Update("^EpdCtrl^监控平台^^^"_id_"^3^icon-menu^")
		set mnuid=##class(DHCMed.SS.Menus).Update("^EpdControl^传染病监控^dhcmed.cc.ctrl.epidemic.csp^&SubjectID=3&LocFlag=1^"_id_"^301^icon-menu^"_mid)
		
		
		
		w "菜单初始化完毕！",!
		q "OK"
}

ClassMethod CreateConfig()
{
}

/// w ##class(DHCMed.EPDService.PrepareData).InitData()
ClassMethod InitData()
{
	w "启动变异 DHCMed.EPD 包...",!
	d $System.OBJ.CompilePackage("DHCMed.EPD")
	d $System.OBJ.CompilePackage("DHCMed.EPDService")
	d $System.OBJ.CompilePackage("DHCMed.SS")
	d $System.OBJ.CompilePackage("DHCMed.SSService")
	W "编译完成",!
	
	
	w "开始重新生成索引...",!
	s arrarylistcls=""
    s clsname="",clspath=""
	w $system.OBJ.GetPackageList(.arrarylistcls,"DHCMed.EPD")
	s clskey=""
	f  s clskey=$o(arrarylistcls(clskey)) q:clskey=""  d
	.s cdef = ##class(%Dictionary.ClassDefinition).%OpenId(clskey)
	.d cdef.%Close()
	.Quit:cdef.Super'["%Persistent"
	.Kill cdef
	.w "处理："_clskey_"..."
	.w "返回值："_$ZOBJCLASSMETHOD(clskey,"%BuildIndices"),!

	s arrarylistcls=""
    s clsname="",clspath=""
	w $system.OBJ.GetPackageList(.arrarylistcls,"DHCMed.SS")
	s clskey=""
	f  s clskey=$o(arrarylistcls(clskey)) q:clskey=""  d
	.s cdef = ##class(%Dictionary.ClassDefinition).%OpenId(clskey)
	.d cdef.%Close()
	.Quit:cdef.Super'["%Persistent"
	.Kill cdef	
	.w "处理："_clskey_"..."
	.w "返回值："_$ZOBJCLASSMETHOD(clskey,"%BuildIndices"),!



	Quit "OK"
}

}

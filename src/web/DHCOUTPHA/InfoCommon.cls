Import sqluser

/// creator:yunhaibao
/// createdate:20160501
/// descirpiton:门诊药房获取科室等下拉信息的类
Class web.DHCOUTPHA.InfoCommon Extends %RegisteredObject [ ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:20160429
/// descirpiton:获取门诊药房配药人下拉集合
/// flag是为了区分配药人和发药人下拉列表的内容
/// w ##class(web.DHCOUTPHA.InfoCommon).jsGetPYUserList(100,578,"selec2","")
ClassMethod jsGetPYUserList(locid, userid, style = "", combotext = "", flag)
{
	s result=##class(%Library.ResultSet).%New("web.DHCPhQueryTotal:QueryChFy")
	s sc=result.Execute(locid,userid,flag)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	i style="select2" s colNameStr="id^text"
	e  s colNameStr="RowId^Desc"
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		s rowid=result.%GetData(2)
		s description=result.%GetData(1)
		s descpy=##class(web.DHCST.Common.AppCommon).GetCNCODE(description)
		continue:(combotext'="")&&($zcvt(descpy,"U")'[$zcvt(combotext,"U"))
		s ret=rowid_"^"_description
		s countrecords=countrecords+1
		I countrecords=1 d
		.w "["
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

/// creator:yunhaibao
/// createdate:20160425
/// descirpiton:获取门诊药房发药窗口集合
/// w ##class(web.DHCOUTPHA.InfoCommon).jsGetFYWinList(100)
ClassMethod jsGetFYWinList(locid, ChkRelFlag, style = "")
{
	s result=##class(%Library.ResultSet).%New("PHA.OP.DispWinCf.Query:QueryChWin")
	s sc=result.Execute(locid,ChkRelFlag)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	i style="select2" s colNameStr="id^text"
	e  s colNameStr="RowId^Desc"
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		s ret=result.%GetData(2)_"^"_result.%GetData(1)
		s countrecords=countrecords+1
		I countrecords=1 d
		.w "["
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

/// creator:yunhaibao
/// createdate:20160425
/// descirpiton:获取门诊药房配药窗口列表
/// w ##class(web.DHCOUTPHA.InfoCommon).jsQueryPYWinList(100)
ClassMethod jsQueryPYWinList(locid)
{
	s result=##class(%Library.ResultSet).%New("web.DHCPhQueryTotal:QueryWinDoFlag")
	s sc=result.Execute(locid)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s colNameStr="RowId^Desc"
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		s ret=result.%GetData(2)_"^"_result.%GetData(1)
		s countrecords=countrecords+1
		I countrecords=1 d
		.w "["
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

/// creator:yunhaibao
/// createdate:20160425
/// descirpiton:获取基数药科室集合
/// w ##class(web.DHCOUTPHA.InfoCommon).jsGetBasicLocList("","yk")
ClassMethod jsGetBasicLocList(style = "", combotext = "", HospId As %String = "")
{
	s result=##class(%Library.ResultSet).%New("web.DHCOutPhAddBaseMed:GetPhbLocDs")
	s sc=result.Execute(combotext)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	i style="select2" s colNameStr="id^text"
	e  s colNameStr="RowId^Desc"
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		s rowid=result.%GetData(2)
		s desc=result.%GetData(1)
		s hospDr=$p(^CTLOC(rowid),"^",22)
		continue:(HospId'="")&&(hospDr'="")&&(HospId'=hospDr)
		i desc["-" s desc=$p(desc,"-",2)
		s ret=rowid_"^"_desc
		s countrecords=countrecords+1
		I countrecords=1 d
		.w "["
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

/// creator:yunhaibao
/// createdate:20160425
/// descirpiton:获取急诊留观科室
/// w ##class(web.DHCOUTPHA.InfoCommon).jsGetEMLocList(100)
ClassMethod jsGetEMLocList(style = "", HospId As %String = "")
{
	s result=##class(%Library.ResultSet).%New("web.DHCOutPhCommon:QueryGetLgArea")
	s sc=result.Execute()
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	i style="select2" s colNameStr="id^text"
	e  s colNameStr="RowId^Desc"
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		s ret=result.%GetData(2)_"^"_result.%GetData(1)
		s rowid=result.%GetData(2)
		s hospDr=$p(^CTLOC(rowid),"^",22)
		continue:(HospId'="")&&(hospDr'="")&&(HospId'=hospDr)

		s countrecords=countrecords+1
		I countrecords=1 d
		.w "["
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

/// creator:yunhaibao
/// createdate:20160425
/// descirpiton:获取门诊药房配药窗口
/// w ##class(web.DHCOUTPHA.InfoCommon).jsGetPYWinList(100)
ClassMethod jsGetPYWinList(locid, chkfywflag = "", style = "")
{
	s result=##class(%Library.ResultSet).%New("PHA.OP.PyWinCf.Query:GetPyWin")
	s sc=result.Execute(locid,chkfywflag)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	i style["select2" s colNameStr="id^text"
	e  s colNameStr="RowId^Desc"
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		s ret=result.%GetData(2)_"^"_result.%GetData(1)
		s countrecords=countrecords+1
		I countrecords=1 d
		.w "["
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

/// creator:yunhaibao
/// createdate:20160425
/// descirpiton:获取门诊药房发药窗口
/// w ##class(web.DHCOUTPHA.InfoCommon).jsQueryDispWinList(100)
ClassMethod jsQueryDispWinList(ctloc, ChkRelFlag)
{
	s ^TMPHLH($this,"jsQueryDispWinList")=$lb(ctloc, ChkRelFlag)
	q:ctloc="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNameStr="phwpid^phwid^phwWinDesc^phwWinStat"
	s countrecords=0
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	s phw="0"
	f  s phw=$o(^DHCPHWINi("WIN",phl,phw)) q:phw=""  d
	.s phwp="",phwl=""
	.s phwp=$o(^DHCPHWPi("WINDOW",phl,phw,""))
	.s useflag="",phwdesc="",doflag=""
	.q:phwp=""
	.s doflag=$p(^DHCPHWP(phwp),"^",1)
	.i doflag="1" s doflag="有人" 
	.e  s doflag="无人"
	.q:phw=""
	.s useflag=$p(^DHCPHWIN(phw),"^",4)
	.q:useflag="1"
	.//配发模式下需检查发药窗口是否关联了配药窗口
	.q:(ChkRelFlag=1)&&(##class(PHA.OP.COM.Method).ChkPhwRelPhpw(phw)=0)
	.s phwdesc=$p(^DHCPHWIN(phw),"^",1)
	.s countrecords=countrecords+1
	.s colData=phwp_"^"_phw_"^"_phwdesc_"^"_doflag
	.I countrecords=1 d
	..w "["
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colData)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colData)
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

/// w ##class(web.DHCOUTPHA.InfoCommon).GetDescFromId("","","","")
ClassMethod GetDescFromId(phl As %Library.String = "", pyphw As %Library.String = "", pydr As %Library.String = "", fydr As %Library.String = "", wincode As %Library.String = "", fyphw = "")
{
   s ret="",ctloc="",ctlocdesc="",pyphwdesc="",pyname="",fyname="",winposdesc="",fyphwdesc=""
   i phl'="" s ctloc=+$p(^DHCPHLOC(phl),"^",1)
   i ctloc'="" s ctlocdesc=$p(^CTLOC(ctloc),"^",2)
   i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2)
   i pyphw'="" s pyphwdesc=$p(^DHCPHPY(pyphw),"^",1)
   i fyphw'="" s fyphwdesc=$p(^DHCPHWIN(fyphw),"^",1)
   i pydr'="" s pyname=$p(^DHCPHPER(pydr),"^",2)
   i fydr'="" s fyname=$p(^DHCPHPER(fydr),"^",2)
   i wincode="W" s winposdesc="西侧"
   i wincode="E" s winposdesc="东侧"
   s ret=ctlocdesc_"^"_pyphwdesc_"^"_pyname_"^"_fyname_"^"_winposdesc_"^"_fyphwdesc
   q ret
}

/// creator:yunhaibao
/// createdate:20160831
/// description:获取登录门诊权限,科室,用户,配药,发药,处方审核
/// output:json
/// phloc:门诊科室维护,phuser:门诊人员维护,phfy:发药,phpy:配药,phaudit:处方审核,phnouse:无效
/// w ##class(web.DHCOUTPHA.InfoCommon).CheckPermission(99,578)
ClassMethod CheckPermission(locid, userid = "", groupid = "")
{
	s AppName=##class(web.DHCOutPhCommon).%GetParameter("AppName")
	s phloc="",phuser="",phfy="",phpy="",phaudit="",phuserName=""
	s phnouse="",phcy="",phtq=""
	i $d(^DHCPHLOCi("LOC",locid)) d
	.s phloc=$o(^DHCPHLOCi("LOC",locid,""))
	.s phtq=$p(^DHCPHLOC(phloc),"^",5) 			//提前摆药
	.s phcy=$p(^DHCPHLOC(phloc),"^",6) 			//草药
	.s phlocaudit=$p(^DHCPHLOC(phloc),"^",7)	//科室审核处方
	.i (userid'="")&&($d(^DHCPHPERi("USR",userid))) d 
	..s phperson=""
	..f  s phperson=$o(^DHCPHPERi("USR",userid,phperson)) q:phperson=""  d
	...s phpersonloc=+$p(^DHCPHPER(phperson),"^",3)
	...q:phpersonloc'=phloc
	...s phpy=$p(^DHCPHPER(phperson),"^",6)
	...s phfy=$p(^DHCPHPER(phperson),"^",1)
	...s phaudit=$p(^DHCPHPER(phperson),"^",8)
	...s phnouse=$p(^DHCPHPER(phperson),"^",9)
	...s phuser=phperson
	...s phuserName=$p($g(^DHCPHPER(phuser)),"^",2)
	s phpy=$case(phpy,1:"Y",:"N")
	s phfy=$case(phfy,1:"Y",:"N")
	s phaudit=$s((phaudit="1"):"Y",1:"N")
	s phnouse=$case(phnouse,1:"Y",:"N")
	s phtq=$case(phtq,1:"Y",:"N")
	s phcy=$case(phcy,1:"Y",:"N")
	// 是否允许欠药
    s hospid=$p($g(^CTLOC(locid)),"^",22)
    s appparams=groupid_"^"_locid_"^"_userid_"^"_hospid
	s owedisp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName, "OweDisp", appparams)
	s returnNeedReq=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName, "ReturnNeedReq", appparams)
	s phloc=##class(web.DHCSTJQUERYCOMMON).JsonCell("phloc",phloc)
	s phtq=##class(web.DHCSTJQUERYCOMMON).JsonCell("phtq",phtq)
	s phcy=##class(web.DHCSTJQUERYCOMMON).JsonCell("phcy",phcy)
	s phuser=##class(web.DHCSTJQUERYCOMMON).JsonCell("phuser",phuser)
	s phpy=##class(web.DHCSTJQUERYCOMMON).JsonCell("phpy",phpy)
	s phfy=##class(web.DHCSTJQUERYCOMMON).JsonCell("phfy",phfy)
	s phaudit=##class(web.DHCSTJQUERYCOMMON).JsonCell("phaudit",phaudit)
	s phnouse=##class(web.DHCSTJQUERYCOMMON).JsonCell("phnouse",phnouse)
	s owedisp=##class(web.DHCSTJQUERYCOMMON).JsonCell("owedisp",owedisp)
	s returnNeedReq=##class(web.DHCSTJQUERYCOMMON).JsonCell("ReturnNeedReq",returnNeedReq)
	s phuserName=##class(web.DHCSTJQUERYCOMMON).JsonCell("phuserName",phuserName)
	s permission=phloc_","_phtq_","_phcy_","_phuser_","_phpy_","_phfy_","_phaudit_","_phnouse_","_owedisp_","_returnNeedReq_","_phuserName
	s permissionstring="[{"_permission_"}]"
	q permissionstring
}

/// creator:	yunhaibao
/// createdate: 2016-12-06
/// description:获取处方类型
/// w ##class(web.DHCOUTPHA.InfoCommon).GetPrescType("select2")
/// 与此名称一致##class(web.DHCOutPhCommon).GetPrescTitle("")
ClassMethod GetPrescType(style)
{
	s Title="RowId^Desc"
	i style["select2" s Title="id^text"
	e  s Title="RowId^Desc"
	s ret="" ,num=0
	s ret="1#普通^2#急诊^3#儿科^4#麻、精一^5#精二"
	s len=$l(ret,"^")
	f index=1:1:len d
	.s PrescStr=$p(ret,"^",index)
	.s PrescRowId=$p(PrescStr,"#",1)
	.s PrescDesc=$p(PrescStr,"#",2)
	.s data=PrescRowId_"^"_PrescDesc
	.s num=num+1
	.i num=1 d
	..w "["
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
    q:num=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	w "]"
    q ""
}

/// creator:yunhaibao
/// createdate:2017-11-20
/// description:获取窗口类型
/// w ##class(web.DHCOUTPHA.InfoCommon).jsGetWinType()
ClassMethod jsGetWinType()
{
	s title="RowId^Desc"
	s ret="" ,num=0
	s ret=##class(PHA.OP.DispWinCf.Query).GetWinType()
	s len=$l(ret,"^")
	f index=1:1:len d
	.s winTypeStr=$p(ret,"^",index)
	.s winTypeId=$p(winTypeStr,$c(1),1)
	.s winTypeDesc=$p(winTypeStr,$c(1),2)
	.s data=winTypeId_"^"_winTypeDesc
	.s num=num+1
	.i num=1 d
	..w "["
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(title,data)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,data)
    q:num=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	w "]"
    q ""
}

/// creator:dinghongying
/// createdate:2018-11-21
/// description:获取处方统计的处方类型
/// w ##class(web.DHCOUTPHA.InfoCommon).GetOutPrescType("select2")
ClassMethod GetOutPrescType(style)
{
	s Title="RowId^Desc"
	i style["select2" s Title="id^text"
	e  s Title="RowId^Desc"
	s ret="" ,num=0
	s ret="1#门诊处方^2#急诊处方^3#体检处方"
	s len=$l(ret,"^")
	f index=1:1:len d
	.s PrescStr=$p(ret,"^",index)
	.s PrescRowId=$p(PrescStr,"#",1)
	.s PrescDesc=$p(PrescStr,"#",2)
	.s data=PrescRowId_"^"_PrescDesc
	.s num=num+1
	.i num=1 d
	..w "["
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
    q:num=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	w "]"
    q ""
}

}

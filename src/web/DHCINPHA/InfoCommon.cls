Import sqluser

/// creator:yunhaibao
/// createdate:20160504
/// descirpiton:住院药房获取科室等下拉信息的类
Class web.DHCINPHA.InfoCommon Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod NewPid()
{
	q $i(^DHCSTPHARMACY("web.DHCINPHA.InfoCommon"))
}

/// 获取发药类别,用于发药界面显示
/// 此方法与web.DHCSTPHALOC.GetPhaLocDispType保持一致
/// w ##class(web.DHCINPHA.InfoCommon).GetPhaDispType(98)
ClassMethod GetPhaDispType(loc)
{
	 n (loc)
	 q:loc="" ""
	 s config=##Class(web.DHCSTKUTIL).GetPhaConfig("Con_DispTypeLocal")
	 s ret=""
	 s plid=$o(^DHCPL(0,"Loc",loc,"")) q:plid="" ""
	 s chl=""
	 f  s chl=$o(^DHCPL(plid,"DIS",chl)) q:chl=""  d
	 .s disptype=$p(^DHCPL(plid,"DIS",chl),"^",1)
	 .s defaultflag=$p(^DHCPL(plid,"DIS",chl),"^",5)
	 .q:'$d(^DHCSTDRUGGRP(disptype))
	 .s typecode=$p(^DHCSTDRUGGRP(disptype),"^",1)
	 .s typedesc=$p(^DHCSTDRUGGRP(disptype),"^",2)
	 .i ret="" d
	 ..s ret=$g(typecode)
	 .e  d
	 ..s ret=ret_"^"_$g(typecode)
	 s AddType=""
	 s rowid=""
	 s rowid=$o(^DHCPL(0,"Loc",loc,rowid))
	 s result=##class(web.DHCSTPHALOC).GetPhaLoc(rowid)
	 s DisplayEmy=$p(result,"^",25)
	 i DisplayEmy="Y" s DisplayEmy=1
	 e  s DisplayEmy=0
	 i DisplayEmy=1 d
	 .s emy="EMY"
	 .i AddType="" d
	 ..s AddType=emy
	 .e  d
	 ..s AddType=AddType_"^"_emy
	 s qt="QT"
	 i AddType'[qt d
	 .i AddType="" d
	 ..s AddType=qt
	 .e  d
	 ..s AddType=AddType_"^"_qt
	 i ret="" d
	 .s ret=AddType
	 e  d
	 .i AddType'="" d
	 ..s ret=ret_"^"_AddType
	 q ret
}

/// 根据发药类别代码获取描述
/// w ##class(web.DHCINPHA.InfoCommon).GetDispCatDescByCode("PTFY")
ClassMethod GetDispCatDescByCode(catcode)
{
	q:catcode="" ""
	q:'$d(^DHCSTDRUGGRP(0,"Code",catcode)) ""
	s catid=$o(^DHCSTDRUGGRP(0,"Code",catcode,""),-1)
	s catdesc=$p(^DHCSTDRUGGRP(catid),"^",2)
	q catdesc
}

/// 根据是否为特殊科室标志获取科室列表
/// w ##CLASS(web.DHCINPHA.InfoCommon).jsGetWardListByDocFlag("224^","","select2")
ClassMethod jsGetWardListByDocFlag(params, combotext = "", style = "")
{
	s ret = []
	s pCombotext = $zcvt(combotext, "U")
	s pLoc = $p(params, "^", 1)
	s pDocFlag = $p(params, "^", 2)
	s pInput = $p(params, "^", 3)
	s pHosp = $g(%session.Data("LOGON.HOSPID"))
	if (pDocFlag '= 1){
    	s sqlStr = "SELECT %ID, CTLOC_Desc FROM SQLUSER.CT_Loc WHERE CTLOC_WardFlag = 'Y'"
	}else{
		s sqlStr = "SELECT LINK_CTLOC_DR, LINK_CTLOC_DR->CTLOC_Desc"
				 _ " FROM CT_LocLinkLocation"
				 _ " WHERE LINK_ParRef = " _ pLoc
	}
	
    s sqlStatement = ##class(%SQL.Statement).%New()
    s sqlStatus = sqlStatement.%Prepare(sqlStr)
    s sqlResult = sqlStatement.%Execute()
    while (sqlResult.%Next()){		
        s loc = sqlResult.%GetData(1)
        s locDesc = sqlResult.%GetData(2)
        s locData = $g(^CTLOC(loc))
        continue:($p(locData, "^", 22) '= pHosp)
       	s activeDateFrom = $p(locData, "^", 24)
	    continue:(activeDateFrom '= "")&(activeDateFrom > +$h)
	    s activeDateTo = $p(locData, "^", 25)
	    continue:(activeDateTo '= "")&(activeDateTo < +$h)
	    if ($p(locData, "^", 13) = "W") {
			s ward = $o(^PAWARD(0, "WARD_LocationDR", loc, 0))
			if (ward '= ""){
				continue:($p(^PAWARD(ward), "^", 6) '= "Y")
			}   
		}
		if (pDocFlag = ""){
			continue:(##class(web.DHCSTKUTIL).DoctorLocRefuse(pLoc, loc) = 1)
		}
		continue:(pCombotext '= "")&&($zcvt(locDesc, "U") '[ pCombotext)&&($zcvt($p(locData, "^", 43), "U") '[ pCombotext)
		s rowData = {}
		if (style = "select2"){
			s rowData.id = loc, rowData.text = locDesc
		}else{
			s rowData.RowId = loc, rowData.Desc = locDesc
		}
		d ret.%Push(rowData)
    }	
    
	q ret.%ToJSON()
}

/// creator:yunhaibao
/// createdate:20160530
/// description:获取住院退药原因下拉
/// w ##class(web.DHCINPHA.InfoCommon).GetInRetReason("select2")
ClassMethod GetInRetReason(type = "", hosp = "") As %String
{
	n (type,hosp)
	s result=##class(%Library.ResultSet).%New("web.DHCSTKUTIL:RetReason")
	s sc=result.Execute()
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	i type="gridcombobox" s colNameStr="value^text"
	e  i type="select2" s colNameStr="id^text"
	e   s colNameStr="RowId^Desc"
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		s ret=result.%GetData(2)_"^"_result.%GetData(1)
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("BLC_ReasonForRefund",result.%GetData(2),hosp)="N"
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
/// createdate:20160629
/// description:获取科室发药类别集合
/// w ##class(web.DHCINPHA.InfoCommon).GetLocDispTypeDs(100)
ClassMethod GetLocDispTypeDs(LocId, style = "") As %String
{
	q:LocId="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i style["select2" s colNameStr="id^text"
	e  s colNameStr="RowId^Desc"
	s plid=$o(^DHCPL(0,"Loc",LocId,"")) q:plid="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	s chl="",h=0
	f  s chl=$o(^DHCPL(plid,"DIS",chl)) q:chl=""  d
	.s disptype=$p(^DHCPL(plid,"DIS",chl),"^",1)
	.s defaultflag=$p(^DHCPL(plid,"DIS",chl),"^",5)
	.q:'$d(^DHCSTDRUGGRP(disptype))
	.s typecode=$p(^DHCSTDRUGGRP(disptype),"^",1)
	.s typedesc=$p(^DHCSTDRUGGRP(disptype),"^",2)
	.s data=typecode_"^"_typedesc
	.s h=h+1
	.I h=1 d
	..w "["
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,data)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,data)
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	w "]"
	q ""
}

/// creator:yunhaibao
/// createdate:20160705
/// description:获取发药类别集合
/// w ##class(web.DHCINPHA.InfoCommon).GetDispTypeDs()
ClassMethod GetDispTypeDs(type = "", HospId = "") As %String
{
	i type="gridcombobox" s colNameStr="value^text"
	e   s colNameStr="RowId^Desc"
	s h=0
	s disptype=0
	f  s disptype=$o(^DHCSTDRUGGRP(disptype)) q:disptype=""  d
	.q:'$d(^DHCSTDRUGGRP(disptype))
	.s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("DHCStkDrugGroup",disptype,HospId) //医院级别授权
	.q:flag="N"
	.s typedesc=$p(^DHCSTDRUGGRP(disptype),"^",2)
	.s data=disptype_"^"_typedesc
	.s h=h+1
	.I h=1 d
	..w "["
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,data)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,data)
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	w "]"
	q ""
}

/// creator:yunhaibao
/// createdate:20160919
/// description:获取住院拒绝发药原因
/// w ##class(web.DHCINPHA.InfoCommon).GetRefuseDispReasonDs("select2")
ClassMethod GetRefuseDispReasonDs(style = "", hosp = "")
{
	n (style ,hosp)
	i style["select2" s Title="id^text"
	e  s Title="RowId^Desc"
	s count=0
	s rfid=0
	f  s rfid=$o(^DHCRFREASON(rfid)) q:rfid=""  d
	.q:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_STRefuseReason",rfid,hosp)="N"
	.s rfdesc=$p(^DHCRFREASON(rfid),"^",2)
	.s data=rfid_"^"_rfdesc
	.s count=count+1
	.I count=1 d
	..w "["
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
    q:count=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	w "]"
	q ""
}

/// creator:yunhaibao
/// createdate:20160919
/// description:获取住院发药发药人下拉,当科室不为空时按科室取
/// w ##class(web.DHCINPHA.InfoCommon).GetInPhaUserDs("38","","","select2")
ClassMethod GetInPhaUserDs(grp = "", locrowid = "", combotext = "", style = "")
{
	k calcData	
	i style["select2" s Title="id^text"
	e  s Title="RowId^Desc"  
	q:(grp="")&&(locrowid="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i locrowid'="" d
	.s ret=""
	.set myrowid=0
	.for  s myrowid=$o(^SSU("SSUSR",myrowid)) q:myrowid=""  d
	..s ctloctype="",usename="",useid=""
	..s tr=0,loc=""
	..s loc=+$p(^SSU("SSUSR",myrowid),"^",4)
	..i locrowid=loc s tr=tr+1
	..i tr=0  d
	...s othusr="0",th=0
	...f  s othusr=$o(^SSU("SSUSR",myrowid,"OTHLL",othusr)) q:(othusr="")!(othusr="0")  d
	....s othloc="",CTDesc=""
	....s othloc=+$p(^SSU("SSUSR",myrowid,"OTHLL",othusr),"^",1)
	....s ctloctype=""
	....s ctloctype=$p(^CTLOC(othloc),"^",13)
	....//q:ctloctype'["D"
	....q:othloc'=locrowid
	....s tr=tr+1
	..q:tr=0
	..s usename=$p(^SSU("SSUSR",myrowid),"^",2)
	..s data=usename_"^"_myrowid
	..s calcData(data)=""
	i (locrowid="")&&(grp'="") d
	.s ssusr=""
	.f  s ssusr=$o(^SSU("SSUSR",0,"Group",grp,ssusr)) q:ssusr=""  d
	..s name=$p(^SSU("SSUSR",ssusr),"^",2)
	..s data=name_"^"_ssusr
	..s calcData(data)=""
	s count=0
	s outputi=""
	f  s outputi=$o(calcData(outputi)) q:outputi=""  d
	.s userid=$p(outputi,"^",2)
	.s userData=^SSU("SSUSR",userid)
	.s username=$p(userData,"^",2)
	.s dateFrom = $p(userData,"^",96)
	.q:(dateFrom'="")&&(dateFrom>+$h) // 未开始
	.s dateTo = $p(userData,"^",97)
	.q:(dateTo'="")&&(dateTo<+$h) // 已截止
	.q:$p(userData,"^",19)="N"
	.s usernamepy=##class(web.DHCST.Common.AppCommon).GetCNCODE(username)
	.q:(combotext'="")&&($zcvt(usernamepy,"U")'[$zcvt(combotext,"U"))&&(username'[combotext)
	.s outputdata=userid_"^"_username
	.s count=count+1
	.I count=1 d
	..w "["
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,outputdata)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,outputdata)
    q:count=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	w "]"
	q ""
}

/// creator:yunhaibao
/// createdate:20170503
/// description:获取皮试记录列表
/// w ##class(web.DHCINPHA.InfoCommon).jsQuerySkinTest("1",999,"")
ClassMethod jsQuerySkinTest(page, rows, params = "") As %String
{
	s RegNo=$p(params,"^",1)
	q:RegNo="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s result=##class(%Library.ResultSet).%New("web.DHCSTPCHCOLLS2:GetSkinTest")
	s sc=result.Execute(RegNo)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e  s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1
		I countrecords=1 d
		.w ##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(countrecords,rows)
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	q ""
}

/// creator:	yunhaibao
/// createdate: 2018-05-10
/// description:获取住院医嘱审核合理用药厂商
/// w ##class(web.DHCINPHA.InfoCommon).GetPassProp("",100,"")
ClassMethod GetPassProp(GroupId As %String = "", LocId As %String, UserId As %String = "") As %Library.String
{
    n (GroupId,LocId,UserId)   
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName="DHCSTORDDISP"
    s Pass=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"PASS",Param) 
    q Pass
}

/// creator:	yunhaibao
/// createdate: 2020-04-07
/// description:获取住院医嘱审核相关参数
/// w ##class(web.DHCINPHA.InfoCommon).GetMonitorProp("",100,"")
ClassMethod GetMonitorPropStr(GroupId As %String = "", LocId As %String, UserId As %String = "") As %Library.String
{
    n (GroupId,LocId,UserId)   
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName="DHCSTORDDISP"
    s Pass=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"PASS",Param) 
	s RePassNeedCancel=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RePassNeedCancel",Param) 
    q Pass_"^"_RePassNeedCancel
}

}

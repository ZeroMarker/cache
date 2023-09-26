Class web.DHCST.Common.JsCommon Extends %Persistent [ ProcedureBlock ]
{

/// deccription:药品列表
/// table:      User.IncItm
/// input:		inputParams^1:别名
/// d ##class(%ResultSet).RunQuery("web.DHCST.Common.JsCommon","IncItm","","a")
Query IncItm(inputParams = "", filterText = "") As websys.Query(ROWSPEC = "incRowId,incCode,incDesc,incSpec")
{
}

ClassMethod IncItmExecute(ByRef qHandle As %Binary, inputParams = "", filterText = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	//q:inputParams="" $$$OK
	q:filterText="" $$$OK
	s HospId=$s($d(%session):%session.Data("LOGON.HOSPID"),1:"")
	s inputText=filterText
	s inputText="%"_$$ALPHAUP^SSUTIL4(inputText)_"%"
    s result = ##class(%Library.ResultSet).%New()
	s StkGrpType="G"
    s sqlStr ="select distinct inca_inci_dr from inc_alias "_
    "where %ALPHAUP(inca_text) like '"_inputText_"' and inca_inci_dr->inci_incsc_dr in "_ 
   "(Select scgr_stkcat_dr from dhc_stkcatgrprelations Where scgr_scg_parref->SCG_Type='"_StkGrpType_"')"
    d result.Prepare(sqlStr)
    d result.Execute()
    s num=0
    While(result.Next())
    {	
    	q:num>100
        s incId = result.Data("INCA_INCI_DR")
		s incCode=##class(PHA.COM.Data.Base).InciCode(incId)
		s incDesc=##class(PHA.COM.Data.Base).InciDesc(incId)
        s itmAdd=$o(^DHCITMINFO(0,"INCI",incId,"")) 
        s incSpec=$p($g(^DHCITMINFO(+itmAdd)),"^",27)
        s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",incId,HospId) //医院级别授权
		continue:flag="N"

        continue:incDesc=""
        s num=num+1
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(incId,incCode,incDesc,incSpec)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:库存分类
/// table:      User.INCStkCat
/// d ##class(%ResultSet).RunQuery("web.DHCST.Common.JsCommon","INCSCStkGrp","","西")
Query INCSCStkGrp(inputStr = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod INCSCStkGrpExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s filterText=$zcvt(filterText,"U")
	s HospId=$s($d(%session):%session.Data("LOGON.HOSPID"),1:"")
	s ind=1
	s stkCatId=0
	f  s stkCatId=$o(^INC("SC",stkCatId)) q:+stkCatId'>0  d 
	.q:'$d(^DHCSCG("STKCAT",stkCatId))
	.s stkGrpId=$o(^DHCSCG("STKCAT",stkCatId,"")) 
	.q:stkGrpId=""
	.s stkType=$p(^DHCSCG(stkGrpId),"^",3)
	.q:stkType'="G"
	.s stkCatDesc=##class(PHA.COM.Data.Base).StkCatDesc(stkCatId) 
	.s flag=##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_StkCat",stkCatId,HospId) //医院级别授权
	.q:flag="N"
	.i filterText'="" s stkCatPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(stkCatDesc)
	.q:(filterText'="")&&(stkCatPY'[filterText)&&(stkCatDesc'[filterText)
    .d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(stkCatId,stkCatDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// w ##class(web.DHCST.Common.JsCommon).GetLocByGrp(1)
/// d ##class(%ResultSet).RunQuery("web.DHCST.Common.JsCommon","GetLocByGrp",38)
Query GetLocByGrp(grpdr = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetLocByGrpExecute(ByRef qHandle As %Binary, grpdr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s sub="0"
	f  s sub=$o(^SSU("SSGRP",grpdr,"ST",sub)) q:sub=""  d
	.s ctlocdr=$p(^SSU("SSGRP",grpdr,"ST",sub),"^",1)
	.q:ctlocdr=""
	.s activeFlag=$p(^SSU("SSGRP",grpdr,"ST",sub),"^",2)
	.q:activeFlag="N"
	.q:'$d(^CTLOC(ctlocdr))
	.s ctlocdesc=##class(PHA.COM.Data.Base).LocDesc(ctlocdr)
	.s ctlocconname=$zcvt($p(^CTLOC(ctlocdr),"^",43),"U")
	.s ctloctype=$p(^CTLOC(ctlocdr),"^",13)
	.s cthospid=$p(^CTLOC(ctlocdr),"^",22)
	.q:($d(%session))&&(cthospid'="")&&($g(%session.Data("LOGON.HOSPID"))'=cthospid)
    .d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(ctlocdr,ctlocdesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// Creator		zzd
/// CreatDate	2018-07-20
/// Description	获取制剂列表
/// Input
/// Output
/// Other		d ##class(%ResultSet).RunQuery("web.DHCST.Common.JsCommon","GetInRecList","","LHNZSY")
Query GetInRecList(inputParams = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String,Qty,Uom,Remark,ExpDate,AddCost")
{
}

ClassMethod GetInRecListExecute(ByRef qHandle As %Binary, inputParams = "", filterText = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s HospId=$s($d(%session):%session.Data("LOGON.HOSPID"),1:"")
	s result = ##class(%Library.ResultSet).%New()
	i filterText="" d 
    .s sqlStr="select INREC_RowId AS RowId,INREC_Desc As Descption from INC_ItmRcp"
    .s sqlStr=sqlStr_" where inrec_parref->inci_incsc_dr in" 
    .s sqlStr=sqlStr_" (select scgr_stkcat_dr from dhc_stkcatgrprelations"
    .s sqlStr=sqlStr_" where scgr_scg_parref->scg_type='G')"
    e  d
    .s filterText=$$ALPHAUP^SSUTIL4(filterText)
    .s sqlStr="select INREC_RowId AS RowId,INREC_Desc As Descption from INC_ItmRcp" 
    .s sqlStr=sqlStr_" where inrec_parref in (select distinct(inca_inci_dr) AS RowId from inc_alias" 
    .s sqlStr=sqlStr_" Where %ALPHAUP(inca_text) %STARTSWITH  "_"'"_filterText_"'"
    .s sqlStr=sqlStr_" and inca_inci_dr->inci_incsc_dr in"
    .s sqlStr=sqlStr_" (select scgr_stkcat_dr from dhc_stkcatgrprelations "
    .s sqlStr=sqlStr_" where scgr_scg_parref->scg_type='G')) "
     
    d result.Prepare(sqlStr)
    d result.Execute()
    s num=0
    While(result.Next())
    {     
    	q:num>100
    	s Rowid = result.Data("RowId")
    	;s Desc=result.Data("Descption")
		s Desc=##class(web.DHCST.IncItmRcp).GetIncRcpDesc(Rowid)
    	s Inci=+Rowid
    	s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",Inci,HospId) //医院级别授权
		continue:flag="N"

    	s RecSub=$p(Rowid,"||",2)
    	s InRcpUom=$p(^INCI(Inci,"REC",RecSub),"^",1)
		s InRcpQty=$p(^INCI(Inci,"REC",RecSub),"^",2)
		s InRcpUom=##class(PHA.COM.Data.Base).UomDesc(InRcpUom)
		s Remark=$g(^INCI(Inci,"REC",RecSub,"REM",1))
		s Months=$p(^INCI(Inci,"REC",RecSub),"^",14)
		s ExpDate=""
		i +Months'=0 d
		.s retdate=+..DateChange("",Months)
		.i retdate'=0 d
		..s ExpDate=retdate-1
		..s ExpDate=$zd(ExpDate,3)
		.
		s AddCost=$p(^INCI(Inci,"REC",RecSub),"^",15)
		s num=num+1
		d outputRow
    }

	Quit $$$OK
outputRow  
	s Data=$lb(Rowid,Desc,InRcpQty,InRcpUom,Remark,ExpDate,AddCost)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// Creator		zzd
/// CreatDate	2018-07-20
/// Description	获取安全组下的人员
/// Input
/// Output
/// Other		d ##class(%ResultSet).RunQuery("web.DHCST.Common.JsCommon","GetUserOfGrpList","1")
Query GetUserOfGrpList(grpdr) As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetUserOfGrpListExecute(ByRef qHandle As %Binary, grpdr) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    q:grpdr="" $$$OK
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT DISTINCT(a.SSUSR_RowId) as RowId,a.SSUSR_Name as Descption FROM SS_User a"
    s sqlStr=sqlStr_" left JOIN SS_UserOtherLogonLoc b ON b.OTHLL_ParRef=a.SSUSR_RowId" 
    s sqlStr=sqlStr_" WHERE a.SSUSR_Group="_"'"_grpdr_"'"_" OR b.OTHLL_UserGroup_DR="_"'"_grpdr_"'" 

     
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {    
    	
    	s Rowid = result.Data("RowId")
    	s Active=$p(^SSU("SSUSR",Rowid),"^",19)
    	continue:Active'="Y"
    	s Desc=##class(PHA.COM.Data.Base).UserName(Rowid)
		d outputRow
    }

	Quit $$$OK
outputRow  
	s Data=$lb(Rowid,Desc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// Creator		zzd
/// CreatDate	2018-07-20
/// Description	获取单位
/// Input
/// Output
/// Other		d ##class(%ResultSet).RunQuery("web.DHCST.Common.JsCommon","GetUomByInci","2003")
Query GetUomByInci(inputStr = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetUomByInciExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s Inci=+inputStr
	q:+Inci=0 $$$OK
	s Inci=+Inci
	s Buom=$p(^INCI(Inci,1),"^",10)
	s Puom=$p(^INCI(Inci,3),"^",6)
	i Buom'=Puom d
	.s Rowid=Puom
	.s Desc=##class(PHA.COM.Data.Base).UomDesc(Puom)
	.d outputRow
	.s Rowid=Buom
	.s Desc=##class(PHA.COM.Data.Base).UomDesc(Buom)
	.d outputRow
	e  d
	.s Rowid=Buom
	.s Desc=##class(PHA.COM.Data.Base).UomDesc(Buom)
	.d outputRow
    

	Quit $$$OK
outputRow  
	s Data=$lb(Rowid,Desc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

ClassMethod NewPid()
{
	q $i(^DHCST("web.DHCST.Common.JsCommon"))
}

/// w ##class(web.DHCST.Common.JsCommon).DateChange(23,"")
ClassMethod DateChange(days, months)
{
	s retdate=""
	s curdate=+$h
	i days'="" d
	.s days=$fn(days,"",0)
	.s retdate=curdate+days
	e  d
	.i months'=""  d
	..s months=$fn(months,"",0)
	..s curmonth=+$p($zd(curdate,3),"-",2)
	..s curyear=+$p($zd(curdate,3),"-",1)
	..s curday=+$p($zd(curdate,3),"-",3)
	..s tmpmonths=curmonth+months-1
	..s years=tmpmonths\12
	..s month=tmpmonths#12+1
	..s date=(curyear+years)_"-"_month_"-"_01
	..s date=$zdh(date,3)+curday
	..s retdate=date
	q retdate
}

ClassMethod GetInrecPrice(InRec, Uom, Param)
{
	s GroupId=$p(Param,"^",1)
	s LocId=$p(Param,"^",2)
	s User=$p(Param,"^",3)
	s HospId=$p(Param,"^",4)
	i (HospId="")&&(LocId'="") s HospId=$p(^CTLOC(LocId),"^",22)
	s Inci=+InRec
	i Uom="" s Uom=$p(^INCI(Inci,3),"^",6)
	
	s CurSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inci,+$h,Uom,HospId,"G","")
	s Perv=GroupId_"^"_LocId_"^"_User_"^"_HospId
	s AppName=##class(web.DHCST.ManuOrder).%GetParameter("AppName")
	s DefaultRp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaultRp",Perv)  //根据维护的进价取法 取进价
    s incirp=""
    i DefaultRp=2  d 
    .s LastReailPrice=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(Inci,+$h,Uom,HospId,"G","")
	.s incirp=LastReailPrice
	e  d
	.s cpr=##class(web.DHCST.ManuOrder).GetItmCpr(InRec)
	.s incirp=CurSp/cpr
	s bUom=$p(^INCI(Inci,1),"^",10)
	s pUom=$p(^INCI(Inci,3),"^",6)
	i bUom=Uom  d
	.s incirp=##Class(web.DHCSTCOMMPARA).GetNumbFN(incirp,Perv,"FmtRP",2)
	e  d
	.s incirp=##Class(web.DHCSTCOMMPARA).GetNumbFN(incirp,Perv,"FmtRP",1)
	s CurSp=##class(web.DHCST.Common.JsCommon).ChangVal(CurSp,"FmtSP")
    q incirp_"^"_CurSp
}

/// Description		-1~1 之间的补0
/// w ##class(web.DHCST.Common.JsCommon).ChangVal(0.1)
ClassMethod ChangVal(val, Type = "")
{
	i Type="" s Type="FmtRP"
	s hospId=""
	s ret=+##class(web.DHCST.Common.AppCommon).DecLenByFmtType(Type,hospId)
	s len=$l($p(val,".",2))
	q:(len>ret)||(Type="Qty") $fn(val,"",len)
	q $fn(val,"",ret)
}

Storage Default
{
<Data name="JsCommonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCST.Common.JsCommonD</DataLocation>
<DefaultData>JsCommonDefaultData</DefaultData>
<IdLocation>^web.DHCST.Common.JsCommonD</IdLocation>
<IndexLocation>^web.DHCST.Common.JsCommonI</IndexLocation>
<StreamLocation>^web.DHCST.Common.JsCommonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

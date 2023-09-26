Import sqluser

/// creator:yunhaibao
/// createdate:20160422
/// description:药房获取数据的公共方法  返回均为json
Class web.DHCSTPharmacyCommon Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:20160422
/// description:获取安全组stocklocation集合
/// w ##class(web.DHCSTPharmacyCommon).GetPhaLocByGrp("1","mzddd","select2")
ClassMethod GetPhaLocByGrp(grpdr, combotext = "", style = "") As %String
{
    k GetPhaLocByGrpDATA
    s combotext=$zcvt(combotext,"U")
    s Title="RowId^Desc"
    i style["select2" s Title="id^text"
    s h=0
    s sub="0"
    f  s sub=$o(^SSU("SSGRP",grpdr,"ST",sub)) q:sub=""  d
    .s ctlocdr=$p(^SSU("SSGRP",grpdr,"ST",sub),"^",1)
    .q:ctlocdr=""
    .q:$p(^SSU("SSGRP",grpdr,"ST",sub),"^",2)="N"
    .q:'$d(^CTLOC(ctlocdr))
    .s ctlocdesc=##class(PHA.COM.Data.Base).LocDesc(ctlocdr)
    .s ctlocconname=$zcvt($p(^CTLOC(ctlocdr),"^",43),"U")
    .s ctloctype=$p(^CTLOC(ctlocdr),"^",13)
    .s cthospid=$p(^CTLOC(ctlocdr),"^",22)
    .q:($d(%session))&&(cthospid'="")&&($g(%session.Data("LOGON.HOSPID"))'=cthospid)
    .q:(ctloctype'="D")&&('$d(^DHCPL(0,"Loc",ctlocdr)))
    .q:(combotext'="")&&($zcvt(ctlocdesc,"U")'[combotext)&&(ctlocconname'[combotext)
    .i (style["select2")&&(ctlocdesc["-") s ctlocdesc=$p(ctlocdesc,"-",2)
    .s h=h+1
    .s data=ctlocdesc_"^"_ctlocdr
    .s GetPhaLocByGrpDATA(h)=data   
    s count=0
    w "["
    s h=""
    f  s h=$o(GetPhaLocByGrpDATA(h)) q:h=""  d
    .s data=GetPhaLocByGrpDATA(h)
    .s LocDr = $p(data,"^",2)
    .s LocDesc = $p(data,"^",1)
    .s tmp=LocDr_"^"_LocDesc
    .s count = count+1
    .I count=1 d
    ..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,tmp)
    .e  d
    ..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,tmp)
    w "]"
    q ""
}

/// creator:yunhaibao
/// createdate:20160422
/// description:获取病区集合
/// w ##class(web.DHCSTPharmacyCommon).GetWardLocDs("","select2")
ClassMethod GetWardLocDs(combotext = "", style = "") As %String
{
    k GetWardLocDsDATA
    s combotext=$zcvt(combotext,"U")
    s Title="RowId^Desc"
    i style["select2" s Title="id^text"
    s HospId=$g(%session.Data("LOGON.HOSPID"))
    s h=0
    s warddr=0
    f  s warddr=$o(^PAWARD(warddr)) q:(warddr="")||(+warddr=0)  d
    .s warddesc=##class(PHA.COM.Data.Base).WardDesc(warddr)
    .s locdr=$p(^PAWARD(warddr),"^",5)
    .q:locdr=""
    .q:($p(^PAWARD(warddr),"^",6) '= "Y")
    .s locconname=$zcvt($p(^CTLOC(locdr),"^",43),"U")
    .q:HospId'=$p(^CTLOC(locdr),"^",22)
    .q:$p(^CTLOC(locdr),"^",5)'="Y"
    .q:(combotext'="")&&($zcvt(warddesc,"U")'[combotext)&&(locconname'[combotext)
    .i (style["select2")&&(warddesc["-") s warddesc=$p(warddesc,"-",2)
    .q:warddesc=""
    .s h=h+1
    .s data=warddesc_"^"_warddr
    .s GetWardLocDsDATA(locdr)=data
    q:h=0 "[]"
    s maxrow=h    
    s count=0
    s h=""
    f  s h=$o(GetWardLocDsDATA(h)) q:h=""  d
    .s data=GetWardLocDsDATA(h)
    .s warddesc=$p(data,"^",1)
    .s rowId=$p(data,"^",2)
    .s tmpstr=rowId_"^"_warddesc
    .s count=count+1
    .I count=1 d
    ..w "["
    ..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,tmpstr)
    .e  d
    ..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,tmpstr)
    w "]"
    q ""
}

/// creator:yunhaibao
/// createdate:20160422
/// description:获取药品集合
/// w ##class(web.DHCSTPharmacyCommon).GetInciListByAlias("amxdddl")
ClassMethod GetInciListByAlias(alias) As %String
{
    k GetInciListByAliasDATA
    s alias="%"_$$ALPHAUP^SSUTIL4(alias)_"%"
    s h=0
    s result = ##class(%Library.ResultSet).%New()
    s StkGrpType="G"
    s sqlStr ="select distinct inca_inci_dr from inc_alias "_
    "where %ALPHAUP(inca_text) like '"_alias_"' and inca_inci_dr->inci_incsc_dr in "_ 
   "(Select scgr_stkcat_dr from dhc_stkcatgrprelations Where scgr_scg_parref->SCG_Type='"_StkGrpType_"')"
    d result.Prepare(sqlStr)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) q "[]"
    s count = 0
    While(result.Next())
    {   
        s inci = result.Data("INCA_INCI_DR")
        s incidesc=##class(PHA.COM.Data.Base).InciDesc(inci)
        continue:incidesc=""
        s count=count+1
        s GetInciListByAliasDATA(count)=inci_"^"_incidesc
        
    }
    q:count=0 "[]"
    s maxrow=count    
    s count=0
    s h=""
    f  s h=$o(GetInciListByAliasDATA(h)) q:h=""  d
    .s data=GetInciListByAliasDATA(h)
    .s incidesc=$p(data,"^",2)
    .s rowId=$p(data,"^",1)
    .s tmpstr=rowId_"^"_incidesc
    .s count=count+1
    .I count=1 d
    ..w "["
    ..W ##class(web.DHCSTJQUERYCOMMON).getJsonData("RowId^Desc",tmpstr)
    .e  d
    ..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData("RowId^Desc",tmpstr)
    w "]"
    q ""
}

/// creator:yunhaibao
/// createdate:20160425
/// description:获取卡类型
/// w ##class(web.DHCSTPharmacyCommon).ReadCardTypeDefineListBroker("GetCardTypeToJson")
ClassMethod ReadCardTypeDefineListBroker(JSFunName As %String = "", ListName As %String = "", SessionStr As %String = "", style = "") As %String
{
    k ReadCardTypeDefineListBrokerDATA
    s ^TMPSessionStr=SessionStr 
    s myTypeID=0
    s mydes=""
    s myval=""
    s mySelFlag=0
    s myDataFlag=0
    s ^TMPSessionStr=SessionStr
    s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
    if ($IsObject(myPEObj)){
        s myDataFlag=1
    }
    s outputdata=""
    s myIdx=0
    f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
    .s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
    .s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)       ;CTD_ActiveFlag
    .q:(myActiveFlag'="IE")
    .s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)      ;CTD_DateTo
    .q:((+myDateTo'=0)&(myDateTo<+$h))          ;失效日
    .s myDateFrom=+$p(^DHCCARDTYPEDef(myTypeID),"^", 9)     ;CTD_DateFrom
    .q:((+myDateFrom'=0)&(myDateFrom>+$h))          ;生效日
    .s myval=myTypeID
    .s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
    .s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
    .i myDefault="Y" d
    ..s mySelFlag=1
    .e  d
    ..s mySelFlag=0
    .s myFindFlag=1
    .i +myDataFlag  d
    ..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
    ..i myPEObj.DefaultCardTypeDR=myTypeID  d
    ...s mySelFlag=1
    .q:(+myFindFlag=0)
    .s myIdx=myIdx+1
    .s ReadCardTypeDefineListBrokerDATA(myIdx)=myval_"^"_mySelFlag_"!!"_mydes
    s index="",count=0
    s Title="RowId!!Desc"
    i style["select2" s Title="id!!text"
    f  s index=$o(ReadCardTypeDefineListBrokerDATA(index)) q:index=""  d
    .s count=count+1
    .s data=ReadCardTypeDefineListBrokerDATA(index)
    .I count=1 d
    ..w "["
    ..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data,"!!")
    .e  d
    ..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data,"!!")
    w "]"
    q ""
}

/// creator:yunhaibao
/// createdate:20160422
/// description:获取科室组集合
/// w ##class(web.DHCSTPharmacyCommon).GetLocGroupDs(100)
ClassMethod GetLocGroupDs(phaLoc, combotext = "", style = "") As %String
{
    s result=##class(%Library.ResultSet).%New("web.DHCSTKUTIL:GetLocGroupQuery")
    s sc=result.Execute("G",combotext,phaLoc)
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
        s rowId = result.%GetData(1)
        s desc = ##class(PHA.COM.Data.Base).LocGroupDesc(2)
        s ret=desc _ "^" _ rowId
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
/// createdate:20160422
/// description:获取药品集合
/// w ##class(web.DHCSTPharmacyCommon).GetIncItmForDialog("wss")
ClassMethod GetIncItmForDialog(alias) As %String
{
    k GetIncItmForDialogDATA
    s alias="%"_$$ALPHAUP^SSUTIL4(alias)_"%"
    s pid=..NewPid()
    s h=0
    s result = ##class(%Library.ResultSet).%New()
    s StkGrpType="G"
    s sqlStr ="select distinct inca_inci_dr from inc_alias "_
    "where %ALPHAUP(inca_text) like '"_alias_"' and inca_inci_dr->inci_incsc_dr in "_ 
   "(Select scgr_stkcat_dr from dhc_stkcatgrprelations Where scgr_scg_parref->SCG_Type='"_StkGrpType_"')"
    d result.Prepare(sqlStr)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) q "[]"
    s count = 0
    While(result.Next())
    {   
        s inci = result.Data("INCA_INCI_DR")
        s incidesc=##class(PHA.COM.Data.Base).InciDesc(inci)
        s incicode=$p(^INCI(inci,1),"^",1)
        continue:incidesc=""
        s count=count+1
        s GetIncItmForDialogDATA(count)=inci_"^"_incidesc_"^"_incicode
        
    }
    q:count=0 "[]"
    s colNameStr="Inci^InciCode^InciDesc"
    s maxrow=count    
    s count=0
    s h=""
    f  s h=$o(GetIncItmForDialogDATA(h)) q:h=""  d
    .s data=GetIncItmForDialogDATA(h)
    .s incidesc=$p(data,"^",2)
    .s incicode=$p(data,"^",3)
    .s rowId=$p(data,"^",1)
    .s tmpstr=rowId_"^"_incicode_"^"_incidesc
    .s count=count+1
    .I count=1 d
    ..w "["
    ..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,tmpstr)
    .e  d
    ..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,tmpstr)
    w "]"
    q ""
}

/// creator:yunhaibao
/// createdate:20160905
/// description:获取药品集合,供下拉框
/// w ##class(web.DHCSTPharmacyCommon).GetLocInciDsByAlias("wss","98","select2")
ClassMethod GetLocInciDsByAlias(combotext, locid = "", style = "") As %String
{
    k GetLocInciDsByAliasDATA
    //q:alias="" "[{RowId:"",Desc:""}]"
    s combotext="%"_$$ALPHAUP^SSUTIL4(combotext)_"%"
    s pid=..NewPid()
    s h=0
    s result = ##class(%Library.ResultSet).%New()
    s StkGrpType="G"
    s sqlStr ="select distinct inca_inci_dr from inc_alias "_
    "where %ALPHAUP(inca_text) like '"_combotext_"' and inca_inci_dr->inci_incsc_dr in "_ 
    "(Select scgr_stkcat_dr from dhc_stkcatgrprelations Where scgr_scg_parref->SCG_Type='"_StkGrpType_"')"
    d result.Prepare(sqlStr)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) q "[]"
    s count = 0
    While(result.Next())
    {   
        s inci = result.Data("INCA_INCI_DR")
        continue:(locid'="")&&('$d(^INCI("IL_LOC",locid,inci)))
        s incidesc=##class(PHA.COM.Data.Base).InciDesc(inci)
        s incicode=$p(^INCI(inci,1),"^",1)
        continue:incidesc=""
        s count=count+1
        s GetLocInciDsByAliasDATA(count)=inci_"^"_incidesc_"^"_incicode
        
    }
    q:count=0 "[]"
    i style="select2" s colNameStr="id^text"
    e  s colNameStr="RowId^Desc"
    s maxrow=count    
    s count=0
    s h=""
    f  s h=$o(GetLocInciDsByAliasDATA(h)) q:h=""  d
    .s data=GetLocInciDsByAliasDATA(h)
    .s incidesc=$p(data,"^",2)
    .s incicode=$p(data,"^",3)
    .s rowId=$p(data,"^",1)
    .s tmpstr=rowId_"^"_incidesc
    .s count=count+1
    .I count=1 d
    ..w "["
    ..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,tmpstr)
    .e  d
    ..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,tmpstr)
    w "]"
    q ""
}

/// creator:yunhaibao
/// createdate:20160505
/// description:根据登记号获取病人基本信息
/// w ##class(web.DHCSTPharmacyCommon).GetPatInfoByNo("0000000213")
ClassMethod GetPatInfoByNo(pano, adm = "")
{
    &sql(select papmi_name,papmi_sex_dr,nvl(papmi_dob,"") 
    into :paname,:sexDr,:dob from pa_patmas
    where papmi_no=:pano)
    q:SQLCODE ""
    i $g(dob)'="" d
    .s pmi=$o(^PAPERi("PAPMI_PatNo",pano,""))
    .s age=##class(PHA.FACE.IN.Com).GetAge(pmi,adm) //年龄统一调用接口wyx 2015-01-29
    .s dob=$zd(dob,3)
    .s sex = ##class(PHA.COM.Data.Base).SexDesc(sexDr) 
    s result=$g(paname)_"^"_$g(sex)_"^"_ $g(dob)_"^"_$g(age)
    q result
}

/// creator:    yunhaibao
/// createdate: 20170217
/// description:根据登记号获取病人基本信息
/// w ##class(web.DHCSTPharmacyCommon).GetPatInfoByAdm("214")
ClassMethod GetPatInfoByAdm(adm)
{
    q:adm="" "[{}]"
    s papmi=$p(^PAADM(adm),"^",1)
    &SQL(select papmi_no into :pano from pa_patmas where PAPMI_RowId=:papmi)
    s papmiinfo=..GetPatInfoByNo(pano,adm)
    s Title="PatNo^PatName"
    s data=pano_"^"_$p(papmiinfo,"^",1)
    s result="["_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)_"]"
    q result
}

/// creator:yunhaibao
/// createdate:20160505
/// description:根据科室id获取住院药房那个配置信息
/// w ##class(web.DHCSTPharmacyCommon).GetInPhaConfig("98")
ClassMethod GetInPhaConfig(locId)
{
    s result=##class(web.DHCSTPHALOC).GetPhaflag(locId)
    w result
    q ""
}

/// creator:    yunhaibao
/// createdate: 20160603
/// description:获取科室集合
/// input:      custtype(DocLoc:医生科室)
/// w ##class(web.DHCSTPharmacyCommon).GetCtLocDs("","","","","3")
ClassMethod GetCtLocDs(combotext = "", style = "", loctype = "", custtype = "", HospId = "") As %String
{
    k GetCtLocDsDATA
    s Title="RowId^Desc"
    i style["select2" s Title="id^text"
    i HospId="" s HospId=$g(%session.Data("LOGON.HOSPID"))
    s h=0
    s ctloc=0
    f  s ctloc=$o(^CTLOC(ctloc)) q:ctloc=""  d
    .s locdesc=##class(PHA.COM.Data.Base).LocDesc(ctloc)
    .s locConName=$p(^CTLOC(ctloc),"^",43)
    .s quitFlag=""
    .s locType=$p(^CTLOC(ctloc),"^",13)
    .q:(HospId'="")&&(HospId'=$p(^CTLOC(ctloc),"^",22))
    .s frDate=$p(^CTLOC(ctloc),"^",24)
    .q:(frDate'="")&&(frDate>(+$h)) //科室不可用
    .s toDate=$p(^CTLOC(ctloc),"^",25)
    .q:(toDate'="")&&(toDate<(+$h)) //科室不可用
    .i custtype'="" d
    ..i custtype="DocLoc" d
    ...i $p(^CTLOC(ctloc),"^",5)="Y" s quitFlag="1" q
    ...i locType="D" s quitFlag="1" q
    .e  d
    ..s exitflag=##class(web.DHCST.Common.UtilCommon).FindInList(loctype,locType,"$$")
    ..s:exitflag=0 quitFlag="1" 
    .q:(loctype'="")&&(quitFlag'="")
    .q:(custtype'="")&&(quitFlag'="")
    .s matchFlag=""
    .i combotext="" s matchFlag=1
    .i (combotext'="")&&($zcvt(locdesc,"U")[$zcvt(combotext,"U")) s matchFlag=1
    .i (combotext'="")&&($zcvt(locConName,"U")[$zcvt(combotext,"U")) s matchFlag=1
    .q:matchFlag=""
    .i (style["select2")&&(locdesc["-") s locdesc=$p(locdesc,"-",2)
    .q:locdesc=""
    .s h=h+1
    .s tmpstr=ctloc_"^"_locdesc
    .I h=1 d
    ..w "["
    ..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,tmpstr)
    .e  d
    ..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,tmpstr)
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
    w "]"
    q ""
}

/// descirpiton:根据登录用户获取登陆科室以及其他登陆科室
/// d ##class(web.DHCSTPharmacyCommon).GetUserAllLocDs(1,"")
ClassMethod GetUserAllLocDs(userid, combotext = "", style = "", HospId = "")
{
    k GetUserAllLocDsDATA
    s Title="RowId^Desc"
    i style["select2" s Title="id^text"
    s ret="",num=0
    s ctloc="",ctlocdesc=""
    i userid="" q ret
    s ctloc=+$p(^SSU("SSUSR",userid),"^",4)
    s ctlocdesc=##class(PHA.COM.Data.Base).LocDesc(ctloc)
    i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2) 
    i (HospId=$p($g(^CTLOC(ctloc)),"^",22)) s GetUserAllLocDsDATA(ctloc)=ctlocdesc
    s othusr="0",th=0
    f  s othusr=$o(^SSU("SSUSR",userid,"OTHLL",othusr)) q:(othusr="")!(othusr="0")  d
    .s ctloc="",ctlocdesc=""
    .s ctloc=+$p(^SSU("SSUSR",userid,"OTHLL",othusr),"^",1)
    .q:ctloc=0
    .s ctloctype=""
    .s ctloctype=$p($g(^CTLOC(ctloc)),"^",13)
    .q:ctloctype'["D"
    .q:(HospId'=$p($g(^CTLOC(ctloc)),"^",22))
    .s ctlocdesc=$p($g(^CTLOC(ctloc)),"^",2)
    .s ctlocconname=$p($g(^CTLOC(ctloc)),"^",43)
    .q:(combotext'="")&&($zcvt(ctlocdesc,"U")'[$zcvt(combotext,"U"))&&($zcvt(ctlocconname,"U")'[$zcvt(combotext,"U"))
    .i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2)
    .s GetUserAllLocDsDATA(ctloc)=ctlocdesc

    s outputi=""
    f  s outputi=$o(GetUserAllLocDsDATA(outputi)) q:outputi=""  d
    .s num=num+1
    .s loc=outputi
    .s locdesc=GetUserAllLocDsDATA(outputi)
    .s ret=loc_"^"_locdesc
    .i num=1  d 
    ..w "["
    ..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,ret)
    .e  d 
    ..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,ret)
    i num>0 w "]"
    q ""
}

/// descirpiton:获取药房人员
/// d ##class(web.DHCSTPharmacyCommon).GetLocAllUserDs(98)
ClassMethod GetLocAllUserDs(ctloc)
{
    s colNameStr="RowId^Desc"
    s ret=""
    s myrowid=0,num=0
    f  s myrowid=$o(^SSU("SSUSR",myrowid)) q:myrowid=""  d
    .s ctloctype="",usecode="",usename="",useid=""
    .s tr=0,loc=""
    .s loc=+$p(^SSU("SSUSR",myrowid),"^",4)
    .i ctloc=loc s tr=tr+1
    .i tr=0  d
    ..s othusr="0",th=0
    ..f  s othusr=$o(^SSU("SSUSR",myrowid,"OTHLL",othusr)) q:(othusr="")!(othusr="0")  d
    ...s othloc="",CTDesc=""
    ...s othloc=+$p(^SSU("SSUSR",myrowid,"OTHLL",othusr),"^",1)
    ...s ctloctype=""
    ...s ctloctype=$p(^CTLOC(othloc),"^",13)
    ...q:ctloctype'["D"
    ...q:othloc'=ctloc
    ...s tr=tr+1
    .q:tr=0
    .s usecode=$p(^SSU("SSUSR",myrowid),"^",1)
    .s usename=##class(PHA.COM.Data.Base).UserName(myrowid)
    .s useid=myrowid
    .s num=num+1
    .s ret=useid_"^"_usename
    .i num=1  d 
    ..w "["
    ..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
    .e  d 
    ..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
    i num>0 w "]"
    q ""
}

/// creator:yunhaibao
/// createdate:20160623
/// description:获取用法集合
/// w ##class(web.DHCSTPharmacyCommon).GetInstuDs()
ClassMethod GetInstuDs(combotext = "") As %String
{
    s combotext=$zcvt(combotext,"U")
    s instuid=0,h=0
    f  s instuid=$o(^PHCIN(instuid)) q:(instuid="")||(+instuid=0)  d
    .s instudesc=##class(PHA.COM.Data.Base).InstDesc(instuid)
    .s instupy=$s(combotext'="":##class(web.DHCST.Common.AppCommon).GetCNCODE(instudesc),1:"")
    .q:(combotext'="")&&(instupy'[combotext)&&(instudesc'[combotext)
    .s h=h+1
    .s data=instuid_"^"_instudesc
    .I h=1 d
    ..w "["
    ..w ##class(web.DHCSTJQUERYCOMMON).getJsonData("RowId^Desc",data)
    .e  d
    ..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData("RowId^Desc",data)
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    w "]"
    q ""
}

/// creator:yunhaibao
/// createdate:20160628
/// description:获取库存分类集合
/// w ##class(web.DHCSTPharmacyCommon).GetStkCatDs()
ClassMethod GetStkCatDs(StkGrp = "", combotext = "", style = "") As %String
{
    s Title="RowId^Desc"
    s HospId=$g(%session.Data("LOGON.HOSPID"))
    i style["select2" s Title="id^text"
    s stkcat="0",h=0
    f  s stkcat=$o(^INC("SC",stkcat)) q:stkcat=""  d
    .q:stkcat="0"
    .s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_StkCat",stkcat,HospId) //医院级别授权
    .q:flag="N"
    .s stkcatdesc=##class(PHA.COM.Data.Base).StkCatDesc(stkcat)
    .s stkcattype=$p(^INC("SC",stkcat),"^",3)
    .q:(stkcattype'="G")
    .s stkcatpy=##class(web.DHCST.Common.AppCommon).GetCNCODE(stkcatdesc)
    .q:(combotext'="")&&($zcvt(stkcatpy,"U")'[$zcvt(combotext,"U"))&&(stkcatdesc'[combotext)
    .s data=stkcat_"^"_stkcatdesc
    .s h=h+1
    .I h=1 d
    ..w "["
    ..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
    .e  d
    ..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    w "]"
    q ""
}

/// creator:yunhaibao
/// createdate:20160628
/// description:获取科室管理组集合
/// w ##class(web.DHCSTPharmacyCommon).GetManaGroupDs(100)
ClassMethod GetManaGroupDs(ctloc = "", style = "") As %String
{
    s Title="RowId^Desc"
    i style["select2" s Title="id^text"
    s mangrp="0",h=0
    f  s mangrp=$o(^DHCLMG(0,"LOC",ctloc,mangrp)) q:(mangrp="")!(mangrp="0")  d
    .s mangrpdesc=##class(PHA.COM.Data.Base).LocManGroupDesc(mangrp)
    .s data=mangrp_"^"_mangrpdesc
    .s h=h+1
    .I h=1 d
    ..w "["
    ..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
    .e  d
    ..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    w "]"
    q ""
}

/// creator:yunhaibao
/// createdate:20160629
/// description:获取科室类组集合
/// w ##class(web.DHCSTPharmacyCommon).GetLocStkGrpDs(100)
ClassMethod GetLocStkGrpDs(LocId, style = "") As %String
{
    q:LocId="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    s Title="RowId^Desc"
    i style["select2" s Title="id^text"
    s Slcg=0,h=0,Type="G"
    f  s Slcg=$o(^DHCSLCG(0,"CTLOC",LocId,Type,Slcg)) q:Slcg=""  d
    .s StkCatGrp=$p(^DHCSLCG(Slcg),"^",2)
    .s Default=$p(^DHCSLCG(Slcg),"^",4)
    .q:'$d(^DHCSCG(StkCatGrp))
    .s StkCatGrpDesc=##class(PHA.COM.Data.Base).StkCatGrpDesc(StkCatGrp)
    .s data=StkCatGrp_"^"_StkCatGrpDesc
    .s h=h+1
    .I h=1 d
    ..w "["
    ..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
    .e  d
    ..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    w "]"
    q ""
}

/// creator:dinghongying
/// createdate:20160704
/// description:获取管制分类集合
/// w ##class(web.DHCSTPharmacyCommon).GetPoisonCatDs()
ClassMethod GetPoisonCatDs(combotext = "", style = "") As %String
{
    s Title="RowId^Desc"
    i style["select2" s Title="id^text"
    s PoisonRowId="0",num=0
    f  s PoisonRowId=$o(^PHCPO(PoisonRowId)) q:PoisonRowId=""  d
    .q:PoisonRowId="0"
    .s PoisonDesc=##class(PHA.COM.Data.Base).PoisonDesc(PoisonRowId)
    .s data=PoisonRowId_"^"_PoisonDesc
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
/// createdate:20161212
/// description:获取剂型集合
/// w ##class(web.DHCSTPharmacyCommon).GetPhcFormDs()
ClassMethod GetPhcFormDs(combotext = "", style = "") As %String
{
    s Title="RowId^Desc"
    i style["select2" s Title="id^text"
    s PhcFormRowId="0",num=0
    f  s PhcFormRowId=$o(^PHCF(PhcFormRowId)) q:PhcFormRowId=""  d
    .q:PhcFormRowId="0"
    .s PhcFormDesc=##class(PHA.COM.Data.Base).FormDesc(PhcFormRowId)
    .s PhcFormPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(PhcFormDesc)
    .q:(combotext'="")&&($zcvt(PhcFormPY,"U")'[$zcvt(combotext,"U"))&&(PhcFormDesc'[combotext)
    .s data=PhcFormRowId_"^"_PhcFormDesc
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
/// createdate:20160806
/// description:获取科室对象
/// w ##class(web.DHCSTPharmacyCommon).GetDefaultLoc(100)
ClassMethod GetDefaultLoc(locId)
{
    s locDesc=""
    s locDesc1=""
    i (locId'="")&&($d(^CTLOC(locId))) d
    .s locDesc=##class(PHA.COM.Data.Base).LocDesc(locId)
    .i locDesc["-" s locDesc1=$p(locDesc,"-",2)
    .e  s locDesc1=LocDesc
    q locDesc1
}

/// creator:yunhaibao
/// createdate:201608010
/// description:获取his公共参数
/// output:json 登记号长度
/// w ##class(web.DHCSTPharmacyCommon).GetPhaHisCommonParmas()
ClassMethod GetPhaHisCommonParmas()
{
    s Title="patNoLen"
    s patNoLen=$p(^CF("PATCF",1,3),"^",5)
    s data=patNoLen
    w "["
    w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,data)
    w "]"
    q ""
}

/// creator:yunhaibao
/// createdate:201608011
/// description:根据登记号或卡号获取病人信息
/// input:号码,类型(patno/cardno)
/// output:json
/// w ##class(web.DHCSTPharmacyCommon).GetPatientBasicInfo("0000000123","cardno")
ClassMethod GetPatientBasicInfo(inputno, type)
{
    i type="cardno" d
    .s patno=##class(web.DHCOutPhCommon).GetPmiNoFrCardNo(inputno)
    e  s patno=inputno
    q:patno="" "[{}]"
    &sql(select PAPMI_RowId,papmi_name,papmi_sex_dr,nvl(papmi_dob,"") 
    into :patid,:patname,:sexDr,:patbirth from pa_patmas
    where papmi_no=:patno)
    q:SQLCODE "[{}]" 
    i patbirth'="" s patbirth=$zd(patbirth,3)
    e  s patbirth=""
    s patage=##class(PHA.FACE.IN.Com).GetAge(patid,"")               
    s patsex = ##class(PHA.COM.Data.Base).SexDesc(sexDr) 
    s patid=##class(web.DHCSTJQUERYCOMMON).JsonCell("patid",patid)
    s patno=##class(web.DHCSTJQUERYCOMMON).JsonCell("patno",patno)
    s patsex=##class(web.DHCSTJQUERYCOMMON).JsonCell("patsex",patsex)
    s patbirth=##class(web.DHCSTJQUERYCOMMON).JsonCell("patbirth",patbirth)
    s patage=##class(web.DHCSTJQUERYCOMMON).JsonCell("patage",patage)
    s patname=##class(web.DHCSTJQUERYCOMMON).JsonCell("patname",patname)
    s patstring=patid_","_patno_","_patsex_","_patbirth_","_patage_","_patname
    s patstring="[{"_patstring_"}]"
    q patstring
}

/// creator:yunhaibao
/// createdate:201608015
/// description:根据医嘱id获取病人医嘱基本信息
/// input:医嘱ID
/// output:json
/// w ##class(web.DHCSTPharmacyCommon).GetPatientOrdInfo("1339||3")
ClassMethod GetPatientOrdInfo(orditem)
{
    q:orditem="" "[{}]"
    s ord=+orditem
    s itm=$p(orditem,"||",2)
    s paadm=$p(^OEORD(ord),"^",1)
    s patid=$p(^PAADM(paadm),"^",1)
    s patInfo=##class(PHA.COM.Order).GetPatInfo(paadm)
    s patno=$p(patInfo,"^",1)
    s patname = $p(patInfo,"^", 3)
    s patsex = $p(patInfo,"^", 4)
    s patage= $p(patInfo,"^", 5)
    s patbirth = $p(patInfo,"^", 18)
    s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
    s patweight= $p(patInfo,"^", 10)
    s patheight= $p(patInfo,"^", 11)
    s admloc=$p(^PAADM(paadm),"^",4)
    s admlocdesc=##class(PHA.COM.Data.Base).LocDesc(admloc)
    i admlocdesc["-" s admlocdesc=$p(admlocdesc,"-",2)
    s presctitle=##class(PHA.OP.COM.Method).GetPrescTitle(prescno) //处方类型
    s preasonId =$p($g(^OEORD(ord,"I",itm,11)),"^",18)
    s patbilltype=##class(PHA.COM.Data.Base).AdmReasonDesc(preasonId)
    s patid=##class(web.DHCSTJQUERYCOMMON).JsonCell("patid",patid)
    s patno=##class(web.DHCSTJQUERYCOMMON).JsonCell("patno",patno)
    s patname=##class(web.DHCSTJQUERYCOMMON).JsonCell("patname",patname)
    s patsex=##class(web.DHCSTJQUERYCOMMON).JsonCell("patsex",patsex)
    s patbirth=##class(web.DHCSTJQUERYCOMMON).JsonCell("patbirth",patbirth)
    s patweight=##class(web.DHCSTJQUERYCOMMON).JsonCell("patweight",patweight)
    s patheight=##class(web.DHCSTJQUERYCOMMON).JsonCell("patheight",patheight)
    s patage=##class(web.DHCSTJQUERYCOMMON).JsonCell("patage",patage)
    s patbilltype=##class(web.DHCSTJQUERYCOMMON).JsonCell("patbilltype",patbilltype)    
    s prescno=##class(web.DHCSTJQUERYCOMMON).JsonCell("prescno",prescno)
    s admlocdesc=##class(web.DHCSTJQUERYCOMMON).JsonCell("admlocdesc",admlocdesc)
    s presctitle=##class(web.DHCSTJQUERYCOMMON).JsonCell("presctitle",presctitle)
    s patstring1=patid_","_patno_","_patsex_","_patbirth_","_patheight_","_patage
    s patstring2=patname_","_patweight_","_patbilltype_","_prescno_","_admlocdesc_","_presctitle
    s patstring=patstring1_","_patstring2
    s patstring="[{"_patstring_"}]"
    q patstring
}

ClassMethod NewPid()
{
    q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"ST")
}

ClassMethod GetSendMachineFlag(locDr)
{
    q:$g(locDr)="" ""
    s phlocDr=$o(^DHCPL(0,"Loc",locDr,""))
    q:phlocDr="" ""
    s sendmachine=$p($g(^DHCPL(+phlocDr)),"^",31)
    q sendmachine
}

/// Author:     zhaoxinlong
/// Createdate: 2022-4-21
/// Description:依据接收科室获取病区集合(按配置取)
/// Output:病区ID,描述
/// w ##class(web.DHCSTPharmacyCommon).GetWardLocDsByRecLoc("184","","select2")
ClassMethod GetWardLocDsByRecLoc(recLoc, combotext = "", style = "") As %String
{
    //s ^zhxl("GetWardLocDsByRecLoc") = $lb(recLoc, combotext , style)
    s result = ##class(%Library.ResultSet).%New("PHA.STORE.Org:WardLocByRecLoc")
    s sc = result.Execute(recLoc,combotext)
    s retArr = ##class(web.DHCST.Array).%New()
    while($$$ISOK(sc)&&result.Next()){
        s locId = result.%GetData(1)
        s id = $o(^PAWARD(0,"WARD_LocationDR",locId,0))
        continue:(id = "")
        s desc = ##class(PHA.COM.Data.Base).LocDesc(id)
        s dataObj = ##class(web.DHCST.Object).%New()
        s dataObj.id = id
        s dataObj.text = desc
        d retArr.Insert(dataObj)
    }
    q retArr.ToJSON()
}

}

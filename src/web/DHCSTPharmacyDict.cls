/// creator:     yunhaibao
/// createdate:  2018-06-19
/// description: 公共字典,仅为下拉或公共数据的表格
/// return:      均为query
Class web.DHCSTPharmacyDict Extends %RegisteredObject
{

/// deccription:科室组
/// table:      User.DHCStkLocGroup
/// d ##class(%ResultSet).RunQuery("web.DHCSTPharmacyDict","DHCStkLocGroup","50")
Query DHCStkLocGroup(inputStr = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod DHCStkLocGroupExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s phaLoc=$p(inputStr,"^",1)
    s combotext=""
    s inputLen=$l(inputStr,"^")
    i inputLen>1 s combotext=$p(inputStr,"^",inputLen)
    s result=##class(%Library.ResultSet).%New("web.DHCSTKUTIL:GetLocGroupQuery")
    s sc=result.Execute("G",combotext,phaLoc)
    While(result.Next())
    {
        s RowId = result.Data("Rowid") 
        s Description =##class(PHA.COM.Data.Base).LocGroupDesc(RowId)
        d outputRow
    }
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:医生科室
/// table:      User.CTLOC
/// d ##class(%ResultSet).RunQuery("web.DHCSTPharmacyDict","DocLoc","xn")
Query DocLoc(inputStr = "", filterText = "", hosp = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod DocLocExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "", hosp = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s comboText=filterText
    s locId=0
    f  s locId=$o(^CTLOC(locId)) q:locId=""  d
    .s locDesc=$p(^CTLOC(locId),"^",2)
    .q:(locDesc["停")||(locDesc["废")
    .s locConName=$p(^CTLOC(locId),"^",43)
    .q:$p(^CTLOC(locId),"^",5)="Y"
    .q:$p(^CTLOC(locId),"^",13)="D"
    .q:(hosp'="")&&(hosp'=$p(^CTLOC(locId),"^",22))
    .s matchFlag=""
    .i comboText="" s matchFlag=1
    .i (comboText'="")&&($zcvt(locDesc,"U")[$zcvt(comboText,"U")) s matchFlag=1
    .i (comboText'="")&&($zcvt(locConName,"U")[$zcvt(comboText,"U")) s matchFlag=1
    .q:matchFlag=""
    .s locDesc=##class(PHA.COM.Data.Base).LocDesc(locId)
    .d outputRow
    Quit $$$OK
outputRow  
    s Data=$lb(locId,locDesc)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:科室用户
/// d ##class(%ResultSet).RunQuery("web.DHCSTPharmacyDict","LocUser","101")
Query LocUser(inputStr = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod LocUserExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s locId=$p(inputStr,"^",1)
    s userId=0,num=0
    f  s userId=$o(^SSU("SSUSR",userId)) q:userId=""  d
    .s locDr=+$p(^SSU("SSUSR",userId),"^",4)
    .i locId=locDr s LocUserArr(userId)=""
    .s otherUserId=""
    .f  s otherUserId=$o(^SSU("SSUSR",userId,"OTHLL",otherUserId)) q:otherUserId=""  d
    ..s locDr=+$p(^SSU("SSUSR",userId,"OTHLL",otherUserId),"^",1)
    ..i locDr=locId s LocUserArr(userId)=""
    s userId=""
    f  s userId=$o(LocUserArr(userId)) q:userId=""  d
    .s userName=##class(PHA.COM.Data.Base).UserName(userId)
    .s useractive=$p(^SSU("SSUSR",userId),"^",19)  //激活标志
    .q:useractive'="Y"
    .s dateto=$p(^SSU("SSUSR",userId),"^",97)  //过期时间   
    .s dateto=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(dateto)
    .q:(dateto'="")&&(dateto<+$h)
    .s userPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(userName)
    .s matchFlag=""
    .i filterText="" s matchFlag=1
    .i (filterText'="")&&($zcvt(userName,"U")[$zcvt(filterText,"U")) s matchFlag=1
    .i (filterText'="")&&($zcvt(userPY,"U")[$zcvt(filterText,"U")) s matchFlag=1
    .q:matchFlag=""
    .d outputRow
    Quit $$$OK
outputRow  
    s Data=$lb(userId,userName)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:病区
/// table:      User.PACWard
/// d ##class(%ResultSet).RunQuery("web.DHCSTPharmacyDict","PACWard")
Query PACWard(inputStr = "", filterText = "", hosp = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PACWardExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "", hosp = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    i filterText'="" s inputStr=filterText
    s inputStr=$zcvt(inputStr,"U")
    s warddr=0
    f  s warddr=$o(^PAWARD(warddr)) q:(warddr="")||(+warddr=0)  d
    .s warddesc=$p(^PAWARD(warddr),"^",2)
    .s locdr=$p(^PAWARD(warddr),"^",5)
    .q:locdr=""
    .q:$p(^CTLOC(locdr),"^",5)'="Y"
    .q:(hosp'="")&&(hosp'=$p(^CTLOC(locdr),"^",22))
    .s locconname=$zcvt($p(^CTLOC(locdr),"^",43),"U")
    .s warddescpy=##class(web.DHCST.Common.AppCommon).GetCNCODE(warddesc)
    .q:(inputStr'="")&&($zcvt(warddesc,"U")'[inputStr)&&(locconname'[inputStr)&&(warddescpy'[inputStr)
    .q:warddesc=""
    .s warddesc=##class(PHA.COM.Data.Base).WardDesc(warddr)
    .d outputRow
    Quit $$$OK
outputRow  
    s Data=$lb(warddr,warddesc)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:药房-规范写法
/// input:      
/// d ##class(%ResultSet).RunQuery("web.DHCSTPharmacyDict","PhaLoc","250")
Query PhaLoc(inputStr = "", filterText = "", hosp = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PhaLocExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "", hosp = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s comboText=$p(inputStr,"^",1)
    s ind=1
    s phaLocId=""
    f  s phaLocId=$o(^DHCPL(phaLocId)) q:phaLocId=""  d
    .q:+phaLocId=0
    .s locId=$p(^DHCPL(phaLocId),"^",1)
    .q:locId=""
    .s PhaLocData(locId)=""
    s phLocId=""
    f  s phLocId=$o(^DHCPHLOC(phLocId)) q:phLocId=""  d
    .q:+phLocId=0
    .s locId=$p(^DHCPHLOC(phLocId),"^",1)
    .q:locId=""
    .s PhaLocData(locId)="" 
    s locId=""
    f  s locId=$o(PhaLocData(locId)) q:locId=""  d
    .q:'$d(^CTLOC(locId))
    .s frDate=$p(^CTLOC(locId),"^",24)
    .q:(frDate'="")&&(frDate>(+$h)) 
    .s toDate=$p(^CTLOC(locId),"^",25)
    .q:(toDate'="")&&(toDate<(+$h)) 
    .s locDesc=##class(PHA.COM.Data.Base).LocDesc(locId)
    .s hospID=$p(^CTLOC(locId),"^",22)
    .q:(hosp'="")&&(hosp'=hospID)
    .d outputRow
    Quit $$$OK
outputRow  

    s Data=$lb(locId,locDesc)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:所有科室
/// table:      User.CTLOC
/// input:      inputStr^1:科室类型
/// d ##class(%ResultSet).RunQuery("web.DHCSTPharmacyDict","CtLoc","xn")
Query CtLoc(inputStr = "", filterText = "", hosp = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod CtLocExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "", hosp = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s comboText=filterText
    s locType=$p(inputStr,"^",1)
    s locId=0
    f  s locId=$o(^CTLOC(locId)) q:locId=""  d
    .s locDesc=$p(^CTLOC(locId),"^",2)
    .q:(locDesc["停")||(locDesc["废")
    .q:(locType'="")&&(locType'=$p(^CTLOC(locId),"^",13))
    .q:(hosp'="")&&(hosp'=$p(^CTLOC(locId),"^",22))
    .s locConName=$p(^CTLOC(locId),"^",43)
    .s matchFlag=""
    .i comboText="" s matchFlag=1
    .i (comboText'="")&&($zcvt(locDesc,"U")[$zcvt(comboText,"U")) s matchFlag=1
    .i (comboText'="")&&($zcvt(locConName,"U")[$zcvt(comboText,"U")) s matchFlag=1
    .q:matchFlag=""
    .s locDesc = ##class(PHA.COM.Data.Base).LocDesc(locId)
    .d outputRow
    Quit $$$OK
outputRow  
    s Data=$lb(locId,locDesc)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// description: 库存项对应单位
/// deccription:所有科室
/// table:      User.CTLOC
/// d ##class(%ResultSet).RunQuery("web.DHCSTPharmacyDict","IncUom","858")
Query IncUom(inputStr = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod IncUomExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s incId=$p(inputStr,"^",1)
    q:+incId=0 $$$OK
    s pUomId=$p(^INCI(incId,3),"^",6)
    i pUomId'="" d
    .s pUomDesc=##class(PHA.COM.Data.Base).UomDesc(pUomId)
    .s Data=$lb(pUomId,pUomDesc)
    .s ^CacheTemp(repid,ind)=Data    
    .s ind=ind+1
    s bUomId=$p(^INCI(incId,1),"^",10)
    i (bUomId'="")&&(pUomId'="")&&(pUomId'=bUomId) d
    .s bUomDesc=##class(PHA.COM.Data.Base).UomDesc(bUomId)
    .s Data=$lb(bUomId,bUomDesc)
    .s ^CacheTemp(repid,ind)=Data    
    .s ind=ind+1
    q $$$OK
}

/// deccription:退药原因
/// table:      退药原因取计费组退费原因表-DHC_INVOPRefReason
/// d ##class(%ResultSet).RunQuery("web.DHCSTPharmacyDict","RetReason")
Query RetReason(inputStr = "", filterText = "", hospId As %String = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod RetReasonExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "", hospId As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    i filterText'="" s inputStr=filterText
    s inputStr=$zcvt(inputStr,"U")
    s retreasondr=""
    f  s retreasondr=$o(^DHCINVOPREFR(retreasondr)) q:retreasondr=""  d
    .s retreasondesc=""
    .s retreasondesc=##class(PHA.COM.Data.Base).OPRetReasonDesc(retreasondr)
    .s hospId=##class(PHA.FACE.IN.Com).GetDefHospIdByTableName("Bill_OP_RefInvReason",hospId)
    .s hospDr=$p(^DHCINVOPREFR(retreasondr),"^",3)
    .q:(hospId'="")&&(hospDr'="")&&(hospId'=hospDr)
    .q:(inputStr'="")&&($zcvt(retreasondesc,"U")'[inputStr) 
    .q:retreasondesc=""
    .d outputRow
    Quit $$$OK
outputRow  
    s Data=$lb(retreasondr,retreasondesc)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:药品列表
/// table:      User.IncItm
/// input:      inputStr^1:库存项Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPharmacyDict","IncItm","","amxl")
Query IncItm(inputStr = "", filterText = "") As websys.Query(ROWSPEC = "incRowId,incCode,incDesc,incSpec")
{
}

ClassMethod IncItmExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    //q:inputParams="" $$$OK
    s IncId=$p(inputStr,"^",1)
    s LocId=$p(inputStr,"^",2)  
    q:(IncId="")&&(filterText="") $$$OK
    s filterText="%"_$$ALPHAUP^SSUTIL4(filterText)_"%"
    s result = ##class(%Library.ResultSet).%New()
    s StkGrpType="G"
    if (IncId'="") {
        s sqlStr ="select inci_rowid as incId from inc_itm  where inci_RowId='"_IncId_"'"
    }else {
        s sqlStr ="select distinct inca_inci_dr as incId from inc_alias "_
        "where %ALPHAUP(inca_text) like '"_filterText_"' and inca_inci_dr->inci_incsc_dr in "_ 
        "(Select scgr_stkcat_dr from dhc_stkcatgrprelations Where scgr_scg_parref->SCG_Type='"_StkGrpType_"')"
    }
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s incId = result.Data("incId")
        continue:(LocId'="")&&('$d(^INCI("IL_LOC",LocId,incId)))
        s incDesc=##class(PHA.COM.Data.Base).InciDesc(incId)
        s incCode=$p(^INCI(incId,1),"^",1)
        s itmAdd=$o(^DHCITMINFO(0,"INCI",incId,"")) 
        s incSpec=$p($g(^DHCITMINFO(+itmAdd)),"^",27)
        continue:incDesc=""
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

}

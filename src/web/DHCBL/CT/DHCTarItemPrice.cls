Import SQLUser

/// 名称:收费项目查询
/// 描述:查询医嘱项与对应的库存项信息，并维护关联收费项
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2016-04-01
Class web.DHCBL.CT.DHCTarItemPrice Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "DHC_TarItemPrice";

/// Function: 获取收费项价格
/// CreateDate: 2016-4-15
/// Creator:  陈莹
/// Debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarItemPrice","GetList","10","")
Query GetList(TARIRowId As %String, rowid As %String) As %Query(ROWSPEC = "TPRowId:%String, TPTARIParRef:%String,TPStartDate:%String, TPEndDate:%String, TPPrice:%String, TPUpdateUser:%String, TPUpdateDate:%String, TPUpdateTime:%String,  TPPatInsType:%String, TPPatInsTypeDesc:%String,TPAlterPrice1:%String, TPAlterPrice2:%String, TPHospitalDR:%String,TPHospitalDRDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, TARIRowId As %String, rowid As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
 
    if (TARIRowId'="") 
    {
        s TPTARIParRef=TARIRowId
        s TPChildSub=""
        ;倒序查询
        for
        {
            s TPChildSub=$o(^DHCTARI(TARIRowId,"P",TPChildSub),-1)  q:(TPChildSub=0)||(TPChildSub="")
            s TPRowId=TARIRowId_"||"_TPChildSub
            s TPStartDate=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",3)
            s TPEndDate=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",4)
            s TPPatInsType=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",13)  //PACAdmReason
            s:TPPatInsType="" TPPatInsTypeDesc=""
            s:TPPatInsType'="" TPPatInsTypeDesc=$p($g(^PAC("ADMREA",TPPatInsType)),"^",2)

            s TPPrice=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",5)
            s TPAlterPrice1=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",14)
            s TPAlterPrice2=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",15)

            if $e(TPPrice,1)="." s TPPrice="0"_TPPrice
            if $e(TPAlterPrice1,1)="." s TPAlterPrice1="0"_TPAlterPrice1
            if $e(TPAlterPrice2,1)="." s TPAlterPrice2="0"_TPAlterPrice2
            s TPUpdateUser=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",8)
            s:TPUpdateUser'="" TPUpdateUser=$p($g(^SSU("SSUSR",TPUpdateUser)),"^",2)

            s TPUpdateDate=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",9)
            s TPUpdateTime=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",10)
            s TPHospitalDR=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",16)
            s TPHospitalDRDesc=""
            s:TPHospitalDR=0 TPHospitalDR=""
            s:TPHospitalDR=0 TPHospitalDRDesc=""
            s:TPHospitalDR'="" TPHospitalDRDesc=$p($g(^CT("HOSP",TPHospitalDR)),"^",2)

            s:TPUpdateTime'="" TPUpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(TPUpdateTime)
            s:TPUpdateDate'="" TPUpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TPUpdateDate)
            s:TPStartDate'="" TPStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TPStartDate)
            s:TPEndDate'="" TPEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TPEndDate)
            
            //s TPNoteText=$p($g(^DHCTARI(TARIRowId,"P",TPChildSub)),"^",17)
            d OutputRowPrice
        }
    }

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowPrice
    set Data=$lb(TPRowId,TPTARIParRef,TPStartDate,TPEndDate,TPPrice, TPUpdateUser, TPUpdateDate, TPUpdateTime,  TPPatInsType, TPPatInsTypeDesc,TPAlterPrice1, TPAlterPrice2, TPHospitalDR,TPHospitalDRDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator:陈莹
/// CreatDate:2016-4-15
/// Description:判断这个医院，收费项价格开始日期能不能为今天
/// Table:User.OEOrdItem
/// 空为今天没开过，其他值为开过
/// w ##class(web.DHCBL.CT.DHCTarItemPrice).GetTariPriceRowID("1","3")
ClassMethod GetTariPriceRowID(TariRowID, HospID) As %String
{
    n (TariRowID,HospID)
    q:TariRowID="" ""
    s userflag=""
    
    ///判断医嘱执行记录表
    //^OEORDi(0,"DateARCIM",{OEORE_ExStDate},OEORIItmMastDR,{OE_Order.OEORD_RowId},{OE_OrdItem.OEORI_Childsub},{OEORE_Childsub})
    //医嘱的无效状态：  作废，门急诊的停止、撤销， 还没有加判断
    
    
    k ^TMPTARILinkedARCIM
    s linkcount=0
    ///获取与收费项有有效关联的医嘱项 (关联开始日期早于或等于今天， 结束日期 晚于或等于今天)
    s tStDate=0
    for
    { 
        s tStDate=$o(^DHCOLT(0,"TAR",TariRowID,tStDate)) Quit:tStDate=""
        if (tStDate<=+$h)
        {
            set OLTRowid=0
            for
            {
                s OLTRowid=$o(^DHCOLT(0,"TAR",TariRowID,tStDate,OLTRowid)) Quit:(OLTRowid="")
                s ARCIMRowId=$p($G(^DHCOLT(OLTRowid)),"^",1)
                continue:ARCIMRowId=""
                s OLTEndDate=$p($g(^DHCOLT(OLTRowid)),"^",5)        
                if ((OLTEndDate="")||((OLTEndDate'="")&&(OLTEndDate>=+$h)))
                {
                    s linkcount=linkcount+1
                    s ^TMPTARILinkedARCIM(ARCIMRowId)=OLTRowid
                }
            }
        }
    }
    if linkcount>0
    {
        ////先查询医嘱执行记录（考虑长期医嘱 )
        s Date=+$h
        s ARCIMRowId=0
        for
        {
            s ARCIMRowId=$o(^TMPTARILinkedARCIM(ARCIMRowId)) q:(ARCIMRowId="")||(userflag=1)
            s OEORDRowId=0
            for
            {
                s OEORDRowId=$o(^OEORDi(0,"DateARCIM",Date,ARCIMRowId,OEORDRowId)) q:(OEORDRowId="")||(userflag=1)
                s OEORIChildsub=0
                for
                {
                    s OEORIChildsub=$o(^OEORDi(0,"DateARCIM",Date,ARCIMRowId,OEORDRowId,OEORIChildsub)) q:(OEORIChildsub="")||(userflag=1)   ///User.OEOrdItem  医嘱表
                    //2020-03-05 chenying add本医院组没有开过，其他医院开过，允许本院调价
                    if HospID'=""
                    {
                        s AdmRowid=$p($G(^OEORD(OEORDRowId)),"^",1)  //患者信息表 id
                        continue:AdmRowid=""
                        s admDep=$p($G(^PAADM(AdmRowid)),"^",4) //就诊科室
                        continue:(admDep="")
                        //s CTLOCHospitalDR=$p($g(^CTLOC(admDep)),"^",22)   
                        //CONTINUE:CTLOCHospitalDR'=HospID
                        s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlagSpecial("CT_Loc",admDep,HospID,"","DHC_TarItemPrice")
                        continue:showflag="N"
                    }
                    s userflag=1      //说明当天有用到该收费项相关的医嘱项，所以不允许当天生效
                }
            }
        }
        
        if (userflag="")
        {
            //^OEORDi(0,"ItemDate",{OEORI_Date},{OE_Order.OEORD_RowId},{OEORI_Childsub})
            ///医嘱表，考虑挂号费可能 不在医嘱执行记录里
            s OEORDRowId=0
            for
            {
                s OEORDRowId=$o(^OEORDi(0,"ItemDate",Date,OEORDRowId)) q:(OEORDRowId="")||(userflag=1)  //User.OEOrder
                s OEORIChildsub=0
                for
                {
                    s OEORIChildsub=$o(^OEORDi(0,"ItemDate",Date,OEORDRowId,OEORIChildsub)) q:(OEORIChildsub="")||(userflag=1)   ///User.OEOrdItem  医嘱表
                    S OEORIItmMastDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)  //医嘱项id
                    //2020-03-05 chenying add本医院组没有开过，其他医院开过，允许本院调价
		    continue:OEORIItmMastDR=""
                    if $d(^TMPTARILinkedARCIM(OEORIItmMastDR))>0  //属于本收费项关联的医嘱项范围内时
                    {
                        if HospID'=""  //医院不为空时判断当前医院或医院组是否有开过，如果医院为空则有医院开过就限制
                        {
                            s AdmRowid=$p($G(^OEORD(OEORDRowId)),"^",1)  //患者信息表 id
                            continue:AdmRowid=""
                            s admDep=$p($G(^PAADM(AdmRowid)),"^",4) //就诊科室
                            continue:(admDep="")
                            continue:('$d(^CTLOC(admDep)))
                            //s CTLOCHospitalDR=$p($g(^CTLOC(admDep)),"^",22)   
                            //CONTINUE:CTLOCHospitalDR'=HospID
                            s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlagSpecial("CT_Loc",admDep,HospID,"","DHC_TarItemPrice")
                            continue:showflag="N"
                        }
                        s userflag=1      //说明当天有用到该收费项相关的医嘱项，所以不允许当天生效
                    }
                }
            }
        }
    }
    k ^TMPTARILinkedARCIM
    q userflag
}

/// 判断医嘱项是否已经有开出医嘱 
/// Return:Y:是，N:否
/// w ##class(web.DHCBL.CT.DHCTarItemPrice).GetOrderLinkFlag("1||1")
ClassMethod GetOrderLinkFlag(OLTARCIMDR) As %String
{
    n (OLTARCIMDR)
    q:OLTARCIMDR="" "N"
    s OrderFlag="Y"
    i $d(^DHCPBi(0,"ARCIM",OLTARCIMDR)) s OrderFlag="Y"
    e  s OrderFlag="N"
    q OrderFlag
}

/// Creator:陈莹
/// CreatDate:2016-4-15
/// Description:保存收费项价格
/// Table:User.DHCTarItemAlias
/// Input: 收费项rowid, 费别^价格^开始日期^结束日期^辅助价格1^辅助价格2^医院
/// Return:成功返回"{success:'true',info:'保存成功！'}";失败返回"{success:'false',errorinfo:'保存失败！'}"
/// Other:w ##class(web.DHCBL.CT.DHCTarItemPrice).SaveAll("67","1^22^2019-08-10^^^^2&#1^20^2019-08-06^^^^2")
ClassMethod SaveAll(rowid As %String, AddPriceStr As %String) As %String
{
    n (rowid,AddPriceStr,%session)
    s result="" 
    s msg=0,rs=""
    IF AddPriceStr'=""
    {
        s length=$l(AddPriceStr,"&#")
        
        for i=1:1:length
        {
            s DataStr=$p(AddPriceStr,"&#",i)
            s eobj = ##class(web.Entity.CT.DHCTarItemPrice).%New()
            s eobj.TPTARIParRef=rowid
            s eobj.TPPatInsType=$p(DataStr,"^",1)
            s eobj.TPPrice=$p(DataStr,"^",2)
            s eobj.TPStartDate=$p(DataStr,"^",3)
            s eobj.TPEndDate=$p(DataStr,"^",4)
            s eobj.TPAlterPrice1=$p(DataStr,"^",5)
            s eobj.TPAlterPrice2=$p(DataStr,"^",6)
            s eobj.TPHospitalDR=$p(DataStr,"^",7)
            s ret=..SaveEntity(eobj)
            if (ret["false")
            {
                s msg=1
                s rs=ret
            }
        }
        if (msg=0)
        {
            s result= "{success:'true',info:'保存成功！'}"
        }
        else
        {
            s result= rs
        }
    }
    ELSE
    {
        s result= "{success:'true',info:'没有数据！'}"
    }
    q result
}

/// CHENYING
/// CreatDate:2016-4-15
/// 保存收费项子表 收费项价格
/// User.DHCTarItemPrice
/// w ##class(web.DHCBL.CT.DHCTarItemPrice).SaveEntity(preobj)
ClassMethod SaveEntity(preobj As web.Entity.CT.DHCTarItemPrice, ImportFlag As %String = "") As %String
{
    N (preobj,ImportFlag,%session)
    s result2=""
    s:preobj.TPStartDate'="" preobj.TPStartDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(preobj.TPStartDate)
    s:preobj.TPEndDate'="" preobj.TPEndDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(preobj.TPEndDate)
    s:preobj.TPStartDate="" preobj.TPStartDate=+$h
    if (preobj.TPPatInsType="") Quit "{success:'false',errorinfo:'费别不允许为空'}"
    if preobj.TPHospitalDR=""
    {
        if $d(%session) s preobj.TPHospitalDR=$Get(%session.Data("LOGON.HOSPID"))
    }
    if preobj.TPUpdateUser=""
    {
        if $d(%session) s preobj.TPUpdateUser=$Get(%session.Data("LOGON.USERID"))
    }
    //增加
    if (preobj.TPRowId="")&(preobj.TPTARIParRef'="")    
    {
        s ppobj=##class(User.DHCTarItemPrice).%New(preobj.TPTARIParRef)
        d ppobj.TPTARIParRefSetObjectId(preobj.TPTARIParRef)
        s ppobj.TPStartDate = preobj.TPStartDate 
        s ppobj.TPEndDate = preobj.TPEndDate 
        if ImportFlag=""
        {
            if (preobj.TPStartDate'="")&&(preobj.TPStartDate <+$h)
            {
                Quit "{success:'false',errorinfo:'调价开始日期不允许早于当前日期'}"
            }
            elseif (preobj.TPStartDate =+$h)
            {
                s PriceConfig=..GetTariPriceRowID(preobj.TPTARIParRef,preobj.TPHospitalDR)
                Quit:(PriceConfig'="") "{success:'false',errorinfo:'今日此收费项有开出过,不允许当天调价'}"
            }
        }
        s ppobj.TPPrice = preobj.TPPrice
        s ppobj.TPAlterPrice1 = preobj.TPAlterPrice1
        s ppobj.TPAlterPrice2 = preobj.TPAlterPrice2    
        d ppobj.TPPatInsTypeSetObjectId(preobj.TPPatInsType)
        s ppobj.TPUpdateDate=+$h
        s ppobj.TPUpdateTime=$p($h,",",2)
        d ppobj.TPHospitalDRSetObjectId(preobj.TPHospitalDR)
        
        d ppobj.TPUpdateUserSetObjectId(preobj.TPUpdateUser)
        
        Tstart
        s sc=ppobj.%Save()
        do ppobj.%Close()
        if $$$ISOK(sc){
            Tcommit
            s tpid = ppobj.%Id()
            s result2 = "{success:'true',id:'"_tpid_"'}"
            s TARIDesc=$p($g(^DHCTARI(preobj.TPTARIParRef)),"^",2)
            s READesc=""
            s:preobj.TPPatInsType'="" READesc=$p($g(^PAC("ADMREA",preobj.TPPatInsType)),"^",2)
        
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarItemPrice","User.DHCTarItemPrice","收费项目价格",tpid,TARIDesc_"-"_READesc,"A",preobj)      
            
            //更新同费别的最后一条价格结束日期为新数据的结束日期前一天，最早为当天2018-04-02 沧州人民
            s flag=0
            s sub=$p(tpid,"||",2)
            for
            {
                s sub=$o(^DHCTARI(preobj.TPTARIParRef,"P",sub),-1) Q:(sub=0)||(sub="")||(flag=1)
                s pattype=$p($g(^DHCTARI(preobj.TPTARIParRef,"P",sub)),"^",13)
                s TPHospitalDR=$p($g(^DHCTARI(preobj.TPTARIParRef,"P",sub)),"^",16)
                ///同病人费别 同医院
                if (pattype=preobj.TPPatInsType)&&(preobj.TPHospitalDR=TPHospitalDR)
                {
                    s TPStartDate=$p($g(^DHCTARI(preobj.TPTARIParRef,"P",sub)),"^",3)
                    s TPEndDate=$p($g(^DHCTARI(preobj.TPTARIParRef,"P",sub)),"^",4)
                    if (TPStartDate<=ppobj.TPStartDate)&&(TPEndDate="")
                    {
                        s date=ppobj.TPStartDate-1
                        if date<+$h s date=+$h
                        s lastpriceid=preobj.TPTARIParRef_"||"_sub
                        &sql(update DHC_TarItemPrice(TP_EndDate) values (:date) where TP_RowId=:lastpriceid)
                        if (SQLCODE=0)
                        {
                            s flag=1
                        }
                    }
                }
            }
            
        
        }else{
            Trollback
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("收费项目价格","web.DHCBL.CT.DHCTarItemPrice","SaveEntity",preobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            s result2 = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
        }               
    }
    else
    {
        s result2 = "{success:'false',errorinfo:'ParRef为空！'}"
    }
    q result2
}

/// Creator：陈莹
/// CreatDate: 2021-06-10
/// Description：修改 项目上自己导入过价格数据后，在前台维护时报uniqueindex的报错
/// Table：User.DHCTarItemPrice
/// flag=0时 查看错误数据，flag=1时处理错误数据
/// Other:d ##class(web.DHCBL.CT.DHCTarItemPrice).RepairError(0)
///       d ##class(web.DHCBL.CT.DHCTarItemPrice).RepairError(1)
ClassMethod RepairError(flag) As %String
{
    
    s TARIRowId=0
    for 
    {
        s TARIRowId=$o(^DHCTARI(TARIRowId)) q:(TARIRowId="")
        s ChildSub=$g(^DHCTARI(TARIRowId,"P",0))
        s realsub=$o(^DHCTARI(TARIRowId,"P",""),-1)
        if (realsub'="")&&(realsub'=0)&&((ChildSub="")||((realsub>ChildSub)&&(ChildSub'=""))) 
        {
            if (flag=0) W TARIRowId_" "_$p($g(^DHCTARI(TARIRowId)),"^",1)_" "_$p($g(^DHCTARI(TARIRowId)),"^",2),!
            if (flag=1) s ^DHCTARI(TARIRowId,"P",0)=realsub
        }
    }
}

/// Desctiption:保存收费项价格
/// CreatDate:  2023-1-9
/// Creator:    sunfengchao
/// Table:      User.DHCTarItemPrice
/// Input:      TARIRowId:收费项id , DataStr： 患者费别(默认全自费)^标准价格^开始日期^结束日期^价格1^价格2^医院  
/// Others:     w ##class(web.DHCBL.CT.DHCTarItemPrice).SaveTarPrice(1,"1^2^2023-02-20^^^^2")
ClassMethod SaveTarPrice(TARIRowId As %String, DataStr As %String, ImportFlag As %String = "") As %String
{
    new (TARIRowId,DataStr,ImportFlag,%session)
    q:(TARIRowId="")||(DataStr="") "{""success"":""false"",""errorinfo"":""收费项id或价格数据不允许为空""}" 
    s result2=""
    s preobj = ##class(web.Entity.CT.DHCTarItemPrice).%New()
    s preobj.TPTARIParRef=TARIRowId
    s preobj.TPPatInsType=$p(DataStr,"^",1)
    s preobj.TPPrice=$p(DataStr,"^",2)
    s preobj.TPStartDate=$p(DataStr,"^",3)
    s preobj.TPEndDate=$p(DataStr,"^",4)
    s preobj.TPAlterPrice1=$p(DataStr,"^",5)
    s preobj.TPAlterPrice2=$p(DataStr,"^",6)
    s preobj.TPHospitalDR=$p(DataStr,"^",7)
    
    s:preobj.TPStartDate'="" preobj.TPStartDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(preobj.TPStartDate)
    s:preobj.TPEndDate'="" preobj.TPEndDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(preobj.TPEndDate)
    s:preobj.TPStartDate="" preobj.TPStartDate=+$h
    if (preobj.TPPatInsType="") Quit "{""success"":""false"",""errorinfo"":""费别不允许为空""}"  
    if preobj.TPHospitalDR=""
    {
        if $d(%session) s preobj.TPHospitalDR=$Get(%session.Data("LOGON.HOSPID"))
    }
    if preobj.TPUpdateUser=""
    {
        if $d(%session) s preobj.TPUpdateUser=$Get(%session.Data("LOGON.USERID"))
    }
    //增加
    if (preobj.TPRowId="")&(preobj.TPTARIParRef'="")    
    {
        s ppobj=##class(User.DHCTarItemPrice).%New(preobj.TPTARIParRef)
        d ppobj.TPTARIParRefSetObjectId(preobj.TPTARIParRef)
        s ppobj.TPStartDate = preobj.TPStartDate 
        s ppobj.TPEndDate = preobj.TPEndDate  
        if ImportFlag=""
        {
            if (preobj.TPStartDate'="")&&(preobj.TPStartDate <+$h)
            {
                Quit "{""success"":""false"",""errorinfo"":""调价开始日期不允许早于当前日期""}"  
            }
            elseif (preobj.TPStartDate =+$h)
            {
                s PriceConfig=..GetTariPriceRowID(preobj.TPTARIParRef,preobj.TPHospitalDR)
                Quit:(PriceConfig'="") "{""success"":""false"",""errorinfo"":""今日此收费项有开出过,不允许当天调价""}"   
            } 
        }
        s ppobj.TPPrice = preobj.TPPrice
        s ppobj.TPAlterPrice1 = preobj.TPAlterPrice1
        s ppobj.TPAlterPrice2 = preobj.TPAlterPrice2    
        d ppobj.TPPatInsTypeSetObjectId(preobj.TPPatInsType)
        s ppobj.TPUpdateDate=+$h
        s ppobj.TPUpdateTime=$p($h,",",2)
        d ppobj.TPHospitalDRSetObjectId(preobj.TPHospitalDR) 
        d ppobj.TPUpdateUserSetObjectId(preobj.TPUpdateUser)
        
        Tstart
        s sc=ppobj.%Save()
        do ppobj.%Close()
        if $$$ISOK(sc){
            Tcommit
            s tpid = ppobj.%Id()
            s result2 = "{""success"":""true"",""id"":"""_tpid_"""}"
            s TARIDesc=$p($g(^DHCTARI(preobj.TPTARIParRef)),"^",2)
            s READesc=""
            s:preobj.TPPatInsType'="" READesc=$p($g(^PAC("ADMREA",preobj.TPPatInsType)),"^",2) 
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarItemPrice","User.DHCTarItemPrice","收费项目价格",tpid,TARIDesc_"-"_READesc,"A",preobj)      
            
            //更新同费别的最后一条价格结束日期为新数据的结束日期前一天，最早为当天
            s flag=0
            s sub=$p(tpid,"||",2)
            for
            {
                s sub=$o(^DHCTARI(preobj.TPTARIParRef,"P",sub),-1) Q:(sub=0)||(sub="")||(flag=1)
                s pattype=$p($g(^DHCTARI(preobj.TPTARIParRef,"P",sub)),"^",13)
                s TPHospitalDR=$p($g(^DHCTARI(preobj.TPTARIParRef,"P",sub)),"^",16)
                ///同病人费别 同医院
                if (pattype=preobj.TPPatInsType)&&(preobj.TPHospitalDR=TPHospitalDR)
                {
                    s TPStartDate=$p($g(^DHCTARI(preobj.TPTARIParRef,"P",sub)),"^",3)
                    s TPEndDate=$p($g(^DHCTARI(preobj.TPTARIParRef,"P",sub)),"^",4)
                    if (TPStartDate<=ppobj.TPStartDate)&&(TPEndDate="")
                    {
                        s date=ppobj.TPStartDate-1
                        if date<+$h s date=+$h
                        s lastpriceid=preobj.TPTARIParRef_"||"_sub
                        &sql(update DHC_TarItemPrice(TP_EndDate) values (:date) where TP_RowId=:lastpriceid)
                        if (SQLCODE=0)
                        {
                            s flag=1
                        }
                    }
                }
            } 
        }
        else{
            Trollback
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("收费项目价格","web.DHCBL.CT.DHCTarItemPrice","SaveEntity",preobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            s result2 = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
        }               
    }
    else
    {
        s result2 = "{""success"":""false"",""errorinfo"":""ParRef为空""}"  
    }
    q result2
}

}

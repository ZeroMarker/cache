/// 名称:医嘱项维护
/// 描述:包含增\删\改\查功能
/// 编写者基础数据平台组-陈莹
/// 编写日期: 2012-9-6
Class web.DHCBL.CT.ARCItmMast Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "ARC_ItmMast";

/// Function: 医嘱项查询方法,分页
/// Creator: sunfengchao,chenying
/// CreateDate: 2015-5-6
/// P1代码,P2描述,P3药物查找,P4别名,P5账单组,P6账单子组,P7医嘱子类,P8服务组,enableflag可用标志,ownflag独立医嘱标志,ordercat医嘱大类
/// debug: w ##class(web.DHCBL.CT.ARCItmMast).GetList("","" ,"","","","","","","","",0,20,"A","A","","","","","")
ClassMethod GetList(ID As %String, P1 As %String, P2 As %String, P3 As %String, P4 As %String, P5 As %String, P6 As %String, P7 As %String, P8 As %String, start, limit, enableflag, ownflag, sort, dir, ordercat, datefrom, hospid, limittype) As %String
{
    if (ID'="") 
    {
        s Result= ##class(web.DHCBL.CT.ARCItmMast).GetItmByRowID(ID,hospid)
        w "{""data"":["_Result_"],""total"":""1"",""success"":""true""}"
    }
    else
    {
        s code=P1   //1代码
        s desc=P2   //2描述
        s drug=P3  //3药物代码  ;不用了
        s alias=P4  //4别名
        s billgrp=P5    //5账单组
        s billsub=P6    //6账单子组
        s itemcat=P7    //7医嘱子类
        s service=P8    //8服务组
        s:code'="" code=$zcvt(code,"U")
        s:desc'="" desc=$zcvt(desc,"U")
        s:drug'="" drug=$zcvt(drug,"U")
        s:alias'="" alias=$zcvt(alias,"U")
        s:datefrom'="" datefrom= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)
        s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
        s AuStr=##class(web.DHCBL.Authorize.ARCItmMast).DHCGetDataByDefaultSession()
        //如果登录医院不等于医院组，要判断医院级授权是不是只有登录医院的权限，要能看到医院组的医嘱项数据。
        s HOSPID=""
        if $d(%session) s HOSPID=$g(%session.Data("LOGON.HOSPID"))
        s DefHospId= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(..#SQLTableName,HOSPID,"")
        s strHOSPID="{ID:"_HOSPID_"}"
        
        if ($l(AuStr,"#")=1) {
            s Limited=0
            s AutBit=""
        }
        elseif ($l(AuStr,"#")=2) {
            s Limited=$p(AuStr,"#",1)
            s AutBit=$p(AuStr,"#",2)
        }
        s AuFlag=0
        if (AuStr="")||((AuStr'="")&(Limited=0)) s AuFlag=1 //判断是否有授权,如果没有则全部显示
        
        s ARCIMItemCatDRAuStr=##class(web.DHCBL.Authorize.ARCItemCat).DHCGetDataByDefaultSession()
        s ARCIMItemCatDRAuFlag=0
        ;医嘱子分类
        if (ARCIMItemCatDRAuStr="")||(ARCIMItemCatDRAuStr["limited:0") s ARCIMItemCatDRAuFlag=1

        s ARCIMBillingUOMDRAuStr=##class(web.DHCBL.Authorize.CTUOM).DHCGetDataByDefaultSession()
        s ARCIMBillingUOMDRAuFlag=0
        ;单位
        if (ARCIMBillingUOMDRAuStr="")||(ARCIMBillingUOMDRAuStr["limited:0") s ARCIMBillingUOMDRAuFlag=1

        s ARCIMBillGrpRowIdAuStr=##class(web.DHCBL.Authorize.ARCBillGrp).DHCGetDataByDefaultSession()
        s ARCIMBillGrpRowIdAuFlag=0
        ;账单组
        if (ARCIMBillGrpRowIdAuStr="")||(ARCIMBillGrpRowIdAuStr["limited:0") s ARCIMBillGrpRowIdAuFlag=1

        s ARCIMDefPriorityDRAuStr=##class(web.DHCBL.Authorize.OECPriority).DHCGetDataByDefaultSession()
        s ARCIMDefPriorityDRAuFlag=0
        ;医嘱优先级
        if (ARCIMDefPriorityDRAuStr="")||(ARCIMDefPriorityDRAuStr["limited:0") s ARCIMDefPriorityDRAuFlag=1

        s ARCIMDerFeeRulesDRAuStr=##class(web.DHCBL.Authorize.ARCDerivedFeeRules).DHCGetDataByDefaultSession()
        s ARCIMDerFeeRulesDRAuFlag=0
        ;收费规定
        if (ARCIMDerFeeRulesDRAuStr="")||(ARCIMDerFeeRulesDRAuStr["limited:0") s ARCIMDerFeeRulesDRAuFlag=1

        s ARCIMServiceGroupDRAuStr=##class(web.DHCBL.Authorize.RBCServiceGroup).DHCGetDataByDefaultSession()
        s ARCIMServiceGroupDRAuFlag=0
        ;服务组
        if (ARCIMServiceGroupDRAuStr="")||(ARCIMServiceGroupDRAuStr["limited:0") s ARCIMServiceGroupDRAuFlag=1
        
        
        if sort="" s sort="ARCIMRowId"
        k ^TMP("BDPARCIM")  //记录查询出的数据
        k ^TMPARCIM  //查询临时用
        s ARCIMSubscript=0
        for
        {
            s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:(ARCIMSubscript="")
            s ARCIMVersion=0
            for 
            {
                s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:(ARCIMVersion="")
                s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
                
                //代码过滤
                s ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)                  ;代码
                continue:($zcvt(ARCIMCode,"U")'[code)
                
                //名称过滤
                s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)                  ;描述
                continue:($zcvt(ARCIMDesc,"U")'[desc)  
                
                //别名过滤
                if (alias'="")
                {
                    s AliasFlag=0
                    s ALIASText1=""
                    s ALIASRowId=0,ALIASText1=""
                    for 
                    {
                        s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId))             ;别名
                        q:ALIASRowId=""
                        s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
                        s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")_"^"_$$ALPHAUP^SSUTIL4(ALIASText)
                    }
                    if (ALIASText1[alias) s AliasFlag=1
                    continue:(AliasFlag'=1)
                }
                
                //医院过滤
                if hospid'=""
                {
                    s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCIMRowId,hospid)
                    continue:showflag="N"
                }
                else
                {
                    ; 遍历 医院子表，查询医院dr 进行筛选
                    s HospChildsub=0,AuHospFlag=0 
                    s strHospitalID=""
                    IF (AuHospStr'=1)&&(AuHospStr'="off")
                    {
                        for
                        {
                            s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")||(AuHospFlag=1)  
                            s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
                            s strHospitalID = "{ID:"_HOSPHospitalDR_"}"
                            if (AuHospStr[strHospitalID) s AuHospFlag=1
                            if (HOSPID'=DefHospId)&&(DefHospId=HOSPHospitalDR)  //如果登录医院不等于医院组，要判断医院级授权是不是只有登录医院的权限，要能看到医院组的医嘱项数据。
                            {
                                if (AuHospStr[strHOSPID)||(AuHospStr[strHospRowId) s AuHospFlag=1
                            }
                        }
                    }
                    continue:('((AuHospStr=1)||(AuHospFlag=1)||(AuHospStr="off")))
                }
                
                //医嘱子分类过滤
                s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
                continue:((ARCIMItemCatDR'=itemcat)&&(itemcat'="")) 
                
                //医嘱大类过滤
                s OECOrderCatDR=""
                s:ARCIMItemCatDR'="" OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)  //医嘱大类
                continue:((OECOrderCatDR'=ordercat)&&(ordercat'=""))
                
                //账单子组过滤
                s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)                  ;账单子组
                continue:((ARCIMBillSubDR'=billsub)&&(billsub'=""))
                    
                //账单组过滤
                s ARCIMBillGrpRowId=""
                s:ARCIMBillSubDR["||" ARCIMBillGrpRowId=$p(ARCIMBillSubDR,"||",1)                     ;账单组
                continue:((ARCIMBillGrpRowId'=billgrp)&&(billgrp'=""))
                
                ///过滤独立医嘱
                s ARCIMOrderOnItsOwn = $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",13)       ;独立医嘱
                s:ARCIMOrderOnItsOwn="" ARCIMOrderOnItsOwn="N"  
                continue:((ownflag'="")&&(ownflag'="A")&&(ARCIMOrderOnItsOwn'=ownflag))
                
                //过滤可用医嘱
                s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)       ; 开始日期
                s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
                s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
                s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)      ; 结束日期    
                s enable="N"
                if ((ARCIMEffDate'="")&(ARCIMEffDate<=+$h))&((ARCIMEffDateTo="")||((ARCIMEffDateTo'="")&(ARCIMEffDateTo>=+$h))) s enable="Y"
                continue:((enableflag'="")&&(enableflag'="A")&&(enableflag'=enable))
                
                ///过滤医嘱项开始日期
                continue:((datefrom'="")&&(datefrom'=ARCIMEffDate))
                    
                ///过滤服务组
                s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7)             ;服务组
                continue:((service'="")&&(ARCIMServiceGroupDR'=service))
                    
                s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)
                s ARCIMDefPriorityDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",22)
                s ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)
                
                /// 过滤 限患者类型
                s ARCIMRESTRICTOP =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",14)  // 限制门诊  
                s:ARCIMRESTRICTOP="" ARCIMRESTRICTOP="N" 
                continue:(limittype["OP")&(ARCIMRESTRICTOP'="Y")   
                s ARCIMRESTRICTIP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",13) // 限制住院  
                s:ARCIMRESTRICTIP="" ARCIMRESTRICTIP="N"   
                continue:(limittype["IP")&(ARCIMRESTRICTIP'="Y")    
                s ARCIMRESTRICTHP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",15)   // 限制体检  
                s:ARCIMRESTRICTHP="" ARCIMRESTRICTHP="N" 
                continue:(limittype["HP")&(ARCIMRESTRICTHP'="Y")    
                s ARCIMRESTRICTEM =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",12)  // 限制急诊
                s:ARCIMRESTRICTEM="" ARCIMRESTRICTEM="N" 
                continue:(limittype["EM")&(ARCIMRESTRICTEM'="Y")  
                  
                /*s ARCIMPHCDFDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",12)               ;药物 
                s PHCDRowId="",PHCDCode=""
                s:ARCIMPHCDFDR'="" PHCDRowId=$p(ARCIMPHCDFDR,"||",1)
                s:PHCDRowId'="" PHCDCode= $p($g(^PHCD(PHCDRowId,1)),"^",1)
                */
                    
                s sortvalue=ARCIMSubscript
                if (sort="ARCIMCode")
                {
                    s sortvalue=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1) 
                }
                elseif (sort="ARCIMDesc")
                {
                    s sortvalue=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2) 
                    s sortvalue="S"_##class(web.DHCBL.BDP.FunLib).GetCNCODE(sortvalue,3,"")
                }
                elseif (sort="orderprice")
                {
                    s sortvalue=##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice(ARCIMRowId,hospid)
                    if sortvalue="" s sortvalue=0
                    s sortvalue=1+sortvalue   //考虑0.7,存的时候会带引号，如果不加1，会比正常的数字排在后面
                }
                s ARCIMItemCatDRstrRowId="{ID:"_ARCIMItemCatDR_"}"
                s ARCIMBillGrpRowIdstrRowId="{ID:"_ARCIMBillGrpRowId_"}"
                s ARCIMBillingUOMDRstrRowId="{ID:"_ARCIMBillingUOMDR_"}"
                s ARCIMDefPriorityDRstrRowId="{ID:"_ARCIMDefPriorityDR_"}"
                s ARCIMDerFeeRulesDRstrRowId="{ID:"_ARCIMDerFeeRulesDR_"}"
                s ARCIMServiceGroupDRstrRowId="{ID:"_ARCIMServiceGroupDR_"}"
                if (($bit(AutBit,ARCIMSubscript)=1)||(AuFlag=1))&&((ARCIMBillGrpRowIdAuStr[ARCIMBillGrpRowIdstrRowId)||(ARCIMBillGrpRowIdAuFlag=1))&&((ARCIMItemCatDRAuStr[ARCIMItemCatDRstrRowId)||(ARCIMItemCatDRAuFlag=1))&&((ARCIMBillingUOMDRAuStr[ARCIMBillingUOMDRstrRowId)||(ARCIMBillingUOMDRAuFlag=1))&&((ARCIMDefPriorityDRAuStr[ARCIMDefPriorityDRstrRowId)||(ARCIMDefPriorityDRAuFlag=1))&&((ARCIMDerFeeRulesDRAuStr[ARCIMDerFeeRulesDRstrRowId)||(ARCIMDerFeeRulesDRAuFlag=1))&&((ARCIMServiceGroupDRAuStr[ARCIMServiceGroupDRstrRowId)||(ARCIMServiceGroupDRAuFlag=1))
                {
                    s ^TMPARCIM(sort,sortvalue,ARCIMSubscript)=ARCIMVersion
                }
            }
        }
        
        if start="" s start=0
        if limit="" s limit=20
        s count=0
        s start=start+1
        w "{""data"":["
        s CurrentCount=0
        
        s sortvalue=0,sdir=1   ///ASC,正序
        if (dir="DESC")   //倒序
        {
            s sortvalue="",sdir=-1
        }
        for  
        {           
            s sortvalue=$o(^TMPARCIM(sort,sortvalue),sdir) q:sortvalue=""
            s ARCIMSubscript=0
            if (dir="DESC") s ARCIMSubscript=""
            for 
            {
                s ARCIMSubscript=$o(^TMPARCIM(sort,sortvalue,ARCIMSubscript),sdir) q:(ARCIMSubscript="")
                s ARCIMVersion=$g(^TMPARCIM(sort,sortvalue,ARCIMSubscript))
                s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
                s count=count+1     
                s ^TMP("BDPARCIM",count)=ARCIMRowId
                if (count<start) continue
                if ((count<(start+limit)))
                {
                    if CurrentCount=0
                    {
                        s CurrentCount=1
                    }
                    else
                    {
                        s CurrentCount=CurrentCount+1
                        w ","
                    }
                    w ##class(web.DHCBL.CT.ARCItmMast).GetItmByRowID(ARCIMRowId,hospid)
                }
            }
        }
        w "],""total"":"""_count_""",""success"":""true""}"
        k ^TMPARCIM
    }   

    q ""
}

/*


/// Function: GetList 后台分页版
/// Creator: sunfengchao
/// CreateDate: 2015-5-6
/// P1代码,P2描述,P3药物查找,P4别名,P5账单组,P6账单子组,P7医嘱子类,P8服务组,P9收费规定,enableflag,ordercat 医嘱大类
/// code, desc, alias, billgrp, billsub, drug, itemcat, service
/// debug: w ##class(web.DHCBL.CT.ARCItmMast).GetList("","" ,"","","","","","","","",0,20,"A","A","","","","","")
ClassMethod GetList(ID As %String, P1 As %String, P2 As %String, P3 As %String, P4 As %String, P5 As %String, P6 As %String, P7 As %String, P8 As %String, start, limit, enableflag, ownflag, sort, dir, ordercat, datefrom, hospid) As %String
{
    s:datefrom'="" datefrom= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)
    
    if (enableflag="") s enableflag="A"
    if (ownflag="") s ownflag="A"
    
    if start="" s start=0
    if limit="" s limit=20
    
    if (ID'="") 
    {
        s Result= ##class(web.DHCBL.CT.ARCItmMast).GetItmByRowID(ID,hospid)
        w "{""data"":["_Result_"],""total"":""1"",""success"":""true""}"
    }
    else
    {
        
        s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
        s AuStr=##class(web.DHCBL.Authorize.ARCItmMast).DHCGetDataByDefaultSession()
        s LookUpMode=##class(web.DHCBL.BDP.BDPAlias).GetConfig("ARC_ItmMast")
        
        s:P1'="" P1=$zcvt(P1,"U")
        s:P2'="" P2=$zcvt(P2,"U")
        s:P3'="" P3=$zcvt(P3,"U")
        s:P4'="" P4=$zcvt(P4,"U")
        
        if sort="" s sort="ARCIMRowId"
        k ^TMP("BDPARCIM")  //记录查询出的数据
        k ^TMPARCIM  //查询临时用
        
        if ($l(AuStr,"#")=1) {
            s Limited=0
            s AutBit=""
        }
        elseif ($l(AuStr,"#")=2) {
            s Limited=$p(AuStr,"#",1)
            s AutBit=$p(AuStr,"#",2)
        }
        s AuFlag=0
        if (AuStr="")||((AuStr'="")&(Limited=0)) s AuFlag=1 //判断是否有授权,如果没有则全部显示
        
        s ARCIMItemCatDRAuStr=##class(web.DHCBL.Authorize.ARCItemCat).DHCGetDataByDefaultSession()
        s ARCIMItemCatDRAuFlag=0
        ;医嘱子分类
        if (ARCIMItemCatDRAuStr="")||(ARCIMItemCatDRAuStr["limited:0") s ARCIMItemCatDRAuFlag=1

        s ARCIMBillingUOMDRAuStr=##class(web.DHCBL.Authorize.CTUOM).DHCGetDataByDefaultSession()
        s ARCIMBillingUOMDRAuFlag=0
        ;单位
        if (ARCIMBillingUOMDRAuStr="")||(ARCIMBillingUOMDRAuStr["limited:0") s ARCIMBillingUOMDRAuFlag=1

        s ARCIMBillGrpRowIdAuStr=##class(web.DHCBL.Authorize.ARCBillGrp).DHCGetDataByDefaultSession()
        s ARCIMBillGrpRowIdAuFlag=0
        ;账单组
        if (ARCIMBillGrpRowIdAuStr="")||(ARCIMBillGrpRowIdAuStr["limited:0") s ARCIMBillGrpRowIdAuFlag=1

        s ARCIMDefPriorityDRAuStr=##class(web.DHCBL.Authorize.OECPriority).DHCGetDataByDefaultSession()
        s ARCIMDefPriorityDRAuFlag=0
        ;医嘱优先级
        if (ARCIMDefPriorityDRAuStr="")||(ARCIMDefPriorityDRAuStr["limited:0") s ARCIMDefPriorityDRAuFlag=1

        s ARCIMDerFeeRulesDRAuStr=##class(web.DHCBL.Authorize.ARCDerivedFeeRules).DHCGetDataByDefaultSession()
        s ARCIMDerFeeRulesDRAuFlag=0
        ;收费规定
        if (ARCIMDerFeeRulesDRAuStr="")||(ARCIMDerFeeRulesDRAuStr["limited:0") s ARCIMDerFeeRulesDRAuFlag=1

        s ARCIMServiceGroupDRAuStr=##class(web.DHCBL.Authorize.RBCServiceGroup).DHCGetDataByDefaultSession()
        s ARCIMServiceGroupDRAuFlag=0
        ;服务资源组
        if (ARCIMServiceGroupDRAuStr="")||(ARCIMServiceGroupDRAuStr["limited:0") s ARCIMServiceGroupDRAuFlag=1
        
        if (P6'="")||(P7'="")||(P8'="")
        {
            
            if (P8'="") s indexname="SERGRP",indexvalue=P8   //服务资源组
            if (P6'="") s indexname="ARCSG_DR",indexvalue=P6   //账单子组
            if (P7'="") s indexname="ARCIC_DR",indexvalue=P7   //医嘱子类
            S ARCIMSubscript=0
            for
            {
                s ARCIMSubscript=$o(^ARCIM(0,indexname,indexvalue,ARCIMSubscript))  q:ARCIMSubscript=""
                s ARCIMVersion=0
                for 
                {
                    s ARCIMVersion=$o(^ARCIM(0,indexname,indexvalue,ARCIMSubscript,ARCIMVersion))  q:ARCIMVersion=""
                    s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
                    
                    if hospid'=""
                    {
                        s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCIMRowId,hospid)
                        continue:showflag="N"
                    }
                    else
                    {
                        ; 遍历 医院子表，查询医院dr 进行筛选
                        s HospChildsub=0,AuHospFlag=0 
                        IF (AuHospStr'=1)&&(AuHospStr'="off")
                        {
                            for
                            {
                                s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")||(AuHospFlag=1)  
                                s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
                                s strHospitalID = "{ID:"_HOSPHospitalDR_"}"
                                if (AuHospStr[strHospitalID) s AuHospFlag=1
                            }
                        }
                        continue:('((AuHospStr=1)||(AuHospFlag=1)||(AuHospStr="off")))
                    }
                    s ARCIMRowId=##class(web.DHCBL.CT.ARCItmMast).MatchParamsAut(ARCIMRowId,P1,P2,P4,P5,P6,P3,P7,P8,enableflag,ownflag,ordercat,datefrom)
                    q:ARCIMRowId=""
                    
                    s sortvalue=ARCIMSubscript
                    if (sort="ARCIMCode")
                    {
                        s sortvalue=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1) 
                    }
                    if (sort="ARCIMDesc")
                    {
                        s sortvalue=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2) 
                        s sortvalue="S"_##class(web.DHCBL.BDP.FunLib).GetCNCODE(sortvalue,3,"")
                    }
                    if (sort="orderprice")
                    {
                        s sortvalue=##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice(ARCIMRowId,hospid)
                        if sortvalue="" s sortvalue=0
                        s sortvalue=1+sortvalue   //考虑0.7,存的时候会带引号，如果不加1，会比正常的数字排在后面
                    }
                    
                    s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
                    s OECOrderCatDR=""
                    s:ARCIMItemCatDR'="" OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)
                    s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)                  ;账单组与 账单子组
                    s ARCIMBillGrpRowId=""
                    s:ARCIMBillSubDR["||" ARCIMBillGrpRowId=$p(ARCIMBillSubDR,"||",1)                     ;账单组DR
                    
                    s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)
                    s ARCIMDefPriorityDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",22)
                    s ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)
                    s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7)             ;服务资源组

                    s ARCIMItemCatDRstrRowId="{ID:"_ARCIMItemCatDR_"}"
                    s ARCIMBillGrpRowIdstrRowId="{ID:"_ARCIMBillGrpRowId_"}"
                    s ARCIMBillingUOMDRstrRowId="{ID:"_ARCIMBillingUOMDR_"}"
                    s ARCIMDefPriorityDRstrRowId="{ID:"_ARCIMDefPriorityDR_"}"
                    s ARCIMDerFeeRulesDRstrRowId="{ID:"_ARCIMDerFeeRulesDR_"}"
                    s ARCIMServiceGroupDRstrRowId="{ID:"_ARCIMServiceGroupDR_"}"
                    if (($bit(AutBit,ARCIMSubscript)=1)||(AuFlag=1))&&((ARCIMBillGrpRowIdAuStr[ARCIMBillGrpRowIdstrRowId)||(ARCIMBillGrpRowIdAuFlag=1))&&((ARCIMItemCatDRAuStr[ARCIMItemCatDRstrRowId)||(ARCIMItemCatDRAuFlag=1))&&((ARCIMBillingUOMDRAuStr[ARCIMBillingUOMDRstrRowId)||(ARCIMBillingUOMDRAuFlag=1))&&((ARCIMDefPriorityDRAuStr[ARCIMDefPriorityDRstrRowId)||(ARCIMDefPriorityDRAuFlag=1))&&((ARCIMDerFeeRulesDRAuStr[ARCIMDerFeeRulesDRstrRowId)||(ARCIMDerFeeRulesDRAuFlag=1))&&((ARCIMServiceGroupDRAuStr[ARCIMServiceGroupDRstrRowId)||(ARCIMServiceGroupDRAuFlag=1))
                    {
                        
                        s ^TMPARCIM(sort,sortvalue,ARCIMSubscript)=ARCIMVersion
                    }
                    
                }
            }
            
        }
        elseif (P7="")&&(ordercat'="")
        {
            ; 医嘱大类
            s arcimcat=0
            for
            {
                s arcimcat=$o(^ARCIM(0,"ARCIC_DR",arcimcat))  q:arcimcat=""
                if $p($g(^ARC("IC",arcimcat)),"^",8)'=ordercat continue
                S ARCIMSubscript=0
                for
                {
                    s ARCIMSubscript=$o(^ARCIM(0,"ARCIC_DR",arcimcat,ARCIMSubscript))  q:ARCIMSubscript=""
                    s ARCIMVersion=0
                    for 
                    {
                        s ARCIMVersion=$o(^ARCIM(0,"ARCIC_DR",arcimcat,ARCIMSubscript,ARCIMVersion))  q:ARCIMVersion=""
                        s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
                        
                        if hospid'=""
                        {
                            s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCIMRowId,hospid)
                            continue:showflag="N"
                        }
                        else
                        {
                            ; 遍历 医院子表，查询医院dr 进行筛选
                            s HospChildsub=0,AuHospFlag=0 
                            IF (AuHospStr'=1)&&(AuHospStr'="off")
                            {
                                for
                                {
                                    s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")||(AuHospFlag=1)  
                                    s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
                                    s strHospitalID = "{ID:"_HOSPHospitalDR_"}"
                                    if (AuHospStr[strHospitalID) s AuHospFlag=1
                                }
                            }
                            continue:('((AuHospStr=1)||(AuHospFlag=1)||(AuHospStr="off")))
                        }
                        s ARCIMRowId=##class(web.DHCBL.CT.ARCItmMast).MatchParamsAut(ARCIMRowId,P1,P2,P4,P5,P6,P3,P7,P8,enableflag,ownflag,ordercat,datefrom)
                        q:ARCIMRowId=""
                        s sortvalue=ARCIMSubscript
                        if (sort="ARCIMCode")
                        {
                            s sortvalue=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1) 
                        }
                        if (sort="ARCIMDesc")
                        {
                            s sortvalue=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2) 
                            s sortvalue="S"_##class(web.DHCBL.BDP.FunLib).GetCNCODE(sortvalue,3,"")
                        }
                    
                        if (sort="orderprice")
                        {
                            s sortvalue=##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice(ARCIMRowId,hospid)
                            if sortvalue="" s sortvalue=0
                            s sortvalue=1+sortvalue
                        }
                        
                        s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
                        s OECOrderCatDR=""
                        s:ARCIMItemCatDR'="" OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)
                        s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)                  ;账单组与 账单子组
                        s ARCIMBillGrpRowId=""
                        s:ARCIMBillSubDR["||" ARCIMBillGrpRowId=$p(ARCIMBillSubDR,"||",1)                     ;账单组DR
                        
                        s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)
                        s ARCIMDefPriorityDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",22)
                        s ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)
                        s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7)             ;服务资源组

                        s ARCIMItemCatDRstrRowId="{ID:"_ARCIMItemCatDR_"}"
                        s ARCIMBillGrpRowIdstrRowId="{ID:"_ARCIMBillGrpRowId_"}"
                        s ARCIMBillingUOMDRstrRowId="{ID:"_ARCIMBillingUOMDR_"}"
                        s ARCIMDefPriorityDRstrRowId="{ID:"_ARCIMDefPriorityDR_"}"
                        s ARCIMDerFeeRulesDRstrRowId="{ID:"_ARCIMDerFeeRulesDR_"}"
                        s ARCIMServiceGroupDRstrRowId="{ID:"_ARCIMServiceGroupDR_"}"
                        if (($bit(AutBit,ARCIMSubscript)=1)||(AuFlag=1))&&((ARCIMBillGrpRowIdAuStr[ARCIMBillGrpRowIdstrRowId)||(ARCIMBillGrpRowIdAuFlag=1))&&((ARCIMItemCatDRAuStr[ARCIMItemCatDRstrRowId)||(ARCIMItemCatDRAuFlag=1))&&((ARCIMBillingUOMDRAuStr[ARCIMBillingUOMDRstrRowId)||(ARCIMBillingUOMDRAuFlag=1))&&((ARCIMDefPriorityDRAuStr[ARCIMDefPriorityDRstrRowId)||(ARCIMDefPriorityDRAuFlag=1))&&((ARCIMDerFeeRulesDRAuStr[ARCIMDerFeeRulesDRstrRowId)||(ARCIMDerFeeRulesDRAuFlag=1))&&((ARCIMServiceGroupDRAuStr[ARCIMServiceGroupDRstrRowId)||(ARCIMServiceGroupDRAuFlag=1))
                        {
                            
                            s ^TMPARCIM(sort,sortvalue,ARCIMSubscript)=ARCIMVersion
                        }
                            
                    }
                }
            }
            
        }
        elseif ((P5'="")&&(P6=""))  /// 账单组不为空
        {
            ;账单组不为空
            s BillSub=0
            for 
            {
                s BillSub=$o(^ARCIM(0,"ARCSG_DR",BillSub)) q:BillSub=""
                if ($p(BillSub,"||",1)=P5)
                {
                    s ARCIMSubscript=0
                    for
                    {
                        s ARCIMSubscript=$o(^ARCIM(0,"ARCSG_DR",BillSub,ARCIMSubscript)) q:ARCIMSubscript=""
                        s ARCIMVersion=0
                        for 
                        {
                            s ARCIMVersion=$o(^ARCIM(0,"ARCSG_DR",BillSub,ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""
                            s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
                            if hospid'=""
                            {
                                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCIMRowId,hospid)
                                continue:showflag="N"
                            }
                            else
                            {
                                ; 遍历 医院子表，查询医院dr 进行筛选
                                s HospChildsub=0,AuHospFlag=0 
                                IF (AuHospStr'=1)&&(AuHospStr'="off")
                                {
                                    for
                                    {
                                        s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")||(AuHospFlag=1)  
                                        s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
                                        s strHospitalID = "{ID:"_HOSPHospitalDR_"}"
                                        if (AuHospStr[strHospitalID) s AuHospFlag=1
                                    }
                                }
                                continue:('((AuHospStr=1)||(AuHospFlag=1)||(AuHospStr="off")))
                            }
                            s ARCIMRowId=##class(web.DHCBL.CT.ARCItmMast).MatchParamsAut(ARCIMRowId,P1,P2,P4,P5,P6,P3,P7,P8,enableflag,ownflag,ordercat,datefrom)
                            q:ARCIMRowId=""
                            s sortvalue=ARCIMSubscript
                            if (sort="ARCIMCode")
                            {
                                s sortvalue=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1) 
                            }
                            if (sort="ARCIMDesc")
                            {
                                s sortvalue=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2) 
                                s sortvalue="S"_##class(web.DHCBL.BDP.FunLib).GetCNCODE(sortvalue,3,"")
                            }
                    
                            if (sort="orderprice")
                            {
                                s sortvalue=##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice(ARCIMRowId,hospid)
                                if sortvalue="" s sortvalue=0
                                s sortvalue=1+sortvalue
                            }
                            
                            
                            s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
                            s OECOrderCatDR=""
                            s:ARCIMItemCatDR'="" OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)
                            s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)                  ;账单组与 账单子组
                            s ARCIMBillGrpRowId=""
                            s:ARCIMBillSubDR["||" ARCIMBillGrpRowId=$p(ARCIMBillSubDR,"||",1)                     ;账单组DR
                            
                            s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)
                            s ARCIMDefPriorityDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",22)
                            s ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)
                            s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7)             ;服务资源组

                            s ARCIMItemCatDRstrRowId="{ID:"_ARCIMItemCatDR_"}"
                            s ARCIMBillGrpRowIdstrRowId="{ID:"_ARCIMBillGrpRowId_"}"
                            s ARCIMBillingUOMDRstrRowId="{ID:"_ARCIMBillingUOMDR_"}"
                            s ARCIMDefPriorityDRstrRowId="{ID:"_ARCIMDefPriorityDR_"}"
                            s ARCIMDerFeeRulesDRstrRowId="{ID:"_ARCIMDerFeeRulesDR_"}"
                            s ARCIMServiceGroupDRstrRowId="{ID:"_ARCIMServiceGroupDR_"}"
                            if (($bit(AutBit,ARCIMSubscript)=1)||(AuFlag=1))&&((ARCIMBillGrpRowIdAuStr[ARCIMBillGrpRowIdstrRowId)||(ARCIMBillGrpRowIdAuFlag=1))&&((ARCIMItemCatDRAuStr[ARCIMItemCatDRstrRowId)||(ARCIMItemCatDRAuFlag=1))&&((ARCIMBillingUOMDRAuStr[ARCIMBillingUOMDRstrRowId)||(ARCIMBillingUOMDRAuFlag=1))&&((ARCIMDefPriorityDRAuStr[ARCIMDefPriorityDRstrRowId)||(ARCIMDefPriorityDRAuFlag=1))&&((ARCIMDerFeeRulesDRAuStr[ARCIMDerFeeRulesDRstrRowId)||(ARCIMDerFeeRulesDRAuFlag=1))&&((ARCIMServiceGroupDRAuStr[ARCIMServiceGroupDRstrRowId)||(ARCIMServiceGroupDRAuFlag=1))
                            {
                                
                                s ^TMPARCIM(sort,sortvalue,ARCIMSubscript)=ARCIMVersion
                            }
                        }
                    }
                }
            }
            
        }
        else    //账单组、账单子组、服务资源组、医嘱子类、医嘱大类、均为空没办法通过索引查询，只能遍历所有数据
        {
            s ARCIMSubscript=0
            for
            {
                s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:(ARCIMSubscript="")
                s ARCIMVersion=0
                for 
                {
                    s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:(ARCIMVersion="")
                
                    s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
                    
                    if hospid'=""
                    {
                        s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCIMRowId,hospid)
                        continue:showflag="N"
                    }
                    else
                    {
                        ; 遍历 医院子表，查询医院dr 进行筛选
                        s HospChildsub=0,AuHospFlag=0 
                        IF (AuHospStr'=1)&&(AuHospStr'="off")
                        {
                            for
                            {
                                s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")||(AuHospFlag=1)  
                                s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
                                s strHospitalID = "{ID:"_HOSPHospitalDR_"}"
                                if (AuHospStr[strHospitalID) s AuHospFlag=1
                            }
                        }
                        continue:('((AuHospStr=1)||(AuHospFlag=1)||(AuHospStr="off")))
                    }
                    s ARCIMRowId=##class(web.DHCBL.CT.ARCItmMast).MatchParamsAut(ARCIMRowId,P1,P2,P4,P5,P6,P3,P7,P8,enableflag,ownflag,ordercat,datefrom)
                    q:ARCIMRowId=""
                    s sortvalue=ARCIMSubscript
                    if (sort="ARCIMCode")
                    {
                        s sortvalue=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1) 
                    }
                    if (sort="ARCIMDesc")
                    {
                        s sortvalue=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2) 
                        s sortvalue="S"_##class(web.DHCBL.BDP.FunLib).GetCNCODE(sortvalue,3,"")
                    }
                    
                    if (sort="orderprice")
                    {
                        s sortvalue=##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice(ARCIMRowId,hospid)
                        if sortvalue="" s sortvalue=0
                        s sortvalue=1+sortvalue
                    }
                    
                    s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
                    s OECOrderCatDR=""
                    s:ARCIMItemCatDR'="" OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)
                    s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)                  ;账单组与 账单子组
                    s ARCIMBillGrpRowId=""
                    s:ARCIMBillSubDR["||" ARCIMBillGrpRowId=$p(ARCIMBillSubDR,"||",1)                     ;账单组DR
                    
                    s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)
                    s ARCIMDefPriorityDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",22)
                    s ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)
                    s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7)             ;服务资源组

                    s ARCIMItemCatDRstrRowId="{ID:"_ARCIMItemCatDR_"}"
                    s ARCIMBillGrpRowIdstrRowId="{ID:"_ARCIMBillGrpRowId_"}"
                    s ARCIMBillingUOMDRstrRowId="{ID:"_ARCIMBillingUOMDR_"}"
                    s ARCIMDefPriorityDRstrRowId="{ID:"_ARCIMDefPriorityDR_"}"
                    s ARCIMDerFeeRulesDRstrRowId="{ID:"_ARCIMDerFeeRulesDR_"}"
                    s ARCIMServiceGroupDRstrRowId="{ID:"_ARCIMServiceGroupDR_"}"
                    if (($bit(AutBit,ARCIMSubscript)=1)||(AuFlag=1))&&((ARCIMBillGrpRowIdAuStr[ARCIMBillGrpRowIdstrRowId)||(ARCIMBillGrpRowIdAuFlag=1))&&((ARCIMItemCatDRAuStr[ARCIMItemCatDRstrRowId)||(ARCIMItemCatDRAuFlag=1))&&((ARCIMBillingUOMDRAuStr[ARCIMBillingUOMDRstrRowId)||(ARCIMBillingUOMDRAuFlag=1))&&((ARCIMDefPriorityDRAuStr[ARCIMDefPriorityDRstrRowId)||(ARCIMDefPriorityDRAuFlag=1))&&((ARCIMDerFeeRulesDRAuStr[ARCIMDerFeeRulesDRstrRowId)||(ARCIMDerFeeRulesDRAuFlag=1))&&((ARCIMServiceGroupDRAuStr[ARCIMServiceGroupDRstrRowId)||(ARCIMServiceGroupDRAuFlag=1))
                    {
                        
                        s ^TMPARCIM(sort,sortvalue,ARCIMSubscript)=ARCIMVersion
                    }
                }
            }
            
        }
        s count=0
        K IDS
        s IDS=##class(%Library.ListOfDataTypes).%New()
        s sortvalue=0,sdir=1   ///ASC,正序
        if (dir="DESC")   //倒序
        {
            s sortvalue="",sdir=-1
        }
        for  
        {           
            s sortvalue=$o(^TMPARCIM(sort,sortvalue),sdir) q:sortvalue=""
            s ARCIMSubscript=0
            if (dir="DESC") s ARCIMSubscript=""
            for 
            {
                s ARCIMSubscript=$o(^TMPARCIM(sort,sortvalue,ARCIMSubscript),sdir) q:(ARCIMSubscript="")
                s ARCIMVersion=$g(^TMPARCIM(sort,sortvalue,ARCIMSubscript))
                s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
                s count=count+1
                s ^TMP("BDPARCIM",count)=ARCIMRowId
                d IDS.Insert("'"_ARCIMRowId_"'")
                
            }
        }
        d ##class(web.DHCBL.CT.ARCItmMast).MultiGetItmByID(IDS,count,hospid,start,limit)
        k ^TMPARCIM
    }   

    q ""
}*/
/// Function:通过ID 查找医嘱项
/// Creator:陈莹
/// CreateDate: 2015-9-1
/// Debug: w ##class(web.DHCBL.CT.ARCItmMast).GetItmByRowID("13367||1","")
ClassMethod GetItmByRowID(ID As %String, hospid As %String) As %String
{
    n (ID,hospid)
    s strResult=""

    if (ID'="") 
    {

        s ARCIMSubscript=$p(ID,"||",1)
        s ARCIMVersion=$p(ID,"||",2)
        q:(ARCIMSubscript="")||(ARCIMVersion="") ""
        S ARCIMRowId=ID
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
        s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
        s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
        s ARCIMAbbrev =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",3)   ; 医嘱缩写

        s ARCIMCode =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMCode)
        s ARCIMDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMDesc)
        s ARCIMAbbrev =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMAbbrev)

        s ARCIMPHCDFDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",12)  ; 药物   
        s PHCDCode="",PHCDRowId=""
        s:ARCIMPHCDFDR'="" PHCDRowId=$p(ARCIMPHCDFDR,"||",1)   
        s:PHCDRowId'="" PHCDCode= $p($g(^PHCD(PHCDRowId,1)),"^",1)

        s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) ; 医嘱子分类
        s ARCIMItemCatDRDesc="",OECOrderCatDR="",OECOrderCatDRDesc=""

        if (ARCIMItemCatDR'="")
        {
            s ARCIMItemCatDRDesc=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)  
            s ARCIMItemCatDRDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMItemCatDRDesc) 
            s OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)
            if OECOrderCatDR'="" s OECOrderCatDRDesc=$p($g(^OEC("ORCAT",OECOrderCatDR)),"^",2)
        }

        s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)     ;账单组与 账单子组
        s ARCIMBillGrpRowId="",ARCIMBillGrpDesc="",ARCIMBillSubDRDesc=""
        if ARCIMBillSubDR["||"
        {
            s:ARCIMBillSubDR'="" ARCIMBillGrpRowId=$p(ARCIMBillSubDR,"||",1)                   ; 账单组DR
            s:ARCIMBillSubDR'="" ARCIMBillGrpDesc=$p($g(^ARCBG($p(ARCIMBillSubDR,"||",1))),"^",2)
            s:ARCIMBillSubDR'="" ARCIMBillSubDRDesc=$P($g(^ARCBG($p(ARCIMBillSubDR,"||",1),"SG",$p(ARCIMBillSubDR,"||",2))),"^",2)  
            s ARCIMBillGrpDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMBillGrpDesc)
            s ARCIMBillSubDRDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMBillSubDRDesc) 
        }
        s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)           ; 计帐单位 
        s ARCIMBillingUOMDRDesc=""
        s:ARCIMBillingUOMDR'="" ARCIMBillingUOMDRDesc=$p($g(^CT("UOM",ARCIMBillingUOMDR)),"^",2)
        s ARCIMBillingUOMDRDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMBillingUOMDRDesc)

        s ARCIMDefPriorityDRDesc=""
        s ARCIMDefPriorityDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",22) ; 医嘱优先级(默认优先级)
        s:ARCIMDefPriorityDR'="" ARCIMDefPriorityDRDesc=$p($g(^OECPR(ARCIMDefPriorityDR)),"^",2)
        s ARCIMDefPriorityDRDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMDefPriorityDRDesc) 

        s ARCIMOrderOnItsOwn = $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",13)    ;独立医嘱
        s:ARCIMOrderOnItsOwn="" ARCIMOrderOnItsOwn="N"     

        s ARCIMAllowOrderWOStockCheck = $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",11)  ;无库存医嘱
        s:ARCIMAllowOrderWOStockCheck="" ARCIMAllowOrderWOStockCheck="N"  

        s ARCIMSensitive=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",18)     ;加急医嘱
        s:ARCIMSensitive="" ARCIMSensitive="N" 

        s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7) ;服务组
        s ARCIMServiceGroupDRDesc =""
        if (ARCIMServiceGroupDR'="")
        {
            s ARCIMServiceGroupDRDesc =$p($g(^RBC("SG",ARCIMServiceGroupDR)),"^",2)
            s ARCIMServiceGroupDRDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMServiceGroupDRDesc) 
        } 

        s ARCIMServMaterial=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",6)        ; 服务/材料
        s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)       ; 开始日期
        s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
        s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
        s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)      ; 结束日期 
        
        s enable="N"
        if ((ARCIMEffDate'="")&(ARCIMEffDate<=+$h))&((ARCIMEffDateTo="")||((ARCIMEffDateTo'="")&(ARCIMEffDateTo>=+$h))) s enable="Y"
        
        
        
        s:ARCIMEffDate'="" ARCIMEffDate =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCIMEffDate)  
        s:ARCIMEffDateTo'="" ARCIMEffDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCIMEffDateTo)

        s ARCIMOEMessage=$g(^ARCIM(ARCIMSubscript,ARCIMVersion,"OEM",1))               ; 医嘱备注  
        s ARCIMOEMessage=##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMOEMessage)  
        
        s ARCIMSensitiveOrder= $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",22) 
        s:ARCIMSensitiveOrder="" ARCIMSensitiveOrder="N"

        s ARCIMDefSensitive= $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",41) 
        s:ARCIMDefSensitive="" ARCIMDefSensitive="N"

        s ARCIMAllowInputFreq= $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",42)  //允许录入频次
        s:ARCIMAllowInputFreq="" ARCIMAllowInputFreq="N" 

        s ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)
        s ARCIMDerFeeRulesDRDesc=""
        s:ARCIMDerFeeRulesDR'="" ARCIMDerFeeRulesDRDesc=$p($g(^ARC("DFR",ARCIMDerFeeRulesDR)),"^",2)   ///收费规定
        s ARCIMDerFeeRulesDRDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMDerFeeRulesDRDesc)


        ; 规格
        s INCIRowid=$o(^INCI(0,"ARCIM_DR",ARCIMSubscript,0)) 
        s INFOSpec="",INCICode=""
        if (INCIRowid'="")
        {
            s INCICode=$p($g(^INCI(INCIRowid,1)),"^",1)
            s INCICode=##class(web.DHCBL.BDP.FunLib).EvalJSON(INCICode)
            s INFOINCIDR=INCIRowid
            s INFOSpecRowId=$O(^DHCITMINFO(0,"INCI",INFOINCIDR,0))
            s:INFOSpecRowId'="" INFOSpec=$p($g(^DHCITMINFO(INFOSpecRowId)),"^",27)
            s INFOSpec=##class(web.DHCBL.BDP.FunLib).EvalJSON(INFOSpec)
        }

        
        ; 医嘱项价格
        s orderprice=""
        s orderprice=##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice(ARCIMRowId,hospid)

        s ARCIMChgOrderPerHour=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",25) 
        s:ARCIMChgOrderPerHour="" ARCIMChgOrderPerHour="N"

        s ARCIMDeceasedPatientsOnly=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",29) 
        s:ARCIMDeceasedPatientsOnly="" ARCIMDeceasedPatientsOnly="N"

        s ARCIMDisplayCumulative=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",23) 
        s:ARCIMDisplayCumulative="" ARCIMDisplayCumulative="N"

        s ARCIMUseODBCforWord=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",6) 
        s:ARCIMUseODBCforWord="" ARCIMUseODBCforWord="N"

        s ARCIMRestrictEM=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",12) 
        s:ARCIMRestrictEM="" ARCIMRestrictEM="N"


        s ARCIMRestrictIP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",13) 
        s:ARCIMRestrictIP="" ARCIMRestrictIP="N"

        s ARCIMRestrictOP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",14) 
        s:ARCIMRestrictOP="" ARCIMRestrictOP="N"

        s ARCIMRestrictHP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",15) 
        s:ARCIMRestrictHP="" ARCIMRestrictHP="N"

        s ARCIMScanCodeBilling=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",22)  //ofy6
        s:ARCIMScanCodeBilling="" ARCIMScanCodeBilling="N"

        Set ARCIMLinkInsu=""
        /*///ofy4同仁医院
        Set ARCIMLinkInsu=##class(web.DHCINSUPort).ArcimLinkInsu(ARCIMSubscript_"||"_ARCIMVersion,"1")
        if (ARCIMLinkInsu["!")
        {
        s ARCIMLinkInsu=$p(ARCIMLinkInsu,"!",2)
        if ARCIMLinkInsu["^" s ARCIMLinkInsu=$P(ARCIMLinkInsu,"^",1)
        else  s ARCIMLinkInsu=""
        }*/
        s ARCIMText1=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",32)    
        s ARCIMText2=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",33)    
        s ARCIMText3=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",34)    
        s ARCIMText4=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",35)    
        s ARCIMText5=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",36) 
        s ARCIMPatientOrderFile1=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",19)
        s ARCIMPatientOrderFile2=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",20)
        s ARCIMPatientOrderFile3=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",21)
        s ARCIMMaxCumDose=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",30)
        s ARCIMMaxQtyPerDay=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",37)
        s ARCIMMaxQty=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",38)
        
        
        
        s ARCIMPatientOrderFile1=##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMPatientOrderFile1)
        s ARCIMPatientOrderFile2=##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMPatientOrderFile2)
        s ARCIMPatientOrderFile3=##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMPatientOrderFile3)
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_ItmMast",ARCIMRowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)
        s BDPInternalDesc = $p($g(resultStr),"^",2)
        s BDPHospNationalCode=$p($g(resultStr),"^",3)  
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)

        s strResult= "{""ARCIMRowId"":"""_ARCIMRowId_""",""ARCIMCode"":"""_ARCIMCode_""",""ARCIMDesc"":"""_ARCIMDesc_""",""ARCIMItemCatDR"":"""_ARCIMItemCatDR_""",""PHCDCode"":"""_PHCDCode_""",""ARCIMBillGrpDesc"":"""_ARCIMBillGrpDesc_""",""ARCIMBillSubDRDesc"":"""_ARCIMBillSubDRDesc_""",""OECOrderCatDR"":"""_OECOrderCatDR_""",""OECOrderCatDRDesc"":"""_OECOrderCatDRDesc_""",""ARCIMItemCatDRDesc"":"""_ARCIMItemCatDRDesc_""",""ARCIMBillingUOMDRDesc"":"""_ARCIMBillingUOMDRDesc_""",""ARCIMServMaterial"":"""_ARCIMServMaterial_""",""ARCIMDefPriorityDRDesc"":"""_ARCIMDefPriorityDRDesc_""",""ARCIMServiceGroupDRDesc"":"""_ARCIMServiceGroupDRDesc_""",""ARCIMAbbrev"":"""_ARCIMAbbrev_""",""ARCIMOrderOnItsOwn"":"""_ARCIMOrderOnItsOwn_""",""ARCIMAllowOrderWOStockCheck"":"""_ARCIMAllowOrderWOStockCheck_""",""ARCIMEffDate"":"""_ARCIMEffDate_""",""ARCIMEffDateTo"":"""_ARCIMEffDateTo_""",""ARCIMBillGrpRowId"":"""_ARCIMBillGrpRowId_""",""ARCIMBillSubDR"":"""_ARCIMBillSubDR_""",""ARCIMBillingUOMDR"":"""_ARCIMBillingUOMDR_""",""ARCIMServiceGroupDR"":"""_ARCIMServiceGroupDR_""",""ARCIMDefPriorityDR"":"""_ARCIMDefPriorityDR_""",""ARCIMOEMessage"":"""_ARCIMOEMessage_""",""ARCIMDerFeeRulesDRDesc"":"""_ARCIMDerFeeRulesDRDesc_""",""ARCIMDerFeeRulesDR"":"""_ARCIMDerFeeRulesDR_""",""INFOSpec"":"""_INFOSpec_""",""INCICode"":"""_INCICode_""",""orderprice"":"""_orderprice_""",""ARCIMChgOrderPerHour"":"""_ARCIMChgOrderPerHour_""",""ARCIMDeceasedPatientsOnly"":"""_ARCIMDeceasedPatientsOnly_""",""ARCIMDisplayCumulative"":"""_ARCIMDisplayCumulative_""",""ARCIMUseODBCforWord"":"""_ARCIMUseODBCforWord_""",""ARCIMRestrictEM"":"""_ARCIMRestrictEM_""",""ARCIMRestrictIP"":"""_ARCIMRestrictIP_""",""ARCIMRestrictOP"":"""_ARCIMRestrictOP_""",""ARCIMRestrictHP"":"""_ARCIMRestrictHP_""",""ARCIMScanCodeBilling"":"""_ARCIMScanCodeBilling_""",""ARCIMSensitive"":"""_ARCIMSensitive_""",""ARCIMSensitiveOrder"":"""_ARCIMSensitiveOrder_""",""ARCIMDefSensitive"":"""_ARCIMDefSensitive_""",""ARCIMAllowInputFreq"":"""_ARCIMAllowInputFreq_""",""ARCIMText1"":"""_ARCIMText1_""",""ARCIMText2"":"""_ARCIMText2_""",""ARCIMText3"":"""_ARCIMText3_""",""ARCIMText4"":"""_ARCIMText4_""",""ARCIMText5"":"""_ARCIMText5_""",""ARCIMPatientOrderFile1"":"""_ARCIMPatientOrderFile1_""",""ARCIMPatientOrderFile2"":"""_ARCIMPatientOrderFile2_""",""ARCIMPatientOrderFile3"":"""_ARCIMPatientOrderFile3_""",""enable"":"""_enable_""",""ARCIMLinkInsu"":"""_ARCIMLinkInsu_""",""ARCIMMaxCumDose"":"""_ARCIMMaxCumDose_""",""ARCIMMaxQtyPerDay"":"""_ARCIMMaxQtyPerDay_""",""ARCIMMaxQty"":"""_ARCIMMaxQty_""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode_""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_"""}" 
    }
    q strResult
}

/// Function: 通过ID批量查医嘱项信息
/// Creator:陈莹
/// CreateDate: 2015-9-1
/// IDS 入参用%Library.ListOfDataTypes类型，用%String在数据id串超过32763长度时会超长  20170801，读取时用GetAt(i)
/// Debug : w ##class(web.DHCBL.CT.ARCItmMast).MultiGetItmByID("3||1^12||1^2511||1^5366||1","4","","0","20")
ClassMethod MultiGetItmByID(IDS As %Library.ListOfDataTypes, count As %String, hospid As %String, start As %String, limit As %String) As %String
{
    n (IDS,count,hospid,start,limit)
    s ID="",strResult=""

    s end=0
    if (start=0)||(start="") s start=1
    if (limit=0)||(limit="") s limit=20
    if ((start>0)&(start#limit=0)) s start=start+1  
    s end=start+limit
    w "{""data"":["
    s CurrentN=0

    for i=1:1:count
    {
        continue:(i<start)  q:i>(end-1)
        s ID=$tr(IDS.GetAt(i),"'","")       // s count = $METHOD(PLIST,"Count")
        q:ID=""
        s strResult=##class(web.DHCBL.CT.ARCItmMast).GetItmByRowID(ID,hospid)
        if (strResult'="")
        {
            if (CurrentN=0)
            {
                s CurrentN=1
            }
            else
            {
                s CurrentN=CurrentN+1
                w ","
            }
            w strResult
        }
        else
        {   
            s count=count-1  //ID为空或者返回串为空count就不准了, 要去掉
        }
    }
    w "],""total"":"""_count_""",""success"":""true""}"
    q ""
}

/// Function: 判断经过索引筛选后的ID是否符合授权和参数条件,符合返回ID,不符合返回空
/// Creator:陈莹
/// CreateDate: 2015-9-1
/// w ##class(web.DHCBL.CT.ARCItmMast).MatchParamsAut("1||1","","","","","","","","","")
/// Input:ID(医嘱项rowid),code(医嘱项代码),desc(医嘱项代码),alias(别名),billgrp(账单组),billsub(账单子组),drug(药物),itemcat(医嘱子类),service(医嘱项服务资源组),enableflag(医嘱项是否可用标志),ownflag(独立医嘱标志 A,Y,N),ordercat(医嘱大类)，datefrom(开始日期)
/// debug:w ##class(web.DHCBL.CT.ARCItmMast).MatchParamsAut(ID,code,desc,alias,billgrp,billsub,drug,itemcat,service)
ClassMethod MatchParamsAut(ID As %String, code As %String, desc As %String, alias As %String, billgrp As %String, billsub As %String, drug As %String, itemcat As %String, service As %String, enableflag As %String, ownflag As %String, ordercat As %String, datefrom As %String, limittype As %String) As %String
{
    S:desc'="" desc=$zcvt(desc,"U")
    S:code'="" code=$zcvt(code,"U")
    S:alias'="" alias=$zcvt(alias,"U")
    S:drug'="" drug=$zcvt(drug,"U")
    
    S RID=""
    
            
    s ARCIMRowId=ID
    s ARCIMSubscript=$p(ARCIMRowId,"||",1)
    s ARCIMVersion=$p(ARCIMRowId,"||",2)
    
    s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
    s OECOrderCatDR=""
    s:ARCIMItemCatDR'="" OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)
    s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)                  ;账单组与 账单子组
    s ARCIMBillGrpRowId=""
    s:ARCIMBillSubDR["||" ARCIMBillGrpRowId=$p(ARCIMBillSubDR,"||",1)                     ;账单组DR
    
    s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)
    s ARCIMDefPriorityDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",22)
    s ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)
    s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7)             ;服务资源组

    s ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)                   ;医嘱名称
    s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
    s ARCIMPHCDFDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",12)               ;药物 
    s PHCDRowId="",PHCDCode=""
    s:ARCIMPHCDFDR'="" PHCDRowId=$p(ARCIMPHCDFDR,"||",1)
    s:PHCDRowId'="" PHCDCode= $p($g(^PHCD(PHCDRowId,1)),"^",1)
    
    s ARCIMOrderOnItsOwn = $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",13)       ;独立医嘱
    s:ARCIMOrderOnItsOwn="" ARCIMOrderOnItsOwn="N"  
    
    s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)       ; 开始日期
    s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
    s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
    s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)      ; 结束日期 
        
    s enable="N"
    if ((ARCIMEffDate'="")&(ARCIMEffDate<=+$h))&((ARCIMEffDateTo="")||((ARCIMEffDateTo'="")&(ARCIMEffDateTo>=+$h))) s enable="Y"
                                        
    s LookUpMode=##class(web.DHCBL.BDP.BDPAlias).GetConfig("ARC_ItmMast")
    if desc'=""
    {
        s DescFlag=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,ARCIMDesc,desc)
    }
    else
    {
        s DescFlag=1
    }
    
    if alias'=""
    {
        s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
        s ALIASRowId=0,ALIASText1=""
        for
        {
            s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId))
            q:(ALIASRowId="")
            s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
            s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
        }
        s AliasFlag=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,ALIASText1,alias)
    }
    else
    {
        s AliasFlag=1
    }
    if ((datefrom=ARCIMEffDate)||(datefrom=""))&&(AliasFlag=1)&&($zcvt(ARCIMCode,"U")[code)&&(DescFlag=1)&($zcvt(PHCDCode,"U")[drug)&((ARCIMBillGrpRowId=billgrp)||(billgrp=""))&((ARCIMBillSubDR=billsub)||(billsub=""))&((ARCIMItemCatDR=itemcat)||(itemcat=""))&((ARCIMServiceGroupDR=service)||(service=""))&((enableflag=enable)||(enableflag="A"))&((ARCIMOrderOnItsOwn=ownflag)||(ownflag="A"))&(((OECOrderCatDR=ordercat)&&(ordercat'=""))||(ordercat=""))&(((PatientLimit=limittype)&&(limittype'=""))||(limittype=""))     
    {
        s RID=ID
    }
    else
    {
        s RID=""
    }
    
    q RID
}

/// CreatDate:2013-2-22
/// Description:为combobox查询取数据(医嘱项)->ARC_ItmMast  
/// Table:User.ARCItmMast
/// Input:ordercat(医嘱大类desc),subcat(医嘱子类id),code,desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItmMast","GetDataForCmb1","","","","","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, ordercat As %String, ordercatdesc As %String, subcat As %String, subcatdesc As %String, hospid As %String) As %Query(ROWSPEC = "ARCIMRowId:%String,ARCIMCode:%String,ARCIMDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, ordercat As %String, ordercatdesc As %String, subcat As %String, subcatdesc As %String, hospid As %String) As %Status
{
 s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
 s ind=1
 


 
 if (rowid'="") {
    s ARCIMSubscript=$p(rowid, "||", 1)
    s ARCIMVersion=$p(rowid, "||", 2)
    s ARCIMRowId=rowid
    s ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
    s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)

    //s ARCIMCode =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMCode)
    //s ARCIMDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMDesc)
    d OutputRowARCIM
 }
 else {
     s:code'="" code=$ZCONVERT(code,"U")
     s:desc'="" desc=$ZCONVERT(desc,"U")
     s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
     s AuStr=##class(web.DHCBL.Authorize.ARCItmMast).DHCGetDataByDefaultSession()

     if ($l(AuStr,"#")=1) {
      s Limited=0
      s AutBit=""
     }
     elseif ($l(AuStr,"#")=2) {
      s Limited=$p(AuStr,"#",1)
      s AutBit=$p(AuStr,"#",2)
     }
     s AuFlag=0
     if (AuStr="")||((AuStr'="")&(Limited=0)) s AuFlag=1 //判断是否有授权,如果没有则全部显示

     s ARCIMItemCatDRAuStr=##class(web.DHCBL.Authorize.ARCItemCat).DHCGetDataByDefaultSession()
     s ARCIMItemCatDRAuFlag=0
     ;未授权情况下，默认显示全部数据
     if (ARCIMItemCatDRAuStr="")||(ARCIMItemCatDRAuStr["limited:0") s ARCIMItemCatDRAuFlag=1

     s ARCIMBillingUOMDRAuStr=##class(web.DHCBL.Authorize.CTUOM).DHCGetDataByDefaultSession()
     s ARCIMBillingUOMDRAuFlag=0
     ;未授权情况下，默认显示全部数据
     if (ARCIMBillingUOMDRAuStr="")||(ARCIMBillingUOMDRAuStr["limited:0") s ARCIMBillingUOMDRAuFlag=1

     s ARCIMBillGrpRowIdAuStr=##class(web.DHCBL.Authorize.ARCBillGrp).DHCGetDataByDefaultSession()
     s ARCIMBillGrpRowIdAuFlag=0
     ;未授权情况下，默认显示全部数据
     if (ARCIMBillGrpRowIdAuStr="")||(ARCIMBillGrpRowIdAuStr["limited:0") s ARCIMBillGrpRowIdAuFlag=1

     s ARCIMDefPriorityDRAuStr=##class(web.DHCBL.Authorize.OECPriority).DHCGetDataByDefaultSession()
     s ARCIMDefPriorityDRAuFlag=0
     ;未授权情况下，默认显示全部数据
     if (ARCIMDefPriorityDRAuStr="")||(ARCIMDefPriorityDRAuStr["limited:0") s ARCIMDefPriorityDRAuFlag=1

     s ARCIMDerFeeRulesDRAuStr=##class(web.DHCBL.Authorize.ARCDerivedFeeRules).DHCGetDataByDefaultSession()
     s ARCIMDerFeeRulesDRAuFlag=0
     ;未授权情况下，默认显示全部数据
     if (ARCIMDerFeeRulesDRAuStr="")||(ARCIMDerFeeRulesDRAuStr["limited:0") s ARCIMDerFeeRulesDRAuFlag=1

     s ARCIMServiceGroupDRAuStr=##class(web.DHCBL.Authorize.RBCServiceGroup).DHCGetDataByDefaultSession()
     s ARCIMServiceGroupDRAuFlag=0
     ;未授权情况下，默认显示全部数据
     if (ARCIMServiceGroupDRAuStr="")||(ARCIMServiceGroupDRAuStr["limited:0") s ARCIMServiceGroupDRAuFlag=1
    
    //如果登录医院不等于医院组，要判断医院级授权是不是只有登录医院的权限，要能看到医院组的医嘱项数据。
    s HOSPID=""
    if $d(%session) s HOSPID=$g(%session.Data("LOGON.HOSPID"))
    s DefHospId= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(..#SQLTableName,HOSPID,"")
    s strHOSPID="{ID:"_HOSPID_"}"
    
     s ARCIMSubscript=0
     for
     {
         s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:(ARCIMSubscript="")
         s ARCIMVersion=0
         for 
         {
            s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))
            q:(ARCIMVersion="")
            s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
            
            s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)                  ;描述
            if desc'=""
            {
                s AliasFlag=0
                s ALIASText1=""
                s ALIASRowId=0,ALIASText1=""
                for 
                {
                    s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId))             ;别名
                    q:ALIASRowId=""
                    s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                }
                if (ALIASText1[desc)||($zcvt(ARCIMDesc,"U")[desc) s AliasFlag=1
            }
            else
            {
                s AliasFlag=1
            }
            continue:(AliasFlag'=1)
            
            if hospid'=""
            {
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCIMRowId,hospid)
                continue:showflag="N"
            }
            else
            {
                ; 遍历 医院子表，查询医院dr 进行筛选
                s HospChildsub=0,AuHospFlag=0 
                s strHospitalID=""
                IF (AuHospStr'=1)&&(AuHospStr'="off")
                {
                    for
                    {
                        s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")||(AuHospFlag=1)  
                        s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
                        s strHospitalID = "{ID:"_HOSPHospitalDR_"}"
                        if (AuHospStr[strHospitalID) s AuHospFlag=1
                        if (HOSPID'=DefHospId)&&(DefHospId=HOSPHospitalDR)  //如果登录医院不等于医院组，要判断医院级授权是不是只有登录医院的权限，要能看到医院组的医嘱项数据。
                        {
                            if (AuHospStr[strHOSPID)||(AuHospStr[strHospRowId) s AuHospFlag=1
                        }
                    }
                }
                continue:('((AuHospStr=1)||(AuHospFlag=1)||(AuHospStr="off")))
            }
            
            s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
            s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)                  ;账单组与 账单子组
            s ARCIMBillGrpRowId=""
            s:ARCIMBillSubDR["||" ARCIMBillGrpRowId=$p(ARCIMBillSubDR,"||",1)                     ;账单组DR
            
            s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)
            s ARCIMDefPriorityDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",22)
            s ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)
            s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7)             ;服务组

            s ARCIMItemCatDRstrRowId="{ID:"_ARCIMItemCatDR_"}"
            s ARCIMBillGrpRowIdstrRowId="{ID:"_ARCIMBillGrpRowId_"}"
            s ARCIMBillingUOMDRstrRowId="{ID:"_ARCIMBillingUOMDR_"}"
            s ARCIMDefPriorityDRstrRowId="{ID:"_ARCIMDefPriorityDR_"}"
            s ARCIMDerFeeRulesDRstrRowId="{ID:"_ARCIMDerFeeRulesDR_"}"
            s ARCIMServiceGroupDRstrRowId="{ID:"_ARCIMServiceGroupDR_"}"
            
            if (($bit(AutBit,ARCIMSubscript)=1)||(AuFlag=1))&&((ARCIMBillGrpRowIdAuStr[ARCIMBillGrpRowIdstrRowId)||(ARCIMBillGrpRowIdAuFlag=1))&&((ARCIMItemCatDRAuStr[ARCIMItemCatDRstrRowId)||(ARCIMItemCatDRAuFlag=1))&&((ARCIMBillingUOMDRAuStr[ARCIMBillingUOMDRstrRowId)||(ARCIMBillingUOMDRAuFlag=1))&&((ARCIMDefPriorityDRAuStr[ARCIMDefPriorityDRstrRowId)||(ARCIMDefPriorityDRAuFlag=1))&&((ARCIMDerFeeRulesDRAuStr[ARCIMDerFeeRulesDRstrRowId)||(ARCIMDerFeeRulesDRAuFlag=1))&&((ARCIMServiceGroupDRAuStr[ARCIMServiceGroupDRstrRowId)||(ARCIMServiceGroupDRAuFlag=1))
            {
                s ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
                //s ARCIMCode =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMCode)
                //s ARCIMDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMDesc)
                
                s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)               ;开始日期
                s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
                s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
                s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)              ;结束日期
                
                CONTINUE:(ARCIMEffDate'="")&&(ARCIMEffDate>+$H)
                CONTINUE:(ARCIMEffDateTo'="")&&(ARCIMEffDateTo<+$H)
                
                s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
                s ARCIMItemCatDRDesc="",OECOrderCatDR="",OECOrderCatDRDesc=""
                if (ARCIMItemCatDR'="")
                {
                    s ARCIMItemCatDRDesc=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)  
                    s OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)
                    if OECOrderCatDR'="" s OECOrderCatDRDesc=$p($g(^OEC("ORCAT",OECOrderCatDR)),"^",2)
                }

                if '((((ordercatdesc="bed")||(subcatdesc="bed"))&&(ARCIMItemCatDRDesc["床")&&(ARCIMItemCatDRDesc'["临床"))||(subcatdesc="")||(ARCIMItemCatDRDesc[subcatdesc)) continue
                
               if ($ZCONVERT(ARCIMCode,"U")[code)&((ordercat="")||(ordercat=OECOrderCatDR))&((subcat="")||(subcat=ARCIMItemCatDR))
               {
                 d OutputRowARCIM
               }
             }
           }
      }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
OutputRowARCIM
    set Data=$lb(ARCIMRowId,ARCIMCode,ARCIMDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2013-2-22
/// Description:为combobox查询取数据(医嘱项)->ARC_ItmMast  ，，分页
/// Table:User.ARCItmMast
/// Input:ordercat(医嘱大类desc),subcat(医嘱子类id),code,desc
/// Other:w ##class(web.DHCBL.CT.ARCItmMast).GetDataForCmb2("","","","","","","","","")
ClassMethod GetDataForCmb2(rowid As %String, code As %String, desc As %String, ordercat As %String, ordercatdesc As %String, subcat As %String, subcatdesc As %String, start, limit, hospid) As %String
{
    
    if (rowid'="") {
        s ARCIMSubscript=$p(rowid, "||", 1)
        s ARCIMVersion=$p(rowid, "||", 2)
        s ARCIMRowId=rowid
        s ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
        s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)

        s ARCIMCode =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMCode)
        s ARCIMDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMDesc)
        w "{""data"":["
        w "{""ARCIMRowId"":"""_ARCIMRowId_""",""ARCIMDesc"":"""_ARCIMDesc_"""}"         
        w "],""total"":""1"",""success"":""true""}"
    }
    else 
    {
        if start="" s start=0
        if limit="" s limit=20
        s count=0
        s start=start+1  ////start=0  从1条开始 不加会导致第一页显示的记录比设置的“每页显示记录数”少一条
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
        s AuStr=##class(web.DHCBL.Authorize.ARCItmMast).DHCGetDataByDefaultSession()

        if ($l(AuStr,"#")=1) {
            s Limited=0
            s AutBit=""
        }
        elseif ($l(AuStr,"#")=2) {
            s Limited=$p(AuStr,"#",1)
            s AutBit=$p(AuStr,"#",2)
        }
        s AuFlag=0
        if (AuStr="")||((AuStr'="")&(Limited=0)) s AuFlag=1 //判断是否有授权,如果没有则全部显示

        s ARCIMItemCatDRAuStr=##class(web.DHCBL.Authorize.ARCItemCat).DHCGetDataByDefaultSession()
        s ARCIMItemCatDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (ARCIMItemCatDRAuStr="")||(ARCIMItemCatDRAuStr["limited:0") s ARCIMItemCatDRAuFlag=1

        s ARCIMBillingUOMDRAuStr=##class(web.DHCBL.Authorize.CTUOM).DHCGetDataByDefaultSession()
        s ARCIMBillingUOMDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (ARCIMBillingUOMDRAuStr="")||(ARCIMBillingUOMDRAuStr["limited:0") s ARCIMBillingUOMDRAuFlag=1

        s ARCIMBillGrpRowIdAuStr=##class(web.DHCBL.Authorize.ARCBillGrp).DHCGetDataByDefaultSession()
        s ARCIMBillGrpRowIdAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (ARCIMBillGrpRowIdAuStr="")||(ARCIMBillGrpRowIdAuStr["limited:0") s ARCIMBillGrpRowIdAuFlag=1

        s ARCIMDefPriorityDRAuStr=##class(web.DHCBL.Authorize.OECPriority).DHCGetDataByDefaultSession()
        s ARCIMDefPriorityDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (ARCIMDefPriorityDRAuStr="")||(ARCIMDefPriorityDRAuStr["limited:0") s ARCIMDefPriorityDRAuFlag=1

        s ARCIMDerFeeRulesDRAuStr=##class(web.DHCBL.Authorize.ARCDerivedFeeRules).DHCGetDataByDefaultSession()
        s ARCIMDerFeeRulesDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (ARCIMDerFeeRulesDRAuStr="")||(ARCIMDerFeeRulesDRAuStr["limited:0") s ARCIMDerFeeRulesDRAuFlag=1

        s ARCIMServiceGroupDRAuStr=##class(web.DHCBL.Authorize.RBCServiceGroup).DHCGetDataByDefaultSession()
        s ARCIMServiceGroupDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (ARCIMServiceGroupDRAuStr="")||(ARCIMServiceGroupDRAuStr["limited:0") s ARCIMServiceGroupDRAuFlag=1
        W "{""data"":["
        
        //如果登录医院不等于医院组，要判断医院级授权是不是只有登录医院的权限，要能看到医院组的医嘱项数据。
        s HOSPID=""
        if $d(%session) s HOSPID=$g(%session.Data("LOGON.HOSPID"))
        s DefHospId= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(..#SQLTableName,HOSPID,"")
        s strHOSPID="{ID:"_HOSPID_"}"
        
        S CurrentCount=0
        s ARCIMSubscript=0
        for
        {
            s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:(ARCIMSubscript="")
            s ARCIMVersion=0
            for 
            {
                s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:(ARCIMVersion="")
                s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
                
                s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)                  ;描述
                if desc'=""
                {
                    s AliasFlag=0
                    s ALIASText1=""
                    s ALIASRowId=0,ALIASText1=""
                    for 
                    {
                        s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId))             ;别名
                        q:ALIASRowId=""
                        s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
                        s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                    }
                    if (ALIASText1[desc)||($zcvt(ARCIMDesc,"U")[desc) s AliasFlag=1
                    continue:(AliasFlag'=1)
                }
                if hospid'=""
                {
                    s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCIMRowId,hospid)
                    continue:showflag="N"
                }
                else
                {
                    ; 遍历 医院子表，查询医院dr 进行筛选
                    s HospChildsub=0,AuHospFlag=0 
                    IF (AuHospStr'=1)&&(AuHospStr'="off")
                    {
                        for
                        {
                            s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")||(AuHospFlag=1)  
                            s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
                            s strHospitalID = "{ID:"_HOSPHospitalDR_"}"
                            if (AuHospStr[strHospitalID) s AuHospFlag=1
                            if (HOSPID'=DefHospId)&&(DefHospId=HOSPHospitalDR)  //如果登录医院不等于医院组，要判断医院级授权是不是只有登录医院的权限，要能看到医院组的医嘱项数据。
                            {
                                if (AuHospStr[strHOSPID)||(AuHospStr[strHospRowId) s AuHospFlag=1
                            }
                        }
                    }
                    continue:('((AuHospStr=1)||(AuHospFlag=1)||(AuHospStr="off")))
                }
                s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
                s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)                 ;账单组与 账单子组
                s ARCIMBillGrpRowId=""
                s:ARCIMBillSubDR["||" ARCIMBillGrpRowId=$p(ARCIMBillSubDR,"||",1)                    ;账单组DR

                s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)
                s ARCIMDefPriorityDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",22)
                s ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)
                s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7)            ;服务组

                s ARCIMItemCatDRstrRowId="{ID:"_ARCIMItemCatDR_"}"
                s ARCIMBillGrpRowIdstrRowId="{ID:"_ARCIMBillGrpRowId_"}"
                s ARCIMBillingUOMDRstrRowId="{ID:"_ARCIMBillingUOMDR_"}"
                s ARCIMDefPriorityDRstrRowId="{ID:"_ARCIMDefPriorityDR_"}"
                s ARCIMDerFeeRulesDRstrRowId="{ID:"_ARCIMDerFeeRulesDR_"}"
                s ARCIMServiceGroupDRstrRowId="{ID:"_ARCIMServiceGroupDR_"}"
                
                if (($bit(AutBit,ARCIMSubscript)=1)||(AuFlag=1))&&((ARCIMBillGrpRowIdAuStr[ARCIMBillGrpRowIdstrRowId)||(ARCIMBillGrpRowIdAuFlag=1))&&((ARCIMItemCatDRAuStr[ARCIMItemCatDRstrRowId)||(ARCIMItemCatDRAuFlag=1))&&((ARCIMBillingUOMDRAuStr[ARCIMBillingUOMDRstrRowId)||(ARCIMBillingUOMDRAuFlag=1))&&((ARCIMDefPriorityDRAuStr[ARCIMDefPriorityDRstrRowId)||(ARCIMDefPriorityDRAuFlag=1))&&((ARCIMDerFeeRulesDRAuStr[ARCIMDerFeeRulesDRstrRowId)||(ARCIMDerFeeRulesDRAuFlag=1))&&((ARCIMServiceGroupDRAuStr[ARCIMServiceGroupDRstrRowId)||(ARCIMServiceGroupDRAuFlag=1))
                {
                    s ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)                  ;代码
                    
                    s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)               ;开始日期
                    s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
                    s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
                    s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)              ;结束日期
            
                    CONTINUE:(ARCIMEffDate'="")&&(ARCIMEffDate>+$H)
                    CONTINUE:(ARCIMEffDateTo'="")&&(ARCIMEffDateTo<+$H)
            
                    
                    
                    // s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
                    s ARCIMItemCatDRDesc="",OECOrderCatDR="",OECOrderCatDRDesc=""
                    if (ARCIMItemCatDR'="")
                    {
                        s ARCIMItemCatDRDesc=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)                  ;医嘱子分类描述
                        s OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)  
                        if (OECOrderCatDR'="")  s OECOrderCatDRDesc=$p($g(^OEC("ORCAT",OECOrderCatDR)),"^",2)
                    }   

                    if '((((ordercatdesc="bed")||(subcatdesc="bed"))&&(ARCIMItemCatDRDesc["床")&&(ARCIMItemCatDRDesc'["临床"))||(subcatdesc="")||(ARCIMItemCatDRDesc[subcatdesc)) continue
                    
                    if ($ZCONVERT(ARCIMCode,"U")[code)&((ordercat="")||(ordercat=OECOrderCatDR))&((subcat="")||(subcat=ARCIMItemCatDR))
                    {
                        s count=count+1
                        if (count<start) continue
                        if ((count<(start+limit)))
                        {
                            if CurrentCount=0
                            {
                                s CurrentCount=1
                            }
                            else
                            {
                                s CurrentCount=CurrentCount+1
                                w ","
                            }
                            s ARCIMCode =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMCode)
                            s ARCIMDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMDesc)
                    
                            w "{""ARCIMRowId"":"""_ARCIMRowId_""",""ARCIMDesc"":"""_ARCIMDesc_"""}"
                        }

                    }
                }
            }
        }
        w "],""total"":"""_count_""",""success"":""true""}"
    }
    q ""
}

/// Creator：基础数据平台组 chenying
/// CreatDate: 2014-11-21
/// Description：数据重复校验
/// Table： ARC_ItmMast
/// Input：id, code, desc,hospid(医院id）
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.CT.ARCItmMast).FormValidate("","","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
    n (code,desc,id,hospid)
    s flag=0
    if $$ALPHAUP^SSUTIL4(code)'=""
    {
        s sub=0
        for
        {
            s sub=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),sub)) q:sub=""
            s version=0
            for
            {
                s version=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),sub,version)) q:version=""
                IF ($p($g(^ARCIM(sub,version,1)),"^",1)=code)
                {
                    S idc=sub_"||"_version
                    //s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
                    //continue:showflag="N"
                    if (id="")||((id'="")&&(id'=idc)) s flag=1
                }
            }
        }
    }
    if $p($g(^Config.BDP(..#SQLTableName,+hospid)),"^",8)'="false"
    {
        if $$ALPHAUP^SSUTIL4(desc)'=""
        {
            s sub=0
            for
            {
                s sub=$O(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(desc),sub)) q:sub=""
                s version=0
                for
                {
                    s version=$O(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(desc),sub,version)) q:version=""
                    
                    IF ($p($g(^ARCIM(sub,version,1)),"^",2)=desc) 
                    {
                        s ARCIMEffDateTo=$p($g(^ARCIM(sub,version,7)),"^",1)              ;结束日期
                        continue:ARCIMEffDateTo'=""   ///不校验结束的数据
                         S idd=sub_"||"_version
                         if ((id'="")&&(id'=idd))||(id="")
                         {
                             s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
                             continue:showflag="N"
                             s flag=1
                         }
                    }
                }
            }
        }
    }
    q flag
}

/// Function: 添加医嘱项
/// CraeteDate: 2013-5-15
/// Others : 陈莹
/// Debug:   w ##class(web.DHCBL.CT.ARCItmMast).Save()
/// Input:arcimrowid  医嘱项rowid 
/// ArcItmMastStr:代码^描述^缩写^医嘱子分类^帐单组^帐单子组^计帐单位^默认优先级^开始日期^结束日期10^医嘱提示^服务组^服务/材料^医嘱项别名^收费规定^Text1^Text2^Text3^Text4^Text5
/// ArcimCheckboxStr：小时医嘱^已故病人专用^显示累计^使用ODBC模板^限制为急诊病人用^限制为住院病人用^限制为门诊病人用^限制为体检病人用^敏感医嘱^独立医嘱^无库存医嘱^加急医嘱
/// ZeroFeeStr：零收费项信息
/// AddOrdLinkTar:关联收费项信息
/// 2017-03-30修改， 整合复制和添加方法
ClassMethod Save(arcimrowid, ArcItmMastStr, ZeroFeeStr, AddOrdLinkTar, ArcimCheckboxStr, LinkHospId As %String = "") As %String
{
    n (arcimrowid,ArcItmMastStr, ZeroFeeStr, AddOrdLinkTar, ArcimCheckboxStr,LinkHospId,%session)
    if '$d(%session) Quit "{sucess:'false',info:'获取不到session!'}"
    Set ARCIMCode=$p(ArcItmMastStr,"^",1)
    if ARCIMCode="" Quit "{success:'false',info:'医嘱代码不能为空!'}"
    
    S length=$$$comMemberArrayGet("User.ARCItmMast",$$$cCLASSproperty,"ARCIMCode",$$$cPROPparameter,"MAXLEN")
    if $l(ARCIMCode)>length Quit "{success:'false',info:'医嘱代码长度不能超过"_length_"!'}"
    
    Set ARCIMDesc=$p(ArcItmMastStr,"^",2)                      ;名称
    if ARCIMDesc="" Quit "{success:'false',info:'医嘱名称不能为空!'}"
    
    s flag= ##class(web.DHCBL.CT.ARCItmMast).FormValidate("",ARCIMCode,"",LinkHospId)
    If flag=1 Quit "{success:'false',info:'医嘱代码已经存在, 不能重复添加!'}"
    
    s flag= ##class(web.DHCBL.CT.ARCItmMast).FormValidate("","",ARCIMDesc,LinkHospId)
    If flag=1 Quit "{success:'false',info:'医嘱名称已经存在, 不能重复添加!'}"
    
    Set ARCIMAbbrev=$p(ArcItmMastStr,"^",3)                     ;缩写

    s ARCIMCode =##class(web.DHCBL.BDP.FunLib).Util(ARCIMCode)
    s ARCIMDesc =##class(web.DHCBL.BDP.FunLib).Util(ARCIMDesc)
    s ARCIMAbbrev =##class(web.DHCBL.BDP.FunLib).Util(ARCIMAbbrev)

    If ARCIMAbbrev="" Do
    .Set ARCIMAbbrev=ARCIMDesc

    Set ARCIMItemCatDR=$p(ArcItmMastStr,"^",4)                            ;医嘱子分类
    Set billgroupdr=$p(ArcItmMastStr,"^",5)                               ;帐单组
    Set ARCIMBillSubDR=$p(ArcItmMastStr,"^",6)                            ;帐单子组
    Set ARCIMBillingUOMDR=$p(ArcItmMastStr,"^",7)                         ;计帐单位
    
    ///2021-01-28非药品类医嘱 账单单位不能为空。药品账单单位不必填
    if ARCIMItemCatDR'=""
    {
        s ARCICOrderType = $p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
        if (ARCICOrderType'="R")  //医嘱子分类类型不为药品
        {
            if (ARCIMBillingUOMDR="") Quit "{success:'false',info:'非药品类医嘱 账单单位不能为空!'}"
        }
    }
    
    
    Set ARCIMDefPriorityDR=$p(ArcItmMastStr,"^",8)                        ;默认优先级
    Set ARCIMEffDate=$p(ArcItmMastStr,"^",9)                              ;开始日期
    Set ARCIMEffDateTo=$p(ArcItmMastStr,"^",10)                           ;结束日期
    If ARCIMEffDate'="" Set ARCIMEffDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(ARCIMEffDate)
    If ARCIMEffDateTo'="" Set ARCIMEffDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(ARCIMEffDateTo)
    Set ARCIMOEMessage=$p(ArcItmMastStr,"^",11)                           ;医嘱提示
    Set ARCIMServiceGroupDR=$p(ArcItmMastStr,"^",12)                      ;服务组
    Set ARCIMServMaterial=$p(ArcItmMastStr,"^",13)                        ;服务/材料
    Set Alias=$p(ArcItmMastStr,"^",14)                                    ;医嘱项别名 
    Set ARCIMDerFeeRulesDR=$p(ArcItmMastStr,"^",15)                       ;收费规定       
    s ARCIMText1=$p($g(ArcItmMastStr),"^",16)
    s ARCIMText2=$p($g(ArcItmMastStr),"^",17)
    s ARCIMText3=$p($g(ArcItmMastStr),"^",18)
    s ARCIMText4=$p($g(ArcItmMastStr),"^",19)
    s ARCIMText5=$p($g(ArcItmMastStr),"^",20)
    
    s ARCIMPatientOrderFile1=$p($g(ArcItmMastStr),"^",21)
    s ARCIMPatientOrderFile2=$p($g(ArcItmMastStr),"^",22)
    s ARCIMPatientOrderFile3=$p($g(ArcItmMastStr),"^",23)
    s ARCIMMaxCumDose=$p($g(ArcItmMastStr),"^",24)
    s ARCIMMaxQtyPerDay=$p($g(ArcItmMastStr),"^",25)
    s ARCIMMaxQty=$p($g(ArcItmMastStr),"^",26) 
    
    s lengthArcimCheckboxStr=$l(ArcimCheckboxStr,"^")
    for i=1:1:lengthArcimCheckboxStr
    {
        s myValuei=$p(ArcimCheckboxStr,"^",i)
        if myValuei="true" s $p(ArcimCheckboxStr,"^",i)="Y"
        else  s $p(ArcimCheckboxStr,"^",i)="N"  
    }
    
    s ARCIMChgOrderPerHour=$p($g(ArcimCheckboxStr),"^",1)                 ;小时医嘱
    s ARCIMDeceasedPatientsOnly=$p($g(ArcimCheckboxStr),"^",2)            ;已故病人专用
    s ARCIMDisplayCumulative=$p($g(ArcimCheckboxStr),"^",3)               ;显示累计
    s ARCIMUseODBCforWord=$p($g(ArcimCheckboxStr),"^",4)                  ;使用ODBC模板
    s ARCIMRestrictEM=$p($g(ArcimCheckboxStr),"^",5)                      ;限制为急诊病人用
    s ARCIMRestrictIP=$p($g(ArcimCheckboxStr),"^",6)                      ;限制为住院病人用
    s ARCIMRestrictOP=$p($g(ArcimCheckboxStr),"^",7)                      ;限制为门诊病人用        
    s ARCIMRestrictHP=$p($g(ArcimCheckboxStr),"^",8)                      ;限制为体检病人用
    s ARCIMSensitiveOrder=$p($g(ArcimCheckboxStr),"^",9)                  ;敏感医嘱
    Set ARCIMOrderOnItsOwn=$p($G(ArcimCheckboxStr),"^",10)                ;独立医嘱
    Set ARCIMAllowOrderWOStockCheck=$p(ArcimCheckboxStr,"^",11)           ;无库存医嘱
    Set ARCIMSensitive=$p(ArcimCheckboxStr,"^",12)                        ;加急医嘱
    s ARCIMDefSensitive=$p($g(ArcimCheckboxStr),"^",13)                   ;默认加急
    s ARCIMAllowInputFreq=$p($g(ArcimCheckboxStr),"^",14)             ;允许录入频次
    s ARCIMScanCodeBilling=$p($g(ArcimCheckboxStr),"^",15)            ;是否扫码计费
    
    Set obj=##class(User.ARCItmMast).%New()
    Set obj.ARCIMCode=ARCIMCode                                           ;医嘱代码
    Set obj.ARCIMDesc=ARCIMDesc                                           ;医嘱描述
    Set obj.ARCIMAbbrev=ARCIMAbbrev                                       ;缩写
    Do obj.ARCIMItemCatDRSetObjectId(ARCIMItemCatDR)                      ;医嘱子分类
    Do obj.ARCIMBillSubDRSetObjectId(ARCIMBillSubDR)                      ;帐单子组
    Do obj.ARCIMBillingUOMDRSetObjectId(ARCIMBillingUOMDR)                ;计帐单位
    Do obj.ARCIMDefPriorityDRSetObjectId(ARCIMDefPriorityDR)              ;默认优先级
    Do obj.ARCIMDerFeeRulesDRSetObjectId(ARCIMDerFeeRulesDR)              ;收费规定 
    Do obj.ARCIMServiceGroupDRSetObjectId(ARCIMServiceGroupDR)            ;服务组
    if $d(%session) Do obj.ARCIMUpdateUserSetObjectId($g(%session.Data("LOGON.USERID")))                       ;修改人
    Set obj.ARCIMOrderOnItsOwn=ARCIMOrderOnItsOwn                         ;独立医嘱
    Set obj.ARCIMAllowOrderWOStockCheck=ARCIMAllowOrderWOStockCheck       ;无库存医嘱
    Set obj.ARCIMSensitive=ARCIMSensitive                                 ;加急医嘱

    If ARCIMOEMessage'="" Do                                              ;医嘱提示框
    .Set OEMessagLen=$LENGTH(ARCIMOEMessage,""_$c(13,10)_"")
    .For i=1:1:OEMessagLen Do
    ..Set DataString=$P(ARCIMOEMessage,""_$c(13,10)_"",i)
    ..Do obj.ARCIMOEMessage.Insert(DataString)                            ;插入医嘱提示
  

    Set obj.ARCIMServMaterial=ARCIMServMaterial                           ;服务/材料
    Set obj.ARCIMUpdateDate=$p($h,",",1)                                  ;修改日期
    Set obj.ARCIMUpdateTime=$p($h,",",2)                                  ;修改时间
    Set obj.ARCIMChgPostFlg="O"                                           ;ARCIM_ChgPostFlg
    Set obj.ARCIMEffDate=ARCIMEffDate
    Set obj.ARCIMEffDateTo=ARCIMEffDateTo
    s obj.ARCIMChgOrderPerHour=ARCIMChgOrderPerHour
    s obj.ARCIMDeceasedPatientsOnly=ARCIMDeceasedPatientsOnly
    s obj.ARCIMDisplayCumulative=ARCIMDisplayCumulative
    s obj.ARCIMUseODBCforWord =ARCIMUseODBCforWord 
    s obj.ARCIMRestrictEM=ARCIMRestrictEM
    s obj.ARCIMRestrictIP =ARCIMRestrictIP 
    s obj.ARCIMRestrictOP =ARCIMRestrictOP 
    s obj.ARCIMRestrictHP=ARCIMRestrictHP
    s obj.ARCIMScanCodeBilling=ARCIMScanCodeBilling
    s obj.ARCIMSensitiveOrder=ARCIMSensitiveOrder
    s obj.ARCIMDefSensitive=ARCIMDefSensitive
    s obj.ARCIMAllowInputFreq=ARCIMAllowInputFreq
    
    s obj.ARCIMText1=ARCIMText1
    s obj.ARCIMText2=ARCIMText2
    s obj.ARCIMText3=ARCIMText3
    s obj.ARCIMText4=ARCIMText4
    s obj.ARCIMText5=ARCIMText5
    s obj.ARCIMPatientOrderFile1=ARCIMPatientOrderFile1
    s obj.ARCIMPatientOrderFile2=ARCIMPatientOrderFile2
    s obj.ARCIMPatientOrderFile3=ARCIMPatientOrderFile3
    s obj.ARCIMMaxCumDose=ARCIMMaxCumDose
    s obj.ARCIMMaxQtyPerDay=ARCIMMaxQtyPerDay
    s obj.ARCIMMaxQty=ARCIMMaxQty
    //s obj.ARCIMSystemCategory=ARCIMSystemCategory

    //添加医嘱项事务-01
    s eobj = ##class(web.Entity.CT.ARCItmMast).%New()
    s eobj.ARCIMCode=ARCIMCode                                               ;医嘱代码
    s eobj.ARCIMDesc=ARCIMDesc                                               ;医嘱名称
    s eobj.ARCIMAbbrev=ARCIMAbbrev                                           ;缩写
    s eobj.ARCIMItemCatDR=ARCIMItemCatDR                                     ;医嘱子分类
    s eobj.ARCIMBillSubDR=ARCIMBillSubDR                                     ;帐单子组
    s eobj.ARCIMBillingUOMDR=ARCIMBillingUOMDR                               ;计帐单位
    s eobj.ARCIMDefPriorityDR=ARCIMDefPriorityDR                             ;默认优先级
    s eobj.ARCIMServiceGroupDR=ARCIMServiceGroupDR                           ;服务组
    s eobj.ARCIMDerFeeRulesDR=ARCIMDerFeeRulesDR                             ;收费规定
    if $d(%session) s eobj.ARCIMUpdateUser=$g(%session.Data("LOGON.USERID"))   ;修改人
    s eobj.ARCIMOrderOnItsOwn= ARCIMOrderOnItsOwn                            ;独立医嘱 
    s eobj.ARCIMAllowOrderWOStockCheck =ARCIMAllowOrderWOStockCheck          ;无库存医嘱
    s eobj.ARCIMServMaterial=ARCIMServMaterial                               ;服务/材料 
    s eobj.ARCIMSensitive=ARCIMSensitive                                     ;加急医嘱
    s eobj.ARCIMChgPostFlg="O"
    s eobj.ARCIMEffDate=ARCIMEffDate                                         ;开始日期
    s eobj.ARCIMEffDateTo=ARCIMEffDateTo                                     ;结束日期 
    s eobj.ARCIMUpdateDate=$p($h,",",1)                                      ;修改日期
    s eobj.ARCIMUpdateTime=$p($h,",",2)                                      ;修改时间
    s eobj.ARCIMText1= ARCIMText1
    s eobj.ARCIMText2= ARCIMText2
    s eobj.ARCIMText3= ARCIMText3
    s eobj.ARCIMText4= ARCIMText4
    s eobj.ARCIMText5= ARCIMText5
    s eobj.ARCIMOEMessage=ARCIMOEMessage 
    s eobj.ARCIMSensitiveOrder=ARCIMSensitiveOrder
    s eobj.ARCIMDefSensitive=ARCIMDefSensitive 
    s eobj.ARCIMAllowInputFreq=ARCIMAllowInputFreq 
    s eobj.ARCIMChgOrderPerHour=ARCIMChgOrderPerHour
    s eobj.ARCIMDeceasedPatientsOnly=ARCIMDeceasedPatientsOnly
    s eobj.ARCIMDisplayCumulative=ARCIMDisplayCumulative
    s eobj.ARCIMUseODBCforWord =ARCIMUseODBCforWord 
    s eobj.ARCIMRestrictEM=ARCIMRestrictEM
    s eobj.ARCIMRestrictIP =ARCIMRestrictIP 
    s eobj.ARCIMRestrictOP =ARCIMRestrictOP 
    s eobj.ARCIMRestrictHP=ARCIMRestrictHP
   	s eobj.ARCIMScanCodeBilling=ARCIMScanCodeBilling
    s eobj.ARCIMPatientOrderFile1=ARCIMPatientOrderFile1
    s eobj.ARCIMPatientOrderFile2=ARCIMPatientOrderFile2
    s eobj.ARCIMPatientOrderFile3=ARCIMPatientOrderFile3
    s eobj.ARCIMMaxCumDose=ARCIMMaxCumDose
    s eobj.ARCIMMaxQtyPerDay=ARCIMMaxQtyPerDay
    s eobj.ARCIMMaxQty=ARCIMMaxQty
    //s eobj.ARCIMSystemCategory=ARCIMSystemCategory
    Tstart   
    Set sc=obj.%Save()
    If $$$ISERR(sc){
        Trollback
        s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项","web.DHCBL.CT.ARCItmMast","Save",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        Quit "{success:'false',info:'医嘱项添加失败, 请重新操作!'}"
    }
    Tc
    Set arcimrowid=obj.%Id()  //添加医嘱项的arcim_owid
    // 医嘱项新增时，保存医嘱项的日志
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItmMast","User.ARCItmMast","医嘱项",arcimrowid,ARCIMDesc,"A",eobj)
    d eobj.%Close()
 
 
 
    ///保存医嘱项的有效日期记录
    s flag= ##class(web.DHCBL.BDP.FunLib).IsValidClassName("web.DHCBL.CT.ARCItmMastUpdInfo")
    if (flag=1)
    {
        d ##class(web.DHCBL.CT.ARCItmMastUpdInfo).SaveData(arcimrowid,ARCIMEffDate,ARCIMEffDateTo)
    }
    
    
    
    /// 别名
    if (Alias'="")
    {
        s length=$l(Alias,"/")
        for i=1:1:length
        {
            s str=$p(Alias,"/",i)
            continue:str=""
            d ##class(web.DHCBL.CT.ARCAlias).AddOrderAlias(arcimrowid_"^"_str)
        }
    }
    
    ///调用配置
    d ##class(web.DHCBL.CT.ARCItmMast).ConfigInterface(arcimrowid,LinkHospId)
    //改为开启医院级授权后，医嘱项默认添加页面选中的医院
    s flag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")
    if (flag="Y")
    {
        s newAddOrdHosp=arcimrowid_"^"_LinkHospId
        d ##class(web.DHCBL.CT.ARCItemHosp).AddARCItemHosp(newAddOrdHosp)
    }
    //添加零收费项目、并做医嘱项与零收费项目关联事务-03
    If ZeroFeeStr'="" 
    {
        
        s flag=$o(^DHCOLT(0,"ARTTA",arcimrowid,0))
        If flag'="" Quit "{success:'false',info:'该医嘱项已经存在收费项目对照关系,不能再添加零收费项!'}"
        s ZeroFeeStr=ZeroFeeStr_"^"_arcimrowid_"^"_ARCIMCode_"^"_ARCIMDesc_"^"_ARCIMBillingUOMDR
        Ts
        s ZeroFeeResult= ##class(web.DHCBL.CT.ARCItmMast).AddZeroTarToLink(ZeroFeeStr)
        If ZeroFeeResult["success:'true'" {
            tc
        }
        else {
            tro
            q "{success:'false',info:"_$p(ZeroFeeResult,"errorinfo:",2)
        }
        
        
    }
 
    //添加收费项目关联医嘱项事务-04
    if (AddOrdLinkTar'="")
    {
        Tstart
        s tarlength=$length(AddOrdLinkTar,"*")
        s saveflag=0
        for i=1:1:tarlength 
        {
            s StrAddOrdLinkTar=$p(AddOrdLinkTar,"*",i) 
            s newAddOrdLinkTar=arcimrowid_"^"_StrAddOrdLinkTar
            s SaveRet=##class(web.DHCBL.CT.DHCOrderLinkTar).AddOrdLinkTar(newAddOrdLinkTar)
            if SaveRet["success:'false'" s saveflag=1
        }
        If (saveflag=0)
        {
            Tc
        }
        else
        {
            Trollback
            Quit "{success:'false',info:'医嘱项添加成功！部分医嘱项与收费项目关联失败, 请重新关联！'}"
        }
    }
    ///往PACS同步医嘱项数据 2020-05-22
    s SyncPACSFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPSyncPACS")
    if (SyncPACSFlag="Y"){
        d ##class(web.DHCBL.BDP.BDPInterface).PACSUpdateARCIM(arcimrowid)   
    }
    
    Quit "{success:'true',id:'"_arcimrowid_"'}"
}

/// Function:  修改医嘱项
/// Creator:   陈莹
/// Input:arcimrowid  医嘱项rowid 
/// ArcItmMastStr:代码^描述^缩写^医嘱子分类^帐单组^帐单子组^计帐单位^默认优先级^开始日期^结束日期10^医嘱提示^服务组^服务/材料^医嘱项别名^收费规定^Text1^Text2^Text3^Text4^Text5
/// ArcimCheckboxStr：小时医嘱^已故病人专用^显示累计^使用ODBC模板^限制为急诊病人用^限制为住院病人用^限制为门诊病人用^限制为体检病人用^敏感医嘱^独立医嘱^无库存医嘱^加急医嘱
/// ZeroFeeStr：零收费项信息
/// AddOrdLinkTar:关联收费项信息
ClassMethod update(arcimrowid As %String, ArcItmMastStr As %String, ZeroFeeStr As %String, ArcimCheckboxStr As %String, LinkHospId As %String = "") As %String
{
    n (arcimrowid,ArcItmMastStr, ZeroFeeStr, ArcimCheckboxStr,LinkHospId,%session)
    
    
    Set OldARCIMCode=$p($g(^ARCIM($p(arcimrowid,"||",1),$p(arcimrowid,"||",2),1)),"^",1)  ;被修改医嘱项的原代码
    Set OldARCIMDesc=$p($g(^ARCIM($p(arcimrowid,"||",1),$p(arcimrowid,"||",2),1)),"^",2)  ;被修改医嘱项的原名称
    
    s arcim=""
    Set ARCIMCode=$p(ArcItmMastStr,"^",1)
    if ARCIMCode="" Quit "{success:'false',info:'医嘱代码不能为空!'}"
    
    S length=$$$comMemberArrayGet("User.ARCItmMast",$$$cCLASSproperty,"ARCIMCode",$$$cPROPparameter,"MAXLEN")
    if $l(ARCIMCode)>length Quit "{success:'false',info:'医嘱代码长度不能超过"_length_"!'}"
    
    Set ARCIMDesc=$p(ArcItmMastStr,"^",2)                                   ;名称
    if ARCIMDesc="" Quit "{success:'false',info:'医嘱名称不能为空!'}"
    s flag= ##class(web.DHCBL.CT.ARCItmMast).FormValidate(arcimrowid,ARCIMCode,"",LinkHospId)
    If flag=1 Quit "{success:'false',info:'医嘱代码已经存在, 不能重复!'}"
    
    s flag= ##class(web.DHCBL.CT.ARCItmMast).FormValidate(arcimrowid,"",ARCIMDesc,LinkHospId)
    If flag=1 Quit "{success:'false',info:'医嘱名称已经存在, 不能重复!'}"
    

    Set ARCIMAbbrev=$p(ArcItmMastStr,"^",3)                                        ;缩写

    s ARCIMCode =##class(web.DHCBL.BDP.FunLib).Util(ARCIMCode)
    s ARCIMDesc =##class(web.DHCBL.BDP.FunLib).Util(ARCIMDesc)
    s ARCIMAbbrev =##class(web.DHCBL.BDP.FunLib).Util(ARCIMAbbrev)
    
    Set ARCIMItemCatDR=$p(ArcItmMastStr,"^",4)                                     ;医嘱子分类Dr
    Set billgroupdr=$p(ArcItmMastStr,"^",5)                                        ;帐单组Dr
    Set ARCIMBillSubDR=$p(ArcItmMastStr,"^",6)                                     ;帐单子组Dr
    Set ARCIMBillingUOMDR=$p(ArcItmMastStr,"^",7)                                  ;计帐单位Dr
    
    ///2020-04-23限制 医嘱项界面不能修改药品账单单位
    if ARCIMItemCatDR'=""
    {
        s ARCICOrderType = $p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
        if ARCICOrderType="R"  //医嘱子分类类型为药品
        {
            s OldARCIMBillingUOMDR=$p($g(^ARCIM($p(arcimrowid,"||",1),$p(arcimrowid,"||",2),8)),"^",14) 
            if (ARCIMBillingUOMDR'=OldARCIMBillingUOMDR) Quit "{success:'false',info:'医嘱项界面不能修改药品账单单位!'}"
        }
        else
        {
            ///2021-01-28非药品类医嘱 账单单位不能为空
            if (ARCIMBillingUOMDR="") Quit "{success:'false',info:'非药品类医嘱 账单单位不能为空!'}"
        }
    }
    Set ARCIMDefPriorityDR=$p(ArcItmMastStr,"^",8)                                 ;默认优先级Dr
    Set ARCIMEffDate=$p(ArcItmMastStr,"^",9)                                       ;开始日期
    Set ARCIMEffDateTo=$p(ArcItmMastStr,"^",10)                                    ;结束日期
    Set:ARCIMEffDate'="" ARCIMEffDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(ARCIMEffDate)   
    SET:ARCIMEffDateTo'="" ARCIMEffDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(ARCIMEffDateTo)
    Set ARCIMOEMessage=$p(ArcItmMastStr,"^",11)                                    ;医嘱提示框
    Set ARCIMServiceGroupDR=$p(ArcItmMastStr,"^",12)                               ;服务组Dr
    Set ARCIMServMaterial=$p(ArcItmMastStr,"^",13)                                 ;服务/材料
    s ARCIMDerFeeRulesDR=$p(ArcItmMastStr,"^",15)                                  ;收费规定

    s ARCIMText1=$p(ArcItmMastStr,"^",16)
    s ARCIMText2=$p(ArcItmMastStr,"^",17)
    s ARCIMText3=$p(ArcItmMastStr,"^",18)
    s ARCIMText4=$p(ArcItmMastStr,"^",19)
    s ARCIMText5=$p(ArcItmMastStr,"^",20)
    
    s ARCIMPatientOrderFile1=$p($g(ArcItmMastStr),"^",21)  ///2010824
    s ARCIMPatientOrderFile2=$p($g(ArcItmMastStr),"^",22)
    s ARCIMPatientOrderFile3=$p($g(ArcItmMastStr),"^",23)
    s ARCIMMaxCumDose=$p($g(ArcItmMastStr),"^",24)
    s ARCIMMaxQtyPerDay=$p($g(ArcItmMastStr),"^",25)
    s ARCIMMaxQty=$p($g(ArcItmMastStr),"^",26) 
    
    s lengthArcimCheckboxStr=$l(ArcimCheckboxStr,"^")
    for i=1:1:lengthArcimCheckboxStr
    {
        s myValuei=$p(ArcimCheckboxStr,"^",i)
        if myValuei="true" s $p(ArcimCheckboxStr,"^",i)="Y"
        else  s $p(ArcimCheckboxStr,"^",i)="N"  
    }
    
    s ARCIMChgOrderPerHour=$p($g(ArcimCheckboxStr),"^",1)   
    s ARCIMDeceasedPatientsOnly=$p($g(ArcimCheckboxStr),"^",2)  
    s ARCIMDisplayCumulative=$p($g(ArcimCheckboxStr),"^",3) 
    s ARCIMUseODBCforWord=$p($g(ArcimCheckboxStr),"^",4)    
    s ARCIMRestrictEM=$p($g(ArcimCheckboxStr),"^",5)    
    s ARCIMRestrictIP=$p($g(ArcimCheckboxStr),"^",6)    
    s ARCIMRestrictOP=$p($g(ArcimCheckboxStr),"^",7)    
    s ARCIMRestrictHP=$p($g(ArcimCheckboxStr),"^",8)    
    s ARCIMSensitiveOrder=$p($g(ArcimCheckboxStr),"^",9)
    S ARCIMOrderOnItsOwn=$p(ArcimCheckboxStr,"^",10)                                ;独立医嘱
    
    
    
    
    S ARCIMAllowOrderWOStockCheck=$p(ArcimCheckboxStr,"^",11)                       ;无库存医嘱
    S ARCIMSensitive=$p(ArcimCheckboxStr,"^",12)                                    ;加急医嘱            
    s ARCIMDefSensitive=$p($g(ArcimCheckboxStr),"^",13)
    s ARCIMAllowInputFreq=$p(ArcimCheckboxStr,"^",14)                               ;允许录入频次
    s ARCIMScanCodeBilling=$p(ArcimCheckboxStr,"^",15)                              ;是否扫码计费

    /// 用于记录一个原始数据,日志保存 
    s eobj = ##class(web.Entity.CT.ARCItmMast).%New()
    s eobj.ARCIMRowId=arcimrowid
    s eobj.ARCIMCode=ARCIMCode                                                      ;医嘱代码
    s eobj.ARCIMDesc=ARCIMDesc                                                      ;医嘱名称
    s eobj.ARCIMAbbrev=ARCIMAbbrev                                                  ;缩写
    s eobj.ARCIMItemCatDR=ARCIMItemCatDR                                            ;医嘱子分类
    s eobj.ARCIMBillSubDR=ARCIMBillSubDR                                            ;帐单子组
    s eobj.ARCIMBillingUOMDR=ARCIMBillingUOMDR                                      ;计帐单位
    s eobj.ARCIMDefPriorityDR=ARCIMDefPriorityDR                                    ;默认优先级
    s eobj.ARCIMServiceGroupDR=ARCIMServiceGroupDR                                  ;服务组
    s eobj.ARCIMDerFeeRulesDR=ARCIMDerFeeRulesDR                                    ;收费规定
    if $d(%session) s eobj.ARCIMUpdateUser=$g(%session.Data("LOGON.USERID"))
    s eobj.ARCIMOrderOnItsOwn= ARCIMOrderOnItsOwn                                   ;独立医嘱 
    s eobj.ARCIMAllowOrderWOStockCheck=ARCIMAllowOrderWOStockCheck                  ;无库存医嘱
    s eobj.ARCIMServMaterial=ARCIMServMaterial                                      ;服务/材料 
    s eobj.ARCIMSensitive=ARCIMSensitive                                            ;加急医嘱
    s eobj.ARCIMChgPostFlg="O"
    s eobj.ARCIMEffDate=ARCIMEffDate                                                ;开始日期
    s eobj.ARCIMEffDateTo=ARCIMEffDateTo                                            ;结束日期 
    s eobj.ARCIMUpdateDate=$p($h,",",1)                                             ;修改日期
    s eobj.ARCIMUpdateTime=$p($h,",",2)                                             ;修改时间
    s eobj.ARCIMText1= ARCIMText1
    s eobj.ARCIMText2= ARCIMText2
    s eobj.ARCIMText3= ARCIMText3
    s eobj.ARCIMText4= ARCIMText4
    s eobj.ARCIMText5= ARCIMText5
    s eobj.ARCIMOEMessage=ARCIMOEMessage 
    s eobj.ARCIMSensitiveOrder=ARCIMSensitiveOrder 
    s eobj.ARCIMDefSensitive=ARCIMDefSensitive
    s eobj.ARCIMAllowInputFreq=ARCIMAllowInputFreq
    s eobj.ARCIMChgOrderPerHour=ARCIMChgOrderPerHour
    s eobj.ARCIMDeceasedPatientsOnly=ARCIMDeceasedPatientsOnly
    s eobj.ARCIMDisplayCumulative=ARCIMDisplayCumulative
    s eobj.ARCIMUseODBCforWord =ARCIMUseODBCforWord 
    s eobj.ARCIMRestrictEM=ARCIMRestrictEM
    s eobj.ARCIMRestrictIP =ARCIMRestrictIP 
    s eobj.ARCIMRestrictOP =ARCIMRestrictOP 
    s eobj.ARCIMRestrictHP=ARCIMRestrictHP
    
    s eobj.ARCIMPatientOrderFile1=ARCIMPatientOrderFile1
    s eobj.ARCIMPatientOrderFile2=ARCIMPatientOrderFile2
    s eobj.ARCIMPatientOrderFile3=ARCIMPatientOrderFile3
    
    s eobj.ARCIMMaxCumDose=ARCIMMaxCumDose
    s eobj.ARCIMMaxQtyPerDay=ARCIMMaxQtyPerDay
    s eobj.ARCIMMaxQty=ARCIMMaxQty
    
    s eobj.ARCIMScanCodeBilling=ARCIMScanCodeBilling
    s oobj=##class(User.ARCItmMast).%OpenId(arcimrowid)
    s bobj=##class(web.Entity.CT.ARCItmMast).%New()

    s bobj.ARCIMRowId=arcimrowid
    s bobj.ARCIMCode=oobj.ARCIMCode                                                     ;医嘱代码 
    s bobj.ARCIMDesc=oobj.ARCIMDesc                                                     ;医嘱名称
    s bobj.ARCIMAbbrev=oobj.ARCIMAbbrev                                                 ;缩写
    /*s bobj.ARCIMAbbrev =$tr(bobj.ARCIMAbbrev,"""","")
    s bobj.ARCIMDesc =$tr(bobj.ARCIMDesc,"""","")
    s bobj.ARCIMCode =$tr(bobj.ARCIMCode,"""","")*/
    s:oobj.ARCIMItemCatDR'="" bobj.ARCIMItemCatDR=oobj.ARCIMItemCatDR.%Id()             ;医嘱子分类   
    s:oobj.ARCIMBillSubDR'="" bobj.ARCIMBillSubDR= oobj.ARCIMBillSubDR.%Id()            ;帐单子组
    s:oobj.ARCIMBillingUOMDR'="" bobj.ARCIMBillingUOMDR=oobj.ARCIMBillingUOMDR.%Id()    ;计帐单位 
    s:oobj.ARCIMDefPriorityDR'="" bobj.ARCIMDefPriorityDR=oobj.ARCIMDefPriorityDR.%Id() ;默认优先级
    s:oobj.ARCIMServiceGroupDR'="" bobj.ARCIMServiceGroupDR=oobj.ARCIMServiceGroupDR.%Id() ;服务组
    s:oobj.ARCIMDerFeeRulesDR'="" bobj.ARCIMDerFeeRulesDR= oobj.ARCIMDerFeeRulesDR.%Id() ;收费规定ARCIMDerFeeRulesDR
    s:oobj.ARCIMUpdateUser'="" bobj.ARCIMUpdateUser= oobj.ARCIMUpdateUser.%Id()         ;修改人 ARCIM_UpdateUser
    s bobj.ARCIMOrderOnItsOwn=oobj.ARCIMOrderOnItsOwn                                   ;独立医嘱
    s bobj.ARCIMAllowOrderWOStockCheck=oobj.ARCIMAllowOrderWOStockCheck                 ;无库存医嘱
    s bobj.ARCIMServMaterial= oobj.ARCIMServMaterial                                    ;服务/材料 
    s bobj.ARCIMSensitive=oobj.ARCIMSensitive                                           ;加急医嘱
    s bobj.ARCIMChgPostFlg=oobj.ARCIMChgPostFlg
    s bobj.ARCIMEffDate=oobj.ARCIMEffDate                                               ;开始日期
    s bobj.ARCIMEffDateTo=oobj.ARCIMEffDateTo                                           ;结束日期 
    s EffDateOld=bobj.ARCIMEffDate                                                      ;开始日期
    s EffDateToOld=bobj.ARCIMEffDateTo
    s bobj.ARCIMUpdateDate=oobj.ARCIMUpdateDate                                         ;修改日期
    s bobj.ARCIMUpdateTime=oobj.ARCIMUpdateTime                                         ;修改时间
    s bobj.ARCIMText1=oobj.ARCIMText1
    s bobj.ARCIMText2=oobj.ARCIMText2
    s bobj.ARCIMText3=oobj.ARCIMText3                                
    s bobj.ARCIMText4=oobj.ARCIMText4
    s bobj.ARCIMText5=oobj.ARCIMText5
    s bobj.ARCIMPatientOrderFile1=oobj.ARCIMPatientOrderFile1
    s bobj.ARCIMPatientOrderFile2=oobj.ARCIMPatientOrderFile2
    s bobj.ARCIMPatientOrderFile3=oobj.ARCIMPatientOrderFile3
    
    s bobj.ARCIMMaxCumDose=oobj.ARCIMMaxCumDose
    s bobj.ARCIMMaxQtyPerDay=oobj.ARCIMMaxQtyPerDay
    s bobj.ARCIMMaxQty=oobj.ARCIMMaxQty
    s myARCIMOEMessage=""
    if oobj.ARCIMOEMessage'=""
    {
        s myCount=oobj.ARCIMOEMessage.Count()   
        s myARCIMOEMessage=oobj.ARCIMOEMessage.GetAt(myCount)   
    }    
    s bobj.ARCIMOEMessage=myARCIMOEMessage 
    s bobj.ARCIMSensitiveOrder=oobj.ARCIMSensitiveOrder 
    s bobj.ARCIMDefSensitive=oobj.ARCIMDefSensitive 
    s bobj.ARCIMAllowInputFreq=oobj.ARCIMAllowInputFreq 
    s bobj.ARCIMChgOrderPerHour=oobj.ARCIMChgOrderPerHour
    s bobj.ARCIMDeceasedPatientsOnly=oobj.ARCIMDeceasedPatientsOnly
    s bobj.ARCIMDisplayCumulative=oobj.ARCIMDisplayCumulative
    s bobj.ARCIMUseODBCforWord =oobj.ARCIMUseODBCforWord 
    s bobj.ARCIMRestrictEM=oobj.ARCIMRestrictEM
    s bobj.ARCIMRestrictIP =oobj.ARCIMRestrictIP 
    s bobj.ARCIMRestrictOP =oobj.ARCIMRestrictOP 
    s bobj.ARCIMRestrictHP=oobj.ARCIMRestrictHP
    s bobj.ARCIMScanCodeBilling=oobj.ARCIMScanCodeBilling

    Set obj=##class(User.ARCItmMast).%OpenId(arcimrowid)
    Set obj.ARCIMCode=ARCIMCode ;医嘱代码  ARCIM_Code
    Set obj.ARCIMDesc=ARCIMDesc ;医嘱描述  ARCIM_Desc
    Set obj.ARCIMAbbrev=ARCIMAbbrev                                                      ;缩写
    Do obj.ARCIMItemCatDRSetObjectId(ARCIMItemCatDR)                                     ;医嘱子分类
    Do obj.ARCIMBillSubDRSetObjectId(ARCIMBillSubDR)                                     ;帐单子组
    Do obj.ARCIMBillingUOMDRSetObjectId(ARCIMBillingUOMDR)                               ;计帐单位
    Do obj.ARCIMDefPriorityDRSetObjectId(ARCIMDefPriorityDR)                             ;默认优先级
    Do obj.ARCIMDerFeeRulesDRSetObjectId(ARCIMDerFeeRulesDR)                             ;收费规定 
    Do obj.ARCIMServiceGroupDRSetObjectId(ARCIMServiceGroupDR)                           ;服务组
    if $d(%session) Do obj.ARCIMUpdateUserSetObjectId($g(%session.Data("LOGON.USERID")))
    Set obj.ARCIMOrderOnItsOwn=ARCIMOrderOnItsOwn                                        ;独立医嘱
    Set obj.ARCIMAllowOrderWOStockCheck=ARCIMAllowOrderWOStockCheck                      ;无库存医嘱
    Set obj.ARCIMServMaterial=ARCIMServMaterial                                          ;服务/材料
    Set obj.ARCIMUpdateDate=$p($h,",",1)                                                 ;修改日期
    Set obj.ARCIMUpdateTime=$p($h,",",2)                                                 ;修改时间
    Set obj.ARCIMSensitive=ARCIMSensitive                                                ;加急医嘱
    Set obj.ARCIMSensitiveOrder=ARCIMSensitiveOrder                                      ;敏感医嘱
    Set obj.ARCIMDefSensitive=ARCIMDefSensitive                                          ;默认加急
    Set obj.ARCIMAllowInputFreq=ARCIMAllowInputFreq                                ;允许录入频次
    Set obj.ARCIMChgPostFlg="O"                                                          ;ARCIM_ChgPostFlg   
    Set obj.ARCIMEffDate=ARCIMEffDate
    Set obj.ARCIMEffDateTo=ARCIMEffDateTo
      
    
    
                                           
    Set SUBSCRIPTION=$p(arcimrowid,"||",1)
    Set VERSION=$p(arcimrowid,"||",2)

    Set OEMNum=$g(^ARCIM(SUBSCRIPTION,VERSION,"OEM",0))
    if (OEMNum>=1) K ^ARCIM(SUBSCRIPTION,VERSION,"OEM")
    if ARCIMOEMessage'=""                                                                ;医嘱提示框 ARCIM_OEMessage  为List类型
    {
        Set OEMessagLen=$LENGTH(ARCIMOEMessage,""_$c(13,10)_"")
        Set ^ARCIM(SUBSCRIPTION,VERSION,"OEM",0)=OEMessagLen
        For i=1:1:OEMessagLen
        {
            Set DataString=$P(ARCIMOEMessage,""_$c(13,10)_"",i)
            Do obj.ARCIMOEMessage.SetAt(DataString,i)                                    ;修改List类型语法
        }
    }
    else
    {
        Set ^ARCIM(SUBSCRIPTION,VERSION,"OEM",0)=1  //解决备注为空值时没有修改成功的bug 2017-12-19
        Do obj.ARCIMOEMessage.SetAt("",1)
    } 
    s obj.ARCIMChgOrderPerHour=ARCIMChgOrderPerHour
    s obj.ARCIMDeceasedPatientsOnly=ARCIMDeceasedPatientsOnly
    s obj.ARCIMDisplayCumulative=ARCIMDisplayCumulative
    s obj.ARCIMUseODBCforWord =ARCIMUseODBCforWord 
    s obj.ARCIMRestrictEM=ARCIMRestrictEM
    s obj.ARCIMRestrictIP =ARCIMRestrictIP 
    s obj.ARCIMRestrictOP =ARCIMRestrictOP 
    s obj.ARCIMRestrictHP=ARCIMRestrictHP
    s obj.ARCIMScanCodeBilling=ARCIMScanCodeBilling
    s obj.ARCIMText1= ARCIMText1
    s obj.ARCIMText2= ARCIMText2
    s obj.ARCIMText3= ARCIMText3
    s obj.ARCIMText4= ARCIMText4
    s obj.ARCIMText5= ARCIMText5
    s obj.ARCIMPatientOrderFile1=ARCIMPatientOrderFile1
    s obj.ARCIMPatientOrderFile2=ARCIMPatientOrderFile2
    s obj.ARCIMPatientOrderFile3=ARCIMPatientOrderFile3
    s obj.ARCIMMaxCumDose=ARCIMMaxCumDose
    s obj.ARCIMMaxQtyPerDay=ARCIMMaxQtyPerDay
    s obj.ARCIMMaxQty=ARCIMMaxQty
    
    
    Tstart  //修改医嘱项事务
    Set sc=obj.%Save()
    If $$$ISERR(sc){
        Trollback
        s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项","web.DHCBL.CT.ARCItmMast","update",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        Quit "{success:'false',info:'医嘱项修改失败, "_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
    }
    Tc
    ///  记录修改后的数据 
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItmMast","User.ARCItmMast","医嘱项",arcimrowid,ARCIMDesc,"U",eobj,bobj)
 
    ///医嘱项描述修改时
    if (ARCIMDesc'=OldARCIMDesc)
    {
        s ALIASText=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ARCIMDesc)
        s SaveDataStr=arcimrowid_"^"_ALIASText_"^^"
        d ##class(web.DHCBL.CT.ARCAlias).AddOrderAlias(SaveDataStr) 
    }
    
    
    ///chenying 20180331 
    ///医嘱项修改  需要更新别名里医嘱项描述、医嘱子分类和医嘱项独立标志
    ///独立和非独立医嘱时索引不同,独立医嘱的索引 ARC("ALIAS",0,"DescVIOS",TEXT,Desc)
    s aliasflag=##class(web.DHCBL.CT.ARCAlias).BatchUpdate(arcimrowid)  
    
    ///保存医嘱项的有效日期记录
    s flag= ##class(web.DHCBL.BDP.FunLib).IsValidClassName("web.DHCBL.CT.ARCItmMastUpdInfo")
    if (flag=1)
    {
        if ((ARCIMEffDate'=EffDateOld)||(ARCIMEffDateTo'=EffDateToOld))
        {       
            d ##class(web.DHCBL.CT.ARCItmMastUpdInfo).SaveData(arcimrowid,ARCIMEffDate,ARCIMEffDateTo)  
        }
    }

    d eobj.%Close()
 
    //添加收费项目,及医嘱项与收费项目的关联,事务-02
    If ZeroFeeStr'="" {
        s flag=$o(^DHCOLT(0,"ARTTA",arcimrowid,0))
        If flag'="" Quit "{success:'false',info:'该医嘱项已经存在收费项目对照关系,不能再添加零收费项!'}"
        s ZeroFeeStr=ZeroFeeStr_"^"_arcimrowid_"^"_ARCIMCode_"^"_ARCIMDesc_"^"_ARCIMBillingUOMDR
        Ts
        s ZeroFeeResult= ##class(web.DHCBL.CT.ARCItmMast).AddZeroTarToLink(ZeroFeeStr)
        If ZeroFeeResult["success:'true'" 
        {
            tc
        }
        else
        {
            tro
            q "{success:'false',info:"_$p(ZeroFeeResult,"errorinfo:",2)
        }
        
    }
    
    ///往PACS同步医嘱项数据 2020-05-22
    s SyncPACSFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPSyncPACS")
    if (SyncPACSFlag="Y"){
        d ##class(web.DHCBL.BDP.BDPInterface).PACSUpdateARCIM(arcimrowid)   
    }
    Quit "{success:'true',id:'"_arcimrowid_"'}"
}

/// Function:删除时验证数据是否被引用
/// Input :  id
/// Creator: sunfengchao
/// Others : last update by sunfengchao
ClassMethod GetRefFlag(id As %String) As %String
{
    n (id)
    s return="",myInfo=""
    
    //1 是否被"安全组-医嘱子类明细"引用
    s flag=0
    s rowid=0 
    for
    {
        s rowid=$o(^SSU("SSGRP",rowid)) q:rowid=""  q:flag
        s sub2=0
        for
        {
            s sub2=$o(^SSU("SSGRP",rowid,"SSORD",sub2)) q:sub2=""  q:flag
            i ($d(^SSU("SSGRP",rowid,"SSORD",sub2,"ITM",0,"ARCIM",id))) s flag=1
        }
    }
    i (flag) s myInfo=myInfo_"<安全组-医嘱子类明细>" 
    

    //2 是否被"科室/部门/病区-床位类型"引用
    s flag=0
    s rowid=0 
    for
    {
        s rowid=$o(^PAC("BEDTP",rowid)) q:rowid=""  q:flag
        i ($p($g(^PAC("BEDTP",rowid)),"^",4)=id) s flag=1
    }
    i (flag) s myInfo=myInfo_"<科室/部门/病区-床位类型>"

    //3 是否被"科室/部门/病区-房间类型"引用
    s flag=0
    s rowid=0
    for
    {
        s rowid=$o(^PAC("ROOMT",rowid)) q:rowid=""  q:flag
        i ($p($g(^PAC("ROOMT",rowid)),"^",3)=id) s flag=1
    }
    i (flag) s myInfo=myInfo_"<科室/部门/病区-房间类型>"

    //4 是否被"库存项"引用
    s flag=0
    s rowid=0
    for
    {
        s rowid=$o(^INCI(rowid)) q:rowid=""  q:flag
        i ($p($g(^INCI(rowid,1)),"^",3)=id) s flag=1
    }
    i (flag) s myInfo=myInfo_"<库存项>"

    //5 是否被"麻醉剂"引用
    s flag=0
    s rowid=0
    for
    {
        s rowid=$o(^ORC("ANAGN",rowid)) q:rowid=""  q:flag
        i ($p($g(^ORC("ANAGN",rowid)),"^",3)=id) s flag=1
    }
    i (flag) s myInfo=myInfo_"<麻醉剂>"

    //6 是否被"手术/过程"或"手术关联医嘱项"引用
    i ($d(^ORC("OPER",0,"ARCIM",id)))  s myInfo=myInfo_"<手术/过程 或 手术关联医嘱项>"

    //7 是否被"医嘱项收费项关联"引用
    s flag=0
    s rowid=0
    for
    {
        s rowid=$o(^DHCOLT(rowid)) q:rowid=""  q:flag
        i ($p($g(^DHCOLT(rowid)),"^",1)=id) s flag=1
    }
    i (flag) s myInfo=myInfo_"<医嘱项与收费项关联>"

    
    //8 是否被"检查通用名和HIS项目对照表"引用
    s Code=$p($g(^ARCIM($p(id,"||",1),$p(id,"||",2),1)),"^",1)
    s ServerMaterial=$p($g(^ARCIM($p(id,"||",1),$p(id,"||",2),7)),"^",6)    
    i (ServerMaterial="S")
    {
        i ($o(^DHCPHGENCON(0,"HisCode",Code,"")))
        {
            s GICTRowId=$o(^DHCPHGENCON(0,"HisCode",Code,0))
            s GICTCode=$p($g(^DHCPHGENCON(GICTRowId)),"^",1) //通用名代码
            s GICTCodeU=$ZCONVERT(GICTCode,"U")
            s PHEGRowId=$o(^DHCPHEGENi(0,"Code",GICTCodeU,0)) //通用名ID
            s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
            s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
            s PHLICodeU=$ZCONVERT(PHLICode,"U")
            i ((PHLICodeU="CHECK")||(PHLICodeU="ULTR")||(PHLICodeU="RADI")||(PHLICodeU="ENDO")){
                s myInfo=myInfo_"<检查通用名和HIS项目对照表>"  
            }   
        }
    }   
    
    //9 是否被"心电项目与HIS项目对照表"引用
    s Code=$p($g(^ARCIM($p(id,"||",1),$p(id,"||",2),1)),"^",1)  
    s ItemCatDr=$p($g(^ARCIM($p(id,"||",1),$p(id,"||",2),1)),"^",10)     ; 医嘱子分类 
    if (ItemCatDr'=""){
        s OrderType=$P($g(^ARC("IC",ItemCatDr)),"^",7) 
        i ((OrderType'="L")&(OrderType'="S")&(OrderType'="R"))
        {
            i ($o(^DHCPHGENCON(0,"HisCode",Code,"")))
            {
                s GICTRowId=$o(^DHCPHGENCON(0,"HisCode",Code,0))
                s GICTCode=$p($g(^DHCPHGENCON(GICTRowId)),"^",1) //通用名代码
                s GICTCodeU=$ZCONVERT(GICTCode,"U")
                s PHEGRowId=$o(^DHCPHEGENi(0,"Code",GICTCodeU,0)) //通用名ID
                s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
                s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
                s PHLICodeU=$ZCONVERT(PHLICode,"U")
                i (PHLICodeU="ELECT"){
                    s myInfo=myInfo_"<心电项目与HIS项目对照表>"
                }   
            }   
        }   
    }
  
    //10 是否被"医嘱项关联医嘱项"引用
    s flag=0
    s sub=0 
    for
    {
        s sub=$o(^ARCIM(0,"ARCIMLA",id,sub)) q:sub=""  q:flag=1
        s version=$o(^ARCIM(0,"ARCIMLA",id,sub,0))
        s flag=1
        i (flag=1) s myInfo=myInfo_"<医嘱项关联医嘱项>"
    }

    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"

    q return
}

/// Function: 删除医嘱项
/// CreateDate:2013-8-23
/// Input:医嘱项rowid
/// others: update by sunfengchao
/// w ##class(web.DHCBL.CT.ARCItmMast).DeleteData("13945||1")
ClassMethod DeleteData(id As %String) As %String
{
    n (id,%session)
    s result=""
    q:id="" ""

    //验证是否被引用
    s re=..GetRefFlag(id)
    if ($p(re,"^",1)) {
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    { 
        s eobj = ##class(web.Entity.CT.ARCItmMast).%New()
  
        /// 删除时的日志记录
        s eobj.ARCIMRowId = id  
        S ARCIMSubscript=$P(id,"||",1)
        S ARCIMVersion=$P(id,"||",2)
        s eobj.ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)  
        s eobj.ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
        s eobj.ARCIMCode =##class(web.DHCBL.BDP.FunLib).Util(eobj.ARCIMCode)
        s eobj.ARCIMDesc =##class(web.DHCBL.BDP.FunLib).Util(eobj.ARCIMDesc)                                                
        s eobj.ARCIMAbbrev=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",3)                  
        s eobj.ARCIMAbbrev=##class(web.DHCBL.BDP.FunLib).Util(eobj.ARCIMAbbrev)
        s eobj.ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)               ;医嘱子分类   
        s eobj.ARCIMBillSubDR= $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)               ;帐单子组
        s eobj.ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)            ;计帐单位 
        s eobj.ARCIMDefPriorityDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",22)           ;默认优先级
        s eobj.ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7)           ;服务组
        s eobj.ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)           ;收费规定

        s eobj.ARCIMOrderOnItsOwn= $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",13)          ;独立医嘱
        s eobj.ARCIMAllowOrderWOStockCheck=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",11)  ;无库存医嘱
        s eobj.ARCIMServMaterial=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",6)             ;服务/材料 
        s eobj.ARCIMSensitive=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",18)               ;加急医嘱
        s eobj.ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)                 ;开始日期
        s eobj.ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)                ;结束日期 
        
        s eobj.ARCIMText1=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",32)    
        s eobj.ARCIMText2=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",33)    
        s eobj.ARCIMText3=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",34)    
        s eobj.ARCIMText4=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",35)    
        s eobj.ARCIMText5=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",36) 
        
        s eobj.ARCIMUpdateDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",1)               ;修改日期
        s eobj.ARCIMUpdateTime=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",2)               ;修改时间
        s eobj.ARCIMUpdateUser=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",3)
        s eobj.ARCIMSensitiveOrder=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",22)
        s eobj.ARCIMChgOrderPerHour=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",25) 
        s eobj.ARCIMDeceasedPatientsOnly=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",29) 
        s eobj.ARCIMDisplayCumulative=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",23) 
        s eobj.ARCIMUseODBCforWord =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",6) 
        s eobj.ARCIMRestrictEM=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",12) 
        s eobj.ARCIMRestrictIP =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",13) 
        s eobj.ARCIMRestrictOP =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",14) 
        s eobj.ARCIMRestrictHP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",15) 
        s eobj.ARCIMDefSensitive=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",41)
        s eobj.ARCIMAllowInputFreq=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",42) 
        s eobj.ARCIMScanCodeBilling=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",22) 
        
        ts
        s sc=##class(User.ARCItmMast).%DeleteId(id)
        if $$$ISOK(sc)
        {
            tc
            s result= "{success:'true',info:'删除成功！'}" 
            ///删除医嘱项接收科室 add @2017-2-28
            s locid=0
            for
            {
                s locid=$o(^ARCRL(id,locid)) q:locid=""
                d ##class(web.DHCBL.CT.ARCItmRecLoc).DeleteData(id_"||"_locid)
            }
            ///删除医嘱项别名
            s aliasid=0
            for
            {
                s aliasid=$o(^ARC("ALIAS",0,"ARCIM",id,aliasid)) q:aliasid=""
                d ##class(web.DHCBL.CT.ARCAlias).DeleteData(aliasid)
            }
            
            //保存日志
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItmMast","User.ARCItmMast","医嘱项",id,eobj.ARCIMDesc,"D",eobj)
        }
        else 
        {
            tro
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项","web.DHCBL.CT.ARCItmMast","DeleteData",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        }
    }
    q result
}

/// 陈莹
/// 2017-03-21
/// Function: 添加零收费项目
/// Others: 
/// w ##class(web.DHCBL.CT.ARCItmMast).AddZeroTarToLink(ZeroFeeStr)
ClassMethod AddZeroTarToLink(ZeroFeeStr As %String) As %String
{
    n (ZeroFeeStr,%session)
    
    Set myArcimrowid=$p(ZeroFeeStr,"^",8)       ;在ARC_ItmMast表中arcim_rowid
    s flag=$o(^DHCOLT(0,"ARTTA",myArcimrowid,0))
    If flag'="" Quit "{success:'false',info:'该医嘱项已经存在收费项目对照关系,不能再添加零收费项!'}"
    
    s newtarieobj=##class(web.Entity.CT.DHCTarItem).%New()  
    s newtarieobj.TARICode =$p(ZeroFeeStr,"^",9)
    s newtarieobj.TARIDesc= $p(ZeroFeeStr,"^",10)
    s newtarieobj.TARIActiveFlag="Y"
    S newtarieobj.TARIUOM=$p(ZeroFeeStr,"^",11)                          ;收费基本单位
    s newtarieobj.TARISubCate=$p(ZeroFeeStr,"^",1)                       ;收费子分类
    s newtarieobj.TARIEMCCate=$p(ZeroFeeStr,"^",2)                       ;核算子分类
    s newtarieobj.TARIAcctCate=$p(ZeroFeeStr,"^",3)                      ;会计子分类
    s newtarieobj.TARIInpatCate=$p(ZeroFeeStr,"^",4)                     ;住院子分类
    s newtarieobj.TARIOutpatCate=$p(ZeroFeeStr,"^",5)                    ;门诊子分类
    s newtarieobj.TARIMRCate=$p(ZeroFeeStr,"^",6)                        ;病案首页子分类
    s newtarieobj.TARIMCNew=$p(ZeroFeeStr,"^",7)                         ;新病案首页分类
    
    s tariresult= ##class(web.DHCBL.CT.DHCTarItem).SaveEntity(newtarieobj)
    if tariresult["success:'true'" 
    {
        s tarirowid=##class(web.DHCBL.BDP.FunLib).GetResultRowId(tariresult)
        s Qty=1
        s insertOltLinkStr=myArcimrowid_"^"_tarirowid_"^"_Qty
        s oltlinkRs=##class(web.DHCBL.CT.DHCOrderLinkTar).AddOrdLinkTar(insertOltLinkStr)
        if oltlinkRs["success:'true'" 
        {
            s TPPatInsType=1
            s priceStr=TPPatInsType_"^0^^^^"
            s priceRs=##class(web.DHCBL.CT.DHCTarItemPrice).SaveAll(tarirowid,priceStr)
            if priceRs["success:'true'" s Rs=tariresult
            else  s Rs=priceRs
        }
        else{
            s Rs=oltlinkRs  
        }
    }
    else{
        s Rs=tariresult
    }
    q Rs
}

///  Function: 获取医嘱项的价格
///  Creator:  sunfengchao
///  CreateDate: 2015-8-5
///  Input:arcimrowid（医嘱项rowid）,hospid（医院id）
///  Return: 医嘱项 目前的价格
///  w ##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice("14009||1")
ClassMethod GetOrderPrice(arcimrowid As %String, hospid As %String = "") As %String
{
    n (arcimrowid,hospid,%session)
    S $ZT="ERROR"
    Set aricmprice=""
    if hospid="" Set hospid=$g(%session.Data("LOGON.HOSPID"))
    s aricmprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcimrowid,+$h,"","","","",hospid)
    //s aricmprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcimrowid,+$h,"","","","")
    s price=$p(aricmprice,"^",1)
    if $e(price,1)="." s price="0"_price
    q price
ERROR
    Q "ERROR"
}

/// Function: 获取收费项价格
/// CreateDate:2016-8-26
/// Creator: chenying
/// Input:tarirowide(收费项rowid),hospid（医院id）
/// Retrun:收费项价格
/// w ##class(web.DHCBL.CT.ARCItmMast).GetTariPrice("22",2)
ClassMethod GetTariPrice(tarirowid As %String, hospid As %String = "") As %String
{
    n (tarirowid,hospid,%session)
    s $zt="ERROR"
    q:tarirowid="" ""
    if hospid="" s hospid=$g(%session.Data("LOGON.HOSPID"))
    s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(tarirowid,+$h,"","","",hospid)
    //s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(tarirowid,+$h,"","","")
    s tarprice=$p(priceinfo,"^",1)
    if $e(tarprice,1)="." S tarprice="0"_tarprice
    s tarprice=$tr(tarprice,$c(10),"")
    s tarprice=$tr(tarprice,$c(13),"")
    s tarprice=$tr(tarprice,$c(0),"")    
    q tarprice
}

/// CreatDate:2016-5-11
/// Creator:chenying
/// w ##class(web.DHCBL.CT.ARCItmMast).GetLastARCItmMastCode()
/// Return: 获取最后一条医嘱项数据的代码
/// 深圳宝安中医院需求 
ClassMethod GetLastARCItmMastCode() As %String
{
    s code=""
    s ARCIMSubscript=$o(^ARCIM(""),-1)
    s ARCIMVersion=0
    for 
    {
        s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:(ARCIMVersion="")    
        s code=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)  
    }
    q code
}

/// Creator:chenying
/// w ##class(web.DHCBL.CT.ARCItmMast).GetARCIMEnable("1||1")
/// Input: ARCIMRowId （医嘱项rowid）
/// CreatDate:2016-5-11
/// 开始日期是今天的医嘱可以开，结束日期是今天的也可以开
/// Return: Y、N  判断医嘱是否可用
/// 不判断医嘱为否是独立医嘱，只判断日期：开始日期不为空并早于今天，结束日期为空或者结束日期晚于今天  
ClassMethod GetARCIMEnable(ARCIMRowId) As %String
{
    n (ARCIMRowId)
    s enableFlag="N"
    q:ARCIMRowId="" enableFlag
    s ARCIMSubscript=$p(ARCIMRowId,"||",1)
    s ARCIMVersion=$p(ARCIMRowId,"||",2)
    //s ARCIMOrderOnItsOwn = $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",13)    ;独立医嘱  (ARCIMOrderOnItsOwn="Y")&
    s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)       ; 开始日期
    s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
    s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
    s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)      ; 结束日期
    if ((ARCIMEffDate'="")&(ARCIMEffDate<=+$h))&((ARCIMEffDateTo="")||((ARCIMEffDateTo'="")&(ARCIMEffDateTo>=+$h))) s enableFlag="Y"
    q enableFlag
}

/// Creator:chenying
/// CreatDate:2016-5-11
/// Description:判断这条医嘱项是否被库存项关联
/// w ##class(web.DHCBL.CT.ARCItmMast).IsLinkedByINCItm("1||1")
/// Input: ARCIMRowId （医嘱项rowid）
/// Return: Y、N判断这条医嘱项是否被库存项关联  Y关联  N没被关联
ClassMethod IsLinkedByINCItm(ARCIMRowId) As %String
{
    q:ARCIMRowId="" "N"
    s flag="N"
    s incirowid=$o(^INCI(0,"ARCIM_DR",$p(ARCIMRowId,"||",1),0))
    if incirowid'="" s flag="Y"
    Q flag
}

/// Creator:chenying
/// CreatDate:2016-5-11
/// Description:判断这条医嘱项是否被库存项关联
/// w ##class(web.DHCBL.CT.ARCItmMast).GetLinkedINCRowId("1||1")
/// Input: ARCIMRowId （医嘱项rowid）
/// Return: Y、N判断这条医嘱项是否被库存项关联  Y关联  N没被关联
ClassMethod GetLinkedINCRowId(ARCIMRowId) As %String
{
    q:ARCIMRowId="" "N"
    s flag="N"
    s incirowid=$o(^INCI(0,"ARCIM_DR",$p(ARCIMRowId,"||",1),0))
    if incirowid'="" s flag="Y"
    Q flag
}

/// Creator:陈莹
/// CreatDate:2016-8-18
/// Description:添加/修改 医嘱项
/// Table:User.ARCItmMast
/// Input:web.Entity.CT.ARCItmMast
/// Return:成功返回success:'true'和新增或修改的数据的ARCIMRowId;失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.CT.ARCItmMast).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCItmMast) As %String
{
    new (eobj,%session)
    s result=""
    if $IsObject(eobj)
    {
        s:eobj.ARCIMAllowOrderWOStockCheck="" eobj.ARCIMAllowOrderWOStockCheck="N"
        s:eobj.ARCIMOrderOnItsOwn="" eobj.ARCIMOrderOnItsOwn="N"
        s:eobj.ARCIMSensitive="" eobj.ARCIMSensitive="N"
        s:eobj.ARCIMChgOrderPerHour="" eobj.ARCIMChgOrderPerHour="N"
        s:eobj.ARCIMDeceasedPatientsOnly="" eobj.ARCIMDeceasedPatientsOnly="N"
        s:eobj.ARCIMDisplayCumulative="" eobj.ARCIMDisplayCumulative="N"
        s:eobj.ARCIMUseODBCforWord="" eobj.ARCIMUseODBCforWord="N"
        s:eobj.ARCIMRestrictEM="" eobj.ARCIMRestrictEM="N"
        s:eobj.ARCIMRestrictIP="" eobj.ARCIMRestrictIP="N"
        s:eobj.ARCIMRestrictOP="" eobj.ARCIMRestrictOP="N"
        s:eobj.ARCIMRestrictHP="" eobj.ARCIMRestrictHP="N"
        s:eobj.ARCIMSensitiveOrder="" eobj.ARCIMSensitiveOrder="N"
        s:eobj.ARCIMDefSensitive="" eobj.ARCIMDefSensitive="N"
        s:eobj.ARCIMSensitive="N" eobj.ARCIMDefSensitive="N"  //【加急医嘱】的checkbox勾选后才可以勾选【默认加急】标识
        s:eobj.ARCIMAllowInputFreq="" eobj.ARCIMAllowInputFreq="N"
        s:eobj.ARCIMScanCodeBilling="" eobj.ARCIMScanCodeBilling="N" //是否扫码计费

        //前台js已添加空值判断、重复判断、开始日期是否小于结束日期
        s:eobj.ARCIMEffDate'="" eobj.ARCIMEffDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ARCIMEffDate)
        s:eobj.ARCIMEffDate="" eobj.ARCIMEffDate=+$h
        s:eobj.ARCIMEffDateTo'="" eobj.ARCIMEffDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ARCIMEffDateTo)
        Set eobj.ARCIMCode=##class(web.DHCBL.BDP.FunLib).Util(eobj.ARCIMCode)                                ;医嘱代码  ARCIM_Code
        Set eobj.ARCIMDesc=##class(web.DHCBL.BDP.FunLib).Util(eobj.ARCIMDesc)                                ;医嘱描述  ARCIM_Desc
        Set eobj.ARCIMAbbrev=##class(web.DHCBL.BDP.FunLib).Util(eobj.ARCIMAbbrev)
        
        s flag=..FormValidate(eobj.ARCIMRowId,eobj.ARCIMCode,eobj.ARCIMDesc,eobj.LinkHospId)
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
            
        }
        else
        {
            if (eobj.ARCIMRowId="")       
            {
                s obj=##class(User.ARCItmMast).%New()
            }
            else                           
            {
                s obj=##class(User.ARCItmMast).%OpenId(eobj.ARCIMRowId)
        
                s bobj=##class(web.Entity.CT.ARCItmMast).%New()
                s bobj.ARCIMCode=obj.ARCIMCode                                          ;医嘱代码
                s bobj.ARCIMDesc=obj.ARCIMDesc                                          ;医嘱描述
                s bobj.ARCIMAbbrev=obj.ARCIMAbbrev                                      ;缩写
                s:obj.ARCIMItemCatDR'="" bobj.ARCIMItemCatDR=obj.ARCIMItemCatDR.%Id()   ;医嘱子分类 ARCIM_ItemCat_DR
                s:obj.ARCIMBillSubDR'="" bobj.ARCIMBillSubDR=obj.ARCIMBillSubDR.%Id()   ;帐单子组  ARCIM_BillSub_DR
                s:obj.ARCIMBillingUOMDR'="" bobj.ARCIMBillingUOMDR=obj.ARCIMBillingUOMDR.%Id()         ;计帐单位 ARCIM_BillingUOM_DR
                s:obj.ARCIMDefPriorityDR'="" bobj.ARCIMDefPriorityDR=obj.ARCIMDefPriorityDR.%Id()      ;默认优先级 ARCIM_DefPriority_DR
                s:obj.ARCIMServiceGroupDR'="" bobj.ARCIMServiceGroupDR=obj.ARCIMServiceGroupDR.%Id()   ;服务组 ARCIM_ServiceGroup_DR
                s:obj.ARCIMDerFeeRulesDR'="" bobj.ARCIMDerFeeRulesDR=obj.ARCIMDerFeeRulesDR.%Id()      ;收费规定    
                s:obj.ARCIMUpdateUser'="" bobj.ARCIMUpdateUser=obj.ARCIMUpdateUser.%Id()               ;添加人 ARCIM_UpdateUser
                s:obj.ARCIMPHCDFDR'="" bobj.ARCIMPHCDFDR=obj.ARCIMPHCDFDR.%Id()         ;药物
                
                Set bobj.ARCIMServMaterial=obj.ARCIMServMaterial                        ;服务/材料 ARCIM_ARCIMServMaterial
                Set bobj.ARCIMOrderOnItsOwn=obj.ARCIMOrderOnItsOwn                      ;独立医嘱  ARCIM_OrderOnItsOwn
                Set bobj.ARCIMAllowOrderWOStockCheck=obj.ARCIMAllowOrderWOStockCheck    ;无库存医嘱 ARCIM_AllowOrderWOStockCheck
                Set bobj.ARCIMSensitive=obj.ARCIMSensitive                              ;加急医嘱
                Set bobj.ARCIMServMaterial=obj.ARCIMServMaterial                        ;服务/材料 ARCIM_ARCIMServMaterial
    
            
                Set bobj.ARCIMUpdateDate=obj.ARCIMUpdateDate                            ;添加日期 ARCIM_UpdateDate
                Set bobj.ARCIMUpdateTime=obj.ARCIMUpdateTime                            ;添加时间 ARCIM_UpdateTime
                Set bobj.ARCIMChgPostFlg=obj.ARCIMChgPostFlg                            ;ARCIM_ChgPostFlg  查找必须赋值，才能添加的原因?
                Set bobj.ARCIMEffDate=obj.ARCIMEffDate                                  ;开始日期  ARCIM_EffDate
                Set bobj.ARCIMEffDateTo=obj.ARCIMEffDateTo                              ;结束日期  ARCIM_EffDateTo
                s EffDateOld=obj.ARCIMEffDate
                s EffDateToOld=obj.ARCIMEffDateTo
                s bobj.ARCIMChgOrderPerHour=obj.ARCIMChgOrderPerHour
                s bobj.ARCIMDeceasedPatientsOnly=obj.ARCIMDeceasedPatientsOnly
                s bobj.ARCIMDisplayCumulative=obj.ARCIMDisplayCumulative
                s bobj.ARCIMUseODBCforWord =obj.ARCIMUseODBCforWord 
                s bobj.ARCIMRestrictEM=obj.ARCIMRestrictEM
                s bobj.ARCIMRestrictIP =obj.ARCIMRestrictIP 
                s bobj.ARCIMRestrictOP =obj.ARCIMRestrictOP 
                s bobj.ARCIMRestrictHP=obj.ARCIMRestrictHP
                s bobj.ARCIMScanCodeBilling=obj.ARCIMScanCodeBilling
                s bobj.ARCIMSensitiveOrder=obj.ARCIMSensitiveOrder
                s bobj.ARCIMDefSensitive=obj.ARCIMDefSensitive
                s bobj.ARCIMText1=obj.ARCIMText1
                s bobj.ARCIMText2=obj.ARCIMText2
                s bobj.ARCIMText3=obj.ARCIMText3
                s bobj.ARCIMText4=obj.ARCIMText4
                s bobj.ARCIMText5=obj.ARCIMText5
                
                s bobj.ARCIMPatientOrderFile1=obj.ARCIMPatientOrderFile1
                s bobj.ARCIMPatientOrderFile2=obj.ARCIMPatientOrderFile2
                s bobj.ARCIMPatientOrderFile3=obj.ARCIMPatientOrderFile3
                s bobj.ARCIMMaxCumDose=obj.ARCIMMaxCumDose
                s bobj.ARCIMMaxQtyPerDay=obj.ARCIMMaxQtyPerDay
                s bobj.ARCIMMaxQty=obj.ARCIMMaxQty
                s bobj.ARCIMNoOfCumDays=obj.ARCIMNoOfCumDays
                s bobj.ARCIMAllowInputFreq=obj.ARCIMAllowInputFreq
                
                
                
            }
        
            Set obj.ARCIMCode=eobj.ARCIMCode                                               ;医嘱代码  ARCIM_Code
            Set obj.ARCIMDesc=eobj.ARCIMDesc                                               ;医嘱描述  ARCIM_Desc
            Set obj.ARCIMAbbrev=eobj.ARCIMAbbrev                                           ;缩写      ARCIM_Abbrev
            Do:eobj.ARCIMItemCatDR'="" obj.ARCIMItemCatDRSetObjectId(eobj.ARCIMItemCatDR)  ;医嘱子分类 ARCIM_ItemCat_DR
            Do:eobj.ARCIMItemCatDR="" obj.ARCIMItemCatDRSetObjectId("")
            Do:eobj.ARCIMBillSubDR'="" obj.ARCIMBillSubDRSetObjectId(eobj.ARCIMBillSubDR)
            Do:eobj.ARCIMBillSubDR="" obj.ARCIMBillSubDRSetObjectId("")                    ;帐单子组  ARCIM_BillSub_DR
            Do:eobj.ARCIMBillingUOMDR'="" obj.ARCIMBillingUOMDRSetObjectId(eobj.ARCIMBillingUOMDR)            ;计帐单位 ARCIM_BillingUOM_DR
            Do:eobj.ARCIMBillingUOMDR="" obj.ARCIMBillingUOMDRSetObjectId("")
            Do:eobj.ARCIMDefPriorityDR'="" obj.ARCIMDefPriorityDRSetObjectId(eobj.ARCIMDefPriorityDR)         ;默认优先级 ARCIM_DefPriority_DR
            Do:eobj.ARCIMDefPriorityDR="" obj.ARCIMDefPriorityDRSetObjectId("")
            Do:eobj.ARCIMServiceGroupDR'="" obj.ARCIMServiceGroupDRSetObjectId(eobj.ARCIMServiceGroupDR)      ;服务组 ARCIM_ServiceGroup_DR
            Do:eobj.ARCIMServiceGroupDR="" obj.ARCIMServiceGroupDRSetObjectId("")
            Do:eobj.ARCIMDerFeeRulesDR'="" obj.ARCIMDerFeeRulesDRSetObjectId(eobj.ARCIMDerFeeRulesDR)         ;收费规定 
            Do:eobj.ARCIMDerFeeRulesDR="" obj.ARCIMDerFeeRulesDRSetObjectId("")  
            //Do obj.ARCIMUpdateUserSetObjectId(1) 
            if $d(%session) Do obj.ARCIMUpdateUserSetObjectId($G(%session.Data("LOGON.USERID"))) 
            Do:eobj.ARCIMPHCDFDR'="" obj.ARCIMPHCDFDRSetObjectId(eobj.ARCIMPHCDFDR)         ;药物
            Do:eobj.ARCIMPHCDFDR="" obj.ARCIMPHCDFDRSetObjectId("")
            
            Set obj.ARCIMServMaterial=eobj.ARCIMServMaterial                                ;服务/材料 ARCIM_ARCIMServMaterial
            Set obj.ARCIMOrderOnItsOwn=eobj.ARCIMOrderOnItsOwn                              ;独立医嘱  ARCIM_OrderOnItsOwn
            Set obj.ARCIMAllowOrderWOStockCheck=eobj.ARCIMAllowOrderWOStockCheck            ;无库存医嘱 ARCIM_AllowOrderWOStockCheck
            Set obj.ARCIMSensitive=eobj.ARCIMSensitive                                      ;加急医嘱
            Set obj.ARCIMServMaterial=eobj.ARCIMServMaterial                                ;服务/材料 ARCIM_ARCIMServMaterial

    
            Set obj.ARCIMUpdateDate=$P($h,",",1)                                            ;添加日期 ARCIM_UpdateDate
            Set obj.ARCIMUpdateTime=$p($h,",",2)                                            ;添加时间 ARCIM_UpdateTime
            Set obj.ARCIMChgPostFlg="O"                                                     ;ARCIM_ChgPostFlg  查找必须赋值，才能添加的原因?
            Set obj.ARCIMEffDate=eobj.ARCIMEffDate                                          ;开始日期  ARCIM_EffDate
            Set obj.ARCIMEffDateTo=eobj.ARCIMEffDateTo                                      ;结束日期  ARCIM_EffDateTo
        
            s obj.ARCIMChgOrderPerHour=eobj.ARCIMChgOrderPerHour
            s obj.ARCIMDeceasedPatientsOnly=eobj.ARCIMDeceasedPatientsOnly
            s obj.ARCIMDisplayCumulative=eobj.ARCIMDisplayCumulative
            s obj.ARCIMUseODBCforWord =eobj.ARCIMUseODBCforWord 
            s obj.ARCIMRestrictEM=eobj.ARCIMRestrictEM
            s obj.ARCIMRestrictIP =eobj.ARCIMRestrictIP 
            s obj.ARCIMRestrictOP =eobj.ARCIMRestrictOP 
            s obj.ARCIMRestrictHP=eobj.ARCIMRestrictHP
             
            if (eobj.ARCIMRowId="")       
            {
                If eobj.ARCIMOEMessage'=""                                                      ;医嘱提示框 ARCIM_OEMessage
                {
                
                    Set OEMessagLen=$LENGTH(eobj.ARCIMOEMessage,""_$c(13,10)_"")
                    For i=1:1:OEMessagLen
                    { 
                        Set DataString=$P(eobj.ARCIMOEMessage,""_$c(13,10)_"",i)
                        Do obj.ARCIMOEMessage.Insert(DataString)                            ;插入医嘱提示
                    }
                } 
                
            }
            else                           
            {
                Set ord=$p(eobj.ARCIMRowId,"||",1)
                Set OrdSub=$p(eobj.ARCIMRowId,"||",2)
                
                Set OEMNum=$g(^ARCIM(ord,OrdSub,"OEM",0))
                if (OEMNum>=1) K ^ARCIM(ord,OrdSub,"OEM")

                if eobj.ARCIMOEMessage'=""
                {
                     Set OEMessagLen=$LENGTH(eobj.ARCIMOEMessage,""_$c(13,10)_"")
                     Set ^ARCIM(ord,OrdSub,"OEM",0)=OEMessagLen
                     For i=1:1:OEMessagLen Do
                     .Set DataString=$P(eobj.ARCIMOEMessage,""_$c(13,10)_"",i)
                     .Do obj.ARCIMOEMessage.SetAt(DataString,i)                         ;修改List类型语法

                }
                else
                {
                    Set ^ARCIM(ord,OrdSub,"OEM",0)=1  //解决备注为空值时没有修改成功的bug 2017-12-19
                    Do obj.ARCIMOEMessage.SetAt("",1)
                } 
            }
            
            
            s obj.ARCIMScanCodeBilling=eobj.ARCIMScanCodeBilling  //是否扫码计费
            s obj.ARCIMSensitiveOrder=eobj.ARCIMSensitiveOrder
            s obj.ARCIMDefSensitive=eobj.ARCIMDefSensitive
            s obj.ARCIMText1=eobj.ARCIMText1
            s obj.ARCIMText2=eobj.ARCIMText2
            s obj.ARCIMText3=eobj.ARCIMText3
            s obj.ARCIMText4=eobj.ARCIMText4
            s obj.ARCIMText5=eobj.ARCIMText5
            s obj.ARCIMPatientOrderFile1=eobj.ARCIMPatientOrderFile1
            s obj.ARCIMPatientOrderFile2=eobj.ARCIMPatientOrderFile2
            s obj.ARCIMPatientOrderFile3=eobj.ARCIMPatientOrderFile3
            s obj.ARCIMMaxCumDose=eobj.ARCIMMaxCumDose
            s obj.ARCIMMaxQtyPerDay=eobj.ARCIMMaxQtyPerDay
            s obj.ARCIMMaxQty=eobj.ARCIMMaxQty
            s obj.ARCIMNoOfCumDays=eobj.ARCIMNoOfCumDays
            s obj.ARCIMAllowInputFreq=eobj.ARCIMAllowInputFreq   //允许录入频次
            
            Tstart
            s sc=obj.%Save()
            do obj.%Close()
            if $$$ISOK(sc){
                Tcommit
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"
            
                d:eobj.ARCIMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItmMast","User.ARCItmMast","医嘱项",id,eobj.ARCIMDesc,"A",eobj)
                d:eobj.ARCIMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItmMast","User.ARCItmMast","医嘱项",id,eobj.ARCIMDesc,"U",eobj,bobj)
                ///往PACS同步医嘱项数据 2020-05-22
                s SyncPACSFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPSyncPACS")
                if (SyncPACSFlag="Y"){
                    d ##class(web.DHCBL.BDP.BDPInterface).PACSUpdateARCIM(id)   
                }
                if eobj.ARCIMRowId="" ///添加时自动添加别名
                {
                    
                    d ##class(web.DHCBL.CT.ARCItmMast).ConfigInterface(id,eobj.LinkHospId)
                    
                    //改为开启医院级授权后，医嘱项默认添加页面选中的医院
                    s flag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")
                    if (flag="Y")
                    {
                        s hosplength=$l(eobj.LinkHospId,"/")
                        for hosplengthi=1:1:hosplength 
                        {
                            s HospRowId=$p(eobj.LinkHospId,"/",hosplengthi)
                            d ##class(web.DHCBL.CT.ARCItemHosp).AddARCItemHosp(id_"^"_HospRowId)
                        }
                    }
                    
                }
                else
                {
                    ///保存医嘱项的有效日期记录
                    s flag= ##class(web.DHCBL.BDP.FunLib).IsValidClassName("web.DHCBL.CT.ARCItmMastUpdInfo")
                    if (flag=1)
                    {
                        if ((eobj.ARCIMEffDate'=EffDateOld)||(eobj.ARCIMEffDateTo'=EffDateToOld))
                        {       
                            d ##class(web.DHCBL.CT.ARCItmMastUpdInfo).SaveData(id,eobj.ARCIMEffDate,eobj.ARCIMEffDateTo)    
                        }
                    }
                    
                    d ##class(web.DHCBL.CT.ARCAlias).BatchUpdate(eobj.ARCIMRowId)
                    
                }
                
                
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项","web.DHCBL.CT.ARCItmMast","SaveEntity",eobj)
                s:logid'="" ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
                
            }
        }
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }   
    q result
}

/// Function:添加时，查找一个医嘱大类下的所有医嘱项代码生成码（总共八位，前两位为医嘱大类代码，后六位为生成码）的最大值+1
/// Creator:陈莹
/// FOR 河南省人民医院
/// CreateDate: 2016-9-2
/// input:itemcatid(医嘱子类id)
/// Retrun；按照规则返回医嘱项代码
/// Debug: w ##class(web.DHCBL.CT.ARCItmMast).GetMaxCodeByItemCat(10)
ClassMethod GetMaxCodeByItemCat(itemcatid) As %String
{
    n (itemcatid)
    s str=""
    q:itemcatid="" ""
    s OECOrderCatDR = $p($g(^ARC("IC",itemcatid)),"^",8)
    q:OECOrderCatDR="" ""
    s ORCATCode = $p($g(^OEC("ORCAT",OECOrderCatDR)),"^",1)
    s catlength=$L(ORCATCode)

    k ^TMPARCIMCODE
    s ARCICRowId=0
    for 
    {
        s ARCICRowId=$o(^ARC("IC",0,"OrdCat",OECOrderCatDR,ARCICRowId)) q:ARCICRowId=""
        S ARCIMSubscript=0
        for
        {
            s ARCIMSubscript=$o(^ARCIM(0,"ARCIC_DR",ARCICRowId,ARCIMSubscript))  q:ARCIMSubscript=""
            s ARCIMVersion=0
            for 
            {
                s ARCIMVersion=$o(^ARCIM(0,"ARCIC_DR",ARCICRowId,ARCIMSubscript,ARCIMVersion))  q:ARCIMVersion=""
                s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
                continue:ARCIMRowId=""
                s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
                s ARCIMCode =##class(web.DHCBL.BDP.FunLib).Util(ARCIMCode)
                s CreatARCIMCode=$e(ARCIMCode,catlength+1,catlength+6)
                s CreatARCIMCode=CreatARCIMCode+1   ///先加1
                if (CreatARCIMCode=1)&&(CreatARCIMCode'=000000) continue  //去掉字符串
                s:CreatARCIMCode'="" ^TMPARCIMCODE(CreatARCIMCode)=""
                
            }
        }
    }
    s MaxCode=$o(^TMPARCIMCODE(""),-1)
    while ($o(^ARCIM(0,"Code",ORCATCode_MaxCode,0))'="")    ;代码不能重复
    {
        s MaxCode=MaxCode+1
        
        if $l(MaxCode)<6
        {
            s str1=""
            for codei=1:1:(6-$l(MaxCode))  
            {
                s str1="0"_str1  //考虑  0002+1    补0
            }
            s MaxCode=str1_MaxCode
        }
     
    }
    
    if $l(MaxCode)<6
    {
        s str1=""
        for codei=1:1:(6-$l(MaxCode))  
        {
            s str1="0"_str1  //考虑补0
        }
        s MaxCode=str1_MaxCode
    }
    s str=ORCATCode_MaxCode
    q str
}

/// Function: 获取医嘱项总数，或者医嘱项关联收费项总数
/// CreateDate:2017-1-16 update@2019-0212
/// Creator: chenying
/// w ##class(web.DHCBL.CT.ARCItmMast).GetDataCount("BDPARCIM")
ClassMethod GetDataCount(ExportType) As %String
{
    n (ExportType)
    s count=0,totalcount=0
    if (ExportType="BDPORDERLINK")
    {
        k ^TMP("BDPORDERLINK")
        for
        {
            s count=$o(^TMP("BDPARCIM",count)) q:count=""
            s ARCIMRowId=$g(^TMP("BDPARCIM",count))
            if $d(^DHCOLT(0,"ARTTA",ARCIMRowId))
            {
                s OLTTariffDR=0
                for
                {
                    s OLTTariffDR=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,OLTTariffDR)) q:OLTTariffDR=""   
                    s OLTStartDate=0
                    for
                    {
                        s OLTStartDate=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,OLTTariffDR,OLTStartDate)) q:OLTStartDate=""
                        s OLTRowId=0
                        for
                        {
                            s OLTRowId=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,OLTTariffDR,OLTStartDate,OLTRowId)) q:OLTRowId=""
                            s totalcount=totalcount+1
                            s ^TMP("BDPORDERLINK",totalcount)=ARCIMRowId_"^"_OLTTariffDR_"^"_OLTRowId
                        }
                    }
                }
            }
            else
            {
                s totalcount=totalcount+1
                s ^TMP("BDPORDERLINK",totalcount)=ARCIMRowId    
            }           
        }       
    }
    else
    {
        s totalcount=$o(^TMP("BDPARCIM",""),-1)
    }
    q totalcount
}

/// Function: 获取收费项与医嘱项关联数据总数
/// CreateDate:2017-1-16
/// Creator: chenying
/// w ##class(web.DHCBL.CT.ARCItmMast).GetExceltitlename("BDPARCIM")
ClassMethod GetExceltitlename(ExportType) As %String
{
    n (ExportType)
    if ExportType="BDPORDERLINK"
    {
        s Exceltitlename="医嘱代码&%医嘱名称&%医嘱项价格&%医嘱别名&%计价单位&%医嘱开始日期&%医嘱结束日期&%关联数量&%关联开始日期&%关联结束日期&%收费代码&%收费名称&%收费项开始日期&%收费项结束日期&%收费项有效标志&%收费项别名&%收费项单价&%收费项单位&%医嘱缩写&%医嘱备注&%医嘱大类&%医嘱子分类&%账单大类&%帐单子类&%收费大类&%收费子类&%住院大类&%住院子类&%门诊大类&%门诊子类&%核算大类&%核算子类&%会计大类&%会计子类&%病案大类&%病案子类&%新病案大类&%新病案子类&%默认优先级&%独立医嘱&%检查服务标志(S/M)&%是否打折&%多部位计价一次&%加急医嘱&%小时医嘱&%无库存医嘱&%服务组&%收费规定&%已故病人专用&%显示累计&%使用ODBC模板&%限制急诊&%收费依据&%特殊项目标志&%收费项目外部代码&%收费项目收费说明&%国家医保编码&%国家医保名称&%限制门诊&%限制住院&%项目内涵&%收费项目备注&%除外内容&%是否扫码计费"
        
    }
    else
    {
        s Exceltitlename="医嘱代码&%医嘱名称&%医嘱项价格&%医嘱别名&%计价单位&%医嘱开始日期&%医嘱结束日期&%医嘱缩写&%医嘱备注&%医嘱大类&%医嘱子分类&%账单大类&%帐单子类&%默认优先级&%独立医嘱&%检查服务标志(S/M)&%加急医嘱&%小时医嘱&%无库存医嘱&%服务组&%收费规定&%已故病人专用&%显示累计&%使用ODBC模板&%限制急诊&%限制门诊&%限制住院&%是否扫码计费"
    }
    q Exceltitlename
}

/// Function: 获取第K条医嘱项及其关联的收费项信息,导出信息时调用
/// Input:k (查询到的第几条医嘱项数据）
/// Retrun:医嘱项及其关联的收费项信息
/// CreateDate:2017-1-16 update@2019-0212
/// Creator: chenying
/// w ##class(web.DHCBL.CT.ARCItmMast).GetFieldValue(2,"BDPARCIM")
/// w ##class(web.DHCBL.CT.ARCItmMast).GetFieldValue(3,"BDPORDERLINK")
ClassMethod GetFieldValue(k, ExportType, hospid) As %String
{
    n (k,ExportType,hospid)
    s Value="" 
    i ExportType="BDPORDERLINK"  //导出医嘱项及对照的收费项信息
    {
        s ARCIMRowId=$p($g(^TMP("BDPORDERLINK",k)),"^",1)
        s OLTTariffDR=$p($g(^TMP("BDPORDERLINK",k)),"^",2)
        s OLTRowId=$p($g(^TMP("BDPORDERLINK",k)),"^",3)
        q:ARCIMRowId="" ""
        s (ARCIMCode,ARCIMDesc,OrderPrice,ALIASText1,ARCIMBillingUOMDR,ARCIMEffDate,ARCIMEffDateTo,OLTQty,OLTStartDate,OLTEndDate,TARICode,TARIDesc,TARIStartDate,TARIEndDate,TARIActiveFlag,TARIALIASText1,TariPrice,TARIUOM,ARCIMAbbrev,ARCIMOEMessage,OrdCat,ARCIMItemCatDR,BillGrp,ARCIMBillSubDR,TarCat,TARISubCate,InpaCat,TARIInpatCate,OutpaCat,TARIOutpatCate,EmCat,TARIEMCCate,AcctCat,TARIAcctCate,MrCat,TARIMRCate,MrCatNew,TARIMCNew,ARCIMDefPriorityDR,ARCIMOrderOnItsOwn,ARCIMServMaterial,OLTBascPriceFlag,OLTBillOnceFlag,ARCIMSensitive,ARCIMChgOrderPerHour,ARCIMAllowOrderWOStockCheck,ARCIMServiceGroupDR,ARCIMDerFeeRulesDR,ARCIMDeceasedPatientsOnly,ARCIMDisplayCumulative,ARCIMUseODBCforWord,ARCIMRestrictEM,TARIChargeBasis,TARISpecialFlag,TARIActiveFlag,TARIExternalCode,TARIEngName,TARIInsuName,TARIInsuCode,ARCIMRestrictOP,ARCIMRestrictIP,TARIConnote,TARIRemark,TARIExclude,ARCIMScanCodeBilling)=""
        s ARCIMSubscript=$p(ARCIMRowId,"||",1)
        s ARCIMVersion=$p(ARCIMRowId,"||",2)
        q:(ARCIMSubscript="")||(ARCIMVersion="") ""
        s ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
        s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
        s ARCIMCode =##class(web.DHCBL.BDP.FunLib).Util(ARCIMCode)
        s ARCIMDesc =##class(web.DHCBL.BDP.FunLib).Util(ARCIMDesc)
        s OrderPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIMRowId,+$h,"","","","",hospid)
        s OrderPrice=$p(OrderPrice,"^",1)
        if $e(OrderPrice,1)="." s OrderPrice="0"_OrderPrice
        s ALIASRowId=0,ALIASText1=""
        for
        {
            s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId))
            q:(ALIASRowId="")
            s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
            s:ALIASText1'="" ALIASText1=ALIASText1_"/"_ALIASText
            s:ALIASText1="" ALIASText1=ALIASText
        }
        s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)           ; 计帐单位 
        s:ARCIMBillingUOMDR'="" ARCIMBillingUOMDR=$p($g(^CT("UOM",ARCIMBillingUOMDR)),"^",2)
        s ARCIMAbbrev =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",3)   ; 医嘱缩写
        s ARCIMOEMessage=$g(^ARCIM(ARCIMSubscript,ARCIMVersion,"OEM",1))               ; 医嘱备注 
        s ARCIMOEMessage =##class(web.DHCBL.BDP.FunLib).Util(ARCIMOEMessage)
        
        s ARCIMDefPriorityDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",22) ; 医嘱优先级(默认优先级)
        s:ARCIMDefPriorityDR'="" ARCIMDefPriorityDR=$p($g(^OECPR(ARCIMDefPriorityDR)),"^",2)
    
        s ARCIMOrderOnItsOwn = $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",13)    ;独立医嘱
        s:ARCIMOrderOnItsOwn="" ARCIMOrderOnItsOwn="N"     

        s ARCIMAllowOrderWOStockCheck = $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",11)  ;无库存医嘱
        s:ARCIMAllowOrderWOStockCheck="" ARCIMAllowOrderWOStockCheck="N"  

        s ARCIMSensitive=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",18)     ;加急医嘱
        s:ARCIMSensitive="" ARCIMSensitive="N" 

        s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7) ;服务组
        if (ARCIMServiceGroupDR'="")
        {
            s ARCIMServiceGroupDR =$p($g(^RBC("SG",ARCIMServiceGroupDR)),"^",2)
        } 
        s ARCIMServMaterial=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",6)        ; 服务/材料
        s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)       ; 开始日期
        s ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
        s ARCIMEffDate=$p(ARCIMEffDate,",",1)
        s:ARCIMEffDate'="" ARCIMEffDate =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCIMEffDate)  
        s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)      ; 结束日期 
        s:ARCIMEffDateTo'="" ARCIMEffDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCIMEffDateTo)

        s ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)
        s:ARCIMDerFeeRulesDR'="" ARCIMDerFeeRulesDR=$p($g(^ARC("DFR",ARCIMDerFeeRulesDR)),"^",2)   ///收费规定
        
        s ARCIMChgOrderPerHour=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",25) 
        s:ARCIMChgOrderPerHour="" ARCIMChgOrderPerHour="N"

        s ARCIMDeceasedPatientsOnly=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",29) 
        s:ARCIMDeceasedPatientsOnly="" ARCIMDeceasedPatientsOnly="N"

        s ARCIMDisplayCumulative=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",23) 
        s:ARCIMDisplayCumulative="" ARCIMDisplayCumulative="N"

        s ARCIMUseODBCforWord=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",6) 
        s:ARCIMUseODBCforWord="" ARCIMUseODBCforWord="N"

        s ARCIMRestrictEM=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",12) 
        s:ARCIMRestrictEM="" ARCIMRestrictEM="N"


        s ARCIMRestrictIP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",13) 
        s:ARCIMRestrictIP="" ARCIMRestrictIP="N"

        s ARCIMRestrictOP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",14) 
        s:ARCIMRestrictOP="" ARCIMRestrictOP="N"

        s ARCIMRestrictHP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",15) 
        s:ARCIMRestrictHP="" ARCIMRestrictHP="N"

        s ARCIMScanCodeBilling=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",22) 
        s:ARCIMScanCodeBilling="" ARCIMScanCodeBilling="N"

        s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) ; 医嘱子分类
        s OECOrderCatDR="",OrdCat=""
        if (ARCIMItemCatDR'="")
        {
            s OrdCat=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)
            if OrdCat'="" s OrdCat=$p($g(^OEC("ORCAT",OrdCat)),"^",2)
            s ARCIMItemCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)        
        }

        s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)     ;账单组与 账单子组
        s BillGrp=""
        if ARCIMBillSubDR["||"
        {
            s BillGrp=$p($g(^ARCBG($p(ARCIMBillSubDR,"||",1))),"^",2)
            s ARCIMBillSubDR=$P($g(^ARCBG($p(ARCIMBillSubDR,"||",1),"SG",$p(ARCIMBillSubDR,"||",2))),"^",2)  
        } 
        
        s (TARICode,TARIDesc,TARIStartDate,TARIPrice,OLTQty,OLTStartDate,OLTEndDate)=""
        if (OLTTariffDR'="")
        {
            s id=OLTTariffDR
            s TARICode=$P($G(^DHCTARI(OLTTariffDR)),"^",1) 
            s TARIDesc=$P($G(^DHCTARI(OLTTariffDR)),"^",2)
            s TARIStartDate =$p($g(^DHCTARI(OLTTariffDR)),"^",11) ///收费项开始日期
            s:TARIStartDate'="" TARIStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TARIStartDate)
            s TariPrice=##class(web.UDHCJFPRICE).GetItmPrice(OLTTariffDR,+$h,"","","",hospid)
            s TariPrice=$p(TariPrice,"^",1)
            if $e(TariPrice,1)="." s TariPrice="0"_TariPrice
            s TARIActiveFlag=$p($g(^DHCTARI(id)),"^",7)
            s TARIALIASText1=""
            s TIARowId=0
            for
            {
                s TIARowId=$o(^DHCTARAL("A",OLTTariffDR,TIARowId))  q:TIARowId=""
                s TIAAlias=$p($g(^DHCTARAL(TIARowId)),"^",3)
                s:TARIALIASText1'="" TARIALIASText1=TARIALIASText1_"/"_TIAAlias
                s:TARIALIASText1="" TARIALIASText1=TIAAlias
            }
            
            s TARIUOM =$p($g(^DHCTARI(id)),"^",3)     ///单位
            s:TARIUOM'="" TARIUOM=$p($g(^CT("UOM",TARIUOM)),"^",2)
            
            s TARISubCate =$p($g(^DHCTARI(id)),"^",4) ///收费项目子类
            if $p($g(^DHCTarC("SC",TARISubCate)),"^",3)'="" s TarCat =$p($g(^DHCTarC("CC",$p($g(^DHCTarC("SC",TARISubCate)),"^",3))),"^",2)
            s:TARISubCate'="" TARISubCate=$p($g(^DHCTarC("SC",TARISubCate)),"^",2)
            
            s TARIAcctCate = $p($g(^DHCTARI(id)),"^",5)   ///收费会计子类
            if $p($g(^DHCTarC("AC",TARIAcctCate)),"^",3)'="" s AcctCat =$p($g(^DHCTarC("TAC",$p($g(^DHCTarC("AC",TARIAcctCate)),"^",3))),"^",2)
            s:TARIAcctCate'="" TARIAcctCate=$p($g(^DHCTarC("AC",TARIAcctCate)),"^",2)
            
            s TARIOutpatCate =  $p($g(^DHCTARI(id)),"^",15)  ///门诊费用子类
            if $p($g(^DHCTarC("OC",TARIOutpatCate)),"^",3)'="" s OutpaCat =$p($g(^DHCTarC("TOC",$p($g(^DHCTarC("OC",TARIOutpatCate)),"^",3))),"^",2)
            s:TARIOutpatCate'="" TARIOutpatCate=$p($g(^DHCTarC("OC",TARIOutpatCate)),"^",2)
            
            s TARIInpatCate =$p($g(^DHCTARI(id)),"^",14)  ///住院费用子类
            if $p($g(^DHCTarC("IC",TARIInpatCate)),"^",3)'="" s InpaCat =$p($g(^DHCTarC("TIC",$p($g(^DHCTarC("IC",TARIInpatCate)),"^",3))),"^",2)
            s:TARIInpatCate'="" TARIInpatCate=$p($g(^DHCTarC("IC",TARIInpatCate)),"^",2)
            
            s TARIEMCCate = $p($g(^DHCTARI(id)),"^",16)  ///经济核算子类
            if $p($g(^DHCTarC("EC",TARIEMCCate)),"^",3)'="" s EmCat =$p($g(^DHCTarC("TEC",$p($g(^DHCTarC("EC",TARIEMCCate)),"^",3))),"^",2)
            s:TARIEMCCate'="" TARIEMCCate=$p($g(^DHCTarC("EC",TARIEMCCate)),"^",2)
           
            s TARIMRCate =$p($g(^DHCTARI(id)),"^",6)  ///旧病案首页子类
            if $p($g(^DHCTarC("MC",TARIMRCate)),"^",3)'=""  s MrCat=$p($g(^DHCTarC("TMC",$p($g(^DHCTarC("MC",TARIMRCate)),"^",3))),"^",2)
            s:TARIMRCate'="" TARIMRCate=$p($g(^DHCTarC("MC",TARIMRCate)),"^",2)
           
            s TARIMCNew=$p($g(^DHCTARI(id)),"^",30) ///新病案首页子类
            if $p($g(^DHCTarC("MCNew",TARIMCNew)),"^",3)'="" s MrCatNew=$p($g(^DHCTarC("TMCNew",$p($g(^DHCTarC("MCNew",TARIMCNew)),"^",3))),"^",2)
            s:TARIMCNew'="" TARIMCNew=$p($g(^DHCTarC("MCNew",TARIMCNew)),"^",2)
            
            
            //s TARIInsuName = $p($g(^DHCTARI(id)),"^",18) //医保名称
            s InsuInfo=##class(web.DHCBL.CT.DHCTarItem).GetStdInsuInfo(id,hospid)
            s TARIInsuCode=$p(InsuInfo,"^",1)  //国家医保编码  2022-04-11
            s TARIInsuName=$p(InsuInfo,"^",2)  //国家医保名称
            s TARIExternalCode = $p($g(^DHCTARI(id)),"^",13)
            s TARIChargeBasis = $p($g(^DHCTARI(id)),"^",20)  //收费依据
            s TARIEngName = $p($g(^DHCTARI(id)),"^",19)  //收费说明
            ///2017-11-29
            s TARIConnote = $p($g(^DHCTARI(id)),"^",32)  //项目内涵
            s TARIRemark = $p($g(^DHCTARI(id)),"^",33)  //备注
            s TARIExclude = $p($g(^DHCTARI(id)),"^",34)  //除外内容
            
            s TARISpecialFlag=$p($g(^DHCTARI(id)),"^",17)
            s TARIStartDate =$p($g(^DHCTARI(id)),"^",11) ///开始日期
            s TARIEndDate = $p($g(^DHCTARI(id)),"^",12)
            
            
            s:TARIStartDate'="" TARIStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TARIStartDate)
            s:TARIEndDate'="" TARIEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TARIEndDate)
        
        
            
        }
        if (OLTRowId'="")
        {
            s OLTQty=$p($g(^DHCOLT(OLTRowId)),"^",3)
            s OLTStartDate=$p($g(^DHCOLT(OLTRowId)),"^",4)
            s:OLTStartDate'="" OLTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OLTStartDate)
            s OLTEndDate=$p($g(^DHCOLT(OLTRowId)),"^",5)
            s:OLTEndDate'="" OLTEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OLTEndDate)
            s OLTBascPriceFlag=$p($g(^DHCOLT(OLTRowId)),"^",8)
            s OLTBillOnceFlag=$p($g(^DHCOLT(OLTRowId)),"^",9)
            
            
        }
        s Value=ARCIMCode_"&%"_ARCIMDesc_"&%"_OrderPrice_"&%"_ALIASText1_"&%"_ARCIMBillingUOMDR_"&%"_ARCIMEffDate_"&%"_ARCIMEffDateTo_"&%"_OLTQty_"&%"_OLTStartDate_"&%"_OLTEndDate
        s Value=Value_"&%"_TARICode_"&%"_TARIDesc_"&%"_TARIStartDate_"&%"_TARIEndDate_"&%"_TARIActiveFlag_"&%"_TARIALIASText1_"&%"_TariPrice_"&%"_TARIUOM_"&%"_ARCIMAbbrev_"&%"_ARCIMOEMessage
        s Value=Value_"&%"_OrdCat_"&%"_ARCIMItemCatDR_"&%"_BillGrp_"&%"_ARCIMBillSubDR_"&%"_TarCat_"&%"_TARISubCate_"&%"_InpaCat_"&%"_TARIInpatCate_"&%"_OutpaCat_"&%"_TARIOutpatCate
        s Value=Value_"&%"_EmCat_"&%"_TARIEMCCate_"&%"_AcctCat_"&%"_TARIAcctCate_"&%"_MrCat_"&%"_TARIMRCate_"&%"_MrCatNew_"&%"_TARIMCNew_"&%"_ARCIMDefPriorityDR_"&%"_ARCIMOrderOnItsOwn
        s Value=Value_"&%"_ARCIMServMaterial_"&%"_OLTBascPriceFlag_"&%"_OLTBillOnceFlag_"&%"_ARCIMSensitive_"&%"_ARCIMChgOrderPerHour_"&%"_ARCIMAllowOrderWOStockCheck_"&%"_ARCIMServiceGroupDR_"&%"_ARCIMDerFeeRulesDR_"&%"_ARCIMDeceasedPatientsOnly_"&%"_ARCIMDisplayCumulative
        s Value=Value_"&%"_ARCIMUseODBCforWord_"&%"_ARCIMRestrictEM_"&%"_TARIChargeBasis_"&%"_TARISpecialFlag_"&%"_TARIExternalCode_"&%"_TARIEngName_"&%"_TARIInsuCode_"&%"_TARIInsuName_"&%"_ARCIMRestrictOP_"&%"_ARCIMRestrictIP_"&%"_TARIConnote
        s Value=Value_"&%"_TARIRemark_"&%"_TARIExclude_"&%"_ARCIMScanCodeBilling
        
        
    }
    else  ///只导出医嘱项信息
    {
        s ARCIMRowId=$g(^TMP("BDPARCIM",k))
        q:ARCIMRowId="" ""
        s ARCIMSubscript=$p(ARCIMRowId,"||",1)
        s ARCIMVersion=$p(ARCIMRowId,"||",2)
        q:(ARCIMSubscript="")||(ARCIMVersion="") ""
        s ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
        s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
        s ARCIMCode =##class(web.DHCBL.BDP.FunLib).Util(ARCIMCode)
        s ARCIMDesc =##class(web.DHCBL.BDP.FunLib).Util(ARCIMDesc)
        s OrderPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIMRowId,+$h,"","","","",hospid)
        s OrderPrice=$p(OrderPrice,"^",1)
        if $e(OrderPrice,1)="." s OrderPrice="0"_OrderPrice
        s ALIASRowId=0,ALIASText1=""
        for
        {
            s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId))
            q:(ALIASRowId="")
            s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
            s:ALIASText1'="" ALIASText1=ALIASText1_"/"_ALIASText
            s:ALIASText1="" ALIASText1=ALIASText
        }
        s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)           ; 计帐单位 
        s:ARCIMBillingUOMDR'="" ARCIMBillingUOMDR=$p($g(^CT("UOM",ARCIMBillingUOMDR)),"^",2)
        s ARCIMAbbrev =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",3)   ; 医嘱缩写
        s ARCIMOEMessage=$g(^ARCIM(ARCIMSubscript,ARCIMVersion,"OEM",1))               ; 医嘱备注 
        s ARCIMOEMessage =##class(web.DHCBL.BDP.FunLib).Util(ARCIMOEMessage)
        s ARCIMDefPriorityDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",22) ; 医嘱优先级(默认优先级)
        s:ARCIMDefPriorityDR'="" ARCIMDefPriorityDR=$p($g(^OECPR(ARCIMDefPriorityDR)),"^",2)
    
        s ARCIMOrderOnItsOwn = $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",13)    ;独立医嘱
        s:ARCIMOrderOnItsOwn="" ARCIMOrderOnItsOwn="N"     

        s ARCIMAllowOrderWOStockCheck = $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",11)  ;无库存医嘱
        s:ARCIMAllowOrderWOStockCheck="" ARCIMAllowOrderWOStockCheck="N"  

        s ARCIMSensitive=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",18)     ;加急医嘱
        s:ARCIMSensitive="" ARCIMSensitive="N" 

        s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7) ;服务组
        if (ARCIMServiceGroupDR'="")
        {
            s ARCIMServiceGroupDR =$p($g(^RBC("SG",ARCIMServiceGroupDR)),"^",2)
        } 
        s ARCIMServMaterial=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",6)        ; 服务/材料
        s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)       ; 开始日期
        s ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
        s ARCIMEffDate=$p(ARCIMEffDate,",",1)
        s:ARCIMEffDate'="" ARCIMEffDate =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCIMEffDate)  
        s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)      ; 结束日期 
        s:ARCIMEffDateTo'="" ARCIMEffDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCIMEffDateTo)

        s ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)
        s:ARCIMDerFeeRulesDR'="" ARCIMDerFeeRulesDR=$p($g(^ARC("DFR",ARCIMDerFeeRulesDR)),"^",2)   ///收费规定
        
        s ARCIMChgOrderPerHour=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",25) 
        s:ARCIMChgOrderPerHour="" ARCIMChgOrderPerHour="N"

        s ARCIMDeceasedPatientsOnly=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",29) 
        s:ARCIMDeceasedPatientsOnly="" ARCIMDeceasedPatientsOnly="N"

        s ARCIMDisplayCumulative=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",23) 
        s:ARCIMDisplayCumulative="" ARCIMDisplayCumulative="N"

        s ARCIMUseODBCforWord=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",6) 
        s:ARCIMUseODBCforWord="" ARCIMUseODBCforWord="N"

        s ARCIMRestrictEM=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",12) 
        s:ARCIMRestrictEM="" ARCIMRestrictEM="N"


        s ARCIMRestrictIP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",13) 
        s:ARCIMRestrictIP="" ARCIMRestrictIP="N"

        s ARCIMRestrictOP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",14) 
        s:ARCIMRestrictOP="" ARCIMRestrictOP="N"

        s ARCIMRestrictHP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",15) 
        s:ARCIMRestrictHP="" ARCIMRestrictHP="N"

        s ARCIMScanCodeBilling=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",22) 
        s:ARCIMScanCodeBilling="" ARCIMScanCodeBilling="N"

        s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) ; 医嘱子分类
        s OECOrderCatDR="",OrdCat=""
        if (ARCIMItemCatDR'="")
        {
            s OrdCat=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)
            if OrdCat'="" s OrdCat=$p($g(^OEC("ORCAT",OrdCat)),"^",2)
            s ARCIMItemCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)        
        }

        s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)     ;账单组与 账单子组
        s BillGrp=""
        if ARCIMBillSubDR["||"
        {
            s BillGrp=$p($g(^ARCBG($p(ARCIMBillSubDR,"||",1))),"^",2)
            s ARCIMBillSubDR=$P($g(^ARCBG($p(ARCIMBillSubDR,"||",1),"SG",$p(ARCIMBillSubDR,"||",2))),"^",2)  
        }
       
        
        /*外部代码
        //2019-02-12  四川妇幼
        s Extstr=""
        s sub=0
        for
        {
            s sub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",sub)) q:sub=""
            s EXTCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",sub)),"^",4)
            s EXTDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",sub)),"^",6)
            s:Extstr'="" Extstr=Extstr_"&%"_EXTCode_"&%"_EXTDesc
            s:Extstr="" Extstr=EXTCode_"&%"_EXTDesc
            
        }
        */
        s Value=ARCIMCode_"&%"_ARCIMDesc_"&%"_OrderPrice_"&%"_ALIASText1_"&%"_ARCIMBillingUOMDR_"&%"_ARCIMEffDate_"&%"_ARCIMEffDateTo_"&%"_ARCIMAbbrev_"&%"_ARCIMOEMessage_"&%"_OrdCat_"&%"_ARCIMItemCatDR_"&%"_BillGrp_"&%"_ARCIMBillSubDR_"&%"_ARCIMDefPriorityDR_"&%"_ARCIMOrderOnItsOwn_"&%"_ARCIMServMaterial_"&%"_ARCIMSensitive_"&%"_ARCIMChgOrderPerHour_"&%"_ARCIMAllowOrderWOStockCheck_"&%"_ARCIMServiceGroupDR_"&%"_ARCIMDerFeeRulesDR_"&%"_ARCIMDeceasedPatientsOnly_"&%"_ARCIMDisplayCumulative_"&%"_ARCIMUseODBCforWord_"&%"_ARCIMRestrictEM_"&%"_ARCIMRestrictOP_"&%"_ARCIMRestrictIP_"&%"_ARCIMScanCodeBilling
    }
    q Value
}

/// Function:自动生成配置  不自动生成 返回空， 自动生成  类型F  OA  A  O
/// Creator:陈莹
/// CreateDate: 2017-10-13
/// Debug: w ##class(web.DHCBL.CT.ARCItmMast).AutoCreateType()
/// ^Config.BDP("ARCIMCONFIG")="true^true^false^true^OA^10^"
ClassMethod AutoCreateType(hospid As %String = "") As %String
{
    n (hospid)
    s ConfigType=..#SQLTableName
    s Global=$g(^Config.BDP(ConfigType,+hospid))
    s CodeType=""
    if $d(^Config.BDP(ConfigType,+hospid))
    {
        s AutoCode=$p(Global,"^",4)
        if AutoCode="true"
        {
            s CodeType=$p(Global,"^",5)         
            ///代码规则：1，F，所有医嘱项一套规则 字母开头  2，OA医嘱大类代码+医嘱子类代码  3：O 医嘱大类代码开头   4.A  医嘱子类代码开头
        }
    }
    q CodeType
}

/// Function:获取是否自动生成医嘱项代码 是返回1，否返回0
/// Creator:陈莹
/// CreateDate: 2017-11-9
/// input:
/// Debug: w ##class(web.DHCBL.CT.ARCItmMast).GetAutoCreateFlag()
/// ^Config.BDP("ARC_ItmMast",2)="false^true^false^true^OA^10^"
ClassMethod GetAutoCreateFlag(hospid As %String = "") As %String
{
    n (hospid)
    s flag=0
    s ConfigType=..#SQLTableName
    s Global=$g(^Config.BDP(ConfigType,+hospid))
    if $d(^Config.BDP(ConfigType,+hospid))
    {
        s AutoCode=$p(Global,"^",4)
        if AutoCode="true" s flag=1 
    }
    q flag
}

/// Function:添加时，自动生成医嘱项代码，根据配置，取开头字符+总位数   最大数字+1
/// Creator:陈莹
/// CreateDate: 2017-07-07
/// input: Status 0时，如果是大类和子类代码状态时 返回空，为1时才根据子类和大类的值取代码最大值
/// Debug: w ##class(web.DHCBL.CT.ARCItmMast).AutoCreateCode("1^1^0")
/// Debug: w ##class(web.DHCBL.CT.ARCItmMast).AutoCreateCode("")
/// ^Config.BDP("ARC_ItmMast",2)="true^true^false^true^OA^10^"
ClassMethod AutoCreateCode(CatStr, hospid As %String = "") As %String
{
    n (CatStr,hospid)
    s ConfigType=..#SQLTableName
    s Global=$g(^Config.BDP(ConfigType,+hospid))
    
    s ordercat=$p(CatStr,"^",1)  ///医嘱大类rowid
    s itemcat=$p(CatStr,"^",2) ///医嘱子类rowid
    s Status=$p(CatStr,"^",3) ///状态判断
    s MaxCode=""
    if itemcat'="" s ordercat=$p($g(^ARC("IC",itemcat)),"^",8)
    if $d(^Config.BDP(ConfigType,+hospid))
    {
        s AutoCode=$p(Global,"^",4)
        if AutoCode="true"
        {
            k ^TMPCODE(ConfigType)
            s CodeType=$p(Global,"^",5)          ///代码规则：1，F，所有医嘱项一套规则 字母开头  2，OA医嘱大类代码+医嘱子类代码  3：O 医嘱大类代码开头   4.A  医嘱子类代码开头
            s TotalLength=$p(Global,"^",6)       ///自动生成总共多少位的代码
            s OriginCode=""
            
            if CodeType="F"
            {
                s OriginCode=$p(Global,"^",7)    ///代码规则为F时， 起始代码 
            }
            else
            {
                if Status="0" q ""
                if CodeType="OA"
                {
                    if (itemcat'="")&&(ordercat'="")
                    {
                        s OriginCode=$p($g(^OEC("ORCAT",ordercat)),"^",1)_$p($g(^ARC("IC",itemcat)),"^",1)
                    }
                    elseif (itemcat'="")&&(ordercat="")
                    {
                        
                        s:ordercat'="" OriginCode=$p($g(^OEC("ORCAT",ordercat)),"^",1)_$p($g(^ARC("IC",itemcat)),"^",1)
                    }
                    else
                    {
                        q ""
                    }
                }
                
                elseif CodeType="A"
                {
                    if (itemcat'="")
                    {
                        s OriginCode=$p($g(^ARC("IC",itemcat)),"^",1)
                    }
                    else
                    {
                        q ""
                    }
                }
                elseif CodeType="O"
                {
                    if (ordercat'="")
                    {
                        s OriginCode=$p($g(^OEC("ORCAT",ordercat)),"^",1)
                    }
                    else
                    {
                        q ""
                    }
                }
            }
            s olength=$l(OriginCode)
            if ((TotalLength-$l(OriginCode))<=0)
            {
                 s MaxCode=""
            }
            else
            {
                s Code1=""
                s Code=0
                for
                {
                    S Code=$o(^ARCIM(0,"Code",Code)) q:Code=""
                    s sub=0
                    for
                    {
                        S sub=$o(^ARCIM(0,"Code",Code,sub)) q:sub=""
                        s ver=0
                        for
                        {
                            S ver=$o(^ARCIM(0,"Code",Code,sub,ver)) q:ver=""
                            s ARCIMRowId=sub_"||"_ver
                            s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCIMRowId,hospid)
                            continue:showflag="N"
                            s RCode=$p($g(^ARCIM(sub,ver,1)),"^",1)
                            s RCode=##class(web.DHCBL.BDP.FunLib).Util(RCode)
                            if ($e(RCode,1,olength)=OriginCode)&&($l(RCode)=TotalLength)
                            {
                                s Code1=$e(RCode,olength+1,TotalLength)+1
                                S:Code1'="" ^TMPCODE(ConfigType,Code1)=RCode
                            }
                        }
                    }
                }
                s Code1=$o(^TMPCODE(ConfigType,""),-1)
                s Code1=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(Code1,TotalLength-$l(OriginCode))     ///自动补全0
                s MaxCode=OriginCode_Code1
                k ^TMPCODE(ConfigType)
            }
        }
    }
    q MaxCode
}

/// Function: 河南漯河中心需求，查询数据中以某字符串开头的医嘱项代码最大值，并自动+1
/// Creator:陈莹
/// CreateDate: 2017-11-7
/// Debug: w ##class(web.DHCBL.CT.ARCItmMast).GetMaxCode("A01BA")
ClassMethod GetMaxCode(SearchStr, hospid As %String = "") As %String
{
    n (SearchStr,hospid)
    q:SearchStr="" ""
    s MaxCode=""
    s zCode=$$ALPHAUP^SSUTIL4(SearchStr)
    for
    {
        S zCode=$o(^ARCIM(0,"Code",zCode)) q:(zCode="")
        if ($e(zCode,1,$l(SearchStr))'=$$ALPHAUP^SSUTIL4(SearchStr)) continue  //首字母要求一致
        s sub=0
        for
        {
            S sub=$o(^ARCIM(0,"Code",zCode,sub)) q:sub=""
            s ver=0
            for
            {
                S ver=$o(^ARCIM(0,"Code",zCode,sub,ver)) q:ver=""
                s ARCIMRowId=sub_"||"_ver
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCIMRowId,hospid)
                continue:showflag="N"
                s Code=$p($g(^ARCIM(sub,ver,1)),"^",1)
                s Code=##class(web.DHCBL.BDP.FunLib).Util(Code)
                if ($e(Code,1,$l(SearchStr))'=SearchStr) continue  //首字母要求一致
                //q:(SearchStr?1n.n)&&($e(Code,1,1)'?1n.n)
                if $l(SearchStr)>$l(Code) continue 
                if ($e(Code,$l(SearchStr)+1,$l(Code))?1n.n)   //str?1n.n ///全是数字 返回1，含有其他字符 返回0
                {
                    s maxvalue=$e(Code,$l(SearchStr)+1,$l(Code))
                    s TMPMAXCODE(+maxvalue+1)=$l(Code)
                
                }
            }
        }
    }
    s sub=$o(TMPMAXCODE(""),-1)
    if sub'=""
    {
        s Code=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(sub,$g(TMPMAXCODE(sub))-$l(SearchStr))     ///自动补全0
    }
    else
    {
        s Code=""
    }
    s MaxCode=SearchStr_Code
    q MaxCode
}

/// Creator:陈莹
/// CreatDate:2017-03-20
/// Description:获取医嘱项单独的配置
/// w ##class(web.DHCBL.CT.ARCItmMast).GetConfigValue()
/// ^Config.BDP("ARC_ItmMast",2)="true^true^false^true^F^10^YP"
ClassMethod GetConfigValue(hospid As %String = "") As %String
{
    n (hospid)
    s ConfigType=..#SQLTableName
    s Global=$g(^Config.BDP(ConfigType,+hospid))
    //s LinkHospital=$p(Global,"^",1)      //关联医院，默认false 
    //if (LinkHospital="") S LinkHospital="false"   
    s FirstFightAlias=$p(Global,"^",2)    //首拼别名，默认true
    if (FirstFightAlias="") S FirstFightAlias="true"  
    s FivePenAlias=$p(Global,"^",3)       //五笔码别名，默认false
    if (FivePenAlias="") S FivePenAlias="false"
    s AutoCode=$p(Global,"^",4)          //自动生成代码，默认false
    if (AutoCode="") S AutoCode="false"
    
    s FCode="",OACode="",ACode="",OCode="",OriginCode=""
    s TotalLength=$p(Global,"^",6)       ///自动生成总共多少位的代码
    
    s CodeType=$p(Global,"^",5)          ///代码规则：1，F F所有医嘱项一套规则 YP字母开头  2，OA医嘱大类代码+医嘱子类代码  3：O 医嘱大类代码开头   4.A  医嘱子类代码开头
    if CodeType="F"
    {
        s FCode="F"
        s OriginCode=$p(Global,"^",7)    ///代码规则为F时开头代码
    }
    elseif CodeType="OA"
    {
        s OACode="OA"   
    }
    elseif CodeType="A"
    {
        s ACode="A"
        
    }
    elseif CodeType="O"
    {
        s OCode="O"
    }
    s ValidDesc=$p(Global,"^",8)         //校验描述是否重复，默认true
    if (ValidDesc="") S ValidDesc="true"
    s CodeAlias=$p(Global,"^",9)       //代码别名，默认false
    if (CodeAlias="") S CodeAlias="false"
    //s str="LinkHospital:"""_LinkHospital_""","
    s str="FirstFightAlias:"""_FirstFightAlias_""",FivePenAlias:"""_FivePenAlias_""",AutoCode:"""_AutoCode_""",OCode:"""_OCode_""",ACode:"""_ACode_""",OACode:"""_OACode_""",FCode:"""_FCode_""",OriginCode:"""_OriginCode_""",TotalLength:"""_TotalLength_""",ValidDesc:"""_ValidDesc_""",CodeAlias:"""_CodeAlias_""""
    
    s str = "{list:[{"_str_"}]}"
    q str
}

/// Creator:陈莹
/// CreatDate:2017-03-20
/// Description:保存医嘱项单独的配置
/// Input：（1）是否自动添加医院^（2）是否自动添加首拼别名^（3）是否自动添加五笔码别名^（4）代码是否自动生成^（5）规则1：F所有医嘱项一套规则 ，
/// /规则2 :OA医嘱大类代码+医嘱子类代码 自动加1 /规则3：O医嘱大类代码/规则4：A医嘱子类代码 自动加1^（6）多少位数^（7）如果规则为F,代码开头字符串
/// (8)校验名称重复  (9)自动添加 代码 到别名里
/// w ##class(web.DHCBL.CT.ARCItmMast).SaveConfigValue("false^true^false^false^^^^true^true^false")
ClassMethod SaveConfigValue(ConfigStr, hospid As %String = "") As %String
{
    n (ConfigStr,hospid)
    s ConfigType=..#SQLTableName
    s ^Config.BDP(ConfigType,+hospid)=ConfigStr
    q "{success:'true'}"
}

/// Function: 药物查找
/// CreateDate: 2013-8-22 
/// Creator:  sunfengchao
/// Debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItmMast","GetDrugList","","","")
Query GetDrugList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCDRowId:%String,PHCDCode:%String,PHCDName:%String")
{
}

ClassMethod GetDrugListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") 
 {
   s PHCDRowId=rowid
   s PHCDCode=$p($g(^PHCD(PHCDRowId,1)),"^",1)
   s PHCDName=$p($g(^PHCD(PHCDRowId,1)),"^",2)
   d OutputRow
 }
 else
 {
   s:code'="" code=$ZCONVERT(code,"U") //转换成大写
   s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
   s PHCDRowId=0
   for
   {
      s PHCDRowId=$o(^PHCD(PHCDRowId))
      q:(PHCDRowId="")||(PHCDRowId="DF_Form")
      s PHCDCode=$p($g(^PHCD(PHCDRowId,1)),"^",1)
      s PHCDName=$p($g(^PHCD(PHCDRowId,1)),"^",2)
      continue:(PHCDCode="")||(PHCDName="") //屏蔽垃圾数据
      s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHCDName)
      if ($ZCONVERT(PHCDCode,"U")[code)&(($ZCONVERT(PHCDName,"U")[desc) ||(PINYIN[desc) )
      {
        d OutputRow
      }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(PHCDRowId,PHCDCode,PHCDName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDrugListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDrugListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDrugListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/*
/// Function:其他明细中的药物combox
/// CreateDate: 2014-8-22
/// Creator: sunfengchao
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItmMast","drugmast","","","","","","")
ClassMethod drugmast(start, limit, sort, dir, callback, drugdesc) As %String
{
 
 If $g(drugdesc)'="" Do
 .Set ConExp="'%"_drugdesc_"%'" 
 .Set strSql="select PHCDF_PHCD_ParRef,PHCDF_PHCD_ParRef->PHCD_Code,PHCDF_PHCD_ParRef->PHCD_Name,PHCDF_PHCF_DR,PHCDF_PHCF_DR->PHCF_Desc  from  PHC_DrgForm where PHCDF_PHCD_ParRef->PHCD_Name like"_"  "_ConExp
 Else  Do
 .Set strSql="select PHCDF_PHCD_ParRef,PHCDF_PHCD_ParRef->PHCD_Code,PHCDF_PHCD_ParRef->PHCD_Name,PHCDF_PHCF_DR,PHCDF_PHCF_DR->PHCF_Desc  from  PHC_DrgForm"
 
 
 //排序
 s strSort=""
 s sortField=""
 
 i sort'="" d
 .i sort="rowid" s sortField="PHCDF_PHCD_ParRef"
 .i sort="code"  s sortField="PHCD_Code"
 .i sort="desc"  s sortField="PHCD_Name"
 
 i sortField'="" d
 .s dir=$ZCONVERT(dir,"U")
 .i (dir="DESC") || (dir="ASC") s strSort=" ORDER BY "_sortField_" "_dir
 .e  s strSort=" ORDER BY "_sortField_" DESC"
 e  d
 .s strSort=" ORDER BY %ID DESC"
 s strSql=strSql_strSort
 
 
 s result=##class(%Library.ResultSet).%New()
 
 d result.Prepare(strSql)
 d result.Execute()
 
 s count=0
 s strResult=""
 s drgform="[,'']"
 s end=start+limit
 
 While(result.Next())
 {
  s rowid=result.Data("PHCDF_PHCD_ParRef")
  s code=##class(ext.util.String).EvalJSON(result.Data("PHCD_Code"))
  s desc=##class(ext.util.String).EvalJSON(result.Data("PHCD_Name"))

  s count=count+1
  
  i (count>start) & (count<=end) d
   .i strResult'="" d
   ..s strResult=strResult_",{""rowid"":"""_rowid_""",""code"":"""_code_""",""desc"":"""_desc_"""}"
   .e  d
   ..s strResult="{""rowid"":"""_rowid_""",""code"":"""_code_""",""desc"":"""_desc_"""}"
 }
 
 d result.Close()
 
 i callback'="" d
 .s strResult=callback_"({""totalCount"":"""_count_""",""results"":["_strResult_"]});"
 e  d
 .s strResult="{""totalCount"":"""_count_""",""results"":["_strResult_"]}"
 
 q strResult
}

/// Function:其他明细中的药物形态combox
/// CreateDate: 2014-8-23
/// Creator: sunfengchao
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItmMast","drugform","","","","","","")
ClassMethod drugform(start, limit, sort, dir, callback, drugformrowid) As %String
{
 s strSql="select PHCDF_PHCD_ParRef,PHCDF_PHCF_DR->PHCF_Code,PHCDF_PHCF_DR->PHCF_Desc  from  PHC_DrgForm  where  PHCDF_PHCD_ParRef="_drugformrowid
 //排序
 s strSort=""
 s sortField=""
 
 i sort'="" d
 .i sort="rowid" s sortField="PHCDF_PHCD_ParRef"
 .i sort="code"  s sortField="PHCF_Code"
 .i sort="desc"  s sortField="PHCF_Desc"
 
 i sortField'="" d
 .s dir=$ZCONVERT(dir,"U")
 .i (dir="DESC") || (dir="ASC") s strSort=" ORDER BY "_sortField_" "_dir
 .e  s strSort=" ORDER BY "_sortField_" DESC"
 e  d
 .s strSort=" ORDER BY %ID DESC"
 s strSql=strSql_strSort
 
 
 s result=##class(%Library.ResultSet).%New()
 
 d result.Prepare(strSql)
 d result.Execute()
 
 s count=0
 s strResult=""
 s end=start+limit
 
 While(result.Next())
 {
  s rowid=result.Data("PHCDF_PHCD_ParRef")
  s code=##class(ext.util.String).EvalJSON(result.Data("PHCF_Code"))
  s desc=##class(ext.util.String).EvalJSON(result.Data("PHCF_Desc"))
  
  s count=count+1
  
  i (count>start) & (count<=end) d
   .i strResult'="" d
   ..s strResult=strResult_",{""rowid"":"""_rowid_""",""code"":"""_code_""",""desc"":"""_desc_"""}"
   .e  d
   ..s strResult="{""rowid"":"""_rowid_""",""code"":"""_code_""",""desc"":"""_desc_"""}"
 }
 
 d result.Close()
 
 i callback'="" d
 .s strResult=callback_"({""totalCount"":"""_count_""",""results"":["_strResult_"]});"
 e  d
 .s strResult="{""totalCount"":"""_count_""",""results"":["_strResult_"]}"
 
 q strResult
}
*/
///        ofy10 江苏连云港中医  修改检查类医嘱项代码和描述时、和新增检查类医嘱项时调用PACS组接口，同步医嘱信息
/// Creator:陈莹
/// CreatDate:2017-07-13
/// Description:通过医嘱项代码获取医嘱项rowid
/// w ##class(web.DHCBL.CT.ARCItmMast).GetARCIMRowIdByCode("A\\1AB51")
ClassMethod GetARCIMRowIdByCode(code As %String) As %String
{
    n (code)
    S ROWID=""
    IF $$ALPHAUP^SSUTIL4(code)'=""
    {
        s sub=0
        for
        {
            s sub=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),sub)) q:sub=""
            s version=0
            for
            {
                s version=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),sub,version)) q:version=""
                s SCODE=$p($g(^ARCIM(sub,version,1)),"^",1) 
                IF (SCODE=code) S ROWID=sub_"||"_version
            }
        }
    }
    q ROWID
}

/// Creator:陈莹
/// CreatDate:2017-07-13
/// Description:通过医嘱项rowid获取医嘱项别名
/// w ##class(web.DHCBL.CT.ARCItmMast).GetAliasByRowId("1","1")
ClassMethod GetAliasByRowId(ARCIMSubscript, ARCIMVersion) As %String
{
    n (ARCIMSubscript,ARCIMVersion)
    s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
    s ALIASRowId=0,ALIASText1=""
    for
    {
        s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId))
        q:(ALIASRowId="")
        s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
        s:ALIASText1'="" ALIASText1=ALIASText1_"/"_ALIASText
        s:ALIASText1="" ALIASText1=ALIASText
    }
    q ALIASText1
}

/// Creator:陈莹
/// CreatDate:2019-06-28
/// Description:调用配置
/// d ##class(web.DHCBL.CT.ARCItmMast).ConfigInterface("1||1",2)
ClassMethod ConfigInterface(ARCIMRowId, hospid As %String = "") As %String
{
    n (ARCIMRowId,hospid,%session)
    Q:ARCIMRowId="" ""
    
    s ARCIMCode=$p($g(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),1)),"^",1)
    s ARCIMDesc=$p($g(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),1)),"^",2)
    ///自动添加大写拼音首拼别名 2019-04-29  
    if ($p($g(^Config.BDP(..#SQLTableName,+hospid)),"^",2)'="false") //默认添加
    {
        s Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ARCIMDesc)
        s Alias=##class(web.DHCBL.BDP.FunLib).RemoveSpecialSymbols(Alias)
        d ##class(web.DHCBL.CT.ARCAlias).AddOrderAlias(ARCIMRowId_"^"_Alias)
        
    }
    ///自动添加五笔码别名 2017-03-30   
    if ($p($g(^Config.BDP(..#SQLTableName,+hospid)),"^",3)="true") //默认不添加
    {
        s Alias=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(ARCIMDesc,1)
        s Alias=##class(web.DHCBL.BDP.FunLib).RemoveSpecialSymbols(Alias)
        d ##class(web.DHCBL.CT.ARCAlias).AddOrderAlias(ARCIMRowId_"^"_Alias)
    }
    
    ///自动添加代码别名 2019-05-30
    if ($p($g(^Config.BDP(..#SQLTableName,+hospid)),"^",9)="true") //默认不添加
    {
        d ##class(web.DHCBL.CT.ARCAlias).AddOrderAlias(ARCIMRowId_"^"_ARCIMCode)
        
    }
    q ""
}

/// Function:批量生成五笔码首字母别名
/// Creator:陈莹
/// CreateDate: 2017-03-27
/// Debug: D ##class(web.DHCBL.CT.ARCItmMast).BatchAddSWBCode()
ClassMethod BatchAddSWBCode() As %String
{
    s sub=0
    for
    {
        
        s sub=$o(^ARCIM(sub)) q:sub=""
        s version=0
        for
        {
            s version=$o(^ARCIM(sub,version)) q:version=""
            s desc=$p($G(^ARCIM(sub,version,1)),"^",2)
            s arcim=sub_"||"_version
            s wbcode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(desc,1)
            
            if wbcode'=""
            {
                
                k aobj1
                s arcitemcatdr=$p($G(^ARCIM(sub,version,1)),"^",10)
                s aobj1=##class(User.ARCAlias).%New()
                d aobj1.ALIASARCIMDRSetObjectId(arcim)
                s aobj1.ALIASText=wbcode
                s aobj1.ALIASType= "ARCIM" 
                s aobj1.ALIASOrderOnItsOwn="Y" 
                s aobj1.ALIASDateFrom=+$h
                s aobj1.ALIASDesc=desc
                d aobj1.ALIASOrderSubCatDRSetObjectId(arcitemcatdr)
                s sc=aobj1.%Save()
                
            }   
        }
        
    }
}

/// Function:根据代码获取医嘱项id
/// Creator:陈莹
/// CreateDate: 2021-09-13
/// w ##class(web.DHCBL.CT.ARCItmMast).GetRowIdByCode("")
ClassMethod GetRowIdByCode(code As %String) As %String
{
    n (code)
    q:code="" ""
    s arcimrowid=""
    s subscript=0
    for
    {
        s subscript=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),subscript)) q:subscript=""
        s version=0
        for
        {
            s version=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),subscript,version)) q:version=""
            s arcimcode=$p($g(^ARCIM(subscript,version,1)),"^",1)  
            if (arcimcode=code) s arcimrowid=subscript_"||"_version
        }
    }
    q arcimrowid
}

/// Function:根据描述获取医嘱项id
/// Creator:陈莹
/// CreateDate: 2021-09-13
/// w ##class(web.DHCBL.CT.ARCItmMast).GetRowIdByDesc("")
ClassMethod GetRowIdByDesc(desc As %String) As %String
{
    n (desc)
    q:desc="" ""
    s arcimrowid=""
    s subscript=0
    for
    {
        s subscript=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(desc),subscript)) q:subscript=""
        s version=0
        for
        {
            s version=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(desc),subscript,version)) q:version=""
            s arcimdesc=$p($g(^ARCIM(subscript,version,1)),"^",2)  
            if (arcimdesc=desc) s arcimrowid=subscript_"||"_version
        }
    }
    q arcimrowid
}

/// Function:获取医嘱项的医嘱子分类的类型
/// Creator:陈莹
/// CreateDate: 2022-09-13
/// Input:医嘱项id
/// Output:医嘱项的医嘱子分类的类型
/// w ##class(web.DHCBL.CT.ARCItmMast).GetTypeByARCIMRowId("1")
ClassMethod GetTypeByARCIMRowId(arcimrowid As %String) As %String
{
    n (arcimrowid)
    q:arcimrowid="" ""
    S ARCIMSubscript=$P(arcimrowid,"||",1)
    S ARCIMVersion=$P(arcimrowid,"||",2)
    q:((ARCIMSubscript="")||(ARCIMVersion="")) ""
    s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
    q:ARCIMItemCatDR="" ""
    s ARCICOrderType = $p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)
    q ARCICOrderType
}

/// Function:对某医院的数据 医嘱项代码批量加前缀
/// Creator:陈莹
/// CreateDate: 2022-11-01
/// Input:hospid医院id,prefix要加的前缀
/// w ##class(web.DHCBL.CT.ARCItmMast).UpdateCodeByHosp("3","F")
ClassMethod UpdateCodeByHosp(hospid As %String, prefix As %String) As %String
{
    n (hospid,prefix)
    q:hospid="" ""
    q:prefix="" ""
    s length=$l(prefix)
    s ARCIMRowId=""
    s ARCIMSubscript=0
    for
    {
        s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:ARCIMSubscript=""
        s ARCIMVersion=0
        for
        {
            s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""
            s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
            ; 遍历 医院子表，查询医院dr 进行筛选
            s HospChildsub=0,AuHospFlag=0 
            for
            {
                s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")||(AuHospFlag=1)  
                s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
                if (HOSPHospitalDR=hospid) s AuHospFlag=1
            }
            s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) ; 医嘱子分类
	        if (ARCIMItemCatDR'="")
	        {
	            s Type=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)  
	            continue:((Type="R")||(Type="M")) ///过滤药品和材料 
	        }
            if AuHospFlag=1
            {
	            s arcimcode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
	            s pre=$e(arcimcode,1,length)
	            if pre'=prefix
	            {
		            s obj=##class(User.ARCItmMast).%OpenId(ARCIMRowId)
					Set obj.ARCIMCode=prefix_arcimcode
					Set obj.ARCIMChgPostFlg="O"
					Set obj.ARCIMUpdateDate=$P($h,",",1)                                            ;添加日期 ARCIM_UpdateDate
					Set obj.ARCIMUpdateTime=$p($h,",",2)                                            ;添加时间 ARCIM_UpdateTime
					s sc=obj.%Save()
					if $$$ISOK(sc){
						do obj.%Close()
					}
					else
					{
						w "医嘱项更新失败："_ARCIMRowId_" "_prefix_arcimcode_" "_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!	
					}
	            }
            }
        }
    }
    q ""
}

/// Function:对医嘱项和收费项数据，清除空节点数据。
/// Creator:陈莹
/// CreateDate: 2022-12-16
/// w ##class(web.DHCBL.CT.ARCItmMast).ClearNullNode()
ClassMethod ClearNullNode() As %String
{
   
	//收费项目和收费项目价格如果保存后，再回滚会导致存在^DHCTARI(5679,"P",0)=1的数据，属于垃圾数据，要清理
	s RowId=0
	for
	{
		s RowId=$o(^DHCTARI(RowId)) q:((RowId="")||(RowId'>0))
		IF ($D(^DHCTARI(RowId))=10) k ^DHCTARI(RowId)
	}
	//医嘱项和医嘱项关联医院如果保存后，再回滚会导致存在^ARCIM(1,1,"HOSP",0)=1的数据，属于垃圾数据，要清理
	s RowId=0
	for
	{
		s RowId=$o(^ARCIM(RowId)) q:((RowId="")||(RowId'>0))
		if ($D(^ARCIM(RowId,1,1))=0)&&($D(^ARCIM(RowId,1))>0) k ^ARCIM(RowId)	
	}
	Q ""
}

}

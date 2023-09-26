/// Function:材料审批完成后生成材料数据
/// CreateDate:2023-04-23
/// Creator:sunfengchao
Class web.BDPExt.INCMaterialAuditBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// update2020-02-11
/// 库存类组与分类关联表 User.DHCStkCatGrpRelations
/// User.DHCItmAddionInfo
ClassMethod SaveEntity(Ceobj As web.BDPExt.WZAuditEntity) As %String
{
    n (Ceobj,%session)
    s $zt="ERROR"
    s ImportResult="" 
    s liststr="Code^"_Ceobj.InciCode_"|Desc^"_Ceobj.InciDesc_"|Charge^"_Ceobj.Charge_"|Alias^"_Ceobj.Alias_"|Spec^"_Ceobj.Spec_"|Model^"_Ceobj.Model_"|Manf^"_Ceobj.Manf
    s liststr=liststr_"|BUom^"_Ceobj.BUom_"|PUom^"_Ceobj.PUom_"|Factor^"_Ceobj.Factor_"|PackUomMax^"_Ceobj.PackUomMax_"|PackUomFacMax^"_Ceobj.PackUomFacMax_"|SP^"_Ceobj.SP 
    s liststr=liststr_"|CatGrp^"_Ceobj.StkGrp_"|StkCat^"_Ceobj.StkCat_"|HighValue^"_Ceobj.HighValue_"|Origin^"_Ceobj.Origin_"|InsuCode^"_Ceobj.MatInsuCode_"|InsuDesc^"_Ceobj.MatInsuDesc_"|Barcode^"_Ceobj.INCBCode_"|Vendor^"_Ceobj.PbVendor
    s liststr=liststr_"|RegisterNo^"_Ceobj.RegisterNo_"|ImportFlag^"_Ceobj.ImportFlag
   
    s:Ceobj.OLTQty="" Ceobj.OLTQty="1" 
    s:Ceobj.TARIActiveFlag="" Ceobj.TARIActiveFlag="Y"
    
    s ^tmpcy("web.BDPExt.WZBLL22")=liststr
    Ts
    //库存项
    ///2020-04-16调用物资组李慧新接口web.DHCSTMHUI.Tools.CodeInputX
    //s importret=##class(web.DHCSTM.Tools.CodeInputX).SaveInci(liststr)  //>0 - 成功,<0 - 失败
    ///调试：w ##class(web.DHCSTMHUI.Tools.CodeInputX).SaveInci(^tmpcy("web.BDPExt.WZBLL"),2)
    try
    {
        s importret=##class(web.DHCSTMHUI.Tools.CodeInputX).SaveInci(liststr,Ceobj.LinkHospId)
    }
    catch myvar
    { 
        s importret="{""rowid"":"""",""msg"":"""_$tr($ze,"""","")_""",""success"":""-1"",""keyValue"":{}}"
        
    } 
    /// 解析新的返回值 JSON串 if (importret>0)    //>0 - 成功,<0 - 失败
    set messageJsonObj=##class(%DynamicAbstractObject).%FromJSON(importret)  //将返回值json处理成对象
    if (messageJsonObj.success=0)  //为负数时为保存失败,0为保存成功
    {
        s InciID=messageJsonObj.rowid
        if (InciID>0)
        {
            S INCIIsTrfFlag=$P($G(^INCI(InciID,2)),"^",6)
            i INCIIsTrfFlag["Both" s $P(^INCI(InciID,2),"^",6)="B"   ///Both Iss & Trf  表结构有问题
            
            i (Ceobj.InciCode="") 
            {
                s Ceobj.InciCode=$p($g(^INCI(InciID,1)),"^",1)  //医嘱项代码=收费项代码   
            }
            ///后勤类材料不需要导医嘱项
            ///医用卫生材料中（收费）的有医嘱项,医用卫生材料中（非收费类）一般也不用医嘱项
            if ($ZCVT(Ceobj.Charge,"U")="Y")
            {
                
                ///医嘱项
                s myARCIMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Ceobj.ARCIMCode,Ceobj.LinkHospId)  //$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.ARCIMCode),0))    ///已存在的医嘱项跳过
                if (myARCIMRowId="")
                {
                    //医嘱项
                    s arcimeobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.ARCItmMast")
                    s arcimeobj.LinkHospId=Ceobj.LinkHospId
                    s arcimeobj.ARCIMRowId=""
                    s arcimeobj.ARCIMCode=Ceobj.ARCIMCode  //医嘱项代码=库存项代码
                    s arcimeobj.ARCIMDesc=Ceobj.ARCIMDesc  //医嘱项名称=库存项名称
                    s arcimeobj.ARCIMItemCatDR=Ceobj.ARCIMItemCatDR
                    s arcimeobj.ARCIMBillSubDR=Ceobj.ARCIMBillSubDR
                    s arcimeobj.ARCIMBillingUOMDR=Ceobj.ARCIMBillingUOMDR     //医嘱项走计价单位
                    s arcimeobj.ARCIMOrderOnItsOwn=Ceobj.ARCIMOrderOnItsOwn
                    i (arcimeobj.ARCIMOrderOnItsOwn'="N") s arcimeobj.ARCIMOrderOnItsOwn="Y"  //默认为独立医嘱
                    s arcimeobj.ARCIMAllowOrderWOStockCheck=Ceobj.ARCIMAllowOrderWOStockCheck
                    i (arcimeobj.ARCIMAllowOrderWOStockCheck'="Y") s arcimeobj.ARCIMAllowOrderWOStockCheck="N"   //默认为有库存
                    s ARCIMSaveResult=##class(web.DHCBL.CT.ARCItmMast).SaveEntity(arcimeobj)    
                    s myARCIMRowId=##class(web.BDPExt.FunLib).GetResultRowId(ARCIMSaveResult)
                }
                if (myARCIMRowId'="")&&(InciID>0)
                {
                    //保存完医嘱项后要修改库存项里的医嘱项dr，指向这条医嘱项
                    IF myARCIMRowId["||"
                    {
                        s inciobj=##class(User.INCItm).%OpenId(InciID,0)
                        if inciobj'=""
                        {
                            Do inciobj.INCIOriginalARCIMDRSetObjectId(myARCIMRowId) 
                            s sc=inciobj.%Save()
                            do inciobj.%Close()
                            if $$$ISERR(sc)
                            {
                                s ImportResult="{success:'false',errorinfo:'保存库存项的医嘱项指针失败！'}" 
                            }
                        }
                        else
                        {
                            s ImportResult="{success:'false',errorinfo:'获取库存项对象失败！'}" 
                            
                        } 
                    }
                    else
                    {
                        s ImportResult="{success:'false',errorinfo:'医嘱项id/库存项id错误!'}" 
                    }
                    if ImportResult=""
                    {
                        ///医嘱项别名
                        if Ceobj.Alias'=""
                        {
                            s aliaslength=$l(Ceobj.Alias,"/")
                            for i=1:1:aliaslength
                            {   
                                continue:$p(Ceobj.Alias,"/",i)=""
                                s aliaseobj=##class(web.Entity.CT.ARCAlias).%New()
                                s aliaseobj.ALIASARCIMDR=myARCIMRowId
                                s aliaseobj.ALIASDateFrom=Ceobj.ARCIMEffDate //2019-02-24
                                s aliaseobj.ALIASDateTo=Ceobj.ARCIMEffDateTo
                                s aliaseobj.ALIASText=$p(Ceobj.Alias,"/",i) 
                                d ##class(web.DHCBL.CT.ARCAlias).SaveEntity(aliaseobj)
                            }
                        }
                        //收费项
                        s tarieobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarItem")
                        s tarieobj.LinkHospId=Ceobj.LinkHospId
                        s tarieobj.TARIRowId=""   
                        s tarieobj.TARICode=Ceobj.TARICode   //收费项代码
                        s tarieobj.TARIDesc=Ceobj.TARIDesc   //收费项名称
                        s tarieobj.TARIUOM=Ceobj.TARIUOM      //收费项走基本单位
                        s tarieobj.TARISubCate=Ceobj.TARISubCate
                        s tarieobj.TARIInpatCate=Ceobj.TARIInpatCate
                        s tarieobj.TARIOutpatCate=Ceobj.TARIOutpatCate
                        s tarieobj.TARIEMCCate=Ceobj.TARIEMCCate
                        s tarieobj.TARIAcctCate=Ceobj.TARIAcctCate
                        s tarieobj.TARIMRCate=Ceobj.TARIMRCate
                        s tarieobj.TARIMCNew=Ceobj.TARIMCNew   
                        s tarieobj.TARIInsuCode=Ceobj.TARIInsuCode    //国家医保编码
                        s tarieobj.TARIInsuName=Ceobj.TARIInsuName    //国家医保名称
                        s tarieobj.TARIActiveFlag=Ceobj.TARIActiveFlag
                        s:tarieobj.TARIActiveFlag="" tarieobj.TARIActiveFlag="Y"  
                        s TARISaveResult=##class(web.DHCBL.CT.DHCTarItem).SaveEntity(tarieobj)  
                        s TARIRowId=##class(web.BDPExt.FunLib).GetResultRowId(TARISaveResult)
                        if (TARIRowId'="")
                        {
                            if Ceobj.TARIAlias'=""  //收费项别名
                            {
                                s aliaslength=$l(Ceobj.TARIAlias,"/")
                                for i=1:1:aliaslength
                                {   
                                    ///收费项别名
                                    s tiaeobj=##class(web.Entity.CT.DHCTarItemAlias).%New()
                                    s tiaeobj.TIATARIDR=TARIRowId
                                    s tiaeobj.TIAAlias=$p(Ceobj.TARIAlias,"/",i)    
                                    d ##class(web.DHCBL.CT.DHCTarItemAlias).SaveEntity(tiaeobj)
                                }
                            }
                                   
                            //收费项价格
                            s tpeobj=##class(web.Entity.CT.DHCTarItemPrice).%New()
                            s tpeobj.TPTARIParRef=TARIRowId
                            s tpeobj.TPHospitalDR=Ceobj.LinkHospId
                            s tpeobj.TPPatInsType =Ceobj.TPPatInsType //患者费别
                            
                            //计算基本单位对应的价格   2017-03-21 入库单位和基本单位的转换系数
                            s CTCFRowId=$o(^CT("CTCF",0,"UOM",Ceobj.PUom,Ceobj.BUom,0)) 
                            if CTCFRowId'="" 
                            {
                                s CTCFFactor=$p($g(^CT("CTCF",CTCFRowId)),"^",3)
                                s tpeobj.TPPrice=Ceobj.SP/CTCFFactor
                            }
                            s tpeobj.TPStartDate =Ceobj.TARIStartDate 
                            s tpeobj.TPEndDate =Ceobj.TARIEndDate
                            s TPSaveResult=##class(web.DHCBL.CT.DHCTarItemPrice).SaveEntity(tpeobj)         
                            s TPRowId=##class(web.BDPExt.FunLib).GetResultRowId(TPSaveResult)
                            if (TPRowId'="")
                            {
                                
                                s olteobj=##class(web.Entity.CT.DHCOrderLinkTar).%New() ///医嘱项与收费项目关联 
                                s olteobj.OLTARCIMDR=myARCIMRowId
                                s olteobj.OLTTariffDR=TARIRowId 
                                s olteobj.OLTQty=1
                                s olteobj.OLTStartDate =Ceobj.ARCIMEffDate
                                s olteobj.OLTEndDate=Ceobj.ARCIMEffDateTo 
                                s OLTSaveResult=##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(olteobj)
                                s OLTRowId=##class(web.BDPExt.FunLib).GetResultRowId(OLTSaveResult)
                                if (OLTRowId="")
                                {
                                    s ImportResult="医嘱项与收费项目关联:"_OLTSaveResult
                                } 
                            }
                            else
                            {
                                s ImportResult="收费项目价格:"_TPSaveResult               
                            }
                        }   
                        else
                        {
                            s ImportResult="收费项目:"_TARISaveResult           
                        }
                    }
                }
                else
                {
                    s ImportResult="医嘱项:"_ARCIMSaveResult   
                }
            }
            
        }
        else
        {
            s ImportResult="{success:'false',errorinfo:'获取库存项RowId失败！'}" 
        }
        
            
    }
    else
    {
        s ImportResult= "物资接口保存失败："_messageJsonObj.msg 
    }
    if (ImportResult="")
    {
        Tc
        s ImportResult="{success:'true',id:'"_InciID_"'}"   ///返回库存项单位
    }
    else
    {
        Tro
    }

    q ImportResult
ERROR
    Q "导入报错"_$ZE
}

/// Creator:陈莹
/// CreatDate:2017-3-22
/// Description:数据重复验证方法,导入药品数据时调用
/// Table:User.INCItm
/// Input: code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.BDPExt.WZBLL).FormValidate("ZZZ00035","齿轮","2")
/// Other:w ##class(web.BDPExt.WZBLL).FormValidate("A00N001","药箅子[1个]",2)
ClassMethod FormValidate(code As %String, desc As %String, hospid As %String) As %String
{
    new (code,desc,hospid)
    s flag=""
    if ($$ALPHAUP^SSUTIL4(code)'="")
    {
        s idc=0
        for
        {
            s idc=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
            s Value=$p($g(^INCI(idc,1)),"^",1)
            if (Value=code)
            {
                
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("INC_Itm",idc,hospid)
                continue:showflag="N"
                s flag=1
            }           
        }       
    }
    if ($$ALPHAUP^SSUTIL4(desc)'="")
    {
        s idc=0
        for
        {
            s idc=$o(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(desc),idc)) q:idc=""
            s Value=$p($g(^INCI(idc,1)),"^",2)
            if (Value=desc)
            {
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("INC_Itm",idc,hospid)
                continue:showflag="N"
                s flag=1
            }
            
        }
        
    }
    q flag
}

/// Creator:陈莹
/// CreatDate:2017-10-10
/// Description:通过库存项是否收费标志（有没有关联医嘱项）
/// w ##class(web.BDPExt.WZBLL).GetChargeFlag(INCIRowId)
ClassMethod GetChargeFlag(INCIRowId) As %String
{
    n (INCIRowId)
    q:INCIRowId="" ""
    s INCIOriginalARCIMDR=$P($G(^INCI(INCIRowId,1)),"^",3)
    if (INCIOriginalARCIMDR'="")
    {
        s Flag="Y"
    }
    else
    {
        s Flag="N"
    }
    q Flag
}

/// Creator:陈莹
/// CreatDate:2017-10-10
/// Description:通过库存项获取库存类组描述
/// 库存类组与分类关联表 User.DHCStkCatGrpRelations
/// w ##class(web.BDPExt.WZBLL).GetCatGrpByRowId(INCIRowId)
ClassMethod GetCatGrpByRowId(INCIRowId) As %String
{
    n (INCIRowId)
    q:INCIRowId="" ""
    s Desc=""
    s StkCat=$p($g(^INCI(INCIRowId,2)),"^",2)
    if StkCat'=""
    {
        s SCGRowid=$o(^DHCSCG("STKCAT",StkCat,0))
        s:SCGRowid'="" Desc=$p($g(^DHCSCG(SCGRowid)),"^",2) 
    }
    q Desc
}

/*
    ///字段名和值之间用上箭头"^" 拼接，然后它们之间再用"|"拼接。
    s yzxobj.TARIExternalCode=Ceobj.TARIExternalCode
            s yzxobj.TARIEngName=Ceobj.TARIEngName
            s yzxobj.TARIChargeBasis=Ceobj.TARIChargeBasis
            s yzxobj.TARIConnote=Ceobj.TARIConnote
            s yzxobj.TARIRemark=Ceobj.TARIRemark
            s yzxobj.TARIExclude=Ceobj.TARIExclude
            
            */
/// Function: 物资导入时的调试程序
/// d ##class(web.BDPExt.WZBLL).Test()
ClassMethod Test()
{
    s eobj=##class(web.BDPExt.WZEntity).%New()

    s eobj.AcctSubCat=4 

    s eobj.BUom=152
    s eobj.BillCat=16
    s eobj.BillSubCat="16||1"

  s eobj.CatGrp ="无菌卫生材料"

 s eobj.Charge="Y"
 s eobj.Code="C362034551d" 
 s eobj.Desc="锁定加压骨接合固定系统d" // (天津正天医疗器械有限公司/锁定加压骨接合固定系统 小L形锁定板/YHP0101 3孔×34mm(右),Ti6Al7Nb)" 
 
              

    s eobj.EmSubCat=48
    s eobj.Factor=1
    s eobj.FeeUom=152
    s eobj.FeeUomFac=1
    s eobj.HighValue="Y"
    s eobj.ID="" 

    s eobj.InpaSubCat=4 
    s eobj.LinkHospId=2 
    s eobj.MrSubCat=4

    s eobj.MrSubCatNew=27
    s eobj.Onitsown="Y"
    s eobj.OrdCat=10
    s eobj.OrdSubCat=50    
    s eobj.OutpaSubCat=4
    s eobj.PUom=152    
    s eobj.RP=914.29   
    s eobj.SP=914.29 

    s eobj.StkCat=5
    s eobj.TarCat=16
    s eobj.TarSubCat=48
    s eobj.Wostock="Y" 
    s rest=..SaveEntity(eobj)
    b ;ret
}

}

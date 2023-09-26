Import sqluser

/// Descript:   统计物资批次信息
/// Creater:    lxt
/// CreateDate:	2017-09-26
Class web.DHCSTMHUI.ItmBatPrice Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	根据条件统计物资批次价格变动
/// Creater:	lxt
/// CreateDate:	2017-09-26
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ItmBatPrice","QueryBatRp","{""StartDate"":""2019-06-01"",""gUserId"":""6423"",""gLocId"":""554"",""gGroupId"":""277"",""gHospId"":""10"",""EndDate"":""2020-06-25"",""ScgStk"":"""",""StkCat"":"""",""Vendor"":"""",""HvFlag"":"""",""ChargeFlag"":"""",""InciDesc"":"""",""Inci"":"""",""BatNo"":"""",""MinRp"":"""",""MaxRp"":""""}")
/// StartDate As %String, EndDate As %String, GrpType As %String, StkCatId As %String, Others As %String
Query QueryBatRp(Params As %String(MAXLEN="")) As Query(ROWSPEC = "incib,inci,inciCode,inciDesc,spec,batNo,expDate,rpBuom,rpPuom:%Float,spBuom:%Float,spPuom:%Float,Buom:%Float,Puom:%Float,manfCode,manfName,vendorCode,vendorName,ingrNo,dateAdd,TimeAdd,giftFlag,adjCheque,stkgrp,Incsc") [ SqlProc ]
{
}

ClassMethod QueryBatRpExecute(ByRef qHandle As %Binary, Params As %String(MAXLEN="")) As %Status
{
 n (qHandle,Params)
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:Params="" $$$OK
 s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
 d PJobj.%FromJSON(Params)
 s StartDate=PJobj.%Get("StartDate")
 s EndDate=PJobj.%Get("EndDate") 
 s:StartDate'="" StartDate=..DH2L(StartDate)
 s:EndDate'="" EndDate=..DH2L(EndDate)
 s inciDr=PJobj.%Get("Inci")
 s BATNO=PJobj.%Get("BatNo")
 s MANFId=PJobj.%Get("Manf")
 s VENDORId=PJobj.%Get("Vendor")
 s MinRp=PJobj.%Get("MinRp")
 s MaxRp=PJobj.%Get("MaxRp")
 s hvFlag=PJobj.%Get("HvFlag")
 s charge=PJobj.%Get("ChargeFlag")
 s GrpType=PJobj.%Get("ScgStk")
 s gHospId=PJobj.%Get("gHospId")
 s StkGrp=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("","M","",GrpType,gHospId)
 s StkCatId=PJobj.%Get("StkCat")
 s sql= "select  incib_incib_dr  incib,"
 s sql=sql_"incib_rp  rpBuom,"
 s sql=sql_"incib_rppuruom  rpPuom,"
 s sql=sql_"incib_sp  spBuom,"
 s sql=sql_"incib_sppuruom  spPuom,"
 s sql=sql_"incib_phmnf_dr  manfId,"
 s sql=sql_"incib_phmnf_dr->phmnf_code  manfCode,"
 s sql=sql_"incib_phmnf_dr->phmnf_name  manfName,"
 s sql=sql_"incib_apcvm_dr  vendorId,"
 s sql=sql_"incib_apcvm_dr->APCVM_code  vendorCode,"
 s sql=sql_"incib_apcvm_dr->APCVM_name  vendorName,"
 s sql=sql_"incib_ingri_dr->INGRI_INGR_ParRef->ingr_no  ingrNo,"
 s sql=sql_"incib_dateAdd  dateAdd,"
 s sql=sql_"incib_TimeAdd  TimeAdd,"
 s sql=sql_"incib_GiftFlag  giftFlag,"
 s sql=sql_"incib_adjcheque  adjCheque "
 s sql=sql_"  from  DHC_IncItmBat  order  by  incib_dateAdd  asc"

 s xrs=##class(%Library.ResultSet).%New()
 s xrs.RuntimeMode=0
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 s n=0
 k ^TMPITMBATRP
 if $$$ISERR(sc) q $$$OK
 while ( xrs.Next())
 {
   s dateAdd=xrs.Data("dateAdd")
   continue:((EndDate'="")&&(dateAdd>EndDate))
   continue:((StartDate'="")&&(dateAdd<StartDate))
   s incib=xrs.Data("incib")
   s inci=+incib
   s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("INC_Itm",inci,gHospId)
   continue:ShowDataFlag="N"
   continue:((inciDr'="")&&(inciDr'=inci))
   s stkgrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
   s tmptype=$p(stkgrpInfo,"^",3)
   continue:(tmptype'=..sssCode())
   s inciCode=$P(^INCI(inci,1),"^",1)
   s inciDesc=$P(^INCI(inci,1),"^",2)
   s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
   s ch=$p(incib,"||",2)
   s batNo=$p(^INCI(inci,"IB",ch),"^",1)
   continue:((BATNO'="")&&(BATNO'=batNo))
   s expDate=$p(^INCI(inci,"IB",ch),"^",2)
   s rpBuom=xrs.Data("rpBuom")
   continue:(MinRp'="")&&(MinRp>+rpBuom)
   continue:(MaxRp'="")&&(MaxRp<+rpBuom)
   s rpPuom=xrs.Data("rpPuom")
   s spBuom=xrs.Data("spBuom")
   s spPuom=xrs.Data("spPuom")
   s Buom=$p(^INCI(inci,1),"^",10)
   s:Buom'="" Buom=$p(^CT("UOM",Buom),"^",2)
   s Puom=$p(^INCI(inci,3),"^",6)
   s:Puom'="" Puom=$p(^CT("UOM",Puom),"^",2)
   s manfId=xrs.Data("manfId")
   continue:(MANFId'="")&&(MANFId'=manfId)
   s manfCode=xrs.Data("manfCode")
   s manfName=xrs.Data("manfName")
   s vendorId=xrs.Data("vendorId")
   continue:(VENDORId'="")&&(VENDORId'=vendorId)
   s vendorCode=xrs.Data("vendorCode")
   s vendorName=xrs.Data("vendorName")
   s ingrNo=xrs.Data("ingrNo")
   s TimeAdd=xrs.Data("TimeAdd")
   s giftFlag=xrs.Data("giftFlag")
   s adjCheque=xrs.Data("adjCheque")
   s stkgrpId=$p(stkgrpInfo,"^",5)
   continue:((GrpType'="")&&(("^"_StkGrp_"^")'[("^"_stkgrpId_"^")))
   s stkgrp=$p(stkgrpInfo,"^",6)
   s IncscId=$p(^INCI(inci,2),"^",2)
   continue:((StkCatId'="")&&(StkCatId'[IncscId))
   s Incsc=$p(^INC("SC",IncscId),"^",2)
   s HV=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
   continue:((hvFlag'="")&&(hvFlag'=HV))  
   s chargeflag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(inci)
   continue:((charge'="")&&(charge'=chargeflag))
   s n=n+1
   s ^TMPITMBATRP(inci,n)=incib_"^"_inci_"^"_inciCode_"^"_inciDesc_"^"_spec_"^"_batNo_"^"_expDate
   _"^"_rpBuom_"^"_rpPuom_"^"_spBuom_"^"_spPuom_"^"_Buom_"^"_Puom_"^"_manfCode_"^"_manfName_"^"_vendorCode
   _"^"_vendorName_"^"_ingrNo_"^"_dateAdd_"^"_TimeAdd_"^"_giftFlag_"^"_adjCheque_"^"_stkgrp_"^"_Incsc
 }
 s inci=0
 f  s inci=$o(^TMPITMBATRP(inci)) q:+inci=0  d
 .s n=0
 .f  s n=$o(^TMPITMBATRP(inci,n)) q:+n=0  d
 ..s incib=$p(^TMPITMBATRP(inci,n),"^",1)
 ..s inci=$p(^TMPITMBATRP(inci,n),"^",2)
 ..s inciCode=$p(^TMPITMBATRP(inci,n),"^",3)
 ..s inciDesc=$p(^TMPITMBATRP(inci,n),"^",4)
 ..s spec=$p(^TMPITMBATRP(inci,n),"^",5)
 ..s batNo=$p(^TMPITMBATRP(inci,n),"^",6)
 ..s expDate=$p(^TMPITMBATRP(inci,n),"^",7)
 ..s:expDate'="" expDate=..DL2H(expDate)
 ..s rpBuom=$p(^TMPITMBATRP(inci,n),"^",8)
 ..s rpPuom=$p(^TMPITMBATRP(inci,n),"^",9)
 ..s spBuom=$p(^TMPITMBATRP(inci,n),"^",10)
 ..s spPuom=$p(^TMPITMBATRP(inci,n),"^",11)
 ..s Buom=$p(^TMPITMBATRP(inci,n),"^",12)
 ..s Puom=$p(^TMPITMBATRP(inci,n),"^",13)
 ..s manfCode=$p(^TMPITMBATRP(inci,n),"^",14)
 ..s manfName=$p(^TMPITMBATRP(inci,n),"^",15)
 ..s vendorCode=$p(^TMPITMBATRP(inci,n),"^",16)
 ..s vendorName=$p(^TMPITMBATRP(inci,n),"^",17)
 ..s ingrNo=$p(^TMPITMBATRP(inci,n),"^",18)
 ..s dateAdd=$p(^TMPITMBATRP(inci,n),"^",19)
 ..s:dateAdd'="" dateAdd=..DL2H(dateAdd)
 ..s TimeAdd=$p(^TMPITMBATRP(inci,n),"^",20)
 ..s giftFlag=$p(^TMPITMBATRP(inci,n),"^",21)
 ..s adjCheque=$p(^TMPITMBATRP(inci,n),"^",22)
 ..s stkgrp=$p(^TMPITMBATRP(inci,n),"^",23)
 ..s Incsc=$p(^TMPITMBATRP(inci,n),"^",24)
 ..s last=$o(^TMPITMBATRP(inci,n),-1)
 ..s rpBuomlast=0
 ..s:+last'=0 rpBuomlast=$p(^TMPITMBATRP(inci,last),"^",8)
 ..q:(+last'=0)&&(rpBuomlast=rpBuom)
 ..d OutPurRow
  
  
 Quit $$$OK
 
OutPurRow
 s Data=$lb(incib,inci,inciCode,inciDesc,spec,batNo,expDate,rpBuom,rpPuom,spBuom,spPuom,Buom,Puom,manfCode,manfName,
 vendorCode,vendorName,ingrNo,dateAdd,TimeAdd,giftFlag,adjCheque,stkgrp,Incsc)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

}

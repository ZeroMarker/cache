Import SQLUser

Class web.DHCANCom Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod getCurDateAndTime() As %String
{
    s dat=$zd(+$h,3)
    s tim=$zt($p($h,",",2))
    q dat_"^"_tim
}

ClassMethod GetANCVitalSign(ancvcId = "") As %String
{
    s ancoId =0,resStr=""
    f  s ancoId=$o(^DHCANC("ComOrd",ancoId)) q:ancoId=""  d
        .s ancoStr=$g(^DHCANC("ComOrd",ancoId))
        .q:($p(ancoStr,"^",3)'="V")
        .s ancoStr=$tr(ancoStr,"^","!")
        .q:(ancvcId'="")&($p(ancoStr,"!",5)'=ancvcId)
        .i resStr'="" s resStr=resStr_"^"
        .s $p(ancoStr,"!",7)=$p(ancoStr,"!",7)
        .//s resStr=resStr_ancoId_"!"_$p(ancoStr,"!",2,3)_"!"_$p(ancoStr,"!",5,7)
        .s resStr=resStr_ancoId_"!"_$p(ancoStr,"!",2)_"!"_$p(ancoStr,"!",6)_"!"_$p(ancoStr,"!",5)_"!"_$p(ancoStr,"!",7,8)
    q resStr
}

ClassMethod GetAncEvent(ancvcId = "") As %String
{
    s ancoId=0,resStr=""
    f  s ancoId=$o(^DHCANC("ComOrd",ancoId)) q:ancoId=""  d
        .s ancoStr=$g(^DHCANC("ComOrd",ancoId))
        .q:($p(ancoStr,"^",3)'="E")
        .q:(ancvcId'="")&($p(ancoStr,"^",5)'=ancvcId)
        .i resStr'="" s resStr=resStr_"^"
        .s ancoStr=$tr(ancoStr,"^","!")
        .s $p(ancoStr,"!",7)=$p(ancoStr,"!",7)
        .s resStr=resStr_ancoId_"!"_$p(ancoStr,"!",1,2)_"!"_$p(ancoStr,"!",5)_"!"_$p(ancoStr,"!",7)
    q resStr
}

// 返回：eqUomIdStr等效剂量单位_"^"_eqDefDoseStr医嘱缺省量_"^"_baseUomId基本单位_"^"_eqQtyStr转换系数：基本单位数量*eqQty=等效剂量单位数量_"^"_volume单位代码为"ML"的转换系数,无则为""

ClassMethod GetEqUomQty(arcimId) As %String
{
    s eqUomIdStr="",eqDefDoseStr=1,baseUomId="",eqQtyStr=1,volume=1,basePrice=0
    q:arcimId="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume_"^"_basePrice
    s basePrice=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,+$h,"","","","")
    s baseUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
    s eqUomIdStr=baseUomId
    s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
    q:phcdfId="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume_"^"_basePrice
    s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
    q:phcdfSub="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume_"^"_basePrice
    s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)
    
    
    s volume=""
    s volUomId=$o(^CT("UOM",0,"Code","ML",""))
    s eqUomIdStr=baseUomId,eqQtyStr=1,eqDefDoseStr=1
    s eqId=0,haveData=0
    f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
        .s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
        .s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
        .s eqDefDose=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",3)
        .i eqQty=0 s eqQty=1
        .i $p(eqQty,".",1)="" s eqQty=0_eqQty
        .i $p(eqDefDose,".",1)="" s eqDefDose=0_eqDefDose
        .//i eqDefDose<1 s eqDefDose=eqQty
        .//i eqDefDose<1 s eqDefDose=1
        .q:(eqUomId="")!(eqQty=0)
        .i +eqDefDose=0 s eqDefDose=eqQty
        .i 'haveData s eqUomIdStr="",eqQtyStr="",eqDefDoseStr=""
        .
        .i eqUomIdStr'="" s eqUomIdStr=eqUomIdStr_"|",eqQtyStr=eqQtyStr_"|",eqDefDoseStr=eqDefDoseStr_"|"
        .s eqUomIdStr=eqUomIdStr_eqUomId,eqQtyStr=eqQtyStr_eqQty,eqDefDoseStr=eqDefDoseStr_eqDefDose
        .i volUomId=eqUomId d
            ..s volume=eqQty
            ..i +volume=0 s volume=1
        .s haveData=1
    q eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume_"^"_basePrice
}

ClassMethod GetAncComOrd(needAncvcIdStr = "", needArcimDesc = "", needComOrdType = "D", isAnApply = "Y") As %String
{
    q:'$d(^DHCANC("ViewCat",needAncvcIdStr)) 0 //目前只传单个
    k ^TMP("ANCom",$i),tmpData
    s isVPSite=""
    i needArcimDesc'="" s needArcimDesc=$$ALPHAUP^SSUTIL4(needArcimDesc)
    i needAncvcIdStr'="" d
        .s isVPSite=$p($g(^DHCANC("ViewCat",needAncvcIdStr)),"^",6)
        .i $p(^DHCANC("ViewCat",needAncvcIdStr),"^")="oEvent" d  //目前不用了
            ..s ancvcId=$o(^DHCANC("ViewCat",0,"gas",""))
            ..i ancvcId'="" s needAncvcIdStr=needAncvcIdStr_"|"_ancvcId
            ..s ancvcId=$o(^DHCANC("ViewCat",0,"liquid",""))
            ..i ancvcId'="" s needAncvcIdStr=needAncvcIdStr_"|"_ancvcId
            ..s ancvcId=$o(^DHCANC("ViewCat",0,"localAnaesth",""))
            ..i ancvcId'="" s needAncvcIdStr=needAncvcIdStr_"|"_ancvcId
    s ancoId=0,i=0
    f  s ancoId=$o(^DHCANC("ComOrd",ancoId)) q:ancoId=""  d
        .s ancoStr=$g(^DHCANC("ComOrd",ancoId))
        .q:(needComOrdType'="")&($p(ancoStr,"^",3)'=needComOrdType)
        .q:(isAnApply="Y")&($p(ancoStr,"^",9)'="Y")
        .q:(isAnApply'="")&(isAnApply'="Y")&($p(ancoStr,"^",10)'="Y")
        .s ancvcId=$p(^DHCANC("ComOrd",ancoId),"^",5)
        .q:(isVPSite'="Y")&(needAncvcIdStr'="")&(("|"_ancvcId_"|")'[("|"_needAncvcIdStr_"|"))
        .q:(isVPSite="Y")&($p($g(^DHCANC("ViewCat",+ancvcId)),"^",6)'="Y")
        .i $l(ancoStr,"^")<20 s $p(ancoStr,"^",20)=""
        .s ancoStr=$tr(ancoStr,"^",$c(3))
        .s ancoDesc=$p(^DHCANC("ComOrd",ancoId),"^",2)
        .s arcimIdList=$p(^DHCANC("ComOrd",ancoId),"^",4)
        .s aliasDesc="",arcimDesc="",haveArcimId=0
        .f i=1:1:$l(arcimIdList,"~") d
            ..s arcimId=$p(arcimIdList,"~",i)
            ..i $l(arcimIdList,"~")>1 w arcimId,!
            ..s arcimSub=+arcimId
            ..s arcimVer=$p(arcimId,"||",2)
            ..//q:(arcimSub="")!(arcimVer="")
            ..s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
            ..q:arcimDesc=""
            ..s aliasId=""
            ..i (arcimSub'="")&(arcimVer'="") d
                ...f  s aliasId=$O(^ARC("ALIAS",0,"ARCIM",arcimId,aliasId)) q:aliasId=""  d
                    ....i aliasDesc'="" s aliasDesc=aliasDesc_"^"
                    ....s aliasDesc=aliasDesc_$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
            ..//s arcimDesc=$p($g(^ARCIM(arcimSub,arcimVer,1)),"^",2)
            ..q:(needArcimDesc'="")&(("^"_aliasDesc_"^")'[("^"_needArcimDesc))&(ancoDesc'[needArcimDesc)&(arcimDesc'[needArcimDesc)
            ..s eqUomQty=..GetEqUomQty(arcimId) //??
            ..//s ancoStr=$g(^DHCANC("ComOrd",+ancoId))
            ..//ypz 090623 begin
            ..s defPhcinId=""
            ..s phcdfId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",12)
            ..s phcdId=+phcdfId,phcdfSub=+$p(phcdfId,"||",2)
            ..i phcdfSub'="" d
                ...s defPhcinId=$p($g(^PHCD(phcdId,"DF",phcdfSub,1)),"^",5)
            ..s haveArcimId=1
            ..s tmpData($p(ancoStr,$c(3),14)_","_$p(^DHCANC("ComOrd",ancoId),"^",1,2)_i)=ancoId_"^"_ancoStr_"^"_arcimId_"^"_arcimDesc_$c(3)_$p(eqUomQty,"^")_$c(3)_$p(eqUomQty,"^",2)_$c(3)_defPhcinId_$c(3)_$p(eqUomQty,"^",3)_$c(3)_$p(eqUomQty,"^",4)_$c(3)_$p(eqUomQty,"^",5)
            ..i $l(arcimIdList,"~")>1 w arcimId_":"_tmpData($p(ancoStr,$c(3),14)_","_$p(^DHCANC("ComOrd",ancoId),"^",1,2)_i),!
        .
        .q:(isAnApply="Y")&($p(ancoStr,$c(3),3)="D")&(haveArcimId=0)
        .q:haveArcimId=1
        .s tmpData($p(ancoStr,$c(3),14)_","_$p(^DHCANC("ComOrd",ancoId),"^",1,2))=ancoId_"^"_ancoStr_"^^"_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)
        .//ypz 090623 end
        .//s tmpData($p(^DHCANC("ComOrd",ancoId),"^",1,2))=ancoId_"^"_ancoStr_"^"_arcimDesc_"^"_$p(eqUomQty,"^")_"^"_$p(eqUomQty,"^",2)
        .//w tmpData($p(^DHCANC("ComOrd",ancoId),"^",1,2)),!
        .//s ^TMP("ANCom",$i,i)=ancoId_"^"_$p(^DHCANC("ComOrd",ancoId),"^",2)_"^"_$p(^DHCANC("ComOrd",ancoId),"^",4)_"^"_$p(^DHCANC("ComOrd",ancoId),"^",5)
        .//s i=i+1
    s node=""
    f  s node=$o(tmpData(node)) q:node=""  d
        .s ^TMP("ANCom",$i,i)=tmpData(node)
        .//w node_":"_^TMP("ANCom",$i,i),!
        .s i=i+1
    q i
    ;s arcimSub=0,i=0
    ;f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
    ;    .s arcicId=$p(^ARCIM(arcimSub,1,1),"^",10)
    ;    .i $p(^ARC("IC",arcicId),"^",8)'=30 q
    ;    .s ^TMP("ANCom",$i,i)=arcimSub_"||1,"_$p(^ARCIM(arcimSub,1,1),"^",2)
    ;    .s i=i+1 
    ;q i
}

// D ##CLASS(%ResultSet).RunQuery("web.DHCCLCom"," FindOrdCatExt")

// 返回值：ancoId常用医嘱码Id_"^"_ancoStr常用医嘱串_"^"_arcimId是HIS医嘱代码Id_"^"_

// arcimDesc医嘱名_$c(3)_eqUomIdStr等效剂量单位Id_$c(3)_eqDefDoseStr医嘱缺省量_$c(3)_用法Id_$c(3)_baseUomId基本单位_$c(3)_eqQtyStr转换系数_$c(3)_volume单位代码为"ML"的转换系数,无则为""

// 基本单位数量*转换系数=等效剂量单位数量

ClassMethod GetArcim(isComOrd, arcicId, needArcimDesc, ancvcId = "", comOrdType = "D", isAnApply = "Y") As %String
{
    i isComOrd="ComOrd" q ..GetAncComOrd(ancvcId,needArcimDesc,comOrdType,isAnApply)
    i arcicId="",needArcimDesc="",comOrdType q 0
    k ^TMP("ANCom",$i)
    
    i (needArcimDesc'="") s needArcimDesc=$$ALPHAUP^SSUTIL4(needArcimDesc)
    s arcimSub=0,i=0
    f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
        .s arcimVer=0 f  s arcimVer=$o(^ARCIM(arcimSub,arcimVer)) q:arcimVer=""  d
            ..s arcimId=arcimSub_"||"_arcimVer
            ..s arcicId=$p($g(^ARCIM(+arcimId,arcimVer,1)),"^",10)
            ..q:arcicId=""
            ..q:'$d(^ARC("IC",arcicId))
            ..q:(isAnApply="Y")&($p(^ARC("IC",arcicId),"^",7)'="R") //arcic_OrderType
            ..q:##class(web.DHCANOPCom).IfEffectOrd("",arcimId)'="Y"
            ..s aliasId="",aliasDesc=""
            ..f  s aliasId=$O(^ARC("ALIAS",0,"ARCIM",arcimId,aliasId)) q:aliasId=""  d
                ...i aliasDesc'="" s aliasDesc=aliasDesc_"^"
                ...s aliasDesc=aliasDesc_$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
            ..q:aliasDesc=""
            ..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
            ..q:(needArcimDesc'="")&(("^"_aliasDesc_"^")'[("^"_needArcimDesc))&(arcimDesc'[needArcimDesc)
            ..s itemcatDR=$p(^ARCIM(arcimSub,arcimVer,1),"^",10)
            ..i arcicId'="",arcicId'=itemcatDR q
            ..
            ..s lAncoId=0,ancoId=0
            ..f  s lAncoId=$o(^DHCANC("ComOrd",lAncoId)) q:(lAncoId="")!(ancoId>0)  d
                ...i arcimId=$p($g(^DHCANC("ComOrd",lAncoId)),"^",4) s ancoId=lAncoId
            ..//s ancvcId=$o(^DHCANC("ViewCat",0,"oEvent",""))  //无用
            ..i ancoId>0 s ancvcId=$p($g(^DHCANC("ComOrd",ancoId)),"^",5)
            ..s eqUomQty=..GetEqUomQty(arcimId)
            ..s ancoStr=""
            ..i ancoId>0 s ancoStr=$g(^DHCANC("ComOrd",+ancoId))
            ..i $l(ancoStr,"^")<20 s $p(ancoStr,"^",20)=""
            ..i $p(ancoStr,"^",4)="" s $p(ancoStr,"^",4)=arcimId
            ..s $p(ancoStr,"^",5)=ancvcId
            ..s ancoStr=$tr(ancoStr,"^",$c(3))
            ..//ypz 090623 begin
            ..s defPhcinId=""
            ..s phcdfId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",12)
            ..s phcdId=+phcdfId,phcdfSub=+$p(phcdfId,"||",2)
            ..i phcdfSub'="" d
                ...s defPhcinId=+$p($g(^PHCD(phcdId,"DF",phcdfSub,1)),"^",5)
            ..s ^TMP("ANCom",$i,i)=+ancoId_"^"_ancoStr_"^"_arcimId_"^"_arcimDesc_$c(3)_$p(eqUomQty,"^")_$c(3)_$p(eqUomQty,"^",2)_$c(3)_defPhcinId_$c(3)_$p(eqUomQty,"^",3)_$c(3)_$p(eqUomQty,"^",4)_$c(3)_$p(eqUomQty,"^",5)
            ..//ypz 090623 end
            ..//s ^TMP("ANCom",$i,i)=+ancoId_"^"_ancoStr_"^"_arcimDesc_"^"_$p(eqUomQty,"^")_"^"_$p(eqUomQty,"^",2)
            ..//w i_":"_^TMP("ANCom",$i,i),!
            ..s i=i+1 
    q i
    ;s arcimSub=0,i=0
    ;f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
    ;    .s arcicId=$p(^ARCIM(arcimSub,1,1),"^",10)
    ;    .i $p(^ARC("IC",arcicId),"^",8)'=30 q
    ;    .s ^TMP("ANCom",$i,i)=arcimSub_"||1,"_$p(^ARCIM(arcimSub,1,1),"^",2)
    ;    .s i=i+1 
    ;q i
}

ClassMethod GetSearchArcim(isComOrd, arcicId, needArcimDesc, opaId = "", ctLocId = "", ancvcId = "", comOrdType = "D", isAnApply = "Y") As %String
{
    i isComOrd="ComOrd" q ..GetAncComOrd(ancvcId,needArcimDesc,comOrdType,isAnApply)
    i arcicId="",needArcimDesc="",comOrdType q 0
    k ^TMP("ANCom",$i)
    
    i (needArcimDesc'="") s needArcimDesc=$$ALPHAUP^SSUTIL4(needArcimDesc)
    s arcimSub=0,i=0
    f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
        .s arcimVer=0 f  s arcimVer=$o(^ARCIM(arcimSub,arcimVer)) q:arcimVer=""  d
            ..s arcimId=arcimSub_"||"_arcimVer
            ..s arcicId=$p($g(^ARCIM(+arcimId,arcimVer,1)),"^",10)
            ..q:arcicId=""
            ..q:'$d(^ARC("IC",arcicId))
            ..;q:(isAnApply="Y")&($p(^ARC("IC",arcicId),"^",7)'="R") //arcic_OrderType
            ..q:##class(web.DHCANOPCom).IfEffectOrd("",arcimId)'="Y"
            ..s aliasId="",aliasDesc=""
            ..f  s aliasId=$O(^ARC("ALIAS",0,"ARCIM",arcimId,aliasId)) q:aliasId=""  d
                ...i aliasDesc'="" s aliasDesc=aliasDesc_"^"
                ...s aliasDesc=aliasDesc_$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
            ..q:aliasDesc=""
            ..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
            ..q:(needArcimDesc'="")&(("^"_aliasDesc_"^")'[("^"_needArcimDesc))&(arcimDesc'[needArcimDesc)
            ..s itemcatDR=$p(^ARCIM(arcimSub,arcimVer,1),"^",10)
            ..i arcicId'="",arcicId'=itemcatDR q
            ..
            ..s lAncoId=0,ancoId=0
            ..f  s lAncoId=$o(^DHCANC("ComOrd",lAncoId)) q:(lAncoId="")!(ancoId>0)  d
                ...i arcimId=$p($g(^DHCANC("ComOrd",lAncoId)),"^",4) s ancoId=lAncoId
            ..//s ancvcId=$o(^DHCANC("ViewCat",0,"oEvent",""))  //无用
            ..i ancoId>0 s ancvcId=$p($g(^DHCANC("ComOrd",ancoId)),"^",5)
            ..s eqUomQty=..GetEqUomQty(arcimId)
            ..s ancoStr=""
            ..i ancoId>0 s ancoStr=$g(^DHCANC("ComOrd",+ancoId))
            ..i $l(ancoStr,"^")<20 s $p(ancoStr,"^",20)=""
            ..i $p(ancoStr,"^",4)="" s $p(ancoStr,"^",4)=arcimId
            ..s $p(ancoStr,"^",5)=ancvcId
            ..s ancoStr=$tr(ancoStr,"^",$c(3))
            ..//ypz 090623 begin
            ..s defPhcinId=""
            ..s phcdfId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",12)
            ..s phcdId=+phcdfId,phcdfSub=+$p(phcdfId,"||",2)
            ..i phcdfSub'="" d
                ...s defPhcinId=+$p($g(^PHCD(phcdId,"DF",phcdfSub,1)),"^",5)
            ..s itemPrice=+##Class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimId,+$h,"","","","")
            ..s defaultRecvLoc=##class(web.DHCANCall).GetOrderItemRecloc(opaId,arcimId,"",ctLocId)
            ..s defaultRecvLoc=$tr(defaultRecvLoc,"^","#")
            ..s ^TMP("ANCom",$i,i)=+ancoId_"^"_ancoStr_"^"_arcimId_"^"_arcimDesc_"^"_$p(eqUomQty,"^")_"^"_$p(eqUomQty,"^",2)_"^"_defPhcinId_"^"_$p(eqUomQty,"^",3)_"^"_$p(eqUomQty,"^",4)_"^"_$p(eqUomQty,"^",5)_"^"_itemPrice_"^"_defaultRecvLoc
            ..//ypz 090623 end
            ..//s ^TMP("ANCom",$i,i)=+ancoId_"^"_ancoStr_"^"_arcimDesc_"^"_$p(eqUomQty,"^")_"^"_$p(eqUomQty,"^",2)
            ..//w i_":"_^TMP("ANCom",$i,i),!
            ..s i=i+1 
    q i
    ;s arcimSub=0,i=0
    ;f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
    ;    .s arcicId=$p(^ARCIM(arcimSub,1,1),"^",10)
    ;    .i $p(^ARC("IC",arcicId),"^",8)'=30 q
    ;    .s ^TMP("ANCom",$i,i)=arcimSub_"||1,"_$p(^ARCIM(arcimSub,1,1),"^",2)
    ;    .s i=i+1 
    ;q i
}

/// Creator：        ccq
/// CreatDate：      2013-10-02
/// Description：    获取HIS医嘱项集合
/// Table：          ARC_ItmMast
/// Input：          arcimIdStr HIS医嘱项ID串，以“^”分割
/// Output：       
/// Return：         HIS医嘱项串，第一级以$c(3)分割，第二级以"^"分割
ClassMethod GetArcimList(arcimIdStr As %String) As %String
{
    q:(arcimIdStr="") "HIS医嘱项ID串为空"
    s result=""
    s arcimIdNum=$l(arcimIdStr,"~")
    f i=1:1:arcimIdNum  d
    .s arcimId=$p(arcimIdStr,"~",i)
    .s arcimStr=..GetArcimById(arcimId)
    .i result'="" s result=result_$c(3)
    .s result=result_arcimStr
    
    q result
}

ClassMethod GetCTUOM() As %String
{
    k ^TMP("ANCom",$i)
    s ctuomCode=0,i=0
    f  s ctuomCode=$o(^CT("UOM",0,"Code",ctuomCode)) q:ctuomCode=""  d
        .s ctuomId=$o(^CT("UOM",0,"Code",ctuomCode,""))
        .q:ctuomId=""
        .q:'$d(^CT("UOM",ctuomId))
        .s sortNo=$p(^CT("UOM",ctuomId),"^",3)
        .i +sortNo'=sortNo s sortNo=10000
        .s sortNo=sortNo+(ctuomId/10000)
        .s unitDesc=$ZCVT($p($g(^CT("UOM",+ctuomId)),"^",2),"l")
        .s unitCode=$p(^CT("UOM",+ctuomId),"^",1)
        .s tmpUom(sortNo)=ctuomId_"^"_unitDesc_"^"_unitCode
    s sortNo=""
    f  s sortNo=$o(tmpUom(sortNo)) q:sortNo=""  d
        .s i=i+1 
        .s ^TMP("ANCom",$i,i)=tmpUom(sortNo)
        .//w tmpUom(sortNo),!
    q i
}

ClassMethod GetOParrange(date As %String) As %String
{
    k ^TMP("ANCom",$i)
    s arcimSub=0,i=0
    f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
        .s arcicId=$p(^ARCIM(arcimSub,1,1),"^",10)
        .i $p(^ARC("IC",arcicId),"^",8)'=30 q
        .s ^TMP("ANCom",$i,i)=arcimSub_"||1,"_$p(^ARCIM(arcimSub,1,1),"^",2)
        .s i=i+1 
    q i
}

ClassMethod GetPHCIN() As %String
{
    k ^TMP("ANCom",$i)
    s phcinId=0,i=0
    f  s phcinId=$o(^PHCIN(phcinId)) q:phcinId=""  d
        .s sortNo=+$p(^PHCIN(phcinId),"^",3)
        .i sortNo=0 s sortNo=10000
        .s sortNo=sortNo+(phcinId/10000)
        .s tmpPhcin(sortNo)=phcinId_"^"_$p(^PHCIN(phcinId),"^",2)_"^"_$p(^PHCIN(phcinId),"^",1)_"^"_$p(^PHCIN(phcinId),"^",3)
    s sortNo=""
    f  s sortNo=$o(tmpPhcin(sortNo)) q:sortNo=""  d
        .s i=i+1 
        .s ^TMP("ANCom",$i,i)=tmpPhcin(sortNo)
    q i
}

ClassMethod GetCTLOC(typeStr As %String = "W^E^D^OP^EM^CL") As %String
{
    k ^TMP("ANCom",$i)
    s ctlocId=0,i=0
    f  s ctlocId=$o(^CTLOC(ctlocId)) q:ctlocId=""  d
        .q:"^"_typeStr_"^"'[("^"_$p(^CTLOC(ctlocId),"^",13)_"^")
        .//w $p(^CTLOC(ctlocId),"^",2),!
        .s ^TMP("ANCom",$i,i)=ctlocId_"^"_$p(^CTLOC(ctlocId),"^",2)
        .s i=i+1 
    q i
}

/// w ##class(web.DHCANCom).GetParaNew(86,42)
ClassMethod GetParaNew(opaId As %String, ctlocId As %String = "") As %String
{
    Q:'$d(^DHCANOPArrange(opaId)) ""
    s result=""
    s type=""
    f  s type=$o(^DHCANC("Para",type)) q:type=""  d
    .q:(type'=(ctlocId_"AN"))&(type'=(ctlocId_"PACU"))&(type'=(ctlocId_"SE"))
    .s ret=..GetParaSingle(opaId,ctlocId,$p(type,ctlocId,2))
    .i result="" s result=ret
    .e  s result=result_"^"_ret
    q result
}

ClassMethod GetParaSingle(opaId As %String, ctlocId As %String = "", Type As %String = "AN") As %String
{
    //少了两列
    //q:(+opaId=0) 0
    q:'$d(^DHCANOPArrange(opaId)) ""
    s i=0,resStr="",tmpStr=""
    i (+opaId=0) s anpId="Default"
    e  s anpId=..GetAnpIdNew(opaId,ctlocId,Type)
    s anpiSub=0
    f  s anpiSub=$o(^DHCANPara(anpId,"I",anpiSub)) q:anpiSub=""  d
        .s anpiStr=^DHCANPara(anpId,"I",anpiSub)
        .//w anpiStr,!
        .i "DHU"'[$p(anpiStr,"^",5) s $p(anpiStr,"^",5)="D"
        .i "IM"'[$p(anpiStr,"^",6) s $p(anpiStr,"^",6)="M"
        .s $p(anpiStr,"^",13)=$p(anpiStr,"^",13) //$p($g(^DHCANC("VPSite",+$p(anpiStr,"^",13))),"^",2)
        .s anpiStr=$tr(anpiStr,"^","!")
        .//s tmpStr=$p($g(^DHCANC("MDataItem",+anpiStr)),"^",2) //$p($g(^ORC("OPMON",+anpiStr)),"^",2)
        .//s tmpStr=tmpStr_"!"_$p($g(^DHCANC("Event",+$p(anpiStr,"!",2))),"^",2)
        .s tmpOrder=$p($g(^DHCANC("ComOrd",+$p(anpiStr,"!",4))),"^",2)
        .i tmpOrder="" d
        ..s tmpOrder=$p($g(^ARCIM(+$p(anpiStr,"!",3),1,1)),"^",2)
        .//s tmpStr=tmpStr_"!"_tmpOrder
        .s $p(anpiStr,"!",10)=$p(anpiStr,"!",10)_"!"_$p($g(^DHCANC("Scale",+$p(anpiStr,"!",10))),"^",3)_"!"_$p($g(^DHCANC("Scale",+$p(anpiStr,"!",10))),"^",5)
        .
        .//s $p(resStr,"^",$p(anpiStr,"!",8))=anpId_"||"_anpiSub_"!"_tmpOrder_"!"_anpiStr
        .s TmpList(+(anpiSub_"."_$p(anpiStr,"!",8)))=anpId_"||"_anpiSub_"!"_tmpOrder_"!"_anpiStr
    s tmpSeq=""
    f  s tmpSeq=$o(TmpList(tmpSeq)) q:tmpSeq=""  d
        .i resStr="" s resStr=resStr_"^"
        .s resStr=resStr_"^"_TmpList(tmpSeq)
    q resStr
}

/// w ##class(web.DHCANCom).GetAnpIdNew()
ClassMethod GetAnpIdNew(opaId, ctlocId, Type = "AN")
{
    q:(+opaId=0) 0
    s anpId=$o(^DHCANPara(0,opaId,""))
    s ctlocIdDocType=ctlocId_Type
    i ctlocIdDocType="" s ctlocIdDocType="Default"
    i anpId="" d
    .s ^DHCANPara(0)=$g(^DHCANPara(0))+1
    .s ^DHCANPara(0,opaId,^DHCANPara(0))=""
    .i '$d(^DHCANC("Para",ctlocIdDocType)) d
    ..m ^DHCANC("Para",ctlocIdDocType)=^DHCANC("Para","Default")
    
    .s anaId=$p($g(^DHCANOPArrange(opaId)),"^",2) //OPA_Anaest_dr
    .q:anaId=""
    .s EpisodeID=+anaId
    .s anaSub=$p(anaId,"||",2)

    .s anMethodId=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)         //ANA_Method
    .s anMethodCode=$P($g(^ORC("ANMET",+anMethodId)),"^",1)     //取第一个
    .i $d(^DHCANC("Para",ctlocIdDocType_"."_anMethodCode))>0 s ctlocIdDocType=ctlocIdDocType_"."_anMethodCode
    .m ^DHCANPara(^DHCANPara(0))=^DHCANC("Para",ctlocIdDocType)
    .s $p(^DHCANPara(^DHCANPara(0)),"^",1)=opaId  //ypz end
    .s anpId=^DHCANPara(0)
    .s num=0
    .s num=$g(^DHCANPara(anpId,"I",0))
    .f k=1:1:num d
    ..s $p(^DHCANPara(anpId,"I",k),"^",15)=Type
    .;PACU设置(暂时使用)
    .s pacuDocType=ctlocId_"PACU"
    .i $d(^DHCANC("Para",pacuDocType))>0  d
    ..s pacuTemplateCount=$g(^DHCANC("Para",pacuDocType,"I",0))
    ..f i=1:1:pacuTemplateCount  d
    ...s ^DHCANPara(anpId,"I",num+i)=^DHCANC("Para",pacuDocType,"I",i)
    ...s $p(^DHCANPara(anpId,"I",num+i),"^",15)="PACU"
    e  d
    .;s num=0
    .;s num=$g(^DHCANPara(anpId,"I",0))
    .;s count=^DHCANC("Para",ctlocIdDocType,"I",0)
    .;i count>0 d
    ..;f i=1:1:count d
    ...;s ^DHCANPara(^DHCANPara(0),"I",num+i)=^DHCANC("Para",ctlocIdDocType,"I",i)
    ...;s $p(^DHCANPara(anpId,"I",num+i),"^",14)=Type
    q anpId
}

ClassMethod GetPara(opaId As %String, ctlocIdDocType As %String = "") As %String
{
    //少了两列
    //q:(+opaId=0) 0
    q:'$d(^DHCANOPArrange(opaId)) ""
    s i=0,resStr="",tmpStr=""
    i (+opaId=0) s anpId="Default"
    e  s anpId=..GetAnpId(opaId,ctlocIdDocType)
    

    s anpiSub=0
    f  s anpiSub=$o(^DHCANPara(anpId,"I",anpiSub)) q:anpiSub=""  d
        .s anpiStr=^DHCANPara(anpId,"I",anpiSub)
        .//w anpiStr,!
        .i "DHU"'[$p(anpiStr,"^",5) s $p(anpiStr,"^",5)="D"
        .i "IM"'[$p(anpiStr,"^",6) s $p(anpiStr,"^",6)="M"
        .s $p(anpiStr,"^",13)=$p(anpiStr,"^",13) //$p($g(^DHCANC("VPSite",+$p(anpiStr,"^",13))),"^",2)
        .s anpiStr=$tr(anpiStr,"^","!")
        .//s tmpStr=$p($g(^DHCANC("MDataItem",+anpiStr)),"^",2) //$p($g(^ORC("OPMON",+anpiStr)),"^",2)
        .//s tmpStr=tmpStr_"!"_$p($g(^DHCANC("Event",+$p(anpiStr,"!",2))),"^",2)
        .s tmpOrder=$p($g(^DHCANC("ComOrd",+$p(anpiStr,"!",4))),"^",2)
        .i tmpOrder="" d
        ..s tmpOrder=$p($g(^ARCIM(+$p(anpiStr,"!",3),1,1)),"^",2)
        .//s tmpStr=tmpStr_"!"_tmpOrder
        .s $p(anpiStr,"!",10)=$p(anpiStr,"!",10)_"!"_$p($g(^DHCANC("Scale",+$p(anpiStr,"!",10))),"^",3)_"!"_$p($g(^DHCANC("Scale",+$p(anpiStr,"!",10))),"^",5)
        .
        .//s $p(resStr,"^",$p(anpiStr,"!",8))=anpId_"||"_anpiSub_"!"_tmpOrder_"!"_anpiStr
        .s TmpList(+(anpiSub_"."_$p(anpiStr,"!",8)))=anpId_"||"_anpiSub_"!"_tmpOrder_"!"_anpiStr
    s tmpSeq=""
    f  s tmpSeq=$o(TmpList(tmpSeq)) q:tmpSeq=""  d
        .i resStr="" s resStr=resStr_"^"
        .s resStr=resStr_"^"_TmpList(tmpSeq)
    q resStr
}

ClassMethod GetItems(i As %String, j As %String) As %Library.List
{
 s k=0,returnList=""
 f k=i:1:(i+j) d
     .i $d(^TMP("ANCom",$i,k))=1 d
         ..s returnList=returnList_$LB($LB(^TMP("ANCom",$i,k)))
         ..k ^TMP("ANCom",$i,k)
 q returnList
}

/// ctlocIdDocType为科室代码,为空：只存病人参数；
/// ctlocIdDocType不为空：anmetId麻醉方式ID，为空时存为科室模板；不为空存麻醉方式模板
ClassMethod SetPara(opaId As %String, paraStr As %String, ctlocIdDocType As %String = "", anmetId As %String = "") As %String
{
    q:(+opaId=0) -1
    s paraId=$o(^DHCANPara(0,opaId,""))
    
    k ^DHCANParaBak(paraId)
    m ^DHCANParaBak(paraId)=^DHCANPara(paraId)
    m ^DHCANParaBakCCQ(paraId)=^DHCANPara(paraId)
    ////s paraStr="!300!N^D!33!19244||1!144!A!!!1!!!1!!!^D!65!1427||1!9!A!!!2!!!2!!!^D!65!1295||1!2!A!!!3!!!2!!!^D!65!1371||1!7!A!!!4!!!2!!!^D!34!992||1!21!A!!!5!!!3!!!^V!63!!87!A!!7!6!ff8080!!157!!!^V!63!!95!A!!7!7!8080ff!!157!!!^E!23!!!A!!!8!!!15!!!^V!24!!82!A!!3!9!0000ff!!110!!!^V!24!!91!A!!2!10!000040!!110!!!^V!24!!90!A!!1!11!000040!!110!!!^V!24!!85!A!!1!12!008000!!110!!!^V!24!!86!A!!2!13!008000!!110!!!^D!64!!!A!!!14!!!4!!!^E!39!!!A!!!15!!!108!!!^D!39!!!A!!!16!!!160!!!"
    s num=$l(paraStr,"^")
    
    i num<2 q -2
    ;w ^DHCANPara(paraId),!
    s $p(^DHCANParaBak(paraId),"^",2)=$p(paraStr,"!",2)
    ;w ^DHCANPara(paraId),!
    s $p(^DHCANParaBak(paraId),"^",3)=$p($p(paraStr,"!",3),"^")
    ;w ^DHCANPara(paraId),!
    k ^DHCANParaBak(paraId,"I")
    s ^DHCANParaBak(paraId,"I",0)=num-1
    f i=2:1:num d
        .s paraiStr=$p(paraStr,"^",i)
        .s paraiStr=$tr(paraiStr,"!","^")
        .s tmpStr=$p(paraiStr,"^",3)
        .s ancoId=$p(paraiStr,"^",4)
        .i tmpStr'="",ancoId="" d
            ..s ancoId=0
            ..f  s ancoId=$o(^DHCANC("ComOrd",ancoId)) q:ancoId=""  d
                ...i tmpStr=$p(^DHCANC("ComOrd",ancoId),"^",4) s $p(paraiStr,"^",4)=ancoId
        .s tmpStr=$p(paraiStr,"^",4)
        .i tmpStr'="",$p(paraiStr,"^",3)="" d
            ..s $p(paraiStr,"^",3)=$p($g(^DHCANC("ComOrd",tmpStr)),"^",4)
        .//s ancvpsId=0
        .//f  s ancvpsId=$o(^DHCANC("VPSite",ancvpsId)) q:ancvpsId=""  d
            .//.i $p(paraiStr,"^",13)=$p(^DHCANC("VPSite",ancvpsId),"^",2) s $p(paraiStr,"^",13)=ancvpsId
        .s ^DHCANParaBak(paraId,"I",i-1)=paraiStr
    if (ctlocIdDocType="")
    {
        k ^DHCANPara(paraId)
        m ^DHCANPara(paraId)=^DHCANParaBak(paraId)  
    }
    q:ctlocIdDocType="" 0
    //s anmetId=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)       //ANA_Method
    i anmetId'="" d         //从前台取
        .s anmthCode=$P($g(^ORC("ANMET",+anmetId)),"^",1)       //取第一个
        .q:anmthCode=""
        .s ctlocIdDocType=ctlocIdDocType_"."_anmthCode
    //w ctlocIdDocType
    i ctlocIdDocType'="" d
        .k ^DHCANC("Para",ctlocIdDocType)
        .m ^DHCANC("Para",ctlocIdDocType)=^DHCANParaBak(paraId)
    q 0
}

ClassMethod AutoTerminal(inroomOpaId) As %String
{
    s retStr=0
    q:inroomOpaId="" 0
    q:'$d(^DHCANOPArrange(inroomOpaId)) 0
    q:$p(^DHCANOPArrange(inroomOpaId),"^",27)'="I" 0
    s anoId=$o(^DHCANOrder(0,"OPApp",inroomOpaId,""),-1)
    //i anoId="" &sql(update DHC_AN_OPArrange set OPA_Status='L' where OPA_RowId=:inroomOpaId) q
    s anoUpdateDate=$p($g(^DHCANOrder(+anoId)),"^",21)
    s anoUpdateTime=$p($g(^DHCANOrder(+anoId)),"^",22)
    s lastRecordToNow=($h-anoUpdateDate)*86400+$p($h,",",2)-anoUpdateTime
    //i (anoUpdateDate="")!(lastRecordToNow>18000) d
    i (1<0) d     //不执行自动结束监护操作
        .s ^tmpCLEquip("autoAn",inroomOpaId)=$zd($h,3)_" "_$zt($p($h,",",2))_" lastRecSec:"_lastRecordToNow
        .s retStr=..StopEquipCollect(inroomOpaId)
        .&sql(update DHC_AN_OPArrange set OPA_Status='L' where OPA_RowId=:inroomOpaId) 
    e  d
        .s papmiId=+^PAADM(+(^DHCANOPArrange(inroomOpaId)))
        .s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
        .s opaStartDate=$p(^DHCANOPArrange(inroomOpaId),"^",14)
        .s retStr="病人"_patName_"(手术Id:"_inroomOpaId_")正在手术!请选择日期"_$zd(opaStartDate,3)_"查询,进入麻醉监护,结束监护,退出后方可继续操作!"
    q retStr
}

/// w ##class(web.DHCANCom).SetInDateTime(85,"2017/9/24","09:00:00",1,"AN")
ClassMethod SetInDateTime(opaId As %String, inDate As %String, inTime As %String, isSet As %String = "1", accessType = "AN") As %String
{
    //accessType取值:"AN"/"PACU"
    q:(+opaId=0) "-1"
    s inDate=##class(web.DHCANOPCom).ConvertToDateH(inDate)
    s inTime=##class(web.DHCANOPCom).ConvertToTimeH(inTime)
    
    //手术开始时间调整
    s curDate=+$h,curTime=$p($h,",",2)
    s secDiff=(inDate-curDate)*86400+inTime-curTime
    i secDiff>0 d       //晚于的日期归当天，时间晚于系统时间的，取系统日期和时间，否则取当天
        .s inDate=curDate
        .i inTime>curTime s inTime=curTime
    i secDiff<-86400 d  //早于多于一天的，不变时间，改日期
        .s inDate=curDate
        .i inTime>curTime s inDate=curDate-1

    //w inDate_" "_inTime
    s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
    //I为入室，R为准备，P为恢复室，L离室
    q:(accessType="AN")&("IRPL"'[opaStatus) "手术状态不对!"
    q:(accessType="PACU")&("PL"'[opaStatus) "手术状态不对!"
    
    s roomId=$p($g(^DHCANOPArrange(opaId)),"^",20)
    q:+roomId=0 -2 ;"未定义房间!"
    s pacuRoomId=""
    i accessType="PACU" s pacuRoomId=$p($g(^DHCANOPArrange(opaId)),"^",47)
    q:(accessType="PACU")&(pacuRoomId="") "未指定病人恢复床!"
    s retStr=0
    i (accessType="AN")&($d(^DHCANOPArrange(0,"RoomStatus",roomId,"I"))>0) d
        .s inroomOpaId=$o(^DHCANOPArrange(0,"RoomStatus",roomId,"I",""))
        .i inroomOpaId'=opaId d
            ..s retStr=..AutoTerminal(inroomOpaId)
    q:retStr'=0 retStr
    i opaStatus="P" d //恢复室返回，当前病人不在恢复室监护
        .i (accessType="AN") d
            ..i $p($g(^DHCANOPArrange(opaId,"PACU")),"^",6)'="" s retStr="病人已在恢复室!" //已入恢复室可手工修改
    q:retStr'=0 retStr //手工修改
    
    i opaStatus="L" d //术毕可重返
        .i (accessType="PACU") d
            ..s tmpRoomId=0
            ..f  s tmpRoomId=$o(^DHCANOPArrange(0,"RoomStatus",tmpRoomId)) q:tmpRoomId=""  d
                ...s pacuOpaId=0
                ...f  s pacuOpaId=$o(^DHCANOPArrange(0,"RoomStatus",tmpRoomId,"P",pacuOpaId)) q:pacuOpaId=""  d
                    ....q:pacuRoomId'=$p($g(^DHCANOPArrange(pacuOpaId)),"^",47) //不是当前恢复床是可重启状态
                    ....i $p($g(^DHCANOPArrange(pacuOpaId,"PACU")),"^",6)'="" s retStr="恢复床已有新病人在监护!"
    q:retStr'=0 retStr
        
    s anpId=..GetAnpId(opaId)
    s interval=$p($g(^DHCANPara(anpId)),"^",2) //取得数据采样间隔时间，已经不再使用了
    s interval="" ///get from roomequip
    ////q:interval<5 -1 ;"采样间隔时间太小!"
    s retStr=..StartEquipCollect(opaId, isSet, interval, accessType)
    //i retStr=0 d
    i "LPR"[$p(^DHCANOPArrange(opaId),"^",27) d
        .i (accessType="AN") &sql(update DHC_AN_OPArrange set OPA_Status='I' where OPA_RowId=:opaId)
        .q:"PR"[$p(^DHCANOPArrange(opaId),"^",27)
        .i (accessType="PACU") &sql(update DHC_AN_OPArrange set OPA_Status='P' where OPA_RowId=:opaId)
    //q:'isSet retStr
    //如果设备启动成功，且为点击开始按钮进入，写入室时间
    //i retStr=0 d
    i isSet d
        .i (accessType="AN") d
            ..s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
            ..s $p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",39)=inDate //ANA_TheatreInDate
            ..s $p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",40)=inTime //ANA_TheatreInTime
        .i (accessType="PACU") d
            ..s $p(^DHCANOPArrange(pacuOpaId,"PACU"),"^",6)=inDate
            ..s $p(^DHCANOPArrange(pacuOpaId,"PACU"),"^",7)=inTime
        .//&sql(update DHC_AN_OPArrange set OPA_Status='I' where OPA_RowId=:opaId)  //还有P状态
    //返回状态，如果设备启动失败即刻返回
    q retStr
}

ClassMethod SetPACUTheatreInTime(opaId As %String, dateTimeStr As %String) As %String
{
    q:opaId="" "排班号ID错!"
    s opaPACUInDate=##class(web.DHCANOPCom).ConvertToDateH($p(dateTimeStr,"^",1),"")
    s opaPACUInTime=##class(web.DHCANOPCom).ConvertToTimeH($p(dateTimeStr,"^",2),"")
    i opaPACUInDate'="" s $p(^DHCANOPArrange(opaId,"PACU"),"^",6)=opaPACUInDate
    i opaPACUInTime'="" s $p(^DHCANOPArrange(opaId,"PACU"),"^",7)=opaPACUInTime
    &sql(update DHC_AN_OPArrange set OPA_Status='P' where OPA_RowId=:opaId)
    q 0
}

ClassMethod SetPACUTheatreOutTime(opaId As %String, dateTimeStr As %String) As %String
{
    q:opaId="" "排班号ID错!"
    s opaPACUOutDate=##class(web.DHCANOPCom).ConvertToDateH($p(dateTimeStr,"^",1),"")
    s opaPACUOutTime=##class(web.DHCANOPCom).ConvertToTimeH($p(dateTimeStr,"^",2),"")
    i opaPACUOutDate'="" s $p(^DHCANOPArrange(opaId,"PACU"),"^",8)=opaPACUOutDate
    i opaPACUOutTime'="" s $p(^DHCANOPArrange(opaId,"PACU"),"^",9)=opaPACUOutTime
    &sql(update DHC_AN_OPArrange set OPA_Status='L' where OPA_RowId=:opaId)
    q 0
}

/// d ##class(web.DHCANCom).StartEquipCollect(69,1,"","PACU")
ClassMethod StartEquipCollect(opaId As %String, isSet As %String = "1", interval As %String = "", accessType = "AN") As %String
{
     q ##class(web.DHCANDeviceTask).ExcuteByOpaId(opaId)
}

/// w ##class(web.DHCANCom).SetOutDateTime(85,"2017/6/28","10:30:00","AN")
ClassMethod SetOutDateTime(opaId As %String, outDate As %String, outTime As %String, accessType = "AN") As %String
{
    q:(+opaId=0) -1
    s outDate=##class(web.DHCANOPCom).ConvertToDateH(outDate)
    s outTime=##class(web.DHCANOPCom).ConvertToTimeH(outTime)
    
    s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
    q:(accessType="AN")&("IPL"'[opaStatus) "手术状态不对!"
    q:(accessType="PACU")&("PL"'[opaStatus) "手术状态不对!"
    //q:opaStatus="L" 0 //修改手术状态，不改结束时间，可能不太灵活
    s anoStr=..GetAncoByCode(opaId,"TheatreOut","E")
    s retStr=..StopEquipCollect(opaId, accessType) //防止设备服务异常时，手术状态不能改。
    s newOpaStatus="L"
    i $p(anoStr,"^",10)="PACU" s newOpaStatus="P"
    i (accessType="PACU") s newOpaStatus="L"
    //&sql(update DHC_AN_OPArrange set OPA_Status=:newOpaStatus where OPA_RowId=:opaId)
    i (opaStatus'="")&(newOpaStatus'="") d
        .s $p(^DHCANOPArrange(opaId),"^",27)=newOpaStatus
        .s oprId=$p($g(^DHCANOPArrange(opaId)),"^",20)
        .i (oprId'="") d
            ..k ^DHCANOPArrange(0,"RoomStatus",oprId,opaStatus,opaId)
            ..s ^DHCANOPArrange(0,"RoomStatus",oprId,newOpaStatus,opaId)=""
    i accessType="AN" d
        .s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
        .//s $p(^DHCANOPArrange(opaId),"^",27)="L"
        .s startDate=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",39)
        .s startTime=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",40)
        .i outDate<startDate d
            ..s outDate=startDate
        .i outDate=startDate d
            ..i outTime<startTime s outDate=outDate+1
        .i outDate>$h d
            ..s maxDateTimeStr=..GetAnoMaxDateTime(opaId)
            ..s outDate=$p(maxDateTimeStr,"^",1)
            ..s outTime=$p(maxDateTimeStr,"^",2)
        .s $p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",41)=outDate //ANA_TheatreOutDate
        .s $p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",42)=outTime //ANA_TheatreOutTime
    i (accessType="PACU")!(opaStatus="P") d
        .s $p(^DHCANOPArrange(opaId,"PACU"),"^",8)=outDate
        .s $p(^DHCANOPArrange(opaId,"PACU"),"^",9)=outTime

    
    q retStr
}

ClassMethod GetAnoMaxDateTime(opaId As %String) As %String
{
    s anoId="",maxDate=1,maxTime=0
    f  s anoId=$o(^DHCANOrder(0,"OPApp",opaId,anoId),-1) q:(anoId="")  d
        .q:'$d(^DHCANOrder(anoId))
        .s curDate=$p(^DHCANOrder(anoId),"^",7) //anoEndDate
        .i curDate="" s curDate=$p(^DHCANOrder(anoId),"^",5) //anoStartDate
        .q:curDate<maxDate
        .s curTime=$p(^DHCANOrder(anoId),"^",8) //anoEndTime
        .i curTime="" s curTime=$p(^DHCANOrder(anoId),"^",6) //anoStartTime
        .q:(curDate=maxDate)&(curTime<maxTime)
        .s anoEditFlag=$p(^DHCANOrder(anoId),"^",25)
        .q:"NE"'[anoEditFlag //不考虑不显示的
        .s maxDate=curDate,maxTime=curTime
     q maxDate_"^"_maxTime
}

ClassMethod GetAncoByCode(opaId, ancoCode, typeCode, accessType = "AN") As %String
{
    q:ancoCode="" ""
    q:typeCode="" ""
    s ancoId=""
    s ancoId=$o(^DHCANC("ComOrd",0,"TypeCode",typeCode,ancoCode,""))
    q:ancoId="" ""
    s anoId="",isFind=0,anoStr=""
    f  s anoId=$o(^DHCANOrder(0,"CommOrd",ancoId,opaId,anoId),-1) q:(anoId="")!(isFind)  d
        .q:'$d(^DHCANOrder(ancoId))
        .q:"NE"'[$p(^DHCANOrder(+anoId),"^",25)
        .s anoStr=^DHCANOrder(anoId)
        .s isFind=1
        .//w anoId,!
    q anoStr
}

ClassMethod StopEquipCollect(opaId As %String, accessType = "AN") As %String
{
	q ##class(web.DHCANDeviceTask).ExcuteByOpaId(opaId,"StopEq")
}

ClassMethod InsertAnOrder(opaId As %String, userId As %String, locId As %String, docUserId As %String) As %String
{
    q:(+opaId=0) -1
    s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
    s inDate=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",39)
    s inTime=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",40)
    s outDate=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",41)
    s outTime=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",42)
    s anoId=0,resStr=-2
    f  s anoId=$o(^DHCANOrder(0,"OPApp",opaId,anoId)) q:anoId=""  d
        .s anoEditFlag=$p(^DHCANOrder(anoId),"^",25)
        .q:((anoEditFlag'="N")&(anoEditFlag'="E")) //只写正常和修改的
        .s anoUpdateDate=$p(^DHCANOrder(anoId),"^",21)
        .s anoUpdateTime=$p(^DHCANOrder(anoId),"^",22)
        .q:(anoUpdateDate<inDate)!((anoUpdateDate=inDate)&(anoUpdateTime<inTime))
        .;q:(anoUpdateDate>outDate)!((anoUpdateDate=outDate)&(anoUpdateTime<outTime)) //??离室后的允许插入?
        .//admId,arcim^qty^recloc^price^specimen^admreason
        .s oriStr=$p(^DHCANOrder(anoId),"^",9)_"^"_$p(^DHCANOrder(anoId),"^",11)_"^"_$p(^DHCANOrder(anoId),"^",26)_"^^"
        .//Adm,OrdItemStr,User,Loc,LABDATA,DocUserId
        .s resStr=##class(web.DHCOPCashier).CashierInsertOrdItem(+anaId,oriStr,userId,locId,docUserId)
        .
        .//w oriStr_"/"_resStr,!
    q resStr
}

ClassMethod GetPatInfo(opaId As %String) As %String
{
    q:(+opaId=0) ""
    s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
    s papmiId=+^PAADM(+anaId)
    s regNo=$p(^PAPER(papmiId,"PAT",1),"^",1)
    s patName=$p(^PAPER(papmiId,"ALL"),"^",1)
    s inDate=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",39)
    s inTime=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",40)
    s outDate=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",41)
    s outTime=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",42)

    q "病人姓名:"_patName_" 登记号:"_regNo
}

ClassMethod GetInOutDateTime(opaId As %String) As %String
{
    q:(+opaId=0) $zd(+$h,3)_"^"_$zt($p($h,",",2))_"^"_$zd(+$h,3)_"^"_$zt($p($h,",",2))_"^^^^"
    s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
    s resStr=$zd($p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",39),3)
    s $p(resStr,"^",2)=$zt($p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",40))
    i $p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",39)="" s $p(resStr,"^",1,2)="^"
    s $p(resStr,"^",3)=$zd($p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",41),3)
    s $p(resStr,"^",4)=$zt($p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",42))
    i $p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",41)="" s $p(resStr,"^",3,4)="^"
    i $p(^DHCANOPArrange(opaId),"^",27)="P",$p($g(^DHCANOPArrange(opaId,"PACU")),"^",6)="" d
        .s $p(^DHCANOPArrange(opaId,"PACU"),"^",6)=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",39)
        .s $p(^DHCANOPArrange(opaId,"PACU"),"^",7)=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",40)
    s $p(resStr,"^",5)=$zd($p($g(^DHCANOPArrange(opaId,"PACU")),"^",6),3)
    s $p(resStr,"^",6)=$zt($p($g(^DHCANOPArrange(opaId,"PACU")),"^",7))
    s $p(resStr,"^",7)=$zd($p($g(^DHCANOPArrange(opaId,"PACU")),"^",8),3)
    s $p(resStr,"^",8)=$zt($p($g(^DHCANOPArrange(opaId,"PACU")),"^",9))
    i $p($g(^DHCANOPArrange(opaId,"PACU")),"^",6)="" s $p(resStr,"^",5,8)="^^^"
    i $p($g(^DHCANOPArrange(opaId,"PACU")),"^",8)="" s $p(resStr,"^",7,8)="^"
    q resStr
}

ClassMethod GetAllIcon() As %String
{
 s i=0,retStr=-1
 f  s i=$o(^DHCANC("Icon",i)) q:i=""  d
     .i +^DHCANC("Icon",i)>100 q
     .i retStr'=-1 s retStr=retStr_"!"_i_"^"_^DHCANC("Icon",i)
     .i retStr=-1 s retStr=i_"^"_^DHCANC("Icon",i)
 q retStr
}

Query FindASAClass() As %SQLQuery(CONTAINID = 1)
{
    select %ID As Id,
           ORASA_Code As Code,
           ORASA_Desc As Description
           From SQLUser.ORC_ASA_ClassPhActiv
}

Query FindOperPosition() As %SQLQuery(CONTAINID = 1)
{
    select %ID As Id,
           OPPOS_Code As Code,
           OPPOS_Desc As Description
           From SQLUser.ORC_OperPosition
}

Query FindIcons() As %SQLQuery(CONTAINID = 1)
{
    select %ID As Id,
           ANI_Code As Code,
           ANI_Desc As Description,
           ANI_Count As PointCount,
           ANI_Height As Height,
           ANI_Width As Width,
           ANI_PositionX As PositionX,
           ANI_PositionY As PositionY,
           ANI_LineWidth As LineWidth,
           ANI_Shape As Shape,
           ANI_Data As Data
           From SQLUser.DHC_ANC_Icon
}

ClassMethod FormatDuration(intervalSec, dayExpress) As %String
{
    //dayExpress不为空，显示的是日期的显示单位及间隔符，为空显示小时数，不显示天数
    i intervalSec<0.0001 q ""
    s intervalDay=$p((intervalSec/86400),".")
    w intervalSec,!
    
    i +intervalDay=0 s intervalDay=""
    s formatTime=$zt((intervalSec-(86400*intervalDay)),2)
    i intervalDay'="" d
        .i dayExpress="" d
            ..s $p(formatTime,":")=intervalDay*24+formatTime
            ..s intervalDay=""
        .s intervalDay=intervalDay_dayExpress
    q intervalDay_formatTime
}

/// Creator：        ypz
/// CreatDate：      2010-09-06
/// Description：    取排班、麻醉、手术信息
/// Table：          DHC_AN_OPArrange,OR_Anaesthesia,OR_Anaest_Operation
/// Input：          排班ID
/// Output：       
/// Return：         返回""无数据。返回数据分两级，第一级"^"，分别是病人、排班、麻醉、手术、其它信息、附加手术信息。
///                     第二级$c(3)，附加手术有第三级$c(4)
///                     regNo_$c(3)_ctlocDesc_$c(3)_roomDesc_$c(3)_sex_$c(3)_patName_$c(3)_safetyNetCardNo_"^"_bedCode_"^"_age_"^"_wardDesc
///                     "^"_opaPatHeight_$c(3)_opaPatWeight_$c(3)_opaPreAnDrug_$c(3)_ancefId_$c(3)_ancefDesc_$c(3)_opaOpDocNote_$c(3)_opaAnDocNote_$c(3)_planAnmetId_$c(3)_planAnmetDesc_$c(3)_opaStartDate
///                         _$c(3)_opaStartTime_$c(3)_opaEndDate_$c(3)_opaEndTime
///                     "^"_anCtcpId_$c(3)_anaesthetist_$c(3)_anmetId_$c(3)_anmetDesc_$c(3)_orAsaId_$c(3)_orAsaDesc_$c(3)_inrouId_$c(3)_inrouDesc_$c(3)_anaCuffIntubTube_$c(3)_cuffIntubTube
///                        _$c(3)_orintId_$c(3)_orintDesc_$c(3)_anaDuration_$c(3)_/*anAssIdStr_$c(3)_anAssStr*/_$c(3)_anSuperId_$c(3)_anSuperDesc_$c(3)_anaTheatreInDate_$c(3)_anaTheatreInTime_$c(3)_anaTheatreOutDate
///                            _$c(3)_anaTheatreOutTime_$c(3)_anaSourceType
///                     "^"_surgId_$c(3)_surgDesc_$c(3)_operId_$c(3)_operDesc_$c(3)_preMrcidId_$c(3)_preMrcidDesc_$c(3)_postMrcidId_$c(3)_postMrcidDesc_$c(3)_opposId_$c(3)_opposDesc
///                        _$c(3)_opDuration_$c(3)_assIdStr_$c(3)_assSurgStr_$c(3)_anAssIdStr_$c(3)_anAssStr_$c(3)_opscnIdStr_$c(3)_opscnStr_$c(3)_cirnIdStr_$c(3)_cirnStr_$c(3)_planOperId_$c(3)_planOperDesc
///                     "^"_aniIntrathPuncSite_$c(3)_Desc_$c(3)_aniIntubationDepth_$c(3)_Desc_$c(3)_aniIntrathCathLen_$c(3)_Desc_$c(3)_aniIntrathPuncBleedAmt_$c(3)_Desc_$c(3,2)
///                        _aniIntrathPuncResiste_$c(3)_Desc_$c(3)_aniIntrathPuncNegCompe_$c(3)_Desc_$c(3)_aniIntrathPuncDiffFeel_$c(3)_Desc
///                     "^"_attAnaopSub_$c(4)_anaopOperType_$c(4)_attOperId_$c(4)_attOperDesc_$c(4)_attAnaopNotes_$c(4)_attPlanOperId_$c(4)_attPlanOperDesc_$c(3)_....
/// w ##Class(web.DHCANCom).GetAnaInfo("71")
ClassMethod GetAnaInfo(opaId As %String) As %String
{
    q:(+opaId=0) ""
    s anaId=$p($g(^DHCANOPArrange(opaId)),"^",2) //OPA_Anaest_dr
    q:anaId="" ""
    s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    
    s opaAppDate=$P(^DHCANOPArrange(opaId),"^",3)
    s opaAppTime=$P(^DHCANOPArrange(opaId),"^",5)
    s orderAuditStatus=$P(^DHCANOPArrange(opaId),"^",48)
    //s patInfo=##class(web.DHCANOPCom).PatInfo("^"_EpisodeID,"",opaAppDate,opaAppTime)
    s patInfo=##class(web.DHCANOPCom).PatInfo("^"_EpisodeID,"")
    s patInfo=$tr(patInfo,"^",$c(3)) //$p(patInfo,"^",1,9) //regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"岁^"_$g(wardDesc)
    
    s applocId=$p(^DHCANOPArrange(opaId),"^",54)
    i applocId="" s applocId=$p(^PAADM(+EpisodeID),"^",4)
    s applocDesc=$p(^CTLOC(+applocId),"^",2)    
    i $p(applocDesc,"-",2)'="" s applocDesc=$p(applocDesc,"-",2)
    //s patInfo=patInfo_$c(3)_applocDesc

    s preDrug=$p(^DHCANOPArrange(opaId),"^",29) //13
    s preDrug=$tr(preDrug,"ML","ml")
    s preDrug=$tr(preDrug,"MG","mg")
    s ancefId=$p(^DHCANOPArrange(opaId),"^",12)
    s ancefDesc=$p($g(^DHCANC("ANEffect",+ancefId)),"^",2) //21
    s opaOpDocNote=$p($g(^DHCANOPArrange(opaId)),"^",42)
    s opaStartDate=##class(web.DHCANOPCom).ConvertToDate($P(^DHCANOPArrange(opaId),"^",14),"")
    s opaStartTime=##class(web.DHCANOPCom).ConvertToTime($P(^DHCANOPArrange(opaId),"^",15),"")
    s opaEndDate=##class(web.DHCANOPCom).ConvertToDate($P(^DHCANOPArrange(opaId),"^",16),"")
    s opaEndTime=##class(web.DHCANOPCom).ConvertToTime($P(^DHCANOPArrange(opaId),"^",17),"")
    
    s anaesthetist=""
    s anCtcpId=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)        ; ANA_Anaesthetist_Dr 
    i anCtcpId'="" s anaesthetist=##class(web.DHCANOPCom).GetNameById(anCtcpId) ;麻醉医师 /12
    s anmetId=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)        ;ANA_Method /13
    s anmetDesc=##class(web.DHCANOPCom).GetAnMethodDescById(anmetId,"+")
    s tracheaCannulaInfo=""
    s methodInfoCode=""
    s sub=""
    i $d(^OR(EpisodeID,"ANA",anaSub,"MethodInfo"))  d
    .s anmethodCount=$l(anmetId,"|")
    .f i=1:1:anmethodCount  d
    ..s anmethodId=$P(anmetId,"|",i)
    ..q:(anmethodId="")
    ..f  s sub=$o(^OR(EpisodeID,"ANA",anaSub,"MethodInfo",anmethodId,sub)) q:(sub="")  d
    ...f  s methodInfoCode=$o(^OR(EpisodeID,"ANA",anaSub,"MethodInfo",anmethodId,sub,methodInfoCode)) q:(methodInfoCode="")  d
    ....s methodInfoDesc=$p(^OR(EpisodeID,"ANA",anaSub,"MethodInfo",anmethodId,sub,methodInfoCode),"^",1)
    ....s methodInfoValue=$p(^OR(EpisodeID,"ANA",anaSub,"MethodInfo",anmethodId,sub,methodInfoCode),"^",2)
    ....i tracheaCannulaInfo'="" s tracheaCannulaInfo=tracheaCannulaInfo_$c(1)
    ....s tracheaCannulaInfo=tracheaCannulaInfo_methodInfoCode_":"_methodInfoDesc_":"_methodInfoValue_":"_anmethodId
    
    s orAsaId="",orAsaDesc=""
 	//s orAsaId=$P(^OR(EpisodeID,"ANA",anaSub),"^",26)
 	//s orAsaDesc=$p($g(^ORC("ASA",+orAsaId)),"^",2)  //12  //为配合pad版术前访视,ASA分级存取自扩展表数据 YuanLin 20171221
 	
    s inrouId=$P(^OR(EpisodeID,"ANA",anaSub),"^",16)
    s inrouDesc=$p($g(^ORC("INROU",+inrouId)),"^",2) //ANA_IntubRoute_DR插管通道16 /24
    s cuffIntubTube=""
    s anaCuffIntubTube=$P(^OR(EpisodeID,"ANA",anaSub),"^",22)
    i anaCuffIntubTube="Y" s cuffIntubTube="套囊"
    s orintId=$P(^OR(EpisodeID,"ANA",anaSub),"^",21)
    s orintDesc=$p($g(^ORC("INTS",+orintId)),"^",2) //ANA_IntSize_DR   插管尺寸29  /22
    //s ingraId=$P(^OR(EpisodeID,"ANA",anaSub),"^",17)
    //s ingraDesc=$p($g(^ORC("INGRA",+ingraId)),"^",2) //ANA_IntubGrade_DR插管级别17 /23
    s anaEndDate=$p(^OR(EpisodeID,"ANA",anaSub),"^",29)
    s anaEndTime=$p(^OR(EpisodeID,"ANA",anaSub),"^",4)
    /*i anaDuration<0 s anaDuration=""
    e  d
        .s anDurtDay=$p((anaDuration/86400),".")
        .i +anDurtDay=0 s anDurtDay=""
        .i anDurtDay'="" s anDurtDay=anDurtDay_"d "
        .s anaDuration=anaDuration-(86400*anDurtDay)
        .s anaDuration=anDurtDay_$zt(anaDuration,2)*/
    s anaSourceType=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)
    i anaSourceType="B" s anaSourceType="择期"
    i anaSourceType="E" s anaSourceType="急诊"
    s surgId="",operId="",preMrcidId="",postMrcidId="",opposId="",planOperId="",planOperDesc=""
    s assId="",assSurgStr="",assIdStr="",opscnIdStr="",opscnStr="",cirnIdStr="",cirnStr=""
    s surgDesc="",operDesc="",preMrcidDesc="",postMrcidDesc="",opposDesc="",opDuration=""
    s anAssIdStr="",anAssStr=""
    s anaTheatreInDate="",anaTheatreInTime="",anaTheatreOutDate="",anaTheatreOutTime=""
    s anSuperId=$p(^OR(EpisodeID,"ANA",anaSub),"^",7)               //麻醉指导医生Id
    s anSuperDesc=##class(web.DHCANOPCom).GetNameById(anSuperId)    //麻醉指导医生
    s anaopSub=0,attAnaopStr=""
    s anNurseId=$p(^OR(EpisodeID,"ANA",anaSub),"^",8)  //麻醉护士ID
    s anNurseDesc=##class(web.DHCANOPCom).GetNameById(anNurseId)  //麻醉护士
    s anaopSub=0,attAnaopStr="",anaTheatreInDate="",anaTheatreInTime="",anaTheatreOutDate="",anaTheatreOutTime=""
    s operName="",num="",di="",OperID="",planOperID="",planOperDesc=""
    f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
        .s curAnaopOperType=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)
        .s operId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6) ;重新梳理 YuanLin 实施手术 ANAOP_Type_DR 允许选择多条  20170717
        .s operNotes=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",1))   //手术备注
        .i operId'=""  d
        ..i OperID="" s OperID=operId
        ..e  s OperID=OperID_"|"_operId
        ..i operDesc'="" s operDesc=operDesc_"+"_$P(^ORC("OPER",+operId),"^",2)
        ..e  s operDesc=$P(^ORC("OPER",+operId),"^",2)
        ..i operNotes'="" s operDesc=operDesc_"("_operNotes_")"
        .e  d
        ..i operDesc'="" s operDesc=operDesc_"+"_$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2))
        ..e  s operDesc=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2))
        ..i operNotes'="" s operDesc=operDesc_"("_operNotes_")"
        .q:(operId="")&(operDesc="")
        .s planOperId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"DHC")),"^",2) ;拟施手术 DHC节点
        .//s planOperDesc=$P(^ORC("OPER",+planOperId),"^",2)
        .//i planOperDesc="",planOperId'="" s planOperDesc=planOperId,planOperId=""
        .q:planOperId=""
        .i (+planOperId>0) d														//yq 20190102 拟施手术名称重新取
        ..i planOperID="" s planOperID=planOperId
        ..e  s planOperID=planOperID_"|"_planOperId
        ..i planOperDesc'="" s planOperDesc=planOperDesc_"+"_$P(^ORC("OPER",+planOperId),"^",2)
        ..e  s planOperDesc=$P(^ORC("OPER",+planOperId),"^",2)
        .e  d
        ..i planOperDesc'="" s planOperDesc=planOperDesc_"+"_$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"DHC",5))
        ..e  s planOperDesc=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"DHC",5))
        .//i planOperDesc="",planOperId'="" s planOperDesc=planOperId,planOperId=""
		
		.i anaopSub>1 d
            ..i attAnaopStr'="" s attAnaopStr=attAnaopStr_$c(3)
            ..s attAnaopStr=attAnaopStr_anaopSub_$c(4)_curAnaopOperType_$c(4)_operId_$c(4)_operDesc_$c(4)_planOperId_$c(4)_planOperDesc
        .q:anaopSub>1 //第一条为主手术
        .s surgId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8)   ;ANAOP_Surgeon_DR  ；手术医师
        .s surgDesc=##class(web.DHCANOPCom).GetNameById(surgId)
        .i surgId="" s surgDesc=$p(opaOpDocNote,"|",2)
        .i (surgDesc="")  d
        ..s surgDesc=##class(web.DHCANOPData).GetSurgeonDescription(opaId)
        .s opasSub=0,assCount=0
        .f  s opasSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",opasSub)) q:opasSub=""  d
            ..s assId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",opasSub),"^")
            ..s assCtcp=##class(web.DHCANOPCom).GetNameById(assId)
            ..i (assCtcp="")&(assId'="") s assCtcp=assId
            ..i assCtcp="" s assCtcp=$p(opaOpDocNote,"|",(opasSub+2))
            ..//q:assId=""
            ..i assSurgStr'="" s assSurgStr=assSurgStr_",",assIdStr=assIdStr_","
            ..s assSurgStr=assSurgStr_assCtcp
            ..s assIdStr=assIdStr_assId
            ..s assCount=assCount+1
        .f i=(assCount+3):1:$l(opaOpDocNote,"|") d
            ..q:$p(opaOpDocNote,"|",i)=""
            ..i assSurgStr'="" s assSurgStr=assSurgStr_",",assIdStr=assIdStr_","
            ..s assIdStr=assIdStr_""
            ..s assSurgStr=assSurgStr_$p(opaOpDocNote,"|",i)
        .;i surgDesc="" s assSurgStr="",assIdStr=""
        .s anassSub=0 //麻醉助手
        .f  s anassSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub)) q:anassSub=""  d
            ..s anAssId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub),"^")
            ..q:anAssId=""
            ..i anAssIdStr'="" s anAssIdStr=anAssIdStr_",",anAssStr=anAssStr_","
            ..s anAssIdStr=anAssIdStr_anAssId
            ..s anAssStr=anAssStr_##class(web.DHCANOPCom).GetNameById(anAssId)
        .i anaesthetist="" s anAssIdStr="",anAssStr=""
        .s opscnIdStr="",opscnStr=""
        .s opscnSub=0 //器械护士
        .f  s opscnSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",opscnSub)) q:opscnSub=""  d
            ..s opscnId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",opscnSub),"^")
            ..q:opscnId=""
            ..i opscnIdStr'="" s opscnIdStr=opscnIdStr_",",opscnStr=opscnStr_","
            ..s opscnIdStr=opscnIdStr_opscnId
            ..s opscnStr=opscnStr_##class(web.DHCANOPCom).GetNameById(opscnId)
        .s cirnIdStr="",cirnStr=""
        .s cirnSub=0 //巡回护士
        .f  s cirnSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub)) q:cirnSub=""  d
            ..s cirnId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub),"^")
            ..q:cirnId=""
            ..i cirnIdStr'="" s cirnIdStr=cirnIdStr_",",cirnStr=cirnStr_","
            ..s cirnIdStr=cirnIdStr_cirnId
            ..s cirnStr=cirnStr_##class(web.DHCANOPCom).GetNameById(cirnId)
        .;以下术前诊断取多个,包括手填数据  YuanLin 20170711
        .s preMrcidId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",4)   ;ANAOP_PreopDiag_DR 术前诊断
        .s num=$l(preMrcidId,"|")
        .f di=1:1:num d
            ..s predigdr=$p(preMrcidId,"|",di)
            ..i predigdr'=""  d
                ...i preMrcidDesc'="" s preMrcidDesc=preMrcidDesc_";"_$P(^MRC("ID",predigdr),"^",2)
                ...e  s preMrcidDesc=$P(^MRC("ID",predigdr),"^",2)
            ..e  d
                ...i preMrcidDesc'="" s preMrcidDesc=preMrcidDesc_";"_$p($g(^OR(EpisodeID,"ANA",anaSub,"TXT",2)),";",di)
                ...e  s preMrcidDesc=$p($g(^OR(EpisodeID,"ANA",anaSub,"TXT",2)),";",di)
        .;以上
        .;以下术后诊断取多个,包括手填数据,如为空,按术前诊断走  YuanLin 20170711
        .s postMrcidId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",5)   ;ANAOP_PostDiag_DR 术后诊断
        .i postMrcidId="" s postMrcidId=preMrcidId
        .s num=$l(postMrcidId,"|")
        .f di=1:1:num d
            ..s postdigdr=$p(postMrcidId,"|",di)
            ..i postdigdr'=""  d
                ...i postMrcidDesc'="" s postMrcidDesc=postMrcidDesc_";"_$P(^MRC("ID",postdigdr),"^",2)
                ...e  s postMrcidDesc=$P(^MRC("ID",postdigdr),"^",2)
            ..e  d
                ...i postMrcidDesc'="" s postMrcidDesc=postMrcidDesc_";"_$p($g(^OR(EpisodeID,"ANA",anaSub,"TXT",3)),";",di)
                ...e  s postMrcidDesc=$p($g(^OR(EpisodeID,"ANA",anaSub,"TXT",3)),";",di)
        .;以上
        .s opposSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"POS",0)) //体位多个?
        .s opposId=+$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"POS",+opposSub))
        .s opposDesc=$p($g(^ORC("OPPOS",opposId)),"^",2)
        .s opDuration=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",16)-$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",13)
        .s opDuration=opDuration*86400+$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",3)-$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",2)
        .s opDuration=..FormatDuration(opDuration,"") //"d "
        .i anaEndDate="" d
            ..s anaEndDate=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",16)
            ..s anaEndTime=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",3)
        .
        .s anaTheatreInDate=##class(web.DHCANOPCom).ConvertToDate($p(^OR(+anaId,"ANA",anaSub),"^",39),"")
        .s anaTheatreInTime=##class(web.DHCANOPCom).ConvertToTime($p(^OR(+anaId,"ANA",anaSub),"^",40),"")
        .s anaTheatreOutDate=##class(web.DHCANOPCom).ConvertToDate($p(^OR(+anaId,"ANA",anaSub),"^",41),"")
        .s anaTheatreOutTime=##class(web.DHCANOPCom).ConvertToTime($p(^OR(+anaId,"ANA",anaSub),"^",42),"")
        .i anaTheatreInDate="" s anaTheatreInTime="",anaTheatreOutDate=""
        .i anaTheatreOutDate="" s anaTheatreOutTime=""
        .//i opDuration<0 s opDuration="" q
        .//s opDurtDay=$p((opDuration/86400),".")
        .//i +opDurtDay=0 s opDurtDay=""
        .//i opDurtDay'="" s opDurtDay=opDurtDay_"d "
        .//s opDuration=opDuration-(86400*opDurtDay)
        .//s opDuration=opDurtDay_$zt(opDuration,2)
    //s resStr=resStr_"^"_anaesthetist_"^"_anmetDesc_"^"_surgDesc_"^"_opName_"^"_prediag_"^"_postdiag_"^"_preDrug_"^"_opposDesc_"^"_ancefDesc //13-21
    s anaDuration=(anaEndDate-$p(^OR(EpisodeID,"ANA",anaSub),"^",2))*86400
    s anaDuration=anaDuration+anaEndTime-$p(^OR(EpisodeID,"ANA",anaSub),"^",3)
    s anaDuration=..FormatDuration(anaDuration,"") //"d "
    s operId=OperID
    //拟施麻醉为空时同步
    ;i $p($g(^DHCANOPArrange(opaId,"PA")),"^",89)="" d //OPA_PaAnaestType
        .//i anmetId'="" s $p(^DHCANOPArrange(opaId,"PA"),"^",89)=anmetId
        .//e  s $p(^DHCANOPArrange(opaId,"PA"),"^",89)=anmetDesc
    s planAnmetId=$p($g(^DHCANOPArrange(opaId,"PA")),"^",89)
    i planAnmetId'=$p(^OR(EpisodeID,"ANA",anaSub),"^",5) s planAnmetId=$p(^OR(EpisodeID,"ANA",anaSub),"^",5)  //ck 20131120
    s planAnmetDesc=##class(web.DHCANOPCom).GetAnMethodDescById(planAnmetId,"+")
     
    i $l(planAnmetId,"|")<2 s planAnmetId=+planAnmetId
    s planAnmetId="" //,anmetId=""
        s bloodTypeId=$p(^DHCANOPArrange(opaId),"^",11)
    s bloodTypeDesc=$p($g(^PAC("BLDT",+bloodTypeId)),"^",2)
    s RHBloodType=$p(^DHCANOPArrange(opaId),"^",25)
    //s resStr=resStr_"^"_orintDesc_"^"_ingraDesc_"^"_inrouDesc  //22-24
    /*  for data move
    s puncSiteStr=$g(^DHCANOPArrange(opaId,1))
    s $p(puncSiteStr,"^")=$p(puncSiteStr,"^")_$c(3)_$p(^DHCANC("PuncSite",+puncSiteStr),"^",2)
    s $p(puncSiteStr,"^",2)=$p(puncSiteStr,"^",2)_$c(3)_$p(^DHCANC("IntDepth",+$p(puncSiteStr,"^",2)),"^",2)
    s $p(puncSiteStr,"^",3)=$p(puncSiteStr,"^",3)_$c(3)_$p(^DHCANC("IntSetDepth",+$p(puncSiteStr,"^",3)),"^",2)
    s $p(puncSiteStr,"^",4)=$p(puncSiteStr,"^",4)_$c(3)_$p(^DHCANC("BleedingAmount",+$p(puncSiteStr,"^",4)),"^",2)
    f i=5:1:10 s $p(puncSiteStr,"^",i)=$c(3)
    f i=11:1:20 d
        .s $p(puncSiteStr,"^",i)=$p(puncSiteStr,"^",i)_$c(3)_$p(^DHCANC("PuncEffect",+$p(puncSiteStr,"^",i)),"^",2)
        .//w puncSiteStr,!
    */
    s aniIntrathPuncSite=$p($g(^DHCANOPArrange(opaId,"ANI",1)),"^",16)
    s aniIntubationDepth=$p($g(^DHCANOPArrange(opaId,"ANI",1)),"^",81)
    s aniIntrathCathLen=$p($g(^DHCANOPArrange(opaId,"ANI",1)),"^",31)
    s aniIntrathPuncBleedAmt=$p($g(^DHCANOPArrange(opaId,"ANI",1)),"^",23)
    s aniIntrathPuncResist=$p($g(^DHCANOPArrange(opaId,"ANI",1)),"^",20)
    s aniIntrathPuncNegComp=$p($g(^DHCANOPArrange(opaId,"ANI",1)),"^",21)
    s aniIntrathPuncDiffFeel=$p($g(^DHCANOPArrange(opaId,"ANI",1)),"^",22)
    s $p(puncSiteStr,"^",1)=aniIntrathPuncSite_$c(3)_$p($g(^DHCANC("PuncSite",+aniIntrathPuncSite)),"^",2)
    s $p(puncSiteStr,"^",2)=aniIntubationDepth_$c(3)_$p($g(^DHCANC("IntDepth",+aniIntubationDepth)),"^",2)
    s $p(puncSiteStr,"^",3)=aniIntrathCathLen_$c(3)_$p($g(^DHCANC("IntSetDepth",+aniIntrathCathLen)),"^",2)
    s $p(puncSiteStr,"^",4)=aniIntrathPuncBleedAmt_$c(3)_$p($g(^DHCANC("BleedingAmount",+aniIntrathPuncBleedAmt)),"^",2)
    f i=5:1:10 s $p(puncSiteStr,"^",i)=$c(3)
    s $p(puncSiteStr,"^",11)=aniIntrathPuncResist_$c(3)_$p($g(^DHCANC("PuncEffect",+aniIntrathPuncResist)),"^",2)
    s $p(puncSiteStr,"^",12)=aniIntrathPuncNegComp_$c(3)_$p($g(^DHCANC("PuncEffect",+aniIntrathPuncNegComp)),"^",2)
    s $p(puncSiteStr,"^",13)=aniIntrathPuncDiffFeel_$c(3)_$p($g(^DHCANC("PuncEffect",+aniIntrathPuncDiffFeel)),"^",2)
    s puncSiteStr=$tr(puncSiteStr,"^",$c(3))
    s ansStr=""
    s ansSub=0,quitFlag=0
    f  s ansSub=$o(^DHCANOPArrange(opaId,"Shift",ansSub)) q:(ansSub="")!(quitFlag)  d
        .i $p(^DHCANOPArrange(opaId,"Shift",ansSub),"^",1)="TI" d
            ..s ansStr=^DHCANOPArrange(opaId,"Shift",ansSub),quitFlag=1
    i ansStr="" s $p(ansStr,$c(3),39)=$p(ansStr,$c(3),39)
    s ansStr=$tr(ansStr,"^",$c(3))
    
    s aniStr=""
    s aniSub=0,quitFlag=0
    f  s aniSub=$o(^DHCANOPArrange(opaId,"ANI",aniSub)) q:(aniSub="")!(quitFlag)  d
        .s aniStr=$tr(^DHCANOPArrange(opaId,"ANI",aniSub),"^",$c(3)),quitFlag=1
    s patTransferTo=$p(aniStr,$c(3),101)
    s analgesia=$p(^DHCANOPArrange(opaId),"^",66)
    s analgesiaScore=$p(^DHCANOPArrange(opaId),"^",68)
    
    s inOutStr="",singleInOutStr="",inOutId=""
    f  s inOutId=$o(^DHCANOPArrange(opaId,"InOut",inOutId)) q:(inOutId="")  d
    .s inOutCode=$p(^DHCANOPArrange(opaId,"InOut",inOutId),"^",1)
    .s inOutDesc=$p(^DHCANOPArrange(opaId,"InOut",inOutId),"^",2)
    .s inOutValue=$p(^DHCANOPArrange(opaId,"InOut",inOutId),"^",3)
    .s inOutType=$p(^DHCANOPArrange(opaId,"InOut",inOutId),"^",4)
    .s singleInOutStr=inOutCode_"#"_inOutDesc_"#"_inOutValue_"#"_inOutType
    .i inOutStr'="" s inOutStr=inOutStr_$c(3)
    .s inOutStr=inOutStr_singleInOutStr
    
    s inAreaTemper=$p(^DHCANOPArrange(opaId),"^",81)
    s inAreaPulse=$p(^DHCANOPArrange(opaId),"^",84)
    s inAreaResp=$p(^DHCANOPArrange(opaId),"^",85)
    s inAreaSystolic=$p(^DHCANOPArrange(opaId),"^",82)
    s inAreaDiastolic=$p(^DHCANOPArrange(opaId),"^",83)
    s inAreaSPO2=$p(^DHCANOPArrange(opaId),"^",86)
    s inAreaWeight=$p(^DHCANOPArrange(opaId),"^",24)
    s inAreaHeight=$p(^DHCANOPArrange(opaId),"^",22)
    i (inAreaHeight="0") s inAreaHeight=""
    
    s inAreaVitalSignStr=inAreaTemper_$c(3)_inAreaPulse_$c(3)_inAreaResp_$c(3)_inAreaSystolic_$c(3)_inAreaDiastolic_$c(3)_inAreaWeight_$c(3)_inAreaHeight_$c(3)_inAreaSPO2
    
    //术前访视信息
    s complaints=$p($g(^DHCANOPArrange(opaId,"PA")),"^",106)
    s preOPOtherInfo=$p($g(^DHCANOPArrange(opaId,"PA")),"^",107)
    s preOPTemper=$p($g(^DHCANOPArrange(opaId,"PA")),"^",60)
    s preOPPluse=$p($g(^DHCANOPArrange(opaId,"PA")),"^",59)
    s preOPResp=$p($g(^DHCANOPArrange(opaId,"PA")),"^",63)
    s preOPSystolic=$p($g(^DHCANOPArrange(opaId,"PA")),"^",61)
    s preOPDiastolic=$p($g(^DHCANOPArrange(opaId,"PA")),"^",62)
    s preOPHB=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",5)
    s preOPHCT=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",6)
    s preOPWBC=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",3)
    s preOPPLT=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",7)
    s preOPALT=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",8)
    s preOPBUN=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",16)
    s preOPCR=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",15)
    s preOPGLU=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",14)
    s preOPK=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",25)
    s preOPNa=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",26)
    s preOPCl=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",28)
    s preOPPT=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",37)
    s preOPAPTT=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",41)
    s preOPPaO2=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",52)
    
    //start 添加湘雅医院HIS信息，病人ID
    s oaRowId=$o(^DHCENSOA("0","Paadm",+EpisodeID,""))
    s otherHisPatientId=$p($g(^DHCENSOA(+oaRowId)),"^",4)
    s otherHisVisitId=$p($g(^DHCENSOA(+oaRowId)),"^",5)
    //s resStr=resStr_"^"_otherHisPatientId_$c(3)_otherHisVisitId
    
    //新加恢复室床号 YuanLin  20170711
    s tPacuBed=""
    s tPacuBedId=$P($G(^DHCANOPArrange(opaId)),"^",47)          //OPA_PacuBed_Dr    麻醉恢复床
    i tPacuBedId'="" s tPacuBed=$p(^DHCANC("OPRoom",tPacuBedId),"^",2)
    e  s tPacuBed=""
    
    s preAnaVisitInfo=complaints_$c(3)_preOPOtherInfo_$c(3)_preOPTemper_$c(3)_preOPPluse_$c(3)_preOPResp_$c(3)_preOPSystolic_$c(3)_preOPDiastolic_$c(3)_preOPHB_$c(3)_preOPHCT_$c(3)_preOPWBC_$c(3)_preOPPLT_$c(3)_preOPALT_$c(3)_preOPBUN_$c(3)_preOPCR_$c(3)_preOPGLU_$c(3)_preOPK_$c(3)_preOPNa_$c(3)_preOPCl_$c(3)_preOPPT_$c(3)_preOPAPTT_$c(3)_preOPPaO2
    //病人、排班、麻醉、手术、术毕、附加手术、交班、麻醉记录信息
    s resStr=patInfo_$c(3)_otherHisPatientId_$c(3)_otherHisVisitId
    s resStr=resStr_"^"_$p($g(^DHCANOPArrange(opaId)),"^",22)_$c(3)_$p($g(^DHCANOPArrange(opaId)),"^",24)_$c(3)_preDrug_$c(3)_ancefId_$c(3)_ancefDesc_$c(3)_$p(opaOpDocNote,"|")_$c(3)_$p($g(^DHCANOPArrange(opaId)),"^",43)_$c(3)_planAnmetId_$c(3)_planAnmetDesc_$c(3)_opaStartDate_$c(3)_opaStartTime_$c(3)_opaEndDate_$c(3)_opaEndTime_$c(3)_applocDesc_$c(3)_bloodTypeId_$c(3)_bloodTypeDesc_$c(3)_RHBloodType
    s resStr=resStr_"^"_anCtcpId_$c(3)_anaesthetist_$c(3)_anmetId_$c(3)_anmetDesc_$c(3)_orAsaId_$c(3)_orAsaDesc_$c(3)_inrouId_$c(3)_inrouDesc_$c(3)_anaCuffIntubTube_$c(3)_cuffIntubTube_$c(3)_orintId_$c(3)_orintDesc_$c(3)_anaDuration_$c(3)_anAssIdStr_$c(3)_anAssStr_$c(3)_anSuperId_$c(3)_anSuperDesc_$c(3)_anaTheatreInDate_$c(3)_anaTheatreInTime_$c(3)_anaTheatreOutDate_$c(3)_anaTheatreOutTime_$c(3)_anaSourceType_$c(3)_anNurseId_$c(3)_anNurseDesc_$c(3)_patTransferTo_$c(3)_analgesia_$c(3)_analgesiaScore_$c(3)_tracheaCannulaInfo //_$c(3)_ingraDesc
    s resStr=resStr_"^"_surgId_$c(3)_surgDesc_$c(3)_operId_$c(3)_operDesc_$c(3)_preMrcidId_$c(3)_preMrcidDesc_$c(3)_postMrcidId_$c(3)_postMrcidDesc_$c(3)_opposId_$c(3)_opposDesc_$c(3)_opDuration_$c(3)_assIdStr_$c(3)_assSurgStr_$c(3)_anAssIdStr_$c(3)_anAssStr_$c(3)_opscnIdStr_$c(3)_opscnStr_$c(3)_cirnIdStr_$c(3)_cirnStr_$c(3)_planOperId_$c(3)_planOperDesc_$c(3)_orderAuditStatus
    s resStr=resStr_"^"_puncSiteStr
    s resStr=resStr_"^"_attAnaopStr
    s resStr=resStr_"^"_ansStr
    s resStr=resStr_"^"_aniStr
    s resStr=resStr_"^"_inOutStr
    s resStr=resStr_"^"_inAreaVitalSignStr
    s resStr=resStr_"^"_preAnaVisitInfo
    s resStr=resStr_"^"_tPacuBed
    s ^tmpYpz("getanainfo_com",opaId,$h)=surgId_"*"_surgDesc_"*"_resStr
    s ^ttt(666)=resStr
    q resStr
}

/// Creator：        ypz
/// CreatDate：      2010-09-06
/// Description：    修改排班、麻醉、手术信息
/// Table：          DHC_AN_OPArrange,OR_Anaesthesia,OR_Anaest_Operation
/// Input：          排班ID,anaInfo数据:第一级"^",分别是排班、麻醉、手术、其它、附加手术信息。第二级$c(3),第三级$c(4)
///                     opaPatHeight_$c(3)_opaPatWeight_$c(3)_opaPreAnDrug_$c(3)_ancefId_$c(3)_opaOpDocNote_$c(3)_opaAnDocNote_$c(3)_planAnmetDesc
///                     "^"_anCtcpId_$c(3)_anmetDesc_$c(3)_orAsaId_$c(3)_inrouId_$c(3)_anaCuffIntubTubeId_$c(3)_orintId_$c(3)_/*anAssIdStr*/_$c(3)_anSuperId
///                     "^"_surgId_$c(3)_operId_$c(3)_postMrcidId_$c(3)_opposId_$c(3)_assIdStr_$c(3)_anAssIdStr_c(3)_opscnIdStr_$c(3)_cirnIdStr_$c(3)_preMrcidId
///                     "^"_aniIntrathPuncSite_$c(3)_aniIntubationDepth_$c(3)_aniIntrathCathLen_$c(3)_aniIntrathPuncBleedAmt_$c(3,7)
///                        _aniIntrathPuncResiste_$c(3)_aniIntrathPuncNegCompe_$c(3)_aniIntrathPuncDiffFeel
///                     "^"_attAnaopSub_$c(4)_anaopOperType_$c(4)_attOperId_$c(4)_attOperDesc_$c(4)_attPlanOperId_$c(4)_attPlanOperDesc_$c(3)_....
/// Output：       
/// Return：         返回0正常，否则提示信息
ClassMethod SetAnaInfo(opaId, anaInfo = "") As %String
{
    //s anaInfo="155#55#aa#1#王力##ADMZ-安定麻醉+AFMMZ-安氟醚麻醉^512#AXDJMZ-胺酰胆硷麻醉+AZFMZ-艾宙酚麻醉#1#2#N#3#^74#8#post6#3#ys001,1256#510,514,512#488,490#492,502#pre5^3#3#3#3#######2#2#1^4!S!7!oper001#5!S!9!oper001"
    //s ^tmpYpz("anainfo")=anaInfo
    //s anaInfo=^tmpYpz("anainfo")
    //s anaInfo=$tr(anaInfo,"#",$c(3))
    //s anaInfo=$tr(anaInfo,"!",$c(4))
    //w anaInfo,!
    q:(+opaId=0) "手术申请号不能为空!"
    q:$d(^DHCANOPArrange(opaId))<1 "申请号有误!"
    s opaStr=$p(anaInfo,"^")
    s anaStr=$p(anaInfo,"^",2)  //新增麻醉指导医生Id
    s anopStr=$p(anaInfo,"^",3)
    s puncStr=$p(anaInfo,"^",4)
    s attAnaopStr=$p(anaInfo,"^",5)
    s ansStr=$p(anaInfo,"^",6)
    s aniStr=$p(anaInfo,"^",7)
    s ^tmp("SetAnaInfo",opaId)=anaStr
    
    //s $p(^DHCANOPArrange(opaId),"^",22)=$p(opaStr,$c(3))      //OPA_PatHeight
    //s $p(^DHCANOPArrange(opaId),"^",24)=$p(opaStr,$c(3),2)    //OPA_PatWeight
    //s $p(^DHCANOPArrange(opaId),"^",29)=$p(opaStr,$c(3),3)    //OPA_PreAnDrug
    //s $p(^DHCANOPArrange(opaId),"^",12)=$p(opaStr,$c(3),4)    //OPA_AnaEffect_Dr
    //s opaOpDocNote=$p(opaStr,$c(3),5)
    //s $p(^DHCANOPArrange(opaId),"^",42)=opaOpDocNote  //OPA_OpDocNote后面赋值
    //s $p(^DHCANOPArrange(opaId),"^",43)=$p(opaStr,$c(3),6)    //OPA_AnDocNote 
    s planAnmetId=##class(web.DHCANOPCom).ConvertToAnMethodId($p(opaStr,$c(3),7),"+")
    i planAnmetId'="" s $p(^DHCANOPArrange(opaId,"PA"),"^",89)=planAnmetId
    
    s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
    s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    s $P(^OR(EpisodeID,"ANA",anaSub),"^",6)=$p(anaStr,$c(3))        ; ANA_Anaesthetist_Dr 
    s anmetDesc=$p(anaStr,$c(3),2)
    s anmetId=""
    i anmetDesc'="" d
        .//for update start
        .s anmetId=##class(web.DHCANOPCom).ConvertToAnMethodId(anmetDesc,"+")
        .q
        .//for update end
        .s anmetId=$o(^ORC("ANMET",0,"Desc",$$ALPHAUP^SSUTIL4(anmetDesc),""))
        .q:anmetId'=""
        .s num=$l(anmetDesc,"+")
        .q:num<2
        .s insertFlag="Y"
        .f i=1:1:num d
            ..s tmpAnmetDesc=$p(anmetDesc,"+",i)
            ..s tmpAnmetId=$o(^ORC("ANMET",0,"Desc",$$ALPHAUP^SSUTIL4(tmpAnmetDesc),""))
            ..i tmpAnmetId="" s insertFlag="N"
        .q:insertFlag'="Y"
        .s anmetCode="AUTO"_(^ORC("ANMET",0)+1)
        .s curDate=+$h
        .&sql(insert into sqluser.ORC_AnaestMethod(ANMET_Code,ANMET_Desc,ANMET_DateFrom) values(:anmetCode,:anmetDesc,:curDate))
        .i SQLCODE=0 s anmetId=%ROWID
    s $P(^OR(EpisodeID,"ANA",anaSub),"^",5)=anmetId             //ANA_Method /13
    s $P(^OR(EpisodeID,"ANA",anaSub),"^",26)=$p(anaStr,$c(3),3) //ANA_ASA_DR
    //s $P(^OR(EpisodeID,"ANA",anaSub),"^",16)=$p(anaStr,$c(3),4)   //ANA_IntubGrade_DR
    s $P(^OR(EpisodeID,"ANA",anaSub),"^",22)=$p(anaStr,$c(3),5) //ANA_Cuff_IntubTube
    s $P(^OR(EpisodeID,"ANA",anaSub),"^",21)=$p(anaStr,$c(3),6) //ANA_IntSize_DR
    s anAssCpcpIdStr=$p(anaStr,$c(3),7)
    s $P(^OR(EpisodeID,"ANA",anaSub),"^",7)=$p(anaStr,$c(3),8)  //ANA_Supervisor_DR麻醉指导医生Id
    ;s $P(^OR(EpisodeID,"ANA",anaSub),"^",8)=$p(anaStr,$c(3),9) //麻醉护士Id
    ;s $P(^OR(EpisodeID,"ANA",anaSub),"^",32)=$p(anaStr,$c(3),10)

    s anaopSub=0,operCount=0
    f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
        .i anaopSub=1 d
            ..i $p(anopStr,$c(3),2)=+$p(anopStr,$c(3),2) s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)=$p(anopStr,$c(3),2)  ;ANAOP_Type_DR手术名称
            ..e  d
                ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2)=$p(anopStr,$c(3),2)
                ...s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)=""
        .
        .q:anaopSub>1
        .s anaopId=EpisodeID_"||"_anaSub_"||"_anaopSub
        .
        .i +$p(anopStr,$c(3),1)>0 d
            ..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8)=$p(anopStr,$c(3),1)   ;ANAOP_Surgeon_DR  ；手术医师
        .e  d
            ..;s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8)=""
            ..s $p(opaOpDocNote,"|",2)=$p(anopStr,$c(3),1)
        .//i $p(anopStr,$c(3),2)=+$p(anopStr,$c(3),2) s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)=$p(anopStr,$c(3),2)   ;ANAOP_Type_DR     ；手术名称
        .s postMrcidId=$p(anopStr,$c(3),3)
        .i postMrcidId=+postMrcidId s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",5)=postMrcidId   ;ANAOP_PostDiag_DR 术后诊断
        .e  d
            ..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",5)=""
            ..s ^OR(EpisodeID,"ANA",anaSub,"TXT",3)=postMrcidId
        .s opposSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"POS",0)) 
        .//q:opposSub=""
        .i opposSub'="" d
            ..s $p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"POS",opposSub),"^")=$p(anopStr,$c(3),4)
        .e  d
            ..s opposSub=1
            ..s $p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"POS",opposSub),"^")=$p(anopStr,$c(3),4)
            ..s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"POS",0)=opposSub
        .s assIdStr=$p(anopStr,$c(3),5)
        .s retStr=##class(web.DHCANOPCom).UpdateOperationCtcp(anaopId,"ASS",assIdStr,",",.opaOpDocNote)
        .i $p(anopStr,$c(3),6)'="" s anAssCpcpIdStr=$p(anopStr,$c(3),6) //to be update
        .s retStr=##class(web.DHCANOPCom).UpdateOperationCtcp(anaopId,"ANASS",anAssCpcpIdStr,",")
        .s opscnIdStr=$p(anopStr,$c(3),7)
        .s retStr=##class(web.DHCANOPCom).UpdateOperationCtcp(anaopId,"SCN",opscnIdStr,",")
        .s cirnIdStr=$p(anopStr,$c(3),8)
        .s retStr=##class(web.DHCANOPCom).UpdateOperationCtcp(anaopId,"CIRN",cirnIdStr,",")
        .s preMrcidId=$p(anopStr,$c(3),9)
        .i preMrcidId=+preMrcidId s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",4)=preMrcidId ;ANAOP_PreopDiag_DR 术前诊断
        .e  d
            ..s ^OR(EpisodeID,"ANA",anaSub,"TXT",2)=preMrcidId
            ..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",4)=""
    s $p(^DHCANOPArrange(opaId),"^",42)=opaOpDocNote                //修正医生备注的非院内医生后保存
    /////s ^DHCANOPArrange(opaId,1)=$tr(puncStr,$c(3),"^")
    //s $p(^DHCANOPArrange(opaId,"ANI",1),"^",16)=$p(puncStr,$c(3),1)
    //s $p(^DHCANOPArrange(opaId,"ANI",1),"^",81)=$p(puncStr,$c(3),2)
    //s $p(^DHCANOPArrange(opaId,"ANI",1),"^",31)=$p(puncStr,$c(3),3)
    //s $p(^DHCANOPArrange(opaId,"ANI",1),"^",23)=$p(puncStr,$c(3),4)
    //s $p(^DHCANOPArrange(opaId,"ANI",1),"^",20)=$p(puncStr,$c(3),11)
    //s $p(^DHCANOPArrange(opaId,"ANI",1),"^",21)=$p(puncStr,$c(3),12)
    //s $p(^DHCANOPArrange(opaId,"ANI",1),"^",22)=$p(puncStr,$c(3),13)
    s retStr=##class(web.DHCANOPCom).UpdateAttOperation(anaId, attAnaopStr)
    q:retStr'=0 retStr
    
    s ansSub=0,quitFlag=0,curAnsSub=""
    f  s ansSub=$o(^DHCANOPArrange(opaId,"Shift",ansSub)) q:(ansSub="")!(quitFlag)  d
        .i $p(^DHCANOPArrange(opaId,"Shift",ansSub),"^",1)="TI" d
            ..s quitFlag=1,curAnsSub=ansSub
    i curAnsSub="" d
        .s ^DHCANOPArrange(opaId,"Shift",0)=$g(^DHCANOPArrange(opaId,"Shift",0))+1
        .s curAnsSub=^DHCANOPArrange(opaId,"Shift",0)
        .s ^DHCANOPArrange(opaId,"Shift",curAnsSub)="TI"
    s setValList="5^6^8^9^11"
    f i=1:1:$l(setValList,"^") d
        .s itemPos=$p(setValList,"^",i)
        .s $p(^DHCANOPArrange(opaId,"Shift",curAnsSub),"^",itemPos)=$p(ansStr,$c(3),itemPos)
    //s setValList="14^16^20^21^22^23^25^26^27^31^66^73^75^77^78^80^81^86^95^101"
    //s aniSub=$o(^DHCANOPArrange(opaId,"ANI",0))
    //i aniSub="" s ^DHCANOPArrange(opaId,"ANI",0)=1,aniSub=1
    //f i=1:1:$l(setValList,"^") d
    //  .s itemPos=$p(setValList,"^",i)
    //  .s $p(^DHCANOPArrange(opaId,"ANI",aniSub),"^",itemPos)=$p(aniStr,$c(3),itemPos)

    q retStr
}

ClassMethod GetAnpId(opaId, ctlocIdDocType = "")
{
    q:(+opaId=0) 0
    s anpId=$o(^DHCANPara(0,opaId,""))
    i anpId'="" q anpId
    i ctlocIdDocType="" s ctlocIdDocType="Default"
    
    s ^DHCANPara(0)=$g(^DHCANPara(0))+1
    s ^DHCANPara(0,opaId,^DHCANPara(0))=""
    i $d(^DHCANC("Para",ctlocIdDocType))<1 m ^DHCANC("Para",ctlocIdDocType)=^DHCANC("Para","Default")
    
    s anaId=$p($g(^DHCANOPArrange(opaId)),"^",2) //OPA_Anaest_dr
    q:anaId="" ""
    s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)

    s anMethodId=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)          //ANA_Method
    s anMethodCode=$P($g(^ORC("ANMET",+anMethodId)),"^",1)      //取第一个
    i $d(^DHCANC("Para",ctlocIdDocType_"."_anMethodCode))>0 s ctlocIdDocType=ctlocIdDocType_"."_anMethodCode
    m ^DHCANPara(^DHCANPara(0))=^DHCANC("Para",ctlocIdDocType)
    s ^TMPCCQ(opaId,"MergePara",+$h,$p($h,",",2))=anMethodCode_"^"_anMethodId_"^"_ctlocIdDocType
    s $p(^DHCANPara(^DHCANPara(0)),"^",1)=opaId  //ypz end
    s anpId=^DHCANPara(0)
    q anpId
}

ClassMethod GetPreDrug(opaId, fDate, tDate = "") As %String
{
    q:(+opaId=0) ""
    q:'$d(^DHCANOPArrange(opaId)) ""
    s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
    s EpisodeID=+anaId
    s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
    q:oeordId="" ""
    i fDate'="" s fDate=$zdh(fDate,3)
    i fDate="" s fDate=+$h
    i tDate'="" s tDate=$zdh(tDate,3)
    i tDate="" s tDate=+$h
    
    
    i tDate<fDate s tDate=+$h
    i tDate<fDate q ""
    s resStr=""
    f curDate=fDate:1:tDate d
        .s oeoriSub=""
        .f  s oeoriSub=$o(^OEORDi(0,"StDt",curDate,oeordId,oeoriSub)) q:oeoriSub=""  d
            ..s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
            ..q:arcimId=""
            ..s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
            ..s arcimDesc=$p(arcimDesc,"(")
            ..q:arcimDesc=""
            ..s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeordId_"||"_oeoriSub)
            ..q:arcicOrderType'="R"
            ..s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
            ..s unitUomId="",unitDesc=""
            ..i doseQty'="" s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
            ..i unitUomId'="" s unitDesc=$ZCVT($p($g(^CT("UOM",unitUomId)),"^",2),"l")
            ..s doseQtyUnit=""
            ..i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
            ..i (doseQty'="")&(unitDesc'="") s doseQtyUnit=doseQty_" "_unitDesc
            ..i doseQtyUnit'="" s arcimDesc=arcimDesc_"("_doseQtyUnit_")"
            ..i resStr'="" s resStr=resStr_"^"
            ..s resStr=resStr_arcimDesc
    q resStr
}

ClassMethod GetAncViewCat(type = "", needAncvcId = "", isAnApply = "Y") As %String
{
    //type:V生命体征,O医嘱,E事件
    s typePos=0
    i type="V" s typePos=3
    i type="D" s typePos=4
    i type="E" s typePos=5
    i type="VPS" s typePos=6
    s isVPSite=""
    i needAncvcId'="" s isVPSite=$p($g(^DHCANC("ViewCat",needAncvcId)),"^",6)
    s resStr=""
    s ancvcId=0
    f  s ancvcId=$o(^DHCANC("ViewCat",ancvcId)) q:ancvcId=""  d
        .q:(isVPSite'="Y")&(needAncvcId'="")&(needAncvcId'=ancvcId)
        .s ancvcStr=^DHCANC("ViewCat",ancvcId)
        .q:(isVPSite="Y")&($p($g(^DHCANC("ViewCat",ancvcId)),"^",6)'="Y")
        .q:(isAnApply="Y")&($p(^DHCANC("ViewCat",ancvcId),"^",7)'="Y")
        .q:(isAnApply'="")&(isAnApply'="Y")&($p(^DHCANC("ViewCat",ancvcId),"^",8)'="Y")
        .i typePos>0,$p(ancvcStr,"^",typePos)'="Y" q
        .//s $p(ancvcStr,"^",6)=$p($g(^DHCANC("VPSite",+$p(ancvcStr,"^",6))),"^",2)
        .i $l(ancvcStr,"^")<15 s $p(ancvcStr,"^",15)=""
        .s $p(ancvcStr,"^",2)=$p($p(ancvcStr,"^",2),"[")
        .s ancvcStr=$tr(ancvcStr,"^","!")
        .i resStr'="" s resStr=resStr_"^"
        .s resStr=resStr_ancvcId_"!"_ancvcStr
    q resStr
}

ClassMethod GetAncVenipuncSite() As %String
{
    s resStr=""
    s ancvpsId=0
    f  s ancvpsId=$o(^DHCANC("VPSite",ancvpsId)) q:ancvpsId=""  d
        .s ancvpsStr=^DHCANC("VPSite",ancvpsId)
        .s ancvpsStr=$tr(ancvpsStr,"^","!")
        .i resStr'="" s resStr=resStr_"^"
        .s resStr=resStr_ancvpsId_"!"_ancvpsStr
    q resStr
}

ClassMethod GetMasterItem(arcicId As %String, arcimDesc As %String) As %Status
{
    i (arcimDesc'="") s arcimDesc=$$ALPHAUP^SSUTIL4(arcimDesc)
    s arcimSub=0 
    f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
    .s arcimVer=0 f  s arcimVer=$o(^ARCIM(arcimSub,arcimVer)) q:arcimVer=""  d
    ..s arcimId=arcimSub_"||"_arcimVer
    ..s aliasId=$O(^ARC("ALIAS",0,"ARCIM",arcimId,""))
    ..q:aliasId=""
    ..s aliasDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
    ..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
    ..s arcimDesc=aliasDesc_"-"_arcimDesc
    ..q:arcimDesc'[arcimDesc
    ..//q:$p(arcimDesc,arcimDesc,1)'=""
    ..s itemcatDR=$p(^ARCIM(arcimSub,arcimVer,1),"^",10)
    ..i arcicId=itemcatDR d
    ..
    quit
}

ClassMethod GetOrderInfo() As %String
{
    s resStr=""
    q resStr
}

ClassMethod GetArcimDesc(arcimId) As %String
{
    q:arcimId="" ""
    s arcimDesc=""
    s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
    q arcimDesc
}

ClassMethod GetPostOpCond(opaId) As %String
{
    s $p(postOpCondStr,"^",39)=""
    q:(+opaId=0) postOpCondStr
    /*q:'$d(^DHCANOPArrange(opaId,2)) postOpCondStr
    s postOpCondStr=$g(^DHCANOPArrange(opaId,2))
    */
    s postOpCondStr=$g(^DHCANOPArrange(opaId,"Sum","I"))
    s $p(postOpCondStr,"^",11)=$g(^DHCANOPArrange(opaId,"Sum","IB"))
    s $p(postOpCondStr,"^",21)=$g(^DHCANOPArrange(opaId,"Sum","O"))
    s $p(postOpCondStr,"^",31)=$tr($p($g(^DHCANOPArrange(opaId)),"^",60),"|","^")
    f i=31:1:39 s $p(postOpCondStr,"^",i)=$p($g(^DHCANC("PostOpCond",+$p(postOpCondStr,"^",i))),"^",2)
    q postOpCondStr
}

ClassMethod SetPostOpCond(opaId, paraStr) As %String
{
    q:(+opaId=0) ""
    //s ^DHCANOPArrange(opaId,2)=paraStr
    s ^DHCANOPArrange(opaId,"Sum","I")=$p(paraStr,"^",1,5)
    s ^DHCANOPArrange(opaId,"Sum","IB")=$p(paraStr,"^",11,17)
    s ^DHCANOPArrange(opaId,"Sum","O")=$p(paraStr,"^",21,23)
    s opaPostAnaSum=$p(paraStr,"^",31,39)
    s $p(^DHCANOPArrange(opaId),"^",60)=$tr(opaPostAnaSum,"^","|")
    q 0
}

ClassMethod GetAncByNode(node) As %String
{
    q:node="" ""
    s resStr="",id=0
    f  s id=$o(^DHCANC(node,id)) q:id=""  d
        .s desc=$p(^DHCANC(node,id),"^",2)
        .i "^VSCat^"[("^"_node_"^") s desc=$p(desc,"[")
        .i resStr'="" s resStr=resStr_"^"
        .s resStr=resStr_id_$c(3)_desc
    q resStr
}

ClassMethod GetOrcByNode(node) As %String
{
    q:node="" ""
    s resStr="",id=0
    f  s id=$o(^ORC(node,id)) q:id=""  d
        .i resStr'="" s resStr=resStr_"^"
        .s resStr=resStr_id_$c(3)_$p(^ORC(node,id),"^",2)
    q resStr
}

ClassMethod GetLocCtcp(opaId, anNode) As %String
{
    //node="anloc","oploc"
    q:'$d(^DHCANOPArrange(+opaId)) ""
    s locIdStr=""
    s locIdStr=$p(^DHCANOPArrange(+opaId),"^",21)
    s anaId=$p(^DHCANOPArrange(+opaId),"^",2) //OPA_Anaest_dr
    i locIdStr="",anaId'="" s locIdStr=$p($g(^PAADM(+anaId)),"^",4)
    i locIdStr="",anNode'="" s locIdStr=$g(^DHCANOPSET(anNode))
    q:locIdStr="" ""
    s num=$l(locIdStr,"^")
    
    s resStr="",ctcpIdStr=""
    f i=1:1:num d
        .s str=$P(locIdStr,"^",i)
        .s locId=$P(str,"|")
        .s resId="" f  s resId=$O(^RB("RES",0,"CTLOC",locId,resId)) q:resId=""  d
            ..s ctcpId=$P(^RB("RES",resId),"^",2)
            ..q:ctcpId=""
            ..q:(("^"_ctcpIdStr_"^")[("^"_ctcpId_"^"))
            ..s userEmailName=##class(DHCANOPCom).GetCtcpUserEmailName(ctcpId)
            ..s tmpData(userEmailName_ctcpId)=ctcpId
        .s clcpRowId="" f  s clcpRowId=$o(^DHCCLCPI("CtLoc",locId,clcpRowId)) q:clcpRowId=""  d
            ..s ctcpId="~"_clcpRowId
            ..s tmpData(ctcpId)=ctcpId
     s ctcpNode=""
     f  s ctcpNode=$o(tmpData(ctcpNode)) q:ctcpNode=""  d
        .s ctcpId=tmpData(ctcpNode)
        .q:ctcpId=""
        .;s ctcpDesc=$p(^CTPCP(ctcpId,1),"^",2)
        .s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpId)
        .i resStr'="" s resStr=resStr_"^",ctcpIdStr=ctcpIdStr_"^"
        .s resStr=resStr_ctcpId_$c(3)_ctcpDesc
        .s ctcpIdStr=ctcpIdStr_ctcpId
     q resStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCANCom","FindAnNur","","NURSE")  //DOCTOR  //NURSE
/// 取得所有 麻醉护士
Query FindAnNur(careProv As %Library.String, type As %Library.String) As %Query(ROWSPEC = "ctcpDesc,ctcpDr")
{
}

ClassMethod FindAnNurExecute(ByRef qHandle As %Binary, careProv As %Library.String = "", type As %Library.String = "") As %Status
{
     Set repid=$I(^CacheTemp)
     If $g(ind)="" Set ind=1
     s num=$L($G(^DHCANOPSET("anloc")),"^")
     f i=1:1:num d
     .s str=$P(^DHCANOPSET("anloc"),"^",i)
     .s id=$P(str,"|")
     .s anctLoc(id)=""
     s loc="" f  s loc=$O(anctLoc(loc)) q:loc=""  d
     .s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",loc,rw)) q:rw=""  d
     ..s ctcpDr=$P(^RB("RES",rw),"^",2)
     ..q:ctcpDr=""
     ..s ctcpDesc=$p(^CTPCP(ctcpDr,1),"^",2)
     ..s ctcpOtherName=$p(^CTPCP(ctcpDr,3),"^",28)
     ..q:(careProv'="")&((ctcpDesc'[careProv)!(("^"_ctcpOtherName_"^")'[("^"_careProv_"^")))
     ..;q:(careProv'="")&(ctcpDesc'[careProv)
     ..s ctcptId=$p(^CTPCP(ctcpDr,1),"^",4)
     ..q:ctcptId=""
     ..s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",4)
     ..q:(type'="")&(ctcptType'=type)
     ..Do OutputAnNur

     Set qHandle=$lb(0,repid,0)
     Quit $$$OK
OutputAnNur
    set Data=$lb(ctcpDr,ctcpDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

ClassMethod FindAnNurFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnNurExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else  {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindAnNurClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnNurExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANCom","FindAnCareProv","朱茂恩","DOCTOR")
Query FindAnCareProv(careProv As %Library.String, type As %Library.String) As %Query(ROWSPEC = "Id,Desc")
{
}

ClassMethod FindAnCareProvExecute(ByRef qHandle As %Binary, careProv As %Library.String = "", type As %Library.String = "") As %Status
{
     Set repid=$I(^CacheTemp)
     If $g(ind)="" Set ind=1
     s num=$L($G(^DHCANOPSET("anloc")),"^")
     f i=1:1:num d
     .s str=$P(^DHCANOPSET("anloc"),"^",i)
     .s id=$P(str,"|")
     .s anctLoc(id)=""
     s loc="" f  s loc=$O(anctLoc(loc)) q:loc=""  d
     .s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",loc,rw)) q:rw=""  d
     ..s ctcpDr=$P(^RB("RES",rw),"^",2)
     ..q:ctcpDr=""
     ..s ctcpDesc=$p(^CTPCP(ctcpDr,1),"^",2)
     ..s ctcpOtherName=$p(^CTPCP(ctcpDr,3),"^",28)
     ..q:(careProv'="")&((ctcpDesc'[careProv)!(("^"_ctcpOtherName_"^")'[("^"_careProv_"^")))
     ..s ctcptId=$p(^CTPCP(ctcpDr,1),"^",4)
     ..q:ctcptId=""
     ..s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",4)
     ..q:(type'="")&(ctcptType'=type)
     ..Do OutputAnNur

     Set qHandle=$lb(0,repid,0)
     Quit $$$OK
OutputAnNur
    set Data=$lb(ctcpDr,ctcpDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

ClassMethod FindAnCareProvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnCareProvExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else  {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindAnCareProvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnCareProvExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDiag(mrcidStr)
{
    k ^TMP("ANCom",$i)
    s i=0
    s mrcidStr=$$ALPHAUP^SSUTIL4(mrcidStr)  //ypz 070313 $ZCONVERT(mrcidStr,"U")
    q:mrcidStr="" 0
    if mrcidStr'=""
    {
        s flag="N"
        s OpDiag=$O(^MRC("ID",0,"ALIAS",mrcidStr),-1) //ypz 070313 保证找到当前串
        f  s OpDiag=$O(^MRC("ID",0,"ALIAS",OpDiag)) q:(OpDiag="")!(flag="Y")  d
            .i $p(OpDiag,mrcidStr)'="" s flag="Y" q
            .//i $e(OpDiag,1,$L(mrcidStr))'=mrcidStr s flag="Y" q
            .s mrcidId=""
            .f  s mrcidId=$O(^MRC("ID",0,"ALIAS",OpDiag,mrcidId)) q:(mrcidId="")  d
                ..s mrcidDesc=$p(^MRC("ID",mrcidId),"^",2)
                ..s ^TMP("ANCom",$i,i)=mrcidId_"^"_mrcidDesc
                ..//w ^TMP("ANCom",$i,i)_".",!
                ..s i=i+1
    }
    i i>0 q i
    s mrcidId=0
    f  s mrcidId=$o(^MRC("ID",mrcidId)) q:mrcidId=""  d
        .s mrcidDesc=$p(^MRC("ID",mrcidId),"^",2)
        .//s LinkStr=$ZCONVERT(mrcidStr,"U")
        .i $$ALPHAUP^SSUTIL4(mrcidDesc)[mrcidStr  do
            ..s ^TMP("ANCom",$i,i)=mrcidId_"^"_mrcidDesc
            ..//w ^TMP("ANCom",$i,i)
            ..s i=i+1
    q i
}

ClassMethod GetOperation(operStr)
{
    k ^TMP("ANCom",$i)
    s i=0 //ypz 060811
    //^ORC("OPER",0,"ALIAS",$$ALPHAUP({ALIAS_Text}),{ORC_Operation.OPER_RowId},{ALIAS_Childsub})
    s operStr=$$ALPHAUP^SSUTIL4(operStr) //$ZCONVERT(operStr,"U")  ypz 070313
    q:operStr="" 0
    if (operStr'="")
    {
    s flag="N"
    s OpDes=$O(^ORC("OPER",0,"ALIAS",operStr),-1)  //ypz 070313 open
    f  s OpDes=$O(^ORC("OPER",0,"ALIAS",OpDes)) q:(OpDes="")!(flag="Y")  d
        .i $p(OpDes,operStr)'="" s flag="Y" q
        .s operId=""
        .f  s operId=$O(^ORC("OPER",0,"ALIAS",OpDes,operId)) q:operId=""  d  //ypz 070313 
            ..s operDesc=$p(^ORC("OPER",operId),"^",2)
            ..s ^TMP("ANCom",$i,i)=operId_"^"_operDesc
            ..//w ^TMP("ANCom",$i,i)
            ..s i=i+1
    }
    if i>0 q i
    s operId=0
    f  s operId=$o(^ORC("OPER",operId)) q:operId=""  d
        .s operDesc=$p(^ORC("OPER",operId),"^",2)
        .q:$$ALPHAUP^SSUTIL4(operDesc)'[operStr //q:$$UPPER^SSUTIL4(operDesc)'[operStr
        .s ^TMP("ANCom",$i,i)=operId_"^"_operDesc
        .//w ^TMP("ANCom",$i,i)
        .s i=i+1
    q i
}

ClassMethod SetEventAttDateTime(opaId, aneId, anceId, dateStr, timeStr) As %String
{
    q:(+opaId=0) "手术申请号为空!"
    i anceId="",aneId'="" s anceId=$p($g(^DHCANOrder("Event",aneId)),"^",2)
    q:anceId="" "没有事件号!"
    s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
    s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    i dateStr'="" s dateH=$zdh(dateStr,3)
    e   s dateH=+$h 
    i timeStr'="" s timeH=$zth(timeStr,3)
    e   s timeH=$p($h,",",2)

    i $p($g(^DHCANC("Event",anceId)),"^")="AnaStart" d
        .s $p(^OR(EpisodeID,"ANA",anaSub),"^",2)=dateH
        .s $p(^OR(EpisodeID,"ANA",anaSub),"^",3)=timeH
    i $p($g(^DHCANC("Event",anceId)),"^")="AnaEnd" d
        .s $p(^OR(EpisodeID,"ANA",anaSub),"^",29)=dateH
        .s $p(^OR(EpisodeID,"ANA",anaSub),"^",4)=timeH
    s anaopSub=0 
    f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
        .i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
        .i $p($g(^DHCANC("Event",anceId)),"^")="OperStart" d
            ..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",13)=dateH
            ..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",2)=timeH
        .i $p($g(^DHCANC("Event",anceId)),"^")="OperEnd" d
            ..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",16)=dateH
            ..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",3)=timeH
    //s anaDuration=($p(^OR(EpisodeID,"ANA",anaSub),"^",29)-$p(^OR(EpisodeID,"ANA",anaSub),"^",2))*86400
    //s anaDuration=anaDuration+$p(^OR(EpisodeID,"ANA",anaSub),"^",4)-$p(^OR(EpisodeID,"ANA",anaSub),"^",3)
    
      // .s opDuration=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",16)-$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",13)
      // .s opDuration=opDuration*86400+$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",3)-$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",2)

    q 0
}

/// accessType :"AN"术中访问,"PACU"恢复室访问
/// w ##class(web.DHCANCom).GetEditStat(79,"AN")
ClassMethod GetEditStat(opaId, accessType = "AN") As %String
{
    //"CanStart^"安排状态可以启动设备，"CanStop^"术中状态可继续手术。
    //返回"CanRead^"没有操作权限IP,"CanEdit^"有操作权限IP,但已有新病人手术,能编辑,"CanRestart^"可以连接设备,
    //"InRoom^"安排状态但已有别的手术
    //手术安排的PACU状态，在麻醉监护中结束监护时置，如果选了PACU，那么状态相应修改。
    //PACU状态下返回:"CanStart^","CanStop^","CanRead^","CanEdit^","CanRestart^","CanPACURestart^"(是否需要这个状态?)
    i accessType="Read" s accessType="AN"
    q:(+opaId=0) "noOpaId^无病人手术号!"
    s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
    q:opaStatus="" "noOpaStat^无手术状态!"
    q:opaStatus="A" "appOper^不能对手术状态为申请的病人操作！"
    q:opaStatus="D" "declineOper^不能对手术状态为拒绝的病人操作！"
    q:opaStatus="N" "unAppointOper^不能对手术状态为非预约的病人操作！"
    s roomId=$p($g(^DHCANOPArrange(opaId)),"^",20)
    q:roomId="" "noOperRoom^无病人手术间!"
    s pacuRoomId=""
    i accessType="PACU" s pacuRoomId=$p($g(^DHCANOPArrange(opaId)),"^",47)
    q:(accessType="PACU")&(pacuRoomId="") "CanRead^未指定病人恢复床!" //恢复室能看麻醉单??
    q:opaStatus="F" "CanRead^"
    q:(opaStatus'="R")&(opaStatus'="I")&(opaStatus'="L")&(opaStatus'="P") "errOpaStat^手术状态不对!"
    //q:(accessType="AN")&(opaStatus="P") "CanRead^" //暂可修改??
    q:(accessType="PACU")&(opaStatus="R") "errOpaStat^手术未开始,请在手术结束后进行!" //术前不能看
    q:(accessType="PACU")&(opaStatus="I") "errOpaStat^手术未结束,请在手术结束后进行!" //术中不能看
    
    s retStr="CanRead^"
    s tmpRoomId=roomId
    i accessType="PACU" s tmpRoomId=pacuRoomId
    s anreId=""
    f  s anreId=$o(^DHCANRoomEquip(0,"Room",tmpRoomId,anreId)) q:anreId=""  d
        .s anreEditTcpipAddress=$p($g(^DHCANRoomEquip(anreId)),"^",7)
        .q:anreEditTcpipAddress=""
        .i ("|"_anreEditTcpipAddress_"|")[("|"_$zu(67,15,$j)_"|") s retStr="CanStart^"
        .//i ("|"_anreEditTcpipAddress_"|")[("|127.0.0.1|") s retStr="CanStart^"
 //s retStr="CanStart^" //for debug
    q:retStr'["CanStart^" retStr //非可编辑IP则退出
    
    i (accessType="AN")&($d(^DHCANOPArrange(0,"RoomStatus",roomId,"I")))>0 d
        .i opaStatus="L" s retStr="CanEdit^" q //术后进入时，已有新监护，只能手工修改
        .s inroomOpaId=$o(^DHCANOPArrange(0,"RoomStatus",roomId,"I",""))
        .i inroomOpaId=opaId s retStr="CanStop^" //术中进入，可以重返
        .i inroomOpaId'=opaId d //术前要进时，已有监护
            ..s tmpRetStr=..AutoTerminal(inroomOpaId)
            ..i tmpRetStr'=0 s retStr=tmpRetStr
    q:retStr'["CanStart^" retStr
    q:(accessType="AN")&(opaStatus="I")>0 retStr //PACU已返回
    q:(accessType="AN")&(opaStatus="R")>0 retStr //PACU已返回
    
    i opaStatus="L" d //术毕可重返
        .//&sql(update DHC_AN_OPArrange set OPA_Status='I' where OPA_RowId=:opaId)
        .i (accessType="AN") s retStr="CanRestart^"
        .i (accessType="PACU") d
            ..s retStr="CanRestart^" //考虑麻醉结束后可能忘记点去PACU?? 是不是只要CanPACURestart
            ..s tmpRoomId=0
            ..f  s tmpRoomId=$o(^DHCANOPArrange(0,"RoomStatus",tmpRoomId)) q:tmpRoomId=""  d
                ...s pacuOpaId=0
                ...f  s pacuOpaId=$o(^DHCANOPArrange(0,"RoomStatus",tmpRoomId,"P",pacuOpaId)) q:pacuOpaId=""  d
                    ....q:pacuRoomId'=$p($g(^DHCANOPArrange(pacuOpaId)),"^",47) //不是当前恢复床是可重启状态
                    ....i $p($g(^DHCANOPArrange(pacuOpaId,"PACU")),"^",6)'="" s retStr="CanEdit^" //已有恢复床
    q:retStr'["CanStart^" retStr
    q:opaStatus="L" retStr //可不要
    
    i opaStatus="P" d //在术毕后选入恢复室则 无PACU开始时间则返回开始，有则继续
        .i (accessType="AN") d
            ..s retStr="CanRestart^"
            ..i $p($g(^DHCANOPArrange(opaId,"PACU")),"^",6)'="" s retStr="CanEdit^" //已入恢复室可手工修改
        .i (accessType="PACU") d 
            ..s tmpRoomId=0
            ..f  s tmpRoomId=$o(^DHCANOPArrange(0,"RoomStatus",tmpRoomId)) q:tmpRoomId=""  d
                ...s pacuOpaId=0
                ...f  s pacuOpaId=$o(^DHCANOPArrange(0,"RoomStatus",tmpRoomId,"P",pacuOpaId)) q:pacuOpaId=""  d
                    ....q:pacuRoomId'=$p($g(^DHCANOPArrange(pacuOpaId)),"^",47) //不是当前恢复床是可重启状态
                    ....q:pacuOpaId'=opaId
                    ....//i $p($g(^DHCANOPArrange(pacuOpaId,"PACU")),"^",6)'="" s retStr="CanEdit^" //已有恢复床
            ..q:retStr'["CanStart^"
            ..i $p($g(^DHCANOPArrange(opaId,"PACU")),"^",6)'="" s retStr="CanStop^" //已入恢复室则继续
    q retStr
}

ClassMethod GetRoomStat(opaId, userId = "") As %String
{
    q:(+opaId=0)&(userId="") "noOpaIdAndUserId^无病人手术号和用户!"
    //q:opaId="" "noOpaId^无病人手术号!"
    s locIdStr=""
    i opaId'="" d
        .s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
        .q:opaStatus="" //"noOpaStat^无手术状态!"
        .q:opaStatus="A" //"appOper^不能对手术状态为申请的病人操作！"
        .q:opaStatus="D" //"declineOper^不能对手术状态为拒绝的病人操作！"
        .q:opaStatus="N" //"unAppointOper^不能对手术状态为非预约的病人操作！"
        .s roomId=$p($g(^DHCANOPArrange(opaId)),"^",20)
        .q:roomId="" //"noOperRoom^无病人手术间!"
        .s locIdStr=$p(^DHCANC("OPRoom",roomId),"^",3)
    i locIdStr="" d //"无手术科室!"
        .s ctcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
        .q:ctcpId=""
        .s locId=""
        .f  s locId=$O(^RB("RES",0,"CTPCP",ctcpId,locId)) q:(locId="")  d
            ..i locIdStr'="" s locIdStr=locIdStr_"^"
            ..s locIdStr=locIdStr_locId
            ..s linkLockIdStr=##class(web.DHCCLCom).GetLinkLocId(locId)
            ..i linkLockIdStr'="" s locIdStr=locIdStr_"^"_linkLockIdStr
            ..//w locIdStr,!
    
    s operLocId="",retStr="",i=0
    f  s operLocId=$o(^DHCANC("OPRoom",0,"CtLoc",operLocId)) q:operLocId=""  d
        .q:(locIdStr'="")&(locIdStr'[operLocId)
        .s roomId=""
        .f  s roomId=$o(^DHCANC("OPRoom",0,"CtLoc",operLocId,roomId)) q:roomId=""  d
            ..s i=i+1
            ..//q:(locIdStr="")&(i>10)
            ..q:'$d(^DHCANC("OPRoom",roomId))
            ..s opaId=$o(^DHCANOPArrange(0,"RoomStatus",roomId,"I",""))
            ..i retStr'="" s retStr=retStr_"^"
            ..s retStr=retStr_roomId
            ..s retStr=retStr_$c(3)_$p(^DHCANC("OPRoom",roomId),"^")_$c(3)_$p(^DHCANC("OPRoom",roomId),"^",2)
            ..s retStr=retStr_$c(3)_opaId
    q retStr
}

// 返回值:anmetId(麻醉方法Id)_$c(3)_anmetDesc(麻醉方法名)_$c(3)_antypeId(麻醉方法分类Id)^...

ClassMethod GetAnMethodSingle() As %String
{
    //s ^ORC("ANMET",3)=3^静脉全麻^^^61151^
    s code="",retStr=""
    f  s code=$o(^ORC("ANMET",0,"Code",code)) q:code=""  d
        .s anmetId=$o(^ORC("ANMET",0,"Code",code,""))
        .q:anmetId=""
        .s anmetCode=$p(^ORC("ANMET",anmetId),"^",1)
        .s anmetDesc=$p(^ORC("ANMET",anmetId),"^",2)
        .s antypeId=$p(^ORC("ANMET",anmetId),"^",3)
        .q:$p(anmetDesc,"+",2)'=""
        .i retStr'="" s retStr=retStr_"^"
        .s retStr=retStr_anmetId_$c(3)_anmetDesc_$c(3)_antypeId_$c(3)_anmetCode
     q retStr
}

// 返回值 ancoId_"^"_ancoStr_"^"_arcimDesc_"^"_eqUomIdStr等效剂量单位_"^"_eqDefDoseStr医嘱缺省量_"^"_defPhcinId_"^"_baseUomId基本单位_"^"_eqQtyStr转换系数_"^"_volume单位代码为"ML"的转换系数,无则为""

// ancoStr以$c(3)分割

ClassMethod GetArcimById(arcimId) As %String
{
    q:arcimId="" ""
    
    q:##class(web.DHCANOPCom).IfEffectOrd("",arcimId)'="Y" ""
    s OrdCatDR=""
    s arcimCode=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",1)
    s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
    s arcimCatId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",10)
    i arcimCatId'="" s OrdCatDR=$p(^ARC("IC",arcimCatId),"^",8)
    s lAncoId=0,ancoId=0
    //f  s lAncoId=$o(^DHCANC("ComOrd",lAncoId)) q:(lAncoId="")!(ancoId>0)  d
    //  .i arcimId=$p(^DHCANC("ComOrd",lAncoId),"^",4) s ancoId=lAncoId
    s ancvcId="" //ypz无初始值//$o(^DHCANC("ViewCat",0,"oEvent",""))
    //i ancoId>0 s ancvcId=$p(^DHCANC("ComOrd",ancoId),"^",5)
    s eqUomQty=..GetEqUomQty(arcimId)
    
    s ancoStr=""
    ;i ancoId>0 s ancoStr=$g(^DHCANC("ComOrd",+ancoId))
    ;i $l(ancoStr,"^")<20 s $p(ancoStr,"^",20)=""
    ;i $p(ancoStr,"^",4)="" s $p(ancoStr,"^",4)=arcimId
    ;s $p(ancoStr,"^",5)=ancvcId
    ;s ancoStr=$tr(ancoStr,"^",$c(3))
    s defPhcinId="",defaultInstrDesc=""
    s phcdfId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",12)
    s phcdId=+phcdfId,phcdfSub=+$p(phcdfId,"||",2)
    s arcicId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",10)
    
    i phcdfSub'="" d
        .s defPhcinId=$p($g(^PHCD(phcdId,"DF",phcdfSub,1)),"^",5)
        .s defaultInstrDesc=$p($g(^PHCIN(+defPhcinId)),"^",2)
    s itemPrice=+##Class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimId,+$h,"","","","")
    q ancoId_"^"_ancoStr_"^"_arcimDesc_"^"_$p(eqUomQty,"^")_"^"_$p(eqUomQty,"^",2)_"^"_defPhcinId_"^"_$p(eqUomQty,"^",3)_"^"_$p(eqUomQty,"^",4)_"^"_$p(eqUomQty,"^",5)_"^"_itemPrice_"^"_arcimCode_"^"_arcimCatId_"^"_defaultInstrDesc_"^"_OrdCatDR
}

/// Creator：        ypz
/// CreatDate：      2009-04-21
/// Description：    取房间设备数据
/// Table：          DHC_AN_RoomEquip
/// Input：          opaId手术安排ID
/// Output：       
/// Return：         返回""无数据。返回数据分两级，第一级"^"，是每条设备记录的数据。
///                 第二级$c(3)：房间号_$c(3)_设备ID_$c(3)_设备IP地址_$c(3)_设备端口_$c(3)_设备程序_$c(3)_采样间隔_$c(3)_操作电脑IP地址_"^"....
ClassMethod GetAnRoomEquip(opaId) As %String
{
    //w ##class(web.DHCANCom).GetAnRoomEquip(27)
    q:opaId="" ""
    s oproomId=$p($g(^DHCANOPArrange(opaId)),"^",20)
    q:+oproomId=0 "未定义房间!"
    s anreId="",retStr=""
    //循环手术室中的设备
    f  s anreId=$o(^DHCANRoomEquip(0,"Room",oproomId,anreId)) q:anreId=""  d
        .s eqId=$p($g(^DHCANRoomEquip(anreId)),"^",2)
        .//q:eqId=""
        .i retStr'="" s retStr=retStr_"^"
        .s retStr=retStr_$tr(^DHCANRoomEquip(anreId),"^",$c(3))
    q retStr
}

ClassMethod InsertAnOrderTemp(anOrder) As %String
{
    Set $ZT="ERROR"
    TSTART
    s anOpaDr=$p(anOrder,"#",1)
    s anOrdDr=$p(anOrder,"#",2)
    s anoSttDate=$p(anOrder,"#",3)
    s anoSttTime=$p(anOrder,"#",4)
    s anoQty=$p(anOrder,"#",5)
    s anoUomDr=$p(anOrder,"#",6)
    s anoViewCatDr=$p(anOrder,"#",7)
    s anoSource=$p(anOrder,"#",8)
    s anoType=$p(anOrder,"#",9)
    &SQL(Insert into DHC_AN_Order(ANO_OPA_Dr,ANO_ANCORD_Dr,ANO_StartDate,ANO_StartTime,ANO_UpdateDate,ANO_UpdateTime,ANO_Qty,ANO_Uom_Dr,ANO_ViewCat_Dr,ANO_Source,ANO_Type) values(:anOpaDr,:anOrdDr,:anoSttDate,:anoSttTime,:anoSttDate,:anoSttTime,:anoQty,:anoUomDr,:anoViewCatDr,:anoSource,:anoType))
    i SQLCODE TROLLBACK
    Q:SQLCODE 1
    TCOMMIT
    q SQLCODE
ERROR
    Set ErrorMsg=$ZE
    TROLLBACK
    Quit "<ERROR>"_VALUE
    q SQLCODE
}

/// Creator：        ypz
/// CreatDate：      2009-08-20
/// Description：    取交班信息
/// Table：          DHC_AN_OPArrange
/// Input：          opaId手术安排ID
/// Output：       
/// Return：         返回""无数据。返回数据分两级，第一级"^"，记录各数据。
///                 交班地、交班病人意识、交班呼吸次数、交班呼吸模式、交班呼吸清晰、交班呼吸对称、交班心率/脉搏次数、
///                 交班心律窦性、交班心律窦性自由文本、交班收缩压、交班舒张压、交班血氧饱和度、交班是否吸氧、
///                 交班吸氧百分比、交班人、接班人
///                 其中交班地、交班病人意识、交班呼吸模式的内码和描述用$c(3)分开，交班人、接班人Id和名称用$c(3)分开
///                 
ClassMethod GetAnaShiftInfo(opaId As %String) As %String
{
    //w ##class(web.DHCANCom).GetAnaShiftInfo(1)
    //OPA_ShiftPlace交班地：T-手术间,W-病房,P-麻醉恢复室，S-SICU,I-ICU,C-CTICU
    //OPA_Consciousness Multiple Choice 交班病人意识：C-清醒，S-Somnolence嗜睡, U-未清醒
    //OPA_Respiration   Number  交班呼吸次数
    //OPA_RespMode  Multiple Choice 交班呼吸模式：S-自主,M-机控Mechanical Ventilation
    //OPA_RespClear Yes/No  交班呼吸清晰
    //OPA_RespSymmetrical   Yes/No  交班呼吸对称
    //OPA_PulseRate Number  交班心率/脉搏次数
    //OPA_RhythmSinus   Yes/No  交班心律窦性
    //OPA_RhythmOther   Text    交班心律窦性自由文本
    //OPA_BPSystolic    Number  交班收缩压
    //OPA_BPDiastolic   Number  交班舒张压
    //OPA_OxygenSaturation  Number  交班血氧饱和度
    //OPA_InhaleOxygen  Yes/No  交班是否吸氧
    //OPA_InhaleOxyDensity  Number  交班吸氧百分比
    //OPA_ShiftCtcp_Dr  DR  交班人，指向CT_CareProv表
    //OPA_ReliefCtcp_Dr DR  接班人，指向CT_CareProv表

    s retStr=$g(^DHCANOPArrange(+opaId,"S"))
    s $p(retStr,"^",20)=""
    s opaShiftPlace=$p(retStr,"^",1)
    s opaShiftPlaceExt=$SELECT(opaShiftPlace="T":"手术间",opaShiftPlace="W":"病房",opaShiftPlace="P":"麻醉恢复室",opaShiftPlace="S":"SICU",opaShiftPlace="I":"ICU",opaShiftPlace="C":"CTICU",1:"") 
    s $p(retStr,"^",1)=$p(retStr,"^",1)_$c(3)_opaShiftPlaceExt
    s opaConsciousness=$p(retStr,"^",2)
    s opaConsciousnessExt=$SELECT(opaConsciousness="C":"清醒",opaConsciousness="S":"嗜睡",opaConsciousness="U":"未清醒",1:"") 
    s $p(retStr,"^",2)=$p(retStr,"^",2)_$c(3)_opaConsciousnessExt
    s opaRespMode=$p(retStr,"^",4)
    s opaRespModeExt=$SELECT(opaRespMode="S":"自主",opaRespMode="M":"机控",opaRespMode="U":"未清醒",1:"") 
    s $p(retStr,"^",4)=$p(retStr,"^",4)_$c(3)_opaRespModeExt
    s shiftCtcpId=$p(retStr,"^",15)
    s $p(retStr,"^",15)=$p(retStr,"^",15)_$c(3)_##class(web.DHCANOPCom).GetNameById(shiftCtcpId) //$p($g(^CTPCP(+shiftCtcpId,1)),"^",2)
    s reliefCtcpId=$p(retStr,"^",16)
    s $p(retStr,"^",16)=$p(retStr,"^",16)_$c(3)_##class(web.DHCANOPCom).GetNameById(reliefCtcpId) //$p($g(^CTPCP(+reliefCtcpId,1)),"^",2)
    q retStr
}

/// Creator：        ypz
/// CreatDate：      2009-08-20
/// Description：    写交班信息
/// Table：          DHC_AN_OPArrange
/// Input：          opaId手术安排ID,写入参数：返回数据分两级，第一级"^"，记录各数据。
///                 交班地码、交班病人意识码、交班呼吸次数、交班呼吸模式码、交班呼吸清晰、交班呼吸对称、交班心率/脉搏次数、
///                 交班心律窦性、交班心律窦性自由文本、交班收缩压、交班舒张压、交班血氧饱和度、交班是否吸氧、
///                 交班吸氧百分比、交班人Id、接班人Id
/// Output：       
/// Return：         返回"0"正常，否则出错信息。
ClassMethod SetAnaShiftInfo(opaId As %String, paraStr As %String) As %String
{
    //w ##class(web.DHCANCom).SetAnaShiftInfo(1,"T^S^3^M^N^a^b^c^d^e^f^g^h^i^12^15")
    q:opaId="" "手术Id为空!"
    q:'$d(^DHCANOPArrange(+opaId)) "手术Id无相应数据!"
    i "TWPSIC"'[$p(paraStr,"^",1) s $p(paraStr,"^",1)=""
    i "CSU"'[$p(paraStr,"^",2) s $p(paraStr,"^",2)=""
    i "SM"'[$p(paraStr,"^",4) s $p(paraStr,"^",4)=""
    i "YN"'[$p(paraStr,"^",5) s $p(paraStr,"^",5)=""
    i "YN"'[$p(paraStr,"^",6) s $p(paraStr,"^",6)=""
    i "YN"'[$p(paraStr,"^",8) s $p(paraStr,"^",8)=""
    i "YN"'[$p(paraStr,"^",13) s $p(paraStr,"^",13)=""
    i +$p(paraStr,"^",15)=0 s $p(paraStr,"^",15)=""
    i +$p(paraStr,"^",16)=0 s $p(paraStr,"^",16)=""
    s $p(paraStr,"^",3)=+$p(paraStr,"^",3)
    s $p(paraStr,"^",7)=+$p(paraStr,"^",7)
    s $p(paraStr,"^",10)=+$p(paraStr,"^",10)
    s $p(paraStr,"^",11)=+$p(paraStr,"^",11)
    s $p(paraStr,"^",12)=+$p(paraStr,"^",12)
    s $p(paraStr,"^",14)=+$p(paraStr,"^",14)
    s ^DHCANOPArrange(+opaId,"S")=paraStr
    q 0
}

/// Creator：        ypz
/// CreatDate：      2009-09-27
/// Description：    取时间比例数据
/// Table：          DHC_AN_Para,DHC_AN_ParaTimeScale
/// Input：          opaId手术安排ID
/// Output：       
/// Return：         返回""无数据。返回数据分两级，第一级"^"，是每条时间比例数据。
///                 第二级$c(3)：开始日期_$c(3)_开始时间_$c(3)_比例值_$c(3)_修改人_$c(3)_修改日期_$c(3)_修改时间_$c(3)_"^"....
ClassMethod GetTimeScale(opaId, ctlocIdDocType) As %String
{
    q:opaId="" ""
    q:ctlocIdDocType'["AN" ""
    //i (+opaId=0) s anpId="Default"
    //s anpId=..GetAnpId(opaId,ctlocIdDocType)
    
    s ctlocId=+ctlocIdDocType
    s anpId=..GetAnpIdNew(opaId,ctlocId,$p(ctlocIdDocType,ctlocId,2))

    
    s retStr="",anptSub=0
    f  s anptSub=$o(^DHCANPara(anpId,"T",anptSub)) q:anptSub=""  d
        .s anptDate=$p(^DHCANPara(anpId,"T",anptSub),"^")
        .s anptDate=$zd(anptDate,3)
        .s anptTime=$p(^DHCANPara(anpId,"T",anptSub),"^",2)
        .s anptTime=$zt(anptTime,2)
        .s anptScale=$p(^DHCANPara(anpId,"T",anptSub),"^",3)
        .s ctlocType=$p(^DHCANPara(anpId,"T",anptSub),"^",7)
        .q:ctlocIdDocType'=ctlocType
        .s userId=$p(^DHCANPara(anpId,"T",anptSub),"^",4)
        .s anptEndDate=$p(^DHCANPara(anpId,"T",anptSub),"^",8)
        .s anptEndDate=$zd(anptEndDate,3)
        .s anptEndTime=$p(^DHCANPara(anpId,"T",anptSub),"^",9)
        .s anptEndTime=$zt(anptEndTime,2)
        .s StartXCoordinate=$p(^DHCANPara(anpId,"T",anptSub),"^",10)
        .i retStr'="" s retStr=retStr_"^"
        .s retStr=retStr_anptDate_$c(3)_anptTime_$c(3)_anptScale_$c(3)_anptEndDate_$c(3)_anptEndTime_$c(3)_StartXCoordinate_$c(3)_userId
    q retStr
}

/// Creator：        ypz
/// CreatDate：      2009-09-27
/// Description：    取时间比例数据
/// Table：          DHC_AN_Para,DHC_AN_ParaTimeScale
/// Input：          opaId手术安排ID,ctlocIdDocType科室类型;ifClear是否清数据:1/0;userId,用户Id;anptStr输入串:分两级，第一级"^"，是每条时间比例数据。
///                 第二级$c(3)：开始日期_$c(3)_开始时间_$c(3)_比例值_$c(3)_修改人_$c(3)_修改日期_$c(3)_修改时间_$c(3)_"^"....
/// Output：       
/// Return：         返回0正常，否则提示出错信息。
ClassMethod SetTimeScale(opaId, ctlocIdDocType, userId, ifClear = 0, anptStr) As %String
{
    //s anptStr=+$h_$c(3)_1800_$c(3)_2_"^"_+$h_$c(3)_7200_$c(3)_2
    q:opaId="" 0
    q:anptStr="" 0
    q:ctlocIdDocType'["AN" 0
    //i (+opaId=0) s anpId="Default"
    //s anpId=..GetAnpId(opaId,ctlocIdDocType)
    
    s ctlocId=+ctlocIdDocType
    s anpId=..GetAnpIdNew(opaId,ctlocId,$p(ctlocIdDocType,ctlocId,2))

    s retStr=0,actNum=0
    k ^DHCANPara(anpId,"T")
    q:ifClear 0
    s num=$l(anptStr,"^")
    f i=1:1:num d
        .s curStr=$p(anptStr,"^",i)
        .q:curStr=""
        .q:+$p(curStr,$c(3),3)=0
        .s $p(^DHCANPara(anpId,"T",i),"^",1)=##class(web.DHCANOPCom).ConvertToDateH($p(curStr,$c(3),1))
        .s $p(^DHCANPara(anpId,"T",i),"^",2)=##class(web.DHCANOPCom).ConvertToTimeH($p(curStr,$c(3),2))
        .s $p(^DHCANPara(anpId,"T",i),"^",3)=+$p(curStr,$c(3),3)
        .s $p(^DHCANPara(anpId,"T",i),"^",4)=+userId
        .s $p(^DHCANPara(anpId,"T",i),"^",5)=+$h
        .s $p(^DHCANPara(anpId,"T",i),"^",6)=$p($h,",",2)
        .s $p(^DHCANPara(anpId,"T",i),"^",7)=ctlocIdDocType
        .s $p(^DHCANPara(anpId,"T",i),"^",8)=##class(web.DHCANOPCom).ConvertToDateH($p(curStr,$c(3),4))
        .s $p(^DHCANPara(anpId,"T",i),"^",9)=##class(web.DHCANOPCom).ConvertToTimeH($p(curStr,$c(3),5))
        .s $p(^DHCANPara(anpId,"T",i),"^",10)=$p(curStr,$c(3),6)
        .s actNum=actNum+1
    s ^DHCANPara(anpId,"T",0)=actNum
    q retStr
}

// d ##class(%ResultSet).RunQuery("web.DHCANCom","FindANCustomCode","PAM",0)

/// Creator：        ypz
/// CreatDate：      2009-11-02
/// Description：    取术前码表数据
/// Table：          DHC_AN_Oparrange
/// Input：          node,术前取"PAM";isAllCode为1取全部数据，为0只取有效数据。
/// Output：       
/// Return：         返回数据。
/// 
Query FindANCustomCode(node As %String, isAllData As %String) As %Query(ROWSPEC = "pieceNo:%String,isAvailable:%String,selectType:%String,valueType:%String,fieldName:%String,searchCode:%String,dataStr:%String")
{
}

ClassMethod FindANCustomCodeExecute(ByRef qHandle As %Binary, node As %String, isAllCode As %String = 1) As %Status
{
    s repid=$i(^CacheTemp)
    i node="" s qHandle=$lb(0,repid,0) q $$$OK
    s ind=1
    s pieceNo=0 
    f  s pieceNo=$o(^DHCANC(node,pieceNo))  q:pieceNo=""  d
        .s isAvailable=$p(^DHCANC(node,pieceNo),"^")
        .q:('isAllCode)&(isAvailable'="Y")
        .
        .s selectType=$p(^DHCANC(node,pieceNo),"^",2)
        .s valueType=$p(^DHCANC(node,pieceNo),"^",3)
        .s fieldName=$p(^DHCANC(node,pieceNo),"^",4)
        .s searchCode=$p(^DHCANC(node,pieceNo),"^",5)
        .s dataStr=""
        .//w node,dataNo,valueType,!
        .i selectType'="" d
            ..s dataStr=$g(^DHCANC(node,pieceNo,selectType))
        .d OutputRow
    s qHandle=$lb(0,repid,0)
    q $$$OK
OutputRow
    s Data=$lb(pieceNo,isAvailable,selectType,valueType,fieldName,searchCode,dataStr)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod FindANCustomCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANCustomCodeExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
        s AtEnd=1
        s Row=""
    }
    else      {         
        s Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod FindANCustomCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANCustomCodeExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

// 存手术病人数据，node="PAM"为术前数据，dataPara依后台定义

ClassMethod SaveCustomData(opaId, node, dataPara)
{
    q:opaId="" ""
    q:node="" ""
    q:dataPara="" ""
    s ^DHCANOPArrange(opaId,node)=dataPara //在后台？
}

// 取手术病人数据，node="PAM"为术前数据

ClassMethod GetCustomData(opaId, node)
{
    q:opaId="" ""
    q:node="" ""
    q ^DHCANOPArrange(opaId,node) //在前台？
}

ClassMethod GetOPArrangeChildSub(parref As %String, node As %String) As %String
{
    q:parref="" ""
    s childSub=""
    s childSub=$o(^DHCANOPArrange(parref,node,childSub))
    q childSub
}

ClassMethod GetAnalgesiaDrugChildSub(paaParref As %String, paaChildSub As %String) As %String
{
    q:parref="" ""
    s childSub=""
    s childSub=$o(^DHCANOPArrange(paaParref,"PAA",paaChildSub,"D",childSub))
    q childSub
}

ClassMethod SetPreAssessmentInfo(opaId, assessmentInfo = "") As %String
{
    q:(+opaId=0) "手术申请号不能为空！"
    q:$d(^DHCANOPArrange(opaId))<1 "申请号有误！"
    s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
    s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    s $P(^OR(EpisodeID,"ANA",anaSub),"^",26)=$p(assessmentInfo,$c(3),1)
    q 0
}

ClassMethod GetPreAssessmentInfo(opaId) As %String
{
    q:(+opaId=0) "手术申请号不能为空！"
    q:$d(^DHCANOPArrange(opaId))<1 "申请号有误！"
    s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
    s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    s retStr=$P(^OR(EpisodeID,"ANA",anaSub),"^",26)
    q retStr
}

/// Creator：        ypz
/// CreatDate：      2010-07-22
/// Description：    根据手术排班ID，保存交班信息
/// Table：          DHC_AN_Oparrange,DHC_AN_Shift
/// Input：          opaId手术排班Id，shiftCtcpId交班用户Id，reliefCtcpId接班用户Id, ansType交班类型, ansCareProvType交班医护人员类型
/// Return：         0:保存成功，其它为出错信息。
ClassMethod SaveAnaShift(opaId, shiftCtcpId, reliefCtcpId, ansType, ansCareProvType, ansSub = "") As %String
{
    q:(+opaId=0) "手术申请号不能为空！"
    q:$d(^DHCANOPArrange(opaId))<1 "申请号有误!"
    q:##class(web.DHCANOPCom).GetNameById(shiftCtcpId)="" "交班用户Id有误!" //'$d(^CTPCP(shiftCtcpId,1))
    q:##class(web.DHCANOPCom).GetNameById(reliefCtcpId)="" "接班用户Id有误!" //'$d(^CTPCP(reliefCtcpId,1)) "接班用户Id有误!"
    q:("^AI^TI^T^TO^PI^P^W^I^AO^")'[("^"_ansType_"^") "交班类型错!"
    q:("^A^SA^AA^PA^SN^CN^PN^")'[("^"_ansCareProvType_"^") "交班医护人员类型错!"
    
    k PLIST
    s retStr=0
    
    i ansSub'="" d
        .s ansId=opaId_"||"_ansSub
        .&sql(Select * INTO :PLIST() From DHC_AN_Shift where ANS_RowId=:ansId)
        .i SQLCODE s retStr="读取数据失败! SQLCode="_SQLCODE q
    i retStr'=0 q retStr
    s PLIST(3)=ansType
    s PLIST(18)=shiftCtcpId
    s PLIST(19)=reliefCtcpId
    s PLIST(20)=+$h
    s PLIST(21)=$p($h,",",2)
    s PLIST(41)=ansCareProvType
    i ansSub'="" d
        .&SQL(Update DHC_AN_Shift values :PLIST() where ANS_RowId=:ansId)
        .i SQLCODE s retStr="修改失败! SQLCode="_SQLCODE
    e  d
        .s PLIST(0)=opaId
        .&SQL(Insert into DHC_AN_Shift values :PLIST())
        .i SQLCODE s retStr="插入失败! SQLCode="_SQLCODE
    q retStr
}

/// Creator：        ypz
/// CreatDate：      2010-07-22
/// Description：    根据手术排班ID，保存交班信息
/// Table：          DHC_AN_Oparrange,DHC_AN_Shift
/// Input：          opaId手术排班Id，shiftCtcpId交班用户Id，reliefCtcpId接班用户Id, ansType交班类型, ansCareProvType交班医护人员类型
/// Return：         0:保存成功，其它为出错信息。
ClassMethod SaveAnArrangeShift(opaId, shiftCtcpId, reliefCtcpId, ansType, ansCareProvType, ansSub = "", shiftDate, shiftTime) As %String
{
    q:(+opaId=0) "手术申请号不能为空！"
    q:$d(^DHCANOPArrange(opaId))<1 "申请号有误!"
    q:##class(web.DHCANOPCom).GetNameById(shiftCtcpId)="" "交班用户Id有误!" //'$d(^CTPCP(shiftCtcpId,1))
    q:##class(web.DHCANOPCom).GetNameById(reliefCtcpId)="" "接班用户Id有误!" //'$d(^CTPCP(reliefCtcpId,1)) "接班用户Id有误!"
    q:("^AI^TI^T^TO^PI^P^W^I^AO^")'[("^"_ansType_"^") "交班类型错!"
    q:("^A^SA^AA^PA^SN^CN^PN^")'[("^"_ansCareProvType_"^") "交班医护人员类型错!"
    
    i shiftDate'=""  s curShiftDate=$zdh(shiftDate,3)
    e  s curShiftDate=+$h
    i shiftTime'="" s curShiftTime=$zth(shiftTime,3)
    e  s curShiftTime=$p($h,",",2)
    
    k PLIST
    s retStr=0
    
    i ansSub'="" d
        .s ansId=opaId_"||"_ansSub
        .&sql(Select * INTO :PLIST() From DHC_AN_Shift where ANS_RowId=:ansId)
        .i SQLCODE s retStr="读取数据失败! SQLCode="_SQLCODE q
    i retStr'=0 q retStr
    s PLIST(3)=ansType
    s PLIST(18)=shiftCtcpId
    s PLIST(19)=reliefCtcpId
    s PLIST(20)=curShiftDate
    s PLIST(21)=curShiftTime
    s PLIST(41)=ansCareProvType
    i ansSub'="" d
        .&SQL(Update DHC_AN_Shift values :PLIST() where ANS_RowId=:ansId)
        .i SQLCODE s retStr="修改失败! SQLCode="_SQLCODE
    e  d
        .s PLIST(0)=opaId
        .&SQL(Insert into DHC_AN_Shift values :PLIST())
        .i SQLCODE s retStr="插入失败! SQLCode="_SQLCODE
    q retStr
}

/// Creator：        ypz
/// CreatDate：      2010-07-22
/// Description：    根据手术排班ID取交班信息
/// Table：          DHC_AN_Oparrange,DHC_AN_Shift
/// Input：          opaId手术排班Id
/// Return：         返回:用"^"分割，第二级是以$c(3)分割，第1个是交班分类:AI术前,TI入室,T术中,TO离室,PI入恢复室,P恢复室,W入病房,I入ICU,AO其它术后。
///                 第16个是交班人ID，第17个是接班人ID，第18个是交班日期，第19个是交班时间
///                 第39个是交班医护人员类型:A麻醉医生,SA麻醉指导医生,AA麻醉助手,PA恢复室麻醉医生,SN器械护士,CN巡回护士,PN恢复室护士
ClassMethod GetAnaShift(opaId) As %String
{
    q:(+opaId=0) "手术申请号不能为空！"
    q:$d(^DHCANOPArrange(opaId))<1 "申请号有误！"
    s retStr=""
    s ansSub=0
    f  s ansSub=$o(^DHCANOPArrange(opaId,"Shift",ansSub)) q:ansSub=""  d
        .i retStr'="" s retStr=retStr_"^"
        .s ansStr=$tr(^DHCANOPArrange(opaId,"Shift",ansSub),"^",$c(3))
        .s $p(ansStr,$c(3),39)=$p(ansStr,$c(3),39)
        .i $p(ansStr,$c(3),18)'="" d
            ..s $p(ansStr,$c(3),18)=$zd($p(ansStr,$c(3),18),3)
            ..s $p(ansStr,$c(3),19)=$zt($p(ansStr,$c(3),19),2)
        .s retStr=retStr_ansSub_$c(3)_ansStr
    q retStr
}

ClassMethod GetPacByNode(node) As %String
{
    q:node="" ""
    s resStr="",id=0
    f  s id=$o(^PAC(node,id)) q:id=""  d
        .s desc=$p(^PAC(node,id),"^",2)
        .i resStr'="" s resStr=resStr_"^"
        .s resStr=resStr_id_$c(3)_desc
    q resStr
}

/// 返回值：入手术科室日期^入手术科室时间^离手术科室日期^离手术科室时间^入手术间日期^时间^离手术间日期^时间^麻醉开始日期^时间
///             ^麻醉结束日期^时间^手术开始日期^时间^手术结束日期^时间^气管插管日期^时间^气管拔管日期^时间
///             ^入PACU日期^时间^离PACU日期^时间^离手术室去向
ClassMethod GetANDateTime(opaId As %String) As %String
{
    q:opaId="" ""
    q:'$d(^DHCANOPArrange(opaId)) ""
    s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
    q:("AD"[opaStatus) "手术状态不对!"
    s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
    s anaSub=$p(anaId,"||",2)
    q:anaSub="" "麻醉指针错!"
    
    s anaAreaInDate=##class(web.DHCANOPCom).ConvertToDate($p(^OR(+anaId,"ANA",anaSub),"^",35),"")
    s anaAreaInTime=##class(web.DHCANOPCom).ConvertToTime($p(^OR(+anaId,"ANA",anaSub),"^",36),"")
    s anaAreaOutDate=##class(web.DHCANOPCom).ConvertToDate($p(^OR(+anaId,"ANA",anaSub),"^",37),"")
    s anaAreaOutTime=##class(web.DHCANOPCom).ConvertToTime($p(^OR(+anaId,"ANA",anaSub),"^",38),"")

    s anaTheatreInDate=##class(web.DHCANOPCom).ConvertToDate($p(^OR(+anaId,"ANA",anaSub),"^",39),"")
    s anaTheatreInTime=##class(web.DHCANOPCom).ConvertToTime($p(^OR(+anaId,"ANA",anaSub),"^",40),"")
    s anaTheatreOutDate=##class(web.DHCANOPCom).ConvertToDate($p(^OR(+anaId,"ANA",anaSub),"^",41),"")
    s anaTheatreOutTime=##class(web.DHCANOPCom).ConvertToTime($p(^OR(+anaId,"ANA",anaSub),"^",42),"")
    
    s anaStartDate=##class(web.DHCANOPCom).ConvertToDate($p(^OR(+anaId,"ANA",anaSub),"^",2),"")
    s anaAnaStartTime=##class(web.DHCANOPCom).ConvertToTime($p(^OR(+anaId,"ANA",anaSub),"^",3),"")
    s anaFinishDate=##class(web.DHCANOPCom).ConvertToDate($p(^OR(+anaId,"ANA",anaSub),"^",29),"")
    s anaAnaFinishTime=##class(web.DHCANOPCom).ConvertToTime($p(^OR(+anaId,"ANA",anaSub),"^",4),"")
    
    s surgStartDate=anaStartDate
    i surgStartDate="" s surgStartDate=anaTheatreInDate
    s anaSurgStartTime=##class(web.DHCANOPCom).ConvertToTime($p(^OR(+anaId,"ANA",anaSub),"^",19),"")
    i anaSurgStartTime'="" d
        .i $p(^OR(+anaId,"ANA",anaSub),"^",19)<$p(^OR(+anaId,"ANA",anaSub),"^",3) d
            ..s surgStartDate=##class(web.DHCANOPCom).ConvertToDate($p(^OR(+anaId,"ANA",anaSub),"^",2)+1,"")
    s surgFinishDate=anaFinishDate
    s anaSurgFinishTime=##class(web.DHCANOPCom).ConvertToTime($p(^OR(+anaId,"ANA",anaSub),"^",20),"")
    i anaSurgFinishTime'="" d
        .i $p(^OR(+anaId,"ANA",anaSub),"^",4)'="" d   ///保证麻醉结束不为空才有资格进行比较  YuanLin  20170705
          ..i $p(^OR(+anaId,"ANA",anaSub),"^",20)>$p(^OR(+anaId,"ANA",anaSub),"^",4) d
            ...s surgStartDate=##class(web.DHCANOPCom).ConvertToDate($p(^OR(+anaId,"ANA",anaSub),"^",2)-1,"")
    
    s aniIntubationInDate=##class(web.DHCANOPCom).ConvertToDate($p($g(^DHCANOPArrange(opaId,"ANI",1)),"^",82),"")
    s aniIntubationInTime=##class(web.DHCANOPCom).ConvertToTime($p($g(^DHCANOPArrange(opaId,"ANI",1)),"^",83),"")
    s aniIntubationExtDate=##class(web.DHCANOPCom).ConvertToDate($p($g(^DHCANOPArrange(opaId,"ANI",1)),"^",87),"")
    s aniIntubationExtTime=##class(web.DHCANOPCom).ConvertToTime($p($g(^DHCANOPArrange(opaId,"ANI",1)),"^",88),"")
    
    s opaPACUInDate=##class(web.DHCANOPCom).ConvertToDate($p($g(^DHCANOPArrange(opaId,"PACU")),"^",6),"")
    s opaPACUInTime=##class(web.DHCANOPCom).ConvertToTime($p($g(^DHCANOPArrange(opaId,"PACU")),"^",7),"")
    s opaPACUOutDate=##class(web.DHCANOPCom).ConvertToDate($p($g(^DHCANOPArrange(opaId,"PACU")),"^",8),"")
    s opaPACUOutTime=##class(web.DHCANOPCom).ConvertToTime($p($g(^DHCANOPArrange(opaId,"PACU")),"^",9),"")
    
    i (opaPACUInDate="") s opaPACUInDate=anaTheatreOutDate
    i (opaPACUInTime="") s opaPACUInTime=anaTheatreOutTime
    
    s aniTheatreTransferTo=$p($g(^DHCANOPArrange(opaId,"ANI",1)),"^",101)
    i (aniTheatreTransferTo="")  d
    .s aniTheatreTransferTo=##class(web.DHCANOPData).GetSurgeonDescription(opaId,"HUI")
    
    s retStr=anaAreaInDate_"^"_anaAreaInTime_"^"_anaAreaOutDate_"^"_anaAreaOutTime
    s retStr=retStr_"^"_anaTheatreInDate_"^"_anaTheatreInTime_"^"_anaTheatreOutDate_"^"_anaTheatreOutTime
    s retStr=retStr_"^"_anaStartDate_"^"_anaAnaStartTime_"^"_anaFinishDate_"^"_anaAnaFinishTime
    s retStr=retStr_"^"_surgStartDate_"^"_anaSurgStartTime_"^"_surgFinishDate_"^"_anaSurgFinishTime
    s retStr=retStr_"^"_aniIntubationInDate_"^"_aniIntubationInTime_"^"_aniIntubationExtDate_"^"_aniIntubationExtTime
    s retStr=retStr_"^"_opaPACUInDate_"^"_opaPACUInTime_"^"_opaPACUOutDate_"^"_opaPACUOutTime
    s retStr=retStr_"^"_aniTheatreTransferTo
    
    q retStr
}

/// 入参dateTimeStr:入手术科室日期^入手术科室时间^离手术科室日期^离手术科室时间^入手术间日期^时间^离手术间日期^时间^麻醉开始日期^时间
///                 ^麻醉结束日期^时间^手术开始日期^时间^手术结束日期^时间^气管插管日期^时间^气管拔管日期^时间
///                 ^入PACU日期^时间^离PACU日期^时间^离手术室去向
ClassMethod SetANDateTime(opaId As %String, dateTimeStr As %String) As %String
{
    q:opaId="" "排班号ID错!"
    
    q:'$d(^DHCANOPArrange(opaId)) "没有排班数据!"
    s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
    q:("AD"[opaStatus) "手术状态不对!"
    s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
    s anaSub=$p(anaId,"||",2)
    q:anaSub="" "麻醉指针错!"
    s anaAreaInDate=##class(web.DHCANOPCom).ConvertToDateH($p(dateTimeStr,"^",1),"")
    s anaAreaInTime=##class(web.DHCANOPCom).ConvertToTimeH($p(dateTimeStr,"^",2),"")
    s anaAreaOutDate=##class(web.DHCANOPCom).ConvertToDateH($p(dateTimeStr,"^",3),"")
    s anaAreaOutTime=##class(web.DHCANOPCom).ConvertToTimeH($p(dateTimeStr,"^",4),"")
    //q:##class(web.DHCANOPCom).CompareDateTime(anaAreaInDate,anaAreaInTime,anaAreaOutDate,anaAreaOutTime)>-1 "入手术室时间不能晚于离手术室时间!"
    
    s anaTheatreInDate=##class(web.DHCANOPCom).ConvertToDateH($p(dateTimeStr,"^",5),"")
    s anaTheatreInTime=##class(web.DHCANOPCom).ConvertToTimeH($p(dateTimeStr,"^",6),"")
    s anaTheatreOutDate=##class(web.DHCANOPCom).ConvertToDateH($p(dateTimeStr,"^",7),"")
    s anaTheatreOutTime=##class(web.DHCANOPCom).ConvertToTimeH($p(dateTimeStr,"^",8),"")
    //q:##class(web.DHCANOPCom).CompareDateTime(anaTheatreInDate,anaTheatreInTime,anaTheatreOutDate,anaTheatreOutTime)>-1 "入手术间时间不能晚于离手术间时间!"
    
    s anaStartDate=##class(web.DHCANOPCom).ConvertToDateH($p(dateTimeStr,"^",9),"")
    s anaAnaStartTime=##class(web.DHCANOPCom).ConvertToTimeH($p(dateTimeStr,"^",10),"")
    s anaFinishDate=##class(web.DHCANOPCom).ConvertToDateH($p(dateTimeStr,"^",11),"")
    s anaAnaFinishTime=##class(web.DHCANOPCom).ConvertToTimeH($p(dateTimeStr,"^",12),"")
    //q:(anaFinishDate'="")&(##class(web.DHCANOPCom).CompareDateTime(anaStartDate,anaAnaStartTime,anaFinishDate,anaAnaFinishTime)>-1) "麻醉开始时间不能晚于麻醉结束时间!"
    
    s surgStartDate=$p(dateTimeStr,"^",13)
    s anaSurgStartTime=##class(web.DHCANOPCom).ConvertToTimeH($p(dateTimeStr,"^",14),"")
    s surgFinishDate=$p(dateTimeStr,"^",15)
    s anaSurgFinishTime=##class(web.DHCANOPCom).ConvertToTimeH($p(dateTimeStr,"^",16),"")
    //q:##class(web.DHCANOPCom).CompareDateTime(surgStartDate,anaSurgStartTime,surgFinishDate,anaSurgFinishTime)>-1 "手术开始时间不能晚于手术结束时间!"
    
    s aniIntubationInDate=##class(web.DHCANOPCom).ConvertToDateH($p(dateTimeStr,"^",17),"")
    s aniIntubationInTime=##class(web.DHCANOPCom).ConvertToTimeH($p(dateTimeStr,"^",18),"")
    s aniIntubationExtDate=##class(web.DHCANOPCom).ConvertToDateH($p(dateTimeStr,"^",19),"")
    s aniIntubationExtTime=##class(web.DHCANOPCom).ConvertToTimeH($p(dateTimeStr,"^",20),"")
    //q:##class(web.DHCANOPCom).CompareDateTime(aniIntubationInDate,aniIntubationInTime,aniIntubationExtDate,aniIntubationExtTime)>-1 "插管时间不能晚于拔管时间!"
    
    s opaPACUInDate=##class(web.DHCANOPCom).ConvertToDateH($p(dateTimeStr,"^",21),"")
    s opaPACUInTime=##class(web.DHCANOPCom).ConvertToTimeH($p(dateTimeStr,"^",22),"")
    s opaPACUOutDate=##class(web.DHCANOPCom).ConvertToDateH($p(dateTimeStr,"^",23),"")
    s opaPACUOutTime=##class(web.DHCANOPCom).ConvertToTimeH($p(dateTimeStr,"^",24),"")
    //q:##class(web.DHCANOPCom).CompareDateTime(opaPACUInDate,opaPACUInTime,opaPACUOutDate,opaPACUOutTime)>-1 "入恢复室时间不能晚于离恢复室时间!"
    
    ////
    i anaAreaInDate'="" s $p(^OR(+anaId,"ANA",anaSub),"^",35)=anaAreaInDate
    i anaAreaInTime'="" s $p(^OR(+anaId,"ANA",anaSub),"^",36)=anaAreaInTime
    i anaAreaOutDate'="" s $p(^OR(+anaId,"ANA",anaSub),"^",37)=anaAreaOutDate
    i anaAreaOutTime'="" s $p(^OR(+anaId,"ANA",anaSub),"^",38)=anaAreaOutTime
    
    ;i anaTheatreInDate'="" s $p(^OR(+anaId,"ANA",anaSub),"^",39)=anaTheatreInDate
    ;i anaTheatreInTime'="" s $p(^OR(+anaId,"ANA",anaSub),"^",40)=anaTheatreInTime
    ;i anaTheatreOutDate'="" s $p(^OR(+anaId,"ANA",anaSub),"^",41)=anaTheatreOutDate
    ;i anaTheatreOutTime'="" s $p(^OR(+anaId,"ANA",anaSub),"^",42)=anaTheatreOutTime

    i anaStartDate'="" s $p(^OR(+anaId,"ANA",anaSub),"^",2)=anaStartDate
    i anaAnaStartTime'="" s $p(^OR(+anaId,"ANA",anaSub),"^",3)=anaAnaStartTime
    i anaFinishDate'="" s $p(^OR(+anaId,"ANA",anaSub),"^",29)=anaFinishDate
    i anaAnaFinishTime'="" s $p(^OR(+anaId,"ANA",anaSub),"^",4)=anaAnaFinishTime
    
    i anaSurgStartTime'="" s $p(^OR(+anaId,"ANA",anaSub),"^",19)=anaSurgStartTime
    i anaSurgFinishTime'="" s $p(^OR(+anaId,"ANA",anaSub),"^",20)=anaSurgFinishTime

    i aniIntubationInDate'="" s $p(^DHCANOPArrange(opaId,"ANI",1),"^",82)=aniIntubationInDate
    i aniIntubationInTime'="" s $p(^DHCANOPArrange(opaId,"ANI",1),"^",83)=aniIntubationInTime
    i aniIntubationExtDate'="" s $p(^DHCANOPArrange(opaId,"ANI",1),"^",87)=aniIntubationExtDate
    i aniIntubationExtTime'="" s $p(^DHCANOPArrange(opaId,"ANI",1),"^",88)=aniIntubationExtTime
    
    //由手麻进行的"出入PACU"的操作,不再授权初始化恢复室记录单时间轴   YuanLin  20170706
    ;i opaPACUInDate'="" s $p(^DHCANOPArrange(opaId,"PACU"),"^",6)=opaPACUInDate
    ;i opaPACUInTime'="" s $p(^DHCANOPArrange(opaId,"PACU"),"^",7)=opaPACUInTime
    ;i opaPACUOutDate'="" s $p(^DHCANOPArrange(opaId,"PACU"),"^",8)=opaPACUOutDate
    ;i opaPACUOutTime'="" s $p(^DHCANOPArrange(opaId,"PACU"),"^",9)=opaPACUOutTime
    
    ;s $p(^DHCANOPArrange(opaId,"ANI",1),"^",101)=$p(dateTimeStr,"^",25)
    
    q 0
}

// w ##class(web.DHCANCom).SendAnRecord("123456")

ClassMethod SendAnRecord(record As %String) As %String
{
    q:record="" ""
    Set recordList=""
    Set Str=""
    Set recordList=recordList_"<AnaRecordeBill>"
    Set recordList=recordList_"<ApplyId>"_$p(record,$c(3),1)_"</ApplyId>"
    Set recordList=recordList_"<OperArrangeId>"_$p(record,$c(3),2)_"</OperArrangeId>"
    Set recordList=recordList_"<PreOperativeDiagnosis>"_$p(record,$c(3),3)_"</PreOperativeDiagnosis>"
    Set recordList=recordList_"<PostOperativeDiagnosis>"_$p(record,$c(3),4)_"</PostOperativeDiagnosis>"
    Set recordList=recordList_"<SimulativeMainSurgery>"_$p(record,$c(3),5)_"</SimulativeMainSurgery>"
    Set recordList=recordList_"<SimulativeSubSurgery>"_$p(record,$c(3),6)_"</SimulativeSubSurgery>"
    Set recordList=recordList_"<PerformedMainSurgery>"_$p(record,$c(3),7)_"</PerformedMainSurgery>"
    Set recordList=recordList_"<PerformedSubSurgery>"_$p(record,$c(3),8)_"</PerformedSubSurgery>"
    Set recordList=recordList_"<SimulativeAnaMethod>"_$p(record,$c(3),9)_"</SimulativeAnaMethod>"
    Set recordList=recordList_"<PerformedAnaMethod>"_$p(record,$c(3),10)_"</PerformedAnaMethod>"
    Set recordList=recordList_"<ASAClassification>"_$p(record,$c(3),11)_"</ASAClassification>"
    Set recordList=recordList_"<AnaClassification>"_$p(record,$c(3),12)_"</AnaClassification>"
    Set recordList=recordList_"<BodyPosition>"_$p(record,$c(3),13)_"</BodyPosition>"
    Set recordList=recordList_"<Weight>"_$p(record,$c(3),14)_"</Weight>"
    Set recordList=recordList_"<Height>"_$p(record,$c(3),15)_"</Height>"
    Set recordList=recordList_"<InRoomDateTime>"_$p(record,$c(3),16)_"</InRoomDateTime>"
    Set recordList=recordList_"<AnaStartDateTime>"_$p(record,$c(3),17)_"</AnaStartDateTime>"
    Set recordList=recordList_"<OperStartDateTime>"_$p(record,$c(3),18)_"</OperStartDateTime>"
    Set recordList=recordList_"<OperEndDateTime>"_$p(record,$c(3),19)_"</OperEndDateTime>"
    Set recordList=recordList_"<IntubatedDateTime>"_$p(record,$c(3),20)_"</IntubatedDateTime>"
    Set recordList=recordList_"<ExtubateDateTime>"_$p(record,$c(3),21)_"</ExtubateDateTime>"
    Set recordList=recordList_"<OutRoomDateTime>"_$p(record,$c(3),22)_"</OutRoomDateTime>"
    Set recordList=recordList_"<Whereabouts>"_$p(record,$c(3),23)_"</Whereabouts>"
    Set recordList=recordList_"<InPACUDateTime>"_$p(record,$c(3),24)_"</InPACUDateTime>"
    Set recordList=recordList_"<OutPACUDateTime>"_$p(record,$c(3),25)_"</OutPACUDateTime>"
    Set recordList=recordList_"<AnaExpert>"_$p(record,$c(3),26)_"</AnaExpert>"
    Set recordList=recordList_"<Anesthesiologist>"_$p(record,$c(3),27)_"</Anesthesiologist>"
    Set recordList=recordList_"<AnaAssistant>"_$p(record,$c(3),28)_"</AnaAssistant>"
    Set recordList=recordList_"<SurgeryExpert>"_$p(record,$c(3),29)_"</SurgeryExpert>"
    Set recordList=recordList_"<SurgeryDoctor>"_$p(record,$c(3),30)_"</SurgeryDoctor>"
    Set recordList=recordList_"<ScrubNurses>"_$p(record,$c(3),31)_"</ScrubNurses>"
    Set recordList=recordList_"<IsValid>"_$p(record,$c(3),32)_"</IsValid>"
    Set recordList=recordList_"</AnaRecordeBill>"
    Set ^TMPCCQ("Test")=recordList
    Set recordList="<Request>"_recordList_"</Request>"
    Set Str=recordList
    s StreamTarStr=##class(%GlobalCharacterStream).%New()
    s StreamSendTarFlag=##class(%GlobalCharacterStream).%New()
    d StreamTarStr.Write(Str)
    s obj=##class(web.DHCENS.WebService.DHCSoap).%New()
    s StreamSendTarFlag=obj.DhcService("AnaRecordeBill",StreamTarStr)
    d StreamSendTarFlag.Rewind()
    s Len=StreamSendTarFlag.SizeGet()
    d StreamSendTarFlag.Rewind()
    s SendTarFlag=StreamSendTarFlag.Read(Len)
    Set SendTarFlag=$P(SendTarFlag,"Returncode>",2)
    q SendTarFlag
}

ClassMethod SetAutoCreateDataState(opaId As %String, paraString As %String) As %String
{
    s paraCount=$l(paraString,"^")
    f i=1:1:paraCount d
    .s paraItem=$p(paraString,"^",i)
    .s itemCode=$p(paraItem,$c(3),1)
    .s itemActive=$p(paraItem,$c(3),2)
    .s itemInterval=$p(paraItem,$c(3),3)
    .s ^DHCAN(+opaId,"AutoCreateData",itemCode)=itemActive_"^"_itemInterval
    q "0"
}

ClassMethod GetAutoCreateDataState(opaId As %String) As %String
{
    s itemCode=""
    s ret=""
    f  s itemCode=$o(^DHCAN(+opaId,"AutoCreateData",itemCode)) q:itemCode=""  d
    .i ret'="" s ret=ret_"^"
    .s itemActive=$p(^DHCAN(+opaId,"AutoCreateData",itemCode),"^",1)
    .s itemInterval=$p(^DHCAN(+opaId,"AutoCreateData",itemCode),"^",2)
    .s ret=ret_itemCode_$c(3)_itemActive_$c(3)_itemInterval
    
    q ret
}

/// 获取事件之前的生命体征  After,Before  TheatreIn,TheatreOut,AnaEnd
/// w ##class(web.DHCANCom).GetOutRoomVitalSigns("7530","TheatreIn","NIBPs","After")
ClassMethod GetOutRoomVitalSigns(opaId As %String, EventCode As %String, VSCode As %String, SType As %String) As %String
{
    q:opaId="" ""
    k ^TempVS("Dif",$j)
    s eventId=$o(^DHCANC("ComOrd",0,"TypeCode","E",EventCode,""))
    q:eventId="" ""
    s eventSdate="",eventStime="",eventEdate="",eventEtime=""
    s datedif=0,timedif=0,dif=0,mindif=""
    s eventRowId="" f  s eventRowId=$o(^DHCANOrder(0,"CommOrd",eventId,opaId,eventRowId)) q:eventRowId=""  d
    .s eventFlag=$p($G(^DHCANOrder(eventRowId)),"^",17)
    .q:eventFlag'="N"
    .s eventSdate=$p(^DHCANOrder(eventRowId),"^",5)
    .s eventStime=$p(^DHCANOrder(eventRowId),"^",6)
    .s eventEdate=$p(^DHCANOrder(eventRowId),"^",7)
    .s eventEtime=$p(^DHCANOrder(eventRowId),"^",8)
    s anoRowId="" f  s anoRowId=$o(^DHCANOrder(0,"OPApp",opaId,anoRowId)) q:anoRowId=""  d
    .s anoEditFlag=$p($G(^DHCANOrder(anoRowId)),"^",25)
    .q:anoEditFlag'="N"
    .s anoType=$p($G(^DHCANOrder(anoRowId)),"^",30)
    .q:anoType'="V"
    .s anoSdate=$p(^DHCANOrder(anoRowId),"^",5)  //生命体征时间
    .i SType="Before" s datedif=eventSdate-anoSdate
    .e  s datedif=anoSdate-eventSdate
    .q:datedif<0
    .s anoStime=$p(^DHCANOrder(anoRowId),"^",6)
    .i SType="Before" s timedif=eventStime-anoStime
    .e  s timedif=anoStime-eventStime
    .s dif=datedif*86400+timedif
    .q:dif<0
    .;s anoEdate=$p(^DHCANOrder(anoRowId),"^",7)
    .;s anoEtime=$p(^DHCANOrder(anoRowId),"^",8)
    .s ancodr=$p(^DHCANOrder(anoRowId),"^",2)
    .s ancocode=$p(^DHCANC("ComOrd",ancodr),"^",1)
    .q:VSCode'=ancocode
    .s anoqty=$p(^DHCANOrder(anoRowId),"^",11)
    .i mindif="" d
    ..s mindif=dif
    ..s ^TempVS("Dif",$j,opaId,ancocode)=anoqty
    .i dif<mindif d
    ..s mindif=dif
    ..s ^TempVS("Dif",$j,opaId,ancocode)=anoqty
    
    s PABPSystolic=$P($g(^DHCANOPArrange(opaId,"PA")),"^",61)
    s PABPDiastolic=$P($g(^DHCANOPArrange(opaId,"PA")),"^",62)  
    s PAHeartRate=$P($g(^DHCANOPArrange(opaId,"PA")),"^",59)
    s PARespRate=$P($g(^DHCANOPArrange(opaId,"PA")),"^",63)
    i (VSCode="NIBPs")&(EventCode="TheatreIn")&((PABPSystolic="")!(PABPSystolic=0)) s $P(^DHCANOPArrange(opaId,"PA"),"^",61)=$g(^TempVS("Dif",$j,opaId,"NIBPs"))
    i (VSCode="NIBPd")&(EventCode="TheatreIn")&((PABPDiastolic="")!(PABPDiastolic=0)) s $P(^DHCANOPArrange(opaId,"PA"),"^",62)=$g(^TempVS("Dif",$j,opaId,"NIBPd"))
    i (VSCode="PULSE")&(EventCode="TheatreIn")&((PAHeartRate="")!(PAHeartRate=0)) s $P(^DHCANOPArrange(opaId,"PA"),"^",59)=$g(^TempVS("Dif",$j,opaId,"PULSE"))
    i (VSCode="zzhx")&(EventCode="TheatreIn")&((PARespRate="")!(PARespRate=0)) s $P(^DHCANOPArrange(opaId,"PA"),"^",63)=$g(^TempVS("Dif",$j,opaId,"zzhx"))
    
    q $g(^TempVS("Dif",$j,opaId,VSCode))
}

/// ck 20120709 调电子病历术前访视接口，并将值写到手术排班表中
/// $LB(体重,血型,急诊/择期手术,术前禁食,血压,脉搏,呼吸,ASA分级)
/// 急诊/择期手术 从手术申请中取，不从电子病历取值
/// w ##class(web.DHCANCom).GetPreoperativeRecordInfo(7384)
ClassMethod GetPreoperativeRecordInfo(opaId As %String) As %String
{
    q:opaId="" "-1"
    s retList=""
    s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
    //s retList=##Class(EPRservice.BIL.Special.BIToAN).GetPreoperativeRecordInfo(EpisodeID)
    q:retList="" "-1"
    s OPAPatWeight=$li(retList,1)
    s OPABloodTypeDr=$li(retList,2)
    s AnaSourceType=$li(retList,3)
    s OPAPreOperPatTeaching=$li(retList,4)
    s OPAPABPSystolic=$p($li(retList,5),"/",1)
    s OPAPABPDiastolic=$p($li(retList,5),"/",2)
    s OPAPAHeartRate=$li(retList,6)
    s OPAPARespRate=$li(retList,7)
    s ASAClass=$li(retList,8)
    
    ;s PatWeight=$P(^DHCANOPArrange(opaId),"^",24)
    ;s BloodTypeDr=$P(^DHCANOPArrange(opaId),"^",11)
    
    ;s PreOperPatTeaching=$P(^DHCANOPArrange(opaId),"^",70) 
    ;s PABPSystolic=$P(^DHCANOPArrange(opaId,"PA"),"^",61)
    ;s PABPDiastolic=$P(^DHCANOPArrange(opaId,"PA"),"^",62) 
    ;s PAHeartRate=$P(^DHCANOPArrange(opaId,"PA"),"^",59)
    ;s PARespRate=$P(^DHCANOPArrange(opaId,"PA"),"^",63)
    
    i $P(^DHCANOPArrange(opaId),"^",24)="" s $P(^DHCANOPArrange(opaId),"^",24)=OPAPatWeight
    i $P(^DHCANOPArrange(opaId),"^",11)="" s $P(^DHCANOPArrange(opaId),"^",11)=OPABloodTypeDr
    i $P(^DHCANOPArrange(opaId),"^",70)="" s $P(^DHCANOPArrange(opaId),"^",70)=OPAPreOperPatTeaching
    ;i $P(^DHCANOPArrange(opaId,"PA"),"^",61)="" s $P(^DHCANOPArrange(opaId,"PA"),"^",61)=OPAPABPSystolic
    ;i $P(^DHCANOPArrange(opaId,"PA"),"^",62)="" s $P(^DHCANOPArrange(opaId,"PA"),"^",62)=OPAPABPDiastolic
    ;i $P(^DHCANOPArrange(opaId,"PA"),"^",59)="" s $P(^DHCANOPArrange(opaId,"PA"),"^",59)=OPAPAHeartRate
    ;i $P(^DHCANOPArrange(opaId,"PA"),"^",63)="" s $P(^DHCANOPArrange(opaId,"PA"),"^",63)=OPAPARespRate
    
    q "0"
}

ClassMethod GetIfHaveTag(opaId As %String) As %String
{
    ;s retStr=""
    ;s anoSource=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",23)
    ;i anoSource="T" s retStr="N"
    ;e  s retStr="Y"
    s retStr=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",23)
    q retStr
}

ClassMethod SetAnaMethod(opaId, planAnmetDesc = "", anmetDesc = "")
{
    s planAnmetId=##class(web.DHCANOPCom).ConvertToAnMethodId($p(opaStr,$c(3),7),"+")
    i planAnmetId'="" s $p(^DHCANOPArrange(opaId,"PA"),"^",89)=planAnmetId
    s anmetId=##class(web.DHCANOPCom).ConvertToAnMethodId(anmetDesc,"+")
    s anaId=$p(^DHCANOPArrange(opaId),"^",2)
    s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    s $P(^OR(EpisodeID,"ANA",anaSub),"^",5)=anmetId
}

ClassMethod GetOPAANCByNode(node) As %String
{
    q:node="" ""
    s resStr="",id=0
    f  s id=$o(^DHCANC(node,id)) q:id=""  d
        .s desc=$p(^DHCANC(node,id),"^",2)
        .i resStr'="" s resStr=resStr_"^"
        .s resStr=resStr_id_$c(3)_desc
    q resStr
}

ClassMethod SendMessage(opaId) As %String
{
    //s retSendMessage=##class(web.DHCENS.EnsHISService).SendOperationSchedule(opaId)
    s retSendMessage="1^发送消息失败"
    q retSendMessage
}

ClassMethod InsertPrintRecord(opaId, title, userId, ctLocId, status, note = "") As %String
{
    q:opaId="" "无手术记录"
    q:status="" "无打印状态"
    q:userId="" "无操作人"
    s date=+$h,time=+$p($h,",",2)
    k PLIST
    TSTART
    s PLIST(2)=date
    s PLIST(3)=time
    s admId=$P(^DHCANOPArrange(opaId),"^",1)
    s PLIST(4)=admId
    s PLIST(5)=opaId
    s PLIST(8)=title
    s PLIST(9)=ctLocId
    s PLIST(10)=status
    s PLIST(11)=note
    s PLIST(12)=userId
    &SQL(Insert into DHC_CL_PrintRecord values :PLIST())
    i SQLCODE TROLLBACK
    e  TCOMMIT
    q SQLCODE
}

/// Creator：        ck
/// CreatDate：      2013-03-26
/// Description：    根据麻醉方法ID获取关联医嘱套ID
/// Table：          ORC_AnaestMethod
/// Input：          麻醉方法ID
/// Return：         医嘱套ID或空
ClassMethod GetArcosByAnMethodId(anmethodId As %String) As %String
{
 q:anmethodId="" ""
 s arcosdr=$p(^ORC("ANMET",anmethodId),"^",4)
 s dateFrom=$p(^ORC("ANMET",anmethodId),"^",5)
 s dateTo=$p(^ORC("ANMET",anmethodId),"^",6)
 q:(dateFrom>+$h)!(dateFrom="") ""
 q:(dateTo<+$h)&(dateTo'="") ""
 q arcosdr
}

/// Creator：        ck
/// CreatDate：      2013-04-21
/// Description：    通过日期获取房间手术ID
/// Table：          
/// Input：          开始日期、结束日期、房间ID
/// Return：         手术ID
ClassMethod GetRoomOpaInfo(sdate As %String, edate As %String, roomId As %String) As %String
{
    q:roomId="" ""
    i (sdate="")!(edate="") s sdate=+$H,edate=+$H
    e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(sdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(edate)
    s retstr=""
    f date=sdate:1:edate
    {   
        s opaId=""
        f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
        .q:$d(^DHCANOPArrange(opaId))<1
        .s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
        .;q:oproomdr=""
        .q:oproomdr'=roomId
        .s opordno=$P(^DHCANOPArrange(opaId),"^",26)
        .s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
        .q:(opaStatus="A")!(opaStatus="")!(opaStatus="D")!(opaStatus="N")
        .s status=""
        .i opaStatus="A" s status="申请"
        .i opaStatus="D" s status="拒绝"
        .i opaStatus="R" s status="安排"
        .i opaStatus="N" s status="非预约"
        .i opaStatus="I" s status="术中"
        .i opaStatus="P" s status="恢复室"
        .i opaStatus="L" s status="术毕"
        .i opaStatus="F" s status="完成"
        .i retstr="" s retstr=opaId
        .e  s retstr=retstr_"^"_opaId
    }   
    q retstr
}

/// d ##class(%ResultSet).RunQuery("web.DHCANCom","FindRoomOpaInfo","62941")
Query FindRoomOpaInfo(opate As %String) As %Query(ROWSPEC = "roomId,roomInfo")
{
}

ClassMethod FindRoomOpaInfoExecute(ByRef qHandle As %Binary, opate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    k ^tempOPRoom
    i opate="" s opate=+$H
    e  s opate=##Class(web.DHCANOPCom).ConvertToDateH(opate)

    s opaId=""
    f  s opaId=$O(^DHCANOPArrange(0,"SDate",opate,opaId)) q:opaId=""  d
        .q:$d(^DHCANOPArrange(opaId))<1
        .s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
        .q:oproomdr=""
        .s opordno=$P(^DHCANOPArrange(opaId),"^",26)
        .q:opordno=""
        .s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
        .q:(opaStatus="A")!(opaStatus="")!(opaStatus="D")!(opaStatus="N")
        .s admId=$P(^DHCANOPArrange(opaId),"^",1)
        .s papmiId=$p($g(^PAADM(admId)),"^",1)
        .s paadmtype=$p($g(^PAADM(admId)),"^",2)
        .s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
        .s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
        .s status=""
        .i opaStatus="A" s status="申请"
        .i opaStatus="D" s status="拒绝"
        .i opaStatus="R" s status="安排"
        .i opaStatus="N" s status="非预约"
        .i opaStatus="I" s status="术中"
        .i opaStatus="P" s status="恢复室"
        .i opaStatus="L" s status="术毕"
        .i opaStatus="F" s status="完成"
        .s opTimeStr=##class(web.DHCANCom).GetANDateTime(opaId)
        .s adm=$P($P(^DHCANOPArrange(opaId),"^",2),"||",1)
        .s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
        .s opDes="",count=0,opSub=1
        .s operType=$P(^OR(adm,"ANA",chl),"^",32) 
        .s subChl=0 f  s subChl=$O(^OR(adm,"ANA",chl,"OP",subChl)) q:(subChl="")  d
        ..s opDr=$P(^OR(adm,"ANA",chl,"OP",subChl),"^",6)
        ..i (opDr'="")&&(opDr=+opDr)  d
        ...i $P($g(^ORC("OPER",+opDr)),"^",2)'="" d
        ....i opDes'="" s opDes=opDes_";" 
        ....s opDes=opDes_$P($g(^ORC("OPER",+opDr)),"^",2)
        ..e  d
        ...i $g(^OR(adm,"ANA",chl,"OP",subChl,"REM",2))'="" d
        ....i opDes'="" s opDes=opDes_";"
        ....s opDes=opDes_$G(^OR(adm,"ANA",chl,"OP",subChl,"REM",2))
        ..s count=count+1
        ..q:count>1
        ..s opSub=subChl
        .s opDes=$tr(opDes,"*","")
        .s opDes=$tr(opDes,$c(13),"")
        .s opDes=$tr(opDes,$c(10),"")
        .s opDes=$tr(opDes," ","")
        .s docDr=$P(^OR(adm,"ANA",chl,"OP",opSub),"^",8)
        .s surgeon=""
        .i docDr'="" s surgeon=##class(web.DHCANOPCom).GetNameById(docDr)
        .e  s surgeon=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")       
        .s surgeon=$tr(surgeon,$c(13),"")
        .s surgeon=$tr(surgeon,$c(10),"")
        .s p=0,xsh1="",xsh2=""  ;洗手
        .s xsh="",xch=""
        .s xs=0 f  s xs=$O(^OR(adm,"ANA",chl,"OP",opSub,"SCN",xs)) q:(xs="")!(p=3)  d
        ..q:xs>20
        ..s xsdr=$P(^OR(adm,"ANA",chl,"OP",opSub,"SCN",xs),"^",1)
        ..q:xsdr=""
        ..s p=p+1
        ..s xsh1=xsh1_" "_##class(web.DHCANOPCom).GetNameById(xsdr)
        .s p=0
        .s xs=20 f  s xs=$O(^OR(adm,"ANA",chl,"OP",opSub,"SCN",xs)) q:(xs="")!(p=3)  d
        ..s xsdr=$P(^OR(adm,"ANA",chl,"OP",opSub,"SCN",xs),"^",1)
        ..q:xsdr=""
        ..s p=p+1
        ..s xsh2=xsh2_" "_##class(web.DHCANOPCom).GetNameById(xsdr)_"(交)"
        .s xsh=xsh1_" "_xsh2
        .s xch1="",xch2=""
        .s p=0  ;巡回
        .s xc=0 f  s xc=$O(^OR(adm,"ANA",chl,"OP",opSub,"CIRN",xc)) q:(xc="")!(p=3)   d
        ..q:xc>20
        ..s xchdr=$P(^OR(adm,"ANA",chl,"OP",opSub,"CIRN",xc),"^",1)
        ..q:xchdr=""
        ..s p=p+1  
        ..s xch1=$G(xch1)_" "_##class(web.DHCANOPCom).GetNameById(xchdr)
        .s p=0
        .s xc=20 f  s xc=$O(^OR(adm,"ANA",chl,"OP",opSub,"CIRN",xc)) q:(xc="")!(p=3)  d
        ..s xchdr=$P(^OR(adm,"ANA",chl,"OP",opSub,"CIRN",xc),"^",1)
        ..q:xchdr=""
        ..s p=p+1
        ..s xch2=xch2_" "_##class(web.DHCANOPCom).GetNameById(xchdr)_"(交)"
        .s xch=xch1_" "_xch2
        .s nurse=xsh_"#"_xch
        .s nurse=$tr(nurse,"*","")
        .s nurse=$tr(nurse,$c(13),"")
        .s nurse=$tr(nurse,$c(10),"")
        .s anDocDr=$P(^OR(adm,"ANA",chl),"^",6)                         ;ANA_Anaesthetist_Dr 
        .i anDocDr'="" d
        ..s anDoc=##class(web.DHCANOPCom).GetNameById(anDocDr)      ;麻醉医师
        .e  s anDoc=""
        .s anDirectiveDocDr=$P(^OR(adm,"ANA",chl),"^",7)
        .i anDirectiveDocDr'="" d
        ..s anDirectiveDoc=##class(web.DHCANOPCom).GetNameById(anDirectiveDocDr) ;麻醉指导医师
        .e  s anDirectiveDoc=""
        .i anDirectiveDoc'="" d
        ..s anDoc=anDoc_","_anDirectiveDoc 
        .s anDocAss=""
        .s ass=0
        .f  s ass=$o(^OR(adm,"ANA",chl,"OP",opSub,"ANASS",ass)) q:ass=""  d  
        ..s anAssDr=$p($g(^OR(adm,"ANA",chl,"OP",opSub,"ANASS",ass)),"^",1)
        ..q:anAssDr=""
        ..i anDocAss="" d
        ...s anDocAss=##class(web.DHCANOPCom).GetNameById(anAssDr)
        ..e  d
        ...s anDocAss=anDocAss_" "_##class(web.DHCANOPCom).GetNameById(anAssDr)
        .i anDocAss'="" d
        .. s anDoc=anDoc_","_anDocAss
        .s anDoc=$tr(anDoc,"*","")
        .s anDoc=$tr(anDoc,$c(13),"")
        .s anDoc=$tr(anDoc,$c(10),"")
        .s anmthdr=$P(^OR(adm,"ANA",chl),"^",5) 
        .s anmethod=""
        .i anmthdr'="" d
        ..s anmetNum=$l(anmthdr,"|")
        ..f i=1:1:anmetNum d
        ...s anmetId=$p(anmthdr,"|",i)
        ...q:anmetId=""
        ...s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
        ...i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
        ...i anmethod="" s anmethod=anmetDesc
        ...e  s anmethod=anmethod_","_anmetDesc
        .s anmethod=$tr(anmethod,"*","")
        .s anmethod=$tr(anmethod,$c(13),"")
        .s anmethod=$tr(anmethod,$c(10),"")
        .s arrTime=$P(^DHCANOPArrange(opaId),"^",8)
        .s arrDate=$P(^DHCANOPArrange(opaId),"^",7)
        .s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
        .s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
        .i arrDate="" s arrDate=opstdate
        .i arrTime="" s arrTime=opsttime
        .s arrDateTime=$ZD(arrDate,3)_" "_$ZT(arrTime,2)
        .;s opstDateTime=$ZD(opstdate,3)_" "_$ZT(opsttime,2)
        .s anaTheatreInDate=$p(opTimeStr,"^",5)
        .s anaTheatreInTime=$p(opTimeStr,"^",6)
        .s anaTheatreIn=anaTheatreInDate_" "_anaTheatreInTime
        .s anaTheatreOutDate=$p(opTimeStr,"^",7)
        .s anaTheatreOutTime=$p(opTimeStr,"^",8)
        .s opaEstiOperDuration=$p(^DHCANOPArrange(opaId),"^",37)
        .;w !,anaTheatreOutTime_"^"_opaEstiOperDuration_"^"_anaTheatreInTime
        .i (anaTheatreOutTime="")&(opaEstiOperDuration'="")&(anaTheatreInTime'="") d
        ..i ($zth(anaTheatreInTime,3)+opaEstiOperDuration)<86400 d
        ...s anaTheatreOutTime=$zt($zth(anaTheatreInTime,3)+$p(^DHCANOPArrange(opaId),"^",37))
        ..e  s anaTheatreOutTime="23:59:59"
        .i anaTheatreOutTime'="" d
        ..i anaTheatreOutDate="" s anaTheatreOutDate=anaTheatreInDate 
        .s anaTheatreOut=anaTheatreOutDate_" "_anaTheatreOutTime
        .s inRoomDateTime=""
        .s inRoomDate=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",7)
        .s inRoomTime=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",8)
        .i inRoomDate'="" s inRoomDateTime=$zd(inRoomDate,3)
        .i inRoomTime'="" s inRoomDateTime=inRoomDateTime_" "_$zt(inRoomTime,2)
        .s outRoomDateTime=""
        .s outRoomDate=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",31)
        .s outRoomTime=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",32)
        .i outRoomDate'="" s outRoomDateTime=$zd(outRoomDate,3)
        .i outRoomTime'="" s outRoomDateTime=outRoomDateTime_" "_$zt(outRoomTime,2)
        .s anaStartTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"AnaStart",1,"Y","","")
        .s anaStartTime=$p(anaStartTime,$c(3),1)
        .;s anaStartTime=##Class(web.DHCANOPCom).ConvertToTimeH(anaStartTime,"")
        .s surgeonStartTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"OperStart",1,"Y","","")
        .s surgeonStartTime=$p(surgeonStartTime,$c(3),1)
        .;s surgeonStartTime=##Class(web.DHCANOPCom).ConvertToTimeH(surgeonStartTime,"")
        .s surgeonEndTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"OperEnd",-1,"Y","","")
        .s surgeonEndTime=$p(surgeonEndTime,$c(3),1)
        .;s surgeonEndTime=##Class(web.DHCANOPCom).ConvertToTimeH(surgeonEndTime,"")
        .s anaEndTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"AnaEnd",-1,"Y","","")
        .s anaEndTime=$p(anaEndTime,$c(3),1)
        .;s anaEndTime=##Class(web.DHCANOPCom).ConvertToTimeH(anaEndTime,"")
        .s eventTime=anaStartTime_"#"_surgeonStartTime_"#"_surgeonEndTime_"#"_anaEndTime
        .s ^tempOPRoom($j,oproomdr,opordno,opaId)=status_"^"_arrDateTime_"^"_anaTheatreIn_"^"_anaTheatreOut_"^"_patName_"^"_opaStatus_"^"_inRoomDateTime_"^"_outRoomDateTime_"^"_opDes_"^"_eventTime_"^"_surgeon_"^"_nurse_"^"_anDoc_"^"_anmethod_"^"_operType
        
    s roomId="" f  s roomId=$o(^DHCANC("OPRoom",roomId)) q:roomId=""  d
    .q:$d(^DHCANC("OPRoom",roomId))<1
    .;q:$p(^DHCANC("OPRoom",roomId),"^",9)'="T"
    .s roomInfo=""
    .s ord="" f  s ord=$o(^tempOPRoom($j,roomId,ord)) q:ord=""  d
    ..s opaRowId="" f  s opaRowId=$o(^tempOPRoom($j,roomId,ord,opaRowId)) q:opaRowId=""  d
    ...s opaStat=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",1)
    ...s arrDateTime=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",2)
    ...s anaTheatreIn=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",3)
    ...s anaTheatreOut=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",4)
    ...s patname=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",5)
    ...s opaStatus=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",6)
    ...s inRoomDateTime=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",7)
    ...s outRoomDateTime=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",8)
    ...s operDesc=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",9)
    ...s eventTime=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",10)
    ...s surgeon=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",11)
    ...s nurse=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",12)
    ...s anDoc=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",13)
    ...s anmethod=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",14)
    ...s operType=$p(^tempOPRoom($j,roomId,ord,opaRowId),"^",15)
    ...i roomInfo="" s roomInfo=opaRowId_"^"_opaStat_"^"_arrDateTime_"^"_anaTheatreIn_"^"_anaTheatreOut_"^"_ord_"^"_patname_"^"_opaStatus_"^"_inRoomDateTime_"^"_outRoomDateTime_"^"_operDesc_"^"_eventTime_"^"_surgeon_"^"_nurse_"^"_anDoc_"^"_anmethod_"^"_operType
    ...e  s roomInfo=roomInfo_"*"_opaRowId_"^"_opaStat_"^"_arrDateTime_"^"_anaTheatreIn_"^"_anaTheatreOut_"^"_ord_"^"_patname_"^"_opaStatus_"^"_inRoomDateTime_"^"_outRoomDateTime_"^"_operDesc_"^"_eventTime_"^"_surgeon_"^"_nurse_"^"_anDoc_"^"_anmethod_"^"_operType
    .;i roomInfo="" s roomInfo="^^^^^^^"
    .do OutRowInfo
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutRowInfo
    set Data=$lb(roomId,roomInfo)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindRoomOpaInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRoomOpaInfoExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindRoomOpaInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRoomOpaInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：        ypz
/// CreatDate：      2009-04-20
/// Description：    保存数据到麻醉记录表中
/// Table：          DHC_AN_Order,DHC_AN_RoomEquip,DHC_AN_RoomEquipDetail
/// Input：          opaId手术安排ID,icuaId重症监护安排ID,equipId手术间设备或监护床设备ID,userId;
///                 para：分两级，第一级"^",第二级#。每条记录的数据。
///                 chanalNo_#_sttDate_"#"_sttTime_"#"_ancoType(医嘱类型)_"#"_itemValue_"%"_itemValue2_"%"_itemValue3_"#"_ctuomId_"#"_icuoId(未用)_"#"_ancvcId_"#"_oeoriId(未用)"^"....
///                     status: 当前设备任务的状态：
///                     "Unstarted"：未启动
///                     "Running"：正运行
///                     "NetOffline"：网络问题
///                     “NoData"：无数据，很可能是MOXA原因
/// Output：       
/// Return：         0-正常，其他-异常返回信息
/// 2:未插入值
/// -1: 手术安排ID和重症监护安排ID不为同时为空!
/// -2: 手术安排ID和重症监护安排ID不正确!
/// -3: 手术安排ID和重症监护安排ID不能同时有值!
/// -4: 无设备ID!
/// -5: 无数据!
/// -11:手术状态不为"I",重症监护床不为Receive或者Finish
/// -12:opaId不存在或icauId错误
/// -13:手术间设备记录不存在!
/// -14:未知设备类型
/// -23:床位号不存在
/// -110: 被另一线程占用
ClassMethod Insert2DB(opaId As %String, equipId As %String, anoSource As %String, extInfo As %String = "", dataPara As %String = "", status As %String = "") As %String
{
    
    // s opaId=620
    // s equipId=
    // s anoSource="A"
    // s extInfo=""
    // s dataPara=""
    // s status="Running"
    // w ##class(web.DHCANCom).Insert2DB(opaId,equipId,anoSource,extInfo,dataPara,status)
    s isInsert=0,devTypeId="",insertStr="" 
    q:(opaId="") -1 //"手术安排ID和重症监护安排ID不为同时为空!"
    q:(+opaId=0) -2 //"手术安排ID和重症监护安排ID不正确!"
    q:(equipId="") -4 //"无设备ID!"
    q:dataPara="" -5 //"无数据!"
    s temperatureChannelNo="TEMP0" //体温的通道号
    s ^TempLmLm("20140505","extInfo",opaId)=extInfo
    s ^tmpANDebug("InsertANOrder","input")=$ztime($p($h,",",2))_opaId_","_equipId_","_anoSource_","_extInfo_","_dataPara
    s ^TempLm("InsertANOrder","20140505",opaId,$j)=opaId_","_equipId_","_anoSource_","_extInfo_","_dataPara
    s ^TMPANMONITORDEBGUG("InsertANOrder",opaId)=equipId_"@"_dataPara           //监护仪模拟数据界面临时收集数据用,每次覆盖,有用误删  YuanLin  20170714
    s retStr=0
    i +opaId>0 d
        .i $g(^DHCANOPArrange(opaId))="" s retStr=-12 q
        .;i $p($g(^DHCANOPArrange(opaId)),"^",27)'="I" s retStr=-11 q
        .;设备状态
        .s $p(^DHCANOPArrange(opaId,"Ext"),"^",23)=$P(dataPara,"#",5)
        .
        .;s anreId=equipId //$o(^DHCANRoomEquip(0,"Equip",equipId,""))
        .;i anreId="" s retStr=-12 q //"未定义" q
        .;i '$d(^DHCANRoomEquip(anreId)) s retStr=-13 q //"手术间设备记录不存在!" q
        .i devTypeId="" s devTypeId=$p($g(^DHCANRoomEquip(equipId)),"^",5)
        .b ;equipId
        .i devTypeId="" s retStr=-14 q
        .s devCode=$p($g(^DHCANC("CType",devTypeId)),"^",1)
        .b
        .i devCode="Relay" d
        ..;RELAY|192.168.203.201|192.168.203.18|PhilipsMP
        ..s ip=$p($g(^DHCANRoomEquip(equipId)),"^",3)
        ..s devCode=$p(ip,"|",4)
        ..s devTypeId=$o(^DHCANC("CType",0,"Code",devCode,""),-1)
        ..//s ccType=$p($g(^DHCANC("CType",devTypeId)),"^",4)
        ..;s devTypeId=$o(^DHCANC("CType",0,"Code",devCode,""))
        ..//s tmpId="" f tmpId=$o(^DHCANC("CType",0,"Code",devCode,tmpId)) q:tmpId=""  d
        ..//.s itemStr=$g(^DHCANC("CType",tmpId))
        ..//.i $p(itemStr,"^",4)=ccType s devTypeId=tmpId
        ..b
        .// 如果是自动识别或模拟设备，则查找设备类型Id
        .i (((devCode="AutoCheckDev")||(devCode="TestDev"))&&(extInfo'="")) d 
        ..;查找设备类型Id
        ..s devTypeId=0
        ..s devTypeId=$o(^DHCANC("CType",0,"Code",extInfo,devTypeId))
        ..b ;b
        .i devTypeId="" s retStr=-14 q
        .s itemNum=$L(dataPara,"^")
        .f i=1:1:itemNum d
            ..q:retStr'=0
            ..s itemStr=$P(dataPara,"^",i)
            ..q:itemStr=""
            ..s anredChannelNo=$P(itemStr,"#",1)
            ..q:anredChannelNo=""
            ..s ancctiSub=$o(^DHCANC("CType",0,"ChannelNo",anredChannelNo,devTypeId,""))
            ..q:ancctiSub=""
            ..//q:'$d(^DHCANRoomEquip(0,"ChannelNo",anredChannelNo,anreId))
            ..//s anredSub="" 
            ..//f  s anredSub=$o(^DHCANRoomEquip(0,"ChannelNo",anredChannelNo,anreId,anredSub)) q:anredSub=""  d
            ..//.q:'$d(^DHCANRoomEquip(anreId,"I",anredSub))
            ..//.s ancoId=$p(^DHCANRoomEquip(anreId,"I",anredSub),"^",1)
            ..//q:$p(^DHCANC("CType",devTypeId,"I",ancctiSub),"^",3)'="Y"
            ..s ancoId=$p(^DHCANC("CType",devTypeId,"I",ancctiSub),"^",1)
            ..q:ancoId=""
            ..s ancoDesc=$p($g(^DHCANC("ComOrd",ancoId)),"^",2)
            ..s paraItemId=##class(web.DHCANCom).GetParaItemIdByComOrdId(ancoId,opaId)
            ..k PLIST
            ..s PLIST(2)=opaId
            ..s PLIST(3)=ancoId       //ANO_ANCORD_Dr
            ..s PLIST(4)=""
            ..s sttDate=$P(itemStr,"#",2)
            ..s PLIST(5)=##class(web.DHCANOPCom).ConvertToDateH(sttDate)
            ..s sttTime=$P(itemStr,"#",3)
            ..i sttTime="" s sttTime=$p($h,",",2)
            ..i $l(sttTime,":")>1 s sttTime=$zth(sttTime)
            ..s PLIST(6)=sttTime
            ..s PLIST(7)=##class(web.DHCANOPCom).ConvertToDateH(sttDate)
            ..s PLIST(8)=sttTime
            ..s itemStr=$tr(itemStr," ","")
            ..s anoQtyStr=$P(itemStr,"#",5)
            
            ..s PLIST(10)="",PLIST(11)=""
            ..s field=$p($g(^DHCANC("ComOrd",ancoId)),"^",24)
            ..i field="Qty" s PLIST(11)=$P(anoQtyStr,"%",1) //ANO_Qty
            ..e  i field="Note" s PLIST(10)=anoQtyStr 
            ..//s PLIST(11)=$P(anoQtyStr,"%",1) //ANO_Qty
            ..//q:(PLIST(11)="")!(PLIST(11)["-")
            ..i (anredChannelNo=temperatureChannelNo)&(PLIST(11)>100) s PLIST(11)=PLIST(11)/10
            ..q:(anredChannelNo=temperatureChannelNo)&((PLIST(11)>42)!(PLIST(11)<30))
            ..s PLIST(32)=$P(anoQtyStr,"%",2) //ANO_Qty2
            ..i (PLIST(32)["-") s PLIST(32)=""
            ..s PLIST(33)=$P(anoQtyStr,"%",3) //ANO_Qty3
            ..i (PLIST(33)["-") s PLIST(33)=""
            ..s ctuomId=$P(itemStr,"#",6)
            ..i ctuomId="" s ctuomId=$p($g(^DHCANC("ComOrd",ancoId)),"^",6)
            ..s PLIST(12)=ctuomId
            ..s ancvcId=$P(itemStr,"#",8)
            ..i ancvcId="" s ancvcId=$p($g(^DHCANC("ComOrd",ancoId)),"^",5)
            ..s PLIST(16)=ancvcId
            ..s PLIST(21)=+$H    //ypz//s PLIST(11)=+$H
            ..s PLIST(22)=$p($h,",",2)  //ypz//s PLIST(12)=$p($h,",",2)
            ..s PLIST(25)="N"
            ..s PLIST(30)="I"    //ypz//s PLIST(8)="I"
            ..s PLIST(31)=$P(itemStr,"#",4) //ANCO_Type   //ypz Add
            ..s decimalDigits=0
            ..q:(PLIST(31)="D")&(PLIST(11)<0.0001)
            ..i (PLIST(31)="D")!(anredChannelNo="TEMP0") s decimalDigits=1
            ..b ;0
            ..i PLIST(11)'="" s PLIST(11)=$fn(PLIST(11),"",decimalDigits)
            ..i PLIST(32)'="" s PLIST(32)=$fn(PLIST(32),"",decimalDigits)
            ..i PLIST(33)'="" s PLIST(33)=$fn(PLIST(33),"",decimalDigits)
            ..s PLIST(36)=ancoDesc
            ..s PLIST(37)=paraItemId
            ..&sql(insert into DHC_AN_Order values :PLIST())
            ..s insertStr=insertStr_anredChannelNo_","
            ..s isInsert=1
            ..i SQLCODE s retStr=i_":AN SQLCODE:"_SQLCODE //"插入新数据错! code="_SQLCODE
            i (retStr=0)&&(isInsert=0) s retStr=2 // 未插入值   
    q retStr_" "_"opaId:"_opaId_" "_insertStr
}

ClassMethod GetParaItemIdByComOrdId(comOrdId As %String, opaId As %String) As %String
{
    s paraId=$o(^DHCANPara(0,+opaId,""))
    q:(paraId="") "-1"
    s opaPatStatus=$P(^DHCANOPArrange(opaId),"^",27)
    s paraItemId="",result=""
    f  s paraItemId=$o(^DHCANPara(paraId,"I",paraItemId)) q:(paraItemId="")!(result'="")  d
    .s Temptype=$p(^DHCANPara(paraId,"I",paraItemId),"^",15)
    .q:(opaPatStatus="I")&(Temptype'="AN")&(Temptype'="")
    .q:(opaPatStatus="P")&(Temptype'="PACU")&(Temptype'="")
    .s relateComOrdId=$p(^DHCANPara(paraId,"I",paraItemId),"^",4)
    .q:(relateComOrdId'=comOrdId)
    .s result=paraId_"||"_paraItemId
    
    q result
}

/// d ##class(%ResultSet).RunQuery("web.DHCANCom","FindOperationNurse","","OP^OUTOP^EMOP","","","","","")
Query FindOperationNurse(needCtcpDesc As %String, locListCodeStr As %String, locDescOrId As %String = "", EpisodeID As %String = "", opaId As %String = "", ifDoctor As %String = "", ifSurgeon As %String = "") As %Query(ROWSPEC = "Id,Desc,Alias")
{
}

ClassMethod FindOperationNurseExecute(ByRef qHandle As %Binary, needCtcpDesc As %String, locListCodeStr As %String, locDescOrId As %String = "", EpisodeID As %String = "", opaId As %String = "", ifDoctor As %String = "", ifSurgeon As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    k ^TMPCTCP($j)
    s needCtcpDesc=$$ALPHAUP^SSUTIL4(needCtcpDesc)
    s ctlocIdList=""
    i locDescOrId'="" d
        .i locDescOrId=+locDescOrId s ctlocIdList=locDescOrId
        .e  d
            ..s locDesc=$$ALPHAUP^SSUTIL4(locDescOrId)
            ..s ctlocIdList=$o(^CTLOC(0,"Desc",locDesc,""))
    i EpisodeID="",opaId'="" s EpisodeID=$P($g(^DHCANOPArrange(opaId)),"^",1)
    s locListCodeStr=##class(web.DHCCLCom).AdjustLocListCode(locListCodeStr,EpisodeID)
    i ctlocIdList="" s ctlocIdList=##class(web.DHCCLCom).GetLocIdByLocListCode(locListCodeStr)
    i needCtcpDesc="",ctlocIdList="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
    
    //查询提示已安排手术间的麻醉科医生、手术室护士
    i ((locListCodeStr_"^")["AN^")!((locListCodeStr_"^")["OP^") d
        .s opaStartDate=$p($g(^DHCANOPArrange(+opaId)),"^",14)
        .q:opaStartDate=""
        .k ctcpList
        .s opaId=""
        .f  s opaId=$O(^DHCANOPArrange(0,"SDate",+opaStartDate,opaId)) q:opaId=""  d 
            ..q:'$d(^DHCANOPArrange(opaId))
            ..s oprId=$P($G(^DHCANOPArrange(opaId)),"^",20)
            ..q:oprId=""
            ..s oprDesc=$p($G(^DHCANC("OPRoom",oprId)),"^",2)
            ..s anaId=$P(^DHCANOPArrange(opaId),"^",2)
            ..s EpisodeID=+anaId
            ..s anaSub=$p(anaId,"||",2)
            ..i ((locListCodeStr_"^")]"AN^") d
                ...s anaSuperCtcpId=$P(^OR(EpisodeID,"ANA",anaSub),"^",7)
                ...d SetCtcp(anaSuperCtcpId,oprDesc)
                ...s anaesthCtcpId=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)
                ...d SetCtcp(anaesthCtcpId,oprDesc)
                ...s anaopSub=0 
                ...f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
                    ....i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
                    ....s anassSub=0
                    ....i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
                    ....f  s anassSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub)) q:anassSub=""  d
                        .....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub),"^")
                        .....d SetCtcp(ctcpId,oprDesc)
            ..q:(locListCodeStr_"^")'["OP^"
            ..s anaopSub=0 
            ..f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
                ...i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
                ...s scnSub=0
                ...f  s scnSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",scnSub)) q:scnSub=""  d
                    ....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",scnSub),"^")
                    ....d SetCtcp(ctcpId,oprDesc)
                ...s cirnSub=0
                ...f  s cirnSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub)) q:cirnSub=""  d
                    ....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub),"^")
                    ....d SetCtcp(ctcpId,oprDesc)
    s ctcptIdStr=$g(^DHCCLSet("AnOp","OpDocTp")) //能为主刀医师的医护人员类型
    f i=1:1:$l(ctlocIdList) d
        .s ctlocId=$p(ctlocIdList,"^",i)
        .q:ctlocId=""
        .s resId=""
        .f  s resId=$O(^RB("RES",0,"CTLOC",ctlocId,resId))  q:resId=""  d
            ..s ctcpId=$P(^RB("RES",resId),"^",2)
            ..q:ctcpId=""
            ..s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
            ..q:ctcptId=""
            ..q:(ifSurgeon="Y")&((locListCodeStr_"^")["OPDEPT^")&((ctcptIdStr'="")&(("^"_ctcptIdStr_"^")'[("^"_ctcptId_"^")))
            ..s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",4)
            ..q:(ifDoctor'="")&(ifDoctor="Y")&(ctcptType'="DOCTOR")
            ..q:(ifDoctor'="")&(ifDoctor'="Y")&(ctcptType'="NURSE")
            ..//s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
            ..s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpId)
            ..q:($p(ctcpDesc,needCtcpDesc)'="")&(needCtcpDesc'="")&(##class(web.UDHCANOPArrange).MatchName(ctcpId,needCtcpDesc)=0)
            ..s ctcpDesc=ctcpDesc_$g(ctcpList(ctcpId))
            ..s ctcpAlias=$p($g(^CTPCP(ctcpId,3)),"^",28)
            ..s ^TMPCTCP($j,1,ctcpId)=$lb(ctcpId,ctcpDesc,ctcpAlias)
            ..;Do Outputcpt
        .s ctcptOtherId = ""
        .s list = ##class(web.UDHCANOPArrange).FindOtherCtcp(ctlocId,needCtcpDesc,ifDoctor) //liangqi 100906 查询外院医护人员
        .q:list.Size=""
        .f j=1:1:list.Size d
        ..s str = list.GetAt(j)
        ..s ctcptOtherId = "~"_$p(str,"^",1)
        ..s ctcpDesc = $p(str,"^",2)_$g(ctcpList(ctcptOtherId))
        ..s ctcpAlias=$p(str,"^",3)
        ..s ^TMPCTCP($j,2,ctcptOtherId)=$lb(ctcptOtherId,ctcpDesc,ctcpAlias)
        ..;d Outputothercpt
        s n="" 
        f  s n=$o(^TMPCTCP($j,n)) q:n=""  d
        .s ctcptId=""  f  s ctcptId=$o(^TMPCTCP($j,n,ctcptId)) q:ctcptId=""  d
        ..d Outputcpt
        
        /*
      //PJF 10031 
 s codeflag=0
 i +needCtcpDesc'=0 d
 .q:needCtcpDesc=""
 .s ctcpId=0
 .f  s ctcpId=$O(^SSU("SSUSR",0,"SSUSR_Initials",needCtcpDesc,ctcpId)) q:ctcpId=""  d
 ..s ctcpDesc=$p(^SSU("SSUSR",ctcpId),"^",2)
 ..s codeflag=1
 ..Do Outputcpt
 i codeflag=1 s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
 s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",ctloc,rw))  q:rw=""  d
     .s ctcpId=$P(^RB("RES",rw),"^",2)
     .q:ctcpId=""
     .s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
     .;q:(ctcpDesc'[needCtcpDesc)&(needCtcpDesc'="")
     .s text2=$p($g(^CTPCP(ctcpId,3)),"^",12) 
     .s tmpname=text2_ctcpDesc
     .s tmpname=$$ALPHAUP^SSUTIL4(tmpname)
     .q:(tmpname'[needCtcpDesc)
     .Do Outputcpt  
     */
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
SetCtcp(ctcpId,oprDesc)
    q:(ctcpId="")
    q:$g(ctcpList(ctcpId))[("("_oprDesc_")")
    s ctcpList(ctcpId)=$g(ctcpList(ctcpId))_"("_oprDesc_")"
    q

Outputcpt
 set Data=$lb(ctcpId,ctcpDesc)
 Set ^CacheTemp(repid,ind)=^TMPCTCP($j,n,ctcptId)
 Set ind=ind+1
 quit
}

ClassMethod FindOperationNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationNurseExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
    //
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {                // fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindOperationNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationNurseExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Query FindBloodType() As %SQLQuery(CONTAINID = 1)
{
    Select %ID As Id,
           BLDT_Code As Code,
           BLDT_Desc As Description
           From SQLUser.PAC_BloodType
}

/// Descript：   撤消监护，将病人的手术麻醉状态还原为"安排"
/// Creater：    陈长青
/// CreateDate：2013-12-27
/// Input：      手术申请排班ID，需还原的状态
/// Return:     0-撤消成功，其它撤消失败错误信息
ClassMethod RevokeMonitor(opaId As %String, status As %String = "R") As %String
{
    q:(opaId="") "病人手术申请排班ID不能为空"
    q:'$d(^DHCANOPArrange(opaId)) "数据库中不存在改手术申请排班ID("_opaId_")"
    
    TSTART
    &sql(update dhc_an_oparrange set opa_status=:status where opa_rowid=:opaId)
    i SQLCODE'=0 TRollBack  q "撤消监护状态失败(错误代码："_SQLCODE_")"
    
    &sql(delete from dhc_an_order where ano_opa_dr=:opaId)
    i SQLCODE<0 TRollBack  q "删除数据失败(错误代码："_SQLCODE_")"
    //考虑到无任何数据需要删除时,SQLCODE为100,同样不属于删除数据失败  YuanLin  20170714
    
    &sql(delete from DHC_AN_OPArrangeExtend where ANOPAE_OPA_Dr=:opaId)
        i SQLCODE<0 TRollBack  q "删除数据失败(错误代码："_SQLCODE_")"
    
    s paraId=$o(^DHCANPara(0,+opaId,""))
    if (paraId'="")
    {
        &sql(delete from dhc_an_para where %ID=:paraId)
        i SQLCODE'=0 TRollBack  q "删除数据失败(错误代码："_SQLCODE_")"        
    }
    s ret=..StopEquipCollect(opaId)
    i ret'=0 TRollBack  q ret
    
    TCommit
    q SQLCODE
}

ClassMethod JudgeANStatus(opaId As %String) As %String
{
    s result="N"
    
    s eventResult=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"TheatreIn",1,"Y")
    s theareInExist="N"
    i (eventResult'="") s theareInExist="Y"
    
    s eventResult=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"TheatreOut",1,"Y")
    s theareOutExist="N"
    i (eventResult'="") s theareOutExist="Y"
    
    s eventResult=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"OperStart",1,"Y")
    s operStartExist="N"
    i (eventResult'="") s operStartExist="Y"
    
    s eventResult=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"OperEnd",1,"Y")
    s operFinishExist="N"
    i (eventResult'="") s operFinishExist="Y"
    
    i (theareInExist="Y")&(theareOutExist="Y")&(operStartExist="Y")&(operFinishExist="Y") s result="Y"
    
    q result
}

ClassMethod ExcuteTask(equipId As %String, opaId As %String, cmd As %String) As %String
{
    //w ##class(web.DHCICUCom).ExcuteTask(equipId,opaId,"StopEq") ;"StartEq"
    s retStr="" ,source="A",interval=0,devType="",devTypeId="",extInfo=""
    
    i "IRLP"'[$p(^DHCANOPArrange(opaId),"^",27) s retStr="手术状态不对!" q
    s oproomId=$p($g(^DHCANOPArrange(opaId)),"^",20)
    i +oproomId=0 s retStr="未定义房间!" q
    s eqId=$p($g(^DHCANRoomEquip(equipId)),"^",2)
    //i eqId="" s retStr="未定义手术间设备!" q
    s IP=$p($g(^DHCANRoomEquip(equipId)),"^",3)
    s port=$p($g(^DHCANRoomEquip(equipId)),"^",4)
    s devTypeId=$p($g(^DHCANRoomEquip(equipId)),"^",5)
    s interval=$p($g(^DHCANRoomEquip(equipId)),"^",6)
    i +interval=0 s interval=60
    s interval=interval*1000
    
    i devTypeId=+devTypeId d
    .i $d(^DHCANC("CType",devTypeId)) s devType=$p($g(^DHCANC("CType",devTypeId)),"^",1)
    .q:devType'=""
    .s devType=$p($g(^DHCANC("EquipTypeCode",devTypeId)),"^",2)
    e  s devType=devTypeId
    
    s retStr=##class(web.DHCCLDevTool).ExcuteDevTask(source,equipId,opaId,"","",IP,port,interval,devType,extInfo,cmd)
    
    q retStr
}

ClassMethod GetUserTypeName(userId As %String) As %String
{
    //取用户的类别:医生还是护士
    q:userId="" "用户有误!"
    s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
    q:ctpcpId="" "该用户未关联医护人员!"
    s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
    q:ctcptId="" "该医护人员未定义医护类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
    ;q:ctcptInternalType="" "医护人员类型定义有误!"
    s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
    s loadName=$p($g(^SSU("SSUSR",userId)),"^",1)
    q ctcptInternalType_"^"_userName_"^"_loadName_"^"_ctpcpId
}

// 修改手术状态

ClassMethod ChangeOpStatus(arrangeId, stat)
{
    // w ##class(web.DHCANCom).ChangeOpStatus(arrangeId,stat)
    s oldStat="",res="",SQLCODE=""
    &sql(SELECT OPA_Status into:oldStat FROM DHC_AN_OPArrange WHERE OPA_RowId=:arrangeId)
    &sql(UPDATE DHC_AN_OPArrange SET OPA_Status=:stat WHERE OPA_RowId=:arrangeId)
    s date=##class(web.DHCClinicCom).ConvertToDate(+$h)
    s time=$p($h,",",2)
    
    i SQLCODE=0 d
    .s res="成功修改为:"_stat
    e  s res=SQLCODE
    s ^tmpandebug("ChangeOpStatus",arrangeId,date,time)=oldStat_" "_stat_" "_res
    
    q res
}

// 启动停止所以采集任务

ClassMethod StartAllTask(type = "Start")
{
    // w ##class(web.DHCANCom).StartAllTask()
    s oprId="" f  s oprId=$o(^DHCANC("OPRoom",oprId)) q:oprId=""  d
        .q:'$d(^DHCANOPArrange(0,"RoomStatus",oprId,"I"))
        .s opaId=$o(^DHCANOPArrange(0,"RoomStatus",oprId,"I",""))
        .q:'$d(^DHCANOPArrange(opaId))
        .s opaStartDate=$P(^DHCANOPArrange(opaId),"^",14)
        .;q:(opaStartDate+1)<$h
        .i type="Start" d
            ..s retStr=##class(web.DHCANCom).StartEquipCollect(opaId, 0, "")
            ..w $zd(opaStartDate,3)_" roomId:="_oprId_" opaId="_opaId_" startVal:"_retStr,!
        .e  d
            ..s retStr=##class(web.DHCANCom).StopEquipCollect(opaId)
            ..w $zd(opaStartDate,3)_" roomId:="_oprId_" opaId="_opaId_" stopVal:"_retStr,!
    q "Over"
}

/// Descript：   获取当前手术的状态
/// Creater：    李谋
/// CreateDate：2014-04-18
/// Input：      手术申请排班ID
/// Return:     当前手术的状态
ClassMethod GetOperStatus(opaId As %String) As %String
{
    q:(opaId="") "病人手术申请排班ID不能为空"
    q:'$d(^DHCANOPArrange(opaId)) "数据库中不存在改手术申请排班ID("_opaId_")"
    
    s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
    
    q opaStatus
}

/// w ##class(web.DHCANCom).GetSignImage(105)
/// ClassMethod GetSignImage(usrID As %String) As CA.UsrSignatureInfo
ClassMethod GetSignImage(usrID As %String) As %String
{
    s id=##Class(CA.UsrSignatureInfo).GetInUseID(usrID)
    q:(id="") ""
    
    s obj=##Class(CA.UsrSignatureInfo).%OpenId(id)
    q:(obj'="") obj.SignImage
    q ""
}

ClassMethod GetIfSign(CTLocID As %String) As %String
{
    q:CTLocID="" 0
    s ^DHCANDigitalIf("GetIfSign",CTLocID)=1
    s ret= $g(^DHCANDigitalIf("GetIfSign",CTLocID))
    q ret
}

// 20160802 From LM By Ding

ClassMethod GetDeviceState(opaId) As %String
{
   // w ##class(web.DHCANCom).GetDeviceState(opaId)
   s roomId=""
   &SQL(SELECT OPA_OpRoom_Dr INTO:roomId FROM DHC_AN_OPArrange WHERE OPA_RowId=:opaId)
   q:roomId="" ""
   
   &sql(DECLARE EmpCursor CURSOR FOR
        SELECT ANRE_Equip_Dr into :equipId from DHC_AN_RoomEquip 
        WHERE ANRE_Room_Dr=:roomId)
   s resStr=""
   &sql(OPEN EmpCursor)
   FOR { &sql(FETCH EmpCursor)
       QUIT:SQLCODE
       //s oneRes=##class(web.DHCCLDevTool).GetDeviceState("A", equipId)
	   s oneRes=""
       i resStr="" s resStr=oneRes
       e  s resStr=resStr_","_oneRes
   }
   s resStr="["_resStr_"]"
   &sql(CLOSE EmpCursor)
   q resStr
}

ClassMethod ModifyParaItem(paraItemId As %String, paraItemDesc As %String) As %String
{
    q:+paraItemId=0 "-1"
    &sql(update SQLUSER.DHC_AN_ParaItem set ANPI_DisplayName=:paraItemDesc where ANPI_RowId=:paraItemId)
    q "0"
}

/// 监护仪模拟数据界面
/// w ##class(web.DHCANCom).GetCallectData(334)
ClassMethod GetCallectData(opaId) As %String
{
    s code="",value="",hr="",bp="",SpO2="",temp="",co2="",sys="",dia="",Sev="",rr="",str="",retstr=""
    s devTypeId="",devCode=""
    i $d(^TMPANMONITORDEBGUG("InsertANOrder",opaId))  d
    .s retstr=$P(^TMPANMONITORDEBGUG("InsertANOrder",opaId),"@",2)
    .s equipId=$P(^TMPANMONITORDEBGUG("InsertANOrder",opaId),"@",1)
    .i devTypeId="" s devTypeId=$p($g(^DHCANRoomEquip(equipId)),"^",5)
    .i devTypeId="" s retStr=-14 q
    .s devCode=$p($g(^DHCANC("CType",devTypeId)),"^",1)
    .i devCode="Relay" d
    ..s ip=$p($g(^DHCANRoomEquip(equipId)),"^",3)
    ..s devCode=$p(ip,"|",4)
    ..s devTypeId=$o(^DHCANC("CType",0,"Code",devCode,""),-1)
    .i (((devCode="AutoCheckDev")||(devCode="TestDev"))&&(extInfo'="")) d 
    ..s devTypeId=0
    ..s devTypeId=$o(^DHCANC("CType",0,"Code",extInfo,devTypeId))
    s itemNum=$L(retstr,"^")
    f i=1:1:itemNum d
    .s itemStr=$P(retstr,"^",i)
    .q:itemStr=""
    .s code=$P(itemStr,"#",1)
    .q:code=""
    .s ancctiSub=$o(^DHCANC("CType",0,"ChannelNo",code,devTypeId,""))
    .q:ancctiSub=""
    .s ancoId=$p(^DHCANC("CType",devTypeId,"I",ancctiSub),"^",1)
    .q:ancoId=""
    .s value=$P(itemStr,"#",5)
    .i ancoId=2 s hr=$fn(value,"",0)   ///HR
    .i ancoId=8  s SpO2=$fn(value,"",0) //氧饱和度
    .i ancoId=3  s rr=$fn(value,"",0)  //RR
    .i ancoId=1 s temp=$fn(value,"",0)  //体温
    .i ancoId=10 s co2=$fn(value,"",0)    //CO2
    .i ancoId=185  s Sev=$fn(value,"",0)
    .i (ancoId=4)||(ancoId=6) s sys=$fn(value,"",0)   //收缩压
    .i (ancoId=5)||(ancoId=7) s dia=$fn(value,"",0)   //舒张压
    s bp=sys_"/"_dia
    s str=SpO2_"^"_bp_"^"_hr_"^"_Sev_"^"_rr_"^"_temp_"^"_co2
    i str="^/^^^^^"  d
    .s ancoIdstr="1^2^3^4^5^6^7^8^10"
    .s str=##class(web.DHCANOrder).GetCallectDataByImport(opaId,ancoIdstr)
    q str
}

}

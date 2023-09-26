Import SQLUser

///     IInsertItem     给个人/团体增加项目或套餐
///     InsertItem4Team         团体增加项目
///     InsertItemSet4Team      团体增加套餐
///     InsertItem4Person       个人增加项目
///     InsertItemSet4Person    个人增加套餐
///     UpdateAmount            
///     IDeleteItem     删除个人/团体增加项目或套餐
///     UpdateAmount
///     IInsOrd4NewPat  增加团体组成员
///     InsOrdEnt4NewPat    给新成员预约套餐
///     InsertItemSet4Person
///     InsOrdItm4NewPat    给新成员预约项目
///     InsertItem4Person
///     
/// description: 预约项目处理
///     parameter:  AdmId: PreIAdmId /PreGAdmId
///             AdmType  "PERSON"/"TEAM"
///             ArcItemId and ArcItemSetId: There is only one is not NULL
/// return: ""-OK, Else-Error
/// test:
///     个人套餐w ##class(web.DHCPE.PreItemList).IInsertItem("167","PERSON","PRE","","175",1423)
///         个人项目
///     团体项目w ##class(web.DHCPE.PreItemList).IInsertItem("303","PERSON","PRE","","1875",1423)
///                                                         "303","PERSON","PRE","","1875",1423
///         团体套餐w ##class(web.DHCPE.PreItemList).IInsertItem("33||4","TEAM","","166",10612)  
/// Class web.DHCPE.PreItemList Extends %RegisteredObject [ ProcedureBlock ]
Class web.DHCPE.PreItemList Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// debug:d ##class(web.DHCPE.PreItemList).IInsertItem("2487","PERSON","ADD","4764||1&1&1&","","12187",1)
ClassMethod IInsertItem(AdmId As %Library.String = "", AdmType As %Library.String = "", PreOrAdd As %Library.String = "", ArcItemId As %Library.String = "", ArcItemSetId As %Library.String = "", UpdateUserId As %Library.String = "", FeeFlag As %String = 1, DrugInfo As %String = "", OEOrdQty As %String = 1, OEOrdRecLocID As %String = "") As %String
{
    s ^tempdhcpe("IInsertItem")=$lb(AdmId,AdmType,PreOrAdd,ArcItemId,ArcItemSetId,UpdateUserId,FeeFlag,DrugInfo,OEOrdQty,OEOrdRecLocID)
    
    q:((AdmType'="PERSON")&&(AdmType'="TEAM")) "ERROR: AdmType must is PERSON/TEAM"
    q:((ArcItemId="")&&(ArcItemSetId="")) "ERROR: Arguments OrdItemId/OrdEntId is null!"    
    
    i (ArcItemSetId'=""){
        q:'$d(^ARCOS(ArcItemSetId,"DATE",1,"ITM")) "该套餐没关联医嘱项"
        i AdmType="PERSON" d
        .s HadSetsID=$G(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",AdmId))
        e  d
        .s HadSetsID=$G(^DHCPEDataEx("DHCPEPreTEAM","PreOrdSet",AdmId))
        ;q:("^"_HadSetsID_"^")[("^"_ArcItemSetId_"^") "套餐已存在，不允许再次添加"
    }

    i (AdmType="PERSON")&&(ArcItemSetId'="")
    {
        s ReCheckFlag=$P($G(^DHCPEPreIADM(AdmId)),"^",28)
        q:ReCheckFlag="Y" "复查客人、不允许选择套餐"
    }
	
	//查看库存是否足够 
	s IsEnough=..GetIsEnough(AdmId, AdmType,ArcItemId,ArcItemSetId)
    q:(IsEnough'="") IsEnough
    
	q ##class(web.DHCPE.PreItemList2).IInsertItem(AdmId,AdmType,PreOrAdd,ArcItemId,ArcItemSetId,UpdateUserId,"","",DrugInfo,OEOrdQty,OEOrdRecLocID)
}

ClassMethod HISUIIInsertItem(AdmId As %Library.String = "", AdmType As %Library.String = "", PreOrAdd As %Library.String = "", ArcItemId As %Library.String = "", ArcItemSetId As %Library.String = "", UpdateUserId As %Library.String = "", FeeFlag As %String = 1, RepeatFlag As %String = 0, DrugInfo As %String = "") As %String
{
    k ^tempdhcpe("HISUIIInsertItem")
    s ^tempdhcpe("HISUIIInsertItem")=$lb(AdmId,AdmType,PreOrAdd,ArcItemId,ArcItemSetId,UpdateUserId,FeeFlag,RepeatFlag,DrugInfo)
    q:((AdmType'="PERSON")&&(AdmType'="TEAM")) "{""ret"":""ERROR: AdmType must is PERSON/TEAM""}" //"ERROR: AdmType must is PERSON/TEAM"
    q:((ArcItemId="")&&(ArcItemSetId="")) "{""ret"":""ERROR: Arguments OrdItemId/OrdEntId is null!""}" //"ERROR: Arguments OrdItemId/OrdEntId is null!"
  
    i (ArcItemSetId'=""){
        q:'$d(^ARCOS(ArcItemSetId,"DATE",1,"ITM")) "{""ret"":""该套餐没关联医嘱项""}"
        //^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",IAdmId)=$G(^DHCPEDataEx("DHCPEPreTEAM","PreOrdSet",TeamId)
        i AdmType="PERSON" d
        .s HadSetsID=$G(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",AdmId))
        e  d
        .s HadSetsID=$G(^DHCPEDataEx("DHCPEPreTEAM","PreOrdSet",AdmId))
        s OSEBreakID="",OSEBreak=""
        s OSEBreakID=$o(^DHCPEOSE(0,"OrdSets",ArcItemSetId,0))
        i OSEBreakID'="" s OSEBreak=$p(^DHCPEOSE(OSEBreakID),"^",2)
        ;q:(OSEBreak'="Y")&&(("^"_HadSetsID_"^")[("^"_ArcItemSetId_"^")) "{""ret"":""套餐已存在，不允许再次添加""}"
    }
    
    i (AdmType="PERSON")&&(ArcItemSetId'="")
    {
        s ReCheckFlag=$P($G(^DHCPEPreIADM(AdmId)),"^",28)
        q:ReCheckFlag="Y" "{""ret"":""复查客人、不允许选择套餐""}"	
	}
	
	//查看库存是否足够 
    s IsEnough=..GetIsEnough(AdmId, AdmType,ArcItemId,ArcItemSetId)
    q:(IsEnough'="") "{""ret"":"""_IsEnough_"""}"
    
	s ret=##class(web.DHCPE.PreItemList2).IInsertItem(AdmId,AdmType,PreOrAdd,ArcItemId,ArcItemSetId,UpdateUserId,"",RepeatFlag,DrugInfo)
	
	q "{""ret"":"""_ret_"""}"
}

/// Description:  查看库存是否足够 
/// Output: 空 足够  -1^不足的项目或者原因
/// debug:  w ##class(web.DHCPE.PreItemList).GetIsEnough("96||1","TEAM","1876||1","")
ClassMethod GetIsEnough(AdmId As %Library.String = "", AdmType As %Library.String = "", ArcItemId As %Library.String = "", ArcItemSetId As %Library.String = "")
{
	s ^DHCPERecord("GetIsEnough")=$lb(AdmId,AdmType,ArcItemId,ArcItemSetId)
	/* ***************************
	///扣库存现在医生站开医嘱程序会扣，先把接口写在这里 以防需要体检单独调用
	
	物资根据医嘱ID消减库存的接口(开医嘱减库存接口)
	w ##class(web.DHCSTMHUI.PCHCOLLSM).Disp(oeori,barcode,CallFlag)
	入参：
		oeori--医嘱明细rowid(长期医嘱处理时,传入执行记录rowid);
		barcode--高值医嘱条码(默认为空)
		CallFlag--调用标记(审核医嘱传递"ORDER",计费后调用传递"BILL";门诊一般计费后减库存,住院开医嘱减库存)
	出参:
		0--处理成功 
		其他:处理失败
	
	*****************************/
	i $l(ArcItemId,"^")=1{
        //s roundingfee=$p(ArcItemId,"&",2)
        //s RoundType=$p(ArcItemId,"&",3)
        //s RoundRemark=$p(ArcItemId,"&",4)
        s ArcItemId=$p(ArcItemId,"&",1)
	}
	s RetDesc=""
	s NeedQty=1
	
	s LocID=$P($g(^DHCPEPreIADM(AdmId)),"^",26)
	if (AdmType="TEAM"){
		
		s LocID=$P($g(^DHCPEPreGADM(+AdmId)),"^",23)
		s NeedQty=0
		s TMPADM=""
		for{
			s TMPADM=$o(^DHCPEPreIADM(0,"PGTeam",AdmId,TMPADM))
			q:(TMPADM="")
			
			s Status=$p(^DHCPEPreIADM(TMPADM),"^",8)
			continue:(Status["CAN")
			s NeedQty=NeedQty+1
			}
	
	}
	
		
	
	b //0
	if (ArcItemId'=""){
		
		s ARCICOrderType=""
		s ItemCatDR=$p(^ARCIM(+ArcItemId,$p(ArcItemId,"||",2),1),"^",10)  
		i ItemCatDR'=""  s ARCICOrderType=$p(^ARC("IC",ItemCatDR),"^",7)
		
		
		s incId=$o(^INCI(0,"ARCIM_DR",+ArcItemId,0))
		s UOMFac=1
		i incId'=""{
			//包装单位
			s bUom=$p(^INCI(incId,1),"^",10)
			//基本单位
			s pUom=$p(^INCI(incId,3),"^",6)
			//门诊发药单位
			s outPhUomDr=$p(^INCI(incId,1),"^",12)
			//入库单位（正包装的）
			//s UOMFac= ##class(PHA.FACE.OUT.Com).UOMFac(pUom,bUom) //整包装单位
			s:(outPhUomDr'="")&&(bUom'="") UOMFac= ##class(PHA.FACE.OUT.Com).UOMFac(outPhUomDr,bUom) // 和发药单位匹配
		}
		s NeedQty=NeedQty*UOMFac
		b /// LocID
		s ArcDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ArcItemId,"A",LocID)
		s RecLoc=..GetRecLoc(1, ArcItemId, LocID)
		
		if (ARCICOrderType="M"){
			
			s MetRet=##class(web.DHCSTMHUI.DHCSTMSERVICE).GetAvailQtyByArc(ArcItemId,RecLoc,NeedQty)
			s:(MetRet=0) RetDesc=ArcDesc_"库存不足" 
			s:(MetRet<0) RetDesc=ArcDesc_"获取库存失败" 
		}
		
		if (ARCICOrderType="R"){
			b
			s DrugRet= ##Class(web.DHCSTINTERFACE).GetAvailQtyByArc(ArcItemId , RecLoc , NeedQty , 1)
			s:(DrugRet=0) RetDesc=ArcDesc_"库存不足" 
			s:(DrugRet<0) RetDesc=ArcDesc_"获取库存失败" 
		}
		
			
	}else{
		
		s ItemInfo=##class(web.DHCPE.PreItemList2).GetItemInfoBySetsID(ArcItemSetId,AdmId)
		s itemIds=$P(ItemInfo,$C(0),2)
		for i=1:1:$l(itemIds,$c(1)){
			
			s OneArcItemID=$p($p(itemIds,$c(1),i),"^",1)
			s ArcDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(OneArcItemID,"A",LocID)
			s RecLoc=..GetRecLoc(1, OneArcItemID, LocID)
			
			s incId=$o(^INCI(0,"ARCIM_DR",+OneArcItemID,0))
			s UOMFac=1
			i incId'=""{
				//包装单位
				s bUom=$p(^INCI(incId,1),"^",10)
				//基本单位
				s pUom=$p(^INCI(incId,3),"^",6)
				//门诊发药单位
				s outPhUomDr=$p(^INCI(incId,1),"^",12)
				//入库单位（正包装的）
				//s UOMFac= ##class(PHA.FACE.OUT.Com).UOMFac(pUom,bUom) //整包装单位
				s:(outPhUomDr'="")&&(bUom'="") UOMFac= ##class(PHA.FACE.OUT.Com).UOMFac(outPhUomDr,bUom) // 和发药单位匹配
			}
			s NeedQty=NeedQty*UOMFac
			
			
			s ARCICOrderType=""
			s ItemCatDR=$p(^ARCIM(+OneArcItemID,$p(OneArcItemID,"||",2),1),"^",10)  
			i ItemCatDR'=""  s ARCICOrderType=$p(^ARC("IC",ItemCatDR),"^",7)
			if (ARCICOrderType="M"){
				
				s MetRet=##class(web.DHCSTMHUI.DHCSTMSERVICE).GetAvailQtyByArc(OneArcItemID,RecLoc,NeedQty)
				
				s:(MetRet=0) RetDesc=ArcDesc_"库存不足" 
				s:(MetRet<0) RetDesc=ArcDesc_"获取库存失败" 
			}
			if (ARCICOrderType="R"){
				
				s DrugRet= ##Class(web.DHCSTINTERFACE).GetAvailQtyByArc(OneArcItemID , RecLoc , NeedQty , 1)
				s:(DrugRet=0) RetDesc=ArcDesc_"库存不足" 
				s:(DrugRet<0) RetDesc=ArcDesc_"获取库存失败" 
			}
		}
	}
		
	q RetDesc
}

/// Description:  查看项目是否已存在 
/// debug:  w ##class(web.DHCPE.PreItemList).IsExistItem("4||6", "TEAM","8569||1")
ClassMethod IsExistItem(AdmId As %Library.String = "", AdmType As %Library.String = "", ArcItemId As %Library.String = "", ArcItemSetId As %Library.String = "", LocID)
{
    s AlowAddFlag=0
    s ret=""
    /*
    i ("TEAM"=AdmType)&((""'=$g(ArcItemId))&(("23442||1"=ArcItemId)||("33163||1"=ArcItemId))) d
    .&SQL(select PGTOI_RowId into :RowId from DHC_PE_PreGTOrdItem 
            where (PGTOI_ItmMast_DR="23442||1" or PGTOI_ItmMast_DR="33163||1") and PGTOI_ParRef=:AdmId and PGTOI_ItemStat=1
            )
    .s ret=SQLCODE
    i ("PERSON"=AdmType)&((""'=$g(ArcItemId))&(("23442||1"=ArcItemId)||("33163||1"=ArcItemId))) d
    .&SQL(select PIOI_RowId into :RowId from DHC_PE_PreIOrdItem 
            where (PIOI_ItmMast_DR="23442||1" or PIOI_ItmMast_DR="33163||1") and PIOI_ParRef=:AdmId and PIOI_ItemStat=1
            )
    .s ret=SQLCODE
    Q:("0"=ret) 3  ;存在已有内科或老年内科
    
    ;上面为内科来年内科判断
    */
    i ("TEAM"=AdmType)&(""'=$g(ArcItemSetId)) d
    .&SQL(select PGTOE_RowId into :RowId    from DHC_PE_PreGTOrdEnt 
            where PGTOE_OrderSets_DR=:ArcItemSetId and PGTOE_ParRef=:AdmId and PGTOE_ItemStat=1
            )
    .s ret=SQLCODE
    
    i ("TEAM"=AdmType)&(""'=$g(ArcItemId)) d
    .&SQL(select PGTOI_RowId into :RowId from DHC_PE_PreGTOrdItem 
            where PGTOI_ItmMast_DR=:ArcItemId and PGTOI_ParRef=:AdmId and PGTOI_ItemStat=1
            )
    .s ret=SQLCODE
    
    i ("PERSON"=AdmType)&(""'=$g(ArcItemSetId)) d
    .&SQL(select PIOE_RowId into :RowId from DHC_PE_PreIOrdEnt 
            where PIOE_OrderSets_DR=:ArcItemSetId and PIOE_ParRef=:AdmId and PIOE_ItemStat=1
            )
    .s ret=SQLCODE
    
    i ("PERSON"=AdmType)&(""'=$g(ArcItemId)) d
    .&SQL(select PIOI_RowId into :RowId from DHC_PE_PreIOrdItem 
            where PIOI_ItmMast_DR=:ArcItemId and PIOI_ParRef=:AdmId and PIOI_ItemStat=1
            )
    .s ret=SQLCODE
    
    i ArcItemId'="" d
    .;s AlowAddFlag=+$G(^DHCPECTDataEx("DHCPEStationOrder","AlowAddFlag",ArcItemId))
    .s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcItemId,LocID)
    .q:StatOrderID=""
    .s ID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderID,""))
    .i ID'="" s AlowAddFlag=$lg($g(^CF.PE.StationOrderSetD(ID)),15)
    .i AlowAddFlag="Y" s AlowAddFlag=1
    .e  s AlowAddFlag=0
    Q:("0"=ret) 1_"^"_AlowAddFlag  ;存在相同的大项

    i ArcItemId'=""{
        ;2:存在相同的化验项目;0:都不存在
        s ret=##class(web.DHCPE.PreItemListEx).HadLisDetail(AdmId,ArcItemId)
        q ret
    }
    
    Q:("100"=ret) 0
    Q:(""=ret) 0
    Q 0
}

/// /w ##class(web.DHCPE.PreItemList).IsCT("39175" ,"PERSON", "22811||1")
ClassMethod IsCT(AdmId As %Library.String = "", AdmType As %Library.String = "", ItemId As %Library.String = "")
{
   
    s Flag=""
    q:(ItemId="") 0 
    q:('$d(^DHCPEST(0,"STORD_ARCIM",ItemId,13))) 0
    i ("TEAM"=AdmType) d
    .s sub=0
    .f  s sub=$o(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDITEM",sub)) q:(sub="")  d
    ..q
    ..s status=$p($g(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDITEM",sub)),"^",16)
    ..q:(status'=1)
    ..s MastDr=$p($g(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDITEM",sub)),"^",1)
    ..s:($d(^DHCPEST(0,"STORD_ARCIM",MastDr,8)))&&(status=1) Flag=1
    
    
    
    
    i ("PERSON"=AdmType) d
    .s sub=0
    .
    .f  s sub=$o(^DHCPEPreIADM(AdmId,"ORDITEM",sub)) q:sub=""  d
    ..b ;00
    ..s status=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",sub)),"^",16)
    ..;q:(status'=1)
    ..b ;11
    ..s MastDr=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",sub)),"^",1)
    ..b ;22
    ..s:($d(^DHCPEST(0,"STORD_ARCIM",MastDr,8)))&&(status=1) Flag=1
    ..q:(Flag=1)
    b ;33
    q:((Flag=1)&&($d(^DHCPEST(0,"STORD_ARCIM",ItemId,13)))) "1"
    
    b ;2
    q 0
}

/// w ##class(web.DHCPE.PreItemList).IsExistItems("112||1" ,"TEAM" , "20488")
ClassMethod IsExistItems(AdmId As %Library.String = "", AdmType As %Library.String = "", ItemSetId As %Library.String = "")
{
    
    ;s ^sxt("dd")=AdmId_"  "_AdmType_"  "_ItemSetId
    s ret="",Desc=""
    s Desc2=$p($g(^ARC("IC",$p($g(^ARCOS(ItemSetId)),"^",9))),"^",2)
    
    s:(Desc2'="体检医嘱套") ret="100"
    ;s ^sxt("des")="ret"_ret
    
    
    
    i (("TEAM"=AdmType)&&(ret'="100")) d
    .;s ^sxt("t")=ret
    .
    .
    .s sub=0
    .f  s sub=$o(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDENT",sub)) q:sub=""  d
    ..s setsdr=$p($g(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDENT",sub)),"^",1)
    ..s status=$p($g(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDENT",sub)),"^",7)
    ..;b ;0
    ..q:(status'=1)
    ..s Desc=$p($g(^ARC("IC",$p($g(^ARCOS(setsdr)),"^",9))),"^",2)
    ..;b ;1
    ..s:(Desc="体检医嘱套") ret="0"
    ..;b ;2
    
    
    
    
    
    
    
    
    
    
    
    
    
    i (("PERSON"=AdmType)&&(ret'="100")) d
    .s sub=0
    .f  s sub=$o(^DHCPEPreIADM(AdmId,"ORDENT",sub)) q:sub=""  d
    ..s setsdr=$p($g(^DHCPEPreIADM(AdmId,"ORDENT",sub)),"^",1)
    ..s status=$p($g(^DHCPEPreIADM(AdmId,"ORDENT",sub)),"^",9)
    ..q:(status'=1)
    ..s Desc=$p($g(^ARC("IC",$p($g(^ARCOS(setsdr)),"^",9))),"^",2)
    ..
    ..s:(Desc="体检医嘱套") ret="0"
    
    s ^sxt("ret")=ret
    ;Q:(""=ret) 0
    Q:("0"=ret) 1
    Q:("100"=ret) 0
    Q 0
}

/// 增加个人项目 dhc_pe_preIOrdItem(个人项目表)
/// return:     ""-OK, else-ErrorInfo
/// parameter: 
///             ArcItemIds:     医嘱项目列表 用"^"分割
///             GrpOrdItemIds:  如果是团体的成员，则输入团体项目记录的ID(DHC_PE_PreGTOrdItem.PGTOI_RowId)
///             OrdEntId:       如果医嘱项目是以医嘱套预约, 则输入预约医嘱套的ID(dhc_pe_preIOrdEnt.PIOE_RowId)
///             outNewIds:      返回值,返回成功插入的医嘱项目记录的ID
/// Modified by MLH 
/// w ##class(web.DHCPE.PreItemList).InsertItem4Person(26883,"9636||1&858","","",10791,"","PRE")                        
ClassMethod InsertItem4Person(AdmId As %Library.String = "", ArcItemIds As %Library.String = "", OrdEntId As %Library.String = "", GrpOrdItemIds As %Library.String = "", UpdateUserId As %Library.String = "", outNewIds As %Library.String = "", PreOrAdd As %Library.String = "", ArcItemSetId As %Library.String = "", CanBreak As %Library.String = "") [ Private ]
{
    
    s ^tempdhcpe("0403","PreItemList","InsertItem4Person")=AdmId_","""_ArcItemIds_""","""_OrdEntId_""","""_GrpOrdItemIds_""","_UpdateUserId_","_outNewIds_","_PreOrAdd
    s retVal=""
    Q:(""=ArcItemIds) retVal
    
    Set PIADMStatus=$p($g(^DHCPEPreIADM(AdmId)),"^",8)
    Quit:(PIADMStatus)="CANCELPE" ""

    s GrpOrdItemIds=$g(GrpOrdItemIds)
    s newId=""      // 新预约项目记录的ID
    s outNewIds=""  // 返回值 成功插入项目记录的列表  
    
    s AsCharged=$p(^DHCPEPreIADM(AdmId),"^",9) 
    s LocID=$P(^DHCPEPreIADM(AdmId),"^",26)
    i $l(ArcItemIds,"^")=1{
        s itemPrice=$p(ArcItemIds,"&",2)
        s RoundType=$p(ArcItemIds,"&",3)
        s RoundRemark=$p(ArcItemIds,"&",4)
        s arcItemId=$p(ArcItemIds,"&",1)
        S PIBISexDR=""
        s PIADMPIBIDR=$p($g(^DHCPEPreIADM(AdmId)),"^",1)
        i PIADMPIBIDR'=""  d
        .S PIBISexDR=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",3)
        //s SetInfo=$G(^DHCPESetting("DHCPE","DefPatientType"))
        s SetInfo=$G(^DHCPESetting("DHCPE","DefPatientType",LocID))
        s Sex=$G(^DHCPECTDataEx("DHCPEStationOrder","Sex",arcItemId))
        q:(PIBISexDR =$P(SetInfo,"^",3))&&( Sex=$P(SetInfo,"^",4)) "体检者性别与医嘱性别不一致"   //
        q:(PIBISexDR =$P(SetInfo,"^",4))&&( Sex=$P(SetInfo,"^",3)) "体检者性别与医嘱性别不一致"   //
    }

    f iLLoop=1:1:$l(ArcItemIds,"^") d
    .s arcItemInfo=$p(ArcItemIds,"^",iLLoop)
    .Q:(""=arcItemInfo)
    .s itemPrice=$p(arcItemInfo,"&",2)
    .s arcItemId=$p(arcItemInfo,"&",1)
    .s StationFlag=1
    .s Station=$o(^DHCPEST(0,"STORD_ARCIM",arcItemId,0))
    .;i (Station="")||(Station=$G(^DHCPESetting("DHCPE","StationId_Other"))) s StationFlag=0   //add 20200207
    .i (Station="")||(Station=$G(^DHCPESetting("DHCPE","StationId_Other",LocID))) s StationFlag=0 //add 20200207
    .// 如果是团体成员，获取相应的团体分组预约项目记录的ID
    .s GrpOrdItemId=$p(GrpOrdItemIds,"^",iLLoop)
    .s UpdateDate=+$H
    .s UpdateTime=$p($H,",",2)
    .s ItemFeeType=""
    
    .i GrpOrdItemId="" d
    ..s RecLoc=..GetRecLoc(1,arcItemId,LocID)
    ..s SPECDR=..GetDefaultSpecName(arcItemId,"1")
    ..s:$d(%session) loc=%session.Get("LOGON.CTLOCID")
    ..s:'$d(%session) loc=572
    ..i $G(^DHCPECTDataEx("DHCPEStationOrder","SpecialItem",arcItemId,loc))'="" d
    ...s ItemFeeType=$G(^DHCPECTDataEx("DHCPEStationOrder","SpecialItem",arcItemId,loc))
    ..s AccountAmount=+..GetOrderPrice(arcItemId_"&O",AdmId,"",ItemFeeType) 
    ..;s AccountAmount=..GetOrderPrice(arcItemId_"&O",AdmId,"0",ItemFeeType)  //Add By WRZ 2008-11-13
    ..s GTFactAmount=0
    ..s Qty=1
    .e  d
    ..s RecLoc=..GetRecLoc(2,GrpOrdItemId)
    ..s SPECDR=..GetDefaultSpecName(GrpOrdItemId,"2")
    ..s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",AdmId))
    ..s GTADMFeeType=$G(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",$p(GrpOrdItemId,"||",1,2)))
    ..i ADMFeeType=GTADMFeeType  d
    ...s AccountAmount=$p($g(^DHCPEPreGADM(+GrpOrdItemId,"Team",$p(GrpOrdItemId,"||",2),"ORDITEM",$p(GrpOrdItemId,"||",3))),"^",11) //Add By  2011-07-13
    ...s GTFactAmount=$p($g(^DHCPEPreGADM(+GrpOrdItemId,"Team",$p(GrpOrdItemId,"||",2),"ORDITEM",$p(GrpOrdItemId,"||",3))),"^",4) //Add By 2011-07-13
    ..else   d
    ...s AccountAmount=+..GetOrderPrice(arcItemId_"&O",AdmId,"",ADMFeeType)  
    ...s GTFactAmount=0
    ..s Qty=$G(^DHCPEDataEx("DHCPEPreGTOrdItem","Qty",GrpOrdItemId))
    ..i +Qty=0 s Qty=1
    .i +itemPrice'=0  do
    ..s AccountAmount=itemPrice  //原来协议调整费都是0
    .//else  do          //Modified By WRZ 2008-11-13
    .//.s AccountAmount=..GetOrderPrice(arcItemId)
    .//i +AccountAmount=0 s AsCharged="Y"
    .s PaiedFlag=##class(web.DHCPE.HandlerPreOrds).GetPaiedFlag(AdmId)
    .i (PaiedFlag="1")||(PaiedFlag="2") d
    ..i +AccountAmount=0 s AsCharged="Y"  //已经缴过费的，加0费用的项目才视同收费
    .&sql(insert into sqluser.dhc_pe_preIOrdItem(PIOI_ParRef,
                 PIOI_GTOI_DR, PIOI_ItmMast_DR, PIOI_OrdEnt_DR
                , PIOI_UpdateUser_DR, PIOI_UpdateDate,PIOI_UpdateTime,
                PIOI_Type,PIOI_AsCharged,PIOI_AccountAmount,PIOI_ItemStat,PIOI_ItemRecLoc_DR
            )values(
                :AdmId,:GrpOrdItemId,:arcItemId,:OrdEntId,:UpdateUserId,
                :UpdateDate,:UpdateTime,:PreOrAdd,:AsCharged,:AccountAmount,'1',:RecLoc
            )
        )
    .S:('(("0"=SQLCODE)||("-119"=SQLCODE))) SQLCODE=SQLCODE_"AdmId:"_AdmId_"GrpOrdItemId,:"_GrpOrdItemId_"arcItemId,:"_arcItemId_"OrdEntId,:"_OrdEntId_"UpdateUserId,:"_UpdateUserId_"UpdateDate,:"_UpdateDate_"UpdateTime,:"_UpdateTime_"PreOrAdd,:"_PreOrAdd_"AsCharged,:"_AsCharged_"AccountAmount,:"_AccountAmount_"RecLoc:"_RecLoc
    .Q:('(("0"=SQLCODE)||("-119"=SQLCODE)))
    .s OldInfo=$G(^DHCPEItemSort("Sort","Item",arcItemId))
    .k:OldInfo'="" ^DHCPEItemSort("Item",$P(OldInfo,"^",1),$P(OldInfo,"^",2))
    .s ItemSort=$I(^DHCPEItemSort("Sort","Item",arcItemId,"Sort"))
    .s ItemSub=$I(^DHCPEItemSort("Item",ItemSort))
    .s ^DHCPEItemSort("Item",ItemSort,ItemSub)=arcItemId
    .s ^DHCPEItemSort("Sort","Item",arcItemId)=ItemSort_"^"_ItemSub
    .s newId=%ROWID
    .i (CanBreak="Y")&&(ArcItemSetId'="") s ^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",AdmId,ArcItemSetId,newId)=1
    .s ^DHCPEDataEx("DHCPEPreIOrdItem","Qty",newId)=Qty
    .s ^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",newId)=SPECDR
    .i ((GrpOrdItemId="")&&(OrdEntId="")&&(StationFlag=1)) d ##class(web.DHCPE.AdmRecordManager).Insert(AdmId,"P","ADDItem","",newId)   //add 20200207
    .//对项目设置体检费别
    .s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",AdmId))
    .i GrpOrdItemId'=""  d
    ..s TADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",GrpOrdItemId)) //add by 20110902
    ..S ADMFeeType=TADMFeeType
    .i ItemFeeType'="" s ADMFeeType=ItemFeeType  
    .s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",newId)=ADMFeeType   //add by 20110902
    .s outNewIds=outNewIds_"^"_newId
    .//分组里插入新人员，取分组项目医保设置更新人员
    .i (GrpOrdItemId'="")&&($d(^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",GrpOrdItemId)))  s ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",newId)=$h_"^"_%session.Get("LOGON.USERID")
    .///得到审核表
    .i OrdEntId="" d
    ..s PARet=##class(web.DHCPE.PreItemList).GetPAList(AdmId,PreOrAdd,"I",arcItemInfo,"",ADMFeeType)
    ..//b //e
    ..Q:PARet=""
    ..//b //f
    ..s Inserted=0
    ..f PALoop=1:1:$l(PARet,$C(1)) d
    ...s PAStr=$p(PARet,$C(1),PALoop)
    ...s PADR=$p(PAStr,"^",1)
    ...s FactAmount=$p(PAStr,"^",5)
    ...;i GTFactAmount'=0 s FactAmount=GTFactAmount  //Add By WRZ 2008-11-13
    ...i GrpOrdItemId'="" s FactAmount=GTFactAmount
    ...i +itemPrice'=0 s FactAmount=itemPrice  //原来协议调整费都是0
    ...;额外加项不视同收费
    ...s PAType=$P(^DHCPEPreA(PADR),"^",1)
    ...i PAType="I" d
    ....s gid=$p($g(^DHCPEPreIADM(AdmId)),"^",2)
    ....i gid'="" d
    .....s NewAsCharged="N"
    .....s:$G(^DHCPEPreIADM(AdmId,"IFeeAsCharged"))'="" NewAsCharged=$G(^DHCPEPreIADM(AdmId,"IFeeAsCharged"))
    .....s ^tempdhcpe("IFeeAsCharged")=NewAsCharged
    .....s $P(^DHCPEPreIADM(AdmId,"ORDITEM",$p(newId,"||",2)),"^",9)=NewAsCharged
    .....i +AccountAmount=0 s $P(^DHCPEPreIADM(AdmId,"ORDITEM",$p(newId,"||",2)),"^",9)="Y"
    ...&sql(insert into sqluser.DHC_PE_PreIOrdItemFee(
                PIOIF_ParRef,PIOIF_FactAmount,PIOIF_PAudit_DR,
                PIOIF_UpdateUser_DR,PIOIF_UpdateDate,PIOIF_UpdateTime
            )values(
                :newId,:FactAmount,:PADR,:UpdateUserId,:UpdateDate,
                :UpdateTime
            )
        )
    ...///如果是增加协议调整费自动确认加项
    ...i +itemPrice'=0 d 
    ....d ##class(web.DHCPE.TransAdmInfo).ConfirmAddOrdItem(AdmId,%session.Get("LOGON.USERID"))
    ....s ^DHCPEDataEx("InsertRoundFee",+newId,$P(newId,"||",2))=RoundType_"^"_RoundRemark_"^"_itemPrice_"^"_%session.Get("LOGON.USERID")_"^"_$H
    ...//b //2
    Q:('(("0"=SQLCODE)||("-119"=SQLCODE))) "Error: insert dhc_pe_preIOrdItem error , sqlcodemlh="_SQLCODE
    // 整理数据,去除空白预约ID
    i ($l(outNewIds,"^")>0) s outNewIds=$e(outNewIds,2,$l(outNewIds))
    
    q retVal
}

/// 增加个人项目 dhc_pe_preIOrdItem(个人项目表)
/// return:     ""-OK, else-ErrorInfo
/// parameter: 
///             ArcItemIds:     医嘱项目列表 用"^"分割
///             GrpOrdItemIds:  如果是团体的成员，则输入团体项目记录的ID(DHC_PE_PreGTOrdItem.PGTOI_RowId)
///             OrdEntId:       如果医嘱项目是以医嘱套预约, 则输入预约医嘱套的ID(dhc_pe_preIOrdEnt.PIOE_RowId)
///             outNewIds:      返回值,返回成功插入的医嘱项目记录的ID
/// Modified by MLH                         
ClassMethod InsertItemOth4Person(AdmId As %Library.String = "", GrpOrdItemIds As %Library.String = "", UpdateUserId As %Library.String = "", outNewIds As %Library.String = "", PreOrAdd As %Library.String = "") [ Private ]
{
    Set ^lisatest("1226","InsertItemOth4Person")=AdmId_"^"_GrpOrdItemIds_"^"_UpdateUserId_"^"_outNewIds_"^"_PreOrAdd
    Set TLAOrder=0,TLATube=1,ret=""
    Set BloodSet=0,FoodBloodSet=0,HaveBloodSet=0,TLABloodSet=0,NormalBloodSet=0
    Set PIOISub=0,i=1
    s znSpeace=$ZN
     s LocID=$P(^DHCPEPreIADM(AdmId),"^",26)
    //s MedData=$G(^DHCPESetting("NAMESPACE","MEDDATA"))
    //s LABDATA=$G(^DHCPESetting("NAMESPACE","LABDATA"))
    s MedData=$G(^DHCPESetting("NAMESPACE","MEDDATA",LocID))
    s LABDATA=$G(^DHCPESetting("NAMESPACE","LABDATA",LocID))

    For  Set PIOISub=$o(^DHCPEPreIADM(AdmId,"ORDITEM",PIOISub)) Quit:(PIOISub="")  Do
    .Set PIOIStr=$g(^DHCPEPreIADM(AdmId,"ORDITEM",PIOISub))
    .Quit:PIOIStr=""
    .Set PIOIArcimDR=$p(PIOIStr,"^",1)
    .Quit:PIOIArcimDR=""
    .Set PIOIOrdEntDR=$p(PIOIStr,"^",2)
    .Set PIOIArcosDR="",ARCICDesc="",LabTrakTestSet="",Specimen=""
    .If $g(PIOIOrdEntDR)'="" Do
    ..Set PIOIArcosDR=$p(^DHCPEPreIADM(AdmId,"ORDENT",$p(PIOIOrdEntDR,"||",2)),"^",1)
    ..Set ARCICRowId=$p(^ARCOS(PIOIArcosDR),"^",9)
    ..Set ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2) 
    .Set PIOIArcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(PIOIArcimDR)
    .If (PIOIArcimDesc["TLA")&(PIOIArcimDesc'["餐后") Do
    ..Set TLAOrder=1  //有TLA医嘱
    ..Set TLABloodSet=1
    .If PIOIArcimDesc["餐后" Do
    ..Set FoodBloodSet=FoodBloodSet+1
    .If (ARCICDesc["检验")&(PIOIArcimDesc'["TLA")&(PIOIArcimDesc'["餐后") Do
    ..Set LabTrakTestSet=$p(^ARCOS(PIOIArcosDR),"^",11)
    ..zn MedData
    ..Set SpecimenRowId=$$GetTestSetSpecimen^DHCPEOrdItem(LabTrakTestSet,LABDATA)
    ..Set Specimen=$p(^[LABDATA]TTAB("SPEC",SpecimenRowId),"/",1)
    ..zn znSpeace
    ..If Specimen["血" Set NormalBloodSet=1
    .If PIOIArcimDR="6303||1" Do  //真空采血管
    ..Set PIOIArcimEnt=$p(PIOIStr,"^",2)
    ..If $g(PIOIArcimEnt)="" Set TLATube=0
    .Set ^lisatest("1226","PIOIArcosDR",i)=PIOIArcimDR_"^"_PIOIOrdEntDR_"^"_PIOIArcosDR_"^"_ARCICDesc_"^"_LabTrakTestSet_"^"_Specimen
    .If (PIOIArcimDR="123||1")&(PIOIArcosDR="13") Set HaveBloodSet=HaveBloodSet+1
    .Set i=i+1
    If (TLATube=1)&(TLAOrder=1) Do
    .Set ret=..InsertItem4Person(AdmId,"6303||1", "", GrpOrdItemIds, UpdateUserId, outNewIds, PreOrAdd)
    Set ^lisatest("1226","BloodSet")=FoodBloodSet_"^"_TLABloodSet_"^"_NormalBloodSet_"^"_HaveBloodSet
    Set BloodSet=FoodBloodSet+TLABloodSet+NormalBloodSet-HaveBloodSet
    For iLLoop=1:1:BloodSet Do
    .Set ret=..InsertItemSet4Person(AdmId,13,"",UpdateUserId,outNewIds,PreOrAdd)

    Quit ret
}

/// 增加个人项目 dhc_pe_preIOrdItem(个人项目表)
/// return:     ""-OK, else-ErrorInfo
/// parameter: 
///             ArcItemIds:     医嘱项目列表 用"^"分割
///             GrpOrdItemIds:  如果是团体的成员，则输入团体项目记录的ID(DHC_PE_PreGTOrdItem.PGTOI_RowId)
///             OrdEntId:       如果医嘱项目是以医嘱套预约, 则输入预约医嘱套的ID(dhc_pe_preIOrdEnt.PIOE_RowId)
///             outNewIds:      返回值,返回成功插入的医嘱项目记录的ID
/// Modified by MLH                         
ClassMethod InsertItemOth4Team(AdmId As %Library.String = "", GrpOrdItemIds As %Library.String = "", UpdateUserId As %Library.String = "", outNewIds As %Library.String = "") [ Private ]
{
    Set ^lisatest("1226","InsertItemOth4Team")=AdmId_"^"_GrpOrdItemIds_"^"_UpdateUserId_"^"_outNewIds
    Set TLAOrder=0,TLATube=1,ret=""
    Set BloodSet=0,FoodBloodSet=0,HaveBloodSet=0,TLABloodSet=0,NormalBloodSet=0
    s znSpeace=$ZN
    s LocID=$P(^DHCPEPreIADM(AdmId),"^",26)
    //s MedData=$G(^DHCPESetting("NAMESPACE","MEDDATA"))
    //s LABDATA=$G(^DHCPESetting("NAMESPACE","LABDATA"))
    s MedData=$G(^DHCPESetting("NAMESPACE","MEDDATA",LocID))
    s LABDATA=$G(^DHCPESetting("NAMESPACE","LABDATA",LocID))

    Set PGTOISub=0,i=1
    Set PGADM=$p(AdmId,"||",1)
    Set PGTeamChd=$p(AdmId,"||",2)
    For  Set PGTOISub=$o(^DHCPEPreGADM(PGADM,"Team",PGTeamChd,"ORDITEM",PGTOISub)) Quit:(PGTOISub="")  Do
    .Set PGTOIStr=$g(^DHCPEPreGADM(PGADM,"Team",PGTeamChd,"ORDITEM",PGTOISub))
    .Quit:PGTOIStr=""
    .Set PGTOIArcimDR=$p(PGTOIStr,"^",1)
    .Quit:PGTOIArcimDR=""
    .Set PGTOIOrdEntDR=$p(PGTOIStr,"^",2)
    .Set PGTOIArcosDR="",ARCICDesc="",LabTrakTestSet="",Specimen=""
    .If $g(PGTOIOrdEntDR)'="" Do
    ..Set PGTOIArcosDR=$p(^DHCPEPreGADM(PGADM,"Team",PGTeamChd,"ORDENT",$p(PGTOIOrdEntDR,"||",3)),"^",1)
    ..Set ARCICRowId=$p(^ARCOS(PGTOIArcosDR),"^",9)
    ..Set ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2) 
    .Set PGTOIArcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(PGTOIArcimDR)
    .//Set PIOIArcimDesc=$p(^ARCIM($p(PIOIArcimDR,"||",1),1,1),"^",2)
    .If (PGTOIArcimDesc["TLA")&(PGTOIArcimDesc'["餐后") Do
    ..Set TLAOrder=1  //有TLA医嘱
    ..Set TLABloodSet=1
    .If PGTOIArcimDesc["餐后" Do
    ..Set FoodBloodSet=FoodBloodSet+1
    .If (ARCICDesc["检验")&(PGTOIArcimDesc'["TLA")&(PGTOIArcimDesc'["餐后") Do
    ..Set LabTrakTestSet=$p(^ARCOS(PGTOIArcosDR),"^",11)
    ..zn MedData
    ..Set SpecimenRowId=$$GetTestSetSpecimen^DHCPEOrdItem(LabTrakTestSet,LABDATA)
    ..Set Specimen=$p(^[LABDATA]TTAB("SPEC",SpecimenRowId),"/",1)
    ..zn znSpeace
    ..If Specimen["血" Set NormalBloodSet=1
    .If PGTOIArcimDR="6303||1" Do
    ..Set PGTOIArcimEnt=$p(PGTOIStr,"^",2)
    ..If $g(PGTOIArcimEnt)="" Set TLATube=0
    .Set ^lisatest("1226","PGTOIArcosDR",i)=PGTOIArcimDR_"^"_PGTOIOrdEntDR_"^"_PGTOIArcosDR_"^"_ARCICDesc_"^"_LabTrakTestSet_"^"_Specimen
    .If (PGTOIArcimDR="123||1")&(PGTOIArcosDR="13") Set HaveBloodSet=HaveBloodSet+1
    .Set i=i+1
    If (TLATube=1)&(TLAOrder=1) Do
    .Set ret=..InsertItem4Team(AdmId,"6303||1", "", UpdateUserId, outNewIds, "PRE")
    .//        InsertItem4Team(TeamAdmId,ArcItemIds,OrdEntId,UpdateUserId ,outNewIds,PreOrAdd)
    Set ^lisatest("1226","BloodSet")=FoodBloodSet_"^"_TLABloodSet_"^"_NormalBloodSet_"^"_HaveBloodSet
    Set BloodSet=FoodBloodSet+TLABloodSet+NormalBloodSet-HaveBloodSet
    For iLLoop=1:1:BloodSet Do
    .Set ret=..InsertItemSet4Team(AdmId,13,UpdateUserId,outNewIds)
    .//        InsertItemSet4Team(TeamAdmId,ArcItemSetId,UpdateUserId,outNewRowId)
    Quit ret
}

/// 增加个人项目套 dhc_pe_preIOrdEnt
/// return: ""-OK, else-ErrorInfo
/// parameter:
///         GrpOrdEntId: DHC_PE_PreGTOrdEnt.PGTOE_RowId. it is null if the ordEnt is not auto generated by group.
///         outNewRowId: Output argument.  return the new RowId .  
/// test:  w ##class(web.DHCPE.PreItemList).InsertItemSet4Person(119,2392,"","3565",.a,"PRE")
ClassMethod InsertItemSet4Person(AdmId As %Library.String = "", ArcItemSetId As %Library.String = "", GrpOrdEntId As %Library.String = "", UpdateUserId As %Library.String = "", outNewIds As %Library.String = "", PreOrAdd As %Library.String = "", RepeatFlag As %String = 0) [ Private ]
{
    //s ^lisatest("0409","InsertItemSet4Person")=AdmId_","""_ArcItemSetId_""","""_GrpOrdEntId_""","""_UpdateUserId_","_outNewIds_","_PreOrAdd
    
    Set PIADMStatus=$p($g(^DHCPEPreIADM(AdmId)),"^",8)
    Quit:(PIADMStatus)="CANCELPE" ""
    S LocID=$P($G(^DHCPEPreIADM(AdmId)),"^",26)
    S hospId=$P($G(^CTLOC(LocID)),"^",22)

    
    s SCOrdSetsID=$P(ArcItemSetId,"^",2)
    s ArcItemSetId=$P(ArcItemSetId,"^",1)
    
    // added by xy 2012-10-29 start
    S PIBISexDR=""
    s PIADMPIBIDR=$p($g(^DHCPEPreIADM(AdmId)),"^",1)
    i PIADMPIBIDR'=""  d
    .S PIBISexDR=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",3)
    
    //s SetInfo=$G(^DHCPESetting("DHCPE","DefPatientType"))
    s SetInfo=$G(^DHCPESetting("DHCPE","DefPatientType",LocID))

    s Sex=$g(^DHCPEDataEx("DHCPEBaseData","Sex",ArcItemSetId)) 
    q:(PIBISexDR =$P(SetInfo,"^",3))&&( Sex=$P(SetInfo,"^",4)) "体检者性别与医嘱套性别不一致"
    q:(PIBISexDR =$P(SetInfo,"^",4))&&( Sex=$P(SetInfo,"^",3)) "体检者性别与医嘱套性别不一致"
    
    
    s itemIds=""
    s rowCount=0
    s UpdateDate=+$H
    s UpdateTime=$p($H,",",2)
    
    //Modified by MLH 2007-07-12
    Set ordEntId=""
    Set OSERowId=$o(^DHCPEOSE(0,"OrdSets",ArcItemSetId,0))
    Set Break=""
    If $g(OSERowId)'="" Set Break=$p(^DHCPEOSE(OSERowId),"^",2)
    ;s Break="Y"
    Set CanBreak=$s(Break'="Y":"N",Break="Y":"Y")
    
    if (RepeatFlag=1){
    // 获取套餐里的所有子项
    s GrpOrdItemIds=""
    i ""'=GrpOrdEntId d
    .// 操作团体客户 团体套餐记录ID 返回套餐项目记录ID 返回套餐子项 
    .d ##class(web.DHCPE.HandlerPreOrds).IGetItemIdStr4GTOrdEnt(GrpOrdEntId, .GrpOrdItemIds, .itemIds)
    e  d
    .s itemIds=##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(ArcItemSetId_"^"_SCOrdSetsID)
    /// 过滤已有的项目 by zrc start
    i itemIds'="" d
    .s Temp=""
    .s itemIdStrs=""
    .s gub=0
    .f  s gub=$o(^DHCPEPreIADM(AdmId,"ORDITEM",gub)) q:gub=""  d
    ..s itemdr=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",gub)),"^",1)
    ..s status=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",gub)),"^",16)
    ..q:(status'=1)
    ..s:itemIdStrs'="" itemIdStrs=itemIdStrs_"^"_itemdr
    ..s:itemIdStrs="" itemIdStrs=itemdr
    .i itemIdStrs'="" d
    ..for i=1:1:$l(itemIds,"^") d
    ...s Item=$p(itemIds,"^",i)
    ...i itemIdStrs'[Item d
    ....s:Temp'="" Temp=Temp_"^"_Item
    ....s:Temp="" Temp=Item
    ...e  d
    ....s CanBreak="Y"
    ..s itemIds=Temp
    /// 过滤已有的项目 by zrc  end
    }
    s GTFcatAmount=0  ////Add By WRZ 2008-11-13
    
    If CanBreak="N" Do //Modified by MLH 2007-07-12
    .s AccountAmount=0
    .//Modified by MLH 2008-05-23 团体小组医嘱套中有删除项目时,增加新人,计算费用有问题,已改正
    .If GrpOrdEntId="" Do
    ..i SCOrdSetsID="" d
    ...s AccountAmount=##class(web.DHCPE.Handle.ARCOrdSets).GetPrice(ArcItemSetId_"&O","",AdmId,"","B",LocID,hospId)
    ..e  d
    ...s AccountAmount=$P(^DHCPEAP(+SCOrdSetsID,"SC",$P(SCOrdSetsID,"||",2),"OrdSets",$P(SCOrdSetsID,"||",3)),"^",10)
    .Else  Do
    ..s AccountAmount=$p($g(^DHCPEPreGADM(+GrpOrdEntId,"Team",$p(GrpOrdEntId,"||",2),"ORDENT",$p(GrpOrdEntId,"||",3))),"^",6)
    ..s GTFcatAmount=$p($g(^DHCPEPreGADM(+GrpOrdEntId,"Team",$p(GrpOrdEntId,"||",2),"ORDENT",$p(GrpOrdEntId,"||",3))),"^",5) ////Add By WRZ 2008-11-13
    .////////////////////////////
    .&sql(insert into sqluser.dhc_pe_preIOrdEnt(
            PIOE_ParRef, PIOE_GTOE_DR, PIOE_OrderSets_DR ,PIOE_UpdateUser_DR,
            PIOE_UpdateDate,PIOE_UpdateTime,PIOE_AccountAmount,PIOE_Type,PIOE_ItemStat
        )values(
            :AdmId, :GrpOrdEntId, :ArcItemSetId, :UpdateUserId, 
            :UpdateDate,:UpdateTime,:AccountAmount,:PreOrAdd,'1'
        )
    )
    .If ((SQLCODE'=0)&&(SQLCODE'=-119)) Q:"Error: insert dhc_pe_preIOrdEnt error , sqlcode="_SQLCODE
    .;s OldInfo=$G(^DHCPEItemSort("Sort","Set",ArcItemSetId))
    .;k:OldInfo'="" ^DHCPEItemSort("Set",$P(OldInfo,"^",1),$P(OldInfo,"^",2))
    .;s ItemSort=$I(^DHCPEItemSort("Sort","Set",ArcItemSetId,"Sort"))
    .;s ItemSub=$I(^DHCPEItemSort("Set",ItemSort))
    .;s ^DHCPEItemSort("Set",ItemSort,ItemSub)=ArcItemSetId
    .;s ^DHCPEItemSort("Sort","Set",ArcItemSetId)=ItemSort_"^"_ItemSub
    .s ordEntId=%ROWID
    .s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",AdmId))  //add by 20110902
    .i GrpOrdEntId'=""  d
    ..s TADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Ent",GrpOrdEntId)) //add by 20110902
    ..S ADMFeeType=TADMFeeType
    .s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Ent",ordEntId)=ADMFeeType   //add by 20110902
    else  Do
    .s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",AdmId))  //add by 20110902
    .i GrpOrdEntId'=""  d
    ..s TADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Ent",GrpOrdEntId)) //add by 20110902
    ..S ADMFeeType=TADMFeeType
    .s ^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",AdmId)=$G(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",AdmId))_"^"_ArcItemSetId
    
    //分组里插入新人员，取分组医嘱套医保设置更新人员
    i (GrpOrdEntId'="")&&($d(^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Ent",GrpOrdEntId)))  s ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Ent",ordEntId)=$h_"^"_%session.Get("LOGON.USERID")
    //取审核表
    s PARet=##class(web.DHCPE.PreItemList).GetPAList(AdmId,PreOrAdd,"I","",ArcItemSetId,ADMFeeType)
    f PALoop=1:1:$l(PARet,$C(1)) d
    .s PAStr=$p(PARet,$C(1),PALoop)
    .s PADR=$p(PAStr,"^",1)
    .s FactAmount=$p(PAStr,"^",5)
    .i GTFcatAmount'=0 s FactAmount=GTFcatAmount  //Add By WRZ 2008-11-13
    .If CanBreak="N" Do //Modified by MLH 2007-07-12
    ..&sql(insert into sqluser.DHC_PE_PreIOrdEntFee(
                PIOEF_ParRef,PIOEF_FactAmount,PIOEF_PAudit_DR,
                PIOEF_UpdateUser_DR,PIOEF_UpdateDate,PIOEF_UpdateTime
            )values(
                :ordEntId,:FactAmount,:PADR,
                :UpdateUserId,:UpdateDate,:UpdateTime
            )
        )
    ../////////////081024  By WRZ
    ..
    ..//s UARet=..UpdateAmount(PADR,0,AccountAmount,0,FactAmount)   
    ..//
    ../////////////End
    if (RepeatFlag=0){
    // 获取套餐里的所有子项
    s GrpOrdItemIds=""
    i ""'=GrpOrdEntId d
    .// 操作团体客户                                              团体套餐记录ID    返回套餐项目记录ID  返回套餐子项      
    .d ##class(web.DHCPE.HandlerPreOrds).IGetItemIdStr4GTOrdEnt(GrpOrdEntId, .GrpOrdItemIds, .itemIds)
    e  d
    .s itemIds=##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(ArcItemSetId_"^"_SCOrdSetsID)
    }
    // 个人单项目
    s myTemp=""
    s retVal=..InsertItem4Person( AdmId, itemIds, ordEntId, GrpOrdItemIds,UpdateUserId,myTemp,PreOrAdd,ArcItemSetId,CanBreak)
    d ##class(web.DHCPE.PreAudit).InsertEntFactAmount(ordEntId)
    I ordEntId'="" d ##class(web.DHCPE.AdmRecordManager).Insert(AdmId,"P","ADDSet","",ordEntId)
    s outNewIds=ordEntId
    q retVal
}

// ##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet("77^")

/// ************************************************************************
///             增加团体的医嘱项目
/// return:     ""-OK, else-ErrorInfo
/// parameter:  
///             ArcItemIds:     separated by "^",
///             OrdEntId:       DHC_PE_PreGTOrdEnt.PGTOE_RowId, It is null if the item is not auto generated by itemSet.
///             outNewIds:      Output argument. return the new ids.
/// test:  w ##class(web.DHCPE.PreItemList).InsertItem4Team("1||1","5||1^6||1^7||1","",1,"")
ClassMethod InsertItem4Team(TeamAdmId As %Library.String = "", ArcItemIds As %Library.String = "", OrdEntId As %Library.String = "", UpdateUserId As %Library.String = "", outNewIds As %Library.String = "", PreOrAdd As %Library.String = "") As %String [ Private ]
{
    s grpNewIds=""
    s retVal=""
    s temp=""
    //s ^lisatest("0403","InsertItem4Team")=TeamAdmId_"^"_ArcItemIds_"^"_OrdEntId_"^"_UpdateUserId_"^"_outNewIds
    s retVal=..InsertTeamOrdItm(TeamAdmId, ArcItemIds, OrdEntId, UpdateUserId, .grpNewIds)
    q:(""'=retVal) retVal
    /*20090115  wrz
    // 给团体成员增加项目
    s GTIAdm="0"
    for  s GTIAdm=$o(^DHCPEPreIADM(0,"PGTeam",TeamAdmId,GTIAdm))  q:GTIAdm=""  d
    .// 个人单项目
    .s retVal=..InsertItem4Person(GTIAdm,ArcItemIds,"",grpNewIds,UpdateUserId,temp,PreOrAdd)
    .q:(""'=retVal)
    */
    q retVal
}

/// 
/// return: ""-OK, else-ErrorInfo
/// parameter: 
///             ArcItemIds:     separated by "^",
///             OrdEntId:       DHC_PE_PreGTOrdEnt.PGTOE_RowId, It is null if the item is not auto generated by itemSet.
///             outNewIds:      Output argument. return the new ids.
ClassMethod InsertTeamOrdItm(TeamAdmId As %Library.String = "", ArcItemIds As %Library.String = "", OrdEntId As %Library.String = "", UpdateUserId As %Library.String = "", outGrpNewIds As %Library.String = "", CanBreak As %Library.String = "Y", ArcItemSetId As %Library.String = "") As %String [ Private ]
{
    
    s retVal=""
    s newId=""
    s outGrpNewIds=""
    s temp=""
    //s ^tempdhcpe("InsertTeamOrdItm")=TeamAdmId_"^"_ArcItemIds_"^"_OrdEntId_"^"_UpdateUserId_"^"_outGrpNewIds
    s LocID=$P($G(^DHCPEPreGADM(+TeamAdmId)),"^",23)
    i $l(ArcItemIds,"^")=1{
        s itemPrice=$p(ArcItemIds,"&",2)
        s arcItemId=$p(ArcItemIds,"&",1)
        S GSex="",Sex=""
        s GSex=$p($g(^DHCPEPreGADM(+TeamAdmId,"Team",$P(TeamAdmId,"||",2))),"^",12) 
        i arcItemId'="" s Sex=$G(^DHCPECTDataEx("DHCPEStationOrder","Sex",arcItemId)) 
        //s SetInfo=$G(^DHCPESetting("DHCPE","DefPatientType"))
        s SetInfo=$G(^DHCPESetting("DHCPE","DefPatientType",LocID))
        q:(GSex ="F")&&( Sex=$P(SetInfo,"^",3)) "体检者性别与医嘱套性别不一致"   //
        q:(GSex ="M")&&( Sex=$P(SetInfo,"^",4)) "体检者性别与医嘱套性别不一致"  

    }
    
    
    //得到审核表的RowId
    
    
    s AdmId=+TeamAdmId
    s PAStr=..GetPARowId("G",TeamAdmId,"PRE")
    Q:PAStr="" "NotGetPA"
    q:ArcItemIds="" retVal
    s PIOIPAuditDR=$p(PAStr,"^",1)
    s PAprivilegeMode=$p(PAStr,"^",2)
    s Privilege=$p(PAStr,"^",3)
    s Rebate=$p(PAStr,"^",4)
    //s AsCharged=$p(^DHCPEPreGADM(AdmId),"^",7)
    s SQLCODE=0
    f iLLoop=1:1:$l(ArcItemIds,"^") d
    .s arcItemInfo=$p(ArcItemIds,"^",iLLoop)
    .Q:(""=arcItemInfo)
    .s itemPrice=$p(arcItemInfo,"&",2)
    .s arcItemId=$p(arcItemInfo,"&",1)
    .s UpdateDate=+$H
    .s UpdateTime=$p($H,",",2)
    .s AccountAmount=0,FactAmount=0
    .//s itmPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcItemId,+$H,"","","",itemPrice)
    .//s AccountAmount=+itmPrice
    .s ItemFeeType=""
    .;s loc=%session.Get("LOGON.CTLOCID")
    .s LocID=$P($G(^DHCPEPreGADM(+TeamAdmId)),"^",23)
    .i $G(^DHCPECTDataEx("DHCPEStationOrder","SpecialItem",arcItemId,LocID))'="" d
    ..s ItemFeeType=$G(^DHCPECTDataEx("DHCPEStationOrder","SpecialItem",arcItemId,LocID))
    
    .s AccountAmount=..GetOrderPrice(arcItemId_"&O",TeamAdmId,"0",ItemFeeType)
    .i ((PAprivilegeMode="NP")||(PAprivilegeMode="OP")) s FactAmount=AccountAmount
    .//added 20160811 start
    .s FactAmount1=""
    .s FactAmount1=##class(web.DHCPE.ItemExtend).GetARCPrice(arcItemId,TeamAdmId)
    .i FactAmount1'="" s FactAmount=FactAmount1
    .//added 20160811 end
    .i PAprivilegeMode="OR" s FactAmount=AccountAmount*(Rebate/100)
    .s RecLoc=..GetRecLoc(1,arcItemId,LocID)
    .s SpecDR=..GetDefaultSpecName(arcItemId,"1")
    .
    .&sql(
            insert into sqluser.dhc_pe_preGTOrdItem (
                PGTOI_ParRef, PGTOI_ItmMast_DR, PGTOI_OrdEnt_DR,
                PGTOI_AccountAmount, PGTOI_FactAmount,
                PGTOI_privilegeMode,PGTOI_Privilege,
                PGTOI_UpdateUser_DR,PGTOI_UpdateDate,PGTOI_UpdateTime,
                PGTOI_PAudit_DR,PGTOI_ItemStat,PGTOI_ItemRecLoc_DR)
            values(
                :TeamAdmId,:arcItemId,:OrdEntId,:AccountAmount,:FactAmount,
                :PAprivilegeMode,:Privilege,:UpdateUserId,:UpdateDate,
                :UpdateTime,:PIOIPAuditDR,'1',:RecLoc)
        )
    .q:(SQLCODE'=0)
    .s newId=%ROWID
    .s ^DHCPEDataEx("DHCPEPreIOrdItem","TEAM",newId)=SpecDR
    .s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",TeamAdmId))  //add by 20110902
    .i ItemFeeType'="" s ADMFeeType=ItemFeeType
    .s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",newId)=ADMFeeType
    .//20090115  wrz 
    .i CanBreak="Y" d
    ..s GTIAdm="0"
    ..for  s GTIAdm=$o(^DHCPEPreIADM(0,"PGTeam",TeamAdmId,GTIAdm))  q:(GTIAdm="")||(SQLCODE'=0)  d
    ...s ^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",GTIAdm)=$G(^DHCPEDataEx("DHCPEPreTEAM","PreOrdSet",TeamAdmId))
    ...s retVal=..InsertItem4Person(GTIAdm,arcItemId,"",newId,UpdateUserId,"","PRE",ArcItemSetId,CanBreak)
    ...i retVal'="" s SQLCODE=retVal
    ...q:(""'=retVal)
    .//End
    
    Q:('((0=SQLCODE)||(-119=SQLCODE))) SQLCODE
    s newId=%ROWID
    //s ^DHCPEDataEx("DHCPEPreIOrdItem","TEAM",newId)=SpecDR
    s outGrpNewIds=outGrpNewIds _"^"_newId
    
    // 整理数据 去除空白ID
    i ($l(outGrpNewIds)>0)  s outGrpNewIds=$e(outGrpNewIds,2,$l(outGrpNewIds))  
    
    q retVal
}

///             增加团体组的套餐项目
/// return:     ""-OK, else-ErrorInfo
/// parameter:
///             outNewRowId: Output argument.  return the new RowId . 
/// test:   w ##class(web.DHCPE.PreItemList).InsertItemSet4Team("1||1",1, 1,"")
ClassMethod InsertItemSet4Team(TeamAdmId As %Library.String = "", ArcItemSetId As %Library.String = "", UpdateUserId As %Library.String = "", outNewRowId As %Library.String = "", RepeatFlag As %String = 0)
{
    
    s newGrpOrdItemIds=""
    s newGrpOrdEntId=""
    s temp=""
    s rowCount=0
    s SCOrdSetsID=$P(ArcItemSetId,"^",2)
    s ArcItemSetId=$P(ArcItemSetId,"^",1)
    
    s GSex=$p($g(^DHCPEPreGADM(+TeamAdmId,"Team",$P(TeamAdmId,"||",2))),"^",12) 
    s Sex=$g(^DHCPEDataEx("DHCPEBaseData","Sex",ArcItemSetId))
    
    
    s LocID=$P($G(^DHCPEPreGADM(+TeamAdmId)),"^",23)
    //s SetInfo=$G(^DHCPESetting("DHCPE","DefPatientType"))
    s SetInfo=$G(^DHCPESetting("DHCPE","DefPatientType",LocID))

    q:(GSex ="F")&&( Sex=$P(SetInfo,"^",3)) "体检者性别与医嘱套性别不一致"   //
    q:(GSex ="M")&&( Sex=$P(SetInfo,"^",4)) "体检者性别与医嘱套性别不一致"  

    
    b // InsertItemSet4Team w TeamAdmId_","_ArcItemSetId
    //&sql(select count(*), max(PGTOE_RowId) into :rowCount, :newGrpOrdEntId
    //   from sqluser.dhc_pe_preGTOrdEnt 
    //   where PGTOE_ParRef=:TeamAdmId and PGTOE_OrderSets_DR=:ArcItemSetId and PGTOE_ItemStat="1")
        
    //Modified by MLH 2007-07-12
    Set newGrpOrdEntId="",rowCount=0
    Set OSERowId=$o(^DHCPEOSE(0,"OrdSets",ArcItemSetId,0))
    Set Break=""
    If $g(OSERowId)'="" Set Break=$p(^DHCPEOSE(OSERowId),"^",2)
    ;Set Break="Y"
    Set CanBreak=$s(Break'="Y":"N",Break="Y":"Y")
    
    if (RepeatFlag="1"){
    /// 获取分组上已有的项目
    s itemIds=##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(ArcItemSetId_"^"_SCOrdSetsID)
    /// 过滤已有的项目 by zrc  start
    i itemIds'="" d
    .s Temp=""
    .s itemIdStrs=""
    .s gub=0
    .f  s gub=$o(^DHCPEPreGADM(+TeamAdmId,"Team",$p(TeamAdmId,"||",2),"ORDITEM",gub)) q:gub=""  d
    ..s itemdr=$p($g(^DHCPEPreGADM(+TeamAdmId,"Team",$p(TeamAdmId,"||",2),"ORDITEM",gub)),"^",1)
    ..s status=$p($g(^DHCPEPreGADM(+TeamAdmId,"Team",$p(TeamAdmId,"||",2),"ORDITEM",gub)),"^",13)
    ..q:(status'=1)
    ..s:itemIdStrs'="" itemIdStrs=itemIdStrs_"^"_itemdr
    ..s:itemIdStrs="" itemIdStrs=itemdr
    .i itemIdStrs'="" d
    ..for i=1:1:$l(itemIds,"^") d
    ...s Item=$p(itemIds,"^",i)
    ...i itemIdStrs'[Item d
    ....s:Temp'="" Temp=Temp_"^"_Item
    ....s:Temp="" Temp=Item
    ...e  d
    ....s CanBreak="Y"
    ..s itemIds=Temp
    /// 过滤已有的项目 by zrc  start  end
    }
    if rowCount=0 Do
    .//取审核表
    .s AdmId=+TeamAdmId
    .S LocID=$P($G(^DHCPEPreGADM(+TeamAdmId)),"^",23)
    .S hospId=$P($G(^CTLOC(LocID)),"^",22)
    .s PAStr=..GetPARowId("G",TeamAdmId,"PRE")  
    .If PAStr="" Q:"NotGetPA"
    .s PIOIPAuditDR=$p(PAStr,"^",1)
    .s PAprivilegeMode=$p(PAStr,"^",2)
    .s Privilege=$p(PAStr,"^",3)
    .s Rebate=$p(PAStr,"^",4)
    .s AccountAmount=0,FactAmount=0
    .;s ItemFeeType=
    .i SCOrdSetsID="" d
    ..s AccountAmount=##class(web.DHCPE.Handle.ARCOrdSets).GetPrice(ArcItemSetId,"",TeamAdmId,"","B",LocID,hospId)
    .e  d
    ..s AccountAmount=$P(^DHCPEAP(+SCOrdSetsID,"SC",$P(SCOrdSetsID,"||",2),"OrdSets",$P(SCOrdSetsID,"||",3)),"^",10)
    .i ((PAprivilegeMode="NP")||(PAprivilegeMode="OP")) s FactAmount=AccountAmount
    .i PAprivilegeMode="OR" s FactAmount=AccountAmount*(Rebate/100)
    .s UpdateDate=+$H
    .s UpdateTime=$p($H,",",2)
    .If CanBreak="N" Do //Modified by MLH 2007-07-12
    ..&sql(insert into sqluser.dhc_pe_preGTOrdEnt(PGTOE_ParRef, 
                PGTOE_OrderSets_DR,PGTOE_UpdateUser_DR, PGTOE_UpdateDate, 
                PGTOE_UpdateTime,PGTOE_FactAmount,PGTOE_AccountAmount,PGTOE_ItemStat)
            values(:TeamAdmId, :ArcItemSetId, :UpdateUserId, :UpdateDate,
                :UpdateTime,:FactAmount,:AccountAmount,'1')
            )
    ..If ((SQLCODE'=0)&&(SQLCODE'=-119)) Quit:"Error: insert dhc_pe_preIOrdEnt error , sqlcode="_SQLCODE
    ..s newGrpOrdEntId=%ROWID
    ..s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",TeamAdmId))         //add by 20110902
    ..s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Ent",newGrpOrdEntId)=ADMFeeType  //add by 20110902
    .e  d
    ..s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",TeamAdmId))         //add by 20110902
    ..s:newGrpOrdEntId'="" ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Ent",newGrpOrdEntId)=ADMFeeType  //add by 20110902
    ..s ^DHCPEDataEx("DHCPEPreTEAM","PreOrdSet",TeamAdmId)=$G(^DHCPEDataEx("DHCPEPreTEAM","PreOrdSet",TeamAdmId))_"^"_ArcItemSetId
    if (RepeatFlag="0"){
        s itemIds=##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(ArcItemSetId_"^"_SCOrdSetsID)
    }
    s retVal=..InsertTeamOrdItm(TeamAdmId, itemIds, newGrpOrdEntId, UpdateUserId, .newGrpOrdItemIds,CanBreak,ArcItemSetId)
    q:(retVal'="") retVal   
    s outNewRowId=newGrpOrdEntId
    //20090115  wrz
    q:CanBreak="Y" retVal
    
    s AdmIndex="0"
    f  s AdmIndex=$o(^DHCPEPreIADM(0,"PGTeam",TeamAdmId,AdmIndex))  q:AdmIndex=""  d
    .//b // InsertItemSet4Team 个人项目套            
    .s retVal=..InsertItemSet4Person(AdmIndex, ArcItemSetId_"^"_SCOrdSetsID,newGrpOrdEntId,UpdateUserId, temp,"PRE" )
    .q:(retVal'="")
    
    s outNewRowId=newGrpOrdEntId
    q retVal
}

/// 删除个人/团体的医嘱项目或项目套餐
/// parameter: 
///     AdmId: PreIAdmId /PreGAdmId
///     AdmType  "PERSON"/"TEAM"
///     ArcItemId and ArcItemSetId: There is only one is not NULL
///     OrdItemId 医嘱项目表的编码
///     OrdEntId 项目套餐表的编码
///                 
///     return: ""-OK, Else-Error
/// w ##class(web.DHCPE.PreItemList).IDeleteItem(543,"PERSON","543||16","")
ClassMethod IDeleteItem(AdmId As %Library.String = "", AdmType As %Library.String = "", OrdItemId As %Library.String = "", OrdEntId As %Library.String = "", AddAmountFlag As %Library.String = "0", User As %String = "") As %String
{
	q ##class(web.DHCPE.PreItemList2).IDeleteItem(AdmId,AdmType,OrdItemId,OrdEntId,AddAmountFlag,User)
}

/// Create by MLH 2008-05-22
/// 删除单个项目时(包括套餐项目),更新审核表金额
/// w ##class(web.DHCPE.PreItemList).PAUpdateAmount("649||5")
ClassMethod OrdItemUpdateAmount(OrdItemId As %String = "") As %String
{
    Quit:(OrdItemId="") -1
    Set AdmId=+OrdItemId
    Set AAUpdate=0
    Set OrdType="ORDITEM"
    Set OrdChd=$p(OrdItemId,"||",2)
    Set OrdEnt=$p(^DHCPEPreIADM(AdmId,"ORDITEM",OrdChd),"^",2)
    Set AccountAmount=0
    If OrdEnt'="" Do
    .Set OrdType="ORDENT"
    .Set OrdChd=$p(OrdEnt,"||",2)
    .Set ArcimDR=$p(^DHCPEPreIADM(AdmId,"ORDITEM",$p(OrdItemId,"||",2)),"^",1)
    .Set ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",OrdItemId)) //add by 20110908
    .Set AccountAmount=..GetOrderPrice(ArcimDR,AdmId,"",ADMFeeType)
    .Set AccountAmount=$p(AccountAmount,"^",1)
    Else  Do 
    .Set AccountAmount=$p(^DHCPEPreIADM(AdmId,OrdType,OrdChd),"^",14)
    
    Set FeeChd=0
    For  Set FeeChd=$o(^DHCPEPreIADM(AdmId,OrdType,OrdChd,"FEE",FeeChd))  Quit:FeeChd=""  Do
    .Set FEEStr=^DHCPEPreIADM(AdmId,OrdType,OrdChd,"FEE",FeeChd)
    .//Set FactAmount=$p(FEEStr,"^",2)
    .Set FactAmount=AccountAmount
    .Set PADR=$p(FEEStr,"^",5)
    .If AAUpdate=0 Do 
    ..Set ret=..UpdateAmount(PADR,AccountAmount,0,FactAmount,0)
    ..Set AAUpdate=1
    .Else  Do
    ..Set ret=..UpdateAmount(PADR,0,0,FactAmount,0)
    Quit $g(ret)
}

/// Create by MLH 2008-05-22
/// 删除套餐,更新审核表金额
/// w ##class(web.DHCPE.PreItemList).PAUpdateAmount("649||5")
ClassMethod OrdEntUpdateAmount(OrdEnt As %String = "") As %String
{
    Quit:OrdEnt="" -1
    Set AAUpdate=0,FactAmount=0,AccountAmount=0
    Set AdmId=+OrdEnt
    Set OrdEntChd=$p(OrdEnt,"||",2)
    
    Set AccountAmount=$p(^DHCPEPreIADM(AdmId,"ORDENT",OrdEntChd),"^",7)
    
    Set FeeChd=0
    For  Set FeeChd=$o(^DHCPEPreIADM(AdmId,"ORDENT",OrdEntChd,"FEE",FeeChd))  Quit:FeeChd=""  Do
    .Set FEEStr=^DHCPEPreIADM(AdmId,"ORDENT",OrdEntChd,"FEE",FeeChd)
    .Set FactAmount=$p(FEEStr,"^",2)
    .Set PADR=$p(FEEStr,"^",5)
    .If AAUpdate=0 Do
    ..Set ret=..UpdateAmount(PADR,AccountAmount,0,FactAmount,0)
    ..Set AAUpdate=1
    .Else  Do
    ..Set ret=..UpdateAmount(PADR,0,0,FactAmount,0)
    
    Quit $g(ret)
}

/// Create by MLH 2007-11-27
/// 删除医嘱项时改变医嘱套的价格
ClassMethod GChangeEntAmount(OrdItemId) As %String
{
    Set rebate=100  
    Set GChangeRet=0
    Set GADM=$p(OrdItemId,"||",1)
    Set GTeam=$p(OrdItemId,"||",2)
    Set GItemChd=$p(OrdItemId,"||",3)
    Set ArcimDR=$p(^DHCPEPreGADM(GADM,"Team",GTeam,"ORDITEM",GItemChd),"^",1)
    Set OrdItemOfEnt=$p(^DHCPEPreGADM(GADM,"Team",GTeam,"ORDITEM",GItemChd),"^",2)
    If OrdItemOfEnt'="" Do
    .Set TeamFeeType=$G(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",OrdItemId))
    .Set PGTOIAccountAmount=..GetOrderPrice(ArcimDR,GADM_"||"_GTeam,"",TeamFeeType)
    .Set PGTOEAccountAmount=$P(^DHCPEPreGADM(GADM,"Team",GTeam,"ORDENT",$P(OrdItemOfEnt,"||",3)),"^",6)
    .Set PGTOEAANew=PGTOEAccountAmount-PGTOIAccountAmount
    .Set PGTOEFactAmount=$P(^DHCPEPreGADM(GADM,"Team",GTeam,"ORDENT",$P(OrdItemOfEnt,"||",3)),"^",5)
    .Set AuditID=$p(^DHCPEPreGADM(GADM,"Team",GTeam,"ORDITEM",GItemChd),"^",12)
    .Set rebate=$p(^DHCPEPreA(AuditID),"^",5)   
    .Set PGTOEFANew=""
    .If (($g(PGTOEFactAmount)'="")&&($g(PGTOEFactAmount)'=0)) Do
    ..i rebate'=""  set PGTOEFANew=(PGTOEAANew*rebate)/100              //add by zhouli
    ..e  Set PGTOEFANew=PGTOEFactAmount-PGTOIAccountAmount             //add by zhouli
    .//Set ^lisatest("1126",":PGTOEFANew")=PGTOEFANew
    .&sql(update dhc_pe_pregtordent SET PGTOE_AccountAmount=:PGTOEAANew,PGTOE_FactAmount=:PGTOEFANew
           where PGTOE_RowId=:OrdItemOfEnt)
    .//b //888
    .i '(("0"=SQLCODE)||("100"=SQLCODE)) goto GChangeErr
    .&sql(update dhc_pe_preiordent SET PIOE_AccountAmount=:PGTOEAANew,PIOE_FactAmount=:PGTOEFANew
           where PIOE_GTOE_DR=:OrdItemOfEnt)
    .i '(("0"=SQLCODE)||("100"=SQLCODE)) goto GChangeErr
    Quit GChangeRet
    
GChangeErr  
    Set GChangeRet=SQLCODE
    Quit GChangeRet
}

// w ##class(web.DHCPE.PreItemList).IChangeEntAmount("595||31")

/// Create by MLH 2007-11-27
/// 删除医嘱项时改变医嘱套的价格
ClassMethod IChangeEntAmount(OrdItemId) As %String
{
  
    set rebate=100                      //add by zhouli   
    Set IChangeRet=0
    Set AdmId=$p(OrdItemId,"||",1)
    Set ArcimDR=$p(^DHCPEPreIADM(AdmId,"ORDITEM",$p(OrdItemId,"||",2)),"^",1)
    Set OrdItemOfEnt=$p(^DHCPEPreIADM(AdmId,"ORDITEM",$p(OrdItemId,"||",2)),"^",2)

    If OrdItemOfEnt'="" Do
    .Set ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",OrdItemId))  //add by 20110908
    .Set PIOIAccountAmount=..GetOrderPrice(ArcimDR,AdmId,"",ADMFeeType)              //add by 20110908
    .Set PIOIAccountAmount=$p(PIOIAccountAmount,"^",1)
    .Set PIOIAccountAmount=+$g(^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",OrdItemOfEnt,OrdItemId))
    .Set PIOEAccountAmount=$P(^DHCPEPreIADM(AdmId,"ORDENT",$P(OrdItemOfEnt,"||",2)),"^",7)
    .Set PIOEAANew=PIOEAccountAmount-PIOIAccountAmount
    .Set PIOEFactAmount=0
    .//循环累加医嘱套费用表的实际金额
    .Set FeeChd=0
    .For  Set FeeChd=$o(^DHCPEPreIADM(AdmId,"ORDENT",$P(OrdItemOfEnt,"||",2),"FEE",FeeChd)) Quit:FeeChd=""  Do
    ..////Add By WRZ 2008-12-13  退费后删除医嘱套里面的项目会重复计费
    ..s AuditID=$p($g(^DHCPEPreIADM(AdmId,"ORDENT",$P(OrdItemOfEnt,"||",2),"FEE",FeeChd)),"^",5)
    ..q:AuditID=""
    ..s AuditFlag=$p($G(^DHCPEPreA(AuditID)),"^",21)
    ..s rebate=$p(^DHCPEPreA(AuditID),"^",5)      //add by zhouli
    ..q:AuditFlag="NU"
    ../////End
    ..Set ChdFactAmount=$p($g(^DHCPEPreIADM(AdmId,"ORDENT",$P(OrdItemOfEnt,"||",2),"FEE",FeeChd)),"^",2)
    ..Set PIOEFactAmount=PIOEFactAmount+ChdFactAmount
    .///////////////////////////
    .Set PIOEFANew=""
    .If (($g(PIOEFactAmount)'="")&&($g(PIOEFactAmount)'=0)) Do
    ..i rebate'=""  set PIOEFANew=(PIOEAANew*rebate)/100              //modify  by zhouli
    ..e  Set PIOEFANew=PIOEFactAmount-PIOIAccountAmount               //modify  by zhouli
    .&sql(update dhc_pe_preiordentfee set pioef_factamount=:PIOEFANew where pioef_parref=:OrdItemOfEnt)
    .i '(("0"=SQLCODE)||("100"=SQLCODE)) goto ChangeErr
    .&sql(update dhc_pe_preiordent SET PIOE_AccountAmount=:PIOEAANew,PIOE_FactAmount=:PIOEFANew
           where PIOE_RowId=:OrdItemOfEnt)
    .//b //888
    .i '(("0"=SQLCODE)||("100"=SQLCODE)) goto ChangeErr
    .d ##class(web.DHCPE.OrdSetsPrice).SplitOrdSetPrice(OrdItemOfEnt)
    Quit IChangeRet
    
ChangeErr   
    Set IChangeRet=SQLCODE
    Quit IChangeRet
}

// w ##class(web.DHCPE.PreItemList).Exit("570")

/// 团体组增加??员
/// 使用      web.DHCPE.PreIADM.Save(增加团体组人员)
/// Description: Insert Team's orderItems into person's OrdItem when a person is added into a team.
/// return:  ""-ok, else-errInfo
/// test:  w ##class(web.DHCPE.PreItemList).IInsOrd4NewPat("1||1", "34", "10166")
ClassMethod IInsOrd4NewPat(TeamId As %Library.String = "", IAdmId As %Library.String = "", UpdateUserId As %Library.String = "", UseTrans As %String = "1")
{
	s ^listest("IInsOrd4NewPat")=TeamId_","_IAdmId_","_UpdateUserId
	
	s retVal=##class(web.DHCPE.PreItemList2).IInsertItem(IAdmId,"","PRE",TeamId,"",UpdateUserId)
	q retVal
}

/// 给新的团体组成员 增加团体组的医嘱套项目
ClassMethod InsOrdEnt4NewPat(TeamId As %Library.String = "", IAdmId As %Library.String = "", UpdateUserId As %Library.String = "") [ Private ]
{
    s retVal=""
    s subGrp=$p(TeamId,"||",1)
    s subTeam=$p(TeamId,"||",2)
    s subLast="0"
    f  s subLast=$o(^DHCPEPreGADM(subGrp,"Team",subTeam,"ORDENT",subLast))  q:((subLast="")||(retVal'=""))  d
    .s gTOrdEntId=subGrp_"||"_subTeam_"||"_subLast
    .s arcItemSetId=$p(^DHCPEPreGADM(subGrp,"Team",subTeam,"ORDENT",subLast),"^",1)
    .Set arcItemStatus=$P(^DHCPEPreGADM(subGrp,"Team",subTeam,"ORDENT",subLast),"^",7)
    .i ((arcItemSetId'="")&&(gTOrdEntId'="")&&(arcItemStatus'=4))  d
    ..// 个人项目套
    ..s retVal=..InsertItemSet4Person(IAdmId, arcItemSetId, gTOrdEntId,  UpdateUserId, "","PRE")
    q retVal
}

/// 给新的团体组成员 增加团体组的医嘱项目
/// return:  ""-ok, else-errInfo
ClassMethod InsOrdItm4NewPat(TeamId As %Library.String = "", IAdmId As %Library.String = "", UpdateUserId As %Library.String = "") [ Private ]
{
    s retVal=""
    s subGrp=$p(TeamId,"||",1), subTeam=$p(TeamId,"||",2), subLast="0"
    f  s subLast=$o(^DHCPEPreGADM(subGrp,"Team",subTeam,"ORDITEM",subLast))  q:((subLast="")||(retVal'=""))  d
    .s strData=^DHCPEPreGADM(subGrp,"Team",subTeam,"ORDITEM",subLast)
    .s gTOrdItmId=subGrp_"||"_subTeam_"||"_subLast
    .s arcItemId=$p(strData,"^",1)
    .Set arcItemStatus=$p(strData,"^",13)
    .i (($p(strData,"^",2)="")&&(arcItemStatus'=4)) d
    ..// 个人单项目
    ..s retVal=..InsertItem4Person(IAdmId, arcItemId, "", gTOrdItmId, UpdateUserId, "","PRE")
    
    q retVal
}

/// ////////////////////////////////////////////////////////////////////////////
/// 保存个人的应收金额和最终金额/如果是团体成员，则保存团体应收金额和最终金额
/// Created by MLH
ClassMethod UpdateAmount(PARowId As %String = "", SrcAmount1 As %String = "", TarAmount1 As %String = "", SrcAmount2 As %String = "", TarAmount2 As %String = "")
{
    q:PARowId="" -1
    s PAAccountAmount=$p(^DHCPEPreA(PARowId),"^",6)
    s PAFactAmount=$p(^DHCPEPreA(PARowId),"^",9)
    s PAAccountAmount=$s(PAAccountAmount'="":PAAccountAmount,PAAccountAmount="":0)
    s PAFactAmount=$s(PAFactAmount'="":PAFactAmount,PAFactAmount="":0)
    
    s SrcAmount1=$s(SrcAmount1'="":SrcAmount1,SrcAmount1="":0)
    s TarAmount1=$s(TarAmount1'="":TarAmount1,TarAmount1="":0)
    s SrcAmount2=$s(SrcAmount2'="":SrcAmount2,SrcAmount2="":0)
    s TarAmount2=$s(TarAmount2'="":TarAmount2,TarAmount2="":0)
    
    s AccountAmount=PAAccountAmount-SrcAmount1+TarAmount1
    s FactAmount=PAFactAmount-SrcAmount2+TarAmount2
    
    b
    &sql(update sqluser.DHC_PE_PreAudit 
        set PA_AccountAmount=:AccountAmount,
            PA_DiscountedAmount=:FactAmount,
            PA_FactAmount=:FactAmount
         where PA_RowId=:PARowId
         )
    
    Q SQLCODE
}

/// 根据个人GADM得到团体ID,然后得到对应团体的折扣率 wrz 07/03/21
ClassMethod GetGADMRebate(GADM)
{
    //new GADM,GBaseInfoID,CRMGBaseInfoID
    // 看是否是团体成员
    i GADM="" q 1
    s GBaseInfoID=$P($G(^DHCPEPreGADM(GADM)),"^",1)
    i GBaseInfoID="" q 1
    s Rebate=$P($G(^DHCPEGBI(GBaseInfoID)),"^",14)
    q Rebate/100
}

/// 获取医嘱的费用（应收金额） 
/// Description: Get the total amount of a persn/Team/Group
/// parameter:
///     AdmType:        "PERSN"/"TEAM"/"GROUP" 
///         计算的类型：  个人/团体组/团体
///     AdmId:  个人      (DHC_PE_PreIADM.PIADM_RowId)
///             团体组 (DHC_PE_PreGADM.PGADM_RowId)
///             团体      (DHC_PE_PreGTeam.PGT_RowId)
///     return: totalAmount
///     test: w ##class(web.DHCPE.PreItemList).IGetOrdAmount("1","GROUP")
ClassMethod IGetOrdAmountHISUI(AdmId As %Library.String = "", AdmType As %Library.String = "", IsSave As %String = "0")
{
    s AdmId=$p(AdmId,"^",1)   //add by zl20100624
    q:((AdmId="")||(AdmType="")) 0
    s retVal=0
    
    i (AdmType="PERSON") d //个人的应收金额
    .s retVal=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(AdmId)
    
    i (AdmType="TEAM") d //团体组的应收金额
    .s retVal=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Team(AdmId)
    
    i (AdmType="GROUP") d //团体的应收金额
    .s retVal=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Grp(AdmId)
    
    s Amount=$p(retVal,"^",1)
    s Fact=$p(retVal,"^",2)
    
    q $fn(Fact,"",2)
}

ClassMethod IGetOrdAmount(AdmId As %Library.String = "", AdmType As %Library.String = "", IsSave As %String = "0")
{
    s AdmId=$p(AdmId,"^",1)   //add by zl20100624
    q:((AdmId="")||(AdmType="")) 0
    s retVal=0
    
    i (AdmType="PERSON") d //个人的应收金额
    .s retVal=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(AdmId)
    
    i (AdmType="TEAM") d //团体组的应收金额
    .s retVal=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Team(AdmId)
    
    i (AdmType="GROUP") d //团体的应收金额
    .s retVal=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Grp(AdmId)
    
    s Amount=$p(retVal,"^",1)
    s Fact=$p(retVal,"^",2)
    q "应收金额"_$C(13)_Amount_$C(13)_"优惠金额"_$C(13)_Fact
    q retVal
}

/// parameter:
///         AdmType: "PERSON"/"GROUP"
ClassMethod ISaveFactAmount(AdmId As %Library.String = "", AdmType As %Library.String = "", FactAmount As %Library.String = "")
{
    q:((AdmId="")||(AdmType="")||(FactAmount="")) "ERROR:The arguments are not complete in "_$zn
    s retVal=""
    if AdmType="PERSON"{
        s objAdm=##class(User.DHCPEPreIADM).%OpenId(AdmId)
        q:objAdm.PIADMStatus'="PREREG" "ERROR: The Status is not preReg of person "_AdmId_ "  "_$zn
        s objAdm.PIADMFactAmount=FactAmount
        d objAdm.%Save()
    }elseif AdmType="GROUP"{
        s objAdm=##class(User.DHCPEPreGADM).%OpenId(AdmId)
        q:objAdm.PGADMStatus'="PREREG" "ERROR: The Status is not preReg of GROUP "_AdmId_ "  "_$zn
        s objAdm.PGADMFactAmount=FactAmount
        d objAdm.%Save()
    }
    q ""
}

/// 更新优惠金额
/// Type Person:个人  Item:分组
ClassMethod UpdateOPAmount(Strings, Type)
{
    //new ItemID,AuditID,FactAmount,i,j,String,OldFactAmount
    
    s i=$length(Strings,"^")
    s SQLCODE=0
    TSTART
    for j=1:1:i
    {
        s String=$p(Strings,"^",j)
        s ItemID=$p(String,",",1)
        s FactAmount=$p(String,",",2)
        i FactAmount="" s FactAmount=0
        ///Modified By WRZ 2009-01-06
        
        s Qty=$p(String,",",3)
        i +Qty=0 s Qty=1
        s FactAmount=FactAmount*Qty
        s AccountAmount=+$p(String,",",4)
        s AccountAmount=AccountAmount*Qty
        ///Modified End
    
        i Type="PERSON"
        {
            s SQLCODE=..UpdateItemByPerson(ItemID,FactAmount,Qty,AccountAmount)
        }
        i Type="TEAM"
        {
            s SQLCODE=..UpdateItemByItem(ItemID,FactAmount,Qty,AccountAmount)
        }
        q:SQLCODE
    }
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    i Type="PERSON"
    {
        s iAdm=+ItemID
       
        s SQLCODE=##class(web.DHCPE.PreAudit).UpdateFeeRecord(iAdm,"OPAmount")
        i SQLCODE
        {
            TROLLBACK
            q SQLCODE
        }
        s gAdm=$p(^DHCPEPreIADM(iAdm),"^",2)
        i gAdm="" d
        .s SQLCODE=##class(web.DHCPE.PreIADM).UpdatePersonAuditAmount(iAdm)
        e  d
        .s SQLCODE=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(gAdm,"")
        
    }
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }             
    TCOMMIT
    q SQLCODE
}

ClassMethod UpdateItemByItem(ItemID, FactAmount, Qty As %String = "1", AccountAmount)
{
    s SQLCODE=0
    s Parref=$p(ItemID,"||",1)
    s TSub=$p(ItemID,"||",2)
    s Sub=$p(ItemID,"||",3)
    s OEntID=$p($g(^DHCPEPreGADM(Parref,"Team",TSub,"ORDITEM",Sub)),"^",2)
    i OEntID=""
    {
        s OldFactAmount=$p($g(^DHCPEPreGADM(Parref,"Team",TSub,"ORDITEM",Sub)),"^",6)
    }
    else
    {
        s OldFactAmount=..GetGTOrdEntPrice(OEntID)
    }
     i OldFactAmount="" s OldFactAmount=0
    //q:FactAmount=OldFactAmount SQLCODE
     
     &SQL(update sqluser.DHC_PE_PreGTOrdItem set PGTOI_FactAmount=:FactAmount,PGTOI_AccountAmount=:AccountAmount where PGTOI_RowId=:ItemID)
     q:SQLCODE SQLCODE
     s ^DHCPEDataEx("DHCPEPreGTOrdItem","Qty",ItemID)=Qty
     s IADM=0
     f  s IADM=$o(^DHCPEPreIADM(0,"GTOI",ItemID,IADM)) q:(IADM="")||(SQLCODE'=0)  d
     .s Sub=0
     .f  s Sub=$o(^DHCPEPreIADM(0,"GTOI",ItemID,IADM,Sub)) q:(Sub="")||(SQLCODE'=0)  d 
     ..s IFlag=$p(^DHCPEPreIADM(IADM,"ORDITEM",Sub),"^",16)
     ..q:IFlag'="1"
     ..s FSub=0
     ..s Flag=0
     ..f  s FSub=$o(^DHCPEPreIADM(IADM,"ORDITEM",Sub,"FEE",FSub)) q:(FSub="")||(Flag=1)  d
     ...s PAudit=$p(^DHCPEPreIADM(IADM,"ORDITEM",Sub,"FEE",FSub),"^",5)
     ...q:PAudit=""
     ...s IFlag=$p(^DHCPEPreA(PAudit),"^",21)
     ...s:IFlag="NU" Flag=1
     ...s IFlag=$p(^DHCPEPreA(PAudit),"^",19)
     ...;s:IFlag'="OP" Flag=1
     ...s IFlag=$p(^DHCPEPreA(PAudit),"^",14)
     ...s:IFlag="CHARGED" Flag=1
     ...q:Flag=1
     ...s FID=IADM_"||"_Sub_"||"_FSub
     ...&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_FactAmount=:FactAmount where PIOIF_RowId=:FID)
     ...s:SQLCODE'=0 Flag=1
     ..q:Flag=1
     ..s IID=IADM_"||"_Sub
     ..&SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_FactAmount=:FactAmount,PIOI_AccountAmount=:AccountAmount where PIOI_RowId=:IID)
     ..s ^DHCPEDataEx("DHCPEPreIOrdItem","Qty",IID)=Qty
    /*
    i OEntID=""
    {
        &SQL(update sqluser.DHC_PE_PreGTOrdItem set PGTOI_FactAmount=:FactAmount,PGTOI_AccountAmount=:AccountAmount where PGTOI_RowId=:ItemID)
        //0924
        q:SQLCODE SQLCODE
        s ^DHCPEDataEx("DHCPEPreGTOrdItem","Qty",ItemID)=Qty
        s IADM=0
        f  s IADM=$o(^DHCPEPreIADM(0,"GTOI",ItemID,IADM)) q:(IADM="")||(SQLCODE'=0)  d
        .s Sub=0
        .f  s Sub=$o(^DHCPEPreIADM(0,"GTOI",ItemID,IADM,Sub)) q:(Sub="")||(SQLCODE'=0)  d 
        ..s IFlag=$p(^DHCPEPreIADM(IADM,"ORDITEM",Sub),"^",16)
        ..q:IFlag'="1"
        ..s FSub=0
        ..s Flag=0
        ..f  s FSub=$o(^DHCPEPreIADM(IADM,"ORDITEM",Sub,"FEE",FSub)) q:(FSub="")||(Flag=1)  d
        ...s PAudit=$p(^DHCPEPreIADM(IADM,"ORDITEM",Sub,"FEE",FSub),"^",5)
        ...q:PAudit=""
        ...s IFlag=$p(^DHCPEPreA(PAudit),"^",21)
        ...s:IFlag="NU" Flag=1
        ...s IFlag=$p(^DHCPEPreA(PAudit),"^",19)
        ...;s:IFlag'="OP" Flag=1
        ...s IFlag=$p(^DHCPEPreA(PAudit),"^",14)
        ...s:IFlag="CHARGED" Flag=1
        ...q:Flag=1
        ...s FID=IADM_"||"_Sub_"||"_FSub
        ...&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_FactAmount=:FactAmount where PIOIF_RowId=:FID)
        ...s:SQLCODE'=0 Flag=1
        ..q:Flag=1
        ..s IID=IADM_"||"_Sub
        ..&SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_FactAmount=:FactAmount,PIOI_AccountAmount=:AccountAmount where PIOI_RowId=:IID)
        ..s ^DHCPEDataEx("DHCPEPreIOrdItem","Qty",IID)=Qty
        
        
        
    }
    else
    {
        ;&SQL(update sqluser.DHC_PE_PreGTOrdEnt set PGTOE_FactAmount=:FactAmount,PGTOE_AccountAmount=:AccountAmount where PGTOE_RowId=:OEntID)
        s ^DHCPEDataEx("DHCPEPreGTOrdEnt","Qty",OEntID)=Qty
        //0924
        q:SQLCODE SQLCODE
        s IADM=0
        f  s IADM=$o(^DHCPEPreIADM(0,"GTOE",OEntID,IADM)) q:(IADM="")||(SQLCODE'=0)  d
        .s Sub=0
        .f  s Sub=$o(^DHCPEPreIADM(0,"GTOE",OEntID,IADM,Sub)) q:(Sub="")||(SQLCODE'=0)  d 
        ..s IFlag=$p(^DHCPEPreIADM(IADM,"ORDENT",Sub),"^",9)
        ..q:IFlag'="1"
        ..s FSub=0
        ..s Flag=0
        ..f  s FSub=$o(^DHCPEPreIADM(IADM,"ORDENT",Sub,"FEE",FSub)) q:(FSub="")||(Flag=1)  d
        ...s PAudit=$p(^DHCPEPreIADM(IADM,"ORDENT",Sub,"FEE",FSub),"^",5)
        ...q:PAudit=""
        ...s IFlag=$p(^DHCPEPreA(PAudit),"^",21)
        ...s:IFlag="NU" Flag=1
        ...s IFlag=$p(^DHCPEPreA(PAudit),"^",19)
        ...;s:IFlag'="OP" Flag=1
        ...s IFlag=$p(^DHCPEPreA(PAudit),"^",14)
        ...s:IFlag="CHARGED" Flag=1
        ...q:Flag=1
        ...s FID=IADM_"||"_Sub_"||"_FSub
        ...;&SQL(update sqluser.DHC_PE_PreIOrdEntFee set PIOEF_FactAmount=:FactAmount where PIOEF_RowId=:FID)
        ...s:SQLCODE'=0 Flag=1
        ..q:Flag=1
        ..s IID=IADM_"||"_Sub
        ..;&SQL(update sqluser.DHC_PE_PreIOrdEnt set PIOE_FactAmount=:FactAmount,PIOE_AccountAmount=:AccountAmount where PIOE_RowId=:IID)
        ..s ^DHCPEDataEx("DHCPEPreIOrdEnt","Qty",IID)=Qty
   
        
    }
    */
    q:SQLCODE SQLCODE
    s SQLCODE=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(+ItemID)
    
    q SQLCODE
    //s AuditID=$p($g(^DHCPEPreGADM(Parref,"Team",TSub,"ORDITEM",Sub)),"^",12)
    //s SQLCODE=##class(web.DHCPE.PreItemList).UpdateAmount(AuditID,0,0,OldFactAmount,FactAmount)
    //q SQLCODE
}

ClassMethod UpdateItemByPerson(ItemID, FactAmount, Qty As %String = "1", AccountAmount)
{
   
    s SQLCODE=0
    s Parref=$p(ItemID,"||",1)
    s Sub=$p(ItemID,"||",2)
    s OEntID=$p($g(^DHCPEPreIADM(Parref,"ORDITEM",Sub)),"^",2)
    i OEntID=""
    {
        s OldFactAmount=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(ItemID,"","")
        //$p($g(^DHCPEPreIADM(Parref,"ORDITEM",Sub)),"^",6)
    }
    else
    {
        s lisatest("0420","555")=OEntID
        s OldFactAmount=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByOrd(OEntID,"","")
        //$p(..GetOrdEntPrice(OEntID),"^",2)
    }
    i OldFactAmount="" s OldFactAmount=0
    i OEntID=""
    {
        s ^DHCPEDataEx("DHCPEPreIOrdItem","Qty",ItemID)=Qty 
        &SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_AccountAmount=:AccountAmount where PIOI_RowId=:ItemID)
        q:SQLCODE'=0 SQLCODE
        s CRMOrderID=$o(^DHCPECRMO(0,"CRMORI",ItemID,0))
        i CRMOrderID'="" d
        .s OEORIID=$p($G(^DHCPECRMO(CRMOrderID)),"^",1)
        .&SQL(update sqluser.OE_OrdItem set OEORI_PhQtyOrd=:Qty where OEORI_RowId=:OEORIID)
        .q:SQLCODE
        .///更新  dhc_oedispensing
        .s OEDID=$o(^DHCOEDISQTY(0,"OEORI",OEORIID,""),-1)
        .q:OEDID=""
        .&SQL(update sqluser.dhc_oedispensing set DSP_TotalQty=:Qty,DSP_Qty=:Qty,DSP_ConfirmQty=:Qty where DSP_RowID=:OEDID)
    }
    else
    {
		s ^DHCPEDataEx("DHCPEPreIOrdItem","Qty",ItemID)=Qty 
        &SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_AccountAmount=:AccountAmount where PIOI_RowId=:ItemID)
        q:SQLCODE'=0 SQLCODE
        s CRMOrderID=$o(^DHCPECRMO(0,"CRMORI",ItemID,0))
        i CRMOrderID'="" d
        .s OEORIID=$p($G(^DHCPECRMO(CRMOrderID)),"^",1)
        .&SQL(update sqluser.OE_OrdItem set OEORI_PhQtyOrd=:Qty where OEORI_RowId=:OEORIID)
        .q:SQLCODE
        .///更新  dhc_oedispensing
        .s OEDID=$o(^DHCOEDISQTY(0,"OEORI",OEORIID,""),-1)
        .q:OEDID=""
        .&SQL(update sqluser.dhc_oedispensing set DSP_TotalQty=:Qty,DSP_Qty=:Qty,DSP_ConfirmQty=:Qty where DSP_RowID=:OEDID)
	
	
        s ^DHCPEDataEx("DHCPEPreIOrdEnt","Qty",OEntID)=Qty
        
        ;&SQL(update sqluser.DHC_PE_PreIOrdEnt set PIOE_AccountAmount=:AccountAmount where PIOE_RowId=:OEntID)
    }
    q:SQLCODE'=0 SQLCODE
    q:FactAmount=OldFactAmount SQLCODE
    //w !,FactAmount
    i OEntID=""
    {
        s fSub=0,Num=0
        f  s fSub=$o(^DHCPEPreIADM(Parref,"ORDITEM",Sub,"FEE",fSub)) q:(fSub="")||(SQLCODE'=0)  d
        .s fId=Parref_"||"_Sub_"||"_fSub
        .s AId=$p(^DHCPEPreIADM(Parref,"ORDITEM",Sub,"FEE",fSub),"^",5)
        .q:AId=""
        .s PAStatus=$p(^DHCPEPreA(AId),"^",21)
        .q:PAStatus="NU"
         .s Num=Num+1
         .//w !,fId_"%%"_FactAmount_"%%"_Num
        .i Num=1  d
        ..s ^zl("20120208",fId)=FactAmount
        ..&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_FactAmount=:FactAmount, PIOIF_AccountAmount=:FactAmount where PIOIF_RowId=:fId)
        .else  d
        ..//w !,fId_"%%"_FactAmount_"%%"_Num
        ..&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_FactAmount=0, PIOIF_AccountAmount=0 where PIOIF_RowId=:fId)
    }
    else
    {   
	
		s fSub=0,Num=0
        f  s fSub=$o(^DHCPEPreIADM(Parref,"ORDITEM",Sub,"FEE",fSub)) q:(fSub="")||(SQLCODE'=0)  d
        .s fId=Parref_"||"_Sub_"||"_fSub
        .s AId=$p(^DHCPEPreIADM(Parref,"ORDITEM",Sub,"FEE",fSub),"^",5)
        .q:AId=""
        .s PAStatus=$p(^DHCPEPreA(AId),"^",21)
        .q:PAStatus="NU"
         .s Num=Num+1
         .//w !,fId_"%%"_FactAmount_"%%"_Num
        .i Num=1  d
        ..s ^zl("20120208",fId)=FactAmount
        ..&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_FactAmount=:FactAmount, PIOIF_AccountAmount=:FactAmount where PIOIF_RowId=:fId)
        .else  d
        ..//w !,fId_"%%"_FactAmount_"%%"_Num
        ..&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_FactAmount=0, PIOIF_AccountAmount=0 where PIOIF_RowId=:fId)
		
		
        s Sub=$p(OEntID,"||",2)
        s fSub=0,Num=0
        f  s fSub=$o(^DHCPEPreIADM(Parref,"ORDENT",Sub,"FEE",fSub)) q:(fSub="")||(SQLCODE'=0)  d
        .s fId=Parref_"||"_Sub_"||"_fSub
        .s AId=$p(^DHCPEPreIADM(Parref,"ORDENT",Sub,"FEE",fSub),"^",5)
        .q:AId=""
        .s PAStatus=$p(^DHCPEPreA(AId),"^",21)
        .q:PAStatus="NU"
        .s Num=Num+1
        .i Num=1 d
        ..;&SQL(update sqluser.DHC_PE_PreIOrdEntFee set PIOEF_FactAmount=:FactAmount where PIOEF_RowId=:fId)
        .else  d
        ..;&SQL(update sqluser.DHC_PE_PreIOrdEntFee set PIOEF_FactAmount=0 where PIOEF_RowId=:fId)
        //&SQL(update sqluser.DHC_PE_PreIOrdEnt set PIOE_FactAmount=:FactAmount where PIOE_RowId=:OEntID)
    }
    q:SQLCODE SQLCODE
    q SQLCODE
}

ClassMethod GetGTOrdEntPrice(OrdEntID)
{
    s OEAdm=$p(OrdEntID,"||",1)
    s OESub=$p(OrdEntID,"||",2)
    s Sub=$p(OrdEntID,"||",3)
    s OEOnePrice=$p(^DHCPEPreGADM(OEAdm,"Team",OESub,"ORDENT",Sub),"^",5)
    i OEOnePrice="" s OEOnePrice=0
    q OEOnePrice
}

ClassMethod GetPAList(AdmId As %Library.String = "", PreOrAdd As %Library.String = "", AdmType As %Library.String = "", OEOrdItem As %Library.String = "", OEOrdEnt As %Library.String = "", ADMFeeType As %Library.String = "")
{
    S ^tempdhcpe("0410","GetPARowId")=AdmId_"^"_PreOrAdd_"^"_AdmType_"^"_OEOrdItem_"^"_OEOrdEnt
    Q:((AdmId="")||(PreOrAdd="")||(AdmType="")) ""
    Q:((OEOrdItem="")&&(OEOrdEnt=""))
    i AdmType="I" d
    .s CRMADM=AdmId
    e  d
    .s CRMADM=""
    s PGAdm="",AddOrdItem="",AddLimit="",PGTeam=""
    //是否自结
    s DisChargedMode=""
    i (AdmType="I")  s DisChargedMode=$p(^DHCPEPreIADM(AdmId),"^",17)
    //**********
    s GAdd=1 //GAdd=1是否取团体审核表里
    i ((AdmType="I")&&(PreOrAdd="ADD")) d
    .s AddOrdItem=$p(^DHCPEPreIADM(AdmId),"^",10)
    .s AddLimit=$p(^DHCPEPreIADM(AdmId),"^",11)
    .i (AddOrdItem="N") s GAdd=0
    .i ((AddOrdItem="Y")&&(AddLimit="N")) d
    ..s GAdd=1
    ///自结
    i (DisChargedMode="ID") s GAdd=0      
    ////////
    i (((GAdd=1)||(PreOrAdd="PRE"))&&(AdmType="I")) d 
    .s PGAdm=$p(^DHCPEPreIADM(AdmId),"^",2)
    .s PGTeam=$p(^DHCPEPreIADM(AdmId),"^",3)
    e  d
    .s PGAdm="" 
    .s PGTeam=""
    i AdmType="G" d
    .s PGAdm=+AdmId
    .s PGTeam=AdmId
    ///自结
    i (DisChargedMode="ID") d
    .s PGTeam=""      
    .s PGAdm=""
    /////////
    s CRMADMType=$s(PGAdm'="":"G",PGAdm="":"I")
    s PACRMADM=$s(CRMADMType="G":PGTeam,CRMADMType="I":AdmId)
    //i (AdmType="G") s AdmStatus=$p(^DHCPEPreGADM(PGAdm),"^",6)
    //e  s AdmStatus=$p(^DHCPEPreIADM(AdmId),"^",8)
    
    i (AdmType="G") d
    .s AdmStatus=$p(^DHCPEPreGADM(PGAdm),"^",6)
    .S LocID=$P($G(^DHCPEPreGADM(PGAdm)),"^",23)
    .S hospId=$P($G(^CTLOC(LocID)),"^",22)
    e  d
    .s AdmStatus=$p(^DHCPEPreIADM(AdmId),"^",8)
    .S LocID=$P($G(^DHCPEPreIADM(AdmId)),"^",26)
    .S hospId=$P($G(^CTLOC(LocID)),"^",22)
    
    
    s PARet=..GetPARowId(CRMADMType,PACRMADM,PreOrAdd)
    Q:PARet="" ""
    s PAprivilegeMode=$p(PARet,"^",2)
    s Rebate=$p(PARet,"^",4)
    i PAprivilegeMode="" s PAprivilegeMode="NP"
    
    i (OEOrdItem'="") d
    .s itemPrice=$p(OEOrdItem,"&",2)
    .s arcItemId=$p(OEOrdItem,"&",1)
    .//S itemPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcItemId,+$H,"","","",itemPrice) 
    .//S itemPrice=..GetOrderPrice(arcItemId,CRMADM,"",ADMFeeType)
    .S itemPrice=..GetOrderPrice(arcItemId,CRMADM,"0",ADMFeeType) 
    .s AccountAmount=+itemPrice

    i (OEOrdEnt'="") d
    .s AccountAmount=##class(web.DHCPE.Handle.ARCOrdSets).GetPrice(OEOrdEnt,"",CRMADM,ADMFeeType,"B",LocID,hospId)
        
    s FactAmount=0
    i ((PAprivilegeMode="NP")||(PAprivilegeMode="OP")||(PAprivilegeMode="TP")) s FactAmount=AccountAmount
    i PAprivilegeMode="OR" s FactAmount=AccountAmount*(Rebate/100)
    
    s PARet=PARet_"^"_FactAmount
    
    i AdmType="I" s ICRMADM=AdmId
    
    //公费加自费
    s MixPARet=""
    i ((CRMADMType="G")&&(PreOrAdd="ADD")&&(AddOrdItem="Y")&&(AddLimit="Y")) d
    .s OLRet=..OverLimit(AdmId,FactAmount)  //得到允许公费的金额
    .b  //222
    .i (OLRet<=0) d    //G
    ..s PARet=PARet
    .e  d
    ..i ((OLRet>0)&&(OLRet<FactAmount)) d    //Mix
    ...s MixPARet=..GetPARowId("I",ICRMADM,PreOrAdd)
    ...s $p(PARet,"^",5)=(FactAmount-OLRet)
    ...s PARet=PARet_$C(1)_MixPARet_"^"_OLRet
    ..e  d      //I
    ...s MixPARet=..GetPARowId("I",ICRMADM,PreOrAdd)
    ...s FactAmount=0
    ...s PAprivilegeMode=$p(MixPARet,"^",2)
    ...s Rebate=$p(MixPARet,"^",4)
    ...i PAprivilegeMode="" s PAprivilegeMode="NP"
    ...i ((PAprivilegeMode="NP")||(PAprivilegeMode="OP")||(PAprivilegeMode="TP")) s FactAmount=AccountAmount
    ...i PAprivilegeMode="OR" s FactAmount=AccountAmount*(Rebate/100)
    ...s PARet=MixPARet_"^"_FactAmount
    
    Q:PARet="" ""
    s RetVal=PARet
    Q RetVal
}

/// Create by MLH 2007-04-18
ClassMethod GetPARowId(CRMADMType As %Library.String = "", PACRMADM As %Library.String = "", PreOrAdd As %Library.String = "", SeleAuditRowid As %String = "")
{
    //取可操作的审核表
    s PARowId=0,GetPA=0,Notice=0,PAprivilegeMode="NP",Privilege="",Rebate=0,PGTeam=""
    i CRMADMType="G" d
    .s PGTeam=PACRMADM
    .s PACRMADM=+PACRMADM
    s PIOIPAuditDR=""
    f  s PARowId=$o(^DHCPEPreA(0,"CRMADM",CRMADMType,PACRMADM,PARowId)) q:(PARowId="")||(GetPA=1)  d
    .s PAStr=^DHCPEPreA(PARowId)
    .s PAAuditedStatus=$p(PAStr,"^",10)
    .s PAType=$p(PAStr,"^",20)
    .s Team=$p(PAStr,"^",22)
    .q:(PGTeam'=Team)
    .//s ^lisatest("0404","PAType",PARowId)=PAType_"^"_PreOrAdd
    .s PAprivilegeMode=$p(PAStr,"^",19)
    .s Privilege=$p(PAStr,"^",5)
    .s ChargedStatus=$p(PAStr,"^",14)
    .//如果是总价审核，未审核，可用
    .//s ^lisatest("0404","PAprivilegeMode","PAType","PAAuditedStatus","AdmStatus","Notice",1,PARowId)=PAprivilegeMode_"^"_PAType_"^"_PAAuditedStatus_"^"_AdmStatus_"^"_Notice
    .i ((PAprivilegeMode="TP")&&(PreOrAdd=PAType)&&(PAAuditedStatus'="Audited")&&(ChargedStatus'="CHARGED")) d 
    ..s GetPA=1
    ..s PIOIPAuditDR=PARowId
    .//如果是总价审核，在预约状态，已审核，提示（要取消审核）
    .i ((PAprivilegeMode="TP")&&(PreOrAdd=PAType)&&(PAAuditedStatus="Audited")&&(AdmStatus="PREREG")&&(ChargedStatus'="CHARGED")) d
    ..s Notice=1    
    ..//s ^lisatest("0404","PAprivilegeMode","PAType","PAAuditedStatus","AdmStatus","Notice",2,PARowId)=PAprivilegeMode_"^"_PAType_"^"_PAAuditedStatus_"^"_AdmStatus_"^"_Notice
    .//如果不是总价审核，不管是否审核和到达，可用
    .i ((PAprivilegeMode'="TP")&&(PreOrAdd=PAType)&&(ChargedStatus'="CHARGED")) d
    ..s GetPA=1
    ..s PIOIPAuditDR=PARowId
    ..i PAprivilegeMode="OR" s Rebate=$p(^DHCPEPreA(PARowId),"^",5)
    .q:GetPA=1

    Q:("1"=Notice) "Notice"
    i GetPA=0 d  //没有得到审核表，生一个
    .s PAprivilegeMode="NP"
    .i CRMADMType="G" s PAGIADM=$o(^DHCPEGADM(0,"CRMGADM",PACRMADM,0))
    .i CRMADMType="I" s PAGIADM=$o(^DHCPEIADM(0,"CRMADM",PACRMADM,0))
    .&sql(insert into sqluser.DHC_PE_PreAudit(PA_ADMType,PA_CRMADM,PA_GIADM,
                PA_AuditedStatus,PA_ChargedStatus,PA_PrivilegeMode,PA_Type,PA_Status,PA_CRMTeam
            )values(
                :CRMADMType,:PACRMADM,:PAGIADM,'NoAudited','UNCHARGED','NP',
                :PreOrAdd,'U',:PGTeam
            ))
    .Q:('(("0"=SQLCODE)||("-119"=SQLCODE)))
    .s PIOIPAuditDR=%ROWID

    Q:PIOIPAuditDR="" ""
    s RetVal=PIOIPAuditDR_"^"_PAprivilegeMode_"^"_Privilege_"^"_Rebate
    Q RetVal
}

/// backup by MLH 2007-04-18
ClassMethod GetPARowId1(AdmId As %Library.String = "", PreOrAdd As %Library.String = "", AdmType As %Library.String = "", AddAmount As %Library.String = "0")
{
    S ^lisatest("0410","GetPARowId")=AdmId_"^"_PreOrAdd_"^"_AdmType_"^"_AddAmount
    Q:((AdmId="")||(PreOrAdd="")||(AdmType="")) ""
    
    s PGAdm="",AddOrdItem=""
    s CanAdd=1    
    i ((AdmType="I")&&(PreOrAdd="ADD")) d
    .s AddOrdItem=$p(^DHCPEPreIADM(AdmId),"^",10)
    .s AddLimit=$p(^DHCPEPreIADM(AdmId),"^",11)
    .i (AddOrdItem="N") s CanAdd=0
    .i ((AddOrdItem="Y")&&(AddLimit="Y")) d
    ..s OLRet=..OverLimit(AdmId,AddAmount)
    ..s CanAdd=1
    ..//s CanAdd=$s(OLRet=1:0,OLRet=0:1)
    .i ((AddOrdItem="Y")&&(AddLimit="N")) d
    ..s CanAdd=1
    
    i (((CanAdd=1)||(PreOrAdd="PRE"))&&(AdmType="I")) d 
    .s PGAdm=$p(^DHCPEPreIADM(AdmId),"^",2)
    e  s PGAdm="" 
    i AdmType="G" s PGAdm=AdmId
    
    s CRMADMType=$s(PGAdm'="":"G",PGAdm="":"I")
    s PACRMADM=$s(CRMADMType="G":PGAdm,CRMADMType="I":AdmId)
    i (AdmType="G") s AdmStatus=$p(^DHCPEPreGADM(AdmId),"^",6)
    e  s AdmStatus=$p(^DHCPEPreIADM(AdmId),"^",8)
    b //0
    //取可操作的审核表
    s PARowId=0,GetPA=0,Notice=0,PAprivilegeMode="NP",Privilege="",Rebate=0
    s PIOIPAuditDR=""
    f  s PARowId=$o(^DHCPEPreA(0,"CRMADM",CRMADMType,PACRMADM,PARowId)) q:(PARowId="")||(GetPA=1)  d
    .s PAStr=^DHCPEPreA(PARowId)
    .s PAAuditedStatus=$p(PAStr,"^",10)
    .s PAType=$p(PAStr,"^",20)
    .//s ^lisatest("0404","PAType",PARowId)=PAType_"^"_PreOrAdd
    .s PAprivilegeMode=$p(PAStr,"^",19)
    .s Privilege=$p(PAStr,"^",5)
    .s ChargedStatus=$p(PAStr,"^",14)
    .//如果是总价审核，未审核，可用
    .s ^lisatest("0404","PAprivilegeMode","PAType","PAAuditedStatus","AdmStatus","Notice",1,PARowId)=PAprivilegeMode_"^"_PAType_"^"_PAAuditedStatus_"^"_AdmStatus_"^"_Notice
    .i ((PAprivilegeMode="TP")&&(PreOrAdd=PAType)&&(PAAuditedStatus'="Audited")&&(ChargedStatus'="CHARGED")) d 
    ..b  //33333
    ..s GetPA=1
    ..s PIOIPAuditDR=PARowId
    .//如果是总价审核，在预约状态，已审核，提示（要取消审核）
    .i ((PAprivilegeMode="TP")&&(PreOrAdd=PAType)&&(PAAuditedStatus="Audited")&&(AdmStatus="PREREG")&&(ChargedStatus'="CHARGED")) d
    ..s Notice=1    
    ..//s ^lisatest("0404","PAprivilegeMode","PAType","PAAuditedStatus","AdmStatus","Notice",2,PARowId)=PAprivilegeMode_"^"_PAType_"^"_PAAuditedStatus_"^"_AdmStatus_"^"_Notice
    .//如果不是总价审核，不管是否审核和到达，可用
    .i ((PAprivilegeMode'="TP")&&(PreOrAdd=PAType)&&(ChargedStatus'="CHARGED")) d
    ..s GetPA=1
    ..s PIOIPAuditDR=PARowId
    ..i PAprivilegeMode="OR" s Rebate=$p(^DHCPEPreA(PARowId),"^",5)
    .q:GetPA=1
    .//b //resksiaf

    b //0000
    Q:("1"=Notice) "Notice"
    b //1
    i GetPA=0 d  //没有得到审核表，生一个
    .s PAprivilegeMode="NP"
    .&sql(insert into sqluser.DHC_PE_PreAudit(PA_ADMType,PA_CRMADM,
                PA_AuditedStatus,PA_ChargedStatus,PA_PrivilegeMode,PA_Type,PA_Status
            )values(
                :CRMADMType,:PACRMADM,'UnAudited','UNCHARGED','NP',:PreOrAdd,'U'
            ))
    .//B //2
    .Q:('(("0"=SQLCODE)||("-119"=SQLCODE)))
    .s PIOIPAuditDR=%ROWID
    
    Q:PIOIPAuditDR="" ""
    
    s RetVal=PIOIPAuditDR_"^"_PAprivilegeMode_"^"_Privilege_"^"_Rebate_"^"_AddOrdItem
    
    Q RetVal
}

/// <0 允许公费加项  >0&&<AddAmount 允许部分自费的金额
ClassMethod OverLimit(AdmId As %Library.String = "", AddAmount As %Library.String = "")
{
    s IInfo=$G(^DHCPEPreIADM(AdmId))
    s GID=$p(IInfo,"^",2)
    i GID="" q 0
    s LimitAddOrdItem=$p(IInfo,"^",10)
    i LimitAddOrdItem="N" q 1
    s LimitAddOrdAmount=$p(IInfo,"^",11)
    i LimitAddOrdItem="N" q 0
    s LimitAmount=$p(IInfo,"^",12)
    s OldAmount=0
    s OISub=0
    s OrdEntDRs=""
    f  s OISub=$o(^DHCPEPreIADM(AdmId,"ORDITEM",OISub)) q:OISub=""  d
    .s ItemID=AdmId_"||"_OISub
    .s OrdEntDR=$p(^DHCPEPreIADM(AdmId,"ORDITEM",OISub),"^",2)
    .s Stat=$p(^DHCPEPreIADM(AdmId,"ORDITEM",OISub),"^",16)
    .q:Stat'="1"
    .//s AddOrdItem=$p(^DHCPEPreIADM(AdmId,"ORDITEM",OISub),"^",5)
    .//s AddType=$p(^DHCPEPreIADM(AdmId,"ORDITEM",OISub),"^",15)
    .//w AddOrdItem_"^"_AddType
    .//q:(AddOrdItem="N")
    .//q:AddType'="ADD"
    .i OrdEntDR="" d
    ..s OneOldAmount=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(ItemID,"G","ADD")
    ..//s OneOldAmount=$p(^DHCPEPreIADM(AdmId,"ORDITEM",OISub),"^",14)
    ..//i OneOldAmount="" s OneOldAmount=0
    ..s OldAmount=OldAmount+OneOldAmount
    .e  d
    ..q:##class(web.DHCPE.PreAudit).StringIsInStrs(OrdEntDRs,OrdEntDR)
    ..s OrdEntDRs=OrdEntDRs_"^"_OrdEntDR
    ..s OneOldAmount=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByOrd(OrdEntDR,"G","ADD")
    ..//$p(..GetOrdEntPrice(OrdEntDR),"^",1)
    ..s OldAmount=OldAmount+OneOldAmount
    s ReturnTotal=OldAmount+AddAmount-LimitAmount
    q ReturnTotal
    
    i OldAmount+AddAmount>LimitAmount
    {
        s ReturnTotal=OldAmount+AddAmount-LimitAmount
        q ReturnTotal
    }
    q 0
}

/// 应收^打折
ClassMethod GetOrdEntPrice(OrdEntID)
{
    s OEAdm=$p(OrdEntID,"||",1)
    s OESub=$p(OrdEntID,"||",2)
    s OEOnePrice=$p(^DHCPEPreIADM(OEAdm,"ORDENT",OESub),"^",7)
    s ^lisatest("0420","OrdEntID")=OrdEntID
    s OEFactOnePrice=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByOrd(OrdEntID,"","")
    //s OEFactOnePrice=$p(^DHCPEPreIADM(OEAdm,"ORDENT",OESub),"^",6)
    i OEOnePrice="" s OEOnePrice=0
    //i OEFactOnePrice="" s OEFactOnePrice=0
    q OEOnePrice_"^"_OEFactOnePrice
}

// w ##class( web.DHCPE.PreItemList).StopPIOI("543||16")

ClassMethod StopPIOI(PIOIRowId As %Library.String = "")
{
   //q ""
    Quit:PIOIRowId="" -1
    Set ret=0
    Set CRMORowId=$o(^DHCPECRMO(0,"CRMORI",PIOIRowId,0))
    s OrdEntDR=$p(^DHCPEPreIADM(+PIOIRowId,"ORDITEM",$p(PIOIRowId,"||",2)),"^",2)
    i OrdEntDR="" d
    .s ItemRemark=PIOIRowId
    e  d
    .s ItemRemark=PIOIRowId_"("_OrdEntDR_")"
    If $g(CRMORowId)'="" Set OEORIRowId=$p($g(^DHCPECRMO(CRMORowId)),"^",1)
    If $g(OEORIRowId) Set OEORIStat=$p($g(^OEORD($p(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2),1)),"^",13)
    /// ad by sun 停止视同收费的药品自动生成退药申请
    s DrugAplly=0
    i CRMORowId'="" d
    .s Paystatus=$p($g(^DHCPECRMO(CRMORowId)),"^",4)
    .i Paystatus="OC" d
    ..s DrugAplly=##class(web.DHCPE.ItemFeeList).DrugPermControl("1^"_PIOIRowId,"0","")
    q:(DrugAplly=2) "-1"
    /// ad by sun 停止视同收费的药品自动生成退药申请 end
    
    //如果医嘱状态为核实，或还没传到OE_OrdItem表中，可被停止
    If ($g(OEORIStat)=1)||($g(OEORIStat)=6)||($g(OEORIStat)="") Do
    .&sql(update sqluser.DHC_PE_PreIOrdItem set PIOI_ItemStat='4' where PIOI_RowId=:PIOIRowId)
    .If '(("0"=SQLCODE)||("100"=SQLCODE)) Set ret=-1
    .Quit:ret'=0
    
    
    .s OrderSets=$G(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",+PIOIRowId))
    .s i=$l(OrderSets,"^")
    .f j=1:1:i d
    ..s PIOEOrderSetsDR=$p(OrderSets,"^",j)
    ..q:PIOEOrderSetsDR=""
    ..s ARCOSOrdSubCatDR=$p($G(^ARCOS(PIOEOrderSetsDR)),"^",9)
    ..q:ARCOSOrdSubCatDR=""
    ..s OrcatDesc=$p($G(^ARC("IC",ARCOSOrdSubCatDR)),"^",2)
    ..q:OrcatDesc'="体检医嘱套"
    ..i $d(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",+PIOIRowId,PIOEOrderSetsDR,PIOIRowId)) d
    ...s ^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",+PIOIRowId,PIOEOrderSetsDR,PIOIRowId)=4
    
    
    .s FeeSub=0
    .f  s FeeSub=$o(^DHCPEPreIADM(+PIOIRowId,"ORDITEM",$p(PIOIRowId,"||",2),"FEE",FeeSub)) q:(FeeSub="")  d
    ..s PreAudit=$p(^DHCPEPreIADM(+PIOIRowId,"ORDITEM",$p(PIOIRowId,"||",2),"FEE",FeeSub),"^",5)
    ..q:PreAudit=""
    ..s auditStatus=$p(^DHCPEPreA(PreAudit),"^",21)
    ..q:auditStatus="NU"
    ..s ChargedStatus=$p(^DHCPEPreA(PreAudit),"^",14)
    ..i ChargedStatus'="CHARGED" d
    ...s ^DHCPEPreIADM(+PIOIRowId,"ORDITEM",$p(PIOIRowId,"||",2),"FEE",FeeSub,"CancelPE")=PreAudit
    .&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_PAudit_DR=null where PIOIF_ParRef=:PIOIRowId and PIOIF_PAudit_DR->PA_Status='U')
    .If '(("0"=SQLCODE)||("100"=SQLCODE)) Set ret=-1
    .Quit:ret'=0
    .//记录停止DHC_PE_PreIOrdItem的时间
    .Set ret=..ItemDelDataEx(PIOIRowId,"","")   
    .d ##class(web.DHCPE.AdmRecordManager).Insert(+PIOIRowId,"P","DeleteItem","",ItemRemark)
    Quit ret
}

/// w ##class(web.DHCPE.PreItemList).StopPIOE()
ClassMethod StopPIOE(PIOERowId As %Library.String = "")
{
    Quit:PIOERowId="" -1
    Set ret=0
    //停止DHC_PE_PreIOrdEnt的医嘱
    &sql(update sqluser.DHC_PE_PreIOrdEnt set PIOE_ItemStat='4' where PIOE_RowId=:PIOERowId)
    Quit:'(("0"=SQLCODE)||("100"=SQLCODE)) -1
    s FeeSub=0
    f  s FeeSub=$o(^DHCPEPreIADM(+PIOERowId,"ORDENT",$P(PIOERowId,"||",2),"FEE",FeeSub)) q:(FeeSub="")  d
    .s PreAudit=$p(^DHCPEPreIADM(+PIOERowId,"ORDENT",$P(PIOERowId,"||",2),"FEE",FeeSub),"^",5)
    .q:PreAudit=""
    .s auditStatus=$p(^DHCPEPreA(PreAudit),"^",21)
    .q:auditStatus="NU"
    .s ChargedStatus=$p(^DHCPEPreA(PreAudit),"^",14)
    .i ChargedStatus'="CHARGED" d
    ..s ^DHCPEPreIADM(+PIOERowId,"ORDENT",$P(PIOERowId,"||",2),"FEE",FeeSub,"CancelPE")=PreAudit
    &SQL(update sqluser.DHC_PE_PreIOrdEntFee set PIOEF_PAudit_DR=null where PIOEF_ParRef=:PIOERowId and PIOEF_PAudit_DR->PA_Status='U')
    Quit:'(("0"=SQLCODE)||("100"=SQLCODE)) -1
    //记录停止DHC_PE_PreIOrdItem的时间
    Set ret=..ItemDelDataEx("",PIOERowId,"")
    Quit:ret'=0 -1
    
    //停止套餐包含的DHC_PE_PreIOrdItem的医嘱
    Set AdmId=+PIOERowId
    Set PIOIChd=0
    For  Set PIOIChd=$o(^DHCPEPreIADM(0,"OrdEnt",PIOERowId,AdmId,PIOIChd))  Quit:PIOIChd=""  Do
    .Set ret=..StopPIOI(AdmId_"||"_PIOIChd)
    .Quit:ret'=0
    
    Quit ret
}

ClassMethod StopOEORI(OrdItemId As %Library.String = "", OrdEntId As %Library.String = "", XDate As %Library.String = "", XTime As %Library.String = "")
{
    q:((OrdItemId="")&&(OrdEntId="")) -1
    s RetVal=0
    If $g(XDate)="" s XDate=+$h
    If $g(XTime)="" s XTime=$p($h,",",2)
    If OrdEntId'="" Do
    .s OrdChild=""
    .f  s OrdChild=$o(^DHCPEPreIADM(0,"OrdEnt",OrdEntId,+OrdEntId,OrdChild)) q:OrdChild=""  d
    ..s OrdItemId=+OrdEntId_"||"_OrdChild
    ..s CRMOrderDR=$o(^DHCPECRMO(0,"CRMORI",OrdItemId,0))
    ..if $g(CRMOrderDR)'="" Do
    ...s OEORIDR=$p($g(^DHCPECRMO(CRMOrderDR)),"^",1)
    ...if $g(OEORIDR)'="" d
    ....d ##class(web.DHCPE.CRM.RisGateway).SendInfo("D",OEORIDR)    //add 20100307
    ....d ##Class(RISService.InvokeRISService).DiscontinueAppInfoPACS(OEORIDR,"","D") //停医嘱时,撤销pacs的申请
    ....&sql(update sqluser.oe_orditem set Oeori_itemstat_dr='4',Oeori_XDate=:XDate,Oeori_XTime=:XTime where oeori_RowId=:OEORIDR and Oeori_itemstat_dr<>'6')
    ....i '(("0"=SQLCODE)||("100"=SQLCODE)) s RetVal=-1
    ....//&SQL(delete from sqluser.dhc_oedispensing where DSP_OEORI_DR=:OEORIDR)
    ....d ##class(web.DHCOEDispensing).Return(OEORIDR)              //add
    ....i SQLCODE=100 s SQLCODE=0
    ....i SQLCODE'=0 s RetVal=-1
    ....q:SQLCODE'=0
    ....d ##class(web.DHCPE.PreItemListEx).UpdateSpecInfo(OEORIDR)
    ....d ##class(web.DHCPE.ItemDetailRecord).Insert(OEORIDR,"D","")
    e  d
    .//b //1
    .s CRMOrderDR=$o(^DHCPECRMO(0,"CRMORI",OrdItemId,0))
    .If $g(CRMOrderDR)'="" Do 
    ..s OEORIDR=$p($g(^DHCPECRMO(CRMOrderDR)),"^",1)
    ..if $g(OEORIDR)'="" d
    ...d ##class(web.DHCPE.CRM.RisGateway).SendInfo("D",OEORIDR)    //add 20100307
    ...d ##Class(RISService.InvokeRISService).DiscontinueAppInfoPACS(OEORIDR,"","D") //停医嘱时,撤销pacs的申请
    ...&sql(update sqluser.oe_orditem set Oeori_itemstat_dr='4',Oeori_XDate=:XDate,Oeori_XTime=:XTime where oeori_RowId=:OEORIDR and Oeori_itemstat_dr<>'6')
    ...i '(("0"=SQLCODE)||("100"=SQLCODE)) s RetVal=-1
    ...//&SQL(delete from sqluser.dhc_oedispensing where DSP_OEORI_DR=:OEORIDR)
    ...d ##class(web.DHCOEDispensing).Return(OEORIDR)               //add
    ...i SQLCODE=100 s SQLCODE=0
    ...i SQLCODE'=0 s RetVal=-1
    ...q:SQLCODE'=0
    ...d ##class(web.DHCPE.PreItemListEx).UpdateSpecInfo(OEORIDR)
    ...d ##class(web.DHCPE.ItemDetailRecord).Insert(OEORIDR,"D","")
    q RetVal
}

/*
ClassMethod MayDeleteItem(Type As %String = "", OrdItemId As %String = "", OrdEntId As %String = "")
{
    Quit:(OrdItemId="")&(OrdEntId="")
    
    If OrdItemId'="" Do
    .Set ItemType="OrdItem"
    .Set ItemID=OrdItemId
    Else  Do
    .Set ItemType="OrdEnt"
    .Set ItemID=OrdEntId
    s Flag=0
    if Type="TEAM"
    {
        i ItemType="OrdEnt" d
        .s iAdm=0
        .f  s iAdm=$o(^DHCPEPreIADM(0,"GTOE",ItemID,iAdm)) q:(iAdm="")||(Flag'=0)  d
        ..s iSub=0
        ..f  s iSub=$o(^DHCPEPreIADM(0,"GTOE",ItemID,iAdm,iSub)) q:(iSub="")||(Flag'=0)  d
        ...d PersonMayDelete(iAdm,iAdm_"||"_iSub)
        i ItemType="OrdItem" d
        .s iAdm=0
        .f  s iAdm=$o(^DHCPEPreIADM(0,"GTOI",ItemID,iAdm)) q:(iAdm="")||(Flag'=0)  d
        ..s iSub=0
        ..f  s iSub=$o(^DHCPEPreIADM(0,"GTOI",ItemID,iAdm,iSub)) q:(iSub="")||(Flag'=0)  d
        
        ...d PersonMayDelete(iAdm,iAdm_"||"_iSub)
    }
    elseif Type="PERSON"
    {
        s iAdm=+ItemID
        d PersonMayDelete(iAdm,ItemID)
    }
    q Flag
PersonMayDelete(Adm,iID)

    i ItemType="OrdItem" d
    .s OrdEnt=$p(^DHCPEPreIADM(Adm,"ORDITEM",$p(iID,"||",2)),"^",2)
    .s ItemStat=$p(^DHCPEPreIADM(Adm,"ORDITEM",$p(iID,"||",2)),"^",16)
    .//s:ItemStat="4" Flag=5
    .q:Flag'=0
    .i OrdEnt'="" d
    ..s Sub=0
    ..f  s Sub=$o(^DHCPEPreIADM(Adm,"ORDENT",$p(OrdEnt,"||",2),"FEE",Sub)) q:(Sub="")||(Flag=1)||(Flag=3)  d
    ...s AId=$p(^DHCPEPreIADM(Adm,"ORDENT",$p(OrdEnt,"||",2),"FEE",Sub),"^",5)
    ...q:AId=""
    ...s PAStatus=$p(^DHCPEPreA(AId),"^",21)
    ...q:PAStatus="NU"
    ...s FeeStatus=$p(^DHCPEPreA(AId),"^",14)
    ...s:FeeStatus="CHARGED" Flag=1
    .e  d
    ..s Sub=0
    ..f  s Sub=$o(^DHCPEPreIADM(Adm,"ORDITEM",$p(iID,"||",2),"FEE",Sub)) q:(Sub="")||(Flag=1)||(Flag=3)  d
    ...s AId=$p(^DHCPEPreIADM(Adm,"ORDITEM",$p(iID,"||",2),"FEE",Sub),"^",5)
    ...q:AId=""
    ...s PAStatus=$p(^DHCPEPreA(AId),"^",21)
    ...q:PAStatus="NU"
    ...s FeeStatus=$p(^DHCPEPreA(AId),"^",14)
    ...s:FeeStatus="CHARGED" Flag=1
    .q:Flag'=0
    .s AdmStatus=$p(^DHCPEPreIADM(Adm),"^",8)
    .i (AdmStatus="ARRIVED")||(AdmStatus="REGISTERED") d
    ..s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",iID,0))
    ..i CRMORowId'="" d
    ...s OEORI=$P(^DHCPECRMO(CRMORowId),"^",1)
    ...s OEORIStat=$p(^OEORD($p(OEORI,"||",1),"I",$P(OEORI,"||",2),1),"^",13)
    ...i OEORIStat="6" s Flag=3
    ...i OEORIStat="4" s Flag=5
    ...q:Flag'=0
    ...s Flag=..MedicalIsCanDelete(OEORI)
    .
    i ItemType="OrdEnt" d
    .s ItemStat=$p($g(^DHCPEPreIADM(Adm,"ORDENT",$p(iID,"||",2))),"^",9)
    .//s:ItemStat="4" Flag=5
    .q:Flag'=0
    .s Sub=0
    .f  s Sub=$o(^DHCPEPreIADM(Adm,"ORDENT",$p(iID,"||",2),"FEE",Sub)) q:(Sub="")||(Flag'=0)  d
    ..s AId=$p(^DHCPEPreIADM(Adm,"ORDENT",$p(iID,"||",2),"FEE",Sub),"^",5)
    ..q:AId=""
    ..s PAStatus=$p(^DHCPEPreA(AId),"^",21)
    ..q:PAStatus="NU"
    ..s FeeStatus=$p(^DHCPEPreA(AId),"^",14)
    ..s:FeeStatus="CHARGED" Flag=1
    .q:Flag'=0
    .s PIOICldSub=0
    .f  s PIOICldSub=$o(^DHCPEPreIADM(0,"OrdEnt",iID,Adm,PIOICldSub)) q:(PIOICldSub=""||Flag'=0)  d
    ..s AdmStatus=$p(^DHCPEPreIADM(Adm),"^",8)
    ..i (AdmStatus="ARRIVED")||(AdmStatus="REGISTERED") d
    ...s PIOIRowId=Adm_"||"_PIOICldSub
    ...s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",PIOIRowId,0))
    ...i CRMORowId'="" d
    ....s OEORI=$P(^DHCPECRMO(CRMORowId),"^",1)
    ....s OEORIStat=$p(^OEORD($p(OEORI,"||",1),"I",$P(OEORI,"||",2),1),"^",13)
    ....i OEORIStat="6" s Flag=4    q
    ....i OEORIStat="4" s Flag=5    q
    ....s Flag=..MedicalIsCanDelete(OEORI)
}
*/
/// Type  "PERSON":个人   "TEAM":分组
/// ItemType   "ITEM":项目  "Ord":套餐
/// w ##class(web.DHCPE.PreItemList).MayDeleteItem("PERSON","451||9","")
ClassMethod MayDeleteItem(Type As %String = "", OrdItemId As %String = "", OrdEntId As %String = "")
{
    Quit:(OrdItemId="")&(OrdEntId="")
    
    If OrdItemId'="" Do
    .Set ItemType="OrdItem"
    .Set ItemID=OrdItemId
    Else  Do
    .Set ItemType="OrdEnt"
    .Set ItemID=OrdEntId
    s Flag=0
    if Type="TEAM"
    {
        i ItemType="OrdEnt" d
        .s iAdm=0
        .f  s iAdm=$o(^DHCPEPreIADM(0,"GTOE",ItemID,iAdm)) q:(iAdm="")||(Flag'=0)  d
        ..s iSub=0
        ..f  s iSub=$o(^DHCPEPreIADM(0,"GTOE",ItemID,iAdm,iSub)) q:(iSub="")||(Flag'=0)  d
        ...d PersonMayDelete(iAdm,iAdm_"||"_iSub)
        i ItemType="OrdItem" d
        .s iAdm=0
        .f  s iAdm=$o(^DHCPEPreIADM(0,"GTOI",ItemID,iAdm)) q:(iAdm="")||(Flag'=0)  d
        ..s iSub=0
        ..f  s iSub=$o(^DHCPEPreIADM(0,"GTOI",ItemID,iAdm,iSub)) q:(iSub="")||(Flag'=0)  d
        
        ...d PersonMayDelete(iAdm,iAdm_"||"_iSub)
    }
    elseif Type="PERSON"
    {
        s iAdm=+ItemID
        d PersonMayDelete(iAdm,ItemID)
    }
    q Flag
PersonMayDelete(Adm,iID)
    //s Flag=##class(web.DHCPE.ResultEdit).GeneralAdviceAudited(Adm,"CRM")
    //If Flag=1 Set Flag=2
    //Quit:Flag'=0 Flag
    i ItemType="OrdItem" d
    .s OrdEnt=$p($g(^DHCPEPreIADM(Adm,"ORDITEM",$p(iID,"||",2))),"^",2)
    .s ItemStat=$p($g(^DHCPEPreIADM(Adm,"ORDITEM",$p(iID,"||",2))),"^",16)
    .//s:ItemStat'="1" Flag=5   //wq
    .;s:ItemStat="4" Flag=5
    .q:Flag'=0
    .i OrdEnt'="" d
    ..s Sub=0
    ..f  s Sub=$o(^DHCPEPreIADM(Adm,"ORDENT",$p(OrdEnt,"||",2),"FEE",Sub)) q:(Sub="")||(Flag=1)||(Flag=3)  d
    ...s AId=$p($g(^DHCPEPreIADM(Adm,"ORDENT",$p(OrdEnt,"||",2),"FEE",Sub)),"^",5)
    ...q:AId=""
    ...s PAStatus=$p($g(^DHCPEPreA(AId)),"^",21)
    ...q:PAStatus="NU"
    ...s FeeStatus=$p($g(^DHCPEPreA(AId)),"^",14)
    ...s:FeeStatus="CHARGED" Flag=1
    .e  d
    ..s Sub=0
    ..f  s Sub=$o(^DHCPEPreIADM(Adm,"ORDITEM",$p(iID,"||",2),"FEE",Sub)) q:(Sub="")||(Flag=1)||(Flag=3)  d
    ...s AId=$p($g(^DHCPEPreIADM(Adm,"ORDITEM",$p(iID,"||",2),"FEE",Sub)),"^",5)
    ...q:AId=""
    ...s PAStatus=$p($g(^DHCPEPreA(AId)),"^",21)
    ...q:PAStatus="NU"
    ...s FeeStatus=$p($g(^DHCPEPreA(AId)),"^",14)
    ...s:FeeStatus="CHARGED" Flag=1
    .q:Flag'=0
    .s AdmStatus=$p($g(^DHCPEPreIADM(Adm)),"^",8)
    .i (AdmStatus="ARRIVED")||(AdmStatus="REGISTERED") d
    ..s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",iID,0))
    ..i CRMORowId'="" d
    ...s OEORI=$P($g(^DHCPECRMO(CRMORowId)),"^",1)
    ...q:OEORI=""
    ...q:'$d(^OEORD($p(OEORI,"||",1),"I",$P(OEORI,"||",2),1))
    ...s OEORIStat=$p($g(^OEORD($p(OEORI,"||",1),"I",$P(OEORI,"||",2),1)),"^",13)
    ...i OEORIStat="6" s Flag=3
    ...;i OEORIStat="4" s Flag=5
    ...q:Flag'=0
    ...s Flag=..MedicalIsCanDelete(OEORI)
    .
    i ItemType="OrdEnt" d
    .s ItemStat=$p($g(^DHCPEPreIADM(Adm,"ORDENT",$p(iID,"||",2))),"^",9)
    .//s:ItemStat'="1" Flag=5  //wq
    .;s:ItemStat="4" Flag=5
    .q:Flag'=0
    .s Sub=0
    .f  s Sub=$o(^DHCPEPreIADM(Adm,"ORDENT",$p(iID,"||",2),"FEE",Sub)) q:(Sub="")||(Flag'=0)  d
    ..s AId=$p($g(^DHCPEPreIADM(Adm,"ORDENT",$p(iID,"||",2),"FEE",Sub)),"^",5)
    ..q:AId=""
    ..s PAStatus=$p($g(^DHCPEPreA(AId)),"^",21)
    ..q:PAStatus="NU"
    ..s FeeStatus=$p($g(^DHCPEPreA(AId)),"^",14)
    ..s:FeeStatus="CHARGED" Flag=1
    .q:Flag'=0
    .s PIOICldSub=0
    .f  s PIOICldSub=$o(^DHCPEPreIADM(0,"OrdEnt",iID,Adm,PIOICldSub)) q:(PIOICldSub=""||Flag'=0)  d
    ..s AdmStatus=$p($g(^DHCPEPreIADM(Adm)),"^",8)
    ..i (AdmStatus="ARRIVED")||(AdmStatus="REGISTERED") d
    ...s PIOIRowId=Adm_"||"_PIOICldSub
    ...s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",PIOIRowId,0))
    ...i CRMORowId'="" d
    ....s OEORI=$P($g(^DHCPECRMO(CRMORowId)),"^",1)
    ....q:OEORI=""
    ....q:'$d(^OEORD($p(OEORI,"||",1),"I",$P(OEORI,"||",2),1))
    ....s OEORIStat=$p($g(^OEORD($p(OEORI,"||",1),"I",$P(OEORI,"||",2),1)),"^",13)
    ....i OEORIStat="6" s Flag=4    q
    ....;i OEORIStat="4" s Flag=5   q
    ....s Flag=..MedicalIsCanDelete(OEORI)
}

/// w ##class(web.DHCPE.PreItemList).MedicalIsCanDelete()
ClassMethod MedicalIsCanDelete(OEORIRowId)
{
    //s OEDId=$o(^DHCOEDISQTY(0,"OEORI",OEORIRowId,0))
    s OEDId=$o(^DHCOEDISQTY(0,"OEORI",OEORIRowId,""),-1)
    q:OEDId="" 0
    
    s ARCIMDR=$P($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",2)
    s ARCICOrderType=""
    s ItemCatDR=$p($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1)),"^",10)  
	i ItemCatDR'=""  s ARCICOrderType=$p(^ARC("IC",ItemCatDR),"^",7)
	
	s OEDStatus=$p($g(^DHCOEDISQTY(OEDId)),"^",7)
    q:(OEDStatus="C")&&(ARCICOrderType="R") 6   //已发药
 
    q 0
}

ClassMethod Exit(AdmId)
{
   q:AdmId=""
    s PIADMStatus=$P($G(^DHCPEPreIADM(AdmId)),"^",8)
    i ("ARRIVED"=PIADMStatus)||("REGISTERED"=PIADMStatus) d
    .s IADMRowId=$O(^DHCPEIADM(0,"CRMADM",AdmId,""))
    .s:(""=IADMRowId) retVal="No find Register Record"
    .Q:(""=IADMRowId)
    .s PAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
    .//s taiObj=##class(web.DHCPE.PreTransAdmInfo).%New()
    .//s rtn=##class(web.DHCPE.PEApp).CreatePrescNo(PAADMDR)
    b //0422--5
    Quit
}

ClassMethod UpdateRecLoc(Loc, PreItem, Type)
{
    q:Loc="" 0
    TSTART
    i Type="TEAM"
    {
        s TItemStat=$p(^DHCPEPreGADM(+PreItem,"Team",$p(PreItem,"||",2),"ORDITEM",$p(PreItem,"||",3)),"^",13)
        i TItemStat'="1"
        {
            TROLLBACK
            q "分组项目状态不正确"
        }
        &SQL(update sqluser.DHC_PE_PreGTOrdItem set PGTOI_ItemRecLoc_DR=:Loc where PGTOI_RowId=:PreItem)
        i SQLCODE'=0
        {
            TROLLBACK
            q "更新分组项目接收科室错误"
        }
        s IADM=0
        f  s IADM=$o(^DHCPEPreIADM(0,"GTOI",PreItem,IADM)) q:(IADM="")||(SQLCODE'=0)  d
        .s Sub=0
        .f  s Sub=$o(^DHCPEPreIADM(0,"GTOI",PreItem,IADM,Sub)) q:(Sub="")||(SQLCODE'=0)  d
        ..s IPreItem=IADM_"||"_Sub
        ..s ReturnStr=..UpdatePersonRecLoc(IPreItem,Loc)
        ..s SQLCODE=+ReturnStr
        ..s Return=$p(ReturnStr,"^",2)
        ..i SQLCODE=2 s SQLCODE=0
        
    }
    else
    {
        s ReturnStr=..UpdatePersonRecLoc(PreItem,Loc)
        s SQLCODE=+ReturnStr
        s Return=$p(ReturnStr,"^",2)
    }
    i SQLCODE'=0 
    {
        TROLLBACK
        q Return
    }
    TCOMMIT
    q SQLCODE
}

/// w ##class(web.DHCPE.Query.PreItemList).UpdatePersonRecLoc("410||4","210")
ClassMethod UpdatePersonRecLoc(PreItemID, LocID)
{
    s PreItemStat=$p(^DHCPEPreIADM(+PreItemID,"ORDITEM",$p(PreItemID,"||",2)),"^",16)
    i PreItemStat'="1"
    {
        q "2^项目状态不是有效状态"
    }
    s CRMID=$o(^DHCPECRMO(0,"CRMORI",PreItemID,0))
    i CRMID'=""
    {
        s OEORDID=$p(^DHCPECRMO(CRMID),"^",1)
        s OEORIStat=$p(^OEORD($p(OEORDID,"||",1),"I",$P(OEORDID,"||",2),1),"^",13)
        s ItemMastDR=$p(^OEORD($p(OEORDID,"||",1),"I",$P(OEORDID,"||",2),1),"^",2)
        Q:ItemMastDR=""

        i OEORIStat'=1
        {
            q "2^医嘱状态不是核实状态"
        }
        &SQL(update sqluser.OE_ORDItem set OEORI_RecDep_DR=:LocID where OEORI_RowID=:OEORDID)
        q:SQLCODE "1^更新医嘱科室错误"
        s arcitmid=$p(^DHCPEPreIADM(+PreItemID,"ORDITEM",$p(PreItemID,"||",2)),"^",1)
        s ItemCatDR=$p(^ARCIM(+arcitmid,$p(arcitmid,"||",2),1),"^",10)
        s ARCICOrderType=""  
		i ItemCatDR'=""  s ARCICOrderType=$p(^ARC("IC",ItemCatDR),"^",7)
		if (ARCICOrderType="R"){
        &SQL(update sqluser.dhc_OEDispensing set DSP_RecDep_DR=:LocID where DSP_OEORI_DR=:OEORDID)
        q:SQLCODE "1^更新打包表科室错误"
		}
    }
    &SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_ItemRecLoc_DR=:LocID where PIOI_RowId=:PreItemID)
    q:SQLCODE "1^更新项目科室错误"
    q SQLCODE
}

/// 1根据ARC_ItmMast得到接收科室(插入团体分组或者个人预约项目的时候使用)
/// 2根据分组的预约项目ID得到接收科室DHC_PE_PreGTOrdItem(根据分组预约项目插入个人预约项目的时候使用)
/// 3根据个人的预约项目ID得到接收科室DHC_PE_PreIOrdItem(个人到达的时候使用)
ClassMethod GetRecLoc(Type, ItemID, LocID = "")
{
    ;w ##class(web.DHCPE.PreItemList).GetRecLoc("1", ARCItmMastID)
    s RecLoc=""
    i Type=1 d
    .i LocID="" d
    ..s:$d(%session) DefaultLoc=%session.Get("LOGON.CTLOCID")
    ..s:$G(DefaultLoc)="" DefaultLoc=105
    .e  s DefaultLoc=LocID
    .i DefaultLoc'="" s DefaultADM=$G(^DHCPESetting("DHCPE","DefaultPAADM",DefaultLoc))
    .//s DefaultLoc=$G(^DHCPESetting("DHCPE","PhyExamLocId"))
    .i DefaultADM'="" s RecLoc=##class(web.DHCPE.TransAdmInfo).GetReceiveLoc(DefaultADM, ItemID,DefaultLoc)
    e  i Type=2 d
    .s TID=+ItemID
    .s TSub=$p(ItemID,"||",2)
    .s ItemSub=$p(ItemID,"||",3)
    .s RecLoc=$P(^DHCPEPreGADM(TID,"Team",TSub,"ORDITEM",ItemSub),"^",14)
    e  i Type=3 d
    .s IID=+ItemID
    .s ItemSub=$p(ItemID,"||",2)
    .s RecLoc=$P($g(^DHCPEPreIADM(IID,"ORDITEM",ItemSub)),"^",17)
    q RecLoc
}

/// 在预约项目界面显示名称
ClassMethod GetItemName(AdmId, AdmType)
{
    s AdmId=$p(AdmId,"^",1)  //add by zl 20100624
    s Name=""
    i AdmType="PERSON"
    {
        s IBID=$p(^DHCPEPreIADM(AdmId),"^",1)
        s Status=$p(^DHCPEPreIADM(AdmId),"^",8)
        s Status=##Class(web.DHCPE.PreCommon).TransStatus(Status)
        s ChargStatus=##Class(web.DHCPE.PreIADM).GetChargedStatus("I",AdmId)
        s Name=$p(^DHCPEPreIBI(IBID),"^",2)
        s Sex=$p(^DHCPEPreIBI(IBID),"^",3)
        s Name="个人:"_Name_"("_Status_")"_$P($g(^CT("SEX",Sex)),"^",2)_"("_ChargStatus_")"
    }
    else
    {
        s Name=$p(^DHCPEPreGADM(+AdmId,"Team",$p(AdmId,"||",2)),"^",1)
        s Name="分组:"_Name
    }
    s ConfirmStatus=..GetConfirmStatus(AdmId,AdmType)
    i ConfirmStatus'=0 s ConfirmStatus="请确认加项"
    i ConfirmStatus=0 s ConfirmStatus=""
    s ^DHCPEConfirmInfo("ConfirmStatus",AdmId,AdmType)=ConfirmStatus
    q Name_"  "_ConfirmStatus
}

ClassMethod GetConfirmInfoStatus(AdmID, AdmType)
{
 
    i '$d(^DHCPEConfirmInfo("ConfirmStatus",AdmID,AdmType)) q ""
    q $g(^DHCPEConfirmInfo("ConfirmStatus",AdmID,AdmType))
}

ClassMethod GetConfirmStatus(AdmID, AdmType)
{
    s Flag=0
    i AdmType="PERSON"
    {
        Set IAdmRowID=$o(^DHCPEIADM(0,"CRMADM",AdmID,0))
        Quit:$g(IAdmRowID)="" Flag
        s OISub=0
        f  s OISub=$o(^DHCPEPreIADM(AdmID,"ORDITEM",OISub)) q:(OISub="")||(Flag'=0)  d
        .s ItemID=AdmID_"||"_OISub
        .s PreItemStat=$p($G(^DHCPEPreIADM(AdmID,"ORDITEM",OISub)),"^",16)
        .q:PreItemStat'="1"
        .s CRMID=$o(^DHCPECRMO(0,"CRMORI",ItemID,0))
        .i CRMID="" d
        ..s Flag=1
        .e  d
        ..s OEID=$P(^DHCPECRMO(CRMID),"^",1)
        ..s:OEID="" Flag=1
    }
    else
    {
        Set PIADMRowID=0
        For  Set PIADMRowID=$o(^DHCPEPreIADM(0,"PGTeam",AdmID,PIADMRowID)) Quit:(PIADMRowID="")||(Flag'=0)  Do
        .s Flag=..GetConfirmStatus(PIADMRowID,"PERSON")
        
    }
    q Flag
}

/// ##class(web.DHCPE.PreItemList).GetPreStatus(Type,ID)
ClassMethod GetPreStatus(Type, ID)
{
    s Status="REG"
    i Type="PERSON"
    {
        s Status=$p($G(^DHCPEPreIADM(ID)),"^",8)
    }
    else
    {
        s Status=$p($G(^DHCPEPreGADM(+ID)),"^",6)
    }
    i Status="ARRIVED" s Status="ARR"
    q Status
}

/// Create by MLH 2007-11-26
/// w ##class(web.DHCPE.PreItemList).GetOrderPrice("684||1")
ClassMethod GetOrderPrice(arcItemId, PreIADM As %Library.String = "", MaxPriceFlag As %Library.String = "0", ItemFeeType As %Library.String = "", GTItemDate As %Library.String = "", LocID = "") As %String
{
    s OType=$p(arcItemId,"&",2)
    s arcItemId=$p(arcItemId,"&",1)
    s ADMFeeType=""
    s:GTItemDate="" GTItemDate=+$H
    s CurLocID = LocID
    //取个人预约记录上体检类型
    i PreIADM'="" 
    {
    i PreIADM["||"  d
    .s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",PreIADM))
    .s:CurLocID="" CurLocID=$p(^DHCPEPreGADM(+PreIADM),"^",23)
    else  d
    .s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",PreIADM))
    .s:CurLocID="" CurLocID=$p(^DHCPEPreIADM(PreIADM),"^",26)
    }
    else
    {
        s:(CurLocID="")&&($D(%session)) CurLocID=%session.Get("LOGON.CTLOCID")
        s:$G(CurLocID)="" CurLocID=152
        }
    s PatADM=$G(^DHCPESetting("DHCPE","DefaultPAADM",CurLocID))
    //s ExpStr="^^^"_PatADM_"^^^" 
    s RecLoc=..GetRecLoc(1,arcItemId)
    s ExpStr="^^^"_PatADM_"^"_RecLoc_"^"_arcItemId_"^" 
    i ItemFeeType'=""  s ADMFeeType=ItemFeeType  //如果传了项目对应的类型，优先项目
    
    /*
    i OType'="O"
    {
        s AccountAmount=##class(web.DHCPE.ItemExtend).GetARCPrice(arcItemId,PreIADM)
        q:AccountAmount'="" AccountAmount
    }
    */
    
    s AccountAmount=##class(web.DHCPE.ItemExtend).GetARCPrice(arcItemId,PreIADM,CurLocID)
    q:AccountAmount'="" AccountAmount

    Set BilledMode=$g(^DHCPESetting("DHCPE","BilledMode"))
        //Set HosCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
    Set HosCode=$g(^DHCPESetting("DHCPE","HospitalCode",CurLocID))

    //080117 wrz
    s UOM=$p($G(^ARCIM(+arcItemId,$p(arcItemId,"||",2),8)),"^",14)
    
    s Cat=+$p($G(^ARCIM(+arcItemId,$p(arcItemId,"||",2),1)),"^",10)
    i Cat'="" d
    .//s Cat=$p($G(^ARC("IC",Cat)),"^",8)
    .s ordType=$p($G(^ARC("IC",Cat)),"^",7)
    e  d
    .s ordType=""
    i ordType="R"
    {
        ;s itemPrice=##class(web.DHCDocOrderEntry).GetOrderPrice("","",arcItemId,+$H,"","","","")
        
        /// Input:
    ///         PatType：病人就诊类型，可以为空(pa_adm表PAADM_Epissubtype_DR ->PAC_EpisodeSubType)
    ///         InsType：费别指针，可以为空，为空时按计费组的配置走 
    ///         Arcim：医嘱项指针，不能为空 
    ///         SttDate：计费时间，可以为空，为空时取$h 
    ///         Prior：传空（不用） 
    ///         Instr：传空（不用）  
    ///         Linkto：传空 （不用）
    ///         OEPrice：自定价金额，自定价医嘱不能空 
    ///         HospID：医院指针，多院区时不能为空 
    ///         ExpStr：扩展串，格式：挂号优惠设置^医嘱Id^执行记录Id^就诊Id^医嘱接受科室Id^医嘱项Id^高值条码^库存项Id(预留)^患者Id^就诊类型(挂号时使用)
    /// Return：单价_"^"_折扣单价_"^"_记账单价_"^"_自付单价_"^"_错误代码
    /// w ##class(web.UDHCJFPRICE).GetOrderPrice("","18","5114||1",65032,"","","","","2","94^1055||4^^1125^^")
        
        //s itemPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(ADMFeeType,"",arcItemId,GTItemDate,"","","","")
         
        s hospid=$P(^CTLOC(CurLocID),"^",22)
		//s itemPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","","2||1",+$H,"","","","",2,"^^^^^^")
		s itemPrice=##class(web.UDHCJFPRICE).GetOrderPrice(ADMFeeType,"",arcItemId,GTItemDate,"","","","",hospid,ExpStr)
		b ;itemPrice
		s incId=$o(^INCI(0,"ARCIM_DR",+arcItemId,0))
		s UOMFac=1
		i incId'="" d
		.//包装单位
		.s bUom=$p(^INCI(incId,1),"^",10)
		.//基本单位
		.s pUom=$p(^INCI(incId,3),"^",6)
		.//门诊发药单位
		.s outPhUomDr=$p(^INCI(incId,1),"^",12)
		.//入库单位（正包装的）
		.//s UOMFac= ##class(PHA.FACE.OUT.Com).UOMFac(pUom,bUom) //整包装单位
		.s UOMFac= ##class(PHA.FACE.OUT.Com).UOMFac(outPhUomDr,bUom) // 和发药单位匹配
		//取医嘱的销售单位  发药单位
		s $p(itemPrice,"^",1)=$p(itemPrice,"^",1)*UOMFac

		s $p(itemPrice,"^",4)=$p(itemPrice,"^",1)
    }
    else
    {
        s hospid=$P(^CTLOC(CurLocID),"^",22)
        If BilledMode="Old" Do
        .Set CurrentNS=$ZNSPACE
        .;Set MEDDATA=^DHCPESetting("NAMESPACE","MEDDATA")
        .Set MEDDATA=^DHCPESetting("NAMESPACE","MEDDATA",CurLocID)
        .zn MEDDATA
        .////Set itemPrice=$$getprice1^CHOPOrderEntry(arcItemId,+$H)  修改为以下
        .i ((Cat=15)&&(HosCode="AZ")) d
        ..Set itemPrice=$$getprice^CHOPOrderEntry(arcItemId,+$H,UOM)
        .e  d
        ..Set itemPrice=$$getprice1^CHOPOrderEntry(arcItemId,GTItemDate)
        .
        .zn CurrentNS
        Else  Do
        .//Set itemPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcItemId,+$H,"","","","")
        .//Set itemPrice=##class(web.UDHCJFPRICE).GetOrderPrice(ADMFeeType,"",arcItemId,GTItemDate,"","","","")
        .//Set itemPrice=##class(web.UDHCJFPRICE).GetOrderPrice(ADMFeeType,"",arcItemId,GTItemDate,"","","","",hospid)
        .Set itemPrice=##class(web.UDHCJFPRICE).GetOrderPrice(ADMFeeType,"",arcItemId,GTItemDate,"","","","",hospid,ExpStr)
    }
    Set AccountAmount=+$P(itemPrice,"^",4)
    q:MaxPriceFlag=0 AccountAmount
    //q $P(itemPrice,"^",1)_"^"_$P(itemPrice,"^",4)
    q $P(itemPrice,"^",4)_"^"_$P(itemPrice,"^",4)
}

/*ClassMethod GetDefaultSpecName(arcim, Type)
{
    s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
    i TrakVerison="" s TrakVerison="TrakCare"
    s LabData=$G(^DHCPESetting("NAMESPACE","LABDATA"))
    s ExtCode=""
    i Type="1"
    {
    s arcos=##class(web.DHCPE.PEApp).GetArcSets("", arcim)
    i TrakVerison="TrakCare" d
    .Quit:$g(arcim)=""
    .Quit:'$d(^ARCIM(+arcim,1,"EXT"))
    .Set Ext=$o(^ARCIM(+arcim,1,"EXT",0))
    .Quit:$g(Ext)=""
    .Set ExtCode=$p(^ARCIM(+arcim,1,"EXT",Ext),"^",4)
    i "MedTrak"=TrakVerison d
    .Quit:$g(arcos)=""
    .s ExtCode=$P($G(^ARCOS(arcos)), "^", 11)
    //下面注释部分是按照医院取外部代码，集团医院会使用，如南山
    
    //s LocID=%session.Get("LOGON.CTLOCID")
    //s hospid=$P(^CTLOC(LocID),"^",22)
    //zn "DHC-Data"
    //s ExtCode=$$GetTestCodeByHosp^DHCDocOrderCommon(arcim,hospid)
    //zn "DHC-APP"
    

    q:ExtCode="" ""
    s SpecDR=""
    s SPECDesc=""
    Set Specimendr=""
    Set Specimenflag="N"
    For  Set Specimendr=$o(^[LabData]TTAB("TS",ExtCode,1,Specimendr)) Q:((Specimendr="")||(Specimenflag="Y")||(Specimenflag="1"))  Do
    .s SpecDR=Specimendr
    .Set Container=$o(^TTAB("TS",ExtCode,1,Specimendr,""))
    .i Container="" d
    ..Set Specimenflag=$p(^TTAB("TS",ExtCode,1,Specimendr),"\",1)
    ..i Specimenflag="Y"  s SpecDR=Specimendr
    .e  d
    ..Set Specimenflag=$g(^TTAB("TS",ExtCode,1,Specimendr,Container))
    ..If Specimenflag="1" s SpecDR=Specimendr
    
    .;Set Specimenflag=$p($g(^[LabData]TTAB("TS",ExtCode,1,Specimendr)),"/",1)
    .;s SpecDR=Specimendr
    .;i Specimenflag["Y"  s SpecDR=Specimendr
    i SpecDR'="" s SPECDesc=$p($G(^[LabData]TTAB("SPEC",SpecDR)),"\",1)
    q SpecDR_"^"_SPECDesc}
    else
    {
        q $G(^DHCPEDataEx("DHCPEPreIOrdItem","TEAM",arcim))
    }
}*/
/// Type=1   根据遗嘱项得到默认的标本
/// Type=2   根据分组的CRMItemID得到标本
/// w ##class(web.DHCPE.PreItemList).GetDefaultSpecName()
ClassMethod GetDefaultSpecName(arcim, Type, hospId As %Library.String = "", LocID As %String = "")
{
    i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
    i TrakVerison="" s TrakVerison="TrakCare"
    s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",LocID))
    s LabData=$G(^DHCPESetting("NAMESPACE","LABDATA",LocID))

    s ExtCode=""
    i Type="1"
    {
    s arcos=##class(web.DHCPE.PEApp).GetArcSets("", arcim)
  
    i TrakVerison="TrakCare" d
    .q:$g(arcim)=""
    .q:'$d(^ARCIM(+arcim,1,"EXT"))
    .s Ext=0
	.f  s Ext=$o(^ARCIM(+arcim,1,"EXT",Ext)) q:((Ext="")||(ExtCode'=""))  d
	..s StaDate=$p($g(^ARCIM(+arcim,1,"EXT",Ext)),"^",1)
	..s EndDate=$p($g(^ARCIM(+arcim,1,"EXT",Ext)),"^",2)
	..q:StaDate=""
	..q:StaDate>+$h
	..q:(EndDate'="")&&(EndDate<+$h)
	..s ExtCode=$p($g(^ARCIM(+arcim,1,"EXT",Ext)),"^",4)
    i "MedTrak"=TrakVerison d
    .q:$g(arcos)=""
    .s ExtCode=$P($g(^ARCOS(arcos)), "^", 11)    

    
    //下面注释部分是按照医院取外部代码，集团医院会使用，如南山
    /*
    s LocID=%session.Get("LOGON.CTLOCID")
    s hospid=$P(^CTLOC(LocID),"^",22)
    zn "DHC-Data"
    s ExtCode=$$GetTestCodeByHosp^DHCDocOrderCommon(arcim,hospid)
    zn "DHC-APP"
    */
    
    q:ExtCode="" ""
    i LisNewVersion="Y" {
        s ret=##class(web.DHCDocOrderCommon).GetSpecimenByTestset(ExtCode,hospId)
        s SpecDR=$p(ret,$c(3),1)
        s SPECDesc=$p(ret,$c(3),2)
        q SpecDR_"^"_SPECDesc
    }
    else{

        s SpecDR=""
        s SPECDesc=""
        Set Specimendr=""
        Set Specimenflag="N"
        For  Set Specimendr=$o(^[LabData]TTAB("TS",ExtCode,1,Specimendr)) Q:((Specimendr="")||(Specimenflag="Y")||(Specimenflag="1"))  Do
        .s SpecDR=Specimendr
        .Set Container=$o(^TTAB("TS",ExtCode,1,Specimendr,""))
        .i Container="" d
        ..Set Specimenflag=$p($g(^TTAB("TS",ExtCode,1,Specimendr)),"\",1)
        ..i Specimenflag="Y"  s SpecDR=Specimendr
        .e  d
        ..Set Specimenflag=$g(^TTAB("TS",ExtCode,1,Specimendr,Container))
        ..If Specimenflag="1" s SpecDR=Specimendr
        /*
        .Set Specimenflag=$p($g(^[LabData]TTAB("TS",ExtCode,1,Specimendr)),"/",1)
        .s SpecDR=Specimendr
        .i Specimenflag["Y"  s SpecDR=Specimendr*/
        i SpecDR'="" s SPECDesc=$p($g(^[LabData]TTAB("SPEC",SpecDR)),"\",1)
        q SpecDR_"^"_SPECDesc
        }
    }
    else
    {
        q $g(^DHCPEDataEx("DHCPEPreIOrdItem","TEAM",arcim))
    }
}

ClassMethod UpdateSpecName(SpecID, PreItem, Type)
{
    s SQLCODE=0
    TSTART
    i Type="TEAM"
    {
        s TItemStat=$p(^DHCPEPreGADM(+PreItem,"Team",$p(PreItem,"||",2),"ORDITEM",$p(PreItem,"||",3)),"^",13)
        i TItemStat'="1"
        {
            TROLLBACK
            q "分组项目状态不正确"
        }
        s ^DHCPEDataEx("DHCPEPreIOrdItem","TEAM",PreItem)=SpecID
        s IADM=0
        f  s IADM=$o(^DHCPEPreIADM(0,"GTOI",PreItem,IADM)) q:(IADM="")||(SQLCODE'=0)  d
        .s Sub=0
        .f  s Sub=$o(^DHCPEPreIADM(0,"GTOI",PreItem,IADM,Sub)) q:(Sub="")||(SQLCODE'=0)  d
        ..s IPreItem=IADM_"||"_Sub
        ..s ReturnStr=..UpdatePersonSpecID(IPreItem,SpecID)
        ..s SQLCODE=+ReturnStr
        ..s Return=$p(ReturnStr,"^",2)
        ..i SQLCODE=2 s SQLCODE=0
        
    }
    else
    {
        s ReturnStr=..UpdatePersonSpecID(PreItem,SpecID)
        s SQLCODE=+ReturnStr
        s Return=$p(ReturnStr,"^",2)
    }
    i SQLCODE'=0 
    {
        TROLLBACK
        q Return
    }
    TCOMMIT
    q SQLCODE
}

ClassMethod UpdatePersonSpecID(PreItemID, SpecID)
{
    s SQLCODE=0
    s PreItemStat=$p(^DHCPEPreIADM(+PreItemID,"ORDITEM",$p(PreItemID,"||",2)),"^",16)
    i PreItemStat'="1"
    {
        q "2^项目状态不是有效状态"
    }
    s CRMID=$o(^DHCPECRMO(0,"CRMORI",PreItemID,0))
    i CRMID'="" q "2^人员项目已经到达"
    /*{
        s OEORDID=$p(^DHCPECRMO(CRMID),"^",1)
        s OEORIStat=$p(^OEORD($p(OEORDID,"||",1),"I",$P(OEORDID,"||",2),1),"^",13)
        i OEORIStat'=1
        {
            q "2^医嘱状态不是核实状态"
        }
        s Spec=$P(SpecID,"^",1)
        &SQL(update sqluser.OE_OrdSpecimen set SPEC_Code=:Spec where SPEC_ParRef=:OEORDID)
        q:SQLCODE "1^更新医嘱标本错误"
    }*/
    s ^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",PreItemID)=SpecID
    q SQLCODE
}

ClassMethod ItemDelDataEx(PIOIRowId As %Library.String = "", PIOERowId As %Library.String = "", User As %Library.String = "1")
{
    
    Quit:(PIOIRowId="")&(PIOERowId="") ""
    ;s User=1
    If User="" Set User=%session.Get("LOGON.USERID")
    Set XDate=+$h
    Set XTime=$p($h,",",2)
    If PIOIRowId'="" Do
    .Set ^DHCPEDataEx("DHCPEPreIOrdItem","XDate","XTime",PIOIRowId)=XDate_"^"_XTime_"^"_User
    .Set ^DHCPEDataEx("DHCPEPreIOrdItem",0,"XDateTime",XDate,XTime,PIOIRowId)=""
    .Set ^DHCPEDataEx("DHCPEPreIOrdItem",0,"XUser",User,PIOIRowId)=""
    Else  Do
    .Quit:PIOERowId=""
    .Set ^DHCPEDataEx("DHCPEPreIOrdEnt","XDate","XTime",PIOERowId)=XDate_"^"_XTime_"^"_User
    .Set ^DHCPEDataEx("DHCPEPreIOrdEnt",0,"XDateTime",XDate,XTime,PIOERowId)=""
    .Set ^DHCPEDataEx("DHCPEPreIOrdEnt",0,"XUser",User,PIOERowId)=""
    .
    Quit 0
}

ClassMethod UnItemDelDataEx(PIOIRowId As %Library.String = "", PIOERowId As %Library.String = "")
{
    Quit:(PIOIRowId="")&(PIOERowId="") ""
    If PIOIRowId'="" Do
    .s Type="DHCPEPreIOrdItem"
    .s ID=PIOIRowId
    Else  Do
    .s Type="DHCPEPreIOrdEnt"
    .s ID=PIOERowId
    s OldInfo=$G(^DHCPEDataEx(Type,"XDate","XTime",ID))
    q:OldInfo=""
    k ^DHCPEDataEx(Type,"XDate","XTime",ID)
    s Date=$P(OldInfo,"^",1)
    s Time=$P(OldInfo,"^",2)
    s User=$P(OldInfo,"^",3)
    k ^DHCPEDataEx(Type,0,"XDateTime",Date,Time,ID)
    k ^DHCPEDataEx(Type,0,"XUser",User,ID)
    
    Quit 0
}

/// d ##class(web.DHCPE.PreItemList).ModifyAddAmountApp(13,100)
ClassMethod ModifyAddAmountApp(PreAdmId, Amount)
{
    s SQLCODE=0
    s AddFlag=$p($G(^DHCPEPreIADM(PreAdmId)),"^",10)
    s AddLimitFlag=$p($G(^DHCPEPreIADM(PreAdmId)),"^",11)
    s AddLimitAmount=+$p($G(^DHCPEPreIADM(PreAdmId)),"^",12)
    if (AddFlag="Y")&&(AddLimitFlag'="Y") q SQLCODE
    if (AddFlag'="Y") q SQLCODE
    /*
    if (AddFlag'="Y") d
    .s AddFlag="Y"
    .s AddLimitFlag="Y"
    */
    s AddLimitAmount=AddLimitAmount+Amount
    &SQL(update sqluser.DHC_PE_PreIADM set PIADM_AddOrdItem=:AddFlag,PIADM_AddOrdItemLimit=:AddLimitFlag,PIADM_AddOrdItemAmount=:AddLimitAmount where PIADM_RowId=:PreAdmId)
    i SQLCODE'=0 q SQLCODE
    &SQL(update sqluser.DHC_PE_IADM set IADM_AddOrdItem=:AddFlag,IADM_AddOrdItemLimit=:AddLimitFlag,IADM_AddOrdItemAmount=:AddLimitAmount where IADM_CRMADM=:PreAdmId)
    i SQLCODE=100 s SQLCODE=0
    q SQLCODE
}

/// w ##class(web.DHCPE.PreItemList).ModifyAddAmount("35703||2","Item")
ClassMethod ModifyAddAmount(ItemID, Type)
{
    s ModifyAddAmount=0
    if Type="Item" d
    .s ModifyAddAmount=+$p($G(^DHCPEPreIADM(+ItemID,"ORDITEM",$p(ItemID,"||",2))),"^",14)
    e  d
    .s ModifyAddAmount=$p($G(^DHCPEPreIADM(+ItemID,"ORDENT",$p(ItemID,"||",2))),"^",7)
    q:ModifyAddAmount=0 0
    s SQLCODE=..ModifyAddAmountApp(+ItemID,ModifyAddAmount)
    i SQLCODE'=0 q SQLCODE
    s SQLCODE=..ModifyIFeeAmount(+ItemID,"LimitFee")
    /*s gId=$p(^DHCPEPreIADM(+ItemID),"^",2)
    i gId'="" d
    .s SQLCODE=##class(web.DHCPE.PreAudit).UpdateFeeRecord(+ItemID,"LimitFee")
    .q:SQLCODE'=0
    .s SQLCODE=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(gId)
    */
    q SQLCODE
}

/// /删除项目的时候使用的修改自费金额
ClassMethod ModifyIFeeAmount(IADM, Type)
{
    q ##class(web.DHCPE.PreAudit).UpdateFeeRecord(IADM,"LimitFee")
}

ClassMethod GetARCIMbyOEOrd(PIADM, PIOrdID, Type)
{
 
    S ItemID="",PIOEOrderSetsDR="",IDStr=""
    i Type="Item"  d
    .s ARCIMID=$P($G(^DHCPEPreIADM($P(PIOrdID,"||",1),"ORDITEM", $P(PIOrdID,"||",2))),"^",1)
    .q:ARCIMID=""
    .s PIOIOrdEntDR=$P(^DHCPEPreIADM($P(PIOrdID,"||",1),"ORDITEM", $P(PIOrdID,"||",2)),"^",2)
    .i PIOIOrdEntDR'=""  s PIOEOrderSetsDR=$p(^DHCPEPreIADM($p(PIOIOrdEntDR,"||",1),"ORDENT",$p(PIOIOrdEntDR,"||",2)),"^",1) 
    .s childsub=""
    .f  s childsub=$o(^DHCPEPreIADM(0,"ItmMast",ARCIMID, PIADM,childsub))  q:childsub=""  d
    ..s OrderSetsDR=""
    ..s OrdEntDR=$P(^DHCPEPreIADM(PIADM,"ORDITEM", childsub),"^",2)
    ..i OrdEntDR'=""  s OrderSetsDR=$p(^DHCPEPreIADM($p(OrdEntDR,"||",1),"ORDENT",$p(OrdEntDR,"||",2)),"^",1) 
    ..q:PIOEOrderSetsDR'=OrderSetsDR
    ..s PIOIItemStat=$P(^DHCPEPreIADM(PIADM,"ORDITEM", childsub),"^",16)
    ..q:PIOIItemStat'="1"
    ..s ItemID=PIADM_"||"_childsub
    ..i IDStr=""  s IDStr=ItemID
    ..else  s IDStr=IDStr_"^"_ItemID
 
    
   i Type="Ent"  d
    .s OrderSets=$P($G(^DHCPEPreIADM($P(PIOrdID,"||",1),"ORDENT", $P(PIOrdID,"||",2))),"^",1) 
    .q:OrderSets=""
    .//s childsub=0
    .//s childsub=$o(^DHCPEPreIADM(0,"OrderSets",OrderSets, PIADM,0))
    .//q:childsub=""
    .//s ItemID=PIADM_"||"_childsub
    .//s PIOEItemStat=$P(^DHCPEPreIADM(PIADM,"ORDENT",childsub),"^",9) 
    .s ItemID=PIOrdID
    .s PIOEItemStat=$P(^DHCPEPreIADM($P(PIOrdID,"||",1),"ORDENT",$P(PIOrdID,"||",2)),"^",9) 
    .q:PIOEItemStat'="1"
    .i IDStr=""  s IDStr=ItemID
    .else  s IDStr=IDStr_"^"_ItemID

 
    i ("^"_IDStr_"^")[("^"_PIOrdID_"^")  q PIOrdID
    q ItemID
}

// w ##class(web.DHCPE.PreItemList).ItemHadSpec("1838","OrdSet")

ClassMethod ItemHadSpec(ItemID, Type As %String = "")
{
    ;n (ItemID,Type)
    s arcDesc=""
    s ItemID=$p(ItemID,"&",1)
    i Type="OrdSet"
    {
        s arcsetid=ItemID
        s arcsetdateid=""
        f  s arcsetdateid=$o(^ARCOS(arcsetid,"DATE",arcsetdateid)) q:((arcsetdateid="")||(arcDesc'=""))  d
        .s arcdata=$g(^ARCOS(arcsetid,"DATE",arcsetdateid))
        .q:arcdata=""
        .s datefrom=$p(arcdata,"^",1)
        .q:datefrom>+$h
        .s dateto=$p(arcdata,"^",2)
        .q:((dateto'="")&&(dateto<+$h))
        .s arcsetdateitemid=0
        .f  s arcsetdateitemid=$o(^ARCOS(arcsetid,"DATE",arcsetdateid,"ITM",arcsetdateitemid)) q:((arcsetdateitemid=""))  d
        ..s arcdata=$g(^ARCOS(arcsetid,"DATE",arcsetdateid,"ITM",arcsetdateitemid))
        ..s arcitemid=$p(arcdata,"^",1)
        ..s arcitemsub=$p(arcitemid,"||",1)
        ..s arcitemver=$p(arcitemid,"||",2)
        ..s itemCat=$P(^ARCIM(arcitemsub,arcitemver,1),"^",10)
        ..s catType=$P(^ARC("IC",itemCat),"^",7)
        ..q:catType'="L"
        ..s specStr=..GetDefaultSpecName(arcitemid,1)
        ..s specID=$P(specStr,"^",1)
        ..i specID="" d
        ...s arcDesc=$P(^ARCIM(arcitemsub,arcitemver,1),"^",2)
        .q:arcDesc'=""
        .s arcsetdateitemid=0
        .f  s arcsetdateitemid=$o(^ARCOS(arcsetid,"DATE",arcsetdateid,"OS",arcsetdateitemid)) q:((arcsetdateitemid="")||(arcDesc'=""))  d
        ..s arcdata=$g(^ARCOS(arcsetid,"DATE",arcsetdateid,"OS",arcsetdateitemid))
        ..s arcitemid=$p(arcdata,"^",1)
        ..s arcDesc=..ItemHadSpec(arcitemid,"OrdSet")
    }
    else
    {
        s arcitemid=ItemID
        s arcitemsub=$p(arcitemid,"||",1)
        s arcitemver=$p(arcitemid,"||",2)
        s itemCat=$P(^ARCIM(arcitemsub,arcitemver,1),"^",10)
        s catType=$P(^ARC("IC",itemCat),"^",7)
        q:catType'="L" ""
        s specStr=..GetDefaultSpecName(arcitemid,1)
        s specID=$P(specStr,"^",1)
        i specID="" d
        .s arcDesc=$P(^ARCIM(arcitemsub,arcitemver,1),"^",2)
    }
    q arcDesc
}

// 

// w ##class(web.DHCPE.PreItemList).UpdateItemFeeType("")

/// Type PERSON:个人  TEAM:分组
ClassMethod UpdateItemFeeType(Strings)
{

    //s Strings="685||1,PERSON,Item,8,1," 
    s CurLoc=%session.Get("LOGON.CTLOCID")
    //s FeeTypeSuperGroup=$g(^DHCPESetting("DHCPE","FeeTypeSuperGroup"))
    s FeeTypeSuperGroup=$g(^DHCPESetting("DHCPE","FeeTypeSuperGroup",CurLoc))

    s CurGroupID=%session.Get("LOGON.GROUPID")
    q:(FeeTypeSuperGroup'=CurGroupID) "不是超级权限，不能修改费用类别"

    Set UserID=%session.Get("LOGON.USERID")
    //s UserID="3878"
    k ^DHCPETMPChargeStr(UserID)
    s i=$length(Strings,"^")
    s SQLCODE=0
    s GetChargedStr=""
    TSTART
    for j=1:1:i
    {
    //修改项目体检费别
  
    s String=$p(Strings,"^",j)
    s ItemID=$p(String,",",1)
    s PersonType=$p(String,",",2)
    s ItemType=$p(String,",",3)
    s ItemFeeType=$p(String,",",4)
    s Qty=$p(String,",",5)
    s Parref=$p(ItemID,"||",1)
    s Sub=$p(ItemID,"||",2)
    s EntDR=$p(String,",",6)
    i +Qty=0  s Qty=1
    
    i PersonType="PERSON"
    {   
    if ItemType="Item"
    {
    s OldADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",ItemID))
    i OldADMFeeType'=ItemFeeType   d 
    .s ChargedFlag=..GetChargedFlag(ItemType,ItemID,EntDR) 
    .i ChargedFlag="1"  d ..GetChargedStr(PersonType,ItemID,EntDR) // 得到已收费项目名字，用于提示
    .q:ChargedFlag="1"    //已收费退出
    .s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",ItemID)=ItemFeeType
    .// //修改项目体检价格
    .//得到当前医嘱的折扣率
    .s SQLCODE=..UpdateAmountByItemFeeType(PersonType,ItemType,ItemID,Qty)
    }
    if ItemType="Ent"
    {
    s OldADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Ent",EntDR))
    i OldADMFeeType'=ItemFeeType  d
    .s ChargedFlag=..GetChargedFlag(ItemType,ItemID,EntDR)
    .i ChargedFlag="1"  d ..GetChargedStr(PersonType,ItemID,EntDR)
    .q:ChargedFlag="1"
    .d ..UpdateItemFeeTypeByEnt(PersonType,ItemID,EntDR,ItemFeeType)   //通过医嘱套设置医嘱项的费用类别
    .s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Ent",EntDR)=ItemFeeType
    .s SQLCODE=..UpdateAmountByItemFeeType(PersonType,ItemType,ItemID,Qty)
    }
    }
    i PersonType="TEAM" 
    {   
    if ItemType="Item"
    {
    s OldADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",ItemID))
    i OldADMFeeType'=ItemFeeType  d
    .s ChargedFlag=..GetTeamChargedFlag(ItemID,EntDR,ItemFeeType)
    .i ChargedFlag="1"  d ..GetChargedStr(PersonType,ItemID,EntDR)
    .q:ChargedFlag="1"
    .d ..UpdateItemFeeTypeByEnt(PersonType,ItemID,EntDR,ItemFeeType)   //通过医嘱套设置医嘱项的费用类别
    .s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",ItemID)=ItemFeeType
    .s SQLCODE=..UpdateAmountByItemFeeType(PersonType,ItemType,ItemID,Qty)
    }
    if ItemType="Ent"
    {
    
    s OldADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Ent",EntDR))
    i OldADMFeeType'=ItemFeeType  d
    .s ChargedFlag=..GetTeamChargedFlag(ItemID,EntDR,ItemFeeType)
    .i ChargedFlag="1"  d ..GetChargedStr(PersonType,ItemID,EntDR)
    .q:ChargedFlag="1"
    .d ..UpdateItemFeeTypeByEnt(PersonType,ItemID,EntDR,ItemFeeType)   //通过医嘱套设置医嘱项的费用类别
    .s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Ent",EntDR)=ItemFeeType
    .s SQLCODE=..UpdateAmountByItemFeeType(PersonType,ItemType,ItemID,Qty)
    }   

    }
} 
    i SQLCODE
 {
    TROLLBACK
    q SQLCODE
 }            
    TCOMMIT
    s ChargedStr=$G(^DHCPETMPChargeStr(UserID))
    i ChargedStr'=""   d
    .s Length=$l(ChargedStr,",")
    .s SQLCODE=$p(ChargedStr,",",2,Length)_"已收费,不能修改"
    q SQLCODE
}

ClassMethod GetChargedStr(PersonType, PIOIRowID, PIOERowID)
{
  
   
    s USERID=%session.Get("LOGON.USERID")
    //s UserID="3878"
    i PersonType="PERSON"  d
    .s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",PIOIRowID,0))
    .s ARCID=$p(^DHCPEPreIADM($P(PIOIRowID,"||",1),"ORDITEM",$P(PIOIRowID,"||",2)),"^",1)
    .q:ARCID=""
    .s ARCIMDesc=$p(^ARCIM($p(ARCID,"||",1),$p(ARCID,"||",2),1),"^",2)
    .i PIOERowID'=""  d
    ..s ARCOSDR=$p($g(^DHCPEPreIADM($p(PIOERowID,"||",1),"ORDENT",$p(PIOERowID,"||",2))),"^",1)
    ..s ARCOSDesc=$p(^ARCOS(ARCOSDR),"^",2)  
    ..s ARCIMDesc=ARCOSDesc
    .i CRMORowId'=""  d
    ..s BillStatus=$p(^DHCPECRMO(CRMORowId),"^",4)
    ..q:BillStatus'="P"
    ..s ^DHCPETMPChargeStr(USERID)=$G(^DHCPETMPChargeStr(USERID))_","_ARCIMDesc
    else  d
    .s ARCID=$p(^DHCPEPreGADM($P(PIOIRowID,"||",1),"Team",$P(PIOIRowID,"||",2),"ORDITEM",$P(PIOIRowID,"||",3)),"^",1)
    .q:ARCID=""
    .s ARCIMDesc=$p(^ARCIM($p(ARCID,"||",1),$p(ARCID,"||",2),1),"^",2)
    .i PIOERowID'=""  d
    ..s ARCOSDR=$p(^DHCPEPreGADM($P(PIOERowID,"||",1),"Team",$P(PIOERowID,"||",2),"ORDENT",$P(PIOERowID,"||",3)),"^",1)
    ..s ARCOSDesc=$p(^ARCOS(ARCOSDR),"^",2)  
    ..s ARCIMDesc=ARCOSDesc
    .Set PIADMRowId=0,ChargedFlag=0
    .For  Set PIADMRowId=$o(^DHCPEPreIADM(0,"GTOI",PIOIRowID,PIADMRowId)) Quit:PIADMRowId=""  Do
    ..Set PIOICldSub=0
    ..For  Set PIOICldSub=$o(^DHCPEPreIADM(0,"GTOI",PIOIRowID,PIADMRowId,PIOICldSub)) Quit:PIOICldSub=""  Do
    ...Set PIOIRowId=PIADMRowId_"||"_PIOICldSub
    ...Set PIOEDR=$P(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOICldSub),"^",2)
    ...i PIOEDR'="" s return=..GetChargedFlag("Ent","",PIOEDR)
    ...else  s return=..GetChargedFlag("Item",PIOIRowId,"")
    ...i return="1" s ChargedFlag="1"
    ...q:return="0"
    .q:ChargedFlag=0
    .s ^DHCPETMPChargeStr(USERID)=$G(^DHCPETMPChargeStr(USERID))_","_ARCIMDesc
  
 q ""
}

ClassMethod GetTeamChargedFlag(PGOIRowID, PGOERowID, ItemFeeType)
{
    
   
    Set PIADMRowId=0,ChargedFlag=0
    For  Set PIADMRowId=$o(^DHCPEPreIADM(0,"GTOI",PGOIRowID,PIADMRowId)) Quit:PIADMRowId=""  Do
    .Set PIOICldSub=0
    .For  Set PIOICldSub=$o(^DHCPEPreIADM(0,"GTOI",PGOIRowID,PIADMRowId,PIOICldSub)) Quit:PIOICldSub=""  Do
    ..Set PIOIRowId=PIADMRowId_"||"_PIOICldSub
    ..Set PIOEDR=$P(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOICldSub),"^",2)
    ..i PIOEDR'="" s return=..GetChargedFlag("Ent","",PIOEDR)
    ..else  s return=..GetChargedFlag("Item",PIOIRowId,"")
    ..i return="1" s ChargedFlag="1"


     Q ChargedFlag
}

// "TEAM^49||3||4^49||3||1^8" 

// w ##class(web.DHCPE.PreItemList).UpdateItemFeeTypeByEnt("TEAM","49||3||4","49||3||1","6")

ClassMethod UpdateItemFeeTypeByEnt(PersonType, ItemDR, EntDR, ItemFeeType)
{

    i PersonType="PERSON"  d
    .s PIOIChildSub=0
    .f  s PIOIChildSub=$o(^DHCPEPreIADM(0,"OrdEnt",EntDR,$p(EntDR,"||",1),PIOIChildSub))  q:PIOIChildSub=""  d
    ..s PIOIRowID=$p(EntDR,"||",1)_"||"_PIOIChildSub
    ..s OrdItemStatus=$p(^DHCPEPreIADM($p(PIOIRowID,"||",1),"ORDITEM",PIOIChildSub),"^",16)
    ..q:OrdItemStatus'="1" 
    ..s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",PIOIRowID)=ItemFeeType
    i PersonType="TEAM"  d
    .i EntDR'=""  d     // 如果是医嘱套
    ..s PGTOIChildSub=0
    ..f  s PGTOIChildSub=$o(^DHCPEPreGADM(0,"OrdEnt",EntDR,$p(EntDR,"||",1),$p(EntDR,"||",2),PGTOIChildSub)) q:PGTOIChildSub=""  d
    ...s PGTOIItemStat=$p($G(^DHCPEPreGADM($p(EntDR,"||",1),"Team",$p(EntDR,"||",2),"ORDITEM",PGTOIChildSub)),"^",13)
    ...s PGTOIOrdItemDR=$p(EntDR,"||",1)_"||"_$p(EntDR,"||",2)_"||"_PGTOIChildSub
    ...q:PGTOIItemStat'=1
    ...s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",PGTOIOrdItemDR)=ItemFeeType
    ..s PIADMRowId=0
    ..f  s PIADMRowId=$o(^DHCPEPreIADM(0,"GTOE",EntDR, PIADMRowId))  q:PIADMRowId=""  d
    ...s PIOEChildSub=0
    ...f  s PIOEChildSub=$o(^DHCPEPreIADM(0,"GTOE",EntDR, PIADMRowId,PIOEChildSub)) q:PIOEChildSub=""  d
    ....s PIOERowID=PIADMRowId_"||"_PIOEChildSub
    ....s PIOEItemStat=$p($G(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub)),"^",9) 
    ....q:PIOEItemStat'="1" 
    ....s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Ent",PIOERowID)=ItemFeeType
    ....s PIOIChildSub=0
    ....f  s PIOIChildSub=$o(^DHCPEPreIADM(0,"OrdEnt",PIOERowID,PIADMRowId,PIOIChildSub))  q:PIOIChildSub=""  d
    .....s PIOIRowID=PIADMRowId_"||"_PIOIChildSub
    .....s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",PIOIRowID)=ItemFeeType
    .else  d
    ..s PIADMRowId=0
    ..f  s PIADMRowId=$o(^DHCPEPreIADM(0,"GTOI",ItemDR, PIADMRowId))  q:PIADMRowId=""  d
    ...Set PIOICldSub=0
    ...For  Set PIOICldSub=$o(^DHCPEPreIADM(0,"GTOI",ItemDR,PIADMRowId,PIOICldSub)) Quit:PIOICldSub=""  Do
    ....Set PIOIRowId=PIADMRowId_"||"_PIOICldSub
    ....s OrdItemStatus=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOICldSub),"^",16)
    ....q:OrdItemStatus'="1" 
    ....s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",PIOIRowId)=ItemFeeType

     Q ""
}

// w ##class(web.DHCPE.PreItemList).UpdateAmountByItemFeeType("PERSON","Item","641||4","1")

/// 根据体检费别更新金额 //PERSON^Item^641||4^1" 
/// Type Person:个人  Item:分组
ClassMethod UpdateAmountByItemFeeType(PersonType, Type, ItemID, Qty As %String = "1")
{
    
    s SQLCODE=0  //ORDENT
    s Parref=$p(ItemID,"||",1)
    s Sub=$p(ItemID,"||",2)
    i Type="Item"  s ItemType="ORDITEM" 
    i Type="Ent"  s ItemType="ORDENT" 
    s PAuditID="",FactAmount="0",PAprivilegeMode="",Rate=""
    i PersonType="PERSON"
    {   
    s PIOEDR=$P(^DHCPEPreIADM(Parref,"ORDITEM",Sub),"^",2)
    i PIOEDR'="" d
    .s FeeSub=$O(^DHCPEPreIADM($p(PIOEDR,"||",1),ItemType,$p(PIOEDR,"||",2),"FEE",0))
    .q:FeeSub=""
    .s PAuditID=$P(^DHCPEPreIADM($p(PIOEDR,"||",1),ItemType, $p(PIOEDR,"||",2),"FEE",FeeSub),"^",5)
    .s PIOEOrderSetsDR=$p(^DHCPEPreIADM($p(PIOEDR,"||",1),"ORDENT",$p(PIOEDR,"||",2)),"^",1) 
    .s PIOISub=0  //得到医嘱套有效医嘱的费用累加
    .f  s PIOISub=$o(^DHCPEPreIADM(0,"OrdEnt",PIOEDR,Parref,PIOISub))  q:PIOISub=""  d
    ..s OrdItemStatus=$p(^DHCPEPreIADM(Parref,"ORDITEM",PIOISub),"^",16)
    ..q:OrdItemStatus'="1" 
    ..s PIOIARCIMDR=$P(^DHCPEPreIADM(Parref,"ORDITEM",PIOISub),"^",1)
    ..s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",Parref_"||"_PIOISub))
    ..s PIOIFactAmount=..GetOrderPrice(PIOIARCIMDR_"&O","","",ADMFeeType)
    ..s PIOIID=Parref_"||"_PIOISub
    ..s PIOIFactAmount=$p(PIOIFactAmount,"^",1)*Qty
    ..&SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_AccountAmount=:PIOIFactAmount where PIOI_RowId=:PIOIID)
    ..s FactAmount=FactAmount+PIOIFactAmount
    else  d
    .s FeeSub=$O(^DHCPEPreIADM(Parref,ItemType,Sub,"FEE",0))
    .q:FeeSub=""
    .s PAuditID=$P(^DHCPEPreIADM(Parref,ItemType, Sub,"FEE",FeeSub),"^",5)
    .s PIOIARCIMDR=$P(^DHCPEPreIADM(Parref,"ORDITEM",Sub),"^",1)
    .s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",ItemID))
    .s FactAmount=..GetOrderPrice(PIOIARCIMDR_"&O","","",ADMFeeType)
    .s FactAmount=$p(FactAmount,"^",1)*Qty
    q:PAuditID="" "后台数据出错"
    s PAStr=$G(^DHCPEPreA(PAuditID))
    s PAprivilegeMode=$p(PAStr,"^",19)
    s Rate=$p(PAStr,"^",5)
    s ChargedStatus=$p(PAStr,"^",14)
    q:ChargedStatus="CHARGED" "项目已收费不允许修改"  

    }
    
    i PersonType="TEAM"
    {

    s PGOEDR=$p(^DHCPEPreGADM($p(ItemID,"||",1),"Team",$p(ItemID,"||",2),"ORDITEM",$p(ItemID,"||",3)),"^",2)
    s ItmMastDR=$p(^DHCPEPreGADM($p(ItemID,"||",1),"Team",$p(ItemID,"||",2),"ORDITEM",$p(ItemID,"||",3)),"^",1)
    s PAprivilegeMode=$p(^DHCPEPreGADM($p(ItemID,"||",1),"Team",$p(ItemID,"||",2),"ORDITEM",$p(ItemID,"||",3)),"^",5)
    s Rate=$p(^DHCPEPreGADM($p(ItemID,"||",1),"Team",$p(ItemID,"||",2),"ORDITEM",$p(ItemID,"||",3)),"^",6)
    i PGOEDR'="" d
    .s OrderSetsDR=$p(^DHCPEPreGADM($p(PGOEDR,"||",1),"Team",$p(PGOEDR,"||",2),"ORDENT",$p(PGOEDR,"||",3)),"^",1)   
    .s PGTChildSub=0
    .f  s PGTChildSub=$o(^DHCPEPreGADM(0,"OrdEnt",PGOEDR,$p(ItemID,"||",1),PGTChildSub))  q:PGTChildSub=""  d
    ..s PGOISub=0  //得到医嘱套有效医嘱的费用累加
    ..f  s PGOISub=$o(^DHCPEPreGADM(0,"OrdEnt",PGOEDR,$p(ItemID,"||",1),PGTChildSub,PGOISub))  q:PGOISub=""  d
    ...s PGOIDR=$p(ItemID,"||",1)_"||"_PGTChildSub_"||"_PGOISub
    ...s PGTOIItemStat=$p(^DHCPEPreGADM($p(ItemID,"||",1),"Team",PGTChildSub,"ORDITEM",PGOISub),"^",13)
    ...q:PGTOIItemStat'=1
    ...s ItmMastDR=$p(^DHCPEPreGADM($p(ItemID,"||",1),"Team",PGTChildSub,"ORDITEM",PGOISub),"^",1)
    ...s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",PGOIDR))
    ...s PGOIFactAmount=..GetOrderPrice(ItmMastDR_"&O","","",ADMFeeType)
    ...s PGOIFactAmount=$p(PGOIFactAmount,"^",1)*Qty
    ...s FactAmount=FactAmount+PGOIFactAmount
    else  d
    .s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",ItemID))
    .s FactAmount=..GetOrderPrice(ItmMastDR_"&O","","",ADMFeeType)
    .s FactAmount=$p(FactAmount,"^",1)*Qty  
    }

    
    s AccountAmount=FactAmount
    s AccountAmount=AccountAmount
    if PAprivilegeMode="OR" s FactAmount=FactAmount*Rate/100
 

    
    TSTART

        i PersonType="PERSON"
        {     
            s SQLCODE=..UpdateItemByPerson(ItemID,FactAmount,Qty,AccountAmount)

        }
        i PersonType="TEAM"
        {
            s SQLCODE=..UpdateItemByTeam(ItemID,FactAmount,Qty,AccountAmount)
        }
        q:SQLCODE
    
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    
    i PersonType="PERSON"
    {
        s iAdm=+ItemID
        s SQLCODE=##class(web.DHCPE.PreAudit).UpdateFeeRecord(iAdm,"OPAmount")
        i SQLCODE
        {
        TROLLBACK
            q SQLCODE
        }
        s gAdm=$p(^DHCPEPreIADM(iAdm),"^",2)
        i gAdm="" d
        .s SQLCODE=##class(web.DHCPE.PreIADM).UpdatePersonAuditAmount(iAdm)
        e  d
        .s SQLCODE=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(gAdm)
    }

    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
                  
    TCOMMIT
    q SQLCODE
}

ClassMethod UpdateItemByTeam(ItemID, FactAmount, Qty As %String = "1", AccountAmount)
{
    s SQLCODE=0
    s Parref=$p(ItemID,"||",1)
    s TSub=$p(ItemID,"||",2)
    s Sub=$p(ItemID,"||",3)
    s OEntID=$p($g(^DHCPEPreGADM(Parref,"Team",TSub,"ORDITEM",Sub)),"^",2)
    i OEntID=""
    {
        s OldFactAmount=$p($g(^DHCPEPreGADM(Parref,"Team",TSub,"ORDITEM",Sub)),"^",6)
    }
    else
    {
        s OldFactAmount=..GetGTOrdEntPrice(OEntID)
    }
    i OldFactAmount="" s OldFactAmount=0
    i OEntID=""
    {
        &SQL(update sqluser.DHC_PE_PreGTOrdItem set PGTOI_FactAmount=:FactAmount,PGTOI_AccountAmount=:AccountAmount where PGTOI_RowId=:ItemID)
        q:SQLCODE SQLCODE
    
        s IADM=0
        f  s IADM=$o(^DHCPEPreIADM(0,"GTOI",ItemID,IADM)) q:(IADM="")||(SQLCODE'=0)  d
        .s Sub=0
        .f  s Sub=$o(^DHCPEPreIADM(0,"GTOI",ItemID,IADM,Sub)) q:(Sub="")||(SQLCODE'=0)  d 
        ..s IFlag=$p(^DHCPEPreIADM(IADM,"ORDITEM",Sub),"^",16)
        ..q:IFlag'="1"
        ..s PIOIARCIMDR=$P(^DHCPEPreIADM(IADM,"ORDITEM",Sub),"^",1)
        ..s FSub=0
        ..s Flag=0
        ..s IADMQty=$g(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",IADM_"||"_Sub))
        ..i +IADMQty=0 s IADMQty=1
        ..f  s FSub=$o(^DHCPEPreIADM(IADM,"ORDITEM",Sub,"FEE",FSub)) q:(FSub="")||(Flag=1)  d
        ...s PAudit=$p(^DHCPEPreIADM(IADM,"ORDITEM",Sub,"FEE",FSub),"^",5)
        ...q:PAudit=""
        ...s PAStr=$G(^DHCPEPreA(PAudit))
        ...s PAprivilegeMode=$p(PAStr,"^",19)
        ...s Rate=$p(PAStr,"^",5)
        ...s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",IADM_"||"_Sub))
        ...s IFactAmount=..GetOrderPrice(PIOIARCIMDR_"&O","","",ADMFeeType)
        ...s IFactAmount=$p(IFactAmount,"^",1)
        ...s IAccountAmount=IFactAmount
        ...if PAprivilegeMode="OR" s IFactAmount=IFactAmount*Rate/100
        ...s IFlag=$p(^DHCPEPreA(PAudit),"^",21)
        ...s:IFlag="NU" Flag=1
        ...s IFlag=$p(^DHCPEPreA(PAudit),"^",19)
        ...;s:IFlag'="OP" Flag=1
        ...s IFlag=$p(^DHCPEPreA(PAudit),"^",14)
        ...s:IFlag="CHARGED" Flag=1
        ...q:Flag=1
        ...s FID=IADM_"||"_Sub_"||"_FSub
        ...s IFactAmount=IADMQty*IFactAmount
        ...&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_FactAmount=:IFactAmount where PIOIF_RowId=:FID)
        ...s:SQLCODE'=0 Flag=1
        ..q:Flag=1
        ..s IID=IADM_"||"_Sub
        ..s IAccountAmount=IADMQty*IAccountAmount
        ..&SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_FactAmount=:IFactAmount,PIOI_AccountAmount=:IAccountAmount where PIOI_RowId=:IID)
    
        
        
        
    }
    else
    {
        &SQL(update sqluser.DHC_PE_PreGTOrdEnt set PGTOE_FactAmount=:FactAmount,PGTOE_AccountAmount=:AccountAmount where PGTOE_RowId=:OEntID)
        q:SQLCODE SQLCODE
        s SQLCODE=..ChangedTOrdItem(OEntID) //更新团体分组套餐中项目的价格
        q:SQLCODE SQLCODE
        s IADM=0
        f  s IADM=$o(^DHCPEPreIADM(0,"GTOE",OEntID,IADM)) q:(IADM="")||(SQLCODE'=0)  d
        .s Sub=0
        .f  s Sub=$o(^DHCPEPreIADM(0,"GTOE",OEntID,IADM,Sub)) q:(Sub="")||(SQLCODE'=0)  d 
        ..s IFlag=$p(^DHCPEPreIADM(IADM,"ORDENT",Sub),"^",9)
        ..q:IFlag'="1"
        ..s PIOEOrderSetsDR=$p(^DHCPEPreIADM(IADM,"ORDENT",Sub),"^",1) 
        ..s FSub=0
        ..s IADMQty=$G(^DHCPEDataEx("DHCPEPreIOrdEnt","Qty",IADM_"||"_Sub))
        ..i +IADMQty=0 s IADMQty=1
        ..s Flag=0,IFactAmount=0
        ..f  s FSub=$o(^DHCPEPreIADM(IADM,"ORDENT",Sub,"FEE",FSub)) q:(FSub="")||(Flag=1)  d
        ...s PAudit=$p(^DHCPEPreIADM(IADM,"ORDENT",Sub,"FEE",FSub),"^",5)
        ...q:PAudit=""
        ...s PAStr=$G(^DHCPEPreA(PAudit))
        ...s PAprivilegeMode=$p(PAStr,"^",19)
        ...s Rate=$p(PAStr,"^",5)
        ...s PIOISub=0  //得到医嘱套有效医嘱的费用累加
        ...f  s PIOISub=$o(^DHCPEPreIADM(0,"OrdEnt",IADM_"||"_Sub,IADM,PIOISub))  q:PIOISub=""  d
        ....s PIOIStatus=$p(^DHCPEPreIADM(IADM,"ORDITEM",PIOISub),"^",16)
        ....q:PIOIStatus'="1" 
        ....s PIOIARCIMDR=$P(^DHCPEPreIADM(IADM,"ORDITEM",PIOISub),"^",1)
        ....s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",IADM_"||"_PIOISub))
        ....s PIOIRowid=IADM_"||"_PIOISub
        ....s PIOIFactAmount=$p(..GetOrderPrice(PIOIARCIMDR_"&O","","",ADMFeeType),"^",1)
        ....&SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_AccountAmount=:PIOIFactAmount where PIOI_RowId=:PIOIRowid)
        ....s IFactAmount=IFactAmount+PIOIFactAmount
        ...s IAccountAmount=IFactAmount
        ...s IFactAmount=IADMQty*IFactAmount
        ...s IAccountAmount=IADMQty*IAccountAmount
        ...if PAprivilegeMode="OR" s IFactAmount=IFactAmount*Rate/100
        ...s IFlag=$p(^DHCPEPreA(PAudit),"^",21)
        ...s:IFlag="NU" Flag=1
        ...s IFlag=$p(^DHCPEPreA(PAudit),"^",19)
        ...;s:IFlag'="OP" Flag=1
        ...s IFlag=$p(^DHCPEPreA(PAudit),"^",14)
        ...s:IFlag="CHARGED" Flag=1
        ...q:Flag=1
        ...s FID=IADM_"||"_Sub_"||"_FSub
        ...&SQL(update sqluser.DHC_PE_PreIOrdEntFee set PIOEF_FactAmount=:IFactAmount where PIOEF_RowId=:FID)
        ...s:SQLCODE'=0 Flag=1
        ..q:Flag=1
        ..s IID=IADM_"||"_Sub
        ..&SQL(update sqluser.DHC_PE_PreIOrdEnt set PIOE_FactAmount=:IFactAmount,PIOE_AccountAmount=:IAccountAmount where PIOE_RowId=:IID)
     
        
        
        
    }
    
    q:SQLCODE SQLCODE
    s SQLCODE=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(+ItemID)
    
    q SQLCODE
    //s AuditID=$p($g(^DHCPEPreGADM(Parref,"Team",TSub,"ORDITEM",Sub)),"^",12)
    //s SQLCODE=##class(web.DHCPE.PreItemList).UpdateAmount(AuditID,0,0,OldFactAmount,FactAmount)
    //q SQLCODE
}

ClassMethod SaveInsuFlag(OrdItemId As %Library.String = "", OrdEntId As %Library.String = "", AdmType As %Library.String = "", ItemType As %Library.String = "", InsuFlag As %Library.String = "") As %String
{

    s UserID=%session.Get("LOGON.USERID")
    //s UserID="3878"
    Quit:((AdmType'="PERSON")&&(AdmType'="TEAM")) "ERROR: AdmType must is PERSON/TEAM"
    Quit:((OrdItemId="")&&(OrdEntId="")) "ERROR: Arguments OrdItemId/OrdEntId is null!"
    //设置个人单个项目
    s ChargedStr=""
    If ("PERSON"=AdmType)&&(""=OrdEntId) Do
    .s ChargedFlag=..GetChargedFlag(ItemType,OrdItemId,OrdEntId)
    .q:ChargedFlag="1"
    .i InsuFlag=""  d    //保存个人医嘱项医保设置
    ..i $d(^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",OrdItemId))  k ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",OrdItemId)
    .else  d
    ..s ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",OrdItemId)=$H_"^"_UserID
    //设置个人套餐
    If ("PERSON"=AdmType)&&(""'=OrdEntId) Do
    .s ChargedFlag=..GetChargedFlag(ItemType,OrdItemId,OrdEntId)
    .q:ChargedFlag="1"
    .i InsuFlag=""  d   //保存个人医嘱套医保设置
    ..i $d(^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Ent",OrdEntId))  k ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Ent",OrdEntId)
    .else  d
    ..s ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Ent",OrdEntId)=$H_"^"_UserID
    .//Set PIOICldSub=0
    .//For  Set PIOICldSub=$o(^DHCPEPreIADM(0,"OrdEnt",OrdEntId,$p(OrdEntId,"||",1),PIOICldSub)) Quit:PIOICldSub=""  Do
    .//.s PIOIRowId=$p(OrdEntId,"||",1)_"||"_PIOICldSub
    .//.s PIOIItemStat=$p(^DHCPEPreIADM($p(OrdEntId,"||",1),"ORDITEM",PIOICldSub),"^",16)  
    .//.q:PIOIItemStat'="1"
    .//.i InsuFlag=""  d   //保存个人医嘱套下医嘱项目医保设置
    .//..i $d(^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",PIOIRowId))  k ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",PIOIRowId)
    .//.else  d
    .//..s ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",PIOIRowId)=$H_"^"_UserID
    //设置分组单个项目
    i ("TEAM"=AdmType)&&(""=OrdEntId)  Do
    .Set PIADMRowId=0
    .For  Set PIADMRowId=$o(^DHCPEPreIADM(0,"GTOI",OrdItemId,PIADMRowId)) Quit:PIADMRowId=""  Do
    ..Set PIOICldSub=0
    ..For  Set PIOICldSub=$o(^DHCPEPreIADM(0,"GTOI",OrdItemId,PIADMRowId,PIOICldSub)) Quit:PIOICldSub=""  Do
    ...Set PIOIRowId=PIADMRowId_"||"_PIOICldSub
    ...s PIOIItemStat=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOICldSub),"^",16)  
    ...q:PIOIItemStat'="1"
    ...s ChargedFlag=..GetChargedFlag(ItemType,PIOIRowId,"")
    ...s ChargedStr=ChargedStr_"^"_ChargedFlag
    ...q:ChargedFlag="1"
    ...i InsuFlag=""  d    //保存分组下体检者医嘱项的医保设置
    ....i $d(^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",PIOIRowId))  k ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",PIOIRowId)
    ...else  d
    ....s ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",PIOIRowId)=$H_"^"_UserID
    .i ChargedStr'[0  s ChargedFlag=1  //如果此医嘱全组都已交费，则不能改变医保设置勾
    .else  d
    ..i InsuFlag=""  d      //保存分组医嘱项的医保设置  OrdItemId为DHC_PE_PreGTOrdItem表ID
    ...i $d(^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",OrdItemId))  k ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",OrdItemId)
    ..else  d
    ...s ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",OrdItemId)=$H_"^"_UserID
    // 设置分组套餐
    If ("TEAM"=AdmType)&&(""'=OrdEntId) Do
    .Set PIADMRowId=0
    .For  Set PIADMRowId=$o(^DHCPEPreIADM(0,"GTOE",OrdEntId,PIADMRowId)) Quit:PIADMRowId=""  Do
    ..Set PIOECldSub=0
    ..For  Set PIOECldSub=$o(^DHCPEPreIADM(0,"GTOE",OrdEntId,PIADMRowId,PIOECldSub)) Quit:PIOECldSub=""  Do
    ...Set PIOERowId=PIADMRowId_"||"_PIOECldSub
    ...s PIOEStat=$p(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOECldSub),"^",9)  
    ...q:PIOEStat'="1"
    ...s ChargedFlag=..GetChargedFlag(ItemType,"",PIOERowId)
    ...s ChargedStr=ChargedStr_"^"_ChargedFlag
    ...q:ChargedFlag="1"
    ...i InsuFlag=""  d     //保存分组下个人医嘱套医保设置
    ....i $d(^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Ent",PIOERowId))  k ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Ent",PIOERowId)
    ...else  d
    ....s ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Ent",PIOERowId)=$H_"^"_UserID
    ...//Set PIOICldSub=0
    ...//For  Set PIOICldSub=$o(^DHCPEPreIADM(0,"OrdEnt",PIOERowId,PIADMRowId,PIOICldSub)) Quit:PIOICldSub=""  Do
    ...//.s PIOIRowId=PIADMRowId_"||"_PIOICldSub
    ...//.s PIOIItemStat=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOICldSub),"^",16)  
    ...//.q:PIOIItemStat'="1"
    ...//.i InsuFlag=""  d //保存分组下个人医嘱套里项目医保设置
    ...//..i $d(^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",PIOIRowId))  k ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",PIOIRowId)
    ...//.else  d
    ...//..s ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Item",PIOIRowId)=$H_"^"_UserID
    .i ChargedStr'[0  s ChargedFlag=1  //如果此医嘱套全组都已交费，则不能改变医保设置勾
    .else  d  //保存分组医嘱套医保设置 OrdItemId为DHC_PE_PreGTOrdEnt表ID
    ..i InsuFlag=""  d
    ...i $d(^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Ent",OrdEntId))  k ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Ent",OrdEntId)
    ..else  d
    ...s ^DHCPEDataEx("DHCPEPreIADM","InsuFlag","Ent",OrdEntId)=$H_"^"_UserID
  Q ChargedFlag
}

// 如果已付费则不修改设置

// Ent^372||5^372||1"

// w ##class(web.DHCPE.PreItemList).GetChargedFlag("Item","433||1","")

ClassMethod GetChargedFlag(ItemType, PersonItemDR, PersonEntDR)
{
 
  s FeeFlag=0
  i ItemType="Item"  d
  .s ItemType="ORDITEM"
  .s PIADM=$p(PersonItemDR,"||",1)
  .s ChildSub=$p(PersonItemDR,"||",2)
  else    d
  .s ItemType="ORDENT"
  .s PIADM=$p(PersonEntDR,"||",1)
  .s ChildSub=$p(PersonEntDR,"||",2)
  s FeeChildSub=0
  f  s FeeChildSub=$o(^DHCPEPreIADM(PIADM,ItemType,ChildSub,"FEE",FeeChildSub))  q:FeeChildSub=""  d
  .s AuditID=$P(^DHCPEPreIADM(PIADM,ItemType, ChildSub,"FEE",FeeChildSub),"^",5)
  .q:AuditID=""
  .s ChargedStatus=$p(^DHCPEPreA(AuditID),"^",14) 
  .i ChargedStatus="CHARGED"  s FeeFlag=1
  
  q FeeFlag
}

// 通过医嘱套ID,修改团体分组中医嘱套对应的DHC_PE_PreGTOrdItem记录

/// /w ##class(web.DHCPE.PreItemList).ChangedTOrdItem("76||7||2")
ClassMethod ChangedTOrdItem(PGOEDR)
{
   
    s SQLCODE=0
    s PGTChildSub=0 
    f  s PGTChildSub=$o(^DHCPEPreGADM(0,"OrdEnt",PGOEDR,$p(PGOEDR,"||",1),$p(PGOEDR,"||",2), PGTChildSub))  q:PGTChildSub=""  d
    .s PGTOIOrdItemDR=$p(PGOEDR,"||",1)_"||"_$p(PGOEDR,"||",2)_"||"_PGTChildSub
    .s ItmMastDR=$p(^DHCPEPreGADM($p(PGTOIOrdItemDR,"||",1),"Team",$p(PGTOIOrdItemDR,"||",2),"ORDITEM",$p(PGTOIOrdItemDR,"||",3)),"^",1)
    .s PGTOIItemStat=$p(^DHCPEPreGADM($p(PGTOIOrdItemDR,"||",1),"Team",$p(PGTOIOrdItemDR,"||",2),"ORDITEM",$p(PGTOIOrdItemDR,"||",3)),"^",13)
    .q:PGTOIItemStat'=1
    .s Qty=$G(^DHCPEDataEx("DHCPEPreGTOrdItem","Qty",PGTOIOrdItemDR))
    .i +Qty=0 s Qty=1
    .s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",PGTOIOrdItemDR))
    .s FactAmount=##class(web.DHCPE.PreItemList).GetOrderPrice(ItmMastDR_"&O","","",ADMFeeType)
    .s FactAmount=$p(FactAmount,"^",1)
    .s FactAmount=FactAmount*Qty
    .s AccountAmount=FactAmount 
    .s PAprivilegeMode=$p(^DHCPEPreGADM($p(PGTOIOrdItemDR,"||",1),"Team",$p(PGTOIOrdItemDR,"||",2),"ORDITEM",$p(PGTOIOrdItemDR,"||",3)),"^",5)
    .s Rate=$p(^DHCPEPreGADM($p(PGTOIOrdItemDR,"||",1),"Team",$p(PGTOIOrdItemDR,"||",2),"ORDITEM",$p(PGTOIOrdItemDR,"||",3)),"^",6)
    .if PAprivilegeMode="OR" s FactAmount=FactAmount*Rate/100
    .&SQL(update sqluser.DHC_PE_PreGTOrdItem set PGTOI_FactAmount=:FactAmount,PGTOI_AccountAmount=:AccountAmount where PGTOI_RowId=:PGTOIOrdItemDR)
   q SQLCODE
}

ClassMethod IsAddItem(PreIADM, ItemSub)
{
    s PreSetID=$p(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",2)
    q:PreSetID="" 0
    s OrdSetID=$p(^DHCPEPreIADM(PreIADM,"ORDENT",$P(PreSetID,"||",2)),"^",1)
    s ARCOSOrdSubCatDR=$p($G(^ARCOS(OrdSetID)),"^",9)
    s OrcatDesc=$p($G(^ARC("IC",ARCOSOrdSubCatDR)),"^",2)
    q:OrcatDesc'="体检医嘱套" 0
    q 1
}

/// w ##class(web.DHCPE.PreItemList).GetPreItemDesc("9||1","TEAM")
/// w ##class(web.DHCPE.PreItemList).GetPreItemDesc("189","PERSON")
ClassMethod GetPreItemDesc(PreIADM, Type As %String = "PERSON")
{
    s Job=$J
    s PreIADM=$P(PreIADM,"^",1)
    k ^TempDHCPE(Job,PreIADM)
    s ItemDesc="",SetDesc=""
    s ItemSub=0
    s SetSub=0
    i Type'="PERSON"{
        f  s ItemSub=$O(^DHCPEPreGADM(+PreIADM,"Team",$P(PreIADM,"||",2),"ORDITEM",ItemSub)) q:ItemSub=""  d
        .s Stat=$p(^DHCPEPreGADM(+PreIADM,"Team",$P(PreIADM,"||",2),"ORDITEM",ItemSub),"^",13)
        .q:Stat'="1"
        .s ArcimID=$p(^DHCPEPreGADM(+PreIADM,"Team",$P(PreIADM,"||",2),"ORDITEM",ItemSub),"^",1)
        .q:ArcimID=""
        .s ^TempDHCPE(Job,PreIADM,"HadItem",ArcimID)=""
        .s ArcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ArcimID)
        .s ^TempDHCPE(Job,PreIADM,"ItemDesc",ArcimDesc)=""
        f  s SetSub=$O(^DHCPEPreGADM(+PreIADM,"Team",$P(PreIADM,"||",2),"ORDENT",SetSub)) q:SetSub=""  d
        .s Stat=$p(^DHCPEPreGADM(+PreIADM,"Team",$P(PreIADM,"||",2),"ORDENT",SetSub),"^",7)
        .q:Stat'="1"
        .s SetID=$p(^DHCPEPreGADM(+PreIADM,"Team",$P(PreIADM,"||",2),"ORDENT",SetSub),"^",1)
        .s SetDesc=$p($g(^ARCOS(SetID)),"^",2)
        .s ^TempDHCPE(Job,PreIADM,"SetDesc",SetDesc)=""
        .d ..OtherSetDesc(Job,PreIADM,SetID)
    }else{
        f  s ItemSub=$O(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)) q:ItemSub=""  d
        .s Stat=$p($G(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)),"^",16)
        .q:Stat'="1"
        .s ArcimID=$p(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",1)
        .q:ArcimID=""
        .s IsAddItem=..IsAddItem(PreIADM,ItemSub)
        .s ^TempDHCPE(Job,PreIADM,"HadItem",ArcimID)=""
        .s ArcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ArcimID)
        .s ^TempDHCPE(Job,PreIADM,"ItemDesc",ArcimDesc)=IsAddItem
        f  s SetSub=$O(^DHCPEPreIADM(PreIADM,"ORDENT",SetSub)) q:SetSub=""  d
        .s Stat=$p($G(^DHCPEPreIADM(PreIADM,"ORDITEM",SetSub)),"^",9)
        .q:Stat'="1"
        .s SetID=$p(^DHCPEPreIADM(PreIADM,"ORDITEM",SetSub),"^",1)
        .s SetDesc=$p($g(^ARCOS(SetID)),"^",2)
        .s ^TempDHCPE(Job,PreIADM,"SetDesc",SetDesc)=""
        .d ..OtherSetDesc(Job,PreIADM,SetID)
    }
    s Desc=""
    f  s Desc=$O(^TempDHCPE(Job,PreIADM,"ItemDesc",Desc)) q:Desc=""  d
    .s AddItem=$G(^TempDHCPE(Job,PreIADM,"ItemDesc",Desc))
    .i ItemDesc="" d
    ..s ItemDesc=Desc_$C(2)_AddItem
    .e  d
    ..s ItemDesc=ItemDesc_"^"_Desc_$C(2)_AddItem
    s Desc=""
    f  s Desc=$O(^TempDHCPE(Job,PreIADM,"SetDesc",Desc)) q:Desc=""  d
    .i SetDesc="" d
    ..s SetDesc=Desc
    .e  d
    ..s SetDesc=SetDesc_"^"_Desc
    k ^TempDHCPE(Job,PreIADM)
    q ItemDesc_$C(1)_SetDesc
}

ClassMethod OtherSetDesc(Job, PreIADM, SetID)
{
    s HadFlag=1
    s SetDesc=$p($g(^ARCOS(SetID)),"^",2)
    s today=+$h
    s dateChildId="0"
    s Flag=0
    f  s dateChildId=$o(^ARCOS(SetID,"DATE",dateChildId))  q:dateChildId=""  d
    .set strData=^ARCOS(SetID,"DATE",dateChildId)
    .q:(($p(strData,"^",1)>today)&&($p(strData,"^",2)<today))
    .s itemChildId="0"
    .f  s itemChildId=$o(^ARCOS(SetID,"DATE",dateChildId,"ITM",itemChildId))  q:itemChildId=""  d
    ..s myItemId=$p($g(^ARCOS(SetID,"DATE",dateChildId,"ITM",itemChildId)),"^",1)
    ..i '$D(^TempDHCPE(Job,PreIADM,"HadItem",myItemId)) s HadFlag=0
    .s SetsSub="0"
    .f  s SetsSub=$o(^ARCOS(SetID,"DATE",dateChildId,"OS",SetsSub))  q:SetsSub=""  d
    ..s SetsID=$p($g(^ARCOS(SetID,"DATE",dateChildId,"OS",SetsSub)),"^",1)
    ..s Flag=..OtherSetDesc(Job,PreIADM,SetsID)
    ..s:Flag=0 HadFlag=0
    s:Flag=1 ^TempDHCPE(Job,PreIADM,"SetDesc",SetDesc)=""
    q HadFlag
}

// 1是  0不是

ClassMethod IsSameFeeType(AdmId, AdmType, ItemSetId)
{
    ;w ##class(web.DHCPE.PreItemList).IsSameFeeType("764","PERSON","4211")
    s ItemFeeType=$G(^DHCPEDataEx("OrdSetsEx","SpecialItem",ItemSetId))
    q:ItemFeeType="" "1^"
    i AdmType="PERSON" d
    .s CurFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",AdmId))
    e  d
    .s CurFeeType=$G(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",AdmId))
    i CurFeeType'=ItemFeeType q 0_"^"_ItemFeeType
    q "1^"
}

ClassMethod ChangeFeeType(AdmId, AdmType, FeeType)
{
    i AdmType="PERSON" d
    .s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",AdmId)=FeeType
    .i FeeType'="" d
    ..s VIPLevel=$G(^DHCPEVIPLevelI(FeeType))
    ..s:VIPLevel'="" $P(^DHCPEPreIADM(AdmId),"^",18)=VIPLevel
    .d ##class(web.DHCPE.PreIADM).SetPersonADMFeeType(AdmId, FeeType)
    e  d
    .s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",AdmId)=FeeType
    .i FeeType'="" d
    ..s VIPLevel=$G(^DHCPEVIPLevelI(FeeType))
    ..s:VIPLevel'="" ^DHCPECBVIPLevel("PGT",AdmId)=VIPLevel
    .d ##class(web.DHCPE.PreIADM).SetGTADMFeeType(AdmId, FeeType)
    .s PIADMRowId=0
    .f  s PIADMRowId=$o(^DHCPEPreIADM(0,"PGTeam",AdmId,PIADMRowId)) q:PIADMRowId=""  d
    ..d ..ChangeFeeType(PIADMRowId, "PERSON", FeeType)
    q 0
}

ClassMethod GetAllowAddItemST(ArcItemId, AdmType, AdmId)
{
    s flag=0
    i ("TEAM"=AdmType) d
    .s sub=0
    .f  s sub=$o(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDITEM",sub)) q:(sub="")  d
    ..s status=$p($g(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDITEM",sub)),"^",16)
    ..q:(status'=1)
    ..s MastDr=$p($g(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDITEM",sub)),"^",1)
    ..q:MastDr'=ArcItemId
    ..s StationID=$o(^DHCPEST(0,"STORD_ARCIM",MastDr,0))
    ..i $G(^DHCPESetting("DHCPE","AllowAddItem"))[StationID  s flag=1
    ..q:(flag=1)
    
    i ("PERSON"=AdmType) d
    .s sub=0
    .f  s sub=$o(^DHCPEPreIADM(AdmId,"ORDITEM",sub)) q:sub=""  d
    ..s status=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",sub)),"^",16)
    ..q:(status'=1)
    ..s MastDr=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",sub)),"^",1)
    ..q:MastDr'=ArcItemId
    ..s StationID=$o(^DHCPEST(0,"STORD_ARCIM",MastDr,0))
    ..i $G(^DHCPESetting("DHCPE","AllowAddItem"))[StationID  s flag=1
    ..q:flag=1

    q flag
}

/// Description: 自转公药品是否可转
/// Input: 
/// OTput:       1 不允许
/// debug: w ##class(web.DHCPE.PreItemList).ChangePhcItem("284||14^ORDITEM^G")
ClassMethod ChangePhcItem(ItemInfo)
{
	//s ^tempdhcpe("ChangePhcItem")=ItemInfo
	s flag=0
	s ItemId=$P(ItemInfo,"^",1)
	s AdmId=+ItemId
	s PGTeamDR=$P($g(^DHCPEPreIADM(AdmId)),"^",3)
    s LocID=$P($g(^DHCPEPreIADM(AdmId)),"^",26)
    s AddPhcItem=$p($g(^DHCPEPreIADM(AdmId)),"^",13)
    i (ItemId'="")&&(AddPhcItem="N")&&(PGTeamDR'="") d
    .s ArcitmID=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",$p(ItemId,"||",2))),"^",1)
    .s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcitmID,LocID)
    .s STRowId=""
    .i StatOrderDR'="" s STRowId=$p(StatOrderDR,"||",1)
    .s STDesc=""
    .i STRowId'="" s STDesc=$p($g(^DHCPEST(STRowId)),"^",2)
    .i STDesc["药品" s flag=1
    q flag
}

/// Description: 是否允许加药
/// Input:       AdmId：预约ID, AdmType:就诊类型，ItemId:医嘱项ID
/// OTput:       1/0: 不允许/允许
/// debug: w ##class(web.DHCPE.PreItemList).IsAddPhcItem()
ClassMethod IsAddPhcItem(AdmId, AdmType, ItemId As %Library.String = "", PreOrAdd, SetID As %Library.String = "")
{
    //s ^tempdhcpe("IsAddPhcItem")=$lb(AdmId, AdmType, ItemId, PreOrAdd,SetID)
    s flag=0,STDesc="",STRowId=""

    s AddPhcItem="N"
    i ("PERSON"=AdmType) d
    .s PGTeamDR=$p($g(^DHCPEPreIADM(AdmId)),"^",3)
    .s LocID=$P($g(^DHCPEPreIADM(AdmId)),"^",26)
    .i (PGTeamDR'="")&&(PreOrAdd="PRE") d
    ..s AddPhcItem=$p($g(^DHCPEPreIADM(AdmId)),"^",13)
    ..i AddPhcItem="N" D
    ...i ItemId'="" d
    ....;s STRowId=$o(^DHCPEST(0,"STORD_ARCIM",ItemId,""))
    ..../***多院区 start***/
    ....s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemId,LocID)
    ....i StatOrderDR'="" s STRowId=$p(StatOrderDR,"||",1)
    ....s STDesc=""
    ..../***多院区 end***/
    ....i STRowId'="" s STDesc=$p($g(^DHCPEST(STRowId)),"^",2)
    ....i STDesc["药品" s flag=1
    ...e  d
    ....s flag=##class(web.DHCPE.PreItemList).IsExsitPhcInSet(SetID)
    
    i ("TEAM"=AdmType)&&(PreOrAdd="PRE") d
    .s AddPhcItem=$p($g(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2))),"^",9)
    .s LocID=$p($g(^DHCPEPreGADM($p(AdmId,"||",1))),"^",23)
    .i AddPhcItem="N" D
    ..i ItemId'="" d
    ...;s STRowId=$o(^DHCPEST(0,"STORD_ARCIM",ItemId,""))
    .../***多院区 start***/
    ...s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemId,LocID)
    ...i StatOrderDR'="" s STRowId=$p(StatOrderDR,"||",1)
    ...s STDesc=""
    .../***多院区 end***/
    ...i STRowId'="" s STDesc=$p($g(^DHCPEST(STRowId)),"^",2)
    ...i STDesc["药品" s flag=1
    ..e  d
    ...s flag=##class(web.DHCPE.PreItemList).IsExsitPhcInSet(SetID)
    
    q flag
}

/// Description: 判断套餐是否包含药品医嘱项
/// Input: SetId：套餐ID 
/// OTput: 1 包含
/// debug: w ##class(web.DHCPE.PreItemList).IsExsitPhcInSet(184)
ClassMethod IsExsitPhcInSet(SetID As %Library.String = "")
{
    s SetFlag=0
    //获取套餐中的项目
    s itemIds=##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(SetID)
    q:itemIds="" ""
    ;b ;itemIds
    s ItemLength=$l(itemIds,"^") 
    for i=1:1:ItemLength {
        S ItemID=$P(itemIds,"^",i)
        s STRowId=$o(^DHCPEST(0,"STORD_ARCIM",ItemID,""))
        i STRowId'="" s STDesc=$p($g(^DHCPEST(STRowId)),"^",2)
        i STDesc["药品" s SetFlag=1 
        q:SetFlag=1 
    }
    q SetFlag
}

ClassMethod IGetGZAmount(AdmId As %Library.String = "", AdmType As %Library.String = "", IsSave As %String = "0")
{
    s AdmId=$p(AdmId,"^",1) 
    q:((AdmId="")||(AdmType="")) 0
    s retVal=0
    //个人的应收金额
    i (AdmType="PERSON") d 
    .s retVal=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(AdmId)
    .s Amount=$p(retVal,"^",2) 
    .S ZFAmount=0,PARowId=0
    .s PGeamID=$P($G(^DHCPEPreIADM(AdmId)),"^",3)
    .I PGeamID'=""  d
    ..f  s PARowId=$o(^DHCPEPreA(0,"CRMADM","I",AdmId,PARowId)) q:PARowId=""  d
    ...s PAStatus=$p($g(^DHCPEPreA(PARowId)),"^",21) //PA_Status U-Use有效 NU-NoUse无效
    ...q:PAStatus="NU"
    ...s PAType=$p(^DHCPEPreA(PARowId),"^",20)
    ...;q:PAType'="ADD"  //统结转换自结类型是Pre
    ...s ZFAmount=ZFAmount+$p(^DHCPEPreA(PARowId),"^",9)
    ..s Amount="公费:"_""_(Amount-ZFAmount)_", "_"自费:"_""_ZFAmount
    ..//s Amount="自费:"_""_ZFAmount
    .e  d
    ..s Amount="公费:"_""_ZFAmount_", "_"自费:"_""_(Amount-ZFAmount)
    ..//s Amount="自费:"_""_(Amount-ZFAmount)

    //团体组的应收金额
    i (AdmType="TEAM") d 
    .s retVal=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Team(AdmId)
    .s Amount=$p(retVal,"^",2) 
    .S ZFAmount=0
    .s iAdmId="0"
    .f  s iAdmId=$o(^DHCPEPreIADM(0,"PGTeam",AdmId,iAdmId)) q:iAdmId=""  d
    ..S PARowId=0
    ..f  s PARowId=$o(^DHCPEPreA(0,"CRMADM","I",iAdmId,PARowId)) q:PARowId=""  d
    ...s PAStatus=$p($g(^DHCPEPreA(PARowId)),"^",21) //PA_Status U-Use有效 NU-NoUse无效
    ...q:PAStatus="NU"
    ...s PAType=$p(^DHCPEPreA(PARowId),"^",20)
    ...q:PAType'="ADD"
    ...s ZFAmount=ZFAmount+$p(^DHCPEPreA(PARowId),"^",9)
    .s Amount=""  
    .//s Amount="公费:"_""_(Amount-ZFAmount)_", "_"自费:"_""_ZFAmount


    i (AdmType="GROUP") d //团体的应收金额
    .s retVal=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Grp(AdmId)
    .s Amount=$p(retVal,"^",2) 
    .s ZFAmount=0
    .s iAdmId="0"
    .f  s iAdmId=$o(^DHCPEPreIADM(0,"PGADM",AdmId,iAdmId)) q:iAdmId=""   d
    ..S PARowId=0
    ..f  s PARowId=$o(^DHCPEPreA(0,"CRMADM","I",iAdmId,PARowId)) q:PARowId=""  d
    ...s PAStatus=$p($g(^DHCPEPreA(PARowId)),"^",21) //PA_Status U-Use有效 NU-NoUse无效
    ...q:PAStatus="NU"
    ...s PAType=$p(^DHCPEPreA(PARowId),"^",20)
    ...q:PAType'="ADD"
    ...s ZFAmount=ZFAmount+$p(^DHCPEPreA(PARowId),"^",9)
    .//s Amount="自费:"_""_ZFAmount_", "_"公费:"_""_(Amount-ZFAmount)
    .//s Amount="公费:"_""_(Amount-ZFAmount)_","_"自费:"_""_ZFAmount
    .s Amount=""
    q Amount
}

/// 判断医嘱套的性别和个人、分组的性别是都一致
/// w ##class(web.DHCPE.PreItemList).IsSetSex("18241","PERSON","17398||1")
ClassMethod IsSetSex(AdmId As %Library.String = "", AdmType As %Library.String = "", ItemSetId As %Library.String = "")
{
    s SetSex=""
    s ret=0
    i ("PERSON"=AdmType) d
    .s PreIBI=$P(^DHCPEPreIADM(AdmId),"^",1)
    .s SexDR=$P(^DHCPEPreIBI(PreIBI),"^",3)
    .S SetSex=$g(^DHCPEDataEx("DHCPEBaseData","Sex",ItemSetId))
    .i (SetSex'="")&&(SexDR'=SetSex) d
    ..s ret="1^"_"客户性别与套餐维护的性别不符"
    i ("TEAM"=AdmType) d
    .s PGTSex=$P(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2)),"^",12)
    .i PGTSex="F" s PGTSex="女"
    .i PGTSex="M" s PGTSex="男"
    .i PGTSex="N" s PGTSex="不限"
    .S SetSexID=$g(^DHCPEDataEx("DHCPEBaseData","Sex",ItemSetId))
    .i SetSexID'="" S SetSex=$P($G(^CT("SEX",SetSexID)),"^",2)
    .i ((PGTSex'="不限")&&(SetSex'=PGTSex)&&((SetSex'=""))) d
    ..s ret="1^"_"分组性别与套餐维护的性别不符"
    q ret
}

/// 判断客户和分组性别
/// w ##class(web.DHCPE.PreItemList).JustAdmSex(10889)
ClassMethod JustAdmSex(AdmId As %Library.String = "")
{
    q:AdmId="" ""
    s SetSex=""
    i $L(AdmId,"||")>1 d
    .s PGTSex=$P(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2)),"^",12)
    .i PGTSex="F" s SetSex="女"
    .i PGTSex="M" s SetSex="男"
    .i PGTSex="N" s SetSex=""
    e  d
    .s PreIBI=$P(^DHCPEPreIADM(AdmId),"^",1)
    .s SexDR=$P(^DHCPEPreIBI(PreIBI),"^",3)
    .i SexDR'="" S SetSex=$P($G(^CT("SEX",SexDR)),"^",2)
    .i ((SetSex'="男")&(SetSex'="女")) S SetSex=""
   
    q SetSex
}

/// Description:   判断客户性别、年龄是否与医嘱项维护的一致
/// Input:         AdmId(预约ID), AdmType(类型 "PERSON" 个人，"TEAM" 分组),ArcimID(医嘱项ID)
/// Return：       非0 不一致,0 一致
/// Debug:w ##class(web.DHCPE.PreItemList).JustArcItemInfo("1042","PERSON","11627||1")
ClassMethod JustArcItemInfo(AdmId As %Library.String = "", AdmType As %Library.String = "", ArcimID As %Library.String = "")
{
	s ^temp("DHCPE","JustArcItemInfo")=$LB(AdmId,AdmType,ArcimID)
	s flag=0
	i ("PERSON"=AdmType) {
    	s PreIBI=$P($g(^DHCPEPreIADM(AdmId)),"^",1)
    	s LocID=$P($g(^DHCPEPreIADM(AdmId)),"^",26)
    	s HospID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(LocID)
    	s RegNo=$p($g(^DHCPEPreIBI(PreIBI)),"^",1)
    	q:$o(^PAPERi("PAPMI_PatNo",RegNo,0))="" flag
        s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
    	//s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMIRowId,HospID,LocID)
    	//s SexDR=$P(^DHCPEPreIBI(PreIBI),"^",3)
    	//s flag=##class(web.DHCDocOrderCommon).GetItemAgeSexRestriction(ArcimID,SexDR,Age)	
    	s flag=##class(web.DHCDocOrderCommon).GetItemAgeSexRestriction(ArcimID,PAPMIRowId,HospID)  //imedical 9.0修改
	}elseif ("TEAM"=AdmType){
		
	}
	q flag
}

/// 判断站点和项目组合界面的条件
/// w ##class(web.DHCPE.PreItemList).ItemCanPreInfo("18241","PERSON","17398||1")
ClassMethod ItemCanPreInfo(AdmId As %Library.String = "", AdmType As %Library.String = "", ItemId As %Library.String = "")
{
     //s ^tempdhcpe("ItemCanPreInfo")=$lb(AdmId,AdmType,ItemId)B
    s $ZT="ItemCanPreInfoErr"
    s ret=0
    s flag=0
    
    s LocID=$P($g(^DHCPEPreIADM(AdmId)),"^",26)
    s OrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemId,LocID)
    q:OrderID="" "站点项目组合没对照数据！"
    s ID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,OrderID,0))
    q:ID="" "站点项目组合科室项目详情没维护！"
    s AgeMax=$lg($g(^CF.PE.StationOrderSetD(ID)),11) //年龄上限
    s AgeMin=$lg($g(^CF.PE.StationOrderSetD(ID)),12) //年龄下限
    s CanAge=AgeMin_"^"_AgeMax
    s CanMarried=$lg($g(^CF.PE.StationOrderSetD(ID)),10) //婚姻
    	

    i ("PERSON"=AdmType) d
    .s PreIBI=$P(^DHCPEPreIADM(AdmId),"^",1)
    .s IBIDOB=$P(^DHCPEPreIBI(PreIBI),"^",4)
    .s Age=##class(web.DHCLCNUREXCUTE).CalAge(IBIDOB,+$h)
    .s Age=$P(Age,"Y",1)
    .s Married=$P(^DHCPEPreIBI(PreIBI),"^",17)
    .;s CanAge=$G(^DHCPECTDataEx("DHCPEStationOrder","Age",ItemId))  //多院区改造前
    .i (""'=$P(CanAge,"^",1))&&(Age<$P(CanAge,"^",1)) d
    ..s ret=ret_","_"客户年龄小于维护的年龄下限"
    ..s flag=1
    .i (""'=$P(CanAge,"^",2))&&(Age>$P(CanAge,"^",2)) d
    ..s ret=ret_","_"客户年龄大于维护的年龄上限"
    ..s flag=1
    .;s CanMarried=$G(^DHCPECTDataEx("DHCPEStationOrder","Married",ItemId))  //多院区改造前
    .i (CanMarried'="")&&(CanMarried'=Married) d
    ..s ret=ret_","_"客户婚姻状况与项目维护的婚姻状况不符"
    ..s flag=1
    i ("TEAM"=AdmType) d
    .;s Married=$P(^DHCPEGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2)),"^",12)
    
    i flag=1 d
    .s $P(ret,",",1)="-1"
    .s ret=ret_","_"是否继续增加?"
    e  d
    .s $P(ret,",",1)="0"
    q ret
    
    
ItemCanPreInfoErr
    s $ZT=""
    q 0
}

/// 判断套餐是不是包含已经停止的医嘱，存在已经停止的医嘱不允许预约，需要修改套餐后进行预约
/// w ##class(web.DHCPE.PreItemList).IsExistARCSets("2904")
ClassMethod IsExistARCSets(SetId)
{
    q:SetId="" ""
    s ret=""
    s dateChildId=""
    f  s dateChildId=$o(^ARCOS(SetId,"DATE",dateChildId)) q:dateChildId=""  d
    .s itemChildId="0"
    .f  s itemChildId=$o(^ARCOS(SetId,"DATE",dateChildId,"ITM",itemChildId)) q:itemChildId=""  d
    ..s strDataItm=$g(^ARCOS(SetId,"DATE",dateChildId,"ITM",itemChildId))
    ..s myItemId=$p(strDataItm,"^",1)
    ..s myItemStr=$G(^ARCIM($p(myItemId,"||",1),$p(myItemId,"||",2),1))
    ..s ArcDesc=$P(myItemStr,"^",2)
    ..s StopDate=""
    ..s StopDate=$P($G(^ARCIM($p(myItemId,"||",1),$p(myItemId,"||",2),7)),"^",1)
    ..i ((StopDate'="")&&(StopDate<+$h)) d
    ...s ret=ret_""_ArcDesc
    q ret
}

/// function：判断是否存在重复的项目
/// w ##class(web.DHCPE.PreItemList).IsRepeatItem(897,148,"PERSON")
ClassMethod IsRepeatItem(AdmId As %Library.String = "", ArcItemSetId As %Library.String = "", AdmType As %Library.String = "")
{
    //s ^tempdhcpe("IsRepeatItem")=AdmId_"^"_ArcItemSetId_"^"_AdmType
    s SCOrdSetsID=$P(ArcItemSetId,"^",2)
    s ArcItemSetId=$P(ArcItemSetId,"^",1)
    s RepeatFlag=0
    s Temp=""
    //获取套餐中的项目
    s itemIds=##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(ArcItemSetId_"^"_SCOrdSetsID)
    ;b ;itemIds
    if (AdmType="PERSON") {
    i itemIds'="" d
    .s Temp=""
    .s itemIdStrs=""
    .s gub=0
    .f  s gub=$o(^DHCPEPreIADM(AdmId,"ORDITEM",gub)) q:gub=""  d
    ..s itemdr=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",gub)),"^",1)
    ..s status=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",gub)),"^",16)
    ..q:(status'=1)
    ..s:itemIdStrs'="" itemIdStrs=itemIdStrs_"^"_itemdr
    ..s:itemIdStrs="" itemIdStrs=itemdr
    .i itemIdStrs'="" d
    ..for i=1:1:$l(itemIds,"^") d
    ...s Item=$p(itemIds,"^",i)
    ...i itemIdStrs[Item d
    ....s:Temp'="" Temp=Temp_"^"_Item
    ....s:Temp="" Temp=Item
    
    }elseif(AdmType="TEAM"){
    
    s TeamAdmId=AdmId
    i itemIds'="" d
    .s Temp=""
    .s itemIdStrs=""
    .s gub=0
    .f  s gub=$o(^DHCPEPreGADM(+TeamAdmId,"Team",$p(TeamAdmId,"||",2),"ORDITEM",gub)) q:gub=""  d
    ..s itemdr=$p($g(^DHCPEPreGADM(+TeamAdmId,"Team",$p(TeamAdmId,"||",2),"ORDITEM",gub)),"^",1)
    ..s status=$p($g(^DHCPEPreGADM(+TeamAdmId,"Team",$p(TeamAdmId,"||",2),"ORDITEM",gub)),"^",13)
    ..q:(status'=1)
    ..s:itemIdStrs'="" itemIdStrs=itemIdStrs_"^"_itemdr
    ..s:itemIdStrs="" itemIdStrs=itemdr
    .i itemIdStrs'="" d
    ..for i=1:1:$l(itemIds,"^") d
    ...s Item=$p(itemIds,"^",i)
    ...i itemIdStrs[Item d
    ....s:Temp'="" Temp=Temp_"^"_Item
    ....s:Temp="" Temp=Item
    
    }
    i Temp'="" s RepeatFlag=1
    q RepeatFlag
}

/// function:获取接收科室
/// w ##class(web.DHCPE.PreItemList).GetOldRecLoc()
ClassMethod GetOldRecLoc(PreItem, Type)
{
    s RecLoc=""
    i Type="TEAM" {
        s RecLoc=$p($g(^DHCPEPreGADM(+PreItem,"Team",$p(PreItem,"||",2),"ORDITEM",$p(PreItem,"||",3))),"^",14)
    }else{
        s RecLoc=$p($g(^DHCPEPreIADM(+PreItem,"ORDITEM",$p(PreItem,"||",2))),"^",17)
    }
    q RecLoc
}

/// function:获取标本信息
/// w ##class(web.DHCPE.PreItemList).GetOldSpec()
ClassMethod GetOldSpec(PreItem, Type)
{
    s Spec=""
    i Type="TEAM" {
        s Spec=$g(^DHCPEDataEx("DHCPEPreIOrdItem","TEAM",PreItem))
    }else{
        s Spec=$g(^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",PreItem))
    }
    q Spec
}

/// function :验证新增项目是否和预约的项目排斥
/// dubug: w ##class(web.DHCPE.PreItemList).IsExistExcludeItem()
ClassMethod IsExistExcludeItem(AdmId As %Library.String = "", AdmType As %Library.String = "", ArcItemId As %Library.String = "")
{
    s ExcludeFlag=0
    
    i "TEAM"=AdmType d
    .s TSub=0
    .f  s TSub=$o(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDITEM",TSub)) q:(TSub="")||(ExcludeFlag=1)  d
    ..S ItmMastDR=$p($g(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDITEM",TSub)),"^",1)
    ..s ItemStat=$p($g(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDITEM",TSub)),"^",13)
    ..q:ItemStat="4"
    ..s ADMLocID=$P($g(^DHCPEPreGADM(+AdmId)),"^",23)
    ..S ExcludeFlag=##class(web.DHCPE.CT.ExcludeArcItem).IsExcludeArcItem(ArcItemId,ItmMastDR,ADMLocID)
    i "PERSON"=AdmType d
    .s Sub=0
    .f  s Sub=$o(^DHCPEPreIADM(AdmId,"ORDITEM",Sub)) q:(Sub="")||(ExcludeFlag=1)  d
    ..S ItmMastDR=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",Sub)),"^",1)
    ..s ItemStat=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",Sub)),"^",16)
    ..q:ItemStat="4"
    ..s ADMLocID=$p($g(^DHCPEPreIADM(AdmId)),"^",26)
    ..S ExcludeFlag=##class(web.DHCPE.CT.ExcludeArcItem).IsExcludeArcItem(ArcItemId,ItmMastDR,ADMLocID)
    q ExcludeFlag
}

/// function : 获取项目或套餐是不是能够增加限额 --预约公费
/// dubug: w ##class(web.DHCPE.PreItemList).GetAddAmountFlag()
ClassMethod GetAddAmountFlag(Type As %String = "", OrdItemId As %String = "", OrdEntId As %String = "")
{
    Quit:(OrdItemId="")&(OrdEntId="")
    
    If OrdItemId'="" Do
    .Set ItemType="OrdItem"
    .Set ItemID=OrdItemId
    Else  Do
    .Set ItemType="OrdEnt"
    .Set ItemID=OrdEntId
    s Flag=0
    if Type="TEAM"
    {
       s Flag=1
    }
    elseif Type="PERSON"
    {
        s PreOrAdd=""
        i ItemType="OrdItem" d
        .s PreOrAdd=$p(^DHCPEPreIADM(+ItemID,"ORDITEM",$p(ItemID,"||",2)),"^",15)
        .i PreOrAdd="PRE" s Flag=1
        
        i ItemType="OrdEnt" d
        .s PreOrAdd=$p(^DHCPEPreIADM(+ItemID,"ORDENT",$p(ItemID,"||",2)),"^",8)
        .i PreOrAdd="PRE" s Flag=1
        
        
    }
    q Flag
}

/// Creator：	  xy
/// CreatDate：	  20220823
/// Description:  修改预约项目的药品附加信息
/// Input:        PreOrdItemID(预约项目ID),DrugInfo(药品附加信息)
/// Return：      0
/// Debug:w ##class(web.DHCPE.PreItemList).UpdateDrugByPreItem()
ClassMethod UpdateDrugByPreItem(PreOrdItemID As %String = "", DrugInfo As %String = "")
{
	q:(PreOrdItemID="") "0"
	s $P(^DHCPEPreIADM(+PreOrdItemID,"ORDITEM",$P(PreOrdItemID,"||",2)),"^",28)=$p(DrugInfo,"^",1)   //单次剂量 
    s $P(^DHCPEPreIADM(+PreOrdItemID,"ORDITEM",$P(PreOrdItemID,"||",2)),"^",29)=$p(DrugInfo,"^",2)   //单次剂量单位
    s $P(^DHCPEPreIADM(+PreOrdItemID,"ORDITEM",$P(PreOrdItemID,"||",2)),"^",30)=$p(DrugInfo,"^",3)   //频次指针
    s $P(^DHCPEPreIADM(+PreOrdItemID,"ORDITEM",$P(PreOrdItemID,"||",2)),"^",31)=$p(DrugInfo,"^",4)   //疗程指针
    s $P(^DHCPEPreIADM(+PreOrdItemID,"ORDITEM",$P(PreOrdItemID,"||",2)),"^",32)=$p(DrugInfo,"^",5)   //用法指针
    q 0
}

}

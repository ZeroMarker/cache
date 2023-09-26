Class web.DHCPE.PreItemList2 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*
需要修改根据医嘱项id，获取打折不打折的方法GetDiscountFlag
*/

// 插入分组项目

// w ##class(web.DHCPE.PreItemList2).IInsertItem("309||2","TEAM","PRE","4724||1","",11849,0)

// 插入个人项目

// w ##class(web.DHCPE.PreItemList2).IInsertItem("1||1","TEAM","PRE","","3774",11849)

// 分组里面加入人员 第二个参数为空 第四个参数是分组ID

// w ##class(web.DHCPE.PreItemList2).IInsertItem("11615","","PRE","309||3","",11849)

// ^DHCPESetting("DHCPE","GetCurrentPrice",LocID)="Y"  //Y:使用当前价格  非Y:使用分组预约时的价格

// ^DHCPESetting("DHCPE","GetGAuditByTeam",LocID)="Y"  //Y:根据分组生成审核记录  非Y:不根据分组生成审核记录

/// Description: 体检预约表插入医嘱
/// Debug: w ##class(web.DHCPE.PreItemList2).IInsertItem("2502","PERSON","PRE","2585||1","","12187","")
ClassMethod IInsertItem(AdmId As %Library.String = "", AdmType As %Library.String = "", PreOrAdd As %Library.String = "", ArcItemId As %Library.String = "", ArcItemSetId As %Library.String = "", UpdateUserId As %Library.String = "", SeleAuditRowid As %String = "", RepeatFlag As %String = "", DrugInfo As %String = "", OEOrdQty As %String = "1", OEOrdRecLocID As %String = "") As %String
{
	s ^TempDHCPEInserItem("IInsertItem")=$lb(AdmId,AdmType,PreOrAdd,ArcItemId,ArcItemSetId,UpdateUserId,SeleAuditRowid,RepeatFlag,DrugInfo,OEOrdQty,OEOrdRecLocID)
	n (AdmId,AdmType,PreOrAdd,ArcItemId,ArcItemSetId,UpdateUserId,%session,SeleAuditRowid,RepeatFlag,DrugInfo,OEOrdQty,OEOrdRecLocID)
	s roundingfee=""
	i $l(ArcItemId,"^")=1{
        s roundingfee=$p(ArcItemId,"&",2)
        s RoundType=$p(ArcItemId,"&",3)
        s RoundRemark=$p(ArcItemId,"&",4)
        s ArcItemId=$p(ArcItemId,"&",1)
            
         i ((AdmType="PERSON")&&(ArcItemSetId="")&&(roundingfee="")){
	        s LocID=$P($g(^DHCPEPreIADM(AdmId)),"^",26)
        	s PIBISexDR="",PIBIRegNo = ""
        	s PIADMPIBIDR=$p($g(^DHCPEPreIADM(AdmId)),"^",1)
        	i PIADMPIBIDR'="" s PIBISexDR=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",3) 
            s Sex=""
        	s SetInfo=$G(^DHCPESetting("DHCPE","DefPatientType",LocID))
        	s OrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcItemId,LocID)
        	s ID=""
        	i (OrderID'="") d
        	.s ID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,OrderID,0))
        	.i ID'="" d
        	..s Sex=$lg($g(^CF.PE.StationOrderSetD(ID)),9)
        	
       	 	q:(ID'="")&&(PIBISexDR =$P(SetInfo,"^",3))&&(Sex=$P(SetInfo,"^",4)) "客户性别与医嘱项性别不一致！" 
        	q:(ID'="")&&(PIBISexDR =$P(SetInfo,"^",4))&&(Sex=$P(SetInfo,"^",3)) "客户性别与医嘱项性别不一致！" 
        }
         

        
    }
	//s $ZT="IInsertItemErr"
	s TStartFlag=0
	i ArcItemSetId'=""{
		s arcdata=$g(^ARCOS(ArcItemSetId))
		i arcdata="" q "套餐ID不对"
		s datefrom=$p(arcdata,"^",15)
		if datefrom'=""
		{
			s datefrom=+datefrom
			if (+datefrom>+$h) q "套餐还未启用"
		}
		s dateto=$p(arcdata,"^",16)
		i ((dateto'="")&&(dateto<+$h)) q "套餐已经停用"
		s ItemInfo=..GetItemInfoBySetsID(ArcItemSetId,AdmId)
		q:ItemInfo="" "套餐没有使用的项目"
		
		
		/// 过滤套餐中已有的项目  start
		i (RepeatFlag="1"){
		s itemIds=$P(ItemInfo,$C(0),2)
		i itemIds'="" d
		.s Temp=""
		.s itemIdStrs=""
		.i (AdmType="PERSON") d
		..s gub=0
		..f  s gub=$o(^DHCPEPreIADM(AdmId,"ORDITEM",gub)) q:gub=""  d
		...s itemdr=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",gub)),"^",1)
		...s status=$p($g(^DHCPEPreIADM(AdmId,"ORDITEM",gub)),"^",16)
		...q:(status'=1)
		...s:itemIdStrs'="" itemIdStrs=itemIdStrs_"^"_itemdr
		...s:itemIdStrs="" itemIdStrs=itemdr
		.e  i (AdmType="TEAM") d
		..s gub=0
		..f  s gub=$o(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDITEM",gub)) q:gub=""  d
		...s itemdr=$p($g(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDITEM",gub)),"^",1)
		...s status=$p($g(^DHCPEPreGADM($p(AdmId,"||",1),"Team",$p(AdmId,"||",2),"ORDITEM",gub)),"^",13)
		...q:(status'=1)
		...s:itemIdStrs'="" itemIdStrs=itemIdStrs_"^"_itemdr
		...s:itemIdStrs="" itemIdStrs=itemdr
		.i itemIdStrs'="" d
		..for i=1:1:$l(itemIds,$c(1)) d
		...s Itemstr=$p(itemIds,$c(1),i)
		...s Item=$p(Itemstr,"^",1)
		...i itemIdStrs'[Item d
		....s:Temp'="" Temp=Temp_$c(1)_$p(itemIds,$c(1),i)
		....s:Temp="" Temp=$p(itemIds,$c(1),i)
		..s itemIds=Temp
		q:itemIds="" "套餐中重复的项目已全部删除，没有可添加的项目！"
	    s $P(ItemInfo,$C(0),2)=itemIds
	   
	   /// 过滤套餐中已有的项目  end
		}
	}
	s CurDate=+$H
	s CurTime=$P($H,",",2)
	s SQLCODE=0
	TSTART
	s TStartFlag=1
	//个人
	i (AdmType="PERSON"){
		s LocID=$P($g(^DHCPEPreIADM(AdmId)),"^",26)
		s GetCurrentPrice=$g(^DHCPESetting("DHCPE","GetCurrentPrice",LocID))
		s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",AdmId))
		s HospID=$P($g(^CTLOC(LocID)),"^",22)
		i ArcItemSetId'=""{  //套餐
			s SetsPrice=$P(ItemInfo,$C(0),1)
			s SetsItemIDs=$P(ItemInfo,$C(0),2)
			d InsertPersonSets(AdmId,ArcItemSetId,"",SetsPrice,SetsItemIDs,PreOrAdd)
		}else{  //个人项目
			//项目ID^数量^价格^分组项目ID...
			//s LocID=$P(^DHCPEPreIADM(AdmId),"^",26)
			//s ItemPrice=..GetItemPrice(ADMFeeType, LocID, ArcItemId)
			i roundingfee'="" s ItemPrice=roundingfee
			e  s ItemPrice=..GetItemPrice(ADMFeeType, LocID, ArcItemId,AdmId)
			//s SetsItemIDs=ArcItemId_"^1^"_ItemPrice
			s SetsItemIDs=ArcItemId_"^"_OEOrdQty_"^"_ItemPrice
			d InsertPersonItem(AdmId,"","",SetsItemIDs,PreOrAdd)
		}	
	}elseif (AdmType="TEAM"){  //分组项目
		s LocID=$P($g(^DHCPEPreGADM(+AdmId)),"^",23)
		s GetCurrentPrice=$g(^DHCPESetting("DHCPE","GetCurrentPrice",LocID))
		s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",AdmId))
		s HospID=$P($g(^CTLOC(LocID)),"^",22)
		i ArcItemSetId'=""{  //套餐
			s SetsPrice=$P(ItemInfo,$C(0),1)
			s SetsItemIDs=$P(ItemInfo,$C(0),2)
			d InsertTeamSets(AdmId,ArcItemSetId,SetsPrice,SetsItemIDs,PreOrAdd)
		}else{  //分组项目
			//项目ID^数量^价格^分组项目ID...
			//s LocID=$P(^DHCPEPreGADM(+AdmId),"^",23)
			s ItemPrice=..GetItemPrice(ADMFeeType, LocID, ArcItemId)
			//s SetsItemIDs=ArcItemId_"^1^"_ItemPrice
			s SetsItemIDs=ArcItemId_"^"_OEOrdQty_"^"_ItemPrice
			d InsertTeamItem(AdmId,"","",SetsItemIDs,PreOrAdd)
		}	
	}else{  //向分组里面增加人员
		s TeamID=ArcItemId
		s PreGADM=+TeamID
		s TeamSub=$P(TeamID,"||",2)
		s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",AdmId))
		s LocID=$P($g(^DHCPEPreIADM(AdmId)),"^",26)
		s GetCurrentPrice=$g(^DHCPESetting("DHCPE","GetCurrentPrice",LocID))
		s HospID=$P($g(^CTLOC(LocID)),"^",22)
		s SQLCODE=0
		//插入套餐
		s EntSub=0
		f  s EntSub=$O(^DHCPEPreGADM(PreGADM,"Team",TeamSub,"ORDENT",EntSub)) q:(EntSub="")||(SQLCODE'=0)  d
		.s EntStat=$P($g(^DHCPEPreGADM(PreGADM,"Team",TeamSub,"ORDENT",EntSub)),"^",7)
		.q:EntStat'="1"
		.s SetsPrice=$P($g(^DHCPEPreGADM(PreGADM,"Team",TeamSub,"ORDENT",EntSub)),"^",6)
		.s SetsItemIDs=""
		.s TeamSetsID=TeamID_"||"_EntSub
		.s SetsID=$P($g(^DHCPEPreGADM(PreGADM,"Team",TeamSub,"ORDENT",EntSub)),"^",1)
		.s PreOrAdd=$P($g(^DHCPEPreGADM(PreGADM,"Team",TeamSub,"ORDENT",EntSub)),"^",10)
        .i PreOrAdd="" s PreOrAdd="PRE"
		.s EntItemSub=0
		.f  s EntItemSub=$O(^DHCPEPreGADM(0,"OrdEnt",TeamSetsID,PreGADM,TeamSub,EntItemSub)) q:(EntItemSub="")  d
		..s ItemStat=$P($g(^DHCPEPreGADM(PreGADM,"Team",TeamSub,"ORDITEM",EntItemSub)),"^",13)
		..q:ItemStat'="1"
		..s ArcItemID=$P($g(^DHCPEPreGADM(PreGADM,"Team",TeamSub,"ORDITEM",EntItemSub)),"^",1)
		..i GetCurrentPrice="Y" d
		...s ItemPrice=..GetItemPrice(ADMFeeType, LocID, ArcItemID) //按当前价格
		..e  d
		...s ItemPrice=$P($g(^DHCPEPreGADM(PreGADM,"Team",TeamSub,"ORDITEM",EntItemSub)),"^",11)
		..s TeamItemID=TeamID_"||"_EntItemSub
		..s Qty=$g(^DHCPEDataEx("DHCPEPreGTOrdItem","Qty",TeamItemID))
		..s OneItemInfo=ArcItemID_"^"_Qty_"^"_ItemPrice_"^"_TeamItemID
		..i SetsItemIDs="" d
		...s SetsItemIDs=OneItemInfo
		..e  d
		...s SetsItemIDs=SetsItemIDs_$C(1)_OneItemInfo
		.q:SetsItemIDs=""
		.d InsertPersonSets(AdmId,SetsID,TeamSetsID,SetsPrice,SetsItemIDs,PreOrAdd)
		i SQLCODE'=0{
			TROLLBACK
			q "插入人员套餐失败:"_SQLCODE
		}
		s EntItemSub=0
		f  s EntItemSub=$O(^DHCPEPreGADM(PreGADM,"Team",TeamSub,"ORDITEM",EntItemSub)) q:(EntItemSub="")||(SQLCODE'=0)  d
		.s ItemStat=$P($g(^DHCPEPreGADM(PreGADM,"Team",TeamSub,"ORDITEM",EntItemSub)),"^",13)
		.q:ItemStat'="1"
		.s TeamSetsID=$P($g(^DHCPEPreGADM(PreGADM,"Team",TeamSub,"ORDITEM",EntItemSub)),"^",2)
		.q:TeamSetsID'=""
		.s ArcItemID=$P($g(^DHCPEPreGADM(PreGADM,"Team",TeamSub,"ORDITEM",EntItemSub)),"^",1)
		.s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",PreGADM_"||"_TeamSub_"||"_EntItemSub))
		.i GetCurrentPrice="Y" d
		..s ItemPrice=..GetItemPrice(ADMFeeType, LocID, ArcItemID) //按当前价格
		.e  d
		..s ItemPrice=$P($g(^DHCPEPreGADM(PreGADM,"Team",TeamSub,"ORDITEM",EntItemSub)),"^",11)
		.s TeamItemID=TeamID_"||"_EntItemSub
		.s Qty=$g(^DHCPEDataEx("DHCPEPreGTOrdItem","Qty",TeamItemID))
		.s OneItemInfo=ArcItemID_"^"_Qty_"^"_ItemPrice_"^"_TeamItemID
		.s PreOrAdd=$P($g(^DHCPEPreGADM(PreGADM,"Team",TeamSub,"ORDITEM",EntItemSub)),"^",18)
        .i PreOrAdd="" s PreOrAdd="PRE"
		.d InsertPersonItem(AdmId,"","",OneItemInfo,PreOrAdd)
 	}
 	
 	i +SQLCODE=-9099{
	 	TROLLBACK
	 	q "操作失败:"_$P(SQLCODE,"^",2)
 	}
 	i SQLCODE'=0{
	 	TROLLBACK
	 	q "操作失败:"_SQLCODE
 	}
 	TCOMMIT
	q ""
IInsertItemErr
	s $ZT=""
	i TStartFlag="1" TROLLBACK
	q "发生异常:"_$ZERROR
InsertTeamSets(TeamID,SetsID,SetsPrice,SetsItemIDs,PreOrAdd)
	k TeamSetsLIST
	s TeamSetsLIST(0)=TeamID  //DHC_PE_PreGTeam分组ID
	s TeamSetsLIST(3)=SetsID  //套餐ID
	s TeamSetsLIST(4)=UpdateUserId  //PGTOE_UpdateUser_DR
	s TeamSetsLIST(5)=CurDate  //PGTOE_UpdateDate
	s TeamSetsLIST(6)=CurTime  //PGTOE_UpdateTime
	
	s GAuditInfo=..GetPARowId("G",TeamID,PreOrAdd,SeleAuditRowid,"")
	s GAuditID=+GAuditInfo
	s PrivilegeMode=$P($g(^DHCPEPreA(GAuditID)),"^",19)
	i PrivilegeMode="OR"{
		s Rebate=$P(GAuditInfo,"^",3)
		s FactAmt=$FN((SetsPrice*Rebate/100),"",2)
	}else{
		s FactAmt=SetsPrice
	}
	
	s TeamSetsLIST(7)=FactAmt  //PGTOE_FactAmount
	s TeamSetsLIST(8)=SetsPrice  //PGTOE_AccountAmount
	s TeamSetsLIST(9)="1"  //PGTOE_ItemStat
	s TeamSetsLIST(12)=PreOrAdd  //PGTOE_Type
	
	
	&SQL(Insert into SQLUser.DHC_PE_PreGTOrdEnt Values :TeamSetsLIST())
	q:SQLCODE'=0
	s TeamSetsID=%ROWID
	s ItemLength=$L(SetsItemIDs,$C(1))
	f Itemi=1:1:ItemLength {
		s OneItemInfo=$P(SetsItemIDs,$C(1),Itemi)
		s TeamItemID=$$InsertTeamItem(TeamID,SetsID,TeamSetsID,OneItemInfo,PreOrAdd)  //插入分组项目，不插入分组下每个人的项目
		q:SQLCODE'=0
		s $P(OneItemInfo,"^",4)=TeamItemID
		s $P(SetsItemIDs,$C(1),Itemi)=OneItemInfo
	}
	//插入分组下每个人的套餐（包括套餐内项目）信息
	s PIADM=0
	f  s PIADM=$O(^DHCPEPreIADM(0,"PGTeam",TeamID,PIADM)) q:(PIADM="")||(SQLCODE'=0)  d
	.s Status=$P($g(^DHCPEPreIADM(PIADM)),"^",8)
	.q:Status="CANCELPE"
	.d InsertPersonSets(PIADM,SetsID,TeamSetsID,SetsPrice,SetsItemIDs,PreOrAdd)
	.//w PIADM_","_SetsID_","_TeamSetsID_","_SetsPrice_","_SetsItemIDs_","_SQLCODE,!
	q:SQLCODE'=0 ""
	q TeamSetsID
	//增加分组项目
InsertTeamItem(TeamID,SetsID,TeamSetsID,SetsItemIDs,PreOrAdd)
	s AdmAsCharged=$P(^DHCPEPreGADM(+TeamID),"^",7)
	k TeamItemList
	s OneItemInfo=SetsItemIDs  //项目ID^数量^价格^分组项目ID...
	s TeamItemList(0)=TeamID
	s TeamItemList(3)=$P(OneItemInfo,"^",1)  //PGTOI_ItmMast_DR
	s TeamItemList(4)=TeamSetsID  //PGTOI_OrdEnt_DR
	s TeamItemList(5)=SetsID  //PGTOI_ARCOS_DR
	s ItemQty=$P(OneItemInfo,"^",2)
	s:+ItemQty=0 ItemQty=1
	s ItemPrice=$P(OneItemInfo,"^",3)
	s ItemAmt=$FN((ItemPrice*ItemQty),"",2)
	b ;TeamID
	s GAuditInfo=..GetPARowId("G",TeamID,PreOrAdd,SeleAuditRowid,TeamItemList(3))
	s GAuditID=+GAuditInfo
	s PrivilegeMode=$P($g(^DHCPEPreA(GAuditID)),"^",19)
	i PrivilegeMode="OR"{
		s Rebate=$P(GAuditInfo,"^",3)
		s FactAmt=$FN((ItemAmt*Rebate/100),"",2)
	}else{
		s FactAmt=ItemAmt
	}
	s TeamItemList(6)=FactAmt  //PGTOI_FactAmount
	s TeamItemList(7)=PrivilegeMode  //PGTOI_PrivilegeMode
	//s TeamItemList(8)=""  //PGTOI_Privilege
	s TeamItemList(9)=AdmAsCharged  //PGTOI_AsCharged
	s TeamItemList(10)=UpdateUserId  //PGTOI_UpdateUser_DR
	s TeamItemList(11)=CurDate  //PGTOI_UpdateUser_DR
	s TeamItemList(12)=CurTime  //PGTOI_UpdateTime
	s TeamItemList(13)=ItemAmt  //PGTOI_AccountAmount
	s TeamItemList(14)=GAuditID  //PGTOI_PAudit_DR
	s TeamItemList(15)="1"  //PGTOI_ItemStat
	s ItemRecLocID=..GetRecLoc(TeamID,TeamItemList(3))
	s TeamItemList(16)=ItemRecLocID  //PGTOI_ItemRecLoc_DR
	s TeamItemList(20)=PreOrAdd  //PGTOI_Type
	&SQL(Insert into SQLUser.DHC_PE_PreGTOrdItem Values :TeamItemList())
	q:SQLCODE'=0 ""
	//s newId=%ROWID
	s TeamItemID=%ROWID
	s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",TeamItemID)=ADMFeeType
	s ^DHCPEDataEx("DHCPEPreGTOrdItem","Qty",TeamItemID)=ItemQty
	s DefaultSpecName=##class(web.DHCPE.PreItemList).GetDefaultSpecName(TeamItemList(3),"1","",LocID)
	s ^DHCPEDataEx("DHCPEPreIOrdItem","TEAM",TeamItemID)=DefaultSpecName
	//插入项目对应的收费项信息
	s arcitmid=$P(OneItemInfo,"^",1) 
	s CurAmt=0
	s TarItem=0
	f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
	.s StartDate=0
	.f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>CurDate)||(SQLCODE'=0)  d
	..s OLTID=0
	..f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:(OLTID="")||(SQLCODE'=0)  d
	...s EndDate=$p($g(^DHCOLT(OLTID)),"^",5)
	...q:(EndDate'="")&&(EndDate<CurDate)
	...s qty=$p($g(^DHCOLT(OLTID)),"^",3)
	...//s ADMFeeType=""
	...//s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",preAdmId))
	...//s ItemADMType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",preAdmId_"||"_childsub))
	...s CurPrice=+##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"",ADMFeeType,"",HospID,"")   //得到当前计费项金额
	...k TarItemList
	...s TarItemList(0)=TeamItemID
	...s TarItemList(3)=TarItem
	...s TarItemList(4)=qty
	...s TarItemList(5)=CurPrice
	...s CurAmt=CurAmt+(qty*CurPrice)
	...&SQL(Insert into SQLUser.DHC_PE_PreGTOrdItemTarItem Values :TarItemList())
	q:SQLCODE'=0 ""
	s $P(^DHCPEPreGADM(+TeamItemID,"Team",$P(TeamItemID,"||",2),"ORDITEM",$P(TeamItemID,"||",3)),"^",15)=CurAmt
	s ^DHCPEDataEx("DHCPEPreGTOrdItem","Qty",TeamItemID)=ItemQty
	i SetsID=""{  //如果不是套餐内的项目，插入分组下每个人的项目,套餐内的项目是在个人插入套餐（InsertPersonSets）时插入的
		s $P(OneItemInfo,"^",4)=TeamItemID
		s PIADM=0
		f  s PIADM=$O(^DHCPEPreIADM(0,"PGTeam",TeamID,PIADM)) q:(PIADM="")||(SQLCODE'=0)  d
		.s Status=$P($g(^DHCPEPreIADM(PIADM)),"^",8)
		.q:Status="CANCELPE"
		.d InsertPersonItem(PIADM,"","",OneItemInfo,PreOrAdd)  //PreIADM,SetsID,IAdmSetsID,SetsItemIDs
		q:SQLCODE'=0 ""
	}
	q TeamItemID
	//增加个人套餐
InsertPersonSets(PreIADM,SetsID,TeamSetsID,SetsPrice,SetsItemIDs,PreOrAdd)
	k SetsList
	s SetsList(0)=PreIADM //dhc_pe_preiadm表ID
	s SetsList(3)=SetsID //Arc_OrdSets表ID
	s SetsList(4)=TeamSetsID  //User.DHCPEPreGTOrdEnt表的ID
	s SetsList(5)=UpdateUserId  //操作员
	s SetsList(6)=CurDate  //日期
	s SetsList(7)=CurTime  //时间
	//s SetsList(8)=""  //PIOE_FactAmount
	s SetsList(9)=SetsPrice  //PIOE_AccountAmount
	s SetsList(10)=PreOrAdd  //PIOE_Type  PRE：预约  ADD：加项
	s SetsList(11)="1"  //状态
	&SQL(Insert into SQLUser.DHC_PE_PreIOrdEnt Values :SetsList())
	q:SQLCODE'=0 SQLCODE
	s IAdmSetsID=%ROWID
	s ItemLength=$L(SetsItemIDs,$C(1))
	f Itemi=1:1:ItemLength {
		s OneItemInfo=$P(SetsItemIDs,$C(1),Itemi)
		s SQLCODE=$$InsertPersonItem(PreIADM,SetsID,IAdmSetsID,OneItemInfo,PreOrAdd)
		q:SQLCODE'=0
	}
	q IAdmSetsID
	//项目ID^数量^价格^分组项目ID...
InsertPersonItem(PreIADM,SetsID,IAdmSetsID,SetsItemIDs,PreOrAdd)
	 
	s AdmAsCharged=$P($g(^DHCPEPreIADM(PreIADM)),"^",9)
	//s DisChargedMode=
	k ItemList
	s OneItemInfo=SetsItemIDs
	s arcitmid=$P(OneItemInfo,"^",1)
	i $G(PIBIRegNo)=""
	{
		s PIADMPIBIDR=$p($g(^DHCPEPreIADM(PreIADM)),"^",1)
        i PIADMPIBIDR'="" s PIBIRegNo = $p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",1)
	}
	s avaliNum = ##class(web.DHCPE.ArcimPreManager).GetAavilNum(arcitmid,$P(^DHCPEPreIADM(PreIADM),"^",5),PIBIRegNo,$P(^DHCPEPreIADM(PreIADM),"^",18)_"^^",$P(^DHCPEPreIADM(PreIADM),"^",26))
    i avaliNum<=0  s SQLCODE = "-9099^超过【"_$P(^ARCIM(+arcitmid,$P(arcitmid,"||",2),1),"^",2)_"】限额！" 
    q:SQLCODE'=0 SQLCODE
	s ItemList(0)=PreIADM //dhc_pe_preiadm表ID
	s ItemList(3)=arcitmid //Arc_ItmMast表的ID
	s ItemList(4)=IAdmSetsID //DHC_PE_PreIOrdEnt表的ID
	s ItemList(5)=SetsID //Arc_OrdSets表ID
	s ItemList(6)=$P(OneItemInfo,"^",4) //DHC_PE_PreGTOrdItem
	//s ItemList(7)="" //PIOI_AddOrdItem YN公费自费，未用
	//s ItemList(8)="" //PIOI_FactAmount  真实金额 未用
	//s ItemList(9)="" //PIOI_PrivilegeMode  优惠形式 未用
	//s ItemList(10)="" //PIOI_Privilege  优惠内容 未用
	s ItemQty=$P(OneItemInfo,"^",2)
	s:+ItemQty=0 ItemQty=1
	s ItemPrice=$P(OneItemInfo,"^",3)
	/// 计算药品和耗材的数量 begin
	if (SetsID=""){
		
		s DoseQty=$P(DrugInfo,"^",1) //剂量
	    s UOMDR=$P(DrugInfo,"^",2) //剂量单位
	    s FreqDR=$P(DrugInfo,"^",3) //频次
	    //s ItemList(33)=$P(DrugInfo,"^",5) //用法
	    s DuratDR=$P(DrugInfo,"^",4) //疗程
	    if (DoseQty'="")&&(UOMDR'="")&&(FreqDR'="")&&(DuratDR'=""){
		    
		    s FreqCoef=$p(^PHCFR(FreqDR),"^",2)
		    
			s DuratCoef=$p(^PHCDU(DuratDR),"^",2)
			
			s incId=$o(^INCI(0,"ARCIM_DR",+arcitmid,0))
			s UOMFac=1
			i incId'=""{
				//基本单位
				s bUom=$p(^INCI(incId,1),"^",10)
				//
				s pUom=$p(^INCI(incId,3),"^",6)
				//门诊发药单位
				s outPhUomDr=$p(^INCI(incId,1),"^",12)
				s UOMFac= ##class(PHA.FACE.OUT.Com).UOMFac(UOMDR,bUom) // 和发药单位匹配
				s BaseQty=DoseQty*FreqCoef*DuratCoef
				s ItemQty=##class(%SYSTEM.SQL).CEILING(BaseQty/UOMFac)
			}
		}
	}
	/// 计算药品和耗材的数量 end
	
	
	s ItemAmt=$FN((ItemPrice*ItemQty),"",2)
	s ItemList(16)=ItemAmt //金额
	
	//项目视同收费状态需要根据是否自费加项判断
	i (PreOrAdd="ADD")&&(($g(^DHCPESetting("DHCPE","CashierSystem",LocID))="0")||($g(^DHCPESetting("DHCPE","CashierSystem",LocID))="2")) d
	.s AdmAsCharged="N"
	
	s ItemAsCharged=AdmAsCharged
	
	//自费加项视同收费
	s:($G(^DHCPEPreIADM(PreIADM,"IFeeAsCharged"))'="")&&((PreOrAdd="ADD")) ItemAsCharged=$G(^DHCPEPreIADM(PreIADM,"IFeeAsCharged"))
	
	/***已经缴过费的，加0费用的项目才视同收费 start***/
	s PaiedFlag=##class(web.DHCPE.HandlerPreOrds).GetPaiedFlag(PreIADM)
	s ZeroIsASCharged=^DHCPESetting("DHCPE","ZeroIsASCharged",LocID)
    i (PaiedFlag="1")||(PaiedFlag="2") d
    .i (+ItemAmt=0)&&(ZeroIsASCharged="Y") s ItemAsCharged="Y" 
    /***已经缴过费的，加0费用的项目才视同收费 end***/

	s ItemList(11)=ItemAsCharged //PIOI_AsCharged  视同收费
	//s ItemList(12)="" //PIOI_PAudit_DR  审核记录ID  未用
	s ItemList(13)=UpdateUserId //PIOI_UpdateUser_DR  用户
	s ItemList(14)=CurDate //PIOI_UpdateDate 日期
	s ItemList(15)=CurTime //PIOI_UpdateDate 时间
	
	s ItemList(17)=PreOrAdd //PIOI_Type
	s ItemList(18)="1" //PIOI_ItemStat
	//s ItemRecLocID=..GetRecLoc(PreIADM,ItemList(3))
	i OEOrdRecLocID'="" s ItemRecLocID=OEOrdRecLocID
	e  s ItemRecLocID=..GetRecLoc(PreIADM,ItemList(3))
	s ItemList(19)=ItemRecLocID //PIOI_ItemRecLoc_DR  接收科室
	s DefaultSpecName=##class(web.DHCPE.PreItemList).GetDefaultSpecName(ItemList(3),"1","",LocID)
	s ItemList(20)=$P(DefaultSpecName,"^",1) //标本类型
	/***药品信息 strat***/
	if (SetsID'=""){
      s DrugInfo=##class(web.DHCPE.CT.HISUICommon).GetDrugByID(SetsID_"^"_arcitmid,LocID,"ArcOrdSets")
    }
    s ItemList(30)=$P(DrugInfo,"^",1) //剂量
    s ItemList(31)=$P(DrugInfo,"^",2) //剂量单位
    s ItemList(32)=$P(DrugInfo,"^",3) //频次
    s ItemList(33)=$P(DrugInfo,"^",5) //用法
    s ItemList(34)=$P(DrugInfo,"^",4) //疗程
   /***药品信息 end***/
   
	&SQL(Insert into SQLUser.DHC_PE_PreIOrdItem Values :ItemList())
	q:SQLCODE'=0 SQLCODE_"a"
	s PreItemID=%ROWID
	d ##class(web.DHCPE.AdmRecordManager).Insert(PreIADM,"P","ADDItem",UpdateUserId,PreItemID)
	s TeamItemID=$P(OneItemInfo,"^",4)
	i TeamItemID'=""{  //获取费用类别
		s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",TeamItemID))
	}else{
		s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",PreIADM))
	}
	s ^DHCPEDataEx("DHCPEPreIOrdItem","Qty",PreItemID)=ItemQty
	s ^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",PreItemID)=DefaultSpecName
	s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",PreItemID)=ADMFeeType 
	//插入项目对应的收费项信息
	s CurAmt=0
	i (GetCurrentPrice="Y")&&(TeamItemID'="")  //按照分组项目价格
	{
		s CurAmt=$P(^DHCPEPreGADM(+TeamItemID,"Team",$P(TeamItemID,"||",2),"ORDITEM",$P(TeamItemID,"||",3)),"^",15)
		s TarItemSub=0
		f  s TarItemSub=$O(^DHCPEPreGADM(+TeamItemID,"Team",$P(TeamItemID,"||",2),"ORDITEM",$P(TeamItemID,"||",3),"TarItem",TarItemSub)) q:TarItemSub=""  d
		.s TarItemData=$g(^DHCPEPreGADM(+TeamItemID,"Team",$P(TeamItemID,"||",2),"ORDITEM",$P(TeamItemID,"||",3),"TarItem",TarItemSub))
		.k TarItemList
		.s TarItemList(0)=PreItemID
		.s TarItemList(3)=$P(TarItemData,"^",1)
		.s TarItemList(4)=$P(TarItemData,"^",2)
		.s TarItemList(5)=$P(TarItemData,"^",3)
		.&SQL(Insert into SQLUser.DHC_PE_PreIOrdItemTarItem Values :TarItemList())
	}
	else {  //单找当前收费项价格
		s ARCICOrderType=""  
		s ItemCatDR=$p(^ARCIM(+arcitmid,$p(arcitmid,"||",2),1),"^",10)  
		i ItemCatDR'=""  s ARCICOrderType=$p(^ARC("IC",ItemCatDR),"^",7)  //医嘱子分类
        
	    i ARCICOrderType="R" { //药品类取批次价
	    
	        //药品根据医嘱项取收费项
	   	 	s inciID="" 
    		f  s inciID=$o(^INCI(0,"ARCIM_DR",+arcitmid,inciID)) q:inciID=""  d
    		.s notUseFlag=$p($g(^INCI(inciID,2)),"^",9)
    		.//q:notUseFlag="Y"
    		.s UOMFac=1
			.s bUom=$p($g(^INCI(inciID,1)),"^",10) //基本单位
			.s pUom=$p($g(^INCI(inciID,3)),"^",6) //入库单位（整数包装的）
			.s UOMFac= ##class(PHA.FACE.OUT.Com).UOMFac(pUom,bUom)
    		.s ordEndDate=""
    		.s infoID=$o(^DHCITMINFO(0,"INCI",inciID,""))
    		.i infoID'="" d
    		..s itmInfoData=$g(^DHCITMINFO(infoID))
    		..s infoEndDate=$p(itmInfoData,"^",31)
    		..s ordEndDate=$p(itmInfoData,"^",113)
    		.q:(infoEndDate'="")&&(infoEndDate<paraDate)
    		.q:(ordEndDate'="")&&(ordEndDate<paraDate)
     		.s trID=""
    		.f  s trID=$o(^DHCINCTARi("INCI",inciID,trID)) q:trID=""  d
    		..s inctrData=$g(^DHCINCTAR(trID))
    		..q:inctrData=""
    		..s trStartDate = $p(inctrData,"^",4)
    		..q:(trStartDate'="")&&(trStartDate>CurDate)
    		..s trEndDate=$p(inctrData,"^",5)
    		..q:(trEndDate'="")&&(trEndDate<CurDate)
    		..s TarItem=$p(inctrData,"^",2)    //收费项
    		..s qty=$p(inctrData,"^",3)       //收费项数量
			..s CurPrice=+##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"",ADMFeeType,"",HospID,"")
			..k TarItemList
			..s TarItemList(0)=PreItemID
			..s TarItemList(3)=TarItem
			..s TarItemList(4)=qty
			..s TarItemList(5)=CurPrice*UOMFac
			..s CurAmt=CurAmt+(qty*CurPrice*UOMFac)
			..&SQL(Insert into SQLUser.DHC_PE_PreIOrdItemTarItem Values :TarItemList())
	    }else{
			s TarItem=0
			f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
			.s StartDate=0
			.f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>CurDate)||(SQLCODE'=0)  d
			..s OLTID=0
			..f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:(OLTID="")||(SQLCODE'=0)  d
			...s EndDate=$p($g(^DHCOLT(OLTID)),"^",5)
			...q:(EndDate'="")&&(EndDate<CurDate)
			...s qty=$p($g(^DHCOLT(OLTID)),"^",3)
			...//s ADMFeeType=""
			...//s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",preAdmId))
			...//s ItemADMType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",preAdmId_"||"_childsub))
			...s CurPrice=+##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"",ADMFeeType,"",HospID,"")   //得到当前计费项金额
			...k TarItemList
			...s TarItemList(0)=PreItemID
			...s TarItemList(3)=TarItem
			...s TarItemList(4)=qty
			...s TarItemList(5)=CurPrice
			...s CurAmt=CurAmt+(qty*CurPrice)
			...&SQL(Insert into SQLUser.DHC_PE_PreIOrdItemTarItem Values :TarItemList())
	    }
	}
	q:SQLCODE'=0 SQLCODE_"b"
	s $P(^DHCPEPreIADM(PreIADM,"ORDITEM",$P(PreItemID,"||",2)),"^",27)=CurAmt
	//插入费用记录
	s PAuditInfo=..GetPreAuditID(PreIADM, PreOrAdd, arcitmid,ItemAmt,SeleAuditRowid)  //  如果存在公+自的项目，返回多个记录
	s AuditInfoLength=$L(PAuditInfo,$C(1))  //PAuditID_"^"_AcountAmount_"^"_FactAmount_$C(1)_PAuditID_"^"_AcountAmount_"^"_FactAmount
	f AuditInfoi=1:1:AuditInfoLength{  
		s OneAuditInfo=$P(PAuditInfo,$C(1),AuditInfoi)
		s PAudit=$P(OneAuditInfo,"^",1)
		//项目的视同收费状态:需要根据是否自费加项判断
		s NewAsCharged="N"
		i PreOrAdd="ADD" d
		.s PAType=$P(^DHCPEPreA(PAudit),"^",1)
		.i PAType="G" d  //公费
		..s NewAsCharged="Y"  
		.i PAType="I" d  //自费
		..s PreGID=$p($g(^DHCPEPreIADM(+PreItemID)),"^",2)
		..i PreGID'="" d
		...s NewAsCharged="N"
		...//自费加项视同收费
		...s:$G(^DHCPEPreIADM(+PreItemID,"IFeeAsCharged"))'="" NewAsCharged=$G(^DHCPEPreIADM(+PreItemID,"IFeeAsCharged"))
    	.//加项类型的项目需要更新DHCPEPreIOrdItem中字段PIOI_AsCharged 
   	 	.s $p(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2)),"^",9)= NewAsCharged  
       
		s AddOrdItem="N"
		s SQLCODE=$$InsertPersonItemFee(PreItemID,OneAuditInfo,AddOrdItem)
		q:SQLCODE'=0
	}
	q:SQLCODE'=0 SQLCODE_"c"
	q SQLCODE
	//插入项目费用表
InsertPersonItemFee(PreItemID,AuditInfo,AddOrdItem)
	k ItemFeeLIST
	s ItemFeeLIST(0)=PreItemID
	s ItemFeeLIST(3)=AddOrdItem  //PIOIF_AddOrdItem  Y/N
	s PAudit=$P(AuditInfo,"^",1)
	s AccountAmount=$P(AuditInfo,"^",2)
	s FactAmount=$P(AuditInfo,"^",3)
	s ItemFeeLIST(4)=$J(FactAmount,"",2)  //PIOIF_FactAmount
	//s ItemFeeLIST(5)=PrivilegeMode  //PIOIF_PrivilegeMode
	//s ItemFeeLIST(6)=Privilege  //PIOIF_Privilege
	s ItemFeeLIST(7)=PAudit  //PIOIF_PAudit_DR
	s ItemFeeLIST(8)=UpdateUserId  //PIOIF_UpdateUser_DR
	s ItemFeeLIST(9)=CurDate  //PIOIF_UpdateDate
	s ItemFeeLIST(10)=CurTime  //PIOIF_UpdateTime
	s ItemFeeLIST(11)=$J(AccountAmount,"",2)  //PIOIF_AccountAmount
	s Rebate=$P($G(^DHCPEPreA(PAudit)),"^",5)
	s ItemFeeLIST(12)=Rebate
	&SQL(Insert into SQLUser.DHC_PE_PreIOrdItemFee Values :ItemFeeLIST())
	s OldAccountAmt=$P($g(^DHCPEPreA(PAudit)),"^",6)
	s OldFactAmt=$P($g(^DHCPEPreA(PAudit)),"^",9)
	s OldFactAmt=$FN((OldFactAmt+FactAmount),"",2)
	s OldAccountAmt=$FN((OldAccountAmt+AccountAmount),"",2)
	s $P(^DHCPEPreA(PAudit),"^",6)=OldAccountAmt
	s $P(^DHCPEPreA(PAudit),"^",7)=OldFactAmt
	s $P(^DHCPEPreA(PAudit),"^",9)=OldFactAmt
	//增加协议调整费记录
    i +roundingfee'=0 d 
    .d ##class(web.DHCPE.TransAdmInfo).ConfirmAddOrdItem(+PreItemID,%session.Get("LOGON.USERID"))
    .s ^DHCPEDataEx("InsertRoundFee",+PreItemID,$P(PreItemID,"||",2))=RoundType_"^"_RoundRemark_"^"_roundingfee_"^"_%session.Get("LOGON.USERID")_"^"_$H
	q SQLCODE
}

/// Description: 获取加项限额
/// Input: 		 PreIADM(个人预约ID)
/// Debug: w ##class(web.DHCPE.PreItemList2).GetILimit()
ClassMethod GetILimit(PreIADM)
{
	n (PreIADM)
	s AddFlag=$P($g(^DHCPEPreIADM(PreIADM)),"^",10)
	q:AddFlag'="Y" 0
	s LimitFlag=$P($g(^DHCPEPreIADM(PreIADM)),"^",11)
	q:LimitFlag="N" 99999999
	s TotalLimitAmt=$P($g(^DHCPEPreIADM(PreIADM)),"^",12)
	s AddAmt=..GetAddAmt(PreIADM)
	s LimitAmt=TotalLimitAmt-AddAmt
	q LimitAmt
}

/// Description: 获取未付费加项金额
/// Input: 		 PreIADM(个人预约ID)
/// Debug: w ##class(web.DHCPE.PreItemList2).GetAddAmt()
ClassMethod GetAddAmt(PreIADM)
{
	//w ##class(web.DHCPE.PreItemList2).GetAddAmt(11615)
	n (PreIADM)
	s AddAmt=0
	s ItemSub=0
	f  s ItemSub=$O(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)) q:ItemSub=""  d
	.s ItemStat=$P($g(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)),"^",16)
	.q:ItemStat'="1"
	.s Sub=0
	.f  s Sub=$o(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub,"FEE",Sub)) q:Sub=""  d
	..s DataStr=$g(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub,"FEE",Sub))
	..s AuditId=$p(DataStr,"^",5)
	..q:AuditId=""
	..s Flag=$p($g(^DHCPEPreA(AuditId)),"^",21)
	..q:Flag="NU"
	..s AuditType=$p($g(^DHCPEPreA(AuditId)),"^",1)
	..q:(AuditType="I")
	..s AppType=$p($g(^DHCPEPreA(AuditId)),"^",20)
	..q:AppType'="ADD"
	..s ChargedStatus=$p($g(^DHCPEPreA(AuditId)),"^",14)
	..q:ChargedStatus="CHARGED"
	..s OneAmt=$p(DataStr,"^",2)
	..s AddAmt=AddAmt+OneAmt
	q AddAmt
}

/// Description: 根据预约id，项目预约还是加项,医嘱项ID,项目价格  
///              获取:审核记录id^原金额^折后金额
/// Input: 		 AdmId(个人预约ID), PREOrADD(预约或加项目), ArcItemID（医嘱项ID）, ItemAmt（项目价格）, SeleAuditRowid
/// Debug: w ##class(web.DHCPE.PreItemList2).GetPreAuditID() 
ClassMethod GetPreAuditID(AdmId, PREOrADD, ArcItemID, ItemAmt, SeleAuditRowid As %String = "")
{
	//w ##class(web.DHCPE.PreItemList2).GetPreAuditID(11615,"ADD",11497||1,140)
	n (AdmId,PREOrADD,ArcItemID,ItemAmt,SeleAuditRowid)
	//获取可以使用的审核记录id
	s ret=""
	s DisChargedMode=$p($g(^DHCPEPreIADM(AdmId)),"^",17)  //结算方式
	s PGAdm=$p($g(^DHCPEPreIADM(AdmId)),"^",2)
	s PGTeam=$p($g(^DHCPEPreIADM(AdmId)),"^",3)
	s PAuditID=""
	i PGAdm'=""{
		i DisChargedMode="ID"{ //自结，就是获取自费类型
			s AdmType="I"
			s PAuditID=..GetPARowId(AdmType,AdmId,PREOrADD,SeleAuditRowid,ArcItemID)
		}else{
			i PREOrADD="PRE"{  //统结，如果是PRE类型，获取团体费用类型
				s AdmType="G"
				s PAuditID=..GetPARowId(AdmType,AdmId,PREOrADD,SeleAuditRowid,ArcItemID)
			}else{  //统结加项类型
				s AddOrdItem=$p(^DHCPEPreIADM(AdmId),"^",10)
				s AddLimitFlag=$p(^DHCPEPreIADM(AdmId),"^",11)
				s AddLimit=$p(^DHCPEPreIADM(AdmId),"^",12)
				;b ;AddLimit  AddOrdItem
				i (AddOrdItem="N") d
				.s AdmType="I"  //不允许加项，自费类型
				.s PAuditID=..GetPARowId(AdmType,AdmId,PREOrADD,SeleAuditRowid,ArcItemID)
				e  d
				.i (AddLimitFlag="N") d //允许加项，不限制加项限额，公费类型
				..s AdmType="G"
				..s PAuditID=..GetPARowId(AdmType,AdmId,PREOrADD,SeleAuditRowid,ArcItemID)
				.e  d  //设置了加项限额
				..s HadAddAmount=..GetAddAmt(AdmId)
				..i HadAddAmount>=AddLimit d  //已经无可用限额，全自费
				...s AdmType="I"
				...s PAuditID=..GetPARowId(AdmType,AdmId,PREOrADD,SeleAuditRowid,ArcItemID)
				..e  d  //判断剩余限额是否够加项
				...s AdmType="G"
				...s GAuditID=..GetPARowId(AdmType,AdmId,PREOrADD,SeleAuditRowid,ArcItemID)
				...s GFactAmount=..GetFactAmount(ArcItemID,ItemAmt,+GAuditID)
				...i (HadAddAmount+GFactAmount)<=AddLimit d  //全公费
				....s ret=(+GAuditID)_"^"_ItemAmt_"^"_GFactAmount
				...e  d  //部分公费，产生了公+自
				....s GFactAmount=AddLimit-HadAddAmount  //公费可用的额度
				....s GPrivilegeMode=$P(GAuditID,"^",2)
				....i GPrivilegeMode="OR" d
				.....s GRebate=$P(GAuditID,"^",3)
				.....s GAcountAmount=(GFactAmount*100)/GRebate  //公费对应得项目原价的金额
				....e  d
				.....s GAcountAmount=GFactAmount
				....s AdmType="I"
				....s IAuditID=..GetPARowId(AdmType,AdmId,PREOrADD,SeleAuditRowid,ArcItemID)
				....s IAcountAmount=ItemAmt-GAcountAmount  //自费部分对应项目原价的金额
				....s IFactAmount=..GetFactAmount(ArcItemID,IAcountAmount,+IAuditID)
				....s ret=(+GAuditID)_"^"_GAcountAmount_"^"_GFactAmount_$C(1)_(+IAuditID)_"^"_IAcountAmount_"^"_IFactAmount
			}
		}
	}else{  //个人
		s AdmType="I"
		s PAuditID=..GetPARowId(AdmType,AdmId,PREOrADD,SeleAuditRowid,ArcItemID)
	}
	i ret=""{
		s PAuditID=+PAuditID
		s FactAmount=..GetFactAmount(ArcItemID,ItemAmt,+PAuditID)
		s ret=PAuditID_"^"_ItemAmt_"^"_FactAmount
	}
	q ret
}

/// Description: 根据医嘱项id、项目原价、审核记录id,获取折后价格
/// Input: 		 ArcItemID(医嘱项id),AcountAmount(项目原价),PAuditID(审核记录id)
/// Debug: w ##class(web.DHCPE.PreItemList2).GetFactAmount()
ClassMethod GetFactAmount(ArcItemID, AcountAmount, PAuditID)
{
	n (ArcItemID,AcountAmount,PAuditID)
	s:$D(%session) LocID =%session.Get("LOGON.CTLOCID")
    i PAuditID'="" {
        s ADMType=$p($g(^DHCPEPreA(PAuditID)),"^",1)
    	i (ADMType="G") {
       		s PGAdm=$p($g(^DHCPEPreA(PAuditID)),"^",2)
        	s LocID=$P($g(^DHCPEPreGADM(PGAdm)),"^",23)
    	}elseif (ADMType="I") {
        	s PreIAdmID=$p($g(^DHCPEPreA(PAuditID)),"^",2)
        	s LocID=$P($g(^DHCPEPreIADM(PreIAdmID)),"^",26)
    	}
    
    }
   
    s DiscountFlag=..GetDiscountFlag(ArcItemID,LocID)
    q:DiscountFlag="Y" AcountAmount  //项目不打折返回原价
	s PrivilegeMode=$P($G(^DHCPEPreA(PAuditID)),"^",19)
	q:PrivilegeMode'="OR" AcountAmount  //审核记录不打折返回原价
	s Rebate=$P($G(^DHCPEPreA(PAuditID)),"^",5)
	s FactAmount=AcountAmount*(Rebate/100)  //根据折扣率计算折扣价格
	q FactAmount
}

/// Description:  根据 医嘱项id，获取是否可用打折的标记 
/// Input:        ArcItemID(医嘱项id),LocID(科室ID)
/// Return：      N/Y(参与打折/不打折)
/// Debug:  w ##class(web.DHCPE.PreItemList2).GetDiscountFlag()
ClassMethod GetDiscountFlag(ArcItemID, LocID As %String = "")
{
	s:$D(%session)&&(LocID="") LocID =%session.Get("LOGON.CTLOCID")
	s NoDiscount="N"
	q:ArcItemID="" "N"
    s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcItemID,LocID)
    q:StatOrderID="" "N"
    s StatOrderSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderID,0)) 
    q:StatOrderSetID="" "N"
    s NoDiscount=$lg($g(^CF.PE.StationOrderSetD(StatOrderSetID)),36)
    s:NoDiscount="" NoDiscount="N"
    q NoDiscount
}

/// Description: 根据adm类型、preiadm表id、加项预约类型获取审核记录id 
/// Input: 		 CRMADMType(adm类型),PreIAdmID(preiadm表id),PreOrAdd(加项预约类型)
/// Debug: w ##class(web.DHCPE.PreItemList2).GetPARowId()
ClassMethod GetPARowId(CRMADMType As %Library.String = "", PreIAdmID As %Library.String = "", PreOrAdd As %Library.String = "", SeleAuditRowid As %String = "", ArcItemID As %String = "")
{
	//w ##calss(web.DHCPE.PreItemList2).GetPARowId("G","1||1","PRE")
	n (CRMADMType,PreIAdmID,PreOrAdd,SeleAuditRowid,ArcItemID)
	i SeleAuditRowid'=""{
		s PrivilegeMode=$P($G(^DHCPEPreA(SeleAuditRowid)),"^",19)
		s Rebate=$P($g(^DHCPEPreA(SeleAuditRowid)),"^",5)
		q SeleAuditRowid_"^"_PrivilegeMode_"^"_Rebate
	}
	
	i $L(PreIAdmID,"||")>1 {
		s PGTeam=PreIAdmID
		s PGAdm=+PGTeam
		s LocID=$P($g(^DHCPEPreGADM(PGAdm)),"^",23)
	}else{
		s PGAdm=$p($g(^DHCPEPreIADM(PreIAdmID)),"^",2)
		s PGTeam=$p($g(^DHCPEPreIADM(PreIAdmID)),"^",3)
		s LocID=$P($g(^DHCPEPreIADM(PreIAdmID)),"^",26)
	}
	s DiscountFlag=..GetDiscountFlag(ArcItemID,LocID)
	
	//分组设置了折扣率，按照分组获取审核记录
	s GetGAuditByTeam="N"  //$G(^DHCPESetting("DHCPE","GetGAuditByTeam",LocID))
	s DefaultRebate=""
	i PGTeam'=""{
		s DefaultRebate=$p($G(^DHCPEPreGADM(+PGTeam,"Team",$P(PGTeam,"||",2))),"^",20,22)
		i (DefaultRebate'="^^")&&(DefaultRebate'=""){  //团体人员按分组折扣率
			s GetGAuditByTeam="Y"
		}else{ //按团体统一折扣率
			s DefaultRebate=$p($G(^DHCPEPreGADM(PGAdm)),"^",26,28)
		}	
	}else{  //个人
		
	}
	//团体设置过分组折扣，就拆分审核表
    i PGTeam'=""{
        s PGSub=0
        f  s PGSub=$o(^DHCPEPreGADM(+PGTeam,"Team",PGSub)) q:PGSub=""  d
        .s PGDefaultRebate=$p($G(^DHCPEPreGADM(+PGTeam,"Team",PGSub)),"^",20,22)
        .i (PGDefaultRebate'="^^")&&(PGDefaultRebate'="") s GetGAuditByTeam="Y"
    }
	//取可操作的审核表
	s Notice=0
	i CRMADMType="G" d
	.s PACRMADM=+PGAdm
	e  d
	.s PACRMADM=PreIAdmID
	s PIOIPAuditDR=""
	s PARowId=0
	f  s PARowId=$o(^DHCPEPreA(0,"CRMADM",CRMADMType,PACRMADM,PARowId)) q:(PARowId="")||(PIOIPAuditDR'="")  d
	.s PAStr=^DHCPEPreA(PARowId)
	.s PAAuditedStatus=$p(PAStr,"^",10)
	.q:PAAuditedStatus="Audited"  //已经审核不能再向上面增加
	.s PAType=$p(PAStr,"^",20)
	.q:PreOrAdd'=PAType 
	.s Team=$p(PAStr,"^",22)
	.q:(CRMADMType="G")&&(GetGAuditByTeam="Y")&&(PGTeam'=Team)  //团体审核记录，并且根据分组设置审核记录
	.s ChargedStatus=$p(PAStr,"^",14)
	.q:ChargedStatus="CHARGED"  //已收费退出
	.s UserFlag=$p(PAStr,"^",21)
	.q:UserFlag="NU"  //已退费退出
	.s CurDiscountFlag=$p(PAStr,"^",24)
	.s:CurDiscountFlag="" CurDiscountFlag="N"
	.q:CurDiscountFlag'=DiscountFlag
	.s PIOIPAuditDR=PARowId
	
	//获取默认折扣率
	
	i PIOIPAuditDR=""{  //没有取到审核记录
		s Rebate=""  //设置初始折扣率为空
		i PGAdm'=""{
			i CRMADMType="I"{
				s Rebate=$P(DefaultRebate,"^",3)  //..GetGRebate(PGTeam,3)
			}else{
				i PreOrAdd="ADD"{
					s Rebate=$P(DefaultRebate,"^",2)  //..GetGRebate(PGTeam,2)
				}else{
					s Rebate=$P(DefaultRebate,"^",1)  //..GetGRebate(PGTeam,1)
				}
			}
		}
		s PAprivilegeMode="NP"  //设置默认无优惠
		s:Rebate'="" PAprivilegeMode="OR"  //有折扣率，设置为折扣优惠方式
		
		i CRMADMType="G" s PAIADM=$o(^DHCPEGADM(0,"CRMGADM",PACRMADM,0))
		i CRMADMType="I" s PAIADM=$o(^DHCPEIADM(0,"CRMADM",PACRMADM,0))
		i GetGAuditByTeam'="Y" s PGTeam=""  //不根据分组生成审核记录分组设置为空
		
		&sql(insert into sqluser.DHC_PE_PreAudit(PA_ADMType,PA_CRMADM,PA_GIADM,
				PA_AuditedStatus,PA_ChargedStatus,PA_PrivilegeMode,PA_Type,PA_Status,PA_CRMTeam,PA_Rebate,PA_NoPrivilege
			)values(
				:CRMADMType,:PACRMADM,:PAIADM,'NoAudited','UNCHARGED',:PAprivilegeMode,
				:PreOrAdd,'U',:PGTeam,:Rebate,:DiscountFlag
			))
		Q:SQLCODE'=0 ""
		s PIOIPAuditDR=%ROWID
	}
	Q:PIOIPAuditDR="" ""
	s PrivilegeMode=$P($G(^DHCPEPreA(PIOIPAuditDR)),"^",19)
	s Rebate=$P($G(^DHCPEPreA(PIOIPAuditDR)),"^",5)
	q PIOIPAuditDR_"^"_PrivilegeMode_"^"_Rebate
}

/// Description: 根据团体预约记录id和折扣类型获取折扣系数
/// Input: 		 PGTeam(分组预约ID),RebateType(1：团体公费预约折扣率  2：公费加项折扣率  3：自费加项折扣率)
/// Debug: w ##class(web.DHCPE.PreItemList2).GetGRebate()
ClassMethod GetGRebate(PGTeam, RebateType)
{
	q $p($G(^DHCPEPreGADM(+PGTeam,"Team",$P(PGTeam,"||",2))),"^",RebateType+19)
}

/// Description:  根据预约id、医嘱项ID，获取接收科室
/// Input: 		  AdmID(预约id),ArcItemID(医嘱项ID)
/// Debug: w ##class(web.DHCPE.PreItemList2).GetRecLoc()
ClassMethod GetRecLoc(AdmID, ArcItemID)
{
	n (AdmID,ArcItemID)
	i $L(AdmID,"||")>1{  //分组
		s Loc=$P($g(^DHCPEPreGADM(+AdmID)),"^",23)
	}else{  //个人
		s Loc=$P($g(^DHCPEPreIADM(AdmID)),"^",26)
	}
	s DefaultADM=$G(^DHCPESetting("DHCPE","DefaultPAADM",Loc))
	s RecLocID=##class(web.DHCPE.TransAdmInfo).GetReceiveLoc(DefaultADM, ArcItemID,Loc)
	q RecLocID
}

/// Description:  根据套餐id获取项目信息ID及价格等信息
/// Input: 		  项目ID^数量^价格^用法...$C(1)项目ID^数量^价格^用法...
/// Debug: w ##class(web.DHCPE.PreItemList2).GetItemInfoBySetsID()
ClassMethod GetItemInfoBySetsID(ArcItemSetId, AdmID)
{
	n (ArcItemSetId, AdmID)
	//根据id获取费用类型及科室id
	i $L(AdmID,"||")>1{  //分组
		s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",+AdmID))
		s Loc=$P(^DHCPEPreGADM(+AdmID),"^",23)
	}else{  //个人
		s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",AdmID))
		s Loc=$P(^DHCPEPreIADM(AdmID),"^",26)
	
	}
	//获取医嘱套对应的检查项目信息
	s SetsPrice=0
	s ret=""
	s arcsetdateid=""
	f  s arcsetdateid=$o(^ARCOS(ArcItemSetId,"DATE",arcsetdateid)) q:(arcsetdateid="")  d
	.s arcdata=$g(^ARCOS(ArcItemSetId,"DATE",arcsetdateid))
	.q:arcdata=""
	.s datefrom=$p(arcdata,"^",1)
	.q:datefrom>+$h
	.s dateto=$p(arcdata,"^",2)
	.q:((dateto'="")&&(dateto<+$h))
	.s arcsetdateitemid=0
	.///取项目
	.f  s arcsetdateitemid=$o(^ARCOS(ArcItemSetId,"DATE",arcsetdateid,"ITM",arcsetdateitemid)) q:((arcsetdateitemid=""))  d
	..s arcdata=$g(^ARCOS(ArcItemSetId,"DATE",arcsetdateid,"ITM",arcsetdateitemid))
	..s arcitemid=$p(arcdata,"^",1)
	..s EffDateTo=$p(^ARCIM($p(arcitemid,"||",1),$p(arcitemid,"||",2),7),"^",1)
	..i EffDateTo="" s EffDateTo=+$H+1
	..q:EffDateTo<+$H
	..s EffDateFrom=$p($G(^ARCIM($p(arcitemid,"||",1),$p(arcitemid,"||",2),1)),"^",13)
	..s EffDateFrom=$P(EffDateFrom,"Z",1)
	..i EffDateFrom="" s EffDateFrom=+$H-1
	..q:EffDateFrom>+$H
	..s OneInfo=""
	..s arcitemqty=$p(arcdata,"^",2)
	..i arcitemqty="" s arcitemqty=1
	..;s ItemPrice=$p(arcdata,"^",19)          //ITM_Price
	..
	..// 取套餐项目定价
	..s ItemPrice=##class(web.DHCPE.CT.OrderSets).GetOSItemPrice(ArcItemSetId_"||"_arcsetdateid_"||"_arcsetdateitemid, +$h)
	..s:ItemPrice'="" ItemPrice={}.%FromJSON(ItemPrice).price
	..
	..i ItemPrice="" d
	...s ItemPrice=..GetItemPrice(ADMFeeType,Loc,arcitemid)
	..s ItemPrice=$FN(ItemPrice,"",2)
	..s SetsPrice=SetsPrice+ItemPrice
	..s OneInfo=arcitemid_"^"_arcitemqty_"^"_ItemPrice
	..i ret="" d
	...s ret=OneInfo
	..e  d
	...s ret=ret_$C(1)_OneInfo
	.///包含套餐
	.///取项目
	.f  s arcsetdateitemid=$o(^ARCOS(ArcItemSetId,"DATE",arcsetdateid,"OS",arcsetdateitemid)) q:((arcsetdateitemid=""))  d
	..s arcdata=$g(^ARCOS(ArcItemSetId,"DATE",arcsetdateid,"OS",arcsetdateitemid))
	..s arcitemid=$p(arcdata,"^",1)
	..s OneInfo=..GetItemInfoBySetsID(arcitemid)
	..s OnePrice=$P(OneInfo,$C(0),1)
	..s OneInfo=$P(OneInfo,$C(0),2)
	..s SetsPrice=SetsPrice+OnePrice
	..q:OneInfo=""
	..i ret="" d
	...s ret=OneInfo
	..e  d
	...s ret=ret_$C(1)_OneInfo
	q:ret="" ""
	s SetsPrice=$FN(SetsPrice,"",2)
	q SetsPrice_$C(0)_ret
}

/// Description:  获取医嘱项当前价格（优先取赠送价格、医嘱扩展价格）
/// Debug: w ##class(web.DHCPE.PreItemList2).GetItemPrice("","152","3950||1","2521")
ClassMethod GetItemPrice(ADMFeeType, LocID, ARCID, PreIADM = "")
{
	s ^tempdhcpe("GetItemPrice")=$lb(ADMFeeType, LocID, ARCID, PreIADM)
	n (ADMFeeType,LocID,ARCID,PreIADM)
	s ItemPrice="",Date = +$H
	
		
	/***********优先取体检里面定义的价格 start****************/
	
	//根据医嘱项ID查找对应OrderDR（站点和项目组合ID）
	i ARCID'="" s OrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCID,LocID)
	i (OrderDR'=""){
		i (PreIADM'=""){
			//赠送价格
			s Fee=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(PreIADM)
			s Fee=+$P(Fee,"^",2)		
			s IEID=0
			//索引由^DHCPEIE(0,"ARCIM")改变^DHCPEIE(0,"Order")
			f  s IEID=$O(^DHCPEIE(0,"Order",OrderDR,IEID)) q:(IEID="")||(ItemPrice'="")  d
			.s LocShowDFlag=##class(User.DHCPEItemExtend).GetLocShowDataFlag(IEID,LocID)
    		.q:LocShowDFlag'="Y"	
			.s Sub=0
			.f  s Sub=$o(^DHCPEIE(IEID,"SI",Sub)) q:(Sub="")||(ItemPrice'="")  d
			..s CLoc=$p($g(^DHCPEIE(IEID,"SI",Sub)),"^",5)
			..q:CLoc'=LocID
			..s BDate=$p($g(^DHCPEIE(IEID,"SI",Sub)),"^",3)
			..q:BDate>Date
			..s EDate=$p($g(^DHCPEIE(IEID,"SI",Sub)),"^",4)
			..q:(EDate<Date)&&(EDate'="")
			..s FeeMin=$p($g(^DHCPEIE(IEID,"SI",Sub)),"^",1)
			..q:FeeMin>Fee
			..s ItemPrice=0
			q:ItemPrice'="" ItemPrice
		}
			
		//医嘱扩展价格
		s IEID=0
		//索引由^DHCPEIE(0,"ARCIM")改变^DHCPEIE(0,"Order")
		f  s IEID=$O(^DHCPEIE(0,"Order",OrderDR,IEID)) q:(IEID="")||(ItemPrice'="")  d
		.s LocShowDFlag=##class(User.DHCPEItemExtend).GetLocShowDataFlag(IEID,LocID)
    	.q:LocShowDFlag'="Y"
		.s Sub=0
		.f  s Sub=$o(^DHCPEIE(IEID,"P",Sub)) q:(Sub="")||(ItemPrice'="")  d
		..s CLoc=$p($g(^DHCPEIE(IEID,"P",Sub)),"^",4)
		..q:CLoc'=LocID
		..s BDate=$p($g(^DHCPEIE(IEID,"P",Sub)),"^",2)
		..q:BDate>Date
		..s EDate=$p($g(^DHCPEIE(IEID,"P",Sub)),"^",3)
		..q:(EDate<Date)&&(EDate'="")
		..s ItemPrice=$p($g(^DHCPEIE(IEID,"P",Sub)),"^",1)
		q:ItemPrice'="" ItemPrice
	}
	/***********优先取体检里面定义的价格 end****************/
	
   /***********体检未维护价格，获取his维护价格 start****************/
   
	s hospid=$P($g(^CTLOC(LocID)),"^",22)
	s Cat=+$p($G(^ARCIM(+ARCID,$p(ARCID,"||",2),1)),"^",10)
    i Cat'="" d
    .//s Cat=$p($G(^ARC("IC",Cat)),"^",8)
    .s ordType=$p($G(^ARC("IC",Cat)),"^",7)
    e  d
    .s ordType=""
    if (ordType="R"){
	    s incId=$o(^INCI(0,"ARCIM_DR",+ARCID,0))
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
			s UOMFac= ##class(PHA.FACE.OUT.Com).UOMFac(outPhUomDr,bUom) // 和发药单位匹配
		}
		
		s ItemPrice=##class(web.UDHCJFPRICE).GetOrderPrice(ADMFeeType,"",ARCID,+$H,"","","","",hospid)
		//取医嘱的销售单位  发药单位
		s $p(ItemPrice,"^",1)=$p(ItemPrice,"^",1)*UOMFac
    }else{
	    s ItemPrice=##class(web.UDHCJFPRICE).GetOrderPrice(ADMFeeType,"",ARCID,+$H,"","","","",hospid)
		
		}
	
   /***********体检未维护价格，获取his维护价格 end****************/
	q $P(ItemPrice,"^",1)
}

/*
ClassMethod IDeleteItemBak(AdmId As %Library.String = "", AdmType As %Library.String = "", OrdItemId As %Library.String = "", OrdEntId As %Library.String = "", AddAmountFlag As %Library.String = "0", User As %String = "") As %String
{
	
	s ^TempDHCPEInserItem("IDeleteItem")=AdmId_"^"_AdmType_"^"_OrdItemId_"^"_OrdEntId_"^"_AddAmountFlag_"^"_User
	n (AdmId, AdmType, OrdItemId, OrdEntId, AddAmountFlag, User,%session)
	s TStartFlag=0
	q:((AdmType'="PERSON")&&(AdmType'="TEAM")) "删除信息，项目类型不对。"
	q:((OrdItemId="")&&(OrdEntId="")) "项目或者套餐不能都为空。"
	i User="" d
	.s:$D(%session) User=%session.Get("LOGON.USERID")
	s:User="" User=1
    
	s CurDate=+$H
	s CurTime=$P($H,",",2)
	s ret=""
	s $ZT="IDeleteItemErr"
	s TStartFlag=1
	s SQLCODE=0
    i AdmType="TEAM"{  //分组
	    i OrdEntId'=""{  //分组套餐
		    d DeleteTeamSets
	    }else{  //分组项目
		    d DeleteTeamItem(OrdItemId,1)  //删除分组下每个人的项目
	    }
    }else{  //个人
	    i OrdEntId'=""{  //个人套餐
		    d DeletePersonSets
	    }else{  //分组项目
		    
	    }
    }
    i SQLCODE'=0{
	    TROLLBACK
	    q "删除项目失败:"_SQLCODE
    }
    TCOMMIT
    q ret
DeleteTeamSets
	//把分组的套餐设置为删除状态
	&sql(update sqluser.DHC_PE_PreGTOrdEnt set PGTOE_ItemStat='4' where PGTOE_RowId=:OrdEntId)
	q:SQLCODE'=0
	//分组套餐下的项目设置为删除状态
	s GTOISub=0
	f  s GTOISub=$O(^DHCPEPreGADM(0,"OrdEnt",OrdEntId,+OrdEntId,$P(OrdEntId,"||",2),GTOISub)) q:(GTOISub="")||(SQLCODE'=0)  d
	.s TeamItemID=$P(OrdEntId,"||",1,2)_"||"_GTOISub
	.s ItemRet=$$DeleteTeamItem(TeamItemID,0)  //不删除每个人的项目
	//循环分组下每个人的套餐，删除个人套餐
	s PIADMRowId=0
	f  s PIADMRowId=$o(^DHCPEPreIADM(0,"GTOE",OrdEntId,PIADMRowId)) q:PIADMRowId=""  d
	.s PIADMStatus=$P($G(^DHCPEPreIADM(PIADMRowId)),"^",8)
	.q:PIADMStatus="CANCELPE"
	.s PIOECldSub=0
	.f  s PIOECldSub=$o(^DHCPEPreIADM(0,"GTOE",OrdEntId,PIADMRowId,PIOECldSub)) q:(PIOECldSub="")||(SQLCODE'=0)  d
	..s SetsStat=$P(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOECldSub),"^",9)
	..q:SetsStat'="1"
	..s PIOERowId=PIADMRowId_"||"_PIOECldSub
	..d DeletePersonSets(PIOERowId)
	q
DeleteTeamItem(TeamItemID,DeletePersonItemFlag)
	//分组项目设置为停止状态
	&SQL(update sqluser.DHC_PE_PreGTOrdItem set PGTOI_ItemStat='4' where PGTOI_RowId=:TeamItemID)
	q:SQLCODE'=0 ""
	q:DeletePersonItemFlag=0 ""  //不删除分组每个人的项目,删除分组套餐时传入0
	s PIADMRowId=0
	f  s PIADMRowId=$O(^DHCPEPreIADM(0,"GTOI",TeamItemID,PIADMRowId)) q:PIADMRowId=""  d
	.s PIADMStatus=$P($G(^DHCPEPreIADM(PIADMRowId)),"^",8)
	.q:PIADMStatus="CANCELPE"
	.s PIOISub=0
	.f  s PIOISub=$O(^DHCPEPreIADM(0,"GTOI",TeamItemID,PIADMRowId,PIOISub)) q:(PIOISub="")||(SQLCODE'=0)  d
	..s ItemStat=$P(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOISub),"^",16)
	..q:ItemStat'="1"
	..s PersonItemID=PIADMRowId_"||"_PIOISub
	..d DeletePersonItem(PersonItemID)
	q ""
DeletePersonSets(PersonSetsID)
	s SetsDeleteFlag=1
	s PIOISub=0
	f  s PIOISub=$O(^DHCPEPreIADM(0,"OrdEnt",PersonSetsID,+PersonSetsID,PIOISub)) q:(PIOISub="")||(SQLCODE'=0)  d
	.s ItemStat=$P(^DHCPEPreIADM(+PersonSetsID,"ORDITEM",PIOISub),"^",16)
	.q:ItemStat'="1"
	.s PersonItemID=PIADMRowId_"||"_PIOISub
	.s ItemDeleteResult=$$DeletePersonItem(PersonItemID)
	.q:SQLCODE'=0
	.s:ItemDeleteResult'="0" SetsDeleteFlag=0 //不能删除套餐
	q:SQLCODE'=0 ""
	i SetsDeleteFlag=1{
		&sql(update sqluser.DHC_PE_PreIOrdEnt set PIOE_ItemStat='4' where PIOE_RowId=:PersonSetsID)
	}
	q ""
	
DeletePersonItem(PersonItemID)  //返回1：已执行不能删除  2：已收费不能删除 0：能删除 -1:删除错误
	s ItemMayDelete=..MayDeleteItem(PersonItemID)
	q:ItemMayDelete'=0 ItemMayDelete
	&sql(update sqluser.DHC_PE_PreIOrdItem set PIOI_ItemStat='4' where PIOI_RowId=:PersonItemID)
	q:SQLCODE'=0 "-1"
	s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",PersonItemID,0))
	i CRMORowId'=""{
		s OEOrdItemID=$P(^DHCPECRMO(CRMORowId),"^",1)
		i OEOrdItemID'=""{
			d ##class(web.DHCPE.CRM.RisGateway).SendInfo("D",OEOrdItemID)  //如果需要调用pacs接口，放到SendInfo处
			&sql(update sqluser.oe_orditem set Oeori_itemstat_dr='4',Oeori_XDate=:CurDate,Oeori_XTime=:CurTime where oeori_RowId=:OEOrdItemID)
			q:SQLCODE'=0 "-1"
			
			/// ad by sun 停止视同收费的药品自动生成退药申请
			s DrugAplly=0
			s Paystatus=$p($g(^DHCPECRMO(CRMORowId)),"^",4)
			i Paystatus="OC" d
			.s DrugAplly=##class(web.DHCPE.ItemFeeList).DrugPermControl("1^"_PersonItemID,"0","")  //方法里面的用户需要判断下，不直接取session
			q:(DrugAplly=2) "-1"
			/// ad by sun 停止视同收费的药品自动生成退药申请 end
			//d ##class(web.DHCOEDispensing).Return(OEORIDR)
			//插入到达项目表
			d ##class(web.DHCPE.ItemDetailRecord).Insert(OEORIDR,"D",User,CurDate)
			
		}
	}
	//更新费用表以及审核记录表的数据
	s ItemFeeSub=0
	f  s ItemFeeSub=$O(^DHCPEPreIADM(+PersonItemID,"ORDITEM",$P(PersonItemID,"||",2),"FEE",ItemFeeSub)) q:(ItemFeeSub="")||(SQLCODE'=0)  d
	.s PAuditDR=$p($g(^DHCPEPreIADM(+PersonItemID,"ORDITEM",$P(PersonItemID,"||",2),"FEE",ItemFeeSub)),"^",5)
	.q:PAuditDR=""
	.s ChargedStatus=$p($g(^DHCPEPreA(PAuditDR)),"^",14)
	.q:ChargedStatus="CHARGED"
	.s UserFlag=$p($g(^DHCPEPreA(PAuditDR)),"^",21)
	.q:UserFlag="NU"
	.s ItemFeeID=PersonItemID_"||"_ItemFeeSub
	.&SQL(Update Sqluser.DHC_PE_PreIOrdItemFee set PIOIF_PAudit_DR=null where PIOIF_RowID=:ItemFeeID)
	.q:SQLCODE'=0
	.//计算审核记录的应收、实收金额
	.s AcountAmt=$p($g(^DHCPEPreIADM(+PersonItemID,"ORDITEM",$P(PersonItemID,"||",2),"FEE",ItemFeeSub)),"^",9)
	.s FactAmt=$p($g(^DHCPEPreIADM(+PersonItemID,"ORDITEM",$P(PersonItemID,"||",2),"FEE",ItemFeeSub)),"^",2)
	.s OldAccountAmt=$P(^DHCPEPreA(PAuditDR),"^",6)
	.s OldFactAmt=$P(^DHCPEPreA(PAuditDR),"^",9)
	.s OldFactAmt=$FN((OldFactAmt-FactAmt),"",2)
	.s OldAccountAmt=$FN((OldAccountAmt-AcountAmt),"",2)
	.//更新审核记录的应收、实收金额
	.s $P(^DHCPEPreA(PAuditDR),"^",6)=OldAccountAmt
	.s $P(^DHCPEPreA(PAuditDR),"^",7)=OldFactAmt
	.s $P(^DHCPEPreA(PAuditDR),"^",9)=OldFactAmt
	q:SQLCODE'=0 "-1"
	//处理删除项目，增加限额
	
	//插入体检过程表
	d ##class(web.DHCPE.AdmRecordManager).Insert(+PersonItemID,"P","DeleteItem","","")
	q
		
IDeleteItemErr
	s $ZT=""
	i TStartFlag=1 TROLLBACK
	q "删除项目异常:"_$ZERROR
}
*/

// 返回1：已执行不能删除  2：已收费不能删除 6：已发药不能删除 0：能删除

// 

ClassMethod MayDeleteItem(PersonItemID)
{
	n (PersonItemID)
	s MayFlag=0
	s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",PersonItemID,0))
	i CRMORowId'="" d
	.s OEOrdItemID=$P($g(^DHCPECRMO(CRMORowId)),"^",1)
	.q:OEOrdItemID=""
	.q:'$d(^OEORD($p(OEOrdItemID,"||",1),"I",$P(OEOrdItemID,"||",2),1))
	.s OEORIStat=$p($g(^OEORD($p(OEOrdItemID,"||",1),"I",$P(OEOrdItemID,"||",2),1)),"^",13)
	.s:OEORIStat="6" MayFlag=1  //已执行
	.q:OEORIStat="6"
	.s MayFlag=##class(web.DHCPE.PreItemList).MedicalIsCanDelete(OEOrdItemID)
	q:MayFlag'=0 MayFlag
	s Sub=0
	f  s Sub=$o(^DHCPEPreIADM(+PersonItemID,"ORDITEM",$p(PersonItemID,"||",2),"FEE",Sub)) q:(Sub="")||(MayFlag'=0)  d
	.s AId=$p($g(^DHCPEPreIADM(+PersonItemID,"ORDITEM",$p(PersonItemID,"||",2),"FEE",Sub)),"^",5)
	.q:AId=""
	.s PAStatus=$p($g(^DHCPEPreA(AId)),"^",21)
	.q:PAStatus="NU"
	.s FeeStatus=$p($g(^DHCPEPreA(AId)),"^",14)
	.s:FeeStatus="CHARGED" MayFlag=2  //已收费
	q MayFlag
}

/// w ##class(web.DHCPE.PreItemList2).IDeleteItem("1||1","TEAM^","1||1||5","",1)
ClassMethod IDeleteItem(AdmId As %Library.String = "", AdmType As %Library.String = "", OrdItemId As %Library.String = "", OrdEntId As %Library.String = "", AddAmountFlag As %Library.String = "0", User As %String = "", DeleteStatus As %String = "4") As %String
{
	s ^tempdhcpe("IDeleteItem")=$lb(AdmId,AdmType,OrdItemId,OrdEntId,AddAmountFlag,User,DeleteStatus)
	
	Set retVal=""
	Quit:((AdmType'="PERSON")&&(AdmType'="TEAM")) "ERROR: AdmType must is PERSON/TEAM"
	Quit:((OrdItemId="")&&(OrdEntId="")) "ERROR: Arguments OrdItemId/OrdEntId is null!"
	
	//是否能删除医嘱
	Set Return=##class(web.DHCPE.PreItemList).MayDeleteItem(AdmType,OrdItemId,OrdEntId)   
	Quit:Return Return_"^aaa"
	
	i User="" d
	.s:$D(%session) User=%session.Get("LOGON.USERID")
    s:User="" User=1
    
    s XDate=+$H
    s XTime=$P($H,",",2)
    s ret=""
    s $ZT="IDeleteItemErr"
    s SQLCODE=0
	TSTART
	
	If ("PERSON"=AdmType){  //个人
		i OrdEntId'=""{
			d DeletePersonEnt(OrdEntId)
		}else{
			d DeletePersonItem(OrdItemId,1)
		}
	}else{  //分组
	
		i OrdEntId'=""{
			d DeleteTeamEnt(OrdEntId)
		}else{
			d DeleteTeamItem(OrdItemId)
		}
	}
	//w SQLCODE
	TCOMMIT
	q retVal
IDeleteItemErr	
	TROLLBACK
	Q $G(ret)_"^"_$G(SQLCODE)_$ZERROR
DeleteTeamEnt(TeamEntID)
	&sql(update sqluser.DHC_PE_PreGTOrdEnt set PGTOE_ItemStat='4' where PGTOE_RowId=:TeamEntID)
	q:SQLCODE'=0
	&sql(update sqluser.DHC_PE_PreGTOrdItem set PGTOI_ItemStat='4' where PGTOI_OrdEnt_dr=:TeamEntID)
	q:SQLCODE'=0
	s PIADMRowId=0
	f  s PIADMRowId=$o(^DHCPEPreIADM(0,"GTOE",OrdEntId,PIADMRowId)) q:PIADMRowId=""  d
	.s PIADMStatus=$P($g(^DHCPEPreIADM(PIADMRowId)),"^",8)
	.s PIOECldSub=0
	.f  s PIOECldSub=$o(^DHCPEPreIADM(0,"GTOE",OrdEntId,PIADMRowId,PIOECldSub)) q:PIOECldSub=""  d
	..s PIOERowId=PIADMRowId_"||"_PIOECldSub
	..s ItemStat=$P($g(^DHCPEPreIADM(+PIADMRowId,"ORDENT",PIOECldSub)),"^",9)
	..q:ItemStat'="1"
	..d DeletePersonEnt(PIOERowId)
	q
DeleteTeamItem(TeamItemID)
	&sql(update sqluser.DHC_PE_PreGTOrdItem set PGTOI_ItemStat='4' where PGTOI_RowId=:TeamItemID)
	s PIADMRowId=0
	f  s PIADMRowId=$o(^DHCPEPreIADM(0,"GTOI",TeamItemID,PIADMRowId)) q:(PIADMRowId="")||(SQLCODE'=0)  d
	.s PIOICldSub=0
	.f  s PIOICldSub=$o(^DHCPEPreIADM(0,"GTOI",TeamItemID,PIADMRowId,PIOICldSub)) q:(PIOICldSub="")||(SQLCODE'=0)  d
	..s PIOIRowId=PIADMRowId_"||"_PIOICldSub
	..s OrdItemStatus=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOICldSub)),"^",16)
	..q:OrdItemStatus'="1" 
	..d DeletePersonItem(PIOIRowId,1)
	q
DeletePersonEnt(PreOrdEntId)
	s PreOrAdd=$P($g(^DHCPEPreIADM(+PreOrdEntId,"ORDENT",$P(PreOrdEntId,"||",2))),"^",8)
	s AcountAmt=0
	s ItemSub=0
	f  s ItemSub=$O(^DHCPEPreIADM(0,"OrdEnt",PreOrdEntId,+PreOrdEntId,ItemSub)) q:(ItemSub="")||(SQLCODE'=0)  d
	.s ItemStat=$P($g(^DHCPEPreIADM(+PreOrdEntId,"ORDITEM",ItemSub)),"^",16)
	.q:ItemStat'="1"
	.//s OneAcountAmt=
	.s OneItemID=+PreOrdEntId_"||"_ItemSub
	.s OneFactAmt=$$DeletePersonItem(OneItemID,0)
	.s AcountAmt=AcountAmt+OneFactAmt
	&sql(update sqluser.DHC_PE_PreIOrdEnt set PIOE_ItemStat='4' where PIOE_RowId=:PreOrdEntId)
	q:PreOrAdd="ADD"
	i AddAmountFlag="1" d
	.s SQLCODE=##class(web.DHCPE.PreItemList).ModifyAddAmountApp(+PreOrdEntId,AcountAmt)
	.d ##class(web.DHCPE.PreAudit).UpdateFeeRecord(+PreOrdEntId,"OPAmount")
	q 
DeletePersonItem(PreItemID,ItemAddAmountFlag)
	s OneFactAmt=0
	s OneItemSub=$P(PreItemID,"||",2)
	s ItemStat=$P($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",OneItemSub)),"^",16)
	q:ItemStat'="1" 0
	s PreOrAdd=$P($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",OneItemSub)),"^",15)
	s OEORIStat="1",OEORIRowId=""
	s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",PreItemID,0))
	s PayFlag=""
	i CRMORowId'="" d
	.s OEORIRowId=$p($g(^DHCPECRMO(CRMORowId)),"^",1)
	.s PayFlag=$p($g(^DHCPECRMO(CRMORowId)),"^",4)
	.i OEORIRowId'="" s OEORIStat=$p($g(^OEORD($p(OEORIRowId,"||",1),"I",$p(OEORIRowId,"||",2),1)),"^",13)
	;b ;PayFlag OEORIStat
	
	/**************对于视同收费的药品,停止医嘱时自动生成退药申请start***********/
	s AdmLocID=$P($g(^DHCPEPreIADM(+PreItemID)),"^",26)
    s DrugAplly=0
    i CRMORowId'="" d
    .s Paystatus=$p($g(^DHCPECRMO(CRMORowId)),"^",4)
    .i Paystatus="OC" d
    ..s DrugAplly=##class(web.DHCPE.ItemFeeList).DrugPermControl("1^"_PreItemID,"0","",AdmLocID)
    q:(DrugAplly=2) "-1"
    /**************对于视同收费的药品,停止医嘱时自动生成退药申请end***********/
    
	q:(PayFlag="P")||(PayFlag="PP") 0
	q:OEORIStat="6" 0
	//更新个人预约表的医嘱状态
	&sql(update sqluser.DHC_PE_PreIOrdItem set PIOI_ItemStat=:DeleteStatus where PIOI_RowId=:PreItemID)
	q:SQLCODE'=0 0
	
	//撤销检查申请，更新医嘱表的医嘱状态
	i OEORIRowId'=""{
		
		//撤销检查申请
		d ##class(web.DHCPE.CRM.RisGateway).SendInfo("D",OEORIRowId,User) 
		d ##Class(RISService.InvokeRISService).DiscontinueAppInfoPACS(OEORIRowId,"","D") //停医嘱时,撤销pacs的申请
		
		//更新医嘱表的医嘱状态
		&sql(update sqluser.oe_orditem set Oeori_itemstat_dr='4',Oeori_XDate=:XDate,Oeori_XTime=:XTime where oeori_RowId=:OEORIRowId)
		q:SQLCODE'=0 0
		
		//减药品库存
		d ##class(web.DHCOEDispensing).Return(OEORIRowId) 
		
		//插入项目明细记录
		d ##class(web.DHCPE.ItemDetailRecord).Insert(OEORIRowId,"D","") 
	}
	s PreEntID=$P(^DHCPEPreIADM(+PreItemID,"ORDITEM",OneItemSub),"^",2)
	s ItemFeeSub=0
	f  s ItemFeeSub=$O(^DHCPEPreIADM(+PreItemID,"ORDITEM",OneItemSub,"FEE",ItemFeeSub)) q:(ItemFeeSub="")||(SQLCODE'=0)  d
	.s PAuditDR=$p($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",OneItemSub,"FEE",ItemFeeSub)),"^",5)
	.s ChargedStatus=$p($g(^DHCPEPreA(PAuditDR)),"^",14)
	.q:ChargedStatus="CHARGED"
	.s UserFlag=$p($g(^DHCPEPreA(PAuditDR)),"^",21)
	.q:UserFlag="NU"
	.s ItemFeeID=PreItemID_"||"_ItemFeeSub
	.&SQL(Update Sqluser.DHC_PE_PreIOrdItemFee set PIOIF_PAudit_DR=null where PIOIF_RowID=:ItemFeeID)
	.s AcountAmt=$p($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",OneItemSub,"FEE",ItemFeeSub)),"^",9)
	.s FactAmt=$p($g(^DHCPEPreIADM(+PreItemID,"ORDITEM",OneItemSub,"FEE",ItemFeeSub)),"^",2)
	.s OneFactAmt=OneFactAmt+FactAmt
	.s OldAccountAmt=$P($g(^DHCPEPreA(PAuditDR)),"^",6)
	.s OldFactAmt=$P($g(^DHCPEPreA(PAuditDR)),"^",9)
	.s OldFactAmt=$FN((OldFactAmt-FactAmt),"",2)
	.s OldAccountAmt=$FN((OldAccountAmt-AcountAmt),"",2)
	.s $P(^DHCPEPreA(PAuditDR),"^",6)=OldAccountAmt
	.s $P(^DHCPEPreA(PAuditDR),"^",7)=OldFactAmt
	.s $P(^DHCPEPreA(PAuditDR),"^",9)=OldFactAmt
	.i PreEntID'="" d
	..s OldAccountAmt=$p($g(^DHCPEPreIADM(+PreItemID,"ORDENT",$P(PreEntID,"||",2))),"^",7)
	..s OldAccountAmt=$FN((OldAccountAmt-AcountAmt),"",2)
	..s $p(^DHCPEPreIADM(+PreItemID,"ORDENT",$P(PreEntID,"||",2)),"^",7)=OldAccountAmt
	i PreEntID'="" d
	.s EntFeeSub=+$O(^DHCPEPreIADM(+PreItemID,"ORDENT",$P(PreEntID,"||",2),"FEE",0))
	.i EntFeeSub>0 d
	..Set ret=##class(web.DHCPE.PreItemList).IChangeEntAmount(PreItemID)
	
	//记录停止DHC_PE_PreIOrdItem的时间
	//Set ret=..ItemDelDataEx(PreItemID,"",User)
	d ##class(web.DHCPE.AdmRecordManager).Insert(+PreItemID,"P","DeleteItem",User,PreItemID)
	
	
	
	//q:PreOrAdd="ADD" 0
    i AddAmountFlag="1" d
    .q:ItemAddAmountFlag=0
    .i PreOrAdd'="ADD" s SQLCODE=##class(web.DHCPE.PreItemList).ModifyAddAmountApp(+PreItemID,OneFactAmt) //ADD的不增加限额
    .d ##class(web.DHCPE.PreAudit).UpdateFeeRecord(+PreItemID,"OPAmount")
    
    i AddAmountFlag="0" d
    .q:PreOrAdd'="ADD"
    .d ##class(web.DHCPE.PreAudit).UpdateFeeRecord(+PreItemID,"OPAmount")
	
	
	
	q OneFactAmt
}

}

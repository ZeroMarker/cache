/// modified by ZY0273 20210707 对变量进行初始化处理
Class web.DHCEQ.EM.BUSArrive Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modefied by ZY0260 20210428
/// w ##Class(web.DHCEQContractNew).SaveArriveRecord("1","1^119^1^120^1$CHAR(3)1^119^1^121^2","1")
ClassMethod SaveArriveRecord(val As %String = "", valList, sysflag As %Library.String = "")
{
	new User,Date,Time,rowid,ID
	Set $ZT="ERRORSaveArriveRecord"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	s Date=+$H
	s Time=$P($H,",",2)

	s PLISTA(3)=$p(val,"^",1)   //供应商
	s PLISTA(4)=Date         //$p(val,"^",2)  到货日期
	/*后期新增界面用
	s PLISTA(5)=$p(val,"^",3)    //送货人
	s PLISTA(6)=$p(val,"^",4)    //送货联系人
	s PLISTA(7)=$p(val,"^",5)    //送货人联系电话
	s PLISTA(8)=$p(val,"^",6)    //接收人
	s PLISTA(9)=$p(val,"^",7)    //接收地点
	s PLISTA(10)=$p(val,"^",8)   //包装总件数
	*/
	s PLISTA(15)=User   //
	s PLISTA(16)=Date   //
	s PLISTA(17)=Time   //
	TSTART	
	;s PLIST(1)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQArrive",Date)
	&SQL(Insert Into SQLUSER.DHC_EQArrive Values :PLISTA())
	if SQLCODE
 	{
	 	TROLLBACK
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 	}
 	s rowid=$G(%ROWID)
 	s ID=rowid
	//modified by ZY0252 20210301
 	s SQLCODE=##Class(web.DHCEQ.EM.BUSArrive).SaveArriveList(ID,valList,sysflag )	// MZY0058	2020-10-18
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ID)
ERRORSaveArriveRecord
 	TROLLBACK		         //回滚事务
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorMsg)
}

// modified by ZY0252 20210301

ClassMethod SaveArriveList(ArriveID, val, sysflag)
{
	//modified by ZY0252 20210301
	new Length,ALRowID,ContractListID,OpenCheckRequestID,ID,Flag,i
	k PLISTAL
	i ArriveID="" q ""
	s PLISTAL(2)=ArriveID  				;ArriveDR
	/// modefied by ZY0260 20210428
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s Length=$l(val,SplitRowCode)
	s Flag=0
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=$p(val,SplitRowCode,i)
		;保存到货明细
		s PLISTAL(3)=$p(valList,"^",1)    //1:合同明细
		s PLISTAL(4)=$p(valList,"^",2)         //对应业务ID   1：合同明细ID;
		s ContractListID=$p(valList,"^",2)
		s PLISTAL(5)= $p(valList,"^",3)   //2  到货数量 $p(val,"^",9)
		s ArriveListNum=$p(valList,"^",3)
		/*后期新增界面用 
		s PLISTAL(6)= $p(valList,"^",10)    //包装数量
		s PLISTAL(7)= $p(valList,"^",11)   //存放地点
		*/
		s PLISTAL(8)="1"               //到货状态
		s PLISTAL(10)="N"
		/*后期新增界面用
		s PLISTAL(14)= $p(valList,"^",12)   //验收组
		s PLISTAL(15)= $p(valList,"^",13)  //验收人
		*/
		//modified by ZY0252 20210301
		s ContractListLocID=$p(valList,"^",4)
		s PLISTAL(17)=$p(valList,"^",4)
		s ArriveLocDR=$p(valList,"^",5)
		/// modefied end by ZY0260 20210428
		/*
		if (ContractListLocID'="")
		{
		 	&SQL(update SQLUSER.DHC_EQContractListLoc set CLL_ArrivedQuantity=:ArriveListNum where CLL_RowID=:ContractListLocID)
			i SQLCODE
	 		{
				s Flag=SQLCODE
	 		}
		}
	 	q:Flag'=0
	 	*/
	 	&SQL(Insert Into SQLUSER.DHC_EQArriveList Values :PLISTAL())
		i SQLCODE
 		{
			s Flag=SQLCODE
 		}
 		q:Flag'=0
 		s ALRowID=$G(%ROWID)
 		s ID=ALRowID
		/// modefied by ZY0260 20210428
	    s OpenCheckRequestID=##Class(web.DHCEQ.EM.BUSArrive).SaveOpenCheckRequest(ContractListID,ArriveListNum,ArriveLocDR,sysflag)
		i OpenCheckRequestID'>0
 		{
			s Flag=OpenCheckRequestID
 		}
 		q:Flag'=0
		/// modefied by ZY0260 20210428
 		/*
 		//Modify By QW 2017-07-20 通知验收不提交
		//modified by ZY0221 202-04-14
		s OpenCheckRequestID= ##Class(web.DHCEQ.EM.BUSArrive).SubmitOpenCheckRequest(OpenCheckRequestID)
		i OpenCheckRequestID'>0
 		{
			s Flag=OpenCheckRequestID
 		}
 		q:Flag'=0
 		*/
 		//
 		if ID'=""
		{
			//modofied by zy ZY0206   合同到货发送到验收单逻辑错误
			s OpenCheckListID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OpenCheckRequestID,0))
 			&SQL(Update SQLUSER.DHC_EQArriveList Set AL_OpenCheckListDR=:OpenCheckListID where AL_RowID=:ID)
	 		i SQLCODE
	 		{
				s Flag=SQLCODE
	 		}
		}
 		q:Flag'=0
	}
	q Flag
}

/// modefied by ZY0260 20210428
/// modified by ZY0252 20210301
/// modified by ZY0221 2020-04-14 取值错误
/// w ##Class(web.DHCEQContractNew).SaveOpenCheckRequest(6,1)
ClassMethod SaveOpenCheckRequest(ContractListID, ArriveListNum, ArriveLocDR As %Library.String = "", sysflag As %Library.String = "")
{
	new val,TContractDR,TContractNo,TItemDR,TGuaranteePeriodNum,TDepreMethodDR,TLimitYears,TOriginDR,TExpendituresDR
	new TProviderDR,TProviderHandler,TProviderTel,TServiceDR,TServiceHandler,TServiceTel,TEquipCatDR,TStatCatDR,TEquipTypeDR,TUnitDR,TName,TCode
	new TFileNo
	i ContractListID="" q -1
	s (val,TContractDR,TContractNo,TItemDR,TGuaranteePeriodNum,TDepreMethodDR,TLimitYears,TOriginDR,TExpendituresDR)=""
	s (TProviderDR,TProviderHandler,TProviderTel,TServiceDR,TServiceHandler,TServiceTel,TEquipCatDR,TStatCatDR,TEquipTypeDR,TUnitDR,TName,TCode)=""
	s TFileNo=""
	s result= ^DHCEQContractList(ContractListID)
	s TContractDR=$p(result,"^",1)
	s TContractNo=$p($g(^DHCEQContract(TContractDR)),"^",2)
	s TProviderDR=$p($g(^DHCEQContract(TContractDR)),"^",18)
	s TProviderHandler=$P($G(^DHCEQContract(TContractDR)),"^",20)
	s TProviderTel=$P($G(^DHCEQContract(TContractDR)),"^",19)
	s TServiceDR=$p($G(^DHCEQContract(TContractDR)),"^",36)
	s TServiceHandler=$P($G(^DHCEQContract(TContractDR)),"^",37)
	s TServiceTel=$P($G(^DHCEQContract(TContractDR)),"^",38)
	s TGuaranteePeriodNum=$p(result,"^",16)     ;  CTL_Hold6->保修期 $Piece($Get(^DHCEQContract(TContractDR)),"^",23)
	s TExpendituresDR=$Piece($Get(^DHCEQContract(TContractDR)),"^",23)
	s TDepreMethodDR=##class(web.DHCEQCommon).GetSysInfo(301002)
	s TOriginDR=##class(web.DHCEQCommon).GetSysInfo(301008)
	s TItemDR=$p(result,"^",18)
	i TItemDR'="" d
	.s TUnitDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)
	.s TName=$P($G(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	.s TCode=$P($G(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",2)
	.s TStatCatDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",5) //2009-11-25 党军 DJ0037
	.s TEquipTypeDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",3)
	.s TEquipCatDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",4)
	s TLimitYears=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TEquipCatDR,TStatCatDR)
	s TPurchaseTypeDR=##class(web.DHCEQCommon).GetSysInfo(301009)
	s TFileNo=$P($G(^DHCEQContract(TContractDR)),"^",52)  //add by sjh 2019-10-31  BUG00016
	//add by ZY0213
	s (UseLocDR,BuyRequestListID,BuyRequestID)=""
	//"1":"计划","2":"招标","3":"设备项","4":"设备","5":"入库明细","":""
	s SourceType = $p(result,"^",5)
	s SourceID = $p(result,"^",17)
	i SourceType=1 d
	.s BuyRequestListID=$Piece($Get(^DHCEQBuyPlanList(SourceID)),"^",10)
	e  i SourceType=2 d
	.//0：设备项 1采购申请 2采购计划
	.s SourceType=$Piece($Get(^DHCEQIFBBag(SourceID)),"^",9)
	.s SourceID=$Piece($Get(^DHCEQIFBBag(SourceID)),"^",10)
	.i SourceType=1 d
	..s BuyRequestListID=SourceID
	.e  i SourceType=2  d
	..s BuyRequestListID=$Piece($Get(^DHCEQBuyPlanList(SourceID)),"^",10)
	i BuyRequestListID'="" s BuyRequestID=$Piece($Get(^DHCEQBuyRequestList(BuyRequestListID)),"^",1)
	i BuyRequestID'="" s UseLocDR=$Piece($Get(^DHCEQBuyRequest(BuyRequestID)),"^",4)
	//end by ZY0213
	/// modified by ZY0252 20210301
	i ArriveLocDR'="" s UseLocDR=ArriveLocDR
	
    s val=val_"^"_TName  //2
    s val=val_"^"_TCode //3
    s val=val_"^"_TPurchaseTypeDR  //4
    s val=val_"^"_TEquipTypeDR  //5
    s val=val_"^"_TStatCatDR  //6
    s val=val_"^"_TEquipCatDR  //7
    s val=val_"^^"_$P($G(^DHCEQContract(TContractDR)),"^",48)  //9 采购方式 add by wy 2021-11-05
    s val=val_"^^^^"_TUnitDR  //13
	s val=val_"^"_$p(result,"^",3)  //14  规格            	//modified by ZY0241 获取合同的机型 	
    s val=val_"^"_""  //15   国别
    //s val=val_"^^"_$p(result,"^",7)  //17 验收数量为到货数量需要从到货记录中获取
    s val=val_"^^"_ArriveListNum  //验收数量为到货数量需要从到货记录中获取
    s val=val_"^^^"_TProviderDR //20    供应商          	
    s val=val_"^"_TProviderHandler  //21  供应商联系人
    s val=val_"^"_TProviderTel  //22       供应商联系电话
    s val=val_"^"_$p(result,"^",4) // 生产产商         	
    s val=val_"^^"_""  //25  出厂日期
    s val=val_"^"_TServiceDR  //26   服务商
    s val=val_"^^"_$p(result,"^",16) 	///	保修期
    s val=val_"^"_$p(result,"^",6) //29 原值
    s val=val_"^^"_TOriginDR  //31  设备来源
    s val=val_"^"_UseLocDR	//$p(result,"^",20) //32  使用科室	modified by ZY0213
    s val=val_"^"_TLimitYears  //33  使用年限
    s val=val_"^"_TDepreMethodDR  //34  折旧方法
    s val=val_"^^^^^^^^^^^^^^^^^^^^^^^"_ContractListID    //57 ContractListID
    s val=val_"^"_TContractNo    //58 合同号
    s val=val_"^"_"0"  //59      验收类型
    s val=val_"^^^"_TItemDR  //62  设备项
    s LeaveFactoryNo=""
    s CLLRowID=$o(^DHCEQContractListLoc(0,"ContractList",ContractListID,0))
    if CLLRowID'="" s LeaveFactoryNo=$p($g(^DHCEQContractListLoc(CLLRowID)),"^",8)
    s val=val_"^^"_LeaveFactoryNo   //64 出厂编号 add by wy 2021-11-05
    s val=val_"^^"_$p(result,"^",24)     //注册证号  modified by sjh 2019-10-31 BUG00016
    s val=val_"^^^"_TExpendituresDR  //69	经费来源需要从合同来
    s val=val_"^^^^"_1 //68  sourcetype
    s val=val_"^"_ContractListID   //69 sourceid
    s val=val_"^^^^"_TServiceHandler  //78  服务商联系人
    s val=val_"^"_TServiceTel  ///  79服务商联系电话
    s val=val_"^^"_$p(result,"^",2) //81  商用名
  	s val=val_"^^^^"_"0"  //85 入账形式
  	s val=val_"^^^^^^^^"
	s val=val_TFileNo  //add by sjh 2019-10-31 BUG00016
	///modified by ZY0269 20210615
    ///modified by ZY20230105 bug:3159748
    s result=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).SaveData(val, 2,"","","Y",sysflag)
    
    s result=##class(web.DHCEQ.Plat.LIBCommon).StringToJson(result)    // modified by ZY0307 发现的bug
    s SQLCODE=result.SQLCODE
    i SQLCODE=0 q result.Data
    
    q SQLCODE
}

/// modefied by ZY0260 20210428
ClassMethod SubmitOpenCheckRequest(rowid As %Library.String = "")
{
	///modified by ZY0269 20210615
	s OCRRowID=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).SubmitData(rowid,0,0,"","Y")
	q OCRRowID
}

}

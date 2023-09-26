Class web.DHCEQ.EM.BUSOpenCheckRequest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Modified By QW20200108 BUG:QW0035 增加入参CurRole,Action
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).GetOneOpenCheckRequest(1487,7)
ClassMethod GetOneOpenCheckRequest(RowID As %Library.String = "", CurRole As %Library.String = "", Action As %Library.String = "")
{
	s $ZT="ERRORGetOneOpenCheckRequest"
	s Obj=##Class(User.DHCEQOpenCheckRequest).%OpenId(RowID)
	s DataInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(Obj)
	d DataInfo.%Set("OCREquipTypeDR_ETDesc",Obj.OCREquipTypeDR.ETDesc)
	d DataInfo.%Set("OCRPurchaseTypeDR_PTDesc",Obj.OCRPurchaseTypeDR.PTDesc)
	d DataInfo.%Set("OCRStatCatDR_SCDesc",Obj.OCRStatCatDR.SCDesc)
	d DataInfo.%Set("OCRProviderDR_VDesc",Obj.OCRProviderDR.VName)
	d DataInfo.%Set("OCROriginDR_ODesc",Obj.OCROriginDR.ODesc)
    //Add By QW20200108 BUG:QW0035 begin 增加输出
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("7",RowID)
	d DataInfo.%Set("AIRowID",$p(AppInfo,"^",1))
	d DataInfo.%Set("ApproveSetDR",$p(AppInfo,"^",2))
	d DataInfo.%Set("NextRoleDR",$p(AppInfo,"^",3))
	d DataInfo.%Set("NextFlowStep",$p(AppInfo,"^",4))
	d DataInfo.%Set("ApproveStatus",$p(AppInfo,"^",5))
	d DataInfo.%Set("ApproveRoleDR",$p(AppInfo,"^",6))
	d DataInfo.%Set("CancelFlag",$p(AppInfo,"^",7))
	d DataInfo.%Set("CancelToFlowDR",$p(AppInfo,"^",8))
	d DataInfo.%Set("ApproveRole",$p(AppInfo,"^",9))
	d DataInfo.%Set("NextRole",$p(AppInfo,"^",10))
	s RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(##class(web.DHCEQApproveList).GetApproveSet("7",RowID),CurRole,Action)
	d DataInfo.%Set("RoleStep",RoleStep)
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("7")
	Set Opinion=##Class(web.DHCEQApproveList).GetApproveListOpinion(ApproveType, RowID)
	d DataInfo.%Set("OpinionRecords",Opinion)
	d DataInfo.%Set("Status",DataInfo.OCRStatus)
    //Add By QW20200108 BUG:QW0035 end
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,DataInfo)
ERRORGetOneOpenCheckRequest
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// modified  by ZY  2849944  20220815  验收保存时先根据取临时资金来源信息,进行保存操作
/// modified by ZY0274 合同到货通知的时候去掉事务,同时增加变量初始化处理
/// add by zy 20190924
/// w ##class(web.DHCEQ.EM.BUSOpenCheckRequest).SaveData("1^联想电脑^ＬＸＤＮ^1^2^8^354^^^^^^4^^^^10^^^1^^^2^^^^^12^5000^^1^^6^1^^^^^^^^^^^^^^^^^^^^^^^^^0^2022-11-08^2022-11-08^1^0^^^^^^^^^^0^1^^YS2022110001^2^^^^联想电脑^^^^^^^^^^^^^^^^^^^^250^^^0^^^^^^^^^^^^^^^^^^^","2","","","","","")
/// Modefied by zc0125 2022-12-12 添加盘盈id入参
ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "", Info As %Library.String = "", EquipAttribute As %Library.String = "", NoTranFlag As %Library.String = "", sysflag As %Library.String = "", EquipAttributeStringCat As %String = "", InventoryExceptionDR As %String = "")
{
    new OCRRowID,User,Date,CurRole,InvalidFlag,i,SQLCODE
    k PLIST,PLISTMX
    
    s SQLCODE=0
    s OCRRowID=$p(val,"^",1)
    s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    s CurLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))	//czf 2023-02-15
    s Date=+$H
    s Time=$P($H,",",2)
    s CurRole=$p(val,"^",3) 
     //2011-10-31 DJ DJ0098
    i OCRRowID'=""
    {
        s InvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
        i InvalidFlag="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1015,"单据已无效")
    }
    i NoTranFlag'="Y" Set $ZT="ERROR" //2009-07-10 党军

	;Modified by jdl 2011-3-8  jdl0073
	i NoTranFlag'="Y" TSTART
	if (+isDel=1) //删除
	{
		//恢复修改前面关联业务的数据
		&SQL(Update SQLUSER.DHC_EQOpenCheckRequest set OCR_InvalidFlag='Y',OCR_CancelUser=:User,OCR_CancelDate=:Date,OCR_CancelTime=:Time where OCR_RowID=:OCRRowID)
		if SQLCODE
		{
			i NoTranFlag'="Y" TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收单删除失败!"_$g(%msg))
		}
	 	s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	 	s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	 	s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
	 	s OCLNum=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
		//modified by ZY0252  20210301
	 	s OCLUseLocDR=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",33)
	 	if OCLSourceID'=""
	 	{
			s SQLCODE=##Class(web.DHCEQOpenCheckRequest).SourceUpdate(OCLSourceType,OCLSourceID,OCLNum,2,OCLUseLocDR)
			if SQLCODE
			{
				i NoTranFlag'="Y" TROLLBACK
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收科室明细删除失败!"_$g(%msg))
			}
	 	}
		//modofied by zy ZY0206 begin  合同到货发送到验收单逻辑错误
		//恢复到货记录明细表的数据
		&SQL(Update SQLUSER.DHC_EQArriveList set AL_Status='0',AL_CancelArriveUserDR=:User,AL_CancelArriveDate=:Date,AL_CancelArriveTime=:Time where AL_OpenCheckListDR=:OCLRowID)
		i SQLCODE=100 s SQLCODE=0	//add by czf 1227961 2020-03-16
		if SQLCODE
		{
			i NoTranFlag'="Y" TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"到货明细更新失败!"_$g(%msg))
		}
		
		s OCLRowID=""	//设置方法返回值
	}
	elseif (+isDel=2) //新增,更新
	{
		 /************设备批量审批总单****************/
	 	s PLIST(2)=$p(val,"^",59) 
	 	s PLIST(3)=$p(val,"^",5)
	 	s PLIST(4)=$p(val,"^",4)
	 	s PLIST(5)=$p(val,"^",6)
	 	s PLIST(6)=$p(val,"^",20)   ;Provider
	 	s PLIST(7)=$p(val,"^",21)
	 	s PLIST(8)=$p(val,"^",22)
	 	s PLIST(9)=$p(val,"^",31)
	 	s PLIST(10)=$p(val,"^",41)
	 	;20150807  Mozy0157
	 	s PLIST(11) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",61),"date")
	 	s PLIST(12) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",60),"date")
	 	s PLIST(13)=$p(val,"^",53)
	 	s PLIST(14)=$p(val,"^",50)
	 	s PLIST(15)=$p(val,"^",51)
	 	s PLIST(16)=$p(val,"^",47)
	 	s PLIST(17)=$p(val,"^",56)
	 	s PLIST(18)=$p(val,"^",52)
	 	s PLIST(19)=$p(val,"^",48)
	 	s PLIST(20)=$p(val,"^",49)
	 	s PLIST(21)="0"
	 	s PLIST(22)=$p(val,"^",55)
	 	s PLIST(29)=$p(val,"^",54)
	 	//s PLIST(38)=$p(val,"^",76)		//RequestHold1  存验收单号
	 	s PLIST(39)=$p(val,"^",77)		//RequestHold2 		存医院ID czf 2021-09-01
	 	i PLIST(39)="" s PLIST(39)=%session.Get("LOGON.HOSPID")
	 	i PLIST(39)="" q -1200
	 	s PLIST(40)=User	//$p(val,"^",78)		//RequestHold3	updateUser czf 2022-10-25 begin
	 	s PLIST(41)=Date	//$p(val,"^",79)		//RequestHold4  updateDate
	 	s PLIST(42)=Time	//$p(val,"^",80)		//RequestHold5	updateTime czf 2022-10-25 end
	 	s PLIST(46)="N"					//InvalidFlag
	 	/************设备批量审批细单****************/
	 	s PLISTMX(3)=$p(val,"^",81)		//2013-06-24 DJ0118
	 	s PLISTMX(4)=$p(val,"^",5)
	 	s PLISTMX(5)=$p(val,"^",11)
	 	s PLISTMX(6)=$p(val,"^",14)
	 	s PLISTMX(7)=$p(val,"^",7)
	 	s PLISTMX(8)=$p(val,"^",13)
	 	s PLISTMX(9)=$p(val,"^",3)
	 	s PLISTMX(10)=$p(val,"^",62)
	 	s PLISTMX(11) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",24),"date")	;20150807  Mozy0157
	 	s PLISTMX(12)=$p(val,"^",15)
	 	//s PLISTMX(13)=""
	 	s PLISTMX(14)=$p(val,"^",9)
	 	//s PLISTMX(15)=""
	 	s PLISTMX(16)=$p(val,"^",23)      ;ManuFactory
	 	s PLISTMX(17)=$p(val,"^",17)
	 	s PLISTMX(18)=$p(val,"^",29)
	 	s PLISTMX(19)=$p(val,"^",30)
	 	s NetRemainRate=+##class(web.DHCEQCommon).GetSysInfo("990029")		//czf 1750408 2021-02-09
	 	i $p(val,"^",30)="" s PLISTMX(19)=$p(val,"^",29)*NetRemainRate/100
	 	s PLISTMX(20)=$p(val,"^",33)
	 	s PLISTMX(21)=$p(val,"^",34)
	 	s PLISTMX(22)=$p(val,"^",16)
	 	s PLISTMX(23)=$p(val,"^",8)
	 	s PLISTMX(24)=$p(val,"^",4)
	 	s PLISTMX(25)=$p(val,"^",18)
	 	s PLISTMX(26)=$p(val,"^",26)
	 	s PLISTMX(27)=$p(val,"^",27)
	 	s PLISTMX(28)=$p(val,"^",28)
	 	s PLISTMX(29)=$p(val,"^",6)
	 	s PLISTMX(30)=$p(val,"^",37)
	 	s PLISTMX(31)=$p(val,"^",38)
	 	s PLISTMX(32)=$p(val,"^",10)
	 	//s PLISTMX(33)=CurLocDR		//czf 2023-02-15 ManageLocDR
	 	s PLISTMX(34)=$p(val,"^",32)
	 	s PLISTMX(35)=$p(val,"^",55)
	 	s PLISTMX(36)=$p(val,"^",19)
	 	s PLISTMX(37)=$p(val,"^",58)
	 	s PLISTMX(38)=$p(val,"^",57)
	 	;20150807  Mozy0157
	 	i $p(val,"^",45)'=""  s PLISTMX(39) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",45),"bool") ;
	 	i $p(val,"^",44)'=""  s PLISTMX(40) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",44),"bool") ;
	 	i $p(val,"^",46)'=""  s PLISTMX(41) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",46),"bool") ;
	 	i $p(val,"^",43)'=""  s PLISTMX(42) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",43),"bool") ;
	 	i $p(val,"^",42)'=""  s PLISTMX(43) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",42),"bool") ;
	 	s PLISTMX(44) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",39),"date")
	 	s PLISTMX(45) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",40),"date")
	 	s PLISTMX(46) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",61),"date")
	 	s PLISTMX(47) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",60),"date")
	 	s PLISTMX(48)=$p(val,"^",36)
	 	s PLISTMX(49) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",35),"date")
	 	s PLISTMX(50) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",25),"date")
	 	
		s PLISTMX(51)=$p(val,"^",12) 
		//Add ZY 2009-10-30 ZY0014 
		s PLISTMX(56)=$p(val,"^",65)  
		s PLISTMX(57)=$p(val,"^",66)  
		s PLISTMX(58)=$p(val,"^",67)  
		s PLISTMX(59)=$p(val,"^",68)  
		s PLISTMX(60)=$p(val,"^",69) 
		//End ZY 2009-10-30 ZY0014 
		s LeaveFactoryIDs=$TRANSLATE($p(val,"^",64),"，",",")	//201702-04	Mozy
		/********************************************/ //2009-11-25 党军 begin DJ0037
		i $p(val,"^",70)'=""  s PLISTMX(61) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",70),"bool") ;
		i $p(val,"^",71)'=""  s PLISTMX(62) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",71),"bool") ;
		i $p(val,"^",72)'=""  s PLISTMX(63) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",72),"bool") ;
		s PLISTMX(64)=$p(val,"^",73) ;sourcetype
		s PLISTMX(65)=$p(val,"^",74) ;sourceid
		s PLISTMX(66)=$p(val,"^",75)
		
		//add by GBX 2014-11-18
		s PLISTMX(67)=$p(val,"^",82)  //价值类型
		s PLISTMX(68)=$p(val,"^",83)  //使用方向
		s PLISTMX(69)=$p(val,"^",84)  //UserDR
		//modify by QW0008 通过系统配置来设置入账形式的值
		s AccountShapeFlag=+##class(web.DHCEQCommon).GetSysInfo("990057")
		i AccountShapeFlag=1 s PLISTMX(70)="0"  //入账形式
		else  s PLISTMX(70)=$p(val,"^",85)  //入账形式
		//End  by QW0008
		s PLISTMX(71)=$p(val,"^",86)  //项目预算编号
		//end by GBX 2014-11-18
		//add by GBX 2014-11-24
		s PLISTMX(72)=$p(val,"^",87)  //会计凭证号
		//end by GBX 2014-11-24
		i $p(val,"^",88)'="" s PLISTMX(73) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",88),"bool")	//Hold6		放射标志
		i $p(val,"^",89)'="" s PLISTMX(74) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",89),"bool")	//Hold7		中医标志	//Modify DJ 2017-01-20
		s PLISTMX(75)=$p(val,"^",90)  //Hold8	编制情况
		s PLISTMX(76)=$p(val,"^",91)  //Hold9
		s PLISTMX(77)=$p(val,"^",92)  //Hold10
		s FileNo=$TRANSLATE($p(val,"^",93),"，",",")	//201702-04	Mozy
		/// 2018-05-18 Modified By ZY ZY0169	// Mozy0217  2018-11-01
		s PLISTMX(78)=$p(val,"^",94)  //OCL_ServiceHandler
		s PLISTMX(79)=$p(val,"^",95)  //OCL_ServiceTel
		s PLISTMX(80)=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",96),"date")  //OCL_MeasureDate
		s PLISTMX(81)=$p(val,"^",97)  //OCL_MeasureNos
		s PLISTMX(82)=$p(val,"^",98)  //OCL_SalesManager		//Mozy	2018-5-15
		s PLISTMX(83)=$p(val,"^",99)  //OCL_SalesManagerTel	//Mozy	2018-5-15
		s PLISTMX(84)=$p(val,"^",100)  //OCL_Hold11	产地 	//zy	2018-5-15
		s PLISTMX(85)=$p(val,"^",101)  //OCL_Hold12	功率 	//zy	2018-5-15
		s PLISTMX(86)=$p(val,"^",102)  //OCL_Hold13	保管人 		//zy	2018-5-15
		s PLISTMX(87)=$p(val,"^",103)  //OCL_Hold14	招标编号  //zy	2018-5-15
		s PLISTMX(88)=$p(val,"^",104)  //OCL_Hold15->IsInstall	是否安装//zy	2018-5-15
		
		//MFHandler=$p(val,"^",105) MFTel=$p(val,"^",106) TempBar=$p(val,"^",107)
		s PLISTMX(89)=$p(val,"^",108)  //OCL_ConfigLicense
		s PLISTMX(90)=$p(val,"^",109)  //OCL_NewOldPercent
		s PLISTMX(91)=$p(val,"^",110)  //OCL_Voltage
		s PLISTMX(92)=$p(val,"^",111)  //OCL_Electriccurrent
		s PLISTMX(93)=$p(val,"^",112)  //OCL_UseYearsNum
		s PLISTMX(94)=$p(val,"^",113)  //OCL_Note
		s PLISTMX(95)=$p(val,"^",114)  //OCL_MaintNote
		s PLISTMX(96)=$p(val,"^",115)  //OCL_Hold16
		s PLISTMX(97)=$p(val,"^",116)  //OCL_Hold17
		s PLISTMX(98)=$p(val,"^",117)  //OCL_Hold18
		s PLISTMX(99)=$p(val,"^",118)  //OCL_Hold19
		s PLISTMX(100)=$p(val,"^",119)  //OCL_Hold20
		
		s PLISTMX(101)=$p(val,"^",120)  //OCL_AuthorizeDeptDR
		s PLISTMX(102)=$p(val,"^",121)  //OCL_UseSubjectDR
		s PLISTMX(103)=$p(val,"^",122)  //OCL_BuyModeDR
		s PLISTMX(104)=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",123),"date")  //OCL_AccountDate
		s PLISTMX(105)=$p(val,"^",124)  //OCL_ManageUserDR
		s PLISTMX(106)=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",125),"date")	//OCL_PurchaseDate
		s PLISTMX(109)=$p(val,"^",126)	//OCL_ManageCat add by txr 20230417
		
	 	/********************************************/ //2009-11-25 党军 end DJ0037
	 	i (OCRRowID="")  //新增按钮操作
	 	{
			s PLIST(38)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQOpenCheckRequest",Date,"",$p(val,"^",5))
		 	&SQL(Insert Into SQLUSER.DHC_EQOpenCheckRequest Values :PLIST())
		 	if SQLCODE
		 	{
				i NoTranFlag'="Y" TROLLBACK
			 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收单插入失败!"_$g(%msg))
		 	}
		 	s OCRRowID=$G(%ROWID)
		 	s PLISTMX(2)=OCRRowID
		 	&SQL(Insert Into SQLUSER.DHC_EQOpenCheckList Values :PLISTMX())
		 	if SQLCODE
		 	{
			 	i NoTranFlag'="Y" TROLLBACK
			 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收明细插入失败!"_$g(%msg))
			}
			s OCLRowID=$G(%ROWID) //2009-08-17 党军
			// Mozy		20181123 把合同明细对应的DHC_EQCContractConfig的内容写到验收单明细对应的表中/DHC_EQAffix/DHC_EQDoc/DHC_EQConfig
			if (PLISTMX(64)=1)||(PLISTMX(64)=4)
			{
				Set SQLCODE=##Class(web.DHCEQContractConfig).SaveConfigBySource(PLISTMX(65),OCLRowID)
				if SQLCODE
				{
					i NoTranFlag'="Y" TROLLBACK
					Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"合同明细附件、附属设备信息生成失败!"_$g(%msg))
				}
			}
            ///modified  by ZY  2849944  20220815 在生成验收单前写的资金数据,根据临时ID改写成正式的资金数据
            s TmpSourceID=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).GetCurSourceID("11")	//czf 2895287 2022-09-06
            &SQL(Update SQLUSER.DHC_EQFunds set F_CheckListDR=:OCLRowID,F_SourceID=:OCLRowID where F_SourceType='0' and F_SourceID=:TmpSourceID)
            i SQLCODE=100 s SQLCODE=0
            if SQLCODE
            {
                i NoTranFlag'="Y" TROLLBACK
                q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"资金来源生成失败!"_$g(%msg))
            }
 		}
 		else  //更新按钮操作
 		{
		 	&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Values :PLIST() where OCR_RowID=:OCRRowID)
		 	if SQLCODE
		 	{
				i NoTranFlag'="Y" TROLLBACK
			 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收单保存失败!"_$g(%msg))
		 	}
		 	///先减掉验收单对应的数量
		 	s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
		 	s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
		 	s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
		 	///add by ZY0271 20210617
		 	///保存的时候,如果来源变化了需要删除
		 	if (OCLSourceID'=PLISTMX(65)&&(OCLSourceID'=""))
		 	{
			 	///来源合同变化,删除信息旧存数据
			 	if (OCLSourceType=1)
			 	{
					&SQL(delete from SQLUSER.DHC_EQOpenCheckListLoc  where OCLL_OpenCheckListDR=:OCLRowID)
					if SQLCODE=100 s SQLCODE=0
					if SQLCODE
					{
						TROLLBACK
						q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收科室明细删除失败!"_$g(%msg))
					}
				}
			}
		 	
		 	s OCLNum=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
			//modified by ZY0268  20210611
		 	s OCLUseLocDR=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",33)
		 	i OCLSourceID'=""
		 	{
				s SQLCODE=##Class(web.DHCEQOpenCheckRequest).SourceUpdate(OCLSourceType,OCLSourceID,OCLNum,2,OCLUseLocDR)
				if SQLCODE
				{
					i NoTranFlag'="Y" TROLLBACK
					q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收单资金来源保存失败!"_$g(%msg))
				}
		 	}
			;CZF 1983205 2021-06-11 begin
			;前后来源类型或来源名不一致时删除旧的资金来源记录
			s NewSourceType=PLISTMX(64)
	 		s NewSourceID=PLISTMX(65)
	 		i (OCLSourceType'=NewSourceType)||(OCLSourceID'=NewSourceID)
	 		{
		 		i (OCLSourceType=1)||(NewSourceType=1){		//涉及合同变更才删除
			 		&SQL(delete SQLUSER.DHC_EQFunds where F_SourceType=0 and F_SourceID=:OCLRowID and F_InvalidFlag='N')
					i SQLCODE=100 s SQLCODE=0
		 		}		 		
		 	}
		 	if SQLCODE
		 	{
				i NoTranFlag'="Y" TROLLBACK
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"旧资金来源删除失败!"_$g(%msg))
			}
			;CZF 1983205 2021-06-11 end
			
		 	&SQL(Update SQLUSER.DHC_EQOpenCheckList Values :PLISTMX() where OCL_OpenCheckRequestDR=:OCRRowID)
		 	if SQLCODE
		 	{
				i NoTranFlag'="Y" TROLLBACK
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收明细更新失败!"_$g(%msg))
			}
			s OCLRowID=$G(%ROWID)
 		}
 		//Modefied by zc0125 2022-12-12 增加盘盈业务信息记录 begin
 		s SQLCODE=##Class(web.DHCEQ.EM.BUSInventory).SaveBussInfoByInventory(InventoryExceptionDR,"",11,OCRRowID)
 		if SQLCODE
		{
			i NoTranFlag'="Y" TROLLBACK
			q SQLCODE
		}
		//Modefied by zc0125 2022-12-12 增加盘盈业务信息记录 end
		s ^DHCEQOpenCheckList(OCLRowID,"EX")=LeaveFactoryIDs //2009-08-17 党军
		s ^DHCEQOpenCheckList(OCLRowID,"FileNo")=FileNo	//20150819  Mozy0159
		s ^DHCEQOpenCheckList(OCLRowID,"MFInfo")=$p(val,"^",105)_"^"_$p(val,"^",106)	// MZY0070	1756493		2021-02-20
	 	s ^DHCEQOpenCheckList(OCLRowID,"TempBar")=$TRANSLATE($p(val,"^",107),"，",",")		// MZY0074	1904154		2021-04-30
		;add by czf 20200911 begin CZF0128
		s FileNoSelfFlag=##class(web.DHCEQCommon).GetSysInfo("990059")		//档案号自动生成 0:不启用 1:启用
		i (FileNoSelfFlag=1)
		{
			s FileNoStr=$g(^DHCEQOpenCheckList(OCLRowID,"FileNo"))
			i FileNoStr="" d
			.s BeginNum=1
			e  d
			.s BeginNum=$L(FileNoStr,",")+1
		    s EquipTypeID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",3)  //类组
		    s EquipCatID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",6)  //分类
		    s QuantityNum=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
			s StatCatID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",28)  //类型
		    s UseLocID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",33)  //使用科室
		    s Equipecatno=##class(web.DHCEQEquip).GetEquipeCatCode(EquipCatID)
			f i=BeginNum:1:QuantityNum d
			.s nextno=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQEquip_FileNo",+$H,UseLocID,EquipTypeID,EquipCatID,Equipecatno)
			.i $g(^DHCEQOpenCheckList(OCLRowID,"FileNo"))'=""  d
			..s ^DHCEQOpenCheckList(OCLRowID,"FileNo")=$g(^DHCEQOpenCheckList(OCLRowID,"FileNo"))_","_nextno
			.e  d
			..s ^DHCEQOpenCheckList(OCLRowID,"FileNo")= nextno
		}		
		;add by czf 20200911 end CZF0128
		
		///再加上验收单对应的数量
	 	s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	 	s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
	 	s OCLNum=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
		//modified by ZY0268  20210611
	 	s OCLUseLocDR=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",33)
		s SQLCODE=##Class(web.DHCEQOpenCheckRequest).SourceUpdate(OCLSourceType,OCLSourceID,OCLNum,1,OCLUseLocDR)
		if SQLCODE
		{
			i NoTranFlag'="Y" TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收单资金来源生成失败!"_$g(%msg))
		}
		//Function:Funds	2012-2-16 生成资金来源信息
		;Modified By JDL 2012-2-15 JDL0116
		s OCLOriginalFee=$p(^DHCEQOpenCheckList(OCLRowID),"^",17)
		s OCLAmount=OCLNum*OCLOriginalFee
		///modified by ZY0209
		s selfflag=""					//CZF 2021-06-03 begin
		s fundsid=$o(^DHCEQFunds("0","Source",0,OCLRowID,0))
		i fundsid'="" s selfflag=1		//CZF 2021-06-03 end
		s SQLCODE=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(0,OCLRowID,OCLAmount,selfflag)
		if SQLCODE
		{
			i NoTranFlag'="Y" TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收单资金来源生成失败!"_$g(%msg))
		}
		///modified by ZY 20220913 2907381、2907386、2907390
    	/// Mozy0145    20141017
    	//Set SQLCODE=##Class(web.DHCEQOpenCheckRequest).SaveDataForInfo(Info,0,OCLRowID,2)
    	Set SQLCODE=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).SaveExclusiveInfo(Info,0,OCLRowID)
		if SQLCODE
		{
			i NoTranFlag'="Y" TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收专信息保存失败!"_$g(%msg))
		}
	 	//Add By DJ 2016-08-16
	 	s InvoiceNo=$p(val,"^",65)
		s SQLCODE=##Class(web.DHCEQInStockNew).UpdateInvoiceInfo(OCLRowID, InvoiceNo, "", "", 6)
		i SQLCODE
		{
			i NoTranFlag'="Y" TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收单发票号保存失败!"_$g(%msg))
		}
		// begin add by jyp jyp 2019-09-02 设备新增时保存验收单设备属性
		Set return=##Class(web.DHCEQ.EM.BUSEquipAttribute).SaveOpenCheckEquipAttribute(2,OCLRowID,EquipAttribute)
		if return
		{
			i NoTranFlag'="Y" TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(return,"验收单设备属性保存失败!"_$g(%msg))
		}
		// end add by jyp jyp 2019-09-02 设备新增时保存验收单设备属性
		
		;设备属性分类保存 czf 2022-04-14
		set return=##class(web.DHCEQ.EM.BUSAttributeCat).SaveEQAttributeCat(2,OCLRowID,EquipAttributeStringCat)
		if return
		{
			TRollback
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(return,"验收单属性分类保存失败!"_$g(%msg))
		}
		;设备属性分类保存 czf 2022-04-14 end
		
		//modified by ZY0265  20210531
		//设备新增时保存明细子表
		Set return=##Class(web.DHCEQ.EM.BUSOpenCheckListLoc).SaveOpenCheckListLoc(OCLRowID,sysflag)
		if return
		{
			i NoTranFlag'="Y" TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(return,"验收科室明细保存失败!"_$g(%msg))
		}
		///modified by ZY0260 20210428
		s return=##Class(web.DHCEQ.EM.BUSOpenCheckListLoc).SetLeaveFactoryNoAndFileNo(OCLRowID)
		i return
		{
			i NoTranFlag'="Y" TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(return,"验收科室明细出厂编号/档案号保存失败!"_$g(%msg))
		}
	}
	i NoTranFlag'="Y" TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,OCRRowID)
 	
ERROR
	if NoTranFlag'="Y"
	{
		TROLLBACK
		Set ErrorMsg=$ZE	           //得到系统返回的错误消息
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"<ERROR>"_ErrorMsg)
	}
}

/// modified by ZY0274 合同到货通知的时候去掉事务
/// add by zc 2019-12-02  zc0054  SubmitData添加入参CheckInStockType  设备入库时录入验收信息自动审核
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).SubmitData("148^^1^^16^2^^",2)
ClassMethod SubmitData(val, InFlag As %Library.String = "0", OutFlag As %Library.String = "0", CheckInStockType As %Library.String = "", NoTranFlag As %Library.String = "")
{
	k OCRRowID
	s OCRRowID=$p(val,"^",1)
	i OCRRowID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	//s CurRole=$p(val,"^",3)
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetCurrentSYSHospitalId()	//czf 2021-09-01
	
	i NoTranFlag'="Y" Set $ZT="ERRORSubmit"
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("7")
	i OCRRowID'=""
	{
		s InvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
		i InvalidFlag="Y" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015,"单据已无效!")
	}
	
	if (##Class(web.DHCEQPayPlan).CheckPayPlan(2,OCRRowID)="-2") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1010)  //Modified By QW20200108 BUG:QW0035 begin 修改返回值q -1010
	s Status=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",20) //状态
	if Status'="0" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015,"该记录状态不符合,不能执行操作!")
	///modified by ZY0260 20210428
	/*
	s LocListFlag=+##class(web.DHCEQCommon).GetSysInfo("201015")
	if (LocListFlag=1)
	{
		s OpenCheckListLoc=##Class(web.DHCEQ.EM.BUSOpenCheckListLoc).CheckOpenCheckListLoc(OCRRowID)
		if OpenCheckListLoc'="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1100",OpenCheckListLoc)
	}*/
	
	s EquipType=$P(^DHCEQOpenCheckRequest(OCRRowID),"^",2)
	s PurchaseType=$P(^DHCEQOpenCheckRequest(OCRRowID),"^",3)
	s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	s MaxPrice=$P(^DHCEQOpenCheckList(OCLRowID),"^",17)
	s SpecialType=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).GetSpecialType(OCLRowID)
	s YearFlag=""
	
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag,"",sHospID)	//czf 2021-09-01
	i ApproveSet="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-4007,"审批设置不存在!")
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, OCRRowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	s AppInfoStatus="1"	 		;AppInfoStatus
	s AuditFlag=0
	
	k PLIST
	s PLIST(21)="1"
	s PLIST(23)=User
	s PLIST(24)=Date
	s PLIST(25)=Time
	
	s PLIST(33)=ApproveSet
	s PLIST(34)=NextRole
	s PLIST(35)=NextStep
	s PLIST(36)=""
	s PLIST(37)=""
	//add by zc 2019-12-02 zc0054 begin  设备入库时录入验收信息自动审核
	i CheckInStockType="Y" d
	.s AutoAuditFlag="Y"
	.s NextStep=""	
	//add by zc 2019-12-02 zc0054 end  设备入库时录入验收信息自动审核  
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s AuditFlag=1
		s AppInfoStatus="2"			;AppInfoStatus
		s PLIST(21)="2"
	 	s PLIST(26)=User
	 	s PLIST(27)=Date
	 	s PLIST(28)=Time
	}
	
	i NoTranFlag'="Y" TSTART
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,OCRRowID,"7",User)
	if SQLCODE
	 {
		 i NoTranFlag'="Y" TROLLBACK
		 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"删除审批明细失败!"_$g(%msg))
	 }
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,OCRRowID,NextRole,NextStep,"","",AppInfoStatus)
	if SQLCODE
	 {
		 i NoTranFlag'="Y" TROLLBACK
		 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存审批信息失败!"_$g(%msg))
	 }
	&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Values :PLIST() where OCR_RowID=:OCRRowID)
	if SQLCODE
	{
		i NoTranFlag'="Y" TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"更新验收单信息失败!"_$g(%msg))
	}
	s OccupyFlag=##class(web.DHCEQCommon).GetSysInfo("990073")
	i OccupyFlag=1
	{
		s SQLCODE=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).OccupyEquipNo(OCLRowID)
		i SQLCODE=1 s SQLCODE=-1000
		if SQLCODE
		 {
			 i NoTranFlag'="Y" TROLLBACK
			 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"设备编号占用失败!"_$g(%msg))
		 }
	}
	
	;最后一步,需要调用审核方法
	if AuditFlag=1
	{
		s return=##class(web.DHCEQ.EM.BUSOpenCheckRequest).LastAuditAction(OCRRowID,OCLRowID, User, Date,Time, InFlag,OutFlag)  //modified by zy 2019-10-21 ZY0194
		s SQLCODE=$p(return,"^",1)
		s ErrMsg=$p(return,"^",2,*)
		if SQLCODE
		{
		 	i NoTranFlag'="Y" TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收最终审批失败!详细："_ErrMsg)
	 	}
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("11", OCRRowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	if SQLCODE
	 {
		 i NoTranFlag'="Y" TROLLBACK
		 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"审批消息生成失败!"_$g(%msg))
	 }
	/*************************************************/
	//Function:Funds	2012-2-16 生成资金来源信息
	s OCLAmount=$p(^DHCEQOpenCheckList(OCLRowID),"^",16)*$p(^DHCEQOpenCheckList(OCLRowID),"^",17)
	///modified by ZY0268 20210611
	s SQLCODE=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(0,OCLRowID,OCLAmount,1)
	if SQLCODE
	{
		i NoTranFlag'="Y" TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"资金来源生成失败!"_$g(%msg))
	}
	/*************************************************/
	i NoTranFlag'="Y" TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,OCRRowID)  //Modified By QW20200108 BUG:QW0035 begin 修改返回值q OCRRowID
ERRORSubmit
	if NoTranFlag'="Y" 
	{
		TROLLBACK
		Set ErrorMsg=$ZE	     //得到系统返回的错误消息
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)  //Modified By QW20200108 BUG:QW0035 begin 修改返回值Quit ErrorMsg
	}
}

/// 创建:zy 2009-12-02  No ZY0018
/// 描述:反提交
/// w ##Class(web.DHCEQInStockNew).CancelSubmitData("202^^1^^5^1^112^28")
ClassMethod CancelSubmitData(val)
{
	k OCRRowID,PLIST
	s OCRRowID=$P(val,"^",1)
	i OCRRowID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("")  //Modified By QW20200108 BUG:QW0035 begin 修改返回值q ""
	Set $ZT="ERRORCancel"
	//Modified By QW20200108 BUG:QW0035 begin 参数与Audit保持一致
	s User=$p(val,"^",7)
	if User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s RejectReason=$p(val,"^",6)
	s CurRole=$p(val,"^",2)  //Role
	//Modified By QW20200108 BUG:QW0035 End 参数与Audit保持一致
	s PLIST(21)="0"
	s Status="0"
	
	TSTART
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("7")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("7", OCRRowID)
	s RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	;生成审批记录
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,OCRRowID,RejectReason,"",CurRole,RoleStep,User,"1")
	//Modified By QW20200108 BUG:QW0035 begin 修改返回值
	if SQLCODE
	 {
		 TROLLBACK
		 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	 }
	//Modified By QW20200108 BUG:QW0035 End
	
	s CancelToFlowDR=""
	s CancelFlag="N"
	s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,CurRole,0))
	i AFRowID'="" d
	.s CancelFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",5)
	.s CancelToFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",6)
	i CancelFlag'="Y" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1006)  //Modified By QW20200108 BUG:QW0035 begin 修改返回值q -1006		;该步骤未设置为可取消
	
	s (ApproveRoleDR,Step)=""
	i CancelToFlowDR'=""
	{
		s Status="1"
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
 		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
 		///add by lmm 2017-06-14 405891 begin
 		s PLIST(21)="1"  
		s PLIST(34)=ApproveRoleDR
 		s PLIST(35)=Step
 		///add by lmm 2017-06-14 405891 end
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,OCRRowID,ApproveRoleDR,Step,"","",Status,"Y")
	//Modified By QW20200108 BUG:QW0035 begin 修改返回值
	if SQLCODE
	 {
		 TROLLBACK
		 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	 }
	//Modified By QW20200108 BUG:QW0035 End
	&sql(Update SQLUSER.DHC_EQOpenCheckRequest Values :PLIST() where OCR_RowID=:OCRRowID)
	//Modified By QW20200108 BUG:QW0035 begin 修改返回值
	if SQLCODE
	 {
		 TROLLBACK
		 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	 }
	//Modified By QW20200108 BUG:QW0035 End
	else
	{
		s ApproveFlow=""
		i CancelToFlowDR'=""
		{
			s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
			
		}
		else
		{
			s ApproveFlow="^^^^^^^^"_ApproveSet  
		}
		s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("11", OCRRowID, User, ApproveFlow, "Y",CurRole)
		//Modified By QW20200108 BUG:QW0035 begin 修改返回值
		if SQLCODE
		 {
			 TROLLBACK
			 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		 }
		//Modified By QW20200108 BUG:QW0035 End
	}
	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,OCRRowID)  //Modified By QW20200108 BUG:QW0035 begin 修改返回值q OCRRowID
 	
ERRORCancel
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息 
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)  //Modified By QW20200108 BUG:QW0035 begin 修改返回值Quit ErrorMsg  //返回错误消息 ;
}

/// Mozy0185	增加自动出库审核标志 
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:审核
/// Modified By QW20200108 BUG:QW0035 begin 增加入参data,LocDR
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).AuditData("2^7^1^同意^^^1","0","2","","","")
ClassMethod AuditData(val, InFlag As %Library.String = "0", OutFlag As %Library.String = "0", editFieldsInfo, data As %Library.String = "", LocDR As %Library.String = "")
{
	k OCRRowID,PLIST
	s OCRRowID=$p(val,"^",1)
	i OCRRowID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","验收单ID不能为空!")
	
	s CurRole=$p(val,"^",2)  //Role
	s RoleStep=$p(val,"^",3)  //Step
	s Opinion=$p(val,"^",4)  //Opinion
	s Remark=$p(val,"^",5)
	//Modified By QW20200108 BUG:QW0035 begin 移动端传session
	s User=$p(val,"^",7)
	if User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	//Modified By QW20200108 BUG:QW0035 End 移动端传session
	s Date=+$H
	s Time=$P($H,",",2)
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("7")
	i OCRRowID'=""
	{
		s InvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
		i InvalidFlag="Y" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1015,"验收单已无效!")
	}
	
	s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	s Status=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",20) //状态
	if Status'="1" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015)  //Modified By QW20200108 BUG:QW0035 begin 修改返回值q -2015   //该记录状态不符合,不能执行操作!
	s EquipType=$P(^DHCEQOpenCheckRequest(OCRRowID),"^",2)
	s PurchaseType=$P(^DHCEQOpenCheckRequest(OCRRowID),"^",3)
	s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	s MaxPrice=$P(^DHCEQOpenCheckList(OCLRowID),"^",17)
	s SpecialType=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).GetSpecialType(OCLRowID)
	s YearFlag=""
	
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag)
	i ApproveSet="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-4007)  //Modified By QW20200108 BUG:QW0035 begin 修改返回值q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, OCRRowID,RoleStep,CurRole)
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	s AppInfoStatus="1"	 		;AppInfoStatus
	s AuditFlag=0
	
	Set $ZT="ERRORAudit"
	k PLIST
    /*/ MZY0144	3070859		2022-11-24
    s PLIST(21)="1"
    s PLIST(23)=User
    s PLIST(24)=Date
    s PLIST(25)=Time*/
	
	s PLIST(33)=ApproveSet
	s PLIST(34)=NextRole
	s PLIST(35)=NextStep
	s PLIST(37)=CurRole  //Role
	s PLIST(36)=RoleStep  //Step
	
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s AuditFlag=1
		s AppInfoStatus="2"			;AppInfoStatus
		s PLIST(21)="2"
	 	s PLIST(26)=User
	 	s PLIST(27)=Date
	 	s PLIST(28)=Time
	}
	
	TSTART
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, OCRRowID, Opinion, Remark,CurRole,RoleStep,User) //Modified By QW20200108 BUG:QW0035 begin 移动端传session
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"审批明细保存失败！"_$g(%msg))
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,OCRRowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)		//modified by CZF0088 2020-03-06 1215622
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"审批信息保存失败！"_$g(%msg))
	}
	&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Values :PLIST() where OCR_RowID=:OCRRowID)
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收单信息更新失败！"_$g(%msg))
	}
	//Modified QW20200108 BUG:QW0035 begin判断是否设置可编辑字段或者组件设置保存。
 	if data'=""
	{
		Set SQLCODE=##class(web.DHCEQ.EM.BUSOpenCheckRequest).SaveDataNew(data,"2","","N",User)	
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收单组件设置更新失败！"_$g(%msg))
		}
	}
	else 
	{
		if editFieldsInfo'=""
		{
			s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)		//编辑要修改的字段
			if SQLCODE
			 {
				 TROLLBACK
				 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收单编辑字段保存失败！"_$g(%msg))
			 }
		}
	}
	//Modified QW20200108 BUG:QW0035 end判断是否设置可编辑字段或者组件设置保存。
	;最后一步,需要调用审核方法
	if AuditFlag=1
	{
		s return=##class(web.DHCEQ.EM.BUSOpenCheckRequest).LastAuditAction(OCRRowID,OCLRowID, User, Date,Time, InFlag,OutFlag,LocDR) //Modified QW20200108 BUG:QW0035 增加session locdr
		s SQLCODE=$p(return,"^",1)
		s ErrMsg=$p(return,"^",2,*)
		if SQLCODE
		 {
			 TROLLBACK
			 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收单最终审核失败！详细："_ErrMsg)
		 }
	}
	
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("11", OCRRowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收单审批消息生成失败！"_$g(%msg))
	}
	/*************************************************/
	//Function:Funds	2012-2-16 生成资金来源信息
	;Modified By JDL 2012-2-15 JDL0116
	s OCLAmount=$p(^DHCEQOpenCheckList(OCLRowID),"^",16)*$p(^DHCEQOpenCheckList(OCLRowID),"^",17)
	///modified by ZY0268 20210611
	s SQLCODE=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(0,OCLRowID,OCLAmount,1)
	if SQLCODE
	 {
		 TROLLBACK
		 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"验收单资金来源生成失败！"_$g(%msg))
	 }
	
	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,OCRRowID)  //Modified By QW20200108 BUG:QW0035 begin 修改返回值q OCRRowID
ERRORAudit
	TROLLBACK
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)  //Modified By QW20200108 BUG:QW0035 begin 修改返回值Quit ErrorMsg
}

ClassMethod GetSpecialType(OCID)
{
	s SpecialType=""
	s EquipCat=$P(^DHCEQOpenCheckList(OCID),"^",6)
	i EquipCat'="" s SpecialType=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCat),"^",5)
	i SpecialType'="" q SpecialType
	q 0
}

/// Modified By QW20200108 BUG:QW0035 增加session CurLocDR
ClassMethod LastAuditAction(OCRRowID, OCLRowID, User, Date, Time, InFlag, OutFlag, CurLocDR As %Library.String = "")
{
	s SQLCODE=0
	//占用设备编号时间点','0,不占用;1,验收提交;2,验收最终审核;'
	s OccupyFlag=##class(web.DHCEQCommon).GetSysInfo("990073")
	i OccupyFlag=2
	{
		s SQLCODE=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).OccupyEquipNo(OCLRowID)
		i SQLCODE q SQLCODE_"^设备编号占用失败！"_$g(%msg)
	}
	
	//start by csj 2020-10-15 需求号：1556715 更新采购计划已执行数量
	s SourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	s SourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
	s Quantity=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
	i (SourceType=1) //来源为合同
	{ 
		s ContractSourceType=$p($g(^DHCEQContractList(SourceID)),"^",5)
		i ContractSourceType=1 //来源为计划
		{
			s ContractSourceID=$p($g(^DHCEQContractList(SourceID)),"^",17) 
			s ExecNum=$p($g(^DHCEQBuyPlanList(ContractSourceID)),"^",11) //已执行数量
			s ExecNum=ExecNum+Quantity
			&SQL(update sqluser.DHC_EQBuyPlanList set BPL_ExecNum=:ExecNum where BPL_RowID=:ContractSourceID)
			i SQLCODE q SQLCODE_"^计划明细执行数量更新失败！"_$g(%msg)
		}
	} 
	elseif(SourceType=3) //来源为采购计划
	{
		s ExecNum=$p($g(^DHCEQBuyPlanList(SourceID)),"^",11) //已执行数量
		s ExecNum=ExecNum+Quantity
		&SQL(update sqluser.DHC_EQBuyPlanList set BPL_ExecNum=:ExecNum where BPL_RowID=:SourceID)
		i SQLCODE q SQLCODE_"^计划明细执行数量更新失败！"_$g(%msg)
	}
	//end by csj 2020-10-15
	
	//生成台帐时间点','0,验收审核;1,入库审核;'
	s InsertEquipFlag=+##class(web.DHCEQCommon).GetSysInfo("990074")
	i InsertEquipFlag=0
	{
		s SQLCODE=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).SaveEquipData(OCRRowID, OCLRowID, User, Date,Time,CurLocDR) ///Modified By QW20200108 BUG:QW0035 增加session CurLocDR
		i SQLCODE q SQLCODE_"^台账设备生成失败！"_$g(%msg)
	}
	else   //Modefied by zc0125 2022-12-12 增加最终结果处理 begin
	{
		s SQLCODE=##Class(web.DHCEQ.EM.BUSInventory).SaveDisposeResultByBussType(11,OCRRowID) 
		i SQLCODE q SQLCODE
	}   //Modefied by zc0125 2022-12-12 增加最终结果处理 end
	// MZY0026	1279490		2020-05-22	取消采购合同到货预警
	i $p($g(^DHCEQOpenCheckList(OCLRowID)),"^",37)'="" s SQLCODE = ##Class(web.DHCEQ.Plat.BussWarnDays).SetEndDay(75, "94-1", $p($g(^DHCEQOpenCheckList(OCLRowID)),"^",37))
	i SQLCODE q SQLCODE_"^取消采购合同到货预警失败！"_$g(%msg)
	s SQLCODE = ##Class(web.DHCEQOpenCheckRequest).AutoInOutExecute(1,OCLRowID,$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",31),User, InFlag, OutFlag)
	q SQLCODE_"^自动入出库失败！"_$g(%msg)
}

/// Mozy0217  2018-11-01	待定
/// 功能：提取生成台账代码
/// 入参val:传入的字符串，第一个为验收单的id; 
/// 				AutoFlag:自动出入库设置; CancelFlag :"Y" 作废时根据审核状态的验收单生成台账
/// Modified By QW20200108 BUG:QW0035 增加session CurLocDR
ClassMethod SaveEquipData(OCRRowID, OCLRowID, User, Date, Time, CurLocDR As %Library.String = "")
{
	s SQLCODE=0
	k PI
    s OpenCheckRequest=$g(^DHCEQOpenCheckRequest(OCRRowID))
    s OpenCheckList=$g(^DHCEQOpenCheckList(OCLRowID))
    
	//Set ^DHCEQOpenCheckList(oclrowid,"AutoFlag")=AutoFlag	;20170327 Mozy0184
	/*********写入台帐设备*****************/
	s PI(2) = $p(OpenCheckList,"^",2)	;Name
	s PI(3) = $p(OpenCheckList,"^",4)	;ABCType
	s PI(4) = $p(OpenCheckList,"^",5)	;ModelDR
 	s PI(5) = $p(OpenCheckList,"^",6)	;EquiCatDR
 	s PI(6) = $p(OpenCheckList,"^",7)	;UnitDR
 	s PI(7) = $p(OpenCheckList,"^",8) //Code 	 
 	s PI(8) = $p(OpenCheckList,"^",9) //ItemDR
 	s PI(9) = $p(OpenCheckList,"^",47) ;InstallLoc
 	s PI(10) = $p(OpenCheckList,"^",48) ;InstallDate
 	s PI(12) = $p(OpenCheckList,"^",49) ;LeaveFactoryDate
 	s PI(13) = $p(OpenCheckRequest,"^",10) ;OpenCheckDate
 	s PI(14) = $p(OpenCheckList,"^",46) ;CheckDate
 	s PI(15) = $p(OpenCheckList,"^",10) ;MakeDate
 	s PI(16) = $p(OpenCheckList,"^",39) ;ComputerFlag  add by zy 20150901 zy0140
 	s PI(17) = $p(OpenCheckList,"^",11)	;CountryDR
 	s PI(18) = $p(OpenCheckList,"^",32)	;ManageLocDR
 	s PI(19) = $p(OpenCheckList,"^",12)	;ManageLevelDR
 	//s PI(20) = $p(OpenCheckList,"^",33)	;UseLocDR  //2012-03-12 DJ
 	s PI(21) = $p(OpenCheckRequest,"^",8)	;OriginDR
 	s PI(22) = $p(OpenCheckRequest,"^",9)	;FromDeptDR
	s PI(24) = $p(OpenCheckList,"^",13)	;BuyTypeDR
 	s PI(25) = $p(OpenCheckList,"^",14)	;EquipTechLevelDR 
 	s PI(26) = $p(OpenCheckRequest,"^",5)	;ProviderDR
 	s PI(27) = $p(OpenCheckList,"^",15)	;ManuFactoryDR
 	s PI(28) = $p(OpenCheckList,"^",17)	;OriginalFee
 	If PI(3)=""
	{
		// Mozy003008		2020-04-09 		补充修正ABC分类
		Set PI(3)="A"		;默认类
		;If PI(28)<80000 Set PI(3)="B"
		;If PI(28)<10000 Set PI(3)="C"
		;If PI(28)<1000 Set PI(3)="D"
		s SplitFlag=##class(web.DHCEQCommon).GetSysInfo("201013")
		i SplitFlag="" s SplitFlag="100000,10000"
		If PI(28)<+$p(SplitFlag,",",1) Set PI(3)="B"
		If PI(28)<+$p(SplitFlag,",",2) Set PI(3)="C"
		If PI(28)<+$p(SplitFlag,",",3) Set PI(3)="D"
	}
 	s PI(29) = $p(OpenCheckList,"^",17)	;NetFee
	s PI(30) = $p(OpenCheckList,"^",18)  	;NetRemainFee
	s PI(32) = $p(OpenCheckList,"^",19) 	;LimitYearsNum
	s PI(33) = $p(OpenCheckList,"^",37)	;ContractListDR
	s PI(34) = $p(OpenCheckList,"^",20) 	;DepreMethod
	s PI(35) = $p(OpenCheckRequest,"^",21)	;Remark
	s PI(37) = $p(OpenCheckList,"^",29) 	;DesignWorkLoadNum
	s PI(38) = $p(OpenCheckList,"^",30) 	;WorkLoadUnit
	s PI(39)=0 ;Status
	s PI(40) = $p(OpenCheckList,"^",104)	;EQManageUserDR
	s PI(42) = $p(OpenCheckRequest,"^",6)	;ContactUser
 	s PI(43) = $p(OpenCheckRequest,"^",7)	;ContactMode
	s PI(47) = $p(OpenCheckList,"^",42) ;GuaranteeFlag
 	s PI(48) = "N"
 	s PI(49) = $p(OpenCheckList,"^",40) ;TestFlag
 	s PI(50) = $p(OpenCheckList,"^",38) ;MedicalFlag
 	s PI(51) = $p(OpenCheckList,"^",43) ;GuaranteeStartDate
	s PI(52) = $p(OpenCheckList,"^",44) ;GuaranteeEndDate
 	s PI(53)=User
	s PI(54)=Date
	s PI(55)=Time
	s PI(56)=User
	s PI(57)=Date
	s PI(58)=Time
	s PI(59)= $p(OpenCheckList,"^",21) ;Currency
	s PI(60) = "N"
	s PI(61) = "0"
 	s PI(62) = $p(OpenCheckList,"^",22) //MemeryCode
 	s PI(63) = $p(OpenCheckList,"^",41) //UrgencyFlag
 	s PI(64) = $p(OpenCheckList,"^",3) //EquipType
 	s PI(65) = $p(OpenCheckList,"^",23) //PurchaseTypeDR
 	s PI(66) = $p(OpenCheckList,"^",24) //PurposeTypeDR
 	s PI(67) = $p(OpenCheckList,"^",85) //OCL_Hold13 -> KeeperDR
 	//s PI(68) = $p(OpenCheckList,"^",31) ;StoreLoc 2009-06-26 党军
 	s PI(70) = $p(OpenCheckList,"^",25) //ServiceDR 	 
 	s PI(73) = $p(OpenCheckList,"^",26) //LocationDR
 	s PI(74) = $p(OpenCheckList,"^",27) //GuaranteePeriodNum
 	s PI(76) = $p(OpenCheckList,"^",28) //StatCatDR
 	s PI(77) = $Piece(OpenCheckList,"^",36) //ContractNo Mozy0051	2011-4-15
 	s PI(78) = OCLRowID //OpenCheckListRowid
 	//s LeaveFactoryNo=$p(OpenCheckList,"^",55)
 	s LeaveFactoryNo=$g(^DHCEQOpenCheckList(OCLRowID,"EX")) //2009-08-17 党军
 	//新增:2009-11-25 党军 begin DJ0037
 	s PI(82)=$p(OpenCheckList,"^",60) ;BenefitAnalyFlag
 	s PI(83)=$p(OpenCheckList,"^",61) ;CommonageFlag
 	s PI(84)=$p(OpenCheckList,"^",62) ;AutoCollectFlag
 	s PI(85)=$p(OpenCheckList,"^",65) ;WorkLoadPerMonth
 	//modified by ZY0307 2763246
 	s PI(91)=$p(OpenCheckList,"^",71)  //凭证号
 	s PI(93)=$p(OpenCheckList,"^",56) ;Hold2  //注册证号
 	s PI(95)=$p(OpenCheckList,"^",58)	;Hold4	//品牌	2013-12-11 DJ0122
 	//2009-11-25 党军 end DJ0037
 	Set PI(96)=$Piece(OpenCheckList,"^",59)	;Hold5	//经费来源 20150630  Mozy0154
 	
 	Set PI(98)=$Piece(OpenCheckList,"^",88)	;EQ_ConfigLicense
 	Set PI(99)=$Piece(OpenCheckList,"^",89)	;EQ_NewOldPercent
 	
 	Set PI(100)=$Piece(OpenCheckList,"^",84)	;Hold12	//功率 2021-05-20 BUG 1880422 
 	
 	Set PI(101)=$Piece(OpenCheckList,"^",90)	;EQ_Voltage
 	Set PI(102)=$Piece(OpenCheckList,"^",91)	;EQ_Electriccurrent
 	
 	//modify BY:GBX 2014-11-24
 	s PI(109)=$p(OpenCheckList,"^",66)  //ValueType
 	s PI(110)=$p(OpenCheckList,"^",67)  //DirectionsUse
 	s PI(111)=$p(OpenCheckList,"^",68)  //UserDR
 	s PI(112)=$p(OpenCheckList,"^",69)  //AccountShape
 	s PI(113)=$p(OpenCheckList,"^",70)  //ProjectNo
 	s PI(103)=$p(OpenCheckList,"^",72)  //EQRaditionFlag	放射标志 
	//Modefied by zc0103 2021-06-02 使用年限保存,中医标识不存储 begin
	//s PI(81)=$p(OpenCheckList,"^",73) ;中医标志 Add By DJ 2017-01-20
	s PI(81)=$p(OpenCheckList,"^",92)
	//Modefied by zc0103 2021-06-02 使用年限保存,中医标识不存储 end
	s PI(114)=$p(OpenCheckList,"^",77)  //ServiceHandler
	s PI(115)=$p(OpenCheckList,"^",78)  //ServiceTel
	s PI(117)=$p(OpenCheckList,"^",74)  //SpecialFlag
	s PI(118)=$p(OpenCheckList,"^",81)  //SalesManager		//Mozy	2018-5-15
	s PI(119)=$p(OpenCheckList,"^",82)  //SalesManagerTel	//Mozy	2018-5-15
	
	//s PI(120)= //EQ_Hold11  主设备ID
	//s PI(121)= //EQ_Hold12
	//s PI(122)= //EQ_Hold13
	s PI(123)=$p(OpenCheckList,"^",83)  //EQ_Hold14 产地
	s PI(124)=$p(OpenCheckList,"^",86)  //EQ_Hold15 招标编号
	s PI(125)=$p(OpenCheckList,"^",93)  //EQ_Note  
	s PI(126)=$p(OpenCheckList,"^",94)  //EQ_MaintNote
	s PI(127)=$p(OpenCheckList,"^",95)  //EQ_Hold16
	s PI(128)=$p(OpenCheckList,"^",96)  //EQ_Hold17
	s PI(129)=$p(OpenCheckList,"^",97)  //EQ_Hold18
	s PI(130)=$p(OpenCheckList,"^",98)  //EQ_Hold19
	s PI(131)=$p(OpenCheckList,"^",99)  //EQ_Hold20
	
	s PI(132)=$p(OpenCheckList,"^",100)  //EQ_AuthorizeDeptDR
	s PI(133)=$p(OpenCheckList,"^",101)  //EQ_UseSubjectDR
	s PI(134)=$p(OpenCheckList,"^",102)  //EQ_BuyModeDR
	s PI(135)=$p(OpenCheckList,"^",103)  //EQ_AccountDate
	s PI(137)=$p(OpenCheckList,"^",108)  //EQ_ManageCat add by txr 20230417
	
	//s PI(86)= $p(OpenCheckRequest,"^",38) //FileNo 档案号 2014-1-9 HZY0045 
 	Set FileNo=$g(^DHCEQOpenCheckList(OCLRowID,"FileNo"))		//20150819  Mozy0159
 	Set TempBar=$g(^DHCEQOpenCheckList(OCLRowID,"TempBar"))		// MZY0074	1904154		2021-04-30
 	Set SplitFlag=##class(web.DHCEQCommon).GetSysInfo("990035")	//20150822  Mozy0162 验收时档案号是否拆分
 	s Quantity=$P(OpenCheckList,"^",16)
	for j=1:1:Quantity
	{
		q:SQLCODE'=0
	 	s PI(11) =##class(web.DHCEQCommon).Replace($P(LeaveFactoryNo, ",", j),$C(13,10),"")
	 	//20150822  Mozy0162 验收时档案号是否拆分
	 	If SplitFlag=1 Do
	 	.Set PI(86) =##class(web.DHCEQCommon).Replace($Piece(FileNo, ",", j),$C(13,10),"")
	 	Else  Do
	 	.Set PI(86) = FileNo
	 	&sql(Insert Into sqluser.DHC_EQEquip values :PI())
	 	q:SQLCODE'=0
		s ID=$G(%ROWID)
		// MZY0074	1904154		2021-04-30	插入绑定记录
		k BList
	 	s BList(2)=1		;BO_SourceType			来源类型					1:设备  2:
		s BList(3)=ID		;BO_SourceID			来源ID						对应设备ID
		s BList(4)=2		;BO_BindType			绑定类型					1:RFID 2:外部条码
		s BList(5)=""		;BO_BindID			绑定对象ID	
		s BList(6)=##class(web.DHCEQCommon).Replace($P(TempBar, ",", j),$C(13,10),"")	;BO_BindNo	绑定编号
		s BList(7)=User	;BO_BindUserDR			绑定人
	 	s BList(8)=Date	;BO_FromDate			绑定日期
	 	s BList(9)=Time	;BO_FromTime			绑定时间
		;BO_UnBindUserDR			解绑人					
		;BO_ToDate			解绑日期					
		;BO_ToTime			解绑时间					
		;BO_Remark			备注					解绑可注明原因
		s BList(14)="N"		;BO_InvalidFlag	//modified by ZY 20210528
		i BList(6)'=""
		{
			&sql(Insert Into sqluser.DHC_EQBindObj values :BList())
			i SQLCODE q
		}
		//占用设备编号时间点','0,不占用;1,验收提交;2,验收最终审核;'
		s EquipNoNew=""
		s OccupyFlag=##class(web.DHCEQCommon).GetSysInfo("990073")
		i OccupyFlag'=0 s EquipNoNew=$p($g(^DHCEQOpenCheckList(OCLRowID,"EquipNo")),"^",j)
		i EquipNoNew'=""
		{
			&SQL(Update SQLUSER.DHC_EQEquip set EQ_No=:EquipNoNew Where EQ_RowID=:ID)
		}
		else
		{
			s SQLCODE= ##CLASS(web.DHCEQEquip).UpdateEquipNo(ID,Date,CurLocDR) //Modified By QW20200108 BUG:QW0035 增加session CurLocDR
		}
		q:SQLCODE'=0
		//Modefied by zc0125 2022-12-12 增加最终处理结果记录 begin
		s SQLCODE=##Class(web.DHCEQ.EM.BUSInventory).SaveDisposeResultByBussType(11,OCRRowID,ID)
		q:((SQLCODE'=0)&&(SQLCODE'=100))
		//Modefied by zc0125 2022-12-12 增加最终处理结果记录 end
		//begin add by jyp jyp 2019-09-02 设备属性在审核时保存到设备中
		s SQLCODE= ##CLASS(web.DHCEQ.EM.BUSEquipAttribute).SaveEquipAttributeByOpenCheckList(2,OCLRowID,ID)
		q:((SQLCODE'=0)&&(SQLCODE'=100))  // modify by jyp 2019-10-21 
		//end add by jyp jyp 2019-09-02 设备属性在审核时保存到设备中
		
		//czf 2022-04-14 属性分类保存到设备中 begin
		s SQLCODE= ##CLASS(web.DHCEQ.EM.BUSAttributeCat).SaveAttibuteCatByOCL(2,OCLRowID,ID)
		q:((SQLCODE'=0)&&(SQLCODE'=100))  // modify by jyp 2019-10-21 
		//czf 2022-04-14 属性分类保存到设备中 end
        
	 	if PI(33)'=""
	 	{
		 	s SQLCODE=##Class(web.DHCEQOpenCheckRequest).InsertAffixByContract(ID,PI(33))
			q:SQLCODE'=0
	 	}
	 	//add by wy 2018-5-2
	 	//配置清单复制与附属设备生成台账
	 	s SQLCODE=##class(web.DHCEQOpenCheckRequest).InsertEquipOrConfig(OCLRowID,ID,j)	//modified by zy 2019-10-21 ZY0194
	 	q:SQLCODE'=0
		/// Mozy0145	20141017
		Set StatDR=$Piece(OpenCheckList,"^",28)
		Set AssetType=$Piece($Get(^DHCEQCCode("DHCEQCStatCat",StatDR)),"^",5)
		///modified by ZY 20220913 2907381、2907386、2907390
    	//Set Info=##Class(web.DHCEQOpenCheckRequest).GetInfoData(0,OCLRowID)
    	//Set SQLCODE=##Class(web.DHCEQOpenCheckRequest).SaveDataForInfo(Info,1,ID,2)
    	Set SQLCODE=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).InsertExclusiveByOCL(0,OCLRowID,ID)	//生成设备专属信息 czf 2022-11-01
	 	q:SQLCODE'=0
	 	///////////////////拆分附件的出厂编号 		 ///Mozy	2016-8-4
		If $Data(^DHCEQAffix(0,"CheckListDR",OCLRowID))'=0
	 	{
		 	Set Affixrowid=0
			For  Set Affixrowid=$Order(^DHCEQAffix(0,"CheckListDR",OCLRowID,Affixrowid))  Quit:(Affixrowid="")||(SQLCODE'=0)  Do
			.;Hold3-拆分标记	把附件拆分为单台
			.If $Piece($Get(^DHCEQAffix(Affixrowid)),"^",27)="Y" Do
			..Set QuantityNum=$Piece($Get(^DHCEQAffix(Affixrowid)),"^",7)
			..for n=1:1:QuantityNum d
			...Kill APLIST
			...q:SQLCODE'=0			//modified by czf 2020-07-20 1424108
			...Set APLIST(2) = ID	;EquipDR
			...Set APLIST(3) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",2)	;AffixDR
			...Set APLIST(4) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",3)	;AffixCatDR
			...Set APLIST(5) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",4)	;PartSpec
			...Set APLIST(6) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",5)	;PartModel
			...Set APLIST(7) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",6)	;ManuFactoryDR
			...Set APLIST(8) = 1	;$Piece($Get(^DHCEQAffix(Affixrowid)),"^",7)	;QuantityNum
			...Set APLIST(9) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",8)	;ReceiverDR
			...Set LeaveFacNo = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",9)	;LeaveFacNo
			...i $d(^DHCEQAffix(Affixrowid,"EX")) Set LeaveFacNo = $g(^DHCEQAffix(Affixrowid,"EX"))	;LeaveFacNo
			...Set APLIST(10) = $Piece(LeaveFacNo,",",(j-1)*QuantityNum+n)
			...Set APLIST(11) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",10)	;LeaveDate
			...Set APLIST(12) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",11)	;PriceFee
			...Set APLIST(13) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",12)	;Remark
			...Set APLIST(14) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",13)	;CurrencyDR 
			...Set APLIST(15) = "N"		;AF_DisuseFlag
			...Set APLIST(16) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",15)	;AF_InvalidFlag
			...Quit:APLIST(16)'="N"
			...Set APLIST(20) = ""			;AF_CheckListDR
			...Set APLIST(21) = Affixrowid	;AFOldRowID
			...Set APLIST(25) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",24) ;ProviderDR
			...Set APLIST(26) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",25) ;Hold1
			...Set APLIST(27) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",26) ;Hold2
			...;Set APLIST(28) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",27) ;Hold3
			...Set APLIST(29) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",28) ;Hold4
		 	...Set APLIST(30) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",29) ;Hold5
		 	...;Add By QW20210629 BUG:QW0130 增加序号 begin
		 	...s enextno=""
		 	...s nnextno=""
		 	...&SQL(select max(AF_Hold1) into :enextno from sqluser.DHC_EQAffix where AF_EquipDR = :ID )
		 	...&SQL(select max(AF_Hold1) into :nnextno from sqluser.DHC_EQAffix where AF_CheckListDR = :OCLRowID and AF_SplitFlag='N')
		 	...s APLIST(31)=enextno+1
		 	...if enextno>nnextno  s APLIST(31)=enextno+1
		 	...;Add By QW20210629 BUG:QW0130 增加序号 end
		 	...&SQL(Insert Into SQLUSER.DHC_EQAffix Values :APLIST())
	 	}
	}
	q SQLCODE
}

/// add by zy 20190927
/// 在没有生成资产台帐前,占用资产编号,用于提前打印资产卡片
/// 	入参  验收明细ID
/// 	返回值 0:占用成功;1:占用不成功
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).OccupyEquipNo(14)
ClassMethod OccupyEquipNo(OCLRowID)
{
	new OpenCheckList,EquipTypeID,EquipCatID,QuantityNum,StatCatID,UseLocID,equipecatno,EquipNoStr
	new BeginNum,i,nextno
	
    s OpenCheckList=$g(^DHCEQOpenCheckList(OCLRowID))
    s EquipTypeID=$p(OpenCheckList,"^",3)  //类组
    s EquipCatID=$p(OpenCheckList,"^",6)  //分类
    s QuantityNum=$p(OpenCheckList,"^",16)
	s StatCatID=$p(OpenCheckList,"^",28)  //类型
    s UseLocID=$p(OpenCheckList,"^",33)  //使用科室
    s equipecatno=##class(web.DHCEQEquip).GetEquipeCatCode(EquipCatID)
        ///modified by ZY0200 逻辑错误
	s EquipNoStr=$g(^DHCEQOpenCheckList(OCLRowID,"EquipNo"))
	i EquipNoStr="" d
	.s BeginNum=1
	e  d
	.s BeginNum=$L(EquipNoStr,"^")+1
	for i=BeginNum:1:QuantityNum
	{
		s nextno=""
		s nextno=##class(web.DHCEQCCounter).GetNextNo("DHC_EQEquip",+$H,UseLocID,EquipTypeID,StatCatID,equipecatno)	// MZY0059	1571977		2020-10-26	修正参数
		if $g(^DHCEQOpenCheckList(OCLRowID,"EquipNo"))'=""  d
		.s ^DHCEQOpenCheckList(OCLRowID,"EquipNo")=$g(^DHCEQOpenCheckList(OCLRowID,"EquipNo"))_"^"_nextno
		e  d
		.s ^DHCEQOpenCheckList(OCLRowID,"EquipNo")= nextno
	}
	s EquipNoStr=$g(^DHCEQOpenCheckList(OCLRowID,"EquipNo"))
	i $L(EquipNoStr,"^")>=QuantityNum q 0
	q 1
}

/// Add By QW20200108 BUG:QW0035
/// 入参为json的保存方法
/// 	入参  data为json格式
/// 	返回值 0:成功 其他:失败
/// w ##class(web.DHCEQ.EM.BUSOpenCheckRequest).SaveData("","","0","","N",71)	
ClassMethod SaveDataNew(data, isDel As %Library.String = "", Info As %Library.String = "", TranFlag As %Library.String = "Y", User As %Library.String = "", EquipAttribute As %Library.String = "")
{
	s $ZT="ERRORSave"
	k PLIST,PLISTMX,OCRRowID,OCLRowID
	i User=""  s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s SQLCODE=0
	i TranFlag="Y" TSTART
	if isDel=1
	{
		//恢复修改前面关联业务的数据
		&SQL(Update SQLUSER.DHC_EQOpenCheckRequest set OCR_InvalidFlag='Y',OCR_CancelUser=:User,OCR_CancelDate=:Date,OCR_CancelTime=:Time where OCR_RowID=:OCRRowID)
		 if SQLCODE
		 {
		   i TranFlag="Y" TROLLBACK
		   Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		 }
		 s OCRRowID=data
	 	 s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	 	 s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	 	 s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
	 	 s OCLNum=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
		 //modified by ZY0252  20210301
	 	 s OCLUseLocDR=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",33)
		 s SQLCODE=##Class(web.DHCEQOpenCheckRequest).SourceUpdate(OCLSourceType,OCLSourceID,OCLNum,2,OCLUseLocDR)
		 if SQLCODE
		 {
			 i TranFlag="Y" TROLLBACK
			 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		 }

		s OCRRowID=""
	}
	elseif (+isDel=2) //新增,更新
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQOpenCheckRequest",JsonData,.PLIST)
	    s PLISTMX=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQOpenCheckList",JsonData,.PLISTMX)
		s AccountShapeFlag=+##class(web.DHCEQCommon).GetSysInfo("990057")
		i AccountShapeFlag=1 s PLISTMX(70)="0"  //入账形式
		///Modified By QW20200119 begin BUG:QW0039增加输出
		s LeaveFactoryIDs=""
		s FileNo=""
		if (JsonData.%IsDefined("OCLLeaveFactoryIDs")=1) s LeaveFactoryIDs=$TRANSLATE(JsonData.OCLLeaveFactoryIDs,"，",",")
		if (JsonData.%IsDefined("OCLFileNos")=1) s FileNo=$TRANSLATE(JsonData.OCLFileNos,"，",",")
		///Modified By QW20200119 end BUG:QW0039增加输出
		s RowID = JsonData.BussID
		i RowID'=""
		{
			s InvalidFlag=$p($g(^DHCEQOpenCheckRequest(RowID)),"^",45)
			i InvalidFlag="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1015)
		}
	    if RowID=""
	    {
			s PLIST(21)="0"
			s PLIST(46)="N"	
			s PLIST(38)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQOpenCheckRequest",Date,"",data.OCREquipTypeDR)
		 	&SQL(Insert Into SQLUSER.DHC_EQOpenCheckRequest Values :PLIST())
		 	if SQLCODE
		 	{
				i TranFlag="Y" TROLLBACK
			 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		 	}
		 	s OCRRowID=$G(%ROWID)
		 	s PLISTMX(2)=OCRRowID
		 	&SQL(Insert Into SQLUSER.DHC_EQOpenCheckList Values :PLISTMX())
		 	if SQLCODE
		 	{
			 	i TranFlag="Y" TROLLBACK
			 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			s OCLRowID=$G(%ROWID)
			if (PLISTMX(64)=1)||(PLISTMX(64)=4)
			{
				Set SQLCODE=##Class(web.DHCEQContractConfig).SaveConfigBySource(PLISTMX(65),OCLRowID)
				if SQLCODE
				{
					i TranFlag="Y" TROLLBACK
					Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
				}
			}
		}
		else
		{
			s OCRRowID=RowID
			&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Values :PLIST() where OCR_RowID=:OCRRowID)
		 	if SQLCODE
			{
				i TranFlag="Y" TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
		 	///先减掉验收单对应的数量
		 	s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
		 	s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
		 	s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
		 	s OCLNum=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
			s SQLCODE=##Class(web.DHCEQOpenCheckRequest).SourceUpdate(OCLSourceType,OCLSourceID,OCLNum,2)
			if SQLCODE
			{
				i TranFlag="Y" TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			
			;CZF 1983205 2021-06-11 begin
			;前后来源类型或来源名不一致时删除旧的资金来源记录
			s NewSourceType=PLISTMX(64)
	 		s NewSourceID=PLISTMX(65)
	 		i (OCLSourceType'=NewSourceType)||(OCLSourceID'=NewSourceID)
	 		{
		 		&SQL(delete SQLUSER.DHC_EQFunds where F_SourceType=0 and F_SourceID=:OCLRowID and F_InvalidFlag='N')
				i SQLCODE=100 s SQLCODE=0		 		
		 	}
		 	if SQLCODE
		 	{
				i TranFlag="Y" TROLLBACK
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			;CZF 1983205 2021-06-11 end
			
		 	&SQL(Update SQLUSER.DHC_EQOpenCheckList Values :PLISTMX() where OCL_OpenCheckRequestDR=:OCRRowID)
		 	if SQLCODE
			{
				i TranFlag="Y" TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			s OCLRowID=$G(%ROWID)
		}
		s InvoiceNo=""   ;JsonData.InvoiceNo
		s SQLCODE=##Class(web.DHCEQInStockNew).UpdateInvoiceInfo(OCLRowID, InvoiceNo, "", "", 6)
		i SQLCODE
		{
			i TranFlag="Y" TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s ^DHCEQOpenCheckList(OCLRowID,"EX")=LeaveFactoryIDs //2009-08-17 党军
		s ^DHCEQOpenCheckList(OCLRowID,"FileNo")=FileNo	//20150819  Mozy0159
		
		///再加上验收单对应的数量
	 	s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	 	s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
	 	s OCLNum=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
		s SQLCODE=##Class(web.DHCEQOpenCheckRequest).SourceUpdate(OCLSourceType,OCLSourceID,OCLNum,1)
		i SQLCODE
		{
			i TranFlag="Y" TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		//Function:Funds	2012-2-16 生成资金来源信息
		;Modified By JDL 2012-2-15 JDL0116
		s OCLOriginalFee=$p(^DHCEQOpenCheckList(OCLRowID),"^",17)
		s OCLAmount=OCLNum*OCLOriginalFee
		///modified by ZY0209
		s selfflag=""					//CZF 2021-06-03 begin
		s fundsid=$o(^DHCEQFunds("0","Source",0,OCLRowID,0))
		i fundsid'="" s selfflag=1		//CZF 2021-06-03 end
		s SQLCODE=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(0,OCLRowID,OCLAmount,selfflag)
		i SQLCODE
		{
			i TranFlag="Y" TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		/// Mozy0145	20141017
		Set SQLCODE=##Class(web.DHCEQOpenCheckRequest).SaveDataForInfo(Info,0,OCLRowID,2)
		i SQLCODE
		{
			i TranFlag="Y" TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	 	//Add By DJ 2016-08-16
	 	s InvoiceNo=PLISTMX(56)
		s SQLCODE=##Class(web.DHCEQInStockNew).UpdateInvoiceInfo(OCLRowID, InvoiceNo, "", "", 6)
		i SQLCODE
		{
			i TranFlag="Y" TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		// begin add by jyp jyp 2019-09-02 设备新增时保存验收单设备属性
		Set return=##Class(web.DHCEQ.EM.BUSEquipAttribute).SaveOpenCheckEquipAttribute(2,OCLRowID,EquipAttribute)
		i return
		{
			i TranFlag="Y" TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(return)
		}
		// end add by jyp jyp 2019-09-02 设备新增时保存验收单设备属性
	}
	i TranFlag="Y" TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORSave
	i TranFlag="Y" TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// Add By QW20200108 BUG:QW0035
/// 验收来源query
/// 	入参:无
/// 	输出-TRowID:OCLSourceType,TDesc:OCLSourceTypeDesc
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSOpenCheckRequest","GetSourceType","")
Query GetSourceType() As %Query(ROWSPEC = "TRowID:%String,TDesc:%String")
{
}

ClassMethod GetSourceTypeExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1

	s SourceType=##class(web.DHCEQCommon).GetSysInfo("201001")  
	s ContractIDs=##class(web.DHCEQCommon).GetSysInfo("201012")	
	if SourceType=2 s ContractIDs=0_","_ContractIDs_","_3
	if SourceType=0 s ContractIDs="0,3"
	s Len=$l(ContractIDs,",")
	f i=1:1:Len d
	.s ID=$p(ContractIDs,",",i)
	.q:ID=""
	.s TDesc=$case(ID,"0":"设备项","1":"采购合同","3":"计划单","4":"协议合同","5":"投放合同")
	.d OutputRowGetSourceType
	
	Quit $$$OK
OutputRowGetSourceType
	Set Data=$lb(ID,TDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetSourceTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSourceTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetSourceTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSourceTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Mozy0247	1190959		2020-02-17
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).CheckLocStock("10,13")
ClassMethod CheckToLoc(OCRIDs As %String = "")
{
	i (OCRIDs="") q "0^"
	s sysinfo=##class(web.DHCEQCommon).GetSysInfo("201015")
	n len,i,OCRRowID,OCLRowID,flag
	s flag=0
	s len=$l(OCRIDs,",")
	f i=1:1:len d
	.q:flag'=0
	.s OCRRowID=$p(OCRIDs,",",i)
	.s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	.
	.i sysinfo'=1 d
	..i ##Class(web.DHCEQOpenCheckRequest).CheckLocStock(0,$Piece($Get(^DHCEQOpenCheckList(OCLRowID)),"^",33))'=0 d
	...s flag=-1
	...s $P(OCRIDs,",",i)=""
	.e  d
	..s result=##Class(web.DHCEQ.EM.BUSOpenCheckListLoc).CheckOpenCheckListLoc(OCRRowID)
	..i result'="" d
	...s flag=result
	...s $P(OCRIDs,",",i)=""
	
	q flag_"^"_OCRIDs
}

/// Mozy0247	1190959		2020-02-17
/// w ##Class("web.DHCEQ.EM.BUSOpenCheckRequest").Execute("17,18,19",7,1,0,0)
ClassMethod Execute(valRowIDs As %Library.String = "", CurRole As %Library.String = "", RoleStep As %Library.String = "", inflag As %Library.String = "", outflag As %Library.String = "")
{
	i valRowIDs="" Q 0
	n Count,len
	s len=$l(valRowIDs,",")
	;s SQLCODE=0
	for Count=1:1:len d
	.s val = $p(valRowIDs,",",Count)_"^"_CurRole_"^"_RoleStep_"^同意^"
	.d ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).AuditData(val, inflag, outflag, "")
	
	q len
}

/// Mozy0255	1190551		2020-3-6	获取验收单的供应商信息
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).GetCheckRequestProvider(25)
ClassMethod GetCheckRequestProvider(RowID As %Library.String = "")
{
	s ProviderDR=+$p($g(^DHCEQOpenCheckRequest(+RowID)),"^", 5)
	q ProviderDR_"^"_##class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
}

/// // MZY0026	1320845		2020-05-20	获取台账设备的供应商信息
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).GetEquipProvider(25)
ClassMethod GetEquipProvider(RowID As %Library.String = "")
{
	s ProviderDR=+$p($g(^DHCEQEquip(+RowID)),"^", 25)
	q ProviderDR_"^"_##class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
}

/// 检测验收单的供应商和其附属设备的供应商是否一致
/// 			不一致返回1
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).CheckConfigProvider(25)
ClassMethod CheckConfigProvider(RowID As %Library.String = "", ProviderDR As %Library.String = "0")
{
	i RowID="" q 0
	i ProviderDR="" q 0
	s Find=0
	s TMID=0
	f  s TMID=$o(^DHCEQConfig(0,"SourceID",1,RowID,TMID)) quit:(TMID="")||(Find'=0)  d
	.i $p($g(^DHCEQConfig(TMID)),"^",10)'=ProviderDR s Find=1
	q Find
}

/// 将验收单的供应商同步更新至其附属设备
/// 			失败返回非零
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).UpdateConfigProvider(25)
ClassMethod UpdateConfigProvider(RowID As %Library.String = "", ProviderDR As %Library.String = "0")
{
	i RowID="" q 0
	i ProviderDR="" q 0
	s SQLCODE=0
	TSTART
	s TMID=0
	f  s TMID=$o(^DHCEQConfig(0,"SourceID",1,RowID,TMID)) quit:(TMID="")||(SQLCODE'=0)  d
	.&SQL(Update SQLUSER.DHC_EQConfig Set C_ProviderDR=:ProviderDR where C_RowID=:TMID)
	
	if SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	TCOMMIT
	q SQLCODE
}

/// 创建:mwz 2021-01-18 
/// 描述:验收当前人自发撤回
/// 入参 val:验收单rowid^User^，CurRole ：当前菜单ApproveRole
/// 返回值：SQLCODE  RowID
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).SelfCancelSubmitData("40^^","7")
ClassMethod SelfCancelSubmitData(val As %Library.String = "", CurRole)
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	s CancelToFlowDR=""
	s APLRowID="",CurStep=0
	Set $ZT="ERRORSelfCancelSubmitData"
	Set User=$Piece(val,"^",2)
	i User="" 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("7", RowID)
	i CurRole'="" Set CancelToFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,CurRole,0))
	Set RejectReason="自发撤回"
	;获取取消到上一步的信息
	Set Status="0"     
	Set ApproveRoleDR=""
    s Step=1
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("7")
	if (CancelToFlowDR'="")
	{
		Set ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		Set Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		set APLRowID=$o(^DHCEQApproveList(0,"Source",ApproveType,RowID,""),-1)
		i APLRowID'="" set CurStep=$p($g(^DHCEQApproveList(APLRowID)),"^",9)
		Set Status="1"
	}
	i (Step'=CurStep)&&(CurStep'=0) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9022")
	
	TSTART 
	//Set RoleStep=1 //##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,RejectReason,"",CurRole,CurStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	Set PLIST(21)=	Status	// BR_Status
	Set PLIST(34)=CurRole    
 	Set PLIST(35)=CurStep
	&sql(Update SQLUSER.DHC_EQOpenCheckRequest Values :PLIST() where OCR_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("11", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORSelfCancelSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     				//得到系统返回的错误消息
 	Quit "ERRORSelfCancelSubmitData"_ErrorMsg   //返回错误消息
}

/// add by czf 2020-08-18
/// 获取DHCEQOpenCheckList的Json串
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).GetOneOpenCheckList(1487)
ClassMethod GetOneOpenCheckList(RowID As %Library.String = "")
{
	n Obj,DataInfo
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","RowID不能为空")
	s $ZT="ERRORGetOneOpenCheckList"
	s Obj=##Class(User.DHCEQOpenCheckList).%OpenId(RowID)
	s DataInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(Obj)
	d DataInfo.%Set("OCLBuyTypeDR_BTDesc",Obj.OCLBuyTypeDR.BTDesc)
	d DataInfo.%Set("OCLCountryDR_CTCOUDesc",##Class(web.DHCEQCommon).GetTrakNameByID("country", Obj.OCLCountryDR))
	d DataInfo.%Set("OCLCurrencyDR_CDesc",##Class(web.DHCEQCommon).GetTrakNameByID("currency", Obj.OCLCurrencyDR))
	d DataInfo.%Set("OCLDepreMethodDR_DMDesc",Obj.OCLDepreMethodDR.DMDesc)
	d DataInfo.%Set("OCLEquiCatDR_ECDesc",Obj.OCLEquiCatDR.ECDesc)
	d DataInfo.%Set("OCLEquipTechLevelDR_TLDesc",Obj.OCLEquipTechLevelDR.TLDesc)
	d DataInfo.%Set("OCLEquipTypeDR_ETDesc",Obj.OCLEquipTypeDR.ETDesc)
	d DataInfo.%Set("OCLInstallLocDR_CTLOCDesc",##Class(web.DHCEQCommon).GetTrakNameByID("dept", Obj.OCLInstallLocDR))
	d DataInfo.%Set("OCLItemDR_MIDesc",Obj.OCLItemDR.MIDesc)
	d DataInfo.%Set("OCLLocationDR_LDesc",Obj.OCLLocationDR.LDesc)
	d DataInfo.%Set("OCLManageLevelDR_MLDesc",Obj.OCLManageLevelDR.MLDesc)
	d DataInfo.%Set("OCLManageLocDR_CTLOCDesc",##Class(web.DHCEQCommon).GetTrakNameByID("dept", Obj.OCLManageLocDR))
	d DataInfo.%Set("OCLManuFactoryDR_VName",Obj.OCLManuFactoryDR.VName)
	d DataInfo.%Set("OCLModelDR_MDesc",Obj.OCLModelDR.MDesc)
    d DataInfo.%Set("OCLPackTypeDR_PTDesc",Obj.OCLPackTypeDR.PTDesc)
   	d DataInfo.%Set("OCLPurchaseTypeDR_PTDesc",Obj.OCLPurchaseTypeDR.PTDesc)
   	d DataInfo.%Set("OCLPurposeTypeDR_PTDesc",Obj.OCLPurposeTypeDR.PTDesc)
   	d DataInfo.%Set("OCLServiceDR_VName",Obj.OCLServiceDR.VName)
   	d DataInfo.%Set("OCLStoreLocDR_CTLOCDesc",##Class(web.DHCEQCommon).GetTrakNameByID("dept", Obj.OCLStoreLocDR))
   	d DataInfo.%Set("OCLUnitDR_UOMDesc",##Class(web.DHCEQCommon).GetTrakNameByID("uom", Obj.OCLUnitDR))
   	d DataInfo.%Set("OCLUseLocDR_CTLOCDesc",##Class(web.DHCEQCommon).GetTrakNameByID("dept", Obj.OCLUseLocDR))
   	d DataInfo.%Set("OCLUserDR_SSUSRName",##Class(web.DHCEQCommon).GetTrakNameByID("user", Obj.OCLUserDR))
   	d DataInfo.%Set("OCLWorkLoadUnitDR_UOMDesc",##Class(web.DHCEQCommon).GetTrakNameByID("uom", Obj.OCLWorkLoadUnitDR))
   	s OCLLeaveFactoryNos=$g(^DHCEQOpenCheckList(RowID,"EX"))		//add by czf 2020-11-16
   	s OCLFileNos=$g(^DHCEQOpenCheckList(RowID,"FileNo"))
   	d DataInfo.%Set("OCLLeaveFactoryNos",OCLLeaveFactoryNos)
   	d DataInfo.%Set("OCLFileNos",OCLFileNos)
   	s ManuFacInfo=$g(^DHCEQOpenCheckList(RowID,"MFInfo"))	//czf 2021-11-04
   	s TempBar=$g(^DHCEQOpenCheckList(RowID,"TempBar"))
   	d DataInfo.%Set("OCLManuFacHandler",$p(ManuFacInfo,"^",1))
   	d DataInfo.%Set("OCLManuFacTel",$p(ManuFacInfo,"^",2))
   	d DataInfo.%Set("OCLTempBar",TempBar)
    d DataInfo.%Set("OCLHold5_EDesc",##Class(web.DHCEQCommon).GetTrakNameByID("expense", Obj.OCLHold5))
   	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,DataInfo)
ERRORGetOneOpenCheckList
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// czf 2022-05-25
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).IsInstall("IsInstall")
ClassMethod IsInstall(name, width As %String = "", promptinfo As %String = "") As %String
{
    ;;下拉列表
    w ##class(web.DHCEQCommon).GetDefaultStyle(name, width, promptinfo)
    w "<option value=></option>"
    w "<option value=1>是</option>"
    w "<option value=0>否</option>"
    w "</select>",!
}

/// Modefied by ZY0307 2022-07-13 北海人民迁移过来的
/// 2014-08-21 DJ0126
/// 新旧程度
ClassMethod GetNewOldPercent(name, width As %String = "", promptinfo As %String = "") As %String
{
    ;;下拉列表
    w ##class(web.DHCEQCommon).GetDefaultStyle(name, width, promptinfo)
    w "<option value=></option>"
    w "<option value=0>全新</option>"
    w "<option value=1>九成新</option>"
    w "<option value=2>八成新</option>"
    w "<option value=3>七成新</option>"
    w "<option value=4>六成新</option>"
    w "<option value=5>五成新</option>"
    w "<option value=10>旧设备</option>"
    w "</select>",!
}

/// add by ZY     2849944  20220815
/// 在取当前临时id的时候,删除前一天的临时数据
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).GetCurSourceID()
ClassMethod GetCurSourceID(BussType) As %String
{
    s Date=+$H
    s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    s Job=$j
    s TmpSourceID=Date_"-"_User_"-"_Job
    
    if (BussType="11")
    {
        s SourceID=0
        f  s SourceID=$o(^DHCEQFunds("0","Source",0,SourceID))  q:(SourceID="")  d
        .q:SourceID'["-"
        .s tmpDate=$p(SourceID,"-",1)
        .i tmpDate<Date  d
        ..&SQL(delete from SQLUSER.DHC_EQFunds  where F_SourceType ='0' and F_SourceID =:SourceID)
        ..i SQLCODE=100 s SQLCODE=0
    }
    elseif (BussType="91")
    {
        //^DHCEQMultipleApproveInfo(0,"SourceID",BApproveType,BusRowID
        s SourceID=0
        f  s SourceID=$o(^DHCEQMultipleApproveInfo("0","SourceID",1,SourceID))  q:(SourceID="")  d
        .q:SourceID'["-"
        .s tmpDate=$p(SourceID,"-",1)
        .i tmpDate<Date  d
        ..&SQL(delete from SQLUSER.DHC_EQMultipleApproveInfo  where MA_ApproveTypeDR ='1' and MA_BusID =:SourceID)
        ..i SQLCODE=100 s SQLCODE=0
        
        s SourceID=0
        f  s SourceID=$o(^DHCEQIFBList("0","Source",1,SourceID))  q:(SourceID="")  d
        .q:SourceID'["-"
        .s tmpDate=$p(SourceID,"-",1)
        .i tmpDate<Date  d
        ..&SQL(delete from SQLUSER.DHC_EQIFBList  where IFBL_SourceType ='1' and IFBL_SourceID =:SourceID)
        ..i SQLCODE=100 s SQLCODE=0
        
        s SourceID=0
        f  s SourceID=$o(^DHCEQResearch("0","SourceType",1,1,SourceID))  q:(SourceID="")  d
        .q:SourceID'["-"
        .s tmpDate=$p(SourceID,"-",1)
        .i tmpDate<Date  d
        ..&SQL(delete from SQLUSER.DHC_EQResearch  where R_BussType='1' and R_SourceType ='1'  and R_SourceID = :SourceID)
        ..i SQLCODE=100 s SQLCODE=0
        
        s SourceID=0
        f  s SourceID=$o(^DHCEQEconCalc("0","Source",1,SourceID))  q:(SourceID="")  d
        .q:SourceID'["-"
        .s tmpDate=$p(SourceID,"-",1)
        .i tmpDate<Date  d
        ..&SQL(delete from SQLUSER.DHC_EQEconCalc  where EC_SourceType ='1'  and EC_SourceID = :SourceID)
        ..i SQLCODE=100 s SQLCODE=0
       
        s SourceID=0
        f  s SourceID=$o(^DHCEQEquipService("0","BussSource",1,SourceID))  q:(SourceID="")  d
        .q:SourceID'["-"
        .s tmpDate=$p(SourceID,"-",1)
        .i tmpDate<Date  d
        ..&SQL(delete from SQLUSER.DHC_EQEquipService  where ES_BussType='1' and ES_SourceType ='3'  and ES_SourceID = :SourceID)
        ..i SQLCODE=100 s SQLCODE=0
    }
    elseif (BussType="51")
    {
        s SourceID=0
        f  s SourceID=$o(^DHCEQFunds("0","Source",7,SourceID))  q:(SourceID="")  d
        .q:SourceID'["-"
        .s tmpDate=$p(SourceID,"-",1)
        .i tmpDate<Date  d
        ..&SQL(delete from SQLUSER.DHC_EQFunds  where F_SourceType ='7' and F_SourceID =:SourceID)
        ..i SQLCODE=100 s SQLCODE=0
    }
    q TmpSourceID
}

/// add by ZY 20220913 2907381、2907386、2907390
/// 根据系统参数判断专属信息类型
/// 401002 土地类型ID 
/// 401003 房屋建筑物类型ID
/// 401005 交通工具类型ID
/// 990023 无形资产类组ID
/// 根据来源类型判断专属类型
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).GetExclusiveType(0,1)
ClassMethod GetExclusiveType(SourceType As %String = "0", SourceID As %String = "")
{
    new OCRRowID,StatCatDR,EquipTypeDR
    s (OCRRowID,StatCatDR,EquipTypeDR)=""
    i SourceID="" q ""
    if SourceType=0
    {
        s OCRRowID=$Piece($Get(^DHCEQOpenCheckList(SourceID)),"^",1)
        s StatCatDR=$Piece($Get(^DHCEQOpenCheckList(SourceID)),"^",28)
        s EquipTypeDR=$P($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",2)
    }
    elseif SourceType=1
    {
        s EquipTypeDR=$Piece($Get(^DHCEQEquip(SourceID)),"^",63)
        s StatCatDR=$P($g(^DHCEQEquip(SourceID)),"^",75)
    }
    if ((","_##class(web.DHCEQCommon).GetSysInfo("401002")_",")[(","_StatCatDR_",")) q "DHCEQLand"
    if ((","_##class(web.DHCEQCommon).GetSysInfo("401003")_",")[(","_StatCatDR_",")) q "DHCEQBuilding"
    if ((","_##class(web.DHCEQCommon).GetSysInfo("990023")_",")[(","_EquipTypeDR_",")) q "DHCEQIntangibleAssets"
    if ((","_##class(web.DHCEQCommon).GetSysInfo("401005")_",")[(","_StatCatDR_",")) q "DHCEQVehicle"
    q ""
}

/// add by ZY 20220913 2907381、2907386、2907390
/// 根据来源保存对应类型的专属信息
/// 入参：data ：专属信息json字符串
/// 	SourceType：0  验收  1 台账
/// 	SourceID： 验收明细ID/台账ID
/// 返回值  SQLCODE 0 成功  其他  错误代码
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).SaveExclusiveInfo(data,0,OCLRowID)
ClassMethod SaveExclusiveInfo(data, SourceType As %String = "0", SourceID As %String = "")
{
    i data="" q 0
    new ExclusiveType,result,SQLCODE
    s result=""
    s SQLCODE=0
    s ExclusiveType=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).GetExclusiveType(SourceType,SourceID)
    if ExclusiveType="DHCEQLand"
    {
        s result=##Class(web.DHCEQ.EM.BUSLand).SaveData(data)
    }
    elseif ExclusiveType="DHCEQBuilding"
    {
        s result=##Class(web.DHCEQ.EM.BUSBuilding).SaveData(data)
    }
    elseif ExclusiveType="DHCEQIntangibleAssets"
    {
        s result=##Class(web.DHCEQ.EM.BUSIntangibleAssets).SaveData(data)
    }
    elseif ExclusiveType="DHCEQVehicle"
    {
        s result=##Class(web.DHCEQ.EM.BUSVehicle).SaveData(data)
    }
    i result="" q SQLCODE
    s result=##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(result)
    s SQLCODE=result.SQLCODE
    i SQLCODE'=0 q result.Data
    q SQLCODE
}

/// add by ZY 20220913 2907381、2907386、2907390
/// 根据来源保存写台账对应的专属信息
/// 入参：SourceType：0  验收  1 台账
/// SourceID： 验收明细ID/台账ID
///     EquipID：台账ID
/// 返回值  SQLCODE 0 成功  其他  错误代码
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).InsertExclusiveByOCL(0,121,37)
ClassMethod InsertExclusiveByOCL(SourceType As %String = "0", SourceID As %String = "", EquipID)
{
    new ExclusiveType,ExclRowID,Obj,ObjInfo,result,SQLCODE
    s result=""
    s SQLCODE=0
    s ExclusiveType=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).GetExclusiveType(SourceType,SourceID)
    i ExclusiveType="" q SQLCODE
    if ExclusiveType="DHCEQLand"
    {
        s ExclRowID=$Order(^DHCEQLand(0,"Source",SourceType,SourceID,0))
        if (ExclRowID'="")
        {
            s Obj=##Class(User.DHCEQLand).%OpenId(ExclRowID)
            s ObjInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(Obj)
            d ObjInfo.%Set("LEquipDR",EquipID)
            d ObjInfo.%Set("LSourceType","1")
            d ObjInfo.%Set("LSourceID",EquipID)
            s ObjInfo=ObjInfo.%ToJSON()
            s result=##Class(web.DHCEQ.EM.BUSLand).SaveData(ObjInfo)
        }
    }
    elseif ExclusiveType="DHCEQBuilding"
    {
        s ExclRowID=$Order(^DHCEQBuilding(0,"OpenCheckList",SourceID,0))
        if (ExclRowID'="")
        {
            s Obj=##Class(User.DHCEQBuilding).%OpenId(ExclRowID)
            s ObjInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(Obj)
            d ObjInfo.%Set("BDEquipDR",EquipID)
            d ObjInfo.%Set("BDOpenCheckListDR","")
            s ObjInfo=ObjInfo.%ToJSON()
            s result=##Class(web.DHCEQ.EM.BUSBuilding).SaveData(ObjInfo)
        }
    }
    elseif ExclusiveType="DHCEQIntangibleAssets"
    {
        s ExclRowID=$Order(^DHCEQIntangibleAssets(0,"Source",SourceType,SourceID,0))
        if (ExclRowID'="")
        {
            s Obj=##Class(User.DHCEQIntangibleAssets).%OpenId(ExclRowID)
            s ObjInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(Obj)
            d ObjInfo.%Set("IAEquipDR",EquipID)
            d ObjInfo.%Set("IASourceType","1")
            d ObjInfo.%Set("IASourceID",EquipID)
            s ObjInfo=ObjInfo.%ToJSON()
            s result=##Class(web.DHCEQ.EM.BUSIntangibleAssets).SaveData(ObjInfo)
        }
    }
    elseif ExclusiveType="DHCEQVehicle"
    {
        s ExclRowID=$Order(^DHCEQVehicle(0,"Source",SourceType,SourceID,0))
        
        if (ExclRowID'="")
        {
            s Obj=##Class(User.DHCEQVehicle).%OpenId(ExclRowID)
            s ObjInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(Obj)
            d ObjInfo.%Set("VEquipDR",EquipID)
            d ObjInfo.%Set("VSourceType","1")
            d ObjInfo.%Set("VSourceID",EquipID)
            s ObjInfo=ObjInfo.%ToJSON()
            s result=##Class(web.DHCEQ.EM.BUSVehicle).SaveData(ObjInfo)
        }
    }
    i result="" q SQLCODE
    s result=##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(result)
    s SQLCODE=$p(result.SQLCODE,"^",1)
    i SQLCODE'=0 q result.Data
    q SQLCODE
}

/// add by txr 20230417 管理类别
/// w ##Class(web.DHCEQ.EM.BUSOpenCheckRequest).ManageCate("ManageCate")
ClassMethod ManageCate(name, width As %String = "", promptinfo As %String = "") As %String
{
 	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name, width, promptinfo)
	w "<option value=></option>"
 	w "<option value=1>一类</option>"
	w "<option value=2>二类</option>"
	w "<option value=3>三类</option>"
	w "<option value=0>其他</option>"
	w "</select>",!
}

}

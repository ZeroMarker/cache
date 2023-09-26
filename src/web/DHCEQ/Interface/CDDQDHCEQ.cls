/// 成都第七物资接口
/// add by czf CZF0062 2020-02-24
/// 入参日期格式统一为yyyy-mm-dd
Class web.DHCEQ.Interface.CDDQDHCEQ Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：CZF0062 2020-02-24
/// Description：物资系统入库审核时保存计量设备信息
/// Input:入库多条材料时明细数据,格式: 名称^编码^型号^数量^单位^原值^耗材类组^耗材分类^使用科室^入库单号^入库日期^供应商^入库人^生产厂商^出厂编号^出厂日期^国别^品牌^管理负责人^库房
/// 	  多条数据之间用$c(1)分隔
/// OutPut:0:数据保存成功 其他：不成功
/// Command:w ##class(web.DHCEQ.Interface.CDDQDHCEQ).SaveData("镊子^DZHC0002^HS01^3^个^200.00^^^87^RK20190814001^65241^设备供应公司^1^设备生产厂商^RH89232^65240^中国^格力^^467")
ClassMethod SaveData(val As %Library.String = "")
{
	n len,i,valList,MRowID,URowID,ModelDR,ProviderID,FacRowid
	
	s (MRowID,URowID,ModelDR,ProviderID,FacRowid)=""
	s Flag=0
	s ^TmpCZF("InStock")=val
	s len=$l(val,$c(1))
	k PLISTEQ
	f i=1:1:len d
	.q:Flag'=0
	.s valList=$p(val,$c(1),"i")
	.s Num=$p(val,"^",4)
	.i Num="" s Num=1
	.f j=1:1:Num d
	..s PLISTEQ(2)=$p(val,"^",1)	;EQ_Name
	..s PLISTEQ(92)=$p(val,"^",2)	;EQ_OldNo
	..s PLISTEQ(64)=6 		;设备类组 默认低值耗材
	..s PLISTEQ(76)=19		;设备类型 默认计量标准器具及量具,衡器
	..s PLISTEQ(5)=1063		;设备分类 默认计量标准器具及量具,衡器
	..s PLISTEQ(7)=##class(web.DHCEQCHanZiEncoding).GetEncoding(PLISTEQ(2),4,"","U")	;EQ_Code
	..s Unit=$p(val,"^",5)
	..s UCode=##class(web.DHCEQCHanZiEncoding).GetEncoding(Unit,4,"","U")
	..s UOMType=2 		;设备单位
	..&SQL(select UOM_RowID into :URowID from SQLUSER.DHC_EQCUOM where UOM_Desc=:Unit and UOM_UOMType=:UOMType and UOM_InvalidFlag<>'Y')
	..i URowID="" d
	...s UList="^^"_UOMType_"^"_UCode_"^"_Unit
	...s URowID=##class(web.DHCEQCUOM).SaveData("","",UList,"")
	...i URowID<=0 s Flag=1
	..q:Flag'=0
	..s PLISTEQ(6)=URowID	;EQ_UnitDR
	..&SQL(select MI_RowID into :ItemDR from SQLUSER.DHC_EQCMasterItem where MI_Code=:PLISTEQ(7) and MI_Desc=:PLISTEQ(2) and MI_EquipTypeDR=:PLISTEQ(64) and MI_InvalidFlag='N')
	..i ItemDR="" d
	...s MList="^"_PLISTEQ(2)_"^"_PLISTEQ(7)_"^"_PLISTEQ(64)_"^"_PLISTEQ(5)_"^"_PLISTEQ(76)_"^^"_URowID
	...s MRowID=##class(web.DHCEQCMasterItem).SaveData("","",MList,"")
	...i MRowID<=0 s Flag=1
	..q:Flag'=0
	..s PLISTEQ(8)=MRowID	;EQ_ItemDR
	..s Model=$p(val,"^",3)
	..i Model'="" d
	...s MCode=##class(web.DHCEQCHanZiEncoding).GetEncoding(Model,4,"","U")	;EQ_Code
	...&SQL(select M_RowID into :ModelDR from SQLUSER.DHC_EQCModel where M_Desc=:Model and M_ItemDR=:MRowID and M_InvalidFlag='N')
	...i ModelDR="" d
	....s ModelList="^"_MCode_"^"_Model_"^^"_MRowID_"^^^^^"
	....s ModelDR=##class(web.DHCEQCModel).SaveData("","",ModelList,2)
	....i ModelDR<=0 s Flag=1
	..q:Flag'=0
	..s PLISTEQ(4)=ModelDR	;EQ_ModelDR
	..s PLISTEQ(18)=$p(val,"^",20)	;managelocdr
	..s PLISTEQ(21)=1		;EQ_OriginDR 设备来源
	..s PLISTEQ(28)=$p(val,"^",6)	;EQ_OriginalFee
	..s PLISTEQ(106)=$p(val,"^",7)	;EQ_Hold2 耗材类组
	..s PLISTEQ(107)=$p(val,"^",8)	;EQ_Hold3 耗材分类
	..s UseLocID=$p(val,"^",9)
	..;s UseLocID=##Class(web.DHCEQImportDataTool).GetUseLocIDForXY2(UseLoc)
	..s PLISTEQ(20)=UseLocID	;EQ_UseLocDR
	..s StoreLocID=$p(val,"^",20)
	..;s StoreLocID=##Class(web.DHCEQImportDataTool).GetUseLocIDForXY2(StoreLoc)
	..s PLISTEQ(68)=StoreLocID	;EQ_StoreLocDR
	..s InStockNo=$p(val,"^",10)
	..s InStockDate=$p(val,"^",11)
	..s InStockUser=$p(val,"^",13)
	..q:InStockDate=""
	..s InStockInfo=InStockUser_$zd(InStockDate,3)_"入库,入库单号:"_InStockNo
	..s PLISTEQ(35)=InStockInfo		;EQ_Remark	
	..s UserID=##Class(web.DHCEQImportDataTool).GetUserID(InStockUser)
	..;i InStockDate'="" s InStockDate=$zdh(InStockDate,3)
	..s PLISTEQ(46)=InStockDate	;EQ_TransAssetDate
	..s PLISTEQ(53)=UserID		;EQ_AddUser
	..s PLISTEQ(54)=InStockDate	;EQ_AddDate
	..s PLISTEQ(56)=UserID		;EQ_UpdateUser
	..s PLISTEQ(57)=InStockDate	;EQ_UpdateDate
	..s PLISTEQ(106)=InStockNo	;EQ_Hold2
	..s Provider=$p(val,"^",12)
	..s PCode=##class(web.DHCEQCHanZiEncoding).GetEncoding(Provider,4,"","U")
	..&SQL(select V_RowID into :ProviderID from SQLUSER.DHC_EQCVendor where V_Name=:Provider)
	..i ProviderID="" d
	...s PList="^"_PCode_"^"_Provider_"^^^^^^^^^^^^^^^^^^^^"
	...s ProviderID=##class(web.DHCEQCVendor).SaveData(PList,"")
	...i ProviderID="" s Flag=1
	..q:Flag'=0
	..s PLISTEQ(26)=ProviderID
	..s Manufacturer=$p(val,"^",14)
	..s FacCode=##class(web.DHCEQCHanZiEncoding).GetEncoding(Manufacturer,4,"","U")
	..&SQL(select MF_RowID into :FacRowid from SQLUSER.DHC_EQCManufacturer where MF_Name=:Manufacturer and MF_InvalidFlag='N')
	..i FacRowid="" d
	...s FList="^"_Manufacturer_"^"_FacCode_"^^^^^^^^^^^^^"
	...s FacRowid=##class(web.DHCEQCManufacturer).SaveData("","",FList,"")
	...i FacRowid="" s Flag=1
	..q:Flag'=0
	..s PLISTEQ(27)=FacRowid
	..s PLISTEQ(11)=$p(val,"^",15)	;EQ_LeaveFactoryNo
	..s LeaveFacDate=$p(val,"^",16)
	..;i LeaveFacDate'= "" s LeaveFacDate=$zdh(LeaveFacDate,3)
	..s PLISTEQ(12)=LeaveFacDate	;EQ_LeaveFactoryDate
	..s Country=$p(val,"^",17)
	..s CountryDR=##Class(web.DHCEQImportDataTool).GetCountryID(Country)
	..s PLISTEQ(17)=""
	..i CountryDR'="" s PLISTEQ(17)=CountryDR
	..s Brand=$p(val,"^",18)
	..s BrandID=##Class(web.DHCEQImportDataTool).GetbrandID(Brand)
	..s PLISTEQ(95)=""
	..i BrandID'="" s PLISTEQ(95)=BrandID
	..s Manager=$p(val,"^",19)
	..s ManagerID=##Class(web.DHCEQImportDataTool).GetUserID(Manager)
	..s PLISTEQ(40)=""
	..i ManagerID'="" s PLISTEQ(40)=ManagerID
	..s PLISTEQ(16)="Y"	;EQ_ComputerFlag 计量标志
	..s PLISTEQ(39)=0	;EQ_Status
	..s PLISTEQ(61)=1	;EQ_StockStatus
	..s PLISTEQ(48)="Y"	;EQ_InputFlag
	..s PLISTEQ(60)="N"	;EQ_InvalidFlag
	..&SQL(Insert Into SQLUSER.DHC_EQEquip Values :PLISTEQ())
	..i SQLCODE s Flag=SQLCODE
	..q:Flag'=0
	..s ID=$g(%ROWID)
	..s updateNo=##Class(web.DHCEQEquip).UpdateEquipNo(ID,+$H)
	..i updateNo s Flag=updateNo
	..q:Flag'=0
	
	q Flag
}

/// Creator：CZF0062 2020-02-24
/// Description：物资系统退货审核时更新计量设备信息
/// Input:退货多条材料时明细数据,格式: 耗材名称^耗材编码^供应商^退货单号^退货人^退货原因^退货日期^退货数量^入库单号
/// 	  多条数据之间用$c(1)分隔
/// OutPut:0:数据保存成功 其他：不成功
/// Command:w ##class(web.DHCEQ.Interface.CDDQDHCEQ).ReturnUpdData("美乐胶(1517002)^NPH00001^JH-成都嘉鸿医疗器械有限公司^5035MPT20190816003^1^^65241^-1")
ClassMethod ReturnUpdData(val As %Library.String = "")
{
	n len,valList,Flag,ReturnInfo,i,ReturnNum
	
	s ^TmpCZF("return")=val
	s Flag=0
	s len=$l(val,$c(1))
	f i=1:1:len
	{
		s valList=$p(val,$c(1),i)
		s Name=$p(valList,"^",1)	;材料名称
		s No=$p(valList,"^",2)		;材料编码
		s Provider=$p(valList,"^",3)
		s ProviderID=##Class(web.DHCEQImportDataTool).GetProviderID(Provider,1)
		s ReturnNo=$p(valList,"^",4)
		s ReturnUser=$p(valList,"^",5)
		s ReturnUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",ReturnUser)
		s Reason=$p(valList,"^",6)
		s ReturnDate=$p(valList,"^",7)
		i ReturnDate'="" s ReturnDate=$zd(ReturnDate,3)
		s ReturnInfo=ReturnUser_ReturnDate_"退货,退货单号:"_ReturnNo
		i Reason'="" s ReturnInfo=ReturnInfo_",退货原因:"_Reason
		s ReturnNum=$p(valList,"^",8)
		s ReturnNum=-1*ReturnNum
		s InStockNo=$p(valList,"^",9)
		s EquipTypeDR=6	;设备类组 计量耗材
		s StatCatDR=19	;设备类型 默认计量标准器具及量具,衡器
		s Count=1
		s StoreLocDR=""
		f  s StoreLocDR=$o(^DHCEQEquip(0,"StoreLocStatCat",StoreLocDR)) q:(StoreLocDR="")||(Flag'=0)  d
		.s EQRowID=""
		.f  s EQRowID=$o(^DHCEQEquip(0,"StoreLocStatCat",StoreLocDR,EquipTypeDR,StatCatDR,EQRowID)) q:(EQRowID="")||(Count>ReturnNum)  d
		..q:Flag'=0
		..q:$p($g(^DHCEQEquip(EQRowID)),"^",38)'=0 	;Status
		..q:$p($g(^DHCEQEquip(EQRowID)),"^",60)'=1	;StockStatus
		..q:$p($g(^DHCEQEquip(EQRowID)),"^",59)'="N"	;InvalidFlag
		..s EQHold2=$p($g(^DHCEQEquip(EQRowID,"OtherInfo")),"^",10)
		..q:(InStockNo'="")&&(InStockNo'=EQHold2)
		..q:(Name'=$p($g(^DHCEQEquip(EQRowID)),"^",1))	;Name
		..q:(ProviderID'="")&&(ProviderID'=$p($g(^DHCEQEquip(EQRowID)),"^",25))	;ProviderDR
		..q:(No'="")&&(No'=$p($g(^DHCEQEquip(EQRowID)),"^",91))	;OldNo
		..s Remark=$p($g(^DHCEQEquip(EQRowID)),"^",34)
		..i Remark'="" s Remark=Remark_";"_ReturnInfo
		..e  s Remark=ReturnInfo
		..&SQL(Update SQLUSER.DHC_EQEquip set EQ_Status=2,EQ_StockStatus=2,EQ_Remark=:Remark where EQ_RowID=:EQRowID)
		..i SQLCODE s Flag=1
		..q:Flag'=0
		..s Count=Count+1
		q:Flag'=0
	}
	q Flag
}

/// Creator：CZF0062 2020-02-24
/// Description：物资系统转移审核时更新计量设备信息
/// Input:转移多条材料时明细数据,格式: 耗材名称^耗材编码^来源科室^接收科室^转移类型^转移单号^转移日期^操作人^转移数量^入库单号^供应商
/// 	  多条数据之间用$c(1)分隔
/// OutPut:0:数据保存成功 其他：不成功
/// Command:w ##class(web.DHCEQ.Interface.CDDQDHCEQ).StoreMoveUpdData("镊子^DZHC0002^病理科^固定资产库房^^ZY201908140001^2019-08-14^demo^1^^设备供应公司")
ClassMethod StoreMoveUpdData(val As %Library.String = "")
{
	n len,i,valList,Flag,ToLocDR,UseLocDR,StoreLocDR,StartDate,StoreMoveInfo
	s ^TmpCZF("StoreMove")=val
	s Flag=0
	s len=$l(val,$c(1))
	f i=1:1:len
	{
		s valList=$p(val,$c(1),i)
		s Name=$p(valList,"^",1)	;材料名称
		s No=$p(valList,"^",2)		;材料编码
		s FromLoc=$p(valList,"^",3)	;出库科室
		s FromLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",FromLoc)
		s ToLoc=$p(valList,"^",4)	;接收科室
		s ToLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",ToLoc)
		s MoveType=$p(valList,"^",5)	;
		s StoreMoveNo=$p(valList,"^",6)	;转移单号
		s StoreMoveDate=$p(valList,"^",7)
		i StoreMoveDate'="" s StoreMoveDate=$zd(StoreMoveDate,3)
		s StoreMoveUser=$p(valList,"^",8)
		s StoreMoveUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",StoreMoveUser)
		s StoreMoveInfo=StoreMoveUser_StoreMoveDate_"转移,转移单号:"_StoreMoveNo
		s StoreMoveNum=$p(valList,"^",9)
		s InStockNo=$p(valList,"^",10)	;入库单号
		s Provider=$p(valList,"^",11)
		s ProviderID=##Class(web.DHCEQImportDataTool).GetProviderID(Provider,1)
		s EquipTypeDR=6	;设备类组 计量耗材
		s StatCatDR=19	;设备类型 默认计量标准器具及量具,衡器
		s StartDate=$zdh(StoreMoveDate,3)	;启用日期
		;s StoreLocID=##Class(web.DHCEQImportDataTool).GetUseLocIDForXY2(ToLoc)
		s StoreLocID=ToLoc
		s UseLocDR=StoreLocID
		s Count=1
		s Type=""
		i (FromLocDesc["库房") d
		.i (ToLocDesc["库房") s Type=4,UseLocDR="" 	;库房调拨
		.e  s Type=0	;出库
		e  d
		.i (ToLocDesc["库房") s Type=3,UseLocDR="" 	;科室退库
		.e  s Type=1	;科室调拨
		s StoreLocDR=""
		f  s StoreLocDR=$o(^DHCEQEquip(0,"StoreLocStatCat",StoreLocDR)) q:(StoreLocDR="")||(Flag'=0)  d
		.s EQRowID=""
		.f  s EQRowID=$o(^DHCEQEquip(0,"StoreLocStatCat",StoreLocDR,EquipTypeDR,StatCatDR,EQRowID)) q:(EQRowID="")||(Count>StoreMoveNum)  d
		..q:Flag'=0
		..s Status=$p($g(^DHCEQEquip(EQRowID)),"^",38)	;Status
		..q:(Type=0||Type=4)&&(Status'=0)
		..q:(Type=1||Type=3)&&(Status'=1)
		..q:$p($g(^DHCEQEquip(EQRowID)),"^",60)'=1	;StockStatus
		..q:$p($g(^DHCEQEquip(EQRowID)),"^",59)'="N"	;InvalidFlag
		..s EQHold2=$p($g(^DHCEQEquip(EQRowID,"OtherInfo")),"^",10)
		..q:(InStockNo'="")&&(InStockNo'=EQHold2)
		..q:(Name'=$p($g(^DHCEQEquip(EQRowID)),"^",1))	;Name
		..q:(ProviderID'="")&&(ProviderID'=$p($g(^DHCEQEquip(EQRowID)),"^",25))	;ProviderDR
		..q:(No'="")&&(No'=$p($g(^DHCEQEquip(EQRowID)),"^",91))	;OldNo 材料编码
		..s Remark=$p($g(^DHCEQEquip(EQRowID)),"^",34)
		..i Remark'="" s Remark=Remark_";"_StoreMoveInfo
		..e  s Remark=ReturnInfo
		..i Type=0 s Status=1
		..i Type=3 s Status=0
		..&SQL(Update SQLUSER.DHC_EQEquip set EQ_Status=:Status,EQ_Remark=:Remark,EQ_UseLocDR=:UseLocDR,EQ_StoreLocDR=:StoreLocID,EQ_StartDate=:StartDate where EQ_RowID=:EQRowID)
		..i SQLCODE s Flag=1
		..q:Flag'=0
		..s Count=Count+1
		q:Flag'=0
		
	}
	q Flag
}

}

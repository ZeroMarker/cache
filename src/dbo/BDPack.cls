/// 血袋信息
Class dbo.BDPack Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_Pack, StorageStrategy = Default ]
{

Index IndexArriveDate On ArriveDate [ SqlName = Index_ArriveDate, Type = index ];

Index IndexBarcode On (PackBarcode, ProductBarcode) [ SqlName = Index_Barcode, Type = index ];

Index IndexCallbackDate On CallbackDate [ SqlName = Index_CallbackDate, Type = index ];

Index IndexDonorID On DonorID [ SqlName = Index_DonorID, Type = index ];

Index IndexInfusionStartDate On InfusionStartDate [ SqlName = Index_InfusionStartDate, Type = index ];

Index IndexMaster On (PackID, SecondID) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPackStatus On PackStatusDR [ SqlName = Index_PackStatus, Type = index ];

Index IndexParentPack On ParentPackDR [ SqlName = Index_ParentPack, Type = index ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

Index IndexPatientRegNo On PatientRegNo [ SqlName = Index_PatientRegNo, Type = index ];

Index IndexReceiveDate On (WorkGroupDR, ReceiveDate) [ SqlName = Index_ReceiveDate, Type = index ];

Index IndexReq On ReqDR [ SqlName = Index_Req, Type = index ];

Index IndexStatusStock On StatusStock [ SqlName = Index_StatusStock, Type = index ];

Index IndexStockInDate On (WorkGroupDR, StockInDate) [ SqlName = Index_StockInDate, Type = index ];

Index IndexStockOutDate On (WorkGroupDR, StockOutDate) [ SqlName = Index_StockOutDate, Type = index ];

Index IndexPosition On PackPositionDR [ SqlName = Index_PositionID, Type = index ];

Index IndexCheckDate On (WorkGroupDR, CheckDate) [ SqlName = Index_CheckDate, Type = index ];

Index IndexInfusionEndDate On InfusionEndDate [ SqlName = Index_InfusionEndDate, Type = index ];

Index IndexSupplierNo On (SupplierNo, StockInDate, WorkGroupDR) [ SqlName = Index_SupplierNo, Type = index ];

Index IndexPackNo On (PackNo, WorkGroupDR) [ SqlName = Index_PackNo, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDPACK On RowID [ PrimaryKey, SqlName = PK_BD_PACK, Type = index, Unique ];

/// Foreign Key FKBDPackArriveLocation created via DDL
ForeignKey FKBDPackArriveLocation(ArriveLocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BD_Pack_ArriveLocation ];

/// Foreign Key FKBDPackArriveUser created via DDL
ForeignKey FKBDPackArriveUser(ArriveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_ArriveUser ];

/// Foreign Key FKBDPackArriveWard created via DDL
ForeignKey FKBDPackArriveWard(ArriveWardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_BD_Pack_ArriveWard ];

/// Foreign Key FKBDPackBGroup created via DDL
ForeignKey FKBDPackBGroup(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_Pack_BGroup ];

/// Foreign Key FKBDPackBloodProduct created via DDL
ForeignKey FKBDPackBloodProduct(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BD_Pack_BloodProduct ];

/// Foreign Key FKBDPackCallbackUser created via DDL
ForeignKey FKBDPackCallbackUser(CallbackUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_CallbackUser ];

/// Foreign Key FKBDPackCheckUser created via DDL
ForeignKey FKBDPackCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_CheckUser ];

/// Foreign Key FKBDPackFirstCheckUser created via DDL
ForeignKey FKBDPackFirstCheckUser(FirstCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_FirstCheckUser ];

/// Foreign Key FKBDPackInfusionEndUser created via DDL
ForeignKey FKBDPackInfusionEndUser(InfusionEndUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_InfusionEndUser ];

/// Foreign Key FKBDPackPackStatus created via DDL
ForeignKey FKBDPackPackStatus(PackStatusDR) References dbo.BBPackStatus(PKBBPACKSTATUS) [ SqlName = FK_BD_Pack_PackStatus ];

/// Foreign Key FKBDPackParent created via DDL
ForeignKey FKBDPackParent(ParentPackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_Pack_Parent ];

/// Foreign Key FKBDPackPatientLocation created via DDL
ForeignKey FKBDPackPatientLocation(PatientLocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BD_Pack_PatientLocation ];

/// Foreign Key FKBDPackPatientWard created via DDL
ForeignKey FKBDPackPatientWard(PatientWardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_BD_Pack_PatientWard ];

/// Foreign Key FKBDPackReceiveUser created via DDL
ForeignKey FKBDPackReceiveUser(ReceiveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_ReceiveUser ];

/// Foreign Key FKBDPackReq created via DDL
ForeignKey FKBDPackReq(ReqDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_Pack_Req ];

/// Foreign Key FKBDPackSecondCheckUser created via DDL
ForeignKey FKBDPackSecondCheckUser(SecondCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_SecondCheckUser ];

/// Foreign Key FKBDPackStockInUser created via DDL
ForeignKey FKBDPackStockInUser(StockInUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_StockInUser ];

/// Foreign Key FKBDPackStockOutUser created via DDL
ForeignKey FKBDPackStockOutUser(StockOutUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_StockOutUser ];

/// Foreign Key FKBDPackSupplier created via DDL
ForeignKey FKBDPackSupplier(SupplierDR) References dbo.BBSupplier(PKBBSUPPLIER) [ SqlName = FK_BD_Pack_Supplier ];

/// Foreign Key FKBDPackUnfreezeEUser created via DDL
ForeignKey FKBDPackUnfreezeEUser(UnfreezeEUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_UnfreezeEUser ];

/// Foreign Key FKBDPackUnfreezeSUser created via DDL
ForeignKey FKBDPackUnfreezeSUser(UnfreezeSUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_UnfreezeSUser ];

/// Foreign Key FKBDPackUnfreezeSUser created via DDL
ForeignKey FKBDPackBackUser(GetBackUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_BackUser ];

/// Foreign Key FKBDPackWorkGroup created via DDL
ForeignKey FKBDPackWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_Pack_WorkGroup ];

/// Foreign Key FKBDPackUnfreezeSUser created via DDL
ForeignKey FKBGCheckUser(BGCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BG_CheckUser ];

/// Foreign Key FKBDPackPosition created via DDL
ForeignKey FKBDPackPosition(PackPositionDR) References dbo.BDPackPosition(PKBDPackPosition) [ SqlName = FK_BD_PackPosition ];

/// Foreign Key FKBDPackPosition created via DDL
ForeignKey FKBGCheckMachine(BGCheckMachineDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BG_CheckMachine ];

/// Foreign Key FKBDPackPosition created via DDL
ForeignKey FKBGBloodGroup(BGBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BG_BloodGroup ];

/// Foreign Key FKBDPackPosition created via DDL
ForeignKey FKBDTakeUser(TakeUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_TakeUser ];

ForeignKey FKBDSoutUser(ScoutCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_ScoutUser ];

ForeignKey FKBDCollectUser(CollectUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_CollectUser ];

ForeignKey FKBDFirVerifyUser(FirVerifyUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_FirVerifyUser ];

ForeignKey FKBDSecVerifyUser(SecVerifyUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_SecVerifyUser ];

ForeignKey FKBDReactionSignUser(ReactionSignUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_ReactionSignUser ];

ForeignKey FKBDDestroyOUser(DestroyOUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Pack_DestroyOUserDR ];

ForeignKey FKBDInfuseWay(InfuseWayDR) References dbo.BBInfuseWay(PKBBINFUSEWAY) [ SqlName = FK_BD_Pack_InfuseWay ];

ForeignKey FKBDPackLockReq(LockReqDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_Pack_LockReq ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血袋  
Property PackID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 血液产品  
Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 次编号  
Property SecondID As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

/// 血袋条码  
Property PackBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 6 ];

/// 血制品条码  
Property ProductBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

/// 献血员ID号  
Property DonorID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 分装级别  
Property SplitLevel As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 9 ];

/// 血型组  
Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 血量  
Property PackVolume As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 11 ];

/// 父血袋ID  
Property ParentPackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 血站  
Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 有效日期  
Property ExpiredDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 有效时间  
Property ExpiredTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 采集日期  
Property CollectionDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 采集时间  
Property CollectionTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 制备日期  
Property ProductionDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 制备时间  
Property ProductionTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 献血类型  
Property DonorType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 20 ];

/// 是否特殊化验  {1:true,0:false}
Property IsSpecialTest As %Library.Boolean [ SqlColumnNumber = 21 ];

/// 锁定  {1:true,0:false}
Property IsLocked As %Library.Boolean [ SqlColumnNumber = 22 ];

/// 是否自体血  {1:true,0:false}
Property IsAutologous As %Library.Boolean [ SqlColumnNumber = 23 ];

/// 自体血登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 24 ];

/// 是否预定使用  {1:true,0:false}
Property IsReserved As %Library.Boolean [ SqlColumnNumber = 25 ];

/// 预定使用人登记号  
Property ReserveRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 26 ];

/// 预定使用人姓名  
Property ReserveName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 27 ];

/// 接收日期  
Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

/// 接收时间  
Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

/// 接收用户  
Property ReceiveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

/// 审核日期  
Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

/// 审核时间  
Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

/// 审核用户  
Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 33 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 34 ];

/// 血袋状态  
Property PackStatusDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 35 ];

/// 血袋库存状态  
Property StatusStock As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ Required, SqlColumnNumber = 36 ];

/// 使用的申请单  
Property ReqDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 37 ];

/// 使用的登记号  
Property PatientRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 38 ];

/// 使用病人科室  
Property PatientLocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 39 ];

/// 使用病人病区  
Property PatientWardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 40 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 41 ];

/// 输注结束状态  
Property InfusionStatus As %Library.SmallInt [ SqlColumnNumber = 42 ];

/// 异常结束原因  
Property AbnormalReason As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 43 ];

/// 剩余血量  
Property RemainVolumn As %Library.Float [ SqlColumnNumber = 44 ];

/// 入库日期  
Property StockInDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 45 ];

/// 入库时间  
Property StockInTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 46 ];

/// 入库用户  
Property StockInUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 47 ];

/// 血液形态  
Property BloodForm As %Library.SmallInt [ SqlColumnNumber = 48 ];

/// 解冻开始日期  
Property UnfreezeSDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 49 ];

/// 解冻开始时间  
Property UnfreezeSTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 50 ];

/// 解冻开始用户  
Property UnfreezeSUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 51 ];

/// 解冻结束日期  
Property UnfreezeEDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 52 ];

/// 解冻结束时间  
Property UnfreezeETime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 53 ];

/// 解冻结束用户  
Property UnfreezeEUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 54 ];

/// 出库日期  
Property StockOutDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 55 ];

/// 出库时间  
Property StockOutTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 56 ];

/// 出库用户  
Property StockOutUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 57 ];

/// 临床接收日期  
Property ArriveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 58 ];

/// 临床接收时间  
Property ArriveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 59 ];

/// 临床接收用户  
Property ArriveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 60 ];

/// 临床接收科室  
Property ArriveLocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 61 ];

/// 临床接收病区  
Property ArriveWardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 62 ];

/// 输注开始日期  
Property InfusionStartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 63 ];

/// 输注开始时间  
Property InfusionStartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 64 ];

/// 输注审核第一用户  
Property FirstCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 65 ];

/// 输注审核第二用户  
Property SecondCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 66 ];

/// 输注完成日期  
Property InfusionEndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 67 ];

/// 输注完成时间  
Property InfusionEndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 68 ];

/// 输注完成记录用户  
Property InfusionEndUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 69 ];

/// 回收日期  
Property CallbackDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 70 ];

/// 回收时间  
Property CallbackTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 71 ];

/// 回收用户  
Property CallbackUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 72 ];

/// InPrice  
Property InPrice As %Library.Float [ SqlColumnNumber = 73 ];

/// PositionNo  
Property PositionNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 74 ];

/// PackPositionDR  
Property PackPositionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 75 ];

/// GetBackDate  
Property GetBackDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 76 ];

/// GetBackTime  
Property GetBackTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 77 ];

/// GetBackUserDR  
Property GetBackUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 78 ];

/// IsBGChecked  {1:true,0:false}
Property IsBGChecked As %Library.Boolean [ SqlColumnNumber = 79 ];

/// BGCheckDate  
Property BGCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 80 ];

/// BGCheckTime  
Property BGCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 81 ];

/// BGCheckUserDR  
Property BGCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 82 ];

///       
Property ExtraFee As %Library.Float [ SqlColumnNumber = 83 ];

///       
Property Phenotype As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 84 ];

///       
Property BGCheckMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 85 ];

/// BGCheckSpecimenNo  
Property BGCheckSpecimenNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 86 ];

///       
Property BGBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 87 ];

/// IsBind  
Property IsBind As %Library.SmallInt [ SqlColumnNumber = 88 ];

/// IsUpload  
Property IsUpload As %Library.SmallInt [ SqlColumnNumber = 89 ];

/// RFIDCode  
Property RFIDCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 90 ];

/// FreezerId  
Property FreezerId As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 91 ];

/// FreezerLoc  
Property FreezerLoc As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 92 ];

///       
Property CollectReaction As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 93 ];

///       
Property TakeDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 94 ];

///       
Property TakeTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 95 ];

///       
Property TakeUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 96 ];

///       
Property ScoutCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 97 ];

///       
Property ScoutCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 98 ];

///       
Property ScoutCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 99 ];

/// CallBackDirection  
Property CallBackDirection As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 100 ];

/// SoakDate  
Property SoakDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 101 ];

/// SoakTime  
Property SoakTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 102 ];

/// SoakUserDR  
Property SoakUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 103 ];

/// DestroyDate  
Property DestroyDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 104 ];

/// DestroyTime  
Property DestroyTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 105 ];

/// DestroyUser  
Property DestroyUser As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 106 ];

/// InfusionType  
Property InfusionType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 107 ];

/// CollectUserDR  
Property CollectUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 108 ];

/// TransOrderID  
Property TransOrderID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 109 ];

/// TransOrderUserDR  
Property TransOrderUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 110 ];

/// TransPlanDate  
Property TransPlanDate As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 111 ];

/// TransPlanTime  
Property TransPlanTime As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 112 ];

/// 血液原始血站
Property SupplierNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 113 ];

/// 输血医嘱滴速备注
Property DripSpeed As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 114 ];

/// 输血医嘱备注
Property InfusOrderRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 115 ];

/// 输血前核对日期
Property VerifyDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 116 ];

/// 输血前核对时间
Property VerifyTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 117 ];

/// 输血前第一核对人
Property FirVerifyUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 118 ];

/// 输血前第二核对人
Property SecVerifyUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 119 ];

/// 抗体筛查 0:阴性，1:阳性
Property ABScreen As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 120 ];

/// 存储位置号
Property PackPosition As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 121 ];

/// 产品号
Property PackNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 122 ];

/// 是否出现不良反应标记日期
Property ReactionSignDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 123 ];

/// 是否出现不良反标记时间
Property ReactionSignTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 124 ];

/// 是否出现不良反应标记人
Property ReactionSignUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 125 ];

/// 销毁移交用户
Property DestroyOUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 126 ];

/// 输注途径
Property InfuseWayDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 127 ];

/// 输注记录设备
Property EntryDevice As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 128 ];

/// 在电脑记录的原因
Property EntryCause As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 129 ];

/// 锁定申请单  
Property LockReqDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 130 ];

/// 加工方式  格式：辐照,去白，洗涤
Property Ways As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 131 ];

Storage Default
{
<Data name="BDPackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackID</Value>
</Value>
<Value name="3">
<Value>BloodProductDR</Value>
</Value>
<Value name="4">
<Value>SecondID</Value>
</Value>
<Value name="5">
<Value>PackBarcode</Value>
</Value>
<Value name="6">
<Value>ProductBarcode</Value>
</Value>
<Value name="7">
<Value>DonorID</Value>
</Value>
<Value name="8">
<Value>SplitLevel</Value>
</Value>
<Value name="9">
<Value>BloodGroupDR</Value>
</Value>
<Value name="10">
<Value>PackVolume</Value>
</Value>
<Value name="11">
<Value>ParentPackDR</Value>
</Value>
<Value name="12">
<Value>SupplierDR</Value>
</Value>
<Value name="13">
<Value>ExpiredDate</Value>
</Value>
<Value name="14">
<Value>ExpiredTime</Value>
</Value>
<Value name="15">
<Value>CollectionDate</Value>
</Value>
<Value name="16">
<Value>CollectionTime</Value>
</Value>
<Value name="17">
<Value>ProductionDate</Value>
</Value>
<Value name="18">
<Value>ProductionTime</Value>
</Value>
<Value name="19">
<Value>DonorType</Value>
</Value>
<Value name="20">
<Value>IsSpecialTest</Value>
</Value>
<Value name="21">
<Value>IsLocked</Value>
</Value>
<Value name="22">
<Value>IsAutologous</Value>
</Value>
<Value name="23">
<Value>RegNo</Value>
</Value>
<Value name="24">
<Value>IsReserved</Value>
</Value>
<Value name="25">
<Value>ReserveRegNo</Value>
</Value>
<Value name="26">
<Value>ReserveName</Value>
</Value>
<Value name="27">
<Value>ReceiveDate</Value>
</Value>
<Value name="28">
<Value>ReceiveTime</Value>
</Value>
<Value name="29">
<Value>ReceiveUserDR</Value>
</Value>
<Value name="30">
<Value>CheckDate</Value>
</Value>
<Value name="31">
<Value>CheckTime</Value>
</Value>
<Value name="32">
<Value>CheckUserDR</Value>
</Value>
<Value name="33">
<Value>Remark</Value>
</Value>
<Value name="34">
<Value>PackStatusDR</Value>
</Value>
<Value name="35">
<Value>StatusStock</Value>
</Value>
<Value name="36">
<Value>ReqDR</Value>
</Value>
<Value name="37">
<Value>PatientRegNo</Value>
</Value>
<Value name="38">
<Value>PatientLocationDR</Value>
</Value>
<Value name="39">
<Value>PatientWardDR</Value>
</Value>
<Value name="40">
<Value>WorkGroupDR</Value>
</Value>
<Value name="41">
<Value>InfusionStatus</Value>
</Value>
<Value name="42">
<Value>AbnormalReason</Value>
</Value>
<Value name="43">
<Value>RemainVolumn</Value>
</Value>
<Value name="44">
<Value>StockInDate</Value>
</Value>
<Value name="45">
<Value>StockInTime</Value>
</Value>
<Value name="46">
<Value>StockInUserDR</Value>
</Value>
<Value name="47">
<Value>BloodForm</Value>
</Value>
<Value name="48">
<Value>UnfreezeSDate</Value>
</Value>
<Value name="49">
<Value>UnfreezeSTime</Value>
</Value>
<Value name="50">
<Value>UnfreezeSUserDR</Value>
</Value>
<Value name="51">
<Value>UnfreezeEDate</Value>
</Value>
<Value name="52">
<Value>UnfreezeETime</Value>
</Value>
<Value name="53">
<Value>UnfreezeEUserDR</Value>
</Value>
<Value name="54">
<Value>StockOutDate</Value>
</Value>
<Value name="55">
<Value>StockOutTime</Value>
</Value>
<Value name="56">
<Value>StockOutUserDR</Value>
</Value>
<Value name="57">
<Value>ArriveDate</Value>
</Value>
<Value name="58">
<Value>ArriveTime</Value>
</Value>
<Value name="59">
<Value>ArriveUserDR</Value>
</Value>
<Value name="60">
<Value>ArriveLocationDR</Value>
</Value>
<Value name="61">
<Value>ArriveWardDR</Value>
</Value>
<Value name="62">
<Value>InfusionStartDate</Value>
</Value>
<Value name="63">
<Value>InfusionStartTime</Value>
</Value>
<Value name="64">
<Value>FirstCheckUserDR</Value>
</Value>
<Value name="65">
<Value>SecondCheckUserDR</Value>
</Value>
<Value name="66">
<Value>InfusionEndDate</Value>
</Value>
<Value name="67">
<Value>InfusionEndTime</Value>
</Value>
<Value name="68">
<Value>InfusionEndUserDR</Value>
</Value>
<Value name="69">
<Value>CallbackDate</Value>
</Value>
<Value name="70">
<Value>CallbackTime</Value>
</Value>
<Value name="71">
<Value>CallbackUserDR</Value>
</Value>
<Value name="72">
<Value>InPrice</Value>
</Value>
<Value name="73">
<Value>PositionNo</Value>
</Value>
<Value name="74">
<Value>PackPositionDR</Value>
</Value>
<Value name="75">
<Value>GetBackDate</Value>
</Value>
<Value name="76">
<Value>GetBackTime</Value>
</Value>
<Value name="77">
<Value>GetBackUserDR</Value>
</Value>
<Value name="78">
<Value>IsBGChecked</Value>
</Value>
<Value name="79">
<Value>BGCheckDate</Value>
</Value>
<Value name="80">
<Value>BGCheckTime</Value>
</Value>
<Value name="81">
<Value>BGCheckUserDR</Value>
</Value>
<Value name="82">
<Value>ExtraFee</Value>
</Value>
<Value name="83">
<Value>Phenotype</Value>
</Value>
<Value name="84">
<Value>BGCheckMachineDR</Value>
</Value>
<Value name="85">
<Value>BGCheckSpecimenNo</Value>
</Value>
<Value name="86">
<Value>BGBloodGroupDR</Value>
</Value>
<Value name="87">
<Value>IsBind</Value>
</Value>
<Value name="88">
<Value>IsUpload</Value>
</Value>
<Value name="89">
<Value>RFIDCode</Value>
</Value>
<Value name="90">
<Value>FreezerId</Value>
</Value>
<Value name="91">
<Value>FreezerLoc</Value>
</Value>
<Value name="92">
<Value>CollectReaction</Value>
</Value>
<Value name="93">
<Value>TakeDate</Value>
</Value>
<Value name="94">
<Value>TakeTime</Value>
</Value>
<Value name="95">
<Value>TakeUserDR</Value>
</Value>
<Value name="96">
<Value>ScoutCheckDate</Value>
</Value>
<Value name="97">
<Value>ScoutCheckTime</Value>
</Value>
<Value name="98">
<Value>ScoutCheckUserDR</Value>
</Value>
<Value name="99">
<Value>CallBackDirection</Value>
</Value>
<Value name="100">
<Value>SoakDate</Value>
</Value>
<Value name="101">
<Value>SoakTime</Value>
</Value>
<Value name="102">
<Value>SoakUserDR</Value>
</Value>
<Value name="103">
<Value>DestroyDate</Value>
</Value>
<Value name="104">
<Value>DestroyTime</Value>
</Value>
<Value name="105">
<Value>DestroyUser</Value>
</Value>
<Value name="106">
<Value>InfusionType</Value>
</Value>
<Value name="107">
<Value>CollectUserDR</Value>
</Value>
<Value name="108">
<Value>TransOrderID</Value>
</Value>
<Value name="109">
<Value>TransOrderUserDR</Value>
</Value>
<Value name="110">
<Value>TransPlanDate</Value>
</Value>
<Value name="111">
<Value>TransPlanTime</Value>
</Value>
<Value name="112">
<Value>SupplierNo</Value>
</Value>
<Value name="113">
<Value>DripSpeed</Value>
</Value>
<Value name="114">
<Value>InfusOrderRemark</Value>
</Value>
<Value name="115">
<Value>VerifyDate</Value>
</Value>
<Value name="116">
<Value>VerifyTime</Value>
</Value>
<Value name="117">
<Value>FirVerifyUserDR</Value>
</Value>
<Value name="118">
<Value>SecVerifyUserDR</Value>
</Value>
<Value name="119">
<Value>ABScreen</Value>
</Value>
<Value name="120">
<Value>PackPosition</Value>
</Value>
<Value name="121">
<Value>PackNo</Value>
</Value>
<Value name="122">
<Value>ReactionSignDate</Value>
</Value>
<Value name="123">
<Value>ReactionSignTime</Value>
</Value>
<Value name="124">
<Value>ReactionSignUserDR</Value>
</Value>
<Value name="125">
<Value>DestroyOUserDR</Value>
</Value>
<Value name="126">
<Value>InfuseWayDR</Value>
</Value>
<Value name="127">
<Value>EntryDevice</Value>
</Value>
<Value name="128">
<Value>EntryCause</Value>
</Value>
<Value name="129">
<Value>LockReqDR</Value>
</Value>
<Value name="130">
<Value>Ways</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackD</DataLocation>
<DefaultData>BDPackDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDPackD</IdLocation>
<IndexLocation>^dbo.BDPackI</IndexLocation>
<StreamLocation>^dbo.BDPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

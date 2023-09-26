Class web.DHCEQ.Process.DHCEQPicture Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// GetPicture
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQPicture","GetPicture",52,14662,"^^^^^1,2,4^^^^^^^^")
Query GetPicture(CurrentSourceType As %String, CurrentSourceID As %String, vData As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TPath:%String,TRemark:%String,TPicTypeDR:%String,TPicTypeDesc:%String,TPicNo:%String,TPicLocation:%String,TPicNum:%String,TPicName:%String,TSourceType:%String,TSourceTypeDesc:%String")
{
}

ClassMethod GetPictureExecute(ByRef qHandle As %Binary, CurrentSourceType As %String, CurrentSourceID As %String, vData As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
	s PicNo=$p($G(vData),"^",3)
	s PicTypeDR=$p($G(vData),"^",6)
	i PicTypeDR="" Quit $$$OK
	s PicName=$p($G(vData),"^",14)
	//S SourceType=$p($G(vData),"^",9)
	//s:SourceType="" SourceType=CurrentSourceType
	//s SourceID=##Class(web.DHCEQ.Process.DHCEQPicture).GetSourceID(CurrentSourceType,CurrentSourceID,SourceType)
	d BuildDataGetPictureList
	
	Quit $$$OK	
BuildDataGetPictureList
	//i (SourceType'="")&&(SourceID'="")  d
	s SourceType="" 
	for  s SourceType=$o(^DHCEQPicture(0,"Source",SourceType)) q:SourceType=""  d
	.q:##Class(web.DHCEQ.Process.DHCEQPicture).SourceTypeAccessable(CurrentSourceType,SourceType)=0
	.s SourceIDs=##Class(web.DHCEQ.Process.DHCEQPicture).GetSourceIDs(CurrentSourceType,CurrentSourceID,SourceType) 
	.q:SourceIDs=""  
	.Set len=$L(SourceIDs,",") //SourceIDs形式为 "SourceID1,SourceID2,SourceID3"
	.for i=1:1:len d
	..s SourceID=$PIECE(SourceIDs,",",i)
	..s NewRowid=0
	..f  s NewRowid=$o(^DHCEQPicture(0,"Source",SourceType,SourceID,NewRowid)) q:NewRowid=""  d
	...d ResetVariablesGetPictureList
	...s TRowID=NewRowid
	...s TPicNo=$p($g(^DHCEQPicture(TRowID)),"^",2)
	...q:(PicNo'="")&&(TPicNo'[PicNo)
	...s TPicTypeDR=$p($g(^DHCEQPicture(TRowID)),"^",5)
	...q:(PicTypeDR'="")&&(PicTypeDR'=TPicTypeDR)&&((","_PicTypeDR_",")'[(","_TPicTypeDR_","))
	...s TPicName=$p($g(^DHCEQPicture(TRowID)),"^",13)
	...q:(PicName'="")&&(TPicName'[PicName)
	...s TInvalidFlag=$p($g(^DHCEQPicture(TRowID)),"^",7)
	...q:(2=TInvalidFlag)
	...d GetListInfo
	...d OutputRowGetPictureList
	quit
GetListInfo
	s TEquipDR=$p($g(^DHCEQPicture(TRowID)),"^",1)
	s TPath=$p($g(^DHCEQPicture(TRowID)),"^",4)
	s TRemark=$p($g(^DHCEQPicture(TRowID)),"^",3)
	s:TPicTypeDR'="" TPicTypeDesc=$p($G(^DHCEQCCode("DHCEQCPicType",TPicTypeDR)),"^",2)
	s TPicLocation=$p($g(^DHCEQPicture(TRowID)),"^",18)
	s TSourceType=SourceType   //modified by czf 增加63-1：供应商资质 419044
	;modify by lmm 2019-10-12
    //modified by ZY 20220926  2826780
    s TSourceTypeDesc=##Class(web.DHCEQ.Plat.CTBussType).GetBussTypeForPicture(TSourceType)
    d GetPicNum
    quit
GetPicNum
	s TPicNum(TRowID)=0
	s TPLRowID=""
	for  s TPLRowID=$o(^DHCEQPictureList(0,"Picture",TRowID,TPLRowID)) q:(TPLRowID="")  d
	.q:("Y"=$p(^DHCEQPictureList(TPLRowID),"^",12))
	.s TPicNum(TRowID)=TPicNum(TRowID)+1
	quit
OutputRowGetPictureList
	s Data=$lb(TRowID,TEquipDR,TPath,TRemark,TPicTypeDR,TPicTypeDesc,TPicNo,TPicLocation,$G(TPicNum(TRowID)),TPicName,TSourceType,TSourceTypeDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPictureList
	s (TRowID,TEquipDR,TPath,TRemark,TPicTypeDR,TPicTypeDesc,TPicNo,TPicLocation,TPicName,TSourceType,TSourceTypeDesc)=""
	quit
}

ClassMethod GetPictureClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPictureExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPictureFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPictureExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 移动端使用的图片表存储函数
ClassMethod SaveData(PTData = "", PLData = "")
{
	Set PTRowID=$p($G(PTData),"^",1)
 	Set PTEquipDR=$p($G(PTData),"^",2)
 	Set PTPictureNo=$p($G(PTData),"^",3)
 	Set PTRemark=$p($G(PTData),"^",4)
 	Set PTPath=$p($G(PTData),"^",5)	
 	Set PTPicTypeDR=$p($G(PTData),"^",6)
 	Set PTSourceType=$p($G(PTData),"^",9)
 	Set PTSourceID=$p($G(PTData),"^",10)
 	Set PTPicName=$p($G(PTData),"^",14)
 	Set PTLocation=$p($G(PTData),"^",19)
 	
 	Set PLRowID=$p($G(PLData),"^",1)
 	Set PLSuffix=$p($G(PLData),"^",3)
 	Set PLPicSort=$p($G(PLData),"^",5)
 	Set PLDefaultFlag=$p($G(PLData),"^",4)
 	Set:PLDefaultFlag="" PLDefaultFlag="N"
	s User=$p($G(PLData),"^",6)    ;##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")) QW20160108用户id需要到Android客户端取值
	s Date=+$H
	s Time=$P($H,",",2)
	//Add by QW20160106只有当来源类型和图片类型匹配才能保存图片
	s PSTDR=$O(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex",PTSourceType,PTPicTypeDR,0))  
	i (PSTDR="")
	{
		q -1011  ;-1011 权限不匹配
	}
	i ($p($g(^DHCEQCCode("DHCEQCPicSourceType",PSTDR)),"^",9)="Y")
	{
		q -1011
	}
	//End by QW20160106
	//Modify by QW20160106 移动新增或者更新图片信息时 PL_UpLoadFlag置为N，当图片上传完成才修改。
	if (PTRowID="")
 	{ 
 		TSTART
 		&SQL(Insert into SQLUSER.DHC_EQPicture(PT_EquipDR,PT_PictureNo,PT_Remark,PT_Path,PT_PicTypeDR,PT_SourceType,PT_SourceID,PT_PicName,PT_UpdateDate,PT_UpdateTime,PT_UpdateUser,PT_Location,PT_InvalidFlag)
 			values (:PTEquipDR,:PTPictureNo,:PTRemark,:PTPath,:PTPicTypeDR,:PTSourceType,:PTSourceID,:PTPicName,:Date,:Time,:User,:PTLocation,0)) 
 		s PTRowID=$g(%ROWID)
 		if SQLCODE
		{
	   		TROLLBACK
	   		q SQLCODE
	 	}
	 	//&SQL(insert into SQLUSER.DHC_EQPictureList (PL_PictureDR,PL_Remark,PL_UpdateUserDR,PL_UpdateDate,PL_UpdateTime) values(:rowid,:remark,:Date,:Time,:User))
	 	&SQL(insert into SQLUSER.DHC_EQPictureList (PL_PictureDR,PL_Suffix,PL_PicSort,PL_UploadUserDR,PL_UploadDate,PL_UploadTime,PL_InvalidFlag,PL_DefaultFlag,PL_UpLoadFlag) values(:PTRowID,:PLSuffix,:PLPicSort,:User,:Date,:Time,'N',:PLDefaultFlag,'N'))
	 	s rowid=$g(%ROWID)
	 	if SQLCODE
		{
	   		TROLLBACK
	   		q SQLCODE
	 	}
 	}
 	else{
	 	TSTART
	 	if ((PTSourceType'="")&&(PTSourceID'="")) //可编辑表格，防止无意义的主表更新
	 	{
 			&SQL(Update SQLUSER.DHC_EQPicture set PT_PictureNo=:PTPictureNo,PT_Remark=:PTRemark,PT_Path=:PTPath,PT_PicTypeDR=:PTPicTypeDR,PT_PicName=:PTPicName,PT_UpdateDate=:Date,PT_UpdateTime=:Time,PT_UpdateUser=:User,PT_Location=:PTLocation,PT_InvalidFlag=1 where PT_RowID = :PTRowID)
 			s PTRowID=$g(%ROWID)
 			if SQLCODE
			{
	   			TROLLBACK
	   			q SQLCODE
	 		}
	 	}
	 	if PLRowID=""
	 	{
		 	&SQL(insert into SQLUSER.DHC_EQPictureList (PL_PictureDR,PL_Suffix,PL_PicSort,PL_UploadUserDR,PL_UploadDate,PL_UploadTime,PL_InvalidFlag,PL_DefaultFlag,PL_UpLoadFlag) values(:PTRowID,:PLSuffix,:PLPicSort,:User,:Date,:Time,'N',:PLDefaultFlag,'N'))
	 		s rowid=$g(%ROWID)
	 		if SQLCODE
			{
	   			TROLLBACK
	   			q SQLCODE
	 		}
	 	}
	 	else
	 	{
	 		//&SQL(Update SQLUSER.DHC_EQPictureList set PL_Remark=:remark,PL_UpdateDate=:Date,PL_UpdateTime=:Time,PL_UpdateUserDR=:User where PL_PictureDR = :rowid)
	 		&SQL(Update SQLUSER.DHC_EQPictureList set PL_Suffix=:PLSuffix,PL_PicSort=:PLPicSort,PL_UploadUserDR=:User,PL_UploadDate=:Date,PL_UploadTime=:Time,PL_DefaultFlag=:PLDefaultFlag,PL_UpLoadFlag='N' where PL_RowID = :PLRowID)
	 		s rowid=$g(%ROWID)
	 		if SQLCODE
			{
	   			TROLLBACK
	   			q SQLCODE
	 		}
	 	}
	 	
	}
	if PLDefaultFlag="Y"
	{
		
		&SQL(Update SQLUSER.DHC_EQPictureList set PL_DefaultFlag='N' where PL_RowID != :PLRowID and PL_PictureDR=:PTRowID )
		if SQLCODE&&(SQLCODE'=100)
		{
	  	 	TROLLBACK
	   		q SQLCODE
		}
	}
	TCOMMIT
 	if SQLCODE&&(SQLCODE'=100)  q SQLCODE
 	q PTRowID_"^"_rowid  ;QW-20160125
}

/// extjs写的图片上传会调用这个方法
ClassMethod SavePicture(PTData As %String = "", User As %String = "")
{
	Set PTRowID=$p($G(PTData),"^",1)
 	Set PTEquipDR=$p($G(PTData),"^",2)
 	Set PTPictureNo=$p($G(PTData),"^",3)
 	Set PTRemark=$p($G(PTData),"^",4)
 	//Modify by zx 2021-06-03 移动端需要,路径获取方式调整
 	;Set PTPath=$p($G(PTData),"^",5)	
 	Set PTPath=##class(web.DHCEQCommon).GetSysInfo("990004")
 	Set PTPicTypeDR=$p($G(PTData),"^",6)
 	Set PTSourceType=$p($G(PTData),"^",9)
 	Set PTSourceID=$p($G(PTData),"^",10)
 	Set PTPicName=$p($G(PTData),"^",14)
 	Set PTLocation=$p($G(PTData),"^",19)
 	
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	if PTRowID=""
	{
 		&SQL(Insert into SQLUSER.DHC_EQPicture(PT_EquipDR,PT_PictureNo,PT_Remark,PT_Path,PT_PicTypeDR,PT_SourceType,PT_SourceID,PT_PicName,PT_UpdateDate,PT_UpdateTime,PT_UpdateUser,PT_Location,PT_InvalidFlag)
 			values (:PTEquipDR,:PTPictureNo,:PTRemark,:PTPath,:PTPicTypeDR,:PTSourceType,:PTSourceID,:PTPicName,:Date,:Time,:User,:PTLocation,0)) 
 		s rowid=$g(%ROWID)
 		if SQLCODE
		{
	   		q -6
	 	}
	}
	else
	{ 	
	 	if ((PTSourceType'="")&&(PTSourceID'="")) //可编辑表格，防止无意义的主表更新
	 	{
 			&SQL(Update SQLUSER.DHC_EQPicture set PT_PictureNo=:PTPictureNo,PT_Remark=:PTRemark,PT_Path=:PTPath,PT_PicTypeDR=:PTPicTypeDR,PT_PicName=:PTPicName,PT_UpdateDate=:Date,PT_UpdateTime=:Time,PT_UpdateUser=:User,PT_Location=:PTLocation,PT_InvalidFlag=1 where PT_RowID = :PTRowID)
 			//http访问,第一次执行sql语句时,当除了Rowid字段为空时将不会执行sql语句，%ROWID为空，SQLCODE对象为0
 			//控制台模式似乎不存在这种优化??非第一次执行??
 			//s rowid=$g(%ROWID)
 			if SQLCODE
			{
	   			q -9
	 		}
	 	}
	}
 	q:rowid'="" rowid
 	q PTRowID
}

ClassMethod DeletePicture(RowID)
{
	//Add By DJ  2017-11-21删除主表前先处理主表对应所有明细记录
	TSTART
	&SQL(Update SQLUSER.DHC_EQPictureList set PL_InvalidFlag='Y' where PL_PictureDR = :RowID)
	i SQLCODE
	{
		TROLLBACK
		q -1
	}
	&SQL(Update SQLUSER.DHC_EQPicture set PT_InvalidFlag=2 where PT_RowID = :RowID)
	if SQLCODE
	{
		TROLLBACK
	   	q -1
 	}
 	TCOMMIT
 	q 1
}

/// 通过图片主表rowid获取url值
ClassMethod GetFtpStreamSrcByPTRowID(PTRowID)
{
	s PLRowID=""
	&SQL(select PL_RowID  into:PLRowID from SQLUser.DHC_EQPictureList where PL_PictureDR=:PTRowID and PL_DefaultFlag='Y' and PL_InvalidFlag='N')
	if (PLRowID="") d
	.&SQL(select PL_RowID  into:PLRowID from SQLUser.DHC_EQPictureList where PL_PictureDR=:PTRowID and PL_InvalidFlag='N' order by PL_PicSort Asc)
	q ##Class(web.DHCEQ.Process.DHCEQPicture).GetFtpStreamSrcByPLRowID(PLRowID)
}

/// 通过明细表rowid获取url值
ClassMethod GetFtpStreamSrcByPLRowID(PLRowID)
{
	i PLRowID="" q 0
	i $G(^DHCEQTemp("Cache","ID"))="" s ^DHCEQTemp("Cache","ID")=0	//页面刷新后向不同图片路径请求，防止客户端缓存当前图片
	q "web.DHCEQ.Lib.DHCEQStreamServer.cls?PICLISTROWID="_(##Class(websys.Page).Encrypt(PLRowID))_"&CacheID="_$I(^DHCEQTemp("Cache","ID"))
}

/// add by zy 20180814  ZY0171
/// 产品库功能代码
/// 重要，配置当前业务流程可以查看到的业务流程图片数据
/// 这个方法需要根据具体医院情况维护,替代原web.DHCEQ.Process.DHCEQCPicSourceType中Configure方法
ClassMethod SourceTypeAccessable(CurrentSourceType, SourceType)
{
	New result,DHCEQSourceTypeAccess
	///调整为0：无 11:开箱验收 12:安装调试验收 21:入库 22:转移 23:减少 31:维修 32保养 33检查 34报废 35折旧 41使用记录 
	/// 51设备调帐 52设备 53设备盘点 54设备盘盈 61工程管理 62科研课题 63证件 91采购申请 92采购计划 93采购招标 94采购合同 95保修合同
	//如果从台帐界面进，想要看到保养相关图片 就s DHCEQSourceTypeAccess(52,32)=1
	s DHCEQSourceTypeAccess(54,54)=1	// MZY0089	2021-08-17
	s DHCEQSourceTypeAccess(53,53)=1
	s DHCEQSourceTypeAccess(52,52)=1
	s DHCEQSourceTypeAccess(52,32)=1
	s DHCEQSourceTypeAccess(52,31)=1
	s DHCEQSourceTypeAccess(52,95)=1
	s DHCEQSourceTypeAccess(52,94)=1
	s DHCEQSourceTypeAccess(52,11)=1
	s DHCEQSourceTypeAccess(52,21)=1	//czf 2022-04-24
	s DHCEQSourceTypeAccess(52,22)=1	//czf 2022-04-24
	s DHCEQSourceTypeAccess(32,32)=1
	s DHCEQSourceTypeAccess(33,33)=1
	s DHCEQSourceTypeAccess(31,31)=1
	s DHCEQSourceTypeAccess(63,63)=1
	s DHCEQSourceTypeAccess(67,67)=1   //modify by lmm 2019-10-12
    s DHCEQSourceTypeAccess("91-1","91-1")=1
	s DHCEQSourceTypeAccess(94,94)=1
	s DHCEQSourceTypeAccess(95,95)=1
	s DHCEQSourceTypeAccess(11,11)=1
	s DHCEQSourceTypeAccess("63-1","63-1")=1   //add by czf 2017-08-01 419044
	s DHCEQSourceTypeAccess("63-2","63-2")=1   //add by czf 20181229 792330
	s DHCEQSourceTypeAccess(96,96)=1
	s DHCEQSourceTypeAccess(21,21)=1	//add by csj 2020-11-19 需求号：1612422
	s DHCEQSourceTypeAccess("34-1","34-1")=1	//add by csj 2020-11-19 需求号：1612424
	s DHCEQSourceTypeAccess(22,22)=1  //Add By QW20210422 BUG:QW0099
	s DHCEQSourceTypeAccess(76,76)=1  //Add By QW20210422 BUG:QW0099
	s DHCEQSourceTypeAccess(34,34)=1  //Add by zc0102  2021-5-27 报废业务条件
	s DHCEQSourceTypeAccess(51,51)=1  //Add By QW20210629 BUG:QW0129
    s DHCEQSourceTypeAccess("63-4","63-4")=1 	//modified by ZY 20220926  2826780
    s DHCEQSourceTypeAccess("v11","v11")=1  //add by lmm 2021-06-08 模型图片
    s DHCEQSourceTypeAccess(52,33)=1		///Modefied by zc0125 2022-11-09 增加设备查看检查图片
    s DHCEQSourceTypeAccess(54,53)=1  ///Modefied by zc0127 2023-01-09 同一台设备盘盈时看盘点的图片
	s DHCEQSourceTypeAccess(54,52)=1  ///Modefied by zc0127 2023-01-09 同一台设备盘盈时看设备的图片
	// MZY0153	3218768		2023-02-20
	s DHCEQSourceTypeAccess(33,33)=1
	s DHCEQSourceTypeAccess(41,41)=1
	s DHCEQSourceTypeAccess(61,61)=1
	s DHCEQSourceTypeAccess(62,62)=1
	s DHCEQSourceTypeAccess(92,92)=1
	s DHCEQSourceTypeAccess(93,93)=1
	s result=$G(DHCEQSourceTypeAccess(CurrentSourceType,SourceType))
	k DHCEQSourceTypeAccess
	i result=1 q 1
	else  q 0
}

/// w ##Class(web.DHCEQ.Process.DHCEQPicture).GetSourceIDs(0,8,1) 查找设备rowid为8的设备对应的所有保养记录rowid
/// 注意w ##Class(web.DHCEQ.Process.DHCEQPicture).GetSourceIDs(1,10,1) 保养业务rowid为10数据，查找保养记录将只能返回本条保养记录的rowid（无法查到这台设备其他保养信息rowid）
ClassMethod GetSourceIDs(CurrentSourceType As %String, CurrentSourceID As %String, SourceType = "")
{
	i SourceType="" q CurrentSourceID
	;在自身业务类型中,只看到当前业务对应图片
	i SourceType=CurrentSourceType  q CurrentSourceID
	
	//有设备DR业务先获取设备DR，
	s EquipDR=$CASE(CurrentSourceType,52:CurrentSourceID,31:$p($G(^DHCEQMaintRequest(CurrentSourceID)),"^",1),32:$p($G(^DHCEQMaint(CurrentSourceID)),"^",1),33:$p($G(^DHCEQMaint(CurrentSourceID)),"^",1),54:$p($G(^DHCEQInventoryException(CurrentSourceID)),"^",24),:"")   ///Modefied by zc0127 2023-01-09 盘盈时的设备ID
	i EquipDR="" q ""
	
	New TSourceIDs,TempSourceID,Type
	//然后通过设备DR取相应业务rowid
	s TSourceIDs=""
	s TempSourceID=""
	i SourceType=52 s TSourceIDs=EquipDR
	;SourceType=1 保养 SourceType=2检查
	i (SourceType=32)||(SourceType=33) d
	.i SourceType=32 s Type=1
	.i SourceType=33 s Type=2
	.for  s TempSourceID=$o(^DHCEQMaint(0,"Equip",Type,EquipDR,TempSourceID)) q:TempSourceID=""  d
	..i TSourceIDs="" s TSourceIDs=TempSourceID 
	..e  s TSourceIDs=TSourceIDs_","_TempSourceID
	i SourceType=31 d
	.s ExObjDR=0
	.f  s ExObjDR=$o(^DHCEQMMaintRequest(0,"Source",1,ExObjDR)) q:ExObjDR=""  d
	..s EQRowID=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",5)
	..q:EQRowID=""
	..q:EQRowID'=EquipDR
	..f  s TempSourceID=$o(^DHCEQMMaintRequest(0,"Source",1,ExObjDR,TempSourceID)) q:TempSourceID=""  d
	...i TSourceIDs="" s TSourceIDs=TempSourceID
	...e  s TSourceIDs=TSourceIDs_","_TempSourceID
	.;for  s TempSourceID=$o(^DHCEQMaintRequest(0,"Equip",EquipDR,TempSourceID)) q:TempSourceID=""  d
	.;.i TSourceIDs="" s TSourceIDs=TempSourceID 
	.;.e  s TSourceIDs=TSourceIDs_","_TempSourceID
	i SourceType=95 d
	.for  s TempSourceID=$o(^DHCEQServiceContract(0,"Equip",EquipDR,TempSourceID)) q:TempSourceID=""  d
	..i TSourceIDs="" s TSourceIDs=TempSourceID 
	..s TSourceIDs=TSourceIDs_","_TempSourceID
	i SourceType=94 d
	.s TempSourceID=$p($g(^DHCEQEquip(EquipDR)),"^",32)
	.q:TempSourceID=""  //Modefied by zc0101 2021-5-13  修改台帐界面看不到合同及验收时录入的照片  begin
	.s ContractDR=$p($g(^DHCEQContractList(TempSourceID)),"^",1)
	.i TSourceIDs="" s TSourceIDs=ContractDR   //Modefied by zc0101 2021-5-13  修改台帐界面看不到合同及验收时录入的照片  end
	.;for  s TempSourceID=$o(^DHCEQContract(0,"Status",2,TempSourceID)) q:TempSourceID=""  d
	.;.i TSourceIDs="" s TSourceIDs=TempSourceID 
	.;.;s TSourceIDs=TSourceIDs_","_TempSourceID
	i SourceType=11 d
	.i $p($g(^DHCEQEquip(EquipDR,"OtherInfo")),"^",24)="" s TSourceIDs=$p(^DHCEQEquip(EquipDR),"^",77)	;Mozy	914928	2019-7-11	附属设备不取验收单图片
	i SourceType=21 d	//入库	czf 2022-04-24 begin
	.i EquipDR'="" d
	..s TInStockListDR=$p($g(^DHCEQEquip(EquipDR)),"^",70)
	..i TInStockListDR'="" s TSourceIDs=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	i SourceType=22 d	//转移
	.for  s TempSourceID=$o(^DHCEQStoreMoveList(TempSourceID)) q:TempSourceID=""  d
	..s SMRowID=$p($g(^DHCEQStoreMoveList(TempSourceID)),"^",1)
	..q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)="Y"
	..s EquipIDs=$g(^DHCEQStoreMoveList(TempSourceID,"EX","RowIDs"))
	..q:(EquipDR'="")&&((","_EquipIDs_",")'[(","_EquipDR_","))
	..i TSourceIDs'="" s TSourceIDs=TSourceIDs_","
	..s TSourceIDs=TSourceIDs_SMRowID	//czf 2022-04-24 end
	///Modefied by zc0127 2023-01-09 盘点明细取值 begin
	i SourceType=53 d
	.s ILInventoryDR=0
	.f  s ILInventoryDR=$o(^DHCEQInventoryList(0,"BillEquip",ILInventoryDR)) q:ILInventoryDR=""  d
	..f  s TempSourceID=$o(^DHCEQInventoryList(0,"BillEquip",ILInventoryDR,EquipDR,TempSourceID)) q:TempSourceID=""  d
	...i TSourceIDs="" s TSourceIDs=TempSourceID
	...e  s TSourceIDs=TSourceIDs_","_TempSourceID
	///Modefied by zc0127 2023-01-09 盘点明细取值 end
	q TSourceIDs
}

/// Modefiedy by 20181023 ZC0040 bug722264
/// Mozy	2016-11-3
/// d ##Class(web.DHCEQ.Process.DHCEQPicture).GetPictureByEquip(10)
ClassMethod GetPictureByEquip(EQRowID As %String = "", width As %String = "540", height As %String = "400")
{
	s PicListRowID=""
	i EQRowID'=""
	{
		; 取台账上传的默认图片
		s PicRowID=$o(^DHCEQPicture(0,"Source",52,EQRowID,""))
		if PicRowID'=""
		{
			i $p($G(^DHCEQPicture(PicRowID)),"^",7)=2 s PicRowID=""		;InvalidFlag
		}
		; 取验收上传的默认图片
		i PicRowID=""
		{
			s PicRowID=$o(^DHCEQPicture(0,"Source",11,EQRowID,""))
			if PicRowID'=""
			{
				i $p($G(^DHCEQPicture(PicRowID)),"^",7)=2 s PicRowID=""		;InvalidFlag
			}
		}
		
		i PicRowID'="" d
		.s tmpListRowID=0	;记录有效的图片明细ID
		.s Sort=""
		.for  s Sort=$o(^DHCEQPictureList(0,"PicSort",PicRowID,Sort),-1) q:(Sort="")||(PicListRowID'="")  d
		..s ListRowID=""
		..for  s ListRowID=$o(^DHCEQPictureList(0,"PicSort",PicRowID,Sort,ListRowID)) q:(ListRowID="")||(PicListRowID'="")  d
		...q:$p($G(^DHCEQPictureList(ListRowID)),"^",12)="Y"		;InvalidFlag
		...
		...s tmpListRowID=ListRowID
		...i $p($G(^DHCEQPictureList(ListRowID)),"^",4)="Y" s PicListRowID=ListRowID
		.i (PicListRowID="")&&(tmpListRowID>0) s PicListRowID=tmpListRowID
		.s PicListRowID=##Class(websys.Page).Encrypt(PicListRowID)
	}
	
	q "web.DHCEQ.Lib.DHCEQStreamServer.cls?PICLISTROWID="_PicListRowID
}

/// add by csj 20190808 根据图片类型及SourceID判断是否上传过对应图片
/// 入参：SourceType 业务图片类型，SourceID：业务ID，PicTypeCode:图片类型Code
/// w ##Class(web.DHCEQ.Process.DHCEQPicture).CheckIfUploadPicBySourceID("94",14","07")
ClassMethod CheckIfUploadPicBySourceID(SourceType As %String, SourceID As %String, PicTypeCode As %String)
{
	new (SourceType,SourceID,PicTypeCode)
	s PicId = ""
	s uploadFlag = 0
	f  s PicId=$o(^DHCEQPicture(0,"Source",SourceType,SourceID,PicId)) q:(PicId="")||(uploadFlag=1)  d
	.q:$P(^DHCEQPicture(PicId),"^",7)="2"
	.s CurPicTypeId = $P(^DHCEQPicture(PicId),"^",5)
	.s CurPicTypeCode = $P(^DHCEQCCode("DHCEQCPicType",CurPicTypeId),"^",1)
	.q:(PicTypeCode'="")&&(CurPicTypeCode'=PicTypeCode)
	.s uploadFlag = 1
	
	q uploadFlag
}

/// 移动端台账图片查询调用
/// Modify by zx 2021-06-03 改为按主表显示,点开后再显示明细
/// Modify by zx 2022-09-15 
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQPicture","GetPictureList","31","","","","248")
Query GetPictureList(CurrentSourceType As %String, CurrentSourceID As %String, PicTypeDR As %String = "", CurGroupID As %String = "", PicIDs As %String = "") As %Query(ROWSPEC = "TRowID:%String,TPicTypeDR:%String,TPicTypeDesc:%String,TPicNo:%String,TPicName:%String,TSourceType:%String,TSourceTypeDesc:%String,TMainPicListID:%String,TPicNum:%String,TUpdateUserID:%String")
{
}

ClassMethod GetPictureListExecute(ByRef qHandle As %Binary, CurrentSourceType As %String, CurrentSourceID As %String, PicTypeDR As %String = "", CurGroupID As %String = "", PicIDs As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
	i (PicTypeDR="")&&(CurrentSourceType="52") Quit $$$OK
	d BuildDataGetPictureListList
	
	Quit $$$OK
BuildDataGetPictureListList
	i PicIDs="" d
	.s SourceType="" 
	.for  s SourceType=$o(^DHCEQPicture(0,"Source",SourceType)) q:SourceType=""  d
	..q:##Class(web.DHCEQ.Process.DHCEQPicture).SourceTypeAccessable(CurrentSourceType,SourceType)=0
	..s SourceIDs=##Class(web.DHCEQ.Process.DHCEQPicture).GetSourceIDs(CurrentSourceType,CurrentSourceID,SourceType) 
	..q:SourceIDs=""  
	..Set len=$L(SourceIDs,",") //SourceIDs形式为 "SourceID1,SourceID2,SourceID3"
	..for i=1:1:len d
	...s SourceID=$PIECE(SourceIDs,",",i)
	...s PicRowID=0
	...f  s PicRowID=$o(^DHCEQPicture(0,"Source",SourceType,SourceID,PicRowID)) q:PicRowID=""  d
	....d GetPictureListListByID
	e  d
	.s SourceType=CurrentSourceType
	.s PicLength=$l(PicIDs,",")
	.f PicLen=1:1:PicLength d
	..s PicRowID=$p(PicIDs,",",PicLen)
	..d GetPictureListListByID
	
	quit

GetPictureListListByID
	d ResetVariablesGetPictureListList
	s TRowID=PicRowID
	s TPicNo=$p($g(^DHCEQPicture(TRowID)),"^",2)
	s TPicTypeDR=$p($g(^DHCEQPicture(TRowID)),"^",5)
	q:(PicTypeDR'="")&&(PicTypeDR'=TPicTypeDR)&&((","_PicTypeDR_",")'[(","_TPicTypeDR_","))
	q:##Class(web.DHCEQ.Lib.Common).PicTypeIsIn(TPicTypeDR,CurGroupID)=1 
	i TPicTypeDesc=$p($G(^DHCEQCCode("DHCEQCPicType",TPicTypeDR)),"^",2)
	i TPicTypeDR'="" s TPicName=$p($g(^DHCEQPicture(TRowID)),"^",13)
	s TUpdateUserID=$p($g(^DHCEQPicture(TRowID)),"^",12)  //Modify by zx 2021-06-04 移动端根据人员限定删除权限
	s TInvalidFlag=$p($g(^DHCEQPicture(TRowID)),"^",7)
	q:(2=TInvalidFlag)
	s TSourceType=SourceType
    s TSourceTypeDesc=##Class(web.DHCEQ.Plat.CTBussType).GetBussTypeForPicture(TSourceType)
	s TPicListRowID=0
	for  s TPicListRowID=$o(^DHCEQPictureList(0,"Picture",TRowID,TPicListRowID)) q:(TPicListRowID="")  d
	.//Modify by zx 2021-06-03
	.q:($p(^DHCEQPictureList(TPicListRowID),"^",12)="Y")
	.q:($p(^DHCEQPictureList(TPicListRowID),"^",13)'="Y")
	.s TPicNum=+TPicNum+1
	.//Modify by zx 2021-06-03 输出主图片当封面图
	.s TMainPicListID=TPicListRowID
	.s TMainFlag=$p($g(^DHCEQPictureList(TPicListRowID)),"^",4)
	.i TMainFlag="Y" s TMainPicListID=TPicListRowID
	q:+TPicNum=0 //Modify by zx 2021-06-03 数量位0时不显示
	d OutputRowGetPictureListList
	quit
OutputRowGetPictureListList
	s Data=$lb(TRowID,TPicTypeDR,TPicTypeDesc,TPicNo,TPicName,TSourceType,TSourceTypeDesc,TMainPicListID,TPicNum,TUpdateUserID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPictureListList
	s (TRowID,TPicTypeDR,TPicTypeDesc,TPicNo,TPicName,TSourceType,TSourceTypeDesc,TPicListRowID,TPicNum,TMainFlag,TMainPicListID,TUpdateUserID)=""
	quit
}

ClassMethod GetPictureListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPictureListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPictureListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPictureListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// author zx 2021-06-03 
/// desc 获取图片明细id,用于移动端轮播图片预览
/// input PTRowID,图片主表id
/// output 图片明细id串,用'^'分割
ClassMethod GetPictureDetail(PTRowID As %String = "")
{
	i PTRowID=""  q ""
	s PicListIDs=""
	s PLRowID=0
	f  s PLRowID=$o(^DHCEQPictureList(0,"Picture",PTRowID,PLRowID))  q:PLRowID=""  d
	.s PLInvalidFlag=$p($g(^DHCEQPictureList(PLRowID)),"^",12)
	.q:PLInvalidFlag="Y"
	.q:$p($g(^DHCEQPictureList(PLRowID)),"^",13)'="Y"
	.i PicListIDs'="" s PicListIDs=PicListIDs_"^"
	.s PicListIDs=PicListIDs_PLRowID
	
	q PicListIDs
}

/// author zx 2021-06-03 
/// desc 根据业务类型关联业务id与图片主表
/// input SourceType,业务类型 SourceID,业务id PicIDs,图片主表id串,逗号分隔 Dels,1表示删除,其它表示关联
/// output 0:成功 其它:失败
/// w ##Class(web.DHCEQ.Process.DHCEQPicture).SavePicturesByBussType("31","352","217,218","0")
ClassMethod SavePicturesByBussType(SourceType As %String = "", SourceID As %String = "", PicIDs As %String = "", Dels As %String = "")
{
	i (SourceType="")||(PicIDs="")  Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1")
	s SQLCODE=0
	Set $ZT="ERRORBatchSavePicture"
	TSTART
	s PicLength=$l(PicIDs,",")
	f i=1:1:PicLength d
	.q:SQLCODE'=0
	.s PicID=$p(PicIDs,",",i)
	.i Dels="1" d
	..&SQL(update SQLUSER.DHC_EQPicture set PT_InvalidFlag='2' where PT_SourceType=:SourceType and PT_RowID=:PicID)
	.e  d
	..&SQL(update SQLUSER.DHC_EQPicture set PT_SourceID=:SourceID where PT_SourceType=:SourceType and PT_RowID=:PicID)
	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
ERRORBatchSavePicture 
	TROLLBACK
	Set ErrorMsg=$ZE
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// author zx 2021-10-13
/// desc 根据业务获取图片清单id
/// input SourceType,业务类型 SourceID,业务id 
/// output PicListIDs,图片子表id串,逗号分隔
/// w ##Class(web.DHCEQ.Process.DHCEQPicture).SavePicturesByBussType("31","352","217,218","0")
ClassMethod GetListIDsByBussType(SourceType As %String = "", SourceID As %String = "")
{
	i (SourceType="")||(SourceID="")  q ""
	new (SourceType,SourceID)
	s (PicID,ListID,ListIDs)=""
	s PicID=0
	f  s PicID=$o(^DHCEQPicture(0,"Source",SourceType,SourceID,PicID)) q:PicID=""  d
	.q:$P(^DHCEQPicture(PicID),"^",7)="2"
	.s ListID=0
	.f  s ListID=$o(^DHCEQPictureList(0,"Picture",PicID,ListID)) q:ListID=""  d
	..i ListIDs'="" s ListIDs=ListIDs_","
	..s ListIDs=ListIDs_ListID
	
	q ListIDs
}

/// author zc0133 2023-4-20
/// desc 根据业务获取可访问图片数量
/// input SourceType,业务类型 SourceID,业务id PicTypeDR,图片类型
/// output PicNum,图片数量
/// w ##Class(web.DHCEQ.Process.DHCEQPicture).GetPictureNumBySource("52","1","1")
ClassMethod GetPictureNumBySource(SourceType As %String = "", SourceID As %String = "", PicTypeDR As %String = "")
{
 	i (SourceType="")||(SourceID="") q 0
 	
 	s PicNum=0
 	s CurSourceType="" 
	for  s CurSourceType=$o(^DHCEQPicture(0,"Source",CurSourceType)) q:CurSourceType=""  d
	.s SourceIDs=##Class(web.DHCEQ.Plat.LIBPicture).GetSourceIDs(SourceType,SourceID,CurSourceType) 
	.q:SourceIDs=""  
	.Set len=$L(SourceIDs,",")
	.for i=1:1:len d
	..s CurSourceID=$PIECE(SourceIDs,",",i)
	..s PTRowID=0
	..f  s PTRowID=$o(^DHCEQPicture(0,"Source",CurSourceType,CurSourceID,PTRowID))  q:PTRowID=""  d
	...q:$p($g(^DHCEQPicture(PTRowID)),"^",7)=2
	...q:(PicTypeDR'="")&&($p($g(^DHCEQPicture(PTRowID)),"^",5)'=PicTypeDR)
	...s PicNum=PicNum+1
		
	quit PicNum
}

}

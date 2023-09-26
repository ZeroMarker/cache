/// 名称: web.DHCEQ.Plat.LIBPicture
/// 描述: 设备图片管理
/// 编写者：ZX
/// 编写日期: 2018-09-22
/// 产品组：设备管理
Class web.DHCEQ.Plat.LIBPicture Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      ZX
/// CreatDate：    2018-09-22
/// Description:   台账首页获取图片
/// Table：        DHC_EQPicture DHC_EQPictureList
/// Input：        RowID:台账ID 
/// Return:        获取第一张图片ID
/// d ##Class(web.DHCEQ.Plat.LIBPicture).GetPictureByEquip(10)
ClassMethod GetPictureByEquip(RowID As %String = "")
{
	n SourceID
	s PicListRowID=""
	s DefualtPicType=##class(web.DHCEQCommon).GetSysInfo("990046")   //Modefied by zc0063 20200407  默认图片外观照
	i RowID'=""
	{
		//Modefied by zc0060 20200326  图片外观照  begin
		s vFlag=0
		s PicRowID=""
		; 取台账上传的默认图片
		s vPicRowID=0
		f  s vPicRowID=$o(^DHCEQPicture(0,"Source",52,RowID,vPicRowID)) q:(vPicRowID="")||(vFlag'=0)  d
		.q:$p($g(^DHCEQPicture(vPicRowID)),"^",7)=2
		.q:(+DefualtPicType>0)&&($p($g(^DHCEQPicture(vPicRowID)),"^",5)'=DefualtPicType)
		.s vFlag=1
		.s PicRowID=vPicRowID
		/*
		s PicRowID=$o(^DHCEQPicture(0,"Source",52,RowID,""))
		if PicRowID'=""
		{
			i $p($G(^DHCEQPicture(PicRowID)),"^",7)=2 s PicRowID=""		;InvalidFlag
		}*/
		; 取验收上传的默认图片

		i PicRowID=""
		{
			//Mozy	902708	2019-5-27	修正验收单取值
			s SourceID=+$p(^DHCEQEquip(RowID),"^",77)
			s vPicRowID=0
			f  s vPicRowID=$o(^DHCEQPicture(0,"Source",11,SourceID,vPicRowID)) q:(vPicRowID="")||(vFlag'=0)  d
			.q:$p($g(^DHCEQPicture(vPicRowID)),"^",7)=2
			.q:(+DefualtPicType>0)&&($p($g(^DHCEQPicture(vPicRowID)),"^",5)'=DefualtPicType)
			.s vFlag=1
			.s PicRowID=vPicRowID
			/*
			s PicRowID=$o(^DHCEQPicture(0,"Source",11,SourceID,""))
			if PicRowID'=""
			{
				i $p($G(^DHCEQPicture(PicRowID)),"^",7)=2 s PicRowID=""		;InvalidFlag
			}*/
			i $p($g(^DHCEQEquip(RowID,"OtherInfo")),"^",24)'="" s PicRowID=""	;ParentDR	Mozy	914928	2019-7-11	附属设备不取验收单图片
		}
		//Modefied by zc0060 20200326 图片外观照  end
		
		i PicRowID'="" d
		.s TmpListRowID=0	;记录有效的图片明细ID
		.s Sort=""
		.for  s Sort=$o(^DHCEQPictureList(0,"PicSort",PicRowID,Sort),-1) q:(Sort="")||(PicListRowID'="")  d
		..s ListRowID=""
		..for  s ListRowID=$o(^DHCEQPictureList(0,"PicSort",PicRowID,Sort,ListRowID)) q:(ListRowID="")||(PicListRowID'="")  d
		...q:$p($G(^DHCEQPictureList(ListRowID)),"^",12)="Y"		;InvalidFlag
		...
		...s TmpListRowID=ListRowID
		...i $p($G(^DHCEQPictureList(ListRowID)),"^",4)="Y" s PicListRowID=ListRowID
		.i (PicListRowID="")&&(TmpListRowID>0) s PicListRowID=TmpListRowID
		.s PicListRowID=##Class(websys.Page).Encrypt(PicListRowID)
	}
	
	q PicListRowID
}

/// //////////////////////////////////////////////////////////////////////////////////
/// w ##Class(web.DHCEQ.Plat.LIBPicture).GetPictureBySource(31,25,4)
ClassMethod GetPictureBySource(SourceType As %String = "", SourceID As %String = "", PicTypeDR As %String = "")
{
	i (SourceType="")||(SourceID="") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	
	s PictureInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	//add by zx 2019-04-02 获取相关连业务图片 测试组需求号:866651
	s CurSourceType="" 
	for  s CurSourceType=$o(^DHCEQPicture(0,"Source",CurSourceType)) q:CurSourceType=""  d
	.s SourceIDs=##Class(web.DHCEQ.Plat.LIBPicture).GetSourceIDs(SourceType,SourceID,CurSourceType) 
	.q:SourceIDs=""  
	.Set len=$L(SourceIDs,",")
	.for i=1:1:len d
	..s CurSourceID=$PIECE(SourceIDs,",",i)
	..s PTRowID=0
	..f  s PTRowID=$o(^DHCEQPicture(0,"Source",CurSourceType,CurSourceID,PTRowID))  q:PTRowID=""  d
	...s PTInvalidFlag=$p($g(^DHCEQPicture(PTRowID)),"^",7)
	...q:PTInvalidFlag=2
	...s PTTypeDR=$p($g(^DHCEQPicture(PTRowID)),"^",5)
	...///modified by ZY20230216 bug:3256164
	...q:(PicTypeDR'=0)&&(PicTypeDR'="")&&((","_PicTypeDR_",")'[(","_PTTypeDR_","))
	...s PTPath=""
	...s PTName=$p($g(^DHCEQPicture(PTRowID)),"^",13)
	...s PLFind=""
	...s PLFlag="N"
	...s PicNum=0  //Add by zc0125 2022-12-8 添加数量显示
	...s PLRowID=0
	...f  s PLRowID=$o(^DHCEQPictureList(0,"Picture",PTRowID,PLRowID))  q:(PLRowID="")||(PLFind'="")  d
	....s PLInvalidFlag=$p($g(^DHCEQPictureList(PLRowID)),"^",12)
	....q:PLInvalidFlag="Y"
	....s PicNum=PicNum+1  //Add by zc0125 2022-12-8 添加数量显示
	....i PTPath="" s PTPath=##Class(web.DHCEQ.Process.DHCEQPicture).GetFtpStreamSrcByPLRowID(PLRowID)
	....s PLFlag=$p($g(^DHCEQPictureList(PLRowID)),"^",4)
	....i ((PLFind="")&&(PLFlag="Y")) s PLFind=PLRowID
	...i PLFind'="" s PTPath=##Class(web.DHCEQ.Process.DHCEQPicture).GetFtpStreamSrcByPLRowID(PLFind)
	...q:PTPath=""
	...s OnePictureInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	...d OnePictureInfo.%Set("id",PTRowID)
	...d OnePictureInfo.%Set("path",PTPath)
	...d OnePictureInfo.%Set("name",PTName)
	...d OnePictureInfo.%Set("picunm",PicNum)  //Add by zc0125 2022-12-8 添加数量显示
	...d PictureInfo.%Set(PTRowID,OnePictureInfo)
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,PictureInfo)
}

ClassMethod GetPictureList(PTRowID As %String = "")
{
	i PTRowID=""  q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	s PictureListInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s PLRowID=0
	f  s PLRowID=$o(^DHCEQPictureList(0,"Picture",PTRowID,PLRowID))  q:PLRowID=""  d
	.s PLInvalidFlag=$p($g(^DHCEQPictureList(PLRowID)),"^",12)
	.q:PLInvalidFlag="Y"
	.; //Moidefied by zc0072 选中图片不能预览问题的处理 begin
	.;q:##Class(web.DHCEQ.Lib.Common).PicTypeIsIn($p($g(^DHCEQPictureList(PLRowID)),"^",5))=1  //Moidefied by zc0071 安全组可访问的文件与图片类型
	.; //Moidefied by zc0072 选中图片不能预览问题的处理 end
	.s PTPath=##Class(web.DHCEQ.Process.DHCEQPicture).GetFtpStreamSrcByPLRowID(PLRowID)
	.d PictureListInfo.%Set(PLRowID,PTPath)
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,PictureListInfo)
}

ClassMethod GetPicType(PTRowID As %String = "")
{
	i PTRowID="" q ""
	q $p($g(^DHCEQPicture(PTRowID)),"^",5)_"^"_$p($g(^DHCEQPicture(PTRowID)),"^",13)
}

ClassMethod DeletePic(PLRowID As %String = "")
{
	i PLRowID="" q 0
	s PTRowID=$p($g(^DHCEQPictureList(PLRowID)),"^",1)
	TSTART
	&SQL(Update SQLUSER.DHC_EQPictureList Set PL_InvalidFlag='Y' Where PL_RowID=:PLRowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s AllInvalidFlag="Y"
	s RowID=0
	f  s RowID=$o(^DHCEQPictureList(0,"Picture",PTRowID,RowID))  q:(RowID="")||(AllInvalidFlag'="Y")  d
	.s PLInvalidFlag=$p($g(^DHCEQPictureList(RowID)),"^",12)
	.q:PLInvalidFlag="Y"
	.s AllInvalidFlag="N"
	i AllInvalidFlag="Y"
	{
		&SQL(Update SQLUSER.DHC_EQPicture Set PT_InvalidFlag=2 Where PT_RowID=:PTRowID)
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

/// Creator：      ZX
/// CreatDate：    2019-04-02
/// Description:   获取业务类型可访问的图片类型
/// Input：        SourceType 业务类型代码 vFlag 图片与文件区分标识
/// Return：       可访问图片类型id串,以 "," 分割
/// w ##Class(web.DHCEQ.Plat.LIBPicture).GetPicTypeBySource("52")
/// Modefied by  zc0067 20200415  添加入参vFlag
ClassMethod GetPicTypeBySource(SourceType, vFlag As %String = "0", vGroupID As %String = "")
{
	new PicTypeDRs,PicTypeDR,PSTRowID
	i SourceType="" q ""
	s PicTypeDRs=""
	
	//Modefied by zc0067 20200415  根据业务类型获取可访问的图片与文件类型修改  begin
	s CurrentSourceType=0 
	for  s CurrentSourceType=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex",CurrentSourceType)) q:CurrentSourceType=""  d
	.q:CurrentSourceType=SourceType
	.q:##Class(web.DHCEQ.Process.DHCEQPicture).SourceTypeAccessable(SourceType,CurrentSourceType)=0
	.s PicTypeDR=0
	.f  s PicTypeDR=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex",CurrentSourceType,PicTypeDR))  q:PicTypeDR=""  d
	..s PSTRowID=0
	..f  s PSTRowID=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex",CurrentSourceType,PicTypeDR,PSTRowID))  q:PSTRowID=""  d
	...q:$p(^DHCEQCCode("DHCEQCPicSourceType",PSTRowID),"^",9)="Y"
	...q:(vFlag=0)&&($p(^DHCEQCCode("DHCEQCPicSourceType",PSTRowID),"^",10)'="Y")
	...q:(vFlag=1)&&($p(^DHCEQCCode("DHCEQCPicSourceType",PSTRowID),"^",11)'="Y")
	...q:##Class(web.DHCEQ.Lib.Common).PicTypeIsIn(PicTypeDR,vGroupID)=1  //Moidefied by zc0071 安全组可访问的文件与图片类型
	...q:(PicTypeDRs'="")&&((","_PicTypeDRs_",")[(","_PicTypeDR_","))
	...i PicTypeDRs'=""  d
	....s PicTypeDRs=PicTypeDRs_","
	...s PicTypeDRs=PicTypeDRs_PicTypeDR
	//Modefied by zc0067 20200415  根据业务类型获取可访问的图片与文件类型修改  end
	
	q PicTypeDRs
}

/// Creator：      ZX
/// CreatDate：    2019-04-02
/// Description:   获取当前业务设备相关联业务单id
/// Input：        CurrentSourceType 当前业务类型, CurrentSourceID 当前业务单id, SourceType 关联业务类型
/// Return：       当前业务单设备关联业务的id串,以 "," 分割
/// w ##Class(web.DHCEQ.Plat.LIBPicture).GetSourceIDs(0,8,1) 
ClassMethod GetSourceIDs(CurrentSourceType As %String, CurrentSourceID As %String, SourceType = "")
{
	i SourceType="" q CurrentSourceID
	;在自身业务类型中,只看到当前业务对应图片
	i SourceType=CurrentSourceType  q CurrentSourceID
	
	//有设备DR业务先获取设备DR，
	s EquipDR=$CASE(CurrentSourceType,52:CurrentSourceID,31:$p($G(^DHCEQMaintRequest(CurrentSourceID)),"^",1),32:$p($G(^DHCEQMaint(CurrentSourceID)),"^",1),33:$p($G(^DHCEQMaint(CurrentSourceID)),"^",1),:"")
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
	i SourceType=95 d
	.for  s TempSourceID=$o(^DHCEQServiceContract(0,"Equip",EquipDR,TempSourceID)) q:TempSourceID=""  d
	..i TSourceIDs="" s TSourceIDs=TempSourceID 
	..s TSourceIDs=TSourceIDs_","_TempSourceID
	i SourceType=94 d
	.s TempSourceID=$p($g(^DHCEQEquip(EquipDR)),"^",32)
	.i TempSourceID'="" s TempSourceID=$p($g(^DHCEQContractList(TempSourceID)),"^",1)		///modified by ZY20221115  合同图片SourceID记的是合同的ID
	.i TSourceIDs="" s TSourceIDs=TempSourceID
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
	
	q TSourceIDs
}

/// Creator：      lmm
/// CreatDate：    2020-02-29
/// Description:   根据业务及业务id获取图片id
/// Input：        CurrentSourceType 当前业务类型, CurrentSourceID 当前业务单id, SourceType 关联业务类型
/// Return：       当前业务单设备关联业务的id串,以 "," 分割
/// w ##Class(web.DHCEQ.Plat.LIBPicture).GetPictureIDBySource(67,8) 
ClassMethod GetPictureIDBySource(SourceType As %String, SourceID As %String)
{
	
	s PictureID=""
	s PictureID=$o(^DHCEQPicture(0,"Source",SourceType,SourceID,""))
	
	q PictureID
}

/// Creator：      ZC
/// CreatDate：    2020-04-15
/// Description:   获取业务类型必须上传的图片与文件
/// Input：        SourceType 业务类型代码 SourceID 业务ID vFlag 图片与文件区分标识
/// Return：       ReturnFlag^PicTypeDR 必须上传标识与图片类型
/// w ##Class(web.DHCEQ.Plat.LIBPicture).CheckMustUpLoad("52")
ClassMethod CheckMustUpLoad(SourceType, SourceID, vFlag As %String = "0")
{
	new PicTypeDR,PSTRowID
	i (SourceType="")||(SourceID="") q 0_"^^"  ///Modefied by ZC0081 2020-09-07 返回值修改
	s ReturnFlag=0
	s (PicTypeDR,PicType)=""   ///Modefied by ZC0082 2020-09-10  PicType未定义处理
	s vPicTypeDR=0
	f  s vPicTypeDR=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex",SourceType,vPicTypeDR))  q:(vPicTypeDR="")||(ReturnFlag'=0)  d
	.q:##Class(web.DHCEQ.Lib.Common).PicTypeIsIn(vPicTypeDR)=1  //Moidefied by zc0071 安全组可访问的文件与图片类型
	.s PSTRowID=0
	.f  s PSTRowID=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex",SourceType,vPicTypeDR,PSTRowID))  q:(PSTRowID="")||(ReturnFlag'=0)  d
	..q:$p(^DHCEQCCode("DHCEQCPicSourceType",PSTRowID),"^",9)="Y"
	..q:(vFlag=0)&&($p(^DHCEQCCode("DHCEQCPicSourceType",PSTRowID),"^",10)'="Y")
	..q:(vFlag=1)&&($p(^DHCEQCCode("DHCEQCPicSourceType",PSTRowID),"^",11)'="Y")
	..q:$p(^DHCEQCCode("DHCEQCPicSourceType",PSTRowID),"^",12)'="Y"
	..;q:##Class(web.DHCEQ.Plat.LIBPicture).CheckMustUpLoad(SourceType,SourceID,vPicTypeDR,vFlag)=0
	..q:##Class(web.DHCEQ.Plat.LIBPicture).CheckUpLoadPicType(SourceType,SourceID,vPicTypeDR,vFlag)=1  ///Modefied by ZC0081 2020-09-07 方法CheckMustUpLoad改为CheckUpLoadPicType
	..s ReturnFlag=1
	..s PicTypeDR=vPicTypeDR
	..i PicTypeDR'="" s PicType=$p($g(^DHCEQCCode("DHCEQCPicType",PicTypeDR)),"^",2)   ///Modefied by ZC0081 2020-09-07 添加图片描述返回值
	q ReturnFlag_"^"_PicTypeDR_"^"_PicType  ///Modefied by ZC0081 2020-09-07 返回值修改
}

/// Creator：      ZC0067
/// CreatDate：    2020-04-15
/// Description:   获取业务类型与业务ID判断必须上传的图片与文件是否已上传
/// Input：        SourceType 业务类型代码 SourceID 业务ID  PicTypeDR图片类型 vFlag 图片与文件区分标识
/// Return：       可访问图片类型id串,以 "," 分割
/// w ##Class(web.DHCEQ.Plat.LIBPicture).CheckUpLoadPicType(11,5,18,0)
ClassMethod CheckUpLoadPicType(SourceType, SourceID, vPicTypeDR, vFlag As %String = "0")
{
	i vPicTypeDR="" q 0
	s UpFlag=0
	
	i vFlag=0 d
	.s vPRowID=0
	.f  s vPRowID=$o(^DHCEQPicture(0,"Source",SourceType,SourceID,vPRowID))  q:(vPRowID="")||(UpFlag'=0)  d
	..q:$p($g(^DHCEQPicture(vPRowID)),"^",7)=2
	..q:$p($g(^DHCEQPicture(vPRowID)),"^",5)'=vPicTypeDR
	..s UpFlag=1
	e  d
	.s vARowID=0
	.f  s vARowID=$o(^DHCEQAppendFile(0,"SourceType",SourceType,SourceID,vARowID)) q:(vARowID="")||(UpFlag'=0)  d
	..q:$p($g(^DHCEQAppendFile(vARowID)),"^",19)="Y"
	..q:$p($g(^DHCEQAppendFile(vARowID)),"^",3)'=vPicTypeDR
	..s UpFlag=1
	q UpFlag
}

/// add by mwz20221101 
/// 根据盘盈明细获取图片
/// 入参：ExceptionID 盘盈表ID
/// 输出：  "web.DHCEQ.Lib.DHCEQStreamServer.cls?PICLISTROWID=1"
/// w ##Class(web.DHCEQ.Plat.LIBPicture).GetPiclistByExceptionID("41")
ClassMethod GetPiclistByExceptionID(ExceptionID As %String = "")
{
	s TPLRowID=""
	s PicRowID=0
	f  s PicRowID=$o(^DHCEQPicture(0,"Source","54",ExceptionID,PicRowID)) q:PicRowID=""  d
	.q:($p($g(^DHCEQPicture(PicRowID)),"^",7)=2)
	.s PLRowID=0
	.f  s PLRowID=$o(^DHCEQPictureList(0,"Picture",PicRowID,PLRowID)) q:PLRowID=""  d
	..s TPLRowID=PLRowID
	q ##Class(web.DHCEQ.Process.DHCEQPicture).GetFtpStreamSrcByPLRowID(TPLRowID)
}

/// 
/// 获取第一张图片
/// 入参：SourceType 业务类型代码 SourceID 业务ID  PicTypeDR图片类型
/// 输出：  "web.DHCEQ.Lib.DHCEQStreamServer.cls?PICLISTROWID=1"
/// w ##Class(web.DHCEQ.Plat.LIBPicture).GetFirstPicture("63-4","1","28")
ClassMethod GetFirstPicture(SourceType, SourceID, PicTypeDR)
{
	i SourceType="" q
	i SourceID="" q
	s PicRowID=0
	s PicListRowID=0
	f  s PicRowID=$o(^DHCEQPicture(0,"Source",SourceType,SourceID,PicRowID)) q:PicRowID=""  d
	.q:($p($g(^DHCEQPicture(PicRowID)),"^",7)=2)
	.q:$p($g(^DHCEQPicture(PicRowID)),"^",5)'=PicTypeDR
	.s ListRowID=0
	.s FindFlag=0
	.s Sort=0
	.for  s Sort=$o(^DHCEQPictureList(0,"PicSort",PicRowID,Sort)) q:(Sort="")||(FindFlag'=0)  d
	..for  s ListRowID=$o(^DHCEQPictureList(0,"PicSort",PicRowID,Sort,ListRowID)) q:(ListRowID="")||(FindFlag'=0)  d
	...q:$p($G(^DHCEQPictureList(ListRowID)),"^",12)="Y" 
	...s FindFlag=1
	...s PicListRowID=ListRowID
	...s PicListRowID=##Class(websys.Page).Encrypt(PicListRowID)
	.i FindFlag=0 d
	..for  s ListRowID=$o(^DHCEQPictureList(0,"Picture",PicRowID,ListRowID)) q:(ListRowID="")||(FindFlag'=0)  d
	...q:$p($G(^DHCEQPictureList(ListRowID)),"^",12)="Y"
	...s FindFlag=1
	...s PicListRowID=ListRowID
	...s PicListRowID=##Class(websys.Page).Encrypt(PicListRowID)
	q PicListRowID
}

}

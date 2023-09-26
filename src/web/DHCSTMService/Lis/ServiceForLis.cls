Import sqluser

/// Descript:	同东华Lis之间的接口程序
/// Creator:	wangjiabin
/// CreateDate:	2018-04-23
Class web.DHCSTMService.Lis.ServiceForLis Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ ProcedureBlock ]
{

/// 接口说明:
/// 1.参数UseFlag为是否启用接口的控制,当且仅当此值为Y时,启用该接口;
/// 2.生成条码时,要提前更新应用,以及必要的单号规则;根据接收科室配置是否生成条码;
/// 3.方法中通过转换命名空间(这里有两个命名空间,具体以项目为准)调用Lis方法,如需调用Service,需做代码调整;
/// 4.GetInciFlag方法中,控制库存项目的范围(用于库存项同步,以及出库审核时推送范围的控制),需根据项目实际情况-调-整-代-码;
/// 
Parameter AppName [ Final ] = "DHCSTMSERFORLISM";

Parameter wsuser = "dhwebservice";

Parameter wsps = "dhwebservice";

/// 判断库存项是否在使用范围内
/// [各方法统一调用]
ClassMethod GetInciFlag(Inci) As %String [ Private ]
{
	q:Inci="" ""
	s Flag="N"
	s StkType=..sssCode()
	s IncscId=$p(^INCI(Inci,2),"^",2)	;库存分类id
	q:IncscId="" Flag
	s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	s ScgType=$p(ScgInfo,"^",3)			;类组(M表示物资)
	s ScgId=$p(ScgInfo,"^",5)			;类组rowid
	s ScgSet=$p(ScgInfo,"^",7)			;类组集合(MM,MO,MR等)
	q:(ScgType'=StkType) Flag
	;q:IncscId'=** Flag					;条件不满足的及时退出
	
	s Flag="Y"
	q Flag
}

/// Description:供应商字典数据(ps:若启用了供应商类组授权(按全院设置),本query起作用)
/// 	上线期初同步时,VendorId传""即可
/// CreatDate:	2019-01-28
/// Input:		供应商Id
/// OutPut:		0:成功, 其他:失败
/// w ##class(web.DHCSTMService.Lis.ServiceForLis).SynVendorInfo(810)
ClassMethod SynVendorInfo(VendorId = "", HospId = "")
{
	q:##class(web.DHCSTMHUI.ServiceConfig).GetSerUseFlag("LIS",HospId)'="Y" 0
	
	set xml=##class(%XML.Writer).%New()
	s SupStream=##class(%GlobalCharacterStream).%New()
	d xml.OutputToStream(SupStream)
	
	d xml.RootElement("Request")
	d xml.Element("Body")
	d xml.Element("SupplierInfoList")
	
	s APCType=..sssCode()
	s result = ##class(%Library.ResultSet).%New()
	i (VendorId="") {
		;是否根据供应商类组授权进行取值
		s ApcScg=##class(web.DHCSTMHUI.Common.AppCommon).GetCommPropValue("ApcScg","")
		i ApcScg="Y" d
		.s sqlStr = "SELECT distinct(ACG_APCVM_Dr) RowId FROM DHC_ApcCatGroup where ACG_SCG_Dr in (SELECT SCG_Rowid FROM dhc_stkcatgroup WHERE SCG_Type='M' AND SCG_Set='MR') and ACG_UseFlag='Y'"
		e  d
		.s sqlStr = "SELECT APCVM_ROWID AS RowId FROM APC_Vendor"
	} else {
		s sqlStr = "SELECT APCVM_ROWID AS RowId FROM APC_Vendor where %id="_VendorId
	}
	d result.Prepare(sqlStr)
	d result.Execute()
	s Count=0
	While(result.Next())
	{
		s RowId=result.Data("RowId")
		s APCVMDesc=$p(^APC("APCVM",RowId),"^",3)
		s APCStkType=$p(^APC("APCVM",RowId),"^",9)
		s STV=$o(^DHCSTV(0,RowId,""))
		continue:APCStkType'=APCType
		s APCStatus=$p(^APC("APCVM",RowId),"^",18)
		continue:APCStatus'="A"
		s rc=$p($G(^APC("APCVM",RowId,1)),"^",11)
		continue:rc="Y"									;过滤中间供应商
		s Remark=""										;备注
		s Count=Count+1
		d xml.Element("SupplierInfo")
		d xml.Element("SupCode"),xml.Write(RowId),xml.EndElement()
		d xml.Element("SupName"),xml.Write(APCVMDesc),xml.EndElement()
		d xml.Element("Remark"),xml.Write(Remark),xml.EndElement()
		d xml.EndElement()
	}
	d result.Close()
	d xml.EndElement()
	d xml.EndDocument()
	d xml.EndRootElement()
	
	/*
	s Ret=0
	s SupStr=SupStream.Read()
	s Soap=##class(web.DHCSTMService.Lis.ForHRPServiceSoap).%New()
	s Soap.Username=..#wsuser
	s Soap.Password=..#wsps
	s OutString=Soap.OfferInterface("WZ002",SupStr)
	s OutSteam=##class(%GlobalCharacterStream).%New()
	d OutSteam.Write(OutString)
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(OutSteam,.tDocument)
	set tSC=tDocument.EvaluateExpression("/Response/Body/ResultCode","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set Ret=tRes.GetAt(1).Value
	}
	q Ret
	*/
	
	s $ZT="NameSpaceZT"
	s Ret=0
	i Count>0 d
	.zn "dhc-lissrc"
	.s Ret=##class(LIS.Service.RG.Interface.RGInterface).SynchroSupplierInfo(SupStream)
	.zn "dhc-app"
	
	
	q Ret
NameSpaceZT
	zn "dhc-app"
	q -999
}

/// Description:试剂字典数据(ps:设置试剂所属类组的"归类"为"试剂",见类组维护界面)
/// CreatDate:	2018-04-23
/// Input:		
/// OutPut:		
/// 	RCode			试剂代码			InciCode
/// 	RCName			试剂中文名称		InciDesc
/// 	REName			试剂英文名称		InciDescEn(暂时传"")
/// 	PackageSize		试剂规格			Spec
/// 	UnitCode		试剂入库单位代码	PUomId(代码无意义,传rowid)
/// 	UnitName		试剂入库单位名称	PUomDesc
/// 	CategoryCode	试剂类别代码		IncscId(库存分类rowid)
/// 	CategoryName	试剂类别名称		库存分类
/// 	ManuCode		试剂生产厂家代码	ManfId(生产厂家rowid)
/// 	ManuName		试剂生产厂家商名称 生产厂家
/// 	LicenseNo		许可证号			???
/// 	RegisterNo		注册证号			CertNo
/// 	RegExpireDate	注册证有效期(Y-m-d)	CertExpDate
/// 	Remark			备注				InciRemarks
/// 	
/// w ##class(web.DHCSTMService.Lis.ServiceForLis).SynInciInfo(2,2)
ClassMethod SynInciInfo(InciId = "", HospId = "") As %Status
{
	q:##class(web.DHCSTMHUI.ServiceConfig).GetSerUseFlag("LIS",HospId)'="Y" 0
	set xml=##class(%XML.Writer).%New()
	s InciStream=##class(%GlobalCharacterStream).%New()
	d xml.OutputToStream(InciStream)
	
	d xml.RootElement("Request")
	d xml.Element("Body")
	d xml.Element("CT_MedicalStockList")
	
	s StkType=..sssCode()
	s Count=0
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.q:+Inci=0
	.q:(InciId'="")&&(Inci'=InciId)
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgStkType=$p(ScgInfo,"^",3)
	.q:ScgStkType'=StkType
	.s InciFlag=..GetInciFlag(Inci)
	.q:InciFlag'="Y"
	.
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s PUomId=$p(^INCI(Inci,3),"^",6)
	.q:(BUomId="")||(PUomId="")||'$d(^CT("UOM",BUomId))||'$d(^CT("UOM",PUomId))
	.s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
	.s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	.s PUomDesc=$p(^CT("UOM",PUomId),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.
	.s IncscId=$p(^INCI(Inci,2),"^",2)
	.q:IncscId=""
	.s IncscDesc=$p(^INC("SC",IncscId),"^",2)
	.
	.s InciRemarks=""
	.i $d(^INCI(Inci,"REM",1)) d
	..s InciRemarks=^INCI(Inci,"REM",1)
	.
	.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci)
	.s ManfId=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",3)
	.;存储条件
	.s StoreCond=##class(web.DHCSTMHUI.ITMSTORECON).GetStoreCond(Inci)
	.s certInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(Inci)
	.s CertNo=$p(certInfo,"^",1)
	.s CertExpDate=$p(certInfo,"^",2)
	.s:CertExpDate'="" CertExpDate=$zd(CertExpDate,8)
	.s Count=Count+1
	.d xml.Element("CT_MedicalStock")
	.d xml.Element("CTPHDMS_RowId"),xml.Write(Inci),xml.EndElement()				;试剂ID
	.d xml.Element("CTPHDMS_Code"),xml.Write(InciCode),xml.EndElement()				;试剂代码
	.d xml.Element("CTPHDMS_Desc"),xml.Write(InciDesc),xml.EndElement()				;试剂名称
	.d xml.Element("CTPHDMS_Spec"),xml.Write(Spec),xml.EndElement()
	.d xml.Element("CTPHDMS_CheckInUnitCode"),xml.Write(PUomId),xml.EndElement()	;入库单位代码(物资数据ID)
	.d xml.Element("CTPHDMS_CheckInUnitDesc"),xml.Write(PUomDesc),xml.EndElement()	;入库单位描述
	.d xml.Element("CTPHDMS_BasicUnitCode"),xml.Write(BUomId),xml.EndElement()		;基本单位代码(物资数据ID)
	.d xml.Element("CTPHDMS_BasicUnitDesc"),xml.Write(BUomDesc),xml.EndElement()	;基本单位描述
	.d xml.Element("CTPHDMS_CheckInConvFacCode"),xml.Write(UomFac),xml.EndElement()	;单位转换系数
	.d xml.Element("CTPHDMS_DrugMateriel"),xml.Write(2),xml.EndElement()			;物料类别: 1.药品 2.医用耗材 3.后勤物资
	.d xml.Element("CTPHDMS_ManufacturerCode"),xml.Write(ManfId),xml.EndElement()
	.d xml.Element("CTPHDMS_ManufacturerDesc"),xml.Write(ManfDesc),xml.EndElement()
	.d xml.Element("CTPHDMS_StorageCondition"),xml.Write(StoreCond),xml.EndElement()	;存储条件
	.d xml.Element("CTPHDMS_CertNo"),xml.Write(StoreCond),xml.EndElement()
	.d xml.Element("CTPHDMS_CertExpDate"),xml.Write(StoreCond),xml.EndElement()
	.d xml.EndElement()
	
	d xml.EndElement()
	d xml.EndElement()
	d xml.EndRootElement()
	
	q:Count=0 0
	
	/*
	s Ret=0
	s InciStr=InciStream.Read()
	s Soap=##class(web.DHCSTMService.Lis.ForHRPServiceSoap).%New()
	s Soap.Username=..#wsuser
	s Soap.Password=..#wsps
	s OutString=Soap.OfferInterface("WZ001",InciStr)
	s OutSteam=##class(%GlobalCharacterStream).%New()
	d OutSteam.Write(OutString)
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(OutSteam,.tDocument)
	set tSC=tDocument.EvaluateExpression("/Response/ResultCode","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set Ret=tRes.GetAt(1).Value
	}
	q Ret
	*/
	s Ret=0
	s $ZT="NameSpaceZT"
	i Count>0 d
	.zn "dhc-lissrc"
	.s Ret=##class(LIS.Service.RG.Interface.RGInterface).SynchroReagBaseData(InciStream)
	.zn "dhc-app"
	
	q Ret
NameSpaceZT
	zn "dhc-app"
	q -999
}

/// Description:物资出库接收时,为lis方面升成条码
/// CreatDate:	2018-04-23
/// Input:		出库单rowid
/// OutPut:		0:成功, <0:失败
/// w ##class(web.DHCSTMService.Lis.ServiceForLis).CreateLisBarCode(247)
ClassMethod CreateLisBarCode(Init As %String, HospId = "")
{
	q:##class(web.DHCSTMHUI.ServiceConfig).GetSerUseFlag("LIS",HospId)'="Y" 0
	
	q:Init="" ""
	s AppName=..%GetParameter("AppName")
	
	s InitNo=$p(^DHCINIT(Init),"^",1)
	s FrLoc=$p(^DHCINIT(Init),"^",5)
	s ToLoc=$p(^DHCINIT(Init),"^",6)
	s Ingr=$p(^DHCINIT(Init),"^",21)
	s HospId=$p(^CTLOC(ToLoc),"^",22)
	s Param="^"_ToLoc_"^^"_HospId
	s CreateInitBarCode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"CreateInitBarCode",Param)
	q:CreateInitBarCode'="Y" 0
	s Count=0
	;s (UserId,UserName)=""		;采购人id,姓名
	;s UserId=$p(^DHCINIT(Init),"^",11)	;审核人(审核时自动接收审核人为空)
	s UserId=$p(^DHCINIT(Init),"^",8)	;暂取制单人
	s UserName=$S(UserId'="":$p(^SSU("SSUSR",UserId),"^",2),1:"")
	
	s xml=##class(%XML.Writer).%New()
	s InitStream=##class(%GlobalCharacterStream).%New()
	d xml.OutputToStream(InitStream)
	
	d xml.RootElement("InboundInfo")
	;d xml.Element("MedMVBillNo"),xml.Write(InitNo),xml.EndElement()		;出库单号
	d xml.Element("BillNo"),xml.Write(InitNo),xml.EndElement()
	//d xml.Element("OrderListNo"),xml.Write(InitNo),xml.EndElement()		;采购订单编号
	d xml.Element("UserCode"),xml.Write(UserId),xml.EndElement()
	d xml.Element("UserDesc"),xml.Write(UserName),xml.EndElement()
	d xml.Element("SenderName"),xml.Write(UserName),xml.EndElement()	;送货人姓名
	d xml.Element("Remarks"),xml.Write(""),xml.EndElement()
	d xml.Element("DeptCode"),xml.Write(ToLoc),xml.EndElement()
	d xml.Element("InboundReagItemsList")
	s Err=0
	ts
	s Ch=0
	f  s Ch=$o(^DHCINIT(Init,"ITI",Ch)) q:(Ch="")||(Err<0)  d
	.s Initi=Init_"||"_Ch
	.s InitiInfo=^DHCINIT(Init,"ITI",Ch)
	.s Inclb=$p(InitiInfo,"^",3)
	.s vendorinfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	.s VendorId=$p(vendorinfo,"^",1)
	.s VendorDesc=$p(vendorinfo,"^",2)
	.s Inci=$p(Inclb,"||",1)
	.s InciFlag=..GetInciFlag(Inci)
	.q:InciFlag'="Y"
	.s Count=Count+1
	.;d xml.Element("InboundReagItems")
	.
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s Qty=$p(InitiInfo,"^",1)
	.s Qty=$SYSTEM.SQL.CEILING(Qty)
	.s RpAmt=$p(InitiInfo,"^",16)
	.s InitiRemark=$p(InitiInfo,"^",28)
	.s (BatchNo,ExpDate)=""
	.s IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	.s Incib=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
	.i Incib'="" d
	..s IB=$p(Incib,"||",2)
	..s BatchNo=$p(^INCI(Inci,"IB",IB),"^",1)
	..s ExpDate=$p(^INCI(Inci,"IB",IB),"^",2)
	..s:ExpDate'="" ExpDate=$zd(ExpDate,8)	;YYYYmmdd格式
	.
	.i '$d(^DHCINITB(0,"INITI",Initi)) d
	..;未生成过的,按规则生成Lis所需代码
	..d xml.Element("InboundReagItem")
	..
	..d xml.Element("MaterialCode"),xml.Write(Inci),xml.EndElement()
	..d xml.Element("MaterialQty"),xml.Write(Qty),xml.EndElement()
	..d xml.Element("Batch"),xml.Write(BatchNo),xml.EndElement()
	..//d xml.Element("CTMMManufacturerCode"),xml.Write(""),xml.EndElement()	;试剂生产厂家代码
	..d xml.Element("SupplierDR"),xml.Write(VendorId),xml.EndElement()
	..d xml.Element("ExpireDate"),xml.Write(ExpDate),xml.EndElement()
	..d xml.Element("ReceAmount"),xml.Write(RpAmt),xml.EndElement()
	..d xml.Element("SettleAmount"),xml.Write(RpAmt),xml.EndElement()
	..d xml.Element("Remarks"),xml.Write(InitiRemark),xml.EndElement()
	..d xml.Element("BarcodeItemList")
	..f i=1:1:Qty d
	...s InitiBarCode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"","")
	...s obj=##class(User.DHCINITBarCode).%New()
	...d obj.INITBINITIDRSetObjectId(Initi)
	...s obj.INITBBarCode=InitiBarCode
	...s sc=obj.%Save()
	...i $$$ISERR(sc) s Err=-1 q
	...d xml.Element("BarcodeItem")
	...d xml.Element("MaterialBarcode"),xml.Write(InitiBarCode),xml.EndElement()
	...d xml.EndElement()
	..q:Err<0
	..d xml.EndElement()
	..d xml.EndElement()
	.e  d
	..;已经生成过的,直接取值
	..d xml.Element("InboundReagItem")
	..
	..d xml.Element("MaterialCode"),xml.Write(Inci),xml.EndElement()
	..d xml.Element("MaterialQty"),xml.Write(Qty),xml.EndElement()
	..d xml.Element("Batch"),xml.Write(BatchNo),xml.EndElement()
	..//d xml.Element("CTMMManufacturerCode"),xml.Write(""),xml.EndElement()	;试剂生产厂家代码
	..d xml.Element("SupplierDR"),xml.Write(VendorId),xml.EndElement()	;试剂生产厂家代码
	..d xml.Element("ExpireDate"),xml.Write(ExpDate),xml.EndElement()
	..d xml.Element("ReceAmount"),xml.Write(RpAmt),xml.EndElement()
	..d xml.Element("SettleAmount"),xml.Write(RpAmt),xml.EndElement()
	..d xml.Element("Remarks"),xml.Write(InitiRemark),xml.EndElement()
	..d xml.Element("BarcodeItemList")
	..
	..s INITB=0
	..f  s INITB=$o(^DHCINITB(0,"INITI",Initi,INITB)) q:INITB=""  d
	...s InitiBarCode=$p(^DHCINITB(INITB),"^",2)
	...d xml.Element("BarcodeItem")
	...d xml.Element("MaterialBarcode"),xml.Write(InitiBarCode),xml.EndElement()
	...d xml.EndElement()
	..
	..d xml.EndElement()
	..d xml.EndElement()
	
	i Err<0 tro  q Err
	
	tc
	d xml.EndElement()
	//d xml.EndElement()
	//d xml.EndElement()
    d xml.EndRootElement()
	s $ZT="NameSpaceZT"
	s Reasult=""
	s Ret=0
	q:Count=0 Ret
	zn "dhc-lisdata"
	s Result=##class(Service.RG.RGInterface).InboundReag(InitStream)
	zn "dhc-app"
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(Result)
	If $$$ISERR(sc)  s Ret=-997
	q:Ret'=0 Ret
	s ResultObj=##class(web.DHCSTMService.Lis.Model.Response).%New()
	d reader.Correlate("Response","web.DHCSTMService.Lis.Model.Response")
	while reader.Next(.ResultObj,.sc){
		s ResultCode=ResultObj.ResultCode
		s ResultContent=ResultObj.ResultContent
	}
	;w ResultContent,!
	i +ResultCode'=1 s Ret=-998
	
	q Ret
NameSpaceZT
	zn "dhc-app"
	q -999
}

/// Description:订单生成
/// CreatDate:	2019-08-24
/// Input:		
/// OutPut:		0:成功, <0:失败
/// w ##class(web.DHCSTMService.Lis.ServiceForLis).AcceptInPoInfo("<Request><RGOrderInfo><SourceSystem></SourceSystem><MessageID></MessageID><OrderListNo>ORD201804120011</OrderListNo><CTMASupplier>上海腾泰贸易商行</CTMASupplier><DepCode>J</DepCode><DepDesc>检验科</DepDesc><UserCode>reag</UserCode><UserDesc>rg管理员</UserDesc><Remarks>采购计划汇总生成</Remarks><OrderReagItemsList><OrderReagItem><MaterialCode>1007</MaterialCode><MaterialName>3M灭菌指示胶带(1222/国产)</MaterialName><MaterialSpec></MaterialSpec><MaterialUnit>瓶</MaterialUnit><MaterialQty>10</MaterialQty><BatchNum>3</BatchNum></OrderReagItem></OrderReagItemsList></RGOrderInfo></Request>")
ClassMethod AcceptInPoInfo(Input As %GlobalCharacterStream, HospId = "") As %String
{
	q:##class(web.DHCSTMHUI.ServiceConfig).GetSerUseFlag("LIS",HospId)'="Y" 0
	
	q:Input="" ""
	//测试
	//s Data="<Request><RGOrderInfo><SourceSystem></SourceSystem><MessageID></MessageID><OrderListNo>ORD201804120011</OrderListNo><CTMASupplier>AM00014</CTMASupplier><DepCode>J</DepCode><DepDesc>物资材料库</DepDesc><UserCode>Demo</UserCode><UserDesc>Demo Group</UserDesc><Remarks>采购计划汇总生成</Remarks><OrderReagItemsList><OrderReagItem><MaterialCode>GZ00001x</MaterialCode><MaterialName>生物止血材料(可吸收止血膜)</MaterialName><MaterialSpec>III</MaterialSpec><MaterialUnit>片</MaterialUnit><MaterialQty>10</MaterialQty><BatchNum>3</BatchNum></OrderReagItem></OrderReagItemsList></RGOrderInfo></Request>"
	//Set Input=##class(%GlobalCharacterStream).%New()
	//d Input.Write(Data)
	s $ZT="ErrorHandle"
	s Ret=0
	s InPo="",LocDesc="",UserName="",VendorCode="",Vendor="",LocId="",User="",HospId="",Remark="",OrderReagItem=""
	s DetailData="",MainData=""
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(Input)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	d reader.Correlate("RGOrderInfo","web.DHCSTMService.Lis.Model.OrderReag")
	While reader.Next(.OrderReagobj,.sc){
		s InPo=OrderReagobj.OrderListNo
		s LocDesc=OrderReagobj.DepDesc
		s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
		s LocId=$o(^CTLOC(0,"Desc",LocDesc,""))
		s UserName=OrderReagobj.UserDesc
		s UserName=$$ALPHAUP^SSUTIL4(UserName)
		s User=$o(^SSU("SSUSR",0,"SSUSR_Name",UserName,""))
		i LocId="" s Ret=-1
		s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
		s Remark=OrderReagobj.Remarks
		s VendorCode=OrderReagobj.CTMASupplier
		s VendorCode=$$ALPHAUP^SSUTIL4(VendorCode)
		s Vendor=$o(^APC("APCVM",0,"APCVM_Name",VendorCode,""))
		i Vendor="" s Ret=-2
		s CmpFlag="N"
		s MainData=Vendor_"^"_LocId_"^"_User_"^^"_CmpFlag_"^"_Remark_"^"
		s ParamStr="^"_LocId_"^"_User_"^"_HospId
		continue:Ret'=0
		s Len=OrderReagobj.OrderReagItemsList.Count()
		s InPoData=""
		f i=1:1:Len {
			s OrderReagItemListObj=OrderReagobj.OrderReagItemsList.GetAt(i)
			s OrderReagItemObjLen=OrderReagItemListObj.OrderReagItem.Count()
			f j=1:1:OrderReagItemObjLen {
				s OrderReagItemObj=OrderReagItemListObj.OrderReagItem.GetAt(j)
				s InciCode=OrderReagItemObj.MaterialCode
				s InciCode=$$ALPHAUP^SSUTIL4(InciCode)
				s Inci=$o(^INCI(0,"Code",InciCode,""))
				i Inci="" s Ret=-3 q
				s InciDesc=OrderReagItemObj.MaterialName
				s SpecDesc=OrderReagItemObj.MaterialSpec		;按具体规格
				s Info=$o(^DHCITMINFO(0,"INCI",Inci,0))
				i Info'="" d
				.s TmpSpec=$p(^DHCITMINFO(Info),"^",27)
				.;i TmpSpec'=SpecDesc s Ret=-4					;规格不一致
				s Qty=OrderReagItemObj.MaterialQty
				s UomDesc=OrderReagItemObj.MaterialUnit
				s UomDesc=$$ALPHAUP^SSUTIL4(UomDesc)
				s Uom=$o(^CT("UOM",0,"Desc",UomDesc,""))
				s BUomId=$p(^INCI(Inci,1),"^",10)
				s PurUomId=$p(^INCI(Inci,3),"^",6)
				i (BUomId'=Uom)&&(PurUomId'=Uom) s Ret=-5 q		;单位不一致
				s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetConfigRp(Inci,Uom,##class(web.DHCSTMHUI.INPO).%GetParameter("AppName"),ParamStr)
				s ReqQty=Qty
				s InPoData=Inci_"^"_Uom_"^"_Rp_"^"_Qty_"^"_ReqQty_"^"_SpecDesc
				s InpoTitle="InciId^UomId^Rp^PurQty^ReqQty^SpecDesc"
				s InPoData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(InPoData,InpoTitle)
				if (DetailData="") {
					s DetailData=InPoData
				} else {
					s DetailData=DetailData_","_InPoData
				}
			}
		}
	}
	q:Ret<0 Ret
	s MainData=$tr(MainData,$c(0),"")
	s MainTitle="Vendor^PoLoc^gUserId^StkScg^ReqLoc"
	s Main=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
	
	s DetailData=$tr(DetailData,$c(0),"")
	s Detail="["_DetailData_"]"
	ts
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s RtnObj=##class(web.DHCSTMHUI.INPO).Update(Main)
	i RtnObj.success<0 tro  q -10
	s MainId=RtnObj.rowid
	s RtnObj=##class(web.DHCSTMHUI.INPOItm).Save(MainId,Detail)
	i RtnObj.success<0 tro  q -11
	tc
	q 0
ErrorHandle
	s Ret="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
	Quit Ret
}

/// w ##class(web.DHCSTMService.Lis.ServiceForLis).SynInciInfoM("27443",2)
ClassMethod SynInciInfoM(InciId = "", HospId = "") As %Status
{
	;q:..#UseLisFlag'="Y" 0
	;s HospId=%session.Data("LOGON.HOSPID")
	set xml=##class(%XML.Writer).%New()
	s InciStream=##class(%GlobalCharacterStream).%New()
	d xml.OutputToStream(InciStream)
	
	s $ZT="NameSpaceZT"
	s InciBaseData=##class(web.DHCSTMService.Lis.Model.BaseData).%New()
	d InciBaseData.ListBaseData.Clear()
	s StkType=..sssCode()
	s Count=0,Ret=0
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.q:+Inci=0
	.q:(InciId'="")&&(Inci'=InciId)
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgStkType=$p(ScgInfo,"^",3)
	.s ScgSet=$p(ScgInfo,"^",7)			;类组集合
	.s ScgId=$p(ScgInfo,"^",5)
	.;q:ScgId'=17
	.q:ScgStkType'=StkType
	.q:ScgSet'="MR"
	.s NotUseFlag=$p(^INCI(Inci,2),"^",9)
	.;q:NotUseFlag="Y"
	.s GroupName="",GroupId=""
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s PUomId=$p(^INCI(Inci,3),"^",6)
	.q:(BUomId="")||(PUomId="")||'$d(^CT("UOM",BUomId))||'$d(^CT("UOM",PUomId))
	.s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
	.s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	.s PUomDesc=$p(^CT("UOM",PUomId),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.
	.s IncscId=$p(^INCI(Inci,2),"^",2)
	.q:IncscId=""
	.s IncscDesc=$p(^INC("SC",IncscId),"^",2)
	.
	.s InciRemarks=""
	.i $d(^INCI(Inci,"REM",1)) d
	..s InciRemarks=^INCI(Inci,"REM",1)
	.
	.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci)
	.s ManfId=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",3)
	.q:ManfId=""
	.;存储条件
	.s StoreCond=##class(web.DHCSTMHUI.ITMSTORECON).GetStoreCond(Inci)
	.s Info=$o(^DHCITMINFO(0,"INCI",Inci,0))
	.s StoreConId="", PbVendorId="",PbVendorDesc="",FirstDept="",STATUS=""
	.s:Info'="" StoreConId=$p(^DHCITMINFO(Info),"^",28)
	.s:Info'="" PbVendorId=$p(^DHCITMINFO(Info),"^",24)
	.s:PbVendorId'="" PbVendorDesc=$p($G(^APC("APCVM",PbVendorId)),"^",3)
	.s AliasStr=##class(web.DHCSTMHUI.INCALIAS).GetIncAlias(Inci)						;别名
	.s ScgId=$p(ScgInfo,"^",5)
	.s ScgDesc=$p(ScgInfo,"^",2)
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRpOld(Inci,+$H,BUomId,"")
	.s:Info'="" FirstDept=$p(^DHCITMINFO(Info),"^",99)
	.s ALGNAME=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(InciDesc)
	.s InciBaseDataDetail=##class(web.DHCSTMService.Lis.Model.BaseDataDetail).%New()
	.s InciBaseDataDetail.MATERIALID=Inci
	.s InciBaseDataDetail.MATERIALCODE=InciCode
	.s InciBaseDataDetail.MATERIALSTATUS=STATUS
	.s InciBaseDataDetail.MATERIALNAME=InciDesc
	.s InciBaseDataDetail.MATERIALGNAME=ALGNAME
	.s InciBaseDataDetail.MATERIALALIAS=AliasStr
	.s InciBaseDataDetail.MATERIALPACKSIZE=Spec
	.s InciBaseDataDetail.UNITID=PUomId
	.s InciBaseDataDetail.UNITNAME=PUomDesc
	.s InciBaseDataDetail.CATEGORYID=ScgId
	.s InciBaseDataDetail.CATEGORYNAME=ScgDesc
	.s InciBaseDataDetail.STORAGEMODEID=StoreConId
	.s InciBaseDataDetail.STORAGEMODEName=StoreCond
	.s InciBaseDataDetail.MANUFACTURERID=ManfId
	.s InciBaseDataDetail.MANUFACTURERNAME=ManfDesc
	.s InciBaseDataDetail.SUBPACKNO=UomFac
	.s InciBaseDataDetail.GROUPID=GroupId
	.s InciBaseDataDetail.GROUPNAME=GroupName
	.s InciBaseDataDetail.SUPPLIERID=PbVendorId
	.s InciBaseDataDetail.SUPPLIERNAME=PbVendorDesc
	.s InciBaseDataDetail.MATERIALPRICE=Rp
	.s InciBaseDataDetail.HOSID=HospId
	.s InciBaseDataDetail.DEPTID=FirstDept
	.s InciBaseDataDetail.BUNITID=BUomId
	.s InciBaseDataDetail.BUNITNAME=BUomDesc
	.d InciBaseData.ListBaseData.Insert(InciBaseDataDetail)
	.s Count=Count+1
	.i Count=200 d SynInciBaseData
	i Count>0 d SynInciBaseData
	q Ret
SynInciBaseData
	try{
		d InciBaseData.XMLExportToStream(InciStream)
		}catch{}
	zn "dhc-lisdata"
	;s ^tmpqsx("SynInciInfo")=InciStream.Read()
	s ResultInfo=##class(Service.RG.RGInterface).ReagBaseData(InciStream)
	;s ^tmpqsx("SynInciInfoRe")=ResultInfo
	i "^"_ResultInfo'["^"_"成功"_"^" s Ret=-998
	zn "dhc-app"
	d InciBaseData.ListBaseData.Clear()
	s Count=0
	q Ret
NameSpaceZT
	zn "dhc-app"
	q -999
}

/// Description:订单生成(延庆中医Ext版本用到)
/// CreatDate:	
/// Input:		
/// OutPut:		0:成功, <0:失败
/// w ##class(web.DHCSTMService.Lis.ServiceForLis).AcceptInPoInfoM("<OrderInfo><ORDERNO>ORD202005090001</ORDERNO><CHECKDATE>20200509</CHECKDATE><REAGENTGROUPID>LGA</REAGENTGROUPID><DEPARTMENTID>A</DEPARTMENTID><CREATORID>dhcc</CREATORID><OrderDetailList><OrderDetail><MATERIALID>2397</MATERIALID><QUANTITY>5</QUANTITY><SUBPACKNO>1</SUBPACKNO><SUPPLIERID>29</SUPPLIERID><REMARK></REMARK></OrderDetail></OrderDetailList></OrderInfo>")
ClassMethod AcceptInPoInfoM(Input As %GlobalCharacterStream, HospId = "") As %String
{
	q:##class(web.DHCSTMHUI.ServiceConfig).GetSerUseFlag("LIS",HospId)'="Y" 0
	
	q:Input="" ""
	//测试
	//s Data="<Request><RGOrderInfo><SourceSystem></SourceSystem><MessageID></MessageID><OrderListNo>ORD201804120011</OrderListNo><CTMASupplier>AM00014</CTMASupplier><DepCode>J</DepCode><DepDesc>物资材料库</DepDesc><UserCode>Demo</UserCode><UserDesc>Demo Group</UserDesc><Remarks>采购计划汇总生成</Remarks><OrderReagItemsList><OrderReagItem><MaterialCode>GZ00001x</MaterialCode><MaterialName>生物止血材料(可吸收止血膜)</MaterialName><MaterialSpec>III</MaterialSpec><MaterialUnit>片</MaterialUnit><MaterialQty>10</MaterialQty><BatchNum>3</BatchNum></OrderReagItem></OrderReagItemsList></RGOrderInfo></Request>"
	//Set Input=##class(%GlobalCharacterStream).%New()
	//d Input.Write(Data)
	Set $ZTrap = "ErrorHandle"
	s Ret=0
	s InPo="",LocDesc="",UserName="",VendorCode="",Vendor="",LocId="",User="",HospId="",Remarks=""
	Set reader = ##class(%XML.Reader).%New()
	s sc=reader.OpenStream(Input)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit $$$ERROR()
	k ^TMP("DHCSTM","web.DHCSTMService.Lis.ServiceForLis","AcceptInPoInfo")
	s OrderInfoObj=##class(web.DHCSTMService.Lis.Model.OrderInfo).%New()
	d OrderInfoObj.OrderDetailList.Clear()
	d reader.Correlate("OrderInfo","web.DHCSTMService.Lis.Model.OrderInfo")
	While reader.Next(.OrderInfoObj,.sc){
			s InPo=OrderInfoObj.ORDERNO
			s LocDesc=OrderInfoObj.DEPARTMENTID
			s CreateUserId=OrderInfoObj.CREATORID
			i LocDesc="" s Ret=-5
			s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
			s LocId=$o(^CTLOC(0,"Desc",LocDesc,""))
			//s LocId=82
			s UserName=OrderInfoObj.CREATORID
			s UserName=$$ALPHAUP^SSUTIL4(UserName)
			;s User=$o(^SSU("SSUSR",0,"SSUSR_Name",UserName,""))
			s User=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserName,""))
			i (LocId="")||(User="") s Ret=-1
			continue:Ret'=0
			s HospId=$p(^CTLOC(LocId),"^",22)
			s ReagentGroupId=OrderInfoObj.REAGENTGROUPID
			s CheckDate=OrderInfoObj.CHECKDATE
			s CmpFlag="N"
			s Remarks=CheckDate_"#"_InPo
			s Len=OrderInfoObj.OrderDetailList.Count()
			s ParamStr="^"_LocId_"^^"_HospId
			f i=1:1:Len
			{
				s OrderDetailListObj=OrderInfoObj.OrderDetailList.GetAt(i)
				s OrderDetailLen=OrderDetailListObj.OrderDetail.Count()
				f j=1:1:OrderDetailLen {
					s OrderDetailObj=OrderDetailListObj.OrderDetail.GetAt(j)
					;s InciCode=OrderDetailObj.MATERIALID
					//s InciCode=$$ALPHAUP^SSUTIL4(InciCode)
					;s Inci=$o(^INCI(0,"Code",InciCode,""))
					s Inci=OrderDetailObj.MATERIALID
					i Inci="" s Ret=-3
					q:Ret<0
					s InPoQty=OrderDetailObj.QUANTITY
					;s VendorCode=OrderDetailObj.SUPPLIERID
					;s VendorCode=$$ALPHAUP^SSUTIL4(VendorCode)
					;s Vendor=$o(^APC("APCVM",0,"APCVM_Code",VendorCode,""))
					s Vendor=OrderDetailObj.SUPPLIERID
					i Vendor="" s Ret=-2
					q:Ret<0
					s Info=$o(^DHCITMINFO(0,"INCI",Inci,0))
					s BUomId=$p(^INCI(Inci,1),"^",10)
    				s PurUomId=$p(^INCI(Inci,3),"^",6)
    				;i (BUomId'=Uom)&&(PurUomId'=Uom) s Ret=-5	;单位不一致
					s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetConfigRp(Inci,BUomId,##class(web.DHCSTM.INPO).%GetParameter("AppName"),ParamStr)
					s ReqQty=InPoQty
					s RemarkInfo=OrderDetailObj.REMARK
					s InPoData=Inci_"^"_Uom_"^"_Rp_"^"_InPoQty_"^"_ReqQty_"^"_SpecDesc_"^"_RemarkInfo
					s InpoTitle="InciId^UomId^Rp^PurQty^ReqQty^SpecDesc^Remark"
					s InPoData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(InPoData,InpoTitle)
					if (DetailData="") {
						s DetailData=InPoData
					} else {
						s DetailData=DetailData_","_InPoData
					}
				}
			}
	}
	q:Ret<0 Ret
	s MainData=$tr(MainData,$c(0),"")
	s MainTitle="Vendor^PoLoc^gUserId^StkScg^ReqLoc"
	s Main=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
	
	s DetailData=$tr(DetailData,$c(0),"")
	s Detail="["_DetailData_"]"
	ts
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s RtnObj=##class(web.DHCSTMHUI.INPO).Update(Main)
	i RtnObj.success<0 tro  q -10
	s MainId=RtnObj.rowid
	s RtnObj=##class(web.DHCSTMHUI.INPOItm).Save(MainId,Detail)
	i RtnObj.success<0 tro  q -11
	tc
	q 0
ErrorHandle
	s Ret="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
	Quit Ret
}

}

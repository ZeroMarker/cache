Import SQLUser

/// 物资公共接口
Class web.DHCSTMHUI.Interface Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	库存项信息（依据库存项id）
/// Creator:	lxt
/// CreateDate:	2021-08-26
/// Input:		Inci
/// Output:     object型(必须标注字段含义！！！！)
/// w ##class(web.DHCSTMHUI.Interface).GetInciObj("4452")
ClassMethod GetInciObj(Inci, HospId = "")
{
	n (Inci,HospId)
	s Obj={}
	q:(Inci="") Obj
	q:'$d(^INCI(Inci,1)) Obj
	
	/*-------------------------组织数据------------------------------------*/
	
	s Info=$o(^DHCITMINFO(0,"INCI",Inci,""))
	s InfoData=$g(^DHCITMINFO(Info))
	s InfoData1=$g(^DHCITMINFO(Info,1))
	
	s InciCode=$p(^INCI(Inci,1),"^",1)
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	/*单位*/
	s BUomId=$p(^INCI(Inci,1),"^",10)	;基本单位
	s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	s PUomId=$p(^INCI(Inci,3),"^",6)	;入库单位
	s PUomDesc=$p(^CT("UOM",PUomId),"^",2)
	s BPUomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
	
	s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,+$h,PUomId,HospId)
	s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(Inci,+$h,PUomId,HospId)
	s ifexitbatadjpricestr=##class(web.DHCSTMHUI.Common.PriceCommon).IfExitBatAdjprice(Inci,HospId)  ;判断库存项是否存在批次信息
	s ifexitbatadjprice=$p(ifexitbatadjpricestr,"^",1)
	s batflag=$p(ifexitbatadjpricestr,"^",2)  ;批次售价标志
	s incibid=$p(ifexitbatadjpricestr,"^",3)  ;库存项最后一个批次id
	if (batflag=1) d
	.if (ifexitbatadjprice'="Y")  d   ;无批次信息则取调价表中价格信息
	..s aspInfo=##class(web.DHCSTMHUI.INCITM).GetINCPrice(Inci,+$h,PUomId,"")
	..s Rp=$p(aspInfo,"^",1)
	..s Sp=$p(aspInfo,"^",2)
	
	s PbRp=$p(InfoData,"^",22)	//招标进价
	
	s PackUomId=$p(InfoData,"^",51)	//大包装单位
	s PackUomDesc=$s(+PackUomId'=0:$p($g(^CT("UOM",PackUomId)),"^",2),1:"")
	s PackUomFac=$p(InfoData,"^",52)	//系数
	
	/*定价类型*/
	s MarkTypeInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMarkType(Inci)
	s MarkTypeId=$p(MarkTypeInfo,"^",1)
	s MarkTypeDesc=$p(MarkTypeInfo,"^",2)
	
	/*分类*/	
	s IncscId=$p(^INCI(Inci,2),"^",2) //库存分类
	s IncscDesc=$s(IncscId'="":$p(^INC("SC",IncscId),"^",2),1:"")	
	
	s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	s ScgId=$p(ScgInfo,"^",5)		//类组
	s ScgDesc=$p(ScgInfo,"^",2)
	
	s BookCatInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBookCat(Inci)
	s BookCatId=$p(BookCatInfo,"^",1)	//账簿分类
	s BookCatDesc=$p(BookCatInfo,"^",3)
	
	s OfficialCatInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetOfficialCat(Inci)	
	s OfficialCatId=$p(OfficialCatInfo,"^",1) //68分类
	s OfficialCatDesc=$p(OfficialCatInfo,"^",3)
	
	s ClinicCatInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetClinicCat(Inci)
	s ClinicCatId=$p(ClinicCatInfo,"^",1)	//重点关注分类
	s ClinicCatDesc=$p(ClinicCatInfo,"^",3)
	
	s Supervision=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSupervision(Inci)	//器械管理类别
	
	s SCategoryId=$p(^INCI(Inci,2),"^",14)	//灭菌分类
	s SCategoryDesc=$s(SCategoryId'="":$p($g(^INC("SCAT",SCategoryId)),"^",1),1:"")

	
	s QualityLevId=$p(InfoData,"^",3) 	//质量层次
	s QualityLevDesc=$s(QualityLevId'="":$p($g(^DHCITMQL(QualityLevId)),"^",2),1:"")
	
	/*标志*/
	s NotUseFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetNotUseFlag(Inci)	//不可用标志
	s ChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(Inci)	//收费标志
	s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)	//高值标志
	s BatchCodeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBatchCodeFlag(Inci)	//批次码标志
	s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(Inci)	//跟台标志
	s PackChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPackChargeFlag(Inci)	//打包收费标志
	s ImplantationFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncImplantationMat(Inci)	//植入标志
	s ImpFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmImportFlag(Inci)	//进口标志
	s MonitorFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMonitorFlag(Inci)	//重点关注
	s NoLocReqFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncNoLocReq(Inci)	//禁止请领标志
	s ZeroStkFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetZeroStkFlag(Inci)	//零库存标志
	s MetringFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMetringflag(Inci)	//计量标志
	s BAFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBAFlag(Inci)	//一次性标志
	s CentralPurFlag=$p(InfoData1,"^",9)	//集采标志
	s:CentralPurFlag="" CentralPurFlag="N"
	s TemPurchase=$p(InfoData1,"^",17)	//临采标志
	s:TemPurchase="" TemPurchase="N"
	s InHosFlag=$p(InfoData,"^",21)	//本院物资目录标志
	s:InHosFlag="" InHosFlag="N"	
	
	/*招标信息*/
	s PbLevel=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmAddtionPbLevel(Inci)	//招标级别
	
	s PbLId=$p(InfoData,"^",23)	//招标名称
	s PbLDesc=$s(PbLId'="":$p($g(^DHCPBLIST(PbLId)),"^",2),1:"")
		
	s BidDate=$p(InfoData,"^",98)	//招标日期
	i BidDate'="" s BidDate=..DL2H(BidDate)	

	/*属性*/
	s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)	//规格
	s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)	//型号
	s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(Inci)	//品牌
	s Abbrev=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetAbbrev(Inci)	//简称
	s StanderCode=$p(InfoData,"^",44)	//本位码
	s XieHeCode=$p(^INCI(Inci,3),"^",11) 	//协和码
	s PrcFile=$p(InfoData,"^",33) //物价文件号	
	s PrcFileD=$p(InfoData,"^",34)	//物价备案日期
	s:PrcFileD'="" PrcFileD=..DL2H(PrcFileD)
	s ComFrom=$p(InfoData,"^",9)	//国(省)别
	s BarCode=$p(^INCI(Inci,3),"^",9)	//条码
	s ExpireLen=$p(InfoData,"^",32)	//效期长度(月)	
	s INFOSterile=$p(InfoData,"^",79)	//灭菌时间长度(天)
	s QualityNo=$p(InfoData,"^",8)	//质标编号	
	s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(Inci,HospId)
	s MatInsuCode=$p(MatInsuInfo,"^",1)	//国家医保编码
	s MatInsuDesc=$p(MatInsuInfo,"^",2)	//国家医保名称
	s Quality=$p(InfoData,"^",71)	//质地
	s StoreCond=##class(web.DHCSTMHUI.ITMSTORECON).GetStoreCond(Inci)	//存储条件	
	s INFOApplication=$p(InfoData1,"^",21)	//用途
	s INFOFunction=$p(InfoData1,"^",22)	//功能
	s EquAssCode=$p(InfoData1,"^",37)	//装备协会编码
	s Remarks=""
	i $d(^INCI(Inci,"REM",1))  d
	.s Remarks=^INCI(Inci,"REM",1)		//备注

	s OriginId=$p(InfoData,"^",100)	//产地
	s OriginDesc=$s(OriginId'="":$p($g(^DHCSTORI(OriginId)),"^",2),1:"")
	
	s ReqType=$p(InfoData,"^",73)	//请求类型
	i ReqType="O" s ReqType="临时请求"
	e  s ReqType="申请计划"
		
	s InciEndDate=$p(InfoData,"^",113)	//停用日期
	s:InciEndDate'="" InciEndDate=..DL2H(InciEndDate)
	
	s SupLocId=$p(^INCI(Inci,2),"^",1)	//供给科室
	s SupLocDesc=$s(SupLocId'="":$p($g(^CTLOC(SupLocId)),"^",2),1:"")	

	s FirstReqLocId=$p(InfoData,"^",99)	//首请科室
	s FirstReqLocDesc=$s(FirstReqLocId'="":$p($g(^CTLOC(FirstReqLocId)),"^",2),1:"")
	
	/*合同信息*/
	s ContractObj=##class(web.DHCSTMHUI.DHCConTrackManager).GetContByInci(Inci)
	s ContractNo=ContractObj.ContractNo
	s ConStartDate=ContractObj.ConStartDate
	s:ConStartDate'="" ConStartDate=..DL2H(ConStartDate)
	s ConEndDate=ContractObj.ConEndDate
	s:ConEndDate'="" ConEndDate=..DL2H(ConEndDate)
	
	/*生产厂家*/
	s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci)
	s ManfId=$p(ManfInfo,"^",1)
	s ManfCode=$p(ManfInfo,"^",2)
	s ManfDesc=$p(ManfInfo,"^",3)
	
	/*供应商*/
	s VendorInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(Inci)
	s VendorId=$p(VendorInfo,"^",1)
	s VendorCode=$p(VendorInfo,"^",3)
	s VendorDesc=$p(VendorInfo,"^",2)
	
	/*配送商*/
	s CarrierInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbCarrier(Inci)
	s CarrierId=$p(CarrierInfo,"^",1)
	s CarrierDesc=$p(CarrierInfo,"^",2)
	s CarrierTel=$p(CarrierInfo,"^",3)
	
	/*注册证*/
	s CertInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(Inci)
	s CertNo=$p(CertInfo,"^",1)			;注册证号
	s CertExpDate=$p(CertInfo,"^",2)			;注册证效期
	s CertDesc=$p(CertInfo,"^",3)		;注册证名称
	s CertCountry=$p(CertInfo,"^",10)	;注册证生产国家
	S CertApprovalDate=$p(CertInfo,"^",22)	;注册证批准日期
	
	/*挂网信息*/
	s HOOKNetPrice=$p(InfoData,"^",43)	//挂网价格
	s OTC=$p(InfoData,"^",5)			//挂网ID
	s PurCode=$p(InfoData,"^",56)		//挂网商品代码
	s SunPurTypeId=$p(InfoData1,"^",49)	//采购类型
	s SunPurType=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetDictValDesc("SunPur",SunPurTypeId)
	s SpeFlag=$p(InfoData,"^",76)		//阳光采购标志
	
	/*中标信息*/
	s PbNo=$p(InfoData,"^",63)			//中标编号
	s PbDate=$p(InfoData,"^",98)		//中标日期
	s PbFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmPbFlag(Inci)	//中标标记
	/*-------------------------返回数据------------------------------------*/
	/*！！！必须标注字段含义！！！*/
	s Obj.InciCode=InciCode						//物资代码
	s Obj.InciDesc=InciDesc						//物资名称
	s Obj.BUomId=BUomId							//基本单位id
	s Obj.BUomDesc=BUomDesc						//基本单位
	s Obj.PUomId=PUomId							//入库单位id
	s Obj.PUomDesc=PUomDesc						//入库单位
	s Obj.BPUomFac=BPUomFac						//基本单位与入库单位转化系数
	s Obj.Sp=Sp									//售价
	s Obj.Rp=Rp									//进价
	s Obj.PbRp=PbRp								//招标进价
	s Obj.PackUomId=PackUomId					//大包装单位id
	s Obj.PackUomDesc=PackUomDesc				//大包装单位
	s Obj.PackUomFac=PackUomFac					//大包装单位系数
	s Obj.MarkTypeId=MarkTypeId					//定价类型id
	s Obj.MarkTypeDesc=MarkTypeDesc				//定价类型

	s Obj.IncscId=IncscId						//库存分类id
	s Obj.IncscDesc=IncscDesc					//库存分类
	s Obj.ScgId=ScgId							//类组id
	s Obj.ScgDesc=ScgDesc						//类组
	s Obj.BookCatId=BookCatId					//账簿分类id
	s Obj.BookCatDesc=BookCatDesc				//账簿分类
	s Obj.OfficialCatId=OfficialCatId			//68分类id
	s Obj.OfficialCatDesc=OfficialCatDesc		//68分类
	s Obj.ClinicCatId=ClinicCatId				//重点关注分类id
	s Obj.ClinicCatDesc=ClinicCatDesc			//重点关注分类
	s Obj.Supervision=Supervision				//器械管理类别
	s Obj.SCategoryId=SCategoryId				//灭菌分类id
	s Obj.SCategoryDesc=SCategoryDesc			//灭菌分类
	s Obj.QualityLevId=QualityLevId				//质量层次id
	s Obj.QualityLevDesc=QualityLevDesc			//质量层次

	s Obj.NotUseFlag=NotUseFlag					//不可用标志
	s Obj.ChargeFlag=ChargeFlag					//收费标志
	s Obj.HVFlag=HVFlag							//高值标志
	s Obj.BatchCodeFlag=BatchCodeFlag			//批次码标志
	s Obj.TableFlag=TableFlag					//跟台标志
	s Obj.PackChargeFlag=PackChargeFlag			//打包收费标志
	s Obj.ImplantationFlag=ImplantationFlag		//植入标志
	s Obj.ImpFlag=ImpFlag						//进口标志
	s Obj.MonitorFlag=MonitorFlag				//重点关注
	s Obj.NoLocReqFlag=NoLocReqFlag				//禁止请领标志
	s Obj.ZeroStkFlag=ZeroStkFlag				//零库存标志
	s Obj.MetringFlag=MetringFlag				//计量标志
	s Obj.BAFlag=BAFlag							//一次性标志
	s Obj.CentralPurFlag=CentralPurFlag			//集采标志
	s Obj.TemPurchase=TemPurchase				//临采标志
	s Obj.InHosFlag=InHosFlag					//本院物资目录标志

	
	s Obj.PbLevel=PbLevel						//招标级别
	s Obj.PbLId=PbLId							//招标名称id
	s Obj.PbLDesc=PbLDesc						//招标名称
	s Obj.BidDate=BidDate						//招标日期

	s Obj.Spec=Spec								//规格
	s Obj.Model=Model							//型号
	s Obj.Brand=Brand							//品牌
	s Obj.Abbrev=Abbrev							//简称
	s Obj.StanderCode=StanderCode				//本位码
	s Obj.XieHeCode=XieHeCode					//协和码
	s Obj.PrcFile=PrcFile						//物价文件号
	s Obj.PrcFileD=PrcFileD						//物价备案日期
	s Obj.ComFrom=ComFrom						//国(省)别
	s Obj.BarCode=BarCode						//条码
	s Obj.ExpireLen=ExpireLen					//效期长度(月)
	s Obj.INFOSterile=INFOSterile				//灭菌时间长度(天)
	s Obj.QualityNo=QualityNo					//质标编号
	s Obj.MatInsuCode=MatInsuCode				//国家医保编码
	s Obj.MatInsuDesc=MatInsuDesc				//国家医保名称
	s Obj.Quality=Quality						//质地
	s Obj.StoreCond=StoreCond					//存储条件	
	s Obj.INFOApplication=INFOApplication		//用途
	s Obj.INFOFunction=INFOFunction				//功能
	s Obj.OriginId=OriginId						//产地id
	s Obj.OriginDesc=OriginDesc					//产地
	s Obj.ReqType=ReqType						//请求类型
	s Obj.InciEndDate=InciEndDate				//停用日期
	s Obj.SupLocId=SupLocId						//供给科室id
	s Obj.SupLocDesc=SupLocDesc					//供给科室
	s Obj.FirstReqLocId=FirstReqLocId			//首请科室id
	s Obj.FirstReqLocDesc=FirstReqLocDesc		//首请科室
	s Obj.EquAssCode=EquAssCode					//装备协会编码
	s Obj.Remarks=Remarks						//备注

	s Obj.ContractNo=ContractNo					//合同号
	s Obj.ConStartDate=ConStartDate				//合同开始日期	
	s Obj.ConEndDate=ConEndDate					//合同结束日期

	s Obj.ManfId=ManfId							//生产厂家id
	s Obj.ManfCode=ManfCode						//生产厂家代码
	s Obj.ManfDesc=ManfDesc						//生产厂家名称

	s Obj.VendorId=VendorId						//供应商id
	s Obj.VendorCode=VendorCode					//供应商代码
	s Obj.VendorDesc=VendorDesc					//供应商名称

	s Obj.CarrierId=CarrierId					//配送商id
	s Obj.CarrierDesc=CarrierDesc				//配送商名称
	s Obj.CarrierTel=CarrierTel					//配送商电话

	s Obj.CertNo=CertNo							//注册证号
	s Obj.CertExpDate=CertExpDate				//注册证效期
	s Obj.CertDesc=CertDesc						//注册证名称
	s Obj.CertCountry=CertCountry				//注册证生产国家
	s Obj.CertApprovalDate=CertApprovalDate		//注册证批准日期
	
	s Obj.HOOKNetPrice=HOOKNetPrice				//挂网价格
	s Obj.OTC=OTC								//挂网ID
	s Obj.PurCode=PurCode						//挂网商品代码(阳光采购编码)
	s Obj.SunPurType=SunPurType					//采购类型
	s Obj.SpeFlag=SpeFlag						//阳光采购标志
	
	s Obj.PbFlag=PbFlag							//中标标记
	s Obj.PbNo=PbNo								//中标编号
	s Obj.PbDate=PbDate							//中标日期
	
	/*！！！必须标注字段含义！！！*/
	/*-------------------------返回数据------------------------------------*/
	
	
	q Obj
}

/// Descript:	库存项信息（依据医嘱项id）
/// Creator:	lxt
/// CreateDate:	2021-08-26
/// Input:		ArcimId
/// w ##class(web.DHCSTMHUI.Interface).GetInciObjByArc("11814||1","2")
ClassMethod GetInciObjByArc(ArcimId, HospId = "")
{
	n (ArcimId,HospId)
	s Obj={}
	q:(ArcimId="") Obj
	
	s Arc=$p(ArcimId,"||",1)
	s Inci=$o(^INCI(0,"ARCIM_DR",Arc,""))
	q:(Inci="")||'$d(^INCI(Inci,1)) Obj
	
	s Obj=..GetInciObj(Inci,HospId)
	q Obj
}

/// Descript:	库存项信息（依据计费项id）
/// Creator:	lxt
/// CreateDate:	2021-08-26
/// Input:		TarItemId
ClassMethod GetInciObjByTar(TarItemId, HospId = "")
{
	n (TarItemId,HospId)
	s Obj={}
	q:(TarItemId="") Obj
	
	s Date=+$h
	s StartDate="",Inci=""
	f  s StartDate=$o(^DHCOLT(0,"TAR",TarItemId,StartDate),-1) q:(StartDate="")||(Inci'="")  d
	.s OltId=""
	.f  s OltId=$o(^DHCOLT(0,"TAR",TarItemId,StartDate,OltId),-1) q:(OltId="")||(Inci'="")  d
	..s OltInfo=^DHCOLT(OltId)
	..s ArcimId=$p(OltInfo,"^",1)
	..s EndDate=$p(OltInfo,"^",5)
	..q:(EndDate'="")&&(EndDate<Date)
	..s Arc=$p(ArcimId,"||",1)
	..q:Arc=""
	..s Inci=$o(^INCI(0,"ARCIM_DR",Arc,""))
	q:(Inci="")||'$d(^INCI(Inci,1)) Obj
	
	s Obj=..GetInciObj(Inci,HospId)
	q Obj
}

}

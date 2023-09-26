Import sqluser

/// Descript:	同第三方物资管理软件间的库存同步类
/// Creator:	wangjiabin
/// CreateDate:	20191223
Class web.DHCSTMService.HRP.In2OutServiceImpl Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Description:返回默认错误信息
/// Input:	状态值1,错误信息
/// Output:		
/// Return:	{RetCode:"状态值",RetContent:"结果信息"}	
/// w ##class(web.DHCSTMService.HRP.In2OutServiceImpl).OutResultxml("1","2")
ClassMethod OutResultxml(RetCode As %String, RetContent As %String) As %GlobalCharacterStream
{
	n (RetCode,RetContent)
	s OutResultObj=##class(web.DHCSTMService.HRP.Model.OperateResult).%New()
	s OutResultObj.ResultCode=RetCode
	s OutResultObj.ResultContent=RetContent
	s Stream=##class(%GlobalCharacterStream).%New() 
	d OutResultObj.XMLExportToStream(Stream)
	q Stream
}

/// Descript: 与HRP交互接口
/// Creater:  lihui
/// CreateDate:	20191223
/// Input: Input(XML对象流),OperateCode(业务类型：(Disp:开医嘱；Return:撤销作废医嘱...)
/// Output: 
/// Return:		[0:"",1:失败信息]
/// Debug: 		w ##class(web.DHCSTMService.HRP.In2OutServiceImpl).HRPinterface("SaveInciData",^TMPHOUSC("fdafdafdftest","test"))
ClassMethod HRPinterface(OperateCode As %String, Input, HospitalCode) As %GlobalCharacterStream
{
	New (OperateCode,Input,HospitalCode)
	s HospId=##class(web.DHCSTMService.HRP.CommonInfo).ComHosp(HospitalCode)
	i HospId="" q ..OutResultxml(0,"医院代码错误")
	s UseFlag=##class(web.DHCSTMHUI.ServiceConfig).GetSerUseFlag("HRP",HospId)
	i UseFlag'="Y" q ..OutResultxml(0,"接口未启用")
	s SerTypeId=$p(^DHCSTM("ServiceConfig","HRP"_HospId),"^",4)
	s RetStream=##class(%GlobalCharacterStream).%New()
	i OperateCode="" q ..OutResultxml(1,"业务不明,操作有误")
	s InputStream=##class(%GlobalCharacterStream).%New()
	i '$ISOBJECT(Input) d
	.d InputStream.Write(Input)
	e  d
	.d InputStream.CopyFrom(Input)
	d InputStream.Rewind()
	s paramxml=InputStream.Read()
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogId,"",SerTypeId,$ZNAME,OperateCode,paramxml)
	If (OperateCode="SaveAdj") d
	.;同步库存
	.s RetStream=..SaveAdj(Input)
	If (OperateCode="SaveInciData") d
	.;库存项信息
	.s RetStream=..SaveData(Input)
	If (OperateCode="SynPriceData") d
	.;调价
	.s RetStream=..SynPriceData(Input)
	If (OperateCode="SynPriceDataBatch") d
	.;批次调价
	.s RetStream=..SynPriceDataBatch(Input)
	If (OperateCode="SynIncscData") d
	.;同步库存分类
	.s RetStream=..SynIncscData(Input)
	If (OperateCode="SaveVendorData") d
	.;同步供应商
	.s RetStream=..SaveVendorData(Input)
	If (OperateCode="SaveManfData") d
	.;同步生产厂家
	.s RetStream=..SaveManfData(Input)
	If (OperateCode="SaveInGdRec") d
	.;同步入库
	.s RetStream=..SaveInGdRec(Input)
	If (OperateCode="SaveInIsTrf") d
	.;同步出库
	.s RetStream=..SaveInIsTrf(Input)
	If (OperateCode="UpdateInvno") d
	.;同步发票
	.s RetStream=..UpdateInvno(Input)
	If (OperateCode="SaveStock") d
	.;同步库存到具体数量
	.s RetStream=..SaveStock(Input)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogId,RetStream.Read(),SerTypeId,$ZNAME,OperateCode,"")
	Quit RetStream
}

/// w ##class(web.DHCSTMService.HRP.In2OutServiceImpl).SaveAdj(^tmphouscxc)
///  w ##class(web.DHCSTMService.HRP.In2OutServiceImpl).SaveAdj("<LocAdjBills><LocAdjBill><Type>06</Type><Remarks></Remarks><LocDesc>CT室</LocDesc><UserInital></UserInital><LocAdjBillItem><InciCode>SDSL0710002</InciCode><Uom>张</Uom><ExpDate>2023-04-03 00:00:00.0</ExpDate><BarCode>000000010835</BarCode><Qty>1</Qty><ItmRemarks></ItmRemarks><BatchNo>E3971633</BatchNo><billNo>DB-20200800260</billNo><Sp>18050</Sp><Rp>18050</Rp><BatId>85|30052|E3971633|2|000000010835|18050</BatId></LocAdjBillItem></LocAdjBill></LocAdjBills>")
ClassMethod SaveAdj(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	n (Input)
	s RetStream=##class(%GlobalCharacterStream).%New()
	s Pid=$i(^DHCSTMPID("PID"))
	k ^TMPDHCSTM("TMPDHCSTM",Pid),^TMPDHCSTM("TMPDHCSTMERR",Pid)
	s InputStream=##class(%GlobalCharacterStream).%New()
	i '$ISOBJECT(Input) d
	.d InputStream.Write(Input)
	e  d
	.d InputStream.CopyFrom(Input)
	d InputStream.Rewind()
	s ErrorMsg=""
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(InputStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) q ..OutResultxml(1,"入参解析有误")
	d reader.Correlate("LocAdjBills","web.DHCSTMService.HRP.Model.LocAdjBills")
	s LocAdjBillsObj=##class(web.DHCSTMService.HRP.Model.LocAdjBills).%New()
	s LocAdjBillsRetObj=##class(web.DHCSTMService.HRP.Model.LocAdjBills).%New()
	while reader.Next(.LocAdjBillsObj,.sc){
		s LocAdjBillsRetObj=LocAdjBillsObj
	}
	s LocAdjBillsCount=LocAdjBillsRetObj.BillList.Count()
	q:LocAdjBillsCount=0 ..OutResultxml(-1,"参数错误!")
	f BillSub=1:1:LocAdjBillsCount  d
	.s LocAdjBillObj=##class(web.DHCSTMService.HRP.Model.LocAdjBill).%New()
	.s LocAdjBillObj=LocAdjBillsRetObj.BillList.GetAt(BillSub)
	.s LocDesc=LocAdjBillObj.LocDesc
	.s Remarks=LocAdjBillObj.Remarks
	.s UserInital=LocAdjBillObj.UserInital
	.s type=LocAdjBillObj.Type
	.s ErrMsg=""
	.i Remarks'="" d
	..s existrowid=""
	..&sql(SELECT TOP 1 INAD_RowId into :existrowid FROM DHC_INAdj WHERE INAD_Remarks=:Remarks)
	..i existrowid'=""  d
	...s ErrMsg="第"_BillSub_"张单据重复推送!"
	...d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s LocId=##class(web.DHCSTMService.HRP.CommonInfo).ComLoc(LocDesc)
	.i LocId="" d
	..s ErrMsg="第"_BillSub_"张单据,科室为空!"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s ItemCount=LocAdjBillObj.BillItemList.Count()
	.i ItemCount=0 d
	..s ErrMsg="第"_BillSub_"张单据,单据明细为空!"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s UserId=##class(web.DHCSTMService.HRP.CommonInfo).ComUser(UserInital)
	.s ScgId="",Comp="Y",State="10"
	.s AdjReason="同步库存"
	.s ReasonId=##class(web.DHCSTMService.HRP.CommonInfo).GetAdjReason(AdjReason)
	.s StkType="M"
	.s MainInfo=""
	.s $p(MainInfo,"^",1)=LocId
	.s $p(MainInfo,"^",2)=UserId
	.s $p(MainInfo,"^",3)=ReasonId
	.s $p(MainInfo,"^",4)=ScgId
	.s $p(MainInfo,"^",5)=Comp
	.s $p(MainInfo,"^",7)=State
	.s $p(MainInfo,"^",8)=Remarks
	.s mainTitle="AdjLoc^gUserId^ForAdjustReasonId^ScgStk^Complate^adjState^Remark"
	.s mainDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(MainInfo,mainTitle)
	.s ^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)=mainDataObj_"^"_LocDesc
	.s succount=0,msg=""
	.f DetailSub=1:1:ItemCount d
	..s ItemObj=##class(web.DHCSTMService.HRP.Model.LocAdjBillItem).%New()
	..s ItemObj=LocAdjBillObj.BillItemList.GetAt(DetailSub)
	..s BatId=ItemObj.BatId
	..s InciCode=ItemObj.InciCode
	..s Inci=##class(web.DHCSTMService.HRP.CommonInfo).ComInci(InciCode)
	..i +Inci'>0 d
	...s ErrMsg="物资不存在系统中,InciCode:"_InciCode 
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:Inci=""
	..s hvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..s BatchNo=ItemObj.BatchNo
	..s ExpDate=ItemObj.ExpDate
	..s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	..s Rp=ItemObj.Rp
	..s Sp=ItemObj.Sp
	..s Qty=ItemObj.Qty
	..s BarCode=ItemObj.BarCode
	..s Uom=ItemObj.Uom
	..s UomId=##class(web.DHCSTMService.HRP.CommonInfo).ComUom(Uom)
	..i UomId="" d
	...s ErrMsg=Uom_"单位不存在系统中,InciCode:"_InciCode 
	...d ..RecordErrInfo(Pid,ErrMsg)
	..s buomid=$p(^INCI(Inci,1),"^",10)
	..s puomid=$p(^INCI(Inci,3),"^",6)
	..i (UomId'=puomid)&&(buomid'=UomId) d
	...s ErrMsg=Uom_"不是物资关联单位,InciCode:"_InciCode 
	...d ..RecordErrInfo(Pid,ErrMsg)
	..s PFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,buomid)
	..s buomRp=Rp/PFac
	..i ((BarCode'="")&&((Qty'=1)&&(Qty'=-1))) d
	...s ErrMsg="高值条码数量不对应,InciCode:"_InciCode 
	...d ..RecordErrInfo(Pid,ErrMsg)
	..i BarCode'="" d
	...s trackid=$o(^DHCIT(0,"ORIGINALCODE",BarCode,""))
	...s:trackid="" trackid=$o(^DHCIT(0,"LABEL",BarCode,""))
	...i (trackid'="")&&(Qty>0) d
	....s dhcitdetailch=$O(^DHCITD(trackid,"I",""),-1)
	....i dhcitdetailch'="" d
	.....s pointer=$p(^DHCITD(trackid,"I",dhcitdetailch),"^",1)
	.....s hvtye=$p(^DHCITD(trackid,"I",dhcitdetailch),"^",2)    
	.....i (hvtye="P")||(hvtye="F")||(hvtye="MF")||(hvtye="MP") d
	......s ErrMsg="高值条码已使用,InciCode:"_InciCode 
	.....i hvtye="A" d
	......s adjQty=$P(^DHCINAD(+pointer,"ADI",$p(pointer,"||",2)),"^",2)
	......i adjQty=1 d
	.......s ErrMsg="高值条码已存在,InciCode:"_InciCode 
	.....d ..RecordErrInfo(Pid,ErrMsg)
	...i (trackid="")&&(Qty<0) d
	....s ErrMsg="高值条码不存在不能减少库存,InciCode:"_InciCode 
	....d ..RecordErrInfo(Pid,ErrMsg)
	..s Paramstr=BatId_"^"_InciCode_"^"_LocId_"^"_ExpDate_"^"_BatchNo_"^"_buomRp_"^"_buomRp
	..s succount=succount+1
	..s DetailData=Paramstr_"^"_Qty_"^"_UomId_"^"_Rp_"^"_Sp_"^"_BarCode_"^"_UserId
	..s ^TMPDHCSTM("TMPDHCSTM",Pid,BillSub,DetailSub)=DetailData
	q:succount=0 ..OutResultxml(0,"参数为空,请核实数据！")
	s retInfo=..GetErrMsg(Pid)
	i retInfo'="" d
	.k ^TMPDHCSTM("TMPDHCSTM",Pid)
	q:retInfo'="" ..OutResultxml(0,retInfo)
	ts
	s Err=""
	s BillSub=0
	f  s BillSub=$o(^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)) q:(BillSub="")||(Err'="")  d
	.s MainInfo=^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)
	.s MainObj=$p(MainInfo,"^",1)
	.s LocDesc=$p(MainInfo,"^",2)
	.s DetailSub=0,DetailObjStr=""
	.f  s DetailSub=$o(^TMPDHCSTM("TMPDHCSTM",Pid,BillSub,DetailSub)) q:(DetailSub="")||(Err'="")  d
	..s DetailData=^TMPDHCSTM("TMPDHCSTM",Pid,BillSub,DetailSub)
	..s BatId=$P(DetailData,"^",1)
	..s InciCode=$P(DetailData,"^",2)
	..s LocId=$P(DetailData,"^",3)
	..s ExpDate=$P(DetailData,"^",4)
	..s BatchNo=$P(DetailData,"^",5)
	..s buomRp=$P(DetailData,"^",6)
	..s buomRp=$P(DetailData,"^",7)
	..s Qty=$P(DetailData,"^",8)
	..s UomId=$P(DetailData,"^",9)
	..s Rp=$P(DetailData,"^",10)
	..s Sp=$P(DetailData,"^",11)
	..s BarCode=$P(DetailData,"^",12)
	..s UserId=$P(DetailData,"^",13)
	..s Paramstr=BatId_"^"_InciCode_"^"_LocId_"^"_ExpDate_"^"_BatchNo_"^"_buomRp_"^"_buomRp
	..s incib=..GetIncib(Paramstr,"")
	..i +incib<0 d
	...s Err="代码:"_InciCode_",生成批次失败!"
	..q:Err'=""
	..s Inclb=..GetINCLB(incib,LocId)
	..i +Inclb<0 d
	...s Err="代码:"_InciCode_",生成批次失败!"
	..q:Err'=""
	..s ret=0
	..i BarCode'="" d
	...s ret=..HandleBarcode(Inclb,BarCode,UserId,Qty)
	..i ret=-3 s Err="条码重复,InciCode:"_InciCode 
	..i ret'=0 s Err="条码处理失败,InciCode:"_InciCode 
	..q:Err'=""
	..s DetailTitle="Inclb^Qty^UomId^Rp^Sp^HvBarCode"
	..s realDetailData=Inclb_"^"_Qty_"^"_UomId_"^"_Rp_"^"_Sp_"^"_BarCode
	..s DetailObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(realDetailData,DetailTitle)
	..i DetailObjStr="" d
	...s DetailObjStr=DetailObj
	..e  d
	...s DetailObjStr=DetailObjStr_","_DetailObj
	.s DetailObjStr="["_DetailObjStr_"]"
	.q:Err'=""
	.s retInAdj=##class(web.DHCSTMHUI.DHCINAdj).SaveAdj(MainObj,DetailObjStr)
	.s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	.s Sc=PJObj.%FromJSON(retInAdj)
	.i PJObj.%Get("success")'=0 d 
	..s Err="科室:"_LocDesc_",库存同步失败!"
	..;d ..RecordErrInfo(Pid,Err)
	.q:Err'=""
	.s InAdj=PJObj.%Get("rowid")
	.s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	.s ParamData=UserId
	.s ParamTitle="gUserId"
	.s ParamObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(ParamData,ParamTitle)
	.s RtnObj=##class(web.DHCSTMHUI.DHCINAdj).Audit(InAdj,ParamObj)
	.i RtnObj.success'=0 d
	..s Err="科室:"_LocDesc_",库存审核失败!"_RtnObj.msg
	.q:Err'=""
	.s rt=..UpdateItmTrackOrAdjPrice(InAdj)
	.i rt'=0 d
	..s Err="科室:"_LocDesc_",库存调价失败失败!"
	.q:Err'=""
	k ^TMPDHCSTM("TMPDHCSTM",Pid)
	i Err'="" tro  
	q:Err'="" ..OutResultxml(0,Err)
	tc
	q ..OutResultxml(0,"成功")
}

/// Descript:	同步基础数据
/// Creator:	lihui
/// CreateDate:	20191224
/// Input:	[{},{}]	
/// Return:	[0:"",1:失败信息]
/// w ##class(web.DHCSTMService.HRP.In2OutServiceImpl).SaveInciData("<INCIDataList><INCIData><HVFlag>N</HVFlag><IncscDesc>卫生材料类</IncscDesc><InciCode>012600000002</InciCode><PUom>根</PUom><LocDesc>全科医疗科门诊</LocDesc><InciDesc>his字典测试普通收费2</InciDesc><BUom>根</BUom><ChargeFlag>Y</ChargeFlag><HospitalCode>DHSZHYYZY</HospitalCode><UserInitial>demo</UserInitial><Model>2w</Model><TableFlag>N</TableFlag></INCIData></INCIDataList>")
ClassMethod SaveInciData(Input) As %GlobalCharacterStream
{
	n (Input)
	;s Input="<INCIDataList><INCIData><LocDesc>物资材料库</LocDesc><HospitalCode>DHSZHYYZY</HospitalCode><InciCode>物资代码1</InciCode><InciDesc>物资名称1</InciDesc><BUom>个</BUom><PUom>个</PUom><PFac>1</PFac><IncscDesc>高值材料</IncscDesc><Sp>1</Sp><Rp>1</Rp><Spec>规格</Spec><RegCertNo>注册证号</RegCertNo><RegCertExpDate>2029-09-09</RegCertExpDate><TableFlag>Y</TableFlag><HVFlag>Y</HVFlag><PbVendor>江苏润辉康尔医疗器械有限公司</PbVendor><Manf>北京</Manf><Brand>品牌</Brand><Model>型号</Model><ChargeFlag>Y</ChargeFlag><UserInitial>wz01</UserInitial><Abbrev>简称</Abbrev></INCIData><INCIData><HospitalCode>DHSZHYYZY</HospitalCode><LocDesc>物资材料库</LocDesc><InciCode>物资代码2</InciCode><InciDesc>物资名称2</InciDesc><BUom>个</BUom><PUom>个</PUom><PFac>1</PFac><IncscDesc>高值材料</IncscDesc><Sp>1</Sp><Rp>1</Rp><Spec>规格</Spec><RegCertNo>注册证号</RegCertNo><RegCertExpDate>2028-09-09</RegCertExpDate><TableFlag>Y</TableFlag><HVFlag>Y</HVFlag><PbVendor>新疆博泰晟达商贸</PbVendor><Manf>上海</Manf><Brand>品牌</Brand><Model>型号</Model><ChargeFlag>Y</ChargeFlag><UserInitial>wz01</UserInitial><Abbrev>简称</Abbrev></INCIData></INCIDataList>"
	s InputStream=##class(%GlobalCharacterStream).%New()
	i '$ISOBJECT(Input) d
	.d InputStream.Write(Input)
	e  d
	.d InputStream.CopyFrom(Input)
	d InputStream.Rewind()
	s Pid=$i(^DHCSTMPID("PID"))
	k ^TMPDHCSTM("TMPDHCSTMERR",Pid)
	s RetStream=##class(%GlobalCharacterStream).%New()
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(InputStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) q ..OutResultxml(1,"入参解析有误")
	d reader.Correlate("INCIDataList","web.DHCSTMService.HRP.Model.INCIDataList")
	s ListObj=##class(web.DHCSTMService.HRP.Model.INCIDataList).%New()
	s ListAllObj=##class(web.DHCSTMService.HRP.Model.INCIDataList).%New()
	while reader.Next(.ListObj,.sc){
		s ListAllObj=ListObj
	}
	s successcount=0
	s ItmCount=ListAllObj.INCIData.Count()
	f i=1:1:ItmCount  d
	.s ErrMsg=""
	.s INCIDataObj=##class(web.DHCSTMService.HRP.Model.INCIData).%New()
	.s INCIDataObj=ListAllObj.INCIData.GetAt(i)
	.s HospitalCode=INCIDataObj.HospitalCode
	.s InciCode=INCIDataObj.InciCode
	.s InciDesc=INCIDataObj.InciDesc
	.s PFac=INCIDataObj.PFac
	.s BUom=INCIDataObj.BUom
	.s PUom=INCIDataObj.PUom
	.s IncscDesc=INCIDataObj.IncscDesc
	.s UserInitial=INCIDataObj.UserInitial
	.s Sp=INCIDataObj.Sp
	.s Rp=INCIDataObj.Rp
	.s Spec=INCIDataObj.Spec
	.s HVFlag=INCIDataObj.HVFlag
	.s RegCertNo=INCIDataObj.RegCertNo
	.s RegCertExpDate=INCIDataObj.RegCertExpDate
	.s PbVendor=INCIDataObj.PbVendor
	.s Manf=INCIDataObj.Manf
	.s Brand=INCIDataObj.Brand
	.s Model=INCIDataObj.Model
	.s ChargeFlag=INCIDataObj.ChargeFlag
	.s Abbrev=INCIDataObj.Abbrev
	.s ImpFlag=INCIDataObj.ImpFlag
	.s useflag=INCIDataObj.OperationState
	.i useflag="D" d
	..s useflag="Y"
	.e  d
	..s useflag="N"
	.s ArcimId=INCIDataObj.ArcimId
	.s NotUseFlag=useflag
	.s TableFlag=INCIDataObj.TableFlag
	.s LocDesc=INCIDataObj.LocDesc
	.s HospId=##class(web.DHCSTMService.HRP.CommonInfo).ComHosp(HospitalCode)
	.i (HospitalCode="")||(HospId="")
	..s ErrMsg="第"_i_"条医院编码为空"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i InciCode="" d
	..s ErrMsg="第"_i_"条代码为空"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i InciDesc="" d
	..s ErrMsg="第"_i_"条名称为空"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s BUomDr=##class(web.DHCSTMHUI.Tools.CodeInput).validUom(BUom)
	.i BUomDr="" d
	..s ErrMsg="第"_i_"条小单位为空,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s PUomDr=##class(web.DHCSTMHUI.Tools.CodeInput).validUom(PUom)
	.i PUomDr="" d
	..s ErrMsg="第"_i_"条包装单位为空,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s Factor=##class(web.DHCSTMHUI.Tools.CodeInput).validConFac(PUomDr,BUomDr,PFac)
	.i Factor="" d
	..s ErrMsg="第"_i_"条单位没有换算关系,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s IncscDesc=$$ALPHAUP^SSUTIL4(IncscDesc)
	.i IncscDesc="" d
	..s ErrMsg="第"_i_"条分类为空,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s IncscDr=##class(web.DHCSTMService.HRP.CommonInfo).ComStkCat(IncscDesc)
	.;s IncscDr=$o(^INC("SC",0,"Desc",IncscDesc,""))
	.i IncscDr="" d
	..s ErrMsg="第"_i_"条"_IncscDesc_"分类在物资系统不存在,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i (HVFlag'="Y")&&(HVFlag'="N") d
	..s ErrMsg="第"_i_"条高值标志必须为Y或者N,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i (ChargeFlag'="Y")&&(ChargeFlag'="N") d
	..s ErrMsg="第"_i_"条是否收费标志必须为Y或者N,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i (TableFlag'="Y")&&(TableFlag'="N") d
	..s ErrMsg="第"_i_"条材料是否0库存管理标志必须为Y或者N,InciCode:"_InciCode  ;(跟台标志)
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s LocDesc=INCIDataObj.LocDesc
	.s UserId=##class(web.DHCSTMService.HRP.CommonInfo).ComUser(UserInitial)
	.s:UserId="" UserId=1
	.s LocId=##class(web.DHCSTMService.HRP.CommonInfo).ComLoc(LocDesc)
	.i (LocId="") d
	..s LocId=1
	..;s ErrMsg="第"_i_"条科室为空,InciCode:"_InciCode
	..;d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s vendorid=##class(web.DHCSTMService.HRP.CommonInfo).ComApc(PbVendor)
	.s Manfid=##class(web.DHCSTMService.HRP.CommonInfo).ComManf(Manf)
	.s TransFlag="BOTH"
	.s BatchReq="O"
	.s ExpReq="O"
	.s Incid=""
	.&sql(SELECT INCI_RowId INTO:Incid FROM INC_Itm WHERE INCI_Code=:InciCode)
	.;类组
	.s ScgDr=..validScg(HospId)
	.i (ScgDr="") d
	..s ErrMsg="第"_i_"条材料是分类未同步成功,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i Incid'="" d
	..s notuseflag=$P(^INCI(Incid,2),"^",9)
	..i (notuseflag'=NotUseFlag)&&(NotUseFlag="Y") d
	...;d ..SyncArcimAndTariItem(Incid,+$h,"N")   ;唐山中心特殊加的暂时不用
	..i (notuseflag'=NotUseFlag)&&(NotUseFlag="N") d
	...;d ..SyncArcimAndTariItem(Incid,"","Y")   ;唐山中心特殊加的暂时不用
	.s mainData1=Incid_"^"_InciCode_"^"_InciDesc_"^"_BUomDr_"^"_PUomDr_"^"_IncscDr_"^"_TransFlag_"^"_BatchReq_"^"_ExpReq_"^"_UserId
	.s mainData2=Rp_"^"_Sp_"^"_Spec_"^"_HVFlag_"^"_NotUseFlag_"^"_vendorid_"^"_Manfid_"^"_Brand_"^"_Model_"^"_TableFlag
	.s mainData3=HospId_"^"_ScgDr_"^"_LocId_"^"_ChargeFlag_"^"_ImpFlag
	.s mainData=mainData1_"^"_mainData2_"^"_mainData3
	.s mainTitle1="Inci^InciCode^InciDesc^BUom^PUom^StkCat^TransFlag^BatchNoReq^ExpDateReq^gUserId^RpPUom"
	.s mainTitle2="SpPUom^Spec^HighPrice^NotUseFlag^PbVendor^Manf^Brand^Model^HighRiskFlag"
	.s mainTitle3="gHospId^StkGrp^gLocId^ChargeFlag^ImpFlag"
	.s mainTitle=mainTitle1_"^"_mainTitle2_"^"_mainTitle3
	.s mainDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(mainData,mainTitle)
	.s ^TMPDHCSTM("TMPDHCSTM",Pid,i)=mainDataObj
	.s successcount=successcount+1
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	q:successcount=0 ..OutResultxml(0,"参数为空,请核实!")
	s BillSub=0
	f  s BillSub=$o(^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)) q:(BillSub="")  d
	.s IncData=^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)
	.s RtnObj=##class(web.DHCSTMHUI.DrugInfoMaintain).SaveData("",IncData)
	.s PJObjret=##class(web.DHCSTMHUI.Common.FromJson).%New()
	.s Sc=PJObjret.%FromJSON(RtnObj)
	.s success=PJObjret.%Get("success")
	.s msg=PJObjret.%Get("msg")
	.i success'=0 d
	..s ErrMsg="第"_BillSub_"条保存失败,"_msg
	..d ..RecordErrInfo(Pid,ErrMsg)
	.e  d
	..i ArcimId'="" d
	...s tempInciId=$o(^INCI(0,"ARCIM_DR",ArcimId,0))
	...i tempInciId'="" d
	....s ErrMsg="第"_BillSub_"条保存成功,医嘱项已存在关联"
	...e  d
	....s ret=##class(web.DHCSTMHUI.ShowArcinfoForlinkInci).LinkInci(ArcimId,InciId)
	....i ret=0 s ErrMsg="第"_BillSub_"条保存成功"
	....e  s ErrMsg="第"_BillSub_"条保存成功,医嘱项关联失败"
	.e  d
	..s ErrMsg="第"_BillSub_"条保存成功"
	..d ..RecordErrInfo(Pid,ErrMsg)
	s retInfo=""
	s i=0
	f  s i=$o(^TMPDHCSTM("TMPDHCSTMERR",Pid,i)) q:i=""  d
	.s ErrMsg=^TMPDHCSTM("TMPDHCSTMERR",Pid,i)
	.i retInfo="" d
	..s retInfo=ErrMsg
	.e  d
	..s retInfo=retInfo_";"_ErrMsg
	s RetStream=..OutResultxml(0,retInfo)
	k ^TMPDHCSTM("TMPDHCSTMERR",Pid)
	q RetStream
}

ClassMethod UpdateItmTrackOrAdjPrice(InAdj As %String)
{
	n (InAdj)
	ts 
	s ret=0
	s ch=""
	s AdjLoc=$P(^DHCINAD(InAdj),"^",16)
	s AdjHospID=$p($G(^CTLOC(AdjLoc)),"^",22)
	s AdjUserId=$P(^DHCINAD(InAdj),"^",3)
	f  s ch=$o(^DHCINAD(InAdj,"ADI",ch)) q:(ch="")||(ret'=0)  d
	.s qty=$P(^DHCINAD(InAdj,"ADI",ch),"^",2)
	.s inclb=$P(^DHCINAD(InAdj,"ADI",ch),"^",1)
	.s Inci=+inclb
	.s incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	.s Sp=$P(^DHCINAD(InAdj,"ADI",ch),"^",4)
	.s Rp=$P(^DHCINAD(InAdj,"ADI",ch),"^",9)
	.s UomId=$P(^DHCINAD(InAdj,"ADI",ch),"^",5)
	.s pointer=InAdj_"||"_ch
	.q:qty<0
	.i qty<0 d
	..s status="Used"
	.e  d
	..s status="Enable"
	.s dhcit=$o(^DHCITD(0,"Type","A","Pointer",pointer,""))
	.&sql(update dhc_itmtrack set DHCIT_Status=:status where dhcit_rowid=:dhcit)
	.;下面生成批次调价信息
	.s str=Inci_"^"_UomId_"^"_Sp_"^"_Rp_"^"_AdjUserId_"^"_AdjHospID_"^"_AdjLoc
	.s rt=..CreateAdjPriceBatch(str,incib)
	.i rt'=0 d
	..s ret=rt
	i ret'=0 tro  q
	q:ret'=0 ret
	tc
	q ret
}

ClassMethod GetErrMsg(Pid As %String)
{
	s retInfo=""
	s i=0
	f  s i=$o(^TMPDHCSTM("TMPDHCSTMERR",Pid,i)) q:i=""  d
	.s ErrMsg=^TMPDHCSTM("TMPDHCSTMERR",Pid,i)
	.i retInfo="" d
	..s retInfo=ErrMsg
	.e  d
	..s retInfo=retInfo_";"_ErrMsg
	q retInfo
}

/// Description:获取Inclb
/// Descript:	根据第三方批次id等信息获取已有批次,或新建批次信息
/// Creator:	wangjiabin
/// CreateDate:	2017-07-26
/// Input:		Incib, 科室rowid
/// OutPut:		inclb:成功, <0:失败
/// w ##class(web.DHCSTMService.HRP.In2OutServiceImpl).GetINCLB("9041||5",153)
ClassMethod GetINCLB(Incib As %String, LocId As %String) As %String [ Private ]
{
	n (Incib,LocId)
	q:Incib="" -1
	s Inci=$p(Incib,"||",1),IB=$p(Incib,"||",2)
	q:(Inci="")||(IB="") -1
	q:($d(^INCI(Inci,"IB",IB))=0)||($d(^INCI(Inci,"IB",IB))=10) -1
	l +^DBLock($zn,Inci_"^"_LocId):10 e  q -99
	s Err=0
	ts
	s Incil="",Inclb=""
	s IL=$O(^INCI("IL_LOC",LocId,Inci,""))
	i IL="" d
	.&sql(insert into inc_itmloc
		(incil_Inci_parref,incil_ctloc_dr)
		values
		(:Inci,:LocId)
	 )
	.i SQLCODE=0 s Incil=$p($g(%ROWID),$c(1)) 
	.e  s Err=-20 
	.s IL=$p(Incil,"||",2)
	e  d
	.s Incil=Inci_"||"_IL
	i (IL="")||(Err<0) tro 1 q Err
	s LB=$O(^INCI("LB_IB",Incib,Inci,IL,""))
	i LB="" d
	.&sql(insert into INC_ItmLcBt
		(inclb_incil_parref,inclb_incib_dr)
		values(:Incil,:Incib)
	 )
	.i SQLCODE=0 s Inclb=$p($g(%ROWID),$c(1))
	.e  s Err=-21
	e  d
	.s Inclb=Inci_"||"_IL_"||"_LB 
	l -^DBLock($zn,Inci_"^"_LocId)
	i (Inclb="")||(Err<0) tro 1 q Err
	tc
	q Inclb
}

/// Descript:	根据第三方批次id等信息获取已有批次,或新建批次信息
/// Creator:	wangjiabin
/// CreateDate:	2017-07-26
/// Input:		StrParam(BatId^InciCode^LocCode^ExpDate^BatchNo^Rp^Sp)
/// 					第三方批次Id^库存项代码^科室代码^效期(Y-m-d)^批号^进价^售价
/// 			AdjBatchNo批次调价表单号
/// Return:		incib:成功, <0:失败
/// w ##class(web.DHCSTMService.HRP.In2OutServiceImpl).GetIncib("296^11051000519^1002110103^2018-12-31^^137.0300^137.0300","20170001")
ClassMethod GetIncib(StrParam As %String, AdjBatchNo As %String) As %String [ Private ]
{
	n (StrParam,AdjBatchNo)
	s BatId=$p(StrParam,"^",1)  ; 
	s InciCode=$p(StrParam,"^",2)
	;s LocCode=$p(StrParam,"^",3)
	s LocId=$p(StrParam,"^",3)
	s ExpDate=$p(StrParam,"^",4)
	s BatchNo=$p(StrParam,"^",5)
	s Rp=$p(StrParam,"^",6)
	s Sp=$p(StrParam,"^",7)
	s InciCode=$$ALPHAUP^SSUTIL4(InciCode)
	;s LocCode=$$ALPHAUP^SSUTIL4(LocCode)
	q:BatId="" -1
	q:InciCode="" -1
	;q:LocCode="" -1
	q:LocId="" -1
	s Inci=$o(^INCI(0,"Code1",InciCode_"Z",0))
	q:Inci="" -2
	q:'$d(^INCI(Inci,1))||'$d(^INCI(Inci,2))||'$d(^INCI(Inci,3)) -2
	;s LocId=$o(^CTLOC(0,"Code",LocCode,0))
	s Incib=""
	s orginRp=0
	s DHCIncib=$o(^DHCINCIB(0,"DetailId",BatId,0))
	i DHCIncib'="" d
	.s Incib=$p(^DHCINCIB(DHCIncib),"^",1)
	.s orginRp=$p(^DHCINCIB(DHCIncib),"^",3)
	q:(DHCIncib'="")&&(Incib="") -3
	
	i (orginRp'=Rp)&&(DHCIncib'="") q -10
	q:Incib'="" Incib		;获取到Incib的,退出
	
	s $ZT="Error^DHCSTMHUIERROR"
	ts
	;1.传入INC_ItmBat
	s:ExpDate["-" ExpDate=$zdh(ExpDate,3)
	s Uom=$p(^INCI(Inci,1),"^",10)
	s BuomDr=$p(^INCI(Inci,1),"^",10)
	s PuruomDr=$p(^INCI(Inci,3),"^",6)
	s PFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PuruomDr,BuomDr)
	;s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BuomDr)
	s ProduceDate=""
	s Mnf=""
	s SpecList=""
	s Vendor=""
	s GiftFlag=""
	s AdjCheque=""
	s SourceOfFund=""
	s SterilizedBat=""
	;按基本单位处理
	s BRp=Rp
	s PurRp=Rp*PFac
	s BSp=Sp
	s PurSp=Sp*PFac
	s Date=+$h
	s Time=$p($h,",",2)
	s Err=0
	i Incib="" 
	{
		&sql(insert into inc_itmbat
			(INCIB_INCI_ParRef,INCIB_No,INCIB_ExpDate)
			values
			(:Inci,:BatchNo,:ExpDate)
		)
		i SQLCODE'=0  d
		.s Err=-10
		i Err'=0 tro 1 q Err
		s Incib=$p($g(%ROWID),$c(1))
		;2.插入DHC_INCItmBat
		s Dhcingri=""
		&sql(insert into dhc_incitmbat
			(INCIB_INCIB_Dr,INCIB_ProduceDate,INCIB_Rp,INCIB_RpPuruom,INCIB_Sp,
			INCIB_SpPuruom,INCIB_PHMNF_Dr,INCIB_APCVM_Dr,INCIB_INGRI_Dr,INCIB_DateAdd,
			INCIB_TimeAdd,INCIB_SourceOfFund,INCIB_SpecList,INCIB_GiftFlag,INCIB_AdjCheque,
			INCIB_SterilizedBat,INCIB_DetailId)
			values
			(:Incib,:ProduceDate,:BRp,:PurRp,:BSp,
			:PurSp,:Mnf,:Vendor,:Dhcingri,:Date,
			:Time,:SourceOfFund,:SpecList,:GiftFlag,:AdjCheque,
			:SterilizedBat,:BatId)
		)
		i SQLCODE'=0  d
		.s Err=-11
		i Err'=0 tro 1 q Err
	}
	;3.Insert批次调价表
	s AdjUomId=$p(^INCI(Inci,1),"^",10)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s AdjDate=+$h,AdjUserId="",Status="Y"
	s ExecuteDate=+$h
	s PriorRp=0,PriorSp=0,BPriorRp=0,BPriorSp=0
	s PriceFileNo="",WarNoDate="",PreExecuteDate=+$h
	s Remark="",AdjReasonId=""
	s PriceInfo=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByIncib(Incib,+$h,AdjUomId,HospId)
	s OldSp=$p(PriceInfo,"^",2)
	/*i +OldSp'=+Sp {
		&sql(insert into IN_AdjPriceBatch
			(INAPB_date,INAPB_Incib_Dr,INAPB_ssusr_dr,INAPB_status,INAPB_No,
			INAPB_ExecuteDate,INAPB_Uom_Dr,INAPB_PriorRpUom,INAPB_ResultRpUom,INAPB_PriorSpUom,
			INAPB_ResultSpUom,INAPB_PriorRP,INAPB_ResultRP,INAPB_priorsp,INAPB_resultsp,INAPB_Hospital_Dr,
			INAPB_WarrentNO,INAPB_WNODate,INAPB_PreExeDate,INAPB_Remark,INAPB_REASON_DR) 
			values
			(:AdjDate,:Incib,:AdjUserId,:Status,:AdjBatchNo,
			:ExecuteDate,:AdjUomId,:PriorRp,:Rp,:PriorSp,
			:Sp,:BPriorRp,:Rp,:BPriorSp,:Sp,:HospId,
			:PriceFileNo,:WarNoDate,:PreExecuteDate,:Remark,:AdjReasonId)
		)
		i SQLCODE'=0 tro 1 q -12
	}*/
	tc
	q Incib
}

/// 维护库存分类与类组关联 返回类组ID
/// w ##class(web.DHCSTMService.HRP.In2OutServiceImpl).validStkGrpRelation(51)
ClassMethod validStkGrpRelation(sc As %String) As %String
{
	n (sc)
	s scg="",type="M"
	&sql(select scgr_scg_parref into :scg From dhc_stkcatgrprelations  where scgr_stkcat_dr=:sc and scgr_scg_parref->scg_Type=:type)
	s catgrp="耗材"
	i SQLCODE d
	.s rowid=""
	.&sql(select scg_rowid into :scg from dhc_stkcatgroup where scg_desc=:catgrp and scg_type=:type)
	.i SQLCODE d
	..s code="HC01"
	..&sql(insert into  dhc_stkcatgroup(scg_code,scg_desc,scg_type) values (:code,:catgrp,:type))
	.i 'SQLCODE d
	..s scg=$p($g(%ROWID),$c(1))
	.q:scg=""
	.s ch=$o(^DHCSCG(scg,"RE",""),-1)+1
	.&sql(insert into dhc_stkcatgrprelations(scgr_scg_parref,scgr_childsub,scgr_stkcat_dr) values (:scg,:ch,:sc) )
	.
	q scg
}

/// Descript:	同步价格
/// Creator:	lihui
/// CreateDate:	20191223
/// Input:		Data入参xml流  
/// Output:     返回对象xml串
/// Return：
/// w ##class(web.DHCSTMService.SPDService).SynPriceData()
ClassMethod SynPriceData(Input As %GlobalCharacterStream) As %String
{
	n (Input)
	s MainStr="",DetailStr="",Ret=0,n=0
	s reader = ##class(%XML.Reader).%New()
	s sc=reader.OpenStream(Input)
	i $$$ISERR(sc)  q ..OutResultxml(1,"XML解析失败")
	s PriObj=##class(web.DHCSTMService.HRP.Model.PriceData).%New()
	d reader.Correlate("PriceData","web.DHCSTMService.HRP.Model.PriceData")
	s Pid=..NewPid()
	k ^TMPDHCSTMHRPService(Pid,"DHCSTMHRPService")
	s retmsg=..OutResultxml(0,"操作成功"),Ret=0
	
	d reader.Correlate("PriceList","web.DHCSTMService.HRP.Model.PriceList")
	s PriceListObj=##class(web.DHCSTMService.HRP.Model.PriceList).%New()
	s PriceListRetObj=##class(web.DHCSTMService.HRP.Model.PriceList).%New()
	while reader.Next(.PriceListRetObj,.sc){
		s PriceListRetObj=PriceListRetObj
	}
	s DetailCount=PriceListRetObj.BillList.Count()
	q:DetailCount=0 ..OutResultxml(-1,"参数错误!")
	s n=0
	f BillSub=1:1:DetailCount  d
	.s PriObj=##class(web.DHCSTMService.HRP.Model.PriceData).%New()
	.s PriObj=PriceListRetObj.PriceData.GetAt(BillSub)
	.s LocDesc=PriObj.LocDesc
	.s LocId=##class(web.DHCSTMService.HRP.CommonInfo).ComLoc(LocDesc)
	.i LocId="" s Ret=-1,retmsg=..OutResultxml(1,"科室不存在") q
	.s HospId=$p(^CTLOC(LocId),"^",22)
	.i HospId="" s Ret=-1,retmsg=..OutResultxml(1,"科室医院不存在") q
	.s UserName=PriObj.AdjUser
	.s User=##class(web.DHCSTMService.HRP.CommonInfo).ComUser(UserName)
	.s InciCode=PriObj.code
	.s Inci=##class(web.DHCSTMService.HRP.CommonInfo).ComInci(InciCode)
	.i Inci="" s Ret=-2,retmsg=..OutResultxml(1,"物资不存在") q
	.s InciDesc=PriObj.desc
	.s Spec=PriObj.Spec
	.s UomDesc=PriObj.Adjpriceuom
	.s Uom=##class(web.DHCSTMService.HRP.CommonInfo).ComUom(UomDesc)
	.i Uom="" s Ret=-3,retmsg=..OutResultxml(1,"单位不存在") q
	.s Rpb=PriObj.AdjpriceRPbefore
	.s Spb=PriObj.AdjpriceSPbefore
	.s Rpa=PriObj.AdjpriceRPafter
	.s Spa=PriObj.AdjpriceSPafter
	.s AdjDate=PriObj.AdjDate
	.s MainStr=LocId_"^"_HospId_"^"_User
	.s Detailtitle="PreExecuteDate^Inci^AspUomId^ResultSpUom^ResultRpUom^PriorSpUom^PriorRpUom^gLocId^gHospId"
	.s Detaildata=AdjDate_"^"_Inci_"^"_Uom_"^"_Spa_"^"_Rpa_"^"_Spb_"^"_Rpb_"^"_LocId_"^"_HospId
	.s DetailObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Detaildata,Detailtitle)
	.s n=n+1
	.s ^TMPDHCSTMHRPService(Pid,"DHCSTMHRPService",MainStr,n)=DetailObj
	
	q:Ret'=0 retmsg
	i '$d(^TMPDHCSTMHRPService(Pid,"DHCSTMHRPService")) q ..OutResultxml(1,"无数据可处理")
	ts
	s sub=""
	f  s sub=$O(^TMPDHCSTMHRPService(Pid,"DHCSTMHRPService",sub)) q:(sub="")||(Ret'=0)  d
	.s ch="",DetailStr=""
	.f  s ch=$O(^TMPDHCSTMHRPService(Pid,"DHCSTMHRPService",sub,ch)) q:(ch="")||(Ret'=0)  d
	..s Detail=^TMPDHCSTMHRPService(Pid,"DHCSTMHRPService",sub,ch)
	..i DetailStr="" d
	...s DetailStr=Detail
	..e   d
	...s DetailStr=DetailStr_","_Detail
	.s DetailStrObj="["_DetailStr_"]"
	.s maintitle="gLocId^gHospId^gUserId"
	.s maindata=sub
	.s User=$P(sub,"^",3)
	.s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	.s MainObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(maindata,maintitle)
	.s RtnObj=##class(web.DHCSTMHUI.INAdjSalePrice).Update(MainObj,DetailStrObj)
	.s success=RtnObj.success
	.i success'=0 s Ret=+success q
    .s AspIdStr=RtnObj.rowid
    .s AspIdStrLen=$l(AspIdStr,",")
    .f i=1:1:AspIdStrLen q:RtnObj.success'=0  d
    ..s AspId=$p(AspIdStrLen,",",i)
	..s ExecuteDate=$p(^INASP(AspId),"^",2)
	..s AdjUserId=$p(^INASP(AspId),"^",3)
	..s InciId=$p(^INASP(AspId),"^",4)
	..s RtnObj=##class(web.DHCSTMHUI.INAdjSalePrice).Audit(AspId,User)
	..i RtnObj.success'=0 s Ret=RtnObj.success q
	i Ret'=0 tro  q ..OutResultxml(1,"调价失败"_Ret)
	tc
	k ^TMPDHCSTMHRPService(Pid,"DHCSTMHRPService")
	q retmsg
}

ClassMethod SynPriceDataBatch(Input As %GlobalCharacterStream) As %String
{
	n (Input)
	s MainStr="",DetailStr="",Ret=0,n=0
	s reader = ##class(%XML.Reader).%New()
	s sc=reader.OpenStream(Input)
	i $$$ISERR(sc)  q ..OutResultxml(1,"XML解析失败")
	s PriObj=##class(web.DHCSTMService.HRP.Model.PriceData).%New()
	d reader.Correlate("PriceData","web.DHCSTMService.HRP.Model.PriceData")
	s Pid=..NewPid()
	k ^TMPDHCSTMHRPService(Pid,"DHCSTMHRPService")
	s retmsg=..OutResultxml(0,"操作成功"),Ret=0
	While reader.Next(.PriObj,.sc) {
		s LocDesc=PriObj.LocDesc
		s LocId=##class(web.DHCSTMService.HRP.CommonInfo).ComLoc(LocDesc)
		i LocId="" s Ret=-1,retmsg=..OutResultxml(1,"科室不存在") q
		s HospId=$p(^CTLOC(LocId),"^",22)
		i HospId="" s Ret=-1,retmsg=..OutResultxml(1,"科室医院不存在") q
		s UserName=PriObj.AdjUser
		s User=##class(web.DHCSTMService.HRP.CommonInfo).ComUser(UserName)
		s InciCode=PriObj.code
		s Inci=##class(web.DHCSTMService.HRP.CommonInfo).ComInci(InciCode)
		i Inci="" s Ret=-2,retmsg=..OutResultxml(1,"物资不存在") q
		s InciDesc=PriObj.desc
		s Spec=PriObj.Spec
		s UomDesc=PriObj.Adjpriceuom
		s Uom=##class(web.DHCSTMService.HRP.CommonInfo).ComUom(UomDesc)
		i Uom="" s Ret=-3,retmsg=..OutResultxml(1,"单位不存在") q
		s Rpb=PriObj.AdjpriceRPbefore
		s Spb=PriObj.AdjpriceSPbefore
		s Rpa=PriObj.AdjpriceRPafter
		s Spa=PriObj.AdjpriceSPafter
		s AdjDate=PriObj.AdjDate
		s BatId=PriObj.BatId
		s DHCIncib=$o(^DHCINCIB(0,"DetailId",BatId,0))
		i DHCIncib'="" d
		.s Incib=$p(^DHCINCIB(DHCIncib),"^",1)
		i Incib="" s Ret=-3,retmsg=..OutResultxml(1,"物资批次不存在不存在"_Incib) q
		s MainStr=LocId_"^"_HospId_"^"_User
		;s Detailtitle="PreExecuteDate^Inci^AspUomId^ResultSpUom^ResultRpUom^PriorSpUom^PriorRpUom^gLocId^gHospId"
		s Detailtitle="RowId^Incib^Inci^PreExecuteDate^AspUomId^ResultSpUom^ResultRpUom^PriorSpUom^PriorRpUom"
		s Detaildata=""_"^"_Incib_"^"_Inci_"^"_AdjDate_"^"_Uom_"^"_Spa_"^"_Rpa_"^"_Spb_"^"_Rpb
		;s Detaildata=AdjDate_"^"_Inci_"^"_Uom_"^"_Spa_"^"_Rpa_"^"_Spb_"^"_Rpb_"^"_LocId_"^"_HospId
		s DetailObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Detaildata,Detailtitle)
		s n=n+1
		s ^TMPDHCSTMHRPService(Pid,"DHCSTMHRPService",MainStr,n)=DetailObj
	}
	q:Ret'=0 retmsg
	i '$d(^TMPDHCSTMHRPService(Pid,"DHCSTMHRPService")) q ..OutResultxml(1,"无数据可处理")
	ts
	s sub=""
	f  s sub=$O(^TMPDHCSTMHRPService(Pid,"DHCSTMHRPService",sub)) q:(sub="")||(Ret'=0)  d
	.s ch="",DetailStr=""
	.f  s ch=$O(^TMPDHCSTMHRPService(Pid,"DHCSTMHRPService",sub,ch)) q:(ch="")||(Ret'=0)  d
	..s Detail=^TMPDHCSTMHRPService(Pid,"DHCSTMHRPService",sub,ch)
	..i DetailStr="" d
	...s DetailStr=Detail
	..e   d
	...s DetailStr=DetailStr_","_Detail
	.s DetailStrObj="["_DetailStr_"]"
	.s maintitle="gLocId^gHospId^gUserId"
	.s User=$P(sub,"^",3)
	.s Locdr=$p(sub,"^",1)
	.s maindata=sub
	.s MainObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(maindata,maintitle)
	.s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	.s RtnObj=##class(web.DHCSTMHUI.INAdjPriceBatch).Save(MainObj,DetailStrObj)
	.s success=RtnObj.success
	.i success'=0 s Ret=+success q
	.s rowidstr=RtnObj.rowid
	.s len=$l(rowidstr,",")
	.f i=1:1:len q:RtnObj.success'=0  d
	..s AspId=$p(rowidstr,"^",i)
	..s RtnObj=##class(web.DHCSTMHUI.INAdjPriceBatch).Audit(AspId,User_"^"_""_"^"_Locdr)
	..i RtnObj.success'=0 s Ret=RtnObj.success q
	i Ret'=0 tro  q ..OutResultxml(1,"调价失败"_Ret)
	tc
	k ^TMPDHCSTMHRPService(Pid,"DHCSTMHRPService")
	q retmsg
}

/// Descript:	同步分类(库存分类)
/// Creator:	lihui
/// CreateDate:	20200414
/// Input:	[{},{}]	
/// Return:	[0:"",1:失败信息]
/// w ##class(web.DHCSTMService.HRP.In2OutServiceImpl).SynIncscData("<INCSCList><INCSCData><IncscDesc>his分类测试2</IncscDesc><IncscCode>0126</IncscCode></INCSCData></INCSCList>")
ClassMethod SynIncscData(Input) As %GlobalCharacterStream
{
	n (Input)
	;s ^litmp("SynIncscData")=Input
	;s Input="<INCSCList><INCSCData><HospitalCode>DHSZHYYZY</HospitalCode><IncscCode>测试接口导入院区</IncscCode><IncscDesc>测试接口导入院区</IncscDesc></INCSCData><INCSCData><HospitalCode>DHSZHYYZY</HospitalCode><IncscCode>测试接口导入院区1</IncscCode><IncscDesc>测试接口导入院区1</IncscDesc></INCSCData></INCSCList>"
	s InputStream=##class(%GlobalCharacterStream).%New()
	i '$ISOBJECT(Input) d
	.d InputStream.Write(Input)
	e  d
	.d InputStream.CopyFrom(Input)
	d InputStream.Rewind()
	s Pid=$i(^DHCSTMPID("PID"))
	k ^TMPDHCSTM("TMPDHCSTMERR",Pid)
	s RetStream=##class(%GlobalCharacterStream).%New()
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(InputStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	d reader.Correlate("INCSCList","web.DHCSTMService.HRP.Model.INCSCList")
	s ListObj=##class(web.DHCSTMService.HRP.Model.INCSCList).%New()
	s ListAllObj=##class(web.DHCSTMService.HRP.Model.INCSCList).%New()
	while reader.Next(.ListObj,.sc){
		s ListAllObj=ListObj
	}
	s ItmCount=ListAllObj.INCSCData.Count()
	f i=1:1:ItmCount  d
	.s ErrMsg=""
	.s INCSCDataObj=##class(web.DHCSTMService.HRP.Model.INCSCData).%New()
	.s INCSCDataObj=ListAllObj.INCSCData.GetAt(i)
	.s HospitalCode=INCSCDataObj.HospitalCode
	.s IncscCode=INCSCDataObj.IncscCode
	.s IncscDesc=INCSCDataObj.IncscDesc
	.s HospId=##class(web.DHCSTMService.HRP.CommonInfo).ComHosp(HospitalCode)
	.i (HospitalCode="")||(HospId="")
	..s ErrMsg="第"_i_"条医院编码为空"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i IncscCode="" d
	..s ErrMsg="第"_i_"条代码为空"_IncscDesc
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i IncscDesc="" d
	..s ErrMsg="第"_i_"条名称为空"_IncscCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s IncscId=""
	.&sql(SELECT INCSC_RowId INTO:IncscId FROM INC_StkCat WHERE INCSC_Code=:IncscCode)
	.s mainData=IncscId_"^"_IncscCode_"^"_IncscDesc_"^"_HospId
	.s ^TMPDHCSTM("TMPDHCSTM",Pid,i)=mainData
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s BillSub=0
	s ErrMsg=""
	f  s BillSub=$o(^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)) q:(BillSub="")  d
	.s IncscData=^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)
	.s code=$p(IncscData,"^",2)
	.s desc=$p(IncscData,"^",3)
    .s bdpHospId=$p(IncscData,"^",4)
    .s success=0
	.s scgdr=..validScg(bdpHospId)
	.i scgdr=""  d 
	..s ErrMsg="第"_BillSub_"条类组生成失败,"
	..d ..RecordErrInfo(Pid,ErrMsg)
	..s success=-1
	.e  d
	..s stkcatDr=..validStkCat(code,desc,bdpHospId,scgdr)
	..i stkcatDr="" d
	...s ErrMsg="第"_BillSub_"条分类生成失败,"
	...d ..RecordErrInfo(Pid,ErrMsg)
	...s success=-2
	.i success'=0 d
	..s ErrMsg="第"_BillSub_"条保存失败,"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.e  d
	..s ErrMsg="第"_BillSub_"条保存成功"
	..d ..RecordErrInfo(Pid,ErrMsg)	
	s retInfo=""
	s i=0
	f  s i=$o(^TMPDHCSTM("TMPDHCSTMERR",Pid,i)) q:i=""  d
	.s ErrMsg=^TMPDHCSTM("TMPDHCSTMERR",Pid,i)
	.i retInfo="" d
	..s retInfo=ErrMsg
	.e  d
	..s retInfo=retInfo_";"_ErrMsg
	s RetStream=..OutResultxml(0,retInfo)
	k ^TMPDHCSTM("TMPDHCSTMERR",Pid)
	q RetStream
}

/// 记录错误信息
/// d调用
ClassMethod RecordErrInfo(Pid, ErrMsg)
{
	n (Pid,ErrMsg)
	;记录错误信息
	s ErrCount=$i(^TMPDHCSTM("TMPDHCSTMERR",Pid,0))
	s ^TMPDHCSTM("TMPDHCSTMERR",Pid,ErrCount)=ErrMsg
	q
}

/// 验证类组(大类)   
ClassMethod validScg(hospId As %String) As %String
{
     n (hospId)
     s code="HRPSCG"
     s desc="HRP耗材"
	 s type="M"
	 s rowid=""
	 &sql(select scg_rowid into :scg from dhc_stkcatgroup where SCG_Code=:code and scg_type=:type)
	 i SQLCODE d
	 .;调用公共生成类组方法
	 .s StrParam="SCG"_"^"_code_"^"_desc_"^"_""_"^"_"M"
	 .s data=hospId_"^"_hospId
	 .s title="gHospId^BDPHospital"
	 .s HospObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(data,title)
	 .s ret=##class(web.DHCSTMHUI.MulStkCatGroup).Add(StrParam,HospObj)
	 .q:ret'="" 
	 .&sql(select scg_rowid into :nscg from dhc_stkcatgroup where SCG_Code=:code and scg_type=:type)
	 .i SQLCODE d
	 ..s rowid=""
	 .e  d
	 ..s rowid=nscg
	 e  d
	 .s rowid=+scg
	 q rowid
}

/// 验证分类
ClassMethod validStkCat(code As %String, desc As %String, hospId As %String, scgdr As %String) As %String
{
	 n (code,desc,hospId,scgdr)
	 s type="M"
	 s rowid=""
	 &sql(select incsc_rowid into :scid from inc_stkcat where incsc_code=:code and INCSC_StkType=:type)
	 i SQLCODE d
	 .;调用公共生成分类方法
	 .s StrParam="INCSC"_"^"_code_"^"_desc_"^"_scgdr_"^"_"M"
	 .s data=hospId_"^"_hospId
	 .s title="gHospId^BDPHospital"
	 .s HospObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(data,title)
	 .s ret=##class(web.DHCSTMHUI.MulStkCatGroup).Add(StrParam,HospObj)
	 .q:ret'="" 
	 .&sql(select incsc_rowid into :nstkcat from inc_stkcat where incsc_code=:code and INCSC_StkType=:type)
	 .i SQLCODE d
	 ..s rowid=""
	 .e  d
	 ..s rowid=nstkcat
	 e  d
	 .&sql(update inc_stkcat set incsc_desc=:desc where incsc_code=:code)
	 .s rowid=+scid
	 q rowid
}

ClassMethod SyncArcimAndTariItem(incirowid, enddate, flag) As %String
{
	s myARCIMRowId=$p($g(^INCI(incirowid,1)),"^",3)
	if myARCIMRowId'=""
	{
		s INCIDesc=$p($g(^INCI(incirowid,1)),"^",2)
		s arcimobj=##class(User.ARCItmMast).%OpenId(myARCIMRowId)
		Set arcimobj.ARCIMDesc=INCIDesc   //同步医嘱项名称
		Set arcimobj.ARCIMUpdateDate=$P($h,",",1) 
		Set arcimobj.ARCIMUpdateTime=$p($h,",",2)
		Set arcimobj.ARCIMEffDateTo=enddate   //同步医嘱项结束日期
		if arcimobj.ARCIMEffDate["," s arcimobj.ARCIMEffDate=$p(arcimobj.ARCIMEffDate,",",1)
		if arcimobj.ARCIMEffDate["Z" s arcimobj.ARCIMEffDate=$p(arcimobj.ARCIMEffDate,"Z",1)
		Set arcimobj.ARCIMChgPostFlg="O"
		d arcimobj.%Save()
		///获取医嘱项关联的收费项，并修改有效标志
		s tarirowid=0
		for
		{
			s tarirowid=$o(^DHCOLT(0,"ARTTA",myARCIMRowId,tarirowid)) q:tarirowid=""   
			s tariobj=##class(User.DHCTarItem).%OpenId(tarirowid)
			s tariobj.TARIEndDate=enddate //修改收费项结束日期
			s tariobj.TARIActiveFlag=flag   //修改收费项有效标志
			d tariobj.%Save()
		}
	}
}

/// 针对批次售价，先生成批次价
ClassMethod CreateAdjPriceBatch(StrParam As %String, Incib As %String) As %String
{
	n (StrParam,Incib)
	s ItmRowid=$p(StrParam,"^",1)
	s AdjUomId=$p(StrParam,"^",2)
	s ResultSp=$p(StrParam,"^",3)
	s ResultRp=$p(StrParam,"^",4)
	s AdjUserId=$p(StrParam,"^",5)
	s HospId=$p(StrParam,"^",6)
	s LocId=$p(StrParam,"^",7)
	s:LocId="" LocId=1
	s Param=""_"^"_LocId_"^"_AdjUserId_"^"_HospId
	s BatSp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTCOMMONM","BatSp",Param)
	q:BatSp'=1 0  ;非批次价退出
	s RetStr=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByIncib(Incib,+$h,AdjUomId,HospId,"")
	s PriorSp=$p(RetStr,"^",2)
	s PriorRp=$p(RetStr,"^",1)
	s Err=0
	i (PriorRp'=ResultRp)||(PriorSp'=ResultSp) d
	.i Incib="" s Sc=RtnObj.Err(-1,"","批次不存在!")
	.s resultString=0
	.s GrpId=$p(StrParam,"^",8)
	.s LocId=$p(StrParam,"^",9)
	.s AppName=##class(web.DHCSTMHUI.INAdjSalePrice).%GetParameter("AppName")
	.s AdjBatNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,GrpId,LocId)
	.i ((AdjBatNo="")||(+AdjBatNo<0)) s Err=-2
	.q:Err'=0
	.s preexedate=$zd($h,3)
	.s AdjReasonId=""
	.tstart
	.s tmpDetailData=Incib_"^"_preexedate_"^"_ItmRowid_"^"_AdjUomId_"^"_ResultSp_"^"_ResultRp_"^"_AdjUserId_"^"_AdjReasonId_"^"_HospId_"^入库生成^"_PriorRp_"^"_PriorSp
	.s tmpDetailTitle="Incib^PreExecuteDate^Inci^AspUomId^ResultSpUom^ResultRpUom^gUserId^AdjReasonId^gHospId^Remark^PriorRpUom^PriorSpUom"
	.s tmpDetailDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(tmpDetailData,tmpDetailTitle)
	.s tmpDetailDataObj="["_tmpDetailDataObj_"]"
	.s tmpMainData=AdjBatNo_"^"_LocId_"^"_AdjUserId_"^"_HospId
	.s tmpMainTitle="AspNo^gLocId^gUserId^gHospId"
	.s tmpMainDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(tmpMainData,tmpMainTitle)
	.s RtnObjStr=##class(web.DHCSTMHUI.INAdjPriceBatch).Save(tmpMainDataObj,tmpDetailDataObj)
	.i RtnObjStr.success<0 trollback
	.i RtnObjStr.success<0 d
	..s Err=-3
	.q:Err'=0
	.s AspBatId=RtnObjStr.rowid
	.i (AspBatId="") s Err=-4
	.q:Err'=0
	.s Params=AdjUserId_"^"_GrpId_"^"_LocId
	.s RtnObjStr2=##class(web.DHCSTMHUI.INAdjPriceBatch).Audit(AspBatId,Params)
	.i RtnObjStr2.success'=0 trollback
	.i RtnObjStr2.success'=0 d
	..s Err=-5
	.q:Err'=0
	.tcommit
	q Err
}

// Descript:	同步供应商

/// Creator:	lihui
/// CreateDate:	20200414
/// Input:	[{},{}]	
/// Return:	[0:"",1:失败信息]
/// w ##class(web.DHCSTMService.HRP.In2OutServiceImpl).SaveVendorData("<VendorList><VendorData><HospitalCode>DHSZHYY</HospitalCode><VendorCode>代码1</VendorCode><VendorDesc>名称1345</VendorDesc><VendorUseFlag>Y</VendorUseFlag><VendorAlias>助记码1</VendorAlias><VendorCorporation>法人1</VendorCorporation><VendorPresident>法人身份证1</VendorPresident><VendorPreTel>法人联系电话1</VendorPreTel><VendorAcct>账户1</VendorAcct><VendorBank>开户银行1</VendorBank><VendorCrAvail>100</VendorCrAvail><VendorlstPoDate>2025-05-06</VendorlstPoDate><VendorAdd>供应商地址1</VendorAdd><VendorTel>供应商电话1</VendorTel><VendorFax>传真1</VendorFax><VendorAbbrev>供应商简称1</VendorAbbrev></VendorData><VendorData><HospitalCode>DHSZHYY</HospitalCode><VendorCode>代码2</VendorCode><VendorDesc>名称2</VendorDesc><VendorUseFlag>Y</VendorUseFlag><VendorAlias>助记码2</VendorAlias><VendorCorporation>法人2</VendorCorporation><VendorPresident>法人身份证2</VendorPresident><VendorPreTel>法人联系电话2</VendorPreTel><VendorAcct>账户2</VendorAcct><VendorBank>开户银行2</VendorBank><VendorCrAvail>200</VendorCrAvail><VendorlstPoDate>2025-05-06</VendorlstPoDate><VendorAdd>供应商地址2</VendorAdd><VendorTel>供应商电话2</VendorTel><VendorFax>传真233</VendorFax><VendorAbbrev>供应商简称233</VendorAbbrev></VendorData></VendorList>")
ClassMethod SaveVendorData(Input) As %GlobalCharacterStream
{
	n (Input)
	s InputStream=##class(%GlobalCharacterStream).%New()
	i '$ISOBJECT(Input) d
	.d InputStream.Write(Input)
	e  d
	.d InputStream.CopyFrom(Input)
	d InputStream.Rewind()
	s Pid=$i(^DHCSTMPID("PID"))
	k ^TMPDHCSTM("TMPDHCSTMERR",Pid)
	s RetStream=##class(%GlobalCharacterStream).%New()
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(InputStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	d reader.Correlate("VendorList","web.DHCSTMService.HRP.Model.VendorList")
	s ListObj=##class(web.DHCSTMService.HRP.Model.VendorList).%New()
	s ListAllObj=##class(web.DHCSTMService.HRP.Model.VendorList).%New()
	while reader.Next(.ListObj,.sc){
		s ListAllObj=ListObj
	}
	s VendorCount=ListAllObj.VendorData.Count()
	f i=1:1:VendorCount  d
	.s ErrMsg=""
	.s VendorDataObj=##class(web.DHCSTMService.HRP.Model.VendorData).%New()
	.s VendorDataObj=ListAllObj.VendorData.GetAt(i)
	.s HospitalCode=VendorDataObj.HospitalCode
	.s VendorCode=VendorDataObj.VendorCode
	.s VendorDesc=VendorDataObj.VendorDesc
	.s VendorUseFlag=VendorDataObj.VendorUseFlag
	.s VendorAlias=VendorDataObj.VendorAlias
	.s VendorCorporation=VendorDataObj.VendorCorporation
	.s VendorPresident=VendorDataObj.VendorPresident
	.s VendorPreTel=VendorDataObj.VendorPreTel
	.s VendorAcct=VendorDataObj.VendorAcct
	.s VendorBank=VendorDataObj.VendorBank
	.s VendorCrAvail=+VendorDataObj.VendorCrAvail
	.s VendorlstPoDate=VendorDataObj.VendorlstPoDate
	.s VendorAdd=VendorDataObj.VendorAdd
	.s VendorTel=VendorDataObj.VendorTel
	.s VendorFax=VendorDataObj.VendorFax
	.s VendorAbbrev=VendorDataObj.VendorAbbrev
	.s:VendorlstPoDate'="" VendorlstPoDate=$zd(VendorlstPoDate,3)
	.i VendorUseFlag="Y" s VendorUseFlag="A"
	.e  s VendorUseFlag="S"
	.s HospId=##class(web.DHCSTMService.HRP.CommonInfo).ComHosp(HospitalCode)
	.i (HospitalCode="")||(HospId="")
	..s ErrMsg="第"_i_"条医院编码为空"_VendorCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i VendorCode="" d
	..s ErrMsg="第"_i_"条代码为空"_VendorCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i VendorDesc="" d
	..s ErrMsg="第"_i_"条名称为空"_VendorDesc
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s VendorId=""
	.&sql(SELECT apcvm_rowid into :VendorId FROM APC_Vendor WHERE APCVM_Code=:VendorCode)
	.s mainData1=VendorId_"^"_VendorCode_"^"_VendorDesc_"^"_VendorTel_"^"_VendorBank_"^"_VendorAcct_"^"_VendorFax
	.s mainData2=VendorCorporation_"^"_VendorPresident_"^"_VendorUseFlag_"^"_VendorCrAvail_"^"_VendorlstPoDate
	.s mainData3=VendorAdd_"^"_VendorAbbrev_"^"_VendorPreTel_"^"_VendorAlias_"^"_HospId
	.s mainData=mainData1_"^"_mainData2_"^"_mainData3
	.s mainTitle1="RowId^VendorCode^VendorDesc^Tel^Bank^CtrlAcct^Fax"
	.s mainTitle2="President^PresidentCard^Status^CrAvail^LstPoDate"
	.s mainTitle3="Address^Abbrev^PresidentTel^VendorAlias^BDPHospital"
	.s mainTitle=mainTitle1_"^"_mainTitle2_"^"_mainTitle3
	.s mainDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(mainData,mainTitle)
	.s ^TMPDHCSTM("TMPDHCSTM",Pid,i)=mainDataObj	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s BillSub=0
	f  s BillSub=$o(^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)) q:(BillSub="")  d
	.s mainData=^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)
	.s RtnObj=##class(web.DHCSTMHUI.APCVenNew).Save(mainData,"","","")
	.s PJObjret=##class(web.DHCSTMHUI.Common.FromJson).%New()
	.s Sc=PJObjret.%FromJSON(RtnObj)
	.s success=PJObjret.%Get("success")
	.s msg=PJObjret.%Get("msg")
	.i success<0 d
	..s ErrMsg="第"_BillSub_"条保存失败,"_msg
	..d ..RecordErrInfo(Pid,ErrMsg)
	.e  d
	..s ErrMsg="第"_BillSub_"条保存成功"
	..d ..RecordErrInfo(Pid,ErrMsg)	
	s retInfo=""
	s i=0
	f  s i=$o(^TMPDHCSTM("TMPDHCSTMERR",Pid,i)) q:i=""  d
	.s ErrMsg=^TMPDHCSTM("TMPDHCSTMERR",Pid,i)
	.i retInfo="" d
	..s retInfo=ErrMsg
	.e  d
	..s retInfo=retInfo_";"_ErrMsg
	s RetStream=..OutResultxml(0,retInfo)
	k ^TMPDHCSTM("TMPDHCSTMERR",Pid)
	q RetStream
}

/// Descript:	同步生产厂家
/// Creator:	lihui
/// CreateDate:	20200414
/// Input:	[{},{}]	
/// Return:	[0:"",1:失败信息]
/// w ##class(web.DHCSTMService.HRP.In2OutServiceImpl).SaveManfData("<ManfList><ManfData><HospitalCode>DHSZHYY</HospitalCode><ManfCode>生产厂家Code1</ManfCode><ManfDesc>生产厂家名称133334</ManfDesc><ManfUseFlag>Y</ManfUseFlag><ManfAdd>生产厂家地址1</ManfAdd><ManfPhone>生产厂家电话1</ManfPhone></ManfData><ManfData><HospitalCode>DHSZHYY</HospitalCode><ManfCode>生产厂家Code2</ManfCode><ManfDesc>生产厂家名称2</ManfDesc><ManfUseFlag>Y</ManfUseFlag><ManfAdd>生产厂家地址2</ManfAdd><ManfPhone>生产厂家电话2</ManfPhone></ManfData></ManfList>")
ClassMethod SaveManfData(Input) As %GlobalCharacterStream
{
	n (Input)
	s InputStream=##class(%GlobalCharacterStream).%New()
	i '$ISOBJECT(Input) d
	.d InputStream.Write(Input)
	e  d
	.d InputStream.CopyFrom(Input)
	d InputStream.Rewind()
	s Pid=$i(^DHCSTMPID("PID"))
	k ^TMPDHCSTM("TMPDHCSTMERR",Pid)
	s RetStream=##class(%GlobalCharacterStream).%New()
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(InputStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	d reader.Correlate("ManfList","web.DHCSTMService.HRP.Model.ManfList")
	s ListObj=##class(web.DHCSTMService.HRP.Model.ManfList).%New()
	s ListAllObj=##class(web.DHCSTMService.HRP.Model.ManfList).%New()
	while reader.Next(.ListObj,.sc){
		s ListAllObj=ListObj
	}
	s ManfCount=ListAllObj.ManfData.Count()
	f i=1:1:ManfCount  d
	.s ErrMsg=""
	.s ManfDataObj=##class(web.DHCSTMService.HRP.Model.ManfData).%New()
	.s ManfDataObj=ListAllObj.ManfData.GetAt(i)
	.s HospitalCode=ManfDataObj.HospitalCode
	.s ManfCode=ManfDataObj.ManfCode
	.s ManfDesc=ManfDataObj.ManfDesc
	.s ManfUseFlag=ManfDataObj.ManfUseFlag
	.s ManfAdd=ManfDataObj.ManfAdd
	.s ManfPhone=ManfDataObj.ManfPhone
	.s HospId=##class(web.DHCSTMService.HRP.CommonInfo).ComHosp(HospitalCode)
	.i (HospitalCode="")||(HospId="")
	..s ErrMsg="第"_i_"条医院编码为空"_ManfCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i ManfCode="" d
	..s ErrMsg="第"_i_"条代码为空"_ManfCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i ManfDesc="" d
	..s ErrMsg="第"_i_"条名称为空"_ManfDesc
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s ManfId=""
	.&sql(SELECT PHMNF_RowId into :ManfId FROM PH_Manufacturer WHERE PHMNF_Code=:ManfCode)
	.s mainData=ManfId_"^"_ManfCode_"^"_ManfDesc_"^"_ManfAdd_"^"_ManfPhone_"^"_ManfUseFlag_"^"_HospId
	.s mainTitle="RowId^ManfCode^ManfDesc^Address^Tel^Status^BDPHospital"
	.s mainDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(mainData,mainTitle)
	.s ^TMPDHCSTM("TMPDHCSTM",Pid,i)=mainDataObj	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s BillSub=0
	f  s BillSub=$o(^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)) q:(BillSub="")  d
	.s mainData=^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)
	.s RtnObj=##class(web.DHCSTMHUI.ItmManfNew).Save(mainData,"")
	.s PJObjret=##class(web.DHCSTMHUI.Common.FromJson).%New()
	.s Sc=PJObjret.%FromJSON(RtnObj)
	.s success=PJObjret.%Get("success")
	.s msg=PJObjret.%Get("msg")
	.i success<0 d
	..s ErrMsg="第"_BillSub_"条保存失败,"_msg
	..d ..RecordErrInfo(Pid,ErrMsg)
	.e  d
	..s ErrMsg="第"_BillSub_"条保存成功"
	..d ..RecordErrInfo(Pid,ErrMsg)	
	s retInfo=""
	s i=0
	f  s i=$o(^TMPDHCSTM("TMPDHCSTMERR",Pid,i)) q:i=""  d
	.s ErrMsg=^TMPDHCSTM("TMPDHCSTMERR",Pid,i)
	.i retInfo="" d
	..s retInfo=ErrMsg
	.e  d
	..s retInfo=retInfo_";"_ErrMsg
	s RetStream=..OutResultxml(0,retInfo)
	k ^TMPDHCSTM("TMPDHCSTMERR",Pid)
	q RetStream
}

/// Input:		科室批次Id,条码号
/// Output:     
/// Return：
/// w ##class(web.DHCSTMService.HRP.In2OutServiceImpl).HandleBarcode()
ClassMethod HandleBarcode(inclb As %String, barcode As %String, user As %String, Qty As %String) As %String
{
	n (inclb,barcode,user,Qty)
	s Rtn=0
	//注册
	s inci=+inclb
	s data=inci_"^"
	s trackid=$o(^DHCIT(0,"ORIGINALCODE",barcode,""))
	s:trackid="" trackid=$o(^DHCIT(0,"LABEL",barcode,""))
	i (Qty<0)&&(trackid="") s Rtn=-2 q Rtn ;条码不存在
	s newStatus=""
	s stkGrpId=""
	s date=+$h
	s time=$P($h,",",2)
	//绑定
	s il=$p(inclb,"||",2),lb=$p(inclb,"||",3)
	s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
	s vendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetInclbVend(inclb,+$h)
	s vendor=$p(vendorInfo,"^",1)	;取最后入库供应商,可能不准确,仅供参考	
	i (Qty>0) d
	.s newStatus="Enable"
	.i trackid="" d
	..s trackid=##class(web.DHCSTMHUI.DHCItmTrack).RegOne(data,user,stkGrpId,date,time)	
	.i trackid<0 s Rtn=-1 q 
	.s obj=##class(User.DHCItmTrack).%OpenId(trackid)
	.s obj.DHCITOriginalCode=obj.DHCITLabel  ;保存8.3生成条码
	.s obj.DHCITLabel=barcode  ;保存8.4条码
	.;s obj.DHCITOriginalCode=barcode
	.s obj.DHCITStatus=newStatus
	.d obj.DHCITINCIBDRSetObjectId(incib)
	.d obj.DHCITINCLBDRSetObjectId(vendor)
	.d obj.DHCITINCLBDRSetObjectId(inclb)
	.s sc=obj.%Save()
	.i $$$ISERR(sc) s Rtn=-2
	e  d
	.s newStatus="InAdj"
	.s obj=##class(User.DHCItmTrack).%OpenId(trackid)
	.s obj.DHCITStatus=newStatus
	.d obj.DHCITINCIBDRSetObjectId(incib)
	.d obj.DHCITINCLBDRSetObjectId(vendor)
	.d obj.DHCITINCLBDRSetObjectId(inclb)	
	.s sc=obj.%Save()
	.i $$$ISERR(sc) s Rtn=-2
	q Rtn
}

/// 首先将所有批次的库存调整成0，然后增加新的批次库存
/// 同一个耗材所有库存只调整一次
/// 
ClassMethod SaveStock(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	n (Input)
	s RetStream=##class(%GlobalCharacterStream).%New()
	s Pid=$i(^DHCSTMPID("PID"))
	k ^TMPDHCSTM("TMPDHCSTM",Pid),^TMPDHCSTM("TMPDHCSTMERR",Pid)
	s InputStream=##class(%GlobalCharacterStream).%New()
	i '$ISOBJECT(Input) d
	.d InputStream.Write(Input)
	e  d
	.d InputStream.CopyFrom(Input)
	d InputStream.Rewind()
	s ErrorMsg=""
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(InputStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) q ..OutResultxml(1,"入参解析有误")
	d reader.Correlate("LocAdjBills","web.DHCSTMService.HRP.Model.LocAdjBills")
	s LocAdjBillsObj=##class(web.DHCSTMService.HRP.Model.LocAdjBills).%New()
	s LocAdjBillsRetObj=##class(web.DHCSTMService.HRP.Model.LocAdjBills).%New()
	while reader.Next(.LocAdjBillsObj,.sc){
		s LocAdjBillsRetObj=LocAdjBillsObj
	}
	s LocAdjBillsCount=LocAdjBillsRetObj.BillList.Count()
	s succount=0
	f BillSub=1:1:LocAdjBillsCount  d
	.s LocAdjBillObj=##class(web.DHCSTMService.HRP.Model.LocAdjBill).%New()
	.s LocAdjBillObj=LocAdjBillsRetObj.BillList.GetAt(BillSub)
	.s LocDesc=LocAdjBillObj.LocDesc
	.s Remarks=LocAdjBillObj.Remarks
	.s UserInital=LocAdjBillObj.UserInital
	.s type=LocAdjBillObj.Type
	.s LocId=##class(web.DHCSTMService.HRP.CommonInfo).ComLoc(LocDesc)
	.s ErrMsg=""
	.i LocId="" d
	..s ErrMsg="第"_BillSub_"张单据,科室为空!"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s ItemCount=LocAdjBillObj.BillItemList.Count()
	.i ItemCount=0 d
	..s ErrMsg="第"_BillSub_"张单据,单据明细为空!"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s UserId=##class(web.DHCSTMService.HRP.CommonInfo).ComUser(UserInital)
	.s ScgId="",Comp="Y",State="10"
	.s AdjReason="同步库存"
	.s ReasonId=##class(web.DHCSTMService.HRP.CommonInfo).GetAdjReason(AdjReason)
	.s StkType="M"
	.s MainInfo=""
	.s $p(MainInfo,"^",1)=LocId
	.s $p(MainInfo,"^",2)=UserId
	.s $p(MainInfo,"^",3)=ReasonId
	.s $p(MainInfo,"^",4)=ScgId
	.s $p(MainInfo,"^",5)=Comp
	.s $p(MainInfo,"^",7)=State
	.s $p(MainInfo,"^",8)=Remarks
	.s mainTitle="AdjLoc^gUserId^ForAdjustReasonId^ScgStk^Complate^adjState^Remark"
	.s mainDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(MainInfo,mainTitle)
	.s ^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)=mainDataObj_"^"_LocDesc
	.s succount=0,msg=""
	.f DetailSub=1:1:ItemCount d
	..s ItemObj=##class(web.DHCSTMService.HRP.Model.LocAdjBillItem).%New()
	..s ItemObj=LocAdjBillObj.BillItemList.GetAt(DetailSub)
	..s BatId=ItemObj.BatId
	..s InciCode=ItemObj.InciCode
	..s Inci=##class(web.DHCSTMService.HRP.CommonInfo).ComInci(InciCode)
	..i +Inci'>0 d
	...s ErrMsg="物资不存在系统中,InciCode:"_InciCode 
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:Inci=""
	..s hvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..s BatchNo=ItemObj.BatchNo
	..s ExpDate=ItemObj.ExpDate
	..s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	..s Rp=ItemObj.Rp
	..s Sp=ItemObj.Sp
	..s Qty=ItemObj.Qty
	..s BarCode=ItemObj.BarCode
	..s Uom=ItemObj.Uom
	..s UomId=##class(web.DHCSTMService.HRP.CommonInfo).ComUom(Uom)
	..i UomId="" d
	...s ErrMsg=Uom_"单位不存在系统中,InciCode:"_InciCode 
	...d ..RecordErrInfo(Pid,ErrMsg)
	..s buomid=$p(^INCI(Inci,1),"^",10)
	..s puomid=$p(^INCI(Inci,3),"^",6)
	..i (UomId'=puomid)&&(buomid'=UomId) d
	...s ErrMsg=Uom_"不是物资关联单位,InciCode:"_InciCode 
	...d ..RecordErrInfo(Pid,ErrMsg)
	..s PFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,buomid)
	..s buomRp=Rp/PFac
	..i Qty'>0 d
	...s ErrMsg="库存不允许为负,InciCode:"_InciCode 
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..i (BarCode'="")&&((Qty'=1)&&(Qty'=0)) d
	...s ErrMsg=BarCode_"库存只能为1或者0，InciCode:"_InciCode 
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..i BarCode'="" d
	...i '$d(^TMPDHCSTM("TMPDHCSTMBarCode",Pid,BarCode))
	....s ^TMPDHCSTM("TMPDHCSTMBarCode",Pid,BarCode)=""
	...e  d
	....s ErrMsg=BarCode_"条码重复,InciCode:"_InciCode 
	..q:ErrMsg'=""
	..s Paramstr=BatId_"^"_InciCode_"^"_LocId_"^"_ExpDate_"^"_BatchNo_"^"_buomRp_"^"_buomRp
	..s succount=succount+1
	..s DetailData=Paramstr_"^"_Qty_"^"_UomId_"^"_Rp_"^"_Sp_"^"_BarCode_"^"_UserId
	..s ^TMPDHCSTM("TMPDHCSTM",Pid,BillSub,LocId_"^"_Inci,DetailSub)=DetailData
	..
	k ^TMPDHCSTM("TMPDHCSTMBarCode",Pid)
	q:succount=0 ..OutResultxml(0,"参数为空,请核实数据！")
	s retInfo=..GetErrMsg(Pid)
	i retInfo'="" d
	.k ^TMPDHCSTM("TMPDHCSTM",Pid)
	q:retInfo'="" ..OutResultxml(-1,retInfo)
	s Sub=0
	s Err=""
	ts
	s DetailTitle="Inclb^Qty^UomId^Rp^Sp^HvBarCode"
	f  s Sub=$o(^TMPDHCSTM("TMPDHCSTM",Pid,Sub)) q:(Sub="")||(Err'="")  d
	.;s Main=^TMPDHCSTM("TMPDHCSTM",Pid,Sub)
	.s MainInfo=^TMPDHCSTM("TMPDHCSTM",Pid,Sub)
	.s MainObj=$p(MainInfo,"^",1)
	.s LocDesc=$p(MainInfo,"^",2)
	.s LocInci=""
	.s DetailObj=""
	.f  s LocInci=$o(^TMPDHCSTM("TMPDHCSTM",Pid,Sub,LocInci)) q:(LocInci="")||(Err'="")  d
	..s Loc=$p(LocInci,"^",1)
	..s Inci=$p(LocInci,"^",2)
	..;s BarCode=$p(LocInci,"^",3)
	..;如果包含条码直接
	..s buomid=$p(^INCI(Inci,1),"^",10)
	..s il=$o(^INCI("IL_LOC",Loc,Inci,0))
	..q:il=""	;过滤垃圾数据
	..s incil=Inci_"||"_il
	..s lb=0
	..f  s lb=$o(^INCI(Inci,"IL",il,"LB",lb)) q:lb=""  d
	...s Inclb=incil_"||"_lb
	...;s err=##class(web.DHCSTMHUI.Common.StockHandle).UpdateDirtyQty(inclb,qty)  清楚暂用；清除在途
	...s IncQty=##CLASS(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,+$h)
	...s ResQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,"")
	...s AvaQty= ##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,"")
	...q:IncQty=0
	...s bQty=IncQty
	...s bQty=-bQty
	...s Incib=$P(^INCI(inci,"IL",il,"LB",lb),"^",1)
	...s Chl=$p(Incib,"||",2)
	...s dhcib=$o(^DHCINCIB(0,"INCIB",Incib,""))
	...s bRp=$P(^DHCINCIB(dhcib),"^",3)
	...s bSp=$P(^DHCINCIB(dhcib),"^",5)
	...s realDetailData=Inclb_"^"_bQty_"^"_buomid_"^"_bRp_"^"_bSp_"^"_""
	...s DetailStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(realDetailData,DetailTitle)
	...i DetailObj="" d
	....s DetailObj=DetailStr
	...e  d
	....s DetailObj=DetailObj_","_DetailStr
	.q:DetailObj=""
	.s DetailObj="["_DetailObj_"]"
	.s retInAdj=##class(web.DHCSTMHUI.DHCINAdj).SaveAdj(MainObj,DetailObj)
	.s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	.s Sc=PJObj.%FromJSON(retInAdj)
	.i PJObj.%Get("success")'=0 d 
	..s Err="科室:"_LocDesc_",库存同步失败!"
	.q:Err'=""
	.s InAdj=PJObj.%Get("rowid")
	.s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	.s UserId=1  ;demo
	.s ParamData=UserId
	.s ParamTitle="gUserId"
	.s ParamObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(ParamData,ParamTitle)
	.s RtnObj=##class(web.DHCSTMHUI.DHCINAdj).Audit(InAdj,ParamObj)
	.i RtnObj.success'=0 d
	..s Err="科室:"_LocDesc_",库存审核失败!"_RtnObj.msg
	.q:Err'=""
	
	i Err'="" tro
	i Err'="" d
	.k ^TMPDHCSTM("TMPDHCSTM",Pid)
	q:Err'="" ..OutResultxml(-2,Err)
	s Sub=0
	f  s Sub=$o(^TMPDHCSTM("TMPDHCSTM",Pid,Sub)) q:(Sub="")||(Err'="")  d
	.s MainInfo=^TMPDHCSTM("TMPDHCSTM",Pid,Sub)
	.s MainObj=$p(MainInfo,"^",1)
	.s LocDesc=$p(MainInfo,"^",2)
	.s LocInci=""
	.s DetailObjStr=""
	.f  s LocInci=$o(^TMPDHCSTM("TMPDHCSTM",Pid,Sub,LocInci)) q:(LocInci="")||(Err'="")  d
	..s DetailSub=0
	..f  s DetailSub=$o(^TMPDHCSTM("TMPDHCSTM",Pid,Sub,LocInci,DetailSub)) q:(DetailSub="")||(Err'="")  d
	...s DetailData=^TMPDHCSTM("TMPDHCSTM",Pid,Sub,LocInci,DetailSub)
	...s BatId=$P(DetailData,"^",1)
	...s InciCode=$P(DetailData,"^",2)
	...s LocId=$P(DetailData,"^",3)
	...s ExpDate=$P(DetailData,"^",4)
	...s BatchNo=$P(DetailData,"^",5)
	...s buomRp=$P(DetailData,"^",6)
	...s buomRp=$P(DetailData,"^",7)
	...s Qty=$P(DetailData,"^",8)
	...s UomId=$P(DetailData,"^",9)
	...s Rp=$P(DetailData,"^",10)
	...s Sp=$P(DetailData,"^",11)
	...s BarCode=$P(DetailData,"^",12)
	...s UserId=$P(DetailData,"^",13)
	...s Paramstr=BatId_"^"_InciCode_"^"_LocId_"^"_ExpDate_"^"_BatchNo_"^"_buomRp_"^"_buomRp
	...s incib=..GetIncib(Paramstr,"")
	...i +incib<0 d
	....s Err="代码:"_InciCode_",生成批次失败!"
	...q:Err'=""
	...s Inclb=..GetINCLB(incib,LocId)
	...i +Inclb<0 d
	....s Err="代码:"_InciCode_",生成批次失败!"
	...q:Err'=""
	...s ret=0
	...i BarCode'="" d
	....s ret=..HandleBarcode(Inclb,BarCode,UserId,Qty)
	...i ret=-3 s Err="条码重复,InciCode:"_InciCode 
	...i ret'=0 s Err="条码处理失败,InciCode:"_InciCode 
	...q:Err'=""
	...s realDetailData=Inclb_"^"_Qty_"^"_UomId_"^"_Rp_"^"_Sp_"^"_BarCode
	...s DetailObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(realDetailData,DetailTitle)
	...i DetailObjStr="" d
	....s DetailObjStr=DetailObj
	...e  d
	....s DetailObjStr=DetailObjStr_","_DetailObj
	.s DetailObjStr="["_DetailObjStr_"]"
	.q:Err'=""
	.s retInAdj=##class(web.DHCSTMHUI.DHCINAdj).SaveAdj(MainObj,DetailObjStr)
	.s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	.s Sc=PJObj.%FromJSON(retInAdj)
	.i PJObj.%Get("success")'=0 d 
	..s Err="科室:"_LocDesc_",库存同步失败!"
	..;d ..RecordErrInfo(Pid,Err)
	.q:Err'=""
	.s InAdj=PJObj.%Get("rowid")
	.s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	.s ParamData=UserId
	.s ParamTitle="gUserId"
	.s ParamObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(ParamData,ParamTitle)
	.s RtnObj=##class(web.DHCSTMHUI.DHCINAdj).Audit(InAdj,ParamObj)
	.i RtnObj.success'=0 d
	..s Err="科室:"_LocDesc_",库存审核失败!"_RtnObj.msg
	.q:Err'=""
	.s rt=..UpdateItmTrackOrAdjPrice(InAdj)
	.i rt'=0 d
	..s Err="科室:"_LocDesc_",库存调价失败失败!"
	.q:Err'=""
	k ^TMPDHCSTM("TMPDHCSTM",Pid)
	i Err'="" tro  
	q:Err'="" ..OutResultxml(0,Err)
	tc
	q ..OutResultxml(0,"成功")
}

/// 生成入库单
/// w ##class(web.DHCSTMService.HRP.SPDToMat).SaveInGdRec("<InGdRecList><InGdRecMain><HospitalCode/><FromLocCode>2031500</FromLocCode><VenCode>M00025</VenCode><UserCode/><SpdIngrNo>173025</SpdIngrNo><InGdRecDetail><InciCode>YLCL00001</InciCode><uomDesc>套</uomDesc><Qty>2</Qty><Rp>4500</Rp><ManfCode/><ExpDate>2023-01-19 00:00:00</ExpDate><BatNo>MLBY410S2</BatNo><SpdDetailId>NBSYYY_CONSUME_29419</SpdDetailId><productionDate>2018-01-19 00:00:00</productionDate></InGdRecDetail></InGdRecMain></InGdRecList>")
ClassMethod SaveInGdRec(Input) As %GlobalCharacterStream
{
	n (Input)
	s RetStream=##class(%GlobalCharacterStream).%New()
	s Pid=..NewPid()
	k ^TMPDHCSTM("TMPDHCSTM",Pid),^TMPDHCSTM("TMPDHCSTMERR",Pid)
	s InputStream=##class(%GlobalCharacterStream).%New()
	i '$ISOBJECT(Input) d
	.d InputStream.Write(Input)
	e  d
	.d InputStream.CopyFrom(Input)
	d InputStream.Rewind()
	s ErrMsg=""
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(InputStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) q ..OutResultxml(1,"入参解析有误")
	d reader.Correlate("InGdRecList","web.DHCSTMService.HRP.Model.InGdRecList")
	s InGdRecListObj=##class(web.DHCSTMService.HRP.Model.InGdRecList).%New()
	s InGdRecListRetObj=##class(web.DHCSTMService.HRP.Model.InGdRecList).%New()
	while reader.Next(.InGdRecListObj,.sc){
		s InGdRecListRetObj=InGdRecListObj
	}
	s succount=0,Sub=0
	s InGdRecCount=InGdRecListRetObj.InGdRecMain.Count()
	s mainTitle="RecLoc^ApcvmDr^ReqLocId^gUserId^SynBarcode^gHospId"
	s detailtitle="IncId^RecQty^Rp^NewSp^BatchNo^ExpDate^ManfId^IngrUomId^InvNo^InvDate^OrderDetailSubId^reqLocId"
	f Sub=1:1:InGdRecCount  q:ErrMsg'=""  d
	.s InGdRecObj=##class(web.DHCSTMService.HRP.Model.InGdRecMain).%New()
	.s InGdRecObj=InGdRecListRetObj.InGdRecMain.GetAt(Sub)
	.s apccode=InGdRecObj.VenCode
	.s FromLocCode=InGdRecObj.FromLocCode
	.s ToLocCode=InGdRecObj.ToLocCode
	.s UserCode=InGdRecObj.UserCode
	.s SPDNO=InGdRecObj.SpdIngrNo
	.i apccode="" d
	..s ErrMsg="第"_Sub_"张单据供应商为空!"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i FromLocCode="" d
	..s ErrMsg="第"_Sub_"张单据库房为空!"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s apcvmid=##class(web.DHCSTMService.HRP.CommonInfo).ComApc(apccode)
	.s RecLocId=##class(web.DHCSTMService.HRP.CommonInfo).ComLoc(FromLocCode)
	.s userid=##class(web.DHCSTMService.HRP.CommonInfo).ComUser(UserCode)
	.s:userid="" userid=1
	.i apcvmid="" d
	..s ErrMsg="第"_Sub_"张供应商代码不存在!"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.i RecLocId="" d
	..s ErrMsg="第"_Sub_"张库房代码不存在!"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s Hospid=$p(^CTLOC(RecLocId),"^",22)
	.s mainData=RecLocId_"^"_apcvmid_"^"_""_"^"_userid_"^"_SPDNO_"^"_Hospid
	.s ^TMPDHCSTM("TMPDHCSTM",Pid,Sub)=mainData
	.s detailcount=InGdRecObj.InGdRecDetail.Count()
	.f ch=1:1:detailcount  q:ErrMsg'=""  d
	..s InGdRecDetialObj=##class(web.DHCSTMService.HRP.Model.InGdRecDetail).%New()
	..s InGdRecDetialObj=InGdRecObj.InGdRecDetail.GetAt(ch)
	..s InciCode=InGdRecDetialObj.InciCode
	..s Qty=InGdRecDetialObj.Qty
	..s Rp=InGdRecDetialObj.Rp
	..s BatNo=InGdRecDetialObj.BatNo
	..s ExpDate=InGdRecDetialObj.ExpDate
	..s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	..s ManfCode=InGdRecDetialObj.ManfCode
	..s PruductDate=InGdRecDetialObj.productionDate
	..s spddetailID=InGdRecDetialObj.SpdDetailId
	..s uomDesc=InGdRecDetialObj.uomDesc
	..s Invno=InGdRecDetialObj.Invno
	..s InvDate=InGdRecDetialObj.InvDate
	..s:InvDate'="" InvDate=$zd(InvDate,3)
	..
	..i InciCode=""  d
	...s ErrMsg="第"_Sub_"||"_ch_"张物资代码不能为空!"
	...d ..RecordErrInfo(Pid,ErrMsg)
	..i uomDesc="" d
	...s ErrMsg="第"_Sub_"||"_ch_"张物资单位不能为空!"
	...d ..RecordErrInfo(Pid,ErrMsg)
	..i Qty'>0 d
	...s ErrMsg="第"_Sub_"||"_ch_"张入库数量不能少于0!"
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s inci=##class(web.DHCSTMService.HRP.CommonInfo).ComInci(InciCode)
	..i inci="" d
	...s ErrMsg="第"_Sub_"||"_ch_"张物资代码对照错误!"
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s Manf=""
	..s:ManfCode'="" Manf=##class(web.DHCSTMService.HRP.CommonInfo).ComManf(ManfCode)
	..s UomId=##class(web.DHCSTMService.HRP.CommonInfo).ComUom(uomDesc)
	..i UomId="" d
	...s ErrMsg="第"_Sub_"||"_ch_"张单位对照错误!"
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s buomid=$p(^INCI(inci,1),"^",10)
	..s puomid=$p(^INCI(inci,3),"^",6)
	..i (UomId'=puomid)&&(buomid'=UomId) d
	...s ErrMsg=uomDesc_"不是物资关联单位,InciCode:"_InciCode 
	...d ..RecordErrInfo(Pid,ErrMsg)
	..;
	..s detailtitle="IncId^RecQty^Rp^NewSp^BatchNo^ExpDate^ManfId^IngrUomId^InvNo^InvDate^OrderDetailSubId^reqLocId^Sp"
	..s detailData=inci_"^"_Qty_"^"_Rp_"^"_Rp_"^"_BatNo_"^"_ExpDate_"^"_Manf_"^"_UomId_"^"_Invno_"^"_InvDate_"^"_spddetailID_"^"_""_"^"_Rp
	..s detailDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(detailData,detailtitle)
	..s ^TMPDHCSTM("TMPDHCSTM",Pid,Sub,ch)=detailDataObj
	..s succount=succount+1
	s retInfo=..GetErrMsg(Pid)
	i retInfo'="" d
	.k ^TMPDHCSTM("TMPDHCSTM",Pid)
	q:retInfo'="" ..OutResultxml(-1,retInfo)
	q:succount=0 ..OutResultxml(0,"参数为空,请核实数据！")
	s Err=0
	ts
	s BillSub=0
	f  s BillSub=$o(^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)) q:(BillSub="")||(Err'=0)  d
	.s mainData=^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)
	.s paramtitle="gUserId^gGroupId^gHospId"
	.s userid=$p(mainData,"^",4)
	.s hospid=$p(mainData,"^",6)
	.s toLoc=$p(mainData,"^",3)
	.s $p(mainData,"^",3)=""
	.s paramstr=userid_"^^"_hospid
	.s paramobj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(paramstr,paramtitle)
	.s mainDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(mainData,mainTitle)
	.s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	.s detailobj=""
	.s DetailSub=0
	.f  s DetailSub=$o(^TMPDHCSTM("TMPDHCSTM",Pid,BillSub,DetailSub)) q:(DetailSub="")||(Err'=0)  d
	..s DetailData=^TMPDHCSTM("TMPDHCSTM",Pid,BillSub,DetailSub)
	..i detailobj="" d
	...s detailobj=DetailData
	..e  d
	...s detailobj=detailobj_","_DetailData
	.s detailobj="["_detailobj_"]"
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Save(mainDataObj,detailobj)
	.i RtnObj.success'=0 d
	..s Err=RtnObj.success
	.q:Err'=0
	.s IngrId=RtnObj.rowid
	.i $p(^DHCINGR(IngrId),"^",12)'="Y" d
	..;完成入库单
	..s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).MakeComplete(IngrId,paramobj,"")
	.i RtnObj.success'=0 d
	..s Err=RtnObj.success
	.q:Err'=0
	.s AuditFlag=$p(^DHCINGR(IngrId),"^",29)
	.i AuditFlag'="Y" d
	..s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Audit(IngrId,paramobj,"")
	.i RtnObj.success'=0 d
	..s Err=RtnObj.success
	k ^TMPDHCSTM("TMPDHCSTM",Pid)
	i Err'=0 tro  
	q:Err'=0 ..OutResultxml(0,Err)
	tc
	q ..OutResultxml(0,"成功")
}

ClassMethod UpdateInvno(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	n (Input)
	s ^tmphousc("fdadfadfa")=Input
	s RetStream=##class(%GlobalCharacterStream).%New()
	s Pid=..NewPid()
	k ^TMPDHCSTM("TMPDHCSTM",Pid),^TMPDHCSTM("TMPDHCSTMERR",Pid)
	s InputStream=##class(%GlobalCharacterStream).%New()
	i '$ISOBJECT(Input) d
	.d InputStream.Write(Input)
	e  d
	.d InputStream.CopyFrom(Input)
	d InputStream.Rewind()
	s ErrMsg=""
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(InputStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) q ..OutResultxml(1,"入参解析有误")
	d reader.Correlate("InvList","web.DHCSTMService.HRP.Model.InvList")
	s InvListObj=##class(web.DHCSTMService.HRP.Model.InvList).%New()
	s InvListRetObj=##class(web.DHCSTMService.HRP.Model.InvList).%New()
	while reader.Next(.InvListObj,.sc){
		s InvListRetObj=InvListObj
	}
	s succount=0
	s Ret=0
	ts
	s InvListCount=InvListRetObj.InvDetail.Count()
	f Sub=1:1:InvListCount  q:Ret'=0  d
	.s InvnoDetailObj=##class(web.DHCSTMService.HRP.Model.InvDetail).%New()
	.s InvnoDetailObj=InvListRetObj.InvDetail.GetAt(Sub)
	.s invno=InvnoDetailObj.Invno
	.q:invno=""
	.s InvSetDate=+$h
	.s invdate=InvnoDetailObj.InvDate
	.s invdate="" 
	.s detaiId=InvnoDetailObj.SpdDetailId
	.&sql(update dhc_ingdrecitm set initm_invno=:invNo,
		initm_invdate=:invDate,initm_InvSetDate=:InvSetDate where initm_OrderDetailSubId=:detaiId)
	.i SQLCODE'=0 d
	..s Ret=-1
	i Ret'=0 tro
	q:Ret'=0 ..OutResultxml(Ret,"失败")
	tc
	q ..OutResultxml(0,"成功")
}

/// 取出批次的创建日期
/// Date:2015-07-14
/// Created By :zhwh
/// 
/// Arguments:
///  inclb -批次rowid
/// Return:
///   
ClassMethod GetClbDate(incib) As %String
{
	n (incib)
	&sql(SELECT incib_dateadd,incib_timeadd into :d,:t  FROM dhc_incitmbat WHERE INCIB_INCIB_DR=:incib)	
	i $g(d)="" s d=+$h-500
	i $g(t)=""  s t=1
	s str=$tr($j(d,5)_$j(t,5)," ","0")
	q str
}

/// CreatDate:2012-07-24
/// Description:按效期优先的规则匹配本次出库批次
/// Table:inc_itmlcbt
/// Input:科室id,库存项id,数量,出类型
/// Return:
ClassMethod GetInclbForTransfer(LocId As %String, IncId As %String, Qty As %String, OutType As %String = "", SpecDesc As %String = "", Rp As %String = "") As %Library.String
{
	n (LocId,IncId,Qty,OutType,SpecDesc,Rp)
	i $g(OutType)="" s OutType="0"  //缺省使用效期先后做出库顺序
	q:'$d(^INCI("IL_LOC",LocId,IncId)) ""
	s Pid=..NewPid()
	k ^TMPGETINCLB(Pid),^DHCTMPYFINCLB(Pid)
	s NewQty=Qty
	s IL=$o(^INCI("IL_LOC",LocId,IncId,""))
	s LB=0
	s Today=+$h
	f  s LB=$o(^INCI(IncId,"IL",IL,"LB",LB)) q:LB=""  d
	.s Inclb=IncId_"||"_IL_"||"_LB
	.s Incib=""
	.s Incib=$P(^INCI(IncId,"IL",IL,"LB",LB),"^",1)
	.s Chl=$p(Incib,"||",2)
	.s dhcib=$o(^DHCINCIB(0,"INCIB",Incib,""))
	.s PurRp=$P(^DHCINCIB(dhcib),"^",4)
	.q:PurRp'=Rp
	.s ExpDays=0      ;失效天数
	.s ExpDate=+$p(^INCI(IncId,"IB",Chl),"^",2)
	.i ExpDate=0  d
	..s ExpDate=+$h+500
	.i ExpDate=+$h  s ExpDays=1
	.e  s ExpDays=ExpDate-(+$h)
	.s IncQty=##CLASS(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,Today)
	.s ResQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,"")
	.s AvaQty= ##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,"")
	.q:AvaQty'>0
	.s BatNo=$p(^INCI(IncId,"IB",Chl),"^",1)
	.s ExpDate=$p(^INCI(IncId,"IB",Chl),"^",2)
	.s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	.s RecallFlag=$p(^INCI(IncId,"IB",Chl),"^",3)
	.q:RecallFlag="Y"   //批次锁定的不做出库单
	.s InclbSpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(Inclb)
	.s Data=BatNo_"^"_IncQty_"^"_ExpDate_"^"_Inclb_"^"_ResQty_"^"_AvaQty
	.
	.i $g(OutType)="1" d   //先进先出
	..s Sub=..GetClbDate(Incib)
	.e  i $g(OutType)="0" d  //效期先后
	..s Sub=ExpDays
	.;2017-12-27 若具体规格不一致,则往后排
	.;(以保证具体规格对应的批次库存不足时,能取其他批次的数据)
	.i (SpecDesc'="")&&(InclbSpecDesc'=SpecDesc) d
	..s Sub=ExpDays+9999900000		;这里是根据GetClbDate的格式确定的
	.s ^DHCTMPYFINCLB(Pid,Sub,Inclb)=Data
	s Sub=""
	f  s Sub=$o(^DHCTMPYFINCLB(Pid,Sub)) q:(Sub="")!(NewQty=0)  d
	.s Inclb=""
	.f  s Inclb=$o(^DHCTMPYFINCLB(Pid,Sub,Inclb)) q:(Inclb="")!(NewQty=0)  d
	..s Data=^DHCTMPYFINCLB(Pid,Sub,Inclb)
	..s ^TMPGETINCLB(Pid,Inclb)=Data
	..s AvaQty=$p(Data,"^",6)
	..q:AvaQty<=0
	..i AvaQty'<NewQty  d
	...s $p(^TMPGETINCLB(Pid,Inclb),"^",7)=NewQty    ;批次转移数量
	...s NewQty=0  
	..e  d
	...s $p(^TMPGETINCLB(Pid,Inclb),"^",7)=AvaQty    ;批次转移数量                                       
	...s NewQty=NewQty-AvaQty
	k ^DHCTMPYFINCLB(Pid)
	q Pid
}

ClassMethod SaveInIsTrf(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	n (Input)
	s ^tmphousc("fdadfadfb")=Input
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s RetStream=##class(%GlobalCharacterStream).%New()
	s Pid=..NewPid()
	k ^TMPDHCSTM("TMPDHCSTM",Pid),^TMPDHCSTM("TMPDHCSTMERR",Pid)
	s InputStream=##class(%GlobalCharacterStream).%New()
	i '$ISOBJECT(Input) d
	.d InputStream.Write(Input)
	e  d
	.d InputStream.CopyFrom(Input)
	d InputStream.Rewind()
	s ErrMsg=""
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(InputStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) q ..OutResultxml(1,"入参解析有误")
	d reader.Correlate("InGdRecList","web.DHCSTMService.HRP.Model.InGdRecList")
	s InGdRecListObj=##class(web.DHCSTMService.HRP.Model.InGdRecList).%New()
	s InGdRecListRetObj=##class(web.DHCSTMService.HRP.Model.InGdRecList).%New()
	while reader.Next(.InGdRecListObj,.sc){
		s InGdRecListRetObj=InGdRecListObj
	}
	s succount=0
	s InGdRecCount=InGdRecListRetObj.InGdRecMain.Count()
	s mainTitle="RecLoc^ApcvmDr^ReqLocId^gUserId^SynBarcode^gHospId"
	s detailtitle="IncId^RecQty^Rp^NewSp^BatchNo^ExpDate^ManfId^IngrUomId^InvNo^InvDate^OrderDetailSubId^reqLocId"
	s sub=0
	f Sub=1:1:InGdRecCount  q:ErrMsg'=""  d
	.s InGdRecObj=##class(web.DHCSTMService.HRP.Model.InGdRecMain).%New()
	.s InGdRecObj=InGdRecListRetObj.InGdRecMain.GetAt(Sub)
	.s FromLocCode=InGdRecObj.FromLocCode
	.s ToLocCode=InGdRecObj.ToLocCode
	.s UserCode=InGdRecObj.UserCode
	.i FromLocCode="" d
	..s ErrMsg="第"_Sub_"张单据库房为空!"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i ToLocCode="" d
	..s ErrMsg="第"_Sub_"张单据接收科室为空!"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s RecLocId=##class(web.DHCSTMService.HRP.CommonInfo).ComLoc(FromLocCode)
	.s toLocId=##class(web.DHCSTMService.HRP.CommonInfo).ComLoc(ToLocCode)
	.s userid=##class(web.DHCSTMService.HRP.CommonInfo).ComUser(UserCode)
	.s:userid="" userid=1
	.i RecLocId="" d
	..s ErrMsg="第"_Sub_"张库房代码不存在!"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.i toLocId="" d
	..s ErrMsg="第"_Sub_"张出库科室代码不存在!"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s Hospid=$p(^CTLOC(RecLocId),"^",22)
	.s mainData=RecLocId_"^"_userid_"^"_toLocId_"^"_Hospid
    .s ^TMPDHCSTM("TMPDHCSTM",Pid,Sub)=mainData
	.s detailcount=InGdRecObj.InGdRecDetail.Count()
	.f ch=1:1:detailcount  q:ErrMsg'=""  d
	..s InGdRecDetialObj=##class(web.DHCSTMService.HRP.Model.InGdRecDetail).%New()
	..s InGdRecDetialObj=InGdRecObj.InGdRecDetail.GetAt(ch)
	..s InciCode=InGdRecDetialObj.InciCode
	..s Qty=InGdRecDetialObj.Qty
	..s Rp=InGdRecDetialObj.Rp
	..s uomDesc=InGdRecDetialObj.uomDesc
	..i InciCode=""  d
	...s ErrMsg="第"_Sub_"||"_ch_"张物资代码不能为空!"
	...d ..RecordErrInfo(Pid,ErrMsg)
	..i uomDesc="" d
	...s ErrMsg="第"_Sub_"||"_ch_"张物资单位不能为空!"
	...d ..RecordErrInfo(Pid,ErrMsg)
	..i Qty'>0 d
	...s ErrMsg="第"_Sub_"||"_ch_"张出库数量不能少于0!"
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s inci=##class(web.DHCSTMService.HRP.CommonInfo).ComInci(InciCode)
	..i inci="" d
	...s ErrMsg="第"_Sub_"||"_ch_"张物资代码对照错误!"
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
    ..s UomId=##class(web.DHCSTMService.HRP.CommonInfo).ComUom(uomDesc)
	..i UomId="" d
	...s ErrMsg="第"_Sub_"||"_ch_"张单位对照错误!"
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	
	..s buomid=$p(^INCI(inci,1),"^",10)
	..s puomid=$p(^INCI(inci,3),"^",6)
	..i (UomId'=puomid)&&(buomid'=UomId) d
	...s ErrMsg=uomDesc_"不是物资关联单位,InciCode:"_InciCode 
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..;s PFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,buomid)
	..s detailData=inci_"^"_Qty_"^"_Rp_"^"_UomId
	.s ^TMPDHCSTM("TMPDHCSTM",Pid,Sub,ch)=detailData
	.s succount=succount+1
	q:succount=0 ..OutResultxml(0,"参数为空,请核实数据！")
	s retInfo=..GetErrMsg(Pid)
	i retInfo'="" d
	.k ^TMPDHCSTM("TMPDHCSTM",Pid)
	q:retInfo'="" ..OutResultxml(-1,retInfo)
	s OperDesc="正常出库",OperStkType="OM"
    &sql(select %id into :OpTypeId from dhc_operatetype where ipt_desc=:OperDesc and ipt_type=:OperStkType)
    s OpTypeId=$g(OpTypeId)
    s Complete="N"
    s Status="10"
    s remark=""
	s ErrDetail=""
	ts
	s Err=0
	s BillSub=0
	f  s BillSub=$o(^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)) q:(BillSub="")||(Err'=0)  d
	.s mainData=^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)
	.s FrLocId=$p(mainData,"^",1)
	.s HospId=$p(^CTLOC(FrLocId),"^",22)
	.s UserId=$p(mainData,"^",2)
	.s ToLocId=$p(mainData,"^",3)
	.s MainData=FrLocId_"^"_ToLocId_"^"_""_"^"_OpTypeId_"^"_Complete_"^"_Status_"^"_UserId_"^"_""_"^"_"M"_"^"_""_"^^"_""_"^"_""
    .s Err=0
    .s MainId=""		;这里先将主表rowid置空
    .s ListDetail=""
    .s Remark=""
	.s DetailSub=0
	.f  s DetailSub=$o(^TMPDHCSTM("TMPDHCSTM",Pid,BillSub,DetailSub)) q:(DetailSub="")||(Err'=0)  d
	..s DetailData=^TMPDHCSTM("TMPDHCSTM",Pid,BillSub,DetailSub)
	..s InciDr=$P(DetailData,"^",1)
	..s NotTrQty=$P(DetailData,"^",2)
	..s Rp=$P(DetailData,"^",3)
	..s UomDr=$P(DetailData,"^",4)
    ..s BUomDr=$p(^INCI(InciDr,1),"^",10)
    ..s PurUomDr=$p(^INCI(InciDr,3),"^",6)
    ..s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(+PurUomDr,+BUomDr)
    ..s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomDr,BUomDr)
    ..s PurRP=Rp*Fac
    ..s ExistFlag=0   ;标识是否存在可转移的批次
    ..s ppid=..GetInclbForTransfer(FrLocId,InciDr,NotTrQty,"","",PurRP)
    ..i ppid'=""  d
    ...s Inclb=""
    ...f  s Inclb=$o(^TMPGETINCLB(ppid,Inclb)) q:(Inclb="")!(Err'=0)  d
    ....s IncInfo=^TMPGETINCLB(ppid,Inclb)    ;批次信息
    ....s Qty=$p(IncInfo,"^",7)     ;批次转移数量
    ....s Qty=Qty/Fac
    ....s ExistFlag=1
    ....s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomDr,HospId)
	....s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomDr,HospId)
	....s NewSp=##class(web.DHCSTMHUI.Common.PriceCommon).BatSpUom(Inclb,UomDr,HospId)
    ....s SpAmt=Sp*Qty
    ....s RpAmt=Rp*Qty
    ....s NewSpAmt=NewSp*Qty
    ....s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	....s NewSpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(NewSpAmt,HospId)
	....s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
    ....s Detail="^"_Inclb_"^"_Qty_"^"_UomDr_"^"_""_"^"_""_"^^"_""
	....s DetailTitle="RowId^Inclb^Qty^UomId^Inrqi^Remark^Ingri^SpecDesc"
	....s DetailStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Detail,DetailTitle)
	....;若MainId="",先保存主表(之前放在前面,可能有明细为空的情况)
	....i MainId="" d
	.....s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).Update(MainDataStr)
	.....s MainId=RtnObj.rowid
	....i RtnObj.success<0	d	;若主表保存失败,退出
	.....s Err=-1
	....q:Err'=0
	....;保存明细
	....s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrfItm).Update(MainId,DetailStr)
	....i RtnObj.success<0 d
	.....s Err=-2
	....q:Err'=0
	....s Initi=RtnObj.rowid
	....;增加新占用库存
	....s Ret=##class(web.DHCSTMHUI.DHCINIsTrf).HandleTransItmDirtyQty(Initi,1)  ;增加新占用库存
	....i Ret'=0 d
	.....s Err=-3
	....q:Err'=0
	....;清除请求单对应在途数
	....s Ret=##class(web.DHCSTMHUI.DHCINIsTrfItm).HandleTransItmResQty(Initi,0)
	....i Ret'=0 d
	.....s Err=-4
	....q:Err'=0
	....s Count=Count+1
	...k ^TMPGETINCLB(pid)
	.;这里拼接根据类组生成的出库单rowid
	.q:MainId=""
	i Err'=0 tro  
	k ^TMPDHCSTM("TMPDHCSTM",Pid)
	q:Err'=0 ..OutResultxml(Err,"失败")
	tc
	q ..OutResultxml(0,"成功")
}

/// 
/// Descript:	同步基础数据
/// Creator:	lihui
/// CreateDate:	20191224
/// Input:	[{},{}]	
/// Return:	[0:"",1:失败信息]
/// w ##class(web.DHCSTMService.HRP.In2OutServiceImpl).SaveData("<INCIDataList><INCIData><HVFlag>N</HVFlag><IncscDesc>卫生材料类</IncscDesc><InciCode>012600000002</InciCode><PUom>根</PUom><LocDesc>全科医疗科门诊</LocDesc><InciDesc>his字典测试普通收费2</InciDesc><BUom>根</BUom><ChargeFlag>Y</ChargeFlag><HospitalCode>DHSZHYYZY</HospitalCode><UserInitial>demo</UserInitial><Model>2w</Model><TableFlag>N</TableFlag></INCIData></INCIDataList>")
ClassMethod SaveData(Input) As %GlobalCharacterStream
{
	n (Input)
	s ^litmp("SaveInciData")=Input
	;s Input="<INCIDataList><INCIData><LocDesc>物资材料库</LocDesc><HospitalCode>DHSZHYYZY</HospitalCode><InciCode>物资代码1</InciCode><InciDesc>物资名称1</InciDesc><BUom>个</BUom><PUom>个</PUom><PFac>1</PFac><IncscDesc>高值材料</IncscDesc><Sp>1</Sp><Rp>1</Rp><Spec>规格</Spec><RegCertNo>注册证号</RegCertNo><RegCertExpDate>2029-09-09</RegCertExpDate><TableFlag>Y</TableFlag><HVFlag>Y</HVFlag><PbVendor>江苏润辉康尔医疗器械有限公司</PbVendor><Manf>北京</Manf><Brand>品牌</Brand><Model>型号</Model><ChargeFlag>Y</ChargeFlag><UserInitial>wz01</UserInitial><Abbrev>简称</Abbrev></INCIData><INCIData><HospitalCode>DHSZHYYZY</HospitalCode><LocDesc>物资材料库</LocDesc><InciCode>物资代码2</InciCode><InciDesc>物资名称2</InciDesc><BUom>个</BUom><PUom>个</PUom><PFac>1</PFac><IncscDesc>高值材料</IncscDesc><Sp>1</Sp><Rp>1</Rp><Spec>规格</Spec><RegCertNo>注册证号</RegCertNo><RegCertExpDate>2028-09-09</RegCertExpDate><TableFlag>Y</TableFlag><HVFlag>Y</HVFlag><PbVendor>新疆博泰晟达商贸</PbVendor><Manf>上海</Manf><Brand>品牌</Brand><Model>型号</Model><ChargeFlag>Y</ChargeFlag><UserInitial>wz01</UserInitial><Abbrev>简称</Abbrev></INCIData></INCIDataList>"
	s InputStream=##class(%GlobalCharacterStream).%New()
	i '$ISOBJECT(Input) d
	.d InputStream.Write(Input)
	e  d
	.d InputStream.CopyFrom(Input)
	d InputStream.Rewind()
	s Pid=$i(^DHCSTMPID("PID"))
	k ^TMPDHCSTM("TMPDHCSTMERR",Pid)
	s RetStream=##class(%GlobalCharacterStream).%New()
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(InputStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) q ..OutResultxml(1,"入参解析有误")
	d reader.Correlate("INCIDataList","web.DHCSTMService.HRP.Model.INCIDataList")
	s ListObj=##class(web.DHCSTMService.HRP.Model.INCIDataList).%New()
	s ListAllObj=##class(web.DHCSTMService.HRP.Model.INCIDataList).%New()
	while reader.Next(.ListObj,.sc){
		s ListAllObj=ListObj
	}
	s rowDelim=##class(web.DHCSTMHUI.Common.UtilCommon).RowDataDelim()
	s ItmCount=ListAllObj.INCIData.Count()
	q:ItmCount=0 ..OutResultxml(-1,"参数错误！") 
	s ErrMsg="",retInfo=""
	f i=1:1:ItmCount  d
	.s INCIDataObj=##class(web.DHCSTMService.HRP.Model.INCIData).%New()
	.s INCIDataObj=ListAllObj.INCIData.GetAt(i)
	.s HospitalCode=INCIDataObj.HospitalCode
	.s InciCode=INCIDataObj.InciCode
	.s InciDesc=INCIDataObj.InciDesc
	.s PFac=INCIDataObj.PFac
	.s BUom=INCIDataObj.BUom
	.s PUom=INCIDataObj.PUom
	.s IncscDesc=INCIDataObj.IncscDesc
	.s UserInitial=INCIDataObj.UserInitial
	.s Sp=INCIDataObj.Sp
	.s Rp=INCIDataObj.Rp
	.s Spec=INCIDataObj.Spec
	.s HVFlag=INCIDataObj.HVFlag
	.s RegCertNo=INCIDataObj.RegCertNo
	.s RegCertExpDate=INCIDataObj.RegCertExpDate
	.s PbVendor=INCIDataObj.PbVendor
	.s Manf=INCIDataObj.Manf
	.s Brand=INCIDataObj.Brand
	.s Model=INCIDataObj.Model
	.s ChargeFlag=INCIDataObj.ChargeFlag
	.s Abbrev=INCIDataObj.Abbrev
	.s ImpFlag=INCIDataObj.ImpFlag
	.s useflag=INCIDataObj.OperationState
	.i useflag="D" d
	..s useflag="Y"
	.e  d
	..s useflag="N"
	.s InsuPurPlanCode=""
	.s InsuPurPlanCode=INCIDataObj.InsuPurPlanCode
	.i (InciCode'="")&&(InsuPurPlanCode'="") j ##class(web.DHCBL.CTBASEIF.ICTCardRegLB).UpdateInsuPurPlanCode(InciCode,InsuPurPlanCode)
	.s ArcimId=INCIDataObj.ArcimId
	.s NotUseFlag=useflag
	.s TableFlag=INCIDataObj.TableFlag
	.s LocDesc=INCIDataObj.LocDesc
	.s HospId=##class(web.DHCSTMService.HRP.CommonInfo).ComHosp(HospitalCode)
	.i (HospitalCode="")||(HospId="")
	..s ErrMsg="第"_i_"条医院编码为空"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i InciCode="" d
	..s ErrMsg="第"_i_"条代码为空"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i InciDesc="" d
	..s ErrMsg="第"_i_"条名称为空"
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s BUomDr=##class(web.DHCSTMHUI.Tools.CodeInput).validUom(BUom)
	.i BUomDr="" d
	..s ErrMsg="第"_i_"条小单位为空,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.
	.s PUomDr=##class(web.DHCSTMHUI.Tools.CodeInput).validUom(PUom)
	.i PUomDr="" d
	..s ErrMsg="第"_i_"条包装单位为空,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.
	.s Factor=##class(web.DHCSTMHUI.Tools.CodeInput).validConFac(PUomDr,BUomDr,PFac)
	.i Factor="" d
	..s ErrMsg="第"_i_"条单位没有换算关系,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.
	.s IncscDesc=$$ALPHAUP^SSUTIL4(IncscDesc)
	.i IncscDesc="" d
	..s ErrMsg="第"_i_"条分类为空,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.
	.s IncscDr=##class(web.DHCSTMService.HRP.CommonInfo).ComStkCat(IncscDesc)
	.;s IncscDr=$o(^INC("SC",0,"Desc",IncscDesc,""))
	.i IncscDr="" d
	..s ErrMsg="第"_i_"条"_IncscDesc_"分类在物资系统不存在,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.
	.i (HVFlag'="Y")&&(HVFlag'="N") d
	..s ErrMsg="第"_i_"条高值标志必须为Y或者N,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.
	.i (ChargeFlag'="Y")&&(ChargeFlag'="N") d
	..s ErrMsg="第"_i_"条是否收费标志必须为Y或者N,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.
	.i (TableFlag'="Y")&&(TableFlag'="N") d
	..s ErrMsg="第"_i_"条材料是否0库存管理标志必须为Y或者N,InciCode:"_InciCode  ;(跟台标志)
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s LocDesc=INCIDataObj.LocDesc
	.s UserId=##class(web.DHCSTMService.HRP.CommonInfo).ComUser(UserInitial)
	.s:UserId="" UserId=1
	.s LocId=##class(web.DHCSTMService.HRP.CommonInfo).ComLoc(LocDesc)
	.i (LocId="") d
	..s LocId=1
	..;s ErrMsg="第"_i_"条科室为空,InciCode:"_InciCode
	..;d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.s vendorid=##class(web.DHCSTMService.HRP.CommonInfo).ComApc(PbVendor)
	.s Manfid=##class(web.DHCSTMService.HRP.CommonInfo).ComManf(Manf)
	.s TransFlag="BOTH"
	.s BatchReq="O"
	.s ExpReq="O"
	.s Incid=""
	.&sql(SELECT INCI_RowId INTO:Incid FROM INC_Itm WHERE INCI_Code=:InciCode)
	.;类组
	.s ScgDr=..validStkGrpRelation(IncscDr)
	.i (ScgDr="") d
	..s ErrMsg="第"_i_"条材料是分类未同步成功,InciCode:"_InciCode
	..d ..RecordErrInfo(Pid,ErrMsg)
	.q:ErrMsg'=""
	.i Incid'="" d
	..s notuseflag=$P(^INCI(Incid,2),"^",9)
	..i (notuseflag'=NotUseFlag)&&(NotUseFlag="Y") d
	...;d ..SyncArcimAndTariItem(Incid,+$h,"N")   ;唐山中心特殊加的暂时不用
	..i (notuseflag'=NotUseFlag)&&(NotUseFlag="N") d
	...;d ..SyncArcimAndTariItem(Incid,"","Y")   ;唐山中心特殊加的暂时不用
	.;下面是医嘱项
	.s arcmainDataObj=""
	.i ChargeFlag="Y" d
	..s arcObj=##class(web.DHCSTMService.HRP.Model.ArcData).%New()
	..s arcObj=INCIDataObj.ArcData.GetAt(1)  ;获取第一个
	..s ArcCode=arcObj.ArcCode			;代码
	..q:ArcCode=""                      ;先不判断
	..s ArcDesc=arcObj.ArcDesc				;描述
	..s BillUomDesc=arcObj.BillUom				;计价单位id
	..i ArcCode="" d
	...s ErrMsg="第"_i_"条医嘱代码为空,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s ArcRowid=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),"")) 
	..i ArcDesc="" d
	...s ErrMsg="第"_i_"条医嘱名称为空,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s BillUom=##class(web.DHCSTMHUI.Tools.CodeInput).validUom(BillUomDesc)
	..i BillUom="" d
	...s ErrMsg="第"_i_"条计价单位为空,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s ArcSubCatDesc=arcObj.OrdSubCat		;医嘱子类id
	..s OrdSubCat=##class(web.DHCSTMService.HRP.CommonInfo).ComOrdSubCat(ArcSubCatDesc) 
	..i OrdSubCat="" d
	...s ErrMsg="第"_i_"条医嘱子类为空或不存在,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s BillCatDesc=arcObj.BillCat				;费用大类id
	..s BillCat=##class(web.DHCSTMService.HRP.CommonInfo).ComBillCat(BillCatDesc)
	..i BillCat="" d
	...s ErrMsg="第"_i_"条费用大类为空或不存在,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s BillSubCatDesc=arcObj.BillSubCat			;费用子类id
	..s BillSubCat=##class(web.DHCSTMService.HRP.CommonInfo).ComBillSubCat(BillSubCatDesc)
	..i BillSubCat="" d
	...s ErrMsg="第"_i_"条费用子类为空或不存在,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s OwnFlag=arcObj.OwnFlag					;独立医嘱标志
	..s OwnFlag="Y"
	..s Priority=arcObj.Priority				;默认医嘱优先级id
	..s WoStock=arcObj.WoStock					;无库存医嘱标志
	..s WoStock="N"
	..s InsuDesc=arcObj.InsuDesc				;医保名称 	
	..s MaxQty=arcObj.MaxQty					;最大量
	..s NoOfCumDays=arcObj.NoOfCumDays			;限制使用天数 	
	..s MaxQtyPerDay=arcObj.MaxQtyPerDay		;每天最大剂量
	..s MaxCumDose=arcObj.MaxCumDose			;单次最大剂量
	..s RestrictEM=arcObj.RestrictEM			;急诊用药
	..s RestrictIP=arcObj.RestrictIP			;住院用药
	..s RestrictOP=arcObj.RestrictOP			;门诊用药
	..s RestrictHP=arcObj.RestrictHP			;体检用药
	..s AliasStr=arcObj.ArcAlias				;别名
	..s SX=arcObj.ArcAbbrev					;缩写
	..s UpdTarFlag=arcObj.FeeFlag
	..S UpInsu=arcObj.UpInsu					;更新医保项标志
	..S InsuItmType=0  								;药品类型为0
	..s TarSubCatDesc=arcObj.TarSubCat     		;子分类
	..s TarSubCat=##class(web.DHCSTMService.HRP.CommonInfo).ComTarSubCat(TarSubCatDesc)
	..i TarSubCat="" d
	...s ErrMsg="第"_i_"条子分类为空或不存在,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s TarInpatCatDesc=arcObj.TarInpatCat      	;住院子分类
	..s TarInpatCat=##class(web.DHCSTMService.HRP.CommonInfo).ComInpaSubCat(TarInpatCatDesc)
	..i TarInpatCat="" d
	...s ErrMsg="第"_i_"条住院子分类为空或不存在,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s TarOutpatCatDesc=arcObj.TarOutpatCat  		;门诊子分类 
	..s TarOutpatCat=##class(web.DHCSTMService.HRP.CommonInfo).ComOutpaSubCat(TarOutpatCatDesc)   
	..i TarOutpatCat="" d
	...s ErrMsg="第"_i_"条门诊子分类为空或不存在,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s TarEMCCatDesc=arcObj.TarEMCCat      		;核算子分类
	..s TarEMCCat=##class(web.DHCSTMService.HRP.CommonInfo).ComTarEmSubCat(TarEMCCatDesc)
	..i TarEMCCat="" d
	...s ErrMsg="第"_i_"条核算子分类为空或不存在,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s TarAcctCatDesc=arcObj.TarAcctCat      		;会计子分类
	..s TarAcctCat=##class(web.DHCSTMService.HRP.CommonInfo).ComAcctSubCat(TarAcctCatDesc)
	..i TarAcctCat="" d
	...s ErrMsg="第"_i_"条会计子分类为空或不存在,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s TarMRCatDesc=arcObj.TarMRCat     			;病例首页
	..s TarMRCat=##class(web.DHCSTMService.HRP.CommonInfo).ComMrSubCat(TarMRCatDesc)
	..i TarMRCat="" d
	...s ErrMsg="第"_i_"条病例首页为空或不存在,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s TarNewMRCatDesc=arcObj.TarNewMRCat     	;新病历首页分类 2015-06-09
	..s TarNewMRCat=##class(web.DHCSTMService.HRP.CommonInfo).ComNewMrSubCat(TarNewMRCatDesc)
	..i TarNewMRCat="" d
	...s ErrMsg="第"_i_"条新病例首页为空或不存在,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s BillCode=arcObj.BillCode				;收费项代码
	..s BillName=arcObj.BillName				;收费项名称
	..s ChargeBasis=arcObj.ChargeBasis			;收费依据
	..i BillCode="" d
	...s ErrMsg="第"_i_"条收费代码为空,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..i BillName="" d
	...s ErrMsg="第"_i_"条收费名称为空,InciCode:"_InciCode
	...d ..RecordErrInfo(Pid,ErrMsg)
	..q:ErrMsg'=""
	..s arcmainData=ArcRowid_"^"_ArcCode_"^"_ArcDesc_"^"_BillUom_"^"_OrdSubCat_"^"_BillCat_"^"_BillSubCat_"^"_OwnFlag_"^"_Priority_"^"_WoStock   ;9
    ..s arcmainData=arcmainData_"^"_InsuDesc_"^"_MaxQty_"^"_NoOfCumDays_"^"_MaxQtyPerDay_"^"_MaxCumDose_"^"_RestrictEM_"^"_RestrictIP_"^"_RestrictOP  ;17
    ..s arcmainData=arcmainData_"^"_RestrictHP_"^"_AliasStr_"^"_SX_"^"_UpdTarFlag_"^"_UpInsu_"^"_TarSubCat_"^"_TarInpatCat_"^"_TarOutpatCat_"^"_TarEMCCat_"^"_TarAcctCat ;27
    ..s arcmainData=arcmainData_"^"_TarMRCat_"^"_TarNewMRCat_"^"_ChargeBasis_"^"_BillCode_"^"_BillName
	..s arcmainTitle="Arc^ArcCode^ArcDesc^BillUom^OrdSubCat^BillCat^BillSubCat^OwnFlag^Priority"
    ..s arcmainTitle=arcmainTitle_"^"_"WoStock^InsuDesc^MaxQty^NoOfCumDays^MaxQtyPerDay^MaxCumDose^RestrictEM"
    ..s arcmainTitle=arcmainTitle_"^"_"RestrictIP^RestrictOP^RestrictHP^ArcAlias^ArcAbbrev^FeeFlag^UpInsu^TarSubCat"
    ..s arcmainTitle=arcmainTitle_"^"_"TarInpatCat^TarOutpatCat^TarEMCCat^TarAcctCat^TarMRCat^TarNewMRCat"
    ..s arcmainTitle=arcmainTitle_"^"_"ChargeBasis^BillCode^BillName"
	..;s arcmainTitle=arcmainTitle_"^"_mainTitle2_"^"_mainTitle3
	..;s arcmainTitle=arcmainTitle_"^"_"INCIData^INCIDataList"
	..s arcmainDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(arcmainData,arcmainTitle)
	.q:ErrMsg'=""
	.;结束医嘱项
	.s mainData1=Incid_"^"_InciCode_"^"_InciDesc_"^"_BUomDr_"^"_PUomDr_"^"_IncscDr_"^"_TransFlag_"^"_BatchReq_"^"_ExpReq_"^"_UserId
	.s mainData2=Rp_"^"_Sp_"^"_Spec_"^"_HVFlag_"^"_NotUseFlag_"^"_vendorid_"^"_Manfid_"^"_Brand_"^"_Model_"^"_TableFlag
	.s mainData3=HospId_"^"_ScgDr_"^"_LocId_"^"_ChargeFlag_"^"_ImpFlag
	.s mainData=mainData1_"^"_mainData2_"^"_mainData3
	.s mainTitle1="Inci^InciCode^InciDesc^BUom^PUom^StkCat^TransFlag^BatchNoReq^ExpDateReq^gUserId^RpPUom"
	.s mainTitle2="SpPUom^Spec^HighPrice^NotUseFlag^PbVendor^Manf^Brand^Model^HighRiskFlag"
	.s mainTitle3="gHospId^StkGrp^gLocId^ChargeFlag^ImpFlag"
	.s mainTitle=mainTitle1_"^"_mainTitle2_"^"_mainTitle3
	.s mainDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(mainData,mainTitle)
	.s ^TMPDHCSTM("TMPDHCSTM",Pid,i)=mainDataObj
	.s ^TMPDHCSTM("TMPDHCSTM",Pid,i,"ArcData")=arcmainDataObj
	i ErrMsg'="" d
	.f  s i=$o(^TMPDHCSTM("TMPDHCSTMERR",Pid,i)) q:i=""  d
	..s ErrMsg=^TMPDHCSTM("TMPDHCSTMERR",Pid,i)
	..i retInfo="" d
	...s retInfo=ErrMsg
	..e  d
	...s retInfo=retInfo_";"_ErrMsg
	.k ^TMPDHCSTM("TMPDHCSTMERR",Pid)
	q:ErrMsg'="" ..OutResultxml(-2,retInfo) 
	s ErrCode=0
	ts
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s BillSub=0
	f  s BillSub=$o(^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)) q:(BillSub="")||(ErrCode'=0)  d
	.s IncData=^TMPDHCSTM("TMPDHCSTM",Pid,BillSub)
	.s ArcData=$g(^TMPDHCSTM("TMPDHCSTM",Pid,BillSub,"ArcData"))
	.s RtnObj=##class(web.DHCSTMHUI.DrugInfoMaintain).SaveData(ArcData,IncData)
	.s PJObjret=##class(web.DHCSTMHUI.Common.FromJson).%New()
	.s Sc=PJObjret.%FromJSON(RtnObj)
	.s success=PJObjret.%Get("success")
	.s msg=PJObjret.%Get("msg")
	.i success'=0 d
	..s ErrCode=success
    i ErrCode'=0 tro
    q:ErrCode'=0 ..OutResultxml(ErrCode,"保存失败!")
	tc
	q ..OutResultxml(0,"保存成功!")
}

}

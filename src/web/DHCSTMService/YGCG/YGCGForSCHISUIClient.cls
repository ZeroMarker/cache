Import SQLUser

/// Descript:	四川阳光采购平台调用平台接口程序
/// Creater:	lihui
/// CreateDate:	20221112
/// 阳光采购平台测试库登录地址:http://218.17.85.68:9001/sso/login.html  H4403195_bm1 Sz@pro0119#
Class web.DHCSTMService.YGCG.YGCGForSCHISUIClient Extends %RegisteredObject
{

/// 是否启用阳光采购接口标志
Parameter UseYGCGFlag = "Y";

/// 订单送货地址
Parameter DistributeAddr = "绵阳市中医医院";

/// 是否通过集成平台标志
Parameter InterfaceFlag = "Y";

/// 因Ext和Hisui要求的Json格式不一致 分为Ext和HisUI 部署时根据需要修改
Parameter Version = "HisUI";

/*
HC001连通性测试			w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).TestConnecion()
HC002获取接口调用凭据	w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetToken()
HC007新建采购订单		w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddOrder(1)
HC008添加采购订单明细	w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddOrderDetail(1,"200423190352938717530144")
HC009提交采购订单		w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).CommitOrder("200423190352938717530144")
HC010获取订单明细信息	w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetOrderDetail(192,1)
HC011获取配送信息		w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetDistribution(192,1)
HC011.1获取配送信息-扩展（配送时间）
HC012入库 上传收货信息	w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddIngdrec(22484)
HC003获取采购目录 获取商品列表		w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetPurchaseDict("1","2019-12-10 00:00:00","2019-12-10 23:59:59","",1)
HC004 获取医院常用目录信息
HC013退货				w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddReturn(1060)
HC014获取退货信息		w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetReturnInfo(1060,1)
HC015新建支付单			w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddInpoPayOrder(1)
HC016添加支付订单明细	w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddInpoPayOrderDetail(1)
HC018提交支付单			w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).SubmitInpoPayOrder(1)
HC017获取待支付明细
HC015获取采购产品规格型号 w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).InsertProductInfo("1","2019-12-10 00:00:00","2019-12-10 23:59:59","",1)
HC005获取合同信息
HC006获取企业信息
HC006.1获取企业信息-扩展（企业名称）
*/
/// 判断库存项 属于 试剂MR/耗材MM/其他O
/// 根据项目情况调整判断条件 默认类组集合判断
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetInciFlag()
ClassMethod GetInciFlag(Inci) As %String
{
	q:Inci="" "O"
	s Flag="O"
	s StkType="M"
	s IncscId=$p(^INCI(Inci,2),"^",2)	;库存分类id
	q:IncscId="" Flag
	s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	s ScgType=$p(ScgInfo,"^",3)			;类组(M表示物资)
	q:ScgType'=StkType Flag
	s ScgId=$p(ScgInfo,"^",5)			;类组rowid
	s ScgSet=$p(ScgInfo,"^",7)			;类组集合(MM,MO,MR等)
	
	;根据类组集合判断
	i ScgSet="MR" s Flag="MR"
	i ScgSet'="MR" s Flag="MM"
	
	;库存分类判断区分物资 试剂
	;i "*"[("^"_IncscId_"^") s Flag="MR" 
	;e  s Flag="MM" 
	
	;类组 判断区分物资 试剂
	;i "*"[("^"_ScgId_"^") s Flag="MR" 
	;e  s Flag="MM"    
	
	q Flag
}

/// CreatDate:	20221117 lihui
/// Description:判断某个业务单据是否试剂单据
/// Input:		主表rowid,业务类型(PO,G,R,T....)
/// Return:		Y/N
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetMRDocFlag(8569,"G")
ClassMethod GetMRDocFlag(Rowid As %String, Type As %String) As %String
{
	q:Rowid="" ""
	q:Type="" ""
	s MRDocFlag="N"
	
	
	i Type="PO" d
	.s Ch=0
	.f  s Ch=$o(^INPO(Rowid,"POI",Ch)) q:(Ch="")||(MRDocFlag="Y")  d
	..s Inci=$p(^INPO(Rowid,"POI",Ch),"^",1)
	..s tmpMRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetInciFlag(Inci)
	..i tmpMRDocFlag="MR"  s MRDocFlag="Y"
	i Type="G" d
	.s Ch=0
	.f  s Ch=$o(^DHCINGR(Rowid,"GRI",Ch)) q:(Ch="")||(MRDocFlag="Y")  d
	..s Inci=$p(^DHCINGR(Rowid,"GRI",Ch),"^",25)
	..s tmpMRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetInciFlag(Inci)
	..i tmpMRDocFlag="MR"  s MRDocFlag="Y"
	i Type="R" d
	.s Ch=0
	.f  s Ch=$o(^INGRT(Rowid,"DHCGRR",Ch)) q:(Ch="")||(MRDocFlag="Y")  d
	..s Inclb=$p(^INGRT(Rowid,"DHCGRR",Ch),"^",6)
	..s Inci=+Inclb
	..s tmpMRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetInciFlag(Inci)
	..i tmpMRDocFlag="MR"  s MRDocFlag="Y"
	i Type="T" d
	.s Ch=0
	.f  s Ch=$o(^DHCINIT(Rowid,"ITI",Ch)) q:(Ch="")||(MRDocFlag="Y")  d
	..s Inclb=$p(^DHCINIT(Rowid,"ITI",Ch),"^",3)
	..s Inci=+Inclb
	..s tmpMRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetInciFlag(Inci)
	..i tmpMRDocFlag="MR"  s MRDocFlag="Y"
	
	i Type="Req" d
	.s Ch=0
	.f  s Ch=$o(^INRQ(Rowid,"RQI",Ch)) q:(Ch="")!(MRDocFlag="Y")  d
	..s Inci=$P(^INRQ(Rowid,"RQI",Ch),"^",4)
	..s tmpMRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetInciFlag(Inci)
	..i tmpMRDocFlag="MR"  s MRDocFlag="Y"
	
	i Type="PAY" d
	.s Ch=0
	.f  s Ch=$o(^DHCPAY(Rowid,"I",Ch)) q:(Ch="")!(MRDocFlag="Y")  d
	..s Inci=$P(^DHCPAY(Rowid,"I",Ch),"^",1)
	..s tmpMRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetInciFlag(Inci)
	..i tmpMRDocFlag="MR"  s MRDocFlag="Y"
	
	q MRDocFlag
}

/// CreatDate:	20180125 lihui
/// Description:判断某个业务单据是否高值单
/// Input:		主表rowid,业务类型(PO,G,R,T....)
/// Return:		Y/N
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetCertDocHVFlag(8569,"G")
ClassMethod GetCertDocHVFlag(Rowid As %String, Type As %String) As %String
{
	q:Rowid="" ""
	q:Type="" ""
	s DocHVFlag="N"
	i Type="G" d
	.s Ch=0
	.f  s Ch=$o(^DHCINGR(Rowid,"GRI",Ch)) q:(Ch="")||(DocHVFlag="Y")  d
	..s Inci=$p(^DHCINGR(Rowid,"GRI",Ch),"^",25)
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..q:HVFlag'="Y"
	..s DocHVFlag=HVFlag
	i Type="R" d
	.s Ch=0
	.f  s Ch=$o(^INGRT(Rowid,"DHCGRR",Ch)) q:(Ch="")||(DocHVFlag="Y")  d
	..s Inclb=$p(^INGRT(Rowid,"DHCGRR",Ch),"^",6)
	..s Inci=+Inclb
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..q:HVFlag'="Y"
	..s DocHVFlag=HVFlag
	i Type="T" d
	.s Ch=0
	.f  s Ch=$o(^DHCINIT(Rowid,"ITI",Ch)) q:(Ch="")||(DocHVFlag="Y")  d
	..s Inclb=$p(^DHCINIT(Rowid,"ITI",Ch),"^",3)
	..s Inci=+Inclb
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..q:HVFlag'="Y"
	..s DocHVFlag=HVFlag
	i Type="PO" d
	.s Ch=0
	.f  s Ch=$o(^INPO(Rowid,"POI",Ch)) q:(Ch="")||(DocHVFlag="Y")  d
	..s Inci=$p(^INPO(Rowid,"POI",Ch),"^",1)
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..q:HVFlag'="Y"
	..s DocHVFlag=HVFlag
	i Type="Req" d
	.s Ch=0
	.f  s Ch=$o(^INRQ(Rowid,"RQI",Ch)) q:(Ch="")!(DocHVFlag="Y")  d
	..s Inci=$P(^INRQ(Rowid,"RQI",Ch),"^",4)
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..q:HVFlag'="Y"
	..s DocHVFlag=HVFlag
	//二级库发放
	i Type="C" d
	.s Ch=0
	.f  s Ch=$o(^DHCINDS(Rowid,"DSI",Ch)) q:(Ch="")!(DocHVFlag="Y")  d
	..s Inci=$P(^DHCINDS(Rowid,"DSI",Ch),"^",4)
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..q:HVFlag'="Y"
	..s DocHVFlag=HVFlag
	//二级库退回
	i Type="L" d
	.s Ch=0
	.f  s Ch=$o(^DHCINDSR(Rowid,"I",Ch)) q:(Ch="")!(DocHVFlag="Y")  d
	..s Inci=$P(^DHCINDSR(Rowid,"I",Ch),"^",4)
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..q:HVFlag'="Y"
	..s DocHVFlag=HVFlag
	
	q DocHVFlag
}

/// H001 连通性测试
/// Creator：wxj
/// CreateDate:2020-12-22
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).TestConnecion()
ClassMethod TestConnecion() As %String
{
	s InputParam=##class(%GlobalCharacterStream).%New()
	d InputParam.Write("{""testdate"":"""_$zdt($h,3)_""",""testcontent"":""这是一条测试消息""}")
	s ReturnJson=..SendData("H001",InputParam).Read()
	q ReturnJson
}

/// HC002 根据第三方平台分配的应用码、授权码获取接口调用凭据
/// Creator：wxj
/// CreateDate:2020-12-22
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetToken() 
ClassMethod GetToken() As %String
{
	s tokenflag=0
	s (ReturnCode,ReturnMsg,Token,ExpiresIn,Lasttime,HospitalStrs)=""
	if $d(^TMPDHCSTMYGCG("TOKEN")) {
		s lastdt=^TMPDHCSTMYGCG("TOKEN")
		s ReturnCode=$p(lastdt,"^",1)
		s ReturnMsg=$p(lastdt,"^",2)
		s Token=$p(lastdt,"^",3)
		s ExpiresIn=$p(lastdt,"^",4)
		s Lasttime=$p(lastdt,"^",5)
		s TodayRemainVisitCount=$p(lastdt,"^",6)
		s HospitalStrs=$p(lastdt,"^",7)
		s lastdate=$p(Lasttime," ",1)
		s lasttime=$p(Lasttime," ",2)
		s nowtime=$p($h,",",2)
		i (lastdate'="")&&(lasttime'="")&&($zdh(lastdate,3)=+$h)&&(nowtime-$zth(lasttime,3)<1800) s tokenflag=1		
	}
	q:tokenflag=1 ReturnCode_"^"_ReturnMsg_"^"_Token_"^"_ExpiresIn_"^"_Lasttime_"^"_TodayRemainVisitCount_"^"_HospitalStrs
	s ReturnJson=..SendData("HC002","")
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode
	s ReturnMsg=ReturnJsonObj.returnMsg  
	s Token=ReturnJsonObj.accessToken
	s ExpiresIn=ReturnJsonObj.expiresIn
	s CurrentTime=ReturnJsonObj.currentTime
	s TodayRemainVisitCount=ReturnJsonObj.todayRemainVisitCount
	s HospitalStrs=ReturnJsonObj.hospitalId
	
	q:(ReturnCode'=1)&&(ReturnCode'=9) "-1^获取令牌失败"
	s:ExpiresIn="" ExpiresIn=1800
	s:CurrentTime="" CurrentTime=$zdt($h,3)
	s ^TMPDHCSTMYGCG("TOKEN")=ReturnCode_"^"_ReturnMsg_"^"_Token_"^"_ExpiresIn_"^"_CurrentTime_"^"_TodayRemainVisitCount_"^"_HospitalStrs
	q ReturnCode_"^"_ReturnMsg_"^"_Token_"^"_ExpiresIn_"^"_CurrentTime_"^"_TodayRemainVisitCount_"^"_HospitalStrs
}

/// Part: HC007物资 SJ006试剂 新建采购订单
/// Creator：wxj
/// CreateDate:2020-12-22
/// Up: lihui 20221115
/// Description：上传HIS订单主表信息到阳光采购平台
/// Table: DHC_INPO(订单附加表PO_PurPlanCodeId字段保存第三方阳光采购平台订单号)
/// Input: PoId-订单ID, InterTypeCoce(试剂:SJ006; 物资:HC007)
/// Return: 0-成功,OrderId-阳光采购平台订单编号
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddOrder(54321)
ClassMethod AddOrder(PoId As %String, InterTypeCoce = "HC007") As %String
{
	q:PoId="" "-2^订单ID不能为空！"
	q:'$d(^INPO(PoId)) "-3^该订单不存在,请核实！"
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s distributeAddress=..#DistributeAddr
	s remarks=$g(^INPO(PoId,"REM",1))
	s orderName="" ; 订单名称
	s orderType=0
	s Data=PoId_"^"_distributeAddress_"^"_remarks_"^"_orderName_"^"_orderType
	s Title="hospitalOrderId^defaultDistributeAddr^orderRemarks^orderName^orderType"
	s InputParamJosn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	s InputParam="accessToken="_accessToken_"&hospitalId="_hospitalId_"&orderInfo="_InputParamJosn
	s InputStream=##class(%GlobalCharacterStream).%New()
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	d ReturnJson.Rewind()
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode 
	s ReturnMsg=ReturnJsonObj.returnMsg   
	q:ReturnCode'=1 ReturnCode_"^"_ReturnMsg
	s errorList=ReturnJsonObj.errorList
	s successList=ReturnJsonObj.successList
	s ListSize=successList.Count()
	q:ListSize=0 "-999^上传订单平台返回值为空"
	s (OrderId,hospitalOrderId)=""
	f i=1:1:ListSize {
		s DataObj=successList.GetAt(i)
		s hospitalOrderId=DataObj.hospitalOrderId			// 院内订单主表ID
		s OrderId=DataObj.orderId			//采购平台订单ID
		s orderName=DataObj.orderName ;耗材采购平台订单名称
		s orderType=DataObj.orderType ;订单类型
	}
	i hospitalOrderId=PoId d
	.&sql(UPDATE SQLUser.DHC_INPO SET PO_PurPlanCodeId =:OrderId WHERE PO_INPO_DR = :PoId)
	q:SQLCODE'=0 SQLCODE_"^"_"保存订单主表失败！"_$g(%msg)
	q 0_"^"_OrderId
}

/// Part: HC008物资 SJ007试剂 添加采购订单明细
/// Creator：wxj
/// CreateDate:2020-12-22
/// Up: lihui 20221115
/// Description：上传HIS订单明细到阳光采购平台
/// Table: IN_POItm(订单明细表INPOI_ThirdOrderDetailId字段保存第三方阳光采购平台订单明细号)
/// Input: PoId-HIS订单ID,orderId-阳光采购平台订单编号, InterTypeCoce(试剂:SJ007; 物资:HC008)
/// Return: 0^成功210204174136880930387934
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddOrderDetail(8727,"220211104606682778324454")
ClassMethod AddOrderDetail(PoId As %String, orderId As %String, InterTypeCoce = "HC008") As %String
{
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s distributeAddress=..#DistributeAddr
	s InputStream=##class(%GlobalCharacterStream).%New()
	s InputParam="accessToken="_accessToken_"&orderDetailInfo="_"{""list"":["
	s listdata=""
	s RetVal=0,RetMsg=""
	s ItmChl=""
	f {
		s ItmChl=$o(^INPO(PoId,"POI",ItmChl)) 		
		q:+ItmChl'>0
		s PoItm=PoId_"||"_ItmChl
		s GlobalData=$g(^INPO(PoId,"POI",ItmChl))
		s Inci=$p(GlobalData,"^",1)
		s highflag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
		s InciCode=$p(^INCI(Inci,1),"^",1)
		s PoQty=$p(GlobalData,"^",7)
		s PoiUom=$p(GlobalData,"^",3)	//订单明细单位
		s BUomId=$p(^INCI(Inci,1),"^",10)	//基本单位
		s PUomid=$p(^INCI(Inci,3),"^",6)	// 入库单位
		s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PoiUom,BUomId)
		s PuomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomid,BUomId)
		s PoQtyBUom=PoQty*UomFac	//基本单位数量
		s PuomQty=PoQtyBUom/PuomFac //入库单位数量
		s PurItmRelId=$o(^DHCItmPCRelation(0,"INCI",Inci,0))
		i PurItmRelId="" s RetVal=-2,RetMsg=InciCode_":没有对照关系!" q
		s MPCId=$p(^DHCItmPCRelation(PurItmRelId),"^",2)
		i MPCId="" s RetVal=-2,RetMsg=InciCode_":没有对照关系!" q
		;S SpecListId=$p(^DHCItmPCRelation(PurItmRelId),"^",3)
		;i SpecListId="" s RetVal=-2,RetMsg=InciCode_":没有对照关系!" q
		s goodsID=""
		s:MPCId'="" goodsID=$p($g(^DHCMatPurCataLog(MPCId)),"^",3) 		;产品ID
		i goodsID="" s RetVal=-3,RetMsg=InciCode_":产品ID为空!" q
		;s SMLCH=$p(SpecListId,"||",2)
		;q:+SMLCH'>0
		;s subcodeId=""
		;s:SpecListId'="" subcodeId=$p(^DHCMatPurCataLog(MPCId,"SMList",SMLCH),"^",4)
		;i subcodeId="" s RetVal=-4,RetMsg=InciCode_":采购产品规格型号为空！" q
		s companyIdPs=$p(^DHCMatPurCataLog(MPCId),"^",17)	;配送商编号
		;i companyIdPs="" s RetVal=-5,RetMsg=InciCode_":配送商为空！" q
		s poitmRemark=$g(^INPO(PoId,"POI",ItmChl,"REM",1))		;订单明细备注
		s orderCustomInfo=""	;自定义订单信息
		i highflag="Y" d
		.s orderCustomInfo=..GetBatExpByIPoi(PoItm)	 ;高值传入库明细批号效期
		s detailId=""  ; 合同明细编号
		s contractid=""
		f  s contractid=$o(^DHCMPCT(0,"GOODSIDCSTATUS",goodsID,"1",contractid)) q:contractid=""  d
		.q:'$d(^DHCMPCT(contractid))
		.s tmpisWithAmount=$p(^DHCMPCT(contractid),"^",29)
		.I tmpisWithAmount'=1  S tmpisWithAmount=0
		.q:tmpisWithAmount'=isWithAmount
		.s contractNumber=$p(^DHCMPCT(contractid),"^",13)
		.s detailId=$p(^DHCMPCT(contractid),"^",18)
		.s companyIdPs=$p(^DHCMPCT(contractid),"^",3) ; 配送商
		i companyIdPs="" s RetVal=-5,RetMsg=InciCode_":配送商为空！" q
		s usingDepartment="器械卫生材料库" ;科室
		s orderType=1
		s DetailStr="{""orderId"":"""_orderId_""",""hospitalOrderDetailId"":"""_PoItm_""",""goodsId"":"""_goodsID_""",""purchaseCount"":"""_PuomQty_""",""distributeAddr"":"""_distributeAddress_""",""companyIdPs"":"""_companyIdPs_""",""orderCustomInfo"":"""_orderCustomInfo_""",""orderType"":"""_orderType_"""}" 
		if listdata'="" s listdata=listdata_","_DetailStr
       	else  s listdata=DetailStr
     }	
    
	s InputParam=InputParam_listdata_"]}"_"&hospitalId="_hospitalId
	q:RetVal'=0 RetVal_"^"_RetMsg
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	d ReturnJson.Rewind()
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode   
	s ReturnMsg=ReturnJsonObj.returnMsg  
	s successList=ReturnJsonObj.successList
	s errorObj=ReturnJsonObj.errorList
	s ListSize=successList.Count()
	q:ListSize=0 "-999^上传明细平台返回值为空"
	s RetMsgStr=""
	if $ISOBJECT(successList) {
		s ListSize=successList.Count()
		f i=1:1:ListSize {
			s DataObj=successList.GetAt(i)
			s PoItm=DataObj.hospitalOrderDetailId	;内部订单明细编号
			s orderDetailId=DataObj.orderDetailId  				;采购平台订单明细编号
			s Inci=$p(^INPO(+PoItm,"POI",$p(PoItm,"||",2)),"^",1)
			s InciCode=$p(^INCI(Inci,1),"^",1)
			//保存平台订单明细编号
			&sql(UPDATE SQLUser.IN_POItm SET INPOI_ThirdOrderDetailId = :orderDetailId WHERE IN_POItm=:PoItm)
			i SQLCODE'=0 {
				if RetMsgStr'="" s RetMsgStr=RetMsgStr_";"_InciCode_"更新订单明细失败"
				else  s RetMsgStr=InciCode_"更新订单明细失败"
			}
		}
	}
	elseif $ISOBJECT(errorObj)  {
		s errorReasonList=errorObj.GetAt(1).errorReasonList
		s errorDetailListSize=errorReasonList.Count()
		s errorDesc=""
		f k=1:1:errorDetailListSize {
			s errorDetail=errorReasonList.GetAt(k)
			s orderId=errorDetail.orderId
			s errorCode=errorDetail.errorCode
			s errorMsg=errorDetail.errorMsg
			if errorDesc'="" s errorDesc=errorDesc_","_orderId_":"_errorMsg
			else  s errorDesc=orderId_":"_errorMsg
		}
		if RetMsgStr'="" s RetMsgStr=RetMsgStr_";"_errorDesc
			else  s RetMsgStr=errorDesc
	}
	else{
		s RetVal=ReturnCode,RetMsg=ReturnMsg
	}
	s:RetMsgStr'="" RetVal=-7,RetMsg=RetMsgStr
	q RetVal_"^"_RetMsg
}

/// 根据订单明细获取入库明细中批号效期
/// Creator: lihui
/// CreateDate: 20230202
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetBatExpByIPoi()
ClassMethod GetBatExpByIPoi(Inpoitmid) As %String
{
	s IngrId="",BatExpStr=""
	f  s IngrId=$o(^DHCINGR(0,"PODR",Inpoitmid,IngrId)) q:IngrId=""  d
	.s chl=""
	.f  s chl=$o(^DHCINGR(0,"PODR",Inpoitmid,IngrId,chl)) q:chl=""  d
	..q:'$d(^DHCINGR(IngrId,"GRI",chl))
	..s ingritminfo=^DHCINGR(IngrId,"GRI",chl)
	..s ExpDate=$p(ingritminfo,"^",9)
	..s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	..s BatNo=$p(ingritminfo,"^",13)
	..s BatExpStr=BatExpStr_" "_ExpDate_"@"_BatNo
	q BatExpStr
}

/// Part: HC009物资 SJ008试剂 提交采购订单
/// Creator：wxj
/// CreateDate:2020-12-22
/// Up: 20221115
/// Input: orderId-阳光采购平台订单编号, InterTypeCoce(试剂:SJ008; 物资:HC009)
/// Return: 0^成功
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).CommitOrder("210209104434435687599104")
ClassMethod CommitOrder(orderId As %String, InterTypeCoce = "HC009") As %String
{
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s distributeAddress=..#DistributeAddr
	s Data=orderId
	s Title="orderId"
	s Inputjson=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	s InputParam="accessToken="_accessToken_"&hospitalId="_hospitalId_"&orderInfo="_Inputjson
	s InputStream=##class(%GlobalCharacterStream).%New()
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	d ReturnJson.Rewind()
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode   
	s ReturnMsg=ReturnJsonObj.returnMsg
	s successList=ReturnJsonObj.successList
	s errorObj=ReturnJsonObj.errorList
	s ListSize=successList.Count()
	q:ListSize=0 "-999^提交订单平台返回值为空"
	s RetMsgStr="",RetVal=0,RetMsg=""
	if $ISOBJECT(successList) {
		s ListSize=successList.Count()
		f i=1:1:ListSize {
			s DataObj=successList.GetAt(i)
			s orderDetailId=DataObj.orderId  				;采购平台订单明细编号
		}
	}
	elseif $ISOBJECT(errorObj)  {
		s errorListSize=errorObj.Count()
		s errorDesc="",errorStr=""
		f j=1:1:errorListSize {
			s errorList=errorObj.GetAt(j)
			s orderDetailId=errorList.orderId
			s errorDetailList=errorList.errorReasonList
			s errorDetailListSize=errorDetailList.Count()
			f k=1:1:errorDetailListSize {
				s errorDetail=errorDetailList.GetAt(k)
				s errorCode=errorDetail.errorcode
				s errorMsg=errorDetail.errorMsg
				if errorDesc'="" s errorDesc=errorDesc_","_errorMsg
				else  s errorDesc=errorMsg
			}
			if RetMsgStr'="" s RetMsgStr=RetMsgStr_";"_orderDetailId_":"_errorDesc
			else  s RetMsgStr=orderDetailId_":"_errorDesc
		}
	}
	else{
		s RetVal=ReturnCode,RetMsg=ReturnMsg
	}
	s:RetMsgStr'="" RetVal=-4,RetMsg=RetMsgStr
	q RetVal_"^"_RetMsg
}

/// Part: HC010物资 SJ009试剂 获取订单明细信息
/// Creator：wxj
/// CreateDate:2020-12-22
/// Up: 20221115 lihui
/// Input: PoId-HIS订单ID,currentPageNumber-指定页码, InterTypeCoce(试剂:SJ009; 物资:HC010)
/// Return: 0-成功
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetOrderDetail(54183,1)
ClassMethod GetOrderDetail(PoId As %String, currentPageNumber As %String = "1", InterTypeCoce = "HC010") As %String
{
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s InputStream=##class(%GlobalCharacterStream).%New()
	s InputParam="accessToken="_accessToken_"&hospitalId="_hospitalId_"&currentPageNumber="_currentPageNumber_"&orderDetailInfo="_"{""list"":["
	s listdata=""
	s ItmChl=""
	f  {
		s ItmChl=$o(^INPO(PoId,"POI",ItmChl)) q:ItmChl=""  d
		q:ItmChl'>0
		s PoItm=PoId_"||"_ItmChl
		s GlobalData=$g(^INPO(PoId,"POI",ItmChl))
		s orderDetailId=$p(GlobalData,"^",20)    ;采购平台订单ID
		continue:orderDetailId=""           	 ;过滤-未上传成功的
		s Data=orderDetailId
		s Title="orderDetailId"
		s Inputjson=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
		if listdata'="" s listdata=listdata_","_Inputjson
		else  s listdata=Inputjson
	}
	q:listdata="" "-2^订单明细不能为空"
	s InputParam=InputParam_listdata_"]}"
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	s ReturnJsonStr=ReturnJson.Read()
	q 0_"^"_ReturnJsonStr
}

/// Part: HC011 物资 SJ010 试剂 获取配送信息
/// Creator：wxj
/// CreateDate:2020-12-22
/// Up: 20221115 lihui
/// Input: PoId-HIS订单ID,currentPageNumber-指定页码, InterTypeCoce(试剂:SJ010; 物资:HC011)
/// Return: 0^成功
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetDistribution(54183,1)
ClassMethod GetDistribution(PoId As %String, currentPageNumber As %String = "1", InterTypeCoce = "HC011") As %String
{
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s InputStream=##class(%GlobalCharacterStream).%New()
	s InputParam="accessToken="_accessToken_"&hospitalId="_hospitalId_"&currentPageNumber="_currentPageNumber_"&orderDetailInfo="_"{""list"":["
	s listdata=""
	s ItmChl=""
	f  {
		s ItmChl=$o(^INPO(PoId,"POI",ItmChl)) q:ItmChl=""  d
		q:ItmChl'>0
		s PoItm=PoId_"||"_ItmChl
		s orderDetailId=$p(^INPO(PoId,"POI",ItmChl),"^",20)    ;采购平台订单ID
		continue:orderDetailId=""           	 			   ;过滤-未上传成功的
		s Data=orderDetailId
		s Title="orderDetailId"
		s Inputjson=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
		if listdata'="" s listdata=listdata_","_Inputjson
		else  s listdata=Inputjson
	}
	q:listdata="" "-2^订单明细不能为空"
	s InputParam=InputParam_listdata_"]}"
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	s ReturnJsonStr=ReturnJson.Read()
	q 0_"^"_ReturnJsonStr
}

/// Part:H008 拒绝收货
/// Creator：wxj
/// CreateDate:2021-03-02
/// Return:0^成功
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).RefuseRec(159517)
ClassMethod RefuseRec(ParamStr As %String) As %String
{
	q:ParamStr="" "-2^入参不能为空！"
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s InputStream=##class(%GlobalCharacterStream).%New()
	s InputParam="{""accessToken"":"""_accessToken_""",""list"":["
	s ChildSub="",listdata=""
	s rowDelim=##class(web.DHCSTMHUI.Common.UtilCommon).RowDataDelim()
    s len=$l(ParamStr,rowDelim)
	s err=""
	f i=1:1:len  d
    .s data=$p(ParamStr,rowDelim,i)
	.s distributionSerialID=$p(data,"^",1)	;配送明细编号
	.s invoiceID=$p(data,"^",2)				;发票号
	.s batchRecordID=$p(data,"^",3)			;批号
	.s warehouseCount=0						;收货数量为0
	.s DetailStr="{""distributionSerialID"":"""_distributionSerialID_""",""invoiceID"":"""_invoiceID_""",""batchRecordID"":"""_batchRecordID_""",""warehouseCount"":"""_warehouseCount_"""}"
	.i listdata'="" s listdata=listdata_","_DetailStr
	.e  s listdata=DetailStr
	q:listdata="" "-4^无需上传的配送明细!"
	s InputParam=InputParam_listdata_"]}"
	d InputStream.Write(InputParam)
	b ;InputParam
	s ReturnJson=..SendData("H008",InputStream)
	q:ReturnJson.Size=0 "-999^平台返回值为空"
	d ReturnJson.Rewind()
	b ;ReturnJson
	//解析返回json
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode   
	s ReturnMsg=ReturnJsonObj.returnMsg
	s errorObj=ReturnJsonObj.disErrorList
	if $ISOBJECT(errorObj) {
		s errorListSize=errorObj.Count()
		s errorDesc="",errorStr=""
		f j=1:1:errorListSize {
			s errorList=errorObj.GetAt(j)
			s distributionSerialID=errorList.distributionSerialID
			s errorDetailList=errorList.errorDetailList
			s errorDetailListSize=errorDetailList.Count()
			f k=1:1:errorDetailListSize {
				s errorDetail=errorDetailList.GetAt(k)
				s errorCode=errorDetail.errorcode
				s errorMsg=errorDetail.errorMsg
				if errorDesc'="" s errorDesc=errorDesc_","_errorMsg
				else  s errorDesc=errorMsg
			}
			if errorStr'="" s errorStr=errorStr_";"_distributionSerialID_":"_errorDesc
			else  s errorStr=distributionSerialID_":"_errorDesc
		}
		if errorStr'="" s ReturnMsg=errorStr
	}
	q ReturnCode_"^"_ReturnMsg
}

/// Description：HC012 物资 SJ011 试剂 上传收货信息 (入库)
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSAddIngdrec(192,1)
ClassMethod JSAddIngdrec(IngdId As %String)
{
	s MRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetMRDocFlag(IngdId,"G")
	s InterTypeCoce="HC012"
	i MRDocFlag="Y"   {
		s InterTypeCoce="SJ011"
	}
	s ifhvflag=..GetCertDocHVFlag(IngdId,"G")
	if ifhvflag="Y" {
		s RetInfo=..AddIngdrecHV(IngdId,"HC012")
	}else{
		s RetInfo=..AddIngdrec(IngdId,InterTypeCoce)
	}
	q RetInfo
}

/// Part: HC012 物资 SJ011 试剂 上传收货信息 (入库)  普通耗材
/// Creator：wxj
/// CreateDate:2020-12-22
/// Up: 20221115 lihui
/// Input:IngdId-HIS入库单ID, InterTypeCoce(试剂:SJ011; 物资:HC012)
/// Return:0^成功
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddIngdrec(159517)
ClassMethod AddIngdrec(IngdId As %String, InterTypeCoce = "HC012") As %String
{
	q:IngdId="" "-2^入库单ID不能为空！"
	q:'$d(^DHCINGR(IngdId)) "-3^该入库单不存在，请核实！"
	
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s InputStream=##class(%GlobalCharacterStream).%New()
	s InputParam="accessToken="_accessToken_"&hospitalId="_hospitalId_"&distributeInfo="_"{""list"":["
	s ChildSub="",listdata=""
	f  {
		s ChildSub=$o(^DHCINGR(IngdId,"GRI",ChildSub))
		q:ChildSub'>0
		s distributionSerialID=$p(^DHCINGR(IngdId,"GRI",ChildSub),"^",64)	;配送明细编号
		continue:distributionSerialID=""
		s RecQty=$p(^DHCINGR(IngdId,"GRI",ChildSub),"^",4)			;收货数量
		s invoiceID=$p(^DHCINGR(IngdId,"GRI",ChildSub),"^",27)				;发票号
		s batchRecordID=$p(^DHCINGR(IngdId,"GRI",ChildSub),"^",13)			;批号
		s IngriUom=$p(^DHCINGR(IngdId,"GRI",ChildSub),"^",10)	//入库明细单位
		s Inci=$p(^DHCINGR(IngdId,"GRI",ChildSub),"^",25)
		s BUomId=$p(^INCI(Inci,1),"^",10)	//基本单位
		s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(IngriUom,BUomId)
		s warehouseCount=RecQty/UomFac	//入库单位数量
		s warehouseCustomInfo="" ;自定义收货信息
		s DetailStr="{""distributeId"":"""_distributionSerialID_""",""warehouseCount"":"""_warehouseCount_""",""warehouseCustomInfo"":"""_warehouseCustomInfo_"""}"
		i listdata'="" s listdata=listdata_","_DetailStr
		e  s listdata=DetailStr
	}
	q:listdata="" "-4^无需上传的配送明细!"
	s InputParam=InputParam_listdata_"]}"
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	q:ReturnJson.Size=0 "-999^平台返回值为空"
	d ReturnJson.Rewind()
	//解析返回json
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode   
	s ReturnMsg=ReturnJsonObj.returnMsg
	s errorObj=ReturnJsonObj.errorList
	if $ISOBJECT(errorObj) {
		s errorListSize=errorObj.Count()
		s errorDesc="",errorStr=""
		f j=1:1:errorListSize {
			s errorList=errorObj.GetAt(j)
			s distributionSerialID=errorList.distributeId
			s errorDetailList=errorList.errorReasonList
			s errorDetailListSize=errorDetailList.Count()
			f k=1:1:errorDetailListSize {
				s errorDetail=errorDetailList.GetAt(k)
				s errorCode=errorDetail.errorcode
				s errorMsg=errorDetail.errorMsg
				if errorDesc'="" s errorDesc=errorDesc_","_errorMsg
				else  s errorDesc=errorMsg
			}
			if errorStr'="" s errorStr=errorStr_";"_distributionSerialID_":"_errorDesc
			else  s errorStr=distributionSerialID_":"_errorDesc
		}
		if errorStr'="" s ReturnMsg=errorStr
	}
	q ReturnCode_"^"_ReturnMsg
}

/// Part: HC012 物资 上传收货信息 (入库)  高值耗材
/// Up: 20221115 lihui
/// Input:IngdId-HIS入库单ID, InterTypeCoce(试剂:SJ011; 物资:HC012)
/// Return:0^成功
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddIngdrecHV(159517)
ClassMethod AddIngdrecHV(IngdId As %String, InterTypeCoce = "HC012") As %String
{
	q:IngdId="" "-2^入库单ID不能为空！"
	q:'$d(^DHCINGR(IngdId)) "-3^该入库单不存在，请核实！"
	
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s InputStream=##class(%GlobalCharacterStream).%New()
	s InputParam="accessToken="_accessToken_"&hospitalId="_hospitalId_"&distributeInfo="_"{""list"":["
	s ChildSub="",listdata=""
	s pid=$i(^DHCSTMYGCGPID("PID"))
	k ^TMPDHCSTMYGCG("AddIngdrecHV")
	f  {
		s ChildSub=$o(^DHCINGR(IngdId,"GRI",ChildSub))
		q:ChildSub'>0
		s distributionSerialID=$p(^DHCINGR(IngdId,"GRI",ChildSub),"^",64)	;配送明细编号
		continue:distributionSerialID=""
		s RecQty=$p(^DHCINGR(IngdId,"GRI",ChildSub),"^",4)			;收货数量
		s invoiceID=$p(^DHCINGR(IngdId,"GRI",ChildSub),"^",27)				;发票号
		s batchRecordID=$p(^DHCINGR(IngdId,"GRI",ChildSub),"^",13)			;批号
		s IngriUom=$p(^DHCINGR(IngdId,"GRI",ChildSub),"^",10)	//入库明细单位
		s Inci=$p(^DHCINGR(IngdId,"GRI",ChildSub),"^",25)
		s BUomId=$p(^INCI(Inci,1),"^",10)	//基本单位
		s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(IngriUom,BUomId)
		s warehouseCount=RecQty*UomFac	//基本单位数量
		s warehouseCustomInfo="" ;自定义收货信息
		i $d(^TMPDHCSTMYGCG("AddIngdrecHV",pid,distributionSerialID))  d
		.s $p(^TMPDHCSTMYGCG("AddIngdrecHV",pid,distributionSerialID),"^",1)=$p(^TMPDHCSTMYGCG("AddIngdrecHV",pid,distributionSerialID),"^",1)+RecQty
		.
		e  d
		.s ^TMPDHCSTMYGCG("AddIngdrecHV",pid,distributionSerialID)=RecQty_"^"_warehouseCustomInfo_"^"_Inci
		
	}
	s tmpdistributid=""
	f  s tmpdistributid=$o(^TMPDHCSTMYGCG("AddIngdrecHV",pid,tmpdistributid)) q:tmpdistributid=""  d
	.s info=^TMPDHCSTMYGCG("AddIngdrecHV",pid,tmpdistributid)
	.s RecQty=$p(info,"^",1)
	.s warehouseCustomInfo=$p(info,"^",2)
	.s Inci=$p(info,"^",3)
	.s BUomId=$p(^INCI(Inci,1),"^",10)	//基本单位
	.s PUomid=$p(^INCI(Inci,3),"^",6)	// 入库单位
	.s PuomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomid,BUomId)
	.s PuomQty=RecQty/PuomFac //入库单位数量
	.s DetailStr="{""distributeId"":"""_tmpdistributid_""",""warehouseCount"":"""_PuomQty_""",""warehouseCustomInfo"":"""_warehouseCustomInfo_"""}"
	.i listdata'="" s listdata=listdata_","_DetailStr
	.e  s listdata=DetailStr
	
	
	q:listdata="" "-4^无需上传的配送明细!"
	s InputParam=InputParam_listdata_"]}"
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	q:ReturnJson.Size=0 "-999^平台返回值为空"
	d ReturnJson.Rewind()
	//解析返回json
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode   
	s ReturnMsg=ReturnJsonObj.returnMsg
	s errorObj=ReturnJsonObj.errorList
	if $ISOBJECT(errorObj) {
		s errorListSize=errorObj.Count()
		s errorDesc="",errorStr=""
		f j=1:1:errorListSize {
			s errorList=errorObj.GetAt(j)
			s distributionSerialID=errorList.distributeId
			s errorDetailList=errorList.errorReasonList
			s errorDetailListSize=errorDetailList.Count()
			f k=1:1:errorDetailListSize {
				s errorDetail=errorDetailList.GetAt(k)
				s errorCode=errorDetail.errorcode
				s errorMsg=errorDetail.errorMsg
				if errorDesc'="" s errorDesc=errorDesc_","_errorMsg
				else  s errorDesc=errorMsg
			}
			if errorStr'="" s errorStr=errorStr_";"_distributionSerialID_":"_errorDesc
			else  s errorStr=distributionSerialID_":"_errorDesc
		}
		if errorStr'="" s ReturnMsg=errorStr
	}
	q ReturnCode_"^"_ReturnMsg
}

/// Description：HC013 物资 SJ012 试剂 上传退货
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSAddReturn(192,1)
ClassMethod JSAddReturn(IngdRet As %String)
{
	s MRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetMRDocFlag(IngdRet,"R")
	s InterTypeCoce="HC013"
	i MRDocFlag="Y"   {
		s InterTypeCoce="SJ012"
	}
	s RetInfo=..AddReturn(IngdRet,InterTypeCoce)
	q RetInfo
}

/// Part: HC013 物资 SJ012 试剂 上传退货
/// Creator：wxj
/// CreateDate:2020-12-22
/// Up: 20221115 lihui
/// Input: IngdRet-HIS退货单ID, InterTypeCoce(试剂：SJ012；物资：HC013)
/// Return: 0^成功
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddReturn(2860)
ClassMethod AddReturn(IngdRet As %String, InterTypeCoce = "HC013") As %String
{
	q:IngdRet="" "-2^退货单ID不能为空！"
	q:'$d(^INGRT(IngdRet)) "-3^该退货单不存在,请核实！"
	
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s InputStream=##class(%GlobalCharacterStream).%New()
	s InputParam="accessToken="_accessToken_"&hospitalId="_hospitalId_"&params="_"{""list"":["
	s listdata="", ChildSub=""
	f  {
		s ChildSub=$o(^INGRT(IngdRet,"DHCGRR",ChildSub))
		q:ChildSub'>0
		s GlobalData=$g(^INGRT(IngdRet,"DHCGRR",ChildSub))
		s IngdRecItm=$p(GlobalData,"^",1)
		s distributionSerialID=$p(^DHCINGR(+IngdRecItm,"GRI",$p(IngdRecItm,"||",2)),"^",64)  ;采购平台配送明细ID
		continue:distributionSerialID=""
		s RetQty=$p(GlobalData,"^",2)
		s returnCountUom=$p(GlobalData,"^",3)
		s ReasonDr=$p(GlobalData,"^",5)
		s Inclb=$p(GlobalData,"^",6)
		s Inci=+Inclb
		s BUomId=$p(^INCI(Inci,1),"^",10)	//基本单位
		s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(returnCountUom,BUomId)
		s returnCount=RetQty*UomFac	//基本单位数量
		s returnReason="",returnCustomInfo=""
		s:(ReasonDr'="")&&$d(^INC("RET",ReasonDr)) returnReason=$p(^INC("RET",ReasonDr),"^",2)
		s:returnReason="" returnReason="未知原因"
		s IngdRetItm=IngdRet_"||"_ChildSub
		s returnPayType=1   ;"支付方式0：支付折扣，1：退货退款"
		s DetailStr="{""hospitalReturnId"":"""_IngdRetItm_""",""distributeId"":"""_distributionSerialID_""",""returnCount"":"""_returnCount_""",""returnReason"":"""_returnReason_""",""returnCustomInfo"":"""_returnCustomInfo_""",""returnPayType"":"""_returnPayType_"""}"
		i listdata'="" s listdata=listdata_","_DetailStr
		e  s listdata=DetailStr
	}
	q:listdata="" "-4^无需上传的退货明细"
	s InputParam=InputParam_listdata_"]}"
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	d ReturnJson.Rewind()
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode   
	s ReturnMsg=ReturnJsonObj.returnMsg
	s successList=ReturnJsonObj.successList
	s successList=ReturnJsonObj.dataList
	s ListSize=successList.Count()
	q:ListSize=0 "-999^上传退货单平台返回值为空"
	s errorObj=ReturnJsonObj.errorList
	s RetVal=0,RetMsgStr=""
	if $ISOBJECT(successList) {
		s ListSize=successList.Count()
		f i=1:1:ListSize {
			s DataObj=successList.GetAt(i)
			s ingrti=DataObj.hospitalReturnId		;医院内部退货ID
			s returnId=DataObj.returnId  ;省平台退货ID
			//保存平台退货明细编号
			&sql(UPDATE SQLUser.DHC_INGRTITM SET INGRTI_ThirdDetailId = :returnId WHERE INGRTI_RowId=:ingrti)
			i SQLCODE'=0 {
				s RetVal=-5
				i RetMsgStr="" s RetMsgStr="更新退货明细失败:"_ingrti_":"_$g(%msg)
				e  s RetMsgStr=RetMsgStr_";"_ingrti_":"_$g(%msg)
			}
		}
	}
	elseif $ISOBJECT(errorObj) {
		s errorListSize=errorObj.Count()
		s errorDesc="",errorStr=""
		f j=1:1:errorListSize {
			s errorList=errorObj.GetAt(j)
			s RetId=errorList.hospitalReturnId
			s errorDetailList=errorList.errorDetailList
			s errorDetailListSize=errorDetailList.Count()
			f k=1:1:errorDetailListSize {
				s errorDetail=errorDetailList.GetAt(k)
				s errorCode=errorDetail.errorCode
				s errorMsg=errorDetail.errorMsg
				if errorDesc'="" s errorDesc=errorDesc_","_errorMsg
				else  s errorDesc=errorMsg
			}
			if errorStr'="" s errorStr=errorStr_";"_RetId_":"_errorDesc
			else  s errorStr=RetId_":"_errorDesc
		}
		if errorStr'="" s RetVal=ReturnCode,RetMsgStr=errorStr
	}
	else {
		 s RetVal=ReturnCode,RetMsgStr=ReturnMsg
	}
	q RetVal_"^"_RetMsgStr
}

/// Part: HC014 物资 SJ013 试剂 获取退货信息
/// Creator：wxj
/// CreateDate:2020-12-22
/// Up: 20221115 lihui
/// Input: IngdRet-HIS退货单ID,currentPageNumber-指定页码, InterTypeCoce(试剂：SJ013；物资：HC014)
/// Return: 总页数数据的JSON对象
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetReturnInfo(2860,1,"2021-02-05 00:00:00","2021-02-05 23:59:59")
ClassMethod GetReturnInfo(IngdRet As %String, currentPageNumber As %String, InterTypeCoce = "HC014") As %String
{
	
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s InputStream=##class(%GlobalCharacterStream).%New()
	s InputParam="accessToken="_accessToken_"&hospitalId="_hospitalId_"&currentPageNumber="_currentPageNumber_"&params="_"{""list"":["
	s listdata="",ChildSub=""
	f  {
		s ChildSub=$o(^INGRT(IngdRet,"DHCGRR",ChildSub))
		q:ChildSub'>0
		s IngdRetItm=IngdRet_"||"_ChildSub
		s IngdRecItm=$p($g(^INGRT(IngdRet,"DHCGRR",ChildSub)),"^",1)
		s distributionSerialID=$p(^DHCINGR(+IngdRecItm,"GRI",$p(IngdRecItm,"||",2)),"^",64)  ;采购平台配送明细ID
		continue:distributionSerialID=""
		i listdata'="" s listdata=listdata_",{""distributeId"":"""_distributionSerialID_"""}"
		e  s listdata="{""distributeId"":"""_distributionSerialID_"""}"
	}
	s InputParam=InputParam_listdata_"]}"
	q:listdata="" "-2^没有需要查询的明细"
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	q:ReturnJson.Size=0 "-999^查询退货单平台返回值为空"
	
	s ReturnJsonStr=ReturnJson.Read()
	q 0_"^"_ReturnJsonStr
}

/// Part: HC003物资  SJ003试剂 获取商品列表  1.根据日期查询  2.根据产品ID(可多个)查询
/// Creator: lihui
/// CreateDate:  20221115
/// Table: CT.HRP.MAT.ALLPurCatalog
/// Input:currentPageNumber-指定页码,goodIds-产品ID集合(,分隔),userID-下载操作人ID,ProcurecatalogType 商品类型, ScBid 集采批次, InterTypeCoce(试剂：SJ003；物资：HC003)
/// Return:0-成功
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetAllPurchaseDict("1","","","39492","21297")
ClassMethod GetAllPurchaseDict(currentPageNumber As %String, goodIds As %String = "", userID As %String, procurecatalogType As %String, scBid As %String, InterTypeCoce = "HC003") As %String
{
	;q:(beginTime="")&&(endTime="")&&(goodIds="") "-2^时间和产品id不能同时为空"
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s InputStream=##class(%GlobalCharacterStream).%New()
	s listdata=""
	s InputGoodsCount=$Length(goodIds,",")
	f count=1:1:InputGoodsCount {
		s InputGoodID=$p(goodIds,",",count)
		continue:InputGoodID=""
		s Data=InputGoodID
		s Title="procurecatalogId"
		s GoodIDJsonStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
		if listdata'="" s listdata=listdata_","_GoodIDJsonStr
		else  s listdata=GoodIDJsonStr
	}
	s listdata="{""list"":["_listdata_"]}"
	s InputParam="accessToken="_accessToken_"&procurecatalogIds="_listdata_"&hospitalId="_hospitalId_"&currentPageNumber="_currentPageNumber_"&procurecatalogType="_procurecatalogType_"&scBid="_scBid
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	d ReturnJson.Rewind()
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode   
	s ReturnMsg=ReturnJsonObj.returnMsg  
	q:ReturnCode'=1 ReturnCode_"^"_ReturnMsg  
	s TotalPageCount=ReturnJsonObj.totalPageCount 	;总页数
	s TotalCounts=ReturnJsonObj.totalRecordCount  	;总条数
	s currentPageNumber=ReturnJsonObj.currentPageNumber
	s successList=ReturnJsonObj.dataList
	s ListSize=successList.Count()
	q:ListSize=0 "-999^采购目录平台返回值为空"
	s RetVal=1,RetMsgStr=""
	f i=1:1:ListSize {
		s HospitalObj=successList.GetAt(i)
		s HospitalID="" ; HospitalObj.hospitalId			;医疗机构账号
		s goodsID=HospitalObj.goodsId  				;产品Id
		continue:goodsID=""
		s oldGoodsId=HospitalObj.oldGoodsId ;关联老平台流水号
		s procurecatalogId=HospitalObj.procurecatalogId ;商品流水号
		s outLookc=HospitalObj.outLookc   ;规格
		s model=HospitalObj.model   ; 型号
		s brand=HospitalObj.brand   				;品牌
		s packOutlookc=HospitalObj.packOutlookc ;包装规格
		s priceState=HospitalObj.priceState ;价格状态
		s productName = HospitalObj.productName ;目录通用名
		s sortName=HospitalObj.sortName				;分类
		s price = HospitalObj.linkageReferencePrice ; 采购价格 联动参考价格 
		s regcode=HospitalObj.regcode ; 注册证号ID
		s regcodeName=HospitalObj.regCername		;注册证名称
		s regCerno=HospitalObj.regCerno ; 注册证号
		s regEndTime=HospitalObj.regEndTime ; 注册证截止日期
		s udiCode=HospitalObj.udiCode ; UDI耗材唯一码
		s hclcCode=HospitalObj.hclcCode ; 联采（或国家）平台唯一编码
		s shcDetailId=HospitalObj.shcDetailId ;联盟地区省级平台耗材规格型号编码
		s lastMinPrice=HospitalObj.lastMinPrice ;上月最低价
		s maxPrice=HospitalObj.maxPrice ;最高价格
		s minPrice=HospitalObj.minPrice ;最低价格
		s avgPrice=HospitalObj.avgPrice ;平均价格
		s isMade=HospitalObj.isMade ;是否国产(0:进口,1:国产)
		s isBid=HospitalObj.isBid ; 是否中选（0:非中选、1：中选）
		s scBid=HospitalObj.scBid ;集采批次
		i regEndTime="null" s regEndTime=""
		s regEndDate=$p(regEndTime," ",1)
		s:regEndDate'="" regEndDate=$zdh(regEndDate,3)
		s companyIdPs=HospitalObj.companyIdPs		;医疗机构设置的配送商编号
		s companyNamePs=HospitalObj.companyNamePs	;医疗机构设置的配送商
		s companyIdSc= HospitalObj.companyIdSc ;生产企业编号
		s companyNameSc = HospitalObj.companyNameSc ;生产企业名称
		s companyIdTb=HospitalObj.companyIdTb		; 申报企业编号
		s companyNameTb=HospitalObj.companyNameTb	; 申报企业
		s ybCode= HospitalObj.ybCode ; 医保耗材代码
		s pack= HospitalObj.pack ;包装材质
		s nineState=HospitalObj.nineState ; 九段线状态
		s bidPrice=HospitalObj.bidPrice ;  挂网现价/中选价
		s material=HospitalObj.material ;产品材质
		s productNameFirst="" ; HospitalObj.productNameFirst  	;一级目录
		s productNameSecond="" ; HospitalObj.productNameSecond	;二级目录
		s productNameThree="" ; HospitalObj.productNameThree  	;三级目录
		s goodsName="" ;HospitalObj.goodsName   		;产品名
		s factor="" ; HospitalObj.factor ; 转换比c
		s unit=HospitalObj.calUnit    					;单位
		s source="" ; HospitalObj.source 				;来源
		s purchasePrice="" ; HospitalObj.purchasePrice	;医疗机构设置采购价格
		s materialName="" ;HospitalObj.materialName ;目录材质
		s isUsing="" ; HospitalObj.isUsing ; 是否启用,启用(1)停用(0)
		s purchaseType="" ; HospitalObj.purchaseType		;采购类别
		s addDateTime="" ;HospitalObj.addTime			;添加时间
		i addDateTime="null" s addDateTime=""
		s addDate=$p(addDateTime," ",1)
		s:addDate'="" addDate=$zdh(addDate,3)
		s addTime=$p(addDateTime," ",2)
		s:addTime'="" addTime=$zth(addTime,3)
		s lastUpDateTime=HospitalObj.lastUpdateTime	;最后更新时间
		i lastUpDateTime="null" s lastUpDateTime=""
		s lastUpDate=$p(lastUpDateTime," ",1)
		s:lastUpDate'="" lastUpDate=$zdh(lastUpDate,3)
		s lastUpTime=$p(lastUpDateTime," ",2)
		s:lastUpTime'="" lastUpTime=$zth(lastUpTime,3)
		s dailPurchasePrice="" ; HospitalObj.dailPurchasePrice			;其他采购价格(与其他采购标识对应)
		s purchaseIdentification="" ; HospitalObj.purchaseIdentification	;其他采购类型标识(0:禁用,1:带量采购)
		
		s ALLPurCatalogRowId=$o(^CT.HRP.MAT.ALLPurCatalogI("GOODSID",goodsID,0))
		if +ALLPurCatalogRowId=0 {
			s ALLPurCatalog=##Class(CT.HRP.MAT.ALLPurCatalog).%New()
		}
		else {
			s ALLPurCatalog=##Class(CT.HRP.MAT.ALLPurCatalog).%OpenId(ALLPurCatalogRowId)
		}
		s ALLPurCatalog.DHCMAPCHospId=HospitalID
		s ALLPurCatalog.DHCMAPCGoodsId=goodsID
		s ALLPurCatalog.DHCMAPCSortName=sortName
		s ALLPurCatalog.DHCMAPCProductNameFirst=productNameFirst
		s ALLPurCatalog.DHCMAPCProductNameSecond=productNameSecond
		s ALLPurCatalog.DHCMAPCProductNameThree=productNameThree
		s ALLPurCatalog.DHCMAPCGoodsName=goodsName
		s ALLPurCatalog.DHCMAPCUnit=unit
		s ALLPurCatalog.DHCMAPCRegCodeName=regcodeName
		s ALLPurCatalog.DHCMAPCBrand=brand
		s ALLPurCatalog.DHCMAPCSource=source
		s ALLPurCatalog.DHCMAPCPurchasePrice=price
		s ALLPurCatalog.DHCMAPCDailPurchasePrice=bidPrice
		s ALLPurCatalog.DHCMAPCCompanyIdTb=companyIdTb
		s ALLPurCatalog.DHCMAPCCompanyNameTb=companyNameTb
		s ALLPurCatalog.DHCMAPCCompanyIdPs=companyIdPs
		s ALLPurCatalog.DHCMAPCCompanyNamePs=companyNamePs
		s ALLPurCatalog.DHCMAPCPurchaseType=purchaseType
		s ALLPurCatalog.DHCMAPCAddDate=addDate
		s ALLPurCatalog.DHCMAPCAddTime=addTime
		s ALLPurCatalog.DHCMAPCLastUpdateDate=lastUpDate
		s ALLPurCatalog.DHCMAPCLastUpdateTime=lastUpTime
		s ALLPurCatalog.DHCMAPCDownDate=+$h
		s ALLPurCatalog.DHCMAPCDownTime=$p($h,",",2)
		s ALLPurCatalog.DHCMAPCDailPurchasePrice=dailPurchasePrice
		s ALLPurCatalog.DHCMAPCPurchaseIDentification=purchaseIdentification
		d ALLPurCatalog.DHCMAPCDownUserSetObjectId(userID)
		s ALLPurCatalog.DHCMAPCProductName=productName
		s ALLPurCatalog.DHCMAPCFactor=factor
		s ALLPurCatalog.DHCMAPCCompanyIdSc=companyIdSc
		s ALLPurCatalog.DHCMAPCCompanyNameSc=companyNameSc
		s ALLPurCatalog.DHCMAPCMaterialName=material
		s ALLPurCatalog.DHCMAPCYBCode=ybCode
		s ALLPurCatalog.DHCMAPCIsUsing=isUsing
		s ALLPurCatalog.DHCMAPCRegNo=regCerno
		s ALLPurCatalog.DHCMAPCRegCode=regcode
		s ALLPurCatalog.DHCMAPCRegEndDate=regEndDate
		s ALLPurCatalog.DHCMAPCPackOutlookc=packOutlookc
		s ALLPurCatalog.DHCMAPCOutLookc=outLookc
		s ALLPurCatalog.DHCMAPCGoodsType=model
		s ALLPurCatalog.DHCMAPCProcurecatalogId=procurecatalogId
		s ALLPurCatalog.DHCMAPCPack=pack
		s ALLPurCatalog.DHCMAPCnineState=nineState
		s ALLPurCatalog.DHCMAPCbargainStatus=priceState
		s ALLPurCatalog.DHCMAPCudiCode=udiCode
		s ALLPurCatalog.DHCMAPChclcCode=hclcCode
		s ALLPurCatalog.DHCMAPCshcDetailId=shcDetailId
		s ALLPurCatalog.DHCMAPClastMinPrice=lastMinPrice
		s ALLPurCatalog.DHCMAPCmaxPrice=maxPrice
		s ALLPurCatalog.DHCMAPCminPrice=minPrice
		s ALLPurCatalog.DHCMAPCavgPrice=avgPrice
		s ALLPurCatalog.DHCMAPCisMade=isMade
		s ALLPurCatalog.DHCMAPCisBid=isBid
		s ALLPurCatalog.DHCMAPCscBid=scBid
		s RetVal=ALLPurCatalog.%Save()
		if RetVal'=1 {
			s RetMsg=$SYSTEM.Status.GetErrorText(RetVal)
			s RetMsgStr=$s(RetMsgStr="":RetMsgStr=RetVal,1:RetMsgStr=RetMsgStr_";"_goodsID_":"_RetMsg)
		}
	}
	s:RetMsgStr="" RetMsgStr=TotalPageCount_"^"_TotalCounts
	q RetVal_"^"_RetMsgStr
}

/// Part: HC004物资 SJ004试剂 获取医院常用采购目录  1.根据日期查询  2.根据产品ID(可多个)查询
/// Creator：wxj
/// CreateDate:2020-12-22
/// Update lihui 20221115
/// Input:currentPageNumber-指定页码,goodIds-产品ID集合(,分隔),userID-下载操作人ID,ProcurecatalogType 商品类型, InterTypeCoce(试剂：SJ004；物资：HC004)
/// Return:0-成功
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetPurchaseDict("1","","","39492","21297")
ClassMethod GetPurchaseDict(currentPageNumber As %String, goodIds As %String = "", userID As %String, procurecatalogType As %String, InterTypeCoce = "HC004") As %String
{
	;q:(beginTime="")&&(endTime="")&&(goodIds="") "-2^时间和产品id不能同时为空"
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s InputStream=##class(%GlobalCharacterStream).%New()
	s listdata=""
	s InputGoodsCount=$Length(goodIds,",")
	f count=1:1:InputGoodsCount {
		s InputGoodID=$p(goodIds,",",count)
		continue:InputGoodID=""
		s Data=InputGoodID
		s Title="procurecatalogId"
		s GoodIDJsonStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
		if listdata'="" s listdata=listdata_","_GoodIDJsonStr
		else  s listdata=GoodIDJsonStr
	}
	s:listdata'="" listdata="{""list"":["_listdata_"]}"
	s month=""
	s InputParam="accessToken="_accessToken_"&procurecatalogIds="_listdata_"&month="_month_"&hospitalId="_hospitalId_"&currentPageNumber="_currentPageNumber_"&procurecatalogType="_procurecatalogType
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	d ReturnJson.Rewind()
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode   
	s ReturnMsg=ReturnJsonObj.returnMsg  
	q:ReturnCode'=1 ReturnCode_"^"_ReturnMsg  
	s TotalPageCount=ReturnJsonObj.totalPageCount 	;总页数
	s TotalCounts=ReturnJsonObj.totalRecordCount  	;总条数
	s currentPageNumber=ReturnJsonObj.currentPageNumber
	s successList=ReturnJsonObj.dataList
	s ListSize=successList.Count()
	q:ListSize=0 "-999^医院常用采购目录平台返回值为空"
	s RetVal=1,RetMsgStr=""
	f i=1:1:ListSize {
		s HospitalObj=successList.GetAt(i)
		s HospitalID="" ; HospitalObj.hospitalId			;医疗机构账号
		s goodsID=HospitalObj.goodsId  				;产品Id
		continue:goodsID=""
		s procurecatalogId=HospitalObj.procurecatalogId ;商品流水号
		s outLookc=HospitalObj.outLookc   ;规格
		s model=HospitalObj.model   ; 型号
		s brand=HospitalObj.brand   				;品牌
		s packOutlookc=HospitalObj.packOutlookc ;包装规格
		s priceState=HospitalObj.priceState ;价格状态
		s productName = HospitalObj.productName ;目录通用名
		s sortName=HospitalObj.sortName				;分类
		s price = HospitalObj.price ; 采购价格 
		s regcode=HospitalObj.regcode ; 注册证号ID
		s regcodeName=HospitalObj.regCername		;注册证名称
		s regCerno=HospitalObj.regCerno ; 注册证号
		s regEndTime=HospitalObj.regEndTime ; 注册证截止日期
		i regEndTime="null" s regEndTime=""
		s regEndDate=$p(regEndTime," ",1)
		s:regEndDate'="" regEndDate=$zdh(regEndDate,3)
		s companyIdPs=HospitalObj.companyIdPs		;医疗机构设置的配送商编号
		s companyNamePs=HospitalObj.companyNamePs	;医疗机构设置的配送商
		s companyIdSc= HospitalObj.companyIdSc ;生产企业编号
		s companyNameSc = HospitalObj.companyNameSc ;生产企业名称
		s companyIdTb=HospitalObj.companyIdTb		; 申报企业编号
		s companyNameTb=HospitalObj.companyNameTb	; 申报企业
		s ybCode= HospitalObj.ybCode ; 医保耗材代码
		s pack= HospitalObj.pack ;包装材质
		s nineState=HospitalObj.nineState ; 九段线状态
		s bidPrice=HospitalObj.bidPrice ;  挂网现价/中选价
		s material=HospitalObj.material ;产品材质
		s productNameFirst="" ; HospitalObj.productNameFirst  	;一级目录
		s productNameSecond="" ; HospitalObj.productNameSecond	;二级目录
		s productNameThree="" ; HospitalObj.productNameThree  	;三级目录
		s goodsName="" ;HospitalObj.goodsName   		;产品名
		s factor="" ; HospitalObj.factor ; 转换比c
		s unit="" ;HospitalObj.unit    					;单位
		s source="" ; HospitalObj.source 				;来源
		s purchasePrice="" ; HospitalObj.purchasePrice	;医疗机构设置采购价格
		s materialName="" ;HospitalObj.materialName ;目录材质
		s isUsing="" ; HospitalObj.isUsing ; 是否启用,启用(1)停用(0)
		s purchaseType="" ; HospitalObj.purchaseType		;采购类别
		s addDateTime="" ;HospitalObj.addTime			;添加时间
		i addDateTime="null" s addDateTime=""
		s addDate=$p(addDateTime," ",1)
		s:addDate'="" addDate=$zdh(addDate,3)
		s addTime=$p(addDateTime," ",2)
		s:addTime'="" addTime=$zth(addTime,3)
		s lastUpDateTime=HospitalObj.lastUpdateTime	;最后更新时间
		i lastUpDateTime="null" s lastUpDateTime=""
		s lastUpDate=$p(lastUpDateTime," ",1)
		s:lastUpDate'="" lastUpDate=$zdh(lastUpDate,3)
		s lastUpTime=$p(lastUpDateTime," ",2)
		s:lastUpTime'="" lastUpTime=$zth(lastUpTime,3)
		s dailPurchasePrice="" ; HospitalObj.dailPurchasePrice			;其他采购价格(与其他采购标识对应)
		s purchaseIdentification="" ; HospitalObj.purchaseIdentification	;其他采购类型标识(0:禁用,1:带量采购)

		s MatPurCatalogRowId=$o(^DHCMatPurCataLog(0,"GoodsId",goodsID,0))
		if +MatPurCatalogRowId=0 {
			s DHCMatPurCatalog=##Class(User.DHCMatPurCatalog).%New()
		}
		else {
			s DHCMatPurCatalog=##Class(User.DHCMatPurCatalog).%OpenId(MatPurCatalogRowId)
		}
		s DHCMatPurCatalog.DHCMPCHospId=HospitalID
		s DHCMatPurCatalog.DHCMPCGoodsId=goodsID
		s DHCMatPurCatalog.DHCMPCSortName=sortName
		s DHCMatPurCatalog.DHCMPCProductNameFirst=productNameFirst
		s DHCMatPurCatalog.DHCMPCProductNameSecond=productNameSecond
		s DHCMatPurCatalog.DHCMPCProductNameThree=productNameThree
		s DHCMatPurCatalog.DHCMPCGoodsName=goodsName
		s DHCMatPurCatalog.DHCMPCUnit=unit
		s DHCMatPurCatalog.DHCMPCRegCodeName=regcodeName
		s DHCMatPurCatalog.DHCMPCBrand=brand
		s DHCMatPurCatalog.DHCMPCSource=source
		s DHCMatPurCatalog.DHCMPCPurchasePrice=price
		s DHCMatPurCatalog.DHCMPCDailPurchasePrice=bidPrice
		s DHCMatPurCatalog.DHCMPCCompanyIdTb=companyIdTb
		s DHCMatPurCatalog.DHCMPCCompanyNameTb=companyNameTb
		s DHCMatPurCatalog.DHCMPCCompanyIdPs=companyIdPs
		s DHCMatPurCatalog.DHCMPCCompanyNamePs=companyNamePs
		s DHCMatPurCatalog.DHCMPCPurchaseType=purchaseType
		s DHCMatPurCatalog.DHCMPCAddDate=addDate
		s DHCMatPurCatalog.DHCMPCAddTime=addTime
		s DHCMatPurCatalog.DHCMPCLastUpdateDate=lastUpDate
		s DHCMatPurCatalog.DHCMPCLastUpdateTime=lastUpTime
		s DHCMatPurCatalog.DHCMPCDownDate=+$h
		s DHCMatPurCatalog.DHCMPCDownTime=$p($h,",",2)
		s DHCMatPurCatalog.DHCMPCPurchaseIDentification=purchaseIdentification
		d DHCMatPurCatalog.DHCMPCDownUserSetObjectId(userID)
		s DHCMatPurCatalog.DHCMPCProductName=productName
		s DHCMatPurCatalog.DHCMPCFactor=factor
		s DHCMatPurCatalog.DHCMPCCompanyIdSc=companyIdSc
		s DHCMatPurCatalog.DHCMPCCompanyNameSc=companyNameSc
		s DHCMatPurCatalog.DHCMPCMaterialName=material
		s DHCMatPurCatalog.DHCMPCYBCode=ybCode
		s DHCMatPurCatalog.DHCMPCIsUsing=isUsing
		s DHCMatPurCatalog.DHCMPCRegNo=regCerno
		s DHCMatPurCatalog.DHCMPCRegCode=regcode
		s DHCMatPurCatalog.DHCMPCRegEndDate=regEndDate
		s DHCMatPurCatalog.DHCMPCPackOutlookc=packOutlookc
		s DHCMatPurCatalog.DHCMPCOutLookc=outLookc
		s DHCMatPurCatalog.DHCMPCGoodsType=model
		s DHCMatPurCatalog.DHCMPCProcurecatalogId=procurecatalogId
		s DHCMatPurCatalog.DHCMPCPack=pack
		s DHCMatPurCatalog.DHCMPCnineState=nineState
		s DHCMatPurCatalog.DHCMPCbargainStatus=priceState
		s RetVal=DHCMatPurCatalog.%Save()
		if RetVal'=1 {
			s RetMsg=$SYSTEM.Status.GetErrorText(RetVal)
			s RetMsgStr=$s(RetMsgStr="":RetMsgStr=RetVal,1:RetMsgStr=RetMsgStr_";"_goodsID_":"_RetMsg)
		}
	}
	s:RetMsgStr="" RetMsgStr=TotalPageCount_"^"_TotalCounts
	q RetVal_"^"_RetMsgStr
}

/// 下载 商品列表 HC003物资 SJ003试剂 以及 医院常用商品目录 HC004物资 SJ004试剂 一并处理
/// Creator：lihui
/// CreateDate: 20221115
/// Table：User.DHCMatPurCatalog 医院常用商品目录，CT.HRP.MAT.ALLPurCatalog 商品列表
/// Input: currentPageNumber-指定页码,goodsId-产品ID ，userID 操作人ID,ProcurecatalogType 商品类型, ScBid 集采批次
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetProductInfo("1","","","271","21297")
ClassMethod GetProductInfo(currentPageNumber As %String = "1", goodIds As %String, userID As %String, ProcurecatalogType As %String, ScBid As %String) As %String
{
	s ^litmp("GetProductInfo")=$lb(currentPageNumber,goodIds,userID,ProcurecatalogType,ScBid)
	s RtnObj=""
	i (..#Version="HisUI") s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s (MainTotalPageAll,MainTotalCountAll,MainTotalPage,MainTotalCount)=0
	s retmsg="",RetVal=1
	f PageNumber=1:1:currentPageNumber  d
	.;商品列表 物资
	.s RetInfoAll=..GetAllPurchaseDict(PageNumber,goodIds,userID,ProcurecatalogType,ScBid,"HC003")
	.s RetVal=$p(RetInfoAll,"^",1)
	.s MainTotalPageAll=MainTotalPageAll+$p(RetInfoAll,"^",2)
	.s MainTotalCountAll=MainTotalCountAll+$p(RetInfoAll,"^",3)
	.i RetVal'=1   s retmsg=retmsg_"商品列表物资下载失败"_RetInfoAll
	.
	.;商品列表 试剂
	.s RetInfoAll=..GetAllPurchaseDict(PageNumber,goodIds,userID,ProcurecatalogType,ScBid,"SJ003")
	.s RetVal=$p(RetInfoAll,"^",1)
	.s MainTotalPageAll=MainTotalPageAll+$p(RetInfoAll,"^",2)
	.s MainTotalCountAll=MainTotalCountAll+$p(RetInfoAll,"^",3)
	.i RetVal'=1   s retmsg=retmsg_"商品列表试剂下载失败"_RetInfoAll
	.
	.;医院常用商品目录 物资
	.s RetInfo=..GetPurchaseDict(PageNumber,goodIds,userID,ProcurecatalogType,"HC004")
	.s RetVal=$p(RetInfo,"^",1)
	.s MainTotalPage=MainTotalPage+$p(RetInfo,"^",2)
	.s MainTotalCount=MainTotalCount+$p(RetInfo,"^",3)
	.i RetVal'=1  s retmsg=retmsg_"医院常用商品物资目录下载失败"_RetInfo
	.
	.;医院常用商品目录 试剂
	.s RetInfo=..GetPurchaseDict(PageNumber,goodIds,userID,ProcurecatalogType,"SJ004")
	.s RetVal=$p(RetInfo,"^",1)
	.s MainTotalPage=MainTotalPage+$p(RetInfo,"^",2)
	.s MainTotalCount=MainTotalCount+$p(RetInfo,"^",3)
	.i RetVal'=1  s retmsg=retmsg_"医院常用商品试剂目录下载失败"_RetInfo
	.
	s:retmsg'="" RetVal=-1
	s:retmsg="" retmsg=MainTotalPage_"^"_MainTotalCount_"&"_MainTotalPageAll_"^"_MainTotalCountAll,RetVal=0
	i (..#Version="Ext") q RetVal_"^"_retmsg 
	d RtnObj.Err(RetVal,"",retmsg,"",0)
	q RtnObj.Json()
}

/// Description:按时间批量下载采购目录、采购规格型号信息  后台执行命令 批量下载
/// Creator：wxj
/// CreateDate：2021-01-04
/// Input：开始时间、截止时间、下载人ID
/// OutPut：总共下载的页数
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).ALLDownPurchaseDict("2019-10-01 00:00:00","2021-01-01 23:59:59",1)
ClassMethod ALLDownPurchaseDict(beginTime As %String, endTime As %String, userID As %String)
{
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:tokenStatus'=1 "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s Page=1
	s RetInfo=..GetProductInfo(Page, beginTime, endTime,"", userID)
	q:$p(RetInfo,"^",1)'=0 RetInfo
	w !,"第"_Page_"页下载完成"
	s TotalPage=$p(RetInfo,"^",2)
	s TotalRow=$p(RetInfo,"^",3)
	f i=2:1:TotalPage d
	.s TmpRetInfo=..GetProductInfo(i, beginTime, endTime,"", userID )
	.i $p(TmpRetInfo,"^",1)'=0 w !,"第"_i_"页下载失败"
	.e  w !,"第"_i_"页下载完成"
	w !
	q "共"_TotalPage_"页(共"_TotalRow_"行)"
}

/// 判断订单明细是否存在对照的
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).InpoIflink(799)
ClassMethod InpoIflink(PoId As %String)
{
	q:PoId="" "Y"
	s flag="N"
	s chl=""
	f  s chl=$o(^INPO(PoId,"POI",chl)) q:(chl="")!(flag="Y")  d
	.q:'$d(^INPO(PoId,"POI",chl))
	.s inci=$p(^INPO(PoId,"POI",chl),"^",1)
	.s YGCGInfo=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetSubCode(inci)
	.i YGCGInfo'="" s flag="Y"
	q flag
}

/// Part: 物资(HC007、HC008、HC009) 试剂(SJ006、SJ007、SJ008) 同步订单一步式完成
/// Creator：wxj
/// CreateDate:2020-12-22
/// Update: lihui 20221115
/// Description：上传HIS订单到阳光采购平台
/// Input: PoId-HIS订单ID
/// Return:0^成功
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).UpLoadPo(10146)
ClassMethod UpLoadPo(PoId As %String)
{
	q:(PoId="") "-1^订单ID不能为空！"
	//创建空的订单
	q:..InpoIflink(PoId)'="Y" "-1^明细中没有对照的商品"
	s dhcPoId=$o(^DHCINPO(0,"INPO",PoId,0))
	s PurPlanCodeId=""
	s:dhcPoId'="" PurPlanCodeId=$p(^DHCINPO(dhcPoId),"^",14)
	q:PurPlanCodeId'="" "-2^订单已经上传，不能重复上传"
	s RetInfo="0^"
	s MRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetMRDocFlag(PoId,"PO")
	i MRDocFlag="Y"   {
		s RetInfo=..AddOrder(PoId,"SJ006")
		s RetVal=$p(RetInfo,"^",1)
		q:RetVal'=0 RetInfo
		s OrderId=$p(RetInfo,"^",2)	
		//添加订单明细
		s RetInfo=..AddOrderDetail(PoId,OrderId,"SJ007")
		s RetVal=$p(RetInfo,"^",1)
		i RetVal'=0 d
		.&sql(UPDATE SQLUser.DHC_INPO SET PO_PurPlanCodeId =NULL WHERE PO_INPO_DR = :PoId)
		.&sql(UPDATE SQLUser.IN_POItm SET INPOI_ThirdOrderDetailId = NULL WHERE IN_PO=:PoId)
		q:RetVal'=0 RetInfo
		//提交订单
		s RetInfo=..CommitOrder(OrderId,"SJ008")
		s RetVal=$p(RetInfo,"^",1)
		q:RetVal'=0 RetInfo
		
	}else{
		s RetInfo=..AddOrder(PoId,"HC007")
		s RetVal=$p(RetInfo,"^",1)
		q:RetVal'=0 RetInfo
		s OrderId=$p(RetInfo,"^",2)	
		//添加订单明细
		s RetInfo=..AddOrderDetail(PoId,OrderId,"HC008")
		s RetVal=$p(RetInfo,"^",1)
		i RetVal'=0 d
		.&sql(UPDATE SQLUser.DHC_INPO SET PO_PurPlanCodeId =NULL WHERE PO_INPO_DR = :PoId)
		.&sql(UPDATE SQLUser.IN_POItm SET INPOI_ThirdOrderDetailId = NULL WHERE IN_PO=:PoId)
		q:RetVal'=0 RetInfo
		//提交订单
		s RetInfo=..CommitOrder(OrderId,"HC009")
		s RetVal=$p(RetInfo,"^",1)
		q:RetVal'=0 RetInfo
	}
	q RetInfo
}

/// ------前端调用方法-----
/// Creator：wxj
/// CreateDate:2020-12-20
/// Description：EXT版本批量上传HIS订单到阳光采购平台
/// Input:PoIdStr-HIS订单ID集合
/// Return:成功:0;失败:成功信息+失败信息
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JsUpLoadPo("54183")
ClassMethod JsUpLoadPo(PoIdStr As %String)
{
	q:(PoIdStr="") "-1^订单ID不能为空！"
	s del="^"
	s (result,sucret,failret)=""
	s (suc,fail)=0
	s len=$l(PoIdStr,del)
	f i=1:1:len  d
	.s PoId=$p(PoIdStr,del,i)
	.s ret=..UpLoadPo(PoId)
	.i +ret=0 d
	..s suc=suc+1
	..s:sucret="" sucret=PoId
	..s:sucret'="" sucret=sucret_"^"_PoId
	.e  d
	..s fail=fail+1
	..i failret="" s failret=PoId_":"_ret
	..e  s failret=failret_"^"_PoId_":"_ret
	i fail=0 s result=0   //全部成功
	e  s result=suc_","_fail_","_sucret_","_failret
	q result
}

/// ExT版本查询已下载的采购目录信息
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryMatPurCatalog(0,30,"","")
ClassMethod JSQueryMatPurCatalog(Start As %String, Limit As %String, Params As %String = "")
{
	s PurSubCode=$p(Params,"^",1)
	s PurCode=$p(Params,"^",2)
	s PurName=$p(Params,"^",3)
	s Spec=$p(Params,"^",4)
	s End=Start+Limit
	s Num=0
	s json = ##class(Code.JsonObj).%New()
	s MPCId=0
	f  s MPCId=$o(^DHCMatPurCataLog(MPCId)) q:+MPCId=0  d
	.s maindata=$g(^DHCMatPurCataLog(MPCId))
	.q:maindata=""
	.s DHCMPCHospId=$p(maindata,"^",1)
	.s GoodsId=$p(maindata,"^",3)

	.s procurecatalogId=$p(maindata,"^",43)
	.q:(PurCode'="")&&(GoodsId'[PurCode)
	.s SortName=$p(maindata,"^",4)
	.s ProductNameFirst=$p(maindata,"^",5)
	.s ProductNameSecond=$p(maindata,"^",6)
	.s ProductNameThree=$p(maindata,"^",30)
	.s GoodsName=$p(maindata,"^",7)
	.s productName=$p(maindata,"^",31)  ;通用名
	.q:(PurName'="")&&(productName'[PurName)
	.s GoodsName=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(GoodsName,"'","\'")
    	.s GoodsName=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(GoodsName,"\","\\")
	.;if $Find(GoodsName,"'") s GoodsName=$tr(GoodsName,"''")
	.s Unit=$p(maindata,"^",10)
	.s RegCodeName=$p(maindata,"^",11)
	.s regCerno=$p(maindata,"^",40) 
	.s regcode=$p(maindata,"^",41)
	.s RegEndDate=$p(maindata,"^",42)
	.s:RegEndDate'="" RegEndDate=$zd(RegEndDate,3)
	.s Brand=$p(maindata,"^",12)
	.s Source=$p(maindata,"^",13)
	.s PurchasePrice=$p(maindata,"^",14)
	.s CompanyIdTb=$p(maindata,"^",15)
	.s CompanyNameTb=$p(maindata,"^",16)
	.s CompanyIdPs=$p(maindata,"^",17)
	.s CompanyNamePs=$p(maindata,"^",18)
	.s PurchaseType=$p(maindata,"^",19)
	.s AddDate=$p(maindata,"^",20)
	.s:AddDate'="" AddDate=$zd(AddDate,3)
	.s AddTime=$p(maindata,"^",21)
	.s:AddTime'="" AddTime=$zt(AddTime,1)
	.s LastUpdateDate=$p(maindata,"^",22)
	.s:LastUpdateDate'="" LastUpdateDate=$zd(LastUpdateDate,3)
	.s LastUpdateTime=$p(maindata,"^",23)
	.s:LastUpdateTime'="" LastUpdateTime=$zt(LastUpdateTime,1)
	.s DownDate=$p(maindata,"^",24)
	.s:DownDate'="" DownDate=$zd(DownDate,3)
	.s DownTime=$p(maindata,"^",25)
	.s:DownTime'="" DownTime=$zt(DownTime,1)
	.s DownUserDr=$p(maindata,"^",26)
	.s DailPurchasePrice=$p(maindata,"^",28)
	.s PurchaseIDentification=$p(maindata,"^",29)
	.s bargainStatus=$p(maindata,"^",38)
	.s contractStatus=$p(maindata,"^",39)
	.s Pack=$p(maindata,"^",45)
	.s ybCode=$p(maindata,"^",35)
	.s nineState=$p(maindata,"^",46)
	.s:PurchaseIDentification=0 PurchaseIDentification="禁用"
	.s:PurchaseIDentification=1 PurchaseIDentification="带量采购"
	.s DownUser=""
	.i DownUserDr'="" s DownUser=$p($g(^SSU("SSUSR",DownUserDr)),"^",2)
	.
	.s INCI=$o(^DHCItmPCRelation(0,"LOG",MPCId,""))
	.s InciCode=$s(INCI'="":$p(^INCI(INCI,1),"^",1),1:"")
	.;s InciInfo=..GetComparedData(SMListId)
	.;s INCI=$p(InciInfo,"^",1)
	.;s InciCode=$p(InciInfo,"^",2)
	.s SMListId=""
	.s SubCodeId=""
	.s packOutlookc=$p(maindata,"^",44)
	.s OutLookc=$p(maindata,"^",8)
	.s GoodsType=""
	.q:(Spec'="")&&(OutLookc'[Spec)
	.s OutLookc=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(OutLookc,"'","\'")
	.s OutLookc=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(OutLookc,"\","\\")
	.s GoodsType=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(GoodsType,"'","\'")
	.s GoodsType=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(GoodsType,"\","\\")
	.s packOutlookc=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(packOutlookc,"'","\'")
	.s packOutlookc=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(packOutlookc,"\","\\")
	.s MinUnitMeasure=""
	.s MinUnitSale=""
	.s MinUnitPackage=""
	.s MinUnitPrice=""
	.s Data1=MPCId_"^"_DHCMPCHospId_"^"_GoodsId_"^"_SortName_"^"_ProductNameFirst
	.s Data2=ProductNameSecond_"^"_ProductNameThree_"^"_GoodsName_"^"_Unit_"^"_RegCodeName
	.s Data3=Brand_"^"_Source_"^"_PurchasePrice_"^"_CompanyIdTb_"^"_CompanyNameTb
	.s Data4=CompanyIdPs_"^"_CompanyNamePs_"^"_PurchaseType_"^"_DailPurchasePrice_"^"_PurchaseIDentification
	.s Data5=AddDate_"^"_AddTime_"^"_LastUpdateDate_"^"_LastUpdateTime_"^"_DownDate
	.s Data6=DownTime_"^"_DownUser_"^"_INCI_"^"_InciCode_"^"_SMListId
	.s Data7=SubCodeId_"^"_OutLookc_"^"_GoodsType_"^"_MinUnitMeasure_"^"_MinUnitSale
	.s Data8=MinUnitPackage_"^"_MinUnitPrice_"^"_bargainStatus_"^"_contractStatus_"^"_Pack
	.s Data9=regCerno_"^"_regcode_"^"_packOutlookc_"^"_procurecatalogId_"^"_ybCode
	.s Data10=RegEndDate_"^"_nineState_"^"_productName
	.s DataStr=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6_"^"_Data7_"^"_Data8_"^"_Data9_"^"_Data10
	.s Num=Num+1
    .q:Num<=Start
    .q:Num>End
    .d json.InsertRowData(DataStr)
    s Title1="MPCId^DHCMPCHospId^GoodsId^SortName^ProductNameFirst"
    s Title2="ProductNameSecond^ProductNameThree^GoodsName^Unit^RegCodeName"
    s Title3="Brand^Source^PurchasePrice^CompanyIdTb^CompanyNameTb"
    s Title4="CompanyIdPs^CompanyNamePs^PurchaseType^DailPurchasePrice^PurchaseIDentification"
    s Title5="AddDate^AddTime^LastUpdateDate^LastUpdateTime^DownDate"
    s Title6="DownTime^DownUser^INCI^InciCode^SMListId"
    s Title7="SubCodeId^OutLookc^GoodsType^MinUnitMeasure^MinUnitSale"
    s Title8="MinUnitPackage^MinUnitPrice^bargainStatus^contractStatus^Pack"
    s Title9="regCerno^regcode^packOutlookc^procurecatalogId^ybCode"
    s Title10="RegEndDate^nineState^productName"
    s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4_"^"_Title5_"^"_Title6_"^"_Title7_"^"_Title8_"^"_Title9_"^"_Title10
    s ItmDetailInfo=json.getJsonData(Title,Num)
    k json
    q ItmDetailInfo
}

/// HIUSI EXT 版本查询已下载的采购目录信息
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryMatPurCatalogNew("1","15","^G1044248^^")
ClassMethod JSQueryMatPurCatalogNew(page As %String, rows As %String, Params As %String = "")
{
	s Start=page
	i (..#Version="HisUI")  d
	.s Start=(page-1)*rows
	s Limit=rows
	s End=Start+Limit
	s PurSubCode=$p(Params,"^",1)
	s PurCode=$p(Params,"^",2)
	s PurName=$p(Params,"^",3)
	s Spec=$p(Params,"^",4)
	s Num=0
	s json=..GetJsonObj()
	s MPCId=0
	f  s MPCId=$o(^DHCMatPurCataLog(MPCId)) q:+MPCId=0  d
	.s maindata=$g(^DHCMatPurCataLog(MPCId))
	.q:maindata=""
	.s DHCMPCHospId=$p(maindata,"^",1)
	.s GoodsId=$p(maindata,"^",3)
	.s procurecatalogId=$p(maindata,"^",43)
	.q:(PurCode'="")&&(GoodsId'[PurCode)
	.s SortName=$p(maindata,"^",4)
	.s ProductNameFirst=$p(maindata,"^",5)
	.s ProductNameSecond=$p(maindata,"^",6)
	.s ProductNameThree=$p(maindata,"^",30)
	.s GoodsName=$p(maindata,"^",7)
	.s productName=$p(maindata,"^",31)  ;通用名
	.q:(PurName'="")&&(productName'[PurName)
	.s GoodsName=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(GoodsName,"'","\'")
    .s GoodsName=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(GoodsName,"\","\\")
	.;if $Find(GoodsName,"'") s GoodsName=$tr(GoodsName,"''")
	.s Unit=$p(maindata,"^",10)
	.s RegCodeName=$p(maindata,"^",11)
	.s regCerno=$p(maindata,"^",40) 
	.s regcode=$p(maindata,"^",41)
	.s RegEndDate=$p(maindata,"^",42)
	.s:RegEndDate'="" RegEndDate=$zd(RegEndDate,3)
	.s Brand=$p(maindata,"^",12)
	.s Source=$p(maindata,"^",13)
	.s PurchasePrice=$p(maindata,"^",14)
	.s CompanyIdTb=$p(maindata,"^",15)
	.s CompanyNameTb=$p(maindata,"^",16)
	.s CompanyIdPs=$p(maindata,"^",17)
	.s CompanyNamePs=$p(maindata,"^",18)
	.s PurchaseType=$p(maindata,"^",19)
	.s AddDate=$p(maindata,"^",20)
	.s:AddDate'="" AddDate=$zd(AddDate,3)
	.s AddTime=$p(maindata,"^",21)
	.s:AddTime'="" AddTime=$zt(AddTime,1)
	.s LastUpdateDate=$p(maindata,"^",22)
	.s:LastUpdateDate'="" LastUpdateDate=$zd(LastUpdateDate,3)
	.s LastUpdateTime=$p(maindata,"^",23)
	.s:LastUpdateTime'="" LastUpdateTime=$zt(LastUpdateTime,1)
	.s DownDate=$p(maindata,"^",24)
	.s:DownDate'="" DownDate=$zd(DownDate,3)
	.s DownTime=$p(maindata,"^",25)
	.s:DownTime'="" DownTime=$zt(DownTime,1)
	.s DownUserDr=$p(maindata,"^",26)
	.s DailPurchasePrice=$p(maindata,"^",28)
	.s PurchaseIDentification=$p(maindata,"^",29)
	.s bargainStatus=$p(maindata,"^",38)
	.s contractStatus=$p(maindata,"^",39)
	.s Pack=$p(maindata,"^",45)
	.s ybCode=$p(maindata,"^",35)
	.s nineState=$p(maindata,"^",46)
	.s:PurchaseIDentification=0 PurchaseIDentification="禁用"
	.s:PurchaseIDentification=1 PurchaseIDentification="带量采购"
	.s DownUser=""
	.i DownUserDr'="" s DownUser=$p($g(^SSU("SSUSR",DownUserDr)),"^",2)
	.
	.s INCI=$o(^DHCItmPCRelation(0,"LOG",MPCId,""))
	.s InciCode=$s(INCI'="":$p(^INCI(INCI,1),"^",1),1:"")
	.;s InciInfo=..GetComparedData(SMListId)
	.;s INCI=$p(InciInfo,"^",1)
	.;s InciCode=$p(InciInfo,"^",2)
	.s SMListId=""
	.s SubCodeId=""
	.s packOutlookc=$p(maindata,"^",44)
	.s OutLookc=$p(maindata,"^",8)
	.s GoodsType=""
	.q:(Spec'="")&&(OutLookc'[Spec)
	.s OutLookc=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(OutLookc,"'","\'")
	.s OutLookc=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(OutLookc,"\","\\")
	.s GoodsType=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(GoodsType,"'","\'")
	.s GoodsType=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(GoodsType,"\","\\")
	.s packOutlookc=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(packOutlookc,"'","\'")
	.s packOutlookc=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(packOutlookc,"\","\\")
	.s MinUnitMeasure=""
	.s MinUnitSale=""
	.s MinUnitPackage=""
	.s MinUnitPrice=""
	.s Data1=MPCId_"^"_DHCMPCHospId_"^"_GoodsId_"^"_SortName_"^"_ProductNameFirst
	.s Data2=ProductNameSecond_"^"_ProductNameThree_"^"_GoodsName_"^"_Unit_"^"_RegCodeName
	.s Data3=Brand_"^"_Source_"^"_PurchasePrice_"^"_CompanyIdTb_"^"_CompanyNameTb
	.s Data4=CompanyIdPs_"^"_CompanyNamePs_"^"_PurchaseType_"^"_DailPurchasePrice_"^"_PurchaseIDentification
	.s Data5=AddDate_"^"_AddTime_"^"_LastUpdateDate_"^"_LastUpdateTime_"^"_DownDate
	.s Data6=DownTime_"^"_DownUser_"^"_INCI_"^"_InciCode_"^"_SMListId
	.s Data7=SubCodeId_"^"_OutLookc_"^"_GoodsType_"^"_MinUnitMeasure_"^"_MinUnitSale
	.s Data8=MinUnitPackage_"^"_MinUnitPrice_"^"_bargainStatus_"^"_contractStatus_"^"_Pack
	.s Data9=regCerno_"^"_regcode_"^"_packOutlookc_"^"_procurecatalogId_"^"_ybCode
	.s Data10=RegEndDate_"^"_nineState_"^"_productName
	.s DataStr=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6_"^"_Data7_"^"_Data8_"^"_Data9_"^"_Data10
	.s Num=Num+1
    .q:Num<=Start
    .q:Num>End
    .d json.InsertRowData(DataStr)
    s Title1="MPCId^DHCMPCHospId^GoodsId^SortName^ProductNameFirst"
    s Title2="ProductNameSecond^ProductNameThree^GoodsName^Unit^RegCodeName"
    s Title3="Brand^Source^PurchasePrice^CompanyIdTb^CompanyNameTb"
    s Title4="CompanyIdPs^CompanyNamePs^PurchaseType^DailPurchasePrice^PurchaseIDentification"
    s Title5="AddDate^AddTime^LastUpdateDate^LastUpdateTime^DownDate"
    s Title6="DownTime^DownUser^INCI^InciCode^SMListId"
    s Title7="SubCodeId^OutLookc^GoodsType^MinUnitMeasure^MinUnitSale"
    s Title8="MinUnitPackage^MinUnitPrice^bargainStatus^contractStatus^Pack"
    s Title9="regCerno^regcode^packOutlookc^procurecatalogId^ybCode"
    s Title10="RegEndDate^nineState^productName"
    s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4_"^"_Title5_"^"_Title6_"^"_Title7_"^"_Title8_"^"_Title9_"^"_Title10
    i ..#Version="Ext"  d
	.s JsonStr=json.getJsonData(Title,Num)
	e  d
	.s JsonStr=""
	.d json.getJsonData(Title,Num)
	k json 
	q JsonStr
}

/*ClassMethod JSQueryMatPurCatalogNew(page As %String, rows As %String, Params As %String = "")
{
	s Start=(page-1)*rows
	s Limit=rows
	s End=Start+Limit
	s PurSubCode=$p(Params,"^",1)
	s PurCode=$p(Params,"^",2)
	s PurName=$p(Params,"^",3)
	s Spec=$p(Params,"^",4)
	s PurCodeLength=$L(PurCode)
	s Num=0
	s json =##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s MPCId=0
	f  s MPCId=$o(^DHCMatPurCataLog(MPCId)) q:+MPCId=0  d
	.s maindata=$g(^DHCMatPurCataLog(MPCId))
	.q:maindata=""
	.s DHCMPCHospId=$p(maindata,"^",1)
	.s GoodsId=$p(maindata,"^",3)
	.s procurecatalogId=$p(maindata,"^",43)
	.q:(PurCode'="")&&(GoodsId'[PurCode)
	.s SortName=$p(maindata,"^",4)
	.s ProductNameFirst=$p(maindata,"^",5)
	.s ProductNameSecond=$p(maindata,"^",6)
	.s ProductNameThree=$p(maindata,"^",30)
	.s GoodsName=$p(maindata,"^",7)
	.s productName=$p(maindata,"^",31)  ;通用名
	.q:(PurName'="")&&(productName'[PurName)
	.s GoodsName=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(GoodsName,"'","\'")
    .s GoodsName=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(GoodsName,"\","\\")
	.;if $Find(GoodsName,"'") s GoodsName=$tr(GoodsName,"''")
	.s Unit=$p(maindata,"^",10)
	.s RegCodeName=$p(maindata,"^",11)
	.s regCerno=$p(maindata,"^",40) 
	.s regcode=$p(maindata,"^",41)
	.s RegEndDate=$p(maindata,"^",42)
	.s:RegEndDate'="" RegEndDate=$zd(RegEndDate,3)
	.s Brand=$p(maindata,"^",12)
	.s Source=$p(maindata,"^",13)
	.s PurchasePrice=$p(maindata,"^",14)
	.s CompanyIdTb=$p(maindata,"^",15)
	.s CompanyNameTb=$p(maindata,"^",16)
	.s CompanyIdPs=$p(maindata,"^",17)
	.s CompanyNamePs=$p(maindata,"^",18)
	.s PurchaseType=$p(maindata,"^",19)
	.s AddDate=$p(maindata,"^",20)
	.s:AddDate'="" AddDate=$zd(AddDate,3)
	.s AddTime=$p(maindata,"^",21)
	.s:AddTime'="" AddTime=$zt(AddTime,1)
	.s LastUpdateDate=$p(maindata,"^",22)
	.s:LastUpdateDate'="" LastUpdateDate=$zd(LastUpdateDate,3)
	.s LastUpdateTime=$p(maindata,"^",23)
	.s:LastUpdateTime'="" LastUpdateTime=$zt(LastUpdateTime,1)
	.s DownDate=$p(maindata,"^",24)
	.s:DownDate'="" DownDate=$zd(DownDate,3)
	.s DownTime=$p(maindata,"^",25)
	.s:DownTime'="" DownTime=$zt(DownTime,1)
	.s DownUserDr=$p(maindata,"^",26)
	.s DailPurchasePrice=$p(maindata,"^",28)
	.s PurchaseIDentification=$p(maindata,"^",29)
	.s bargainStatus=$p(maindata,"^",38)
	.s contractStatus=$p(maindata,"^",39)
	.s Pack=$p(maindata,"^",45)
	.s ybCode=$p(maindata,"^",35)
	.s nineState=$p(maindata,"^",46)
	.s:PurchaseIDentification=0 PurchaseIDentification="禁用"
	.s:PurchaseIDentification=1 PurchaseIDentification="带量采购"
	.s DownUser=""
	.i DownUserDr'="" s DownUser=$p($g(^SSU("SSUSR",DownUserDr)),"^",2)
	.
	.s INCI=$o(^DHCItmPCRelation(0,"LOG",MPCId,""))
	.s InciCode=$s(INCI'="":$p(^INCI(INCI,1),"^",1),1:"")
	.;s InciInfo=..GetComparedData(SMListId)
	.;s INCI=$p(InciInfo,"^",1)
	.;s InciCode=$p(InciInfo,"^",2)
	.s SMListId=""
	.s SubCodeId=""
	.s packOutlookc=$p(maindata,"^",44)
	.s OutLookc=$p(maindata,"^",8)
	.s GoodsType=""
	.q:(Spec'="")&&(OutLookc'[Spec)
	.s OutLookc=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(OutLookc,"'","\'")
	.s OutLookc=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(OutLookc,"\","\\")
	.s GoodsType=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(GoodsType,"'","\'")
	.s GoodsType=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(GoodsType,"\","\\")
	.s packOutlookc=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(packOutlookc,"'","\'")
	.s packOutlookc=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(packOutlookc,"\","\\")
	.s MinUnitMeasure=""
	.s MinUnitSale=""
	.s MinUnitPackage=""
	.s MinUnitPrice=""
	.s Data1=MPCId_"^"_DHCMPCHospId_"^"_GoodsId_"^"_SortName_"^"_ProductNameFirst
	.s Data2=ProductNameSecond_"^"_ProductNameThree_"^"_GoodsName_"^"_Unit_"^"_RegCodeName
	.s Data3=Brand_"^"_Source_"^"_PurchasePrice_"^"_CompanyIdTb_"^"_CompanyNameTb
	.s Data4=CompanyIdPs_"^"_CompanyNamePs_"^"_PurchaseType_"^"_DailPurchasePrice_"^"_PurchaseIDentification
	.s Data5=AddDate_"^"_AddTime_"^"_LastUpdateDate_"^"_LastUpdateTime_"^"_DownDate
	.s Data6=DownTime_"^"_DownUser_"^"_INCI_"^"_InciCode_"^"_SMListId
	.s Data7=SubCodeId_"^"_OutLookc_"^"_GoodsType_"^"_MinUnitMeasure_"^"_MinUnitSale
	.s Data8=MinUnitPackage_"^"_MinUnitPrice_"^"_bargainStatus_"^"_contractStatus_"^"_Pack
	.s Data9=regCerno_"^"_regcode_"^"_packOutlookc_"^"_procurecatalogId_"^"_ybCode
	.s Data10=RegEndDate_"^"_nineState_"^"_productName
	.s DataStr=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6_"^"_Data7_"^"_Data8_"^"_Data9_"^"_Data10
	.s Num=Num+1
    .q:Num<=Start
    .q:Num>End
    .d json.InsertRowData(DataStr)
    s Title1="MPCId^DHCMPCHospId^GoodsId^SortName^ProductNameFirst"
    s Title2="ProductNameSecond^ProductNameThree^GoodsName^Unit^RegCodeName"
    s Title3="Brand^Source^PurchasePrice^CompanyIdTb^CompanyNameTb"
    s Title4="CompanyIdPs^CompanyNamePs^PurchaseType^DailPurchasePrice^PurchaseIDentification"
    s Title5="AddDate^AddTime^LastUpdateDate^LastUpdateTime^DownDate"
    s Title6="DownTime^DownUser^INCI^InciCode^SMListId"
    s Title7="SubCodeId^OutLookc^GoodsType^MinUnitMeasure^MinUnitSale"
    s Title8="MinUnitPackage^MinUnitPrice^bargainStatus^contractStatus^Pack"
    s Title9="regCerno^regcode^packOutlookc^procurecatalogId^ybCode"
    s Title10="RegEndDate^nineState^productName"
    s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4_"^"_Title5_"^"_Title6_"^"_Title7_"^"_Title8_"^"_Title9_"^"_Title10
    d json.getJsonData(Title,Num)
    k json
    q ""
}
*/
/// 对照判断标识
/// 1：inci有对照记录
/// 0：inci无对照记录
/// -1：参数异常
ClassMethod UpDateInciLogFlag(Inci)
{
	q:(+Inci=0) "-1^库存项ID不能为空！"
	s Flag=0
	s PurItmRelDr=$o(^DHCItmPCRelation(0,"INCI",Inci,0))
	if PurItmRelDr'="" s Flag=1
	q Flag
}

/*
/// Description：保存HIS库存项信息和采购平台规格型号对照信息  未使用
/// Input:Inci-His库存项ID,SMLId-采购平台规格型号表ID,UpFlag-对照标志(1为对照/0为取消对照)
/// Table：DHC_SpecModelList
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).SaveRelaInfo(28088,"1181||2",0)
ClassMethod SaveRelaInfo(Inci As %String, SMLId As %String, UpFlag As %String)
{
	s RtnObj=""
	i (..#Version="HisUI") s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	q:Inci="" RtnObj.Err(-1,"","库存项ID不能为空","",0)
	q:SMLId="" RtnObj.Err(-1,"","规格型号子表ID不能为空","",0)
	s Matrowid=+SMLId
	s SMLCh=$p(Matrowid,"||",2)
	s RetVal=0,RetMsg=""
	s InciCode=$p(^INCI(Inci,1),"^",1)
	if (UpFlag=1){
		//关联
		s PurItmRelId=$o(^DHCItmPCRelation(0,"INCI",Inci,0))
		i PurItmRelId'="" d
		.s RetVal="-3"
		.s RetMsg="保存失败!该库存项已做对照,请先取消原对照关系再更新"
		q:PurItmRelId'="" RtnObj.Err(RetVal,"",RetMsg,"",0)
		;q "-3^该库存项已做对照,请先取消原对照关系再更新" modify by free 20220121
		&sql(insert into SQLUser.DHC_ItmPurCataRelations(ItmPCR_INCI_DR,ItmPCR_PurCata_DR,ItmPCR_SML_DR) values (:Inci,:Matrowid,:SMLId) )
	}else{
		//取消关联
		&sql(delete from SQLUser.DHC_ItmPurCataRelations where ItmPCR_INCI_DR=:Inci)
	}
	i SQLCODE'=0 d
	.s RetVal=SQLCODE
	.s RetMsg="保存失败!"_$g(%msg)
	q RtnObj.Err(RetVal,"",RetMsg,"",0)
}*/
/// Description：保存HIS库存项信息和采购平台目录对照 lihui 20221117
/// Input:Inci-His库存项ID,Matrowid-采购平台目录表ID,UpFlag-对照标志(1为对照/0为取消对照)
/// Table：User.DHCItmPurCataRelations User.DHCMatPurCatalog
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).SaveRelaInfoSC(28088,"1181",0)
ClassMethod SaveRelaInfoSC(Inci As %String, Matrowid As %String, UpFlag As %String)
{
	s RtnObj=""
	i (..#Version="HisUI") s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	i (..#Version="HisUI")&&(Inci="")  d RtnObj.Err(-1,"","库存项ID不能为空","",0) q RtnObj.Json()
	i (..#Version="Ext")&&(Inci="") q "-1^库存项ID不能为空"
	i (..#Version="HisUI")&&(Matrowid="")  d RtnObj.Err(-1,"","目录表ID不能为空","",0) q RtnObj.Json()
	i (..#Version="Ext")&&(Matrowid="") q "-1^目录表ID不能为空" 

	s RetVal=0,RetMsg=""
	s InciCode=$p(^INCI(Inci,1),"^",1)
	if (UpFlag=1){
		//关联
		s PurItmRelId=$o(^DHCItmPCRelation(0,"INCI",Inci,0))
		s tmpIncid=$o(^DHCItmPCRelation(0,"LOG",Matrowid,""))
		i (PurItmRelId'="")||(tmpIncid'="") d
		.s RetVal="-3"
		.s RetMsg="保存失败!该库存项已做对照或者该平台编码已被对照,请先取消原对照关系再更新"
		i (..#Version="HisUI")&&(PurItmRelId'="")  d RtnObj.Err(RetVal,"",RetMsg,"",0) q RtnObj.Json()
		i (..#Version="Ext")&&(PurItmRelId'="") q RetVal_"^"_RetMsg 
		&sql(insert into SQLUser.DHC_ItmPurCataRelations(ItmPCR_INCI_DR,ItmPCR_PurCata_DR) values (:Inci,:Matrowid) )
	}else{
		//取消关联
		&sql(delete from SQLUser.DHC_ItmPurCataRelations where ItmPCR_INCI_DR=:Inci)
	}
	i SQLCODE'=0 d
	.s RetVal=SQLCODE
	.s RetMsg="保存失败!"_$g(%msg)
	i (..#Version="Ext") q RetVal_"^"_RetMsg 
	d RtnObj.Err(RetVal,"",RetMsg,"",0)
	q RtnObj.Json()
}

/// Description：界面显示采购平台订单明细数据 HC010 物资 SJ009 试剂
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryPoItmInfo(192,1)
ClassMethod JSQueryPoItmInfo(PoId, Page)
{
	s MRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetMRDocFlag(PoId,"PO")
	s RetInfo=""
	i MRDocFlag="Y"   {
		s RetInfo=..GetOrderDetail(PoId,Page,"SJ009")
	}else{
		s RetInfo=..GetOrderDetail(PoId,Page,"HC010")
	}
	s RtnObj=""
	i (..#Version="HisUI") s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s RetVal=$p(RetInfo,"^",1)
	s RetMsg=$p(RetInfo,"^",2)
	;i (..#Version="HisUI")&&(RetVal'=0)  d RtnObj.Err(-1,"",RetMsg,"",0) q RtnObj.Json()
	;i (..#Version="Ext")&&(RetVal'=0) q "-1^"_RetMsg
	s Ret=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(RetMsg,"",.JsonObj,.pCharsProcessed,"2","","0")
	;i (..#Version="HisUI")&&(Ret'="1")  d RtnObj.Err(-1,"","Json解析错误","",0) q RtnObj.Json()
	;i (..#Version="Ext")&&(Ret'="1") q "-1^Json解析错误"
	s returnCode=JsonObj.returnCode
	s returnMsg=JsonObj.returnMsg
	;i (..#Version="HisUI")&&(returnCode'="1")  d RtnObj.Err(-1,"",returnMsg,"",0) q RtnObj.Json()
	;i (..#Version="Ext")&&(returnCode'="1") q returnCode_"^"_returnMsg
	s dataList=JsonObj.dataList
	s currentPageNumber=JsonObj.currentPageNumber    ;当前页码
	s totalPageCount=JsonObj.totalPageCount			 ;总页码
	//q:totalPageCount'>0 returnCode_"^"_returnMsg
	s totalRecordCount=JsonObj.totalRecordCount		 ;总行数
	s Title="orderDetailState^subDate^subTime^orderId^orderRemark^orderDetailID^refuseReason^totalPageCount^totalRecordCount^orderName^confirmDate^confirmTime"
	s Count=dataList.Count()
	;i (..#Version="HisUI")&&(Count'>0)  d RtnObj.Err(-1,"",returnMsg,"",0)  q RtnObj.Json()
	;i (..#Version="Ext")&&(Count'>0) q "-1^"_returnMsg
	s json=..GetJsonObj()
	f i=1:1:Count {
		s getdatalist=dataList.GetAt(i)
		s orderDetailState=getdatalist.orderDetailState   ;当前状态
		s orderDetailState=..GetOrderDetailStateDesc(orderDetailState)
		s submitTime=getdatalist.submitTime    ;订单提交时间
		s subDate=$p(submitTime," ",1)
		s subTime=$p(submitTime," ",2)
		s orderId=getdatalist.orderId	;订单编号
		s orderName=getdatalist.orderName	 ; 订单名称
		s orderRemark=getdatalist.orderRemark	;订单备注
		s orderDetailID=getdatalist.orderDetailId		;订单明细编号
		s refuseReason=getdatalist.refuseReason		;拒绝理由
		s confirmTime=getdatalist.confirmTime    ; 响应时间
		s confirmDate=$p(confirmTime," ",1)
		s confirmTime=$p(confirmTime," ",2)
		&sql(SELECT * FROM DHCOrdState WHERE orderDetailId=:orderDetailID)
		i SQLCODE  d
		.&sql(INSERT INTO DHCOrdState  (orderDetailId, orderDetailState, orderId, orderRemark, refuseReason, submitTime,orderName,confirmTime) 
		      VALUES(:orderDetailID,:orderDetailState,:orderId,:orderRemark,:refuseReason,:submitTime,:orderName,:confirmTime))
		e  d
		.&sql(UPDATE DHCOrdState SET orderDetailState=:orderDetailState,orderRemark=:orderRemark,refuseReason=:refuseReason,submitTime=:submitTime,orderName=:orderName,confirmTime=:confirmTime where  orderDetailId=:orderDetailID)
		s Data=orderDetailState_"^"_subDate_"^"_subTime_"^"_orderId_"^"_orderRemark_"^"_orderDetailID_"^"_refuseReason_"^"_totalPageCount_"^"_totalRecordCount_"^"_orderName_"^"_confirmDate_"^"_confirmTime
		d json.InsertRowData(Data)
	}
	i ..#Version="Ext"  d
	.s JsonStr=json.getJsonData(Title,totalRecordCount)
	e  d
	.s JsonStr=""
	.d json.getJsonData(Title,totalRecordCount)
	k json 
	q JsonStr
}

/// Description：界面显示已配送状态订单信息 HC011 物资，SJ010 试剂
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryPoItmDispatching(3,1)
ClassMethod JSQueryPoItmDispatching(PoId, Page)
{
	s RtnObj=""
	i (..#Version="HisUI") s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s MRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetMRDocFlag(PoId,"PO")
	s RetInfo=""
	i MRDocFlag="Y"   {
		s RetInfo=..GetDistribution(PoId,Page,"SJ010")
	}else{
		s RetInfo=..GetDistribution(PoId,Page,"HC011")
	}
	s RetVal=$p(RetInfo,"^",1)
	s RetMsg=$p(RetInfo,"^",2)
	;i (..#Version="HisUI")&&(RetVal'=0)  d RtnObj.Err(-1,"",RetMsg,"",0) q RtnObj.Json()
	;i (..#Version="Ext")&&(RetVal'=0) q "-1^"_RetMsg
	s Ret=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(RetMsg,"",.JsonObj,.pCharsProcessed,"2","","0")
	;i (..#Version="HisUI")&&(Ret'="1")  d RtnObj.Err(-1,"","Json解析错误","",0) q RtnObj.Json()
	;i (..#Version="Ext")&&(Ret'="1") q "-1^Json解析错误"
	s returnCode=JsonObj.returnCode
	s returnMsg=JsonObj.returnMsg
	;i (..#Version="HisUI")&&(returnCode'="1")  d RtnObj.Err(-1,"",returnMsg,"",0) q RtnObj.Json()
	;i (..#Version="Ext")&&(returnCode'="1") q returnCode_"^"_returnMsg
	s dataList=JsonObj.dataList
	
	s currentPageNumber=JsonObj.currentPageNumber    ;当前页码
	s totalPageCount=JsonObj.totalPageCount			 ;总页码
	s totalRecordCount=JsonObj.totalRecordCount		 ;总行数
	s Title="orderDetailID^distributionSerialID^invoiceID^batchRecordID^distributeCount^distriDate^distriTime^warehouseCount^IngdrecDate^IngdrecTime^Inci^InciCode^InciDesc^totalPageCount^totalRecordCount^highflag^hospitalId^purchasePrice^invoiceCode^periodDate^distributeCustomInfo^detailDistributeAddress^invoicePrimaryIds^goodsId^outLookc^model^companyIdTb^companyNameTb^companyIdPs^companyNamePs"
	s Count=dataList.Count()
	;i (..#Version="HisUI")&&(Count'>0)  d RtnObj.Err(-1,"",returnMsg,"",0)  q RtnObj.Json()
	;i (..#Version="Ext")&&(Count'>0) q "-1^"_returnMsg
	s json=..GetJsonObj()
	f i=1:1:Count {
		s getdatalist=dataList.GetAt(i)
		s hospitalId=getdatalist.hospitalId ; 医院编号
		s procurecatalogId =getdatalist.procurecatalogId 		;产品id
		s companyIdPs=getdatalist.companyIdPs		;配送企业id
		s orderDetailID=getdatalist.orderDetailId		;订单明细编号
		s distributionSerialID=getdatalist.distributeId   ;配送明细编号
		s purchasePrice=getdatalist.purchasePrice ;采购价格
		s invoiceID=getdatalist.invoiceId				;发票号
		s invoiceCode=getdatalist.invoiceCode ;发票代码
		s batchRecordID=getdatalist.batchCode     ;批号
		s periodDate=getdatalist.periodDate ;有效期
		s periodDate=$s(periodDate'="":$zd($zdh(periodDate,8),3),1:"")
		s distributeCount=getdatalist.distributeCount	;配送数量
		s distributeTime=getdatalist.distributeTime	;配送时间
		s distriDate=$p(distributeTime," ",1)
		s distriTime=$p(distributeTime," ",2)
		s warehouseCount=getdatalist.warehouseCount	;入库数量
		s warehouseTime=getdatalist.warehouseTime		;入库时间
		s IngdrecDate=$p(warehouseTime," ",1)
		s IngdrecTime=$p(warehouseTime," ",2)
		s distributeCustomInfo=getdatalist.distributeCustomInfo ;自定义配送信息
		s detailDistributeAddress=getdatalist.detailDistributeAddress ;配送地址
		s invoicePrimaryIds=getdatalist.invoicePrimaryIds ;多个发票id
		s invoiceValidState=getdatalist.invoiceValidState ;发票验证状态(0:待验证,1:可能符合，2:验证不通过)
		s invoiceValidRemark=getdatalist.invoiceValidRemark ;发票验证备注信息
		s invoicePrimaryIds=getdatalist.invoicePrimaryIds ;多个发票id
		s goodsId=getdatalist.goodsId ;产品id
		s outLookc=getdatalist.outLookc ;规格  
		s model=getdatalist.model ;型号
		s companyIdTb=getdatalist.companyIdTb ;投标企业ID
		s companyNameTb=getdatalist.companyNameTb ;投标企业名称
		s companyIdPs=getdatalist.companyIdPs ;配送企业ID
		s companyNamePs=getdatalist.companyNamePs ;配送企业名称
		&sql(SELECT * FROM DHCCarrState WHERE orderDetailId=:orderDetailID and distributeId=:distributionSerialID)
		i SQLCODE d
		.&sql(INSERT INTO DHCCarrState (batchCode, detailDistributeAddress, distributeCount, distributeCustomInfo, distributeId, distributeTime, hospitalId, invoiceCode, invoiceId, orderDetailId,
					 periodDate, purchasePrice, warehouseCount, warehouseTime,invoicePrimaryIds,goodsId,outLookc,model,companyIdTb,companyNameTb,
					 companyIdPs,companyNamePs) 
       		VALUES(:batchRecordID,:detailDistributeAddress,:distributeCount,:distributeCustomInfo,:distributionSerialID,:distributeTime,:hospitalId,:invoiceCode,:invoiceID,:orderDetailID,
       		       :periodDate,:purchasePrice,:warehouseCount,:warehouseTime,:invoicePrimaryIds,:goodsId,:outLookc,:model,:companyIdTb,:companyNameTb,
				   :companyIdPs,:companyNamePs))
        e  d
        .&sql(UPDATE DHCCarrState SET batchCode=:batchRecordID,detailDistributeAddress=:detailDistributeAddress,distributeCount=:distributeCount,distributeCustomInfo=:distributeCustomInfo,distributeTime=:distributeTime,hospitalId=:hospitalId,invoiceCode=:invoiceCode,invoiceId=:invoiceID,
               periodDate=:periodDate,purchasePrice=:purchasePrice,warehouseCount=:warehouseCount,warehouseTime=:warehouseTime,goodsId=:goodsId,outLookc=:outLookc,model=:model,companyIdTb=:companyIdTb,companyNameTb=:companyNameTb,
				   companyIdPs=:companyIdPs,companyNamePs=:companyNamePs WHERE orderDetailId=:orderDetailID and distributeId=:distributionSerialID)
		s (Inci,InciCode,InciDesc)="",highflag="N"
		&sql(SELECT INPOI_INCI_DR INTO :Inci FROM  SQLUser.IN_POItm WHERE IN_PO=:PoId AND INPOI_ThirdOrderDetailId=:orderDetailID)		
		i 'SQLCODE
		{
			s InciCode=$P(^INCI(Inci,1),"^",1)
			s InciDesc=$P(^INCI(Inci,1),"^",2)
			s highflag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
			i highflag="Y" d
			.s BUomId=$p(^INCI(Inci,1),"^",10)	//基本单位
			.s PUomid=$p(^INCI(Inci,3),"^",6)	// 入库单位
			.s PuomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomid,BUomId)
			.s distributeCount=distributeCount*PuomFac	//基本单位配送数量
			.s warehouseCount=warehouseCount*PuomFac	//基本单位入库数量
		}
		s Data1=orderDetailID_"^"_distributionSerialID_"^"_invoiceID_"^"_batchRecordID_"^"_distributeCount_"^"_distriDate_"^"_distriTime_"^"_warehouseCount_"^"_IngdrecDate_"^"_IngdrecTime
		s Data2=Inci_"^"_InciCode_"^"_InciDesc_"^"_totalPageCount_"^"_totalRecordCount_"^"_highflag_"^"_hospitalId_"^"_purchasePrice_"^"_invoiceCode_"^"_periodDate
		s Data3=distributeCustomInfo_"^"_detailDistributeAddress_"^"_invoicePrimaryIds_"^"_goodsId_"^"_outLookc
		s Data4=model_"^"_companyIdTb_"^"_companyNameTb_"^"_companyIdPs_"^"_companyNamePs
		s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
		d json.InsertRowData(Data)
	}
	i ..#Version="Ext"  d
	.s JsonStr=json.getJsonData(Title,totalRecordCount)
	e  d
	.s JsonStr=""
	.d json.getJsonData(Title,totalRecordCount)
	k json 
	q JsonStr
}

/// 2021-1-3
/// Up: lihui 20221117 试剂 SJ013 物资 HC014
/// Description：界面显示已经上传的退货申请
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryRetInfo(1051,1)
ClassMethod JSQueryRetInfoAll(IngdRet As %String = "", Page As %String = 1)
{
	s RtnObj=""
	i (..#Version="HisUI") s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s MRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetMRDocFlag(IngdRet,"R")
	s InterTypeCoce="HC014"
	i MRDocFlag="Y"   {
		s InterTypeCoce="SJ013"
	}
	s RetInfo=..GetReturnInfo(IngdRet,Page,InterTypeCoce)
	s RetVal=$p(RetInfo,"^",1)
	s RetMsg=$p(RetInfo,"^",2)
	;i (..#Version="HisUI")&&(RetVal'=0)  d RtnObj.Err(-1,"",RetMsg,"",0) q RtnObj.Json()
	;i (..#Version="Ext")&&(RetVal'=0) q RetVal_"^"_RetMsg
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(RetMsg,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s returnCode=ReturnJsonObj.returnCode
	s returnMsg=ReturnJsonObj.returnMsg
	;i (..#Version="HisUI")&&(returnCode'="1")  d RtnObj.Err(-1,"",returnMsg,"",0) q RtnObj.Json()
	;i (..#Version="Ext")&&(returnCode'="1") q returnCode_"^"_returnMsg
	s totalPageCount=ReturnJsonObj.totalPageCount ;总页码
	i (..#Version="HisUI")&&(totalPageCount'>0)  d RtnObj.Err(-1,"",returnMsg,"",0) q RtnObj.Json()
	i (..#Version="Ext")&&(totalPageCount'>0) q returnCode_"^"_returnMsg
	s dataList=ReturnJsonObj.dataList
	;i (..#Version="HisUI")&&('$ISOBJECT(dataList))  d RtnObj.Err(-1,"","没有查询到结果信息","",0) q RtnObj.Json()
	;i (..#Version="Ext")&&('$ISOBJECT(dataList)) q returnCode_"^没有查询到结果信息"
	s CurrentPageNumber=ReturnJsonObj.currentPageNumber	;当前页码
	s TotalRecordCount=ReturnJsonObj.totalRecordCount		;总行数
	s Title="returnID^distributionSerialID^returnType^returnResponseTime^isResponse^refuseReason^returnInvoiceId^returnMaintenanceInvoiceTime^distributeTime"
	s Count=dataList.Count()
	s json=..GetJsonObj()
	f i=1:1:Count {
		s getdatalist=dataList.GetAt(i)
		s returnID=getdatalist.returnId		;退货明细编号
		s distributionSerialID=getdatalist.distributeId	;配送明细编号
		s returnType=getdatalist.returnType	;退货类型 
		s returnType=$s(returnType="0":"现场退货",returnType="1":"入库后退",1:returnType)
		s returnResponseTime=getdatalist.returnResponseTime		;退货响应时间
		s distributeTime=getdatalist.distributeTime  ;配送时间
		s isResponse=getdatalist.isResponse	;是否响应	 			
		s isResponse=..GetisResponseDesc(isResponse)
		s refuseReason=getdatalist.refuseReason		;拒绝原因
		s returnInvoiceId=getdatalist.returnInvoiceId	;发票号
		s returnMaintenanceInvoiceTime=getdatalist.returnMaintenanceInvoiceTime	;维护发票时间
		&sql(SELECT * FROM DHCRetState WHERE returnID=:returnID)
		i SQLCODE  d
		.&sql(INSERT INTO DHCRetState (distributionSerialID, isResponse, refuseReason, returnID, returnInvoiceId, returnMaintenanceInvoiceTime, returnResponseTime, returnType)
 			VALUES(:distributionSerialID,:isResponse,:refuseReason,:returnID,:returnInvoiceId,:returnMaintenanceInvoiceTime,:returnResponseTime,:returnType))
		e  d
		.&sql(UPDATE DHCRetState SET distributionSerialID=:distributionSerialID,isResponse=:isResponse,refuseReason=:refuseReason,returnInvoiceId=:returnInvoiceId,returnMaintenanceInvoiceTime=:returnMaintenanceInvoiceTime,returnResponseTime=:returnResponseTime,returnType=:returnType WHERE returnID=:returnID)
				 
		s Data1=returnID_"^"_distributionSerialID_"^"_returnType_"^"_returnResponseTime_"^"_isResponse
		s Data2=refuseReason_"^"_returnInvoiceId_"^"_returnMaintenanceInvoiceTime_"^"_distributeTime
		s Data=Data1_"^"_Data2
		d json.InsertRowData(Data)
	}
	f cPage=2:1:totalPageCount {
		s RetInfo2=..GetReturnInfo(IngdRet,Page,InterTypeCoce)
		s RetVal2=$p(RetInfo,"^",1)
		s RetMsg2=$p(RetInfo,"^",2)
		continue:RetVal2'=0
		s newParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(RetMsg2,"",.newReturnJsonObj,.pCharsProcessed,"2","","0")
		s newReturnCode=newReturnJsonObj.returnCode
		continue:newReturnCode'=1
		s newReturnMsg=newReturnJsonObj.returnMsg
		s newTotalPageCount=newReturnJsonObj.totalPageCount ;总页码
		continue:newTotalPageCount'>0
		s newdataList=newReturnJsonObj.successList
		continue:'$ISOBJECT(newdataList)
		s newCurrentPageNumber=newReturnJsonObj.currentPageNumber	;当前页码
		s newTotalRecordCount=newReturnJsonObj.totalRecordCount		;总行数
		s newCount=newdataList.Count()
		f j=1:1:newCount {
			s getdatalist2=newdataList.GetAt(j)
			s newReturnID=getdatalist2.returnId		;退货明细编号
			s newDistributionSerialID=getdatalist2.distributionSerialID	;配送明细编号
			s newReturnType=getdatalist2.returnType	;退货类型 
			s newReturnType=$s(newReturnType="0":"现场退货",newReturnType="1":"入库后退",1:newReturnType)
			s newReturnResponseTime=getdatalist2.returnResponseTime		;退货响应时间
			s newdistributeTime=getdatalist.distributeTime  ;配送时间
			s newIsResponse=getdatalist2.isResponse	;是否响应	 			
			s newIsResponse=..GetisResponseDesc(newIsResponse)
			s newRefuseReason=getdatalist2.refuseReason		;拒绝原因
			s newReturnInvoiceId=getdatalist2.returnInvoiceId	;发票号
			s newReturnMaintenanceInvoiceTime=getdatalist2.returnMaintenanceInvoiceTime	;维护发票时间		 
			&sql(SELECT * FROM DHCRetState WHERE returnID=:returnID)
			i SQLCODE  d
			.&sql(INSERT INTO DHCRetState (distributionSerialID, isResponse, refuseReason, returnID, returnInvoiceId, returnMaintenanceInvoiceTime, returnResponseTime, returnType)
	 			VALUES(:newDistributionSerialID,:newIsResponse,:newRefuseReason,:newReturnID,:newReturnInvoiceId,:newReturnMaintenanceInvoiceTime,:newReturnResponseTime,:newReturnType))
			e  d
			.&sql(UPDATE DHCRetState SET distributionSerialID=:newDistributionSerialID,isResponse=:newIsResponse,refuseReason=:newRefuseReason,returnInvoiceId=:newReturnInvoiceId,returnMaintenanceInvoiceTime=:newReturnMaintenanceInvoiceTime,returnResponseTime=:newReturnResponseTime,returnType=:newReturnType WHERE returnID=:newReturnID)
		
			s newData1=newReturnID_"^"_newDistributionSerialID_"^"_newReturnType_"^"_newReturnResponseTime_"^"_newIsResponse
			s newData2=newRefuseReason_"^"_newReturnInvoiceId_"^"_newReturnMaintenanceInvoiceTime_"^"_newdistributeTime
			s newData=newData1_"^"_newData2
			d json.InsertRowData(newData)
		}
	}
	i ..#Version="Ext"  d
	.s JsonStr=json.getJsonData(Title,TotalRecordCount)
	e  d
	.s JsonStr=""
	.d json.getJsonData(Title,TotalRecordCount)
	k json 
	q JsonStr
}

/// Description：获取依据订单保存入库单所需要的主信息
ClassMethod GetPoInfoById(PoId)
{
	q:PoId="" ""
	s GloablData=$g(^INPO(PoId))
	q:GloablData="" ""
	s Vendor=$p(GloablData,"^",2)
	s PurUser=$p(GloablData,"^",7)
	s DhcPoId=$o(^DHCINPO(0,"INPO",PoId,0))
	s StkGrpId=$p(^DHCINPO(DhcPoId),"^",3)
	s PoLoc =$p(^DHCINPO(DhcPoId),"^",2)
	q PoId_"^"_Vendor_"^"_PurUser_"^"_StkGrpId_"^"_PoLoc
}

/// Description：根据采购平台订单明细ID获取依据订单保存入库单所需要的信息
/// Input:orderDetailId-采购平台订单明细ID
/// Other:厂商的取发遵循 订单 的参数配置
ClassMethod GetPoItmInfo(orderDetailId, PoId, HighFlag = "N")
{
	q:(orderDetailId="")||(PoId="") ""
	s PoItm=""
	&sql(SELECT IN_POItm INTO :PoItm FROM  SQLUser.IN_poItm WHERE IN_PO=:PoId and INPOI_ThirdOrderDetailId=:orderDetailId)
	q:PoItm="" ""
	s Inci=$p(^INPO(PoId,"POI",$p(PoItm,"||",2)),"^",1)
	s highflag=##class(web.DHCSTM.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	s:HighFlag="" HighFlag="N"
	q:HighFlag'=highflag ""
	s DhcPoId=$o(^DHCINPO(0,"INPO",PoId,0))
	s PoLoc =$p(^DHCINPO(DhcPoId),"^",2)
	s HospId=$p(^CTLOC(PoLoc),"^",22)
	s Param="^"_PoLoc_"^^"_HospId
	s ItmDefaultInfo=##class(web.DHCSTM.DHCINGdRec).GetItmInfo(Inci,Param)
	s ManfId=$p(ItmDefaultInfo,"^",1)
	s ExpDate=$p(ItmDefaultInfo,"^",8)
	//订单按基本单位数量上传，入库默认为基本单位入库
	s Rp=$p(ItmDefaultInfo,"^",5)
	s Sp=$p(ItmDefaultInfo,"^",6)
	s BUomId=$p(ItmDefaultInfo,"^",11)
	s ConFac=$p(ItmDefaultInfo,"^",12)
	s BRp=$s(+ConFac'=0:Rp/ConFac,1:Rp) //老版本GetItmInfo方法中无BRp、BSp字段,需在本方法中计算
	s BSp=$s(+ConFac'=0:Sp/ConFac,1:Sp)
	s BRp=##class(web.DHCSTM.Common.AppCommon).FormatRp(BRp,HospId,2)
	s BSp=##class(web.DHCSTM.Common.AppCommon).FormatSp(BSp,HospId,2)

	q PoItm_"^"_BUomId_"^"_BRp_"^"_BSp_"^"_ManfId_"^"_ExpDate
}

/// Description：根据采购平台订单明细ID获取依据订单保存入库单所需要的信息
/// Input:orderDetailId-采购平台订单明细ID
/// Other:厂商的取发遵循 订单 的参数配置
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetPoItmInfoHisUI("221128182009454345178242","2119","N")
ClassMethod GetPoItmInfoHisUI(orderDetailId, PoId, HighFlag = "N")
{
	s ^tmpli("orderDetailId")=orderDetailId
	q:(orderDetailId="")||(PoId="") ""
	s PoItm=""
	&sql(SELECT IN_POItm INTO :PoItm FROM  SQLUser.IN_poItm WHERE IN_PO=:PoId and INPOI_ThirdOrderDetailId=:orderDetailId)
	q:PoItm="" ""
	s Inci=$p(^INPO(PoId,"POI",$p(PoItm,"||",2)),"^",1)
	s highflag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	s:HighFlag="" HighFlag="N"
	q:HighFlag'=highflag ""
	s DhcPoId=$o(^DHCINPO(0,"INPO",PoId,0))
	s PoLoc =$p(^DHCINPO(DhcPoId),"^",2)
	s HospId=$p(^CTLOC(PoLoc),"^",22)
	s Data=PoLoc_"^"_HospId
	s Param=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,"gLocId^gHospId")
	s ItmDefaultInfo=##class(web.DHCSTMHUI.DHCINGdRec).GetItmInfo(Inci,Param)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(ItmDefaultInfo)
	s ManfId=PJObj.%Get("ManfId")
	s ExpDate=PJObj.%Get("ExpDate")
	//订单按基本单位数量上传，入库默认为基本单位入库
	s Rp=PJObj.%Get("Rp")
	s Sp=PJObj.%Get("Sp")
	s BUomId=PJObj.%Get("BUomId")
	s ConFac=PJObj.%Get("ConFac")
	s BRp=$s(+ConFac'=0:Rp/ConFac,1:Rp) //老版本GetItmInfo方法中无BRp、BSp字段,需在本方法中计算
	s BSp=$s(+ConFac'=0:Sp/ConFac,1:Sp)
	s BRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(BRp,HospId,2)
	s BSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(BSp,HospId,2)
	q PoItm_"^"_BUomId_"^"_BRp_"^"_BSp_"^"_ManfId_"^"_ExpDate
}

/// Descript:   更新配送信息到高值入库单
/// Creater:    lihui
/// CreateDate: 20221201
/// Table:DHC_InGdRecItm
/// Input: 配送明细信息
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSLinkInGdRec(ListData)
ClassMethod JSLinkInGdRec(ListData)
{
	s RtnObj=""
	i (..#Version="HisUI") s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
 	s PJObjItm=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObjItm.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","明细入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	While (RtnObj.success=0) {
		s ListDataObj=PJObjItm.%Pop()
		q:ListDataObj=""
		s orderDetailID=ListDataObj.%Get("orderDetailID") // 平台订单明细ID
		s IncId=ListDataObj.%Get("Inci")
		s OrderDetailSubId=ListDataObj.%Get("distributionSerialID")	//平台配送明细ID
		s InvNo=ListDataObj.%Get("invoiceID") ; 发票号
		s InvCode=ListDataObj.%Get("invoiceCode") ; 发票代码
		s ExpDate=ListDataObj.%Get("periodDate") ; 效期
		
		s BatNo=ListDataObj.%Get("batchRecordID") ; 批号
		s Qty=ListDataObj.%Get("distributeCount") ;配送数量
		s warehouseCount=ListDataObj.%Get("warehouseCount") ;已入库数量
		s IncDesc=$p(^INCI(IncId,1),"^",2)
		i (+Qty=0) d RtnObj.Err(-2,"",IncDesc_"配送数量为空!") q 
		s inpoitmid=""
		&sql(SELECT IN_POItm into:inpoitmid FROM IN_POItm WHERE INPOI_ThirdOrderDetailId=:orderDetailID)
		i SQLCODE d RtnObj.Err(-2,"",IncDesc_"没有对应HIS订单信息!") q
		
		s count=0
		s ingrid=""
		f  s ingrid=$o(^DHCINGR(0,"PODR",inpoitmid,ingrid)) q:(ingrid="")!(count=Qty)!(RtnObj.success'=0)  d
		.s chl=""
		.f  s chl=$o(^DHCINGR(0,"PODR",inpoitmid,ingrid,chl)) q:(chl="")!(count=Qty)!(RtnObj.success'=0)   d
		..q:'$d(^DHCINGR(ingrid,"GRI",chl))
		..s ingritminfo=^DHCINGR(ingrid,"GRI",chl)
		..s distributid=$p(ingritminfo,"^",64)
		..q:distributid'=""
		..s inciid=$p(ingritminfo,"^",25)
		..q:inciid'=IncId
		..s ingritmid=ingrid_"||"_chl
		..&sql(UPDATE DHC_INGdRecItm SET initm_OrderDetailSubId=:OrderDetailSubId WHERE INGRI_RowId=:ingritmid)
		..i SQLCODE d RtnObj.Err(-2,"",IncDesc_ingritmid_"关联入库明细失败!") q
		..s count=count+1
		
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:   更新配送信息到高值入库单 Ext
/// Creater:    lihui
/// CreateDate: 20221212
/// Table:DHC_InGdRecItm
/// Input: 配送明细信息
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSLinkInGdRecExt(ListData)
ClassMethod JSLinkInGdRecExt(ListData)
{
	q:ListData="" 0
	s rowDelim=##class(web.DHCSTM.Common.UtilCommon).RowDataDelim()
    s len=$l(ListData,rowDelim)
	s err="",ret=0
	ts
	f i=1:1:len q:ret'=0  d
    	.s data=$p(ListData,rowDelim,i)
    	.q:data=""
		.s orderDetailID=$p(data,"^",1) // 平台订单明细ID
		.s IncId=$p(data,"^",2)
		.s OrderDetailSubId=$p(data,"^",3) //平台配送明细ID
		.s InvNo=$p(data,"^",4) ; 发票号
		.s InvCode=$p(data,"^",5) ; 发票代码
		.s ExpDate=$p(data,"^",6) ; 效期
		.s BatNo=$p(data,"^",7) ; 批号
		.s Qty=$p(data,"^",8) ;配送数量
		.s warehouseCount=$p(data,"^",9) ;已入库数量
		.s IncDesc=$p(^INCI(IncId,1),"^",2)
		.i (+Qty=0) d RtnObj.Err(-2,"",IncDesc_"配送数量为空!") q 
		.s inpoitmid=""
		.&sql(SELECT IN_POItm into:inpoitmid FROM IN_POItm WHERE INPOI_ThirdOrderDetailId=:orderDetailID)
		.i SQLCODE s ret=-1,err=IncDesc_"没有对应HIS订单信息!" q
		.
		.s count=0
		.s ingrid=""
		.f  s ingrid=$o(^DHCINGR(0,"PODR",inpoitmid,ingrid)) q:(ingrid="")!(count=Qty)!(ret'=0)  d
		..s chl=""
		..f  s chl=$o(^DHCINGR(0,"PODR",inpoitmid,ingrid,chl)) q:(chl="")!(count=Qty)!(ret'=0)   d
		...q:'$d(^DHCINGR(ingrid,"GRI",chl))
		...s ingritminfo=^DHCINGR(ingrid,"GRI",chl)
		...s distributid=$p(ingritminfo,"^",64)
		...q:distributid'=""
		...s inciid=$p(ingritminfo,"^",25)
		...q:inciid'=IncId
		...s ingritmid=ingrid_"||"_chl
		...&sql(UPDATE DHC_INGdRecItm SET initm_OrderDetailSubId=:OrderDetailSubId WHERE INGRI_RowId=:ingritmid)
		...i SQLCODE s ret=-1,err=IncDesc_ingritmid_"关联入库明细失败!" q
		...s count=count+1
	i ret'=0 tro  q ret_"^"_err
	tc
	q ret
}

/// -------公共方法--------
/// 获取阳光采购使用的标志
ClassMethod GetYGCGFlag()
{
	;或扩展成其他方法
	q ..#UseYGCGFlag
}

/// 获取 产品编号、规格、型号、议价状态
/// Table: DHC_MatPurCatalog
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetSubCode(19897)
ClassMethod GetSubCode(Inci)
{
    s (MPCId,goodsID,subCodeId,SpecListId,outLook,goodsType,subCodeId)=""
    s PurItmRelId=$o(^DHCItmPCRelation(0,"INCI",Inci,0))
    q:+PurItmRelId'>0 ""
    s MPCId=$p(^DHCItmPCRelation(PurItmRelId),"^",2)
    q:(MPCId="")||('$d(^DHCMatPurCataLog(MPCId))) ""
    s MatPurCataLoginfo=^DHCMatPurCataLog(MPCId)
	s goodsID=$p(MatPurCataLoginfo,"^",3) ;产品编号
	s bargainStatus=$p(MatPurCataLoginfo,"^",38) ;议价状态
	s outLook=$p(MatPurCataLoginfo,"^",8) ; 规格
	s goodsType=$p(MatPurCataLoginfo,"^",9) ;型号
	q subCodeId_"^"_SpecListId_"^"_goodsID_"^"_outLook_"^"_goodsType_"^"_bargainStatus
}

/// 根据 参数Version 获取相应JsonObj
ClassMethod GetJsonObj()
{
	i ..#Version="Ext"  d
	.s JsonObj=##class(Code.JsonObj).%New()
	e  d
	.s JsonObj=##class(web.DHCSTMHUI.Common.JsonObj).%New()
	
	q JsonObj
}

/// Description：返回订单状态描述
ClassMethod GetOrderDetailStateDesc(orderDetailState)
{
	s ret=""
	s:orderDetailState=0 ret="已保存待提交"
	s:orderDetailState=1 ret="已提交待响应"
	s:orderDetailState=2 ret="已响应待配送"
	s:orderDetailState=3 ret="拒绝响应"
	s:orderDetailState=4 ret="已配送待收货"
	
	s:orderDetailState=5 ret="拒绝配送"
	s:orderDetailState=6 ret="未及时配送"
	s:orderDetailState=7 ret="收货中"
	s:orderDetailState=8 ret="已收货"
	s:orderDetailState=9 ret="已撤单"
	q:ret="" orderDetailState
	q ret
}

/// Description：根据退货单响应状态代码获取描述
ClassMethod GetisResponseDesc(Response)
{
	s ret=""
	s:Response=0 ret="已提交待确认"
	s:Response=1 ret="已确认待维护退货发票 "
	s:Response=2 ret="已确认且已维护退货发票"
	s:Response=3 ret="拒绝退货("
	q:ret="" Response
	q ret
}

ClassMethod SendData(FunctionCode, InputStream As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s ReturnJson=##class(%GlobalCharacterStream).%New()
	s Flag=..#InterfaceFlag
	if Flag="Y" {
		if (FunctionCode["SJ"){
			;试剂
			s ReturnJson=##class(web.DHCENS.BLL.SPD.Method.SJInterface).SendSJInterfaceService(FunctionCode,InputStream)
		}ELSE{
		s ReturnJson=##class(web.DHCENS.BLL.SPD.Method.HCInterface).SendHCInterfaceService(FunctionCode,InputStream)
		}
	}
	else {
		s ReturnJson=..YGCGInterface(FunctionCode,InputStream)
	}
	q ReturnJson
}

/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).YGCGInterface(H001,"")
/// 测试 专网地址 Server 10.8.2.220 Port 9011 公网地址 218.17.85.68:9001
/// 正式 Server 10.8.2.220 Port 9010
ClassMethod YGCGInterface(FunctionCode As %String, InputStream) As %GlobalCharacterStream
{
	s $ZT="Exception"
	if $ISObject(InputStream)
	{
		Set len = InputStream.Size
		Do InputStream.Rewind()
		Set params = InputStream.Read(.len, .st)
	}else{
		set params=InputStream
	}
	 
	s url=""
	s Return=##class(%GlobalCharacterStream).%New()
	if FunctionCode="H001" {
		s url="/hcapi/v1/hospitalInterface/connection/test"
		set tRequest=##class(%Net.HttpRequest).%New() 
		set tRequest.Server="218.17.85.68"	//10.8.2.220
		set tRequest.Port="9001"	//9011
		do tRequest.EntityBody.Write(params)
		do tRequest.ContentTypeSet("application/json")
		do tRequest.ContentCharsetSet("UTF8")
		do tRequest.Post(url)
		set Return=tRequest.HttpResponse.Data
	}
	else  {
		if FunctionCode="H002" s url="/hcapi/v1/hospitalInterface/token/get"
		else  if FunctionCode="H003" s url="/hcapi/v1/hospitalInterface/order/add"
		else  if FunctionCode="H004" s url="/hcapi/v1/hospitalInterface/orderdetail/add"
		else  if FunctionCode="H005" s url="/hcapi/v1/hospitalInterface/order/submit"
		else  if FunctionCode="H006" s url="/hcapi/v1/hospitalInterface/orderdetail/get"
		else  if FunctionCode="H007" s url="/hcapi/v1/hospitalInterface/distribution/get"
		else  if FunctionCode="H008" s url="/hcapi/v1/hospitalInterface/storage/add"
		else  if FunctionCode="H009" s url="/hcapi/v1/hospitalInterface/hospitalProcurecatalog/get"
		else  if FunctionCode="H010" s url="/hcapi/v1/hospitalInterface/return/addReturn"
		else  if FunctionCode="H011" s url="/hcapi/v1/hospitalInterface/return/getReturn"
		else  if FunctionCode="H012" s url="/hcapi/v1/hospitalInterface/payOrder/addOrder"
		else  if FunctionCode="H013" s url="/hcapi/v1/hospitalInterface/payOrder/addOrderDetail"
		else  if FunctionCode="H014" s url="/hcapi/v1/hospitalInterface/payOrder/submitOrder"
		else  if FunctionCode="H015" s url="/hcapi/v1/hospitalInterface/hospitalSubCode/get"
		q:url="" ""
		set tRequest=##class(%Net.HttpRequest).%New() 
		set tRequest.Server="218.17.85.68"
		set tRequest.Port="9001" 
		set tKey="params" 
		do tRequest.InsertParam(tKey,params)
		do tRequest.ContentTypeSet("application/json")
		do tRequest.ContentCharsetSet("UTF8")
		do tRequest.Post(url)  
		set Return=tRequest.HttpResponse.Data 
	}
	q Return
Exception
	s Return=##class(%GlobalCharacterStream).%New()
	d Return.Write("-1^"_$ZE)
	q Return
}

/// 批量上传入库信息 HC012 物资 SJ011 试剂
/// w ##class(web.DHCSTMHUI.INPO).SendInPoStr(12)
ClassMethod JsSendInGdrecStr(IngrStr As %String) As %String
{
	s del="^"
	s count=$l(IngrStr,del)
	s ret=0,failcont=0
	f i=1:1:count  d
	.s Ingr=$p(IngrStr,del,i)
	.s ret=..AddIngdrec(Ingr)
	.i ret'=0 d
	..s failcont=failcont+1
	.
	q count_"^"_failcont
}

/// 获取规格型号已对照库存项代码
ClassMethod GetComparedData(SMLRowId As %String) As %String
{
	q:+SMLRowId'>0 ""
	s InciStr="",InciCodeStr=""
	s Inci=""
	f  s Inci=$o(^DHCItmPCRelation(0,"LOG",+SMLRowId,Inci)) q:Inci=""  d
	.s PurItmRelId=""
	.f  s PurItmRelId=$o(^DHCItmPCRelation(0,"LOG",+SMLRowId,Inci,PurItmRelId)) q:PurItmRelId=""  d
	..s SML=$P(^DHCItmPCRelation(PurItmRelId),"^",3)
	..q:SMLRowId'=SML
	..s InciCode=$p(^INCI(Inci,1),"^",1)
	..i InciStr'="" s InciStr=InciStr_","_Inci
	..else  s InciStr=Inci
	..i InciCodeStr'="" s InciCodeStr=InciCodeStr_","_InciCode
	..else  s InciCodeStr=InciCode
	q InciStr_"^"_InciCodeStr
}

/// HC005 下载 合同信息 
/// Creator：lihui
/// CreateDate: 20221115
/// Table：User.DHCProContract
/// Input: currentPageNumber-指定页码,beginTime开始日期 时间,endTime 截止日期 时间，contractIds-合同ID ，userID 操作人ID
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetProContInfo("1","2021-05-01","2022-04-05","","24990")
ClassMethod GetProContInfo(currentPageNumber As %String = "1", beginTime As %String, endTime As %String, contractIds As %String, userID As %String) As %String
{
	s ^litmp("GetProContInfo")=$lb(currentPageNumber,beginTime,endTime,contractIds,userID)
	s RtnObj=""
	i (..#Version="HisUI") s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	i (..#Version="HisUI")&&((beginTime="")&&(endTime="")&&(contractIds="") )  d RtnObj.Err(-1,"","时间和合同id不能同时为空","",0) q RtnObj.Json()
	i (..#Version="Ext")&&((beginTime="")&&(endTime="")&&(contractIds="") ) q "-1^时间和合同id不能同时为空"
	s MainTotalPageAll=0,MainTotalCountAll=0,retmsg="",RetVal=0
	if beginTime'="" {
		s:beginTime'="" beginTime=$zdh(beginTime,3) 
		s:endTime'="" endTime=$zdh(endTime,3) 
		f date=beginTime:1:endTime q:(RtnObj.success'=0)  d
		.s RetInfo=..GetContrPro(currentPageNumber,date,date+1,contractIds,userID)
		.s MainTotalPage=$p(RetInfo,"^",1)
		.s MainTotalCount=$p(RetInfo,"^",2)
		.i MainTotalCount'>0  s retmsg=retmsg_"日期"_$zd(date,3)_"合同信息为空 或者 下载失败"_RetInfo
		.s MainTotalPageAll=MainTotalPageAll+MainTotalPage
		.s MainTotalCountAll=MainTotalCountAll+MainTotalCount
	}
	s:retmsg'="" RetVal=-1
	s:retmsg="" retmsg=MainTotalPageAll_"^"_MainTotalCountAll 
	
	i (..#Version="Ext") q RetVal_"^"_retmsg 
	d RtnObj.Err(RetVal,"",retmsg,"",0)
	q RtnObj.Json()
}

/// Part: HC005 获取合同信息
/// Creator：lihui
/// CreateDate: 20221115
/// Input: currentPageNumber-指定页码,beginTime-开始时间,endTime-截止时间,contractIds-合同编号,userID-下载操作人ID
/// Return:0-成功
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetContrPro("1","2021-04-15","2021-04-16","",1)
ClassMethod GetContrPro(currentPageNumber As %String, beginTime As %String = "", endTime As %String = "", contractIds As %String = "", userID As %String) As %String
{
	q:(beginTime="")&&(endTime="")&&(contractIds="") "-2^时间和合同id不能同时为空"
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s InputStream=##class(%GlobalCharacterStream).%New()
	s listdata=""
	s:beginTime'="" beginTime=$zd(beginTime,3)
	s:endTime'="" endTime=$zd(endTime,3)
	s:contractIds="" contractIds="E"  ;传入为空
	s InputGoodsCount=$Length(contractIds,",")
	s RetVal=0,RetMsgStr=""
	s (AllDetailTotalPageCount,AllDetailTotalCounts)=0
	f count=1:1:InputGoodsCount {
		s tmpcontractId=$p(contractIds,",",count)
		i contractIds="E" s tmpcontractId=""
		s InputMainParam="accessToken="_accessToken_"&bargainDetailId="_tmpcontractId_"&currentPageNumber="_currentPageNumber_"&endTime="_endTime_"&hospitalId="_hospitalId_"&startTime="_beginTime
		s InputMainStream=##class(%GlobalCharacterStream).%New()
		d InputMainStream.Write(InputMainParam)
		s ReturnJson=..SendData("HC005",InputMainStream)
		continue:ReturnJson.Size=0 ;"-999^合同信息平台返回值为空"
	    d ReturnJson.Rewind()
	    s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	    s ReturnCode=ReturnJsonObj.returnCode 
	    s ReturnMsg=ReturnJsonObj.returnMsg
	    continue:ReturnCode'=1 ;ReturnCode_"^"_ReturnMsg
	    s TotalPageCount=ReturnJsonObj.totalPageCount 	;总页数
	    s TotalCounts=ReturnJsonObj.totalRecordCount  	;总条数
	    s currentPageNumber=ReturnJsonObj.currentPageNumber
	    s successList=ReturnJsonObj.dataList
	    s ListSize=successList.Count()
	    f i=1:1:ListSize {
			s HospitalObj=successList.GetAt(i)
			s contractId=HospitalObj.bargainId  				; 合同编号
			continue:contractId=""
			s detailId=HospitalObj.bargainDetailId ;合同明细ID 唯一标识
			continue:detailId=""
			s HospitalID=HospitalObj.hospitalId			;医疗机构账号
			s hospitalName=HospitalObj.hospitalName ;医疗机构名称
			s lawerHospital=HospitalObj.lawerHospital ;医院负责人
			s phoneHospital=HospitalObj.phoneHospital ;医院联系电话
			s registerAddressHosp=HospitalObj.registerAddressHosp ; 医院注册地址
			s hospitalSignStatus ="" ; HospitalObj.hospitalSignStatus ;医疗机构签订状态 0：未签订，1：已签订，2：拒绝签订"
			s hospitalSignTime=HospitalObj.signtimeHospital	 ;医疗机构签订时间
			i hospitalSignTime="null" s hospitalSignTime=""
			s hospitalSignDate=$p(hospitalSignTime," ",1)
			s:hospitalSignDate'="" hospitalSignDate=$zdh(hospitalSignDate,3)
			s hospitalSignTime=$p(hospitalSignTime," ",2)
			s:hospitalSignTime'="" hospitalSignTime=$zth(hospitalSignTime,3)
			s lawerCompanyName=HospitalObj.lawerCompanyName  	;生产企业法定代表人
			s companyIdSc=HospitalObj.companyIdSc  	;生产企业编号
			s companyNameSc=HospitalObj.companyNameSc	;生产企业名称
			s phoneCompsc=HospitalObj.phoneCompsc  ;生产企业联系电话
			s registerAddressCompsc=HospitalObj.registerAddressCompsc ;生产企业注册地址
			s companyScSignStatus="" ;HospitalObj.companyScSignStatus 	;生产企业签订状态 0：未签订，1：已签订，2：拒绝签订
			s signtimeCompsc=HospitalObj.signtimeCompsc   		; 生产企业签约具体时间
			i signtimeCompsc="null" s signtimeCompsc=""
			s companyScSignDate=$p(signtimeCompsc," ",1)
			s:companyScSignDate'="" companyScSignDate=$zdh(companyScSignDate,3)
			s companyScSignTime=$p(signtimeCompsc," ",2)
			s:companyScSignTime'="" companyScSignTime=$zth(companyScSignTime,3)
			s companyIdPs= HospitalObj.companyIdPs ; 配送方编号
			s companyNamePs=HospitalObj.companyNamePs    ;配送方名称
			s lawerCompPs=HospitalObj.lawerCompPs  	;配送企业法定代表人
			s phoneCompPs=HospitalObj.phoneCompPs    ;配送企业联系电话
			s adressCompPs=HospitalObj.adressCompPs ;配送企业注册地址
			s companyPsSignStatus = "" ;HospitalObj.companyPsSignStatus ;配送企业签订状态 0：未签订，1：已签订，2：拒绝签订
			s companyPsSignTime=HospitalObj.signdateCompPs		;配送企业签订时间
			i companyPsSignTime="null" s companyPsSignTime=""
			s companyPsSignDate=$p(companyPsSignTime," ",1)
			s:companyPsSignDate'="" companyPsSignDate=$zdh(companyPsSignDate,3)
			s companyPsSignTime=$p(companyPsSignTime," ",2)
			s:companyPsSignTime'="" companyPsSignTime=$zth(companyPsSignTime,3)
			s regCername=HospitalObj.regCername ;注册证名称
			s regCerno=HospitalObj.regCerno ;注册证ID
			s yearCount=HospitalObj.yearCount  ;合同采购量
			s amount=HospitalObj.amount ;合同明细采购总价
			s bidPrice=HospitalObj.bidPrice ;中选价格
			s accomplishment=HospitalObj.accomplishment ;合同完成量
			s isSkipHospital=HospitalObj.isSkipHospital  ;医院是否跳过签章（ 0：未签（初始化状态），1：跳过，2，未跳过）
			s contractStatus=HospitalObj.bargainState   ;合同签约状态，0未提交 1医院已签约 2生产企业已签约
			s signatureState=HospitalObj.signatureState ;签章状态(0.未签章，1.医院已签章，2.生产企业已签章，3.配送企业已签章)
			s isWithAmount="" ;HospitalObj.isWithAmount 				;合同类型
			s addDateTime=HospitalObj.addTime			;添加时间
			i addDateTime="null" s addDateTime=""
			s addDate=$p(addDateTime," ",1)
			s:addDate'="" addDate=$zdh(addDate,3)
			s addTime=$p(addDateTime," ",2)
			s:addTime'="" addTime=$zth(addTime,3)
			s lastUpDateTime=HospitalObj.lastUpdateTime	;最后更新时间
			i lastUpDateTime="null" s lastUpDateTime=""
			s lastUpDate=$p(lastUpDateTime," ",1)
			s:lastUpDate'="" lastUpDate=$zdh(lastUpDate,3)
			s lastUpTime=$p(lastUpDateTime," ",2)
			s:lastUpTime'="" lastUpTime=$zth(lastUpTime,3)
			
			s DHCMPCTRowId=$o(^DHCMPCT(0,"CONTRACTDETAILID",contractId,detailId,0) )
			if +DHCMPCTRowId=0 {
				s DHCProContract=##Class(User.DHCProContract).%New()
			}
			else {
				s DHCProContract=##Class(User.DHCProContract).%OpenId(DHCMPCTRowId)
			}
			s DHCProContract.DHCPCTcontractId=contractId
			s DHCProContract.DHCPCTdetailId=detailId
			s DHCProContract.DHCPCTHospId=HospitalID
			s DHCProContract.DHCPCThospitalName=hospitalName
			s DHCProContract.DHCPCTlawerHospital=lawerHospital
			s DHCProContract.DHCPCTphoneHospital=phoneHospital
			s DHCProContract.DHCPCTregisterAddressHosp=registerAddressHosp
			s DHCProContract.DHCPCThospitalSignStatus=hospitalSignStatus
			s DHCProContract.DHCPCThospitalSignDate=hospitalSignDate
			s DHCProContract.DHCPCThospitalSignTime=hospitalSignTime
			s DHCProContract.DHCPCTCompanyIdSc=companyIdSc
			s DHCProContract.DHCPCTCompanyNameSc=companyNameSc
			s DHCProContract.DHCPCTlawerCompanyName=lawerCompanyName
			s DHCProContract.DHCPCTphoneCompsc=phoneCompsc
			s DHCProContract.DHCPCTregisterAddressCompsc=registerAddressCompsc
			s DHCProContract.DHCPCTcompanyScSignStatus=companyScSignStatus
			s DHCProContract.DHCPCTcompanyScSignDate=companyScSignDate
			s DHCProContract.DHCPCTcompanyScSignTime=companyScSignTime
			s DHCProContract.DHCPCTcompanyIdPs=companyIdPs
			s DHCProContract.DHCPCTcompanyNamePs=companyNamePs
			s DHCProContract.DHCPCTlawerCompPs=lawerCompPs
			s DHCProContract.DHCPCTphoneCompPs=phoneCompPs
			s DHCProContract.DHCPCTadressCompPs=adressCompPs
			s DHCProContract.DHCPCTcompanyPsSignStatus=companyPsSignStatus
			s DHCProContract.DHCPCTcompanyPsSignDate=companyPsSignDate
			s DHCProContract.DHCPCTcompanyPsSignTime=companyPsSignTime
			s DHCProContract.DHCPCTcontractStatus=contractStatus
			s DHCProContract.DHCPCTregCername=regCername
			s DHCProContract.DHCPCTregCerno=regCerno
			s DHCProContract.DHCPCTamount=amount
			s DHCProContract.DHCPCTcontractNumber=yearCount
			s DHCProContract.DHCPCTcontractPrice=bidPrice
			s DHCProContract.DHCPCTisSkipHospital=isSkipHospital
			s DHCProContract.DHCPCTsignatureState=signatureState
			s DHCProContract.DHCPCTisWithAmount=""
			s DHCProContract.DHCPCTprocurecatalogId=""
			s DHCProContract.DHCPCTGoodsId=""
			s DHCProContract.DHCPCTdisTime=""
			s DHCProContract.DHCPCTcontractCycle=""
			s DHCProContract.DHCPCTcontractPayTime=""
			s DHCProContract.DHCPCTcurrentContractExecuteNumber=""
			s DHCProContract.DHCPCTAddDate=addDate
			s DHCProContract.DHCPCTAddTime=addTime
			s DHCProContract.DHCPCTLastUpdateDate=lastUpDate
			s DHCProContract.DHCPCTLastUpdateTime=lastUpTime
			s DHCProContract.DHCPCTDownDate=+$h
			s DHCProContract.DHCPCTDownTime=$p($h,",",2)
			d DHCProContract.DHCPCTDownUserSetObjectId(userID)
			s RetVal=DHCProContract.%Save()
			if RetVal'=1 {
				s RetMsg=$SYSTEM.Status.GetErrorText(RetVal)
				s RetMsgStr=$s(RetMsgStr="":RetMsgStr=RetVal,1:RetMsgStr=RetMsgStr_";"_contractId_":"_detailId_":"_RetMsg)
			}
		}
	}
	s:RetMsgStr="" RetMsgStr=TotalPageCount_"^"_TotalCounts
	q RetMsgStr
}

/// HIUSI版本查询已下载的合同信息
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryProContract(1,15,"")
ClassMethod JSQueryProContract(page As %String, rows As %String, Params As %String = "")
{
	s Start=page
	i (..#Version="HisUI")  d
	.s Start=(page-1)*rows
	s Limit=rows
	s End=Start+Limit
	s pcontractIds=$p(Params,"^",1)
	s Num=0
	s json=..GetJsonObj()
	s DHCMPCTRowId=0
	f  s DHCMPCTRowId=$o(^DHCMPCT(DHCMPCTRowId)) q:DHCMPCTRowId=""  d
	.s ProConinfo=^DHCMPCT(DHCMPCTRowId)
	.s PCTcontractId=$p(ProConinfo,"^",12) ; 合同主表ID
	.q:(pcontractIds'="")&&(pcontractIds'=PCTcontractId)
	.s hospitalId=$p(ProConinfo,"^",24) ; 医疗机构编号
	.s hospitalName=$p(ProConinfo,"^",25) ; 医院名称
	.s lawerHospital=$p(ProConinfo,"^",39) ; 医院负责人
	.s phoneHospital=$p(ProConinfo,"^",40) ; 医院联系电话
	.s registerAddressHosp=$p(ProConinfo,"^",41) ; 医院注册地址 
	.s PCThospitalSignStatus=$p(ProConinfo,"^",26) ; 医疗机构签订状态
	.s isSkipHospital=$p(ProConinfo,"^",50) ; 医院是否跳过签章
	.s hospitalSignDate=$p(ProConinfo,"^",37) ; 医院签订日期
	.s:hospitalSignDate'="" hospitalSignDate=$zd(hospitalSignDate,3) 
	.s hospitalSignTime=$p(ProConinfo,"^",38) ; 医院签订时间
	.s:hospitalSignTime'="" hospitalSignTime=$zt(hospitalSignTime,1)
	.s PCTCompanyNameSc=$p(ProConinfo,"^",6) ; 生产企业名称
	.s companyIdSc=$p(ProConinfo,"^",4) ; 生产企业编号 
	.s phoneCompsc=$p(ProConinfo,"^",43) ; 生产企业联系电话 
	.s lawerCompanyName=$p(ProConinfo,"^",42) ; 生产企业负责人
	.s PCTcompanyScSignStatus=$p(ProConinfo,"^",9) ; 生产企业签订状态
	.s companyScSignDate=$p(ProConinfo,"^",35) ; 生产企业签订日期
	.s:companyScSignDate'="" companyScSignDate=$zd(companyScSignDate,3) 
	.s companyScSignTime=$p(ProConinfo,"^",36) ; 生产企业签订时间
	.s:companyScSignTime'="" companyScSignTime=$zt(companyScSignTime,1)
	.s registerAddressCompsc=$p(ProConinfo,"^",44) ; 生产企业注册地址
	.s PCTcontractStatus=$p(ProConinfo,"^",16) ; 合同状态
	.s PCTisWithAmount=$p(ProConinfo,"^",29) ; 是否带量
	.s PCTdetailId=$p(ProConinfo,"^",18) ; 合同明细编号
	.s companyIdPs=$p(ProConinfo,"^",3) ; 配送方编号
	.s PCTcompanyNamePs=$p(ProConinfo,"^",5) ; 配送方名称
	.s PCTcompanyPsSignStatus=$p(ProConinfo,"^",7) ; 配送方签订状态
	.s companyPsSignDate=$p(ProConinfo,"^",18) ; 配送方签订日期
	.s:companyPsSignDate'="" companyPsSignDate=$zd(companyPsSignDate,3) 
	.s companyPsSignTime=$p(ProConinfo,"^",18) ; 配送方签订时间
	.s:companyPsSignTime'="" companyPsSignTime=$zt(companyPsSignTime,1)
	.s lawerCompPs=$p(ProConinfo,"^",52) ; 配送方法定代表人
	.s phoneCompPs=$p(ProConinfo,"^",45) ; 配送企业联系电话
	.s adressCompPs=$p(ProConinfo,"^",46) ; 配送企业注册地址 
	.
	.s regCername=$p(ProConinfo,"^",47) ; 注册证名称
	.s regCerno=$p(ProConinfo,"^",48) ; 注册证号
	.s PCTprocurecatalogId=$p(ProConinfo,"^",32) ; 商品编号
	.s amount=$p(ProConinfo,"^",49) ; 合同明细采购总价 金额 
	.s signatureState=$p(ProConinfo,"^",51) ; 签章状态
	.s accomplishment=$p(ProConinfo,"^",17) ; 合同完成量
	.s LastUpdateDate=$p(ProConinfo,"^",30) ; 最后更新日期
	.s:LastUpdateDate'="" LastUpdateDate=$zd(LastUpdateDate,3) 
	.s LastUpdateTime=$p(ProConinfo,"^",31) ; 最后更新时间
	.s:LastUpdateTime'="" LastUpdateTime=$zt(LastUpdateTime,1)
	.s PCTGoodsId=""
	.s MatPurCatalogRowId="" ;$o(^DHCMatPurCataLog(0,"GoodsId",PCTGoodsId,0))
	.
	.s GoodsName=$s(MatPurCatalogRowId'="":$p(^DHCMatPurCataLog(MatPurCatalogRowId),"^",7),1:"") ;产品名称
	.s PCTcontractNumber=$p(ProConinfo,"^",13) ; 合同量
	.s PCTcontractPrice=$p(ProConinfo,"^",15) ; 合同价 中选价格
	.s PCTdisTime=$p(ProConinfo,"^",19) ; 合同配送时限
	.s PCTcontractCycle=$p(ProConinfo,"^",11) ; 合同周期
	.s PCTcontractPayTime=$p(ProConinfo,"^",14) ; 合同回款时间
	.s PCTcurrentContractExecuteNumber=$p(ProConinfo,"^",17) ; 当前合同执行量
	.s PCTisAgreement=$p(ProConinfo,"^",28) ; 是否带量明细
	.s PCTDownDate=$p(ProConinfo,"^",20) ; 下载日期
	.s:PCTDownDate'="" PCTDownDate=$zd(PCTDownDate,3)
	.s PCTDownTime=$p(ProConinfo,"^",21) ; 下载时间
	.s:PCTDownTime'="" PCTDownTime=$zt(PCTDownTime,1)
	.
	.s PCListsubcodeId="" ; 规格型号编号
	.s PCListOutLookc="" ; 规格
	.s PCListGoodsType="" ; 型号
	.s PCListOutLookc=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(PCListOutLookc,"'","\'")
    	.s PCListOutLookc=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(PCListOutLookc,"\","\\")
    	.s PCListGoodsType=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(PCListGoodsType,"'","\'")
    	.s PCListGoodsType=##class(web.DHCSTMHUI.Common.UtilCommon).Replace(PCListGoodsType,"\","\\")
	.s PCListdiCode="" ; 医疗器械唯一标识
	.s PCListisUsing="" ; 是否启用
	.s RowId=""
	.s Data1=DHCMPCTRowId_"^"_RowId_"^"_PCTcontractId_"^"_PCThospitalSignStatus_"^"_PCTCompanyNameSc_"^"_PCTcompanyScSignStatus_"^"_PCTcompanyNamePs_"^"_PCTcompanyPsSignStatus_"^"_PCTcontractStatus_"^"_PCTisWithAmount_"^"_PCTdetailId
	.s Data2=PCTprocurecatalogId_"^"_PCTGoodsId_"^"_PCTcontractNumber_"^"_PCTcontractPrice_"^"_PCTdisTime_"^"_PCTcontractCycle_"^"_PCTcontractPayTime_"^"_PCTcurrentContractExecuteNumber_"^"_PCTisAgreement_"^"_PCTDownDate
	.s Data3=PCListsubcodeId_"^"_PCListOutLookc_"^"_PCListGoodsType_"^"_PCListdiCode_"^"_PCListisUsing_"^"_PCTDownTime_"^"_GoodsName_"^"_companyPsSignDate_"^"_companyPsSignTime_"^"_lawerCompPs
	.s Data4=phoneCompPs_"^"_regCername_"^"_hospitalId_"^"_companyIdSc_"^"_companyScSignDate_"^"_companyScSignTime_"^"_registerAddressCompsc_"^"_amount_"^"_regCerno_"^"_phoneCompsc
	.s Data5=hospitalName_"^"_lawerHospital_"^"_lawerCompanyName_"^"_companyIdPs_"^"_isSkipHospital_"^"_hospitalSignDate_"^"_hospitalSignTime_"^"_signatureState_"^"_phoneHospital_"^"_accomplishment
	.s Data6=LastUpdateDate_"^"_LastUpdateTime
	.s DataStr=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6
	.s Num=Num+1
    	.q:Num<=Start
    	.q:Num>End
    	.d json.InsertRowData(DataStr)
	s Title1="DHCMPCTRowId^RowId^PCTcontractId^PCThospitalSignStatus^PCTCompanyNameSc^PCTcompanyScSignStatus^PCTcompanyNamePs^PCTcompanyPsSignStatus^PCTcontractStatus^PCTisWithAmount^PCTdetailId"
    s Title2="PCTprocurecatalogId^PCTGoodsId^PCTcontractNumber^PCTcontractPrice^PCTdisTime^PCTcontractCycle^PCTcontractPayTime^PCTcurrentContractExecuteNumber^PCTisAgreement^PCTDownDate"
    s Title3="PCListsubcodeId^PCListOutLookc^PCListGoodsType^PCListdiCode^PCListisUsing^PCTDownTime^GoodsName^companyPsSignDate^companyPsSignTime^lawerCompPs"
    s Title4="phoneCompPs^regCername^hospitalId^companyIdSc^companyScSignDate^companyScSignTime^registerAddressCompsc^amount^regCerno^phoneCompsc"
    s Title5="hospitalName^lawerHospital^lawerCompanyName^companyIdPs^isSkipHospital^hospitalSignDate^hospitalSignTime^signatureState^phoneHospital^accomplishment"
    s Title6="LastUpdateDate^LastUpdateTime"
    s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4_"^"_Title5_"^"_Title6
    
    i ..#Version="Ext"  d
	.s JsonStr=json.getJsonData(Title,Num)
	e  d
	.s JsonStr=""
	.d json.getJsonData(Title,Num)
	k json 
	q JsonStr
}

/// Part: HC006物资 SJ005试剂 获取企业信息
/// Creator：lihui
/// CreateDate: 20221115
/// Input: currentPageNumber-指定页码,beginTime,endTime,companyIds-企业编号ID,操作人ID
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetCompanyInfo(1,"2021-01-01","2021-04-28","",1)
ClassMethod GetCompanyInfo(currentPageNumber As %String = "1", beginTime As %String, endTime As %String, companyIds As %String, userID As %String) As %String
{
	s RtnObj=""
	i (..#Version="HisUI") s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	i (..#Version="HisUI")&&(beginTime="")&&(endTime="")&&(companyIds="") d RtnObj.Err(-1,"","日期和企业编号id不能同时为空","",0) q RtnObj.Json()
	i (..#Version="Ext")&&(beginTime="")&&(endTime="")&&(companyIds="") q -1_"^日期和企业编号id不能同时为空" 
	s (MainTotalPage,MainTotalCount)=0
	s retmsg="",RetVal=1
	s year=+beginTime
	f i=1:1:12 {
		s month=""
		if i<10 s month="0"_i
		e  s month=i
		s startdate=year_"-"_month
		f PageNumber=1:1:currentPageNumber q:(RetVal'=1)  d
		.;企业 物资
		.s RetInfo=..CompanyInfo(PageNumber,startdate,endTime,companyIds,userID,"HC006")
		.s RetVal=$p(RetInfo,"^",1)
		.s MainTotalPage=MainTotalPage+$p(RetInfo,"^",2)
		.s MainTotalCount=MainTotalCount+$p(RetInfo,"^",3)
		.i RetVal'=1  s retmsg=retmsg_"企业物资目录下载失败"_RetInfo
		.
		.;企业 试剂
		.s RetInfo=..CompanyInfo(PageNumber,startdate,endTime,companyIds,userID,"SJ005")
		.s RetVal=$p(RetInfo,"^",1)
		.s MainTotalPage=MainTotalPage+$p(RetInfo,"^",2)
		.s MainTotalCount=MainTotalCount+$p(RetInfo,"^",3)
		.i RetVal'=1  s retmsg=retmsg_"企业试剂目录下载失败"_RetInfo
		.
	}
	s:retmsg'="" RetVal=-1
	s:retmsg="" retmsg=MainTotalPage_"^"_MainTotalCount,RetVal=0
	i (..#Version="Ext") q RetVal_"^"_retmsg 
	d RtnObj.Err(RetVal,"",retmsg,"",0)
	q RtnObj.Json()
}

/// Part: HC006物资 SJ006试剂 获取企业信息
/// Creator：lihui
/// CreateDate: 20221115
/// Input: currentPageNumber-指定页码,companyIds-企业编号ID,beginTime,endTime, InterTypeCoce(试剂:SJ006; 物资:HC006)
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetCompanyInfo(1,"2021-01-01","2021-04-28","",1)
ClassMethod CompanyInfo(currentPageNumber As %String = "1", beginTime As %String, endTime As %String, companyIds As %String, userID As %String, InterTypeCoce = "HC006") As %String
{
	s ^litmp("GetProductInfo")=$lb(currentPageNumber,beginTime,endTime,companyIds,userID,InterTypeCoce)
	q:(beginTime="")&&(endTime="")&&(companyIds="") "-1^时间和企业编号id不能同时为空"
	
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s InputStream=##class(%GlobalCharacterStream).%New()
	s listdata=""
	s InputGoodsCount=$Length(companyIds,",")
	f count=1:1:InputGoodsCount {
		s InputGoodID=$p(companyIds,",",count)
		continue:InputGoodID=""
		s Data=InputGoodID_"^"_InputGoodID
		s Title="companyId^companyID"
		s GoodIDJsonStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
		if listdata'="" s listdata=listdata_","_GoodIDJsonStr
		else  s listdata=GoodIDJsonStr
	}
	s listdata="{""list"":["_listdata_"]}"
	s month=$p(beginTime,"-",1,2)
	s InputParam="accessToken="_accessToken_"&companyIds="_listdata_"&month="_month_"&hospitalId="_hospitalId_"&currentPageNumber="_currentPageNumber
	s InputStream=##class(%GlobalCharacterStream).%New()
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	q:ReturnJson.Size=0 RtnObj.Err(-1,"","平台返回值为空","",0)
	d ReturnJson.Rewind()
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode   
	s ReturnMsg=ReturnJsonObj.returnMsg  
	q:ReturnCode'=1 ReturnCode_"^"_ReturnMsg  
	s TotalCounts=ReturnJsonObj.totalRecordCount  
	s TotalPageCount=ReturnJsonObj.totalPageCount
	s RetVal=1,RetMsgStr=""
	f j=1:1:TotalPageCount {
		s InputParam="accessToken="_accessToken_"&companyIds="_listdata_"&month="_month_"&hospitalId="_hospitalId_"&currentPageNumber="_j
		s InputStream=##class(%GlobalCharacterStream).%New()
		d InputStream.Write(InputParam)
		s ReturnJson=..SendData(InterTypeCoce,InputStream)
		continue:ReturnJson.Size=0
		d ReturnJson.Rewind()
		s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
		s ReturnCode=ReturnJsonObj.returnCode   
		s ReturnMsg=ReturnJsonObj.returnMsg  
		continue:ReturnCode'=1
		s currentPage=ReturnJsonObj.currentPageNumber
		s successList=ReturnJsonObj.dataList
		s ListSize=successList.Count()
		f i=1:1:ListSize {
			s DataObj=successList.GetAt(i)
			s companyId=DataObj.companyId			// 企业编号
			continue:companyId=""
			s companyName=DataObj.companyName			// 企业名称
			s businessLicense=DataObj.businessLicense   			// 营业执照注册号
			s areaId=DataObj.areaId			// 地区 id 号
			s areaName=DataObj.areaName  			// 地区名称
			s companyContactTel=DataObj.companyContactTel ; 企业联系电话
			s companyType=DataObj.companyType ; 企业类型
			s loginUserName=DataObj.loginUserName ; 企业账号
			s addDateTime=DataObj.addTime ; 
			i addDateTime="null" s addDateTime=""
			s addDate=$p(addDateTime," ",1)
			s:addDate'="" addDate=$zdh(addDate,3)
			s addTime=$p(addDateTime," ",2)
			s:addTime'="" addTime=$zth(addTime,3)
			s lastUpDateTime=DataObj.lastUpdateTime  ; 变更时间
			i lastUpDateTime="null" s lastUpDateTime=""
			s lastUpDate=$p(lastUpDateTime," ",1)
			s:lastUpDate'="" lastUpDate=$zdh(lastUpDate,3)
			s lastUpTime=$p(lastUpDateTime," ",2)
			s:lastUpTime'="" lastUpTime=$zth(lastUpTime,3)
			//更新 User.DHCPurComCatalog
			s DHCPCRowId=$o(^PURCOMCAT(0,"CODE",companyId,"") )
			if (+DHCPCRowId=0) {
				s DHCPCObj=##class(User.DHCPurComCatalog).%New("")
			}
			else {
				s DHCPCObj=##class(User.DHCPurComCatalog).%OpenId(DHCPCRowId)
			}
			s DHCPCObj.DHCPCcompanyId=companyId
			s DHCPCObj.DHCPCcompanyName=companyName
			s DHCPCObj.DHCPCaddress=""
			s DHCPCObj.DHCPCcompanyContactTel=companyContactTel
			s DHCPCObj.DHCPCcompanyContactFax=""
			s DHCPCObj.DHCPCzipCode=""
			s DHCPCObj.DHCPCemail=""
			s DHCPCObj.DHCPCaddDate=addDate
			s DHCPCObj.DHCPCaddTime=addTime
			s DHCPCObj.DHCPClastUpdateDate=lastUpDate
			s DHCPCObj.DHCPClastUpdateTime=lastUpTime
			s DHCPCObj.DHCPCDownDate=+$h
			s DHCPCObj.DHCPCDownTime=$p($h,",",2)
			d DHCPCObj.DHCPCDownUserSetObjectId(userID)
			s DHCPCObj.DHCPCPointer=""
			s DHCPCObj.DHCPCType=""
			s DHCPCObj.DHCPCBusinessLicense=businessLicense
			s DHCPCObj.DHCPCAreaId=areaId
			s DHCPCObj.DHCPCAreaName=areaName
			s DHCPCObj.DHCPCCompanyType=companyType
			s DHCPCObj.DHCPCloginUserName=loginUserName
			s RetVal=DHCPCObj.%Save()
			if RetVal'=1 {
				s RetMsg=$SYSTEM.Status.GetErrorText(RetVal)
				s RetMsgStr=$s(RetMsgStr="":RetMsgStr=RetVal,1:RetMsgStr=RetMsgStr_";"_companyId_":"_RetMsg)
			}
		}
	}
	i RetMsgStr="" s RetMsgStr=TotalPageCount_"^"_TotalCounts
	q RetVal_"^"_RetMsgStr
}

/// HIUSI版本查询已下载的企业信息
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryCompany(1,15,"")
ClassMethod JSQueryCompany(page As %String, rows As %String, Params As %String = "")
{
	s Start=page
	i (..#Version="HisUI")  d
	.s Start=(page-1)*rows
	s Limit=rows
	s End=Start+Limit
	s ComCode=$p(Params,"^",1)
	s ComName=$p(Params,"^",2)
	s Num=0
	s json=..GetJsonObj()
	s RowId=0
	f  s RowId=$o(^PURCOMCAT(RowId)) q:RowId=""  d
	.s Cominfo=^PURCOMCAT(RowId)
	.s Pointer=$p(Cominfo,"^",18) ; HIS企业ID 
	.s Type=$p(Cominfo,"^",19) ; HIS企业类型
	.s TypeDesc=""
	.s:Type="V" TypeDesc="供应商"
	.s:Type="M" TypeDesc="生产厂商"
	.s DHCPCcompanyId=$p(Cominfo,"^",9) ; 企业编号
	.q:(ComCode'="")&&(DHCPCcompanyId'=ComCode)
	.s DHCPCcompanyName=$p(Cominfo,"^",10) ; 企业名称
	.q:(ComName'="")&&(DHCPCcompanyName'[ComName)
	.s DHCPCaddress=$p(Cominfo,"^",2) ; 地址
	.s CcompanyContactTel=$p(Cominfo,"^",8) ; 企业联系电话 
	.s CcompanyContactFax=$p(Cominfo,"^",7) ; 企业传真号码
	.s DHCPCzipCode=$p(Cominfo,"^",20) ; 邮编
	.s DHCPCemail=$p(Cominfo,"^",15) ; 邮箱
	.s DownDate=$p(Cominfo,"^",12) ; 下载日期 
	.s:DownDate'="" DownDate=$zd(DownDate,3)
	.s DownTime=$p(Cominfo,"^",13) ; 下载时间
	.s:DownTime'="" DownTime=$zt(DownTime,1)
	.s DHCPCBusinessLicense=$p(Cominfo,"^",6) ; 营业执照注册号
	.s AreaId=$p(Cominfo,"^",4) ; 地区id号
	.s AreaName=$p(Cominfo,"^",5) ; 地区名称
	.s CompanyType=$p(Cominfo,"^",11) ; 企业类型
	.s comtypedesc=..comtypedesc(CompanyType)
	.s DHCPCaddDate=$p(Cominfo,"^",1) ; 增加日期
	.s:DHCPCaddDate'="" DHCPCaddDate=$zd(DHCPCaddDate,3)
	.s DHCPCaddTime=$p(Cominfo,"^",3) ; 增加时间
	.s:DHCPCaddTime'="" DHCPCaddTime=$zt(DHCPCaddTime,1)
	.s UpdateDate=$p(Cominfo,"^",16) ; 更新日期
	.s:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
	.s UpdateTime=$p(Cominfo,"^",17) ; 更新时间
	.s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
	.
	.s loginUserName=$p(Cominfo,"^",21) ; 企业账号
	.
	.s Data1=Pointer_"^"_Type_"^"_TypeDesc_"^"_DHCPCcompanyId_"^"_DHCPCcompanyName_"^"_DHCPCaddress_"^"_CcompanyContactTel_"^"_CcompanyContactFax_"^"_DHCPCzipCode_"^"_DHCPCemail
	.s Data2=DownDate_"^"_DownTime_"^"_DHCPCBusinessLicense_"^"_AreaId_"^"_AreaName_"^"_CompanyType_"^"_comtypedesc_"^"_DHCPCaddDate_"^"_DHCPCaddTime_"^"_UpdateDate
	.s Data3=UpdateTime_"^"_RowId_"^"_loginUserName
	.s DataStr=Data1_"^"_Data2_"^"_Data3
	.s Num=Num+1
    	.q:Num<=Start
    	.q:Num>End
    	.d json.InsertRowData(DataStr)
	s Title1="Pointer^Type^TypeDesc^DHCPCcompanyId^DHCPCcompanyName^DHCPCaddress^CcompanyContactTel^CcompanyContactFax^DHCPCzipCode^DHCPCemail"
    	s Title2="DownDate^DownTime^DHCPCBusinessLicense^AreaId^AreaName^CompanyType^comtypedesc^DHCPCaddDate^DHCPCaddTime^UpdateDate"
    	s Title3="UpdateTime^RowId^loginUserName"
    	s Title=Title1_"^"_Title2_"^"_Title3
    	i ..#Version="Ext"  d
	.s JsonStr=json.getJsonData(Title,Num)
	e  d
	.s JsonStr=""
	.d json.getJsonData(Title,Num)
	k json 
	q JsonStr
}

ClassMethod comtypedesc(CompanyType)
{
	q:CompanyType="" ""
	s CompanyTypeDesc=""
	i CompanyType="0" s CompanyTypeDesc="生产企业"
	i CompanyType="1" s CompanyTypeDesc="国内总代"
	i CompanyType="2" s CompanyTypeDesc="配送企业"
	i CompanyType="3" s CompanyTypeDesc="生产配送企业"
	i CompanyType="4" s CompanyTypeDesc="国内总代,配送企业"
	i CompanyType="5" s CompanyTypeDesc="生产,国内总代企业"
	i CompanyType="6" s CompanyTypeDesc="生产,国内总代,配送企业"
	q CompanyTypeDesc
}

/// Description：保存HIS企业信息和采购平台企业对照信息
/// Input: Vendid-His企业ID,RowId-平台企业记录表ID,UpFlag-对照标志(1为对照/0为取消对照)
/// Table：DHC_PurComCatalog
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).SaveComRelaInfo(832,"1||2",1)
ClassMethod SaveComRelaInfo(Vendid As %String, RowId As %String, UpFlag As %String, HIStype As %String)
{
	s RtnObj=""
	i (..#Version="HisUI") s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	i (..#Version="HisUI")&&((Vendid="")&&(RowId="")) d RtnObj.Err(-1,"","His企业ID和平台企业记录表ID不能同时为空","",0) q RtnObj.Json()
	i (..#Version="Ext")&&((Vendid="")&&(RowId="")) q RetVal_"^His企业ID和平台企业记录表ID不能同时为空" 
	
	s RetVal=0,RetMsg="处理成功"
	if (UpFlag=1){
		//关联
		s MPCId=$o(^PURCOMCAT(0,"TYPEPOINT",HIStype,Vendid,""))
		s TmpHisPoint=$p(^PURCOMCAT(RowId),"^",18)
		i (MPCId'="")||(TmpHisPoint'="") d
		.s RetVal="-3"
		.s RetMsg="保存失败!该企业已做对照,请先取消原对照关系再更新"
		i (..#Version="HisUI")&&(MPCId'="")  q RtnObj.Err(-1,"",RetMsg,"",0)
		i (..#Version="Ext")&&(MPCId'="") q RetVal_"^"_RetMsg 
		&sql(UPDATE DHC_PurComCatalog SET DHCPC_Pointer=:Vendid,DHCPC_Type=:HIStype WHERE DHCPC_RowId=:RowId)
	}else{
		//取消关联
		&sql(UPDATE DHC_PurComCatalog SET DHCPC_Pointer=NULL,DHCPC_Type=NULL WHERE DHCPC_RowId=:RowId)
	}
	
	i SQLCODE'=0 d
	.s RetVal=SQLCODE
	.s RetMsg="保存失败!"_$g(%msg)
	i (..#Version="Ext") q RetVal_"^"_RetMsg 
	d RtnObj.Err(RetVal,"",RetMsg,"",0)
	q RtnObj.Json()
}

/// Description：获取企业对照信息
/// Input: Vendid-His企业ID,HIS企业类型
/// Table：DHC_PurComCatalog
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).getComRelaInfo(832,1)
ClassMethod getComRelaInfo(Vendid As %String, HIStype As %String)
{
	
	q:(Vendid="")||(HIStype="") ""
	s (companyName,companyId)=""
	&sql(SELECT DHCPC_companyName, DHCPC_companyId into :companyName,:companyId FROM DHC_PurComCatalog WHERE DHCPC_Type=:HIStype AND DHCPC_Pointer=:Vendid)
	s data=""
	q:SQLCODE data
	s data=companyName_"^"_companyId
	q data
}

/*   关联了付款模块 作废
/// Part: 物资(HC015、HC016、HC018) 试剂(SJ014、SJ015、SJ017) 同步支付单一步式完成
/// Creator：wxj
/// CreateDate:2020-12-22
/// Update: lihui 20221115
/// Description：上传HIS付款单到阳光采购平台
/// Input: PayId-HIS付款单ID
/// Return:0^成功
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).UpLoadPay(10146)
ClassMethod UpLoadPay(PayId As %String)
{
	q:(PayId="") "-1^付款单ID不能为空！"
	
	;q:..InpoIflink(PayId)'="Y" "-1^明细中没有对照的商品"
	s RetInfo="0^"
	s MRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetMRDocFlag(PayId,"PAY")
	i MRDocFlag="Y"   {
		//创建空的付款单
		s RetInfo=..AddPayOrder(PayId,"SJ014")
		s RetVal=$p(RetInfo,"^",1)
		q:RetVal'=0 RetInfo
		s OrderId=$p(RetInfo,"^",2)	
		//添加订单明细
		s RetInfo=..AddPayOrderDetail(PayId,"SJ015")
		s RetVal=$p(RetInfo,"^",1)
		i RetVal'=0 d
		.s ^DHCPAY(PayId,"YZRMPURCODE")=""
		q:RetVal'=0 RetInfo
		//提交订单
		s RetInfo=..SubmitPayOrder(PayId,"SJ017")
		s RetVal=$p(RetInfo,"^",1)
		q:RetVal'=0 RetInfo
		
	}else{
		//创建空的付款单
		s RetInfo=..AddPayOrder(PayId,"HC015")
		s RetVal=$p(RetInfo,"^",1)
		q:RetVal'=0 RetInfo
		s OrderId=$p(RetInfo,"^",2)	
		//添加订单明细
		s RetInfo=..AddPayOrderDetail(PayId,OrderId,"HC016")
		s RetVal=$p(RetInfo,"^",1)
		i RetVal'=0 d
		.s ^DHCPAY(PayId,"YZRMPURCODE")=""
		q:RetVal'=0 RetInfo
		//提交订单
		s RetInfo=..SubmitPayOrder(OrderId,"HC018")
		s RetVal=$p(RetInfo,"^",1)
		q:RetVal'=0 RetInfo
	}
	q RetInfo
}

/// Part:HC015 物资 SJ014 试剂 新建支付订单
/// Creator：wxj
/// CreateDate:2020-12-23
/// Update: lihui 20221123
/// Input:PayId-HIS付款单ID
/// Return:0^成功
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddPayOrder(1060)
ClassMethod AddPayOrder(PayId As %String, InterTypeCoce = "HC015")
{
	q:PayId="" -1_"^订单id为空"
	s vendId=$p($g(^DHCPAY(PayId)),"^",2)
	q:vendId="" -2_"^订单的供应商id为空"
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s orderRemark=""
	s companyId=""
	s Data=PayId_"^"_companyId_"^"_orderRemark
	s Title="hospitalOrderId^companyId^orderRemarks"
	s InputParamJosn=##class(web.DHCSTM.Common.UtilCommon).GetJsonStr(Data,Title)
	s InputParam="accessToken="_accessToken_"&hospitalId="_hospitalId_"&orderInfo="_InputParamJosn
	
	s ReturnJson=..SendData(InterTypeCoce,InputParam)
	q:ReturnJson.Size=0 "-4^上传支付单平台返回值为空"
	d ReturnJson.Rewind()
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode 
	s ReturnMsg=ReturnJsonObj.returnMsg   
	q:ReturnCode'=1 ReturnCode_"^"_ReturnMsg
	s errorList=ReturnJsonObj.errorList
	s successList=ReturnJsonObj.successList
	s ListSize=successList.Count()
	s (OrderId)=""
	f i=1:1:ListSize {
		s DataObj=successList.GetAt(i)
		s OrderId=DataObj.payOrderCode			//采购平台订单ID
	}
	i OrderId'="" d
	.s ^DHCPAY(PayId,"SZBAMATPURCODE")=OrderId
	q:OrderId="" -1_"^"_OrderId
	q 0_"^"_OrderId
}

/// Part: HC016 物资 SJ015 试剂  添加支付明细信息
/// Creator：wxj
/// CreateDate:2020-12-23
/// Update: lihui 20221123
/// Input:PayId-HIS付款单ID
/// Return:0^成功
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddPayOrderDetail(1060)
ClassMethod AddPayOrderDetail(PayId As %String, InterTypeCoce = "HC016")
{
	q:PayId="" "-2^支付单ID不能为空"
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s orderId=$g(^DHCPAY(PayId,"YZRMPURCODE"))
	q:orderId="" "-3^该支付单未上传平台"
	s InputParam="accessToken="_accessToken_"&hospitalId="_hospitalId_"&orderDetailInfo="_"{""list"":["
	s listdata=""
	s RetVal=0,RetMsg=""
	s Chl=""
	f  {
		s Chl=$o(^DHCPAY(PayId,"I",Chl)) 
		q:+Chl'>0
		s Inci=$p(^DHCPAY(PayId,"I",Chl),"^",1)
		q:Inci=""
		s distributeId=""	//配送明细编号
		s returnId=""		//退货明细编号
		s type=$p(^DHCPAY(PayId,"I",Chl),"^",9)
		s pointer=$p(^DHCPAY(PayId,"I",Chl),"^",2)
		s distributeId=""
		i type="G" d
		.s distributeId=$p($g(^DHCINGR(+pointer,"GRI",$p(pointer,"||",2))),"^",64)
		e  i type="R" d
		.s distributeId=$g(^INGRT(+pointer,"DHCGRR",$p(pointer,"||",2),"^",30))
		q:distributeId=""
		s DetailStr="{""payOrderCode"":"""_orderId_""",""distributeId"":"""_distributeId_"""}"
		if listdata'="" s listdata=listdata_","_DetailStr
       	else  s listdata=DetailStr
	
	}
	s InputParam=InputParam_listdata_"]}"
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	q:ReturnJson.Size=0 "-6^上传明细平台返回值为空"
	d ReturnJson.Rewind()
	//解析返回json
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode   
	s ReturnMsg=ReturnJsonObj.returnMsg  
	q:ReturnMsg="OK" "0^支付单明细上传成功"
	s successList=ReturnJsonObj.successList
	s ListSize=successList.Count()
	q RetVal_"^"_RetMsg
}

/// Part: HC018 物资 SJ017 试剂  提交支付单
/// Creator：wxj
/// CreateDate:2020-12-23
/// Update: lihui 20221123
/// Input:PayId-HIS付款单ID
/// Return:0^成功
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).SubmitPayOrder(1060)
ClassMethod SubmitPayOrder(PayId As %String, InterTypeCoce = "HC018")
{
	q:PayId="" "-1^付款单ID为空"
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	
	s orderId=$g(^DHCPAY(PayId,"YZRMPURCODE")) //省平台支付订单编号
	q:orderId="" "-2^该支付单未上传"
	s Data=orderId
	s Title="payOrderCode"
	s InputParamJosn=##class(web.DHCSTM.Common.UtilCommon).GetJsonStr(Data,Title)
	s InputParam="accessToken="_accessToken_"&hospitalId="_hospitalId_"&orderInfo="_InputParamJosn
	s ReturnJson=..SendData(InterTypeCoce,InputParam)
	q:ReturnJson.Size=0 "-3^提交支付单平台返回值为空"
	d ReturnJson.Rewind()
	//解析返回json
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode   
	s ReturnMsg=ReturnJsonObj.returnMsg
	q ReturnCode_"^"_ReturnMsg
}

/// Description：界面显示采购平台支付单明细数据 HC017 物资 SJ016 试剂
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryPayItmInfo(192,1)
ClassMethod JSQueryPayItmInfo(PayId, Page)
{
	s MRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetMRDocFlag(PayId,"PAY")
	s RetInfo=""
	i MRDocFlag="Y"   {
		s RetInfo=..GetPayDetail(PayId,Page,"SJ016")
	}else{
		s RetInfo=..GetPayDetail(PayId,Page,"HC017")
	}
	s RtnObj=""
	i (..#Version="HisUI") s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s RetVal=$p(RetInfo,"^",1)
	s RetMsg=$p(RetInfo,"^",2)
	;i (..#Version="HisUI")&&(RetVal'=0)  d RtnObj.Err(-1,"",RetMsg,"",0) q RtnObj.Json()
	;i (..#Version="Ext")&&(RetVal'=0) q "-1^"_RetMsg
	s Ret=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(RetMsg,"",.JsonObj,.pCharsProcessed,"2","","0")
	;i (..#Version="HisUI")&&(Ret'="1")  d RtnObj.Err(-1,"","Json解析错误","",0) q RtnObj.Json()
	;i (..#Version="Ext")&&(Ret'="1") q "-1^Json解析错误"
	s returnCode=JsonObj.returnCode
	s returnMsg=JsonObj.returnMsg
	;i (..#Version="HisUI")&&(returnCode'="1")  d RtnObj.Err(-1,"",returnMsg,"",0) q RtnObj.Json()
	;i (..#Version="Ext")&&(returnCode'="1") q returnCode_"^"_returnMsg
	s dataList=JsonObj.dataList
	s currentPageNumber=JsonObj.currentPageNumber    ;当前页码
	s totalPageCount=JsonObj.totalPageCount			 ;总页码
	s totalRecordCount=JsonObj.totalRecordCount		 ;总行数
	s Title="orderDetailId^distributeId^orderName^procurecatalogId^realAmount^realQuantity^companyNameSc^companyIdPs^companyNamePs^invoiceId^storageDate^hosIngdNo"
	s Count=dataList.Count()
	;i (..#Version="HisUI")&&(Count'>0)  d RtnObj.Err(-1,"",returnMsg,"",0)  q RtnObj.Json()
	;i (..#Version="Ext")&&(Count'>0) q "-1^"_returnMsg
	s json=..GetJsonObj()
	f i=1:1:Count {
		s getdatalist=dataList.GetAt(i)
		s companyNameSc=companyNameSc   ; 生产企业名称
		s distributeId=distributeId   ; 配送明细编号
		s companyIdPs=companyIdPs   ; 配送企业编号
		s companyNamePs=companyNameSc   ; 配送企业名称
		s storageDate=getdatalist.storageDate    ;收退货日期
		s subDate=$p(storageDate," ",1)
		s subTime=$p(storageDate," ",2)
		s realQuantity=getdatalist.realQuantity	; 结算数量
		s realAmount=getdatalist.realAmount   ; 结算金额
		s procurecatalogId=getdatalist.procurecatalogId	 ; 商品ID
		s orderRemark=getdatalist.orderRemark	;订单备注
		s orderDetailID=getdatalist.orderDetailId		;订单明细编号
		s invoiceId=getdatalist.invoiceId		; 发票号
		s orderDetailId=getdatalist.orderDetailId    ; 
		s orderName=getdatalist.orderName    ; 
		s hosIngdNo=getdatalist.hosIngdNo    ;
		&sql(SELECT * FROM DHCPaySate WHERE orderDetailId=:orderDetailID)
		i SQLCODE  d
		.&sql(INSERT INTO DHCPaySate  (orderDetailId, distributeId, orderName, procurecatalogId, realAmount, realQuantity,companyNameSc,companyIdPs,companyNamePs,invoiceId,storageDate,hosIngdNo) 
		      VALUES(:orderDetailId, :distributeId, :orderName, :procurecatalogId, :realAmount, :realQuantity,:companyNameSc,:companyIdPs,:companyNamePs,:invoiceId,:storageDate,:hosIngdNo))
		e  d
		.&sql(UPDATE DHCPaySate SET orderDetailId=:orderDetailId,distributeId=:distributeId,orderName=:orderName,procurecatalogId=:procurecatalogId,realAmount=:realAmount,realQuantity=:realQuantity,companyNameSc=:companyNameSc,companyIdPs=:companyIdPs,companyNamePs=:companyNamePs,invoiceId=:invoiceId,storageDate=:storageDate,hosIngdNo=:hosIngdNo where  orderDetailId=:orderDetailID)
		s Data=orderDetailId_"^"_distributeId_"^"_orderName_"^"_procurecatalogId_"^"_realAmount_"^"_realQuantity_"^"_companyNameSc_"^"_companyIdPs_"^"_companyNamePs_"^"_invoiceId_"^"_storageDate_"^"_hosIngdNo
		d json.InsertRowData(Data)
	}
	i ..#Version="Ext"  d
	.s JsonStr=json.getJsonData(Title,totalRecordCount)
	e  d
	.s JsonStr=""
	.d json.getJsonData(Title,totalRecordCount)
	k json 
	q JsonStr
}

/// Part:   HC017 物资 SJ016 试剂 获取支付单明细信息
/// Creator：wxj
/// CreateDate:2020-12-22
/// Up: 20221123 lihui
/// Input: PoId-HIS订单ID,currentPageNumber-指定页码, InterTypeCoce(HC017 物资 SJ016 试剂)
/// Return: 0-成功
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetOrderDetail(54183,1)
ClassMethod GetPayDetail(PayId As %String, currentPageNumber As %String = "1", InterTypeCoce = "HC010") As %String
{
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s startTime=""
	s endTime=""
	s InputStream=##class(%GlobalCharacterStream).%New()
	s InputParam="accessToken="_accessToken_"&startTime="_startTime_"&endTime="_endTime_"&hospitalId="_hospitalId_"&currentPageNumber="_currentPageNumber_"&params="_"{""list"":["
	s listdata=""
	s ItmChl=""
	f  {
		s Chl=$o(^DHCPAY(PayId,"I",Chl)) 
		q:+Chl'>0
		s Inci=$p(^DHCPAY(PayId,"I",Chl),"^",1)
		q:Inci=""
		s distributeId=""	//配送明细编号
		s returnId=""		//退货明细编号
		s type=$p(^DHCPAY(PayId,"I",Chl),"^",9)
		s pointer=$p(^DHCPAY(PayId,"I",Chl),"^",2)
		s distributeId=""
		i type="G" d
		.s distributeId=$p($g(^DHCINGR(+pointer,"GRI",$p(pointer,"||",2))),"^",64)
		e  i type="R" d
		.s distributeId=$g(^INGRT(+pointer,"DHCGRR",$p(pointer,"||",2),"^",30))
		q:distributeId=""
		s Data=distributeId
		s Title="distributeId"
		s Inputjson=##class(web.DHCSTM.Common.UtilCommon).GetJsonStr(Data,Title)
		if listdata'="" s listdata=listdata_","_Inputjson
		else  s listdata=Inputjson
		
	}
	q:listdata="" "-2^明细不能为空"
	s InputParam=InputParam_listdata_"]}"
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	s ReturnJsonStr=ReturnJson.Read()
	q 0_"^"_ReturnJsonStr
}
*/
/// Part: 物资(HC015、HC016、HC018) 试剂(SJ014、SJ015、SJ017) 同步支付单一步式完成
/// Creator：wxj
/// CreateDate:2020-12-22
/// Update: lihui 20221115
/// Description：上传HIS 采购订单
/// Input: PayId-HIS付款单ID
/// Return:0^成功
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).UpLoadInpoPay(10146)
ClassMethod UpLoadInpoPay(InpoId As %String)
{
	q:(InpoId="") "-1^付款单ID不能为空！"
	
	q:..InpoIflink(InpoId)'="Y" "-1^明细中没有对照的商品"
	s RetInfo="0^"
	s MRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetMRDocFlag(InpoId,"PO")
	i MRDocFlag="Y"   {
		//创建空的付款单
		s RetInfo=..AddInpoPayOrder(InpoId,"SJ014")
		s RetVal=$p(RetInfo,"^",1)
		q:RetVal'=0 RetInfo
		s OrderId=$p(RetInfo,"^",2)	
		//添加订单明细
		s RetInfo=..AddInpoPayOrderDetail(InpoId,OrderId,"SJ015")
		s RetVal=$p(RetInfo,"^",1)
		q:RetVal'=0 RetInfo
		//提交订单
		s RetInfo=..SubmitInpoPayOrder(OrderId,"SJ017")
		s RetVal=$p(RetInfo,"^",1)
		q:RetVal'=0 RetInfo
		
	}else{
		//创建空的付款单
		s RetInfo=..AddInpoPayOrder(InpoId,"HC015")
		s RetVal=$p(RetInfo,"^",1)
		q:RetVal'=0 RetInfo
		s OrderId=$p(RetInfo,"^",2)	
		//添加订单明细
		s RetInfo=..AddInpoPayOrderDetail(InpoId,OrderId,"HC016")
		s RetVal=$p(RetInfo,"^",1)
		q:RetVal'=0 RetInfo
		//提交订单
		s RetInfo=..SubmitInpoPayOrder(OrderId,"HC018")
		s RetVal=$p(RetInfo,"^",1)
		q:RetVal'=0 RetInfo
	}
	q RetInfo
}

/// Part:HC015 物资 SJ014 试剂 新建支付订单
/// Creator：wxj
/// CreateDate:2020-12-23
/// Update: lihui 20221123
/// Input:PayId-HIS付款单ID
/// Return:0^成功
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddInpoPayOrder(1060)
ClassMethod AddInpoPayOrder(InpoId As %String, InterTypeCoce = "HC015")
{
	q:InpoId="" -1_"^订单id为空"
	s vendId=$p($g(^INPO(InpoId)),"^",2)
	q:vendId="" -2_"^订单的供应商id为空"
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s orderRemark=""
	s companyId=$p(..getComRelaInfo(vendId,"V"),"^",2)
	s Data=InpoId_"^"_companyId_"^"_orderRemark
	s Title="hospitalOrderId^companyId^orderRemarks"
	s InputParamJosn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	s InputParam="accessToken="_accessToken_"&hospitalId="_hospitalId_"&orderInfo="_InputParamJosn
	s InputStream=##class(%GlobalCharacterStream).%New()
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	q:ReturnJson.Size=0 "-4^上传支付单平台返回值为空"
	d ReturnJson.Rewind()
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode 
	s ReturnMsg=ReturnJsonObj.returnMsg   
	s errorList=ReturnJsonObj.errorList
	s errorListSize=errorList.Count()
	s errorMsginfo=""
	f i=1:1:errorListSize {
		s DataObj=errorList.GetAt(i)
		s errorReasonList=DataObj.errorReasonList
		s errorReasonListSize=errorReasonList.Count()
		f j=1:1:errorReasonListSize {
			s ReasonDataObj=errorReasonList.GetAt(j)
			s errorMsginfo=errorMsginfo_""_ReasonDataObj.errorMsg
		}
	}
	q:ReturnCode'=1 ReturnCode_"^"_ReturnMsg_"新建支付单"_errorMsginfo
	s successList=ReturnJsonObj.successList
	
	s OrderId=ReturnJsonObj.payOrderCode
	q:OrderId="" -1_"^"_OrderId
	q 0_"^"_OrderId
}

/// Part: HC016 物资 SJ015 试剂  添加支付明细信息
/// Creator：wxj
/// CreateDate:2020-12-23
/// Update: lihui 20221123
/// Input:PayId-HIS付款单ID
/// Return:0^成功
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddInpoPayOrderDetail(1060)
ClassMethod AddInpoPayOrderDetail(InpoId As %String, OrderId, InterTypeCoce = "HC016")
{
	q:InpoId="" "-2^采购订单ID不能为空"
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	q:OrderId="" "-3^该支付单未上传平台"
	s InputParam="accessToken="_accessToken_"&hospitalId="_hospitalId_"&orderDetailInfo="_"{""list"":["
	s listdata=""
	s RetVal=0,RetMsg=""
	s Chl=""
	f  {
		s Chl=$o(^INPO(InpoId,"POI",Chl)) 
		q:+Chl'>0
		s infpoitmid=InpoId_"||"_Chl
		s inpoitminfo=^INPO(InpoId,"POI",Chl)
		s Inci=$p(inpoitminfo,"^",1)
		q:Inci=""
		s ThirdOrderDetailId=$p(inpoitminfo,"^",20)
		q:ThirdOrderDetailId=""
		s carrstateid=""
		f  {
			s carrstateid=$o(^User.DHCCarrStateI("No",ThirdOrderDetailId,carrstateid))
			q:+carrstateid'>0
			q:'$d(^User.DHCCarrStateD(carrstateid))
			s CarrStateinfo=^User.DHCCarrStateD(carrstateid)
			s distributeId=$lg(CarrStateinfo,4)	//配送明细编号
			q:distributeId=""
			s DetailStr="{""payOrderCode"":"""_OrderId_""",""hospitalOrderDetailId"":"""_infpoitmid_""",""distributeId"":"""_distributeId_"""}"
			if listdata'="" s listdata=listdata_","_DetailStr
	       	else  s listdata=DetailStr
		}
	
	}
	s InputParam=InputParam_listdata_"]}"
	s InputStream=##class(%GlobalCharacterStream).%New()
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	q:ReturnJson.Size=0 "-6^上传明细平台返回值为空"
	d ReturnJson.Rewind()
	//解析返回json
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode   
	s ReturnMsg=ReturnJsonObj.returnMsg  
	q:ReturnMsg="OK" "0^支付单明细上传成功"
	s successList=ReturnJsonObj.successList
	s ListSize=successList.Count()
	q RetVal_"^"_RetMsg
}

/// Part: HC018 物资 SJ017 试剂  提交支付单
/// Creator：wxj
/// CreateDate:2020-12-23
/// Update: lihui 20221123
/// Input:PayId-HIS付款单ID
/// Return:0^成功
/// Debug:w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).SubmitInpoPayOrder(1060)
ClassMethod SubmitInpoPayOrder(OrderId As %String, InterTypeCoce = "HC018")
{
	q:OrderId="" "-1^平台支付单ID为空"
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	
	
	s Data=OrderId
	s Title="payOrderCode"
	s InputParamJosn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	s InputParam="accessToken="_accessToken_"&hospitalId="_hospitalId_"&orderInfo="_InputParamJosn
	s InputStream=##class(%GlobalCharacterStream).%New()
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	q:ReturnJson.Size=0 "-3^提交支付单平台返回值为空"
	d ReturnJson.Rewind()
	//解析返回json
	s ParseJsonSc=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(ReturnJson,"",.ReturnJsonObj,.pCharsProcessed,"2","","0")
	s ReturnCode=ReturnJsonObj.returnCode   
	s ReturnMsg=ReturnJsonObj.returnMsg
	q ReturnCode_"^"_ReturnMsg
}

/// Description：界面显示采购平台支付单明细数据 HC017 物资 SJ016 试剂
/// w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryInpoPayItmInfo(192,1)
ClassMethod JSQueryInpoPayItmInfo(InpoId, Page)
{
	s MRDocFlag=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetMRDocFlag(InpoId,"PO")
	s RetInfo=""
	i MRDocFlag="Y"   {
		s RetInfo=..GetInpoPayDetail(InpoId,Page,"SJ016")
	}else{
		s RetInfo=..GetInpoPayDetail(InpoId,Page,"HC017")
	}
	s RtnObj=""
	i (..#Version="HisUI") s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s RetVal=$p(RetInfo,"^",1)
	s RetMsg=$p(RetInfo,"^",2)
	;i (..#Version="HisUI")&&(RetVal'=0)  d RtnObj.Err(-1,"",RetMsg,"",0) q RtnObj.Json()
	;i (..#Version="Ext")&&(RetVal'=0) q "-1^"_RetMsg
	s Ret=##class(web.DHCSTMService.YGCG.CommonMethod).ParseJSON(RetMsg,"",.JsonObj,.pCharsProcessed,"2","","0")
	;i (..#Version="HisUI")&&(Ret'="1")  d RtnObj.Err(-1,"","Json解析错误","",0) q RtnObj.Json()
	;i (..#Version="Ext")&&(Ret'="1") q "-1^Json解析错误"
	s returnCode=JsonObj.returnCode
	s returnMsg=JsonObj.returnMsg
	;i (..#Version="HisUI")&&(returnCode'="1")  d RtnObj.Err(-1,"",returnMsg,"",0) q RtnObj.Json()
	;i (..#Version="Ext")&&(returnCode'="1") q returnCode_"^"_returnMsg
	s dataList=JsonObj.dataList
	s currentPageNumber=JsonObj.currentPageNumber    ;当前页码
	s totalPageCount=JsonObj.totalPageCount			 ;总页码
	s totalRecordCount=JsonObj.totalRecordCount		 ;总行数
	s Title="orderDetailId^distributeId^orderName^procurecatalogId^realAmount^realQuantity^companyNameSc^companyIdPs^companyNamePs^invoiceId^storageDate^hosIngdNo"
	s Count=dataList.Count()
	;i (..#Version="HisUI")&&(Count'>0)  d RtnObj.Err(-1,"",returnMsg,"",0)  q RtnObj.Json()
	;i (..#Version="Ext")&&(Count'>0) q "-1^"_returnMsg
	s json=..GetJsonObj()
	f i=1:1:Count {
		s getdatalist=dataList.GetAt(i)
		s companyNameSc=getdatalist.companyNameSc   ; 生产企业名称
		s distributeId=getdatalist.distributeId   ; 配送明细编号
		s companyIdPs=getdatalist.companyIdPs   ; 配送企业编号
		s companyNamePs=getdatalist.companyNameSc   ; 配送企业名称
		s storageDate=getdatalist.storageDate    ;收退货日期
		s subDate=$p(storageDate," ",1)
		s subTime=$p(storageDate," ",2)
		s realQuantity=getdatalist.realQuantity	; 结算数量
		s realAmount=getdatalist.realAmount   ; 结算金额
		s procurecatalogId=getdatalist.procurecatalogId	 ; 商品ID
		s orderRemark=getdatalist.orderRemark	;订单备注
		s orderDetailId=getdatalist.orderDetailId		;订单明细编号
		s invoiceId=getdatalist.invoiceId		; 发票号
		s orderName=getdatalist.orderName    ; 
		s hosIngdNo=getdatalist.hosIngdNo    ;
		&sql(SELECT * FROM DHCPaySate WHERE orderDetailId=:orderDetailId)
		i SQLCODE  d
		.&sql(INSERT INTO DHCPaySate  (orderDetailId, distributeId, orderName, procurecatalogId, realAmount, realQuantity,companyNameSc,companyIdPs,companyNamePs,invoiceId,storageDate,hosIngdNo) 
		      VALUES(:orderDetailId, :distributeId, :orderName, :procurecatalogId, :realAmount, :realQuantity,:companyNameSc,:companyIdPs,:companyNamePs,:invoiceId,:storageDate,:hosIngdNo))
		e  d
		.&sql(UPDATE DHCPaySate SET orderDetailId=:orderDetailId,distributeId=:distributeId,orderName=:orderName,procurecatalogId=:procurecatalogId,realAmount=:realAmount,realQuantity=:realQuantity,companyNameSc=:companyNameSc,companyIdPs=:companyIdPs,companyNamePs=:companyNamePs,invoiceId=:invoiceId,storageDate=:storageDate,hosIngdNo=:hosIngdNo where  orderDetailId=:orderDetailID)
		s Data=orderDetailId_"^"_distributeId_"^"_orderName_"^"_procurecatalogId_"^"_realAmount_"^"_realQuantity_"^"_companyNameSc_"^"_companyIdPs_"^"_companyNamePs_"^"_invoiceId_"^"_storageDate_"^"_hosIngdNo
		d json.InsertRowData(Data)
	}
	i ..#Version="Ext"  d
	.s JsonStr=json.getJsonData(Title,totalRecordCount)
	e  d
	.s JsonStr=""
	.d json.getJsonData(Title,totalRecordCount)
	k json 
	q JsonStr
}

/// Part:   HC017 物资 SJ016 试剂 获取支付单明细信息
/// Creator：wxj
/// CreateDate:2020-12-22
/// Up: 20221123 lihui
/// Input: PoId-HIS订单ID,currentPageNumber-指定页码, InterTypeCoce(HC017 物资 SJ016 试剂)
/// Return: 0-成功
/// Debug: w ##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetOrderDetail(54183,1)
ClassMethod GetInpoPayDetail(InpoId As %String, currentPageNumber As %String = "1", InterTypeCoce = "HC010") As %String
{
	s tokenStr=..GetToken()
	s tokenStatus=$p(tokenStr,"^",1)
	q:(tokenStatus'=1)&&(tokenStatus'=9) "-1^获取令牌失败"
	s accessToken=$p(tokenStr,"^",3)
	s hospitalId=$p(tokenStr,"^",7)
	s startTime=""
	s endTime=""
	s InputStream=##class(%GlobalCharacterStream).%New()
	s InputParam="accessToken="_accessToken_"&startTime="_startTime_"&endTime="_endTime_"&hospitalId="_hospitalId_"&currentPageNumber="_currentPageNumber_"&params="_"{""list"":["
	s listdata=""
	s Chl=""
	f  {
		s Chl=$o(^INPO(InpoId,"POI",Chl)) 
		q:+Chl'>0
		s infpoitmid=InpoId_"||"_Chl
		s inpoitminfo=^INPO(InpoId,"POI",Chl)
		s Inci=$p(inpoitminfo,"^",1)
		q:Inci=""
		s ThirdOrderDetailId=$p(inpoitminfo,"^",20)
		q:ThirdOrderDetailId=""
		s carrstateid=""
		f  {
			s carrstateid=$o(^User.DHCCarrStateI("No",ThirdOrderDetailId,carrstateid))
			q:+carrstateid'>0
			q:'$d(^User.DHCCarrStateD(carrstateid))
			s CarrStateinfo=^User.DHCCarrStateD(carrstateid)
			s distributeId=$lg(CarrStateinfo,4)	//配送明细编号
			q:distributeId=""
			s Data=distributeId
			s Title="distributeId"
			s Inputjson=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
			if listdata'="" s listdata=listdata_","_Inputjson
			else  s listdata=Inputjson
		}
		
	}
	q:listdata="" "-2^明细不能为空"
	s InputParam=InputParam_listdata_"]}"
	d InputStream.Write(InputParam)
	s ReturnJson=..SendData(InterTypeCoce,InputStream)
	s ReturnJsonStr=ReturnJson.Read()
	q 0_"^"_ReturnJsonStr
}

}

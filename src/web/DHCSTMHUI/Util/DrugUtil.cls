Import sqluser

/// Descript:药品信息等Store的取法
/// 在dhcst.drugutil.csp,dhcst.phaorderwindow.csp中调用
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-07
Class web.DHCSTMHUI.Util.DrugUtil Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   取符合条件的库存项信息
/// Creater:    zhangyong
/// CreateDate: 2010-11-04
/// Input:      Start,Limit,Sort,Dir,StrParam(拼接如下)
/// 			input-库存项别名^StkGrpRowId-类组RowId^StkGrpType-类组类型^Locdr-Ctloc_rowid^NotUseFlag("N"或"Y")
/// 			^QtyFlag("1"则只显示正库存)^HospID^Start^Limit^User
/// 			^StkCat^toLoc^ReqModeLimited(植入标志)^NoLocReq(禁止请领标志)^spec
/// 			^rp^brand(品牌)^sLoc^Vendor^HV(Y:仅高值,N:仅低值,"":所有)^是否请领零库存
/// Output:     Return
/// Return：
/// Modify by:zdm,2012-02-04,优化查询速度,不用表连接
/// 2016-07-18 wangjiabin: 过滤与取值分开处理,优化速度
/// d ##class(web.DHCSTMHUI.Util.DrugUtil).GetPhaOrderItemInfo("1","15","","","{""StkGrpRowId"":""1"",""StkGrpType"":""M"",""Locdr"":"""",""NotUseFlag"":""N"",""QtyFlag"":""0"",""ToLoc"":"""",""ReqModeLimited"":"""",""NoLocReq"":"""",""Vendor"":"""",""HV"":""N"",""gUserId"":""13740"",""gLocId"":""163"",""gGroupId"":""98"",""gHospId"":""2"",""MENUID"":""57765"",""Spec"":"""",""Brand"":"""",""Rp"":""""}","ycx")
ClassMethod GetPhaOrderItemInfo(page, rows, sort, order, StrParam, q) As %Library.String
{
	n (page,rows,sort,order,StrParam,q,%session)
	s Start=(page-1)*rows
	s Limit=rows
	s Sort=sort
	s Dir=order
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(StrParam)
	s StkGrpRowId=PJObj.%Get("StkGrpRowId")
	s StkGrpType=PJObj.%Get("StkGrpType")
	s Locdr=PJObj.%Get("Locdr")
	s NotUseFlag=PJObj.%Get("NotUseFlag")
	s QtyFlag=PJObj.%Get("QtyFlag")
	s gHospID=PJObj.%Get("gHospId")
	s HospID=PJObj.%Get("BDPHospital")
	s HospID=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(HospID,gHospID)
	s User=PJObj.%Get("gUserId")
	s StkCat=PJObj.%Get("StkCat")
	s toLoc=PJObj.%Get("ToLoc")
	s ReqModeLimited=PJObj.%Get("ReqModeLimited")
	s NoLocReq=PJObj.%Get("NoLocReq")
	s spec=PJObj.%Get("Spec")
	s rp=PJObj.%Get("Rp")
	s brand=PJObj.%Get("Brand")
	s sLoc=PJObj.%Get("gLocId")
	s Vendor=PJObj.%Get("Vendor")
	s HV=PJObj.%Get("HV")
	s RequestNoStock=PJObj.%Get("RequestNoStock")
	s BarCode=PJObj.%Get("BarCode")
	s PInciId=PJObj.%Get("InciId")
	s QueryFlag=PJObj.%Get("QueryFlag")
	s GroupId=PJObj.%Get("gGroupId")
	s ChargeFlag=PJObj.%Get("ChargeFlag")
	s PackChargeFlag=PJObj.%Get("PackChargeFlag")
	s SeachAllFlag=PJObj.%Get("SeachAllFlag")	//可不输入关键信息查询
	s ReqType=PJObj.%Get("ReqType")	//库存请求页面如果单据类型是"申领计划",则不受QtyFlag的影响,不判断库存是否为0
	s InclbVendor=PJObj.%Get("InclbVendor")
	s UpperBarCode=$$ALPHAUP^SSUTIL4(BarCode)
	i (HospID'=gHospID) d
	.s User=""
	.s sLoc=""
	.s GroupId=""
	
	s Input=q
	i (SeachAllFlag'="Y")&&((StkCat="")&&(BarCode="")&&(PInciId=""))&&(Input="") w $$$NullJson q ""
	i StkGrpType="" w $$$NullJson q ""		;类组类型不能为空
	
	s ToLocId=$s(toLoc'="":toLoc,1:sLoc)	;toLoc不为空的,再使用sLoc
	s pHospID=..sssHospId(ToLocId)
	s:pHospID="" pHospID=HospID
	s TmpScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(User,StkGrpType,Locdr,StkGrpRowId,pHospID)
	;取供应方权限,再和ScgStr取交集
	i ToLocId'="" d
	.s xLocScgStr=..GetAuthorOnlyScg(ToLocId_"^",StkGrpType)
	.;s xLocScgStr=""
	.i xLocScgStr="" s ScgStr=TmpScgStr quit
	.s ScgStr=""
	.f i=1:1:$l(TmpScgStr,"^") d
	..s TmpScg=$p(TmpScgStr,"^",i)
	..i (","_xLocScgStr_",")[(","_TmpScg_",") d
	...i ScgStr="" s ScgStr=TmpScg
	...e  s ScgStr=ScgStr_"^"_TmpScg
	e  d
	.s ScgStr=TmpScgStr
	
	s IncscStr=$$GetIncscStr(ScgStr)
	
	s Input="%"_$$ALPHAUP^SSUTIL4(Input)_"%"
	s sqlStr = ""
	if (UpperBarCode'="") {
		s (TmpInci,Inci)=""
		f  s TmpInci=$o(^INCI(0,"BarCode",UpperBarCode,TmpInci)) q:(TmpInci="")||(Inci'="")  d
		.q:'$d(^INCI(TmpInci,1))
		.s InciBarCode=$p(^INCI(TmpInci,3),"^",9)
		.i InciBarCode=BarCode s Inci=TmpInci q
		i Inci="" w $$$NullJson q ""
		s sqlStr ="select inci_rowid as InciId from inc_itm where INCI_RowId="_Inci
	} elseif (StkCat'="") {
		s sqlStr ="select inci_rowid as InciId from inc_itm where inci_incsc_dr="_StkCat
		if (Input'="") {
			s sqlStr="select distinct inca_inci_dr as InciId from inc_alias"
				_" where inca_inci_dr->inci_incsc_dr="_StkCat
				_" and %ALPHAUP(inca_text) like '"_Input_"'"
		}
	} elseif (QueryFlag="InciCode") {
		s sqlStr ="select inci_rowid as InciId from inc_itm where INCI_Code like '"_Input_"'"
	} elseif (PInciId'="") {
		s sqlStr ="select inci_rowid as InciId from inc_itm where INCI_RowId ="_PInciId
	} else {
		s sqlStr ="select distinct inca_inci_dr as InciId from inc_alias "
			_" where %ALPHAUP(inca_text) like '"_Input_"' or %ALPHAUP(inca_inci_dr->INCI_Desc) like '"_Input_"' "
	}
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) q ""
	s defaRp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTDRUGMAINTAINM","ItmQueryDefaRp","")
	s Pid=..NewPid()
	k ^TMPDHCSTM(Pid,"ItemInfo")
	s Num=0
	i toLoc'="" s Sort="ReqFre"
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{
		s InciDr = result.Data("InciId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("AppTable"),InciDr,HospID)
		CONTINUE:ShowDataFlag="N"
		CONTINUE:(InciDr="")||'$D(^INCI(InciDr))
		s inccat=$p(^INCI(InciDr,2),"^",2)
		CONTINUE:(inccat="")||((","_IncscStr_",")'[(","_inccat_","))
		i (HV'="") d
		.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciDr)
		continue:(HV'="")&&(HVFlag'=HV)
		;科室
		I (Locdr'="") {
			i (RequestNoStock="N"){
				CONTINUE:'$D(^INCI("IL_LOC",Locdr,InciDr))
			}
		}
		;请求制单时判断此请求科室是否可以申请该物资
		s ret="Y"
		I (toLoc'="")&&(Locdr'="") d
		.s ret=..CheckToLoc(InciDr,Locdr,toLoc)
		CONTINUE:ret'="Y"
		;是否使用
		I (NotUseFlag'="") {
			CONTINUE:(($P(^INCI(InciDr,2),"^",9)'="")&&(NotUseFlag'=$P(^INCI(InciDr,2),"^",9)))
		}
		;请求方式
		I (ReqModeLimited'="") {
			s add=$o(^DHCITMINFO(0,"INCI",InciDr,""))
			CONTINUE:add=""
			s reqmodeLimited=$P(^DHCITMINFO((add)),"^",73)
			CONTINUE:(reqmodeLimited'="")&&(ReqModeLimited'=reqmodeLimited)
		}
		;是否禁止请领
		I (NoLocReq'="") {
			s noLocReq=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncNoLocReq(InciDr)
			CONTINUE:NoLocReq'=noLocReq
		}
		;取当前库存量
		i ((QtyFlag="1")&&(Locdr'="")&&(ReqType'="C")) {
			S BuomQty=##Class(web.DHCSTMHUI.Common.DrugStkCommon).IL(InciDr,Locdr,+$H)
			CONTINUE:(BuomQty'>0)
		}
		i (spec'="")||(Sort="Spec") d
		.S Spec=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciDr) 
		CONTINUE:(spec'="")&&(Spec'[spec)
		i (brand'="")||(Sort="Brand") d
		.s Brand=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(InciDr)
		CONTINUE:(brand'="")&&(Brand'[brand)
		i (Vendor'="") d
		.s pbvendor=$P(##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(InciDr),"^",1)
		CONTINUE:(Vendor'="")&&(pbvendor'="")&&(Vendor'=pbvendor)
		i (InclbVendor'="")  d
		.s LastVendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetLastVen(InciDr,Locdr)
		.s LastVendId=$p(LastVendorInfo,"^",1)
		.s LastVenDesc=$p(LastVendorInfo,"^",2)
		CONTINUE:(InclbVendor'="")&&(InclbVendor'=LastVendId)
		
		S PuomDr=$P(^INCI(InciDr,3),"^",6)					//入库单位ID
		i (+rp'=0)||(Sort="PRp") {
			s pRp=##class(web.DHCSTMHUI.DrugInfoMaintain).Rp(InciDr,PuomDr,HospID,defaRp)
			CONTINUE:(+rp'=0)&&(+rp'=+pRp)
		}
		s ARCIMDR=$P(^INCI(InciDr,1),"^",3)
		continue:(ChargeFlag="Y")&&(ARCIMDR="")
		continue:(ChargeFlag="N")&&(ARCIMDR'="")
		s tmpPackChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPackChargeFlag(InciDr)
		continue:(PackChargeFlag="Y")&&(tmpPackChargeFlag'="Y")
		continue:(PackChargeFlag="N")&&(tmpPackChargeFlag="Y")
		i Sort="ManfName" d
		.s ManfInfo=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(InciDr)
		.s ManfName=$p(ManfInfo,"^",3)
		
		s Num = Num+1
		s Sub=""
		i (Sort="ReqFre") d
		.s ReqFre=0,incil="",dhcincil=""
		.s incil=$O(^INCI("IL_LOC",toLoc,InciDr,""))
		.s:incil'="" dhcincil=$O(^DHCINCIL("INCIL",incil,""))
		.s:dhcincil'="" ReqFre=+$P(^DHCINCIL(dhcincil),"^",27)
		.s Sub=ReqFre
		e  i Sort="Spec" d
		.s Sub=Spec
		e  i Sort="Brand" d
		.s Sub=Brand
		e  i Sort="PRp" d
		.s Sub=pRp
		e  i Sort="ManfName" d
		.s Sub=ManfName
		e  d
		.s Sub=InciDr
		
		s:Sub="" Sub="*"
		s ^TMPDHCSTM(Pid,"ItemInfo",Sub,Num)=InciDr
	}
	
	s count=0
	s end = Start+Limit
	s DirFlag=$s(Dir="asc":1,1:-1)
	s Sub=""
	f  s Sub=$O(^TMPDHCSTM(Pid,"ItemInfo",Sub),DirFlag) q:Sub=""  d
	.s Num=""
	.f  s Num=$O(^TMPDHCSTM(Pid,"ItemInfo",Sub,Num),DirFlag) q:Num=""  d
	..s count=count+1
	..q:count<(Start+1)
	..q:count>end
	..
	..s InciDr=$p(^TMPDHCSTM(Pid,"ItemInfo",Sub,Num),"^",1)
	..s InciInfo=$$GetInciDetail(InciDr)
	..d json.InsertRowData(InciInfo)
	k ^TMPDHCSTM(Pid,"ItemInfo")
	d result.Close()
	s TitleStr="InciDr^InciItem^InciCode^InciDesc^Spec"
		_"^ManfName^PUomDr^PUomDesc^PRp:number^PSp:number"
		_"^PUomQty:number^BUomDr^BUomDesc^BRp:number^BSp:number"
		_"^BUomQty:number^BillUomDesc^BillRp:number^BillSp:number^BillUomQty:number"
		_"^NotUseFlag^PFac:number^HVFlag^ProvLoc^Remarks"
		_"^WarrentNo^WnoDate^ARCDesc^ZeroStkFlag^PbRp:number"
		_"^CertNo^CertExpDate^ReqPuomQty:number^Brand^Model"
		_"^GrpId^GrpDesc^ProvLocId^Incil^Manfdr"
		_"^PbVendorId^PbVendorDesc^BatchReq^ExpReq^PUomAvaQty:number"
		_"^BatchCodeFlag^BUomAvaQty:number^ReqBuomQty:number^TableFlag^MatInsuCode^MatInsuDesc"
	d json.getJsonData(TitleStr,count)
	k json
	q ""

GetIncscStr(ScgStr)
	n (ScgStr)
	q:ScgStr="" ""
	s IncscStr=""
	s ScgLen=$l(ScgStr,"^")
	f i=1:1:ScgLen d
	.s Scg=$p(ScgStr,"^",i)
	.s ch=""
	.f  s ch=$o(^DHCSCG(Scg,"RE",ch)) q:ch=""  d
	..s Incsc=$p(^DHCSCG(Scg,"RE",ch),"^",1)
	..i IncscStr="" s IncscStr=Incsc
	..e  s IncscStr=IncscStr_","_Incsc
	q IncscStr
GetInciDetail(InciDr)
	q:'$D(^INCI(InciDr)) ""
	S InciItem=$P(^INCI(InciDr,1),"^",3)				//arcim
	S InciCode=$P(^INCI(InciDr,1),"^",1)
	S InciDesc=$P(^INCI(InciDr,1),"^",2)
	s BatchReq=$p(^INCI(InciDr,2),"^",10)
	s ExpReq=$p(^INCI(InciDr,2),"^",11)
	S Spec=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciDr)
	S Model=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(InciDr)
	s Brand=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(InciDr)
	s pbvendor=$P(##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(InciDr),"^",1)
	S ManfStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(InciDr)
	S Manfdr=$P(ManfStr,"^",1)
	S ManfCode=$P(ManfStr,"^",2)
	S ManfName=$P(ManfStr,"^",3)
	//入库单位
	S PuomDr=$P(^INCI(InciDr,3),"^",6)
	S PuomDesc=$s(PuomDr'="":$P(^CT("UOM",PuomDr),"^",2),1:"")
	s pRp=##class(web.DHCSTMHUI.DrugInfoMaintain).Rp(InciDr,PuomDr,HospID,defaRp)
	S pSp=##Class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciDr,+$H,PuomDr,HospID)
	//基本单位
	S BuomStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncBuom(InciDr)
	S BuomDr=$P(BuomStr,"^",1)
	S BuomDesc=$P(BuomStr,"^",2)
	s bRp=##class(web.DHCSTMHUI.DrugInfoMaintain).Rp(InciDr,BuomDr,HospID,defaRp)
	S bSp=##Class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciDr,+$H,BuomDr,HospID)
	
	s ifexitbatadjpricestr=##class(web.DHCSTMHUI.Common.PriceCommon).IfExitBatAdjprice(InciDr)
	s ifexitbatadjprice=$p(ifexitbatadjpricestr,"^",1)
	s batflag=$p(ifexitbatadjpricestr,"^",2)
	if ((ifexitbatadjprice'="Y")&&(batflag=1)&&(defaRp'=3)) d  ;批次售价且无批次信息且进价不是取招标进价
	.s aspInfo=##class(web.DHCSTMHUI.INCITM).GetINCPrice(InciDr,+$h,PuomDr,"")  //直接获取当前进价售价(取自调价表)20170422
	.s pRp=$p(aspInfo,"^",1)
	.s pSp=$p(aspInfo,"^",2)
	.s buomaspInfo=##class(web.DHCSTMHUI.INCITM).GetINCPrice(InciDr,+$h,BuomDr,"")  //直接获取当前进价售价(取自调价表)20170422
	.s bRp=$p(buomaspInfo,"^",1)
	.s bSp=$p(buomaspInfo,"^",2)
	//账单单位
	s BillUomStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcBuomByInc(InciDr)
	s BillUomDr=$P(BillUomStr,"^",1)
	s BillUomDesc=$P(BillUomStr,"^",2)
	s BillRp=##Class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(InciDr,BillUomDr,HospID)
	s BillSp=##Class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciDr,+$H,BillUomDr,HospID)
	s BuomQty=0,Incil="",BUomAvaQty=0
	i (Locdr'="") d
	.s IL=$o(^INCI("IL_LOC",Locdr,InciDr,""))
	.s:IL'="" Incil=InciDr_"||"_IL
	.s BuomQty=##Class(web.DHCSTMHUI.Common.DrugStkCommon).IL(InciDr,Locdr,+$H)	//基本单位数量
	.s BUomAvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurItmAvaQtyB(Incil,BuomDr)
	s PFac=##Class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PuomDr,BuomDr)
	s PuomQty=$s(PFac'=0:BuomQty/PFac,1:"")				//入库单位数量
	s PUomAvaQty=$s(PFac'=0:BUomAvaQty/PFac,1:"")
	s BillFac=##Class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PuomDr,BuomDr)
	s BillUomQty=$s(BillFac'="":BuomQty/BillFac,1:"")	//账单单位数量
	s NotUse=$P(^INCI(InciDr,2),"^",9)					//是否使用
	s NotUse=$s(NotUse="Y":1,1:0)
	s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciDr)
	s (remarks,ARCDesc)=""
	&sql(select inci_remarks,INCI_OriginalARCIM_DR->ARCIM_Desc into :remarks,:ARCDesc
		from inc_itm where inci_rowid=:InciDr)
	s remarks=$lts(remarks)
	//取供应科室
	s provLoc=$P(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetprovLoc(InciDr,toLoc),"^",2)
	s provLocid=$P(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetprovLoc(InciDr,toLoc),"^",1)
	;物价文件号
	s WarrentNo="",WnoDate=""
	&sql(select INFO_PrcFile,INFO_PrcFileD into :WarrentNo,:WnoDate from DHC_ItmAddionInfo where INFO_INCI_DR=:InciDr)
	s:WnoDate'="" WnoDate=..DL2H(WnoDate)
	s ZeroStkFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetZeroStkFlag(InciDr,Locdr)     
	s PbRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPbRp(InciDr,PuomDr)
	s cert=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(InciDr)
	s CertNo=$p(cert,"^",1)
	s CertExpDate=$p(cert,"^",2)
	s (reqPuomQty,reqBuomQty)=0
	i (toLoc'="") d
	.s reqBuomQty=##Class(web.DHCSTMHUI.Common.DrugStkCommon).IL(InciDr,toLoc,+$H)      //请求科室基本单位数量
	s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciDr)
	s:StkGrpInfo'="" GrpId=$p(StkGrpInfo,"^",5)
	s:StkGrpInfo'="" GrpDesc=$p(StkGrpInfo,"^",2)
	i PFac'=0 s reqPuomQty=reqBuomQty/PFac				//请求科室入库单位数量
	s PbVendorInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(InciDr)
	s PbVendorId=$p(PbVendorInfo,"^",1)
	s PbVendorDesc=$p(PbVendorInfo,"^",2)
	s AppName="DHCSTCOMMONM"	//生产厂家按类组授权过滤
	s Param=GroupId_"^"_sLoc_"^"_User_"^"_HospID
	s ManfScg=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"ManfScg",Param)
	i ManfScg="Y" d
	.&sql(SELECT * FROM DHC_ManfCatGroup WHERE MCG_MANF_Dr=:Manfdr AND MCG_SCG_Dr=:GrpId AND MCG_UseFlag='Y')
	.i SQLCODE'=0 d
	..s Manfdr="",ManfCode="",ManfName=""
	s BatchCodeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBatchCodeFlag(InciDr)
	s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(InciDr)
	s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(InciDr,HospID)
	s MatInsuCode=$p(MatInsuInfo,"^",1)
	s MatInsuDesc=$p(MatInsuInfo,"^",2)
	s InciInfo=InciDr_"^"_InciItem_"^"_InciCode_"^"_InciDesc_"^"_Spec
		_"^"_ManfName_"^"_PuomDr_"^"_PuomDesc_"^"_pRp_"^"_pSp
		_"^"_PuomQty_"^"_BuomDr_"^"_BuomDesc_"^"_bRp_"^"_bSp
		_"^"_BuomQty_"^"_BillUomDesc_"^"_BillRp_"^"_BillSp_"^"_BillUomQty
		_"^"_NotUse_"^"_PFac_"^"_HVFlag_"^"_provLoc_"^"_remarks
		_"^"_WarrentNo_"^"_WnoDate_"^"_ARCDesc_"^"_ZeroStkFlag_"^"_PbRp
		_"^"_CertNo_"^"_CertExpDate_"^"_reqPuomQty_"^"_Brand_"^"_Model
		_"^"_GrpId_"^"_GrpDesc_"^"_provLocid_"^"_Incil_"^"_Manfdr
		_"^"_PbVendorId_"^"_PbVendorDesc_"^"_BatchReq_"^"_ExpReq_"^"_PUomAvaQty
		_"^"_BatchCodeFlag_"^"_BUomAvaQty_"^"_reqBuomQty_"^"_TableFlag_"^"_MatInsuCode
		_"^"_MatInsuDesc
	
	q InciInfo
}

/// 验证请求科室是否可以申请该物资
/// Y-可以	其它-不可以
/// w ##class(web.DHCSTMHUI.Util.DrugUtil).CheckToLoc(2057,163,1)
ClassMethod CheckToLoc(Inci As %String, frLoc As %String, toLoc As %String) As %String
{
	n (Inci,frLoc,toLoc)
	s Ret="N"
	&sql(select RFU_RowId  into :rowid  from DHC_RefuseReqLocItm  where RFU_INCI_DR=:Inci AND RFU_UseFlag="Y")
	q:rowid="" "Y"	//若库存项"限制请领"未配置或无有效配置，默认可申领
	s RFReqId=""
	f  s RFReqId=$o(^DHCRFUREQ(0,"FTI",frLoc,toLoc,Inci,RFReqId)) q:(RFReqId="")||(Ret="Y")  d
	.s DateFrom=$p(^DHCRFUREQ(RFReqId),"^",4)
	.s DateTo=$p(^DHCRFUREQ(RFReqId),"^",5)
	.s Useflag=$p(^DHCRFUREQ(RFReqId),"^",7)
	.q:Useflag'="Y"
	.q:(DateFrom'="")&&(DateFrom>+$h)
	.q:(DateTo'="")&&(DateTo<+$h)
	.s Ret="Y"
	q Ret
}

/// description:获取类组是否在权限内
/// date:		2017-08-28
/// creator:	wangjiabin
/// input:		StrParam(科室^人员^第二科室^类组集合^...), 类组类型(M/O等,缺省为M), 要判断的类组id
/// output:		Y:在权限内, N:不在权限内
/// w ##class(web.DHCSTMHUI.Util.DrugUtil).IsScgAuthor("153","M",6)
ClassMethod IsScgAuthor(StrParam As %String, Type As %String, SCG As %String) As %String
{
	n (StrParam,Type,SCG)
	s LocId=$p(StrParam,"^",1)
	s UserId=$p(StrParam,"^",2)
	s xLocId=$p(StrParam,"^",3)
	s ScgSet=$p(StrParam,"^",4)
	s:Type="" Type=..sssCode()
	
	s ScgStr=""
	s Param=LocId_"^"_UserId
	s TmpScgStr=..GetAuthorOnlyScg(Param,Type)	;仅显示有权限的类组
	;若未授权,取所有类组
	s:TmpScgStr="" TmpScgStr=$$GetAllScgString(Type)
	
	i xLocId'="" d
	.s xLocScgStr=..GetAuthorOnlyScg(xLocId_"^",Type)
	.s:xLocScgStr="" xLocScgStr=$$GetAllScgString(Type)
	.f i=1:1:$l(TmpScgStr,",") d
	..s TmpScg=$p(TmpScgStr,",",i)
	..i (","_xLocScgStr_",")[(","_TmpScg_",") d
	...i ScgStr="" s ScgStr=TmpScg
	...e  s ScgStr=ScgStr_","_TmpScg
	e  d
	.s ScgStr=TmpScgStr
	
	q:(ScgStr="")||((","_ScgStr_",")'[(","_SCG_",")) "N"
	q "Y"
	
GetAllScgString(Type)
	n (Type)
	s AllScgStr=""
	s ScgId=0
	f  s ScgId=$o(^DHCSCG(ScgId)) q:ScgId=""  d
	.q:(+ScgId'>0)||'$d(^DHCSCG(ScgId))
	.s ScgType=$p($G(^DHCSCG(ScgId)),"^",3)
	.q:ScgType'=Type
	.q:('$d(^DHCSCG(ScgId,"RE"))&&('$d(^DHCSCG(0,"Parent",ScgId))))		;未关联库存分类的,过滤
	.i AllScgStr="" d
	..s AllScgStr=ScgId
	.e  d
	..s AllScgStr=AllScgStr_","_ScgId
	q AllScgStr
}

/// Descript:	根据科室和药品库存项查询物资的批次列表
/// Creator:	wangjiabin
/// CreateDate:	2018-05-19
/// Input:库存项id,供应科室id,请求科室id,开始行，一页显示记录数       
/// Output:     
/// Return：批次RowID^批次/效期^生产厂家^批次库存^包装单位^售价^  
/// 请求数量^基本单位^进价^库位^供应方库存^请求方库存^入库日期
/// 包装单位id^基本单位id^包装单位和基本单位的转换率^批次占用库存^批次可用库存^批次售价
/// Modify:2013-01-22,公共批次窗口调用
/// wangjiabin 2013-10-11 添加inclb参数(缺省为空),用于高值材料转移时取特定批次信息
/// w ##class(web.DHCSTMHUI.Util.DrugUtil).GetDrugBatInfo(1,15,"","","{""InciDr"":""948"",""ProLocId"":"""",""ReqLocId"":"""",""QtyFlag"":0}")
ClassMethod GetDrugBatInfo(page, rows, sort, order, Params) As %Library.String
{
	n (page,rows,sort,order,Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 ""
	s InciDr=PJObj.%Get("InciDr")
	s ProLocId=PJObj.%Get("ProLocId")
	s ReqLocId=PJObj.%Get("ReqLocId")
	s QtyFlag=PJObj.%Get("QtyFlag")
	s Inclb=PJObj.%Get("Inclb")
	s PBatchNo=PJObj.%Get("BatchNo")
	s PExpDate=PJObj.%Get("ExpDate")
	s PExpDate=..DH2L(PExpDate)
	q:ProLocId="" ""
	q:InciDr="" ""
	s Start=(page-1)*rows
	s Limit=rows
	s end = Start+Limit
	s pid=..NewPid()
	k ^TMPDHCSTMBAT(pid,"DrugUtil")
	
	s InciCode=$p(^INCI(InciDr,1),"^",1)
	s InciDesc=$p(^INCI(InciDr,1),"^",2)
	s count = 0
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s chl=0
	f  s chl=$o(^INCI("IL_LOC",ProLocId,InciDr,chl)) q:chl=""  d
	.s lb=0
	.f  s lb=$o(^INCI(InciDr,"IL",chl,"LB",lb))  q:lb=""  d
	..s RowId =InciDr_"||"_chl_"||"_lb
	..q:(Inclb'="")&(RowId'=Inclb)
	..s IncibRowId =$p(^INCI(InciDr,"IL",chl,"LB",lb),"^",1)
	..s IncilRowId =InciDr_"||"_chl
	..s BatNo=$p(^INCI(+IncibRowId,"IB",$p(IncibRowId,"||",2)),"^",1)
	..q:(PBatchNo'="")&&(PBatchNo'=BatNo)
	..s ExpDate=$p(^INCI(+IncibRowId,"IB",$p(IncibRowId,"||",2)),"^",2)
	..q:(PExpDate'="")&&(PExpDate'=ExpDate)
	..s RecallFlag=$p(^INCI(+IncibRowId,"IB",$p(IncibRowId,"||",2)),"^",3)
	..s ExpDateLogical=$s(ExpDate'="":ExpDate,1:"*")
	..s:ExpDate'="" ExpDate=..DL2H(ExpDate)
	..s BatExp = BatNo_"~"_ExpDate
	..s SterilizedBat=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSterilizedBatByInclb(RowId)
	..s Manf = ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(RowId)
	..s ManfDr=$P(Manf,"^",1)
	..s ManfName=$P(Manf,"^",2)
	..s BUomId=$p(^INCI(InciDr,1),"^",10)
	..q:BUomId=""
	..s BUomDesc="",PurUomDesc=""
	..s BUomDesc=$p($g(^CT("UOM",BUomId)),"^",2)
	..s PurUomId=$p(^INCI(InciDr,3),"^",6)
	..q:PurUomId=""
	..s PurUomDesc=$p($g(^CT("UOM",PurUomId)),"^",2)
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciDr)
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciDr)
	..
	..//出库等操作:高值扫码(此时传入Inclb)时,高值直接用基本单位
	..i (HVFlag="Y")&&(Inclb'="") d
	...s PurUomId=BUomId
	...s PurUomDesc=BUomDesc
	..
	..s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(+PurUomId,+BUomId)
	..s InclbQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(RowId,+$h,PurUomId)
	..q:(QtyFlag=1)&(InclbQty<=0)
	..S InitQty = 0
	..s Date = $P($H, ",", 1)
	..S HospID=$P(^CTLOC(ProLocId),"^",22)
	..
	..s BatSpFlag=..sssBatSpFlag(HospID,InciDr)
	..i BatSpFlag="1" d //批次价格
	...s RetStr=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByIncib(IncibRowId,+$h,PurUomId,HospID,"")
	...s Sp=$p(RetStr,"^",2)
	...s Rp=$p(RetStr,"^",1)
	..e  d
	...s Rp = ##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(RowId,PurUomId,HospID)
	...s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciDr,+$h,PurUomId,HospID)
	..S ReqQty = 0
	..s StkBin=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(ProLocId,InciDr)
	..s StkBin=$p(StkBin,"^",1)
	..s DirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(RowId,PurUomId)
	..s ResveredQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbReservedQty(RowId,PurUomId)
	..s AvaQty = InclbQty - DirtyQty - ResveredQty
	..s SupplyStockQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(InciDr,ProLocId,PurUomId,Date)
	..s SupplyAvaStockQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(ProLocId,InciDr,PurUomId) ;物资可用库存
	..s RequrstStockQty=0
	..S:ReqLocId'="" RequrstStockQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(InciDr,ReqLocId,PurUomId,Date)
	..s IngrId="",dah=+$h,INGR=""
	..f  s INGR=$o(^DHCINGR(0,"GRI_INCIB",IncibRowId,INGR),-1)  q:(IngrId'="")!(INGR="")   d
	...s grdate=$p(^DHCINGR(INGR),"^",4)
	...s:grdate'>dah IngrId=INGR
	..s IngrDate=""
	..i IngrId'="" d
	...s IngrDate=$p(^DHCINGR(+IngrId),"^",4)
	...s:IngrDate'="" IngrDate=..DL2H(IngrDate)
	..s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(RowId)
	..s Vendor=$p(VendorInfo,"^",1)
	..s VendorName=$p(VendorInfo,"^",2)
	..s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(RowId)
	..s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(InciDr,HospID)
	..s MatInsuCode=$p(MatInsuInfo,"^",1)
	..s MatInsuDesc=$p(MatInsuInfo,"^",2)
	..s count = count+1
	..s sub=""
	..i sort="BatExp" d
	...s sub=ExpDateLogical
	..e  d
	...s sub=lb
	..s tmp1=RowId_"^"_BatExp_"^"_ManfName_"^"_InclbQty_"^"_PurUomDesc_"^"_Sp_"^"_ReqQty_"^"_BUomDesc_"^"_Rp_"^"_StkBin
	..s tmp2=SupplyStockQty_"^"_RequrstStockQty_"^"_IngrDate_"^"_PurUomId_"^"_BUomId_"^"_ConFac_"^"_DirtyQty_"^"_AvaQty_"^"_HVFlag
	..s tmp3=SupplyAvaStockQty_"^"_RecallFlag_"^"_Vendor_"^"_VendorName_"^"_SterilizedBat_"^"_SpecDesc_"^"_InciCode_"^"_InciDesc
	..s tmp4=MatInsuCode_"^"_MatInsuDesc_"^"_Spec
	..s tmp=tmp1_"^"_tmp2_"^"_tmp3_"^"_tmp4
	..s ^TMPDHCSTMBAT(pid,"DrugUtil",sub,count)=tmp
	s order=$$ALPHAUP^SSUTIL4(order)
	s:order="" order="ASC"
	s orderFlag=$s(order="ASC":1,1:-1)
	s count=0
	s sub=""
	f  s sub=$o(^TMPDHCSTMBAT(pid,"DrugUtil",sub),orderFlag) q:sub=""  d
	.s ch1=""
	.f  s ch1=$o(^TMPDHCSTMBAT(pid,"DrugUtil",sub,ch1)) q:ch1=""  d
	..s tmp=^TMPDHCSTMBAT(pid,"DrugUtil",sub,ch1)
	..s count=count+1
	..i (count>Start)&(count<=end) d
	...d json.InsertRowData(tmp)
	..
	.
	s Title="Inclb^BatExp^Manf^InclbQty:number^PurUomDesc^Sp:number^ReqQty:number^BUomDesc^Rp:number^StkBin"
		_"^SupplyStockQty:number^RequrstStockQty:number^IngrDate^PurUomId^BUomId^ConFac:number^DirtyQty:number^AvaQty:number^HVFlag"
		_"^SupplyAvaStockQty:number^RecallFlag^Vendor^VendorName^SterilizedBat^SpecDesc^InciCode^InciDesc^MatInsuCode"
		_"^MatInsuDesc^Spec"
	k ^TMPDHCSTMBAT(pid,"DrugUtil")
	d json.getJsonData(Title,count)
	k json
	q ""
}

/// Description:新建类组或库存分类
/// 	2016-03-10 重写GetUserCatGrpStr,根据参数调用DHC_StkLocCatGroup或DHC_StkLocStkCat
/// 	添加scg参数(缺省为空),为与新版类组授权方法结合使用
/// Creator:	wangjiabin
/// CreateDate:	2016-02-19
/// Table:		DHC_StkCatGrpRelations等
/// Input:		人员id, StkType, 科室id, 类组id
/// Output:		
ClassMethod GetUserCatGrpStr(userRowId As %String, stktype As %String, loc As %String, scg As %String = "", HospId = "") As %String
{
	n (userRowId,stktype,loc,scg,HospId,%session)
	q:(loc="")&&(scg="")&&(HospId="") ""
	s LocHospId=""
	i loc'="" s LocHospId=..sssHospId(loc)
	;q:(LocHospId'="")&&(HospId'="")&&(HospId'=LocHospId) ""   ;传入科室关联的医院 与直接传入医院ID不同
	i ((LocHospId'="")&&(HospId'="")&&(HospId'=LocHospId)) d  ;登陆医院不等于传递的医院 但是用户ID 科室ID是登陆医院的信息 因此默认置为空
	.s userRowId=""
	.s loc=""
	s:$g(stktype)="" stktype=..sssCode()
	s result=""
	;1.获取人员(科室)授权类组
	s AuthorScgStr=..GetAuthorOnlyScg(loc_"^"_userRowId,stktype)
	s AuthorScgStr=$tr(AuthorScgStr,",","^")
	
	;2.获取scg所有子类的串
	s ScgChildStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetAllChildScgStr(scg,"^")
	
	;2016-03-30 若均为空,返回所有类组
	i AuthorScgStr="",ScgChildStr="" q $$GetAllScg(stktype,HospId)
	
	;若有一个为空,返回另一个
	i AuthorScgStr="" q ScgChildStr
	i ScgChildStr="" q AuthorScgStr
	
	;3.获取交集
	s AuthorLen=$l(AuthorScgStr,"^")
	f i=1:1:AuthorLen d
	.s Scg=$p(AuthorScgStr,"^",i)
	.q:("^"_ScgChildStr_"^")'[("^"_Scg_"^")		;过滤ScgChildStr没有的
	.i result="" s result=Scg
	.e  s result=result_"^"_Scg
	s result=$tr(result,"^",",")
	s result=##class(web.DHCSTMHUI.Util.StkGrp).filterScgByHosp(result,HospId)
	s result=$tr(result,",","^")
	q result

GetAllScg(Type,HospId)
	n (Type,HospId)
	q:Type="" ""
	s AllScgStr=""
	s ScgId=0
	f  s ScgId=$o(^DHCSCG(ScgId)) q:ScgId=""  d
	.q:(+ScgId'>0)||'$d(^DHCSCG(ScgId))
	.s ScgType=$p($G(^DHCSCG(ScgId)),"^",3)
	.q:ScgType'=Type
	.q:('$d(^DHCSCG(ScgId,"RE"))&&('$d(^DHCSCG(0,"Parent",ScgId))))		;未关联库存分类的,过滤
	.i AllScgStr="" d
	..s AllScgStr=ScgId
	.e  d
	..s AllScgStr=AllScgStr_"^"_ScgId
	s AllScgStr=$tr(AllScgStr,"^",",")
	s AllScgStr=##class(web.DHCSTMHUI.Util.StkGrp).filterScgByHosp(AllScgStr,HospId)
	s AllScgStr=$tr(AllScgStr,",","^")
	q AllScgStr
}

/// 取某用户的授权类组串
/// Author:zhwh
/// Date:2013-07-12
/// Arguments:
///  userRowId - 用户rowid
///  stktype - 类型
/// Return:
///  类组串
///  update: 2014-10-29添加loc  如果人员下未配置 取科室下的权限
///  2016-03-14 修改多级类组后,方法名:GetUserCatGrpStr-->GetUserCatGrpStrOld
ClassMethod GetUserCatGrpStrOld(userRowId As %String, stktype As %String, loc As %String) As %String
{
 n (userRowId,stktype,loc)
 s result=""
 &Sql(declare userScg cursor for 
  select u_slcg_parref->slcg_stkcatgrp_dr From sqluser.dhc_stklocusercatgrp
  where u_ssusr_dr=:userRowId and u_slcg_parref->slcg_type=:stktype and u_slcg_parref->SLCG_CTLoc_Dr=:loc and U_Active='Y')    
 &sql(open  userScg)
 f  &sql(fetch userScg into :scg) q:SQLCODE  d
 .i result="" s result=+scg
 .e  s result=result_"^"_+scg
 .
 &sql(close userScg)
 i result="" d
 .&Sql(declare userScg2 cursor for 
  select SLCG_StkCatGrp_Dr From DHC_StkLocCatGroup
  where  SLCG_Type=:stktype and SLCG_CTLoc_Dr=:loc)    
 .&sql(open  userScg2)
 .f  &sql(fetch userScg2 into :scg) q:SQLCODE  d
 ..i result="" s result=+scg
 ..e  s result=result_"^"_+scg
 .
 .&sql(close userScg2)
 q result
}

/// Description:仅取有权限的类组(叶子类组或其子类组均有权限的),逗号隔开
/// Creator:	wangjiabin
/// CreateDate:	2016-03-10
/// Table:		DHC_StkCatGrpRelations等
/// Input:		StrParam(科室id^人员id^...), 类组类型(M/O等,缺省为M)
/// Output:	
/// w ##class(web.DHCSTMHUI.Util.DrugUtil).GetAuthorOnlyScg("153^541")
ClassMethod GetAuthorOnlyScg(StrParam As %String, Type As %String = "M") As %String
{
	n (StrParam,Type)
	s:Type="" Type=..sssCode()
	s LocId=$p(StrParam,"^",1)
	s UserId=$p(StrParam,"^",2)
	s ScgStr=..GetUserCatGrpStrOld(UserId,Type,LocId)	;有权限的底层类组(^隔开)
	s ScgStr=$tr(ScgStr,"^",",")
	q:ScgStr="" ""
	
	;循环遍历所有的类组(新加入的也过滤),若上级类组的孩子都在ScgStr,则将上级类组加入 
	s i=0
	f {
		s i=i+1
		q:i>$l(ScgStr,",")
		s Scg=$p(ScgStr,",",i)
		continue:Scg=""
		s ParScg=$p($G(^DHCSCG(Scg)),"^",4)
		continue:(ParScg="")||((","_ScgStr_",")[(","_ParScg_","))		;已存在的过滤
		s AuthorFlag=$$IsAllChildrenAuthor(ParScg,ScgStr)
		continue:AuthorFlag=0
		s ScgStr=ScgStr_","_ParScg
	}
	
	q ScgStr
IsAllChildrenAuthor(ParScg,ScgStr)
	;判断是否所有的类组均已授权
	n (ParScg,ScgStr)
	s AuthorFlag=1
	s Scg=""
	f  s tmpScg=Scg,Scg=$o(^DHCSCG(0,"Parent",ParScg,Scg)) q:(Scg="")||(tmpScg=Scg)||(AuthorFlag'=1)  d
	.q:('$d(^DHCSCG(Scg,"RE"))&&('$d(^DHCSCG(0,"Parent",Scg))))		;2016-03-15 未关联库存分类且没有子类组的,不考虑
	.i (","_ScgStr_",")'[(","_Scg_",") s AuthorFlag=0
	q AuthorFlag
}

/// Description:获取价格格式化小数长度
/// Creator:	wangjiabin
/// CreateDate:	2014-10-30
/// Input:		格式化类型(FmtRP,FmtPP,FmtSP,FmtRA,FmtPA,FmtSA,FmtQTY)
/// Output:		格式化小数位数
/// w ##class(web.DHCSTMHUI.Util.DrugUtil).DecLenByFmtType("FmtRP",2)
ClassMethod DecLenByFmtType(FmtType As %String, HospId As %String) As %Integer
{
	n (FmtType,HospId)
	s FmtDecLen=2			;缺省显示两位
	s NormTypes="FmtRP,FmtPP,FmtSP,FmtRA,FmtPA,FmtSA,FmtQTY"
	q:'$f(NormTypes,$g(FmtType)) FmtDecLen
	
	s AppName="DHCSTCOMMONM"
	s StrParam="^^^"_HospId
	s FmtStr=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,FmtType,StrParam)
	s DecStr=$P(FmtStr,".",2)
	S FmtDecLen=$l(DecStr)	;小数位数
	
	q FmtDecLen
}

/// Descript:根据药品库存项查询药品的批次列表
/// Creater:zhangdongmei
/// CreateDate:2013-07-19
/// Input:库存项id,开始行，一页显示记录数       
/// Output:     
/// Return：批次RowID^批次/效期^生产厂家^批次库存^包装单位^售价^基本单位^进价^入库日期^
/// 包装单位id^基本单位id^包装单位和基本单位的转换率
/// modify: wyx 根据库存项id取INC_ItmBat表的药品的批次(与科室库存批次不是一个意思)，批号+效期为一个批次
/// d ##class(web.DHCSTMHUI.Util.DrugUtil).GetDrugBatInfoAll("1","15","Rp","asc","{""InciDr"":""4449"",""ProLocId"":""392""}")
/// 20180719
ClassMethod GetDrugBatInfoAll(page, rows, sort, order, Params) As %Library.String
{
	n (page, rows, sort, order, Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 ""
	s InciDr=PJObj.%Get("InciDr")
	q:InciDr="" ""
	s Start=(page-1)*rows
	s Limit=rows
	s end = Start+Limit
	s LocId=PJObj.%Get("ProLocId")
	s FilterZeroQty=PJObj.%Get("FilterZeroQty")
	s HospID=""
	s:LocId'="" HospID=$p(^CTLOC(LocId),"^",22)
	S InciCode=$P(^INCI(InciDr,1),"^",1)
	S InciDesc=$P(^INCI(InciDr,1),"^",2)
	s BUomId=$p(^INCI(InciDr,1),"^",10)
	s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	s PurUomId=$p(^INCI(InciDr,3),"^",6)
	s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	s Pid=..NewPid()
	k ^TMPDrugBatInfo(Pid,"DrugBatInfo")
	s count=0
	s chl=0
	f  s chl=$o(^INCI(InciDr,"IB",chl)) q:chl=""  d
	.s Incib =InciDr_"||"_chl
	.s ZeroFlag=..CheckQtyByIncib(Incib)
	.q:(FilterZeroQty="Y")&&(ZeroFlag=0)
	.s count=count+1
	.s RetStr=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByIncib(Incib,+$h,PurUomId,HospID,"")
	.s Sp=$p(RetStr,"^",2)
	.s Sub=""
	.i sort="Sp" d
	..s Sub=Sp
	.e  d
	..s Sub=chl
	.s ^TMPDrugBatInfo(Pid,"DrugBatInfo",Sub,count)=chl
	
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s order=$$ALPHAUP^SSUTIL4(order)
	s:order="" order="ASC"
	s orderFlag=$s(order="ASC":1,1:-1)
	s count=0
	s Sub=""
	f  s Sub=$o(^TMPDrugBatInfo(Pid,"DrugBatInfo",Sub),orderFlag) q:Sub=""  d
	.s num=""
	.f  s num=$o(^TMPDrugBatInfo(Pid,"DrugBatInfo",Sub,num),orderFlag) q:num=""  d
	..s count=count+1
	..q:(count<(Start+1))||(count>end)
	..s chl=^TMPDrugBatInfo(Pid,"DrugBatInfo",Sub,num)
	..d GetIncibDateInfo(chl)
	
	s Title1="Incib^InciDr^InciCode^InciDesc^BatExp^PurUomId^PurUomDesc^Rp:number^Sp:number^BUomId"
	s Title2="BUomDesc^IngrDate"
	s Title=Title1_"^"_Title2
	d json.getJsonData(Title,count)
	k ^TMPDrugBatInfo(Pid,"DrugBatInfo")
	k json
	q ""
GetIngrDate(Incib)
	n (Incib)
	q:Incib="" ""
	s Ingr=$o(^DHCINGR(0,"GRI_INCIB",Incib,""),-1)
	q:Ingr="" ""
	s IngrDate=$p(^DHCINGR(Ingr),"^",4)
	s:IngrDate'="" IngrDate=..DL2H(IngrDate)
	q IngrDate
	
GetIncibDateInfo(chl)
	s Incib=InciDr_"||"_chl
	s BatNo=$p(^INCI(InciDr,"IB",chl),"^",1)
	s ExpDate=$p(^INCI(InciDr,"IB",chl),"^",2)
	i ExpDate'="" s ExpDate=..DL2H(ExpDate)
	s BatExp = BatNo_"~"_ExpDate
	s RetStr=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByIncib(Incib,+$h,PurUomId,HospID,"")
	s Sp=$p(RetStr,"^",2)
	s Rp=$p(RetStr,"^",1)
	s IngrDate=$$GetIngrDate(Incib)
	
	s Data1=Incib_"^"_InciDr_"^"_InciCode_"^"_InciDesc_"^"_BatExp_"^"_PurUomId_"^"_PurUomDesc_"^"_Rp_"^"_Sp_"^"_BUomId
	s Data2=BUomDesc_"^"_IngrDate
	s DataStr=Data1_"^"_Data2
	d json.InsertRowData(DataStr)
}

/// creator:lxt
/// date:2016-11-09
/// description:截取科室名称
/// input:科室名称
/// output:截取后科室名称
/// others:w ##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc("",163)
ClassMethod GetLocDesc(LocDesc As %String, LocId As %String = "")
{
	n (LocDesc,LocId)
	i (LocDesc="")&&(LocId'="") s LocDesc=$p(^CTLOC(LocId),"^",2)
	s LocDescType=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTCOMMONM","GetLocDesc","")
	i (LocDesc["-")  d  //判断是否存在'-'
	.i LocDescType=1  d    //取'-'前部分
	..s LocDesc=$p(LocDesc,"-",1)
	.e  i LocDescType=2  d  //取'-'后部分
	..s LocDesc=$p(LocDesc,"-",2)
	
	q LocDesc
}

/// Descript:	根据科室和药品库存项查询物资的高值条码列表
/// Creator:	wxj
/// CreateDate:	2020-06-22
/// Input:库存项id,供应科室id,请求科室id,开始行，一页显示记录数       
/// Output:     
/// w ##class(web.DHCSTMHUI.Util.DrugUtil).GetDrugHVBatInfo(1,15,"","",^tempzlk("002"))
ClassMethod GetDrugHVBatInfo(page, rows, sort, order, Params) As %Library.String
{
	n (page,rows,sort,order,Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 ""
	s InciDr=PJObj.%Get("InciDr")
	s ProLocId=PJObj.%Get("ProLocId")
	s ReqLocId=PJObj.%Get("ReqLocId")
	s QtyFlag=PJObj.%Get("QtyFlag")
	s Inclb=PJObj.%Get("Inclb")
	s PBatchNo=PJObj.%Get("BatchNo")
	s PExpDate=PJObj.%Get("ExpDate")
	s PExpDate=..DH2L(PExpDate)
	q:ProLocId="" ""
	q:InciDr="" ""
	s Start=(page-1)*rows
	s Limit=rows
	s end = Start+Limit
	
	s InciCode=$p(^INCI(InciDr,1),"^",1)
	s InciDesc=$p(^INCI(InciDr,1),"^",2)
	S Spec=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciDr)
	s count = 0
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s chl=0
	f  s chl=$o(^INCI("IL_LOC",ProLocId,InciDr,chl)) q:chl=""  d
	.s lb=0
	.f  s lb=$o(^INCI(InciDr,"IL",chl,"LB",lb))  q:lb=""  d
	..s RowId =InciDr_"||"_chl_"||"_lb
	..q:(Inclb'="")&(RowId'=Inclb)
	..s IncibRowId =$p(^INCI(InciDr,"IL",chl,"LB",lb),"^",1)
	..s IncilRowId =InciDr_"||"_chl
	..s BatNo=$p(^INCI(+IncibRowId,"IB",$p(IncibRowId,"||",2)),"^",1)
	..q:(PBatchNo'="")&&(PBatchNo'=BatNo)
	..s ExpDate=$p(^INCI(+IncibRowId,"IB",$p(IncibRowId,"||",2)),"^",2)
	..q:(PExpDate'="")&&(PExpDate'=ExpDate)
	..s RecallFlag=$p(^INCI(+IncibRowId,"IB",$p(IncibRowId,"||",2)),"^",3)
	..s:ExpDate'="" ExpDate=..DL2H(ExpDate)
	..s BatExp = BatNo_"~"_ExpDate
	..s SterilizedBat=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSterilizedBatByInclb(RowId)
	..s Manf = ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(RowId)
	..s ManfDr=$P(Manf,"^",1)
	..s ManfName=$P(Manf,"^",2)
	..s BUomId=$p(^INCI(InciDr,1),"^",10)
	..q:BUomId=""
	..s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	..s PurUomId=$p(^INCI(InciDr,3),"^",6)
	..q:PurUomId=""
	..s PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciDr)
	..
	..//出库等操作:高值扫码(此时传入Inclb)时,高值直接用基本单位
	..i (HVFlag="Y")&&(Inclb'="") d
	...s PurUomId=BUomId
	...s PurUomDesc=$g(BUomDesc)
	..
	..s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(+PurUomId,+BUomId)
	..s InclbQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(RowId,PurUomId,2)
	..q:(QtyFlag=1)&(InclbQty<=0)
	..S InitQty = 0
	..s Date = $P($H, ",", 1)
	..S HospID=$P(^CTLOC(ProLocId),"^",22)
	..
	..s BatSpFlag=..sssBatSpFlag(HospID,InciDr)
	..i BatSpFlag="1" d //批次价格
	...s RetStr=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByIncib(IncibRowId,+$h,PurUomId,HospID,"")
	...s Sp=$p(RetStr,"^",2)
	...s Rp=$p(RetStr,"^",1)
	..e  d
	...s Rp = ##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(RowId,PurUomId,HospID)
	...s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciDr,+$h,PurUomId,HospID)
	..S ReqQty = 0
	..s StkBin=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(ProLocId,InciDr)
	..s StkBin=$p(StkBin,"^",1)
	..s DirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(RowId,PurUomId)
	..s ResveredQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbReservedQty(RowId,PurUomId)
	..s AvaQty = InclbQty - DirtyQty - ResveredQty
	..s SupplyStockQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(InciDr,ProLocId,PurUomId,Date)
	..s SupplyAvaStockQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(ProLocId,InciDr,PurUomId) ;物资可用库存
	..S:ReqLocId'="" RequrstStockQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(InciDr,ReqLocId,PurUomId,Date)
	..s IngrId=$o(^DHCINGR(0,"GRI_INCIB",IncibRowId,""),-1)
	..s IngrDate=""
	..i IngrId'="" d
	...s IngrDate=$p(^DHCINGR(+IngrId),"^",4)
	...s:IngrDate'="" IngrDate=..DL2H(IngrDate)
	..s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(RowId)
	..s Vendor=$p(VendorInfo,"^",1)
	..s VendorName=$p(VendorInfo,"^",2)
	..s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(RowId)
	..s dhcit=""
	..f  s dhcit=$o(^DHCIT(0,"INCI",InciDr,dhcit)) q:dhcit=""  d	
	...s barcodestatus=$p(^DHCIT(dhcit),"^",5)
	...q:barcodestatus'="Enable"
	...s HvBarcode=$p(^DHCIT(dhcit),"^",2)
	...s INCLB=$p(^DHCIT(dhcit),"^",12)
	...q:INCLB'=RowId
	...s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(IncId,HospID)
	...s MatInsuCode=$p(MatInsuInfo,"^",1)
	...s MatInsuDesc=$p(MatInsuInfo,"^",2)
	...s count = count+1
	...
	...s tmp1=InciDr_"^"_RowId_"^"_BatExp_"^"_ManfName_"^"_InclbQty_"^"_$g(PurUomDesc)_"^"_Sp_"^"_ReqQty_"^"_$g(BUomDesc)_"^"_Rp_"^"_StkBin
	...s tmp2=SupplyStockQty_"^"_$g(RequrstStockQty)_"^"_IngrDate_"^"_PurUomId_"^"_BUomId_"^"_ConFac_"^"_DirtyQty
	...s tmp3=AvaQty_"^"_HVFlag_"^"_SupplyAvaStockQty_"^"_RecallFlag_"^"_Vendor_"^"_VendorName
	...s tmp4=SterilizedBat_"^"_SpecDesc_"^"_InciCode_"^"_InciDesc_"^"_dhcit_"^"_HvBarcode_"^"_Spec_"^"_MatInsuCode_"^"_MatInsuDesc
	...s tmp=tmp1_"^"_tmp2_"^"_tmp3_"^"_tmp4
	...i (count>Start)&(count<=end) d
	....d json.InsertRowData(tmp)
	s Title="InciDr^Inclb^BatExp^Manf^InclbQty:number^PurUomDesc^Sp:number^ReqQty:number^BUomDesc^Rp:number^StkBin"
		_"^SupplyStockQty:number^RequrstStockQty:number^IngrDate^PurUomId^BUomId^ConFac:number^DirtyQty:number"
		_"^AvaQty:number^HVFlag^SupplyAvaStockQty:number^RecallFlag^Vendor^VendorName"
		_"^SterilizedBat^SpecDesc^InciCode^InciDesc^dhcit^HVBarCode^Spec^MatInsuCode^MatInsuDesc"
	d json.getJsonData(Title,count)
	k json
	q ""
}

/// w ##class(web.DHCSTMHUI.Util.DrugUtil).CheckQtyByIncib("1938||2")
ClassMethod CheckQtyByIncib(Incib)
{
	n (Incib)
	s flag=0
	s IL=""
	f  s IL=$o(^INCI("LB_IB",Incib,+Incib,IL)) q:(IL="")||(flag=1)  d
	.s LB=""
	.f  s LB=$o(^INCI("LB_IB",Incib,+Incib,IL,LB)) q:(LB="")||(flag=1)  d
	..s Qty=$p(^INCI(+Incib,"IL",IL,"LB",LB),"^",2)
	..s:Qty>0 flag=1
	q flag
}

}

Import sqluser

/// 将物资信息属性进行同步处理
/// 20190306  lihui
Class web.DHCSTMHUI.Tools.InciParamRecordS Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

ClassMethod synchroParams() As %String
{
	k ^TMP("INCIPARAMS_INFO")    ;1:属性名称;2:属性描述;3.是否审核标志;
	k ^TMP("INCIPARAMS_INFO_ERROR")
	;INC_ITM
	s ^TMP("INCIPARAMS_INFO",10001)=$lb("INCICode","代码","Y")
	s ^TMP("INCIPARAMS_INFO",10002)=$lb("INCIDesc","描述","Y")
	s ^TMP("INCIPARAMS_INFO",10003)=$lb("INCICTUOMDR","基本单位","Y")
	s ^TMP("INCIPARAMS_INFO",10004)=$lb("INCICTUOMPurchDR","入库单位","Y")
	s ^TMP("INCIPARAMS_INFO",10005)=$lb("INCIINCSCDR","库存分类","Y")
	s ^TMP("INCIPARAMS_INFO",10006)=$lb("INCINotUseFlag","停用标志","N")
	s ^TMP("INCIPARAMS_INFO",10007)=$lb("INCIBatchReq","要求批次","N")
	s ^TMP("INCIPARAMS_INFO",10008)=$lb("INCIExpReq","要求效期","N")
	s ^TMP("INCIPARAMS_INFO",10009)=$lb("INCISterile","消毒项标志","N")
	s ^TMP("INCIPARAMS_INFO",10010)=$lb("INCISterCatDR","消毒项分类 ","N")
	s ^TMP("INCIPARAMS_INFO",10011)=$lb("INCIBarCode","条码","N")
	s ^TMP("INCIPARAMS_INFO",10012)=$lb("INCIReportingDays","协和码","N")
	s ^TMP("INCIPARAMS_INFO",10013)=$lb("INCICTLOCDR","供应仓库","N")


	; DHC_ItmAddionInfo
	s ^TMP("INCIPARAMS_INFO",20001)=$lb("INFOImportFlag","进口标志","N")
	s ^TMP("INCIPARAMS_INFO",20002)=$lb("INFOQualityLevel","质量层次","N")
	s ^TMP("INCIPARAMS_INFO",20003)=$lb("INFOComFrom","国（省）别","N")
	s ^TMP("INCIPARAMS_INFO",20004)=$lb("INFORemark","批准文号","N")
	s ^TMP("INCIPARAMS_INFO",20005)=$lb("INFOHighPrice","高值类标志","N")
	s ^TMP("INCIPARAMS_INFO",20006)=$lb("INFOMTDR","定价类型","N")
	s ^TMP("INCIPARAMS_INFO",20007)=$lb("INFOMaxSp","最高售价","N")
	s ^TMP("INCIPARAMS_INFO",20008)=$lb("INFOInHosFlag","本院药品目录","N")
	s ^TMP("INCIPARAMS_INFO",20009)=$lb("INFOPbRp","招标进价","N")
	s ^TMP("INCIPARAMS_INFO",20010)=$lb("INFOPBLDR","招标名称","N")
	s ^TMP("INCIPARAMS_INFO",20011)=$lb("INFOPbVendorDR","招标供应商","N")
	s ^TMP("INCIPARAMS_INFO",20012)=$lb("INFOPbManfDR","招标生产商","N")
	s ^TMP("INCIPARAMS_INFO",20013)=$lb("INFOPbCarrierDR","招标配送商","N")
	s ^TMP("INCIPARAMS_INFO",20014)=$lb("INFOSpec","规格","N")
	s ^TMP("INCIPARAMS_INFO",20015)=$lb("INFOBAflag","一次性标志(物资材料)","N")
	s ^TMP("INCIPARAMS_INFO",20016)=$lb("INFOPBLevel","招标级别代码","N")
	s ^TMP("INCIPARAMS_INFO",20017)=$lb("INFOEndDate","截止日期","N")
	s ^TMP("INCIPARAMS_INFO",20018)=$lb("INFOExpireLen","效期长度(天)","N")
	s ^TMP("INCIPARAMS_INFO",20019)=$lb("INFOPrcFile","物价文件号","N")
	s ^TMP("INCIPARAMS_INFO",20020)=$lb("INFOPrcFileD","价格生效日期","N")
	s ^TMP("INCIPARAMS_INFO",20021)=$lb("INFOBCDr","账簿分类","N")
	s ^TMP("INCIPARAMS_INFO",20022)=$lb("INFOStandardCode","物资本位码","N")
	s ^TMP("INCIPARAMS_INFO",20023)=$lb("INFONotUseReasonDr","不可用原因","N")
	s ^TMP("INCIPARAMS_INFO",20024)=$lb("INFOPHMNFDR","厂商","N")
	s ^TMP("INCIPARAMS_INFO",20025)=$lb("INFOInsuCatDR","医保类别","N")
	s ^TMP("INCIPARAMS_INFO",20026)=$lb("INFOHighRiskFlag","高危标志","N")
	s ^TMP("INCIPARAMS_INFO",20027)=$lb("INFOPackUom","大包装","N")
	s ^TMP("INCIPARAMS_INFO",20028)=$lb("INFOPackUomFactor","大包装转换因子","N")
	s ^TMP("INCIPARAMS_INFO",20029)=$lb("INFOPackPicPath","外包装图片路径","N")
	s ^TMP("INCIPARAMS_INFO",20030)=$lb("INFOMaxPurAmt","月采购金额上限","N")
	s ^TMP("INCIPARAMS_INFO",20031)=$lb("INFODistribFlag","分配标志","N")
	s ^TMP("INCIPARAMS_INFO",20032)=$lb("INFOChargeFlag","收费标志","N")
	s ^TMP("INCIPARAMS_INFO",20033)=$lb("INFOBrand","品牌","N")
	s ^TMP("INCIPARAMS_INFO",20034)=$lb("INFOModel","型号","N")
	s ^TMP("INCIPARAMS_INFO",20035)=$lb("INFOAbbrev","简称","N")
	s ^TMP("INCIPARAMS_INFO",20036)=$lb("INFOSupervision","器械材料监管分类","N")
	s ^TMP("INCIPARAMS_INFO",20037)=$lb("INFOImplantationMat","植入（介入）材料","N")
	s ^TMP("INCIPARAMS_INFO",20038)=$lb("INFOPbno","招标序号","N")
	s ^TMP("INCIPARAMS_INFO",20039)=$lb("INFOChangeRate","招标转换比","N")
	s ^TMP("INCIPARAMS_INFO",20040)=$lb("INFOMatQuality","材质","N")
	s ^TMP("INCIPARAMS_INFO",20041)=$lb("INFOReqModeLimited","限制请求方式","N")
	s ^TMP("INCIPARAMS_INFO",20042)=$lb("INFONoLocReq","禁止科室请领","N")
	s ^TMP("INCIPARAMS_INFO",20043)=$lb("INFOSpeFlag","特殊标志","N")
	s ^TMP("INCIPARAMS_INFO",20044)=$lb("INFOSterileDateLen","灭菌时间长度（天）","N")
	s ^TMP("INCIPARAMS_INFO",20045)=$lb("INFOMedEqptCatDR","医疗器械分类","N")
	s ^TMP("INCIPARAMS_INFO",20046)=$lb("INFOZeroStk","零库存标志","N")
	s ^TMP("INCIPARAMS_INFO",20047)=$lb("INFOChargeType","收费类型","N")
	s ^TMP("INCIPARAMS_INFO",20048)=$lb("INFOSpecFlag","具体规格是否可以录入标志","N")
	s ^TMP("INCIPARAMS_INFO",20049)=$lb("INFOTransDate","到货时间","N")
	s ^TMP("INCIPARAMS_INFO",20050)=$lb("INFOBidDate","招标日期","N")
	s ^TMP("INCIPARAMS_INFO",20051)=$lb("INFOFirstReqDept","首请科室","N")
	s ^TMP("INCIPARAMS_INFO",20052)=$lb("INFOOrigin","原产地","N")
	s ^TMP("INCIPARAMS_INFO",20053)=$lb("INFOInsuPay","是否医保支付","N")
	s ^TMP("INCIPARAMS_INFO",20054)=$lb("INFOInsuPrice","医保支付价格","N")
	s ^TMP("INCIPARAMS_INFO",20055)=$lb("INFOMatCatOfficialDR","材料官方分类","N")
	s ^TMP("INCIPARAMS_INFO",20056)=$lb("INFOMatCatClinicalDR","材料临床分类","N")
	s ^TMP("INCIPARAMS_INFO",20057)=$lb("INFOMatCatSpecialDR","材料特殊分类","N")
	s ^TMP("INCIPARAMS_INFO",20058)=$lb("INFOMatRegCertDR","注册证号","N")
    
	s cnt=0,addcnt=0
    s i=0
	f  s i=$o(^TMP("INCIPARAMS_INFO",i)) q:i=""  d
	.s cnt=cnt+1
	.s listdata=^TMP("INCIPARAMS_INFO",i)
	.s paramname=$list(listdata,1)
	.s paramdesc=$list(listdata,2)
	.s auditflag=$list(listdata,3)
	.s retid=..ParamsIfExist(paramname)
	.if retid="" d
	..&sql(INSERT INTO SQLUser.DHC_InciParamRecord (INCIP_ParamName, INCIP_Desc, INCIP_ActiveFlag) VALUES (:paramname,:paramdesc,:auditflag))
	..if SQLCODE'=0 d
	...s lastcnt=$O(^TMP("INCIPARAMS_INFO_ERROR",""),-1)+1
	...s ^TMP("INCIPARAMS_INFO_ERROR",lastcnt)=elemid_","_cspname
	..e  d
	...s addcnt=addcnt+1
	
	q addcnt_"^"_cnt
}

ClassMethod ParamsIfExist(paramname As %String) As %String
{
	n (paramname)
	s rowid=$o(^DHCINCIP(0,"param",paramname,""))
 	q rowid
}

}

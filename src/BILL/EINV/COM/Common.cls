/// 共通处理类
Class BILL.EINV.COM.Common Extends %RegisteredObject
{

/// 功能说明：生成唯一的流水号
///           生成规则：发票ID+业务编码+时间戳,位数不足时 在前边补充随机字符串;超过长度时从右向左截取字符串。
///           超过要求长度时从右向左截取要求的长度。
/// 入参说明：LogicCode --> 业务编码
///           OutLen    --> 输出的随机数长度
///           InvPrtNo  --> 发票No
/// 返 回 值：生成的业务流水号 
/// 修改履历：董科锋  2019 09 18  新做成
/// w ##class(BILL.EINV.COM.Common).CreateBusinessNo("IP","32","123456") 
ClassMethod CreateBusinessNo(LogicCode As %String, OutLen As %Integer = 30, InvPrtNo As %String = "") As %String
{
	s NowDateTimeStr=$h                 ;日期及时间
	s NowDate=$zd(+NowDateTimeStr, 8)                       ;日期字符串(格式：YYYYMMDD)
	s NowTime=$tr($zt($p(NowDateTimeStr, ",",2)), ":", "")  ;时间(格式：HHMISS)
	s Stamp=$p($zts, ".", 2)                                ;毫秒
	
	s DateTimeInfo= NowDate_NowTime_Stamp
	
	;add by xubaobao 2021 05 31 由于有些项目要求流水号保留18位，从右边截取容易出现并发，所有生产流水号规则改为"随机数+时间戳+业务类型+发票id"
	;s MainOutInfo=LogicCode_DateTimeInfo
	;s:(InvPrtNo'="") MainOutInfo=InvPrtNo_MainOutInfo
	s MainOutInfo=DateTimeInfo_LogicCode
	s:(InvPrtNo'="") MainOutInfo=MainOutInfo_InvPrtNo
	
	s NowLen=$l(MainOutInfo)  ;主要的流水号长度
	if (NowLen<OutLen){  ;位数不足时，在前边补充随机字符串
		s RandomArr="ABCDEFGHIGKLMNOPQRSTUVWXY1234567890"    ;随机字符从这个字符串中获取
		s RandNum=$l(RandomArr)                              ;用来产生随机数,用作查询随机字符的索引
		s AddInfo=""
		s AddLen=OutLen-NowLen
		f index=1:1:AddLen d
		.s RandomIndex=$Random(RandNum)  ;获取随机字符的索引
		.s RandomIndex=RandomIndex+1  ;获取字符串的值从1开始，但是获取的随机数从0开始，所以这里加1
		.s:RandomIndex>RandNum RandomIndex=RandNum
		.s RandomChar=$e(RandomArr, RandomIndex, RandomIndex)  ;获取随机字符
		.s AddInfo=AddInfo_RandomChar
		s OutBusinessNo=AddInfo_MainOutInfo
		
	}else{ ;超过要求的长度时,截取从右边截取要求的长度
		s startIndex=(NowLen-OutLen)+1
		s OutBusinessNo=$e(MainOutInfo, startIndex, NowLen)
	}
	
	q OutBusinessNo
}

/// 根据代码类别和位置取字典的值
/// SysType:SYS代码
/// Code:代码
/// xubaobao 2019 09 29
/// 取值的位置
/// w ##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","BILLEINV_RequestType",5)
ClassMethod GetEINVDicByCodeAndInd(DicType, DicCode, ind) As %String
{
	s rtn=""
	q:(DicType="")||(DicCode="") rtn
	
	s rowid=0
	f  s rowid=$o(^BILL.EINV.PO.DicDataI("IDataKey",DicType,DicCode,rowid)) q:(rowid="")  d
	.s obj = ##class(BILL.EINV.PO.DicData).%OpenId(rowid)	;获取对象
	.s AllInfo=rowid_"^"_obj.DicType_"^"_obj.DicCode_"^"_obj.DicDesc_"^"_obj.DicBill1_"^"_obj.DicBill2_"^"_obj.DicDemo_"^"_obj.XStr1_"^"_obj.XStr2_"^"_obj.XStr3_"^"_obj.XStr4_"^"_obj.XStr5
	.i (+ind=0) d
	..s rtn=AllInfo
	.e  d
	..s rtn=$p(AllInfo, "^", +ind)

	q rtn
}

/// 功能说明：从电子票据的字典配置中获取医院对应的配置信息
/// 入参说明：HospitalInfoMap  --> 医院相关的配置信息(返回值)
///           HospitalNo       --> 医院编码(可选)
///           RtnObjFlg        --> 返回的是字典的对象信息标志(可选)
/// 返 回 值：医院的相关配置数量
/// 修改履历：董科锋  2019 12 20 新做成
/// s HospitalInfoMap=""
/// w ##class(BILL.EINV.COM.Common).GetHospitalInfoByDic("")
/// w HospitalInfoMap.GetAt("XSF_NSRSBH")
ClassMethod GetHospitalInfoByDic(HospitalInfoMap As %ArrayOfDataTypes, HospitalNo As %String = "", RtnObjFlg As %String = "0") As %String
{
	s RtnNum=0
	
	if ($isobject(HospitalInfoMap)=0){
		s HospitalInfoMap=##class(%ArrayOfDataTypes).%New()
	}
	
	s DicType="Hospital_Einvt_Info"_HospitalNo   ;字典类型
	
	s DicCode=""
	f  s DicCode=$o(^BILL.EINV.PO.DicDataI("IDataKey",DicType,DicCode)) q:DicCode=""  d
	.s rowid=""
	.f  s rowid=$o(^BILL.EINV.PO.DicDataI("IDataKey",DicType,DicCode,rowid)) q:rowid=""  d
	..s obj=##class(BILL.EINV.PO.DicData).%OpenId(rowid)	;获取对象
	..s KeyCode=DicCode
	..s objVal=obj.DicBill1
	..i RtnObjFlg="1" 
	...s objVal=obj
	..d HospitalInfoMap.SetAt(objVal, KeyCode)   ;加入到键值对集合中
	..s RtnNum=RtnNum+1
	
	q RtnNum
}

/// 功能说明：XML字符流转换为指定的对象
/// 入参说明：XmlStream     --> XML字符流
///           RootNodeName  --> 根节点名称
///           OutClassName  --> 转转成的对象类名称
///           OutObj        --> 转换后的对象
/// 返 回 值：0 成功  -1 失败
/// w ##class(BILL.EINV.COM.Common).XmlStreamToObj()
ClassMethod XmlStreamToObj(XmlStream As %GlobalCharacterStream, RootNodeName As %String, OutClassName As %String, ByRef OutObj As %String) As %String
{
	s RtnFlg="-1"
	
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(XmlStream)
	d reader.Correlate(RootNodeName, OutClassName)
	if reader.Next(.obj,.sc) {
		s OutObj=obj
		s RtnFlg="0"
	}
	
	q RtnFlg
}

/// 功能说明：参数验证失败时构造 通用的返回值信息字符流
/// 入参说明：ResultCode  -->  返回值编码
///           ErrMsg      -->  错误信息
/// 返 回 值：返回值数据流
/// w ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "ErrMsg")
ClassMethod BuildComOutStream(ResultCode As %String, ErrMsg As %String) As %GlobalCharacterStream
{
	s ObjResult=##class(BILL.EINV.DTO.ZZJ.ResultRes).%New()
	s ObjResult.ResultCode=ResultCode      ;返回代码
	s ObjResult.ResultMsg=ErrMsg           ;返回信息
    
    s OutputPamStream=""
    d ObjResult.XMLExportToStream(.OutputPamStream)
    q OutputPamStream
}

/// 功能说明：当HIS费用分类需要与第三方电子票据的费用分类对照时，按照第三方费用分类汇总
/// 入参说明：ObjInvPrtInfo		--> 发票对象
/// 			 ObjUPConfig		--> 配置信息对象
/// 出参说明：费用分类编码^费用分类名称^费用分类总金额,费用分类编码^费用分类名称^费用分类总金额,...
/// w ##class(BILL.EINV.COM.Common).GetCatFeeByInvDr()
ClassMethod GetCatFeeByInvDr(ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, ObjUPConfig As BILL.EINV.PO.InvUpConfig, PayAdmType As %String) As %String
{
	k CateList
	s FeeConStr=""
	q:$IsObject(ObjInvPrtInfo)=0 FeeConStr
	
	s DicType="FeeItmCateCon"
	s:PayAdmType="OP" DicType="FeeItmCateOPCon"
	s:PayAdmType="IP" DicType="FeeItmCateIPCon"
	s DicType=DicType_ObjUPConfig.FactoryCode
	
	f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	.s CateCode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code
	.s CateDesc=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc
	.s CateAmt=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt
	.q:(+CateAmt=0)
	.s FeeCateConInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd(DicType, CateCode, 0)	;第三方分类编码
	.s FeeCateCon=$p(FeeCateConInfo, "^", 5)   ;对照编码
	.s:FeeCateCon="" FeeCateCon=CateCode       ;没有对照编码的时候 用原始编码
	.s CateNameCon=$p(FeeCateConInfo, "^", 6)  ;对照名称
	.s CateList("Amount",FeeCateCon)=+$g(CateList("Amount", FeeCateCon))+CateAmt
	.s CateList("CateName", FeeCateCon)=CateNameCon
	
	s FeeCodeCon="",FeeDescCon="",FeeAmtCon=""
	f  s FeeCodeCon=$o(CateList("Amount",FeeCodeCon)) q:(FeeCodeCon="")  d
	.s FeeAmtCon=$g(CateList("Amount",FeeCodeCon))			 ;第三方分类汇总金额
	.s FeeAmtCon=$fn(FeeAmtCon,"",2)       	 ;保留两位小数
	.s FeeDescCon=$g(CateList("CateName", FeeCodeCon))
	.;s FeeDescCon=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeType"_ObjUPConfig.FactoryCode,FeeCodeCon,4)	;第三方分类名称
	.i FeeConStr="" d
	..s FeeConStr=FeeCodeCon_"^"_FeeDescCon_"^"_FeeAmtCon
	.e  d
	..s FeeConStr=FeeConStr_","_FeeCodeCon_"^"_FeeDescCon_"^"_FeeAmtCon
	
	q FeeConStr
}

/// 通过发票ID、业务类型返回电子票据二维码信息
/// w ##class(BILL.EINV.COM.Common).BILLEINVInfoByPrtId("OP", "3786152","1")
ClassMethod BILLEINVInfoByPrtId(PayAdmType As %String, HISPrtRowID As %String, Type As %String) As %String
{
	s BILLEINVInfo=""
	q:((PayAdmType)||(HISPrtRowID="")) BILLEINVInfo
	
	s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxEInvFlg",PayAdmType,HISPrtRowID,"E","I",0))
	q:(IUDID="") BILLEINVInfo
	
	s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID)
	s uplodeFlag=objUpDetail.IUDUplodeFlag				//上传标志
	q:(uplodeFlag'="Y") "不存在已上传记录"
	
	s:(Type="") Type="1"
	if (Type="1") {		//返回二维码信息串（同HIS导诊单二维码串）
		s BILLEINVInfo=##class(BILL.EINV.BL.COM.Common).GetIUDBillQRCodeByIUDInitDr(PayAdmType,HISPrtRowID)
	}elseif( Type="2"){   //返回博思的Url串
		s BILLEINVInfo=objUpDetail.IUDPictureUrl
	}elseif( Type="3"){	  //返回博思的二维码Base64加密串
		s BILLEINVInfo=objUpDetail.IUDBillQRCode
	}
	
	q BILLEINVInfo
}

/// 功能说明：   通过日期时间获取对应的第三方上传时间格式
/// 入参：       Date：日期
/// 				 Time: 时间
/// 出参：       第三方接口对应的上传时间格式(格式：yyyyMMddHHmmssSSS)
/// w ##class(BILL.EINV.COM.Common).GetBusDate(+$h,$p($h,",",2))
ClassMethod GetBusDate(Date, Time) As %String
{
	s rtnDate=""
	i Date="" s Date=+$h
	i Time="" s Time=$p($h,",",2)
	i Date'["-" d  s Date=$zd(Date,3)
	i Time'[":" d  s Time=$zt(Time,1)
	;s rtnDate=$replace(Date,"-","")_$replace(Time,":","")_$e($p($zts,".",2),1,3)
	s SSSTime=$p($zts,".",2)
	if ($l(SSSTime)<3){
		s SSSTimeTmp="000"_SSSTime
		s LenTmp=$l(SSSTimeTmp)
		s StartIndex=(LenTmp-3)+1
		s SSSTime=$e(SSSTimeTmp, StartIndex,LenTmp)
	}else{
		s SSSTime=$e(SSSTime,1,3)
	}
	s rtnDate=$replace(Date,"-","")_$replace(Time,":","")_SSSTime
	q rtnDate
}

/// 电子票据功能启用标识
/// w ##class(BILL.EINV.COM.Common).EInvUseFlag()
ClassMethod EInvUseFlag(Type) As %String
{
	s:Type'="IP" Type="OP"
	q ##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case",Type_"_Use_Flg",5)
}

/// 功能说明：生成唯一的流水号
///           生成规则：发票ID+业务编码+时间戳,位数不足时 在前边补充随机字符串;超过长度时从右向左截取字符串。
///           超过要求长度时从右向左截取要求的长度。
/// 入参说明：LogicCode --> 业务编码
///           OutLen    --> 输出的随机数长度
///           InvPrtNo  --> 发票No
/// 返 回 值：生成的业务流水号 
/// 修改履历：徐保保 2020 11 08
/// w ##class(BILL.EINV.COM.Common).CreateBusinessNoNew("OP") 
ClassMethod CreateBusinessNoNew(PayAdmType As %String) As %String
{
	s NowDate=$zd(+$h, 8)
	s OutBusinessNo=PayAdmType_NowDate_"-"_$i(^DHCBILLEINVBUSNO(PayAdmType,+$h))
	q OutBusinessNo
}

/// 功能说明：   通过HIs卡类型获取对应的第三方的卡类型
/// 入参：       CardType：卡类型
/// 出参：       第三方接口对应的卡类型
/// 备注说明：   目前根据HIs卡类型和第三方接口文档里面提供的卡类型在程序里面进行匹配
/// w ##class(BILL.EINV.COM.Common).GetBusCardType() 
ClassMethod GetBusCardType(CardType As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	s BusCardType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("CardTypeCon"_ObjUPConfig.FactoryCode,CardType,5)
    q BusCardType
}

/// 功能说明：   通过HIs医保类型获取对应的第三方的医保类型
/// 入参：       CardType：医保类型
/// 出参：       第三方接口对应的医保类型
/// 备注说明：   目前根据HIs医保类型和第三方接口文档里面提供的医保类型在程序里面进行匹配
/// w ##class(BILL.EINV.COM.Common).GetBusCardType() 
ClassMethod GetBusInsuType(InsuType As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	s BusInsuType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("InsuTypeCon"_ObjUPConfig.FactoryCode,InsuType,5)
    q BusInsuType
}

/// 生成纯数字的字符串
/// w ##class(BILL.EINV.COM.Common).CreateCheckeCode("6") 
/// input :OutLen  ;字符串的长度
/// output:OutInfo   ;输出字符串
ClassMethod CreateCheckeCode(OutLen As %Integer = 6) As %String
{
                       
	s OutInfo=""
	f index=1:1:OutLen d
	.s RandomIndex=$Random(10)  ;获取随机字符的索引
	.s OutInfo=OutInfo_RandomIndex
	q OutInfo
}

/// System.currentTimeMillis()产生一个当前的毫秒
/// 获取1970年1月1日到现在毫秒数
/// 时间戳
/// w ##class(BILL.EINV.COM.Common).GetcurrentTimeMillis()
ClassMethod GetcurrentTimeMillis()
{
  q +$h*86400+$p($h,",",2)-4070937600
}

/// desc：时间戳转日期 默认精确到毫秒 - 第二个参数传入 0 精确到秒
/// w ##class(BILL.EINV.COM.Common).Timestamp2DateTime(1627356127452)
/// w ##class(BILL.EINV.COM.Common).Timestamp2DateTime(1627356124, 0)
ClassMethod Timestamp2DateTime(timestamp, ms As %Boolean = 1)
{
	s timestamp = $g(timestamp)
	q:timestamp="" ""
	i ms s timestamp = timestamp \ 1000
	s datetime = timestamp + 4070937600
	s time = datetime # 86400
	s date = (datetime - time) / 86400
	s date = $zd(date, 3)
	s time = $zt(time, 1)
	s toDateTime = date _ " " _ time
	q toDateTime
}

/// desc：当前日期转时间戳 默认精确到毫秒 - 参数 0 精确到秒
/// w ##class(BILL.EINV.COM.Common).DateTime2Timestamp(0)
/// w ##class(BILL.EINV.COM.Common).DateTime2Timestamp()
ClassMethod DateTime2Timestamp(ms As %Boolean = 1)
{
	if (ms) {
		s timestamp = (+$h - 47117) * 3600 * 24 * 1000 
		s nowtimestamp = $p($zts, ",", 2) * 1000
		s timestamp = timestamp + nowtimestamp
	} else {
		s timestamp = (+$h - 47117) * 3600 * 24 
		s nowtimestamp = $p($p($zts, ",", 2), ".")
		s timestamp = timestamp + nowtimestamp
	}
	q timestamp
}

}

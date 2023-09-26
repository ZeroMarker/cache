/// 浙江省通用电子发票(用于杭州整形电子发票接口)
Class BILL.EINV.ADP.ZJA Extends %RegisteredObject
{

/// 功能说明：调用开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：guoyunlong   2020-10-18 新做成         
/// 其    他：w ##class(BILL.EINV.ADP.ZJA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	b ;开具之前先调用身份认证接口
	;acceskeyid   Url(加密文件路径)   ???需要项目上提供
	s RtnFlag="-1"
	s PersonObj=##class(BILL.EINV.DTO.ZJA.PersonSignRes).%New()
	s acceskeyid=""
	b ;正式库
    s acceskeyid="0ec8180772d54ffa87da6ee78d208c2b"
	s username="91330681MA2D80G598"
	s password="hy87221052"
	
	;测试暂时写死，后面从字典表里面去配置 20201203
	;s acceskeyid="2f344ad8eb00460bbc1ea3ee2e936053"
	;s username="91330681MA2D80G598"
	;s password="qwer1234"
	s QueryFLag=..Query(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:QueryFLag="0" "0"  ;;;查询成功，不在调用开票接口
	
	
	s sign=..GetpersonSign(acceskeyid,username,password,InvociePam,PersonObj)
	q:sign'="0" RtnFlag
	s InputJson=..InvoiceCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	b ;w InputJson
	q:InputJson="" "-1"   ;组织入参发生错误
	s ServiceCode="MES0160"
	s Message=InputJson	
	b ;;;232								;业务入参
	s ResponseData=##class(BILL.EINV.DTO.ZJA.EInvoiceRes).%New()
	s ErrMsg=""
	s outFlag=##class(BILL.EINV.BI.ZJA.HTTPRequest).InvoiceRequest(ServiceCode,Message,.ResponseData,.ErrMsg)	
    b ;;;outFlag
	if (outFlag="0") {
		 s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail,ResponseData)
		
	}else{
		 ;s ObjInvUpDetail.IUDResultCode=Rtn                ;错误信息编码
		 ;s ObjInvUpDetail.IUDResultMeg=ResponseData.resultCode     ;错误信息描述
		 ;s InvociePam.ErrMsgInfo=OutJsonStream
		 s RtnFlag="-1"
		 s InvociePam.ErrMsgInfo=ErrMsg
	}
	q RtnFlag
}

/// 组织开具接口参数
ClassMethod InvoiceCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
   s rtn=""
   //票据信息
   s invobj=##class(BILL.EINV.DTO.ZJA.EInvoiceReq).%New()
   s invobj.acceskeyid="0ec8180772d54ffa87da6ee78d208c2b"    ; 访问id
   ;s invobj.acceskeyid="2f344ad8eb00460bbc1ea3ee2e936053"    ; 访问id
   s invobj.businessType="dzswj.dzfp.fpkj"      ;业务类型
   s invobj.token=InvociePam.token        ;"ccb41b27a011468cad09cc8738e3ff38"           ;认证授权票据
   s invobj.nonce=..GetRandomNum(8)          ;随机数
   ;s invobj.timestamp=..GetBusDate(ObjInvPrtInfo.BusDate,ObjInvPrtInfo.BusTime)      ;时间戳
   s invobj.timestamp=..GetBusDate($zd(($h),3),$zt($p($h,",",2)))
   s ContextObj=##class(BILL.EINV.DTO.ZJA.EInvoiceContextReq).%New()
   s ContextObj.uuidxh=ObjInvUpDetail.IUDBusNo    ;"2008"_ObjInvUpDetail.IUDInvDr       ;开票编号???         -开票企业自有发票编号，保证本企业唯一（必需）
   ;s:ObjInvUpDetail.IUDInvDr="422275" ContextObj.uuidxh="123123123123123231223"
   s ContextObj.djxh="10213300000000313002"                              ;登记序号(可以从认证接口获取（必需）)
   s ContextObj.nsrsbh="91330681MA2D80G598"                        ;纳税人识别号(可以从认证接口获取（必需）)
   s ContextObj.nsrmc="诸暨宏宇康复医院有限公司"                         ;纳税人名称(可以从认证接口获取（必需）)
   s ContextObj.kplx="1"                            ;开票类型
   s ContextObj.kjfsbh="91330681MA2D80G598"                         ;开具方识别号 ????这个传什么
   s ContextObj.fpdm=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode                   ;发票代码
   s ContextObj.fphm=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo                   ;发票号码
   s ContextObj.hj=ObjInvPrtInfo.InvShareAmt                      ;合计金额
   s ContextObj.se="0"                      ;税额
   b ;发票类型    (01门诊,02住院)
   s ContextObj.fplx=$case(ObjInvUpDetail.IUDPayAdmType,"OP":"01","REG":"01","IP":"02") 
   s ContextObj.ybkh=ObjInvPrtInfo.InsuDivInfo.InsuId                   ;医保卡号
   s ContextObj.xm=ObjInvPrtInfo.PatBaseInfo.PatName_"("_ObjInvPrtInfo.PatBaseInfo.PAPMINO_")"                    ;姓名
   s ContextObj.sjhm=ObjInvPrtInfo.PatBaseInfo.Mobphone  ;手机号码
   s ContextObj.blh=ObjInvPrtInfo.PatAdmInfo.MedicalCode                    ;病历号
   s ContextObj.rylb=ObjInvPrtInfo.InsuDivInfo.PatType                   ;人员类别
   s ContextObj.jsrq=$zd(ObjInvPrtInfo.BusDate,3)                  ;结算日期
   s ContextObj.zyh=ObjInvPrtInfo.PatAdmInfo.MedicalCode                   ;住院号
   s ContextObj.gzdw=ObjInvPrtInfo.PatBaseInfo.JobUnit                   ;工作单位
   s ContextObj.yblx=ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc                   ;医保类型
   s ContextObj.yljglx=InvociePam.HospitalInfoMap.GetAt("HospitalType")                ;医疗机构类型
   s ContextObj.zyrq=ObjInvPrtInfo.PatAdmInfo.AdmDate_"至"_ObjInvPrtInfo.PatAdmInfo.OutDate_",共"_ObjInvPrtInfo.PatAdmInfo.IPDays_"天"     ;住院日期
   s ContextObj.skr=ObjInvPrtInfo.BusUserCode                    ;收款人
   s ContextObj.bz=""                     ;备注
   s ContextObj.ybjsxx=ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0+ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0    ;所有报销金额      ;医保结算信息
   s OtherAmt=0
   for index=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
   .s ChargeCode=ObjInvPrtInfo.InvCateInfo.GetAt(index).Code
   .s ChargeName=ObjInvPrtInfo.InvCateInfo.GetAt(index).Desc
   .s Amt=ObjInvPrtInfo.InvCateInfo.GetAt(index).Amt
   .s SelfAmt=ObjInvPrtInfo.InvCateInfo.GetAt(index).SelfAmt
   .if ChargeName="挂号费"       d
   ..s ContextObj.ghf=Amt                    ;挂号费
   .else  if (ChargeName="输氧费")&(ContextObj.fplx="01") d
   ..s ContextObj.syangf=Amt                    ;输氧费
   .else  if (ChargeName="输氧费")&(ContextObj.fplx="02") d
   ..s ContextObj.by107mc="输氧费"                  ;备用101名称
   ..s ContextObj.by107je=Amt                 ;金额
   ..s ContextObj.by107zl=SelfAmt                ;自理费
   .else  if ChargeName="中草药费" d
   ..s ContextObj.zyf=Amt                    ;中草药费
   .else  if ChargeName="诊查费" d
   ..s ContextObj.zcf=Amt                    ;诊查费/诊疗费
   ..s ContextObj.zcfzl=SelfAmt
   .else  if ChargeName="西药费" d
   ..s ContextObj.xyf=Amt                    ;西药费
   ..s ContextObj.xyfzl=SelfAmt
   .else  if ChargeName="中成药费" d
   ..s ContextObj.zcy=Amt                    ;中成药/中成费
   ..s ContextObj.zcyzl=SelfAmt               ;中成药/中成费
   .else  if ChargeName="床位费" d
   ..s ContextObj.cwf=Amt                    ;床位费
   ..s ContextObj.cwfzl=SelfAmt
   .else  if ChargeName="检查费" d
   ..s ContextObj.jcf=Amt                    ;检查费
   ..s ContextObj.jcfzl=SelfAmt                   ;检查费
   .else  if (ChargeName="化验费")&(ContextObj.fplx="01") d
   ..s ContextObj.hyf=Amt                    ;化验费
   .else  if (ChargeName="化验费")&(ContextObj.fplx="02") d
   ..s ContextObj.jyf=Amt                    ;检验费
   ..s ContextObj.jyfzl=SelfAmt                   ;检验费
   .else  if ChargeName="治疗费" d
   ..s ContextObj.zliaof=Amt                 ;治疗费
   ..s ContextObj.zliaofzl=SelfAmt                ;治疗费
   .else  if ChargeName="手术费" d
   ..s ContextObj.ssf=Amt                    ;手术费
   ..s ContextObj.ssfzl=SelfAmt                   ;手术费
   .else  if ChargeName="输血费" d
   ..s ContextObj.syf=Amt                    ;输血费
   ..s ContextObj.syfzl=SelfAmt                  ;输血费
   .else  if ChargeName="材料费" d 
   ..s ContextObj.clf=Amt                    ;材料费
   ..s ContextObj.clfzl=SelfAmt                  ;材料费
   .else  if (ChargeName="其它")||(ChargeName="其他费")    d 
   ..s ContextObj.qt=Amt                      ;其他
   ..s ContextObj.qtzl=SelfAmt                    ;其他
   .else  if ChargeName="护理费" d
   ..s ContextObj.hlf=Amt                      ;护理费
   ..s ContextObj.hlfzl=SelfAmt                 ;护理费
   .else  if (ChargeName="煎药费")&(ContextObj.fplx="02") d
   ..s ContextObj.by101mc="煎药费"
   ..s ContextObj.by101je=Amt
   ..s ContextObj.by101zl=SelfAmt
   .else  if (ChargeName="煎药费")&(ContextObj.fplx="01") d
   ..s ContextObj.by120mc="煎药费"
   ..s ContextObj.by120je=Amt
   .else  if ChargeName="空调费"&(ContextObj.fplx="02") d
   ..s ContextObj.by104mc="空调费"
   ..s ContextObj.by104je=Amt
   ..s ContextObj.by104zl=SelfAmt
   .else  if (ChargeName="空调费")&(ContextObj.fplx="01") d
   ..s ContextObj.by122mc="空调费"
   ..s ContextObj.by122je=Amt


   s ContextObj.xj=ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay10     ;现金
   s ContextObj.bnzh="" //ObjInvPrtInfo.InsuDivInfo.INPAYInsustr15                   ;本年账户
   s ContextObj.lnzh="" //ObjInvPrtInfo.InsuDivInfo.INPAYInsustr16                   ;历年账户
   ;b ;zjy111
   s ContextObj.ybzh=ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0    ;医保账户
   s ContextObj.by116mc="医保基金"
   s ContextObj.by116je=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1
   s ContextObj.yjk=ObjInvPrtInfo.DepositAmt                   ;预缴款
   s ContextObj.bjhj=ObjInvPrtInfo.RecAmt                   ;补缴款
   s ContextObj.bjxj=ObjInvPrtInfo.RecAmt                  ;补缴现金
   s ContextObj.bjzp=""                    ;补缴支票
   s ContextObj.tkhj=ObjInvPrtInfo.RefAmt                   ;退款
   s ContextObj.tkxj=ObjInvPrtInfo.RefAmt                   ;退款现金
   s ContextObj.tkzp=""                    ;退款支票
   s ContextObj.by02mc=""                  ;备用02名称
   s ContextObj.by02je=""
   s ContextObj.by03mc=""                  ;备用02名称
   s ContextObj.by03je=""
   

   
   s ContextObj.by110mc=""                  ;备用101名称
   s ContextObj.by110je=""                  ;金额
   s ContextObj.by110zl=""                  ;自理费
   
   s ContextObj.by113mc=""                  ;备用101名称
   s ContextObj.by113je=""                  ;金额
   s ContextObj.by113zl=""                  ;自理费
   
   s ContextObj.by118mc="公务员基金"                  ;备用02名称
   s ContextObj.by118je=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay3
   
   
   ;s ContextObj.by120mc="其他"                  ;备用02名称
   ;s ContextObj.by120je=""  ;ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay2+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay4+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay6
   
   ;s ContextObj.by124mc=""                  ;备用02名称
   ;s ContextObj.by124je=""
   
   b ///2020-12-28 添加挂号信息
  ;s ContextObj.ybjsxx="医保统筹支付："_ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0_"，医保账户支付："_ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0
   s ContextObj.ybjsxx=ObjInvPrtInfo.InsuDivInfo.INPAYInsustr1_", "_ObjInvPrtInfo.InsuDivInfo.INPAYInsustr3_", "_ObjInvPrtInfo.InsuDivInfo.INPAYInsustr4_", "_ObjInvPrtInfo.InsuDivInfo.INPAYInsustr5_", "_ObjInvPrtInfo.InsuDivInfo.INPAYInsustr6_", "_ObjInvPrtInfo.InsuDivInfo.INPAYInsustr7_", "_ObjInvPrtInfo.InsuDivInfo.INPAYInsustr8_", "_ObjInvPrtInfo.InsuDivInfo.INPAYInsustr9_", "_ObjInvPrtInfo.InsuDivInfo.INPAYInsustr10_", "_ObjInvPrtInfo.InsuDivInfo.INPAYInsustr11_", "_ObjInvPrtInfo.InsuDivInfo.INPAYInsustr14_", "_ObjInvPrtInfo.InsuDivInfo.INPAYInsustr15_", "_ObjInvPrtInfo.InsuDivInfo.INPAYInsustr16_", "_ObjInvPrtInfo.InsuDivInfo.INPAYInsustr17_", "_ObjInvPrtInfo.InsuDivInfo.INPAYInsustr18
  b ///2020-12-30 挂号发票不显示明细
  i (ObjInvUpDetail.IUDPayAdmType="REG")&&(ObjInvPrtInfo.RegDetails'="") d
  .s sfxmxxObj=##class(BILL.EINV.DTO.ZJA.EInvoiceContextsfmxxx).%New()
  .s sfxmxxObj.xmgg=$p(ObjInvPrtInfo.RegDetails," ",1)
  .s sfxmxxObj.lb=$P(ObjInvPrtInfo.RegDetails," ",2)
  .d ContextObj.sfmxxx.Insert(sfxmxxObj)
  e  d
  .for Index=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
  ..s sfxmxxObj=##class(BILL.EINV.DTO.ZJA.EInvoiceContextsfmxxx).%New()
  ..s Tardesc=ObjInvPrtInfo.InvItmDetInfo.GetAt(Index).TarDesc   ;$tr( ,"[","")
  ..;s Tardesc=$tr(Tardesc,"]","") 
  ..s Spec=$tr(ObjInvPrtInfo.InvItmDetInfo.GetAt(Index).Spec,"[","")
  ..s Spec=$tr(Spec,"]","")
  ..s sfxmxxObj.xmgg=Tardesc_" "_Spec                   ;项目规格
  ..;s sfxmxxObj.lb=ObjInvPrtInfo.InvItmDetInfo.GetAt(Index).Insuxmlb                        ;类别
  ..s sfxmxxObj.lb=ObjInvPrtInfo.InvItmDetInfo.GetAt(Index).ChrgType
  ..s sfxmxxObj.sl=ObjInvPrtInfo.InvItmDetInfo.GetAt(Index).Qty                       ;数量
  ..s sfxmxxObj.je=ObjInvPrtInfo.InvItmDetInfo.GetAt(Index).Amt                       ;金额
  ..s sfxmxxObj.se2="0"                       ;税额
  ..s sfxmxxObj.zlzf=ObjInvPrtInfo.InvItmDetInfo.GetAt(Index).INDISScale                  ;自理自费 全是0？ zjy
  ..d ContextObj.sfmxxx.Insert(sfxmxxObj)
  
  b  ;调用平台加密content
  s datastream=##class(%GlobalCharacterStream).%New()
  d ##class(ext.util.JsonObject).ObjectToJSONStream(ContextObj,.datastream)
  ;b ;1111
  ;s soap=##class(web.DHCENS.SOAPNew.PUB0014Soap).%New()
  ;s result=soap.encryptData("MES0090",datastream) 
  s result=##class(web.DHCENS.BLL.Invoice.RSAUtil).RSAEncrypt(datastream.Read())
  ;b ;2222
  s jsonString={}.%FromJSON(result)
  s data1=jsonString.%Get("data")
  ;s data2=$zcvt(data1,"O","URL")
  b ;result
  s invobj.content=data1   ;ContextObj
  ;//调用固定方法进行对象转Json
  s Stream=##class(%GlobalCharacterStream).%New()
  d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
  s rtn=Stream.Read()
  q rtn
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ResultMegObj As BILL.EINV.DTO.ZJA.EInvoiceRes) As %String
{
	s RtnFlg="-1"
	
	//对返回结果的时间戳进行分割
	s createDate=ResultMegObj.data.kprq 					;返回日期"2019-12-17"
	s createDate=$zdh(createDate,3)
	s ObjInvUpDetail.IUDResultCode=ResultMegObj.resultCode					;处理结果代码
	//s ObjInvUpDetail.IUDResultMeg=ResultMegObj.resultMsg				;详细信息
	s ObjInvUpDetail.IUDCreatDate=createDate							;电子票据生成日期
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.data.fpdm      ;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.data.fphm     ;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=ResultMegObj.data.uuid                ;校验码
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.data.pdfurl		;电子票据H5页面URL
	;s ObjInvUpDetail.IUDBusNo= ""      ;开票流水号
    s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"										;发票状态
	s RtnFlg="0"
	
	q RtnFlg
}

/// 功能说明：根据不同的业务类型分别调用不同冲红接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：guoyunlong   2020-05-24  
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invalid("","","") 
ClassMethod Invalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"	
	;s ^zjy("Invalid")=ObjInvUpDetail_"~"_ObjInvPrtInfo_"~"_InvociePam
	;开具之前先调用身份认证接口
	s PersonObj=##class(BILL.EINV.DTO.ZJA.PersonSignRes).%New()
	s acceskeyid=""
	;测试暂时写死，后面从字典表里面去配置 20201203
    ;s acceskeyid="ffdb74461f5d40639dcefe7e625982e0"
	;s username="913301007735976708"
	;s password="qwer1234"
	;正式库
	s acceskeyid=""
	s username=""
	s password=""
	s sign=..GetpersonSign(acceskeyid,username,password,InvociePam,PersonObj)
	q:sign'="0" RtnFlag
	b ;接口服务名称
	s InputJson=..InvalidCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	b ;InputJson
	q:InputJson="" RtnFlag 
	s Message=InputJson									;业务入参
	s ServiceCode="MES0162"
	s ResponseData=##class(BILL.EINV.DTO.ZJA.EInvalidRes).%New()
	b ;接口入参
	s ErrMsg=""
	s outFlag=##class(BILL.EINV.BI.ZJA.HTTPRequest).InvoiceRequest(ServiceCode,Message,.ResponseData,.ErrMsg)
	b ;outFlag
	s OutJsonStream=""
	if (outFlag="0") {
		s RtnFlag=..SetInvResultOfInvalid(ObjInvUpDetail,ResponseData)  ;;把红冲开票结果信息保存到交易表
		s RtnFlag="0"
	}else{
		//s ObjInvUpDetail.IUDResultCode=Rtn                	;错误信息编码
		//s ObjInvUpDetail.IUDResultMeg=OutJsonStream     	;错误信息描述
		//s InvociePam.ErrMsgInfo=OutJsonStream
		s RtnFlag="-1"
		s InvociePam.ErrMsgInfo=ErrMsg
		//s RtnFlag="0"
	}
	q RtnFlag
}

/// 组织红冲接口参数
ClassMethod InvalidCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
   s rtn=""
   //票据信息
   s invobj=##class(BILL.EINV.DTO.ZJA.EInvalidReq).%New()
   s invobj.acceskeyid="0ec8180772d54ffa87da6ee78d208c2b"
   ;s invobj.acceskeyid="2f344ad8eb00460bbc1ea3ee2e936053"
   s invobj.businessType="dzswj.dzfp.fpzf"         ;RtnFlag
   s invobj.token=InvociePam.token     
   s invobj.nonce=..GetRandomNum(8)          ;随机数
   ;s invobj.timestamp=..GetBusDate(ObjInvPrtInfo.BusDate,ObjInvPrtInfo.BusTime)      ;时间戳
   s invobj.timestamp=..GetBusDate($zd(($h),3),$zt($p($h,",",2)))
   s contextobj=##class(BILL.EINV.DTO.ZJA.EInvalidContextReq).%New()
   s contextobj.kprq=$zd(ObjInvUpDetail.OriInvUpDetail.IUDCreatDate,3)
   s contextobj.hj=ObjInvUpDetail.OriInvUpDetail.IUDCreatAmt
   s contextobj.fphm=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo
   s contextobj.fpdm=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode
   
   b  ;调用平台加密content
   s datastream=##class(%GlobalCharacterStream).%New()
   d ##class(ext.util.JsonObject).ObjectToJSONStream(contextobj,.datastream)
   s result=##class(web.DHCENS.BLL.Invoice.RSAUtil).RSAEncrypt(datastream.Read())
   ;s soap=##class(web.DHCENS.SOAPNew.PUB0014Soap).%New()
   b ;s result=soap.encryptData("MES0090",datastream) 
   s jsonString={}.%FromJSON(result)
   s data1=jsonString.%Get("data")
   s invobj.content=data1
   //调用固定方法进行对象转Json
   s Stream=##class(%GlobalCharacterStream).%New()
   d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
   s rtn=Stream.Read()
   q rtn
}

/// 功能说明：设置红票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ResultMegObj As BILL.EINV.DTO.ZJA.EInvalidRes) As %String
{
	s RtnFlg="-1"
	
	//对返回结果的时间戳进行分割
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.data.fpdm      ;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.data.fphm     ;电子票据号码
	s ObjInvUpDetail.IUDResultCode=ResultMegObj.resultCode
    s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="作废成功"   						   ;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="S"										;发票状态
	s RtnFlg="0"
	
	q RtnFlg
}

/// 功能说明：   通过日期时间获取对应的第三方上传时间格式
/// 入参：       Date：日期
/// 				 Time: 时间
/// 出参：       第三方接口对应的上传时间格式(格式：yyyyMMddHHmmssSSS)
/// w ##class(BILL.EINV.ADP.ZJA).GetBusDate("2020-01-01","15:30:20")
ClassMethod GetBusDate(Date, Time) As %String
{
	/*
	s rtnDate=""
	i Date'["-" d  s Date=$zd(Date,3)
	i Time'[":" d  s Time=$zt(Time,1)
	s rtnDate=$replace(Date,"-","")_$replace(Time,":","")_$e($p($zts,".",2),1,3)
	q rtnDate
	
	s rtnDate=""
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
	s rtnDate=$e($replace(Date,"-","")_$replace(Time,":",""),1,13)   ;_SSSTime
	q rtnDate
	*/
	;生成13位时时间戳
	s rtnDate=""
	;i Date'["-" d  s Date=$zd(Date,3)
	;i Time'[":" d  s Time=$zt(Time,1)
	s rtnDate=($p($p($zts,".",1)-$zdh("1970-01-01",3),",",1)*24*3600+$p($p($zts,".",1),",",2))*1000+$p($zts,".",2)
	q rtnDate
}

/// 获取随机数
/// input:Len -随机数长度
/// output: 随机数
/// 其    他：w ##class(BILL.EINV.ADP.ZJA).GetRandomNum(10) 
ClassMethod GetRandomNum(Len As %String) As %String
{
	    s RandLen=0
		if (RandLen<Len){       ;位数不足时，在前边补充随机字符串
		s RandomArr="ABCDEFGHIGKLMNOPQRSTUVWXY1234567890"    ;随机字符从这个字符串中获取
		s RandNum=$l(RandomArr)                              ;用来产生随机数,用作查询随机字符的索引
		s AddInfo=""
		s AddLen=Len-RandLen
		f index=1:1:AddLen d
		.s RandomIndex=$Random(RandNum)  ;获取随机字符的索引
		.s RandomIndex=RandomIndex+1  ;获取字符串的值从1开始，但是获取的随机数从0开始，所以这里加1
		.s:RandomIndex>RandNum RandomIndex=RandNum
		.s RandomChar=$e(RandomArr, RandomIndex, RandomIndex)  ;获取随机字符
		.s AddInfo=AddInfo_RandomChar
		q AddInfo
		
	}
}

/// 功能说明： 对第三方返回的json加密数据进行解析
/// w ##class(BILL.EINV.ADP.JSC).DecryptionResult("","")
ClassMethod DecryptionResult(Response, ByRef ErrMsg As %String, ByRef ResultObj As BILL.EINV.DTO.ZJA.EInvoiceRes) As %String
{
	s Rtn="-1"
	s ResultStream=##class(%GlobalCharacterStream).%New()
	d ResultStream.Write(Response)
	d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.ResultObj,"")
	s Rtn=ResultObj.resultCode
	s ErrMsg=ResultObj.resultMsg
	q Rtn
}

/*
/// 获取身份认证接口
/// 2020-11-20
/// guoyunlong 
/// 要求：密码采用RSA非对称加密    --公钥文件：swj.cer
/// input :InputStr---访问id^用户登录名^用户密码
///       FileUrl  ---RSA 加密文件路径
/// w ##class(BILL.EINV.ADP.ZJA).GetpersonSign("","","","")
ClassMethod GetpersonSign(acceskeyid As %String, username As %String, password As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef PersonSignRes As BILL.EINV.DTO.ZJA.PersonSignRes) As %String
{
	///用户名需要用RSA加密
	s EinvFlag="-1"
	
	;s acceskeyid="ffdb74461f5d40639dcefe7e625982e0"
	;s username="913301007735976708"
	;s password="qwer1234"
	q:(acceskeyid="")||(username="")||(password="") EinvFlag
	;加密调用平台接口加密
	s passwordRSA=##class(BILL.EINV.ADP.ZJA).RSAencrypt(password)
	;s passwordRSA=##class(web.Util.Encryption).HexRSAEncrypt(password,FileUrl)  ;RSA加密
	;s passwordBase64= ##class(web.Util.Encryption).Base64Encode(passwordRSA)
	;s passwordBase64=$zcvt(passwordRSA,"O","UTF8")
	;s passwordBase64New=$zcvt(passwordBase64,"O","URL")
	s PersonSignObj=##class(BILL.EINV.DTO.ZJA.PersonSignReq).%New()
	s PersonSignObj.acceskeyid=acceskeyid    ;访问id   --测试-b252ac5cebfc4c26a0b5187fc3926491 生产：5c7fb50f0f9d4ce9839b055e31f73225
	s PersonSignObj.username=username        ;用户登录名
	s PersonSignObj.password=passwordRSA      ;用户密码
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(PersonSignObj,.Stream)
	;s Message=Stream.Read()
	;调用第三方接口获取身份认证返回值
	s ServiceCode="MES0069"
	s Flag=##class(BILL.EINV.BI.ZJA.HTTPRequest).InvoiceRequest(ServiceCode,Stream,.PersonSignRes)	;平台接口
	b ;;s PersonSignRes=##class(BILL.EINV.DTO.ZJA.PersonSignRes).%New()
	;d ##class(ext.util.JsonObject).ObjectToJSONStream(.PersonSignRes,outData)
	i Flag="0" d
	.s InvociePam.token=PersonSignRes.data.token
	.s EinvFlag="0"
	q EinvFlag
}
*/
/// 获取身份认证接口
/// 2020-11-20
/// guoyunlong 
/// 要求：密码采用RSA非对称加密    --公钥文件：swj.cer
/// input :InputStr---访问id^用户登录名^用户密码
///       FileUrl  ---RSA 加密文件路径
/// w ##class(BILL.EINV.ADP.ZJA).GetpersonSign("0ec8180772d54ffa87da6ee78d208c2b","91330681MA2D80G598","hy87221052","","")
ClassMethod GetpersonSign(acceskeyid As %String, username As %String, password As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef PersonSignRes As BILL.EINV.DTO.ZJA.PersonSignRes) As %String
{
	///用户名需要用RSA加密
	s EinvFlag="-1"
	;q:(acceskeyid="")||(username="")||(password="") EinvFlag
	;s acceskeyid="2f344ad8eb00460bbc1ea3ee2e936053"
	;s username="91330681MA2D80G598"
	;s password="qwer1234"
	s acceskeyid="0ec8180772d54ffa87da6ee78d208c2b"
	s username="91330681MA2D80G598"
	s password="hy87221052"
	s passwordJson=##class(web.DHCENS.BLL.Invoice.RSAUtil).RSAEncrypt(password)
	s JsonData={}.%FromJSON(passwordJson)
	s password=JsonData.data
	s PersonSignObj=##class(BILL.EINV.DTO.ZJA.PersonSignReq).%New()
	s PersonSignObj.acceskeyid=acceskeyid    ;访问id   --测试-b252ac5cebfc4c26a0b5187fc3926491 生产：5c7fb50f0f9d4ce9839b055e31f73225
	s PersonSignObj.username=username        ;用户登录名
	s PersonSignObj.password=password        ;用户密码
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(PersonSignObj,.Stream)
	s Message=Stream.Read()
	b ;调用第三方接口获取身份认证返回值
	s ServiceCode="MES0159"
	s outFlag=##class(BILL.EINV.BI.ZJA.HTTPRequest).InvoiceRequest(ServiceCode,Message,.PersonSignRes)	;平台接口
	if outFlag="0" d
	.s InvociePam.token=PersonSignRes.data.token
	.s EinvFlag="0"
	;b //d ##class(ext.util.JsonObject).ObjectToJSONStream(.PersonSignRes,outData)
	/*
	s outData=outData.Read()
	s outData={}.%FromJSON(outData)
	s resultCode=outData.resultCode
	if resultCode="000000"  d
	.s resultObj=outData.resultObj
	.s resultObjData=##class(web.DHCENS.BLL.Invoice.RSAUtil).RSADecrypt(resultObj)
	.do ##class(ext.util.JsonObject).JSONStreamToObject(resultObjData,.PersonSignRes)
	.s EinvFlag="0"
	.s InvociePam.token=PersonSignRes.data.token
	*/
	q EinvFlag
}

ClassMethod Query(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	;开具之前先调用身份认证接口
	;acceskeyid   Url(加密文件路径)   ???需要项目上提供
	s RtnFlag="-1"
	s PersonObj=##class(BILL.EINV.DTO.ZJA.PersonSignRes).%New()
	s acceskeyid=""
	;测试暂时写死，后面从字典表里面去配置 20201203
	;s acceskeyid="2f344ad8eb00460bbc1ea3ee2e936053"
	;s username="91330681MA2D80G598"
	;s password="qwer1234"
	;正式库
	s acceskeyid="0ec8180772d54ffa87da6ee78d208c2b"
	s username="91330681MA2D80G598"
	s password="hy87221052"
	s sign=..GetpersonSign(acceskeyid,username,password,InvociePam,PersonObj)
	q:sign'="0" RtnFlag
	s InputJson=..QueryEinvInfo(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:InputJson="" "-1"   ;组织入参发生错误
	s ServiceCode="MES0161"
	s Message=InputJson	
	b ;;;232
	s ErrMsg=""								;业务入参
	s ResponseData=##class(BILL.EINV.DTO.ZJA.EInvoiceRes).%New()
	s outFlag=##class(BILL.EINV.BI.ZJA.HTTPRequest).InvoiceRequest(ServiceCode,Message,.ResponseData,.ErrMsg)	
    b ;;;outFlag
	if (outFlag="0") {
		 s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail,ResponseData)
		
	}else{
		 ;s ObjInvUpDetail.IUDResultCode=Rtn                ;错误信息编码
		 ;s ObjInvUpDetail.IUDResultMeg=ResponseData.resultCode     ;错误信息描述
		 ;s InvociePam.ErrMsgInfo=OutJsonStream
		 s RtnFlag="-1"
		 s InvociePam.ErrMsgInfo=ErrMsg
	}
	q RtnFlag
}

/// w ##class(BILL.EINV.ADP.ZJA).GetRandom()
/// 电子发票查询
/// w ##class(BILL.EINV.BI.BSA.HTTPRequest).QueryEinvInfo("12","34")
ClassMethod QueryEinvInfo(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam)
{
	s RtnFlag="-1"
	
	s invobj=##class(BILL.EINV.DTO.ZJA.EInvalidReq).%New()
   s invobj.businessType="dzswj.dzfp.fpcx"         ;RtnFlag
   s invobj.acceskeyid="0ec8180772d54ffa87da6ee78d208c2b"
   s invobj.token=InvociePam.token     
   s invobj.nonce=..GetRandomNum(8)          ;随机数
   ;s invobj.timestamp=..GetBusDate(ObjInvPrtInfo.BusDate,ObjInvPrtInfo.BusTime)      ;时间戳
   s invobj.timestamp=..GetBusDate($zd(($h),3),$zt($p($h,",",2)))
   s contextobj=##class(BILL.EINV.DTO.ZJA.EInvQueryReq).%New()
   s contextobj.uuid=ObjInvUpDetail.IUDBusNo  ;"2008"_ObjInvUpDetail.IUDInvDr
   b  ;调用平台加密content
   s datastream=##class(%GlobalCharacterStream).%New()
   d ##class(ext.util.JsonObject).ObjectToJSONStream(contextobj,.datastream)
   s result=##class(web.DHCENS.BLL.Invoice.RSAUtil).RSADecrypt(datastream.Read())
   s jsonString={}.%FromJSON(result)
   s data1=jsonString.%Get("data")
   s invobj.content=data1
   //调用固定方法进行对象转Json
   s Stream=##class(%GlobalCharacterStream).%New()
   d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
   ;q Stream
   s rtn=Stream.Read()
   q rtn
}

}

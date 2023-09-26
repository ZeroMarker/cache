Import sqluser

/// Descript:	四川阳光采购平台接口
/// Creater:	lihui
/// CreateDate:	20221112
Class web.DHCSTMHUI.ServiceForSCYGCG Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	高值使用记录
/// Creater:	zhangxiao
/// CreateDate:	2019-10-28
/// Table://CALL web_DHCSTMHUI.ServiceForSZYGCG_GetHvDispList("2020-12-24","2020-12-24")	
/// d ##Class(%ResultSet).RunQuery("web.DHCSTMHUI.ServiceForSCYGCG","GetHvDispList","2020-12-24","2020-12-24")
Query GetHvDispList(StartDate As %String = "", EndDate As %String = "") As websys.Query(ROWSPEC = "USED_ID:%String,DOC_ID_CARD:%String,DOC_NAME:%String,DPT_NAME:%String,PATIENT_NAME:%String,PATIENT_ID_CARD:%String,SEX:%String,JBZD_ID:%String,JBZD_NAME:%String,IS_IMPLANTCONSUME:%String,GOODS_ID_PROVINCE:%String,GOODS_CODE_ID_PROVICE:%String,YB_CODE:%String,GOODS_ID:%String,GOODS_NAME:%String,OUTLOOKC:%String,GOODS_TYPE:%String,COMPANY_ID_SC:%String,COMPANY_NAME_SC:%String,REGE_CODE:%String,USED_TIME:%String,USED_COUNT:%String,USED_PRICE:%String,USED_UNIT:%String,BATCH_CODE:%String,UDI:%String,CZYMD:%String,SCYMD:%String") [ SqlProc ]
{
}

ClassMethod GetHvDispListExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:StartDate="" StartDate=+h-1
	s:EndDate="" EndDate=+h-1
	
	
	f Date=StartDate:1:EndDate d
	.s OriId=0
	.f  s OriId=$o(^DHCHVMORI(0,"DATE",Date,OriId)) q:OriId=""  d    ;根据高值医嘱消耗日期统计数据
	..s Oeori=$p(^DHCHVMORI(OriId,1),"^",1)  	;医嘱子表id
	..s Ord=+Oeori,Chl=$p(Oeori,"||",2)
	..q:(Ord="")!(Chl="")
	..s Ostat=$p(^OEORD(Ord,"I",Chl,1),"^",13)	;医嘱状态id
    ..s Oeflag=$p(^OEC("OSTAT",Ostat),"^",1)
    ..q:(Oeflag="C")||(Oeflag="U")||(Oeflag="D")	;撤销,作废,停止 的医嘱不再处理
    ..s OrdDoc=$p(^OEORD(Ord,"I",Chl,1),"^",11)		;开医嘱医生
    ..s OrdDept=$p(^OEORD(Ord,"I",Chl,1),"^",3)		;开医嘱科室
    ..s Deptdesc=$p(^CTLOC(OrdDept),"^",1)			;医生所属科室
	..s DocCode=$p(^CTPCP(OrdDoc,1),"^",1)
	..s DocName=$p(^CTPCP(OrdDoc,1),"^",2)		;医生姓名
	..s DicID="",DocIDNO=""
	..if $d(^DHCINDID("0","ITypeCode","DoctorCodeConXZA",DocCode))  d
	...s DicID=$O(^DHCINDID("0","ITypeCode","DoctorCodeConXZA",DocCode,DicID))
	...s DocIDNO=$p( ^DHCINDID(DicID),"^",5 )  //医生身份证号
	..s Adm=$p(^OEORD(Ord),"^",1)
	..s papmidr=$p(^PAADM(Adm),"^",1)
	..s (PatName,Sex,CardNo)=""
	..i papmidr'="" d
	...s PatName=$p($g(^PAPER(papmidr,"ALL")),"^",1)	;患者姓名
	...s sexdr=$p($g(^PAPER(papmidr,"ALL")),"^",7)
	...s:sexdr'="" Sex=$p(^CT("SEX",sexdr),"^",1)		;患者性别
	...s Carddr=$o(^DHCCARDi("CF",0,"PAPMIDR",papmidr,""))
	...s:+Carddr'=0 CardNo=$p(^DHCCARD("CF",Carddr),"^",2)  ;患者就诊卡号
	..
	..s Diagstr="^"
	..s Diagstr=..GetDiagTotal(Adm)
	..s Inci=$p(^DHCHVMORI(OriId,1),"^",34)  ;库存项Id
	..q:Inci=""
	..s Barcode=$p(^DHCHVMORI(OriId,1),"^",24)
	..q:Barcode=""
	..s Dhcit=$o(^DHCIT(0,"LABEL",Barcode,0))
    ..s:Dhcit="" Dhcit=$o(^DHCIT(0,"ORIGINALCODE",Barcode,0))
    ..q:Dhcit=""
    ..
    ..s (INFOImplantationMat,ImplantFlag,Spec,Model,ManfId,ManfCode,ManfDesc)=""
    ..s Info=$O(^DHCITMINFO(0,"INCI",Inci,0))
    ..s:Info'="" INFOImplantationMat=$p(^DHCITMINFO(Info),"^",62) ;植入
	..s:INFOImplantationMat="Y" ImplantFlag=1
	..s:INFOImplantationMat'="Y" ImplantFlag=0
	..
	..s InciCode=$p(^INCI(Inci,1),"^",1)	;院内物资代码
	..s InciDesc=$p(^INCI(Inci,1),"^",2) 	;院内物资名称
	..s:Info'="" Spec=$p(^DHCITMINFO(Info),"^",27)		;院内规格
	..s:Info'="" Model=$p(^DHCITMINFO(Info),"^",59)		;型号
	..s ManfId=$p(^DHCIT(Dhcit),"^",15) ;厂商
	..s:ManfId'="" ManfCode=$p(^PHMNF(ManfId),"^",1)	;院内生产企业代码
	..s:ManfId'="" ManfDesc=$p(^PHMNF(ManfId),"^",2)	;院内生产企业名称
	..s (RegCertNo)=""
	..&sql(select IR_RegCertNo into:RegCertNo from DHC_ItmRemark where IR_INCI_DR=:Inci) ;注册证号
	..s UseDate=Date
	..s:UseDate'="" UseDate=$zd(UseDate,3)
	..s Qty=$p(^DHCHVMORI(OriId,1),"^",19)		;使用数量
	..s Sp=$p(^DHCHVMORI(OriId,1),"^",21)		;使用售价
	..s UomId=$p(^DHCHVMORI(OriId,1),"^",18)	;使用单位
	..s UomDesc=""
	..s:UomId'="" UomDesc=$p(^CT("UOM",UomId),"^",2)
	..s BatNo=$p(^DHCHVMORI(OriId,1),"^",13)  ;批号
	..s UDI="" ;耗材唯一标识 不知道取取什么
	..s Time=$p(^DHCHVMORI(OriId,1),"^",9)  ;使用时间
	..s:Time'="" Time=$zt(Time)
	..s UseDate=UseDate_" "_Time
	..s Today=+$H
	..s:Today'="" Today=$zd(Today,3)
	..s NowTime=$p($H,",",2)
	..s:NowTime'="" NowTime=$zt(NowTime)
	..s Today=Today_" "_NowTime
	..
	..s TarID=""
	..s InsuCode=""
	..if $d(^DHCTARI(0,"Code",InciCode))  d
	...s TarID=$O(^DHCTARI(0,"Code",InciCode,TarID))
	...s InsuInfo=$$GetConInfo^DHCINSUTarContrast(TarID,"GDSZ",$zd(+$h,3))
	...s InsuCode=$p(InsuInfo,"^",3)
	..s (MatRowid,SubcodeId,YGCGCode,YGCGSpec)=""
	..s PurItmRelId=$o(^DHCItmPCRelation(0,"INCI",Inci,0))	;阳光采购对照关系表ID
	..i PurItmRelId'="" d
	...s MatRowid=$p(^DHCItmPCRelation(PurItmRelId),"^",2)	;采购目录表ID
	...s SpecListId=$p(^DHCItmPCRelation(PurItmRelId),"^",3)	;采购规格型号表ID
	...s:MatRowid'="" YGCGCode=$p(^DHCMatPurCataLog(MatRowid),"^",3)		;采购平台产品码
	...s:(MatRowid'="")&&(SpecListId'="") YGCGSpec=$p($g(^DHCMatPurCataLog(MatRowid,"SMList",SpecListId)),"^",4)
	..
	..Set USEDID=Oeori			//使用ID
	..Set DOCIDCARD=DocIDNO		//医生身份证号
	..Set DOCNAME=DocName		//医生姓名
	..Set DPTNAME=Deptdesc		//医生所属科室名称
	..Set PATIENTNAME=PatName	//患者姓名
	..Set PATIENTIDCARD=CardNo	//患者就诊卡证号码
	..Set SEX=Sex				//患者性别代码
	..Set JBZDID=$p(Diagstr,"^",1)		//诊断疾病编码
	..Set JBZDNAME=$p(Diagstr,"^",2)	//诊断疾病名称
	..Set ISIMPLANTCONSUME=ImplantFlag	//是否植入性耗材
	..Set GOODSIDPROVINCE=YGCGCode		//采购平台产品码
	..Set GOODSCODEIDPROVICE=YGCGSpec	//采购平台规格型号码
	..Set YBCODE=InsuCode		//医保编码
	..Set GOODSID=InciCode		//院内产品码
	..Set GOODSNAME=InciDesc	//院内产品名称
	..Set OUTLOOKC=Spec			//院内使用规格
	..Set GOODSTYPE=Model		//院内使用型号
	..Set COMPANYIDSC=ManfCode  //院内产品生产企业编号
	..Set COMPANYNAMESC=ManfDesc		//院内产品生产企业名称
	..set:RegCertNo="" RegCertNo="无"
	..Set REGECODE=RegCertNo	//院内产品注册证号
	..Set USEDTIME=UseDate		//院内使用时间
	..Set USEDCOUNT=Qty			//院内使用数量
	..Set USEDPRICE=Sp			//使用单价（元）
	..Set USEDUNIT=UomDesc		//使用单位
	..Set BATCHCODE=BatNo		//使用生产批号
	..Set UDI=UDI				//耗材唯一标识
	..Set CZYMD=UseDate			//记录操作时间
	..Set SCYMD=Today			//记录上传时间
	..d OutputHvDispList
	
	Quit $$$OK
	
OutputHvDispList
	set:USEDID="" USEDID="无"
	set:DOCIDCARD="" DOCIDCARD="无"
	set:DOCNAME="" DOCNAME="无"
	set:DPTNAME="" DPTNAME="无"
	set:PATIENTNAME="" PATIENTNAME="无"
	set:PATIENTIDCARD="" PATIENTIDCARD="无"
	set:SEX="" SEX="无"
	set:JBZDID="" JBZDID="无"
	set:JBZDNAME="" JBZDNAME="无"
	set:ISIMPLANTCONSUME="" ISIMPLANTCONSUME="无"
	set:GOODSIDPROVINCE="" GOODSIDPROVINCE="无"
	set:GOODSCODEIDPROVICE="" GOODSCODEIDPROVICE="无"
	set:YBCODE="" YBCODE="无"
	set:GOODSID="" GOODSID="无"
	set:GOODSNAME="" GOODSNAME="无"
	set:OUTLOOKC="" OUTLOOKC="无"
	set:GOODSTYPE="" GOODSTYPE="无"
	set:COMPANYIDSC="" COMPANYIDSC="无"
	set:COMPANYNAMESC="" COMPANYNAMESC="无"
	set:REGECODE="" REGECODE="无"
	set:USEDTIME="" USEDTIME="无"
	set:USEDCOUNT="" USEDCOUNT="无"
	set:USEDPRICE="" USEDPRICE="无"
	set:USEDUNIT="" USEDUNIT="无"
	set:BATCHCODE="" BATCHCODE="无"
	set:UDI="" UDI="无"
	set:CZYMD="" CZYMD="无"
	set:SCYMD="" SCYMD="无"
	set Data=$lb(USEDID,DOCIDCARD,DOCNAME,DPTNAME,PATIENTNAME,PATIENTIDCARD,SEX,JBZDID,JBZDNAME,ISIMPLANTCONSUME,GOODSIDPROVINCE,GOODSCODEIDPROVICE,YBCODE,GOODSID,GOODSNAME,OUTLOOKC,GOODSTYPE,COMPANYIDSC,COMPANYNAMESC,REGECODE,USEDTIME,USEDCOUNT,USEDPRICE,USEDUNIT,BATCHCODE,UDI,CZYMD,SCYMD)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// w ##Class(web.WYDHelpTool).GetDiagTotal("9475816")
ClassMethod GetDiagTotal(adm)
{
 s mrDiaDesc=""
 s curDia="^"
 s mrAdmId=$P(^PAADM(adm),"^",61)
 s mrDiaChild=0
 f  s mrDiaChild=$O(^MR(mrAdmId,"DIA",mrDiaChild)) q:(mrDiaChild="")  d
 .s curDiaDesc=""
 .s mrDiaId=$p($G(^MR(mrAdmId,"DIA",mrDiaChild)),"^",1)
 .i mrDiaId'=""  d
 ..s curDia=$p($G(^MRC("ID",mrDiaId)),"^",1)_"^"_$p($G(^MRC("ID",mrDiaId)),"^",2)
 q curDia
}

/// ------同步信息到采购平台-----
/// 下载 商品列表 以及 医院常用商品目录
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).GetProductInfo("1","","","271","21297")
ClassMethod GetProductInfo(CurPage As %String, GoodIds As %String = "", UserId As %String, ProcurecatalogType As %String, ScBid As %String)
{
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||GetProductInfo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetProductInfo(CurPage,GoodIds,UserId,ProcurecatalogType,ScBid)
	q Ret
}

/// HUI查询采购目录信息
ClassMethod JSQueryMatPurCatalogNew(page As %String, rows As %String, Params As %String = "")
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||JSQueryMatPurCatalogNew"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryMatPurCatalogNew(page,rows, Params)
	q Ret
}

/// 判断inci是否有对照记录(对照之前调用)
ClassMethod UpDateInciLogFlag(Inci)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||UpDateInciLogFlag"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).UpDateInciLogFlag(Inci)
	q Ret
}

/// 对照/取消对照关系
ClassMethod SaveRelaInfo(Inci As %String, Matrowid As %String, UpFlag As %String)
{
	s ^litmp("SaveRelaInfo")=$lb(Inci,Matrowid,UpFlag)
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||SaveRelaInfoSC"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).SaveRelaInfoSC(Inci, Matrowid,UpFlag)
	q Ret
}

/// 同步单个订单 生成订单 实时同步调用
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).UpLoadPo()
ClassMethod UpLoadPo(PoId As %String)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||UpLoadPo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).UpLoadPo(PoId)
	q Ret
}

/// 查询订单状态
ClassMethod JSQueryPoItmInfo(PoId, Page)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||JSQueryPoItmInfo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryPoItmInfo(PoId,Page)
	q Ret
}

/// 查询订单配送信息
ClassMethod JSQueryPoItmDispatching(PoId, Page)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||JSQueryPoItmDispatching"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryPoItmDispatching(PoId,Page)
	q Ret
}

/// 关联订单配送信息到高值入库单
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).JSLinkInGdRec(1161)
ClassMethod JSLinkInGdRec(ListData)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||JSLinkInGdRec"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSLinkInGdRec(ListData)
	q Ret
}

/// 获取依据订单保存入库单所需要的主信息
ClassMethod GetPoInfoById(PoId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||GetPoInfoById"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetPoInfoById(PoId)
	q Ret
}

/// 获取依据订单保存入库单所需要的明细信息 EXT版本
ClassMethod GetPoItmInfo(orderDetailId, PoId, HighFlag = "N")
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||GetPoItmInfo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetPoItmInfo(orderDetailId, PoId,HighFlag)
	q Ret
}

/// 获取依据订单保存入库单所需要的明细信息 HisUI版本
ClassMethod GetPoItmInfoHisUI(orderDetailId, PoId, HighFlag = "N")
{
	s ^tmpli("GetPoItmInfo22")=$lb(orderDetailId, PoId)
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||GetPoItmInfoHisUI"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetPoItmInfoHisUI(orderDetailId, PoId,HighFlag)
	q Ret
}

/// Descript:   批量上传订单
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).JsSendInpoStr(1161)
ClassMethod JsSendInpoStr(PoIdStr) As %String
{
    n (PoIdStr)
    s ^litmp("JsSendInpoStr")=PoIdStr
    s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
    s del="^"
    s (result,sucret,failret)=""
    s (suc,fail)=0
	s len=$l(PoIdStr,del)
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||UpLoadPo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.f i=1:1:len  d
    ..s PoId=$p(PoIdStr,del,i)
    ..s ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).UpLoadPo(PoId)
    ..s retcode=$p(ret,"^",1)
    ..s retmsg=$p(ret,"^",2)
    ..i retcode=0 d
    ...s suc=suc+1
    ...i sucret'="" s sucret=sucret_"^"_PoId
  	...e  s sucret=PoId
  	..e  d
  	...s fail=fail+1
  	...i failret'="" s failret=failret_"^"_PoId_":"_retmsg
  	...e  s failret=PoId_":"_retmsg
  	...
  	d RtnObj.Err(0,"",suc_"@"_fail_"@"_sucret_"@"_failret,"",0)
  	q RtnObj.Json()
}

/// Descript:   批量上传入库单
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).JsSendIngrStr(1161)
ClassMethod JsSendIngrStr(IngrStr) As %String
{
    n (IngrStr)
    s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
    s del="^"
    s (result,sucret,failret)=""
    s (suc,fail)=0
	s len=$l(IngrStr,del)
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||JSAddIngdrec"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.f i=1:1:len  d
    ..s Ingr=$p(IngrStr,del,i)
    ..s ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSAddIngdrec(Ingr)
    ..s retcode=$p(ret,"^",1)
    ..s retmsg=$p(ret,"^",2)
    ..i retcode=1 d
    ...s suc=suc+1
    ...i sucret'="" s sucret=sucret_"^"_Ingr
  	...e  s sucret=Ingr
  	..e  d
  	...s fail=fail+1
  	...i failret="" s failret=Ingr_retmsg
  	...e  s failret=failret_"^"_Ingr_retmsg
  	
  	d RtnObj.Err(0,"",suc_"@"_fail_"@"_sucret_"@"_failret,"",0)
  	q RtnObj.Json()
}

/// Descript:   批量上传退货单
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).JsSendRetStr(1161)
ClassMethod JsSendRetStr(RetStr) As %String
{
    n (RetStr)
    s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
    s del="^"
    s (result,sucret,failret)=""
    s (suc,fail)=0
	s len=$l(RetStr,del)
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||JSAddReturn"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.f i=1:1:len  d
    ..s Ingdret=$p(RetStr,del,i)
    ..s ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSAddReturn(Ingdret)
    ..s retcode=$p(ret,"^",1)
    ..s retmsg=$p(ret,"^",2)
    ..i retcode=0 d
    ...s suc=suc+1
    ...i sucret'="" s sucret=sucret_"^"_Ingdret
  	...e  s sucret=Ingdret
  	..e  d
  	...s fail=fail+1
  	...i failret'="" s failret=failret_"^"_retmsg
  	...e  s failret=retmsg
  	
  	d RtnObj.Err(0,"",suc_"@"_fail_"@"_sucret_"@"_failret,"",0)
  	q RtnObj.Json()
}

/// 查询退货信息
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).JSQueryRetInfo(29,"","",1)
ClassMethod JSQueryRetInfo(IngdRet, Page = 1)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||JSQueryRetInfoAll"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryRetInfoAll(IngdRet,Page)
	q Ret
}

/// Descript:   批量上传付款单
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).JsSendInpoPayStr(1161)
ClassMethod JsSendInpoPayStr(PayIdStr) As %String
{
    n (PayIdStr)
    s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
    s del="^"
    s (result,sucret,failret)=""
    s (suc,fail)=0
	s len=$l(PayIdStr,del)
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||UpLoadInpoPay"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.f i=1:1:len  d
    ..s PayId=$p(PayIdStr,del,i)
    ..s ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).UpLoadInpoPay(PayId)
    ..s retcode=$p(ret,"^",1)
    ..s retmsg=$p(ret,"^",2)
    ..i retcode=0 d
    ...s suc=suc+1
    ...i sucret'="" s sucret=sucret_"^"_Ingdret
  	...e  s sucret=Ingdret
  	..e  d
  	...s fail=fail+1
  	...i failret'="" s failret=failret_"^"_retmsg
  	...e  s failret=retmsg
  	
  	d RtnObj.Err(0,"",suc_"@"_fail_"@"_sucret_"@"_failret,"",0)
  	q RtnObj.Json()
}

/// 查询支付单信息
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).JSQueryInpoPayItmInfo(29,1)
ClassMethod JSQueryInpoPayItmInfo(PayId, Page = 1)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||JSQueryInpoPayItmInfo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryInpoPayItmInfo(PayId,Page)
	q Ret
}

/// 获取规格型号编号、产品编号、规格、型号
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).GetSubCode(Inci)
ClassMethod GetSubCode(Inci)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||GetSubCode"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetSubCode(Inci)
	q Ret
}

/// 上传入库单 使用批量上传方法
ClassMethod AddIngdrec(IngdId)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||AddIngdrec"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddIngdrec(IngdId)
	q Ret
}

/// 上传退货单 使用批量上传方法
ClassMethod AddReturn(IngdRet)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||AddReturn"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).AddReturn(IngdRet)
	q Ret
}

/// Descript:   拒绝收货  未使用
ClassMethod RefuseRec(ParamStr) As %String
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||RefuseRec"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).RefuseRec(ParamStr)
	q Ret
}

/// 下载合同目录
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).GetProContInfo("1","2021-04-15","2021-04-16","","6423")
ClassMethod GetProContInfo(CurPage As %String, PCStartDate As %String = "", PCEndDate As %String = "", contractIds As %String = "", UserId As %String)
{
	s ^litmp("getpro")=$lb(CurPage, PCStartDate, PCEndDate, contractIds, UserId)
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||GetProductInfo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetProContInfo(CurPage,PCStartDate, PCEndDate,contractIds,UserId)
	q Ret
}

/// 查询合同信息 HISUI Ext
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).JSQueryProContract("1","15","")
ClassMethod JSQueryProContract(page As %String, rows As %String, Params As %String = "")
{
	s ^litmp("JSQueryProContract")=$lb(page,rows,Params)
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||JSQueryProContract"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryProContract(page,rows, Params)
	q Ret
}

/// 查询企业信息 HISUI Ext
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).JSQueryCompany("1","100","^上海微创医疗器械（集团）有限公司^")
ClassMethod JSQueryCompany(page As %String, rows As %String, Params As %String = "")
{
	s ^litmp("JSQueryCompany")=$lb(page,rows,Params)
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||JSQueryCompany"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryCompany(page,rows, Params)
	q Ret
}

/// 下载企业信息 HISUI Ext
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).GetCompanyInfo()
ClassMethod GetCompanyInfo(CurPage As %String = "1", StartDate As %String, EndDate As %String, companyIds As %String, userID As %String)
{
	s ^litmp("JSDownCompany")=$lb(CurPage,StartDate,EndDate,companyIds,userID)
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||GetCompanyInfo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetCompanyInfo(CurPage,StartDate,EndDate,companyIds,userID)
	q Ret
}

/// 企业对照/取消对照关系 HIStype 企业类型 HISUI Ext
ClassMethod SaveComRelaInfo(CompanyId As %String, RowId As %String, UpFlag As %String, HIStype As %String)
{
	s ^litmp("SaveComRelaInfo")=$lb(CompanyId,RowId,UpFlag,HIStype)
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||SaveComRelaInfo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).SaveComRelaInfo(CompanyId, RowId,UpFlag,HIStype)
	q Ret
}

/// 根据HIS id 获取企业对照信息
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).getComRelaInfo()
ClassMethod getComRelaInfo(Vendid As %String, HIStype As %String)
{
	s ^litmp("SaveComRelaInfo")=$lb(Vendid,HIStype)
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||getComRelaInfo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).getComRelaInfo(Vendid,HIStype)
	q Ret
}

/// 判断库存项属于 试剂MR/耗材MM/其他M
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).GetInciFlag()
ClassMethod GetInciFlag(Inci As %String)
{
	n (Inci)
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||GetInciFlag"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).GetInciFlag(Inci)
	q Ret
}

/// -------------------------Ext---------------------------
/// Ext查询采购目录信息
ClassMethod JSQueryMatPurCatalog(Start As %String, Limit As %String, Params As %String = "")
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||JSQueryMatPurCatalogNew"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSQueryMatPurCatalogNew(Start, Limit, Params)
	q Ret
}

/// Descript:   批量上传订单
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).JsSendInpoStrExt(1161)
ClassMethod JsSendInpoStrExt(PoIdStr) As %String
{
    n (PoIdStr)
    s del="^"
    s (result,sucret,failret)=""
    s (suc,fail)=0
	s len=$l(PoIdStr,del)
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||UpLoadPo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.f i=1:1:len  d
    ..s PoId=$p(PoIdStr,del,i)
    ..s ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).UpLoadPo(PoId)
    ..s retcode=$p(ret,"^",1)
    ..s retmsg=$p(ret,"^",2)
    ..i retcode=0 d
    ...s suc=suc+1
    ...i sucret'="" s sucret=sucret_"^"_PoId
  	...e  s sucret=PoId
  	..e  d
  	...s fail=fail+1
  	...i failret'="" s failret=failret_"^"_PoId_":"_retmsg
  	...e  s failret=PoId_":"_retmsg
  	...
  	q suc_"@"_fail_"@"_sucret_"@"_failret
}

/// Descript:   批量上传入库单
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).JsSendIngrStrExt(1161)
ClassMethod JsSendIngrStrExt(IngrStr) As %String
{
    n (IngrStr)
    s del="^"
    s (result,sucret,failret)=""
    s (suc,fail)=0
	s len=$l(IngrStr,del)
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||JSAddIngdrec"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.f i=1:1:len  d
    ..s Ingr=$p(IngrStr,del,i)
    ..s ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSAddIngdrec(Ingr)
    ..s retcode=$p(ret,"^",1)
    ..s retmsg=$p(ret,"^",2)
    ..i retcode=1 d
    ...s suc=suc+1
    ...i sucret'="" s sucret=sucret_"^"_Ingr
  	...e  s sucret=Ingr
  	..e  d
  	...s fail=fail+1
  	...i failret="" s failret=Ingr_retmsg
  	...e  s failret=failret_"^"_Ingr_retmsg
  	
  	q suc_"@"_fail_"@"_sucret_"@"_failret
}

/// Descript:   批量上传退货单
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).JsSendRetStrExt(1161)
ClassMethod JsSendRetStrExt(RetStr) As %String
{
    n (RetStr)
    s del="^"
    s (result,sucret,failret)=""
    s (suc,fail)=0
	s len=$l(RetStr,del)
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||JSAddReturn"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.f i=1:1:len  d
    ..s Ingdret=$p(RetStr,del,i)
    ..s ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSAddReturn(Ingdret)
    ..s retcode=$p(ret,"^",1)
    ..s retmsg=$p(ret,"^",2)
    ..i retcode=0 d
    ...s suc=suc+1
    ...i sucret'="" s sucret=sucret_"^"_Ingdret
  	...e  s sucret=Ingdret
  	..e  d
  	...s fail=fail+1
  	...i failret'="" s failret=failret_"^"_retmsg
  	...e  s failret=retmsg
  	
  	q suc_"@"_fail_"@"_sucret_"@"_failret
}

/// Descript:   批量上传付款单
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).JsSendInpoPayStrExt(1161)
ClassMethod JsSendInpoPayStrExt(PayIdStr) As %String
{
    n (PayIdStr)
    s del="^"
    s (result,sucret,failret)=""
    s (suc,fail)=0
	s len=$l(PayIdStr,del)
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||UpLoadInpoPay"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.f i=1:1:len  d
    ..s PayId=$p(PayIdStr,del,i)
    ..s ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).UpLoadInpoPay(PayId)
    ..s retcode=$p(ret,"^",1)
    ..s retmsg=$p(ret,"^",2)
    ..i retcode=0 d
    ...s suc=suc+1
    ...i sucret'="" s sucret=sucret_"^"_Ingdret
  	...e  s sucret=Ingdret
  	..e  d
  	...s fail=fail+1
  	...i failret'="" s failret=failret_"^"_retmsg
  	...e  s failret=retmsg
  	
  	q suc_"@"_fail_"@"_sucret_"@"_failret
}

/// 关联订单配送信息到高值入库单 Ext
/// w ##class(web.DHCSTMHUI.ServiceForSCYGCG).JSLinkInGdRecExt(1161)
ClassMethod JSLinkInGdRecExt(ListData)
{
	s Ret=""
	s ClassMethodStr="web.DHCSTMService.YGCG.YGCGForSCHISUIClient||JSLinkInGdRecExt"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCSTMService.YGCG.YGCGForSCHISUIClient).JSLinkInGdRecExt(ListData)
	q Ret
}

}

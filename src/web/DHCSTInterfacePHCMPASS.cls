/// description: 药房药库组-调用东华知识库接口类
Class web.DHCSTInterfacePHCMPASS Extends %RegisteredObject
{

/// creator: 	yunhaibao
/// createdate: 2018-03-05
/// description:调用知识库
/// input:		主医嘱Id,处方号,用户Id^登陆科室Id^安全组Id,chkType(Q(查询适应症等),C(合理分析)...)
/// output:		[{"manLevel":"C","passFlag":"1","retMsg":""}] 	
/// others:		处方号不为空时按处方号获取
/// return:		json	
/// w ##class(web.DHCSTInterfacePHCMPASS).LibPhaCheckOrder("1271||92-65540","","711^248^136","C")
ClassMethod LibPhaCheckOrder(mOeori, prescNo, userInfo, chkType)
{
	s $zt="LibPhaCheckOrderErr"
	i mOeori["-" s mOeori=$p(mOeori,"-",1)
	s ^TMPDHCSTPARAMS("web.DHCSTInterfacePHCMPASS","LibPhaCheckOrder")=$lb(mOeori, prescNo, userInfo, chkType)
	s ordData=..PreparePassOrdData(mOeori,prescNo)
	q:$p(ordData,"^",1)<0 ordData
	s retValue=##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,chkType,ordData,userInfo)
	q retValue
LibPhaCheckOrderErr
	q "-1"_"^"_..Get("程序错误：处方 ")_prescNo_" "_$ze
}

/// creator:	yunhaibao
/// createdate: 2018-03-05
/// description:药典提示
/// input:		医嘱Id,用户Id^登陆科室Id^安全组Id,chkType(Q(查询适应症等),C(合理分析),Q1(静配专用查询)...)
/// output：	Q:适应证@/$ 适应证消息1 /n  适应证消息2 /n   !   禁忌证@/$ 消息1/n消息2 ！ 
/// return:	 	string   			
/// w ##class(web.DHCSTInterfacePHCMPASS).LibPhaMedTips("2335||4","10213^246^37","Q")
ClassMethod LibPhaMedTips(oeori, userInfo, chkType)
{
	s ^TMPDHCSTPARAMS("web.DHCSTInterfacePHCMPASS","LibPhaMedTips")=$lb(oeori, userInfo, chkType)
	i oeori["-" s mOeori=$p(oeori,"-",1)
	s ordData=..GetOeoriData(oeori)
	s retValue=##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,chkType,"!"_ordData,userInfo)
	q:chkType="Q1" retValue
	s retInfo=$p(retValue,"^",3)
	i (retInfo="")||(retInfo="!!!!!")  d
	.s retInfo=..Get("药典提示")_"@/$"_..Get("药典信息无维护！")
	q retInfo
}

/// creator: 	yunhaibao
/// createdate: 2018-03-05
/// description:根据主医嘱Id组织知识库分析需要的数据格式 
/// input:		$p(inputStr,"^",1)(主医嘱Id)
/// output:     医嘱项id^用法id^频次id^剂量^剂量单位^总量^总量单位^疗程id^关联号( 是否成组医嘱$c(1)医嘱序号 ) ^标本^部位^接收科室id^医嘱id  (没有时为空即可)
/// w ##class(web.DHCSTInterfacePHCMPASS).PreparePassOrdData("461||142")
ClassMethod PreparePassOrdData(mOeori, prescNo)
{
	q:(prescNo="")&&(mOeori="") "-1"_"^"_..Get("主医嘱Id为空")
	s ordData="",orderId=""
	i prescNo'="" d
	.s ordId=""
	.f  s ordId=$o(^OEORD(0,"PrescNo",prescNo,ordId)) q:ordId=""  d
	..s orderId=ordId
	..s ordItm=""
	..f  s ordItm=$o(^OEORD(0,"PrescNo",prescNo,ordId,ordItm)) q:ordItm=""  d
	...q:+ordItm=0
	...s oeoriData=..GetOeoriData(ordId_"||"_ordItm)
	...q:oeoriData=""
	...s ordData=$s(ordData="":oeoriData,1:ordData_$c(2)_oeoriData)
	e  d
	.s oeoriData=..GetOeoriData(mOeori)
	.s ordData=oeoriData
	.s ordId=+mOeori
	.s orderId=ordId
	.s ordItm=""
 	.f  s ordItm=$O(^OEORDi(0,"OEORI",ordId,mOeori,ordItm)) Q:ordItm=""  D
 	..s oeori=ordId_"||"_ordItm
 	..s oeoriData=..GetOeoriData(oeori)
 	..q:oeoriData=""
 	..s ordData=$s(ordData="":oeoriData,1:ordData_$c(2)_oeoriData)
 	q:orderId="" "-1"_"^"_..Get("获取不到医嘱数据")
 	s admId=$p(^OEORD(orderId),"^",1)
 	q admId_"!"_ordData
}

/// creator: 	yunhaibao
/// createdate: 2018-03-05
/// description:获取单条医嘱数据
/// input:		oeori(医嘱Id)
/// output:     医嘱项id^用法id^频次id^剂量^剂量单位^总量^总量单位^疗程id^关联号( 是否成组医嘱$c(1)医嘱序号 ) ^标本^部位^接收科室id^医嘱id  (没有时为空即可)
/// w ##class(web.DHCSTInterfacePHCMPASS).GetOeoriData("83||7")
ClassMethod GetOeoriData(oeori)
{
	s ordId=+oeori
	s ordItm=+$p(oeori,"||",2)
	q:(ordId=0)||(ordItm=0) ""
	s oeStateId=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",13)
	S oeStateCode=$p($g(^OEC("OSTAT",+oeStateId)),"^",1)
	q:(oeStateCode'="V")&&(oeStateCode'="E") "" 
	s arcItmId=$P($g(^OEORD(ordId,"I",ordItm,1)),"^",2)
	s instrucId=$p($g(^OEORD(ordId,"I",ordItm,2)),"^",7)
	q:instrucId="" ""
	s freqId=$p($g(^OEORD(ordId,"I",ordItm,2)),"^",4)
	s doseQty=$p($g(^OEORD(ordId,"I",ordItm,2)),"^",1)
	s doseUom=$p($g(^OEORD(ordId,"I",ordItm,2)),"^",3)
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	q:dspId="" ""
	s dspQty=$p(^DHCOEDISQTY(dspId),"^",5)
	s incId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
	q:incId="" 0
	s bUom=$p(^INCI(incId,1),"^",10) 
	s duratId=$p($g(^OEORD(ordId,"I",ordItm,2)),"^",4)
	s grpFlag=0	// 是否成组
	s mOeori=..GetMainOeori(oeori)
	i $d(^OEORDi(0,"OEORI",+mOeori,mOeori)) d
	.s grpFlag=1
	.s seqNo=grpFlag_$c(1)_(ordItm-$p(mOeori,"||",2)+1)
	e  s seqNo=""
	s bb=""	// 标本
	s bw="" // 部位
	s recLocId=$p($g(^OEORD(ordId,"I",ordItm,3)),"^",6)
	s retData1=arcItmId_"^"_instrucId_"^"_freqId_"^"_doseQty_"^"_doseUom
	s retData2=dspQty_"^"_doseUom_"^"_duratId_"^"_seqNo_"^"_bb
	s retData3=bw_"^"_recLocId_"^"_oeori
	q retData1_"^"_retData2_"^"_retData3
}

ClassMethod GetMainOeori(oeori As %String) As %String
{
	Q:oeori="" ""
 	S ordId=$p(oeori,"||",1) Q:ordId="" ""
 	S ordItm=$p(oeori,"||",2) Q:ordItm="" ""
 	Q:'$D(^OEORD(ordId,"I",ordItm,1)) ""
 	Q:'$D(^OEORD(ordId,"I",ordItm,11)) ""
 	S linkOeori=$P(^OEORD(ordId,"I",ordItm,11),"^",39)
 	Q:linkOeori'="" linkOeori
 	Q oeori
}

ClassMethod Get(str)
{
    q ##class(PHA.COM.Base).Get(str)
}

}

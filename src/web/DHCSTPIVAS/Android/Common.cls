Import sqluser

/// creator:	 yunhaibao
/// createdate:  2018-02-26
/// description: 静脉配液中心PDA公共类
Class web.DHCSTPIVAS.Android.Common Extends %RegisteredObject [ ProcedureBlock ]
{

/// desciption: 登陆调用
/// input: userCode(工号),passWord(密码)
/// output:
/// w ##class(web.DHCSTPIVA.Android.Common).Logon("pivas",1)
ClassMethod Logon(userCode, passWord) As %String
{
	q:userCode="" ..Msg("false","用户名为空","warn")
	q:passWord="" ..Msg("false","密码为空","warn")
	s $zt="ErrorLogon"
	s validUser=##class(web.SSUser).IsValidUser(userCode,passWord)
	s validCode=$p(validUser,"^",1)
	s validMsg=$p(validUser,"^",2)
	i validCode<=0 d
	.i validMsg="UserNotFindErr" s validMsg="用户名不存在"
	.i validMsg="UnActiveErr" s validMsg="用户未激活"
	.i validMsg="DateFromScopeErr" s validMsg="未到用户开启日"
	.i validMsg="DateToScopeErr" s validMsg="用户有效期已过"
	.i validMsg="PasswordErr" s validMsg="密码错误"
	q:validMsg'="" ..Msg("false",validMsg,"warn")
	s userId=+validUser
	s userCode=$p(^SSU("SSUSR",userId),"^",1)
	s userName=$p(^SSU("SSUSR",userId),"^",2)
	s locsJson=..GetUserLoc(userId)
	q:locsJson.Count()=0 ..Msg("false","用户没有可登录科室","warn")
	s dataJson=##class(%ArrayOfDataTypes).%New()
	d dataJson.SetAt(locsJson,"Locs")
	d dataJson.SetAt(userId,"userId")
	d dataJson.SetAt(userName,"userName")
	d dataJson.SetAt(userCode,"userCode")	
	d dataJson.SetAt(1,"passWord")	
	s logonJson=##class(%ArrayOfDataTypes).%New()
	d logonJson.SetAt("true","Success")
	d logonJson.SetAt("success","MsgType")
	d logonJson.SetAt(dataJson,"Data")
	q ##class(Nur.JSON).Encode(logonJson)

ErrorLogon
	q ..Msg("false",$ze,"error")
}

/// description: 获取用户登陆科室以及其他登录科室
/// return:json 数据
ClassMethod GetUserLoc(userId) As %ListOfDataTypes
{
	s locsJson=##class(%ListOfDataTypes).%New()
	q:+userId=0 locsJson
	s locId=$p(^SSU("SSUSR",userId),"^",4)
	s locDesc=$p(^CTLOC(locId),"^",2)
	s grpId=$p(^SSU("SSUSR",userId),"^",5)
	s grpDesc=$p(^SSU("SSGRP",grpId),"^",1)
	i (locId'="")&&(grpId'="") d
	.s locJson=##class(%ArrayOfDataTypes).%New()
	.d locJson.SetAt(locId,"locId")
	.d locJson.SetAt(locDesc,"locDesc")
	.d locJson.SetAt(grpId,"grpId")
	.d locJson.SetAt(grpDesc,"grpDesc")
	.d locsJson.Insert(locJson)
	s userOther=""
	f  s userOther=$o(^SSU("SSUSR",userId,"OTHLL",userOther)) q:userOther=""  d
	.s locId=$p(^SSU("SSUSR",userId,"OTHLL",userOther),"^",1)
	.q:locId=""
	.s locDesc=$p(^CTLOC(locId),"^",2)
	.s grpId=$p(^SSU("SSUSR",userId,"OTHLL",userOther),"^",2)
	.q:grpId=""
	.s grpDesc=$p(^SSU("SSGRP",grpId),"^",1)
	.s locJson=##class(%ArrayOfDataTypes).%New()
	.d locJson.SetAt(locId,"locId")
	.d locJson.SetAt(locDesc,"locDesc")
	.d locJson.SetAt(grpId,"grpId")
	.d locJson.SetAt(grpDesc,"grpDesc")
	.d locsJson.Insert(locJson)
	q locsJson
}

/// description: 执行方法返回输出信息
/// input: success(true,false),msg(返回信息描述),msgType(错误级别,warn,error,"")
/// w ##class(web.DHCSTPIVAS.Android.Common).Msg("2",1,3)
ClassMethod Msg(success, msg, msgType) As %String
{
	s msgJson=##class(%ArrayOfDataTypes).%New()
	d msgJson.SetAt(success,"Success")
	d msgJson.SetAt(msg,"Data")
	d msgJson.SetAt(msgType,"MsgType")
	q ##class(Nur.JSON).Encode(msgJson)
}

/// description:扫码调用
/// input:   	barCode(条码), psNumber(预执行状态标识号), userId(用户Id), locId(科室Id)
/// output:		$p(ret,"^",1)<0 失败,$p(ret,"^",1) 失败信息1176-309-1^101^711^80
/// w ##class(web.DHCSTPIVAS.Android.Common).ExecuteByBarCode("1176-309-3","80","711","101")
ClassMethod ExecuteByBarCode(barCode As %String, psNumber As %String, userId As %String, locId As %String = "") As %String
{
	s $zt="ErrorExecuteByBarCode"
	s retStr=##class(web.DHCSTPIVAS.DataHandler).ExecuteByBarCode(barCode,psNumber,userId,locId)
	s retVal=$p(retStr,"^",1)
	s retMsg=$p(retStr,"^",2)
	q:+retVal<0 ..Msg("false",retMsg,"warn")
	// 如下获取数据必然成功,因此不考虑失败
	s:barCode["-" barCode=$p(barCode,"-",1)_"||"_$p(barCode,"-",2)_"||"_$p(barCode,"-",3)
	s mDsp=$o(^DHCOEDISQTY(0,"OEORE",barCode,""))
	q:mDsp="" ..Msg("false","条码不存在","warn")
    s grpNo=$p(^DHCOEDISQTY(mDsp),"^",4)
    q:mDsp="" ..Msg("false","不存在轮次","warn")
	s pogId=$o(^PIVA(0,"OEGRP",mDsp,grpNo,""))
	q:pogId="" ..Msg("false","尚未打签","warn")
	// 最后的json
	s retJson=##class(%ArrayOfDataTypes).%New()	
	// 明细数据的json
	s dataJson=##class(%ArrayOfDataTypes).%New()
	// 主信息数据
	s ordMainJson=..JsonOrdMain(mDsp)
	d dataJson.SetAt(ordMainJson,"OrdMain")
	// 明细药品数据
	s ordDetailJson=..JsonOrdDetail(mDsp)
	d dataJson.SetAt(ordDetailJson,"OrdDetail")
	d retJson.SetAt("true","Success")
	d retJson.SetAt("success","MsgType")
	d retJson.SetAt(dataJson,"Data")
	q ##class(Nur.JSON).Encode(retJson)
ErrorExecuteByBarCode
	q ..Msg("false",$ze,"error")
}

/// description:条码信息(病人\药品\批次\剂量\频次\用法等)
/// w ##class(web.DHCSTPIVAS.Android.Common).GetBarCodeInfo("1220-44-88")
ClassMethod GetBarCodeInfo(barCode As %String)
{
	s $zt="ErrorGetBarCodeInfo"
	q:barCode="" ..Msg("false","条码为空","warn")
	s:barCode["-" barCode=$p(barCode,"-",1)_"||"_$p(barCode,"-",2)_"||"_$p(barCode,"-",3)
	s mDsp=$o(^DHCOEDISQTY(0,"OEORE",barCode,""))
	q:mDsp="" ..Msg("false","条码不存在","warn")
    s grpNo=$p(^DHCOEDISQTY(mDsp),"^",4)
    q:mDsp="" ..Msg("false","不存在轮次","warn")
	s pogId=$o(^PIVA(0,"OEGRP",mDsp,grpNo,""))
	q:pogId="" ..Msg("false","尚未打签","warn")
	// 最后的json
	s retJson=##class(%ArrayOfDataTypes).%New()
	// 明细数据的json
	s dataJson=##class(%ArrayOfDataTypes).%New()
	// 主信息数据
	s ordMainJson=..JsonOrdMain(mDsp)
	d dataJson.SetAt(ordMainJson,"OrdMain")
	// 明细药品数据
	s ordDetailJson=..JsonOrdDetail(mDsp)
	d dataJson.SetAt(ordDetailJson,"OrdDetail")
	// 扫描记录数据
	s ordExecuteJson=..JsonOrdExecute(mDsp)
	d dataJson.SetAt(ordExecuteJson,"ordExecute")	
	d retJson.SetAt("true","Success")
	d retJson.SetAt("success","MsgType")
	d retJson.SetAt(dataJson,"Data")
	q ##class(Nur.JSON).Encode(retJson)
ErrorGetBarCodeInfo
	q ..Msg("false",$ze,"error")
}

/// description:获取病人主信息\病区\批次等
/// return:		Json
/// w ##class(web.DHCSTPIVAS.Android.Common).JsonOrdMain(311920)
ClassMethod JsonOrdMain(mDsp) As %ArrayOfDataTypes
{
	s ordMainJson=##class(%ArrayOfDataTypes).%New()
	s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
    s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
    s wardDesc=$p(^PAWARD(wardId),"^",2)
    s grpNo=$p(^DHCOEDISQTY(mDsp),"^",4)
	s pogId=$o(^PIVA(0,"OEGRP",mDsp,grpNo,""))
	s batNo=$p(^PIVA(pogId),"^",3)_"批"
    s mOeori=$p(^DHCOEDISQTY(mDsp),"^",1)
    s mOrdId=+mOeori
    s doseDate=$p(^DHCOEDISQTY(mDsp),"^",21)
	s doseDateHtml=##class(web.DHCSTPIVAS.Common).DateShortFormat(doseDate)
    s doseTime=$p(^DHCOEDISQTY(mDsp),"^",20)
    s doseTimeHtml=##class(web.DHCSTPIVAS.Common).TimeShortFormat(doseTime)
    s doseDateTime=doseDateHtml_" "_doseTimeHtml
	s instructDesc=$p(##class(web.DHCSTPIVAS.Common).OeoriInstruc(mOeori),"^",2)
	s freqDesc=$p(##class(web.DHCSTPIVAS.Common).OeoriFreq(mOeori),"^",2)
	s priDesc=$p(##class(web.DHCSTPIVAS.Common).OeoriPriority(mOeori),"^",3)
	s admId=$p(^OEORD(mOrdId),"^",1)
	s bedId=$p(^PAADM(admId),"^",73)
	s patId=$p(^PAADM(admId),"^",1) 
	s wardSub=+bedId
	s bedSub=+$p(bedId,"||",2)
	s bedNo=$p($g(^PAWARD(wardSub,"BED",bedSub)),"^",1)
	s patWeight=##class(web.DHCSTPIVAS.Common).GetPatWeight(admId)
	s patHeight=##class(web.DHCSTPIVAS.Common).GetPatHeight(admId)
	s patName=$p(^PAPER(patId,"ALL"),"^",1)
	s patNo=$p(^PAPER(patId,"PAT",1),"^",1)
	s patSex=+$p(^PAPER(patId,"ALL"),"^",7)
	s patSex=$p($g(^CT("SEX",patSex)),"^",2)
	s patAge=##class(web.DHCSTKUTIL).GetAge(patId,admId)
	d ordMainJson.SetAt(patNo,"patNo")
	d ordMainJson.SetAt(patName,"patName")
	d ordMainJson.SetAt(patSex,"patSex")
	d ordMainJson.SetAt(patWeight,"patWeight")
	d ordMainJson.SetAt(patHeight,"patHeight")
	d ordMainJson.SetAt(wardDesc,"wardDesc")
	d ordMainJson.SetAt(bedNo,"bedNo")
	d ordMainJson.SetAt(freqDesc,"freqDesc")
	d ordMainJson.SetAt(instructDesc,"instrDesc")
	d ordMainJson.SetAt(priDesc,"priDesc")
	d ordMainJson.SetAt(batNo,"batNo")
	d ordMainJson.SetAt(patAge,"patAge")
	d ordMainJson.SetAt(doseDateTime,"doseDateTime")
	q ordMainJson
	q ##class(Nur.JSON).Encode(ordMainJson)
}

/// description:获取药品明细信息
/// return:		Json
/// w ##class(web.DHCSTPIVAS.Android.Common).JsonOrdDetail(311920)
ClassMethod JsonOrdDetail(mDsp) As %ListOfDataTypes
{
	s detailSJson=##class(%ListOfDataTypes).%New()
	s grpNo=$p($g(^DHCOEDISQTY(mDsp)),"^",4)
	q:grpNo="" detailSJson
	s pogId=$o(^PIVA(0,"OEGRP",mDsp,grpNo,""))
	s pogItm=""
	f  s pogItm=$o(^PIVA(pogId,"I",pogItm)) q:pogItm=""  d
	.q:+pogItm=0
	.s detailJson=##class(%ArrayOfDataTypes).%New()
	.s dspId=$p(^PIVA(pogId,"I",pogItm),"^",1)
	.q:'$d(^DHCOEDISQTY(dspId))
	.s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
	.s incDesc=$p(##class(web.DHCSTPIVAS.Common).GetIncItmByOeori(oeori),"^",3)
	.d detailJson.SetAt(incDesc,"incDesc")
	.s dosage=##class(web.DHCSTPIVAS.Common).OeoriDosage(oeori)
	.d detailJson.SetAt(dosage,"dosage")
	.d detailSJson.Insert(detailJson)
	q detailSJson
	q ##class(Nur.JSON).Encode(detailSJson)
}

/// description:获取状态执行记录信息
/// return:		Json
ClassMethod JsonOrdExecute(mDsp) As %ListOfDataTypes
{
	s oeore=$p(^DHCOEDISQTY(mDsp),"^",3)
	s result=##class(%Library.ResultSet).%New("web.DHCSTPIVAS.Dictionary:LabelExeRecords")
	s sc=result.Execute(oeore)
	s dataJson=##class(%ListOfDataTypes).%New()
	s colNum=result.GetColumnCount()
	While(result.Next())
	{ 
		s recordJson=##class(%ArrayOfDataTypes).%New()
		f i=1:1:colNum d
		.d recordJson.SetAt(result.GetData(i),result.GetColumnName(i))
		d dataJson.Insert(recordJson)
	}
	q dataJson
	q ##class(Nur.JSON).Encode(dataJson)
}

/// description:设置Pda将要显示的模块
/// w ##class(web.DHCSTPIVAS.Android.Common).PdaMainViews(1)
ClassMethod PdaMainViews(locId)
{
	s $zt="ErrPdaMainViews"
	q:locId="" ..Msg("false","登陆科室为空","warn")
	s dataJson=##class(%ArrayOfDataTypes).%New()
	s psDescS="排药贴签,进仓核对,仓内配置,出仓复核,打包配送,条码追溯,NFC测试"
	// 进对应图标名称,源代码中必须有该图标
	s psDrawS="paiyao_normal,hedui_normal,peiyao_normal,fuhe_normal,peisong_normal,zhuisuo_normal,nfc_normal"
	s psNumS="40,50,60,70,80,1001,1002"
	d dataJson.SetAt(psDescS,"psDescS")
	d dataJson.SetAt(psDrawS,"psDrawS")
	d dataJson.SetAt(psNumS,"psNumS")
	s retJson=##class(%ArrayOfDataTypes).%New()
	d retJson.SetAt("true","Success")	
	d retJson.SetAt(dataJson,"Data")
	q ##class(Nur.JSON).Encode(retJson)
ErrPdaMainViews	
	q ..Msg("false",$ze,"error")
}

/// 暂未使用
/// description:条码信息(病人\药品\批次\剂量\频次\用法等)
/// input:		barCode(条码),retType(输出类型)
/// w ##class(web.DHCSTPIVAS.Android.Common).OeoriInfo("75-1-1","String")
ClassMethod OeoriInfo(barCode As %String, retType = "")
{
	q:$l(barCode,"-")'=3 ..Msg("false","标签错误","warn")
	q:barCode="" ..Msg("false","标签为空","warn")
	s barCode=$replace(barCode,"-","||")
	s ord=$p(barCode,"||",1)
	s itm=$p(barCode,"||",2)
	s exe=$p(barCode,"||",3)
	s mOeori=ord_"||"_itm
	s mOeore=ord_"||"_itm_"||"_exe
	s dspId=$o(^DHCOEDISQTY(0,"OEORE",mOeore,""))
	q:dspId="" ..Msg("false","获取不到医嘱信息","warn")
	s grpNo=$p(^DHCOEDISQTY(dspId),"^",4)
	S mDsp=##class(web.DHCSTPIVAS.Common).GetMainDspId(dspId,grpNo)
	q:mDsp="" ..Msg("false","获取不到医嘱打包记录","warn")
	s pogId=$o(^PIVA(0,"OEGRP",mDsp,grpNo,""))
	q:pogId="" ..Msg("false","尚未打印标签","warn")
	q:'$d(^PIVA(pogId)) ..Msg("false","无此标签","warn")
	s phacId=$P(^PIVA(pogId),"^",10)
 	q:phacId="" ..Msg("false","取标签信息错误,获取不到Phac","warn")
	s admId=$p(^OEORD(ord),"^",1) 
	s patId=$p(^PAADM(admId),"^",1) 
	s patName=$P(^PAPER(patId,"ALL"),"^",1)
	s patNo=$p(^PAPER(patId,"PAT",1),"^",2) 
	s patAge=##class(web.DHCSTKUTIL).GetAge(patId)
    s patSex=$p(^PAPER(patId,"ALL"),"^",7)
    s patSex=$p($g(^CT("SEX",+patSex)),"^",2)	
    S bedId=$P(^PAADM(admId),"^",73)
 	S bedNo="*"
 	i bedId'="" s bedNo=$p($g(^PAWARD(+bedId,"BED",+$p(bedId,"||",2))),"^",1)
	s instrucStr=##class(web.DHCSTPIVAS.Common).OeoriInstruc(mOeori)
	s instrucDesc=$p(instrucStr,"^",2)
	s freqStr=##class(web.DHCSTPIVAS.Common).OeoriFreq(mOeori)
	s freqDesc=$p(freqStr,"^",2)
	s doseTime=$p(^DHCOEDISQTY(mDsp),"^",20)
	s doseDate=$p(^DHCOEDISQTY(mDsp),"^",21)
	s doseTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(doseTime)
	s doseDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(doseDate)
	s doseDateTime=doseDate_" "_doseTime
	s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
	s wardDesc=$p(^CTLOC(wardLocId),"^",2)
 	// 病人信息	
	s dataJson=##class(%ArrayOfDataTypes).%New()
	d dataJson.SetAt(patId,"patId")
	d dataJson.SetAt(patName,"patName")
	d dataJson.SetAt(patNo,"patNo")
	d dataJson.SetAt(patAge,"patAge")
	d dataJson.SetAt(patSex,"patSex")
	d dataJson.SetAt(bedNo,"bedNo")
	d dataJson.SetAt(wardDesc,"wardDesc")
	// 频次用法
	d dataJson.SetAt(instrucDesc,"instrucDesc")
	d dataJson.SetAt(freqDesc,"freqDesc")
	d dataJson.SetAt(doseDateTime,"doseDateTime")
	s orderJson=##class(%ListOfDataTypes).%New()
	s oeori=mOeori
	d OeoriData
 	// 医嘱信息
	s ordItm=""
	f  S ordItm=$o(^OEORDi(0,"OEORI",ord,mOeori,ordItm)) q:ordItm=""  d  //关联医嘱
 	.S oeori=ord_"||"_ordItm
 	.Q:'$d(^DHCOEDISQTY(0,"OEORI",oeori))
 	.d OeoriData
 	d dataJson.SetAt(orderJson,"Orders")
	q:retType="Json" dataJson
	s retJson=##class(%ArrayOfDataTypes).%New()
	d retJson.SetAt("true","Success")
	d retJson.SetAt("success","MsgType")
	d retJson.SetAt(dataJson,"Data")
	q ##class(Nur.JSON).Encode(retJson)

OeoriData
 	s incStr=##class(web.DHCSTPIVAS.Common).GetIncItmByOeori(oeori)
 	s incDesc=$P(incStr,"^",3)
 	s dosage=##class(web.DHCSTPIVAS.Common).OeoriDosage(oeori)
 	s oeoriJson=##class(%ArrayOfDataTypes).%New()
	d oeoriJson.SetAt(incDesc,"incDesc")
	d oeoriJson.SetAt(dosage,"dosage")
	d orderJson.Insert(oeoriJson)
	q
}

}

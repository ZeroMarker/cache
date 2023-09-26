/// creator:lulin
/// createdate:2021-05-24
/// description:第三方接口
Class web.NurSensThirdInter Extends %RegisteredObject
{

/// 获取Get请求结果
/// url: http://192.168.0.155:8081/api/getVteRiskInfo 
/// params:json串入参，key-value的形式 如：{"EpisodeID":"5678055","Name","张三"}
/// w ##class(web.NurSensThirdInter).ExecuteGet("http://ip.taobao.com/service/getIpInfo.php","{""ip"":""117.89.35.58"",""code"":""333""}")
ClassMethod ExecuteGet(url, params = "") As %String
{
	s result = ""
	try
	{
		s httprequest=##class(%Net.HttpRequest).%New()
		if (params'="")
		{
			s params = ##class(Nur.JSON).Decode(params) // 转换为%ArrayOfDataTypes
			s keyX= ""
			for
			{
				s val = params.GetNext(.keyX)
				q:keyX=""
				d httprequest.SetParam(keyX,val)
			}
		}
		s httprequest.Timeout = 5 //设置超时秒数
		s status = httprequest.Get(url)
		if status {
		     d httprequest.HttpResponse.Data.Rewind()
		     d {
		         s result = httprequest.HttpResponse.Data.Read()
		     } while 'httprequest.HttpResponse.Data.AtEnd
		}
	}catch exp
	{
		
	}
	q result
}

/// 获取Post请求结果
/// server:服务地址，port：端口，url:服务路径，timeout：超时时长，param：参数(json格式)
ClassMethod ExcetePost(server, port, url, timeout, param) As %String
{
	s result=""
	s $zt="err"
	set req=##class(%Net.HttpRequest).%New()
	set req.Server=server
	s req.Port = port
	s req.Timeout = timeout
	set req.ContentType="application/json;charset=UTF-8"
	do req.EntityBody.Write(param)
	set sc = req.Post(url)
	if sc {
		s data=req.HttpResponse.Data
	    d data.Rewind()
	    d {
		    s tRet=data.Read()
		    i result="" d
		    .s result=tRet
		    e  d
		    .s result=result_tRet
	     	//s result = data.Read()
	    } while 'data.AtEnd
	}
	q result
err
	q result
}

/// 护管子类型第三方接口
ClassMethod GetCategroy(par, tmp, Server, port, url) As %String
{
	//s url="http://"_Server_":"_port_url	
	s param="{""Type"":"""_par_""",""tradeCode"": ""NM0001""}"
	s timeout=20
	s ret=..ExcetePost(Server,port,url,timeout,param)
	i ret'="" d
	.s retObj= ##class(Nur.JSON).Decode(ret)
	.i retObj.GetAt("ResultCode")=1 d
	..s listObject=retObj.GetAt("TypeList")
	..f i=1:1:listObject.Count() d
	...s dataObj=listObject.GetAt(i)
	...q:dataObj=""
	...s rw=dataObj.GetAt("rw")
	...s desc=dataObj.GetAt("desc")
	...s tmp(rw)=desc
}

/// 护管人员信息第三方接口
/// d ##class(web.NurSensThirdInter).GetNurMgData("2021-04-26",.tmp,"nurse.cr-health.com","34011","/crHesb/hospital/common")
ClassMethod GetNurMgData(date, tmp, Server, port, url) As %String
{
	//s url="http://"_Server_":"_port_url	
	s param="{""date"":"""_date_""",""tradeCode"": ""NM0002""}"
	s timeout=20
	s ret=..ExcetePost(Server,port,url,timeout,param)
	i ret'="" d
	.s retObj= ##class(Nur.JSON).Decode(ret)
	.i retObj.GetAt("ResultCode")=1 d
	..s listObject=retObj.GetAt("PerList")
	..f i=1:1:listObject.Count() d
	...s dataObj=listObject.GetAt(i)
	...q:dataObj=""
	...s DataKey=dataObj.GetAt("DataKey")
	...q:DataKey=""
	...s CTLocDR=dataObj.GetAt("CTLocDR")
	...;s CTLocDR=""
	...;s:ctLocCode'="" CTLocDR=$O(^CTLOC(0,"Code",$zcvt(ctLocCode,"U"),""))
	...;s:CTLocDR="" CTLocDR=ctLocCode
	...s isResign=dataObj.GetAt("IsResign")
	...s NurBeforWard=dataObj.GetAt("NurBeforWard")
	...s:isResign="Y" NurBeforWard=CTLocDR,CTLocDR="9997"
	...s tPerRet="DataKey|"_DataKey_"^CTLocDR|"_CTLocDR_"^NurBeforWard|"_NurBeforWard
	...s key="" f  s key=dataObj.Next(key)  q:key=""  d
	....q:((key="DataKey")||(key="CTLocDR")||(key="isResign")||(key="NurBeforWard"))
	....s value=dataObj.GetAt(key)
	....i ((key="ComeDate")||(key="WorkDate")) d
	.....s value=$P(value," ",1)
	....s tPerRet=tPerRet_"^"_key_"|"_value
	...s tmp(DataKey)=tPerRet
}

/// Creator:lulin
/// Description:获取第三方xml文件
/// Date:2022-04-02
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetThirdInfoData(dateFrom, dateTo, tmpInfData) As %String
{
	s a=##class(web.DHCENS.STBLL.DRG.Method.TsClass).GetMGZB("<params><cmd>getinf</cmd></params>")
	s InputStream=##class(%GlobalCharacterStream).%New()
	d InputStream.Write("<DATAS>"_$P(a,"<DATAS>",2))
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	if $$$ISERR(tSC) {
		q 0
	}else{
		k tmpKey
		s tmpKey=""
		s mLeyLB=$LB("InfType","InfDate","RepDate","RepTime","EpisodeID","PaRecord","PaName","PaSex","RepStatus"
		,"RepStatus","RepUserName","RepUserCode","InfXDate","InfEffect","CtLocDesc","AdmDate","SexDesc"
		,"PerBirth") ;敏感指标院感表字段名称
		//先根据id找到唯一对应关系
		s tSC=tDocument.EvaluateExpression("/DATAS/DATA/REPORTID","text()",.tRes)
		q:'$$$ISOK(tSC) 0
		s dataNum=tRes.Count()
		f i=1:1:dataNum d
		.s value=tRes.GetAt(i).Value
		.s:value="null" value=""
		.q:value=""
		.s tmpInfData(value)="ReportID|"_value
		.s tmpKey(i)=value
		f keyIndex=1:1:$LL(mLeyLB)  d
		.s mKey=$LG(mLeyLB,keyIndex)
		.s xmlKey=$zcvt(mKey,"U")
		.q:mKey=""
		.s tSC=tDocument.EvaluateExpression("/DATAS/DATA/"_xmlKey,"text()",.tRes)
		.q:'$$$ISOK(tSC)
		.f dataIndex=1:1:dataNum d
		..s value=tRes.GetAt(dataIndex).Value
		..;q:value=""
		..s:value="null" value=""
		..s ReportID=$g(tmpKey(dataIndex))
		..q:ReportID=""
		..s tmpInfData(ReportID)=tmpInfData(ReportID)_"^"_mKey_"|"_value
	}
	q 1
}

/// 出院持续六个月
ClassMethod GetBabyOutSixMilkData(Date) As %String
{
	;出院患儿中持续母乳喂养的6月龄内患儿数
	s DateStr="" f  s DateStr=$O(^NEMR.Pediatric.MomMilkS(DateStr)) q:DateStr=""  d
	.q:($zd(Date,3)'=$P(DateStr," ",1))
	.s CtlocID="" f  s CtlocID=$o(^NEMR.Pediatric.MomMilkS(DateStr,CtlocID)) q:(CtlocID="")  d
	..s ADM="" f  s ADM=$o(^NEMR.Pediatric.MomMilkS(DateStr,CtlocID,ADM)) q:(ADM="")  d
	...s USERID="" f  s USERID=$o(^NEMR.Pediatric.MomMilkS(DateStr,CtlocID,ADM,USERID)) q:(USERID="")  d
	....Q:^NEMR.Pediatric.MomMilkS(DateStr,CtlocID,ADM,USERID)'="Y"
	....s PAPMI=""
	....s admaf=$tr(ADM," ","")
    ....s:(admaf'="")&&($d(^PAADM(admaf))) PAPMI=$p($g(^PAADM(admaf)),"^",1)
    ....s PatName="",RegNo=""
    ....s:(PAPMI'="") PatName=$p(^PAPER(PAPMI,"ALL"),"^",1)
    ....s:(PAPMI'="") RegNo=$p(^PAPER(PAPMI,"PAT",1),"^",1)
 	....s ^tmpWardData(CtlocID)=$g(^tmpWardData(CtlocID))+1
	....s ^tmpWardData(CtlocID,ADM)=PatName_"("_RegNo_")"
	q ""
}

/// 母乳、混合母乳六个月
ClassMethod GetBabySixMilkData(Date, type) As %String
{
	
	s adm="" f  s adm=$o(^NEMR.HLPGDI("IndexDateAdm",Date,adm)) q:(adm="")  d
    .s hlpgdid="" f  s hlpgdid=$o(^NEMR.HLPGDI("IndexDateAdm",Date,adm,hlpgdid)) q:(hlpgdid="")  d
    ..s muruWY=$lg(^NEMR.HLPGDD(hlpgdid),31)  	;CHECKBOX4---31
    ..s hunheWY=$lg(^NEMR.HLPGDD(hlpgdid),32)  ;CHECKBOX6---32
    ..s ks=$lg(^NEMR.HLPGDD(hlpgdid),23)  		;TEXT2---23
    ..s hldy=$lg(^NEMR.HLPGDD(hlpgdid),21)  	;TEXT1---21 ;护理单元
    ..s CtlocID=""
    ..s:hldy'="" CtlocID=$O(^CTLOC(0,"Desc",$zcvt(hldy,"U"),""))
    ..q:CtlocID=""
    ..s age=$lg(^NEMR.HLPGDD(hlpgdid),29)  	;TEXT7---29 ;年龄
   	..s ageyear=$p(age,"岁",1)
   	..s agemonthday=$p(age,"岁",2)
   	..s agemonth=$p(agemonthday,"月",1)
   	..q:age>1
   	..q:agemonth>7
    ..s admaf=$tr(adm," ","")
    ..s PAPMI=""
    ..s:(admaf'="")&&($d(^PAADM(admaf))) PAPMI=$p($g(^PAADM(admaf)),"^",1)
    ..s PatName="",RegNo=""
    ..s:(PAPMI'="") PatName=$p(^PAPER(PAPMI,"ALL"),"^",1)
    ..s:(PAPMI'="") RegNo=$p(^PAPER(PAPMI,"PAT",1),"^",1)
    ..i type="blend" d 
    ...;入院时为混合喂养的6月龄内患儿数
    ...s:hunheWY="true" ^tmpWardData(CtlocID)=1+$G(^tmpWardData(CtlocID)),^tmpWardData(CtlocID,hlpgdid)=PatName_"("_RegNo_")"
    ..;;入院时为母乳喂养的6月龄内患儿数
    ..i type="pure" d
    ...s:muruWY="true" ^tmpWardData(CtlocID)=1+$G(^tmpWardData(CtlocID)),^tmpWardData(CtlocID,hlpgdid)=PatName_"("_RegNo_")"
	q ""
}

/// 所有手术数量
ClassMethod GetAnNum(Date) As %String
{
    s nwardid="" f  s nwardid=$o(^HXNSRNi("DW",Date,nwardid)) q:nwardid=""  d   ;HX_NurShiftRecordForNur
	.s nsrfndr="" f  s nsrfndr=$o(^HXNSRNi("DW",Date,nwardid,nsrfndr)) q:nsrfndr=""  d
	..s CTLocID=$p($g(^PAWARD(nwardid)),"^",5)
	..q:CTLocID=""
	..s locstr=$p(^HXNSRN(nsrfndr),"^",16)
	..s SurgeryCount=$p(locstr,"!",1)
	..s ^tmpWardData(CTLocID)=SurgeryCount+$G(^tmpWardData(CTLocID)),^tmpWardData(CTLocID,nsrfndr)="总数:"_SurgeryCount
	q ""
}

/// 医嘱执行用法医嘱数量,type:use:用法，用药med
ClassMethod GetOrderNum(Date, type) As %String
{
	s yongfastr="-2-3-4-5-6-78-91-54-97-"  ;用法 锐器
	k tmpPAAdm
	s rid="" f  s rid=$o(^OEORDi(0,"DateExecute",Date,rid))  q:rid=""  d
	.s oeoid="" f  s oeoid=$o(^OEORDi(0,"DateExecute",Date,rid,oeoid))  q:oeoid=""  d
	..s tPAADMDR=$p(^OEORD(rid),"^",1) ;主表
	..q:$d(tmpPAAdm(tPAADMDR))
 	..s admaf=$tr(tPAADMDR," ","")
    ..s PAPMI=""
    ..s:(admaf'="")&&($d(^PAADM(admaf))) PAPMI=$p($g(^PAADM(admaf)),"^",1)
    ..s PatName="",RegNo=""
    ..s:(PAPMI'="") PatName=$p(^PAPER(PAPMI,"ALL"),"^",1)
    ..s:(PAPMI'="") RegNo=$p(^PAPER(PAPMI,"PAT",1),"^",1)
	..s tOEORIDR=rid_"||"_oeoid
	..s PAADMType=$p(^PAADM(tPAADMDR),"^",2)
	..q:PAADMType'="I"
	..s tOEORIItmMastDR=$p(^OEORD(rid,"I",oeoid,1),"^",2)
	..q:tOEORIItmMastDR=""
	..s ARCICDR=$P(^ARCIM($P(tOEORIItmMastDR,"||",1),$P(tOEORIItmMastDR,"||",2),1),"^",10) //医嘱子类id
	..s ARCIdesc=""
	..;s ARCICDR=$p(^ARCIM($p($g(tmparcim),"||",1),$p($g(tmparcim),"||",2),1),"^",10)		//医嘱子类id
	..s:ARCICDR'="" ARCIdesc=$p(^ARC("IC",$g(ARCICDR)),"^",2)			//医嘱大类id  OEORIItmMastDR
	..s OrderSDate=$P($G(^OEORD(rid,"I",oeoid,1)),"^",9)  ;医嘱开始日期
 	..s OrderSTime=$P($G(^OEORD(rid,"I",oeoid,1)),"^",10) ;医嘱开始时间
	..s CTLocID=$P($G(^OEORD(rid,"I",oeoid,9)),"^",2)   ;病人所在病区
 	..i CTLocID'=""  d
 	...s PatWardtype=$p(^CTLOC(CTLocID),"^",13)
 	...i (PatWardtype'="W")&&(PatWardtype'="EM") d
 	....s PaWardDR=##class(web.NurSensDHCCHISComm).getTransWardByDateTime(tPAADMDR,OrderSDate,OrderSTime)   ;取转移表所在病区
	....s:PaWardDR'="" CTLocID=$p($g(^PAWARD(PaWardDR)),"^",5)
	..q:CTLocID=""
	..s tOEOARCIMCode=$p($g(^ARCIM(+tOEORIItmMastDR,$p(tOEORIItmMastDR,"||",2),1)),"^",1)
	..s tOEOARCIMDesc=$p($g(^ARCIM(+tOEORIItmMastDR,$p(tOEORIItmMastDR,"||",2),1)),"^",2)	//张睿新加by20160802
	..s OrdExecDR="" f  s OrdExecDR=$O(^OEORD(rid,"I",oeoid,"X",OrdExecDR)) q:OrdExecDR=""  d
	...s OEOREOrderStatusDR=$p(^OEORD(rid,"I",oeoid,"X",OrdExecDR),"^",16)
	...q:'((OEOREOrderStatusDR=1)||(OEOREOrderStatusDR=4))   ;完成已执行
	...s tOEORIDate=$p($g(^OEORD(rid,"I",oeoid,"X",OrdExecDR)),"^",19)  ;医嘱执行表执行日期（8.2）2020.01.16
	...q:(tOEORIDate'=Date) 
    ...s OEORIDateTime=$p($g(^OEORD(rid,"I",oeoid,"X",OrdExecDR)),"^",20)
    ...s (tprotype,ExecDR)=""
	...s ExecDR=$p($g(^OEORD(+rid,"I",+oeoid,"X",OrdExecDR)),"^",15)
  	...s:ExecDR'="" tprotype=$p(^CTPCP(ExecDR,1),"^",4)
	...s yongfa=$p($g(^OEORD(rid,"I",oeoid,2)),"^",7)
	...s YF="",SYRet=0,SYRetCnt=0,SXRet=0,SXRetCnt=0
	...s:yongfa'="" YF=$p($g(^PHCIN(yongfa)),"^",2)	//用法
	...i ((type="药")&&(ARCIdesc["药")) d
	....s ^tmpWardData(CTLocID)=1+$G(^tmpWardData(CTLocID))
	....s ^tmpWardData(CTLocID,tPAADMDR)=PatName_"("_RegNo_")"
	....s tmpPAAdm(tPAADMDR)=1
	...s yong="-"_yongfa_"-"
	...i ((type="锐器用法")&&(yongfastr'[yong))  d
	....s ^tmpWardData(CTLocID)=1+$G(^tmpWardData(CTLocID))
	....s ^tmpWardData(CTLocID,tPAADMDR)=PatName_"("_RegNo_")"
	....s tmpPAAdm(tPAADMDR)=1
	...i ((type="液")&&((YF["静滴")||(YF["续滴"))) d
	....s ^tmpWardData(CTLocID)=1+$G(^tmpWardData(CTLocID))
	....s ^tmpWardData(CTLocID,tPAADMDR)=PatName_"("_RegNo_")"
	....s tmpPAAdm(tPAADMDR)=1
	q ""
}

// 外周静脉通路明细

ClassMethod selAccessDetail(Date)
{
	s rtn="",sN=0
	s id="" f  s id=$O(^NEMR.Pediatric.AccessNewD(id)) q:id=""  d
	.s HappenDate=$lG(^NEMR.Pediatric.AccessNewD(id),4)
	.s HappenTime=$lG(^NEMR.Pediatric.AccessNewD(id),5)
	.q:HappenDate=""
	.s removeDate=$LG(^NEMR.Pediatric.AccessNewD(id),16)  //拔除日期：拔除的日期
	.s:removeDate="" removeDate=+$H
	.q:((HappenDate>Date)||(removeDate<Date))
	.s:HappenDate'="" HappenDate=$ZD(HappenDate,3)
	.q:HappenDate=""
	.s:HappenTime'="" HappenTime=$ZT(HappenTime) //发生时间日期格式转换
	.s PatWard=$lG(^NEMR.Pediatric.AccessNewD(id),3)
	.q:PatWard=""
	.s PatWardname=""
	.s:PatWard'="" PatWardname=$P($G(^CTLOC(PatWard)),"^",2) //护理单元科室
	.s PatBedNo=$lG(^NEMR.Pediatric.AccessNewD(id),8) //床号
	.s paadm=$lG(^NEMR.Pediatric.AccessNewD(id),2)
	.s papmi=$P($G(^PAADM(paadm)),"^",1)
	.s PatName=$P($G(^PAPER(papmi,"ALL")),"^",1)  //名字
	.s PatNo=$p($G(^PAPER(papmi,"PAT",1)),"^",1) //登记号
	.s dob=$P($G(^PAPER(papmi,"ALL")),"^",6),PatAge=""
	.s PatAge=##class(NEMR.Function.Web.PublicMethod).PerSonAge(paadm,"3")
	.s Diag=##class(NEMR.Interface.BaseHisClass).GetFirstDialog(paadm)
	.s PatDiag=$P(Diag,"^",3)
	.s:PatDiag="" PatDiag=$P(Diag,"^",1) //诊断
	.s BW=$LG(^NEMR.Pediatric.AccessNewD(id),10) //部位：取当前所创建的记录所选择的部位
	.s BWOther=$LG(^NEMR.Pediatric.AccessNewD(id),11)
	.s BW=$case(BW,"1":"手背","2":"前臂","3":"足背","4":"踝部","5":"头部","6":"颈部","7":"胫前","8":"其他:"_BWOther,BW:"")
	.;s BW=$case(BW,"1":"头部","2":"颈部","3":"前臂","4":"手背","5":"胫前","6":"踝部","7":"足背","8":"其他:"_BWOther,BW:"")
	.s PunctureType=$LG(^NEMR.Pediatric.AccessNewD(id),12) //穿刺针类型：取当前所创建的记录选择的类型
	.s PunctureType=$case(PunctureType,"1":"留置针","2":"钢针",PunctureType:"")
	.s remove=$LG(^NEMR.Pediatric.AccessNewD(id),15) //拔除类型（1：带管转科/出院 2：拔除）
	.s remove=$case(remove,"1":"带管转科/出院","2":"拔除",remove:"")
	.s removeDate=$LG(^NEMR.Pediatric.AccessNewD(id),16) //拔除日期：拔除的日期
	.s:removeDate'="" removeDate=$ZD(removeDate,3)
	.s days=""
	.s:(HappenDate'="")&&(removeDate'="") days=$ZDH(removeDate,3)-$ZDH(HappenDate,3)+1
	.s:(HappenDate'="")&&(removeDate="") days=(+$H)-$ZDH(HappenDate,3)+1
	.s ret="就诊号:"_paadm_",姓名:"_PatName_",病区:"_PatWardname_",床号:"_PatBedNo_",年龄:"_PatAge
	.s ret=ret_",发生日期："_HappenDate_",发生时间："_HappenTime_",部位："_BW_",诊断："_PatDiag_",类型："_PunctureType
	.s ret=ret_",拔除日期:"_removeDate_",共计:"_days_"天"
	.s ^tmpWardData(PatWard)=1+$G(^tmpWardData(PatWard))
	.s ^tmpWardData(PatWard,id)=ret
	q ""
}

/// Creater:wyl
/// CreateDate:护理部指标从在院患者角度取数20210120调整规则后
/// Description:jz手术数据  Execute(ByRef qHandle As %Binary,
/// d ##class(%ResultSet).RunQuery("ZPack.Testwyl3","GetNursDataV3","2022-01-01","2022-03-31")
/// call ZPack.Testwyl3_GetNursDataV3("2021-04-01","2021-06-30")
Query GetNursDataV3(paraSttDate As %String, paraEndDate As %String) As %Query(ROWSPEC = "季度,病房,特级护理患者占用床日数:%Numeric,一级护理患者占用床日数:%Numeric,二级护理患者占用床日数:%Numeric,三级护理患者占用床日数:%Numeric,中心导管置管总日数:%Numeric,中心导管置管总日数（CVC）:%Numeric,中心导管置管总日数（PICC）:%Numeric,中心导管置管总日数非PICCCVC:%Numeric,住院患者总床日数:%Numeric,住院患者总数:%Numeric,住院患者身体约束日数:%Numeric,新入院患者总数:%Numeric,初期留院人数:%Numeric,夜班收治患者数:%Numeric,白班收治患者数:%Numeric,导尿管留置总日数:%Numeric,患者使用有创机械通气的总日数:%Numeric,气管导管留置总日数:%Numeric,胃肠管（经口鼻）留置总日数:%Numeric,锐器发生率分母2手术人数:%Numeric,锐器发生率分母1用法的医嘱天数:%Numeric,总数:%Numeric,新生儿占有床日数统计当天小于28天:%Numeric,新生儿占有床日数入院小于28天:%Numeric,同期住院患者用药患者人日数:%Numeric,同期接受输液患者人次:%Numeric,同期接受输血患者人次:%Numeric,入院时为母乳喂养的6月龄内患儿数:%Numeric,出院患儿中持续母乳喂养的6月龄内患儿数:%Numeric,入院时为混合喂养的6月龄内患儿数:%Numeric,同期接受输血患者人日数:%Numeric,同期接受输液患者人日数:%Numeric,冲动行为干预治疗人日数:%Numeric") [ SqlProc ]
{
}

ClassMethod GetNursDataV3Execute(ByRef qHandle As %Binary, tSDate As %String, tEDate As %String) As %Status
{

	S tSDate=$zdh(tSDate,3)
	S tEDate=$zdh(tEDate,3)

	K ^HXBITEMPGetNursDataV3
	k ^hxbitempwyl20210630
	k ^HXBITEMPWYL10220119
	k ^HXBITempWYLARCDayV3
	f tDate=tSDate:1:tEDate d
	.s Datestr=$zd(tDate,3)
	.;w "母乳喂养MomMilk"_Datestr,!
	.s Year=$p(Datestr,"-",1)
	.s Month=$p(Datestr,"-",2)
	.s:+Month<=3 Season="1"
	.s:((+Month>=4) && (+Month<=6)) Season="2"
	.s:((+Month>=7) && (+Month<=9)) Season="3"
	.s:((+Month>=10) && (+Month<=12)) Season="4"
	.s SeasonDate=Year_""_Season

	;k ^HXBITempWYLARCDayV3
	s YZMCSTRS="中心导管置管总日数（PICC）^中心导管置管总日数（CVC）^导尿管留置总日数^胃肠管（经口鼻）留置总日数^中心导管置管总日数非PICCCVC^气管导管留置总日数^患者使用有创机械通气的总日数^住院患者身体约束日数^同期住院患者用药患者人日数^同期接受输液患者人次^同期接受输血患者人次^冲动行为干预治疗人次"
	s ArcimCodeSTRS="@666903527@^@4306012336@^@666600130@666000037@666900452@666000039@666903727@666903728@666903729@^@666000058@666900447@4409000818@666600084@666900448@666000059@666600085@4409001118@4409001218@666000464@666000468@666900479@^@666000431@^@4409200720@666600389@666600390@666900470@666901412@"  
	
	s ArcimCodeSTRS=ArcimCodeSTRS_"^"_"@666000255@666902803@^@666200007@^yy^sy^sx^666600106"
	s yongfastr="-2-3-4-5-6-78-91-54-97-"  ;用法 锐器
	

	w "母乳喂养MomMilk"_""_$zd($p($h,",",1),3)_""_$zt($p($h,",",2)),!
	f tDate=tSDate:1:tEDate d
	.s Datestr=$zd(tDate,3)
	.;w "母乳喂养MomMilk"_Datestr,!
	.s Year=$p(Datestr,"-",1)
	.s Month=$p(Datestr,"-",2)
	.s:+Month<=3 Season="1"
	.s:((+Month>=4) && (+Month<=6)) Season="2"
	.s:((+Month>=7) && (+Month<=9)) Season="3"
	.s:((+Month>=10) && (+Month<=12)) Season="4"
	.s SeasonDate=Year_""_Season

	s DATE=$zd(tSDate,3) f  s DATE=$o(^NEMR.Pediatric.MomMilkS(DATE)) q:((DATE="")||($zdh($p(DATE," ",1),3)>tEDate))  d
    .s wardid="" f  s wardid=$o(^NEMR.Pediatric.MomMilkS(DATE,wardid)) q:(wardid="")  d
    ..s warddesc=$p($g(^CTLOC(wardid)),"^",2)
	..s ADM="" f  s ADM=$o(^NEMR.Pediatric.MomMilkS(DATE,wardid,ADM)) q:(ADM="")  d
	...s USERID="" f  s USERID=$o(^NEMR.Pediatric.MomMilkS(DATE,wardid,ADM,USERID)) q:(USERID="")  d
	....Q:^NEMR.Pediatric.MomMilkS(DATE,wardid,ADM,USERID)'="Y"
    ....s ^HXBITEMPGetNursDataV3(SeasonDate,warddesc,"出院患儿中持续母乳喂养的6月龄内患儿数")=1+$G(^HXBITEMPGetNursDataV3(SeasonDate,warddesc,"出院患儿中持续母乳喂养的6月龄内患儿数"))
 

	w "新生儿占有床日HXBeInDay"_""_$zd($p($h,",",1),3)_""_$zt($p($h,",",2)),!
	f tDate=tSDate:1:tEDate d
	.s Datestr=$zd(tDate,3)
	.w "新生儿占有床日"_"^"_Datestr,!
	.s Year=$p(Datestr,"-",1)
	.s Month=$p(Datestr,"-",2)
	.s:+Month<=3 Season="1"
	.s:((+Month>=4) && (+Month<=6)) Season="2"
	.s:((+Month>=7) && (+Month<=9)) Season="3"
	.s:((+Month>=10) && (+Month<=12)) Season="4"
	.s SeasonDate=Year_""_Season
	.s tPAADMDR="" f  s tPAADMDR=$o(^PAADMi("PAADM_AdmDate",tDate,tPAADMDR)) q:tPAADMDR=""  d
	..q:'$d(^PAADM(tPAADMDR))  ;150536832  2020-09-27  
	..s (udate,inday1,inday)=""
	..s str=^PAADM(tPAADMDR)
	..s tPAADMType=$p($g(str),"^",2)   				//就诊类型
	..Q:tPAADMType'="I"
	..s PAPMINO=$p(str,"^",1) //登记号
	..s PAADMDischgDate=$p(str,"^",17) //出院日期
	..s PAADMCurrentWardDR=$p(str,"^",70)
	..s wardesc=$p($g(^PAWARD(PAADMCurrentWardDR)),"^",2)  
	..q:wardesc=""
	..s PAADMNO=$p(str,"^",81) //病案号 w $o(^OEORD(0,"Adm",146207884,""),-1)
	..s tPAPMIDR=+$p($g(^PAADM(tPAADMDR)),"^",1)
	..s tPAPMIDOB=$p($g(^PAPER(tPAPMIDR,"ALL")),"^",6)  //出生日期
	..s age=tDate-tPAPMIDOB  ;入院时间-出生日期,
    ..;q:age>28  ;去掉日期大于28天
 
    ..S (cntr,cntz)=0
    ..s bidid=""  f  s bidid=$o(^Data.HXBeInDayDetI("iPAADMDR",tPAADMDR,bidid)) q:bidid=""  d  ;在院表
	...s HLPGDstr=$g(^Data.HXBeInDayDetD(bidid))
	...s DPicDate=$lg(HLPGDstr,2) ;在院日期
	...s agehlpg=DPicDate-tPAPMIDOB
	...s:age<=28 cntr=$g(cntr)+1 
	...q:agehlpg>28
	...s:agehlpg cntz=$g(cntz)+1
	..q:((cntr=0)||(cntz=0))
	..;w tPAADMDR_"^"_cntr_"^"_cntz,!
	..s ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"新生儿占有床日数入院小于28天")=cntr+$G(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"新生儿占有床日数入院小于28天"))
	..s ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"新生儿占有床日数统计当天小于28天")=cntz+$G(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"新生儿占有床日数统计当天小于28天"))
	
	w "几级护理HxNur.Model.JBDBMain白班夜班出院床日数HLPGDD母乳喂养"_""_$zd($p($h,",",1),3)_""_$zt($p($h,",",2)),!
	f tDate=tSDate:1:tEDate d
	.s Datestr=$zd(tDate,3)
	.w "几级护理HxNur.Model.JBDBMain白班夜班出院床日数HLPGDD母乳喂养"_Datestr,!
	.s Year=$p(Datestr,"-",1)
	.s Month=$p(Datestr,"-",2)
	.s:+Month<=3 Season="1"
	.s:((+Month>=4) && (+Month<=6)) Season="2"
	.s:((+Month>=7) && (+Month<=9)) Season="3"
	.s:((+Month>=10) && (+Month<=12)) Season="4"
	.s SeasonDate=Year_""_Season
	
	.zn "dhc_app_new"
	.s jbwardid="" f  s jbwardid=$o(^NEMR.HxNur.Model.JBDBMainI("IndOnWard",tDate,jbwardid)) q:jbwardid=""  d
	..s wardesc=$p($g(^CTLOC(jbwardid)),"^",2)  //科室 
	..s jdbmaindr="" f  s jdbmaindr=$o(^NEMR.HxNur.Model.JBDBMainI("IndOnWard",tDate,jbwardid,jdbmaindr)) q:jdbmaindr=""  d ;Index IdxMainDR On MainDR
	...s jdbtdr="" f  s jdbtdr=$o(^NEMR.HxNur.Model.MBDTI("IdxFlight"," "_jdbmaindr," "_"合计",jdbtdr)) q:jdbtdr=""  d ;Index IdxFlight On (MainDR, Flight);
	....S str=$G(^NEMR.HxNur.Model.MBDTD(jdbtdr))
	....Q:str=""
	....s PrimaryCare=$lg(str,11)  ;一级
	....S SpecialCare=$lg(str,10)  ;特级
	....s PatientCount=$lg(str,9)  ;总数
	....;b ;s OpsCount=$lg(str,8)  ;
	....s ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"特级护理患者占用床日数")=SpecialCare+$G(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"特级护理患者占用床日数"))
	....s ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"一级护理患者占用床日数")=PrimaryCare+$G(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"一级护理患者占用床日数"))
	....s ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"总数")=PatientCount+$G(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"总数"))
	
	.f i2=1:1:176  d   ;白班夜班
	..q:(i2=83)
	..ZN "DHC_APP"
	..s outstr=""
	..q:'$d(^PAWARD(i2))
	..;q:i2'=19
	..s wardesc=$p(^PAWARD($g(i2)),"^",2)
	..s outstr="" ;..GetShiftRecordData(tDate,i2)
	..q:outstr=""
	..q:(outstr'["^")
	..s BB=+$p(outstr,"^",1) ; 白班收治患者数 
	..S YB=+$p(outstr,"^",2)  ; 夜班收治患者数
	..s ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"白班收治患者数")=BB+$G(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"白班收治患者数"))
	..s ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"夜班收治患者数")=YB+$G(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"夜班收治患者数"))
	
	.s MRLDid="" f  s MRLDid=$o(^HXBI.MRLocDailyWorkI("iReportDate",tDate,MRLDid)) q:MRLDid=""  d
	..q:'$d(^HXBI.MRLocDailyWorkD(MRLDid))
	..S MRLStr=^HXBI.MRLocDailyWorkD(MRLDid)  
	..S WardDR=$lg(MRLStr,5)
	..q:WardDR'="Ward"  ;只取护理单元
	..s BeBedDays=$lg(MRLStr,28)   ;住院患者总床日数 
	..s FLocDR=$lg(MRLStr,4)   ;
	..s CTLOCDesc="NULL"
	..s CTLOCDesc=$p($g(^CTLOC(FLocDR)),"^",2)
	..s InCountTotal=$lg(MRLStr,10)   ;入院患者总数  
	..s:tDate=tSDate PatCountOrig=$lg(MRLStr,9)   ;初期留院人数  
	..s ^HXBITEMPGetNursDataV3(SeasonDate,CTLOCDesc,"住院患者总床日数")=BeBedDays+$G(^HXBITEMPGetNursDataV3(SeasonDate,CTLOCDesc,"住院患者总床日数"))
	..s ^HXBITEMPGetNursDataV3(SeasonDate,CTLOCDesc,"新入院患者总数")=InCountTotal+$G(^HXBITEMPGetNursDataV3(SeasonDate,CTLOCDesc,"新入院患者总数"))
	..s ^HXBITEMPGetNursDataV3(SeasonDate,CTLOCDesc,"初期留院人数")=PatCountOrig+$G(^HXBITEMPGetNursDataV3(SeasonDate,CTLOCDesc,"初期留院人数"))
	..s ^HXBITEMPGetNursDataV3(SeasonDate,CTLOCDesc,"住院患者总数")=(InCountTotal+PatCountOrig)+$G(^HXBITEMPGetNursDataV3(SeasonDate,CTLOCDesc,"住院患者总数"))
	.zn "dhc_app_new"
	.s nwardid="" f  s nwardid=$o(^HXNSRNi("DW",tDate,nwardid)) q:nwardid=""  d   ;HX_NurShiftRecordForNur
	..s nsrfndr="" f  s nsrfndr=$o(^HXNSRNi("DW",tDate,nwardid,nsrfndr)) q:nsrfndr=""  d
	...s wardesc=$p(^PAWARD($g(nwardid)),"^",2)
	...s locstr=$p(^HXNSRN(nsrfndr),"^",16)
	...s SurgeryCount=$p(locstr,"!",1)
	...s yjhl=$p(locstr,"!",4)  ;一级
	...s tjhl=$p(locstr,"!",3)  ;特级
	...s CountTodayall=0
	...s PatCountToday=$p(^HXNSRN(nsrfndr),"^",21)  ;当日留院人数
	...s DischCountTotal=$p(^HXNSRN(nsrfndr),"^",12) ;当日出院院人数  select top 10 * from NEMR_HxNur_Model.JBDBMain 
	...s TransOutCount=$p(^HXNSRN(nsrfndr),"^",30) ;转往他科    select top 10 * from NEMR_HxNur_Model.mbdt
	...s CountTodayall=PatCountToday+DischCountTotal+TransOutCount
	...s ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"手术人数")=SurgeryCount+$G(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"手术人数"))
   
    .s adm="" f  s adm=$o(^NEMR.HLPGDI("IndexDateAdm",tDate,adm)) q:(adm="")  d
    ..s hlpgdid="" f  s hlpgdid=$o(^NEMR.HLPGDI("IndexDateAdm",tDate,adm,hlpgdid)) q:(hlpgdid="")  d
    ...s muruWY=$lg(^NEMR.HLPGDD(hlpgdid),31)  	;CHECKBOX4---31
    ...s hunheWY=$lg(^NEMR.HLPGDD(hlpgdid),32)  ;CHECKBOX6---32
    ...s ks=$lg(^NEMR.HLPGDD(hlpgdid),23)  		;TEXT2---23
    ...s hldy=$lg(^NEMR.HLPGDD(hlpgdid),21)  	;TEXT1---21 ;护理单元
    ...s age=$lg(^NEMR.HLPGDD(hlpgdid),29)  	;TEXT7---29 ;年龄
   	...s ageyear=$p(age,"岁",1)
   	...s agemonthday=$p(age,"岁",2)
   	...s agemonth=$p(agemonthday,"月",1)
   	...q:age>1
   	...q:agemonth>7
    ...s admaf=$tr(adm," ","")
    ...s PAPMI=""
    ...s:(admaf'="")&&($d(^PAADM(admaf))) PAPMI=$p($g(^PAADM(admaf)),"^",1)
    ...s PatName="0",RegNo="0"
    ...s:(PAPMI'="") PatName=$p(^PAPER(PAPMI,"ALL"),"^",1)
    ...s:(PAPMI'="") RegNo=$p(^PAPER(PAPMI,"PAT",1),"^",1) 
    ...s:hunheWY="true" ^HXBITEMPGetNursDataV3(SeasonDate,hldy,"入院时为混合喂养的6月龄内患儿数")=1+$G(^HXBITEMPGetNursDataV3(SeasonDate,hldy,"入院时为混合喂养的6月龄内患儿数"))
    ...q:muruWY'="true"
    ...s ^HXBITEMPGetNursDataV3(SeasonDate,hldy,"入院时为母乳喂养的6月龄内患儿数")=1+$G(^HXBITEMPGetNursDataV3(SeasonDate,hldy,"入院时为母乳喂养的6月龄内患儿数"))
 
 

    
   w "医嘱"_""_$zd($p($h,",",1),3)_""_$zt($p($h,",",2)),!
  
	f tDate=tSDate:1:tEDate d
	.s Datestr=$zd(tDate,3)
	.w Datestr,!
	.s Year=$p(Datestr,"-",1)
	.s Month=$p(Datestr,"-",2)
	.s:+Month<=3 Season="1"
	.s:((+Month>=4) && (+Month<=6)) Season="2"
	.s:((+Month>=7) && (+Month<=9)) Season="3"
	.s:((+Month>=10) && (+Month<=12)) Season="4"
	.s SeasonDate=Year_""_Season
	.;q:SeasonDate<=20221
	.ZN "DHC_APP"
	.w "跑医嘱"
	.s rid="" f  s rid=$o(^OEORDi(0,"DateExecute",tDate,rid))  q:rid=""  d
	..s oeoid="" f  s oeoid=$o(^OEORDi(0,"DateExecute",tDate,rid,oeoid))  q:oeoid=""  d
	...s tPAADMDR=$p(^OEORD(rid),"^",1) ;主表
	...s tOEORIDR=rid_"||"_oeoid
	...;q:tPAADMDR'=159809672
	...s PAADMType=$p(^PAADM(tPAADMDR),"^",2)
	...q:PAADMType'="I"
	...s tOEORIItmMastDR=$p(^OEORD(rid,"I",oeoid,1),"^",2)
	...q:tOEORIItmMastDR=""
	...s ARCICDR=$P(^ARCIM($P(tOEORIItmMastDR,"||",1),$P(tOEORIItmMastDR,"||",2),1),"^",10) //医嘱子类id
	...s ARCIdesc=""
	...;s ARCICDR=$p(^ARCIM($p($g(tmparcim),"||",1),$p($g(tmparcim),"||",2),1),"^",10)		//医嘱子类id
	...s:ARCICDR'="" ARCIdesc=$p(^ARC("IC",$g(ARCICDR)),"^",2)			//医嘱大类id  OEORIItmMastDR
	...;s PaWardDR=$p(^PAADM(tPAADMDR),"^",70)
	...s OrderSDate=$P($G(^OEORD(rid,"I",oeoid,1)),"^",9)  ;医嘱开始日期
 	...s OrderSTime=$P($G(^OEORD(rid,"I",oeoid,1)),"^",10) ;医嘱开始时间
	...s PaWardDR=$P($G(^OEORD(rid,"I",oeoid,9)),"^",2)   ;病人所在病区
	...;b:PaWardDR=""
 	...i PaWardDR'=""  d
 	....s PatWardtype=$p(^CTLOC(PaWardDR),"^",13)
 	....s:(PatWardtype'="W")&&(PatWardtype'="EM") PaWardDR=##class(web.NurSensDHCCHISComm).getTransWardByDateTime(tPAADMDR,OrderSDate,OrderSTime)   ;取转移表所在病区
	...s wardesc=""
	...;b:PaWardDR=203
	...s:PaWardDR'="" wardesc=$p(^CTLOC(PaWardDR),"^",2) ;$p($g(^PAWARD(PaWardDR)),"^",2)
	...;Q:wardesc'["46" 
	...s:wardesc="" wardesc="NULL" 
	...s tOEOARCIMCode=$p($g(^ARCIM(+tOEORIItmMastDR,$p(tOEORIItmMastDR,"||",2),1)),"^",1)
	...;Q:"@4409200720@666600389@666600390@666900470@666901412@666000255@666902803@"'[tOEOARCIMCode
	...s tOEOARCIMDesc=$p($g(^ARCIM(+tOEORIItmMastDR,$p(tOEORIItmMastDR,"||",2),1)),"^",2)	//张睿新加by20160802
	...s OrdExecDR="" f  s OrdExecDR=$O(^OEORD(rid,"I",oeoid,"X",OrdExecDR)) q:OrdExecDR=""  d
	....s OEOREOrderStatusDR=$p(^OEORD(rid,"I",oeoid,"X",OrdExecDR),"^",16)
	....q:'((OEOREOrderStatusDR=1)||(OEOREOrderStatusDR=4))   ;完成已执行
	....s tOEORIDate=$p($g(^OEORD(rid,"I",oeoid,"X",OrdExecDR)),"^",19)  ;医嘱执行表执行日期（8.2）2020.01.16
	....q:(tOEORIDate'=tDate) 
    ....s OEORIDateTime=$p($g(^OEORD(rid,"I",oeoid,"X",OrdExecDR)),"^",20)
    ....s (tprotype,ExecDR)=""
	....s ExecDR=$p($g(^OEORD(+rid,"I",+oeoid,"X",OrdExecDR)),"^",15)
  	....s:ExecDR'="" tprotype=$p(^CTPCP(ExecDR,1),"^",4)
	....s yongfa=$p($g(^OEORD(rid,"I",oeoid,2)),"^",7)
	....s YF="",SYRet=0,SYRetCnt=0,SXRet=0,SXRetCnt=0
	....s:yongfa'="" YF=$p($g(^PHCIN(yongfa)),"^",2)	//用法

	....;B ;05
	....s ^HXBITEMPWYL10220119(tPAADMDR,tOEORIDR,tOEOARCIMCode,wardesc)=1
	
	....s YZMCCnt="" f YZMCCnt=1:1:$l(YZMCSTRS,"^") q:YZMCCnt=""  d
	.....s YZMC=$p(YZMCSTRS,"^",YZMCCnt)
	.....s ArcimCode=$p(ArcimCodeSTRS,"^",YZMCCnt)
	.....s strflag="^同期住院患者用药患者人日数^同期接受输液患者人次^同期接受输血患者人次"
	.....s (SXRet,SYRet)=0
	.....s:((ArcimCode[tOEOARCIMCode) &&(tOEORIDate'="")&&(wardesc'="")&&(strflag'[YZMC)) ^HXBITempWYLARCDayV3(SeasonDate,wardesc,YZMC,tPAADMDR,tOEORIDate)=1
    .....s:((ARCIdesc["药")) ^HXBITempWYLARCDayV3(SeasonDate,wardesc,"同期住院患者用药患者人日数",tPAADMDR,tOEORIDate)=1
	.....;s:((ARCIdesc["药")&&(tprotype=2)) ^HXBITempWYLARCDayV3(SeasonDate,wardesc,"同期住院患者用药患者人日数",tPAADMDR,tOEORIDate)=1
	.....s yong="-"_yongfa_"-"
	.....s:yongfastr'[yong ^HXBITempWYLARCDayV3(SeasonDate,wardesc,"锐器发生数",tPAADMDR,tOEORIDate)=1
	.....s:((ArcimCode="sx") &&("@4306012636@"[tOEOARCIMCode)) SXRet=1 ,SXRetCnt=SXRet+1,^HXBITempWYLARCDayV3(SeasonDate,wardesc,"同期接受输血患者人日数",tPAADMDR,tOEORIDate)=1
	.....s:((YF["静滴")||(YF["续滴")) SYRet=1
	.....s:((YF["静滴")||(YF["续滴")) SYRetCnt=SYRet+1
	.....s:SYRet=1 ^HXBITempWYLARCDayV3(SeasonDate,wardesc,"同期接受输液患者人次",tPAADMDR,"NULL")=1,^HXBITempWYLARCDayV3(SeasonDate,wardesc,"同期接受输液患者人日数",tPAADMDR,tOEORIDate)=1
	.....s:SXRet=1 ^HXBITempWYLARCDayV3(SeasonDate,wardesc,"同期接受输血患者人次",tPAADMDR,"NULL")=1
	
		   

	;聚合数据
	zn "dhc_app"
	f tDate=tSDate:1:tEDate d
	.s Datestr=$zd(tDate,3)
	.w Datestr,!
	.s Year=$p(Datestr,"-",1)
	.s Month=$p(Datestr,"-",2)
	.s:+Month<=3 Season="1"
	.s:((+Month>=4) && (+Month<=6)) Season="2"
	.s:((+Month>=7) && (+Month<=9)) Season="3"
	.s:((+Month>=10) && (+Month<=12)) Season="4"
	.s SeasonDate=Year_""_Season
	.s ^hxbitempwyl20210630(SeasonDate)=""


	s SeasonDate="" f  s SeasonDate=$o(^hxbitempwyl20210630(SeasonDate))  q:SeasonDate=""  d
	.s cnt=0
	.s wardesc="" f  s wardesc=$o(^HXBITempWYLARCDayV3(SeasonDate,wardesc)) q:wardesc=""  d  
	..s YZMC="" f  s YZMC=$o(^HXBITempWYLARCDayV3(SeasonDate,wardesc,YZMC)) q:YZMC=""  d
	...s adm="" f  s adm=$o(^HXBITempWYLARCDayV3(SeasonDate,wardesc,YZMC,adm)) q:adm=""  d

	....S:YZMC="同期接受输液患者人次" ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,YZMC)=1+$g(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,YZMC))
	....S:YZMC="同期接受输血患者人次" ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,YZMC)=1+$g(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,YZMC))
	....s tOEORIDate="" f  s tOEORIDate=$o(^HXBITempWYLARCDayV3(SeasonDate,wardesc,YZMC,adm,tOEORIDate)) q:tOEORIDate=""  d
	.....;Q:YZMC'="胃肠管（经口鼻）留置总日数"
	.....s cnt=cnt+1
	.....s:((YZMC'="")&&(YZMC'="同期接受输液患者人次")&&(YZMC'="同期接受输血患者人次")) ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,YZMC)=+$g(^HXBITempWYLARCDayV3(SeasonDate,wardesc,YZMC,adm,tOEORIDate))+$g(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,YZMC))

    ;w cnt,!
    ;b ;08
    ;为空的赋值0
    s YZMCSTRS="特级护理患者占用床日数^一级护理患者占用床日数^二级护理患者占用床日数^三级护理患者占用床日数^中心导管置管总日数^中心导管置管总日数（CVC）^中心导管置管总日数（PICC）^中心导管置管总日数非PICCCVC^住院患者总床日数^住院患者总数^住院患者身体约束日数^新入院患者总数^初期留院人数^夜班收治患者数^白班收治患者数^导尿管留置总日数^患者使用有创机械通气的总日数^气管导管留置总日数^胃肠管（经口鼻）留置总日数^手术人数^锐器发生数^总数^新生儿占有床日数统计当天小于28天^新生儿占有床日数入院小于28天^同期住院患者用药患者人日数^同期接受输液患者人次^同期接受输血患者人次^入院时为母乳喂养的6月龄内患儿数^出院患儿中持续母乳喂养的6月龄内患儿数^入院时为混合喂养的6月龄内患儿数^同期接受输血患者人日数^同期接受输液患者人日数^冲动行为干预治疗人日数"
   

    s SeasonDate="" f  s SeasonDate=$o(^hxbitempwyl20210630(SeasonDate))  q:SeasonDate=""  d
   
	.s YZMCCnt="" f YZMCCnt=1:1:$l(YZMCSTRS,"^") q:YZMCCnt=""  d
	..s YZMC=$p(YZMCSTRS,"^",YZMCCnt)
	..s wardesc="" f  s wardesc=$o(^HXBITEMPGetNursDataV3(SeasonDate,wardesc)) q:wardesc=""  d
	...s:'$d(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,YZMC)) ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,YZMC)=0
	...s ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"二级护理患者占用床日数")=$g(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"总数"))-$G(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"特级护理患者占用床日数"))-$G(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"一级护理患者占用床日数"))
	...s:^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"二级护理患者占用床日数")<0 ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"二级护理患者占用床日数")=0
	...s:wardesc["ICU" ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"二级护理患者占用床日数")=0
	...s:wardesc["第11" ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"二级护理患者占用床日数")=0
	...s:wardesc["第13" ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"二级护理患者占用床日数")=0
	...s:wardesc["第15" ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"二级护理患者占用床日数")=0
	...s:wardesc["第72" ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"二级护理患者占用床日数")=0
	...s:wardesc["第73" ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"二级护理患者占用床日数")=0
	...s:wardesc["麻醉科" ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"二级护理患者占用床日数")=0
	...s:wardesc["温江第1" ^HXBITEMPGetNursDataV3(SeasonDate,wardesc,"二级护理患者占用床日数")=0
	
	w "进gloab结束"_$zt($p($h,",",2)),!

	;s YZMCSTRS="特级护理患者占用床日数^一级护理患者占用床日数^二级护理患者占用床日数^三级护理患者占用床日数^中心导管置管总日数^中心导管置管总日数（CVC）^中心导管置管总日数（PICC）^中心导管置管总日数非PICCCVC^住院患者总床日数^住院患者总数^住院患者身体约束日数^新入院患者总数^初期留院人数^夜班收治患者数^白班收治患者数^导尿管留置总日数^患者使用有创机械通气的总日数^气管导管留置总日数^胃肠管（经口鼻）留置总日数^手术人数^锐器发生数^总数^新生儿占有床日数统计当天小于28天^新生儿占有床日数入院小于28天^同期住院患者用药患者人日数^同期接受输液患者人次^同期接受输血患者人次^入院时为母乳喂养的6月龄内患儿数^出院患儿中持续母乳喂养的6月龄内患儿数^入院时为混合喂养的6月龄内患儿数^同期接受输血患者人日数^同期接受输液患者人日数^冲动行为干预治疗人次"
	s YZMCSTRS="特级护理患者占用床日数^一级护理患者占用床日数^二级护理患者占用床日数^三级护理患者占用床日数^中心导管置管总日数^中心导管置管总日数（CVC）^中心导管置管总日数（PICC）^中心导管置管总日数非PICCCVC^住院患者总床日数^住院患者总数^住院患者身体约束日数^新入院患者总数^初期留院人数^夜班收治患者数^白班收治患者数^导尿管留置总日数^患者使用有创机械通气的总日数^气管导管留置总日数^胃肠管（经口鼻）留置总日数^手术人数^锐器发生数^总数^新生儿占有床日数统计当天小于28天^新生儿占有床日数入院小于28天^同期住院患者用药患者人日数^同期接受输液患者人次^同期接受输血患者人次^入院时为母乳喂养的6月龄内患儿数^出院患儿中持续母乳喂养的6月龄内患儿数^入院时为混合喂养的6月龄内患儿数^同期接受输血患者人日数^同期接受输液患者人日数^冲动行为干预治疗人次"
	s repid=$i(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s index=1

	s SeasonDate="" f  s SeasonDate=$o(^hxbitempwyl20210630(SeasonDate))  q:SeasonDate=""  d
	.s wardesc="" f  s wardesc=$o(^HXBITEMPGetNursDataV3(SeasonDate,wardesc)) q:wardesc=""  d
	..s str1="",str=""
	..;q:wardesc'="第05护理单元"
	..s YZMCCnt="" f YZMCCnt=1:1:$l(YZMCSTRS,"^") q:YZMCCnt=""  d
	...s YZMC=$p(YZMCSTRS,"^",YZMCCnt)
	...;s YZMC="" f  s YZMC=$o(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,YZMC)) q:YZMC=""  d
	
	...s str1=$g(str1)_":"_YZMC

    ...s str=$g(str)_":"_+$g(^HXBITEMPGetNursDataV3(SeasonDate,wardesc,YZMC))
	...;b:((YZMC="出院患儿中持续母乳喂养的6月龄内患儿数") &&(wardesc="第05护理单元"))
  	..;w str1,!
  	..;w str,!
  	..;b ;08
	..s Data=$lb(SeasonDate,wardesc,$p(str,":",2),$p(str,":",3),$p(str,":",4),$p(str,":",5),(+$p(str,":",7)+$p(str,":",8)+$p(str,":",9)),$p(str,":",7),$p(str,":",8),$p(str,":",9),$p(str,":",10),$p(str,":",11),$p(str,":",12),$p(str,":",13),$p(str,":",14),$p(str,":",15),$p(str,":",16),$p(str,":",17),$p(str,":",18),$p(str,":",19),$p(str,":",20),$p(str,":",21),$p(str,":",22),$p(str,":",23),$p(str,":",24),$p(str,":",25),$p(str,":",26),$p(str,":",27),$p(str,":",28),$p(str,":",29),$p(str,":",30),$p(str,":",31),$p(str,":",32),$p(str,":",33),$p(str,":",34))
	..s ^CacheTemp(repid,index)=Data
	..s index=index+1
	Quit $$$OK
}

ClassMethod GetNursDataV3Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNursDataV3Execute ]
{
	s repid=$list(qHandle,2)
	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNursDataV3Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNursDataV3Execute ]
{
	s AtEnd=$list(qHandle,1)
	s repid=$list(qHandle,2)
	s ind=$list(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind=""{
		s AtEnd=1
		s Row=""
	}
	else   {
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}

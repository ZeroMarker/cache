Class web.DHCICUPrintService Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：        王枭啸
/// CreatDate：      2018-10-28
/// Description：    获取病人打印信息
/// Table：          DHC_ICU_Order
/// Input:           icuaId:病人重症id,stdate:开始日期,sttime:开始时间,enddate:结束日期,endtime:结束时间,ItemCodeStr:常用医嘱代码串
/// Return：         PrintDT:打印时间,Orders:打印内容,User:记录用户
/// d ##class(%ResultSet).RunQuery("web.DHCICUPrintService","GetPrintOrdersNew","14","2020-04-29","14:36","2020-07-20","10:29","ExecTime^Temper^HR^Resp^NBP^ABP^SPO2^consciousnessICU^Pupil;Size^Pupil;LightReflecting^Pupil^OrderText^Administration^PQty^InfactQty^HisSpeed^UrineVolume^Proportion^Stool^OtherIOName^OtherIOQty^NursingRecord.PressureSoreICU.DVTScore.PipeScoreICU.FallScore.TTPF.RASS.CPOT.ZWScore.Glasgow.Overturn.SpongeBathInBed.AerosolInhalation.Sputum.AirwayCare.Oralcare.PerinealCare.DroppingTheTrachea.HLBCG.HLZDPT.QYZL.AVCare.CVP.BSICU.JCPGY.ICP.VentilatorMode.PEEP.FiO2.Ppeak.Pmean.VT.RAW.CR.ETCO2.OtherIn^NursingRecord^PressureSoreICU^DVTScore^PipeScoreICU^FallScore^TTPF^RASS^CPOT^ZWScore^Glasgow^Overturn^SpongeBathInBed^AerosolInhalation^Sputum^AirwayCare^Oralcare^PerinealCare^DroppingTheTrachea^HLBCG^HLZDPT^AVCare^Oralcare^CVP^BSICU^JCPGY^ICP^VentilatorMode^PEEP^FiO2^Ppeak^Pmean^VT^RAW^CR^ETCO2^OtherIn^OperationUser")
Query GetPrintOrdersNew(icuaId, stdate, sttime, enddate, endtime, ItemCodeStr, ItemIfHaveDateStr = "", moreDatasStr = "") As %Query(ROWSPEC = "PrintDT,Orders,User") [ SqlProc ]
{
}

ClassMethod GetPrintOrdersNewExecute(ByRef qHandle As %Binary, icuaId, stdate, sttime, enddate, endtime, ItemCodeStr, ItemIfHaveDateStr = "", moreDatasStr = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPDHCICU("GetPrintOrdersNew")
	k ^TMPDHCICU("GetPrintOrdersNewOut")
	s stdate=##class(web.DHCClinicCom).ConvertToDateH(stdate)
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH(sttime)
	s enddate=##class(web.DHCClinicCom).ConvertToDateH(enddate)
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH(endtime)
	
	f curDate=stdate:1:enddate d
	.s n=0
	.s icuoSttTime=""  //,YINLIUCount=0,YINLIUId1="",YINLIUId2="",YINLIUId3=""
	.s kFlag="N"
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..q:(curDate=stdate)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=enddate)&&(icuoSttTime>endtime)    //晚于开始时间
	..i ((icuoSttTime>=25200)&&(kFlag="N")) d    //换班时清缓存数据  7:00
	...k ^TMPHaveDate s kFlag="Y"
	..s ^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime)=$zd(curDate,3)_" "_$zt(icuoSttTime,2)
	..s orderStr="",UserStr="",OtherUserStr="",UserFlag="N",otherUserFlag="N"
	..s icuoId="",haveDateFlag="N"
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoUserStr="",icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...i ICUOICUPIDr'="" d
    ....q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
    
	...s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...s comOrdFlag=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",10)
	...q:comOrdFlag="N"   //未激活
	...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
	...s ICUOViewCatCode=$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",1)
	...;q:(ItemCodeStr'="")&&(ItemCodeStr'[icucriCode)
	...q:(..CheckData(icucriCode,ItemCodeStr)="N")&&(..CheckData(ICUOViewCatCode,ItemCodeStr)="N")
	...i ..CheckData(icucriCode,ItemIfHaveDateStr)="Y" d    //有项目才打印模式
	....s haveDateFlag="Y"
	....i $g(^TMPHaveDate(icucriCode))="" s hdCount=0
	....w !,$g(^TMPHaveDate(icucriCode))_"#"_ICUOICUPIDr
	....s hdPIDrStr=$g(^TMPHaveDate(icucriCode)) 
	....i hdPIDrStr'="" d
	.....s n=0
	.....f hdI=1:1:$length(^TMPHaveDate(icucriCode),"^") d
	......s hdPIDr=$p(^TMPHaveDate(icucriCode),"^",hdI)
	......i hdPIDr=ICUOICUPIDr s hdCount=hdI,n=hdI
	.....i n=0 s hdCount=$length(^TMPHaveDate(icucriCode),"^")+1
	....e  s hdCount=1
	....w !,hdCount
	....i ..CheckData(ICUOICUPIDr,$g(^TMPHaveDate(icucriCode)))="N" d
	.....i $g(^TMPHaveDate(icucriCode))'="" s ^TMPHaveDate(icucriCode)=$g(^TMPHaveDate(icucriCode))_"^"_ICUOICUPIDr
	.....e  s ^TMPHaveDate(icucriCode)=ICUOICUPIDr
	....s icucriCode=icucriCode_hdCount
	
	...i (..CheckData(ICUOViewCatCode,ItemIfHaveDateStr)="Y")&&(..CheckData(icucriCode,ItemCodeStr)="N") d    //有项目才打印模式(固定项目跳过)
	....s haveDateFlag="Y"
	....i $g(^TMPHaveDate(ICUOViewCatCode))="" s hdCount=0
	....w !,$g(^TMPHaveDate(ICUOViewCatCode))_"#"_ICUOICUPIDr
	....s hdPIDrStr=$g(^TMPHaveDate(ICUOViewCatCode)) 
	....i hdPIDrStr'="" d
	.....s n=0
	.....f hdI=1:1:$length(^TMPHaveDate(ICUOViewCatCode),"^") d
	......s hdPIDr=$p(^TMPHaveDate(ICUOViewCatCode),"^",hdI)
	......i hdPIDr=ICUOICUPIDr s hdCount=hdI,n=hdI
	.....i n=0 s hdCount=$length(^TMPHaveDate(ICUOViewCatCode),"^")+1
	....e  s hdCount=1
	....w !,hdCount
	....i ..CheckData(ICUOICUPIDr,$g(^TMPHaveDate(ICUOViewCatCode)))="N" d
	.....i $g(^TMPHaveDate(ICUOViewCatCode))'="" s ^TMPHaveDate(ICUOViewCatCode)=$g(^TMPHaveDate(ICUOViewCatCode))_"^"_ICUOICUPIDr
	.....e  s ^TMPHaveDate(ICUOViewCatCode)=ICUOICUPIDr
	....s icucriCode=ICUOViewCatCode_hdCount
	

	...s moreDataFlag="N"
	...i ..CheckData(icucriCode,moreDatasStr)="Y" s moreDataFlag="Y"
	...;w !,icuoId_"^"_icuoComOrdDr_"^"_icucriCode
	...s icuoUserDr=$p($g(^DHCICUOrder(icuoId)),"^",4)
	...;q:icuoUserDr'=113
	...s icuoUserDesc=""
	...i icuoUserDr'="" s icuoUserDesc=$p($g(^SSU("SSUSR",icuoUserDr)),"^",2)
	...s OtherDesc=$p($g(^DHCICUOrder(icuoId,"OtherUser")),"^",2)
    ...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s icuoVolume=+$p($g(^DHCICUOrder(icuoId)),"^",28)
    
    
	...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...;w !,icuoComOrdDr_"^"_icuoDataType_"^"_icucriCode_"^"_icuoQty_"^"_icuoNote
	...;i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Qty" s icuoValue=icuoQty
	...i icuoDataType="Volume" s icuoValue=icuoVolume
	...i icuoDataType="Note" s icuoValue=icuoNote
	...;i icuoValue=0 s icuoValue=""
	
	...;特殊字符处理
	...i ICUOViewCat="191"  d //护理记录 
	....s icuoValue=$replace(icuoValue,";",",")
	....s icuoValue=$replace(icuoValue,"/",",")
	....s icuoValue=$replace(icuoValue,"^",",")
	....s icuoValue=$replace(icuoValue,"#",",")
	....s icuoValue=$replace(icuoValue,"；",",")
	...s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
	...i ((ICUOViewCat="337")&&(icucriCode'="DongTaiNDT"))||(ICUOViewCat="340")||(ICUOViewCat="341")||((ICUOViewCat="343")&&(icucriCode'="QiGuanqkhy")&&(icucriCode'="QiGuanqkQingK")&&(icucriCode'="ChuangCiDian"))||((ICUOViewCat="338")&&(icucriCode'="TiWei")&&(icucriCode'="ZHIDONG")&&(icucriCode'="TiWeiBianHuan")&&(icucriCode'="ShenghuoHL")&&(icucriCode'="WithABone")) d   ///只显示项目名称：检验检查分类除了动态心电图，冷热疗分类，功能锻炼分类，换药分类除了气管切开换药，切口描述，血管通路穿刺点描述，基础护理分类中除了卧位，制动，体位变换，生活护理，骨科支具
	....s icuoValue=paraDesc
	...i ((icuoValue=0)&&(ICUOViewCat'="310")&&(ICUOViewCat'="215")&&(ICUOViewCat'="222")) s icuoValue=""    //评分,生命体征,出入量
	...i icuoUserDesc'="" d
	....q:UserFlag="Y"
	....i UserStr="" s UserStr=icuoUserDesc
	....e  i UserStr'[icuoUserDesc s UserStr=UserStr_"/"_icuoUserDesc
	....s UserFlag="Y"
	...i OtherDesc'="" d
	....q:otherUserFlag="Y"
	....i UserStr="" s UserStr=OtherDesc
	....e  i UserStr'[OtherDesc s UserStr=UserStr_"/"_OtherDesc
	....s otherUserFlag="Y"
	...s icuoOrderStr=icucriCode_"#"_icuoComOrdDr_"#"_icuoValue_"#"_ICUOViewCat_"#"_icuoId_"#"_ICUOICUPIDr
	...s alComDrStr=""
	...f alc=1:1:$length(orderStr,"@") d
	....s alComDrStr=alComDrStr_"^"_$p($p(orderStr,"@",alc),"#",2)
	...;i (orderStr'[icuoComOrdDr)||(haveDateFlag="Y")||(moreDataFlag="Y") d   //同一时间点同一项目多个数据
	...i (..CheckData(icuoComOrdDr,alComDrStr)="N")||(haveDateFlag="Y")||(moreDataFlag="Y") d    //同一时间点同一项目多个数据
	....i orderStr="" s orderStr=icuoOrderStr
	....e  s orderStr=orderStr_"@"_icuoOrderStr
	...e  d
	....i ($g(^TMPDHCICU("GetPrintOrdersNew",icuaId,curDate,icuoSttTime+n))'[icuoComOrdDr)&&($g(^TMPDHCICU("GetPrintOrdersNew",icuaId,curDate,icuoSttTime+n))'="") d
	.....s icuoOrderStr=$p(^TMPDHCICU("GetPrintOrdersNew",icuaId,curDate,icuoSttTime+n),"^",2)_"@"_icuoOrderStr
	.....s ^TMPDHCICU("GetPrintOrdersNew",icuaId,curDate,icuoSttTime+n)=^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime)_"^"_icuoOrderStr_"^"_UserStr
	....e  d
	.....s n=n+1
	.....;q:((icuoSttTime+n)<sttime)||((icuoSttTime+n)>endtime)
	.....i icuoOrderStr'="" s ^TMPDHCICU("GetPrintOrdersNew",icuaId,curDate,icuoSttTime+n)=^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime)_"^"_icuoOrderStr_"^"_UserStr
	..i (orderStr="")&&(icuoOrderStr'="") k ^TMPDHCICU("GetPrintOrdersNew",icuaId,curDate,icuoSttTime) q
	..;s UserStr=$p(UserStr,"/",1)
	..i orderStr'="" s ^TMPDHCICU("GetPrintOrdersNew",icuaId,curDate,icuoSttTime)=^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime)_"^"_orderStr_"^"_UserStr


    s Date="" f  s Date=$o(^TMPDHCICU("GetPrintOrdersNew",icuaId,Date)) q:Date=""  d
	.s Time="" f  s Time=$o(^TMPDHCICU("GetPrintOrdersNew",icuaId,Date,Time)) q:Time=""  d
	..s DT=$p($g(^TMPDHCICU("GetPrintOrdersNew",icuaId,Date,Time)),"^",1)
	..s Orders=$p($g(^TMPDHCICU("GetPrintOrdersNew",icuaId,Date,Time)),"^",2)
	..s User=$p($g(^TMPDHCICU("GetPrintOrdersNew",icuaId,Date,Time)),"^",3)
	..s ^TMPDHCICU("GetPrintOrdersNewOut",icuaId,Date,Time)=$lb(DT,Orders,User)
	

    ..Do PrintOrdersNew

			
		    

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK


PrintOrdersNew
 Set ^CacheTemp(repid,ind)=^TMPDHCICU("GetPrintOrdersNewOut",icuaId,Date,Time)
 Set ind=ind+1
 quit
}

ClassMethod GetPrintOrdersNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintOrdersNewExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else      {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetPrintOrdersNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintOrdersNewExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator：判断code是否在codeStr串中(区分大小写)
/// Input：  Code需判断的代码，codeStr代码串(^拼接)
/// Return： N:不在，Y:在
/// w ##Class(web.DHCICUPrintService).CheckData("aaa","aa^vv^cc")
ClassMethod CheckData(code As %String, codeStr As %String)
{
	s isMatch="N"
	s l=$length(codeStr,"^")
	f i=1:1:l d
	.s needCode=$p(codeStr,"^",i)
	.i code=needCode s isMatch="Y"
	
	q isMatch
}

/// Creator：判断code是否在codeStr串中的位置
/// Input：  Code需判断的代码，codeStr代码串(^拼接)
/// Return： index
/// w ##Class(web.DHCICUOrder).GetIndex("aaa","aa^vv^cc")
ClassMethod GetIndex(code As %String, codeStr As %String)
{
	s ret=0
	s l=$length(codeStr,"^")
	f i=1:1:l d
	.q:ret'=0
	.s needCode=$p(codeStr,"^",i)
	.i code=needCode s ret=i
	
	q ret
}

/// 获取病人打印生命体征折线图
/// d ##class(%ResultSet).RunQuery("web.DHCICUPrintService","GetPrintLineChar","14","2020/7/27","Temper")
Query GetPrintLineChar(icuaId, date, shiftSTime = "", shiftETime = "", ItemCodeStr) As %Query(ROWSPEC = "icucCode,CharStr") [ SqlProc ]
{
}

ClassMethod GetPrintLineCharExecute(ByRef qHandle As %Binary, icuaId, date, shiftSTime = "", shiftETime = "", ItemCodeStr) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPDHCICU("GetPrintLineChar")
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i shiftSTime="" s shiftSTime="7:00"
	i shiftETime="" s shiftETime="6:59"
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH(shiftSTime)
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH(shiftETime)
	
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoUserStr="",icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...;w !,icuoId
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    
	...s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...s comOrdFlag=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",10)
	...q:comOrdFlag="N"   //未激活
	...q:(ItemCodeStr'="")&&(ItemCodeStr'[icucriCode)
	...s icuoUserDr=$p($g(^DHCICUOrder(icuoId)),"^",4)
	...i icuoUserDr'="" s icuoUserDesc=$p($g(^SSU("SSUSR",icuoUserDr)),"^",2)
	...s OtherDesc=$p($g(^DHCICUOrder(icuoId,"OtherUser")),"^",2)
    ...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s icuoVolume=+$p($g(^DHCICUOrder(icuoId)),"^",28)
    
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...q:ICUOICUPIDr=""
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...;w !,icuoComOrdDr_"^"_icuoDataType_"^"_icucriCode_"^"_icuoQty_"^"_icuoNote
	...;i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Qty" s icuoValue=icuoQty
	...i icuoDataType="Volume" s icuoValue=icuoVolume
	...i icuoDataType="Note" s icuoValue=icuoNote
	...s ^TMPDHCICU("GetPrintLineChar",icuaId,icucriCode,curDate,icuoSttTime,icuoId)=icuoValue

    
    s icucCode="" f  s icucCode=$o(^TMPDHCICU("GetPrintLineChar",icuaId,icucCode)) q:icucCode=""  d
    .s CharStr=""
    .s icucdate="" f  s icucdate=$o(^TMPDHCICU("GetPrintLineChar",icuaId,icucCode,icucdate)) q:icucdate=""  d
    ..s icuctime="" f  s icuctime=$o(^TMPDHCICU("GetPrintLineChar",icuaId,icucCode,icucdate,icuctime)) q:icuctime=""  d
    ...s icucId="" f  s icucId=$o(^TMPDHCICU("GetPrintLineChar",icuaId,icucCode,icucdate,icuctime,icucId)) q:icucId=""  d
    ....s ret=""
    ....s icucValue=$g(^TMPDHCICU("GetPrintLineChar",icuaId,icucCode,icucdate,icuctime,icucId))
    ....q:icucValue=""
    ....s ret=$zd(icucdate,3)_" "_$zt(icuctime,2)_"^"_icucValue
    ....i CharStr="" s CharStr=ret
    ....e  s CharStr=CharStr_";"_ret
    .q:CharStr=""
    .s Data=$lb(icucCode,CharStr)
	

    .Do GetPrintLineChar

			
		    

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK


GetPrintLineChar
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetPrintLineCharFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintLineCharExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else      {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetPrintLineCharClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintLineCharExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/*
/// 获取病人打印生命体征记录单数据
/// d ##class(%ResultSet).RunQuery("web.DHCICUPrintService","GetPrintDataChar","14","2022-11-21","07:00:00","06:59:59","1_VitalSign^2_ContinuousInjectionPumps^3_IntravenousInfusion^4_NasalFeedingPumping^5_Injection^6_NursingRecordItems^7_ICUCareEvaluateItem^8_DrugIntake")
Query GetPrintDataChar(icuaId, date, shiftSTime = "", shiftETime = "", ViewCatStr, NeedSummary = "") As %Query(ROWSPEC = "icucViewCat,icucDesc,icupDr,icucDr,dateTime,DataStr,user") [ SqlProc ]
{
}

ClassMethod GetPrintDataCharExecute(ByRef qHandle As %Binary, icuaId, date, shiftSTime = "", shiftETime = "", ViewCatStr, NeedSummary = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPDHCICU("GetPrintDataChar")
	k ^TMPDHCICU("GetPrintDataCharOther")
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i shiftSTime="" s shiftSTime="7:00"
	i shiftETime="" s shiftETime="6:59"
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH(shiftSTime)
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH(shiftETime)
	
	s needViewCatStr=""
	f i=1:1:$length(ViewCatStr,"^") d
    .s VCDr=$p(ViewCatStr,"^",i)
    .s vCode=$p(VCDr,"_",2)
    .i needViewCatStr="" s needViewCatStr=vCode
    .e  s needViewCatStr=needViewCatStr_"^"_vCode
	
	s icuoUserStr=""
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...;w !,icuoId
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
    ...q:ICUOViewCat=""
    ...s viewCode=$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",1)
    ...q:(needViewCatStr'="")&&(..CheckData(viewCode,needViewCatStr)'="Y")
    ...s index="1"
    ...f i=1:1:$length(ViewCatStr,"^") d
    ....s VCDr=$p(ViewCatStr,"^",i)
    ....i $p(VCDr,"_",2)=$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",1) s index=$p(VCDr,"_",1)
    ...s icucViewCat=$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",2)
	...s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...s comOrdFlag=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",10)
	...q:comOrdFlag="N"   //未激活
	...s icuoUserDesc=""
	...s icuoUserDr=$p($g(^DHCICUOrder(icuoId)),"^",4)
	...i icuoUserDr'="" s icuoUserDesc=$p($g(^SSU("SSUSR",icuoUserDr)),"^",2)
	...i icuoUserStr'[icuoUserDesc d
	....i icuoUserStr="" s icuoUserStr=icuoUserDesc
	....e  s icuoUserStr=icuoUserStr_"  "_icuoUserDesc
	...s OtherDesc=$p($g(^DHCICUOrder(icuoId,"OtherUser")),"^",2)
    ...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s icuoVolume=+$p($g(^DHCICUOrder(icuoId)),"^",28)
    ...s paraDesc=""
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...i ICUOICUPIDr="" d  //自动采集的数据通过个人模板获取paraItem的Id
    ....s paraId=""
    ....s paraId=$o(^DHCICUPara(0,"ICUA",icuaId,paraId))
    ....q:paraId=""
    ....s paraChlId=""
    ....f  s paraChlId=$o(^DHCICUPara(paraId,"I",paraChlId)) q:paraChlId=""  d
    .....q:ICUOICUPIDr'=""
    .....s paraComDr=$p($g(^DHCICUPara(paraId,"I",paraChlId)),"^",4)
    .....s paraViewCat=$p($g(^DHCICUPara(paraId,"I",paraChlId)),"^",11) //237
    .....q:paraViewCat=237  //监护仪分类
    .....i paraComDr=icuoComOrdDr s ICUOICUPIDr=paraId_"||"_paraChlId 
    ...q:ICUOICUPIDr=""
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...q:($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'="")&&(icucriCode'="DaBian03")  //不取子项除大便量
	...q:$g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2)))=""
	...s paraViewCatId=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",11)
	...s paraViewCatCode=$p($g(^DHCICUC("ViewCat",paraViewCatId)),"^",1)
	...q:(needViewCatStr'="")&&(..CheckData(paraViewCatCode,needViewCatStr)'="Y")
	...s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
	...q:paraDesc=""
	...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...;w !,icuoComOrdDr_"^"_icuoDataType_"^"_icucriCode_"^"_icuoQty_"^"_icuoNote
	...;i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Qty" s icuoValue=icuoQty
	...i icuoDataType="Volume" s icuoValue=icuoVolume
	...i icuoDataType="Note" s icuoValue=icuoNote
	...q:index=""
	...s paraNo=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",8)
	...s mainDr=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)
	...i mainDr'="" d    //子项排序号与主项一致
	....s chlNo1=$p($g(^DHCICUPara($p(mainDr,"||",1),"I",$p(mainDr,"||",2))),"^",8)
	....s chlNo2=$p($g(mainDr),"||",2)/10000
	....s paraNo=chlNo1+chlNo2
	...i paraNo="" s paraNo=9999
	...i ICUOViewCat'=310 s ^TMPDHCICU("GetPrintDataChar",icuaId,index,paraNo,ICUOViewCat,ICUOICUPIDr,icuoComOrdDr,paraDesc,curDate,icuoSttTime,icuoId)=icuoValue_"^"_icuoUserDesc_"^"_icucriCode
    ...s ^TMPDHCICU("GetPrintDataCharOther",icuaId,curDate,icuoSttTime,icuoId)=paraDesc_":"_icuoValue
 
    
    ;最新执行医嘱获取
    d ..GetOrderItemList(icuaId,$zd(date,3)_" "_$zt(sttime,2),$zd(date+1,3)_" "_$zt(endtime,2))
    ;b //1
    s orRowId=""
    f  s orRowId=$o(^TMPICUPrint("GetPrintDataChar",$j,icuaId,orRowId)) q:orRowId=""  d
    .s orStDate=""
    .f  s orStDate=$o(^TMPICUPrint("GetPrintDataChar",$j,icuaId,orRowId,orStDate)) q:orStDate=""  d
    ..s orStTime=""
    ..f  s orStTime=$o(^TMPICUPrint("GetPrintDataChar",$j,icuaId,orRowId,orStDate,orStTime)) q:orStTime=""  d
    ...s orDesc=$list(^TMPICUPrint("GetPrintDataChar",$j,icuaId,orRowId,orStDate,orStTime),1)
    ...s orViewCat=$list(^TMPICUPrint("GetPrintDataChar",$j,icuaId,orRowId,orStDate,orStTime),2)
    ...s orVolume=$list(^TMPICUPrint("GetPrintDataChar",$j,icuaId,orRowId,orStDate,orStTime),3)
    ...i (orVolume>0)&(orVolume<1) s orVolume=$fn(orVolume,"",$l($p(orVolume,".",2)))
    ...;s orUserDesc=$list(^TMPICUPrint("GetPrintDataChar",icuaId,orRowId,orStDate,orStTime),4)
    ...;s orAuditUser=$list(^TMPICUPrint("GetPrintDataChar",icuaId,orRowId,orStDate,orStTime),5)
    ...s orCodeId=$list(^TMPICUPrint("GetPrintDataChar",$j,icuaId,orRowId,orStDate,orStTime),6)
    ...s orCode=$p($g(^DHCICUC("RecordItem",orCodeId)),"^",1)
    ...s icuoId="or"_orRowId
    ...;w !,orCodeId_"^"_orCode
    ...s ^TMPDHCICU("GetPrintDataChar",+icuaId,98,9888,orViewCat,"orderList","orderList",orDesc,orStDate,orStTime,icuoId)=orVolume_"^"_""_"^"_orCode
    
    
    i NeedSummary="Y" d
    .//出入量
    .f curDate=date:1:(date+1) d
	..f icuoSttTime=0:3600:82800 d
	...;w !,icuoSttTime
	...q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	...q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
    ...s inoutStr=..GetIcuInOut(icuaId,curDate,icuoSttTime,shiftSTime,shiftETime)  //出入量
    ...;w !,curDate_"^"_icuoSttTime
    ...s ^TMPDHCICU("GetPrintDataChar",icuaId,99,99999,222,"inout1","inout","总入量",curDate,icuoSttTime,"inout")=$p(inoutStr,"^",1)_"^"_""_"^"_"TotalIn2"
    ...s ^TMPDHCICU("GetPrintDataChar",icuaId,99,99999,222,"inout2","inout","总出量",curDate,icuoSttTime,"inout2")=$p(inoutStr,"^",2)_"^"_""_"^"_"TotalOut2"
    ...s ^TMPDHCICU("GetPrintDataChar",icuaId,99,99999,222,"inout3","inout","出入量平衡",curDate,icuoSttTime,"inout3")=$p(inoutStr,"^",3)_"^"_""_"^"_"TotalBalance2"
    
    
    
    i icuoUserStr'="" s ^TMPDHCICU("GetPrintDataCharOther",icuaId,date+1,25140,"ZQM")="护士"_":"_icuoUserStr_"   "_"审核人"

    s indx="" f  s indx=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx)) q:indx=""  d
    .s paraindx="" f  s paraindx=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx)) q:paraindx=""  d
    ..s viewCatDr="" f  s viewCatDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr)) q:viewCatDr=""  d
    ...s icupDr="" f  s icupDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr)) q:icupDr=""  d
    ....s icucViewCat=$p($g(^DHCICUC("ViewCat",viewCatDr)),"^",1)
    ....s icucDr="" f  s icucDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr)) q:icucDr=""  d
    .....s paraName="" f  s paraName=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr,paraName)) q:paraName=""  d
    ......s DataStr="",userStr=""
    ......s icucdate="" f  s icucdate=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr,paraName,icucdate)) q:icucdate=""  d
    .......s icuctime="" f  s icuctime=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime)) q:icuctime=""  d
    ........s icucId="" f  s icucId=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)) q:icucId=""  d
    .........s ret=""
    .........s icucValue=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",1)
    .........q:icucValue=""
    .........s icucValue=$replace(icucValue,";",",")
    .........s icucUser=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",2)
    .........s icucCode=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",3)
    .........i icucUser'="" s icucUser=$zd(icucdate,3)_" "_$zt(icuctime,2)_"^"_icucUser
    .........i userStr="" s userStr=icucUser
    .........e  i icucUser'="" s userStr=userStr_","_icucUser
    .........s ret=$zd(icucdate,3)_" "_$zt(icuctime,2)_"^"_icucValue
    .........i DataStr="" s DataStr=ret
    .........e  s DataStr=DataStr_";"_ret
    ......;s Data=$lb("签名",userStr)
    ......;Do GetPrintDataChar
    ......;q:icucriDesc'="ABP(mmHg)"
    ......s Data=$lb(icucViewCat,paraName,icupDr,icucCode,"",DataStr,userStr)
    ......Do GetPrintDataChar
    
    
	
	s odate="" f  s odate=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate)) q:odate=""  d
	.s otime="" f  s otime=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime)) q:otime=""  d
	..s DataStr=""
	..s icuoid="" f  s icuoid=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime,icuoid)) q:icuoid=""  d
	...s icuov=$g(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime,icuoid))
	...q:icuov=""
	...s icuov=$replace(icuov,";",",")
	...i DataStr="" s DataStr=icuov
	...e  s DataStr=DataStr_";"_icuov
	..s dateTime=$zd(odate,3)_" "_$zt(otime,2)
	..s Data=$lb("","","","",dateTime,DataStr,"")
    ..Do GetPrintDataChar

			
		    

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK


GetPrintDataChar
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetPrintDataCharFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintDataCharExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else      {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetPrintDataCharClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintDataCharExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}
*/
/// 获取病人打印生命体征记录单数据
/// d ##class(%ResultSet).RunQuery("web.DHCICUPrintService","GetPrintDataChar","14","2022-11-21","07:00:00","06:59:59","1_VitalSign^2_ContinuousInjectionPumps^3_IntravenousInfusion^4_NasalFeedingPumping^5_Injection^6_NursingRecordItems^7_ICUCareEvaluateItem^8_DrugIntake","Y")
/// d ##class(%ResultSet).RunQuery("web.DHCICUPrintService","GetPrintDataChar","2","2023-04-04","07:00:00","06:59:59","1_VitalSign^2_ContinuousInjectionPumps^3_IntravenousInfusion^4_NasalFeedingPumping^5_Injection^6_NursingRecordItems^7_ICUCareEvaluateItem^8_DrugIntake","Y")
/// d ##class(%ResultSet).RunQuery("web.DHCICUPrintService","GetPrintDataChar","2","2023-04-05","07:00:00","06:59:59","1_VitalSign^2_ContinuousInjectionPumps^3_IntravenousInfusion^4_NasalFeedingPumping^5_Injection^6_NursingRecordItems^7_ICUCareEvaluateItem^8_DrugIntake","Y")
Query GetPrintDataChar(icuaId, date, shiftSTime = "", shiftETime = "", ViewCatStr, NeedSummary = "", NewOrderExecInUse = "N") As %Query(ROWSPEC = "icucViewCat,icucDesc,icupDr,icucDr,dateTime,DataStr,user") [ SqlProc ]
{
}

ClassMethod GetPrintDataCharExecute(ByRef qHandle As %Binary, icuaId, date, shiftSTime = "", shiftETime = "", ViewCatStr, NeedSummary = "", NewOrderExecInUse = "N") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPDHCICU("GetPrintDataChar")
	k ^TMPDHCICU("GetPrintDataCharOther")
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i shiftSTime="" s shiftSTime="7:00"
	i shiftETime="" s shiftETime="6:59"
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH(shiftSTime)
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH(shiftETime)
	
	s needViewCatStr=""
	f i=1:1:$length(ViewCatStr,"^") d
    .s VCDr=$p(ViewCatStr,"^",i)
    .s vCode=$p(VCDr,"_",2)
    .i needViewCatStr="" s needViewCatStr=vCode
    .e  s needViewCatStr=needViewCatStr_"^"_vCode
	
	s icuoUserStr=""
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...;w !,icuoId
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
    ...q:ICUOViewCat=""
    ...s viewCode=$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",1)
    ...q:(needViewCatStr'="")&&(..CheckData(viewCode,needViewCatStr)'="Y")
    ...s index="1"
    ...f i=1:1:$length(ViewCatStr,"^") d
    ....s VCDr=$p(ViewCatStr,"^",i)
    ....i $p(VCDr,"_",2)=$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",1) s index=$p(VCDr,"_",1)
    ...s icucViewCat=$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",2)
	...s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...s comOrdFlag=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",10)
	...q:comOrdFlag="N"   //未激活
	...s icuoUserDesc=""
	...s icuoUserDr=$p($g(^DHCICUOrder(icuoId)),"^",4)
	...i icuoUserDr'="" s icuoUserDesc=$p($g(^SSU("SSUSR",icuoUserDr)),"^",2)
	...i icuoUserStr'[icuoUserDesc d
	....i icuoUserStr="" s icuoUserStr=icuoUserDesc
	....e  s icuoUserStr=icuoUserStr_"  "_icuoUserDesc
	...s OtherDesc=$p($g(^DHCICUOrder(icuoId,"OtherUser")),"^",2)
    ...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s icuoVolume=+$p($g(^DHCICUOrder(icuoId)),"^",28)
    ...s paraDesc=""
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...i ICUOICUPIDr="" d  //自动采集的数据通过个人模板获取paraItem的Id
    ....s paraId=""
    ....s paraId=$o(^DHCICUPara(0,"ICUA",icuaId,paraId))
    ....q:paraId=""
    ....s paraChlId=""
    ....f  s paraChlId=$o(^DHCICUPara(paraId,"I",paraChlId)) q:paraChlId=""  d
    .....q:ICUOICUPIDr'=""
    .....s paraComDr=$p($g(^DHCICUPara(paraId,"I",paraChlId)),"^",4)
    .....s paraViewCat=$p($g(^DHCICUPara(paraId,"I",paraChlId)),"^",11) //237
    .....q:paraViewCat=237  //监护仪分类
    .....i paraComDr=icuoComOrdDr s ICUOICUPIDr=paraId_"||"_paraChlId 
    ...q:ICUOICUPIDr=""
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...q:($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'="")&&(icucriCode'="DaBian03")  //不取子项除大便量
	...q:$g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2)))=""
	...s paraViewCatId=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",11)
	...s paraViewCatCode=$p($g(^DHCICUC("ViewCat",paraViewCatId)),"^",1)
	...q:(needViewCatStr'="")&&(..CheckData(paraViewCatCode,needViewCatStr)'="Y")
	...s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
	...q:paraDesc=""
	...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...;w !,icuoComOrdDr_"^"_icuoDataType_"^"_icucriCode_"^"_icuoQty_"^"_icuoNote
	...;i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Qty" s icuoValue=icuoQty
	...i icuoDataType="Volume" s icuoValue=icuoVolume
	...i icuoDataType="Note" s icuoValue=icuoNote
	...q:index=""
	...s paraNo=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",8)
	...s mainDr=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)
	...i mainDr'="" d    //子项排序号与主项一致
	....s chlNo1=$p($g(^DHCICUPara($p(mainDr,"||",1),"I",$p(mainDr,"||",2))),"^",8)
	....s chlNo2=$p($g(mainDr),"||",2)/10000
	....s paraNo=chlNo1+chlNo2
	...i paraNo="" s paraNo=9999
	...i ICUOViewCat'=310 s ^TMPDHCICU("GetPrintDataChar",icuaId,index,paraNo,ICUOViewCat,ICUOICUPIDr,icuoComOrdDr,paraDesc,curDate,icuoSttTime,icuoId)=icuoValue_"^"_icuoUserDesc_"^"_icucriCode
    ...s ^TMPDHCICU("GetPrintDataCharOther",icuaId,curDate,icuoSttTime,icuoId)=paraDesc_":"_icuoValue
 
    /*
    ///是否在生命体征单上面打印新医嘱数据项的地方
    */
    ;最新执行医嘱获取 start
    if (NewOrderExecInUse="Y")  d
    .d ..GetOrderItemList(icuaId,$zd(date,3)_" "_$zt(sttime,2),$zd(date+1,3)_" "_$zt(endtime,2))
    .;b //1
    .s orRowId=""
    .f  s orRowId=$o(^TMPICUPrint("GetPrintDataChar",$j,icuaId,orRowId)) q:orRowId=""  d
    ..s orStDate=""
    ..f  s orStDate=$o(^TMPICUPrint("GetPrintDataChar",$j,icuaId,orRowId,orStDate)) q:orStDate=""  d
    ...s orStTime=""
    ...f  s orStTime=$o(^TMPICUPrint("GetPrintDataChar",$j,icuaId,orRowId,orStDate,orStTime)) q:orStTime=""  d
    ....s orDesc=$list(^TMPICUPrint("GetPrintDataChar",$j,icuaId,orRowId,orStDate,orStTime),1)
    ....s orViewCat=$list(^TMPICUPrint("GetPrintDataChar",$j,icuaId,orRowId,orStDate,orStTime),2)
    ....s orVolume=$list(^TMPICUPrint("GetPrintDataChar",$j,icuaId,orRowId,orStDate,orStTime),3)
    ....i (orVolume>0)&(orVolume<1) s orVolume=$fn(orVolume,"",$l($p(orVolume,".",2)))
    ....;s orUserDesc=$list(^TMPICUPrint("GetPrintDataChar",icuaId,orRowId,orStDate,orStTime),4)
    ....;s orAuditUser=$list(^TMPICUPrint("GetPrintDataChar",icuaId,orRowId,orStDate,orStTime),5)
    ....s orCodeId=$list(^TMPICUPrint("GetPrintDataChar",$j,icuaId,orRowId,orStDate,orStTime),6)
    ....s orCode=$p($g(^DHCICUC("RecordItem",orCodeId)),"^",1)
    ....s icuoId="or"_orRowId
    ....;w !,orCodeId_"^"_orCode
    ....s ^TMPDHCICU("GetPrintDataChar",+icuaId,98,9888,orViewCat,"orderList","orderList",orDesc,orStDate,orStTime,icuoId)=orVolume_"^"_""_"^"_orCode
    ;最新执行医嘱获取 end
    
    s startDateTime=date+(sttime/100000)
	s endDateTime=(date+1)+(endtime/100000)

	
    if (NeedSummary="Y")  d
    .//出入量
    .for currentDate=date:1:(date+1)  d
	..for icuoSttTime=0:3600:82800  d
	...set currentDateTime=currentDate+(icuoSttTime/100000)
	...;q:((curDate=date)&&(icuoSttTime<sttime))    //早于开始时间
	...;q:((curDate=(date+1))&&(icuoSttTime>endtime))    //晚于结束时间
	...;quit:(((curDate=date)&&(icuoSttTime<sttime))||((curDate=(date+1))&&(icuoSttTime>endtime)))
	...quit:((currentDateTime<startDateTime)||(currentDateTime>endDateTime))
    ...set inoutStr=..GetIcuInOut(icuaId,currentDate,icuoSttTime,shiftSTime,shiftETime,NewOrderExecInUse)  //出入量
    ...;w icuaId_"^"_currentDate_"^"_icuoSttTime_"^"_shiftSTime_"^"_shiftETime_"@"_inoutStr,!
    ...set ^TMPDHCICU("GetPrintDataChar",icuaId,99,99999,222,"inout1","inout","总入量",currentDate,icuoSttTime,"inout")=$p(inoutStr,"^",1)_"^"_""_"^"_"TotalIn2"
    ...set ^TMPDHCICU("GetPrintDataChar",icuaId,99,99999,222,"inout2","inout","总出量",currentDate,icuoSttTime,"inout2")=$p(inoutStr,"^",2)_"^"_""_"^"_"TotalOut2"
    ...set ^TMPDHCICU("GetPrintDataChar",icuaId,99,99999,222,"inout3","inout","出入量平衡",currentDate,icuoSttTime,"inout3")=$p(inoutStr,"^",3)_"^"_""_"^"_"TotalBalance2"
        
    i icuoUserStr'="" s ^TMPDHCICU("GetPrintDataCharOther",icuaId,date+1,25140,"ZQM")="护士"_":"_icuoUserStr_"   "_"审核人"

    s indx="" f  s indx=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx)) q:indx=""  d
    .s paraindx="" f  s paraindx=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx)) q:paraindx=""  d
    ..s viewCatDr="" f  s viewCatDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr)) q:viewCatDr=""  d
    ...s icupDr="" f  s icupDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr)) q:icupDr=""  d
    ....s icucViewCat=$p($g(^DHCICUC("ViewCat",viewCatDr)),"^",1)
    ....s icucDr="" f  s icucDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr)) q:icucDr=""  d
    .....s paraName="" f  s paraName=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr,paraName)) q:paraName=""  d
    ......s DataStr="",userStr=""
    ......s icucdate="" f  s icucdate=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr,paraName,icucdate)) q:icucdate=""  d
    .......s icuctime="" f  s icuctime=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime)) q:icuctime=""  d
    ........s icucId="" f  s icucId=$o(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)) q:icucId=""  d
    .........s ret=""
    .........s icucValue=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",1)
    .........q:icucValue=""
    .........s icucValue=$replace(icucValue,";",",")
    .........s icucUser=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",2)
    .........s icucCode=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,indx,paraindx,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",3)
    .........i icucUser'="" s icucUser=$zd(icucdate,3)_" "_$zt(icuctime,2)_"^"_icucUser
    .........i userStr="" s userStr=icucUser
    .........e  i icucUser'="" s userStr=userStr_","_icucUser
    .........s ret=$zd(icucdate,3)_" "_$zt(icuctime,2)_"^"_icucValue
    .........i DataStr="" s DataStr=ret
    .........e  s DataStr=DataStr_";"_ret
    ......;s Data=$lb("签名",userStr)
    ......;Do GetPrintDataChar
    ......;q:icucriDesc'="ABP(mmHg)"
    ......s Data=$lb(icucViewCat,paraName,icupDr,icucCode,"",DataStr,userStr)
    ......Do GetPrintDataChar
    
    
	
	s odate="" f  s odate=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate)) q:odate=""  d
	.s otime="" f  s otime=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime)) q:otime=""  d
	..s DataStr=""
	..s icuoid="" f  s icuoid=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime,icuoid)) q:icuoid=""  d
	...s icuov=$g(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime,icuoid))
	...q:icuov=""
	...s icuov=$replace(icuov,";",",")
	...i DataStr="" s DataStr=icuov
	...e  s DataStr=DataStr_";"_icuov
	..s dateTime=$zd(odate,3)_" "_$zt(otime,2)
	..s Data=$lb("","","","",dateTime,DataStr,"")
    ..Do GetPrintDataChar
		    

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK


GetPrintDataChar
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetPrintDataCharFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintDataCharExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else      {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetPrintDataCharClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintDataCharExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取病人打印生命体征记录单数据
/// d ##class(%ResultSet).RunQuery("web.DHCICUPrintService","GetPrintDataChar","14","2020/7/27","VitalSign^ContinuousInjectionPumps^IntravenousInfusion^NasalFeedingPumping^Injection^NursingRecordItems^ICUCareEvaluateItem^DrugIntake")
Query GetPrintDataCharYC(icuaId, date, ViewCatStr) As %Query(ROWSPEC = "icucViewCat,icucDesc,icupDr,icucDr,dateTime,DataStr,user") [ SqlProc ]
{
}

ClassMethod GetPrintDataCharYCExecute(ByRef qHandle As %Binary, icuaId, date, ViewCatStr) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPDHCICU("GetPrintDataChar")
	k ^TMPDHCICU("GetPrintDataCharOther")
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH("8:00")
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH("7:59")
	
	s icuoUserStr=""
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	..s inoutId="",inoutValue="",inoutVC="",inoutUser="",inoutDesc=""
	..f  s inoutId=$o(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)) q:inoutId=""  d
	...s inoutValue=$p($g(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)),"^",1)
	...s inoutUserId=$p($g(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)),"^",2)
	...i inoutUserId'="" s inoutUser=$p($g(^SSU("SSUSR",inoutUserId)),"^",2)
	...s inoutCode=$p($g(^DHCICUC("RecordItem",inoutId)),"^",1)
	...s inoutDesc=$p($g(^DHCICUC("RecordItem",inoutId)),"^",2)
	...s inoutVC=$p($g(^DHCICUC("RecordItem",inoutId)),"^",5)
	...i inoutValue'="" s ^TMPDHCICU("GetPrintDataChar",icuaId,inoutVC,"InOut",inoutId,inoutDesc,curDate,icuoSttTime,"InOut")=inoutValue_"^"_inoutUser
	...;s inout=inoutCode_"#"_inoutId_"#"_inoutValue
	...;i inoutStr="" s inoutStr=inout
	...;e  s inoutStr=inoutStr_";"_inout
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...;w !,icuoId
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
    ...q:ICUOViewCat=""
    ...q:(ViewCatStr'="")&&(ViewCatStr'[$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",1))
    ...s icucViewCat=$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",2)
    
	...s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...s comOrdFlag=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",10)
	...q:comOrdFlag="N"   //未激活
	...s icuoUserDesc=""
	...s icuoUserDr=$p($g(^DHCICUOrder(icuoId)),"^",4)
	...i icuoUserDr'="" s icuoUserDesc=$p($g(^SSU("SSUSR",icuoUserDr)),"^",2)
	...i icuoUserStr'[icuoUserDesc d
	....i icuoUserStr="" s icuoUserStr=icuoUserDesc
	....e  s icuoUserStr=icuoUserStr_"  "_icuoUserDesc
	...s OtherDesc=$p($g(^DHCICUOrder(icuoId,"OtherUser")),"^",2)
    ...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s icuoVolume=+$p($g(^DHCICUOrder(icuoId)),"^",28)
    ...s paraDesc=""
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...i ICUOICUPIDr'="" d
    ....q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	....q:$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'=""  //不取子项
	....q:$g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2)))=""
	....s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
	...e  d
	....s ICUOICUPIDr=1
	....s paraDesc=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",2)
	...q:paraDesc=""
	...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...;w !,icuoComOrdDr_"^"_icuoDataType_"^"_icucriCode_"^"_icuoQty_"^"_icuoNote
	...;i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Qty" s icuoValue=icuoQty
	...i icuoDataType="Volume" s icuoValue=icuoVolume
	...i icuoDataType="Note" s icuoValue=icuoNote
	...i "IntravenousInfusion^Injection^ContinuousInjectionPumps^XZP^Oral,NasalFeedingPumping"[$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",1) s icuoValue=+icuoValue
	...s ^TMPDHCICU("GetPrintDataChar",icuaId,ICUOViewCat,ICUOICUPIDr,icuoComOrdDr,paraDesc,curDate,icuoSttTime,icuoId)=icuoValue_"^"_icuoUserDesc_"^"_icucriCode
    ...;s ^TMPDHCICU("GetPrintDataCharOther",icuaId,curDate,icuoSttTime,icuoId)=paraDesc_":"_icuoValue_"^"_icucriCode
    
    ;i icuoUserStr'="" s ^TMPDHCICU("GetPrintDataCharOther",icuaId,date+1,25140,"ZQM")="护士"_":"_icuoUserStr_"   "_"审核人"

    s viewCatDr="" f  s viewCatDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr)) q:viewCatDr=""  d
    .s icupDr="" f  s icupDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr)) q:icupDr=""  d
    ..s icucViewCat=$p($g(^DHCICUC("ViewCat",viewCatDr)),"^",1)
    ..s icucDr="" f  s icucDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr)) q:icucDr=""  d
    ...s paraName="" f  s paraName=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName)) q:paraName=""  d
    ....s DataStr="",userStr=""
    ....s icucdate="" f  s icucdate=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate)) q:icucdate=""  d
    .....s icuctime="" f  s icuctime=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime)) q:icuctime=""  d
    ......s icucId="" f  s icucId=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)) q:icucId=""  d
    .......s ret=""
    .......s icucValue=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",1)
    .......q:icucValue=""
    .......s icucValue=$replace(icucValue,";",",")
    .......s icucUser=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",2)
    .......i icucUser'="" s icucUser=$zd(icucdate,3)_" "_$zt(icuctime,2)_"^"_icucUser
    .......s icucCode=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",3)
    .......i userStr="" s userStr=icucUser
    .......e  i icucUser'="" s userStr=userStr_","_icucUser
    .......s ret=$zd(icucdate,3)_" "_$zt(icuctime,2)_"^"_icucValue
    .......i DataStr="" s DataStr=ret
    .......e  s DataStr=DataStr_";"_ret
    ....;s Data=$lb("签名",userStr)
    ....;Do GetPrintDataChar
    ....;q:icucriDesc'="ABP(mmHg)"
    ....s Data=$lb(icucViewCat,paraName,icupDr,icucCode,"",DataStr,userStr)
    ....Do GetPrintDataCharYC
    
    
	
	s odate="" f  s odate=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate)) q:odate=""  d
	.s otime="" f  s otime=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime)) q:otime=""  d
	..s DataStr=""
	..s icuoid="" f  s icuoid=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime,icuoid)) q:icuoid=""  d
	...s icuov=$g(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime,icuoid))
	...q:icuov=""
	...s icuov=$replace(icuov,";",",")
	...i DataStr="" s DataStr=icuov
	...e  s DataStr=DataStr_";"_icuov
	..s dateTime=$zd(odate,3)_" "_$zt(otime,2)
	..s Data=$lb("","","","",dateTime,DataStr,"")
    ..Do GetPrintDataCharYC

			
		    

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK


GetPrintDataCharYC
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetPrintDataCharYCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintDataCharYCExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else      {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetPrintDataCharYCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintDataCharYCExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetPrintPages(icuaId As %String) As %String
{
	q:(icuaId="")
	s Pages=0
	s Pages=$g(^DHCICUArrange(icuaId,"PrintPages"))
    
    q Pages
}

/// w ##Class(web.DHCICUPrintService).GetYLCodeStr()
ClassMethod GetYLCodeStr() As %String
{
   s YLCodeStr=""
   s icuoComOrdDr=""
   f  s icuoComOrdDr=$o(^DHCICUC("RecordItem",icuoComOrdDr)) q:icuoComOrdDr=""  d
   .s icucriTemplateDr=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",28)
   .q:icucriTemplateDr'=5661
   .s icucriViewCat=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",5)
   .q:icucriViewCat=222
   .s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
   .i YLCodeStr="" s YLCodeStr=icucriCode
   .e  s YLCodeStr=YLCodeStr_"^"_icucriCode
   
   q YLCodeStr
}

/// w ##Class(web.DHCICUPrintService).GetMainItemDesc(2004)
ClassMethod GetMainItemDesc(icuoId As %String) As %String
{
   q:icuoId="" ""
   s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
   q:ICUOICUPIDr="" ""
   s mainPIDr=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)
   i mainPIDr="" s mainPIDr=ICUOICUPIDr
   s itemDesc=""
   s itemDesc=$p($g(^DHCICUPara($p(mainPIDr,"||",1),"I",$p(mainPIDr,"||",2))),"^",14)
   
   q itemDesc
}

/// Creator：        王枭啸
/// CreatDate：      2021-8-26
/// Description：    获取病人打印信息(出入量单子)
/// Table：          DHC_ICU_Order
/// Input:           icuaId:病人重症id,stdate:开始日期,sttime:开始时间,enddate:结束日期,endtime:结束时间,ItemCodeStr:常用医嘱代码串
/// Return：         PrintDT:打印时间,Orders:打印内容,User:记录用户
/// d ##class(%ResultSet).RunQuery("web.DHCICUPrintService","GetPrintInOut","14","2020-06-1","07:00","6:59","DetailVolumePump^DetailDisposalInfusionPump^DetailVolumeIV^DetailVolumeInjection^DetailVolumeOral^DetailVolumeNasal^FoodVolume^SKFYYTKF")
Query GetPrintInOut(icuaId, date, shiftSTime, shiftETime, ItemCodeStr = "") As %Query(ROWSPEC = "Time,Code,Desc,Qty,User") [ SqlProc ]
{
}

ClassMethod GetPrintInOutExecute(ByRef qHandle As %Binary, icuaId, date, shiftSTime, shiftETime, ItemCodeStr = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i shiftSTime="" s shiftSTime="7:00"
	i shiftETime="" s shiftETime="6:59"
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH(shiftSTime)
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH(shiftETime)
	
	k ^TMPICU("GetPrintInOut")
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoUserStr="",icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...q:ICUOICUPIDr=""
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...s comOrdFlag=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",10)
	...q:comOrdFlag="N"   //未激活
	...q:..CheckData(icucriCode,ItemCodeStr)="N"
	...s icuoUserDr=$p($g(^DHCICUOrder(icuoId)),"^",4)
	...i icuoUserDr'="" s icuoUserDesc=$p($g(^SSU("SSUSR",icuoUserDr)),"^",2)
	...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10) 
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11) 
    ...s icuoVolume=+$p($g(^DHCICUOrder(icuoId)),"^",28)
    
	...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...;i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Qty" s icuoValue=icuoQty
	...i icuoDataType="Volume" s icuoValue=icuoVolume
	...i icuoDataType="Note" d
	....q:+icuoNote'=icuoNote   //非数值去掉
	....s icuoValue=icuoNote
	...s Desc=..GetMainItemDesc(icuoId)
	...s Time=$zt(icuoSttTime,2)
	...s index=..GetIndex(icucriCode,ItemCodeStr)
	...s ^TMPICU("GetPrintInOut",curDate,icuoSttTime,index,icuoId)=$lb(Time,icucriCode,Desc,+icuoValue,icuoUserDesc)
	
	s da="" f  s da=$o(^TMPICU("GetPrintInOut",da)) q:da=""  d
	.s t="" f  s t=$o(^TMPICU("GetPrintInOut",da,t)) q:t=""  d
	..s piDr="" f  s piDr=$o(^TMPICU("GetPrintInOut",da,t,piDr)) q:piDr=""  d
	...s rwId="" f  s rwId=$o(^TMPICU("GetPrintInOut",da,t,piDr,rwId)) q:rwId=""  d
	....s Time=$list(^TMPICU("GetPrintInOut",da,t,piDr,rwId),1)
	....s icucriCode=$list(^TMPICU("GetPrintInOut",da,t,piDr,rwId),2)
	....s Desc=$list(^TMPICU("GetPrintInOut",da,t,piDr,rwId),3)
	....s icuoValue=$list(^TMPICU("GetPrintInOut",da,t,piDr,rwId),4)
	....s icuoUserDesc=$list(^TMPICU("GetPrintInOut",da,t,piDr,rwId),5)
    ....Do PrintOrdersNew1

			
		    

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK


PrintOrdersNew1
 Set ^CacheTemp(repid,ind)=$lb(Time,icucriCode,Desc,+icuoValue,icuoUserDesc)
 Set ind=ind+1
 quit
}

ClassMethod GetPrintInOutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintInOutExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else      {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetPrintInOutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintInOutExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取导管内容
/// w ##Class(web.DHCICUPrintService).GetDGStr(12,"2021-08-10")
ClassMethod GetDGStr(icuaId As %String, date As %String, shiftSTime As %String = "", shiftETime As %String = "") As %String
{
	k ^TMPGetDGStr
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i shiftSTime="" s shiftSTime="7:00"
	i shiftETime="" s shiftETime="6:59"
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH(shiftSTime)
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH(shiftETime)
	s icuoUserStr=""
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...;w !,icuoId
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...q:((icuoComOrdDr=5956)||(icuoComOrdDr=6059)||(icuoComOrdDr=5602)||(icuoComOrdDr=5964)||(icuoComOrdDr=6354)||(icuoComOrdDr=6538)||(icuoComOrdDr=6795))	///ly20210512
    ...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
    ...q:(ICUOViewCat'="236")&&(ICUOViewCat'="235")   //导管
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...q:ICUOICUPIDr=""
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...s icupiSeqNo=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",8)  //排序号
	...;q:$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'=""  //不取子项
	...s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
	...
	...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s icuoVolume=+$p($g(^DHCICUOrder(icuoId)),"^",28)
    ...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...;i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Qty" s icuoValue=icuoQty
	...i icuoDataType="Volume" s icuoValue=icuoVolume
	...i icuoDataType="Note" s icuoValue=icuoNote
	...s mainPidr=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)  //主项模板ID
	...i mainPidr=""  d //主项
	....s ^TMPGetDGStr(ICUOICUPIDr)=paraDesc
	...e  d  //子项
	....s ^TMPGetDGStr(mainPidr,ICUOICUPIDr,icupiSeqNo)=paraDesc_":"_icuoValue
	
	s DGStr=""
	
	s i=0
	s mainId="" f  s mainId=$o(^TMPGetDGStr(mainId)) q:mainId=""  d
	.q:$g(^TMPGetDGStr(mainId))=""
	.s i=i+1
	.s DGDetail=i_"."_$g(^TMPGetDGStr(mainId))
	.s chlId="" f  s chlId=$o(^TMPGetDGStr(mainId,chlId)) q:chlId=""  d
	..s no="" f  s no=$o(^TMPGetDGStr(mainId,chlId,no)) q:no=""  d
	...s DGDetail=DGDetail_$c(3)_$g(^TMPGetDGStr(mainId,chlId,no))
	.i DGStr="" s DGStr=DGDetail
	.e  s DGStr=DGStr_$c(3)_DGDetail
	
	;b //1
	q DGStr
}

/*
/// 获取ICU出入量
/// w ##Class(web.DHCICUPrintService).GetIcuInOut(100,"2021-12-30","17:00")
ClassMethod GetIcuInOut(icuaId, date, time, shiftSTime = "", shiftETime = "") As %String
{
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	i shiftSTime="" s shiftSTime="7:00"
	i shiftETime="" s shiftETime="6:59"
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH(shiftSTime)
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH(shiftETime)
	s icuWardId=+$p($g(^DHCICUArrange(icuaId)),"^",4)  //病区id
	s ctLocId=$p($g(^PAWARD(icuWardId)),"^",5)  //科室id
	s inCodeStr="",outCodeStr=""
	s icuIOId=""
	f  s icuIOId=$o(^DHCICUC("IOItem",0,"Ctloc",ctLocId,icuIOId)) q:icuIOId=""  d
	.s ioType=$p($g(^DHCICUC("IOItem",icuIOId)),"^",3)
	.q:ioType=""
	.s ioComDr=$p($g(^DHCICUC("IOItem",icuIOId)),"^",4)
	.q:ioComDr=""
	.s ioComCode=$p($g(^DHCICUC("RecordItem",ioComDr)),"^",1)
	.s ioMultiple=$p($g(^DHCICUC("IOItem",icuIOId)),"^",11)
	.i ioType="I" d
	..i inCodeStr="" s inCodeStr=ioComCode
	..e  s inCodeStr=inCodeStr_"^"_ioComCode
	.i ioType="O" d
	..i outCodeStr="" s outCodeStr=ioComCode
	..e  s outCodeStr=outCodeStr_"^"_ioComCode
	;b //1
	//当前时间点出入量
	s nowIn=0,nowOut=0,nowBalance=0
	s nowTime=""
	f  s nowTime=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,nowTime)) q:nowTime=""  d
	.q:((nowTime<time)||(nowTime>=(time+3600)))
	.;w $zd(date,3)_"^"_$zt(nowTime,2),!
	.s icuoId=""
	.f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,nowTime,icuoId)) q:icuoId=""  d
	..s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	..q:orderEditFlag="C"
	..s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ..q:icuoComOrdDr=""
    ..s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ..i ICUOICUPIDr'="" d
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
    ..s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ..s icuoVolume=+$p($g(^DHCICUOrder(icuoId)),"^",28)
	..s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	..q:icuoDataType="Note"
	..i icuoDataType="Qty" s icuoValue=icuoQty
	..i icuoDataType="Volume" s icuoValue=icuoVolume
	..s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	..s comOrdFlag=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",10)
	..q:comOrdFlag="N"   //未激活
	..;q:(ItemCodeStr'="")&&(ItemCodeStr'[icucriCode)
	..i ..CheckData(icucriCode,inCodeStr)="Y" d  //入量
	...s multiple=..GetInOutMultiple(ctLocId,icucriCode)
	...q:multiple=0
	...s nowIn=nowIn+(icuoValue*multiple)
	..i ..CheckData(icucriCode,outCodeStr)="Y" d  //出量
	...s multiple=..GetInOutMultiple(ctLocId,icucriCode)
	...;w multiple_"^"_icucriCode,!
	...q:multiple=0
	...s nowOut=nowOut+(icuoValue*multiple)
	...;w !,nowOut_"^"_(icuoValue*multiple)_"^"_icucriCode_"^"_multiple
	s nowBalance=nowIn-nowOut
	
	s allIn=0,allOut=0,allBalance=0
	//当前班次开始时间到当前时间点的总出入量
	s stD="",endD=""
	i time<sttime s stD=date-1,endD=date
	i time>=sttime s stD=date,endD=date+1
	f curDate=stD:1:endD d
	.s sttTime=""
	.f  s sttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,sttTime)) q:sttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=stD)&&(sttTime<sttime)    //早于开始时间
	..q:(curDate=(stD+1))&&(sttTime>=(endtime + 3600))    //晚于开始时间
	..q:(curDate=date)&&(sttTime>=(time+ 3600)) 
	..q:curDate>date
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,sttTime,icuoId)) q:icuoId=""  d
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...i ICUOICUPIDr'="" d
    ....q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s icuoVolume=+$p($g(^DHCICUOrder(icuoId)),"^",28)
	...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...q:icuoDataType="Note"
	...i icuoDataType="Qty" s icuoValue=icuoQty
	...i icuoDataType="Volume" s icuoValue=icuoVolume
	...s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...s comOrdFlag=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",10)
	...q:comOrdFlag="N"   //未激活
	...;q:(ItemCodeStr'="")&&(ItemCodeStr'[icucriCode)
	...i ..CheckData(icucriCode,inCodeStr)="Y" d  //入量
	....s multiple=..GetInOutMultiple(ctLocId,icucriCode)
	....q:multiple=0
	....s allIn=allIn+(icuoValue*multiple)
	...i ..CheckData(icucriCode,outCodeStr)="Y" d  //出量
	....s multiple=..GetInOutMultiple(ctLocId,icucriCode)
	....q:multiple=0
	....s allOut=allOut+(icuoValue*multiple)
	s allBalance=allIn-allOut
	
	;b //1
	q +nowIn_"("_+allIn_")"_"^"_+nowOut_"("_+allOut_")"_"^"_+nowBalance_"("_+allBalance_")"
}
*/
/// 获取ICU出入量
/// NewOrderExecInUse该入参控制新医嘱数据是否统计到总入量和出入量平衡里面
/// w ##Class(web.DHCICUPrintService).GetIcuInOut(2,"2023-4-4","36000","7:00","6:59")
/// w ##Class(web.DHCICUPrintService).GetIcuInOut(2,"66568","36000","7:00","6:59")
/// w ##Class(web.DHCICUPrintService).GetIcuInOut(2,"66568","39600","7:00","6:59","Y")
ClassMethod GetIcuInOut(icuaId, date, time, shiftSTime = "", shiftETime = "", NewOrderExecInUse = "N") As %String
{
	set newOrderIn=0,newOrderInTotal=0
	
	///ly20230404	新医嘱入量计算 start
	set shiftSTimeH=##class(web.DHCClinicCom).ConvertToTimeH(shiftSTime)
	set shiftETimeH=##class(web.DHCClinicCom).ConvertToTimeH(shiftETime)
	if (time>=shiftSTimeH) set newOrderdate=date
	if (time<=shiftETime) set newOrderdate=date-1
	if (NewOrderExecInUse="Y")  d
	.set newOrderStDate=##class(web.DHCClinicCom).ConvertToDate(newOrderdate)
	.set newOrderEndDate=##class(web.DHCClinicCom).ConvertToDate(newOrderdate+1)
	.set newOrderDataStr=##class(ICU.BS.Order).GetOrderSumDataStr(icuaId,newOrderStDate_" "_shiftSTime,newOrderEndDate_" "_shiftETime)
	.for i=1:1:$length(newOrderDataStr,"^")  d
	..set newOrderData=$p(newOrderDataStr,"^",i)
	..quit:((newOrderData="")||($length(newOrderData,"#")<4))
	..for j=1:1:$length(newOrderData,"#")  d
	..set newOrderDateH=##class(web.DHCClinicCom).ConvertToDateH($p(newOrderData,"#",3))
	..set newOrderTimeH=##class(web.DHCClinicCom).ConvertToTimeH($p(newOrderData,"#",4))
	..if (((date=newOrderDateH)&&(time=newOrderTimeH))||(((date+1)=newOrderDateH)&&(time=newOrderTimeH)))  d
	...set newOrderIn=+$p(newOrderData,"#",1),newOrderInTotal=+$p(newOrderData,"#",2)
	...w newOrderIn_"^"_newOrderInTotal,!
	///ly20230404	新医嘱入量计算 end
	
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	i shiftSTime="" s shiftSTime="7:00"
	i shiftETime="" s shiftETime="6:59"
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH(shiftSTime)
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH(shiftETime)
	s icuWardId=+$p($g(^DHCICUArrange(icuaId)),"^",4)  //病区id
	s ctLocId=$p($g(^PAWARD(icuWardId)),"^",5)  //科室id
	s inCodeStr="",outCodeStr=""
	s icuIOId=""
	f  s icuIOId=$o(^DHCICUC("IOItem",0,"Ctloc",ctLocId,icuIOId)) q:icuIOId=""  d
	.s ioType=$p($g(^DHCICUC("IOItem",icuIOId)),"^",3)
	.q:ioType=""
	.s ioComDr=$p($g(^DHCICUC("IOItem",icuIOId)),"^",4)
	.q:ioComDr=""
	.s ioComCode=$p($g(^DHCICUC("RecordItem",ioComDr)),"^",1)
	.s ioMultiple=$p($g(^DHCICUC("IOItem",icuIOId)),"^",11)
	.i ioType="I" d
	..i inCodeStr="" s inCodeStr=ioComCode
	..e  s inCodeStr=inCodeStr_"^"_ioComCode
	.i ioType="O" d
	..i outCodeStr="" s outCodeStr=ioComCode
	..e  s outCodeStr=outCodeStr_"^"_ioComCode
	;b //1
	//当前时间点出入量
	s nowIn=0,nowOut=0,nowBalance=0
	s nowTime=""
	f  s nowTime=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,nowTime)) q:nowTime=""  d
	.q:((nowTime<time)||(nowTime>=(time+3600)))
	.;w $zd(date,3)_"^"_$zt(nowTime,2),!
	.s icuoId=""
	.f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,nowTime,icuoId)) q:icuoId=""  d
	..s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	..q:orderEditFlag="C"
	..s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ..q:icuoComOrdDr=""
    ..s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ..i ICUOICUPIDr'="" d
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
    ..s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ..s icuoVolume=+$p($g(^DHCICUOrder(icuoId)),"^",28)
	..s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	..q:icuoDataType="Note"
	..i icuoDataType="Qty" s icuoValue=icuoQty
	..i icuoDataType="Volume" s icuoValue=icuoVolume
	..s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	..s comOrdFlag=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",10)
	..q:comOrdFlag="N"   //未激活
	..;q:(ItemCodeStr'="")&&(ItemCodeStr'[icucriCode)
	..i ..CheckData(icucriCode,inCodeStr)="Y" d  //入量
	...s multiple=..GetInOutMultiple(ctLocId,icucriCode)
	...q:multiple=0
	...s nowIn=nowIn+(icuoValue*multiple)
	..i ..CheckData(icucriCode,outCodeStr)="Y" d  //出量
	...s multiple=..GetInOutMultiple(ctLocId,icucriCode)
	...;w multiple_"^"_icucriCode,!
	...q:multiple=0
	...s nowOut=nowOut+(icuoValue*multiple)
	...;w !,nowOut_"^"_(icuoValue*multiple)_"^"_icucriCode_"^"_multiple
	s nowBalance=nowIn-nowOut
	
	s allIn=0,allOut=0,allBalance=0
	//当前班次开始时间到当前时间点的总出入量
	s stD="",endD=""
	i time<sttime s stD=date-1,endD=date
	i time>=sttime s stD=date,endD=date+1
	f curDate=stD:1:endD d
	.s sttTime=""
	.f  s sttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,sttTime)) q:sttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=stD)&&(sttTime<sttime)    //早于开始时间
	..q:(curDate=(stD+1))&&(sttTime>=(endtime + 3600))    //晚于开始时间
	..q:(curDate=date)&&(sttTime>=(time+ 3600)) 
	..q:curDate>date
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,sttTime,icuoId)) q:icuoId=""  d
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...i ICUOICUPIDr'="" d
    ....q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s icuoVolume=+$p($g(^DHCICUOrder(icuoId)),"^",28)
	...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...q:icuoDataType="Note"
	...i icuoDataType="Qty" s icuoValue=icuoQty
	...i icuoDataType="Volume" s icuoValue=icuoVolume
	...s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...s comOrdFlag=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",10)
	...q:comOrdFlag="N"   //未激活
	...;q:(ItemCodeStr'="")&&(ItemCodeStr'[icucriCode)
	...i ..CheckData(icucriCode,inCodeStr)="Y" d  //入量
	....s multiple=..GetInOutMultiple(ctLocId,icucriCode)
	....q:multiple=0
	....s allIn=allIn+(icuoValue*multiple)
	...i ..CheckData(icucriCode,outCodeStr)="Y" d  //出量
	....s multiple=..GetInOutMultiple(ctLocId,icucriCode)
	....q:multiple=0
	....s allOut=allOut+(icuoValue*multiple)
	
	set allIn=allIn+newOrderInTotal,nowIn=nowIn+newOrderIn	///ly20230404
	
	s allBalance=allIn-allOut
	
	;b //1
	q +nowIn_"("_+allIn_")"_"^"_+nowOut_"("_+allOut_")"_"^"_+nowBalance_"("_+allBalance_")"
}

/// 出入量加减系数
/// w ##Class(web.DHCICUPrintService).GetInOutMultiple(480,"Stoolcount")
ClassMethod GetInOutMultiple(ctlocId, code) As %String
{
	s ret=0
	s icuIOId=""
	f  s icuIOId=$o(^DHCICUC("IOItem",0,"Ctloc",ctlocId,icuIOId)) q:icuIOId=""  d
	.s ioType=$p($g(^DHCICUC("IOItem",icuIOId)),"^",3)
	.q:ioType=""
	.s ioComDr=$p($g(^DHCICUC("IOItem",icuIOId)),"^",4)
	.q:ioComDr=""
	.s ioComCode=$p($g(^DHCICUC("RecordItem",ioComDr)),"^",1)
	.q:ioComCode'=code
	.s ioMainICUCIOIDr=$p($g(^DHCICUC("IOItem",icuIOId)),"^",9)
	.q:ioMainICUCIOIDr=""
	.s ioMainDesc=$p($g(^DHCICUC("IOItem",ioMainICUCIOIDr)),"^",2)
	.q:ioMainDesc["平衡" //平衡
	.s ioMultiple=$p($g(^DHCICUC("IOItem",icuIOId)),"^",11)
	.s ret=ioMultiple
	.;b //1
	
	q ret
}

/// 获取项目每小时汇总
/// w ##Class(web.DHCICUPrintService).GetSummaryPreHour(2,"2022-11-17","7:00","6:59","YaoJiaoShui^Yinshi3^DrugOrders","NasalFeedingPumping")
ClassMethod GetSummaryPreHour(icuaId, date, shiftSTime = "", shiftETime = "", comOrdDrStr, viewCatCodeStr, summaryType = "", notSummaryOrdDrStr = "") As %String
{
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i shiftSTime="" s shiftSTime="7:00"
	i shiftETime="" s shiftETime="6:59"
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH(shiftSTime)
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH(shiftETime)
	k ^TMPGetSummaryPreHour($j)
	f curDate=date:1:(date+1) d
	.f sumTimes=0:3600:82800 d
	..q:(curDate=date)&&(sumTimes<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(sumTimes>endtime)    //晚于开始时间	
	..s ^TMPGetSummaryPreHour($j,curDate,sumTimes)=0
	..s totalQty=0
	..s icuoSttTime=""
	..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	...q:((icuoSttTime<sumTimes)||(icuoSttTime>=(sumTimes+3600)))
	...q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	...q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	...s icuoId=""
	...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	....s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	....q:orderEditFlag="C"
	....s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ....q:icuoComOrdDr=""
    ....s icuoCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
    ....s comOrdFlag=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",10)
	....q:comOrdFlag="N"   //未激活
    ....s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
    ....q:ICUOViewCat=""
    ....s viewCode=$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",1)
    ....q:(..CheckData(icuoCode,comOrdDrStr)="N")&&(..CheckData(viewCode,viewCatCodeStr)="N")
    ....q:(..CheckData(icuoCode,notSummaryOrdDrStr)="Y")   //不汇总的项目
    ....s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ....i ICUOICUPIDr'="" d
    .....q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
    ....s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ....s icuoVolume=+$p($g(^DHCICUOrder(icuoId)),"^",28)
    ....s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
	....s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	....i icuoDataType="Note" s icuoValue=icuoNote
	....i icuoDataType="Qty" s icuoValue=icuoQty
	....i icuoDataType="Volume" s icuoValue=icuoVolume
	....q:+icuoValue'=icuoValue   //去掉非数值项
	....s totalQty=totalQty+icuoValue
	..s ^TMPGetSummaryPreHour($j,curDate,sumTimes)=^TMPGetSummaryPreHour($j,curDate,sumTimes)+totalQty
	
	i ..CheckData("DrugOrders",comOrdDrStr)="Y" d    //药品医嘱用量汇总
	.s instrIDStr="32^33^123^191^194^238"   //泵入药用法，与C#程序中OrderExecGridView.cs中的instrIDList一致
	.s startDT=$zd(date,3)_" "_$zt(sttime,2),endDT=$zd((date+1),3)_" "_$zt((endtime),2)
	.s volumeDetails=##class(ICU.BS.Order).GetOrderSumDetailJSON(icuaId,startDT,endDT)
	.f vDl=1:1:volumeDetails.%Size() d
	..s detailStr=volumeDetails.%Get(vDl-1)
	..s detailHourVol=detailStr.HourVol
	..s detailDate=detailStr.StartDate
	..s detailDate=##class(ICU.Utils.DateTime).ConvertToDateH(detailDate)
	..s detailTime=detailStr.StartTime
	..s detailTime=##class(ICU.Utils.DateTime).ConvertToTimeH(detailTime)
	..s Order=detailStr.OrderID
	..s InstructionID=$list(^ICU.Data.OrderD(Order),15)  //用法
	..q:(summaryType'="")&&(summaryType="NasalFeedingPumping")&&(..CheckData(InstructionID,instrIDStr)="N")   //获取泵入药汇总
	..;b //1
	..f curDate=date:1:(date+1) d
	...f sumTimes=0:3600:82800 d
	....q:(curDate=date)&&(sumTimes<sttime)    //早于开始时间
	....q:(curDate=(date+1))&&(sumTimes>endtime)    //晚于开始时间
	....q:((detailTime<sumTimes)||(detailTime>=(sumTimes+3600)))
	....;b //1
	....s ^TMPGetSummaryPreHour($j,curDate,sumTimes)=^TMPGetSummaryPreHour($j,curDate,sumTimes)+detailHourVol
	
	
	s ret=""
	s dates="" f  s dates=$o(^TMPGetSummaryPreHour($j,dates)) q:dates=""  d
	.s times="" f  s times=$o(^TMPGetSummaryPreHour($j,dates,times)) q:times=""  d
	..s qty=+$g(^TMPGetSummaryPreHour($j,dates,times))  //+sumQty
	..i (qty>0)&(qty<1) s qty=$fn(qty,"",$l($p(qty,".",2)))   //补0
	..i ret="" s ret=qty
	..e  s ret=ret_"^"_qty
	
	q ret
}

/// 获取子项数据
ClassMethod GetChlDatas(icuaId, mainPiDr, date, time) As %String
{
	s ret=""
	s icuoId=""
	k ^TMPGetChlDatas(icuaId,$j)
	f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,icuoId)) q:icuoId=""  d
	.q:$d(^DHCICUOrder(icuoId))<1
	.s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	.q:orderEditFlag="C"
	.s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
	.q:ICUOICUPIDr=""
	.q:$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'=mainPiDr
	.s paraNo=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",8)
	.s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    .q:icuoComOrdDr=""
    .s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    .s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    .s icuoVolume=+$p($g(^DHCICUOrder(icuoId)),"^",28)
    .s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
    .s paraDesc=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",2)
    .i icuoDataType="Qty" s icuoValue=icuoQty
	.i icuoDataType="Volume" s icuoValue=icuoVolume
	.i icuoDataType="Note" s icuoValue=icuoNote
	.s ^TMPGetChlDatas(icuaId,$j,paraNo,icuoId)=paraDesc_":"_icuoValue
	
	s index=0 f  s index=$o(^TMPGetChlDatas(icuaId,$j,index)) q:index=""  d
	.s icuId=0 f  s icuId=$o(^TMPGetChlDatas(icuaId,$j,index,icuId)) q:icuId=""  d
    ..i ret="" s ret=$g(^TMPGetChlDatas(icuaId,$j,index,icuId))
    ..e  s ret=ret_","_$g(^TMPGetChlDatas(icuaId,$j,index,icuId))
    
    q ret
}

/// 根据登记号查询重症病人
/// Input:regNo住院号
/// Output:病人姓名^重症ID(多个ID用,分隔)
/// w ##Class(web.DHCICUPrintService).GetICUPatientByRegNo("0000000534")
ClassMethod GetICUPatientByRegNo(regNo As %String) As %String
{
	s patName="",icuaIdStr=""
	s papmrId="" f  s papmrId=$o(^PAPERi("PAPMI_PatNo",regNo,papmrId)) q:papmrId=""  d
	.s patName=$p($g(^PAPER(papmrId,"ALL")),"^",1)
	.s EpisodeID="" f  s EpisodeID=$o(^PAPERdr(papmrId,"ADM","I",EpisodeID)) q:EpisodeID=""  d
	..s icuaId=""  f  s icuaId=$o(^DHCICUArrange(0,"Adm",EpisodeID,icuaId)) q:icuaId=""  d
	...i icuaIdStr="" s icuaIdStr=icuaId
	...e  s icuaIdStr=icuaIdStr_","_icuaId
	
	q patName_"^"_icuaIdStr
}

/// 根据重症Id获取重症记录信息
/// Input:icuaId重症Id
/// Output:病人姓名^就诊号^开始日期^结束日期
/// w ##Class(web.DHCICUPrintService).GetIcuInfo("14")
ClassMethod GetIcuInfo(icuaId As %String) As %String
{
	s patName=""
	s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s startDate=$p($g(^DHCICUArrange(icuaId)),"^",6)
	i startDate'="" s startDate=$zd(startDate,3)
	s endDate=$p($g(^DHCICUArrange(icuaId)),"^",7)
	i endDate'="" s endDate=$zd(endDate,3)
	
	q patName_"^"_EpisodeID_"^"_startDate_"^"_endDate
}

/// w ##Class(web.DHCICUPrintService).GetOrderItemList(2,"2022-11-16 7:00","2022-11-17 6:59")
ClassMethod GetOrderItemList(icuaId As %String, startDT As %String, endDT As %String) As %String
{
	set startDTH=##class(ICU.Utils.DateTime).ConvertToDateTimeH(startDT,"")
	set endDTH=##class(ICU.Utils.DateTime).ConvertToDateTimeH(endDT,"")
	kill ^TMPICUPrint("GetPrintDataChar",$j)
	;set patWardId=$p($g(^DHCICUArrange(icuaId)),"^",87)
	;set patLocId=$p($g(^PAWARD(patWardId)),"^",5)
	;b //2
	set instrIDStr="32^33^123^191^194^238"   //泵入药用法，与C#程序中OrderExecGridView.cs中的instrIDList一致
	set volumeDetails=##class(ICU.BS.Order).GetOrderSumDetailJSON(icuaId,startDT,endDT)
	kill ^TMPGetOrderItemList("OrderDT",$j)
	for vDl=1:1:volumeDetails.%Size()
	{
		set detailStr=volumeDetails.%Get(vDl-1)
		set detailTime=##class(ICU.Utils.DateTime).ConvertToTimeH(detailStr.StartTime)
		set Order=detailStr.OrderID
		if $get(^TMPGetOrderItemList("OrderDT",$j,Order))="" set ^TMPGetOrderItemList("OrderDT",$j,Order)=$zt(detailTime,2)
		else  set ^TMPGetOrderItemList("OrderDT",$j,Order)=^TMPGetOrderItemList("OrderDT",$j,Order)_"  "_$zt(detailTime,2)
		;b //1
	}
	
	for vDl=1:1:volumeDetails.%Size()
	{
		set detailStr=volumeDetails.%Get(vDl-1)
		set detailDate=detailStr.StartDate
		set detailTime=detailStr.StartTime
		set detailOrderId=detailStr.OrderID
		set detailHourVol=detailStr.HourVol
		set Order=detailOrderId
		set orderDesc=$list(^ICU.Data.OrderD(Order),3)    //描述
		set InstructionID=$list(^ICU.Data.OrderD(Order),15)  //用法
		set InstructionDesc=##class(CIS.AN.COM.String).GetDescByID("User.PHCInstruc","PHCINDesc1",InstructionID)
		set:(InstructionDesc'="") orderDesc=orderDesc_" ("_InstructionDesc_")"
		set FreqID=$list(^ICU.Data.OrderD(Order),19)  //频次
		set FreqDesc=##class(CIS.AN.COM.String).GetDescByID("User.PHCFreq","PHCFRDesc1",FreqID) //频次描述
		if FreqDesc'="" set orderDesc=orderDesc_"  "_FreqDesc
		set FreDetailId=0,FreDetailStr=""
		for
		{
			set FreDetailId=$Order(^PHCFR(FreqID,"DT",FreDetailId))
			quit:FreDetailId=""
			set FreDetail=$piece($get(^PHCFR(FreqID,"DT",FreDetailId)),"^",1)
			continue:FreDetail=""
			set FreDetail=$zt(FreDetail,4)
			if FreDetailStr="" set FreDetailStr=FreDetail
			else  set FreDetailStr=FreDetailStr_"-"_FreDetail
		}
		if FreDetailStr'="" set orderDesc=orderDesc_"("_FreDetailStr_")"
		if $get(^TMPGetOrderItemList("OrderDT",$j,Order))'="" set orderDesc=orderDesc_"  "_$get(^TMPGetOrderItemList("OrderDT",$j,Order))
		
		set orderDesc=$replace(orderDesc,$c(13,10),"+")
		set orderDesc=$replace(orderDesc,$c(10),"+")
		
		//获取执行医嘱的所属显示分类
		set viewCatId=252,oeorId=5016  //默认静脉输液
		if (..CheckData(InstructionID,instrIDStr)="Y") set viewCatId=253,oeorId=5017  //泵入 
		;i Order=30 w !,Order_"^"_orderDesc		
		set ^TMPICUPrint("GetPrintDataChar",$j,icuaId,detailOrderId,##class(ICU.Utils.DateTime).ConvertToDateH(detailDate),##class(ICU.Utils.DateTime).ConvertToTimeH(detailTime))=$lb(orderDesc,viewCatId,detailHourVol,"","",oeorId)
	}

	quit 0
}

}

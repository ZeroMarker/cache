Class web.DHCICUGDIPrintData
{

/// Creator：        王枭啸
/// CreatDate：      2018-10-28
/// Description：    获取病人打印信息
/// Table：          DHC_ICU_Order
/// Input:           icuaId:病人重症id,stdate:开始日期,sttime:开始时间,enddate:结束日期,endtime:结束时间,ItemCodeStr:常用医嘱代码串
/// Return：         PrintDT:打印时间,Orders:打印内容,User:记录用户
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrders","14","2020-04-29","14:36","2020-07-20","10:29","ExecTime^Temper^HR^Resp^NBP^ABP^SPO2^consciousnessICU^Pupil;Size^Pupil;LightReflecting^Pupil^OrderText^Administration^PQty^InfactQty^HisSpeed^UrineVolume^Proportion^Stool^OtherIOName^OtherIOQty^NursingRecord.PressureSoreICU.DVTScore.PipeScoreICU.FallScore.TTPF.RASS.CPOT.ZWScore.Glasgow.Overturn.SpongeBathInBed.AerosolInhalation.Sputum.AirwayCare.Oralcare.PerinealCare.DroppingTheTrachea.HLBCG.HLZDPT.QYZL.AVCare.CVP.BSICU.JCPGY.ICP.VentilatorMode.PEEP.FiO2.Ppeak.Pmean.VT.RAW.CR.ETCO2.OtherIn^NursingRecord^PressureSoreICU^DVTScore^PipeScoreICU^FallScore^TTPF^RASS^CPOT^ZWScore^Glasgow^Overturn^SpongeBathInBed^AerosolInhalation^Sputum^AirwayCare^Oralcare^PerinealCare^DroppingTheTrachea^HLBCG^HLZDPT^AVCare^Oralcare^CVP^BSICU^JCPGY^ICP^VentilatorMode^PEEP^FiO2^Ppeak^Pmean^VT^RAW^CR^ETCO2^OtherIn^OperationUser")
Query GetPrintOrders(icuaId, stdate, sttime, enddate, endtime, ItemCodeStr, ItemIfHaveDateStr = "") As %Query(ROWSPEC = "PrintDT,Orders,User") [ SqlProc ]
{
}

ClassMethod GetPrintOrdersExecute(ByRef qHandle As %Binary, icuaId, stdate, sttime, enddate, endtime, ItemCodeStr, ItemIfHaveDateStr = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPDHCICU("GetPrintOrders")
	k ^TMPDHCICU("GetPrintOrdersOut")
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
	..s icuoId=""
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
	...;q:(ItemCodeStr'="")&&(ItemCodeStr'[icucriCode)
	...q:..CheckData(icucriCode,ItemCodeStr)="N"
	...i ..CheckData(icucriCode,ItemIfHaveDateStr)="Y" d    //有项目才打印模式
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
	...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
	...;特殊字符处理
	...i ICUOViewCat="191"  d //护理记录 
	....s icuoValue=$replace(icuoValue,";",",")
	....s icuoValue=$replace(icuoValue,"/",",")
	....s icuoValue=$replace(icuoValue,"^",",")
	....s icuoValue=$replace(icuoValue,"#",",")
	....s icuoValue=$replace(icuoValue,"；",",")
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
	...s icuoOrderStr=icucriCode_"#"_icuoComOrdDr_"#"_icuoValue_"#"_ICUOViewCat_"#"_icuoId
	...i orderStr'[icuoComOrdDr d   //同一时间点同一项目多个数据
	....i orderStr="" s orderStr=icuoOrderStr
	....e  s orderStr=orderStr_"@"_icuoOrderStr
	...e  d
	....i ($g(^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime+n))'[icuoComOrdDr)&&($g(^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime+n))'="") d
	.....s icuoOrderStr=$p(^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime+n),"^",2)_"@"_icuoOrderStr
	.....s ^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime+n)=^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime)_"^"_icuoOrderStr_"^"_UserStr
	....e  d
	.....s n=n+1
	.....;q:((icuoSttTime+n)<sttime)||((icuoSttTime+n)>endtime)
	.....i icuoOrderStr'="" s ^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime+n)=^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime)_"^"_icuoOrderStr_"^"_UserStr
	..i (orderStr="")&&(icuoOrderStr'="") k ^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime) q
	..;s UserStr=$p(UserStr,"/",1)
	..i orderStr'="" s ^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime)=^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime)_"^"_orderStr_"^"_UserStr


    s Date="" f  s Date=$o(^TMPDHCICU("GetPrintOrders",icuaId,Date)) q:Date=""  d
	.s Time="" f  s Time=$o(^TMPDHCICU("GetPrintOrders",icuaId,Date,Time)) q:Time=""  d
	..s DT=$p($g(^TMPDHCICU("GetPrintOrders",icuaId,Date,Time)),"^",1)
	..s Orders=$p($g(^TMPDHCICU("GetPrintOrders",icuaId,Date,Time)),"^",2)
	..s User=$p($g(^TMPDHCICU("GetPrintOrders",icuaId,Date,Time)),"^",3)
	..s ^TMPDHCICU("GetPrintOrdersOut",icuaId,Date,Time)=$lb(DT,Orders,User)
	

    ..Do PrintOrdersNew

			
		    

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK


PrintOrdersNew
 Set ^CacheTemp(repid,ind)=^TMPDHCICU("GetPrintOrdersOut",icuaId,Date,Time)
 Set ind=ind+1
 quit
}

ClassMethod GetPrintOrdersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintOrdersExecute ]
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

ClassMethod GetPrintOrdersClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintOrdersExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator：判断code是否在codeStr串中(区分大小写)
/// Input：  Code需判断的代码，codeStr代码串(^拼接)
/// Return： N:不在，Y:在
/// w ##Class(web.DHCICUOrder).CheckData("aaa","aa^vv^cc")
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

/// Creator：      	wxx
/// CreatDate：    	2019-08-30
/// Description： 	保存病人打印记录
/// Table：        	DHC_ICU_PrintRecord
/// Input：        	入参：icuaId监护ID, sttime打印页起始日期, time打印页起始时间,enddate打印页结束日期, endtime打印页结束时间, dateTimeSeq序号(暂未用), page打印页, pageRow行数, userId用户
/// Return：       	返回：0成功，其它出错信息。
/// w ##Class(web.DHCICUOrder).SavePrintRecordNew("31299","2018-09-20","02:00","2018-09-20","15:30","5","20","113")
ClassMethod SavePrintRecordNew(icuaId, stdate, sttime, enddate, endtime, page, pageRow, userId) As %String
{
	s ^tmpwxx("SavePrintRecordXY",icuaId,$h)=icuaId_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_page_"^"_pageRow_"^"_userId
	q:icuaId="" "监护号不能为空!"
	q:'$d(^DHCICUArrange(icuaId)) "监护号没有数据!"
	q:page="" "页码不能为空!"
	q:(stdate="")!(sttime="")!(enddate="")!(endtime="") "日期和时间不能为空!"
	s stdate=##class(web.DHCCLCom).ConvertToDateH(stdate)
	s sttime=##class(web.DHCCLCom).ConvertToTimeH(sttime)
	s enddate=##class(web.DHCCLCom).ConvertToDateH(enddate)
	s endtime=##class(web.DHCCLCom).ConvertToTimeH(endtime)
	k PLIST
	s PLIST(3)=+$h
	s PLIST(4)=$p($h,",",2)
	s PLIST(5)=""
	s PLIST(6)=page
	s PLIST(7)=pageRow
	s PLIST(8)=userId
	s PLIST(9)=stdate
	s PLIST(10)=sttime
	s PLIST(11)=enddate
	s PLIST(12)=endtime
	
	s icuprSub=$o(^DHCICUArrange(0,"PrintPage",icuaId,page,""))
	i icuprSub'="" d
		.s icuprId=icuaId_"||"_icuprSub
		.&sql(update DHC_ICU_PrintRecord VALUES :PLIST() WHERE ICUPR_RowId=:icuprId)
	e  d
		.s PLIST(0)=icuaId
		.&sql(insert into DHC_ICU_PrintRecord VALUES :PLIST())
	s retStr=0
	i SQLCODE s retStr="保存数据错! code="_SQLCODE
	q retStr
}

/// Creator：      	wxx
/// CreatDate：    	2010-03-30
/// Description： 	获取病人打印记录
/// Table：        	DHC_ICU_PrintRecord
/// Input：        	入参：icuaId监护ID, date重症记录日期, time重症记录时间, page打印页。
/// Return：       	返回：0成功，其它出错信息。
/// w ##Class(web.DHCICUOrder).GetPrintRecordNew("123","","","")
ClassMethod GetPrintRecordNew(icuaId, date, time, page, isNextPage As %String = "Y") As %String
{
	q:icuaId="" "监护号不能为空!"
	q:'$d(^DHCICUArrange(icuaId)) "监护号没有数据!"
	//q:page="" "页码不能为空!"
	i date'="" s date=##class(web.DHCCLCom).ConvertToDateH(date)
	i time'="" s time=##class(web.DHCCLCom).ConvertToTimeH(time)
	i time'="",time\60*60=time s time=time+30
	
	s retStr="",icuprSub=""
	i page'="" s icuprSub=$o(^DHCICUArrange(0,"PrintPage",icuaId,page,""))
	i icuprSub="",date="" d
		.s page=$o(^DHCICUArrange(0,"PrintPage",icuaId,""),-1)
		.q:page=""
		.s icuprSub=$o(^DHCICUArrange(0,"PrintPage",icuaId,page,""),-1)
	i icuprSub'="" d
		.s icuprStr=$g(^DHCICUArrange(icuaId,"PR",icuprSub))
		.q:icuprStr=""
		.s $p(icuprStr,"^",1)=$zd($p(icuprStr,"^",1),3)
		.s $p(icuprStr,"^",2)=$zt($p(icuprStr,"^",2))
		.s $p(icuprStr,"^",7)=$zd($p(icuprStr,"^",7),3)
		.s $p(icuprStr,"^",8)=$zt($p(icuprStr,"^",8))
		.s $p(icuprStr,"^",9)=$zd($p(icuprStr,"^",9),3)
		.s $p(icuprStr,"^",10)=$zt($p(icuprStr,"^",10))
		.s retStr=$tr(icuprStr,"^",$c(3))
	q:retStr'="" retStr
	q:date="" retStr
	
	q retStr
}

ClassMethod SavePrintPages(icuaId, Pages) As %String
{
	q:(icuaId="")||(Pages="") ""
	s ^DHCICUArrange(icuaId,"PrintPages")=Pages
    
    q 0
}

/// w ##Class(web.DHCICUOrder).SaveICUInOut("14","2020/7/21","16:00","6691","7(13)","10211")
ClassMethod SaveICUInOut(icuaId, date, time, icuoComOrdDr, value, userId) As %String
{
	i date'="" s date=##class(web.DHCCLCom).ConvertToDateH(date)
	i time'="" s time=##class(web.DHCCLCom).ConvertToTimeH(time)
    s ^DHCICUOrder("ICUInOut",icuaId,date,time,icuoComOrdDr)=value_"^"_userId
    
    q 0
}

/// 获取病人打印生命体征折线图
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintLineChar","14","2020/7/27","Temper")
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

/// 获取病人打印生命体征记录单数据
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintDataChar","14","2022-03-21","07:00:00","06:59:59","1_VitalSign^2_ContinuousInjectionPumps^3_IntravenousInfusion^4_NasalFeedingPumping^5_Injection^6_NursingRecordItems^7_ICUCareEvaluateItem^8_DrugIntake")
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
	...q:$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'=""  //不取子项
	...q:$g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2)))=""
	...s paraViewCatId=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",11)
	...s paraViewCatCode=$p($g(^DHCICUC("ViewCat",paraViewCatId)),"^",1)
	...q:(needViewCatStr'="")&&(..CheckData(paraViewCatCode,needViewCatStr)'="Y")
	...s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
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
	...i paraNo="" s paraNo=9999
	...i ICUOViewCat'=310 s ^TMPDHCICU("GetPrintDataChar",icuaId,index,paraNo,ICUOViewCat,ICUOICUPIDr,icuoComOrdDr,paraDesc,curDate,icuoSttTime,icuoId)=icuoValue_"^"_icuoUserDesc_"^"_icucriCode
    ...s ^TMPDHCICU("GetPrintDataCharOther",icuaId,curDate,icuoSttTime,icuoId)=paraDesc_":"_icuoValue
    ...;s inoutStr=..GetIcuInOut(icuaId,curDate,icuoSttTime,shiftSTime,shiftETime)  //出入量
    ...;s ^TMPDHCICU("GetPrintDataChar",icuaId,99,222,"inout1","inout","总入量",curDate,icuoSttTime,"inout")=$p(inoutStr,"^",1)_"^"_""_"^"_"TotalIn2"
    ...;s ^TMPDHCICU("GetPrintDataChar",icuaId,99,222,"inout2","inout","总出量",curDate,icuoSttTime,"inout2")=$p(inoutStr,"^",2)_"^"_""_"^"_"TotalOut2"
    ...;s ^TMPDHCICU("GetPrintDataChar",icuaId,99,222,"inout3","inout","出入量平衡",curDate,icuoSttTime,"inout3")=$p(inoutStr,"^",3)_"^"_""_"^"_"TotalBalance2"
    
    i NeedSummary="Y"
    .//出入量
    .f curDate=date:1:(date+1) d
	..f icuoSttTime=0:3600:82800 d
	...q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	...q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
    ...s inoutStr=..GetIcuInOut(icuaId,curDate,icuoSttTime,shiftSTime,shiftETime)  //出入量
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

/// 获取病人打印生命体征记录单数据
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintDataChar","14","2020/7/27","VitalSign^ContinuousInjectionPumps^IntravenousInfusion^NasalFeedingPumping^Injection^NursingRecordItems^ICUCareEvaluateItem^DrugIntake")
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

/// w ##Class(web.DHCICUOrder).GetYLCodeStr()
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

/// w ##Class(web.DHCICUOrder).GetMainItemDesc(2004)
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
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintInOut","14","2020-06-1","07:00","6:59","DetailVolumePump^DetailDisposalInfusionPump^DetailVolumeIV^DetailVolumeInjection^DetailVolumeOral^DetailVolumeNasal^FoodVolume^SKFYYTKF")
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
    ....Do PrintOrdersNew

			
		    

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK


PrintOrdersNew
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
/// w ##Class(web.DHCICUOrder).GetDGStr(12,"2021-08-10")
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

/// 获取ICU出入量
/// w ##Class(web.DHCICUOrder).GetIcuInOut(100,"2021-12-30","17:00")
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
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=stD)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(stD+1))&&(icuoSttTime>=(endtime + 3600))    //晚于开始时间
	..q:(curDate=date)&&(icuoSttTime>=(time+ 3600)) 
	..q:curDate>date
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
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

/// 出入量加减系数
/// w ##Class(web.DHCICUOrder).GetInOutMultiple(480,"Stoolcount")
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
	.s ioMainDesc=$p($g(^DHCICUC("IOItem",ioMainICUCIOIDr)),"^",2)
	.q:ioMainDesc["出入量平衡" //出入量平衡
	.s ioMultiple=$p($g(^DHCICUC("IOItem",icuIOId)),"^",11)
	.s ret=ioMultiple
	.;b //1
	
	q ret
}

}

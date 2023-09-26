Import SQLUser

/// 该类主要处理入库、设备数据(DHC_ICU_DeviceData)与业务数据(DHC_ICU_CollectData)的转移
Class web.DHCICUDeviceData Extends web.DHCClinicCom
{

/// Creator：      	邓体进
/// CreatDate：    	2016-11-01
/// Description： 	ICU采集数据入库
/// Table：        	
/// Input：        	source:来源(I), equipId:设备Id,  dataPara:参数, status:状态, extInfo:扩展字段(自动识别时标识实际设备)
/// Output：        入库情况
/// Return：       	0: 正常 2:入库正常但未插入任何值 其他:失败
ClassMethod InsertToDb(equipId, dataPara, extInfo)
{
	// w ##class(web.DHCICUDeviceData).InsertToDb(equipId, dataPara, status, extInfo)
	i dataPara'["PatientID" d
	.s res=..InsertBedData(equipId, dataPara, extInfo)
	e  d
	.s res=..InsertShareDevByEquipId(equipId,extInfo,dataPara,"")
	q res
}

/// Creator：      	邓体进
/// CreatDate：    	2016-10-25
/// Description： 	与床位相关的ICU采集数据入库
/// Table：        	DHC_ICU_DeviceData
/// Input：        	source:来源(I), equipId:设备Id,  dataPara:参数, status:状态, extInfo:扩展字段(自动识别时标识实际设备)
/// Output：        入库情况
/// Return：       	0: 正常 2:入库正常但未插入任何值 其他:失败
ClassMethod InsertBedData(equipId, dataPara, extInfo)
{
	// w ##class(web.DHCICUDeviceData).InsertToDb(source, equipId, icuaId, extInfo, dataPara, status)
	s source="I"
	s devClass=$p(extInfo,".",1)
	s devType=$p(extInfo,".",2)
	i devType="" s devType=extInfo
	i devClass="" s devClass="Vent"
	s devTypeId=..GetDevTypeId(equipId,"Standard"_devClass) //GetDevTypeId(equipId,extInfo)
	if devTypeId="" s devTypeId=..GetDevTypeId(equipId,devType)
	q:((+devTypeId)<=0) "未知采集设备类型"
	
	// 循环解析数据
	s itemNum=$L(dataPara,"^")
	s resStr="",date="",time=""
	f i=1:1:itemNum d
	.s itemStr=$P(dataPara,"^",i)
	.q:itemStr=""
	.s itemName=$P(itemStr,"#",1)
	.s date=$P(itemStr,"#",2)
	.s time=$P(itemStr,"#",3)
	.
	.s value=$P(itemStr,"#",5)
	.s ancctiSub=$o(^DHCANC("CType",0,"ChannelNo",itemName,devTypeId,""))
	.q:ancctiSub=""
	.s recordItemId=$p(^DHCANC("CType",devTypeId,"I",ancctiSub),"^",1)
	.
	.q:recordItemId=""
	.
	.s field=$p($g(^DHCICUC("RecordItem",recordItemId)),"^",24)
	.s num="",text=""
	.i (field="Qty") s num=+value // 数值ICUO_Qty
	.e  i field="Note" s text=value // 文本ICUO_Note
	.
	.s res=..AddDeviceData(equipId,date,time,recordItemId,"",num,text)
	.i resStr="" s resStr="0 "_" "_itemName_":"_res
	.e  s resStr=resStr_","_itemName_":"_res
	
	// 将数据移动CollectData表中
	i ((date'="")&&(time'="")) d ..ProDeviceDataByDatetime(equipId,date,time)
	q resStr
}

/// Creator： ypz
/// CreatDate： 2012-11-28
/// Description： 保存数据到ICU表中
/// Table： DHC_AN_Order,DHC_AN_RoomEquip,DHC_AN_RoomEquipDetail
/// Input： opaId手术安排ID,icuaId重症监护安排ID,anreOrIcubeId手术间设备或监护床设备ID,userId;
/// para：分两级，第一级"^",第二级#。每条记录的数据。
/// chanalNo_#_sttDate_"#"_sttTime_"#"_ancoType(医嘱类型)_"#"_itemValue_"%"_itemValue2_"%"_itemValue3_"#"_ctuomId_"#"_icuoId(未用)_"#"_ancvcId_"#"_oeoriId(未用)"^"....
/// status: 当前设备任务的状态：
/// "Unstarted"：未启动
/// "Running"：正运行
/// "NetOffline"：网络问题
/// “NoData"：无数据，很可能是MOXA原因
/// Output： 
/// Return： 0-正常，1-病人ID不存在，2-未找到icuaId,3-equipId为空，4-equipId错误,其他-插入数据库有误
/// s equipId=1,anoSource="S",userId=""
/// s dataPara="Datetime#2013-04-28#11:16:56#V#2013-04-28 10:00:00####^PatientID#2013-04-28#11:16:56#V#C736539####^SampleType#2013-04-28#11:16:56#V#动脉^####^pH#2013-04-28#11:16:56#V#7.426####^pCO2#2013-04-28#11:16:56#V#29.3####^pO2(A)#2013-04-28#11:16:56#V#220####^K+#2013-04-28#11:16:56#V#3.6####^Na+#2013-04-28#11:16:56#V#136####^Ca++#2013-04-28#11:16:56#V#1.23####^Cl-#2013-04-28#11:16:56#V#112####^Glu#2013-04-28#11:16:56#V#6.5####^Lac#2013-04-28#11:16:56#V#1.1####^tHb#2013-04-28#11:16:56#V#9.0####^RHb#2013-04-28#11:16:56#V#-0.5####^O2Hb#2013-04-28#11:16:56#V#98.9####^sO2#2013-04-28#11:16:56#V#100.5####^COHb#2013-04-28#11:16:56#V#1.1####^MetHb#2013-04-28#11:16:56#V#0.5####^tBil#2013-04-28#11:16:56#V#9####^T#2013-04-28#11:16:56#V#37.0####^FIO2#2013-04-28#11:16:56#V#40.0####^p50(st)#2013-04-28#11:16:56#V#26.84####^pH(T)#2013-04-28#11:16:56#V#7.426####^pCO2(T)#2013-04-28#11:16:56#V#29.3####^HCO3-#2013-04-28#11:16:56#V#19.2####^SBE#2013-04-28#11:16:56#V#-5.2####^SBC#2013-04-28#11:16:56#V#20.5####^pO2(T)#2013-04-28#11:16:56#V#220####^pO2(A)#2013-04-28#11:16:56#V#100.3####^pO2(A),T#2013-04-28#11:16:56#V#150.3####^p50(act)#2013-04-28#11:16:56#V#25.23####^p50(act),T#2013-04-28#11:16:56#V#25.23####^AaDO2#2013-04-28#11:16:56#V#30.6####^tO2#2013-04-28#11:16:56#V#5.8####^RI#2013-04-28#11:16:56#V#14####^RI,T#2013-04-28#11:16:56#V#14####^Anion gap#2013-04-28#11:16:56#V#4.8####"
/// w ##class(web.DHCICUDeviceTask).InsertShareDev(anreOrIcubeId,anoSource,userId,dataPara,status)
ClassMethod InsertShareDevByEquipId(equipId As %String, extInfo As %String = "", dataPara As %String = "") As %String
{
	// w ##class(web.DHCICUDeviceTask).InsertShareDev(equipId,extInfo,dataPara)
	;s ^TMPANDEBUG("InsertShareDev")=$ztime($p($h,",",2))_equipId_","_anoSource_","_userId_","_dataPara_","
	// equipID是否在Global中
	s icuaId="" s medCareNo="" s actTime="" s ret=0 s insertStr="",SQLCODE=0,retStr=""
	// 查找病人ID
	s pId=..GetValue(dataPara,"PatientID") , isInserted=0 ,txtValue="" ,numValue=""
	s dateTime=..GetValue(dataPara,"DateTime")
	i dateTime="" q "DateTime is Null"
	s actDate=##class(web.DHCClinicCom).ConvertToDateH($p(dateTime,"~",1))
	i dateTime["~" d
	.s actTime=$zth($p(dateTime,"~",2))
	i pId="" q "1:NoPatInfo"
	// 若是检验号则通过检验号查找病人ID
	s tStr=$g(^TEPI(pId))
	i tStr'="" s pId=$p(tStr,"\",18)
	e  d
	.;认为是病案号
	.
	.s sub=0
	.f  s sub=$o(^DHCICUArrange(sub)) q:(sub="")  d
	..s arrangeStatus=$p($g(^DHCICUArrange(sub)),"^",18)
	..q:arrangeStatus'="M"
	..s EpisodeID=$p(^DHCICUArrange(sub),"^",1)
	..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	..;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	..s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	..s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	..s medCareNo=$$UPPER^SSUTIL4(medCareNo)
	..i medCareNo=$$UPPER^SSUTIL4(pId) s icuaId=sub 
	

	// 通过病人ID查找icuaId
	i icuaId="" s icuaId=##class(web.DHCICUCom).GetIcuaId("",pId,"") s icuaId=$p(icuaId,"^",1)
	i icuaId=""  q "2:InvalidPatInfo"
	q:('..IsJustLeaveDept(icuaId)) "3:离开科室超过24小时"
	
	s wardId=""
	s bedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	s wardId=$p(bedId,"||",1)
	// 获取设备类型ID
	s deviceObj=##class(User.DHCICUDevice).%OpenId(equipId)
	s ancctId=deviceObj.CollectInterfaceId.%Id()
    d deviceObj.%Close()
	
	q:ancctId="" "-4:未知设备"
	s cStr=..GetCalculateItems(icuaId,actDate,actTime,dataPara)
	s opDateTime=""
	
	i cStr'="" d
	.s opDateTime=$p(cStr,"@",2)
	.s cStr=$p(cStr,"@",1)
	.s dataPara=dataPara_"^"_cStr
	.
	//b "插入数据库"
	// 插入数据库
	s sType=..GetValue(dataPara,"SampleType")
	s CaValue=..GetValue(dataPara,"Ca+")
	s insertStr=insertStr_"icuaId:"_icuaId_" "
	s retStr=0 s itemNum=$L(dataPara,"^")	
	f i=1:1:itemNum d
	.;查找对应常用医嘱项
	.q:retStr'=0
	.s itemStr=$P(dataPara,"^",i)
	.s icubedChannelNo=$P(itemStr,"#",1)
	.q:icubedChannelNo=""
	.s ancctiSub=$o(^DHCANC("CType",0,"ChannelNo",icubedChannelNo,ancctId,""))
	.q:ancctiSub=""
	.q:$p(^DHCANC("CType",ancctId,"I",ancctiSub),"^",3)'="Y"
	.s icucriId=$p(^DHCANC("CType",ancctId,"I",ancctiSub),"^",1)
	.q:icucriId=""
	.q:'##class(User.DHCICUCRecordItem).%ExistsId(icucriId)
	.s record=##class(User.DHCICUCRecordItem).%OpenId(icucriId)
	.s sttDate=$P(itemStr,"#",2) ;发送日期
	.s sttTime=$P(itemStr,"#",3) ;发送时间
	.
	.s sttDate=##class(web.DHCClinicCom).ConvertToDateH(sttDate)
	.i $l(sttTime,":")>1 s sttTime=$zth(sttTime)
	.s endDate=sttDate
	.s endTime=sttTime
	.s ancoOrArcimValue=$P(itemStr,"#",5)
	.;是否在医嘱配置范围内
	.s max=$p($g(^DHCICUC("RecordItem",icucriId)),"^",21)
	.s min=$p($g(^DHCICUC("RecordItem",icucriId)),"^",22)
	.q:ancoOrArcimValue>max!ancoOrArcimValue>8000000!ancoOrArcimValue<min
	.s txtValue="" s numValue=""
	.s field=$p(^DHCICUC("RecordItem",icucriId),"^",24)
	.i (field="Qty")&&(ancoOrArcimValue'="")  s numValue=+ancoOrArcimValue
	.e  s txtValue=ancoOrArcimValue
	.s SQLCODE=0
	.i ((icubedChannelNo="DeviceName")&&(txtValue="GEMPremier4000")) s txtValue="GEM4000"
	.;Ca++小于0.6时
	.i ((wardId=33)&&(record.ICUCRICode="SampleType")&&(CaValue<0.6)) s txtValue="Venous"
	.s ret=..AddICUOrder(icuaId,icucriId,actDate,actTime,numValue,txtValue)
	.i ret>=0 s isInserted=1 s insertStr=insertStr_icubedChannelNo_"["_icucriId_"]"_","
	.i (cStr'="")&&("Gap;RATIO"[icubedChannelNo) d
	..s opDate=$p(opDateTime,",",1)
	..s opTime=$p(opDateTime,",",2)
	..
	..s ret=..AddICUOrder(icuaId,icucriId,opDate,opTime,numValue,txtValue)
	..
	..i ret>=0 s isInserted=1 s insertStr=insertStr_icubedChannelNo_"["_icucriId_"]"_","
	..s dataPara=dataPara_"^"_cStr
	i SQLCODE'=0 q SQLCODE
	
	// 根据时间找出这一时间的生理参数(监护仪、呼吸机等)并插入到DHC_ICU_Order
	s wardIds=$g(^DHCCLSet("RecentDataWardId")) ;不需要添加最近时间的参数的科室
	s wardId=$p($p($g(^DHCICUArrange(icuaId)),"^",4),"||",1)
	s time=actTime 
	s InsertedRecentData=""
	i ("^"_wardIds_"^")'[("^"_wardId_"^") ;d InsertReRecentData 根据血气时间点插入最近的生命体征数据
	
	// 计算氧合指数	
	i sType="Arterial" d
	.s PaO2=..GetValue(dataPara,"pO2")
	.;添加PaO2,用以计算评分
	.s ret=..AddICUOrder(icuaId,6596,actDate,actTime,PaO2,"")
	.i ret>=0 s insertStr=insertStr_"PaO2:"_PaO2_","
	.s FiO2=..GetICUValue(icuaId,actDate,actTime,5942) ;FiO2
	.s FiO2=+$p(FiO2,"^",1)
	.s oi=0
	.
	.i FiO2'=0 d
	..
	.e  d
	..s time=(actTime\3600)*3600
	..
	..s FiO2=..GetICUValue(icuaId,actDate,time,5942) ;手填的FiO2
	..s FiO2=+$p(FiO2,"^",1)
	..i FiO2=0 d
	...s FlowO2=+..GetICUValue(icuaId,actDate,time,5653) ;FlowO2氧流量
	...i FlowO2'=0 s FiO2=(FlowO2*4)+21
	...e  s FiO2=21
	.i ((FiO2<20)||(FiO2>100)) s FiO2=21
	.
	.s oi=PaO2/FiO2*100 ;氧合指数
	.i oi>0 d
	..s oi=$fn(oi,"",1)
	..s ret=..AddICUOrder(icuaId,5909,actDate,actTime,oi,"")
	..i ret>=0 s isInserted=1 s insertStr=insertStr_"OI:"_oi_","
	
	
	i (isInserted=0)&&(retStr=0) s retStr="NoInsertedItem"_":"_icuaId_" "_insertStr
	q retStr_" "_icuaId_" "_insertStr_" RecentData:"_InsertedRecentData
	
	
InsertReRecentData	
	f  s time=$o(^DHCICUArrange(0,"CData",icuaId,actDate,time),-1) q:time=""  d
	.i ($zabs(actTime-time)>(20*60)) s isExit=1 q // 20分钟内数据
	.s icucdSub=""
	.f  s icucdSub=$o(^DHCICUArrange(0,"CData",icuaId,actDate,time,icucdSub)) q:icucdSub=""  d
	..s item=$g(^DHCICUArrange(icuaId,"C",icucdSub))
	..q:item=""
	..s icucriId=$p(item,"^",1)
	..q:icucriId=""
	..
	..s txtValue="" s numValue=""
	..s txtValue=$p(item,"^",4)
	..s numValue=$p(item,"^",5)
	..s ret=..AddICUOrder(icuaId,icucriId,actDate,actTime,numValue,txtValue)
	..s code=$p($g(^DHCICUC("RecordItem",icucriId)),"^",1)
	..s InsertedRecentData=InsertedRecentData_code_"["_icucriId_"-"_ret_"]"_","
	..q
	q
}

ClassMethod GetDevTypeId(equipId, extInfo)
{
	// w ##class(web.DHCICUDeviceData).GetDevTypeId(equipId)
	// 如RELAY设备，则获取真实的设备ID
	s devTypeId=""
	&sql(SELECT CollectInterfaceId into :devTypeId FROM DHC_ICU_Device WHERE RowId=:equipId)
	s source="I"
	q:devTypeId="" "Invalid EquipId"
	s obj=##class(User.DHCANCCollectType).%OpenId(devTypeId)
	s devCode=obj.ANCCTCode
	d obj.%Close()
	// 如果是自动识别或模拟设备，则查找设备类型Id
	i (((devCode="AutoCheckDev")||(devCode="TestDev"))) d 
	.;查找设备类型Id
	.s devTypeId=##class(web.DHCANCCollectType).GetDevIdByCode(extInfo,source)
	q devTypeId
}

ClassMethod GetIcuaId(equipId)
{
	// w ##class(web.DHCICUDeviceData).GetIcuaId(equipId)
	// equipId > bedId > 当前床位就诊号 > icuaId
	s bedId=""
	&sql(SELECT BedId into :bedId FROM DHC_ICU_BedDevice WHERE DeviceId=:equipId)
	q:bedId="" ""
	//s EpisodeID=$$GetCurEpisodeIDByBedId(bedId)
	//q:EpisodeID="" ""
	&sql(SELECT ICUA_RowId into:icuaId FROM DHC_ICU_Arrange 
	WHERE ICUA_Status="M" and ICUA_Bed_Dr=:bedId order by ICUA_StartDate,ICUA_StartTime)
	// ICUA_Adm_Dr=:EpisodeID)
	q icuaId
GetCurEpisodeIDByBedId(bedId)
	s EpisodeID=""
	s wardId=$p(bedId,"||",1)
	// 获取当前病区正病区、在床位的就诊号
	// &sql(SELECT PAADM_RowID into:EpisodeID FROM PA_Adm 
	// WHERE PAADM_CurrentWard_DR=:wardId and PAADM_VisitStatus="A" and PAADM_CurrentBed_DR=:bedId)
	s roomId="" f  s roomId=$O(^PAADMi("CurrWard",wardId,roomId)) q:roomId=""  d
	.s sub="" f  s sub=$O(^PAADMi("CurrWard",wardId,roomId,sub)) q:sub=""  d
	..s curBedId=$p($g(^PAADM(sub)),"^",73)
	..q:curBedId'=bedId
	..s visitStatus=$p($g(^PAADM(sub)),"^",20)
	..q:visitStatus'="A"
	..s EpisodeID=sub
	q EpisodeID
}

ClassMethod AddDeviceData(equipId, date, time, recordItemId, icuaId, num, text)
{
	// w ##class(web.DHCICUDeviceData).AddDeviceData(equipId,date,time,recordItemId,icuaId,num,text)
	i '$ISVALIDNUM(date) s date=..ConvertToDateH(date)
	i '$ISVALIDNUM(time) s time=..ConvertToTimeH(time)
	
	s field=$p($g(^DHCICUC("RecordItem",recordItemId)),"^",24)
	s max=$p($g(^DHCICUC("RecordItem",recordItemId)),"^",21)
	s min=$p($g(^DHCICUC("RecordItem",recordItemId)),"^",22)
	q:(field="Qty")&&(((max'="")&&(num>max))) num_">max"
	q:(field="Qty")&&((min'="")&&(num<min)) num_"<min"
	
	s updateDate=$p($h,",",1)
	s updateTime=$p($h,",",2)
	s rowId=""
	&sql(select top 1 ID into:rowId from DHC_ICU_DeviceData where equipId=:equipId and StartDate=:date and StartTime=:time and RecordItemId=:recordItemId)
	s SQLCODE=""
	i rowId>0 d
	.
	.&sql(update DHC_ICU_DeviceData set Num=:num,Text=:text,UpdateDate=-1,UpdateTime=:updateTime where Id=:rowId)
	e  d
	.&sql(INSERT INTO DHC_ICU_DeviceData(IcuaId,EquipId,RecordItemId,StartDate,StartTime,Num,Text,UpdateDate,UpdateTime) VALUES(:icuaId,:equipId,:recordItemId,:date,:time,:num,:text,:updateDate,:updateTime))
	s rowId=$g(%ROWID)
	i icuaId'="" d ##class(web.DHCICUCom).InsertCollectData(icuaId,recordItemId,date,time,num,text)
	
	q rowId
}

/// Creator：      	邓体进
/// CreatDate：    	2016-10-27
/// Description： 	添加计算数据
///                  特殊扩展参数:血气、血流动力学参数等个别参数需要病人信息(如身高体重)才能计算
/// 					 注: 常规扩展参数推荐在采集端完成(可以配置实现)
/// Table：        	DHC_ICU_DeviceData
/// Input：        	wardId: 病区ID,date/time:采集入库的时间,scope:查找数据的时间范围
/// Output：        入库情况
/// Return：       	0: 正常 
ClassMethod AddExtendData(icuaId, fromDate, fromTime)
{
	s EventData(wardId,"NBP")="N_SYS;N_MEAN;N_DIA"
	s EventData(wardId,"NBP")="N_SYS;N_MEAN;N_DIA"
	s EventData(wardId,"NBP")="N_SYS;N_MEAN;N_DIA"
	
	// 查找
	s w=+..GetDeviceDataValue(dataPara,"Weight")
	s h=+..GetDeviceDataValue(dataPara,"Height")
	s bsa=+..GetDeviceDataValue(dataPara,"BSA")
	
	s weight=$p(^DHCICUArrange(icuaId),"^",25)
	s height=$p(^DHCICUArrange(icuaId),"^",24)
	i ((weight'=w)||(height'=h))  d
	.s $p(^DHCICUArrang(icuaId),"^",25)=w
	.s $p(^DHCICUArrang(icuaId),"^",24)=h
	
	s EpisodeID=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	s sex=##class(web.DHCICUCom).GetGender(EpisodeID)
	
	i sex="Female" s sex="F"
	e  s sex="M"
	
	s item=$p(dataPara,"^",1)
	s date=$P(item,"#",2)
	s time=$P(item,"#",3)
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	
	s map=+..GetDeviceDataValue(icuaId,date,time,"MAP") ; MAP(ABPm)
	
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=##class(web.DHCClinicCom).CalAge(birth,date)
	
	
	
	q retStr
}

ClassMethod GetDeviceDataValue(equipId, code, date, time)
{
	// w ##class(web.DHCICUDeviceData).GetDeviceDataValue(equipId,code,date,time)
	// w ##class(web.DHCICUDeviceData).GetDeviceDataValue(1,"HR","2016-10-25","09:22")
	s recordItemId=..GetRecordIteId(code)
	q:recordItemId="" ""
	s id="",num="",text=""
	&sql(select ID,Num,Text into :id,:num,:text from DHC_ICU_DeviceData 
	where EquipId=:equipId and RecordItemId=:recordItemId)
	q:id="" ""
	
	s field=$p($g(^DHCICUC("RecordItem",recordItemId)),"^",24)
	s value=""
	i (field="Qty") s value=num // 数值ICUO_Qty
	e  i field="Note" s value=text // 文本ICUO_Note
	
	q value
}

/// Creator：      	邓体进
/// CreatDate：    	2016-10-27
/// Description： 	按病区插入每小时数据
/// Table：        	
/// Input：        	wardId: 病区ID,date/time:采集入库的时间,scope:查找数据的时间范围
/// Output：        入库情况
/// Return：       	0: 正常 
ClassMethod AddWardCollectData(wardId, date, time, scope = 3600)
{
	// w ##class(web.DHCICUDeviceData).AddWardCollectData(wardId,date,time,scope)
	// w ##class(web.DHCICUDeviceData).AddWardCollectData(23,"2016-10-26","14:00")
	
	s isConfirmed=0
	s retStr=2
	s date=..ConvertToDateH(date)
	s time=..ConvertToTimeH(time)
	
	s patientList=##class(web.DHCICUCom).FindWardPatient(wardId, "")
	q:patientList="" 0
	f i=1:1:$l(patientList,"^") {
		s icuaId=$p($p(patientList,"^",i),"|",4)
		w "DeviceDataToOrder:",icuaId,!
		q:icuaId=""
		
	}
	q 0
}

ClassMethod AddCollectData(icuaId, date, time, scope = 3600)
{
	// w ##class(web.DHCICUDeviceData).AddCollectData(icuaId,date,time,scope)
	// w ##class(web.DHCICUDeviceData).AddCollectData(1,"2016-10-25","09:22")
	s date=..ConvertToDateH(date)
	s time=..ConvertToTimeH(time)
	s recordItemId=""
	for{
		s recordItemId=$o(^DHCICUDeviceData(0,"IcuaId",icuaId,recordItemId))
		b // recordId
		q:recordItemId=""
		
		s curDate=date
		s curTime=time+1
		s res=$$Check(recordItemId,curDate,curTime)
		if ((time-scope)>0)&&(res=0) {
			 s res=$$Check(recordItemId,curDate,curTime)
		}
	}
	q 1
Check(recordItemId,curDate,curTime)
	s curDate=date-1
	s curTime=24*3600
	s curTime=$o(^DHCICUDeviceData(0,"IcuaId",icuaId,recordItemId,curDate,curTime),-1)
	s curDateTime=curDate*3600*24+curTime
	s dateTime=date*3600*24+time
	s curScope=dateTime-curDateTime
	q:(..IsEventData(recordItemId)'=1) 2
	i ((curScope<scope)&&(curTime'="")) d Insert q 1
	q 0
Insert
	s rowId=$o(^DHCICUDeviceData(0,"IcuaId",icuaId,recordItemId,curDate,curTime,""))
	q:rowId=""
	s obj=##class(User.DHCICUDeviceData).%OpenId(rowId)
	d obj.%Close()
	w "insert:",rowId,!
	
	s res=##class(web.DHCICUCom).Insert2ICUOrder(icuaId, obj.RecordItemId, obj.StartDate, obj.StartTime, obj.Num, obj.Text, "")
	b //
	w "Insert2ICUOrder",res,!
	q res
Should
}

ClassMethod GetRecordIteId(code)
{
	// w ##class(web.DHCICUDeviceData).GetRecordIteId(code)
	s rowId=""
	&sql(SELECT ICUCRI_RowId into:rowId FROM DHC_ICUC_RecordItem WHERE ICUCRI_Code=:code)
	q rowId
}

/// Creator：      	邓体进
/// CreatDate：    	2016-11-17
/// Description： 	添加某时间点的数据
/// Table：        	
/// Input：        	equipId:设备号
/// Output：        从BedDevice表查找equipId,找到:1,未找到0
/// Return：       	0: 不是共享设备 
ClassMethod IsShareEquip(equipId)
{
	q 0
}

/// Creator：      	邓体进
/// CreatDate：    	2016-11-17
/// Description： 	某时间点,数据是否是事件类型的
/// Table：        	DHC_ICU_DeviceData
/// Input：        	equipId:设备号,date,time
/// Output：        
/// Return：       	1:是 0:否
ClassMethod IsEventData(equipId, date, time)
{
	// 通过判断数据中是否有DateTime判断
	s recordItemId=""
	&sql(SELECT ICUCRI_RowId into :recordItemId FROM DHC_ICUC_RecordItem WHERE ICUCRI_Code="DateTime")
	q:recordItemId="" 0
	
	s sub=$O(^DHCICUDeviceData(0,"EquipId",equipId,date,time,recordItemId,""))
	q:sub'="" 1
	q 0
}

/// Creator：      	邓体进
/// CreatDate：    	2016-11-17
/// Description： 	某时间点,数据是否是事件类型的
/// Table：        	DHC_ICU_DeviceData
/// Input：        	equipId:设备号,date,time
/// Output：        
/// Return：       	1:是 0:否
ClassMethod GetIcuaIdByData(equipId, date, time)
{
	// 通过判断数据中是否有PatientId判断
	s recordItemId=""
	&sql(SELECT ICUCRI_RowId into :recordItemId FROM DHC_ICUC_RecordItem WHERE ICUCRI_Code="PatientId")
	q:recordItemId="" 0
	
	s sub=$O(^DHCICUDeviceData(0,"EquipId",equipId,date,time,recordItemId,""))
	q:sub'="" ""
	s obj=##class(User.DHCICUDeviceData).%OpenId(sub)
	s recordItemId=obj.RecordItemId.%Id()
	s num=obj.Num
	s pId=obj.Text
	s icuaId=""
	s sub=0
	f  s sub=$o(^DHCICUArrange(sub)) q:(sub="")  d
	.s arrangeStatus=$p($g(^DHCICUArrange(sub)),"^",18)
	.q:arrangeStatus'="M"
	.s EpisodeID=$p(^DHCICUArrange(sub),"^",1)
	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	.s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	.s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	.s medCareNo=$$UPPER^SSUTIL4(medCareNo)
	.i medCareNo=$$UPPER^SSUTIL4(pId) s icuaId=sub 


	// 通过病人ID查找icuaId
	i icuaId="" s icuaId=##class(web.DHCICUCom).GetIcuaId("",pId,"")
	q icuaId
}

/// Creator：      	邓体进
/// CreatDate：    	2016-11-17
/// Description： 	添加某时间点的数据
/// Table：        	
/// Input：        	equipId,date,time
/// Output：        入库情况
/// Return：       	0: 正常 
ClassMethod AddToCollectData(equipId, date, time, icuaId)
{
	s date=..ConvertToDateH(date)
	s time=..ConvertToTimeH(time)
	s resStr=""
	// 遍历
	s recordItemId=""
	For {
		s recordItemId=$O(^DHCICUDeviceData(0,"EquipId",equipId,date,time,recordItemId))
		q:recordItemId=""
		s sub=""
		For{
			s sub=$O(^DHCICUDeviceData(0,"EquipId",equipId,date,time,recordItemId,sub))
			q:sub=""
			s obj=##class(User.DHCICUDeviceData).%OpenId(sub)
			continue:obj.RecordItemId=""
			s recordItemId=obj.RecordItemId.%Id()
			s num=obj.Num
			s text=obj.Text
			s res=##class(web.DHCICUCom).InsertCollectData(icuaId,recordItemId,date,time,num,text)
			d AddResList(res)
		}
		
	}
	q resStr
AddResList(res)
	i resStr="" s resStr=res
	e  s resStr=resStr_","_res
	q resStr
}

/// Creator：      	邓体进
/// CreatDate：    	2016-11-17
/// Description： 	添加事件类型数据到ICUOrder
/// Table：        	
/// Input：        	equipId,date,time
/// Output：        入库情况
/// Return：       	0: 正常 
ClassMethod AddEventData(equipId, date, time, icuaId)
{
	s date=..ConvertToDateH(date)
	s time=..ConvertToTimeH(time)
	// 遍历
	For {
		s sub=$O(^DHCICUDeviceData(0,"EquipId",equipId,date,time,sub))
		q:curTIme=""
		s obj=##class(User.DHCICUDeviceData).%OpenId(sub)
		s recordItemId=obj.RecordItemId.%Id()
		s num=obj.Num
		s text=obj.Text
		s paraItemId=..GetParaitemId(recordItemId)
		s res=##class(web.DHCICUCom).Insert2ICUOrder(icuaId,recordItemId,date,time,num,text,paraItemId)
	}
}

ClassMethod GetParaitemId(recordItemId)
{
	s paraItemId=""
	f  s sub=$O(^DHCICUPara(paraId,"I",sub)) q:sub=""  d
	..s itemStr=$g(^DHCICUPara(paraId,"I",sub))
	..s recordId=$p(itemStr,"^",4)
	..s mainId=$p(itemStr,"^",19)
	q
}

ClassMethod ProAllDeviceData()
{
	// 遍历DHC_ICU_Device表
}

/// Creator：      	邓体进
/// CreatDate：    	2016-11-17
/// Description： 	按设备和时间段处理采集数据
/// 						该方法在时间监护时间段调整后或者程序异常时才会调用
/// Table：        	DHC_Device_Data
/// Input：        	equipId,fromDate,fromTime,toDate,toTime
/// Output：        入库情况
/// Return：       	0: 正常 
ClassMethod ProDeviceData(equipId, fromDate, fromTime, toDate, toTime)
{
	
	s fromDatetime=(fromDate*3600*24)+fromTime
	s toDatetime=(toDate*3600*24)+toTime
	q:fromDatetime>toDatetime "fromDatetime>toDatetime"
	s date=fromDate
	s time=fromTime-1
	i time=0 s time=""
	
	For {
		s date=$O(^DHCICUDeviceData(0,"EquipId",equipId,date))
		q:date=""
		i date'=fromDate s time="" ; 跨天
		For {
			s time=$O(^DHCICUDeviceData(0,"EquipId",equipId,date,time))
			q:time=""
			s datetime=(date*3600*24)+time
			i datetime>toDatetime  goto QuitLabel
			s icuaId=""
			s res=..ProDeviceDataByDatetime(equipId,date,time)
			d AddResList(res)
		}
	}
	goto QuitLabel
QuitLabel
	q ""
AddResList(res)
	i resStr="" s resStr=res
	e  s resStr=resStr_","_res
	q resStr
}

/// Creator：      	邓体进
/// CreatDate：    	2016-11-17
/// Description： 	按设备和时间点处理采集数据
/// 						该方法在入库时调用或被ProDeviceData调用
/// Table：        	DHC_Device_Data
/// Input：        	equipId,fromDate,fromTime,toDate,toTime
/// Output：        入库情况
/// Return：       	0: 正常 
ClassMethod ProDeviceDataByDatetime(equipId, date, time)
{
	// w ##class(web.DHCICUDeviceData).ProDeviceDataByDatetime(equipId, date, time)
	i ..IsShareEquip(equipId) s icuaId=..GetIcuaIdByData(equipId,date,time)
	e  s icuaId=..GetIcuaId(equipId)
	s res="IcuaId is NULL"
	b
	if icuaId'="" {
		i ..IsEventData(equipId,date,time) s res=..AddEventData(equipId,date,time,icuaId)
		e  s res=..AddToCollectData(equipId,date,time,icuaId)
	}
	q res
}

/// // 以下是加载数据到界面程序
ClassMethod ICUEveryHourTask() As %String
{
	// w ##class(web.DHCICUDeviceData).ICUEveryHourTask()
	s retStr=0
	SET $ZTRAP="ERR"
	d ..Log("ICUEveryHourTask","Begin")
	s time=$p($h,",",2)
	s hour=time\3600
	s min=(time-(hour*3600))\60
	s dStr=$zd($p($h,",",1))
	s iDate=+$p(dStr,"/",2)
	s ^dhccldebuglog("ICUEveryHourTask")=$h
	s scope=3600
	s uiTime=((time+(scope/2))\3600)*3600
	
	// 采集相关
	d ..LoadCollectDataToUI(+$h,uiTime)

	// 启动当前所有需要监护的任务
	// w ##class(web.DHCICUDeviceTask).StartAllTask()
	d ..Log("ICUEveryHourTask","End")
	q retStr
	
ERR
	d ..Log("ICUEveryHourTask-Error",$zerror)
	q "-1"
}

/// Creator：      	邓体进
/// CreatDate：    	2017-03-14
/// Description： 	加载采集数据到界面
/// 						该方法将离传入时间的最近的数据加载到界面
/// Table：        	DHC_ICU_Order,DHC_ICU_CollectData
/// Input：        	
/// Output：        入库情况
/// Return：       	0: 正常 
ClassMethod LoadCollectDataToUI(date, time)
{
	// w ##class(web.DHCICUDeviceData).LoadCollectDataToUI(date,time)
	SET $ZTRAP="ERR"
	
	d ..Log("LoadCollectData","Begin")
	
	s wardId="" f  s wardId=$O(^User.DHCICUDeviceI("DepartmentIndex",wardId)) q:wardId=""  d
	.s retStr=..LoadCollectDataByWardId(wardId,date,time)
	
	d ..Log("LoadCollectData","End")
	q 0
ERR
	d ..Log("LoadCollectData-Error",$zerror)
	q "-1"
}

/// Creator：      	邓体进
/// CreatDate：    	2017-03-14
/// Description： 	加载某病区采集数据到界面
/// 						该方法将离传入时间的最近的数据加载到界面
/// Table：        	DHC_ICU_Order,DHC_ICU_CollectData
/// Input：        	wardId: 病区ID
/// /				date,time: 处理数据的时间点
/// Output：        入库情况
/// Return：       	-1:错误,其他:正常
ClassMethod LoadCollectDataByWardId(wardId, date, time, scope = 3600)
{
	// w ##class(web.DHCICUDeviceData).LoadCollectDataByWardId(wardId,date,time)
	If ('$ISVALIDNUM(date)) s date=..ConvertToDateH(date)
	If ('$ISVALIDNUM(time)) s time=..ConvertToTimeH(time)
	SET $ZTRAP="ERR"
	d ..Log("LoadCollectDataByWardId","Begin")
	s patientList=##class(web.DHCICUCom).FindWardPatient(wardId, "")
	q:patientList="" 0
	s res=""
	f i=1:1:$l(patientList,"^") d
	.q:$p(patientList,"^",i)=""
	.s icuaId=$p($p(patientList,"^",i),"|",4)
	.q:icuaId=""
	.s res=..LoadCollectDataByIcuaId(icuaId,date,time,scope)
	d ..Log("LoadCollectDataByWardId","End")
	q res
ERR
	d ..Log("LoadCollectDataByWardId-Error",$zerror)
	q "-1"
}

/// Creator：      	邓体进
/// CreatDate：    	2017-03-14
/// Description： 	根据icuaId加载采集数据到界面
/// 						该方法将离传入时间的最近的数据加载到界面
/// Table：        	DHC_ICU_Order,DHC_ICU_CollectData
/// Input：        	wardId: 病区ID
/// /				date,time: 处理数据的时间点
/// Output：        入库情况
/// Return：       	-1:错误,其他:正常
ClassMethod LoadCollectDataByIcuaId(icuaId, date, time, scope)
{
	// w ##class(web.DHCICUDeviceData).LoadCollectDataByIcuaId(icuaId,date,time,scope)
	If ('$ISVALIDNUM(date)) s date=..ConvertToDateH(date)
	If ('$ISVALIDNUM(time)) s time=..ConvertToTimeH(time)
	SET $ZTRAP="ERR"
	d ..Log("LoadCollectDataByIcuaId","Begin")
	s curDate=date,curTime=time
	i curTime=0 s curTime=86400,curDate=curDate-1 // 零点
	s isExit=0
	f  s curTime=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime),-1) q:(curTime="")!(isExit)  d
	.i $zabs(((date*3600*24)+time)-((curDate*3600*24)+curTime))>scope s isExit=1 q //十分钟内数据
	.s icucdSub="" f  s icucdSub=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime,icucdSub)) q:icucdSub=""  d
	..q:'$d(^DHCICUArrange(icuaId,"C",icucdSub))
	..q:$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)=""
	..q:$d(IcucriList($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)))
	..s recordItemId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1) ;2014-11-11 dtj
	..s recordItemCode=$p($g(^DHCICUC("RecordItem",recordItemId)),"^",1)
	..w "recordItemCode:",recordItemCode,!
	..s IcucriList(recordItemId)=icucdSub
	..s IcucriList(recordItemId,"Code")=recordItemCode
	
	s userId=""
	s icucriId="" f  s icucriId=$o(IcucriList(icucriId)) q:icucriId=""  d
	.
	.s icucdSub=IcucriList(icucriId)
	.q:'$d(^DHCICUArrange(icuaId,"C",icucdSub))
	.s txtValue=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4) //ICUO_Note
	.s numValue=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5) //ICUO_Qty
	.s rowId=..AddICUOrder(icuaId,icucriId,date,time,numValue,txtValue,"",userId)
	.s code=IcucriList(icucriId,"Code")
	.w "AddICUOrder:",rowId,"=>",code,":",icuaId,",",icucriId,",",date,",",time,",numValue:",numValue,",txtValue:",txtValue,!
	.
	d ..Log("LoadCollectDataByIcuaId","End")
	q 0
ERR
	b
	d ..Log("LoadCollectDataByIcuaId-Error",$zerror)
	q "-1"
}

ClassMethod AddICUOrder(icuaId As %String, icucriId As %String, date As %String, time As %String, numValue As %String, txtValue As %String, paraItemId As %String = "", userId = "") As %String
{
	//i icucriId=6096 d
	//.s time=time+3600
	//.i time>(24*3600) s date=date+1 s time=0
	// 不是数值且不是文本型
	
	w "AddICUOrder:",icuaId,",",icucriId,",",date,",",time,",",numValue,!
	q 0 //// 在测试阶段
	s SQLCODE=""
	q:(('$ISVALIDNUM(numValue))&&(txtValue="")) "null"
	//w ##Class(web.DHCICUCom).Insert2ICUOrder(icuaId, icucriId, date, time,numValue, txtValue)
	s rowId="" ,retStr=0
	// 查询后插入
	s isFind=0

	s sub ="" f  s sub=$O(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,sub)) q:((sub="")||(isFind))  d
	.s editFlag=$p($g(^DHCICUOrder(sub)),"^",25)
	.q:editFlag=""
	.i "NE"[editFlag s isFind=1 s rowId=sub
	.
	// 已存在则修改，否则插入数据
	i isFind=1  d
	.
	.s retStr=$$UPDATE()
	e  s retStr=$$INSERT()
	q retStr
INSERT()		
	s PLIST(2)=icuaId //icuaId
	s PLIST(3)=icucriId //icucriId
	s PLIST(5)=userId //userId
	s PLIST(6)=date //startDate
	s PLIST(7)=time //startTime
	s PLIST(8)=date //endDate
	s PLIST(9)=time //endTime
	s PLIST(11)=txtValue
	s PLIST(12)=numValue
	s PLIST(13)="" //ctuomId
	s PLIST(17)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5) //ancvcId
	s PLIST(18)="N" //ICUO_Flag
	s PLIST(22)=+$h //ICUO_UpdateDate
	s PLIST(23)=$p($h,",",2) //ICUO_UpdateTime
	s PLIST(24)="" //ICUO_ICUO_Dr
	s PLIST(26)="N" //ICUO_EditFlag
	s PLIST(30)="I" //ICUO_ICUO_Source
	s PLIST(31)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",3) //ICUO_Type
	
	i paraItemId'="" s PLIST(39)=paraItemId
	&SQL(Insert into DHC_ICU_Order Values :PLIST())

	i SQLCODE s retStr=icuaId_":ICU SQLCODE:"_SQLCODE //icuoId"插入数据错! SQLCode="_SQLCODE
	s ^tmpICUDebug("ShareDev",$h)=SQLCODE_",rowId="_$g(%ROWID)
	w "Insert:",icucriId,!
	i (SQLCODE<0) q SQLCODE
	e  q $g(%ROWID)
	
UPDATE()
	s updateTime=$p($h,",",2)
	s updateDate=+$h
	
	&sql(update DHC_ICU_Order set ICUO_UpdateTime=:updateTime,
	 ICUO_UpdateDate=:updateDate ,
	 ICUO_Note=:txtValue,
	 ICUO_Qty=:numValue,
	 ICUO_ICUPI_Dr=:paraItemId
	 where ICUO_RowId=:rowId
	 )	
	w "Update:",rowId," ",SQLCODE,!
	i (SQLCODE<0) q SQLCODE
	e  q rowId
}

ClassMethod GetRecentUserId(icuaId, date, time)
{
	// w ##class(web.DHCICUDeviceData).GetRecentUserId(icuaId,date,time)
	If '$ISVALIDNUM(date) s date=..ConvertToDateH(date)
	If '$ISVALIDNUM(time) s time=..ConvertToTimeH(time)
	If time=0 s date=date-1 s time=3600*24
	s userId=""
	s curTime=time+1  f curTime=$O(^DHCICUOrder(0,"SttDateTime",date,icuaId,curTime),-1) q:((curTime="")||(userId'=""))  d
	.s sub="" f sub=$O(^DHCICUOrder(0,"SttDateTime",date,icuaId,curTime,sub)) q:((sub="")||(userId'=""))  d
	..s userId=$P($g(^DHCICUOrder(sub)),"^",4)
	..w sub,":",$zt(curTime),!
	q userId
}

ClassMethod IsJustLeaveDept(icuaId, hour = 24)
{
	// w ##class(web.DHCICUCom).IsJustLeaveDept(icuaId)
	s leaveDate=0,leaveTime=0
	
	&sql(SELECT ICUA_LeaveDate,ICUA_LeaveTime into :leaveDate,:leaveTime FROM DHC_ICU_Arrange WHERE ICUA_RowId=:icuaId and ICUA_Status="T") 
	q:((+leaveDate)=0) 1
	s leaveDateTime=(leaveDate*3600*24)+leaveTime
	s now=(($h)*3600*24)+($p($h,",",2))
	s span=$zabs(now-leaveDateTime)
	q:(span<(3600*hour)) 1
	q 0
}

ClassMethod GetValue(dataPara As %String, itemName As %String) As %String
{
	s itemValue=""
	s itemNum=$L(dataPara,"^")
	f i=1:1:itemNum q:itemValue'=""  d
	.s itemStr=$P(dataPara,"^",i)
	.q:itemStr=""
	.s chNo=$P(itemStr,"#",1)
	.i chNo=itemName s itemValue=$P(itemStr,"#",5) s i=itemNum	
	q itemValue
}

ClassMethod GetCalculateItems(icuaId, qDate As %String, qTime As %String, dataPara As %String)
{
	// w ##class(web.DHCANAdaptor).GetCalCulateItems(icuaId,qDate,qTime,dataPara)
	s PaO2=0,PvO2=0,CaO2=0,CvO2=0,difCO2=0,gap=0
	s curSampleType=..GetValue(dataPara,"SampleType")
	s pCO21=..GetValue(dataPara,"pCO2")
	s pO21=..GetValue(dataPara,"pO2")
	q:curSampleType=""||pCO21="" ""
	;b "s"
	i curSampleType="Arterial" s qSampleType="Venous"
	i curSampleType="Venous" s qSampleType="Arterial"
	// 获取时间
	s oppsiteDate="",oppsiteTime=""
	i (((curSampleType="Arterial")||(curSampleType="Venous"))&&((qSampleType="Arterial")||(qSampleType="Venous"))) d
	.s str=..GetValueByCode(icuaId,"SampleType",qDate,qTime,qSampleType)
	.i str="" s str=..GetValueByCode(icuaId,"SampleType",qDate,qTime+(20*60)+1,qSampleType)
	.q:str="" 	
	.s oppsiteDate=$p(str,":",1)
	.s oppsiteTime=$p(str,":",2)
	.q:oppsiteTime=qTime

	q:((oppsiteDate="")||(oppsiteTime="")) ""
	// Gap计算
	s str=..GetValueByCode(icuaId,"pCO2",oppsiteDate,oppsiteTime)
	s pCO22=$p(str,":",3)
	s str=..GetValueByCode(icuaId,"pO2",oppsiteDate,oppsiteTime)
	s pO22=$p(str,":",3)
	i curSampleType="Arterial" s PaO2=pO21,PvO2=pO22
	e  s PaO2=pO22,PvO2=pO21
	
	i pCO22'="" d
	.s gap=$zabs(pCO21-pCO22)
	.s retStr=..GetCombStr("Gap",gap,qDate,qTime)
	// RATIO计算
	s sO21=..GetValue(dataPara,"sO2")
	s str=..GetValueByCode(icuaId,"sO2",oppsiteDate,oppsiteTime)
	s sO22=$p(str,":",3)
	s atHb="" ;动脉总Hb
	i curSampleType="Arterial" s atHb=..GetValue(dataPara,"tHb")
	e  d
	.s str=..GetValueByCode(icuaId,"tHb",oppsiteDate,oppsiteTime)
	.i str'="" s atHb=$p(str,":",3)
	i atHb'="" d
	.i atHb>24 s atHb=atHb/10
	.b "Hb"
	.i curSampleType="Arterial" d
	..s CaO2=(1.34*sO21*atHb/100)+(0.003*PaO2)
	..s CvO2=(1.34*sO22*atHb/100)+(0.003*PvO2)
	.e  d 
	..s CaO2=(1.34*sO22*atHb/100)+(0.003*PaO2)
	..s CvO2=(1.34*sO21*atHb/100)+(0.003*PvO2)
	.s difCO2=CaO2-CvO2
	.
	.i difCO2'=0 d
	..s RATIO=gap/difCO2
	..s RATIO=$fn(RATIO,"",2)
	..
	..s RATIOStr=..GetCombStr("RATIO",RATIO,qDate,qTime)
	..s retStr=retStr_"^"_RATIOStr
	w "CaO2:",CaO2,"CvO2:",CvO2,"gap:",gap,"difCO2:",difCO2
	q retStr_"@"_oppsiteDate_","_oppsiteTime
Gap
	
	q gap
}

// return:date,time,numValue,txtValue

ClassMethod GetValueByCode(icuaId, code As %String, qDate As %String, qTime As %String, qStr As %String = "", scope = 20) As %String
{
	// w ##class(web.DHCANAdaptor).GetValueByCode(icuaId,code,qDate,qTime)
	s scope=scope*60
	s date=qDate
	s time=qTime+1
	s ret="" s isExit=0 
	
	d Find
	i (ret="")&&($zabs(((date*3600*24)+time)-((qDate*3600*24)+qTime))<scope) d
	.s qDate=qDate-1 s qTime=3600*24
	.d Find
	q ret
Find
	;b "s"
	f  s time=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time),-1) q:((time="")||(isExit=1))  d
	.i $zabs(((date*3600*24)+time)-((qDate*3600*24)+qTime))>=scope s isExit=1 q
	.s sub=0
	.f  s sub=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,sub)) q:((sub="")||(isExit=1))  d
	..
	..s itemStr=$g(^DHCICUOrder(sub))
	..s comOrdId=$p(itemStr,"^",2) ;医嘱ID
	..s qtyValue=$p(itemStr,"^",11) ;Qty
	..s noteValue=$p(itemStr,"^",10) ;Note
	..s comOrdCode=$p($g(^DHCICUC("RecordItem",comOrdId)),"^",1) ;Code
	..i sub=61985 ;b "s"
	..i (comOrdCode=code) d
	...;b "Find"
	...i (qStr'="")&&((qStr=noteValue)||(qStr=qtyValue)) s ret=date_":"_time_":"_qtyValue_","_noteValue s isExit=1 
	...i qStr="" s ret=date_":"_time_":"_qtyValue_":"_noteValue s isExit=1 

	q
}

ClassMethod GetCombStr(itemName As %String, itemValue As %String, date As %String, time As %String) As %String
{
	s fStr="###V#####"
	s $p(fStr,"#",1)=itemName ;Name
	s $p(fStr,"#",2)=$zd(date,3) ;Date
	s $p(fStr,"#",3)=$zt(time) ;Time
	s $p(fStr,"#",5)=itemValue ;Value
	q fStr
}

/// 根据RecordItemId查找某一时间点的值
ClassMethod GetICUValue(icuaId As %String, date As %String, time As %String, icucriId As %String) As %String
{
	
	s sub="" s numValue="" s txtValue="" s isFind=0 s isExit=0
	s t=time+1
	d Find
	// 判断当前时间是否在零点10分内,如小于则
	i time<(10*60) d
	.s date=date-1 d Find	
	.s time=24*60*60-1
	.d Find
	
	q numValue_"^"_txtValue
Find
	f  s t=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,t),-1) q:((t="")||(isFind=1)||(isExit=1))  d
	.f  s sub=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,t,sub)) q:((sub="")||(isFind=1))  d
	..w ($zabs(t-time)>(60*60)),!
	..i ($zabs(t-time)>(60*60)) s isExit=1 q // 20分钟内数据
	..s ctuomId=$p($g(^DHCICUOrder(sub)),"^",2)
	..w t,ctuomId,!
	..
	..i ctuomId=icucriId  d
	...;b
	...s isFind=1 
	...s itemStr=^DHCICUOrder(sub)
	...s txtValue=$p(itemStr,"^",10)
	...s numValue=$p(itemStr,"^",11)
	q
}

// w ##class(web.DHCICUDeviceData).GetDeviceDataByIcuaId(4,"2018-08-01","11:25","2018-08-01","11:50")

ClassMethod GetDeviceDataByIcuaId(icuaId, startDate, startTime, endDate, endTime)
{
	i icuaId=7 d
	.s ^DHCIcuDebug("GetDeviceDataByIcuaId",$h,icuaId)=icuaId_","_startDate_","_startTime_","_endDate_","_endTime
	i '$ISVALIDNUM(startDate) s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	i '$ISVALIDNUM(startTime) s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	i '$ISVALIDNUM(endDate) s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	i '$ISVALIDNUM(endTime) s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	s devices=..GetDeviceIdByIcuaId(icuaId)
	s len=$L(devices,",")
	s i=1  f i=1:1:len  d
	.s devId=$p(devices,",",1)
	.q:devId=""
	.s res=$$FindData(devId)
	
	q "over"
FindData(devId)
   
    s date=startDate-1  f  s date=$O(^DHCICUDeviceData(0,"EquipId",devId,date)) q:((date="")||(date>endDate))  d
	.s time=""  
	.i date=startDate s time=startTime
	.f  s time=$O(^DHCICUDeviceData(0,"EquipId",devId,date,time)) q:((time="")||((date=endDate)&&(time>endTime)))  d
	..w "time:",$zd(date),$zt(time),!
	..
	..s recordItemId="" f  s recordItemId=$O(^DHCICUDeviceData(0,"EquipId",devId,date,time,recordItemId)) q:recordItemId=""  d
	...s sub="" f  s sub=$O(^DHCICUDeviceData(0,"EquipId",devId,date,time,recordItemId,sub)) q:sub=""  d
	....s res=..GenOrder(icuaId,sub)
	q ""
FindData2(devId)
   
    s date=endDate+1  f  s date=$O(^DHCICUDeviceData(0,"EquipId",devId,date),-1) q:((date="")||(date<startDate))  d
	.s time=3600*24 
	.i date=endDate s time=endTime+1
	.f  s time=$O(^DHCICUDeviceData(0,"EquipId",devId,date,time),-1) q:((time="")||((date=startDate)&&(time<startTime)))  d
	..w "time:",$zd(date),$zt(time),!
	..
	..s recordItemId="" f  s recordItemId=$O(^DHCICUDeviceData(0,"EquipId",devId,date,time,recordItemId)) q:recordItemId=""  d
	...s sub="" f  s sub=$O(^DHCICUDeviceData(0,"EquipId",devId,date,time,recordItemId,sub)) q:sub=""  d
	....s res=..GenOrder(icuaId,sub)
	q ""
}

// w ##class(web.DHCICUDeviceData).GenOrder(4)

ClassMethod GenOrder(icuaId, rowId)
{
    s deviceData=##class(User.DHCICUDeviceData).%OpenId(rowId)
    s icucdStartDate=deviceData.StartDate
	s icucdStartTime=deviceData.StartTime

	s icucdStartDateTime=icucdStartDate+(icucdStartTime/100000)
	s icucdEndDateTime=icucdStartDateTime
	//q:(ifByDateTime="Y")&(icucdEndDateTime'>sttDateTime) -4 //开始时间点不计
	//q:(ifByDateTime="Y")&(icucdStartDateTime>endDateTime) -5 //结束时间点计入
	
	s icucriId=deviceData.RecordItemId.%Id()
	q:icucriId="" -2
	s code=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",1)
	
	w "GenOrder[",code,"]:",rowId," ",$zd(icucdStartDate),"-",$zt(icucdStartTime)," ",deviceData.Num,!
	s icucdUpdateDate=deviceData.UpdateDate
	s icucdUpdateTime=deviceData.UpdateTime
	s updateDateTime=icucdUpdateDate+(icucdUpdateTime/100000)
	
	s curId="" //s tmpStr="^" //??
	s curIcucriId=icucriId
	s oeoreId="" //s tmpStr=tmpStr_"^"	//ICUO_OEORE_Dr
	s curUserId="" //s tmpStr=tmpStr_"^"	//ICUO_User_Dr
	s curStartDate=$zd(icucdStartDate,3) //s tmpStr=tmpStr_$ZD($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)_"^"	//ICUO_StartDate
	s curStartTime=$zt(icucdStartTime) //s tmpStr=tmpStr_$ZT($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3))_"^"
	s curEndDate=curStartDate //s tmpStr=tmpStr_$ZD($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)_"^"
	s curEndTime=curStartTime //s tmpStr=tmpStr_$ZT($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3))_"^"
	s arcimId="" //s tmpStr=tmpStr_"^"
	s curNote=deviceData.Text //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4)_"^"	//ICUO_Note num:10
	s curQty=deviceData.Num //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5)_"^"	//ICUO_Qty
	s uomId="" //s tmpStr=tmpStr_"^"	//ICUO_Uom_Dr
	s icuoConcentration="" //s tmpStr=tmpStr_"^"	//ICUO_Concentration
	s icuoOriginateFromIcuodr="" //s tmpStr=tmpStr_"^"	//ICUO_OriginateFromICUO_Dr
	s phcinId="" //s tmpStr=tmpStr_"^"	//ICUO_Instr_Dr
	
	s ancvcId=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",5) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",5)_"^" //tmpStr_ancvcDesc_"^"
	s doseSpeed=""
	s icuoFlag="N" //s tmpStr=tmpStr_"N^"	//ICUO_Flag
	s icuoDrugMode="" //s tmpStr=tmpStr_"^"	//ICUO_DrugMode
	s icuoSpeed="" //s tmpStr=tmpStr_"^"	//ICUO_Speed
	s curUpdateDate=$zd(icucdUpdateDate,3) //s tmpStr=tmpStr_$ZD(icucdUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icucdUpdateTime) //s tmpStr=tmpStr_$ZT(icucdUpdateTime)_"^"
	s icuoReason="" //s tmpStr=tmpStr_"^"	//ICUO_Reason
	s curEditFlag="N" //s tmpStr=tmpStr_"N^"	//ICUO_EditFlag
	s curEditedId="" //s tmpStr=tmpStr_"^"	//ICUO_ICUO_DR
	s icuoRecLocId="" //s tmpStr=tmpStr_"^"	//ICUO_RecLoc_Dr
	s curDocUserId="" //s tmpStr=tmpStr_"^"	//ICUO_DocUser_Dr
	s icuoVolume=0 //s tmpStr=tmpStr_"0^"	//ICUO_Volume
	s icuoSpeedUnitDr="" //s tmpStr=tmpStr_"^" //ICUO_SpeedUnit_Dr
	s icuoSource="A" //s tmpStr=tmpStr_"A^"	//ICUO_Source
	s icuoType=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",3) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",3)_"^"	//ICUO_Type //num:30
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)_"^"
	s arcimDesc="" //s tmpStr=tmpStr_"^"
	s icuoPreparedVolume=0 //s tmpStr=tmpStr_"0^"	//ICUO_PreparedVolume
	s icuoAttachOeoriId="" //s tmpStr=tmpStr_"^"     //ICUO_AttachOeoriId
	s icuoReportResult="" //s tmpStr=tmpStr_"^"     //ICUO_ReportResult
	//s tmpStr=tmpStr_icuaId_"^"  //
	s mainOeoriId="",subOeoriId="",oecprDesc="",phcinDesc="",prcfrDesc="",oeoriNote="",curAbbreviate="",icuoOrdItemNote="",icuoMainIcuoDr="",icuoRemarks="",icuoIcupiDr="",doseSpeed="",totalQty=""
	s $p(tmpStr,"^",47)="^"
	s ^TMPICU("Order",$j,icuaId,updateDateTime,icucriId,rowId)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr,doseSpeed,totalQty)
	q 0
}

ClassMethod GetDeviceIdByIcuaId(icuaId)
{
	// w ##class(web.DHCICUDeviceData).GetDeviceIdByIcuaId(4)
	s bedId=""
	&sql(SELECT ICUA_Bed_Dr into:bedId FROM DHC_ICU_Arrange 
	WHERE ICUA_RowId=:icuaId)
	
	&sql(Declare c Cursor for 
	 SELECT DeviceId into :deviceId 
	 FROM DHC_ICU_BedDevice WHERE BedId=:bedId)
	&sql(open c)
	s res=""
	For{
		&sql(Fetch c)
		quit:SQLCODE
		i res="" s res=deviceId 
		e  s res=res_","_deviceId 
	}
	&sql(Close c)
	
	q res
}

ClassMethod OldTest(icuaId, endDate, endTime)
{
	// w ##class(web.DHCICUDeviceData).OldTest(icuaId, endDate, endTime)
	i '$ISVALIDNUM(endDate) s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	i '$ISVALIDNUM(endTime) s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	s curDate=endDate,curTime=endTime+1
	f  s curTime=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime),-1) q:(curTime="")  d
	.s icucdSub="" b
	.f  s icucdSub=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime,icucdSub)) q:icucdSub=""  d
	..w "Data:",$zd(curDate)," ",$zt(curTime)
	..q
	..//q:$$GetCollectData("Y")<0
	q "o"
}

}

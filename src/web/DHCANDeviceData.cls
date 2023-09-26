Import SQLUser

Class web.DHCANDeviceData Extends %RegisteredObject
{

// w ##class(web.DHCANDeviceData).InsertANOrder(devId, extInfo, dataPara, status)

ClassMethod InsertANOrder(devId, extInfo, dataPara, status)
{
	s opaId=..GetOpaIdByDeviceId(devId)
	q:opaId="" "NOt Found opaId:"_devId
	s res=..Insert2DB(devId,opaId,extInfo,dataPara,status)
	q res
}

// w ##class(web.DHCANDeviceData).GetOpaIdByDeviceId(devId)

ClassMethod GetOpaIdByDeviceId(devId)
{
	s roomId=""
	/*&sql(select RoomId into :roomId from DHC_AN_RoomDevice where DeviceId=:devId)
	s roomId="" f  s sub=$O(^DHCANOPArrange(0,"RoomStatus",roomId,"M",)) q:roomId=""  d
	.*/
	s opaId=""
	&sql(select top 1 OPA_RowId into:opaId from DHC_AN_OPArrange 
	where OPA_Status='I' and OPA_OpRoom_Dr=
	(select RoomId from DHC_AN_RoomDevice where DeviceId=:devId)
	order by OPA_RowId)
	
	q opaId
}

/// Creator：      	ypz
/// CreatDate：    	2009-04-20
/// Description： 	保存数据到麻醉记录表中
/// Table：        	DHC_AN_Order,DHC_AN_RoomEquip,DHC_AN_RoomEquipDetail
/// Input：        	opaId手术安排ID,icuaId重症监护安排ID,equipId手术间设备或监护床设备ID,userId;
///                 para：分两级，第一级"^",第二级#。每条记录的数据。
/// 			   	chanalNo_#_sttDate_"#"_sttTime_"#"_ancoType(医嘱类型)_"#"_itemValue_"%"_itemValue2_"%"_itemValue3_"#"_ctuomId_"#"_icuoId(未用)_"#"_ancvcId_"#"_oeoriId(未用)"^"....
/// 					status: 当前设备任务的状态：
/// 					"Unstarted"：未启动
/// 					"Running"：正运行
/// 					"NetOffline"：网络问题
/// 					“NoData"：无数据，很可能是MOXA原因
/// Output：       
/// Return：       	0-正常，其他-异常返回信息
/// 2:未插入值
/// -1: 手术安排ID和重症监护安排ID不为同时为空!
/// -2: 手术安排ID和重症监护安排ID不正确!
/// -3: 手术安排ID和重症监护安排ID不能同时有值!
/// -4: 无设备ID!
/// -5: 无数据!
/// -11:手术状态不为"I",重症监护床不为Receive或者Finish
/// -12:opaId不存在或icauId错误
/// -13:手术间设备记录不存在!
/// -14:未知设备类型
/// -23:床位号不存在
/// -110: 被另一线程占用
ClassMethod Insert2DB(devId, opaId, extInfo, dataPara, status) As %String
{
	
	// s opaId=7077
	// s equipId=6
	// s anoSource="A"
	// s extInfo=""
	// s dataPara=""
	// s status="Running"
	// w ##class(web.DHCANCom).Insert2DB(opaId,equipId,anoSource,extInfo,dataPara,status)
	s isInsert=0,devTypeId="",insertStr="" 
	q:(opaId="") -1 //"手术安排ID和重症监护安排ID不为同时为空!"
	q:(+opaId=0) -2 //"手术安排ID和重症监护安排ID不正确!"
	q:(devId="") -4 //"无设备ID!"
	q:dataPara="" -5 //"无数据!"
	s temperatureChannelNo="Temp" //体温的通道号
	s retStr=0
	i +opaId>0 d
		.i $g(^DHCANOPArrange(opaId))="" s retStr=-12 q
		.i devTypeId="" s devTypeId=$List(^User.DHCANDeviceD(devId),5)
		.
		.i devTypeId="" s retStr=-14 q
		.s deviceObj=##class(User.DHCANCCollectType).%OpenId(devTypeId)
		.s devCode=deviceObj.ANCCTCode
		.i devCode="Relay" d
		..;RELAY|192.168.203.201|192.168.203.18|PhilipsMP
		..s ip=$p($g(^DHCANRoomEquip(equipId)),"^",3)
		..s devCode=$p(ip,"|",3)
		..s devTypeId=$o(^DHCANC("CType",0,"Code",devCode,""),-1)
		..
		.// 如果是自动识别或模拟设备，则查找设备类型Id
		.i (((devCode="AutoCheckDev")||(devCode="TestDev"))&&(extInfo'="")) d 
		..;查找设备类型Id
		..s devTypeId=0
		..s devTypeId=$o(^DHCANC("CType",0,"Code",extInfo,devTypeId))
		.i devTypeId="" s retStr=-14 q
		.s itemNum=$L(dataPara,"^")
		.f i=1:1:itemNum d
			..q:retStr'=0
			..s itemStr=$P(dataPara,"^",i)
			..q:itemStr=""
			..s itemName=$P(itemStr,"#",1)
			..q:itemName=""
			..;b  ;;002
			..s ancctiSub=$o(^DHCANC("CType",0,"ChannelNo",itemName,devTypeId,""))
			..q:ancctiSub=""
			..s ancoId=$p(^DHCANC("CType",devTypeId,"I",ancctiSub),"^",1)
			..q:ancoId=""
			..
			..s paraItemId=##class(web.DHCANCom).GetParaItemIdByComOrdId(ancoId,opaId)
			..k PLIST
			..s value=$P(itemStr,"#",5)
			..s sttDate=$P(itemStr,"#",2)
			..s sttTime=$P(itemStr,"#",3)
			..i (itemName=temperatureChannelNo)&(value>100) s value=value/10
	        ..q:(itemName=temperatureChannelNo)&((value>42)!(value<30))
	        ..s decimalDigits=1
	        ..i (itemName="TEMP0") s decimalDigits=1
	        ..s sttDate=##class(web.DHCANOPCom).ConvertToDateH(sttDate)
	        ..s sttTime=##class(web.DHCANOPCom).ConvertToDateH(sttTime)
			..s newRowId=..AddANOrder(opaId,ancoId,sttDate,sttTime,value,paraItemId,decimalDigits)
			..s insertStr=insertStr_itemName_","
			..s isInsert=1
			..s retStr=i_":AN SQLCODE:"_newRowId //"插入新数据错! code="_SQLCODE
    i (retStr=0)&&(isInsert=0) s retStr=2 // 未插入值	
	q retStr_" "_"opaId:"_opaId_" "_insertStr
}

// w ##class(web.DHCANDeviceData).AddANOrder(opaId,ancoId,sttDate,sttTime,value)

ClassMethod AddANOrder(opaId, ancoId, sttDate, sttTime, value, paraItemId, decimalDigits)
{
	s ancvcId=$p($g(^DHCANC("ComOrd",ancoId)),"^",5)
	s ancoDesc=$p($g(^DHCANC("ComOrd",ancoId)),"^",2)
	s field=$p($g(^DHCANC("ComOrd",ancoId)),"^",24)
	i '$ISVALIDNUM(sttDate) s sttDate=##class(web.DHCANOPCom).ConvertToDateH(sttDate)
	i '$ISVALIDNUM(sttTime) s sttTime=##class(web.DHCANOPCom).ConvertToDateH(sttTime)
	s oldRowId=$$FindANOrder()
	b
	i oldRowId'="" d
	.s res=$$UpadateANOrder(oldRowId,value)
	q:oldRowId'="" "update:"_oldRowId
	
	
	s PLIST(2)=opaId
	s PLIST(3)=ancoId       //ANO_ANCORD_Dr
	s PLIST(4)=""
	s PLIST(5)=sttDate
	s PLIST(6)=sttTime
	s PLIST(7)=sttDate
	s PLIST(8)=sttTime
	s PLIST(10)="",PLIST(11)=""
	
	i field="Qty" s PLIST(11)=$P(value,"%",1) //ANO_Qty
	e  i field="Note" s PLIST(10)=value 
	
	s PLIST(32)=$P(value,"%",2) //ANO_Qty2
	i (PLIST(32)["-") s PLIST(32)=""
	s PLIST(33)=$P(value,"%",3) //ANO_Qty3
	i (PLIST(33)["-") s PLIST(33)=""
	s ctuomId=$p($g(^DHCANC("ComOrd",ancoId)),"^",6)
	s PLIST(12)=ctuomId
	
	s PLIST(16)=ancvcId
	s PLIST(21)=+$H    //ypz//s PLIST(11)=+$H
	s PLIST(22)=$p($h,",",2)  //ypz//s PLIST(12)=$p($h,",",2)
	s PLIST(25)="N"
	s PLIST(30)="I"    //ypz//s PLIST(8)="I"
	s PLIST(31)="V" //ANCO_Type   //ypz Add
	s decimalDigits=0
	q:(PLIST(31)="D")&(PLIST(11)<0.0001)
	
	i PLIST(11)'="" s PLIST(11)=$fn(PLIST(11),"",decimalDigits)
	i PLIST(32)'="" s PLIST(32)=$fn(PLIST(32),"",decimalDigits)
	i PLIST(33)'="" s PLIST(33)=$fn(PLIST(33),"",decimalDigits)
	s PLIST(36)=ancoDesc
	s PLIST(37)=paraItemId
	&sql(insert into DHC_AN_Order values :PLIST())
	
	q $g(%ROWID)
FindANOrder()
    s rowId=""
	&sql(select ANO_RowId into :rowId from DHC_AN_Order
	where ANO_OPA_Dr=:opaId and ANO_ANCORD_Dr=:ancoId and 
	ANO_StartDate=:sttDate and ANO_StartTime=:sttTime)
	q rowId
UpadateANOrder(rowId,value)
	s obj=##class(User.DHCANOrder).%OpenId(rowId)
	i field="Qty" s obj.ANOQty=$P(value,"%",1) //ANO_Qty
	e  i field="Note" s obj.ANONote=value 
	d obj.%Save()
	q "0"
}

}

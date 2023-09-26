/// add by ZY0296 2022-03-23
Class web.DHCEQ.BA.BUSUseRecordQueue Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQ.BA.BUSUseRecordQueue).SaveData()
ClassMethod SaveData(URQRowID, data, Type)
{
	n Date,Time,SQLCODE,JsonData
	k PLIST
	;s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
 	s Time=$Piece($H,",",2)
	if +Type=0
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlistNew("User.DHCEQIUseRecordQueue",JsonData,.PLIST)
		s URQRowID = JsonData.URQRowID
		s PLIST(18)="N"				;CancelFlag
		s PLIST(26)=Date			;AddDate
		s PLIST(27)=Time			;AddTime
		s PLIST(33)="0"				;Status
		i URQRowID=""
		{
			&SQL(insert into SQLUSER.SQLUSER.DHC_EQIUseRecordQueue Values :PLIST())
			s URQRowID=$g(%ROWID)
		}
		else
		{
			&SQL(update SQLUSER.SQLUSER.DHC_EQIUseRecordQueue Values :PLIST() where URQ_RowID = :URQRowID)
		}
	}
	elseif +Type=1
	{
		s PLIST(33)=data				;Status
		&SQL(Update SQLUSER.DHC_EQIUseRecordQueue Values :PLIST() where URQ_RowID=:URQRowID)
	}
	q SQLCODE
}

/// modified by ZY0396 2022-03-23
/// 描述：采集效益分析数据到中间表
/// d ##class(web.DHCEQ.BA.BUSUseRecordQueue).GatherDataToIUseRcordQueue()
ClassMethod GatherDataToIUseRcordQueue(GatherDate, ExType, EquipID As %String = "")
{
	s Job=$j
	s tmpDate=$ZD(GatherDate,3)
	s SDate=$ZD(GatherDate,3)
	s EDate=$ZD(GatherDate,3)
	
	///河北省中医LIS
	if ExType="LIS"
	{
		s CurErrorID=+$o(^DHCEQLog("ErrResult",ExType,GatherDate,Job,0))
		s SourceID=0
		f  s SourceID=$o(^DHCEQDeviceMap(0,"Equip",SourceID)) quit:SourceID=""  d
		.q:(EquipID'="")&(EquipID'=SourceID)
		.i SourceID'="" s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
		.s DMRowID=0
		.f  s DMRowID=$o(^DHCEQDeviceMap(0,"Equip",SourceID,ExType,DMRowID)) quit:DMRowID=""  d
		..s DeviceMap=$g(^DHCEQDeviceMap(DMRowID))
		..q:$p(DeviceMap,"^",5)="Y"
		..s DeviceID=$p(DeviceMap,"^",3)
		..//s DateType="Report"	//Study
		..//s ds =##class(%Library.ResultSet).%New("web.DHCEQ.Interface.Inner.DHCEQLISFrom:GetLISUseRecord")
		..//d ds.Execute(DeviceID,SDate,EDate,"","","","","","","","","","","","","")
		..s ds =##class(%Library.ResultSet).%New("web.UpHLYYData:DHCRuiMeiSBxyfx")
		..d ds.Execute(SDate,EDate,DeviceID)
		..f  q:'ds.Next()  d
		...s objUseRecord=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
		...d objUseRecord.%Set("URQExType",ExType)
		...d objUseRecord.%Set("URQExDeviceID",DeviceID)
		...
		...s Item=##Class(web.DHCEQ.BA.BUSUseRecordQueue).GetExItemRowID(ds.URQExItemID)  //Modify by zx 2020-07-30
		...d objUseRecord.%Set("URQExItemID",Item)
		...s ExID=ds.URQExBussID
		...i ExID="" s ExID=Item_"||"_ds.URQPatientID
		...d objUseRecord.%Set("URQExBussID",ds.URQExBussID)
		...
		...s UseDate=ds.URQUseDate
		...i UseDate'=""  d
		....s UseDate=$p(UseDate,".",1)
		....s UseDate=$ZDH(UseDate,3)
		....s UseDate=$ZD(UseDate,4)
		...d objUseRecord.%Set("URQUseDate",UseDate)
		...d objUseRecord.%Set("URQWorkLoadNum",1)	//ds.URQWorkLoadNum
		...
		...s UseLocDR=ds.URQExUseLocID
		...s UseLocDR=##Class(web.DHCEQImportDataTool).GetUseLocID(UseLocDR)
		...d objUseRecord.%Set("URQExUseLocID",UseLocDR)
		...
		...d objUseRecord.%Set("URQPrice",ds.URQPrice)
		...d objUseRecord.%Set("URQTotalFee",ds.URQTotalFee)
		...d objUseRecord.%Set("URQPositiveFlag",$Case(ds.URQPositiveFlag,"阳性":"Y","阴性":"N","":"N"))
		...
		...d objUseRecord.%Set("URQPatientID",ds.URQPatRID)
		...d objUseRecord.%Set("URQPatientAge",##class(web.DHCEQCommon).Replace(ds.URQPatientAge,"岁",""))
		...d objUseRecord.%Set("URQPatientName",ds.URQPatientName)
		...d objUseRecord.%Set("URQPatientSex",$Case(ds.URQPatientSex,"1":"F","0":"M"))
		...
		...d objUseRecord.%Set("URQStartDate",UseDate)
		...d objUseRecord.%Set("URQStartTime","")
		...d objUseRecord.%Set("URQEndDate",UseDate)
		...d objUseRecord.%Set("URQEndTime","")
		...d objUseRecord.%Set("URQRemark","")
		...s objUseRecord=objUseRecord.%ToJSON()
		...
		...s SQLCODE=##Class(web.DHCEQ.BA.BUSUseRecordQueue).SaveData("",objUseRecord,"0")
		...i SQLCODE  d	//采集记录失败
		....s CurErrorID=CurErrorID+1
		....s ^DHCEQLog("ErrResult",ExType,GatherDate,Job,CurErrorID)=SQLCODE
	}
	elseif ExType="RIS"
	{
		///河北省中医RIS
		s SourceID=0
		f  s SourceID=$o(^DHCEQDeviceMap(0,"Equip",SourceID)) quit:SourceID=""  d
		.q:(EquipID'="")&(EquipID'=SourceID)
		.i SourceID'="" s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
		.s DMRowID=0
		.f  s DMRowID=$o(^DHCEQDeviceMap(0,"Equip",SourceID,ExType,DMRowID)) quit:DMRowID=""  d
		..s DeviceMap=$g(^DHCEQDeviceMap(DMRowID))
		..q:$p(DeviceMap,"^",5)="Y"
		..s DeviceID=$p(DeviceMap,"^",3)
		..q:DeviceID=""
		..s ds =##class(%Library.ResultSet).%New("web.UpHLYYData:DHCmiPlatformSBxyfx")
		..d ds.Execute(SDate,EDate,DeviceID)
		..f  q:'ds.Next()  d
		...s objUseRecord=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
		...d objUseRecord.%Set("URQExType",ExType)
		...d objUseRecord.%Set("URQExDeviceID",DeviceID)
		...
		...s Item=##Class(web.DHCEQ.BA.BUSUseRecordQueue).GetExItemRowID(ds.URQExItemID)  //Modify by zx 2020-07-30
		...d objUseRecord.%Set("URQExItemID",Item)
		...s ExID=ds.URQExBussID
		...i ExID="" s ExID=Item_"||"_ds.URQPatientID
		...d objUseRecord.%Set("URQExBussID",ds.URQExBussID)
		...
		...s UseDate=ds.URQUseDate
		...i UseDate'=""  d
		....s UseDate=$p(UseDate,".",1)
		....s UseDate=$ZDH(UseDate,3)
		....s UseDate=$ZD(UseDate,4)
		...d objUseRecord.%Set("URQUseDate",UseDate)
		...d objUseRecord.%Set("URQWorkLoadNum",1)	//ds.URQWorkLoadNum
		...
		...s UseLocDR=ds.URQExUseLocID
		...s UseLocDR=##Class(web.DHCEQImportDataTool).GetUseLocID(UseLocDR)
		...d objUseRecord.%Set("URQExUseLocID",UseLocDR)
		...
		...d objUseRecord.%Set("URQPrice",ds.URQPrice)
		...d objUseRecord.%Set("URQTotalFee",ds.URQTotalFee)
		...d objUseRecord.%Set("URQPositiveFlag",$Case(ds.URQPositiveFlag,"阳性":"Y","阴性":"N","":"N"))
		...
		...d objUseRecord.%Set("URQPatientID",ds.URQPatRID)
		...d objUseRecord.%Set("URQPatientAge",##class(web.DHCEQCommon).Replace(ds.URQPatientAge,"岁",""))
		...d objUseRecord.%Set("URQPatientName",ds.URQPatientName)
		...d objUseRecord.%Set("URQPatientSex",$Case(ds.URQPatientSex,"1":"F","0":"M","":"M"))
		...
		...d objUseRecord.%Set("URQStartDate",UseDate)
		...d objUseRecord.%Set("URQStartTime","")
		...d objUseRecord.%Set("URQEndDate",UseDate)
		...d objUseRecord.%Set("URQEndTime","")
		...d objUseRecord.%Set("URQRemark","")
		...s objUseRecord=objUseRecord.%ToJSON()
		...s SQLCODE=##Class(web.DHCEQ.BA.BUSUseRecordQueue).SaveData("",objUseRecord,"0")
		...i SQLCODE  d	//采集记录失败
		....s CurErrorID=CurErrorID+1
		....s ^DHCEQLog("ErrResult",ExType,GatherDate,Job,CurErrorID)=SQLCODE
	}
	/*
	s Date=$ZD(+$H-1,3)
	s objService=##class(web.DHCEQ.Interface.Outer.HistorySearchWebServiceSoap).%New()
	s objDataSet=objService.DHCEQIUseRecordQueue(Date,Date)
	
	s reader = ##class(%XML.Reader).%New()
	s sc=reader.OpenStream(objDataSet)
	d reader.Correlate("DHC_EQIUseRecordQueue","web.DHCEQ.Interface.OuterTableProperty.DHCEQIUseRecordQueueProperty")
	s CurErrorID=+$o(^DHCEQLog("Job","GatherKYData",$H,"Result",0))
	while(reader.Next(.object,.sc))
	{
		s objUseRecord=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
		d objUseRecord.%Set("URQExType",object.URQExType)
		d objUseRecord.%Set("URQExDeviceID",object.URQExDeviceID)
		d objUseRecord.%Set("URQExItemID",object.URQExItemID)
		d objUseRecord.%Set("URQExBussID",##Class(web.DHCEQCommon).Replace(object.URQExBussID,"_","||"))
		d objUseRecord.%Set("URQExUseLocID",object.URQExUseLocID)
		d objUseRecord.%Set("URQUseDate",object.URQUseDate)
		d objUseRecord.%Set("URQWorkLoadNum",object.URQWorkLoadNum)
		d objUseRecord.%Set("URQPrice",object.URQPrice)
		d objUseRecord.%Set("URQTotalFee",object.URQTotalFee)
		
		d objUseRecord.%Set("URQPatientInfo",object.URQPatientInfo)
		d objUseRecord.%Set("URQStartDate",object.URQStartDate)
		d objUseRecord.%Set("URQStartTime",object.URQStartTime)
		d objUseRecord.%Set("URQEndDate",object.URQEndDate)
		d objUseRecord.%Set("URQEndTime",object.URQEndTime)
		d objUseRecord.%Set("URQRemark",object.URQRemark)
		d objUseRecord.%Set("URQPositiveFlag",object.URQPositiveFlag)
		d objUseRecord.%Set("URQPatientAge",object.URQPatientAge)
		d objUseRecord.%Set("URQPatientSex",object.URQPatientSex)
		
		s SQLCODE=##Class(web.DHCEQ.BA.BUSUseRecordQueue).SaveData("",objUseRecord,"0")
		i SQLCODE	//采集记录失败
		{
			s CurErrorID=CurErrorID+1
			s ^DHCEQLog("Job","GatherKYData",$H,"Result",CurErrorID)=SQLCODE		
		}
	}
	*/
}

/// Creator：      	zx
/// CreatDate：    	2020-07-30
/// Description:	根据医嘱项代码获取医嘱项RowID
/// Table：        	无  
/// Input：        	code:医嘱项代码
/// Output：       	无
/// Return：       	医嘱项RowID
/// Others：	
/// w ##Class(web.DHCEQ.BA.BUSUseRecordQueue).GetExItemRowID("SF000084")
ClassMethod GetExItemRowID(code As %String) As %String
{
    S code=$G(code)
    Q:'$L(code) ""
	S arcimMainID=$O(^ARCIM(0,"Code",code,""))
	Q:'$L(arcimMainID) ""
	S arcimSubID=$O(^ARCIM(0,"Code",code,arcimMainID,""))
	Q:'$L(arcimSubID) ""
	Q arcimMainID_"||"_arcimSubID
}

}

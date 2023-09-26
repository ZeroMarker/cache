Class EPRservice.BLL.Dental.BLToothRecord Extends %RegisteredObject [ ProcedureBlock ]
{

/// 乳牙
Parameter DeciduousToothCode = "51,52,53,54,55,61,62,63,64,65,71,72,73,74,75,81,82,83,84,85";

/// 恒牙
Parameter PermanentToothCode = "11,12,13,14,15,17,17,18,21,22,23,24,25,26,27,28,31,32,33,34,35,36,37,38,41,42,43,44,45,46,47,48";

/// Debug:	w ##Class(EPRservice.BLL.Dental.BLToothRecord).SetToothRecord()
ClassMethod SetToothRecord(APatientID, AEpisodeID, AInstanceDataID, ATemplateID, AEPRDocID, AEPRNum, AUserID) As %String
{
	//s ^CacheTempDHCEPRDebug("SetToothRecord") = APatientID_","_AEpisodeID_","_AInstanceDataID_","_ATemplateID_","_AEPRDocID_","_AEPRNum_","_AUserID
	
	s $zt = "OnErrorHandler"
	
	s hasItemMapped = ##Class(EPRservice.BLL.Dental.BLToothMaping).HasMetaItemMapped(ATemplateID)
	q:(hasItemMapped="0") "0"
	
	s curItemCode = ""
	for {
		s curItemCode = $O(^DHCEPRM.Dental.ToothMapingI("IdxMetaItemCode"," "_ATemplateID,curItemCode))
		q:(curItemCode = "")
		
		s toothMapingID = $O(^DHCEPRM.Dental.ToothMapingI("IdxMetaItemCode"," "_ATemplateID,curItemCode,""))
		continue:(toothMapingID="")
		
		s objToothMaping = ##Class(EPRmeta.Dental.ToothMaping).%OpenId(toothMapingID)
		continue:(objToothMaping="")
		
		//b "s"
		s toothMapingFunctionCode = objToothMaping.ToothMapingFunctionCode
		s metaItemCode = objToothMaping.MetaItemCode
		s valueType = objToothMaping.ValueType
		s contentValueType = objToothMaping.ConentValueType
		
		s toothPositonCode = ..GetMapingToothPositionCode(AEpisodeID, valueType, toothMapingFunctionCode, AInstanceDataID)
		
		if (toothPositonCode = "")
		{
			do ..ClearToothRecordFromRowNo(AEpisodeID, AInstanceDataID, ATemplateID, metaItemCode, "1")
		}
		else
		{
			s recordContent = ..GetRecordContent(AEpisodeID, contentValueType, toothMapingFunctionCode, AInstanceDataID)
			do ..SetOneToothRecord(APatientID, AEpisodeID, AInstanceDataID, ATemplateID, AEPRDocID, AEPRNum, AUserID, metaItemCode, recordContent, toothPositonCode)
		}
	}
	
	q "1"
	
OnErrorHandler		
	s AErrorMessage = "-1:"_$ZError
}

ClassMethod GetMapingToothPositionCode(AEpisodeID, AValueType, AToothMapingFunctionCode, AInstanceDataID) As %String
{
	//b "s"
	s toothPositionCode = ""
	
	if (AToothMapingFunctionCode = "001")
	{
		s recordContent = ##Class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID,AValueType,AInstanceDataID)
		q:(recordContent = "") toothPositionCode
		
		//表格单元中的多选单元的牙位视图数据，每个多选单元值包含|分割的4部分数据，每一部分数据对照一个或多个牙位
		//即：应该映射到哪个牙位上，是由用户在多选单元选中的值决定的
		s toothPositionCode = ..Maping001(recordContent)
	}
	elseif (AToothMapingFunctionCode = "002")
	{
		s recordContent = ##Class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID,AValueType,AInstanceDataID)
		q:(recordContent = "") toothPositionCode
		
		//表格单元中的多选单元的牙位视图数据，每个多选单元值包含|分割的4部分数据，每一部分数据对照一个或多个牙位
		//即：应该映射到哪个牙位上，是由用户在多选单元选中的值决定的
		s toothPositionCode = ..Maping001(recordContent)
	}
	elseif (AToothMapingFunctionCode = "003")
	{
		s recordContent = ##Class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID,AValueType,AInstanceDataID)
		q:(recordContent = "") toothPositionCode
		
		//表格单元中的多选单元的牙位视图数据，每个多选单元值包含|分割的4部分数据，每一部分数据对照一个或多个牙位
		//即：应该映射到哪个牙位上，是由用户在多选单元选中的值决定的
		s toothPositionCode = ..Maping001(recordContent)
	}
	elseif (AToothMapingFunctionCode = "004")
	{
		s recordContent = ##Class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID,AValueType,AInstanceDataID)
		q:(recordContent = "") toothPositionCode
		
		//表格单元中的多选单元的牙位视图数据，每个多选单元值包含|分割的4部分数据，每一部分数据对照一个或多个牙位
		//即：应该映射到哪个牙位上，是由用户在多选单元选中的值决定的
		s toothPositionCode = ..Maping001(recordContent)
	}
	elseif (AToothMapingFunctionCode = "005")
	{
		s recordContent = ##Class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID,AValueType,AInstanceDataID)
		q:(recordContent = "") toothPositionCode
		
		//表格单元中的多选单元的牙位视图数据，每个多选单元值包含|分割的4部分数据，每一部分数据对照一个或多个牙位
		//即：应该映射到哪个牙位上，是由用户在多选单元选中的值决定的
		s toothPositionCode = ..Maping001(recordContent)
	}
	elseif (AToothMapingFunctionCode = "999")
	{
		//一个界面模板单元直接对应一个牙位的处置内容，则将 EPRmeta.Dental.ToothMaping.ValueType的值直接设置为相应牙位编码即可
		//即：界面模板单元和牙位一一对照
		s toothPositionCode = "1:"_AValueType
	}
	
	q toothPositionCode
}

ClassMethod GetRecordContent(AEpisodeID, AValueType, AToothMapingFunctionCode, AInstanceDataID) As %String
{
	//b "s"
	s RecordContent = ""
	
	if (AToothMapingFunctionCode = "001")
	{
		s RecordContent = ##Class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID,AValueType,AInstanceDataID)	
	}
	elseif (AToothMapingFunctionCode = "002")
	{
		s RecordContent = ##Class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID,AValueType,AInstanceDataID)
	}
	elseif (AToothMapingFunctionCode = "003")
	{
		s RecordContent = ##Class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID,AValueType,AInstanceDataID)
	}
	elseif (AToothMapingFunctionCode = "004")
	{
		s RecordContent = ##Class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID,AValueType,AInstanceDataID)
	}
	elseif (AToothMapingFunctionCode = "005")
	{
		s RecordContent = ##Class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID,AValueType,AInstanceDataID)
	}
	
	q RecordContent
}

/// Return:	1:11,12^2:15,26
/// Debug:	w ##Class(EPRservice.BLL.Dental.BLToothRecord).Maping001("Ⅴ Ⅴ Ⅳ Ⅲ Ⅱ Ⅰ Ⅰ Ⅱ Ⅲ Ⅳ Ⅴ 3 1 | 4 6|4 2 | 3 5")
ClassMethod Maping001(recordContent) As %String
{
	q:(recordContent="") ""
	
	s retToothCode = ""
	
	s rowCount = $L(recordContent,$c(2))	//表格行数
	for i = 1:1:rowCount
	{
		s curRowContent = $p(recordContent,$c(2),i)	//第i行数据
		s rowNo = i
		
		s curRowToothCode = ..Maping001Row(curRowContent)
		
		if (retToothCode = "")
		{
			s retToothCode = rowNo_":"_curRowToothCode
		}
		else
		{
			s retToothCode = retToothCode_"^"_rowNo_":"_curRowToothCode
		}
	}
	
	q retToothCode
}

/// w ##Class(EPRservice.BLL.Dental.BLToothRecord).Maping001Row("Ⅴ Ⅴ Ⅳ Ⅲ Ⅱ Ⅰ Ⅰ Ⅱ Ⅲ Ⅳ Ⅴ 3 1 | 4 6|4 2 | 3 5")
ClassMethod Maping001Row(curContent As %String)
{
	q:(curContent = "") ""
		
	s rowToothCode = ""
		
	//多选单元的牙位视图数据，包含|分割的4部分数据，每一部分数据对照一个或多个牙位
	for i = 1:1:4
	{
		s curRegionContent = $p(curContent,"|",i)
		s curRegion = i	//多选单元的牙位视图数据的第几部分，左上、右上、左下、右下分别为1、2、3、4
		
		s tmpCount = $L(curRegionContent," ")
		for j = 1:1:tmpCount
		{
			s tmpContent = $P(curRegionContent," ",j)
			s tmpToothCode = ..Maping001Value2Code(tmpContent,curRegion)
			continue:(tmpToothCode="")
			
			s isInclude = ..IsInclude(rowToothCode, tmpToothCode, ",")
			continue:(isInclude="1")
			
			if (rowToothCode = "")
			{
				s rowToothCode = tmpToothCode
			}
			else
			{
				s rowToothCode = rowToothCode_","_tmpToothCode
			}
		}
	}
	
	q rowToothCode
}

/// w ##Class(EPRservice.BLL.Dental.BLToothRecord).Maping001Value2Code("1","1")
/// w ##Class(EPRservice.BLL.Dental.BLToothRecord).Maping001Value2Code("1","2")
/// w ##Class(EPRservice.BLL.Dental.BLToothRecord).Maping001Value2Code("1","3")
/// w ##Class(EPRservice.BLL.Dental.BLToothRecord).Maping001Value2Code("1","4")
/// w ##Class(EPRservice.BLL.Dental.BLToothRecord).Maping001Value2Code("Ⅱ","1")
/// w ##Class(EPRservice.BLL.Dental.BLToothRecord).Maping001Value2Code("Ⅱ","2")
/// w ##Class(EPRservice.BLL.Dental.BLToothRecord).Maping001Value2Code("Ⅱ","3")
/// w ##Class(EPRservice.BLL.Dental.BLToothRecord).Maping001Value2Code("Ⅱ","4")
ClassMethod Maping001Value2Code(AValue As %String, ARegion As %String) As %String
{
	q:(AValue="") ""
	
	//不需要做一个算法，很难理解，直接枚举对照关系最简单
	//多选单元的牙位界面：左上角数据
	q:(ARegion="1")&&(AValue="1") "11"
	q:(ARegion="1")&&(AValue="2") "12"
	q:(ARegion="1")&&(AValue="3") "13"
	q:(ARegion="1")&&(AValue="4") "14"
	q:(ARegion="1")&&(AValue="5") "15"
	q:(ARegion="1")&&(AValue="6") "16"
	q:(ARegion="1")&&(AValue="7") "17"
	q:(ARegion="1")&&(AValue="8") "18"
	q:(ARegion="1")&&(AValue="Ⅰ") "51"
	q:(ARegion="1")&&(AValue="Ⅱ") "52"
	q:(ARegion="1")&&(AValue="Ⅲ") "53"
	q:(ARegion="1")&&(AValue="Ⅳ") "54"
	q:(ARegion="1")&&(AValue="Ⅴ") "55"
	
	//多选单元的牙位界面：右上角数据
	q:(ARegion="2")&&(AValue="1") "21"
	q:(ARegion="2")&&(AValue="2") "22"
	q:(ARegion="2")&&(AValue="3") "23"
	q:(ARegion="2")&&(AValue="4") "24"
	q:(ARegion="2")&&(AValue="5") "25"
	q:(ARegion="2")&&(AValue="6") "26"
	q:(ARegion="2")&&(AValue="7") "27"
	q:(ARegion="2")&&(AValue="8") "28"
	q:(ARegion="2")&&(AValue="Ⅰ") "61"
	q:(ARegion="2")&&(AValue="Ⅱ") "62"
	q:(ARegion="2")&&(AValue="Ⅲ") "63"
	q:(ARegion="2")&&(AValue="Ⅳ") "64"
	q:(ARegion="2")&&(AValue="Ⅴ") "65"
	
	//多选单元的牙位界面：左下角数据
	q:(ARegion="3")&&(AValue="1") "41"
	q:(ARegion="3")&&(AValue="2") "42"
	q:(ARegion="3")&&(AValue="3") "43"
	q:(ARegion="3")&&(AValue="4") "44"
	q:(ARegion="3")&&(AValue="5") "45"
	q:(ARegion="3")&&(AValue="6") "46"
	q:(ARegion="3")&&(AValue="7") "47"
	q:(ARegion="3")&&(AValue="8") "48"
	q:(ARegion="3")&&(AValue="Ⅰ") "81"
	q:(ARegion="3")&&(AValue="Ⅱ") "82"
	q:(ARegion="3")&&(AValue="Ⅲ") "83"
	q:(ARegion="3")&&(AValue="Ⅳ") "84"
	q:(ARegion="3")&&(AValue="Ⅴ") "85"
	
	//多选单元的牙位界面：右下角数据
	q:(ARegion="4")&&(AValue="1") "31"
	q:(ARegion="4")&&(AValue="2") "32"
	q:(ARegion="4")&&(AValue="3") "33"
	q:(ARegion="4")&&(AValue="4") "34"
	q:(ARegion="4")&&(AValue="5") "35"
	q:(ARegion="4")&&(AValue="6") "36"
	q:(ARegion="4")&&(AValue="7") "37"
	q:(ARegion="4")&&(AValue="8") "38"
	q:(ARegion="4")&&(AValue="Ⅰ") "71"
	q:(ARegion="4")&&(AValue="Ⅱ") "72"
	q:(ARegion="4")&&(AValue="Ⅲ") "73"
	q:(ARegion="4")&&(AValue="Ⅳ") "74"
	q:(ARegion="4")&&(AValue="Ⅴ") "75"
	
	q ""
	
	/* 不需要做一个算法，很难理解，直接枚举对照关系最简单
	s retValue = "" 
	
	s retRegionFactor = "10"
	if (ARegion = "1")
	{	s retRegionFactor = "10"}
	elseif (ARegion = "2")
	{	s retRegionFactor = "20"}
	elseif (ARegion = "3")
	{	s retRegionFactor = "40"}
	elseif (ARegion = "4")
	{	s retRegionFactor = "30"}
	
	//转换单元数据编码为数字
	if (AValue="Ⅰ") 
	{	
		s retValue = "1"
		s retRegionFactor = retRegionFactor + 40
	}
	elseif (AValue="Ⅱ") 
	{	
		s retValue = "2"
		s retRegionFactor = retRegionFactor + 40
	}
	elseif (AValue="Ⅲ") 
	{	
		s retValue = "3"
		s retRegionFactor = retRegionFactor + 40
	}
	elseif (AValue="Ⅳ") 
	{	
		s retValue = "4"
		s retRegionFactor = retRegionFactor + 40
	}
	elseif (AValue="Ⅴ") 
	{	
		s retValue = "5"
		s retRegionFactor = retRegionFactor + 40
	}
	else
	{	s retValue = (+AValue)}
	
	q:(retValue < 1)||(retValue>8) ""
	
	s retValue = retValue + retRegionFactor
	q retValue	
	*/
}

ClassMethod IsInclude(ASrcToothCode, ADstToothCode, ASeprator) As %Boolean
{
	q:(ADstToothCode="") "1"
	q:(ASrcToothCode="") "0"
	q $f(ASeprator_ASrcToothCode_ASeprator,ASeprator_ADstToothCode_ASeprator) > 0
}

ClassMethod ClearToothRecordFromRowNo(AEpisodeID, AInstanceDataID, ATemplateID, AMetaItemCode, ARowNoStart)
{
	s rowNo = ARowNoStart
	for {
		s id = $O(^DHCEPRI.Dental.ToothRecordI("IdxInstanceDataID"," "_AEpisodeID, " "_AInstanceDataID, " "_ATemplateID, " "_AMetaItemCode, rowNo, ""))
		if (id '= "")
		{
			do ..DeleteToothRecord(id)
		}
		
		s rowNo = $O(^DHCEPRI.Dental.ToothRecordI("IdxInstanceDataID"," "_AEpisodeID, " "_AInstanceDataID, " "_ATemplateID, " "_AMetaItemCode, rowNo))
		q:(rowNo = "")
	}
}

ClassMethod SetOneToothRecord(APatientID, AEpisodeID, AInstanceDataID, ATemplateID, AEPRDocID, AEPRNum, AUserID, AMetaItemCode, ARecordContent, AToothPositionCode)
{
	//b "s"
	s rowCount = $L(AToothPositionCode,"^")
	for i = 1:1:rowCount
	{
		s curRowInfo = $P(AToothPositionCode,"^",i)
		s rowNo = $P(curRowInfo,":",1)
		s toothCode = $P(curRowInfo,":",2)
		
		s toothRecordID = ..GetToothRecordID(AEpisodeID, AInstanceDataID, ATemplateID, AMetaItemCode, rowNo)
		if (toothCode = "")
		{
			if (toothRecordID '= "")
			{
				do ..DeleteToothRecord(toothRecordID)
			}
			continue
		}
		
		s rowContent = $P(ARecordContent,$c(2),rowNo)
		
		if (toothRecordID = "")
		{
			do ..CreateToothRecord(APatientID, AEpisodeID, AInstanceDataID, ATemplateID, AEPRDocID, AEPRNum, AUserID, AMetaItemCode, rowContent, toothCode, rowNo) 
		}
		else
		{
			do ..UpdateToothRecord(toothRecordID, rowContent, AUserID, toothCode)
		}
	}
	
	s delStartRowNo = rowCount + 1
	do ..ClearToothRecordFromRowNo(AEpisodeID,AInstanceDataID,ATemplateID,AMetaItemCode,delStartRowNo)
}

ClassMethod GetToothRecordID(AEpisodeID, AInstanceDataID, ATemplateID, AMetaItemCode, ARowNo) As %String
{
	//Index IdxInstanceDataID On (EpisodeID, InstanceDataID, TemplateID, MetaItemCode, RowNo) [ Unique ];
	s id = $O(^DHCEPRI.Dental.ToothRecordI("IdxInstanceDataID"," "_AEpisodeID, " "_AInstanceDataID, " "_ATemplateID, " "_AMetaItemCode, ARowNo, ""))
	q id
}

ClassMethod CreateToothRecord(APatientID, AEpisodeID, AInstanceDataID, ATemplateID, AEPRDocID, AEPRNum, AUserID, AMetaItemCode, ARecordContent, AToothPositionCode, ARowNo) As %String
{
	
	s objToothRecord = ##Class(EPRinstance.Dental.ToothRecord).%New()
	s objToothRecord.PatientID = APatientID
	s objToothRecord.EpisodeID = AEpisodeID
	s objToothRecord.ToothPositionCode = AToothPositionCode
	s objToothRecord.InstanceDataID = AInstanceDataID
	s objToothRecord.TemplateID = ATemplateID
	s objToothRecord.EPRDocID = AEPRDocID
	s objToothRecord.EPRNum = AEPRNum
	s objToothRecord.MetaItemCode = AMetaItemCode
	s objToothRecord.RecordContent = ARecordContent
	s objToothRecord.CreateUserID = AUserID
	s objToothRecord.UpdateUserID = AUserID
	s objToothRecord.RowNo =  ARowNo
	
	s nowDate = $P($h,",",1)
	s nowTime = $P($h,",",2)
	s objToothRecord.CreateDate = nowDate
	s objToothRecord.CreateTime = nowTime
	s objToothRecord.UpdateDate = nowDate
	s objToothRecord.UpdateTime = nowTime
	
	s sc = objToothRecord.%Save()
	q sc
}

ClassMethod UpdateToothRecord(AToothRecordID, ARecordContent, AUserID, AToothPositionCode) As %String
{
	//b "s"
	s objToothRecord = ##Class(EPRinstance.Dental.ToothRecord).%OpenId(AToothRecordID)
	q:(objToothRecord = "") "0"
	
	s objToothRecord.RecordContent = ARecordContent
	s objToothRecord.UpdateUserID = AUserID
	s objToothRecord.UpdateDate = $P($h,",",1)
	s objToothRecord.UpdateTime = $P($h,",",2)
	s objToothRecord.ToothPositionCode = AToothPositionCode
	
	s sc = objToothRecord.%Save()
	q sc
}

ClassMethod DeleteToothRecord(AToothRecordID) As %String
{
	q:(AToothRecordID="") "1"
	
	s sc = ##Class(EPRinstance.Dental.ToothRecord).%DeleteId(AToothRecordID)
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

ClassMethod GetToothRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetToothRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetToothRecordExecute(ByRef qHandle As %Binary, APatientID As %String, AEpisodeID As %String, ADataFlag As %String, AToothPositionCode As %String, ACurrentAdmFlag = "0") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

 	s episodeID = ""
 	for {
	 	//b "101"
 		s episodeID = $O(^DHCEPRI.Dental.ToothRecordI("IdxAdmCreateDT"," "_APatientID,episodeID))
 		q:(episodeID="")
 		
 		continue:(ACurrentAdmFlag = "1")&&(episodeID '= (" "_AEpisodeID))		
 		
 		s date = ""
 		for {
	 		//b "102"
	 		s date = $O(^DHCEPRI.Dental.ToothRecordI("IdxAdmCreateDT"," "_APatientID,episodeID,date))
 			q:(date="")
 			
 			s time = ""
 			for {
	 			//b "103"
	 			s time = $O(^DHCEPRI.Dental.ToothRecordI("IdxAdmCreateDT"," "_APatientID,episodeID,date,time))
 				q:(time="")
 		
 				s rowID = ""
 				for {
	 				b "104"
	 				s rowID = $O(^DHCEPRI.Dental.ToothRecordI("IdxAdmCreateDT"," "_APatientID,episodeID,date,time,rowID))
 					q:(rowID="")
 					
 					s toothCode = $listget($G(^DHCEPRI.Dental.ToothRecordI("IdxAdmCreateDT"," "_APatientID,episodeID,date,time,rowID)),2)
 					s isOK = $$IsOK(ADataFlag,AToothPositionCode,toothCode)
 					continue:(isOK = "0")
 					
 					d Output(rowID)
 				}
 			}
 		}
 	}
 					
	q $$$OK
 	
IsOK(ADataFlag, AToothPositionCode, recordToothCode)
	if (ADataFlag = "21")
	{
		//显示所有
		q "1"
	}
	elseif (ADataFlag = "22")
	{
		//显示恒牙
		s isInclude = "0"
		s recordToothCount = $L(recordToothCode,",")
		for index = 1:1:recordToothCount
		{
			s isInclude = ..IsInclude(..#PermanentToothCode,$P(recordToothCode,",",index),",")
			q:(isInclude="1")
		}
		q isInclude
	}
	elseif (ADataFlag = "23")
	{
		//显示乳牙
		s isInclude = "0"
		s recordToothCount = $L(recordToothCode,",")
		for index = 1:1:recordToothCount
		{
			s isInclude = ..IsInclude(..#DeciduousToothCode,$P(recordToothCode,",",index),",")
			q:(isInclude="1")
		}
		q isInclude
	}
	elseif (ADataFlag = "1")
	{
		//显示指定牙齿
		s isInclude = ..IsInclude(recordToothCode,AToothPositionCode,",")
		q isInclude
	}
	
	q "1"
 					

 /*	
GetData1
 	s episodeID = ""
 	for {
	 	//b "101"
 		s episodeID = $O(^DHCEPRI.Dental.ToothRecordI("IdxTooth"," "_APatientID,episodeID))
 		q:(episodeID="")
 				
 		s date = ""
 		for {
	 		//b "102"
	 		s date = $O(^DHCEPRI.Dental.ToothRecordI("IdxTooth"," "_APatientID,episodeID," "_AToothPositionCode,date))
 			q:(date="")
 			
 			s time = ""
 			for {
	 			//b "103"
	 			s time = $O(^DHCEPRI.Dental.ToothRecordI("IdxTooth"," "_APatientID,episodeID," "_AToothPositionCode,date,time))
 				q:(time="")
 		
 				s rowID = ""
 				for {
	 				//b "104"
	 				s rowID = $O(^DHCEPRI.Dental.ToothRecordI("IdxTooth"," "_APatientID,episodeID," "_AToothPositionCode,date,time,rowID))
 					q:(rowID="")
 					
 					d Output(rowID)
 				}
 			}
 		}
	}
	q
 	*/
 	
Output(toothRowID)
	//b "s"
	s objToothRecord = ##Class(EPRinstance.Dental.ToothRecord).%OpenId(toothRowID)
	s EpisodeID = objToothRecord.EpisodeID
	s AdmDate = $P($G(^PAADM(EpisodeID)),"^",6)
	s AdmDate = $zd(AdmDate,3)
	s ToothPositionCode = objToothRecord.ToothPositionCode
	s RecordContent = objToothRecord.RecordContent
	s UpdateDate = $zd(objToothRecord.UpdateDate,3)
	
	s ^CacheTemp(repid, ind) = $LB(EpisodeID, AdmDate, ToothPositionCode, RecordContent, UpdateDate)
	s ind = ind + 1
	q
}

ClassMethod GetToothRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetToothRecordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Debug: d ##Class(%ResultSet).RunQuery("EPRservice.BLL.Dental.BLToothRecord","GetToothRecord","13","15","22","")
Query GetToothRecord(APatientID As %String, AEpisodeID As %String, ADataFlag As %String, AToothPositionCode As %String, ACurrentAdmFlag = "0") As %Query(ROWSPEC = "EpisodeID:%String,AdmDate:%String,ToothPositionCode:%String,RecordContent:%String,UpdateDate:%String")
{
}

/// Desc:	获取有处置数据的牙位
/// Debug:	w ##Class(EPRservice.BLL.Dental.BLToothRecord).GetOperedTooth("13")
ClassMethod GetOperedTooth(APatientID As %String) As %String
{
		s retTooth = ""

	
		s date = ""
 		for {
	 		//b "102"
	 		s date = $O(^DHCEPRI.Dental.ToothRecordI("IdxPatCreateDT"," "_APatientID,date))
 			q:(date="")
 			
 			s time = ""
 			for {
	 			//b "103"
	 			s time = $O(^DHCEPRI.Dental.ToothRecordI("IdxPatCreateDT"," "_APatientID,date,time))
 				q:(time="")
 		
 				s rowID = ""
 				for {
	 				//b "104"
	 				s rowID = $O(^DHCEPRI.Dental.ToothRecordI("IdxPatCreateDT"," "_APatientID,date,time,rowID))
 					q:(rowID="")
 					
 					s toothCode = $listget($G(^DHCEPRI.Dental.ToothRecordI("IdxPatCreateDT"," "_APatientID,date,time,rowID)),2)
 					continue:(toothCode = "")||(toothCode=$c(0))
 					
 					if (retTooth = "")
 					{	s retTooth = toothCode}
 					else
 					{	s retTooth = retTooth_","_toothCode}
 				}
 			}
 		}
 		
 		q:(retTooth="") ""
 		
 		//除重复
 		s ret = ""
 		s arrTooth = ##class(%ArrayOfDataTypes).%New()
 		s count = $L(retTooth,",")
 		for i=1:1:count
 		{
	 		s toothCode = $P(retTooth,",",i)
	 		
			//不能为空
	 		continue:(toothCode="")||(toothCode=$C(0))
	 		
	 		//已经重复
	 		continue:(arrTooth.GetAt(toothCode) '= "")
	 		
	 		//必须为标准牙位数值
	 		s isOK1 = ..IsInclude(..#DeciduousToothCode,toothCode,",")
	 		s isOK2 = ..IsInclude(..#PermanentToothCode,toothCode,",")
	 		continue:(isOK1 '= "1")&&(isOK2 '= "1")
	 		
	 		d arrTooth.SetAt(toothCode,toothCode)
	 		if (ret = "")
	 		{	s ret = toothCode}
	 		else
	 		{	s ret = ret_","_toothCode}
 		}
 		
 		q ret
 		
 		
 		s retTooth = ""
 		s key = ""
 		for {
	 		b "s"
	 		s val = arrTooth.GetNext(.key) 
	 		q:(key="")  
	 		
	 		
	 		if (retTooth = "")
	 		{	s retTooth = val}
	 		else
	 		{	s retTooth = retTooth_","_val}
 		}
 	
 		q retTooth
}

/// Debug:	do ##class(EPRservice.BLL.Dental.BLToothRecord).Test1()
ClassMethod Test1()
{
	do ..SetToothRecord("11","201868","83||1","37","512","1","5972")
}

/// Debug:	do ##class(EPRservice.BLL.Dental.BLToothRecord).Test2()
ClassMethod Test2()
{
	d ##Class(%ResultSet).RunQuery("EPRservice.BLL.Dental.BLToothRecord","GetToothRecord","11","201764","1","11")
}

/// Debug:	do ##class(EPRservice.BLL.Dental.BLToothRecord).Test3()
ClassMethod Test3()
{
	s p = $g(^CacheTempDHCEPRDebug("SetToothRecord"))
	s a1 = $P(p,",",1)
	s a2 = $P(p,",",2)
	s a3 = $P(p,",",3)
	s a4 = $P(p,",",4)
	s a5 = $P(p,",",5)
	s a6 = $P(p,",",6)
	s a7 = $P(p,",",7)
	
	d ..SetToothRecord(a1,a2,a3,a4,a5,a6,a7)
}

}

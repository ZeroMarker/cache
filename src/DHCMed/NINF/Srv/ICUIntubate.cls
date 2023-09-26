/// 名称: DHCMed.NINF.Srv.ICUIntubate
/// 描述: ICU三管信息 对外接口
/// 编写者：zhufei
/// 编写日期: 2013-05-22
Class DHCMed.NINF.Srv.ICUIntubate Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 数据来源
/// 指向医嘱表   格式:"OEITEM:OE_OrdItem.RowID"
Property DataSource As %String(TRUNCATE = 1);

/// 置管类型(中央导管、呼吸机、导尿管)
Property IntubateType As DHCMed.NINF.Srv.Dictionary;

/// 置管日期
Property IntubateDate As %Date;

/// 置管时间
Property IntubateTime As %Time;

/// 拔管日期
Property ExtubateDate As %Date;

/// 拔管时间
Property ExtubateTime As %Time;

/// 插管名称
Property IntubateDesc As %String;

/// Creator：     zhufei
/// CreatDate：   2013-05-22
/// Description:  根据就诊号取【ICU三管信息】接口
/// Table：       
/// Input：       EpisodeID 就诊号
/// Return：      返回%List
/// w ##class(DHCMed.NINF.Srv.ICUIntubate).GetICUResults(14184,"VAP")
ClassMethod GetICUResults(aEpisodeID As %String, aTypeCode As %String) As %ListOfObjects
{
	New (aEpisodeID,aTypeCode)
	Set return=##class(%ListOfObjects).%New()
	Quit:(aEpisodeID="")||(aTypeCode="") return
	
	Set LogDataProcType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFICUSurveryDataType","")
	If LogDataProcType="ByOE" {
		Set return=..GetICUResultsByOE(aEpisodeID,aTypeCode)
	} ElseIf LogDataProcType="ByICU" {
		Set return=..GetICUResultsByICU(aEpisodeID,aTypeCode)
	} Else {}
	
	Quit return
}

/// w ##class(DHCMed.NINF.Srv.ICUIntubate).GetICUResultsByICU(2169,"PICC")
ClassMethod GetICUResultsByICU(aEpisodeID As %String, aTypeCode As %String) As %ListOfObjects
{
	New (aEpisodeID,aTypeCode)
	Set return=##class(%ListOfObjects).%New()
	Quit:(aEpisodeID="")||(aTypeCode="") return
	
	Set TypeID="",TypeCode=""
	Set objType=##Class(DHCMed.SS.Dictionary).GetByTypeCode("NINFICUIntubateType",aTypeCode,"")
	If $IsObject(objType) {
		Set TypeID=objType.%Id()
		Set TypeCode=objType.Code
		Set TypeDesc=objType.Description
	}
	Quit:(TypeID="")||(TypeCode="") return
	
	//Set AdmitDate=$p($g(^PAADM(+aEpisodeID)),"^",6)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
	Set AdmitDate=$p(AdmDateTime,"^",1)
	//Set DischDate=$p($g(^PAADM(+aEpisodeID)),"^",17)
	//Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(aEpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set:DischDate="" DischDate=+$h
	
	//"Ventilator"为气管插管,"CVP"为中心静脉置管,"Urethra"为尿管置管
	Set:TypeCode="PICC" CatheterType="CVP"
	Set:TypeCode="VAP" CatheterType="Ventilator"
	Set:TypeCode="UC" CatheterType="Urethra"
	
	Set CatheterList=##class(web.DHCICUStat).GetCatheter(+AdmitDate,+DischDate,"",aEpisodeID,CatheterType)
	Quit:CatheterList="" return
	
	//11||10060:2013-07-21"_$c(3,3)_"2013-07-21"_$c(3)_"2013-07-22 19:30"_$c(3,3,3)_"科外"
	For indRec=1:1:$p(CatheterList,"^") {
		Set strRec=$p(CatheterList,"^",indRec)
		Continue:strRec=""
		
		Set xRecID=$p(strRec,$c(3),1)
		Set xtmpTime=$p(strRec,$c(3),3)
		Set StartDate=$p(xtmpTime," ",1)
		Set:StartDate'="" StartDate=$zdh(StartDate,3)
		Continue:StartDate=""
		Set StartTime=$p(xtmpTime," ",2)
		Set:StartTime'="" StartTime=$zth(StartTime,1)
		Set StartTime=+StartTime
		Set xtmpTime=$p(strRec,$c(3),4)
		Set EndDate=$p(xtmpTime," ",1)
		Set:EndDate'="" EndDate=$zdh(EndDate,3)
		Set EndTime=$p(xtmpTime," ",2)
		Set:EndTime'="" EndTime=$zth(EndTime,1)
		Set EndTime=+EndTime
		If EndDate="" {
			Set EndDate=+$h
			Set EndTime=$p($h,",",2)
		}
		
		Set objXICU=##Class(DHCMed.NINF.Srv.ICUIntubate).%New()
		Continue:'$IsObject(objXICU)
		
		Set objXICU.DataSource="OEITEM:"_xRecID
		Set objXICU.IntubateType=##class(DHCMed.NINF.Srv.Dictionary).GetDicObj(TypeID_"^"_TypeDesc)
		Set objXICU.IntubateDate=StartDate
		Set objXICU.IntubateTime=StartTime
		Set objXICU.ExtubateDate=EndDate
		Set objXICU.ExtubateTime=EndTime
		If objXICU'="" Do objXICU.%Close()
		
		//Do $System.OBJ.Dump(objXICU)
		Do return.Insert(objXICU)
	}
	
	Quit return
}

/// w ##class(DHCMed.NINF.Srv.ICUIntubate).GetICUResultsByOE(659760,"PICC")
ClassMethod GetICUResultsByOE(aEpisodeID As %String, aTypeCode As %String) As %ListOfObjects
{
	New (aEpisodeID,aTypeCode)
	Set return=##class(%ListOfObjects).%New()
	Quit:(aEpisodeID="")||(aTypeCode="") return
	
	Set TypeID="",TypeCode=""
	Set objType=##Class(DHCMed.SS.Dictionary).GetByTypeCode("NINFICUIntubateType",aTypeCode,"")
	If $IsObject(objType) {
		Set TypeID=objType.%Id()
		Set TypeCode=objType.Code
		Set TypeDesc=objType.Description
	}
	Quit:(TypeID="")||(TypeCode="") return
	//PICC、VAP、UC、NPICC、NVNT、NUC
	Set ArcimFromList = ..getArcimList("InfRep"_TypeCode_"Arcim")
	Quit:ArcimFromList="" return
	Set ArcimToList = ..getArcimList("InfRep"_TypeCode_"EndArcim")
	
	Kill ^TMP($zn,$j,"GetICUResults")
	
	Set EpisodeID=+aEpisodeID
	
	//插管医嘱+拔管医嘱
	//插管开始医嘱
	For indList=1:1:$listlength(ArcimFromList) {
		Set xArcimObject=$list(ArcimFromList,indList)
		Continue:xArcimObject=""
		Set xArcimID=$list(xArcimObject,1)
		Continue:xArcimID=""
		Set xSttField=$list(xArcimObject,2)
		Set xEndField=$list(xArcimObject,3)
		
		Set arrRec=##Class(DHCMed.DPCustom.Data.OEOrdItem).GetDataByAdm(EpisodeID,"","","",xArcimID)
		Set Num=arrRec.Count()
		For indRec=1:1:Num {
			Set objRec=arrRec.GetAt(indRec)
			Continue:'$IsObject(objRec)
			
			Set OEItemID=objRec.RecordID
			Set Priority=objRec.Priority
			Set OEStartDate=objRec.SttDate
			Set OEStartTime=objRec.SttTime
			Set OEEndDate=objRec.XDate
			Set OEEndTime=objRec.XTime
			If (Priority'["长期")&&(ArcimToList="") {
				Set OEEndDate=OEStartDate
				Set OEEndTime=OEStartTime
			}
			Set OEOrdDesc=objRec.ItemDesc
			
		 	Set tmpDate="",tmpTime=""
		 	Set $p(tmpDate,"0",7-$l(OEStartDate))=OEStartDate
		 	Set $p(tmpTime,"0",7-$l(OEStartTime))=OEStartTime
		 	Set ^TMP($zn,$j,"GetICUResults",0,tmpDate_","_tmpTime,OEItemID)=$lb(OEStartDate,OEStartTime,OEEndDate,OEEndTime,Priority,OEOrdDesc)
		}
	}
	
	//插管结束医嘱
	For indList=1:1:$listlength(ArcimToList) {
		Set xArcimObject=$list(ArcimToList,indList)
		Continue:xArcimObject=""
		Set xArcimID=$list(xArcimObject,1)
		Continue:xArcimID=""
		Set xSttField=$list(xArcimObject,2)
		Set xEndField=$list(xArcimObject,3)
		
		Set arrRec=##Class(DHCMed.DPCustom.Data.OEOrdItem).GetDataByAdm(EpisodeID,"","","",xArcimID)
		Set Num=arrRec.Count()
		For indRec=1:1:Num {
			Set objRec=arrRec.GetAt(indRec)
			Continue:'$IsObject(objRec)
			
			Set OEItemID=objRec.RecordID
			Set Priority=objRec.Priority
			Set OEStartDate=objRec.SttDate
			Set OEStartTime=objRec.SttTime
			Set OEEndDate=objRec.XDate
			Set OEEndTime=objRec.XTime
			If (Priority'["长期")&&(ArcimToList="") {
				Set OEEndDate=OEStartDate
				Set OEEndTime=OEStartTime
			}
			Set OEOrdDesc=objRec.ItemDesc
			
		 	Set tmpDate="",tmpTime=""
		 	Set $p(tmpDate,"0",7-$l(OEStartDate))=OEStartDate
		 	Set $p(tmpTime,"0",7-$l(OEStartTime))=OEStartTime
		 	Set ^TMP($zn,$j,"GetICUResults",1,tmpDate_","_tmpTime,OEItemID)=$lb(OEStartDate,OEStartTime,OEEndDate,OEEndTime,Priority,OEOrdDesc)
		}
	}
	
	Set xDateTime=""
	For {
		Set xDateTime=$o(^TMP($zn,$j,"GetICUResults",0,xDateTime))
		Quit:xDateTime=""
		
		Set xOEItemID=""
		For {
			Set xOEItemID=$o(^TMP($zn,$j,"GetICUResults",0,xDateTime,xOEItemID))
			Quit:xOEItemID=""
			
			Set xValue=$g(^TMP($zn,$j,"GetICUResults",0,xDateTime,xOEItemID))
			Set StartDate=$list(xValue,1)
			Set StartTime=$list(xValue,2)
			Set EndDate=$list(xValue,3)
			Set EndTime=$list(xValue,4)
			Set Priority=$list(xValue,5)
			Set OEOrdDesc=$list(xValue,6)
			
			If (Priority'["长期")&&(ArcimToList'="") {
				Set yDateTime=$o(^TMP($zn,$j,"GetICUResults",1,xDateTime))
				If yDateTime'="" {
					Set yOEItemID=$o(^TMP($zn,$j,"GetICUResults",1,yDateTime,""))
					If yOEItemID'="" {
						Set yValue=$g(^TMP($zn,$j,"GetICUResults",1,yDateTime,yOEItemID))
						Set EndDate=$list(yValue,3)
						Set EndTime=$list(yValue,4)
					}
				}
			}
			
			Set objXICU=##Class(DHCMed.NINF.Srv.ICUIntubate).%New()
			Continue:'$IsObject(objXICU)
			
			Set objXICU.DataSource="OEITEM:"_xOEItemID
			Set objXICU.IntubateType=##class(DHCMed.NINF.Srv.Dictionary).GetDicObj(TypeID_"^"_TypeDesc)
			Set objXICU.IntubateDesc=OEOrdDesc
			Set objXICU.IntubateDate=StartDate
			Set objXICU.IntubateTime=StartTime
			Set objXICU.ExtubateDate=EndDate
			Set objXICU.ExtubateTime=EndTime
			If objXICU'="" Do objXICU.%Close()
			
			//Do $System.OBJ.Dump(objXICU)
			Do return.Insert(objXICU)
		}
	}
	Kill ^TMP($zn,$j,"GetICUResults")
	
	Quit return
}

/// w ##Class(DHCMed.NINF.Srv.ICUIntubate).getArcimList("InfRepVAPArcim")
ClassMethod getArcimList(aCategory As %String) As %List
{
	New (aCategory)
	Set return=""
	Quit:aCategory="" return
	
	Set ID=0
	For {
		Set ID=$o(^DHCMed.NINFDi("ICUIntu",0,"IndexCategory"," "_$zcvt(aCategory,"U"),ID))
		Quit:ID=""
		
		Set objDic=##class(DHCMed.NINF.Dic.ICUIntubate).GetObjById(ID)
		Continue:'$IsObject(objDic)
		
		Set ObjectID=objDic.ObjectID
		Set SttField=objDic.Target01
		Set EndField=objDic.Target02
		
		Set return=return_$lb($lb(ObjectID,SttField,EndField))
	}
	
	Quit return
}

Storage Default
{
<Data name="ICUIntubateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="ICUIntubateState">
<Subscript>"DHCMed.NINF.Srv.ICUIntubate"</Subscript>
<Value name="1">
<Value>ExtubateDate</Value>
</Value>
<Value name="2">
<Value>ExtubateTime</Value>
</Value>
<Value name="3">
<Value>IntubateDate</Value>
</Value>
<Value name="4">
<Value>IntubateTime</Value>
</Value>
<Value name="5">
<Value>IntubateType</Value>
</Value>
<Value name="6">
<Value>DataSource</Value>
</Value>
<Value name="7">
<Value>IntubateDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMed.N.ICUIntubateD</DataLocation>
<DefaultData>ICUIntubateDefaultData</DefaultData>
<IdLocation>^DHCMed.N.ICUIntubateD</IdLocation>
<IndexLocation>^DHCMed.N.ICUIntubateI</IndexLocation>
<State>ICUIntubateState</State>
<StreamLocation>^DHCMed.N.ICUIntubateS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

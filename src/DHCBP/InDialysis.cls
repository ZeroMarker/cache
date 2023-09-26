Import SQLUser

/// 加载透中项目:GetRecordList
/// 加载透中数据:FindData
/// 添加透中数据:Add
/// 删除透中数据:Delete
Class DHCBP.InDialysis Extends web.DHCClinicCom
{

// w ##class(DHCBP.InDialysis).GetRecordList(419)

// 科室在登陆时确认,由前台传入

ClassMethod GetRecordList(locId)
{
	q:locId="" ""
	s ^tem("20190905")=locId
	s Id=""
	s Id=..GetIdBylocId(locId)
	q:Id=""
	s configuration=##class(User.DHCClinicXMLConfiguration).%OpenId(Id)
	Set stream=configuration.XCDocumentContent
	//set status=##class(%XML.Document).GetDocumentFromStream(stream,.document)
	//Set rootNode=document.GetDocumentElement()
	s path="/BloodPurificationConfiguration/DisplayConfiguration/RecordViewMappingConfiguration/RecordViewMapping"
	// d ..ShowNode(rootNode)
	d ..GetItem(stream,path,"Code","HDF",.Item)
	s recordCode=Item("RecordCode")
	s path="/BloodPurificationConfiguration/DisplayConfiguration/DisplayRecordConfiguration/DisplayRecordCat"
	d ..GetList(stream,path,"Code",recordCode,.List)
	s jsonStream=..ToJson(.List)
	 w jsonStream.Read()
	q jsonStream.Read()
}

ClassMethod GetIdBylocId(locId)
{
	s docName="BPConfiguration"_locId_".xml"
	s id=""
	&sql(SELECT ID into :id FROM DHCClinic_XMLConfiguration WHERE XC_DocumentName=:docName)
	q id
}

// 通过arrangeId查找所有透中数据

// 格式:

//   [{DateTime:'2019-10-20 11:00',HR:67,SpO2:100..},..]

// w ##class(DHCBP.InDialysis).FindData(908)

ClassMethod FindData(arrangeId)
{
	k Array
	s date="" f  s date=$O(^DHCBPRecord(0,"DateTime",date)) q:date=""  d
	.s time="" f  s time=$O(^DHCBPRecord(0,"DateTime",date,arrangeId,time)) q:time=""  d
	..d AddItem
	..
	b ////
	s stream=..ToJson(.Array)
	// w stream.Read()
	q stream.Read()
AddItem
    s index=date_time
    s updateUser="",updateUserId="",count=0
    s id="" f  s id=$O(^DHCBPRecord(0,"DateTime",date,arrangeId,time,id)) q:id=""  d
    .s item=##class(User.DHCBPRecord).%OpenId(id)
    .;w item.BPRBPCRecordItemDr.BPCRICode,id,!
    .;q:((item.BPREditStatus="D")||(item.BPREditStatus="C"))
    .q:(item.BPREditStatus="D")
    .i ..ConvertToTime(time)["09:17" b /////
    .
    .q:item.BPRBPCRecordItemDr=""
    .s Array(index,"Datetime")=..ConvertToDate(date)_" "_..ConvertToTime(time)
    .s value=item.BPRQty
    .i item.BPRBPCRecordItemDr.BPCRICode="Note" s value=item.BPRNote
    .if item.BPRNote s value=item.BPRNote
    .s Array(index,item.BPRBPCRecordItemDr.BPCRICode)=value
    .s updateUser=item.BPRUpdateUserDr
    .s userObj=##class(User.SSUser).%OpenId(updateUser)
    .s updateUserDesc=userObj.SSUSRName
    .i count=0 d
    ..s Array(index,"KeyDT")=date_" "_time
    ..s Array(index,"updateUserDesc")=updateUserDesc
    ..s Array(index,"updateUserId")=updateUser
    q
}

// s paramStr="{""ArrangeId"":28085,""Code"":""DBP"",""Datetime"":""2019-12-03 11:45"",""Value"":""14""}"

// w ##class(DHCBP.InDialysis).Add(paramStr)

/// 添加一个时间点的数据
///    paramStr: "{""ArrangeId"":28085,""Code"":""DBP"",""Datetime"":""2019-12-03 11:45"",""Value"":""14""}"
ClassMethod Add(paramStr)
{
	s ^tmpby("20190528")=paramStr
	// s d={}.%FromJSON(paramStr)
	s d=..ToJsonObj(paramStr)
	s dateTime=d.GetAt("Datetime")
	s date=$p(dateTime," ",1)
	s time=$p(dateTime," ",2)
	s date=..ConvertToDateH(date)
	s time=..ConvertToTimeH(time)
	S updateUserDr=d.GetAt("UpdateUserDr")
	
	s arrangeId=d.GetAt("ArrangeId")
	s code=d.GetAt("Code")
	s value=d.GetAt("Value")
	s recordItemId=$$FindRecordItemId(code)
	/*if ((code="SBP")||(code="DBP")||(code="HR")){
		s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
		s arrange.BPAStartDiastolicPressure=value
    	s arrange.BPAStartSystolicPressure=value
		s arrange.BPAStartHeartRate=value
		}*/
	if (code="Datetime"){
		s oldDate=$p(value," ",1)
		s oldTime=$p(value," ",2)
		s oldDate=..ConvertToDateH(oldDate)
		s oldTime=..ConvertToTimeH(oldTime)
		&sql(update DHC_BP_Record set BPR_StartDate=:date,BPR_StartTime=:time 
		WHERE BPR_BPArrange_Dr=:arrangeId and BPR_StartDate=:oldDate and BPR_StartTime=:oldTime
		and BPR_EditStatus<>"D")
	}
	else {
	    s rowId=..SaveRecord(arrangeId,date,time,recordItemId,value,updateUserDr)
	}
	/*s key=""
	s rowId=""
	For{
		s key=d.Next(key)
		q:key=""
		s value=d.GetAt(key)
		s recordItemId=$$FindRecordItemId(key)
		b
		if (recordItemId'=""){
			b //
			s rowId=..SaveRecord(arrangeId,date,time,recordItemId,value)
		}
	}
    */

	/*
	set iter = d.%GetIterator()
	while iter.%GetNext(.key,.value) {
		s recordItemId=$$FindRecordItemId(key)
		if (recordItemId'=""){
			d ..SaveRecord(arrangeId,date,time,recordItemId,value)
		}
	}*/
	q rowId
FindRecordItemId(code)
    s id=""
    &sql(select BPCRI_RowId into:id 
    from DHC_BPC_RecordItem 
    where BPCRI_Code=:code)
    q id
}

// w ##class(DHCBP.InDialysis).Delete(114,"2021-06-29 16:19")

ClassMethod Delete(arrangeId, dateTime)
{
	s ^TempBPDebug("Delete")=arrangeId_" "_dateTime
	s date=$p(dateTime," ",1)
	s time=$p(dateTime," ",2)
	s date=..ConvertToDateH(date)
	s time=..ConvertToTimeH(time)
	&sql(Update DHC_BP_Record set BPR_EditStatus='D'
	where BPR_BPArrange_Dr=:arrangeId and BPR_StartDate=:date and BPR_StartTime=:time)
	q SQLCODE
}

// w ##class(DHCBP.InDialysis).SaveRecord(arrangeId, date, time, recordItemId, value)

ClassMethod SaveRecord(arrangeId, date, time, recordItemId, value, updateUserDr)
{
	s retstr=""
	if ('$ISVALIDNUM(date)) s date=..ConvertToDateH(date)
	if ('$ISVALIDNUM(time)) s time=..ConvertToTimeH(time)
	s oldId=$$Find()
	s recordCatDr=$$FindRecordCatId(recordItemId)
	//B
	if (oldId'=""){
		s oldRecord=##class(User.DHCBPRecord).%OpenId(oldId)
		s oldRecord.BPRBPCRecordCatDr=##class(User.DHCBPCRecordCat).%OpenId(recordCatDr)
		s oldRecord.BPREditStatus="C"
		s oldRecord.BPRUpdateDate=+$h
		s oldRecord.BPRUpdateTime=$p($h,",",2)
		s oldRecord.BPRQty=+value
		s oldRecord.BPRNote=value
		s oldRecord.BPRUpdateUserDr=updateUserDr
		d oldRecord.%Save()
		//s record.BPREditStatus="E"
		s retstr=oldId
	}
	else {
		s record=##class(User.DHCBPRecord).%New()
		s record.BPREditStatus="N"
	
	
		s record.BPRBPArrangeDr=##class(User.DHCBPArrange).%OpenId(arrangeId)
		s record.BPRBPCRecordItemDr=##class(User.DHCBPCRecordItem).%OpenId(recordItemId)
		s record.BPRBPCRecordCatDr=##class(User.DHCBPCRecordCat).%OpenId(recordCatDr)
		s record.BPRStartDate=date
		s record.BPRStartTime=time
		s record.BPREndDate=date
		s record.BPREndTime=time
		s record.BPRUpdateDate=+$h
		s record.BPRUpdateTime=$p($h,",",2)
		s record.BPRUpdateUserDr=updateUserDr
		s record.BPRQty=+value
		s record.BPRNote=value
		s record.BPRSource="M"
	
		d record.%Save()
		s retstr=record.%Id()
		}
	q retstr
Find()
   s id=""
   &sql(select BPR_RowId into :id from DHC_BP_Record
   where BPR_BPArrange_Dr=:arrangeId and BPR_BPCRecordItem_Dr=:recordItemId and
   BPR_StartDate=:date and BPR_StartTime=:time)
   q id
FindRecordCatId(recordItemId)
    s RecordCatDr =""
    &sql(select BPCRI_BPCRecordCat_Dr into:RecordCatDr 
    from DHC_BPC_RecordItem 
    where BPCRI_RowId=:recordItemId)
    q RecordCatDr
}

// w ##class(DHCBP.InDialysis).WriteNodes()

// w ##class(DHCBP.InDialysis).GetItem(stream,path,"Code","HDF")

ClassMethod GetItem(stream, path, attrName, value, ReturnItem = "")
{
	//s configuration=##class(User.DHCClinicXMLConfiguration).%OpenId(22)
	//Set stream=configuration.XCDocumentContent
    set status=##class(%XML.TextReader).ParseStream(stream,.textreader)
    //check status
    if $$$ISERR(status) {do $System.Status.DisplayError(status) quit}
    //iterate through document, node by node
    s find=""
    s obj=""
    
    while ((find="")&&(textreader.Read()))
    {
        if (textreader.Path=path) {
	       do FindItem()
        }
    }
    q:find=1 obj
    q ""
FindItem()
   //s obj={}
   s obj=##class(%Library.ArrayOfDataTypes).%New()
   
   
   If (textreader.NodeType="element") {
	   // list attributes for this node
	   For a = 1:1:textreader.AttributeCount {
		  Do textreader.MoveToAttributeIndex(a)
		  // Write find.LocalName," = ",find.Value,!
		  if ((textreader.LocalName=attrName) && (textreader.Value=value)){
		     Set find=1
		  }
		  d obj.SetAt(textreader.Value,textreader.LocalName)
		  //d obj.%Set(textreader.LocalName,textreader.Value)
		  s ReturnItem(textreader.LocalName)=textreader.Value
	   }
   }
   q obj
}

// w ##class(DHCBP.InDialysis).GetList(stream,path,"Code","General",.MyList)

// s path="/BloodPurificationConfiguration/DisplayConfiguration/DisplayRecordConfiguration/DisplayRecordCat"

ClassMethod GetList(stream, path, attrName, value, ReturnList = "")
{
	//s configuration=##class(User.DHCClinicXMLConfiguration).%OpenId(22)
	//Set stream=configuration.XCDocumentContent
	k ReturnList
    set status=##class(%XML.TextReader).ParseStream(stream,.textreader)
    //check status
    if $$$ISERR(status) {do $System.Status.DisplayError(status) quit}
    //iterate through document, node by node
    s find=""
    //s list=[]
    
    s list=##class(%Library.ArrayOfDataTypes).%New()
    s index=0
    while ((find="")&&(textreader.Read()))
    {
	    
        if (textreader.Path=path) {
	       if $$FindItem()=1{
		       d textreader.Read()
		       s subPath=textreader.Path
		       while (subPath=textreader.Path){
			       if $$OutPut() s index=index+1
			       do textreader.Read()
			   }
		       
	       }
	       
        }
    }
    q:find=1 list
    q ""
FindItem()
   //s obj={}
   
   s obj=##class(%Library.ArrayOfDataTypes).%New()
   If (textreader.NodeType="element") {
	   // list attributes for this node
	   For a = 1:1:textreader.AttributeCount {
		  Do textreader.MoveToAttributeIndex(a)
		  if ((textreader.LocalName=attrName) && (textreader.Value=value)){
		     Set find=1
		  }
	   }
   }
   q find
OutPut()
   //s obj={}
   s obj=##class(%Library.ArrayOfDataTypes).%New()
   s hasValue=0
   If (textreader.NodeType="element") {
	   // list attributes for this node
	   For a = 1:1:textreader.AttributeCount {
		  Do textreader.MoveToAttributeIndex(a)
		  //d obj.%Set(textreader.LocalName,textreader.Value)
		  d obj.SetAt(textreader.Value,textreader.LocalName)
		  s ReturnList(index,textreader.LocalName)=textreader.Value
		  s hasValue=1
	   }
   }
   if (hasValue) {
   //d list.%Set(index,obj)
   d list.SetAt(obj,index)
   }
   q hasValue
}

ClassMethod ShowNode(node As %XML.Node)
{
    Write !,"LocalName="_node.LocalName
    If node.NodeType=$$$xmlELEMENTNODE  {
        Write !,"Namespace="_node.Namespace
    }
    If node.NodeType=$$$xmlELEMENTNODE {
        Write !,"NamespaceIndex="_node.NamespaceIndex
     }
    Write !,"Nil="_node.Nil
    Write !,"NodeData="_node.NodeData
    Write !,"NodeId="_node.NodeId
    Write !,"NodeType="_node.NodeType
    Write !,"QName="_node.QName
    Write !,"HasChildNodes returns "_node.HasChildNodes()
    Write !,"GetNumberAttributes returns "_node.GetNumberAttributes()
    Set status=node.GetText(.text)
    If status {
        Write !, "Text of the node is "_text
        } else {
            Write !, "GetText does not return text"
        }
}

ClassMethod ShowAttributes(node As %XML.Node)
{
    Set count=node.GetNumberAttributes()
    Write !, "Number of attributes: ", count
    Set first=node.FirstAttributeName()
    Write !, "First attribute is: ", first
    Write !, "   Its value is: ",node.GetAttributeValue(first)
    Set next=node.NextAttributeName(first)

    For i=1:1:count-2 {
        Write !, "Next attribute is: ", next
        Write !, "   Its value is: ",node.GetAttributeValue(next)
        Set next=node.NextAttributeName(next)
        }
    Set last=node.LastAttributeName()
    Write !, "Last attribute is: ", last
    Write !, "   Its value is: ",node.GetAttributeValue(last)
}

// w ##class(DHCBP.InDialysis).FindArrangeInfo(27750)

// 获取透析状态，透析中签名信息

ClassMethod FindArrangeInfo(arrangeId)
{
	set StartOperationNurse="",StartOperationDateTime="",NurseCheck="",NurseCheckDateTime="",StartOperationNurseDr="",NurseCheckDr=""
	set arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
	//set json={}
	set json=##class(%Library.ArrayOfDataTypes).%New()

	do AddJson("CheckDocDr",arrange.BPACheckDocDr)
	do AddJson("Status",arrange.BPAStatus)
	if (arrange.BPAStartOperationNurseDr'=""){
		s obj=##class(User.CTCareProv).%OpenId(arrange.BPAStartOperationNurseDr)
	    s StartOperationNurse=obj.CTPCPDesc
	    s StartOperationNurseDr=arrange.BPAStartOperationNurseDr
	    s StartOperationDate=..ConvertToDate(arrange.BPAStartOperationDate)
	    s StartOperationTime=..ConvertToTime(arrange.BPAStartOperationTime)
	    s StartOperationDateTime=StartOperationTime
	}
    
    if (arrange.BPACheckNurseDr'=""){
	    s obj=##class(User.CTCareProv).%OpenId(arrange.BPACheckNurseDr)
	    s NurseCheck=obj.CTPCPDesc
	    s NurseCheckDr=arrange.BPACheckNurseDr
	    s NurseCheckDate=..ConvertToDate(arrange.BPANurseCheckDate)
	    s NurseCheckTime=..ConvertToTime(arrange.BPANurseCheckTime)
	    s NurseCheckDateTime=NurseCheckDate_" "_NurseCheckTime
    }
    do AddJson("StartOperationNurse",StartOperationNurse)
    do AddJson("StartOperationNurseDr",StartOperationNurseDr)
    
    do AddJson("StartOperationDatetime",StartOperationDateTime) 
    do AddJson("NurseCheck",NurseCheck)
    do AddJson("NurseCheckDr",NurseCheckDr)
    do AddJson("NurseCheckDateTime",NurseCheckDateTime)
    	  
 	q ##class(Nur.JSON).Encode(json)
AddJson(name,value)
   //d json.%Set(name,value)
   d json.SetAt(value,name)
}

/// Creator: by
/// CreatDate: 2019-12-03
/// Description: 保存签名
/// Table：DHC_BP_Arrange
/// Input：arrangeId,签名者医护人员表id，更新日期，时间拼接字符串
///  s paramStr="{""ArrangeId"":""68"",""Role"":""StartOperationNurse"",""CtcpId"":626,""UpdateDate"":""2020/5/24"",""UpdateTime"":""09:52""}"
/// w ##class(DHCBP.InDialysis).SaveSignature(paramStr)
/// Return：SQLCODE
ClassMethod SaveSignature(paraStr)
{
	s obj=..ToJsonObj(paraStr)
	s role=obj.GetAt("Role")
	s arrangeId=obj.GetAt("ArrangeId")
	s ctcpId=obj.GetAt("CtcpId")
	s updateDate=obj.GetAt("UpdateDate")
	s updateDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
	s updateTime=obj.GetAt("UpdateTime")
	s updateTime=##class(web.DHCClinicCom).ConvertToTimeH(updateTime)
	s res=""
	if (role="StartOperationNurse")
	{
		//s res=##class(web.DHCBPCom).StartEquipCollect(arrangeId)	
		s res=""	
		if (res=0)||(res="") 
		{
		  &sql(update DHC_BP_Arrange set BPA_Status='M',BPA_StartOperationNurse_Dr=:ctcpId,BPA_StartOperationDate=:updateDate,
		  BPA_StartOperationTime=:updateTime where BPA_RowId=:arrangeId
		  )
		}
		/* i SQLCODE=0 d
		.s ^tmpdebug("go")=res
		.;s res=##class(web.DHCBPCom).StartEquipCollect(arrangeId)
		.s res=0
		.s ^tmpdebug("res")=res
		*/
	}
	if (role="EditStartOperationDT")
	{

	  &sql(update DHC_BP_Arrange set BPA_StartOperationDate=:updateDate,
		BPA_StartOperationTime=:updateTime where BPA_RowId=:arrangeId
		)

	}
	if (role="CheckNurse")
	{
	  &sql(update DHC_BP_Arrange set BPA_CheckNurse_Dr=:ctcpId,BPA_NurseCheckDate=:updateDate,
		BPA_NurseCheckTime=:updateTime where BPA_RowId=:arrangeId
		)	
	}
	if (role="WardRoundDoctor")
	{
	&sql(update DHC_BP_Arrange set BPA_WardRoundDoc_Dr=:ctcpId,BPA_WardRoundDate=:updateDate,
		BPA_WardRoundTime=:updateTime where BPA_RowId=:arrangeId
		)	
	}
	i res="" s res=SQLCODE
	q res
}

/// d ##class(%ResultSet).RunQuery("DHCBP.InDialysis","GetRecordItemOptions","Note")
Query GetRecordItemOptions(code As %String = "") As %Query(ROWSPEC = "Option:%String")
{
}

ClassMethod GetRecordItemOptionsExecute(ByRef qHandle As %Binary, code As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	q:code="" ""
 	s Options=""
 	&sql(select BPCRI_Options into:Options from DHC_BPC_RecordItem where BPCRI_Code=:code)
 	s Option=""
 	i $l(Options,";")>0 d
 	.f i=1:1:$l(Options,";") d
 	..s Option=$p(Options,";",i)
	..d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(Option)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetRecordItemOptionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVascularAccessListOldExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetRecordItemOptionsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVascularAccessListOldExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

// w ##class(DHCBP.InDialysis).GetCollectData(119,114,"2021-06-30 10:04",578)

ClassMethod GetCollectData(locId, arrangeId, dateTime, updateUserDr)
{
	q:locId="" ""
	s ^tem("20190905")=locId
	s Id="",retstr=""
	s Id=..GetIdBylocId(locId)
	q:Id=""
	s date=##class(web.DHCClinicCom).ConvertToDateH($p(dateTime," ",1))
	s time=##class(web.DHCClinicCom).ConvertToTimeH($p(dateTime," ",2))
	s configuration=##class(User.DHCClinicXMLConfiguration).%OpenId(Id)
	Set stream=configuration.XCDocumentContent
	//set status=##class(%XML.Document).GetDocumentFromStream(stream,.document)
	//Set rootNode=document.GetDocumentElement()
	s path="/BloodPurificationConfiguration/DisplayConfiguration/RecordViewMappingConfiguration/RecordViewMapping"
	// d ..ShowNode(rootNode)
	d ..GetItem(stream,path,"Code","HDF",.Item)
	s recordCode=Item("RecordCode")
	s path="/BloodPurificationConfiguration/DisplayConfiguration/DisplayRecordConfiguration/DisplayRecordCat"
	d ..GetList(stream,path,"Code",recordCode,.List)
	s name="",recordItemStr=""
	f  s name=$O(List(name)) q:name=""  d
	.s code=List(name,"Code")
	.s recordItemId=$$FindRecordItemId(code)
	.s res=##Class(web.DHCBPCom).GetCollectData(arrangeId,date,time,recordItemId)
	.b
	.s value=$lg(res,13)
	.s retstr=..SaveRecord(arrangeId, date, time, recordItemId, value, updateUserDr)
	q retstr
FindRecordItemId(code)
    s id=""
    &sql(select BPCRI_RowId into:id 
    from DHC_BPC_RecordItem 
    where BPCRI_Code=:code)
    q id
}

}

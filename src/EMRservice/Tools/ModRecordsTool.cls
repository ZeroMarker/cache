/// 名称:EMRservice.Tools.ModRecordsTool
/// 描述:修改病例数据
/// 编写者：yejian
/// 编写日期: 2019-9-26
Class EMRservice.Tools.ModRecordsTool Extends (%RegisteredObject, %XML.Adaptor)
{

/// do ##class(%ResultSet).RunQuery("EMRservice.Tools.ModRecordsTool","GetAllInstanceIDQueryByDate","2019-02-18","2019-09-26")
Query GetAllInstanceIDQueryByDate(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "InstanceID:%String,reValue:%String")
{
}

ClassMethod GetAllInstanceIDQueryByDateExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1,Count=300
 	
	s InstanceID=""
	q:(AStartDate = "") $$$OK
    q:(AEndDate = "") $$$OK
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s date = endDate+1
	s sdate=startDate
  	for {
		s sdate =  $o(^DHCEMRI.InstanceDataI("IdxModifyDate", sdate))			
		q:(sdate = "")
		q:(sdate>date)
		s parentId = ""
		for
		{
			s parentId = $o(^DHCEMRI.InstanceDataI("IdxModifyDate",sdate,parentId))
			q:(parentId = "")
			s subId = ""
			for
			{
				s subId = $o(^DHCEMRI.InstanceDataI("IdxModifyDate",sdate,parentId,subId))
				q:(subId = "")
				s InstanceID=parentId_"||"_subId
				s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)  
				q:(objInstance = "")
				q:((objInstance.RealTemplateID'="38")||(objInstance.Status'="Save"))
				s simCID = $o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_InstanceID," V001"," V002"," O0128",""))				
				q:(simCID = "")
				s objCSim =##class(EMRinstance.ICompositeSimple).%OpenId(simCID)				
				q:(objCSim="")
				s ckdrugAllergy = objCSim.DataValue
				q:(ckdrugAllergy'="-")
				s simSID = $o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_InstanceID," V001"," V002"," L0129",""))				
				q:(simSID = "")
				s objSSim =##class(EMRinstance.ICompositeSimple).%OpenId(simSID)				
				q:(objSSim="")
				s skdrugAllergy = objSSim.DataValue
				s reValue = ""   
				if (skdrugAllergy="无") //||(skdrugAllergy = "")
				{
					s reValue = "1"
				}elseif($l(skdrugAllergy)>0)
				{
					s reValue = "2"
				}
				      
				s ^CacheTemp(repid,ind) = $lb(InstanceID,reValue)
				s ind=ind+1
				q		
			}
		}					    
	}
  
   Quit $$$OK
}

ClassMethod GetAllInstanceIDQueryByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllInstanceIDQueryByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllInstanceIDQueryByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllInstanceIDQueryByDateExecute ]
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

/// debug d ##class(EMRservice.Tools.ModRecordsTool).ModRecordData("2019-09-11","2019-09-11")
ClassMethod ModRecordData(AStartDate As %String, AEndDate As %String) As %String
{
	s count = ""
	s instanceStream = ##class(%GlobalBinaryStream).%New()
	s inputDecrypt = ##class(%GlobalBinaryStream).%New()
	s objEData = ##class(EPRservice.entity.EInstanceData).%New() 
	s ds = ##class(%ResultSet).RunQuery("EMRservice.Tools.ModRecordsTool","GetAllInstanceIDQueryByDate")
	d ds.Execute(AStartDate,AEndDate)
	
	While (ds.Next())
	{

		s InstanceID =ds.Data("InstanceID")
		s reValue =ds.Data("reValue")
		continue:(InstanceID="")
		s saveinstanceobj=##class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s userid=saveinstanceobj.CreateUser
		s title=saveinstanceobj.Title
		s titlecode=saveinstanceobj.TitleCode
		d instanceStream.Clear()
		d inputDecrypt.Clear()
		q:(userid="")
		d instanceStream.CopyFrom(saveinstanceobj.InstanceData)
		s strCont = "<Code Code=""O0128"" SourceCode=""O0128""  CCode=""V002""  KBNodeID="""" DisplayName=""药物过敏""/>"
		s strReOld = "<Object Code=""O0128"" Type=""2"" Value=""-"" DrawInboxRect=""6"">"
		s strRevalue =  ""
		s strReView = ""
		s strSimValue = ""
		if (reValue = "2")
		{
			s strSimValue = "有"
			s strRevalue = "<Value><Choice Code=""2"" DisplayName=""有""/>"
			s strReView = "<Object Code=""O0128"" Type=""2"" Value=""2"" DrawInboxRect=""6"">"
		}
		else
		{ 
			s strSimValue = "无"
			s strRevalue = "<Value><Choice Code=""1"" DisplayName=""无""/>"
			s strReView = "<Object Code=""O0128"" Type=""1"" Value=""1"" DrawInboxRect=""6"">"
		}
		
		s strCont = $zcvt(strCont,"O","UTF8")
		s strReOld = $zcvt(strReOld,"O","UTF8")
		s strRevalue = $zcvt(strRevalue,"O","UTF8")
		s strReView = $zcvt(strReView,"O","UTF8")
		s replacesm = ""
		d instanceStream.Rewind()
	    while (instanceStream.AtEnd = 0)
	    {
	        s tmp =  instanceStream.Read(32000)
	        if (tmp [ strCont)
	        {
		        s tmp1 = $p(tmp,strCont,1)
		        s tmp2 = strCont
		        s tmp3 = $p(tmp,strCont,2)
		        s tmp31 = $p(tmp3,"</Value>",1)
		        s tmp3 = $REPLACE(tmp3,tmp31,strRevalue)
		        s tmp = tmp1_tmp2_tmp3
	        }
	        if (tmp [ strReOld)
	        {
		         s tmp = $REPLACE(tmp,strReOld,strReView)
	        }
	        d inputDecrypt.Write(tmp)
	    } 
	    d saveinstanceobj.InstanceData.CopyFrom(inputDecrypt)
		s sc = saveinstanceobj.%Save()
		
		s simCID = $o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_InstanceID," V001"," V002"," O0128",""))				
		q:(simCID = "")
		s objCSim =##class(EMRinstance.ICompositeSimple).%OpenId(simCID)				
		q:(objCSim="")
		s objCSim.DataValue = strSimValue  
		s objCSim.ValueCode = reValue
		s scs = objCSim.%Save()
		s saveinstanceobj=""
		s objCSim = ""
		s count=count+1
		
	}
    q "创建病历数："_count
}

/// debug d ##class(EMRservice.Tools.ModRecordsTool).TestSaveData("1591544||1","1")
ClassMethod TestSaveData(InstanceID As %String, reValue As %String)
{
	//b "s"
	
	//s argOutData = ##class(%FileBinaryStream).%New() 
	//s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID) 
	//d argOutData.CopyFrom(##Class(EMRservice.BL.BLTemplate).GetRecordXML(objInstance.TemplateID,"Document",objInstance.Title,objInstance.TitleCode,objInstance.InstanceMetaData,objInstance.InstanceScriptData,objInstance.InstanceData,objInstance.InstanceMedia,objInstance.InstanceInitialData))
	
	s instanceStream = ##class(%GlobalBinaryStream).%New()
	s inputDecrypt = ##class(%GlobalBinaryStream).%New()
	
	s saveinstanceobj=##class(EMRinstance.InstanceData).%OpenId(InstanceID)
	s userid=saveinstanceobj.CreateUser
	s title=saveinstanceobj.Title
	s titlecode=saveinstanceobj.TitleCode
	
	q:(userid="")
	d instanceStream.CopyFrom(saveinstanceobj.InstanceData)
	/*
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="D:\xml\GET_DOCUMENT_"_11_".xml"
	//s AStream.Filename="/tmp/SAVE_DOCUMENT_"_InstanceID_".xml"
	d AStream.CopyFrom(instanceStream)
	d AStream.SaveStream()
	d AStream.%Close()
	*/
	s strCont = "<Code Code=""O0128"" SourceCode=""O0128""  CCode=""V002""  KBNodeID="""" DisplayName=""药物过敏""/>"
	s strReOld = "<Object Code=""O0128"" Type=""2"" Value=""-"" DrawInboxRect=""6"">"
	s strRevalue =  ""
	s strReView = ""
	s strSimValue = ""
	if (reValue = "2")
	{
		s strSimValue = "有"
		s strRevalue = "<Value><Choice Code=""2"" DisplayName=""有""/>"
		s strReView = "<Object Code=""O0128"" Type=""2"" Value=""2"" DrawInboxRect=""6"">"
	}
	else
	{ 
		s strSimValue = "无"
		s strRevalue = "<Value><Choice Code=""1"" DisplayName=""无""/>"
		s strReView = "<Object Code=""O0128"" Type=""1"" Value=""1"" DrawInboxRect=""6"">"
	}
		
	
	s strCont = $zcvt(strCont,"O","UTF8")
	s strReOld = $zcvt(strReOld,"O","UTF8")
	s strRevalue = $zcvt(strRevalue,"O","UTF8")
	s strReView = $zcvt(strReView,"O","UTF8")
	s replacesm = ""
	d instanceStream.Rewind()
    while (instanceStream.AtEnd = 0)
    {
        s tmp =  instanceStream.Read(32000)
        if (tmp [ strCont)
        {
	        s tmp1 = $p(tmp,strCont,1)
	        s tmp2 = strCont
	        s tmp3 = $p(tmp,strCont,2)
	        s tmp31 = $p(tmp3,"</Value>",1)
	        s tmp3 = $REPLACE(tmp3,tmp31,strRevalue)
	        s tmp = tmp1_tmp2_tmp3
        }
        if (tmp [ strReOld)
        {
	         s tmp = $REPLACE(tmp,strReOld,strReView)
        }
        d inputDecrypt.Write(tmp)
    }  
	
	/*
	s A1Stream=##Class(%FileBinaryStream).%New()
	s A1Stream.Filename="D:\xml\GET_DOCUMENT_"_12_".xml"
	//s A1Stream.Filename="/tmp/SAVE_DOCUMENT_"_InstanceID_".xml"
	d A1Stream.CopyFrom(inputDecrypt)
	d A1Stream.SaveStream()
	d A1Stream.%Close()
	*/
	d saveinstanceobj.InstanceData.CopyFrom(inputDecrypt)
	s sc = saveinstanceobj.%Save() //病历数据流修改保存
	s simCID = $o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_InstanceID," V001"," V002"," O0128",""))				
	q:(simCID = "")
	s objCSim =##class(EMRinstance.ICompositeSimple).%OpenId(simCID)				
	q:(objCSim="")
	s objCSim.DataValue = strSimValue
	s objCSim.ValueCode = reValue 
	
	s scs = objCSim.%Save() //打散表数据修改保存
	s saveinstanceobj=""
	s objCSim = ""
	
	//s AStream=##Class(%FileBinaryStream).%New()
	//s AStream.Filename="D:\xml\GET_DOCUMENT_"_11_".xml"
	//s AStream.Filename="/tmp/SAVE_DOCUMENT_"_InstanceID_".xml"
	//s status= ##Class(EMRservice.BL.BLInstanceData).SaveDoucment(InstanceID,userid,AStream, title,titlecode,"")

	s errorMsg = ""

	w "succeed!"
}

/// w ##Class(EMRservice.Tools.DailyWorkTool).SaveDocument("4084||1")
ClassMethod SaveDocument(AInstanceID As %String)
{
	 s saveinstanceobj=##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	 s userid=saveinstanceobj.CreateUser
	 s title=saveinstanceobj.Title
	 s titlecode=saveinstanceobj.TitleCode
	 
	 q:(userid="") -1
	 s saveinstanceobj=""
	 s AStream=##Class(%FileBinaryStream).%New()
	 s AStream.Filename="/tmp/SAVE_DOCUMENT_"_AInstanceID_".xml"
	 s status= ##Class(EMRservice.BL.BLInstanceData).SaveDoucment(AInstanceID,userid,AStream, title,titlecode,"")

	 q status
}

}

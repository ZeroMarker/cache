/// 诊断
Class DWR.DIA.BL.Diagnosis Extends %RegisteredObject
{

ClassMethod DiagnosisIns(pRequest As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $ZT="DiagnosisInsET"
	set pResponse=""
	quit pResponse
DiagnosisInsET
	quit pResponse
}

ClassMethod DiagnosisRecQry(RtStream As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $ZT="DiagnosisRecQryET"
	set pResponse=##Class(DWR.DIA.MSG.DiagnosisRecQryRp).%New()

	set reader = ##class(%XML.Reader).%New()
	set sc=reader.OpenStream(RtStream)
	If $$$ISERR(sc) 
	{
		do Output("100","HIS接收到的入参数据格式有误"_sc)
	    Quit RpStream
	}
	Do reader.Correlate("Request","DWR.DIA.MSG.DiagnosisRecQryRt")
	if (reader.Next(.pRequest,.sc))
	{   
	}
	if ('$IsObject(pRequest))
	{
		do Output("100","HIS接收到的入参数据格式有误")
	    Quit RpStream
	}
	
	
	set pResponse=..DiagnosisRecQryExe(pRequest)
	do Output(pResponse.ResultCode,pResponse.ResultContent)
	
	quit RpStream
	
Output(ResultCode,ResultContent)
	set RpStream=""
	set pResponse.ResultCode=ResultCode
	set pResponse.ResultContent=ResultContent
	set RtStream=##class(%GlobalCharacterStream).%New()
	do pResponse.XMLExportToStream(.RpStream,"Response")
	quit
DiagnosisRecQryET
	set pResponse=##Class(DWR.DIA.MSG.DiagnosisRecQryRp).%New()
	do Output("-100","HIS端错误："_$ZERROR)
	quit RpStream
}

ClassMethod DiagnosisRecQryExe(Rt As DWR.DIA.MSG.DiagnosisRecQryRt) As DWR.DIA.MSG.DiagnosisRecQryRp
{
	set $ZT="DiagnosisRecQryExeET"
	set ResultCode="100"
	set ResultContent="没有查询到患者的诊断记录"
	set Rp=##Class(DWR.DIA.MSG.DiagnosisRecQryRp).%New()
	set EpisodeID=Rt.EpisodeID
	set PatientID=Rt.PatientID
	set Diagnosishistory=Rt.Diagnosishistory
	
	if (EpisodeID="")
	{
		do OutputResult("101","就诊ID不能为空")
	    Quit Rp
	}
	set PatientID=$piece($get(^PAADM(EpisodeID)),"^",1)
	if (PatientID="")
	{
		do OutputResult("101","患者就诊记录不存在")
	    Quit Rp
	}
	if (Diagnosishistory="N")     // 只查本次诊断，不包括历史诊断
	{
		set GroupObj=##Class(DWR.DIA.MSG.DiagnosisRecGroup).%New()
		set GroupObj.GroupName="本次诊断"
		do OutputDiagnosisRec(EpisodeID,EpisodeID)
		do Rp.DiagnosisRecGroupList.Insert(GroupObj)
		do GroupObj.%Close()
	}
	else
	{
		if ((Diagnosishistory'="Y"))  // 包括本次诊断
		{
			set GroupObj=##Class(DWR.DIA.MSG.DiagnosisRecGroup).%New()
			set GroupObj.GroupName="本次诊断"
			do OutputDiagnosisRec(EpisodeID,EpisodeID)
			do Rp.DiagnosisRecGroupList.Insert(GroupObj)
			do GroupObj.%Close()
		}
		
		// 历史诊断
		set GroupObj=##Class(DWR.DIA.MSG.DiagnosisRecGroup).%New()
		set GroupObj.GroupName="历史诊断"
		
		set AdmType=""
		while($order(^PAPERdr(PatientID,"ADM",AdmType))'="")
		{
			set AdmType=$order(^PAPERdr(PatientID,"ADM",AdmType))
			
			set AdmID=""
			while($order(^PAPERdr(PatientID,"ADM",AdmType,AdmID),-1)'="")
			{
				set AdmID=$order(^PAPERdr(PatientID,"ADM",AdmType,AdmID),-1)
				
				if (AdmID=EpisodeID) continue
				
				do OutputDiagnosisRec(AdmID,EpisodeID)
				
			}
		}
		do Rp.DiagnosisRecGroupList.Insert(GroupObj)
		do GroupObj.%Close()
		
	}
	
	do OutputResult(ResultCode,ResultContent)
	quit Rp
	
OutputDiagnosisRec(myEpisodeID,EpisodeID)
	
	set MRADMRowID=$piece($get(^PAADM(myEpisodeID)),"^",61)
	if (MRADMRowID="") quit
	if (EpisodeID=myEpisodeID)
	{
		set DiagnosisRecFlag="Y"
		set GroupName="本次诊断"
	}
	else
	{
		set DiagnosisRecFlag="N"
		set GroupName="历史诊断"
	}
	set ChildSub=""
	while (($order(^MR(MRADMRowID,"DIA",ChildSub),-1)'="")&&($order(^MR(MRADMRowID,"DIA",ChildSub),-1)'="0"))
	{
		set ChildSub=$order(^MR(MRADMRowID,"DIA",ChildSub),-1)
		set ICDDr=$piece($get(^MR(MRADMRowID,"DIA",ChildSub)),"^",1)
		set MrDesc=$get(^MR(MRADMRowID,"DIA",ChildSub,"DES",1))
		if (ICDDr="")&&(MrDesc="") continue
		set ICDCode=""
		if (ICDDr'="")
		{
			if MrDesc'="" set ICDDesc=$piece($get(^MRC("ID",ICDDr)),"^",2)_":"_MrDesc
			else  set ICDDesc=$piece($get(^MRC("ID",ICDDr)),"^",2),ICDCode=$piece($get(^MRC("ID",ICDDr)),"^",1)
		}
		else  
		{
			set ICDDesc=MrDesc
		}
		set ResultCode="0"
		set ResultContent="查询成功"
		
		set RowObj=##Class(DWR.DIA.MSG.DiagnosisRecord).%New()
		set RowObj.DiagnosisID=MRADMRowID_"||"_ChildSub
		set TypeSub=$order(^MR(MRADMRowID,"DIA",ChildSub,"TYP","0"))
		if (TypeSub'="")
		{
			set DiagnosisTypeID=$piece(^MR(MRADMRowID,"DIA",ChildSub,"TYP",TypeSub),"^",1)
			set RowObj.DiagnosisType=$piece($get(^MRC("DTYP",DiagnosisTypeID)),"^",2)
		}
		set RowObj.ICDCode=ICDCode
		set RowObj.ICDDesc=ICDDesc
	
		set DoctorID=$piece($get(^MR(MRADMRowID,"DIA",ChildSub)),"^",4)
		if (DoctorID'="") 
		{	
			set RowObj.Doctor=$piece($get(^CTPCP(DoctorID,1)),"^",2)
		}
		set UpdateDate=$piece($get(^MR(MRADMRowID,"DIA",ChildSub)),"^",7)
		set UpdateTime=$piece($get(^MR(MRADMRowID,"DIA",ChildSub)),"^",8)
		if (UpdateDate'="")
		{
			set RowObj.UpdateDate=$ZDate(UpdateDate,3)
			set RowObj.UpdateTime=$ZTime(UpdateTime,2)
		}
		set RowObj.DiagnosisRecFlag=DiagnosisRecFlag
	
	set sc=GroupObj.DiagnosisRecList.Insert(RowObj)
		
	do RowObj.%Close()
		
		
	}
	
	
	
		
	quit

OutputResult(ResultCode,ResultContent)
	set Rp.ResultCode=ResultCode
	set Rp.ResultContent=ResultContent
	quit
DiagnosisRecQryExeET
	set Rp=##Class(DWR.DIA.MSG.DiagnosisRecQryRp).%New()
	do OutputResult("-100","HIS端错误："_$ZERROR)
	quit Rp
}

ClassMethod DiagnosisTypeQry(pRequest As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $ZT="DiagnosisTypeQryET"
	set pResponse=""
	quit pResponse
DiagnosisTypeQryET
	quit pResponse
}

ClassMethod ICDQry(pRequest As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $ZT="ICDET"
	set pResponse=""
	quit pResponse
ICDET
	quit pResponse
}

/// 取一次就诊的诊断信息	
ClassMethod GetOneAdmDiagnos(MRADMRowID As %String) As %String
{
	
	set mystr=""
	set ChildSub="0"
	while ($order(^MR(MRADMRowID,"DIA",ChildSub))'="")
	{
		set ChildSub=$order(^MR(MRADMRowID,"DIA",ChildSub))
		set ICDDr=$piece($get(^MR(MRADMRowID,"DIA",ChildSub)),"^",1)
		set MrDesc=$get(^MR(MRADMRowID,"DIA",ChildSub,"DES",1))
		if (ICDDr="")&&(MrDesc="") continue
		if (ICDDr'="")
		{
			if MrDesc'="" set ICDDesc=$piece($get(^MRC("ID",ICDDr)),"^",2)_":"_MrDesc
			else  set ICDDesc=$piece($get(^MRC("ID",ICDDr)),"^",2)
		}
		else  
		{
			set ICDDesc=MrDesc
		}
		if (mystr="")
		{
			set mystr=ICDDesc
		}
		else
		{
			set mystr=mystr_","_ICDDesc
		}
	}
	quit mystr
}

}

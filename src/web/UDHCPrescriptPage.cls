Class web.UDHCPrescriptPage Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("ACTION",1),"")
	s EpisodeID=$Get(%request.Data("EpisodeID",1),"")
	s PrescNoStr=$Get(%request.Data("PrescNoStr",1),"")
	s OEItemIDStr=$Get(%request.Data("OEItemIDStr",1),"")
	if (action = "DataPrescNoTree")
	{
  		w ..DataPrescNoTree(EpisodeID,PrescNoStr,OEItemIDStr)
  		//w ##Class(EMRservice.BL.BLBindQuery).GetRecordCategoryJson()
	}elseif (action = "TemplateTable")
	{
		w ..DataTemplateTable(219)
	}elseif (action = "PrintRecLoc")
	{
		w ..DataPrintRecLoc(219)
	}
	Quit $$$OK
}

/// /w ##Class(web.UDHCPrescriptPage).DataPrintRecLoc(75)
ClassMethod DataPrintRecLoc(UserID As %String) As %String
{
	q "[{""id"":1,""text"":""text1""},{""id"":2,""text"":""text2""},{""id"":3,""text"":""text3"",""selected"":true}]"
}

/// /w ##Class(web.UDHCPrescriptPage).DataPrescNoTree(878,"","")
ClassMethod DataPrescNoTree(EpisodeID As %String, PrescNoStr As %String, OEItemIDStr As %String) As %Boolean
{
	s ^tan("DataPrescNoTree")=EpisodeID_","_PrescNoStr_","_OEItemIDStr
	s PrescNoList=##class(web.UDHCPrescript).GetPrescNoList(EpisodeID)
	s Length=$Length(PrescNoList,"^")
	s json=""
	s MRADMID=$P(^PAADM(EpisodeID),"^",61)
	s DiagnoseList=##class(web.DHCDocDiagnosNew).GetMRDiagnoseList(MRADMID,"","")
	if (Length="")||(DiagnoseList=""){
		s json = json_"["_"{"
		s json = json_"""text"":"""_"处方列表"_""""_","
		s json = json_"""iconCls"":"""_"user-folder-open"_""""
		s json = json_"}"_"]"
		q json
	}
	//没人选中时，展示所有有数据的内容
	if (PrescNoStr="")&&(OEItemIDStr=""){
		s ID=0
		for {
			s ID=$O(^User.DHCDocPrescNoLinkDiaI("DHCDocEpisodeIDIndex"," "_EpisodeID,ID))
			q:ID=""
			s PrescNo=$List(^User.DHCDocPrescNoLinkDiaD(ID),3)
			s OEItem=$List(^User.DHCDocPrescNoLinkDiaD(ID),5)
			continue:(PrescNo="")&&(OEItem="")
			if (PrescNo'=""){
				if (PrescNoStr'=""){
					s PrescNoStr=PrescNoStr_"^"_PrescNo
				}else{
					s PrescNoStr=PrescNo
				}
			}else{
				if (OEItemIDStr'=""){
					s OEItemIDStr=OEItemIDStr_"^"_OEItem
				}else{
					s OEItemIDStr=OEItem
				}
			}
		}
	}
	s DiagLength=$length(DiagnoseList,$c(1))
	k DiagArr
	for i=1:1:DiagLength {
		s OneDiagnose=$P(DiagnoseList,$c(1),i)
		s Desc=$P(OneDiagnose,"^",1)
		s Rowid=$P(OneDiagnose,"^",2)
		s MRDesc=$P(OneDiagnose,"^",4)
		s NoteDesc=$P(OneDiagnose,"^",7)
		s MainDiagRowID=$P(OneDiagnose,"^",15)
		s NCDCode=$p($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DHC")),"^",10)
		s NCDDesc=""
		if (NCDCode'=""){
			s NCDDesc=##Class(web.DHCMRDiagnosNew).GetNCDDesc(NCDCode)
		}
		s Info=Desc_" "_" "_NoteDesc
		if (NCDDesc'=""){
			s Info=Info_"("_NCDDesc_")"
		}
		if (MainDiagRowID'=""){
			if ($D(DiagArr(MainDiagRowID))){
				s DiagArr(MainDiagRowID)=DiagArr(MainDiagRowID)_"-"_Info
			}else{
				s DiagArr(MainDiagRowID)=Info
			}
		}else{
			s DiagArr(Rowid)=Info
		}
	}
	//////New
	s result="["
	for i=1:1:$length(PrescNoStr,"^") {
		s PrescNo=$P(PrescNoStr,"^",i)
		continue:PrescNo=""
		s:(result'="[") result = result_","
		s result = result_"{"
		s result = result_"""id"":"""_PrescNo_"@"""_","
		s result = result_"""text"":""<a style='color=red;font-size:20px;height:30px'>"_PrescNo_"</a>"""_","
		s result = result_"""iconCls"":"""_"icon-tip"_""""_","
		s result = result_"""attributes"":{"
		s result = result_"""type"":"""_"Category"_""""_","
		s result = result_"""font-size"":"""_"20px"_""""
		s result = result_"}"
		s UnSelDiaSt=..GetUnSelDia(PrescNo,"")
		s children=""
		s DiaRowid="0"
		for{
			s DiaRowid=$O(DiagArr(DiaRowid))
			q:DiaRowid=""
			s Info=$G(DiagArr(DiaRowid))
			s:(children'="") children = children_","
			s CheckFlag=1
			if (UnSelDiaSt'="")&&(("@"_UnSelDiaSt_"@")[("@"_DiaRowid_"@")) s CheckFlag=0
			s children = children_"{"
			s children = children_"""id"":"""_PrescNo_"@@"_DiaRowid_"@"_CheckFlag_""""_","
			s children = children_"""text"":""<a style='font-size:20px;height:30px'>"_Info_"</a>"""_","
			//s children = children_"""attributes"":{"
			//s children = children_"""type"":"""_"Category"_""""_","
			s children = children_"""checked"":"""_CheckFlag_""""
			//s children = children_"}"
			s children = children_"}"
		}
		s result = result_",""children"":["_children_"]"
		s result = result_"}"
	}
	for i=1:1:$length(OEItemIDStr,"^") {
		s OEItemID=$P(OEItemIDStr,"^",i)
		continue:OEItemID=""
		s ARCIMDr=$P(^OEORD(+OEItemID,"I",$P(OEItemID,"||",2),1),"^",2)
		s ARCIMName=$P(^ARCIM(+ARCIMDr,$P(ARCIMDr,"||",2),1),"^",2)
		s:(result'="[") result = result_","
		s result = result_"{"
		s result = result_"""id"":""@"_OEItemID_""""_","
		s result = result_"""text"":""<a style='color=red;font-size:20px;height:30px'>"_ARCIMName_"</a>"""_","
		s result = result_"""iconCls"":"""_"icon-tip"_""""_","
		s result = result_"""attributes"":{"
		s result = result_"""type"":"""_"Category"_""""_","
		s result = result_"""font-size"":"""_"20px"_""""
		s result = result_"}"
		s UnSelDiaSt=..GetUnSelDia("",OEItemID)
		s children=""
		s DiaRowid="0"
		for{
			s DiaRowid=$O(DiagArr(DiaRowid))
			q:DiaRowid=""
			s Info=$G(DiagArr(DiaRowid))
			s:(children'="") children = children_","
			s CheckFlag=1
			if (UnSelDiaSt'="")&&(("@"_UnSelDiaSt_"@")[("@"_DiaRowid_"@")) s CheckFlag=0
			s children = children_"{"
			s children = children_"""id"":"""_"@"_OEItemID_"@"_DiaRowid_"@"_CheckFlag_""""_","
			s children = children_"""text"":""<a style='font-size:20px;height:30px'>"_Info_"</a>"""_","
			//s children = children_"""attributes"":{"
			//s children = children_"""type"":"""_"Category"_""""_","
			s children = children_"""checked"":"""_CheckFlag_""""
			//s children = children_"}"
			s children = children_"}"
		}
		s result = result_",""children"":["_children_"]"
		s result = result_"}"
	}
	s result = result_"]"
	q result
	
	
	//////Old
	/*
	s result="["
	for i=1:1:Length {
		s PrescNo=$P(PrescNoList,"^",i)
		s:(result'="[") result = result_","
		s result = result_"{"
		s result = result_"""id"":"""_PrescNo_""""_","
		s result = result_"""text"":""<a style='color=red;font-size:20px;height:30px'>"_PrescNo_"</a>"""_","
		s result = result_"""iconCls"":"""_"icon-tip"_""""_","
		s result = result_"""attributes"":{"
		s result = result_"""type"":"""_"Category"_""""_","
		s result = result_"""font-size"":"""_"20px"_""""
		s result = result_"}"
		s UnSelDiaSt=..GetUnSelDiaByPrescNo(PrescNo)
		s children=""
		s DiaRowid="0"
		for{
			s DiaRowid=$O(DiagArr(DiaRowid))
			q:DiaRowid=""
			s Info=$G(DiagArr(DiaRowid))
			s:(children'="") children = children_","
			s CheckFlag=1
			if (UnSelDiaSt'="")&&(("@"_UnSelDiaSt_"@")[("@"_DiaRowid_"@")) s CheckFlag=0
			s children = children_"{"
			s children = children_"""id"":"""_PrescNo_"@"_DiaRowid_"@"_CheckFlag_""""_","
			s children = children_"""text"":""<a style='font-size:20px;height:30px'>"_Info_"</a>"""_","
			//s children = children_"""attributes"":{"
			//s children = children_"""type"":"""_"Category"_""""_","
			s children = children_"""checked"":"""_CheckFlag_""""
			//s children = children_"}"
			s children = children_"}"
		}
		s result = result_",""children"":["_children_"]"
		s result = result_"}"
	}
	s result = result_"]"
	q result
	*/
}

/// //w ##Class(web.UDHCPrescriptPage).SetPrescNoLinkDiagnose("O16012000037@@128||2@0^O16012000037@@128||7@0^O16012000037@@128||8@0",128)
ClassMethod SetPrescNoLinkDiagnose(UploadInfo As %String, EpisodeID As %String) As %String
{
	s ^tan("SetPrescNoLinkDiagnose")=UploadInfo_"-----"_EpisodeID
	/*
	O16011500117@@75||2@1^
	O16011500117@@75||3@1^
	O16011500119@@75||1@1^
	O16011500119@@75||3@1^
	O16011500146@@75||1@1^
	O16011500146@@75||3@1^
	@65||23@75||3@1-----75
	*/
	//////--------------------new
	k PrescNoArr
	k ItemArr
	for i=1:1:$Length(UploadInfo,"^") {
		///PrescNo_"@"_OEItemID_"@"_DiaRowid_"@"_CheckFlag_
		s PrescNo=$P($P(UploadInfo,"^",i),"@",1)
		s OEItemID=$P($P(UploadInfo,"^",i),"@",2)
		s DiaRowid=$P($P(UploadInfo,"^",i),"@",3)
		continue:(PrescNo="")&&(OEItemID="")
		s DiaRowidStr=..GetGroupDiaStr(DiaRowid)
		for k=1:1:$Length(DiaRowidStr,"#"){
			s DiaRowid=$P(DiaRowidStr,"#",k)
			if (PrescNo'=""){
				if ($D(PrescNoArr(PrescNo))){
					s PrescNoArr(PrescNo)=PrescNoArr(PrescNo)_"@"_DiaRowid
				}else{
					s PrescNoArr(PrescNo)=DiaRowid
				}
			}else{
				if ($D(ItemArr(OEItemID))){
					s ItemArr(OEItemID)=ItemArr(OEItemID)_"@"_DiaRowid
				}else{
					s ItemArr(OEItemID)=DiaRowid
				}
			}
		}
	}
	b
	s PrescNo=0
	for {
		s PrescNo=$O(PrescNoArr(PrescNo))
		q:PrescNo=""
		s DiaRowidStr=$G(PrescNoArr(PrescNo))
		s RowID=$O(^User.DHCDocPrescNoLinkDiaI("DHCDocPrescNoIndex"," "_PrescNo,""),-1)
		if DiaRowidStr=""{
			if (RowID'=""){
				&Sql(delete SQLUSER.DHCDocPrescNoLinkDia where ID=:RowID)
			}
		}else{
		
			if (RowID=""){
				&Sql(Insert into SQLUSER.DHCDocPrescNoLinkDia Set DHCDoc_PrescNo=:PrescNo,DHCDoc_EpisodeID=:EpisodeID,
					DHCDoc_MRDiaStr=:DiaRowidStr)
			}else{
				&Sql(Update SQLUSER.DHCDocPrescNoLinkDia Set DHCDoc_PrescNo=:PrescNo,DHCDoc_EpisodeID=:EpisodeID,
					DHCDoc_MRDiaStr=:DiaRowidStr where ID=:RowID)
			}
		}

	}
	
	s OEItemID=0
	for {
		s OEItemID=$O(ItemArr(OEItemID))
		q:OEItemID=""
		s DiaRowidStr=$G(ItemArr(OEItemID))
		s RowID=$O(^User.DHCDocPrescNoLinkDiaI("DHCDocOEORDIndex"," "_OEItemID,""),-1)
		if DiaRowidStr=""{
			if (RowID'=""){
				&Sql(delete SQLUSER.DHCDocPrescNoLinkDia where ID=:RowID)
			}
		}else{
			if (RowID=""){
				&Sql(Insert into SQLUSER.DHCDocPrescNoLinkDia Set DHCDoc_OEORD=:OEItemID,DHCDoc_EpisodeID=:EpisodeID,
					DHCDoc_MRDiaStr=:DiaRowidStr)
			}else{
				&Sql(Update SQLUSER.DHCDocPrescNoLinkDia Set DHCDoc_OEORD=:OEItemID,DHCDoc_EpisodeID=:EpisodeID,
					DHCDoc_MRDiaStr=:DiaRowidStr where ID=:RowID)
			}
		}
	}
	
	
	q 0
	/////-------------old
	/*
	q:EpisodeID="" ""
	&sql(delete SQLUser.DHCDocPrescNoLinkDia where DHCDoc_EpisodeID=:EpisodeID)
	q:UploadInfo="" ""
	////传入的不需要关联的信息
	for i=1:1:$length(UploadInfo,"^"){
		s PrescNo=$P($P(UploadInfo,"^",i),"@",1)
		s MRDIADr=$P($P(UploadInfo,"^",i),"@",2)
		if ($D(PrescNoArr(PrescNo))){
			s PrescNoArr(PrescNo)=PrescNoArr(PrescNo)_"@"_MRDIADr
		}else{
			s PrescNoArr(PrescNo)=MRDIADr
		}
		
	}
	q:'$D(PrescNoArr) ""
	s PrescNo=""
	for {
		s PrescNo=$O(PrescNoArr(PrescNo))
		q:PrescNo=""
		s DIADRStr=$G(PrescNoArr(PrescNo))
		continue:DIADRStr=""
		&Sql(Insert into SQLUSER.DHCDocPrescNoLinkDia Set DHCDoc_PrescNo=:PrescNo,DHCDoc_EpisodeID=:EpisodeID,
			DHCDoc_MRDiaStr=:DIADRStr)
	}
	q 0
	*/
}

ClassMethod GetUnSelDiaByPrescNo(PrescNo As %String) As %String
{

	s RowID=$O(^User.DHCDocPrescNoLinkDiaI("DHCDocPrescNoIndex"," "_PrescNo,""),-1)
	q:RowID="" ""
	s UnSelDiaStr=$List(^User.DHCDocPrescNoLinkDiaD(RowID),4)
	
	q UnSelDiaStr
}

ClassMethod GetUnSelDia(PrescNo As %String, OEItemID As %String) As %String
{
	s UnSelDiaStr=""
	if (PrescNo'=""){
		s RowID=$O(^User.DHCDocPrescNoLinkDiaI("DHCDocPrescNoIndex"," "_PrescNo,""),-1)
		q:RowID="" ""
		s UnSelDiaStr=$List(^User.DHCDocPrescNoLinkDiaD(RowID),4)
	}elseif (OEItemID'=""){
		s RowID=$O(^User.DHCDocPrescNoLinkDiaI("DHCDocOEORDIndex"," "_OEItemID,""),-1)
		q:RowID="" ""
		s UnSelDiaStr=$List(^User.DHCDocPrescNoLinkDiaD(RowID),4)
	}
	q UnSelDiaStr
}

/// /w ##Class(web.UDHCPrescriptPage).GetGroupDiaStr("128||2")
ClassMethod GetGroupDiaStr(MainMRAdm As %String) As %String
{
	q:MainMRAdm="" ""
	s GroupDiaStr=MainMRAdm
	s MRADMRowId=$P(MainMRAdm,"||",1)
	s Sub=0
	for {
		s Sub=$O(^MR($P(MainMRAdm,"||",1),"DIA",0,"Link",MainMRAdm,Sub))
		q:Sub=""
		s GroupDiaStr=GroupDiaStr_"#"_$P(MainMRAdm,"||",1)_"||"_Sub
	}
	q GroupDiaStr
}

/// //根据医嘱号取诊断病种
/// w ##Class(web.UDHCPrescriptPage).GetNCDCodeByOrd("1610||56")
ClassMethod GetNCDCodeByOrd(OrdItem As %String) As %String
{
	q:OrdItem="" ""
	s NCDCodeStr=""
	s PrescNo=$P($G(^OEORD(+OrdItem,"I",$P(OrdItem,"||",2),1)),"^",14)
	s UnSelDiaStr=##Class(web.UDHCPrescriptPage).GetUnSelDia(PrescNo,OrdItem)
	s EpisodeID=$P(^OEORD(+OrdItem),"^",1)
	s MRADMID=$P(^PAADM(EpisodeID),"^",61)
	s DiagnoseList=##class(web.DHCDocDiagnosNew).GetMRDiagnoseList(MRADMID,"","")
	for i=1:1:$Length(DiagnoseList,$c(1)) {
		s Rowid=$P($P(DiagnoseList,$c(1),i),"^",2)
		continue:Rowid=""
		continue:(("@"_UnSelDiaStr_"@")[("@"_Rowid_"@"))
		s NCDCode=$p($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DHC")),"^",10)
		continue:NCDCode=""
		//s NCDDesc=##Class(web.DHCMRDiagnosNew).GetNCDDesc(NCDCode)
		if NCDCodeStr="" s NCDCodeStr=NCDCode
		else  s NCDCodeStr=NCDCodeStr_"^"_NCDCode
	}
	q NCDCodeStr
}

/// //根据医嘱号取诊断病种
/// w ##Class(web.UDHCPrescriptPage).GetNCDCodeByOrdNew("1610||56")
ClassMethod GetNCDCodeByOrdNew(OrdItem As %String) As %String
{
	q:OrdItem="" ""
	s NCDCodeStr=""
	s NCDDescStr=""
	s PrescNo=$P($G(^OEORD(+OrdItem,"I",$P(OrdItem,"||",2),1)),"^",14)
	s UnSelDiaStr=##Class(web.UDHCPrescriptPage).GetUnSelDia(PrescNo,OrdItem)
	/*
	for i=1:1:$Length(DiaStr,"@") {
		s Rowid=$P(DiaStr,"@",i)
		continue:Rowid=""
		s NCDCode=$p($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DHC")),"^",10)
		continue:NCDCode=""
		s NCDDesc=##Class(web.DHCMRDiagnosNew).GetNCDDesc(NCDCode)
		if NCDCodeStr="" s NCDCodeStr=NCDCode
		else  s NCDCodeStr=NCDCodeStr_"^"_NCDCode
		if NCDDescStr="" s NCDDescStr=NCDDesc
		else  s NCDDescStr=NCDDescStr_"^"_NCDDesc
	}
	*/
	s EpisodeID=$P(^OEORD(+OrdItem),"^",1)
	s MRADMID=$P(^PAADM(EpisodeID),"^",61)
	s DiagnoseList=##class(web.DHCDocDiagnosNew).GetMRDiagnoseList(MRADMID,"","")
	for i=1:1:$Length(DiagnoseList,$c(1)) {
		s Rowid=$P($P(DiagnoseList,$c(1),i),"^",2)
		continue:Rowid=""
		continue:(("@"_UnSelDiaStr_"@")[("@"_Rowid_"@"))
		s NCDCode=$p($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DHC")),"^",10)
		continue:NCDCode=""
		s NCDDesc=##Class(web.DHCMRDiagnosNew).GetNCDDesc(NCDCode)
		if NCDCodeStr="" s NCDCodeStr=NCDCode
		else  s NCDCodeStr=NCDCodeStr_"^"_NCDCode
		if NCDDescStr="" s NCDDescStr=NCDDesc
		else  s NCDDescStr=NCDDescStr_"^"_NCDDesc
	}
	
	
	
	q NCDCodeStr_"#"_NCDDescStr
}

/// /w ##Class(web.UDHCPrescriptPage).DataTemplateTable("128||2")
ClassMethod DataTemplateTable(TemplateID As %String) As %Boolean
{
	s json = "{"
	s json = json_"""total"":"_"1"_""_","
	s json = json_"""rows"":"_"["
	
	s json = json_"{"
	s json = json_"""RowNum"":"""_"1"_""""_","
	s json = json_"""ICDDesc1"":"""_"测试1"_""""_","
	s json = json_"""ICDDr1"":"""_"测试1"_""""_","
	s json = json_"""ICDDesc2"":"""_"测试1"_""""_","
	s json = json_"""ICDDr2"":"""_"测试1"_""""_","
	s json = json_"""ICDDesc3"":"""_"测试1"_""""_","
	s json = json_"""ICDDr3"":"""_"测试1"_""""_","
	s json = json_"""ICDDesc4"":"""_"测试1"_""""_","
	s json = json_"""ICDDr4"":"""_"测试1"_""""_","
	s json = json_"""ICDDesc5"":"""_"测试1"_""""_","
	s json = json_"""ICDDr5"":"""_"测试1"_""""
	s json = json_"}"
	
	s json = json_"]"
	s json = json_"}"
	q json
}

}

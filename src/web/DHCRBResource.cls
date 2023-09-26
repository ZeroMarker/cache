Class web.DHCRBResource Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod DepBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 k ^CacheTemp($j,"uu")	
 Set (id,code,desc)=""
 s CTDesc=""
 s yy=""
 s val=" "_val
 set RowId=0
	//f  Set RowId=$o(^User.DHCUserGroupD("RES",0,"CTLOC",val,RowId)) quit:RowId=""  d
 f  Set RowId=$o(^User.DHCUserGroupI("UserNamedr",val,RowId)) quit:RowId=""  d

 .s RId=$list(^User.DHCUserGroupD(RowId),4)
 .s Desc=$p($g(^CTLOC(RId)),"^",2)
	
 .s CTDesc=RId_"&"_Desc
 .if '$D(^CacheTemp($j,"uu",RId)) s ^CacheTemp($j,"uu",RId)=CTDesc

 s xk=0 f  Set xk=$o(^CacheTemp($j,"uu",xk)) quit:xk=""  d
 .s yy=^CacheTemp($j,"uu",xk)
 .s retval=itmjs_"('"_$ZCVT(yy,"O","JS")_"');"
 .i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(yy,"O","JS")_"');"
 .&javascript<#(retval)#>
 q 1
}

ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 Set (id,code,desc)=""
 s CTDesc=""
 s yy=""
 //set ^DHCApp=val
 set RowId=0
	f  Set RowId=$o(^RB("RES",0,"CTLOC",val,RowId)) quit:RowId=""  d

	.If ($D(^RB("RES",RowId))) do 
	..Set DocDr=$p(^RB("RES",RowId),"^",2)
	..set ScheSt=$p(^RB("RES",RowId),"^",6)
	..set desc=$p(^RB("RES",RowId),"^",17)
	..if (ScheSt'="Y") Quit
 ..s CTDesc=DocDr_"&"_desc

 ..i (yy="")  d 
 ...s yy=CTDesc
 ..e  d 
 ...s yy=yy_"^"_CTDesc
 s retval=itmjs_"('"_$ZCVT(yy,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(yy,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

/// 判断是否有复诊收费标志
ClassMethod GetEPMarkFlag(ResRowId As %String) As %String
{
	;w ##class(web.DHCRBResource).GetEPMarkFlag(5)
	set obj=##Class(User.DHCRBResource).%OpenId(ResRowId)
	set RESEPMarkFlag=obj.RESEPMarkFlag
	d obj.%Close()
	if (RESEPMarkFlag="Y") Q 1
	Q 0
}

ClassMethod GetResDocByLocId(itmjs As %Library.String = "", val As %Library.String = "", UserID As %String = "", JSON As %String = "", HospID = "")
{
	;w ##class(web.DHCRBResource).GetResDocByLocId("","13")
	s desc=""
	Set rs=##Class(%ResultSet).%New("web.DHCRBResSession:FindResDoc")
	If rs.QueryIsValid() { 
		 Set Status=rs.Execute(val,"",UserID,"","",HospID)
		 If 'Status Quit
		 While rs.Next() {
			 Set DocCode=rs.GetData(2)
			 Set DocRowid=rs.GetData(3)
			 Set DocDesc=rs.GetData(1)
			 Set ResRowid=rs.GetData(4)
			 If desc="" Set desc=ResRowid_$c(2)_DocRowid_$c(1)_DocDesc
			 Else  Set desc=desc_"^"_ResRowid_$c(2)_DocRowid_$c(1)_DocDesc
		 }
	}
	if JSON="JSON"{
		Q desc
	}else{
	Q:desc="" 1
	s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
	&javascript<#(retval)#>
	Q 1
	}
}

ClassMethod GetResLocByDocId(itmjs As %Library.String = "", docId As %String, JSON As %String = "", HospID As %String = "")
{
	Set data =""
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Do result.Prepare("select %ID,RES_CTLOC_DR->CTLOC_DESC xx,RES_CTLOC_DR from SQLUSER.RB_Resource WHERE RES_CTPCP_DR=? and RES_CTLOC_DR->CTLOC_Hospital_DR=?")
	Do result.Execute(docId,HospID)
	if (result.Next()){
	    Set data=result.GetData(1)_$C(2)_result.GetData(3)_$C(1)_result.GetData(2)
	}
	while (result.Next()){
		Set data=data_"^"_result.GetData(1)_$C(2)_result.GetData(3)_$C(1)_result.GetData(2)
	}
	if JSON="JSON"{
		Q data
	}else{
		Q:data="" 1
		s retval=itmjs_"('"_$ZCVT(data,"O","JS")_"');"
		&javascript<#(retval)#>
		Q 1
	}
}

ClassMethod GetResourceById(DocId As %String, js As %String)
{
	set reource = ##Class(User.DHCRBResource).%OpenId(DocId)
	set result =""
	if ($IsObject(reource.RESClinicGroupDR)){
		set result=reource.RESClinicGroupDR.%Id()
	}
	
	if ($IsObject(reource.RESSessionTypeDR)){
		set result=result_"^"_reource.RESSessionTypeDR.%Id()
	}else{
		set result=result_"^"_""
	}
	set result=result_"^"_reource.RESLoad
	set result=result_"^"_reource.RESAppLoad
	set result=result_"^"_reource.RESAppStartNum
	set result=result_"^"_reource.RESAddLoad
	set result=result_"^"_reource.RESDiagnosCatStr
	set result=result_"^"_reource.RESFeeType
	set result=result_"^"_reource.RESReAdmFeeFlag
	set result=result_"^"_reource.RESEPMarkFlag
	set result=result_"^"_reource.RESTimeRangeFlag
	set result=result_"^"_reource.RESTimeRangeLength
	set result=result_"^"_reource.RESTimeRangeRegNum
	set result=result_"^"_reource.RESAllowGetSeqNoFlag
	set result=result_"^"_reource.RESReAdmFeeFlag
	
	q result
 //s retval=js_"('"_$ZCVT(reource.RESClinicGroupDR.SESSDesc,"O","JS")_"');"
 // s retval= retval_"("_reource.RESClinicGroupDR.SESSDesc
 // &javascritp<#(retval)#>
}

ClassMethod GetSessionServerByParent(ParentId As %String) As %String
{
 s ^linli("parentId")= ParentId
	set str ="["
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Do result.Prepare("select SER_RowId,Ser_arcim_dr->arcim_desc arcim_desc  from SQLUSER.DHC_RBCSessionTypeService where SER_ParRef=?")
	Do result.Execute(ParentId)
	if (result.Next())
	{
		;set str=str_result.Data("SER_RowId")_"^"_result.Data("arcim_desc")
		set str=str_"'"_result.GetData(1)_"^"_result.GetData(2)_"'"
	}
	For  Quit:'result.Next()  Do
	.Set str=str_",'"_result.GetData(1)_"^"_result.GetData(2)_"'"

	set str=str_"]"
	q str
}

ClassMethod RBResourceServerDelete(Info As web.DHCEntity.PCA.DHCRBCSessionTypeService) As %String
{
 TStart
 set sc= ##class(User.DHCRBCSessionTypeService).%DeleteId(Info.ID)

 If $$$ISERR(sc) {
 Do $System.Status.DisplayError()
 Trollback
 Quit -100
 }
 TCommit
 quit 0
}

ClassMethod RBResourceServerSave(Info As web.DHCEntity.PCA.DHCRBCSessionTypeService) As %String
{
 TStart
 	if (+Info.ID>0){
		set object=##class(User.DHCRBCSessionTypeService).%OpenId(Info.ID)
	}else{
		set object=##class(User.DHCRBCSessionTypeService).%New(Info.SERParRef)
	}
	//set ^linli("ddd")=Info.SERRBCServiceDR
	//if (Info.SERRBCServiceDR'="")&&(Info.SERRBCServiceDR'=$C(0))
	//{
		//set ^linli("ddd1")=Info.SERRBCServiceDR
		set object.SERParRef =Info.SERParRef
		if (Info.SERRBCServiceDR'="") do object.SERARCIMDRSetObjectId(Info.SERRBCServiceDR)
		d object.SERHospDRSetObjectId(Info.HospID)
		set object.SERType =Info.SERType
		if (Info.SERDiagnoseDr'=""){
			d object.SERDiagnoseDrSetObjectId(Info.SERDiagnoseDr)
			}
	//}
	set sc=object.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError(sc)
		Trollback
		Quit -100
	}
	TCommit
	quit object.%Id()
}

ClassMethod RBResourceUpdate(RBResourceInfo As web.DHCEntity.PCA.RBResource) As %String
{
 TStart
 set object=##class(User.DHCRBResource).%OpenId(RBResourceInfo.ID)

 if (RBResourceInfo.RESClinicGroupDR'="")**(RBResourceInfo.RESClinicGroupDR'=$C(0))
 {
 do object.RESClinicGroupDRSetObjectId(RBResourceInfo.RESClinicGroupDR)
 }
 if (RBResourceInfo.RESSessionTypeDR'="")&&(RBResourceInfo.RESSessionTypeDR'=$C(0))
 {
 do object.RESSessionTypeDRSetObjectId(RBResourceInfo.RESSessionTypeDR)
 }
 set object.RESLoad =RBResourceInfo.RESLoad
 set object.RESAppLoad =RBResourceInfo.RESAppLoad
 set object.RESAppStartNum =RBResourceInfo.RESAppStartNum
 set object.RESAddLoad =RBResourceInfo.RESAddLoad
 set object.RESDiagnosCatStr =RBResourceInfo.RESDiagnosCatStr
 set object.RESFeeType =RBResourceInfo.RESFeeType
 set object.RESReAdmFeeFlag=RBResourceInfo.RESReAdmFeeFlag
 set object.RESEPMarkFlag=RBResourceInfo.RESEPMarkFlag
 ;set object.RESTimeRangeFlag =RBResourceInfo.RESTimeRangeFlag
 ;set object.RESTimeRangeLength=RBResourceInfo.RESTimeRangeLength
 ;set object.RESTimeRangeRegNum=RBResourceInfo.RESTimeRangeRegNum
 set object.RESAllowGetSeqNoFlag=RBResourceInfo.RESAllowGetSeqNoFlag
 set sc=object.%Save()
 If $$$ISERR(sc) {
 Do $System.Status.DisplayError()
 Trollback
 Quit -100
 }
 TCommit
 quit object.%Id()
}

ClassMethod docBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", gr As %Library.String = "")
{
 k ^CacheTemp2($j,"mm")	
 Set (id,code,desc)=""
 s CTDesc=""
 s yy=""
 //s ^yyyy=val_"!"_gr
 s val=" "_val
 set RowId=0
 f  Set RowId=$o(^User.DHCUserGroupI("UserNamedr",val,RowId)) quit:RowId=""  d
 .s RId=$list(^User.DHCUserGroupD(RowId),4)
 .i gr=RId d
 ..s usid=$list(^User.DHCUserGroupD(RowId),2)
 ..s Desc=$p($g(^CTLOC(usid)),"^",2)
 ..s CTDesc=usid
 ..if '$D(^CacheTemp2($j,"mm",usid)) s ^CacheTemp2($j,"mm",usid)=CTDesc
 s xk=0 f  Set xk=$o(^CacheTemp2($j,"mm",xk)) quit:xk=""  d
 .s yy=^CacheTemp2($j,"mm",xk)
 .s retval=itmjs_"('"_$ZCVT(yy,"O","JS")_"');"
 .i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(yy,"O","JS")_"');"
 .&javascript<#(retval)#>
 q 1
}

Query RbResourceQuery() As %SQLQuery(CONTAINID = 1, ROWSPEC = "TRESSessionTypeDR:%String,TRESSessionType:%String,TRESClinicGroupDR:%String,TRESClinicGroup:%String,TID:%String")
{
 select RES_SessionType_DR, RES_SessionType_DR->SESS_Desc,RES_ClinicGroup_DR,RES_ClinicGroup_DR->CLGRP_Desc,RES_RowId from SQLUser.DHC_RBResource
}

Query UFind(depid) As %SQLQuery(CONTAINID = 1, ROWSPEC = "RES_CTPCP_DR:%Integer,RES_CTPCP_DR->CTPCP_Desc:%String")
{
SELECT RES_CTPCP_DR,RES_CTPCP_DR->CTPCP_Desc 
FROM SQLUser.RB_RESOURCE
WHERE (RES_CTLOC_DR = :depid 
and (res_schedulerequired='Yes' or res_schedulerequired='Y'))
}

Query UFindjz() As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTLOC_Desc:%String,aa:%Integer,bb:%Integer")
{
SELECT CTLOC_Desc,Count(*),SUM(RegfeeArcPrice) from
SQLUser.CT_Loc,SQLUser.DHCRegistrationFee,SQLUser.PA_Adm 
where SQLUser.DHCRegistrationFee.RegfeeArcDr=SQLUser.CT_Loc.CTLOC_Rowid
and SQLUser.DHCRegistrationFee.RegfeeAdmDr=PAADM_Rowid and PAADM_CreateUser='4365' 
and PAADM_AdmDate='2005-06-15'
group by CTLOC_Desc
}

Query newFind(depid, docid) As %SQLQuery(CONTAINID = 1, ROWSPEC = "RES_CTPCP_DR:%Integer,RES_CTPCP_DR->CTPCP_Desc:%String")
{
SELECT RES_CTPCP_DR,RES_CTPCP_DR->CTPCP_Desc 
FROM SQLUser.RB_RESOURCE
WHERE (RES_CTLOC_DR = :depid and RES_CTPCP_DR=:docid
)
}

ClassMethod GetTimeRangeResourceById(DocId As %String, TimeRangeDR As %String)
{
	
	s RESTRowId="",rtn=""
	f  s RESTRowId=$o(^RB("RES",DocId,"REST",RESTRowId)) q:(RESTRowId="")||(rtn'="")  d
	.s RESTTimeRangeDR=$p(^RB("REST",RESTRowId),"^",2)
	.q:RESTTimeRangeDR'=TimeRangeDR
	.s rtn=$g(^RB("REST",RESTRowId))
	q rtn
}

ClassMethod TRRBResourceServerSave(Infostr As %String) As %String
{
	 s ^tempscl("TRRBResourceServerSave")=Infostr
	 s RESRowId=$p(Infostr,"^",1)
	 s TimeRangeRowId=$p(Infostr,"^",2)
	 s ASLoad=$p(Infostr,"^",3)
	 s AppLoad=$p(Infostr,"^",4)
	 s AppStartNum=$p(Infostr,"^",5)
	 s AutoLoad=$p(Infostr,"^",6)
	 s ExtLoad=$p(Infostr,"^",7)
	 s RESTRowId=""
	 &sql(select REST_RowId into:RESTRowId from SQLUser.DHC_RBResourceTR where REST_TimeRange_DR=:TimeRangeRowId and REST_Resource_DR=:RESRowId)
	 TStart
	 if (RESTRowId=""){
		 set object=##class(User.DHCRBResourceTR).%New()
	 }else{
		 set object=##class(User.DHCRBResourceTR).%OpenId(RESTRowId)
	 }
	 do object.RESTResourceDRSetObjectId(RESRowId)
	 do object.RESTTimeRangeDRSetObjectId(TimeRangeRowId)
	 set object.RESTLoad =ASLoad
	 set object.RESTAppLoad =AppLoad
	 set object.RESTAppStartNum =AppStartNum
	 set object.RESTAutoLoad =AutoLoad
	 set object.RESTExtLoad=ExtLoad
	 set sc=object.%Save()
	 If $$$ISERR(sc) {
		 Do $System.Status.DisplayError()
		 Trollback
		 Quit -100
	 }
	 TCommit
	 quit object.%Id()
}

/*Query QuerySessionServer(SerParRef,HospID) As %SQLQuery(CONTAINID = 1, ROWSPEC = "SERRowId:%String,ARCIMDR:%String,ARCITMDesc:%String")
{
	SELECT SER_RowId,SER_ARCIM_DR,SER_ARCIM_DR->ARCIM_Desc
	FROM SQLUser.DHC_RBCSessionTypeService
	WHERE (SER_ParRef = :SerParRef)
}*/
/// d ##class(%ResultSet).RunQuery("web.DHCRBResource","QuerySessionServer",1,"2","OrderDiag")
Query QuerySessionServer(SerParRef, HospID As %String = "", Type As %String = "OrderNorm") As websys.Query(ROWSPEC = "SERRowId:%String,ARCIMDR:%String,ARCITMDesc:%String,OtherAdmReason :%String,MRCDIADR:%String,MRCDIADesc:%String ")
{
}

ClassMethod QuerySessionServerExecute(ByRef qHandle As %Binary, SerParRef, HospID As %String = "", Type As %String = "OrderNorm") As %Status
{
	Set repid=$I(^CacheTemp)
    Set ind=1
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    s SERChildsub=0
    for {
	    s SERChildsub=$o(^RBC("SESS",SerParRef,"SER",SERChildsub)) Q:SERChildsub=""
	    s HospDR=$p(^RBC("SESS",SerParRef,"SER",SERChildsub),"^",2)
	    continue:(HospDR'="")&&(HospDR'=HospID)
	    s ARCIMDR=$p(^RBC("SESS",SerParRef,"SER",SERChildsub),"^",1)
	    continue:((ARCIMDR'="")&&(##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ARCIMDR,HospID)="N"))
	    s SESSType=$p(^RBC("SESS",SerParRef,"SER",SERChildsub),"^",3)
	    continue:(((SESSType="")&&(Type'="OrderNorm"))||((SESSType'="")&&(Type'=SESSType)))
	    s MRCDIADR=$p(^RBC("SESS",SerParRef,"SER",SERChildsub),"^",4)
	    s MRCDIADesc=""
	    if MRCDIADR'="" s MRCDIADesc=$p(^MRC("ID",MRCDIADR),"^",2)
	    s SERRowId=SerParRef_"||"_SERChildsub
	    s ARCITMDesc=""
	    if ARCIMDR'="" s ARCITMDesc=$p(^ARCIM(+ARCIMDR,1,1),"^",2)
	    s OtherAdmReason=""
	    s sub=0
	    for {
	    	s sub=$O(^RBC("SESS",SerParRef,"SER",SERChildsub,"AdmReason",sub))
	    	q:(sub="")
	    	s AdmReasonDr=^(sub)
	    	continue:(AdmReasonDr="")
	    	s AdmReason=$P(^PAC("ADMREA",AdmReasonDr),"^",2)
	    	if (OtherAdmReason=""){
		    	s OtherAdmReason=AdmReason
		    }else{
				s OtherAdmReason=OtherAdmReason_","_AdmReason
			}
	    }
	    d OutPutRow1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow1
	set Data=$lb($g(SERRowId),$g(ARCIMDR),ARCITMDesc,OtherAdmReason,MRCDIADR,MRCDIADesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCRBResource","FindAdmReason","1||26")
Query FindAdmReason(SERRowId As %String, HospID As %String = "") As websys.Query(ROWSPEC = "AdmReason:%String,AdmReasonDesc:%String,SelFlag:%Boolean")
{
}

ClassMethod FindAdmReasonExecute(ByRef qHandle As %Binary, SERRowId As %String, HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    Set ind=1
    s EXCludeAdmReasonList=..GetEXCludeAdmReasonList(SERRowId)
    s AdmReason=0
    for {
		s AdmReason=$O(^PAC("ADMREA",AdmReason))
		q:(AdmReason="")
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("PAC_AdmReason",AdmReason,HospID)="N"
		s AdmReasonDesc=$P(^PAC("ADMREA",AdmReason),"^",2)
		s READateFrom=$P(^PAC("ADMREA",AdmReason),"^",3)
		continue:(READateFrom'="")&&(READateFrom>+$h)
		s READateTo=$P(^PAC("ADMREA",AdmReason),"^",4)
		continue:(READateTo'="")&&(READateTo<+$h)
		s SelFlag=0
		if EXCludeAdmReasonList[("^"_AdmReason_"^"){
			s SelFlag=1
		}
		d OutputRowFindAdmReason
	}
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindAdmReason
	set Data=$lb($g(AdmReason),$g(AdmReasonDesc),$g(SelFlag))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// /w ##Class(web.DHCRBResource).InsertSEREXCludeAdmReason("1||26","1^2^3^4^5^6^7^8")
ClassMethod InsertSEREXCludeAdmReason(SERRowId As %String, EXCludeAdmReasonStr As %String) As %String
{
	set object=##class(User.DHCRBCSessionTypeService).%OpenId(SERRowId)
	if ($IsObject(object)){
		d object.SEREXCludeAdmReason.Clear()
		for i=1:1:$Length(EXCludeAdmReasonStr,"^"){
			d object.SEREXCludeAdmReason.InsertObjectId($P(EXCludeAdmReasonStr,"^",i))
		}
		d object.%Save()
		d object.%Close()
	}
	q 0
}

ClassMethod GetEXCludeAdmReasonList(SERRowId As %String) As %String
{
	s EXCludeAdmReasonList=""
    s sub=0
    for {
    	s sub=$O(^RBC("SESS",$P(SERRowId,"||",1),"SER",$P(SERRowId,"||",2),"AdmReason",sub))
    	q:(sub="")
    	s AdmReasonDr=^(sub)
    	continue:(AdmReasonDr="")
    	if (EXCludeAdmReasonList=""){
	    	s EXCludeAdmReasonList=AdmReasonDr
	    }else{
			s EXCludeAdmReasonList=EXCludeAdmReasonList_"^"_AdmReasonDr
		}
    }
    i EXCludeAdmReasonList'="" s EXCludeAdmReasonList="^"_EXCludeAdmReasonList_"^"
    q EXCludeAdmReasonList
}

ClassMethod FindResLocOrDocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindResLocOrDocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCRBResource","FindResLocOrDoc","14","Loc","")
ClassMethod FindResLocOrDocExecute(ByRef QHandle As %Binary, InputID As %String, Type As %String, UserID As %String = "", Group As %String = "", MarkCodeName As %String = "", HospID As %String) As %Status
{
	s ^tmpnk("FindResLocOrDocExecute")=InputID_","_Type
	Set repid=$I(^CacheTemp)
	
	if (InputID=""){
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s ind=1
	if Type="Loc"{
		s ret=..GetResDocByLocId("",InputID,UserID,"JSON",HospID)	
	}elseif Type="Doc"{
		s ret=..GetResLocByDocId("",InputID,"JSON",HospID)	
	}
	if ret'=""{
		s retlen=$l(ret,"^")
		for myic=1:1:retlen{
			d ResetVariables1
			s oneret=$p(ret,"^",myic)
			s RowId=$p(oneret,$c(1),1)
			if (Type="Doc") {
				s LocId=$p(RowId,$c(2),2)
				continue:('$d(^PAC("ADMLOC",0,"AdmType","O",LocId)))&&('$d(^PAC("ADMLOC",0,"AdmType","E",LocId)))
			}
			s RowId=$tr(RowId,$c(2),"@")
			s DocDesc=$p(oneret,$c(1),2)
			s DocDescPY=##class(web.DHCINSUPort).GetCNCODE(DocDesc,4,"")
			s OutputBeforeSort(DocDescPY,RowId)=DocDesc
			
		}
	}
	s DocDescPY=""
	f  s DocDescPY=$o(OutputBeforeSort(DocDescPY)) q:DocDescPY=""  d
	.s RowId=""
	.f  s RowId=$o(OutputBeforeSort(DocDescPY,RowId)) q:RowId=""  d
	..s DocDesc=OutputBeforeSort(DocDescPY,RowId)
	..d OutputRow1
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(DocDesc,RowId)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables1
	set (DocDesc,RowId)=""
	quit
}

ClassMethod FindResLocOrDocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindResLocOrDocExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindResLocOrDoc(InputID As %String, Type As %String, UserID As %String = "", Group As %String = "", MarkCodeName As %String = "", HospID As %String = "") As %Query(ROWSPEC = "Desc:%String,RowID:%String") [ SqlProc ]
{
}

Query SeviceQuery(RegServiceGroupRowId As %String, HospID As %String = "") As websys.Query(ROWSPEC = "ID:%String,Desc:%String,Price:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCRBResource","SeviceQuery","8","2")
ClassMethod SeviceQueryExecute(ByRef qHandle As %Binary, RegServiceGroupRowId As %String, HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s AdmReason=$O(^PAC("ADMREA",0))
	set rs=##class(%ResultSet).%New("web.DHCBL.BaseReg.BaseDataQuery:SeviceQuery") 
	d rs.Execute(RegServiceGroupRowId,HospID)
	Set columns = rs.GetColumnCount()
	If $SYSTEM.Status.IsOK(rs){
		while (rs.Next()){
			s ID=rs.GetData(1)
			s Desc=rs.GetData(2)
			s Price=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("",AdmReason,ID,+$H,"","","","",HospID,""),"^",4)
			s Price=$FN(Price,"",2)
			d OutPutRow2
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow2
	set Data=$lb($g(ID),$g(Desc),$G(Price))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

}

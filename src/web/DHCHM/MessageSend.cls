Class web.DHCHM.MessageSend Extends Abstract [ Not ProcedureBlock ]
{

//查找用户	

//d ##class(%ResultSet).RunQuery("web.DHCHM.MessageSend","GetUser")

Query GetUser() As %Query(ROWSPEC = "ID:%String:ID,BIAddDate:%String:BIAddDate,BIAddTime:%String:BIAddTime,BIAddUserDR:%String:BIAddUserDR,SSUSRName:%String:SSUSRName,BIAddress:%String:BIAddress,BICCertificateTypeDR:%String:BICCertificateTypeDR,CTDesc:%String:CTDesc,BICEducationDR:%String:BICEducationDR,CTDesc:%String:CTDesc,BICMaritalDR:%String:BICMaritalDR,CTDesc:%String:CTDesc,BICNationDR:%String:BICNationDR,CTDesc:%String:CTDesc,BICOccupationDR:%String:BICOccupationDR,CTDesc:%String:CTDesc,BICServiceClassDR:%String:BICServiceClassDR,SCDesc:%String:SCDesc,BICSexDR:%String:BICSexDR,CTDesc:%String:CTDesc,BICUserGroupDR:%String:BICUserGroupDR,CTDesc:%String:CTDesc,BICUserTypeDR:%String:BICUserTypeDR,CTDesc:%String:CTDesc,BICity:%String:BICity,BICode:%String:BICode,BICompany:%String:BICompany,BIDOB:%String:BIDOB,BIDocDR:%String:BIDocDR,SSUSRName:%String:SSUSRName,BIEmail:%String:BIEmail,BIHMDR:%String:BIHMDR,SSUSRName:%String:SSUSRName,BIHospWebsite:%String:BIHospWebsite,HOSPDesc:%String:HOSPDesc,BIIDCard:%String:BIIDCard,BIInputCode:%String:BIInputCode,BILocDR:%String:BILocDR,CTLOCDesc:%String:CTLOCDesc,BIMobilePhone:%String:BIMobilePhone,BIName:%String:BIName,BIPAPMINo:%String:BIPAPMINo,BIPassWord:%String:BIPassWord,BIPostCode:%String:BIPostCode,BIRemark:%String:BIRemark,BITel:%String:BITel")
{
}

ClassMethod GetUserExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=0
	f  s ID=$o(^User.DHCHMOBaseInfoD(ID))  quit:ID=""  d
	.d BuildDataGetUser
	Quit $$$OK
BuildDataGetUser
	d ResetVariablesGetUser
	s obj=##class(User.DHCHMOBaseInfo).%OpenId(ID)
	s BIAddDate = ..TransDateToPage(obj.BIAddDate,3)
	s BIAddTime = obj.BIAddTime
	i $ISOBJECT(obj.BIAddUserDR) d
	.s BIAddUserDR = obj.BIAddUserDR.%Id()
	.i BIAddUserDR '= "" d
	..s SSUSRName=obj.BIAddUserDR.SSUSRName
	s BIAddress = obj.BIAddress
	i $ISOBJECT(obj.BICCertificateTypeDR) d
	.s BICCertificateTypeDR = obj.BICCertificateTypeDR.%Id()
	.i BICCertificateTypeDR '= "" d
	..s CTDesc=obj.BICCertificateTypeDR.CTDesc
	i $ISOBJECT(obj.BICEducationDR) d
	.s BICEducationDR = obj.BICEducationDR.%Id()
	.i BICEducationDR '= "" d
	..s CTDesc=obj.BICEducationDR.CTDesc
	i $ISOBJECT(obj.BICMaritalDR) d
	.s BICMaritalDR = obj.BICMaritalDR.%Id()
	.i BICMaritalDR '= "" d
	..s CTDesc=obj.BICMaritalDR.CTDesc
	i $ISOBJECT(obj.BICNationDR) d
	.s BICNationDR = obj.BICNationDR.%Id()
	.i BICNationDR '= "" d
	..s CTDesc=obj.BICNationDR.CTDesc
	i $ISOBJECT(obj.BICOccupationDR) d
	.s BICOccupationDR = obj.BICOccupationDR.%Id()
	.i BICOccupationDR '= "" d
	..s CTDesc=obj.BICOccupationDR.CTDesc
	i $ISOBJECT(obj.BICServiceClassDR) d
	.s BICServiceClassDR = obj.BICServiceClassDR.%Id()
	.i BICServiceClassDR '= "" d
	..s SCDesc=obj.BICServiceClassDR.SCDesc
	i $ISOBJECT(obj.BICSexDR) d
	.s BICSexDR = obj.BICSexDR.%Id()
	.i BICSexDR '= "" d
	..s CTDesc=obj.BICSexDR.CTDesc
	i $ISOBJECT(obj.BICUserGroupDR) d
	.s BICUserGroupDR = obj.BICUserGroupDR.%Id()
	.i BICUserGroupDR '= "" d
	..s CTDesc=obj.BICUserGroupDR.CTDesc
	i $ISOBJECT(obj.BICUserTypeDR) d
	.s BICUserTypeDR = obj.BICUserTypeDR.%Id()
	.i BICUserTypeDR '= "" d
	..s CTDesc=obj.BICUserTypeDR.CTDesc
	s BICity = obj.BICity
	s BICode = obj.BICode
	s BICompany = obj.BICompany
	s BIDOB = ..TransDateToPage(obj.BIDOB,3)
	i $ISOBJECT(obj.BIDocDR) d
	.s BIDocDR = obj.BIDocDR.%Id()
	.i BIDocDR '= "" d
	..s SSUSRName=obj.BIDocDR.SSUSRName
	s BIEmail = obj.BIEmail
	i $ISOBJECT(obj.BIHMDR) d
	.s BIHMDR = obj.BIHMDR.%Id()
	.i BIHMDR '= "" d
	..s SSUSRName=obj.BIHMDR.SSUSRName
	i $ISOBJECT(obj.BIHospWebsite) d
	.s BIHospWebsite = obj.BIHospWebsite.%Id()
	.i BIHospWebsite '= "" d
	..s HOSPDesc=obj.BIHospWebsite.HOSPDesc
	s BIIDCard = obj.BIIDCard
	s BIInputCode = obj.BIInputCode
	i $ISOBJECT(obj.BILocDR) d
	.s BILocDR = obj.BILocDR.%Id()
	.i BILocDR '= "" d
	..s CTLOCDesc=obj.BILocDR.CTLOCDesc
	s BIMobilePhone = obj.BIMobilePhone
	s BIName = obj.BIName
	s BIPAPMINo = obj.BIPAPMINo
	s BIPassWord = obj.BIPassWord
	s BIPostCode = obj.BIPostCode
	s BIRemark = obj.BIRemark
	s BITel = obj.BITel
	d OutputRowGetUser
	quit
OutputRowGetUser
	s Data=$lb(ID,BIAddDate,BIAddTime,BIAddUserDR,SSUSRName,BIAddress,BICCertificateTypeDR,CTDesc,BICEducationDR,CTDesc,BICMaritalDR,CTDesc,BICNationDR,CTDesc,BICOccupationDR,CTDesc,BICServiceClassDR,SCDesc,BICSexDR,CTDesc,BICUserGroupDR,CTDesc,BICUserTypeDR,CTDesc,BICity,BICode,BICompany,BIDOB,BIDocDR,SSUSRName,BIEmail,BIHMDR,SSUSRName,BIHospWebsite,HOSPDesc,BIIDCard,BIInputCode,BILocDR,CTLOCDesc,BIMobilePhone,BIName,BIPAPMINo,BIPassWord,BIPostCode,BIRemark,BITel)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetUser
	s (BIAddDate,BIAddTime,BIAddUserDR,SSUSRName,BIAddress,BICCertificateTypeDR,CTDesc,BICEducationDR,CTDesc,BICMaritalDR,CTDesc,BICNationDR,CTDesc,BICOccupationDR,CTDesc,BICServiceClassDR,SCDesc,BICSexDR,CTDesc,BICUserGroupDR,CTDesc,BICUserTypeDR,CTDesc,BICity,BICode,BICompany,BIDOB,BIDocDR,SSUSRName,BIEmail,BIHMDR,SSUSRName,BIHospWebsite,HOSPDesc,BIIDCard,BIInputCode,BILocDR,CTLOCDesc,BIMobilePhone,BIName,BIPAPMINo,BIPassWord,BIPostCode,BIRemark,BITel)=""
	quit
}

ClassMethod GetUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//筛选用户

//d ##class(%ResultSet).RunQuery("web.DHCHM.MessageSend","FindBaseInfoByType","","","4")

Query FindBaseInfoByType(VStartDate As %String = "", VEndDate As %String = "", HCId As %String = "") As %Query(ROWSPEC = "OQEId:%String,vBIPAPMINo:%String,vName:%String,SexDesc:%String,Date:%String,EducationDesc:%String,MaritalDesc:%String,vMobilePhone:%String")
{
}

ClassMethod FindBaseInfoByTypeExecute(ByRef qHandle As %Binary, VStartDate As %String = "", VEndDate As %String = "", HCId As %String = "") As %Status
{
 	new repid, index,ID
 	k ^ypp
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s VStartDate=..TransDateToDB(VStartDate)
	s VEndDate=..TransDateToDB(VEndDate)
	i (VStartDate="")&&(VEndDate="") d
	.s VStartDate=+$H-30
	.s VEndDate=+$H
	i VStartDate="" s VStartDate=0
	i VEndDate="" s VEndDate=+$H
	s Date=VStartDate-1
	f  s Date=$o(^User.DHCHMOQEQuestionI("QEQAddDateIndex",Date)) q:(Date="")||(Date>VEndDate)  d
	.s OERId=0
	.f  s OERId=$o(^User.DHCHMOQEQuestionI("QEQAddDateIndex",Date,OERId)) q:OERId=""  d
	..s OERobj=##class(User.DHCHMOEvaluationRecord).%OpenId(OERId)
	..s OBIobj=OERobj.QOBaseInfoDR
	..s EducationDesc=OERobj.QCEducationDR.CTDesc
	..s MaritalDesc=OERobj.QCMaritalDR.CTDesc
	..s Sub=0
	..f  s Sub=$o(^User.DHCHMOQEQuestionI("QEQAddDateIndex",Date,OERId,Sub)) q:Sub=""  d
	...s OQEId=OERId_"||"_Sub
	...s OQEobj=##class(User.DHCHMOQEQuestion).%OpenId(OQEId)
	...s HCDR=""
	...i $ISOBJECT(OQEobj.QEQCHumanClassDR) d
	....s HCDR=OQEobj.QEQCHumanClassDR.%Id()
	...q:HCDR=""
	...q:(HCId'="")&&(HCDR'="")&&(HCId'=HCDR)
	...d BuildDataFindBaseInfoByType
	Quit $$$OK
BuildDataFindBaseInfoByType
    s OQEId=OBIobj.%Id()
	s vName=OBIobj.BIName
	s vBIPAPMINo=OBIobj.BIPAPMINo
	i $ISOBJECT(OBIobj.BICSexDR) d
	.s SexDR=OBIobj.BICSexDR.%Id()
	.i SexDR'="" d
	..s SexDesc=OBIobj.BICSexDR.CTDesc
	s vDate=$zd(Date,3)
	s vMobilePhone=OBIobj.BIMobilePhone
	d OutputRowFindBaseInfoByType
	quit
OutputRowFindBaseInfoByType
	s Data=$lb(OQEId,vBIPAPMINo,vName,SexDesc,vDate,EducationDesc,MaritalDesc,vMobilePhone)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod FindBaseInfoByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBaseInfoByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBaseInfoByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBaseInfoByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//得到发送记录------------------------------------------------

//d ##class(%ResultSet).RunQuery("web.DHCHM.MessageSend","FindRecord","","","")

Query FindRecord(VStartDate As %String = "", VEndDate As %String = "", HCId As %String = "") As %Query(ROWSPEC = "OQEId:%String,vBIPAPMINo:%String,vName:%String,SexDesc:%String,Date:%String,EducationDesc:%String,MaritalDesc:%String,vMobilePhone,vResult,vMessage:%String")
{
}

ClassMethod FindRecordExecute(ByRef qHandle As %Binary, VStartDate As %String = "", VEndDate As %String = "", HCId As %String = "") As %Status
{
 		new repid, index,ID,OERId,OQEobj,MESobj,OBIobj,Date
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
    //^User.DHCHMOMessageSendDetailI("MSDStatusIndex"," F",342,993)
	s OERId=0
	f  s OERId=$o(^User.DHCHMOMessageSendDetailI("MSDStatusIndex",HCId,OERId)) q:OERId=""   d
	.s Sub=0
	.f  s Sub=$o(^User.DHCHMOMessageSendDetailI("MSDStatusIndex",HCId,OERId,Sub)) q:Sub=""  d
	..s OQEId=OERId_"||"_Sub
	..//w OQEId
	..//w OQEobj.MSDSourceID
	..s MESobj=##class(User.DHCHMOMessageSendMain).%OpenId(OERId) 
	..s OQEobj=##class(User.DHCHMOMessageSendDetail).%OpenId(OQEId)
	..s Date=OQEobj.MSDSendDate
	..s OBIobj=##class(User.DHCHMOBaseInfo).%OpenId(OQEobj.MSDSourceID)
	..//w OBIobj.BIName
	..d BuildDataFindRecorde
	Quit $$$OK
BuildDataFindRecorde
	s vName=OBIobj.BIName
	s vBIPAPMINo=OBIobj.BIPAPMINo
	i $ISOBJECT(OBIobj.BICSexDR) d
	.s SexDR=OBIobj.BICSexDR.%Id()
	.i SexDR'="" d
	..s SexDesc=OBIobj.BICSexDR.CTDesc
	s vDate=$zd(Date,3)
	s vMobilePhone=OQEobj.MSDMobileTelephone
	s vResult=OQEobj.MSDStatus
	s vMessage=MESobj.MSMMessageDetail
	d OutputRowFindRecorde
	quit
OutputRowFindRecorde
	s Data=$lb(OQEId,vBIPAPMINo,vName,SexDesc,vDate,EducationDesc,MaritalDesc,vMobilePhone,vResult,vMessage)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod FindRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBaseInfoByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBaseInfoByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//保存杂志发送记录-----------------------------------------------------------------------------

//w ##class(web.DHCHM.MessageSend).CMagazineSendSaveData("1^^1","2^3")

ClassMethod CMagazineSendSaveData(valueStr As %String, SendList As %String) As %String
{
    //n (rr,rr2,propertyStr,length)
   //保存主表
   	s propertyStr="MSMMagazineDR^MSMRemark^MSMSendUser^MSMSendDate^MSMSendTime"
	//s valueStr="2^vvv^2^11111^11111"
	s valueStr=valueStr_"^"_$p($h,",",1)_"^"_$p($h,",",2)
	
  Tstart 	
	s rr=##class(User.DHCHMOMagazineSendMain).SaveData("",valueStr,propertyStr)
	
  if +rr<0 {   
    TROLLBACK
    q rr
 }
 	
	//w rr,!
   //保存明细表	
   s propertyStr="MSDParRef^MSDSourceID^MSDSourceType"
   //s SendList="1^2^3^6^8^12"
   s length=$length(SendList,"^")
   //w length,!
   
   for i=1:1:length 
   {
	   s tempstr=$p(SendList,"^",i)
	   s valueStr=rr_"^"_tempstr_"^"_"60010001"
	   //w valueStr,!
	   s rr2=##class(User.DHCHMOMagazineSendDetail).SaveData("",valueStr,propertyStr)
   }
  if +rr2<0 {
    TROLLBACK
 }else{ 
    Tcommit}
   
   quit rr2
}

//保存 短信发送记录

//w ##class(web.DHCHM.MessageSend).CMessageSendSaveData("短信内容^备注^2","1||1^^F#2||2^13001909677^F#3||3^13910299677^S")

ClassMethod CMessageSendSaveData(valueStr As %String, SendList As %String) As %String
{
    //n (rr,rr2,propertyStr,length)
   //保存主表

	s propertyStr="MSMMessageDetail^MSMRemark^MSMCreateUser^MSMSendDate^MSMSendTime"
   
	//s valueStr="短信内容^备注^2"
	s valueStr=valueStr_"^"_$p($h,",",1)_"^"_$p($h,",",2)
	//w valueStr
  Tstart 	
	s rr=##class(User.DHCHMOMessageSendMain).SaveData("",valueStr,propertyStr)
	//w rr
  if +rr<0 {   
    TROLLBACK
    q rr
 }
 	//w rr,!
   //保存明细表	

  s propertyStr="MSDParRef^MSDSourceID^MSDMobileTelephone^MSDStatus^MSDSendDate^MSDSendTime^MSDSourceType"
   //s SendList="6^8^12"
   s length=$length(SendList,"#")
   //w length,!
   
   for i=1:1:length 
   {
	   s tempstr=$p(SendList,"#",i)
	   s valueStr=rr_"^"_tempstr_"^"_$p($h,",",1)_"^"_$p($h,",",2)_"^70010001"
	   //w valueStr,!
	   s rr2=##class(User.DHCHMOMessageSendDetail).SaveData("",valueStr,propertyStr)
	   if +rr2<0 {break}
   }
   
  if +rr2<0 {
    TROLLBACK
 }else{ 
    Tcommit}
   
  quit rr2
}

//得到是否马上发送

//w ##class(web.DHCHM.MessageSend).GetUserCode()

ClassMethod GetUserCode() As %String
{
	n id,obj,tmp // 设置以上变量为局部变量（不设置会影响方法外同名变量）
 	// ^User.DHCHMCSettingI("SCodeIndex"," 90010003",146)
 	s id=$O(^User.DHCHMCSettingI("SCodeIndex"," 90010003",0))
    s obj=##class(User.DHCHMCSetting).%OpenId(id)
 	q obj.SValue
}

//d ##class(web.DHCHM.MessageSend).test()

ClassMethod test() As %String
{
	new repid, index,ID,OERId,sub,OQEobj
    //^User.DHCHMOMessageSendDetailI("MSDStatusIndex"," F",342,993)
   
	s OERId=0
	f  s OERId=$o(^User.DHCHMOMessageSendDetailI("MSDStatusIndex"," F",OERId)) q:OERId=""  d
	.w OERId
	.s Sub=0
	.f  s Sub=$o(^User.DHCHMOMessageSendDetailI("MSDStatusIndex"," F",OERId,Sub)) q:Sub=""  d
	..s OQEId=OERId_"||"_Sub
	..w OQEId
	..s OQEobj=##class(User.DHCHMOMessageSendDetail).%OpenId(OQEId)
	..w OQEobj.MSDSourceID
	..s OBIobj=##class(User.DHCHMOBaseInfo).%OpenId(OQEobj.MSDSourceID)
	..w OBIobj.BIName
}

//更新 短信发送状态

//w ##class(web.DHCHM.MessageSend).CMessageSendUpdateStatus("","344||998^^N#344||999^13001909677^F#344||1000^13910299677^S")

ClassMethod CMessageSendUpdateStatus(valueStr As %String, SendList As %String) As %String
{
  //n (rr,rr2,propertyStr,length,tempstr,vid,vstatus)
  Tstart 	

   //保存明细表	
  
  s propertyStr="MSDStatus^MSDSendDate^MSDSendTime^MSDSourceType"
  s length=$length(SendList,"#")
  for i=1:1:length 
   {
	   s tempstr=$p(SendList,"#",i)
	   s vid=$p(tempstr,"^",1)
	   s vstatus=$p(tempstr,"^",3)
	   s valueStr=vstatus_"^"_$p($h,",",1)_"^"_$p($h,",",2)_"^70010001"
	   //w valueStr,!
	   //w vid
	   s rr2=##class(User.DHCHMOMessageSendDetail).SaveData(vid,valueStr,propertyStr)
	   if +rr2<0 {break}
   }
   
  if +rr2<0 {
    TROLLBACK
 }else{ 
    Tcommit}
   
  quit rr2
}

}

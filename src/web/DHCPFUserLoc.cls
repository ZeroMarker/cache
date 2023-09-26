/// web.DHCPFUserLoc
Class web.DHCPFUserLoc Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "HISPFUserLocService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// TODO: add arguments and implementation.
Method Save(Source, Data) As %String [ WebMethod ]
{
	Set ^Temp("Protal")=Source_","_Data
	If Source="U"{
		q ..SaveUser(Data)
	}
	IF Source="D"{
		q ..SaveDep(Data)
	}
	Quit "-1^Arg1 值错误!"
}

/// TODO: Add SS_User.
/// 日期格式为yyyy-MM-dd
ClassMethod SaveUser(Data As %String) As %String
{
	Set Code = $Piece(Data,"^",1), Name = $Piece(Data,"^",2), Password = $Piece(Data,"^",3)
	Set Deptcode = $Piece(Data,"^",4), State = $Piece(Data,"^",5), Email = $Piece(Data,"^",6)
	Set InvalidDate = $Piece(Data,"^",7), EegDate = $Piece(Data,"^",8), Type = $Piece(Data,"^",9),Mnemonics=$Piece(Data,"^",10)
	Set HealthType=$Piece(Data,"^",11), IsExpert=$Piece(Data,"^",12),/*专家*/ SecGroupDesc=$Piece(Data,"^",13)
	Set Certificate=$Piece(Data,"^",14)/*医师资格证号*/,IsDrugRight=$Piece(Data,"^",15)/*毒麻处方权*/,Number=$Piece(Data,"^",16)
	Set now = +$h,nowtime=$p($h,",",2)
	;医护人员
	Set CTPCPTypeId = $o(^CT("CPT",0,"Code",$$ALPHAUP^SSUTIL4(HealthType),"")) 
	;$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(HealthType),""))
	If CTPCPTypeId="" q "-1^Health Type Not Exist"
	Set DeptId = $O(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Deptcode),""))
	If DeptId="" q "-1^Dept Code Not Exist"
	Set CTCPTInternalType = $p(^CT("CPT",CTPCPTypeId),"^",4)
	Set CTLOCType = $p(^CTLOC(DeptId),"^",13)	
	If (CTCPTInternalType="DOCTOR")&&(CTLOCType'="E") q "-1^ Doctors Department is not of type Execute"
	If (CTCPTInternalType="NURSE")&&(CTLOCType'="W") q "-1^ Nurses Department is not of type Ward"
	Set CTProvId = "",CTProvObj=""
	IF ##class(User.CTCareProv).CTPCPCodeUnqIdx1Exists(Code,.CTProvId){
		Set CTProvObj = ##class(User.CTCareProv).%OpenId(CTProvId)			
	}Else {
		Set CTProvObj = ##class(User.CTCareProv).%New()
	}
	Quit:'$IsObject(CTProvObj) -1_"^Get HIS CTCareProv Error"	
	if State=1{	;Ins		
		Set CTProvObj.CTPCPActiveFlag = "Y"	
		Set CTProvObj.CTPCPDateActiveFrom = now
	}elseif State=2{	;un active
		Set CTProvObj.CTPCPActiveFlag = "N"			
	}
	Set CTProvObj.CTPCPOtherName=Mnemonics
	Set CTProvObj.CTPCPSpecialistYN=IsExpert
	Set CTProvObj.CTPCPUnit =Certificate
	Set CTProvObj.CTPCPHICApproved=IsDrugRight
	Set CTProvObj.CTPCPCode = Code
	Set CTProvObj.CTPCPDesc = Name 
	Do CTProvObj.CTPCPCarPrvTpDRSetObjectId(CTPCPTypeId)	
	Set CTProvObj.CTPCPUpdateDate = now
	Set CTProvObj.CTPCPUpdateTime = nowtime
	Set sc = CTProvObj.%Save()
	if $SYSTEM.Status.IsError(sc) q -1_"^"_$SYSTEM.Status.GetErrorText(sc)
	Set CTProvId = CTProvObj.%Id()	
	Do CTProvObj.%Close()
	Set CTProvObj = ""
	;资源	
	Set RBResId = $O(^RB("RES",0,"CTPCP",CTProvId,DeptId,""))
	If RBResId=""{
		Set RBResObj = ##class(User.RBResource).%New()
		Set RBResObj.RESActive="Y"
		Set RBResObj.RESCode = Code
		Set RBResObj.RESDesc = Name
		Do RBResObj.RESCTLOCDRSetObjectId(DeptId)
		Do RBResObj.RESCTPCPDRSetObjectId(CTProvId)
		Set RBResObj.RESDateActiveFrom = now
	}
	;用户
	Set Obj = ""
	Set SSUserId = ""
	IF ##class(User.SSUser).SSUSRInitialsUnqIdx1Exists(Code,.SSUserId){
		Set Obj = ##class(User.SSUser).%OpenId(SSUserId)			
	}Else {
		Set Obj = ##class(User.SSUser).%New()
	}
	Quit:'$IsObject(Obj) -1_"^Get HIS User Error"	
	if State=1{	;Ins		
		Set Obj.SSUSRActive = "Y"
		Set Obj.SSUSRCreatedDate = now
		Set Obj.SSUSRCreatedTime = nowtime
	}elseif State=2{	;un active
		Set Obj.SSUSRActive="N"			
	} 
	Set Obj.SSUSRInitials = Code
	Set Obj.SSUSRName = Name
	Set Obj.SSUSRPassword = ##class(web.Util.Encryption).RSADecrypt(Password,"D:\DSKeys\HIS_Privatekey.pem")
	Set Obj.SSUSREMailName = Email
	Set Obj.SSUSRDateFrom =$s(InvalidDate'="":$zdh(InvalidDate,3),1:$h-1)
	Set Obj.SSUSRDateTo = $s(EegDate'="":$zdh(EegDate,3),1:"")
	;Type,Deptcode
	Do Obj.SSUSRDefaultDeptDRSetObjectId(DeptId)
	Set SecGroupId = ""
	&sql(SELECT SSGRP_Rowid into :SecGroupId from SQLUser.SS_Group where SSGRP_Desc =:SecGroupDesc)
	Do Obj.SSUSRGroupSetObjectId(SecGroupId)
	
	DO Obj.SSUSRCTPCPDRSetObjectId(CTProvId)
	Set Obj.SSUSRLastUpdateDate = now
	Set Obj.SSUSRLastUpdateTime = nowtime
	Set sc = Obj.%Save()
	If $SYSTEM.Status.IsError(sc) q -1_"^"_$SYSTEM.Status.GetErrorText(sc)
	Do Obj.%Close()
	Set Obj = ""
	Quit 0_"^成功"
}

/// TODO: Add CT_Loc.
Method SaveDep(Data As %String) As %String [ WebMethod ]
{
	Set Code = $Piece(Data,"^",1), Name = $Piece(Data,"^",2), LocLevel = $Piece(Data,"^",3)
	Set Super = $Piece(Data,"^",4), State = $Piece(Data,"^",5), IsLast = $Piece(Data,"^",6)
	Set Type = $Piece(Data,"^",7),Address = $Piece(Data,"^",10),Phone =$Piece(Data,"^",11)
	Set StartDate = $Piece(Data,"^",13), EndDate = $Piece(Data,"^",14)
	Set Obj = ""
	Set CTLocId = ""
	Set CTLocId = ##class(web.CTLoc).GetIdFromCodeOrDescription(Code)
	If CTLocId{
		Set Obj = ##class(User.CTLoc).%OpenId(CTLocId)			
	}Else {
		Set Obj = ##class(User.CTLoc).%New()
	}
	Quit:'$IsObject(Obj) -1_"^GET HIS CTLoc Error"	
	if State=1{	;Ins		
		Set Obj.CTLOCActiveFlag = "Y"		
		
	}elseif State=2{	;un active
		Set Obj.CTLOCActiveFlag="N"			
	}
	Set Obj.CTLOCCode = Code
	Set Obj.CTLOCDesc = Name
	Set Obj.CTLOCType = Type
	Set Obj.CTLOCAddress = Address
	Set Obj.CTLOCTelephone = Phone
	Set Obj.CTLOCDateActiveFrom = $s(StartDate'="":$zdh(StartDate,3),1:"")
	Set Obj.CTLOCDateActiveTo = $s(EndDate'="":$zdh(EndDate,3),1:"")
	;LocLevel,Super,IsLast	
	Set sc = Obj.%Save()
	If $SYSTEM.Status.IsError(sc) q -1_"^"_$SYSTEM.Status.GetErrorText(sc)
	Quit 0_"^成功"
}

}

Class dhcservice.SynchronizeUserLoc Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "SynchronizeUserLoc";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

Parameter PRIVATEKEYFILE = "HIS_Privatekey.pem";

Parameter PUBLICKEYFILE = "HIS_Public.csr";

Method GetKeyDir() As %String [ WebMethod ]
{
	Set Config = $o(^websys.ConfigurationD(""))
	Set App = $lg(^websys.ConfigurationD(Config),2)
	If App="" Set App="/dthealth/web"
	Set dir=""
	Set CurNS=$namespace
	zn "%sys"
	Set dir = $lg(^SYS("Security","ApplicationsD",App),17)_"/key/"	
	zn CurNS
	Set dir = ##class(%File).NormalizeDirectory(dir)
	Quit dir
}

Method RSADecrypt(Ciphertext) As %String [ WebMethod ]
{
	Set dir = ..GetKeyDir()
	if (dir="") q "Not find key directory."
	Set PrivateKeyFile = ##class(%File).NormalizeFilename(dir_"/"_..#PRIVATEKEYFILE)
	if ##class(%File).Exists(PrivateKeyFile){
		Quit ##class(web.Util.Encryption).RSADecrypt(Ciphertext,PrivateKeyFile)	
	}else{
		Quit "Not find "_PrivateKeyFile_" file."
	}
}

Method RSAEncrypt(Plaintext) As %String [ WebMethod ]
{
	Set dir = ..GetKeyDir()
	if (dir="") q "Not find key directory."
	Set PublicKeyFile = ##class(%File).NormalizeFilename(dir_"/"_..#PUBLICKEYFILE)
	if ##class(%File).Exists(PublicKeyFile){
		q ##class(web.Util.Encryption).RSAEncrypt(Plaintext,PublicKeyFile)
	}else{
		Quit "Not find "_PublicKeyFile_" file."
	}
}

/// TODO: add arguments and implementation.
Method Save(Source, Data) As %String [ WebMethod ]
{
	set ^Temp("cml","service","in")=Data
	If Source="U"{
		Set rtn = ..SaveUser(Data)
		set ^Temp("cml","service","SaveUser")=rtn
		quit rtn
	}
	IF Source="D"{
		set rtn = ..SaveDep(Data)
		set ^Temp("cml","service","SaveDep")=rtn
		quit rtn
	}
	
	Quit "-1^Arg1 值错误!"
}

/// FBB0003^范冰冰^rqtC8TYMwYb/8zgFDQ8ZHxnc0eoShqz0hlGnOlifFy83gr7O6EAOlSoTSf2WaBHz977mik50Umhs MRCbOORyAbKPrR6CcXUHTEDg5iCoJBeErjGNQtW9yPenqHrUgMdKc3h+30x+1GVs0M9dNbAQR6yA 3ara9vEduNMI3NSjT20=
/// ^10010000^1^11123@qq.com^2013-09-03^^02^FBB^主任医师^Y^Demo Group^1001^Y^0003^bine
///  
/// TODO: Add SS_User.
Method SaveUser(Data As %String) As %String [ WebMethod ]
{
	Set Code = $Piece(Data,"^",1), Name = $Piece(Data,"^",2), Password = $Piece(Data,"^",3)
	;Set Password = ..RSADecrypt(Password)
	Set Deptcode = $Piece(Data,"^",4), State = $Piece(Data,"^",5), Email = $Piece(Data,"^",6)
	Set InvalidDate = $Piece(Data,"^",7), EegDate = $Piece(Data,"^",8), Type = $Piece(Data,"^",9),Mnemonics=$Piece(Data,"^",10)
	Set HealthType=$Piece(Data,"^",11), IsExpert=$Piece(Data,"^",12),/*专家*/ SecGroupDesc=$Piece(Data,"^",13)
	Set Certificate=$Piece(Data,"^",14)/*医师资格证号*/,IsDrugRight=$Piece(Data,"^",15)/*毒麻处方权*/,Number=$Piece(Data,"^",16)
	Set Ename = $Piece(Data,"^",17)
	Set now = +$h,nowtime=$p($h,",",2)	
	If State=2{	;un active
		/*IF ##class(User.CTCareProv).CTPCPCodeUnqIdx1Exists(Code,.CTProvId){
			Set CTProvObj = ##class(User.CTCareProv).%OpenId(CTProvId)			
		}
		Quit:'$IsObject(CTProvObj) Code_". CTCareProv Code Not Exist"
		Set CTProvObj.CTPCPActiveFlag = "N"	
		Set CTProvObj.CTPCPDateActiveTo = +$h
		Set sc = CTProvObj.%Save()
		if $SYSTEM.Status.IsError(sc) q -1_"^"_$SYSTEM.Status.GetErrorText(sc)
		Set CTProvObj=""	*/	
		IF ##class(User.SSUser).SSUSRInitialsUnqIdx1Exists(Code,.SSUserId){
			Set Obj = ##class(User.SSUser).%OpenId(SSUserId)			
		}
		Quit:'$IsObject(Obj) Code_". SSUser Code Not Exist"
		Set Obj.SSUSRActive="N"	
		set Obj.SSUSRDateTo = +$h			
		Set sc = Obj.%Save()
		If $SYSTEM.Status.IsError(sc) q -1_"^"_$SYSTEM.Status.GetErrorText(sc)
		Do Obj.%Close()
		Set Obj = ""
		Quit 0_"^删除成功"
	}
	;Quit:HealthType="" "-1^HealthType Is Null!"
	;医护人员
	;Set CTPCPTypeId = $o(^CT("CPT",0,"Code",$$ALPHAUP^SSUTIL4(HealthType),""))	;
	;If CTPCPTypeId="" q "-1^"_HealthType_"Health Type Not Exist"
	Set DeptId = $O(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Deptcode),""))
	If DeptId="" q "-1^"_Deptcode_"Dept Code Not Exist"
	;Set CTCPTInternalType = $p(^CT("CPT",CTPCPTypeId),"^",4)
	;Set CTLOCType = $p(^CTLOC(DeptId),"^",13)	
	;If (CTCPTInternalType="DOCTOR")&&(CTLOCType'="E") q "-1^ Doctors Department is not of type Execute"
	;If (CTCPTInternalType="NURSE")&&(CTLOCType'="W") q "-1^ Nurses Department is not of type Ward"
	/*Set CTProvId = "",CTProvObj=""
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
	}elseif State=3{
		if EegDate="" Set CTProvObj.CTPCPActiveFlag = "Y"	
	}
	Set CTProvObj.CTPCPOtherName=Mnemonics
	Set CTProvObj.CTPCPSpecialistYN=IsExpert
	Set CTProvObj.CTPCPUnit =Certificate
	Set CTProvObj.CTPCPHICApproved=IsDrugRight
	Set CTProvObj.CTPCPCode = Code
	Set CTProvObj.CTPCPDesc = Name 
	Do CTProvObj.CTPCPCarPrvTpDRSetObjectId(CTPCPTypeId)
	if EegDate'="" set CTProvObj.CTPCPDateActiveTo = $zdh(EegDate,3)
	else  set CTProvObj.CTPCPDateActiveTo = ""
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
	}*/
	;用户
	Set Obj = ""
	Set SSUserId = ""
	IF ##class(User.SSUser).SSUSRInitialsUnqIdx1Exists(Code,.SSUserId){
		Set Obj = ##class(User.SSUser).%OpenId(SSUserId)			
	}Else {
		Set Obj = ##class(User.SSUser).%New()
	}
	;Set ^Temp("wanghc","SSUserId")=SSUserId
	Quit:'$IsObject(Obj) -1_"^Get HIS User Error"	
	if State=1{	;Ins		
		Set Obj.SSUSRActive = "Y"
		Set Obj.SSUSRCreatedDate = now
		Set Obj.SSUSRCreatedTime = nowtime
		;Type,Deptcode
		Do Obj.SSUSRDefaultDeptDRSetObjectId(DeptId)
		Set SecGroupId = ""
		&sql(SELECT SSGRP_Rowid into :SecGroupId from SQLUser.SS_Group where SSGRP_Desc =:SecGroupDesc)
		Do Obj.SSUSRGroupSetObjectId(SecGroupId)
	}elseif State=2{	;un active
		Set Obj.SSUSRActive="N"			
	}elseif State=3{	;un active
		if EegDate="" Set Obj.SSUSRActive="Y"			
	} 
	Set Obj.SSUSRInitials = Code
	Set Obj.SSUSRName = Name
	;if (Obj.SSUSRPassword="") Set Obj.SSUSRPassword = $$ENCR^SSUTIL2(Password)
	if (Password'="") && (Password'="******") Set Obj.SSUSRPassword = $$ENCR^SSUTIL2(Password)
	Set Obj.SSUSREMailName = Email
	If Obj.SSUSRDateFrom=""  Set Obj.SSUSRDateFrom = now
	If InvalidDate["-" Set Obj.SSUSRDateFrom = $zdh(InvalidDate,3)
	if (EegDate["-") set Obj.SSUSRDateTo = $zdh(EegDate,3)
	else  set Obj.SSUSRDateTo = ""
	;Set ^Temp("wanghc","SSUSRDateTo")=EegDate
	Set Obj.SSUSRName1 = Ename

	;Set ^Temp("wanghc","SecGroupId")=SecGroupId
	;DO Obj.SSUSRCTPCPDRSetObjectId(CTProvId)
	Set Obj.SSUSRLastUpdateDate = now
	Set Obj.SSUSRLastUpdateTime = nowtime
	;Set ^Temp("wanghc","now")=now
	Set sc = Obj.%Save()
	If $$$ISERR(sc) q -1_"^"_$SYSTEM.Status.GetErrorText(sc)
	Do Obj.%Close()
	Set Obj = ""
	Quit 0_"^成功"
}

/// 
/// TODO: Add CT_Loc.
/// D ##class(dhcservice.SynchronizeUserLoc).SaveDep("WSGCS^我是个测试^^^3^^E^12^^1234^12345^WSGCS^2015-03-25^^^^Y")
Method SaveDep(Data As %String) As %String [ WebMethod ]
{
	Quit:Data="" "-1^arg is null"
	Set $ZT="SaveDepErr"
	Set Code = $Piece(Data,"^",1), Name = $Piece(Data,"^",2), LocLevel = $Piece(Data,"^",3)
	Set Super = $Piece(Data,"^",4), State = $Piece(Data,"^",5), IsLast = $Piece(Data,"^",6)
	Set LocType =  $Piece(Data,"^",7),DGroup=$Piece(Data,"^",8),LocAddr = $Piece(Data,"^",10)
	Set LocPhone=$Piece(Data,"^",11),Mnemonics=$Piece(Data,"^",12),StartDate = $Piece(Data,"^",13)
	Set EndDate = $Piece(Data,"^",14),Storey=$Piece(Data,"^",15),Cataloguo=$Piece(Data,"^",16),Dept=$Piece(Data,"^",17)
	set HospCode=$Piece(Data,"^",18)
	Set CTLocId = ""
	Set CTLocId = ##class(web.CTLoc).GetIdFromCodeOrDescription(Code)
	If CTLocId{
		Set Obj = ##class(User.CTLoc).%OpenId(CTLocId)			
	}Else {
		Set Obj = ##class(User.CTLoc).%New()
	}
	Quit:'$IsObject(Obj) -1_"^GET HIS CTLoc Error"
	
	if State=2{	;un active
		Set Obj.CTLOCActiveFlag="N"
	    Set Obj.CTLOCDateActiveTo = +$h
		Set sc = Obj.%Save()
		If $SYSTEM.Status.IsError(sc) q -1_"^"_$SYSTEM.Status.GetErrorText(sc)
		Quit 0_"^删除成功"
	}
	if State=1{	;Ins		
		Set Obj.CTLOCActiveFlag = "Y"			
	}elseif State=3{
		if EndDate="" Set Obj.CTLOCActiveFlag= "Y"	
	}
	Set Obj.CTLOCType = LocType
	Set Obj.CTLOCCode = Code
	if Name["-"{
		Set Obj.CTLOCDesc = Name
	}else{
		Set Obj.CTLOCDesc = Mnemonics_"-"_Name
	}
	;Set ^Temp("wanghc","obj")=DGroup
	if DGroup'=""{
		Set GroupId = ##class(web.RBCDepartmentGroup).GetIdFromCodeOrDescription(DGroup)
		do:GroupId>0 Obj.CTLOCDepDRSetObjectId(GroupId)
	}
	;Set ^Temp("wanghc","LocAddr")=LocAddr
	if LocAddr'=""{
		Do Obj.CTLOCAddress.Clear()
		Do Obj.CTLOCAddress.InsertAt(LocAddr,1)
	}
	Set Obj.CTLOCTelephone = LocPhone
	;Set ^Temp("wanghc","LocPhone")=LocPhone_","_StartDate_","_EndDate
	if StartDate["-" Set Obj.CTLOCDateActiveFrom = $zdh(StartDate,3)
	if EndDate["-" Set Obj.CTLOCDateActiveTo = $zdh(EndDate,3)
	else  Set Obj.CTLOCDateActiveTo =""
	Set HospId = ##class(web.CTHospital).GetIdFromCodeOrDescription(HospCode)
	do Obj.CTLOCHospitalDRSetObjectId(HospId)
	;LocLevel,Super,IsLast	
	;Set ^Temp("wanghc","IsLast")=IsLast
	Set sc = Obj.%Save()
	If $SYSTEM.Status.IsError(sc) q -1_"^"_$SYSTEM.Status.GetErrorText(sc)
	Quit 0_"^成功"
SaveDepErr
	Quit "-100^HISSaveDep:"_$SYSTEM.Status.GetErrorText($ze)
}

/// 用于导入科室到统一平台
/// Param Start 开始行 从1开始.包含Start行.
/// Param Row  多少条科室记录
Method GetDeptList(Start = 1, Count = 30) As %String [ WebMethod ]
{
	Set Rtn="",NumRow=0
	If Start'>0 Set Start=1
	If Count'>0 Set Count=30
	Set End = Start+Count
	Set CTLocId=0
	For  Set CTLocId = $o(^CTLOC(CTLocId)) Quit:((CTLocId="")||(NumRow>=End))  d
	.Set Obj =  ##class(User.CTLoc).%OpenId(CTLocId,0)
	.if Obj.CTLOCDesc["-" Set Name = $p(Obj.CTLOCDesc,"-",2)
	.else  Set Name = Obj.CTLOCDesc
	.Set Active = Obj.CTLOCActiveFlag
	.Quit:Active="N"
	.Set NumRow = NumRow+1
	.Quit:NumRow<Start
	.Quit:NumRow>=End
	.Set Data=""
	.Set $Piece(Data,"^",1) = Obj.CTLOCCode
	.Set $Piece(Data,"^",2) = Name
	.;Set LocLevel=$Piece(Data,"^",3)
	.;Set Super = $Piece(Data,"^",4)
	.Set $Piece(Data,"^",5)=1 ;State 
	.;Set IsLast = $Piece(Data,"^",6)
	.Set $Piece(Data,"^",7) = Obj.CTLOCType
	.Set $Piece(Data,"^",8) = $S($IsObject(Obj.CTLOCDepDR):Obj.CTLOCDepDR.DEPCode,1:"")
	.Set $Piece(Data,"^",10) = $S($IsObject(Obj.CTLOCAddress):Obj.CTLOCAddress.GetAt(1),1:"") ;LocAddr
	.Set $Piece(Data,"^",11) = Obj.CTLOCTelephone ;LocPhone
	.If Name["-" Set Mnemonics = $p(Name,"-",1)
	.Else  Set Mnemonics = ##class(ext.util.String).ToChineseSpell(Name)
	.Set $Piece(Data,"^",12) = Mnemonics
	.Set $Piece(Data,"^",13) = $S(Obj.CTLOCDateActiveFrom'="":$zd(Obj.CTLOCDateActiveFrom,3),1:"")
	.Set $Piece(Data,"^",14) = $S(Obj.CTLOCDateActiveTo'="":$zd(Obj.CTLOCDateActiveTo,3),1:"")
	.if Rtn="" Set Rtn = Data
	.Else  Set Rtn = Rtn_"|"_Data
	Quit Rtn
}

/// 用于导入用户到统一平台
/// Param Start 开始行 从1开始.包含Start行.
/// Param Row  多少条科室记录
Method GetUserList(Start = 1, Count = 30) As %String [ WebMethod ]
{
	Set Rtn="",NumRow=0
	If Start'>0 Set Start=1
	If Count'>0 Set Count=30
	Set End = Start+Count
	Set Id=0
	For  Set Id = $o(^SSU("SSUSR",Id)) Quit:((Id="")||(NumRow>=End))  d
	.Set Obj =  ##class(User.SSUser).%OpenId(Id,0)
	.Set Name = Obj.SSUSRName
	.Set Active = Obj.SSUSRActive
	.Quit:Active="N"
	.Set NumRow = NumRow+1
	.Quit:NumRow<Start
	.Quit:NumRow>=End
	.Set Data=""
	.Set $Piece(Data,"^",1) = Obj.SSUSRInitials
	.Set $Piece(Data,"^",2) = Name
	.;Set $Piece(Data,"^",3) = "******"
	.Set:$IsObject(Obj.SSUSRDefaultDeptDR) $Piece(Data,"^",4) = Obj.SSUSRDefaultDeptDR.CTLOCCode
	.Set $Piece(Data,"^",5)=1 ;State 
	.Set $Piece(Data,"^",6) = Obj.SSUSREmail
	.Set:Obj.SSUSRDateFrom'="" $Piece(Data,"^",7) = $ZD(Obj.SSUSRDateFrom,3)
	.Set:Obj.SSUSRDateTo'="" $Piece(Data,"^",8) = $ZD(Obj.SSUSRDateTo,3)
	.;Type = $Piece(Data,"^",9),
	.Set $Piece(Data,"^",10) = ##class(ext.util.String).ToChineseSpell(Name)
	.Set Type="03"
    .If $IsObject(Obj.SSUSRCareProvDR),$IsObject(Obj.SSUSRCareProvDR.CTPCPCarPrvTpDR) d
	..Set $Piece(Data,"^",11) = Obj.SSUSRCareProvDR.CTPCPCarPrvTpDR.CTCPTCode ;HealthType
	..Set CTCPTInternalType =   Obj.SSUSRCareProvDR.CTPCPCarPrvTpDR.CTCPTInternalType
	..Set Type= $case(CTCPTInternalType,"DOCTOR":"02","NURSE":"01",:"03") ;Type = $Piece(Data,"^",9) 01：护士，02：医生，03：其它
	.Set DefaultGroupDesc = Obj.SSUSRGroup.SSGRPDesc
	.if DefaultGroupDesc["护士长" set Type="04"
	.Set OtherLocInd=0,Flag=0
	.For  Set OtherLocInd = $o(^SSU("SSUSR", Id, "OTHLL",OtherLocInd)) Quit:OtherLocInd=""  d
	..Quit:(OtherLocInd'>0)
	..Set OtherGroupId = $p($g(^SSU("SSUSR", Id, "OTHLL",OtherLocInd)),"^",2)
	..set OtherGroupDesc = $p(^SSU("SSGRP",OtherGroupId),"^",1)
	..If OtherGroupDesc["护士长" set Type="04"
	.Set $Piece(Data,"^",9) = Type
	.;IsExpert=$Piece(Data,"^",12),/*专家*/ 
	.Set:$IsObject(Obj.SSUSRGroup) $Piece(Data,"^",13) = Obj.SSUSRGroup.SSGRPDesc
	.;Set $Piece(Data,"^",14) = ""
	.;Set IsDrugRight=$Piece(Data,"^",15)/*毒麻处方权*/
	.;Set Number=$Piece(Data,"^",16)
	.Set $Piece(Data,"^",17) = Obj.SSUSRInitials
	.if Rtn="" Set Rtn = Data
	.Else  Set Rtn = Rtn_"|"_Data
	Quit Rtn
}

}

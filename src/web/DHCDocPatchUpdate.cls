Class web.DHCDocPatchUpdate Extends %RegisteredObject
{

ClassMethod GetOEPref(UserId, LogonLocId = "", CONTEXT = "")
{
	Q:UserId="" "1"
	s PrefType=##class(epr.PreferencesQuery).GetPrefTypeByLoc(LogonLocId)
	s PrefWflag=0
	s appKey="ORDER"_CONTEXT_PrefType
	&sql(select ID from websys.Preferences where ObjectType='User.SSUser' and AppKey=:appKey and AppSubKey='OEOrder.PrefTabs.EditList' and ObjectReference=:UserId)
	if SQLCODE=0 s PrefWflag=1
	if PrefWflag'=1 {
	&sql(select ID from websys.Preferences where ObjectType='User.SSUser' and AppKey='ORDER' and AppSubKey='OEOrder.PrefTabs.EditList' and ObjectReference=:UserId)
	}
	Q:SQLCODE "1"
	Q "0"
}

/// w ##class(web.DHCDocPatchUpdate).ChangeOEPref(600)
ClassMethod ChangeOEPref(UserId)
{
	Q:UserId="" "1"
	s UserIdNew=UserId_"1111"
	s PrefWflag=0
	&sql(select ID from websys.Preferences where ObjectType='User.SSUser' and AppKey %STARTSWITH 'ORDERW' and AppSubKey='OEOrder.PrefTabs.EditList' and ObjectReference=:UserId)
	if SQLCODE=0 s PrefWflag=1
	if PrefWflag'=1 {
	   &sql(select ID from websys.Preferences where ObjectType='User.SSUser' and AppKey='ORDER' and AppSubKey='OEOrder.PrefTabs.EditList' and ObjectReference=:UserId)
	}
	b  ;
	Q:SQLCODE "1"
	TS
	if PrefWflag=1 {
        &sql(update websys.Preferences set ObjectReference=:UserIdNew where ObjectType='User.SSUser' and AppKey %STARTSWITH 'ORDERW' and AppSubKey='OEOrder.PrefTabs.EditList' and ObjectReference=:UserId)	
	}else{
	    &sql(update websys.Preferences set ObjectReference=:UserIdNew where ObjectType='User.SSUser' and AppKey='ORDER' and AppSubKey='OEOrder.PrefTabs.EditList' and ObjectReference=:UserId)
	}
	b ;4
	i SQLCODE {
		Tro
		Q "1"
	}
	s ^DHCChangeOEPrefLog("UserId",+$h,UserId)=UserId_"^"_UserIdNew
	TC
	Q "0"
}

ClassMethod ReChangeOEPref(UserId)
{
	Q:UserId="" "1"
	s UserIdNew=UserId_"1111"
	s PrefWflag=0
	&sql(select ID from websys.Preferences where ObjectType='User.SSUser' and AppKey %STARTSWITH 'ORDERW' and AppSubKey='OEOrder.PrefTabs.EditList' and ObjectReference=:UserIdNew)
	if SQLCODE=0 s PrefWflag=1
	if PrefWflag'=1 {
	   &sql(select ID from websys.Preferences where ObjectType='User.SSUser' and AppKey='ORDER' and AppSubKey='OEOrder.PrefTabs.EditList' and ObjectReference=:UserIdNew)
	}
	Q:SQLCODE "1"
	TS
	if PrefWflag=1 {
	    &sql(update websys.Preferences set ObjectReference=:UserId where ObjectType='User.SSUser' and AppKey %STARTSWITH 'ORDERW' and AppSubKey='OEOrder.PrefTabs.EditList' and ObjectReference=:UserIdNew)
	}else{
	    &sql(update websys.Preferences set ObjectReference=:UserId where ObjectType='User.SSUser' and AppKey='ORDER' and AppSubKey='OEOrder.PrefTabs.EditList' and ObjectReference=:UserIdNew)
	}
	i SQLCODE {
		Tro
		Q "1"
	}
	s ^DHCChangeOEPrefLog("RUserId",+$h,UserId)=UserId_"^"_UserIdNew
	TC
	Q "0"
}

ClassMethod GetCodeDescById(Id, Table, Format)
{
	Q:(Id="")!(Table="") ""
	s Code="",Desc=""
	i (Table="User.CTLoc") {
		s Code=$P($G(^CTLOC(Id)),"^",1)
		i $L(Code,"-")>1 s Code=$P(Code,"-",1)
		s Desc=$P($G(^CTLOC(Id)),"^",2)
		i $l(Desc,"-")>1 s Desc=$P(Desc,"-",2)
	}
	i Format="Code" {
		Q Code
	}elseif (Format="Desc"){
		Q Desc
	}else{
		Q Code_$C(1)_Desc
	}
}

ClassMethod InsertConMRCode(UserId, ICD, DefineCode)
{
	;"6044,19326,22"
	;w ##class(web.DHCDocPatchUpdate).InsertConMRCode(6044,19326,22)
	s ^RP("MRCode")=UserId_","_ICD_","_DefineCode
	Q:(UserId="")!(ICD="")!(DefineCode="") "1"
	i $g(^DHCMRCode("MRDefineCode",UserId,ICD))'=""{
		s DefineCodeW=$G(^DHCMRCode("MRDefineCode",UserId,ICD))
		b ;
		i DefineCodeW'="" {
			k ^DHCMRCodeI("MRDefineCodeI",UserId,DefineCodeW)
		}
		;b
		s ^DHCMRCode("MRDefineCode",UserId,ICD)=DefineCode
		s ^DHCMRCodeI("MRDefineCodeI",UserId,DefineCode)=ICD
	}else{
		s ^DHCMRCode("MRDefineCode",UserId,ICD)=DefineCode
		s ^DHCMRCodeI("MRDefineCodeI",UserId,DefineCode)=ICD
	}
	Q "0"
}

ClassMethod GetConMRCode(UserId, temp, format)
{
	Q:((UserId="")!(temp="")!(format="")) ""
	s ret=""
	i (format="ICD"){
		s ret=$G(^DHCMRCode("MRDefineCode",UserId,temp))
	}
	i (format="ConCode"){
		s ret=$G(^DHCMRCodeI("MRDefineCodeI",UserId,temp))
	} 
	Q ret
}

}

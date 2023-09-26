/// 名称: DHCWMR.FPService.FPPatInfoSrv
/// 描述: 编目病人信息相关服务
/// 编写者：zhufei
/// 编写日期: 2014-09-16
Class DHCWMR.FPService.FPPatInfoSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-09-16
/// Description:  查询病人信息
/// Table：       Pa_Patmas、Pa_Adm
/// Input：       aFrontPageID : 编目记录ID
/// Return：      ROWSPEC=...
/// D ##class(%ResultSet).RunQuery("DHCWMR.FPService.FPPatInfoSrv","QryPatInfo","23","")
Query QryPatInfo(aFrontPageID As %String, aVolumeID As %String) As %Query(ROWSPEC = "FrontPageID:%String,VolumeID:%String,MrTypeID:%String,MrTypeDesc:%String,MrNo:%String,IsFinish:%String,StatusDesc:%String,BuildDate:%String,BuildTime:%String,BuildUser:%String,UpdateDate:%String,UpdateTime:%String,UpdateUser:%String,EpisodeID:%String,PatientID:%String,AdmDate:%String,AdmTime:%String,Loc:%String,Ward:%String,Room:%String,Bed:%String,DocCode:%String,DocName:%String,DischDate:%String,DischTime:%String,EstDischDate:%String,EstDischTime:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,PersonalType:%String,PersonalID:%String,Province:%String,City:%String,Country:%String,Marital:%String,Nation:%String,Education:%String,Telephone:%String,Company:%String,HomeAddress:%String,Relation:%String,RelationMan:%String,RelationAddr:%String,EncryptLevel:%String,PatLevel:%String") [ SqlProc ]
{
}

ClassMethod QryPatInfoExecute(ByRef qHandle As %Binary, aFrontPageID As %String, aVolumeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	If aFrontPageID'="" {
	 	Set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjById(aFrontPageID)
	 	Quit:'$IsObject(objFrontPage) $$$OK
	 	Quit:'$IsObject(objFrontPage.FPVolumeDr) $$$OK
	 	Set VolumeID=objFrontPage.FPVolumeDr.%Id()
		Set IsFinish=objFrontPage.FPIsFinish
		Set StatusDesc=$s(IsFinish=1:"完成",1:"暂存")
		Set BuildDate=objFrontPage.FPBuildDate
		Set:BuildDate'="" BuildDate=$zd(BuildDate,3)
		Set BuildTime=objFrontPage.FPBuildTime
		Set:BuildTime'="" BuildTime=$zt(BuildTime,2)
		Set BuildUser=objFrontPage.FPBuildUser
		Set:BuildUser'="" BuildUser=$p($g(^SSU("SSUSR",+BuildUser)),"^",2)
		Set UpdateDate=objFrontPage.FPUpdateDate
		Set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
		Set UpdateTime=objFrontPage.FPUpdateTime
		Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,2)
		Set UpdateUser=objFrontPage.FPUpdateUser
		Set:UpdateUser'="" UpdateUser=$p($g(^SSU("SSUSR",+UpdateUser)),"^",2)
	} Else {
		Set VolumeID=aVolumeID
		Set IsFinish=0
		Set StatusDesc=$s(IsFinish=1:"完成",1:"草稿")
		Set BuildDate=""
		Set BuildTime=""
		Set BuildUser=""
		Set UpdateDate=""
		Set UpdateTime=""
		Set UpdateUser=""
	}
 	Quit:VolumeID="" $$$OK
 	Set objVolume=##Class(DHCWMR.SS.Volume).GetObjById(VolumeID)
 	Quit:'$IsObject(objVolume) $$$OK
 	Quit:'$IsObject(objVolume.SVMainDr) $$$OK
 	Quit:'$IsObject(objVolume.SVMainDr.SMMrType) $$$OK
 	Set MrNo=objVolume.SVMainDr.SMMrNo
 	Set MrTypeID=objVolume.SVMainDr.SMMrType.%Id()
 	Set MrTypeDesc=objVolume.SVMainDr.SMMrType.MTDesc
 	
 	Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(VolumeID)
 	Quit:EpisodeID="" $$$OK
 	
 	Set Data=..GetPatInfoByAdm(EpisodeID)
 	Quit:Data="" $$$OK
 	Set Data=$lb(aFrontPageID,VolumeID,MrTypeID,MrTypeDesc,MrNo,IsFinish,StatusDesc,BuildDate,BuildTime,BuildUser,UpdateDate,UpdateTime,UpdateUser)_Data
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
	Quit $$$OK
}

ClassMethod QryPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPatInfoByAdm(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set EpisodeID=aEpisodeID
	Set strAdmInfo=$g(^PAADM(EpisodeID))
	Quit:strAdmInfo="" return
	Set PatientID=$p(strAdmInfo,"^",1)
	Quit:PatientID="" return
	
	 //upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	//Set AdmDate=$p(strAdmInfo,"^",6)
	Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	//Set AdmTime=$p(strAdmInfo,"^",7)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
	Set LocID=+$p(strAdmInfo,"^",4)
	Set LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
	Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	//update by pylian 2016-01-22
	Set DischDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetDischDateTime(aEpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	//Set DischDate=$p(strAdmInfo,"^",17)   
	Set:DischDate'="" DischDate=$zd(DischDate,3)
	//Set DischTime=$p(strAdmInfo,"^",18)
	Set:DischTime'="" DischTime=$zt(DischTime,2)
	Set EstimDischDate=$p(strAdmInfo,"^",59)
	Set:EstimDischDate'="" EstimDischDate=$zd(EstimDischDate,3)
	Set EstimDischTime=$p(strAdmInfo,"^",60)
	Set:EstimDischTime'="" EstimDischTime=$zt(EstimDischTime,2)
	Set WardID=+$p(strAdmInfo,"^",70)
	Set WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
    Set RoomID=+$p(strAdmInfo,"^",69)
    Set RoomDesc=$p($g(^PAROOM(+RoomID)),"^",2)
    Set BedID=$p(strAdmInfo,"^",73)
    Set BedDesc=$p($g(^PAWARD(+BedID,"BED",+$p($p(strAdmInfo,"^",73),"||",2))),"^",1) //修复Bug
    //Set:BedDesc'="" BedDesc=BedDesc_"床"
    Set DocID=$p(strAdmInfo,"^",9)
    Set DocCode=$p($g(^CTPCP(+DocID,1)),"^",1)
    Set DocName=$p($g(^CTPCP(+DocID,1)),"^",2)
	
	Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
	Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	Set Sex=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	Set Sex=$p($g(^CT("SEX",+Sex)),"^",2)
	Set BirthDay=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	
	//update by zf 20150228 统一调用年龄计算方法
	//Set tmpDate=$p($g(^PAADM(+EpisodeID)),"^",6)
	//Set tmpTime=$p($g(^PAADM(+EpisodeID)),"^",7)
	Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmTime)	//返回“*岁*月*天”
	
	//fix bug 8396 by pylian 2015-04-01  病案编目不显示患者病人密级和病人级别
	Set (EncryptLevel,PatLevel)=""
	Set SecretStr=##class(DHCWMR.IO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	Set PersonalType=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	Set PersonalType=$p($g(^PAC("CARD",+PersonalType)),"^",2)
	Set PersonalID=$p($g(^PAPER(PatientID,"ALL")),"^",9)
	Set PAPMIDVAnumber=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	If ($l(PAPMIDVAnumber)>10) {
		Set PersonalID=PAPMIDVAnumber
	}
	Set ProvinceID=$p($g(^PAPER(PatientID,"PER",2)),"^",11)
	Set ProvinceDesc=$p(^CT("PROV",+ProvinceID),"^",2)
	Set:$p(ProvinceDesc,"-",2)'="" ProvinceDesc=$p(ProvinceDesc,"-",2)
	Set CityID=$p($g(^PAPER(PatientID,"ALL")),"^",18)
	Set CityDesc=$p(^CT("CIT",+CityID),"^",2)
	Set:$p(CityDesc,"-",2)'="" CityDesc=$p(CityDesc,"-",2)
	
    Set CountryID=$p($g(^PAPER(PatientID,"PER",1)),"^",8)
    Set CountryDesc=$p(^CT("COU",+CountryID),"^",2)
	Set:$p(CountryDesc,"-",2)'="" CountryDesc=$p(CountryDesc,"-",2)
    Set MaritalID=$p($g(^PAPER(PatientID,"PER",2)),"^",3)
    Set MaritalDesc=$p(^CT("MAR",+MaritalID),"^",2)
    Set NationID=$p($g(^PAPER(PatientID,"PER",2)),"^",1)
    Set NationDesc=$p(^CT("NAT",+NationID),"^",2)
	Set:$p(NationDesc,"-",2)'="" NationDesc=$p(NationDesc,"-",2)
    Set EducationID=$p($g(^PAPER(PatientID,"PER",2)),"^",5)
    Set EducationDesc=$p(^CT("EDU",+EducationID),"^",2)
    
    Set Telephone=..xGetMobPhone(PatientID)
    Set Company=..xGetCompany(PatientID)
    Set HomeAddress=..xGetHomeAddr(PatientID)
    Set Relation=..xGetCTRLT(PatientID)
    Set RelationMan=..xGetGTRLTMan(PatientID)
	Set RelationAddr=..xGetGTRLTAddr(PatientID)
	Set RelationTel=..xGetCTRLTTel(PatientID)
	If (Telephone'="")&&(RelationTel'="") {
		Set Telephone=Telephone_","_RelationTel
	} ElseIf Telephone="" {
		Set Telephone=RelationTel
	} Else {}
	
	Set return=$lb(EpisodeID,PatientID,AdmDate,AdmTime,LocDesc,WardDesc,RoomDesc,BedDesc)
	Set return=return_$lb(DocCode,DocName,DischDate,DischTime,EstimDischDate,EstimDischTime)
	Set return=return_$lb(PapmiNo,PatName,Sex,Age,PersonalType,PersonalID,ProvinceDesc,CityDesc)
	Set return=return_$lb(CountryDesc,MaritalDesc,NationDesc,EducationDesc,Telephone,Company)
	Set return=return_$lb(HomeAddress,Relation,RelationMan,RelationAddr)
	Set return=return_$lb(EncryptLevel,PatLevel)
	Quit return
}

/// 家庭住址
/// w ##class(DHCWMR.FPService.FPPatInfoSrv).xGetHomeAddr(140)
ClassMethod xGetHomeAddr(aPatientID As %String) As %String
{
 	New (aPatientID)
    Set return=""
    Quit:aPatientID="" return
    
    Set configValue=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("PatHomeAddress","")
    If (+configValue=0) {
	    Set return=$g(^PAPER(aPatientID,"PER","ADD",1))
    } Else {
    	Set return=$p($g(^PAPER(aPatientID,"PER",4)),"^",18)
    }
    Quit return
}

/// 工作单位
/// w ##class(DHCWMR.FPService.FPPatInfoSrv).xGetCompany(140)
ClassMethod xGetCompany(aPatientID As %String) As %String
{
 	New (aPatientID)
    Set return=""
    Quit:aPatientID="" return
    
    Set configValue=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("PatCompany","")
    If (+configValue=0) {
	    Set return=$p($g(^PAPER(aPatientID,"PER",4)),"^",18)
    } Else {
    	Set return=$g(^PAPER(aPatientID,"PER","ADD",1))
    }
    Quit return
}

/// 通过病人的ID取得其联系人的信息 
/// w ##class(DHCWMR.FPService.FPPatInfoSrv).xGetGTRLTMan(140)
ClassMethod xGetGTRLTMan(aPatientID As %String) As %String
{
 	New (aPatientID)
    Set return=""
    Quit:aPatientID="" return
    
    Set configValue=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("PatRelationMan","")
    If (+configValue=0) {
	    Set return=$p($g(^PAPER(aPatientID,"PER",2)),"^",13)
    } Else {
    	Set return=$p($g(^PAPER(aPatientID,"PER",1)),"^",1)
    }
    Quit return
}

/// 通过病人的ID取得病人与联系人关系
/// w ##class(DHCWMR.FPService.FPPatInfoSrv).xGetCTRLT(140)
ClassMethod xGetCTRLT(aPatientID As %String) As %String
{
 	New (aPatientID)
    Set return=""
    Quit:aPatientID="" return
    
    Set configValue=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("PatRelation","")
    If (+configValue=0) {
	    Set RltId=$p($g(^PAPER(aPatientID,"EMP")),"^",4) ;字段：PAPER_CTRLT_DR 指向表CT_Relation
	    Set return=$p($g(^CT("RLT",+RltId)),"^",2) ;关系描述对应字段CTRLT_Desc
    } Else {
    	Set return=$p($g(^PAPER(aPatientID,"ALL")),"^",4)
    }
    Quit return
}

/// 通过病人的ID取得其联系人电话
/// w ##class(DHCWMR.FPService.FPPatInfoSrv).xGetCTRLTTel(140)
ClassMethod xGetCTRLTTel(aPatientID As %String) As %String
{
 	New (aPatientID)
    Set return=""
    Quit:aPatientID="" return
    
    Set configValue=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("PatRelationTel","")
    If (+configValue=0) {
	    Set return=$p($g(^PAPER(aPatientID,"PER",1)),"^",11)
	    //如果PAPER_TelH为空，电话号码取值改为PAPMI_MobPhone
	    Set:return="" return=$p($g(^PAPER(aPatientID,"PER",4)),"^",21)
    } Else {
    	Set return=$p($g(^PAPER(aPatientID,"PER",2)),"^",8)
    }
    Quit return
}

/// 通过病人的ID取得其联系人地址
/// w ##class(DHCWMR.FPService.FPPatInfoSrv).xGetGTRLTAddr(140)
ClassMethod xGetGTRLTAddr(aPatientID As %String) As %String
{
 	New (aPatientID)
    Set return=""
    Quit:aPatientID="" return
    
    Set configValue=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("PatRelationAddr","")
    If (+configValue=0) {
	    Set return=$p($g(^PAPER(aPatientID,"PER",1)),"^",1)
    } Else {
    	Set return=$p($g(^PAPER(aPatientID,"ALL")),"^",5)
    }
    Quit return
}

/// 通过病人的ID取得病人手机号(公司电话)
/// w ##class(DHCWMR.FPService.FPPatInfoSrv).xGetMobPhone(140)
ClassMethod xGetMobPhone(aPatientID As %String) As %String
{
 	New (aPatientID)
    Set return=""
    Quit:aPatientID="" return
    
    Set configValue=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("PatMobPhone","")
    If (+configValue=0) {
	    Set return=$p($g(^PAPER(aPatientID,"PER",4)),"^",21)
    } Else {
    	Set return=$p($g(^PAPER(aPatientID,"PER",4)),"^",18)
    }
    Quit return
}

}

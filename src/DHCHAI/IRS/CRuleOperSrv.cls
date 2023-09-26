/// 名称: DHCHAI.IRS.CRuleOperSrv
/// 描述: 手术筛查标准相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-02
Class DHCHAI.IRS.CRuleOperSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-08-28
/// Description:  根据手术科室+手术名称判断+切口类型该手术是否在需要调查
/// Table：       DHCHAI.IR.INFOPSSurvKeyWds、DHCHAI.IR.INFOPSSurvOperDx
/// Input：       
/// Return：      空：不调查    String：标准手术ID--DHCHAI.DP.OROperDx
/// w ##class(DHCHAI.IRS.CRuleOperSrv).CheckByCRuleOper("阑尾炎的顶顶顶顶顶切除手术","2")
ClassMethod CheckByCRuleOper(aOperDesc As %String, aOperLocID As %String, aMapIncDicDr As %String = "") As DHCHAI.IR.CRuleOper
{
	New (aOperDesc,aOperLocID,aMapIncDicDr)
	Set return=""
	Quit:(aOperDesc="") return
	
	Set aOperDesc=$zcvt(aOperDesc,"U")
	Set aOperDesc=$tr(aOperDesc," ","")
	Quit:aOperDesc="" return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aOperLocID)
	Quit:'$IsObject(objLoc) return
	Set aLocDr=objLoc.%Id()
	Set (aHospDr,aHospGrpDr)=""
	If $IsObject(objLoc.BTHospDr){
		Set aHospDr=objLoc.BTHospDr.%Id()
		If $IsObject(objLoc.BTHospDr.BTGroupDr){
			Set aHospGrpDr=objLoc.BTHospDr.BTGroupDr.%Id()
		}
	}	
	Set xOperDr=""
 	For {
	 	Set xOperDr=$o(^DHCHAI.IR.CRuleOperD(xOperDr))
	 	Quit:xOperDr=""
	 	
	 	Set objCROper=##class(DHCHAI.IR.CRuleOper).GetObjById(xOperDr)
	 	Continue:'$IsObject(objCROper)
	 	Continue:objCROper.BTIsActive'=1
	 	//类型（1全院、2院区、3科室）
		Set Type=objCROper.BTType
		If Type=1 {
			Continue:'$IsObject(objCROper.BTHospGrpDr)
			Set HospGrpDr=objCROper.BTHospGrpDr.%Id()
			Continue:HospGrpDr'=aHospGrpDr
		} ElseIf Type=2 {
			Continue:'$IsObject(objCROper.BTHospDr)
			Set HospDr=objCROper.BTHospDr.%Id()
			Continue:HospDr'=aHospDr
		} ElseIf Type=3 {
			Continue:'$IsObject(objCROper.BTLocDr)
			Set LocDr=objCROper.BTLocDr.%Id()
			Continue:LocDr'=aLocDr
		}
		
		If '$IsObject(objCROper.BTOperDxDr)&&(objCROper.BTOperation="") {//只维护切口类型
			If ($IsObject(objCROper.BTIncisionDr)) {   
				Set InccisionDr = objCROper.BTIncisionDr.%Id()
				Continue:(aMapIncDicDr'="")&&(aMapIncDicDr'=InccisionDr)
				Set return=objCROper
				Quit //退出
			}
		}Else {   //维护标准名称手术，必须维护手术关键词
		    
		    If ($IsObject(objCROper.BTIncisionDr)) {   
				Set InccisionDr = objCROper.BTIncisionDr.%Id()
				Continue:(aMapIncDicDr'="")&&(aMapIncDicDr'=InccisionDr)
			}
			
			Set xInWord=""
			For {
				Set xInWord=$o(^DHCHAI.IR.CRuleOperKeysI("IndexOperDrInWord",xOperDr,xInWord))
				Quit:xInWord=""
				Quit:return'=""
				Continue:aOperDesc'[xInWord
			
				Set xKeyID=""
				For {
					Set xKeyID=$o(^DHCHAI.IR.CRuleOperKeysI("IndexOperDrInWord",xOperDr,xInWord,xKeyID))
					Quit:xKeyID=""
					
					Set obj=##class(DHCHAI.IR.CRuleOperKeys).GetObjById(xKeyID)
					Continue:'$IsObject(obj)
					Continue:'$IsObject(obj.BTOperDr)
					
					Set ExWords=obj.BTExWords
					If ExWords'="" {
						Set IsAct=1
						For indEx=1:1:$ll(ExWords) {
							Set ExWord=$listget(ExWords,indEx)
							Continue:aOperDesc'[ExWord
							Set IsAct=0
						}
						Quit:IsAct<1
					}
					
					Set return=obj.BTOperDr
					Quit //退出
				}
			}
		}
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-02
/// Description:  查询手术筛查标准列表
/// Table：       DHCHAI.IR.CRuleOper
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CRuleOperSrv","QryCRuleOper")
Query QryCRuleOper() As %Query(ROWSPEC = "ID:%String,Type:%String,GrpID:%String,GrpDesc:%String,HospID:%String,HospDesc:%String,LocID:%String,LocDesc:%String,IncID:%String,IncCode:%String,IncDesc:%String,OperDxID:%String,Operation:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserCode:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCRuleOperExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.IR.CRuleOperD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.IR.CRuleOper).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
		Set Type = obj.BTType
		If $IsObject(obj.BTHospGrpDr) {
			Set GrpID   = obj.BTHospGrpDr.%Id()  
			Set GrpCode = obj.BTHospGrpDr.BTCode
			Set GrpDesc = obj.BTHospGrpDr.BTDesc
	    }Else {
			Set (GrpID,GrpCode,GrpDesc)=""   
		}
		If $IsObject(obj.BTHospDr) {
			Set HospID   = obj.BTHospDr.%Id()  
			Set HospCode = obj.BTHospDr.BTCode
			Set HospDesc = obj.BTHospDr.BTDesc
	    }Else {
			Set (HospID,HospCode,HospDesc)=""   
		}
		If $IsObject(obj.BTLocDr) {
			Set LocID   = obj.BTLocDr.%Id()  
			Set LocCode = obj.BTLocDr.BTCode
			Set LocDesc = obj.BTLocDr.BTDesc
			Set LocDesc2 = obj.BTLocDr.BTDesc2
			Set:LocDesc2'="" LocDesc=LocDesc2
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	    }Else {
			Set (LocID,LocCode,LocDesc)=""   
		}
		
		//手术切口
	 	Set IncID="",IncCode="",IncDesc=""
	 	If $IsObject(obj.BTIncisionDr) {
			Set IncID	= obj.BTIncisionDr.%Id()
			Set IncCode	= obj.BTIncisionDr.BTCode
			Set IncDesc	= obj.BTIncisionDr.BTDesc	
		}
		//手术字典
		If $IsObject(obj.BTOperDxDr){
			Set OperDxID=obj.BTOperDxDr.%Id()
			Set Operation=obj.BTOperDxDr.BTOperDesc
		} Else {
			//手术名称（自定义）
			Set OperDxID=""
			Set Operation=obj.BTOperation
		}
		
	 	Set IsActive    = obj.BTIsActive
		Set ActDate     = obj.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime     = obj.BTActTime
		Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUserID="",ActUserCode="",ActUserDesc=""
		If $IsObject(obj.BTActUserDr) {
			Set ActUserID   = obj.BTActUserDr.%Id()
			Set ActUserCode = obj.BTActUserDr.BTCode
			Set ActUserDesc = obj.BTActUserDr.BTDesc
		}
		
		Set Data=$lb(xID,Type,GrpID,GrpDesc,HospID,HospDesc,LocID,LocDesc,IncID,IncCode,IncDesc,OperDxID,Operation,IsActive,ActDate,ActTime,ActUserID,ActUserCode,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCRuleOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCRuleOperExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCRuleOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCRuleOperExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2017-08-30
/// Description:  查询手术关键词列表
/// Table：       DHCHAI.IR.CRuleOper、DHCHAI.IR.CRuleOperKeys
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CRuleOperSrv","QryCRuleOperKeys",2)
Query QryCRuleOperKeys(aOperID As %String) As %Query(ROWSPEC = "ID:%String,OperID:%String,OperDesc:%String,InWord:%String,ExWords:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserCode:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCRuleOperKeysExecute(ByRef qHandle As %Binary, aOperID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aOperID="" $$$OK
 	
 	Set xInWord=""
 	For {
		Set xInWord=$o(^DHCHAI.IR.CRuleOperKeysI("IndexOperDrInWord",aOperID,xInWord))
		Quit:xInWord=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CRuleOperKeysI("IndexOperDrInWord",aOperID,xInWord,xID))
			Quit:xID=""
			
	 		Set obj=##class(DHCHAI.IR.CRuleOperKeys).GetObjById(xID)
	 		Continue:'$IsObject(obj)
	 		Continue:'$IsObject(obj.BTOperDr)
	 		Set InWord=obj.BTInWord
	 		Continue:InWord=""
	 		
	 		Set ExWords=""
	 		Set ExWordList=obj.BTExWords
	 		For indEx=1:1:$ll(ExWordList) {
		 		Set ExWord=$listget(ExWordList,indEx)
		 		Continue:ExWord=""
		 		Set ExWords=ExWords_","_ExWord
		 	}
		 	Set:ExWords'="" ExWords=$e(ExWords,2,$l(ExWords))
		 	Set ActDate     = obj.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime     = obj.BTActTime
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set ActUserID="",ActUserCode="",ActUserDesc=""
			If $IsObject(obj.BTActUserDr) {
				Set ActUserID   = obj.BTActUserDr.%Id()
				Set ActUserCode = obj.BTActUserDr.BTCode
				Set ActUserDesc = obj.BTActUserDr.BTDesc
			}
			
			Set OperID=obj.BTOperDr.%Id()
			Set OperDesc=obj.BTOperDr.BTOperation
			
			Set Data=$lb(xID,OperID,OperDesc,InWord,ExWords,ActDate,ActTime,ActUserID,ActUserCode,ActUserDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCRuleOperKeysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCRuleOperKeysExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCRuleOperKeysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCRuleOperKeysExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2017-12-18
/// Description:  根据手术筛查规则维护判断是否手术科室
/// Table：       DHCHAI.IR.CRuleOper
/// Input：       aLocDr : 科室ID
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CRuleOperSrv).CheckIsOper(9)
ClassMethod CheckIsOper(aLocDr As %String) As %String
{
	New (aLocDr)
	Set return=0
	Quit:aLocDr="" return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocDr)
	Quit:'$IsObject(objLoc) return
	Quit:'$IsObject(objLoc.BTHospDr) return
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) return
	Set aHospDr=objLoc.BTHospDr.%Id()
	Set aHospGrpDr=objLoc.BTHospDr.BTGroupDr.%Id()
    Set IRCRuleOperFlag=##class(DHCHAI.BT.Config).GetValByCode("IRCRuleOperFlag") //手术筛查规则启用标志
 	Quit:IRCRuleOperFlag'=1 1
 	
	If $d(^DHCHAI.IR.CRuleOperI("IndexTypeLocDr",3,aLocDr)) {
		Set ID=$o(^DHCHAI.IR.CRuleOperI("IndexTypeLocDr",3,aLocDr,0))
		Set objCROper=##class(DHCHAI.IR.CRuleOper).GetObjById(ID)
		If $IsObject(objCROper) {
			Quit:objCROper.BTIsActive'=1 return
			Quit:'$IsObject(objCROper.BTLocDr) return
			Set LocDr=objCROper.BTLocDr.%Id()
			Quit:LocDr'=aLocDr return
			Set return=1
		}
	}
	
	If $d(^DHCHAI.IR.CRuleOperI("IndexTypeHospDr",2,aHospDr)) {
		Set ID=$o(^DHCHAI.IR.CRuleOperI("IndexTypeHospDr",2,aHospDr,0))
		Set objCROper=##class(DHCHAI.IR.CRuleOper).GetObjById(ID)
		If $IsObject(objCROper) {
			Quit:objCROper.BTIsActive'=1 return
			Quit:'$IsObject(objCROper.BTHospDr) return
			Set HospDr=objCROper.BTHospDr.%Id()
			Quit:HospDr'=aHospDr return
			Set return=1
		}
	}
	
	If $d(^DHCHAI.IR.CRuleOperI("IndexTypeHospGrpDr",1,aHospGrpDr)) {
		Set ID=$o(^DHCHAI.IR.CRuleOperI("IndexTypeHospGrpDr",1,aHospGrpDr,0))
		Set objCROper=##class(DHCHAI.IR.CRuleOper).GetObjById(ID)
		If $IsObject(objCROper) {
			Quit:objCROper.BTIsActive'=1 return
			Quit:'$IsObject(objCROper.BTHospGrpDr) return
			Set HospGrpDr=objCROper.BTHospGrpDr.%Id()
			Quit:HospGrpDr'=aHospGrpDr return
			Set return=1
		}
	
	}
	
	If ('$d(^DHCHAI.IR.CRuleOperI))&&(IRCRuleOperFlag=1) {   //初始未配置情况
		Set obj=##class(DHCHAI.BT.Location).GetObjById(aLocDr)
	 	Quit:'$IsObject(obj) return
	 	Quit:obj.BTIsActive'=1 return
	 	Quit:obj.BTIsOPER'=1 return //非手术科室 排除
	 	Set return=1
		
	}
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-22
/// Description:  查询手术切口调查科室
/// Table：       DHCHAI.BT.Location
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CRuleOperSrv","QryOperLocList","")
Query QryOperLocList(aHospIDs As %String = "") As %Query(ROWSPEC = "ID:%String,LocCode:%String,LocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOperLocListExecute(ByRef qHandle As %Binary, aHospIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set tHospID=$p(aHospIDs,"|",1)
 	Set:tHospID="" tHospID=$p(aHospIDs,"|",2)
	Set DisplayLocType=##class(DHCHAI.BT.Config).GetValByCode("OPSDisplayLocType",tHospID)
 	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.BT.LocationD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.BT.Location).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Continue:obj.BTIsActive'=1
	 	Continue:obj.BTIsOPER'=1 //非手术科室 排除
	 	Continue:(aHospIDs'="")&&(("|"_aHospIDs_"|")'[("|"_obj.BTHospDr.%Id()_"|"))  //院区过滤
	 	If DisplayLocType="W" {
		 	Continue:obj.BTTypeDr.BTCode'="W"   // 病区
	 	} Else {
		 	Continue:obj.BTTypeDr.BTCode'="E"   // 科室
		}
		Continue:obj.BTCateDr.BTCode'="I"   // 住院
		Set IsOper=..CheckIsOper(xID)
	    Continue:IsOper'=1 //检查手术筛查规则
		
	 	Set OperCode=obj.BTCode
	 	Set OperDesc=obj.BTDesc
	 	Set OperDesc2=obj.BTDesc2
		Set:OperDesc2'="" OperDesc=OperDesc2
		Set:OperDesc["-" OperDesc=$p(OperDesc,"-",2)
	 	Continue:OperDesc["停用"
		Set Data=$lb(xID,OperCode,OperDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOperLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOperLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperLocListExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}

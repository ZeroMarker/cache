/// 住院体检其它数据设置，总检会诊费人员设置、会诊费医嘱、会诊费接受科室、默认会诊费、住院医生（不允许提交）
Class web.DHCPE.CT.OtherPatientToHPBaseSet Extends (%RegisteredObject, %XML.Adaptor)
{

// 设置职称和会诊医嘱的对应

/// Description: 设置职称和会诊医嘱的对应
/// Table：会诊费收费项目设置 User.DHCPEOthPatToHPBaseCPT 
/// Input: CarPrvTpID医护人员类型, LocID 科室ID, OrderID会诊项目（医嘱项）, tableName 表名, UserID 用户,Empower
/// Return：成功：表的ID  失败：-1^错误描述
/// Creator：sxt 
/// CreatDate：20210812
/// dubug: w ##class(web.DHCPE.CT.OtherPatientToHPBaseSet).SetCarPrvTpConOrder("21","152","10121||1","Y","13811","12")
ClassMethod SetCarPrvTpConOrder(CarPrvTpID, LocID, OrderID, Active, UserID, RowID, SessionUserID)
{
	s ^DHCPERecord("SetCarPrvTpConOrder")=$lb(CarPrvTpID, LocID, OrderID, Active, UserID,RowID,SessionUserID)
	s HPBUserDR=""
	
	s $ZT="SetCarPrvTpConOrderErr"
    s result=1
    
	if (RowID=""){
		s obj=##Class(User.DHCPEOthPatToHPBase).%New()	
	}
	else{
		s OldRecord=$ListToString($g(^CF.PE.OthPatToHPBaseD(RowID)))
		s obj=##class(User.DHCPEOthPatToHPBase).%OpenId(RowID)
		s HPBUserDR=obj.HPBHPBUserDR
	
	}
	q:(HPBUserDR'=UserID)&&($d(^CF.PE.OthPatToHPBaseI("IdxOfLocHPBUser"," "_LocID," "_UserID))) "-1^医护人员重复!"
	s obj.HPBLocDR=LocID
	s obj.HPBHPBUserDR=UserID
	s obj.HPBCarPrvTpDR=CarPrvTpID
	s obj.HPBNoActive=Active
	s obj.HPBHPBItemDR=OrderID
	s obj.HPBUpdateDate=+$H
	s obj.HPBUpdateTime=$p($h,",",2)
	s obj.HPBUpdateUserDR=SessionUserID
	TSTART
	s sc=obj.%Save()
	d obj.%Close()
	if ($System.Status.IsError(sc)){
		s result="-1^保存数据失败"
        goto SetCarPrvTpConOrderErr
	}
	else{
		 s ID=obj.%Id()
		if (RowID=""){	
   	    	s OldRecord=""
   	    	s NewRecord=$ListToString($g(^CF.PE.OthPatToHPBaseD(ID)))
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_OthPatToHPBase",ID,"I",OldRecord,NewRecord,SessionUserID)
   	    
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto SetCarPrvTpConOrderErr
			}
   	    }else{
   	    	s NewRecord=$ListToString($g(^CF.PE.OthPatToHPBaseD(ID)))
   	    	if (OldRecord'=NewRecord) {
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_OthPatToHPBase",ID,"U",OldRecord,NewRecord,SessionUserID)
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        			goto SetCarPrvTpConOrderErr
				}
   	    	}
   	    }	  
		
	}
	TCommit
       s result="0^保存数据成功"
       q result  
SetCarPrvTpConOrderErr
	TROLLBACK 
	//q $ZE
    q result
}

ClassMethod SetCarPrvTpConOrderbak(CarPrvTpID, LocID, OrderID, tableName, UserID, Empower As %String = "N")
{
	s ^DHCPERecord("SetCarPrvTpConOrder")=$lb(CarPrvTpID, LocID, OrderID, tableName, UserID)
	/// 站点是空的标识总检的
	s Parref=$o(^CF.PE.OthPatToHPBaseI("IdxOfLocStation"," "_LocID,-100000000000000,0))
	q:(Parref="") "-1^还未创建总检会诊费人员"
	TS
	
	s ID=$o(^CF.PE.OthPatToHPBaseI("CPT","IdxOfCPTCarPrv",Parref," "_CarPrvTpID,0))
	if (ID=""){
		s obj=##Class(User.DHCPEOthPatToHPBaseCPT).%New()
		d obj.ParRefSetObjectId(Parref)
	}
	else{
		s obj=##class(User.DHCPEOthPatToHPBaseCPT).%OpenId(Parref_"||"_ID)
	
	}
	s obj.HPBCarPrvTpDR=CarPrvTpID
	s obj.HPBArcimDR=OrderID
	s sc=obj.%Save()
	d obj.%Close()
	if ($System.Status.IsError(sc)){
		TRO
		q "-1^"_$System.Status.GetErrorText(sc)
	}
	else{
		
		
		s ret=##class(User.DHCPEOthPatToHPBaseCPT).SaveDataToPowerControl(obj.%Id(),LocID,UserID,Empower)
		if ($p(ret,"^",1)="-1"){
			tro
			q "-1^"_$p(ret,"^",2)
			
		}
		else{
			TC
		q obj.%Id()
		}
	}
}

// 设置默认会诊医嘱，对应职称没设置会诊费时使用，没设置就不插入会诊费

/// Description: 设置默认会诊医嘱，对应职称没设置会诊费时使用，没设置就不插入会诊费
/// Table：会诊费收费设置 User.DHCPEOthPatToHPBase 
/// Input: LocID 科室, OrderID 总检会诊项目（医嘱项） 指向ARC_ItmMast , tableName DHC_PE_OthPatToHPBase, UserID
/// Return：成功：表的ID  失败：-1^错误描述
/// Creator：sxt 
/// CreatDate：20210812
/// dubug: w ##class(web.DHCPE.CT.OtherPatientToHPBaseSet).SetConOrderDefault()
ClassMethod SetConOrderDefault(LocID, OrderID, tableName, UserID, Empower As %String = "N")
{
	TS
	/// 空的标识总检的
	s ID=$o(^CF.PE.OthPatToHPBaseI("IdxOfLocStation"," "_LocID,-100000000000000,0))
	
	if (ID=""){
		s obj=##Class(User.DHCPEOthPatToHPBase).%New()
	}
	else{
		s obj=##Class(User.DHCPEOthPatToHPBase).%OpenId(ID)
	}
	s obj.HPBHPBItemDR=OrderID
	s sc=obj.%Save()
	d obj.%Close()
	
	if ($System.Status.IsError(sc)){
		TRO
		q "-1^"_$System.Status.GetErrorText(sc)
	}
	else{
		s ret=##class(User.DHCPEOthPatToHPBase).SaveDataToPowerControl(obj.%Id(),LocID,UserID,Empower)
		b ; ret
   		//表记录授权插入数据失败
		If ($p(ret,"^",1)="-1")	 
		{ 
			 // 测试先注释了 
    		s ErrDesc="插入记录授权表失败"
    		tro
			q "-1^"_ErrDesc
	
		 }
		TC
		q obj.%Id()
		
	}
}

// 设置总检会诊费（初检提交时插入），没设置就不插入会诊费

/// Description: 设置总检会诊费（初检提交时插入），没设置就不插入会诊费
/// Table：会诊费收费设置 User.DHCPEOthPatToHPBase 
/// Input: LocID 科室, UserID 总检会诊费人员 , tableName DHC_PE_OthPatToHPBase, UserID
/// Return：成功：表的ID  失败：-1^错误描述
/// Creator：sxt 
/// CreatDate：20210812
/// dubug: w ##class(web.DHCPE.CT.OtherPatientToHPBaseSet).SetConOrderDefault()
ClassMethod SetGenConUser(LocID, UserID, ID, tableName, SessionUser, Active, Empower As %String = "N")
{
	TS
	if (ID=""){
		s obj=##Class(User.DHCPEOthPatToHPBase).%New()
	}
	else{
		s obj=##Class(User.DHCPEOthPatToHPBase).%OpenId(ID)
	}
	
	s obj.HPBLocDR=LocID
	s obj.HPBHPBUserDR=UserID
	s obj.HPBUpdateDate=+$H
	s obj.HPBUpdateTime=$P($h,",",2)
	s obj.HPBUpdateUserDR=%session.Get("LOGON.USERID")
	s obj.HPBNoActive=Active
	s sc=obj.%Save()
	d obj.%Close()
	if ($System.Status.IsError(sc)){
		TRO
		q "-1^"_$System.Status.GetErrorText(sc)
	}
	else{
		s ret=##class(User.DHCPEOthPatToHPBase).SaveDataToPowerControl(obj.%Id(),LocID,SessionUser,Empower)
		if ($p(ret,"^",1)="-1"){
			tro
			q ret
		
		}
		else{
			tc
			q obj.%Id()
		}
	}
}

// 设置提交站点时对应会诊费的接受科室,如果没设置提交时不插入会诊费

/// Description: 设置总检会诊费（初检提交时插入），没设置就不插入会诊费
/// Table：会诊费收费设置 User.DHCPEOthPatToHPBase 
/// Input: LocID 科室, StationID 站点id, RecLocID 接收科室^医生ID, ID,tablename 表名User.DHCPEOthPatToHPBase ,UserID
/// Return：成功：表的ID  失败：-1^错误描述
/// Creator：sxt 
/// CreatDate：20210812
/// dubug: w ##class(web.DHCPE.CT.OtherPatientToHPBaseSet).SetStationConRecLoc()
/// / LocID,StationID,RecLocID,StationHPBID,session['LOGON.USERID'],ActiveFlag
ClassMethod SetStationConRecLoc(LocID, StationID, RecLocID, ID, UserID, ActiveFlag)
{
	s $ZT="SetStationConRecLocErr"
    s result=1
    
	if (ID=""){
		s obj=##Class(User.DHCPEOthPatToHPBase).%New()
	}
	else{
		s OldRecord=$ListToString($g(^CF.PE.OthPatToHPBaseD(ID)))
		s obj=##Class(User.DHCPEOthPatToHPBase).%OpenId(ID)
	}
	
	
	s obj.HPBLocDR=LocID
	s obj.HPBRecDocDR=UserID
	s obj.HPBRecLocDR=RecLocID
	d obj.HPBStationDRSetObjectId(StationID)
	s obj.HPBUpdateDate=+$H
	s obj.HPBUpdateTime=$P($h,",",2)
	s obj.HPBUpdateUserDR=%session.Get("LOGON.USERID")
	s obj.HPBNoActive=ActiveFlag
	
	TSTART
	s sc=obj.%Save()
	d obj.%Close()
	if ($System.Status.IsError(sc)){
		s result="-1^保存数据失败"
        goto SetStationConRecLocErr
	}
	else{
		s RowID=obj.%Id()
		 if (ID=""){	
   	    	s OldRecord=""
   	    	s NewRecord=$ListToString($g(^CF.PE.OthPatToHPBaseD(RowID)))
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_OthPatToHPBase",RowID,"I",OldRecord,NewRecord,UserID)
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto SetStationConRecLocErr
			}
   	    }else{
   	    	s NewRecord=$ListToString($g(^CF.PE.OthPatToHPBaseD(RowID)))
   	    	if (OldRecord'=NewRecord) {
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_OthPatToHPBase",RowID,"U",OldRecord,NewRecord,UserID)
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        			goto SetStationConRecLocErr
				}
   	    	}
   	    }	  
		
	}
	
	TCommit
      s result="0^保存数据成功"
      q result  
SetStationConRecLocErr
	TROLLBACK 
    q result
}

// 设置某些人员为住院医生、如果为住院医生、不允许体检录入提交

ClassMethod SetInDoc(LocID, UserID, DeleteFlag As %String = "N")
{
	
	i DeleteFlag="Y" d
	.k ^DHCPEOtherPatientToHPBase("InDoc",LocID,UserID)
	e  d
	.s ^DHCPEOtherPatientToHPBase("InDoc",LocID,UserID)=""
	q 0
}

Query FindInDoc(curLoc) As %Query(ROWSPEC = "UserID:%String,UserCode:%String,UserName:%String")
{
}

ClassMethod FindInDocExecute(ByRef qHandle As %Binary, curLoc) As %Status
{
	Set repid=$I(^CacheTemp)
	//s curLoc=%session.Get("LOGON.CTLOCID")
 	s ind=1
 	s UserID=""
 	f  s UserID=$O(^DHCPEOtherPatientToHPBase("InDoc",curLoc,UserID)) q:UserID=""  d
 	.s UserCode=$P($g(^SSU("SSUSR",UserID)),"^",1)
 	.s UserName=$P($g(^SSU("SSUSR",UserID)),"^",2)
 	.d FindBuild	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(UserID,UserCode,UserName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInDocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindInDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query LookUpWithType(val As %String, date As %Library.String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,hidden,Code:%String,IntType:%String")
{
SELECT CTCPT_Desc, CTCPT_RowID As RowID, CTCPT_Code, CTCPT_InternalType
FROM SQLUser.CT_CarPrvTp
WHERE ((CTCPT_Desc %STARTSWITH :val) OR (CTCPT_Code =:val))
 AND ((:date IS NULL) OR ((CTCPT_DateFrom IS NULL OR CTCPT_DateFrom <= :date) AND (CTCPT_DateTo IS NULL OR CTCPT_DateTo >= :date)))
AND (CTCPT_InternalType="DOCTOR")
ORDER BY CTCPT_Desc
}

/// /d ##class(%ResultSet).RunQuery("web.DHCPE.CT.OtherPatientToHPBaseSet","FindCarPrvTpNew","","B","152","2")
Query FindCarPrvTpNew(Desc As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Query(ROWSPEC = "CarPrvTpID:%String:ID,Desc:%String:姓名")
{
}

ClassMethod FindCarPrvTpNewExecute(ByRef qHandle As %Binary, Desc As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
	 //s ^tempdhcpe("SearchUSERSXT",LocID,hospId)=$lb(Desc,Type,LocID,hospId)
    s ind=1
    s i=2
	Set repid=$I(^CacheTemp)
 	
 	s id=0
	f  s id=$O(^CT("CPT",id)) q:id=""  d
	.s DocName=$p($g(^CT("CPT",id)),"^",2)  //医护人员类型
    .s InternalType=$p($g(^CT("CPT",id)),"^",4) 
    .s Active=$p($g(^CT("CPT",id)),"^",3)  //激活
    .q:InternalType'="DOCTOR"
    .q:(Active'="Y")
    .s DateFrom=$p($g(^CT("CPT",id)),"^",5)
    .q:DateFrom=""
    .q:(DateFrom'="")&&(DateFrom>+$H) 
    .s DateTo=$p($g(^CT("CPT",id)),"^",6)
    .i DateTo="" s DateTo=+$H+1
	.q:DateTo<+$H
 	.
	.d DoctorWorkStatisticOut2
   	.s DocName="",CurData="",Initials=""
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
DoctorWorkStatisticOut2
    s Data=$LB(id,DocName)
    Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCarPrvTpNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCarPrvTpNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCarPrvTpNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCarPrvTpNewExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.OtherPatientToHPBaseSet","FindCarPrvTp",152,"Y")
Query FindCarPrvTp(curLoc, Active) As websys.Query(ROWSPEC = "RowID:%String,TypeDesc:%String,ARCIMDesc:%String,UserName:%String,CurActiveDesc:%String,ARCIMID:%String,Type:%String,RealUserID:%String")
{
}

ClassMethod FindCarPrvTpExecute(ByRef qHandle As %Binary, curLoc, Active) As %Status
{
	s ^tempdhcpe("FindCarPrvTp")=curLoc
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
   
    s GenHPBID=$o(^CF.PE.OthPatToHPBaseI("IdxOfLocStation"," "_curLoc,-100000000000000,0))
    if (GenHPBID=""){
	    //Set qHandle=$lb(0,repid,0)
		//Quit $$$OK
	  }
    
    /// ^CF.PE.OthPatToHPBaseI("IdxOfLocCarPrvTp",HPBLocDR, HPBCarPrvTpDR
    s QUserID=""
    f  s QUserID=$o(^CF.PE.OthPatToHPBaseI("IdxOfLocHPBUser"," "_curLoc,QUserID)) q:(QUserID="")  d
    .s RealUserID=$replace(QUserID," ","")
    .q:(RealUserID="")
    .s RowID=$o(^CF.PE.OthPatToHPBaseI("IdxOfLocHPBUser"," "_curLoc,QUserID,0))
    .q:(RowID="")
    .s CurActiveDesc=""
    .s CurActive=$lg(^CF.PE.OthPatToHPBaseD(RowID),8)
    .q:(CurActive'=Active)
    .s:(CurActive="Y") CurActiveDesc="是"
    .s:(CurActive="N") CurActiveDesc="否"
    .s ARCIMDesc=""
    .s ARCIMID=$lg(^CF.PE.OthPatToHPBaseD(RowID),7)
    .q:(ARCIMID="")
    .S ARCIMDesc=$P($g(^ARCIM(+ARCIMID,1,1)),"^",2)  //项目
    .q:(ARCIMDesc="")
    .s Type=$lg(^CF.PE.OthPatToHPBaseD(RowID),12)
    .q:(Type="") 
    .s TypeDesc=$p($g(^CT("CPT",Type)),"^",2)
    .b
    .s UserName=$P($g(^SSU("SSUSR",RealUserID)),"^",2)
    .//q:(ARCIMDesc="")
    .s ^CacheTemp(repid,ind)=$lb(RowID,TypeDesc,ARCIMDesc,UserName,CurActiveDesc,ARCIMID,Type,RealUserID)
	.s ind=ind+1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    /*
    s DefaultARCIMDesc="",DefaultItem=""
    i GenHPBID'="" d
    .s DefaultItem=$Lg(^CF.PE.OthPatToHPBaseD(GenHPBID),7)
    .s:(DefaultItem'="") DefaultARCIMDesc=$P($g(^ARCIM(+DefaultItem,1,1)),"^",2)
    .
    .
    
    s id=0
	f  s id=$O(^CT("CPT",id)) q:id=""  d
	.s Desc=$p($g(^CT("CPT",id)),"^",2)  //医护人员类型
    .s InternalType=$p($g(^CT("CPT",id)),"^",4) 
    .s Active=$p($g(^CT("CPT",id)),"^",3)  //激活
    .q:InternalType'="DOCTOR"
    .q:(Active'="Y")
    .s DateFrom=$p($g(^CT("CPT",id)),"^",5)
    .q:DateFrom=""
    .q:(DateFrom'="")&&(DateFrom>+$H) 
    .s DateTo=$p($g(^CT("CPT",id)),"^",6)
    .i DateTo="" s DateTo=+$H+1
	.q:DateTo<+$H
	.s Sub=""
	.i GenHPBID'="" d
	..s ArcItmID=$o(^CF.PE.OthPatToHPBaseI("CPT","IdxOfCPTItem",GenHPBID," "_id,0))
	..s:(ArcItmID'="") Sub=$o(^CF.PE.OthPatToHPBaseI("CPT","IdxOfCPTItem",GenHPBID," "_id,ArcItmID,0))
	.s CTPID="" 
	.s:(Sub'="") CTPID=GenHPBID_"||"_Sub
    .s ARCIMID=$lg($g(^CF.PE.OthPatToHPBaseD(+GenHPBID,"CPT",+Sub)),3)
    .s ARCIMDesc=""
    .i ARCIMID'="" S ARCIMDesc=$P($g(^ARCIM(+ARCIMID,1,1)),"^",2)  //项目
    .s DefaultItem=$g(^DHCPEOtherPatientToHPBase("ConOrderDefault",curLoc))
   
	.s ^CacheTemp(repid,ind)=$lb($g(id),Desc,InternalType,ARCIMDesc,DefaultARCIMDesc,ARCIMID,DefaultItem,CTPID,GenHPBID,Active)
	.s ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	*/
}

/*
Query FindCarPrvTp(curLoc) As websys.Query(ROWSPEC = "CarPrvTpID:%String,CarPrvTpDesc:%String,InternalType:%String,ARCIMDesc:%String,DefaultARCIMDesc:%String,ARCIMID:%String,DefaultARCIMID:%String,TEmpowerFlag:%String,TGenEmpowerFlag:%String,CPTID:%String,HPBID:%String")
{
}

ClassMethod FindCarPrvTpExecute(ByRef qHandle As %Binary, curLoc) As %Status
{
	s ^tempdhcpe("FindCarPrvTp")=curLoc
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
   
    s GenHPBID=$o(^CF.PE.OthPatToHPBaseI("IdxOfLocStation"," "_curLoc,-100000000000000,0))
    if (GenHPBID=""){
	    //Set qHandle=$lb(0,repid,0)
		//Quit $$$OK
	  }
    
    s DefaultARCIMDesc="",DefaultItem=""
    i GenHPBID'="" d
    .s DefaultItem=$Lg(^CF.PE.OthPatToHPBaseD(GenHPBID),7)
    .s:(DefaultItem'="") DefaultARCIMDesc=$P($g(^ARCIM(+DefaultItem,1,1)),"^",2)
    
    s id=0
	f  s id=$O(^CT("CPT",id)) q:id=""  d
	.s Desc=$p($g(^CT("CPT",id)),"^",2)
    .s InternalType=$p($g(^CT("CPT",id)),"^",4)
    .s Active=$p($g(^CT("CPT",id)),"^",3)
    .q:InternalType'="DOCTOR"
    .q:(Active'="Y")
    .s DateFrom=$p($g(^CT("CPT",id)),"^",5)
    .q:DateFrom=""
    .q:(DateFrom'="")&&(DateFrom>+$H) 
    .s DateTo=$p($g(^CT("CPT",id)),"^",6)
    .i DateTo="" s DateTo=+$H+1
	.q:DateTo<+$H
	.s Sub=""
	.i GenHPBID'="" d
	..s ArcItmID=$o(^CF.PE.OthPatToHPBaseI("CPT","IdxOfCPTItem",GenHPBID," "_id,0))
	..s:(ArcItmID'="") Sub=$o(^CF.PE.OthPatToHPBaseI("CPT","IdxOfCPTItem",GenHPBID," "_id,ArcItmID,0))
	.s CTPID="" 
	.s:(Sub'="") CTPID=GenHPBID_"||"_Sub
    .s ARCIMID=$lg($g(^CF.PE.OthPatToHPBaseD(+GenHPBID,"CPT",+Sub)),3)
    .s ARCIMDesc=""
    .i ARCIMID'="" S ARCIMDesc=$P($g(^ARCIM(+ARCIMID,1,1)),"^",2)
    .s DefaultItem=$g(^DHCPEOtherPatientToHPBase("ConOrderDefault",curLoc))
    .s TEmpowerFlag=$p(##class(User.DHCPEOthPatToHPBaseCPT).GetEmpowerFlag(GenHPBID_"||"_Sub,curLoc),"^",2)
    .s TGenEmpowerFlag=$p(##class(User.DHCPEOthPatToHPBase).GetEmpowerFlag(GenHPBID,curLoc),"^",2)
	.s ^CacheTemp(repid,ind)=$lb($g(id),Desc,InternalType,ARCIMDesc,DefaultARCIMDesc,ARCIMID,DefaultItem,TEmpowerFlag,TGenEmpowerFlag,CTPID,GenHPBID)
	.s ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}
*/
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.OtherPatientToHPBaseSet","FindStation",304)
Query FindStation(curLoc) As websys.Query(ROWSPEC = "StationID:%String,StationDesc:%String,RecLocDesc:%String,DefaultDoc:%String,GenConUserDesc:%String,GenConUserID:%String,ReclocID:%String,UserID:%String,HPBID:%String,GenHPBID:%String,TActiveFlag:%String,TEmpowerFlag:%String,TGenActiveFlag:%String,TGenEmpowerFlag:%String")
{
}

ClassMethod FindStationExecute(ByRef qHandle As %Binary, curLoc) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    //s curLoc=%session.Get("LOGON.CTLOCID") 
    s ^DHCPERecord("FindStationExecute")=curLoc
    s id=0
	f  s id=$O(^DHCPEST(id)) q:id=""  d
	.s Desc=$p($g(^DHCPEST(id)),"^",2)
    .s Code=$p($g(^DHCPEST(id)),"^",1)
    .s Active=$p($g(^DHCPEST(id)),"^",5)
    .q:(Active'="Y")
    .s HPBID=$o(^CF.PE.OthPatToHPBaseI("IdxOfLocStation"," "_curLoc,id,0))
    .b:(id=6)
    .
    .s ConRecLocInfo=""
    .s:(HPBID'="") ConRecLocInfo=$g(^CF.PE.OthPatToHPBaseD(HPBID)) //$G(^DHCPEOtherPatientToHPBase("ConRecLoc",curLoc,id))
    .s ReclocID=""
    .s ReclocID=$lg(ConRecLocInfo,4)
    .s ReclocDesc=""
    .i ReclocID'="" s ReclocDesc=$P($g(^CTLOC(ReclocID)),"^",2)
    .s UserID=""
    .s UserID=$lg(ConRecLocInfo,5)
    .s UserName=""
    .i UserID'="" s UserName=$P($g(^SSU("SSUSR",UserID)),"^",2)
    .s TActiveFlag="N",TEmpowerFlag=""
    .i HPBID'="" d
    ..s TActiveFlag=$lg($g(^CF.PE.OthPatToHPBaseD(HPBID)),8)
    ..s TEmpowerFlag=$p(##class(User.DHCPEOthPatToHPBase).GetEmpowerFlag(HPBID,curLoc),"^",2)
    .
    .s HPBGenID=$o(^CF.PE.OthPatToHPBaseI("IdxOfLocStation"," "_curLoc,-100000000000000,0))
    .s GenConUserDesc="",TGenActiveFlag="N",TGenEmpowerFlag=""
    .i HPBGenID'="" d
    ..s GenUserID=$lg($g(^CF.PE.OthPatToHPBaseD(HPBGenID)),6)
    ..s TGenActiveFlag=$lg($g(^CF.PE.OthPatToHPBaseD(HPBGenID)),8)
    ..s TGenEmpowerFlag=$p(##class(User.DHCPEOthPatToHPBase).GetEmpowerFlag(HPBGenID,curLoc),"^",2)
    ..s GenConUserDesc=$P($g(^SSU("SSUSR",GenUserID)),"^",2)
	.s ^CacheTemp(repid,ind)=$lb($g(id),Desc,ReclocDesc,UserName,GenConUserDesc,GenUserID,ReclocID,UserID,HPBID,HPBGenID,TActiveFlag,TEmpowerFlag,TGenActiveFlag,TGenEmpowerFlag)
	.s ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}

Class DHCDoc.OPAdm.ScheduleTemplateConfig Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// creator:屈坚
/// date:2020-10-12
/// desc:排班拓展设置
Query GetScheduleTemplateConfigList(HospId As %String = "") As %Query(ROWSPEC = "RowID:%String,STCCode:%String,STCDesc:%String,STCType:%String,STCFatherCode:%String,STCDataTemp:%String,STCDataTempDesc:%String,STCDataTempGlobal:%String,STCTypeDesc:%String,STCDataMultCheck:%String,STCDataHospShow:%String ")
{
}

ClassMethod GetScheduleTemplateConfigListExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.ScheduleTemplateConfig","GetScheduleTemplateConfigList",2)
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
    s RowID=""
    for {
	    s RowID=$O(^DHCSCHEDULETEMPCONi("HospID",HospId,RowID))
	    q:RowID=""
	   	s STCHospDr=$p(^DHCSCHEDULETEMPCON(RowID),"^",8)
		s STCCode=$p(^DHCSCHEDULETEMPCON(RowID),"^",1)
	    s STCDesc=$p(^DHCSCHEDULETEMPCON(RowID),"^",2)
	    s STCType=$p(^DHCSCHEDULETEMPCON(RowID),"^",3)
	    continue:((STCType="Order")||(STCType="Diag"))
	    s STCTypeDesc=$case(STCType,"text":"文本","checkbox":"勾选框","combobox-sub":"下拉框关联子数据","combobox-data":"下拉框关联字典表","sub":"子数据",:"")
	    s STCFatherCode=$p(^DHCSCHEDULETEMPCON(RowID),"^",4)
	    s STCDataTemp=$p(^DHCSCHEDULETEMPCON(RowID),"^",5)
	    s STCDataTempDesc=$p(^DHCSCHEDULETEMPCON(RowID),"^",6)
	    s STCActive=$p(^DHCSCHEDULETEMPCON(RowID),"^",7)
	    s STCDataTempGlobal=$p(^DHCSCHEDULETEMPCON(RowID),"^",9)
	    continue:STCActive'="Y"
	    s STCDataMultCheck=$p(^DHCSCHEDULETEMPCON(RowID),"^",10)
	    s STCDataHospShow=$g(^DHCSCHEDULETEMPCON(RowID,"hospshow"))
	    d OutputRowScheduleTemplateConfigList
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowScheduleTemplateConfigList
	set Data=$lb(RowID,STCCode,STCDesc,STCType,STCFatherCode,STCDataTemp,STCDataTempDesc,STCDataTempGlobal,STCTypeDesc,STCDataMultCheck,STCDataHospShow)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetScheduleTemplateConfigListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScheduleTemplateConfigListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetScheduleTemplateConfigListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScheduleTemplateConfigListExecute ]
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

/// w ##class(DHCDoc.OPAdm.ScheduleTemplateConfig).insert(^Tempscl("str"))
ClassMethod insert(Str As %String, HospId As %String = "", STCDataHospShow As %String = "") As %String
{
	s ^Tempscl("str")=Str
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	k PLIST
	s PLIST(2)=$p(Str,"^",1) //代码
	s PLIST(3)=$p(Str,"^",2) //描述
	s PLIST(4)=$p(Str,"^",3)
	s PLIST(5)=$p(Str,"^",4)
	s PLIST(6)=$p(Str,"^",5)
	s PLIST(7)=$p(Str,"^",6)
	s PLIST(8)="Y"
	s PLIST(9)=HospId
	s PLIST(10)=$p(Str,"^",7)
	s PLIST(11)=$p(Str,"^",8)
	s PLIST(12)=STCDataHospShow
	s PLIST(13)=$p(Str,"^",9)
	s PLIST(14)=$p(Str,"^",10)
	s count=0
	&sql(select count(RowID) into :count from SQLUser.DHCScheduleTemplateConfig where STCCode=:PLIST(2) 
	and STCDesc=:PLIST(3) and STCType=:PLIST(4) and STCFatherCode=:PLIST(5)
	and  STCDataTemp=:PLIST(6)and  STCDataTempDesc=:PLIST(7) and  STCActive=:PLIST(8) and STCHospDr=:HospId 
	and STCArcimDr=:PLIST(13) and STCICDDr=:PLIST(14))
	if (PLIST(4)="Diag"){
		&sql(select count(RowID) into :count from SQLUser.DHCScheduleTemplateConfig where STCActive=:PLIST(8) and STCHospDr=:HospId 
		and STCICDDr=:PLIST(14))
		Q:count'=0 "记录重复!"
		}
	if (PLIST(4)="Order"){
		&sql(select count(RowID) into :count from SQLUser.DHCScheduleTemplateConfig where STCActive=:PLIST(8) and STCHospDr=:HospId 
		and STCArcimDr=:PLIST(13))
		Q:count'=0 "记录重复!"
		}
	Q:count'=0 "记录重复!"
	&sql(insert into SQLUser.DHCScheduleTemplateConfig values :PLIST())
	q SQLCODE
}

/// w ##class(DHCDoc.OPAdm.ScheduleTemplateConfig).delete(6)
ClassMethod delete(Rowid) As %String
{
	&sql(update SQLUser.DHCScheduleTemplateConfig set STCActive="N" where RowID=:Rowid)
    q SQLCODE
}

/// w ##class(DHCDoc.DHCDocConfig.PrescriptSet).Update(5,"藏药^藏药^CM^1^Y")
ClassMethod update(Rowid As %String, str As %String, STCDataHospShow As %String = "") As %String
{
	s STCHospDr=$p(^DHCSCHEDULETEMPCON(Rowid),"^",8)
	s STCCode=$p(str,"^",1)
    s STCDesc=$p(str,"^",2)
    s STCType=$p(str,"^",3)
    s STCFatherCode=$p(str,"^",4)
    s STCDataTemp=$p(str,"^",5)
    s STCDataTempDesc=$p(str,"^",6)
    s STCDataTempGlobal=$p(str,"^",7)
    s STCActive="Y"
    s count=0
    s STCDataMultCheck=$p(str,"^",8)
	s STCArcimDr=$p(str,"^",9)
    s STCICDDr=$p(str,"^",10)
    &sql(select count(RowID) into :count from SQLUser.DHCScheduleTemplateConfig where STCCode=:STCCode 
	and STCDesc=:STCDesc and STCType=:STCType and STCFatherCode=:STCFatherCode
	and  STCDataTemp=:STCDataTemp and  STCDataTempDesc=:STCDataTempDesc and  STCActive=:STCActive and STCHospDr=:STCHospDr and RowID<>:Rowid
	and STCArcimDr=:STCArcimDr and STCICDDr=:STCICDDr)
	Q:count'=0 "记录重复!"
	if (STCType="Diag"){
		&sql(select count(RowID) into :count from SQLUser.DHCScheduleTemplateConfig where STCActive=:STCActive and STCHospDr=:STCHospDr
		and STCICDDr=:STCICDDr and RowID<>:Rowid)
		Q:count'=0 "记录重复!"
		}
	if (STCType="Order"){
		&sql(select count(RowID) into :count from SQLUser.DHCScheduleTemplateConfig where STCActive=:STCActive and STCHospDr=:STCHospDr
		and STCArcimDr=:STCArcimDr and RowID<>:Rowid )
		Q:count'=0 "记录重复!"
		}
	&sql(update SQLUser.DHCScheduleTemplateConfig 
           set STCCode=:STCCode ,STCDesc=:STCDesc,STCType=:STCType , STCFatherCode=:STCFatherCode
		,  STCDataTemp=:STCDataTemp ,  STCDataTempDesc=:STCDataTempDesc,STCDataTempGlobal=:STCDataTempGlobal
           ,STCDataMultCheck =:STCDataMultCheck,STCDataHospShow=:STCDataHospShow 
           ,STCArcimDr=:STCArcimDr , STCICDDr=:STCICDDr
           where RowID=:Rowid )
      q SQLCODE
}

/// w ##class(DHCDoc.OPAdm.ScheduleTemplateConfig).GetScheduleConfigJson(2)
ClassMethod GetScheduleConfigJson(HospId)
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s retObj=[]
    s RowID=""
    for {
	    s RowID=$O(^DHCSCHEDULETEMPCONi("HospID",HospId,RowID))
	    q:RowID=""
	    s obj={}
	   	s STCHospDr=$p(^DHCSCHEDULETEMPCON(RowID),"^",8)
		s STCCode=$p(^DHCSCHEDULETEMPCON(RowID),"^",1)
	    s STCDesc=$p(^DHCSCHEDULETEMPCON(RowID),"^",2)
	    s STCType=$p(^DHCSCHEDULETEMPCON(RowID),"^",3)
	    continue:STCType="sub"
	    s STCActive=$p(^DHCSCHEDULETEMPCON(RowID),"^",7)
	    continue:STCActive'="Y"
	    s MultCheck=$p(^DHCSCHEDULETEMPCON(RowID),"^",10)
	    continue:((STCType="Order")||(STCType="Diag"))
	    s obj.id=RowID
	    s obj.code=STCCode
	    s obj.desc=STCDesc
	    s obj.type=STCType
	    s obj.MultCheck=MultCheck
	    s Data=[]
	    if (STCType="combobox-sub"){
		    s subrowid=""
		    for {
	    		s subrowid=$O(^DHCSCHEDULETEMPCONi("HospID",HospId,subrowid))
	    		q:subrowid=""
	     		s subrowidType=$p(^DHCSCHEDULETEMPCON(subrowid),"^",3)
	     		continue:subrowidType'="sub"
	     		s subMasterCode=$p(^DHCSCHEDULETEMPCON(subrowid),"^",4)
	     		continue:subMasterCode'=STCCode
	     		s subrowidDesc=$p(^DHCSCHEDULETEMPCON(subrowid),"^",2)
	     		s STCActive=$p(^DHCSCHEDULETEMPCON(subrowid),"^",7)
	    		continue:STCActive'="Y"
	     		s Dataobj={}
	     		s Dataobj.id=subrowid
	     		s Dataobj.desc=subrowidDesc
	     		d Data.%Push(Dataobj)
	    	}
	    	
		}elseif(STCType="combobox-data"){
			s xGlobal=$p(^DHCSCHEDULETEMPCON(RowID),"^",9)
			s DescProName=$p(^DHCSCHEDULETEMPCON(RowID),"^",6)
			s STCDataHospShow=$g(^DHCSCHEDULETEMPCON(RowID,"hospshow"))
			s tableName="SQLUser."_$p(^DHCSCHEDULETEMPCON(RowID),"^",5)
		   	s RowId=0            //原表内容
			 s sql=" select %id,"_ DescProName_" from " _tableName
			 s xrs=##class(%Library.ResultSet).%New()
			 d xrs.Prepare(sql)
			 s sc=xrs.Execute()
			 i $$$ISERR(sc) continue
			 while (xrs.Next())
			 {
				s Dataobj={}
				s ROWID=%ROWID 
				if ((STCDataHospShow'="")&&(ROWID'="")){
					s NowDesc=0
					s xfunction="if ("_STCDataHospShow_")  {s NowDesc=1}"
					x xfunction
					continue:(NowDesc=0)
					}
				
				s Dataobj.id=%ROWID
				s Dataobj.desc=xrs.Data(DescProName)
				d Data.%Push(Dataobj)
			 }
			
		}
		s obj.Data=Data
		d retObj.%Push(obj)
	}
	 s RowID=""
    for {
	    s RowID=$O(^DHCSCHEDULETEMPCONi("HospID",HospId,RowID))
	    q:RowID=""
	    s obj={}
	   	s STCHospDr=$p(^DHCSCHEDULETEMPCON(RowID),"^",8)
		s STCCode=$p(^DHCSCHEDULETEMPCON(RowID),"^",1)
	    s STCDesc=$p(^DHCSCHEDULETEMPCON(RowID),"^",2)
	    s STCType=$p(^DHCSCHEDULETEMPCON(RowID),"^",3)
	    continue:STCType="sub"
	    s STCActive=$p(^DHCSCHEDULETEMPCON(RowID),"^",7)
	    continue:STCActive'="Y"
	    s MultCheck=$p(^DHCSCHEDULETEMPCON(RowID),"^",10)
	    continue:((STCType'="Order"))
	    if (STCType="Order"){
		    s ARCIMDR=$p(^DHCSCHEDULETEMPCON(RowID),"^",11)
			s STCDesc="医嘱："_$p($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1)),"^",2)
			s STCCode=$p($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1)),"^",1)
			s STCType="checkbox"
		    }
	    s obj.id=RowID
	    s obj.code=STCCode
	    s obj.desc=STCDesc
	    s obj.type=STCType
	    s obj.MultCheck=MultCheck
	    s Data=[]
	    s obj.Data=Data
		d retObj.%Push(obj)
	 }
	 s RowID=""
    for {
	    s RowID=$O(^DHCSCHEDULETEMPCONi("HospID",HospId,RowID))
	    q:RowID=""
	    s obj={}
	   	s STCHospDr=$p(^DHCSCHEDULETEMPCON(RowID),"^",8)
		s STCCode=$p(^DHCSCHEDULETEMPCON(RowID),"^",1)
	    s STCDesc=$p(^DHCSCHEDULETEMPCON(RowID),"^",2)
	    s STCType=$p(^DHCSCHEDULETEMPCON(RowID),"^",3)
	    continue:STCType="sub"
	    s STCActive=$p(^DHCSCHEDULETEMPCON(RowID),"^",7)
	    continue:STCActive'="Y"
	    s MultCheck=$p(^DHCSCHEDULETEMPCON(RowID),"^",10)
	    continue:((STCType'="Diag"))
		if (STCType="Diag"){
		    s MRCDIADR=$p(^DHCSCHEDULETEMPCON(RowID),"^",12)
			s STCDesc="诊断："_$p(^MRC("ID",MRCDIADR),"^",2)
			s STCCode=$p(^MRC("ID",MRCDIADR),"^",1)
			s STCType="checkbox"
		    }
	    s obj.id=RowID
	    s obj.code=STCCode
	    s obj.desc=STCDesc
	    s obj.type=STCType
	    s obj.MultCheck=MultCheck
	    s Data=[]
	    s obj.Data=Data
		d retObj.%Push(obj)
	}
	Q retObj.%ToJSON()
}

/// 保存排班模板扩展设置
/// w ##class(DHCDoc.OPAdm.ScheduleTemplateConfig).SaveTempExtendConfig("2||1||8","","1"_$c(1)_"2"_$c(1)_"3"_$c(1)_"5","44"_$c(1)_"true"_$c(1)_"4"_$c(1)_"2")
ClassMethod SaveTempExtendConfig(SessRowid, RowIDStr, TypeIDStr, ValueStr) As %DynamicObject
{
	s ^tempqujian("SaveTempExtendConfig") =SessRowid_","_RowIDStr_","_TypeIDStr_","_ValueStr
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s rtn="0"
	for i=1:1:$l(TypeIDStr,$C(1)){
		s OneTypeID=$P(TypeIDStr,$C(1),i)
		s OneRowID=$P(RowIDStr,$C(1),i)
		s OneValue=$P(ValueStr,$C(1),i)
		if OneRowID=""{
			s AQECObj=##class(User.DHCRBResEffDateSessExtendConfig).%New(SessRowid)
			s AQECObj.AQECParRef=SessRowid
			s AQECObj.AQECResDR=ResRowid
			s AQECObj.AQECDateChildsub=DateSub
			s AQECObj.AQECSessChildsub=SessSub
		}else{
			s AQECObj=##class(User.DHCRBResEffDateSessExtendConfig).%OpenId(OneRowID)
		}
		d AQECObj.AQECTemplateConfigSetObjectId(OneTypeID)
		s AQECObj.AQECValue=OneValue
		s sc=AQECObj.%Save()
		if $$$ISERR(sc){
			s rtn="更新预约方式失败"
			Q
		}
	}
	q rtn
}

/// 展示排班模板扩展设置
/// w ##class(DHCDoc.OPAdm.ScheduleTemplateConfig).ShowTempExtendConfig("7||1||1")
ClassMethod ShowTempExtendConfig(SessRowid)
{
	s ^temequjian("ShowTempExtendConfig")=SessRowid
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s ChirdRowID=""
	s retObj=[]
	for{
		s ChirdRowID=$O(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQEC",ChirdRowID)) 
		Q:ChirdRowID=""  
		s TemplateConfigID=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQEC",ChirdRowID),"^",1)
		continue:TemplateConfigID=""
		s Value=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQEC",ChirdRowID),"^",2)
		s Type=$p(^DHCSCHEDULETEMPCON(TemplateConfigID),"^",3)
		s STCCode=$p(^DHCSCHEDULETEMPCON(TemplateConfigID),"^",1)
		s MultCheck=$p(^DHCSCHEDULETEMPCON(TemplateConfigID),"^",10)
		s STCActive=$p(^DHCSCHEDULETEMPCON(TemplateConfigID),"^",7)
	    continue:STCActive'="Y"
	    if (Type="Order"){
		    s ARCIMDR=$p(^DHCSCHEDULETEMPCON(TemplateConfigID),"^",11)
			s STCDesc="医嘱："_$p($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1)),"^",2)
			s STCCode=$p($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1)),"^",1)
			s Type="checkbox"
		    }
		if (Type="Diag"){
		    s MRCDIADR=$p(^DHCSCHEDULETEMPCON(TemplateConfigID),"^",12)
			s STCDesc="诊断："_$p(^MRC("ID",MRCDIADR),"^",2)
			s STCCode=$p(^MRC("ID",MRCDIADR),"^",1)
			s Type="checkbox"
		}
		s obj={}
		s obj.TemplateConfigID=TemplateConfigID
		s obj.STCCode=STCCode
	    s obj.Value=Value
	    s obj.Type=Type
	    s obj.RowID=SessRowid_"||"_ChirdRowID
	    s obj.MultCheck=MultCheck
	    d retObj.%Push(obj)
	}
	Q retObj.%ToJSON()
}

/// 保存排班扩展设置
/// w ##class(DHCDoc.OPAdm.ScheduleTemplateConfig).SaveASScheduleExtendConfig("3217||83","","1"_$c(1)_"2"_$c(1)_"3"_$c(1)_"5","44"_$c(1)_"true"_$c(1)_"4"_$c(1)_"2")
ClassMethod SaveASScheduleExtendConfig(ASRowid, RowIDStr, TypeIDStr, ValueStr) As %DynamicObject
{
	s ^tempqujian("SaveTempExtendConfig") =ASRowid_","_RowIDStr_","_TypeIDStr_","_ValueStr
	s rtn="0"
	for i=1:1:$l(TypeIDStr,$C(1)){
		s OneTypeID=$P(TypeIDStr,$C(1),i)
		s OneRowID=$P(RowIDStr,$C(1),i)
		s OneValue=$P(ValueStr,$C(1),i)
		if (OneRowID=""){
			s AMQObj=##class(User.DHCRBApptScheduleExtendConfig).%New(ASRowid)
			d AMQObj.ASQECASParRefSetObjectId(ASRowid)
		}else{
			s AMQObj=##class(User.DHCRBApptScheduleExtendConfig).%OpenId(OneRowID)
		}
		d AMQObj.ASQECTemplateConfigSetObjectId(OneTypeID)
		s AMQObj.ASQECValue=OneValue
		s sc=AMQObj.%Save()
		if $$$ISERR(sc){
			s rtn="更新预约方式失败"
			Q
		}
	}
	q rtn
}

/// 展示排班扩展设置
/// w ##class(DHCDoc.OPAdm.ScheduleTemplateConfig).ShowTempExtendConfig("2||1||8")
ClassMethod ShowASScheduleExtendConfig(ASRowid)
{
	s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
	s ASQSub=""
	s retObj=[]
	for{
		s ASQSub=$O(^RBAS(ResRowid,ASSub,"AQEC",ASQSub)) 
		Q:ASQSub=""
		s TemplateConfigID=$P(^RBAS(ResRowid,ASSub,"AQEC",ASQSub),"^",1)
		continue:TemplateConfigID=""
		s Value=$P(^RBAS(ResRowid,ASSub,"AQEC",ASQSub),"^",2)
		s Type=$p($g(^DHCSCHEDULETEMPCON(TemplateConfigID)),"^",3)
		s STCCode=$p($g(^DHCSCHEDULETEMPCON(TemplateConfigID)),"^",1)
		s STCActive=$p(^DHCSCHEDULETEMPCON(TemplateConfigID),"^",7)
	    continue:STCActive'="Y"
	    if (Type="Order"){
		    s ARCIMDR=$p(^DHCSCHEDULETEMPCON(TemplateConfigID),"^",11)
			s STCDesc="预开医嘱："_$p($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1)),"^",2)
			s STCCode=$p($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1)),"^",1)
			s Type="checkbox"
		    }
		if (Type="Diag"){
		    s MRCDIADR=$p(^DHCSCHEDULETEMPCON(TemplateConfigID),"^",12)
			s STCDesc="预开诊断："_$p(^MRC("ID",MRCDIADR),"^",2)
			s STCCode=$p(^MRC("ID",MRCDIADR),"^",1)
			s Type="checkbox"
		}
		s obj={}
		s obj.TemplateConfigID=TemplateConfigID
		s obj.STCCode=STCCode
	    s obj.Value=Value
	    s obj.Type=Type
	    s obj.RowID=ASRowid_"||"_ASQSub
	    s MultCheck=$p(^DHCSCHEDULETEMPCON(TemplateConfigID),"^",10)
	    s obj.MultCheck=MultCheck
	    d retObj.%Push(obj)
	}
	Q retObj.%ToJSON()
}

/// 生成排班时
ClassMethod CreatTempExtendConfig(SessRowid, ASRowid)
{
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s ChirdRowID=""
	s retObj=[]
	s RowIDStr="", TypeIDStr="", ValueStr=""
	for{
		s ChirdRowID=$O(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQEC",ChirdRowID)) 
		Q:ChirdRowID=""  
		s TemplateConfigID=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQEC",ChirdRowID),"^",1)
		continue:TemplateConfigID=""
		s Value=$P(^RB("RES",ResRowid,"Date",DateSub,"SESS",SessSub,"AQEC",ChirdRowID),"^",2)
		s Type=$p(^DHCSCHEDULETEMPCON(TemplateConfigID),"^",3)
		s STCCode=$p(^DHCSCHEDULETEMPCON(TemplateConfigID),"^",1)
		if (TypeIDStr=""){
			s TypeIDStr=TemplateConfigID
		}else{
			s TypeIDStr=TypeIDStr_$C(1)_TemplateConfigID
		}
		if (ValueStr=""){
			s ValueStr=Value_$C(1)
		}else{
			s ValueStr=ValueStr_Value_$C(1)
		}
	}
	s rtn=..SaveASScheduleExtendConfig(ASRowid, RowIDStr, TypeIDStr, ValueStr)
	q rtn
}

/// 挂号时调用排班扩展设置判断，是否可以挂号
/// 入参:PatientID,ASRowid,扩展数据传ExpandStr(AdmReason_","_...)
/// 出参:0可以挂号，1不可以挂号^不可以挂号原因
/// w ##class(DHCDoc.OPAdm.ScheduleTemplateConfig).CheckOPRegExpandConfig("2||1||8")
ClassMethod CheckOPRegExpandConfig(PatientID, ASRowid, ExpandStr)
{
	s ret=0
	s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
	s ASQSub=""
	s AdmReason=$P(ExpandStr,",",1)
	s PatDOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
	s Age=$$CalAge^at182(PatDOB,+$H,"","","")
	s Age=$p(Age,"|",12)
	s PatSex=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	for{
		s ASQSub=$O(^RBAS(ResRowid,ASSub,"AQEC",ASQSub)) 
		Q:ASQSub=""
		s TemplateConfigID=$P(^RBAS(ResRowid,ASSub,"AQEC",ASQSub),"^",1)
		continue:TemplateConfigID=""
		s Value=$P(^RBAS(ResRowid,ASSub,"AQEC",ASQSub),"^",2)
		continue:Value=""
		s Type=$p($g(^DHCSCHEDULETEMPCON(TemplateConfigID)),"^",3)
		s STCCode=$p($g(^DHCSCHEDULETEMPCON(TemplateConfigID)),"^",1)
		s STCActive=$p(^DHCSCHEDULETEMPCON(TemplateConfigID),"^",7)
	    continue:STCActive'="Y"
		if (STCCode="LimitReason"){
			if (AdmReason'=""){
			if (("!"_Value_"!")[("!"_AdmReason_"!")){
				s ret=1_"^"_"该排班限制了"_	$P(^PAC("ADMREA",AdmReason),"^",2)_"费别!"
			}
		}
	}
	q:ret'=0
	if (STCCode="LimitSex"){
		if (PatSex=Value){
			s ret=1_"^"_"该排班限制了性别!"
		}
	}
	q:ret'=0
	if (STCCode="LimitAgeSmall"){
		if (Age<Value){
			s ret=1_"^"_"该排班限制了不能小于"_Value_"岁!"
		}
	}
	q:ret'=0
	if (STCCode="LimitAgeBig"){
		if (Age>Value){
			s ret=1_"^"_"该排班限制了不能大于"_Value_"岁!"
		}
	}
	q:ret'=0
	///todo 其他内容可以在下方实现
  }
  q ret
}

ClassMethod CheckPACAdmReason(ROWID, HospId)
{
	s READateFrom=$p(^PAC("ADMREA",ROWID),"^",3)
	Q:(READateFrom'="")&&(READateFrom>+$h) "N"
	s READateTo=$p(^PAC("ADMREA",ROWID),"^",4)
	Q:(READateTo'="")&&(READateTo<+$h) "N"
	Q ##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("PAC_AdmReason",ROWID,HospId)
}

ClassMethod CheckCTSex(ROWID, HospId)
{
	s READateFrom=$p(^CT("SEX",ROWID),"^",4)
	Q:(READateFrom'="")&&(READateFrom>+$h) "N"
	s READateTo=$p(^CT("SEX",ROWID),"^",5)
	Q:(READateTo'="")&&(READateTo<+$h) "N"
	s Active=$p(^CT("SEX",ROWID),"^",8)
	q:Active'="Y" "N"
	q "Y"
}

Query GetScheduleTemplateTypeList(HospId As %String = "", Type) As %Query(ROWSPEC = "RowID:%String,ARCIMDR:%String,ARCITMDesc:%String,MRCDIADR:%String,MRCDIADesc:%String")
{
}

ClassMethod GetScheduleTemplateTypeListExecute(ByRef qHandle As %Binary, HospId As %String = "", Type) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.ScheduleTemplateConfig","GetScheduleTemplateTypeList",2,"Order")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
    s RowID=""
    for {
	    s RowID=$O(^DHCSCHEDULETEMPCONi("HospID",HospId,RowID))
	    q:RowID=""
	   	s STCHospDr=$p(^DHCSCHEDULETEMPCON(RowID),"^",8)
	    s STCType=$p(^DHCSCHEDULETEMPCON(RowID),"^",3)
	    continue:(STCType'=Type)
	    s STCActive=$p(^DHCSCHEDULETEMPCON(RowID),"^",7)
	    continue:STCActive'="Y"
	    s ARCIMDR=$p(^DHCSCHEDULETEMPCON(RowID),"^",11)
	    s ARCITMDesc=""
	    if (ARCIMDR'=""){
		    continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ARCIMDR,HospId)="N"
		    s ARCITMDesc=$p($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1)),"^",2)
		    }
		s MRCDIADR=$p(^DHCSCHEDULETEMPCON(RowID),"^",12)
		s MRCDIADesc=""
		if (MRCDIADR){
			s MRCDIADesc=$p(^MRC("ID",MRCDIADR),"^",2)
			}
	    d OutputRowScheduleTemplateTypeList
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowScheduleTemplateTypeList
	set Data=$lb(RowID,ARCIMDR,ARCITMDesc,MRCDIADR,MRCDIADesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetScheduleTemplateTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScheduleTemplateTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetScheduleTemplateTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScheduleTemplateTypeListExecute ]
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

}

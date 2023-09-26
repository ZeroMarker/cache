Class DHCDoc.DHCDocConfig.LabBindRuleSetting Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取已维护检验绑定规则方案列表
Query QueryLabPlan(HospId As %String) As %Query(ROWSPEC = "RowID:%String,PlanName:%String,PlanHospDr:%String,PlanHosp:%String")
{
}

ClassMethod QueryLabPlanExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.LabBindRuleSetting","QueryLabPlan")
	//s MapHospStr=..GetBDPMappingHOSPStr()
	//s MapHospStr="^"_MapHospStr_"^"
	Set repid=$I(^CacheTemp)
    Set ind=1
    s rowid=0
 	for {
	 	s rowid=$o(^User.DHCDocLabPlanD(rowid)) q:rowid=""
	 	s LabPlanName=$lg(^User.DHCDocLabPlanD(rowid),1)
	 	s LabPlanHospDr=$lg(^User.DHCDocLabPlanD(rowid),2)
	 	continue:HospId'=LabPlanHospDr
	 	//continue:(MapHospStr'[("^"_LabPlanHospDr_"^"))
	 	s LabPlanHosp=$p(^CT("HOSP",LabPlanHospDr),"^",2)
		Do OutputRowQueryLabPlan
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowQueryLabPlan
	set Data=$lb($g(rowid),$g(LabPlanName),$g(LabPlanHospDr),$g(LabPlanHosp))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryLabPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLabPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryLabPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLabPlanExecute ]
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

/// 保存方案
/// 入参:方案ID^方案名称^所属院区
/// 出参 0 成功 其他 失败
ClassMethod SavePlan(saveStr As %String) As %String
{
	s rowid=$p(saveStr,"^",1)
	s LabPlanName=$p(saveStr,"^",2)
	s LabPlanHospDr=$p(saveStr,"^",3)
	if (rowid'="") {
		&sql(select count(ID) into :count from SQLUser.DHCDocLabPlan where LabPlanName=:LabPlanName and LabPlanHospDr=:LabPlanHospDr and ID <> :rowid)
		Q:count>0 "-101"
		&sql(update SQLUser.DHCDocLabPlan set LabPlanName=:LabPlanName,LabPlanHospDr=:LabPlanHospDr where ID=:rowid)
	}else{
		&sql(select count(ID) into :count from SQLUser.DHCDocLabPlan where LabPlanName=:LabPlanName and LabPlanHospDr=:LabPlanHospDr)
		Q:count>0 "-101"
		&sql(insert into SQLUser.DHCDocLabPlan set LabPlanName=:LabPlanName,LabPlanHospDr=:LabPlanHospDr)
	}
	Q SQLCODE
}

/// 删除方案
/// 入参:rowid:方案ID 
/// 出参 0 成功 其他 失败
ClassMethod DeletePlan(Rowid As %String) As %String
{
	&sql(delete SQLUser.DHCDocLabPlan where ID=:Rowid)
	if (SQLCODE=0){
		//删除方案对应限制规则
		&sql(delete SQLUser.DHCDocLabPlanOrdLimit where LimitLabPlanDr=:Rowid)
		//删除方案对应限定医嘱
		&sql(delete SQLUser.DHCDocLabPlanBindOrdFee where LabPlanDr=:Rowid)
		//删除方案容器/标本取血类型
		&sql(delete SQLUser.DHCDocLabPlanBloodFlag where LabPlanDr=:Rowid)
	}
	Q SQLCODE
}

/// 获取所有执行科室
Query LookUpAllLoc(curHospId As %String, AdmTypeStr As %String, Desc As %String = "") As %Query(ROWSPEC = "Desc:%String,rowid:%String") [ SqlProc ]
{
}

ClassMethod LookUpAllLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpAllLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LookUpAllLocExecute(ByRef QHandle As %Binary, curHospId As %String, AdmTypeStr As %String, Desc As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.LabBindRuleSetting","LookUpAllLoc","1")
	Set repid=$I(^CacheTemp)
	s ind=1
	if (AdmTypeStr="") {
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	kill TempLocArr
	s TypeStr=AdmTypeStr //"O^E^I"
	for i=1:1:$l(TypeStr){
		s Type=$p(TypeStr,"^",i)
		q:Type=""
		s rowid=""
		for  {
			set rowid=$o(^PAC("ADMLOC",0,"AdmType",Type,rowid))  
			quit:(rowid="") 
			continue:'$d(^CTLOC(rowid))
			continue:$d(TempLocArr(rowid))
			s locHospId=$p(^CTLOC(rowid),"^",22)
			continue:(locHospId'=curHospId)&(locHospId'="")&(curHospId'="")
			s LocActiveFrom=+$p($g(^CTLOC(rowid)),"^",24)
			s LocActiveTo=+$p($g(^CTLOC(rowid)),"^",25)
			continue:((LocActiveFrom'=0)&&(LocActiveFrom>+$h))||((LocActiveTo<+$h)&&(LocActiveTo'=0))
			continue:($P(^CTLOC(rowid),"^",14)'="Y")
			s CTDesc=$p(^CTLOC(rowid),"^",2)
			continue:##class("web.DHCOPAdmReg").CheckLocDesc(rowid,Desc)'=1
			s TempLocArr(rowid)=1
			Do OutputRow1
		}
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(CTDesc,rowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod LookUpAllLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpAllLocExecute ]
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

/// 获取方案限制规则
/// 入参 方案ID
/// 限制科室串_$C(1)_限制就诊类型_$C(1)_开始年龄_$C(1)_结束年龄_$C(1)_限制性别串
ClassMethod GetLabPlanLimitStr(PlanRowId As %String) As %String
{
	s LimitLocStr=$lg(^User.DHCDocLabPlanD(PlanRowId),3)
	s LimitAdmTypeStr=$lg(^User.DHCDocLabPlanD(PlanRowId),4)
	s LimitAgeFrom=$lg(^User.DHCDocLabPlanD(PlanRowId),5)
	s LimitAgeTo=$lg(^User.DHCDocLabPlanD(PlanRowId),6)
	s LimitSexStr=$lg(^User.DHCDocLabPlanD(PlanRowId),7)
	s LabPlanAlgorithms=$lg(^User.DHCDocLabPlanD(PlanRowId),8)
	s LabPlanMergeLabPlan=$lg(^User.DHCDocLabPlanD(PlanRowId),9)
	Q LimitLocStr_$C(1)_LimitAdmTypeStr_$C(1)_LimitAgeFrom_$C(1)_LimitAgeTo_$C(1)_LimitSexStr_$C(1)_LabPlanAlgorithms_$C(1)_LabPlanMergeLabPlan
}

/// 保存方案限制规则
/// 入参 方案ID、 限制科室串_$C(1)_限制就诊类型_$C(1)_开始年龄_$C(1)_结束年龄_$C(1)_限制性别串_$C(1)_方案算法
/// 出参 0 成功 其他 失败
ClassMethod SaveLabPlanLimit(PlanRowId As %String, saveStr As %String, saveLimitOrdStr As %String) As %String
{
	s err=0
	s LabPlanLimitLocStr=$p(saveStr,$C(1),1)
	s LabPlanLimitAdmType=$p(saveStr,$C(1),2)
	s LabPlanLimitAgeFrom=$p(saveStr,$C(1),3)
	s LabPlanLimitAgeTo=$p(saveStr,$C(1),4)
	s LabPlanLimitSexStr=$p(saveStr,$C(1),5)
	s LabPlanAlgorithms=$p(saveStr,$C(1),6)
	s MergeLabPlan=$p(saveStr,$C(1),7)
	TS
	&sql(update SQLUser.DHCDocLabPlan set 
		LabPlanLimitLocStr=:LabPlanLimitLocStr,LabPlanLimitAdmType=:LabPlanLimitAdmType,
		LabPlanLimitAgeFrom=:LabPlanLimitAgeFrom,LabPlanLimitAgeTo=:LabPlanLimitAgeTo,
		LabPlanLimitSexStr=:LabPlanLimitSexStr,LabPlanAlgorithms=:LabPlanAlgorithms,
		LabPlanMergeLabPlan=:MergeLabPlan
	where ID=:PlanRowId)
	if ('SQLCODE) {
		s rowid=$p(%ROWID,$c(1))
		s $list(^User.DHCDocLabPlanD(rowid),3)=LabPlanLimitLocStr
		if (saveLimitOrdStr'="") {
			s err=..SaveLabPlanOrdLimit(PlanRowId,saveLimitOrdStr)
		}
		if (err=0) {
			s rtn=..chkLabPlanUniqued(PlanRowId)
			if (+rtn=1) {
				tro
				Q "101^"_$p(rtn,"^",2)
			}
		}else{
			if err="-101" s err="限定医嘱项目重复!"
		}
	}
	TC
	Q err
}

/// 保存方案限定医嘱
/// 入参 方案ID、 id^限定医嘱项ID^仅限使用本方案标识
/// 出参 0 成功 其他 失败
/// w ##class(DHCDoc.DHCDocConfig.LabBindRuleSetting).SaveLabPlanOrdLimit(1,"^4830||1^")
ClassMethod SaveLabPlanOrdLimit(PlanRowId As %String, saveStr As %String) As %String
{
	s rowId=$p(saveStr,"^",1)
	s LimitArcimDr=$p(saveStr,"^",2)
	if (rowId'="") {
		&sql(select count(ID) into :count from SQLUser.DHCDocLabPlanOrdLimit where LimitLabPlanDr=:PlanRowId and LimitArcimDr=:LimitArcimDr and ID <> :rowId)
		Q:count>0 "-101"
		&sql(update SQLUser.DHCDocLabPlanOrdLimit set 
		LimitLabPlanDr=:PlanRowId,LimitArcimDr=:LimitArcimDr
		where ID=:rowId)
	}else{
		&sql(select count(ID) into :count from SQLUser.DHCDocLabPlanOrdLimit where LimitLabPlanDr=:PlanRowId and LimitArcimDr=:LimitArcimDr)
		Q:count>0 "-101"
		&sql(insert into SQLUser.DHCDocLabPlanOrdLimit set 
		LimitLabPlanDr=:PlanRowId,LimitArcimDr=:LimitArcimDr)
	}
	Q SQLCODE
}

/// 删除方案限定医嘱
/// 入参 id
/// 出参 0 成功 其他 失败
ClassMethod DelLabPlanOrdLimit(rowId As %String) As %String
{
	TS
	&sql(select LimitLabPlanDr into :PlanId from SQLUser.DHCDocLabPlanOrdLimit where ID=:rowId)
	&sql(delete SQLUser.DHCDocLabPlanOrdLimit where ID=:rowId)
	if ('SQLCODE) {
		s rtn=..chkLabPlanUniqued(PlanId)
		if (+rtn=1) {
			tro
			Q "101^"_$p(rtn,"^",2)
		}
	}
	TC
	Q SQLCODE
}

/// 获取方案限定医嘱列表
/// 入参 方案ID
Query QueryLabPlanOrdLimit(PlanRowId As %String) As %Query(ROWSPEC = "RowID:%String,ARCIMDR:%String,ArcimDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryLabPlanOrdLimitClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLabPlanOrdLimitExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryLabPlanOrdLimitExecute(ByRef QHandle As %Binary, PlanRowId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.LabBindRuleSetting","QueryLabPlanOrdLimit","1")
	Set repid=$I(^CacheTemp)
	s ind=1
	if (PlanRowId=""){
		Set QHandle=$lb(0,repid,0) Quit $$$OK
	}
	s rowid=0
	for {
		s rowid=$o(^User.DHCDocLabPlanOrdLimitI("LimitLabPlanDr"," "_PlanRowId,rowid)) q:rowid=""
		s ARCIMDR=$lg(^User.DHCDocLabPlanOrdLimitD(rowid),2)
		s ArcimDesc=$p(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1),"^",2)
		Do OutputRow2
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(rowid,ARCIMDR,ArcimDesc)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod QueryLabPlanOrdLimitFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLabPlanOrdLimitExecute ]
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

/// 保存方案对应费用医嘱
/// 入参 方案ID、 id^限定医嘱项ID^数量^保存类型
/// 出参 0 成功 其他 失败
ClassMethod SaveLabPlanBindOrdFee(PlanRowId As %String, saveStr As %String) As %String
{
	s rowId=$p(saveStr,"^",1)
	s ArcimDr=$p(saveStr,"^",2)
	s Qty=$p(saveStr,"^",3)
	s SaveType=$p(saveStr,"^",4)
	s IsRepeatAdd=$p(saveStr,"^",5)
	s ^tempscl("SaveLabPlanBindOrdFee")=PlanRowId_","_saveStr
	if (rowId'="") {
		&sql(select count(ID) into :count from SQLUser.DHCDocLabPlanBindOrdFee where LabPlanDr=:PlanRowId and LabPlanBindArcimDr=:ArcimDr and ID <> :rowId and LabPlanBindType=:SaveType)
		Q:count>0 "-101"
		&sql(update SQLUser.DHCDocLabPlanBindOrdFee set
		LabPlanBindArcimDr=:ArcimDr,LabPlanBindQty=:Qty,
		LabPlanBindIsRepeat=:IsRepeatAdd
		where ID=:rowId)
	}else{
		&sql(select count(ID) into :count from SQLUser.DHCDocLabPlanBindOrdFee where LabPlanDr=:PlanRowId and LabPlanBindArcimDr=:ArcimDr  and LabPlanBindType=:SaveType)
		Q:count>0 "-101"
		&sql(insert into SQLUser.DHCDocLabPlanBindOrdFee set
		LabPlanDr=:PlanRowId,
		LabPlanBindArcimDr=:ArcimDr,LabPlanBindQty=:Qty,
		LabPlanBindType=:SaveType,LabPlanBindIsRepeat=:IsRepeatAdd)
	}
	Q SQLCODE
}

/// 删除方案对应费用医嘱
/// 入参 id
/// 出参 0 成功 其他 失败
ClassMethod DelLabPlanBindOrdFee(rowId As %String) As %String
{
	&sql(delete SQLUser.DHCDocLabPlanBindOrdFee where ID=:rowId)
	Q SQLCODE
}

/// 获取方案对应费用医嘱列表
/// 入参 方案ID、 绑定类型
/// 出参 0 成功 其他 失败
Query QueryLabPlanBindOrdFee(PlanRowId As %String, LabPlanBindType As %String) As %Query(ROWSPEC = "RowID:%String,ARCIMDR:%String,ArcimDesc:%String,Qty:%String,IsRepeatAdd:%String") [ SqlProc ]
{
}

ClassMethod QueryLabPlanBindOrdFeeClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLabPlanBindOrdFeeExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryLabPlanBindOrdFeeExecute(ByRef QHandle As %Binary, PlanRowId As %String, LabPlanBindType As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.LabBindRuleSetting","QueryLabPlanBindOrdFee","3","BloodType_1")
	Set repid=$I(^CacheTemp)
	s ind=1
	if (PlanRowId="")||(LabPlanBindType=""){
		Set QHandle=$lb(0,repid,0) Quit $$$OK
	}
	s LabPlanBindType=$ZCVT(LabPlanBindType,"U")
	s rowid=0
	for {
		s rowid=$o(^User.DHCDocLabPlanBindOrdFeeI("LabPlanBindOrdFeeType"," "_PlanRowId," "_LabPlanBindType,rowid)) q:rowid=""
		s ARCIMDR=$lg(^User.DHCDocLabPlanBindOrdFeeD(rowid),2)
		s ArcimDesc=$p(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1),"^",2)
		s Qty=$lg(^User.DHCDocLabPlanBindOrdFeeD(rowid),3)
		s IsRepeatAdd=$lg(^User.DHCDocLabPlanBindOrdFeeD(rowid),5)
		Do OutputRow3
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(rowid,ARCIMDR,ArcimDesc,Qty,IsRepeatAdd)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod QueryLabPlanBindOrdFeeFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLabPlanBindOrdFeeExecute ]
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

/// 根据常规设置->按容器关联医嘱/不选则默认按标本,获取标本/容器列表
/// 入参 方案ID
Query SpecOrContainerList(PlanRowId As %String, LabPlanHospId As %String = "") As %Query(ROWSPEC = "Code:%String,Desc:%String,BloodFlag:%String,BloodFlagDesc:%String,BloodActive:%String") [ SqlProc ]
{
}

ClassMethod SpecOrContainerListClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = SpecOrContainerListExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SpecOrContainerListExecute(ByRef QHandle As %Binary, PlanRowId As %String, LabPlanHospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.LabBindRuleSetting","SpecOrContainerList","1")
	Set repid=$I(^CacheTemp)
	s ind=1
	if (PlanRowId=""){
		Set QHandle=$lb(0,repid,0) Quit $$$OK
	}
	if (LabPlanHospId="") s LabPlanHospId=%session.Get("LOGON.HOSPID")
	s LabPlanHospDr=$lg(^User.DHCDocLabPlanD(PlanRowId),2)
	s HospitalCode=$p(^CT("HOSP",LabPlanHospDr),"^",1)
	s CFBaseContainer=..%GetConfig("BaseContainer",LabPlanHospId) //$$getconfignode^DHCDocConfig("BaseContainer")
	if CFBaseContainer=1 {
		//按容器绑定
		Set rset = ##class(%ResultSet).%New("DHCDoc.DHCDocConfig.Container:GetContainerList")
		Set rs = rset.Execute(HospitalCode)
		While (rset.Next()) {
		 	s Code=rset.Data("ConCode")
		 	s Desc=rset.Data("ConDesc")
		 	s BloodFlag=""
		 	s BloodFlagDesc=""
		 	s BloodActive="Y"
		 	s id1=$o(^User.DHCDocLabPlanBloodFlagI("LabPlanDr"," "_PlanRowId," "_$$ALPHAUP^SSUTIL4(Code),""))
		 	if (id1'="") {
			 	s BloodFlag=$lg(^User.DHCDocLabPlanBloodFlagD(id1),3)
			 	//i BloodFlag=1 s BloodFlagDesc="统一采血"
			 	if (BloodFlag'="")&&($d(^User.DHCDocLabBloodTypeD(BloodFlag))) {
				 	s BloodFlagDesc=$lg(^User.DHCDocLabBloodTypeD(BloodFlag),3)
				 	s BloodActive=$lg(^User.DHCDocLabBloodTypeD(BloodFlag),4)
				}
			}
		 	Do OutputRow4
		}
		 d rset.Close()
	}else{
		//按标本绑定
		Set rset = ##class(%ResultSet).%New("DHCDoc.DHCDocConfig.Specimen:GetSpecList")
		Set rs = rset.Execute(HospitalCode)
		While (rset.Next()) {
		 	s Code=rset.Data("SPECCode")
		 	s Desc=rset.Data("SPECDesc")
		 	s BloodFlag=""
		 	s BloodFlagDesc=""
		 	s BloodActive="Y"
		 	s id1=$o(^User.DHCDocLabPlanBloodFlagI("LabPlanDr"," "_PlanRowId," "_$$ALPHAUP^SSUTIL4(Code),""))
		 	if (id1'="") {
			 	s BloodFlag=$lg(^User.DHCDocLabPlanBloodFlagD(id1),3)
			 	//i BloodFlag=1 s BloodFlagDesc="统一采血"
			 	if (BloodFlag'="")&&($d(^User.DHCDocLabBloodTypeD(BloodFlag))) {
				 	s BloodFlagDesc=$lg(^User.DHCDocLabBloodTypeD(BloodFlag),3)
				 	s BloodActive=$lg(^User.DHCDocLabBloodTypeD(BloodFlag),4)
				}
			}
		 	Do OutputRow4
		}
		 d rset.Close()
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(Code,Desc,BloodFlag,BloodFlagDesc,BloodActive)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod SpecOrContainerListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SpecOrContainerListExecute ]
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

/// 保存方案里容器/标本的取血类型
/// 入参:PlanRowId:方案ID TypeCode：标本/容器Code BloodFlag:取血类型
/// 出参 0 成功 其他 失败
ClassMethod SaveLabPlanBloodFlag(PlanRowId As %String, TypeCode As %String, BloodFlag As %String) As %String
{
	s rowid=$o(^User.DHCDocLabPlanBloodFlagI("LabPlanDr"," "_PlanRowId," "_$$ALPHAUP^SSUTIL4(TypeCode),""))
	if (rowid'="") {
		&sql(update SQLUser.DHCDocLabPlanBloodFlag set LabPlanBloodFlag=:BloodFlag where ID=:rowid)
	}else{
		&sql(insert into SQLUser.DHCDocLabPlanBloodFlag set
			LabPlanDr=:PlanRowId,
			LabPlanTypeCode=:TypeCode,LabPlanBloodFlag=:BloodFlag)
	}
	Q SQLCODE
}

/// 验证方案限制条件的唯一性
/// 入参：方案ID
/// 出参 0 唯一 1 不唯一
/// w ##class(DHCDoc.DHCDocConfig.LabBindRuleSetting).chkLabPlanUniqued(10)
ClassMethod chkLabPlanUniqued(PlanRowId As %String) As %String
{
	s Uniqued=0
	s checkHospDr=$lg(^User.DHCDocLabPlanD(PlanRowId),2)
	s checkLimitLocStr=$lg(^User.DHCDocLabPlanD(PlanRowId),3)
	k checkLimitLocArr
	d ..OutputArr(checkLimitLocStr,.checkLimitLocArr)
	s checkLimitAdmTypeStr=$lg(^User.DHCDocLabPlanD(PlanRowId),4)
	k checkLimitAdmTypeArr
	d ..OutputArr(checkLimitAdmTypeStr,.checkLimitAdmTypeArr)
	s checkLimitAgeFrom=$lg(^User.DHCDocLabPlanD(PlanRowId),5)
	s checkLimitAgeTo=$lg(^User.DHCDocLabPlanD(PlanRowId),6)
	s checkLimitOrdStr=""
	s rowid=0
	for {
		s rowid=$o(^User.DHCDocLabPlanOrdLimitI("LimitLabPlanDr"," "_PlanRowId,rowid)) q:rowid=""
		s arcimId=$lg(^User.DHCDocLabPlanOrdLimitD(rowid),2)
		if checkLimitOrdStr="" s checkLimitOrdStr=arcimId
		else  s checkLimitOrdStr=checkLimitOrdStr_"^"_arcimId
	}
	k checkLimitOrdArr
	d ..OutputArr(checkLimitOrdStr,.checkLimitOrdArr)
	s planId=0
	for {
		s planId=$o(^User.DHCDocLabPlanD(planId)) q:planId=""
		continue:planId=PlanRowId
		s labPlanHospDr=$lg(^User.DHCDocLabPlanD(planId),2)
		continue:labPlanHospDr'=checkHospDr
		s labPlanLimitLocStr=$lg(^User.DHCDocLabPlanD(planId),3)
		continue:labPlanLimitLocStr=""
		s labPlanLimitAdmTypeStr=$lg(^User.DHCDocLabPlanD(planId),4)
		s labPlanLimitAgeFrom=$lg(^User.DHCDocLabPlanD(planId),5)
		s labPlanLimitAgeTo=$lg(^User.DHCDocLabPlanD(planId),6)
		s labPlanLimitOrdStr=""
		s rowid=0
		for {
			s rowid=$o(^User.DHCDocLabPlanOrdLimitI("LimitLabPlanDr"," "_planId,rowid)) q:rowid=""
			s arcimId=$lg(^User.DHCDocLabPlanOrdLimitD(rowid),2)
			if labPlanLimitOrdStr="" s labPlanLimitOrdStr=arcimId
			else  s labPlanLimitOrdStr=labPlanLimitOrdStr_"^"_arcimId
		}
		s LocCheck= ..chkInArr(labPlanLimitLocStr,.checkLimitLocArr)
		s AdmTypeCheck= ..chkInArr(labPlanLimitAdmTypeStr,.checkLimitAdmTypeArr)
		if (labPlanLimitOrdStr'="")&&($d(checkLimitOrdArr)) {
			s LimitOrdCheck= ..chkInArr(labPlanLimitOrdStr,.checkLimitOrdArr)
		}elseif(labPlanLimitOrdStr="")&&('$d(checkLimitOrdArr)){
			s LimitOrdCheck=1
		}else{
			s LimitOrdCheck=0
		}
		continue:('LocCheck)||('AdmTypeCheck)||('LimitOrdCheck)||(labPlanLimitAgeFrom>checkLimitAgeTo)||(labPlanLimitAgeTo<checkLimitAgeFrom)
		s labPlanName=$lg(^User.DHCDocLabPlanD(planId),1)
		s Uniqued=1_"^"_labPlanName
		Q
	}
	Q Uniqued
}

ClassMethod OutputArr(Str As %String, ByRef ParmArr)
{
	Q:Str=""
	k ParamArr
	for i=1:1:$l(Str,"^") {
		s key=$p(Str,"^",i)
		s ParmArr(key)=1
	}
}

ClassMethod chkInArr(Str As %String, ByRef arr) As %String
{
	s find=0
	Q:Str="" find
	for i=1:1:$l(Str,"^") {
		s key=$p(Str,"^",i)
		continue:key=""
		if ($d(arr(key))) {
			s find=1
		}
	}
	Q find
}

/// 保存检验取血类型
/// 入参:代码^名称^有效标识
/// 出参 0 成功 其他 失败
ClassMethod SaveBloodType(Rowid As %String, saveStr As %String) As %String
{
	s code=$p(saveStr,"^",1)
	s desc=$p(saveStr,"^",2)
	s ActiveFlag=$p(saveStr,"^",3)
	if (Rowid="") {
		&sql(select count(ID) into :count from SQLUser.DHCDocLabBloodType where LabBloodTypeCode=:code or LabBloodTypeDesc=:desc)
		Q:count>0 "-101"
		&sql(insert into SQLUser.DHCDocLabBloodType set LabBloodTypeCode=:code,LabBloodTypeDesc=:desc,LabBloodTypeActiveFlag=:ActiveFlag)
	}else{
		&sql(select count(ID) into :count from SQLUser.DHCDocLabBloodType where (LabBloodTypeCode=:code or LabBloodTypeDesc=:desc) and ID<>:Rowid)
		Q:count>0 "-101"
		&sql(update  SQLUser.DHCDocLabBloodType set LabBloodTypeCode=:code,LabBloodTypeDesc=:desc where ID=:Rowid)
	}
	Q SQLCODE
}

/// 修改取血类型有效标识
/// 入参:表User.DHCDocLabBloodType ID
/// 出参 0 成功 其他 失败
ClassMethod UpdateBloodTypeActive(rowid As %String) As %String
{
	Q:rowid="" 0
	s OldActive=$lg(^User.DHCDocLabBloodTypeD(rowid),4)
	i OldActive="Y" s NewActive="N"
	else  s NewActive="Y"
	&sql(update SQLUser.DHCDocLabBloodType set LabBloodTypeActiveFlag=:NewActive where ID=:rowid)
	Q SQLCODE
}

/// Description:： 查询检验取血类型
Query FindBloodType(paraActive As %String = "") As %Query(ROWSPEC = "rowid:%String,Code:%String,Desc:%String,Active:%String")
{
}

ClassMethod FindBloodTypeExecute(ByRef qHandle As %Binary, paraActive As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CMDocConfig","FindBloodType")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s rowid=0
    for {
		s rowid=$O(^User.DHCDocLabBloodTypeD(rowid))
		q:rowid=""
		s Code=$lg(^User.DHCDocLabBloodTypeD(rowid),2)
		s Desc=$lg(^User.DHCDocLabBloodTypeD(rowid),3)
		s Active=$lg(^User.DHCDocLabBloodTypeD(rowid),4)
		i Active="" s Active="Y"
		continue:(paraActive'="")&&(Active'=paraActive)
		d OutputRowFindBloodType
	}
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindBloodType
	set Data=$lb(rowid,Code,Desc,Active)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindBloodTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBloodTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBloodTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBloodTypeExecute ]
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

/// 获取检验医嘱使用的方案
/// 入参:adm就诊ID
/// 出参 方案ID串
ClassMethod GetLabOrdUsedPlanArr(adm As %String, ByRef LabOrdPlanArray) As %String
{
	Q:(adm="") ""
	k LabOrdPlanArray
	;就诊类型
	s AdmType=$p($g(^PAADM(adm)),"^",2)
	s admloc=$p(^PAADM(adm),"^",4)
	;院区
	s HospRowid=$p($g(^CTLOC(admloc)),"^",22)
	s PatientID=$p(^PAADM(adm),"^",1)
	;年龄
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,adm)
	i PatAge'["岁" s PatAge=0
	e  s PatAge=$p(PatAge,"岁")
	;性别
	s PatSexDr=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	s PlanId=0
	for {
		s PlanId=$o(^User.DHCDocLabPlanI("LabPlanHospDr"," "_HospRowid,PlanId)) Q:PlanId=""
		s LimitAdmType=$lg(^User.DHCDocLabPlanD(PlanId),4)
		continue:LimitAdmType=""
		continue:("^"_LimitAdmType_"^")'[("^"_AdmType_"^")
		s LimitAgeFrom=$lg(^User.DHCDocLabPlanD(PlanId),5)
		continue:((+PatAge)<LimitAgeFrom)
		s LimitAgeTo=$lg(^User.DHCDocLabPlanD(PlanId),6)
		continue:((+PatAge)>LimitAgeTo)
		s LimitSexStr=$lg(^User.DHCDocLabPlanD(PlanId),7)
		continue:("^"_LimitSexStr_"^")'[("^"_PatSexDr_"^")
		s labPlanLimitLocStr=$lg(^User.DHCDocLabPlanD(PlanId),3)
		s labPlanLimitOrdStr=""
		s rowid=0
		for {
			s rowid=$o(^User.DHCDocLabPlanOrdLimitI("LimitLabPlanDr"," "_PlanId,rowid)) q:rowid=""
			s arcimId=$lg(^User.DHCDocLabPlanOrdLimitD(rowid),2)
			if labPlanLimitOrdStr="" s labPlanLimitOrdStr=arcimId
			else  s labPlanLimitOrdStr=labPlanLimitOrdStr_"^"_arcimId
		}
		s LabOrdPlanArray(PlanId)=labPlanLimitLocStr_$C(1)_labPlanLimitOrdStr
	}
}

/// 复制方案
/// 入参:复制方案ID，复制到方案名称、复制到方案院区
/// 出参 0 成功 其他 失败
ClassMethod CopyPlan(CopyFromLabPlan As %String, CopyToLabPlanName As %String, CopyToLabPlanHospDr As %String) As %String
{
	&sql(select count(ID) into :count from SQLUser.DHCDocLabPlan where LabPlanName=:CopyToLabPlanName and LabPlanHospDr=:CopyToLabPlanHospDr)
	Q:count>0 "-101"
	TS
	&sql(insert into SQLUser.DHCDocLabPlan set LabPlanName=:CopyToLabPlanName,LabPlanHospDr=:CopyToLabPlanHospDr)
	i 'SQLCODE {
		s CopyToLabPlanId=$p(%ROWID,$c(1))
		//复制取血类型费用绑定、容器/标本费用绑定 User.DHCDocLabPlanBindOrdFee
		s id=0
		for {
			s id=$o(^User.DHCDocLabPlanBindOrdFeeI("LabPlanDr"," "_CopyFromLabPlan,id)) Q:id=""
			s ArcimDr=$lg(^User.DHCDocLabPlanBindOrdFeeD(id),2)
			s Qty=$lg(^User.DHCDocLabPlanBindOrdFeeD(id),3)
			s BindType=$lg(^User.DHCDocLabPlanBindOrdFeeD(id),4)
			s RepeatFlag=$lg(^User.DHCDocLabPlanBindOrdFeeD(id),5)
			d ..SaveLabPlanBindOrdFee(CopyToLabPlanId,"^"_ArcimDr_"^"_Qty_"^"_BindType_"^"_RepeatFlag)
		}
		//复制容器/标本取血类型 User.DHCDocLabPlanBloodFlag
		s TypeCode=0
		for {
			s TypeCode=$o(^User.DHCDocLabPlanBloodFlagI("LabPlanDr"," "_CopyFromLabPlan,TypeCode)) Q:TypeCode=""
			s id=0
			for {
				s id=$o(^User.DHCDocLabPlanBloodFlagI("LabPlanDr"," "_CopyFromLabPlan,TypeCode,id)) Q:id=""
				s typecode=$lg(^User.DHCDocLabPlanBloodFlagD(id),2)
				s BloodFlag=$lg(^User.DHCDocLabPlanBloodFlagD(id),3)
				d ..SaveLabPlanBloodFlag(CopyToLabPlanId,typecode,BloodFlag)
			}
		}
		TC
		Q 0
	}else{
		tro
		Q SQLCODE
	}
}

ClassMethod GetBDPMappingHOSPStr() As %String
{
	s ret=""
	Set obj=##class(%ResultSet).%New("DHCDoc.Common.Hospital:GetHospDataForCombo")
	d obj.Execute("","","Doc_BaseConfig_LabBindRuleSetting","")
	For  Quit:'obj.Next()  Do
	.s HOSPRowId=obj.Data("HOSPRowId")
	.i ret="" s ret=HOSPRowId
	.e  s ret=ret_"^"_HOSPRowId
	Q ret
}

// 获取血糖医嘱分组列表

Query FindBloodSugarGroup() As websys.Query(ROWSPEC = "BloodSugarGroupDR:%String,BloodSugarGroupCode:%String,BloodSugarGroup:%String")
{
}

ClassMethod FindBloodSugarGroupExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ArcItemConfig","FindBloodSugarGroup")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	s id=0
	for {
		s id=$o(^User.DHCDocLabBloodSugarGroupD(id)) Q:id=""
		s BloodSugarGroupDR=id
		s BloodSugarGroupCode=$lg(^User.DHCDocLabBloodSugarGroupD(id),1)
		s BloodSugarGroup=$lg(^User.DHCDocLabBloodSugarGroupD(id),2)
		d OutputRowBloodSugarGroup
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowBloodSugarGroup
	Set Data=$lb(BloodSugarGroupDR,BloodSugarGroupCode,BloodSugarGroup)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// 删除血糖分组
/// 出参 0 成功 其他 失败
ClassMethod DeleteLabBloodSugarGroup(Rowid As %String, HospDr As %String) As %String
{
	&sql(delete SQLUser.DHCDocLabBloodSugarGroup where ID=:Rowid)
	s id=0
	for {
		s id=$o(^User.DHCDocOrdBloodSugarGroupI("LabOrdBloodSugarGroupDr",HospDr,Rowid,id)) Q:id=""
		d ..DeleteLabOrdBloodSugarGroup(id)
	}
	Q SQLCODE
}

// 判断所删除的血糖维护是否已维护相应的医嘱

ClassMethod ChkOrdBloodSugar(GroupDr As %String, HospDr As %String) As %String
{
	Q:$d(^User.DHCDocOrdBloodSugarGroupI("LabOrdBloodSugarGroupDr",HospDr,GroupDr)) 1
	Q 0
}

/// 保存血糖维护
ClassMethod SaveLabBloodSugarGroup(Rowid As %String, Code As %String, Name As %String) As %String
{
	s id=$o(^User.DHCDocLabBloodSugarGroupI("LabBloodSugarGroupCode"," "_$$ALPHAUP^SSUTIL4(Code),""))
	if (id'="")&&(id'=Rowid) Q "代码重复!"
	s id=$o(^User.DHCDocLabBloodSugarGroupI("LabBloodSugarGroupName"," "_$$ALPHAUP^SSUTIL4(Name),""))
	if (id'="")&&(id'=Rowid) Q "名称重复!"
	if (Rowid'="") {
		&sql(update SQLUser.DHCDocLabBloodSugarGroup set LabBloodSugarGroupCode=:Code,LabBloodSugarGroupName=:Name where ID=:Rowid)
	}else{
		&sql(insert into SQLUser.DHCDocLabBloodSugarGroup set LabBloodSugarGroupCode=:Code,LabBloodSugarGroupName=:Name)
	}
	Q SQLCODE
}

// 获取已维护血糖分组的医嘱列表

Query FindOrdBloodSugarGroup(HospDr As %String) As websys.Query(ROWSPEC = "id:%String,ARCIMDR:%String,ArcimDesc:%String,BloodSugarGroupDR:%String,BloodSugarGroup:%String")
{
}

ClassMethod FindOrdBloodSugarGroupExecute(ByRef qHandle As %Binary, HospDr As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ArcItemConfig","FindBloodSugarGroup")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	s id=0
	for {
		s id=$o(^User.DHCDocOrdBloodSugarGroupD(id)) Q:id=""
		s LabOrdArcimDr=$lg(^User.DHCDocOrdBloodSugarGroupD(id),1)
		s ArcimDesc=$p(^ARCIM(+LabOrdArcimDr,$p(LabOrdArcimDr,"||",2),1),"^",2)
		s LabOrdBloodSugarGroupDr=$lg(^User.DHCDocOrdBloodSugarGroupD(id),2)
		s LabBloodSugarGroupName=$lg(^User.DHCDocLabBloodSugarGroupD(LabOrdBloodSugarGroupDr),2)
		s LabOrdHospDr=$lg(^User.DHCDocOrdBloodSugarGroupD(id),3)
		continue:LabOrdHospDr'=HospDr
		d OutputRowFindOrdBloodSugarGroup
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindOrdBloodSugarGroup
	Set Data=$lb(id,LabOrdArcimDr,ArcimDesc,LabOrdBloodSugarGroupDr,LabBloodSugarGroupName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// 删除医嘱项血糖分组
/// 出参 0 成功 其他 失败
ClassMethod DeleteLabOrdBloodSugarGroup(Rowid As %String) As %String
{
	&sql(delete SQLUser.DHCDocOrdBloodSugarGroup where ID=:Rowid)
	Q SQLCODE
}

/// 保存医嘱项血糖维护
ClassMethod SaveLabOrdBloodSugarGroup(Rowid As %String, ARCIMDR As %String, BloodSugarGroupDR As %String, HospDr As %String) As %String
{
	s id=$o(^User.DHCDocOrdBloodSugarGroupI("LabOrdArcimDr",HospDr,ARCIMDR,""))
	if (id'="")&&(id'=Rowid) Q "该医嘱项已维护!"
	if (Rowid'="") {
		&sql(update SQLUser.DHCDocOrdBloodSugarGroup set LabOrdArcimDr=:ARCIMDR,LabOrdBloodSugarGroupDr=:BloodSugarGroupDR where ID=:Rowid)
	}else{
		&sql(insert into SQLUser.DHCDocOrdBloodSugarGroup set LabOrdArcimDr=:ARCIMDR,LabOrdBloodSugarGroupDr=:BloodSugarGroupDR,LabOrdHospDr=:HospDr)
	}
	Q SQLCODE
}

}

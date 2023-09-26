Class DHCDoc.DHCDocCure.RBCServiceGroupSet Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query QueryServiceGroup(config As %String = "", HospID As %String = "", TPRowID As %String = "") As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,DateFrom:%String,DateTo:%String,RelateAssTemp:%String,RelateAssTempDesc:%String,HasConfigFlag:%String,RelateRecordTemp:%String,RelateRecordTempDesc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCServiceGroupSet","QueryServiceGroup")
ClassMethod QueryServiceGroupExecute(ByRef qHandle As %Binary, config As %String = "", HospID As %String = "", TPRowID As %String = "") As %Status
{
	s ind=1
	s repid=$I(^CacheTemp)
	s langid=20
	if ($d(%session)){
		s langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCureRBCServiceGroupSet",HospID,+$H)
	s ServiceGroupRowid=0  f  s ServiceGroupRowid=$o(^DHCDocCureRBCServiceGroupSet(ServiceGroupRowid)) q:ServiceGroupRowid=""  d
	.d OutServiceGroup
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 
OutServiceGroup
	s HospShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCureRBCServiceGroupSet",ServiceGroupRowid,HospID)
	s ServiceGroupCode=$p(^DHCDocCureRBCServiceGroupSet(ServiceGroupRowid),"^",1)
	s ServiceGroupDesc=$p(^DHCDocCureRBCServiceGroupSet(ServiceGroupRowid),"^",2)
	s ServiceGroupDesc=##class(User.DHCDocCureRBCServiceGroupSet).GetTranByDesc("DDCSGSDesc",ServiceGroupDesc,langid)
	Q:(HospShowDataFlag="N")
	s DateFrom=$p(^DHCDocCureRBCServiceGroupSet(ServiceGroupRowid),"^",3)
	Q:(config'=1)&&(DateFrom'="")&&(DateFrom>+$H)
	s:DateFrom'="" DateFrom=##class(websys.Conversions).DateLogicalToHtml(DateFrom)
	s DateTo=$p(^DHCDocCureRBCServiceGroupSet(ServiceGroupRowid),"^",4)
	Q:(config'=1)&&(DateTo'="")&&(DateTo<+$H)
	s:DateTo'="" DateTo=##class(websys.Conversions).DateLogicalToHtml(DateTo)
	s AssTempInfo=..GetGroupRelateAssTemp(ServiceGroupRowid)
	s RelateAssTemp=$p(AssTempInfo,"^",1)
	s RelateAssTempDesc=$p(AssTempInfo,"^",2)
	s RecordTempInfo=..GetGroupRelateRecordTemp(ServiceGroupRowid)
	s RelateRecordTemp=$p(RecordTempInfo,"^",1)
	s RelateRecordTempDesc=$p(RecordTempInfo,"^",2)
	s HasConfigFlag="N"
	if TPRowID'=""{
		s HasConfigFlag=##class(DHCDoc.DHCDocCure.RBCTimePeriodSet).CheckHasConfigFlag(TPRowID,ServiceGroupRowid,HospID)
	}
	set Data=$lb(ServiceGroupRowid,ServiceGroupCode,ServiceGroupDesc,DateFrom,DateTo,RelateAssTemp,RelateAssTempDesc,HasConfigFlag,RelateRecordTemp,RelateRecordTempDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1 
	quit
}

ClassMethod QueryServiceGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryServiceGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryServiceGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryServiceGroupExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 通过ID获取时间段设置数据
ClassMethod GetCureRBCTimePeriodSetById(Id As %String) As %String
{
	q:Id="" ""
	s Data=$G(^DHCDocCureRBCTimePeriodSet(Id))
	if $p(Data,"^",3)'="" s $p(Data,"^",3)=$zt($p(Data,"^",3),1)
	if $p(Data,"^",4)'="" s $p(Data,"^",4)=$zt($p(Data,"^",4),1)
	if $p(Data,"^",5)'="" s $p(Data,"^",5)=$zt($p(Data,"^",5),1)
	q Data
}

/// 通过ID判断服务组是否已过期
ClassMethod CheckServiceGroupActive(Id As %String) As %String
{
	q:Id="" 0
	s ret=1
	s DateFrom=$p(^DHCDocCureRBCServiceGroupSet(Id),"^",3)
	if (DateFrom'="")&&(DateFrom>+$H) s ret=0
	i DateFrom'="" d
	s DateTo=$p(^DHCDocCureRBCServiceGroupSet(Id),"^",4)
	if (DateTo'="")&&(DateTo<+$H) s ret=0
	q ret
}

/// 保存时间段设置数据
/// w ##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).SaveCureRBCServiceGroupSet("^01^针灸组^02/23/2016^")
ClassMethod SaveCureRBCServiceGroupSet(str As %String, hisui As %String = "", HospID As %String = "") As %String
{
	n (str,hisui,HospID)
	s ^TMP("SaveCureRBCServiceGroupSet")=str
	Q:str="" -1
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	Set DDCSGSROWID=$P(str,"^")
	Set DDCSGSCode=$P(str,"^",2)
	Set DDCSGSDesc=$P(str,"^",3)
	Set DDCSGSDateFrom=$P(str,"^",4)
	Set DDCSGSDateTo=$P(str,"^",5)
	if hisui=""{
		s:DDCSGSDateFrom'="" DDCSGSDateFrom=$zdh(DDCSGSDateFrom,1)
		s:DDCSGSDateTo'="" DDCSGSDateTo=$zdh(DDCSGSDateTo,1)
	}else{
		;hisui改造后日期格式按照系统格式
		if DDCSGSDateFrom["/" s DDCSGSDateFrom=$zdh(DDCSGSDateFrom,4)
		if DDCSGSDateTo["/" s DDCSGSDateTo=$zdh(DDCSGSDateTo,4)
		if DDCSGSDateFrom["-" s DDCSGSDateFrom=$zdh(DDCSGSDateFrom,3)
		if DDCSGSDateTo["-" s DDCSGSDateTo=$zdh(DDCSGSDateTo,3)
	}
	if (DDCSGSDateFrom'="")&&(DDCSGSDateTo'="")&&(DDCSGSDateTo<DDCSGSDateFrom) Q 201
	S RowID=$O(^DHCDocCureRBCServiceGroupSet(0,"Code",DDCSGSCode,""))
	Q:(DDCSGSROWID="")&&(RowID'="") 101
	Q:(DDCSGSROWID'="")&&(RowID'="")&&(RowID'=DDCSGSROWID) 101
	K PLIST
	s PLIST(2)=DDCSGSCode
	s PLIST(3)=DDCSGSDesc
	s PLIST(4)=DDCSGSDateFrom
	s PLIST(5)=DDCSGSDateTo
	if DDCSGSROWID="" 
	{
	 	&sql(insert into SQLUser.DHC_DocCureRBCServiceGroupSet values :PLIST())
	 	i 'SQLCODE {
		 	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCureRBCServiceGroupSet",HospID,+$H)
		 	s RowID=$p(%ROWID,$c(1))
		 	d ##class(DHCDoc.Common.Hospital).SaveHOSP("DHC_DocCureRBCServiceGroupSet",RowID,HospID)
	 	}
	}else{
		&sql(update SQLUser.DHC_DocCureRBCServiceGroupSet values :PLIST() where DDCSGS_Rowid=:DDCSGSROWID )
	}
	q SQLCODE
}

ClassMethod DeleteCureRBCServiceGroupSet(Rowid As %String) As %String
{
	 q:Rowid="" 100
	 &sql(delete from SQLUser.DHC_DocCureRBCServiceGroupSet where DDCSGS_Rowid=:Rowid)
	 q SQLCODE
}

ClassMethod SaveGroupRelateAssTemp(DDCSGSRowid As %String, RelateAssTempDR As %String, RelateRecordTempDR As %String)
{
	Q:DDCSGSRowid="" "-100"
	&sql(update SQLUser.DHC_DocCureRBCServiceGroupSet set DDCSGS_RelateAssTemp=:RelateAssTempDR,DDCSGS_RelateRecordTemp=:RelateRecordTempDR where DDCSGS_Rowid=:DDCSGSRowid )
	Q SQLCODE
}

ClassMethod GetGroupRelateAssTemp(DDCSGSRowid As %String)
{
	n (DDCSGSRowid,%session)
	s LANGID=..%LanguageID()
	s (NewRelateAssTemp,RelateAssTempDesc)=""
	s RelateAssTemp=$p(^DHCDocCureRBCServiceGroupSet(DDCSGSRowid),"^",5)
	if RelateAssTemp'=""{
		for loop=1:1:$l(RelateAssTemp,","){
			s mRelateAssTemp=$p(RelateAssTemp,",",loop)
			s mRelateAssTempDesc=$p($g(^DHCDocAppBLMap(mRelateAssTemp)),"^",2)
			s mRelateAssTempDesc=##class(User.DHCDocAppBLMap).GetTranByDesc("APPMapName",mRelateAssTempDesc,LANGID)
			s mRelateAssTempActive=$p($g(^DHCDocAppBLMap(mRelateAssTemp)),"^",4)
			continue:mRelateAssTempActive="N"
			if RelateAssTempDesc="" s RelateAssTempDesc=mRelateAssTempDesc
			else  s RelateAssTempDesc=RelateAssTempDesc_","_mRelateAssTempDesc
			if NewRelateAssTemp="" s NewRelateAssTemp=mRelateAssTemp
			else  s NewRelateAssTemp=NewRelateAssTemp_","_mRelateAssTemp
		}
	}
	s ret=NewRelateAssTemp_"^"_RelateAssTempDesc
	Q ret
}

ClassMethod GetGroupRelateRecordTemp(DDCSGSRowid As %String)
{
	n (DDCSGSRowid)
	s (NewRelateTemp,RelateTempDesc)=""
	s RelateTemp=$p(^DHCDocCureRBCServiceGroupSet(DDCSGSRowid),"^",6)
	if RelateTemp'=""{
		for loop=1:1:$l(RelateTemp,","){
			s mRelateTemp=$p(RelateTemp,",",loop)
			s mRelateTempDesc=$p($g(^DHCDocAppBLMap(mRelateTemp)),"^",2)
			s mRelateTempActive=$p($g(^DHCDocAppBLMap(mRelateTemp)),"^",4)
			continue:mRelateTempActive="N"
			if RelateTempDesc="" s RelateTempDesc=mRelateTempDesc
			else  s RelateTempDesc=RelateTempDesc_","_mRelateTempDesc
			if NewRelateTemp="" s NewRelateTemp=mRelateTemp
			else  s NewRelateTemp=NewRelateTemp_","_mRelateTemp
		}
	}
	s ret=NewRelateTemp_"^"_RelateTempDesc
	Q ret
}

/// 以下为服务组下可分配资源配置
/// w ##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).SaveTriageResource(^TMP("SaveTriageResource"))
ClassMethod SaveTriageResource(str As %String) As %String
{
	n (str)
	s ^TMP("SaveTriageResource")=str
	Q:str="" -1
	Set ROWID=$P(str,"^")
	Set DDCTRCTLocDr=$P(str,"^",2)
	Set DDCTRCTPCPDr=$P(str,"^",3)
	Set DDCTRParRef=$P(str,"^",4)
	Set DDCTRActive=$P(str,"^",5)
	Set DDCTRCount=$P(str,"^",6)
	s FRowID=""
	S ChildSub=$O(^DHCDocCureTRi(0,"RES",DDCTRCTLocDr,DDCTRCTPCPDr,DDCTRParRef,0))
	if (ChildSub'="") s FRowID=DDCTRParRef_"||"_ChildSub
	Q:(ROWID="")&&(FRowID'="") 101
	Q:(ROWID'="")&&(FRowID'="")&&(ROWID'=FRowID) 102
	K PLIST
	s PLIST(3)=DDCTRCTLocDr
	s PLIST(4)=DDCTRCTPCPDr
	s PLIST(5)=DDCTRActive
	s PLIST(6)=DDCTRCount
	if ROWID="" 
	{
		s PLIST(0)=DDCTRParRef
	 	&sql(insert into SQLUser.DHC_DocCureTriageResource values :PLIST())
	 	
	}else{
		&sql(update SQLUser.DHC_DocCureTriageResource values :PLIST() where DDCTR_RowID=:ROWID )
	}
	q SQLCODE
}

ClassMethod DeleteTriageResource(Rowid As %String) As %String
{
	 q:Rowid="" 100
	 &sql(delete from SQLUser.DHC_DocCureTriageResource where DDCTR_RowID=:Rowid)
	 q SQLCODE
}

Query QueryTriageResource(LocRowID As %String = "", HospID As %String = "", LocDesc As %String = "") As %Query(ROWSPEC = "DDCTRROWID:%String,DDCTRServiceGroupID:%String,DDCTRServiceGroup:%String,DDCTRCTLocID:%String,DDCTRCTLoc:%String,DDCTRCTPCPID:%String,DDCTRCTPCP:%String,DDCTRActive:%String,DDCTRCount:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCServiceGroupSet","QueryTriageResource","","2")
ClassMethod QueryTriageResourceExecute(ByRef qHandle As %Binary, LocRowID As %String = "", HospID As %String = "", LocDesc As %String = "") As %Status
{
	s ind=1
	Set repid=$I(^CacheTemp)
	s DDCTRParRef=0  f  s DDCTRParRef=$o(^DHCDocCureTR(DDCTRParRef)) q:DDCTRParRef=""  d
	.Q:##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_DocCureRBCServiceGroupSet",DDCTRParRef,HospID)="N"
	.s DDCTRChildSub=0 f  s DDCTRChildSub=$o(^DHCDocCureTR(DDCTRParRef,"TR",DDCTRChildSub)) q:DDCTRChildSub=""  d
	..d OutTriageResource
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 
OutTriageResource
	s TRData=$g(^DHCDocCureTR(DDCTRParRef,"TR",DDCTRChildSub))
	Q:'$d(^DHCDocCureRBCServiceGroupSet(DDCTRParRef))
	s RowID=DDCTRParRef_"||"_DDCTRChildSub
	s DDCTRServiceGroup=$p(^DHCDocCureRBCServiceGroupSet(DDCTRParRef),"^",2)
	s DDCTRCTLocDr=$p(TRData,"^",1)
	Q:'$d(^CTLOC(DDCTRCTLocDr))
	Q:##CLASS(web.DHCOPAdmReg).CheckLocDesc(DDCTRCTLocDr,LocDesc)'=1
	Q:(LocRowID'="")&&(LocRowID'=DDCTRCTLocDr)
	s CTHosp=$p($g(^CTLOC(DDCTRCTLocDr)),"^",22)
	Q:(HospID'="")&&(HospID'=CTHosp)
	s DDCTRCTLoc=$p($G(^CTLOC(DDCTRCTLocDr)),"^",2)
	s DDCTRResDr=$p(TRData,"^",2)
	s DDCTRCTPCPDr=$p($G(^RB("RES",DDCTRResDr)),"^",2)
	s DDCTRCTPCP=$p($G(^CTPCP(DDCTRCTPCPDr,1)),"^",2)
	s DDCTRActive=$p(TRData,"^",3)
	if DDCTRActive="Y" s DDCTRActive=""
	else  s DDCTRActive="已失效"
	s DDCTRCount=$p(TRData,"^",4)
	set Data=$lb(RowID,DDCTRParRef,DDCTRServiceGroup,DDCTRCTLocDr,DDCTRCTLoc,DDCTRResDr,DDCTRCTPCP,DDCTRActive,DDCTRCount)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1 
	quit
}

ClassMethod QueryTriageResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTriageResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryTriageResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTriageResourceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 初始化服务组
/// w ##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).InitServiceGroup("82","","2")
ClassMethod InitServiceGroup(CuGroupID = "", Config = "", HospID = "") As %String
{
	n (CuGroupID,Config,HospID)
	Set result=##class(%Library.ResultSet).%New("DHCDoc.DHCDocCure.RBCServiceGroupSet:QueryServiceGroup")
	Set sc=result.Execute(Config,HospID)
	If $$$ISERR(sc) Quit "[]"
	s Arr=[]
	While(result.Next()){ 
		s GroupId=result.Data("Rowid")
		continue:(CuGroupID'="")&&(CuGroupID=GroupId) 	;过滤自己
		s LGroupId=result.Data("Rowid")
		s LGroupDesc=result.Data("Desc")
		s SpellAlias=##class(ext.util.String).ToChineseSpell(LGroupDesc)
		s Obj={}
		s Obj."value" =LGroupId
		s Obj."text" =LGroupDesc
		s Obj."SpellAlias" =SpellAlias
		d Arr.%Push(Obj)
	}
	q Arr.%ToJSON()
}

/// 保存关联服务组
/// w ##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).SaveLinkServiceGroup(^templx("LinkGroupStr"))
ClassMethod SaveLinkServiceGroup(LinkGroupStr, HospID) As %String
{
	n (LinkGroupStr,HospID)
	s ^templx("LinkGroupStr")=LinkGroupStr
	s Ret="0",CuDate=+$h,CuTime=$p($h,",",2)
  	Ts
	f len=1:1:$l(LinkGroupStr,"&&"){
		s LinkGroup=$p(LinkGroupStr,"&&",len)
		continue:LinkGroup=""
		s RowId=$p(LinkGroup,"^",1)
		s GroupId=$p(LinkGroup,"^",2)
		s LGroupId=$p(LinkGroup,"^",3)
		s ExitRowId=$o(^User.DHCDocCureSGLinkI("LinkHospGroupIndex",HospID,GroupId,LGroupId,""))
		s LGroupDesc=$p(^DHCDocCureRBCServiceGroupSet(LGroupId),"^",2)
		i (+ExitRowId'=0){
			if (RowId'=ExitRowId){
				s Ret="-1^"_LGroupDesc_"不能重复关联"
				q
			}else{
				continue
			}
		}
		i RowId'=""{
			&SQL(Update SQLUser.DHC_DocCureRBCServiceGroupLink set Link_GroupId=:GroupId,Link_LinkGroupId=:LGroupId where ID=:RowId)
			s Ret=SQLCODE_"^"_LGroupDesc_$g(%msg)
		}else{
			&SQL(insert into SQLUser.DHC_DocCureRBCServiceGroupLink (Link_GroupId,Link_LinkGroupId,Link_Date,Link_Time,Link_Hosp_DR) Values(:GroupId,:LGroupId,:CuDate,:CuTime,:HospID))
			s Ret=SQLCODE_"^"_LGroupDesc_$g(%msg)
		}
		Q:+Ret'=0
	}
	i +Ret=0{
		Tc
	}else{
		Tro
	}
	q Ret
}

/// 删除关联服务组
/// w ##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).DeleteLinkServiceGroup("1")
ClassMethod DeleteLinkServiceGroup(RowID) As %String
{
	n (RowID)
	q:RowID="" "-1^缺少入参"
	&SQL(DELETE SQLUser.DHC_DocCureRBCServiceGroupLink where ID=:RowID)
	s Ret=SQLCODE_"^"_$g(%msg)
	q Ret
}

/// 初始化关联服务组
/// w ##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).InitLinkServiceGroup("82")
ClassMethod InitLinkServiceGroup(CuGroupId, HospID As %String = "") As %String
{
	n (CuGroupId,HospID,%session)
	s Arr=[]
	s LinkGroupId=0
	f  s LinkGroupId=$o(^User.DHCDocCureSGLinkI("LinkHospGroupIndex",HospID,CuGroupId,LinkGroupId)) q:LinkGroupId=""  d
	.s RowId=$o(^User.DHCDocCureSGLinkI("LinkHospGroupIndex",HospID,CuGroupId,LinkGroupId,""))
	.s LGroupId=LinkGroupId
	.s HospShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCureRBCServiceGroupSet",LinkGroupId,HospID)
	.q:(HospShowDataFlag="N")
	.s LGroupDesc=$p(^DHCDocCureRBCServiceGroupSet(LinkGroupId),"^",2)
	.s Obj={}
	.s Obj."LGroupId" =LGroupId
	.s Obj."LGroupDesc" =LGroupDesc
	.s Obj."GroupLinkID"=RowId
	.d Arr.%Push(Obj)
	q Arr.%ToJSON()
}

/// w ##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).GetLinkServiceGroup(146)
ClassMethod GetLinkServiceGroup(ServiceGroupDR, HospID As %String = "")
{
	n (ServiceGroupDR,HospID,%session)
	if (HospID="")&&($d(%session)){
		s HospID=%session.Get("LOGON.HOSPID")
	}
	s LinkServiceGroupStr=""
	s LinkGroupId=0
	for{
		s LinkGroupId=$o(^User.DHCDocCureSGLinkI("LinkHospGroupIndex",HospID,ServiceGroupDR,LinkGroupId)) q:LinkGroupId=""  d
		s RowId=$o(^User.DHCDocCureSGLinkI("LinkHospGroupIndex",HospID,ServiceGroupDR,LinkGroupId,""))
		continue:LinkGroupId=""
		s HospShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCureRBCServiceGroupSet",LinkGroupId,HospID)
		continue:(HospShowDataFlag="N")
		if LinkServiceGroupStr="" s LinkServiceGroupStr=LinkGroupId
		else  s LinkServiceGroupStr=LinkServiceGroupStr_"^"_LinkGroupId
	}
	Q LinkServiceGroupStr
}

}

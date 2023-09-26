/// 资源与出诊级别对照配置及获取类
/// 医院要求挂号职称按医护人员类型管理,由科室自己排班,但是出诊级别按配置控制,排班员不可更改
/// Create By WangQingyong 2017-02-01
/// Update By NK 2018-04-08
/// Update Content:
/// 		原先维护的是后台gloable,现增加后台User表结构DHC_RBResContrast、DHC_RBSessContrast
Class web.DHCDocSessContrast Extends %RegisteredObject
{

/// 获取资源默认职称配置
/// 优先级顺序:具体科室医生>科室默认>医护类型默认
/// 入参:资源RB_Resource Rowid 返回：挂号级别(RBC_SessType) Rowid^描述
/// Debug:w ##class(web.DHCDocSessContrast).GetResSessType(959)
ClassMethod GetResSessType(ResRowid)
{
	Q:ResRowid="" ""
	s LocRowid=$P($G(^RB("RES",ResRowid)),"^",1)
	Q:LocRowid="" ""
	s LocHospDr=$p(^CTLOC(LocRowid),"^",22)
	s SessRowid="",SessDesc=""
	s RBRCRowID=$o(^DHCRBResContrast(0,"DeptRes",LocRowid,ResRowid,0))	;资源对应级别
	if RBRCRowID'=""{
		s SessRowid=$p(^DHCRBResContrast(RBRCRowID),"^",3)
		d GetSessDesc
	}
	Q:SessDesc'="" SessRowid_"^"_SessDesc
	s RBRCRowID=0
	for {
		s RBRCRowID=$o(^DHCRBResContrast(0,"DEPT",LocRowid,RBRCRowID))
		Q:(RBRCRowID="")
		s mylocid=$p(^DHCRBResContrast(RBRCRowID),"^",1)
		s myresid=$p(^DHCRBResContrast(RBRCRowID),"^",2)
		continue:myresid'=""
		s SessRowid=$p(^DHCRBResContrast(RBRCRowID),"^",3)
		d GetSessDesc
	}
	Q:SessDesc'="" SessRowid_"^"_SessDesc
	s CareRowid=$P($G(^RB("RES",ResRowid)),"^",2)
	s TypeRowid=$P(^CTPCP(CareRowid,1),"^",4)
	i TypeRowid'=""{
		s find=0
		s LocSessRowID=0
		f {
			s LocSessRowID=$O(^DHCRBLocContrasti(0,"TypeDept",LocHospDr,TypeRowid,LocRowid,LocSessRowID)) q:LocSessRowID=""
			continue:'$d(^DHCRBLocContrast(LocSessRowID))
			s SessRowid=$p(^DHCRBLocContrast(LocSessRowID),"^",3)
			d GetSessDesc
			s find=1
		}
		if find=0{
			s RBSCRowID=$o(^DHCRBSessContrast(0,"PRVTYPE",TypeRowid,LocHospDr,0))
			if RBSCRowID'=""{
				s SessRowid=$P($G(^DHCRBSessContrast(RBSCRowID)),"^",2)	;医护类别对应级别
				d GetSessDesc
			}
		}
	}
	Q SessRowid_"^"_SessDesc
	
GetSessDesc
	s:SessRowid'="" SessDesc=$P(^RBC("SESS",SessRowid),"^",2)
}

/// Description:保存医护人员类型与出诊级别对照
/// Table：User.CTCarPrvTp、User.RBCSessionType
ClassMethod SaveSessContrast(InputStr, HospID = "") As %String
{
	s rtn=""
	f i=1:1:$L(InputStr,"^") d
	.s str=$P(InputStr,"^",i)
	.s CarePrvTypeDR=+str
	.s SessionTypeDR=$P(str,"!",2)
	.Q:(CarePrvTypeDR="") //!(SessionTypeDR="")
	.s RBSCRowID=$o(^DHCRBSessContrast(0,"PRVTYPE",CarePrvTypeDR,HospID,0))
	.if RBSCRowID="" d
	..&sql(insert sqluser.DHC_RBSessContrast set RBSC_CarePrvType_DR=:CarePrvTypeDR,RBSC_SessionType_DR=:SessionTypeDR,RBSC_Hosp_DR=:HospID)
	..s rtn=SQLCODE
	.else  d
	..&sql(update sqluser.DHC_RBSessContrast set RBSC_SessionType_DR=:SessionTypeDR where RBSC_RowID=:RBSCRowID)
	..s rtn=SQLCODE
	Q rtn
}

/// Description:保存科室医生与出诊级别对照
/// Table：User.CTLoc、User.RBResource、User.RBCSessionType
/// w ##class(web.DHCDocSessContrast).SaveResContrast("13!!3!")
ClassMethod SaveResContrast(InputStr) As %String
{
	s ^tmpnk("SaveResContrast")=InputStr
	s rtn=0
	s LocId=$P(InputStr,"!",1)
	q:LocId=""
	s ResId=$P(InputStr,"!",2)
	s SessId=$P(InputStr,"!",3)
	s RBRCRowID=$P(InputStr,"!",4)
	s find=0
	i (ResId'=""){
		s rbrcid=0
		for  s rbrcid=$o(^DHCRBResContrast(0,"DeptRes",LocId,ResId,rbrcid)) q:(rbrcid="")!(find=1)  d
		.q:rbrcid=RBRCRowID
		.s mylocid=$p(^DHCRBResContrast(rbrcid),"^",1)
		.s myresid=$p(^DHCRBResContrast(rbrcid),"^",2)
		.s find=1
		
		/*if (RBRCRowID="")&&($D(^DHCRBResContrast(0,"DeptRes",LocId,ResId))){
			s find=1
		}*/
	}else{
		s rbrcid=0
		for  s rbrcid=$o(^DHCRBResContrast(0,"DEPT",LocId,rbrcid)) Q:(rbrcid="")!(find=1)  d
		.q:rbrcid=RBRCRowID
		.s mylocid=$p(^DHCRBResContrast(rbrcid),"^",1)
		.s myresid=$p(^DHCRBResContrast(rbrcid),"^",2)
		.if myresid="" s find=1
	}
	if find=1{
		s LocDesc=$P($G(^CTLOC(LocId)),"^",2)
		s:LocDesc["-" LocDesc=$P(LocDesc,"-",2)
		i ResId'="" s ResDesc=$P($G(^RB("RES",ResId)),"^",17)
		e  s ResDesc="--科室默认--"
		Q "-1^'"_LocDesc_ResDesc_"'重复维护,一个科室医生只能有一个级别"	
	}
	if RBRCRowID=""{
		s RBRCObj=##class(User.DHCRBResContrast).%New()	
	}else{
		s RBRCObj=##class(User.DHCRBResContrast).%OpenId(RBRCRowID)	
	}
	if $IsObject(RBRCObj){
		do RBRCObj.RBRCDeptDRSetObjectId(LocId)
		do RBRCObj.RBRCResourceDRSetObjectId(ResId)
		do RBRCObj.RBRCSessionTypeDRSetObjectId(SessId)
		s sc=RBRCObj.%Save()
	    If $$$ISERR(sc){
		    s rtn="-100"
	    }
	    d RBRCObj.%Close()
	}
	q rtn
}

ClassMethod delete(RBRCRowID As %String)
{
	Q:RBRCRowID="" "-100"
	&sql(delete SQLUSER.DHC_RBResContrast where RBRC_RowID=:RBRCRowID)
	Q SQLCODE
}

Query QueryCareType(Type, HospID = "") As %Query(ROWSPEC = "CareTpRowid:%String,CareTpDesc:%String,SessRowid:%String,SessDesc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocSessContrast","QueryCareType")
ClassMethod QueryCareTypeExecute(ByRef qHandle As %Binary, Type = "DOCTOR", HospID = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s TypeRowid=0
	f  s TypeRowid=$O(^CT("CPT",TypeRowid)) q:TypeRowid=""  d
	.s TypeCode=$P(^CT("CPT",TypeRowid),"^",4)
	.Q:TypeCode'=Type
	.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_CarPrvTp",TypeRowid,HospID)
	.s TypeDesc=$P(^CT("CPT",TypeRowid),"^",2)
	.s StartDate=$P(^CT("CPT",TypeRowid),"^",5)
	.s EndDate=$P(^CT("CPT",TypeRowid),"^",6)
	.q:(StartDate'="")&&(StartDate>+$h)
	.q:(EndDate'="")&&(EndDate<+$h)
	.s RBSCRowID=$o(^DHCRBSessContrast(0,"PRVTYPE",TypeRowid,HospID,0))
	.s SessRowid=""
	.i RBSCRowID'="" d
	..s SessRowid=$p($G(^DHCRBSessContrast(RBSCRowID)),"^",2)
	.s SessDesc=""
	.s:SessRowid'="" SessDesc=$P(^RBC("SESS",SessRowid),"^",2)
	.d OutputRow    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(TypeRowid,TypeDesc,SessRowid,SessDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QueryCareTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCareTypeExecute ]
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

ClassMethod QueryCareTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCareTypeFetch ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QuerySessList(Desc, HospID = "") As %Query(ROWSPEC = "SessRowid:%String,SessDesc:%String")
{
}

ClassMethod QuerySessListExecute(ByRef qHandle As %Binary, Desc = "", HospID = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^tempqujina("QuerySessList")=Desc_","_HospID
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s SessRowid=0
	f  s SessRowid=$O(^RBC("SESS",SessRowid)) q:SessRowid=""  d
	.s SessDesc=$P(^RBC("SESS",SessRowid),"^",2)
	.q:(Desc'="")&(SessDesc'[Desc)
	.s SessSdate=$P(^RBC("SESS",SessRowid),"^",6)
	.Q:(SessSdate'="")&&(SessSdate>+$h)
	.s SessEdate=$P(^RBC("SESS",SessRowid),"^",7)
	.Q:(SessEdate'="")&&(SessEdate'>+$h)
	.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_SessionType",SessRowid,HospID)
	.d OutputRow    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(SessRowid,SessDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QuerySessListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySessListExecute ]
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

ClassMethod QuerySessListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySessListFetch ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QueryLocList(Desc As %String, HospID As %String = "", CareTypeId As %String = "", SessRowId As %String = "") As %Query(ROWSPEC = "LocRowid,LocDesc,CTAlias,AuthedFlag") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocSessContrast","QueryLocList")
ClassMethod QueryLocListExecute(ByRef qHandle As %Binary, Desc As %String, HospID As %String = "", CareTypeId As %String = "", SessRowId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	k ^TMP($j,"QueryLocList")
	s AdmType="O^E"
	s Len=$L(AdmType,"^")
	for i=1:1:Len  {
		s AdmTypePut=$P(AdmType,"^",i)
		s RowId=0 f  s RowId=$O(^PAC("ADMLOC",0,"AdmType",AdmTypePut,RowId)) Q:RowId=""  d
		.Q:'$d(^RB("RES",0,"CTLOC",RowId))
		.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",RowId,HospID)
		.Q:##class(web.DHCOPAdmReg).CheckLocDesc(RowId,Desc)'=1
		.s LocDateTo=$p($g(^CTLOC(RowId)),"^",25)
		.Q:(LocDateTo'="")&&(LocDateTo<+$H)
		.s CTDesc=$p($g(^CTLOC(RowId)),"^",2)
		.s CTAliasTem=""
		.i $l(CTDesc,"-")>1 s CTAliasTem=$P(CTDesc,"-",1)
		.s CTAlias=$P(^CTLOC(RowId),"^",43)
		.q:($P(^CTLOC(RowId),"^",14)'="Y")
		.i CTAlias="" s CTAlias=CTAliasTem
		.s CTRowId=RowId
		.s CTCode=CTRowId
		.s AuthedFlag=..CheckAuthedFlag(CareTypeId,SessRowId,CTRowId,HospID)
		.s CTLOCMarkNO=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.CTLoc","正式",CTRowId)
		.i CTLOCMarkNO="" s CTLOCMarkNO="999"
	    .s ^TMP($j,"QueryLocList",CTLOCMarkNO,CTRowId)=CTDesc_"^"_CTAlias_"^"_AuthedFlag   //建立临时Globle
		.//Do OutputRow1
	}
	//按照序号排序
	s seq="" for {
		s seq=$O(^TMP($j,"QueryLocList",seq))
		Quit:seq=""
		s seq1="" for {
			s seq1=$O(^TMP($j,"QueryLocList",seq,seq1))
			Quit:seq1=""
			s temp=^TMP($j,"QueryLocList",seq,seq1)
			s CTRowId=seq1
			s CTDesc=$P(temp,"^",1)
			s CTAlias=$P(temp,"^",2)
			s AuthedFlag=$P(temp,"^",3)
			d OutputRow		
		}
	}
	k ^TMP($j,"QueryLocList")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(CTRowId,CTDesc,CTAlias,AuthedFlag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QueryLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocListExecute ]
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

ClassMethod QueryLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocListFetch ]
{
    Set repid=$LIST(qHandle,2)
     Kill ^CacheTemp(repid)
     Quit $$$OK
}

Query QueryLocRes(LocId) As %Query(ROWSPEC = "ResRowid:%String,ResDesc:%String,Alias:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocSessContrast","QueryLocRes",3)
ClassMethod QueryLocResExecute(ByRef qHandle As %Binary, LocId) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ResRowid="",ResDesc="--科室默认--"
	d OutputRow
	if LocId=""{
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK	
	}
	f  s ResRowid=$O(^RB("RES",0,"CTLOC",LocId,ResRowid)) q:ResRowid=""  d
	.s DateTo=$P(^RB("RES",ResRowid),"^",23)
	.q:(DateTo'="")&(DateTo<+$H)
	.s DateFrom=$P(^RB("RES",ResRowid),"^",22)
	.q:(DateFrom>+$H)&&(DateFrom'="")
	.s ResDesc=$P(^RB("RES",ResRowid),"^",17)
	.s RESCTPCPDR=$P(^RB("RES",ResRowid),"^",2)
	.s CTPCPOtherName=""
	.s:RESCTPCPDR'="" CTPCPOtherName=$p($g(^CTPCP(RESCTPCPDR,3)),"^",28)
	.d OutputRow    
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(ResRowid,ResDesc,CTPCPOtherName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
    quit
}

ClassMethod QueryLocResFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocResExecute ]
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

ClassMethod QueryLocResClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocResFetch ]
{
    Set repid=$LIST(qHandle,2)
     Kill ^CacheTemp(repid)
     Quit $$$OK
}

Query QueryResContrast(LocId, HospID = "") As %Query(ROWSPEC = "LocRowid,LocDesc,ResRowid,ResDesc,SessRowid,SessDesc,RBRCRowID") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocSessContrast","QueryResContrast","",3)
ClassMethod QueryResContrastExecute(ByRef qHandle As %Binary, LocId = "", HospID = "") As %Status
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if LocId=""{
		s RBRCRowID=0
		f  s RBRCRowID=$O(^DHCRBResContrast(RBRCRowID)) q:RBRCRowID=""  d
		.Q:'$d(^DHCRBResContrast(RBRCRowID))
		.d GetData
	}else{
		s RBRCRowID=0
		f  s RBRCRowID=$O(^DHCRBResContrast(0,"DEPT",LocId,RBRCRowID)) q:RBRCRowID=""  d
		.Q:'$d(^DHCRBResContrast(RBRCRowID))
		.d GetData
	}
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
GetData
	s LocRowid=$p(^DHCRBResContrast(RBRCRowID),"^",1)
	Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",LocRowid,HospID)
	s LocDesc=$P($G(^CTLOC(LocRowid)),"^",2)
	s:LocDesc["-" LocDesc=$P(LocDesc,"-",2)
	s ResRowid=$p(^DHCRBResContrast(RBRCRowID),"^",2)
	s ResDesc=""
	s:+ResRowid'=0 ResDesc=$P($G(^RB("RES",ResRowid)),"^",17)
	s SessDesc=""
	s SessRowid=$p(^DHCRBResContrast(RBRCRowID),"^",3)
	Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_SessionType",SessRowid,HospID)
	s:SessRowid'="" SessDesc=$P($g(^RBC("SESS",SessRowid)),"^",2)
	d OutputRow  
	q
OutputRow
    set Data=$lb(LocRowid,LocDesc,ResRowid,ResDesc,SessRowid,SessDesc,RBRCRowID)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
    quit
}

ClassMethod QueryResContrastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResContrastExecute ]
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

ClassMethod QueryResContrastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResContrastFetch ]
{
    Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CheckAuthedOtherFlag(CareTypeId As %String, SessRowId As %String, LocRowId As %String, HospID As %String)
{
	s TypeDesc=""
	if (CareTypeId="")!(SessRowId="")!(LocRowId="") q TypeDesc
	s FindSessRowid=""
	s myrowid=""
	for{
		s myrowid=$o(^DHCRBLocContrasti(0,"TypeDept",HospID,CareTypeId,LocRowId,myrowid)) Q:myrowid=""
		s AuthSessRowid=$p(^DHCRBLocContrast(myrowid),"^",3)
		continue:AuthSessRowid=SessRowId
		s FindSessRowid=AuthSessRowid
		q:FindSessRowid'=""
	}
	s:FindSessRowid'="" TypeDesc=$P($g(^RBC("SESS",FindSessRowid)),"^",2)	
	
	q TypeDesc
}

ClassMethod CheckAuthedFlag(CareTypeId As %String, SessRowid As %String, LocRowId As %String, HospID As %String)
{
	s ret=0
	if (CareTypeId="")!(SessRowid="")!(LocRowId="") q ret
	
	s RBRLRowID=$o(^DHCRBLocContrasti(0,"ALLField",HospID,CareTypeId,SessRowid,LocRowId,""))
	if RBRLRowID'=""{
		s ret=RBRLRowID
	}
	q ret
}

/// Description:保存科室医生与出诊级别对照
/// Table：User.CTLoc、User.RBResource、User.RBCSessionType
/// w ##class(web.DHCDocSessContrast).SaveResContrast("13!!3!")
ClassMethod SaveLocContrast(CareTypeId As %String, SessId As %String, ILocStr As %String, CLocStr As %String, HospID As %String) As %String
{
	s ^tmpnk("SaveLocContrast")=$lb(CareTypeId,SessId,ILocStr,CLocStr)
	s rtn=0
	
	s ILocLen=$l(ILocStr,"^")
	for loop=1:1:ILocLen{
		s LocId=$p(ILocStr,"^",loop)
		s AuthedFlag=..CheckAuthedFlag(CareTypeId,SessId,LocId,HospID)	
		if +AuthedFlag=0{
			s myrowid=""
			for{
				s myrowid=$o(^DHCRBLocContrasti(0,"TypeDept",HospID,CareTypeId,LocId,myrowid)) Q:myrowid=""
				d ..deleteSessLocCon(myrowid)	
			}
			
			d ..InsertSessLocCon(CareTypeId,SessId,LocId,HospID)	
		}
	}
	
	s ILocLen=$l(CLocStr,"^")
	for loop=1:1:ILocLen{
		s LocId=$p(CLocStr,"^",loop)
		s RowId=..CheckAuthedFlag(CareTypeId,SessId,LocId,HospID)	
		if RowId>0{
			d ..deleteSessLocCon(RowId)	
		}
	}
	
	q rtn
}

ClassMethod InsertSessLocCon(CareTypeId As %String, SessId As %String, LocId As %String, HospID As %String)
{
	s rtn=0
	s RBRCObj=##class(User.DHCRBCTLocConrast).%New()
	if $IsObject(RBRCObj){
		do RBRCObj.RBRLDeptDRSetObjectId(LocId)
		do RBRCObj.RBRLCareTypeDRSetObjectId(CareTypeId)
		do RBRCObj.RBRLSessionTypeDRSetObjectId(SessId)
		do RBRCObj.RBSLHospDRSetObjectId(HospID)
		s sc=RBRCObj.%Save()
	    If $$$ISERR(sc){
		    s rtn="-100"
	    }
	    d RBRCObj.%Close()
	}
	q rtn
}

Query QueryLocContrast(CareTypeId As %String, HospID As %String) As %Query(ROWSPEC = "SessRowid:%String,SessDesc:%String,AuthDeptCount:%String,AuthDeptIDStr:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocSessContrast","QueryLocContrast","3")
ClassMethod QueryLocContrastExecute(ByRef qHandle As %Binary, CareTypeId As %String, HospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if CareTypeId=""{
		Set qHandle=$lb(0,repid,0)
    	Quit $$$OK
	}
	
	s SessRowid=""
	for{
		s SessRowid=$o(^DHCRBLocContrasti(0,"ALLField",HospID,CareTypeId,SessRowid)) q:SessRowid=""
		s AuthLocCount=0,AuthDeptIDStr=""
		s LocRowID=""
		for{
			s LocRowID=$o(^DHCRBLocContrasti(0,"ALLField",HospID,CareTypeId,SessRowid,LocRowID)) q:LocRowID=""
			s AuthLocCount=AuthLocCount+1
			if AuthDeptIDStr="" s AuthDeptIDStr=LocRowID
			else  s AuthDeptIDStr=AuthDeptIDStr_"^"_LocRowID
		}
		s SessDesc=""
		s SessDesc=$P($g(^RBC("SESS",SessRowid)),"^",2)
		d OutputRow  
	}
	
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(SessRowid,SessDesc,AuthLocCount,AuthDeptIDStr)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
    quit
}

ClassMethod QueryLocContrastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocContrastExecute ]
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

ClassMethod QueryLocContrastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocContrastExecute ]
{
    Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod deleteSessLocCon(RowID As %String)
{
	Q:RowID="" "-100"
	&sql(delete SQLUSER.DHC_RBCTLocContrast where RBRL_RowID=:RowID)
	Q SQLCODE
}

ClassMethod DelLocContrast(CareTypeID As %String, SessionTypeID As %String, HospID As %String)
{
	Q:(CareTypeID="")!(SessionTypeID="") "-100"
	&sql(delete SQLUSER.DHC_RBCTLocContrast where RBRL_CareType_DR=:CareTypeID and RBRL_SessionType_DR=:SessionTypeID and RBRL_Hosp_DR=:HospID)
	Q SQLCODE
}

}

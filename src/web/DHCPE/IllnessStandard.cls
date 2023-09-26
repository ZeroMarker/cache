Class web.DHCPE.IllnessStandard Extends %Library.RegisteredObject
{

Parameter BUILD = 137;

/// w ##class(web.DHCPE.DHCPEExpertDiagnosis).GetMaxCode()
ClassMethod GetMaxCode()
{
	s Code=0
	&SQL(select max(ILLS_code) into :Code from sqluser.DHC_PE_IllnessStandard)
	i Code="" s Code=0
	s Code=+Code+1
	s Code=$E("00000000",1,8-$l(Code))_Code
	q Code
}

ClassMethod InsertED(InString As %Library.String = "")
{
	//new PLIST,EDRowId
	s PLIST(2)=$p(InString,"^",1)
	s PLIST(3)=$p(InString,"^",2)
	s PLIST(4)=$p(InString,"^",3)
	s PLIST(6)=+$h
	s PLIST(5)=$p(InString,"^",6)
	s PLIST(7)=$p(InString,"^",4)
	s PLIST(8)=$p(InString,"^",5)
	i $p(InString,"^",7)'="User" s PLIST(5)=""
	s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	i HospitalCode="FX" s PLIST(5)="" //复兴
	s EDAlias=$p(InString,"^",8)
	s PLIST(9)=$p(InString,"^",9) //ToReport
	s PLIST(10)=$p(InString,"^",10) //Sex
	s PLIST(11)=$p(InString,"^",11) //Loc
	s PLIST(12)=$p(InString,"^",12) //Type
	s PLIST(16)=$p(InString,"^",13) //TypeNew
	s PLIST(17)=$p(InString,"^",14) 
	s PLIST(18)=$p(InString,"^",15) 
	s PLIST(19)=$p(InString,"^",16) 
	TSTART
	&sql(Insert into sqluser.DHC_PE_IllnessStandard
		values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s EDRowId=%ROWID
	i EDAlias'=""
	{
		s Strings="^"_EDRowId_"^"_EDAlias
		s SQLCODE=..UpdateAlias(Strings,"0")
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	TCOMMIT
	q SQLCODE_"^"_EDRowId
}

ClassMethod UpdateAlias(DataStr, isDelete)
{
	//new PLIST
	if (isDelete=1)
	{
		&SQL(delete from sqluser.DHC_PE_ILLSAlias where ILLSA_RowId=:DataStr)
	}
	else
	{
		s RowId=$p(DataStr,"^",1)
		s PLIST(2)=$p(DataStr,"^",2)
		s PLIST(3)=$p(DataStr,"^",3)
		i RowId=""
		{
			&SQL(insert into sqluser.DHC_PE_ILLSAlias values :PLIST())
		}
		else
		{
			&SQL(update sqluser.DHC_PE_ILLSAlias values :PLIST() where ILLSA_RowId=:RowId)
		}
	}
	q SQLCODE
}

ClassMethod OutSexToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='Sex_DR_Name' id='Sex_DR_Name' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>  </option>",!
	w "<option value='M'>男</option>",!
	w "<option value='F'>女</option>",!
	w "<option value='N'>不详</option>",!
	w "</select>",!
	Quit $$$OK
}

/// function :通过疾病获取疾病别名
/// debug:d ##class(web.DHCPE.IllnessStandard).GetAliasByEDID()
ClassMethod GetAliasByEDID(EDRowID As %Library.String = "")
{
	q:EDRowID="" ""
	s DescStr=""
	S id=""
	f  s id=$o(^DHCPEILLSA(id)) q:(id="")  d
	.S ILLSID=$P($G(^DHCPEILLSA(id)),"^",1)
	.Q:EDRowID'=ILLSID
	.s Desc=$P($G(^DHCPEILLSA(id)),"^",2)
	.i DescStr="" s DescStr=Desc
	.e  s DescStr=DescStr_","_Desc
	q DescStr
}

Query QueryED(Code As %Library.String = "", DiagnoseConclusion As %Library.String = "", Alias As %Library.String = "") As %Query(ROWSPEC = "ED_RowId:%String, ED_Detail:%String, ED_DiagnoseConclusion:%String, ED_Code:%String,ED_Illness:%String,ED_CommonIllness:%String,TToReport:%String,TSex:%String,TType:%String,AliasDesc:%String")
{
}

ClassMethod QueryEDExecute(ByRef qHandle As %Binary, Code As %Library.String = "", DiagnoseConclusion As %Library.String = "", Alias As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s Code=$ZCVT(Code,"U")
	s DiagnoseConclusion=$ZCVT(DiagnoseConclusion,"U")
	s Alias=$ZCVT(Alias,"U")
	s CurUser=%session.Get("LOGON.USERID")
	s ind=1
 	i Alias=""
 	{
	s EDID=0
	f  s EDID=$o(^DHCPEILLS(EDID)) q:EDID=""  d
	.s RowId=EDID
	.s User=$p(^DHCPEILLS(EDID),"^",4)
	.q:(User'="")&&(User'=CurUser)
	.d SetDataQueryED
 	}
 	else
 	{
	 	s RowIds="^"
	 	s TextDesc=Alias
		s TextDesc=$O(^DHCPEILLSA(0,"Alias",Alias),-1)
	 	f  s TextDesc=$O(^DHCPEILLSA(0,"Alias",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Alias)  d
		.s ARowId=0
		.f  s ARowId=$O(^DHCPEILLSA(0,"Alias",TextDesc,ARowId)) q:ARowId=""  d
		..s RowId=$p($g(^DHCPEILLSA(ARowId)),"^",1)
		..q:RowId=""
		..q:RowIds[("^"_RowId_"^")
		..s RowIds=RowIds_RowId_"^"
		..d SetDataQueryED
 	}
   
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetDataQueryED
	s (Detail,DC,UCode,Illness,CommonIllness,AliasDesc)=""
	q:RowId=""
	s EDAliaID=0
	
	s DC=$P($G(^DHCPEILLS(RowId)),"^",3)
	s Detail=$P($G(^DHCPEILLS(RowId)),"^",2)
	s UDC=$ZCVT(Detail,"U")
	q:UDC'[DiagnoseConclusion
	s CCode=$P($G(^DHCPEILLS(RowId)),"^",1)
	s UCode=$ZCVT(CCode,"U")
	q:UCode'[Code
	s Illness=$P($G(^DHCPEILLS(RowId)),"^",6)
	s CommonIllness=$P($G(^DHCPEILLS(RowId)),"^",7)
	I CommonIllness="Y" S CommonIllness="是"
	E  S CommonIllness="否"
	s ToReport=$P($G(^DHCPEILLS(RowId)),"^",8)
	s Sex=$P($G(^DHCPEILLS(RowId)),"^",9)
	s Sex=$S(Sex="F":"女",Sex="M":"男",Sex="N":"不限",Sex="":"")
	s Type=$P($G(^DHCPEILLS(RowId)),"^",11)
	s Type=..GetTypeDesc(Type)
	
	s AliasDesc=..GetAliasByEDID(RowId)
	s TypeNew=$P($G(^DHCPEILLS(RowId)),"^",12)
	s TypeNewDesc=..GetTypeNewDesc(TypeNew)
	/*
	{id:'1',text:'分类'},
            {id:'2',text:'疾病'},
            {id:'3',text:'项目'},
            */
	s ILLSStationDesc=""
	s ILLSStation=$P($G(^DHCPEILLS(RowId)),"^",13)
	s:(ILLSStation'="") ILLSStationDesc=$p(^DHCPEST(ILLSStation),"^",2)
	s FatherIllDesc=""
	s FatherIll=$P($G(^DHCPEILLS(RowId)),"^",14)
	s:(FatherIll'="") FatherIllDesc=$P($G(^DHCPEILLS(FatherIll)),"^",2)
	
	s Note=$P($G(^DHCPEILLS(RowId)),"^",15)
	
	d QueryED
	q
	
QueryED      
	set Data=$lb(RowId, DC, Detail, CCode,Illness,CommonIllness,ToReport,Sex,Type,AliasDesc,TypeNew,ILLSStation,FatherIll,Note,TypeNewDesc,ILLSStationDesc,FatherIllDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryEDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEDExecute ]
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

ClassMethod QueryEDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod InitED(EDRowId As %Library.String = "")
{
	s EDStr=$g(^DHCPEILLS(EDRowId))
	q EDStr
}

ClassMethod DeleteED(EDRowId As %Library.String = "")
{
	TSTART
	&sql(Delete from sqluser.DHC_PE_IllnessStandard where ILLS_RowId=:EDRowId)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&sql(Delete from sqluser.DHC_PE_ILLSAlias where ILLSA_ILLS_DR=:EDRowId)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(delete from sqluser.DHC_PE_IDRelate where IDR_ILLS_DR=:EDRowId)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	Q SQLCODE
}

ClassMethod UpdateED(EDRowId As %Library.String = "", DataStr As %Library.String = "")
{
	s DateUpdate=+$h
	s l=$L(DataStr,"^")
	for i=1:1:l
	{
		s PLIST(i+1)=$P(DataStr,"^",i)
	}
	k PLIST(5)
	s PLIST(6)=DateUpdate
	&sql(Update sqluser.DHC_PE_IllnessStandard 
		values :PLIST()
		where ILLS_RowId=:EDRowId)
		
	Q SQLCODE
}

ClassMethod GetEDName(EDId)
{
	i EDId="" q ""
	q $P(^DHCPEILLS(EDId),"^",2)
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.IllnessStandard","GetEDiagnosisByAlias","")
Query GetEDiagnosisByAlias(AddDiagnosis As %Library.String = "") As %Query(ROWSPEC = "HIDDEN:%String, Detail:%String:疾病名称, DiagnoseConclusion:%String:疾病建议, Code:%String:编码")
{
}

ClassMethod GetEDiagnosisByAliasExecute(ByRef qHandle As %Binary, AddDiagnosis As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s Desc=$ZCVT(AddDiagnosis,"U")
	s CurUser=%session.Get("LOGON.USERID")
	s ind=1
 	i Desc=""
 	{
	 	s EDID=0
	 	f  s EDID=$o(^DHCPEILLS(EDID)) q:EDID=""  d
	 	.s RowId=EDID
	 	.s User=$p(^DHCPEILLS(EDID),"^",4)
	 	.q:(User'="")&&(User'=CurUser)
	 	.d SetDataGetEDiagnosisByAlias
	 	.//d GetEDiagnosisByAlias
 	}
 	else
 	{
	 	s RowIds="^"
	 	///?????
		s TextDesc=$O(^DHCPEILLSA(0,"Alias",Desc),-1)
	 	f  s TextDesc=$O(^DHCPEILLSA(0,"Alias",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Desc)  d
		.s ARowId=0
		.f  s ARowId=$O(^DHCPEILLSA(0,"Alias",TextDesc,ARowId)) q:ARowId=""  d
		..s RowId=$p($g(^DHCPEILLSA(ARowId)),"^",1)
		..q:RowId=""
		..q:RowIds[("^"_RowId_"^")
		..s RowIds=RowIds_RowId_"^"
		..
		..s User=$p($g(^DHCPEILLS(RowId)),"^",4)
		..q:(User'="")&&(User'=CurUser)
		..d SetDataGetEDiagnosisByAlias
	 	..//d GetEDiagnosisByAlias
	 	///?????
	 	s TextDesc=$O(^DHCPEILLS(0,"CODE",Desc),-1)
	 	f  s TextDesc=$O(^DHCPEILLS(0,"CODE",TextDesc)) Q:((""=TextDesc)||(TextDesc'[Desc))  d
		.s RowId=0
		.f  s RowId=$O(^DHCPEILLS(0,"CODE",TextDesc,RowId)) q:RowId=""  d
		..q:RowId=""
		..q:RowIds[("^"_RowId_"^")
		..s RowIds=RowIds_RowId_"^"
		..s User=$p(^DHCPEILLS(RowId),"^",4)
		..q:(User'="")&&(User'=CurUser)
		..d SetDataGetEDiagnosisByAlias
	 	..//d GetEDiagnosisByAlias
	 	///?????
	 	s TextDesc=$O(^DHCPEILLS(0,"Desc",Desc),-1)
	 	f  s TextDesc=$O(^DHCPEILLS(0,"Desc",TextDesc)) Q:(""=TextDesc)||(TextDesc'[Desc)  d
		.s RowId=0
		.f  s RowId=$O(^DHCPEILLS(0,"Desc",TextDesc,RowId)) q:RowId=""  d
		..q:RowId=""
		..q:RowIds[("^"_RowId_"^")
		..s RowIds=RowIds_RowId_"^"
		..s User=$p(^DHCPEILLS(RowId),"^",4)
		..q:(User'="")&&(User'=CurUser)
		..d SetDataGetEDiagnosisByAlias
	 	..//d GetEDiagnosisByAlias
 	}
   
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetDataGetEDiagnosisByAlias
	s (Detail,DC,Code)=""
	q:RowId=""
	s Detail=$P($G(^DHCPEILLS(RowId)),"^",3)
	s DC=$P($G(^DHCPEILLS(RowId)),"^",2)
	s Code=$P($G(^DHCPEILLS(RowId)),"^",1)
	d GetEDiagnosisByAlias
	q
	
GetEDiagnosisByAlias      
	set Data=$lb(RowId, DC, Detail, Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetEDiagnosisByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEDiagnosisByAliasExecute ]
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

ClassMethod GetEDiagnosisByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEDiagnosisByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query EDCondition(ParrefRowId As %Library.String = "", EDID As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TILLNessID:%String,TILLNessDesc:%String,TEDID:%String,TEDDesc:%String,TEDDetail:%String,TEDCode:%String")
{
}

ClassMethod EDConditionExecute(ByRef qHandle As %Binary, ParrefRowId As %String = "", EDID As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	if ParrefRowId'="" d
 	.s IDRID=0
 	.f  s IDRID=$o(^DHCPEIDR(0,"ILLSDR",ParrefRowId,IDRID)) q:IDRID=""  d
 	..d GetOneDetail
	e  i EDID'="" d
	.s IDRID=0
 	.f  s IDRID=$o(^DHCPEIDR(0,"EDDR",EDID,IDRID)) q:IDRID=""  d
 	..d GetOneDetail
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 	q 
GetOneDetail
	s ILLDR=$p($g(^DHCPEIDR(IDRID)),"^",2)
	q:ILLDR=""
	s ILLDesc=$p($G(^DHCPEILLS(ILLDR)),"^",2)
	s EDDR=$p(^DHCPEIDR(IDRID),"^",1)
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ED", EDDR)
	q:LocFlag=1
	s EDDesc=$p($G(^DHCPEED(EDDR,1)),"^",1)
	s EDCode=$p($G(^DHCPEED(EDDR,1)),"^",6)
	s EDDetail=$p($G(^DHCPEED(EDDR,"Detail")),"^",1)
	d Build
	q
Build
	set Data=$lb(IDRID,ILLDR,ILLDesc,EDDR,EDDesc,EDDetail,EDCode)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod EDConditionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EDConditionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod EDConditionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EDConditionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetILLNessDesc(ILLNessID)
{
	q:ILLNessID="" ""
	q $p($G(^DHCPEILLS(ILLNessID)),"^",2)
}

ClassMethod GetEDDesc(EDID)
{
	q:EDID="" ""
	q $p($G(^DHCPEED(EDID,1)),"^",1)
}

ClassMethod UpdateIDR(InString, isDelete)
{
	if (isDelete=1) d
	.&SQL(Delete from sqluser.DHC_PE_IDRelate where IDR_RowId=:InString)
	e  d
	.s RowID=$p(InString,"^",1)
	.s PLIST(2)=$p(InString,"^",2)
	.s PLIST(3)=$p(InString,"^",3)
	.if RowID'=""  d
	..&SQL(update sqluser.DHC_PE_IDRelate values :PLIST() where IDR_RowId=:RowID)
	.e  d
	..&SQL(select IDR_ED_DR,IDR_ILLS_DR from sqluser.DHC_PE_IDRelate where IDR_ED_DR=:PLIST(2)and IDR_ILLS_DR=:PLIST(3))
	..if SQLCODE=0 d
	...s SQLCODE="疾病和建议已经对照,不能重复添加"
	..e  d
	...&SQL(insert into sqluser.DHC_PE_IDRelate values :PLIST())
	q SQLCODE
}

/// creator:wangfujian
/// creatDate:2009-05-13
/// description:查询专家诊断或疾病
/// inputData:专家诊断或疾病 的 别名
/// d ##class(%ResultSet).RunQuery("web.DHCPE.IllnessStandard","GetEDorIllByAlias","前列腺增大")
Query GetEDorIllByAlias(EDorILLAlias As %Library.String = "", Illness As %Library.String = "", CommonIllness As %Library.String = "", CTLocID As %String = "") As %Query(ROWSPEC = "HIDDEN:%String, Detail:%String, DiagnoseConclusion:%String, Code:%String")
{
}

ClassMethod GetEDorIllByAliasExecute(ByRef qHandle As %Binary, EDorILLAlias As %String = "", Illness As %Library.String = "", CommonIllness As %Library.String = "", CTLocID As %String = "") As %Status
{
    
	Set repid=$I(^CacheTemp)
	s ind=1
	s alias=$ZCVT(EDorILLAlias,"U")
	//s GRDiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	s GRDiagnosisType=$p($G(^DHCPESetting("DHCPE","GRDiagnosisType",CTLocID)),"^",1)
	i GRDiagnosisType="N" d
	.//按专家诊断查询
	.i alias="" d
	..//如果默认查处所以专家诊断
	..s EDID=0
	..f  s EDID=$o(^DHCPEED(EDID)) q:EDID=""  d
	...s RowId=EDID
	...d outEDData
	.e  d
	..//按诊断结论查询
	..s TextDesc=$O(^DHCPEED(0,"Conclusion",alias),-1)
	..f  s TextDesc=$O(^DHCPEED(0,"Conclusion",TextDesc)) Q:(""=TextDesc)||(TextDesc'[alias)  d
	...s EDID=0
	...f  s EDID=$o(^DHCPEED(0,"Conclusion",TextDesc,EDID)) q:EDID=""  d
	....s RowId=EDID
	....d outEDData
	..//按诊断别名查询
	..s TextDesc=$O(^DHCPEEDA(0,"Alias",alias),-1)
	..f  s TextDesc=$O(^DHCPEEDA(0,"Alias",TextDesc)) Q:(""=TextDesc)||(TextDesc'[alias)  d
	...s EDAId=0
	...f  s EDAId=$o(^DHCPEEDA(0,"Alias",TextDesc,EDAId)) q:EDAId=""  d
	....s EDID=$P($g(^DHCPEEDA(EDAId)),"^",1)
	....s RowId=EDID
	....d outEDData
	e  d
	.//按疾病 查询
	.i alias="" d
	..s illID=0
	..f  s illID=$o(^DHCPEILLS(illID)) q:illID=""  d
	...s RowId=illID
	...d outIllData
	.e  d
	..s TextDesc=$o(^DHCPEILLS(0,"Desc",alias),-1)
	..f  s TextDesc=$o(^DHCPEILLS(0,"Desc",TextDesc)) Q:(""=TextDesc)||(TextDesc'[alias)  d
	...s illID=0
	...f  s illID=$o(^DHCPEILLS(0,"Desc",alias,illID)) q:illID=""  d
	....s RowId=illID
	....d outIllData
	..//按疾病别名查询
	..s TextDesc=$o(^DHCPEILLSA(0,"Alias",alias),-1)
	..f  s TextDesc=$o(^DHCPEILLSA(0,"Alias",TextDesc)) Q:(""=TextDesc)||(TextDesc'[alias)  d
	...s illAID=0
	...f  s illAID=$o(^DHCPEILLSA(0,"Alias",alias,illAID)) q:illAID=""  d
	....s illID=$P($g(^DHCPEILLSA(illAID)),"^",1)
	....s RowId=illID
	....d outIllData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outEDData
	Q:RowId=""
	s Code=$p($g(^DHCPEED(RowId,1)),"^",6)
	s Detail=$p($g(^DHCPEED(RowId,"Detail")),"^",1)
	s DC=$p($g(^DHCPEED(RowId,1)),"^",1)
	S EDCommonIllness=$p($g(^DHCPEED(RowId,1)),"^",5)
	q:(CommonIllness="Y")&&(CommonIllness'=EDCommonIllness)
	d OUTDATA
	q 
outIllData
  
	Q:RowId=""
	s Code=$p($g(^DHCPEILLS(RowId)),"^",1)
	s Detail=$p($g(^DHCPEILLS(RowId)),"^",3)
	s DC=$p($g(^DHCPEILLS(RowId)),"^",2)
	S EDCommonIllness=$p($g(^DHCPEILLS(RowId)),"^",7)
	q:(CommonIllness="Y")&&(CommonIllness'=EDCommonIllness)
	d OUTDATA

	Q
OUTDATA
	set Data=$lb(RowId,  Detail,DC, Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetEDorIllByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEDorIllByAliasExecute ]
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

ClassMethod GetEDorIllByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEDorIllByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SaveIllExplain(InString)
{
 s Return="0"	
 s IllRowID=$P(InString,"^",1)
 s IllExplain=$P(InString,"^",2)
 s Type=$P(InString,"^",3)
 s PrintType=$P(InString,"^",4)
 s CurUser=%session.Get("LOGON.USERID")
 i Type="1"  s Node="IllExplain"
 i Type="2"  s Node="SportGuide"
 i Type="3"  s Node="DietGuide"
 i IllExplain=""  d
 .i $D(^DHCPECTDataEx("BaseData","IllnessStandard",Node,IllRowID))  k ^DHCPECTDataEx("BaseData","IllnessStandard",Node,IllRowID)
 .else  s Return="请输入描述内容"
 else  s ^DHCPECTDataEx("BaseData","IllnessStandard",Node,IllRowID)=IllExplain_"@@"_PrintType_"@@"_CurUser_"@@"_$H
 q Return
}

ClassMethod GetIllInfo(IllRowID, Type)
{
 s Return=""
 q:IllRowID="" Return
 i Type="1"  d 
 .s Return=$G(^DHCPECTDataEx("BaseData","IllnessStandard","IllExplain",IllRowID))
 i Type="2"  d
 .s Return=$G(^DHCPECTDataEx("BaseData","IllnessStandard","SportGuide",IllRowID))
 i Type="3"  d
 .s Return=$G(^DHCPECTDataEx("BaseData","IllnessStandard","DietGuide",IllRowID))
 
 q Return
}

Query GetIllByAlias(EDorILLAlias As %Library.String = "") As %Query(ROWSPEC = "HIDDEN:%String, DiagnoseConclusion:%String,Detail:%String,  Code:%String")
{
}

ClassMethod GetIllByAliasExecute(ByRef qHandle As %Binary, EDorILLAlias As %String = "") As %Status
{
   
	Set repid=$I(^CacheTemp)
	s ind=1
	s alias=$ZCVT(EDorILLAlias,"U")
    i alias="" d
	.s illID=0
	.f  s illID=$o(^DHCPEILLS(illID)) q:illID=""  d
	..s RowId=illID
	..d output
	e  d
	.s TextDesc=$o(^DHCPEILLS(0,"Desc",alias),-1)
	.f  s TextDesc=$o(^DHCPEILLS(0,"Desc",TextDesc)) Q:(""=TextDesc)||(TextDesc'[alias)  d
	..s illID=0
	..f  s illID=$o(^DHCPEILLS(0,"Desc",alias,illID)) q:illID=""  d
	...s RowId=illID
	...d output
	.//按疾病别名查询
	.s TextDesc=$o(^DHCPEILLSA(0,"Alias",alias),-1)
	.f  s TextDesc=$o(^DHCPEILLSA(0,"Alias",TextDesc)) Q:(""=TextDesc)||(TextDesc'[alias)  d
	..s illAID=0
	..f  s illAID=$o(^DHCPEILLSA(0,"Alias",alias,illAID)) q:illAID=""  d
	...s illID=$P($g(^DHCPEILLSA(illAID)),"^",1)
	...s RowId=illID
	...d output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

output
  
	Q:RowId=""
	s Code=$p($g(^DHCPEILLS(RowId)),"^",1)
	s Detail=$p($g(^DHCPEILLS(RowId)),"^",3)
	s IllDesc=$p($g(^DHCPEILLS(RowId)),"^",2)
	d OUTDATA

	Q
OUTDATA
	set Data=$lb(RowId,  IllDesc, Detail,Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetIllByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIllByAliasExecute ]
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

ClassMethod GetIllByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIllByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OutTypeToHtml(ContrlWidth As %String = "", DefaultValue As %String = "")
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='ReportType' id='ReportType' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	s:DefaultValue="" DefaultValue="1"
	s Flag=""
	s:DefaultValue=1 Flag=" selected"
	w "<option value='1'"_Flag_">"_..GetTypeDesc(1)_"</option>",!
	s Flag=""
	s:DefaultValue=2 Flag=" selected"
	w "<option value='2'"_Flag_">"_..GetTypeDesc(2)_"</option>",!
	s Flag=""
	s:DefaultValue=3 Flag=" selected"
	w "<option value='3'"_Flag_">"_..GetTypeDesc(3)_"</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod GetTypeDesc(Type)
{
	q:Type="1" "团体报告"
	q:Type="2" "妇科统计"
	q:Type="3" "阳性统计"
	q ""
}

ClassMethod GetTypeNewDesc(Type)
{
	q:Type="1" "分类"
	q:Type="2" "疾病"
	q:Type="3" "项目"
	q ""
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.IllnessStandard","FindPISCodeNew")
Query FindIllAlias(ILLSRowID As %Library.String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindIllAliasExecute(ByRef qHandle As %Binary, ILLSRowID As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s id=0
	f  s id=$o(^DHCPEILLSA(id)) q:(id="")  d
	.S ILLSID=$P($G(^DHCPEILLSA(id)),"^",1)
	.Q:(ILLSRowID'=ILLSID)&(ILLSRowID'="")
	.s Desc=$P($G(^DHCPEILLSA(id)),"^",2)
	.s ^CacheTemp(repid,ind)=$lb(id,Desc)
	.s ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}

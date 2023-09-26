/// CTOR: QP
/// DATE: 2017-02-28
/// VERN: V4.1.3
/// DESC: 抗菌药物基础数据配置表操作类
Class DHCAnt.KSS.Config.BaseData Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2017-02-28
/// DESC: 
/// IN  : 
/// EXEC: w ##class(DHCAnt.KSS.Config.BaseData).GeTreeBasedataType()
ClassMethod GeTreeBasedataType() As %String
{
	n 
	s num=0,rowId=0
	s SHUI=1	;##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SHUI")
	k ^TEMP("DHCAnt","KSS",$j)
	f  s rowId=$o(^DHCAntBaseMainConfigI("MCGParentCode","BASECFG",rowId))  q:rowId=""  d
	.s num=num+1
	.s code=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",3)
 	.s desc=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",4) 
 	.s active=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",5)
 	.q:active'=1
 	.s sqeno=$P($g(^DHCAntBaseMainConfigD(rowId)),"^",12)
 	.i sqeno="" s sqeno=0	//处理显示顺序为空
	.s url=$P($g(^DHCAntBaseMainConfigD(rowId)),"^",13)
	
	.i url="" d
	..i SHUI=1 s url="dhcant.kss.config.basedata.center.hui.csp"
	..e  s url="dhcant.kss.config.basedata.center.csp"
	.s ^TEMP("DHCAnt","KSS",$j,sqeno,code)=desc_"^"_code_"^"_url
	i num=0 w "[]"
	q:num=0 ""
	w "[",!
	w "{""text"":"_"""基础数据"",",!
	w """children"":["
	s num=0,seqnum=""
	f  s seqnum=$O(^TEMP("DHCAnt","KSS",$j,seqnum)) q:seqnum=""  d
	.s curCode=""
	.f  s curCode=$O(^TEMP("DHCAnt","KSS",$j,seqnum,curCode)) q:curCode=""  d
	..s num=num+1
	..s resultStr=$g(^TEMP("DHCAnt","KSS",$j,seqnum,curCode))
	..s code=$p(resultStr,"^",2),value=$p(resultStr,"^",1),url=$p(resultStr,"^",3)
	..;s desc=seqnum_"、"_value
	..s desc=value	//num_"、"_value
	..i num=1 w "{""id"":"_""""_code_""", ""text"":"_""""_desc_""",""url"":"""_url_"?type="_code_"""}",!
	..e  w ",{""id"":"_""""_code_""", ""text"":"_""""_desc_""",""url"":"""_url_"?type="_code_"""}",!
	w "]",!
	w "}]"
	
	q ""
}

/// CTOR: QP
/// DATE: 2016-09-04
/// DESC: 抗菌药物字典查询Query
/// IN  : type: 表类型
/// 		  parentscode: 父级类型
/// 		  baseFlag: 是否激活
/// 		  isspecial：特殊标志
/// OUT : 		
/// EXEC:  d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.BaseData","QryAllbasedata","CONDOC")
Query QryAllbasedata(type As %String, parDr As %String = "", itemDr As %String = "", InHosp = "") As %Query(ROWSPEC = "id,tableType,tableName,code,desc,parCode,active,aimItem,specialFlag,descText,parDesc,infectDepFlag,aimItemDesc,hospDr,hospName")
{
}

ClassMethod QryAllbasedataExecute(ByRef qHandle As %Binary, type As %String, parDr As %String = "", itemDr As %String = "", InHosp = "") As %Status
{
	q:type="" ""
	Set repid=$I(^CacheTemp)
 	s ind=1
    s pdcId=""
    f  s pdcId=$o(^DHCAntBasePurposeDataConfigD(pdcId)) q:pdcId=""  d
    .s tableType=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",1)
    .q:(tableType'=type)&&(tableType'="")	//过滤表类型
    .s tableName=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",2)	//表类型描述
    .s code=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",4) 	//代码
    .s desc=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",3)	//描述
    .s parCode=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",6)	//父级值
    .q:(parDr'="")&&(parCode'=parDr)
    .s parDesc="",descText=""
    .Q:(tableType="CONDOC")&&('$D(^CTPCP(desc,1)))
    .i tableType="CONLOC"  d
    ..s descText=$p(^CTLOC(desc),"^",2)
    ..i descText["-" s descText=$p(descText,"-",2)
    .i tableType="CONDOC" d
    ..s descText=$p(^CTPCP(desc,1),"^",2)
    ..s parDesc=$p(^CTLOC(parCode),"^",2)
    ..i parDesc["-" s parDesc=$p(parDesc,"-",2)
    .s active=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",5)	//是否激活
    .s aimItem=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",7)	//使用目的子类
    .Q:(itemDr'="")&&(aimItem'=itemDr)
    .i (tableType="AIMITEM")||(tableType="IND") d
    ..s:parCode'="" parDesc=$p(^DHCAntBasePurposeDataConfigD(parCode),"^",3)
    .i tableType="AIM" d
    ..s:parCode'="" parDesc=$p(^DHCAntBasePurposeDataConfigD(parCode),"^",3)
    ..s:aimItem'="" aimItemDesc=$p(^DHCAntBasePurposeDataConfigD(aimItem),"^",3)   
    .s specialFlag=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",8)	//特殊标志
    .s infectDepFlag=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",9)	//感染性疾病科标志
    .s hospDr=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",11)
    .s hospName=""
    .i hospDr'="" s hospName=$p(^CT("HOSP",hospDr),"^",2)
    .q:(InHosp'="")&&(hospDr'=InHosp)
   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(pdcId,tableType,tableName,code,desc,parCode,active,aimItem,specialFlag,descText,parDesc,infectDepFlag,aimItemDesc,hospDr,hospName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryAllbasedataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAllbasedataExecute ]
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

ClassMethod QryAllbasedataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAllbasedataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2016-09-04
/// DESC: 抗菌药物字典查询Query
/// IN  : type: 表类型
/// 		  parentscode: 父级类型
/// 		  baseFlag: 是否激活
/// 		  isspecial：特殊标志
/// OUT : 		
/// EXEC:  d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.BaseData","QryConLoc")
Query QryConLoc(InHosp = "") As %Query(ROWSPEC = "id,text,code")
{
}

ClassMethod QryConLocExecute(ByRef qHandle As %Binary, InHosp = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s pdcId=""
 	f  s pdcId=$o(^DHCAntBasePurposeDataConfigI("PDCType","CONLOC",pdcId)) q:pdcId=""  d
 	.s id=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",3)	//描述
 	.s active=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",5)	//描述
 	.s hospDr=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",11)
 	.q:(active'=1)||(hospDr="")
 	.q:(InHosp'="")&&(InHosp'=hospDr)
 	.q:id=""
 	.s text=$p(^CTLOC(id),"^",2)
 	.s code=$p(^CTLOC(id),"^",43)
 	.i text["-" s text=$p(text,"-",2)
   	.Do OutwardRow2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow2
	set Data=$lb(id,text,code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryConLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryConLocExecute ]
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

ClassMethod QryConLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryConLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 向基础数据表插入数据
/// w ##class(DHCAnt.KSS.Config.BaseData).DBSaveBasedata("57^CONLOC^会诊科室^11^GREK-感染二科^1^^^")
ClassMethod DBSaveBasedata(para)
{
	s ^TEMP("QP",1)=para
	s flag=0
	s Id=$p(para,"^",1)
	s Type=$p(para,"^",2)
	s TypeDesc=$p(para,"^",3)
	s Value=$p(para,"^",4)
	s Code=$p(para,"^",5)
	s Active=$p(para,"^",6)
	s ParentOBJ=$p(para,"^",7)
	s ParentAimItem=$p(para,"^",8)
	s SpecialFlag=$p(para,"^",9)
	s InfectDepFlag=$p(para,"^",10)
	s hosp=$p(para,"^",11)
	
	i (Id=""){
		s obj=##class(DHCAnt.Base.PurposeDataConfig).%New()	
		/*&sql(select count(*) into :mycount from DHCAnt_Base.PurposeDataConfig where (PDC_Type=:Type)and(PDC_TypeDesc=:TypeDesc)
		and(PDC_Value=:Value)and(PDC_Code=:Code)and(PDC_ParentOBJ=:ParentOBJ)and(PDC_ParentAimItem=:ParentAimItem)and(PDC_SpecialFlag=:SpecialFlag))*/
			q:'$IsObject(obj) flag
			s obj.PDCType=Type
			s obj.PDCTypeDesc=TypeDesc
			s obj.PDCValue=Value
			s obj.PDCCode=Code
			s obj.PDCActive=Active
			s obj.PDCParentOBJ=ParentOBJ
			s obj.PDCParentAimItem=ParentAimItem
			s obj.PDCSpecialFlag=SpecialFlag
			s obj.PDCInfectDepFlag=InfectDepFlag
			d obj.PDCHospSetObjectId(hosp)
			s sc=obj.%Save()
		    if $System.Status.IsError(sc){
		        //d $System.Status.DisplayError(sc)
		        s flag=-1    
		    }else{
		        s flag=obj.%Id()
		    }
		    d obj.%Close()
		    q flag
		
	}else{
		s obj=##class(DHCAnt.Base.PurposeDataConfig).%OpenId(Id)
		q:'$IsObject(obj) flag
		s obj.PDCType=Type
			s obj.PDCTypeDesc=TypeDesc
			s obj.PDCValue=Value
			s obj.PDCCode=Code
			s obj.PDCActive=Active
			s obj.PDCParentOBJ=ParentOBJ
			s obj.PDCParentAimItem=ParentAimItem
			s obj.PDCSpecialFlag=SpecialFlag
			s obj.PDCInfectDepFlag=InfectDepFlag
			d obj.PDCHospSetObjectId(hosp)
			s sc=obj.%Save()
		    if $System.Status.IsError(sc){
		        //d $System.Status.DisplayError(sc)
		        s flag=-1    
		    }else{
		        s flag=obj.%Id()
		    }
		    d obj.%Close()
		    q flag	
	}
}

/// CTOR: QP
/// DATE: 2017-10-26
/// DESC: 判断会诊科室是否添加
/// IN  : 
/// OUT : 1:已添加，0:未添加
/// EXEC: w ##class(DHCAnt.KSS.Config.BaseData).ifHasConLoc("114")
ClassMethod ifHasConLoc(conLocId As %String = "") As %String
{
	n (conLocId)
	q:conLocId="" 1
	s rowid="",flag=0
	f  s rowid=$o(^DHCAntBasePurposeDataConfigI("PDCType","CONLOC",rowid)) q:(rowid="")||(flag=1)  d
	.s locid=$p(^DHCAntBasePurposeDataConfigD(rowid),"^",3)
	.i conLocId=locid s flag=1
	
	q flag
}

/// CTOR: QP
/// DATE: 2017-10-26
/// DESC: 判断会诊医生是否添加
/// IN  : 
/// OUT : 1:已添加，0:未添加
/// EXEC: w ##class(DHCAnt.KSS.Config.BaseData).ifHasConDoc("67")
ClassMethod ifHasConDoc(conDocId = "", InHosp = "", InLoc = "", id = "") As %String
{
	n (conDocId,InHosp,InLoc,id)
	q:conDocId="" 1
	s rowid="",flag=0
	f  s rowid=$o(^DHCAntBasePurposeDataConfigI("PDCType","CONDOC",rowid)) q:(rowid="")||(flag=1)  d
	.q:(id'="")&&(id=rowid)
	.s docid=$p(^DHCAntBasePurposeDataConfigD(rowid),"^",3)
	.s loc=$p(^DHCAntBasePurposeDataConfigD(rowid),"^",6)
	.s hospDr=$p(^DHCAntBasePurposeDataConfigD(rowid),"^",11)
	.i (docid=conDocId)&&(hospDr=InHosp)&&(InLoc=loc) s flag=1
	
	q flag
}

}

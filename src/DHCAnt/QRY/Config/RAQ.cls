/// CTOR: QP
/// DATE: 2017-05-02
/// DESC: 抗菌统计分析报表配置操作类
Class DHCAnt.QRY.Config.RAQ Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2017-08-08
/// DESC: 保存基本信息维护表数据
/// IN  : 
/// OUT :
/// Table: DHCWLBaseInforCFG
/// w ##class(DHCAnt.QRY.Config.RAQ).DBSavePBICfgData("")
ClassMethod DBSavePBICfgData(para, separator = "")
{
	n (para, separator)
	i separator="" s separator="^"
	s mRtn=0
	s Id = $p(para,separator,1)
	s code = $p(para,separator,2)
	s desc = $p(para,separator,3)
	s interFlag = $p(para,separator,4)
	s dateFlag = $p(para,separator,5)
	s nature = $p(para,separator,6)
	s func = $p(para,separator,7)
	s bicId=$o(^DHCWLBIC(0,"Code",code,""))
	
	if (Id=""){
		if (bicId '="") {
			Q mRtn	//已维护
		}
		s BICobj=##class(User.DHCWLBaseInforCFG).%New()
		s BICobj.BICCode=code
		s BICobj.BICDesc=desc
		s BICobj.BICDateFlag=dateFlag
		s BICobj.BICInterFlag=interFlag
		s BICobj.BICNature=nature
		s BICobj.BICFunction=func
		s sc=BICobj.%Save()
		if $System.Status.IsError(sc){
			//d $System.Status.DisplayError(sc)
			s mRtn=-1    
		}else{
			s mRtn=BICobj.%Id()
		}
		d BICobj.%Close()
	} else {
		if (bicId ="") {
			Q mRtn	//没有此条记录
		}
		s BICobj=##class(User.DHCWLBaseInforCFG).%OpenId(Id)
		s BICobj.BICCode=code
		s BICobj.BICDesc=desc
		s BICobj.BICDateFlag=dateFlag
		s BICobj.BICInterFlag=interFlag
		s BICobj.BICNature=nature
		s BICobj.BICFunction=func
		s sc=BICobj.%Save()
		
		if $System.Status.IsError(sc){
			//d $System.Status.DisplayError(sc)
			s mRtn=-1    
		}else{
			s mRtn=BICobj.%Id()
		}
		d BICobj.%Close()
	}
		
	Q mRtn
}

/// CTOR: QP
/// DATE: 2017-08-08
/// DESC: 保存科室信息维护表数据
/// IN  : 
/// OUT :
/// Table: DHCWLPatDepInforCFG
/// w ##class(DHCAnt.QRY.Config.RAQ).DBSavePDICfgData("")
ClassMethod DBSavePDICfgData(para, separator = "")
{
	n (para, separator)
	i separator="" s separator="^"
	s mRtn=0
	s Id = $p(para,separator,1)
	s code = $p(para,separator,2)
	s desc = $p(para,separator,3)
	s interFlag = $p(para,separator,4)
	s dateFlag = $p(para,separator,5)
	s admtype = $p(para,separator,6)
	s func = $p(para,separator,7)
	s dicId=$o(^DHCWLPDICFG(0,"Code",code,""))
	
	if (Id=""){
		if (dicId '="") {
			Q mRtn	//已维护
		}
		s DICobj=##class(User.DHCWLPatDepInforCFG).%New()
		s DICobj.PDICode=code
		s DICobj.PDIDesc=desc
		s DICobj.PDIDateFlag=dateFlag
		s DICobj.PDIInterFlag=interFlag
		s DICobj.PDIType=admtype
		s DICobj.PDIFunction=func
		s sc=DICobj.%Save()
		if $System.Status.IsError(sc){
			//d $System.Status.DisplayError(sc)
			s mRtn=-1    
		}else{
			s mRtn=DICobj.%Id()
		}
		d DICobj.%Close()
	} else {
		if (dicId ="") {
			Q mRtn	//没有此条记录
		}
		s DICobj=##class(User.DHCWLPatDepInforCFG).%OpenId(Id)
		s DICobj.PDICode=code
		s DICobj.PDIDesc=desc
		s DICobj.PDIDateFlag=dateFlag
		s DICobj.PDIInterFlag=interFlag
		s DICobj.PDIType=admtype
		s DICobj.PDIFunction=func
		s sc=DICobj.%Save()
		
		if $System.Status.IsError(sc){
			//d $System.Status.DisplayError(sc)
			s mRtn=-1    
		}else{
			s mRtn=DICobj.%Id()
		}
		d DICobj.%Close()
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2017-05-02
/// DESC: 保存配置
/// IN  : 
/// OUT :
/// Table: PHCGeneric
/// w ##class(DHCAnt.QRY.Config.RAQ).GetGenericName("16||18")
ClassMethod DBSaveRAQConfig(para, separator = "")
{
	n (para, separator)
	i separator="" s separator="^"
	s Id=$p(para,separator,1)
	s beType=$p(para,separator,2)
	s cfgType=$p(para,separator,3)
	s cfgDesc=$p(para,separator,4)
	s cfgValue=$p(para,separator,5)
	s active=$p(para,separator,6)
	s extendA=$p(para,separator,7)
	s extendB=$p(para,separator,8)
	s extendC=$p(para,separator,9)
	s extendD=$p(para,separator,10)
	s flag=0
	if (Id=""){
		s obj=##class(DHCAnt.QRY.Base.RAQConfig).%New()
		q:'$IsObject(obj) flag
		s obj.RCGBEType=beType
		s obj.RCGCFGType=cfgType
		s obj.RCGCFGDesc=cfgDesc
		s obj.RCGCFGValue=cfgValue
		s obj.RCGActive=active
		s obj.RCGExtendA=extendA
		s obj.RCGExtendB=extendB
		s obj.RCGExtendC=extendC
		s obj.RCGExtendD=extendD
		s sc=obj.%Save()
		if $System.Status.IsError(sc){
		   //d $System.Status.DisplayError(sc)
			s flag=-1    
		}else{
		    s flag=obj.%Id()
		}
		d obj.%Close()
		q flag
	} else {
		s obj=##class(DHCAnt.QRY.Base.RAQConfig).%OpenId(Id)
		q:'$IsObject(obj) flag
		s obj.RCGBEType=beType
		s obj.RCGCFGType=cfgType
		s obj.RCGCFGDesc=cfgDesc
		s obj.RCGCFGValue=cfgValue
		s obj.RCGActive=active
		s obj.RCGExtendA=extendA
		s obj.RCGExtendB=extendB
		s obj.RCGExtendC=extendC
		s obj.RCGExtendD=extendD
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
/// DATE: 2017-05-03
/// DESC: 获取类型配置数值,
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCAnt.QRY.Config.RAQ).GetRaqConfigValue("DATA","SJ-ARCIM",",")
ClassMethod GetRaqConfigValue(beType As %String, cfgType As %String, separator As %String = "") As %String
{
	n (beType, cfgType, separator)
	i separator="" s separator=","
	s rowId="",mRtn="",num=0
	f  s rowId=$o(^DHCAntQRYBaseRAQConfigI("RCGBEType",beType,"RCGCFGType",cfgType,rowId)) q:rowId=""  d
	.s active=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",5)
	.q:active'="Y"
	.s num=num+1
	.s cfgValue=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",4)
	.i num=1 s mRtn=cfgValue
	.e  s mRtn=mRtn_separator_cfgValue
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-05-02
/// DESC: 查询类型通用Query
/// IN  : 
/// OUT :
/// Table: DHCAnt_QRY_Base.RAQConfig
/// d ##class(%ResultSet).RunQuery("DHCAnt.QRY.Config.RAQ","QryCommonType","DATATYPE","")
Query QryCommonType(beType As %String, cfgType As %String) As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryCommonTypeExecute(ByRef qHandle As %Binary, beType As %String = "", cfgType As %String = "") As %Status
{
	n (qHandle,beType,cfgType)
	Set repid=$I(^CacheTemp)
 	Set ind=1
	i (beType="")&&(cfgType="") Set qHandle=$lb(0,repid,0) q $$$OK
	i cfgType="" d
	.s rowId=""
	.f  s rowId=$o(^DHCAntQRYBaseRAQConfigI("RCGBEType",beType,"S1",rowId)) q:rowId=""  d
	..s id=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",2)
	..s text=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",3)
	..s active=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",5)
	..q:active'="Y"
	..d OutputRow1
    e  d
    .s rowId=""
	.f  s rowId=$o(^DHCAntQRYBaseRAQConfigI("RCGBEType",beType,"RCGCFGType",cfgType,rowId)) q:rowId=""  d
	..s id=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",2)
	..s text=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",3)
	..s active=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",5)
	..q:active'="Y"
	..d OutputRow1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	s Data=$ListBuild(id,text)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1	
	q
}

ClassMethod QryCommonTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCommonTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCommonTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCommonTypeExecute ]
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

/// CTOR: QP
/// DATE: 2017-05-02
/// DESC: 查询数据通用Query
/// IN  : 
/// OUT :
/// Table: DHCAnt_QRY_Base.RAQConfig
/// d ##class(%ResultSet).RunQuery("DHCAnt.QRY.Config.RAQ","QryCommonData","DATATYPE","")
Query QryCommonData(beType As %String, cfgType As %String, cfgValue As %String = "", cfgDesc As %String = "") As %Query(ROWSPEC = "rowId,curBeType,curCfgType,curCfgDesc,curCfgValue,curActive,curCfgExtendA,curCfgExtendB,curCfgExtendC,curCfgExtendD")
{
}

ClassMethod QryCommonDataExecute(ByRef qHandle As %Binary, beType As %String = "", cfgType As %String = "", cfgValue As %String = "", cfgDesc As %String = "") As %Status
{
	n (qHandle,beType,cfgType,cfgValue,cfgDesc)
	
	Set repid=$I(^CacheTemp)
 	Set ind=1
	i (beType="")&&(cfgType="") Set qHandle=$lb(0,repid,0) q $$$OK
	i beType="PDI" d
	.s pdiRowid=0,cfgValue=$zcvt(cfgValue,"U") 
	.f  s pdiRowid=$o(^DHCWLPDICFG(pdiRowid)) q:pdiRowid=""  d
	..s curBeType=$p(^DHCWLPDICFG(pdiRowid),"^",3)	//code
	..s curCfgType=$p(^DHCWLPDICFG(pdiRowid),"^",6)	//PDIInterFlag
	..s curCfgValue=$p(^DHCWLPDICFG(pdiRowid),"^",7)	//PDIFunction
	..s curCfgValueUpper=$zcvt(curCfgValue,"U")  
	..q:(cfgValue'="")&&(curCfgValueUpper'[cfgValue)
	..s curCfgDesc=$p(^DHCWLPDICFG(pdiRowid),"^",2)	//desc
	..q:(cfgDesc'="")&&(curCfgDesc'[cfgDesc)
	..s curCfgExtendA=$p(^DHCWLPDICFG(pdiRowid),"^",5)	//PDIDateFlag
	..s curActive=$p(^DHCWLPDICFG(pdiRowid),"^",4)	//
	..s curCfgExtendB="PDI"
	..s curCfgExtendC="",curCfgExtendD=""
	..s rowId=pdiRowid
	..d OutputRow2
	
	 //edit by ws@20200208 增加上过滤条件, 被注释的是之前的代码
	i beType="PBI" d
	.s pbiRowid=0,cfgValue=$zcvt(cfgValue,"U") 
	.f  s pbiRowid=$o(^DHCWLBIC(pbiRowid)) q:pbiRowid=""  d
	..s curBeType=$p(^DHCWLBIC(pbiRowid),"^",3)	//code
	..s curCfgType=$p(^DHCWLBIC(pbiRowid),"^",5)	//interflag
	..s curCfgValue=$p(^DHCWLBIC(pbiRowid),"^",7)	//PDIFunction
	..s curCfgValueUpper=$zcvt(curCfgValue,"U")  
	..q:(cfgValue'="")&&(curCfgValueUpper'[cfgValue)
	..s curCfgDesc=$p(^DHCWLBIC(pbiRowid),"^",2)	//desc
	..q:(cfgDesc'="")&&(curCfgDesc'[cfgDesc)
	..s curCfgExtendA=$p(^DHCWLBIC(pbiRowid),"^",6)	//natrue
	..s curActive=$p(^DHCWLBIC(pbiRowid),"^",4)	//dateflag
	..s curCfgExtendB="PBI"
	..s curCfgExtendC="",curCfgExtendD=""
	..s rowId=pbiRowid
	..d OutputRow2
	/* 这一块是修改前的,下面那块跟这个一样,多了俩过滤条件
	i (cfgType="")&&(beType'="PDI")&&(beType'="PBI") d
	.s rowId=""
	.f  s rowId=$o(^DHCAntQRYBaseRAQConfigI("RCGBEType",beType,"S1",rowId)) q:rowId=""  d
	..s curActive=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",5)
	..;q:curActive'="Y"
	..s curBeType=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",1)
	..s curCfgType=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",2)
	..s curCfgDesc=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",3)
	..s curCfgValue=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",4)
	..s curCfgExtendA=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",6)
	..s curCfgExtendB=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",7)
	..s curCfgExtendC=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",8)
	..s curCfgExtendD=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",9)
	..d OutputRow2
    i (cfgType'="") d
    .s rowId=""
	.f  s rowId=$o(^DHCAntQRYBaseRAQConfigI("RCGBEType",beType,"RCGCFGType",cfgType,rowId)) q:rowId=""  d
	..s curActive=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",5)
	..;q:curActive'="Y"
	..s curBeType=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",1)
	..s curCfgType=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",2)
	..s curCfgDesc=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",3)
	..s curCfgValue=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",4)
	..s curCfgExtendA=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",6)
	..s curCfgExtendB=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",7)
	..s curCfgExtendC=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",8)
	..s curCfgExtendD=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",9)
	..d OutputRow2
	*/
	
	i (cfgType="")&&(beType'="PDI")&&(beType'="PBI") d
	.s rowId="" ,cfgValue=$zcvt(cfgValue,"U") 	// added by ws@20200207 增加过滤语句, 从上面代码复制过来的, 不知为啥这两处之前没过滤条件
	.f  s rowId=$o(^DHCAntQRYBaseRAQConfigI("RCGBEType",beType,"S1",rowId)) q:rowId=""  d
	..s curActive=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",5)
	..;q:curActive'="Y"
	..s curBeType=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",1)
	..s curCfgType=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",2)
	..s curCfgDesc=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",3)
	..q:(cfgDesc'="")&&(curCfgDesc'[cfgDesc)	// added by ws@20200207 增加过滤语句
	..s curCfgValue=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",4)
	..s curCfgValueUpper=$zcvt(curCfgValue,"U") // added by ws@20200207 增加过滤语句
	..q:(cfgValue'="")&&(curCfgValueUpper'[cfgValue)
	..s curCfgExtendA=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",6)
	..s curCfgExtendB=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",7)
	..s curCfgExtendC=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",8)
	..s curCfgExtendD=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",9)
	..d OutputRow2
    i (cfgType'="") d
    .s rowId="" ,cfgValue=$zcvt(cfgValue,"U")
	.f  s rowId=$o(^DHCAntQRYBaseRAQConfigI("RCGBEType",beType,"RCGCFGType",cfgType,rowId)) q:rowId=""  d
	..s curActive=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",5)
	..;q:curActive'="Y"
	..s curBeType=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",1)
	..s curCfgType=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",2)
	..s curCfgDesc=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",3)
	..q:(cfgDesc'="")&&(curCfgDesc'[cfgDesc)	// added by ws@20200207 增加过滤语句
	..s curCfgValue=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",4)
	..s curCfgValueUpper=$zcvt(curCfgValue,"U") // added by ws@20200207 增加过滤语句
	..q:(cfgValue'="")&&(curCfgValueUpper'[cfgValue)
	..s curCfgExtendA=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",6)
	..s curCfgExtendB=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",7)
	..s curCfgExtendC=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",8)
	..s curCfgExtendD=$P(^DHCAntQRYBaseRAQConfigD(rowId),"^",9)
	..d OutputRow2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow2
	s Data=$ListBuild(rowId,curBeType,curCfgType,curCfgDesc,curCfgValue,curActive,curCfgExtendA,curCfgExtendB,curCfgExtendC,curCfgExtendD)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1	
	q
}

ClassMethod QryCommonDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCommonDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCommonDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCommonDataExecute ]
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

/// CTOR: QP
/// DATE: 2017-08-09
/// DESC: 取值标志
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.QRY.Config.RAQ","QryInterFlag")
Query QryInterFlag() As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryInterFlagExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1 
    Set qHandle=$lb(0,repid,0)
    s InterFlag=0
    f  s InterFlag=$O(^DHCWLPatBaseLoadInit("InterFlag",InterFlag)) Q:InterFlag=""  d
	.s id=InterFlag,text=InterFlag
	.d OutputRow3
    
    Quit $$$OK
OutputRow3
    set Data=$lb(id,text)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryInterFlagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInterFlagExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryInterFlagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInterFlagExecute ]
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

/// CTOR: QP
/// DATE: 2017-08-09
/// DESC: 时间属性
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.QRY.Config.RAQ","QryDateFlag")
Query QryDateFlag() As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryDateFlagExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1 
    Set qHandle=$lb(0,repid,0)
    s DateFlag=0
    f  s DateFlag=$O(^DHCWLPatBaseLoadInit("DateFlag",DateFlag)) Q:DateFlag=""  d
	.s id=DateFlag,text=DateFlag
	.d OutputRow4
    
    Quit $$$OK
OutputRow4
    set Data=$lb(id,text)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryDateFlagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDateFlagExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryDateFlagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDateFlagExecute ]
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

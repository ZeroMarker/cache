Import SQLUser

/// 质控字典存取方法
Class web.DHCWMRQualityDic Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 96;

/// 存 1 质控标准字典 DHC_WMR_RuleDic
ClassMethod UpdateRuleDic(Instring)
{
    n (Instring)
    s ret=""
    
    s DicRowid=$p(Instring,"^",4)         ;RuleTypeDr
    q:'$d(^DHCWMRDIC(+DicRowid)) -1
    
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateRuleDic^DHCWMRQualityDic(Instring)
	zn CurrentNS
	q ret
}

/// 存 2 质控大类字典 DHC_WMR_SectionDic
ClassMethod UpdateSectionDic(Instring)
{
    n (Instring)
    s ret=""
    
    s DicRowid=$p(Instring,"^",4)         ;SectionTypeDr
    q:'$d(^DHCWMRDIC(+DicRowid)) -1
    
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateSectionDic^DHCWMRQualityDic(Instring)
	zn CurrentNS
	q ret
}

/// 存 3 质控项目字典 DHC_WMR_EntryDic
ClassMethod UpdateEntryDic(Instring)
{
    n (Instring)
    s ret=""
    
    s DicRowid=$p(Instring,"^",4)         ;EntryTypeDr
    q:'$d(^DHCWMRDIC(+DicRowid)) -1
    
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateEntryDic^DHCWMRQualityDic(Instring)
	zn CurrentNS
	q ret
}

/// 取 1 质控标准字典 DHC_WMR_RuleDic
ClassMethod GetRuleDicById(RuleDicRowid)
{
    n (RuleDicRowid)
    
    s retString=##class(web.DHCWMRQualityBaseCtl).GetDicRById(RuleDicRowid)
    
    ;DHC_WMR_Dictionary
    s Dic=""
    s DicDr=+$p(retString,"^",4)
    s:DicDr'=0 Dic=##class(web.DHCWMRQualityBaseCtl).GetDicById(DicDr)
    ;w retString,!,Dic,!
    s retString=retString_$c(2)_Dic
    q retString
    
    /*
    s ret=""
    q:'$d(^DHCWMRRDIC(+RuleDicRowid)) ret
    
    s ret=$g(^DHCWMRRDIC(+RuleDicRowid))
    s ret=+RuleDicRowid_"^"_ret
    s:$p(ret,"^",5)'="" $p(ret,"^",5)=$s($p(ret,"^",5)["Y":"Yes",1:"No")
    
    ;Dictionary
    s DicRowid=+$p(ret,"^",4)
    s:DicRowid'=0 DicInfo=DicRowid_"^"_$g(^DHCWMRDIC(DicRowid))
    s ret=ret_$c(2)_$g(DicInfo)
    
    q ret
    */
}

/// 取 2 质控大类字典 DHC_WMR_SectionDic
ClassMethod GetSectionDicById(SectionDicRowid)
{
    n (SectionDicRowid)
    
    s retString=##class(web.DHCWMRQualityBaseCtl).GetDicSById(SectionDicRowid)
    
    ;DHC_WMR_Dictionary
    s Dic=""
    s DicDr=+$p(retString,"^",4)
    s:DicDr'=0 Dic=##class(web.DHCWMRQualityBaseCtl).GetDicById(DicDr)
    ;w retString,!,Dic,!
    s retString=retString_$c(2)_Dic
    q retString
    /*
    s ret=""
    q:'$d(^DHCWMRSDIC(+SectionDicRowid)) ret
    
    s ret=$g(^DHCWMRSDIC(+SectionDicRowid))
    s ret=+SectionDicRowid_"^"_ret
    s:$p(ret,"^",5)'="" $p(ret,"^",5)=$s($p(ret,"^",5)["Y":"Yes",1:"No")
    
    ;Dictionary
    s DicRowid=+$p(ret,"^",4)
    s:DicRowid'=0 DicInfo=DicRowid_"^"_$g(^DHCWMRDIC(DicRowid))
    s ret=ret_$c(2)_$g(DicInfo)
    q ret
    */
}

/// 取 3 质控项目字典 DHC_WMR_EntryDic
ClassMethod GetEntryDicById(EntryDicRowid)
{
    n (EntryDicRowid)
    
    s retString=##class(web.DHCWMRQualityBaseCtl).GetDicEById(EntryDicRowid)
    
    ;DHC_WMR_Dictionary
    s Dic=""
    s DicDr=+$p(retString,"^",4)
    s:DicDr'=0 Dic=##class(web.DHCWMRQualityBaseCtl).GetDicById(DicDr)
    ;w retString,!,Dic,!
    s retString=retString_$c(2)_Dic
    q retString
    /*
    s ret=""
    q:'$d(^DHCWMREDIC(+EntryDicRowid)) ret
    
    s ret=$g(^DHCWMREDIC(+EntryDicRowid))
    s ret=+EntryDicRowid_"^"_ret
    s:$p(ret,"^",5)'="" $p(ret,"^",5)=$s($p(ret,"^",5)["Y":"Yes",1:"No")
    
    ;Dictionary
    s DicRowid=+$p(ret,"^",4)
    s:DicRowid'=0 DicInfo=DicRowid_"^"_$g(^DHCWMRDIC(DicRowid))
    s ret=ret_$c(2)_$g(DicInfo)
    q ret
    */
}

/*
Query QueryRuleDic() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Code,Title,IsActive,ResumeText,RuleTypeDr,RuleTypeDr->Description as Type FROM DHC_WMR_RuleDic where %ID>0
}

/// add by wuqk 按照质控标准类型查询 2008-04-02
Query LookUpRuleDic(TypeCode) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Title FROM DHC_WMR_RuleDic where %ID>0 AND IsActive='Y' AND RuleTypeDr->Code=:TypeCode
}

Query QuerySectionDic() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Code,Title,IsActive,ResumeText,SectionTypeDr,SectionTypeDr->Description as Type FROM DHC_WMR_SectionDic where %ID>0
}

Query QueryEntryDic() As %SQLQuery(CONTAINID = 1)
{
  SELECT %ID,Code,Title,IsActive,ResumeText,EntryTypeDr,EntryTypeDr->Description as Type FROM DHC_WMR_EntryDic where %ID>0
}
*/
/// ***************************************************
ClassMethod QueryRuleDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRuleDicExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryRuleDicExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind = 1
    Set qHandle=$lb(0,repid,0)
    
    ;^DHCWMRRDIC({Rowid})
    s Rowid=0
    f  s Rowid=$o(^DHCWMRRDIC(Rowid)) q:Rowid=""  d
    .s tmpRule=$g(^DHCWMRRDIC(Rowid))
    .;Rowid,Code,Title,IsActive,ResumeText,RuleTypeDr,Type
    .s Code=$p(tmpRule,"^",1)
    .s Title=$p(tmpRule,"^",2)
    .s RuleTypeDr=$p(tmpRule,"^",3)
    .s IsActive=$p(tmpRule,"^",4)
    .s ResumeText=$p(tmpRule,"^",5)
    .s Type=$p($g(^DHCWMRDIC(RuleTypeDr)),"^",3)
    .s s=Rowid_"^"_Code_"^"_Title_"^"_IsActive_"^"_ResumeText_"^"_RuleTypeDr_"^"_Type
    .d ..BuildData(repid,ind,s)
    .s ind=ind+1

    Quit $$$OK
}

ClassMethod QueryRuleDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRuleDicExecute ]
{
        
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
	    // if there are no more rows, finish fetching
        Set AtEnd = 1
        Set Row = ""
    }
    Else{
	    // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

Query QueryRuleDic() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Title:%String,IsActive:%String,ResumeText:%String,RuleTypeDr:%String,Type:%String")
{
}

ClassMethod LookUpRuleDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpRuleDicExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod LookUpRuleDicExecute(ByRef qHandle As %Binary, TypeCode As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind = 1
    Set qHandle=$lb(0,repid,0)
    
    ;^DHCWMRRDIC({Rowid})
    s Rowid=0
    f  s Rowid=$o(^DHCWMRRDIC(Rowid)) q:Rowid=""  d
    .s tmpRule=$g(^DHCWMRRDIC(Rowid))
    .;Rowid,Title
    .s Title=$p(tmpRule,"^",2)
    .s tmpTypeCodeDr=$p(tmpRule,"^",3)
    .s tmpIsActive=$p(tmpRule,"^",4)
    .s tmpTypeCode=$p($g(^DHCWMRDIC(+tmpTypeCodeDr)),"^",2)
    .q:((TypeCode'="")&&(TypeCode'=tmpTypeCode))
    .q:tmpIsActive'="Y"
    .s s=Rowid_"^"_Title
    .d ..BuildData(repid,ind,s)
    .s ind=ind+1

    Quit $$$OK
}

ClassMethod LookUpRuleDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpRuleDicExecute ]
{
        
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
	    // if there are no more rows, finish fetching
        Set AtEnd = 1
        Set Row = ""
    }
    Else{
	    // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

Query LookUpRuleDic(TypeCode As %String) As %Query(ROWSPEC = "Rowid:%String,Title:%String")
{
}

ClassMethod QuerySectionDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySectionDicExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QuerySectionDicExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind = 1
    Set qHandle=$lb(0,repid,0)
    
    ;^DHCWMRSDIC({Rowid})
    s Rowid=0
    f  s Rowid=$o(^DHCWMRSDIC(Rowid)) q:Rowid=""  d
    .s tmpSection=$g(^DHCWMRSDIC(Rowid))
    .;Rowid,Code,Title,IsActive,ResumeText,SectionTypeDr,Type
    .s Code=$p(tmpSection,"^",1)
    .s Title=$p(tmpSection,"^",2)
    .s SectionTypeDr=$p(tmpSection,"^",3)
    .s IsActive=$p(tmpSection,"^",4)
    .s ResumeText=$p(tmpSection,"^",5)
    .s Type=$p($g(^DHCWMRDIC(SectionTypeDr)),"^",3)
    .s s=Rowid_"^"_Code_"^"_Title_"^"_IsActive_"^"_ResumeText_"^"_SectionTypeDr_"^"_Type
    .d ..BuildData(repid,ind,s)
    .s ind=ind+1

    Quit $$$OK
}

ClassMethod QuerySectionDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySectionDicExecute ]
{
        
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
	    // if there are no more rows, finish fetching
        Set AtEnd = 1
        Set Row = ""
    }
    Else{
	    // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

Query QuerySectionDic() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Title:%String,IsActive:%String,ResumeText:%String,SectionTypeDr:%String,Type:%String")
{
}

ClassMethod QueryEntryDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEntryDicExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryEntryDicExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind = 1
    Set qHandle=$lb(0,repid,0)
    
    ;^DHCWMREDIC({Rowid})
    s Rowid=0
    f  s Rowid=$o(^DHCWMREDIC(Rowid)) q:Rowid=""  d
    .s tmpEntry=$g(^DHCWMREDIC(Rowid))
    .;Rowid,Code,Title,IsActive,ResumeText,EntryTypeDr,Type
    .s Code=$p(tmpEntry,"^",1)
    .s Title=$p(tmpEntry,"^",2)
    .s EntryTypeDr=$p(tmpEntry,"^",3)
    .s IsActive=$p(tmpEntry,"^",4)
    .s ResumeText=$p(tmpEntry,"^",5)
    .s Type=$p($g(^DHCWMRDIC(EntryTypeDr)),"^",3)
    .s s=Rowid_"^"_Code_"^"_Title_"^"_IsActive_"^"_ResumeText_"^"_EntryTypeDr_"^"_Type
    .d ..BuildData(repid,ind,s)
    .s ind=ind+1

    Quit $$$OK
}

ClassMethod QueryEntryDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEntryDicExecute ]
{
        
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
	    // if there are no more rows, finish fetching
        Set AtEnd = 1
        Set Row = ""
    }
    Else{
	    // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

Query QueryEntryDic() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Title:%String,IsActive:%String,ResumeText:%String,EntryTypeDr:%String,Type:%String")
{
}

/// ***********************************************
Query QueryByTypeFlag(Type As %String, Flag As %String) As %Query(ROWSPEC = "Rowid:%String,DictionaryName:%String,Code:%String,Description:%String,FromDate:%String,ToDate:%String,TextA:%String,TextB:%String,TextC:%String,TextD:%String,IsActive:%String,ResumeText:%String")
{
}

/// BuildData Function
ClassMethod BuildData(repid As %String, ind As %String, s As %String)
{
    set Data=$lb("")
    f iBuild=1:1:$l(s,"^") d
    .s $li(Data,iBuild)=$p(s,"^",iBuild)
    Set ^CacheTemp(repid,ind)=Data
    q
}

ClassMethod QueryDicRuleByTitleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDicRuleByTitleExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryDicRuleByTitleExecute(ByRef qHandle As %Binary, Title As %String, RuleType As %String, IsActive As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind = 1
    Set qHandle=$lb(0,repid,0)
    
    ;^DHCWMRRDIC(0,"Title",{Title},{Rowid})
    s:IsActive'="" IsActive=$s(IsActive["Y":"Y",1:"N")
    s Rowid = ""
    s Rowid=$$GetRuleByTitle(Title,RuleType,IsActive)
    i Rowid '="" d
    .s RuleTitle=$p(^DHCWMRRDIC(Rowid),"^",2)
    .s s=Rowid_"^"_RuleTitle
    .d ..BuildData(repid,ind,s)
    .s ind = ind + 1
        
    s tmpTitle = Title
    f  s tmpTitle=$o(^DHCWMRRDIC(0,"Title",tmpTitle)) q:(tmpTitle="")||(tmpTitle'[Title)  d
    .s Rowid=$$GetRuleByTitle(tmpTitle,RuleType,IsActive)
    .i Rowid '="" d
    ..s RuleTitle=$p(^DHCWMRRDIC(Rowid),"^",2)
    ..s s=Rowid_"^"_RuleTitle
    ..d ..BuildData(repid,ind,s)
    ..s ind=ind+1

    Quit $$$OK
GetRuleByTitle(Title,RuleType,IsActive)
    n (Title,RuleType,IsActive)
    s ret = "", Rowid = ""
    q:Title="" ret
    q:'$d(^DHCWMRRDIC(0,"Title",Title)) ret
    s Rowid=$o(^DHCWMRRDIC(0,"Title",Title,Rowid))
    q:Rowid="" ret
    q:'$d(^DHCWMRRDIC(Rowid)) ret
    s RuleTitle=$p($g(^DHCWMRRDIC(Rowid)),"^",2)
    s RuleTypeDr=$p($g(^DHCWMRRDIC(Rowid)),"^",3)
    q:((RuleType'="")&&(RuleType'=RuleTypeDr)) ret
    s RuleActive=$p($g(^DHCWMRRDIC(Rowid)),"^",4)
    q:((IsActive'="")&(IsActive'=RuleActive)) ret
    s ret = Rowid
    q ret
}

ClassMethod QueryDicRuleByTitleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDicRuleByTitleExecute ]
{
       
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
	    // if there are no more rows, finish fetching
        Set AtEnd = 1
        Set Row = ""
    }
    Else{
	    // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 质控标准字典查询
Query QueryDicRuleByTitle(Title As %String, RuleType As %String, IsActive As %String) As %Query(ROWSPEC = "RuleRowid:%String,RuleTitle:%String")
{
}

ClassMethod QueryDicSecByTitleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDicSecByTitleExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryDicSecByTitleExecute(ByRef qHandle As %Binary, Title As %String, SectionType As %String, IsActive As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind = 1
    Set qHandle=$lb(0,repid,0)
    
    ;^DHCWMRSDIC(0,"Title",{Title},{Rowid})
    s:IsActive'="" IsActive=$s(IsActive["Y":"Y",1:"N")
    s Rowid=0
    f  s Rowid=$o(^DHCWMRSDIC(Rowid)) q:Rowid=""  d
    .s SecCode=$p($g(^DHCWMRSDIC(Rowid)),"^",1)
    .s SecTitle=$p($g(^DHCWMRSDIC(Rowid)),"^",2)
    .s SecActive=$p($g(^DHCWMRSDIC(Rowid)),"^",4)
    .s SecTypeDr=$p($g(^DHCWMRSDIC(Rowid)),"^",3)
    .q:((SectionType'="")&&(SectionType'=SecTypeDr))
    .q:(Title'="")&&(SecCode'[Title)&&(SecTitle'[Title)
    .q:(IsActive'="")&&(IsActive'=SecActive)
    .s s=Rowid_"^"_SecTitle_"^"_SecCode
    .d ..BuildData(repid,ind,s)
    .s ind=ind+1
    
    Quit $$$OK
    
    /*
    ;^DHCWMRSDIC(0,"Title",{Title},{Rowid})
    s:IsActive'="" IsActive=$s(IsActive["Y":"Y",1:"N")
    s Rowid = ""
    s Rowid=$$GetSectionByTitle(Title,SectionType,IsActive)
    i Rowid '="" d
    .s SecTitle=$p(^DHCWMRSDIC(Rowid),"^",2)
    .s SecCode=$p(^DHCWMRSDIC(Rowid),"^",1)
    .s s=Rowid_"^"_SecTitle_"^"_SecCode
    .d ..BuildData(repid,ind,s)
    .s ind = ind + 1
        
    s tmpTitle = Title
    f  s tmpTitle=$o(^DHCWMRSDIC(0,"Title",tmpTitle)) q:(tmpTitle="")||(tmpTitle'[Title)  d
    .s Rowid=$$GetSectionByTitle(tmpTitle,SectionType,IsActive)
    .i Rowid '="" d
    .s SecTitle=$p(^DHCWMRSDIC(Rowid),"^",2)
    .s SecCode=$p(^DHCWMRSDIC(Rowid),"^",1)
    .s s=Rowid_"^"_SecTitle_"^"_SecCode
    ..d ..BuildData(repid,ind,s)
    ..s ind=ind+1

    Quit $$$OK
GetSectionByTitle(Title,SectionType,IsActive)
    n (Title,SectionType,IsActive)
    s ret = "", Rowid = ""
    q:Title="" ret
    q:'$d(^DHCWMRSDIC(0,"Title",Title)) ret
    s Rowid=$o(^DHCWMRSDIC(0,"Title",Title,Rowid))
    q:Rowid="" ret
    q:'$d(^DHCWMRSDIC(Rowid)) ret
    s SecTitle=$p($g(^DHCWMRSDIC(Rowid)),"^",2)
    s SecTypeDr=$p($g(^DHCWMRSDIC(Rowid)),"^",3)
    q:((SectionType'="")&(SectionType'=SecTypeDr)) ret
    s SecActive=$p($g(^DHCWMRSDIC(Rowid)),"^",4)
    q:((IsActive'="")&(IsActive'=SecActive)) ret
    s ret = Rowid
    q ret
    */
}

ClassMethod QueryDicSecByTitleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDicSecByTitleExecute ]
{
        
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
	    // if there are no more rows, finish fetching
        Set AtEnd = 1
        Set Row = ""
    }
    Else{
	    // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 质控大类字典查询
Query QueryDicSecByTitle(Title As %String, SectionType As %String, IsActive As %String) As %Query(ROWSPEC = "SecRowid:%String,SecTitle:%String,SecCode:%String")
{
}

ClassMethod QueryDicEntryByTitleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDicEntryByTitleExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryDicEntryByTitleExecute(ByRef qHandle As %Binary, Title As %String, EntryType As %String, IsActive As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind = 1
    Set qHandle=$lb(0,repid,0)
    
    ;^DHCWMREDIC(0,"Title",{Title},{Rowid})
    s:IsActive'="" IsActive=$s(IsActive["Y":"Y",1:"N")
    s Rowid=""
    f  s Rowid=$o(^DHCWMREDIC(Rowid)) q:Rowid=""  d
    .s EntryCode=$p($g(^DHCWMREDIC(Rowid)),"^",1)
    .s EntryTitle=$p($g(^DHCWMREDIC(Rowid)),"^",2)
    .s EntryActive=$p($g(^DHCWMREDIC(Rowid)),"^",4)
    .q:(Title'="")&&(EntryCode'[Title)&&(EntryTitle'[Title)
    .q:(IsActive'="")&&(IsActive'=EntryActive)
    .s s=Rowid_"^"_EntryTitle_"^"_EntryCode
    .d ..BuildData(repid,ind,s)
    .s ind=ind+1
    
    /*
    s Rowid = ""
    s Rowid=$$GetEntryByTitle(Title,EntryType,IsActive)
    i Rowid '="" d
    .s EntryTitle=$p(^DHCWMREDIC(Rowid),"^",2)
    .s s=Rowid_"^"_EntryTitle
    .d ..BuildData(repid,ind,s)
    .s ind = ind + 1
        
    s tmpTitle = Title
    f  s tmpTitle=$o(^DHCWMREDIC(0,"Title",tmpTitle)) q:(tmpTitle="")||(tmpTitle'[Title)  d
    .s Rowid=$$GetEntryByTitle(tmpTitle,EntryType,IsActive)
    .i Rowid '="" d
    ..s EntryTitle=$p(^DHCWMREDIC(Rowid),"^",2)
    ..s s=Rowid_"^"_EntryTitle
    ..d ..BuildData(repid,ind,s)
    ..s ind=ind+1
    */
    
    Quit $$$OK
GetEntryByTitle(Title,EntryType,IsActive)
    n (Title,EntryType,IsActive)
    s ret = "", Rowid = ""
    q:Title="" ret
    q:'$d(^DHCWMREDIC(0,"Title",Title)) ret
    s Rowid=$o(^DHCWMREDIC(0,"Title",Title,Rowid))
    q:Rowid="" ret
    q:'$d(^DHCWMREDIC(Rowid)) ret
    s EntryTitle=$p($g(^DHCWMREDIC(Rowid)),"^",2)
    s EntryTypeDr=$p($g(^DHCWMREDIC(Rowid)),"^",3)
    q:((EntryType'="")&(EntryType'=EntryTypeDr)) ret
    s EntryActive=$p($g(^DHCWMREDIC(Rowid)),"^",4)
    q:((IsActive'="")&(IsActive'=EntryActive)) ret
    s ret = Rowid
    q ret
}

ClassMethod QueryDicEntryByTitleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDicEntryByTitleExecute ]
{
       
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
	    // if there are no more rows, finish fetching
        Set AtEnd = 1
        Set Row = ""
    }
    Else{
	    // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 质控项目字典查询
Query QueryDicEntryByTitle(Title As %String, EntryType As %String, IsActive As %String) As %Query(ROWSPEC = "EntryRowid:%String,EntryTitle:%String,EntryCode:%String")
{
}

/// 取质控标准的类型代码
ClassMethod GetRuleType(RuleRowId As %String)
{
	n (RuleRowId)
	s code=""
	q:'$d(^DHCWMRRDIC(RuleRowId)) code
	s typeDr=$p($g(^DHCWMRRDIC(RuleRowId)),"^",3)
	s sDic=##class(web.DHCWMRDictionaryCtl).GetDataById(typeDr)
	s code=$p(sDic,"^",3)
	q code
}

}

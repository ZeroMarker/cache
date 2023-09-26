/// CTOR: QP
/// DATE: 2017-03-13
/// VERN: V4.1.3
/// DESC: 抗菌药物联合用药业务类
Class DHCAnt.KSS.Combined Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Description:得到联用原因
/// Table：DHCAntCombinedUseReason
/// input:  
/// output: id,text
Query QryCombinedUseReason() As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryCombinedUseReasonExecute(ByRef qHandle As %Binary) As %Status
{
    //d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Combined","QryCombinedUseReason")
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    s langid=..%LanguageID()
    s CurId=""
    f  s CurId=$o(^DHCAntBasePurposeDataConfigI("PDCType","CMB",CurId)) q:CurId=""  d
    .s CURActiveFlag=$p(^DHCAntBasePurposeDataConfigD(CurId),"^",5)
    .q:CURActiveFlag'=1
    .s CURCode=$p(^DHCAntBasePurposeDataConfigD(CurId),"^",4)
    .s CURDesc=$p(^DHCAntBasePurposeDataConfigD(CurId),"^",3)
    .s CURDesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",CURDesc,langid)
    .d OutputRow1
    
    Quit $$$OK
OutputRow1
    set Data=$lb(CurId,CURDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod QryCombinedUseReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCombinedUseReasonExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod QryCombinedUseReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCombinedUseReasonExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Description:得到更换原因
/// Table：DHCAntChangeReason
/// input:  
/// output: 
Query QryChangeReason(Code As %String, Desc As %String) As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryChangeReasonExecute(ByRef qHandle As %Binary, Code As %String, Desc As %String) As %Status
{
    //d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Combined","QryChangeReason")
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    s langid=..%LanguageID()
    s ChrId=""
    f  s ChrId=$o(^DHCAntBasePurposeDataConfigI("PDCType","CMBCHG",ChrId)) q:ChrId=""  d
    .s CHRActiveFlag=$p(^DHCAntBasePurposeDataConfigD(ChrId),"^",5)
    .q:CHRActiveFlag'=1
    .s CHRCode=$p(^DHCAntBasePurposeDataConfigD(ChrId),"^",4)
    .s CHRDesc=$p(^DHCAntBasePurposeDataConfigD(ChrId),"^",3)
    .s CHRDesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",CHRDesc,langid)
    .d OutputRow2
    ;Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow2
    set Data=$lb(ChrId,CHRDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod QryChangeReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryChangeReasonExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod QryChangeReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryChangeReasonExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Description:审核医嘱时判断是否需要填写更改原因 
/// input: AdmDr - 就诊ID pa_adm 表ID ;    DAUPList - 审核时使用目的表ID @ 嘱类型ID的串; 表： DHC_AntUsePurpose和OEC_Priority
/// output: 0 - 不需要 ;   1 - 需要
/// w ##Class(DHCAnt.KSS.Combined).IfChangeFormDAUP(264,"3609@5")
ClassMethod IfChangeFormDAUP(AdmDr As %String, DAUPList As %String, InHosp = "")
{
	n (AdmDr,DAUPList,InHosp,%session)
	i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
    s Ret=0
    q:(AdmDr="")||(DAUPList="") Ret
    ;s DAUPList=..FilterOMSTOrder(DAUPList)
    s DAACID=$o(^User.DHCAntAdmCombinedInfoI("ADM",AdmDr,""))
    ;q:DAACID="" Ret
    s SCKJ=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SCKJ",InHosp)
    q:(SCKJ="")||(SCKJ="0") Ret
    s CDATE=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("CDATE")
    q:(CDATE="")||(CDATE="0") Ret
    s DAACIDate=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("CDATE")
    i DAACID'="" d
    .s DAACSub=$o(^User.DHCAntAdmCombinedInfoD(DAACID,"ChildDAACS",""),-1)
    .s a=##class(User.DHCAntAdmCombinedSub).%OpenId(DAACID_"||"_DAACSub)
    .s ChaDAUPId=a.ChaDAUPId 
    .s OldKSSInfo=a.KSSInfo
    .s daupIdArr=a.DAUPId
    e  d
    .s ChaDAUPId="" 
    .s OldKSSInfo=""
    .s daupIdArr=""
    
    i ChaDAUPId'="" d
    .s StrDate=a.StrDate
    .s StrTime=a.StrTime
    .;s DAACIDate=^DAACI("Date")
    .;q:StrDate<(+$H-DAACIDate)
    .q:(StrDate*86400+StrTime)<((+$H)*86400+$p($H,",",2)-(DAACIDate*3600))
    .s Ret=1
    q:Ret=1 Ret	//QP
    s KSSInfo=""
    s AllNum=$l(daupIdArr,"^")
    for j=1:1:AllNum d
    .s daupid=$p(daupIdArr,"^",j)                //预停医嘱在听医嘱时不处理，在显示时处理现实内容
    .q:daupid=""
    .s oeori=$p($g(^DAUP("DAUP",daupid)),"^",3)
    .S check=..CheckOrderP(oeori,InHosp)
    .q:check=2
    .i KSSInfo="" s KSSInfo=$p(OldKSSInfo,"^",j)
    .e  s KSSInfo=KSSInfo_"^"_$p(OldKSSInfo,"^",j)
    
    s l=$l(DAUPList,"^")
    for i=1:1:l d
    .s DAUPStr=$p(DAUPList,"^",i)
    .s DAUPID=$p(DAUPStr,"@",1)
    .s oeori=$p($g(^DAUP("DAUP",DAUPID)),"^",3)
    .S check=..CheckOrderP(oeori,InHosp)
    .q:check=2 
    .s ArcItm=$P(^DAUP("DAUP",DAUPID),"^",21)
    .i ("^"_KSSInfo_"^")[("^"_ArcItm_"^") d
    ..s Ret=1
    .e  d
    ..s KSSInfo=KSSInfo_"^"_ArcItm
    q Ret
}

/// Description:审核医嘱时获取联用数判断是否需要填写联用原因
/// input: AdmDr - 就诊ID pa_adm 表ID ;    DAUPList - 审核时使用目的表ID @ 嘱类型ID的串;  表： DHC_AntUsePurpose和OEC_Priority
/// output: 0 - 不需要 ;   其他 - 联用数 ;  -1 - 存在相同长期医嘱项
/// w ##Class(DHCAnt.KSS.Combined).GetCombinedNumFormDAUP(683,"4795@5^4796@3")
ClassMethod GetCombinedNumFormDAUP(AdmDr As %String, DAUPList As %String, InHosp = "")
{
	n (AdmDr,DAUPList,InHosp,%session)
    s Ret=0
    i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
    q:(AdmDr="")||(DAUPList="") Ret_"|"_""
    
    s SCKJ=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SCKJ",InHosp)
    q:(SCKJ="")||(SCKJ="0") Ret_"|"_""
    ;s DAUPList=..FilterOMSTOrder(DAUPList)
    s l=$l(DAUPList,"^")
    s DAACID=$o(^User.DHCAntAdmCombinedInfoI("ADM",AdmDr,""))
    q:(DAACID="")&(l=1) Ret_"|"_""
    if (DAACID'="") {
    s DAACSub=$o(^User.DHCAntAdmCombinedInfoD(DAACID,"ChildDAACS",""),-1)
    s a=##class(User.DHCAntAdmCombinedSub).%OpenId(DAACID_"||"_DAACSub)
    ;;s CurNum=a.CNum 
    ;;s Ret=CurNum
    s OldKSSInfo=a.KSSInfo
    s OldPriorityInfo=a.PriorityInfo
    s CheckNum=0
    s l=$l(DAUPList,"^")
    s daupIdArr=a.DAUPId
    s sameArcimName="",ArcimNameArr=""
    s CurNum=0,KSSInfo="",PriorityInfo=""
    s AllNum=$l(daupIdArr,"^")
    for j=1:1:AllNum d
    .s daupid=$p(daupIdArr,"^",j)                //预停医嘱在听医嘱时不处理，在显示时处理现实内容
    .q:daupid=""
    .s oeori=$p($g(^DAUP("DAUP",daupid)),"^",3)
    .S check=..CheckOrderP(oeori)
    .q:check=2
    .i KSSInfo="" s KSSInfo=$p(OldKSSInfo,"^",j)
    .e  s KSSInfo=KSSInfo_"^"_$p(OldKSSInfo,"^",j)
    .i PriorityInfo="" s PriorityInfo=$p(OldPriorityInfo,"^",j)
    .e  s PriorityInfo=PriorityInfo_"^"_$p(OldPriorityInfo,"^",j)
    .s CurNum=CurNum+1
    }
    else{
	    s CheckNum=0
	   s sameArcimName="",ArcimNameArr=""
    s CurNum=0,KSSInfo="",PriorityInfo="" 
    }
	
    for i=1:1:l d
    .s DAUPStr=$p(DAUPList,"^",i)
    .s DAUPID=$p(DAUPStr,"@",1)
    .s Priority=$p(DAUPStr,"@",2)
    .s ArcItm=$P(^DAUP("DAUP",DAUPID),"^",21)
    .i ("^"_KSSInfo_"^")[("^"_ArcItm_"^")  d
    ..;s DAACIPriority=^DAACI("Priority") 
    ..s DAACIPriority=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("OETYPE")
    ..i (","_DAACIPriority_",")[(","_Priority_",") d
    ...s PriorityNo=..GetListNum(KSSInfo,"^",ArcItm)
    ...s CheckPriority=$p(PriorityInfo,"^",PriorityNo)
    ...i (","_DAACIPriority_",")[(","_CheckPriority_",") d 
    ....s CheckNum="-1" 
    ....s sameArcimName=$p(^ARCIM(+ArcItm,1,1),"^",2)
    ....i ArcimNameArr=""  s ArcimNameArr=sameArcimName
    ....i (ArcimNameArr'="")&&(ArcimNameArr'[sameArcimName)  s ArcimNameArr=ArcimNameArr_","_sameArcimName
    .e  d
    ..s Ret=Ret+1
    ..i KSSInfo="" s KSSInfo=ArcItm
    ..e  s KSSInfo=KSSInfo_"^"_ArcItm
    ..i PriorityInfo="" s PriorityInfo=Priority
    ..e  s PriorityInfo=PriorityInfo_"^"_Priority
    q:CheckNum="-1" CheckNum_"|"_ArcimNameArr
    i Ret'=0 s Ret=Ret+CurNum
    q Ret_"|"_""
}

/// Description:判断新开医嘱项ArcItm在当前联用医嘱项的位数
/// input: StrList - 当前联用医嘱项的串;   delimiter - "^";   CheckStr - 新开医嘱项ArcItm
/// output：ListNum - 位数  
ClassMethod GetListNum(StrList, delimiter, CheckStr)
{
    s ListNum=0
    s ListLen=$l(StrList,delimiter)
    for ListNo=1:1:ListLen d
    .s ListNoStr=$p(StrList,delimiter,ListNo)
    .i ListNoStr=CheckStr s ListNum=ListNo
    q ListNum
}

/// ^DAACI("Date")=2
/// Description:开医嘱时判断是否需要填写更改原因  
/// input: AdmDr - 就诊ID 表 pa_adm ;    ArcItm - 新开医嘱项  表 ARC_ItmMast
/// output: 0 - 不需要;    1 - 需要 
/// w ##Class(DHCAnt.KSS.Combined).IfAntChange(6054875,"14961||1")
ClassMethod IfAntChange(AdmDr As %String, ArcItm As %String, InHosp = "")
{
	n (AdmDr,ArcItm,InHosp,%session)
    s Ret=0
    i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
    q:(AdmDr="")||(ArcItm="") Ret
    s SCKJ=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SCKJ",InHosp)
    q:(SCKJ="")||(SCKJ="0") Ret
    s CDATE=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("CDATE")
    q:(CDATE="")||(CDATE="0") Ret
    
    s DAACID=$o(^User.DHCAntAdmCombinedInfoI("ADM",AdmDr,""))
    q:DAACID="" Ret
    s DAACIDate=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("CDATE")
    s DAACSub=$o(^User.DHCAntAdmCombinedInfoD(DAACID,"ChildDAACS",""),-1)
    s a=##class(User.DHCAntAdmCombinedSub).%OpenId(DAACID_"||"_DAACSub)
    s ChaDAUPId=a.ChaDAUPId 
    i ChaDAUPId'="" d
    .s StrDate=a.StrDate
    .s StrTime=a.StrTime
    .;s DAACIDate=^DAACI("Date")
    .;q:StrDate<(+$H-2)
    .q:(StrDate*86400+StrTime)<((+$H)*86400+$p($H,",",2)-(DAACIDate*3600))
    .s Ret=1
    s KSSInfo=a.KSSInfo
    i ("^"_KSSInfo_"^")[("^"_ArcItm_"^") s Ret=1
    q Ret
}

/// Description:开医嘱时获取联用数判断是否需要填写联用原因
/// input: AdmDr - 就诊ID 表 pa_adm ;    ArcItm - 新开医嘱项  表 ARC_ItmMast
/// output: 0 - 不需要;    其他 - 联用数 
/// w ##Class(DHCAnt.KSS.Combined).GetAntCombinedNum(6054875,"9657||1")
ClassMethod GetAntCombinedNum(AdmDr As %String, ArcItm As %String, InHosp = "")
{
	n (AdmDr,ArcItm,InHosp,%session)
    s Ret=0
    i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
    q:(AdmDr="")||(ArcItm="") Ret
    s SCKJ=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SCKJ",InHosp)
    q:(SCKJ="")||(SCKJ="0") Ret
    
    s DAACID=$o(^User.DHCAntAdmCombinedInfoI("ADM",AdmDr,""))
    q:DAACID="" Ret
    s DAACSub=$o(^User.DHCAntAdmCombinedInfoD(DAACID,"ChildDAACS",""),-1)
    s a=##class(User.DHCAntAdmCombinedSub).%OpenId(DAACID_"||"_DAACSub)
    s CurNum=a.CNum 
    s Ret=CurNum+1
    s KSSInfo=a.KSSInfo
    i ("^"_KSSInfo_"^")[("^"_ArcItm_"^") s Ret=0
    q Ret
}

/// Description: 得到正在使用的抗生素和当前正在开的抗生素的一个展示
/// input: AdmDr - 就诊ID pa_adm 表ID ;    DAUPList - 审核时使用目的表ID @ 嘱类型ID的串;  表： DHC_AntUsePurpose和OEC_Priority
/// output:
/// d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Combined","CombinedInfo",264,"3637@3")
Query CombinedInfo(AdmDr As %String, DAUPList As %String) As %Query(ROWSPEC = "Num:%String,Status:%String,ArcItm:%String,Priority:%String")
{
}

ClassMethod CombinedInfoExecute(ByRef qHandle As %Binary, AdmDr As %String, DAUPList As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ^templsj("2016022902wwwwwww")=AdmDr_"!"_DAUPList
    k ^DHCAACI("CombinedInfo",AdmDr,$I)
    s langid=..%LanguageID()
    s ind=1
    s KSSNum=0,KSSInfo=""
    s DAACID=$o(^User.DHCAntAdmCombinedInfoI("ADM",AdmDr,""))
    i DAACID'="" d
    .s DAACSub=$o(^User.DHCAntAdmCombinedInfoD(DAACID,"ChildDAACS",""),-1)
    .s a=##class(User.DHCAntAdmCombinedSub).%OpenId(DAACID_"||"_DAACSub)
    .s KSSInfo=a.KSSInfo
    .s PriorityInfo=a.PriorityInfo
    .//update by shp
    .s daupIdArr=a.DAUPId
    .s KSSNum=$l(KSSInfo,"^")
    .s NewNum=0,NewKSSInfo="",NewPriorityInfo=""
    .f i=1:1:KSSNum d
    ..s daupid=$p(daupIdArr,"^",i)                //预停医嘱在听医嘱时不处理，在显示时处理现实内容
    ..q:daupid=""
    ..s oeori=$p($g(^DAUP("DAUP",daupid)),"^",3)
    ..S check=..CheckOrderP(oeori)
    ..q:check=2  
    ..i NewKSSInfo="" s NewKSSInfo=$p(KSSInfo,"^",i)
    ..e  s NewKSSInfo=NewKSSInfo_"^"_$p(KSSInfo,"^",i)
    ..i NewPriorityInfo="" s NewPriorityInfo=$p(PriorityInfo,"^",i)
    ..e  s NewPriorityInfo=NewPriorityInfo_"^"_$p(PriorityInfo,"^",i)
    ..s NewNum=NewNum+1
    ..s ^DHCAACI("CombinedInfo",AdmDr,$I,NewNum)="正在使用^"_$p(KSSInfo,"^",i)_"^"_$p(PriorityInfo,"^",i)
    .s KSSNum=NewNum
    .s KSSInfo=NewKSSInfo
    .s PriorityInfo=NewPriorityInfo
    b
    s len=$l(DAUPList,"^")
    f j=1:1:len d
    .s DAUPStr=$p(DAUPList,"^",j)
    .s DAUPID=$p(DAUPStr,"@",1)
    .s Priority=$p(DAUPStr,"@",2)
    .s ArcItm=$P(^DAUP("DAUP",DAUPID),"^",21)
    .i ("^"_KSSInfo_"^")[("^"_ArcItm_"^") d
    ..;s DAACIPriority=^DAACI("Priority")
    ..s DAACIPriority=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("OETYPE")
    ..i (","_DAACIPriority_",")[(","_Priority_",") d
    ...s PriorityNo=##Class(DHCAnt.KSS.Combined).GetListNum(KSSInfo,"^",ArcItm)
    ...k ^DHCAACI("CombinedInfo",AdmDr,$I,PriorityNo)
    ...s KSSNum=KSSNum+1
    ...s ^DHCAACI("CombinedInfo",AdmDr,$I,KSSNum)="新开^"_ArcItm_"^"_Priority
    ..e  d
    ...;s PriorityNo=##Class(DHCAnt.KSS.Combined).GetListNum(KSSInfo,"^",ArcItm)
    ...;k ^DHCAACI("CombinedInfo",AdmDr,$I,PriorityNo)
    ...;s KSSNum=KSSNum+1
    ...;s ^DHCAACI("CombinedInfo",AdmDr,$I,KSSNum)="新开^"_ArcItm_"^"_Priority
    .e  d
    ..s KSSNum=KSSNum+1
    ..s ^DHCAACI("CombinedInfo",AdmDr,$I,KSSNum)="新开^"_ArcItm_"^"_Priority
    ..i KSSInfo="" s KSSInfo=ArcItm
    ..e  s KSSInfo=KSSInfo_"^"_ArcItm
    b ;-1
    s Id=""
    s Num=0
    f  s Id=$o(^DHCAACI("CombinedInfo",AdmDr,$I,Id)) q:Id=""  d
    .s Status=$p(^DHCAACI("CombinedInfo",AdmDr,$I,Id),"^",1)
    .s ArcItm=$p(^DHCAACI("CombinedInfo",AdmDr,$I,Id),"^",2)
    .s ArcItmDesc=$p(^ARCIM(+ArcItm,$p(ArcItm,"||",2),1),"^",2) 
    .s Priority=$p(^DHCAACI("CombinedInfo",AdmDr,$I,Id),"^",3)
    .s PriorityDesc=$p(^OECPR(Priority),"^",2) //医嘱类型
    .s Num=Num+1
    .d OutputRow3
    k ^DHCAACI("CombinedInfo",AdmDr,$I)
    Quit $$$OK
OutputRow3
	s ArcItmDesc= ##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcItmDesc,langid)
	s PriorityDesc= ##class(User.OECPriority).GetTranByDesc("OECPRDesc",PriorityDesc,langid)
	s Status= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",Status,langid)
    set Data=$lb(Num,Status,ArcItmDesc,PriorityDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod CombinedInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CombinedInfoExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod CombinedInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CombinedInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Description: 当需要填写变更原因时,在填出页面下放会显示出要填写变更原因的理由
/// input: AdmDr - 就诊ID pa_adm 表ID ;    DAUPList - 审核时使用目的表ID @ 嘱类型ID的串;  表： DHC_AntUsePurpose和OEC_Priority
/// output:
/// d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Combined","AntChange",75,"1161@3")
Query AntChange(AdmDr As %String, DAUPList As %String) As %Query(ROWSPEC = "Status:%String,ArcItm:%String,StopDate:%String")
{
}

ClassMethod AntChangeExecute(ByRef qHandle As %Binary, AdmDr As %String, DAUPList As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    s ^templsj("2016022901")=AdmDr_"!"_DAUPList
    s langid=..%LanguageID()
    s DAACIDate=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("CDATE")
    s DAACID=$o(^User.DHCAntAdmCombinedInfoI("ADM",AdmDr,""))
    i DAACID'="" d
    .s DAACSub=$o(^User.DHCAntAdmCombinedInfoD(DAACID,"ChildDAACS",""),-1)
    .s a=##class(User.DHCAntAdmCombinedSub).%OpenId(DAACID_"||"_DAACSub)
    .s ChaDAUPId=a.ChaDAUPId 
    .s OldKSSInfo=a.KSSInfo
    .s daupIdArr=a.DAUPId
    e  d
    .s ChaDAUPId=""
    .s OldKSSInfo=""
    .s daupIdArr=""
    
    i ChaDAUPId'="" d
    .s len=$l(ChaDAUPId,"^")
    .s StrDate=a.StrDate
    .s StrTime=a.StrTime
    .f j=1:1:len d
    ..;s DAACIDate=^DAACI("Date")
    ..;q:StrDate<(+$H-DAACIDate)
    ..q:(StrDate*86400+StrTime)<((+$H)*86400+$p($H,",",2)-(DAACIDate*3600))	//QP
    ..s Status="上次停止（撤销）或昨日临嘱"
    ..s DaupIdDr=$p(ChaDAUPId,"^",j)
    ..s ArcItm=$P(^DAUP("DAUP",DaupIdDr),"^",21)
    ..s ArcItmDesc=$p(^ARCIM(+ArcItm,$p(ArcItm,"||",2),1),"^",2) 
    ..s StopTime=""
    ..i StrTime'="" s StopTime=$zt(StrTime,2)
    ..s StopDate=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(StrDate)	//$zd(StrDate,3)
    ..s StopDate=StopDate_" "_StopTime
    ..d OutputRow4
    
    //s KSSInfo=a.KSSInfo
    s KSSInfo=""
    s AllNum=$l(daupIdArr,"^")
    for j=1:1:AllNum d
    .s daupid=$p(daupIdArr,"^",j)                //预停医嘱在听医嘱时不处理，在显示时处理现实内容
    .q:daupid=""
    .s oeori=$p($g(^DAUP("DAUP",daupid)),"^",3)
    .S check=..CheckOrderP(oeori)
    .q:check=2
    .i KSSInfo="" s KSSInfo=$p(OldKSSInfo,"^",j)
    .e  s KSSInfo=KSSInfo_"^"_$p(OldKSSInfo,"^",j)
    
    s l=$l(DAUPList,"^")
    for i=1:1:l d
    .s DAUPStr=$p(DAUPList,"^",i)
    .s DAUPID=$p(DAUPStr,"@",1)
    .s oeori=$p($g(^DAUP("DAUP",DAUPID)),"^",3)
    .S check=..CheckOrderP(oeori)
    .;q:check=2
    .s ArcItm=$P(^DAUP("DAUP",DAUPID),"^",21)
    .s ArcItmDesc=$p(^ARCIM(+ArcItm,$p(ArcItm,"||",2),1),"^",2) 
    .i ("^"_KSSInfo_"^")[("^"_ArcItm_"^") d
    ..s Status="存在相同医嘱"
    ..s StopDate=""
    ..d OutputRow4
    .e  d
    ..s KSSInfo=KSSInfo_"^"_ArcItm
    
    Quit $$$OK
OutputRow4
	s ArcItmDesc= ##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcItmDesc,langid)
	s Status= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",Status,langid)
    set Data=$lb(Status,ArcItmDesc,StopDate)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod AntChangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AntChangeExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod AntChangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AntChangeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Description: 向表内插入数据
/// input: AdmDr - 就诊ID pa_adm 表ID; DAUPList - 审核时使用目的表ID @ 嘱类型ID的串;  表：DHC_AntUsePurpose和OEC_Priority;  CURId - 联用原因表的ID;  CHRId - 变更原因表的ID 
/// output: DHCAntAdmCombinedSub表的ID
/// w ##Class(DHCAnt.KSS.Combined).SaveCombinedInfo(75,"1143@5","","")
/// w ##Class(DHCAnt.KSS.Combined).SaveCombinedInfo(145,"2039@3^2040@3^2041@3^2042@3^2043@3^2044@3^2045@3^2046@3^2047@3^2048@3^2049@3^2050@3^2051@3","","441",2)
ClassMethod SaveCombinedInfo(AdmDr As %String, DAUPList As %String, CURId As %String, CHRId As %String, InHosp = "")
{
	n (AdmDr,DAUPList,CURId,CHRId,InHosp)
    k ^DHCAACI("SaveCombined",AdmDr,$I),^DHCAACI("Note",AdmDr,$I)
    ;s DAUPList=..FilterOMSTOrder(DAUPList)
    s ^TEMP("DHCAnt","Temp","SaveCombinedInfo")=AdmDr_": "_DAUPList_": "_CURId_": "_CHRId
    s DAACID=$o(^User.DHCAntAdmCombinedInfoI("ADM",AdmDr,""))
    B ;009
    i DAACID="" d
    .s KSSNum=0,KSSInfo="",aKSSInfo="",aKSSNum=0
    .d CheckInfo
    .d GetInfo
    .s parr="&"_AdmDr_"&"_KSSNum_"&"_KSSNum_"&"_ArcItmInfo_"&&&"_Date_"&"_Time
    .s DAACID=##Class(User.DHCAntAdmCombinedInfo).Save(parr)
    .s SubParr="&"_DAACID_"&"_KSSNum_"&"_CURId_"&"_CHRId_"&"_DAUPId_"&&"_ArcItmInfo_"&"_PriorityInfo_"&"
    .s SubParr=SubParr_"&&"_Date_"&"_Time_"&&&"_Note
    .s DAACSub=##Class(User.DHCAntAdmCombinedSub).Save(SubParr)
    e  d
    .;s KSSNum=0,KSSInfo="",aKSSInfo="",aKSSNum=0
    .d GetDAACI
    .d GetDAACSub
    .f i=1:1:KSSNum d
    ..s ^DHCAACI("SaveCombined",AdmDr,$I,i)=$p(bDAUPId,"^",i)_"^"_$p(KSSInfo,"^",i)_"^"_$p(bPriorityInfo,"^",i)
    .d CheckInfo
    .d GetInfo
    .i KSSNum>aMaxNum s aMaxNum=KSSNum
    .s parr=DAACID_"&&"_aMaxNum_"&"_aKSSNum_"&"_aKSSInfo_"&&&"_Date_"&"_Time
    .s DAACID=##Class(User.DHCAntAdmCombinedInfo).Save(parr)
    .s SubParr1=DAACID_"||"_DAACSub
    .s $p(SubParr1,"&",14)=Date
    .s $p(SubParr1,"&",15)=Time
    .s DAACSub1=##Class(User.DHCAntAdmCombinedSub).Save(SubParr1)
    .s SubParr="&"_DAACID_"&"_KSSNum_"&"_CURId_"&"_CHRId_"&"_DAUPId_"&&"_ArcItmInfo_"&"_PriorityInfo_"&"
    .s SubParr=SubParr_"&&"_Date_"&"_Time_"&&&"_Note
    .s DAACSub=##Class(User.DHCAntAdmCombinedSub).Save(SubParr)
    
    ;k ^DHCAACI("SaveCombined",AdmDr,$I),^DHCAACI("Note",AdmDr,$I)
    q DAACSub
    
CheckInfo
    s len=$l(DAUPList,"^")
    f j=1:1:len d
    .s DAUPStr=$p(DAUPList,"^",j)
    .s DAUPID=$p(DAUPStr,"@",1)
    .s Priority=$p(DAUPStr,"@",2)
    .s ArcItm=$P(^DAUP("DAUP",DAUPID),"^",21)
    .i ("^"_aKSSInfo_"^")'[("^"_ArcItm_"^") d
    ..i aKSSInfo="" s aKSSInfo=ArcItm
    ..e  s aKSSInfo=aKSSInfo_"^"_ArcItm
    ..s aKSSNum=aKSSNum+1
    .i ("^"_KSSInfo_"^")[("^"_ArcItm_"^") d
    ..;s DAACIPriority=^DAACI("Priority")
    ..s DAACIPriority=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("OETYPE",InHosp)
    ..i (","_DAACIPriority_",")[(","_Priority_",") d
    ...s PriorityNo=##Class(DHCAnt.KSS.Combined).GetListNum(KSSInfo,"^",ArcItm)
    ...s ^DHCAACI("Note",AdmDr,$I,j)=^DHCAACI("SaveCombined",AdmDr,$I,PriorityNo)
    ...k ^DHCAACI("SaveCombined",AdmDr,$I,PriorityNo)
    ...s KSSNum=KSSNum+1
    ...s ^DHCAACI("SaveCombined",AdmDr,$I,KSSNum)=DAUPID_"^"_ArcItm_"^"_Priority
    ..e  d
    ...s ^DHCAACI("Note",AdmDr,$I,j)=DAUPID_"^"_ArcItm_"^"_Priority
    .e  d
    ..s KSSNum=KSSNum+1
    ..s ^DHCAACI("SaveCombined",AdmDr,$I,KSSNum)=DAUPID_"^"_ArcItm_"^"_Priority
    ..i KSSInfo="" s KSSInfo=ArcItm
    ..e  s KSSInfo=KSSInfo_"^"_ArcItm
    q
    
GetInfo 
    s Id="",DAUPId="",PriorityInfo="",ArcItmInfo="",KSSNum=0
    f  s Id=$o(^DHCAACI("SaveCombined",AdmDr,$I,Id)) q:Id=""  d
    .s KSSNum=KSSNum+1
    .s DAUP=$p(^DHCAACI("SaveCombined",AdmDr,$I,Id),"^",1)
    .i DAUPId="" s DAUPId=DAUP
    .e  s DAUPId=DAUPId_"^"_DAUP
    .s ArcItm=$p(^DHCAACI("SaveCombined",AdmDr,$I,Id),"^",2)
    .i ArcItmInfo="" s ArcItmInfo=ArcItm
    .e  s ArcItmInfo=ArcItmInfo_"^"_ArcItm
    .s Priority=$p(^DHCAACI("SaveCombined",AdmDr,$I,Id),"^",3)
    .i PriorityInfo="" s PriorityInfo=Priority
    .e  s PriorityInfo=PriorityInfo_"^"_Priority
    
    s Note=""
    f  s Id=$o(^DHCAACI("Note",AdmDr,$I,Id)) q:Id=""  d
    .s DAUP=$p(^DHCAACI("Note",AdmDr,$I,Id),"^",1)
    .i Note="" s Note=DAUP
    .e  s Note=Note_"^"_DAUP
    s Date=+$H
    s Time=$p($H,",",2)
    q
    
GetDAACI
    s a=##class(User.DHCAntAdmCombinedInfo).%OpenId(DAACID)
    s aMaxNum=a.MaxNum
    s aKSSNum=a.KSSNum
    s aKSSInfo=a.KSSInfo
    s aMinorSubCatNum=a.MinorSubCatNum
    s aMinorSubCatInfo=a.MinorSubCatNum
    q
    
GetDAACSub
    s DAACSub=$o(^User.DHCAntAdmCombinedInfoD(DAACID,"ChildDAACS",""),-1)
    B ;GetDAACSub
    //q:DAACSub=""
    s b=##class(User.DHCAntAdmCombinedSub).%OpenId(DAACID_"||"_DAACSub)
    s KSSNum=b.CNum
    s bDAUPId=b.DAUPId
    s KSSInfo=b.KSSInfo
    s bPriorityInfo=b.PriorityInfo
    s bMinorSubCatNum=b.MinorSubCatNum
    s bMinorSubCatInfo=b.MinorSubCatInfo
    q
}

/// Description: 向联用表内补录某天数据(7.0之前)
/// input: Date
/// output: 
/// d ##Class(DHCAnt.KSS.Combined).CreateDAACIFromDate("")
ClassMethod CreateDAACIFromDate(Date)
{
    i Date="" s Date=+$H
    s oeroid=""
    f  s oeroid=$o(^OEORDi(0,"StDt",Date,oeroid)) q:(oeroid="")  d
    .s childSub="",DAUPList=""
    .s EpisodeID=$p(^OEORD(oeroid),"^",1)
    .f  s childSub=$o(^OEORDi(0,"StDt",Date,oeroid,childSub)) q:(childSub="")  d
    ..s OEORIPriorityDR=$p(^OEORD(oeroid,"I",childSub,1),"^",8)         ///医嘱类型id
    ..s OerStatusId=$p(^OEORD(oeroid,"I",childSub,1),"^",13)            ///医嘱状态id
    ..q:OerStatusId=4
    ..s CurrentOrderFillerNoStr=$p($g(^OEORD(oeroid,"I",childSub,9)),"^",12)
    ..i CurrentOrderFillerNoStr'="" s CurrentOrder=$p(CurrentOrderFillerNoStr,"!!",1)
    ..e  s CurrentOrder=oeroid_"||"_childSub
    ..q:'$D(^DAUP("ADM",EpisodeID,CurrentOrder))
    ..s DAUPId=$o(^DAUP("ADM",EpisodeID,CurrentOrder,""))
    ..i DAUPList="" s DAUPList=DAUPId_"@"_OEORIPriorityDR
    ..e  s DAUPList=DAUPList_"^"_DAUPId_"@"_OEORIPriorityDR
    .i DAUPList'="" s DAACSub=..SaveCombinedInfo(EpisodeID,DAUPList,"","")
    
    q
}

/// Description: 向联用表内补录上线时数据(7.0之后)
/// input: 
/// output: 
/// d ##Class(DHCAnt.KSS.Combined).CreateDAACIFromDAUP()
ClassMethod CreateDAACIFromDAUP()
{
    s nowdate=+$H
    ;s DAACIPriority=^DAACI("Priority")
    s DAACIPriority=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("OETYPE")
    s EpisodeID=""
    f  s EpisodeID=$o(^DAUP("ADM",EpisodeID)) q:EpisodeID=""  d
    .s Order="",DAUPList=""
    .f  s Order=$o(^DAUP("ADM",EpisodeID,Order)) q:Order=""  d
    ..s oeroid=$p(Order,"||",1)
    ..s childSub=$p(Order,"||",2)
    ..s OerStatusId=$p(^OEORD(oeroid,"I",childSub,1),"^",13)
    ..q:OerStatusId'=1
    ..s check=..CheckOrderP(Order)          //update by shp
    ..q:check=2                            //update by shp
    ..s DAUPId=$o(^DAUP("ADM",EpisodeID,Order,""))
    ..s OEORIPriorityDR=$p(^OEORD(oeroid,"I",childSub,1),"^",8)
    ..s OrderDate=$p($g(^OEORD(oeroid,"I",childSub,3)),"^",7)
    ..s OrderTime=$p($g(^OEORD(oeroid,"I",childSub,1)),"^",17)
    ..q:((","_DAACIPriority_",")'[(","_OEORIPriorityDR_",")&(OrderDate'=nowdate))
    ..i DAUPList="" s DAUPList=DAUPId_"@"_OEORIPriorityDR
    ..e  s DAUPList=DAUPList_"^"_DAUPId_"@"_OEORIPriorityDR
    .i DAUPList'="" s DAACSub=..SaveCombinedInfo(EpisodeID,DAUPList,"","")
    
    q
}

/// Description: 向联用表内补录上线时数据(7.0之后)处理存在相同医嘱项的长期医嘱
/// input: 
/// output: 
/// d ##Class(DHCAnt.KSS.Combined).CreateDAACIFromDAUP2()
ClassMethod CreateDAACIFromDAUP2()
{
    s nowdate=+$H
    ;s DAACIPriority=^DAACI("Priority")
    s DAACIPriority=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("OETYPE")
    s CodeD=$o(^OEC("OSTAT",0,"Code","D",0))
    s CodeV=$o(^OEC("OSTAT",0,"Code","V",0))
    s EpisodeID=""
    f  s EpisodeID=$o(^DAUP("ADM",EpisodeID)) q:EpisodeID=""  d
    .s Order=""
    .f  s Order=$o(^DAUP("ADM",EpisodeID,Order)) q:Order=""  d
    ..s oeroid=$p(Order,"||",1)
    ..s childSub=$p(Order,"||",2)
    ..s OerStatusId=$p(^OEORD(oeroid,"I",childSub,1),"^",13)
    ..q:(OerStatusId'=CodeV)
    ..s check=..CheckOrderP(Order)          //update by shp
    ..q:check=2                            //update by shp
    ..s DAUPId=$o(^DAUP("ADM",EpisodeID,Order,""))
    ..s OEORIPriorityDR=$p(^OEORD(oeroid,"I",childSub,1),"^",8)
    ..s OrderDate=$p($g(^OEORD(oeroid,"I",childSub,3)),"^",7)
    ..s OrderTime=$p($g(^OEORD(oeroid,"I",childSub,1)),"^",17)
    ..q:((","_DAACIPriority_",")'[(","_OEORIPriorityDR_",")&(OrderDate'=nowdate))
    ..s DAUPList=DAUPId_"@"_OEORIPriorityDR
    ..s DAACSub=..SaveCombinedInfo(EpisodeID,DAUPList,"","")
    
    q
}

/// Description: 根据医院要求来设置参数
/// input: 
/// output:
/// ^DAACI("Date")：医院规定填写变更原因的天数,若在此规定日期之内发生了药品的变更,那么需要填写一个变更原因(停药之后首次开药)
/// ^DAACI("Priority"):医嘱类型表长嘱的rowid ^OECPR
/// d ##Class(DHCAnt.KSS.Combined).CreateGlobal()
ClassMethod CreateGlobal()
{
    s ^DAACI("Date")=2  
    s ^DAACI("Priority")="5^8"
    q
}

/// Description: 停医嘱后减掉一条或多条联用数
/// input: EpisodeID - 就诊ID pa_adm 表ID;  OrderList - 表OEOrdItem的ID串
/// output: 0 - 失败;  DHCAntAdmCombinedSub表的ID - 成功
/// w ##Class(DHCAnt.KSS.Combined).StopAntOrder(77,"67||300")
/// w ##Class(DHCAnt.KSS.Combined).StopAntOrder(108,"90||6")
ClassMethod StopAntOrder(EpisodeID, OrderList, InHosp = "")
{
	n (EpisodeID, OrderList,InHosp,%session)
	Q:(EpisodeID="")&&(OrderList="") 0
	i InHosp="" {
		i $d(%session) {
			s InHosp=%session.Get("LOGON.HOSPID")
		} else {
			s cOrder=$p(OrderList,"^",1)
			s cOeori=$p(cOrder,"!",1)
			q:cOeori="" 0
			s ord=+cOeori,sub=$p(cOeori,"||",2)
			Q:(ord="")||(sub="") 0
			Q:'$d(^OEORD(ord,"I",sub,9)) 0
			s admLoc=$p(^OEORD(ord,"I",sub,9),"^",2)
			s hosp=$p(^CTLOC(admLoc),"^",22)
			q:hosp="" 0
			s InHosp=hosp
		}
	}
	Q:InHosp="" 0
	s SCKJ=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SCKJ",InHosp)
    q:(SCKJ="")||(SCKJ="0") 0 //QP 未启用
    //s ^HW(1)=OrderList
    s DAUPList="",rtn=0
    s AmdType=$p(^PAADM(EpisodeID),"^",2)
    ;q:AmdType'="I" rtn
    s len=$l(OrderList,"^")
    f i=1:1:len d
    .s OrderStr=$p(OrderList,"^",i)
    .s Order=OrderStr
    .i OrderStr["!" s Order=$p(OrderStr,"!",1)
    .i OrderStr["&" s Order=$p(OrderStr,"&",1)
    .;s oeroid=$p(Order,"||",1)
    .;s childSub=$p(Order,"||",2)
    .;s CurrentOrderFillerNoStr=$p($g(^OEORD(oeroid,"I",childSub,9)),"^",12)
    .;i CurrentOrderFillerNoStr'="" s CurrentOrder=$p(CurrentOrderFillerNoStr,"!!",1)
    .;e  s CurrentOrder=Order
    .q:'$D(^DAUP("ADM",EpisodeID,Order))
    .s DAUPId=$o(^DAUP("ADM",EpisodeID,Order,""))
    .S check=..CheckOrderP(Order) 
    .q:(check=1)
    .i DAUPList="" s DAUPList=DAUPId
    .e  d
    ..i ("^"_DAUPList_"^")'[("^"_DAUPId_"^") s DAUPList=DAUPList_"^"_DAUPId
    q:DAUPList="" rtn
    q:EpisodeID="" rtn
    
    s DAACID=$o(^User.DHCAntAdmCombinedInfoI("ADM",EpisodeID,""))
    q:DAACID="" rtn
    s DAACSub=$o(^User.DHCAntAdmCombinedInfoD(DAACID,"ChildDAACS",""),-1)
    s a=##class(User.DHCAntAdmCombinedSub).%OpenId(DAACID_"||"_DAACSub)
    s DAUPIdInfo=a.DAUPId
    s KSSInfo=a.KSSInfo
    s PriorityInfo=a.PriorityInfo
    s Note=a.Note ;临时使用目的串
    s ChaDAUPId="",NewDAUPId="",NewKSSInfo="",NewPriorityInfo="",KSSNum=0,NewNote=""
    s Notelen=$l(Note,"^")
    f NoteNo=1:1:Notelen d
    .s NoteDAUPId=$p(Note,"^",NoteNo)
    .q:NoteDAUPId=""
    .s NoteOrderID=$P(^DAUP("DAUP",NoteDAUPId),"^",3)
    .s NoteArcItm=$P(^DAUP("DAUP",NoteDAUPId),"^",21)
    .s NotePriority=$p(^OEORD(+NoteOrderID,"I",$p(NoteOrderID,"||",2),1),"^",8)
    .s DAUPIdInfo=DAUPIdInfo_"^"_NoteDAUPId
    .s KSSInfo=KSSInfo_"^"_NoteArcItm
    .s PriorityInfo=PriorityInfo_"^"_NotePriority
    s len=$l(DAUPIdInfo,"^")
    f j=1:1:len d
    .s DAUPId=$p(DAUPIdInfo,"^",j)
    .s KSS=$p(KSSInfo,"^",j)
    .s Priority=$p(PriorityInfo,"^",j)
    .i ("^"_DAUPList_"^")[("^"_DAUPId_"^") d
    ..i ChaDAUPId="" s ChaDAUPId=DAUPId
    ..e  s ChaDAUPId=ChaDAUPId_"^"_DAUPId
    .e  d
    ..i ("^"_NewKSSInfo_"^")[("^"_KSS_"^") d
    ...i NewNote="" s NewNote=DAUPId
    ...e  s NewNote=NewNote_"^"_DAUPId
    ..e  d
    ...i NewDAUPId="" s NewDAUPId=DAUPId
    ...e  s NewDAUPId=NewDAUPId_"^"_DAUPId
    ...i NewKSSInfo="" s NewKSSInfo=KSS
    ...e  s NewKSSInfo=NewKSSInfo_"^"_KSS
    ...i NewPriorityInfo="" s NewPriorityInfo=Priority
    ...e  s NewPriorityInfo=NewPriorityInfo_"^"_Priority
    ...s KSSNum=KSSNum+1
    q:ChaDAUPId="" rtn
    
    s Date=+$H
    s Time=$p($H,",",2)
    s SubParr1=DAACID_"||"_DAACSub
    s $p(SubParr1,"&",14)=Date
    s $p(SubParr1,"&",15)=Time
    s DAACSub1=##Class(User.DHCAntAdmCombinedSub).Save(SubParr1)
    s SubParr="&"_DAACID_"&"_KSSNum_"&&&"_NewDAUPId_"&"_ChaDAUPId_"&"_NewKSSInfo_"&"_NewPriorityInfo_"&"
    s SubParr=SubParr_"&&"_Date_"&"_Time_"&"_NewNote
    s DAACSub=##Class(User.DHCAntAdmCombinedSub).Save(SubParr)
    q DAACSub
}

/// Description: 作废医嘱后重新计算联用数
/// input: EpisodeID - 就诊ID pa_adm 表ID;  OrderList - 表OEOrdItem的ID串
/// output: 0 - 失败;  DHCAntAdmCombinedInfo表的ID - 成功
/// w ##Class(DHCAnt.KSS.Combined).CancleAntOrder(77,"67||300")
/// w ##Class(DHCAnt.KSS.Combined).CancleAntOrder(108,"90||6")
ClassMethod CancleAntOrder(EpisodeID, OrderList, InHosp = "")
{
	n (EpisodeID, OrderList,InHosp,%session)
	
	Q:(EpisodeID="")&&(OrderList="") 0
	i InHosp="" {
		i $d(%session) {
			s InHosp=%session.Get("LOGON.HOSPID")
		} else {
			s cOrder=$p(OrderList,"^",1)
			s cOeori=$p(cOrder,"!",1)
			q:cOeori="" 0
			s ord=+cOeori,sub=$p(cOeori,"||",2)
			Q:(ord="")||(sub="") 0
			Q:'$d(^OEORD(ord,"I",sub,9)) 0
			s admLoc=$p(^OEORD(ord,"I",sub,9),"^",2)
			s hosp=$p(^CTLOC(admLoc),"^",22)
			q:hosp="" 0
			s InHosp=hosp
		}
	}
	Q:InHosp="" 0
	s SCKJ=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SCKJ",InHosp)
    q:(SCKJ="")||(SCKJ="0") 0 //QP 未启用
    s DAUPList="",rtn=0
    s AmdType=$p(^PAADM(EpisodeID),"^",2)
    ;q:AmdType'="I" rtn
    s len=$l(OrderList,"^")
    f i=1:1:len d
    .s OrderStr=$p(OrderList,"^",i)
    .s Order=$p(OrderStr,"!",1)
    .q:'$D(^DAUP("ADM",EpisodeID,Order))
    .s DAUPId=$o(^DAUP("ADM",EpisodeID,Order,""))
    .i DAUPList="" s DAUPList=DAUPId
    .e  d
    ..i ("^"_DAUPList_"^")'[("^"_DAUPId_"^") s DAUPList=DAUPList_"^"_DAUPId
    q:DAUPList="" rtn
    q:EpisodeID="" rtn
    
    s DAACID=$o(^User.DHCAntAdmCombinedInfoI("ADM",EpisodeID,""))
    q:DAACID="" rtn
    /*
    s a=##class(User.DHCAntAdmCombinedInfo).%OpenId(DAACID)
    s aMaxNum=a.MaxNum
    s aKSSNum=a.KSSNum
    s aKSSInfo=a.KSSInfo
    s aMinorSubCatNum=a.MinorSubCatNum
    s aMinorSubCatInfo=a.MinorSubCatNum
    */
    s MaxNum=0,AllKSSNum=0,AllKSSInfo=""
    
    s len=$l(DAUPList,"^")
    f i=1:1:len d
    .s CancleDAUP=$P(DAUPList,"^",i)
    .s DAACSub=""
    .f  s DAACSub=$o(^User.DHCAntAdmCombinedInfoD(DAACID,"ChildDAACS",DAACSub)) q:DAACSub=""  d
    ..s b=##class(User.DHCAntAdmCombinedSub).%OpenId(DAACID_"||"_DAACSub)
    ..s DAUPId=b.DAUPId
    ..s KSSInfo=b.KSSInfo
    ..s PriorityInfo=b.PriorityInfo
    ..s CNum=b.CNum
    ..s Note1=b.Note1 ;作废使用目的串
    ..s Note=b.Note ;临时使用目的串
    ..s bDAUPId=DAUPId,bKSSInfo=KSSInfo,bPriorityInfo=PriorityInfo
    ..s Notelen=$l(Note,"^")
    ..f NoteNo=1:1:Notelen d
    ...s NoteDAUPId=$p(Note,"^",NoteNo)
    ...q:NoteDAUPId=""
    ...s NoteOrderID=$P(^DAUP("DAUP",NoteDAUPId),"^",3)
    ...s NoteArcItm=$P(^DAUP("DAUP",NoteDAUPId),"^",21)
    ...s NotePriority=$p(^OEORD(+NoteOrderID,"I",$p(NoteOrderID,"||",2),1),"^",8)
    ...s bDAUPId=bDAUPId_"^"_NoteDAUPId
    ...s bKSSInfo=bKSSInfo_"^"_NoteArcItm
    ...s bPriorityInfo=bPriorityInfo_"^"_NotePriority
    ..s NewDAUPId="",NewKSSInfo="",NewPriorityInfo="",KSSNum=0,NewNote=""
    ..i ("^"_bDAUPId_"^")[("^"_CancleDAUP_"^") d
    ...d ChangeSub
    ..e  d
    ...;i ("^"_Note_"^")[("^"_CancleDAUP_"^") d
    ...;.i Note1="" s Note1=CancleDAUP
    ...;.e  s Note1=Note1_"^"_CancleDAUP
    ...;.s SubParr=DAACID_"||"_DAACSub
    ...;.s $p(SubParr,"&",17)=Note1
    ...;.s DAACSub=##Class(User.DHCAntAdmCombinedSub).Save(SubParr)
    ...s NewKSSInfo=KSSInfo
    ...s KSSNum=CNum
    ..d GetCombinedInfo
    .i AllKSSInfo="" s AllKSSInfo="+" ;特殊处理,更新程序不处理空
    .s parr=DAACID_"&&"_MaxNum_"&"_AllKSSNum_"&"_AllKSSInfo
    .s rtn=##Class(User.DHCAntAdmCombinedInfo).Save(parr)
    
    q rtn
    
    
GetCombinedInfo
    q:NewKSSInfo=""
    s Addlen=$l(NewKSSInfo,"^")
    f k=1:1:Addlen d
    .s AddKSSInfo=$p(NewKSSInfo,"^",k)
    .i ("^"_AllKSSInfo_"^")'[("^"_AddKSSInfo_"^") d
    ..i AllKSSInfo="" s AllKSSInfo=AddKSSInfo
    ..e  s AllKSSInfo=AllKSSInfo_"^"_AddKSSInfo
    ..s AllKSSNum=AllKSSNum+1
    i MaxNum<KSSNum s MaxNum=KSSNum
    q
        
ChangeSub
    s CancleNo=##Class(DHCAnt.KSS.Combined).GetListNum(bDAUPId,"^",CancleDAUP)
    s Sublen=$l(bDAUPId,"^")
    f j=1:1:Sublen d
    .q:j=CancleNo
    .s KSSArcItm=$P(bKSSInfo,"^",j)
    .i ("^"_NewKSSInfo_"^")[("^"_KSSArcItm_"^") d
    ..i NewNote="" s NewNote=$P(bDAUPId,"^",j)
    ..e  s NewNote=NewNote_"^"_$P(bDAUPId,"^",j)
    .e  d
    ..i NewDAUPId="" s NewDAUPId=$P(bDAUPId,"^",j)
    ..e  s NewDAUPId=NewDAUPId_"^"_$P(bDAUPId,"^",j)
    ..i NewKSSInfo="" s NewKSSInfo=$P(bKSSInfo,"^",j)
    ..e  s NewKSSInfo=NewKSSInfo_"^"_$P(bKSSInfo,"^",j)
    ..i NewPriorityInfo="" s NewPriorityInfo=$P(bPriorityInfo,"^",j)
    ..e  s NewPriorityInfo=NewPriorityInfo_"^"_$P(bPriorityInfo,"^",j)
    ..s KSSNum=KSSNum+1
    i Note1="" s Note1=CancleDAUP
    e  s Note1=Note1_"^"_CancleDAUP
    s SubParr=DAACID_"||"_DAACSub
    i (NewNote="")&&(Note'="") s NewNote="+" ;特殊处理,更新程序不处理空
    i NewDAUPId="" s NewDAUPId="+",NewKSSInfo="+",NewPriorityInfo="+"
    s $p(SubParr,"&",3)=KSSNum
    s $p(SubParr,"&",6)=NewDAUPId
    s $p(SubParr,"&",8)=NewKSSInfo
    s $p(SubParr,"&",9)=NewPriorityInfo
    s $p(SubParr,"&",16)=NewNote
    s $p(SubParr,"&",17)=Note1
    s rtn=##Class(User.DHCAntAdmCombinedSub).Save(SubParr)
    i NewKSSInfo="+" s NewDAUPId="",NewKSSInfo="",NewPriorityInfo=""
    q
}

/// Description: 对当前联用抗生素存在临时医嘱做跨天减掉临时医嘱的自动任务处理
/// input: 
/// output: 
/// d ##Class(DHCAnt.KSS.Combined).ReduceCombinedInfo()
ClassMethod ReduceCombinedInfo()
{
	n
	s InHosp=""
	for {
		s InHosp=$o(^CT("HOSP",InHosp))
		q:InHosp=""
		s SCKJ=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SCKJ",InHosp)
	    continue:+SCKJ=0  //未启用
	    s YDate=+$H-1
	    ;s DAACIPriority=^DAACI("Priority")
	    s DAACIPriority=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("OETYPE",InHosp)
	    continue:+DAACIPriority=0
	    s CurrWard=""  f  s CurrWard=$o(^PAADMi("CurrWard",CurrWard)) q:CurrWard=""  d
	    .s Room="" f  s Room=$o(^PAADMi("CurrWard",CurrWard,Room)) q:Room=""  d
	    ..s Adm="" f  s Adm=$o(^PAADMi("CurrWard",CurrWard,Room,Adm)) q:Adm=""  d
	    ...s DAACID=$o(^User.DHCAntAdmCombinedInfoI("ADM",Adm,""))
	    ...q:DAACID=""
	    ...d ReduceAdmInfo
	    s Adm=""  f  s Adm=$o(^PAADMi("DischDate",YDate,Adm)) q:Adm=""  d
	    .s DAACID=$o(^User.DHCAntAdmCombinedInfoI("ADM",Adm,""))
	    .q:DAACID=""
	    .d ReduceAdmInfo
    
	}
	/*s cHosp=0,SCKJ=0,InHosp=""
	f  s cHosp=$o(^DHCAntBaseMainConfigI("MCGHosp",cHosp)) q:(cHosp="")||(cHosp=1)  d
	.s SCKJ=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SCKJ",cHosp)
	.i SCKJ=1 s InHosp=cHosp*/
    q ""
    
ReduceAdmInfo
    s DAACSub=$o(^User.DHCAntAdmCombinedInfoD(DAACID,"ChildDAACS",""),-1)
    s a=##class(User.DHCAntAdmCombinedSub).%OpenId(DAACID_"||"_DAACSub)
    s DAUPIdInfo=a.DAUPId
    s KSSInfo=a.KSSInfo
    s PriorityInfo=a.PriorityInfo
    q:DAUPIdInfo=""
    s ChaDAUPId="",NewDAUPId="",NewKSSInfo="",NewPriorityInfo="",KSSNum=0
    s len=$l(PriorityInfo,"^")
    f j=1:1:len d
    .s DAUPId=$p(DAUPIdInfo,"^",j)
    .s KSS=$p(KSSInfo,"^",j)
    .s Priority=$p(PriorityInfo,"^",j)
    .s oeori=$p($g(^DAUP("DAUP",DAUPId)),"^",3)    ;shp
    .S check=..CheckOrderP(oeori)       ;shp
    .;将预停医嘱停止时间小于当前时间的不统计
    .i ((","_DAACIPriority_",")[(","_Priority_","))&&(check'=2) d
    ..s KSSNum=KSSNum+1
    ..i NewDAUPId="" s NewDAUPId=DAUPId
    ..e  s NewDAUPId=NewDAUPId_"^"_DAUPId
    ..i NewKSSInfo="" s NewKSSInfo=KSS
    ..e  s NewKSSInfo=NewKSSInfo_"^"_KSS
    ..i NewPriorityInfo="" s NewPriorityInfo=Priority
    ..e  s NewPriorityInfo=NewPriorityInfo_"^"_Priority
    .e  d
    ..i ChaDAUPId="" s ChaDAUPId=DAUPId
    ..e  s ChaDAUPId=ChaDAUPId_"^"_DAUPId
    q:ChaDAUPId=""
    s Date=+$H
    s Time=$p($H,",",2)
    s SubParr1=DAACID_"||"_DAACSub
    s $p(SubParr1,"&",14)=Date
    s $p(SubParr1,"&",15)=Time
    s DAACSub1=##Class(User.DHCAntAdmCombinedSub).Save(SubParr1)
    s SubParr="&"_DAACID_"&"_KSSNum_"&&&"_NewDAUPId_"&"_ChaDAUPId_"&"_NewKSSInfo_"&"_NewPriorityInfo_"&"
    s SubParr=SubParr_"&&"_Date_"&"_Time
    s DAACSub=##Class(User.DHCAntAdmCombinedSub).Save(SubParr)
    
    q
    
    //以下已经不用
    s DAACID=""
    f  s DAACID=$o(^User.DHCAntAdmCombinedSubI("SDATE",Date,DAACID)) q:DAACID=""  d
    .s DAACSub=$o(^User.DHCAntAdmCombinedInfoD(DAACID,"ChildDAACS",""),-1)
    .s a=##class(User.DHCAntAdmCombinedSub).%OpenId(DAACID_"||"_DAACSub)
    .s DAUPIdInfo=a.DAUPId
    .s KSSInfo=a.KSSInfo
    .s PriorityInfo=a.PriorityInfo
    .s ChaDAUPId="",NewDAUPId="",NewKSSInfo="",NewPriorityInfo="",KSSNum=0
    .s len=$l(PriorityInfo,"^")
    .f j=1:1:len d
    ..s DAUPId=$p(DAUPIdInfo,"^",j)
    ..s KSS=$p(KSSInfo,"^",j)
    ..s Priority=$p(PriorityInfo,"^",j)
    ..s oeori=$p(^DAUP("DAUP",daupid),"^",3)    ;shp
    ..S check=..CheckOrderP(oeori)       ;shp
    ..;将预停医嘱停止时间小于当前时间的不统计
    ..i ((","_DAACIPriority_",")[(","_Priority_","))&&(check'=2) d
    ...s KSSNum=KSSNum+1
    ...i NewDAUPId="" s NewDAUPId=DAUPId
    ...e  s NewDAUPId=NewDAUPId_"^"_DAUPId
    ...i NewKSSInfo="" s NewKSSInfo=KSS
    ...e  s NewKSSInfo=NewKSSInfo_"^"_KSS
    ...i NewPriorityInfo="" s NewPriorityInfo=Priority
    ...e  s NewPriorityInfo=NewPriorityInfo_"^"_Priority
    ..e  d
    ...i ChaDAUPId="" s ChaDAUPId=DAUPId
    ...e  s ChaDAUPId=ChaDAUPId_"^"_DAUPId
    .q:ChaDAUPId=""
    .s Date=+$H
    .s Time=$p($H,",",2)
    .s SubParr1=DAACID_"||"_DAACSub
    .s $p(SubParr1,"&",14)=Date
    .s $p(SubParr1,"&",15)=Time
    .s DAACSub1=##Class(User.DHCAntAdmCombinedSub).Save(SubParr1)
    .s SubParr="&"_DAACID_"&"_KSSNum_"&&&"_NewDAUPId_"&"_ChaDAUPId_"&"_NewKSSInfo_"&"_NewPriorityInfo_"&"
    .s SubParr=SubParr_"&&"_Date_"&"_Time
    .s DAACSub=##Class(User.DHCAntAdmCombinedSub).Save(SubParr)
    
    q
}

/// 处理"+"号错误问题
/// w ##Class(DHCAnt.KSS.Combined).CombinedInfo()
ClassMethod CombinedInfo()
{
    s DAACID=0,i=0
    f  s DAACID=$o(^User.DHCAntAdmCombinedInfoD(DAACID)) q:DAACID=""  d
    .s a=##class(User.DHCAntAdmCombinedInfo).%OpenId(DAACID)
    .s KSSInfo=a.KSSInfo
    .q:KSSInfo=""
    .s NewKSSInfo="",NewKSSNum=0
    .s len=$l(KSSInfo,"^")
    .f k=1:1:len d
    ..s thisKSSInfo=$p(KSSInfo,"^",k)
    ..q:thisKSSInfo="+"
    ..q:thisKSSInfo=""
    ..i NewKSSInfo="" s NewKSSInfo=thisKSSInfo
    ..e  s NewKSSInfo=NewKSSInfo_"^"_thisKSSInfo
    ..s NewKSSNum=NewKSSNum+1
    .i NewKSSInfo'=KSSInfo d
    ..i NewKSSInfo="" s NewKSSInfo="+" ;特殊处理,更新程序不处理空
    ..s parr=DAACID_"&&&"_NewKSSNum_"&"_NewKSSInfo
    ..s rtn=##Class(User.DHCAntAdmCombinedInfo).Save(parr)
    ..s i=i+1
    q i
}

/// 检查当前医嘱是否是预停医嘱
/// FIX QP 2018/01/31
/// return :默认为0 : 医嘱未停止
///               1 : 预停医嘱且医嘱的停止时间未到。
///               2 : 医嘱停止时间小于现在时间
/// w ##class(DHCAnt.KSS.Combined).CheckOrderP("650||164")
ClassMethod CheckOrderP(oeori, InHosp = "")
{
	n (oeori, InHosp,%session)
    q:+$g(oeori)=0 2
    s rtn=0
    i InHosp="" {
	    i $d(%session) {
		    s InHosp=%session.Get("LOGON.HOSPID")
		} else {
			s admid=$p(^OEORD(+oeori),"^",1)
			s admLoc=$p(^PAADM(admid),"^",4)
			s InHosp=$p(^CTLOC(admLoc),"^",22)
		}
	}
	q:InHosp="" 2
    s orderStatus=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",13)
    s statusCode=$p(^OEC("OSTAT",orderStatus),"^",1)
    s xDate=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",34)   //退医嘱日期
    s xTime=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),2),"^",15)    //退医嘱时间
    s EDate=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),9),"^",9)    //预停医嘱日期
    s ETime=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),9),"^",10)    //预停医嘱时间
    ;s LongOrderId=$o(^OECPR(0,"Code","S",""))
    ;s LongOrderId=^DAACI("Priority")
    s DAACIPriority=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("OETYPE",InHosp)
    s OrderPrior=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",8)
    q:(","_DAACIPriority_",")'[(","_OrderPrior_",") 0
    if (statusCode="D")||(statusCode="C")||(statusCode="U") s rtn=2	//医嘱停止
    if (EDate'="") {
        if (EDate>+$h)||((EDate=+$h)&&(ETime>$p($h,",",2))) {
            s rtn=1
        }else{
            s rtn=2
            }
    }
    Q rtn
}

/// w ##class(DHCAnt.KSS.Combined).GetDaupPriorInfo(2390368,"2382038||312")
ClassMethod GetDaupPriorInfo(Adm, OrderItemRowid)
{
    //s ^tlsj("22")=Adm_"!"_OrderItemRowid
    n (Adm, OrderItemRowid)
    q:Adm="" ""
    q:OrderItemRowid="" ""
    q:'$d(^DAUP("ADM",Adm,OrderItemRowid)) ""
    s DaupID=$o(^DAUP("ADM",Adm,OrderItemRowid,""))
    s PriorId=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),1),"^",8) 
    s arr=DaupID_"@"_PriorId
    q arr
}

/// CTOR: QP
/// DATE: 2017-08-03
/// DESC: 处理长期自备药
/// IN  : 123@5@OM  
/// w ##class(DHCAnt.KSS.Combined).FilterOMSTOrder("123@5@OM")
ClassMethod FilterOMSTOrder(DAUPList, InHosp = "")
{
    n (DAUPList,InHosp,%session)
    i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
    ;处理长期自备药Quinn
    s SORD=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("SORD")
    s OMSTORD=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("OMSTORD")
    s buildInfo=""
    s l=$l(DAUPList,"^")
    f j=1:1:l d
    .s curInfo=$p(DAUPList,"^",j)
    .s aimId=$p(curInfo,"@",1)
    .s ordType=$p(curInfo,"@",2)
    .s ordOMDrug=$P(curInfo,"@",3)
    .s ordInstrRowID=$P(curInfo,"@",4)	;用法
    .q:ordInstrRowID=""
    .s instrDesc=$p(^PHCIN(ordInstrRowID),"^",2)
    .q:instrDesc["皮试"
    .i (ordType=SORD)&&(ordOMDrug="OM") s ordType=OMSTORD
    .i buildInfo="" s buildInfo=aimId_"@"_ordType
    .e  s buildInfo=buildInfo_"^"_aimId_"@"_ordType
	
    q buildInfo
}

}

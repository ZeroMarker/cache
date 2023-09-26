/// creator:郭宝平
/// date:2015-02-21
/// desc:医生站设置程序->用法绑定相关医嘱的设定
///      根据登录科室判断所在医院来定节点值是否包含医院ID
///   自动关联医嘱绑定:  
///        门诊绑定:  医嘱绑定 ^DHCDocConfig("InstrArcim",InstrRowId)  ,输液费标识:^DHCDocConfig("InstrInfusionFeeArcim",InstrRowId)   
/// 		   住院绑定： 医嘱绑定 ^DHCDocConfig("InstrIPArcim",InstrRowId)  ,输液费标识:^DHCDocConfig("InstrIPInfusionFeeArcim",InstrRowId) 
///   手动选择关联医嘱绑定:  
///        门诊绑定:  医嘱绑定 ^DHCDocConfig("InstrArcimSel",InstrRowId)  
/// 		   住院绑定： 医嘱绑定 ^DHCDocConfig("InstrIPArcimSel",InstrRowId)      
Class DHCDoc.DHCDocConfig.InstrArcim Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：      郭宝平
/// CreatDate：    2015-03-03
/// Description:： 查询用法    
/// Input：         无
/// Output：        
/// Return：       
Query FindInstr(InstrAlias As %String, AppendedInstrFlag As %String = "", LogonWard As %String = "") As %Query(ROWSPEC = "InstrRowID:%String,InstrDesc:%String")
{
}

ClassMethod FindInstrExecute(ByRef qHandle As %Binary, InstrAlias As %String, AppendedInstrFlag As %String = "", LogonWard As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindInstr","wy")
	s ^TMP("FindInstr")=InstrAlias
	s InstrAlias=$$ALPHAUP^SSUTIL4(InstrAlias)
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set langid=..%LanguageID()
    s InstrRowStrByAlias=##class(web.DHCBL.BDP.BDPAlias).GetDataStrByAlias("PHC_Instruc",InstrAlias)		
 	s PHCINDesc="" f  s PHCINDesc=$o(^PHCIN(0,"Desc1",PHCINDesc)) q:(PHCINDesc="")  d
 	.s PHCINRowId="" f  s PHCINRowId=$o(^PHCIN(0,"Desc1",PHCINDesc,PHCINRowId)) q:(PHCINRowId="")  d
	..q:'$D(^PHCIN(PHCINRowId))
	..s InstrCode=$p(^PHCIN(PHCINRowId),"^",1)
	..s InstrDesc=$p(^PHCIN(PHCINRowId),"^",2)
	..s InstrDesc2=$p(^PHCIN(PHCINRowId),"^",3)
	..s InstrActive=$p(^PHCIN(PHCINRowId),"^",4)
	..Q:InstrActive'="Y"
	..q:InstrDesc2["饮片"
	..Q:(InstrAlias'="")&&((("^"_InstrRowStrByAlias_"^")'[("^"_PHCINRowId_"^")))&&($$ALPHAUP^SSUTIL4(InstrCode)'[InstrAlias)&&($$ALPHAUP^SSUTIL4(InstrDesc)'[InstrAlias)&&($$ALPHAUP^SSUTIL4(InstrDesc2)'[InstrAlias)
	..//病区绑定医嘱设置,可查询已进行绑定的用法列表
	..//Q:(AppendedInstrFlag="on")&&(LogonWard'="")&&('$d(^DHCDocConfig("InstrArcimWard",LogonWard,PHCINRowId)))
	..Q:(AppendedInstrFlag="on")&&(LogonWard'="")&&('$d(^User.DHCDocInstrArcimWardI("AddItemArcimDR","I",LogonWard,PHCINRowId)))
	..s InstrCode=##class(User.PHCInstruc).GetTranByDesc("PHCINCode",InstrCode,langid)
	..s InstrDesc=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",InstrDesc,langid)
	..; renyx 取消用法code的显示
	..//s InstrDesc=InstrCode_"-"_InstrDesc
	..s InstrDesc=..TR(InstrDesc)	
	..s InstrDesc=..EvalJSON(InstrDesc)	
	..Do OutputRowFindInstr
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindInstr
	set Data=$lb($g(PHCINRowId),$g(InstrDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindInstrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInstrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrExecute ]
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

ClassMethod EvalJSON(instr As %String) As %String
{
	;w ##class(DHCBILLConfig.DHCBILLFIND).EvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr = ..Replace(mystr,"\", "\\")
	
	s mystr = ..Replace(mystr,"'", "\'")
	
	s mystr = ..Replace(mystr,$c(13), "")
	
	s mystr = ..Replace(mystr,$c(10), "")
	
	q mystr
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

/// 处理数据的不可见字符，ASCii表中前33位是不可见字符
/// Ext 前台在处理含不可见字符的jason数据时处理不了，查询不会显示数据，不会报错。
ClassMethod TR(Info)
{
	Quit:Info="" ""
	For i=0:1:32 Do
	.Set Info=$tr(Info,$c(i),"")
	.For j=0:1:32 Do
	..Set Info=$tr(Info,$c(i,j),"")
	
	Quit Info
}

/// 查询所有医嘱项目
Query FindAllItem() As %Query(ROWSPEC = "ArcimRowID:%String,ArcimDesc:%String")
{
}

ClassMethod FindAllItemExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureAppConfig","FindAllItem")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	Set langid=..%LanguageID()
	s ArcimMaster=""  for  set ArcimMaster=$o(^ARCIM(ArcimMaster)) q:ArcimMaster=""  d
	.s ArcimChild=""  for  set ArcimChild=$o(^ARCIM(ArcimMaster,ArcimChild)) q:ArcimChild=""  d
	..q:'$d(^ARCIM(ArcimMaster,ArcimChild))
	..s ArcimDesc=$P($g(^ARCIM(ArcimMaster,ArcimChild,1)),"^",2)
	..s ArcimDesc=..TR(ArcimDesc)	
	..s ArcimDesc=..EvalJSON(ArcimDesc)
	..s ArcimID=ArcimMaster_"||"_ArcimChild
	..s ArcAlias=$o(^ARC("ALIAS",0,"ARCIM",ArcimID,""))
	..s:ArcAlias'="" ArcAlias=$p(^ARC("ALIAS",ArcAlias),"^",6)
	..s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
	..s:ArcAlias'="" ArcimDesc=ArcAlias_"-"_ArcimDesc
	.d OutputRowFindAllItem
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindAllItem
	Set Data=$lb(ArcimID,ArcimDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindAllItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAllItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllItemExecute ]
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

Query FindOPInstrArcim(InstrRowId As %String, Hospital As %String) As %Query(ROWSPEC = "InstrArcimId:%String,ARCIMDesc:%String,ByDay:%String,InfusionFeeFlag:%String,LocDesc:%String,LocDr:%String,Qty:%String,RecLocDr:%String,RecLocDesc:%String,ageFrom:%String,ageTo:%String,OnlyGroupOrdBind:%String")
{
}

ClassMethod FindOPInstrArcimExecute(ByRef qHandle As %Binary, InstrRowId As %String, Hospital As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindOPInstrArcim",8)
	Set repid=$I(^CacheTemp)
    Set ind=1
    if InstrRowId="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    s:Hospital'="" InstrRowId=InstrRowId_"||"_Hospital
    b ;绑定的材料设置
    s AppendItemStr=$g(^DHCDocConfig("InstrArcim",InstrRowId))
    if AppendItemStr="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    for count=1:1:$l(AppendItemStr,"^")  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .q:ArcimRowid=""
    .Q:'$D(^ARCIM(+ArcimRowid))
    .;按天
    .s ByDay=$p($p(AppendItemStr,"^",count),"!",2)
    .s ByDay=$case(ByDay,1:"Y",:"")
    .;输液费标识
    .s InfusionFeeFlag=$p($p(AppendItemStr,"^",count),"!",3)
    .s InfusionFeeFlag=$case(InfusionFeeFlag,1:"Y",:"")
	.s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	.s ArcimDesc=..TR(ArcimDesc)	
	.s ArcimDesc=..EvalJSON(ArcimDesc)
	.s LocDesc=""
    .s LocID=$p($p(AppendItemStr,"^",count),"!",4)
    .i LocID'="" s LocDesc=$p(^CTLOC(LocID),"^",2)
    .s Qty=$p($p(AppendItemStr,"^",count),"!",5)
    .s RecLocDr=$p($p(AppendItemStr,"^",count),"!",6)
    .s RecLocDesc=""
    .i +RecLocDr'=0 s RecLocDesc=$p(^CTLOC(RecLocDr),"^",2)
	.s InstrArcimId=InstrRowId_"&"_ArcimRowid_"&"_LocID
	.s ageFrom=$p($p(AppendItemStr,"^",count),"!",7)
	.s ageTo=$p($p(AppendItemStr,"^",count),"!",8)
	.s OnlyGroupOrdBind=$p($p(AppendItemStr,"^",count),"!",9)
	.s OnlyGroupOrdBind=$case(OnlyGroupOrdBind,1:"Y",:"")
	.Do OutputRowFindOPInstrArcim
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindOPInstrArcim
	set Data=$lb($g(InstrArcimId),$g(ArcimDesc),$g(ByDay),$g(InfusionFeeFlag),LocDesc,LocID,Qty,RecLocDr,RecLocDesc,ageFrom,ageTo,OnlyGroupOrdBind)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOPInstrArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOPInstrArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOPInstrArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOPInstrArcimExecute ]
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

ClassMethod SaveOPInstrArcim(InstrRowId As %String, ArcimId As %String, ByDay As %String, InfusionFeeFlag As %String, LocRowId As %String, curEditRow As %String, UseLocRowId As %String, Qty As %String, RecLocID As %String = "", ageFrom As %String = "", ageTo As %String = "", OnlyGroupOrdBind As %String = "") As %String
{
	q:(InstrRowId="")||(ArcimId="") 100
	s ^tempslc("SaveOPInstrArcim")=InstrRowId_","_ArcimId_","_ByDay_","_InfusionFeeFlag_","_LocRowId_","_curEditRow_","_UseLocRowId
    if '$D(^ARCIM($P(ArcimId,"||",1))){
		q "-2"
	}
	s AppendItemStr=$g(^DHCDocConfig("InstrArcim",InstrRowId))
	s FindFlag=0
	for count=1:1:$l(AppendItemStr,"^") q:FindFlag=1  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .s InstrLocRowId=$p($p(AppendItemStr,"^",count),"!",4)
    .q:ArcimRowid=""
    .q:(curEditRow'="")&&(count=(curEditRow+1))
    .i (ArcimId=ArcimRowid)&&(InstrLocRowId=UseLocRowId) s FindFlag=1 q
    ;已经做过设置,不能添加
    Q:FindFlag=1 101
	if (curEditRow=""){ //新增
        if AppendItemStr="" s AppendItemStr=ArcimId_"!"_ByDay_"!"_InfusionFeeFlag_"!"_UseLocRowId_"!"_Qty_"!"_RecLocID _"!"_ageFrom _"!"_ageTo _"!"_OnlyGroupOrdBind
        else  s AppendItemStr=AppendItemStr_"^"_ArcimId_"!"_ByDay_"!"_InfusionFeeFlag_"!"_UseLocRowId_"!"_Qty_"!"_RecLocID _"!"_ageFrom _"!"_ageTo _"!"_OnlyGroupOrdBind
    }else{
	    s curEditRow=curEditRow+1
	    s $p(AppendItemStr,"^",curEditRow)=ArcimId_"!"_ByDay_"!"_InfusionFeeFlag_"!"_UseLocRowId_"!"_Qty_"!"_RecLocID _"!"_ageFrom _"!"_ageTo _"!"_OnlyGroupOrdBind
	}
    s ^DHCDocConfig("InstrArcim",InstrRowId)=AppendItemStr
    ;按当次输液最大次数收输液费(输液次数必须) 设置
    s InfusionFeeStr=$g(^DHCDocConfig("InstrInfusionFeeArcim",InstrRowId))
    if InfusionFeeStr=""  s InfusionFeeStr=ArcimId
    else  s InfusionFeeStr=InfusionFeeStr_"^"_ArcimId
    s ^DHCDocConfig("InstrInfusionFeeArcim",InstrRowId)=InfusionFeeStr
    Q 0
}

/// w ##class(DHCDoc.DHCDocConfig.InstrArcim).DeleteOPInstrArcim("97||2&524||1")
ClassMethod DeleteOPInstrArcim(InstrArcimId As %String) As %String
{
	q:(InstrArcimId="") 100
	s InstrRowId=$p(InstrArcimId,"&")
	s ArcimId=$p(InstrArcimId,"&",2)
	s LocRowId=$p(InstrArcimId,"&",3)
	s AppendItemStr=$g(^DHCDocConfig("InstrArcim",InstrRowId))
	s InfusionFeeStr=$g(^DHCDocConfig("InstrInfusionFeeArcim",InstrRowId))
	s NewAppendItemStr="",NewInfusionFeeStr=""
	for count=1:1:$l(AppendItemStr,"^")  d
    .s AppendItem=$p(AppendItemStr,"^",count)
    .s ArcimRowid=$p(AppendItem,"!")
    .s InstrLocRowId=$p(AppendItem,"!",4)
    .q:ArcimRowid=""
    .//q:ArcimId=ArcimRowid
    .q:(ArcimId=ArcimRowid)&&(InstrLocRowId=LocRowId)
    .if NewAppendItemStr="" s NewAppendItemStr=AppendItem
    .else  s NewAppendItemStr=NewAppendItemStr_"^"_AppendItem
    .if NewInfusionFeeStr="" s NewInfusionFeeStr=ArcimRowid
    .else  s NewInfusionFeeStr=NewInfusionFeeStr_"^"_ArcimRowid
    s ^DHCDocConfig("InstrArcim",InstrRowId)=NewAppendItemStr
    s ^DHCDocConfig("InstrInfusionFeeArcim",InstrRowId)=InfusionFeeStr
    q 0
}

Query FindIPInstrArcim(InstrRowId As %String, Hospital As %String) As %Query(ROWSPEC = "InstrArcimId:%String,ARCIMDesc:%String,ByDay:%String,InfusionFeeFlag:%String,LocDesc:%String,LocDr:%String,Qty:%String,RecLocDr:%String,RecLocDesc:%String,ageFrom:%String,ageTo:%String,OnlyGroupOrdBind:%String")
{
}

ClassMethod FindIPInstrArcimExecute(ByRef qHandle As %Binary, InstrRowId As %String, Hospital As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindIPInstrArcim",8)
	Set repid=$I(^CacheTemp)
    Set ind=1
    if InstrRowId="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    //Set HospitalId=""
    //Set:LocRowId'="" HospitalId=$p($G(^CTLOC(LocRowId)),"^",22)
    //s:HospitalId'="" InstrRowId=InstrRowId_"||"_HospitalId
    s:Hospital'="" InstrRowId=InstrRowId_"||"_Hospital
    b ;绑定的材料设置
    s AppendItemStr=$g(^DHCDocConfig("InstrIPArcim",InstrRowId))
    if AppendItemStr="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    for count=1:1:$l(AppendItemStr,"^")  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .q:ArcimRowid=""
    .Q:'$D(^ARCIM(+ArcimRowid))
    .;按天
    .s ByDay=$p($p(AppendItemStr,"^",count),"!",2)
    .s ByDay=$case(ByDay,1:"Y",:"")
    .;输液费标识
    .s InfusionFeeFlag=$p($p(AppendItemStr,"^",count),"!",3)
    .s InfusionFeeFlag=$case(InfusionFeeFlag,1:"Y",:"")
    .s LocDesc=""
    .s LocID=$p($p(AppendItemStr,"^",count),"!",4)
    .i LocID'="" s LocDesc=$p(^CTLOC(LocID),"^",2)
    .s Qty=$p($p(AppendItemStr,"^",count),"!",5)
    .s RecLocDr=$p($p(AppendItemStr,"^",count),"!",6)
    .s RecLocDesc=""
    .i +RecLocDr'=0 s RecLocDesc=$p(^CTLOC(RecLocDr),"^",2)
	.s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	.s ArcimDesc=..TR(ArcimDesc)	
	.s ArcimDesc=..EvalJSON(ArcimDesc)
	.//ageFrom _"!"_ageTo _"!"_OnlyGroupOrdBind
	.s ageFrom=$p($p(AppendItemStr,"^",count),"!",7)
	.s ageTo=$p($p(AppendItemStr,"^",count),"!",8)
	.s OnlyGroupOrdBind=$p($p(AppendItemStr,"^",count),"!",9)
	.s OnlyGroupOrdBind=$case(OnlyGroupOrdBind,1:"Y",:"")
	.s InstrArcimId=InstrRowId_"&"_ArcimRowid_"&"_LocID	
	.Do OutputRowFindIPInstrArcim
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindIPInstrArcim
	set Data=$lb($g(InstrArcimId),$g(ArcimDesc),$g(ByDay),$g(InfusionFeeFlag),LocDesc,LocID,Qty,RecLocDr,RecLocDesc,ageFrom,ageTo,OnlyGroupOrdBind)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindIPInstrArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIPInstrArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindIPInstrArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIPInstrArcimExecute ]
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

/// 住院自动关联医嘱
/// 1. 保存关联医嘱
/// w ##class(DHCDoc.DHCDocConfig.InstrArcim).SaveIPInstrArcim()
ClassMethod SaveIPInstrArcim(InstrRowId As %String, ArcimId As %String, ByDay As %String, InfusionFeeFlag As %String, LocRowId As %String, curEditRow As %String, UseLocRowId As %String, Qty As %String, RecLocID As %String = "", ageFrom As %String = "", ageTo As %String = "", OnlyGroupOrdBind As %String = "") As %String
{
	q:(InstrRowId="")||(ArcimId="") 100
    if '$D(^ARCIM($P(ArcimId,"||",1))){
		q "-2"
	}
	s AppendItemStr=$g(^DHCDocConfig("InstrIPArcim",InstrRowId))
	s FindFlag=0
	for count=1:1:$l(AppendItemStr,"^") q:FindFlag=1  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .s InstrLocRowId=$p($p(AppendItemStr,"^",count),"!",4)
    .q:ArcimRowid=""
    .q:(curEditRow'="")&&(count=(curEditRow+1))
    .i (ArcimId=ArcimRowid)&&(InstrLocRowId=UseLocRowId) s FindFlag=1 q
    ;已经做过设置,不能添加
    Q:FindFlag=1 101
	if (curEditRow=""){
	    if AppendItemStr="" s AppendItemStr=ArcimId_"!"_ByDay_"!"_InfusionFeeFlag_"!"_UseLocRowId_"!"_Qty_"!"_RecLocID_"!"_ageFrom _"!"_ageTo _"!"_OnlyGroupOrdBind
	    else  s AppendItemStr=AppendItemStr_"^"_ArcimId_"!"_ByDay_"!"_InfusionFeeFlag_"!"_UseLocRowId_"!"_Qty_"!"_RecLocID_"!"_ageFrom _"!"_ageTo _"!"_OnlyGroupOrdBind
    }else{
	    s curEditRow=curEditRow+1
	    s $p(AppendItemStr,"^",curEditRow)=ArcimId_"!"_ByDay_"!"_InfusionFeeFlag_"!"_UseLocRowId_"!"_Qty_"!"_RecLocID_"!"_ageFrom _"!"_ageTo _"!"_OnlyGroupOrdBind
	}
    s ^DHCDocConfig("InstrIPArcim",InstrRowId)=AppendItemStr
    ;按当次输液最大次数收输液费(输液次数必须) 设置
    s InfusionFeeStr=$g(^DHCDocConfig("InstrIPInfusionFeeArcim",InstrRowId))
    if InfusionFeeStr=""  s InfusionFeeStr=ArcimId
    else  s InfusionFeeStr=InfusionFeeStr_"^"_ArcimId
    s ^DHCDocConfig("InstrIPInfusionFeeArcim",InstrRowId)=InfusionFeeStr
    Q 0
}

/// 2.删除关联医嘱
/// w ##class(DHCDoc.DHCDocConfig.InstrArcim).DeleteIPInstrArcim("47&6||1")
ClassMethod DeleteIPInstrArcim(InstrArcimId As %String) As %String
{
	q:(InstrArcimId="") 100
	s InstrRowId=$p(InstrArcimId,"&")
	s ArcimId=$p(InstrArcimId,"&",2)
	s LocRowId=$p(InstrArcimId,"&",3)
	s AppendItemStr=$g(^DHCDocConfig("InstrIPArcim",InstrRowId))
	s InfusionFeeStr=$g(^DHCDocConfig("InstrIPInfusionFeeArcim",InstrRowId))
	s NewAppendItemStr="",NewInfusionFeeStr=""
	for count=1:1:$l(AppendItemStr,"^")  d
    .s AppendItem=$p(AppendItemStr,"^",count)
    .s ArcimRowid=$p(AppendItem,"!")
    .s InstrLocRowId=$p(AppendItem,"!",4)
    .q:ArcimRowid=""
    .//q:ArcimId=ArcimRowid
    .q:(ArcimId=ArcimRowid)&&(InstrLocRowId=LocRowId)
    .if NewAppendItemStr="" s NewAppendItemStr=AppendItem
    .else  s NewAppendItemStr=NewAppendItemStr_"^"_AppendItem
    .if NewInfusionFeeStr="" s NewInfusionFeeStr=ArcimRowid
    .else  s NewInfusionFeeStr=NewInfusionFeeStr_"^"_ArcimRowid
    
    s ^DHCDocConfig("InstrIPArcim",InstrRowId)=NewAppendItemStr
    s ^DHCDocConfig("InstrIPInfusionFeeArcim",InstrRowId)=InfusionFeeStr
    q 0
}

Query FindOPInstrArcimSel(InstrRowId As %String, HospitalId As %String) As %Query(ROWSPEC = "InstrArcimId:%String,ARCIMDesc:%String,LocDesc:%String,LocDr:%String")
{
}

ClassMethod FindOPInstrArcimSelExecute(ByRef qHandle As %Binary, InstrRowId As %String, HospitalId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindOPInstrArcimSel",8)
	Set repid=$I(^CacheTemp)
    Set ind=1
    if InstrRowId="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    s:HospitalId'="" InstrRowId=InstrRowId_"||"_HospitalId
    s AppendItemStr=$g(^DHCDocConfig("InstrArcimSel",InstrRowId))
    if AppendItemStr="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    for count=1:1:$l(AppendItemStr,"^")  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!",1)
    .q:ArcimRowid=""
    .Q:'$D(^ARCIM(+ArcimRowid))
	.s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	.s ArcimDesc=..TR(ArcimDesc)	
	.s ArcimDesc=..EvalJSON(ArcimDesc)
	.s LocDesc=""
    .s LocID=$p($p(AppendItemStr,"^",count),"!",2)
    .i LocID'="" s LocDesc=$p(^CTLOC(LocID),"^",2)
	.s InstrArcimId=InstrRowId_"&"_ArcimRowid_"&"_LocID
	.Do OutputRowFindOPInstrArcimSel
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindOPInstrArcimSel
	set Data=$lb($g(InstrArcimId),$g(ArcimDesc),LocDesc,LocID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOPInstrArcimSelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOPInstrArcimSelExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOPInstrArcimSelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOPInstrArcimSelExecute ]
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

/// 住院自动关联医嘱
/// 1. 保存关联医嘱
/// w ##class(DHCDoc.DHCDocConfig.InstrArcim).SaveIPInstrArcim(50,"1811||1",2,0,2)
ClassMethod SaveOPInstrArcimSel(InstrRowId As %String, ArcimId As %String, LocRowId As %String, curEditRow As %String, UseLocRowId As %String) As %String
{
	q:(InstrRowId="")||(ArcimId="") 100
	//Set HospitalId=""
    //Set:LocRowId'="" HospitalId=$p($G(^CTLOC(LocRowId)),"^",22)
    //s:HospitalId'="" InstrRowId=InstrRowId_"||"_HospitalId
    if '$D(^ARCIM($P(ArcimId,"||",1))){
		q "-2"
	}
	s AppendItemStr=$g(^DHCDocConfig("InstrArcimSel",InstrRowId))
	s FindFlag=0
	for count=1:1:$l(AppendItemStr,"^") q:FindFlag=1  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .s InstrLocRowId=$p($p(AppendItemStr,"^",count),"!",2)
    .q:ArcimRowid=""
    .q:(curEditRow'="")&&(count=(curEditRow+1))
    .//if ((ArcimId=ArcimRowid)&&(InstrLocRowId="")&&(UseLocRowId=""))||((ArcimId=ArcimRowid)&&(InstrLocRowId'="")&&(InstrLocRowId=UseLocRowId))  s FindFlag=1 q
    .i (ArcimId=ArcimRowid)&&(InstrLocRowId=UseLocRowId) s FindFlag=1 q
    b //90
    ;已经做过设置,不能添加
    Q:FindFlag=1 101
	if (curEditRow=""){
	    if AppendItemStr="" s AppendItemStr=ArcimId_"!"_UseLocRowId
	    else  s AppendItemStr=AppendItemStr_"^"_ArcimId_"!"_UseLocRowId
    }else{
	    s curEditRow=curEditRow+1
	    s $p(AppendItemStr,"^",curEditRow)=ArcimId_"!"_UseLocRowId
	}
	/*for count=1:1:$l(AppendItemStr,"^") q:FindFlag=1  d
    .s ArcimRowid=$p(AppendItemStr,"^",count)
    .q:ArcimRowid=""
    .if ArcimId=ArcimRowid  s FindFlag=1 q
    ;已经做过设置,不能添加
    Q:FindFlag=1 101
    if AppendItemStr="" s AppendItemStr=ArcimId
    else  s AppendItemStr=AppendItemStr_"^"_ArcimId*/
    s ^DHCDocConfig("InstrArcimSel",InstrRowId)=AppendItemStr
    Q 0
}

/// 2.删除关联医嘱
/// w ##class(DHCDoc.DHCDocConfig.InstrArcim).DeleteIPInstrArcimSel("47&6||1")
ClassMethod DeleteOPInstrArcimSel(InstrArcimId As %String) As %String
{
	q:(InstrArcimId="") 100
	s InstrRowId=$p(InstrArcimId,"&")
	s ArcimId=$p(InstrArcimId,"&",2)
	s LocRowId=$p(InstrArcimId,"&",3)
	s AppendItemStr=$g(^DHCDocConfig("InstrArcimSel",InstrRowId))
	s NewAppendItemStr=""
	for count=1:1:$l(AppendItemStr,"^")  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!",1)
    .q:ArcimRowid=""
    .s InstrLocRowId=$p($p(AppendItemStr,"^",count),"!",2)
    .q:(ArcimId=ArcimRowid)&&(InstrLocRowId=LocRowId)
    .if NewAppendItemStr="" s NewAppendItemStr=ArcimRowid_"!"_InstrLocRowId
    .else  s NewAppendItemStr=NewAppendItemStr_"^"_ArcimRowid_"!"_InstrLocRowId
    s ^DHCDocConfig("InstrArcimSel",InstrRowId)=NewAppendItemStr
    q 0
}

Query FindIPInstrArcimSel(InstrRowId As %String, HospitalId As %String) As %Query(ROWSPEC = "InstrArcimId:%String,ARCIMDesc:%String,LocDesc:%String,LocDr:%String")
{
}

ClassMethod FindIPInstrArcimSelExecute(ByRef qHandle As %Binary, InstrRowId As %String, HospitalId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindIPInstrArcimSel",8)
	Set repid=$I(^CacheTemp)
    Set ind=1
    if InstrRowId="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    s:HospitalId'="" InstrRowId=InstrRowId_"||"_HospitalId
    s AppendItemStr=$g(^DHCDocConfig("InstrIPArcimSel",InstrRowId))
    if AppendItemStr="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    for count=1:1:$l(AppendItemStr,"^")  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .q:ArcimRowid=""
    .Q:'$D(^ARCIM(+ArcimRowid))
	.s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	.s ArcimDesc=..TR(ArcimDesc)	
	.s ArcimDesc=..EvalJSON(ArcimDesc)
	.s LocDesc=""
    .s LocID=$p($p(AppendItemStr,"^",count),"!",2)
    .i LocID'="" s LocDesc=$p(^CTLOC(LocID),"^",2)
	.s InstrArcimId=InstrRowId_"&"_ArcimRowid_"&"_LocID
	.Do OutputRowFindIPInstrArcimSel
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindIPInstrArcimSel
	set Data=$lb($g(InstrArcimId),$g(ArcimDesc),LocDesc,LocID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindIPInstrArcimSelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIPInstrArcimSelExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindIPInstrArcimSelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIPInstrArcimSelExecute ]
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

ClassMethod SaveIPInstrArcimSel(InstrRowId As %String, ArcimId As %String, LocRowId As %String, curEditRow As %String, UseLocRowId As %String) As %String
{
	q:(InstrRowId="")||(ArcimId="") 100
	//Set HospitalId=""
    //Set:LocRowId'="" HospitalId=$p($G(^CTLOC(LocRowId)),"^",22)
    //s:HospitalId'="" InstrRowId=InstrRowId_"||"_HospitalId
    if '$D(^ARCIM($P(ArcimId,"||",1))){
		q "-2"
	}
	s AppendItemStr=$g(^DHCDocConfig("InstrIPArcimSel",InstrRowId))
	s FindFlag=0
	for count=1:1:$l(AppendItemStr,"^") q:FindFlag=1  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .s InstrLocRowId=$p($p(AppendItemStr,"^",count),"!",2)
    .q:ArcimRowid=""
    .q:(curEditRow'="")&&(count=(curEditRow+1))
    .//if ((ArcimId=ArcimRowid)&&(InstrLocRowId="")&&(UseLocRowId=""))||((ArcimId=ArcimRowid)&&(InstrLocRowId'="")&&(InstrLocRowId=UseLocRowId))  s FindFlag=1 q
    .i (ArcimId=ArcimRowid)&&(InstrLocRowId=UseLocRowId) s FindFlag=1 q

    ;已经做过设置,不能添加
    Q:FindFlag=1 101
	if (curEditRow=""){
	    if AppendItemStr="" s AppendItemStr=ArcimId_"!"_UseLocRowId
	    else  s AppendItemStr=AppendItemStr_"^"_ArcimId_"!"_UseLocRowId
    }else{
	    s curEditRow=curEditRow+1
	    s $p(AppendItemStr,"^",curEditRow)=ArcimId_"!"_UseLocRowId
	}
	/*for count=1:1:$l(AppendItemStr,"^") q:FindFlag=1  d
    .s ArcimRowid=$p(AppendItemStr,"^",count)
    .q:ArcimRowid=""
    .if ArcimId=ArcimRowid  s FindFlag=1 q
    ;已经做过设置,不能添加
    Q:FindFlag=1 101
    if AppendItemStr="" s AppendItemStr=ArcimId
    else  s AppendItemStr=AppendItemStr_"^"_ArcimId*/
    s ^DHCDocConfig("InstrIPArcimSel",InstrRowId)=AppendItemStr
    Q 0
}

ClassMethod DeleteIPInstrArcimSel(InstrArcimId As %String) As %String
{
	q:(InstrArcimId="") 100
	s InstrRowId=$p(InstrArcimId,"&")
	s ArcimId=$p(InstrArcimId,"&",2)
	s LocRowId=$p(InstrArcimId,"&",3)
	s AppendItemStr=$g(^DHCDocConfig("InstrIPArcimSel",InstrRowId))
	s NewAppendItemStr=""
	for count=1:1:$l(AppendItemStr,"^")  d
    .s ArcimRowid=$p($p(AppendItemStr,"^",count),"!")
    .q:ArcimRowid=""
    .s InstrLocRowId=$p($p(AppendItemStr,"^",count),"!",2)
    .q:(ArcimId=ArcimRowid)&&(InstrLocRowId=LocRowId)
    .if NewAppendItemStr="" s NewAppendItemStr=ArcimRowid_"!"_InstrLocRowId
    .else  s NewAppendItemStr=NewAppendItemStr_"^"_ArcimRowid_"!"_InstrLocRowId
    s ^DHCDocConfig("InstrIPArcimSel",InstrRowId)=NewAppendItemStr
    q 0
}

Query GetHos() As %Query(ROWSPEC = "HOSPRowId:%String,HOSPDesc:%String,selected:%Boolean")
{
}

ClassMethod GetHosExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","GetHos")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s HOSPRowId=0 f  s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""  d
 	.s HOSPDesc=$p(^CT("HOSP",HOSPRowId),"^",2)
 	.s selected=0
 	.i HOSPRowId=..%GetConfig("MainHospital") s selected=1 //$g(^DHCDocConfig("MainHospital"))
	.Do OutputRowGetHos
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetHos
	set Data=$lb($g(HOSPRowId),$g(HOSPDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetHosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHosExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHosExecute ]
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

/// w ##Class(DHCDoc.DHCDocConfig.InstrArcim).SaveArcimWardList("Instr",12,"114^1483||1^2^3^Y^^2^^1^N^^^4506||1^2","",1)
ClassMethod SaveArcimWardList(SaveQueryName As %String, SaveQueryID As %String, SaveInfo As %String, Index As %String, UserID As %String = "") As %String
{
	s ^tempscl("SaveArcimWardList")=SaveQueryName_","_SaveQueryID_","_SaveInfo_","_Index
	s LocId=$P(SaveInfo,"^",1)
	s ArcimId=$P(SaveInfo,"^",2)
	s AppendType=$P(SaveInfo,"^",3)
	s ExecType=$P(SaveInfo,"^",4)
	s Active=$P(SaveInfo,"^",5)
	s additionalNum=$P(SaveInfo,"^",6)
	s Qty=$P(SaveInfo,"^",7)
	s EndNum=$P(SaveInfo,"^",8)
	s ByHand=$P(SaveInfo,"^",9)
	s SingleNotFee=$P(SaveInfo,"^",10)
	s ageFrom=$P(SaveInfo,"^",11)
	s ageTo=$P(SaveInfo,"^",12)
	s InstrAddArcimId=$P(SaveInfo,"^",13)
	s AddQty=$P(SaveInfo,"^",14)
	s IsRepeatAppend=$P(SaveInfo,"^",15)
	q:(SaveQueryName="")||(SaveQueryID="")||(LocId="")||(ArcimId="")||(Qty<=0) -100
	s CTLOCType=$P(^CTLOC(LocId),"^",13)
	q:(CTLOCType'="W") -200
	s CTLocDesc=$P(^CTLOC(LocId),"^",2)
	if (UserID="") s UserID=%session.Get("LOGON.USERID")
	s SSUSRName=$p(^SSU("SSUSR",UserID),"^",2)
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocId,0))
	q:(WardID="") -300
	s SaveQueryName=$case(SaveQueryName,"Instr":"I","Arcim":"A")
	s OldDataJson="",rowid=Index,UpDateFlag="A"
	K PLIST
	s PLIST(2)=WardID
	s PLIST(3)=SaveQueryName
	s PLIST(4)=SaveQueryID
	s PLIST(5)=ArcimId
	s PLIST(6)=AppendType
	s PLIST(7)=ExecType
	s PLIST(8)=Active
	s PLIST(9)=additionalNum
	s PLIST(10)=EndNum
	s PLIST(11)=Qty
	s PLIST(12)=ByHand
	s PLIST(13)=SingleNotFee
	s PLIST(15)=ageFrom
	s PLIST(16)=ageTo
	s PLIST(17)=InstrAddArcimId
	s PLIST(18)=AddQty
	s PLIST(19)=IsRepeatAppend
	if (Index="") {
		&sql(insert into SQLUser.DHCDoc_InstrArcimWard values :PLIST())
		s rowid=$p(%ROWID,$c(1))
	}else{
		s UpDateFlag="U"
		s OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCDocInstrArcimWard"_$c(2)_rowid)
		&sql(update SQLUser.DHCDoc_InstrArcimWard values :PLIST() where ID=:Index)
	}
	if ('SQLCODE) {
		s NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCDocInstrArcimWard"_$c(2)_rowid)
		d ##class(web.DHCDocDataChangeLog).SaveLog("DHCDoc_InstrArcimWard","User.DHCDocInstrArcimWard","病区绑定医嘱设置","User.DHCDocInstrArcimWard_"_rowid,CTLocDesc_"-"_SSUSRName,UpDateFlag,NewDataJson,OldDataJson)
	}
	Q SQLCODE
}

/// w ##Class(DHCDoc.DHCDocConfig.InstrArcim).DeleteArcimWardList()
ClassMethod DeleteArcimWardList(Index As %String, LocId As %String, UserID As %String) As %String
{
	s OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCDocInstrArcimWard"_$c(2)_Index)
    &sql(delete  SQLUser.DHCDoc_InstrArcimWard where ID=:Index)
    if ('SQLCODE){
	    s NewDataJson=""
	    s CTLocDesc=$P(^CTLOC(LocId),"^",2)
		s SSUSRName=$p(^SSU("SSUSR",UserID),"^",2)
		d ##class(web.DHCDocDataChangeLog).SaveLog("DHCDoc_InstrArcimWard","User.DHCDocInstrArcimWard","病区绑定医嘱设置","User.DHCDocInstrArcimWard_"_Index,CTLocDesc_"-"_SSUSRName,"D",NewDataJson,OldDataJson)
	}
    Q SQLCODE
}

Query FindArcimWardLink(LocId As %String, queryName As %String, QueryID As %String) As %Query(ROWSPEC = "Index:%String,ARCIMDesc:%String,InstrArcimId:%String,AppendType:%String,ExecType:%String,Active:%String,additionalNum:%String,Qty:%String,EndNum:%String,ByHand:%String,SingleNotFee:%String,ageFrom:%String,ageTo:%String,InstrAddArcimId:%String,ARCIMAddDesc:%String,AddQty:%String,ManufacturerName:%String,UnitPrice:%String,IsRepeatAppend:%String")
{
}

ClassMethod FindArcimWardLinkExecute(ByRef qHandle As %Binary, LocId As %String, queryName As %String, QueryID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindArcimWardLink",114,"Instr",39)
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ^tmptan("FindArcimWardLink")=LocId_","_queryName_","_QueryID
    s CTLOCType=$P(^CTLOC(LocId),"^",13)
	s hospId = $p(^CTLOC(LocId),"^",22)
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocId,0))
    if (queryName="")||(QueryID="")||(CTLOCType'="W")||(WardID="") {
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	Set langid=..%LanguageID()
	s queryName=$case(queryName,"Instr":"I","Arcim":"A")
	s ID=0
	for {
		s ID=$o(^User.DHCDocInstrArcimWardI("AddItemArcimDR",queryName,WardID,QueryID,ID)) Q:ID=""
		s Val=$g(^User.DHCDocInstrArcimWardD(ID))
		d OutputRowFindArcimWardLink
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindArcimWardLink
	s ArcimId=$lg(Val,4)
	s ARCIMDesc=$lg(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1),"^",2)
	s AppendType=$lg(Val,5)
	s ExecType=$lg(Val,6)
	s Active=$lg(Val,7)
	s additionalNum=$lg(Val,8)
	s Qty=$lg(Val,10)
	s EndNum=$lg(Val,9)
	s ByHand=$lg(Val,11)
	s SingleNotFee=$lg(Val,12)
	i SingleNotFee="" s SingleNotFee="Y"
	s ARCIMDesc=$P(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1),"^",2)
	s ageFrom=$lg(Val,15)
	s ageTo=$lg(Val,16)
	s InstrAddArcimId=$lg(Val,17)
	s ARCIMAddDesc=""
	i InstrAddArcimId'="" s ARCIMAddDesc=$P($G(^ARCIM(+InstrAddArcimId,$P(InstrAddArcimId,"||",2),1)),"^",2)
	s AddQty=$lg(Val,18)
	s manufacturerName = ""
	s inciId = ##class(web.DHCDocOrderEntry).GetINCI(+ArcimId)
	s ordItemCatId = $p($g(^ARCIM(+ArcimId,$p(ArcimId, "||", 2),1)), "^", 10)
	s ordType = $p(^ARC("IC",ordItemCatId),"^",7)
	if (inciId '= "") {
		if (ordType = "R") {
			//s manufacturerName = ##class(web.DHCSTInterfacePH).GetManfNameByInci(inciId)
			; renyx 修改为使用新接口获取厂商，原接口已作废
			s manufacturerName = ##class(web.DHCST.Common.DrugInfoCommon).GetManf(inciId)
		}
		if (ordType = "M") {
			s manufacturerName = $p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(inciId), "^", 2)
		}
	}
	#; s unitPrice = $p(##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimId,"","","","","",hospId,""), "^", 4)
	#; s:unitPrice'="" unitPrice = $fn(unitPrice,"",4)
	s unitPrice = $p(##class(web.DHCDocOrderEntry).GetOrderPrice("","",ArcimId,"","","","","","","","^^^^"_hospId), "^", 1)
	s IsRepeatAppend=$lg(Val,19)
	i IsRepeatAppend="" s IsRepeatAppend="N"
	s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
	s ARCIMAddDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMAddDesc,langid)
	set Data=$lb(ID,ARCIMDesc,ArcimId,AppendType,ExecType,Active,additionalNum,Qty,EndNum,ByHand,SingleNotFee,ageFrom,ageTo,InstrAddArcimId,ARCIMAddDesc,AddQty,manufacturerName,unitPrice,IsRepeatAppend)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindArcimWardLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimWardLinkExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArcimWardLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimWardLinkExecute ]
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

ClassMethod GetArcimWardLinkExpInfo(LocId As %String, queryName As %String, QueryID As %String) As %String
{
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocId,0))
	s ConfigName=""
	if (queryName="Instr"){
		s ConfigName="InstrArcimWard"
	}elseif (queryName="Arcim"){
		s ConfigName="ArcimWardAdd"
	}
	if (ConfigName="")||(WardID="")||(QueryID=""){
		q ""
	}
	s SingleNotFee=$G(^DHCDocConfig(ConfigName,WardID,QueryID,"SingleNotFee"))
	s Str=SingleNotFee
	q Str
}

ClassMethod SaveArcimWardLinkExpInfo(LocId As %String, queryName As %String, QueryID As %String, SaveInfo As %String) As %String
{
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocId,0))
	s ConfigName=""
	if (queryName="Instr"){
		s ConfigName="InstrArcimWard"
	}elseif (queryName="Arcim"){
		s ConfigName="ArcimWardAdd"
	}
	if (ConfigName="")||(WardID="")||(QueryID=""){
		q "100"
	}
	s SingleNotFee=$P(SaveInfo,"^",1)
	s ^DHCDocConfig(ConfigName,WardID,QueryID,"SingleNotFee")=SingleNotFee

	s Json="0"
	q Json
}

Query FindArcimWardList(LocId As %String, ArcimAlias As %String) As %Query(ROWSPEC = "ARCIMRowID:%String,ARCICDesc:%String,ARCIMDesc:%String")
{
}

ClassMethod FindArcimWardListExecute(ByRef qHandle As %Binary, LocId As %String, ArcimAlias As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindArcimWardList",31,"wssc")
	s ^TMP("FindArcimWardList")=LocId_","_ArcimAlias
	s ArcimAlias=$$ALPHAUP^SSUTIL4(ArcimAlias)
	Set repid=$I(^CacheTemp)
    Set ind=1
    s CTLOCType=$P(^CTLOC(LocId),"^",13)
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocId,0))
    if (CTLOCType'="W")||(WardID="") {
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
 	if (ArcimAlias'=""){
	 	s ArcimMaster=""  for{
		 	set ArcimMaster=$o(^ARCIM(ArcimMaster))
		 	q:(ArcimMaster="")
		 	s ArcimChild=""  for{
			 	set ArcimChild=$o(^ARCIM(ArcimMaster,ArcimChild))
			 	q:((ArcimChild=""))
			 	continue:+ArcimChild<1
			 	s ArcimDesc=$P($g(^ARCIM(ArcimMaster,ArcimChild,1)),"^",2)
			 	s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).TR(ArcimDesc)	
				s ArcimDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).EvalJSON(ArcimDesc)
				s ARCIMRowID=ArcimMaster_"||"_ArcimChild
				continue:(##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowID)=1)
				s Find=0
				s ArcAlias=0
				for {
					s ArcAlias=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowID,ArcAlias))
					q:ArcAlias=""
					s ArcAliasD=$p(^ARC("ALIAS",ArcAlias),"^",6)
					if (($ZCVT(ArcimAlias,"U")=$E($ZCVT(ArcAliasD,"U"),1,$L($ZCVT(ArcimAlias,"U"))))){
						s Find=1
						q
					}
				}
				continue:(Find=0)
				s ARCIMDesc=ArcimDesc
				s ItemCatDr=$P(^ARCIM(ArcimMaster,ArcimChild,1),"^",10) 
				s ARCICDesc=$P(^ARC("IC",ItemCatDr),"^",2)	
				d OutputRowFindArcimWardList
		 	}
	 	}
	}else{
		s ARCIMRowID=0
		for {
			s ARCIMRowID=$O(^DHCDocConfig("ArcimWardAdd",WardID,ARCIMRowID))
			q:ARCIMRowID=""
			continue:(ARCIMRowID'["||")
			s ARCIMDesc=$P(^ARCIM(+ARCIMRowID,$P(ARCIMRowID,"||",2),1),"^",2)
			s ItemCatDr=$P(^ARCIM(+ARCIMRowID,$P(ARCIMRowID,"||",2),1),"^",10) 
			s ARCICDesc=$P(^ARC("IC",ItemCatDr),"^",2)
			d OutputRowFindArcimWardList
		}
	}
 	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindArcimWardList
	s ARCIMDesc=##class(DHCDoc.DHCDocConfig.InstrArcim).EvalJSON(ARCIMDesc)
	set Data=$lb($g(ARCIMRowID),$g(ARCICDesc),$G(ARCIMDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindArcimWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArcimWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimWardListExecute ]
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

/// Input:        EpisodeID:就诊ID   ArcimRowId:医嘱项,成组医嘱^分割  InstrRowId:用法id  QueAppendType绑定方式(1:下医嘱绑定,2:执行绑定)
/// OutPut:		  需绑定医嘱列表:
///                  医嘱项id^绑定模式(1:一天一次,2:按次,按医嘱绑定只有按天，3按最大频次，10首次，11接瓶)^起始数量(按医嘱绑定无起始数量)^数量^配置方式(1:按医嘱；2:按用法)
///                  ^仅成组医嘱绑定费用(1:是,0:全部)^截止数量(按医嘱绑定无截止数量，大于截止数量时不再绑定)^绑定方式(1自动绑定，2手工绑定)^不需要绑定的医嘱类型(^OECPR,RowID,_分割)
///                  ^除最大频次以外加收费(仅在执行绑定，按最大频次时生效)^加收费数量^绑定方式(用法绑定:I\医嘱项绑定:A)^绑定来源字典id（用法ID\医嘱项ID）
///                  $C(2)第二组需要绑定的医嘱$C(2)第三组需要绑定的医嘱$C(2)......
/// w ##Class(DHCDoc.DHCDocConfig.InstrArcim).GetArcimWardInfo(70,"1068||1",18,"1")
ClassMethod GetArcimWardInfo(EpisodeID As %String, ArcimRowId As %String, InstrRowId As %String, QueAppendType As %String, OrderOpenForAllHosp As %String = "") As %String
{
	s ArcimWardInfo=""
	s AdmHospDr=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s PatWard=$P(^PAADM(EpisodeID),"^",70)
	q:PatWard="" ""
	k ArcimWardList
	if (ArcimRowId'=""){
		s Type="A"
		for i=1:1:$Length(ArcimRowId,"^"){
			s IndexDr=$P(ArcimRowId,"^",i)
			continue:(IndexDr="")
			d LoopData
		}
		
	}
	if (InstrRowId'=""){
		s Type="I"
		s IndexDr=InstrRowId

		s ExcludeFlag="N"
		s ExcludeItemList=##Class(web.DHCDocConfig).GetConfigNode3("WardInstrArcim","ExcludeItem_"_InstrRowId,"WardId_"_PatWard,AdmHospDr)
		if (ExcludeItemList'=""){
			for i=1:1:$Length(ArcimRowId,"^"){
				s ArciimDr=$P(ArcimRowId,"^",i)
				if ("!"_ExcludeItemList_"!")[("!"_ArciimDr_"!"){
					s ExcludeFlag="Y"
				}
			}
		}
		if (ExcludeFlag="N"){
			d LoopData
		}
		
	}
	;1、一起带出的类型，不需要做逻辑判断，直接绑定
	s Type=""
	for{
		s Type=$O(ArcimWardList("Y",Type))
		q:(Type="")
		s Str=$G(ArcimWardList("Y",Type))
		if (ArcimWardInfo=""){s ArcimWardInfo=Str
		}else{s ArcimWardInfo=ArcimWardInfo_$C(2)_Str}	
	}
	;2、按医嘱项绑定的医嘱，如果不绑定任何用法绑定医嘱（不含用法N的），则进行绑定
	if ('$D(ArcimWardList("Y","I"))){
		s Str=$G(ArcimWardList("N","A"))
		if (Str'=""){
			if (ArcimWardInfo=""){s ArcimWardInfo=Str
			}else{s ArcimWardInfo=ArcimWardInfo_$C(2)_Str}	
		}
	}
	;3、按用法绑定的医嘱，如果不绑定任何医嘱绑定医嘱，则进行绑定
	if ('$D(ArcimWardList("Y","A")))&&('$D(ArcimWardList("N","A"))){
		s Str=$G(ArcimWardList("N","I"))
		if (Str'=""){
			if (ArcimWardInfo=""){s ArcimWardInfo=Str
			}else{s ArcimWardInfo=ArcimWardInfo_$C(2)_Str}	
		}
	}
	q ArcimWardInfo
LoopData
	s ID=0
	for {
		s ID=$o(^User.DHCDocInstrArcimWardI("AddItemArcimDR",Type,PatWard,IndexDr,ID)) q:ID=""
		s Val=$g(^User.DHCDocInstrArcimWardD(ID))
		d SortData
	}
	q
SortData
	s AddItemType=$lg(Val,3) //Instr-用法绑定,Arcim-医嘱绑定
	s ArcimId=$lg(Val,4)
	s AppendType=$lg(Val,5)
	q:(QueAppendType'=AppendType)
	s ExecType=$lg(Val,6)
	s Active=$lg(Val,7)
	Q:(Active'="Y")

	s datefrom=$p($g(^ARCIM(+ArcimId,1,1)),"^",13)
	s dateto=$p($g(^ARCIM(+ArcimId,1,7)),"^",1)
	i datefrom>$h q
	i dateto,dateto<$h q

	s additionalNum=$lg(Val,8)
	s Qty=$lg(Val,10)
	s EndNum=$lg(Val,9)
	s ByHand=$lg(Val,11)
	s NotLinkPriorStr=$lg(Val,13)
	s NotLinkPriorStr=$TR(NotLinkPriorStr,"^","_")
	s SingleNotFee=$lg(Val,12)
	i (SingleNotFee="")||(SingleNotFee="Y") {
		s SingleNotFee="1"
	}else{
		s SingleNotFee="0"
	}
	s ageFrom=$lg(Val,15)
	s ageTo=$lg(Val,16)
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s PatDOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
	s Age=$$CalAge^at182(PatDOB,+$H,"","","")
	s Age=$p(Age,"|",12)
	Q:(Age<ageFrom)&&(ageFrom'="")
	Q:(Age>ageTo)&&(ageTo'="")
	s InstrAddArcimId=$lg(Val,17)
	s AddQty=$lg(Val,18)
	s IsRepeatAppend=$lg(Val,19)
	i IsRepeatAppend="" s IsRepeatAppend="N"

	
	s AppendOrdType=QueAppendType
	s Str=ArcimId_"^"_ExecType_"^"_additionalNum_"^"_Qty_"^"_AppendOrdType
	s Str=Str_"^"_SingleNotFee_"^"_EndNum_"^"_ByHand_"^"_NotLinkPriorStr_"^"_OrderOpenForAllHosp
	s Str=Str_"^"_InstrAddArcimId_"^"_AddQty_"^"_AddItemType_"^"_Type_"^"_IndexDr
	
	if ($G(ArcimWardList(IsRepeatAppend,Type))=""){
		s ArcimWardList(IsRepeatAppend,Type)=Str
	}else{
		s ArcimWardList(IsRepeatAppend,Type)=ArcimWardList(IsRepeatAppend,Type)_$C(2)_Str
	}
	
	Q
}

// w ##class(DHCDoc.DHCDocConfig.InstrArcim).CheckInstrAppendItemStr("3790||1!0!0!^3795||1!0!0!110^3790||1!0!0!110",110)

ClassMethod CheckInstrAppendItemStr(AppendItemStr As %String, UserLoc As %String, Type As %String = "") As %String
{
	Q:AppendItemStr="" ""
	s UserLocAppendItemStr="",AllLocAppendItemStr=""
	for i=1:1:$L(AppendItemStr,"^") {
		Set AppendItemNod=$p(AppendItemStr,"^",i)
		if (Type="NURADD"){
			Set InstrLocRowId=$P(AppendItemNod,"!",2)
		}else{
			Set InstrLocRowId=$P(AppendItemNod,"!",4)
		}
		
		if (InstrLocRowId=UserLoc){
			i UserLocAppendItemStr="" s UserLocAppendItemStr=AppendItemNod
			e  s UserLocAppendItemStr=UserLocAppendItemStr_"^"_AppendItemNod
		}else{
			if (InstrLocRowId=""){
				i AllLocAppendItemStr="" s AllLocAppendItemStr=AppendItemNod
				e  s AllLocAppendItemStr=AllLocAppendItemStr_"^"_AppendItemNod
			}
		}
	}
	Q:UserLocAppendItemStr'="" UserLocAppendItemStr
	Q AllLocAppendItemStr
}

Query FindInstrArcimBPrior(LocId As %String, Index As %String) As %Query(ROWSPEC = "OECPRRowId:%String,OECPRDesc:%String,selected:%Boolean")
{
}

ClassMethod FindInstrArcimBPriorExecute(ByRef qHandle As %Binary, LocId As %String, Index As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindInstrArcimBPrior","Instr",50,197,1)
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
	q:(LocId="")||(Index="") $$$OK
	s CTLOCType=$P(^CTLOC(LocId),"^",13)
	q:(CTLOCType'="W") $$$OK
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocId,0))
	q:(WardID="") $$$OK
	Set langid=..%LanguageID()
	s KeyValStr=$lg(^User.DHCDocInstrArcimWardD(Index),13)
    s OECPRRowId=0
 	f  s OECPRRowId=$o(^OECPR(OECPRRowId)) q:OECPRRowId=""  d
 	.s OECPRDesc=$p(^OECPR(OECPRRowId),"^",2)
 	.s selected=0
 	.s:(("^"_KeyValStr_"^")[("^"_OECPRRowId_"^")) selected=1
 	.s OECPRDesc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",OECPRDesc,langid)
	.Do OutputRowFindInstrArcimBPrior
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindInstrArcimBPrior
	set Data=$lb($g(OECPRRowId),$g(OECPRDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindInstrArcimBPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrArcimBPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInstrArcimBPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrArcimBPriorExecute ]
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

ClassMethod SaveInstrArcimBPrior(Index As %String, PriorStr As %String, LocId As %String, UserID As %String) As %String
{
	s OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCDocInstrArcimWard"_$c(2)_Index)
	&sql(update SQLUser.DHCDoc_InstrArcimWard set AddItem_ExcludePrior=:PriorStr where ID=:Index)
	if ('SQLCODE){
	    s NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCDocInstrArcimWard"_$c(2)_Index)
	    s CTLocDesc=$P(^CTLOC(LocId),"^",2)
		s SSUSRName=$p(^SSU("SSUSR",UserID),"^",2)
		d ##class(web.DHCDocDataChangeLog).SaveLog("DHCDoc_InstrArcimWard","User.DHCDocInstrArcimWard","病区绑定医嘱设置","User.DHCDocInstrArcimWard_"_Index,CTLocDesc_"-"_SSUSRName,"U",NewDataJson,OldDataJson)
	}
	Q SQLCODE
}

Query GetSpeedFlowRate() As %Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod GetSpeedFlowRateExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","GetHos")
	Set repid=$I(^CacheTemp)
    Set ind=1
 	s id=0 for {
	 	s id=$o(^OEC("SFR",id)) q:id=""
	 	s desc=$p(^OEC("SFR",id),"^",2)
	 	Do OutputSpeedFlowRate
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSpeedFlowRate
	set Data=$lb($g(id),$g(desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetSpeedFlowRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSpeedFlowRateExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSpeedFlowRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSpeedFlowRateExecute ]
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

/// 保存方法属性扩展设置
ClassMethod SaveInstrProperty(InstrRowId As %String, PropertyStr As %String) As %String
{
	for i=1:1:$l(PropertyStr,$C(1)){
		s OnePropertyStr=$p(PropertyStr,$C(1),i)
		s Property=$p(OnePropertyStr,$C(2),1)
		s PropertyValue=$p(OnePropertyStr,$C(2),2)
		s ^DHCDocConfig(Property,InstrRowId)=PropertyValue
	}
	Q 0
}

/// 获取方法扩展属性
/// w ##class(DHCDoc.DHCDocConfig.InstrArcim).GetInstrProperty("39||2","InstrDefSpeedRateUnit")
ClassMethod GetInstrProperty(InstrRowId As %String, PropertyStr As %String) As %String
{
	s InstrPropertyStr=""
	for i=1:1:$l(PropertyStr,$C(1)){
		s Property=$p(PropertyStr,$C(1),i)
		s PropertyValue=$g(^DHCDocConfig(Property,InstrRowId))
		s Property=$replace(Property,"Instr","")
		if InstrPropertyStr="" s InstrPropertyStr=Property_$C(2)_PropertyValue
		else  s InstrPropertyStr=InstrPropertyStr_$C(1)_Property_$C(2)_PropertyValue
	}
	Q InstrPropertyStr
}

Query FindItem(Alias As %String, HospId As %String = "") As websys.Query(ROWSPEC = "ArcimRowID:%String,ArcimDesc:%String,ManfName:%String,Price:%String")
{
}

ClassMethod FindItemExecute(ByRef qHandle As %Binary, Alias As %String, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if (Alias=""){
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	Set langid=..%LanguageID()
	Set rs2=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.ArcItemConfig:FindAllItem")
	d rs2.Execute(Alias,"","","","","","",HospId)
	while(rs2.Next()){
		s ArcimID = rs2.GetData(1)
		continue:ArcimID=""
		s ArcimDesc=rs2.GetData(2)
		s ItemCatRowid=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",10)
		s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
		continue:(OrderType="L")||(OrderType="R")
		continue:##class(web.DHCDocOrderCommon).GetItemServiceFlag(ArcimID)=1
		s inci=##Class(appcom.OEDispensing).GetINCI(+ArcimID)
		s ManfName=""
		if (inci'=""){
			//招标厂商
			s ManfNameStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(inci)
			s ManfName=$P(ManfNameStr,"^",2)
			//批次生产商
			//w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb()
			
		}
		//参考单价
		s Price = $p(##class(web.DHCDocOrderEntry).GetOrderPrice("","",ArcimID,"","","","","","","","^^^^"_HospId), "^", 1)
		s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
		d OutputRowFindItem
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindItem
	Set Data=$lb(ArcimID,ArcimDesc,ManfName,Price)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

Query FindInstrExcludeArcim(InstrRowId As %String, HospitalId As %String, Type As %String) As websys.Query(ROWSPEC = "ARCIMRowID:%String,ArcimDesc:%String")
{
}

ClassMethod FindInstrExcludeArcimExecute(ByRef qHandle As %Binary, InstrRowId As %String, HospitalId As %String, Type As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrArcim","FindInstrExcludeArcim","39",2,"OP")
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
	q:(InstrRowId="")||(Type="") $$$OK
	s Node=$CASE(Type,"OP":"InstrArcim",:"InstrIPArcim")
	s Type=$CASE(Type,"OP":"OPExcludeArcim",:"IPExcludeArcim")
	
	s InstrStr=InstrRowId_"||"_HospitalId
	s ExcludeArcimList=$g(^DHCDocConfig(Node,InstrStr,"ExcludeArcim"))
	
	for i=1:1:$LENGTH(ExcludeArcimList,"^"){
		s ARCIMRowID=$P(ExcludeArcimList,"^",i)
		continue:(ARCIMRowID="")
		s ArcimDesc=$P(^ARCIM(+ARCIMRowID,$P(ARCIMRowID,"||",2),1),"^",2)
		set Data=$lb(ARCIMRowID,ArcimDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 保存例外的医嘱项
ClassMethod InsertInstrExcludeArcim(InstrRowId As %String, Type As %String, HospitalId As %String, ArcimRowID As %String) As %String
{
	Set sc = $$$OK
	if (InstrRowId=""){
		q "-1^用法不能为空"
	}
	if (Type=""){
		q "-1^就诊类型不能为空"
	}
	if (ArcimRowID=""){
		q "-1^未找到有效的医嘱项不能为空"
	}
	s Node=$CASE(Type,"OP":"InstrArcim",:"InstrIPArcim")
	
	s InstrStr=InstrRowId_"||"_HospitalId
	s ExcludeArcimList=$g(^DHCDocConfig(Node,InstrStr,"ExcludeArcim"))
	if ("^"_ExcludeArcimList_"^")[("^"_ArcimRowID_"^"){
		q "-1^存在重复的医嘱项，不需要添加"
	}
	if (ExcludeArcimList=""){
		s ExcludeArcimList=ArcimRowID
	}else{
		s ExcludeArcimList=ExcludeArcimList_"^"_ArcimRowID
	}
	s ^DHCDocConfig(Node,InstrStr,"ExcludeArcim")=ExcludeArcimList
	q sc
}

/// 删除例外的医嘱项
ClassMethod DeleteInstrExcludeArcim(InstrRowId As %String, Type As %String, HospitalId As %String, ArcimIdStr As %String) As %String
{
	Set sc = $$$OK
	if (InstrRowId=""){
		q "-1^用法不能为空"
	}
	if (Type=""){
		q "-1^就诊类型不能为空"
	}
	if (ArcimIdStr=""){
		q "-1^未找到有效的医嘱项不能为空"
	}
	s Node=$CASE(Type,"OP":"InstrArcim",:"InstrIPArcim")
	s Type=$CASE(Type,"OP":"OPExcludeArcim",:"IPExcludeArcim")
	
	s InstrStr=InstrRowId_"||"_HospitalId
	s ExcludeArcimList=$g(^DHCDocConfig(Node,InstrStr,"ExcludeArcim"))
	s NewExcludeArcimList=""
	for i=1:1:$LENGTH(ExcludeArcimList,"^"){
		s ARCIMRowID=$P(ExcludeArcimList,"^",i)
		continue:(ARCIMRowID="")
		if ("^"_ArcimIdStr_"^")[("^"_ARCIMRowID_"^"){
			continue
		}
		if (NewExcludeArcimList=""){
			s NewExcludeArcimList=ARCIMRowID
		}else{
			s NewExcludeArcimList=NewExcludeArcimList_"^"_ARCIMRowID
		}
	}
	s ^DHCDocConfig(Node,InstrStr,"ExcludeArcim")=NewExcludeArcimList
	q sc
}

/// 获取子医嘱可以自定义流速和流速单位的用法
ClassMethod GetSpeedRateSeparateInstr(HospId As %String = "")
{
    s InstrStr=""
    s SessionStr=..%SessionStr()
    s:HospId="" HospId=$p(SessionStr,"^",4)
    s Property="InstrSpeedRateSeparate"
    s InstrItem=""
    f {
        s InstrItem=$o(^DHCDocConfig(Property,InstrItem)) q:InstrItem=""
        continue:^DHCDocConfig(Property,InstrItem)'="1"
        s ItemVal=$p(InstrItem,"||",1)
        continue:ItemVal=""
        s ItemHosp=$p(InstrItem,"||",2)
        continue:HospId'=ItemHosp
        s InstrStr=$s(InstrStr="":ItemVal,1:InstrStr_"^"_ItemVal)
    }
    q InstrStr
}

}

Import SQLUser

Class web.DHCWMRNoCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 267;

ClassMethod Update(InString)
{
	//***************************************
	//功能说明：添加或修改病案号信息
	//入参：WMRRowid^MrType_Dr^MrNo^IsActive^Ctloc_Dr^AssignUser_Dr^AssignDate^AssignTime^ResumeText
	//出参：WMRRowid
	//调试：w ##class(web.DHCWMRNoCtl).Update("入参")
	//*****************************************
	n (InString)
	s $p(InString,"^",3)=$$ALPHAUP^SSUTIL4($p(InString,"^",3))    //add by zf 2008-04-14
    s WMRRowid=$p(InString,"^",1)
    s flg=0
    i WMRRowid'="" d
    .&sql(select * into :PLIST() from DHC_WMR_No where Rowid=:WMRRowid)
    .s:SQLCODE flg=-1
    q:flg=-1 -1
    
    s:$p(InString,"^",2)'="" PLIST(2)=+$p(InString,"^",2)          ;病案类型
    s:$p(InString,"^",3)'="" PLIST(3)=$p(InString,"^",3)           ;病案号
    s:$p(InString,"^",4)'="" PLIST(4)=$s($p(InString,"^",4)["Y":"Y",1:"N")  ;是否有效
    s:$p(InString,"^",5)'="" PLIST(5)=+$p(InString,"^",5)          ;所属接诊科室
    s:$p(InString,"^",6)'="" PLIST(6)=+$p(InString,"^",6)          ;发放操作员
    s:$p(InString,"^",7)'="" PLIST(7)=$zdh($p(InString,"^",7),3)   ;发放日起
    s:$p(InString,"^",8)'="" PLIST(8)=$zth($p(InString,"^",8))     ;发放时间
    
    s:$p(InString,"^",9)'="" PLIST(9)=$p(InString,"^",9)           ;备注
    q:((PLIST(2)=0)||(PLIST(3)="")||(PLIST(4)="")||(PLIST(5)=0)) -1
    q:((PLIST(6)=0)||(PLIST(7)="")||(PLIST(8)="")) -1
    q:($d(^DHCWMRNO(0,"TypeNo",PLIST(2),PLIST(3))))&(WMRRowid="") -100
    i WMRRowid="" d
    .&sql(Insert into DHC_WMR_No values :PLIST())
    e  d
    .&sql(Update DHC_WMR_No values :PLIST() where Rowid=:WMRRowid)
    
    /*
    
    s PLIST(2)=+$p(InString,"^",2)          ;病案类型
    s PLIST(3)=$p(InString,"^",3)           ;病案号
    s PLIST(4)=$s($p(InString,"^",4)["Y":"Y",1:"N")  ;是否有效
    s PLIST(5)=+$p(InString,"^",5)          ;所属接诊科室
    s PLIST(6)=+$p(InString,"^",6)          ;发放操作员
    s PLIST(7)=+$zdh($p(InString,"^",7),3)   ;发放日起
    s PLIST(8)=+$zth($p(InString,"^",8))   ;发放时间
    s PLIST(9)=""   ;发放时间
    i WMRRowid="" d
    .&sql(Insert into DHC_WMR_No values :PLIST())
    e  d
    .&sql(Update DHC_WMR_No values :PLIST() where Rowid=:WMRRowid)
    */
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod Delete(WMRRowid)
{
	//***************************************
	//功能说明：删除病案号信息
	//入参：WMRRowid
	//出参：SQLCODE
	//调试：w ##class(web.DHCWMRNoCtl).Delete("入参")
	//*****************************************
	n (WMRRowid)
    q:WMRRowid="" -1
    q:'$d(^DHCWMRNO(WMRRowid)) -100
    s s=$g(^DHCWMRNO(WMRRowid))
    q:$p(s,"^",3)="N" -2
    &sql(delete from DHC_WMR_No where Rowid=:WMRRowid)
    q SQLCODE
}

ClassMethod GetDataById(WMRRowid)
{
	//***************************************
	//功能说明：获取病案号信息
	//入参：WMRRowid
	//出参：WMRRowid^MrType_Dr^MrNo^IsActive^Ctloc_Dr^AssignUser_Dr^AssignDate^AssignTime^ResumeText
	//调试：w ##class(web.DHCWMRNoCtl).GetDataById("WMRRowid")
	//*****************************************
	n (WMRRowid)
    q:'$d(^DHCWMRNO(WMRRowid)) ""
    s s=WMRRowid_"^"_$g(^DHCWMRNO(WMRRowid))
    s:$p(s,"^",7)'="" $p(s,"^",7)=$zd($p(s,"^",7),3)
    s:$p(s,"^",8)'="" $p(s,"^",8)=$zt($p(s,"^",8),2)
	q s
}

ClassMethod QueryByTypeLocFlagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByTypeLocFlagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryByTypeLocFlagExecute(ByRef qHandle As %Binary, Type As %String, Loc As %String, Flag As %String) As %Status
{
	//***************************************
	//功能说明：查询病案号信息
	//入参：MrType_Dr，Ctloc_Dr，IsActive
	//出参：WMRRowid^MrType_Dr^MrNo^IsActive^Ctloc_Dr^AssignUser_Dr^AssignDate^AssignTime^ResumeText
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRNoCtl","QueryByTypeLocFlag","MrType_Dr","Ctloc_Dr","IsActive")
	//*****************************************
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
    s:Type'="" Type=+Type
    s:Loc'="" Loc=+Loc
    q:((Type="")&&(Loc="")) $$$OK
    s:Flag'="" Flag=$s(Flag["Y":"Y",1:"N")
    i Type="" d
    .s sType="" f  s sType=$o(^DHCWMRNO(0,"TypeLocActive",sType)) q:sType=""  d
    ..q:'$d(^DHCWMRNO(0,"TypeLocActive",sType,Loc))
    ..d CheckFlagByTLF(sType,Loc,Flag)
    e  d
    .q:'$d(^DHCWMRNO(0,"TypeLocActive",Type))
    .i Loc="" d
    ..s sLoc="" f  s sLoc=$o(^DHCWMRNO(0,"TypeLocActive",Type,sLoc)) q:sLoc=""  d
    ...q:'$d(^DHCWMRNO(0,"TypeLocActive",Type,sLoc))
    ...d CheckFlagByTLF(Type,sLoc,Flag)
    .e  d
    ..q:'$d(^DHCWMRNO(0,"TypeLocActive",Type,Loc))
    ..d CheckFlagByTLF(Type,Loc,Flag)
	Quit $$$OK

CheckFlagByTLF(Type,Loc,Flag)
    i Flag="" d
    .s sFlag="" f  s sFlag=$o(^DHCWMRNO(0,"TypeLocActive",Type,Loc,sFlag)) q:sFlag=""  d
    ..q:'$d(^DHCWMRNO(0,"TypeLocActive",Type,Loc,sFlag))
    ..s WMRRowid=0
    ..f  s WMRRowid=$o(^DHCWMRNO(0,"TypeLocActive",Type,Loc,sFlag,WMRRowid)) q:WMRRowid=""  d
    ...q:'$d(^DHCWMRNO(WMRRowid))
    ...s s=##class(web.DHCWMRNoCtl).GetDataById(WMRRowid)
    ...d BuildData
    e  d
    .q:'$d(^DHCWMRNO(0,"TypeLocActive",Type,Loc,Flag))
    .s WMRRowid=0
    .f  s WMRRowid=$o(^DHCWMRNO(0,"TypeLocActive",Type,Loc,Flag,WMRRowid)) q:WMRRowid=""  d
    ..q:'$d(^DHCWMRNO(WMRRowid))
    ..s s =##class(web.DHCWMRNoCtl).GetDataById(WMRRowid)
    ..d BuildData
    q
    
BuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryByTypeLocFlagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByTypeLocFlagExecute ]
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

/// 根据病案类型，接诊室，有效标记查询病案号信息
Query QueryByTypeLocFlag(Type As %String, Loc As %String, Flag As %String) As %Query(ROWSPEC = "Rowid:%String,MrTypeDr:%String,MrNo:%String,IsActive:%String,CtlocDr:%String,AssignUserDr:%String,AssignDate:%String,AssignTime:%String,ResumeText:%String")
{
}

ClassMethod QueryByTypeNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByTypeNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryByTypeNoExecute(ByRef qHandle As %Binary, Type As %String, No As %String) As %Status
{
	//***************************************
	//功能说明：查询病案号信息
	//入参：MrType_Dr，MrNo
	//出参：WMRRowid^MrType_Dr^MrNo^IsActive^Ctloc_Dr^AssignUser_Dr^AssignDate^AssignTime^ResumeText
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRNoCtl","QueryByTypeNo","MrType_Dr"，"MrNo")
	//*****************************************
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
    s:Type'="" Type=+Type
    q:No="" $$$OK
    s No=$$ALPHAUP^SSUTIL4($g(No))   //add by zf 2008-04-14
    i Type="" d
    .s sType="" f  s sType=$o(^DHCWMRNO(0,"TypeNo",sType)) q:sType=""  d
    ..q:'$d(^DHCWMRNO(0,"TypeNo",sType,No))
    ..s WMRRowid=0
    ..f  s WMRRowid=$o(^DHCWMRNO(0,"TypeNo",sType,No,WMRRowid)) q:WMRRowid=""  d
    ...q:'$d(^DHCWMRNO(WMRRowid))
    ...s s=##class(web.DHCWMRNoCtl).GetDataById(WMRRowid)
    ...d BuildData
    e  d
    .q:'$d(^DHCWMRNO(0,"TypeNo",Type,No))
    .s WMRRowid=0
    .f  s WMRRowid=$o(^DHCWMRNO(0,"TypeNo",Type,No,WMRRowid)) q:WMRRowid=""  d
    ..q:'$d(^DHCWMRNO(WMRRowid))
    ..s s=##class(web.DHCWMRNoCtl).GetDataById(WMRRowid)
    ..d BuildData
    q $$$OK
}

ClassMethod QueryByTypeNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByTypeNoExecute ]
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

/// 根据病案类型，病案号查询病案号信息
Query QueryByTypeNo(Type As %String, No As %String) As %Query(ROWSPEC = "Rowid:%String,DictionaryName:%String,Code:%String,Description:%String,FromDate:%String,ToDate:%String,TextA:%String,TextB:%String,TextC:%String,TextD:%String,IsActive:%String,ResumeText:%String")
{
}

ClassMethod GetMrNoByLoc(Type, Loc)
{
	//***************************************
	//功能说明：分配病案号(根据接诊室，病案类型查询最早分配的一个号,并修改状态)
	//入参：MrType_Dr，Ctloc_Dr
	//出参：MrNo
	//调试：w ##class(web.DHCWMRNoCtl).GetMrNoByLoc("入参")
	//*****************************************
	n (Type,Loc)
	;分配病案号(根据接诊室，病案类型查询最早分配的一个号,并修改状态)
    n (Type,Loc)
    s ret=""
    q:Type="" ret
    
    /*
    s sHosp=$$GetDefaultHosp^DHCWMRMedBase01()
    s sMrNoFlag=+$p(sHosp,"/",4)
    q:(sMrNoFlag=1)&(Loc="") ret
    s sHospInfo=$p(sHosp,"/",1)
    s DefaultWMRNo=0
    i $p(sHospInfo,"^",2)="BJYYYY" d    
    .//病案号，友谊-系统自动获取的号都大于这个号，
    .//从这个号以后的最小号开始发，
    .//其它医院从小号开始发。
    .s DefaultWMRNo=500000
    */
    s NumLen=+$p($g(^DHCWMRNOTYPE("NoFormat",Type)),"^",1)
    s NoHead=$p($g(^DHCWMRNOTYPE("NoFormat",Type)),"^",2)
    s sMrNoFlag=+$p($g(^DHCWMRNOTYPE("NoFormat",Type)),"^",3)
    s DefaultWMRNo=$p($g(^DHCWMRNOTYPE("NoFormat",Type)),"^",4)
    q:(sMrNoFlag=1)&(Loc="") ret
    
    q:'$d(^DHCWMRNO(0,"TypeLocActive",Type)) ret
    i sMrNoFlag=0 d
    .s Loc="",tmp=""
    .f  s tmp=$o(^DHCWMRNO(0,"TypeLocActive",Type,tmp),-1) q:(tmp="")||(Loc'="")  d
    ..s:$d(^DHCWMRNO(0,"TypeLocActive",Type,tmp,"Y")) Loc=tmp
    
    q:Loc="" ret
    ;q:((Type="")||(Loc="")) ret
    ;s:Type'="" Type=+Type   
    
    q:'$d(^DHCWMRNO(0,"TypeLocActive",Type,Loc,"Y")) ""
    /*
    s DefaultWMRNo=DefaultWMRNo+1
    s CurrWMRNo=0
    s WMRRowid=0
    while((CurrWMRNo<DefaultWMRNo)&&(WMRRowid'="")){
	    s WMRRowid=$o(^DHCWMRNO(0,"TypeLocActive",Type,Loc,"Y",WMRRowid))
        s:WMRRowid'="" retStr=$g(^DHCWMRNO(WMRRowid))
        s:WMRRowid'="" CurrWMRNo=$p(retStr,"^",2)
        s:((WMRRowid'="")&&(NoHead'="")) CurrWMRNo=$p(CurrWMRNo,NoHead,2)
	}
	*/
	
	//update by zf 208-05-04
	//********************************************************
	s Flg=0,TMPDef="",TMPDef1=""
	f xIndex=1:1:$l(DefaultWMRNo) q:Flg=1  d
	.s tmpDefault=$e(DefaultWMRNo,xIndex,xIndex)
	.i ($ASCII(tmpDefault)<58)&&($ASCII(tmpDefault)>47) d
	..s TMPDef=$e(DefaultWMRNo,1,xIndex-1)
	..s TMPDef1=$e(DefaultWMRNo,xIndex,$l(DefaultWMRNo))
	..s Flg=1
	
	s CurrWMRNo="",WMRRowid=0,xWMRRowid=""
	i sMrNoFlag=1 d
	.;分接诊室取号
	.f  s WMRRowid=$o(^DHCWMRNO(0,"TypeLocActive",Type,Loc,"Y",WMRRowid)) q:(WMRRowid="")||(CurrWMRNo'="")  d
    ..s retStr=$g(^DHCWMRNO(WMRRowid))
    ..s xCurrWMRNo=$p(retStr,"^",2)
    ..s TMPCurr=$e(xCurrWMRNo,1,$l(TMPDef))
    ..s TMPCurr1=$e(xCurrWMRNo,$l(TMPDef)+1,$l(xCurrWMRNo))
    ..i (TMPCurr=TMPDef) d
    ...s:($ASCII(TMPCurr1)<48)||($ASCII(TMPCurr1)>57) CurrWMRNo=xCurrWMRNo
    ...s:(+TMPCurr1>+TMPDef1) CurrWMRNo=xCurrWMRNo
    ..e  d
    ...s CurrWMRNo=xCurrWMRNo
    ..s:xCurrWMRNo'="" xWMRRowid=WMRRowid
	e  d
	.;全院统一取号
	.f  s WMRRowid=$o(^DHCWMRNO(0,"TypeActive",Type,"Y",WMRRowid)) q:(WMRRowid="")||(CurrWMRNo'="")  d
    ..s retStr=$g(^DHCWMRNO(WMRRowid))
    ..s xCurrWMRNo=$p(retStr,"^",2)
    ..s TMPCurr=$e(xCurrWMRNo,1,$l(TMPDef))
    ..s TMPCurr1=$e(xCurrWMRNo,$l(TMPDef)+1,$l(xCurrWMRNo))
    ..i (TMPCurr=TMPDef) d
    ...s:($ASCII(TMPCurr1)<48)||($ASCII(TMPCurr1)>57) CurrWMRNo=xCurrWMRNo
    ...s:(+TMPCurr1>+TMPDef1) CurrWMRNo=xCurrWMRNo
    ..e  d
    ...s CurrWMRNo=xCurrWMRNo
    ..s:xCurrWMRNo'="" xWMRRowid=WMRRowid
    //**************************************************************
	
	i ((CurrWMRNo'="")&&(xWMRRowid'="")) d
    .s ret=CurrWMRNo
    .s Instr=xWMRRowid_"^^^N^^^^^"
    .s flag=..Update(Instr)
    .s:flag<1 ret=""
    e  d
    .s ret=""
	
    q ret
}

ClassMethod SetMrNoByTypeNo(Type, No)
{
	//***************************************
	//功能说明：释放病案号(根据病案类型和病案号释放掉未用的号，已用的号不能释放。)
	//入参：MrType_Dr，MrNo
	//出参：WMRRowid
	//调试：w ##class(web.DHCWMRNoCtl).SetMrNoByTypeNo("入参")
	//*****************************************
	n (Type,No)
	s No=$$ALPHAUP^SSUTIL4($g(No))           //add by zf 2008-04-14
	Set Config=##Class(websys.Configuration).%OpenId(1)
    ;释放病案号(根据病案类型和病案号释放掉未用的号，已用的号不能释放。)
    s:Type'="" Type=+Type
    q:((Type="")||(No="")) -1
    q:'$d(^DHCWMRNO(0,"TypeNo",Type,No)) -100
    s WMRRowid=$o(^DHCWMRNO(0,"TypeNo",Type,No,0))
    q:WMRRowid="" -100
    q:'$d(^DHCWMRNO(WMRRowid)) -100
    s s=$g(^DHCWMRNO(WMRRowid))
    q:$p(s,"^",3)="Y" -2
    s Instr=WMRRowid_"^^^Y^^^^^"
    s ret=..Update(Instr)
    q ret
}

ClassMethod BatchCreateMrNo(InStr)
{
	//***************************************
	//功能说明：批量发放病案号
	//入参：cType^cLoc^cResume^cUser^cNoFrom^cNoTo
	//出参：Flag
	//调试：w ##class(web.DHCWMRNoCtl).BatchCreateMrNo("入参")
	//*****************************************
	n (InStr)
	
	s ret=0
	q:InStr="" ret
	s Type=$p(InStr,"^",1)
	s Loc=$p(InStr,"^",2)
	s Resume=$p(InStr,"^",3)
	s User=$p(InStr,"^",4)
	s NoFrom=+$p(InStr,"^",5)
	s NoTo=+$p(InStr,"^",6)
	s NoLen=0,NoHead=""
	s:$d(^DHCWMRNOTYPE("NoFormat",Type)) NoLen=+$p(^DHCWMRNOTYPE("NoFormat",Type),"^",1)    ;Update ZF 2007-08-13
	s:$d(^DHCWMRNOTYPE("NoFormat",Type)) NoHead=$p(^DHCWMRNOTYPE("NoFormat",Type),"^",2)    ;Update ZF 2007-08-13
	s Date=$zd($p($h,",",1),3)
	s Time=$zt($p($h,",",2),2)
	s str=""
	
	s Flg=1
	
	TStart
	f i=NoFrom:1:NoTo d
	.i NoLen=0 d
	..s MrNo=i
	..i NoHead'="" d
	...s MrNo=NoHead_MrNo
	.e  d
	..s MrNo=i
	..s k=$l(i)
	..;s s=NoLen
	..q:k>NoLen
	..i k<NoLen d
	...f j=k:1:NoLen-1 d
	....s MrNo="0"_MrNo
	..i NoHead'="" d
	...s MrNo=NoHead_MrNo
	.q:MrNo=""
	.s MrNo=$$ALPHAUP^SSUTIL4($g(MrNo))      //add by zf 2008-04-14
	.s:$d(^DHCWMRNO(0,"TypeNo",Type,MrNo)) str=str_" "_MrNo
	.q:$d(^DHCWMRNO(0,"TypeNo",Type,MrNo))
	.s InString="^"_Type_"^"_MrNo_"^Y^"_Loc_"^"_User_"^"_Date_"^"_Time_"^"_Resume
	.s s=##class(web.DHCWMRNoCtl).Update(InString)
	.s:(s<1) Flg=0
	.q:(s<1)
	i Flg=0 TRollBack
	q:Flg=0 ret
	Tcommit
	s ret=1_"^"_str
	q ret
}

//病案号格式设置

ClassMethod UpdateMrNoLen(InStr)
{
	//***************************************
	//入参：
	//病案类型/病案号数字长度/病案号头标记/大小科室取号标记/新系统能用的最小号码
	//cType^cNum^cHead^DefaultLocFlg^MinNo
	//调试：w ##class(web.DHCWMRNoCtl).UpdateMrNoLen("入参")
	//*****************************************
	
	;Update ZF 2007-08-13
	
	n (InStr)
	
	s MrType=+$p(InStr,"^",1)                     ;病案类型
	q:MrType=0 0
	s NumLen=$p(InStr,"^",2)                      ;空--不补零  8--数字部分补齐八位
	s NoHead=$p(InStr,"^",3)                      ;病案号头标记
	s DefaultLocFlg=$p(InStr,"^",4)
	s DefaultLocFlg=$s(DefaultLocFlg=1:1,1:0)     ;0--全院统一取号  1--按科室取号
	s MinNo=$p(InStr,"^",5)                       ;新系统能用的最小号码数字部分
	s MrNoField=+$p(InStr,"^",6)                  ;Trak系统中存储病案号字段代码
	s MrNoCancelFlag=$p(InStr,"^",7)              ;add by liuxuefeng 2009-06-29 增加取消接诊时，是否取消病案号标志
	s ^DHCWMRNOTYPE("NoFormat",MrType)=NumLen_"^"_NoHead_"^"_DefaultLocFlg_"^"_MinNo_"^"_MrNoField_"^"_MrNoCancelFlag
	q 1
}

ClassMethod QueryMrNoFormatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMrNoFormatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryMrNoFormatExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

	s MrTypeId=0
	f  s MrTypeId=$o(^DHCWMRNOTYPE("NoFormat",MrTypeId)) q:MrTypeId=""  d
	.q:'$d(^DHCWMRNOTYPE("NoFormat",MrTypeId))
	.s tmp=$g(^DHCWMRDIC(MrTypeId))
	.s MrTypeCode=$p(tmp,"^",2)
	.s MrTypeDesc=$p(tmp,"^",3)
	.s MrType=MrTypeId_"/"_MrTypeCode_"/"_MrTypeDesc
	.s tmp=..GetMrNoFormat(MrTypeId)
	.q:tmp=""
	.s Len=$p(tmp,"^",1)
	.s Head=$p(tmp,"^",2)
	.s DefLoc=$p(tmp,"^",3)
	.s MinNo=$p(tmp,"^",4)
	.s Field=$p(tmp,"^",5)
	.s MrNoCancelFlag=$p(tmp,"^",6) ;add by liuxuefeng 2009-06-29 增加是否取消病案号字段
	.s s=MrType_"^"_Len_"^"_Head_"^"_DefLoc_"^"_MinNo_"^"_Field_"^"_MrNoCancelFlag
    .d BuildData
    q $$$OK
}

ClassMethod QueryMrNoFormatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMrNoFormatExecute ]
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

/// d ##class(%ResultSet).RunQuery("web.DHCWMRNoCtl","QueryMrNoFormat")
Query QueryMrNoFormat() As %Query(ROWSPEC = "MrType:%String,Len:%String,Head:%String,DefLoc:%String,MinNo:%String,Field:%String,MrNoCancelFlag:%String")
{
}

ClassMethod QueryMrNoInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMrNoInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryMrNoInfoExecute(ByRef qHandle As %Binary, Type As %String, Loc As %String, Flag As %String, NoFrom As %String, NoTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	
	q:Type="" $$$OK
	s Type=+Type
	s:Loc'="" Loc=+Loc
	s:Loc=0 Loc=""
	s:Flag'="" Flag=$s(Flag["Y":"Y",1:"N")
	s NoFrom=+NoFrom
	s:NoFrom=0 NoFrom=""
	s NoTo=+NoTo
	s:NoTo=0 NoTo=""
	i ((NoFrom="")||(NoTo="")) d
    .q:'$d(^DHCWMRNO(0,"TypeLocActive",Type))
    .i Loc="" d
    ..s sLoc="" f  s sLoc=$o(^DHCWMRNO(0,"TypeLocActive",Type,sLoc)) q:sLoc=""  d
    ...q:'$d(^DHCWMRNO(0,"TypeLocActive",Type,sLoc))
    ...d CheckFlagByTLF(Type,sLoc,Flag)
    .e  d
    ..q:'$d(^DHCWMRNO(0,"TypeLocActive",Type,Loc))
    ..d CheckFlagByTLF(Type,Loc,Flag)
	e  d
	.q:NoFrom>NoTo
	.s NoLen=0,NoHead=""
	.s:$d(^DHCWMRNOTYPE("NoFormat",Type)) NoLen=+$p(^DHCWMRNOTYPE("NoFormat",Type),"^",1)    ;Update ZF 2007-08-13
	.s:$d(^DHCWMRNOTYPE("NoFormat",Type)) NoHead=$p(^DHCWMRNOTYPE("NoFormat",Type),"^",2)    ;Update ZF 2007-08-13
	.f i=NoFrom:1:NoTo d
	..i NoLen=0 d
	...s MrNo=i
	...i NoHead'="" d
	....s MrNo=NoHead_MrNo
	..e  d
	...s MrNo=i
	...s k=$l(i)
	...s s=NoLen-1
	...q:k>s
	...f j=k:1:s d
	....s MrNo="0"_MrNo
	...i NoHead'="" d
	....s MrNo=NoHead_MrNo
	..q:MrNo=""
	..i $d(^DHCWMRNO(0,"TypeNo",Type,MrNo)) d
	...s Id=0
	...f  s Id=$o(^DHCWMRNO(0,"TypeNo",Type,MrNo,Id)) q:Id=""  d
	....q:'$d(^DHCWMRNO(Id))
	....q:((Loc'="")&&(Loc'=$p(^DHCWMRNO(Id),"^",4)))
	....q:((Flag'="")&&(Flag'=$p(^DHCWMRNO(Id),"^",3)))
    ....s s=##class(web.DHCWMRNoCtl).GetDataById(Id)
    ....d BuildData
    ..s tmpMrNo=MrNo_" "
    ..f  s tmpMrNo=$o(^DHCWMRNO(0,"TypeNo",Type,tmpMrNo)) q:((tmpMrNo="")||($e(tmpMrNo,1,$l(MrNo))'=MrNo))  d
	...q:($l(tmpMrNo)>($l(MrNo)+1))
	...s Id=0
	...f  s Id=$o(^DHCWMRNO(0,"TypeNo",Type,tmpMrNo,Id)) q:Id=""  d
	....q:'$d(^DHCWMRNO(Id))
	....q:((Loc'="")&&(Loc'=$p(^DHCWMRNO(Id),"^",4)))
	....q:((Flag'="")&&(Flag'=$p(^DHCWMRNO(Id),"^",3)))
    ....s s=##class(web.DHCWMRNoCtl).GetDataById(Id)
    ....d BuildData
    q $$$OK
}

ClassMethod QueryMrNoInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMrNoInfoExecute ]
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

/// 病案号信息查询（多种组合条件）
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRNoCtl","QueryMrNoInfo",6,"","Y","a","b")
Query QueryMrNoInfo(Type As %String, Loc As %String, Flag As %String, NoFrom As %String, NoTo As %String) As %Query(ROWSPEC = "Rowid:%String,MrTypeDr:%String,MrNo:%String,IsActive:%String,CtlocDr:%String,AssignUserDr:%String,AssignDate:%String,AssignTime:%String,ResumeText:%String")
{
}

/// 取科室可用病案号总数和当前病案号（可用）。
/// w ##Class(web.DHCWMRNoCtl).GetMrNoCountAndCurrNo(MrTypeId, LocId)
ClassMethod GetMrNoCountAndCurrNo(MrTypeId, LocId)
{
	n (MrTypeId,LocId)	
	/*
	s sMrNoFlag=+$p(^DHCWMRNOTYPE("NoFormat",MrTypeId),"^",3)      ;Update ZF 2007-08-13
	i sMrNoFlag=0 d
	.s LocId=$o(^DHCWMRNO(0,"TypeLocActive",MrTypeId,""),-1)
	
	q:LocId="" -100
	q:'$d(^DHCWMRNO(0,"TypeLocActive",MrTypeId,LocId,"Y")) -100
	
	s num=0
	s Id=0
	f  s Id=$o(^DHCWMRNO(0,"TypeLocActive",MrTypeId,LocId,"Y",Id)) q:Id=""  d
	.q:'$d(^DHCWMRNO(Id))
	.s num=num+1
	s CurrNo=""
	i num>0 d
	.s CurrNoId=$o(^DHCWMRNO(0,"TypeLocActive",MrTypeId,LocId,"Y",0))
	.s CurrNo=$p($g(^DHCWMRNO(CurrNoId)),"^",2)
	*/
	
	;Modify by liuxuefeng 2009-05-31
	s ret=-1
	q:MrTypeId="" ret
	
	s sMrNoFlag=+$p(^DHCWMRNOTYPE("NoFormat",MrTypeId),"^",3)
	s num=0	
	s CurrNo=""														;可用病案号数量
	;sMrNoFlag=0 为 全院统一取号
	;sMrNoFlag=1 为 按科室取号
	if (sMrNoFlag=0){
		;^DHCWMRNO(0,"TypeActive",{MrType_Dr},{IsActive},{Rowid})
		s RowId=0
		f  s RowId=$o(^DHCWMRNO(0,"TypeActive",MrTypeId,"Y",RowId)) q:RowId=""  d
		.q:'$d(^DHCWMRNO(RowId))
		.s num=num+1
		i num>0 d
		.s CurrNoId=$o(^DHCWMRNO(0,"TypeActive",MrTypeId,"Y",0))
		.s CurrNo=$p($g(^DHCWMRNO(CurrNoId)),"^",2)
	}elseif(sMrNoFlag=1){	
	    //*****非按科室接诊*****************
		;^DHCWMRNO(0,"TypeActive",{MrType_Dr},{IsActive},{Rowid})
		s RowId=0
		f  s RowId=$o(^DHCWMRNO(0,"TypeActive",MrTypeId,"Y",RowId)) q:RowId=""  d
		.q:'$d(^DHCWMRNO(RowId))
		.s num=num+1
		i num>0 d
		.s CurrNoId=$o(^DHCWMRNO(0,"TypeActive",MrTypeId,"Y",0))
		.s CurrNo=$p($g(^DHCWMRNO(CurrNoId)),"^",2)
		//************************************
	}
	q num_"^"_CurrNo
}

/// 获取某种病案类型的最大号
/// w ##Class(web.DHCWMRNoCtl).GetMaxNoByMrType(6)
ClassMethod GetMaxNoByMrType(MrTypeId)
{
	n (MrTypeId)
	s ret=""
	q:+MrTypeId=0 ret
	
	;Update ZF 2007-08-13
	;^DHCWMRNO(0,"TypeNo",{MrType_Dr},{MrNo},{Rowid})
	s NoHead=$p(^DHCWMRNOTYPE("NoFormat",MrTypeId),"^",2)
	s tmpNo=NoHead_"99999999999999999999"
	s MaxNo=$o(^DHCWMRNO(0,"TypeNo",MrTypeId,tmpNo),-1)
	s:$e(MaxNo,1,$l(NoHead))'=NoHead MaxNo=""
	s ret=MaxNo
	q ret
}

/// 通过病案类型查询病案号格式信息
/// 参数：MrType  病案类型Rowid
/// 输出：长度^首代码^科室取号(ID/Desc)^最小号^存储字段(ID/Code/Desc)^MrNoCancelFlag(add "MrNoCancelFlag" by liuxuefeng 2009-06-29)
/// w ##Class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
ClassMethod GetMrNoFormat(MrType)
{
	n (MrType)
	s ret=""
	q:MrType="" ret
	q:'$d(^DHCWMRNOTYPE("NoFormat",MrType)) ret
	;^DHCWMRNOTYPE("NoFormat",MrType)=NumLen_"^"_NoHead_"^"_DefaultLocFlg_"^"_MinNo_"^"_MrNoField
	s TMP=$g(^DHCWMRNOTYPE("NoFormat",MrType))
	s tmpLoc=$p(TMP,"^",3)
	s tmpLoc=$s(tmpLoc=1:1,1:0)
	s:tmpLoc=0 tmpLocDesc="全院统一取号"
	s:tmpLoc=1 tmpLocDesc="按科室取号"
	s $p(TMP,"^",3)=tmpLoc_"/"_tmpLocDesc
	s tmpFieldId=$p(TMP,"^",5)
	i tmpFieldId'="" d
	.s tmp=$g(^DHCWMRDIC(+tmpFieldId))
	.s tmpCode=$p(tmp,"^",2)
	.s tmpDesc=$p(tmp,"^",3)
	.s tmpField=tmpFieldId_"/"_tmpCode_"/"_tmpDesc
	.s $p(TMP,"^",5)=tmpField
	s ret=TMP
	q ret
}

/// Creator:wangCS
/// CreateDate:2011-10-14
/// Description:查询病案号是空的病人
/// Debug:w ##Class(%ResultSet).RunQuery("web.DHCWMRNoCtl","GetEmptyMrNo")
Query GetEmptyMrNo() As %Query(ROWSPEC = "PapmiNo:%String:登记号,PapmiId:%String:病人Id,Name:%String:姓名,Paadm:%String:就诊号,Loc:%String:科室,AdmDate:%String:就诊日期,MrNo:%String:病案号,OldPapmiNo:%String:就登记号,OldPapmiId:%String:旧病人Id,OldName:%String:旧病人姓名")
{
}

ClassMethod GetEmptyMrNoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	set paadm=0
	;^PAADMi("PAADM_Type",{PAADM_Type},{PAADM_RowID})
	set paadm=$o(^PAADMi("PAADM_Type","I",paadm))
	while(paadm'=""){
		set paadmId=paadm
		set paadm=$o(^PAADMi("PAADM_Type","I",paadm))
		;^PAADM({PAADM_RowID})
		set papmiDR=$p($g(^PAADM(paadmId)),"^",1) 
		set papmiNo=$p($g(^PAPER(papmiDR,"PAT",1)),"^",1)  ;papmino
		set name=$p($g(^PAPER(papmiDR,"ALL")),"^",1)      ;name
		;^PAPER({PAPMI_RowId}) 
		set mrNO=$p($g(^PAPER(papmiDR,"PAT",1)),"^",22)  ;病案号
		set admDate=$zd($p($g(^PAADM(paadmId)),"^",6),3)        ;就诊时间
		set locDR=$p($g(^PAADM(paadmId)),"^",4)
		;^CTLOC({CTLOC_RowID})
		set locDesc=$p($g(^CTLOC(locDR)),"^",2)
		Continue:mrNO'=""
		;^DHCWMRRecLog(0,"MrNo",{MrType_Dr},{MrNo},{Rowid})
		set logId=0
		;if ($d(^DHCWMRRecLog(0,"MrNo",7,mrNO))){
		;^DHCWMRRecLog(0,"Papmi",{Papmi_Dr},{Rowid})
		if ($d(^DHCWMRRecLog(0,"Papmi",papmiDR))){
			set logRowId=$o(^DHCWMRRecLog(0,"Papmi",papmiDR,logId))
			set isCancle="N"
			set oldPapmiNo="",oldPapmiDR="",oldName=""
			while(logRowId'="")&&(isCancle="N"){
				set logId=logRowId
				set logRowId=$o(^DHCWMRRecLog(0,"Papmi",papmiDR,logId))
				set mrNO=$p($g(^DHCWMRRecLog(logId)),"^",3) ;mrNO
				;^DHCWMRRecLog({Rowid})
				set opeType=$p($g(^DHCWMRRecLog(logId)),"^",1)
				if (opeType=2){
					set oldPapmiDR=$p($g(^DHCWMRRecLog(logId)),"^",5) ;取消就诊病人
					; ^PAPER({PAPMI_RowId}) "PAT",1
					set oldPapmiNo=$p($g(^PAPER(oldPapmiDR,"PAT",1)),"^",1)   ;papmiIPNO
					set oldName=$p($g(^PAPER(oldPapmiDR,"ALL")),"^",1)        ;oldName
					set isCancle="Y"
				}
			}
			Continue:isCancle="Y"
			set data=$lb(papmiNo,papmiDR,name,paadmId,locDesc,admDate,mrNO,oldPapmiNo,oldPapmiDR,oldName)
			set ^CacheTemp(repid,ind)=data
			set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod GetEmptyMrNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEmptyMrNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod GetEmptyMrNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEmptyMrNoExecute ]
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

/// Creator:wangCS
/// CreateDate:2011-10-20
/// Description:根据病人EpisodeID 判断该病人的病案号是否空，
///            如果空，从DHC_WMR_Main取出病案号更新到pa_patmas.papmi_medicare字段
/// Input:EpisodeID  病人就诊ID paadm
/// Output:成功"OK" 失败"NO"
/// Debug: w ##Class(web.DHCWMRNoCtl).UpdateEmptyMrNO(77290)
ClassMethod UpdateEmptyMrNO(EpisodeID)
{
	new (EpisodeID)
	set ret="OK"
	q:EpisodeID=""
	;^PAADM({PAADM_RowID})
	set papmi=$p($g(^PAADM(EpisodeID)),"^",1)  ;papmidr
	;^PAPER({PAPMI_RowId}) "PAT",1
	set mrNo=$p($g(^PAPER(papmi,"PAT",1)),"^",22) ;papmi_medicare
	;^DHCWMRMAIN(0,"PAPMI",{Papmi_Dr},{Rowid})
	set rowId=0
	set rowId=$o(^DHCWMRMAIN(0,"PAPMI",papmi,rowId))
	q:rowId=""
	;^DHCWMRMAIN({Rowid})
	set WMRMrNo=$p($g(^DHCWMRMAIN(rowId)),"^",2)  ;dhcwmr mrNo
	;b ;WMRMrNo
	if (mrNo'=WMRMrNo){
		&SQL(update pa_patmas set papmi_medicare=:WMRMrNo where papmi_rowid=:papmi)
		;b ;w !,SQLCode
		if ('SQLCODE){
			set ret="OK"	
		}else {
			set ret="NO"
		}
	}
	q ret
}

/// Creator:wangcs
/// CreateDate:2013-04-27
/// Description：获取病案号根据病案类型
ClassMethod GetMrNoByMrType(MrType As %String)
{
   New (MrType)
   Set MrNo=""
   If ($d(^DHCWMRNO(0,"TypeActive",MrType,"Y"))){
	   Set NoRowID=$o(^DHCWMRNO(0,"TypeActive",MrType,"Y",""))
	   Set PMrNo=$p($g(^DHCWMRNO(NoRowID)),"^",2)
   }Else{
		Set CurrentNo=+$g(^DHCWMRNOTYPE("CurrentNo",MrType))  
		Set MaxNo=CurrentNo+1
		Set:MaxNo'="" PMrNo=##class(web.DHCWMRMedBaseCtl).FormatMrNo(MrType,MaxNo)
   }
   Set MrNo=PMrNo
   Quit MrNo
}

/// Creator:wangcs
/// CreateDate:2013-04-27
/// Description：更新病案号为当前最大号
ClassMethod UpdateMrNoByMrType(MrType As %String)
{
   New (MrType)
   Set Rtn=""
   Set CurrentNo=+$g(^DHCWMRNOTYPE("CurrentNo",MrType))  
   Set MaxNo=CurrentNo+1
   Set ^DHCWMRNOTYPE("CurrentNo",MrType)=MaxNo
   Quit MaxNo
}

}

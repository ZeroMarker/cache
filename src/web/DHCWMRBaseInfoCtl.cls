Import SQLUser

/// 基本信息查询
/// By wuqk 2007-03
/// Modify by 2007-05-22  for Structure Rebuild
Class web.DHCWMRBaseInfoCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 85;

/// 根据病案rowid取病人基本信息
/// w ##Class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(17024)
ClassMethod GetBaseInfoByMain(MainRowid)
{
	n (MainRowid)
    s sBaseInfo=""
    ;s sMain=$$GetMainById^DHCWMRMain(+MainRowid)
    s sMain=##class(web.DHCWMRMainCtl).GetMainById(+MainRowid)
    q:sMain="" sBaseInfo
    s PAPMIRowId=$p(sMain,"^",4)
    s HistoryRowId=$p(sMain,"^",5)
    i PAPMIRowId'=""  d
    .;s sBaseInfo=$$FormatBaseInfo(+PAPMIRowId)
    .s sBaseInfo=..FormatBaseInfo(+PAPMIRowId,MainRowid)
    i sBaseInfo="" d
    .;s sPapmi=$$GetHistoryById^DHCWMRHistory(+HistoryRowId)
    .s sPapmi=""
    .s:HistoryRowId'="" sPapmi=##class(web.DHCWMRHistoryCtl).GetHistoryById(+HistoryRowId)
    .s:sPapmi'="" sBaseInfo=sPapmi_"^"_""_"^"_""     ;Papmi,PatitneNO
    q sBaseInfo
}

/// 格式化基本信息
/// w ##class(web.DHCWMRBaseInfoCtl).FormatBaseInfo(Papmi, MainRowid)
ClassMethod FormatBaseInfo(Papmi, MainRowid)
{

    n (Papmi,MainRowid)
    ;s sPapmi=$$GetPatInfo^DHCWMRMedBase(+Papmi)
    ;update by zf 2008-04-20
    ;在没有就诊记录的情况下取病人基本信息，GetPatInfo取病人信息为空
    ;s sPapmi=##class(web.DHCWMRMedBaseCtl).GetPatInfo(+Papmi)
    s sPapmi=##class(web.DHCWMRMedBaseCtl).GetPatInfoTMP(+Papmi)
    s NameSpell=..GetNameSpell(MainRowid)
    s sBaseInfo=""
    s $p(sBaseInfo,"^",1)=""                     ;Rowid/DHC_WMR_HistoryRowID    
    s $p(sBaseInfo,"^",2)=$p(sPapmi,$c(2),1)     ;PatientName/病人姓名          
    s $p(sBaseInfo,"^",3)=NameSpell              ;NameSpell/姓名拼音码          
    s $p(sBaseInfo,"^",4)=$p(sPapmi,$c(2),2)     ;Sex/性别                      
    s $p(sBaseInfo,"^",5)=$p(sPapmi,$c(2),3)     ;Birthday/生日                 
    s $p(sBaseInfo,"^",6)=$p(sPapmi,$c(2),4)     ;Age/年龄     
    s:$p(sBaseInfo,"^",6)["岁" $p(sBaseInfo,"^",6)=$e($p(sBaseInfo,"^",6),0,$l($p(sBaseInfo,"^",6))-1)                 
    s $p(sBaseInfo,"^",7)=$p(sPapmi,$c(2),7)     ;Wedlock/婚姻                  
    s $p(sBaseInfo,"^",8)=$p(sPapmi,$c(2),24)    ;Occupation/职业               
    s $p(sBaseInfo,"^",9)=$p(sPapmi,$c(2),6)     ;City/出生市                   
    s $p(sBaseInfo,"^",10)=""                     ;County/出生县                 
    s $p(sBaseInfo,"^",11)=$p(sPapmi,$c(2),8)     ;Nation/民族                   
    s $p(sBaseInfo,"^",12)=$p(sPapmi,$c(2),19)    ;Nationality/国籍   
    s:$p(sBaseInfo,"^",12)["-" $p(sBaseInfo,"^",12)=$p($p(sBaseInfo,"^",12),"-",2)           
    s $p(sBaseInfo,"^",13)=$p(sPapmi,$c(2),5)     ;IdentityCode/身份证号         
    s $p(sBaseInfo,"^",14)=$p(sPapmi,$c(2),11)    ;Company/工作单位              
    ;s $p(sBaseInfo,"^",15)=$p($g(^PAPER(Papmi,"PER",4)),"^",18)  				;CompanyTel/工作单位电话       PAPER_SecondPhone
    s $p(sBaseInfo,"^",15)=##Class(web.DHCWMRMedBaseCtl).xGetMobPhone(Papmi)		;Modified By liuxuefeng 2009-06-01
    s $p(sBaseInfo,"^",16)="" ;$p(sPapmi,$c(2),)  ;CompanyZip/工作单位邮编       
    s $p(sBaseInfo,"^",17)=$p(sPapmi,$c(2),18)    ;HomeAddress/家庭住址          
    s $p(sBaseInfo,"^",18)=$p(sPapmi,$c(2),9)     ;HomeTel/家庭电话              
    s $p(sBaseInfo,"^",19)=..GetHomeZip(Papmi)  ;HomeZip/家庭邮编              
    s $p(sBaseInfo,"^",20)=$p(sPapmi,$c(2),12)    ;RelationDesc/与联系人关系     
    s $p(sBaseInfo,"^",21)=$p(sPapmi,$c(2),14)    ;RelativeName/联系人           
    s $p(sBaseInfo,"^",22)=$p(sPapmi,$c(2),15)    ;RelativeTel/联系人电话        
    s $p(sBaseInfo,"^",23)=$p(sPapmi,$c(2),13)    ;RelativeAddress/联系人地址    
    s $p(sBaseInfo,"^",24)="Y"                    ;IsActive/是否有效             
    s $p(sBaseInfo,"^",25)=""                     ;ResumeText/备注   
    s $p(sBaseInfo,"^",26)=$p(sPapmi,$c(2),22)    ;Papmi
    s $p(sBaseInfo,"^",27)=$p(sPapmi,$c(2),23)    ;PatitneNO
    q sBaseInfo
}

/// 取姓名拼音码  
ClassMethod GetNameSpell(MainRowid)
{
    n (MainRowid)
    s s=""
    ;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})
    q:'$d(^DHCWMRVOL(0,"Main",+MainRowid)) s
    s LastVol=+$o(^DHCWMRVOL(0,"Main",+MainRowid,""),-1)
    ;^DHCWMRVOLINFO(0,"VOL",{Volume_Dr},{Rowid})
    q:'$d(^DHCWMRVOLINFO(0,"VOL",LastVol)) s
    s VolInfoId=+$o(^DHCWMRVOLINFO(0,"VOL",LastVol,""),-1)
    s s=$p($g(^DHCWMRVOLINFO(VolInfoId)),"^",2)
    q s
}

/// 取邮编
ClassMethod GetHomeZip(Papmi)
{
    n (Papmi)
    s s=""
    s ZipDR=$p($g(^PAPER(+Papmi,"PER",1)),"^",7)   ;Zip_DR
    q:ZipDR="" s
    s s=$p($g(^CT("ZIP",ZipDR)),"^",1)   
    q s
}

/// 根据卷rowid取卷就诊信息
ClassMethod GetAdmInfoByVol(VolRowid)
{

    n (VolRowid)
    ;s MainRowid=+VolRowid
    ;s VolChildSub=$p(VolRowid,"||",2)
    s sAdmInfo=""
    ;s sVol=$$GetVolume^DHCWMRMainVolume(MainRowid,VolChildSub)
    s sVol=##class(web.DHCWMRVolumeCtl).GetVolume(VolRowid)
    s paadm=$p(sVol,"^",3)             //2007-04-17   ZF
    s HistoryAdm=$p(sVol,"^",4)
    
    i paadm'="" d
    .;s sAdmInfo=$$GetAdmListInfo(MainRowid,VolChildSub)
    .s sAdmInfo=..GetAdmListInfo(VolRowid)
    .s:sAdmInfo'="" sAdmInfo=sAdmInfo_"^"_paadm
    e  d
    .;s sAdmInfo=$$GetHistoryAdmById^DHCWMRHistory(+HistoryAdm)
    .s sAdmInfo=##class(web.DHCWMRHistoryCtl).GetHistoryAdmById(+HistoryAdm)
    .s:sAdmInfo'="" sAdmInfo=sAdmInfo_"^"_""
    
    q sAdmInfo
}

/// 格式化卷就诊信息
ClassMethod GetAdmListInfo(VolRowid)
{
	
    n (VolRowid)
    
    s sAdmInfo=""

    ;q:'$d(^DHCWMRMAIN(MainRowid,"V",VolChildSub,"ADM")) sAdmInfo
    ;^DHCWMRMAIN({DHC_WMR_Main.Rowid},"V",{DHC_WMR_MainVolume.ChildSub},"ADM",{ChildSub})
    /*
    s firstChild=$o(^DHCWMRMAIN(MainRowid,"V",VolChildSub,"ADM","0"))
    s LastChild=$o(^DHCWMRMAIN(MainRowid,"V",VolChildSub,"ADM",""),-1)

    s firstAdm=+$g(^DHCWMRMAIN(MainRowid,"V",VolChildSub,"ADM",firstChild))
    s LastAdm=+$g(^DHCWMRMAIN(MainRowid,"V",VolChildSub,"ADM",LastChild))
    */
    
    
    s firstChild=+$o(^DHCWMRVOL(VolRowid,"ADM","0"))
    s LastChild=+$o(^DHCWMRVOL(VolRowid,"ADM",""),-1)

    s firstAdm=+$g(^DHCWMRVOL(VolRowid,"ADM",firstChild))
    s LastAdm=+$g(^DHCWMRVOL(VolRowid,"ADM",LastChild))
    
    s firstTmp=$g(^PAADM(+firstAdm))
    
    s LastTmp=$g(^PAADM(+LastAdm))
    ;取出院日期和时间
    s tmpDateTime=##Class(web.DHCWMRBasePaadm).GetDisAdmDate(+LastAdm)
    s DisDate=$p(tmpDateTime," ",1)
    s DisTime=$p(tmpDateTime," ",2)
    ;s Ward=+$p(tmp,"^",70)
    ;s:Ward'=0 WardDesc=$p($g(^PAWARD(Ward)),"^",2)
    
    s TmpDiagnose=##class(web.DHCWMRBasePaadm).GetMrDiagnose(LastAdm)  ;$$GetMrDiagnose^DHCWMRMedBasePaadm(LastAdm)
    s sDiagnose=""
    f i=1:1:($l(TmpDiagnose,$c(1))-1) d
    .s Temp=$p(TmpDiagnose,$c(1),i)
    .s ICDDR=$p(Temp,$c(2),5)
    .s sDiagnose=sDiagnose_$p(ICDDR,"/",3)_";"
    
    s $p(sAdmInfo,"^",1)=""               ;Rowid/DHC_WMR_HistoryAdmRowID
    s $p(sAdmInfo,"^",2)=""               ;History_Dr/历史基本信息
    s $p(sAdmInfo,"^",3)=$zd($p(firstTmp,"^",6),3)               ;AdmitDate/就诊日期
    s $p(sAdmInfo,"^",4)=$zt($p(firstTmp,"^",7))               ;AdmitTime/就诊时间
    s $p(sAdmInfo,"^",5)=$p(##class(web.DHCWMRMedBaseCtl).GetCtlocStr(+$p(firstTmp,"^",4)),"/",2)
    ;$p($$GetCtlocStr^DHCWMRMedBase(+$p(firstTmp,"^",4)),"/",2)   ;AdmitDep/就诊科室
    s $p(sAdmInfo,"^",6)=##class(web.DHCWMRBasePaadm).GetAdmPatCondition(+firstAdm)       ;AdmitStatus/就诊时状态
    
    ;出院日期和时间
    ;update by zf 2008-10-16
    s $p(sAdmInfo,"^",7)=DisDate   ;DischargeDate/出院日期
    s $p(sAdmInfo,"^",8)=DisTime   ;DischargeTime/出院时间
    ;s $p(sAdmInfo,"^",7)=$s($p(LastTmp,"^",17)'="":$zd($p(LastTmp,"^",17),3),1:"")              ;DischargeDate/出院日期
    ;s $p(sAdmInfo,"^",8)=$s($p(LastTmp,"^",18)'="":$zt($p(LastTmp,"^",18)),1:"")               ;DischargeTime/出院时间
    
    s $p(sAdmInfo,"^",9)=$p(##class(web.DHCWMRMedBaseCtl).GetCtlocStr(+$p(LastTmp,"^",4)),"/",2)
    ;$p($$GetCtlocStr^DHCWMRMedBase(+$p(LastTmp,"^",4)),"/",2)    ;DischargeDep/出院科室
    s $p(sAdmInfo,"^",10)=sDiagnose               ;Diagnose/诊断
    s $p(sAdmInfo,"^",11)="Y"               ;IsActive/是否有效
    s $p(sAdmInfo,"^",12)=""                ;ResumeText/备注
    
    q sAdmInfo
}

ClassMethod QueryPatConditionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatConditionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryPatConditionExecute(ByRef qHandle As %Binary) As %Status
{
	;^MRC("COND",{COND_RowId})
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s Rowid="0"
	f  s Rowid=$o(^MRC("COND",Rowid)) q:Rowid=""  d
	.s Desc=$p($g(^MRC("COND",Rowid)),"^",2)
	.s DateFrom=$p($g(^MRC("COND",Rowid)),"^",3)
	.s DateTo=$p($g(^MRC("COND",Rowid)),"^",4)
	.q:(DateFrom'="")&(DateFrom>+$h)
	.q:(DateTo'="")&(DateTo<+$h)
	.d BuildPatCondition
	Quit $$$OK
BuildPatCondition
	set Data=$lb(+Rowid,Desc)	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryPatConditionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatConditionExecute ]
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

/// 查询入院时情况
Query QueryPatCondition() As %Query(ROWSPEC = "Rowid:%String,Description:%String")
{
}

/// 患者姓名转换拼音全拼
/// ^DHCWMRPYWB("汉字","拼音")=""
/// GBK大字库汉字对应拼音 + 全角数字和字母 + 半角数字和字母
/// w ##Class(web.DHCWMRBaseInfoCtl).ChangeNameToSpell(strName)
ClassMethod ChangeNameToSpell(strName)
{
	n (strName)
	s ret=""
	s strName=$tr(strName," ","")
	f ind=1:1:$l(strName) d
	.s tmp=$e(strName,ind,ind)
	.q:'$d(^DHCWMRPYWB(tmp))
	.s ret=ret_$o(^DHCWMRPYWB(tmp,""))
	q ret
}

/// w ##Class(web.DHCWMRBaseInfoCtl).ChangeNameToSpell000("仇行过")
ClassMethod ChangeNameToSpell000(strName)
{
	n (strName)
	s ret=""
	
	s strName=$tr(strName," ","")
	f ind=1:1:$l(strName) d
	.s tmp=$e(strName,ind,ind)
	.q:'$d(^DHCWMRPYWB(tmp))
	.s tmpPY="",tmpret=ret,flg=0
	.f  s tmpPY=$o(^DHCWMRPYWB(tmp,tmpPY)) q:tmpPY=""  d
	..i flg=0 d
	...f ind1=1:1:$l(ret,"^") d
	....s $p(ret,"^",ind1)=$p(ret,"^",ind1)_tmpPY
	...s flg=1
	..e  d
	...s tmpret1=tmpret
	...f ind1=1:1:$l(tmpret1,"^") d
	....s $p(tmpret1,"^",ind1)=$p(tmpret1,"^",ind1)_tmpPY
	...s ret=ret_"^"_tmpret1
	
	q ret
}

/// w ##Class(web.DHCWMRBaseInfoCtl).CheckNameSpell()
ClassMethod CheckNameSpell()
{
	n
	
	;^DHCWMRHISTORY({Rowid})  Name-1,Spell-2
	s Rowid=0
	f  s Rowid=$o(^DHCWMRHISTORY(Rowid)) q:Rowid=""  d
	.s Name=$p($g(^DHCWMRHISTORY(Rowid)),"^",1)
	.s NameSpell="^"_..ChangeNameToSpell000(Name)_"^"
	.i ($p($g(^DHCWMRHISTORY(Rowid)),"^",2)'="")&&(NameSpell'[("^"_$p($g(^DHCWMRHISTORY(Rowid)),"^",2))_"^") d
	..s ^ZFH(Rowid)=Name_"  "_NameSpell_"  "_$p($g(^DHCWMRHISTORY(Rowid)),"^",2)
	
	;^DHCWMRVOLINFO({Rowid})  Name-1,Spell-2
	s Rowid=0
	f  s Rowid=$o(^DHCWMRVOLINFO(Rowid)) q:Rowid=""  d
	.s Name=$p($g(^DHCWMRVOLINFO(Rowid)),"^",1)
	.s NameSpell="^"_..ChangeNameToSpell000(Name)_"^"
	.i ($p($g(^DHCWMRVOLINFO(Rowid)),"^",2)'="")&&(NameSpell'[("^"_$p($g(^DHCWMRVOLINFO(Rowid)),"^",2))_"^") d
	..s ^ZFV(Rowid)=Name_"  "_NameSpell_"  "_$p($g(^DHCWMRVOLINFO(Rowid)),"^",2)
	
	q "Over!"
}

/// w ##Class(web.DHCWMRBaseInfoCtl).CalAge(argBirthday,argToday)
ClassMethod CalAge(argBirthday As %String, argToday As %String) As %String
{
	New (argBirthday,argToday)
	Set return=""
	Quit:(argBirthday="")||(argToday="") return
	Set argBirthday=+argBirthday
	Set argToday=+argToday
    Quit:(argBirthday=0)||(argToday=0)||(argBirthday>argToday) return
    Set argBirthday=$zd(argBirthday,3)
    Set argToday=$zd(argToday,3)
    Set AgeYear=$p(argToday,"-",1)-$p(argBirthday,"-",1)
    Set AgeMth=$p(argToday,"-",2)-$p(argBirthday,"-",2)
    Set AgeDay=$p(argToday,"-",3)-$p(argBirthday,"-",3)
	If AgeDay<0 {
		Set AgeMth=AgeMth-1
		Set AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+$p(argToday,"-",2))
		If $p(argToday,"-",2)=2 {
			Set:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
		}
	}
	If AgeMth<0 {
	    Set AgeYear=AgeYear-1
	    Set AgeMth=12+AgeMth
	}
    If AgeYear>0 {
	    Set return=AgeYear_"岁"
	} Else {
		Set:AgeMth>0 return=AgeMth_"月"
		Set return=return_AgeDay_"天"
	}
    Quit return
}

}

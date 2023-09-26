Import SQLUser

Class web.DHCWMRExamACRCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 52;

/// 4.3 自动质控规则库  DHC_WMR_AutoCheckRule
ClassMethod UpdateACRule(Instring)
{
    n (Instring)
    s ret=""
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateACRule^DHCWMRExamRule(Instring)
	zn CurrentNS
	q ret
}

/// DHC_WMR_AutoCheckRule
ClassMethod GetExamACRById(ACRId)
{
    n (ACRId)
    s ret=""
    q:+ACRId=0 ret
    ;^DHCWMRACR({RowId})
    q:'$d(^DHCWMRACR(+ACRId)) ret
    s ret=+ACRId_"^"_$g(^DHCWMRACR(+ACRId))
	q ret
}

/// DHC_WMR_AutoCheckRule
ClassMethod GetExamACRByRCode(RCode)
{
    n (RCode)
    s ret=""
    q:RCode="" ret
    ;^DHCWMRACR({RowId})
    q:'$d(^DHCWMRACR(0,"RCode",RCode)) ret
    s ACRId=$o(^DHCWMRACR(0,"RCode",RCode,0))
   	s ret=+ACRId_"^"_$g(^DHCWMRACR(+ACRId))
	q ret
}

/// DHC_WMR_AutoCheckRule
ClassMethod GetExamACRByDesc(alias)
{
    n (alias)
    s ret=""
    q:alias="" ret
    /*
    s alias="%"_alias_"%"
    &sql(declare cACR cursor for select * INTO :PLIST() from DHC_WMR_AutoCheckRule where Description like :alias)
    &sql(open cACR)
    f   &sql(fetch cACR) q:SQLCODE  d
    .s ret=ret_PLIST(1)_"^"_PLIST(2)_"^"_PLIST(3)_"^"_PLIST(4)_"^"_PLIST(5)_"^"_PLIST(6)_$c(1)
    &sql(close cACR)
    */
    k ^CacheTemp($zn,$j,"ACRExp")
    i (($p($p(alias,"-",1),"R",1)'="")||($p($p(alias,"-",2),"R",1)'="")) d
    .;^DHCWMRACR(0,"Desc",{Description},{RowId})
    .s Desc=$o(^DHCWMRACR(0,"Desc",alias),-1),Count=0
    .f  s Desc=$o(^DHCWMRACR(0,"Desc",Desc)) q:(Desc="")||($e(Desc,1,$l(alias))'=alias)||(Count>200)  d
    ..s Rowid=0
    ..f  s Rowid=$o(^DHCWMRACR(0,"Desc",Desc,Rowid)) q:(Rowid="")||(Count>200)  d
    ...;s tmpAutoCheckRule=$g(^DHCWMRACR(Rowid))
    ...;q:tmpAutoCheckRule=""
    ...;s ret=ret_tmpAutoCheckRule_$c(1)
    ...s ^CacheTemp($zn,$j,"ACRExp",Rowid)=""
    ...s Count=Count+1
    e  d
    .s StartRowid=+$p($p(alias,"-",1),"R",2)
    .s EndRowid=+$p($p(alias,"-",2),"R",2)
    .s Rowid=+$p($p(alias,"-",1),"R",2),Count=0
    .s:Rowid>0 Rowid=Rowid-1
    .f  s Rowid=$o(^DHCWMRACR(Rowid)) q:((Rowid="")||(Count>200)||(Rowid>EndRowid))  d
    ..s ^CacheTemp($zn,$j,"ACRExp",Rowid)=""
    ..s Count=Count+1
    
    s Rowid=0
    f  s Rowid=$o(^CacheTemp($zn,$j,"ACRExp",Rowid)) q:Rowid=""  d
    .s s=..GetExamACRById(+Rowid)
    .s ret=ret_s_$c(1)
    k ^CacheTemp($zn,$j,"ACRExp")
    
    s:ret'="" ret=$e(ret,1,$l(ret)-1)
	q ret
}

/// DHC_WMR_AutoCheckRule
ClassMethod GetExamACRAll()
{
    n 
    s ret=""
    s ACRRowId=0,Count=0
    f  s ACRRowId=$o(^DHCWMRACR(ACRRowId)) q:(ACRRowId="")||(Count>200)  d
    .s s=..GetExamACRById(+ACRRowId)
    .s ret=ret_s_$c(1)
    .s Count=Count+1
    s:ret'="" ret=$e(ret,1,$l(ret)-1)
	q ret
}

ClassMethod ExpEntryExpression(Expression)
{
	//***************************************
	//;Get RCode from DHC_WMR_ExamEntry.Expression
    //;split by $c(1)
	//*****************************************
	n (Expression)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	Set ret=$$ExpEntryExpression^DHCWMRQualityExplain(Expression)
	zn CurrentNS
	Quit ret
}

ClassMethod GetACRExpTemplate(Expression)
{
	//***************************************
	//;Get TemplateId from DHC_WMR_AutoCheckRule.Expression
    //;split by $c(2)
	//*****************************************
	n (Expression)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	Set ret=$$GetACRExpTemplate^DHCWMRQualityExplain(Expression)
	zn CurrentNS
	Quit ret
}

ClassMethod GetACRExpTempIndex(Expression)
{
	//***************************************
	//;Get TempIndex(Id.SmipleCode) from DHC_WMR_AutoCheckRule.Expression
    //;split by $c(2)
	//*****************************************
	n (Expression)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	Set ret=$$GetACRExpTempIndex^DHCWMRQualityExplain(Expression)
	zn CurrentNS
	Quit ret
}

ClassMethod GetACRExpByRCode(RCode)
{
	//***************************************
	//;Get DHC_WMR_AutoCheckRule.Expression by DHC_WMR_AutoCheckRule.RCode
    //*****************************************
	n (RCode)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	Set ret=$$GetACRExpByRCode^DHCWMRQualityExplain(RCode)
	zn CurrentNS
	Quit ret
}

ClassMethod GetEntExpTemplate(Expression)
{
	//***************************************
	//;Get TemplateIndex from DHC_WMR_ExamEntry.Expression
	//;split by $c(2)
    //*****************************************
	n (Expression)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	Set ret=$$GetEntExpTemplate^DHCWMRQualityExplain(Expression)
	zn CurrentNS
	Quit ret
}

/// 2008-08-06 LiYang 
/// 将DHC_WMR_AutoCheckRule.Expression转换为$c(4)分隔
ClassMethod ReplaceChar(str)
{
	n (str)
	/*  //by wuqk 2008-08-07
	set intCounter = 0
	for intCounter=1:1:$l(str)
	{
		set:$e(str,intCounter)="/" $e(str,intCounter)=$c(4)
	}
	*/
	quit str
}

ClassMethod ReplaceOld()
{
	set ID = "0"
	f  s ID=$o(^DHCWMRACR(ID))  q:ID=""  d
	.s ^DHCWMRACR(ID)=$tr($g(^DHCWMRACR(ID)),"/",$c(4))
	q 0
	/*   //by wuqk 2008-08-07
	set ID = "0"
	set strData = ""
	do
	{
		set ID = $o(^DHCWMRACR(ID))
		if (ID '= "")
		{
			set strData = ID _ "^"_ $g(^DHCWMRACR(ID))
			set strData = ..ReplaceChar(strData)
			w ..UpdateACRule(strData)
			w !, strData
		}
	}while (ID '= "")
	quit 0
    */
}

ClassMethod ReplaceBlank()
{
	set ID = "0"
	f  s ID=$o(^DHCWMRACR(ID))  q:(ID="")  d
	.s str=$g(^DHCWMRACR(ID))
	.s Exp=$p(str,"^",2)
	.s Len=$l(Exp,$c(4))
	.;w !,"ID="_ID_"  oldExp="_Exp ;b  ;1
	.i '($ISVALIDNUM($p(Exp,$c(4),Len)))  d
	..s $p(Exp,$c(4),Len)=""""""
	..w !,"ID="_ID_"  Exp="_Exp ;b  ;2
	..s $p(str,"^",2)=Exp
	..s ^DHCWMRACR(ID)=str
	q 0
}

}

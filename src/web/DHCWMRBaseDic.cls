Import SQLUser

Class web.DHCWMRBaseDic Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 77;

/// ret="{'total':'"_count_"','record':["_record_"]}"
/// record="{id:"_"'"_id_"',code:'"_code_"',desc:'"_desc_"',resume='"_resume_"'}"
/// fields:
/// id
/// code
/// desc
/// resume
ClassMethod GetAjaxList(DicName, Alias) As %String
{
	n (DicName,Alias)
	set ret=""
	quit:DicName="" ret
	set SysFlag=$$ALPHAUP^SSUTIL4(DicName)
	
	if SysFlag="CTLOC"
	{
		set ret=..GetCTLocByDesc(Alias)
	}
	elseif SysFlag="WARD"
	{
	}
	elseif SysFlag="SSUSER"
	{
		set ret=..GetSSUserByName(Alias)
	}
	elseif SysFlag="DOCTOR"
	{
		set tmp =$$ALPHAUP^SSUTIL4(Alias)
		set strDoctorName = ""
		set Py = tmp //留一个样本用来比较		
		set strHos = ##class(web.DHCWMRMedBase01).GetDefaultHosp()
		set intCounter = 0
		quit:tmp="" ""
		if ($p(strHos,"/",4) = "BeiJing_YY")
		{
			while (1)
			{
				set strDoctorName = $o(^DHCWMRDoctorPinYin(tmp, strDoctorName))
				quit:(strDoctorName="")
				set:ret'="" ret = ret _ $c(1)
				set ret = ret_ "-" _ intCounter _ "^" _ intCounter _ "^" _ strDoctorName _ "^"
				set intCounter = intCounter + 1
			}
			while (1)
			{
				set tmp = $o(^DHCWMRDoctorPinYin(tmp))
				quit:(tmp = "")!(tmp '[ Py)!(intCounter > 20)
				set strDoctorName = ""
				while (1)
				{
					set strDoctorName = $o(^DHCWMRDoctorPinYin(tmp, strDoctorName))
					quit:strDoctorName=""
					set:ret'="" ret = ret _ $c(1)
					set ret = ret _ "-"_intCounter_"^"_intCounter_"^"_strDoctorName_"^"
					set intCounter = intCounter + 1	
				}	
			} 
		}
		else
		{
			set ret=..GetDocByName(Alias)
		}
		//b
		
	}
	else
	{
		;DHC_WMR_Dictionary
		set ret=..GetWMRDicList(DicName,Alias)
	}
	set ret=..BuildAjaxList(ret)
	quit ret
}

ClassMethod GetCTLocByDesc(Desc As %String)
{
	n (Desc)
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s record=""
	s alias=Desc
	i $d(^CTLOC(0,"Desc",alias)) d
	.s id=0
	.f  s id=$o(^CTLOC(0,"Desc",alias,id)) q:id=""  d
	..s tmprecord=$$BuildCtloc(id)
	..s record=record_tmprecord_$c(1)
	f  s alias=$o(^CTLOC(0,"Desc",alias)) q:(alias="")!(alias'[Desc)  d
	.s id=0
	.f  s id=$o(^CTLOC(0,"Desc",alias,id)) q:id=""  d
	..s tmprecord=$$BuildCtloc(id)
	..s record=record_tmprecord_$c(1)
	
	s:record'="" record=$e(record,1,$l(record)-1)
	q record
BuildCtloc(ctloc)
    n (ctloc)
    s s=$g(^CTLOC(ctloc))
    s id=ctloc
    s code=$p(s,"^",1)
    s desc=$p(s,"^",2)
    s:desc["-" desc=$p(desc,"-",$l(desc,"-"))
    s resume=""
    s ret=id_"^"_code_"^"_desc_"^"_resume
    q ret
}

ClassMethod GetSSUserByName(Name As %String)
{
	n (Name)
	s count=0
	s record=""
	/*
	i $d(^SSU("SSUSR",0,"SSUSR_Name",Name)) d
	.s Rowid=$o(^SSU("SSUSR",0,"SSUSR_Name",Name,Rowid))
	.q:$p($g(^SSU("SSUSR",+Rowid)),"^",19)'="Y"
	.s tmprecord=$$BuildUser(Rowid)
	.s record=record_tmprecord_$c(1)
    
    s tmpName=Name
    f  s tmpName=$o(^SSU("SSUSR",0,"SSUSR_Name",tmpName)) q:(tmpName="")!(tmpName'[Name)  d
    .s Rowid=""
    .f  s Rowid=$o(^SSU("SSUSR",0,"SSUSR_Name",tmpName,Rowid)) q:Rowid=""  d
	..q:$p($g(^SSU("SSUSR",+Rowid)),"^",19)'="Y"
	..s tmprecord=$$BuildUser(Rowid)
	..s record=record_tmprecord_$c(1)
	*/
    s Name=$$ALPHAUP^SSUTIL4(Name)
    s Rowid=0
    f  s Rowid=$o(^SSU("SSUSR",Rowid)) q:Rowid=""  d
	.q:$p($g(^SSU("SSUSR",+Rowid)),"^",19)'="Y"
    .s UserName=$p($g(^SSU("SSUSR",+Rowid)),"^",2)
    .s UserPinYin=$p($g(^SSU("SSUSR",+Rowid)),"^",11)
    .s UserPinYin=$ZCVT(UserPinYin,"U") //add by wangcs 2012-12-05
    .q:(Name'="")&&($e(UserName,1,$l(Name))'=Name)&&($e(UserPinYin,1,$l(Name))'=Name)
	.s tmprecord=$$BuildUser(Rowid)
	.s record=record_tmprecord_$c(1)
    s:record'="" record=$e(record,1,$l(record)-1)
	q record
    
    
BuildUser(Rowid)
    n (Rowid)
    s ret=""
    s s=$g(^SSU("SSUSR",+Rowid)) 
    s id=+Rowid
    s code=$p(s,"^",1)
    s desc=$p(s,"^",2)
    s:desc["-" desc=$p(desc,"-",$l(desc,"-"))
    s ctloc=$p(s,"^",5)
    s resume=$p($g(^CTLOC(+ctloc)),"^",2)
    s:resume["-" demo=$p(resume,"-",$l(resume,"-"))
    s ret=id_"^"_code_"^"_desc_"^"_resume
    q ret
    
CheckDoctor(Rowid)
    n (Rowid)
    s flag=0
    q:Rowid="" flag
    q:'$d(^SSU("SSUSR",+Rowid)) flag
    s usrCareProvDR=$p($g(^SSU("SSUSR",+Rowid)),"^",14)
    q:usrCareProvDR="" flag
    q:'$d(^CTPCP(usrCareProvDR)) flag
    s activeFlag=$p($g(^CTPCP(usrCareProvDR,1)),"^",9)
    q:activeFlag'="Y" flag
    
    s CarPrvTpDr=$p($g(^CTPCP(usrCareProvDR,1)),"^",4)
    q:CarPrvTpDr="" flag
    
    q:'$d(^CT("CPT",CarPrvTpDr)) flag
    s InternalType=$p($g(^CT("CPT",CarPrvTpDr)),"^",4)
    
    q:InternalType'="DOCTOR" flag
    
    s flag=1
    q flag
}

ClassMethod GetDocByName(Name As %String)
{
	n (Name)
	s count=0
	s record=""
	q:Name="" record
	/*
	i $d(^SSU("SSUSR",0,"SSUSR_Name",Name)) d
	.s Rowid=$o(^SSU("SSUSR",0,"SSUSR_Name",Name,""))
	.q:$p($g(^SSU("SSUSR",+Rowid)),"^",19)'="Y"
	.q:$$CheckDoctor(Rowid)=0
	.s tmprecord=$$BuildUser(Rowid)
	.s record=record_tmprecord_$c(1)
    
    s tmpName=Name
    f  s tmpName=$o(^SSU("SSUSR",0,"SSUSR_Name",tmpName)) q:(tmpName="")!(tmpName'[Name)  d
    .s Rowid=""
    .f  s Rowid=$o(^SSU("SSUSR",0,"SSUSR_Name",tmpName,Rowid)) q:Rowid=""  d
	..q:$p($g(^SSU("SSUSR",+Rowid)),"^",19)'="Y"
	..q:$$CheckDoctor(Rowid)=0
	..s tmprecord=$$BuildUser(Rowid)
	..s record=record_tmprecord_$c(1)
	*/
	s Name=$$ALPHAUP^SSUTIL4(Name)
    s Rowid=0
    f  s Rowid=$o(^SSU("SSUSR",Rowid)) q:Rowid=""  d
	.q:$p($g(^SSU("SSUSR",+Rowid)),"^",19)'="Y"
    .s UserName=$p($g(^SSU("SSUSR",+Rowid)),"^",2)
    .s UserPinYin=$p($g(^SSU("SSUSR",+Rowid)),"^",11)
    .;add by lyh 2012-12-15 从医护表中查询用户拼音
    .s CareProvDR=$p($g(^SSU("SSUSR",+Rowid)),"^",14)
    .s CareSMCNo=""
    .s:CareProvDR'="" CareSMCNo=$p($g(^CTPCP(CareProvDR,1)),"^",6)	//姓名拼音
    .q:(Name'="")&&($e(UserName,1,$l(Name))'=Name)&&($e(UserPinYin,1,$l(Name))'=Name)&&($e(CareSMCNo,1,$l(Name))'=Name)
	.s tmprecord=$$BuildUser(Rowid)
	.q:count>20
	.s record=record_tmprecord_$c(1)
	.s count=count+1

    s:record'="" record=$e(record,1,$l(record)-1)
	q record
}

ClassMethod GetDocByCode(Code As %String)
{
	;n (Code)
	s count=0
	s Code=$$ALPHAUP^SSUTIL4(Code)
	s record=""
	i $d(^SSU("SSUSR",0,"SSUSR_Initials",Code)) d
	.s Rowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",Code,""))
	.q:$p($g(^SSU("SSUSR",+Rowid)),"^",19)'="Y"
	.q:$$CheckDoctor(Rowid)=0
	.s tmprecord=$$BuildUser(Rowid)
	.s record=record_tmprecord_$c(1)
    
    s tmpCode=Code
    f  s tmpCode=$o(^SSU("SSUSR",0,"SSUSR_Initials",tmpCode)) q:(tmpCode="")!(tmpCode'[Code)  d
    .s Rowid=""
    .f  s Rowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",tmpCode,Rowid)) q:Rowid=""  d
	..q:$p($g(^SSU("SSUSR",+Rowid)),"^",19)'="Y"
	..q:$$CheckDoctor(Rowid)=0
	..s tmprecord=$$BuildUser(Rowid)
	..s record=record_tmprecord_$c(1)
    s:record'="" record=$e(record,1,$l(record)-1)
	q record
}

/// w ##Class(web.DHCWMRBaseDic).GetDocByRowid(1)
ClassMethod GetDocByRowid(Rowid As %String)
{
	n (Rowid)
	s record=""
	q:(+Rowid)=0 record
	s tmprecord=$$BuildUser(Rowid)
	s record=record_tmprecord_$c(1)
    s:record'="" record=$e(record,1,$l(record)-1)
	q record
}

ClassMethod GetWMRDicList(DicName As %String, Alias As %String)
{
	n (DicName,Alias)
	s count=0
	s record=""
	;s ret="{'total':'"_count_"','record':["_record_"]}"
	
	q:'$d(^DHCWMRDIC(0,"DicName",DicName,"Y")) record
    
    s WMRRowid=""
    f  s WMRRowid=$o(^DHCWMRDIC(0,"DicName",DicName,"Y",WMRRowid))  q:WMRRowid=""  d
    .s TextA=$p($g(^DHCWMRDIC(WMRRowid)),"^",6)
    .q:(Alias'="")&(TextA'[Alias)
    .s tmprecord=$$BuildWMRDic(WMRRowid)
	.s record=record_tmprecord_$c(1)
    	
    s:record'="" record=$e(record,1,$l(record)-1)
	
	q record
BuildWMRDic(Rowid)
    n (Rowid)
    s s=$g(^DHCWMRDIC(Rowid))
    s id=+Rowid
    s code=$p(s,"^",2)
    s desc=$p(s,"^",3)
    ;s:desc["-" desc=$p(desc,"-",$l(desc,"-"))
    s resume=""
    s ret=id_"^"_code_"^"_desc_"^"_resume
    ;s ret="{id:"_"'"_id_"',code:'"_code_"',desc:'"_desc_"',resume='"_resume_"'}"
    q ret
}

ClassMethod BuildAjaxList(str As %String)
{
	n (str)
	q:str="" "{'total':'"_0_"','record':[]}"
	s count=$l(str,$c(1))
	s record=""
	f i=1:1:count d
	.s tmprecord=$$BuildAjax($p(str,$c(1),i))
	.s:tmprecord'="" record=record_tmprecord_","
	s:record'="" record=$e(record,1,$l(record)-1)
	s ret="{'total':'"_count_"','record':["_record_"]}"
	q ret
BuildAjax(ShortStr)
    n (ShortStr)
    s AjaxStr=""
    q:ShortStr="" AjaxStr
    s AjaxStr="{id:"_"'"_$p(ShortStr,"^",1)
    s AjaxStr=AjaxStr_"',code:'"_$p(ShortStr,"^",2)
    s AjaxStr=AjaxStr_"',desc:'"_$p(ShortStr,"^",3)
    s AjaxStr=AjaxStr_"',resume:'"_$p(ShortStr,"^",4)_"'}"
    q AjaxStr
}

/// /GetItmDesc(DicName,Val)
ClassMethod GetItmDesc(DicName, Val) As %String
{
	n (DicName,Val)
	set ret=""
	set SysFlag=$$ALPHAUP^SSUTIL4(DicName)
	if SysFlag="CTLOC"
	{
		;set ret=..GetCTLocDesc(Val)
		q:'$d(^CTLOC(+Val)) ret
		s desc=$p($g(^CTLOC(+Val)),"^",2)
		s:desc["-" desc=$p(desc,"-",$l(desc,"-"))
		s ret=desc
	}
	elseif SysFlag="WARD"
	{
	}
	elseif SysFlag="SSUSER"
	{
		;set ret=..GetUserName(Val)
		q:'$d(^SSU("SSUSR",+Val)) ret
		s desc=$p($g(^SSU("SSUSR",+Val)),"^",2)
		;s:desc["-" desc=$p(desc,"-",$l(desc,"-"))
		s ret=desc
	}
	elseif SysFlag="DOCTOR"
	{
		;set ret=..GetUserName(Val)
		q:'$d(^SSU("SSUSR",+Val)) ret
		s desc=$p($g(^SSU("SSUSR",+Val)),"^",2)
		;s:desc["-" desc=$p(desc,"-",$l(desc,"-"))
		s ret=desc
	}
	else
	{
		;DHC_WMR_Dictionary
		;set ret=..GetWMRDicDesc(Val)
		q:'$d(^DHCWMRDIC(+Val)) ret
		s desc=$p($g(^DHCWMRDIC(+Val)),"^",2)
		;s:desc["-" desc=$p(desc,"-",$l(desc,"-"))
		s ret=desc
	}
	quit ret
}

}

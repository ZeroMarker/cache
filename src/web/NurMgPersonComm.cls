/// Creator：gzj
/// Description：Vue版人力资源公共类 
/// Date：2017-06-26
Class web.NurMgPersonComm Extends %RegisteredObject
{

/// Creator:gzj
/// Description:查询人员列表
/// Date:2017-06-26
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindPersons","1")
Query FindPersons(parr As %String = "", column As %String = "", order As %String = "", advflag As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonsExecute(ByRef qHandle As %Binary, parr As %String = "", column As %String = "", order As %String = "", advflag As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",rettmp=""
	s tmp=""
	i advflag="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	i advflag=0
	{
		s locVal=$P(parr,"!")
		s wardVal=$P(parr,"!",2)
		s nameVal=$P(parr,"!",3)
		;s noVal=$P(parr,"!",4)
		;s status=$P(parr,"!",4)
		s roleid=$P(parr,"!",4) //角色id 
		s nurseid=$p(parr,"!",5) // 人员id
	}
	i advflag=1
	{
		//parr=55^14||4^16||1^21||1^7||4^2||4^24||24^24||13 //^14||2,14||3^16||1,16||2^^^^^^0^0&&&1
		s wardVal=$p(parr,"!",1) //病区
		s hireVal=$p(parr,"!",2)  //职称
		s postVal=$p(parr,"!",3) //职务
		s levelVal=$p(parr,"!",4) //层级
		s sourceVal=$p(parr,"!",5) //护士来源
		s politVal=$p(parr,"!",6) //政治面貌
		s firEduVal=$p(parr,"!",7) //第一学历
		s maxEduVal=$p(parr,"!",8) //最高学历
		s roleid=$P(parr,"!",9) //角色id 
		s nurseid=$p(parr,"!",10) // 人员id
	}
	
	;s rolecode=##class(web.NurMgLoginComm).GetLoginRoleCode(roleid)
	i roleid=0
	{
		s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
		.s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
		..s RowID="" f  s RowID=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_id,RowID)) q:RowID=""  d
		...s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
		...q:(obj.PerTypeDR'="N")
		...q:((advflag=0)&&(locVal'="")&&(obj.PerLocDR'=locVal))
		...q:((advflag=0)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
		...q:((advflag=0)&&(nameVal'="")&&((obj.PerName_obj.PerID)'[nameVal))
		...q:((advflag=1)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
		...q:((advflag=1)&&(sourceVal'="")&&(sourceVal'[obj.PerSource))
		...q:((advflag=1)&&(politVal'="")&&(politVal'[obj.PerPolitical))
		...q:((advflag=1)&&(hireVal'="")&&(..CheckHireDuty(RowID,hireVal)=0))
		...q:((advflag=1)&&(postVal'="")&&(..CheckPost(RowID,postVal)=0))
		...q:((advflag=1)&&(levelVal'="")&&(..CheckLevel(RowID,levelVal)=0))
		...q:((advflag=1)&&(firEduVal'="")&&(..CheckEdu(RowID,firEduVal,"0")=0))
		...q:((advflag=1)&&(maxEduVal'="")&&(..CheckEdu(RowID,maxEduVal,"1")=0))
		...s NurseName=obj.PerName
		...s NurseID=obj.PerID
		...s NurseDep=$P($P($g(^CTLOC(obj.PerDepDR)),"^",2),"-",2)
		...s NurseDep=$list($g(^DHCNMG.DB.MgWardD(obj.PerDepDR)),4)
		...i obj.PerBirthday'="" s PerBirthday=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerBirthday)
		...e  s PerBirthday=""
		...s PerCardId=obj.PerCardId
		...s PerAge=""
		...i obj.PerBirthday'="" d
		....s age=##class(web.NurMgVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
		....s PerAge=$p(age,"Y",1)
		...i obj.PerComeDate'="" s PerComeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerComeDate)
		...e  s PerComeDate=""
		...s PerComeYear=""
		...i obj.PerComeDate'="" d
		....s comeyear=##class(web.NurMgVueComm).CalAge($zd(obj.PerComeDate,3),$zd(+$H,3))
		....s PerComeYear=$p(comeyear,"Y",1)
		...i obj.PerDepDate'="" s PerDepDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerDepDate)
		...e  s PerDepDate=""
		...i obj.PerWorkDate'="" s PerWorkDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerWorkDate)
		...e  s PerWorkDate=""
		...s PerRegNo=obj.PerRegNo
		...i obj.PerStatus'="" s PerStatus=..GetCommCode(obj.PerStatus)
		...e  s PerStatus=""
		...i obj.PerMarriage'="" s PerMarriage=..GetCommCode(obj.PerMarriage)
		...e  s PerMarriage=""
		...i obj.PerSource'="" s PerSource=..GetCommCode(obj.PerSource)
		...e  s PerSource=""
		...i obj.PerPolitical'="" s PerPolitical=..GetCommCode(obj.PerPolitical)
		...e  s PerPolitical=""
		...i obj.PerNation'="" s PerNation=..GetCommCode(obj.PerNation)
		...e  s PerNation=""
		...i obj.PerClothesNo'="" s PerClothesNo=..GetCommCode(obj.PerClothesNo)
		...e  s PerClothesNo=""
		...i obj.PerTrouserNo'="" s PerTrouserNo=..GetCommCode(obj.PerTrouserNo)
		...e  s PerTrouserNo=""
		...i obj.PerShoesNo'="" s PerShoesNo=..GetCommCode(obj.PerShoesNo)
		...e  s PerShoesNo=""
		...i obj.PerWordType'="" s PerWordType=..GetCommCode(obj.PerWordType)
		...e  s PerWordType=""
		...s HISNO=obj.HISNO
		...s PerNativePlace=obj.PerNativePlace
		...s PerAddress=obj.PerAddress
		...i obj.PerCadreDate'="" s PerCadreDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerCadreDate)
		...e  s PerCadreDate=""
		...q:obj.PerStatus'="17||1"
		...s PerAuditFlag=""
		...i obj.PerAuditFlag="Y" s PerAuditFlag="已审核"
		...e  i obj.PerAuditFlag="B" s PerAuditFlag="已驳回" 
		...s rettmp="PerName|"_NurseName_"^PerID|"_NurseID_"^PerDepDR|"_NurseDep_"^PerBirthday|"_PerBirthday_"^PerCardId|"_PerCardId_"^PerDepDate|"_PerDepDate_"^PerComeDate|"_PerComeDate_"^PerWorkDate|"_PerWorkDate_"^PerRegNo|"_PerRegNo_"^rowid|"_RowID_"^PerStatus|"_PerStatus_"^PerMarriage|"_PerMarriage_"^PerSource|"_PerSource_"^PerPolitical|"_PerPolitical_"^PerNation|"_PerNation_"^PerClothesNo|"_PerClothesNo_"^PerTrouserNo|"_PerTrouserNo_"^PerShoesNo|"_PerShoesNo_"^PerWordType|"_PerWordType_"^PerAge|"_PerAge_"^PerComeYear|"_PerComeYear_"^HISNO|"_HISNO_"^PerNativePlace|"_PerNativePlace_"^PerAddress|"_PerAddress_"^PerCadreDate|"_PerCadreDate_"^PerAuditFlag|"_PerAuditFlag
		...s PerContact=obj.PerContact
		...s PerPhone=obj.PerPhone
		...s rettmp=rettmp_"^PerContact|"_PerContact_"^PerPhone|"_PerPhone
		...s PerSexDR=..GetCommCode(obj.PerSexDR)
		...s rettmp=rettmp_"^PerSexDR|"_PerSexDR
		...s tmp(NurseDep,RowID)=rettmp
		
		;d OutputPerData
		;...i column'="" d
		;....i column="PerID" s tmp(NurseID,RowID)=ret
		;....i column="PerName" s tmp(NurseName,RowID)=ret
		;....i column="PerDepDR" s tmp(NurseDep,RowID)=ret
		;...i ((column="")!(column="null")) do OutputPerData
	}
	else
	{
		f j=1:1:$l(roleid,"^")
		{
			s roleitm=$p(roleid,"^",j)
			i roleitm="" continue
			s rolecode=##class(web.NurMgLoginComm).GetLoginRoleCode(roleitm)
			i ((rolecode="hlbzr")||(rolecode="hlb")||(rolecode="znurhead")||(rolecode="nurhead")||(rolecode="manager"))
			{
				s rolerw="" f  s rolerw=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_roleitm," "_nurseid,rolerw)) q:rolerw=""  d
				.s roledeprw="" f  s roledeprw=$O(^DHCNMG.DB.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
				..s roledepobj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rolerw_"||"_roledeprw)
				..q:'$IsObject(roledepobj)
				..s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
				...s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
				....q:(id'=roledepobj.SubWard)
				....s RowID="" f  s RowID=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_id,RowID)) q:RowID=""  d
				.....s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
				.....q:(obj.PerTypeDR'="N")
				.....q:((rolecode="nurse")&&(nurseid'="")&&(RowID'=nurseid))
				.....q:((advflag=0)&&(locVal'="")&&(obj.PerLocDR'=locVal))
				.....q:((advflag=0)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
				.....q:((advflag=0)&&(nameVal'="")&&((obj.PerName_obj.PerID)'[nameVal))
				.....q:((advflag=1)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
				.....q:((advflag=1)&&(sourceVal'="")&&(obj.PerSource'=sourceVal))
				.....q:((advflag=1)&&(politVal'="")&&(obj.PerPolitical'=politVal))
				.....q:((advflag=1)&&(hireVal'="")&&(..CheckHireDuty(RowID,hireVal)=0))
				.....q:((advflag=1)&&(postVal'="")&&(..CheckPost(RowID,postVal)=0))
				.....q:((advflag=1)&&(levelVal'="")&&(..CheckLevel(RowID,levelVal)=0))
				.....q:((advflag=1)&&(firEduVal'="")&&(..CheckEdu(RowID,firEduVal,"0")=0))
				.....q:((advflag=1)&&(maxEduVal'="")&&(..CheckEdu(RowID,maxEduVal,"1")=0))
				.....s NurseName=obj.PerName
				.....s NurseID=obj.PerID
				.....s NurseDep=$P($P($g(^CTLOC(obj.PerDepDR)),"^",2),"-",2)
				.....s NurseDep=$list($g(^DHCNMG.DB.MgWardD(obj.PerDepDR)),4)
				.....i obj.PerBirthday'="" s PerBirthday=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerBirthday)
				.....e  s PerBirthday=""
				.....s PerCardId=obj.PerCardId
				.....s PerAge=""
				.....i obj.PerBirthday'="" d
				......s age=##class(web.NurMgVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
				......s PerAge=$p(age,"Y",1)
				.....i obj.PerDepDate'="" s PerDepDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerDepDate)
				.....e  s PerDepDate=""
				.....i obj.PerComeDate'="" s PerComeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerComeDate)
				.....e  s PerComeDate=""
				.....s PerComeYear=""
				.....i obj.PerComeDate'="" d
				......s comeyear=##class(web.NurMgVueComm).CalAge($zd(obj.PerComeDate,3),$zd(+$H,3))
				......s PerComeYear=$p(comeyear,"Y",1)
				.....i obj.PerWorkDate'="" s PerWorkDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerWorkDate)
				.....e  s PerWorkDate=""
				.....s PerRegNo=obj.PerRegNo
				.....i obj.PerStatus'="" s PerStatus=..GetCommCode(obj.PerStatus)
				.....e  s PerStatus=""
				.....i obj.PerMarriage'="" s PerMarriage=..GetCommCode(obj.PerMarriage)
				.....e  s PerMarriage=""
				.....i obj.PerSource'="" s PerSource=..GetCommCode(obj.PerSource)
				.....e  s PerSource=""
				.....i obj.PerPolitical'="" s PerPolitical=..GetCommCode(obj.PerPolitical)
				.....e  s PerPolitical=""
				.....i obj.PerNation'="" s PerNation=..GetCommCode(obj.PerNation)
				.....e  s PerNation=""
				.....i obj.PerClothesNo'="" s PerClothesNo=..GetCommCode(obj.PerClothesNo)
				.....e  s PerClothesNo=""
				.....i obj.PerTrouserNo'="" s PerTrouserNo=..GetCommCode(obj.PerTrouserNo)
				.....e  s PerTrouserNo=""
				.....i obj.PerShoesNo'="" s PerShoesNo=..GetCommCode(obj.PerShoesNo)
				.....e  s PerShoesNo=""
				.....i obj.PerWordType'="" s PerWordType=..GetCommCode(obj.PerWordType)
				.....e  s PerWordType=""
				.....s HISNO=obj.HISNO
				.....s PerNativePlace=obj.PerNativePlace
				.....s PerAddress=obj.PerAddress
				.....i obj.PerCadreDate'="" s PerCadreDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerCadreDate)
				.....e  s PerCadreDate=""
				.....q:obj.PerStatus'="17||1"
				.....s PerAuditFlag=""
				.....i obj.PerAuditFlag="Y" s PerAuditFlag="已审核"
				.....e  i obj.PerAuditFlag="B" s PerAuditFlag="已驳回"
				.....s rettmp="PerName|"_NurseName_"^PerID|"_NurseID_"^PerDepDR|"_NurseDep_"^PerBirthday|"_PerBirthday_"^PerCardId|"_PerCardId_"^PerDepDate|"_PerDepDate_"^PerComeDate|"_PerComeDate_"^PerWorkDate|"_PerWorkDate_"^PerRegNo|"_PerRegNo_"^rowid|"_RowID_"^PerStatus|"_PerStatus_"^PerMarriage|"_PerMarriage_"^PerSource|"_PerSource_"^PerPolitical|"_PerPolitical_"^PerNation|"_PerNation_"^PerClothesNo|"_PerClothesNo_"^PerTrouserNo|"_PerTrouserNo_"^PerShoesNo|"_PerShoesNo_"^PerWordType|"_PerWordType_"^PerAge|"_PerAge_"^PerComeYear|"_PerComeYear_"^HISNO|"_HISNO_"^PerNativePlace|"_PerNativePlace_"^PerAddress|"_PerAddress_"^PerCadreDate|"_PerCadreDate_"^PerAuditFlag|"_PerAuditFlag
				.....s PerContact=obj.PerContact
				.....s PerPhone=obj.PerPhone
				.....s rettmp=rettmp_"^PerContact|"_PerContact_"^PerPhone|"_PerPhone
				.....s PerSexDR=..GetCommCode(obj.PerSexDR)
				.....s rettmp=rettmp_"^PerSexDR|"_PerSexDR
				.....s tmp(NurseDep,RowID)=rettmp
				;.....i column'="" d
				;......i column="PerID" s tmp(NurseID,RowID)=ret
				;......i column="PerName" s tmp(NurseName,RowID)=ret
				;......i column="PerDepDR" s tmp(NurseDep,RowID)=ret
				;.....i ((column="")!(column="null")) d
				;......s tmp(NurseDep,RowID)=ret
				;......;do OutputPerData
			}
			else
			{
				s obj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
				i (obj.PerTypeDR'="N") continue
				;q:((rolecode="nurse")&&(nurseid'="")&&(RowID'=nurseid))
				i ((advflag=0)&&(locVal'="")&&(obj.PerLocDR'=locVal)) continue
				i ((advflag=0)&&(wardVal'="")&&(obj.PerDepDR'=wardVal)) continue
				i ((advflag=0)&&(nameVal'="")&&(obj.PerName'[nameVal)) continue
				i ((advflag=1)&&(wardVal'="")&&(obj.PerDepDR'=wardVal)) continue
				i ((advflag=1)&&(sourceVal'="")&&(obj.PerSource'=sourceVal)) continue
				i ((advflag=1)&&(politVal'="")&&(obj.PerPolitical'=politVal)) continue
				i ((advflag=1)&&(hireVal'="")&&(..CheckHireDuty(RowID,hireVal)=0)) continue
				i ((advflag=1)&&(postVal'="")&&(..CheckPost(RowID,postVal)=0)) continue
				i ((advflag=1)&&(levelVal'="")&&(..CheckLevel(RowID,levelVal)=0)) continue
				i ((advflag=1)&&(firEduVal'="")&&(..CheckEdu(RowID,firEduVal,"0")=0)) continue
				i ((advflag=1)&&(maxEduVal'="")&&(..CheckEdu(RowID,maxEduVal,"1")=0)) continue
				s NurseName=obj.PerName
				s NurseID=obj.PerID
				s NurseDep=$P($P($g(^CTLOC(obj.PerDepDR)),"^",2),"-",2)
				s NurseDep=$list($g(^DHCNMG.DB.MgWardD(obj.PerDepDR)),4)
				i obj.PerBirthday'="" s PerBirthday=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerBirthday)
				e  s PerBirthday=""
				s PerCardId=obj.PerCardId
				s PerAge=""
				i obj.PerBirthday'="" d
				.s age=##class(web.NurMgVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
				.s PerAge=$p(age,"Y",1)
				i obj.PerDepDate'="" s PerDepDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerDepDate)
				e  s PerDepDate=""
				i obj.PerComeDate'="" s PerComeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerComeDate)
				e  s PerComeDate=""
				s PerComeYear=""
				i obj.PerComeDate'="" d
				.s comeyear=##class(web.NurMgVueComm).CalAge($zd(obj.PerComeDate,3),$zd(+$H,3))
				.s PerComeYear=$p(comeyear,"Y",1)
				i obj.PerWorkDate'="" s PerWorkDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerWorkDate)
				e  s PerWorkDate=""
				s PerRegNo=obj.PerRegNo
				i obj.PerStatus'="" s PerStatus=..GetCommCode(obj.PerStatus)
				e  s PerStatus=""
				i obj.PerMarriage'="" s PerMarriage=..GetCommCode(obj.PerMarriage)
				e  s PerMarriage=""
				i obj.PerSource'="" s PerSource=..GetCommCode(obj.PerSource)
				e  s PerSource=""
				i obj.PerPolitical'="" s PerPolitical=..GetCommCode(obj.PerPolitical)
				e  s PerPolitical=""
				i obj.PerNation'="" s PerNation=..GetCommCode(obj.PerNation)
				e  s PerNation=""
				i obj.PerClothesNo'="" s PerClothesNo=..GetCommCode(obj.PerClothesNo)
				e  s PerClothesNo=""
				i obj.PerTrouserNo'="" s PerTrouserNo=..GetCommCode(obj.PerTrouserNo)
				e  s PerTrouserNo=""
				i obj.PerShoesNo'="" s PerShoesNo=..GetCommCode(obj.PerShoesNo)
				e  s PerShoesNo=""
				i obj.PerWordType'="" s PerWordType=..GetCommCode(obj.PerWordType)
				e  s PerWordType=""
				s HISNO=obj.HISNO
				s PerNativePlace=obj.PerNativePlace
				s PerAddress=obj.PerAddress
				i obj.PerCadreDate'="" s PerCadreDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerCadreDate)
				e  s PerCadreDate=""
				q:obj.PerStatus'="17||1"
				s PerAuditFlag=""
				i obj.PerAuditFlag="Y" s PerAuditFlag="已审核"
				e  i obj.PerAuditFlag="B" s PerAuditFlag="已驳回"
				s rettmp="PerName|"_NurseName_"^PerID|"_NurseID_"^PerDepDR|"_NurseDep_"^PerBirthday|"_PerBirthday_"^PerCardId|"_PerCardId_"^PerDepDate|"_PerDepDate_"^PerComeDate|"_PerComeDate_"^PerWorkDate|"_PerWorkDate_"^PerRegNo|"_PerRegNo_"^rowid|"_nurseid_"^PerStatus|"_PerStatus_"^PerMarriage|"_PerMarriage_"^PerSource|"_PerSource_"^PerPolitical|"_PerPolitical_"^PerNation|"_PerNation_"^PerClothesNo|"_PerClothesNo_"^PerTrouserNo|"_PerTrouserNo_"^PerShoesNo|"_PerShoesNo_"^PerWordType|"_PerWordType_"^PerAge|"_PerAge_"^PerComeYear|"_PerComeYear_"^HISNO|"_HISNO_"^PerNativePlace|"_PerNativePlace_"^PerAddress|"_PerAddress_"^PerCadreDate|"_PerCadreDate_"^PerAuditFlag|"_PerAuditFlag
				s PerContact=obj.PerContact
				s PerPhone=obj.PerPhone
				s rettmp=rettmp_"^PerContact|"_PerContact_"^PerPhone|"_PerPhone
				s PerSexDR=..GetCommCode(obj.PerSexDR)
				s rettmp=rettmp_"^PerSexDR|"_PerSexDR
				s tmp(NurseDep,nurseid)=rettmp
				;i column'="" d
				;.i column="PerID" s tmp(NurseID,RowID)=ret
				;.i column="PerName" s tmp(NurseName,RowID)=ret
				;.i column="PerDepDR" s tmp(NurseDep,RowID)=ret
				;i ((column="")!(column="null")) d
				;.s tmp(NurseDep,nurseid)=ret
				;.;do OutputPerData
			}
		}
	}
	;i column'="" d
	;.s ret=""
	;.i order="ascending" d
	;..s desc="" f  s desc=$O(tmp(desc)) q:desc=""  d
	;...s rw="" f  s rw=$O(tmp(desc,rw)) q:rw=""  d
	;....s ret=tmp(desc,rw)
	;....do OutputPerData
	;.e  i order="descending" d
	;..s desc="" f  s desc=$O(tmp(desc),-1) q:desc=""  d
	;...s rw="" f  s rw=$O(tmp(desc,rw),-1) q:rw=""  d
	;....s ret=tmp(desc,rw)
	;....do OutputPerData
	;e  d OutputPerData
	s tmpward="" f  s tmpward=$O(tmp(tmpward)) q:tmpward=""  d
	.s tmpid="" f  s tmpid=$O(tmp(tmpward,tmpid)) q:tmpid=""  d
	..s ret=tmp(tmpward,tmpid)
	..d OutputPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPersonsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPersonsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CheckHireDuty(id, duty) As %String
{
	s flag=0
	s rw="" f  s rw=$O(^DHCNMG.HR.MgHireDutyI("ssid",id,rw)) q:rw=""  d
	.i rw'="" d
	..s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(rw)
	..;i ((duty'="")&&(obj.HireDuty=duty)) s flag=1
	..i ((duty'="")&&(duty[obj.HireDuty)) s flag=1
	q flag
}

ClassMethod CheckPost(id, post) As %String
{
	s flag=0
	s rw="" f  s rw=$O(^DHCNMG.HR.MgPostDutyI("ssid",id,rw)) q:rw=""  d
	.i rw'="" d
	..s obj=##class(DHCNMG.HR.MgPostDuty).%OpenId(rw)
	..;i ((post'="")&&(obj.PostDuty=post)) s flag=1
	..i ((post'="")&&(post[obj.PostDuty)) s flag=1
	q flag
}

ClassMethod CheckLevel(id, level) As %String
{
	s flag=0
	s rw="" f  s rw=$O(^DHCNMG.HR.MgLevelI("ssid",id,rw)) q:rw=""  d
	.i rw'="" d
	..s obj=##class(DHCNMG.HR.MgLevel).%OpenId(rw)
	..;i ((level'="")&&(obj.NurLevel=level)) s flag=1
	..i ((level'="")&&(level[obj.NurLevel)) s flag=1
	q flag
}

ClassMethod CheckEdu(id, eduVal, radio) As %String
{
	s flag=0
	s rw="" f  s rw=$O(^DHCNMG.HR.MgEducateI("ssid",id,rw)) q:rw=""  d
	.i rw'="" d
	..s obj=##class(DHCNMG.HR.MgEducate).%OpenId(rw)
	..;i ((eduVal'="")&&(obj.EduAcademic=eduVal)&&(obj.EduRadio=radio)) s flag=1
	..i ((eduVal'="")&&(eduVal[obj.EduAcademic)&&(obj.EduRadio=radio)) s flag=1
	q flag
}

/// Creator:gzj
/// Description:获取人员信息
/// Date:2017-07-10
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod GetPerson(id As %String) As %String
{
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	s ret="",tmp=""
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgPersons","a",p)) q:p=""  d
	.q:p["%"
	.i p="PerSpeciNurse" d
	..s specinurses=obj.PerSpeciNurse
	..s len=obj.PerSpeciNurse.Count()
	..s ret=""
	..f l=1:1:len d
	...s itm=obj.PerSpeciNurse.GetAt(l)
	...q:itm=""
	...i ret="" s ret=itm
	...e  s ret=ret_","_itm
	..s tmp(p)=ret
	.e  s tmp(p)=$ZOBJPROPERTY(obj,p)
	.s ptype=^oddCOM("DHCNMG.HR.MgPersons","a",p,"P","XSDTYPE")
	.i ((ptype="date")&&(tmp(p)'="")) d
	..s tmp(p)=##class(web.NurMgHISComm).DateLogicalToHtml(tmp(p))
	s k="" 
	f {
		s k=$O(tmp(k))
		q:k=""
		i k="PerPassword" continue
		s ret=ret_k_"|"_tmp(k)_"^"
	}
	//获取层级信息
	s PerLevel="",PerLevelDate=""
	s LeaveId="" f  s LeaveId=$O(^DHCNMG.HR.MgLevelI("ssid",id,LeaveId)) q:LeaveId=""  d
	.s LeaveObj=##class(DHCNMG.HR.MgLevel).%OpenId(LeaveId)
	.q:'$IsObject(LeaveObj)
	.q:LeaveObj.LevelStatus'="A"
	.q:LeaveObj.LevelDate<PerLevelDate
	.q:LeaveObj.LevelDate>+$H
	.s PerLevel=LeaveObj.NurLevel
	.s PerLevelDate=LeaveObj.LevelDate
	s ret=ret_"^PerNurseLevel|"_PerLevel
	//获取职称信息
	s PerHireDuty="",PerHireDutyDate="",HireFlag=0
	s HireDate="" f  s HireDate=$O(^DHCNMG.HR.MgHireDutyI("HireDate",id,HireDate),-1) q:(HireDate="")||(HireFlag=1)  d
	.s HireRowID=$O(^DHCNMG.HR.MgHireDutyI("HireDate",id,HireDate,""),-1)
	.s HireObj=##class(DHCNMG.HR.MgHireDuty).%OpenId(HireRowID)
	.q:'$IsObject(HireObj)
	.q:HireObj.HireStatus'="A"
	.s PerHireDuty=HireObj.HireDuty
	.i HireObj.HireStDate'="" s PerHireDutyDate=##class(web.NurMgHISComm).DateLogicalToHtml(HireObj.HireStDate)
	.s HireFlag=1
	//获取职务信息
	s PerPostDuty="",PerPostDutyDate="",PostFlag=0
	s PostDate="" f  s PostDate=$O(^DHCNMG.HR.MgPostDutyI("PostDate",id,PostDate),-1) q:(PostDate="")||(PostFlag=1)  d
	.;s minsort=100,PostDutyID=""
	.;i PostDate'="" d
	.s PostRowID="" f  s PostRowID=$O(^DHCNMG.HR.MgPostDutyI("PostDate",id,PostDate,PostRowID)) q:(PostRowID="")||(PostFlag=1)  d
	..s PostObj=##class(DHCNMG.HR.MgPostDuty).%OpenId(PostRowID)
	..q:'$IsObject(PostObj)
	..q:PostObj.PostStatus'="A"
	..s PerPostDuty=PostObj.PostDuty
	..s PerPostDutyDate=##class(web.NurMgHISComm).DateLogicalToHtml(PostObj.PostStDate)
	..s PostFlag=1
	..;i PostObj.PostDuty'="" d
	..;.s sort=##class(web.NurMgDBComm).GetSortSetCode(PostObj.PostDuty)
	..;.i sort<minsort d
	..;..s minsort=sort,PerPostDuty=PostObj.PostDuty
	..;..i PostObj.PostStDate'="" s PerPostDutyDate=$zd(PostObj.PostStDate,3)
	//获取当前学历
	s PerCurrentAcade="",PerCurrentSchool="",EduFlag=0
	s EduDate="" f  s EduDate=$O(^DHCNMG.HR.MgEducateI("flag",id,EduDate),-1) q:(EduDate="")||(EduFlag=1)  d
	.s EduRowID=$O(^DHCNMG.HR.MgEducateI("flag",id,EduDate,""))
	.s EduObj=##class(DHCNMG.HR.MgEducate).%OpenId(EduRowID)
	.q:'$IsObject(EduObj)
	.q:EduObj.EduStatus'="A"
	.s PerCurrentAcade=EduObj.EduAcademic
	.s PerCurrentSchool=EduObj.EduSchool
	.s EduFlag=1
	s ret=ret_"^RowID|"_id_"^PerHireDuty|"_PerHireDuty_"^PerHireDutyDate|"_PerHireDutyDate_"^PerPostDuty|"_PerPostDuty_"^PerPostDutyDate|"_PerPostDutyDate_"^PerCurrentAcade|"_PerCurrentAcade_"^PerCurrentSchool|"_PerCurrentSchool
	q ret
}

/// Creator:gzj
/// Description:获取人员信息
/// Date:2017-07-10
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod GetPersonTmp(id As %String) As %String
{
	q:id="" ""
	s rowid=$O(^DHCNMG.HR.MgPersonsTmpI("PersonID"," "_id,""))
	q:rowid="" ""
	
	s obj=##class(DHCNMG.HR.MgPersonsTmp).%OpenId(rowid)
	s ret="",tmp=""
	i obj.PerAuditFlag="Y"
	{
		s pobj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
		s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgPersons","a",p)) q:p=""  d
		.q:p["%"
		.s tmp(p)=$ZOBJPROPERTY(pobj,p)
		.s ptype=^oddCOM("DHCNMG.HR.MgPersons","a",p,"P","XSDTYPE")
		.i ((ptype="date")&&(tmp(p)'="")) d
		..s tmp(p)=##class(web.NurMgHISComm).DateLogicalToHtml(tmp(p))
		s k="" 
		f {
			s k=$O(tmp(k))
			q:k=""
			s ret=ret_k_"|"_tmp(k)_"^"
		}
		;s ret=ret_"^AuditFlag|"_obj.PerAuditFlag
		
	}
	elseif ((obj.PerAuditFlag="")||(obj.PerAuditFlag="N"))
	{
		s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgPersonsTmp","a",p)) q:p=""  d
		.q:p["%"
		.s tmp(p)=$ZOBJPROPERTY(obj,p)
		.s ptype=^oddCOM("DHCNMG.HR.MgPersonsTmp","a",p,"P","XSDTYPE")
		.i ((ptype="date")&&(tmp(p)'="")) d
		..s tmp(p)=##class(web.NurMgHISComm).DateLogicalToHtml(tmp(p))
		s k="" 
		f {
			s k=$O(tmp(k))
			q:k=""
			s ret=ret_k_"|"_tmp(k)_"^"	
		}
	}
	else
	{
		s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgPersonsTmp","a",p)) q:p=""  d
		.q:p["%"
		.s tmp(p)=$ZOBJPROPERTY(obj,p)
		.s ptype=^oddCOM("DHCNMG.HR.MgPersonsTmp","a",p,"P","XSDTYPE")
		.i ((ptype="date")&&(tmp(p)'="")) d
		..s tmp(p)=##class(web.NurMgHISComm).DateLogicalToHtml(tmp(p))
		s k="" 
		f {
			s k=$O(tmp(k))
			q:k=""
			s ret=ret_k_"|"_tmp(k)_"^"	
		}
	}
	s ret=ret_"^RowID|"_rowid
	q ret
}

/// Creator:gzj
/// Description:保存人员临时信息
/// Date:2017-12-07
/// Table:DHCNMG.HR.MgPersonsTmp
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveTmp(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s nurseNo=$g(tmp("PerID"))
	s flag=-1
	i id="" d
	.i nurseNo'="" d
	..s flag=$P(..IsExistTmp(nurseNo),"^",1)
	e  d
	.i nurseNo'="" d
	..s rowid=$P(..IsExistTmp(nurseNo),"^",2)
	..i rowid'=id d
	...s flag=$P(..IsExistTmp(nurseNo),"^",1)
	q:flag=0 "此工号已经存在"
	i id="" s obj=##class(DHCNMG.HR.MgPersonsTmp).%New()
	e  s obj=##class(DHCNMG.HR.MgPersonsTmp).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgPersonsTmp","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s ptype=^oddCOM("DHCNMG.HR.MgPersonsTmp","a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(tmp(p)'="")) d
	...s tmp(p)=$zdh(tmp(p),3)
	..i p="PerID" s tmp(p)=$zcvt($tr(tmp(p)," ",""),"U")
	..s tmp("PerTypeDR")="N" //人员类型（正式N  进修S 实习P 护理员W）
	..s tmp("PerCareType")="N" //医护类型（医生D 护士N）
	..s tmp("PerStatus")="17||1"
	..;i p="PerComeDate" s tmp("PerDepDate")=tmp("PerComeDate")
	..s $ZOBJPROPERTY(obj,p)=$tr(tmp(p),"__","||")
	s obj.PerDepDate=obj.PerComeDate
	s sc=obj.%Save()
	;q obj.%Id()
	q obj.PersonID
}

/// Creator:gzj
/// Description:判断人员是否存在
/// Date:2017-07-17
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod IsExistTmp(nurseno) As %String
{
	s flag=-1
	s rowid=$O(^DHCNMG.HR.MgPersonsTmpI("PerID"," "_$zcvt(nurseno,"U"),""))
	i rowid'="" d
	.s flag=0
	q flag_"^"_rowid
}

/// Creator:gzj
/// Description:保存人员信息
/// Date:2017-07-17
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod Save(parr As %String, type As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s nurseNo=$g(tmp("PerID"))
	s flag=-1
	i id="" d
	.i nurseNo'="" d
	..s flag=$P(..IsExist(nurseNo),"^",1)
	e  d
	.i nurseNo'="" d
	..s rowid=$P(..IsExist(nurseNo),"^",2)
	..i rowid'=id d
	...s flag=$P(..IsExist(nurseNo),"^",1)
	q:flag=0 "此工号已经存在"
	s cardId=$g(tmp("PerCardId"))
	s cardFlag=0
	s tmpRw=$o(^DHCNMG.HR.MgPersonsI("card"," "_$zcvt($tr(cardId," ",""),"U"),""))
	i id="" d
	.i tmpRw'="" s cardFlag=1
	e  d
	.i tmpRw="" s cardFlag=0
	.e  d
	..i tmpRw=id s cardFlag=0
	..e  s cardFlag=1
	q:cardFlag=1 "此身份证号已经存在"
	i id="" s obj=##class(DHCNMG.HR.MgPersons).%New()
	e  s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgPersons","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..s ptype=^oddCOM("DHCNMG.HR.MgPersons","a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(tmp(p)'="")) d
	...s tmp(p)=$zdh(tmp(p),3)
	..i p="PerID" s tmp(p)=$zcvt($tr(tmp(p)," ",""),"U")
	..s tmp("PerTypeDR")="N" //人员类型（正式N  进修S 实习P 护理员W）
	..s tmp("PerCareType")="N" //医护类型（医生D 护士N）
	..s tmp("PerStatus")="17||1"
	..s tmp("PerAuditFlag")=type
	..i p="PerSpeciNurse" d
	...d obj.PerSpeciNurse.Clear()
	...f j=1:1:$l(tmp(p),",") d
	....s itm=$p(tmp(p),",",j)
	....i itm'="" d obj.PerSpeciNurse.Insert(itm)
	..e  s $ZOBJPROPERTY(obj,p)=$tr(tmp(p),"__","||")
	i obj.PerPassword="" s obj.PerPassword="UUUUUU&&&&&&"
	TS
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	s transRowID=$o(^DHCNMG.HR.MgTransDepI("flag"," Y"," "_obj.%Id(),""))
	i transRowID="" d
	.s oldTransID=$o(^DHCNMG.HR.MgTransDepI("Current"," Y"," "_obj.%Id(),""))
	.i oldTransID="" d
	..s newObj=##class(DHCNMG.HR.MgTransDep).%New()
	..s newObj.PerDr=obj.%Id()
	..s newObj.PerDepart=obj.PerDepDR
	..s newObj.PerTranStDate=+$h
	..s newObj.PerTranStTime=$p($h,",",2)
	..s newObj.PerTranCurrent="Y"
	..s newObj.PerTransType="L"
	..s newObjSc=newObj.%Save()
	..s flag=flag&&$$$ISOK(newObjSc)
	.e  d
	..s oldObj=##class(DHCNMG.HR.MgTransDep).%OpenId(oldTransID)
	..s oldObj.PerTranEndDate=+$h
	..s oldObj.PerTranEndTime=$p($h,",",2)
	..s oldObj.PerTranCurrent="N"
	..s oldObj.PerTransType="L"
	..s oldObjSc=oldObj.%Save()
	..s flag=(flag&&$$$ISOK(oldObjSc))
	..i flag=1 d
	...s newObj=##class(DHCNMG.HR.MgTransDep).%New()
	...s newObj.PerDr=obj.%Id()
	...s newObj.PerDepart=obj.PerDepDR
	...s newObj.PerTranStDate=+$h
	...s newObj.PerTranStTime=$p($h,",",2)
	...s newObj.PerTranCurrent="Y"
	...s newObj.PerTransType="L"
	...s newObjSc=newObj.%Save()
	...s flag=(flag&&$$$ISOK(newObjSc))
	
	i flag=1
	{
		TC
	}
	else
	{
		tro
	}
	q:flag=1 obj.%Id()
	q:flag=0 flag
}

/// Creator:gzj
/// Description:保存在职状态信息
/// Date:2017-08-25
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others:"context|17__2^contextdate|2017-08-01^RowID|2"
ClassMethod SaveRtireLeave(parr As %String) As %String
{
	s PerStatus=$tr($P($P(parr,"^",1),"|",2),"__","||")
	s StateDate=$P($P(parr,"^",2),"|",2)
	i StateDate'="" s PerStateDate=$zdh(StateDate,3)
	e  s PerStateDate=+$H
	s RowID=$P($P(parr,"^",3),"|",2)
	q:RowID="" ""
	s flag=..IsRetireLeaState(PerStatus,RowID)
	q:flag="-1" flag
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	q:'$IsObject(obj) ""
	s obj.PerStatus=PerStatus
	i obj.PerStatus'="" d
	.s cobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.PerStatus)
	.q:'$IsObject(cobj)
	.i ((cobj.SubDesc="在职")!(cobj.SubDesc="在院")) s obj.PerStateDate=""
	.e  s obj.PerStateDate=PerStateDate
	d obj.%Save()
	q obj.%Id()
}

ClassMethod IsRetireLeaState(PerStatus, RowID) As %String
{
	s ret=0
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	q:'$IsObject(obj) ""
	i (PerStatus'="")&&(obj.PerStatus=PerStatus) s ret=-1
	q ret
}

/// Creator:gzj
/// Description:判断人员是否存在
/// Date:2017-07-17
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod IsExist(nurseno) As %String
{
	s flag=-1
	s rowid=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_$zcvt(nurseno,"U"),""))
	i rowid'="" d
	.s flag=0
	q flag_"^"_rowid
}

/// Creator:gyg
/// Description:根据人员工号取信息
/// Date:2019-09-9
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others:w ##class(web.NurMgPersonComm).GetNurseMessage("SS04")
ClassMethod GetNurseMessage(nurseno) As %String
{
	s flags=-1
	
	s rowid=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_$zcvt(nurseno,"U"),""))
	i rowid'="" d
	
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	if ('$IsObject(obj)){
			q "^flags|"_flags
		}
	i $d(^DHCNMG.HR.MgNurseResignI("ssid",rowid)) q "^flags|"_"0"
	s nurname=obj.PerName
	s nurward=obj.PerDepDR
	s flags=1
	q "^flags|"_flags_"^id|"_rowid_"^name|"_nurname_"^nurward|"_nurward
}

/// Creator:gzj
/// Description:保存调科记录数据
/// Date:2017-07-24
/// Table:DHCNMG.HR.MgTransDep
/// Input:"^人员表id^科室id^开始日期^开始时间^Y^原因"
/// Output：
/// Return:
/// Others:
ClassMethod SaveTransData(parr As %String) As %String
{
	s id=$P(parr,"^",1)
   	s per=$P(parr,"^",2) //人员表id
   	s dep=$P(parr,"^",3) //科室id
   	s stdate=$P(parr,"^",4) //开始日期
   	s sttime=$P(parr,"^",5) //开始时间
   	s curr=$P(parr,"^",6) //当前状态
   	s mem=$P(parr,"^",7) //原因 （为空）
   	s perrowid=$P(parr,"^",8) //调科申请id
   	s pertrantype=$P(parr,"^",9) //调科类型
   	s stdate=$ZDH(stdate,3)
   	if sttime'="" s sttime=$ZTH(sttime)
   	e  s sttime=$P($H,",",2)
   	s id="",upid=""
   	s rw=""  f  s rw=$O(^DHCNMG.HR.MgTransDepI("ssdr"," "_per,rw)) q:rw=""  d
   	.s loc=$List(^DHCNMG.HR.MgTransDepD(rw),3)
   	.s enddate=$List(^DHCNMG.HR.MgTransDepD(rw),6)
   	.if (loc=dep)&(enddate="") s id=rw
   	.e  d
   	..s id="",upid=rw
   	if id'="" s a=##class(DHCNMG.HR.MgTransDep).%OpenId(id)
   	e  s a=##class(DHCNMG.HR.MgTransDep).%New()
   	s a.PerDr=per
   	s a.PerDepart=dep
   	s a.PerTranStDate=stdate
   	s a.PerTranStTime=sttime
   	s a.PerTranCurrent=curr
   	s a.PerTranMem=mem
   	s a.PerAppID=perrowid
   	s a.PerTransType=pertrantype
   	d a.%Save()
   	if upid'="" 
   	{
	   	s aa=##class(DHCNMG.HR.MgTransDep).%OpenId(upid)
      	s aa.PerTranEndDate=stdate
      	s aa.PerTranEndTime=sttime
      	s aa.PerTranCurrent="N"
      	;s aa.PerTransType=pertrantype
      	d aa.%Save()      
  	}
  	q 0
}

/// Creator:gzj
/// Description:检查（判断）调科日期
/// Date:2017-08-26
/// Table:DHCNMG.HR.MgTransDep
/// Input:""
/// Output：
/// Return:
/// Others:
ClassMethod CheckTransDate(date As %String, rowid As %String) As %String
{
	s ret="true"
	s rw="" f  s rw=$O(^DHCNMG.HR.MgTransDepI("ssdr"," "_rowid,rw),-1) q:rw=""  d
	.s obj=##class(DHCNMG.HR.MgTransDep).%OpenId(rw)
	.q:obj.PerTranCurrent="Y"
	.s dateVal=obj.PerTranStDate
	.i ((date'="")&&($zdh(date,3)<dateVal)) d
	..s ret="false"
	
	q ret
}

/// Creator:gzj
/// Description:查询参与调科人员数据
/// Date:2017-08-28
/// Table:DHCNMG.HR.MgPersons
/// Input:parr  病区id
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindTransNurse","")
Query FindTransNurse(parr As %String = "", info As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransNurseExecute(ByRef qHandle As %Binary, parr As %String = "", info As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
	..q:(isAll=0)&&('$d(tmpWard(id)))
	..s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_id,rowid)) q:rowid=""  d
	...s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	...s nurseno=obj.PerID
	...s nursename=obj.PerName
	...s spell=##class(web.NurMgVueComm).ToChineseSpell(nursename)
	...q:((info'="")&&((nurseno_nursename_spell)'[info))
	...s nursedepret=##class(web.NurMgDBComm).GetWard(obj.PerDepDR)
	...s nursedep=$P($P($g(nursedepret),"^",3),"|",2)
	...s ret="nurseid|"_nurseno_"^nursename|"_nursename_"^nursedep|"_nursedep_"^rowid|"_rowid_"^nursedepcode|"_obj.PerDepDR
	...do OutTransData
	
	;s dep="" f  s dep=$O(^DHCNMG.HR.MgPersonsI("DepID",dep)) q:dep=""  d
	;.s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsI("DepID",dep,rowid)) q:rowid=""  d
	;..s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	;..s nurseid=obj.PerID
	;..s nursename=obj.PerName
	;..q:((info'="")&&(rowid'=info))
	;..s nursedepret=##class(web.NurMgDBComm).GetWard(obj.PerDepDR)
	;..s nursedep=$P($P($g(nursedepret),"^",3),"|",2)
	;..s ret="nurseid|"_nurseid_"^nursename|"_nursename_"^nursedep|"_nursedep_"^rowid|"_rowid_"^nursedepcode|"_obj.PerDepDR
	;..do OutTransData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutTransData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransNurseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindTransNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Writter:gzj
/// Date:2019-05-11
/// Description:判断护士是否在此时间后存在排班
/// Input:
/// Output:
/// Return:
ClassMethod IsHasArg(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s nurseInfo=$P($P(parr,"^",4),"|",2)
	s len=$l(nurseInfo,"@")
	
	s TransDate=$zdh(tmp("TransDate"),3)
	//nurseInfo="TransOutDep「25 ~TransNurse「4@TransOutDep「25~TransNurse「5"
	s ret=""
	f i=1:1:len
	{
		s itm=$p(nurseInfo,"@",i)
		i itm="" continue
		
		s ward=$tr($p($p(itm,"~",1),"「",2)," ","")
		s nurse=$p($p(itm,"~",2),"「",2)
		i ((ward="")!(nurse="")) continue
		s date=TransDate-1 f  s date=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",nurse,date)) q:date=""  d
		.s rw="" f  s rw=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",nurse,date,rw)) q:rw=""  d
		..s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(rw)
		..q:'$IsObject(obj)
		..i ret="" s ret=obj.ArgPerDR.PerName
		..e  s ret=ret_";"_obj.ArgPerDR.PerName
	}
	i ret="" q 0
	e  q ret
}

/// Creator:
/// Date:2019-05-10
/// Description:检查护士是否已经在同一天有过调科记录
ClassMethod CheckNurseTrans(parr As %String) As %String
{
	/*
	TransDate|2019-05-13^TransInDep|1^TransType|13__2
	^TransNurseInfo|TransOutDep「25 ~TransNurse「4@TransOutDep「25~TransNurse「5
	^TransReason|^CreateUser|0^TransStatus|N^TransEndDate|^RowID|6^TranSpecy|L
	*/ //^TransNurseInfo|TransOutDep「25 ~TransNurse「4@TransOutDep「25~TransNurse「5
	s TransDate=$p($p(parr,"^",1),"|",2)
	s TransNurseInfo=$p($p(parr,"^",4),"|",2)
	s TransInDep=$p($p(parr,"^",2),"|",2)
	s len=$l(TransNurseInfo,"@")
	s ret=""
	f i=1:1:len 
	{
		s item=$p(TransNurseInfo,"@",i)
		i item="" continue
		s ward=$p($p(item,"~",1),"「",2)
		s nurse=$p($p(item,"~",2),"「",2)
		
	}
}

/// Creator:gzj
/// Description:保存调科申请
/// Date:2017-08-28
/// Table:DHCNMG.HR.MgTransApp
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveTransApp(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s nurseInfo=$P($P(parr,"^",4),"|",2)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgTransApp).%New()
	e  s obj=##class(DHCNMG.HR.MgTransApp).%OpenId(id)
	i obj.TransAppNo="" s obj.TransAppNo=..GetAppNo()
	s obj.TransOutDep=""
	
	s TransDepNurse=..GetNurse(nurseInfo) //1|1^1|5^1|6
	s len=$L(TransDepNurse,"^")
	d obj.TransNurse.Clear()
	f i=1:1:len
	{
		s itm=$P(TransDepNurse,"^",i)
		i itm'="" 
		{
			s sc=obj.TransNurse.Insert(itm)
		}
	}
	s obj.TransInDep=$P($p(parr,"^",2),"|",2)
	s obj.TransType=$P($p(parr,"^",3),"|",2)
	s obj.TransDate=$zdh($P($P(parr,"^",1),"|",2),3)
	s obj.CreateDate=+$H
	s obj.CreateUser=$P($P(parr,"^",6),"|",2)
	s obj.TransReason=$P($P(parr,"^",5),"|",2)
	s obj.TransStatus=$P($P(parr,"^",7),"|",2)
	i $P($P(parr,"^",8),"|",2)'="" s obj.TransEndDate=$zdh($P($P(parr,"^",8),"|",2),3)
	e  s obj.TransEndDate=""
	s obj.TranSpecy=$P($P(parr,"^",10),"|",2)
	d obj.%Save()
	q obj.%Id()
}

ClassMethod GetAppNo() As %String
{
	s ret=""
	s InitNo=$zd(+$H,8)
	s AppNo=$O(^DHCNMG.HR.MgTransAppI("appno",""),-1)
	s No=$tr(AppNo," ","")
	i No="" s ret=$zd(+$H,8)_"0001" 
	e  d
	.i $E(No,1,8)=InitNo d
	..s ret=No+1
	.e  d
	..s ret=InitNo_"0001"
	q ret
}

ClassMethod GetNurse(parr As %String) As %String
{
	//TransOutDep「1~TransNurse「1@TransOutDep「1~TransNurse「5@TransOutDep「1~TransNurse「6
	s ret=""
	s len=$l(parr,"@")
	f i=1:1:len
	{
		s itm=$P(parr,"@",i)
		i itm'="" 
		{
			;s ret=ret_"^"_$P($P(itm,"~",2),"「",2)
			s dep=$P($p(itm,"~",1),"「",2)
			s nurse=$P($P(itm,"~",2),"「",2)
			i ret'="" s ret=ret_"^"_dep_"|"_nurse
			e  s ret=dep_"|"_nurse
		}
	}
	q ret
}

/// Creator:gzj
/// Description:查询调科申请表
/// Date:2017-06-26
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindTransApp","")
Query FindTransApp(parr As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransAppExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s transappno=$p(parr,"^",1)
	s transward=$p(parr,"^",2)
	s stdate=$p(parr,"^",3)
	i stdate'="" s stdate=$zdh(stdate,3)
	s enddate=$p(parr,"^",4)
	i enddate'="" s enddate=$zdh(enddate,3)
	s transtype=$p(parr,"^",5)
	s status=$p(parr,"^",6)
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s appNo="" f  s appNo=$O(^DHCNMG.HR.MgTransAppI("appno",appNo)) q:appNo=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.HR.MgTransAppI("appno",appNo,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.HR.MgTransApp).%OpenId(rowid)
	..q:'$IsObject(obj)
	..q:((status'="")&&(obj.TransStatus'=status))
	..s isExist=1
	..i isAll=1 s isExist=0
	..e  d
	...i ((obj.TransInDep'="")&&($d(tmpWard(obj.TransInDep)))) s isExist=0
	...i isExist=1 d
	....f i=1:1:obj.TransNurse.Count() d
	.....q:obj.TransNurse.GetAt(i)=""
	.....s dept=$p(obj.TransNurse.GetAt(i),"|")
	.....i (dept'="")&&($d(tmpWard(dept))) s isExist=0
	..q:isExist=1
	..q:((transtype'="")&&(obj.TransType'=transtype))
	..s TransAppNo=obj.TransAppNo
	..q:((transappno'="")&&(TransAppNo'=transappno))
	..s str=##class(web.NurMgDBComm).GetWard(obj.TransInDep)
	..s TransInDep=$P($P(str,"^",3),"|",2)
	..q:((transward'="")&&(obj.TransInDep'=transward))
	..s TransNurse=..GetAppNurse(obj.TransNurse)
	..i obj.TransStatus="N" s TransStatus="未提交"
	..e  i obj.TransStatus="Y" s TransStatus="已提交"
	..e  i obj.TransStatus="A" s TransStatus="已审核"
	..e  i obj.TransStatus="B" s TransStatus="驳回"
	..i obj.TransDate'="" s TransDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TransDate)
	..e  s TransDate=""
	..q:((stdate'="")&&(obj.TransDate<stdate))
	..i obj.CreateDate'="" s CreateDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.CreateDate)
	..e  s CreateDate=""
	..i obj.CreateUser="0" s CreateUser="管理员"
	..e  d
	...s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.CreateUser)
	...s CreateUser=PerObj.PerName
	..s TransReason=obj.TransReason
	..s TransChecker=obj.TransChecker
	..s TransOpinion=obj.TransOpinion
	..i obj.TransEndDate'="" s TransEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TransEndDate)
	..e  s TransEndDate=""
	..s transType=""
	..i obj.TransType'="" d
	...s transTypeObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId($tr(obj.TransType,"__","||"))
	...q:'$IsObject(transTypeObj)
	...s transType=transTypeObj.SubDesc
	..s transOutDep=..GetNurseOutDep(obj.TransNurse)
	..s transNum=obj.TransCount
	..s ret="transAppNo|"_TransAppNo_"^transInDep|"_TransInDep_"^transNurse|"_TransNurse_"^transStatus|"_TransStatus_"^transDate|"_TransDate_"^createDate|"_CreateDate_"^createUser|"_CreateUser_"^transReason|"_TransReason_"^transChecker|"_TransChecker_"^transOpinion|"_TransOpinion_"^rw|"_rowid_"^transEndDate|"_TransEndDate_"^transType|"_transType_"^transOutDep|"_transOutDep
	..s ret=ret_"^CreateUserPr|"_obj.CreateUser_"^transNum|"_transNum_"^StateCode|"_obj.TransStatus
	..do OutputPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransAppExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindTransAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransAppExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNurseOutDep(list) As %String
{
	s ret=""
	i list.GetAt(1)'="" s itm=list.GetAt(1)
	e  s itm=list.GetAt(2)
	s dep=$p(itm,"|",1)
	s obj=##class(DHCNMG.DB.MgWard).%OpenId(dep)
	q:'$IsObject(obj) ""
	s ret=obj.WardDesc
	q ret
}

ClassMethod GetAppNurse(obj) As %String
{
	s ret=""
	s len=obj.Count()
	f i=1:1:len
	{
		s itm=obj.GetAt(i)
		i ret="" s ret=..GetNurseInfo($P(itm,"|",2))
		e  s ret=ret_","_..GetNurseInfo($P(itm,"|",2))
	}
	q ret
}

ClassMethod GetNurseInfo(id As %String) As %String
{
	s list=""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	q:'$IsObject(obj) ""
	s list=obj.PerName
	q list
}

ClassMethod GetTransRec(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCNMG.HR.MgTransApp).%OpenId(id)
	q:'$IsObject(obj)
	i obj.TransDate'="" s TransDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TransDate)
	e  s TransDate=""
	s TransInDep=obj.TransInDep
	i obj.TransNurse'="" d
	.s TransNurse=..GetTransNurse(obj.TransNurse)
	e  s TransNurse=""
	s TransReason=obj.TransReason
	s TransType=obj.TransType
	i obj.TransEndDate'="" s TransEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TransEndDate)
	e  s TransEndDate=""
	s RowID=id
	s TransNum=obj.TransCount
	s ret="TransDate|"_TransDate_"^TransInDep|"_TransInDep_"^TransReason|"_TransReason_"^RowID|"_id_"^TransNurse|"_TransNurse_"^TransType|"_TransType_"^TransEndDate|"_TransEndDate_"^TransNum|"_TransNum
	q ret
}

ClassMethod GetTransNurse(obj) As %String
{
	s len=obj.Count()
	s ret="["
	f i=1:1:len
	{
		s itm=obj.GetAt(i)
		s dep=$P(itm,"|",1)
		s nurse=$P(itm,"|",2)
		s depstr=##class(web.NurMgDBComm).GetWard(dep)
		s nursedep=$P($P(depstr,"^",3),"|",2)
		s nurseobj=##class(DHCNMG.HR.MgPersons).%OpenId(nurse)
		s nursename=nurseobj.PerName
		s nurseid=nurseobj.PerID
		s ret=ret_"{'nurseid':'"_nurseid_"','nursename':'"_nursename_"','nursedep':'"_nursedep_"','nursedepcode':'"_dep_"','rowid':'"_nurse_"'"
		s ret=ret_"},"
	}
	i ret'="[" s ret=$E(ret,1,$L(ret)-1)
	s ret=ret_"]"
	q ret
}

ClassMethod IsValidTransRec(id As %String) As %String
{
	s ret=0
	s obj=##class(DHCNMG.HR.MgTransApp).%OpenId(id)
	q:'$IsObject(obj)
	i obj.TransStatus="N" s ret=1 //未提交
	e  i obj.TransStatus="Y" s ret=2 //已提交
	e  i obj.TransStatus="A" s ret=3 //已审核
	e  i obj.TransStatus="B" s ret=4 //驳回
	q ret
}

/// 
/// Creator:gzj
/// Description:提交审核状态
/// Date:2017-08-30
/// Table:DHCNMG.HR.MgTransApp
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SubmitSatus(parr As %String, id As %String) As %String
{
	s obj=##class(DHCNMG.HR.MgTransApp).%OpenId(id)
	q:'$IsObject(obj)
	s obj.TransStatus=parr
	d obj.%Save()
	q 0
}

ClassMethod GetTransCheckRec(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCNMG.HR.MgTransApp).%OpenId(id)
	q:'$IsObject(obj)
	i obj.TransDate'="" s CheckTranDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TransDate)
	e  s CheckTranDate=""
	s CheckTranInDep=obj.TransInDep
	i obj.TransNurse'="" d
	.s CheckTranNurse=..GetTransNurse(obj.TransNurse)
	e  s CheckTranNurse=""
	s CheckTranReason=obj.TransReason
	s RowID=id
	s TransRadio=obj.TransRadio
	i TransRadio="" s TransRadio=1
	s ret="CheckTranDate|"_CheckTranDate_"^CheckTranInDep|"_CheckTranInDep_"^CheckTranReason|"_CheckTranReason_"^RowID|"_id_"^CheckTranNurse|"_CheckTranNurse_"^TransRadio|"_TransRadio
	q ret
}

/// Creator:gzj
/// Date:2019-05-13
/// Description:审核调科时检测调科人员是否存在排班数据
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod CheckIsHasArg(id As %String) As %String
{
	q:id="" 0
	s ret=""
	s obj=##class(DHCNMG.HR.MgTransApp).%OpenId(id)
	q:'$IsObject(obj) 0
	s TransDate=obj.TransDate
	s len=obj.TransNurse.Count()
	f i=1:1:len
	{
		
		s itm=obj.TransNurse.GetAt(i)
		i itm="" continue
		s ward=$p(itm,"|",1)
		s nurse=$p(itm,"|",2)
		i ((nurse="")!(ward="")) continue
		s date=TransDate-1 f  s date=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",nurse,date)) q:date=""  d
		.s rw="" f  s rw=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",nurse,date,rw)) q:rw=""  d
		..s argObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(rw)
		..q:'$IsObject(argObj)
		..i ret="" s ret=argObj.ArgPerDR.PerName
		..e  s ret=ret_";"_argObj.ArgPerDR.PerName
	}
	q ret
}

/// 
/// Creator:gzj
/// Description:审核状态
/// Date:2017-08-30
/// Table:DHCNMG.HR.MgTransApp
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod CheckTransRec(id As %String, opinion As %String, status As %String, transRadio As %String) As %String
{
	q:id="" 0
	s flag=1
	s obj=##class(DHCNMG.HR.MgTransApp).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.TransOpinion=$tr(opinion," ","")
	s obj.TransStatus=status
	s obj.TransRadio=transRadio
	TS
	s sc=obj.%Save()
	s flag=(flag&&$$$ISOK(sc))
	i status="A"
	{
		s len=obj.TransNurse.Count()
		f i=1:1:len
		{
			s itm=obj.TransNurse.GetAt(i)
			s nurseid=$P(itm,"|",2)
			s nursedep=obj.TransInDep
			s stdate=obj.TransDate
			i (obj.TransDate<=(+$H))
			{
				s transRw=$o(^DHCNMG.HR.MgTransDepI("Current"," Y"," "_nurseid,""))
				i transRw=""
				{
					///某人调科记录不存在 则插入一条新的
					s TransObj=##class(DHCNMG.HR.MgTransDep).%New()
					s TransObj.PerDr=nurseid
					s TransObj.PerDepart=nursedep
					s TransObj.PerTranStDate=stdate
					s TransObj.PerTranStTime=$zth("00:00:00",1)
					s TransObj.PerTranCurrent="Y"
					s TransObj.PerTransType="L"
					s TransSc=TransObj.%Save()
					s flag=(flag&&$$$ISOK(TransSc))
					i flag=1
					{
						s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
						s PerObj.PerDepDR=nursedep
						s PerObj.PerDepDate=stdate
						s PerSc=PerObj.%Save()
						s flag=(flag&&$$$ISOK(PerSc))
					}
				}
				else
				{
					s TransObj=##class(DHCNMG.HR.MgTransDep).%OpenId(transRw)
					s TransObj.PerTranEndDate=stdate
					s TransObj.PerTranEndTime=$zth("00:00:00",1)
					s TransObj.PerTranCurrent="N"
					s TransObj.PerTransType="L"
					s TransObj.PerAppID=obj.%Id()
					s TransSc=TransObj.%Save()
					s flag=(flag&&$$$ISOK(TransSc))
					i flag=1
					{
						s NewTransObj=##class(DHCNMG.HR.MgTransDep).%New()
						s NewTransObj.PerDr=nurseid
						s NewTransObj.PerDepart=nursedep
						s NewTransObj.PerTranStDate=stdate
						s NewTransObj.PerTranStTime=$p($H,",",2)
						s NewTransObj.PerTranCurrent="Y"
						s NewTransObj.PerAppID=obj.%Id()
						s NewTransObj.PerTransType=obj.TranSpecy
						s NewTransSc=NewTransObj.%Save()
						s flag=(flag&&$$$ISOK(NewTransSc))
						i flag=1
						{
							s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
							s PerObj.PerDepDR=nursedep
							s PerObj.PerDepDate=stdate
							s PerSc=PerObj.%Save()
							s flag=(flag&&$$$ISOK(PerSc))
						}
					}
					
				}
			}
			else
			{
				s parr="^"_nurseid_"^"_nursedep_"^"_stdate_"^0^P^^"_obj.%Id()_"^"_obj.TranSpecy
				s objNew=##class(DHCNMG.HR.MgTransDep).%New()
				s objNew.PerDr=nurseid
				s objNew.PerDepart=nursedep
				s objNew.PerTranStDate=stdate
				s objNew.PerTranStTime=$p($H,",",2)
				s objNew.PerTranCurrent="P"
				s objNew.PerAppID=obj.%Id()
				s objNew.PerTransType=obj.TranSpecy
				s objNewSc=objNew.%Save()
				s flag=(flag&&$$$ISOK(objNewSc))
			}
		}
	}
	i flag=1 tc
	e  tro
	q flag
}

/// Creator:gzj
/// Description:保存职称信息
/// Date:2017-08-22
/// Table:DHCNMG.HR.MgHireDuty
/// Input:
/// Output：
/// Return:
/// Others: HireDuty|14__2^HireStDate|2017-08-22^HireEndDate|^HireRemark|^RowID|^HirePerDR|1
ClassMethod SaveDuty(parr As %String, type As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgHireDuty).%New()
	e  s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(id)
	
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgHireDuty","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p'="HirePerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgHireDuty","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="HirePerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..;s tmp("HireStatus")="N"
	..s tmp("HireStatus")=type
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

/// 获取聘任职称记录状态
ClassMethod GetDutyStatus(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(id)
	q:'$IsObject(obj) ""
	s flag=obj.HireStatus
	q flag
}

/// Creator:gzj
/// Description:查询职称列表
/// Date:2017-08-22
/// Table:DHCNMG.HR.MgHireDuty
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindDutyList","")
Query FindDutyList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindDutyListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s par="" f  s par=$O(^DHCNMG.HR.MgHireDutyI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgHireDutyI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(rw)
	..i obj.HireDuty'="" s HireDuty=..GetCommCode(obj.HireDuty)
	..e  s HireDuty=""
	..i obj.HireStDate'="" s HireStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.HireStDate)
	..e  s HireStDate=""
	..i obj.HireEndDate'="" s HireEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.HireEndDate)
	..e  s HireEndDate=""
	..s HireRemark=obj.HireRemark
	..s status=""
	..i obj.HireStatus="N" s status="保存"
	..e  i obj.HireStatus="Y" s status="提交"
	..e  i obj.HireStatus="A" s status="审核"
	..e  i obj.HireStatus="B" s status="驳回"
	..s ret="hireDuty|"_HireDuty_"^hireStDate|"_HireStDate_"^hireEndDate|"_HireEndDate_"^hireRemark|"_HireRemark_"^hireRowID|"_rw_"^status|"_status
	..do OutputDutyData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDutyData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDutyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDutyListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindDutyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDutyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod AuditDutyRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.HireStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Description:查询职称、职务
/// Date:2017-08-22
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetCommCode(id As %String) As %String
{
	s Desc=""
	s a=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(id)
	q:'$IsObject(a) ""
	s Desc=a.SubDesc
	q Desc
}

/// Creator:gzj
/// Description:获取职称记录
/// Date:2017-08-23
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetDutyItem(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(id)
	s HireDuty=obj.HireDuty
	i obj.HireStDate'="" s HireStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.HireStDate)
	e  s HireStDate=""
	i obj.HireEndDate'="" s HireEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.HireEndDate)
	e  s HireEndDate=""
	s HireRemark=obj.HireRemark
	s ret="HireDuty|"_HireDuty_"^HireStDate|"_HireStDate_"^HireEndDate|"_HireEndDate_"^HireRemark|"_HireRemark_"^RowID|"_id
	q ret
}

/// Creator:gzj
/// Description:保存职务信息
/// Date:2017-08-23
/// Table:DHCNMG.HR.MgPostDuty
/// Input:
/// Output：
/// Return:
/// Others: PostDuty|14__2^PostStDate|2017-08-22^PostEndDate|^PostRemark|^RowID|^PostPerDR|1
ClassMethod SavePost(parr As %String, type As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgPostDuty).%New()
	e  s obj=##class(DHCNMG.HR.MgPostDuty).%OpenId(id)
	
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgPostDuty","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p'="PostPerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgPostDuty","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="PostPerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..;s tmp("PostStatus")="N"
	..s tmp("PostStatus")=type
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

/// Creator:gzj
/// Description:查询职务列表
/// Date:2017-08-23
/// Table:DHCNMG.HR.MgPostDuty
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindPostList","")
Query FindPostList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPostListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s par="" f  s par=$O(^DHCNMG.HR.MgPostDutyI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgPostDutyI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgPostDuty).%OpenId(rw)
	..i obj.PostDuty'="" s PostDuty=..GetCommCode(obj.PostDuty)
	..e  s PostDuty=""
	..i obj.PostStDate'="" s PostStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PostStDate)
	..e  s PostStDate=""
	..i obj.PostEndDate'="" s PostEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PostEndDate)
	..e  s PostEndDate=""
	..s PostRemark=obj.PostRemark
	..s status=""
	..i obj.PostStatus="N" s status="保存"
	..e  i obj.PostStatus="Y" s status="提交"
	..e  i obj.PostStatus="A" s status="审核"
	..e  i obj.PostStatus="B" s status="驳回"
	..s ret="postDuty|"_PostDuty_"^postStDate|"_PostStDate_"^postEndDate|"_PostEndDate_"^postRemark|"_PostRemark_"^postRowID|"_rw_"^status|"_status
	..do OutputPostData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPostData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPostListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPostListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPostListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPostListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPostStatus(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(DHCNMG.HR.MgPostDuty).%OpenId(id)
	q:'$IsObject(obj) ""
	s flag=obj.PostStatus
	q flag
}

ClassMethod AuditPostRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgPostDuty).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.PostStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Description:获取职务记录
/// Date:2017-08-23
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetPostItem(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgPostDuty).%OpenId(id)
	s PostDuty=obj.PostDuty
	i obj.PostStDate'="" s PostStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PostStDate)
	e  s PostStDate=""
	i obj.PostEndDate'="" s PostEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PostEndDate)
	e  s PostEndDate=""
	s PostRemark=obj.PostRemark
	s ret="PostDuty|"_PostDuty_"^PostStDate|"_PostStDate_"^PostEndDate|"_PostEndDate_"^PostRemark|"_PostRemark_"^RowID|"_id
	q ret
}

/// Creator:gzj
/// Description:保存教育经历信息
/// Date:2017-08-30
/// Table:DHCNMG.HR.MgEducate
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod SaveEducate(parr As %String, type As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgEducate).%New()
	e  s obj=##class(DHCNMG.HR.MgEducate).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgEducate","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p'="EduPerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgEducate","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="EduPerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..s tmp("EduStatus")=type
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

ClassMethod GetEducateStatus(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(DHCNMG.HR.MgEducate).%OpenId(id)
	q:'$IsObject(obj) ""
	s flag=obj.EduStatus
	q flag
}

ClassMethod AuditEducateRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgEducate).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.EduStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Description:查询教育经历列表
/// Date:2017-08-30
/// Table: DHCNMG.HR.MgEducate
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindEduList","")
Query FindEduList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindEduListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s n=1
	s flag="false"
	s par="" f  s par=$O(^DHCNMG.HR.MgEducateI("flag",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s date="" f  s date=$O(^DHCNMG.HR.MgEducateI("flag",par,date)) q:date=""  d
	..s rw="" f  s rw=$O(^DHCNMG.HR.MgEducateI("flag",par,date,rw)) q:rw=""  d
	...s obj=##class(DHCNMG.HR.MgEducate).%OpenId(rw)
	...;q:obj.EduStatus'="A"
	...i obj.EduStDate'="" s EduStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduStDate)
	...e  s EduStDate=""
	...i obj.EduEndDate'="" s EduEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduEndDate)
	...e  s EduEndDate=""
	...i obj.EduSchool'="" s EduSchool=..GetCommCode(obj.EduSchool)
	...e  s EduSchool=""
	...i obj.EduAcademic'="" s EduAcademic=..GetCommCode(obj.EduAcademic)
	...e  s EduAcademic=""
	...i obj.EduDegree'="" s EduDegree=..GetCommCode(obj.EduDegree)
	...e  s EduDegree=""
	...i obj.EduProfession'="" s EduProfession=..GetCommCode(obj.EduProfession)
	...e  s EduProfession=""
	...s EduRadio=""
	...i obj.EduRadio'="" d
	....s eduobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.EduRadio)
	....q:'$IsObject(eduobj)
	....s EduRadio=eduobj.SubDesc
	...i obj.EduDegreeDate'="" s EduDegreeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduDegreeDate)
	...e  s EduDegreeDate=""
	...s eduAcadeType=""
	...i EduRadio="全日制" d
	....i flag="false" d
	.....s eduAcadeType="第一学历"
	.....s flag="true"
	...s count=..GetCountAcade(par)
	...i ((n=count)&&(n>1)) d
	....s eduAcadeType="最高学历"
	...s n=n+1
	...s status=""
	...i obj.EduStatus="N" s status="保存"
	...e  i obj.EduStatus="Y" s status="提交"
	...e  i obj.EduStatus="A" s status="审核"
	...e  i obj.EduStatus="B" s status="驳回"
	...s ret="eduStDate|"_EduStDate_"^eduEndDate|"_EduEndDate_"^eduSchool|"_EduSchool_"^eduAcademic|"_EduAcademic_"^eduDegree|"_EduDegree_"^eduRowID|"_rw_"^eduProfession|"_EduProfession_"^eduRadio|"_EduRadio_"^eduDegreeDate|"_EduDegreeDate_"^eduAcadeType|"_eduAcadeType_"^status|"_status
	...do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindEduListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEduListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindEduListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEduListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取学历的数量
ClassMethod GetCountAcade(par) As %String
{
	s n=0
	s date="" f  s date=$O(^DHCNMG.HR.MgEducateI("flag",par,date)) q:date=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgEducateI("flag",par,date,rw)) q:rw=""  d
	..s n=n+1
	q n
}

ClassMethod GetSortAcade(par As %String, rw As %String) As %String
{
	s firstAcadeType="",lastAcadeType="",n=0
	s date="" f  s date=$O(^DHCNMG.HR.MgEducateI("flag",par,date)) q:date=""  d
	.s row="" f  s row=$O(^DHCNMG.HR.MgEducateI("flag",par,date,row)) q:row=""  d
	..q:(row'=rw)
	..s obj=##class(DHCNMG.HR.MgEducate).%OpenId(row)
	..i obj.EduRadio'="" d
	...s subobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.EduRadio)
	...q:'$IsObject(subobj)
	...q:(n>1)
	...i subobj.SubDesc="全日制" d
	....s firstAcadeType="第一学历"
	....s n=n+1
	q firstAcadeType
}

/// Creator:gzj
/// Description:获取教育经历记录
/// Date:2017-08-30
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetEduItem(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgEducate).%OpenId(id)
	i obj.EduStDate'="" s EduStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduStDate)
	e  s EduStDate=""
	i obj.EduEndDate'="" s EduEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduEndDate)
	e  s EduEndDate=""
	s EduSchool=obj.EduSchool
	s EduAcademic=obj.EduAcademic
	s EduDegree=obj.EduDegree
	s EduRadio=obj.EduRadio
	s EduProfession=obj.EduProfession
	i obj.EduDegreeDate'="" s EduDegreeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduDegreeDate)
	e  s EduDegreeDate=""
	s ret="EduStDate|"_EduStDate_"^EduEndDate|"_EduEndDate_"^EduSchool|"_EduSchool_"^EduAcademic|"_EduAcademic_"^EduDegree|"_EduDegree_"^RowID|"_id_"^EduRadio|"_EduRadio_"^EduProfession|"_EduProfession_"^EduDegreeDate|"_EduDegreeDate
	q ret
}

/// Creator:gzj
/// Description:保存工作经历信息
/// Date:2017-08-30
/// Table:DHCNMG.HR.MgWork
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod SaveWork(parr As %String, type As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgWork).%New()
	e  s obj=##class(DHCNMG.HR.MgWork).%OpenId(id)
	
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgWork","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p'="WorkPerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgWork","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="WorkPerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..s tmp("WorkStatus")=type
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

ClassMethod GetWorkStatus(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(DHCNMG.HR.MgWork).%OpenId(id)
	q:'$IsObject(obj) ""
	s flag=obj.WorkStatus
	q flag
}

ClassMethod AuditWorkRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgWork).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.WorkStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Description:查询工作经历列表
/// Date:2017-08-30
/// Table: DHCNMG.HR.MgEducate
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindWorkList","")
Query FindWorkList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWorkListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s par="" f  s par=$O(^DHCNMG.HR.MgWorkI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgWorkI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgWork).%OpenId(rw)
	..i obj.WorkStDate'="" s WorkStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.WorkStDate)
	..e  s WorkStDate=""
	..i obj.WorkEndDate'="" s WorkEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.WorkEndDate)
	..e  s WorkEndDate=""
	..s WorkUnit=obj.WorkUnit
	..i obj.WorkPost'="" s WorkPost=..GetCommCode(obj.WorkPost)
	..e  s WorkPost=""
	..i obj.WorkDuty'="" s WorkDuty=..GetCommCode(obj.WorkDuty)
	..e  s WorkDuty=""
	..s WorkRemark=obj.WorkRemark
	..s worktype=""
	..i obj.WorkStatus="N" s workStatus="保存"
	..e  i obj.WorkStatus="Y" s workStatus="提交"
	..e  i obj.WorkStatus="A" s workStatus="审核"
	..e  i obj.WorkStatus="B" s workStatus="驳回"
	..s statusCode=obj.WorkStatus
	..s ret="workStDate|"_WorkStDate_"^workEndDate|"_WorkEndDate_"^workUnit|"_WorkUnit_"^workPost|"_WorkPost_"^workDuty|"_WorkDuty_"^workRemark|"_WorkRemark_"^workRowID|"_rw_"^worktype|"_worktype_"^workStatus|"_workStatus_"^statusCode|"_statusCode  
	..do OutputEduData
	s ret=""
	s transrw="" f  s transrw=$O(^DHCNMG.HR.MgTransDepI("ssdr"," "_parr,transrw)) q:transrw=""  d
	.s transobj=##class(DHCNMG.HR.MgTransDep).%OpenId(transrw)
	.q:transobj.PerTranCurrent="P"
	.s WorkStDate=""
	.i transobj.PerTranStDate'="" s WorkStDate=##class(web.NurMgHISComm).DateLogicalToHtml(transobj.PerTranStDate)
	.e  s WorkStDate=""
	.s WorkEndDate=""
	.i transobj.PerTranEndDate'="" s WorkEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(transobj.PerTranEndDate)
	.e  s WorkEndDate=""
	.s WorkUnit=""
	.i transobj.PerDepart'="" d
	..s unitObj=##class(DHCNMG.DB.MgWard).%OpenId(transobj.PerDepart)
	..s WorkUnit=unitObj.WardDesc
	.;s workPost=""
	.;s postrowid="" f  s postrowid=$O(^DHCNMG.HR.MgPostDutyI("ssid",par,postrowid)) q:postrowid=""  d
	.s worktype="T"
	.s statusCode="A"
	.s ret="workStDate|"_WorkStDate_"^workEndDate|"_WorkEndDate_"^workUnit|"_WorkUnit_"^workPost|"_""_"^workDuty|"_""_"^workRemark|"_""_"^workRowID|"_transrw_"^worktype|"_worktype_"^statusCode|"_statusCode
	.do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWorkListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWorkListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:获取工作经历记录
/// Date:2017-08-30
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetWorkItem(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgWork).%OpenId(id)
	i obj.WorkStDate'="" s WorkStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.WorkStDate)
	e  s WorkStDate=""
	i obj.WorkEndDate'="" s WorkEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.WorkEndDate)
	e  s WorkEndDate=""
	s WorkUnit=obj.WorkUnit
	s WorkDuty=obj.WorkDuty
	s WorkPost=obj.WorkPost
	s WorkRemark=obj.WorkRemark
	s ret="WorkStDate|"_WorkStDate_"^WorkEndDate|"_WorkEndDate_"^WorkUnit|"_WorkUnit_"^WorkPost|"_WorkPost_"^WorkDuty|"_WorkDuty_"^WorkRemark|"_WorkRemark_"^RowID|"_id
	q ret
}

/// Creator:gzj
/// Description:保存护士层级信息
/// Date:2017-08-30
/// Table: DHCNMG.HR.MgLevel
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod SaveLevel(parr As %String, type As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgLevel).%New()
	e  s obj=##class(DHCNMG.HR.MgLevel).%OpenId(id)
	
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgLevel","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p'="LevelPerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgLevel","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="LevelPerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..s tmp("LevelStatus")=type
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

ClassMethod GetLevelStatus(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(DHCNMG.HR.MgLevel).%OpenId(id)
	q:'$IsObject(obj) ""
	s flag=obj.LevelStatus
	q flag
}

ClassMethod AuditLevelRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgLevel).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.LevelStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Description:查询护士层级列表
/// Date:2017-08-30
/// Table: DHCNMG.HR.MgLevel
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindLevelList","1")
Query FindLevelList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindLevelListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s par="" f  s par=$O(^DHCNMG.HR.MgLevelI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgLevelI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgLevel).%OpenId(rw)
	..i obj.LevelDate'="" s LevelDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.LevelDate)
	..e  s LevelDate=""
	..i obj.NurLevel'="" s NurLevel=..GetCommCode(obj.NurLevel)
	..e  s NurLevel=""
	..s LevelRemark=obj.LevelRemark
	..s status=""
	..i obj.LevelStatus="N" s status="保存"
	..e  i obj.LevelStatus="Y" s status="提交"
	..e  i obj.LevelStatus="A" s status="审核"
	..e  i obj.LevelStatus="B" s status="驳回"
	..s levelFactor=obj.LevelFactor
	..s ret="levelDate|"_LevelDate_"^nurLevel|"_NurLevel_"^levelRemark|"_LevelRemark_"^levelRowID|"_rw_"^status|"_status_"^levelFactor|"_levelFactor    
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLevelListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLevelListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindLevelListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLevelListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:获取护士层级记录
/// Date:2017-08-30
/// Table: DHCNMG.HR.MgLevel
/// Input:
/// Output：
/// Return:
ClassMethod GetLevelItem(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgLevel).%OpenId(id)
	i obj.LevelDate'="" s LevelDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.LevelDate)
	e  s LevelDate=""
	s NurLevel=obj.NurLevel
	s LevelRemark=obj.LevelRemark
	s LevelFactor=obj.LevelFactor
	s ret="LevelDate|"_LevelDate_"^NurLevel|"_NurLevel_"^LevelRemark|"_LevelRemark_"^RowID|"_id_"^LevelFactor|"_LevelFactor
	q ret
}

/// Creator:gzj
/// Description:按照病区取护士信息
/// Date:2017-08-31
/// Table: DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindNurInfoOfWard","1","0","0")
Query FindNurInfoOfWard(parr As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurInfoOfWardExecute(ByRef qHandle As %Binary, parr As %String, role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s dep="" f  s dep=$O(^DHCNMG.HR.MgPersonsI("DepID",dep)) q:dep=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsI("DepID",dep,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	..s curward=##class(web.NurMgHRComm).GetCurrentWard(rowid,+$h)
	..q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	..q:((parr'="")&&(curward'=parr))
	..q:obj.PerTypeDR'="N"
	..s nursename=obj.PerName
	..s nurseno=obj.PerID
	..s ret="nursename|"_nursename_"^nurseno|"_nurseno_"^nurserow|"_rowid_"^nursedep|"_obj.PerDepDR
	..do OutputNurData

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurInfoOfWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurInfoOfWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurInfoOfWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurInfoOfWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:保存技术能手、服务之星数据
/// Date:2017-08-31
/// Table: DHCNMG.HR.MgTechService
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod SaveElectes(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgTechService).%New()
	e  s obj=##class(DHCNMG.HR.MgTechService).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgTechService","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s ptype=^oddCOM("DHCNMG.HR.MgTechService","a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(tmp(p)'="")) d
	...s tmp(p)=$zdh(tmp(p),3)
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

/// Creator:gzj
/// Description:查询技术能手、服务之星数据列表
/// Date:2017-08-31
/// Table: DHCNMG.HR.MgTechService
/// Input:parr:2017-08-01^2017-08-31^2^N
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindElecteList","")
Query FindElecteList(parr As %String = "", type As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindElecteListExecute(ByRef qHandle As %Binary, parr As %String = "", type As %String, role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s stmonth=$p(parr,"^",1)
	i stmonth'="" s stdate=$zdh(stmonth,3)
	e  s stdate=""
	s endmonth=$p(parr,"^",2)
	i endmonth'="" s enddate=$zdh(endmonth,3)
	e  s enddate=""
	s ward=$p(parr,"^",3)
	s statu=$p(parr,"^",4)
	k tmpWard
	s tmpWard="",isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s date="" f  s date=$O(^DHCNMG.HR.MgTechServiceI("type"," "_type,date)) q:date=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.HR.MgTechServiceI("type"," "_type,date,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.HR.MgTechService).%OpenId(rowid)
	..q:((stdate'="")&&(obj.ElecteDate<stdate))
	..q:((enddate'="")&&(obj.ElecteDate>enddate))
	..q:(isAll=0)&&((obj.ElecteWard="")||('$d(tmpWard(obj.ElecteWard))))
	..q:((ward'="")&&(obj.ElecteWard'=ward))
	..q:((statu'="")&&(obj.ElecteStatus'=statu))
	..i obj.ElecteNurse'="" s ElecteNurse=..GetNurseInfo(obj.ElecteNurse)
	..e  s ElecteNurse=""
	..i obj.ElecteDate'="" s ElecteDate=$E($zd(obj.ElecteDate,8),1,4)_"-"_$E($zd(obj.ElecteDate,8),5,6)
	..e  s ElecteDate=""
	..i obj.ElecteWard'="" d
	...s rec=##class(web.NurMgDBComm).GetWard(obj.ElecteWard)
	...s ElecteWard=$p($p(rec,"^",3),"|",2)
	..e  s ElecteWard=""
	..i obj.ElecteUser=0 s ElecteUser="管理员"
	..e  i (obj.ElecteUser'="")&&(obj.ElecteUser'=0) s ElecteUser=..GetNurseInfo(obj.ElecteUser)
	..e  s ElecteUser=""
	..s RecDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.RecDate)
	..i obj.ElecteStatus="N" s ElecteStatus="未提交"
	..e  i obj.ElecteStatus="Y" s ElecteStatus="已提交"
	..s ElecteUserId=obj.ElecteUser
	..s ret="electeNurse|"_ElecteNurse_"^electeDate|"_ElecteDate_"^electeWard|"_ElecteWard_"^electeUser|"_ElecteUser_"^recDate|"_RecDate_"^electeStatus|"_ElecteStatus_"^rowid|"_rowid_"^electeUserId|"_ElecteUserId
	..do OutputElecterData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputElecterData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindElecteListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindElecteListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindElecteListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindElecteListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:获取技术能手 服务之星数据
/// Date:2017-08-31
/// Table: DHCNMG.HR.MgTechService
/// Input:
/// Output：
/// Return:
ClassMethod GetElecteItem(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgTechService).%OpenId(id)
	s ElecteNurse=obj.ElecteNurse
	i obj.ElecteDate'="" s ElecteDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ElecteDate)
	.e  s ElecteDate=""
	s ElecteWard=obj.ElecteWard
	s ret="ElecteNurse|"_ElecteNurse_"^ElecteDate|"_ElecteDate_"^ElecteWard|"_ElecteWard_"^RowID|"_id
	q ret
}

/// Creator:gzj
/// Description:获取技术能手 服务之星记录状态
/// Date:2017-08-31
/// Table: DHCNMG.HR.MgTechService
/// Input:
/// Output：
/// Return:
ClassMethod JudgeRec(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCNMG.HR.MgTechService).%OpenId(id)
	q:'$IsObject(obj)
	s ret=obj.ElecteStatus
	q ret
}

/// Creator:gzj
/// Description:保存奖惩情况数据
/// Date:2017-09-05
/// Table: DHCNMG.HR.MgNurReward
/// Input:
/// Output：
/// Return:
ClassMethod SaveReward(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgNurReward).%New()
	e  s obj=##class(DHCNMG.HR.MgNurReward).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgNurReward","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p="RewardNurse" d
	...s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..e  d
	...s ptype=^oddCOM("DHCNMG.HR.MgNurReward","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Description:查询奖惩情况信息
/// Date:2017-09-05
/// Table:DHCNMG.HR.MgNurReward
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindRewardList","10001^2^2017-09-01^2017-09-06")
Query FindRewardList(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRewardListExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s nurno=$tr($p(parr,"^",1)," ","")
	s nurdep=$p(parr,"^",2)
	s stdate=$p(parr,"^",3)
	s enddate=$p(parr,"^",4)
	i stdate'="" s stdate=$zdh(stdate,3)
	i enddate'="" s enddate=$zdh(enddate,3)
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s date="" f  s date=$O(^DHCNMG.HR.MgNurRewardI("ssid",date)) q:date=""  d
	.s nurse="" f  s nurse=$O(^DHCNMG.HR.MgNurRewardI("ssid",date,nurse)) q:nurse=""  d
	..s rowid="" f  s rowid=$O(^DHCNMG.HR.MgNurRewardI("ssid",date,nurse,rowid)) q:rowid=""  d
	...s obj=##class(DHCNMG.HR.MgNurReward).%OpenId(rowid)
	...q:(isAll=0)&&((obj.RewardWard="")||('$d(tmpWard(obj.RewardWard))))
	...s nurseID=obj.RewardNurse.PerID
	...s nurseName=obj.RewardNurse.PerName
	...s nurseShell=##class(web.NurMgVueComm).ToChineseSpell(nurseName)
	...q:((nurno'="")&&(nurseID_nurseName_nurseShell'[$zcvt(nurno,"U")))
	...q:((nurdep'="")&&(obj.RewardWard'=nurdep))
	...q:((stdate'="")&&(obj.RewardDate<stdate))
	...q:((enddate'="")&&(obj.RewardDate>enddate))
	...;s WardStr=##class(web.NurMgDBComm).GetWard(obj.RewardWard)
	...;s rewardWard=$p($p(WardStr,"^",3),"|",2)
	...i obj.RewardWard'="" d
	....s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.RewardWard)
	....s rewardWard=WardObj.WardDesc
	...e  s rewardWard=""
	...s rewardContent=obj.RewardContent
	...s rewardResult=obj.RewardResult
	...i obj.RewardLevel'="" s rewardLevel=..GetCommCode(obj.RewardLevel)
	...e  s rewardLevel=""
	...i obj.RewardDate'="" s rewardDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.RewardDate)
	...e  s rewardDate=""
	...s ret="^nurseID|"_nurseID_"^nurseName|"_nurseName_"^rewardWard|"_rewardWard_"^rewardContent|"_rewardContent_"^rewardResult|"_rewardResult_"^rewardLevel|"_rewardLevel_"^rewardDate|"_rewardDate_"^rowid|"_rowid
	...do OutputRewardData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRewardData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRewardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRewardListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindRewardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRewardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:查询奖惩情况记录
/// Date:2017-09-05
/// Table: DHCNMG.HR.MgNurReward
/// Input:
/// Output：
/// Return:
ClassMethod GetRewardRec(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgNurReward).%OpenId(id)
	s RewardNurse=obj.RewardNurse.%Id()
	s RewardWard=obj.RewardWard
	s RewardContent=obj.RewardContent
	s RewardUnit=obj.RewardUnit
	s RewardResult=obj.RewardResult
	s RewardLevel=obj.RewardLevel
	i obj.RewardDate'="" s RewardDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.RewardDate)
	e  s RewardDate=""
	s RewardTeacher=obj.RewardTeacher
	s Certifier=obj.Certifier
	s RewardMark=obj.RewardMark
	s ret="RewardNurse|"_RewardNurse_"^RewardWard|"_RewardWard_"^RewardContent|"_RewardContent_"^RewardUnit|"_RewardUnit_"^RewardResult|"_RewardResult_"^RewardLevel|"_RewardLevel_"^RewardDate|"_RewardDate_"^RewardTeacher|"_RewardTeacher_"^Certifier|"_Certifier_"^RewardMark|"_RewardMark_"^RowID|"_id
	q ret
}

ClassMethod GetRoleItem(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgNurRole).%OpenId(id)
	s RoleID=obj.RoleID
	i obj.RoleStDate'="" s RoleStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.RoleStDate)
	e  s RoleStDate=""
	i obj.RoleEndDate'="" s RoleEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.RoleEndDate)
	e  s RoleEndDate=""
	s ret="RoleID|"_RoleID_"^RoleStDate|"_RoleStDate_"^RoleEndDate|"_RoleEndDate_"^RowID|"_id
	q ret
}

/// Creator:gzj
/// Description:保存护士角色信息
/// Date:2017-10-09
/// Table: DHCNMG.HR.MgNurRole
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod SaveRole(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s PerDR=$tr($g(tmp("RolePerDR"))," ","")
	s id=$g(tmp("RowID"))
	TS
	i id="" s obj=##class(DHCNMG.HR.MgNurRole).%New()
	e  s obj=##class(DHCNMG.HR.MgNurRole).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgNurRole","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p'="RolePerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgNurRole","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="RolePerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	i $$$ISOK(sc) d
	.s RoleRaw=$O(^DHCNMG.Set.MgRoleNurseI("nurse",$tr($g(tmp("RoleID"))," ","")," "_$tr($g(PerDR)," ",""),""))
	.i RoleRaw="" d
	..i $g(tmp("RoleEndDate"))="" d
	...s RoleObj=##class(DHCNMG.Set.MgRoleNurse).%New()
	...s RoleObj.Parref=##class(DHCNMG.Set.MgRoles).%OpenId($tr($g(tmp("RoleID"))," ",""))
	...s RoleObj.RoleNurse=PerDR
	...i $g(tmp("RoleStDate"))'="" s RoleObj.RoleStDate=$tr($g(tmp("RoleStDate"))," ","")
	...e  s RoleObj.RoleStDate=""
	...s rolesc=RoleObj.%Save()
	...i $$$ISOK(rolesc) d
	....TCOMMIT
	...e  d
	....TROLLBACK
	..e  d
	...TCOMMIT
	.e  d
	..i $g(tmp("RoleEndDate"))'="" d
	...s RoleObj=##class(DHCNMG.Set.MgRoleNurse).%OpenId($tr($g(tmp("RoleID"))," ","")_"||"_RoleRaw)
	...s rolesc=RoleObj.%DeleteId($tr($g(tmp("RoleID"))," ","")_"||"_RoleRaw)
	...i $$$ISOK(rolesc) d
	....TCOMMIT
	...e  d
	....TROLLBACK
	..e  d
	...TCOMMIT
	e  d
	.TROLLBACK
	
	q 0
}

/// Creator:gzj
/// Description:查询角色列表
/// Date:2017-10-09
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindNurRoleList")
Query FindNurRoleList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurRoleListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s perid="" f  s perid=$O(^DHCNMG.HR.MgNurRoleI("ssid",perid),-1) q:perid=""  d
	.q:((parr'="")&&(perid'=parr))
	.s rowid="" f  s rowid=$O(^DHCNMG.HR.MgNurRoleI("ssid",perid,rowid),-1) q:rowid=""  d
	..s obj=##class(DHCNMG.HR.MgNurRole).%OpenId(rowid)
	..s roleid=obj.RoleID
	..s roleCode="",roleName=""
	..i roleid'="" d
	...s roleobj=##class(DHCNMG.Set.MgRoles).%OpenId(roleid)
	...s roleCode=roleobj.RoleCode
	...s roleName=roleobj.RoleDesc
	..i obj.RoleStDate'="" s rolestdate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.RoleStDate)
	..e  s rolestdate=""
	..i obj.RoleEndDate'="" s roleenddate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.RoleEndDate)
	..e  s roleenddate=""
	..s ret="roleCode|"_roleCode_"^roleName|"_roleName_"^rolestdate|"_rolestdate_"^roleenddate|"_roleenddate_"^roleRowID|"_rowid
	..do OutputRoleList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRoleList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurRoleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurRoleListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurRoleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurRoleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:高级查询：病区列表
/// Date:2017-10-25
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAdvWardList")
Query FindAdvWardList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAdvWardListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	
	do OutputRoleList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRoleList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAdvWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdvWardListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAdvWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdvWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:批量审核调科申请
/// Date:2017-11-06
/// Table:DHCNMG.HR.MgTransApp
/// Input:
/// Output：
/// Return:
ClassMethod MultipleAudit(id As %String, user As %String) As %String
{
	s obj=##class(DHCNMG.HR.MgTransApp).%OpenId(id)
	q:'$IsObject(obj) "审核失败"
	q:obj.TransStatus'="Y" "非提交状态不可审核"
	s obj.TransOpinion="批量审核"
	s obj.TransStatus="A"
	s len=obj.TransNurse.Count()
	f i=1:1:len
	{
		s itm=obj.TransNurse.GetAt(i)
		s nurseid=$P(itm,"|",2)
		s nursedep=obj.TransInDep
		s stdate=$zd(obj.TransDate,3)
		i obj.TransDate<=(+$H)
		{
			s parr="^"_nurseid_"^"_nursedep_"^"_stdate_"^0^Y^^"_obj.%Id()_"^"_obj.TranSpecy
			d ..SaveTransData(parr)
			d ##class(web.NurMgSysTaskComm).ChangePerDepInfo(nurseid,nursedep,obj.TransDate)
		}
		else
		{
			s parr="^"_nurseid_"^"_nursedep_"^"_stdate_"^0^P^^"_obj.%Id()_"^"_obj.TranSpecy
			;d ..SaveTransData(parr)
			s objNew=##class(DHCNMG.HR.MgTransDep).%New()
			s objNew.PerDr=nurseid
			s objNew.PerDepart=nursedep
			s objNew.PerTranStDate=$zdh(stdate,3)
			s objNew.PerTranStTime=$p($H,",",2)
			s objNew.PerTranCurrent="P"
			s objNew.PerAppID=obj.%Id()
			s objNew.PerTransType=obj.TranSpecy
			d objNew.%Save()
		}
		
	}
	d obj.%Save()
	q 1
}

/// Creator:lulin
/// Description:保存证书
/// Date:2017-11-18
/// Table:DHCNMG.HR.MgHireDuty\DHCNMG.HR.MgEducate
/// Input:记录表ID||记录表||文件保存路径
/// Output：
/// Return:
/// Others: d ##Class(web.NurMgPersonComm).InsertPic("3||0||Fileupdate/images/cert/2/Hydrangeas.jpg")
ClassMethod InsertPic(parr As %String) As %String
{
	k tmp
	s id=$p(parr,"||")
	s type=$p(parr,"||",2)
	s Certs=$p(parr,"||",3)
	;默认存储到职称表
	s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(id)
	if type="1"{//学历表
		s obj=##class(DHCNMG.HR.MgEducate).%OpenId(id)
	}
	s len=obj.CertPic.Count()
	f i=1:1:len d
	.s tmp(obj.CertPic.GetAt(i))=obj.CertPic.GetAt(i)
	s l=$l(Certs,"^")
	f i=1:1:l d
	.s Cert=$p(Certs,"^",i)
	.i $d(tmp(Cert))=0 d obj.CertPic.Insert(Cert)
	d obj.%Save()
	k tmp
}

/// 
/// 保存奖励惩罚证书
ClassMethod InsertRewardCard(parr As %String) As %String
{
	s id=$p(parr,"^")
	s Certs=$p(parr,"^",2)
	s obj=##class(DHCNMG.HR.MgNurReward).%OpenId(id)
	q:'$IsObject(obj) ""
	
	d obj.CertPic.Insert(Certs)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Description:获取奖惩证书
/// Date:2017-11-18
/// Table:
/// Input:记录表ID
/// Output：
/// Return:
/// Others: w ##class(web.NurMgPersonComm).FindCert("3||0")
ClassMethod GetRewardCert(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgNurReward).%OpenId(id)
	s len=obj.CertPic.Count()
	s ret=""
	f i=1:1:len d
	.s itm=obj.CertPic.GetAt(i)
	.i i=1 s ret=itm
	.e  s ret=ret_"^"_itm
	
	q id_"|"_ret
}

ClassMethod DeleteRewardCert(parr As %String) As %String
{
	s id=$p(parr,"|")
	s cert=$p(parr,"|",2)
	s tmp=""
	s obj=##class(DHCNMG.HR.MgNurReward).%OpenId(id)
	s len=obj.CertPic.Count()
	f i=1:1:len
	{
		s itm=obj.CertPic.GetAt(i)
		i itm="" continue
		i itm'=cert s tmp(i)=itm
	}
	d obj.CertPic.Clear()
	s rw="" f  s rw=$O(tmp(rw)) q:rw=""  d
	.d obj.CertPic.Insert(tmp(rw))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lulin
/// Description:删除证书
/// Date:2017-11-18
/// Table:DHCNMG.HR.MgHireDuty、DHCNMG.HR.MgEducate
/// Input:记录表ID||记录表||删除文件的路径
/// Output：
/// Return:
/// Others: autoplay
ClassMethod DeleteCert(parr As %String) As %String
{
	s id=$p(parr,"||")
	s type=$p(parr,"||",2)
	s Cert=$p(parr,"||",3)
	;默认存储到职称表
	s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(id)
	if type="1"{//学历表
		s obj=##class(DHCNMG.HR.MgEducate).%OpenId(id)
	}
	s len=obj.CertPic.Count()
	f i=1:1:len d
	.s itm=obj.CertPic.GetAt(i)
	.i itm'=Cert s tem(i)=itm
	d obj.CertPic.Clear()
	s i=0
	f  s i=$o(tem(i)) q:i=""  d
	.d obj.CertPic.Insert(tem(i))
	
	d obj.%Save()
}

/// Creator:lulin
/// Description:获取证书
/// Date:2017-11-18
/// Table:DHCNMG.HR.MgHireDuty、DHCNMG.HR.MgEducate
/// Input:记录表ID||记录表
/// Output：
/// Return:
/// Others: w ##class(web.NurMgPersonComm).FindCert("3||0")
ClassMethod FindCert(parr As %String) As %String
{
	s id=$p(parr,"||")
	s type=$p(parr,"||",2)
	;默认存储到职称表
	s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(id)
	if type="1"{//学历表
		s obj=##class(DHCNMG.HR.MgEducate).%OpenId(id)
	}
	s len=obj.CertPic.Count()
	s ret=""
	f i=1:1:len d
	.s itm=obj.CertPic.GetAt(i)
	.i i=1 s ret=itm
	.e  s ret=ret_"^"_itm
	
	q id_"||"_type_"||"_ret
}

/// Creator:lulin
/// Description:获取所有证书
/// Date:2017-11-21
/// Table:DHCNMG.HR.MgHireDuty、DHCNMG.HR.MgEducate
/// Input:记录表ID||记录表
/// Output：
/// Return:
/// Others: w ##class(web.NurMgPersonComm).FindAllCert("1")
ClassMethod FindAllCert(parr As %String) As %String
{
	q:parr="" ""
	s ret=""
	s par="" f  s par=$O(^DHCNMG.HR.MgHireDutyI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgHireDutyI("ssid",par,rw)) q:rw=""  d
	..s r=..FindCert(rw_"||"_0)
	..i ($l($p(r,"||",3))'=0) d
	...i ret="" s ret=r
	...e  s ret=ret_"@"_r
	s par="" f  s par=$O(^DHCNMG.HR.MgEducateI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgEducateI("ssid",par,rw)) q:rw=""  d
	..s r=..FindCert(rw_"||"_1)
	..i ($l($p(r,"||",3))'=0) d
	...i ret="" s ret=r
	...e  s ret=ret_"@"_r
	q ret
}

ClassMethod AuditSure(type As %String, reason As %String, id As %String, audituser As %String) As %String
{
	q:id="" "0"
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	q:'$IsObject(obj) "0"
	q:((obj.PerAuditFlag="B")&&(type="B")) "已驳回"
	q:((obj.PerAuditFlag="Y")&&(type="Y")) "已审核"
	s obj.PerAuditFlag=type
	s obj.AuditReason=$tr(reason," ","")
	s obj.PerAuditor=audituser
	s obj.PerAuditDate=+$H
	s obj.AuditTime=+$p($H,",",2)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lulin
/// Description:判断人员是否存在
/// Date:2017-12-12
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others:zw ##class(web.NurMgPersonComm).IsExistbycard(622201199309188132)
ClassMethod IsExistbycard(cardid) As %String
{
	s flag=-1
	s rowid=$O(^DHCNMG.HR.MgPersonsI("card"," "_$zcvt(cardid,"U"),""))
	i rowid'="" d
	.s flag=0
	q flag_"^"_rowid
}

/// Creator:lulin
/// Description:判断人员是否存在
/// Date:2017-12-12
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others:zw ##class(web.NurMgPersonComm).IsExistbyWardAndName("57^谢立平")
ClassMethod IsExistbyWardAndName(realname) As %String
{
	s flag=-1
	s wardid=$p(realname,"^")
	s name=$zcvt($p(realname,"^",2),"U")
	s perflag=0
	s rowid=""
	s perid="" f  s perid=$o(^DHCNMG.HR.MgPersonsI("DepID"," "_wardid,perid)) q:(perid="")||(perflag'=0)  d
	.s per=##class(DHCNMG.HR.MgPersons).%OpenId(perid)
	.i $zcvt(per.PerName,"U")=name d
	..s flag=0,rowid=perid
	..s perflag=-1
	q flag_"^"_rowid
}

/// Creator:lulin
/// Description:批量上传时保存头像
/// Date:2017-12-12
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod saveperpic(parr As %String = "") As %String
{
	q:parr="" ""
	s perid=$p(parr,"^")
	s pic=$p(parr,"^",2)
	q:perid="" ""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(perid)
	s obj.PerPic=pic
	d obj.%Save()
	q obj.%Id()
}

ClassMethod SysncPersonData() As %String
{
}

ClassMethod GetAuitStatus(id) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	s status=obj.PerAuditFlag
	q status
}

/// Creator:gzj
/// Description:优化查询人员列表
/// Date:2018-09-17
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindNurseList","1")
Query FindNurseList(parr As %String = "", column As %String = "", order As %String = "", advflag As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurseListExecute(ByRef qHandle As %Binary, parr As %String = "", column As %String = "", order As %String = "", advflag As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",rettmp=""
	s tmp=""
	i advflag="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	i advflag=0
	{
		s wardVal=$P(parr,"!",2)
		s nameVal=$P(parr,"!",3)
		;s noVal=$P(parr,"!",4)
		;s status=$P(parr,"!",4)
		s roleid=$P(parr,"!",4) //角色id 
		s nurseid=$p(parr,"!",5) // 人员id
	}
	i advflag=1
	{
		s wardVal=$p(parr,"!",1) //病区
		s hireVal=$p(parr,"!",2)  //职称
		s postVal=$p(parr,"!",3) //职务
		s levelVal=$p(parr,"!",4) //层级
		s sourceVal=$p(parr,"!",5) //护士来源
		s politVal=$p(parr,"!",6) //政治面貌
		s firEduVal=$p(parr,"!",7) //第一学历
		s maxEduVal=$p(parr,"!",8) //最高学历
		s roleid=$P(parr,"!",9) //角色id 
		s nurseid=$p(parr,"!",10) // 人员id
	}
	i roleid=0
	{
		s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
		.s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
		..s RowID="" f  s RowID=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_id,RowID)) q:RowID=""  d
		...s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
		...q:(obj.PerTypeDR'="N")
		...q:((advflag=0)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
		...q:((advflag=0)&&(nameVal'="")&&((obj.PerName_obj.PerID)'[nameVal))
		...q:((advflag=1)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
		...q:((advflag=1)&&(sourceVal'="")&&(sourceVal'[obj.PerSource))
		...q:((advflag=1)&&(politVal'="")&&(politVal'[obj.PerPolitical))
		...q:((advflag=1)&&(hireVal'="")&&(..CheckHireDuty(RowID,hireVal)=0))
		...q:((advflag=1)&&(postVal'="")&&(..CheckPost(RowID,postVal)=0))
		...q:((advflag=1)&&(levelVal'="")&&(..CheckLevel(RowID,levelVal)=0))
		...q:((advflag=1)&&(firEduVal'="")&&(..CheckEdu(RowID,firEduVal,"0")=0))
		...q:((advflag=1)&&(maxEduVal'="")&&(..CheckEdu(RowID,maxEduVal,"1")=0))
		...s NurseName=obj.PerName
		...s NurseID=obj.PerID
		...s NurseDep=$P($P($g(^CTLOC(obj.PerDepDR)),"^",2),"-",2)
		...s NurseDep=$list($g(^DHCNMG.DB.MgWardD(obj.PerDepDR)),3)
		...i obj.PerBirthday'="" s PerBirthday=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerBirthday)
		...e  s PerBirthday=""
		...s PerCardId=obj.PerCardId
		...s PerAge=""
		...i obj.PerBirthday'="" d
		....s age=##class(web.NurMgVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
		....s PerAge=$p(age,"Y",1)
		...i obj.PerComeDate'="" s PerComeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerComeDate)
		...e  s PerComeDate=""
		...s PerComeYear=""
		...i PerComeDate'="" d
		....s comeyear=##class(web.NurMgVueComm).CalAge(PerComeDate,$zd(+$H,3))
		....s PerComeYear=$p(comeyear,"Y",1)
		...i obj.PerDepDate'="" s PerDepDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerDepDate)
		...e  s PerDepDate=""
		...i obj.PerWorkDate'="" s PerWorkDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerWorkDate)
		...e  s PerWorkDate=""
		...s PerRegNo=obj.PerRegNo
		...i obj.PerStatus'="" s PerStatus=..GetCommCode(obj.PerStatus)
		...e  s PerStatus=""
		...i obj.PerMarriage'="" s PerMarriage=..GetCommCode(obj.PerMarriage)
		...e  s PerMarriage=""
		...i obj.PerSource'="" s PerSource=..GetCommCode(obj.PerSource)
		...e  s PerSource=""
		...i obj.PerPolitical'="" s PerPolitical=..GetCommCode(obj.PerPolitical)
		...e  s PerPolitical=""
		...i obj.PerNation'="" s PerNation=..GetCommCode(obj.PerNation)
		...e  s PerNation=""
		...i obj.PerClothesNo'="" s PerClothesNo=..GetCommCode(obj.PerClothesNo)
		...e  s PerClothesNo=""
		...i obj.PerTrouserNo'="" s PerTrouserNo=..GetCommCode(obj.PerTrouserNo)
		...e  s PerTrouserNo=""
		...i obj.PerShoesNo'="" s PerShoesNo=..GetCommCode(obj.PerShoesNo)
		...e  s PerShoesNo=""
		...i obj.PerWordType'="" s PerWordType=..GetCommCode(obj.PerWordType)
		...e  s PerWordType=""
		...s HISNO=obj.HISNO
		...s PerNativePlace=obj.PerNativePlace
		...s PerAddress=obj.PerAddress
		...i obj.PerCadreDate'="" s PerCadreDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerCadreDate)
		...e  s PerCadreDate=""
		...q:obj.PerStatus'="17||1"
		...s PerAuditFlag=""
		...i obj.PerAuditFlag="Y" s PerAuditFlag="已审核"
		...e  i obj.PerAuditFlag="B" s PerAuditFlag="已驳回" 
		...s rettmp="PerName|"_NurseName_"^PerID|"_NurseID_"^PerDepDR|"_NurseDep_"^PerBirthday|"_PerBirthday_"^PerCardId|"_PerCardId_"^PerDepDate|"_PerDepDate_"^PerComeDate|"_PerComeDate_"^PerWorkDate|"_PerWorkDate_"^PerRegNo|"_PerRegNo_"^rowid|"_RowID_"^PerStatus|"_PerStatus_"^PerMarriage|"_PerMarriage_"^PerSource|"_PerSource_"^PerPolitical|"_PerPolitical_"^PerNation|"_PerNation_"^PerClothesNo|"_PerClothesNo_"^PerTrouserNo|"_PerTrouserNo_"^PerShoesNo|"_PerShoesNo_"^PerWordType|"_PerWordType_"^PerAge|"_PerAge_"^PerComeYear|"_PerComeYear_"^HISNO|"_HISNO_"^PerNativePlace|"_PerNativePlace_"^PerAddress|"_PerAddress_"^PerCadreDate|"_PerCadreDate_"^PerAuditFlag|"_PerAuditFlag
		...s tmp(NurseDep,RowID)=rettmp
	}
	else
	{
		f j=1:1:$l(roleid,"^")
		{
			s roleitm=$p(roleid,"^",j)
			i roleitm="" continue
			s rolecode=##class(web.NurMgLoginComm).GetLoginRoleCode(roleitm)
			i ((rolecode="hlbzr")||(rolecode="hlb")||(rolecode="znurhead")||(rolecode="nurhead")||(rolecode="manager"))
			{
				s rolerw="" f  s rolerw=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_roleitm," "_nurseid,rolerw)) q:rolerw=""  d
				.s roledeprw="" f  s roledeprw=$O(^DHCNMG.DB.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
				..s roledepobj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rolerw_"||"_roledeprw)
				..s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
				...s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
				....q:(id'=roledepobj.SubWard)
				....s RowID="" f  s RowID=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_id,RowID)) q:RowID=""  d
				.....s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
				.....q:(obj.PerTypeDR'="N")
				.....q:((rolecode="nurse")&&(nurseid'="")&&(RowID'=nurseid))
				.....q:((advflag=0)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
				.....q:((advflag=0)&&(nameVal'="")&&((obj.PerName_obj.PerID)'[nameVal))
				.....q:((advflag=1)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
				.....q:((advflag=1)&&(sourceVal'="")&&(obj.PerSource'=sourceVal))
				.....q:((advflag=1)&&(politVal'="")&&(obj.PerPolitical'=politVal))
				.....q:((advflag=1)&&(hireVal'="")&&(..CheckHireDuty(RowID,hireVal)=0))
				.....q:((advflag=1)&&(postVal'="")&&(..CheckPost(RowID,postVal)=0))
				.....q:((advflag=1)&&(levelVal'="")&&(..CheckLevel(RowID,levelVal)=0))
				.....q:((advflag=1)&&(firEduVal'="")&&(..CheckEdu(RowID,firEduVal,"0")=0))
				.....q:((advflag=1)&&(maxEduVal'="")&&(..CheckEdu(RowID,maxEduVal,"1")=0))
				.....s NurseName=obj.PerName
				.....s NurseID=obj.PerID
				.....s NurseDep=$P($P($g(^CTLOC(obj.PerDepDR)),"^",2),"-",2)
				.....s NurseDep=$list($g(^DHCNMG.DB.MgWardD(obj.PerDepDR)),4)
				.....i obj.PerBirthday'="" s PerBirthday=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerBirthday)
				.....e  s PerBirthday=""
				.....s PerCardId=obj.PerCardId
				.....s PerAge=""
				.....i obj.PerBirthday'="" d
				......s age=##class(web.NurMgVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
				......s PerAge=$p(age,"Y",1)
				.....i obj.PerDepDate'="" s PerDepDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerDepDate)
				.....e  s PerDepDate=""
				.....i obj.PerComeDate'="" s PerComeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerComeDate)
				.....e  s PerComeDate=""
				.....s PerComeYear=""
				.....i PerComeDate'="" d
				......s comeyear=##class(web.NurMgVueComm).CalAge(PerComeDate,$zd(+$H,3))
				......s PerComeYear=$p(comeyear,"Y",1)
				.....i obj.PerWorkDate'="" s PerWorkDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerWorkDate)
				.....e  s PerWorkDate=""
				.....s PerRegNo=obj.PerRegNo
				.....i obj.PerStatus'="" s PerStatus=..GetCommCode(obj.PerStatus)
				.....e  s PerStatus=""
				.....i obj.PerMarriage'="" s PerMarriage=..GetCommCode(obj.PerMarriage)
				.....e  s PerMarriage=""
				.....i obj.PerSource'="" s PerSource=..GetCommCode(obj.PerSource)
				.....e  s PerSource=""
				.....i obj.PerPolitical'="" s PerPolitical=..GetCommCode(obj.PerPolitical)
				.....e  s PerPolitical=""
				.....i obj.PerNation'="" s PerNation=..GetCommCode(obj.PerNation)
				.....e  s PerNation=""
				.....i obj.PerClothesNo'="" s PerClothesNo=..GetCommCode(obj.PerClothesNo)
				.....e  s PerClothesNo=""
				.....i obj.PerTrouserNo'="" s PerTrouserNo=..GetCommCode(obj.PerTrouserNo)
				.....e  s PerTrouserNo=""
				.....i obj.PerShoesNo'="" s PerShoesNo=..GetCommCode(obj.PerShoesNo)
				.....e  s PerShoesNo=""
				.....i obj.PerWordType'="" s PerWordType=..GetCommCode(obj.PerWordType)
				.....e  s PerWordType=""
				.....s HISNO=obj.HISNO
				.....s PerNativePlace=obj.PerNativePlace
				.....s PerAddress=obj.PerAddress
				.....i obj.PerCadreDate'="" s PerCadreDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerCadreDate)
				.....e  s PerCadreDate=""
				.....q:obj.PerStatus'="17||1"
				.....s PerAuditFlag=""
				.....i obj.PerAuditFlag="Y" s PerAuditFlag="已审核"
				.....e  i obj.PerAuditFlag="B" s PerAuditFlag="已驳回"
				.....s rettmp="PerName|"_NurseName_"^PerID|"_NurseID_"^PerDepDR|"_NurseDep_"^PerBirthday|"_PerBirthday_"^PerCardId|"_PerCardId_"^PerDepDate|"_PerDepDate_"^PerComeDate|"_PerComeDate_"^PerWorkDate|"_PerWorkDate_"^PerRegNo|"_PerRegNo_"^rowid|"_RowID_"^PerStatus|"_PerStatus_"^PerMarriage|"_PerMarriage_"^PerSource|"_PerSource_"^PerPolitical|"_PerPolitical_"^PerNation|"_PerNation_"^PerClothesNo|"_PerClothesNo_"^PerTrouserNo|"_PerTrouserNo_"^PerShoesNo|"_PerShoesNo_"^PerWordType|"_PerWordType_"^PerAge|"_PerAge_"^PerComeYear|"_PerComeYear_"^HISNO|"_HISNO_"^PerNativePlace|"_PerNativePlace_"^PerAddress|"_PerAddress_"^PerCadreDate|"_PerCadreDate_"^PerAuditFlag|"_PerAuditFlag
				.....s tmp(NurseDep,RowID)=rettmp
			}
			else
			{
				s obj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
				q:(obj.PerTypeDR'="N")
				;q:((rolecode="nurse")&&(nurseid'="")&&(RowID'=nurseid))
				q:((advflag=0)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
				q:((advflag=0)&&(nameVal'="")&&(obj.PerName'[nameVal))
				q:((advflag=1)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
				q:((advflag=1)&&(sourceVal'="")&&(obj.PerSource'=sourceVal))
				q:((advflag=1)&&(politVal'="")&&(obj.PerPolitical'=politVal))
				q:((advflag=1)&&(hireVal'="")&&(..CheckHireDuty(RowID,hireVal)=0))
				q:((advflag=1)&&(postVal'="")&&(..CheckPost(RowID,postVal)=0))
				q:((advflag=1)&&(levelVal'="")&&(..CheckLevel(RowID,levelVal)=0))
				q:((advflag=1)&&(firEduVal'="")&&(..CheckEdu(RowID,firEduVal,"0")=0))
				q:((advflag=1)&&(maxEduVal'="")&&(..CheckEdu(RowID,maxEduVal,"1")=0))
				s NurseName=obj.PerName
				s NurseID=obj.PerID
				s NurseDep=$P($P($g(^CTLOC(obj.PerDepDR)),"^",2),"-",2)
				s NurseDep=$list($g(^DHCNMG.DB.MgWardD(obj.PerDepDR)),4)
				i obj.PerBirthday'="" s PerBirthday=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerBirthday)
				e  s PerBirthday=""
				s PerCardId=obj.PerCardId
				s PerAge=""
				i obj.PerBirthday'="" d
				.s age=##class(web.NurMgVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
				.s PerAge=$p(age,"Y",1)
				i obj.PerDepDate'="" s PerDepDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerDepDate)
				e  s PerDepDate=""
				i obj.PerComeDate'="" s PerComeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerComeDate)
				e  s PerComeDate=""
				s PerComeYear=""
				i PerComeDate'="" d
				.s comeyear=##class(web.NurMgVueComm).CalAge(PerComeDate,$zd(+$H,3))
				.s PerComeYear=$p(comeyear,"Y",1)
				i obj.PerWorkDate'="" s PerWorkDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerWorkDate)
				e  s PerWorkDate=""
				s PerRegNo=obj.PerRegNo
				i obj.PerStatus'="" s PerStatus=..GetCommCode(obj.PerStatus)
				e  s PerStatus=""
				i obj.PerMarriage'="" s PerMarriage=..GetCommCode(obj.PerMarriage)
				e  s PerMarriage=""
				i obj.PerSource'="" s PerSource=..GetCommCode(obj.PerSource)
				e  s PerSource=""
				i obj.PerPolitical'="" s PerPolitical=..GetCommCode(obj.PerPolitical)
				e  s PerPolitical=""
				i obj.PerNation'="" s PerNation=..GetCommCode(obj.PerNation)
				e  s PerNation=""
				i obj.PerClothesNo'="" s PerClothesNo=..GetCommCode(obj.PerClothesNo)
				e  s PerClothesNo=""
				i obj.PerTrouserNo'="" s PerTrouserNo=..GetCommCode(obj.PerTrouserNo)
				e  s PerTrouserNo=""
				i obj.PerShoesNo'="" s PerShoesNo=..GetCommCode(obj.PerShoesNo)
				e  s PerShoesNo=""
				i obj.PerWordType'="" s PerWordType=..GetCommCode(obj.PerWordType)
				e  s PerWordType=""
				s HISNO=obj.HISNO
				s PerNativePlace=obj.PerNativePlace
				s PerAddress=obj.PerAddress
				i obj.PerCadreDate'="" s PerCadreDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerCadreDate)
				e  s PerCadreDate=""
				q:obj.PerStatus'="17||1"
				s PerAuditFlag=""
				i obj.PerAuditFlag="Y" s PerAuditFlag="已审核"
				e  i obj.PerAuditFlag="B" s PerAuditFlag="已驳回"
				s rettmp="PerName|"_NurseName_"^PerID|"_NurseID_"^PerDepDR|"_NurseDep_"^PerBirthday|"_PerBirthday_"^PerCardId|"_PerCardId_"^PerDepDate|"_PerDepDate_"^PerComeDate|"_PerComeDate_"^PerWorkDate|"_PerWorkDate_"^PerRegNo|"_PerRegNo_"^rowid|"_nurseid_"^PerStatus|"_PerStatus_"^PerMarriage|"_PerMarriage_"^PerSource|"_PerSource_"^PerPolitical|"_PerPolitical_"^PerNation|"_PerNation_"^PerClothesNo|"_PerClothesNo_"^PerTrouserNo|"_PerTrouserNo_"^PerShoesNo|"_PerShoesNo_"^PerWordType|"_PerWordType_"^PerAge|"_PerAge_"^PerComeYear|"_PerComeYear_"^HISNO|"_HISNO_"^PerNativePlace|"_PerNativePlace_"^PerAddress|"_PerAddress_"^PerCadreDate|"_PerCadreDate_"^PerAuditFlag|"_PerAuditFlag
				s tmp(NurseDep,nurseid)=rettmp
			}
		}
	}
	
	;i column'="" d
	;.s ret=""
	;.i order="ascending" d
	;..s desc="" f  s desc=$O(tmp(desc)) q:desc=""  d
	;...s rw="" f  s rw=$O(tmp(desc,rw)) q:rw=""  d
	;....s ret=tmp(desc,rw)
	;....do OutputPerData
	;.e  i order="descending" d
	;..s desc="" f  s desc=$O(tmp(desc),-1) q:desc=""  d
	;...s rw="" f  s rw=$O(tmp(desc,rw),-1) q:rw=""  d
	;....s ret=tmp(desc,rw)
	;....do OutputPerData
	;e  d OutputPerData
	s tmpward="" f  s tmpward=$O(tmp(tmpward)) q:tmpward=""  d
	.s tmpid="" f  s tmpid=$O(tmp(tmpward,tmpid)) q:tmpid=""  d
	..s ret=tmp(tmpward,tmpid)
	..d OutputPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod UndoRecData(id As %String, operator As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	q:'$IsObject(obj) 0
	q:((obj.PerAuditFlag="N")!(obj.PerAuditFlag="")) -1
	s obj.PerAuditFlag="N"
	s obj.PerAuditor=operator
	s obj.PerAuditDate=+$h
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lulin
/// Description:删除未提交轮转申请表
/// Date:2018-09-17
/// Table:DHCNMG.HR.MgTransApp
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod DeletePerTran(parr As %String) As %String
{
	q:parr="" 0
	f i=1:1:$L(parr,"^") d
	.s id=$P(parr,"^",i)
	.s obj=##class(DHCNMG.HR.MgTransApp).%OpenId(id)
	.q:'$IsObject(obj)
	.q:((obj.TransStatus'="N")&&(obj.TransStatus'="B"))
	.d obj.%DeleteId(id)
	q 1
}

/// Creator:liuning
/// Description:保存科室护士考核情况
/// Date:2019-09-05
/// Table: DHCNMG.HR.NurAssessment
/// Input:
/// Output：
/// Return:
/// Others: zw ##class(web.NurMgPersonComm).SaveNurAssess("ElecteWard|13^ElecteNurse|88^ElecteDate|2019-09-01^ElecteTheory|11^ElecteTechnical|22^ElecteUser|0^RowID|^ElecteStatus|N")
ClassMethod SaveNurAssess(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s tmp("ElecteYear")=$p($zdate(+$h,3),"-",1)
	i id="" s obj=##class(DHCNMG.HR.NurAssessment).%New()
	e  s obj=##class(DHCNMG.HR.NurAssessment).%OpenId(id)
	s electdate=$zdh(tmp("ElecteDate"),3)
	s isExist=$d(^DHCNMG.HR.NurAssessmentI("dep",electdate," "_tmp("ElecteNurse")," "_tmp("ElecteWard")))
	q:(isExist)&&($g(tmp("RowID"))="") "该护士该月份成绩已存在！"
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.NurAssessment","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s ptype=^oddCOM("DHCNMG.HR.NurAssessment","a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(tmp(p)'="")) d
	...s tmp(p)=$zdh(tmp(p),3)
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q 1
}

/// Creator:liuning
/// Description:查询科室护士考核情况
/// Date:2019-09-05
/// Table: DHCNMG.HR.NurAssessment
/// Input:
/// Output：
/// Return:
/// Others:w ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindNurAssessList","2019-09-01^2019-09-30^^","0","0")
Query FindNurAssessList(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurAssessListExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s stmonth=$p(parr,"^",1)
	i stmonth'="" s stdate=$zdh(stmonth,3)
	e  s stdate=""
	s endmonth=$p(parr,"^",2)
	i endmonth'="" s enddate=$zdh(endmonth,3)
	e  s enddate=""
	s ward=$p(parr,"^",3)
	s statu=$p(parr,"^",4)
	k tmpWard
	s tmpWard="",isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s date="" f  s date=$O(^DHCNMG.HR.NurAssessmentI("type",date)) q:date=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.HR.NurAssessmentI("type",date,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.HR.NurAssessment).%OpenId(rowid)
	..q:((stdate'="")&&(obj.ElecteDate<stdate))
	..q:((enddate'="")&&(obj.ElecteDate>enddate))
	..q:(isAll=0)&&((obj.ElecteWard="")||('$d(tmpWard(obj.ElecteWard))))
	..q:((ward'="")&&(obj.ElecteWard'=ward))
	..q:((statu'="")&&(obj.ElecteStatus'=statu))
	..i obj.ElecteNurse'="" s ElecteNurse=..GetNurseInfo(obj.ElecteNurse)
	..e  s ElecteNurse=""
	..i obj.ElecteDate'="" s ElecteDate=$E($zd(obj.ElecteDate,8),1,4)_"-"_$E($zd(obj.ElecteDate,8),5,6)
	..e  s ElecteDate=""
	..i obj.ElecteWard'="" d
	...s rec=##class(web.NurMgDBComm).GetWard(obj.ElecteWard)
	...s ElecteWard=$p($p(rec,"^",3),"|",2)
	..e  s ElecteWard=""
	..i obj.ElecteUser=0 s ElecteUser="管理员"
	..e  i (obj.ElecteUser'="")&&(obj.ElecteUser'=0) s ElecteUser=..GetNurseInfo(obj.ElecteUser)
	..e  s ElecteUser=""
	..s RecDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.RecDate)
	..i obj.ElecteStatus="N" s ElecteStatus="未提交"
	..e  i obj.ElecteStatus="Y" s ElecteStatus="已提交"
	..s ret="electeNurse|"_ElecteNurse_"^electeDate|"_ElecteDate_"^electeWard|"_ElecteWard_"^electeUser|"_ElecteUser_"^recDate|"_RecDate_"^electeStatus|"_ElecteStatus_"^rowid|"_rowid_"^electeTheory|"_obj.ElecteTheory_"^electeTechnical|"_obj.ElecteTechnical
	..do OutputElecterData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputElecterData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurAssessListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurAssessListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurAssessListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurAssessListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:liuning
/// Description:获取考核数据
/// Date:2019-09-05
/// Table: DHCNMG.HR.NurAssessment
/// Input:
/// Output：
/// Return:
ClassMethod GetNurAssessItem(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.NurAssessment).%OpenId(id)
	s ElecteNurse=obj.ElecteNurse
	i obj.ElecteDate'="" s ElecteDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ElecteDate)
	.e  s ElecteDate=""
	s ElecteWard=obj.ElecteWard
	s ret="ElecteNurse|"_ElecteNurse_"^ElecteDate|"_ElecteDate_"^ElecteWard|"_ElecteWard_"^RowID|"_id_"^ElecteTheory|"_obj.ElecteTheory_"^ElecteTechnical|"_obj.ElecteTechnical
	q ret
}

/// Creator:liuning
/// Description:获取考核状态
/// Date:2019-09-05
/// Table: DHCNMG.HR.NurAssessment
/// Input:
/// Output：
/// Return:
ClassMethod NurAssess(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCNMG.HR.NurAssessment).%OpenId(id)
	q:'$IsObject(obj)
	s ret=obj.ElecteStatus
	q ret
}

/// Creator:liuning
/// Description:查询科室护士考核情况汇总
/// Date:2019-09-23
/// Table: DHCNMG.HR.NurAssessment
/// Input:
/// Output：
/// Return:
/// Others:w ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAssessSumList","2019-01-01^","0","0")
Query FindAssessSumList(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAssessSumListExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s findyear=$p(parr,"^",1)
	s ward=$p(parr,"^",2)
	k tmpWard
	s tmpWard="",isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s nur="" f  s nur=$O(^DHCNMG.HR.NurAssessmentI("sum",nur)) q:nur=""  d
	.s year="" f  s year=$O(^DHCNMG.HR.NurAssessmentI("sum",nur,year)) q:year=""  d
	..s checkyear=" "_$p(findyear,"-",1)
	..q:((findyear'="")&&(year'=checkyear))
	..s nurid=$p(nur," ",2)
	..s checkward=##class(DHCNMG.HR.MgPersons).%OpenId(nurid).PerDepDR
	..q:((ward'="")&&(ward'=checkward))
	..s ElecteTheory="",ElecteTechnical=""
	..s ElecteTheory2="",ElecteTechnical2=""
	..s ElecteTheory3="",ElecteTechnical3=""
	..s ElecteTheory4="",ElecteTechnical4=""
	..s ElecteTheory5="",ElecteTechnical5=""
	..s ElecteTheory6="",ElecteTechnical6=""
	..s ElecteTheory7="",ElecteTechnical7=""
	..s ElecteTheory8="",ElecteTechnical8=""
	..s ElecteTheory9="",ElecteTechnical9=""
	..s ElecteTheory10="",ElecteTechnical10=""
	..s ElecteTheory11="",ElecteTechnical11=""
	..s ElecteTheory12="",ElecteTechnical12=""
	..s rowid="" f  s rowid=$O(^DHCNMG.HR.NurAssessmentI("sum",nur,year,rowid)) q:rowid=""  d
	...s obj=##class(DHCNMG.HR.NurAssessment).%OpenId(rowid)	
	...s month=$p($zdate(obj.ElecteDate,3),"-","2")
	...i month="01" d
	....s ElecteTheory=obj.ElecteTheory
	....s ElecteTechnical=obj.ElecteTechnical
	...i month="02" d
	....s ElecteTheory2=obj.ElecteTheory
	....s ElecteTechnical2=obj.ElecteTechnical
	...i month="03" d
	....s ElecteTheory3=obj.ElecteTheory
	....s ElecteTechnical3=obj.ElecteTechnical
	...i month="04" d
	....s ElecteTheory4=obj.ElecteTheory
	....s ElecteTechnical4=obj.ElecteTechnical
	...i month="05" d
	....s ElecteTheory5=obj.ElecteTheory
	....s ElecteTechnical5=obj.ElecteTechnical
	...i month="06" d
	....s ElecteTheory6=obj.ElecteTheory
	....s ElecteTechnical6=obj.ElecteTechnical
	...i month="07" d
	....s ElecteTheory7=obj.ElecteTheory
	....s ElecteTechnical7=obj.ElecteTechnical
	...i month="08" d
	....s ElecteTheory8=obj.ElecteTheory
	....s ElecteTechnical8=obj.ElecteTechnical
	...i month="09" d
	....s ElecteTheory9=obj.ElecteTheory
	....s ElecteTechnical9=obj.ElecteTechnical
	...i month="10" d
	....s ElecteTheory10=obj.ElecteTheory
	....s ElecteTechnical10=obj.ElecteTechnical
	...i month="11" d
	....s ElecteTheory11=obj.ElecteTheory
	....s ElecteTechnical11=obj.ElecteTechnical
	...i month="12" d
	....s ElecteTheory12=obj.ElecteTheory
	....s ElecteTechnical12=obj.ElecteTechnical
	...i obj.ElecteNurse'="" s ElecteNurse=..GetNurseInfo(obj.ElecteNurse)
	...e  s ElecteNurse=""
	...i obj.ElecteWard'="" d
	....s rec=##class(web.NurMgDBComm).GetWard(obj.ElecteWard)
	....s ElecteWard=$p($p(rec,"^",3),"|",2)
	...e  s ElecteWard=""
	...s ElecteYear=obj.ElecteYear
	..s ret="ElecteNurse|"_ElecteNurse_"^ElecteWard|"_ElecteWard_"^ElecteTheory|"_ElecteTheory_"^ElecteTechnical|"_ElecteTechnical
	..s ret=ret_"^ElecteTheory2|"_ElecteTheory2_"^ElecteTechnical2|"_ElecteTechnical2_"^ElecteTheory3|"_ElecteTheory3_"^ElecteTechnical3|"_ElecteTechnical3
	..s ret=ret_"^ElecteTheory4|"_ElecteTheory4_"^ElecteTechnical4|"_ElecteTechnical4_"^ElecteTheory5|"_ElecteTheory5_"^ElecteTechnical5|"_ElecteTechnical5
	..s ret=ret_"^ElecteTheory6|"_ElecteTheory6_"^ElecteTechnical6|"_ElecteTechnical6_"^ElecteTheory7|"_ElecteTheory7_"^ElecteTechnical7|"_ElecteTechnical7
	..s ret=ret_"^ElecteTheory8|"_ElecteTheory8_"^ElecteTechnical8|"_ElecteTechnical8_"^ElecteTheory9|"_ElecteTheory9_"^ElecteTechnical9|"_ElecteTechnical9
	..s ret=ret_"^ElecteTheory10|"_ElecteTheory10_"^ElecteTechnical10|"_ElecteTechnical10_"^ElecteTheory11|"_ElecteTheory11_"^ElecteTechnical11|"_ElecteTechnical11
	..s ret=ret_"^ElecteTheory12|"_ElecteTheory12_"^ElecteTechnical12|"_ElecteTechnical12_"^ElecteYear|"_ElecteYear	
	..do OutputElecterData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputElecterData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAssessSumListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAssessSumListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAssessSumListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAssessSumListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Dhh
/// Description:获取职称
/// Date:2019-11-12
/// Table:DHCNMG.HR.MgHireDuty
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAllHireList","")
Query FindAllHireList(parr As %String, input As %Binary) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllHireListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=$p(parr,"^",1)
	s hire=$p(parr,"^",2)
	s par="" f  s par=$O(^DHCNMG.HR.MgHireDutyI("ssid",par)) q:par=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgHireDutyI("ssid",par,rw)) q:rw=""  d
	..s personObj=##class(DHCNMG.HR.MgPersons).%OpenId(par)
	..q:'$IsObject(personObj)
	..q:personObj.PerStatus'="17||1"
	..s perName=personObj.PerName
	..s perWard=##class(DHCNMG.DB.MgWard).%OpenId(personObj.PerDepDR).WardDesc
	..q:(ward'="")&&(ward'=personObj.PerDepDR)
	..s perinfo=personObj.PerID_","_perName
	..s perId=personObj.PerID
	..q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	..s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(rw)
	..q:(hire'="")&&(hire'=obj.HireDuty)
	..i obj.HireStDate'="" s HireStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.HireStDate)
	..e  s HireStDate=""
	..i obj.HireEndDate'="" s HireEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.HireEndDate)
	..e  s HireEndDate=""
	..i obj.HireDuty'="" s HireDuty=..GetCommCode(obj.HireDuty)
	..e  s HireDuty=""
	..s HireRemark=obj.HireRemark
	..s HireRemark=""
	..i obj.HireStatus="N" s status="保存"
	..e  i obj.HireStatus="Y" s status="提交"
	..e  i obj.HireStatus="A" s status="审核"
	..e  i obj.HireStatus="B" s status="驳回"
	..s ret="HireStDate|"_HireStDate_"^HireEndDate|"_HireEndDate_"^HireDuty|"_HireDuty_"^HireRemark|"_HireRemark_"^hireRowID|"_rw_"^status|"_status_"^NurName|"_perName_"^NurWard|"_perWard_"^NurId|"_perId   
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllHireListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllHireListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllHireListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllHireListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Dhh
/// Description:查询工作经历
/// Date:2019-11-12
/// Table:DHCNMG.HR.MgWork
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAllWorkList","")
Query FindAllWorkList(parr As %String, input As %Binary) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllWorkListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s ret=""
	s ward=$p(parr,"^",1)
	s par="" f  s par=$O(^DHCNMG.HR.MgWorkI("ssid",par)) q:par=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgWorkI("ssid",par,rw)) q:rw=""  d
	..s personObj=##class(DHCNMG.HR.MgPersons).%OpenId(par)
	..q:'$IsObject(personObj)
	..q:personObj.PerStatus'="17||1"
	..s perName=personObj.PerName
	..s perWard=##class(DHCNMG.DB.MgWard).%OpenId(personObj.PerDepDR).WardDesc
	..q:(ward'="")&&(ward'=personObj.PerDepDR)
	..s perinfo=personObj.PerID_","_perName
	..s perId=personObj.PerID
	..q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	..s obj=##class(DHCNMG.HR.MgWork).%OpenId(rw)
	..i obj.WorkStDate'="" s WorkStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.WorkStDate)
	..e  s WorkStDate=""
	..i obj.WorkEndDate'="" s WorkEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.WorkEndDate)
	..e  s WorkEndDate=""
	..s WorkUnit=obj.WorkUnit
	..i obj.WorkPost'="" s WorkPost=..GetCommCode(obj.WorkPost)
	..e  s WorkPost=""
	..i obj.WorkDuty'="" s WorkDuty=..GetCommCode(obj.WorkDuty)
	..e  s WorkDuty=""
	..s WorkRemark=obj.WorkRemark
	..s worktype=""
	..i obj.WorkStatus="N" s workStatus="保存"
	..e  i obj.WorkStatus="Y" s workStatus="提交"
	..e  i obj.WorkStatus="A" s workStatus="审核"
	..e  i obj.WorkStatus="B" s workStatus="驳回"
	..s statusCode=obj.WorkStatus
	..s ret="WorkStDate|"_WorkStDate_"^WorkEndDate|"_WorkEndDate_"^WorkUnit|"_WorkUnit_"^WorkPost|"_WorkPost_"^WorkDuty|"_WorkDuty_"^WorkRemark|"_WorkRemark_"^WorkRowID|"_rw_"^status|"_workStatus_"^statusCode|"_statusCode_"^NurName|"_perName_"^NurWard|"_perWard_"^NurId|"_perId
	..do OutputEduData
	s ret=""
	s transrw="" f  s transrw=$O(^DHCNMG.HR.MgTransDepI("ssdr"," "_parr,transrw)) q:transrw=""  d
	.s transobj=##class(DHCNMG.HR.MgTransDep).%OpenId(transrw)
	.q:transobj.PerTranCurrent="P"
	.s WorkStDate=""
	.i transobj.PerTranStDate'="" s WorkStDate=##class(web.NurMgHISComm).DateLogicalToHtml(transobj.PerTranStDate)
	.e  s WorkStDate=""
	.s WorkEndDate=""
	.i transobj.PerTranEndDate'="" s WorkEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(transobj.PerTranEndDate)
	.e  s WorkEndDate=""
	.s WorkUnit=""
	.i transobj.PerDepart'="" d
	..s unitObj=##class(DHCNMG.DB.MgWard).%OpenId(transobj.PerDepart)
	..s WorkUnit=unitObj.WardDesc
	.;s workPost=""
	.;s postrowid="" f  s postrowid=$O(^DHCNMG.HR.MgPostDutyI("ssid",par,postrowid)) q:postrowid=""  d
	.s worktype="T"
	.s statusCode="A"
	.s ret="WorkStDate|"_WorkStDate_"^WorkEndDate|"_WorkEndDate_"^WorkUnit|"_WorkUnit_"^WorkPost|"_""_"^WorkDuty|"_""_"^WorkRemark|"_""_"^workRowID|"_transrw_"^worktype|"_worktype_"^status|"_statusCode_"^NurName|"_perName_"^NurWard|"_perWard_"^NurId|"_perId
	.do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllWorkListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllWorkListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllWorkListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllWorkListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:liuning
/// Description:获取层级
/// Date:2019-05-15
/// Table:DHCNMG.HR.MgLevel
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAllLevelList","")
Query FindAllLevelList(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllLevelListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=$p(parr,"^",1)
	s level=$p(parr,"^",2)
	s par="" f  s par=$O(^DHCNMG.HR.MgLevelI("ssid",par)) q:par=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgLevelI("ssid",par,rw)) q:rw=""  d
	..s personObj=##class(DHCNMG.HR.MgPersons).%OpenId(par)
	..q:'$IsObject(personObj)
	..q:personObj.PerStatus'="17||1"
	..s perName=personObj.PerName
	..s perWard=##class(DHCNMG.DB.MgWard).%OpenId(personObj.PerDepDR).WardDesc
	..q:(ward'="")&&(ward'=personObj.PerDepDR)
	..s perinfo=personObj.PerID_","_perName
	..s perId=personObj.PerID
	..q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	..s obj=##class(DHCNMG.HR.MgLevel).%OpenId(rw)
	..q:(level'="")&&(level'=obj.NurLevel)
	..i obj.LevelDate'="" s LevelDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.LevelDate)
	..e  s LevelDate=""
	..i obj.NurLevel'="" s NurLevel=..GetCommCode(obj.NurLevel)
	..e  s NurLevel=""
	..s LevelRemark=obj.LevelRemark
	..s status=""
	..i obj.LevelStatus="N" s status="保存"
	..e  i obj.LevelStatus="Y" s status="提交"
	..e  i obj.LevelStatus="A" s status="审核"
	..e  i obj.LevelStatus="B" s status="驳回"
	..s levelFactor=obj.LevelFactor
	..s ret="levelDate|"_LevelDate_"^nurLevel|"_NurLevel_"^levelRemark|"_LevelRemark_"^levelRowID|"_rw_"^status|"_status_"^levelFactor|"_levelFactor_"^perName|"_perName_"^perWard|"_perWard_"^perId|"_perId   
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllLevelListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllLevelListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllLevelListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllLevelListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Dhh
/// Description:获取科研基金
/// Date:2019-11-13
/// Table:DHCNMG.HR.MgResearch
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAllReseaList","")
Query FindAllReseaList(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllReseaListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=$p(parr,"^",1)
	s par="" f  s par=$O(^DHCNMG.HR.MgResearchI("ssid",par)) q:par=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgResearchI("ssid",par,rw)) q:rw=""  d
	..s personObj=##class(DHCNMG.HR.MgPersons).%OpenId(par)
	..q:'$IsObject(personObj)
	..q:personObj.PerStatus'="17||1"
	..s perName=personObj.PerName
	..s perWard=##class(DHCNMG.DB.MgWard).%OpenId(personObj.PerDepDR).WardDesc
	..q:(ward'="")&&(ward'=personObj.PerDepDR)
	..s perinfo=personObj.PerID_","_perName
	..s perId=personObj.PerID
	..q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	..s obj=##class(DHCNMG.HR.MgResearch).%OpenId(rw)
	..i obj.ReseaDate'="" s ReseaDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ReseaDate)
	..e  s ReseaDate=""
	..i obj.ReseaEndDate'="" s ReseaEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ReseaEndDate)
	..e  s ReseaEndDate=""
	..i obj.ReseaLevel'="" s ReseaLevel=..GetCommCode(obj.ReseaLevel)
	..e  s ReseaLevel=""
	..s ReseaFee=obj.ReseaFee
	..s ReseaTitle=obj.ReseaTitle
	..s status=""
	..i obj.ReseaStatus="N" s status="保存"
	..e  i obj.ReseaStatus="Y" s status="提交"
	..e  i obj.ReseaStatus="A" s status="审核"
	..e  i obj.ReseaStatus="B" s status="驳回"
	..s ret="ReseaDate|"_ReseaDate_"^ReseaEndDate|"_ReseaEndDate_"^ReseaTitle|"_ReseaTitle_"^ReseaLevel|"_ReseaLevel_"^ReseaFee|"_ReseaFee_"^ReseaRowID|"_rw_"^status|"_status_"^NurName|"_perName_"^NurWard|"_perWard_"^NurId|"_perId   
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllReseaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllReseaListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllReseaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllReseaListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Dhh
/// Description:获取获奖科研
/// Date:2019-11-13
/// Table:DHCNMG.HR.MgAward
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAllAwardList","")
Query FindAllAwardList(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllAwardListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=$p(parr,"^",1)
	s par="" f  s par=$O(^DHCNMG.HR.MgAwardI("ssid",par)) q:par=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgAwardI("ssid",par,rw)) q:rw=""  d
	..s personObj=##class(DHCNMG.HR.MgPersons).%OpenId(par)
	..q:'$IsObject(personObj)
	..q:personObj.PerStatus'="17||1"
	..s perName=personObj.PerName
	..s perWard=##class(DHCNMG.DB.MgWard).%OpenId(personObj.PerDepDR).WardDesc
	..q:(ward'="")&&(ward'=personObj.PerDepDR)
	..s perinfo=personObj.PerID_","_perName
	..s perId=personObj.PerID
	..q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	..s obj=##class(DHCNMG.HR.MgAward).%OpenId(rw)
	..s AwardResult=obj.AwardResult
	..s AwardTitle=obj.AwardTitle
	..s AwardScore=obj.AwardScore
	..i obj.AwardDate'="" s AwardDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.AwardDate)
	..e  s AwardDate=""
	..i obj.AwardRank'="" s AwardRank=..GetCommCode(obj.AwardRank)
	..e  s AwardRank=""
	..s AwardPatent=obj.AwardPatent
	..i obj.AwardPatType'="" s AwardPatType=..GetCommCode(obj.AwardPatType)
	..e  s AwardPatType=""
	..s AwardThesis=obj.AwardThesis
	..i obj.AwardPublic'="" s AwardPublic=..GetCommCode(obj.AwardPublic)
	..e  s AwardPublic=""
	..s AwardPage=obj.AwardPage
	..s status=""
	..i obj.AwardStatus="N" s status="保存"
	..e  i obj.AwardStatus="Y" s status="提交"
	..e  i obj.AwardStatus="A" s status="审核"
	..e  i obj.AwardStatus="B" s status="驳回"
	..s ret="AwardDate|"_AwardDate_"^AwardRank|"_AwardRank_"^AwardResult|"_AwardResult_"^AwardTitle|"_AwardTitle_"^AwardScore|"_AwardScore_"^AwardPatent|"_AwardPatent_"^AwardPatType|"_AwardPatType_"^AwardThesis|"_AwardThesis_"^AwardPublic|"_AwardPublic_"^AwardPage|"_AwardPage_"^AwardRowID|"_rw_"^status|"_status_"^NurName|"_perName_"^NurWard|"_perWard_"^NurId|"_perId   
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllAwardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllAwardListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllAwardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllAwardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Dhh
/// Description:获取对口支援
/// Date:2019-11-16
/// Table:DHCNMG.HR.MgSupport
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAllSupportList","")
Query FindAllSupportList(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllSupportListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=$p(parr,"^",1)
	s par="" f  s par=$O(^DHCNMG.HR.MgSupportI("ssid",par)) q:par=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgSupportI("ssid",par,rw)) q:rw=""  d
	..s personObj=##class(DHCNMG.HR.MgPersons).%OpenId(par)
	..q:'$IsObject(personObj)
	..q:personObj.PerStatus'="17||1"
	..s perName=personObj.PerName
	..s perWard=##class(DHCNMG.DB.MgWard).%OpenId(personObj.PerDepDR).WardDesc
	..q:(ward'="")&&(ward'=personObj.PerDepDR)
	..s perinfo=personObj.PerID_","_perName
	..s perId=personObj.PerID
	..q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	..s obj=##class(DHCNMG.HR.MgSupport).%OpenId(rw)
	..s SupportAgency=obj.SupportAgency
	..i obj.SupportYear'="" s SupportYear=+$zd(obj.SupportYear,"3")
	..i obj.SupportStDate'="" s SupportStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SupportStDate)
	..e  s SupportStDate=""
	..i obj.SupportEndDate'="" s SupportEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SupportEndDate)
	..e  s SupportEndDate=""
	..s status=""
	..i obj.SupportStatus="N" s status="保存"
	..e  i obj.SupportStatus="Y" s status="提交"
	..e  i obj.SupportStatus="A" s status="审核"
	..e  i obj.SupportStatus="B" s status="驳回"
	..s ret="SupportAgency|"_SupportAgency_"^SupportYear|"_SupportYear_"^SupportStDate|"_SupportStDate_"^SupportEndDate|"_SupportEndDate_"^SupportRowID|"_rw_"^status|"_status_"^NurName|"_perName_"^NurWard|"_perWard_"^NurId|"_perId   
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllSupportListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllSupportListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllSupportListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllSupportListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Dhh
/// Description:获取教材编辑
/// Date:2019-11-14
/// Table:DHCNMG.HR.MgTeach
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAllTeachList","")
Query FindAllTeachList(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllTeachListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=$p(parr,"^",1)
	s par="" f  s par=$O(^DHCNMG.HR.MgTeachI("ssid",par)) q:par=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgTeachI("ssid",par,rw)) q:rw=""  d
	..s personObj=##class(DHCNMG.HR.MgPersons).%OpenId(par)
	..q:'$IsObject(personObj)
	..q:personObj.PerStatus'="17||1"
	..s perName=personObj.PerName
	..s perWard=##class(DHCNMG.DB.MgWard).%OpenId(personObj.PerDepDR).WardDesc
	..q:(ward'="")&&(ward'=personObj.PerDepDR)
	..s perinfo=personObj.PerID_","_perName
	..s perId=personObj.PerID
	..q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	..s obj=##class(DHCNMG.HR.MgTeach).%OpenId(rw)
	..s TeachTitle=obj.TeachTitle
	..s TeachPubNo=obj.TeachPubNo
	..i obj.TeachPublic'="" s TeachPublic=..GetCommCode(obj.TeachPublic)
	..e  s TeachPublic=""
	..i obj.TeachType'="" s TeachType=..GetCommCode(obj.TeachType)
	..e  s TeachType=""
	..s status=""
	..i obj.TeachStatus="N" s status="保存"
	..e  i obj.TeachStatus="Y" s status="提交"
	..e  i obj.TeachStatus="A" s status="审核"
	..e  i obj.TeachStatus="B" s status="驳回"
	..s ret="TeachTitle|"_TeachTitle_"^TeachPubNo|"_TeachPubNo_"^TeachPublic|"_TeachPublic_"^TeachType|"_TeachType_"^TeachRowID|"_rw_"^status|"_status_"^NurName|"_perName_"^NurWard|"_perWard_"^NurId|"_perId   
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllTeachListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllTeachListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllTeachListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllTeachListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Dhh
/// Description:获取学术任职
/// Date:2019-11-14
/// Table:DHCNMG.HR.MgAcapos
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAllAcaposList","")
Query FindAllAcaposList(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllAcaposListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=$p(parr,"^",1)
	s post=$p(parr,"^",2)
	s par="" f  s par=$O(^DHCNMG.HR.MgAcaposI("ssid",par)) q:par=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgAcaposI("ssid",par,rw)) q:rw=""  d
	..s personObj=##class(DHCNMG.HR.MgPersons).%OpenId(par)
	..q:'$IsObject(personObj)
	..q:personObj.PerStatus'="17||1"
	..s perName=personObj.PerName
	..s perWard=##class(DHCNMG.DB.MgWard).%OpenId(personObj.PerDepDR).WardDesc
	..q:(ward'="")&&(ward'=personObj.PerDepDR)
	..s perinfo=personObj.PerID_","_perName
	..s perId=personObj.PerID
	..q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	..s obj=##class(DHCNMG.HR.MgAcapos).%OpenId(rw)
	..q:(post'="")&&(post'=obj.AcaposPost)
	..i obj.AcaposStDate'="" s AcaposStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.AcaposStDate)
	..e  s AcaposStDate=""
	..i obj.AcaposEndDate'="" s AcaposEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.AcaposEndDate)
	..e  s AcaposEndDate=""
	..i obj.AcaposPost'="" s AcaposPost=..GetCommCode(obj.AcaposPost)
	..e  s AcaposPost=""
	..s AcaposUnit=obj.AcaposUnit
	..s status=""
	..i obj.AcaposStatus="N" s status="保存"
	..e  i obj.AcaposStatus="Y" s status="提交"
	..e  i obj.AcaposStatus="A" s status="审核"
	..e  i obj.AcaposStatus="B" s status="驳回"
	..s ret="AcaposStDate|"_AcaposStDate_"^AcaposEndDate|"_AcaposEndDate_"^AcaposPost|"_AcaposPost_"^AcaposUnit|"_AcaposUnit_"^AcaposRowID|"_rw_"^status|"_status_"^NurName|"_perName_"^NurWard|"_perWard_"^NurId|"_perId   
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllAcaposListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllAcaposListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllAcaposListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllAcaposListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Dhh
/// Description:获取学术会议
/// Date:2019-11-14
/// Table:DHCNMG.HR.MgAcadMeeting
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAllAcadList","")
Query FindAllAcadList(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllAcadListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=$p(parr,"^",1)
	s par="" f  s par=$O(^DHCNMG.HR.MgAcadMeetingI("ssid",par)) q:par=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgAcadMeetingI("ssid",par,rw)) q:rw=""  d
	..s personObj=##class(DHCNMG.HR.MgPersons).%OpenId(par)
	..q:'$IsObject(personObj)
	..q:personObj.PerStatus'="17||1"
	..s perName=personObj.PerName
	..s perWard=##class(DHCNMG.DB.MgWard).%OpenId(personObj.PerDepDR).WardDesc
	..q:(ward'="")&&(ward'=personObj.PerDepDR)
	..s perinfo=personObj.PerID_","_perName
	..s perId=personObj.PerID
	..q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	..s obj=##class(DHCNMG.HR.MgAcadMeeting).%OpenId(rw)
	..i obj.AcadYear'="" s AcadYear=+$zd(obj.AcadYear,3)
	..e  s AcadYear=""
	..i obj.AcadDate'="" s AcadDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.AcadDate)
	..e  s AcadDate=""
	..s AcadNurNum=obj.AcadNurNum
	..s AcadUnit=obj.AcadUnit
	..s AcadPlace=obj.AcadPlace
	..s AcadTitle=obj.AcadTitle
	..s status=""
	..i obj.AcadStatus="N" s status="保存"
	..e  i obj.AcadStatus="Y" s status="提交"
	..e  i obj.AcadStatus="A" s status="审核"
	..e  i obj.AcadStatus="B" s status="驳回"
	..s ret="AcadYear|"_AcadYear_"^AcadDate|"_AcadDate_"^AcadNurNum|"_AcadNurNum_"^AcadUnit|"_AcadUnit_"^AcadPlace|"_AcadPlace_"^AcadTitle|"_AcadTitle_"^AcadRowID|"_rw_"^status|"_status_"^NurName|"_perName_"^NurWard|"_perWard_"^NurId|"_perId
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllAcadListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllAcadListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllAcadListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllAcadListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Dhh
/// Description:获取推广技术
/// Date:2019-11-15
/// Table:DHCNMG.HR.MgPromote
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAllAcadList","")
Query FindAllPromoteList(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllPromoteListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=$p(parr,"^",1)
	s par="" f  s par=$O(^DHCNMG.HR.MgPromoteI("ssid",par)) q:par=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgPromoteI("ssid",par,rw)) q:rw=""  d
	..s personObj=##class(DHCNMG.HR.MgPersons).%OpenId(par)
	..q:'$IsObject(personObj)
	..q:personObj.PerStatus'="17||1"
	..s perName=personObj.PerName
	..s perWard=##class(DHCNMG.DB.MgWard).%OpenId(personObj.PerDepDR).WardDesc
	..q:(ward'="")&&(ward'=personObj.PerDepDR)
	..s perinfo=personObj.PerID_","_perName
	..s perId=personObj.PerID
	..q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	..s obj=##class(DHCNMG.HR.MgPromote).%OpenId(rw)
	..i obj.PromoteStYear'="" s PromoteStYear=+$zd(obj.PromoteStYear,3)
	..e  s PromoteStYear=""
	..i obj.PromoteEndYear'="" s PromoteEndYear=+$zd(obj.PromoteEndYear,3)
	..e  s PromoteEndYear=""
	..s PromoteTitle=obj.PromoteTitle
	..s PromoteNum=obj.PromoteNum
	..s PromoteNurse=obj.PromoteNurse
	..s status=""
	..i obj.PromoteStatus="N" s status="保存"
	..e  i obj.PromoteStatus="Y" s status="提交"
	..e  i obj.PromoteStatus="A" s status="审核"
	..e  i obj.PromoteStatus="B" s status="驳回"
	..s ret="PromoteTitle|"_PromoteTitle_"^PromoteNum|"_PromoteNum_"^PromoteNurse|"_PromoteNurse_"^PromoteStYear|"_PromoteStYear_"^PromoteEndYear|"_PromoteEndYear_"^PromoteRowID|"_rw_"^status|"_status_"^NurName|"_perName_"^NurWard|"_perWard_"^NurId|"_perId
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllPromoteListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllPromoteListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllPromoteListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllPromoteListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Dhh
/// Description:获取专科发展
/// Date:2019-11-15
/// Table:DHCNMG.HR.MgSepcialDevelop
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAllSpecialList","")
Query FindAllSpecialList(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllSpecialListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=$p(parr,"^",1)
	s par="" f  s par=$O(^DHCNMG.HR.MgSepcialDevelopI("ssid",par)) q:par=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgSepcialDevelopI("ssid",par,rw)) q:rw=""  d
	..s personObj=##class(DHCNMG.HR.MgPersons).%OpenId(par)
	..q:'$IsObject(personObj)
	..q:personObj.PerStatus'="17||1"
	..s perName=personObj.PerName
	..s perWard=##class(DHCNMG.DB.MgWard).%OpenId(personObj.PerDepDR).WardDesc
	..q:(ward'="")&&(ward'=personObj.PerDepDR)
	..s perinfo=personObj.PerID_","_perName
	..s perId=personObj.PerID
	..q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	..s obj=##class(DHCNMG.HR.MgSepcialDevelop).%OpenId(rw)
	..s SpecialWard=obj.SpecialWard
	..s SpecialEvent=obj.SpecialEvent
	..s status=""
	..i obj.SpecialStatus="N" s status="保存"
	..e  i obj.SpecialStatus="Y" s status="提交"
	..e  i obj.SpecialStatus="A" s status="审核"
	..e  i obj.SpecialStatus="B" s status="驳回"
	..s ret="SpecialWard|"_SpecialWard_"^SpecialEvent|"_SpecialEvent_"^SpecialRowID|"_rw_"^status|"_status_"^NurName|"_perName_"^NurWard|"_perWard_"^NurId|"_perId
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllSpecialListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllSpecialListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllSpecialListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllSpecialListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Dhh
/// Description:获取指导研究生
/// Date:2019-11-15
/// Table:DHCNMG.HR.MgGuide
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAllSpecialList","")
Query FindAllGuideList(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllGuideListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=$p(parr,"^",1)
	s type=$p(parr,"^",2)
	s par="" f  s par=$O(^DHCNMG.HR.MgGuideI("ssid",par)) q:par=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgGuideI("ssid",par,rw)) q:rw=""  d
	..s personObj=##class(DHCNMG.HR.MgPersons).%OpenId(par)
	..q:'$IsObject(personObj)
	..q:personObj.PerStatus'="17||1"
	..s perName=personObj.PerName
	..s perWard=##class(DHCNMG.DB.MgWard).%OpenId(personObj.PerDepDR).WardDesc
	..q:(ward'="")&&(ward'=personObj.PerDepDR)
	..s perinfo=personObj.PerID_","_perName
	..s perId=personObj.PerID
	..q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	..s obj=##class(DHCNMG.HR.MgGuide).%OpenId(rw)
	..q:(type'="")&&(type'=obj.GuideType)
	..s GuideName=obj.GuideName
	..s GuideSchool=obj.GuideSchool
	..s GuideProfession=obj.GuideProfession
	..i obj.GuideStDate'="" s GuideStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.GuideStDate)
	..e  s GuideStDate=""
	..i obj.GuideEndDate'="" s GuideEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.GuideEndDate)
	..e  s GuideEndDate=""
	..i obj.GuideType'="" s GuideType=..GetCommCode(obj.GuideType)
	..e  s GuideType=""
	..s status=""
	..i obj.GuideStatus="N" s status="保存"
	..e  i obj.GuideStatus="Y" s status="提交"
	..e  i obj.GuideStatus="A" s status="审核"
	..e  i obj.GuideStatus="B" s status="驳回"
	..s ret="GuideName|"_GuideName_"^GuideSchool|"_GuideSchool_"^GuideProfession|"_GuideProfession_"^GuideStDate|"_GuideStDate_"^GuideEndDate|"_GuideEndDate_"^GuideType|"_GuideType_"^GuideRowID|"_rw_"^status|"_status_"^NurName|"_perName_"^NurWard|"_perWard_"^NurId|"_perId
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllGuideListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllGuideListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllGuideListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllGuideListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Dhh
/// Description:获取教育信息
/// Date:2019-11-13
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindEducationalList","^","")
Query FindEducationalList(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindEducationalListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$p(parr,"^",1)
	s educational=$p(parr,"^",2)
	s n=1
	s flag="false"
	s par="" f  s par=$O(^DHCNMG.HR.MgEducateI("flag",par)) q:par=""  d
	.;q:((parr'="")&&(par'=parr))
	.s date="" f  s date=$O(^DHCNMG.HR.MgEducateI("flag",par,date)) q:date=""  d
	..s personObj=##class(DHCNMG.HR.MgPersons).%OpenId(par)
	..q:'$IsObject(personObj)
	..q:personObj.PerStatus'="17||1"
	..s perName=personObj.PerName
	..s perWard=##class(DHCNMG.DB.MgWard).%OpenId(personObj.PerDepDR).WardDesc
	..q:(ward'="")&&(ward'=personObj.PerDepDR)
	..s perinfo=personObj.PerID_","_perName
	..s perId=personObj.PerID
	..q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	..s rw="" f  s rw=$O(^DHCNMG.HR.MgEducateI("flag",par,date,rw)) q:rw=""  d
	...s obj=##class(DHCNMG.HR.MgEducate).%OpenId(rw)
	...;q:obj.EduStatus'="A"
	...i obj.EduStDate'="" s EduStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduStDate)
	...e  s EduStDate=""
	...i obj.EduEndDate'="" s EduEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduEndDate)
	...e  s EduEndDate=""
	...i obj.EduSchool'="" s EduSchool=..GetCommCode(obj.EduSchool)
	...e  s EduSchool=""
	...i obj.EduAcademic'="" s EduAcademic=..GetCommCode(obj.EduAcademic)
	...e  s EduAcademic=""
	...i obj.EduDegree'="" s EduDegree=..GetCommCode(obj.EduDegree)
	...e  s EduDegree=""
	...i obj.EduProfession'="" s EduProfession=..GetCommCode(obj.EduProfession)
	...e  s EduProfession=""
	...s EduRadio=""
	...i obj.EduRadio'="" d
	....s eduobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.EduRadio)
	....q:'$IsObject(eduobj)
	....s EduRadio=eduobj.SubDesc
	...i obj.EduDegreeDate'="" s EduDegreeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduDegreeDate)
	...e  s EduDegreeDate=""
	...s eduAcadeType=""
	...i EduRadio="全日制" d
	....i flag="false" d
	.....s eduAcadeType="第一学历"
	.....s flag="true"
	...s count=..GetCountAcade(par)
	...i ((n=count)&&(n>1)) d
	....s eduAcadeType="最高学历"
	...s n=n+1
	...s status=""
	...i obj.EduStatus="N" s status="保存"
	...e  i obj.EduStatus="Y" s status="提交"
	...e  i obj.EduStatus="A" s status="审核"
	...e  i obj.EduStatus="B" s status="驳回"
	..s ret="EduStDate|"_EduStDate_"^EduEndDate|"_EduEndDate_"^EduSchool|"_EduSchool_"^EduAcademic|"_EduAcademic_"^EduDegree|"_EduDegree_"^EduRowID|"_rw_"^EduProfession|"_EduProfession_"^EduRadio|"_EduRadio_"^EduDegreeDate|"_EduDegreeDate_"^eduAcadeType|"_eduAcadeType_"^status|"_status_"^NurName|"_perName_"^NurWard|"_perWard_"^NurId|"_perId
	..do OutputSourceList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSourceList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindEducationalListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEducationalListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindEducationalListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEducationalListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:liuning
/// Description:查询职务列表
/// Date:2019-09-19
/// Table:DHCNMG.HR.MgPostDuty
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindNurPostList","","")
Query FindNurPostList(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurPostListExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=$p(parr,"^",1)
	s post=$p(parr,"^",2)
	s par="" f  s par=$O(^DHCNMG.HR.MgPostDutyI("ssid",par)) q:par=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgPostDutyI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgPostDuty).%OpenId(rw)
	..q:(ward'="")&&(ward'=obj.PostPerDR.PerDepDR)
	..q:(post'="")&&(post'=obj.PostDuty)
	..s perinfo=obj.PostPerDR.PerID_","_obj.PostPerDR.PerName
	..q:(input'="")&&($zcvt(perinfo,"U")'[$zcvt(input,"U"))
	..i obj.PostDuty'="" s PostDuty=..GetCommCode(obj.PostDuty)
	..e  s PostDuty=""
	..i obj.PostStDate'="" s PostStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PostStDate)
	..e  s PostStDate=""
	..i obj.PostEndDate'="" s PostEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PostEndDate)
	..e  s PostEndDate=""
	..s PostRemark=obj.PostRemark
	..s status=""
	..i obj.PostStatus="N" s status="保存"
	..e  i obj.PostStatus="Y" s status="提交"
	..e  i obj.PostStatus="A" s status="审核"
	..e  i obj.PostStatus="B" s status="驳回"
	..s NurName=obj.PostPerDR.PerName
	..s NurId=obj.PostPerDR.PerID
	..s NurWard=##class(DHCNMG.DB.MgWard).%OpenId(obj.PostPerDR.PerDepDR).WardDesc
	..s ret="^NurName|"_NurName_"^NurWard|"_NurWard_"^NurId|"_NurId_"^postDuty|"_PostDuty_"^postStDate|"_PostStDate_"^postEndDate|"_PostEndDate_"^postRemark|"_PostRemark_"^postRowID|"_rw_"^status|"_status
	..do OutputPostData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPostData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurPostListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurPostListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurPostListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurPostListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2019-12-20
/// Description:获取人员审核状态
/// Table:
/// Input:
/// Output:
ClassMethod GetPersonStatus(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	q:'$IsObject(obj) 0
	s status=obj.PerAuditFlag
	q status
}

}

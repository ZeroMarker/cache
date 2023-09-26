/// 名称：web.DHCCPW.MR.BranchAnalysis
/// 描述：对分支型临床路径的各种操作
/// 编写者：牛才才
/// 编写日期：2011-10-12
Class web.DHCCPW.MR.BranchAnalysis Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 描述:     得到分支型临床路径的全部记录
/// 编写者：  牛才才
/// 编写日期：2011-10-12
/// Mocify  : 2011-11-08 
/// by wuqk 传出路径字典信息
///         User.DHCMRCClinPathWaysDic
/// 表名:     User.DHC_MRC_ClinPathWays
/// 入参：    Y 分支型临床路径标记
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.BranchAnalysis","GetPathWays","")
Query GetPathWays() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,CPWOffShoot:%String")
{
}

ClassMethod GetPathWaysExecute(ByRef qHandle As %Binary) As %Status
{
	new (qHandle)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	Kill ^CacheTemp($zn,repid,"CPWOffShoot")
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:CPWID=""
		
		Set objCPW=..GetObjById(CPWID)
		If $IsObject(objCPW) {
			Set CPWOffShoot=objCPW.CPWOffShoot
			Continue:CPWOffShoot'="Y"
			Set ^CacheTemp($zn,repid,"CPWOffShoot",objCPW.CPWCPWDicDR.%Id())=""
		}
	}
	Set cpwDr=$o(^CacheTemp($zn,repid,"CPWOffShoot",0))
	while cpwDr'=""{
		Set objCPWDic=##class(User.DHCMRCClinPathWaysDic).%OpenId(cpwDr)
		Set Code=objCPWDic.CPWDCode
		Set Desc=objCPWDic.CPWDDesc
		if objCPWDic.CPWDActive="Y" {
			//Set Data=$lb(CPWID,Code,Desc,CPWOffShoot)
			Set Data=$lb(cpwDr,Code,Desc,CPWOffShoot)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		Set cpwDr=$o(^CacheTemp($zn,repid,"CPWOffShoot",cpwDr))
	}
	Quit $$$OK
}

ClassMethod GetPathWaysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPathWaysExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPathWaysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPathWaysExecute ]
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

/// 描述:     得到合并症的全部记录
/// 编写者：  牛才才
/// 编写日期：2011-10-12
/// Mocify  : 2011-11-08 
/// by wuqk 传出合并症的路径字典信息
///         User.DHCMRCClinPathWaysDic
/// 表名:     User.DHC_MRC_ClinPathWays
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.BranchAnalysis","GetSyndrome","")
Query GetSyndrome() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod GetSyndromeExecute(ByRef qHandle As %Binary) As %Status
{
	new (qHandle)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	/*Kill ^CacheTemp($zn,repid,"SYNDROME")
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:CPWID=""
		
		Set objCPW=..GetObjById(CPWID)
		If $IsObject(objCPW) {
			Set Code=objCPW.CPWCode
			Set Desc=objCPW.CPWDesc
			If $IsObject(objCPW.CPWCPWTypeDR) {
				Set TypeID=objCPW.CPWCPWTypeDR.%Id()
				Set TypeCode=objCPW.CPWCPWTypeDR.CLPTCode
				Continue:TypeCode'="SYNDROME"
				Set ^CacheTemp($zn,repid,"SYNDROME",objCPW.CPWCPWDicDR.%Id())=""
			}
			
		}
	}*/
	Set cpwDr=$o(^DHCMRC("CPWD",0))
	while cpwDr'=""{
		Set objCPWDic=##class(User.DHCMRCClinPathWaysDic).%OpenId(cpwDr)
		Set Code=objCPWDic.CPWDCode
		Set Desc=objCPWDic.CPWDDesc
		If $IsObject(objCPWDic.CPWDCPWTypeDR){
			Set TypeCode=objCPWDic.CPWDCPWTypeDR.CLPTCode
			if TypeCode="SYNDROME"{
				Set Data=$lb(cpwDr,Code,Desc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		Set cpwDr=$o(^DHCMRC("CPWD",cpwDr))
		//Set Data=$lb(CPWID,Code,Desc)
		//Set cpwDr=$o(^CacheTemp($zn,repid,"SYNDROME",cpwDr))
	}
	Quit $$$OK
}

ClassMethod GetSyndromeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPathWaysExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetSyndromeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPathWaysExecute ]
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

/// 描述:     根据ID得到临床路径对象
/// 编写者：  牛才才
/// 编写日期：2010-10-12
/// 表名：    User.DHCMRCClinPathWays
/// 入参：    ID:   User.DHCMRCClinPathWays.Id
/// 返回值：  返回object
/// w ##class(web.DHCCPW.MR.BranchAnalysis).GetObjById("2")
ClassMethod GetObjById(argId As %String) As User.DHCMRCBaseDictionary
{
	New (argId)
	Set return=##Class(User.DHCMRCClinPathWays).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// 描述:     通过临床路径ID来得到当前路径下的所有步骤的全部记录
/// 编写者:   牛才才
/// 编写日期: 2011-09-28
/// 表名:     User.DHCMRCClinPathWaysEpStep
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.BranchAnalysis","GetAllStepByCPWID","2")
Query GetAllStepByCPWID(argCPWID As %String) As %Query(ROWSPEC = "StepRowid:%String,StepDesc:%String")
{
}

ClassMethod GetAllStepByCPWIDExecute(ByRef qHandle As %Binary, argCPWID As %String) As %Status
{
	new (qHandle,argCPWID)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set CPWID=argCPWID
	Set EpID=0
	For {
		Set EpID=$o(^DHCMRC("CPW",CPWID,"EP",EpID))
		Quit:EpID=""
		Set EpRowID=CPWID_"||"_EpID
		Set objEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(EpRowID)
		Set StepID=0
		For {
			Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
			Quit:StepID=""
			Set StepRowID=CPWID_"||"_EpID_"||"_StepID
			
			Set objStep=..GetStepObjById(StepRowID)
			If $IsObject(objStep){
				Set StepDesc=objStep.CPWSDesc
				Set Data=$lb(StepRowID,StepDesc)
	 			
	 			Set ^CacheTemp(repid,ind)=Data
	 			Set ind=ind+1
	 			
			}
		}
	}
	Quit $$$OK
}

ClassMethod GetAllStepByCPWIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllStepByCPWIDExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllStepByCPWIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllStepByCPWIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 描述:     根据ID取临床路径步骤对象
/// 编写者：  牛才才
/// 编写日期：2010-10-12
/// 表名：    User.DHCMRCClinPathWaysEpStep
/// 入参：    ID:User.DHCMRCClinPathWaysEpStep.Id
/// 返回值：  返回object
/// w ##class(web.DHCCPW.MR.BranchAnalysis).GetStepObjById("1||1||1")
ClassMethod GetStepObjById(argId As %String) As User.DHCMRCClinPathWaysEpStep
{
	New (argId)
	Set return=##Class(User.DHCMRCClinPathWaysEpStep).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     wuqk
/// CreatDate：   2011-11-16
/// Description:  分支型统计明细查询
/// Input：       repid,index
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.BranchAnalysis","QryDetails",1,1)
Query QryDetails(sRepid As %String, sIndex As %String) As %Query(ROWSPEC = "Rowid:%String,Paadm:%String,PathwayDR:%String,PathWayDesc:%String,PathWayEpDR:%String,PathWayEpDesc:%String,EpStepDR:%String,EPStepDesc:%String,Status:%String,StatusDesc:%String,InDoctorDR:%String,InDoctorDesc:%String,InDate:%String,InTime:%String,OutDoctorDR:%String,OutDoctorDesc:%String,OutDate:%String,OutTime:%String,OutReasonDR:%String,OutReasonDesc:%String,UpdateUserDR:%String,UpdateUserDesc:%String,UpdateDate:%String,UpdateTime:%String,Comments:%String,RefCost:%String,RefDays:%String,VarCount:%String,VarReason:%String,PatientID:%String,PapmiNo:%String,InMedicare:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmStatus:%String,AdmDays:%String,CountCost:%String,DrugRatio:%String,ErrFlag:%String")
{
}

ClassMethod QryDetailsExecute(ByRef qHandle As %Binary, sRepid As %String, sIndex As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	Quit:(sRepid="")||(sIndex="") $$$OK
	/*
	set ^CacheTemp($zn,sRepid,sIndex,MRCPWId)=""  //准备明细数据
	*/
	Quit:'$d(^CacheTemp($zn,sRepid,sIndex)) $$$OK
	
	set MRCPWId=0
	for {
		set MRCPWId=$o(^CacheTemp($zn,sRepid,sIndex,MRCPWId))
		quit:MRCPWId=""
		Set Data=##Class(web.DHCCPW.MR.ClinPathWaysQuery).BuildCPWData(MRCPWId,"")
		Continue:Data=""
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDetailsExecute ]
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

/// 查询分支型临床路径
/// by ncc 
/// 2011-09-16
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseDictionary","QryOffShoot","Y")
Query QryOffShoot(Y As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT * FROM SQLUser.DHC_MRC_ClinPathWays,(select max(CPW_RowId) as CPW_RowId,CPW_Desc from SQLUser.DHC_MRC_ClinPathWays group by CPW_Desc) as temp
WHERE temp.CPW_RowId=SQLUser.DHC_MRC_ClinPathWays.CPW_RowId and temp.CPW_Desc=SQLUser.DHC_MRC_ClinPathWays.CPW_Desc and SQLUser.DHC_MRC_ClinPathWays.CPW_OffShoot=:Y
}

/// 查询所有步骤类型
/// by ncc 
/// 2011-10-13
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.MR.BranchAnalysis","QryDicBySubCatDesc","STEPTYPE")
Query QryDicBySubCatDesc(SubCateDesc As %String, Active As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT BD_RowId,BD_Code,BD_Desc,BD_Active FROM SQLUser.DHC_MRC_BaseDictionary
 WHERE (BD_TypeDR->BDSC_Code = :SubCateDesc AND (:Active IS NULL OR (BD_Active=:Active)))
 ORDER BY BD_Code
}

/// 查询并发症
/// by ncc 
/// 2011-09-15
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseDictionary","QrySyndrome","SYNDROME")
Query QrySyndrome(SYNDROME As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT CPWD_RowId,CPWD_Code,CPWD_Desc,CPWD_Active FROM SQLUser.DHC_MRC_ClinPathWaysDic
 WHERE (CPWD_CPWType_DR->CLPT_Code = :SYNDROME)
 ORDER BY CPWD_Code
}

//Query QryCPWDischStat(argDateFrom As %String, argDateTo As %String, argCPWDesc As %String) As %Query(ROWSPEC = "LocDesc:%String,CPWDesc:%String,DischNum:%String,CPWDischNum:%String,InCPWNum:%String,CloseCPWNum:%String,OutCPWNum:%String,InDays:%String,OutDays:%String,CloseDays:%String,CPWRatio:%String,InRatio:%String,OutRatio:%String,CloseRatio:%String,InCost:%String,InDrugRatio:%String,CloseCost:%String,CloseDrugRatio:%String,OutCost:%String,OutDrugRatio:%String")

/// Creator：     wuqk
/// CreatDate：   2011-11-09
/// Description:  分支型临床路径统计
/// Input：       DateFrom(开始日期),DateTo(结束日期),Items(统计项目列表)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.BranchAnalysis","QryCPWDischStat","2011-01-01","2011-01-20")
Query QryCPWDischStat(argDateFrom As %String, argDateTo As %String, argCPWDesc As %String) As %Query(ROWSPEC = "CPWDesc:%String,InCPWNum:%String,OutCPWNum:%String,CloseCPWNum:%String,VarianceCount:%String,OutRatio:%String,CloseRatio:%String,VarianceRatio:%String,InDays:%String,CloseCost:%String,InDrugRatio:%String,repid:%String,index:%String")
{
}

ClassMethod QryCPWDischStatExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, Items As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	Kill ^CacheTemp($zn,repid)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	/*
	set objTitle=##class(User.DHCMRCOffShootStatTitle).%OpenId(1)
	quit:objTitle="" $$$OK
	set count=objTitle.Items.Count()
	for index=1:1:count {
		set objItem=objTitle.Items.GetAt(index)
		set Key=objItem.CPWDicId_"|"_objItem.StepTypeList_"|"_objItem.SyndromeDicList
		
		s item=Key_"|"_objItem.ItemDesc
		//set ^CacheTemp(repid,ind)=$lb(index,objItem.ItemDesc,Key,1)
		//set objItem=""
		//set ind=ind+1
		s Items=Items_item_$c(1)
	}*/
	
	
	Quit:Items="" $$$OK
	
	//构造本次统计的项目信息
	set length=$l(Items,$c(1))
	for index=1:1:length {
		set Item=$p(Items,$c(1),index)
		continue:Item=""
		set CPWDicId=$p(Item,"|",1)
		set StepTypeList=$p(Item,"|",2)
		set SyndromeDicList=$p(Item,"|",3)
		set ItemDesc=$p(Item,"|",4)
		//^DHCMRCi("CPW",0,"IndexPathWayDicAA",1
		//构造统计的路径版本Id
		if $d(^DHCMRCi("CPW",0,"IndexPathWayDicAA",CPWDicId)){
			set Active=$o(^DHCMRCi("CPW",0,"IndexPathWayDicAA",CPWDicId,0))
			set dicCount=0
			while Active'="" {
				//w !,Active
				set cpwId=$o(^DHCMRCi("CPW",0,"IndexPathWayDicAA",CPWDicId,Active,0))
				for {
					set cpwId=$o(^DHCMRCi("CPW",0,"IndexPathWayDicAA",CPWDicId,Active,cpwId))
					quit:cpwId=""
					set objCPW=..GetObjById(cpwId)
					if objCPW'=""{
						//w "-cpwId=",cpwId
						//w "-CPWOffShoot=",objCPW.CPWOffShoot," "
						continue:objCPW.CPWOffShoot'="Y"
						set ^CacheTemp($zn,repid,"CPWDischStat",0,"cpw",cpwId,index)=""  //通过出入径记录的cpwId归入统计项目
						set dicCount=dicCount+1
					}
				}
				set Active=$o(^DHCMRCi("CPW",0,"IndexPathWayDicAA",CPWDicId,Active))
			}
			
			if dicCount>0{ //判断该路径字典下是否有分支型路径
				set ^CacheTemp($zn,repid,"CPWDischStat",index,"ItemDesc")=ItemDesc
				set ^CacheTemp($zn,repid,"CPWDischStat",index,"StepTypeList")=StepTypeList
				set ^CacheTemp($zn,repid,"CPWDischStat",index,"SyndromeDicList")=SyndromeDicList
				set stepCount=$l(StepTypeList,"^")
				for j=1:1:stepCount {
					set stepTypeCode=$p(StepTypeList,"^",j)
					continue:stepTypeCode=""
					set ^CacheTemp($zn,repid,"CPWDischStat",index,"StepTypeList",stepTypeCode)=""
				}
				set SyndromeCount=$l(SyndromeDicList,"^")
				for j=1:1:SyndromeCount {
					set Syndrome=$p(SyndromeDicList,"^",j)                            //并发症路径字典Id
					continue:Syndrome=""
					set ^CacheTemp($zn,repid,"CPWDischStat",index,"SyndromeDicList",Syndrome)=""
				}
			}
		}
	}
	Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For DischDate=argDateFrom:1:argDateTo {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(DischDateIndex,DischDate,Paadm))
			Quit:Paadm=""
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set AdmLoc=$p(AdmInfo,"^",4)
			Set AdmWard=$p(AdmInfo,"^",70)
			//Continue:(argLocID'="")&&(AdmLoc'=argLocID)     //科室过滤
			//Continue:(argWardID'="")&&(AdmWard'=argWardID)  //病区过滤
			Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
			Continue:MRAdm=""
			//^DHCMRi("CPW",0,"IndexMRAdm")
			Continue:'$d(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm))
			//w !,"Paadm=",Paadm,"  MRAdm=",MRAdm
			set MRCPWId=0
			For {
				set MRCPWId=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,MRCPWId))
				Quit:MRCPWId=""
				//w "  MRCPWId="_MRCPWId
				set objMRCPW=##class(User.DHCMRClinicalPathWay).%OpenId(MRCPWId)
				Continue:'$IsObject(objMRCPW)
				set cpwId=objMRCPW.CPWPathwayDR.%Id()
				Continue:'$d(^CacheTemp($zn,repid,"CPWDischStat",0,"cpw",cpwId))
				set index=0
				for {
					set index=$o(^CacheTemp($zn,repid,"CPWDischStat",0,"cpw",cpwId,index))
					quit:index=""
					set sc=$$BuildData(repid,index,MRCPWId,objMRCPW,AdmInfo,Paadm,DischDate)
				}
			}
		}
	}
	
	set index=0
	For {
		set index=$o(^CacheTemp($zn,repid,"CPWDischStat",index))
		quit:index=""
		set CPWDesc=$g(^CacheTemp($zn,repid,"CPWDischStat",index,"ItemDesc"))          //治疗路径
		set InCPWNum=+$g(^CacheTemp($zn,repid,"CPWDischStat",index,"InCPWNum"))         //入径人数
		set OutCPWNum=+$g(^CacheTemp($zn,repid,"CPWDischStat",index,"OutCPWNum"))       //出径人数
		set CloseCPWNum=+$g(^CacheTemp($zn,repid,"CPWDischStat",index,"CloseCPWNum"))     //完成人数
		set VarianceCount=+$g(^CacheTemp($zn,repid,"CPWDischStat",index,"VarianceCount"))     //变异人数
		set:InCPWNum=0 OutRatio="-"
		set:InCPWNum'=0 OutRatio=$fn((OutCPWNum/InCPWNum)*100,"",2)_"%"                  //出径率
		set:InCPWNum=0 CloseRatio="-"
		set:InCPWNum'=0 CloseRatio=$fn((CloseCPWNum/InCPWNum)*100,"",2)_"%"                  //完成率
		set:InCPWNum=0 VarianceRatio="-"
		set:InCPWNum'=0 VarianceRatio=$fn((VarianceCount/InCPWNum)*100,"",2)_"%"                  //变异率
		set:+CloseCPWNum=0 InDays=0
		set:+CloseCPWNum'=0 InDays=$fn(+$g(^CacheTemp($zn,repid,"CPWDischStat",index,"InDays_Count"))/CloseCPWNum,"",2)   //完成路径平均住院日
		set:+CloseCPWNum=0 (CloseCost,CloseCostCount)=0
		set:+CloseCPWNum'=0 CloseCostCount=$fn(+$g(^CacheTemp($zn,repid,"CPWDischStat",index,"CloseCost_Count")),"",2)   //完成路径总费用
		set:+CloseCostCount=0 CloseCost=0,InDrugRatio="-"
		if +CloseCostCount'=0 {
			set CloseCost=$fn(CloseCostCount/CloseCPWNum,"",2)     //完成路径次均费用
			set InDrugCount=+$g(^CacheTemp($zn,repid,"CPWDischStat",index,"InDrug_Count"))
			set InDrugRatio=$fn((InDrugCount/+CloseCostCount)*100,"",2)_"%"   //完成路径药费比
		}
		set Data=$lb(CPWDesc,InCPWNum,OutCPWNum,CloseCPWNum,VarianceCount,OutRatio,CloseRatio,VarianceRatio,InDays,CloseCost,InDrugRatio)
		
	    Set Data=Data_$lb($g(repid))
	    Set Data=Data_$lb($g(index))
		set ^CacheTemp(repid,ind)=Data
		set ind=ind+1
	}
	/*
			,{header: '治疗路径', width: 200, dataIndex: 'CPWDesc', sortable: false}
			,{header: '入径人数', width: 60, dataIndex: 'InCPWNum', sortable: false}
			,{header: '出径人数', width: 60, dataIndex: 'OutCPWNum', sortable: false}
			,{header: '完成人数', width: 60, dataIndex: 'CloseCPWNum', sortable: false}
			//,{header: '变异人数', width: 60, dataIndex: 'VarianceCount', sortable: false}
			,{header: '出径率', width: 60, dataIndex: 'OutRatio', sortable: false}
			,{header: '完成率', width: 60, dataIndex: 'CloseRatio', sortable: false}
			//,{header: '变异率', width: 60, dataIndex: 'VarianceRatio', sortable: false}
			,{header: '完成路径平均住院日', width: 60, dataIndex: 'InDays', sortable: false}
			,{header: '完成路径次均费用', width: 60, dataIndex: 'CloseCost', sortable: false}
			,{header: '完成路径药费比', width: 60, dataIndex: 'InDrugRatio', sortable: false}
	
	*/
	//"LocDesc,CPWDesc,DischNum,CPWDischNum,InCPWNum,CloseCPWNum,OutCPWNum,InDays,OutDays,CloseDays,CPWRatio,InRatio,OutRatio,CloseRatio,InCost,InDrugRatio,CloseCost,CloseDrugRatio,OutCost,OutDrugRatio")

	/*
	//科室	实施病种名称	期内出院病人总数	病种出院人数	期内入径标记人数	期内完成路径人数	期内出径标记人数	入径病人平均住院日	出径病人平均住院日	完成路径病人平均住院日	覆盖率%	入径率%	出径率%	完成率% 入径病人次均费用	入径病人药品费用所占比例(%)	完成路径病人次均费用	完成路径病人药品费用所占比例(%)	出径病人次均费用	出径病人药品费用所占比例(%)
	Set Data=$lb(LocDesc,CPWDesc,DischNum,CPWDischNum,InCPWNum,CloseCPWNum,OutCPWNum,InDays,OutDays,CloseDays,CPWRatio,InRatio,OutRatio,CloseRatio,InCost,InDrugRatio,CloseCost,CloseDrugRatio,OutCost,OutDrugRatio)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	*/
	Kill ^CacheTemp($zn,repid,"CPWDischStat")
	Quit $$$OK
BuildData(repid,index,MRCPWId,objMRCPW,AdmInfo,Paadm,DischDate)
	n (repid,index,MRCPWId,objMRCPW,AdmInfo,Paadm,DischDate)
	set f=$$CheckStepAndSyndrome(repid,index,MRCPWId)
	//w !," f=",f
	//判断步骤和并发症
	quit:f'=1 0
	set ^CacheTemp($zn,repid,index,MRCPWId)=""  //准备明细数据
	set num=$i(^CacheTemp($zn,repid,"CPWDischStat",index,"InCPWNum"))  //入径人数
	if objMRCPW.CPWStatus="O" {
		set num=$i(^CacheTemp($zn,repid,"CPWDischStat",index,"OutCPWNum"))  //出径人数
	}
	else{
		set num=$i(^CacheTemp($zn,repid,"CPWDischStat",index,"CloseCPWNum"))  //完成人数
		set Days=DischDate-$p(AdmInfo,"^",6)+1
		set ^CacheTemp($zn,repid,"CPWDischStat",index,"InDays_Count")=$g(^CacheTemp($zn,repid,"CPWDischStat",index,"InDays_Count"))+Days  //总住院日
		set Fee=##class(web.DHCCPW.MR.Interface).GetAdmCateFee(Paadm)
		set Cost=+$p(Fee,"^",1)
		set CostDrug=+$p(Fee,"^",2)
		set ^CacheTemp($zn,repid,"CPWDischStat",index,"CloseCost_Count")=$g(^CacheTemp($zn,repid,"CPWDischStat",index,"CloseCost_Count"))+Cost  //总费用
		set ^CacheTemp($zn,repid,"CPWDischStat",index,"InDrug_Count")=$g(^CacheTemp($zn,repid,"CPWDischStat",index,"InDrug_Count"))+CostDrug  //总药费
		
	}
	//{%%PARENT}("VAR")
	if $d(^DHCMR("CPW",MRCPWId,"VAR")){
		set num=$i(^CacheTemp($zn,repid,"CPWDischStat",index,"VarianceCount"))  //变异人数
	}
	quit 1
CheckStepAndSyndrome(repid,index,MRCPWId)
	n (repid,index,MRCPWId)
	set StepTypeList=$g(^CacheTemp($zn,repid,"CPWDischStat",index,"StepTypeList"))
	set SyndromeDicList=$g(^CacheTemp($zn,repid,"CPWDischStat",index,"SyndromeDicList"))
	quit:(StepTypeList="")&(SyndromeDicList="") 1
	set ret1=0,ret2=0
	
	//{%%PARENT}("EST")
	set estSub=$o(^DHCMR("CPW",MRCPWId,"EST",""),-1)
	quit:estSub="" ret1
	set StepCodes="^",StepSyndromeDics="^"
	set estId=MRCPWId_"||"_estSub
	set objEST=##class(User.DHCMRClinicalPathWayEstimate).%OpenId(estId)
	//set StepCodes=StepCodes_objEST.CPWEEpStepDR.CPWSStepTypeCode_"^"
	set stepCount=objEST.CPWETimes.Count()
	for i=1:1:stepCount {
		set objEstTimes=objEST.CPWETimes.GetAt(i)
		set StepCodes=StepCodes_objEstTimes.EstEpStepDR.CPWSStepTypeCode_"^"
		set SyndromeCount=objEstTimes.CPWCompStepList.Count()
		if SyndromeCount>0 {
			for SyndromeIndex=1:1:SyndromeCount {
				set SyndromeId=+objEstTimes.CPWCompStepList.GetAt(SyndromeIndex)
				set objSyndrome=..GetObjById(SyndromeId)
				Continue:objSyndrome=""
				set SyndromeDicId=objSyndrome.CPWCPWDicDR.%Id()
				set StepSyndromeDics=StepSyndromeDics_SyndromeDicId_"^"     //并发症字典Id
			}
		}
	}
	if StepTypeList'="" {
		set ret1=1
		set stepTypeCode=0
		for {
			set stepTypeCode=$o(^CacheTemp($zn,repid,"CPWDischStat",index,"StepTypeList",stepTypeCode))
			quit:stepTypeCode=""
			set:StepCodes'[("^"_stepTypeCode_"^") ret1=0   //该患者步骤中不包含指定步骤类型
			quit:ret1=0
		}
	}
	else{set ret1=1}
	//w " StepTypeList=",StepTypeList," StepCodes=",StepCodes
	quit:ret1=0 ret1
	
	if SyndromeDicList'="" {                //并发症路径字典Id列表
		set ret2=1
		set SyndromeDicId=0
		for {
			set SyndromeDicId=$o(^CacheTemp($zn,repid,"CPWDischStat",index,"SyndromeDicList",SyndromeDicId))
			quit:SyndromeDicId=""
			set:StepSyndromeDics'[("^"_SyndromeDicId_"^") ret2=0
			quit:ret2=0
		}
	}
	else{set ret2=1}
	
	quit ret1&ret2
}

ClassMethod QryCPWDischStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWDischStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWDischStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWDischStatExecute ]
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

/// 描述:     保存统计主题
/// 编写者：  wuqk
/// 编写日期：2011-11-08 
/// 表名:     User.DHCMRCOffShootStatTitle
///           User.DHCMRCOffShootStatItem
/// 入参：    TitleId,Title,Items(split by $c(1))
/// 返回：    <0 失败； >0 TitleId
/// d ##Class(web.DHCCPW.MR.BranchAnalysis).SaveTitle()
ClassMethod SaveTitle(id, Title, Items)
{
	new (id,Title,Items)
	set ret=-1
	//tstart
	if id=""{
		set objTitle=##class(User.DHCMRCOffShootStatTitle).%New()
		set objTitle.Title=Title
	}
	else{
		set objTitle=##class(User.DHCMRCOffShootStatTitle).%OpenId(id)
		set count=objTitle.Items.Count()
		for index=1:1:count {
			do objTitle.Items.RemoveAt(index)
		}
		
	}
	//if objTitle="" do trollback
	quit:objTitle="" ret
	set length=$l(Items,$c(1))
	for index=1:1:length {
		set Item=$p(Items,$c(1),index)
		continue:Item=""
		set objItem=##class(User.DHCMRCOffShootStatItem).%New()
		set objItem.CPWDicId=$p(Item,"|",1)
		set objItem.StepTypeList=$p(Item,"|",2)
		set objItem.SyndromeDicList=$p(Item,"|",3)
		set objItem.ItemDesc=$p(Item,"|",4)
		do objTitle.Items.Insert(objItem)
		set objItem=""
	}
	Set sc=objTitle.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		Set err=$System.Status.GetErrorText(sc)
   		Set ret=-2_" "_err
	} Else {
		Set ret=objTitle.%Id()
	}
	Do objTitle.%Close()
	quit ret
}

Query QueryOffShootStatTitle() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID as Rowid ,Title FROM SQLUser.DHCMRCOffShootStatTitle
}

/// 描述:     查询统计主题明细
/// 编写者：  wuqk
/// 编写日期：2011-11-09 
/// 表名:     User.DHCMRCOffShootStatTitle
///           User.DHCMRCOffShootStatItem
/// 入参：    TitleId
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.BranchAnalysis","QueryItemsByTitle",1)
Query QueryItemsByTitle(TitleId As %String) As %Query(ROWSPEC = "Index:%String,ItemDesc:%String,Key:%String,checked:%String")
{
}

ClassMethod QueryItemsByTitleExecute(ByRef qHandle As %Binary, TitleId As %String) As %Status
{
	new (qHandle,TitleId)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	set objTitle=##class(User.DHCMRCOffShootStatTitle).%OpenId(TitleId)
	quit:objTitle="" $$$OK
	set count=objTitle.Items.Count()
	for index=1:1:count {
		set objItem=objTitle.Items.GetAt(index)
		set Key=objItem.CPWDicId_"|"_objItem.StepTypeList_"|"_objItem.SyndromeDicList
		set ^CacheTemp(repid,ind)=$lb(index,objItem.ItemDesc,Key,1)
		set objItem=""
		set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryItemsByTitleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemsByTitleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryItemsByTitleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemsByTitleExecute ]
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

}

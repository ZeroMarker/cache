Class web.DHCWLTJSGHQuery Extends %RegisteredObject
{

/// Creator?      cy
/// CreatDate?    2019-07
/// description:  服务半径统计人数
/// Table?        CT_LOC 
/// Input?        
/// Output?       
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSGHQuery","QueryServiceRadiusNum","2019-02-01","2019-03-01","","") 
Query QueryServiceRadiusNum(startDate As %String, endDate As %String, hosId As %String = "", depId As %Text = "", sessId As %String = "") As %Query(ROWSPEC = "locDesc,provinceDesc,cityAreaDesc,regNum:%Float") [ SqlProc ]
{
}

ClassMethod QueryServiceRadiusNumExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String = "", depId As %Text = "", sessId As %String = "") As %Status
{
	K ^||TEMPDHCWL($j)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	
 	//将入参字符串改成数组\
 	k hosArr
 	d ##class(web.DHCWLTJSCommonFunction).ToArrayFromString(hosId,",",.hosArr) 
 	k depArr
 	d ##class(web.DHCWLTJSCommonFunction).ToArrayFromString(depId,",",.depArr)
 	k sessArr 
 	d ##class(web.DHCWLTJSCommonFunction).ToArrayFromString(sessId,",",.sessArr)
 
	s sDate=$zdh(startDate,3),eDate=$zdh(endDate,3)
   f lDate=sDate:1:eDate  d
   .s wrId=""  f  s wrId=$o(^DHCWorkRegReport(0,"ADMDATE",lDate,wrId))  q:wrId=""  d
   ..s admId=$p($g(^DHCWorkRegReport(wrId)),"^",15)         
   ..q:admId=""
	..s admType=$p($g(^PAADM(admId)),"^",2)  
	..q:'((admType="O")||(admType="E"))||($g(admType)="")    //过滤掉非门诊和急诊的就诊记录
	..s regNum=$p($g(^DHCWorkRegReport(wrId)),"^",29)
	..s locDr=$p($g(^DHCWorkRegReport(wrId)),"^",5)          //所挂科室
	..i locDr="" s locDr=999999
	..s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(locDr)
	..q:('$d(hosArr(hosDr)))&&(hosId'="")
	..q:('$d(depArr(locDr)))&&(depId'="")
	..s sessDr=$p($g(^DHCWorkRegReport(wrId)),"^",34)
	..i +$g(sessDr)=0   s sessDr=999999                       //出诊级别
	..q:('$d(sessArr(sessDr)))&&(sessId'="")
	..;s locDesc=$$GetDepDesc^DHCWLCommon(locDr)
	..s serviceRadius=##class(web.DHCWLStatisticsInterface).GetserviceRadius(admId)	 
	..s provinceDesc=$p(serviceRadius,"^",1) //省
	..s cityAreaDesc=$p(serviceRadius,"^",2) //市
	..s ^||TEMPDHCWL($j,"DATA",locDr,provinceDesc,cityAreaDesc)=$g(^||TEMPDHCWL($j,"DATA",locDr,provinceDesc,cityAreaDesc))+regNum
	
	//output
	s locDr=""
	f  s locDr=$o(^||TEMPDHCWL($j,"DATA",locDr)) q:locDr=""  d
	.s locDesc=$$GetDepDesc^DHCWLCommon(locDr)
	.s provinceDesc=""
	.f  s provinceDesc=$o(^||TEMPDHCWL($j,"DATA",locDr,provinceDesc)) q:provinceDesc=""  d
	..s cityAreaDesc="" f  s cityAreaDesc=$o(^||TEMPDHCWL($j,"DATA",locDr,provinceDesc,cityAreaDesc)) q:cityAreaDesc=""  d 
	...s regNum=+$g(^||TEMPDHCWL($j,"DATA",locDr,provinceDesc,cityAreaDesc))
	...d outputRowserviceRadius
	
	K ^||TEMPDHCWL($j)
	Quit $$$OK
	
outputRowserviceRadius
 s row=$listbuild(locDesc,provinceDesc,cityAreaDesc,regNum)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod QueryServiceRadiusNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryServiceRadiusNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod QueryServiceRadiusNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryServiceRadiusNumExecute ]
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

/// Creator?      cy
/// CreatDate?    2019-07
/// description:  退号信息
/// Table?        CT_LOC 
/// Input?        
/// Output?       
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSGHQuery","QueryCancelRegPatInfo","2019-02-01","2019-03-01","","","1") 
Query QueryCancelRegPatInfo(startDate As %String, endDate As %String, hosId As %String, depId As %Text, docId As %Text, regNo As %Text = "") As %Query(ROWSPEC = "patNo,name,sex,age,admReason,locDesc,docDesc,frDesc,total:%Float,cancelTotal:%Float,cancelReason,cancelDate") [ SqlProc ]
{
}

ClassMethod QueryCancelRegPatInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, depId As %Text, docId As %Text, regNo As %Text = "") As %Status
{
		
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	
 	//将入参字符串改成数组
 	k hosArr
 	d ##class(web.DHCWLTJSCommonFunction).ToArrayFromString(hosId,",",.hosArr) 
 	k depArr
 	d ##class(web.DHCWLTJSCommonFunction).ToArrayFromString(depId,",",.depArr) 
 	k docArr
 	d ##class(web.DHCWLTJSCommonFunction).ToArrayFromString(docId,",",.docArr) 
 	
	s sDate=$zdh(startDate,3),eDate=$zdh(endDate,3)
   f lDate=sDate:1:eDate  d
   .s wrId=""  f  s wrId=$o(^DHCWorkRegReport(0,"ADMDATE",lDate,wrId))  q:wrId=""  d
   ..s admId=$p($g(^DHCWorkRegReport(wrId)),"^",15)         
   ..q:admId=""
	..s admType=$p($g(^PAADM(admId)),"^",2)  
	..q:'((admType="O")||(admType="E"))||($g(admType)="")    //过滤掉非门诊和急诊的就诊记录
	..s regNum=$p($g(^DHCWorkRegReport(wrId)),"^",29)
	..q:regNum=1   //1是挂号， -1是退号；只统计退号信息
	..s frFlag=$p($g(^PAADM(admId)),"^",72)    //出诊复诊标记
	..s frDesc=$case(frFlag,"R":"复诊","F":"初诊",:"")
	..s patId=$p($g(^PAADM(admId)),"^",1) 
    ..s name=$$GetPapmiName^DHCWLCommon(patId)
    ..s patNo=$$GetPapmiNo^DHCWLCommon(patId)
    ..q:(patNo'[regNo)&&(regNo'="") 
    ..s sex=$$GetSex^DHCWLCommon(patId)
    ..s age=##class(web.DHCBillInterface).GetPapmiAge(patId,admId)
    ..s admReason=$$GetReason^DHCWLCommon(admId)
	..s locDr=$p($g(^DHCWorkRegReport(wrId)),"^",5)          //所挂科室
	..i locDr="" s locDr=999999
	..s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(locDr)
	..q:('$d(hosArr(hosDr)))&&(hosId'="")
	..q:('$d(depArr(locDr)))&&(depId'="")
	..s locDesc=$$GetDepDesc^DHCWLCommon(locDr)	                             
	..s docDr=$p($g(^DHCWorkRegReport(wrId)),"^",6)           //所挂医生
	..i docDr="" s docDr=999999	
	..q:('$d(docArr(docDr)))&&(docId'="")
	..s docDesc=$$GetPatDoc^DHCWLCommon(docDr)	
	..s numStr=##class(web.DHCWLTJSCommonFunction).GetRegNumByAdm(admId)
	..s total=$p(numStr,"^",1)  //挂号总次数，不包括退号的
	..s cancelTotal=$p(numStr,"^",2)   //退号总次数
	..s cancelReason=""       //退号原因
	..s cancelDate=$zd(lDate,3)
	..d outputRowCancelRegInfo
	 
	Quit $$$OK
	
outputRowCancelRegInfo
 s row=$listbuild(patNo,name,sex,age,admReason,locDesc,docDesc,frDesc,total,cancelTotal,cancelReason,cancelDate)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod QueryCancelRegPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCancelRegPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod QueryCancelRegPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCancelRegPatInfoExecute ]
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

/// Creator?      czx
/// CreatDate?    2017-12
/// description:  取得门诊科室明细(科室查询条件用)，通过BS代码维护获取
/// Table?        CT_LOC 
/// Input?        
/// Output?       depId:科室id,depDesc:科室描述
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSGHQuery","GetRegDetails","2019-09-01","2019-09-01","","","") 
Query GetRegDetails(startDate As %String, endDate As %String, fOrRFlag As %String = "", hosId As %String = "", sessId As %String = "") As %Query(ROWSPEC = "invNo,sessDesc,name,patNo,admReason,locDesc,docDesc,regPrice,regDate,cancelDate,uerName,mainDiag,flag,frDesc:%String") [ SqlProc ]
{
}

ClassMethod GetRegDetailsExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, fOrRFlag As %String = "", hosId As %String = "", sessId As %String = "") As %Status
{
		
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
	
 	k ^TEMPDHCWL($j)
 	k frArr
 	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(fOrRFlag,",",.frArr) 
 	k hosArr
 	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(hosId,",",.hosArr) 
 	k sessArr
 	s flag=##class(web.DHCWLTJSCommonFunction).ToArrayFromString(sessId,",",.sessArr) 
 	
	s sDate=$zdh(startDate,3),eDate=$zdh(endDate,3)
   f lDate=sDate:1:eDate  d
   .s wrId=""  f  s wrId=$o(^DHCWorkRegReport(0,"ADMDATE",lDate,wrId))  q:wrId=""  d
   ..s admId=$p($g(^DHCWorkRegReport(wrId)),"^",15)         
   ..q:admId=""
	..s admType=$p($g(^PAADM(admId)),"^",2)  
	..q:'((admType="O")||(admType="E"))||($g(admType)="")    //过滤掉非门诊和急诊的就诊记录
	..s invNo=$p($g(^DHCWorkRegReport(wrId)),"^",19)         //发票号
	..s sessDr=$p($g(^DHCWorkRegReport(wrId)),"^",34)
	..i +$g(sessDr)=0   s sessDr=999999 
	..q:('$d(sessArr(sessDr)))&&($g(sessId)'="")
	..i $d(^RBC("SESS",sessDr)) s sessDesc=$p(^RBC("SESS",sessDr),"^",2)                     //出诊级别 
	..e  s sessDesc=""
	..s patId=$p($g(^PAADM(admId)),"^",1) 
    ..s name=$$GetPapmiName^DHCWLCommon(patId)
    ..s patNo=$$GetPapmiNo^DHCWLCommon(patId)
    ..s admReason=$$GetReason^DHCWLCommon(admId)
	..s locDr=$p($g(^DHCWorkRegReport(wrId)),"^",5)          //所挂科室
	..i locDr="" s locDr=999999
	..s locDesc=$$GetDepDesc^DHCWLCommon(locDr)	
	..s hosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(locDr)
	..q:('$d(hosArr(hosDr)))&&($g(hosId)'="")                           
	..s docDr=$p($g(^DHCWorkRegReport(wrId)),"^",6)           //所挂医生
	..i docDr="" s docDr=999999	
	..s docDesc=$$GetPatDoc^DHCWLCommon(docDr)	
	..s regPrice=$p($g(^DHCWorkRegReport(wrId)),"^",8)         //挂号费
	..s admDate=$p($g(^DHCWorkRegReport(wrId)),"^",4)
	..s regUser=$p($g(^DHCWorkRegReport(wrId)),"^",17)
	..i regUser="" s regUser=999999
	..i $d(^SSU("SSUSR",regUser)) s uerName=$p(^SSU("SSUSR",regUser),"^",2)
	..s mainDiag=##class(web.DHCWLStatisticsInterface).GetDiagByAdm(admId,"")
	..s mainDiag=$p(mainDiag,"^",1)
	..i (mainDiag="Null") s mainDiag=""
	..s regNum=$p($g(^DHCWorkRegReport(wrId)),"^",29)
	..s cancelDate="",regDate=""
	..i regNum=1 s flag="挂号",regDate=admDate
	..i regNum=-1 s flag="退号",cancelDate=admDate
	..i regDate'="" s regDate=$zd(regDate,3)
	..i cancelDate'="" s cancelDate=$zd(cancelDate,3)
	..s fOrR=$P(^PAADM(admId),"^",72)
	..i fOrR="" s fOrR="F"  //如果为空,默认为初诊
	..q:('$d(frArr(fOrR)))&&($g(fOrRFlag)'="") 
	..s frDesc=$case(fOrR,"F":"初诊",:"复诊")
	..d outputRow1
	 
   
    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRow1
 s row=$listbuild(invNo,sessDesc,name,patNo,admReason,locDesc,docDesc,regPrice,regDate,cancelDate,uerName,mainDiag,flag,frDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
 
 
GetFriDisDiagnos(admId)
 //通过PA_Adm.PAADM_RowID获得主诊断
 q:$g(admId)="" "Null"
 q:'$d(^PAADM(admId)) "Null"
 s admMainDR=$p(^PAADM(admId),"^",61)
 q:$g(admMainDR)="" "Null"
 q:'$d(^MR(admMainDR,"DIA")) "Null"
 s docId=""
 s mrdiaSub=0 f  s mrdiaSub=$o(^MR(admMainDR,"DIA",mrdiaSub)) q:(mrdiaSub="")!($g(mrcidDesc)'="")  d
 .s mrdiaIcdCode=$p(^MR(admMainDR,"DIA",mrdiaSub),"^")
 .s docId=$p(^MR(admMainDR,"DIA",mrdiaSub),"^",4)
 .s reMark=$g(^MR(admMainDR,"DIA",mrdiaSub,"DES",1))
 .s mainFlag=$p(^MR(admMainDR,"DIA",mrdiaSub,1),"^",20)
 .q:mainFlag'="Y" //Y代表主诊断
 .i mrdiaIcdCode'=""  d
 ..i $d(^MRC("ID",mrdiaIcdCode))  d
 ...s mrcidDesc=$p($g(^MRC("ID",mrdiaIcdCode)),"^",2)
 ...s mrcidCode=$p($g(^MRC("ID",mrdiaIcdCode)),"^",4)
 ...i reMark'="" s mrcidDesc=mrcidDesc_"*"_reMark
 .e  i reMark'="" s mrcidDesc="*"_reMark s mrcidCode=""
 q $g(mrcidDesc)_"^"_$g(mrcidCode)
}

ClassMethod GetRegDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetRegDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegDetailsExecute ]
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

/// Creator?      yw
/// CreatDate?    2016-01
/// description:  取得门诊预约挂号明细
/// Table?        RB_Resource,RB_Appointment,RB_ApptSchedule
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?       patName:姓名,sexDesc:年龄,paperId:身份证,patTel:电话,aptmDesc:预约方式,locId:%String,
/// /              depDesc:科室描述,docId:%String,docDesc:医生描述,appDateTime:预约时间,mQueueNo:预约序号                  
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSGHQuery","GetAppRegDet","2020-07-01","2020-07-28","")
Query GetAppRegDet(startDate As %String, endDate As %String, dep As %Text, hosId As %String) As %Query(ROWSPEC = "patName:%String,sexDesc:%String,paperId:%String,patTel:%String,aptmDesc:%String,locId:%String,depDesc:%String,docId:%String,docDesc:%String,appDateTime:%String,mQueueNo:%String") [ SqlProc ]
{
}

ClassMethod GetAppRegDetExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dep As %Text, hosId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	
    //k ^TEMPDHCWL($j)
	q:startDate="" $$$OK
	q:endDate="" $$$OK	
	
	s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
    
    /*
	f ordDate=startDate:1:endDate  d
 	.s res=0 f  s res=$o(^RB("RES",res)) q:res=""  d
 	..s locId=$p(^RB("RES",res),"^",1)
 	..s:locId="" locId="9999"
 	..q:(dep'="")&&($Find(","_dep_",",","_locId_",")=0)
 	..s docId=$p(^RB("RES",res),"^",2)
 	..s sub=0 f  s sub=$o(^RBAS(res,sub)) q:sub=""  d  //edit by czx in 2018-02-24
 	...s asDat=$P($G(^RBAS(res,sub)),"^",1)
 	...q:asDat'=ordDate
 	...s sessTypeDr=$p(^RBAS(res,sub,"DHC"),"^",6) q:sessTypeDr=""
 	*/
    
	f date=startDate:1:endDate  d
 	.s res="" f  s res=$o(^RBAS("APPT_Date",res)) q:res=""  d
 	..q:'$d(^RB("RES",res))
 	..s locId=$p(^RB("RES",res),"^",1)
 	..s:locId="" locId=999999
 	..s hosDr=$p(^CTLOC(locId),"^",22)
 	..q:(hosId'="")&&($Find(","_hosId_",",","_hosDr_",")=0)
 	..q:(dep'="")&&($Find(","_dep_",",","_locId_",")=0)
 	..s docId=$p(^RB("RES",res),"^",2)
 	..i docId="" s docId=999999
 	..s dateTime="" f  s dateTime=$o(^RBAS("APPT_Date",res,date,dateTime)) q:dateTime=""  d
 	...s sub="" f  s sub=$o(^RBAS("APPT_Date",res,date,dateTime,sub)) q:sub=""  d
 	....s sessTypeDr=$p(^RBAS(res,sub,"DHC"),"^",6) q:sessTypeDr=""
 	....s childsub="" f  s childsub=$o(^RBAS("APPT_Date",res,date,dateTime,sub,childsub)) q:childsub=""  d
 	.....q:$g(^RBAS(res,sub,"APPT",childsub))=""  //垃圾数据
 	.....s mStatus=$p($g(^RBAS(res,sub,"APPT",childsub)),"^",3)         ;预约状态
 	.....q:(mStatus="X")!(mStatus="J")  ;//取消和违约的不统计
 	.....s mMethod=$p(^RBAS(res,sub,"APPT",childsub),"^",12)        ;预约方式
 	.....s admId=$p($g(^RBAS(res,sub,"APPT",childsub)),"^",4)
 	.....q:admId=""  //垃圾数据？
 	.....;s aptmDesc=$$GetAppMethod^DHCWLTJSCommon(admId)
 	.....s aptmDesc=$p(^RBC("APTM",mMethod),"^",2)
 	.....s mQueueNo=$p(^RBAS(res,sub,"APPT",childsub),"^",5)        ;预约序号
 	.....s transDate=$p(^RBAS(res,sub,"APPT",childsub),"^",8)       ;预约日期
 	.....s transTime=$p(^RBAS(res,sub,"APPT",childsub),"^",9)      
 	.....s appDateTime=$zd(transDate,3)_" "_$zt(transTime,1)        ;预预约日期时间
 	.....q:(mMethod="")&&(mStatus="")
	.....s papmi=$p(^PAADM(admId),"^",1)
	.....s patName=$$GetPapmiName^DHCWLCommon(papmi)                 ;姓名
    .....s sexDesc=$$GetSex^DHCWLCommon(papmi)                       ;性别
	.....s paperId=$P(^PAPER(papmi,"ALL"),"^",9)                     ;身份证号
	.....s patTel=$P(^PAPER(papmi,"PER",1),"^",11)                   ;电话
	.....s depDesc=$$GetDepDesc^DHCWLCommon(locId)                   ;科室
	.....s docDesc=$$GetPatDoc^DHCWLCommon(docId)                  ;医生
	.....d OutputRow2

    //k ^TEMPDHCWL($j)
 Quit $$$OK
	
OutputRow2
    
    s data=$lb(patName,sexDesc,paperId,patTel,aptmDesc,locId,depDesc,docId,docDesc,appDateTime,mQueueNo)
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
}

ClassMethod GetAppRegDetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppRegDetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAppRegDetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppRegDetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// Creator?      chenyi
/// CreatDate?    2023-01-29
/// description:  取得门诊预约渠道统计
/// Table?        RB_Appointment
/// Input?        startDate(开始日期),endDate(结束日期)               
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSGHQuery","GetAppAT","2023-02-01","2023-02-15","","","appDate")
Query GetAppAT(startDate As %String, endDate As %String, dep As %Text, hosId As %String, dateType As %String) As %Query(ROWSPEC = "depDesc:%String,appATDesc:%String,num:%Float") [ SqlProc ]
{
}

ClassMethod GetAppATExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dep As %Text, hosId As %String, dateType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	
    k ^||TEMPDHCWL($j)
	q:startDate="" $$$OK
	q:endDate="" $$$OK	
	
	s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
   
   	i dateType="appDate" d
	.f date=startDate:1:endDate  d
 	..s res="" f  s res=$o(^RBAS("APPT_Date",res)) q:res=""  d
 	...q:'$d(^RB("RES",res))
 	...s locId=$p(^RB("RES",res),"^",1)
 	...s:locId="" locId=999999
 	...s hosDr=$p(^CTLOC(locId),"^",22)
 	...q:(hosId'="")&&($Find(","_hosId_",",","_hosDr_",")=0)
 	...q:(dep'="")&&($Find(","_dep_",",","_locId_",")=0)
 	...s docId=$p(^RB("RES",res),"^",2)
 	...i docId="" s docId=999999
 	...s dateTime="" f  s dateTime=$o(^RBAS("APPT_Date",res,date,dateTime)) q:dateTime=""  d
 	....s sub="" f  s sub=$o(^RBAS("APPT_Date",res,date,dateTime,sub)) q:sub=""  d
 	.....s sessTypeDr=$p(^RBAS(res,sub,"DHC"),"^",6) 
 	.....q:sessTypeDr=""
 	.....s childsub="" f  s childsub=$o(^RBAS("APPT_Date",res,date,dateTime,sub,childsub)) q:childsub=""  d
 	......q:$g(^RBAS(res,sub,"APPT",childsub))=""  //垃圾数据
 	......s mStatus=$p($g(^RBAS(res,sub,"APPT",childsub)),"^",3)         ;预约状态
 	......q:(mStatus="X")!(mStatus="J")  ;//取消和违约的不统计
 	......;s mMethod=$p(^RBAS(res,sub,"APPT",childsub),"^",12)        ;预约方式
 	......s appATDr=$p($g(^RBAS(res,sub,"APPT",childsub)),"^",1)		;预约渠道统计
 	......q:appATDr=""  //以前的项目这个字段未使用，应该都是空。只有8.5.3之后的项目才有 SELECT TOP 100 APPT_AT_DR,* FROM RB_Appointment WHERE APPT_DateComp='2022-01-17'   //预约渠道字段
 	......s admId=$p($g(^RBAS(res,sub,"APPT",childsub)),"^",4)
 	......q:admId=""  //垃圾数据？
 	......s nod=locId_","_appATDr
 	......s ^||TEMPDHCWL($j,nod,"NUM")=$g(^||TEMPDHCWL($j,nod,"NUM"))+1
 	e  d
 	.f mDate=startDate:1:endDate  d
    ..s wrId=""  f  s wrId=$o(^DHCWorkRegReport(0,"ADMDATE",mDate,wrId))  q:wrId=""  d
    ...s admId=$p($g(^DHCWorkRegReport(wrId)),"^",15)         
    ...q:admId=""
	...s admType=$p($g(^PAADM(admId)),"^",2)  
	...q:'((admType="O")||(admType="E"))||($g(admType)="")    //过滤掉非门诊和急诊的就诊记录
	...s locId=$p($g(^DHCWorkRegReport(wrId)),"^",5)          //所挂科室  
	...s hosDr=$p(^CTLOC(locId),"^",22)
	...q:(hosId'="")&&($Find(","_hosId_",",","_hosDr_",")=0)
 	...q:(dep'="")&&($Find(","_dep_",",","_locId_",")=0)        
	...s appATDr=$$GetAppType(admId)         //挂号渠道  //以前的项目这个字段未使用，应该都是空。只有8.5.3之后的项目才有 SELECT TOP 100 APPT_AT_DR,* FROM RB_Appointment WHERE APPT_DateComp='2022-01-17'   //预约渠道字段
	...q:(appATDr="")||(appATDr="999")
 	...s nod=locId_","_appATDr
 	...s ^||TEMPDHCWL($j,nod,"NUM")=$g(^||TEMPDHCWL($j,nod,"NUM"))+1
 		
 	s nod=""
 	f  s nod=$o(^||TEMPDHCWL($j,nod)) q:nod=""  d
 	.s depDr=$p(nod,",",1)
 	.s appATDr=$p(nod,",",2)
 	.s depDesc=$p(^CTLOC(depDr),"^",2)
 	.s appATDesc=$p(^RBC("AT",appATDr),"^",2)
 	.s num=$g(^||TEMPDHCWL($j,nod,"NUM"))
	.d OutputRow2

    k ^||TEMPDHCWL($j)
 	Quit $$$OK
	
OutputRow2
    s data=$lb(depDesc,appATDesc,num)
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
 	
 	///Desc:取预约渠道
GetAppType(admId)
 s return=""
 i '$d(^RBAS("ADM",admId)) d
 .s return=999  ;普通挂号
 e  d
 .s res=0 f  s res=$o(^RBAS("ADM",admId,res)) q:res=""  d
 ..s sub=0 f  s sub=$o(^RBAS("ADM",admId,res,sub)) q:sub=""  d 
 ...s subChd=0 f  s subChd=$o(^RBAS("ADM",admId,res,sub,subChd)) q:subChd=""  d 
 ....s return=$p(^RBAS(res,sub,"APPT",subChd),"^",1) ;预约挂号方式
 q return
}

ClassMethod GetAppATClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppATExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAppATFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppATExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

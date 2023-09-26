/// Creator:wangCS
/// CreateDate:2011-08-02
/// Description:死亡编号管理
Class DHCMed.DTHService.RepNoSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator     : zhufei
/// CreateDate  : 2014-04-01
/// Description : 获取新的死亡证明编号
/// Input       : aHospitalID 医院ID
/// Output      : 新的死亡证明编号
/// w ##Class(DHCMed.DTHService.RepNoSrv).GetNewDeathNo(2)
ClassMethod GetNewDeathNo(aHospitalID As %String, aDTHHospCode As %String = "") As %String
{
	new (aHospitalID,aDTHHospCode)
	set return=""
	
	set CurrYear=$p($zd($h,3),"-",1)
	if aDTHHospCode="" {
		set DTHHospCode=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("DTH-DeathRepHospCode",aHospitalID)
		quit:DTHHospCode="" return
	} else {
		set DTHHospCode=aDTHHospCode
	}
	quit:DTHHospCode="" return
	
	set IsGetDeathNoIO=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("DTH-GetDeathNoIO",aHospitalID)
	if IsGetDeathNoIO=1 {
		//友谊医院大门诊与干保楼两套系统，有统一的死亡证明编号，特殊处理
		s obj=##class(DHCMed.DTHCustom.RepNoWSSoap).%New()
		set return=obj.GetNewDeathNo(DTHHospCode)
		set num=+$p(return,"-",3)
		set:num>0 ^DHCMed.DTH("DTHNO"," "_DTHHospCode,CurrYear)=num
	} else {
		set num=$i(^DHCMed.DTH("DTHNO"," "_DTHHospCode,CurrYear))
		set $p(return,"0",5-$l(num))=num
		set return=DTHHospCode_"-"_CurrYear_"-"_return
	}
	
	quit return
}

/// Creator     : zhufei
/// CreateDate  : 2014-04-01
/// Description : 获取死亡证明编号分配方式
/// Input       : aHospitalID 医院ID
/// Output      : 死亡证明编号分配方式
/// w ##Class(DHCMed.DTHService.RepNoSrv).GetDeathNoType(0)
ClassMethod GetDeathNoType(aHospitalID As %String) As %String
{
	New (aHospitalID)
	set return=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("DTH-DeathNoType",aHospitalID)
	set return=+return
	Quit return
}

/// Creator:    wangCS
/// CreateDate: 2011-08-02
/// Description:生成死亡证明编号
/// Input:     startNo：开始编号
///            endNo：  结束编号
///            noType： 死亡证明编号类型
///            locRowId:科室Id
///            userRowId:用户Id
/// Output:生成死亡证明编号结果
/// w ##Class(DHCMed.DTHService.RepNoSrv).MakeReportNo("7^13^1^1^627","^")
ClassMethod MakeReportNo(instr As %String, separate As %String) As %String
{
	new (instr,separate)
	set retStr=""
	if ($g(separate)=""){
			set separate="^"
		}
	set startNo=$p($g(instr),separate,1)
	set endNo=$p($g(instr),separate,2)
	set noType=$p($g(instr),separate,3)     
	set locRowId=$p($g(instr),separate,4)
	set userRowId=$p($g(instr),separate,5)
	;set status=5    ;未出库
	set status=1    ;待用
	set isActive=1  ;1激活 0未激活
	;RowId^TypeDR^ReportNo^LocDR^DoctorDR^StatusDR^IsActive^Resume^UserId
	for startNo=startNo:1:endNo
	{
		set updateStr=separate_noType_separate_startNo_separate_locRowId_separate_separate_status_separate_isActive_separate_separate_userRowId
		set result=..ReportNoStorage(updateStr,separate)
		set retStr=retStr_"死亡证明书编号"_startNo_result_separate
	}
	quit retStr
}

ClassMethod ReportNoStorage(updateStr, separate) As %String
{
	    new (updateStr,separate)
	    ;^DHCMed.DTHi("REPNO","IndexReportNo"," 1",4)
        set resultStr="已存在"
	    set reportNo=" "_$ZCVT($p($g(updateStr),separate,3),"U")
	    
		quit:$d(^DHCMed.DTHi("REPNO","IndexReportNo",reportNo)) resultStr
	    set repNoRowId=##Class(DHCMed.DTH.RepNo).Update(updateStr,separate)
	    set:repNoRowId>0 resultStr="入库成功"
	    set:repNoRowId=-1 resultStr="入库失败"
	    quit resultStr
}

/// Creator:wangCS
/// CreateDate:2011-08-05
/// Desscripiton:批量修改死亡证明书编号的状态
/// Input: 
/// Output:修改结果
/// w ##Class(DHCMed.DTHService.RepNoSrv).BatchChangeStatus("")   
ClassMethod BatchChangeStatus(updateStr) As %String
{
	new (updateStr)
	set separate="^"
	set ret=""
	set count=$l(updateStr)
	for i=1:1:count 
	{
		set str=$p($g(updateStr),separate,i)
		set retVal=..ChangeReportNoStatus(str)
	}
	quit ret
}

/// Creator:wangCS
/// CreateDate:2011-08-02
/// Desscripiton:修改死亡证明书编号的状态
/// Input: updateStr:reportNo 证明书编号
///                 LocDR     科室ID
///                 DoctorDR  医生ID
///                 StatusDR  状态
///                 OpeUserDR 用户ID
/// Output:修改结果
/// w ##Class(DHCMed.DTHService.RepNoSrv).ChangeReportNoStatus("40001291620130067"_$c(1)_"6"_$c(1,1)_"2"_$c(1)_"105")               
ClassMethod ChangeReportNoStatus(updateStr) As %String
{
	new (updateStr)
	set separate=$c(1)
	set ret=""
	
	set reportNo=$p($g(updateStr),separate,1)
	set locRowId=$p($g(updateStr),separate,2)
	set docRowId=$p($g(updateStr),separate,3)
	set status=$p($g(updateStr),separate,4)
	set userId=$p($g(updateStr),separate,5)
	set reportNo=$ZCVT(reportNo,"U")
	set repNoRowId=$o(^DHCMed.DTHi("REPNO","IndexReportNo",reportNo,0))
	set obj=##Class(DHCMed.DTH.RepNo).GetObjById(+repNoRowId)
	quit:'$IsObject(obj) ret
	set obj.LocDR=locRowId
	set obj.DoctorDR=docRowId
	
	set statusDicId=##Class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(status,"DTHCurrencyState") 
	set statusDicObj=##Class(DHCMed.SS.Dictionary).GetObjById(+statusDicId)
	quit:'$IsObject(statusDicObj) ret
	set obj.StatusDR=statusDicObj
	set retVal=obj.%Save()
	if ($system.Status.IsError(retVal)){
		do $system.OBJ.DisplayError(retVal)
		set ret=-1
	}else{
		set ret=obj.%Id()
		//保存死亡证明编号状态表
		set repNoStatus=##Class(DHCMed.DTH.RepNoStatus).%New()
		set repNoStatus.StatusDR=statusDicObj
		set repNoStatus.OpeUserDR=userId
		set currDate=+$h
		set currTime=+$p($h,",",2)
		set repNoStatus.OpeDate=currDate
		set repNoStatus.OpeTime=currTime
		set repNoStatus.ParrefReportNo=obj
		set retVal=repNoStatus.%Save()
		if ($system.Status.IsError(retVal)){
			do $system.OBJ.DisplayError(retVal)
		}
		if repNoStatus'="" do repNoStatus.%Close()
	}
	if obj'="" do obj.%Close()
	
	quit ret
}

/// w ##Class(DHCMed.DTHService.RepNoSrv).BuidData("29")               
ClassMethod BuidData(repNoRowId As %String) As %String
{
	q:repNoRowId="" ""
	set repNoObj=##Class(DHCMed.DTH.RepNo).GetObjById(+repNoRowId)
	q:repNoObj=""
	set RowId=repNoObj.%Id()
	set Type=repNoObj.TypeDR.Description
	set ReportNo=repNoObj.ReportNo
	set locRowId=repNoObj.LocDR
	set locObj=##Class(DHCMed.Base.Ctloc).GetObjById(+locRowId)
	set Loc=locObj.Descs
	set doctId=repNoObj.DoctorDR
	set doctObj=##Class(DHCMed.Base.SSUser).GetObjById(+doctId)
	set Doctor=doctObj.Name
	set Status=repNoObj.StatusDR.Description
	set IsActive=$Case(repNoObj.IsActive,1:"是",0:"否")
	set Resume=repNoObj.Resume
	set repNoStatus=0
	set repNoStatus=$o(^DHCMed.DTH("REPNO",repNoRowId,"Status",repNoStatus))
	set StoraDateTime=""
	set StoraUser=""
	if (repNoStatus'=""){
		    set repNoStatusRowId=repNoRowId_"||"_repNoStatus
			set repNoStaObj=##Class(DHCMed.DTH.RepNoStatus).GetObjById(repNoStatusRowId)
			set storaDate=repNoStaObj.OpeDate
			;set storaDate=$zd($g(storaDate),3)
			set storaDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml($g(storaDate))
			set storaTime=repNoStaObj.OpeTime
			set storaTime=$zt($g(storaTime),1)
			set storaUserId=repNoStaObj.OpeUserDR
			set storaUserObj=##Class(DHCMed.Base.SSUser).GetObjById(+storaUserId)
			set StoraUser=storaUserObj.Name
    }
	set data=$lb(RowId,Type,ReportNo,Loc,Doctor,Status,IsActive,Resume,storaDate,storaTime,StoraUser)
	quit data
}

/// Creator:     wangCS
/// CreateDate:  2011-08-05
/// Description: 查询户籍类型对应未出库的死亡证明编号
/// Input:typeId:类型ID
/// Debug:       w ##Class(%ResultSet).RunQuery("DHCMed.DTHService.RepNoSrv","QryNoStorageReportNo",1481)
Query QryNoStorageReportNo(aRegionType As %String = "") As %Query(ROWSPEC = "RowId:%String,Type:%String,ReportNo:%String,Loc:%String,Doctor:%String,Status:%String,IsActive:%String,Resume:%String,storaDate:%String,storaTime:%String,StoraUser:%String")
{
}

ClassMethod QryNoStorageReportNoExecute(ByRef qHandle As %Binary, aRegionType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	;Quit:$g(aRegionType)="" $$$OK
 	set:aRegionType="" aRegionType=1
 	
 	
 	Set NoStatusID=##Class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(5,"DTHCurrencyState")
 	Set RegionTypeID=##Class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode($g(aRegionType),"DTHRegion")
 	Quit:(NoStatusID="")||(RegionTypeID="") $$$OK
 	
 	Set NoRowID=0
 	For {
	 	Set NoRowID=$o(^DHCMed.DTHi("REPNO","IndexTypeStatus",RegionTypeID,NoStatusID,NoRowID))
	 	Quit:NoRowID=""
	 	Set Data=..BuidData(NoRowID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=+ind+1
	}
 	
	Quit $$$OK
}

ClassMethod QryNoStorageReportNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNoStorageReportNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNoStorageReportNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNoStorageReportNoExecute ]
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

/// Creator:     liulan
/// CreateDate:  2013-04-02
/// Description:根据状态查询编号
/// Input:      LocID  状态
/// Output:     RowId^TypeDR^ReportNo^LocDR^DoctorDR^StatusDR^IsActive^Resume
/// Debug:      d ##Class(%ResultSet).RunQuery("DHCMed.DTHService.RepNoSrv","QryRepNobyLocID","","2")
Query QryRepNobyLocID(aLoc As %String = "", aHosp As %String = "") As %Query(ROWSPEC = "RowId:%String,Type:%String,ReportNo:%String,Loc:%String,Doctor:%String,Status:%String,IsActive:%String,Resume:%String,storaDate:%String,storaTime:%String,StoraUser:%String")
{
}

ClassMethod QryRepNobyLocIDExecute(ByRef qHandle As %Binary, aLoc As %String = "", aHosp As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	if (aLoc=""){
	 	for {
		 	Set aLoc = $o(^DHCMed.DTHi("REPNO","IndexLoc",aLoc))
		 	q:aLoc=""
		 	if aHosp'="" {
			 	Set tmpLoc=$tr(aLoc," ","")  
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(tmpLoc,aHosp)
				continue:flg<1
			}
		 	set repNoRowId=0
		 	for {
		 		set repNoRowId=$o(^DHCMed.DTHi("REPNO","IndexLoc",aLoc,repNoRowId))
		 		Q:repNoRowId=""
		 		Set ^CacheTemp("repNoRowId",repNoRowId)=repNoRowId
		 	}
		}
	} else {
		set repNoRowId=0
		while(repNoRowId'="")
		{
			set repNoRowId=$o(^DHCMed.DTHi("REPNO","IndexLoc"," "_aLoc,repNoRowId))
			q:repNoRowId=""
			Set ^CacheTemp("repNoRowId",repNoRowId)=repNoRowId
		    
		}
	}
	Set repNoRowId=""
	for {
		Set repNoRowId = $o(^CacheTemp("repNoRowId",repNoRowId),-1)
		Q:repNoRowId=""
		set data=..BuidData(repNoRowId)	
		set ^CacheTemp(repid,ind)=data
		set ind=+ind+1
	}
	k ^CacheTemp("repNoRowId")
	Quit $$$OK
}

ClassMethod QryRepNobyLocIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepNobyLocIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepNobyLocIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepNobyLocIDExecute ]
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

/// Creator:liulan
/// CreateDate:2013-10-24
/// Description:更新死亡证明编号
/// Debug: w ##Class(DHCMed.DTHService.RepNoSrv).SaveDTHRepNo("1^0067^1")
ClassMethod SaveDTHRepNo(Str) As %String
{
	new (Str)
	set LocDR=$p($g(Str),"^",1)        //科室
	set DoctorDR=$p($g(Str),"^",2)     //医护人员
	set IsActive=$p($g(Str),"^",3)     //是否有效
	set HospitalID=$p($g(^CTLOC(LocDR)),"^",22)
	set ReportNo=##Class(DHCMed.DTHService.RepNoSrv).GetNewDeathNo(HospitalID)
	set return=-1
	TSTART
	set RepNoobj=##Class(DHCMed.DTH.RepNo).%New()
	set RepNoobj.ReportNo=ReportNo
    set RepNoobj.LocDR=LocDR
	set RepNoobj.DoctorDR=DoctorDR
	set RepNoobj.IsActive=IsActive
	
	set retValue=RepNoobj.%Save()
	if ($system.Status.IsError(retValue))
	{
		do $system.OBJ.DisplayError(retValue)
		TROLLBACK
		set return=-2
	} Else {
		Set return=RepNoobj.%Id()
	}
		
	do:$IsObject(RepNoobj) RepNoobj.%Close()
	if (return>0){
		set RepNoobj=##Class(DHCMed.DTH.RepNo).%OpenId(return)
		set NoStatusObj=##Class(DHCMed.DTH.RepNoStatus).%New()
		set NoStatusObj.ParrefReportNo=RepNoobj
		set currDate=+$h
		set currTime=+$p($h,",",2)
		set NoStatusObj.OpeDate=currDate
		set NoStatusObj.OpeTime=currTime
		set NoStatusObj.OpeUserDR=DoctorDR
		
		set retValue=NoStatusObj.%Save()
		if ($system.Status.IsError(retValue)){
		    do $system.OBJ.DisplayError(retValue)
		    TROLLBACK
		    set return=-3
		    
	    } Else {
		    Set return=NoStatusObj.%Id()
		    TCOMMIT
	    }
		do:$IsObject(NoStatusObj) NoStatusObj.%Close()
		
    }
    quit return
}

}

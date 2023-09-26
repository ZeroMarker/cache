/// 名称:DHCMed.DTH.PaperNo
/// 描述: 死亡证明书纸单号主表
/// 编写者：yhb
/// 编写日期: 2014-06-19
Class DHCMed.DTHService.PaperNoSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ChangeOldPaperNoStatus(InputStr As %String, Separater As %String = "") As %String
{
	New (InputStr,Separater)
	Set ret=-1
	
	Quit:InputStr="" ret
	Set:Separater="" Separater="^"
	Set aReportID = $P(InputStr,Separater,1)
	Set aNoStatus = $P(InputStr,Separater,2)
	Set aOpeLocDR = $P(InputStr,Separater,3)
	Set aOpeUserDR = $P(InputStr,Separater,4)
	Quit:((aReportID="") || (aNoStatus="")) ret
	Set PaperNoID=""
	For {
		Set PaperNoID=$o(^DHCMed.DTH("PAPERNO",PaperNoID),-1)
		Quit:PaperNoID=""
		
		Set objPaperNo=##Class(DHCMed.DTH.PaperNo).%OpenId(PaperNoID)
		If ('$IsObject(objPaperNo)) {
			Continue
		} else {
			Set repId=""
			Set objRep =objPaperNo.RepObj
			If ($IsObject(objRep)) {
				Set repId=objRep.%Id()
			}	
			Continue:repId'=aReportID
			
			//**跟新报告的状态
			Set statusDicId=##Class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(aNoStatus,"DTHCurrencyState") 
			Set objNoStatus=##Class(DHCMed.SS.Dictionary).GetObjById(+statusDicId)
			Set objPaperNo.StatusDR=objNoStatus
			
			Set paperNoId=objPaperNo.%Save()
			if ($system.Status.IsError(paperNoId)){
				do $system.OBJ.DisplayError(paperNoId)
				set ret=-1
			}
			//**在对应的纸单号状态表里插入一条记录
			Set paperNoStatus=##Class(DHCMed.DTH.PaperNoStatus).%New()
			Set paperNoStatus.StatusDR = objNoStatus
			Set paperNoStatus.OpeDate = +$h
			Set paperNoStatus.OpeTime = $p($h,",",2)
			Set paperNoStatus.OpeLocDR = aOpeLocDR
			Set paperNoStatus.OpeUserDR = aOpeUserDR
			Set paperNoStatus.ParrefRaperNo = objPaperNo
			
			Set paperNoRowId=paperNoStatus.%Save()
			If ($system.Status.IsError(paperNoRowId)){
				Do $system.OBJ.DisplayError(paperNoRowId)
				Set ret=-1
			} else {
				Set ret=paperNoRowId
			}
			If objPaperNo'="" do objPaperNo.%Close()
			If paperNoStatus'="" do paperNoStatus.%Close()
		}
	}
	Quit ret
}

/// Creator:    yhb
/// CreateDate: 2014-06-19
/// Description:获取报告对应的纸单号
/// Input:     reportId：报告ID
/// Output:    报告对应的最后一个纸单号
/// w ##Class(DHCMed.DTHService.PaperNoSrv).GetPaperNo("1")
ClassMethod GetPaperNo(reportId As %String) As %String
{
	new (reportId)
	s PaperNo=""
	s StDate=""
	for {
		s StDate = $o(^DHCMed.DTHi("PAPERNO","IndexDTRepPaperNo",StDate),-1)
		q:StDate=""
		q:PaperNo'=""
		s StTime=""
		for {
			s StTime = $o(^DHCMed.DTHi("PAPERNO","IndexDTRepPaperNo",StDate,StTime),-1)
			q:StTime=""
			s PaperNo = $o(^DHCMed.DTHi("PAPERNO","IndexDTRepPaperNo",StDate,StTime,+reportId,""),-1)
			q:PaperNo'=""
		}
	}
	q PaperNo
}

/// Creator:    yhb
/// CreateDate: 2014-06-19
/// Description:是否生成新的纸单号
/// Input:     reportId：报告ID
/// Output:返回1生成新号，返回0不生成新号
/// w ##Class(DHCMed.DTHService.PaperNoSrv).CreatePaperNoFlag("1")
ClassMethod CreatePaperNoFlag(reportId As %String) As %String
{
	new (reportId)
	s PaperNo=##Class(DHCMed.DTHService.PaperNoSrv).GetPaperNo(reportId)
	if (PaperNo="") {
		q 1
	}
	s PaperNoID = $o(^DHCMed.DTHi("PAPERNO","IndexPaperNo",PaperNo,""))
	set obj=##Class(DHCMed.DTH.PaperNo).%OpenId(PaperNoID)
	s OneFlag=0
	s ThreeFlag=0
	if ($IsObject(obj)) {
		s OneFlag = +obj.OneFlag
		s ThreeFlag = +obj.ThreeFlag
	}
	if ((OneFlag=1)&&(ThreeFlag=1)) {
		q 1
	} elseif ((OneFlag=0)&&(ThreeFlag=1)) {
		q 1
	} elseif ((OneFlag=1)&&(ThreeFlag=0)) {
		q 0
	} else {
		q 0
	}
}

/// Creator:    yhb
/// CreateDate: 2014-06-19
/// Description:更新纸单号的打印状态
/// Input:     reportId：报告ID，OneThree：首联打印还是三联打印，YesFlag：首联或三联以打印
/// Output:返回ID更新成功，返回-1失败
/// w ##Class(DHCMed.DTHService.PaperNoSrv).UpdatePaperNo("1","1","1")
ClassMethod UpdatePaperNo(reportId As %String, OneThree As %String, YesFlag As %String) As %String
{
	new (reportId,OneThree,YesFlag)
	set return=-1
	s PaperNo=##Class(DHCMed.DTHService.PaperNoSrv).GetPaperNo(reportId)
	if (PaperNo="") {
		q return
	}
	s PaperNoID = $o(^DHCMed.DTHi("PAPERNO","IndexPaperNo",PaperNo,""))
	set obj=##Class(DHCMed.DTH.PaperNo).%OpenId(PaperNoID)
	if ($IsObject(obj)) {
		if (+OneThree=1) {
			s obj.OneFlag = YesFlag
		} else {
			s obj.ThreeFlag = YesFlag
		}
	}
	set retVal=obj.%Save()
	if ($system.Status.IsError(retVal))
	{
		do $system.OBJ.DisplayError(retVal)
		set return=-1
	}
	else
	{
		set return=obj.%Id()
	}
	do obj.%Close()
	q return
}

/// Creator:    yhb
/// CreateDate: 2014-06-19
/// Description:纸单号入库
/// Input:     startNo：开始编号
///            endNo：  结束编号
///            noType： 死亡证明编号类型
///            locRowId:科室Id
///            userRowId:用户Id
/// Output:生成死亡证明编号结果
/// w ##Class(DHCMed.DTHService.PaperNoSrv).ImportPaperNo("0000001^0000010^1^9")
ClassMethod ImportPaperNo(instr As %String) As %String
{
	new (instr)
	set retStr=""
	set separate="^"
	set RepID=""
	set startNo=$p($g(instr),separate,1)
	set endNo=$p($g(instr),separate,2)
	set StLocDR=$p($g(instr),separate,3)     
	set STDoctorDR=$p($g(instr),separate,4)
	set AllocLocDR=""
	set StatusDR=2  //待用
	set IsActive=1
	set Resume=""
	for paperNo=startNo:1:endNo
	{	
		s PaperNo=""
		s $p(PaperNo,"0",8-$l(paperNo))= paperNo
		set updateStr=separate_RepID_separate_PaperNo_separate_StLocDR_separate_STDoctorDR_separate_AllocLocDR_separate_StatusDR_separate_IsActive_separate_Resume
		set resultStr="已存在"
		if '($d(^DHCMed.DTHi("PAPERNO","IndexPaperNo",PaperNo))){
			set paperNoRowId=##Class(DHCMed.DTH.PaperNo).Update(updateStr,separate)
	    	set:paperNoRowId>0 resultStr="入库成功"
	    	set:paperNoRowId=-1 resultStr="入库失败"
		}
	    
		set retStr=retStr_"死亡证明书纸单号"_PaperNo_resultStr_separate
	}
	s retStr = $e(retStr,1,$l(retStr)-1)
	quit retStr
}

/// Creator:    yhb
/// CreateDate: 2014-06-19
/// Desscripiton:修改纸单号的状态
/// Input: paperNo^OpeLocDR^OpeUserDR^StatusDR^BehindPaperNo^ResumeText
/// Output:修改结果
/// w ##Class(DHCMed.DTHService.PaperNoSrv).ChangePaperNoStatus("0000011^3^117^117^9^1")   
ClassMethod ChangePaperNoStatus(instr) As %String
{
	new (instr)
	set ret = -1
	set separate="^"
	set currDate=+$h
	set currTime=+$p($h,",",2)
	set paperNo=$p($g(instr),separate,1)
	s $p(PaperNo,"0",8-$l(paperNo))= paperNo
	set PaperNoID = $o(^DHCMed.DTHi("PAPERNO","IndexPaperNo",PaperNo,""))
	set obj=##Class(DHCMed.DTH.PaperNo).%OpenId(PaperNoID)
	quit:'$IsObject(obj) ret
	set StatusDR=$p($g(instr),separate,2)
	set AllocLocDR=$p($g(instr),separate,3)
	set OpeLocDR=$p($g(instr),separate,4)
	set OpeUserDR=$p($g(instr),separate,5)
	set RepID=$p($g(instr),separate,6)
	set statusDicId=##Class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(StatusDR,"DTHCurrencyState") 
	set statusDicObj=##Class(DHCMed.SS.Dictionary).GetObjById(+statusDicId)
	set obj.AllocLocDR=AllocLocDR
	set obj.StatusDR=statusDicObj
	set obj.StDate = currDate
	set obj.StTime = currTime
	if (RepID'="") {
		set objRep=##Class(DHCMed.DTH.Report).%OpenId(RepID)
		if ($IsObject(objRep)) {
			set obj.RepObj=objRep
		}
	}
	set paperNoId=obj.%Save()
	if ($system.Status.IsError(paperNoId)){
		do $system.OBJ.DisplayError(paperNoId)
		set ret=-1
	}
	set paperNoStatus=##Class(DHCMed.DTH.PaperNoStatus).%New()
	set paperNoStatus.StatusDR=statusDicObj
	
	set paperNoStatus.OpeDate=currDate
	set paperNoStatus.OpeTime=currTime
	set paperNoStatus.OpeLocDR=OpeLocDR
	set paperNoStatus.OpeUserDR=OpeUserDR
	set paperNoStatus.ParrefRaperNo = obj
	set paperNoRowId=paperNoStatus.%Save()
	
	if ($system.Status.IsError(paperNoRowId)){
		do $system.OBJ.DisplayError(paperNoRowId)
		set ret=-1
	}else{
		set ret=paperNoRowId
	}
	if obj'="" do obj.%Close()
	if paperNoStatus'="" do paperNoStatus.%Close()
	quit ret
}

/// Creator:     yhb
/// CreateDate:  2014-04-26
/// Description:根据状态或科室ID查询纸单号
/// Input:      aState：状态  aLoc：分配科室ID
/// Output:     PaperNoID,PaperNo,StLoc,StDoctor,StDate,StTime,AllocLoc,Status,OneFlag,ThreeFlag
/// Debug:      d ##Class(%ResultSet).RunQuery("DHCMed.DTHService.PaperNoSrv","QryPaperNo","","")
Query QryPaperNo(aState As %String = "", aLoc As %String = "", aHosp As %String = "") As %Query(ROWSPEC = "PaperNoID:%String,PaperNo:%String,StLoc:%String,StDoctor:%String,StDate:%String,StTime:%String,AllocLoc:%String,Status:%String,OneFlag:%String,ThreeFlag:%String")
{
}

ClassMethod QryPaperNoExecute(ByRef qHandle As %Binary, aState As %String = "", aLoc As %String = "", aHosp As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set PaperNoID=""
 	//纸单号、入库科室、入库人、入库日期、入库时间、状态、首联使用、三联使用
 	set (PaperNo,StLoc,StDoctor,StDate,StTime,AllocLoc,Status,OneFlag,ThreeFlag)=""
 	for {
	 	set PaperNoID = $o(^DHCMed.DTH("PAPERNO",PaperNoID),-1)
	 	q:PaperNoID=""
	 	Set PaperInfo = $g(^DHCMed.DTH("PAPERNO",PaperNoID))
	 	Set PaperChildInfo = $g(^DHCMed.DTH("PAPERNO",PaperNoID,1))
	 	Set PaperNo	  = $lg(PaperInfo,2)
	 	Set StLocDR	  = $lg(PaperInfo,3)
	 	if aHosp'="" {
			set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+StLocDR,aHosp)
			continue:flg<1
		}
		Set StLoc=$p($g(^CTLOC(+StLocDR)),"^",2)	 //填报科室
		Set:StLoc["-" StLoc=$p(StLoc,"-",2)
		
		Set StDoctorDR = $lg(PaperChildInfo,3)
		Set StDoctor   = $p($g(^SSU("SSUSR",StDoctorDR)),"^",2)
	 	Set StDate	   = $lg(PaperChildInfo,4)
		Set:StDate'="" StDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(StDate)
	 	Set StTime	  = $lg(PaperChildInfo,5)
		Set:StTime'="" StTime=$zt(StTime,2)
		Set AllocLocDR = $lg(PaperChildInfo,6)
		Set AllocLoc=$p($g(^CTLOC(+AllocLocDR)),"^",2)	 //填报科室
		Set:AllocLoc["-" AllocLoc=$p(AllocLoc,"-",2)
	 	Set StatusDR   = $lg(PaperInfo,5)
		Set Status	   = $lg($g(^DHCMed.SS.DictionaryD(StatusDR)),4)
		Set StatusID   = StatusDR
		Set OneFlag=$lg(PaperChildInfo,8)
		Set:OneFlag=1 OneFlag="已打印"
		Set:OneFlag="" OneFlag="未打印"
		Set:OneFlag=0 OneFlag="未打印"
		Set ThreeFlag=$lg(PaperChildInfo,7)
		Set:ThreeFlag=1 ThreeFlag="已打印"
		Set:ThreeFlag=0 ThreeFlag="未打印"
		Set:ThreeFlag="" ThreeFlag="未打印"
		Continue:(aLoc'="")&&(AllocLocDR'=aLoc)
		Continue:(aState'="")&&(StatusID'=aState)
		Set data=$lb(PaperNoID,PaperNo,StLoc,StDoctor,StDate,StTime,AllocLoc,Status,OneFlag,ThreeFlag)
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryPaperNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPaperNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPaperNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPaperNoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	} Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:    yhb
/// CreateDate: 2014-06-19
/// Description:检查纸单号是否存在及使用状态
/// Input:     PaperNo：录入纸单号
/// Output:    0： 不存在 1： 存在  2：已用
/// w ##Class(DHCMed.DTHService.PaperNoSrv).CheckPaperNo("17")
ClassMethod CheckPaperNo(paperNo As %String, CtlocId As %String = "") As %String
{
	new (paperNo,CtlocId)
	s $p(PaperNo,"0",8-$l(paperNo))= paperNo
	s PaperNoID = $o(^DHCMed.DTHi("PAPERNO","IndexPaperNo",PaperNo,""))
	set obj=##Class(DHCMed.DTH.PaperNo).%OpenId(PaperNoID)
	if ($IsObject(obj)) {
		set objStatus = obj.StatusDR
		if ((CtlocId'="")&&(CtlocId'=obj.AllocLocDR)) {
			q 0
		}
		if ($IsObject(objStatus)) {
			if (objStatus.Code=3) {
				q 2
			} else {
				q 1	
			}
		}
	} else {
		q 0
	}
}

/// Creator:    yhb
/// CreateDate: 2014-06-19
/// Description:获取纸单号
/// Input:     
/// Output:    最早产生的未用纸单号
/// w ##Class(DHCMed.DTHService.PaperNoSrv).GetNewPaperNo()
ClassMethod GetNewPaperNo() As %String
{
	s paperNo=""
	s PaperNo=""
	for {
		s paperNo = $o(^DHCMed.DTHi("PAPERNO","IndexPaperNo",paperNo))
		q:paperNo=""
		s PaperNoID = $o(^DHCMed.DTHi("PAPERNO","IndexPaperNo",paperNo,""))
		set obj=##Class(DHCMed.DTH.PaperNo).%OpenId(PaperNoID)
		if ($IsObject(obj)) {
			set objStatus = obj.StatusDR
			if ($IsObject(objStatus)) {
				if (objStatus.Code=2) {
					s PaperNo=paperNo
					q
				}
			}
		}
	}
	q PaperNo
}

/// Creator:    yhb
/// CreateDate: 2014-06-19
/// Description:重新生成索引 P5库用
/// Input:     
/// Output:    
/// d ##Class(DHCMed.DTHService.PaperNoSrv).BuildInd()
ClassMethod BuildInd() As %String
{
	s PaperID = ""
	for {
		s PaperID = $o(^DHCMed.DTH("PAPERNO",PaperID))
		q:PaperID=""
		set obj=##Class(DHCMed.DTH.PaperNo).%OpenId(PaperID)
		if ($IsObject(obj)) {
			
			set obj.PaperNo=obj.PaperNo
			set obj.RepObj=obj.RepObj
			set obj.StDate=obj.StDate
			set obj.StTime=obj.StTime
			set retVal=obj.%Save()
			//RowId^RepID^RaperNo^StLocDR^STDoctorDR^AllocLocDR^StatusDR^IsActive^Resume
			w obj.%Id(),!
		}
	}
}

/// 根据报告ID取对应的纸单号，若没有报告没有对应的纸单号，则取一个新的最小的号
/// 并更新制单的状态
/// w ##class(DHCMed.DTHService.PaperNoSrv).GetAndUpdateNewPaperNo(8)
ClassMethod GetAndUpdateNewPaperNo(aReportID As %String, aInStr As %String) As %String
{
	New (aReportID,aInStr)
	Set paperno="",return=-1
	
	Set objReport=##Class(DHCMed.DTH.Report).GetObjById(aReportID)
	Quit:('$IsObject(objReport)) return
	
	Set PaperNo=..GetPaperNo(aReportID)
	Quit:PaperNo'="" PaperNo
	If (PaperNo="") {
		//如果reportid对应的没报告则取一个新的纸单号
		Set NewPaperNo=..GetNewPaperNo()
		//更新纸单号的状态
		If (NewPaperNo'="") {
			Set InputStr=PaperNo_"^"_aInStr
			Set return=..ChangePaperNoStatus(InputStr)
			Quit:return<0 return
		}
		
		//更新纸单号报告打印状态
		Set PaperNoID=""
		Set:NewPaperNo'="" PaperNoID=$o(^DHCMed.DTHi("PAPERNO","IndexPaperNo",NewPaperNo,""))
		Set obj=##Class(DHCMed.DTH.PaperNo).%OpenId(PaperNoID)
		Quit:('$IsObject(obj)) return
		
		Set obj.OneFlag = "1"
		Set obj.ThreeFlag = "1"
		Set retVal=obj.%Save()
		
		If ($system.Status.IsError(retVal)) {
			do $system.OBJ.DisplayError(retVal)
			set return=-1
		} else {
			set return=obj.%Id()
		}
		do obj.%Close()
	}
	Quit return
}

}

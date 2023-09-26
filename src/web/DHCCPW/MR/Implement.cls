/// 名称: web.DHCCPW.MR.Implement
/// 描述: 临床路径实施记录
/// 编写者：wuqk
/// 编写日期: 2010-06-12
Class web.DHCCPW.MR.Implement Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     wuqk
/// CreatDate：   2010-06-12
/// Description:  根据ID取临床路径实施记录
/// Table：       User.DHCMRClinicalPathWayImpl
/// Input：       ID:    User.DHCMRClinicalPathWayImpl
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MR.Implement).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRClinicalPathWay
{
	New (argId)
	Set return=""
	Set return=##Class(User.DHCMRClinicalPathWayImpl).%OpenId(argId)
	If return'="" {
		If '$IsObject(return.CPWEStepDR) {
			If $IsObject(return.CPWEStepItemDR) {
				Set StepItemID=return.CPWEStepItemDR.%Id()
				Set StepID=$p(StepItemID,"||",1)_"||"_$p(StepItemID,"||",2)_"||"_$p(StepItemID,"||",3)
				Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(StepID)
				Set return.CPWEStepDR=objStep
			}
		}
	}
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-06-12
/// Description:  根据ID取临床路径实施记录
/// Table：       User.DHCMRClinicalPathWayImpl
/// Input：       ID:    User.DHCMRClinicalPathWayImpl
///               separete: 指定的分隔符
/// Return：      String
/// w ##class(web.DHCCPW.MR.Implement).GetStringById(1,"^")
ClassMethod GetStringById(argId As %String, separete As %String) As %String
{
	New (argId,separete)
	Set return=""
	
	Set obj=..GetObjById(argId)
	quit:'$IsObject(obj) return
	
	Set:$g(separete)="" separete=..#SEPARATE
	set CPWEParRef        = obj.CPWEParRef
	set CPWEOEORIDR       = obj.CPWEOEORIDR       
	set CPWEStepItemDR    = obj.CPWEStepItemDR    
	set CPWEImplementDate = $zd(obj.CPWEImplementDate,3)
	set CPWEImplementTime = $zt(obj.CPWEImplementTime)
	set CPWEDoctorDR      = obj.CPWEDoctorDR      
	set CPWEDate          = $zd(obj.CPWEDate,3)
	set CPWETime          = $zt(obj.CPWETime)   
	set CPWEUserDR        = obj.CPWEUserDR 
	set:$IsObject(CPWEParRef) parentId=CPWEParRef.%Id()
	set strDoctor=##class(web.DHCCPW.MR.CTCareProvSrv).GetCareProvByID(CPWEDoctorDR,$c(2))
	set strUser=##class(web.DHCCPW.MR.CTCareProvSrv).GetCareProvByUserID(CPWEUserDR,$c(2))
	Set return=$g(ID)_separete
	Set return=return_$g(parentId)_separete
	Set return=return_$g(CPWEOEORIDR)_separete
	Set return=return_$g(CPWEStepItemDR)_separete
	Set return=return_$g(CPWEImplementDate)_separete
	Set return=return_$g(CPWEImplementTime)_separete
	Set return=return_$g(strDoctor)_separete
	Set return=return_$g(CPWEDate)_separete
	Set return=return_$g(CPWETime)_separete
	Set return=return_$g(strUser)_separete
	Quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-06-12
/// Description:  insert临床路径实施记录
/// Table：       User.DHCMRClinicalPathWayImpl
/// Input：       str
/// Return：      id
/// w ##class(web.DHCCPW.MR.Implement).InsertImpl("")
ClassMethod InsertImpl(instr) As %String
{
	new (instr)
	
	Set return=-1
	Set ID=$p(instr,"^",1)
	If ID="" {
		Set obj=##class(User.DHCMRClinicalPathWayImpl).%New()
	} Else {
		Set obj=##class(User.DHCMRClinicalPathWayImpl).%OpenId(ID)
	}
	Quit:'$IsObject($g(obj)) return
	
	set CPWEParRef        = $p(instr,"^",2)
	set CPWEOEORIDR       = $p(instr,"^",3)
	set CPWEStepItemDR    = $p(instr,"^",4)
	set CPWEImplementDate = $p(instr,"^",5)
	set CPWEImplementTime = $p(instr,"^",6)
	set CPWEDoctorDR      = $p(instr,"^",7)
	set CPWEDate          = $p(instr,"^",8)
	set:CPWEDate'="" CPWEDate=+$h
	set CPWETime          = $p(instr,"^",9)
	set:CPWETime'="" CPWETime=$p($h,",",2)
	set CPWEUserDR        = $p(instr,"^",10)
	set CPWEActive        = $p(instr,"^",11)
	Set CPWEActive=$s(CPWEActive["N":"N",1:"Y")
	set CPWEUpdoDate      = $p(instr,"^",12)
	set CPWEUpdoTime      = $p(instr,"^",13)
	set CPWEUpdoUserDR    = $p(instr,"^",14)
	set CPWEProcNote      = $p(instr,"^",15)
	
	Set ImplNewDR=$p(instr,"^",16)
	If (ImplNewDR'="") {
		Set objImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(ImplNewDR)
		Quit:'$IsObject(objImplNew) return
	}
	
	set CPWEParRef=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(CPWEParRef)
	quit:CPWEParRef="" return
	
	If (CPWEImplementDate'=""){
		Set:CPWEImplementDate["/" CPWEImplementDate=$zdh(CPWEImplementDate,4)
		Set:CPWEImplementDate["-" CPWEImplementDate=$zdh(CPWEImplementDate,3)
		Set:CPWEImplementDate'="" CPWEImplementDate=+CPWEImplementDate
	}
	else{
		Set CPWEImplementDate=+$h
	}
	If (CPWEImplementTime'=""){		
		Set:CPWEImplementTime[":" CPWEImplementTime=$zth(CPWEImplementTime,2)
		Set:CPWEImplementTime'="" CPWEImplementTime=+CPWEImplementTime
	}
	else{
		Set CPWEImplementTime=$p($h,",",2)
	}
	set StepItemID=$p(CPWEStepItemDR,"-",1)
	set StepID=$p(CPWEStepItemDR,"-",2)
	set:StepID="" StepID=$p(StepItemID,"||",1)_"||"_$p(StepItemID,"||",2)_"||"_$p(StepItemID,"||",3)
	set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
	set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(StepID)
	set obj.CPWEParRef        =  CPWEParRef        
	set obj.CPWEOEORIDR       =  CPWEOEORIDR       
	set obj.CPWEStepItemDR    =  objItem  
	set obj.CPWEImplementDate =  CPWEImplementDate 
	set obj.CPWEImplementTime =  CPWEImplementTime 
	set obj.CPWEDoctorDR      =  CPWEDoctorDR      
	set obj.CPWEDate          =  CPWEDate          
	set obj.CPWETime          =  CPWETime          
	set obj.CPWEUserDR        =  CPWEUserDR
	set obj.CPWEActive        =  CPWEActive
	set obj.CPWEUpdoDate      =  CPWEUpdoDate
	set obj.CPWEUpdoTime      =  CPWEUpdoTime
	set obj.CPWEUpdoUserDR    =  CPWEUpdoUserDR
	set obj.CPWEProcNote      =  CPWEProcNote
	set obj.CPWEStepDR        =  objStep
	Set:(ImplNewDR'="") obj.CPWEImplNewDR=objImplNew
	        
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                      //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	} else {
		set return=obj.%Id()
	}
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-06-12
/// Description:  批量执行临床路径实施记录(诊疗、护理)
/// Table：       
/// Input：       ParentId    :User.DHCMRClinicalPathWay
///               ItemIdList  :User.DHCMRCClinPathWaysEpStepItem
///               UserId      :
/// Return：      flag
/// w ##class(web.DHCCPW.MR.Implement).doImplBatch("","","")
ClassMethod doImplBatch(ParentId, ItemIdList, UserId) As %String
{
	new (ParentId,ItemIdList,UserId)
	set ret=1
	quit:ParentId="" ret
	quit:ItemIdList="" ret
	quit:UserId="" ret
	set $ZT="doImplBatchError"
	
	set UserString=##class(web.DHCCPW.MR.CTCareProvSrv).GetCareProvByUserID(UserId,"^")
	set docId=$p(UserString,"^",1)
	set itemCount=$l(ItemIdList,",")
	
	TStart
	
	for i=1:1:itemCount {
		set itemId=$p(ItemIdList,",",i)
		if itemId="" continue
		
		If (ParentId["||") {
			set instr="^"_$p(ParentId,"||",1)_"^^"_itemId_"^^^"_docId_"^"_+$h_"^"_$p($h,",",2)_"^"_UserId_"^Y^^^^^"_ParentId
		} Else {
			set instr="^"_ParentId_"^^"_itemId_"^^^"_docId_"^"_+$h_"^"_$p($h,",",2)_"^"_UserId_"^Y^^^"
		}
		set flag=..InsertImpl(instr)
		set:+flag<0 ret=+flag
	}
	if ret<0 TRollback
	quit:ret<0 ret
	
	TCommit
	quit ret
	
doImplBatchError
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// Creator：     zhufei
/// CreatDate：   2010-12-22
/// Description:  批量撤销执行临床路径实施记录(诊疗、护理)
/// Table：       
/// Input：       ItemIdList  :User.DHCMRCClinPathWaysEpStepItem
///               UserId      :
/// Return：      flag
/// w ##class(web.DHCCPW.MR.Implement).updoImplBatch("13||11,13||12","208")
ClassMethod updoImplBatch(ItemIdList, UserId) As %String
{
	new (ItemIdList,UserId)
	set ret=1
	quit:ItemIdList="" ret
	quit:UserId="" ret
	set $ZT="updoImplBatchError"
	
	TStart
	
	for i=1:1:$l(ItemIdList,",") {
		set itemId=$p(ItemIdList,",",i)
		if itemId="" continue
		
		set objImpl=..GetObjById(itemId)
		if $IsObject(objImpl){
			set instr=objImpl.%Id()
			set instr=instr_"^"_+objImpl.%Id()
			set instr=instr_"^"_objImpl.CPWEOEORIDR
			set instr=instr_"^"_objImpl.CPWEStepItemDR.%Id()
			set instr=instr_"^"_objImpl.CPWEImplementDate
			set instr=instr_"^"_objImpl.CPWEImplementTime
			set instr=instr_"^"_objImpl.CPWEDoctorDR
			set instr=instr_"^"_objImpl.CPWEDate
			set instr=instr_"^"_objImpl.CPWETime
			set instr=instr_"^"_objImpl.CPWEUserDR
			set instr=instr_"^"_"N"
			set instr=instr_"^"_+$h
			set instr=instr_"^"_$p($h,",",2)
			set instr=instr_"^"_UserId
			set instr=instr_"^"_objImpl.CPWEProcNote
			set flag=..InsertImpl(instr)
			set:+flag<0 ret=+flag
		}
	}
	if ret<0 TRollback
	quit:ret<0 ret
	
	TCommit
	quit ret
	
updoImplBatchError
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// Creator：     zhufei
/// CreatDate：   2010-12-22
/// Description:  通过项目ID取实施记录
/// Table：       
/// Input：       PathWayID   :User.DHCMRClinicalPathWay
///               ItemId      :User.DHCMRCClinPathWaysEpStepItem
/// Return：      flag
/// w ##class(web.DHCCPW.MR.Implement).GetImplements(1,"8||1||1||6-8||1||1-2||1")
ClassMethod GetImplements(PathWayID, ItemID) As %String
{
	New (PathWayID, ItemID)
	Set return=""
	Quit:(PathWayID="")||(ItemID="") return
	
	Set $ZT="GetImplementsError"
	
	Set StepID=$p(ItemID,"-",2)
	Set ItemID=$p(ItemID,"-",1)
	//^DHCMRi(0,"IMPL","IndexStepItem",10,"8||1||1||1",1)
	Set SubID=0
	For {
		Set SubID=$o(^DHCMRi(0,"IMPL","IndexStepItem",PathWayID,ItemID,SubID))
		Quit:SubID=""
		
		Set ImplementID=PathWayID_"||"_SubID
		Set objImplement=..GetObjById(ImplementID)
		If $IsObject(objImplement){
			Set Active=objImplement.CPWEActive
			Continue:Active["N"
			Set CPWEStepDR=objImplement.CPWEStepDR.%Id()
			If CPWEStepDR'="" {
				Continue:(StepID'="")&&(CPWEStepDR'=StepID)
			}
			Set ImplementDate=objImplement.CPWEImplementDate
			Set:ImplementDate'="" ImplementDate=$zd(ImplementDate,3)
			Set ImplementTime=objImplement.CPWEImplementTime
			Set:ImplementTime'="" ImplementTime=$zt(ImplementTime,2)
			Set OEItemID=objImplement.CPWEOEORIDR
			Set ARCItemID="",OEItemDesc=""
			Set:OEItemID'="" ARCItemID=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",2)
			Set:ARCItemID'="" OEItemDesc=$p($g(^ARCIM(+ARCItemID,$p(ARCItemID,"||",2),1)),"^",2)
			Set ProcNote=objImplement.CPWEProcNote
			Set ImplDesc=ImplementDate_" "_ImplementTime
			Set DocID=objImplement.CPWEDoctorDR
			Set DocDesc=$p($g(^CTPCP(+DocID)),"^",2)
			Set:DocDesc'="" ImplDesc=ImplDesc_" ,"_DocDesc
			Set:OEItemDesc'="" ImplDesc=ImplDesc_" ,"_OEItemDesc
			Set:ProcNote'="" ImplDesc=ImplDesc_" ,"_ProcNote
			Set return=return_$c(1)_ImplementID_"^"_ImplDesc
		}
	}
	
	//^DHCMR("IMPL",1,"EpStep","8||1||1","ARCIM","10338||1","8||1||1||6","OEItemID:130||32||1")
	Set ArcimID=""
	For {
		Set ArcimID=$o(^DHCMR("IMPL",PathWayID,"EpStep",StepID,"ARCIM",ArcimID))
		Quit:ArcimID=""
		
		Continue:'$d(^DHCMR("IMPL",PathWayID,"EpStep",StepID,"ARCIM",ArcimID,ItemID))
		
		Set OEExecID=""
		For {
			Set OEExecID=$o(^DHCMR("IMPL",PathWayID,"EpStep",StepID,"ARCIM",ArcimID,ItemID,OEExecID))
			Quit:OEExecID=""
			
			Set tmpData=$g(^DHCMR("IMPL",PathWayID,"EpStep",StepID,"ARCIM",ArcimID,ItemID,OEExecID))
			Continue:tmpData=""
			Set ArcimDesc=$listget(tmpData,2)
			Set OEExStDate=$listget(tmpData,3)
			Set OEExStTime=$listget(tmpData,4)
			Set return=return_$c(1)_""_"^"_ArcimDesc_$zd(+OEExStDate,3)_" "_$zt(+OEExStTime,1)
		}
	}
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
	
GetImplementsError
 	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2010-12-24
/// Description:  单个执行临床路径实施记录(门诊医嘱)
/// Table：       
/// Input：       ParentId    :User.DHCMRClinicalPathWay
///               ItemId      :User.DHCMRCClinPathWaysEpStepItem
///               OrderList   :医嘱列表
///               ProcNote    :处置意见
///               UserId      :操作用户
/// Return：      flag
/// w ##class(web.DHCCPW.MR.Implement).doImplOutOrder("","","","","")
ClassMethod doImplOutOrder(ParentId, ItemId, OrderList, ProcNote, UserId, ImplNewID) As %String
{
	new (ParentId,ItemId,OrderList,ProcNote,UserId,ImplNewID)
	set ret=1,ImplNewID=$g(ImplNewID)
	quit:ParentId="" ret
	quit:ItemId="" ret
	quit:UserId="" ret
	set $ZT="doImplOutOrderError"
	
	set UserString=##class(web.DHCCPW.MR.CTCareProvSrv).GetCareProvByUserID(UserId,"^")
	set docId=$p(UserString,"^",1)
	
	TStart
	
	if OrderList'="" {
		for ordIndex=1:1:$l(OrderList,",")
		{
			set ordId=$p(OrderList,",",ordIndex)
			continue:ordId=""
			set instr="^"_ParentId_"^"_ordId_"^"_ItemId_"^^^"_docId_"^"_+$h_"^"_$p($h,",",2)_"^"_UserId_"^Y^^^^"_ProcNote_"^"_ImplNewID
			set flag=..InsertImpl(instr)
			set:+flag<0 ret=+flag
		}
	} else {
		set instr="^"_ParentId_"^"_""_"^"_ItemId_"^^^"_docId_"^"_+$h_"^"_$p($h,",",2)_"^"_UserId_"^Y^^^^"_ProcNote_"^"_ImplNewID
		set flag=..InsertImpl(instr)
		set:+flag<0 ret=+flag
	}
	if ret<0 TRollback
	quit:ret<0 ret
	
	TCommit
	quit ret
	
doImplOutOrderError
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// Creator：     zhufei
/// CreatDate：   2011-04-28
/// Description:  自动补录完成的临床路径实施记录
/// Return：      flag
/// w ##class(web.DHCCPW.MR.Implement).InsertImplToClosePathWay("","")
ClassMethod InsertImplToClosePathWay(argStartDate As %String, argEndDate As %String) As %String
{
	New (argStartDate,argEndDate)
	Set return=""
	
	Set:argStartDate["-" argStartDate=$zdh(argStartDate,3)
	Set:argStartDate["/" argStartDate=$zdh(argStartDate,4)
	Set:argEndDate["-" argEndDate=$zdh(argEndDate,3)
	Set:argEndDate["/" argEndDate=$zdh(argEndDate,4)
	Set:argStartDate'="" argStartDate=+argStartDate
	Set:argEndDate'="" argEndDate=+argEndDate
	
	Set OutDate=0
	For {
		Set OutDate=$o(^DHCMRi("CPW",0,"IndexStatusOutDate"," C",OutDate))
		Quit:OutDate=""
		Continue:(argStartDate'="")&&(OutDate<argStartDate)
		Continue:(argEndDate'="")&&(OutDate>argEndDate)
		Set OutTime=0
		For {
			Set OutTime=$o(^DHCMRi("CPW",0,"IndexStatusOutDate"," C",OutDate,OutTime))
			Quit:OutTime=""
			Set PathWayID=0
			For {
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexStatusOutDate"," C",OutDate,OutTime,PathWayID))
				Quit:PathWayID=""
				Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				Continue:'$IsObject(objPathWay)
				Set CPWID=objPathWay.CPWPathwayDR.%Id()
				Set DocID=objPathWay.CPWInDoctorDR
				Set UserID=objPathWay.CPWUpdateUserDR
				Set EpID=0
				For {
					Set EpID=$o(^DHCMRC("CPW",CPWID,"EP",EpID))
					Quit:EpID=""
					Set StepID=0
					For {
						Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
						Quit:StepID=""
						Set ItemID=0
						For {
							Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
							Quit:ItemID=""
							Set ItemRowid=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
							Continue:$d(^DHCMRi(0,"IMPL","IndexStepItem",PathWayID,ItemRowid))
							Set UserID=""
							Set UserString=##class(web.DHCCPW.MR.CTCareProvSrv).GetCareProvByUserID(UserID,"^")
							Set DocID=$p(UserString,"^",1)
							Set InputStr="^"_PathWayID_"^"_""_"^"_ItemRowid_"^^^"_DocID_"^"_OutDate_"^"_OutTime_"^"_UserID_"^Y^^^^"_$zd(+$h,3)_"自动插入记录"
							Set flag=..InsertImpl(InputStr)
							Write "flag="_flag,!
						}
					}
				}
				Write "PathWayID="_PathWayID,!
			}
		}
	}
	
	Quit "Over!"
}

}

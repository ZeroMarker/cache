/// 名称: DHCHAI.IRS.PDCARepSrvTMP
/// 描述: PDCA报告服务
/// 编写者：ShenC
/// 编写日期: 2022-08-22
Class DHCHAI.IRS.PDCARepSrvTMP Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2023-09-26
/// Description:  查询PDCA项目类型
/// Table：       DHCHAI.IR.PDCARep
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.PDCARepSrv","QryPAItemType")
Query QryPAItemType(aItemType As %String = "") As %Query(ROWSPEC = "ID:%String,ItemType:%String") [ SqlProc ]
{
}

ClassMethod QryPAItemTypeExecute(ByRef qHandle As %Binary, aItemType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set Count=0
	Set xItemType=""
	For{
		Set xItemType=$o(^MA.HAI.IR.PDCARepI("IndexItemType",xItemType))
		Quit:xItemType=""
		Continue:(aItemType'="")&&(aItemType'=xItemType)
		
		Set Count=Count+1
		Set Data=$lb(Count,xItemType)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryPAItemTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPAItemTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPAItemTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPAItemTypeExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  获取PDCA报告科室信息
/// Table：       DHCHAI.IR.PDCARepLoc
/// Input：       aRepID
/// Return：      成功：返回0，失败：返回<0的代码
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.PDCARepSrv","QryPARepLoc","1","")
Query QryPARepLoc(aRepID As %String, aSubID As %String = "", aLocID As %String = "", aIsActive As %String = "1") As %Query(ROWSPEC = "ID:%String,PLocID:%String,PLocCode:%String,PLocDesc:%String,PLocUserID:%String,PLocUserCode:%String,PLocUserDesc:%String,PAdminUserID:%String,PAdminUserCode:%String,PAdminUserDesc:%String,PData:%String,DASttDate:%String,DPEndDate:%String,DUserID:%String,DUserCode:%String,DUserDesc:%String,DData:%String,DAEndDate:%String,DLocAssess:%String,CDate:%String,CUserID:%String,CUserCode:%String,CUserDesc:%String,AID:%String,ACode:%String,ADesc:%String,AIMP:%String,StatusID:%String,StatusCode:%String,StatusDesc:%String,ReStatus:%String") [ SqlProc ]
{
}

ClassMethod QryPARepLocExecute(ByRef qHandle As %Binary, aRepID As %String, aSubID As %String = "", aLocID As %String = "", aIsActive As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aRepID="" $$$OK
	//循环PDCA报告->科室
	Set xID=""
	For{  
		Set xID=$o(^MA.HAI.IR.PDCARepI("Loc","IndexPlanLoc",aRepID,aIsActive,xID))
		Quit:xID=""
		Continue:(aSubID'="")&&(xID'=aSubID)
			
		Set PALocData=$g(^MA.HAI.IR.PDCARepD(aRepID,"Loc",xID))
		Continue:PALocData=""
		
		//计划
		//P->整改科室(病区)
		Set (PLocID,PLocCode,PLocDesc)=""
		Set PLocID=$lg(PALocData,2)	
		If (PLocID'=""){
			Set LocData=$g(^DHCHAI.BT.LocationD(PLocID))
			If (LocData'=""){
				Set PLocCode=$lg(LocData,2)
				Set PLocDesc=$lg(LocData,3)
			}
		}
		Continue:(aLocID'="")&&(aLocID'=PLocID)
		//P->整改科室(病区)负责人
		Set (PLocUserID,PLocUserCode,PLocUserDesc)=""
		Set PLocUserID=$lg(PALocData,3)
		If (PLocUserID'=""){
			Set UserData=$g(^DHCHAI.BT.SysUserD(PLocUserID))
			If (UserData'=""){
				Set PLocUserCode=$lg(UserData,2)
				Set PLocUserDesc=$lg(UserData,3)
			}
		}	
		//P->院感科负责人
		Set (PAdminUserID,PAdminUserCode,PAdminUserDesc)=""	
		Set PAdminUserID=$lg(PALocData,4)
		If (PAdminUserID'=""){
			Set UserData=$g(^DHCHAI.BT.SysUserD(PAdminUserID))
			If (UserData'=""){
				Set PAdminUserCode=$lg(UserData,2)
				Set PAdminUserDesc=$lg(UserData,3)
			}
		}	
		//P->描述
		Set PData=$lg(PALocData,5)		
			
		//执行
		//D->整改实际开始日期
		Set DASttDate=$lg(PALocData,6)								
		Set:DASttDate'="" DASttDate=$zd(DASttDate,3)
		//D->整改预计结束日期
		Set DPEndDate=$lg(PALocData,7)									
		Set:DPEndDate'="" DPEndDate=$zd(DPEndDate,3)							
		//D->提交人
		Set (DUserID,DUserCode,DUserDesc)=""
		Set DUserID=$lg(PALocData,8)
		If (DUserID'=""){
			Set UserData=$g(^DHCHAI.BT.SysUserD(DUserID))
			If (UserData'=""){
				Set DUserCode=$lg(UserData,2)
				Set DUserDesc=$lg(UserData,3)
			}
		}	
		//D->描述
		Set DData=$lg(PALocData,9)	
		//D->整改实际结束日期
		Set DAEndDate=$lg(PALocData,10)								
		Set:DAEndDate'="" DAEndDate=$zd(DAEndDate,3)
		//D->科室自评
		Set DLocAssess=$lg(PALocData,11)												
			
		//检查
		//C->检查日期
		Set CDate=$lg(PALocData,12)
		Set:CDate'="" CDate=$zd(CDate,3)	
		//C->检查人		
		Set (CUserID,CUserCode,CUserDesc)=""				
		Set CUserDesc=$lg(PALocData,13)
		
		//评价
		//A->效果评价
		Set (AID,ACode,ADesc)=""	
		Set AID=$lg(PALocData,14)									
		If (AID'=""){
			Set DicData=$g(^DHCHAI.BT.DictionaryD(AID))
			If (DicData'=""){
				Set ACode=$lg(DicData,2)
				Set ADesc=$lg(DicData,3)
			}
		}	
		//A->持续改进
		Set AIMP=$lg(PALocData,15)
		
		//获取状态
		Set (StatusID,StatusCode,StatusDesc)=""
		Set StatusID=$lg(PALocData,16)
		If (StatusID'=""){
			Set StatusData=$g(^DHCHAI.BT.DictionaryD(StatusID))
			If (StatusData'=""){
				Set StatusCode=$lg(StatusData,2)
				Set StatusDesc=$lg(StatusData,3)
			}
		}
		
		//报告状态[取转换后:待整改,正在整改,完成整改]
		Set ReStatus="待整改"
		Set:(StatusCode="2")||(StatusCode="5")||(StatusCode="6")||(StatusCode="7")||(StatusCode="8")||(StatusCode="9") ReStatus="正在整改"
		Set:StatusCode="10" ReStatus="完成整改"
		
		//过滤无效记录
		Set IsActive=$lg(PALocData,17)
		Continue:(aIsActive="1")&&(IsActive'="1")
		Continue:(aIsActive="0")&&(IsActive'="0")&&(AID="")
		
		Set Data=$lb(xID,PLocID,PLocCode,PLocDesc,PLocUserID,PLocUserCode,PLocUserDesc,PAdminUserID,PAdminUserCode,PAdminUserDesc,PData,DASttDate,DPEndDate,DUserID,DUserCode,DUserDesc,DData,DAEndDate,DLocAssess,CDate,CUserID,CUserCode,CUserDesc,AID,ACode,ADesc,AIMP,StatusID,StatusCode,StatusDesc,ReStatus)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1		
		
	}
	Quit $$$OK
}

ClassMethod QryPARepLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPARepLocExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPARepLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPARepLocExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  1->取PDCA报告基本信息
/// Table：       DHCHAI.IR.PDCARepLoc
/// Input：       aRepID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.PDCARepSrv).GetPARep(13)
ClassMethod GetPARep(aRepID As %String) As %String
{
	New (aRepID)
	Quit:aRepID="" ""
	
	//取报告基本信息
	Set RepData=$g(^MA.HAI.IR.PDCARepD(aRepID))
	Quit:RepData="" ""
	
	Set ItemType=$lg(RepData,2)								//项目类型->ID
	Set ItemDesc=$lg(RepData,3)								//项目类型->名称
	Set ItemIndexID=$lg(RepData,4)							//关联指标->ID
	Quit:ItemIndexID="" ""
	Set IndexData=$g(^CT.MA.HAI.IR.PDCAIndexBaseD(ItemIndexID))	
	Quit:IndexData="" ""										
	Set IndexDesc=$lg(IndexData,3)							//关联指标->名称
	Set TargetVal=$lg(RepData,10)							//目标值
	Set RepName=$lg(IndexData,6)
	Set RepCsp=$lg(IndexData,9)
	
	Set RegDate=$lg(RepData,5)								//登记日期
	Set:RegDate'="" RegDate=$zd(RegDate,3)						
	Set RegTime=$lg(RepData,6)								//登记时间
	Set:RegTime'="" RegTime=$zt(RegTime,1)
	Set (RegLocID,RegLocDesc)=""							//登记科室
	Set RegLocID=$lg(RepData,7)		
	Set RegLocData=$g(^DHCHAI.BT.LocationD(RegLocID))
	If (RegLocData'=""){
		Set RegLocDesc=$lg(RegLocData,3)
		Set RegLocDesc2=$lg(RegLocData,4)
		Set:RegLocDesc2'="" RegLocDesc=RegLocDesc2
	}
	Set (RegUserID,RegUserDesc)=""							//登记人
	Set RegUserID=$lg(RepData,8)								
	Set RepUserData=$g(^DHCHAI.BT.SysUserD(RegUserID))
	If (RepUserData'=""){
		Set RegUserDesc=$lg(RepUserData,3)
	}
	
	Quit ItemType_"^"_ItemDesc_"^"_ItemIndexID_"^"_IndexDesc_"^"_TargetVal_"^"_RegDate_"^"_RegTime_"^"_RegLocID_"^"_RegLocDesc_"^"_RegUserID_"^"_RegUserDesc_"^"_StatusID_"^"_StatusCode_"^"_RepName_"^"_RepCsp
}

/// Creator：     SehnC
/// CreatDate：   2022-09-26
/// Description:  保存PDCA报告
/// Input：       aRepInfo：主表信息
/// 			  aRepExtInfo：扩展表
/// 			  aRepLocInfo：科室表
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCHAI.IRS.PDCARepSrv).SavePDCARep(")
ClassMethod SavePDCARep(aRepInfo As %String, aRepExtInfo As %Text, aRepLocInfo As %String, aRepLog As %String)
{
	Set return = ""
	New (aRepInfo,aRepExtInfo,aRepLocInfo,aRepLog)
	
	TStart
	//保存主表信息
	Set return = -1
	Set RepID  = $p(aRepInfo,$c(1),1)
	
   	Set Flag=##Class(DHCHAI.IR.PDCARep).Update(aRepInfo,$c(1))
	If (Flag=-1){
		TRollback				//失败回滚
	} 
	Quit:(+Flag)<1 return
	Set RepID=+Flag
	//保存扩展表
	Set return = -2
	Set Flag=0
	For xInd = 1:1:$length(aRepExtInfo,$c(2)){
		Set RepExtInfo = $p(aRepExtInfo,$c(2),xInd)
		Continue:RepExtInfo="" 
		
	    Set $p(RepExtInfo,$c(1),1)= RepID
	    
		Set Flag=##Class(DHCHAI.IR.PDCARepExt).Update(RepExtInfo,$c(1))
		If (Flag=-1){
			TRollback
		}
		Quit:(+Flag)<1
	}
	Quit:(+Flag)<1 return
		
	//保存科室表
	Set return = -3
	Set Flag=0
	For xInd = 1:1:$length(aRepLocInfo,$c(2)){
		Set RepLocInfo = $p(aRepLocInfo,$c(2),xInd)
		Continue:RepLocInfo="" 
		
	    Set $p(RepLocInfo,$c(1),1)= RepID
	    
	    Set Flag=##Class(DHCHAI.IR.PDCARepLoc).UpdateP(RepLocInfo,$c(1))
		If Flag=-1 TRollback
		Quit:(+Flag)<1  
	}
	Quit:(+Flag)<1 RepID
	//保存日志表
	Set return = -4
	Set $p(aRepLog,$c(1),1)=RepID
	
	Set Flag=##Class(DHCHAI.IR.PDCARepLog).Update(aRepLog,$c(1))
	If Flag=-1 TRollback
	Quit:(+Flag)<1 return
	
    TCommit
    
    Set return = RepID	
	Quit return
}

}

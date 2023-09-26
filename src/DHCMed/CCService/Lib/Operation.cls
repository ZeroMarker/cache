/// 名称: DHCMed.CCService.Lib.Operation
/// 描述: 与手术相关的函数库
/// 编写者：zhufei
/// 编写日期: 2011-06-08
Class DHCMed.CCService.Lib.Operation Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.Operation).Test()
ClassMethod Test()
{
	New
	
	Set %EpisodeID=5307965
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..GetOperClassByOAS("特大|大|中|小","")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2012-08-31
/// Description:  取手术麻醉系统手术分类信息
/// Table：       手术排班表  DHC_AN_OPArrange
///               手术等级    DHC_ANC_OPLevel（特大、大、中、小）
///               麻醉表      OR_Anaesthesia
///               手术表      OR_Anaest_Operation
///               手术分类    ORC_OperationCategory
/// Input：       argOperClass : 手术分类
/// Return：      return=手术数量
ClassMethod GetOperClassByOAS(argOperClass As %String, argOperName As %String = "") As %String
{
	New (argOperClass,argOperName,%EpisodeID,%ExtraData,%ErrorData)
	Set return=0
	
	Set $ZT="GetOperClassByOASErr"
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	If (argOperClass'="") {
		Set OperClassList=##Class(DHCMed.CCService.Lib.Common).GetListFromString(argOperClass,"|")
	} Else {
		Set OperClassList=""
	}
	If (argOperName'="") {
		Set OperNameList=##Class(DHCMed.CCService.Lib.Common).GetListFromString(argOperName,"|")
	} Else {
		Set OperNameList=""
	}
	
	Set OperArr=0
	For {
		Set OperArr=$o(^DHCANOPArrange(0,"Adm",+%EpisodeID,OperArr))
		Quit:OperArr=""
		
		Set OperStatus=$p($g(^DHCANOPArrange(OperArr)),"^",27)
		Continue:OperStatus="NotApp"
		Set AnaRowID=$p($g(^DHCANOPArrange(OperArr)),"^",2)
		Set Paadm=$p(AnaRowID,"||",1)
		Set AnaChild=$p(AnaRowID,"||",2)
		Continue:(AnaChild="")||(Paadm="")
		Set OperStartDate=$p($g(^DHCANOPArrange(OperArr)),"^",14)
		If OperStartDate'="" {
    		Set OperStartDate=$zd(OperStartDate,3)
    		Set OperStartTime=$p($g(^DHCANOPArrange(OperArr)),"^",15)
			Set OperStartTime=$zt(+OperStartTime,2)
    	} Else {
	    	Set OperStartTime=""
	    }
	    
		Set OPChild=0
		For {
    		Set OPChild=$o(^OR(Paadm,"ANA",AnaChild,"OP",OPChild))
    		Quit:OPChild=""
    		
    		Set AnaOpRowID=Paadm_"||"_AnaChild_"||"_OPChild
    		Set tmpOper=$g(^OR(Paadm,"ANA",AnaChild,"OP",OPChild))
    		Continue:tmpOper=""
    		
    		Set (OperationID,OperationDesc,OperLevelID,OperLevelDesc,OperCategID,OperCategDesc,OperDocID,OperDocDesc)=""
    		
    		//取手术级别   DHC_ANC_OPLeve
    		Set OperLevelID=$p($g(^OR(Paadm,"ANA",AnaChild,"OP",OPChild,"DHC")),"^",1)
    		Set:OperLevelID'="" OperLevelDesc=$p($g(^DHCANC("OPLevel",OperLevelID)),"^",2)
    		
    		Set OperationID=$p(tmpOper,"^",6)
    		If OperationID'="" {
	    		Set OperationDesc=$p($g(^ORC("OPER",OperationID)),"^",2)
	    		//手术等级
	    		Set OperCategID=$p($g(^ORC("OPER",OperationID)),"^",7)
	    		Set:OperCategID'="" OperCategDesc=$p($g(^ORC("CATEG",OperCategID)),"^",2)
    		} Else {
	    		Set RemSubID=$o(^OR(Paadm,"ANA",AnaChild,"OP",OPChild,"REM",""),-1)
	    		Set:(+RemSubID)>0 OperationDesc=$g(^OR(Paadm,"ANA",AnaChild,"OP",OPChild,"REM",RemSubID))
	    	}
	    	If (OperClassList'="") {
				Continue:(OperCategDesc="")&&(OperLevelDesc="")
				Continue:($listfind(OperClassList,OperCategDesc)<1)&&($listfind(OperClassList,OperLevelDesc)<1)
			}
			If (OperNameList'="") {
				Continue:OperationDesc=""
				Continue:($listfind(OperNameList,OperationDesc)<1)
			}
			
    		Set OperDoc=$p(tmpOper,"^",8)
    		Set tmpOperDocDesc=$p($g(^CTPCP(+OperDoc)),"^",2)
			Set:OperDoc'="" OperDoc=$o(^SSU("SSUSR",0,"CTPCP",OperDoc,0))
			Set objSSUser=##class(DHCMed.Base.SSUser).GetObjById(OperDoc)
			If $IsObject(objSSUser) {
				Set OperDocID=objSSUser.Rowid
				Set OperDocDesc=objSSUser.Name
			}
			Set:(OperDocDesc="")&&(tmpOperDocDesc'="") OperDocDesc="*"_tmpOperDocDesc
			
			//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
			Set Record=""
			Set $p(Record,$c(3),1)=$s(OperCategDesc'="":OperationDesc_"("_OperCategDesc_")",1:OperationDesc)
			Set $p(Record,$c(3),2)=OperStartDate
			Set $p(Record,$c(3),3)=OperStartTime
			Set $p(Record,$c(3),4)=OperationDesc
			Set $p(Record,$c(3),5)=AnaOpRowID
			Set $p(Record,$c(3),6)=+OperDocID
			Set $p(Record,$c(3),7)="argOperClass:"_argOperClass_",argOperName:"_argOperName
			Set %ExtraData=%ExtraData_$lb(Record)
			
			Set return=return+1
    	}
	}
	
	Quit return
	
GetOperClassByOASErr
	Quit 0
}

/// Creator：     liuyh
/// CreatDate：   2013-05-22
/// Description:  取手术麻醉系统手术切口信息
/// Table：       手术排班表  DHC_AN_OPArrange
///               手术等级    DHC_ANC_OPLevel（I,II,III）
///               麻醉表      OR_Anaesthesia
///               手术表      OR_Anaest_Operation
///               手术分类    ORC_OperationCategory
/// Input：       argOperClass : 手
/// w ##class(DHCMed.CCService.Lib.Operation).GetOperClassByCutType(2)
ClassMethod GetOperClassByCutType(argOperClass As %String, argOperName As %String = "") As %String
{
	New (argOperClass,argOperName,%EpisodeID,%ExtraData,%ErrorData)
	Set return=0
	
	Set $ZT="GetOperClassByOASErrs"
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Quit:argOperClass=""
	Set OperClassList=argOperClass
	If (argOperName'="") {
		Set OperNameList=##Class(DHCMed.CCService.Lib.Common).GetListFromString(argOperName,"|")
	} Else {
		Set OperNameList=""
	}
	
	Set OperArr=0
	For {
		Set OperArr=$o(^DHCANOPArrange(0,"Adm",+%EpisodeID,OperArr))
		Quit:OperArr=""
		
		Set OperStatus=$p($g(^DHCANOPArrange(OperArr)),"^",27)
		Continue:OperStatus="NotApp"
		Set AnaRowID=$p($g(^DHCANOPArrange(OperArr)),"^",2)
		Set Paadm=$p(AnaRowID,"||",1)
		Set AnaChild=$p(AnaRowID,"||",2)
		Continue:(AnaChild="")||(Paadm="")
		Set OperStartDate=$p($g(^DHCANOPArrange(OperArr)),"^",14)
		If OperStartDate'="" {
    		Set OperStartDate=$zd(OperStartDate,3)
    		Set OperStartTime=$p($g(^DHCANOPArrange(OperArr)),"^",15)
			Set OperStartTime=$zt(+OperStartTime,2)
    	} Else {
	    	Set OperStartTime=""
	    }
	   
		Set OPChild=0
		For {
    		Set OPChild=$o(^OR(Paadm,"ANA",AnaChild,"OP",OPChild))
    		Quit:OPChild=""
    		
    		Set AnaOpRowID=Paadm_"||"_AnaChild_"||"_OPChild
    		Set tmpOper=$g(^OR(Paadm,"ANA",AnaChild,"OP",OPChild))
    		Continue:tmpOper=""
    		
    		Set (OperationID,OperationDesc,OperLevelID,OperLevelDesc,OperCategID,OperCategDesc,OperDocID,OperDocDesc)=""
    		
    		Set OperationID=$p(tmpOper,"^",6)
    		If OperationID'="" {
	    		Set OperationDesc=$p($g(^ORC("OPER",OperationID)),"^",2)
	    		//手术等级
	    		Set OperCategID=$p($g(^ORC("OPER",OperationID)),"^",7)
	    		Set:OperCategID'="" OperCategDesc=$p($g(^ORC("CATEG",OperCategID)),"^",2)
    		} Else {
	    		Set RemSubID=$o(^OR(Paadm,"ANA",AnaChild,"OP",OPChild,"REM",""),-1)
	    		Set:(+RemSubID)>0 OperationDesc=$g(^OR(Paadm,"ANA",AnaChild,"OP",OPChild,"REM",RemSubID))
	    	}
    		
			//切口级别
			Set tmpCuteTypeDesc=""
			Set tmpCuteTypeID=$p($g(^OR(Paadm,"ANA",AnaChild,"OP",OPChild)),"^",9)
			Set:tmpCuteTypeID'="" tmpCuteTypeDesc=$p($g(^ORC("BLDTP",tmpCuteTypeID)),"^",2)
			
	    	If (OperClassList'="") {
				Continue:tmpCuteTypeID=""
				Continue:tmpCuteTypeID'[OperClassList
			}
    		Set OperDoc=$p(tmpOper,"^",8)
    		Set tmpOperDocDesc=$p($g(^CTPCP(+OperDoc)),"^",2)
			Set:OperDoc'="" OperDoc=$o(^SSU("SSUSR",0,"CTPCP",OperDoc,0))
			Set objSSUser=##class(DHCMed.Base.SSUser).GetObjById(OperDoc)
			If $IsObject(objSSUser) {
				Set OperDocID=objSSUser.Rowid
				Set OperDocDesc=objSSUser.Name
			}
			Set:(OperDocDesc="")&&(tmpOperDocDesc'="") OperDocDesc="*"_tmpOperDocDesc
			
			//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
			Set Record=""
			Set $p(Record,$c(3),1)=$s(tmpCuteTypeDesc'="":OperationDesc_"("_tmpCuteTypeDesc_")",1:OperationDesc)_" "_OperStartDate_" "_OperStartTime
			Set:OperStartDate["-" OperStartDate=$zdh(OperStartDate,3)
			Set:OperStartTime[":" OperStartTime=$zth(OperStartTime,2)
			
			
			Set $p(Record,$c(3),2)=OperStartDate
			Set $p(Record,$c(3),3)=OperStartTime
			Set $p(Record,$c(3),4)=OperationDesc
			Set $p(Record,$c(3),5)=AnaOpRowID
			Set $p(Record,$c(3),6)=+OperDocID
			Set $p(Record,$c(3),7)="argOperClass:"_argOperClass_",argOperName:"_argOperName_"***"
			Set %ExtraData=%ExtraData_$lb(Record)
			Set return=return+1
			
    	}
	}
	
	Quit return
	
GetOperClassByOASErrs
	Quit 0
}

}

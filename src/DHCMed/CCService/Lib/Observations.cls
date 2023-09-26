/// 名称: DHCMed.CCService.Lib.Observations
/// 描述: 与体温单相关的函数库
/// 编写者：zhufei
/// 编写日期: 2011-03-23
Class DHCMed.CCService.Lib.Observations Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.Observations).Test()
ClassMethod Test()
{
	New
	
	/*
	Set %EpisodeID=18214743
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckOBSItemByInterface("37-38")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	*/
	
	Set %EpisodeID=20882284
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckIOOBSItemByDays("37-38")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2011-03-18
/// Description:  通过检查范围筛选体温异常数量
/// Table：       MR_Observations
/// Input：       Input: "36-37.5"
/// Return：      返回体温异常数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.Observations).CheckOBSItem("36-37.5")
ClassMethod CheckOBSItem(argInput As %String) As %String
{
	New (argInput,%EpisodeID,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:argInput="" return
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckOBSItemErr"
	Set argInput=$tr(argInput,"~","-")
	Set argInput=$tr(argInput,"|","-")
	Set argInput=$tr(argInput,"/","-")
	Set argInput=$tr(argInput,"\","-")
	Set argInput=$tr(argInput,",","-")
	Set argInput=$tr(argInput,"、","-")
	Set argInput=$tr(argInput,"，","-")
	Set argInput=$tr(argInput," ","")
	Set tmpOBSL=+$p(argInput,"-",1)
	Set tmpOBSH=+$p(argInput,"-",2)
	Quit:(tmpOBSL<1)||(tmpOBSH<tmpOBSL) return
	Set MRAdm=##class(DHCMed.CCService.Lib.Common).GetMRAdm(%EpisodeID)
	Quit:MRAdm="" return
	
	Set SubID=0
    For {
		Set SubID=$o(^MR(MRAdm,"OBS",SubID))
		Quit:SubID=""
		Set ItemDR=$p($g(^MR(MRAdm,"OBS",SubID)),"^",1)
		Continue:'$d(^MRC("OBITM",+ItemDR))
		Set ItemDesc=$p($g(^MRC("OBITM",+ItemDR)),"^",2)
    	Continue:(ItemDesc'="体温")&&(ItemDesc'="腋温")&&(ItemDesc'="口温")&&(ItemDesc'="肛温")
    	Set Value=+$p($g(^MR(MRAdm,"OBS",SubID)),"^",2)
    	Continue:Value<30		//add by liuyh 2013-03-07 过滤护士录入错误数据
    	Continue:(Value>=tmpOBSL)&&(Value<=tmpOBSH)
    	Set OSBDate=$p($g(^MR(MRAdm,"OBS",SubID)),"^",3)
    	Set OSBTime=$p($g(^MR(MRAdm,"OBS",SubID)),"^",4)
    	Set OSBUser=$p($g(^MR(MRAdm,"OBS",SubID)),"^",5)
    	;Set:OSBDate'="" OSBDate=$zd(OSBDate,3)
    	;Set:OSBTime'="" OSBTime=$zd(OSBTime,2)
    	;Set:OSBUser'="" OSBUser=$p($g(^SSU("SSUSR",OSBUser)),"^",2)
    	
    	Set Count=Count+1
    	Set OSBItemRst=ItemDesc_Value_"度"
    	
    	Set TempData=""
		Set $p(TempData,$c(3),1)=OSBItemRst
		Set $p(TempData,$c(3),2)=+OSBDate
		Set $p(TempData,$c(3),3)=+OSBTime
		Set $p(TempData,$c(3),4)=+Value
		Set $p(TempData,$c(3),5)=MRAdm_"||"_SubID
		Set $p(TempData,$c(3),6)=OSBUser
		Set $p(TempData,$c(3),7)="argInput"_argInput
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	
	Set return=Count
	Quit return
	
CheckOBSItemErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2013-04-11
/// Description:  通过检查范围筛选体温异常数量(通过表DHCMed_NINF_Srv.NurseManage)
/// Table：       MR_Observations
/// Input：       Input: "36-37.5"
/// Return：      返回体温异常数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.Observations).CheckOBSItemByInterface("36-37.5")
ClassMethod CheckOBSItemByInterface(argInput As %String) As %String
{
	New (argInput,%EpisodeID,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:argInput="" return
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckOBSItemByInterfaceErr"
	Set argInput=$tr(argInput,"~","-")
	Set argInput=$tr(argInput,"|","-")
	Set argInput=$tr(argInput,"/","-")
	Set argInput=$tr(argInput,"\","-")
	Set argInput=$tr(argInput,",","-")
	Set argInput=$tr(argInput,"、","-")
	Set argInput=$tr(argInput,"，","-")
	Set argInput=$tr(argInput," ","")
	Set tmpOBSL=+$p(argInput,"-",1)
	Set tmpOBSH=+$p(argInput,"-",2)
	Quit:(tmpOBSL<34)||(tmpOBSH<tmpOBSL) return
	
	Set NMID=0
	For {
		Set NMID=$O(^DHCMed.NINFSi("NurseManage",0,"IndexEpisodeID"," "_%EpisodeID,NMID))
		Quit:NMID=""
		
		Set ObjNurMessage=##Class(DHCMed.NINF.Srv.NurseManage).%OpenId(NMID)
		Continue:'$IsObject(ObjNurMessage)
		Do ObjNurMessage.%Close()
		
		Set ItemName=ObjNurMessage.ItemName
		Continue:(ItemName'="体温")&&(ItemName'="腋温")&&(ItemName'="口温")&&(ItemName'="肛温")
		Set ItemValue=ObjNurMessage.ItemValue
		Continue:+ItemValue<34 ;过滤错误数据
		Continue:(+ItemValue>=tmpOBSL)&&(+ItemValue<=tmpOBSH)
		Set EntryDate=ObjNurMessage.EntryDate
		Set EntryTime=ObjNurMessage.EntryTime
		
		Set Count=Count+1
		Set OSBItemRst="体温异常；"_ItemName_ItemValue_"度"
		
		Set TempData=""
		Set $p(TempData,$c(3),1)=OSBItemRst
		Set $p(TempData,$c(3),2)=+EntryDate
		Set $p(TempData,$c(3),3)=+EntryTime
		Set $p(TempData,$c(3),4)=+ItemValue
		Set $p(TempData,$c(3),5)=NMID
		Set $p(TempData,$c(3),6)=""
		Set $p(TempData,$c(3),7)="argInput"_argInput
		Set %ExtraData=%ExtraData_$lb(TempData)
	}	
	
	Set return=Count
	Quit return
	
CheckOBSItemByInterfaceErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2013-06-13
/// Description:  通过检查范围筛选体温异常数量(通过表DHCMed_NINF_Srv.NurseManage)
/// Table：       MR_Observations
/// Input：       Input: "36-37.5"
/// Return：      返回体温异常数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.Observations).CheckIOOBSItemByDays("36-37.5")
ClassMethod CheckIOOBSItemByDays(argInput As %String) As %String
{
	New (argInput,%EpisodeID,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:argInput="" return
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckIOOBSItemByDaysErr"
	
	Set NIndex="CheckIOOBSItemByDays"
	Kill ^TMP($zn,$j,NIndex)
	
	Set argInput=$tr(argInput,"~","-")
	Set argInput=$tr(argInput,"|","-")
	Set argInput=$tr(argInput,"/","-")
	Set argInput=$tr(argInput,"\","-")
	Set argInput=$tr(argInput,",","-")
	Set argInput=$tr(argInput,"、","-")
	Set argInput=$tr(argInput,"，","-")
	Set argInput=$tr(argInput," ","")
	Set tmpOBSL=+$p(argInput,"-",1)
	Set tmpOBSH=+$p(argInput,"-",2)
	Quit:(tmpOBSL<34)||(tmpOBSH<tmpOBSL) return
	
	Set NMID=0
	For {
		Set NMID=$O(^DHCMed.NINFSi("NurseManage",0,"IndexEpisodeID"," "_%EpisodeID,NMID))
		Quit:NMID=""
		
		Set ObjNurMessage=##Class(DHCMed.NINF.Srv.NurseManage).%OpenId(NMID)
		Continue:'$IsObject(ObjNurMessage)
		Do ObjNurMessage.%Close()
		
		Set ItemName=ObjNurMessage.ItemName
		Continue:(ItemName'="体温")&&(ItemName'="腋温")&&(ItemName'="口温")&&(ItemName'="肛温")
		Set ItemValue=ObjNurMessage.ItemValue
		Continue:+ItemValue<34 ;过滤错误数据
		Continue:(+ItemValue>=tmpOBSL)&&(+ItemValue<=tmpOBSH)
		Set EntryDate=ObjNurMessage.EntryDate
		Set EntryTime=ObjNurMessage.EntryTime
		
		Set ^TMP($zn,$j,NIndex,%EpisodeID,+EntryDate,NMID)=$lb(NMID,ItemName,ItemValue,EntryDate,EntryTime)
	}
	
	Set xDate=""
	For {
		Set xDate=$o(^TMP($zn,$j,NIndex,%EpisodeID,xDate),-1)
		Quit:xDate=""
		
		Set yDate=$o(^TMP($zn,$j,NIndex,%EpisodeID,xDate),-1)
		Continue:yDate=""
		Continue:(xDate-yDate)>1
		
		//当天数据
		Set xOSBItemRst=""
		Set xID=""
		For {
			Set xID=$o(^TMP($zn,$j,NIndex,%EpisodeID,xDate,xID),-1)
			Quit:xID=""
			
			Set tmpData=$g(^TMP($zn,$j,NIndex,%EpisodeID,xDate,xID))
			If xOSBItemRst="" {
				Set NMID=xID
				Set ItemName=$list(tmpData,2)
				Set ItemValue=$list(tmpData,3)
				Set EntryDate=$list(tmpData,4)
				Set EntryTime=$list(tmpData,5)
				Set xOSBItemRst=$zd(xDate,3)_ItemName_" "_ItemValue_"度"
			} Else {
				Set ItemValue=$list(tmpData,3)
				Set xOSBItemRst=xOSBItemRst_" "_ItemValue_"度"
			}
		}
		Continue:xOSBItemRst=""
		
		//前天数据
		Set yOSBItemRst=""
		Set xID=""
		For {
			Set xID=$o(^TMP($zn,$j,NIndex,%EpisodeID,yDate,xID),-1)
			Quit:xID=""
			
			Set tmpData=$g(^TMP($zn,$j,NIndex,%EpisodeID,yDate,xID))
			If yOSBItemRst="" {
				Set NMID=xID
				Set ItemName=$list(tmpData,2)
				Set ItemValue=$list(tmpData,3)
				Set EntryDate=$list(tmpData,4)
				Set EntryTime=$list(tmpData,5)
				Set yOSBItemRst=$zd(yDate,3)_ItemName_" "_ItemValue_"度"
			} Else {
				Set ItemValue=$list(tmpData,3)
				Set yOSBItemRst=yOSBItemRst_" "_ItemValue_"度"
			}
		}
		Continue:yOSBItemRst=""
		
		Set OSBItemRst="持续体温异常："_xOSBItemRst_","_yOSBItemRst
		
		Set Count=Count+1
		
		Set TempData=""
		Set $p(TempData,$c(3),1)=OSBItemRst
		Set $p(TempData,$c(3),2)=+EntryDate
		Set $p(TempData,$c(3),3)=+EntryTime
		Set $p(TempData,$c(3),4)=OSBItemRst
		Set $p(TempData,$c(3),5)=xDate
		Set $p(TempData,$c(3),6)=""
		Set $p(TempData,$c(3),7)="argInput"_argInput
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	Kill ^TMP($zn,$j,NIndex)
	
	Set return=Count
	Quit return
	
CheckIOOBSItemByDaysErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

}

/// 名称: DHCMed.CCService.Lib.EPRV2Data
/// 描述: 与2.0版电子病历相关的函数库
/// 编写者：zhufei
/// 编写日期: 2011-04-22
Class DHCMed.CCService.Lib.EPRV2Data Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.EPRV2Data).Test()
ClassMethod Test()
{
	New
	Set %EpisodeID=68160
	
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckSingleData("首次病程记录#TYPE:Segment#TID:28#TVER:0#GCODE:G0001","综上初步诊断")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckMultiData("历次病程记录#TYPE:TextDesc#TID:32#TVER:0#ECODE:E0001","麻醉意外")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2011-03-18
/// Description:  通过关键字检查唯一模板的单元值
/// Table：       
/// Input：       Input: "唯一模板单元","霍乱"
/// Return：      ret=-1：Error，ret=0：不包含，ret=1：包含
/// w ##class(DHCMed.CCService.Lib.EPRV2Data).CheckSingleData(单元Code,关键字)
ClassMethod CheckSingleData(argElCode As %String, argDesc As %String) As %String
{
	New (argElCode,argDesc,%EpisodeID,%ExtraData,%ErrorData)
	Set return=0
	Quit:(argElCode="")||(argDesc="") return
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckSingleDataErr"
	Set EPRData=##class(EPRservice.BOScatterData).GetEPRData(%EpisodeID,argElCode)
	Set EPRData=$tr(EPRData,$c(13),";")
	Quit:EPRData="" return
	Quit:EPRData'[argDesc return
	
	Set return=1
	Set EPRRst=EPRData
	Set ElDesc=$p(argElCode,"#TYPE",1)
	Set:ElDesc'="" EPRRst=$$BuildCheckSingleDataResult(1)
	Set %ExtraData=%ExtraData_$lb(EPRRst)
	
	Quit return
	
CheckSingleDataErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildCheckSingleDataResult(arg0) //Add By LiYang 2012-06-20
	Set tmpDesc=EPRRst_"("_ElDesc_")"
		//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=0 //日期
	Set $p(tmp,$c(3),3)=0 //事件
	Set $p(tmp,$c(3),4)=tmpDesc
	Set $p(tmp,$c(3),5)=0 //ID
	Set $p(tmp,$c(3),6)=0 //User ID
	Set $p(tmp,$c(3),7)="argElCode="_argElCode_";argDesc="_argDesc
	Quit tmp
}

/// Creator：     zhufei
/// CreatDate：   2011-03-18
/// Description:  通过关键字检查可重复模板的单元值
/// Table：       
/// Input：       Input: "可重复模板单元","霍乱"
/// Return：      ret=-1：Error，ret=0：不包含，ret=1：包含
/// w ##class(DHCMed.CCService.Lib.EPRV2Data).CheckMultiData(单元Code,关键字)
ClassMethod CheckMultiData(argElCode As %String, argDesc As %String) As %String
{
	New (argElCode,argDesc,%EpisodeID,%ExtraData,%ErrorData)
	Set return=0
	Quit:(argElCode="")||(argDesc="") return
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckMultiDataErr"
	Set TemplateID=$p($p(argElCode,"#TID:",2),"#",1)
	Quit:TemplateID="" return
	Set CatalogID="",Count=0
	For {
		Set CatalogID=$o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_%EpisodeID,CatalogID))
		Quit:CatalogID=""
		Set ECRecordID=""
		For {
			Set ECRecordID=$o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_%EpisodeID,CatalogID,ECRecordID))
			Quit:ECRecordID=""
			Set objECRecord=##class(EPRinstance.ECRecord).%OpenId(ECRecordID)
			Continue:objECRecord=""
			Continue:objECRecord.ChartItemType'="Multi"  //  Multi-可重复模板 Single-唯一模板
			Set ChildSub=0
			For {
				Set ChildSub=$o(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,ChildSub))
				Quit:ChildSub=""
				Set InstanceID=ECRecordID_"||"_ChildSub
				Set objInstance = ##class(EPRinstance.InstanceData).%OpenId(InstanceID)
				Continue:objInstance.Status="UnSave"
				Continue:(TemplateID'="")&&(objInstance.TemplateID'=TemplateID)
				Set EPRData=##class(EPRservice.BOScatterData).GetEPRMultipleData(%EpisodeID,argElCode,InstanceID)
				Set EPRData=$tr(EPRData,$c(13),";")
				Continue:EPRData=""
				Continue:EPRData'[argDesc
				
				Set Count=Count+1
				Set HappenDate=objInstance.HappenDate
				Set HappenTime=objInstance.HappenTime
				Set:HappenDate'="" HappenDate=$zd(HappenDate,3)
				Set:HappenTime'="" HappenTime=$zt(HappenTime,1)
				Set Title=objInstance.Title
				Set EPRRst=$$BuildCheckMultiDataResult(1)
				Set %ExtraData=%ExtraData_$lb(EPRRst)
			}
		}
	}
	Set return=Count
	Quit return
	
CheckMultiDataErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildCheckMultiDataResult(arg0) //Add By LiYang 2012-06-20
	Set tmpDesc=HappenDate_" "_HappenTime_" "_Title
		//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set objUser=##class(DHCMed.Base.SSUser).GetByCTPCP(+objDia.DocCodeDr)
	Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
	Do objUser.%Close()
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=objInstance.HappenDate
	Set $p(tmp,$c(3),3)=objInstance.HappenTime
	Set $p(tmp,$c(3),4)=tmpDesc
	Set $p(tmp,$c(3),5)=objInstance.%Id()
	Set $p(tmp,$c(3),6)=+objInstance.CreateUser
	Set $p(tmp,$c(3),7)="argElCode="_argElCode_";argDesc="_argDesc
	Quit tmp
}

}

/// 编写者：李阳
/// 创建日期：2013-12-08
/// 功能：抽取电子病历数据
Class DHCMed.DPCustom.Meta.HIS.EmrProgressNote Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 抽取诊断数据
/// FromDate:出院日期的开始日期
/// ToDate：出院日期的结束日期
/// 注意：一般患者出院后才会填写首页，所以FromDate和ToDate的日期要往前提几天。
ClassMethod ExtractData(FromDate As %Date, ToDate As %Date) As %String
{
	
	For tmpDate=FromDate:1:ToDate {
		Set RecID=""
		For {
			Set RecID=$o(^DHCEPRI.InstanceDataI("IdxModifyDate",tmpDate,RecID))
			Quit:RecID=""
			Set InsChild=""
			For {
				Set InsChild=$o(^DHCEPRI.InstanceDataI("IdxModifyDate",tmpDate,RecID,InsChild))
				Quit:InsChild=""
				Set InsID=RecID_"||"_InsChild
				Set objIns=##class(EPRinstance.InstanceData).%OpenId(InsID)
				Continue:'$IsObject(objIns)
				Do objIns.%Close()
				Set TemplateVerID=objIns.TemplateVersion
				Set tmpInsID=" "_InsID
				Set ret=""
				Set ret=$$ITextDesc(tmpInsID)					
				Set:ret="" ret=$$ISegment(tmpInsID)
				Continue:ret=""
				Set tmp=$$ExtractProgNote(objIns.TheECRecord.EpisodeID,ret,objIns)
			}			
		}
	}
	Quit 1
	
ITextDesc(tmpInsID)	
	n (tmpInsID)
	Set ret=0
	Set tmpContent=""
	Set Code=""
	For {
		Set Code=$o(^DHCEPRI.ITextDescI("IdxForUpdate",tmpInsID,Code))
		Quit:Code=""
		Set RowID=0
		For {
			Set RowID=$o(^DHCEPRI.ITextDescI("IdxForUpdate",tmpInsID,Code,RowID))
			Quit:RowID=""
			Set objData=##class(EPRinstance.ITextDesc).%OpenId(RowID)
			Continue:'$IsObject(objData)
			For {
				Quit:objData.Text.AtEnd
				Set Line=objData.Text.ReadLine()
				w "ITextDesc"_Line,!
				Set:tmpContent'="" tmpContent=tmpContent_$c(13,10)
				Set tmpContent=tmpContent_Line
			}
			Do objData.%Close()
		}	
	}
	Quit tmpContent		

ISegment(tmpInsID)	
	n (tmpInsID)
	Set ret=0
	Set tmpContent=""
	Set Code=""
	For {
		Set Code=$o(^DHCEPRI.ISegmentI("IdxForUpdate",tmpInsID,Code))
		Quit:Code=""
		Set RowID=""
		For {
			Set RowID=$o(^DHCEPRI.ISegmentI("IdxForUpdate",tmpInsID,Code,RowID))
			Quit:RowID=""
			Set objData=##class(EPRinstance.ISegment).%OpenId(RowID)
			Continue:'$IsObject(objData)
			For {
				Quit:objData.Text.AtEnd
				Set Line=objData.Text.ReadLine()
				w "ITextDesc"_Line,!				
				Set:tmpContent'="" tmpContent=tmpContent_$c(13,10)
				Set tmpContent=tmpContent_Line
			}
			Do objData.%Close()
		}	
	}
	Quit tmpContent	
	
ExtractProgNote(EpisodeID,Contnent,objIns)
	n (EpisodeID,Contnent,objIns)
		
	//保存ActMain
	Set strArg=""
	Set $p(strArg,"^",1)=""
	Set $p(strArg,"^",2)=EpisodeID
	Set $p(strArg,"^",3)="MR"
	Set $p(strArg,"^",4)="MR-EMR-PN"
	Set $p(strArg,"^",5)=objIns.ModifyDate
	Set $p(strArg,"^",6)=Contnent
	Set $p(strArg,"^",7)=objIns.%Id()
	Set $p(strArg,"^",8)="" //XDate
	Set $p(strArg,"^",9)=1 //IsActive
	Set $p(strArg,"^",10)=+$h
	Set $p(strArg,"^",11)=$p($h,",",2)
	Set $p(strArg,"^",12)=""
	Set ActMainID=##class(DHCMed.DP.Meta.ActMain).Update(strArg)
		
	Set strArg=""
	Set $p(strArg,$c(1),1)=""
	Set $p(strArg,$c(1),2)=ActMainID
	Set $p(strArg,$c(1),3)="MR-EMR-PN"
	Set $p(strArg,$c(1),4)=objIns.%Id()
	Set $p(strArg,$c(1),5)=objIns.ModifyDate
	Set $p(strArg,$c(1),6)=objIns.ModifyTime
	Set $p(strArg,$c(1),7)="" //Title
	Set $p(strArg,$c(1),8)=Contnent
	Set $p(strArg,$c(1),9)="" //EPNKeyWords
	Set $p(strArg,$c(1),10)="" //EPNResume
	Set ret=##class(DHCMed.DP.Meta.EmrProgressNote).Update(strArg,$c(1))
	Quit 1
}

/// w ##class(DHCMed.DPCustom.Meta.HIS.EmrProgressNote).Test()
ClassMethod Test()
{
	w ##class(DHCMed.DPCustom.Meta.HIS.EmrProgressNote).ExtractData($zdh("2008-01-01",3),$zdh("2014-01-01",3))
	Quit ""
}

}

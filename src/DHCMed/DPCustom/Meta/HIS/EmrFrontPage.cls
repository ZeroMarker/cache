/// 编写者：李阳
/// 创建日期：2013-12-08
/// 功能：抽取电子病历首页
Class DHCMed.DPCustom.Meta.HIS.EmrFrontPage Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// 抽取诊断数据
/// FromDate:出院日期的开始日期
/// ToDate：出院日期的结束日期
/// 注意：一般患者出院后才会填写首页，所以FromDate和ToDate的日期要往前提几天。
ClassMethod ExtractData(FromDate As %Date, ToDate As %Date) As %String
{

	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For tmpDate=FromDate:1:ToDate {
		For {
			Set EpisodeID=$o(^PAADMi(DischDateIndex,tmpDate,EpisodeID))
			Quit:EpisodeID=""
			Continue:$d(^PAADMi("PAADM_Type","I",EpisodeID))=0
			Set tmpRet=$$ExtractFPData(EpisodeID)
		}	
	}
	
ExtractFPData(EpisodeID)
	n (EpisodeID)
	//保存ActMain
	Set strArg=""
	Set $p(strArg,"^",1)=""
	Set $p(strArg,"^",2)=EpisodeID
	Set $p(strArg,"^",3)="MR"
	Set $p(strArg,"^",4)="MR-EMR-FP"
	Set $p(strArg,"^",5)=objDia.DiaDate
	Set $p(strArg,"^",6)=objDia.ICD9CMCode_"--"_objDia.ICDDesc
	Set $p(strArg,"^",7)=PAADMMainMRADMDR_"||"_ChildSub
	Set $p(strArg,"^",8)="" //XDate
	Set $p(strArg,"^",9)=1 //IsActive
	Set $p(strArg,"^",10)=+$h
	Set $p(strArg,"^",11)=$p($h,",",2)
	Set $p(strArg,"^",12)=objDia.AliasDiagText
	Set ActMainID=##class(DHCMed.DP.Meta.ActMain).Update(strArg)
	
	Quit 1
}

}

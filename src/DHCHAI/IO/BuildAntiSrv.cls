/// 名称: DHCHAI.IO.BuildAntiSrv（DHCAnt.Serve.ComOut）
/// 描述: 创建抗菌用药接口类方法
/// 编写者：zhufei
/// 编写日期: 2017-03-23
Class DHCHAI.IO.BuildAntiSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// CTOR: QP
/// SENO: F0005
/// DATE: 2018-03-23
/// DESC: 获取抗菌药物的使用情况信息
/// IN  : 医嘱项ID
/// OUT : 使用目的、其他原因、是否送检、感染部位、申请日期、申请时间
/// EXEC: w ##class(DHCAnt.Serve.ComOut).GetAntUseInfo("650||202")
ClassMethod GetAntUseInfo(oeori As %String)
{
	n (oeori)
	
	s mRtn=""
	q:oeori="" mRtn
	s daupId=$o(^DAUP("OEORI",oeori,0))
	s aimId=$p(^DAUP("DAUP",daupId),"^",20)			//使用目的ID
	s aimDesc=""									//使用目的
	s otherReason=$p(^DAUP("DAUP",daupId),"^",12)	//其他原因
	s isSJ=$p(^DAUP("DAUP",daupId),"^",15)			//是否送检
	i isSJ="Y" s isSJ=1
	i (isSJ="N")||(isSJ="") s isSJ=0
	s infectPartId=$p(^DAUP("DAUP",daupId),"^",6)	//感染部位ID
	s infectPartDesc=""								//感染部位
	s appDate=$p(^DAUP("DAUP",daupId),"^",4)			//开具日期
	s appTime=$p(^DAUP("DAUP",daupId),"^",14)		//开具时间
	s newVersion=..ComIsNewKSSVersion()
	i newVersion=1 d
	.i aimId'="" s aimDesc=$p(^DHCAntBasePurposeDataConfigD(aimId),"^",3)
	.i infectPartId'="" s infectPartDesc=$p(^DHCAntBasePurposeDataConfigD(infectPartId),"^",3)	
 	e  d
 	.i aimId'="" s aimDesc=$p(^DTAUP("AUP",aimId),"^",2)
 	.i infectPartId'="" s infectPartDesc=$li(^User.DHCDocInfPartD(infectPartId),3)
 	s mRtn=aimId_"^"_aimDesc_"^"_otherReason_"^"_isSJ_"^"_infectPartId_"^"_infectPartDesc_"^"_appDate_"^"_appTime
	
	q mRtn
}

/// CTOR: QP
/// SENO: F0005
/// DATE: 2018-03-23
/// DESC: 是否抗菌药物新版
/// IN  : 
/// OUT : 返回1或0,1为是，0为否
/// EXEC: w ##class(DHCAnt.Serve.ComOut).ComIsNewKSSVersion()
ClassMethod ComIsNewKSSVersion(oeori As %String)
{
	n 
	s $zt="ReturnZero"
	s mRtn=0
	i $d(^DHCAntBaseMainConfigD) s mRtn=1
	q mRtn
	
ReturnZero
	q 0
}

}

/// 名称: 	  DHCWMR.IO.ToEnsSrv
/// 描述: 	  To集成平台组接口程序
/// 编写者：  朱飞
/// 编写日期: 2015-11-24
Class DHCWMR.IO.ToEnsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-11-24
/// Description:  保存病历报告记录（To集成平台）
/// Table：       DHCWMR.FP.PathologRep
/// Input：       InputStr ：“就诊号^病理号^病理报告ID^报告日期^报告时间^报告人^病理诊断”
/// 	Return：	  成功:>0 失败:<0
/// w ##class(DHCWMR.IO.ToEnsSrv).ISavePathologRep("223^1^1^2015-11-30^51569^9^病理诊断")
ClassMethod ISavePathologRep(aInputStr As %String, ByRef ErrMsg As %String = "") As %String
{
	New (aInputStr,ErrMsg)
	Set return="",ErrMsg="-1:参数错误"
	Quit:aInputStr="" return
	
	Set $ZT="ISavePathologRepErr"
	
	Set EpisodeID 	= $p(aInputStr,"^",1)
	Set Number 		= $p(aInputStr,"^",2)
	Set ReportID 	= $p(aInputStr,"^",3)
	Set RepDate 	= $p(aInputStr,"^",4)
	Set RepTime 	= $p(aInputStr,"^",5)
	Set RepUser 	= $p(aInputStr,"^",6)
	Set Diagnos 	= $p(aInputStr,"^",7)
	
	Quit:(EpisodeID="")||(Number="")||(ReportID="")||(RepDate="")||(RepTime="")||(RepUser="")||(Diagnos="") return
	
	Set ErrMsg="-2:保存报告错误"
	Set InputStr=""
	Set $p(InputStr,"^",1)=""
	Set $p(InputStr,"^",2)=EpisodeID
	Set $p(InputStr,"^",3)=Number
	Set $p(InputStr,"^",4)=ReportID
	Set $p(InputStr,"^",5)=RepDate
	Set $p(InputStr,"^",6)=RepTime
	Set $p(InputStr,"^",7)=RepUser
	Set $p(InputStr,"^",8)=Diagnos
	Set $p(InputStr,"^",9)=0
	Set $p(InputStr,"^",10)=""
	Set $p(InputStr,"^",11)=""
	Set $p(InputStr,"^",12)=""
	Set ret = ##Class(DHCWMR.FP.PathologRep).Update(InputStr,"^")
	Set return = ret
	Quit return
	
ISavePathologRepErr
	 Set ErrMsg="-999:"_$ZE
     Quit return
}

}

/// 名称:     web.DHCLabKnowledgeBase
/// 描述:     检验知识库
/// 编写者：  huhm
/// 编写日期: 20150128
Class web.DHCLabKnowledgeBase Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

//##Class(web.DHCLabKnowledgeBase).CreateLibData(100005,"B001","1")

/// Creator：      huhm
/// CreatDate：    20150128
/// Description:： 把检验报告结果发送到知识库的数据池
/// Table：        
/// Input：        检验号,医嘱,序号
/// Output：       
/// Return：        
/// Others：   
ClassMethod CreateLibData(Labno, TS, TSCnt) As %String
{
	//
	s tc="" f  s tc=$o(^TEPI(Labno,1,TS,TSCnt,"DATA",tc)) q:tc=""  d
	.s Result=$Piece(^TEPI(Labno,1,TS,TSCnt,"DATA",tc),"\",1)
	.i '$l(Result) q
	.s ResStr=##Class(LabService.TCCommon).GetTestCodeResult(Labno,tc,Result,TS,TSCnt)
	.s TestName=$Piece(ResStr,$c(2),2)
	.s TestSync=$Piece(ResStr,$c(2),7)
	.s Result=$Piece(ResStr,$c(2),3)
	.s ResFlag=$Piece(ResStr,$c(2),5)
	.s Unit=$Piece(ResStr,$c(2),4)
	.s Ranges=$Piece($Piece(ResStr,$c(2),6),"~",1,2)
	.s AuthDate=$p(^TEPI(Labno,1,TS,TSCnt),"\",4)
	.s AuthTime=$p(^TEPI(Labno,1,TS,TSCnt),"\",5)
	.s DebtorNo=$p(^TEPI(Labno),"\",18)
	.s Adm=$P($p(^TEPI(Labno),"\",37),",",2)
	.i '$l(Adm) d
	..s OrdId=$o(^OEORD(0,"Epis",Labno,""))
	..s Adm=$p($g(^OEORD(OrdId)),"^",1)
	.i $l(AuthTime) s AuthTime=AuthTime*60
	.//日期^时间^病人id^就诊id^报告号^项目^结果值^单位^类型(检验L,检查C)
	.s Input=AuthDate_"^"_AuthTime_"^"_DebtorNo_"^"_Adm_"^"_Labno_"||"_TS_"||"_TSCnt_"^"_tc_"^"_Result_"^"_Unit_"^L"
	.s ret=##class(web.DHCSTPHCMPASS).CreateLibData(Input)
	.//s ^TMPKnow(Labno,tc)=Input
	.//w !,Input
	q 0
}

}

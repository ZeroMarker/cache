/// 获取Lis数据的公共库
Class DHCMed.CCService.Lib.CommonLis Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// w ##class(DHCMed.CCService.Lib.CommonLis).GetBugList("261||F053||1")
ClassMethod GetBugList(TestSetRow As %String) As %String
{
		n (TestSetRow)
		Set ret=""
		Set Epis=$p(TestSetRow,"||",1)
		Set TS=$p(TestSetRow,"||",2)
		Set TSCount=$p(TestSetRow,"||",3)
		Quit:(Epis="")||(TS="")||(TSCount="") ret
		Quit:$p($g(^TEPI(Epis,1,TS,TSCount)),"\",31)'="A" ret //Add By LiYang 2012-12-28 FixBug 检验结果未过滤掉未审核结果

		Set BugResult=""
		Set ItmCode=""
		For {
			Set ItmCode=$o(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode))
			Quit:ItmCode=""
			Set RstType=$p($g(^TTAB("TC",ItmCode)),"\",3)
			Continue:RstType'="V"
			Set Result=$p($g(^TEPI(Epis,1,TS,TSCount,"DATA",ItmCode)),"\",1)
			Continue:Result=""
			Set tmpResult=$P($g(^TTAB("BUG",Result)),"\",1)           //细菌名称
			Set tmpWHONetCode=$P($g(^TTAB("BUG",Result)),"\",8)       //add by wuqk 2012-08-31 细菌whonet码 表：CT _Bugs  字段：CTBUG_Synonym
			Continue:"未检出致病菌^未检查出菌^无菌生长"[tmpResult   //removed by wuqk 2012-08-31 
			Continue:tmpWHONetCode="xxx"                              //add by wuqk 2012-08-31 
			Set:tmpWHONetCode="" tmpWHONetCode="xxxxx"
			Continue:tmpResult=""
			Continue:tmpWHONetCode=""
			Continue:(tmpWHONetCode["正常")||(tmpWHONetCode["无细菌生长")
			Set:BugResult'="" BugResult=BugResult_$c(1)
			Set BugResult=BugResult_tmpWHONetCode_"^"_tmpResult
		}
		set BugResult=BugResult
		Set ret=BugResult
		Quit ret
}

}

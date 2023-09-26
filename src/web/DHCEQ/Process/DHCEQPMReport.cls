Class web.DHCEQ.Process.DHCEQPMReport Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQ.Process.DHCEQPMReport).SaveData("1^3^1^保养模版^注释^^^")
ClassMethod SaveData(val, delType)
{
	new PList,rowid
	k PList
	s rowid=""
	s rowid=$p(val,"^",1)
	s PList(2)=$p(val,"^",2)	//PMR_TemplateDR
	s PList(3)=$p(val,"^",3)	//PMR_MaintDR
	s PList(4)=$p(val,"^",4)	//PMR_Caption
	s PList(5)=$p(val,"^",5)	//PMR_Note
	s PList(6)=$p(val,"^",6)	//PMR_PreStat
	s PList(7)=$p(val,"^",7)	//PMR_Stat
	s PList(8)=$p(val,"^",8)	//PMR_Remark
	s PList(9)=0	//PMR_Status
	//i $p(val,"^",9)'="" s PList(9)=$p(val,"^",9)	//PMR_Status
	s PList(10)="N" //PMR_InvalidFlag
	s PList(23)="" //PMR_Hold1
	s PList(24)="" //PMR_Hold2
	s PList(25)="" //PMR_Hold3
	s PList(26)="" //PMR_Hold4
	s PList(27)="" //PMR_Hold5
	if +delType=0
	{
		i (rowid="")
		{
			&SQL(insert into SQLUser.DHC_EQPMReport values :PList())
			s rowid=$g(%ROWID)
		}
		else
		{
			&SQL(Update SQLUser.DHC_EQPMReport values :PList() where PMR_RowID=:rowid)
		}
	}
	elseif +delType=1
	{
		&SQL(Update SQLUser.DHC_EQPMReport set PMR_Status='1' where PMR_RowID=:rowid)
	}
	q:SQLCODE SQLCODE
	q rowid
}

/// w ##Class(web.DHCEQ.Process.DHCEQPMReport).SaveFromPMTemplate("",1)
ClassMethod SaveFromPMTemplate(PMRData, PMTemplateDR, delType)
{
	i $g(PMTemplateDR)="" q -1
	TStart
	s PMRRowID= ##Class(web.DHCEQ.Process.DHCEQPMReport).SaveData(PMRData,delType)
	i PMRRowID'>0 {TRollBack  q PMRRowID}
	s result= ##Class(web.DHCEQ.Process.DHCEQPMReportList).DeleteByReportDR(PMRRowID)
	//modified by zy ZY0156 2016-12-28  索引中增加了排序字段.保存的时候按照排序
	s Sort=0
	for  s Sort=$o(^DHCEQCCode("DHCEQCPMTemplateList",0,"PMTLTemplateDR",PMTemplateDR,Sort)) q:Sort=""  d
	.s TPMTemplateListDR=""
	.for  s TPMTemplateListDR=$o(^DHCEQCCode("DHCEQCPMTemplateList",0,"PMTLTemplateDR",PMTemplateDR,Sort,TPMTemplateListDR)) q:TPMTemplateListDR=""  d
	..s DHCEQTemp=^DHCEQCCode("DHCEQCPMTemplateList",TPMTemplateListDR)
	..s CMaintItemDR=$p(DHCEQTemp,"^",2)	//start by csj 2020-03-30 过滤无效项目
	..s CMaintItemInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMaintItem",CMaintItemDR)),"^",4)
	..s CMaintItemCatDR=$p($g(^DHCEQCCode("DHCEQCMaintItem",CMaintItemDR)),"^",7)
	..s CMaintItemCatInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",CMaintItemCatDR)),"^",5)
	..q:(CMaintItemInvalidFlag="Y")||(CMaintItemCatInvalidFlag="Y") //end by csj 2020-03-30
	..s PMRLData="^"_PMRRowID_"^"_$p(DHCEQTemp,"^",2)_"^"_$p(DHCEQTemp,"^",5)_"^"_$p(DHCEQTemp,"^",3)_"^^"_$p(DHCEQTemp,"^",4)
	..s PMRLRowID= ##Class(web.DHCEQ.Process.DHCEQPMReportList).SaveData(PMRLData)
	..i PMRLRowID'>0 {TRollBack  s result=-2 q }
	i result>0 {TCommit  q PMRRowID}
	else {q result}
}

/// w ##Class(web.DHCEQ.Process.DHCEQPMReport).GetPMTemplate("1")
ClassMethod GetPMTemplate(rowid)
{
	i rowid="" q ""
	new result,resultex
	s (result,resultex)=""
	s result=^DHCEQPMReport(rowid)
	s resultex=resultex_"^"	//PMR_TemplateDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPMTemplate",$p(result,"^",1))),"^",2)
	
	s resultex=result_resultex
	s resultex=##Class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	q resultex
}

}

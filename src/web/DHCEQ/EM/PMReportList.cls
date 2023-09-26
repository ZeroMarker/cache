Class web.DHCEQ.EM.PMReportList Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.PMReportList","GetPMReportList",1)
Query GetPMReportList(ReportDR) As %Query(ROWSPEC = "TRowID:%String,TReportDR:%String,TReportDesc:%String,TMaintItemDR:%String,TMaintItemDesc:%String,TMaintItemCatDR:%String,TMaintItemCatDesc:%String,TResult:%String,TNote:%String,TRemark:%String,TSort:%String")
{
}

ClassMethod GetPMReportListExecute(ByRef qHandle As %Binary, ReportDR) As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
	d BuildDataGetPMReportList
	Quit $$$OK
BuildDataGetPMReportList
	s PMRLRowID=""
	q:$Data(^DHCEQPMReportList(0,"ReportDR",ReportDR))=0 
	f  s PMRLRowID=$o(^DHCEQPMReportList(0,"ReportDR",ReportDR,PMRLRowID)) q:PMRLRowID=""  d
	.q:$p($g(^DHCEQPMReportList(PMRLRowID)),"^",12)="Y"
	.d ResetVariablesGetPMReportList
	.d GetListInfo
	.d OutputRowGetPMReportList
	quit
GetListInfo
	s TRowID=PMRLRowID
	s TReportDR=ReportDR
	i TReportDR'="" s TReportDesc=$p($g(^DHCEQPMReport(TReportDR)),"^",3)
	s TMaintItemDR=$p($g(^DHCEQPMReportList(TRowID)),"^",2)
	i TMaintItemDR'="" d
	.s TMaintItemDesc=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",2)
	.s TMaintItemCatDR=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",7)
	.i TMaintItemCatDR'="" s TMaintItemCatDesc=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",TMaintItemCatDR)),"^",3)
	s TResult=$p($g(^DHCEQPMReportList(TRowID)),"^",3)
	s TNote=$p($g(^DHCEQPMReportList(TRowID)),"^",4)
	s TRemark=$p($g(^DHCEQPMReportList(TRowID)),"^",5)
	s TSort=$p($g(^DHCEQPMReportList(TRowID)),"^",6)
	quit
OutputRowGetPMReportList
	s Data=$lb(TRowID,TReportDR,TReportDesc,TMaintItemDR,TMaintItemDesc,TMaintItemCatDR,TMaintItemCatDesc,TResult,TNote,TRemark,TSort)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPMReportList
	s (TRowID,TReportDR,TReportDesc,TMaintItemDR,TMaintItemDesc,TMaintItemCatDR,TMaintItemCatDesc,TResult,TNote,TRemark,TSort)=""
	quit
}

ClassMethod GetPMReportListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPMReportListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPMReportListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPMReportListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SaveData(PMRLData)
{
	new PList
	s PList(1)=$p($G(PMRLData),"^",1)
	s PList(2)=$p($G(PMRLData),"^",2)
	s PList(3)=$p($G(PMRLData),"^",3)
	s PList(4)=$p($G(PMRLData),"^",4)
	s PList(5)=$p($G(PMRLData),"^",5)
	s PList(6)=$p($G(PMRLData),"^",6)
	s PList(7)=$p($G(PMRLData),"^",7)
	i (PList(1)="")
	{
		k PList(1)
		&SQL(insert into SQLUser.DHC_EQPMReportList values :PList())
	}
	else
	{
		s rowid=PList(1)
		k PList(1)
		&SQL(Update SQLUser.DHC_EQPMReportList values :PList() where PMRL_RowID=:rowid)
	}
	q:SQLCODE SQLCODE
	q $g(%ROWID)
}

/// w ##Class(web.DHCEQ.EM.PMReportList).SaveAllData("1^3^1^保养模版^注释^666^444^555^1","","1")
ClassMethod SaveAllData(ReportData, mydata, delType)
{
	new return,ReportDR,result,length,i
	new TReportDR,TMaintItemDR,TResult,TNote,TRemark,TSort,PMRLData
	s return=""
	TStart
	s ReportDR=##class(web.DHCEQ.Process.DHCEQPMReport).SaveData(ReportData,delType)
	i ReportDR<0 {trollback  b  s return="更新主表失败" q return}
	i delType=0
	{
		s result=##class(web.DHCEQ.EM.PMReportList).DeleteByReportDR(ReportDR)
		i result<0 {trollback   b  s return="删除旧数据失败" q return}
		s length=$LENGTH(mydata,"},{")
		for i=1:1:length d
		.s data(i)=$p(mydata,"},{",i)
		.s TReportDR=ReportDR
		.s TMaintItemDR=##Class(web.DHCEQCommon).GetJsonDataByName(data(i),"TMaintItemDR",1)
		.s TResult=##Class(web.DHCEQCommon).GetJsonDataByName(data(i),"TResult",1)
		.s TNote=##Class(web.DHCEQCommon).GetJsonDataByName(data(i),"TNote",1)
		.s TRemark=##Class(web.DHCEQCommon).GetJsonDataByName(data(i),"TRemark",1)
		.s TSort=##Class(web.DHCEQCommon).GetJsonDataByName(data(i),"TSort",1)
		.s PMRLData="^"_TReportDR_"^"_TMaintItemDR_"^"_TResult_"^"_TNote_"^"_TRemark_"^"_TSort
		.//s ^GR(i+10)=PMRLData
	    .s result= ##class(web.DHCEQ.EM.PMReportList).SaveData(PMRLData)
	    .i result<0 {trollback  s return="更新明细失败" q}
	    .s:i=length return=ReportDR
	}
	else
	{
		s return=ReportDR
	}
    if (return>0)  tcommit
    q return
}

ClassMethod DeleteByReportDR(ReportDR)
{
	
	&SQL(delete from SQLUser.DHC_EQPMReportList where PMRL_ReportDR=:ReportDR)
	q:SQLCODE<0 SQLCODE
	q $g(%ROWID)
}

}

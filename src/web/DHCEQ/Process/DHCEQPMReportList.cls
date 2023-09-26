Class web.DHCEQ.Process.DHCEQPMReportList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQPMReportList","GetPMReportList",1)
/// modify by wl 2019-11-20 WL0013 增加[ SqlProc ]
Query GetPMReportList(ReportDR) As %Query(ROWSPEC = "TRowID:%String,TReportDR:%String,TReportDesc:%String,TMaintItemDR:%String,TMaintItemDesc:%String,TMaintItemCatDR:%String,TMaintItemCatDesc:%String,TResult:%String,TNote:%String,TRemark:%String,TSort:%String") [ SqlProc ]
{
}

ClassMethod GetPMReportListExecute(ByRef qHandle As %Binary, ReportDR) As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	// MZY0076	2021-05-25
	i $Data(^DHCEQPMReportList(0,"ReportDR",ReportDR))=0 Quit $$$OK
	s index=1
	s PMRLRowID=""
	f  s PMRLRowID=$o(^DHCEQPMReportList(0,"ReportDR",ReportDR,PMRLRowID)) q:PMRLRowID=""  d
	.q:$p($g(^DHCEQPMReportList(PMRLRowID)),"^",12)="Y"
	.d ResetVariablesGetPMReportList
	.d GetListInfo
	.d OutputRowGetPMReportList
	Quit $$$OK
GetListInfo
	s TRowID=PMRLRowID
	s TReportDR=ReportDR
	i TReportDR'="" s TReportDesc=$p($g(^DHCEQPMReport(TReportDR)),"^",3)
	s TMaintItemDR=$p($g(^DHCEQPMReportList(TRowID)),"^",2)
	s TResult=$p($g(^DHCEQPMReportList(TRowID)),"^",3)	// MZY0076	2021-05-25
	i TMaintItemDR'="" d
	.s TMaintItemDesc=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",2)
	.s TMaintItemCatDR=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",7)
	.i TMaintItemCatDR'="" s TMaintItemCatDesc=$p($g(^DHCEQCCode("DHCEQCMaintItemCat",TMaintItemCatDR)),"^",3)
	.// MZY0076	2021-05-25
	.i TResult'="" d
	..s findflag=0
	..s MIVID=""
	..f  s MIVID=$o(^DHCEQCCode("DHCEQMCMaintItemValues",0,"MaintItemDR",TMaintItemDR,MIVID)) q:(MIVID="")||(findflag'=0)  d
	...q:$p($g(^DHCEQCCode("DHCEQMCMaintItemValues",MIVID)),"^",5)'="N"
	...i $p($g(^DHCEQCCode("DHCEQMCMaintItemValues",MIVID)),"^",2)=TResult d
	....s TResult=$p($g(^DHCEQCCode("DHCEQMCMaintItemValues",MIVID)),"^",3)
	....s findflag=1
	
	s TNote=$p($g(^DHCEQPMReportList(TRowID)),"^",4)
	s TRemark=$p($g(^DHCEQPMReportList(TRowID)),"^",5)
	s TSort=$p($g(^DHCEQPMReportList(TRowID)),"^",6)
	
	quit
OutputRowGetPMReportList
	Set Data=$lb(TRowID,TReportDR,TReportDesc,TMaintItemDR,TMaintItemDesc,TMaintItemCatDR,TMaintItemCatDesc,TResult,TNote,TRemark,TSort)
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

/// Creator：      WL
/// CreatDate：    2019-11-21
/// Description:   润乾打印(PM报告)
/// Input：        ReportDR:维修ID   所用表：DHC_EQPMReport
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQPMReportList","GetPMReportPrint",1) 
/// Modefied by zc0119 2022-6-20  增加PM保养人输出  
Query GetPMReportPrint(ReportDR As %String = "") As %Query(ROWSPEC = "PMRMaintDR_EQName:%String,PMRMaintDR_EQNo:%String,PMRMaintDR_MDesc:%String,PMRMaintDR_EQLeaveFactoryNo:%String,PMRMaintDR_EQManuFactory:%String,PMRMaintDR_EQStartDate:%String,PMRMaintDR_DeptDesc:%String,PMRMaintDR_MTMaintDate:%String,PMRMaintDR_UserName:%String") [ SqlProc ]
{
}

ClassMethod GetPMReportPrintExecute(ByRef qHandle As %Binary, ReportDR As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	q:ReportDR=""	
 	i ReportDR'="" d
 	.s (TMaintDR,TEquipDR,TEQName,TEQNo,TEQModelDR,TEQModel,TEQLeaveFactoryNo,TEQManuFactoryDR,TEQManuFactory,TEQStartDate,TEQUseLocDR,TEQUseLoc,TMTMaintDate)=""
 	.s TMaintDR=$p($g(^DHCEQPMReport(ReportDR)),"^",2)
 	.i TMaintDR'="" d
 	..s TEquipDR=$p($g(^DHCEQMaint(TMaintDR)),"^",1)
 	.i TEquipDR'="" d 
 	..s TEQName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)  //设备名称
 	..s TEQNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)  //设备编号
 	..s TEQModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3) //机型
 	..s TEQModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TEQModelDR)
 	..s TEQLeaveFactoryNo=$p($g(^DHCEQEquip(TEquipDR)),"^",10) //出厂编号
 	..s TEQManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26) 
 	..s TEQManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TEQManuFactoryDR) //生产厂商
 	..s TEQStartDate=$p($g(^DHCEQEquip(TEquipDR)),"^",44) //启用日期
 	..i TEQStartDate'="" s TEQStartDate=##class(web.DHCEQCommon).TransValueToPage(TEQStartDate,"datetime")
 	..s TEQUseLocDR=$p($g(^DHCEQEquip(TEquipDR)),"^",19) //使用科室
 	..s TEQUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TEQUseLocDR)
 	..s TMTMaintDate=$p($g(^DHCEQMaint(TMaintDR)),"^",5) //PM周期
 	..i TMTMaintDate'="" s TMTMaintDate=##class(web.DHCEQCommon).TransValueToPage(TMTMaintDate,"datetime")
	..s TMTMaintUser=##class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQMaint(TMaintDR)),"^",7)) //保养人   /// Modefied by zc0119 2022-6-20  增加PM保养人输出  
	.d OutputRowGetPMReportPrint	
 	
 	Quit $$$OK	 
OutputRowGetPMReportPrint
 	set Data=$lb(TEQName,TEQNo,TEQModel,TEQLeaveFactoryNo,TEQManuFactory,TEQStartDate,TEQUseLoc,TMTMaintDate,TMTMaintUser)  /// Modefied by zc0119 2022-6-20  增加PM保养人输出  
 	set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod GetPMReportPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPMReportPrintExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind=""
	 {
	  //if there are no more rows,finish fetching...
	  Set AtEnd=1
	  Set Row=""
	 }
	 Else
	 {
	  Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod GetPMReportPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPMReportPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
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

/// w ##Class(web.DHCEQ.Process.DHCEQPMReportList).SaveAllData("1^3^1^保养模版^注释^666^444^555^1","","1")
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
		s result=##class(web.DHCEQ.Process.DHCEQPMReportList).DeleteByReportDR(ReportDR)
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
	    .s result= ##class(web.DHCEQ.Process.DHCEQPMReportList).SaveData(PMRLData)
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

/// add by zx 2019-07-06
/// 保存模板内容明细
/// 入参: 数据各字段内容,用'^'分割,多条时用'$'分割,移动端不允许带'&'字符串
/// 返回: SQLCODE 0,成功 其他,失败
ClassMethod SaveMPReportList(PMRowID, PMRLData)
{
	n PLIST
	s SQLCODE=0
	
	s PMLRowIDs=""
	s Length=$L(PMRLData,"$")
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=$p(PMRLData,"$",i)
		q:valList=""
		k PLIST,PMLRowID
		s PMLRowID=""  ;$p(valList,"^",1)
		s PLIST(2)=PMRowID
		s PLIST(3)=$p(valList,"^",3)
		s PLIST(4)=$p(valList,"^",4)
		s PLIST(5)=$p(valList,"^",5)
		s PLIST(6)=$p(valList,"^",6)
		s PLIST(7)=$p(valList,"^",7)
		i (PMLRowID="")
		{
			&SQL(insert into SQLUser.DHC_EQPMReportList values :PLIST())
			s PMLRowID=$g(%ROWID)
		}
		else
		{
			&SQL(Update SQLUser.DHC_EQPMReportList values :PLIST() where PMRL_RowID=:PMLRowID)
		}
		if PMLRowIDs'="" s PMLRowIDs=PMLRowIDs_","
		s PMLRowIDs=PMLRowIDs_PMLRowID
		q:SQLCODE'=0
	}
	s PMLRowID=0
	f  s PMLRowID=$o(^DHCEQPMReportList(0,"ReportDR",PMRowID,PMLRowID))  quit:(PMLRowID="")||(SQLCODE'=0)  d
	.i (","_PMLRowIDs_",")'[(","_PMLRowID_",") &SQL(delete from SQLUSER.DHC_EQPMReportList where PMRL_RowID = :PMLRowID)
	
	q SQLCODE
}

/// ZC2021-4-14 修改保存方法
/// 入参: 数据各字段内容,用'^'分割,多条时用'#'分割,移动端不允许带'&'字符串
/// w ##Class(web.DHCEQ.Process.DHCEQPMReportList).SaveMPReportListNew(1,"^^1^25^^^^^^^^^^^#^^2^52^^^^^^^^^^#^^3^1^^^^^^^^^^#^^4^1^^^^^^^^^^#^^5^1^^^^^^^^^^#^^6^1^^^^^^^^^^#^^7^1^^^^^^^^^^#^^8^1^^^^^^^^^^#^^9^0.4^^^^^^^^^^#^^10^4.5^^^^^^^^^^#^^11^1^^^^^^^^^^#^^12^-0.45^^^^^^^^^^")
ClassMethod SaveMPReportListNew(PMRowID, PMRLData)
{
	n PLIST,PFLIST
	s SQLCODE=0
	;s ^DHCEQMozy("SaveMPReportListNew")=PMRLData
	&SQL(delete from SQLUSER.DHC_EQPMReportList where PMRL_ReportDR = :PMRowID)
	i SQLCODE=100 s SQLCODE=0
	s PMLRowIDs=""
	s Length=$L(PMRLData,"#")
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=$p(PMRLData,"#",i)
		q:valList=""
		k PLIST,PMLRowID,PFLIST
		s PMLRowID=$p(valList,"^",1)
		s PLIST(2)=PMRowID
		s PLIST(3)=$p(valList,"^",3)
		s PLIST(4)=$p(valList,"^",4)
		s PLIST(5)=$p(valList,"^",5)
		s PLIST(6)=$p(valList,"^",6)
		s PLIST(7)=$p(valList,"^",7)
		s PLIST(8)=$p(valList,"^",8)
		s PLIST(9)=$p(valList,"^",9)
		s PLIST(10)=$p(valList,"^",10)
		s PLIST(11)=$p(valList,"^",11)
		s PLIST(12)=$p(valList,"^",12)
		s MIFRowID=$p(valList,"^",13)
		/*i (PMLRowID="")
		{
			&SQL(insert into SQLUser.DHC_EQPMReportList values :PLIST())
			s PMLRowID=$g(%ROWID)
		}
		else
		{
			&SQL(Update SQLUser.DHC_EQPMReportList values :PLIST() where PMRL_RowID=:PMLRowID)
		}*/
		&SQL(insert into SQLUser.DHC_EQPMReportList values :PLIST())
		s PMLRowID=$g(%ROWID)
		q:SQLCODE'=0
		
		i (MIFRowID'="")
		{
			&SQL(delete from SQLUSER.DHC_EQPMReportListFactor where RLF_ReportListDR = :PMLRowID)
			i SQLCODE=100 s SQLCODE=0
			q:SQLCODE'=0
			s PFLIST(2)=PMLRowID
			s PFLIST(3)=$p($g(^DHCEQCCode("DHCEQMCMaintItemFactor",MIFRowID)),"^",2) 
			s PFLIST(4)=$p($g(^DHCEQCCode("DHCEQMCMaintItemFactor",MIFRowID)),"^",3) 
			s PFLIST(5)=$p($g(^DHCEQCCode("DHCEQMCMaintItemFactor",MIFRowID)),"^",4) 
		
			&SQL(insert into SQLUser.DHC_EQPMReportListFactor values :PFLIST())
		}
	}
	q SQLCODE
}

}

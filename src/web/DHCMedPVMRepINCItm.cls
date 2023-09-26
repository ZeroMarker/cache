Import SQLUser

/// Creator：      cjb
/// CreatDate：   2009-07-03
/// Description:  药品质量报告管理类
Class web.DHCMedPVMRepINCItm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

ClassMethod QueryINCINameByDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryINCINameByDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryINCINameByDescExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
    //s iCount=$$ItmDets^DHCMedPVMCom(Desc)##Class
    s iCount=##Class(web.DHCMedPVMRepCtl).ItmDets(Desc)
	q:iCount<0 $$$OK
	s rowid=""	
	f  s rowid=$o(^CacheTemp($j,"INCItm",rowid)) q:rowid=""  d
	.s s=$g(^CacheTemp($j,"INCItm",rowid))
	.d BuildINICNameData
	k ^CacheTemp($j,"INCItm")
	Quit $$$OK
BuildINICNameData      
	;set Data=$lb(id,code,desc)
	set Data=$lb("")
 	f iBuild=1:1:3 d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryINCINameByDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryINCINameByDescExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      cjb
/// CreatDate：   2009-06-15
/// Description:  查询药物名称 开头的所有药物
/// Table：       表inc_itm ARC_ItmMast
/// Input：       药物名称
/// Output：      模糊查询出表inc_itm记录
/// Return：      
/// Others：      
Query QueryINCINameByDesc(Desc As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod QueryINCBatNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryINCBatNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryINCBatNoExecute(ByRef qHandle As %Binary, INCIDr As %String, INCBatNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
    //s ret=$$ItmBat^DHCMedPVMCom(INCIDr,INCBatNo)
    s ret=##Class(web.DHCMedPVMRepCtl).ItmBat(INCIDr,INCBatNo)
	q:ret="" $$$OK
	s length=$l(ret,$c(1))
	f i=2:1:length d
	.s s=$p(ret,$c(1),i)
	.d BuildINICBatNoData
	Quit $$$OK
BuildINICBatNoData      
	;set Data=$lb(id,BatNo,ExpDate)
	set Data=$lb("")
	s $li(Data,1)=$p(s,"^",1)
	s $li(Data,2)=$p(s,"^",2)
	s:$p(s,"^",3)'="" $li(Data,3)=$zd($p(s,"^",3),4)
	s $li(Data,4)=$p(s,"^",5)
	s $li(Data,5)=$p(s,"^",6)
	s $li(Data,6)=$p(s,"^",7)
	s $li(Data,7)=$p(s,"^",8)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryINCBatNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryINCBatNoExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      cjb
/// CreatDate：   2009-06-15
/// Description:  根据药物Rowid，传入的药物批号模糊查询
/// Table：       表inc_itm 表inc_itmbat
/// Input：       表inc_itm.rowid 模糊批号
/// Output：      模糊查询出表inc_itmbat记录及生产厂家
/// Return：      
/// Others：      d ##Class(%ResultSet).RunQuery("web.DHCMedPVMReport","QueryINCBatNo","167","")
Query QueryINCBatNo(INCIDr As %String, INCBatNo As %String) As %Query(ROWSPEC = "Rowid:%String,BatNo:%String,ExpDate:%String,ManfDesc:%String,Price:%String:价格,UOM:%String,CSC:%String")
{
}

/// Creator：      cjb
/// CreatDate：   2009-06-15
/// Description:  更新药物警戒报告
/// Table：       表DHC_MedPVMReport
/// Input：       药物警戒报告对应字段，药物，批号。。。
/// Output：      修改或增加的记录rowid
/// Return：      
/// Others：       
ClassMethod UpdatePVM(Instring)
{
	n (Instring)
	//s ret=$$UpdatePVM^DHCMedPVMCom(Instring)
	s ret=##Class(web.DHCMedPVMRepCtl).UpdatePVM(Instring)
	q ret
}

/// Creator：      cjb
/// CreatDate：   2009-06-15
/// Description:  审核药物警戒报告
/// Table：       表DHC_MedPVMReport
/// Input：       报告rowid，状态，审核人，审核时间，备注
/// Output：      审核记录rowid
/// Return：      
/// Others：      
ClassMethod UpdateCheckPVM(MPVMRowid, Status, CheckUsr, CheckDate, CheckTime, Demo)
{
	n (MPVMRowid,Status,CheckUsr,CheckDate,CheckTime,Demo)
	//s ret=$$UpdateCheckPVM^DHCMedPVMCom(MPVMRowid,Status,CheckUsr,CheckDate,CheckTime,Demo)
    s ret=##Class(web.DHCMedPVMRepCtl).UpdateCheckPVM(MPVMRowid,Status,CheckUsr,CheckDate,CheckTime,Demo)
	q ret
}

/// Creator：      cjb
/// CreatDate：   2009-06-15
/// Description:  获得药物警戒报告
/// Table：       表DHC_MedPVMReport
/// Input：       报告rowid
/// Output：      对应的rowid记录集
/// Return：      
/// Others：      w ##Class(web.DHCMedPVMRepINCItm).GetMPVM("1")
ClassMethod GetMPVM(Rowid)
{
	n (Rowid)
	q:Rowid="" ""
	s sMPVM=##Class(web.DHCMedPVMRepCtl).GetPVMByRowid(Rowid)
	///报告类型
	s:$p(sMPVM,"^",3)'="" $p(sMPVM,"^",3)=$p(sMPVM,"^",3)_"/"_##class(web.DHCMedDictoryCtl).GetByTypeCode("PVMReportType",$p(sMPVM,"^",3))
	///状态
	s:$p(sMPVM,"^",4)'="" $p(sMPVM,"^",4)=$p(sMPVM,"^",4)_"/"_##class(web.DHCMedDictoryCtl).GetByTypeCode("PVMReportStatus",$p(sMPVM,"^",4))
	s:$p(sMPVM,"^",5)'="" $p(sMPVM,"^",5)=$p(sMPVM,"^",5)_"/"_$tr($p($g(^INCI($p(sMPVM,"^",5),"1")),"^",2),"/","\") 
	//药物信息 rowid INCItmBatNo ExpDate "Y/N" ProComp
	s:$p(sMPVM,"^",6)'="" $p(sMPVM,"^",6)=$p(sMPVM,"^",6)_"/"_..GetItmBatDets($p(sMPVM,"^",6))
	///Description
	s DescriptionStr=""
	i $p(sMPVM,"^",10)'=""  d
	.f i=1:1:$l($p(sMPVM,"^",10),"/") d
	..s:DescriptionStr'="" DescriptionStr=DescriptionStr_$c(1)_..GetByTypeCode("PVMDescription",$p($p(sMPVM,"^",10),"/",i))
	..s:DescriptionStr="" DescriptionStr=..GetByTypeCode("PVMDescription",$p($p(sMPVM,"^",10),"/",i))
	s $p(sMPVM,"^",10)=DescriptionStr
	///Opinion
	s:$p(sMPVM,"^",12)'="" $p(sMPVM,"^",12)=$p(sMPVM,"^",12)_"/"_##class(web.DHCMedDictoryCtl).GetByTypeCode("PVMOpinion",$p(sMPVM,"^",12))
	///ReportPlace
	s:$p(sMPVM,"^",14)'="" $p(sMPVM,"^",14)=$p(sMPVM,"^",14)_"/"_##class(web.DHCMedDictoryCtl).GetByTypeCode("RepPlace",$p(sMPVM,"^",14))
	s s=sMPVM
    q s
}

/// 通过字典类型/字典代码获取字典项
/// Type：字典类型
/// Code：字典Code
ClassMethod GetByTypeCode(Type, Code)
{
	n (Type,Code)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s s=$$QueryByTypeCode^DHCMedDictory(Type,Code)
	zn CurrentNS
	s:s'="" s=$p(s,"^",1)_"/"_$p(s,"^",2)_"/"_$p(s,"^",3)_"/"_$p(s,"^",8)
	q s
}

/// 修改药物警戒字典方法
ClassMethod UpdatePVMDictory(Instring)
{
	n (Instring)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s s=$$Update^DHCMedDictory(Instring)
	zn CurrentNS
	q s
}

/// Creator：     cjb
/// CreatDate：   2009-06-15
/// Description:  获得批号相关信息
/// Table：       表inc_itmbat
/// Input：       inc_itmbat.rowid
/// Output：      对应的rowid记录集
/// Return：      
/// Others：      
ClassMethod GetItmBatDets(Rowid)
{
    //s ret=$$ItmBatByRowId^DHCMedPVMCom(Rowid)
    s ret=##Class(web.DHCMedPVMRepCtl).ItmBatByRowId(Rowid)
    q ret
}

ClassMethod QueryLoctionByDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLoctionByDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryLoctionByDescExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	//用于TextBox
	//根据首字母查询
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s len=$l(Desc)
	s Id=0
	set Data=$lb("")
	s $li(Data,1)=""
	s $li(Data,2)="全科"
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
	f  s Id=$o(^CTLOC(Id)) q:Id=""  d
	.q:'$d(^CTLOC(+Id))
    .s LocDesc=$p($g(^CTLOC(+Id)),"^",2)
    .q:((Desc'="")&&($e(LocDesc,1,len)'=Desc))
    .s s=+Id_"^"_LocDesc
	.d BuildData
	Quit $$$OK
	
BuildData
	set Data=$lb("") 	
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryLoctionByDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLoctionByDescExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     cjb
/// CreatDate：   2009-06-15
/// Description:  获得科室列表
/// Table：       表CT_Loc
/// Input：       科室描述
/// Output：      对应科室的rowid记录集
/// Return：      
/// Others：   
Query QueryLoctionByDesc(Desc As %String) As %Query(ROWSPEC = "ctlocid:%String,ctloc:%String")
{
}

ClassMethod QueryReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryReportExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, CtLoc As %String, Status As %String, INCItm As %String, Key As %String, ReportType As %String, Opinion As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

    //s:DateFrom'="" DateFrom=$zd($zdh(DateFrom,4),3)
    //s:DateTo'="" DateTo=$zd($zdh(DateTo,4),3)
    
    s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
    s:DateTo["/" DateTo=$zdh(DateTo,4)
    s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
    s:DateTo["-" DateTo=$zdh(DateTo,3)
    
	s:DateFrom'="" DateFrom=$zd(DateFrom,3)
	s:DateTo'="" DateTo=$zd(DateTo,3)
	
	q:(DateFrom="")!(DateTo="") $$$OK
	//s Ret=$$QueryA^DHCMedPVMCom(DateFrom, DateTo, CtLoc, Status, INCItm, Key,ReportType,Opinion)
	s Ret=##Class(web.DHCMedPVMRepCtl).QueryA(DateFrom, DateTo, CtLoc, Status, INCItm, Key,ReportType,Opinion)
	q:+Ret<0 $$$OK
	s iCount=+Ret
	s JIndex=$p(Ret,"^",2)
	f IndexApp=0:1:iCount d
	.s s=##Class(web.DHCMedPVMRepCtl).GetDataByIndex(JIndex,IndexApp)
	.//=$p(rs.GetDataByName("ReportDate"),"-")_$tr($justify(rs.GetDataByName("Rowid"),4)," ",0)
	.s $p(s,"^",2)=$p($p(s,"^",16),"-")_$tr($justify($p(s,"^",1),4)," ",0)
	.d BuildDataRep
	.s ind=ind+1
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildDataRep
	set Data=$lb("") 	
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     cjb
/// CreatDate：   2009-06-15
/// Description:  根据综合条件查询药物警戒报告
/// Table：       表DHC_MedPVMReport
/// Input：       时间段，报告科室 报告状态 药物Rowid 报告类型
/// Output：      模糊查询出的药物警戒报告集
/// Return：      
/// Others： 
Query QueryReport(DateFrom As %String, DateTo As %String, CtLoc As %String, Status As %String, INCItm As %String, Key As %String, ReportType As %String, Opinion As %String) As %Query(ROWSPEC = "Rowid:%String:报告ID,ReportNo:%String:报告ID,ReportType:%String:报告ID,ReportStatus:%String:报告ID,INCItmID:%String:报告ID,INCItmBatID:%String:报告ID,ReportQty:%String:报告ID,InStockQty:%String:报告ID,StockQty:%String:报告ID,Description:%String:报告ID,ResumeText:%String:报告ID,Opinion:%String:报告ID,ReportLocID:%String:报告ID,ReportPlace:%String:报告ID,ReportUser:%String:报告ID,ReportDate:%String:报告ID,ReportTime:%String:报告ID,CheckUser:%String:报告ID,CheckDate:%String:报告ID,CheckTime:%String:报告ID,Text1:%String:报告ID,Text1:%String:报告ID")
{
}

ClassMethod QueryPaadmByItmBtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPaadmByItmBtExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryPaadmByItmBtExecute(ByRef qHandle As %Binary, ItmBt As %String, fd As %String, td As %String, loc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	;
	s:fd["/" fd=$zdh(fd,4)
    s:td["/" td=$zdh(td,4)
    s:fd["-" fd=$zdh(fd,3)
    s:td["-" td=$zdh(td,3)
    q:ItmBt="" $$$OK
    s iCount=-1
    i ItmBt["||" d
    .//s iCount=$$QueryPaadmByItmBt^DHCMedPVMCom(ItmBt,fd,td) //取一个批号的所有科室医嘱
    .s iCount=##Class(web.DHCMedPVMRepCtl).QueryPaadmByItmBt(ItmBt,fd,td)
    i ItmBt'["||" d
    .s iCount=##Class(web.DHCMedPVMRepCtl).QueryPaadmByItmLoc(ItmBt,fd,td,loc) //按科室取一种药物的使用医嘱
	q:iCount<0 $$$OK
	s rowid=0	
	f  s rowid=$o(^CacheTemp($j,"ItmBtPaadm",rowid)) q:rowid=""  d
	.//s s=$$GetPaadmBaseInfo^DHCMedBasePaadm(rowid)
	.s s=##Class(web.DHCMedPVMRepCtl).GetPaadmBaseInfo(rowid)
	.d BuildPaadmData
	k ^CacheTemp($j,"ItmBtPaadm")
	Quit $$$OK
BuildPaadmData      
	;set Data=$lb(id,code,desc)
	set Data=$lb("")
	s $li(Data,1)=ItmBt
 	s $li(Data,2)=$p(s,"^",15)
 	s $li(Data,3)=$p(s,"^",6)
 	s $li(Data,4)=$p(s,"^",4)
 	s $li(Data,5)=$p(s,"^",7)
 	s $li(Data,6)=$p(s,"^",18)
 	s $li(Data,7)=$p(s,"^",3)
 	s $li(Data,8)=$p(s,"^",1)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryPaadmByItmBtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPaadmByItmBtExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     cjb
/// CreatDate：   2009-06-15
/// Description:  查询一段时间里使用一个批号或一种药的情况
/// Table：       表inc_itm 表inc_itmbat 表inc_itmlcbt 表DHC_InTrans  DHC_PHACollectItm
///              DHC_PHDISITEM  Pa_adm 
/// Input：       时间段，使用科室 药物rowid 
/// Output：      模糊查询出的病人使用药物信息集
/// Return：      
/// Others： 
Query QueryPaadmByItmBt(ItmBt As %String, fd As %String, td As %String, loc As %String) As %Query(ROWSPEC = "ItmBt:%String,Name:%String,PatNo:%String,AdmDate:%String,AdmLoc:%String,Age:%String,AdmNo:%String,Paadm:%String")
{
}

ClassMethod QueryPVMByArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPVMByArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryPVMByArcimExecute(ByRef qHandle As %Binary, paadm As %String, incit As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
    //s ret=$$GetOeoriByIncIt^DHCMedPVMCom(paadm,incit)
    s ret=##Class(web.DHCMedPVMRepCtl).GetOeoriByIncIt(paadm,incit)
	q:ret="" $$$OK
	s Num=$l(ret,$c(1))-1
	f jBuild=1:1:Num  d
	.s s=$p(ret,$c(1),jBuild)
	.d BuildPVMArcimData
	Quit $$$OK
BuildPVMArcimData      
	set Data=$lb("")
 	f iBuild=1:1:$l(s,$c(2)) d
 	.s $li(Data,iBuild)=$p(s,$c(2),iBuild)
 	;s $li(Data,15)=""    ;执行医生
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryPVMByArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPVMByArcimExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     cjb
/// CreatDate：   2009-06-15
/// Description:  查询药物 医嘱详细情况
/// Table：       表inc_itm 表inc_itmbat Pa_adm OE_Order OE_OrdItem 
/// Input：       就诊rowid，药物rowid 
/// Output：      查询某病人一次就诊所使用药物(医嘱)信息集
/// Return：      
/// Others： 
Query QueryPVMByArcim(paadm As %String, incit As %String) As %Query(ROWSPEC = "oeori:%String,arcimDesc:%String,PriorityDesc:%String,sttDate:%String,endDate:%String,PHFreqDesc:%String,DoseQty:%String,DuratDesc:%String,InstrDesc:%String,uomDesc:%String,phccat:%String,PhQtyOrd:%String,OrderStatusDesc:%String,OeDoc:%String,ExcDoc:%String")
{
}

ClassMethod QueryReportByRowidClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportByRowidExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryReportByRowidExecute(ByRef qHandle As %Binary, PVMRepRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	q:PVMRepRowid="" $$$OK
	s Ret=..GetMPVM(PVMRepRowid)
	q:Ret="" $$$OK
	d BuildDataRepByRowid
	//s ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildDataRepByRowid
	set Data=$lb("") 
	s $li(Data,1)=$p(Ret,"^",1)	  //rowid
	s $li(Data,2)=$p(Ret,"^",2)   //报告编号	
	s $li(Data,3)=$p(Ret,"^",3)   //问题类型
	s $li(Data,4)=$p(Ret,"^",4)   //报告状态
	s $li(Data,5)=$p(Ret,"^",5)   //药品名称
	s $li(Data,6)=$p(Ret,"^",6)   //药品批号 改为到组件中处理
	//s $li(Data,6)=$p($p(Ret,"^",5),"/",3)   //有效期
	//s $li(Data,7)=$p($p(Ret,"^",5),"/",5)   //厂家
	//s $li(Data,8)=$p($p(Ret,"^",5),"/",6)   //单位
	//s $li(Data,9)=$p($p(Ret,"^",5),"/",7)   //价格
	//s $li(Data,10)=$p($p(Ret,"^",5),"/",8)   //剂型
	//
	s $li(Data,7)=$p(Ret,"^",7)   //数量
	s $li(Data,8)=$p(Ret,"^",8)   //入库
	s $li(Data,9)=$p(Ret,"^",9)   //库存
	s $li(Data,10)=$p(Ret,"^",10)   //问题描述  有多个问题，先处理第一个
	s $li(Data,11)=$p(Ret,"^",11)   //备注
	s $li(Data,12)=$p(Ret,"^",12)   //处理意见
	s $li(Data,13)=$p(Ret,"^",13)  //报告科室
	s $li(Data,14)=$p(Ret,"^",14)   //报告位置
	s $li(Data,15)=$p(Ret,"^",15)   //报告人
	s $li(Data,16)=$p(Ret,"^",16)   //报告日期
	s $li(Data,17)=$p(Ret,"^",17)   //报告时间
	s $li(Data,18)=$p(Ret,"^",18)   //审核人
	s $li(Data,19)=$p(Ret,"^",19)   //审核日期
	s $li(Data,20)=$p(Ret,"^",20)   //审核时间
	s $li(Data,21)=$p(Ret,"^",21)   //备用字段一
	s $li(Data,22)=$p(Ret,"^",22)   //备用字段二
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryReportByRowidFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportByRowidExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     cjb
/// CreatDate：   2009-06-15
/// Description:  根据rowid得警戒报告
/// Table：       表DHC_MedPVMReport
/// Input：       报告Rowid 
/// Output：      药物警戒报告
/// Return：      
/// Others： D ##Class(%ResultSet).RunQuery("web.DHCMedPVMRepINCItm","QueryReportByRowid","1")
Query QueryReportByRowid(PVMRepRowid As %String) As %Query(ROWSPEC = "Rowid:%String,ReportNo:%String,ReportType:%String,ReportStatus:%String,INCItmID:%String,INCItmBatID:%String,ReportQty:%String,InStockQty:%String,StockQty:%String,Description:%String,ResumeText:%String:备注,Opinion:%String,ReportLocID:%String:报告科室,ReportPlace:%String,ReportUser:%String:报告人,ReportDate:%String,ReportTime:%String,CheckUser:%String,CheckDate:%String,CheckTime:%String,Text1:%String:备用1,Text2:%String:备用2")
{
}

ClassMethod QueryRepOpinionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRepOpinionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryRepOpinionExecute(ByRef qHandle As %Binary, PVMRepRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	q:PVMRepRowid="" $$$OK
	q:'$d(^DHCMedPVMRep(PVMRepRowid,"D")) $$$OK
	s tmpCS=""
	f  s tmpCS=$o(^DHCMedPVMRep(PVMRepRowid,"D",tmpCS))  q:tmpCS=""  d
	.s Ret=..GetOpinionDtl(PVMRepRowid,tmpCS)    //处理意见流水
	.d BuildDataRepOpinion
	//s ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildDataRepOpinion
	set Data=$lb("") 
	f iBuild=1:1:$l(Ret,"^") d
	.s $li(Data,iBuild)=$p(Ret,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryRepOpinionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRepOpinionExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     cjb
/// CreatDate：   2009-06-15
/// Description:  根据rowid得警戒报告处理意见流水
/// Table：       表DHC_MedPVMReport
/// Input：       报告Rowid 
/// Output：      药物警戒报告处理意见流水
/// Return：      
/// Others： D ##Class(%ResultSet).RunQuery("web.DHCMedPVMRepINCItm","QueryRepOpinion","1")
Query QueryRepOpinion(PVMRepRowid As %String) As %Query(ROWSPEC = "Opinion:%String,UserDr:%String,DoDate:%String,DoTime:%String,Resume:%String")
{
}

ClassMethod GetOpinionDtl(Parref As %String, ChildSub As %String)
{
	s s=$g(^DHCMedPVMRep(Parref,"D",ChildSub))
	s $p(s,"^",2)=##Class(web.DHCMedBaseCtl).GetUsrStr($p(s,"^",2))
	///Opinion
	s:$p(s,"^",1)'="" $p(s,"^",1)=$p(s,"^",1)_"/"_##class(web.DHCMedDictoryCtl).GetByTypeCode("PVMOpinion",$p(s,"^",1))
	s:$p(s,"^",3)'="" $p(s,"^",3)=$zd($p(s,"^",3),3)
	s:$p(s,"^",4)'="" $p(s,"^",4)=$zt($p(s,"^",4))
	q s
}

}

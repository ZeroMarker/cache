Import SQLUser

/// 附加项目操作
/// by wuqk 2007-03
/// modify by lxf 2008-10-14 增加附加项目排序方法:OrderByIndex，修改方法:GetItemList
Class web.DHCWMREmergency Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 17;

ClassMethod QueryDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryDetailsExecute(ByRef qHandle As %Binary, MainStatusRowid As %String, VolStatusRowid As %String, WorkItemRowid As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	;s ^CacheTemp("wuqk")=MainStatusRowid_"/"_VolStatusRowid_"/"_WorkItemRowid
	;s WorkItemRowid="12"
	i MainStatusRowid'="" d             ;DHC_WMR_MainStatusDtl
	.s err=..GetMainStatusDtl(MainStatusRowid,repid)
	e  i VolStatusRowid'=""  d          ;DHC_WMR_VolStatusDtl
	.s err=..GetVolStatusDtl(VolStatusRowid,repid)
	e  i WorkItemRowid'="" d            ;DHC_WMR_WorkItemList
	.s err=..GetItemList(WorkItemRowid,repid)
	Quit $$$OK
}

ClassMethod QueryDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDetailsExecute ]
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

/// *****************************************************************
/// Query          :  QueryDetails
/// 功能描述       ： 查询附加项目列表
///                   根据入参判断，分别查询
///                       病案主表的操作附加项目列表
///                   或  子表的操作附加项目列表
///                   或  操作项目的附加项目列表
/// by wuqk 2007-03
/// 入参           ：
/// MainStatusRowid：DHC_WMR_MainStatus.Rowid
/// VolStatusRowid ：DHC_WMR_VolStatus.Rowid
/// WorkItemRowid  ：DHC_WMR_WorkItem.Rowid
/// 出参           ：附加项目列表
/// MainDtlRowid   :DHC_WMR_MainStatusDtl.Rowid
/// VolDtlRowid    :DHC_WMR_VolStatusDtl.Rowid
/// WorkDetailRowid:DHC_WMR_WorkDetail.Rowid
/// WorkDetailCode :DHC_WMR_WorkDetail.Code
/// WorkDetailDesc :DHC_WMR_WorkDetail.Desc
/// DataType       :DHC_WMR_WorkDetail.DataType
/// IsNeed         :DHC_WMR_WorkItemList.IsNeed
/// ResumeText     :DHC_WMR_WorkDetail.ResumeText
/// ItemValue      :值
/// WorkItemListDr :DHC_WMR_WorkItemList.Rowid
/// DictionaryCode :DHC_WMR_WorkDetail.DictionaryCode
/// *****************************************************************
Query QueryDetails(MainStatusRowid As %String, VolStatusRowid As %String, WorkItemRowid As %String) As %Query(ROWSPEC = "MainDtlRowid:%String,VolDtlRowid:%String,WorkDetailRowid:%String,WorkDetailCode:%String,WorkDetailDesc:%String,DataType:%String,IsNeed:%String,ResumeText:%String,ItemValue:%String,WorkItemListDr:%String,DictionaryCode:%String,iRow:%String")
{
}

/// 根据DHC_WMR_MainStatus.Rowid构造附加项目列表信息
ClassMethod GetMainStatusDtl(MainStatusRowid, repid)
{
    n (MainStatusRowid,repid)
    s ind=1
    s err="0"
    s MainRowid=+MainStatusRowid
    s StatusSub=$p(MainStatusRowid,"||",2)
    ;^DHCWMRMAIN({DHC_WMR_Main.Rowid},"S",{DHC_WMR_MainStatus.ChildSub},"D",{ChildSub})
    q:'$d(^DHCWMRMAIN(MainRowid,"S",StatusSub,"D")) err
    
    ;s MainDtlRowid=""
    s VolDtlRowid=""
    s sub="0" 
    f  s sub=$o(^DHCWMRMAIN(MainRowid,"S",StatusSub,"D",sub)) q:sub=""  d
    .s s=$g(^DHCWMRMAIN(MainRowid,"S",StatusSub,"D",sub))
    .s MainDtlRowid=MainRowid_"||"_StatusSub_"||"_sub
    .s WorkDetailRowid=+$p(s,"^",1)
    .s ItemValue=$p(s,"^",2)
    .s WorkItemListDr=$p(s,"^",4)
    .s sWorkItemList=##class(web.DHCWMRWorkItemCtl).SLGetDataById(WorkItemListDr)
    .s IsNeed=$p(sWorkItemList,"^",5)
    .s sDetail=##class(web.DHCWMRWorkDetailCtl).GetDataById(WorkDetailRowid)
    .s WorkDetailCode=$p(sDetail,"^",2)
    .s WorkDetailDesc=$p(sDetail,"^",3)
    .s DataType=$p(sDetail,"^",4)
    .s ResumeText=$p(sDetail,"^",6)
    .s DictionaryCode=$p(sDetail,"^",7)
    .s Data=$lb(MainDtlRowid,VolDtlRowid,WorkDetailRowid,WorkDetailCode,WorkDetailDesc,DataType,IsNeed,ResumeText,ItemValue,WorkItemListDr,DictionaryCode)
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
    s err="1"
    q err
}

/// 根据DHC_WMR_VolStatus.Rowid构造附加项目列表信息
ClassMethod GetVolStatusDtl(VolStatusRowid, repid)
{
    n (VolStatusRowid,repid)
    s ind=1
    s err="0"
    
    S VolId=+VolStatusRowid
    s StatusSub=$p(VolStatusRowid,"||",2)
    q:'$d(^DHCWMRVOL(VolId,"S",StatusSub,"D")) err
    
    s MainDtlRowid=""
    ;s VolDtlRowid=""
    s sub="0"
    f  s sub=$o(^DHCWMRVOL(VolId,"S",StatusSub,"D",sub)) q:sub=""  d
    .s s=$g(^DHCWMRVOL(VolId,"S",StatusSub,"D",sub))
    .s VolDtlRowid=VolStatusRowid_"||"_sub
    .s WorkDetailRowid=+$p(s,"^",1)
    .s ItemValue=$p(s,"^",2)
    .s WorkItemListDr=$p(s,"^",4)
    .s sWorkItemList=##class(web.DHCWMRWorkItemCtl).SLGetDataById(WorkItemListDr)
    .s IsNeed=$p(sWorkItemList,"^",5)
    .s sDetail=##class(web.DHCWMRWorkDetailCtl).GetDataById(WorkDetailRowid)
    .s WorkDetailCode=$p(sDetail,"^",2)
    .s WorkDetailDesc=$p(sDetail,"^",3)
    .s DataType=$p(sDetail,"^",4)
    .s ResumeText=$p(sDetail,"^",6)
    .s DictionaryCode=$p(sDetail,"^",7)
    .s Data=$lb(MainDtlRowid,VolDtlRowid,WorkDetailRowid,WorkDetailCode,WorkDetailDesc,DataType,IsNeed,ResumeText,ItemValue,WorkItemListDr,DictionaryCode)
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
    s err="1"
    q err
    /*
    s MainRowid=+VolStatusRowid
    s VolSub=$p(VolStatusRowid,"||",2)
    s StatusSub=$p(VolStatusRowid,"||",3)
    ;^DHCWMRMAIN({DHC_WMR_Main.Rowid},"V",{DHC_WMR_MainVolume.ChildSub},"S",{DHC_WMR_VolStatus.ChildSub},"D",{ChildSub}) 
    q:'$d(^DHCWMRMAIN(MainRowid,"V",VolSub,"S",StatusSub,"D")) err
    
    s MainDtlRowid=""
    ;s VolDtlRowid=""
    s sub="0"
    f  s sub=$o(^DHCWMRMAIN(MainRowid,"V",VolSub,"S",StatusSub,"D",sub)) q:sub=""  d
    .s s=$g(^DHCWMRMAIN(MainRowid,"V",VolSub,"S",StatusSub,"D",sub))
    .s VolDtlRowid=VolStatusRowid_"||"_sub
    .s WorkDetailRowid=+$p(s,"^",1)
    .s ItemValue=$p(s,"^",2)
    .s WorkItemListDr=$p(s,"^",4)
    .s sWorkItemList=##class(web.DHCWMRWorkItemCtl).SLGetDataById(WorkItemListDr)
    .s IsNeed=$p(sWorkItemList,"^",5)
    .s sDetail=##class(web.DHCWMRWorkDetailCtl).GetDataById(WorkDetailRowid)
    .s WorkDetailCode=$p(sDetail,"^",2)
    .s WorkDetailDesc=$p(sDetail,"^",3)
    .s DataType=$p(sDetail,"^",4)
    .s ResumeText=$p(sDetail,"^",6)
    .s DictionaryCode=$p(sDetail,"^",7)
    .s Data=$lb(MainDtlRowid,VolDtlRowid,WorkDetailRowid,WorkDetailCode,WorkDetailDesc,DataType,IsNeed,ResumeText,ItemValue,WorkItemListDr,DictionaryCode)
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
    s err="1"
    q err
    */
}

/// 根据DHC_WMR_WorkItem.Rowid构造附加项目列表信息
/// Modify by lxf 2008-10-14
ClassMethod GetItemList(WorkItemRowid, repid)
{
    n (WorkItemRowid,repid)
    s ind=1
    s err="0"
    q:'$d(^DHCWMRWITM(+WorkItemRowid,"L")) err
    
    s MainDtlRowid=""
    s VolDtlRowid=""
    ;s sub="0"  								//delete by lxf
    s index=""									//add by lxf
    s retVal=..OrderByIndex(WorkItemRowid) 		//add by lxf 执行附加项目排序方法
    q:'$d(^TempWMR("DHCWMREmergency",$j)) err 	//add by lxf
    ;f  s sub=$o(^DHCWMRWITM(+WorkItemRowid,"L",sub)) q:sub=""  d   
    f  s index=$o(^TempWMR("DHCWMREmergency",$j,index)) q:index=""  d  //modify by lxf
    .;s s=$g(^DHCWMRWITM(+WorkItemRowid,"L",sub)) 
    .s s=$g(^TempWMR("DHCWMREmergency",$j,index)) //modify by lxf
    .q:$p(s,"^",3)'="Y"
    .//s WorkItemListDr=+WorkItemRowid_"||"_index
    .s WorkItemListDr=$p(s,"^",7)  //update by zf 20100613
    .s WorkDetailRowid=+$p(s,"^",1)
    .s IsNeed=$p(s,"^",4)
    .s ItemValue=$p(s,"^",6)
    .;s ResumeText=$p(s,"^",5)
    .s sDetail=##class(web.DHCWMRWorkDetailCtl).GetDataById(WorkDetailRowid)
    .s WorkDetailCode=$p(sDetail,"^",2)
    .s WorkDetailDesc=$p(sDetail,"^",3)
    .s DataType=$p(sDetail,"^",4)
    .s ResumeText=$p(sDetail,"^",6)
    .s DictionaryCode=$p(sDetail,"^",7)
    .;s ItemValue=""
    .s Data=$lb(MainDtlRowid,VolDtlRowid,WorkDetailRowid,WorkDetailCode,WorkDetailDesc,DataType,IsNeed,ResumeText,ItemValue,WorkItemListDr,DictionaryCode,ind)   //add ind by wuqk 2008-04-03
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
    k ^TempWMR("DHCWMREmergency",$j) //add by lxf 删除临时Global
    s err="1"
    q err
}

/// 将“住院病案流程”中要显示的附加项目列表，按照“操作项维护”保存时的列表顺序进行排序
/// add by lxf 2008-10-14
ClassMethod OrderByIndex(WorkItemRowid)
{
	n (WorkItemRowid)
	q:'$d(^DHCWMRWITM(+WorkItemRowid,"L")) "Error!"
    s sub=0
	f  s sub=$o(^DHCWMRWITM(+WorkItemRowid,"L",sub)) q:sub=""  d
	.s str=$g(^DHCWMRWITM(+WorkItemRowid,"L",sub))
    .q:$p(str,"^",3)'="Y"
    .s index=$p(str,"^",2)
	.s ^TempWMR("DHCWMREmergency",$j,index)=str_"^"_WorkItemRowid_"||"_sub
	q "Success!"
}

/// *****************************************************************
/// 事务           :  UpdateItemDetail
/// 功能描述       ： 编辑附加项目
/// by wuqk 2007-03
/// 入参           ：
///   sMainStatus  ： 更新DHC_WMR_MainStatus的串
///   sMainDtlList ： 更新DHC_WMR_MainStatusDtl的串列表  $c(1) 分隔
///   sVolStatus   ： 更新DHC_WMR_VolStatus的串
///   sVolDtlList  ： 更新DHC_WMR_VolStatusDtl的串列表  $c(1) 分隔
/// 返回值         ： ret=0 成功    ret<0 失败
/// *****************************************************************
ClassMethod UpdateItemDetail(sMainStatus, sMainDtlList, sVolStatus, sVolDtlList)
{
	;n (sMainStatus,sMainDtlList,sVolStatus,sVolDtlList)
	s ret=-1
	q:(sMainStatus="")&(sVolStatus="") ret
	q:(sMainStatus'="")&(sMainDtlList="") ret
	q:(sVolStatus'="")&(sVolDtlList="") ret
	
	;sMainStatus & sVolStatus
	;PLIST(0)=$p(Instring,"^",1)
    ;ChildSub=$p(Instring,"^",2)
    ;PLIST(3)=+$p(Instring,"^",3)        ;病案操作项目/状态
    ;PLIST(4)=+$p(Instring,"^",4)        ;转交人   
    ;PLIST(5)=$p(Instring,"^",5)        ;操作日期 
    ;PLIST(6)=$p(Instring,"^",6)        ;操作时间 
    ;PLIST(7)=+$p(Instring,"^",7)        ;接收人   
    
    ;sMainDtlList & sVolDtlList
	;PLIST(0)=$p(Instring,"^",1)
    ;ChildSub=$p(Instring,"^",2)
    ;PLIST(3)=+$p(Instring,"^",3)        ;突发项目明细
    ;PLIST(4)=$p(Instring,"^",4)         ;突发项目值  
    ;PLIST(5)=$p(Instring,"^",5)         ;备注
    
	;w !,"Start"
	Tstart
	i (sMainStatus'="") d
	.s ret=-1.1
	.s StatusRowid=##class(web.DHCWMRMainCtl).UpdateMainStatus(sMainStatus)
	.q:+StatusRowid<0
	.s ret=-1.2
	.s DtlRowid=0
	.f Index=1:1:$l(sMainDtlList,$c(1)) q:(+DtlRowid<0)  d
	..s sDtl=$p(sMainDtlList,$c(1),Index)
	..s $p(sDtl,"^",1)=StatusRowid
	..s DtlRowid=##class(web.DHCWMRMainCtl).UpdateMainStatusDtl(sDtl)
	.q:+DtlRowid<0
	.s ret=0
	e  i (sVolStatus'="") d
	.s ret=-1.1
	.s StatusRowid=##class(web.DHCWMRVolumeCtl).UpdateVolStatus(sVolStatus)
	.q:+StatusRowid<0
	.s ret=-1.2
	.s DtlRowid=0
	.f Index=1:1:$l(sMainDtlList,$c(1)) q:(+DtlRowid<0)  d
	..s sDtl=$p(sMainDtlList,$c(1),Index)
	..s $p(sDtl,"^",1)=StatusRowid
	..s DtlRowid=##class(web.DHCWMRVolumeCtl).UpdateVolStatusDtl(sDtl)
	.q:+DtlRowid<0
	.s ret=0
	
	i ret<0 TRo
	i ret=0 TCommit
	;w !,"Over"
	q ret
}

ClassMethod SetDicData(Active) As %String
{
	;n (itmName,DataType,DicType,Val)
	/*
	Set itmName="comb"
	Set DataType="4"
	Set DicType="Marriage"
	Set Val="1"
	*/    
	Set itmName="ItemValueZ"_rs.GetDataByName("iRow")
	Set DataType=rs.GetDataByName("DataType")
	Set DicType=rs.GetDataByName("DictionaryCode")
	Set Val=rs.GetDataByName("ItemValue")
	Set Requre=rs.GetDataByName("IsNeed")
    ;s Active=""
    s Active=$s(Active="1":"",1:"disabled")
    i DataType="Dictionary1" d
    .Write "<select id='"_itmName_"' name='"_itmName_"' size=1 "_Active_" style='WIDTH: 180px; HEIGHT: 24px'>"
	.i Requre'="1" Write "<option  value=''></option>"
	.s temp=##class(web.DHCWMRDictionaryCtl).GetByType(DicType,"Y")
	.f Index=1:1:($l(temp,$c(1))-1) d
	..s s=$p(temp,$c(1),Index)
	..s rowid=$p(s,"^",1)
	..s desc=$p(s,"^",4)
	..If rowid=Val Write "<option value="_rowid_" selected>"_desc_"</option>"
	..Else  Write "<option value="_rowid_">"_desc_"</option>"
	.Write "</select>"
	e  i DataType="Dictionary" d
	.Set DicValue=Val
	.Set DicDesc=$p($g(^DHCWMRDIC(+Val)),"^",3)
	.Set:$p(DicDesc,"-",2)'="" DicDesc=$p(DicDesc,"-",2)
	.set:DicDesc="" DicValue=""
	.
	.//Write "<input id='"_itmName_"' name='"_itmName_"' type='hidden' value='"_DicValue_"'>"
	.Write "<input id='"_itmName_"' name='"_itmName_"' style='WIDTH: 0px; HEIGHT: 22px' value='"_DicValue_"'>"
	.Write "<input id='"_itmName_"Desc' name='"_itmName_"Desc' style='WIDTH: 180px; HEIGHT: 22px' value='"_DicDesc_"'>"
	.Write "<IMG id='"_itmName_"Image' name='"_itmName_"Image' src='../images/websys/lookup.gif'>"
	.
	.Write "<script language=javascript>"
	.Write "function "_itmName_"Desc_lookuphandler(e) {"
	.Write "	if (evtName=='"_itmName_"Desc') {"
	.Write "		window.clearTimeout(evtTimer);"
	.Write "		evtTimer='';"
	.Write "		evtName='';"
	.Write "	}"
	.Write "	var type=websys_getType(e);"
	.Write "	var key=websys_getKey(e);"
	.Write "	if ((type=='click')||((type=='keydown')&&(key==13))) {"
	.Write "		var url='websys.lookup.csp';"
	.Write "		url += '?ID="_itmName_"Image&CONTEXT=Kweb.DHCWMREmergency:QryDicByAlias&TLUDESC=&TLUJSF="_itmName_"Desc_selecthandler';"
	.Write "		var obj=document.getElementById('"_itmName_"Desc');"
	.Write "		if (obj) url += '&P1="_DicType_"&P2=' + websys_escape(obj.value);"
	.//Write "		websys_lu(url,1,'');"
	.Write "		dialogArguments.window.open(url);"
	.Write "		return websys_cancel();"
	.Write "	}"
	.Write "}"
	.
	.Write "dialogArguments.window."_itmName_"Desc_selecthandler = function(str){"
	.Write "	var objValue=document.getElementById('"_itmName_"');"
	.Write "	var objDesc=document.getElementById('"_itmName_"Desc');"
	.Write "	var tem=str.split('^');"
	.Write "	objValue.value=tem[0];"
	.Write "	objDesc.value=tem[1];"
	.Write "    ValidateContents();"
	.Write "}"
	.
	.Write "function "_itmName_"Desc_onchange(){"
	.Write "	var objValue=document.getElementById('"_itmName_"');"
	.Write "	objValue.value='';"
	.Write "    	ValidateContents();"
	.Write "}"
	.
	.Write "var obj=document.getElementById('"_itmName_"Desc');"
	.Write "if (obj) obj.onkeydown="_itmName_"Desc_lookuphandler;"
	.Write "if (obj) obj.onchange="_itmName_"Desc_onchange;"
	.Write "var obj=document.getElementById('"_itmName_"Image');"
	.Write "if (obj) obj.onclick="_itmName_"Desc_lookuphandler;"
	.Write "</script>"
    e  d
    .Write "<input id='"_itmName_"' name='"_itmName_"' "_Active
	.Write " style='WIDTH: 180px; HEIGHT: 24px' value='"_val_"'>"
 	q ""
}

ClassMethod QryDicByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QryDicByAliasExecute(ByRef qHandle As %Binary, argType As %String, argAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:'$d(^DHCWMRDIC(0,"DicName",argType,"Y")) $$$OK
	
    Set Rowid=0
    For {
	    Set Rowid=$o(^DHCWMRDIC(0,"DicName",argType,"Y",Rowid))
	    Quit:Rowid=""
	    Set DicInfo=$g(^DHCWMRDIC(Rowid))
    	Set Code=$p(DicInfo,"^",2)
    	Set Desc=$p(DicInfo,"^",3)
    	Continue:Desc'[argAlias
    	Set Data=$lb(Rowid,Desc)
 		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryDicByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicByAliasExecute ]
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

/// CreateUser : zhufei
/// CreateDate : 2010-06-13
/// CreateInfo : 根据类型和别名取基础字典信息
/// d ##Class(%ResultSet).RunQuery("web.DHCWMREmergency","QryDicByAlias","SYS","")
Query QryDicByAlias(argType As %String, argAlias As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

}

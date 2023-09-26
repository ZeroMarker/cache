/// 名称: DHCMed.CCService.ContentDicSrv
/// 描述: DHCMed.CC.ContentDic 监控内容字典表常用方法
/// 编写者：liuyh
/// 编写日期: 2010-04-26
Class DHCMed.CCService.ContentDicSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-04-26
/// Description:  通过监控项目代码、子分类查询监控项目信息
/// Table：       DHCMed.CC.ItemDic
/// Input：       IDCode : 监控项目代码 IDSubCatDr : 子分类
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.ContentDicSrv","QueryItemDicInfo","","")
Query QueryItemDicInfo(IDDesc As %String, IDSubCatDr As %String) As %Query(ROWSPEC = "rowid:%String,IDCode:%String,IDDesc:%String,IDSubCatDr:%String,IDExpression:%String,IDRange:%String,IDResume:%String,CDDesc:%String")
{
}

ClassMethod QueryItemDicInfoExecute(ByRef qHandle As %Binary, IDDesc As %String, IDSubCatDr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""

	f  s rowid=$o(^DHCMed.CC.ItemDicD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.ItemDic).%OpenId(rowid)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.IDCode
	.q:((IDDesc'="")&(obj.IDDesc'[IDDesc))
	.s $li(data,3)=obj.IDDesc
	.s $li(data,4)=obj.IDSubCatDr
	.q:((IDSubCatDr'="")&(IDSubCatDr'=obj.IDSubCatDr))
	.s $li(data,5)=obj.IDExpression
	.s $li(data,6)=obj.IDRange
	.s $li(data,7)=obj.IDResume
	.q:+obj.IDSubCatDr=0
	.s ISCRet=##Class(DHCMed.CC.ItemSubCat).GetObjById(+obj.IDSubCatDr)
	.s:ISCRet'="" $li(data,8)=ISCRet.ISCDesc
	.s:ISCRet="" $li(data,8)=""
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
	q $$$OK
}

ClassMethod QueryItemDicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemDicInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryItemDicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemDicInfoExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-04-26
/// Description:  通过监控内容代码、类型查询监控项目信息
/// Table：       DHCMed.CC.ContentDic
/// Input：       CDCode : 监控内容代码 CDType : 类型 CDTypeDesc: 类型描述
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.ContentDicSrv","QueryContentDicInfo","","","")
Query QueryContentDicInfo(CDCode As %String, CDType As %String, CDTypeDesc As %String) As %Query(ROWSPEC = "rowid:%String,CDCode:%String,CDDesc:%String,CDType:%String,CDExpression:%String,CDResume:%String,CDTypeDesc:%String")
{
}

ClassMethod QueryContentDicInfoExecute(ByRef qHandle As %Binary, CDCode As %String, CDType As %String, CDTypeDesc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	
	f  s rowid=$o(^DHCMed.CC.ContentDicD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.ContentDic).%OpenId(rowid)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.CDCode
	.q:((CDCode'="")&(CDCode'[obj.CDCode))
	.s $li(data,3)=obj.CDDesc
	.s $li(data,4)=obj.CDType
	.q:((CDType'="")&(obj.CDType'[CDType))
	.s $li(data,5)=obj.CDExpression
	.s $li(data,6)=obj.CDResume
	.s:obj.CDType="OE" $li(data,7)="医嘱"
	.s:obj.CDType="D" $li(data,7)="诊断"
	.s:obj.CDType="L" $li(data,7)="检验"
	.q:((CDTypeDesc'="")&(CDTypeDesc'=$li(data,7)))
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
	q $$$OK
}

ClassMethod QueryContentDicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryContentDicInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryContentDicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryContentDicInfoExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-04-26
/// Description:  通过监控内容代码、类型查询监控项目信息
/// Table：       DHCMed.CC.ContentDic
/// Input：       CDCode : 监控内容代码 CDType : 类型
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.ContentDicSrv","FindItemSubCatInfo")
Query FindItemSubCatInfo() As %Query(ROWSPEC = "rowid:%String,ISCode:%String,ISCDesc:%String,ISCCatDr:%String")
{
}

ClassMethod FindItemSubCatInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	f  s rowid=$o(^DHCMed.CC.ItemSubCatD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.ItemSubCat).%OpenId(rowid)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.ISCCode
	.s $li(data,3)=obj.ISCDesc
	.s $li(data,4)=obj.ISCCatDr
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
	q $$$OK
}

ClassMethod FindItemSubCatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemSubCatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindItemSubCatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemSubCatInfoExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-04-30
/// Description:  根据ARCIM_Desc汉字描述或其别名表的拼音首字母查询
/// Table：       ARC_ItmMast
/// Input：       ARCIMDesc:ARC_ItmMast.ARCIM_Desc汉字描述或ARC_Alias.ARC_Alias首字母别名
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.ContentDicSrv","QueryByDescAlias","")
Query QueryByDescAlias(ARCIMDesc As %String) As %Query(ROWSPEC = "ArcimID:%String,ArcimDesc:%String:描述,ARCIMCode:%String:代码,ArcimDR:%String,ARCICOrdCatDR:%String:项目大类Rowid,ORCATDesc:%String:项目大类描述,ARCIMItemCatDR:%String:项目子类Rowid,ARCICDesc:%String:项目子类描述")
{
}

ClassMethod QueryByDescAliasExecute(ByRef qHandle As %Binary, Alias As %String) As %Status
{
	
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:Alias="" $$$OK
	
    s Alias=$ZCVT(Alias,"U")
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 
	.f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..s objArcim=##Class(DHCMed.Base.Arcim).GetObjById(ArcimDR)
	..q:'$IsObject(objArcim)
	..s ArcimDesc=objArcim.ARCIMDesc
	..s AliasText=objArcim.ALIASText
	..s ArcimDesc=AliasText_"-"_ArcimDesc
	..q:ArcimDesc'[Alias			//按照别名过滤
	..Do OutputRow

	Quit $$$OK
OutputRow
	s:ArcimDesc["[" ArcimDesc=$tr(ArcimDesc,"[","")
	s:ArcimDesc["]" ArcimDesc=$tr(ArcimDesc,"]","")
	s:ArcimDesc["(" ArcimDesc=$tr(ArcimDesc,")","")
	s:ArcimDesc["(" ArcimDesc=$tr(ArcimDesc,")","")
	s:ArcimDesc["|" ArcimDesc=$tr(ArcimDesc,"|","")
	s:ArcimDesc["||" ArcimDesc=$tr(ArcimDesc,"||","")
	set Data=$lb(ArcimID,ArcimDesc,objArcim.ARCIMCode,ArcimDR,objArcim.ARCICOrdCatDR,objArcim.ORCATDesc,objArcim.ARCIMItemCatDR,objArcim.ARCICDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1

 	quit
}

ClassMethod QueryByDescAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByDescAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByDescAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByDescAliasExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-05-04
/// Description:  通过监控项目字典代码判断医嘱(诊断)是否已添加
/// Table：       DHCMed.CC.ItemDic
/// Input：       rowid : 医嘱(诊断)rowid str : OE()
/// 	Return		  1 : 已添加   
/// w ##class(DHCMed.CCService.ContentDicSrv).IsDataAdd("1","OE")
ClassMethod IsDataAdd(rowid As %String, str As %String) As %String
{
	n (rowid,str)
	s ret=-1
	q:rowid="" ret
	q:str="" ret
	
	s IDDesc=str_rowid
	s:$o(^DHCMed.CC.ItemDicI("IDCodeIndex"," "_IDDesc,""))'="" ret=$o(^DHCMed.CC.ItemDicI("IDCodeIndex"," "_IDDesc,""))
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2010-05-06
/// Description:  获取所有检验科室
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.ContentDicSrv","GetDepartment")
Query GetDepartment() As %Query(ROWSPEC = "DepNo:%String,DepName:%String")
{
}

ClassMethod GetDepartmentExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    
    s DepList=""
    
   	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    
    zn LABDATA
    s ret=$$GetDepartment^DHCGETSYSPARAMETER()
    f Index=1:1:P0 d
    .s DepName=PLIST(Index)
    .s:DepList="" DepList=DepName
    .s:DepList'="" DepList=DepList_"/"_DepName
 	zn CurrentNS
 	
 	q:DepList="" $$$OK
 	
 	f i=1:1:$l(DepList,"/")  d
 	.s DepNo=$p($p(DepList,"/",i),"^",1)
 	.s DepName=$p(DepList,"/",i)
 	.s Data=$lb(DepNo,DepName)
	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	
 	q $$$OK
}

ClassMethod GetDepartmentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepartmentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDepartmentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepartmentExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-05-06
/// Description:  获取检验科室对应的检验项目列表
/// Input:		  DepCode : 检验科室code TCName : ""
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.ContentDicSrv","GetTestCode","H","")
Query GetTestCode(DepCode As %String, TCName As %String, TestDesc As %String) As %Query(ROWSPEC = "TestCode:%String,TestName:%String")
{
}

ClassMethod GetTestCodeExecute(ByRef qHandle As %Binary, DepCode As %String, TCName As %String, TestDesc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    
    q:DepCode="" $$$OK
    s TestList=""
    
   	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    
    zn LABDATA
    s ret=$$GetTestCode^DHCStatisticItem(DepCode,TCName)
    f Index=1:1:P0 d
    .s TestCodeName=PLIST(Index)
    .s:TestList="" TestList=TestCodeName
    .s:TestList'="" TestList=TestList_"/"_TestCodeName
 	zn CurrentNS
 	
 	q:TestList="" $$$OK
 	
 	//表达式中不能包含 ( ) [ ] 符号
 	s TestList=$tr(TestList,"(","")
 	s TestList=$tr(TestList,")","")
 	s TestList=$tr(TestList,"[","")
 	s TestList=$tr(TestList,"]","")
 	
 	f i=1:1:$l(TestList,"/")  d
 	.s TestCode=$p($p(TestList,"/",i),"|",2)
 	.s TestName=$p(TestList,"/",i)
 	.q:((TestDesc'="")&(TestName'[TestDesc))
 	.s Data=$lb(TestCode,TestName)
	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	
 	q $$$OK
}

ClassMethod GetTestCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTestCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetTestCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTestCodeExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-05-06
/// Description:  通过字典名称获取字典项目
/// Input:		  DicName : 字典名字
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.ContentDicSrv","FindOperCharFromDic","CompareOperator")
Query FindOperCharFromDic(DicName As %String) As %Query(ROWSPEC = "rowid:%String,DicCode:%String,DicName:%String")
{
}

ClassMethod FindOperCharFromDicExecute(ByRef qHandle As %Binary, DicName As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s rowid=0
	
	q:DicName="" $$$OK
	f  s rowid=$o(^DHCMed.SS.DictionaryD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.SS.Dictionary).%OpenId(rowid)
	.q:obj.Active'=1
	.q:obj.Type'=DicName
	.s DicDesc=obj.Description
	.s DicCode=obj.Code
	.s Data=$lb(rowid,DicCode,DicDesc)
	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	
	Quit $$$OK
}

ClassMethod FindOperCharFromDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperCharFromDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindOperCharFromDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperCharFromDicExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-05-06
/// Description:  通过检验项目获取对应的值
/// Input:		  LabCode : 检验项目Code
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.ContentDicSrv","GetValueListByCode","M1003")
Query GetValueListByCode(LabCode As %String) As %Query(ROWSPEC = "Code:%String,Descs:%String")
{
}

ClassMethod GetValueListByCodeExecute(ByRef qHandle As %Binary, LabCode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    
    q:LabCode="" $$$OK
    
   	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    
    zn LABDATA
    s ret=$$GetListByCode^DHCMedLabCode(MEDDATA,LABDATA,LabCode)
 	zn CurrentNS
 	
 	q:ret="" $$$OK
 	
 	f i=1:1:$l(ret,$c(1))-1  d
 	.s Code=$p($p(ret,$c(1),i),$c(28),2)
 	.s Descs=$p($p(ret,$c(1),i),$c(28),3)
 	.s Data=$lb(Code,Descs)
	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	
 	q $$$OK
}

ClassMethod GetValueListByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetValueListByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetValueListByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetValueListByCodeExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-05-10
/// Description:  同时往监控内容字典和监控项目字典表中插入医嘱信息
/// Table：       DHCMed.CC.ContentDic,DHCMed.CC.ItemDic
/// Input：       Str:医嘱信息 Type:类型(医嘱、诊断、检验)           
/// Return：      返回是否成功标志 1:成功   0:失败
/// w ##class(DHCMed.CCService.ContentDicSrv).AddInfoToDic("^1^2^3^4^^","")
ClassMethod AddInfoToDic(Str As %String, Type As %String) As %String
{
	new (Str,Type)
	set ret=0
	quit:Str="" ret
	quit:Type="" ret
	set ret=0,rowid=""
	set $ZT="Error"
	TStart
		
	set ret=##class(DHCMed.CC.ItemDic).Update(Str)
	if ret<0 TRollback
	set $p(Str,"^",4)=Type	// 往内容表中插入数据时，类型为医嘱类型
	
	set DicCode=$ZCVT($p(Str,"^",2),"U") //转换为大写
	if '$d(^DHCMed.CC.ContentDicI("CDCodeIndex"," "_DicCode)) d
	.set ret=##class(DHCMed.CC.ContentDic).Update(Str)
	.if ret<0 TRollback
	
	TCommit
	set ret=1
	quit ret

Error
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

ClassMethod TestAA(Paadm) As %String
{
	
	s ret=""
	s cr=$c(9)
	s ret=ret_ "var objTmp = new Ext.menu.Menu({items:["_cr	
	//start
	f i=1:1:3  d
	.s ret=ret_"{"_cr
    .s ret=ret_"text:'<b>显示病人基本信息1111</b>',"_cr
    .s ret=ret_"icon:'../scripts/dhcmed/img/menudic.gif',"_cr
    .s ret=ret_"handler:function()"_cr
    .s ret=ret_"{"_cr	
    .//s ret=ret_"var objDisplayWin = new DisplayPatientWin(paadm);"_cr
    .s ret=ret_"alert("_Paadm_");"_cr							
    .s ret=ret_"}"_cr
    .s ret=ret_"}"_cr
    .s:i'=3 ret=ret_","
    //end
	s ret=ret_"]}"_cr
	s ret=ret_");"
	q ret
}

}

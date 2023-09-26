/// 名称: DHCMed.Base.MRCICDDx
/// 描述: ICD表(MRC_ICDDx)的业务封装，定义常用属性和方法
/// 编写者：lyh
/// 编写日期: 2010-04-06
Class DHCMed.Base.MRCICDDx Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// ICD表Id  MRCID_RowId  
Property Rowid As %Integer;

/// ICD代码 MRCID_Code
Property Code As %String(TRUNCATE = 1);

/// ICD描述 MRCID_Desc
Property Descs As %String(TRUNCATE = 1);

/// ICD Ins描述 MRCID_InsDesc
Property InsDesc As %String(TRUNCATE = 1);

/// ICD9代码 MRCID_ICD9CM_Code
Property ICD9CMCode As %String(TRUNCATE = 1);

/// 起始日期 MRCID_DateActiveFrom
Property DateFrom As %Library.Date;

/// 是否有效 MRCID_Valid 
Property ICDValid As %Boolean;

/// Creator：     lyh
/// CreatDate：   2010-04-06
/// Description:  将对象格式化为字符串
/// Table：       
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
///               1:Rowid 2:Code 3:Descs 4:InsDesc 5:ICD9CMCode 6:DateFrom 7：ICDValid
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..Rowid_separete_..Code_separete_..Descs_separete_..InsDesc
	set return=return_separete_..ICD9CMCode_separete_..DateFrom_separete_..ICDValid
	quit return
}

/// Creator：     lyh
/// CreatDate：   2010-04-06
/// Description:  根据MRC_ICDDx.MRCID_RowId取ICD信息
/// Table：       MRC_ICDDx
/// Input：       ICDId    MRC_ICDDx.MRCID_RowId
/// Return：      返回obj
/// Others：       
ClassMethod GetObjById(ICDId As %String) As DHCMed.Base.MRCICDDx
{
	new (ICDId)
	set return=""
	quit:ICDId="" return
	quit:'$d(^MRC("ID",+ICDId)) return
	set obj=##Class(DHCMed.Base.MRCICDDx).%New()
	set obj.Rowid=+ICDId
	set obj.Code=$p($g(^MRC("ID",+ICDId)),"^",1)	 	 // ICD代码  MRCID_Code
	set obj.Descs=$p($g(^MRC("ID",+ICDId)),"^",2)   	     // ICD描述 MRCID_Desc
	set obj.InsDesc=$p($g(^MRC("ID",+ICDId)),"^",3)   	 // ICD Ins描述 MRCID_InsDesc
	set obj.ICD9CMCode=$p($g(^MRC("ID",+ICDId)),"^",4)	 // ICD9代码 MRCID_ICD9CM_Code
	set obj.DateFrom=$p($g(^MRC("ID",+ICDId)),"^",6)     // 起始日期 HOSP_DateFrom
	set obj.ICDValid=$p($g(^MRC("ID",+ICDId)),"^",27)	 // 是否有效 MRCID_Valid
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     lyh
/// CreatDate：   2010-04-06
/// Description:  根据MRC_ICDDx.MRCID_RowId取ICD信息
/// Table：       MRC_ICDDx
/// Input：       ICDId    MRC_ICDDx.MRCID_RowId
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.MRCICDDx).GetStringById(1)
ClassMethod GetStringById(ICDId As %String, separete As %String) As %String
{
	new (ICDId,separete)
	set return=""
	set obj=..GetObjById(ICDId)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     lyh
/// CreatDate：   2010-04-06
/// Description:  根据MRC_ICDAlias.ALIAS_Text取ICD信息
/// Table：       MRC_ICDDx、MRC_ICDAlias
/// Input：       alias:    MRC_ICDAlias.ALIAS_Text
/// Return：      返回以$c(1)分隔行的obj.ToString()
/// Others：       ^MRC("ID",0,"ALIAS",$$ALPHAUP({ALIAS_Text}),{MRC_ICDDx.MRCID_RowId},{ALIAS_Childsub})
/// w ##class(DHCMed.Base.MRCICDDx).GetByShortDescAlias("HL")
ClassMethod GetByShortDescAlias(alias As %String) As %String
{
	new (alias)
	set return=""
	set alias=$ZCVT(alias,"U")
	set tmpAlias=alias

	//取ALIAS_Text=tmpALias的数据
	set rowid=$o(^MRC("ID",0,"ALIAS",tmpAlias,0))
	while rowid'="" {
		set return=return_..GetStringById(+$p(rowid,"||",1),"")_$c(1)
		set rowid=$o(^MRC("ID",0,"ALIAS",tmpAlias,rowid))		
	}

	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-05-04
/// Description:  根据MRC_Desc汉字描述或其别名表的拼音首字母查询
/// Table：       MRC_ICDDx
/// Input：       MRCDesc:MRC_ICDDx.MRCID_Desc汉字描述或ARC_Alias.ARC_Alias首字母别名
/// Return：      ResultSet
/// Others：      诊断别名表：MRC_ICDAlias
/// d ##class(%ResultSet).RunQuery("DHCMed.Base.MRCICDDx","QueryByDescAlias","")
Query QueryByDescAlias(Alias As %String) As %Query(ROWSPEC = "MRCID:%String,ICD9CMCode:%String,Descs:%String")
{
}

ClassMethod QueryByDescAliasExecute(ByRef qHandle As %Binary, Alias As %String) As %Status
{
	
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:Alias="" $$$OK
	
    s Alias=$ZCVT(Alias,"U")
 	s ALIASRowId="" 
 	f  s ALIASRowId=$o(^MRC("ID",ALIASRowId)) q:ALIASRowId=""  d
 	.s ALIASChildsub=0
 	.f  s ALIASChildsub=$o(^MRC("ID",ALIASRowId,"ALIAS",ALIASChildsub)) q:ALIASChildsub=""  d
	..s ICDAlias=$p($g(^MRC("ID",ALIASRowId,"ALIAS",ALIASChildsub)),"^",1)
	..q:ICDAlias'[Alias
	..s objMRC=..GetObjById(ALIASRowId)
	..q:'$IsObject(objMRC)
	..s ICD9CMCode=objMRC.ICD9CMCode
	..s Descs=objMRC.Descs
	..Do OutputRow

	Quit $$$OK
OutputRow
	s:Descs["[" Descs=$tr(Descs,"[","")
	s:Descs["]" Descs=$tr(Descs,"]","")
	s:Descs["(" Descs=$tr(Descs,")","")
	s:Descs["(" Descs=$tr(Descs,")","")
	s:Descs["|" Descs=$tr(Descs,"|","")
	s:Descs["||" Descs=$tr(Descs,"||","")
	set Data=$lb(ALIASRowId,ICD9CMCode,Descs)
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

}

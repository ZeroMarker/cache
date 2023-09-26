/// 名称: DHCMed.Base.PacWard
/// 描述: 病区表（PAC_Ward）的业务封装，定义常用属性和方法
/// 编写者：wuqk
/// 编写日期: 2010-04-07
Class DHCMed.Base.PacWard Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 病区Id  WARD_RowID
Property Rowid As %Integer;

/// 病区代码 WARD_Code
Property Code As %String(TRUNCATE = 1);

/// 病区描述 WARD_Desc
Property Descs As %String(TRUNCATE = 1);

/// 科室Id  CT_LOC.CTLOC_RowID
Property CtlocDr As %Integer;

/// Creator：     wuqk
/// CreatDate：   2010-04-07
/// Description:  将对象格式化为字符串
/// Table：       
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
///               1:Rowid 2:Code 3:Descs 3:CtlocDr
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..Rowid_separete_..Code_separete_..Descs_separete_..CtlocDr
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-07
/// Description:  根据PAC_Ward.WARD_RowID取病区信息
/// Table：       PAC_Ward
/// Input：       id:    PAC_Ward.WARD_RowID
/// Return：      返回obj
/// Others：   
/// w ##class(DHCMed.Base.PacWard).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.Base.PacWard
{
	new (id)
	set return=""
	quit:id="" return
	quit:'$d(^PAWARD(+id)) return
	set obj=##Class(DHCMed.Base.PacWard).%New()
	set obj.Rowid=+id
	set obj.Code=$p($g(^PAWARD(+id)),"^",1)    // 代码
	set obj.Descs=$p($g(^PAWARD(+id)),"^",2)   // 描述 
	set obj.CtlocDr=$p($g(^PAWARD(+id)),"^",5)   // 科室Id
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-07
/// Description:  根据PAC_Ward.WARD_RowID取病区信息
/// Table：       PAC_Ward
/// Input：       id:    PAC_Ward.WARD_RowID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.PacWard).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-07
/// Description:  根据CT_Loc.CTLOC_ROWID查找病区列表
/// Table：       CT_Loc,CT_LocLinkLocation,PAC_WARD
/// Input：       ctloc:    CT_Loc.CTLOC_ROWID
/// Return：      返回以$c(1)分隔行的obj.ToString()
/// Others：       ^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
///                ^PAWARD(0,"WARD_LocationDR",{WARD_LocationDR},{WARD_RowID})
/// w ##class(DHCMed.Base.PacWard).GetByLocLink(1)
ClassMethod GetByLocLink(ctloc) As %String
{
	new (ctloc)
	set return=""
	quit:'$d(^CTLOC(+ctloc,"LINK",0,"Loc")) return
	
	set linkCtloc=$o(^CTLOC(+ctloc,"LINK",0,"Loc",""))
	while (linkCtloc'=""){
		if $d(^PAWARD(0,"WARD_LocationDR",+linkCtloc)){
			set wardId=$o(^PAWARD(0,"WARD_LocationDR",+linkCtloc,""))
			while (wardId'=""){
				set str=..GetStringById(+wardId)
				if (str'=""){
					set return=return_str_$c(1)
				}				
				set wardId=$o(^PAWARD(0,"WARD_LocationDR",+linkCtloc,wardId))
			}
		}		
		set linkCtloc=$o(^CTLOC(+ctloc,"LINK",0,"Loc",linkCtloc))
	}
	quit return
}

/// Creator：     PanLei
/// CreatDate：   2013-04-24
/// Description:  根据科室获取对应的病区列表
/// Table：       Ct_Loc,CT_LocLinkLocation
/// Input：       LocID:科室RowID
/// Return：      WardRowID:%String:病区RowID,WardCode:%String:病区Code,WardDesc:%String:病区描述
/// Do ##class(%ResultSet).RunQuery("DHCMed.Base.PacWard","QueryWardByCtLoc","129")
Query QueryWardByCtLoc(argLocID As %String) As %Query(ROWSPEC = "WardRowID:%String:病区RowID,WardCode:%String:病区Code,WardDesc:%String:病区描述")
{
}

ClassMethod QueryWardByCtLocExecute(ByRef qHandle As %Binary, argLocID As %String) As %Status
{
	Set repid = $I(^CacheTemp)
	Set ind = 1
	Set qHandle = $ListBuild(0,repid,0)
	
	Set childSubID = 0
	For {
		Set childSubID = $o(^CTLOC(argLocID,"LINK",childSubID))
		Quit:childSubID=""
		
		Set LinkLocID = $g(^CTLOC(argLocID,"LINK",childSubID))
		Set objWard = ##class(DHCMed.Base.Ctloc).GetObjById(LinkLocID)
		Continue:'$IsObject(objWard)
		
		Set WardRowID = objWard.Rowid	// 病区RowID,294
		Set WardCode = objWard.Code		// 病区Code,重症医学科内科病区
		Set WardDesc = objWard.Descs	// 病区描述,ZZYXKYBQ-重症医学科一病区
		
		Set tmpData = $ListBuild(WardRowID, WardCode, WardDesc)
		Set ^CacheTemp(repid,ind) = tmpData
		Set ind = ind + 1
	}
	
	Quit $$$OK
}

ClassMethod QueryWardByCtLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWardByCtLocExecute ]
{
	Set repid = $List(qHandle,2)
 	Kill ^CacheTemp(repid)
 	
	Quit $$$OK
}

ClassMethod QueryWardByCtLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardByCtLocExecute ]
{
	Set AtEnd = $List(qHandle,1)
 	Set repid = $List(qHandle,2)
 	Set ind = $List(qHandle,3)
 	
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd = 1
 		Set Row = ""
 	} Else {
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	Set qHandle = $ListBuild(AtEnd,repid,ind)
 	
	Quit $$$OK
}

}

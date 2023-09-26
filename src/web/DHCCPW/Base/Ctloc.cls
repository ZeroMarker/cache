/// 名称: web.DHCCPW.Base.Ctloc
/// 描述: 科室表（CT_Loc）的业务封装，定义常用属性和方法
/// 编写者：wuqk
/// 编写日期: 2010-03-29
Class web.DHCCPW.Base.Ctloc Extends (%Persistent, web.DHCCPW.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 科室Id  CTLOC_RowID
Property Rowid As %Integer;

/// 科室代码 CTLOC_Code
Property Code As %String(TRUNCATE = 1);

/// 科室描述 CTLOC_Desc
Property Descs As %String(TRUNCATE = 1);

/*Ward||W：病区
Execute||E：执行科室
Drug Injection||DI：注射
Dispensing||D：药剂
Cashier||C：财务
Other||O：其它
Operating Theatre||OP：手术
Emergency||EM：急诊
Day Surgery||DS：外科诊疗室
Medical Records||MR：病案室
OutPatient Consulting Room||OR：门诊咨询室
Clinic||CL：临床 */
/// 科室类型 CTLOC_Type
Property Type As %String(TRUNCATE = 1);

/// 医院 CTLOC_Hospital_DR  指向CT_Hospital                 
Property HospitalDr As %Integer;

/// 部门组 CTLOC_Dep_DR  指向RBC_DepartmentGroup                 
Property DepGroupDr As %Integer;

/// Creator：     wuqk
/// CreatDate：   2010-03-29
/// Description:  将对象格式化为字符串
/// Table：       
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
///               1:Rowid 2:Code 3:Desc 3:Type 5:HospitalDr 6:DepGroupDr
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..Rowid_separete_..Code_separete_..Descs_separete_..Type
	set return=return_separete_..HospitalDr_separete_..DepGroupDr
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-03-29
/// Description:  根据CT_Loc.CTLOC_RowID取科室信息
/// Table：       CT_Loc
/// Input：       ctloc:    CT_Loc.CTLOC_RowID
/// Return：      返回obj
/// Others：   
/// w ##class(web.DHCCPW.Base.Ctloc).GetObjById(1)
ClassMethod GetObjById(ctloc As %String) As web.DHCCPW.Base.Ctloc
{
	new (ctloc)
	set return=""
	quit:ctloc="" return
	quit:'$d(^CTLOC(+ctloc)) return
	set obj=##Class(web.DHCCPW.Base.Ctloc).%New()
	set obj.Rowid=+ctloc
	set obj.Code=$p($g(^CTLOC(+ctloc)),"^",1)   // 科室代码 CTLOC_Code
	set obj.Descs=$p($g(^CTLOC(+ctloc)),"^",2)   // 科室描述 CTLOC_Desc
	set obj.Type=$p($g(^CTLOC(+ctloc)),"^",13)   // 科室类型 CTLOC_Type
	set obj.HospitalDr=+$p($g(^CTLOC(+ctloc)),"^",22)   // 医院 CTLOC_Hospital_DR
	set obj.DepGroupDr=+$p($g(^CTLOC(+ctloc)),"^",19)   // 部门组 CTLOC_Dep_DR
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-03-29
/// Description:  根据CT_Loc.CTLOC_RowID取科室信息
/// Table：       CT_Loc
/// Input：       ctloc:    CT_Loc.CTLOC_RowID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(web.DHCCPW.Base.Ctloc).GetStringById(1)
ClassMethod GetStringById(ctloc As %String, separete As %String) As %String
{
	new (ctloc,separete)
	set return=""
	set obj=..GetObjById(ctloc)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-03-29
/// Description:  根据CT_Loc.CTLOC_Desc的开头字符取科室信息
/// Table：       CT_Loc
/// Input：       alias:    CT_Loc.CTLOC_Desc的开头字符
///               type:     CT_Loc.CTLOC_Type 科室类型
/// Return：      返回以$c(1)分隔行的obj.ToString()
/// Others：       ^CTLOC(0,"Desc",$$ALPHAUP({CTLOC_Desc}),{CTLOC_RowID})
/// 
/// w ##class(web.DHCCPW.Base.Ctloc).GetByDescAlias("w","w")
ClassMethod GetByDescAlias(alias As %String, type As %String) As %String
{
	new (alias,type)
	set return=""
	set alias=$ZCVT($g(alias),"U")
	set type=$ZCVT($g(type),"U")
	
	set tmpAlias=alias
	
	//取CTLOC_Desc=tmpALias的数据
	if (alias'=""){
		if $d(^CTLOC(0,"Desc",tmpAlias)){
			set rowid=$o(^CTLOC(0,"Desc",tmpAlias,0))
			while rowid'="" {		
				set str=$$buildStringByIdType(rowid,type)
				if (str'=""){
					set return=return_str_$c(1)
				}		
				set rowid=$o(^CTLOC(0,"Desc",tmpAlias,rowid))		
			}
		}
	}
	
	//取CTLOC_Desc以alias开头的数据
	set tmpAlias=$o(^CTLOC(0,"Desc",tmpAlias))
	
	while ((tmpAlias'="")&(($e(tmpAlias,1,$l(alias))=alias)||(alias=""))){
		set rowid=$o(^CTLOC(0,"Desc",tmpAlias,0))
		while rowid'="" {
			set str=$$buildStringByIdType(rowid,type)
			if (str'=""){
				set return=return_str_$c(1)
			}
			set rowid=$o(^CTLOC(0,"Desc",tmpAlias,rowid))		
		}
		set tmpAlias=$o(^CTLOC(0,"Desc",tmpAlias))
	}
	quit return
	
buildStringByIdType(Id,type)
	new (Id,type)
	set str=""	
	set obj=..GetObjById(Id)
	if $IsObject(obj){
		if (type'=""){
			if (obj.Type=type){
				set str=obj.ToString()
			}
		}
		else{
			set str=obj.ToString()
		}
	}
	quit str
}

/// Creator：     wuqk
/// CreatDate：   2010-03-29
/// Description:  根据CT_Loc.CTLOC_Desc的开头字符查询科室信息列表
/// Table：       CT_Loc
/// Input：       alias:    CT_Loc.CTLOC_Desc的开头字符
///               type:     CT_Loc.CTLOC_Type 科室类型
/// Return：      ResultSet
/// Others：       ^CTLOC(0,"Desc",$$ALPHAUP({CTLOC_Desc}),{CTLOC_RowID})
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.Base.Ctloc","QueryByDescAlias","w")
Query QueryByDescAlias(descAlias As %String, type As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod QueryByDescAliasExecute(ByRef qHandle As %Binary, descAlias As %String, type As %String) As %Status
{
	
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	set alias=$ZCVT(descAlias,"U")
	set type=$ZCVT($g(type),"U")
	set tmpAlias=alias
	
	//取CTLOC_Desc=tmpALias的数据
	if (alias'=""){
		if $d(^CTLOC(0,"Desc",tmpAlias)){
			set rowid=$o(^CTLOC(0,"Desc",tmpAlias,0))
			while rowid'="" {		
				do BuildRow(..GetObjById(+rowid),type,repid,.ind)		
				set rowid=$o(^CTLOC(0,"Desc",tmpAlias,rowid))		
			}
		}
	}
	
	//取CTLOC_Desc以alias开头的数据
	set tmpAlias=$o(^CTLOC(0,"Desc",tmpAlias))	
	while ((tmpAlias'="")&(($e(tmpAlias,1,$l(alias))=alias)||(alias=""))){
		set rowid=$o(^CTLOC(0,"Desc",tmpAlias,0))
		while rowid'="" {
			do BuildRow(..GetObjById(+rowid),type,repid,.ind)
			set rowid=$o(^CTLOC(0,"Desc",tmpAlias,rowid))		
		}
		set tmpAlias=$o(^CTLOC(0,"Desc",tmpAlias))
	}
	Quit $$$OK
BuildRow(obj,type,repid,ind)
	new (obj,type,repid,ind)
	if $IsObject(obj) {
		if (obj.Type=type)||(type=""){
    		set Data=$lb(obj.Rowid,obj.Code,obj.Descs)
 			Set ^CacheTemp(repid,ind)=Data
			set ind=ind+1
		}
	}
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

/// Creator：     wuqk
/// CreatDate：   2010-04-07
/// Description:  根据DepGroupId取科室信息列表
/// Table：       CT_Loc
/// Input：       DepGroupId
///               HospId:     医院Id
/// Return：      返回列表$c(1)分隔行 ^分隔列
/// Others：      读取 DepartmentModel 配置
///               CCW:Ctloc/Ctloc/Ward 模式，默认
///               RCW:Rbc_DepGroup/Ctloc/Ward模式
/// w ##class(web.DHCCPW.Base.Ctloc).GetByDepGrop(1)
ClassMethod GetByDepGrop(DepGroupId As %String, HospId As %String) As %String
{
	new (DepGroupId,HospId)
	set DepGroupId=+DepGroupId
	set HospId=+$g(HospId)
	set return=""
	
	set Setting=""
	set objBC=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("DepartmentModel")
	if $IsObject(objBC) {
		set Setting=objBC.BCValue
	}
	set:Setting="" Setting="CCW"
	if Setting="CCW"{
		set return=..GetStringById(DepGroupId)
	}
	elseif Setting="RCW"{
		set return=..GetByRBCDepGrop(DepGroupId)
	}	
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-07
/// Description:  根据部门组ID取科室信息
/// Table：       CT_Loc
/// Input：       rbcDepGroupId:    RBC_DepartmentGroup.DEP_RowID
/// Return：      返回obj.ToString()
/// ^CTLOC(0,"DepGrp",{CTLOC_Dep_DR},{CTLOC_RowID}) 
/// w ##class(web.DHCCPW.Base.Ctloc).GetByRBCDepGrop(1)
ClassMethod GetByRBCDepGrop(rbcDepGroupId As %String) As %String
{
	new (rbcDepGroupId)
	set rbcDepGroupId=+rbcDepGroupId
	set return=""
	quit:'$d(^CTLOC(0,"DepGrp",rbcDepGroupId)) return
	
	set ctloc=$o(^CTLOC(0,"DepGrp",rbcDepGroupId,""))
	while (ctloc'=""){
		set str=..GetStringById(+ctloc)
		if str'="" {
			set return=return_str_$c(1)
		}
		set ctloc=$o(^CTLOC(0,"DepGrp",rbcDepGroupId,ctloc))
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-07-01
/// Description:  查询科室/病区
/// Input：       Type(类型:E-执行科室,W-病区),LocID(关联科室:科室找病区或病区找科室)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.Base.Ctloc","QryCTLoc","","E","")
Query QryCTLoc(argDesc As %String, argType As %String, argLocID As %String) As %Query(ROWSPEC = "CTLocID:%String,CTLocCode:%String,CTLocDesc:%String")
{
}

ClassMethod QryCTLocExecute(ByRef qHandle As %Binary, argDesc As %String, argType As %String, argLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	
	Set:argDesc'="" argDesc=$$ALPHAUP^SSUTIL4(argDesc)
	//^CTLOC({CTLOC_RowID})
	//^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
	Set CTLocID=0
	For {
		Set CTLocID=$o(^CTLOC(CTLocID))
		Quit:CTLocID=""
		Set tmp=$g(^CTLOC(CTLocID))
		Set CTLocCode=$p(tmp,"^",1)
		Set CTLocDesc=$p(tmp,"^",2)
		Set CTLocType=$p(tmp,"^",13)
		Continue:(argType'="")&&(CTLocType'=argType)
		//Continue:(argLocID'="")&&'$d(^CTLOC(+argLocID,"LINK",0,"Loc",CTLocID))
		Set tmpLocDesc=$$ALPHAUP^SSUTIL4(CTLocDesc)
		Continue:(argDesc'="")&&(tmpLocDesc'[argDesc)
		
		Set Data=$lb(CTLocID,CTLocCode,CTLocDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCTLocExecute ]
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

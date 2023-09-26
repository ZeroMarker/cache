/// 名称: DHCMed.Base.Ctloc
/// 描述: 科室表（CT_Loc）的业务封装，定义常用属性和方法
/// 编写者：wuqk
/// 编写日期: 2010-03-29
Class DHCMed.Base.Ctloc Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 科室Id  CTLOC_RowID
Property Rowid As %Integer;

/// 科室代码 CTLOC_Code
Property Code As %String(TRUNCATE = 1);

/// 科室描述 CTLOC_Desc
Property Descs As %String(TRUNCATE = 1);

/// 科室类型 CTLOC_Type
/// Ward||W：病区
/// Execute||E：执行科室
Property Type As %String(TRUNCATE = 1);

/// 医院 CTLOC_Hospital_DR  指向CT_Hospital                 
Property HospitalDr As %Integer;

/// 部门组 CTLOC_Dep_DR  指向RBC_DepartmentGroup                 
Property DepGroupDr As %Integer;

/// 科室电话
Property Telephone As %String;

/// Creator：     wuqk
/// CreatDate：   2010-03-29
/// Description:  将对象格式化为字符串
/// Table：       
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
///               1:Rowid 2:Code 3:Desc 3:Type 5:HospitalDr 6:DepGroupDr
Method ToString(separete As %String, Languages As %String = "") As %String
{
	new (Languages)
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	Set LocDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,..Descs)
	set return=..Rowid_separete_..Code_separete_LocDesc_separete_..Type
	set return=return_separete_..HospitalDr_separete_..DepGroupDr_separete_..Telephone
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-03-29
/// Description:  根据CT_Loc.CTLOC_RowID取科室信息
/// Table：       CT_Loc
/// Input：       ctloc:    CT_Loc.CTLOC_RowID
/// Return：      返回obj
/// Others：   
/// w ##class(DHCMed.Base.Ctloc).GetObjById(1)
ClassMethod GetObjById(ctloc As %String) As DHCMed.Base.Ctloc
{
	new (ctloc)
	set return=""
	quit:ctloc="" return
	quit:'$d(^CTLOC(+ctloc)) return
	set obj=##Class(DHCMed.Base.Ctloc).%New()
	set obj.Rowid=+ctloc
	set obj.Code=$p($g(^CTLOC(+ctloc)),"^",1)           // 科室代码 CTLOC_Code
	set DescStr=$p($g(^CTLOC(+ctloc)),"^",2)
	set:$p(DescStr,"-",2)'="" DescStr=$p(DescStr,"-",2)
	set obj.Descs=DescStr                               // 科室描述 CTLOC_Desc
	set obj.Type=$p($g(^CTLOC(+ctloc)),"^",13)          // 科室类型 CTLOC_Type
	set obj.HospitalDr=+$p($g(^CTLOC(+ctloc)),"^",22)   // 医院 CTLOC_Hospital_DR
	set obj.DepGroupDr=+$p($g(^CTLOC(+ctloc)),"^",19)   // 部门组 CTLOC_Dep_DR
	set obj.Telephone=$p($g(^CTLOC(+ctloc)),"^",40)     // 科室电话 CTLOC_Telephone
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-03-29
/// Description:  根据CT_Loc.CTLOC_RowID取科室信息
/// Table：       CT_Loc
/// Input：       ctloc:    CT_Loc.CTLOC_RowID
/// Return：      返回obj
/// Others：   
/// w ##class(DHCMed.Base.Ctloc).GetObjByWardId(1)
ClassMethod GetObjByWardId(argWardID As %String) As DHCMed.Base.Ctloc
{
	new (argWardID)
	set return=""
	quit:argWardID="" return
	set ctloc=$p($g(^PAWARD(+argWardID)),"^",5)
	quit:'$d(^CTLOC(+ctloc)) return
	set obj=##Class(DHCMed.Base.Ctloc).%New()
	set obj.Rowid=+ctloc
	set obj.Code=$p($g(^CTLOC(+ctloc)),"^",1)           // 科室代码 CTLOC_Code
	set DescStr=$p($g(^CTLOC(+ctloc)),"^",2)
	set:$p(DescStr,"-",2)'="" DescStr=$p(DescStr,"-",2)
	set obj.Descs=DescStr                               // 科室描述 CTLOC_Desc
	set obj.Type=$p($g(^CTLOC(+ctloc)),"^",13)          // 科室类型 CTLOC_Type
	set obj.HospitalDr=+$p($g(^CTLOC(+ctloc)),"^",22)   // 医院 CTLOC_Hospital_DR
	set obj.DepGroupDr=+$p($g(^CTLOC(+ctloc)),"^",19)   // 部门组 CTLOC_Dep_DR
	set obj.Telephone=$p($g(^CTLOC(+ctloc)),"^",40)     // 科室电话 CTLOC_Telephone
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
/// w ##class(DHCMed.Base.Ctloc).GetStringById(1)
ClassMethod GetStringById(ctloc As %String, separete As %String) As %String
{
	new (ctloc,separete,%session)
	Set langid=20
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	set return=""
	set obj=..GetObjById(ctloc)
	if $IsObject(obj){
		set return=obj.ToString($g(separete),Languages)
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
/// w ##class(DHCMed.Base.Ctloc).GetByDescAlias("w","w")
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
/// d ##class(%ResultSet).RunQuery("DHCMed.Base.Ctloc","QueryByDescAlias","","w","I")
Query QueryByDescAlias(descAlias As %String, type As %String, admType As %String = "", addItem As %String = "") As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod QueryByDescAliasExecute(ByRef qHandle As %Binary, descAlias As %String, type As %String, admType As %String, addItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
 	//add by zf 20130225 增加附加选项
 	Set admType=$g(admType)
 	Set addItem=$g(addItem)
	If (addItem'="")&&(descAlias="") {
		Set addItemCode=$p(addItem,"^",1)
		Set addItemDesc=$p(addItem,"^",2)
		Set Data=$lb(addItemCode,addItemCode,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	set alias=$ZCVT(descAlias,"U")
	set type=$ZCVT($g(type),"U")
	set:admType'="" admType=$ZCVT($g(admType),"U")
	set tmpAlias=alias
	
	//取CTLOC_Desc=tmpALias的数据
	if (alias'=""){
		if $d(^CTLOC(0,"Desc",tmpAlias)){
			set rowid=$o(^CTLOC(0,"Desc",tmpAlias,0))
			while rowid'="" {
				//add by zf 20130225 增加科室按门诊、住院、急诊分类的过滤
				if (type'="W")&&(admType'="") {
					continue:'$d(^PAC("ADMLOC",0,"AdmType",admType,rowid))
				}
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
			//add by zf 20130225 增加科室按门诊、住院、急诊分类的过滤
			if (type'="W")&&(admType'="") {
				continue:'$d(^PAC("ADMLOC",0,"AdmType",admType,rowid))
			}
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
/// w ##class(DHCMed.Base.Ctloc).GetByDepGrop(1)
ClassMethod GetByDepGrop(DepGroupId As %String, HospId As %String) As %String
{
	new (DepGroupId,HospId)
	set DepGroupId=+DepGroupId
	set HospId=+$g(HospId)
	set return=""
	
	set Setting=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("DepartmentModel",HospId)
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
/// w ##class(DHCMed.Base.Ctloc).GetByRBCDepGrop(1)
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
/// Do ##class(%ResultSet).RunQuery("DHCMed.Base.Ctloc","QryCTLoc","","E","")
/// Do ##class(%ResultSet).RunQuery("DHCMed.Base.Ctloc","QryCTLoc","","","-2")
/// Do ##class(%ResultSet).RunQuery("DHCMed.Base.Ctloc","QryCTLoc","","","-3")
Query QryCTLoc(argDesc As %String, argType As %String, argLocID As %String, argAdmType As %String = "", argAddItem As %String = "") As %Query(ROWSPEC = "CTLocID:%String,CTLocCode:%String,CTLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCTLocExecute(ByRef qHandle As %Binary, argDesc As %String, argType As %String, argLocID As %String, argAdmType As %String, argAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
 	//add by zf 20130225 增加附加选项
 	Set argAdmType=$g(argAdmType)
 	Set argAddItem=$g(argAddItem)
	If (argAddItem'="")&&(argDesc="") {
		Set addItemCode=$p(argAddItem,"^",1)
		Set addItemDesc=$p(argAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemCode,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	//add by zf 20110808 增加医院判断
	Set tmp=argLocID
	Set argLocID=$p(tmp,"-",1)
	Set argHospID=$p(tmp,"-",2)
	Set:argType'="" argType=$ZCVT($g(argType),"U")
	Set:argAdmType'="" argAdmType=$ZCVT($g(argAdmType),"U")
	
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
		Continue:tmpLocDesc["停用"
		//add by zf 20110808 增加医院判断
		Set HospID=$p(tmp,"^",22)
		Continue:(argHospID'="")&&(HospID'=argHospID)
		//add by zf 20130225 增加科室按门诊、住院、急诊分类的过滤
		If (argType'="W")&&(argAdmType'="") {
			Continue:'$d(^PAC("ADMLOC",0,"AdmType",argAdmType,CTLocID))
		}
		
		Set:(CTLocCode[$c(10))||(CTLocCode[$c(13)) CTLocCode=$tr(CTLocCode,$c(10,13),"")
		Set:(CTLocDesc[$c(10))||(CTLocDesc[$c(13)) CTLocDesc=$tr(CTLocDesc,$c(10,13),"")
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

/// Creator：     PanLei
/// CreatDate：   2013-04-24
/// Description:  根据传入科室判断是否存在对应的病区
/// Table：       Ct_Loc,CT_LocLinkLocation
/// Input：       CT_LocLinkLocation.LINK_CTLOC_DR
/// Return：      return>0:成功  return<=0:失败
/// W ##class(DHCMed.Base.Ctloc).IsExistWardByCtLoc(293)
ClassMethod IsExistWardByCtLoc(argLocID) As %String
{
	New (argLocID)
	Set return = 0
	Quit:argLocID="" return
	
	Set $ZT = "IsExistWardByCtLocErr"
	
	Set childSubID = 0
	For {
		Set childSubID = $o(^CTLOC(argLocID,"LINK",childSubID))
		Quit:childSubID=""
		
		Set LinkLocID = $g(^CTLOC(argLocID,"LINK",childSubID))
		Set objWard = ..GetObjById(LinkLocID)
		
		If $IsObject(objWard) {
			Set return = objWard.Rowid
		}
		Quit:return>0
	}
	Quit return
	
IsExistWardByCtLocErr
	Set return = -1
	Quit return
}

/// Creator：     PanLei
/// CreatDate：   2013-04-12
/// Description:  如果科室类型CTLOC_Type为W,根据病区RowID获取其父表关联的科室RowID
/// Table：       Ct_Loc,CT_LocLinkLocation
/// Input：       CT_LocLinkLocation.LINK_CTLOC_DR
/// Return：      return>0:成功  return<=0:失败
/// W ##class(DHCMed.Base.Ctloc).GetParRefLocByWard(1035)
ClassMethod GetParRefLocByWard(WardLocationDR) As %String
{
	New (WardLocationDR)
	Set return = ""
	Quit:WardLocationDR="" return
	
	Set $ZT = "GetParRefLocByWardErr"
	
	Set ctLocRowID = ""
	For {
		Set ctLocRowID = $o(^CTLOC(ctLocRowID))
		Quit:ctLocRowID=""
		
		//过滤非住院科室患者
		Continue:'$d(^CTLOC(ctLocRowID,"LINK",0,"Loc"))
		
		Set childSubID = 0
		For {
			Set childSubID = $o(^CTLOC(ctLocRowID,"LINK",childSubID))
			Quit:childSubID=""
			
			Set LinkCtLocDR = $g(^CTLOC(ctLocRowID,"LINK",childSubID))
			If (WardLocationDR = LinkCtLocDR) {
				Set return = ctLocRowID
			}
		}
		Quit:return'=""
	}
	Quit return
	
GetParRefLocByWardErr
	Set return = -1
	Quit return
}

/// Creator：     PanLei
/// CreatDate：   2013-03-24
/// Description:  测试类,查询医院所属的科室列表,用于调试程序
/// Table：       
/// Input：       
/// Return：      返回<0,系统程序报错;
/// w ##class(DHCMed.Base.Ctloc).TestQryCTLoc()
ClassMethod TestQryCTLoc() As %String
{
	Set return=""
	Set $ZT="TestQryCTLocErr"
	
	// 总院
	Do ##class(%ResultSet).RunQuery("DHCMed.Base.Ctloc","QryCTLoc","","","-4")
	
	// 东区
	// Do ##class(%ResultSet).RunQuery("DHCMed.Base.Ctloc","QryCTLoc","","","-7")
	
	Quit return
	
TestQryCTLocErr
	Set return = -1
	Quit return
}

}

/// Creator:         wk
/// CreatDate:       2018-05-08
/// Description:	 维度维护
Class web.DHCWL.V1.KPI.DIMFunction Extends %RegisteredObject
{

/// Creator    : wk
/// CreatDate  : 2018-05-09
/// Desc       : 获取维度数据
/// Input    　：filterValue-过滤值
/// Output     : 维度数据
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.DIMFunction","GetDimInforQuery",)
Query GetDimInforQuery(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,dimCode:%String:维度编码,dimName:%String:维度名称,dimDesc:%String:维度描述,date:%String:更新日期,creator:%String:创建者,exeCode:%String:执行代码,remark:%String:备注") [ SqlProc ]
{
}

ClassMethod GetDimInforQueryExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
 	s sql="select ID,KDT_Code,KDT_Name,KDT_Desc,KDT_UpdateDate,KDT_User,KDT_ExeCode,KDT_Remark from DHCWL_MKPI.DHCWLMKPIDimType"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s code=rs.Data("KDT_Code")
		s name=rs.Data("KDT_Name")
		s desc=rs.Data("KDT_Desc")
		s date=rs.Data("KDT_UpdateDate")
		s creator=rs.Data("KDT_User")
		s exeCode=rs.Data("KDT_ExeCode")
		s remark=rs.Data("KDT_Remark")
		s:date'="" date=##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(date)
		continue:((filterValue'="")&&($zcvt(code,"U") '[ filterValue)&&($zcvt(name,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue)&&($zcvt(date,"U") '[ filterValue)&&($zcvt(creator,"U") '[ filterValue)&&($zcvt(exeCode,"U") '[ filterValue)&&($zcvt(remark,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(ID,code,name,desc,date,creator,exeCode,remark)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-05-09
/// Desc       : 获取维度属性数据
/// Input    　：filterValue-过滤值
/// Output     : 维度属性信息
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.DIMFunction","GetDimProInforQuery",)
Query GetDimProInforQuery(dimID As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,proCode:%String:维度属性编码,proName:%String:维度属性名称,proDesc:%String:维度属性描述,proExeCode:%String:执行代码,proDefActive:%String:是否默认激活,proSplitSign:%String:分隔符") [ SqlProc ]
{
}

ClassMethod GetDimProInforQueryExecute(ByRef qHandle As %Binary, dimID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:dimID="" $$$OK
 	s sql="select ID,DimPro_Code,DimPro_Name,DimPro_Desc,DimPro_ExcCode,DimPro_DefaultFlag,DimPro_ValueDeli from DHCWL_MKPI.DHCWLDimProperty where DimPro_DimDr = "_dimID
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s code=rs.Data("DimPro_Code")
		s name=rs.Data("DimPro_Name")
		s desc=rs.Data("DimPro_Desc")
		s exeCode=rs.Data("DimPro_ExcCode")
		s defFlag=rs.Data("DimPro_DefaultFlag")
		s valueDeli=rs.Data("DimPro_ValueDeli")
		s ^CacheTemp(repid,ind)=$lb(ID,code,name,desc,exeCode,defFlag,valueDeli)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator     : wk
/// CreatDate   : 2018-05-09
/// Desc        : 维度新增
/// Input       : 维度信息
/// OutPut      : 保存状态
/// Other       ：do ##Class(web.DHCWL.V1.KPI.DIMFunction).SaveDim(,"=","test","test","test")
ClassMethod SaveDim(ID, KDTCode, KDTName, KDTDesc, KDTExeCode, KDTRemark, KDTUser)
{
	//	日志记录模块(开始)		如果指定的维度编码不存在对应维度Id，则认为是新增维度数据，否则为更新维度数据
	b
	s dimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(KDTCode,"DHCWL.MKPI.MKPIDimType")
	i (""=dimId) s isDimExist="false"
	e  s isDimExist="true"
	s loginType=$case(isDimExist,"false":"MKPIDefineAdd","true":"MKPIDefineUpdate")
	s loginLoginTypeDr=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||"_loginType)
	s loginMKPIIdList="维度Id："_dimId
	d ##class(DHCWL.MKPILogin.LoginService).GetDimDefinition(dimId,.arrOld)
	i $d(arrOld) s loginPrePropertyList=##class(DHCWL.MKPILogin.LoginService).GetJsonStrByCompare(.arrOld)
	e  s loginPrePropertyList=""
	//	日志记录模块(结束)
	
	s dim("ID")=ID
	s dim("KDTCode")=KDTCode
	s dim("KDTName")=KDTName
	s dim("KDTDesc")=KDTDesc
	s dim("KDTExeCode")=KDTExeCode
	s dim("KDTRemark")=KDTRemark
	s dim("KDTUpdateDate")=$zd($p($h,",",1),3)
	s dim("KDTUser")=KDTUser
	
	if ((ID="") && (dimId'="")) {
		q "添加维度失败：维度编码已存在！"
	}
	
	s tip=##class(web.DHCWL.KPI.MaintainKpi).AddDimType(.dim)
	if (tip="ok"){
		q "保存成功"
	}else{
		q tip
	}
	
	//	日志记录模块(开始)
	s dimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(KDTCode,"DHCWL.MKPI.MKPIDimType")
	d ##class(DHCWL.MKPILogin.LoginService).GetDimDefinition(dimId,.arrNew)
	i ("false"=isDimExist){
		i $d(arrNew) s loginPostPropertyList=##class(DHCWL.MKPILogin.LoginService).GetJsonStrByCompare(.arrNew)
		e  s loginPostPropertyList=""
		s loginPrePropertyList=loginPostPropertyList
		s loginPostPropertyList=""
		s loginMKPIIdList="维度Id："_dimId
	}else
	{
		i $d(arrNew) s loginPostPropertyList=##class(DHCWL.MKPILogin.LoginService).GetJsonStrByCompare(.arrOld, .arrNew)
		e  s loginPostPropertyList=""
		s loginMKPIIdList="维度Id："_dimId
	}
	
	s jsonStr="{Operator:'"_loginOperator_"',MKPIIdList:'"_loginMKPIIdList_"',LoginTypeDr:'"_loginLoginTypeDr_"',PrePropertyList:'"_loginPrePropertyList_"',PostPropertyList:'"_loginPostPropertyList_"'}"
	i ("ok"=tip){
		s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
		s status=loginService.LoginStart(loginType,"",0)	;这里给个初值，最终取值根据LoginContent()方法确定
		s status=loginService.LoginContent(jsonStr)
		s status=loginService.LoginEnd()
	}
}

/// Creator   : wk
/// CreatDate : 2018-05-10
/// Desc      : 删除维度
/// Input     : 维度编码
/// OutPut    : 删除结果
/// other     ：do ##class(web.DHCWL.V1.KPI.DIMFunction).DeleteDim()
ClassMethod DeleteDim(KDTCode) As %String
{
	s dimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(KDTCode,"DHCWL.MKPI.MKPIDimType")
	
	//	日志记录模块(开始)
	s loginLoginTypeDr=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||MKPIDefineDelete")
	s loginMKPIIdList="维度Id："_dimId
	d ##class(DHCWL.MKPILogin.LoginService).GetDimDefinition(dimId,.arrOld)
	i $d(arrOld) s loginPrePropertyList=##class(DHCWL.MKPILogin.LoginService).GetJsonStrByCompare(.arrOld)
	e  s loginPrePropertyList=""
	//	日志记录模块(开始)
	
	q:($d(^DHCWL.MKPI.MKPIDimensionsI("DimAndOrderI",dimId))) "存在指标正在使用该维度,不能删除"
	q:($d(^DHCWL.MKPI.DimPropertyI("DimProDr",dimId))) "请删除维度下面的维度属性后再删除维度"
	q:($d(^DHCWL.MeasureDimrole.DimRoleI("DimDr",dimId))) "该维度已关联维度角色,不能删除"
	s tip=##class(web.DHCWL.KPI.MaintainKpi).DeleteDimType(KDTCode)
	&sql(delete from DHCWL_MKPI.DHCWLDimProperty where DimPro_DimDr=:dimId)
	&sql(UPDATE DHCWL_MKPI.DHCWLMKPIDim SET MKPIDim_DimDr=NULL where MKPIDim_DimDr=:dimId)
	&sql(update DHCWL_MKPI.DHCWLMKPI set MKPI_TypeDr=null where MKPI_TypeDr=:dimId)
	if (tip = "ok"){
		q "删除成功"
	}else{
		q "删除失败"
	}
	//		日志记录模块(开始)
	s loginPostPropertyList="维度已删除"
	s jsonStr="{Operator:'"_loginOperator_"',MKPIIdList:'"_loginMKPIIdList_"',LoginTypeDr:'"_loginLoginTypeDr_"',PrePropertyList:'"_loginPrePropertyList_"',PostPropertyList:'"_loginPostPropertyList_"'}"
	i ("ok"=tip){
		s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
		s status=loginService.LoginStart("MKPIDefineDelete","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
		s status=loginService.LoginContent(jsonStr)
		s status=loginService.LoginEnd()
	}
}

/// Creator   :  wk
/// CreatDate :  2018-05-10
/// Desc      :  维度属性的新增与修改
/// Input     :  维度属性信息
/// Output    :  返回执行状态
/// Other     :  do ##class(web.DHCWL.V1.KPI.DIMFunction).addDimPro()
ClassMethod addDimPro(dimId, ID As %String, Code, Name, Desc, ExcuteCode, DefaultFlag, ValueDeli As %String) As %String
{
	s deli="@"
	s dimId=##class(DHCWL.MKPIService.ConfigService).GetDimIdByCode(dimId)
	if ID="" {
		s dimCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(dimId,"DHCWL.MKPI.MKPIDimType")
		s tempId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimCode_"||"_Code,"DHCWL.MKPI.DimProperty")
		i tempId'="" {
			q "同一个维度下维度属性编码不能重复!"
		}
	}
	s setPro="Code="_Code_deli_"DimDr="_dimId_deli_"Name="_Name_deli_"Desc="_Desc_deli_"ExcuteCode="_ExcuteCode_deli_"DefaultFlag="_DefaultFlag_deli_"ValueDeli="_ValueDeli
	s ope="I",whereStr=""
	i ID'="" {
		s ope="U",whereStr=" where ID="_ID
		s setPro="DimDr="_dimId_deli_"Name="_Name_deli_"Desc="_Desc_deli_"ExcuteCode="_ExcuteCode_deli_"DefaultFlag="_DefaultFlag_deli_"ValueDeli="_ValueDeli
	}else {
		  s ope="I"
	}
	i $g(DefaultFlag)="Y" {
		d ##class(DHCWL.util.GetSetService).SetPropertyByStr("DHCWL.MKPI.DimProperty","DefaultFlag=N",deli,"U","where DimPro_DimDr="_dimId)
	}
	d ##class(DHCWL.util.GetSetService).SetPropertyByStr("DHCWL.MKPI.DimProperty",setPro,deli,ope,whereStr)
	q "操作成功"
}

/// Creator   : wk
/// CreatDate : 2018-05-10
/// Input     : 维度属性ID
/// Output    : 删除状态
/// Other     : do ##class(web.DHCWL.V1.KPI.DIMFunction).DeleteDimPro()
ClassMethod DeleteDimPro(dimProId)
{
	q:+dimProId=0 "获取维度属性失败"
	&sql(delete from DHCWL_MKPI.DHCWLDimProperty where ID =:dimProId)
	q:(SQLCODE=0) "维度属性删除成功"
	q "维度属性删除失败"
}

/// Creator    : wk
/// CreatDate  : 2018-05-11
/// Desc       : 根据维度取数规则获取取数规则树
/// Input    　：维度取数规则
/// Output     : 维度取数规则树
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.DIMFunction","GetDIMRuleTreeQuery","")
Query GetDIMRuleTreeQuery(inputRule As %String) As websys.Query(ROWSPEC = "ID:%String:ID,name:%String:描述,code:%String:编码,state:%String:是否展开,checked:%String:是否选中,_parentId:%String:父节点") [ SqlProc ]
{
}

ClassMethod GetDIMRuleTreeQueryExecute(ByRef qHandle As %Binary, inputRule As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	
 	k ^TEMPDHCWL($j)
	s dimCode=$p(inputRule,":",1)
	s ^TEMPDHCWL($j,"inputRule","normalDim",dimCode)=1
	s proRules=$p(inputRule,":",2)
	if $g(proRules)'="" d
	.s pCnt=$l(proRules,"^")
	.f j=1:1:pCnt d
	..s proCode=$p(proRules,"^",j)
	..i ($g(proCode)'="") d
	...s ^TEMPDHCWL($j,"inputRule","normalDim",dimCode,proCode)=1
	   	
   	s i=1
   	s NOBase=1
   	s loopCnt=$l(inputRule,",")
   		
	s iDimCode=$p(inputRule,":",1)

	//维度
	s dimID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(iDimCode,"DHCWL.MKPI.MKPIDimType")
	s dimText=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),3)
	s ^CacheTemp(repid,ind)=$lb(iDimCode,dimText,iDimCode,"open",,)
	s ind=ind+1
	
	//维度属性
	s upDimProCode=""
	f {
		s upDimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimID,upDimProCode))
		q:$g(upDimProCode)=""
		s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimID,upDimProCode,""))
		q:dimProID=""

		s dimProData=$g(^DHCWL.MKPI.DimPropertyD(dimProID))
		q:dimProData=""
		s dimProCode=$lg(dimProData,3)
		s dimProDes=$lg(dimProData,5)
					
		s dimProDes=##class(DHCWL.util.StringUtil).Trim(dimProDes)
		if ((dimProDes="") || (dimProDes=$c(0))) s dimProDes="!!!未设置指标维度描述信息"
		s checked=""
		i $d(^TEMPDHCWL($j,"inputRule","normalDim",iDimCode,dimProCode)) s checked="true"
		s ^CacheTemp(repid,ind)=$lb(dimProCode_dimProID,dimProDes,dimProCode,"open",checked,iDimCode)
		s ind=ind+1
	}
   	k ^TEMPDHCWL($j)
	Quit $$$OK
}

/// Creator：      	wk
/// CreatDate：    	2018-05-14
/// Description:： 	通过维度取数规则，得到基础维度、维度属性值
/// Table：       	
/// Input：         dimRule：格式：基础维度编码,基础维度编码:维度属性1^维度属性2
/// Output：        dimType:维度类型.维度属性或维度类型,dimIDV:维度值,dimProV:解析后维度属性值或基础维度值 				
/// Return：         
/// Others： 		d ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.DIMFunction","QryDimValuesQuery","AdmType:Name")
Query QryDimValuesQuery(dimRule As %String = "", dimFilter As %String = "") As websys.Query(ROWSPEC = "dimDataCode:%String,dimDataID:%String,dimDataDesc:%String") [ SqlProc ]
{
}

ClassMethod QryDimValuesQueryExecute(ByRef qHandle As %Binary, dimRule As %String = "", dimFilter As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	k ^TEMPDHCWL($j)
	K ^TEMPDHCWLCode($j)
	K ^||TEMPDHCWL("exeCodeError",$J)
	//s $ET="d ##class(DHCWL.Interface.MkpiData).RunError()"
	s errorFlag=0
	i ($g(dimRule)="") Quit $$$OK
	i ($p(dimRule,",",2)'="") Quit $$$OK
 	//解析维度规则
 	d ##class(DHCWL.MKPIService.SetKPIData).NewResovleDimRlue(dimRule,.resolved)
 	;resolved（"$DIMPARAM",基础维度编码，维度属性编码)=维度属性在基础维度中的位置
 	s dimType=""
 	f {
		s dimType=$o(resolved("$DIMPARAM",dimType)) 	
	 	q:dimType=""
	 	k map
	 	if (dimFilter'=""){
	 		s filter=##class(DHCWL.MKPIService.Base.Filter).%New()
	 		s map(dimType)=dimType
	 		d filter.ResovleFilterRule(dimFilter,.map)
	 	}
	 	s dimTypeCode=$SYSTEM.SQL.ALPHAUP(dimType)
	 	//得到维度类型的ID
	 	s dimTypeID=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",dimTypeCode,""))
	 	continue:'$d(^DHCWL.MKPI.MKPIDimTypeD(dimTypeID))
	 	//得到维度类型的执行代码
	 	s typeExeCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimTypeID),9)
	 	continue:$g(typeExeCode)=""
	 	
	 	s count=0
 		s execCode="s count=$$"_typeExeCode_"()"
		x execCode
		
		s inx = ""
		//f inx=0:1:count-1  {
		for{
			s inx=$o(^TEMPDHCWLCode($j,inx))
			q:inx=""
			s dimProInfor=dimType
			s itemList=$g(^TEMPDHCWLCode($j,inx))
			//维度的ID值
			s dimID=$p(itemList,"^",1)
			k dims
			s dimProCode=""
			if ($o(resolved("$DIMPARAM",dimType,dimProCode))'=""){
				s dimProV=""
				f {
					//维度属性编码
					s dimProCode=$o(resolved("$DIMPARAM",dimType,dimProCode))
					q:dimProCode=""
					if ($p(dimProInfor,":",2)=""){
						s dimProInfor=dimProInfor_":"_dimProCode
					}else{
						s dimProInfor=dimProInfor_"^"_dimProCode
					}
					//s dimdimProCode=dimType_"."_dimProCode
					s dims(dimType)=dimID
					s dimProCodeUP=$SYSTEM.SQL.ALPHAUP(dimProCode)
					s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimTypeID,dimProCodeUP,""))
					continue:$g(dimProID)=""
					//属性执行代码
					s proExeCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),6)
					continue:$g(proExeCode)=""
					/*s excString="s dimPro=$$"_proExeCode_"("""_dimID_""")"
					do ##class(DHCWL.util.CheckKpiData).CheckKpiExCodetest(proExeCode)
					if ($o(^||TEMPDHCWL("exeCodeError",$J,"saveExCode",""))'=""){
						s errorFlag=1
						q 
					}*/
					//x excString
					s dimPro=$$Excute^DHCWL.ExcuteLineRoutine("$$"_proExeCode,dimID)
					s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro," 	"_$char(10)_$char(13))	
					//s dims(dimdimProCode)=dimPro
					s dimProVPos=resolved("$DIMPARAM",dimType,dimProCode)
					s $p(dimProV,",",dimProVPos)=dimPro
				}
				if (errorFlag=1){
					q 
				}
				if (dimFilter'=""){
	 				s flag=filter.FilterValues(.dims)
	 				if ('flag){
		 				continue
	 				}
	 			}
				s Data=$lb($g(dimProInfor),$g(dimID),$g(dimProV))
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1		
 			}else{
	 			s i=2
	 			s dimValues=""
	 			for{
	 			s dimValue=$p(itemList,"^",i)
	 			q:dimValue=""
	 			s i=i+1
	 			if (dimValues=""){
		 			s dimValues=dimValue
	 			}else{
	 				s dimValues=dimValues_","_dimValue
	 			}
	 			}
	 			if (dimFilter'=""){
	 				s dims(dimType)=dimID
	 				s flag=filter.FilterValues(.dims)
	 				if ('flag){
		 				continue
	 				}
	 			}
	 			s Data=$lb($g(dimType),$g(dimID),$g(dimValues))
	 			Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
 			}
 			q:errorFlag=1
		}
		q:errorFlag=1
	
 	}
 	
 	k ^TEMPDHCWL($j)
	k ^TEMPDHCWLCode($j)
 	if (errorFlag=1){
 		if ($o(^||TEMPDHCWL("exeCodeError",$J,"saveExCode",""))'=""){
			s exeCode=$o(^||TEMPDHCWL("exeCodeError",$J,"saveExCode",""))
			Quit "执行代码 "_exeCode_"不存在,请维护后再进行操作"
		}
 	}
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-05-16
/// Desc       : 获取维度角色
/// Input    　：维度ID
/// Output     : 维度角色信息
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.DIMFunction","GetDimRoleInforQuery",)
Query GetDimRoleInforQuery(dimID As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,dimRoleCode:%String:维度角色编码,dimRoleName:%String:维度角色名称,dimRoleDesc:%String:维度角色描述,dimRoleCreator:%String:创建者,dimRoleDate:%String:更新日期") [ SqlProc ]
{
}

ClassMethod GetDimRoleInforQueryExecute(ByRef qHandle As %Binary, dimID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:dimID="" $$$OK
 	
 	s dimRoleCode=""
 	for{
	 	s dimRoleCode=$o(^DHCWL.MeasureDimrole.DimRoleI("DimDr",dimID,dimRoleCode))
	 	q:dimRoleCode=""
	 	s dimRoleID=$o(^DHCWL.MeasureDimrole.DimRoleI("DimDr",dimID,dimRoleCode,""))
	 	s code=$lg(^DHCWL.MeasureDimrole.DimRoleD(dimRoleID),2)
	 	s desc=$lg(^DHCWL.MeasureDimrole.DimRoleD(dimRoleID),3)
	 	s name=$lg(^DHCWL.MeasureDimrole.DimRoleD(dimRoleID),4)
	 	s creatDate=$lg(^DHCWL.MeasureDimrole.DimRoleD(dimRoleID),6)
	 	//s creatDate=$zd(creatDate,3)
	 	s:creatDate'="" creatDate=##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(creatDate)
	 	s creatUse=$lg(^DHCWL.MeasureDimrole.DimRoleD(dimRoleID),7)
	 	s voidFlag=$lg(^DHCWL.MeasureDimrole.DimRoleD(dimRoleID),8)
	 	continue:(voidFlag="1")
	 	s ^CacheTemp(repid,ind)=$lb(dimRoleID,code,name,desc,creatUse,creatDate)
		s ind=ind+1
 	}	
	Quit $$$OK
}

/// Creator:         wk
/// CreatDate:       2018-05-17
/// Description:     增加维度角色         
/// Input: 	         维度角色编码、创建者、名称、描述、维度ID		
/// Output:	         增加状态
/// Others:			d ##class(web.DHCWL.V1.KPI.DIMFunction).AddDimRole()
ClassMethod AddDimRole(code, creator, name, desc, dimID, operType)
{
	s date=$p($h,",",1)
	s result="保存失败"
	if (operType="add"){
		s dimroleID="",error=""
		for{
			s dimroleID=$o(^DHCWL.MeasureDimrole.DimRoleI("Code"," "_$zcvt(code,"U"),dimroleID))
			q:dimroleID=""
			s flag=$lg(^DHCWL.MeasureDimrole.DimRoleD(dimroleID),8)
			continue:flag=1
			if (flag'=1){
				s error=1
			}
		}
		q:(error=1) "存在相同的编码,请重新定义编码"
		&sql(INSERT INTO DHCWL_MeasureDimrole.DHCWLDimRole(Dimrole_Code,Dimrole_Desc,Dimrole_Name,Dimrole_Dr,Dimrole_CreateDate,Dimrole_CreateUse) VALUES(:code,:desc,:name,:dimID,:date,:creator))
		i SQLCODE=0{
			s result="保存成功"
		}
	}elseif(operType="modify"){
		s dimRoleID = $o(^DHCWL.MeasureDimrole.DimRoleI("Code"," "_$zcvt(code,"U"),""))
		q:'$d(^DHCWL.MeasureDimrole.DimRoleD(dimRoleID)) "未找到相关维度角色"
		&sql(update DHCWL_MeasureDimrole.DHCWLDimRole set Dimrole_Name=:name,Dimrole_Desc=:desc,Dimrole_CreateDate=:date,Dimrole_CreateUse=:creator where ID=:dimRoleID)
		i SQLCODE=0{
			s result="保存成功"
		}
	}
	q result
}

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     作废维度角色
/// Table:           
/// Input: 			维度角色ID			
/// Return:			返回执行作废操作状态
/// Others:			d ##class(DHCWL.MeasureDimroleData.FunctionModule).DeleteDimRole("")
ClassMethod DeleteDimRole(dimRoleID)
{
	s date=$p($h,",",1)
	s result="删除失败"
	q:'$d(^DHCWL.MeasureDimrole.DimRoleD(dimRoleID)) "未找到相关维度角色"
	&sql(delete from DHCWL_MeasureDimrole.DHCWLDimRole where ID=:dimRoleID)
	i SQLCODE=0{
		s result="删除成功"
	}
	q result
}

/// Creator    : wk
/// CreatDate  : 2018-11-27
/// Desc       : 根据维度取数规则获取取数规则树
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.DIMFunction","GetAllDIMTreeQuery","")
Query GetAllDIMTreeQuery(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,name:%String:描述,code:%String:编码,state:%String:是否展开,checked:%String:是否选中,_parentId:%String:父节点") [ SqlProc ]
{
}

ClassMethod GetAllDIMTreeQueryExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s:filterValue="" filterValue=$zcvt(filterValue,"U")
 	k dimList
 	
 	s dimID="" //循环获取所有维度并保存
 	for {
 		s dimID=$o(^DHCWL.MKPI.MKPIDimTypeD(dimID))
 		q:dimID=""
 		s dimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),2)
 		s dimDesc=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),3)
 		continue:((filterValue'="")&&($zcvt(dimCode,"U") '[ filterValue)&&($zcvt(dimDesc,"U") '[ filterValue))
 		s dimTreeID="D."_dimCode
 		s dimList(dimID)=dimTreeID
 		s ^CacheTemp(repid,ind)=$lb(dimTreeID,dimDesc,dimCode,"closed",,)
		s ind=ind+1
 	}

	//循环获取所有维度属性
	s dimID=""
	for {
		s dimID=$o(dimList(dimID))
		q:dimID=""
		s dimTreeID=dimList(dimID)
		s upDimProCode=""
		for{
			s upDimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimID,upDimProCode))
			q:upDimProCode=""
			s dimProID=""
			s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimID,upDimProCode,""))
			q:dimProID=""
			s dimProData=$g(^DHCWL.MKPI.DimPropertyD(dimProID))
			q:dimProData=""
			s dimProCode=$lg(dimProData,3)
			s dimProDes=$lg(dimProData,5)
			s dimProDes=##class(DHCWL.util.StringUtil).Trim(dimProDes)
			if ((dimProDes="") || (dimProDes=$c(0))) s dimProDes="!!!未设置指标维度描述信息"
			s checked=""
			s ^CacheTemp(repid,ind)=$lb("P."_dimProID,dimProDes,dimProCode,"open",checked,dimTreeID)
			s ind=ind+1
		}
	}
	Quit $$$OK
}

}

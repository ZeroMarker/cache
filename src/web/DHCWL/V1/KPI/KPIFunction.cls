/// Creator:         wk
/// CreatDate:       2018-03-09
/// Description:	 指标系统维护
Class web.DHCWL.V1.KPI.KPIFunction Extends %RegisteredObject
{

/// Creator：      wk
/// CreatDate：    2018-03-09
/// Description:： 获取指标信息
/// Table：        
/// Input：       
/// Output：      
/// Return：          
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.KPIFunction","GetKPIListQuery")
/// 
Query GetKPIListQuery(selKpiIDs As %String = "", kpiId As %String = "", kpiCode As %String = "", kpiName As %String = "", kpiDesc As %String = "", kpiExcode As %String = "", createUser As %String = "", dataNode As %String = "", nodeMark As %String = "", getValueType As %String = "", dimType As %String = "", category As %String = "", section As %String = "", filterValue As %String = "", isGroup As %String = "", filterMea As %String = "") As websys.Query(ROWSPEC = "ID:%String:指标ID,kpiCode:%String:指标编码,kpiName:%String:指标name,dimType:%String:维度,measure:%String:度量,kpiExcode:%String:执行代码,dataNode:%String:数据节点,MKPIGlobalFlag:%String:global,createUser:%String:创建者,updateDate:%String:更新日期,kpiDesc:%String:指标描述,category:%String:类型,section:%String:区间,getValueType:%String:取值方式,nodeMark:%String:备注,meaID:%String:度量ID") [ SqlProc ]
{
}

ClassMethod GetKPIListQueryExecute(ByRef qHandle As %Binary, selKpiIDs As %String = "", kpiId As %String = "", kpiCode As %String = "", kpiName As %String = "", kpiDesc As %String = "", kpiExcode As %String = "", createUser As %String = "", dataNode As %String = "", nodeMark As %String = "", getValueType As %String = "", dimType As %String = "", category As %String = "", section As %String = "", filterValue As %String = "", isGroup As %String = "", filterMea As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s:filterValue'="" filterValue=$ZCVT(filterValue,"U")
 	s sql="select ID,MKPI_Code,MKPI_Name,MKPI_Desc,MKPI_EXCode,MKPI_GlobalFlag,MKPI_User,MKPI_UpdateDate,MKPI_Remark,MKPI_TypeDr,MKPI_Cate,MKPI_SectionFlag,MKPI_DataNod,MKPI_GetValueType from DHCWL_MKPI.DHCWLMKPI"
	s orderSql=" order by ID",condSql="",noCond=" "
	s selKpiIDs = ""
	if $g(selKpiIDs)'="" {
		if condSql="" s condSql=condSql_" where"
		e  s condSql=condSql_" and "
		s condSql=condSql_" ID in ("_selKpiIDs_")"
	}
	
	if $g(kpiId)'="" {
		if condSql="" s condSql=condSql_" where"
		e  s condSql=condSql_" and "
		s condSql=condSql_" ID="_kpiId
	}
	if $g(kpiCode)'="" {
		if condSql="" s condSql=condSql_" where "
		e  s condSql=condSql_" and "
		s condSql=condSql_" MKPI_Code like '%"_kpiCode_"%'"
	}
	if $g(kpiName)'="" {
		if condSql="" s condSql=condSql_" where "
		e  s condSql=condSql_" and "
		s condSql=condSql_" MKPI_Name like '%"_kpiName_"%'"
	}
	if $g(kpiDesc)'="" {
		if condSql="" s condSql=condSql_" where "
		e  s condSql=condSql_" and "
		s condSql=condSql_" MKPI_Desc like '%"_kpiDesc_"%'"
	}
	if $g(kpiExcode)'="" {
		if condSql="" s condSql=condSql_" where "
		e  s condSql=condSql_" and "
		s condSql=condSql_" MKPI_EXCode like '%"_kpiExcode_"%'"
	}
	if $g(createUser)'="" {
		if condSql="" s condSql=condSql_" where "
		e  s condSql=condSql_" and "
		s condSql=condSql_" MKPI_User like '%"_createUser_"%'"
	}
	if $g(updateDate)'="" {
		s searDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(updateDate)
		if condSql="" s condSql=condSql_" where "
		e  s condSql=condSql_" and "
		//s condSql=condSql_" MKPI_UpdateDate = '"_$zdh(updateDate,3)_"'"
		s condSql=condSql_" MKPI_UpdateDate = '"_searDate_"'"
	}
	if $g(nodeMark)'="" {
		if condSql="" s condSql=condSql_" where "
		e  s condSql=condSql_" and "
		s condSql=condSql_" MKPI_Remark like '%"_nodeMark_"%'"
	}
	if $g(dataNode)'="" {
		if condSql="" s condSql=condSql_" where "
		e  s condSql=condSql_" and "
		s condSql=condSql_" MKPI_DataNod like '%"_dataNode_"%'"
	}
	/*if $g(globalFlag)'="" {
		if condSql="" s condSql=condSql_" where "
		e  s condSql=condSql_" and "
		if globalFlag="N" {
			s condSql=condSql_" ((MKPI_GlobalFlag = '"_globalFlag_"')or(MKPI_GlobalFlag is null))"
		}else{
			s condSql=condSql_" MKPI_GlobalFlag = '"_globalFlag_"'"
		}
	}*/
	if $g(getValueType)'="" {
		if condSql="" s condSql=condSql_" where "
		e  s condSql=condSql_" and "
		if getValueType="1" {
			s condSql=condSql_" ((MKPI_GetValueType = '"_getValueType_"')or(MKPI_GetValueType is null))"
		}else{
			s condSql=condSql_" MKPI_GetValueType = '"_getValueType_"'"
		}
	}
	if $g(dimType)'="" {
		s dimLen=$l(dimType,","),dimDeli=","
		s:dimLen<2 dimLen=$l(dimType,"，"),dimDeli="，"
		k ID,filterKpiArr,tempArr
		f i=1:1:dimLen {
			k tempArr
			s theDimName=$p(dimType,dimDeli,i)
			i theDimName="" s ID(i,0)=""
			i (theDimName="")&&(dimLen>1) continue
			;s searcheSql="select ID as dimId from DHCWL_MKPI.DHCWLMKPIDimType where KDT_Name = '"_theDimName_"'"
			;w "searcheSql="_searcheSql,!
			;s searcheSql="select MKPI_Dr from  DHCWL_MKPI.DHCWLMKPIDim where MKPIDim_Des like '%"_theDimName_"%' and MKPIDim_Order="_i
			s searcheSql="select MKPI_Dr from  DHCWL_MKPI.DHCWLMKPIDim where MKPIDim_Des like '%"_theDimName_"%'"
			s condRs=##class(%Library.ResultSet).%New()
			d condRs.Prepare(searcheSql)
			d condRs.Execute()
			While(condRs.Next()){
				;s ID(i,condRs.Data("dimId"))=""
				s mkpiDr=condRs.Data("MKPI_Dr")
				continue:((mkpiDr="")||(+mkpiDr=0))
				if (i>1){
					if ($d(filterKpiArr(mkpiDr))){
						s tempArr(mkpiDr)=""
					}
				}else{
					//s filterKpiArr(mkpiDr)=$g(filterKpiArr(mkpiDr))+1
					s filterKpiArr(mkpiDr)=""
				}
				;w "condRs.Data(dimId)="_condRs.Data("dimId"),!
			}
			d condRs.Close()
			if (i>1){
				k filterKpiArr
				m filterKpiArr=tempArr
			}
		}
		s searcheDimFlag=1
	}
	if $g(category)'="" {
		s searcheSql="select ID from DHCWL_MKPI.DHCWLMKPIFL where MKPIFL_Name like '%"_category_"%'"
		s condRs=##class(%Library.ResultSet).%New()
		d condRs.Prepare(searcheSql)
		d condRs.Execute()
		While(condRs.Next()){
			s ID(condRs.Data("ID"))=""
		}
		d condRs.Close()
		s ids="",tempId="" f  s tempId=$o(ID(tempId)) q:tempId=""  d
		.s ids=ids_tempId_","
		s ids=$e(ids,1,$l(ids)-1)
		if $g(ids)'="" {
			if condSql="" s condSql=condSql_" where "
			e  s condSql=condSql_" and "
			s condSql=condSql_" MKPI_Cate in ("_ids_")"
		}
		
		k ID
	}
	if $g(section)'="" {
		s searcheSql="select ID from DHCWL_MKPI.DHCWLSection where Sec_Name like '%"_section_"%'"
		s condRs=##class(%Library.ResultSet).%New()
		d condRs.Prepare(searcheSql)
		d condRs.Execute()
		While(condRs.Next()){
			s ID(condRs.Data("ID"))=""
		}
		d condRs.Close()
		s ids="",tempId="" f  s tempId=$o(ID(tempId)) q:tempId=""  d
		.s ids=ids_tempId_","
		s ids=$e(ids,1,$l(ids)-1)
		if $g(ids)'="" {
			if condSql="" s condSql=condSql_" where "
			e  s condSql=condSql_" and "
			s condSql=condSql_" MKPI_SectionFlag in ("_ids_")"
		}
		k ID
	}
	s sql=sql_" "_condSql_orderSql
	//s ^TEMPDHCWL("test","kpi","test")=sql
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	s num=0
	//读入可选项结束
	While(rs.Next()){
		;i (num-start)>pageSize q
		s rowKpiId=rs.Data("ID")
		i $g(searcheDimFlag)=1 {
			if ('$d(filterKpiArr(rowKpiId))) continue
		}
		s date=rs.Data("MKPI_UpdateDate"),cate=rs.Data("MKPI_Cate"),dim=rs.Data("MKPI_TypeDr"),sect=rs.Data("MKPI_SectionFlag")
		s cateId=cate,dimId=dim,sectId=sect
		if cate="" {
			s cate=""
		}elseif $g(^DHCWL.MKPI.MKPIFLD(cate))'="" {
			s cate=$list(^DHCWL.MKPI.MKPIFLD(cate),5)
		}else{
			s cate=""
		}
		i (1=1)||(dim="")||(dim=$c(0)) {
			s tempRes=""
			s tempDim="" 
			k kpiDimOrdered
			f {
				s tempDim=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",rowKpiId,tempDim))
				q:($g(tempDim)="")||(tempDim=$c(0))
				continue:(+tempDim<=0) 
				;w "tempDim="_tempDim_"  rowKpiId="_rowKpiId
				s kpiDimId=""
				f {
					s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",rowKpiId,tempDim,kpiDimId))
					q:kpiDimId=""
					s dimOrder=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6)
					s:(dimOrder="")||(dimOrder=$c(0)) dimOrder=1
					s kpiDimOrdered(dimOrder)=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),4)   ;$list(^DHCWL.MKPI.MKPIDimTypeD(tempDim),5)
				}	
			}
			s dimOrder=""
			f {
				s dimOrder=$o(kpiDimOrdered(dimOrder))
				q:dimOrder=""
				i tempRes="" s tempRes=kpiDimOrdered(dimOrder)
				e  s tempRes=tempRes_","_kpiDimOrdered(dimOrder)
			}
			s dim=$g(tempRes)
			;s dim=""
		}elseif $d(^DHCWL.MKPI.MKPIDimTypeD(dim)) {
			s tempRes=""
			s tempDim="" 
			f {
				s tempDim=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",rowKpiId,tempDim))
				q:($g(tempDim)="")||(tempDim=$c(0))
				continue:(+tempDim<=0)||('$d(^DHCWL.MKPI.MKPIDimTypeD(tempDim)))
				;w "tempDim="_tempDim_"  rowKpiId="_rowKpiId
				i tempRes="" s tempRes=$list(^DHCWL.MKPI.MKPIDimTypeD(tempDim),5)
				e  s tempRes=tempRes_","_$list(^DHCWL.MKPI.MKPIDimTypeD(tempDim),5)
			}
			//s dim=$list(^DHCWL.MKPI.MKPIDimTypeD(dim),5)
			s:($g(tempRes)="") tempRes=$list(^DHCWL.MKPI.MKPIDimTypeD(dim),5)
			s dim=$g(tempRes)
		}
		i sect="" {
			s setc=""
		}elseif $g(^DHCWL.MKPI.SectionD(sect))'="" {
			;s sectCode=$list(^DHCWL.MKPI.SectionD(sect),2)
			s sect=$list(^DHCWL.MKPI.SectionD(sect),4)
		}else {
			s sect=""
		}
		//modify by wk~2017-03-03~公司时间控件标准化
		//s:date'="" date=$zd(+date,3)
		s:date'="" date=##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(date)
		//插入一个json对象格式
		s getValueType=rs.Data("MKPI_GetValueType")
		if getValueType=1 {
			s getValueType="普通指标"
		}elseif getValueType=2 {
			s getValueType="计算指标"
		}
		if (+$g(isArrayType)=1){
			s eKpiId=rs.Data("ID")
			s kpiDimInfors=""
			s kpiOrder=""
			for{
				s kpiOrder=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",eKpiId,kpiOrder))
				q:kpiOrder=""
				s eKpiDimId=""
				s eKpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",eKpiId,kpiOrder,eKpiDimId))
				s kpiDimDesc=$lg(^DHCWL.MKPI.MKPIDimensionsD(eKpiDimId),4,"")
				s kpiDimCode=$lg(^DHCWL.MKPI.MKPIDimensionsD(eKpiDimId),2,"")
				s kpiDimInfor=kpiDimDesc_"("_kpiDimCode_")"
				if (kpiDimInfors=""){
					s kpiDimInfors=kpiDimInfor
				}else{
					s kpiDimInfors=kpiDimInfors_","_kpiDimInfor
				}
			}
		}
		s rs.Data("MKPI_Name")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_Name"),"'","\'")
		s rs.Data("MKPI_Desc")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_Desc"),"'","\'")
		s rs.Data("MKPI_EXCode")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_EXCode"),"'","\'")
		s rs.Data("MKPI_User")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_User"),"'","\'")
		s rs.Data("MKPI_Remark")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_Remark"),"'","\'")
		s rs.Data("MKPI_DataNod")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_DataNod"),"'","\'")
		s dim=##class(DHCWL.util.StringUtil).ReplaceStr(dim,"'","\'")
		s idValue=rs.Data("ID")
		s codeValue=rs.Data("MKPI_Code")
		s nameValue=rs.Data("MKPI_Name")
		s exeCodeValue=rs.Data("MKPI_EXCode")
		s dataNodeValue=rs.Data("MKPI_DataNod")
		s globalFlagValue=rs.Data("MKPI_GlobalFlag")
		s userValue=rs.Data("MKPI_User")
		s descValue=rs.Data("MKPI_Desc")
		s remarkValue=rs.Data("MKPI_Remark")
		continue:((isGroup'="")&&($d(^DHCWL.MKPI.TaskGroupDetailI("kpi"," "_$ZCVT(codeValue,"U")))))
		continue:(filterValue '= "")&&($ZCVT(idValue,"U") '[ filterValue)&&($ZCVT(codeValue,"U") '[ filterValue)&&($ZCVT(nameValue,"U") '[ filterValue)&&($ZCVT(exeCodeValue,"U") '[ filterValue)&&($ZCVT(dataNodeValue,"U") '[ filterValue)&&($ZCVT(globalFlagValue,"U") '[ filterValue)&&($ZCVT(userValue,"U") '[ filterValue)&&($ZCVT(descValue,"U") '[ filterValue)&&($ZCVT(remarkValue,"U") '[ filterValue)&&($ZCVT(dim,"U") '[ filterValue)&&($ZCVT(date,"U") '[ filterValue)&&($ZCVT(cate,"U") '[ filterValue)&&($ZCVT(sect,"U") '[ filterValue)&&($ZCVT(getValueType,"U") '[ filterValue)
		s kpiID=rs.Data("ID")
		s meaID="",meaIDs="",meaDescs=""
		for {
			s meaID=$o(^DHCWL.MKPI.MKPIMeasureI("MKPIMeaI",kpiID,meaID))
			q:meaID=""
			s meaDesc=$lg(^DHCWL.MeasureDimrole.MeasureD(meaID),3)
			if (meaIDs=""){
				s meaIDs=meaID
			}else{
				s meaIDs=meaIDs_","_meaID
			}
			if (meaDescs=""){
				s meaDescs=meaDesc
			}else{
				s meaDescs=meaDescs_","_meaDesc
			} 
		}
		continue:((filterMea'="")&&(meaDescs '[ filterMea))
		s ^CacheTemp(repid,ind)=$lb(rs.Data("ID"),rs.Data("MKPI_Code"),rs.Data("MKPI_Name"),dim,meaDescs,rs.Data("MKPI_EXCode"),rs.Data("MKPI_DataNod"),rs.Data("MKPI_GlobalFlag"),rs.Data("MKPI_User"),date,rs.Data("MKPI_Desc"),cate,sect,getValueType,rs.Data("MKPI_Remark"),meaIDs)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator：      wk
/// CreatDate：    2018-03-09
/// Description:： 获取指标类型信息
/// Table：        DHCWL_MKPI.DHCWLMKPIFL
/// Input：       
/// Output：      
/// Return：       指标类型信息   
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.KPIFunction","GetKPITypeQuery")
/// 
Query GetKPITypeQuery() As websys.Query(ROWSPEC = "typeCode:%String:指标类型编码,typeName:%String:指标类型名称") [ SqlProc ]
{
}

ClassMethod GetKPITypeQueryExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	
	s sql="select MKPIFL_Code,MKPIFL_Name from DHCWL_MKPI.DHCWLMKPIFL"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	s deli=",",str="['',''],"
	While(rs.Next()){
		s ^CacheTemp(repid,ind)=$lb(rs.Data("MKPIFL_Code"),rs.Data("MKPIFL_Name"))
		s ind=ind+1
	}
	d rs.Close()
	Quit $$$OK
}

/// Creator：      wk
/// CreatDate：    2018-03-09
/// Description:： 获取指标区间信息
/// Table：        DHCWL_MKPI.DHCWLSection
/// Input：       
/// Output：      
/// Return：       指标区间信息    
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.KPIFunction","GetKPISectionQuery")
/// 
Query GetKPISectionQuery() As websys.Query(ROWSPEC = "secCode:%String:指标类型编码,secName:%String:指标类型名称") [ SqlProc ]
{
}

ClassMethod GetKPISectionQueryExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	
	s sql="select Sec_Code,Sec_Name from DHCWL_MKPI.DHCWLSection"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	s deli=",",str="['',''],"
	While(rs.Next()){
		s ^CacheTemp(repid,ind)=$lb(rs.Data("Sec_Code"),rs.Data("Sec_Name"))
		s ind=ind+1
	}
	d rs.Close()
	Quit $$$OK
}

/// Creator：      wk
/// CreatDate：    2018-03-09
/// Description:： 获取指标维度表格信息
/// Table：        DHCWL_MKPI.DHCWLMKPIDim,DHCWL_MKPI.DHCWLMKPIDimType
/// Input：       
/// Output：      
/// Return：       指标维度表格信息    
/// Others：
/// 
Query GetKPIDimQuery(kpiID As %String = "") As websys.Query(ROWSPEC = "ID:%String:指标维度ID,MKPIDimCode:%String:指标维度编码,MKPIDimDimDr:%String:指标维度描述,KDT_Code:%String:关联维度编码,KDT_Name:%String:关联维度名称,MKPIDimOrder:%String:顺序,MKPIDimDeli:%String:分隔符") [ SqlProc ]
{
}

ClassMethod GetKPIDimQueryExecute(ByRef qHandle As %Binary, kpiID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:kpiID="" $$$OK
 	
	s sql="select t1.ID,MKPIDim_Code,MKPIDim_Des,t2.KDT_Code as MKPIDim_DimDr,t2.KDT_Name,t1.MKPIDim_Order,t1.MKPIDim_Deli from DHCWL_MKPI.DHCWLMKPIDim t1,DHCWL_MKPI.DHCWLMKPIDimType t2 where ((t1.MKPIDim_DimDr=t2.ID ))and (MKPI_Dr='"_kpiID_"') union select ID,MKPIDim_Code,MKPIDim_Des,MKPIDim_DimDr,'' as KDT_Name,MKPIDim_Order,MKPIDim_Deli from DHCWL_MKPI.DHCWLMKPIDim where MKPIDim_DimDr is null and (MKPI_Dr='"_kpiID_"') order by MKPIDim_Order"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	s deli=",",str="['',''],"
	While(rs.Next()){
		s ^CacheTemp(repid,ind)=$lb(rs.Data("ID"),rs.Data("MKPIDim_Code"),rs.Data("MKPIDim_Des"),rs.Data("MKPIDim_DimDr"),rs.Data("KDT_Name"),rs.Data("MKPIDim_Order"),rs.Data("MKPIDim_Deli"))
		s ind=ind+1
	}
	d rs.Close()
	Quit $$$OK
}

/// Creator：      wk
/// CreatDate：    2018-03-09
/// Description:： 仅仅为了程序不报错，不用这个query获取数据
/// Table：        DHCWL_MKPI.DHCWLMKPIDim,DHCWL_MKPI.DHCWLMKPIDimType
/// Input：       
/// Output：      
/// Return：       指标维度表格信息    
/// Others：	   d ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.KPIFunction","GetSelectedKPIDimQuery")
/// 
Query GetSelectedKPIDimQuery(kpiID As %String = "") As websys.Query(ROWSPEC = "MKPIDimCode:%String:指标维度编码,MKPIDimDimDr:%String:指标维度描述,KDT_Code:%String:关联维度编码,KDT_Name:%String:关联维度名称") [ SqlProc ]
{
}

ClassMethod GetSelectedKPIDimQueryExecute(ByRef qHandle As %Binary, kpiID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:kpiID="" $$$OK
 
	Quit $$$OK
}

/// Creator：      wk
/// CreatDate：    2018-03-09
/// Description:： 获取指标任务表格信息
/// Table：        
/// Input：       
/// Output：      
/// Return：       指标任务表格信息    
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.KPIFunction","GetKPITaskQuery")
/// 
Query GetKPITaskQuery(kpiId As %String = "") As websys.Query(ROWSPEC = "ID:%String:任务ID,SecCode:%String:任务编码,SecName:%String:任务名称,DTaskExcuteCode:%String:任务执行代码,DTaskExcuteCodeTip:%String:执行时执行代码,DTaskActiveFlag:%String:是否激活") [ SqlProc ]
{
}

ClassMethod GetKPITaskQueryExecute(ByRef qHandle As %Binary, kpiId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	q:(kpiId="") $$$OK
 	
	i $g(kpiId)="" d
	.s kpiCode=$g(%request.Data("kpiCode",1))
	.s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")  ;##class(DHCWL.MKPIService.ConfigService).GetKPIByName(kpiCode)
	i ""=kpiId {
		w "{success:false,info:'不存在该指标'}"
		q
	}
	s kpi=##class(DHCWL.MKPI.MKPI).%OpenId(kpiId)
	i "list-kpiTaskExc"=kpiId {
		w "{success:false,info:'不存在该指标'}"
		q
	}
	s taskSecList=""
	s count=0
	s taskAct=""  f  s taskAct=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,taskAct)) q:taskAct=""  d
	.s taskId="" f  s taskId=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,taskAct,taskId)) q:taskId=""  d
	..q:'$d(^DHCWL.MKPI.CreatDataTaskD(taskId))
	..s taskSecId=$list(^DHCWL.MKPI.CreatDataTaskD(taskId),5)
	..i +taskSecId'=0 d
	...s count=count+1
	...s taskSec=$list(^DHCWL.MKPI.SectionD(taskSecId),2)
	...s DTaskExcuteCode=$lg(^DHCWL.MKPI.CreatDataTaskD(taskId),3,"")
	...s:$ascii($e(DTaskExcuteCode,1))=0 DTaskExcuteCode=""
	...i $g(DTaskExcuteCode)'=""  s DTaskExcuteCodeTip="s monthId="_$g(DTaskExcuteCode)_"()"
	...e  s DTaskExcuteCodeTip=""
	...s sectionName=$list(^DHCWL.MKPI.SectionD(taskSecId),4)
	...i taskAct [ "Y" s taskAct2="是"  
	...e  s taskAct2="否"
	...s taskSecList=taskSecList_"{taskId:"_taskId_",SecName:'"_sectionName_"',SecCode:'"_taskSec_"',DTaskActiveFlag:'"_taskAct2_"',DTaskExcuteCode:'"_$g(DTaskExcuteCode)_"',DTaskExcuteCodeTip:'"_$g(DTaskExcuteCodeTip)_"'},"
	...s ^CacheTemp(repid,ind)=$lb(taskId,taskSec,sectionName,$g(DTaskExcuteCode),$g(DTaskExcuteCodeTip),taskAct2)
	...s ind=ind+1
	Quit $$$OK
}

/// Creator：      wk
/// CreatDate：    2018-03-09
/// Description:： 获取所有待选维度角色
/// Table：        DHCWL_MeasureDimrole.DHCWLDimRole, DHCWL_MKPI.DHCWLMKPIDimType
/// Input：       
/// Output：      
/// Return：       维度角色以及关联维度信息  
/// Others：	   d ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.KPIFunction","GetAllDimRoleQuery")
/// 
Query GetAllDimRoleQuery(filterCode As %String = "") As websys.Query(ROWSPEC = "dimRoleCode:%String:维度角色编码,dimRoleName:%String:维度角色名称,dimCode:%String:维度编码,dimName:%String:维度名称") [ SqlProc ]
{
}

ClassMethod GetAllDimRoleQueryExecute(ByRef qHandle As %Binary, filterCode As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	s value=$ZCVT(filterCode,"U")
	s sql="select a.Dimrole_Code,a.Dimrole_Name,b.KDT_Code,b.KDT_Name,b.ID from DHCWL_MeasureDimrole.DHCWLDimRole a, DHCWL_MKPI.DHCWLMKPIDimType b where a.Dimrole_Dr=b.ID order by ID"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s dimroleCode=rs.Data("Dimrole_Code")
		s dimroleName=rs.Data("Dimrole_Name")
		s dimCode=rs.Data("KDT_Code")
		s dimName=rs.Data("KDT_Name")
		continue:(value'="")&&($ZCVT(dimroleCode,"U") '[ value)&&($ZCVT(dimroleName,"U") '[ value)&&($ZCVT(dimCode,"U") '[ value)&&($ZCVT(dimName,"U") '[ value)
		s ^CacheTemp(repid,ind)=$lb(dimroleCode,dimroleName,dimCode,dimName)
		s ind=ind+1
	}
	d rs.Close()
	Quit $$$OK
}

/// Creator：      wk
/// CreatDate：    2018-03-09
/// Description:： 获取增加区间任务需要增加的任务信息
/// Table：        
/// Input：       
/// Output：      
/// Return：       获取增加区间任务需要增加的任务信息  
/// Others：	   w ##class(web.DHCWL.V1.KPI.KPIFunction).GetNextKPITask("2048")
ClassMethod GetNextKPITask(kpiCode As %String = "", existCode As %String = "")
{
	k existList,secOrderList,secCodeList
	//--获取指标绑定的区间
	if (kpiCode="") {
		s fromSection=""
	}else{
		s kpiCode=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCode)
		i +kpiCode=0 {
			s fromSection=""
		}else {
			s kpi=##class(DHCWL.MKPI.MKPI).%OpenId(kpiCode)
			i kpi.MKPISectionFlag="" s fromSection=""
			e  s fromSection=kpi.MKPISectionFlag.SecCode
		}
	}
	
	if (existCode '= "") {
		s len = $l(existCode,",")
		for i=1:1:len {
			s code=$p(existCode,",",i)
			s existList(code)=""
		}
	}
	s enforce=##class(DHCWL.MKPIService.ConfigService).GetSectionMaxToMin(.sec)
	if (enforce '= 1) {
		q "{""sc"":""指标区间维护不正确,请维护好后添加任务""}"
	}
	s order="",fromSecOrder=""
	for {
		s order=$o(sec(order))
		q:order=""
		s secID=$o(sec(order,""))
		s secCode=sec(order,secID,"C")
		s:(fromSection'="")&(fromSection=secCode) fromSecOrder=order
		s secOrderList(order,secCode)= ""
	}
	s:(fromSecOrder="") fromSecOrder=$o(secOrderList(""),-1)
	s:(fromSection="") fromSection=$o(secOrderList(fromSecOrder,""))
	
	s flag=""
	if ($d(existList(fromSection))){
		for{
			s fromSecOrder=$o(secOrderList(fromSecOrder),-1)
			s:fromSecOrder="" flag="max"
			q:(fromSecOrder="")
			s fromSection=$o(secOrderList(fromSecOrder,""))
			q:('$d(existList(fromSection)))
			
		}
	}
	if (flag="max"){
		q "{""sc"":""已经到达最大区间,不能继续增加了""}"
	}
	
	s secID=$o(sec(fromSecOrder,""))
	s taskCode=sec(fromSecOrder,secID,"C")
	s taskExeCode=sec(fromSecOrder,secID,"E")
	s taskDesc=sec(fromSecOrder,secID,"N")
	s taskFlag=##class(DHCWL.SysService.SysVarService).GetTaskInitStatus()
	q "{""code"":"""_taskCode_""",""exeCode"":"""_taskExeCode_""",""desc"":"""_taskDesc_""",""flag"":"""_taskFlag_""",""sc"":""ok""}"
}

/// Creator：      wk
/// CreatDate：    2018-03-09
/// Description:： 获取要删除的区间任务编码
/// Table：        
/// Input：       
/// Output：      
/// Return：        
/// Others：	   w ##class(web.DHCWL.V1.KPI.KPIFunction).GetDeleteTaskCode("2048")
ClassMethod GetDeleteTaskCode(taskCodes As %String = "")
{
	if (taskCodes="") {
		q "{""sc"":""没有任务,不需要删除""}"
	}
	s enforce=##class(DHCWL.MKPIService.ConfigService).GetSectionMaxToMin(.sec)
	if (enforce '= 1) {
		q "{""sc"":""指标区间维护不正确,请维护好后添加任务""}"
	}
	s order=""
	for {
		s order=$o(sec(order))
		q:order=""
		s secID=$o(sec(order,""))
		s secCode=sec(order,secID,"C")
		q:(taskCodes [ secCode)
	}
	s secID=$o(sec(order,""))
	s secCode=sec(order,secID,"C")
	q "{""secCode"":"""_secCode_""",""sc"":""ok""}"
}

/// Creator      :wk
/// CreatDate    :2018-03-23
/// Description  :获取指标任务的执行代码
/// Table        :DHCWL_MKPI.MKPI_ExecuteCode
/// Input        :secCode 区间ID
/// Return       :对应区间的执行代码
/// other         :d ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.KPIFunction","GetExeCodeListQuery")
Query GetExeCodeListQuery(secCode As %String = "") As websys.Query(ROWSPEC = "exeCodeWrite:%String:执行代码,excCodeApplicable:%String:描述") [ SqlProc ]
{
}

ClassMethod GetExeCodeListQueryExecute(ByRef qHandle As %Binary, secCode As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	Q:(secCode="") $$$OK
 	s exeCodeID=""
 	for {
	 	s exeCodeID=$o(^DHCWL.MKPI.ExecuteCodeI("TypeSubType"," TAS"," "_secCode,exeCodeID))
	 	q:exeCodeID=""
	 	s exeCode=$lg(^DHCWL.MKPI.ExecuteCodeD(exeCodeID),3)
	 	continue:(secCode="Q")&&(exeCode [ "CreatLastQuaDateAt1")
	 	s desc=$lg(^DHCWL.MKPI.ExecuteCodeD(exeCodeID),8)
	 	s ^CacheTemp(repid,ind)=$lb(exeCode,desc)
		s ind=ind+1
 	}
	Quit $$$OK
}

/// Creator     :wk
/// CreatData   :2018-03-26
/// Desc        :保存或者修改指标信息
/// Input       :指标基本信息/指标维度/指标度量
/// Output      :保存状态
/// Other       :
ClassMethod SaveKPI(baseInfor As %String = "", taskInfors As %String = "", dimInfors As %String = "", calExp As %String = "", meaInfor As %String = "", operType As %String = "")
{
	//将指标基本信息分开并根据指标编码判断指标是否存在,再进行保存或者修改
	s kpiCode=$p(baseInfor,"@",1)
	q:kpiCode="" "指标信息获取失败,请检查后重试"
	if (operType="add")&&($d(^DHCWL.MKPI.MKPII("MKPICode",$zcvt(kpiCode,"U")))){
		q "当前指标编码已存在,请重新填写"
	}
	s kpiName=$p(baseInfor,"@",2)
	s kpiDesc=$p(baseInfor,"@",9)
	s kpiMea=$p(baseInfor,"@",3)
	s kpiExcode=$p(baseInfor,"@",4)
	s dataNode=$p(baseInfor,"@",5)
	s globalFlag=$p(baseInfor,"@",6)
	s createUser=$p(baseInfor,"@",7)
	s updateDate=$p(baseInfor,"@",8)
	s category=$p(baseInfor,"@",10)
	s section=$p(baseInfor,"@",11)
	s getValueType=$p(baseInfor,"@",12)
	s nodeMark=$p(baseInfor,"@",13)
	s id=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI") 

	if getValueType="" s getValueType=1
	s pv("id")=id,pv("kpiCode")=kpiCode,pv("kpiName")=kpiName,pv("createUser")=createUser,pv("updateDate")=updateDate
	s pv("nodeMark")=nodeMark,pv("category")=category
	s pv("kpiDesc")=kpiDesc,pv("kpiExcode")=kpiExcode,pv("section")=section
	s pv("dataNode")=dataNode,pv("globalFlag")=globalFlag,pv("getValueType")=getValueType
	//日志记录模块
	//added by JEFF@2013-11-12
	s loginOperator=""
	i $d(%session.Data("LOGON.USERNAME")) s loginOperator=$g(%session.Data("LOGON.USERNAME"))
	
	s flag=0
	i ($g(id)="")||(+id=0) d
	.s result = ##class(web.DHCWL.KPI.MaintainKpi).Insert(.pv)
	.s:result'="ok" flag=1
	.//	日志记录模块(开始)
	.s loginLoginTypeDr=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDefinition")
	.s loginMKPIIdList=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCode)
	.d ##class(DHCWL.MKPILogin.LoginService).GetKpiDefinition(loginMKPIIdList,.arrOld)
	.i $d(arrOld) s loginPrePropertyList=##class(DHCWL.MKPILogin.LoginService).GetJsonStrByCompare(.arrOld)
	.s jsonStr="{Operator:'"_loginOperator_"',MKPIIdList:'"_loginMKPIIdList_"',LoginTypeDr:'"_loginLoginTypeDr_"',PrePropertyList:'"_$g(loginPrePropertyList)_"'}"
	.s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDefinition",$g(id))
	.i (("ok"=result)&&(1=shouldBeLogged)) d
	..s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
	..s status=loginService.LoginStart("KpiLogDefinition","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
	..s status=loginService.LoginContent(jsonStr)
	..s status=loginService.LoginEnd()
	.//	日志记录模块(结束)
	e  d
	.//	日志记录模块(开始)
	.s loginLoginTypeDr=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||MKPIDefineUpdate")
	.s loginMKPIIdList=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCode)
	.d ##class(DHCWL.MKPILogin.LoginService).GetKpiDefinition(loginMKPIIdList,.arrOld)
	.i $d(arrOld) s loginPrePropertyList=##class(DHCWL.MKPILogin.LoginService).GetJsonStrByCompare(.arrOld)
	.//	日志记录模块(开始)
	.TSTART
	.s result = ##class(web.DHCWL.KPI.MaintainKpi).Update(id,.pv)
	.i result="ok" TCOMMIT
	.e  TROLLBACK
	.s:result'="ok" flag=1
	.//	日志记录模块(开始)
	.//	指标更新日志，仅记录修改了记录的日志项
	.d ##class(DHCWL.MKPILogin.LoginService).GetKpiDefinition(loginMKPIIdList,.arrNew)
	.i $d(arrNew) s loginPostPropertyList=##class(DHCWL.MKPILogin.LoginService).GetJsonStrByCompare(.arrOld,.arrNew)
	.s jsonStr="{Operator:'"_loginOperator_"',MKPIIdList:'"_loginMKPIIdList_"',LoginTypeDr:'"_loginLoginTypeDr_"',PrePropertyList:'"_$g(loginPrePropertyList)_"',PostPropertyList:'"_$g(loginPostPropertyList)_"'}"
	.s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDefinition",$g(id))
	.i ("ok"=result)&&(""'=$g(loginPostPropertyList))&&(1=shouldBeLogged) d
	..s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
	..s status=loginService.LoginStart("KpiLogDefinition","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
	..s status=loginService.LoginContent(jsonStr)
	..s status=loginService.LoginEnd()
	.//	日志记录模块(结束)
	
	q:flag'=0 result
	
	s id=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
	
	s sc=##class(web.DHCWL.V1.KPI.KPIFunction).SaveKPIDim(id,dimInfors)
	q:sc'="ok" "指标维度安装失败"
	
	if ((getValueType=2)||(getValueType="计算指标")) {
		s sc=##Class(web.DHCWL.V1.KPI.KPIFunction).SaveCalKPIRule(id,calExp)
		q:sc'="ok" sc
	}else{
		s sc=##class(web.DHCWL.V1.KPI.KPIFunction).SaveKPITask(id,taskInfors)
		q:sc'="ok" sc  //"指标任务安装失败"
	}
	
	s sc=##class(web.DHCWL.V1.KPI.KPIFunction).SaveKPIMea(id,meaInfor)
	
	q sc
	q "ok"
}

/// Creator      : wk
/// CreatDate    : 2018-11-05
/// Desc         : 保存指标度量
/// Other        : do ##class(web.DHCWL.V1.KPI.KPIFunction).SaveKPIMea()
ClassMethod SaveKPIMea(kpiId As %String, kpiMeaIDs As %String)
{
	q:kpiMeaIDs="" "ok"
	s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiId,"DHCWL.MKPI.MKPI")
	i +kpiId=0 {
		q "不存在该指标"
	}
	s flag=0
	s meaID=""
	for {
		s meaID=$o(^DHCWL.MKPI.MKPIMeasureI("MKPIMeaI",kpiId,meaID))
		q:meaID=""
		s rowID=$o(^DHCWL.MKPI.MKPIMeasureI("MKPIMeaI",kpiId,meaID,""))
		if (kpiMeaIDs '[ rowID){
			&sql(delete from DHCWL_MKPI.DHCWLMKPIMeasure where ID=:rowID)
			if (SQLCODE'=0){
				s flag="删除原有度量失败"
				q
			}
		}
	}
	q:flag'=0 flag
	s nowDate=$p($h,",",1)
	s len=$l(kpiMeaIDs,"||")
	for i=1:1:len {
		s meaID=$p(kpiMeaIDs,"||",i)
		continue:meaID=""
		if ('$d(^DHCWL.MKPI.MKPIMeasureI("MKPIMeaI",kpiId,meaID))){
			&sql(INSERT INTO DHCWL_MKPI.DHCWLMKPIMeasure (MKPI_MeaDr,MKPI_KpiDr,Mea_CreateDate) VALUES(:meaID,:kpiId,:nowDate))
			if SQLCODE'=0 {
				s flag="保存失败"
				q
			}
		}
	}
	if (flag'=0){
		q "度量保存出错啦"
	}else{
		q "ok"
	}
}

/// Creator      : wk
/// CreatDate    : 2018-03-27
/// Desc         : 删除指标
/// Other        : do ##class(web.DHCWL.V1.KPI.KPIFunction).DeleteKPI()
ClassMethod DeleteKPI(ids)
{
	s loginOperator=""
	i $d(%session.Data("LOGON.USERNAME")) s loginOperator=$g(%session.Data("LOGON.USERNAME"))
	s IDInfors=""
	s IDs=ids
	s IDsLength=$l(IDs,",")
	for i=1:1:IDsLength{
		s IDInfor=$p(IDs,",",i)
		continue:IDInfor=" "
		if (IDInfors=""){
			s IDInfors=IDInfor
		}else{
			s IDInfors=IDInfors_","_IDInfor
		}
	}
	s IDs=IDInfors
	s IDsLength=$l(IDs,",")
	//判断要删除的指标是否是运算指标中运算关系的一部分。如果是，就退出
	s usedCodes=""
	d ##class(DHCWL.CSPService.calService).getCalPrtor(.calPrtor)
	f i=1:1:IDsLength { 
		s id=$p(IDs,",",i)
		s kpiCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(id,"DHCWL.MKPI.MKPI")
		if $d(calPrtor(kpiCode)) {
			if usedCodes'="" s usedCodes=usedCodes_","
			s usedCodes=usedCodes_calPrtor(kpiCode)
		}
		
	}

	if usedCodes'="" {
		//w "{success:true,tip:'要删除的指标被下面的指标配置了运算关系，请先修改下面指标的运算关系:"_usedCodes_"'}"
		q "要删除的指标被下面的指标配置了运算关系，请先修改下面指标的运算关系:"_usedCodes
	}
	
	s loginLoginTypeDr=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||MKPIDefineUpdate")
	s hasError=0
	TSTART
	f i=1:1:IDsLength { 
		s id=$p(IDs,",",i)
		s loginMKPIIdList=id
		k arrOld
		d ##class(DHCWL.MKPILogin.LoginService).GetKpiDefinition(loginMKPIIdList,.arrOld)
		i $d(arrOld) s loginPrePropertyList=##class(DHCWL.MKPILogin.LoginService).GetJsonStrByCompare(.arrOld)
		//		日志记录模块(结束)
		;add by wz.2015-6-15.删除指标时也删除数据集中取数规则的指标
		s result=##class(DHCWL.MKPI.MMgrDataSetCfg).RejectKpiFromRule(id)
		i result'="ok" {
			//w "{success:true,tip:'"_result_"'}"
			s hasError=1
			q 
		}
		
		;add by wz.2015-7-5.删除指标时也删除运算关系表达式
		s result=##class(DHCWL.MKPI.CalExpDef).DelCalExpByKPIIDs(id)
		i result'="ok" {
			//w "{success:true,tip:'"_result_"'}"
			s hasError=1
			q
		}
		
		s result = ##class(web.DHCWL.KPI.MaintainKpi).Delete(id)
		;w "{success:true,tip:'"_result_"'}"
		//		日志记录模块(开始)
		s loginPostPropertyList="指标已删除"
		s jsonStr="{Operator:'"_loginOperator_"',MKPIIdList:'"_loginMKPIIdList_"',LoginTypeDr:'"_loginLoginTypeDr_"',PrePropertyList:'"_$g(loginPrePropertyList)_"',PostPropertyList:'"_$g(loginPostPropertyList)_"'}"
		s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDefinition",loginMKPIIdList)
		i ("ok"=result)&&(1=shouldBeLogged) {
			s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
			s status=loginService.LoginStart("KpiLogDefinition","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
			s status=loginService.LoginContent(jsonStr)
			s status=loginService.LoginEnd()
		}
		//		日志记录模块(结束)
		//		删除该指标关联的日志配置
		s status=##class(DHCWL.MKPILogin.MKPILoginService).MKPILoginDelete(id)
		i "ok"'=result {
			//w "{success:true,tip:'"_result_"'}"
			s hasError=1
			q
		}
	}
	if hasError=1 {
		TROLLBACK
		q "保存失败"
	}else{
		//w "{success:true,tip:'ok'}"
		TCOMMIT
		q "删除成功"
	}
}

/// Creator      : wk
/// CreatDate    : 2018-03-27
/// Desc         : 指标维度保存方法
/// Input        : 指标信息
/// Output       ：保存状态
/// Other        ：do ##class(web.DHCWL.V1.KPI.KPIFunction).SaveKPIDim()
ClassMethod SaveKPIDimold(kpiId As %String, kpiDimInfors As %String)
{
	q:kpiDimInfors="" "ok"
	s flag=0
	k kpiDimList
	s dimLen=$L(kpiDimInfors,"@")
	for i=1:1:dimLen {
		s kpiDimInfor=$p(kpiDimInfors,"@",i)
		s kpiDimCode=$p(kpiDimInfor,"||",1)
		continue:kpiDimCode=""
		s order=$p(kpiDimInfor,"||",2)
		s deli=$p(kpiDimInfor,"||",3)
		s kpiDimList(order,kpiDimCode)=deli
	}
	
	s kpiCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(kpiId,"DHCWL.MKPI.MKPI")
	k dimOrderList,kpiDimCodeList
	s flag=0,error=""
	s len=$l(kpiDimInfors,"@")
	//检查是否有重复的指标维度
	for i=1:1:len {
		s kpiDimInfor=$p(kpiDimInfors,"@",i)
		s kpiDimCode=$p(kpiDimInfor,"||",1)
		s upKpiDimCode=$zcvt(kpiDimCode,"U")
		if $d(kpiDimCodeList(upKpiDimCode)){
			s flag=1,error="存在相同的指标维度编码"
		}
		s kpiDimCodeList(upKpiDimCode)=""
	}
	q:flag=1 error
	for i=1:1:len {
		s kpiDimInfor=$p(kpiDimInfors,"@",i)
		s kpiDimCode=$p(kpiDimInfor,"||",1)
		s dimOrder=$p(kpiDimInfor,"||",2)
		s dimOrderList(dimOrder)=""
		s dimDeli=$p(kpiDimInfor,"||",3)
		s dimRoleID=$o(^DHCWL.MeasureDimrole.DimRoleI("Code"," "_$ZCVT(kpiDimCode,"U"),""))
		continue:dimRoleID=""
		s dimId=$lg(^DHCWL.MeasureDimrole.DimRoleD(dimRoleID),5)
		s kpiDimName=$lg(^DHCWL.MeasureDimrole.DimRoleD(dimRoleID),3)
		if ('$d(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpiId,dimOrder))){  //如果不存在则插入
			&sql(INSERT INTO DHCWL_MKPI.DHCWLMKPIDim(MKPIDim_Code,MKPI_Dr,MKPIDim_Des,MKPIDim_DimDr,MKPIDim_Order,MKPIDim_Deli) VALUES(:kpiDimCode,:kpiId,:kpiDimName,:dimId,:dimOrder,:dimDeli))
			i (SQLCODE'=0) {
				s flag=1,error="保存数据失败"
				q
			}
		}else{   //如果存在则更新
			s kpiDimId="",num=0
			for{
				s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpiId,dimOrder,kpiDimId))
				q:kpiDimId=""
				s num=num+1
				if (num>=2){
					s sc=##class(DHCWL.MKPI.MKPIDimensions).%DeleteId(kpiDimId)
					if (sc'=1){
						s flag=1,error="删除多余数据失败"
						q
					}
					continue
				}
			
				s locKpiDimCode=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),2)
				s locKpiDimDesc=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),4)
				s locKpiDimDeli=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),7)
				s locDimId=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5)
				if ((locKpiDimCode'=kpiDimCode)||(locKpiDimDesc'=kpiDimName)||(locKpiDimDeli'=dimDeli)||(locDimId'=dimId)){
					&sql(update DHCWL_MKPI.DHCWLMKPIDim set MKPIDim_Code=:kpiDimCode,MKPIDim_Des=:kpiDimName,MKPIDim_DimDr=:dimId,MKPIDim_Deli=:dimDeli where ID=:kpiDimId)
					i (SQLCODE'=0) {
						s flag=1,error="更新已有指标信息失败"
						q
					}
				}
			}
		}
		q:flag=1
		
	}
	//删除多余的指标维度
	s dimOrder=""
	for{
		 s dimOrder=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpiId,dimOrder))
		 q:dimOrder=""
		 if ('$d(dimOrderList(dimOrder))){
			 s kpiDimId=""
			 for{
			 	s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpiId,dimOrder,kpiDimId))
			 	q:kpiDimId=""
			 	&sql(delete from DHCWL_MKPI.DHCWLMKPIDim where ID=:kpiDimId)
			 	i (SQLCODE'=0) {
				 	s flag=1,error="删除多余指标维度失败"
				 	q
			 	}
			 }
			 q:flag=1
		 }
	}
	q:(flag=1) error
	q "ok"
}

/// Creator      : wk
/// CreatDate    : 2018-03-27
/// Desc         : 指标维度保存方法
/// Input        : 指标信息
/// Output       ：保存状态
/// Other        ：do ##class(web.DHCWL.V1.KPI.KPIFunction).SaveKPIDim()
ClassMethod SaveKPIDim(kpiId As %String, kpiDimInfors As %String)
{
	q:kpiDimInfors="" "ok"
	k kpiDimList
	s errorFlag=0
	s dimLen=$L(kpiDimInfors,"@")
	for i=1:1:dimLen {           //遍历传入的指标维度信息
		s kpiDimInfor=$p(kpiDimInfors,"@",i)
		s kpiDimCode=$p(kpiDimInfor,"||",1)
		continue:kpiDimCode=""
		s order=$p(kpiDimInfor,"||",2)
		s deli=$p(kpiDimInfor,"||",3)
		s:deli="" deli=","
		s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,$zcvt(kpiDimCode,"U"),"")) //判断传入的指标维度是否已有
		if (kpiDimId=""){
			s dimRoleID=$o(^DHCWL.MeasureDimrole.DimRoleI("Code"," "_$ZCVT(kpiDimCode,"U"),""))
			if (dimRoleID=""){
				s errorFlag=1
				q
			}
			s dimId=$lg(^DHCWL.MeasureDimrole.DimRoleD(dimRoleID),5)
			s kpiDimName=$lg(^DHCWL.MeasureDimrole.DimRoleD(dimRoleID),4)
			s kpiDimList(kpiDimCode,kpiDimName,dimId,order,deli,"insert")=""
		}else{
			s kpiDimName=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),4)
			s dimId=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5)
			s kpiDimList(kpiDimCode,kpiDimName,dimId,order,deli,"update")=kpiDimId
		}
	}
	q:errorFlag=1 "获取指标维度信息失败"
	
	s kpiDimCode=""
	for {
		s kpiDimCode=$o(kpiDimList(kpiDimCode))
		q:kpiDimCode=""
		s kpiDimName=$o(kpiDimList(kpiDimCode,""))
		s dimId=$o(kpiDimList(kpiDimCode,kpiDimName,""))
		s order=$o(kpiDimList(kpiDimCode,kpiDimName,dimId,""))
		s deli=$o(kpiDimList(kpiDimCode,kpiDimName,dimId,order,""))
		s type=$o(kpiDimList(kpiDimCode,kpiDimName,dimId,order,deli,""))
		if (type="update"){
			s kpiDimId=kpiDimList(kpiDimCode,kpiDimName,dimId,order,deli,type)
			&sql(update DHCWL_MKPI.DHCWLMKPIDim set MKPIDim_Code=:kpiDimCode,MKPIDim_Des=:kpiDimName,MKPIDim_DimDr=:dimId,MKPIDim_Deli=:deli,MKPIDim_Order=:order where ID=:kpiDimId)
			i (SQLCODE'=0) {
				s flag=1,errorFlag="保存数据失败"
				q
			}
		}elseif(type="insert"){
			&sql(INSERT INTO DHCWL_MKPI.DHCWLMKPIDim(MKPIDim_Code,MKPI_Dr,MKPIDim_Des,MKPIDim_DimDr,MKPIDim_Order,MKPIDim_Deli) VALUES(:kpiDimCode,:kpiId,:kpiDimName,:dimId,:order,:deli))
			i (SQLCODE'=0) {
				s flag=1,errorFlag="保存数据失败"
				q
			}
		}
	}
	q:errorFlag'=0 errorFlag
	
	s kpiDimCode=""
	for {
		s kpiDimCode=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,kpiDimCode))
		q:kpiDimCode=""
		s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,kpiDimCode,""))
		s realKpiDimCode=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),2)
		if ('$d(kpiDimList(realKpiDimCode))){
			&sql(delete from DHCWL_MKPI.DHCWLMKPIDim where ID=:kpiDimId)
		 	i (SQLCODE'=0) {
			 	s flag=1,errorFlag="删除多余指标维度失败"
			 	q
		 	}
		}
	}
	q:errorFlag'=0 errorFlag
	q "ok"
}

/// Creator   : wk
/// CreatDate : 2018-03-27
/// Desc      : 保存或者修改指标任务
/// Input     : 传入要保存或者修改的任务信息
/// OutPut    : 返回保存或者修改的状态
/// Other     : do ##class(web.DHCWL.V1.KPI.KPIFunction).SaveKPITask()
ClassMethod SaveKPITask(kpiId, kpiTaskInfors)
{
	q:kpiTaskInfors="" "ok"
	s kpiCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(kpiId,"DHCWL.MKPI.MKPI")
	s taskList=kpiTaskInfors
	s taskLen=$l(taskList,"@")
	s tip=##class(DHCWL.Interface.MKPI.KpiData).CheckKpiTaskByItface(taskList)
	if (tip'="ok"){
		q tip
	}
	s flag=0
	k taskCodeList
	f i=1:1:taskLen {
		k taskD
		s task=$p(taskList,"@",i)
		s taskD("DTaskKPIDR")=kpiCode
		s taskD("DTaskMonthExcuteCode")=$p(task,"||",1)
		s taskD("DTaskExcuteCode")=$p(task,"||",2)
		s taskD("DTaskActiveFlag")=$p(task,"||",3)
		s taskD("DTaskSectionDR")=##class(web.DHCWL.KPI.MaintainKpi).GetKpiSecByCode(taskD("DTaskMonthExcuteCode"))
		s taskCodeList(taskD("DTaskSectionDR"))=""
		s tip=##class(web.DHCWL.KPI.TaskService).AddTask(.taskD)
		if tip'="ok" {
			s flag=1
			q
		}
	}
	q:flag=1 "error"
	s actSign="",flag=0
	for {
		s actSign=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,actSign))
		q:actSign=""
		s kpiTaskID=""
		for {
			s kpiTaskID=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,actSign,kpiTaskID))
			q:kpiTaskID=""
			s secID=$lg(^DHCWL.MKPI.CreatDataTaskD(kpiTaskID),5)
			if ('$d(taskCodeList(secID))){
				s infor=##class(web.DHCWL.KPI.TaskService).DeleteTask(kpiId,secID)
				s:(infor'="ok") flag=1
				q:(infor'="ok")
			}
		}
		q:flag=1
	}
	q:flag=1 "指标任务维护失败"
	q "ok"
}

/// Creator    : wk
/// CeatData   : 2018-05-07
/// Desc       : 保存计算指标运算规则
/// Input      : 指标ID/计算指标规则/计算指标汇总维度
/// Output     ：返回保存信息
/// Other      : do ##Class(web.DHCWL.V1.KPI.KPIFunction).SaveCalKPIRule()
ClassMethod SaveCalKPIRule(kpiID As %String, calExp As %String) As %String
{
	s curKpiID=kpiID
	s calExp=calExp
	s calRel=$p(calExp,"|",1)
	s sumDim=$p(calExp,"|",2)
	q:((calRel="")&&(sumDim="")) "ok"
	
	s successFlag=0
	//检查用户配置的汇总维度和运算关系是否合法
	s validDim=##class(DHCWL.CSPService.calService).CheckSumDim(curKpiID,sumDim,calRel,.retTip)
	if validDim=0 {
		q retTip
	}
	Set kpiObj = ##class(DHCWL.MKPI.MKPI).%OpenId(curKpiID)
	if $ISOBJECT(kpiObj) {
		s kpiCode=kpiObj.MKPICode
		s calExpID=$o(^DHCWL.MKPI.CalExpDefI("KPICODE",kpiCode,""))
		if (calExpID)'="" {
			//修改
			s calExpObj=##class(DHCWL.MKPI.CalExpDef).%OpenId(calExpID)
			if $ISOBJECT(calExpObj) {
				s calExpObj.CalExp=calRel
				s calExpObj.SumDim=sumDim
				s calExpObj.KpiCode=kpiCode
				Set sc = calExpObj.%Save()
				If $$$ISERR(sc) {
					s successFlag=-1
				}			
			}else{
				s successFlag=-1
			}
		}else{
			//新增
			s calExpObj=##class(DHCWL.MKPI.CalExpDef).%New()
			s calExpObj.CalExp=calRel
			s calExpObj.SumDim=sumDim
			s calExpObj.KpiCode=kpiCode
			Set sc = calExpObj.%Save()
			If $$$ISERR(sc) {
				s successFlag=-1
			}
		}
	}else{
		s successFlag=-1
	}
	
	if successFlag=0 {
		q "ok"
	}else{
		q "计算指标保存失败！"	
	}
}

/// Creator   : wk
/// CreatData : 2018-05-07
/// Desc      : 获取计算指标规则以及汇总维度
/// Input     : 指标ID
/// Output    : 计算指标规则以及汇总维度
/// Other     : do ##class(web.DHCWL.V1.KPI.KPIFunction).GetCalKPIConfig()
ClassMethod GetCalKPIConfig(kpiID As %String) As %String
{
	s curKpiID=kpiID
	Set kpiObj=##class(DHCWL.MKPI.MKPI).%OpenId(curKpiID)
				
	s calExp=""
	s sumDim=""

	if $ISOBJECT(kpiObj) {
		s kpiCode=kpiObj.MKPICode
		s calExpID=$o(^DHCWL.MKPI.CalExpDefI("KPICODE",kpiCode,""))
		if (calExpID)'="" {
			s calExpObj=##class(DHCWL.MKPI.CalExpDef).%OpenId(calExpID)
			if $ISOBJECT(calExpObj) {
				s calExp=calExpObj.CalExp
				s sumDim=calExpObj.SumDim
			}
		}
	}
	q calExp_"|"_sumDim
}

/// Creator    : wk
/// CreatData  : 2018-03-29
/// Desc       : 获取指标日志维护信息
/// Input      : 指标ID
/// Output     : 指标日志配置信息
/// Other      ：d ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.KPIFunction","GetKPILogQuery",,"KpiLogDefinition","","1")
Query GetKPILogQuery(kpiIds As %String = "", type As %String = "", filterValue As %String = "", isLogConfig As %String) As websys.Query(ROWSPEC = "KpiLogDefinition:%String:指标定义日志,KpiLogDataProcess:%String:数据处理日志,KpiLogDataQuery:%String:数据查询日志,KpiLogTaskErr:%String:任务错误日志,kpiCode:%String:指标编码") [ SqlProc ]
{
}

ClassMethod GetKPILogQueryExecute(ByRef qHandle As %Binary, kpiIds As %String = "", type As %String = "", filterValue As %String = "", isLogConfig As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s logTypeDr=""
 	i (""'=type) s logTypeDr=$o(^DHCWL.MKPI.APPLibraryI("AppForCodeI",$zcvt("LoginType","U"),$zcvt(type,"U"),""))
 	//s logTypeDr=""
 	q:((kpiIds="")&&(isLogConfig="")) $$$OK
	s len=$l(kpiIds,",")
	s counter=0
	f i=1:1:len d
	.s kpiId=$p(kpiIds,",",i)	
	.s currentKpiId="" f  s currentKpiId=$o(^DHCWL.MKPI.MKPILoginI("MKPIDr",currentKpiId),-1) q:currentKpiId=""  d
	..q:(""'=type)&&(0=(##class(DHCWL.MKPILogin.MKPILoginService).IsActive(logTypeDr,currentKpiId)))
	..q:((kpiId'="")&&(kpiId'=currentKpiId))  	//edited by lhh
	..q:('$d(^DHCWL.MKPI.MKPID(currentKpiId)))   	//edited by lhh
	..s kpiCode=$lg(^DHCWL.MKPI.MKPID(currentKpiId),2)
	..q:((filterValue'="")&&(kpiCode'[filterValue))
	..s counter=counter+1
	..s arrs(counter,"kpiCode")=kpiCode
	..s rowId="" f  s rowId=$o(^DHCWL.MKPI.MKPILoginI("MKPIDr",currentKpiId,rowId),-1) q:rowId=""  d
	...s loginTypeDr=$lg(^DHCWL.MKPI.MKPILoginD(rowId),3)
	...q:((loginTypeDr="")||(+loginTypeDr<0))
	...s loginTypeCode=##class(DHCWL.MKPI.APPLibrary).GetCodeById(loginTypeDr)
	...s loginTypeCode=$p(loginTypeCode,"||",2)
	...s activeFlag=$lg(^DHCWL.MKPI.MKPILoginD(rowId),4)
	...s arrs(counter,loginTypeCode)=activeFlag
 	
 	s order="" f  s order=$o(arrs(order)) q:order=""  d
 	.s defineLog=arrs(order,"KpiLogDefinition")
 	.s processLog=arrs(order,"KpiLogDataProcess")
 	.s queryLog=arrs(order,"KpiLogDataQuery")
 	.s errorLog=arrs(order,"KpiLogTaskErr")
 	.s kpiCode=arrs(order,"kpiCode")
 	.s ^CacheTemp(repid,ind)=$lb(defineLog,processLog,queryLog,errorLog,kpiCode)
 	.s ind=ind+1
 	
 	//s ^CacheTemp(repid,ind)=$lb(arrs(1,"KpiLogDefinition"),arrs(1,"KpiLogDataProcess"),arrs(1,"KpiLogDataQuery"),arrs(1,"KpiLogTaskErr"))
	//s ind=ind+1
 	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-03-29
/// Desc       : 获取已选中指标信息
/// Input    　：指标串
/// Output     : 指标的ID code  描述
/// Other      :
Query GetSelectedKPIQuery(kpiIDs As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,kpiCode:%String:指标编码,kpiName:%String:指标描述") [ SqlProc ]
{
}

ClassMethod GetSelectedKPIQueryExecute(ByRef qHandle As %Binary, kpiIDs As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	Q:(kpiIDs="") $$$OK
 	s sql="select ID,MKPI_Code,MKPI_Name from DHCWL_MKPI.DHCWLMKPI where ID in ("_kpiIDs_")"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s code=rs.Data("MKPI_Code")
		s name=rs.Data("MKPI_Name")
		s ^CacheTemp(repid,ind)=$lb(ID,code,name)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-03-30
/// Desc       : 运行生成数据的方法
/// Input      : 需要生成数据指标/开始日期/结束日期
/// Output     : 返回生成状态
/// Other      ：do ##class(web.DHCWL.V1.KPI.KPIFunction).CreatKPIData()
ClassMethod CreatKPIData(kpiIDs, startDate, endDate, reFlag = "1")
{
	s kpiIds=kpiIDs
	s sd=startDate
	s ed=endDate
	//s reFlag=1
	s dataFlag=$h
	s date=$p(dataFlag,",",1)
	s time=$p(dataFlag,",",2)
	s dataFlag=date_time
	s startValue=""
	s endValue=""
	
	//add by wk~2017-03-09~公司时间控件标准化
	if (sd'=""){
		s sd=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(sd)
		s startValue=sd
		s sd=$zd(sd,3)
	} 
	
	if (ed'=""){
		s ed=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(ed)
		s endValue=ed
		s ed=$zd(ed,3) 
		s endDateT=$zdh(ed,3)
		if endDateT>+$h {
			s ed=$zd(+$h,3)	
		}
	}
	q:(endValue<startValue) "{""dataFlag"":"""_0_""",""tip"":""order""}"
	//删除用来记录生成数据进程用到的global
	k ^TEMPDHCWL("creatKpiDate","checkNumber"),^TEMPDHCWL("recordCurrentPlan","plan"),^TEMPDHCWL("recordMonIDTotal","monthID"),^TEMPDHCWL("recordMonIDCurrent","monthID")
	
	job ##class(DHCWL.Interface.MkpiData).GetKpiDataProgress(sd,ed,kpiIds,reFlag)
	
	q "{""dataFlag"":"""_dataFlag_""",""tip"":""ok""}"
}

/*ClassMethod getCreateDataPlan(rowID As %String)
{
	s kpiDataFlag=rowID
	s dataProcess=$g(^TEMPDHCWL("recordCurrentPlan","plan"),0)
	s value=$g(^TEMPDHCWL("creatKpiDate","checkNumber"))
	if (value'=""){
		s processValue=$p(value,"^",1)
		s number=$p(value,"^",2)
		if (processValue=""||number=""){
			s value=kpiDataFlag_"^"_0
			s ^TEMPDHCWL("creatKpiDate","checkNumber")=value
		}else{
			if (processValue=kpiDataFlag){
				s number=(+number)+1
				if (number=100){
					s dataProcess=-1
				}
				s value=kpiDataFlag_"^"_number
				s ^TEMPDHCWL("creatKpiDate","checkNumber")=value
			}else{
				s value=kpiDataFlag_"^"_0
				s ^TEMPDHCWL("creatKpiDate","checkNumber")=value
			}
		}
	}else{
		s value=kpiDataFlag_"^"_0
		s ^TEMPDHCWL("creatKpiDate","checkNumber")=value
	}
	if (dataProcess=-1){
		k ^TEMPDHCWL("creatKpiDate","checkNumber")
		k ^TEMPDHCWL("recordCurrentPlan","plan")
		k ^TEMPDHCWL("recordMonIDTotal","monthID")
		k ^TEMPDHCWL("recordMonIDCurrent","monthID")
		q -1
	}else{
		if (dataProcess>=1){
			s dataProcess=1
			k ^TEMPDHCWL("creatKpiDate","checkNumber")
		    k ^TEMPDHCWL("recordCurrentPlan","plan")
			k ^TEMPDHCWL("recordMonIDTotal","monthID")
			k ^TEMPDHCWL("recordMonIDCurrent","monthID")
		}
		q $FNUMBER(dataProcess,"+",3)*100
	}
}*/
/// Creator    :  wk
/// CreatDate  :  2018-03-30
/// Desc       :  获取生成数据进度
/// Input　　　： 本次生成数据的唯一标识
/// Output     ： 返回进度
/// Other      :  do
ClassMethod getCreateDataPlan(rowID As %String)
{
	s kpiDataFlag=rowID
	s dataProcess=$g(^TEMPDHCWL("KPI","CreatDate","progress","currentProgress"),0)
	s value=$g(^TEMPDHCWL("creatKpiDate","checkNumber"))
	if (value'=""){
		s processValue=$p(value,"^",1)
		s number=$p(value,"^",2)
		if (processValue=""||number=""){
			s value=kpiDataFlag_"^"_0
			s ^TEMPDHCWL("creatKpiDate","checkNumber")=value
		}else{
			if (processValue=kpiDataFlag){
				s number=(+number)+1
				if (number=100){
					s dataProcess=-1
				}
				s value=kpiDataFlag_"^"_number
				s ^TEMPDHCWL("creatKpiDate","checkNumber")=value
			}else{
				s value=kpiDataFlag_"^"_0
				s ^TEMPDHCWL("creatKpiDate","checkNumber")=value
			}
		}
	}else{
		s value=kpiDataFlag_"^"_0
		s ^TEMPDHCWL("creatKpiDate","checkNumber")=value
	}
	if (dataProcess=-1){
		k ^TEMPDHCWL("creatKpiDate","checkNumber")
		k ^TEMPDHCWL("recordCurrentPlan","plan")
		k ^TEMPDHCWL("recordMonIDTotal","monthID")
		k ^TEMPDHCWL("recordMonIDCurrent","monthID")
		k ^TEMPDHCWL("KPI","CreatDate","progress","currentProgress")
		q -1
	}else{
		if (dataProcess>=1){
			s dataProcess=1
			k ^TEMPDHCWL("creatKpiDate","checkNumber")
		    k ^TEMPDHCWL("recordCurrentPlan","plan")
			k ^TEMPDHCWL("recordMonIDTotal","monthID")
			k ^TEMPDHCWL("recordMonIDCurrent","monthID")
			k ^TEMPDHCWL("KPI","CreatDate","progress","currentProgress")
		}
		q $FNUMBER(dataProcess,"+",3)*100
	}
}

/// Creator  : wk
/// CreaDate : 2018-04-01
/// Desc     : 获取需要导出的指标xml信息(无维度版)
/// Input    : 需要导出的指标ID
/// Output   : 指标信息
/// Other    : do ##Class
ClassMethod getFileContentExcDim(kpiIds)
{
	q:kpiIds="" ""
	s flag=1
	s kpiSysList=##class(DHCWL.MKPIIO.DefaultOutService).GetKpiSystemList(kpiIds,flag)
	d ##class(DHCWL.MKPIIO.DefaultOutService).OutputMKPIToStream(kpiSysList,.outStream,flag)
	Set sc =##class(%XML.TextReader).ParseStream(outStream,.reader)
	if (reader="") {
		w "导出错误!"
		q
	}
	d ##class(DHCWL.MKPIIO.DefaultOutService).TraverXmlToStr(reader)
	q ""
}

/// Creator  : wk
/// CreaDate : 2018-04-01
/// Desc     : 获取需要导出的指标xml信息(有维度版)
/// Input    : 需要导出的指标ID
/// Output   : 指标信息
/// Other    : do ##Class
ClassMethod getFileContentWithDim(kpiIds)
{
	q:kpiIds="" ""
	s kpiSysList=##class(DHCWL.MKPIIO.DefaultOutService).GetKpiSystemList(kpiIds)
	d ##class(DHCWL.MKPIIO.DefaultOutService).OutputMKPIToStream(kpiSysList,.outStream)
	Set sc =##class(%XML.TextReader).ParseStream(outStream,.reader)
	if (reader="") {
		w "导出错误!"
		q
	}
	d ##class(DHCWL.MKPIIO.DefaultOutService).TraverXmlToStr(reader)
	q ""
}

/// Creator    : wk
/// CreatData  : 2018-04-01
/// Desc       : 获取指标Excel导出的信息
/// Input      : 指标ID串
/// Output     : 选中指标信息
/// Other      : do ##Class(web.DHCWL.V1.KPI.KPIFunction).GetKPInforExcel
ClassMethod GetKPInforExcel(kpiIDs)
{
	q:kpiIDs="" ""
	s deli="&"
	s sql="select ID,MKPI_Code,MKPI_Name,MKPI_Desc,MKPI_EXCode,MKPI_GlobalFlag,MKPI_User,MKPI_UpdateDate,MKPI_Remark,MKPI_TypeDr,MKPI_Cate,MKPI_SectionFlag,MKPI_DataNod,MKPI_GetValueType from DHCWL_MKPI.DHCWLMKPI"
	s orderSql=" order by ID",condSql=""
	s selKpiIDs = kpiIDs
	if selKpiIDs'="" {
		if condSql="" s condSql=condSql_" where"
		e  s condSql=condSql_" and "
		s condSql=condSql_" ID in ("_selKpiIDs_")"
	}
	s sql=sql_" "_condSql_orderSql
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	s json=##class(DHCWL.util.Json).Json("id"_deli_"kpiCode"_deli_"kpiName"_deli_"kpiDesc"_deli_"kpiExcode"_deli_"MKPIGlobalFlag"_deli_"createUser"_deli_"updateDate"_deli_"nodeMark"_deli_"dimType"_deli_"category"_deli_"section"_deli_"dataNode"_deli_"getValueType"_deli_"dimCode","result","root",deli)
	s num=0
	//读入可选项结束
	While(rs.Next()){
		s rowKpiId=rs.Data("ID")
		s num=num+1
		s date=rs.Data("MKPI_UpdateDate"),cate=rs.Data("MKPI_Cate"),dim=rs.Data("MKPI_TypeDr"),sect=rs.Data("MKPI_SectionFlag")
		s cateId=cate,dimId=dim,sectId=sect
		if cate="" {
			s cate=""
		}elseif $g(^DHCWL.MKPI.MKPIFLD(cate))'="" {
			s cate=$list(^DHCWL.MKPI.MKPIFLD(cate),5)
		}else{
			s cate=""
		}
		i (1=1)||(dim="")||(dim=$c(0)) {
			s tempRes=""
			s tempDim="" 
			k kpiDimOrdered
			f {
				s tempDim=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",rowKpiId,tempDim))
				q:($g(tempDim)="")||(tempDim=$c(0))
				continue:(+tempDim<=0)
				s kpiDimId=""
				f {
					s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",rowKpiId,tempDim,kpiDimId))
					q:kpiDimId=""
					s dimOrder=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6)
					s:(dimOrder="")||(dimOrder=$c(0)) dimOrder=1
					s kpiDimOrdered(dimOrder)=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),4)   ;$list(^DHCWL.MKPI.MKPIDimTypeD(tempDim),5)
				}	
			}
			s dimOrder=""
			f {
				s dimOrder=$o(kpiDimOrdered(dimOrder))
				q:dimOrder=""
				i tempRes="" s tempRes=kpiDimOrdered(dimOrder)
				e  s tempRes=tempRes_","_kpiDimOrdered(dimOrder)
			}
			s dim=$g(tempRes)
		}elseif $d(^DHCWL.MKPI.MKPIDimTypeD(dim)) {
			s tempRes=""
			s tempDim="" 
			f {
				s tempDim=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",rowKpiId,tempDim))
				q:($g(tempDim)="")||(tempDim=$c(0))
				continue:(+tempDim<=0)||('$d(^DHCWL.MKPI.MKPIDimTypeD(tempDim)))
				i tempRes="" s tempRes=$list(^DHCWL.MKPI.MKPIDimTypeD(tempDim),5)
				e  s tempRes=tempRes_","_$list(^DHCWL.MKPI.MKPIDimTypeD(tempDim),5)
			}
			s:($g(tempRes)="") tempRes=$list(^DHCWL.MKPI.MKPIDimTypeD(dim),5)
			s dim=$g(tempRes)
		}
		i sect="" {
			s setc=""
		}elseif $g(^DHCWL.MKPI.SectionD(sect))'="" {
			s sect=$list(^DHCWL.MKPI.SectionD(sect),4)
		}else {
			s sect=""
		}
		//modify by wk~2017-03-03~公司时间控件标准化
		s:date'="" date=$zd(date,3)
		//插入一个json对象格式
		s getValueType=rs.Data("MKPI_GetValueType")
		if getValueType=1 {
			s getValueType="普通指标"
		}elseif getValueType=2 {
			s getValueType="计算指标"
		}
		s eKpiId=rs.Data("ID")
		s kpiDimInfors=""
		s kpiOrder=""
		for{
			s kpiOrder=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",eKpiId,kpiOrder))
			q:kpiOrder=""
			s eKpiDimId=""
			s eKpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",eKpiId,kpiOrder,eKpiDimId))
			s kpiDimDesc=$lg(^DHCWL.MKPI.MKPIDimensionsD(eKpiDimId),4,"")
			s kpiDimCode=$lg(^DHCWL.MKPI.MKPIDimensionsD(eKpiDimId),2,"")
			s kpiDimInfor=kpiDimDesc_"("_kpiDimCode_")"
			if (kpiDimInfors=""){
				s kpiDimInfors=kpiDimInfor
			}else{
				s kpiDimInfors=kpiDimInfors_","_kpiDimInfor
			}
		}
		s rs.Data("MKPI_Name")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_Name"),"'","\'")
		s rs.Data("MKPI_Desc")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_Desc"),"'","\'")
		s rs.Data("MKPI_EXCode")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_EXCode"),"'","\'")
		s rs.Data("MKPI_User")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_User"),"'","\'")
		s rs.Data("MKPI_Remark")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_Remark"),"'","\'")
		s rs.Data("MKPI_DataNod")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_DataNod"),"'","\'")
		s dim=##class(DHCWL.util.StringUtil).ReplaceStr(dim,"'","\'")
		d json.Insert(rs.Data("ID")_""_deli_"'"_rs.Data("MKPI_Code")_"'"_deli_"'"_rs.Data("MKPI_Name")_"'"_deli_"'"_rs.Data("MKPI_Desc")_"'"_deli_"'"_rs.Data("MKPI_EXCode")_"'"_deli_"'"_rs.Data("MKPI_GlobalFlag")_"'"_deli_"'"_rs.Data("MKPI_User")_"'"_deli_"'"_date_"'"_deli_"'"_rs.Data("MKPI_Remark")_"'"_deli_"'"_dim_"'"_deli_"'"_cate_"'"_deli_"'"_sect_"'"_deli_"'"_rs.Data("MKPI_DataNod")_"'"_deli_"'"_getValueType_"'"_deli_"'"_kpiDimInfors_"'")
		
	}
	d rs.Close()
	d json.SetTotalNum(num)
	w "["
	d {
		s obj=json.GetNextJsonArray()
		i obj'="" w obj,","
	}while(obj'="")
	w "]"
	q ""
}

/// Creator    : wk
/// CreatDate  : 2020-04-03
/// Desc       : 获取指标信息
/// Input    　：指标ID
/// Output     : 指标信息
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.KPIFunction","GetKpiInforQuery","K0646")
Query GetKpiInforQuery(kpiIDs As %String = "") As websys.Query(ROWSPEC = "MKPIId:%String:ID,MKPICode:%String:编码,MKPIName:%String:名称,MKPIDesc:%String:描述,MKPIEXCode:%String:执行代码,MKPIGlobalFlag:%String:是否使用global,MKPIUser:%String:创建者,MKPIUpdateDate:%String:更新日期,MKPIRemark:%String:备注,MKPIDim:%String:维度,MKPICate:%String:类型,MKPISectionFlag:%String:区间,MKPIDataNod:%String:数据节点,MKPIGetValueType:%String:取值方式,MKPIKpiDim:%String:关联维度") [ SqlProc ]
{
}

ClassMethod GetKpiInforQueryExecute(ByRef qHandle As %Binary, kpiIDs As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	q:kpiIDs="" $$$OK
	s deli="&"
	s sql="select ID,MKPI_Code,MKPI_Name,MKPI_Desc,MKPI_EXCode,MKPI_GlobalFlag,MKPI_User,MKPI_UpdateDate,MKPI_Remark,MKPI_TypeDr,MKPI_Cate,MKPI_SectionFlag,MKPI_DataNod,MKPI_GetValueType from DHCWL_MKPI.DHCWLMKPI"
	s orderSql=" order by ID",condSql=""
	s selKpiIDs = kpiIDs
	if selKpiIDs'="" {
		if condSql="" s condSql=condSql_" where"
		e  s condSql=condSql_" and "
		s condSql=condSql_" ID in ("_selKpiIDs_")"
	}
	s sql=sql_" "_condSql_orderSql
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	s json=##class(DHCWL.util.Json).Json("id"_deli_"kpiCode"_deli_"kpiName"_deli_"kpiDesc"_deli_"kpiExcode"_deli_"MKPIGlobalFlag"_deli_"createUser"_deli_"updateDate"_deli_"nodeMark"_deli_"dimType"_deli_"category"_deli_"section"_deli_"dataNode"_deli_"getValueType"_deli_"dimCode","result","root",deli)
	s num=0
	//读入可选项结束
	While(rs.Next()){
		s rowKpiId=rs.Data("ID")
		s num=num+1
		s date=rs.Data("MKPI_UpdateDate"),cate=rs.Data("MKPI_Cate"),dim=rs.Data("MKPI_TypeDr"),sect=rs.Data("MKPI_SectionFlag")
		s cateId=cate,dimId=dim,sectId=sect
		if cate="" {
			s cate=""
		}elseif $g(^DHCWL.MKPI.MKPIFLD(cate))'="" {
			s cate=$list(^DHCWL.MKPI.MKPIFLD(cate),5)
		}else{
			s cate=""
		}
		i (1=1)||(dim="")||(dim=$c(0)) {
			s tempRes=""
			s tempDim="" 
			k kpiDimOrdered
			f {
				s tempDim=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",rowKpiId,tempDim))
				q:($g(tempDim)="")||(tempDim=$c(0))
				continue:(+tempDim<=0)
				s kpiDimId=""
				f {
					s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",rowKpiId,tempDim,kpiDimId))
					q:kpiDimId=""
					s dimOrder=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6)
					s:(dimOrder="")||(dimOrder=$c(0)) dimOrder=1
					s kpiDimOrdered(dimOrder)=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),4)   ;$list(^DHCWL.MKPI.MKPIDimTypeD(tempDim),5)
				}	
			}
			s dimOrder=""
			f {
				s dimOrder=$o(kpiDimOrdered(dimOrder))
				q:dimOrder=""
				i tempRes="" s tempRes=kpiDimOrdered(dimOrder)
				e  s tempRes=tempRes_","_kpiDimOrdered(dimOrder)
			}
			s dim=$g(tempRes)
		}elseif $d(^DHCWL.MKPI.MKPIDimTypeD(dim)) {
			s tempRes=""
			s tempDim="" 
			f {
				s tempDim=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",rowKpiId,tempDim))
				q:($g(tempDim)="")||(tempDim=$c(0))
				continue:(+tempDim<=0)||('$d(^DHCWL.MKPI.MKPIDimTypeD(tempDim)))
				i tempRes="" s tempRes=$list(^DHCWL.MKPI.MKPIDimTypeD(tempDim),5)
				e  s tempRes=tempRes_","_$list(^DHCWL.MKPI.MKPIDimTypeD(tempDim),5)
			}
			s:($g(tempRes)="") tempRes=$list(^DHCWL.MKPI.MKPIDimTypeD(dim),5)
			s dim=$g(tempRes)
		}
		i sect="" {
			s setc=""
		}elseif $g(^DHCWL.MKPI.SectionD(sect))'="" {
			s sect=$list(^DHCWL.MKPI.SectionD(sect),4)
		}else {
			s sect=""
		}
		//modify by wk~2017-03-03~公司时间控件标准化
		s:date'="" date=$zd(date,3)
		//插入一个json对象格式
		s getValueType=rs.Data("MKPI_GetValueType")
		if getValueType=1 {
			s getValueType="普通指标"
		}elseif getValueType=2 {
			s getValueType="计算指标"
		}
		s eKpiId=rs.Data("ID")
		s kpiDimInfors=""
		s kpiOrder=""
		for{
			s kpiOrder=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",eKpiId,kpiOrder))
			q:kpiOrder=""
			s eKpiDimId=""
			s eKpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",eKpiId,kpiOrder,eKpiDimId))
			s kpiDimDr=$lg(^DHCWL.MKPI.MKPIDimensionsD(eKpiDimId),5,"")
			s dimDesc=$lg(^DHCWL.MKPI.MKPIDimTypeD(kpiDimDr),3,"")
			s dimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(kpiDimDr),2,"")
			s kpiDimInfor=dimDesc_"("_dimCode_")"
			if (kpiDimInfors=""){
				s kpiDimInfors=kpiDimInfor
			}else{
				s kpiDimInfors=kpiDimInfors_","_kpiDimInfor
			}
		}
		s rs.Data("MKPI_Name")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_Name"),"'","\'")
		s rs.Data("MKPI_Desc")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_Desc"),"'","\'")
		s rs.Data("MKPI_EXCode")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_EXCode"),"'","\'")
		s rs.Data("MKPI_User")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_User"),"'","\'")
		s rs.Data("MKPI_Remark")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_Remark"),"'","\'")
		s rs.Data("MKPI_DataNod")=##class(DHCWL.util.StringUtil).ReplaceStr(rs.Data("MKPI_DataNod"),"'","\'")
		s dim=##class(DHCWL.util.StringUtil).ReplaceStr(dim,"'","\'")
		//d json.Insert(rs.Data("ID")_""_deli_"'"_rs.Data("MKPI_Code")_"'"_deli_"'"_rs.Data("MKPI_Name")_"'"_deli_"'"_rs.Data("MKPI_Desc")_"'"_deli_"'"_rs.Data("MKPI_EXCode")_"'"_deli_"'"_rs.Data("MKPI_GlobalFlag")_"'"_deli_"'"_rs.Data("MKPI_User")_"'"_deli_"'"_date_"'"_deli_"'"_rs.Data("MKPI_Remark")_"'"_deli_"'"_dim_"'"_deli_"'"_cate_"'"_deli_"'"_sect_"'"_deli_"'"_rs.Data("MKPI_DataNod")_"'"_deli_"'"_getValueType_"'"_deli_"'"_kpiDimInfors_"'")
		s ^CacheTemp(repid,ind)=$lb(rs.Data("ID"),rs.Data("MKPI_Code"),rs.Data("MKPI_Name"),rs.Data("MKPI_Desc"),rs.Data("MKPI_EXCode"),rs.Data("MKPI_GlobalFlag"),rs.Data("MKPI_User"),date,rs.Data("MKPI_Remark"),dim,cate,sect,rs.Data("MKPI_DataNod"),getValueType,kpiDimInfors)
		s ind=ind+1
	}
	d rs.Close()
	q $$$OK
	
	
	
	
	
	
	
	
	
	
	
	q:dimID="" $$$OK
 	s sql="select ID,DimPro_Code,DimPro_Name,DimPro_Desc,DimPro_ExcCode,DimPro_DefaultFlag,DimPro_ValueDeli,DimPro_ProNormal from DHCWL_MKPI.DHCWLDimProperty where DimPro_DimDr = "_dimID_" order by DimPro_ProNormal desc"
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
		s proNormal=rs.Data("DimPro_ProNormal")
		s ^CacheTemp(repid,ind)=$lb(ID,code,name,desc,exeCode,defFlag,valueDeli,proNormal)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-04-19
/// Desc       : 指标预览数据
/// Input    　：取数规则和过滤规则
/// Output     : 预览成功的数据
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.KPIFunction","GetKPIDataQuery")
Query GetKPIDataQuery(kpiRule As %String, startDate As %String = "", endDate As %String = "", mode As %String = "", contract As %String = "", filter As %String = "") As websys.Query(ROWSPEC = "monDesc:%String:日期,kpiCode:%String:指标编码,kpiDesc:%String:指标描述,dimId:%String:维度原始值,dimDesc:%String:维度描述,value:%String:值") [ SqlProc ]
{
}

ClassMethod GetKPIDataQueryExecute(ByRef qHandle As %Binary, kpiRule As %String, startDate As %String = "", endDate As %String = "", mode As %String = "", contract As %String = "", filter As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	q:kpiRule="" $$$OK
 	k ^temp($j)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s kpi=kpiRule
 	s startDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(startDate)
 	s endDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(endDate)
 	s startDate=$zd(startDate,3)
 	s endDate=$zd(endDate,3)
 	s choiceType=""
 	s isRealData=mode
 	s contractType=contract
 	s filterRule=filter
	s realRs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:NewQueryKpiWithContract",kpi,startDate,endDate,choiceType,isRealData,contractType,filterRule)
	While realRs.Next(.sc) {
		s ^temp($j,realRs.Data("monthId"))=realRs.Data("monDesc")
		s ^temp($j,realRs.Data("monthId"),realRs.Data("kpiId"))=realRs.Data("kpiCode")_"||"_realRs.Data("kpiDesc")
		s ^temp($j,realRs.Data("monthId"),realRs.Data("kpiId"),realRs.Data("dimId"))=realRs.Data("dimDesc")
		s ^temp($j,realRs.Data("monthId"),realRs.Data("kpiId"),realRs.Data("dimId"),"REAL")=realRs.Data("value")
	}
	s monId="" f  s monId=$o(^temp($j,monId)) q:monId=""  d
	.s kpiId="" f  s kpiId=$o(^temp($j,monId,kpiId)) q:kpiId=""  d
	..s dim="" f  s dim=$o(^temp($j,monId,kpiId,dim)) q:dim=""  d
	...s value=0
	...i $d(^temp($j,monId,kpiId,dim,"REAL")) s value=^temp($j,monId,kpiId,dim,"REAL")
	...s dataList=$lb(^temp($j,monId),$p(^temp($j,monId,kpiId),"||",1),$p(^temp($j,monId,kpiId),"||",2),dim,^temp($j,monId,kpiId,dim),value)
	...s ^CacheTemp(repid,ind)=dataList
 	...s ind=ind+1
	Quit $$$OK
 	
 	
 	
	s ^CacheTemp(repid,ind)=$lb(ID,code,name)
	s ind=ind+1
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-04-19
/// Desc       : 指标预览数据(实时历史对比)
/// Input    　：取数规则和过滤规则
/// Output     : 预览成功的数据
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.KPIFunction","GetHisAndRealKPIDataQuery")
Query GetHisAndRealKPIDataQuery(kpiRule As %String, startDate As %String = "", endDate As %String = "", mode As %String = "", contract As %String = "", filter As %String = "") As websys.Query(ROWSPEC = "monDesc:%String:日期,kpiCode:%String:指标编码,kpiDesc:%String:指标描述,dimId:%String:维度原始值,dimDesc:%String:维度描述,value:%String:值,realValue:%String:实时数据") [ SqlProc ]
{
}

ClassMethod GetHisAndRealKPIDataQueryExecute(ByRef qHandle As %Binary, kpiRule As %String, startDate As %String = "", endDate As %String = "", mode As %String = "", contract As %String = "", filter As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	q:kpiRule="" $$$OK
 	k ^temp($j)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s kpi=kpiRule
 	s startDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(startDate)
 	s endDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(endDate)
 	s startDate=$zd(startDate,3)
 	s endDate=$zd(endDate,3)
 	s choiceType=""
 	s isRealData=mode
 	s contractType=contract
 	s filterRule=filter
	s realRs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:NewQueryKpiWithContract",kpi,startDate,endDate,choiceType,isRealData_"R",contractType,filterRule)
	s hisRs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:NewQueryKpiWithContract",kpi,startDate,endDate,choiceType,isRealData,contractType,filterRule)
	While realRs.Next(.sc) {
		s ^temp($j,realRs.Data("monthId"))=realRs.Data("monDesc")
		s ^temp($j,realRs.Data("monthId"),realRs.Data("kpiId"))=realRs.Data("kpiCode")_"||"_realRs.Data("kpiDesc")
		s ^temp($j,realRs.Data("monthId"),realRs.Data("kpiId"),realRs.Data("dimId"))=realRs.Data("dimDesc")
		s ^temp($j,realRs.Data("monthId"),realRs.Data("kpiId"),realRs.Data("dimId"),"REAL")=realRs.Data("value")
	}
	While hisRs.Next(.sc) {
		s ^temp($j,hisRs.Data("monthId"))=hisRs.Data("monDesc")
		s ^temp($j,hisRs.Data("monthId"),hisRs.Data("kpiId"))=hisRs.Data("kpiCode")_"||"_hisRs.Data("kpiDesc")
		s ^temp($j,hisRs.Data("monthId"),hisRs.Data("kpiId"),hisRs.Data("dimId"))=hisRs.Data("dimDesc")
		s ^temp($j,hisRs.Data("monthId"),hisRs.Data("kpiId"),hisRs.Data("dimId"),"HIS")=hisRs.Data("value")
	}
	s monId="" f  s monId=$o(^temp($j,monId)) q:monId=""  d
	.s kpiId="" f  s kpiId=$o(^temp($j,monId,kpiId)) q:kpiId=""  d
	..s dim="" f  s dim=$o(^temp($j,monId,kpiId,dim)) q:dim=""  d
	...s rv=0,hv=0
	...i $d(^temp($j,monId,kpiId,dim,"REAL")) s rv=^temp($j,monId,kpiId,dim,"REAL")
	...i $d(^temp($j,monId,kpiId,dim,"HIS")) s hv=^temp($j,monId,kpiId,dim,"HIS")
	...s dataList=$lb(^temp($j,monId),$p(^temp($j,monId,kpiId),"||",1),$p(^temp($j,monId,kpiId),"||",2),dim,^temp($j,monId,kpiId,dim),hv,rv)
	...s ^CacheTemp(repid,ind)=dataList
 	...s ind=ind+1
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-04-19
/// Desc       : 根据取数规则获取取数规则树
/// Input    　：取数规则
/// Output     : 取数规则树
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.KPIFunction","GetKPIRuleTreeQuery","")
Query GetKPIRuleTreeQuery(inputRule As %String = "", treeDeep As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,name:%String:描述,code:%String:编码,state:%String:是否展开,checked:%String:是否选中,_parentId:%String:父节点,type:%String:类型") [ SqlProc ]
{
}

ClassMethod GetKPIRuleTreeQueryExecute(ByRef qHandle As %Binary, inputRule As %String = "", treeDeep As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	q:inputRule="" $$$OK
 	k ^TEMPDHCWL($j)
  	do ##class(web.DHCWL.V1.KPI.KPIFunction).GetKPIRuleGlobal(inputRule)
  	   	
   	s i=1
   	s NOBase=1
   	s loopCnt=$l(inputRule,",")
   	f i=1:1:loopCnt{
   		
   		s aKpiRule=$p(inputRule,",",i)
		s iKpiCode=$p(aKpiRule,":",1)
		
		s jsonData=""
		s jsonDatas=""

		s kpiID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(iKpiCode,"DHCWL.MKPI.MKPI")
		s kpiText=$lg(^DHCWL.MKPI.MKPID(kpiID),5)
		s kpiSecFlag=$lg(^DHCWL.MKPI.MKPID(kpiID),11)
		s kpiIDForParent = "KPI"_kpiID
		s ^CacheTemp(repid,ind)=$lb(kpiIDForParent,kpiText,iKpiCode,"closed",,,"KPI")
		s ind=ind+1
	
		//维度
		s MKPIDimOrder=""
		f {
			s MKPIDimOrder=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpiID,MKPIDimOrder))
			q:$g(MKPIDimOrder)=""
			//f {
				s kpiDimID=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpiID,MKPIDimOrder,""))
				q:kpiDimID=""

				s kpiDimData=$g(^DHCWL.MKPI.MKPIDimensionsD(kpiDimID))
				q:kpiDimData=""
				s MKPIDimCode=$lg(kpiDimData,2)
				s MKPIDimDes=$lg(kpiDimData,4)
				s MKPIDimDimDr=$lg(kpiDimData,5)
				continue:MKPIDimDimDr=""
					
				s MKPIDimDes=##class(DHCWL.util.StringUtil).Trim(MKPIDimDes)
				if ((MKPIDimDes="") || (MKPIDimDes=$c(0))) s MKPIDimDes="!!!未设置指标维度描述信息"
				s checked=""
				i $d(^TEMPDHCWL($j,"inputRule","normalDim",iKpiCode,MKPIDimCode)) s checked="true"
				s kpiDimIDForParent="kpiDim"_kpiDimID
				
				s isOpen="closed"
				if (treeDeep="kpiDim"){
					s isOpen="open"
				}
				s ^CacheTemp(repid,ind)=$lb(kpiDimIDForParent,MKPIDimDes,MKPIDimCode,isOpen,checked,kpiIDForParent,"KPIDIM")
				s ind=ind+1
		
				//维度属性
				continue:((treeDeep'="")&&(treeDeep'="dimpro"))
				s dimProCode=""
				f {
					s dimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",MKPIDimDimDr,dimProCode))
					q:$g(dimProCode)=""
					s dimProID=""
					f {
						s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",MKPIDimDimDr,dimProCode,dimProID))
						q:$g(dimProID)=""
						s proCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),3)
						s proDesc=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),5)
					
						s checked=""
						i $d(^TEMPDHCWL($j,"inputRule","normalDim",iKpiCode,MKPIDimCode,proCode)) s checked="true"
						s dimProIDForParent="dimPro"_kpiDimID_dimProID
						s ^CacheTemp(repid,ind)=$lb(dimProIDForParent,proDesc,proCode,"open",checked,kpiDimIDForParent,"DIMPRO")
						s ind=ind+1
						
					} 
				}
		}
		
		//区间维度
		s secData=$g(^DHCWL.MKPI.SectionD(kpiSecFlag))
		i $g(secData)="" {
			s i=i+1
			continue
		}
		s secCode=$lg(secData,2)
		s secDesc=$lg(secData,3)
		
		s checked=""
		i $d(^TEMPDHCWL($j,"inputRule","secDim",iKpiCode,"$"_secCode)) s checked="true"
		
		s secIDForParent="sec"_kpiID_kpiSecFlag
		s isOpen="closed"
		if (treeDeep="kpiDim"){
			s isOpen="open"
		}
		s ^CacheTemp(repid,ind)=$lb(secIDForParent,secDesc,secCode,isOpen,checked,kpiIDForParent,"SECDIM")
		s ind=ind+1
	
		//维度属性
		continue:((treeDeep'="")&&(treeDeep'="dimpro"))
		s secProCode=""
		f {
			s secProCode=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",kpiSecFlag,secProCode))
			q:$g(secProCode)=""
			s secProID=""
			f {
				s secProID=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",kpiSecFlag,secProCode,secProID))
				q:$g(secProID)=""
				s proCode=$lg(^DHCWL.MKPI.SectionPropertyD(secProID),2)
				s proDesc=$lg(^DHCWL.MKPI.SectionPropertyD(secProID),4)
				
				s checked=""
				i $d(^TEMPDHCWL($j,"inputRule","secDim",iKpiCode,"$"_secCode,proCode)) s checked="true"
				s secProIDForParent="secPro"_secIDForParent_secProID
				s ^CacheTemp(repid,ind)=$lb(secProIDForParent,proDesc,proCode,"open",checked,secIDForParent,"SECDIMPRO")
				s ind=ind+1
			} 
		}
   	}
   	k ^TEMPDHCWL($j)
	Quit $$$OK
}

/// Creator    : wk
/// CreatData  : 2018-04-19
/// Desc       : 将取数规则分类放到global中
/// Input      : 取数规则
/// Output     : 过滤规则
/// Other      : do ##(web.DHCWL.V1.KPI.KPIFunction).GetKPIRuleGlobal()
ClassMethod GetKPIRuleGlobal(inputRule As %String)
{
	s kpiLen=$l(inputRule,",")
	k ^TEMPDHCWL($j)
	f i=1:1:kpiLen d
	.s aKpiRule=$p(inputRule,",",i)
	.s kpiCode=$p(aKpiRule,":",1)
	.s ^TEMPDHCWL($j,"inputRule","normalDim",kpiCode)=1
	.s dimAndProRules=$p(aKpiRule,":",2)
	.q:$g(dimAndProRules)=""
	.s dAndPCnt=$l(dimAndProRules,"^")
	.f j=1:1:dAndPCnt d
	..s aDimAndPro=$p(dimAndProRules,"^",j)
	..s dimCode=$p(aDimAndPro,".",1)
	..i ($g(dimCode)'="") d
	...i ($f(dimCode,"$")'=2) d 	//常规维度及属性 
	....s ^TEMPDHCWL($j,"inputRule","normalDim",kpiCode,dimCode)=1
	....s proCode=$p(aDimAndPro,".",2)
   	....i $g(proCode)'="" s ^TEMPDHCWL($j,"inputRule","normalDim",kpiCode,dimCode,proCode)=1	
   	...e  d							//区间维度及属性
	....s ^TEMPDHCWL($j,"inputRule","secDim",kpiCode,dimCode)=1
	....s proCode=$p(aDimAndPro,".",2)
   	....i $g(proCode)'="" s ^TEMPDHCWL($j,"inputRule","secDim",kpiCode,dimCode,proCode)=1
}

/// Creator    : wk
/// CreatDate  : 2018-04-23
/// Desc       : 指标过滤函数
/// Input    　：
/// Output     : 指标过滤函数
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.KPIFunction","GetFilterFunQuery")
Query GetFilterFunQuery() As websys.Query(ROWSPEC = "ID:%String:ID,FilterFuncCode:%String:函数代码,FilterFuncPrototype:%String:函数原型,Desc:%String:描述") [ SqlProc ]
{
}

ClassMethod GetFilterFunQueryExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	k filterFunc
	s filterFuncId=""
	s num=1
	do{
		s filterFuncId=$o(^DHCWL.MKPI.SysFilterFuncD(filterFuncId))
		q:(""=filterFuncId)
		s obj=##class(DHCWL.MKPI.SysFilterFunc).%OpenId(filterFuncId)
		continue:(""=obj)
		continue:(""'=$g(prototype))&&($g(prototype)'=obj.FilterFuncPrototype)
		continue:(""'=$g(execCode))&&($g(execCode)'=obj.FilterFuncExecCode)
		continue:(""'=$g(funcDesc))&&($g(funcDesc)'=obj.FilterFuncFuncDesc)
		s obj.FilterFuncCode=$tr(obj.FilterFuncCode,"‘","'")
		s obj.FilterFuncExecCode=$tr(obj.FilterFuncExecCode,"^","∧")
		s num=num+1
		s ^CacheTemp(repid,ind)=$lb(filterFuncId,obj.FilterFuncCode,obj.FilterFuncPrototype,obj.FilterFuncFuncDesc)
		s ind=ind+1
	}while(""'=filterFuncId)
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-11-26
/// Desc      : 获取指标度量
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.KPIFunction","GetKPIMeaQuery")
Query GetKPIMeaQuery(kpiIDs As %String) As websys.Query(ROWSPEC = "MKPIMeasureCode:%String:编码,MKPIMeasureDes:%String:描述,MKPIDataSource:%String:数据源,MKPIstaCal:%String:统计口径,MKPICalItem:%String:计算数据项") [ SqlProc ]
{
}

ClassMethod GetKPIMeaQueryExecute(ByRef qHandle As %Binary, kpiIDs As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s sql="SELECT A.Mea_Code,A.Mea_Desc,A.Mea_DataSource,A.Measure_CalItem,A.Mea_StaCal,A.Mea_DsDesc,A.Mea_StaDesc,A.Mea_CalDesc FROM DHCWL_MeasureDimrole.DHCWLMeasure A,DHCWL_MKPI.DHCWLMKPIMeasure B WHERE A.ID=B.MKPI_MeaDr AND B.MKPI_KpiDr IN ("_kpiIDs_")"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s dsDesc=rs.Data("Mea_DsDesc")
		s calDesc=rs.Data("Mea_CalDesc")
		s staDesc=rs.Data("Mea_StaDesc")
		if (dsDesc=""){
			s dsInfor=rs.Data("Mea_DataSource")
		}else{
			s dsInfor=rs.Data("Mea_DataSource")_":"_dsDesc
		}
		
		if (calDesc=""){
			s calInfor=rs.Data("Measure_CalItem")
		}else{
			s calInfor=rs.Data("Measure_CalItem")_":"_calDesc
		}
		
		if (staDesc=""){
			s staInfor=rs.Data("Mea_StaCal")
		}else{
			s staInfor=rs.Data("Mea_StaCal")_":"_staDesc
		}
		s ^CacheTemp(repid,ind)=$lb(rs.Data("Mea_Code"),rs.Data("Mea_Desc"),dsInfor,calInfor,staInfor)
		s ind=ind+1
	}
	Quit $$$OK
}

}

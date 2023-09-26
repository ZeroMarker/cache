/// creator  	:wk
/// creatDate	:2017-04-05
/// Description	:该类用于维度角色和度量的数据处理
Class DHCWL.MeasureDimroleData.FunctionModule Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     获取维度数据，可以根据搜索条件获取相关维度数据
/// Table:           DHCWL_MKPI.DHCWLMKPIDimType
/// Input: 			searcheValue:搜索条件，可为空
/// Output:			维度的相关字段数据
/// Return:
/// Others:			d ##class(%ResultSet).RunQuery("DHCWL.MeasureDimroleData.FunctionModule","GetDimInforQuery","科室")
Query GetDimInforQuery(searcheValue As %Text) As %Query(ROWSPEC = "dimID:%String,dimCode:%String,dimDesc:%String,dimName:%String,dimRemark:%String,dimCreator:%String") [ SqlProc ]
{
}

ClassMethod GetDimInforQueryExecute(ByRef qHandle As %Binary, searcheValue As %Text) As %Status
{
	n (qHandle,searcheValue)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	d ##class(DHCWL.MeasureDimroleData.FunctionModule).getOldDimList(.list)
 	s dimID=""
 	for{
	 	s dimID=$o(^DHCWL.MKPI.MKPIDimTypeD(dimID))
	 	q:dimID=""
	 	s dimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),2)
	 	continue:$d(list($zcvt(dimCode,"U")))
	 	s dimDesc=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),3)
	 	s dimName=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),5)
	 	s dimRemark=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),6)
	 	s dimCreator=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimID),8)
	 	s searcheValue=$zcvt(searcheValue,"U")
	 	continue:(searcheValue'="")&&($zcvt(dimID,"U")'[searcheValue)&&($zcvt(dimCode,"U")'[searcheValue)&&($zcvt(dimDesc,"U")'[searcheValue)&&($zcvt(dimName,"U")'[searcheValue)&&($zcvt(dimRemark,"U")'[searcheValue)&&($zcvt(dimCreator,"U")'[searcheValue)
	 	s ^CacheTemp(repid,ind)=$lb(dimID,dimCode,dimDesc,dimName,dimRemark,dimCreator)
		s ind=ind+1
 	}
	
	Quit $$$OK
}

ClassMethod GetDimInforQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDimInforQueryExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetDimInforQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDimInforQueryExecute ]
{
	n (qHandle,AtEnd,Row)
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

/// Creator:        wk
/// CreatDate:      2017-04-27
/// Description:    获取老版本维度
/// Input:
/// Others:         d ##class(DHCWL.MeasureDimroleData.FunctionModule).getOldDimList(.list)        
ClassMethod getOldDimList(ByRef data)
{
	n (data)
	k data
	s data("ADMREASON")=""
	s data("ADMREA")=""
	s data("ARCIMID")=""
	s data("DOC")=""
	s data("LOC")=""
	s data("SESSTYPE")=""
	s data("TARICDESC")=""
	//s data("TAREC")=""
	s data("USER")=""
	q
}

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     增加维度角色         
/// Input: 	         维度角色编码、创建者、名称、描述、维度ID		
/// Output:	         增加状态
/// Others:			d ##class(DHCWL.MeasureDimroleData.FunctionModule).AddDimRole("lhcs0617")
ClassMethod AddDimRole(code, creator, name, desc, dimID)
{
	n (code,creator,desc,name,dimID)
	s date=$p($h,",",1)
	s result="error"
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
		s result="ok"
	}
	q result
}

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     根据维度ID获取维度角色
/// Table:           DHCWL_MKPI.DHCWLMKPIDimType，DHCWL_MeasureDimrole.DHCWLDimRole
/// Input: 			 dimID维度ID
/// Output:			 维度角色字段的相关信息
/// Return:
/// Others:			d ##class(%ResultSet).RunQuery("DHCWL.MeasureDimroleData.FunctionModule","GetDimInforQuery","")
Query GetDimRoleInforQuery(dimID As %Text) As %Query(ROWSPEC = "ID:%String,DimRoleCode:%String,DimRoleDesc:%String,DimRoleName:%String,DimRoleDate:%String,DimRoleCreator:%String") [ SqlProc ]
{
}

ClassMethod GetDimRoleInforQueryExecute(ByRef qHandle As %Binary, dimID As %Text) As %Status
{
	n (qHandle,dimID)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
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
	 	s ^CacheTemp(repid,ind)=$lb(dimRoleID,code,desc,name,creatDate,creatUse)
		s ind=ind+1
 	}
	
	Quit $$$OK
}

ClassMethod GetDimRoleInforQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDimRoleInforQueryExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetDimRoleInforQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDimRoleInforQueryExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     作废维度角色
/// Table:           
/// Input: 			维度角色ID			
/// Return:			返回执行作废操作状态
/// Others:			d ##class(DHCWL.MeasureDimroleData.FunctionModule).DeleteDimRole("")
ClassMethod DeleteDimRole(dimID)
{
	n (dimID)
	s date=$p($h,",",1)
	s result="error"
	q:'$d(^DHCWL.MeasureDimrole.DimRoleD(dimID)) "未找到相关维度角色"
	&sql(update DHCWL_MeasureDimrole.DHCWLDimRole set Dimrole_VoidFlag="1" where ID=:dimID)
	i SQLCODE=0{
		s result="ok"
	}
	q result
}

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     修改维度角色
/// Table:           
/// Input: 			维度角色ID			
/// Return:			返回执行作废操作状态
/// Others:			d ##class(DHCWL.MeasureDimroleData.FunctionModule).ModifyDimRole("")
ClassMethod ModifyDimRole(dimID, name, desc, date)
{
	n (dimID,desc,name,date)
	s date=$p($h,",",1)
	s result="error"
	q:'$d(^DHCWL.MeasureDimrole.DimRoleD(dimID)) "未找到相关维度角色"
	&sql(update DHCWL_MeasureDimrole.DHCWLDimRole set Dimrole_Name=:name,Dimrole_Desc=:desc,Dimrole_CreateDate=:date where ID=:dimID)
	i SQLCODE=0{
		s result="ok"
	}
	q result
}

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     根据维度角色编码获取维度ID和编码，ID:编码
/// Table:           
/// Input: 			维度角色ID或者编码			
/// Return:			所属维度的ID和编码
/// Others:			d ##class(DHCWL.MeasureDimroleData.FunctionModule).GetDimByDimRole("")
ClassMethod GetDimByDimRole(dimRoleID)
{
	n (dimRoleID)
	q:dimRoleID="" "NULL"
	if ('$d(^DHCWL.MeasureDimrole.DimRoleD(dimRoleID))){
		s dimRoleID=$o(^DHCWL.MeasureDimrole.DimRoleI("Code"," "_$zcvt(dimRoleID,"U"),""))
	}
	q:dimRoleID="" "NULL"
	s dimID=$lg(^DHCWL.MeasureDimrole.DimRoleD(dimRoleID),5)
	s dimCode=$lg($g(^DHCWL.MKPI.MKPIDimTypeD(dimID)),2)
	s dimDesc=$lg($g(^DHCWL.MKPI.MKPIDimTypeD(dimID)),3)
	s result=dimID_":"_dimCode_":"_dimDesc
	q result
}

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     返回数据源数据
/// Table:           
/// Input: 					
/// Return:			返回执行作废操作状态
/// Others:			d ##class(DHCWL.MeasureDimroleData.FunctionModule).GetDataSource(.list)
ClassMethod GetDataSource(ByRef dataSourceList)
{
	n (dataSourceList)
	k dataSourceList
	s dsID=""
	for{
		s dsID=$O(^DHCWL.MeasureDimrole.DSourceD(dsID))
		q:dsID=""
		s packName=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),2)
		s tableName=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),3)
		s desc=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),4)
		s voidFlag=$lg(^DHCWL.MeasureDimrole.DSourceD(dsID),5)
		continue:voidFlag=1
		s dataSourceList(dsID)=packName_"."_tableName_":"_desc
	}
	//s dataSourceList("1")="workLoad:医嘱项表"
	//s dataSourceList("2")="DHCWorkRegReport:挂号表"
	//s dataSourceList("3")="ARCBillGrp:收入表"
}

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     返回计算项的信息
/// Table:           
/// Input: 			 数据源ID	
/// Return:			
/// Others:			d ##class(DHCWL.MeasureDimroleData.FunctionModule).GetCalItem(.list)
ClassMethod GetCalItem(dataSourceID, ByRef dataSourceList)
{
	n (dataSourceID,dataSourceList)
	k dataSourceList
	s dsItemID=""
	for{
		s dsItemID=$o(^DHCWL.MeasureDimrole.DSItemI("ItemType",dataSourceID," 度量",dsItemID))
		q:dsItemID=""
		s name=$lg(^DHCWL.MeasureDimrole.DSItemD(dsItemID),2)
		s desc=$lg(^DHCWL.MeasureDimrole.DSItemD(dsItemID),3)
		s voidFlag=$lg(^DHCWL.MeasureDimrole.DSItemD(dsItemID),8)
		continue:voidFlag=1
		s dataSourceList(dsItemID)=name_":"_desc
	}
}

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     返回统计口径的信息
/// Table:           
/// Input: 			 数据源ID	
/// Return:			
/// Others:			d ##class(DHCWL.MeasureDimroleData.FunctionModule).GetMeastaCal(.list)
ClassMethod GetMeastaCal(dataSourceID, ByRef dataSourceList)
{
	n (dataSourceID,dataSourceList)
	k dataSourceList
	s dsItemID=""
	for{
		s dsItemID=$o(^DHCWL.MeasureDimrole.DSItemI("ItemType",dataSourceID," 口径",dsItemID))
		q:dsItemID=""
		s name=$lg(^DHCWL.MeasureDimrole.DSItemD(dsItemID),2)
		s desc=$lg(^DHCWL.MeasureDimrole.DSItemD(dsItemID),3)
		s voidFlag=$lg(^DHCWL.MeasureDimrole.DSItemD(dsItemID),8)
		continue:voidFlag=1
		s dataSourceList(dsItemID)=name_":"_desc
	}
}

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     增加度量信息
/// Table:           
/// Input: 			 度量code、描述、创建者、数据源、口径、度量
/// Output:			
/// Return:
/// Others:			d ##class(DHCWL.MeasureDimroleData.FunctionModule).AddMeasure("")
ClassMethod AddMeasure(code, dataSource, calItem, meastaCal, desc, creator)
{
	n (code,dataSource,calItem,meastaCal,desc,creator)
	s date=$p($h,",",1)
	s result="error"
	//保证编码唯一
	s measureID="",error=""
	for{
		s measureID=$o(^DHCWL.MeasureDimrole.MeasureI("Code"," "_$zcvt(code,"U"),measureID))
		q:measureID=""
		s flag=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),9)
		continue:flag=1
		if (flag'=1){
			s error=1
		}
	}
	q:(error=1) "存在相同的编码,请重新定义编码"
	
	s dsCode=$lg(^DHCWL.MeasureDimrole.DSourceD(dataSource),3)
	s dsDesc=$lg(^DHCWL.MeasureDimrole.DSourceD(dataSource),4)
	s dsPakName=$lg(^DHCWL.MeasureDimrole.DSourceD(dataSource),2)
	s staCode=$p(meastaCal,":",1)
	s staDesc=$p(meastaCal,":",2)
	s calCode=$p(calItem,":",1)
	s calDesc=$p(calItem,":",2)
	//相同的数据源、计算项、统计口径只能有一份
	s measureID="",error=""
	for{
		s measureID=$o(^DHCWL.MeasureDimrole.MeasureI("DataSource"," "_$zcvt(dsCode,"U"),measureID))
		q:measureID=""
		s flag=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),9)
		continue:flag=1
		s HCalItem=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),5)
		s HMeastaCal=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),6)
		if (HCalItem=calCode)&(HMeastaCal=staCode){
			s error=1
		}
	}
	q:(error=1) "同样的数据源、计算项、统计口径不能多次维护"
	
	//q:$d(^DHCWL.MeasureDimrole.DimRoleI("Code"," "_$zcvt(code,"U"))) "存在相同的编码,请重新定义编码"
	&sql(INSERT INTO DHCWL_MeasureDimrole.DHCWLMeasure(Mea_Code,Mea_Desc,Mea_DataSource,Measure_CalItem,Mea_StaCal,Mea_CreateDate,Mea_CreateUse,Mea_PackName,Mea_DsDesc,Mea_StaDesc,Mea_CalDesc) VALUES(:code,:desc,:dsCode,:calCode,:staCode,:date,:creator,:dsPakName,:dsDesc,:staDesc,:calDesc))
	i SQLCODE=0{
		s result="ok"
	}
	q result
}

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     获取度量信息
/// Table:           
/// Input: 			
/// Output:			
/// Return:
/// Others:			d ##class(%ResultSet).RunQuery("DHCWL.MeasureDimroleData.FunctionModule","getMeasureInforQuery","")
Query getMeasureInforQuery(measureSearch = "", dataSource = "", calItem = "", staCal = "") As %Query(ROWSPEC = "meaID:%String,meaCode:%String,meaDesc:%String,meaDSource:%String,meaCalItem:%String,meastaCal:%String,meaDate:%String,meaCreator:%String") [ SqlProc ]
{
}

ClassMethod getMeasureInforQueryExecute(ByRef qHandle As %Binary, measureSearch = "", dataSource = "", calItem = "", staCal = "") As %Status
{
	n (qHandle,measureSearch,dataSource,calItem,staCal)
	//s ^TEMPDHCWL("wk","test1")=meaCode_"^"_meaDesc_"^"_meaDSource_"^"_meaCalItem_"^"_meastaCal_"^"_meaCreator
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s measureID=""
 	for {
	 	s measureID=$o(^DHCWL.MeasureDimrole.MeasureD(measureID))
	 	q:measureID=""
	 	s RVoidFlag=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),9)
	 	continue:RVoidFlag=1
	 	s RCode=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),2)
	 	s RDesc=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),3)
	 	s RDataSource=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),4)
	 	s RCalItem=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),5)
	 	s RStaCal=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),6)
	 	s RCreateDate=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),7)
	 	s:RCreateDate'="" RCreateDate=##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(RCreateDate)
	 	s RCreateUse=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),8)
	 	s RDSDesc=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),11)
	 	s RStaDesc=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),12)
	 	s RCalDesc=$lg(^DHCWL.MeasureDimrole.MeasureD(measureID),13)
	 	//continue:RDataSource'[dataSource
	 	//continue:RCalItem'[calItem
	 	//continue:RStaCal'[staCal
	 	s:RDSDesc'="" RDataSource=RDataSource_":"_RDSDesc
	 	s:RCalDesc'="" RCalItem=RCalItem_":"_RCalDesc
	 	s:RStaDesc'="" RStaCal=RStaCal_":"_RStaDesc
	 	s measureSearch=$zcvt(measureSearch,"U")
	 	continue:($zcvt(measureID,"U")'[measureSearch)&($zcvt(RCode,"U")'[measureSearch)&($zcvt(RDesc,"U")'[measureSearch)&($zcvt(RDataSource,"U")'[measureSearch)&($zcvt(RCalItem,"U")'[measureSearch)&($zcvt(RStaCal,"U")'[measureSearch)&($zcvt(RCreateUse,"U")'[measureSearch)
	 	continue:($zcvt(RDataSource,"U"))'[($zcvt(dataSource,"U"))
	 	continue:($zcvt(RCalItem,"U"))'[($zcvt(calItem,"U"))
	 	continue:($zcvt(RStaCal,"U"))'[($zcvt(staCal,"U"))
	 	/*continue:RDesc'[measureSearch
	 	continue:RDataSource'[measureSearch
	 	continue:RCalItem'[measureSearch
	 	continue:RStaCal'[measureSearch
	 	continue:RCreateUse'[measureSearch*/
	 	//s:RCreateDate'="" RCreateDate=$zd(RCreateDate,3)
	 	s ^CacheTemp(repid,ind)=$lb(measureID,RCode,RDesc,RDataSource,RCalItem,RStaCal,RCreateDate,RCreateUse)
	 	s ind=ind+1
 	}
	
	Quit $$$OK
}

ClassMethod getMeasureInforQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getMeasureInforQueryExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod getMeasureInforQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getMeasureInforQueryExecute ]
{
	n (AtEnd,qHandle,Row)
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

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     修改度量
/// Table:           
/// Input: 			 度量ID			
/// Return:			 返回执行作废操作状态
/// Others:			 d ##class(DHCWL.MeasureDimroleData.FunctionModule).ModifyMeasure("")
ClassMethod ModifyMeasure(ID, desc)
{
	n (ID,desc)
	s date=$p($h,",",1)
	s result="error"
	q:'$d(^DHCWL.MeasureDimrole.MeasureD(ID)) "未找到相关维度角色"
	&sql(update DHCWL_MeasureDimrole.DHCWLMeasure set Mea_Desc=:desc,Mea_CreateDate=:date where ID=:ID)
	i SQLCODE=0{
		s result="ok"
	}
	q result
}

/// Creator:         wk
/// CreatDate:       2017-04-05
/// Description:     作废度量
/// Table:           
/// Input: 			度量ID			
/// Return:			返回执行作废操作状态
/// Others:			d ##class(DHCWL.MeasureDimroleData.FunctionModule).DeleteMeasure("")
ClassMethod DeleteMeasure(meaID)
{
	n (meaID)
	s date=$p($h,",",1)
	s result="error"
	q:'$d(^DHCWL.MeasureDimrole.MeasureD(meaID)) "未找到相关度量"
	s sc=##class(DHCWL.Interface.MKPI.KpiData).DeleteKpiMeasure(meaID)
	q:(sc'="ok") result
	&sql(update DHCWL_MeasureDimrole.DHCWLMeasure set Mea_VoidFlag="1",Mea_CreateDate=:date where ID=:meaID)
	i SQLCODE=0{
		s result="ok"
	}
	q result
}

}

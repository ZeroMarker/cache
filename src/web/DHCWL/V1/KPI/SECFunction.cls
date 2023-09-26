/// Creator:         wk
/// CreatDate:       2018-05-18
/// Description:	 区间维护
Class web.DHCWL.V1.KPI.SECFunction Extends %RegisteredObject
{

/// Creator    : wk
/// CreatDate  : 2018-05-18
/// Desc       : 获取区间信息
/// Input      : 
/// Output     : 区间信息
/// Table      : DHCWL_MKPI.DHCWLSection
/// Other      ：
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.SECFunction","GetSecInforQuery",)
Query GetSecInforQuery() As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:区间编码,name:%String:区间名称,desc:%String:区间描述,creator:%String:创建者,remark:%String:备注,updateDate:%String:更新日期,parentCode:%String:直接父区间") [ SqlProc ]
{
}

ClassMethod GetSecInforQueryExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
 	s sql="select ID,Sec_Code,Sec_Desc,Sec_DirectParent,Sec_Name,Sec_Remark,Sec_UpdateDate,Sec_User  from DHCWL_MKPI.DHCWLSection"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s updateDate=rs.Data("Sec_UpdateDate")
		if (updateDate){
			s updateDate=##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(updateDate)
		}
		s parentCode=""
		s parentID=rs.Data("Sec_DirectParent")
		if (parentID){
			s parentCode=$lg(^DHCWL.MKPI.SectionD(parentID),2)
		}
		s ^CacheTemp(repid,ind)=$lb(rs.Data("ID"),rs.Data("Sec_Code"),rs.Data("Sec_Name"),rs.Data("Sec_Desc"),rs.Data("Sec_User"),rs.Data("Sec_Remark"),updateDate,$g(parentCode))
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-05-18
/// Desc       : 获取区间属性信息
/// Input      : 
/// Output     : 区间属性信息
/// Table      : DHCWL_MKPI.DHCWLSectionProperty
/// Other      ：
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.SECFunction","GetSecProInforQuery",)
Query GetSecProInforQuery(secID As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,secProCode:%String:属性编码,secProName:%String:属性名称,secProDesc:%String:属性描述,secProExeCode:%String:执行代码") [ SqlProc ]
{
}

ClassMethod GetSecProInforQueryExecute(ByRef qHandle As %Binary, secID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:secID="" $$$OK
 	s sql="select ID,SecDimPro_Code,SecDimPro_Name,SecDimPro_Desc,SecDimPro_ExcCode from DHCWL_MKPI.DHCWLSectionProperty where SecDimPro_DimDr="_secID
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ^CacheTemp(repid,ind)=$lb(rs.Data("ID"),rs.Data("SecDimPro_Code"),rs.Data("SecDimPro_Name"),rs.Data("SecDimPro_Desc"),rs.Data("SecDimPro_ExcCode"))
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   :  wk
/// CreatDate :  2018-05-21
/// Desc      :  区间属性的新增与描述
/// Input     :  区间属性信息
/// Output    :  区间属性更新状态
/// Other     ： do ##class(web.DHCWL.V1.KPI.SECFunction).updateSecPro()
ClassMethod updateSecPro(proID As %String, proCode As %String, proName As %String, proDesc As %String, proExeCode As %String, sectionID As %String)
{
	s id=proID	
	s Code=proCode
	s Name=proName
	s Desc=proDesc
	s DefaultFlag="N"
	s SecDimDr=sectionID
	s ExcuteCode=proExeCode
	if (id=""){//新增
		//判断编码是否重复
		s repFlag=0
		s secID=""
		f {
			s secID=$o(^DHCWL.MKPI.SectionD(secID))
			q:secID=""
			s alphCode=$SYSTEM.SQL.ALPHAUP(Code) 
			if $d(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",secID,alphCode)) {
				s repFlag=1
				q	
			}
		}
		
	if repFlag=1 {
		q "维度属性编码不能重复!"
	}
	&sql(INSERT INTO DHCWL_MKPI.DHCWLSectionProperty (SecDimPro_Code, SecDimPro_Name, SecDimPro_Desc, SecDimPro_ExcCode, SecDimPro_DimDr, SecDimPro_DefaultFlag)
			VALUES (:Code, :Name, :Desc, :ExcuteCode, :SecDimDr, :DefaultFlag))
	i +$g(SQLCODE)'=0 {
		q "添加失败！"_SQLCODE	
	}else{
		q "更新成功"	
	}
    }else{//修改
    	s ^TEMPDHCWL("test","111")=Code_"^"_Name_"^"_Desc_"^"_ExcuteCode_"^"_DefaultFlag_"^"_id
		&sql(UPDATE DHCWL_MKPI.DHCWLSectionProperty SET SecDimPro_Code = :Code, SecDimPro_Name = :Name
			, SecDimPro_Desc = :Desc, SecDimPro_ExcCode= :ExcuteCode,SecDimPro_DefaultFlag = :DefaultFlag	WHERE ID = :id)
		i +$g(SQLCODE)'=0 {
			q "更新失败！"_SQLCODE	
		}else{
			q "更新成功"	
		}
    }
}

/// Creator   : wk
/// CreatDate : 2018-05-21
/// Desc      : 删除区间属性
/// Table     : DHCWL_MKPI.DHCWLSectionProperty 
/// Other     : do ##class(web.DHCWL.V1.KPI.SECFunction).deleteSecPro()
ClassMethod DeleteSecPro(dimProId As %String)
{
	q:+dimProId=0 "获取区间属性失败"
	&sql(delete from DHCWL_MKPI.DHCWLSectionProperty where ID =:dimProId)
	i +$g(SQLCODE)'=0 {
		q "删除失败！"_SQLCODE	
	}else{
		q "删除成功"	
	}
}

/// Creator    : wk
/// CreatDate  : 2018-05-23
/// Desc       : 获取monthID信息
/// Table      : DHCWL_MKPI.DHCWLKPIMonths
/// Other      ：
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.SECFunction","GetMonthQuery",)
Query GetMonthQuery(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,monCode:%String:日期编码,monName:%String:日期名称,monDesc:%String:日期描述,monUpdate:%String:日期更新日期,monSecCode:%String:区间编码") [ SqlProc ]
{
}

ClassMethod GetMonthQueryExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$ZCVT(filterValue,"U")
 	s sql="select ID,KPIM_Code,KPIM_Name,KPIM_Desc,KPIM_UpdateDate,KPIM_SectionFlag from DHCWL_MKPI.DHCWLKPIMonths order by ID"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s updateDate=rs.Data("KPIM_UpdateDate")
		if (updateDate){
			s updateDate=##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(updateDate)
		}
		s secID=""
		s secID=rs.Data("KPIM_SectionFlag")
		if (secID){
			s secCode=$lg(^DHCWL.MKPI.SectionD(secID),2)
		}
		s ID=rs.Data("ID")
		s code=rs.Data("KPIM_Code")
		s name=rs.Data("KPIM_Name")
		s desc=rs.Data("KPIM_Desc")
		continue:((filterValue'="")&&(code '[ filterValue)&&(name '[ filterValue)&&(desc '[ filterValue)&&(secCode '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(ID,code,name,desc,updateDate,secCode)
		s ind=ind+1
	}
	Quit $$$OK
}

///  Creator   : wk
///  CreatDate : 2018-05-23
///  Desc      : 生成指定年份的monthID
///  Other     : do ##Class(web.DHCWL.V1.KPI.SECFunction).CreatMonthID()
ClassMethod CreatMonthID(year As %String)
{
	s nowDate=$p($h,",",1)
	s date=$zd(nowDate,3)
	s nowYear=$p(date,"-",1)
	q:(year="") "生成年份不能为空"
	q:('((year<(nowYear+20))&&(year>(nowYear-20)))) "请输入合理的年份"
	d ##class(DHCWL.MKPICustom.CreatKPIMonths).CreateMonths(year)
	q "生成成功"
}

///  Creator   : wk
///  CreatDate : 2018-12-07
///  Desc      : 获取生成monthID的year列表
///  Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.SECFunction","GetYearList",)
Query GetYearList() As websys.Query(ROWSPEC = "code:%String,desc:%String") [ SqlProc ]
{
}

ClassMethod GetYearListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s date=$p($h,",",1)
	s year=$p($zd(date,3),"-",1)
	for i=(year-5):1:(year+10){
		s ^CacheTemp(repid,ind)=$lb(i,i)
		s ind=ind+1
	}
	Quit $$$OK
}

}

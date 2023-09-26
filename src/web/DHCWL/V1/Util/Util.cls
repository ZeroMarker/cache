/// Creator   : wk
/// CreatDate : 2018-09-19
/// Desc      : 通用接口
Class web.DHCWL.V1.Util.Util Extends %RegisteredObject
{

/// Creator   : wk
/// CreatDate : 2018-09-19
/// Desc      : 解析过滤规则
/// Other     : do ##Class(web.DHCWL.V1.Util.Util).ResoleFilterRule()
ClassMethod ResoleFilterRule(filterRule, ByRef filterList)
{
	s filterIndex=1
	k filterList
	i filterRule["\" s filterRule=$REPLACE(filterRule,"\","\\\")
	s orLen=$l(filterRule,"||")
	//拆分过滤规则
	for i=1:1:orLen{
		s orRule=$p(filterRule,"||",i)
		continue:orRule=""
		s andLen=$l(orRule,"&&")
		for j=1:1:andLen{
			s andRule=$p(orRule,"&&",j)
			continue:andRule=""
			s andRule=##class(DHCWL.util.StringUtil).Trim(andRule)
			if (j=1){
				if (i'=1){
					s andRule="||"_andRule
				}
			}else{
				s andRule="&&"_andRule
			}
			s beforeStr=$p(andRule,"{",1)
			continue:beforeStr=""
			s beforeLen=$l(beforeStr,"[")
			continue:(beforeLen=1)
			s beforeRule=$p(beforeStr,"[",1,(beforeLen-1))
			s rightLen=$l(andRule,"]")
			continue:(rightLen<2)
			s rightRule=$p(andRule,"]",2,(rightLen))
			s centerRule=$p($p(andRule,"{",2),"]",1)
			s centerRule="{"_centerRule
			s:beforeRule=" " beforeRule=""
			s:rightRule=" " rightRule="" 
			
			s filterStr=centerRule
			s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr,"[")
			s filterStr=##class(DHCWL.util.StringUtil).Trim(filterStr,"]")
			s filterStr=##class(DHCWL.util.StringUtil).EscapeStr(filterStr,"[","\")
			s filterStr2=$zcvt(filterStr,"U")
			s choiceFilter="",ind=0,best=0,bestFilter=""
			s filterStrLen=$L(filterStr2),filterFunStrInd=1
			f i=1:1:filterStrLen {
				if $e(filterStr2,i)="}" {
					s filterFunStrInd=i+1
					q
				}
			}
			s filterStr3=$e(filterStr2,filterFunStrInd,filterStrLen)
			f {
				s choiceFilter=$o(^DHCWL.MKPI.SysFilterFuncI("Code",choiceFilter))  ;$o(^DHCWLMKPIFilterConf("FILTER",choiceFilter))
				q:choiceFilter=""
				s choiceFilter2=##class(DHCWL.util.StringUtil).Trim(choiceFilter)
				if (($l(choiceFilter2)>best)&&($f(filterStr3,choiceFilter2)>0)){
					s best=$l(choiceFilter2),bestFilter=choiceFilter2
					s ind=$f(filterStr3,choiceFilter2)+filterFunStrInd-1
				}
			}
			
			s value=$p(filterStr3,bestFilter,2)
			s value=##class(DHCWL.util.StringUtil).Trim(value)
			s dimRule=$p($p(filterStr,"{",2),"}",1)
			s filterList(filterIndex)=$lb(beforeRule,dimRule,bestFilter,value,rightRule)
			s filterIndex=filterIndex+1
			//s ^CacheTemp(repid,ind)=$lb(beforeRule,dimRule,bestFilter,value,rightRule)
			//s ind=ind+1
		}
	}
}

/// Creator    : wk
/// CreatDate  : 2018-09-29
/// Desc       : 获取维度表格信息
/// Other      : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.Util.Util","GetDim")
Query GetDim(q As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,dimCode:%String:dimCode,dimName:%String:dimName") [ SqlProc ]
{
}

ClassMethod GetDimExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s sql="SELECT ID,KDT_Code,KDT_Name FROM DHCWL_MKPI.DHCWLMKPIDimType"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s code=rs.Data("KDT_Code")
		s name=rs.Data("KDT_Name")
		continue:(filterValue'="")&&($zcvt(code,"U") '[ filterValue)&&($zcvt(name,"U") '[ filterValue)
		s ^CacheTemp(repid,ind)=$lb(ID,code,name)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-30
/// Desc      : 获取维度属性信息
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.Util.Util","GetDimPro")
Query GetDimPro(dimCode As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,name:%String:描述") [ SqlProc ]
{
}

ClassMethod GetDimProExecute(ByRef qHandle As %Binary, dimCode As %String, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s dimID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimCode,"DHCWL.MKPI.MKPIDimType")
	q:dimID="" $$$OK
	s sql="SELECT ID,DimPro_Code,DimPro_Name FROM DHCWL_MKPI.DHCWLDimProperty WHERE DimPro_DimDr="_dimID
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s code=rs.Data("DimPro_Code")
		s desc=rs.Data("DimPro_Name")
		continue:((filterValue'="")&&($zcvt(code,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(ID,code,desc)
		s ind=ind+1
	}
	Quit $$$OK
}

}

/// Creator   : wk
/// CreatDate : 2018-05-18
/// Desc      : 通用接口
Class web.DHCWL.V1.KPI.MaintainKpi Extends %RegisteredObject
{

/// 根据类全名，搜索对应的表信息，返回得到给定范围内的Json数据
/// s json=##class(web.DHCWL.V1.KPI.MaintainKpi).GetObjsByClassName("DHCWL.MKPI.Section",1,6)
ClassMethod GetObjsByClassName(classNameData, st As %Integer = "", ed As %Integer = "", ByRef searchCond) As DHCWL.util.Json
{
	s className=classNameData
	s paraList="",sqlFieldName=""
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
	s sqlTableName=cdef.SqlTableName
 	Set count = cdef.Properties.Count()
 	s deli="&",TF=""  //TF标示属性和字段的对应关系//add by lhh@20130221
 	For i = 1:1:count-1 d
	.s paraList=paraList_cdef.Properties.GetAt(i).Name_deli
	.s PV(cdef.Properties.GetAt(i).SqlFieldName)=cdef.Properties.GetAt(i).Type
	.s sqlFieldName=sqlFieldName_cdef.Properties.GetAt(i).SqlFieldName_","
	.s TF(cdef.Properties.GetAt(i).Name)=cdef.Properties.GetAt(i).SqlFieldName //add by lhh@20130221
	s paraList=paraList_cdef.Properties.GetAt(count).Name
	s sqlFieldName=sqlFieldName_cdef.Properties.GetAt(count).SqlFieldName
	s TF(cdef.Properties.GetAt(count).Name)=cdef.Properties.GetAt(count).SqlFieldName
	s PV(cdef.Properties.GetAt(count).SqlFieldName)=cdef.Properties.GetAt(count).Type
	s json=##class(DHCWL.util.Json).Json("ID"_deli_paraList,"total","rows",deli)
	s pageSize=ed-st
	//add by lhh@20130221
	s sqlSearch="  ",flagNum=0
	i (1=1)||($o(searchCond(""))'="") d
	.s tempF="" f  s tempF=$o(searchCond(tempF)) q:tempF=""  d
	..i ($g(TF(tempF))'="")&&($g(searchCond(tempF))'="") d
	...s flagNum=flagNum+1
	...s sqlSearch=sqlSearch_$case(flagNum,1:" ",:" and ")_" "_TF(tempF)_" like '%"_..FormateDateh(PV(TF(tempF)),searchCond(tempF))_"%'"
	i flagNum>0 s sqlSearch=" where "_sqlSearch
	s sqlStr="select ID,"_sqlFieldName_"  from "_..GetSchema(className)_"."_sqlTableName_sqlSearch
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sqlStr)
	d rs.Execute()
	s num=0
	While(rs.Next()){
		s num=num+1
		i (st+pageSize'=0)&&(num<(st)) continue
		i (st+pageSize'=0)&&((st+pageSize)<num) continue
		s temp=""
		f i=1:1:count-1 d
		.s para=$p(sqlFieldName,",",i)
		.s mark=..IsString(PV(para))
		.s temp=temp_mark_..FormateDate(PV(para),rs.Data(para))_mark_deli
		s para=$p(sqlFieldName,",",count)
		s mark=..IsString(PV(para))
		s temp=temp_mark_..FormateDate(PV(para),rs.Data(para))_mark
		s temp=""""_rs.Data("ID")_""""_deli_temp
		d json.InsertForHISUI(temp)
	}
	d json.SetTotalNum(num)
	/*w "["
	d {
		s obj=json.GetNextJsonArray()
		i obj'="" w obj,","
	}while(obj'="")
	w "]"
	q*/
	w json.GetHeadForHISUI()
	;有一些代替此方法（因为数据量大时string会溢出）
	d{
		s obj=json.Next()
		w obj
	}while(obj'="")
	i json.GetCount()=0 w "]}"
	q ""
}

/// w ##class(web.DHCWL.KPI.MaintainKpi).GetSchema("web.DHCWL.KPI.MaintainKpi")
ClassMethod GetSchema(className) As %String
{
	s pn=$l(className,"."),schema=""
	i pn<2 d
	.s schema="SQLUser"
	e  d
	.s temp=$p(className,".",1,pn-1)
	.f i=1:1:$l(temp) d
	..i $e(temp,i)="."  d
	...s schema=schema_"_"
	..e  d
	...s schema=schema_$e(temp,i)
	q schema
}

ClassMethod FormateDate(type, date) As %String
{
	i type ["%Date" {
		//q $zd(+date,3)	//++modify by wk~2017-03-03~公司时间控件标准化
		q ##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(date)
	}elseif type [ "Section" {
		i (+$g(date)'=0)&&($d(^DHCWL.MKPI.SectionD(date))) {
			i 'type [ "DHCWL.MKPI" s type="DHCWL.MKPI."_type
			s exe="s exeObj=##class("_type_").%OpenId("_$g(date)_")"
			x "  "_exe
			i $g(exeObj)'="" q exeObj.SecCode
			else  q date
		}else {
			q $g(date)
		}
	}else {
		 q date
	}
}

/// w ##class(web.DHCWL.KPI.MaintainKpi).IsString("%String")
ClassMethod IsString(type) As %String
{
	q """"
	i (type[ "String")||(type [ "%Date")||(type [ "DHCWL" )  q """"
	e  q ""
}

ClassMethod FormateDateh(type, date) As %String
{
	i type ["%Date" q ##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(date)
	e  q date
}

}

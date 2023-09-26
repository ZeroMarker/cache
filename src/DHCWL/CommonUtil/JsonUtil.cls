Class DHCWL.CommonUtil.JsonUtil Extends %RegisteredObject
{

/*
					1,sql:
					
					s qryName="%DynamicQuery:SQL"  //固定写法
					s sql="select colname from tabname where ..."
					s json=##class(DHCWL.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro)

					2,query:
					s qryName=query名称
					s exeArgs=query入参,这个入参是一个串，由这个query自己解析
					s json=##class(DHCWL.CommonUtil.JsonUtil).GetJsonByQry(qryName,exeArgs,"",start,end,jsonPro)
	
	
	*/
/// Creator：      王峥
/// CreatDate：    2017-7-11
/// Description:： 根据query或sql返回一个JSON数据，主要用于向EXTJS的store对象返回数据
/// Table：       
/// Input：        start，记录开始位置，end，记录结束位置，返回json中的字段。其他参数见others
/// Output：       
/// Return：       JSON格式数据
/// Others：        两种使用方法：
ClassMethod GetJsonByQry(qryName As %String, exeArgs As %String, preArgs As %String = "", start As %Integer = 0, end As %Integer = 0, pros = "") As DHCWL.util.Json
{
	//n (sql,start,end,pros,replaceValue)
	//i $Get(replaceValue, 0)=0 s replaceValue=""
	//s sql=..ReplaceSQLValue(sql,.replaceValue)
	s rs=##class(%Library.ResultSet).%New(qryName)
	d rs.Prepare(preArgs)
	d rs.Execute(exeArgs)
	s cols=rs.GetColumnCount()
	//s colNames="",deli="&",ind=0
	s colNames="",deli=$c(2),ind=0
	k FA
	f i=1:1:cols {
		s name=rs.GetColumnHeader(i)
		i colNames'="" s colNames=colNames_","_name
		e  s colNames=name
		i name="" continue
		s ind=ind+1
		s FA("DEF",name)=rs.GetColumnType(i)
		s FA("PAR",ind,name)=""
	}
	s:$g(pros)="" pros=colNames
	s tempPros=""
	f i=$l(pros):-1:1 {
		i $e(pros,i)="," s tempPros=deli_tempPros
		e  s tempPros=$e(pros,i)_tempPros
	}
	s nums=0
	s json=##class(DHCWL.util.Json).Json(tempPros,,,deli)
	s ignore=1
	i (start=0)&&(end=0) s ignore=0
	While(rs.Next()){
		s i=0
		s nums=nums+1
		i (ignore)&&(nums<(start)) continue
		i (ignore)&&((end)<nums) continue
		s values=""
		f {
			s i=$o(FA("PAR",i))
			q:i=""
			s field=$o(FA("PAR",i,""))
			s v=rs.Data(field)
			s v=$tr(v,$C(13),"")	//去掉回车
			s v=$tr(v,$C(10),"")	//去掉换行
			s type=FA("DEF",field)
			s v=..ConvertToViewType(type,v)
			s:(v=$c(0)) v=""

			s v=..ConvertQuotes(v)
			i values'="" s values=values_deli_"'"_v_"'"
			else  s values="'"_v_"'"


		}
		d json.Insert(values)
	}
	d:json json.SetTotalNum(nums)
	d rs.Close()
	q json
}

ClassMethod ConvertToViewType(type, value)
{
	q:(value="")||(value=$c(0)) ""
	i type=2 {
		//q $zd(value,3)	//modify by wz.2018-01-08
		q ##class(websys.Conversions).DateLogicalToHtml(value)
	}
	q value
}

ClassMethod ConvertQuotes(quotesData) As %String
{
	q:$find(quotesData,"'")=0 quotesData
	s value=""
	s len=$l(quotesData)
	f i=1:1:len {
		s qData=$E(quotesData,i)
		if qData="'" s qData="\'"
		s value=value_qData
	}

	q value
}

}

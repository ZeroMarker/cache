Class web.DHCWL.V1.CommonUtil.Json Extends DHCWL.util.Json
{

Property page As %Integer;

ClassMethod Json(title, result = "curPage", root = "rows", deli = "^", page) As Json
{
	;n (title,result,root, deli)
	q:title="" ""
	s json=##class(Json).%New()
	s json.title=title
	s json.propertyNum=$l(title,deli)
	s json.result=result,json.root=root,json.count=0,json.delimer=deli,json.totalNum=0,json.privor=0
	s json.page=page
	q json
}

Method GetHead() As %String
{
	s ..privor=0
	q "{"""_..result_""":"_..page_",""total"":"_..totalNum_","""_..root_""":["
}

Method Insert(objStr)
{
	;n (objStr)
	s obj="",obj2="",v2=""
	f i=1:1:..propertyNum {
		s v2=""
		s colName=$p(..title,..delimer,i)
		s v=$p(objStr,..delimer,i)
		f j=$l(v):-1:1 {
			s char=$e(v,j)
			continue:($ascii(char)=0)
			s v2=char_v2
		}
		s v=v2
		i obj'="" s obj=obj_","""_colName_""":"_$g(v),obj2=obj2_","_$g(v)
		e  s obj=""""_colName_""""_":"_$g(v),obj2=$g(v)
	}
	s obj="{"_obj_"}"
	d ..data.Insert(obj)
	d ..dataArray.Insert(obj2)
	s ..count=..count+1,..totalNum=..totalNum+1
	q
}

}

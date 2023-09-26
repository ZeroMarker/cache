Class web.print.Test Extends %RegisteredObject
{

ClassMethod GetData(EpisodeID)
{
	Set printObj =  ##class(ext.util.JsonObject).%New()
	/*name,sex,AdmID,age为XML模板中的元素名*/
	do printObj.Put("name","汪小二").Put("sex","<""男").Put("AdmID",EpisodeID).Put("age",18_"岁")
	set rtn = printObj.GetPrintData()
	do printObj.%Close()
	Set printObj = ""
	quit rtn
}

Query FindPat(loc) As websys.Query(ROWSPEC = "no:%String:序号,patname:%String:病人姓名,age:%String:年龄,admdate:%String:就诊日期,regno:%String:登记号,loc:%String:科室")
{
}

ClassMethod FindPatExecute(ByRef qHandle As %Binary, loc) As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	set qHandle = $lb(0,repid,0)
	Set namelist = $lb("刘","张","王","赵","孙","李","周","汪")
	; 19968至40869
	for i=1:1:20{
		s ind = ind+1
		Set name = $lg(namelist,$r(8)+1)_$char($r(20901)+19968)_$char($r(20901)+19968)
		s ^CacheTemp(repid,ind) = $lb(ind,name,"45","2016-01-10","1726367211",loc)
	}
	set qHandle = $lb(0,repid,0)
	Q $$$OK
}

}

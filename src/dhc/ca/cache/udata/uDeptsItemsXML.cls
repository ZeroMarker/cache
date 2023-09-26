Class dhc.ca.cache.udata.uDeptsItemsXML Extends %CSP.Page [ ClassType = "", Not ProcedureBlock ]
{

Parameter CONTENTTYPE = "text/xml";

///  Creator：wyy
///  CreatDate：2009-12-21
///  Description: 根据id生成xml文件
///  Table：
///  Input：id-任意值
///  Output：
///  Return：错误返回错误信息，正确返回正确信息
///  Others：如果传的参数为空，则报错
ClassMethod OnPage() As %Status
{
		Write "<?xml version=""1.0"" ?>",!
		Set id=$G(%request.Data("job",1))
		//If (id=""){
		//    Set status=id
		//    Do $system.OBJ.DisplayError(status)
	    //	Quit status
		//	}
		Set reportData =..GenReportData(id)
		
		Set status = reportData.XMLExport()
	    If ($system.Status.IsError(status)) {
	    	Do $system.OBJ.DisplayError(status)
	    	Quit status
	    }
	         
	    Quit $system.Status.OK()
}

///  Creator：wyy
///  CreatDate：2009-12-21
///  Description: 根据id得到数据插入到reportData
///  Table：
///  Input：id-任意值
///  Output：
///  Return：reportData对象
///  Others：w ##class(dhc.ca.cache.udata.uDeptsItemsXML).GenReportData(2668)
ClassMethod GenReportData(job) As uDeptsItemsList
{
	New (job)
	Set reportData = ##class(dhc.ca.cache.udata.uDeptsItemsList).%New()
	Set job=$G(job)

    s tmpIth=0
    f  q:tmpIth=""  d
    .s tmpIth=$o(^tmpDeptItem(job,"DirectCost",tmpIth))
    .i tmpIth'="" d
    ..i $p(tmpIth,"^",2)="" d
    ...s tn=^tmpDeptItem(job,"DirectCost",tmpIth,0)
    ...s tmpSp=..genSpaces(tmpIth,job)
    ...s tn1=tmpSp_$p(^DHCCADEPTLEVELSETS($p(tn,"^",1)),"^",2)
	...s tn2="合计"
	...s tn3=$p(tn,"^",3)
	...s tn=tn1_"^"_tn2_"^"_tn3
    ...S CommData=..GetDataFromGlobal(tn)	
    ...d reportData.DeptsItemsObj.Insert(CommData)
    ..e  d
    ...s tmpJth=-1
    ...f  q:tmpJth=""  d
    ....s tmpJth=$o(^tmpDeptItem(job,"DirectCost",tmpIth,tmpJth))
    ....i tmpJth'="" d
    .....i ($p(tmpJth,"^",2)'="")||($p(tmpJth,"^",1)=0) d
    ......s tn=^tmpDeptItem(job,"DirectCost",tmpIth,tmpJth)
    ......i $p(tmpJth,"^",1)'=0 d
    .......s tn1=" "
	.......s tn2=$p(^DHCCAALLDATAITEMS($p(tn,"^",2)),"^",3)
	......e  d
	.......s tmpSp=..genSpaces(tmpIth,job)
	.......;w $p(tn,"^",1),"###",^DHCCAUNITDEPTS($p(tn,"^",1)),"###",$p(^DHCCAUNITDEPTS($p(tn,"^",1)),"^",2),!
	.......s ttt=$p(tn,"^",1)
	.......s tn1=""
	.......i ttt'="" d
	........i $d(^DHCCAUNITDEPTS(ttt)) d
	.........s tn1=tmpSp_$p(^DHCCAUNITDEPTS(ttt),"^",2)
	.......s tn2="小计"
	......s tn3=$p(tn,"^",3)
	......s tn=tn1_"^"_tn2_"^"_tn3
    ......S CommData=..GetDataFromGlobal(tn)	
    ......d reportData.DeptsItemsObj.Insert(CommData)
	Quit reportData
}

///  Creator：wyy
///  CreatDate：2009-12-21
///  Description: 根据临时global的值，得到对应的字段
///  Table：
///  Input：
///  Output：
///  Return：reportData对象
/// Others: w ##class(dhc.ca.cache.udata.uDeptsItemsXML).GetDataFromGlobal("dept^item^100")
ClassMethod GetDataFromGlobal(Comm) As uDeptsItemsObj
{
	New (Comm)
	Set Comm=$G(Comm)
	Set reportData = ##class(dhc.ca.cache.udata.uDeptsItemsObj).%New()
	Set reportData.Dept = $p(Comm,"^",1)
	Set reportData.Item = $p(Comm,"^",2)
	Set reportData.Money = $p(Comm,"^",3)
	Quit reportData
}

ClassMethod countSpaces(nodeId) As %String
{
	n (nodeId)
	s t2=""
	s t2=$p(nodeId,"^",2)
	i t2'="" d
	.s t2=1
	e  d
	.s t2=0
	s tmpNum=1
	s t=1
	f  q:t=""  d
	.s t=$p(nodeId,"||",tmpNum)
	.s tmpNum=tmpNum+1
	.i t'=""
	s tn=tmpNum-2
	q tn+t2
}

/// Others: w ##class(dhc.ca.cache.udata.uDeptsItemsXML).genSpaces("39||40||41",3284)
ClassMethod genSpaces(nodeId, job) As %String
{
	n (nodeId,job)
	s root=""
	s root=$o(^tmpDeptItem(job,"DirectCost",root))
	s rootNum=..countSpaces(root)
	s nodeNum=..countSpaces(nodeId)
	s spNum=nodeNum-rootNum
	s sp=""
	f  q:spNum=0  d
	.s spNum=spNum-1
	.s sp=sp_"  "
	q sp
}

}

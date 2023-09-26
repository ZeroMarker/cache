Class dhc.ca.cache.udata.uDeptIncomeXML Extends %CSP.Page [ ClassType = "", Not ProcedureBlock ]
{

Parameter CONTENTTYPE = "text/xml";

///  Creator：wang ying
///  CreatDate：2009-12-25
///  Description: 根据id,医院ID生成XML
///  Table：
///  Input：id-任意值
///  Output：
///  Return：错误返回错误信息，正确返回正确信息
///  Others：如果传的参数为空，则报错。
ClassMethod OnPage() As %Status
{
	Write "<?xml version=""1.0"" ?>",!
	
	Set id=$G(%request.Data("Id",1))
	//Set hospDr=$G(%request.Data("hospDr",1))
	//Set id = 3356
	d ##CLASS(dhc.ca.cache.udata.uGenLevelTmp).GenLevelTmp(id)
	If (id=""){
	    Set status=id
	    Do $system.OBJ.DisplayError(status)
    	Quit status
		}
	Set reportData = ..GenReport(id) 
	Set status = reportData.XMLExport()
    If ($system.Status.IsError(status)) {
    	Do $system.OBJ.DisplayError(status)
    	Quit status
    } 
    k ^TMP(0,"dhc","ca",id)
    Quit $system.Status.OK()
}

///  Creator：wang ying
///  CreatDate：2009-12-25
///  Description: 根据id得到数据插入到reportData
///  Table：
///  Input：id-任意值
///  Output：
///  Return：reportData对象
///  Others：如果传的参数为空，则报错
ClassMethod GenReport(id) As dhc.ca.cache.udata.uDeptIncomeList
{
	Set reportData = ##class(dhc.ca.cache.udata.uDeptIncomeList).%New()
	Set id=$G(id)
	Set count=""
	Do {
		 Set count=$o(^TMP(0,"dhc","ca",id,count))
		 Q:count=""
		 Set setLoc=$G(^TMP(0,"dhc","ca",id,count))
		 Set setLocData=..GetDataFromGlobal(setLoc)		
		 Do reportData.deptIncomeList.Insert(setLocData)
		}
	While(setLoc'="")
    
	Quit reportData
}

///  Creator：wang ying
///  CreatDate：2009-8-14
///  Description: 根据临时global的值，得到对应的字段
///  Table：
///  Input：telephoneFee:临时global的数据
///  Output：
///  Return：reportData对象
///  Others：
ClassMethod GetDataFromGlobal(setLoc) As dhc.ca.cache.udata.uDeptIncomeObj
{
	New (setLoc)
	Set setLoc=$G(setLoc)
	Set reportData = ##class(dhc.ca.cache.udata.uDeptIncomeObj).%New()
	Set reportData.fdept = $p(setLoc,"^",1)
	Set reportData.item = $p(setLoc,"^",2)
	Set reportData.tdept = $p(setLoc,"^",3)
	Set reportData.money = $p(setLoc,"^",4)

	Quit reportData
}

}

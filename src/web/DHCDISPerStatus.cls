Class web.DHCDISPerStatus Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Description: 科室
/// Creator:     zhaowuqiang
/// CreateDate:  2017-01-24  （改）
/// Table: 		 CT_LOC
/// Output:  	 所有科室描述（下拉框显示）
///              w ##class(web.DHCDISPerStatus).SelAllLoc() 
ClassMethod SelAllLoc() As %String
{
	S result = ##class(%Library.ResultSet).%New()
	S sqlStr = "SELECT CTLOC_ROWID as LocDr,CTLOC_DESC as LocDesc FROM CT_LOC"
    D result.Prepare(sqlStr)
	D result.Execute()
	S count = 0
	w "["
	While(result.Next())
	{	
		S LocDr = result.Data("LocDr")
		S LocDesc = result.Data("LocDesc")
		S tmp=LocDr_"^"_LocDesc
		S count = count+1
		I count=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	}
	W "]"
	q ""
}

/// Description: 查询配送人员状态
/// Creator:     赵武强
/// Table:
/// CreateDate:  2017-01-24  
/// Input:  	 StrParam : 以字符"^"分割,格式为:科室id^人员状态
/// Output:   	 报告描述^人员编码^人员姓名^启用状态^忙碌状态 
/// Others:		 w ##class(web.DHCDISPerStatus).QueryPersonStatus("30","1","") 
ClassMethod QueryPersonStatus(rows As %String, page As %String, StrParam As %String) As %String
{
	N (rows,page,StrParam)
	s count=0
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	w "{""rows"":["
	
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行
	s Locdr=$p(StrParam,"^",1)
	s Status=$p(StrParam,"^",2)
	s id=0
	f  s id=$o(^DHCDISLU(id)) Q:id=""  D
	.s userdr=$p(^DHCDISLU(id),"^",2)
	.q:userdr=""
	.s activeflag=$p(^DHCDISLU(id),"^",3)
	.s:activeflag="Y" activeflag="启用"
	.s:activeflag="N" activeflag="禁用"
	.s status=$p(^DHCDISLU(id),"^",4)
	.q:(Status'="")&&(status'=Status)
	.s:status=0 status="忙碌"
	.s:status=1 status="空闲"
	.s locdr=$p(^DHCDISLU(id),"^",1)
	.q:(Locdr'="")&&(Locdr'=locdr)
	.s locdesc=$p(^CTLOC(locdr),"^",2)
	.s userno=$p(^SSU("SSUSR",userdr),"^",1) //用户工号
	.s username=$p(^SSU("SSUSR",userdr),"^",2) //用户姓名
	.
	.S ListData=locdesc_"^"_userno_"^"_username_"^"_activeflag_"^"_status
	.s count=count+1
	.w $case(count,1:"",:",") 
	.w ##class(web.DHCAPPJsonCommon).getJsonData("LocDesc^StaNo^StaName^Enable^Status",ListData)
	w "],""total"":"_count_"}"
	
	Q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	K ^TMP("DHCDIS","web.DHCDISPerStatus",".QueryPersonStatus",pid)
	K ^TMP("DHCDIS","web.DHCDISPerStatus",".QueryPersonStatus",pid)
	K ^TMP("DHCDIS","web.DHCDISPerStatus",".QueryPersonStatus",pid)
	K ^TMP("DHCDIS","web.DHCDISPerStatus",".QueryPersonStatus",pid)
	K ^TMP("DHCDIS","web.DHCDISPerStatus",".QueryPersonStatus",pid)
	K ^TMP("DHCDIS","web.DHCDISPerStatus",".QueryPersonStatus",pid)
	K ^TMP("DHCDIS","web.DHCDISPerStatus",".QueryPersonStatus",pid)
}

}

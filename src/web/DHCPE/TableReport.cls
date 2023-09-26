Import SQLUser

/// 创建时间		：2008.04.03
/// 创建人		：xuwm
/// 存在系统		：体检系统
/// 关联数据		: 
/// 索引			: 
/// 主要功能		：套打报告-维护
/// 主要功能		：
/// 				项目站点为:	0	客户体检信息
/// 				项目站点为:	-1	表示标签未配置
/// 				特殊项目:项目编码大于9901,表示科室小结,诊断,审核人等特殊信息	
/// 最后修改时间	：
/// 最后修改人	：
/// 文件状态		: 未完成
/// 
Class web.DHCPE.TableReport Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 36;

/// 根据输入条件查找站点 涉及组件 DHCPEStation.List
/// d ##class(%ResultSet).RunQuery("web.DHCPE.TableReport","QueryTableReport","","")
Query QueryTableReport(ReportName As %Library.String = "", STDR As %Library.String = "", ARCIMDR As %Library.String = "") As %Query(ROWSPEC = "TR_RowID:%String, TR_TableReport:%String, TR_ST_DR:%String, TR_ST_Desc:%String, TR_OD_DR:%String, TR_OD_Desc:%String, TR_Label:%String, TR_Coordinate:%String")
{
}

ClassMethod QueryTableReportExecute(ByRef qHandle As %Binary, ReportName As %Library.String = "", STDR As %Library.String = "", ARCIMDR As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	s TableReport=""	
	f  s TableReport=$O(^DHCPETR(TableReport)) q:TableReport=""  d
	.
	.Q:(""'=ReportName)&(TableReport'[ReportName)
	.
 	.s id=0
	.f  s id=$O(^DHCPETR(TableReport, id)) q:id=""  d
	..
	..s CurData=$G(^DHCPETR(TableReport, id))
	..Q:(""=CurData)
	..s ODDR=$P(CurData,"^",1)
	..s STDesc=""
	..s ODDesc=""
	..s stid=$P(ODDR,"||",1)
	..Q:(""'=STDR)&(STDR'=stid)
	..s odsub=$P(ODDR,"||",2)
	..s Label=$P(CurData,"^",2)
	..s Coordinate=$P(CurData,"^",3)
	..
	..i (stid=0) d
	...s STDesc="客户信息"
	...s ODDesc=$G(^DHCPETRS("PatientInfo",odsub))
	...
	..
	..i (stid>0) d
	...s STDesc=$P($G(^DHCPEST(stid)),"^",2)
	...
	...s:(+odsub>0)&&(+odsub<9000) ODDesc=$P($G(^DHCPEST(stid, "OD", odsub)),"^",1) //正常项目指标
	...s:(+odsub>9000) ODDesc=$G(^DHCPETRS("Station",odsub)) // 特殊项目
	..
	..d FindBuild	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(id, TableReport, +ODDR, STDesc, ODDR, ODDesc, Label, Coordinate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryTableReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTableReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryTableReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTableReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 批量保存数据,处理模板文件时使用
/// d ##class(web.DHCPE.TableReport).BSave("","","cc^^bbb^18,11;cc^^ddd^19,6;cc^^ggg^20,6;")
ClassMethod BSave(itmjs As %Library.String = "", itmjsex As %Library.String = "", InStrings As %Library.String = "")
{
	s rets=""
	s ^DHCPETEMP("BSave")=InStrings
	F i=1:1:$l(InStrings,";") d
	.s line=$P(InStrings,";",i)
	.s ret=..Save(itmjs,itmjsex,line)
	.s:(""'=ret) res=rets_i_":"+ret_"\n"
	Q rets
}

/// 保存数据
/// d ##class(web.DHCPE.TableReport).Save("","","ddd^^ytyy^1,2")
ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s id=$P(InString,"^",2)
	i ""=id d
	.s ret=..Insert(itmjs,itmjsex,InString)
	e  d
	.s ret=..Update(itmjs,itmjsex,InString)
	
	Q ret
}

/// 保存数据
/// d ##class(web.DHCPE.TableReport).Save("","","ddd^^ytyy^1,2")
ClassMethod Insert(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s Report=$P(InString,"^",1)
	Q:(""=Report) "错误:报告为空"
	s ODDR=$P(InString,"^",3)
	s:(""=ODDR) ODDR="-1||"
	s Label=$P(InString,"^",4)
	Q:(""=Label) "错误:标签为空"
	s Coordinate=$P(InString,"^",5)
	
	s ^DHCPETR(Report)=1+$G(^DHCPETR(Report))
	s RowId=^DHCPETR(Report)
	s:("-1||"=ODDR) ODDR="-1||"_RowId
	s ^DHCPETR(Report,RowId)=ODDR_"^"_Label_"^"_Coordinate
	s ^DHCPETR(Report,0,"OD",ODDR,Coordinate,Label)=RowId			// 项目索引
	s ^DHCPETR(Report,0,"Label", Label, Coordinate)=RowId		// 标签索引
	s ^DHCPETR(Report,0,"Coordinate", $P(Coordinate,",",1), $P(Coordinate,",",2), RowId)=Label	//按位置索引
	Q ""
}

/// 保存数据
/// d ##class(web.DHCPE.TableReport).Save("","","cc^1^2||1^姓名^1,2")
ClassMethod Update(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s Report=$P(InString,"^",1)
	s RowId=$P(InString,"^",2)
	s PLIST=$G(^DHCPETR(Report,RowId))
	Q:(""=PLIST) "错误:记录不存在"
	
	s ODDR=$P(InString,"^",3)
	//s:(0=+ODDR) ODDR="-1||"_RowId
		
	i ($P(PLIST,"^",1)'=ODDR) d
	.s $P(^DHCPETR(Report,RowId),"^",1)=ODDR
	.k ^DHCPETR(Report,0,"OD",$P(PLIST,"^",1))
	.s ^DHCPETR(Report,0,"OD",ODDR,$P(PLIST,"^",3),$P(PLIST,"^",2))=RowId			// 项目索引
	Q ""
}

/// 保存数据
/// d ##class(web.DHCPE.TableReport).Save("","","ddd^^ytyy^1,2")
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s Dtype=$P(InString,"^",1)
	s ReportName=$P(InString,"^",2)
	s ID=$P(InString,"^",3)
	
	// 删除报告 Report
	i "R"=Dtype d
	.k ^DHCPETR(ReportName)
	
	// Item
	i "I"=Dtype d
	.

	Q ""
}

/// 输出站点列表到HTML页面
/// d ##Class(web.DHCPE.TableReport).OutStationToHTML("")
ClassMethod OutStationToHTML(CName As %String = "", ID As %String = "", ContrlWidth As %String = "") As %String
{
	//站点下拉列表
	w:(""=CName) "<input id='TR_ST_Activez"_cnt_"' name='TR_ST_Activez"_cnt_"' type='checkbox'/>"
					_"&nbsp;&nbsp;&nbsp;"
					_"<select name=TR_ST_Descz"_cnt_" id=TR_ST_Descz"_cnt_" HEIGHT=0 onclick='Tabel_STDesc_click(this,"_cnt_");'>",!
	w:(""'=CName) "<select name="_CName_" id="_CName_" style='width:"_ContrlWidth_"' HEIGHT=0>",!
	i (-1=ID) d
	.w "<option value=-1 selected>  </option>",!
	e  d
	.w "<option value=-1>  </option>",!
	
	i 0=+ID d
	.w "<option value=0 selected>个人信息</option>",!
	e  d
	.w "<option value=0>个人信息</option>",!
	
	s STDR=0 
	f  s STDR=$o(^DHCPEST(STDR)) Q:(""=STDR)  d
	.i STDR=+ID d
	..w "<option value="_STDR_" selected>"_$p($g(^DHCPEST(STDR)), "^", 2)_"</option>",!
	.e  d
	..w "<option value="_STDR_">"_$p($g(^DHCPEST(STDR)), "^", 2)_"</option>",!
	
	w "</select>",!
	Quit $$$OK
	w "<label id=""T1z"_cnt_""" name=""T1z"_cnt_""">"_$s(ID'="":ID,1:"&nbsp;")_"</label>" 
	Quit $$$OK
}

/// 输出站点列表到HTML页面
/// d ##Class(web.DHCPE.TableReport).OutStationToHTML("")
ClassMethod OutODDetailToHTML(value As %String = "") As %String
{
	
	//项目列表 
	w "<A onclick='TableODDesc_lookuphandler("_cnt_");'>"
		//_"<IMG id=ldTR_OD_Descz"_cnt_" name=TR_OD_Descz"_cnt_" src='../images/websys/lookup.gif'/>"
		_"<IMG src='../images/websys/lookup.gif'/>"
		_"</A>"
	w "<label id=TR_OD_Descz"_cnt_" name=TR_OD_Descz"_cnt_">"_value_"</label>"
	Quit $$$OK
}

/// 输出站点列表到HTML页面
/// d ##Class(web.DHCPE.TableReport).OutStationToHTML("")
ClassMethod OutBtnUpdateToHTML() As %String
{
	// 更新按钮
	w "<A id=TR_Updatez"_cnt_" name=TR_Updatez"_cnt_" onclick='Table_Update("_cnt_");'>"
		_"<label id=TR_IsUpdatez"_cnt_" name=TR_IsUpdatez"_cnt_">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>"
		_"<IMG src='../images/websys/edit.gif' border=0></A>"
		
	Quit $$$OK
}

/// 查询　患者列表
/// d ##class(%ResultSet).RunQuery("web.DHCPE.TableReport","QueryOrderDetail","2")
Query QueryOrderDetail(STDR As %String = "") As %Query(ROWSPEC = "站点编码:%String, 站点名称:%String, 项目编码:%String, 项目名称:%String")
{
}

ClassMethod QueryOrderDetailExecute(ByRef qHandle As %Binary, STDR As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0
	s stid=0
	
	i ((-1=+STDR)||(0=+STDR)) d
	.s stid=0
	.s stdesc="客户信息"
	.s odsub=""
	.f  s odsub=$O(^DHCPETRS("PatientInfo",odsub)) Q:(""=odsub)  d
	..s oddesc=^DHCPETRS("PatientInfo",odsub)
	..d QueryOrderDetailOut
	
	i (+STDR>0)||(-1=STDR) d
	.s stid=0
	.s:(-1'=STDR) stid=$o(^DHCPEST(STDR),-1)
	.
	.f  s stid=$o(^DHCPEST(stid)) Q:(""=stid)||((-1'=STDR)&&(STDR'=stid))  d
	..s stdesc=$P($g(^DHCPEST(stid)),"^",2)
	..s odsub=0
	..f  s odsub=$o(^DHCPEST(stid,"OD",odsub)) Q:(""=odsub)  d
	...s oddesc=$P($G(^DHCPEST(stid,"OD",odsub)),"^",1)
	...d QueryOrderDetailOut
	...
	..// 特殊项目 
	..f odsub=9901:1:9999  d
	...s oddesc=$G(^DHCPETRS("Station",odsub)) // 特殊项目
    ...Q:(""=oddesc)
    ...d QueryOrderDetailOut
    ..
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryOrderDetailOut
	set Data=$lb(stid, stdesc, stid_"||"_odsub, oddesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryOrderDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryOrderDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 套打报告配置参数
/// d ##class(web.DHCPE.TableReport).TableReportSetting()
ClassMethod TableReportSetting()
{
	s ^DHCPETRS="套打报告配置参数"
	// 客户	基本信息
	s ^DHCPETRS("PatientInfo","AdmDate")="体检日期"
	s ^DHCPETRS("PatientInfo","PatRegNo")="登记号"
	s ^DHCPETRS("PatientInfo","PatName")="姓名"
	s ^DHCPETRS("PatientInfo","Patsex")="性别"
	s ^DHCPETRS("PatientInfo","PatBirthday")="出生日期"
	s ^DHCPETRS("PatientInfo","PatAge")="年龄"
	s ^DHCPETRS("PatientInfo","PatType")="客户类型"
	s ^DHCPETRS("PatientInfo","PatTel1")="电话1"
	s ^DHCPETRS("PatientInfo","PatTel2")="电话2"		
	s ^DHCPETRS("PatientInfo","MobilePhone")="手机"
	s ^DHCPETRS("PatientInfo","PatID")="身份证号"
	s ^DHCPETRS("PatientInfo","Vocation")="职业"
	s ^DHCPETRS("PatientInfo","Position")="职位"
	s ^DHCPETRS("PatientInfo","PatCompany")="工作单位"
	s ^DHCPETRS("PatientInfo","Postalcode")="邮编"
	s ^DHCPETRS("PatientInfo","PatAddress")="地址"
	s ^DHCPETRS("PatientInfo","Nation")="民族"
	s ^DHCPETRS("PatientInfo","Email")="电子邮件"
	s ^DHCPETRS("PatientInfo","Married")="婚姻状况"	
	s ^DHCPETRS("PatientInfo","Blood")="血型"
	// 客户	体检信息
	s ^DHCPETRS("PatientInfo","GeneralAdviceDetail")="总检建议"
	s ^DHCPETRS("PatientInfo","GeneralSummarize")="总检结论"
	s ^DHCPETRS("PatientInfo","AduitUser")="总检医师"
	s ^DHCPETRS("PatientInfo","AduitDate")="总检日期"
	s ^DHCPETRS("PatientInfo","PELoc")="体检中心名称"
	s ^DHCPETRS("PatientInfo","Illness")="疾病"
	// 站点特殊项目
	s ^DHCPETRS("Station",9901)="审核人"
	s ^DHCPETRS("Station",9902)="审核日期"
	s ^DHCPETRS("Station",9903)="科室小结"
	s ^DHCPETRS("Station",9904)="科室诊断"
}

}

//===========================================================================================
// 作者：      yangyongtao
// 编写日期:   2020-08-06
// 描述:	   mdt会诊数据统计
//===========================================================================================
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化病人基本信息
	InitPatInfoPanel();
	
	/// 初始化加载病人列表
	InitPatList();
}

/// 初始化病人基本信息
function InitPatInfoPanel(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-7));
	
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
}

/// 页面DataGrid初始定义已选列表
function InitPatList(){
	///  定义columns
	var columns=[[
	    {field:'CstRDate',title:'时间',width:120},
	    {field:'PatName',title:'患者姓名',width:100},
	    {field:'PatNo',title:'ID号',width:100},
	    {field:'PatSex',title:'性别',width:60},
		{field:'PatAge',title:'年龄',width:60},
		{field:'DisGrpID',title:'DisGrpID',width:100,hidden:true},
		{field:'DisGroup',title:'会诊团队',width:140},
		{field:'CstUser',title:'会诊教授',width:100,hidden:true},
		{field:'AdmType',title:'患者来源',width:100},
		{field:'PatLoc',title:'患者科室来源',width:140},
		{field:'AdmDoctor',title:'经治医生',width:100},
		{field:'itmCost',title:'会诊诊金',width:100},
		//{field:'CstUser',title:'合伙人次',width:100},
		{field:'CstNTime',title:'开始时间',width:150},
		{field:'CstCTime',title:'结束时间',width:150},
		{field:'ID',title:'ID',width:100},
		{field:'pid',title:'pid',width:100,hidden:true},
		
	]];
	
	///  定义datagrid
	var option = {
		rownumbers : true,
		singleSelect : true,
		pagination: true
	};
	/// 就诊类型
	var params = getParams()
	var uniturl = $URL+"?ClassName=web.DHCMDTStatistics&MethodName=JsGetMdtData&Params="+params+"&LgParam="+LgParam+"&MWToken="+websys_getMWToken();
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 查询
function QryPatList(){
	var params = getParams()
	$("#bmDetList").datagrid("load",{"Params":params,"LgParam":LgParam}); 
}

function getParams(){
	var params="";
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	params = StartDate +"^"+ EndDate 
	return params;	
}

/// 获取系统当前日期
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCMDTCom","GetCurSysTime",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

//导出
function Export(){
	var datas = $('#bmDetList').datagrid("getData");
	var pid=datas.rows[0].pid
	runClassMethod("web.DHCMDTStatistics","JsonExportData",{"LgUserID":LgUserID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != ""){
           ExportData(jsonObject)
		}
	},'json',false)	

}

function ExportData(datas){
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var str ='(function test(x){'
	+'\n'+'var xlApp = new ActiveXObject("Excel.Application");'
	+'\n'+'var xlBook = xlApp.Workbooks.Add("");'
	+'\n'+'var objSheet = xlBook.ActiveSheet;'
	+'\n'+'xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,14)).MergeCells = true;'
	+'\n'+'xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,14)).Font.Bold = true;'
	+'\n'+'objSheet.cells(1,1).Font.Bold = true;'
	+'\n'+'objSheet.cells(1,1).Font.Size =24;'
	+'\n'+'objSheet.cells(1,1).HorizontalAlignment = -4108;'
	+'\n'+'objSheet.Columns(1).NumberFormatLocal="@";'
	+'\n'+'objSheet.Columns(3).NumberFormatLocal="@";'
	+'\n'+'objSheet.Columns(13).NumberFormatLocal="@";'
	+'\n'+'objSheet.Columns(14).NumberFormatLocal="@";'
	+'\n'+'objSheet.Cells(1,1).value="统计时间:'+StartDate+'至'+EndDate+'";'
	var beginRow=2;	
	for (var i=0;i<datas.length;i++){
		str=str
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',1).value="'+datas[i].CstRDate+'";'      			//时间
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',2).value="'+datas[i].PatName+'";' 	 			//患者姓名
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',3).value="'+datas[i].PatNo+'";' 					//ID号
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',4).value="'+datas[i].PatSex+'";' 				//性别
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',5).value="'+datas[i].PatAge+'";' 	 			//年龄
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',6).value="'+datas[i].DisGroup+'";' 	 			//会诊团队
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',7).value="'+datas[i].CstUser+'";' 	 			//会诊教授	
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',8).value="'+datas[i].AdmType+'";' 	 			//患者来源	
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',9).value="'+datas[i].PatLoc+'";' 	 			//患者科室来源	
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',10).value="'+datas[i].AdmDoctor+'";' 	 		//经治医生	
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',11).value="'+datas[i].itmCost+'";' 	 			//会诊诊金	
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',12).value="";' 									//合伙人次	
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',13).value="'+datas[i].CstNTime+'";' 	 			//开始时间	
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',14).value="'+datas[i].CstCTime+'";'  			//结束时间	
		
	}
	str=str
	+'\n'+'objSheet.Cells('+beginRow+',1).value="时间";' 	     		//时间
	+'\n'+'objSheet.Cells('+beginRow+',2).value="患者姓名";'	 		//患者姓名
	+'\n'+'objSheet.Cells('+beginRow+',3).value="ID号";'	     		//ID号
	+'\n'+'objSheet.Cells('+beginRow+',4).value="性别";'	     		//性别
	+'\n'+'objSheet.Cells('+beginRow+',5).value="年龄";'	     		//年龄
	+'\n'+'objSheet.Cells('+beginRow+',6).value="会诊团队";'	 		//会诊团队
	+'\n'+'objSheet.Cells('+beginRow+',7).value="会诊教授";'	 		//会诊教授
	+'\n'+'objSheet.Cells('+beginRow+',8).value="患者来源";'	     	//患者来源
	+'\n'+'objSheet.Cells('+beginRow+',9).value="患者科室来源";'	 	//患者科室来源
	+'\n'+'objSheet.Cells('+beginRow+',10).value="经治医生";'	 		//经治医生
	+'\n'+'objSheet.Cells('+beginRow+',11).value="会诊诊金";'	 		//会诊诊金
	+'\n'+'objSheet.Cells('+beginRow+',12).value="合伙人次";'	 		//合伙人次
	+'\n'+'objSheet.Cells('+beginRow+',13).value="开始时间";'	 		//开始时间
	+'\n'+'objSheet.Cells('+beginRow+',14).value="结束时间";'	 		//结束时间
	
	var row1=beginRow,row2=datas.length+beginRow,c1=1,c2=14
	str=str
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(1).LineStyle=1;'
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(1).Weight=2;'
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(2).LineStyle=1;'
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(2).Weight=2;'
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(3).LineStyle=1;'
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(3).Weight=2;'
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(4).LineStyle=1;'
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(4).Weight=2;'
	+'\n'+'xlApp.Visible=true;'
	+'\n'+'objSheet.Columns.AutoFit;'   //自适应
	+'\n'+'xlApp=null;'
	+'\n'+'xlBook=null;'
	+'\n'+'objSheet=null;'	
	+'\n'+'return 1;}());'
	CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	var obj = CmdShell.EvalJs(str);
	return;
	
}

function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=2
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })

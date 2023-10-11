//===========================================================================================
// 作者：      yangyongtao
// 编写日期:   2020-08-17
// 描述:	   mdt各组会诊质控统计
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
	
	/// 疑难病种
	$HUI.combobox("#mdtDisGrp",{
		//url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+LgHospID,
		url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+LgHospID+"&MWToken="+websys_getMWToken(),
		valueField:'value',
		textField:'text',
		onSelect:function(option){

	    }	
	})
	
}

/// 页面DataGrid初始定义已选列表
function InitPatList(){
	///  定义columns
	var columns=[[
	    {field:'DisGroup',title:'MDT组',width:120},
	    {field:'GrpNum',title:'诊疗量',width:80},
	    //{field:'OneNum',title:'占比',width:80},
	    //{field:'OneNum',title:'初诊病例数',width:120},
		//{field:'OneGdp',title:'占比',width:80},
		{field:'OneNum',title:'早期病例数',width:100},
		{field:'OneGdp',title:'占比',width:80},
		{field:'TwoNum',title:'局部晚期病例数',width:120},
		{field:'TwoGdp',title:'占比',width:80},
		{field:'ThreeNum',title:'晚期病例数',width:100},
		{field:'ThreeGdp',title:'占比',width:80}
	
		
	]];
	
	///  定义datagrid
	var option = {
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		fitColumns:true
	};
	/// 就诊类型
	var params = getParams()
	var uniturl = $URL+"?ClassName=web.DHCMDTStatistics&MethodName=JsGetControlStat&Params="+params+"&MWToken="+websys_getMWToken();
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 查询
function QryPatList(){
	var params = getParams()
	$("#bmDetList").datagrid("load",{"Params":params}); 
}

function getParams(){
	var params="";
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue()||"";  /// 疑难病种
	params = StartDate +"^"+ EndDate +"^"+ mdtDisGrp
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
	ExportData(datas.rows);
}


function ExportData(datas){
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var str ='(function test(x){'
	+'\n'+'var xlApp = new ActiveXObject("Excel.Application");'
	+'\n'+'var xlBook = xlApp.Workbooks.Add("");'
	+'\n'+'var objSheet = xlBook.ActiveSheet;'
	+'\n'+'xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,8)).MergeCells = true;'
	+'\n'+'xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,8)).Font.Bold = true;'
	+'\n'+'objSheet.cells(1,1).Font.Bold = true;'
	+'\n'+'objSheet.cells(1,1).Font.Size =24;'
	+'\n'+'objSheet.cells(1,1).HorizontalAlignment = -4108;'
	+'\n'+'objSheet.Columns(3).NumberFormatLocal="@";'
	+'\n'+'objSheet.Cells(1,1).value="统计时间:'+StartDate+'至'+EndDate+'";'
	var beginRow=2;	
	for (var i=0;i<datas.length;i++){
		str=str
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',1).value="'+datas[i].DisGroup+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',2).value="'+datas[i].GrpNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',3).value="'+datas[i].OneNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',4).value="'+datas[i].OneGdp+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',5).value="'+datas[i].TwoNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',6).value="'+datas[i].TwoGdp+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',7).value="'+datas[i].ThreeNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',8).value="'+datas[i].ThreeGdp+'";'	
	}
	str=str
	+'\n'+'objSheet.Cells('+beginRow+',1).value="MDT组";'
	+'\n'+'objSheet.Cells('+beginRow+',2).value="诊疗量";'
	+'\n'+'objSheet.Cells('+beginRow+',3).value="早期病例数";'
	+'\n'+'objSheet.Cells('+beginRow+',4).value="占比";'
	+'\n'+'objSheet.Cells('+beginRow+',5).value="局部晚期病例数";'
	+'\n'+'objSheet.Cells('+beginRow+',6).value="占比";'
	+'\n'+'objSheet.Cells('+beginRow+',7).value="晚期病例数";'
	+'\n'+'objSheet.Cells('+beginRow+',8).value="占比";'

	
	var row1=beginRow,row2=datas.length+beginRow,c1=1,c2=8
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

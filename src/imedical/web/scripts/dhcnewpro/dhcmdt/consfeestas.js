//===========================================================================================
// 作者：      yangyongtao
// 编写日期:   2020-08-13
// 描述:	   mdt各组会诊费用统计
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
	var strArr=GetCurSystemDate(0).split("-")
	var yearArr = [];//创建年度数组
    for(year= parseInt(strArr[0])-10;year<=parseInt(strArr[0]);year++)
	{
		 yearArr.push({"value":year,text:year});
	}
	
	/// 年份
	$HUI.combobox("#Year",{
		url:'',
		data : yearArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	$HUI.combobox("#Year").setValue(strArr[0]);
	
	
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
		{field:'DisGrpID',title:'DisGrpID',width:100,hidden:true},
		{field:'DisGroup',title:'会诊团队',width:140,formatter:function(value){
			if(value==="合计"){
				return $g(value);
			}else{
				return value;
			}
		}},
		{field:'OneMonNum',title:'1月',width:80},
		{field:'TwoMonNum',title:'2月',width:80},
		{field:'ThreeMonNum',title:'3月',width:80},
		{field:'FourMonNum',title:'4月',width:80},
		{field:'FiveMonNum',title:'5月',width:80},
		{field:'SixMonNum',title:'6月',width:80},
		{field:'SevenMonNum',title:'7月',width:80},
		{field:'EightMonNum',title:'8月',width:80},
		{field:'NineMonNum',title:'9月',width:80},
		{field:'TenMonNum',title:'10月',width:80},
		{field:'ElevenMonNum',title:'11月',width:80},
		{field:'TwelveMonNum',title:'12月',width:80},
		{field:'TotleNum',title:'合计',width:80},
		
	]];
	var Year = $HUI.combobox("#Year").getValue(); 
	///  定义datagrid
	var option = {
		//title:Year+'年MDT各组会诊总量',
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		fitColumns:true
	};
	/// 就诊类型
	var params = getParams()
	var uniturl = $URL+"?ClassName=web.DHCMDTStatistics&MethodName=JsGetGrpFeeStat&Params="+params+"&MWToken="+websys_getMWToken();
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 查询
function QryPatList(){
	var params = getParams()
	$("#bmDetList").datagrid("load",{"Params":params}); 
}

function getParams(){
	var params="";
	var Year = $HUI.combobox("#Year").getValue()||"";            /// 年份
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue()||"";  /// 疑难病种
	params = Year+"^"+mdtDisGrp 
	return params;	
}

/// 获取系统当前日期
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCMDTCom","GetNowSysFixedDate",{"offset":offset},function(jsonString){
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
	
	
	var Year = $HUI.combobox("#Year").getValue()||"";            /// 年份
	var str ='(function test(x){'
	+'\n'+'var xlApp = new ActiveXObject("Excel.Application");'
	+'\n'+'var xlBook = xlApp.Workbooks.Add("");'
	+'\n'+'var objSheet = xlBook.ActiveSheet;'
	+'\n'+'xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,14)).MergeCells = true;'
	+'\n'+'xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,14)).Font.Bold = true;'
	+'\n'+'objSheet.cells(1,1).Font.Bold = true;'
	+'\n'+'objSheet.cells(1,1).Font.Size =24;'
	+'\n'+'objSheet.cells(1,1).HorizontalAlignment = -4108;'
	+'\n'+'objSheet.Columns(3).NumberFormatLocal="@";'
	+'\n'+'objSheet.Cells(1,1).value="'+Year+'年各组会诊费用统计";'
	var beginRow=2;	
	for (var i=0;i<datas.length;i++){
		str=str
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',1).value="'+datas[i].DisGroup+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',2).value="'+datas[i].OneMonNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',3).value="'+datas[i].TwoMonNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',4).value="'+datas[i].ThreeMonNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',5).value="'+datas[i].FourMonNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',6).value="'+datas[i].FiveMonNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',7).value="'+datas[i].SixMonNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',8).value="'+datas[i].SevenMonNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',9).value="'+datas[i].EightMonNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',10).value="'+datas[i].NineMonNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',11).value="'+datas[i].TenMonNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',12).value="'+datas[i].ElevenMonNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',13).value="'+datas[i].TwelveMonNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',14).value="'+datas[i].TotleNum+'";'
	}
	str=str
	+'\n'+'objSheet.Cells('+beginRow+',1).value="会诊团队";'
	+'\n'+'objSheet.Cells('+beginRow+',2).value="1月";'
	+'\n'+'objSheet.Cells('+beginRow+',3).value="2月";'
	+'\n'+'objSheet.Cells('+beginRow+',4).value="3月";'
	+'\n'+'objSheet.Cells('+beginRow+',5).value="4月";'
	+'\n'+'objSheet.Cells('+beginRow+',6).value="5月";'
	+'\n'+'objSheet.Cells('+beginRow+',7).value="6月";'
	+'\n'+'objSheet.Cells('+beginRow+',8).value="7月";'
	+'\n'+'objSheet.Cells('+beginRow+',9).value="8月";'
	+'\n'+'objSheet.Cells('+beginRow+',10).value="9月";'
	+'\n'+'objSheet.Cells('+beginRow+',11).value="10月";'
	+'\n'+'objSheet.Cells('+beginRow+',12).value="11月";'
	+'\n'+'objSheet.Cells('+beginRow+',13).value="12月";'
	+'\n'+'objSheet.Cells('+beginRow+',14).value="合计";'

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

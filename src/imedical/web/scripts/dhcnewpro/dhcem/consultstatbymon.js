var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var CstOutFlagarr = [{ "value": "Y", "text": $g("是") },{ "value": "N", "text": $g("否") }];
/// 页面初始化函数
function initPageDefault(){
	
	InitForm();      /// 初始化表单信息
	InitDataGrid(); /// 初始化表格
}

/// 初始化表单信息
function InitForm(){
	var myDate = new Date();
	var myYear=myDate.getFullYear();
	var yearArr = [];//创建年度数组
    for(year=parseInt(myYear)-9;year<=parseInt(myYear);year++)
	{
		yearArr.push({"value":year,"text":year});
	}
	/// 年份
	$HUI.combobox("#Year",{
		data : yearArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	$HUI.combobox("#Year").setValue(myYear);
	
	///科室
	$HUI.combobox("#Loc",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
		valueField: "value", 
		textField: "text",
		
	})
	$HUI.combobox("#Loc").setValue(session['LOGON.CTLOCID']); //默认当前登录科室
	
	///是否院外
	$HUI.combobox("#CstOutFlag",{
		valueField: "value", 
		textField: "text",
		data:CstOutFlagarr
	})
	
	///类型
	$HUI.combobox("#Type",{
		valueField: "value", 
		textField: "text",
		editable:false,
		data:[
			{"value":"R","text":$g("按照申请科室")},
			{"value":"C","text":$g("按照接收科室")}
		]
	})
	$HUI.combobox("#Type").setValue("R"); 
	
}

/// 页面DataGrid初始定义
function InitDataGrid(){
	
	/// 定义columns
	var columns=[[
		{field:'CstRLoc',title:'科室',width:140},
		{field:'OneMonNum',title:'1月',width:80,formatter:formNumberOne},
		{field:'TwoMonNum',title:'2月',width:80,formatter:formNumberTwo},
		{field:'ThreeMonNum',title:'3月',width:80,formatter:formNumberThree},
		{field:'FourMonNum',title:'4月',width:80,formatter:formNumberFour},
		{field:'FiveMonNum',title:'5月',width:80,formatter:formNumberFive},
		{field:'SixMonNum',title:'6月',width:80,formatter:formNumberSix},
		{field:'SevenMonNum',title:'7月',width:80,formatter:formNumberSeven},
		{field:'EightMonNum',title:'8月',width:80,formatter:formNumberEight},
		{field:'NineMonNum',title:'9月',width:80,formatter:formNumberNine},
		{field:'TenMonNum',title:'10月',width:80,formatter:formNumberTen},
		{field:'ElevenMonNum',title:'11月',width:80,formatter:formNumberEleven},
		{field:'TwelveMonNum',title:'12月',width:80,formatter:formNumberTwelve},
		{field:'TotleNum',title:'合计',width:80},
		
	]];
	/// 定义datagrid
	var option = {
		fit: true,
		border:true,
		title:"会诊统计按月",
		toolbar:"#toolbar",
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		rownumbers : true,
		singleSelect : true,
		fitColumns:true,
		pagination: true
	};
	/// 就诊类型
	var params = getParams();
	var uniturl = $URL+"?ClassName=web.DHCEMConsultStatisQuery&MethodName=GetDataByMon&Params="+params;
	new ListComponent('Table', columns, uniturl, option).Init(); 
	
	/// 明细表
	var columns=[[ ///  定义columns
		{field:'Loc',title:'科室',width:140},
		{field:'Num',title:'数量',width:100,formatter:formNumber},	
	]];
	///  定义datagrid
	var option = {
		toolbar: [],
		title:'明细',
		border:true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		rownumbers : true,
		singleSelect : true,
		fitColumns:true,
		pagination: true
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCEMConsultStatisQuery&MethodName=GetDetail&Params=";
	new ListComponent('Detail', columns, uniturl, option).Init(); 
	
	/// 患者明细表
	///  定义columns
	var columns=[[ 
		{field:'PatNo',title:'患者登记号',width:140},
		{field:'PatName',title:'姓名',width:120},
		{field:'CstRDate',title:'申请日期',width:120},
		{field:'CstRUser',title:'申请医师',width:120},
		{field:'CstCDate',title:'会诊日期',width:120},
		{field:'CstUser',title:'会诊医师',width:120},
		{field:'Opinion',title:'会诊完成结论',width:520}		
	]];
	var option = {
		toolbar: [],
		title:'患者明细',
		border:true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			BindTips(); /// 绑定提示消息
		}
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCEMConsultStatisQuery&MethodName=GetPatDetail&Params=";
	new ListComponent('PatDetail', columns, uniturl, option).Init(); 
}

/// 查询
function QryList(){
	var params = getParams();
	$("#Table").datagrid("load",{"Params":params});
	$HUI.datagrid("#Detail").load({"Params":""});
	$HUI.datagrid("#PatDetail").load({"Params":""});
}

function getParams(){
	var params="";
	var SeYear = $HUI.combobox("#Year").getValue()||""; //年份
	var SeLocID = $HUI.combobox("#Loc").getValue()==undefined?"":$HUI.combobox("#Loc").getValue(); //科室
	var SeOutflag = $HUI.combobox("#CstOutFlag").getValue()==undefined?"":$HUI.combobox("#CstOutFlag").getValue(); //是否院外申请
	var SeType = $HUI.combobox("#Type").getValue()==undefined?"":$HUI.combobox("#Type").getValue(); // 类型
	if(SeYear==""){
		$.messager.alert("提示","请选择年份！");
		return;	
	}
	if(SeType==""){
		$.messager.alert("提示","请选择类型！");
		return;	
	}
	params = LgUserID+"^"+SeYear+"^"+SeLocID+"^"+SeOutflag+"^"+SeType+"^"+LgHospID;
	return params;	
}

function formNumber(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowPatDetail(\''+rowData.ItmStr+'\')">&nbsp;'+value+'&nbsp;</a>';
}

function formNumberOne(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.OneMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberTwo(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.TwoMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberThree(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.ThreeMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberFour(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.FourMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberFive(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.FiveMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberSix(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.SixMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberSeven(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.SevenMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberEight(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.EightMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberNine(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.NineMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberTen(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.TenMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberEleven(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.ElevenMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberTwelve(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.TwelveMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function ShowDetail(value){
	var staType = $HUI.combobox("#Type").getValue()==undefined?"":$HUI.combobox("#Type").getValue();   /// 类型
	$HUI.datagrid("#Detail").load({"Params":value+"^"+staType});
	$HUI.datagrid("#PatDetail").load({"Params":""});
}
function ShowPatDetail(value){
	$HUI.datagrid("#PatDetail").load({"Params":value});
}
//导出
function Export(){
	var datas = $('#Table').datagrid("getData");
	ExportData(datas.rows);
}

function ExportData(datas){
    var Year = $HUI.combobox("#Year").getValue()||"";            /// 年份
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add("");
	var objSheet = xlBook.ActiveSheet;
	
	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,14)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,14)).Font.Bold = true; //设置为粗体
	objSheet.Cells(1,1).value= Year+"年科室会诊总量统计"
	var beginRow=2;	
	for (var i=0;i<datas.length;i++){

		objSheet.Cells(i+beginRow+1,1).value=datas[i].CstRLoc;       //会诊团队
		objSheet.Cells(i+beginRow+1,2).value=datas[i].OneMonNum;	 //1月
		objSheet.Cells(i+beginRow+1,3).value=datas[i].TwoMonNum;	 //2月
		objSheet.Cells(i+beginRow+1,4).value=datas[i].ThreeMonNum;	 //3月
		objSheet.Cells(i+beginRow+1,5).value=datas[i].FourMonNum;	 //4月
		objSheet.Cells(i+beginRow+1,6).value=datas[i].FiveMonNum;	 //5月
		objSheet.Cells(i+beginRow+1,7).value=datas[i].SixMonNum;	 //6月	
		objSheet.Cells(i+beginRow+1,8).value=datas[i].SevenMonNum;	 //7月	
		objSheet.Cells(i+beginRow+1,9).value=datas[i].EightMonNum;	 //8月	
		objSheet.Cells(i+beginRow+1,10).value=datas[i].NineMonNum;	 //9月	
		objSheet.Cells(i+beginRow+1,11).value=datas[i].TenMonNum;	 //10月	
		objSheet.Cells(i+beginRow+1,12).value=datas[i].ElevenMonNum; //11月	
		objSheet.Cells(i+beginRow+1,13).value=datas[i].TwelveMonNum; //12月
		objSheet.Cells(i+beginRow+1,14).value=datas[i].TotleNum;	 //合计		
	}

	objSheet.Cells(beginRow,1).value="科室"; 	     	    //科室
	objSheet.Cells(beginRow,2).value="1月";	 			 	//1月
	objSheet.Cells(beginRow,3).value="2月";	     		 	//2月
	objSheet.Cells(beginRow,4).value="3月";	     			//3月
	objSheet.Cells(beginRow,5).value="4月";	     			//4月
	objSheet.Cells(beginRow,6).value="5月";	 				//5月
	objSheet.Cells(beginRow,7).value="6月";	 				//6月	
	objSheet.Cells(beginRow,8).value="7月";	     			//7月
	objSheet.Cells(beginRow,9).value="8月";	 				//8月
	objSheet.Cells(beginRow,10).value="9月";	 			//9月	
	objSheet.Cells(beginRow,11).value="10月";	 			//10月	
	objSheet.Cells(beginRow,12).value="11月";	 			//11月	
	objSheet.Cells(beginRow,13).value="12月";	 			//12月	
	objSheet.Cells(beginRow,14).value="合计";	 			//合计	
	
	gridlist(objSheet,beginRow,datas.length+beginRow,1,14)
	xlApp.Visible=true;
	objSheet.Columns.AutoFit;   //自适应
	xlApp=null;
	xlBook=null;
	objSheet=null;	
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

/// 绑定提示栏
function BindTips(){
	
	var html='<div id="tip" style="word-break:break-all;border-radius:3px; display:none; border:1px solid #000; padding:10px; margin:5px; position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	
	/// 鼠标离开
	$('td[field="Opinion"]').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// 鼠标移动
	$('td[field="Opinion"]').on({
		'mousemove':function(){
			var tleft=(event.clientX + 10);
			if ($(this).text().length <= 20){
				return;
			}
			if ( window.screen.availWidth - tleft < 600){ tleft = tleft - 600;}
			/// tip 提示框位置和内容设定
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 0.8
			}).text($(this).text());
		}
	})
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })

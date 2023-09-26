/// Creator: bianshuai
/// CreateDate: 2014-10-29
//  Descript: 药品质量事件上报

var HospID = session['LOGON.HOSPID'];
var url="dhcpha.clinical.action.csp";
var statArray = [{ "val": "Y", "text": "提交" }, { "val": "N", "text": "未提交" }];
$(function(){

	$("#stdate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
	
	//科室
	$('#dept').combobox({
		mode:'remote',
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			//$('#dept').combobox('reload',url+'?action=SelAllLoc&HospID='+HospID)
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+HospID+'  ')
		}
	}); 

	//病区
	$('#ward').combobox({
		mode:'remote',
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			//$('#ward').combobox('reload',url+'?action=SelAllLoc')
			$('#ward').combobox('reload',url+'?action=GetAllWardNewVersion')

		}
	});
	
	//状态
	$('#status').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:statArray 
	});
	$('#status').combobox('setValue',"N"); //设置combobox默认值
	
	$('#Find').bind("click",Query); //点击查询
	$("a:contains('浏览')").bind("click",repview); //点击查看
	$('a:contains("导出")').bind("click",Export);  //导出
	
	InitPatList(); //报告列表
        Query();
	
	//登记号回车事件
	$('#patno').bind('keypress',function(event){
	 if(event.keyCode == "13"){
		 var patno=$.trim($("#patno").val());
		 if (patno!=""){
			GetWholePatID(patno);
			Query();
		 }	
	 }
	});
})

//查询
function Query()
{
	//1、清空datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2、查询
	var StDate=$('#stdate').datebox('getValue'); //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue'); //科室ID
	if (LocID== undefined){LocID="";}
	var PatNo=$.trim($("#patno").val());
	var curStatus=$('#status').combobox('getValue'); //状态  liyarong 2016-09-26
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+curStatus;
	$('#maindg').datagrid({
		url:url+'?action=GetDQEvtReport',	
		queryParams:{
			params:params}
	});
}

//初始化报告列表
function InitPatList()
{
	//定义columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"dgERepID",title:'dgERepID',width:90,hidden:true},
		{field:'dgERepCode',title:'编码',width:180},
		{field:'dgEPatNo',title:'登记号',width:120},
		{field:'dgEPatName',title:'姓名',width:120},
		{field:'dgERepStatus',title:'当前状态',width:120},
		{field:'dgERepLoc',title:'报告科室',width:260},
		{field:'dgEReporter',title:'报告人',width:120},
		{field:'dgERepDate',title:'报告日期',width:120}
	]];
	
	//定义datagrid
	$('#maindg').datagrid({
		title:'报告列表',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	
	initScroll("#maindg");//初始化显示横向滚动条
}

/// 报表浏览
function repview()
{
	var dgERepID="";
	var rowList=$('#maindg').datagrid('getSelections');
 	if (rowList!=""){
		if(rowList.length>1){
			$.messager.alert('错误提示','一次只能浏览一个报告，请勾选先要查看的记录!',"error");
			return;
			}
		var row=$('#maindg').datagrid('getSelected');
		dgERepID=row.dgERepID;
		dgERepStatus=row.dgERepStatus;  //liyarong 2016-09-26
	}else{
		$.messager.alert('错误提示','请先选择一行记录!',"error");
		return;
	}
	showEditWin(dgERepID,dgERepStatus); 
}


//编辑窗体
function showEditWin(dgERepID,dgERepStatus)
{	
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'报告编辑',
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600
	});

		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.drugqualityevtreport.csp?dqEvtRepID='+dgERepID+'&curstatus='+dgERepStatus+'&editFlag='+0+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}


///补0病人登记号
function GetWholePatID(RegNo)
{    
	if (RegNo=="") {
		return RegNo;
	}
	var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON","GetPatRegNoLen");
	var plen=RegNo.length;
	if (plen>patLen){
		$.messager.alert('错误提示',"登记号输入错误！");
		return;
	}
	for (i=1;i<=patLen-plen;i++){
		RegNo="0"+RegNo;  
	}
	$("#patno").val(RegNo);
}

// 导出Excel
function Export()
{
	var selItemList = $('#maindg').datagrid('getSelections');    //wangxuejian 2016-09-14
	if (selItemList==""){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","请选择路径后,重试！");
		return;
	}
/*
	$.each(selItems, function(index, item){
		var dgERepID=selItems.dgERepID;         //报表ID
		ExportExcel(dgERepID,filePath);
	})
*/
   var selItems= $('#maindg').datagrid('getChecked');
	$.each(selItems, function(index, item){
		var dgERepID=item.dgERepID;         //报表ID
		ExportExcel(dgERepID,filePath);
	})
	$.messager.alert("提示:","导出完成！导出目录为:【"+filePath+"】");
}
function ExportExcel(dgERepID,filePath)
{
	if(dgERepID==""){
		$.messager.alert("提示:","报表ID为空！");
		return;
	}
	var retval=tkMakeServerCall("web.DHCSTPHCMDRGQEVTREPORT","getDQEvtRepExportInfo",dgERepID);
	if(retval==""){
		$.messager.alert("提示:","取数据错误！");
		return;
	}
	var retvalArr=retval.split("&&");
	//1、获取XLS打印路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCST_PHCM_DrgQuaRep.xls";
	//var Template = "C:\\DHCST_PHCM_DrgQuaRep.xls";
	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	objSheet.Cells(2,2).value=retvalArr[2]; //报告科室/部门
	objSheet.Cells(2,7).value=retvalArr[3]; //报告时间
	objSheet.Cells(2,11).value=retvalArr[35]; //编码
	
	objSheet.Cells(3,2).value=retvalArr[6]; //患者姓名
	objSheet.Cells(3,4).value=retvalArr[9]; //出生日期
	objSheet.Cells(3,7).value=retvalArr[8]; //年龄
	objSheet.Cells(3,9).value=retvalArr[7]; //性别
	objSheet.Cells(3,12).value=retvalArr[10]; //住院号/门诊就诊号
	
	objSheet.Cells(4,2).value=retvalArr[12];  //就诊科室
	objSheet.Cells(4,8).value=retvalArr[13];  //事件发生时间
	objSheet.Cells(4,11).value=retvalArr[14]; //发现时间
	
	objSheet.Cells(5,2).value=retvalArr[15]; //事件分级
	objSheet.Cells(6,2).value=retvalArr[16]+retvalArr[17]; //事件发生地点
	objSheet.Cells(7,5).value=retvalArr[18]+retvalArr[19]; //是否能够提供药品标签、处方复印件等资料
	objSheet.Cells(8,2).value=retvalArr[29];  //事件发生经过
	
	objSheet.Cells(9,3).value=retvalArr[20];   //是否死亡
	objSheet.Cells(9,7).value=retvalArr[21];   //直接死因
	objSheet.Cells(9,11).value=retvalArr[22];  //死亡时间
	objSheet.Cells(10,3).value=retvalArr[27];  //是否生命垂危
	objSheet.Cells(10,7).value=retvalArr[28];  //需抢救(报告)
	objSheet.Cells(11,3).value=retvalArr[24];  //是否伤害
	objSheet.Cells(11,7).value=retvalArr[25];  //部位、程度
	objSheet.Cells(12,4).value=retvalArr[26];  //住院时间延长
	objSheet.Cells(13,3).value=retvalArr[23];  //恢复过程
	
	objSheet.Cells(14,2).value=retvalArr[36];  //引发时间因素
	objSheet.Cells(15,2).value=retvalArr[30];  //事件处理情况
	objSheet.Cells(16,2).value=retvalArr[31];  //改进措施
	objSheet.Cells(17,3).value=retvalArr[33];  //报告人
	objSheet.Cells(17,10).value=retvalArr[34]; //科室（部门）负责人
	
	var dgEvtRepDrgItmList=retvalArr[37];  //药品列表

	var dgEvtRepDrgItmArr=dgEvtRepDrgItmList.split("||");
	for(var k=0;k<dgEvtRepDrgItmArr.length;k++){
		var dgEvtDrgItmArr=dgEvtRepDrgItmArr[k].split("^");
		objSheet.Cells(19+k,1).value=dgEvtDrgItmArr[0];  //商品名称
		objSheet.Cells(19+k,2).value=dgEvtDrgItmArr[2];  //通用名
		objSheet.Cells(19+k,3).value=dgEvtDrgItmArr[9]; //供应商
		objSheet.Cells(19+k,5).value=dgEvtDrgItmArr[4];  //生产企业
		objSheet.Cells(19+k,7).value=dgEvtDrgItmArr[10]; //批号~校期
		objSheet.Cells(19+k,9).value=dgEvtDrgItmArr[7];  //规格
		objSheet.Cells(19+k,10).value=dgEvtDrgItmArr[11]; //数量
		objSheet.Cells(19+k,11).value=dgEvtDrgItmArr[6];  //剂型
		objSheet.Cells(19+k,12).value=dgEvtDrgItmArr[8];  //包装类型
	}
    //xlApp.Visible = true; 
	//xlApp.UserControl = true;
	xlBook.SaveAs(filePath+retvalArr[35]+".xls");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}
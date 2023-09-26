/// Creator: bianshuai
/// CreateDate: 2014-10-29
//  Descript: 不良反应上报

var url="dhcpha.clinical.action.csp";
var statArray = [{ "val": "N", "text": "未提交" }, { "val": "R", "text": "退回" }, { "val": "C", "text": "已提交" }]; // wangxuejian 2016/10/28
$(function(){

	$("#stdate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
 	
	//科室
	$('#dept').combobox({
		onShowPanel:function(){
			$('#dept').combobox('reload',url+'?action=SelAllLoc&loctype=E&HospID='+session['LOGON.HOSPID'])
		}
	}); 
	
	

/* 	$('#dept').combobox({
		onShowPanel:function(){
			$('#dept').combobox('reload',url+'?action=SelAllLoc&HospID='+session['LOGON.HOSPID'])
		}
	}); 
	 */
	 $('#status').combobox({	//qunianpeng 2016/11/2
		panelHeight:"auto",  //设置容器高度自动增长
		data:statArray,
		onSelect:function(option){}
	});
	$('#status').combobox('setValue',"N"); //设置combobox默认值
/* 	//状态   wangxuejian  2016/10/27
	var strParam = session['LOGON.GROUPID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.USERID'];
	var StatusCombobox = new ListCombobox("status",url+'?action=jsonAdrStatus&strParam='+strParam,'',{panelHeight:"auto"});   
	StatusCombobox.init(); */

	$('#Find').bind("click",Query);  //点击查询
	$('#Audit').bind("click",Audit); //审批
	$('a:contains("日志")').bind("click",showLogWin); //日志
	$('a:contains("导出")').bind("click",Export); 	  //导出
	
	InitPatList(); //初始化病人列表
	
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
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue');     //科室ID
	var status=$('#status').combobox('getValue');  //状态
	if (typeof LocID=="undefined"){LocID="";}
	var PatNo=$.trim($("#patno").val());
	//var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+LgHospID;
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.USERID']+"^"+status+"^"+session['LOGON.HOSPID'];
	$('#maindg').datagrid({
	  url:url+'?action=QueryCompAdrReport',   //wangxuejian 2016-10-27 
	//	url:url+'?action=GetAdrReport',	
		queryParams:{
			params:params}
	});
}

//初始化病人列表
function InitPatList()
{
	//定义columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"AdrReqID",title:'AdrRepID',width:90},
		{field:'Edit',title:'修改',width:80,align:'center',formatter:setCellEditSymbol},
		{field:'View',title:'查看',width:80,align:'center',formatter:setCellViewSymbol,hidden:true},
		{field:'AdrRepDate',title:'报告日期',width:100},
		{field:'AdrReqNo',title:'报告编号',width:160},
		{field:'PatNo',title:'登记号',width:120},
		{field:'PatName',title:'姓名',width:120},
		{field:'AdrRepStatus',title:'当前状态',width:100},
		{field:'AdrNextStatus',title:'下一状态',width:100,hidden:true},
		{field:'AdrRepLoc',title:'报告科室',width:220},
		{field:'AdrReporter',title:'报告人',width:120},
		{field:'AdrRetReason',title:'退回理由',width:320,formatter:setCellColor}
	]];
	
	//定义datagrid
	$('#maindg').datagrid({
		title:'病人列表',
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
	//清空datagrid  liyarong2016-11-03
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
}

///设置编辑连接
function setCellEditSymbol(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showEditWin("+rowData.AdrReqID+")'><img src='../scripts/dhcpha/images/editb.png' border=0/></a>";
}

///设置查看连接
function setCellViewSymbol(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showViewWin("+rowData.AdrReqID+")'><img src='../scripts/dhcpha/images/multiref.gif' border=0/></a>";
}

///设置列前景色
function setCellColor(value, rowData, rowIndex)
{
	return '<span style="color:red;">'+value+'</span>';;
}

//编辑窗体
function showEditWin(AdrReqID)
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

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.adrreport.csp?adrRepID='+AdrReqID+'&editFlag='+1+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}

//编辑窗体
function showViewWin(AdrReqID)
{
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'报告查看',
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600
	});

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.adrreport.csp?adrRepID='+AdrReqID+'&editFlag='+0+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}

//日志
function showLogWin()
{
	var AdrReqID="";
	var row=$('#maindg').datagrid('getSelected');
	if (row){
		AdrReqID=row.AdrReqID ;
	}else{
		$.messager.alert('提示',"<font style='color:red;font-weight:bold;font-size:20px;'>请先选择一行记录!</font>","error");
		return;
	}
	
	$('#LogWin').css("display","block");
	$('#LogWin').window({
		title:'审核日志',
		collapsible:true,
		border:false,
		closed:"true",
		width:700,
		height:300,
		onClose:function(){
			$('#LogWin').css("display","none");
		}
	});

	// 定义columns
	var columns=[[
		{field:"Status",title:'状态',width:100},
		{field:"AuditUser",title:'审核人',width:100},
		{field:'AuditDate',title:'审核日期',width:100},
		{field:'AuditTime',title:'审核时间',width:100}
	]];
	
	// 定义datagrid
	$('#medadvdicdg').datagrid({
		//title:'',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '正在加载信息...'
	});
	$('#LogWin').window('open');

    $('#medadvdicdg').datagrid({
		url:url+'?action=QueryAuditLog',	
		queryParams:{
			params:AdrReqID}
	});
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
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('提示',"<font style='color:red;font-weight:bold;font-size:20px;'>请先选择一行记录!</font>","error");
		return;
	}
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择路径后,重试！</font>","error");
		return;
	}
	$.each(selItems, function(index, item){
		var adrrRepID=item.AdrReqID;         //报表ID
		ExportExcel(adrrRepID,filePath);
	})
	$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
}

function ExportExcel(adrrRepID,filePath)
{
	if(adrrRepID==""){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>报表ID为空！</font>");
		return;
	}
	var retval=tkMakeServerCall("web.DHCSTPHCMADRREPORT","getAdrRepExportInfo",adrrRepID);
	if(retval==""){
		$.messager.alert("提示:","取数据错误！");
		return;
	}

	var retvalArr=retval.split("&&");
	//1、获取XLS打印路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCST_PHCM_AdrReport.xls";
	//var Template = "C:\\DHCST_PHCM_AdrReport.xls";
	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	objSheet.Cells(2,2).value=retvalArr[2]; //报告状态
	objSheet.Cells(2,9).value=retvalArr[1]; //编号
	objSheet.Cells(3,2).value=retvalArr[3]+","+retvalArr[4]+""+retvalArr[5]; //类型
	objSheet.Cells(3,7).value=retvalArr[6]; //报告单位类别
	
	objSheet.Cells(4,2).value=retvalArr[9]; //患者姓名
	objSheet.Cells(4,4).value=retvalArr[10]; //性别
	objSheet.Cells(4,6).value=retvalArr[12]; //出生日期
	objSheet.Cells(4,8).value=retvalArr[13]; //民族
	objSheet.Cells(4,10).value=retvalArr[14]; //体重
	objSheet.Cells(4,12).value=retvalArr[15]; //联系方式
	
	objSheet.Cells(5,2).value=retvalArr[47]; //原患疾病
	objSheet.Cells(5,5).value=retvalArr[37]; //医院名称
	objSheet.Cells(5,9).value=retvalArr[17]+retvalArr[18]; //既往药品不良反应/事件
	objSheet.Cells(6,5).value=retvalArr[16]; //病历号/门诊号
	objSheet.Cells(6,9).value=retvalArr[19]+retvalArr[20]; //家族药品不良反应/事件

	objSheet.Cells(7,2).value=retvalArr[49]; //相关重要信息
	
	objSheet.Cells(8,3).value=retvalArr[48];  //不良反应/事件名称
	objSheet.Cells(8,10).value=retvalArr[21]; //不良反应/事件发生时间
	
	objSheet.Cells(10,1).value=retvalArr[50]; //不良反应/事件过程描述
	
	objSheet.Cells(11,3).value=retvalArr[22]; //不良反应/事件的结果
	objSheet.Cells(11,7).value=retvalArr[23]; //表现/直接死因
	objSheet.Cells(11,11).value=retvalArr[24]+" "+retvalArr[25]; //死亡时间
	
	objSheet.Cells(12,5).value=retvalArr[26]; //停药或减量后，反应/事件是否消失或减轻？
	objSheet.Cells(13,5).value=retvalArr[27]; //再次使用可疑药品后是否再次出现同样反应/事件
	objSheet.Cells(14,5).value=retvalArr[28]; //对原患疾病的影响
	
	objSheet.Cells(15,3).value=retvalArr[29]; //报告人评价
	objSheet.Cells(15,10).value=retvalArr[30]; //签名
	objSheet.Cells(16,3).value=retvalArr[31];  //报告单位评价
	objSheet.Cells(16,10).value=retvalArr[32]; //签名
	
	objSheet.Cells(17,3).value=retvalArr[33]; //联系电话
	objSheet.Cells(18,3).value=retvalArr[36]; //电子邮箱
	objSheet.Cells(17,10).value=retvalArr[34]+retvalArr[35]; //职业
	objSheet.Cells(18,6).value=retvalArr[30]; //签名
	objSheet.Cells(18,10).value=retvalArr[43]; //报告部门
	
	objSheet.Cells(19,3).value=retvalArr[37]; //单位名称
	objSheet.Cells(19,6).value=retvalArr[38]; //联系人
	objSheet.Cells(19,8).value=retvalArr[39]; //电话
	objSheet.Cells(19,11).value=retvalArr[41]; //报告日期
	
	objSheet.Cells(20,2).value=retvalArr[40]; //备注
	
	var adrRepDrgItmList=retvalArr[51];  //药品列表

	var adrRepDrgItmArr=adrRepDrgItmList.split("||");
	for(var k=0;k<adrRepDrgItmArr.length;k++){
		var drgItmArr=adrRepDrgItmArr[k].split("^");
		objSheet.Cells(23+k,1).value=drgItmArr[0]; //类型
		objSheet.Cells(23+k,2).value=drgItmArr[1]; //批准文号
		objSheet.Cells(23+k,3).value=drgItmArr[3]; //商品名称
		objSheet.Cells(23+k,4).value=drgItmArr[8]; //通用名
		objSheet.Cells(23+k,6).value=drgItmArr[5]; //厂家
		objSheet.Cells(23+k,7).value=drgItmArr[17]; //批号
		objSheet.Cells(23+k,8).value=drgItmArr[9]; //用法用量
		objSheet.Cells(23+k,9).value=drgItmArr[13]; //开始时间
		objSheet.Cells(23+k,11).value=drgItmArr[14]; //结束时间
		objSheet.Cells(23+k,12).value=drgItmArr[16]; //用药原因
	}
	
	//xlApp.Visible = true; 
	//xlApp.UserControl = true;
	//xlBook.SaveAs("D:\\"+retvalArr[1]+".xls");
	//var signSys="\\";
	//filePath=filePath.replace("\\",signSys);
	//alert("filePath:"+filePath)
	xlBook.SaveAs(filePath+retvalArr[1]+".xls");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}

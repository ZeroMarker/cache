
///Creator:    bianshuai
///CreateDate: 2016-01-28
///Descript:   药学类咨询
var flag=0;
var finiFlag="N"
var url="dhcpha.clinical.action.csp";
$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));     //Init结束日期
	
	$("a:contains('新建')").bind("click",newCreateConsult);
	$("a:contains('查询')").bind("click",queryConsultDetail);
	$("a:contains('删除')").bind("click",delConsultDetail);
	
	/**
	 * 咨询身份
	 */
	var consIdenCombobox = new ListCombobox("consIden",url+'?action=QueryConsIdenInfo','',{panelHeight:"auto"});
	consIdenCombobox.init();
	
	/**
	 * 问题类型
	 */
	var quesTypeCombobox = new ListCombobox("consType",url+'?action=QueryQuesType','',{panelHeight:"auto"});
	quesTypeCombobox.init();
	
	/**
	 * 咨询部门
	 */
	 $('#consDept').combobox({
		//mode:'remote',		
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			$('#consDept').combobox('reload',url+'?action=SelAllLoc&hospId='+LgHospID)
			//$('#consDept').combobox('reload',url+'?action=SelAllLoc&HospID='+HospID)
		}
	}); 
	//var conDeptCombobox = new ListCombobox("consDept",url+'?action=QueryConDept','',{});
	//conDeptCombobox.init();
	
	InitConsultList();    //初始化咨询信息列表
	
})

//初始化界面默认信息
function InitConsultDefault(){

	$("#consUserID").val(LgUserID);  //用户ID
	$('#consCode').val(LgUserCode);  //用户工号
	$('#consName').val(LgUserName);  //用户姓名
	$('#consDept').combobox('setValue',LgCtLocID);   
	$('#consDept').combobox('setText',LgCtLocDesc);  
	
	$("#consTele").val('');    //联系电话
	$('#consIden').combobox('setValue','');    //咨询身份
	$('#consType').combobox('setValue','');    //问题类型
	$('#consDesc').val('');    //咨询描述
	$("#consultID").val(''); //咨询ID
}

//初始化病人列表
function InitConsultList()
{

	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'consultID',title:'consultID',width:80,hidden:true},
		{field:'finiFlag',title:'完成标志',width:50,align:'center',formatter:SetCellColor},
		{field:'consDate',title:'咨询日期',width:100},
		{field:'consTime',title:'咨询时间',width:90},
		{field:'quesType',title:'问题类型',width:120},
		{field:'consIden',title:'咨询身份',width:100},
		{field:'consDept',title:'咨询部门',width:160},
		{field:'consName',title:'咨询人',width:100},
		{field:'consTele',title:'联系电话',width:100},
		{field:'consDesc',title:'问题描述',width:500},
		{field:'consDet',title:'明细',width:100,align:'center',formatter:SetCellUrl},
		{field:'LkRepDetial',title:'查看回复',width:100,align:'center',formatter:SetCellDetUrl},
		{field:'LkDetial',title:'操作',width:100,align:'center',formatter:SetCellOpUrl}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'咨询明细',
		//nowrap:false,
		singleSelect : true,
		onLoadSuccess:function(data){
			///提示信息
    		LoadCellTip("consDesc");
		},
		onDblClickRow:function(rowIndex, rowData){
			showModifyWin(rowData.consultID);
		} 
		};
		
	var conDetListComponent = new ListComponent('conDetList', columns, '', option);
	conDetListComponent.Init();

	initScroll("#conDetList");//初始化显示横向滚动条

	queryConsultDetail();
}

 /**
  * 新建咨询问题
  */
function newCreateConsult(){
	finiFlag="N"
	newCreateConsultWin(); //新建咨询窗口
	InitConsultDefault();  //初始化界面默认信息
}

 /**
  * 新建咨询窗口
  */
function newCreateConsultWin(){
	var option = {
			buttons:[{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					saveConsultDetail();
					}
			},{
				text:'关闭',
				iconCls:'icon-cancel',
				handler:function(){
					$('#newConWin').dialog('close');
					}
			}]
		};
	if(flag==1){
		var newConDialogUX = new DialogUX('修改', 'newConWin', '730', '330', option); //lbb 2019-03-12
	}
	else{
	    var newConDialogUX = new DialogUX('新建', 'newConWin', '730', '330', option); //nisijia 2016-09-30
	}
	newConDialogUX.Init();
	flag=0;
}

 /**
  * 保存咨询数据
  */
function saveConsultDetail(){
	 if(finiFlag=="Y"){
		alert("请先取消完成后再进行修改!!!");
		return;
	 }
	 
	var consName=$('#consName').val();    //姓名
	if (consName == ""){
		showMsgAlert("错误提示:","姓名不能为空！");
		return;
	}
		
	var consTele=$('#consTele').val();    //联系电话
	if (consTele == ""){
		showMsgAlert("错误提示:","联系电话不能为空！");
		return;
	}

	var consIden=$('#consIden').combobox('getValues');    //咨询身份
	if (consIden == ""){
		showMsgAlert("错误提示:","咨询身份不能为空！");
		return;
	}
	
	var consType=$('#consType').combobox('getValues');    //问题类型
	if (consType == ""){
		showMsgAlert("错误提示:","问题类型不能为空！");
		return;
	}
	
	var consDept=$('#consDept').combobox('getValues');    //咨询部门
	if (consDept == ""){
		showMsgAlert("错误提示:","咨询部门不能为空！");
		return;
	}

	var consDesc=$('#consDesc').val();       //咨询描述
	if (consDesc == ""){
		showMsgAlert("错误提示:","问题描述不能为空！");
		return;
	}
	if($('#consDesc').val().length>800){
		showMsgAlert("错误提示:","问题描述不能超过800字！");
		return;
	}
	var consUserID = $("#consUserID").val();
	var consultID = $("#consultID").val();
	
	
	var conDataList = consUserID +"^"+ consTele +"^"+ consIden +"^"+ consType +"^"+ consDept +"^"+ consDesc;
		conDataList = conDataList +"^"+ LgUserID+"^"+ "MAN";

	//保存数据
	$.post(url+'?action=saveConsultDetail',{"consultID":consultID,"conDataList":conDataList},function(jsonString){
		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			$('#newConWin').dialog('close');     //关闭窗体
			$('#conDetList').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示:","提交失败,错误原因："+jsonConsObj.ErrorMessage);
		}
	});
}

 /**
  * 查询咨询数据
  */
function queryConsultDetail(){
	
	//1、清空datagrid 
	$('#conDetList').datagrid('loadData', {total:0,rows:[]});
	
	//2、查询
	var startDate=$('#startDate').datebox('getValue');   //起始日期
	var endDate=$('#endDate').datebox('getValue');       //截止日期

	var consDesc=$('#inConsDesc').val();    //咨询描述
	
	var params=startDate +"^"+ endDate +"^"+ LgUserID + "^" + consDesc +"^"+ ""  +"^"+ "" +"^"+ "MAN"+"^"+LgHospID;
	
	$('#conDetList').datagrid({
		url:url + "?action=QueryPhConsult",	
		queryParams:{
			params:params}
	});
}

//链接设置formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showModifyWin("+rowIndex+")'>修改明细</a>";
}

//链接设置formatter="SetCellUrl"
function SetCellColor(value, rowData, rowIndex)
{
	var html = "";
	if (value == "Y"){
		html = "<span style='margin:0px 5px;font-weight:bold;color:red;'>完成</span>";		
	}else{
		html = "<span style='margin:0px 5px;font-weight:bold;color:green;'>No</span>";
		}
    return html;}


/// 删除咨询明细
function delConsultDetail(){
	showMsgAlert("错误原因:" , "删除功能暂时不可用！");
}


//查看回复列表
//查看回复列表
function SetCellDetUrl(value, rowData, rowIndex)
{
	var html = "";
	if (rowData.finiFlag == "Y"){
		html = "<a href='#' onclick='newCreateConsultDetWin("+rowData.consultID+")' style='margin:0px 5px;font-weight:bold;color:red;text-decoration:none;'>查看回复列表</a>";
		
	}else{
		html = "<a href='#' onclick='newCreateConsultDetWin("+rowData.consultID+")'>查看回复列表</a>";
		}
    return html;
}

//操作
function SetCellOpUrl(value, rowData, rowIndex)
{
	var html = "";
	if (rowData.finiFlag != "Y"){
		html = "<a href='#' onclick='setConsultComplete("+"\""+rowData.consultID+"\""+","+"\"Y\""+")'>设置完成</a>";
	}else{
		html = "<a href='#' onclick='setConsultComplete("+"\""+rowData.consultID+"\""+","+"\"N\""+")'>取消完成</a>";
	}
    return html;
}


/// 设置完成状态
function setConsultComplete(consultID, consComFlag){

	//保存数据
	$.post(url+'?action=setConsultComplete',{"consultID":consultID, "consComFlag":consComFlag},function(jsonString){

		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			showMsgAlert("","设置成功！");
			$('#conDetList').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示:","设置失败,错误原因："+jsonConsObj.ErrorMessage);
		}
	});
}

 /**
  * 新建咨询窗口
  */
function newCreateConsultDetWin(consultID){
	
	var option = {
		minimizable : true,
		maximizable : true
		};
	var newConWindowUX = new WindowUX('列表', 'newConDetWin', '930', '550', option);
	newConWindowUX.Init();

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.replyconsult.csp?consultID='+consultID+'"></iframe>';
	$('#newConDetWin').html(iframe);
	
	/*
	window.open ('dhcpha.clinical.replyconsult.csp?consultID='+consultID,'newwindow','height=930,width=620,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no') 
	*/
}

 /**
  * 修改窗体
  */
function showModifyWin(index){

	/*
	if($('#newConWin').is(":visible")){ 
		//窗体处在打开状态,退出
	}else{
		newCreateConsultWin(); //创建窗体
	}
	*/
	flag=1;
	var rowData = $('#conDetList').datagrid('getData').rows[index];
	consultID = rowData.consultID;
	finiFlag=rowData.finiFlag   //lbb  2019/11/18  取完成状态，完成后不能修改保存，只允许浏览
	newCreateConsultWin(); //创建窗体
	
	$.post(url+'?action=QyConsultDetail',{"consultID":consultID},function(jsonString){

		var resobj = jQuery.parseJSON(jsonString);
		$("#consUserID").val(resobj.consUserID);    //用户ID
		$("#consCode").val(resobj.consCode);    //工号
		$("#consName").val(resobj.consName);    //姓名
		$("#consTele").val(resobj.consTele);    //联系电话
		$('#consIden').combobox('setValue',resobj.consIden);    //咨询身份
		$('#consType').combobox('setValue',resobj.quesType);    //问题类型
		$('#consDept').combobox('setValue',resobj.consDept);    //咨询部门
		$('#consDept').combobox('setText',resobj.consDeptDesc);    //咨询部门
		$('#consDesc').val(resobj.consDesc);    //咨询描述
		$("#consultID").val(consultID); //咨询ID
	});
	
}

/// 消息提示窗口
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("提示:","<font style=''>" + ErrMsg + "</font><font style='color:red;'>" + ErrDesc + "</font>");
}
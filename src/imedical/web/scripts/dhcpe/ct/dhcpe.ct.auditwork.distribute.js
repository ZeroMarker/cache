/**
 * 总检工作量分配   dhcpe.ct.auditwork.distribute.js
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
var _FlowType="";  //分配类型

function init(){
	setLayout();
	initDate();
	$("#S_RegNo").keydown(function(e) {	
		if(e.keyCode==13){
			RegNoChange();
		}
	}); 
}
var VIPObj = $HUI.combobox("#S_VIPLevel",{
	url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
	valueField:'id',
	textField:'desc',
	onSelect:function(record){
	}
});

var TypeObj = $HUI.combobox("#S_Type",{
	url:$URL+"?ClassName=web.DHCPE.CT.WorkDistribution&QueryName=QueryWorkType&ResultSetType=array&LocID="+session["LOGON.CTLOCID"],
	valueField:'TCode',
	textField:'TDesc',
	editable:false,
	onSelect:function(record){
	},
	onLoadSuccess:function(data){
		if(data.length>0){
			$("#S_Type").combobox("setValue",data[0].TCode);
		}
	},
	onChange:TypeChange
});


var GIDObj = $HUI.combogrid("#S_GID",{
	panelWidth:520,
	url:$URL+"?ClassName=web.DHCPE.PreGADM&QueryName=SearchPreGADMShort",
	mode:'remote',
	delay:200,
	idField:'Hidden',
	textField:'Name',
	onBeforeLoad:function(param){
		param.Code = param.q;
	},
	onChange:function(){
		GTeamObj.clear();
	},
	columns:[[
		{field:'Hidden',hidden:true},
		{field:'Name',title:'团体名称',width:140},
		{field:'Code',title:'编码',width:100},
		{field:'Begin',title:'开始日期',width:100},
		{field:'End',title:'截止日期',width:100},
		{field:'DelayDate',title:'状态',width:50}			
	]],
	pagination:true,
	pageSize:20
});

var GTeamObj = $HUI.combogrid("#S_TeamID",{
	panelWidth:260,
	url:$URL+"?ClassName=web.DHCPE.PreGTeam&QueryName=SearchGTeam",
	mode:'remote',
	delay:200,
	idField:'PGT_RowId',
	textField:'PGT_Desc',
	onBeforeLoad:function(param){		
		var PreGId=$("#S_GID").combogrid("getValue");
		param.ParRef = PreGId;
	},
	onShowPanel:function()
	{
		$('#S_TeamID').combogrid('grid').datagrid('reload');
	},
	columns:[[
		{field:'PGT_RowId',hidden:true},
		{field:'PGT_ParRef_Name',title:'团体名称',width:140},
		{field:'PGT_Desc',title:'分组名称',width:100}
	]]
});


function TypeChange(newValue, oldValue){
	_FlowType = newValue;
	initDocKeys();
	initNoDistribute();
}

function clean_onclick(){
	$("#S_RegNo").val("");
	$("#S_VIPLevel").combobox("setValue","");
	$("#S_GID").combogrid("setValue","");
	$("#S_TeamID").combogrid("setValue","");
	initDate();
	unselect_all_doc();
	find_onclick();
}

function initNoDistribute(){
	var NoDistributeDataGrid = $HUI.datagrid("#NoDistributeList",{
	url:$URL,
	bodyCls:'panel-body-gray',
	singleSelect:false,
	queryParams:{
		ClassName: "web.DHCPE.WorkDistribution",
		QueryName: "QueryDistribution",
		RegNo: $("#S_RegNo").val(),
		BeginDate: $("#S_StartDate").datebox("getValue"),
		EndDate: $("#S_EndDate").datebox("getValue"),
		GroupDR: $("#S_GID").combogrid("getValue"),
		GTeamDR: $("#S_TeamID").combogrid("getValue"),
		VIPLevel: $("#S_VIPLevel").combobox("getValue"),
		Type: _FlowType	 
	},
	onSelect:function(rowIndex,rowData){

	},
	onDblClickRow:function(index,row){
														
	},	
	columns:[[
		{idField:'TPAADM',hidden:true},
		{field:'TCheck',checkbox:true},
		{field:'TRegNo',width:120,title:'登记号'},
		{field:'TPatName',width:80,title:'姓名'},
		{field:'TSex',width:60,title:'性别'},
		{field:'TAge',width:80,title:'年龄'},
		{field:'TVIPLevel',width:120,title:'VIP等级'},
		{field:'TCheckDate',width:100,title:'体检日期'},
		{field:'TStatus',width:100,title:'状态'}	,
		{field:'TReportStatus',width:100,title:'报告状态'}
	]],
	toolbar: [{
		id: "DistributeBtn",
		iconCls: 'icon-stamp-pass',
		text:'分配',
		handler: distribute_handler
	}],
	fitColumns:true,
	pagination:true,
	pageSize:50,
	fit:true
	});
}

function RegNoChange(){
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	var iRegNo=$("#S_RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
		iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo);
		$("#S_RegNo").val(iRegNo);
	}
	find_onclick();
}

function initDocKeys(){
	unselect_all_doc();
	 $.cm({
        wantreturnval: 1,
        ClassName: 'web.DHCPE.WorkDistribution',
        MethodName: 'GetDocKeysByType',
        Code: _FlowType,
        LocID: session["LOGON.CTLOCID"]
    }, function(data) {
    	if(data.length==0){
    		$.messager.alert("提示","该分配类型下没有指定的医生!","info");
    	}
		$HUI.keywords("#DocKeys",{
			labelCls:"blue",
			onSelect:select_doc,
			onUnselect:unselect_doc,
			items:data
		})
	});

}

/**
 * [全选医生]
 * @Author   wangguoying
 * @DateTime 2021-01-29
 */
function select_all_doc(){
	$("#DocKeys").find("li").each(function(){
		if(!$(this).hasClass("selected")){
			$("#DocKeys").keywords("select",this.id);
		}
	});	
}
/**
 * [全部撤销选中]
 * @Author   wangguoying
 * @DateTime 2021-01-29
 */
function unselect_all_doc(){
	$("#DocKeys").find("li").each(function(){
		if($(this).hasClass("selected")){
			$("#DocKeys").keywords("switchById",this.id);
		}
	});	
}
/**
 * [选中医生]
 * @param    {[Object]}    v [选中的节点]
 * @Author   wangguoying
 * @DateTime 2021-01-29
 */
function select_doc(v){
	createDocPanel(v);
}
/**
 * [撤销选中医生]
 * @param    {[Object]}    v [选中的节点]
 * @Author   wangguoying
 * @DateTime 2021-01-29
 */
function unselect_doc(v){
	var id = "TD_"+v.id;
	if(document.getElementById(id)){
		$("#"+id).remove();
	}
}

/**
 * [重新生成医生已分配列表]
 * @Author   wangguoying
 * @DateTime 2021-02-01
 */
function reSelectDoc(){
	var docs=$("#DocKeys").keywords("getSelected");
	unselect_all_doc();
	docs.forEach( function(element, index) {
		$("#DocKeys").keywords("switchById",element.id);
	});
}

/**
 * [分配]
 * @Author   wangguoying
 * @DateTime 2021-01-30
 */
function distribute_handler(){
	var rows=$("#NoDistributeList").datagrid("getChecked");
	if(rows.length == 0){
		$.messager.alert("提示","请先选中需要分配的记录","info");
		return false;
	}
	var docs=$("#DocKeys").keywords("getSelected");
	if(docs.length == 0){
		$.messager.alert("提示","未选择分配医生","info");
		return false;
	}
	var admIds="";
	rows.forEach( function(value,index,arr) {
		admIds= admIds!=""?admIds+"^"+value.TPAADM:value.TPAADM;
	});
	var docIds="";
	docs.forEach( function(value,index,arr) {
		docIds= docIds!=""?docIds+"^"+value.id:value.id;
	});
	var ret=tkMakeServerCall("web.DHCPE.WorkDistribution","Distribute",docIds,admIds,_FlowType,session["LOGON.USERID"]);
	if(ret != ""){
		$.messager.alert("错误","分配失败："+ret,"error");
		return false;
	}else{
		$.messager.alert("提示","分配成功","success",function(){
			$("#NoDistributeList").datagrid("reload");
			reSelectDoc();
		});
	}
	
}


/**
 * [创建医生分配列表]
 * @param    {[Object]}    docObj [医生关键字对象]
 * @Author   wangguoying
 * @DateTime 2021-01-30
 */
function createDocPanel(docObj){
	if(docObj == "")  return false;
	$cm({
		ClassName: "web.DHCPE.WorkDistribution",
		QueryName: "QueryDistribution",
		DoctorID: docObj.id,
		RegNo: $("#S_RegNo").val(),
		BeginDate: $("#S_StartDate").datebox("getValue"),
		EndDate: $("#S_EndDate").datebox("getValue"),
		GroupDR: $("#S_GID").combogrid("getValue"),
		GTeamDR: $("#S_TeamID").combogrid("getValue"),
		VIPLevel: $("#S_VIPLevel").combobox("getValue"),
		Type: _FlowType
	},function(rs){
		 paintDragDiv(docObj,rs);
	});
}

/**
 * [画拖放区域]
 * @param    {[Object]}    docObj [医生关键字]
 * @param    {[Array]}    	rs     [医生已分配集合]
 * @Author   wangguoying
 * @DateTime 2021-01-30
 */
function paintDragDiv(docObj,rs){
	var num = rs.total;
	var tdNums = $("#DistributeTR").find("td").length;
	// if(tdNums>2){
	// 	var width = (tdNums+1)*300;
	// 	$("#DistributeTab").css("width",width);
	// }
	var td = document.createElement("td");
	td.id="TD_"+docObj.id;
	td.style.width = "300px";
	td.style.height = "100%";
	td.style.verticalAlign="top";
	td.style.padding = '5px';
	var drPanel = document.createElement("div");
	drPanel.id="DragPanel_"+docObj.id;
	drPanel.className="hisui-panel panel-header-gray droppable";
	drPanel.style.padding = '10px';
	drPanel.title="<span style=\"color:blue\">"+docObj.text+"</span>";
	drPanel.setAttribute("data-options","fit:true,headerCls:'panel-header-card'");
	var tipDiv = document.createElement("div");
	tipDiv.style.width = '280px';
	tipDiv.style.textAlign = 'center';
	tipDiv.style.paddingTop="10px";
	var tip="<a href='#'' onclick='deleteByDocDate("+docObj.id+");' style='background:#f79797;border-radius:4px;margin:0 10px 0 0;' class='hisui-linkbutton' >撤销分配</a>";
	tip+="<div style='display:inline'>共<b><label style='color:red;' id='TIP_"+docObj.id+"'>"+num+"</label></b>人</div>"
	tipDiv.innerHTML=tip;
	$(drPanel).append(tipDiv);
	rs.rows.forEach( function(element, index) {
		var dragDiv = document.createElement("div");
		dragDiv.id="DragDiv_"+element.TPAADM;
		if(element.TFinishStatus == "未完成"){
			dragDiv.className="drag hisui-tooltip";
		}else{
			dragDiv.className="no-drag hisui-tooltip";
		}
		
		dragDiv.title="登记号："+element.TRegNo+"<br>姓名："+element.TPatName+"<br>年龄："+element.TAge+"<br>VIP等级："+element.TVIPLevel+"<br>"+"报告状态："+element.TReportStatus+"<br>"+"完成状态："+element.TFinishStatus;
		var html="<table style='width:100%; color:#ffffff;'><tr>";
		var sexImg="";
		if(element.TSex=="男"){
			sexImg = "<img  src='../images/man.png' />";
		}else{
			sexImg = "<img  src='../images/woman.png' />";
		}
		html+="<td style='width: 45px;'>"+sexImg+"</td>";
		var patName=element.TPatName;
		if(patName.length>5){
			patName=patName.substring(0, 4)+"*";
		}
		var baseInfo="<td class='base autocut' style='width: 80px;'>"+patName+"</td>";
		//baseInfo+="<td class='base '>"+element.TAge+"abcdy一二三</td>";
		//baseInfo+="<td class='base'>"+element.TVIPLevel+"</td>"  
		baseInfo+="<td class='base' style='width:120px;'>"+element.TCheckDate+"</td>"
		if(element.TFinishStatus == "未完成"){
			baseInfo+="<td class='base ' style='text-align:right;'><img onclick='deletAdmByDoc("+element.TPAADM +")' style='cursor:pointer;margin-right:8px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' /></td>"	
		}
		html+=baseInfo+"</tr></table>";
		dragDiv.innerHTML=html;
		$(drPanel).append(dragDiv);
	});
	$(td).append(drPanel);
	$("#DistributeTR").append(td);
	$.parser.parse("#TD_"+docObj.id);  //重绘HISUI样式	
	initDragEvent();
}

/**
 * [撤销分配]
 * @param    {[int]}    admId [就诊]
 * @Author   wangguoying
 * @DateTime 2021-01-30
 */
function deletAdmByDoc(admId){
	var docId=$("#DragDiv_"+admId)[0].parentNode.id.split("_")[1];
	var ret=tkMakeServerCall("web.DHCPE.WorkDistribution","DeleteAdmDoc",admId,docId,_FlowType)
	if(ret!=""){
		$.messager.alert("错误",ret,"error");
		return false;
	}
	$("#DragDiv_"+admId).tooltip("hide");
	$("#DragDiv_"+admId).remove();
	$("#TIP_"+docId).html(parseInt($("#TIP_"+docId).html())-1);
	$("#NoDistributeList").datagrid("reload");
	$.messager.popover({msg: '撤销分配成功！',type:'success',timeout: 1000});
}

/**
 * [撤销分配]
 * @param    {[int]}    docId [医生ID]
 * @Author   wangguoying
 * @DateTime 2021-02-01
 */
function deleteByDocDate(docId){
	var beginDate = $("#S_StartDate").datebox("getValue");
	var endDate = $("#S_EndDate").datebox("getValue");
	var ret=tkMakeServerCall("web.DHCPE.WorkDistribution","DeleteByDocDate",docId,beginDate,endDate,_FlowType);
	if(ret!=""){
		$.messager.alert("错误",ret,"error");
		return false;
	}
    $("#DocKeys").keywords("switchById",docId);
    $("#DocKeys").keywords("switchById",docId);
	$("#NoDistributeList").datagrid("reload");
	$.messager.popover({msg: '撤销分配成功！',type:'success',timeout: 1000});
}

/**
 * [全部撤销分配]
 * @Author   wangguoying
 * @DateTime 2021-02-01
 */
function undistribute_all(){
	if(_FlowType == ""){
		$.messager.alert("提示","无分配类型","info");
		return false;
	}
	var beginDate = $("#S_StartDate").datebox("getValue");
	var endDate = $("#S_EndDate").datebox("getValue");
	var ret=tkMakeServerCall("web.DHCPE.WorkDistribution","DeleteByDate",beginDate,endDate,_FlowType);
	if(ret!=""){
		$.messager.alert("错误",ret,"error");
		return false;
	}
	$("#NoDistributeList").datagrid("reload");
	reSelectDoc();
	$.messager.popover({msg: '撤销分配成功！',type:'success',timeout: 1000});
}

/**
 * [设置拖放事件]
 * @Author   wangguoying
 * @DateTime 2021-01-30
 */
function initDragEvent(){
	$('.drag').draggable({
		proxy:'clone',
		revert:true,
		cursor:'Move',
		onStartDrag:function(){
			$(this).draggable('options').cursor='not-allowed';
			$(this).draggable('proxy').addClass('dp');
		},
		onStopDrag:function(){
			$(this).draggable('options').cursor='auto';
		}
	});
	$('.droppable').droppable({
		onDragEnter:function(e,source){
			if(this.id == source.parentNode.id) return false;
			$(source).draggable('options').cursor='auto';
			$(source).draggable('proxy').css('border','1px solid red');
			$(this).addClass('over');
		},
		onDragLeave:function(e,source){
			if(this.id == source.parentNode.id) return false;
			$(source).draggable('options').cursor='not-allowed';
			$(source).draggable('proxy').css('border','1px solid #ccc');
			$(this).removeClass('over');
		},
		onDrop:function(e,source){
			if(this.id == source.parentNode.id) return false;
			
			var admId=source.id.split("_")[1];
			var sourceDoc=source.parentNode.id.split("_")[1];
			var targetDoc=this.id.split("_")[1];
			var ret=tkMakeServerCall("web.DHCPE.WorkDistribution","Move",admId,sourceDoc,targetDoc,_FlowType,session["LOGON.USERID"]);
			if(ret!=""){
				$.messager.alert("错误",ret,"error");
				return false;
			}

			$("#TIP_"+sourceDoc).html(parseInt($("#TIP_"+sourceDoc).html())-1);
			$("#TIP_"+targetDoc).html(parseInt($("#TIP_"+targetDoc).html())+1);
			$(source).draggable('options').cursor='Move';
			$(this).append(source)
			$(this).removeClass('over');
			$.messager.popover({msg: '转移成功！',type:'success',timeout: 1000});
		}
	});
}


/**
 * [初始化日期]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function initDate(){
	var now = new Date();
	var foramtNow = myformatter(now);
	var beginDate = new Date(now.setDate(now.getDate()-60));
	var formatBegin = myformatter(beginDate);
	$('#S_StartDate').datebox('setValue',formatBegin);	
	$("#S_EndDate").datebox('setValue',foramtNow);
}

/**
 * [格式化日期]
 * @param    {[Date]}    date [日期]
 * @return   {[String]}         [格式化的日期]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function myformatter(date){  
    var y = date.getFullYear();  
    var m = date.getMonth()+1;  
    var d = date.getDate();  
    var ret = y+"-"+(m<10?('0'+m):m)+"-"+(d<10?('0'+d):d);
    return ret;
} 


function find_onclick(){
	var type = $("#S_Type").combobox("getValue");
	if(type == ""){
		$.messager.alert("提示","分配类型不能为空","info");
		return false;
	}
	$("#NoDistributeList").datagrid("load",{
		ClassName: "web.DHCPE.WorkDistribution",
		QueryName: "QueryDistribution",
		RegNo: $("#S_RegNo").val(),
		BeginDate: $("#S_StartDate").datebox("getValue"),
		EndDate: $("#S_EndDate").datebox("getValue"),
		GroupDR: $("#S_GID").combogrid("getValue"),
		GTeamDR: $("#S_TeamID").combogrid("getValue"),
		VIPLevel: $("#S_VIPLevel").combobox("getValue"),
		Type: _FlowType 
	});
	reSelectDoc();
}



/**
 * [设置布局]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function setLayout()
{
	$(".panel-header.panel-header-gray").css("border-radius","4px 4px 0 0"); 
	/** 设置面板按钮样式 */
	$(".icon-canel-distribute").html("<span class='pe-panel-tool'>全部撤销分配</span>");
	$(".icon-canel-distribute").css("display","inline");
	$(".icon-canel-distribute").css("vertical-align","middle");
	$(".panel-tool").css("height","30px");
	$(".panel-tool").css("margin-top","-10px");
}

$(init);
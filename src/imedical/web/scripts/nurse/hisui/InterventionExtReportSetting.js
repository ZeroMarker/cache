/**
* @author songchunli
* HISUI 护理文书配置主js
* InterventionExtReportSetting.js
*/
var PageLogicObj={
	m_SelIntervid:"",
	m_SelItemID:"",
	m_dataSource:[], //措施对应任务子项
	m_sortArr:[], // 措施对应任务子项-文书替换id 数组
	m_tabReportItemEditListGrid:"",
	iframeflag:"0", //2758853【护理计划配置】业务界面整合  是否是iframe 界面  1：是； 0：否	
}
$(function(){ 
	//2758853【护理计划配置】业务界面整合
	var iframeflag=""
	if (window.parent.window.PageLogicObj){
		iframeflag=window.parent.window.PageLogicObj.iframeflag
	}
	if(iframeflag=="1"){
		PageLogicObj.iframeflag=iframeflag
		Init();		   			// iframe 界面
	}
	else if ((iframeflag== "")||(iframeflag=="0")){
		InitHospList();			// 正常界面
	}
	InitEvent();
});
$(window).load(function() {
	$("#loading").hide();
	InitEditWindow();
	InitInterventionExtReportEditWin();
})
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabInterventionExtReportList").datagrid("reload");
	});
	$("#SearchDesc").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			$("#tabInterventionExtReportList").datagrid("reload");
		}
	});
	$("#BtnInterventionContent").click(addChar);
	//保存护理文书
	$("#BSaveItnExtReport").click(SaveItnExtReportClick);
	// 保存文书ID配置
	$("#BSaveReportItem").click(SaveReportItemClick);
	$("#BCancel").click(function(){
		$("#InterventionExtReportEditWin").window('close');
	});
	$("#BReportItemWinCancel").click(function(){
		$("#ReportItemEditWin").window('close');
	});
	document.onkeydown=Doc_OnKeyDown;
}
function Doc_OnKeyDown(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if ((keyCode==13)&&(e.ctrlKey)) {
		if (SrcObj.id=="InterventionContent"){
			addChar();
		}
	}
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_InterventionExt");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#SearchDesc").val("");
		$.extend(PageLogicObj,{m_SelIntervid:"",m_SelItemID:"",m_dataSource:[],m_sortArr:[]});
		$("#tabInterventionExtReportList").datagrid("load");
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	// 初始化 状态查询条件
	InitStatus();
	InitInterventionLinkTaskList();
}
function InitStatus(){
	$("#status").combobox({
		valueField:'id',
		textField:'text',
		mode: "local",
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		data:[{"id":"1","text":"启用"},{"id":"2","text":"停用"}],
		onSelect:function(rec){
			if (rec) {
				$("#tabInterventionExtReportList").datagrid("load");
			}
		},
		onUnselect:function(rec){
			$("#tabInterventionExtReportList").datagrid("load");
		},
		onAllSelectClick:function(e){
			$("#tabInterventionExtReportList").datagrid("load");
		}
	});
}
function InitInterventionLinkTaskList(){
	var ToolBar = [{
            text: '修改',
            iconCls: 'icon-write-order',
            handler: function() {
	            var row = $("#tabInterventionExtReportList").datagrid("getSelected");
				if (!row) {
					$.messager.popover({msg:'请选择需要修改的记录！',type:'error'});
					return false;
				}
				ShowInterventionExtReportWin(row);
            }
    }];
	var Columns=[[ 
		{ field: 'code',title:'措施编码',width:100},
		{ field: 'desc',title:'措施短描述',width:510,wordBreak:"break-all"},
		{ field: 'content',title:'文书描述',width:510,wordBreak:"break-all"},
		{ field: 'status',title:'状态',width:60,
			styler: function(value,row,index){
				if (value =="启用"){
					return "color:#3FBD79;"
				}else{
					return "color:#F16E57;"
				}
			}
		}
    ]];
	$('#tabInterventionExtReportList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true,
		idField:"id",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.InterventionSetting&QueryName=FindInterventionContent",
		onBeforeLoad:function(param){
			var status=$("#status").combobox('getValues');
			if (status.length ==1){
				status=status.join("");
			}else{
				status="";
			}
			$.extend(PageLogicObj,{m_SelIntervid:""});
			$('#tabInterventionExtReportList').datagrid("unselectAll");
			//param = $.extend(param,{nameCN:$("#SearchDesc").val(),statusIn:status,hospDR:$HUI.combogrid('#_HospList').getValue()});
			//2758853【护理计划配置】业务界面整合
			param = $.extend(param,{nameCN:$("#SearchDesc").val(),statusIn:status,hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		
		},
		onDblClickRow:function(rowIndex, rowData){
			ShowInterventionExtReportWin(rowData);
		}
	})
}
//2758853【护理计划配置】业务界面整合
function ReloadInterventionExtReportList(rowID){
	$('#tabInterventionExtReportList').datagrid('load',{nameCN:$("#SearchDesc").val(),statusIn:status,hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),RowID:rowID})
}

function InitEditWindow(){
    $("#InterventionExtReportEditWin" ).window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
			SetInterventionExtReportEditWinData();
	   }
	});
	$("#ReportItemEditWin").window({
		modal: true,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:true
	 });
}
function InitInterventionExtReportEditWin(){
	// 措施
	InitIntItem();
	InittabInterventionExtReportEditList();
}
function InitIntItem(){
	$('#IntItem').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.InterventionSetting&QueryName=FindNewInterventionList&rows=99999&ResultSetType=array",
		valueField:'rowID',
		textField:'intShortName',
		mode: "remote",
		onBeforeLoad:function(param){
			//param = $.extend(param,{searchName:param["q"],status:"1",hospDR:$HUI.combogrid('#_HospList').getValue()});
			//2758853【护理计划配置】业务界面整合
			param = $.extend(param,{searchName:param["q"],status:"1",hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		},
		onSelect:function(rec){
			if (rec) {
				$("#IntCode").val(rec.intCode);
				PageLogicObj.m_SelIntervid=row.rowID;
				InitInterventionContent(rec.rowID);
				$("#tabInterventionExtReportEditList").datagrid("load");
			}
		}
    });
}
function InittabInterventionExtReportEditList(){
	var Columns=[[    
		{ field: 'taskcode',title:'任务子项编码',width:100},
		{ field: 'taskdesc',title:'任务子项描述',width:180,wordBreak:"break-all"},
		{ field: 'taskwidget', title: '任务控件类型',width:120},
		{ field: 'replace', title: '文书替换ID',width:130,wordBreak:"break-all",
			formatter: function(value,row,index){
				if (value) {
					return '<a href="#this" class="editcls1" onclick="ShowReportItemEditWin('+(index)+')">'+value+'</a>';
				}else{
					return '<a href="#this" class="editcls1" onclick="ShowReportItemEditWin('+(index)+')">点击修改</a>';
				}
			}
		}
	]];
	$('#tabInterventionExtReportEditList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, 
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : false, 
		idField:"itemID",
		columns :Columns, 
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.InterventionSetting&QueryName=FindInterventionTask",
		onBeforeLoad:function(param){
			PageLogicObj.m_dataSource=[];
			PageLogicObj.m_sortArr=[];
			$('#tabInterventionExtReportEditList').datagrid("unselectAll");
			param = $.extend(param,{intervid:PageLogicObj.m_SelIntervid});
		},
		onDblClickCell:function(rowIndex, field, value){
			if (field =="replace") {
				ShowReportItemEditWin(rowIndex);
			}
		},
		onLoadSuccess:function(data){
			PageLogicObj.m_dataSource=data.rows;
			PageLogicObj.m_sortArr=getSortArray(data.rows);
		}
	})
}
function ShowReportItemEditWin(rowIndex){
	var rows=$("#tabInterventionExtReportEditList").datagrid("getRows");
	PageLogicObj.m_SelItemID=rows[rowIndex].itemID;
	if (PageLogicObj.m_tabReportItemEditListGrid) {
		$('#tabReportItemEditList').datagrid("load");
	}else{
		InittabReportItemEditListGrid();
	}
	$("#ReportItemEditWin").window("setTitle","<font color=yellow>"+rows[rowIndex].taskdesc+"</font> 文书ID配置").window("open");
}
function InittabReportItemEditListGrid(){
	var Columns=[[  
		{ field: 'itemName',title:'任务子项描述',width:250},
		{ field: 'typeName',title:'子项控件类型',width:100},
		{ field: 'subItemName', title: '备选项',width:100},
		{ field: 'subTypeName',title:'备选项控件类型',width:110},
		{ field: 'subItemSortNo',title:'备选项排序',width:100},
		{ field: 'positionID',title:'文书替换id',width:200,
			editor:{
				type:'text'
			}
		}
	]];
	PageLogicObj.m_tabReportItemEditListGrid=$('#tabReportItemEditList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false, 
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : false, 
		idField:"subItemDR", 
		columns :Columns, 
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.InterventionSetting&QueryName=GetReportItemList",
		onBeforeLoad:function(param){
			$('#tabReportItemEditList').datagrid("unselectAll"); 
			//param = $.extend(param,{interventionDR:PageLogicObj.m_SelIntervid,itemDR:PageLogicObj.m_SelItemID,userID:session['LOGON.USERID'],hospDR:$HUI.combogrid('#_HospList').getValue()});
			//2758853【护理计划配置】业务界面整合
			param = $.extend(param,{
				interventionDR:PageLogicObj.m_SelIntervid,
				itemDR:PageLogicObj.m_SelItemID,
				userID:session['LOGON.USERID'],
				hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
			});
		},
		onLoadSuccess:function(data){
			$('#tabReportItemEditList').datagrid('mergeCells',{
				index: 0,
				field:"itemName",
				rowspan:data.total,
				colspan:1
			});
			for (var i=0;i<data.total;i++){
				$('#tabReportItemEditList').datagrid("beginEdit",i);           
			}
		}
	})
}
function ShowInterventionExtReportWin(row){
	PageLogicObj.m_SelIntervid=row.id;
	$("#IntCode").val(row.code);
	$('#IntItem').combobox("reload");
	setTimeout(function() {
		$("#IntItem").combobox("setValue",row.id);
	})
	InitInterventionContent(row.id);
	$("#tabInterventionExtReportEditList").datagrid("load");
	$("#InterventionExtReportEditWin").window('open');
}
//获取护理文书
function InitInterventionContent(intervid){
	$.cm({
		ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
		MethodName:"QueryInterventionContent",
		intervid:intervid,
		dataType:"text"
	},function(Json){
		if (Json!="") {
			Json=eval("("+Json+")");
			$("#InterventionContent").val(Json.data);
		}else{
			$("#InterventionContent").val("");
		}
	})
}
function SetInterventionExtReportEditWinData(){
	$("#IntCode,#InterventionContent").val("");
	$("#IntItem").combobox("setValue","");
	$("#tabInterventionExtReportEditList").datagrid("load");
}
function addChar(){
	var textVal=$("#InterventionContent").val();
	var newData= PageLogicObj.m_sortArr.filter(function(item){
		return textVal.indexOf("["+item+"]") == -1;
	})
	var  buttonChar = "";
	$.map(newData, function(item, i){
        buttonChar += "["+item+"]，";
    });
    if (newData[0] == undefined) {
        return;
    }
    textVal += buttonChar.slice(0, -1);
	$("#InterventionContent").val(textVal);
}
// 保存护理文书
function SaveItnExtReportClick(){
	var InterventionContent=$("#InterventionContent").val();
	if (!InterventionContent){
		$.messager.popover({msg:'护理文书描述不能为空！',type:'error'});
		$("#InterventionContent").focus();
		return false;
	}
	var sc=$.m({
		ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
		MethodName:"UpdateInterventionContent",
		intervid:PageLogicObj.m_SelIntervid,
		content:InterventionContent,
		//hospDR:$HUI.combogrid('#_HospList').getValue()
		//2758853【护理计划配置】业务界面整合
		hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
	},false)
	if (sc >=0){
		$("#InterventionExtReportEditWin").window("close");
		var index=$("#tabInterventionExtReportList").datagrid("getRowIndex",PageLogicObj.m_SelIntervid);
		$("#tabInterventionExtReportList").datagrid("updateRow",{
			index: index,
			row: {
				content:InterventionContent
			}		
		});
	}else{
		$.messager.alert("提示","保存失败!");
		return false;
	}
}
// 保存文书ID配置
function SaveReportItemClick(){
	var dataArray=new Array();
	var posIdArr=new Array();
	var selRows=$('#tabReportItemEditList').datagrid("getRows"); 
	for (var i=0;i<selRows.length;i++){
		var Editors=$('#tabReportItemEditList').datagrid("getEditors",i); 
		var positionID=$(Editors[0].target).val();
		if (!positionID) {
			$.messager.popover({msg:'文书替换id不能为空！',type:'error'});
			$(Editors[0].target).focus();
			return false;
		}
		dataArray.push({
			//subItemDR: selRows[0].subItemDR,  bug fix
			subItemDR: selRows[i].subItemDR,
			positionID: positionID
		});
		posIdArr.push(positionID);
	}
	$.m({
		ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
		MethodName:"SaveReportItem",
		locID:session['LOGON.CTLOCID'],
		userID:session['LOGON.USERID'],
		interventionDR:PageLogicObj.m_SelIntervid,
		itemDR:PageLogicObj.m_SelItemID,
		dataArray:JSON.stringify(dataArray), 
		//hospDR:$HUI.combogrid('#_HospList').getValue()
		//2758853【护理计划配置】业务界面整合
		hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
	},function(rtn){
		if (rtn==0){
			$("#ReportItemEditWin").window("close");
			var index=$('#tabInterventionExtReportEditList').datagrid('getRowIndex',PageLogicObj.m_SelItemID);
			$('#tabInterventionExtReportEditList').datagrid('updateRow',{
				index:index ,
				row: {
					replace: posIdArr.join()
				}
			});	
			var index=$.hisui.indexOfArray(PageLogicObj.m_dataSource,"itemID",PageLogicObj.m_SelItemID);
			PageLogicObj.m_dataSource[index].replace=posIdArr.join();
			PageLogicObj.m_sortArr=getSortArray(PageLogicObj.m_dataSource);
		}else{
			$.messager.alert("提示","保存失败!");
			return false;
		}
	})
}
function compare(property) {
	return function(firstobj, secondobj){
		var  firstValue = firstobj[property];
	    var  secondValue = secondobj[property];
	    if ((firstValue)&&(secondValue)) {
		    return firstValue - secondValue ; //升序
	    }else{
		    return true;
	    }
	}
}
function getSortArray(data){
	var arr = [];
	data.forEach(function(item) {
		if (typeof item.replace == "number") {
			arr.push(item.replace);
		}else {
			var res = item.replace.split(/,|\^/);
			res.forEach(function(item) {
				if (item ==="") return;
				arr.push(parseInt(item));
			})
		}
	})
	return arr.sort(function(a, b){
		return a - b;
	});
}
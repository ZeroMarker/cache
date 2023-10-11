/**
* @author songchunli
* HISUI 措施对任务配置主js
* InterventionLinkTaskSetting.js
*/
var PageLogicObj={
	m_SelRelationId:"",
	m_SelTaskObj:{},
	delInterventionSubItemArr:[],
	m_tabTaskEditListGrid:"",
	iframeflag:"0", //2758853【护理计划配置】业务界面整合  是否是iframe 界面  1：是； 0：否
	selectInterventionRowID:"",
	
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
	InitInterventionLinkTaskEditWin();
})
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabInterventionLinkTaskList").datagrid("reload");
	});
	$("#SearchDesc").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			$("#tabInterventionLinkTaskList").datagrid("reload");
		}
	});
	$("#BSaveTaskItem").click(function(){
		SaveTaskItemClick(true);
	});
	$("#BIntLinkTaskSave").click(function(){
		SaveTaskItemClick(false);
	});
	$("#BSaveInterventionItemExt").click(SaveInterventionItemExtClick);
	$("#BCancel").click(function(){
		$("#InterventionLinkTaskEditWin").window('close');
	});
	$("#BTaskEditWinCancel").click(function(){
		$("#TaskEditWin").window('close');
	});
	$("#IntLinkTaskAdd").click(IntLinkTaskAddClick);
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_InterventionItem");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#SearchDesc").val("");
		$.extend(PageLogicObj,{m_SelRelationId:"",delInterventionSubItemArr:[],m_SelTaskObj:{}});
		$("#tabInterventionLinkTaskList").datagrid("load");
		// 措施
		InitIntItem();
		//措施小项-任务
		InitTaskItem();
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
				$("#tabInterventionLinkTaskList").datagrid("load");
			}
		},
		onUnselect:function(rec){
			$("#tabInterventionLinkTaskList").datagrid("load");
		},
		onAllSelectClick:function(e){
			$("#tabInterventionLinkTaskList").datagrid("load");
		}
	});
}
function ResetInterventionLinkTaskEditWin(){
	var innerHeight = window.innerHeight;
	var innerWidth= window.innerWidth;
	if (PageLogicObj.iframeflag=="1"){
		$("#InterventionLinkTaskEditWin").parent().css({width:innerWidth,})
		$("#InterventionLinkTaskEditWin").parent().find(".panel-header").css({width:innerWidth,})
		$("#InterventionLinkTaskEditWin").css({
			height:innerHeight-40,
			width:innerWidth,
		});
		/*
		$("#intitem-layout").layout("resize",{width:innerWidth,height:innerHeight});
		$("#intitem-layout").layout("resize").layout('panel', 'center').panel('resize', {
	        width: innerWidth,
	        height:innerHeight-150,
    	});
    	*/
    	$("#tabInterventionLinkTaskList").datagrid("resize",{width:'98%',height:'90%'});

    }	
	
}
function InitInterventionLinkTaskList(){
	var ToolBar = [{
            text: '新增',
            iconCls: 'icon-add',
            handler: function() {
	           	//2758853【护理计划配置】业务界面整合
	           	ResetInterventionLinkTaskEditWin();
				if (PageLogicObj.iframeflag=="1"){
					var irow =$(window.parent.$("#iframeInterventions"))[0].contentWindow.$("#tabInterventionsList").datagrid("getSelected");
					if ((!irow)||(irow.intRowID!=PageLogicObj.selectInterventionRowID)){
						$.messager.popover({msg:'请选择一个护理措施！',type:'error'});
						return false;
					}
					var row = $("#tabInterventionLinkTaskList").datagrid('getRows')[0];
					if (row) {
						ShowInterventionLinkTaskWin(row);	
					}
					else{
						$('#IntItem').combobox("select",PageLogicObj.selectInterventionRowID);
					}			
				}
				$("#InterventionLinkTaskEditWin").window('open');
            }
        },{
            text: '修改',
            iconCls: 'icon-write-order',
            handler: function() {
	            ResetInterventionLinkTaskEditWin();
	            var row = $("#tabInterventionLinkTaskList").datagrid("getSelected");
				if (!row) {
					$.messager.popover({msg:'请选择需要修改的记录！',type:'error'});
					return false;
				}
				ShowInterventionLinkTaskWin(row);
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
				DeleteInterventionLinkTask();
            }
        },"-",{
	        id:'interventionitemsetting',
	        text:'任务项配置',
	        iconCls: 'icon-set-col',
	        handler:function(){
		        window.parent.window.addiFrametoEditWindow(" nur.hisui.interventionitemsetting.csp","任务项配置",850,700);
		    }
		}];
	var Columns=[[    //intervid 
		{ field: 'invercode',title:'措施编码',width:100},
		{ field: 'invershort',title:'措施短描述',width:400,wordBreak:"break-all"},
		{ field: 'itemcode',title:'任务子项编码',width:100},
		{ field: 'itemdesc',title:'任务子项描述',width:350,wordBreak:"break-all"},
		{ field: 'widget',title:'控件类型',width:100,},
		{ field: 'replaceIds',title:'文书替换ID',width:100,},
		{ field: 'itemorder',title:'子项排序',width:90},
		{ field: 'status',title:'状态',width:60,
			styler: function(value,row,index){
				if (value =="开启"){
					return "color:#3FBD79;"
				}else{
					return "color:#F16E57;"
				}
			}
		}
    ]];
	$('#tabInterventionLinkTaskList').datagrid({  
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
		idField:"relationid", //taskid
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryInterventionTask",
		onBeforeLoad:function(param){
			var status=$("#status").combobox('getValues');
			if (status.length ==1){
				status=status.join("");
			}else{
				status="";
			}
			$.extend(PageLogicObj,{m_SelRelationId:""});
			$('#tabInterventionLinkTaskList').datagrid("unselectAll");
			//param = $.extend(param,{desc:$("#SearchDesc").val(),statusIn:status,hospitalID:$HUI.combogrid('#_HospList').getValue()});
			//2758853【护理计划配置】业务界面整合
			param = $.extend(param,{desc:$("#SearchDesc").val(),statusIn:status,hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		
		
		},
		onDblClickRow:function(rowIndex, rowData){
			ShowInterventionLinkTaskWin(rowData);
		},
		onLoadSuccess:function(){
			//2758853【护理计划配置】业务界面整合
			if(PageLogicObj.iframeflag=="1"){
				$('#tabInterventionLinkTaskList').datagrid("hideColumn", "invercode");
				$('#tabInterventionLinkTaskList').datagrid("hideColumn", "invershort");
			
			}
		}
	})
}
//2758853【护理计划配置】业务界面整合
function ReloadInterventionLinkTaskList(rowID){
	if (rowID) PageLogicObj.selectInterventionRowID=rowID;
	$('#tabInterventionLinkTaskList').datagrid('load',{
		desc:$("#SearchDesc").val(),
		statusIn:status,
		hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),
		RowID:rowID
	})
}

function InitEditWindow(){
    $("#InterventionLinkTaskEditWin" ).window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
			SetInterventionLinkTaskEditWinData();
	   }
	});
	$("#TaskEditWin").window({
		modal: true,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:true
	 });
}
function InitInterventionLinkTaskEditWin(){
	// 措施
	InitIntItem();
	//措施小项-任务
	InitTaskItem();
	InittabInterventionLinkTaskEditList();
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
				$("#tabInterventionLinkTaskEditList").datagrid("load");
			}
		}
    });
}
function InitTaskItem(){
	$('#TaskItem').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryTask&rows=99999&ResultSetType=array",
		valueField:'rowid',
		textField:'taskname',
		mode: "remote",
		onBeforeLoad:function(param){
			//param = $.extend(param,{name:param["q"],statusFlag:"1",hospitalID:$HUI.combogrid('#_HospList').getValue()});
			//2758853【护理计划配置】业务界面整合
			param = $.extend(param,{name:param["q"],statusFlag:"1",hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
				
		}
    });
}
function InittabInterventionLinkTaskEditList(){
	var Columns=[[    
		{ field: 'taskcode',title:'任务子项编码',width:100},
		{ field: 'taskname',title:'任务子项',width:130,wordBreak:"break-all"},
		{ field: 'order', title: '子项排序',width:70, editor:{type:'text'}},
		{ field: 'reqFlagId', title: '是否必填',width:70,align:"center",
			editor:{
				type:'icheckbox',
				options:{on:'Y',off:'N'}
			},
			formatter: function(value,row,index){
				return row.reqFlag;
			}
		},
		{ 
			field: 'subItems', 
			title: '备选项',
			width:210,
			wordBreak:"break-all",
			styler: function(subItems,row,index){
				var count=$cm({
					ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
					MethodName:"countNIVITS",
					HospitalDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()), 
					ItemDR:row.taskid
				},false);				
				if (count>0) return "background-color:#fda632;color:white;";
			}
		},
		{ field: 'start', title: '启用日期',width:115,
			editor:{
				type:'datebox'
			}
		},
		{ field: 'end', title: '停用日期',width:115,
			editor:{
				type:'datebox'
			}
		},
		{ field: 'Action', title: '操作',width:90,
			formatter:function(value,row,index){
				var d = "<a href='#' onclick='DeleteTaskRow(this)'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/></a>";
					//d += "<a href='#' onclick='MoveTopTaskRow(this)' style='margin:0 5px;'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/arrow_top.png' border=0/></a>";
					//d += "<a href='#' onclick='MoveDownTaskRow(this)'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/arrow_bottom.png' border=0/></a>";
				return d;
			}
		}
	]];
	$('#tabInterventionLinkTaskEditList').datagrid({  
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
		idField:"relationid",
		columns :Columns, 
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryInterventionTaskByInterventionCode",
		onBeforeLoad:function(param){
			PageLogicObj.m_SelTaskObj={};
			PageLogicObj.delInterventionSubItemArr=[];
			$('#tabInterventionLinkTaskEditList').datagrid("unselectAll");
			//param = $.extend(param,{code:$("#IntCode").val(),hospitalID:$HUI.combogrid('#_HospList').getValue()});
			//2758853【护理计划配置】业务界面整合
			param = $.extend(param,{code:$("#IntCode").val(),hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		},
		onDblClickCell:function(rowIndex, field, value){
			if (field =="subItems") {
				var rows=$("#tabInterventionLinkTaskEditList").datagrid("getRows");
				$("#TaskName").val(rows[rowIndex].taskname);
				PageLogicObj.m_SelTaskObj=rows[rowIndex];
				if (PageLogicObj.m_tabTaskEditListGrid) {
					$('#tabTaskEditList').datagrid("load");
				}else{
					InittabTaskEditListGrid();
				}
				$("#TaskEditWin").window("open");
			}else{
				$('#tabInterventionLinkTaskEditList').datagrid("beginEdit",rowIndex);
			}
		},
		loadFilter: function(data){
			if (data.total) {
				data.rows = data.rows.sort(compare("order"));
			}
			return data;
		},
		onLoadSuccess:function(data){
			if (PageLogicObj.m_SelRelationId) {
				var index=$("#tabInterventionLinkTaskEditList").datagrid("getRowIndex",PageLogicObj.m_SelRelationId);
				if (index >=0) {
					$('#tabInterventionLinkTaskEditList').datagrid("beginEdit",index);
				}
			}
			
		}
	})
}

function InittabTaskEditListGrid(){
	//subItemName:%String:备选项,typeName:%String:备选项控件类型,sortNo:%String:备选项排序,
	//subId:%String:hidden,typeId:%String:hidden,check:%String:hidden,positionID:%String:hidden
	var Columns=[[  
		{ field: 'subId',checkbox:'true'},
		{ field: 'subItemName',title:'备选项',width:150},
		{ field: 'typeName',title:'备选项控件类型',width:150,wordBreak:"break-all"},
		{ field: 'sortNo', title: '备选项排序',width:100,
			editor:{
				type:'numberbox'
			}
		}
	]];
	PageLogicObj.m_tabTaskEditListGrid=$('#tabTaskEditList').datagrid({  
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
		idField:"subId", 
		columns :Columns, 
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.InterventionSetting&QueryName=GetSubItemList",
		onBeforeLoad:function(param){
			$('#tabTaskEditList').datagrid("unselectAll");
			//param = $.extend(param,{interventionDR:PageLogicObj.m_SelTaskObj.interid,itemDR:PageLogicObj.m_SelTaskObj.taskid,hospDR:$HUI.combogrid('#_HospList').getValue()});
			//2758853【护理计划配置】业务界面整合
			param = $.extend(param,{interventionDR:PageLogicObj.m_SelTaskObj.interid,itemDR:PageLogicObj.m_SelTaskObj.taskid,hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		},
		onLoadSuccess:function(data){
			for (var i=0;i<data.total;i++){
				var check=data.rows[i].check;
				if (check =="1") {
					$('#tabTaskEditList').datagrid("selectRow",i);           
				} 
			}
		},
		onSelect:function(rowIndex, rowData){
			$('#tabTaskEditList').datagrid("beginEdit",rowIndex);  
		},
		onUnselect:function(rowIndex, rowData){
			$('#tabTaskEditList').datagrid("endEdit",rowIndex);  
		},
		onUnselectAll:function(rows){
			for (var i=0;i<rows.length;i++){
				$('#tabTaskEditList').datagrid("endEdit",i);   
			}
		},
		onSelectAll:function(rows){
			for (var i=0;i<rows.length;i++){
				$('#tabTaskEditList').datagrid("beginEdit",i);   
			}
		}
	})
}
function ShowInterventionLinkTaskWin(row){
	PageLogicObj.m_SelRelationId=row.relationid;
	$("#IntCode").val(row.invercode);
	//$("#IntItem").combobox("setValue",row.intervid);
	$("#IntItem").combobox("setValue",row.IDintervid);
	$("#tabInterventionLinkTaskEditList").datagrid("load");
	$("#InterventionLinkTaskEditWin").window('open');
}
function SetInterventionLinkTaskEditWinData(){
	$("#IntCode").val("");
	$("#IntItem,#TaskItem").combobox("setValue","").combobox("reload");
	$("#tabInterventionLinkTaskEditList").datagrid("load");
}
function DeleteTaskRow(target){
	var Msg="确定要删除此条措施任务吗？";
		Msg += '</br><sapn style="opacity:0.65;">此措施任务删除后，点击确定保存删除结果.</sapn>';
	$.messager.confirm('确认对话框', Msg, function(r){
		if (r) {
			var tr = $(target).closest('tr.datagrid-row');
			var index=parseInt(tr.attr('datagrid-row-index'));
			var rows=$("#tabInterventionLinkTaskEditList").datagrid("getRows");
			var rowid=rows[index].relationid;
			if (rowid) {
				PageLogicObj.delInterventionSubItemArr.push({
					"reldr":rows[index].relationid,
					"startdate":rows[index].start,
					"enddate":rows[index].end,
					"itervdr":rows[index].interid,
					"itemdr":rows[index].taskid,
					"subItems":rows[index].subItems,
					"reqflag":rows[index].reqFlagId,
					"order":rows[index].order,
					"del":1
				});
			}
			$('#tabInterventionLinkTaskEditList').datagrid('deleteRow', index);
		}
	});
}
function MoveTopTaskRow(target){
	var tr = $(target).closest('tr.datagrid-row');
	var index=parseInt(tr.attr('datagrid-row-index'));
	if (index ==0) {
		return;
	}
	var targetEditors=$('#tabInterventionLinkTaskEditList').datagrid("getEditors",index-1);
	if (targetEditors.length) {
		var reqFlagId=$(targetEditors[0].target).checkbox("getValue")?"Y":"N";
		var reqFlag=(reqFlagId =="Y")?"是":"否";
		$('#tabInterventionLinkTaskEditList').datagrid('updateRow',{
			index: index-1,
			row: {
				reqFlagId: reqFlagId,
				reqFlag: reqFlag,
				start: $(targetEditors[1].target).datebox("getValue"),
				end: $(targetEditors[2].target).datebox("getValue"),
			}
		});
	}
	var sourceEditors=$('#tabInterventionLinkTaskEditList').datagrid("getEditors",index);
	if (sourceEditors.length) {
		var reqFlagId=$(sourceEditors[0].target).checkbox("getValue")?"Y":"N";
		var reqFlag=(reqFlagId =="Y")?"是":"否";
		$('#tabInterventionLinkTaskEditList').datagrid('updateRow',{
			index: index,
			row: {
				reqFlagId: reqFlagId,
				reqFlag: reqFlag,
				start: $(sourceEditors[1].target).datebox("getValue"),
				end: $(sourceEditors[2].target).datebox("getValue"),
			}
		});
	}
	var rows=$("#tabInterventionLinkTaskEditList").datagrid("getRows");

	var sourceObj=rows[index];
	var targetObj=rows[index-1];

	var sourceOrder=rows[index].order;
	var targetOrder=rows[index-1].order;

	sourceObj.order=targetOrder;
	targetObj.order=sourceOrder;
	rows[index] = targetObj;
    rows[index - 1] = sourceObj;
	$('#tabInterventionLinkTaskEditList').datagrid('refreshRow', index);
    $('#tabInterventionLinkTaskEditList').datagrid('refreshRow', index - 1).datagrid('selectRow', index - 1);
	if (sourceEditors.length >0) {
		$('#tabInterventionLinkTaskEditList').datagrid('beginEdit', index-1);
	}
	if (targetEditors.length >0){
		$('#tabInterventionLinkTaskEditList').datagrid('beginEdit', index);
	}
}
function MoveDownTaskRow(target){
	var tr = $(target).closest('tr.datagrid-row');
	var index=parseInt(tr.attr('datagrid-row-index'));
	var rows=$("#tabInterventionLinkTaskEditList").datagrid("getRows");
	if (index == (rows.length-1)){
		return;
	}
	var targetEditors=$('#tabInterventionLinkTaskEditList').datagrid("getEditors",index+1);
	if (targetEditors.length) {
		var reqFlagId=$(targetEditors[0].target).checkbox("getValue")?"Y":"N";
		var reqFlag=(reqFlagId =="Y")?"是":"否";
		$('#tabInterventionLinkTaskEditList').datagrid('updateRow',{
			index: index+1,
			row: {
				reqFlagId: reqFlagId,
				reqFlag: reqFlag,
				start: $(targetEditors[1].target).datebox("getValue"),
				end: $(targetEditors[2].target).datebox("getValue"),
			}
		});
	}
	var sourceEditors=$('#tabInterventionLinkTaskEditList').datagrid("getEditors",index);
	if (sourceEditors.length) {
		var reqFlagId=$(sourceEditors[0].target).checkbox("getValue")?"Y":"N";
		var reqFlag=(reqFlagId =="Y")?"是":"否";
		$('#tabInterventionLinkTaskEditList').datagrid('updateRow',{
			index: index,
			row: {
				reqFlagId: reqFlagId,
				reqFlag: reqFlag,
				start: $(sourceEditors[1].target).datebox("getValue"),
				end: $(sourceEditors[2].target).datebox("getValue"),
			}
		});
	}
	var rows=$("#tabInterventionLinkTaskEditList").datagrid("getRows");

	var sourceObj=rows[index];
	var targetObj=rows[index+1];

	var sourceOrder=rows[index].order;
	var targetOrder=Number(rows[index+1].order) + 1;

	sourceObj.order=targetOrder;
	targetObj.order=sourceOrder;
	rows[index] = targetObj;
    rows[index + 1] = sourceObj;
	$('#tabInterventionLinkTaskEditList').datagrid('refreshRow', index);
    $('#tabInterventionLinkTaskEditList').datagrid('refreshRow', index + 1).datagrid('selectRow', index + 1);
	if (sourceEditors.length >0) {
		$('#tabInterventionLinkTaskEditList').datagrid('beginEdit', index+1);
	}
	if (targetEditors.length >0){
		$('#tabInterventionLinkTaskEditList').datagrid('beginEdit', index);
	}
}
function DeleteInterventionLinkTask(){
	var selected = $("#tabInterventionLinkTaskList").datagrid("getSelected");
	if (!selected) {
		$.messager.popover({msg:'请选择需要删除的记录！',type:'error'});
		return false;
	}
	var Msg="确定要删除此条措施任务吗？";
		Msg += '</br><sapn style="opacity:0.65;">此措施任务删除后，护理措施将不会自动带出该措施任务.</sapn>';
	$.messager.confirm('提示',Msg,function(r){   
		if (r){
			var rtn=$.m({
				ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
				MethodName:"DeleteInterventionTaskLink",
				rowID:selected.relationid
			},false)
			if (rtn !=0) {
				$.messager.popover({msg:'删除失败！',type:'error'});
				return false;
			}else{
				var Index=$('#tabInterventionLinkTaskList').datagrid('getRowIndex',selected.relationid);
				$('#tabInterventionLinkTaskList').datagrid('deleteRow', Index);
			}
		}
	}); 
}
// 新增措施小项到表格
function IntLinkTaskAddClick(){
	var IntItem=$("#IntItem").combobox("getValue");
	if (!IntItem) {
		$.messager.popover({msg:'请选择措施！',type:'error'});
		$("#IntItem").next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($("#IntItem").combobox("getData"),"rowID",IntItem) <0){
		$.messager.popover({msg:'请在下拉框中选择措施！',type:'error'});
		$("#IntItem").next('span').find('input').focus();
		return false;
	}
	var TaskData=$("#TaskItem").combobox("getData");
	var TaskItem=$("#TaskItem").combobox("getValue");
	if (!TaskItem) {
		$.messager.popover({msg:'请选择措施小项！',type:'error'});
		$("#TaskItem").next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray(TaskData,"rowid",TaskItem) <0){
		$.messager.popover({msg:'请在下拉框中选择措施！',type:'error'});
		$("#IntItem").next('span').find('input').focus();
		return false;
	}
	var index=$.hisui.indexOfArray(TaskData,"rowid",TaskItem);
	var TaskObj=TaskData[index];
	var  rows=$("#tabInterventionLinkTaskEditList").datagrid("getRows")
	if ($.hisui.indexOfArray(rows,"taskid",TaskItem) >=0){
		$.messager.popover({msg:'该措施小项已存在,不能重复添加！',type:'error'});
		$("#TaskItem").next('span').find('input').focus();
		return false;
	}
	$("#tabInterventionLinkTaskEditList").datagrid('appendRow',{
		taskcode:TaskObj.code,
		taskname:TaskObj.taskname,
		order:rows.length+1,
		reqFlag:"否",
		subItems:"",
		start:ServerObj.CurrentDate,
		end:"",
		relationid:"",
		taskid:TaskItem,
		interid:IntItem,
		reqFlagId:"N"
	});
	$("#tabInterventionLinkTaskEditList").datagrid("beginEdit",rows.length-1);
}
// 保存措施对任务
function SaveTaskItemClick(flag){
	//flag:true确定，false保存
	var dataArray=new Array();
	var rows=$("#tabInterventionLinkTaskEditList").datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		var Editors=$('#tabInterventionLinkTaskEditList').datagrid("getEditors",i);
		if (Editors.length >0){
			var orderValue = $(Editors[0].target).val()
			var reqflag=$(Editors[1].target).checkbox("getValue")?"Y":"N";
			var startdate=$(Editors[2].target).datebox("getValue");
			if (!startdate) {
				$.messager.popover({msg:'第'+(i+1)+'行，请选择启用日期！',type:'error'});
				$(Editors[2].target).next('span').find('input').focus();
				return false;
			}
			var enddate=$(Editors[3].target).datebox("getValue");
			if ((enddate)&&(CompareDate(startdate,enddate))) {
				$.messager.popover({msg:'停用日期不能早于启用日期！',type:'error'});
				$(Editors[3].target).next('span').find('input').focus();
				return false;
			}
			dataArray.push({
				"reldr":rows[i].relationid,
				"startdate":startdate,
				"enddate":enddate,
				"itervdr":rows[i].interid,
				"itemdr":rows[i].taskid,
				"subItems":rows[i].subItems,
				"reqflag":reqflag,
				"del":"",
				"order":orderValue,  //rows[i].order,
				"editable":true
			});
		}else{
			dataArray.push({
				"reldr":rows[i].relationid,
				"startdate":rows[i].start,
				"enddate":rows[i].end,
				"itervdr":rows[i].interid,
				"itemdr":rows[i].taskid,
				"subItems":rows[i].subItems,
				"reqflag":rows[i].reqFlagId,
				"del":"",
				"order":rows[i].order
			});
		}
	}
	//flag:true确定，false保存
	if (!dataArray.length && !PageLogicObj.delInterventionSubItemArr.length) {
		if (flag) {
			$.messager.popover({msg:'请选择措施，新增措施小项！',type:'error'});
			return false;
		}else{
			$.messager.popover({msg:'没有要保存的任务！',type:'error'});
			return false;
		}
	}
	dataArray=dataArray.concat(PageLogicObj.delInterventionSubItemArr);
	var sc=$.m({
		ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
		MethodName:"SaveInterventionTaskLink",
		dataArray:JSON.stringify(dataArray),
		optID:session['LOGON.USERID'],
		//hospDR:$HUI.combogrid('#_HospList').getValue()
		//2758853【护理计划配置】业务界面整合
		hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
		
	},false)
	if (sc ==0){
		PageLogicObj.delInterventionSubItemArr=[];
		if (flag) {
			$("#InterventionLinkTaskEditWin").window("close");
		}else{
			$("#tabInterventionLinkTaskEditList").datagrid("load");
		}
		$("#tabInterventionLinkTaskList").datagrid("reload");
	}else{
		if (sc=="-120") {
			$.messager.popover({msg:'保存失败!存在重复的任务子项排序序号！',type:'error'});
		}else{
			$.messager.popover({msg:'保存失败!',type:'error'});
		}
		return false;
	}
}
// 保存备选项排序
function SaveInterventionItemExtClick(){
	var reg = /^[1-9]*[1-9][0-9]*$/;
	var dataArray=new Array();
	var selRows=$('#tabTaskEditList').datagrid("getSelections"); 
	for (var i=0;i<selRows.length;i++){
		var subId=selRows[i].subId;
		var subItemName=selRows[i].subItemName;
		var index=$('#tabTaskEditList').datagrid("getRowIndex",subId);
		var Editors=$('#tabTaskEditList').datagrid("getEditors",index); 
		var sortNo=$(Editors[0].target).val();
		if (!sortNo) {
			$.messager.popover({msg:'选择的备选项排序不能为空！',type:'error'});
			$(Editors[0].target).focus();
			return false;
		}else  if (!reg.test(sortNo)) {
			$.messager.popover({msg:'选择的备选项排序只能为大于0的正整数！',type:'error'});
			$(Editors[0].target).focus();
			return false;
		}
		dataArray.push({
			subId: subId,
			sortNo: sortNo,
			name: subItemName
		});
	}
	if (dataArray.length){
		dataArray = dataArray.sort(compare("sortNo"));
	}
	var optionStr="";
	dataArray = $.map(dataArray, function(elem, i){
		optionStr += elem.sortNo + "-" + elem.name + ",";
        delete elem.name;
		return elem;
    });
	optionStr=optionStr.slice(0, -1);
	$.m({
		ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
		MethodName:"SaveInterventionItemExt",
		interventionDR:PageLogicObj.m_SelTaskObj.interid, 
		dataArray:JSON.stringify(dataArray), 
		userId:session['LOGON.USERID'],
		taskid:PageLogicObj.m_SelTaskObj.taskid,
		//hospDR:$HUI.combogrid('#_HospList').getValue()
		//2758853【护理计划配置】业务界面整合
		hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
		
	},function(rtn){
		if (rtn==0){
			$("#TaskEditWin").window("close");
			var index=$('#tabInterventionLinkTaskEditList').datagrid('getRowIndex',PageLogicObj.m_SelTaskObj.relationid);
			$('#tabInterventionLinkTaskEditList').datagrid('updateRow',{
				index:index ,
				row: {
					subItems: optionStr
				}
			});	
			var Editors=$('#tabInterventionLinkTaskEditList').datagrid("getEditors",index); 
			if (Editors.length){
				$('#tabInterventionLinkTaskEditList').datagrid("beginEdit",index); 
			}
		}else{
			$.messager.alert("提示","保存失败!");
			return false;
		}
	})
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (dtseparator=="-") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (dtseparator=="/") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(dtseparator=="/"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function CompareDate(date1,date2){
	var date1 = myparser(date1);
	var date2 = myparser(date2); 
	//if(date2<=date1){  
	if(date2<date1){
		return true;  
	} 
	return false;
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

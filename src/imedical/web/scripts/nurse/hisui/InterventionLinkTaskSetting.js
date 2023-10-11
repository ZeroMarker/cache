/**
* @author songchunli
* HISUI ��ʩ������������js
* InterventionLinkTaskSetting.js
*/
var PageLogicObj={
	m_SelRelationId:"",
	m_SelTaskObj:{},
	delInterventionSubItemArr:[],
	m_tabTaskEditListGrid:"",
	iframeflag:"0", //2758853������ƻ����á�ҵ���������  �Ƿ���iframe ����  1���ǣ� 0����
	selectInterventionRowID:"",
	
}
$(function(){ 
	//2758853������ƻ����á�ҵ���������
	var iframeflag=""
	if (window.parent.window.PageLogicObj){
		iframeflag=window.parent.window.PageLogicObj.iframeflag
	}
	if(iframeflag=="1"){
		PageLogicObj.iframeflag=iframeflag
		Init();		   			// iframe ����
	}
	else if ((iframeflag== "")||(iframeflag=="0")){
		InitHospList();			// ��������
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
		// ��ʩ
		InitIntItem();
		//��ʩС��-����
		InitTaskItem();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	// ��ʼ�� ״̬��ѯ����
	InitStatus();
	InitInterventionLinkTaskList();
}
function InitStatus(){
	$("#status").combobox({
		valueField:'id',
		textField:'text',
		mode: "local",
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		data:[{"id":"1","text":"����"},{"id":"2","text":"ͣ��"}],
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
            text: '����',
            iconCls: 'icon-add',
            handler: function() {
	           	//2758853������ƻ����á�ҵ���������
	           	ResetInterventionLinkTaskEditWin();
				if (PageLogicObj.iframeflag=="1"){
					var irow =$(window.parent.$("#iframeInterventions"))[0].contentWindow.$("#tabInterventionsList").datagrid("getSelected");
					if ((!irow)||(irow.intRowID!=PageLogicObj.selectInterventionRowID)){
						$.messager.popover({msg:'��ѡ��һ�������ʩ��',type:'error'});
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
            text: '�޸�',
            iconCls: 'icon-write-order',
            handler: function() {
	            ResetInterventionLinkTaskEditWin();
	            var row = $("#tabInterventionLinkTaskList").datagrid("getSelected");
				if (!row) {
					$.messager.popover({msg:'��ѡ����Ҫ�޸ĵļ�¼��',type:'error'});
					return false;
				}
				ShowInterventionLinkTaskWin(row);
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
				DeleteInterventionLinkTask();
            }
        },"-",{
	        id:'interventionitemsetting',
	        text:'����������',
	        iconCls: 'icon-set-col',
	        handler:function(){
		        window.parent.window.addiFrametoEditWindow(" nur.hisui.interventionitemsetting.csp","����������",850,700);
		    }
		}];
	var Columns=[[    //intervid 
		{ field: 'invercode',title:'��ʩ����',width:100},
		{ field: 'invershort',title:'��ʩ������',width:400,wordBreak:"break-all"},
		{ field: 'itemcode',title:'�����������',width:100},
		{ field: 'itemdesc',title:'������������',width:350,wordBreak:"break-all"},
		{ field: 'widget',title:'�ؼ�����',width:100,},
		{ field: 'replaceIds',title:'�����滻ID',width:100,},
		{ field: 'itemorder',title:'��������',width:90},
		{ field: 'status',title:'״̬',width:60,
			styler: function(value,row,index){
				if (value =="����"){
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
		loadMsg : '������..',  
		pagination : true, 
		rownumbers : true,
		idField:"relationid", //taskid
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*�˴�Ϊfalse*/
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
			//2758853������ƻ����á�ҵ���������
			param = $.extend(param,{desc:$("#SearchDesc").val(),statusIn:status,hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		
		
		},
		onDblClickRow:function(rowIndex, rowData){
			ShowInterventionLinkTaskWin(rowData);
		},
		onLoadSuccess:function(){
			//2758853������ƻ����á�ҵ���������
			if(PageLogicObj.iframeflag=="1"){
				$('#tabInterventionLinkTaskList').datagrid("hideColumn", "invercode");
				$('#tabInterventionLinkTaskList').datagrid("hideColumn", "invershort");
			
			}
		}
	})
}
//2758853������ƻ����á�ҵ���������
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
	// ��ʩ
	InitIntItem();
	//��ʩС��-����
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
			//2758853������ƻ����á�ҵ���������
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
			//2758853������ƻ����á�ҵ���������
			param = $.extend(param,{name:param["q"],statusFlag:"1",hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
				
		}
    });
}
function InittabInterventionLinkTaskEditList(){
	var Columns=[[    
		{ field: 'taskcode',title:'�����������',width:100},
		{ field: 'taskname',title:'��������',width:130,wordBreak:"break-all"},
		{ field: 'order', title: '��������',width:70, editor:{type:'text'}},
		{ field: 'reqFlagId', title: '�Ƿ����',width:70,align:"center",
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
			title: '��ѡ��',
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
		{ field: 'start', title: '��������',width:115,
			editor:{
				type:'datebox'
			}
		},
		{ field: 'end', title: 'ͣ������',width:115,
			editor:{
				type:'datebox'
			}
		},
		{ field: 'Action', title: '����',width:90,
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
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : false, 
		idField:"relationid",
		columns :Columns, 
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryInterventionTaskByInterventionCode",
		onBeforeLoad:function(param){
			PageLogicObj.m_SelTaskObj={};
			PageLogicObj.delInterventionSubItemArr=[];
			$('#tabInterventionLinkTaskEditList').datagrid("unselectAll");
			//param = $.extend(param,{code:$("#IntCode").val(),hospitalID:$HUI.combogrid('#_HospList').getValue()});
			//2758853������ƻ����á�ҵ���������
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
	//subItemName:%String:��ѡ��,typeName:%String:��ѡ��ؼ�����,sortNo:%String:��ѡ������,
	//subId:%String:hidden,typeId:%String:hidden,check:%String:hidden,positionID:%String:hidden
	var Columns=[[  
		{ field: 'subId',checkbox:'true'},
		{ field: 'subItemName',title:'��ѡ��',width:150},
		{ field: 'typeName',title:'��ѡ��ؼ�����',width:150,wordBreak:"break-all"},
		{ field: 'sortNo', title: '��ѡ������',width:100,
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
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : false, 
		idField:"subId", 
		columns :Columns, 
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.InterventionSetting&QueryName=GetSubItemList",
		onBeforeLoad:function(param){
			$('#tabTaskEditList').datagrid("unselectAll");
			//param = $.extend(param,{interventionDR:PageLogicObj.m_SelTaskObj.interid,itemDR:PageLogicObj.m_SelTaskObj.taskid,hospDR:$HUI.combogrid('#_HospList').getValue()});
			//2758853������ƻ����á�ҵ���������
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
	var Msg="ȷ��Ҫɾ��������ʩ������";
		Msg += '</br><sapn style="opacity:0.65;">�˴�ʩ����ɾ���󣬵��ȷ������ɾ�����.</sapn>';
	$.messager.confirm('ȷ�϶Ի���', Msg, function(r){
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
		var reqFlag=(reqFlagId =="Y")?"��":"��";
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
		var reqFlag=(reqFlagId =="Y")?"��":"��";
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
		var reqFlag=(reqFlagId =="Y")?"��":"��";
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
		var reqFlag=(reqFlagId =="Y")?"��":"��";
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
		$.messager.popover({msg:'��ѡ����Ҫɾ���ļ�¼��',type:'error'});
		return false;
	}
	var Msg="ȷ��Ҫɾ��������ʩ������";
		Msg += '</br><sapn style="opacity:0.65;">�˴�ʩ����ɾ���󣬻����ʩ�������Զ������ô�ʩ����.</sapn>';
	$.messager.confirm('��ʾ',Msg,function(r){   
		if (r){
			var rtn=$.m({
				ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
				MethodName:"DeleteInterventionTaskLink",
				rowID:selected.relationid
			},false)
			if (rtn !=0) {
				$.messager.popover({msg:'ɾ��ʧ�ܣ�',type:'error'});
				return false;
			}else{
				var Index=$('#tabInterventionLinkTaskList').datagrid('getRowIndex',selected.relationid);
				$('#tabInterventionLinkTaskList').datagrid('deleteRow', Index);
			}
		}
	}); 
}
// ������ʩС����
function IntLinkTaskAddClick(){
	var IntItem=$("#IntItem").combobox("getValue");
	if (!IntItem) {
		$.messager.popover({msg:'��ѡ���ʩ��',type:'error'});
		$("#IntItem").next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($("#IntItem").combobox("getData"),"rowID",IntItem) <0){
		$.messager.popover({msg:'������������ѡ���ʩ��',type:'error'});
		$("#IntItem").next('span').find('input').focus();
		return false;
	}
	var TaskData=$("#TaskItem").combobox("getData");
	var TaskItem=$("#TaskItem").combobox("getValue");
	if (!TaskItem) {
		$.messager.popover({msg:'��ѡ���ʩС�',type:'error'});
		$("#TaskItem").next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray(TaskData,"rowid",TaskItem) <0){
		$.messager.popover({msg:'������������ѡ���ʩ��',type:'error'});
		$("#IntItem").next('span').find('input').focus();
		return false;
	}
	var index=$.hisui.indexOfArray(TaskData,"rowid",TaskItem);
	var TaskObj=TaskData[index];
	var  rows=$("#tabInterventionLinkTaskEditList").datagrid("getRows")
	if ($.hisui.indexOfArray(rows,"taskid",TaskItem) >=0){
		$.messager.popover({msg:'�ô�ʩС���Ѵ���,�����ظ���ӣ�',type:'error'});
		$("#TaskItem").next('span').find('input').focus();
		return false;
	}
	$("#tabInterventionLinkTaskEditList").datagrid('appendRow',{
		taskcode:TaskObj.code,
		taskname:TaskObj.taskname,
		order:rows.length+1,
		reqFlag:"��",
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
// �����ʩ������
function SaveTaskItemClick(flag){
	//flag:trueȷ����false����
	var dataArray=new Array();
	var rows=$("#tabInterventionLinkTaskEditList").datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		var Editors=$('#tabInterventionLinkTaskEditList').datagrid("getEditors",i);
		if (Editors.length >0){
			var orderValue = $(Editors[0].target).val()
			var reqflag=$(Editors[1].target).checkbox("getValue")?"Y":"N";
			var startdate=$(Editors[2].target).datebox("getValue");
			if (!startdate) {
				$.messager.popover({msg:'��'+(i+1)+'�У���ѡ���������ڣ�',type:'error'});
				$(Editors[2].target).next('span').find('input').focus();
				return false;
			}
			var enddate=$(Editors[3].target).datebox("getValue");
			if ((enddate)&&(CompareDate(startdate,enddate))) {
				$.messager.popover({msg:'ͣ�����ڲ��������������ڣ�',type:'error'});
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
	//flag:trueȷ����false����
	if (!dataArray.length && !PageLogicObj.delInterventionSubItemArr.length) {
		if (flag) {
			$.messager.popover({msg:'��ѡ���ʩ��������ʩС�',type:'error'});
			return false;
		}else{
			$.messager.popover({msg:'û��Ҫ���������',type:'error'});
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
		//2758853������ƻ����á�ҵ���������
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
			$.messager.popover({msg:'����ʧ��!�����ظ�����������������ţ�',type:'error'});
		}else{
			$.messager.popover({msg:'����ʧ��!',type:'error'});
		}
		return false;
	}
}
// ���汸ѡ������
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
			$.messager.popover({msg:'ѡ��ı�ѡ��������Ϊ�գ�',type:'error'});
			$(Editors[0].target).focus();
			return false;
		}else  if (!reg.test(sortNo)) {
			$.messager.popover({msg:'ѡ��ı�ѡ������ֻ��Ϊ����0����������',type:'error'});
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
		//2758853������ƻ����á�ҵ���������
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
			$.messager.alert("��ʾ","����ʧ��!");
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
		    return firstValue - secondValue ; //����
	    }else{
		    return true;
	    }
	}
}

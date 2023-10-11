///taskoverview.config.js

//页面初始化方法加载
$(window).load(function() {
	//隐藏遮罩层
	$("#loading").hide();
	//初始化多院区
	hospList()
	//加载表单列表
	loadDataGridList()

})


function hospList(){
	//所属医院下拉列表
	var hospComp = GenHospComp("Nur_IP_Question");
	hospComp.jdata.options.onSelect = function(e,t){
		loadDataGridList();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		loadDataGridList();
	}
}

////start loadDataGrid
function loadDataGridList(){
	$('#tabQuestionList').datagrid({  
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
			idField:"rowID",
			pageSize: 15,
			pageList : [15,50,100,200],
			columns :dataGridColumns(),
			toolbar :dataGridToolBar(),
			autoRowHeight:true,
			nowrap:false,  /*此处为false*/
			url : $URL+"?ClassName=Nur.NIS.Service.TaskOverview.Setting&QueryName=GetTaskOverNormList",
			onBeforeLoad:function(param){
				$('#tabQuestionList').datagrid("unselectAll");
				var locId = session['LOGON.CTLOCID']
				param = $.extend(param,{keyword:$("#SearchDesc").val(),loc:locId,hospDR:$HUI.combogrid('#_HospList').getValue(),groupFlag:""})
				
			}
			
		})
	
}

function dataGridColumns(){
	var taskType={
		NORMAL:"正常",
		SIGNS:"体征",
		ORDER:"医嘱",
		EVENT:"事件",
		SIGNORDER:"体征+医嘱",
		MUTIPLY:"事件+医嘱",
		SPECIAL:"特殊",
		ASSESS:"评估",
		ORDERASSESS:"医嘱+评估"
	}
	var Columns=[[
  		{ field: 'id',title:'id',width:50,wordBreak:"break-all"},
		{ field: 'taskCode',title:'Code',width:200,wordBreak:"break-all"},
		{ field: 'taskDesc',title:'常规护理任务描述',width:200,wordBreak:"break-all"},
		{ field: 'taskAttr',title:'任务属性',width:90,wordBreak:"break-all",
			formatter: function(value,row,index){
				var names=["基本体征","护理评估","治疗处置"]
				return names[value-1]
			}},
		{ field: 'type',title:'类型',width:90,wordBreak:"break-all",
			formatter: function(value,row,index){
				return taskType[value]
			}},
		{ field: 'exePeriod',title:'执行有效时间设定',width:150,
			formatter: function(value,row,index){
				var names=["需执行","本班次","当日","时间段"]
				return names[value]
			}
		},
		{ field: 'applyPatient',title:'适用人群',width:200,wordBreak:"break-all",
			formatter: function(value,row,index){
				var names=["","成人","婴儿","儿童","新生儿"]
				return names[value]
			}},
		{ field: 'locsName',title:'生效科室',width:200,wordBreak:"break-all"},
		{ field: 'invalidLocs',title:'无效科室',width:200,wordBreak:"break-all"}
	
    ]];	
	return 	Columns
}
function dataGridToolBar(){
	var ToolBar = [{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() {
			openWin("")				
       
        }
    },{
        text: '修改',
        iconCls: 'icon-write-order',
        handler: function() {
	        var row = $("#tabQuestionList").datagrid("getSelected");
			openWin(row.id)
			
        }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {
            var row = $("#tabQuestionList").datagrid("getSelected");
			if (!row) {
				$.messager.alert("提示","请选择需要删除的记录！");
				return false;
			}
			
			$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
			    if (r){
				    var UserId = session['LOGON.USERID']
					runClassMethod("CF.NUR.NIS.TaskOverview","DeleteTaskOverNorm",{ID:row.id,UserId:UserId},function(data){
						$.messager.alert("提示","成功删除记录！");
						loadDataGridList();
					},'json',false);
			    }    
			}); 
        }
    }];
    return ToolBar
}

function openWin(id){
	
	
	var hospid = $HUI.combogrid('#_HospList').getValue()
	
	
	var url="nur.hisui.taskoverview.config.csp?taskId="+id+"&hospId="+hospid
	console.log(url)
	$('#dialogRefer').dialog({
        title: '常规护理任务',
        width: 600,
        height: 600,
        	
        cache: false,
        content: "<iframe id='iframeRefer' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
        modal: true
    });
    $("#dialogRefer").dialog("open");	
}

function closeHandler(){
	 $('#dialogRefer').dialog('close');	
}
function sureReferHandler(){
	var $iframe = $('#iframeRefer')[0].contentWindow
	var rsflag = $iframe.saveFunLib("1")
	if(rsflag){
		$.messager.popover({msg:'保存成功！',type:'success'});
		loadDataGridList()
		$('#dialogRefer').dialog('close');	
	}
}
function copySureReferHandler(){
	var $iframe = $('#iframeRefer')[0].contentWindow
	var rsflag = $iframe.saveFunLib("2")
	if(rsflag){
		$.messager.popover({msg:'保存成功！',type:'success'});
		loadDataGridList()
		$('#dialogRefer').dialog('close');
	}else{
		
	}	
}

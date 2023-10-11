/**
* @author songchunli
* HISUI 评估对问题配置主js
* QLAssess.js
*/
var PageLogicObj={
	m_DataSourceJson:"",
	m_QuestionJson:"", //护理问题json数据
	m_WardJson:"", //所有病区json
	m_AssessTypeJson:"", //对应方式json
	m_ApplyPersonTypeJson:"", //适用人群
	m_selRowId:"", //评估对问题选中行rowid
	m_ItemCode:"", //记录项目代码选择后的编码@名称
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
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabQLAssessList").datagrid("load");
	});
 	$("#searchName").keydown(searchNameOnKeyDown);
	$("#BSaveQLAssess").click(SaveQLAssessClick);
 	$("#BCancel").click(function(){
	 	$("#QLAssessEditWin").window('close');
	});
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_QLAssess");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#searchName").val("");
		$.extend(PageLogicObj, {m_ItemCode:"",m_selRowId:""});
		InitQuestionJson("");
		InitWardJson();
		$("#tabQLAssessList").datagrid("load");
		InitQLAssessEditWin();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){	
	InitModuleSourceJson();		//初始化数据来源json数据
	InitQuestionJson("");		//初始化问题json数据
	InitAssessTypeJson();		//初始化对应方式json数据
	InitWardJson();	
	InitApplyPersonTypeJson();
	InitStatus();				//初始化状态下拉框	
	InitQLAssessListDataGrid(); //初始化评估对问题列表
	//初始化增加/修改弹框
	InitEditWindow();
	InitQLAssessEditWin();
	//InitTip();
}

function InitModuleSourceJson(){
	var data=$.cm({
		ClassName:"Nur.NIS.Common.QueryBrokerNew",
		MethodName:"GetOptionOfProperty",
		//className:"CF.NUR.NIS.QLAssess",
		//propertyName:"ModuleSource"
		className:"CF.NUR.NIS.PatStatusConfig",
		propertyName:"PSCType"
	},false)
	var newData=new Array();
	for (var i=0;i<data.length;i++){
		var value=data[i].value;
		var text=data[i].text;
		newData.push({
			"value":value.toString(),
			"text":text
		});
	}
	PageLogicObj.m_DataSourceJson=newData;
}
function InitQuestionJson(status){
	PageLogicObj.m_QuestionJson=$.cm({
		ClassName:"Nur.NIS.Service.Base.Assess",
		QueryName:"GetQuestionIds",
		//hospDR:$HUI.combogrid('#_HospList').getValue(),
		//2758853【护理计划配置】业务界面整合
		hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),
		allStatus:status,
		rows:99999
	},false)
}
function InitAssessTypeJson(){
	var data=$.cm({
		ClassName:"Nur.NIS.Common.QueryBrokerNew",
		MethodName:"GetOptionOfProperty",
		className:"CF.NUR.NIS.QLAssess",
		propertyName:"Type"
	},false)
	var newData=new Array();
	for (var i=0;i<data.length;i++){
		var value=data[i].value;
		var text=data[i].text;
		newData.push({
			"value":value.toString(),
			"text":text
		});
	}
	PageLogicObj.m_AssessTypeJson=newData;
}

function InitWardJson(){
	PageLogicObj.m_WardJson=$.cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		QueryName:"GetallWardNew",
		desc:"",
		//hospid:$HUI.combogrid('#_HospList').getValue(),
		//2758853【护理计划配置】业务界面整合
		hospid:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),
		bizTable:"Nur_IP_QLAssess",
		rows:99999
	},false)
}
function InitApplyPersonTypeJson(){
	PageLogicObj.m_ApplyPersonTypeJson=$.cm({
		ClassName:"Nur.NIS.Service.Base.Assess",
		QueryName:"GetApplyPersonType"
	},false)
}

function InitStatus(){
	$("#status").combobox({
		valueField:'id',
		textField:'text',
		mode: "local",
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		data:[{"id":"1","text":"启用"},{"id":"0","text":"停用"}],
		onSelect:function(rec){
			if (rec) {
				$("#tabQLAssessList").datagrid("load");
			}
		}
	});
}
function InitQLAssessListDataGrid(){
	var ToolBar = [{
            text: '新增',
            iconCls: 'icon-add',
            handler: function() {
	            ResetQLAssessEditWin(); 
				PageLogicObj.m_selRowId="";				
				// 加载正确的数据，过滤停用问题
	            InitQuestionJson("");
	            InitQuestion();
	            if (PageLogicObj.iframeflag=="1"){		            
		           	var qrow =$(window.parent.$("#iframeQuestion"))[0].contentWindow.$("#tabQuestionList").datagrid("getSelected");
					if (!qrow){
						$.messager.popover({msg:'请选择一个护理问题！',type:'error'});
						return false;
					}
					$('#Question').combobox("select",qrow.rowID);
	            }
	           	$("#QLAssessEditWin").window('open');
				$("#StartDate").datebox('setValue',ServerObj.CurrentDate);
	            $("#DataSource").next('span').find('input').focus();

	            
            }
        },{
            text: '修改',
            iconCls: 'icon-write-order',
            handler: function() {
	            ResetQLAssessEditWin(); 
	            InitQuestionJson("");
	            InitQuestion();	            
	            var selected = $("#tabQLAssessList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("提示","请选择需要修改的记录！");
					return false;
				}
				SetQLAssessRowData(selected);
				$("#QLAssessEditWin").window('open');
				$("#DataSource").next('span').find('input').focus();
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var selected = $("#tabQLAssessList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("提示","请选择要删除的评估问题项！");
					return false;
				}
				$.messager.confirm('确认对话框', "确定要删除该评估问题项吗？", function(r){
					if (r) {
						var rowId=selected.rowId;
						if (rowId) {
							var rtn=$.m({
								ClassName:"Nur.NIS.Service.Base.Assess",
								MethodName:"DeleteQLAssess",
								rowId:rowId
							},false)
							if (rtn !=0) {
								$.messager.popover({msg:'删除失败！',type:'error'});
								return false;
							}else{
								$.messager.popover({msg:'删除成功！',type:'success'});
							}
							$('#tabQLAssessList').datagrid('reload');
						}
					}
				});
            }
        },{
	        text: '复制',
			iconCls: 'icon-copy',
			handler: function(){
				var selected = $("#tabQLAssessList").datagrid("getSelected");
				if (!selected) {
					$.messager.popover({msg:'请选择需要复制的记录！',type:'error'});
					return false;
				}
				SetQLAssessRowData(selected);
				$("#Question").combobox("setValue",""); //需求序号3086059
				PageLogicObj.m_selRowId="";
				$("#QLAssessEditWin").window('open');
				$("#DataSource").next('span').find('input').focus();
			}
	}];
	
	var Columns=[[  
		{ field: 'module',title:'数据来源',width:90,
			formatter: function(module,row,index){
				var index=$.hisui.indexOfArray(PageLogicObj.m_DataSourceJson,"value",module);
				if (index >=0) {
					return PageLogicObj.m_DataSourceJson[index].text;
				}
			}
		},
		{ field: 'reportTemplate',title:'模板代码',width:200},
		{ field: 'assessName', title: '评估系统',width:150},
		{ field: 'reportItem',title:'项目代码',width:150},
		{ field: 'questionIds',title:'护理问题',width:200,
			formatter: function(questionIds,row,index){
				/*if ((questionIds)&&(questionIds.length >0)) {
					var value="";
					for (var i=0;i<questionIds.length;i++){
						var index=$.hisui.indexOfArray(PageLogicObj.m_QuestionJson.rows,"rowId",questionIds[i]);
						if (index >=0) {
							if (value) value=value+","+PageLogicObj.m_QuestionJson.rows[index].name;
							else value=PageLogicObj.m_QuestionJson.rows[index].name;
						}
					}
					return value;
				}*/
				if ((row.questionDescs)&&(row.questionDescs.length>0)){
					return row.questionDescs.join(",");
				}
			},
			styler: function(value,row,index){
				if (row.haveStopQue ==1){
					return 'background-color:#F16E57;color:#FFFFFF;';
				}
			}
		},
		{ field: 'type',title:'对应方式',width:130,
			formatter: function(value,row,index){
				if (value) {
					var index=$.hisui.indexOfArray(PageLogicObj.m_AssessTypeJson,"value",value);
					if (index >=0) {
						return PageLogicObj.m_AssessTypeJson[index].text;
					}
				}
			}
		},
		{ field: 'validExpression', title: '生效公式',width:150},
		{ field: 'applyPersonType', title: '适用人群',width:150,
			formatter: function(applyPersonTypes,row,index){
				var value="";
				if ((applyPersonTypes)&&(applyPersonTypes.length >0)) {
					for (var i=0;i<applyPersonTypes.length;i++){
						var index=$.hisui.indexOfArray(PageLogicObj.m_ApplyPersonTypeJson.rows,"id",applyPersonTypes[i]);
						if (index >=0) {
							if (value) value=value+","+PageLogicObj.m_ApplyPersonTypeJson.rows[index].type;
							else  value=PageLogicObj.m_ApplyPersonTypeJson.rows[index].type;
						}
					}	
				}
				if (value) {
					return value;
				}else{
					return PageLogicObj.m_ApplyPersonTypeJson.rows[0].type;
				}
			}
		},
		{ field: 'validLocs', title: '适用范围',width:150,
			formatter: function(validLocs,row,index){
				var value="";
				if ((validLocs)&&(validLocs.length >0)) {
					for (var i=0;i<validLocs.length;i++){
						var index=$.hisui.indexOfArray(PageLogicObj.m_WardJson.rows,"wardid",validLocs[i]);
						if (index >=0) {
							if (value) value=value+","+PageLogicObj.m_WardJson.rows[index].warddesc;
							else  value=PageLogicObj.m_WardJson.rows[index].warddesc;
						}
					}
					return value;
				}
				if (value) {
					return value;
				}else{
					return "全院";
				}
			}
		},
		{ field: 'invalidLocs', title: '不适用范围',width:150,
			formatter: function(invalidLocs,row,index){
				var value="";
				if ((invalidLocs)&&(invalidLocs.length >0)) {
					for (var i=0;i<invalidLocs.length;i++){
						var index=$.hisui.indexOfArray(PageLogicObj.m_WardJson.rows,"wardid",invalidLocs[i]);
						if (index >=0) {
							if (value) value=value+","+PageLogicObj.m_WardJson.rows[index].warddesc;
							else  value=PageLogicObj.m_WardJson.rows[index].warddesc;
						}
					}
				}
				return value;
			}
		},
		{ field: 'status', title: '状态',width:70,
			styler: function(value,row,index){
				if (value =="启用"){
					return "color:#3FBD79;"
				}else{
					return "color:#F16E57;"
				}
			}
		},
		{ field: 'haveStopQue',hidden:'true'}
    ]];
	$('#tabQLAssessList').datagrid({  
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
		idField:"rowId",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
		//url : $URL+"?ClassName=Nur.NIS.Service.Base.Assess&MethodName=GetQLAssessByQuestionDesc",
		url : $URL+"?ClassName=Nur.NIS.Service.Base.Assess&MethodName=GetQLAssessByQuestionDescNew",
		onBeforeLoad:function(param){
			PageLogicObj.m_selRowId="";
			$('#tabQLAssessList').datagrid("unselectAll");
			var status=$("#status").combobox('getText');
			if (status.split(",").length !=1){
				status="";
			}
			param = $.extend(param,{
				nameDesc:$("#searchName").val(),
				status:status,
				//hospId:$HUI.combogrid('#_HospList').getValue()
				//2758853【护理计划配置】业务界面整合
				hospId:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
			});
		},
		onLoadSuccess:function(data){ // 给停用问题单元格设置背景色
			var trs = $(this).prev().find('div.datagrid-body').find('tr');
			//行
			for(var i=0;i<trs.length;i++){
			  //行内单元格
			  for(var j=1;j<trs[i].cells.length;j++){
				  var row_html = trs[i].cells[j];
				  var cell_field=$(row_html).attr('field');
				  var cell_value=$(row_html).find('div').html();
				  if(cell_field == 'haveStopQue' && cell_value == "1"){
					  // 设置问题列 背景色
					  //trs[i].cells[4].style.cssText='background:#F16E57;';
					  trs[i].cells[4].title = "问题数据异常（停用或删除）"
				  }
			  }
			}
		}
	}).datagrid({loadFilter:DocToolsHUINur.lib.pagerFilter})
}
function InitEditWindow(){
    $("#QLAssessEditWin" ).window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
		   ClearQLAssessEditWinData();
	   }
	});
}
function InitQLAssessEditWin(){
	// 数据来源
	InitDataSource();
	// 患者状态
	InitPatStatus();
	//InitPatStatusLookUp();
	// 护理问题
	InitQuestion();
	// 对应方式
	InitAssessType();
	// 适用人群
	//InitApplyPersonType();
	// 适用范围 不适用范围
	//InitValidLocs();
	// 项目代码
	//InitItemCodeLookUp();
}
function InitDataSource(){
	$('#DataSource').combobox({
		valueField:'value',
		textField:'text',
		mode: "local",
		editable:false,
		data:PageLogicObj.m_DataSourceJson,
		onSelect:function(rec){
			if (rec) {
				PageLogicObj.m_ItemCode="";
				//InitPatStatus();
				$("#PatStatus").combogrid('clear');
				$("#PatStatus").combogrid("grid").datagrid("reload");
				//$("#ItemCode").lookup("setText",PageLogicObj.m_ItemCode);
				//$("#TemplCode,#AssessSsystem").removeAttr("disabled");
				if (rec.value ==1) {
					//$("#TemplCode,#AssessSsystem").val("");
					//("#TemplCode").focus();
					var newObject = jQuery.extend(true, [], PageLogicObj.m_AssessTypeJson);
					$.hisui.removeArrayItem(newObject,"value",4);
					$.hisui.removeArrayItem(newObject,"value",5);
					$("#AssessType").combobox("loadData",newObject).combobox("select","").combobox("enable");
				}else{
					if (rec.value ==2) { //体温单
						$("#AssessType").combobox("loadData",PageLogicObj.m_AssessTypeJson).combobox("select",1).combobox("disable"); //默认对应方式为数据带问题
						//$("#TemplCode").val("Temperature");
						//$("#AssessSsystem").val("体温单");
					}else if(rec.value ==3){
						$("#AssessType").combobox("loadData",PageLogicObj.m_AssessTypeJson).combobox("select",4).combobox("disable"); //默认对应方式为医嘱带问题
						//$("#TemplCode").val("Order");
						//$("#AssessSsystem").val("医嘱");
					}else if(rec.value ==4){
						$("#AssessType").combobox("loadData",PageLogicObj.m_AssessTypeJson).combobox("select",5).combobox("disable"); //默认对应方式为诊断带问题
						//$("#TemplCode").val("Diagnosis");
						//$("#AssessSsystem").val("诊断");
					}
					//$("#TemplCode,#AssessSsystem").attr("disabled","disabled");
					//$("#ItemCode").focus();
				}
			}
		}
	});
}
function InitPatStatus(){
    $("#PatStatus").combogrid({
        url:$URL,
        mode:'remote',
        method:"Get",
		idField:'id',
		//textField:'name',
		textField:'code',
        columns:[[
			{field:'name',title:'名称',width:200,sortable:true},
			{field:'code',title:'Code',width:120,sortable:true}
        ]],
        panelWidth:560,
        panelHeight:420,
        delay:'200',
        queryParams:{ClassName: 'Nur.NIS.Service.Base.Assess',QueryName: 'GetPatStatusList'},
        onBeforeLoad:function(param){
	        var datasource=$("#DataSource").combobox("getValue");
			var hospid=(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue());
	        if (param['q']) {
				var desc=param['q'];
			}else{
				var desc="";
			}
			//param = $.extend(param,{DataSource:$("#DataSource").combobox("getValue"),Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
	    	//2758853【护理计划配置】业务界面整合
	    	param = $.extend(param,{DataSource:datasource,HospId:hospid,Alias:desc});
	    
	    },onSelect:function(ind,item){
		    //$("#PatStatus").combogrid("setValue",item.id);
			//$("#PatStatus").lookup("setText",item.code);		//显示编码
			//$("#PatStatus").lookup("setText",item.name);		//显示名称
		}
    });
}
/*
function InitPatStatusLookUp(){
    $("#PatStatus").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
		idField:'id',
		//textField:'name',
		textField:'code',
        columns:[[
			{field:'name',title:'名称',width:200,sortable:true},
			{field:'code',title:'Code',width:120,sortable:true}
        ]],
		enableNumberEvent:true,
        pagination:true,
        rownumbers:true,
        panelWidth:560,
        panelHeight:420,
        isCombo:true,
        minQueryLen:2,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'Nur.NIS.Service.Base.Assess',QueryName: 'GetPatStatusList'},
        onBeforeLoad:function(param){
	        if (param['q']) {
				var desc=param['q'];
			}else{
				var desc="";
			}
			//param = $.extend(param,{DataSource:$("#DataSource").combobox("getValue"),Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
	    	//2758853【护理计划配置】业务界面整合
	    	param = $.extend(param,{DataSource:$("#DataSource").combobox("getValue"),Alias:desc,HospId:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
	    
	    },onSelect:function(ind,item){
		    $("#PatStatus").lookup("setValue",item.id);
			//$("#PatStatus").lookup("setText",item.code);		//显示编码
			//$("#PatStatus").lookup("setText",item.name);		//显示名称
		}
    });
}
*/
function InitQuestion(){
	$('#Question').combobox({
		mode: "local",
		valueField:'rowId',
		textField:'name',
		mode: "local",
		//multiple:true, //需求序号3086059
		multiple:(PageLogicObj.iframeflag=="1"? false:true),		
		data:PageLogicObj.m_QuestionJson.rows
	});
}

function InitAssessType(){
	$('#AssessType').combobox({
		valueField:'value',
		textField:'text',
		mode: "local",
		editable:false,
		data:PageLogicObj.m_AssessTypeJson
	});
}
/*
function InitApplyPersonType(){
	$('#applyPersonType').combobox({
		mode: "local",
		valueField:'id',
		textField:'type',
		mode: "local",
		multiple:true,
		data:PageLogicObj.m_ApplyPersonTypeJson.rows,
		onSelect:function(rec){
			if ((rec)&&(!rec.id)){
				$('#applyPersonType').combobox("setValues",[""]);
			}else{
				$('#applyPersonType').combobox("unselect","");
			}
		}
	});
}
function InitValidLocs(){
	$("#validLocs,#invalidLocs").combobox({
		mode: "local",
		valueField:'wardid',
		textField:'warddesc',
		mode: "local",
		multiple:true,
		data:PageLogicObj.m_WardJson.rows
	});
}

function InitItemCodeLookUp(){
	$("#ItemCode").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
		idField:'id',
		textField:'name',
		nowrap:false,
        columns:[[
			{field:'name',title:'名称',width:200,sortable:true},
			{field:'code',title:'Code',width:120,sortable:true},
			{field:'text',title:'描述',width:160,sortable:true}
        ]],
		enableNumberEvent:true,
        pagination:true,
        rownumbers:true,
        panelWidth:490,
        panelHeight:370,
        isCombo:true,
        minQueryLen:2,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'Nur.NIS.Service.Base.Assess',QueryName: 'GetItemCodeList'},
        onBeforeLoad:function(param){
	        if (param['q']) {
				var desc=param['q'];
			}
			//param = $.extend(param,{DataSource:$("#DataSource").combobox("getValue"),Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
	    	//2758853【护理计划配置】业务界面整合
	    	param = $.extend(param,{DataSource:$("#DataSource").combobox("getValue"),Alias:desc,HospId:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
	    	
	    	//武汉一院新增
			param = $.extend(param,{emrCode:$("#TemplCode").val()});
	    },onSelect:function(ind,item){
			PageLogicObj.m_ItemCode=item.code+"@"+item.name;
			$("#ItemCode").lookup("setText",PageLogicObj.m_ItemCode);
		}
    });
    
    // 武汉一院新增
    $("#TemplCode").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
		idField:'id',
		textField:'name',
        columns:[[
			{field:'name',title:'名称',width:200,sortable:true},
			{field:'code',title:'Code',width:120,sortable:true}
        ]],
		enableNumberEvent:true,
        pagination:true,
        rownumbers:true,
        panelWidth:560,
        panelHeight:420,
        isCombo:true,
        minQueryLen:2,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'Nur.NIS.Service.Base.Assess',QueryName: 'GetTemplateCodeList'},
        onBeforeLoad:function(param){
	        if (param['q']) {
				var desc=param['q'];
			}
			//param = $.extend(param,{DataSource:$("#DataSource").combobox("getValue"),Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
	    	//2758853【护理计划配置】业务界面整合
	    	param = $.extend(param,{DataSource:$("#DataSource").combobox("getValue"),Alias:desc,HospId:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
	    
	    },onSelect:function(ind,item){
			$("#TemplCode").lookup("setText",item.code);
			$("#AssessSsystem").val(item.name);
		}
    });
}
function InitTip(){
	$("#TemplCode_tip").popover({
		trigger:'hover',
		content:"<p>数据来源是护理病历，输入病历模板code。</p><p>数据来源是体温单、医嘱、诊断，由系统默认。</p>",
		style:'inverse'
	});
	$("#AssessSsystem_tip").popover({
		trigger:'hover',
		content:"<p>数据来源是护理病历，输入病历表单名称。</p><p>数据来源是体温单、医嘱、诊断，由系统默认。</p>",
		style:'inverse'
	});
	var _content="<p>数据来源为护理病历，输入病历元素item值、病历元素名称，以@间隔 如：item11@总分；</p>"
	_content += "<p>数据来源为体温单，选择体征项自动带入；</p>"
	_content += "<p>数据来源为医嘱，选择医嘱项自动带入；</p>"
	_content += "<p>数据来源为诊断，选择诊断自动带入；</p>"
	$("#ItemCode_tip").popover({
		trigger:'hover',
		content:_content,
		style:'inverse',
		width:550
	});
}
*/
//2758853【护理计划配置】业务界面整合
function ReloadQLAssessListDataGrid(rowID){
	$("#QLAssessEditWin").window('close');
	//需求序号3085164
	InitWardJson();   
	//InitValidLocs();
	$('#tabQLAssessList').datagrid('reload',{
		nameDesc:$("#searchName").val(),
		status:status,
		hospId:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),
		SearchQuestionDR:rowID	
	})	
}
function CloseQLAssessEditWin(){
	$("#QLAssessEditWin").window('close');
}
function SaveQLAssessClick(){
	var DataSource=$("#DataSource").combobox("getValue");
	if (!DataSource) {
		$.messager.popover({msg:'请选择数据来源！',type:'error'});
		$("#DataSource").next('span').find('input').focus();
		return false;
	}
	//var PatStatus=$.trim($("#PatStatus").val())
	var PatStatus=$("#PatStatus").combogrid('getValue');
	if ((DataSource ==1)&&(!PatStatus)) {
		$.messager.popover({msg:'请选择患者状态',type:'error'});
		$("#PatStatus").focus();
		return false;
	}
	/*
	var TemplCode=$.trim($("#TemplCode").val())
	if ((DataSource ==1)&&(!TemplCode)) {
		$.messager.popover({msg:'请输入模板代码',type:'error'});
		$("#TemplCode").focus();
		return false;
	}else if ((DataSource!=1)&&(!PageLogicObj.m_ItemCode)) {
		$.messager.popover({msg:'数据来源非护理病历时，请从模板代码下拉框中选择数据！',type:'error'});
		$("#TemplCode").focus();
		return false;
	}

	if (DataSource !=1) TemplCode=PageLogicObj.m_ItemCode;
	var assessName=$.trim($("#AssessSsystem").val());
	if (!assessName) {
		$.messager.popover({msg:'请输入评估系统',type:'error'});
		$("#AssessSsystem").focus();
		return false;
	}
	var ItemCode=$.trim($("#ItemCode").val());
	if (!ItemCode) {
		$.messager.popover({msg:'请输入项目代码',type:'error'});
		$("#ItemCode").focus();
		return false;
	}
	*/
	var Questions=$("#Question").combobox("getValues");
	Questions=Questions.join("@");
	if (!Questions) {
		$.messager.popover({msg:'请选择护理问题！',type:'error'});
		$("#Question").next('span').find('input').focus();
		return false;
	}
	var AssessType=$("#AssessType").combobox("getValue");
	if (!AssessType) {
		$.messager.popover({msg:'请选择对应方式！',type:'error'});
		$("#AssessType").next('span').find('input').focus();
		return false;
	}
	/*
	var validExpression=$.trim($("#validExpression").val());
	var applyPersonType=$("#applyPersonType").combobox("getValues");
	if ((!applyPersonType)||(applyPersonType.length==0)) {
		$.messager.popover({msg:'请选择适用人群！',type:'error'});
		$("#applyPersonType").next('span').find('input').focus();
		return false;
	}
	var validLocs=$("#validLocs").combobox("getValues");
	var invalidLocs=$("#invalidLocs").combobox("getValues");
	if (CompareLocs(validLocs,invalidLocs)>0){
		$.messager.popover({msg:'适用范围 不适用范围重复！',type:'error'});
		$("#invalidLocs").next('span').find('input').focus();
		return false;
	}
	*/
	var StartDate=$("#StartDate").datebox("getValue");
	if (!StartDate) {
		$.messager.popover({msg:'请选择启用日期！',type:'error'});
		$("#StartDate").next('span').find('input').focus();
		return false;
	}
	var stopDate=$("#StopDate").datebox("getValue");
	if (stopDate) {
		if (CompareDate(StartDate,stopDate)) {
			$.messager.popover({msg:'停用日期不能晚于启用日期！',type:'error'});
			$('#StopDate').next('span').find('input').focus();
			return false;
		}
	}
	var itemJson=new Array();
	var saveDataObj={
		"rowId":PageLogicObj.m_selRowId,
		//"reportTemplate":TemplCode,
		//"assessName":assessName,
		//"reportItem":ItemCode,
		"patstatus":PatStatus,
		"questionIds":Questions,
		"type":AssessType,
		//"applyPersonType":applyPersonType.join("@"),
		//"validLocs":validLocs.join("@"),
		//"invalidLocs":invalidLocs.join("@"),
		//"validExpression":validExpression,
		"startDate":StartDate,
		"stopDate":stopDate,
		//"hospId":$HUI.combogrid('#_HospList').getValue(),
		//2758853【护理计划配置】业务界面整合
		"hospId":(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),
		"module":DataSource
	}
	itemJson.push(saveDataObj);
	$.m({
		ClassName:"Nur.NIS.Service.Base.Assess",
		//MethodName:"SaveQLAssess",
		MethodName:"SaveQLAssessNew",
		itemJson:JSON.stringify(itemJson)
	},function (rtn){
		if(rtn == 0) {
			$.messager.popover({msg:'保存成功！',type:'success'});			
			$("#QLAssessEditWin").window('close');
			$("#tabQLAssessList").datagrid("reload");
		} else {
			$.messager.alert('提示','保存失败！'+ rtn , "info");
			return false;
		}
	})
}
//数组交集
function CompareLocs(validLocs,invalidLocs){
	var intersectionSet = validLocs.filter(function(v){return invalidLocs.indexOf(v) > -1})
	return intersectionSet.length	
}
function ClearQLAssessEditWinData(){
	$("#PatStatus").combogrid('clear');
	$("#Question").combobox("setValues",[]);
	$('#DataSource,#AssessType').combobox("setValue","");
	$("#AssessType").combobox("loadData",PageLogicObj.m_AssessTypeJson).combobox("enable");
	//$("#TemplCode,#AssessSsystem,#ItemCode,#validExpression").val("");
	//$("#applyPersonType,#validLocs,#invalidLocs").combobox("setValues",[]);
	$("#StartDate").datebox('setValue',ServerObj.CurrentDate);
	$("#StopDate").datebox('setValue',"");
	$.extend(PageLogicObj, {m_ItemCode:"",m_selRowId:""});
}
function searchNameOnKeyDown(e){
	var key=websys_getKey(e);
	if (key==13){
		$("#tabQLAssessList").datagrid("load");
	}
}
function SetQLAssessRowData(row){
	PageLogicObj.m_ItemCode=row.reportItem;
	$("#DataSource").combobox("setValue",row.module);
	//患者状态赋值
	$("#PatStatus").combogrid("grid").datagrid("reload");	
	$("#PatStatus").combogrid('setValue',row.patstatusDR);
	
	//$("#TemplCode").val(row.reportTemplate);
	//$("#AssessSsystem").val(row.assessName);
	//$("#ItemCode").val(row.reportItem);
	$("#Question").combobox("setValues",row.questionIds || []);
	if (row.haveStopQue ==1){
		$("#Question").combobox("setText",row.questionDescs);
	}
	if (row.module ==1){
		var newObject = jQuery.extend(true, [], PageLogicObj.m_AssessTypeJson);
		$.hisui.removeArrayItem(newObject,"value",4);
		$.hisui.removeArrayItem(newObject,"value",5);
		$("#AssessType").combobox("loadData",newObject).combobox("enable");
	}else{
		$("#AssessType").combobox("loadData",PageLogicObj.m_AssessTypeJson).combobox("disable");
	}
	$("#AssessType").combobox("setValue",row.type);
	/*
	$("#validExpression").val(row.validExpression);
	var applyPersonType=row.applyPersonType;
	if (!applyPersonType) {
		applyPersonType=[""];
	}
	$("#applyPersonType").combobox("setValues",applyPersonType);
	var validLocs=row.validLocs;
	//需求序号	3145960 ((validLocs.length==1)&&(validLocs[0]==""))
	if ((!validLocs)||((validLocs.length==1)&&(validLocs[0]==""))) {
		validLocs=[];
	}
	$("#validLocs").combobox("setValues",validLocs);
	var invalidLocs=row.invalidLocs; 
	//需求序号	3145960 (invalidLocs.length==1)&&(invalidLocs[0]=="")
	if ((!invalidLocs)||((invalidLocs.length==1)&&(invalidLocs[0]==""))) {
		invalidLocs=[];
	}
	$("#invalidLocs").combobox("setValues",invalidLocs);
	*/
	$("#StartDate").datebox("setValue",row.startDate);
	var stopDate=row.stopDate;
	if (!stopDate) stopDate="";
	$("#StopDate").datebox("setValue",stopDate);
	PageLogicObj.m_selRowId=row.rowId;
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
	if(date2<date1){  
		return true;  
	} 
	return false;
}

var DocToolsHUINur={
	lib:{
		pagerFilter:function pagerFilter(data){
			if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
				data = {
					total: data.length,
					rows: data
				}
			}else{
				if(typeof(data.rows)=='undefined'){
					var arr = []
					for (var i in data){
						arr.push(data[i])
					}
					data = {
						total: arr.length,
						rows: arr
					}
				}
			}
			var dg = $(this);
			var opts = dg.datagrid('options');
			var pager = dg.datagrid('getPager');
			pager.pagination({
				showRefresh:false,
				onSelectPage:function(pageNum, pageSize){
					if (dg[0].id!="tabInPatOrd"){
						dg.datagrid('unselectAll');
					}
					opts.pageNumber = pageNum;
					opts.pageSize = pageSize;
					pager.pagination('refresh',{
						pageNumber:pageNum,
						pageSize:pageSize
					});
					dg.datagrid('loadData',data);
					dg.datagrid('scrollTo',0); //滚动到指定的行  
					/*
					//特殊处理下信息总览界面的医嘱列表
					刷新当前页的选中行,源码里面做了延迟，要保证堆栈执行顺序，
					*/
					if (dg[0].id=="tabInPatOrd"){
						setTimeout(function() {
							SetVerifiedOrder(true);
						}, 0);
					}      
				}
			});
			if (!data.originalRows){
				data.originalRows = (data.rows);
			}
			if (opts.pagination){
				if (data.originalRows.length>0) {
					var start = (opts.pageNumber==0?1:opts.pageNumber-1)*parseInt(opts.pageSize);
					if ((start+1)>data.originalRows.length){
						//取现有行数最近的整页起始值
						start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
						opts.pageNumber=(start/opts.pageSize)+1;
					}
					//解决页码显示不正确的问题
					$.extend($.data(pager[0], "pagination").options,{pageNumber:opts.pageNumber});
					
					var end = start + parseInt(opts.pageSize);
					data.rows = (data.originalRows.slice(start, end));
				}
			}
			//console.log(data)
			return data;
		}
	},
	MessageQueue:{
		Queue: {},
		Add: function(MsgType,$Msg){
			if ((typeof MsgType=="undefined")||(typeof $Msg=="undefined")){
				return;   
			}
			if (this.Queue[MsgType] instanceof Array ===false){
			   this.Queue[MsgType]=new Array();
			}
			this.Queue[MsgType].push($Msg);
			return $Msg;
		},
		///批量停止执行Ajax请求，防止相同的请求对同一DOM操作，导致界面数据异常
		FireAjax:   function (MsgType) {
			this.EachDel(MsgType,function($Ajax){
				if($Ajax.readyState == 4 && $Ajax.status == 200) {
					return;
				}
				$Ajax.abort();
			});
		},
		EachDel:   function (MsgType,callBack) {
			if (this.Queue[MsgType] instanceof Array ===false){
				return;
			}
		    var $Msg;
			for(var i=0; i<this.Queue[MsgType].length; i++){
				$Msg=this.Queue[MsgType][i];
				this.Queue[MsgType].splice(i--, 1);
				if (callBack($Msg)===false){
					break;
				}
			}
         }
	}
}
//2758853【护理计划配置】业务界面整合
function ResetQLAssessEditWin(){
	var innerHeight = window.innerHeight;
	var innerWidth= window.innerWidth;
	if (PageLogicObj.iframeflag=="1"){
		$("#QLAssessEditWin").css({
			width:innerWidth-163,
			height:innerHeight-192
			
		});
    }
}

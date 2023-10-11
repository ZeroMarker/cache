/**
* @author xieci
* HISUI 此JS已作废使用
*/
var PageLogicObj={
	m_SelRowId:"", //问题记录选中行ID
	m_WardJson:""
}
$(function(){ 
	InitHospList();
	$("#BFind").on("click",function(){
		$("#tabQuestionList").datagrid("load");
	})
	$("span.exeRule").on("click",function(){
		$(this).addClass("bgselect").siblings("span").removeClass("bgselect");	
		var value = $(this).attr("value")
		var showId = $(this).attr("showId")
		$(this).siblings("span").each(function(){
			var hideId = $(this).attr("showId");
			$("#"+hideId).parents("tr").hide()	
		})
		$("#"+showId).parents("tr").show();
		$(this).parents("tr").find("input").val(value)
		
		
	})
	
	$("body").on("click",".btnTaskSearch",function(){
		var id = $(this).parents("div.searchBtn").attr("id")
		var value = $(this).parents("div.searchBtn").find("input.startDayReport").val();
		var tid = id.split("-")[0]
		var type = id.split("-")[1]
		var parmas = { desc: value,hospID:$HUI.combogrid('#_HospList').getValue() }
		if(type=="office"){
			parmas = { desc: value,hospid:$HUI.combogrid('#_HospList').getValue(),bizTable:"Nur_IP_TaskOverviewNormal" }
		}
		$('#'+tid).combogrid("grid").datagrid("reload", parmas);	
	})
});
$(window).load(function() {
	$("#loading").hide();

})

function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_Question");
	hospComp.jdata.options.onSelect = function(e,t){
		//$("#tabQuestionList").datagrid("load");
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	//加载列表
	InitQuestionListDataGrid();
	InitWin();
}
var rsData=""
var shiftData=""
runClassMethod("CF.NUR.NIS.TaskOverview","GetTaskOverNormOptions",{},function(data){
	rsData = data;
	var times=[]
	for(var i in rsData.timePoint){
		var text = rsData.timePoint[i]	
		var js ={
			"text":text,
			"value":text	
		}
		times.push(js)
	}
	rsData.times = times
},'json',false);

$cm({
	ClassName:"Nur.SHIFT.Service.ShiftBiz",
	QueryName:"QueryShiftType"
},function(rs){
	shiftData=rs.rows
});

//弹窗界面打开时，初始化页面控件
function InitCreate(){
	$("div.div-combo-text").remove()
	var contorls = InitContorls()
	for(var type in contorls){
		var ids=contorls[type]
		
		for(var id in ids){
			var data = ids[id].data
			var queryName = ids[id].changeQuery
			
			if(type=="checkBox"){
				if(typeof(queryName)!="undefined"){
					create.combox(id).combobox({"data":data,"onChange":change[queryName]})
				}else{
					create.combox(id).combobox({"data":data})	
				}
			}
			if(type=="checkBoxIsMultiple"){
				create.combox(id).combobox({"data":data,"multiple":true,'rowStyle':'checkbox'});
			}	
		}
		
		var parmas = { desc: $("#startDayReport").val(),hospID:$HUI.combogrid('#_HospList').getValue() }
		var className="Nur.NIS.Service.TaskOverview.Normal"
		$("#taskItem").parents("tr").hide()
		//关联体征项
		create.combogrid("relationSign",className,"GetSignsItem",parmas)
		//关联医嘱项
		create.combogrid("relationDocAdvices",className,"GetDocAdvice",parmas)
		//关联事件项
		create.combogrid("relationEvents",className,"GetEventType",parmas)
		//关联评估项
		create.combogrid("relationAssess",className,"GetAssessItems",parmas)
		
		//
		parmas = { desc: $("#startDayReport").val(),hospid:$HUI.combogrid('#_HospList').getValue(),bizTable:"Nur_IP_TaskOverviewNormal" }
		//生效科室
		create.combogridOffice("validLocs","Nur.NIS.Service.Base.Ward","GetallWardNew",parmas)
		//无效科室
		create.combogridOffice("invalidLocs","Nur.NIS.Service.Base.Ward","GetallWardNew",parmas)

	}
	$("#condion-panel-one,#condion-panel-two,#condion-panel-three").hide().find("tr").hide()
		
}


var change={
		taskAttr:function(value,oldValue){
			//切换时
			$("#condion-panel-one,#condion-panel-two,#condion-panel-three").hide().find("tr").hide()
			$("#condion-panel-one").show();
			$("#type").parents("tr").show();
			$("#taskItem").parents("tr").show()
			var className="Nur.NIS.Service.TaskOverview.Normal"
			var parmas = { desc: $("#startDayReport").val(),hospID:$HUI.combogrid('#_HospList').getValue() }
			if(value==1){
				create.combogrid("taskItem",className,"GetSignsItem",parmas)			
			}else if(value==2){
				create.combogrid("taskItem",className,"GetAssessItems",parmas)
			}else if(value==3){
				create.combogrid("taskItem",className,"GetDocAdvice",parmas)
			}
			
			//动态筛选关联条件-类型的数据
			var data = []
			for(var i in rsData.type){
				var text = rsData.type[i].value
				var name = taskAttrQuery["taskAttr"+value][text]
				if(typeof(name) !="undefined"){
					data.push(rsData.type[i])
				}
			}
			$("#type").combobox({'data':data,'onChange':change.type});
			//$("#taskItem").siblings("span.combo").find(".div-combo-text").html('')
			//切换时，清除所有的选中记录
			$("div.div-combo-text").html('')
			
		},
		type:function(value,oldValue){
			$("#condion-panel-two,#condion-panel-three").hide().find("tr").hide();	
			$("#condion-panel-two").show();
			$("#type").parents("tr").siblings("tr").hide();
			var v = $("#taskAttr").combobox("getValue");
			var showId = taskAttrQuery["taskAttr"+v][value];
			$(showId).parents("tr").show();
			if(v==1){
				if(value=="SIGNS"){
					$("#condion-panel-three").show()
				}else if(value=="SIGNORDER"){
					$("#condion-panel-three").show();	
				}
			}else if(v==2){
				
				if(value=="ASSESS" || value=="ORDERASSESS"){
					$("#condion-panel-three").show();
					$("#condion-panel-one-a").show();
				}	
			}else{
				$("#condion-panel-two").hide();
			}
			//正常时，需要对执行类型进行筛选
			if(value=="NORMAL"){
				var intervalData=[]
				for(var i in rsData.intervalType){
					var text = rsData.intervalType[i].value	
					var name = rationIntervalType["taskAttr"+v][text]
					if(typeof(name) !="undefined"){
						intervalData.push(rsData.intervalType[i])
					}
				}
				//动态筛选执行类型的数据
				$("#rationIntervalType").combobox({'data':intervalData,"onChange":change.rationIntervalType});
			} 
				
		},
		rationIntervalType:function(value,oldValue){
			$("#rationIntervalType").parents("tr").siblings("tr").hide()
			var v = $("#taskAttr").combobox("getValue")
			var showId = rationIntervalType["taskAttr"+v][value]
			$(showId).parents("tr").show();
		},
		relationExeMode:function(value,oldValue){
			$("#relationExeMode").parents("tr").siblings("tr").hide()
			var v = $("#taskAttr").combobox("getValue")
			var showId = relationExeMode["taskAttr"+v][value]
			$(showId).parents("tr").show();
		}
	}


function isExitValue(selector,id){
	var $div = $("#"+selector).siblings("span.combo").find("div.div-combo-text")
	var len = $div.find('span[id="'+id+'"]').length
	if(len>0){
		return false	
	}
	return true
}
//584864,558617  

function insertComboValues(selector,id,desc){
	var $div = $("#"+selector).siblings("span.combo").find("div.div-combo-text")
	var len = $div.find('span[id="'+id+'"]').length
	if(len>0){
		//$div.find('span[id="'+id+'"]').remove()
	}else{
		if("relationAssess"==selector){
			$div.html('<span style="background-color: #fafafa;border-radius: 2px;padding-left: 3px;padding-right: 20px;border: 1px solid #e8e8e8;display: inline-block;margin: 5px 0px 0px 5px;position: relative;" id="'+id+'">'+desc+'<a style="width: 16px;height: 16px;display: inline-block;vertical-align: top;position: absolute;right:1px;bottom:1px" class="panel-tool-close" href="javascript:void(0)"></a></span>')
	
		}else{
			$div.append('<span style="background-color: #fafafa;border-radius: 2px;padding-left: 3px;padding-right: 20px;border: 1px solid #e8e8e8;display: inline-block;margin: 5px 0px 0px 5px;position: relative;" id="'+id+'">'+desc+'<a style="width: 16px;height: 16px;display: inline-block;vertical-align: top;position: absolute;right:1px;bottom:1px" class="panel-tool-close" href="javascript:void(0)"></a></span>')
		}
		$div.find("span a.panel-tool-close").on("click",function(event){
			event.stopPropagation()
			$(this).parent().remove()
			$('#'+selector).combogrid("grid").datagrid("load");	
			
		})
	}
}

function insertComboDiv(selector){
	var $input = $("#"+selector).siblings("span.combo").find("input.combo-text")
	var w = $input.width()
	var h = $input.height()
	$input.hide()
	$("#"+selector).siblings("span.combo").find("span.combo-arrow").hide()
	$("#"+selector).siblings("span.combo").css({"white-space":"normal","height":"auto"})

	var len = $("#"+selector).siblings("span.combo").find(".div-combo-text").length;
	if(len==0){
		$input.after('<div class="div-combo-text" style="display: inline-block;padding-bottom:5px;border:0px solid;width:100%;min-height:'+h+'px;"></div>')
		$("#"+selector).siblings("span.combo").find(".div-combo-text").on("click",function(event){
			event.stopPropagation()
			$input.trigger("click")
		})
	}
	
}

//动态创建控件
var create = {
	combox:function(id){
		$HUI.combo("#"+id,{
			valueField:"value",
			textField:"text",
			multiple:false,
			selectOnNavigation:false,
			panelHeight:"auto",
			width:257,
			editable:false
		});
		return $("#"+id)
	},
	combogrid:function(selector,clsname,quyname,parmas) {
		var searchhtml = $("#comboxSearch").html()
		var len = $('#'+selector+"-search").length

		if(len==0){
			var id = selector+"-search"
			var html = '<div style="margin-bottom: 5px; " class="searchBtn" id="'+id+'">'+searchhtml+'</div>'
			$("#comboxSearch").after(html)
			
		}
		//var comboxOBJ = $HUI.combogrid("#" + selector, {
			var find = false;
		$("#"+selector).combogrid({
			panelWidth: 350,
			panelHeight: 350,
			editable: false,
			idField: 'id',
			textField: 'desc',
			//method: 'get',
			columns: [[
				{field:'desc',title:'项目名称',width:120}
			]],
			pagination : true,
			url:$URL+"?ClassName="+clsname+"&QueryName="+quyname,
			fitColumns: true,
			toolbar: '#'+selector+"-search",
			pageSize:50,
			multiple: true,
			//rownumbers:true,
			striped: true,
			mode:"remote",
			queryParams:parmas,
			loadFilter: function(obj) {
			  /*var value = $('#'+selector+"-search").find("input.startDayReport").val()
			  if(value==""){
				  obj.rows = []
			  	  return obj;
			  }*/
			  // 数据过滤
			  var arrs = []
			  $.each(obj.rows, function(index, value) {
	                if (isExitValue(selector,value.id)) {
	                    arrs.push(value)
	                }
	            });
			  obj.rows = arrs
			  return obj;
			},
			onBeforeLoad: function(data) {
				insertComboDiv(selector)
				$("#"+selector).combogrid('grid').datagrid('clearSelections');
			},
			onClickRow:function(rowIndex, rowData){
				var desc = rowData.desc
				var id = rowData.id	
				insertComboValues(selector,id,desc)
				$('#'+selector).combogrid("grid").datagrid("load");
				//$("#"+selector).combogrid('grid').datagrid('unselectRow',rowIndex) 
				return false
			},
		});
		

		
	},
	combogridOffice:function(selector,clsname,quyname,parmas) {
		var searchhtml = $("#comboxSearch").html()
		var len = $('#'+selector+"-office-search").length
		if(len==0){
			var id = selector+"-office-search"
			var html = '<div style="margin-bottom: 5px;" class="searchBtn"  id="'+id+'">'+searchhtml+'</div>'
			$("#comboxSearch").after(html)
			
		}
		var comboxOBJ = $HUI.combogrid("#" + selector, {
			panelWidth: 350,
			panelHeight: 350,
			editable: false,
			idField: 'wardid',
			textField: 'warddesc',
			//method: 'get',
			columns: [[
				{field:'warddesc',title:'科室名称',width:350}
			]],
			pagination : true,

			url:$URL+"?ClassName="+clsname+"&QueryName="+quyname,
			fitColumns: true,
			toolbar: '#'+selector+"-office-search",
			pageSize:30,
			multiple: true,
			//rownumbers:true,
			striped: true,
			mode:"remote",
			queryParams:parmas,
			loadFilter: function(obj) {
			  // 数据过滤
			  var arrs = []
			  $.each(obj.rows, function(index, value) {
	                if (isExitValue(selector,value.wardid)) {
	                    arrs.push(value)
	                }
	            });
			  obj.rows = arrs

			  return obj;
			},
			onBeforeLoad: function(data) {
				insertComboDiv(selector)
			},
			onClickRow:function(rowIndex, rowData){
				var desc = rowData.warddesc
				var id = rowData.wardid	
				insertComboValues(selector,id,desc)
				$('#'+selector).combogrid("grid").datagrid("load");
			}
		});
		
	}
}



var  parmas={}
function saveFunLib(flag){
	parmas={}
	var contorls = InitContorls();
	for(var type in contorls){
		var ids=contorls[type]
		for(var id in ids){
			$get.value(id,type)
		}	
	}
	
	var tab = $('#tabQuestionList').datagrid('getSelected');
	
	var locId = session['LOGON.CTLOCID'];
	var userId = session['LOGON.USERID']
	var hospID = $HUI.combogrid('#_HospList').getValue()
	var id = ""
	if(null != tab){
		id =tab.id	
	}
	parmas.hospID=hospID
	parmas.locId = locId
	parmas.userId=userId
	
	
	//继续新增时，为空
	if(flag==2){
		id=""	
	}
	parmas.id=id
	console.log(JSON.stringify(parmas))

	$.m({
		ClassName:"CF.NUR.NIS.TaskOverview",
		MethodName:"AddOrUpdateTaskOverNorm",
		data:JSON.stringify(parmas)
	},function (rtn){
		if(rtn == 0) {
			$.messager.popover({msg:'保存成功！',type:'success'});
			
		} else {
			$.messager.alert('提示','保存失败！'+ rtn , "info");
			return false;
		}
	})
	
}
var $get ={
	value:function(id,type){
	 	var isDisplay = $('#'+id).parents("tr").is(':hidden');
	 	if(isDisplay=='true' || isDisplay){
		 	return false
		 }

		 var len = $("#"+id).length
		 if(len ==0){
			 return false
		 }
		 var value= ""
		 if(type=="input"){
			value= $("#"+id).val()
		
		}

		if(type=="checkBox"){
			value= $("#"+id).combo("getValue")
		}
		if(type=="checkBoxIsMultiple"){
			value = $("#"+id).combo("getValues")
			
		}
		if(type=="combogrid"){
			//value = $("#"+id).combogrid("getValues")
			value=[]
			var $div = $("#"+id).siblings("span.combo").find("div.div-combo-text")
			$div.find('span').each(function(){
				var val = $(this).attr("id")
				value.push(val)
			})
			
			
		}
		parmas[id]=value
		return value;
	 	
	}
}


function InitQuestionListDataGrid(){
	var ToolBar = [{
            text: '新增',
            iconCls: 'icon-add',
            handler: function() {
	            InitCreate()
	            $('#form-save').form('clear');
				$("#myWin").window('open');				
            }
        },{
            text: '修改',
            iconCls: 'icon-write-order',
            handler: function() {
				var row = $("#tabQuestionList").datagrid("getSelected");
				if (!row) {
					$.messager.alert("提示","请选择需要修改的记录！");
					return false;
				}
				runClassMethod("Nur.NIS.Service.TaskOverview.Normal","GetTaskoverNormById",{id:row.id},function(data){
					InitCreate()
					$("#myWin").window('open');
					InitSetValue(data);
				},'json',false);
				
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var selected = $("#tabQuestionList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("提示","请选择需要删除的记录！");
					return false;
				}
				
            }
        }];
	//rowID:%String:hidden,careTypeT:%String:诊断分类,careTypeV:%String:hidden,queCode:%String:问题编码,shortName:%String:护理问题,
	// longName:%String:问题定义,IsNursingAdvice:%String:是否生成护嘱,applyArea:%String:适用范围,status:%String:状态,
	//parentID:%String:hidden,enableDate:%String:hidden,stopDate:%String:hidden,queTypeDr:%String:hidden,queTypeDesc:%String:hidden
	
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
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.TaskOverview.Setting&QueryName=GetTaskOverNormList",
		onBeforeLoad:function(param){
			
			PageLogicObj.m_SelRowId="";
			$('#tabQuestionList').datagrid("unselectAll");
			var locId = session['LOGON.CTLOCID']
			param = $.extend(param,{keyword:$("#SearchDesc").val(),loc:locId,hospDR:$HUI.combogrid('#_HospList').getValue(),groupFlag:""})
			
		},
		onDblClickRow:function(rowIndex, rowData){
			console.log(rowData)
				//alert(rowData.id)
				//双击事件
				runClassMethod("Nur.NIS.Service.TaskOverview.Setting","GetTaskoverNormById",{id:rowData.id},function(data){
					InitCreate()
					$("#myWin").window('open');
					InitSetValue(data);
				},'json',false);
		}
	})
}
function InitSetValue(data){
	$('#form-save').form('clear');

	var contors = InitContorls();
	for(var id in contors.input){
		var value = data[id]
		if(typeof(value)!='undefined'){
			$("#"+id).val(value)
		}
	}
	for(var id in contors.checkBox){
		var value = data[id]
		if(typeof(value)!='undefined'){
			$("#"+id).combobox("setValue",value)
		}
	}
	for(var id in contors.checkBoxIsMultiple){
		var value = data[id]
		if(typeof(value)!='undefined'){
			$("#"+id).combobox("setValues",value)
		}
	}
	console.log(data)
	for(var id in contors.combogrid){
		var name = data[id+"Name"]
		var value = data[id]
		for(var i in value){
			insertComboValues(id,value[i],name[i])	
		}
	}
	if(typeof(data.relationNotTodayExeRule)!='undefined'){
		$("#relationNotTodayExeRule").parents("tr").find("span[value='"+data.relationNotTodayExeRule+"']").trigger("click")
	}

	if(typeof(data.relationTodayExeRule)!='undefined'){		
		$("#relationTodayExeRule").parents("tr").find("span[value='"+data.relationTodayExeRule+"']").trigger("click")
	}
	//$('#form-save').form('load', data);
	

}

function InitWin(){
	$("#myWin").show()
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-w-batch-cfg',
		resizable:true,
		title:' 新增常规护理任务',
		modal:true,
		closed:true,
		buttonAlign : 'center',
		buttons:[{
			text:'保存',
			id:'save_btn',
			handler:function(){
				saveFunLib(1)
			}
		},
		{
			text:'继续新增',
			id:'save_goon',
			handler:function(){
				saveFunLib(2)
			}
		},{
			text:'关闭',
			handler:function(){
				myWin.close();
			}
		}]
	})
	$('#form-save').form("clear");	
}

function InitContorls(){
	var contorls = {
		checkBox:{
			applyPatient:{
					name:"适用患者",
					data:rsData.patientType
				},
			exePeriod:{
					name:"执行有效时间设定",
					data:rsData.exeTime
				},
			
			taskAttr:{
					name:"任务属性",
					data:rsData.taskAttr,
					changeQuery:"taskAttr"
				},
				
			type:{
					name:"类型",
					data:rsData.type,
					changeQuery:"type"
				},
			rationIntervalType:{
					name:"执行类型",
					data:rsData.intervalType,
					changeQuery:"rationIntervalType"
				},
			relationExeMode:{
					name:"执行模式",
					data:rsData.exeMode,
					changeQuery:"relationExeMode"
				},
			relationIntervalPeriodUnit:{
					name:"间隔周期(单位)",
					data:rsData.periodUnit
				},
			relationPeriodUnit:{
					name:"持续周期(单位)",
					data:rsData.periodUnit
				},
			normalSustainUnit:{
					name:"回归正常持续周期(单位)",
					data:rsData.periodUnit
				},
			normalPeriodUnit:{
					name:"正常后持续周期(单位)",
					data:rsData.periodUnit
				},
			normalIntervalPeriodUnit:{
					name:"正常后间隔周期(单位)",
					data:rsData.periodUnit
				},
			relationUDUnit:{
					name:"自定义单位",
					data:[{"text":"小时","value":"HOUR"},{"text":"分钟","value":"MINUTE"}]	
				},
			relationUDOperator:{
					name:"自定义操作符",
					data:[{"text":"之前","value":"2"},{"text":"之后","value":"3"}]	
				}
				
						
		},
		checkBoxIsMultiple:{
			relationExeShift:{
					name:"需执行班次",
					data:shiftData
				},

			relationNotTodayExeShift:{
					name:"非当日需执行班次",
					data:shiftData
				},
			relationTodayExeShift:{
					name:"当日需执行班次",
					data:shiftData
				},
			relationTodayExeTime:{
					name:"当日需执行时间",
					data:rsData.times
				},
			relationNotTodayExeTime:{
					name:"非当日需执行时间",
					data:rsData.times
				},
			normalExeTime:{
					name:"正常后需执行时间",
					data:rsData.times
				},
			rationFixedCycle:{
					name:"固定周期",
					data:rsData.fixedCycle
				},
		},
		combogrid:{
			invalidLocs:{
				name:"无效科室"
				},
			validLocs:{
				name:"生效科室"
				},
			taskItem:{
				name:"任务项"
				},
			relationSign:{
				name:"关联体征项"
				},
			relationEvents:{
				name:"关联事件项"
				},
			relationDocAdvices:{
				name:"关联医嘱项"
				},
			relationAssess:{
				name:"关联评估项"
				}
			
		},
		input:{
			exclusions:{
				name:"排除条件生效方法"
				},
			normalPeriod:{
				name:"正常后持续周期"
			},
			normalIntervalPeriod:{
				name:"正常后间隔周期"
				},
			normalExeRule:{
				name:"正常后需执行规则"
				},
			taskDesc:{
				name:"常规护理任务描述"
				},
			taskCode:{
				name:"代码"
				},
			relationFormula:{
				name:"生效公式"
				},
			relationTodayExeRule:{
				name:"当日需执行规则"
				},
			relationNotTodayExeRule:{
				name:"非当日需执行规则"
				},
			relationIntervalPeriod:{
				name:"间隔周期"
				},
			relationPeriod:{
				name:"持续周期"
				},
			relationExeMethod:{
				name:"执行方法"
				},
			normalFormula:{
				name:"正常值生效公式"
				},
			normalSustain:{
				name:"回归正常持续周期"
				},
			relationUDNum:{
				name:"自定义值"
				}
		},
	
	}
	return contorls
}
var taskAttrQuery={
		"taskAttr1":{
			"NORMAL":"#rationIntervalType",
			"SIGNS":"#relationSign,#relationFormula,#relationTodayExeTime,#relationNotTodayExeTime,#relationPeriod,#normalSustain,#normalExeTime,#normalPeriod,#normalFormula",
			"ORDER":"#relationDocAdvices,#relationExeMode",
			"SIGNORDER":"#relationSign,#relationDocAdvices,#relationFormula,#relationTodayExeTime,#relationNotTodayExeTime,#relationPeriod,#normalSustain,#normalExeTime,#normalPeriod,#NormalFormula",
			"EVENT":"#relationEvents,#relationTodayExeRule,#relationTodayExeTime,#relationNotTodayExeTime,#relationIntervalPeriod,#relationPeriod",//#relationTodayExeRule,#relationNotTodayExeRule,
			"MUTIPLY":"#relationEvents,#relationTodayExeRule,#relationDocAdvices,#relationTodayExeTime,#relationNotTodayExeTime,#relationPeriod",
			"SPECIAL":"#relationExeMethod"
			},
		"taskAttr2":{
			"NORMAL":"#rationIntervalType",//#relationAssess,
			//"ORDER":"#relationDocAdvices,#relationTodayExeTime,#relationNotTodayExeTime,#relationIntervalPeriod,#relationPeriod",
			"ORDER":"#relationDocAdvices,#relationExeMode",
			"EVENT":"#relationEvents,#relationTodayExeRule,#relationTodayExeTime,#relationNotTodayExeTime,#relationIntervalPeriod,#relationPeriod",//#relationNotTodayExeRule,#relationTodayExeRule,
			"SPECIAL":"#relationExeMethod",
			"ASSESS":"#relationAssess,#relationFormula,#relationPeriod,#relationTodayExeTime,#relationNotTodayExeTime,#relationIntervalPeriod,#normalFormula,#normalExeTime,#normalIntervalPeriod,#normalPeriod",//#relationTodayExeRule,#relationNotTodayExeRule,
			"ORDERASSESS":"#relationAssess,#relationDocAdvices,#relationFormula,#relationPeriod,#relationTodayExeTime,#relationNotTodayExeTime,#relationIntervalPeriod,#normalFormula,#normalExeTime,#normalIntervalPeriod,#normalPeriod",//#relationTodayExeRule,#relationNotTodayExeRule,
			"MUTIPLY":"#relationEvents,#relationTodayExeRule,#relationDocAdvices,#relationTodayExeTime,#relationNotTodayExeTime,#relationPeriod",
			"SIGNORDER":"#relationSign,#relationDocAdvices,#relationFormula,#relationTodayExeTime,#relationNotTodayExeTime,#relationPeriod,#normalSustain,#normalExeTime,#normalPeriod,#NormalFormula",
			
			//"ORDERASSESS":"#relationAssess,#relationDocAdvices,#relationFormula,#relationTodayExeTime,#relationNotTodayExeTime,#relationPeriod,#relationIntervalPeriod,#normalFormula,#normalExeTime,#normalIntervalPeriod,#normalPeriod"	
		},
		"taskAttr3":{
			"ORDER":"#relationDocAdvices,#showByFreq"
		}
	}
var rationIntervalType={
		"taskAttr1":{
			"1":"#rationFixedCycle,#relationTodayExeTime",
			"2":"#relationTodayExeTime,#relationPeriod",
		},
		"taskAttr2":{
			//"1":"#relationTodayExeTime,#relationNotTodayExeTime,#relationIntervalPeriod,#relationPeriod",
			//"2":"#relationTodayExeTime,#relationPeriod",
			//"3":"#relationExeShift,#relationIntervalPeriod,#relationPeriod"
			"1":"#rationFixedCycle,#relationTodayExeTime",
			"2":"#relationTodayExeTime,#relationIntervalPeriod,#relationPeriod",
		}
	}
var relationExeMode={
		"taskAttr1":{
			"2":"#relationTodayExeTime,#relationNotTodayExeTime,#relationPeriod",
			"3":"#rationFixedCycle,#relationTodayExeTime"
		},
		"taskAttr2":{
			"2":"#relationTodayExeTime,#relationNotTodayExeTime,#relationIntervalPeriod,#relationPeriod",
			"3":"#rationFixedCycle,#relationTodayExeTime"
		},
		"taskAttr3":{
			"1":""	
		}
	}
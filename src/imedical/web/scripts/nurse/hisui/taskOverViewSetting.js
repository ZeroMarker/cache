/**
* @author xieci
* HISUI ��JS������ʹ��
*/
var PageLogicObj={
	m_SelRowId:"", //�����¼ѡ����ID
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
	//�����б�
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

//���������ʱ����ʼ��ҳ��ؼ�
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
		//����������
		create.combogrid("relationSign",className,"GetSignsItem",parmas)
		//����ҽ����
		create.combogrid("relationDocAdvices",className,"GetDocAdvice",parmas)
		//�����¼���
		create.combogrid("relationEvents",className,"GetEventType",parmas)
		//����������
		create.combogrid("relationAssess",className,"GetAssessItems",parmas)
		
		//
		parmas = { desc: $("#startDayReport").val(),hospid:$HUI.combogrid('#_HospList').getValue(),bizTable:"Nur_IP_TaskOverviewNormal" }
		//��Ч����
		create.combogridOffice("validLocs","Nur.NIS.Service.Base.Ward","GetallWardNew",parmas)
		//��Ч����
		create.combogridOffice("invalidLocs","Nur.NIS.Service.Base.Ward","GetallWardNew",parmas)

	}
	$("#condion-panel-one,#condion-panel-two,#condion-panel-three").hide().find("tr").hide()
		
}


var change={
		taskAttr:function(value,oldValue){
			//�л�ʱ
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
			
			//��̬ɸѡ��������-���͵�����
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
			//�л�ʱ��������е�ѡ�м�¼
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
			//����ʱ����Ҫ��ִ�����ͽ���ɸѡ
			if(value=="NORMAL"){
				var intervalData=[]
				for(var i in rsData.intervalType){
					var text = rsData.intervalType[i].value	
					var name = rationIntervalType["taskAttr"+v][text]
					if(typeof(name) !="undefined"){
						intervalData.push(rsData.intervalType[i])
					}
				}
				//��̬ɸѡִ�����͵�����
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

//��̬�����ؼ�
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
				{field:'desc',title:'��Ŀ����',width:120}
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
			  // ���ݹ���
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
				{field:'warddesc',title:'��������',width:350}
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
			  // ���ݹ���
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
	
	
	//��������ʱ��Ϊ��
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
			$.messager.popover({msg:'����ɹ���',type:'success'});
			
		} else {
			$.messager.alert('��ʾ','����ʧ�ܣ�'+ rtn , "info");
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
            text: '����',
            iconCls: 'icon-add',
            handler: function() {
	            InitCreate()
	            $('#form-save').form('clear');
				$("#myWin").window('open');				
            }
        },{
            text: '�޸�',
            iconCls: 'icon-write-order',
            handler: function() {
				var row = $("#tabQuestionList").datagrid("getSelected");
				if (!row) {
					$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵļ�¼��");
					return false;
				}
				runClassMethod("Nur.NIS.Service.TaskOverview.Normal","GetTaskoverNormById",{id:row.id},function(data){
					InitCreate()
					$("#myWin").window('open');
					InitSetValue(data);
				},'json',false);
				
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                var selected = $("#tabQuestionList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("��ʾ","��ѡ����Ҫɾ���ļ�¼��");
					return false;
				}
				
            }
        }];
	//rowID:%String:hidden,careTypeT:%String:��Ϸ���,careTypeV:%String:hidden,queCode:%String:�������,shortName:%String:��������,
	// longName:%String:���ⶨ��,IsNursingAdvice:%String:�Ƿ����ɻ���,applyArea:%String:���÷�Χ,status:%String:״̬,
	//parentID:%String:hidden,enableDate:%String:hidden,stopDate:%String:hidden,queTypeDr:%String:hidden,queTypeDesc:%String:hidden
	
	var taskType={
		NORMAL:"����",
		SIGNS:"����",
		ORDER:"ҽ��",
		EVENT:"�¼�",
		SIGNORDER:"����+ҽ��",
		MUTIPLY:"�¼�+ҽ��",
		SPECIAL:"����",
		ASSESS:"����",
		ORDERASSESS:"ҽ��+����"
	
	}
	
	var Columns=[[
  		{ field: 'id',title:'id',width:50,wordBreak:"break-all"},
		{ field: 'taskCode',title:'Code',width:200,wordBreak:"break-all"},
		{ field: 'taskDesc',title:'���滤����������',width:200,wordBreak:"break-all"},
		{ field: 'taskAttr',title:'��������',width:90,wordBreak:"break-all",
			formatter: function(value,row,index){
				var names=["��������","��������","���ƴ���"]
				return names[value-1]
			}},
		{ field: 'type',title:'����',width:90,wordBreak:"break-all",
			formatter: function(value,row,index){
				return taskType[value]
			}},
		{ field: 'exePeriod',title:'ִ����Чʱ���趨',width:150,
			formatter: function(value,row,index){
				var names=["��ִ��","�����","����","ʱ���"]
				return names[value]
			}
		},
		{ field: 'applyPatient',title:'������Ⱥ',width:200,wordBreak:"break-all",
			formatter: function(value,row,index){
				var names=["","����","Ӥ��","��ͯ","������"]
				return names[value]
			}},
		{ field: 'locsName',title:'��Ч����',width:200,wordBreak:"break-all"},
		{ field: 'invalidLocs',title:'��Ч����',width:200,wordBreak:"break-all"}
    ]];
	$('#tabQuestionList').datagrid({  
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
		idField:"rowID",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*�˴�Ϊfalse*/
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
				//˫���¼�
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
		title:' �������滤������',
		modal:true,
		closed:true,
		buttonAlign : 'center',
		buttons:[{
			text:'����',
			id:'save_btn',
			handler:function(){
				saveFunLib(1)
			}
		},
		{
			text:'��������',
			id:'save_goon',
			handler:function(){
				saveFunLib(2)
			}
		},{
			text:'�ر�',
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
					name:"���û���",
					data:rsData.patientType
				},
			exePeriod:{
					name:"ִ����Чʱ���趨",
					data:rsData.exeTime
				},
			
			taskAttr:{
					name:"��������",
					data:rsData.taskAttr,
					changeQuery:"taskAttr"
				},
				
			type:{
					name:"����",
					data:rsData.type,
					changeQuery:"type"
				},
			rationIntervalType:{
					name:"ִ������",
					data:rsData.intervalType,
					changeQuery:"rationIntervalType"
				},
			relationExeMode:{
					name:"ִ��ģʽ",
					data:rsData.exeMode,
					changeQuery:"relationExeMode"
				},
			relationIntervalPeriodUnit:{
					name:"�������(��λ)",
					data:rsData.periodUnit
				},
			relationPeriodUnit:{
					name:"��������(��λ)",
					data:rsData.periodUnit
				},
			normalSustainUnit:{
					name:"�ع�������������(��λ)",
					data:rsData.periodUnit
				},
			normalPeriodUnit:{
					name:"�������������(��λ)",
					data:rsData.periodUnit
				},
			normalIntervalPeriodUnit:{
					name:"������������(��λ)",
					data:rsData.periodUnit
				},
			relationUDUnit:{
					name:"�Զ��嵥λ",
					data:[{"text":"Сʱ","value":"HOUR"},{"text":"����","value":"MINUTE"}]	
				},
			relationUDOperator:{
					name:"�Զ��������",
					data:[{"text":"֮ǰ","value":"2"},{"text":"֮��","value":"3"}]	
				}
				
						
		},
		checkBoxIsMultiple:{
			relationExeShift:{
					name:"��ִ�а��",
					data:shiftData
				},

			relationNotTodayExeShift:{
					name:"�ǵ�����ִ�а��",
					data:shiftData
				},
			relationTodayExeShift:{
					name:"������ִ�а��",
					data:shiftData
				},
			relationTodayExeTime:{
					name:"������ִ��ʱ��",
					data:rsData.times
				},
			relationNotTodayExeTime:{
					name:"�ǵ�����ִ��ʱ��",
					data:rsData.times
				},
			normalExeTime:{
					name:"��������ִ��ʱ��",
					data:rsData.times
				},
			rationFixedCycle:{
					name:"�̶�����",
					data:rsData.fixedCycle
				},
		},
		combogrid:{
			invalidLocs:{
				name:"��Ч����"
				},
			validLocs:{
				name:"��Ч����"
				},
			taskItem:{
				name:"������"
				},
			relationSign:{
				name:"����������"
				},
			relationEvents:{
				name:"�����¼���"
				},
			relationDocAdvices:{
				name:"����ҽ����"
				},
			relationAssess:{
				name:"����������"
				}
			
		},
		input:{
			exclusions:{
				name:"�ų�������Ч����"
				},
			normalPeriod:{
				name:"�������������"
			},
			normalIntervalPeriod:{
				name:"������������"
				},
			normalExeRule:{
				name:"��������ִ�й���"
				},
			taskDesc:{
				name:"���滤����������"
				},
			taskCode:{
				name:"����"
				},
			relationFormula:{
				name:"��Ч��ʽ"
				},
			relationTodayExeRule:{
				name:"������ִ�й���"
				},
			relationNotTodayExeRule:{
				name:"�ǵ�����ִ�й���"
				},
			relationIntervalPeriod:{
				name:"�������"
				},
			relationPeriod:{
				name:"��������"
				},
			relationExeMethod:{
				name:"ִ�з���"
				},
			normalFormula:{
				name:"����ֵ��Ч��ʽ"
				},
			normalSustain:{
				name:"�ع�������������"
				},
			relationUDNum:{
				name:"�Զ���ֵ"
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
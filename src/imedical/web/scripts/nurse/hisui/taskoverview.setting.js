
///taskoverview.setting.js
$(window).load(function() {
	$("#loading").hide();
	$Method.init()
	
	$("#BFind").on("click",function(){
		$Method.dataGridList();
	})
	$("body").on("click",".btnTaskSearch",function(){
		var id = $(this).parents("div.searchBtn").attr("id")
		var value = $(this).parents("div.searchBtn").find("input.startDayReport").val();
		var tid = id.split("-")[0]
		var type = id.split("-")[1]
		//var parmas = contorls[tid].parmas()
		//parmas.desc=value
		//var hospID = $HUI.combogrid('#_HospList').getValue();
		//parmas.hospID = hospID
		//console.log(id)
		var taskVal = $("#taskAttr").combobox("getValue");
		var parmas=""
		if(taskVal==1){
			parmas = contorls.relationSign.parmas()
		}else if(taskVal==2){
			parmas = contorls.relationAssess.parmas()
		}else if(taskVal==3){
			parmas = contorls.relationDocAdvices.parmas()
		}
		if(parmas !=""){ 
			parmas.desc=value
			$('#'+tid).combogrid("grid").datagrid("reload", parmas);
		}	
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
})
//页面加载初始化操作

var $Method = {
	init:function(){
		$Method.hospList()
		$Method.myWin()
		$Method.rsTaskOverviewData()
		
	},
	hospList:function(){
		//所属医院下拉列表
		var hospComp = GenHospComp("Nur_IP_Question");
		hospComp.jdata.options.onSelect = function(e,t){
			$Method.dataGridList();
		}
		hospComp.jdata.options.onLoadSuccess= function(data){
			$Method.dataGridList();
		}
	},
	dataGridList:function(){
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
			columns :$Method.dataGridColumns(),
			toolbar :$Method.dataGridToolBar(),
			autoRowHeight:true,
			nowrap:false,  /*此处为false*/
			url : $URL+"?ClassName=Nur.NIS.Service.TaskOverview.Setting&QueryName=GetTaskOverNormList",
			onBeforeLoad:function(param){
				$('#tabQuestionList').datagrid("unselectAll");
				var locId = session['LOGON.CTLOCID']
				param = $.extend(param,{keyword:$("#SearchDesc").val(),loc:locId,hospDR:$HUI.combogrid('#_HospList').getValue(),groupFlag:""})
				
			},
			onDblClickRow:function(rowIndex, rowData){
					
					//双击事件
					runClassMethod("Nur.NIS.Service.TaskOverview.Setting","GetTaskoverNormById",{id:rowData.id},function(data){
						$("#myWin").window('open');
						setContorlsValue(data);
					},'json',false);
			}
		})
		
	},
	dataGridColumns:function(){
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
	},
	dataGridToolBar:function(){
		var ToolBar = [{
            text: '新增',
            iconCls: 'icon-add',
            handler: function() {
	            $Method.create(contorls)
	            $("#condion-panel-one,#condion-panel-two,#condion-panel-three").hide().find("tr").hide()
	            contorls.id=""
	            $('#form-save').form('clear');
	            $("div.div-combo-text").html('')
				$("#myWin").window('open');				
            }
        },{
            text: '修改',
            iconCls: 'icon-write-order',
            handler: function() {
				$Method.create(contorls)
				var row = $("#tabQuestionList").datagrid("getSelected");
				$("#condion-panel-one,#condion-panel-two,#condion-panel-three").hide().find("tr").hide()
				if (!row) {
					$.messager.alert("提示","请选择需要修改的记录！");
					return false;
				}
				runClassMethod("Nur.NIS.Service.TaskOverview.Setting","GetTaskoverNormById",{id:row.id},function(data){
					$("#myWin").window('open');
					setContorlsValue(data);
				},'json',false);
				
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
							$Method.dataGridList();
						},'json',false);
				    }    
				}); 
				
				
				
				
            }
        }];
        return ToolBar
	},
	myWin:function (){
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
	},
	rsTaskOverviewData:function(){
		var rsContorls;
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
			setContorlsData(rsData)
			$Method.create(contorls)
		},'json',false);
		return rsContorls
	},
	create:function(contorls){
		$("#condion-panel-one,#condion-panel-two,#condion-panel-three").hide().find("tr").hide()
		$('#form-save').form('clear');
		$("#taskItem").parents("tr").hide()
		
		for(var cid in contorls){
			var obj = contorls[cid]
			if("combox"==obj.type){
				var queryName = obj.changeQuery
				var values = obj.values
				if(typeof(queryName)!="undefined"){
					MethodCreate.combox(cid).combobox({"data":obj.data,"onChange":queryName})
				}else{
					MethodCreate.combox(cid).combobox({"data":obj.data})
				}
				if(typeof(values)!="undefined"){
					$("#"+cid).combobox("setValue",values)
				}
			}else if("comboxIsMultiple"==obj.type){
				var values = obj.values
				MethodCreate.combox(cid).combobox({"data":obj.data,"multiple":true,'rowStyle':'checkbox'})
				if(typeof(values)!="undefined"){
					$("#"+cid).combobox("setValues",values)
				}
			}else if("combogrid"==obj.type){
				if(obj.classMethod !=""){
					MethodCreate.combogrid(cid,obj.classMethod,obj.queryName,obj.columns(),obj.parmas())	
				}
				var values = obj.values
				var names = obj.names
				if(typeof(values)!="undefined"){
					for(var k in values){
						insertComboValues(cid,values[k],names[k])
					}
				}
			}else if("input"==obj.type){
				var values = obj.values
				$("#"+cid).attr("autocomplete","off")
				if(typeof(values)!="undefined"){
					var isnumberbox = $("#"+cid).hasClass("numberbox")
					if(isnumberbox){
						
						$("#"+cid).numberbox("setValue",values)
					}else{
						$("#"+cid).val(values)
					}
				}
			}	
		}	
	}
}





/**多选下拉框、自带检索功能***/
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
function isExitValue(selector,id){
	var $div = $("#"+selector).siblings("span.combo").find("div.div-combo-text")
	var len = $div.find('span[id="'+id+'"]').length
	if(len>0){
		return false	
	}
	return true
}
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

/**动态创建下拉框和下拉多选框**/
var MethodCreate ={
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
	combogrid:function(selector,clsname,quyname,columns,parmas) {
		var searchhtml = $("#comboxSearch").html()
		var len = $('#'+selector+"-search").length

		if(len==0){
			var id = selector+"-search"
			var html = '<div style="margin-bottom: 5px; " class="searchBtn" id="'+id+'">'+searchhtml+'</div>'
			$("#comboxSearch").after(html)
			
		}
		var find = false;
		$("#"+selector).combogrid({
			panelWidth: 350,
			panelHeight: 350,
			editable: false,
			idField: 'id',
			textField: 'desc',
			columns: columns,
			pagination : true,
			url:$URL+"?ClassName="+clsname+"&QueryName="+quyname,
			fitColumns: true,
			toolbar: '#'+selector+"-search",
			pageSize:50,
			multiple: true,
			striped: true,
			mode:"remote",
			queryParams:parmas,
			loadFilter: function(obj) {
			  var arrs = []
			  $.each(obj.rows, function(index, value) {
	                if (isExitValue(selector,value.id)) {
	                    
	                    
	                    if("invalidLocs"==selector || "validLocs"==selector){
							value.desc=value.warddesc
							value.id = value.wardid
						}
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
				
				/*if("invalidLocs"==selector || "validLocs"==selector){
					rowData.desc=rowData.warddesc
					rowData.id = rowData.
					
				}*/
				var desc = rowData.desc
				var id = rowData.id	
				insertComboValues(selector,id,desc)
				$('#'+selector).combogrid("grid").datagrid("load");
				
				if("relationAssess"!=selector){
					return false;
					
				}
				
				runClassMethod("Nur.NIS.Service.VitalSign.TaskRule","GetAssessCareDate",{itemId:rowData.id},function(data){
					$("#careDate").val(data.careDate)
					$("#careTime").val(data.careTime)	
				},'json',false);
				

				return false
			}
		});
	}
}


/**保存和继续新增
flag = 1 保存
flag = 2 继续新增
思路：contorls取的所有的控件，去除页面不显示的控件，获取显示的控件的值
required=="true"时，表示控件为必填项
**/
function saveFunLib(flag){
	
	
	
	
	var exeRuleValue = $("span.exeRule.bgselect").attr("value");	
	$("#relationTodayExeRule").val(exeRuleValue)
	
	
	
	
	var parmas = {}
	var isNullValue=[]
	for(var cid in contorls){
		var obj=contorls[cid]
		var isDisplay = $('#'+cid).parents("tr").is(':hidden');
	 	if(isDisplay=='true' || isDisplay){
		 	continue;
		}
		var len = $("#"+cid).length
		if(len ==0){
			 continue;
		}
		var type = obj.type
		var value= ""
		if(type=="input"){
			value= $("#"+cid).val()
		}
		if(type=="combox"){
			value= $("#"+cid).combo("getValue")
		}
		if(type=="comboxIsMultiple"){
			value = $("#"+cid).combo("getValues")
		}
		if(type=="combogrid"){
			value=[]
			var $div = $("#"+cid).siblings("span.combo").find("div.div-combo-text")
			$div.find('span').each(function(){
				var val = $(this).attr("id")
				value.push(val)
			})	
		}
		
		var required = obj.required
		if(required=="true"){
			if(value.length==0){
				isNullValue.push(obj.name)
			}
		}
		parmas[cid]=value
	}
	console.log(parmas)
	if(isNullValue.length>0){
		$.messager.alert('提示',isNullValue[0]+'存在必填项未填写，请检查！' , "info");
		return false;	
	}
	parmas.id = flag==1?contorls.id:""
	parmas.hospID=$HUI.combogrid('#_HospList').getValue()
	parmas.locId = session['LOGON.CTLOCID'];
	parmas.userId=session['LOGON.USERID']

	$.m({
		ClassName:"CF.NUR.NIS.TaskOverview",
		MethodName:"AddOrUpdateTaskOverNorm",
		data:JSON.stringify(parmas)
	},function (rtn){
		if(rtn == 0) {
			$.messager.popover({msg:'保存成功！',type:'success'});
			//$('#form-save').form('clear');
			//$("div.div-combo-text").html('')
			//$("#condion-panel-one,#condion-panel-two,#condion-panel-three").hide()
			$Method.dataGridList();
			//location.reload()
		} else {
			$.messager.alert('提示','保存失败！'+ rtn , "info");
			return false;
		}
	})
}
/**编辑和查阅时，将值显示在控件中**/
function setContorlsValue(data){
	contorls.id = data.id

	$('#form-save').form('clear');
	for(var key in data){
		if(typeof(contorls[key])!='undefined'){
			contorls[key].values = data[key]
			var names = data[key+"Name"]
			if(typeof(names) !='undefined'){
				contorls[key].names = names
			}
		}
	}
	$Method.create(contorls)
	
	if(typeof(data.relationNotTodayExeRule)!='undefined'){
		$("#relationNotTodayExeRule").parents("tr").find("span[value='"+data.relationNotTodayExeRule+"']").trigger("click")
	}

	if(typeof(data.relationTodayExeRule)!='undefined'){	

		$("#relationTodayExeRule").parents("tr").find("span[value='"+data.relationTodayExeRule+"']").trigger("click")
	}
	
}
/**编辑时，给控件下拉单选控件和多选控件默认值**/
function setContorlsData(rsData){
	console.log(rsData)
	contorls.applyPatient.data					=		rsData.patientType
	contorls.exePeriod.data						=		rsData.exeTime
	contorls.taskAttr.data						=		rsData.taskAttr
	contorls.type.data							=		rsData.type
	contorls.rationIntervalType.data			=		rsData.intervalType
	contorls.relationExeMode.data				=		rsData.exeMode
	contorls.relationIntervalPeriodUnit.data	=		rsData.periodUnit
	contorls.relationPeriodUnit.data			=		rsData.periodUnit
	//contorls.normalSustainUnit.data				=		rsData.periodUnit
	contorls.normalPeriodUnit.data				=		rsData.periodUnit
	contorls.normalIntervalPeriodUnit.data		=		rsData.periodUnit
	contorls.careDate.data						=		rsData.sqlFieldList
	contorls.careTime.data						=		rsData.sqlFieldList
	

	contorls.relationTodayExeTime.data			=		rsData.times
	contorls.relationNotTodayExeTime.data		=		rsData.times
	contorls.normalExeTime.data					=		rsData.times
	contorls.rationFixedCycle.data				=		rsData.fixedCycle
	
}


function findShow(){
	$("#condion-panel-one,#condion-panel-two,#condion-panel-three").hide()
	$("#condion-panel-one").find("tr").each(function(){
		var display =$(this).css('display');
		if(display !="none"){
			$("#condion-panel-one").show()
		}
	})
	$("#condion-panel-two").find("tr").each(function(){
		var display =$(this).css('display');
		if(display !="none"){
			$("#condion-panel-two").show()
		}
	})
	$("#condion-panel-three").find("tr").each(function(){
		var display =$(this).css('display');
		
		if(display !="none"){
			$("#condion-panel-three").show()
		}
	})
	
	
}


/**页面所有控件的类型、点击事件、是否必填等参数**/
var contorls = {
	

			applyPatient:{
					type:"combox",
					name:"适用患者"
				},
			exePeriod:{
					type:"combox",
					name:"执行有效时间设定",
					required:"true"
				},
			
			taskAttr:{
					name:"任务属性",
					type:"combox",
					required:"true",
					changeQuery:function(value,oldValue){
						$("#condion-panel-one,#condion-panel-two,#condion-panel-three").hide().find("tr").hide()
						$("#taskItem").parents("tr").show()
						var classMethod=""
						var queryName=""
						var columns=""
						var parmas=""
						if(value==1){
							classMethod=contorls.relationSign.classMethod	
							queryName=contorls.relationSign.queryName
							columns = contorls.relationSign.columns()	
							parmas = contorls.relationSign.parmas()	
							$("#type").parents("tr").show();	
						}else if(value==2){
							classMethod=contorls.relationAssess.classMethod	
							queryName=contorls.relationAssess.queryName	
							columns = contorls.relationAssess.columns()	
							parmas = contorls.relationAssess.parmas()	
							$("#type").parents("tr").show();
						}else if(value==3){
							classMethod=contorls.relationDocAdvices.classMethod	
							queryName=contorls.relationDocAdvices.queryName
							columns = contorls.relationDocAdvices.columns()	
							parmas = contorls.relationDocAdvices.parmas()	
							$("#relationDocAdvices,#type").parents("tr").show();	
						}
						var typeArrs = contorls.type.data;
						var typeObj  = {}
						for(var key in typeArrs){
							var val = typeArrs[key].value
							var txt = typeArrs[key].text
							typeObj[val] = txt
						}
						var keyArrs = []
						var list = tempVals["taskAttr-"+value].type
						for(var key in list){
							var txt = typeObj[key]
							if(typeof(txt) !="undefined"){
								keyArrs.push({"value":key,"text":txt})
							}
						}
						console.log(keyArrs)
						$("#type").combobox({'data':keyArrs});
						//contorls.type.data=keyArrs
						MethodCreate.combogrid("taskItem",classMethod,queryName,columns,parmas)
						$("div.div-combo-text").html('')
						findShow()
					}
				},
				
			type:{
					name:"类型",
					type:"combox",
					required:"true",
					changeQuery:function(value,oldValue){
					
						$("#condion-panel-two,#condion-panel-three").hide().find("tr").hide();	
						$("#rationIntervalType").parents("tr").siblings("tr").hide()
						var v = $("#taskAttr").combobox("getValue");
						var key = "taskAttr-"+v+"-type-"+value
						var showIds = tempVals["taskAttr-"+v]["type"][value]
						if(typeof(showIds) !="undefined"){
							$("#condion-panel-two").show();
							$("#type").parents("tr").siblings("tr").hide()
							$(showIds).parents("tr").show();
						}
						findShow()
					}
				},
			rationIntervalType:{
					name:"执行类型",
					type:"combox",
					changeQuery:function(value,oldValue){
						
						$("#rationIntervalType").parents("tr").siblings("tr").hide()
						var v = $("#taskAttr").combobox("getValue");
						var key = "taskAttr-"+v+"-rationIntervalType-"+value
						var showIds = tempVals["taskAttr-"+v]["rationIntervalType"][value]
						$(showIds).parents("tr").show();
					}
				},
			relationExeMode:{
					name:"执行模式",
					type:"combox",
					changeQuery:function(value,oldValue){
						$("#relationExeMode").parents("tr").siblings("tr").hide()
						var v = $("#taskAttr").combobox("getValue");
						var showIds = tempVals["taskAttr-"+v]["relationExeMode"][value]
						$(showIds).parents("tr").show();
					}
				},
			relationIntervalPeriodUnit:{
					type:"combox",
					name:"间隔周期(单位)"
				},
			relationPeriodUnit:{
					type:"combox",
					name:"持续周期(单位)"
				},
			normalSustainUnit:{
					type:"combox",
					name:"回归正常持续周期(单位)",
					data:[{"text":"次","value":"TIME"},
					{"text":"天","value":"DAY"}]
				},
			normalPeriodUnit:{
					type:"combox",
					name:"正常后持续周期(单位)"
				},
			normalIntervalPeriodUnit:{
					type:"combox",
					name:"正常后间隔周期(单位)"
				},
			relationUDUnit:{
					type:"combox",
					name:"自定义单位",
					data:[{"text":"小时","value":"HOUR"}]	//,{"text":"分钟","value":"MINUTE"}
				},
			relationUDOperator:{
					type:"combox",
					name:"自定义操作符",
					data:[{"text":"之前","value":"2"},
					{"text":"之后","value":"3"},
					{"text":"(12h)每间隔","value":"4"},
					{"text":"(24h)每间隔","value":"5"},
					/*{"text":"遵医嘱","value":"6"},*/
					]	
				},
				
			relationExeShift:{
					type:"comboxIsMultiple",
					name:"需执行班次"
				},
			relationNotTodayExeShift:{
					type:"comboxIsMultiple",
					name:"非当日需执行班次"
				},
			relationTodayExeShift:{
					type:"comboxIsMultiple",
					name:"当日需执行班次"
				},
			relationTodayExeTime:{
					type:"comboxIsMultiple",
					name:"当日需执行时间"
				},
			relationNotTodayExeTime:{
					type:"comboxIsMultiple",
					name:"非当日需执行时间"
				},
			normalExeTime:{
					type:"comboxIsMultiple",
					name:"正常后需执行时间"
				},
			rationFixedCycle:{
					type:"comboxIsMultiple",
					name:"固定周期"
				},
			invalidLocs:{
				type:"combogrid",
				name:"无效科室",
				classMethod:"Nur.NIS.Service.Base.Ward",
				queryName:"GetallWardNew",
				parmas:function(){ 
					return {
						desc: $("#startDayReport").val(),
						hospid:$HUI.combogrid('#_HospList').getValue(),
						bizTable:"Nur_IP_TaskOverviewNormal" 
					}
				},
				columns: function(){
					return [[{field:'warddesc',title:'名称',width:350}]]		
				}
			},
			validLocs:{
				type:"combogrid",
				name:"生效科室",
				classMethod:"Nur.NIS.Service.Base.Ward",
				queryName:"GetallWardNew",
				parmas:function(){ 
					return {
						desc: $("#startDayReport").val(),
						hospid:$HUI.combogrid('#_HospList').getValue(),
						bizTable:"Nur_IP_TaskOverviewNormal" 
					}
				},
				columns: function(){
					return [[{field:'warddesc',title:'名称',width:350}]]		
				}
			},
			taskItem:{
				type:"combogrid",
				name:"任务项",
				required:"true",
				classMethod:"",
				queryName:"",
				parmas:function(){ 
					return {
						desc: $("#startDayReport").val(),
						hospID:$HUI.combogrid('#_HospList').getValue()
					}
				},
				columns: function(){
					return [[{field:'desc',title:'名称',width:350}]]		
				}
			},
			relationSign:{
				type:"combogrid",
				name:"关联体征项",
				required:"true",
				classMethod:"Nur.NIS.Service.TaskOverview.Setting",
				queryName:"GetSignsItem",
				parmas:function(){ 
					return {
						desc: $("#startDayReport").val(),
						hospID:$HUI.combogrid('#_HospList').getValue()
					}
				},
				columns: function(){
					return [[{field:'desc',title:'名称',width:350}]]		
				}
			},
			relationEvents:{
				type:"combogrid",
				name:"关联事件项",
				required:"true",
				classMethod:"Nur.NIS.Service.TaskOverview.Setting",
				queryName:"GetEventType",
				parmas:function(){ 
					return {
						desc: $("#startDayReport").val(),
						hospID:$HUI.combogrid('#_HospList').getValue()
					}
				},
				columns: function(){
					return [[{field:'desc',title:'名称',width:350}]]			
				}
			},
			relationDocAdvices:{
				type:"combogrid",
				name:"关联医嘱项",
				required:"true",
				classMethod:"Nur.NIS.Service.TaskOverview.Setting",
				queryName:"GetDocAdvice",
				parmas:function(){ 
					return {
						desc: $("#startDayReport").val(),
						hospDR:$HUI.combogrid('#_HospList').getValue()
					}
				},
				columns: function(){
					return [[{field:'desc',title:'名称',width:350}]]		
				}
			},
			relationAssess:{
				type:"combogrid",
				name:"关联评估项",
				required:"true",
				classMethod:"Nur.NIS.Service.TaskOverview.Setting",
				queryName:"GetAssessItems",
				parmas:function(){ 
					return {
						desc: $("#startDayReport").val(),
						hospID:$HUI.combogrid('#_HospList').getValue()
					}
				},
				columns: function(){
					return [[{field:'desc',title:'名称',width:350}]]		
				}
			},
			exclusions:{
				type:"input",
				name:"排除条件生效方法"
				},
			normalPeriod:{
				type:"input",
				name:"正常后持续周期"
			},
			normalIntervalPeriod:{
				type:"input",
				name:"正常后间隔周期"
				},
			normalExeRule:{
				type:"input",
				name:"正常后需执行规则"
				},
			taskDesc:{
				type:"input",
				name:"常规护理任务描述"
				},
			taskCode:{
				type:"input",
				required:"true",
				name:"代码"
				},
			relationFormula:{
				type:"input",
				required:"true",
				name:"生效公式"
				},
			relationTodayExeRule:{
				type:"input",
				required:"true",
				name:"当日需执行规则"
				},
			relationNotTodayExeRule:{
				type:"input",
				name:"非当日需执行规则"
				},
			relationIntervalPeriod:{
				type:"input",
				name:"间隔周期"
				},
			relationPeriod:{
				type:"input",
				name:"持续周期"
				},
			relationExeMethod:{
				type:"input",
				name:"执行方法"
				},
			normalFormula:{
				type:"input",
				name:"正常值生效公式"
				},
			normalSustain:{
				type:"input",
				name:"回归正常持续周期"
				},
			relationUDNum:{
				type:"input",
				name:"自定义值"
			},
			careDate:{
				type:"input",
				required:"true",
				name:"关联评估日期"
			},
			careTime:{
				type:"input",
				required:"true",
				name:"关联评估时间"
			},
	}




var tempVals={
	"taskAttr-1":{
		"type":{
			"NORMAL":"#type,#rationIntervalType",
			"SIGNS":"#relationTodayExeRule,#relationIntervalPeriod,#relationSign,#relationFormula,#relationTodayExeTime,#relationNotTodayExeTime,#relationPeriod,#normalSustain,#normalExeTime,#normalPeriod,#normalFormula",
			"ORDER":"#relationDocAdvices,#relationExeMode",
			"SIGNORDER":"#relationSign,#relationDocAdvices,#relationFormula,#relationTodayExeTime,#relationNotTodayExeTime,#relationPeriod,#normalSustain,#normalExeTime,#normalPeriod,#NormalFormula",
			"EVENT":"#relationEvents,#relationTodayExeRule,#relationTodayExeTime,#relationNotTodayExeTime,#relationIntervalPeriod,#relationPeriod",//#relationTodayExeRule,#relationNotTodayExeRule,
			"MUTIPLY":"#relationEvents,#relationTodayExeRule,#relationDocAdvices,#relationTodayExeTime,#relationNotTodayExeTime,#relationPeriod",
			"SPECIAL":"#relationExeMethod"
		},
		"rationIntervalType":{
			"1":"#rationFixedCycle,#relationTodayExeTime",
			"2":"#relationTodayExeTime,#relationPeriod,#relationIntervalPeriod"
		},
		"relationExeMode":{
			"2":"#relationTodayExeRule,#relationTodayExeTime,#relationNotTodayExeTime,#relationIntervalPeriod,#relationPeriod",
			"3":"#rationFixedCycle,#relationTodayExeTime"
		}
	},
	"taskAttr-2":{
		"type":{
			"NORMAL":"#rationIntervalType",
			"ORDER":"#relationDocAdvices,#relationExeMode",
			"EVENT":"#relationEvents,#relationTodayExeRule,#relationTodayExeTime,#relationNotTodayExeTime,#relationIntervalPeriod,#relationPeriod",//#relationNotTodayExeRule,#relationTodayExeRule,
			"SPECIAL":"#relationExeMethod",
			"ASSESS":"#normalSustain,#relationTodayExeRule,#careDate,#careTime,#relationAssess,#relationFormula,#relationPeriod,#relationTodayExeTime,#relationNotTodayExeTime,#relationIntervalPeriod,#normalFormula,#normalExeTime,#normalIntervalPeriod,#normalPeriod",//#relationTodayExeRule,#relationNotTodayExeRule,
			"ORDERASSESS":"#normalSustain,#relationTodayExeRule,#careDate,#careTime,#relationAssess,#relationDocAdvices,#relationFormula,#relationPeriod,#relationTodayExeTime,#relationNotTodayExeTime,#relationIntervalPeriod,#normalFormula,#normalExeTime,#normalIntervalPeriod,#normalPeriod",//#relationTodayExeRule,#relationNotTodayExeRule,
			"MUTIPLY":"#relationEvents,#relationTodayExeRule,#relationDocAdvices,#relationTodayExeTime,#relationNotTodayExeTime,#relationPeriod",
			"SIGNORDER":"#relationTodayExeRule,#relationSign,#relationDocAdvices,#relationFormula,#relationTodayExeTime,#relationNotTodayExeTime,#relationPeriod,#normalSustain,#normalExeTime,#normalPeriod,#NormalFormula",
		},
		"rationIntervalType":{
			"1":"#rationFixedCycle,#relationTodayExeTime",
			"2":"#relationTodayExeTime,#relationIntervalPeriod,#relationPeriod"
		},
		"relationExeMode":{
			"2":"#relationTodayExeRule,#relationTodayExeTime,#relationNotTodayExeTime,#relationIntervalPeriod,#relationPeriod",
			"3":"#rationFixedCycle,#relationTodayExeTime"
		}
	},
	"taskAttr-3":{
		"type":{
			"ORDER":"#type,#relationDocAdvices",
		
		}
		
		}
	/*"taskAttr-3":{
		"type":{
			"ORDER":"#type,#relationDocAdvices,#relationExeMode",
			//"MUTIPLY":"#relationEvents,#relationTodayExeRule,#relationDocAdvices,#relationTodayExeTime,#relationNotTodayExeTime,#relationPeriod,#relationIntervalPeriod",
		
		},
		"relationExeMode":{
			"2":"#relationTodayExeRule,#relationTodayExeTime,#relationNotTodayExeTime,#relationIntervalPeriod,#relationPeriod",
			"3":"#rationFixedCycle,#relationTodayExeTime"
		}
	}*/
}
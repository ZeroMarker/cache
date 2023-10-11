var EpisodeIDStr=EpisodeID, startDate="", startTime="", endDate="", endTime, orderTypeFlag="", excutedOrderFlag="", selectedCode="", datagridStatus={};
/**
* @description 初始化UI
*/
function initUI() {
	//initSearchCondition();
	//initPatientTree();
	initSearchDTime();
	initTabs();		
}
/**
* @description 初始化查询条件
*/
function initSearchCondition() {
	$('#wardPatientSearchBox').searchbox({
		searcher: function(value) {
			$HUI.tree('#patientTree','reload');
		}
	});
	$('#wardPatientCondition').switchbox('options').onSwitchChange = function(){
		$HUI.tree('#patientTree','reload');
	};
}
/**
* @description 初始化患者树
*/
function initPatientTree() {
	$HUI.tree('#patientTree', {
		checkbox: true,
		loader: function(param, success, error) {
			$cm({
				ClassName: "NurMp.NursingRecords",
				MethodName: "getWardPatients",
				wardID: session['LOGON.WARDID'],
				adm: EpisodeID,
				groupSort: !$('#wardPatientCondition').switchbox('getValue'),
				babyFlag: '',
				searchInfo: $HUI.searchbox('#wardPatientSearchBox').getValue(),
				locID: session['LOGON.CTLOCID']||'',
				todayOperFlag: $("#radioTodayOper").radio('getValue')
			}, function(data) {
				var addIDAndText = function(node) {
					node.id = node.ID;
					node.text = node.label ;
					if (node.id === EpisodeID) {
						node.checked = true;
					}
					if (node.children) {
						node.children.forEach(addIDAndText);
					}
				}
				data.forEach(addIDAndText);
				success(data);
			});
		},
		onLoadSuccess: function(node, data) {
			if (!!EpisodeID) {
				var selNode = $('#patientTree').tree('find', EpisodeID);
				$('#patientTree').tree('select', selNode.target);
				$('#patientTree').tree('check', selNode.target);
			}
		},
		lines: true,
		onClick: function (node) {
			console.log(node);
			if(node.checked){
				$('#patientTree').tree("uncheck", node.target)	
			}else{
				$('#patientTree').tree("check", node.target)
			}		
		}
	});
}

/**
* @description 初始化查询时间
*/
function initSearchDTime(){
	runClassMethod("Nur.NIS.Service.OrderExcute.QueryOrder","GetQueryConfig",{"hospId":session['LOGON.HOSPID']},function(data){
		startDate = data.startDate;
		startTime = data.startTime;
		endDate = data.endDate;
		endTime = data.endTime;
		$('#startDate').datebox("setValue",data.startDate);
		$('#startTime').timespinner("setValue", data.startTime);  
		$('#endDate').datebox("setValue",data.endDate);
		$('#endTime').timespinner("setValue", data.endTime); 
	},'json',false)
}

/**
* @description 初始化执行记录单据
*/
function initTabs() {
	// 计算table高度
	$("#execute-record").height($("body").height()-46);
	var tabHeight = $("#orderTabs").height();
	var tableHeight = tabHeight - 37;
	console.log(tableHeight);
	
	$HUI.tabs("#orderTabs",
	{
		onSelect:function(title,index){
			selectedCode = $HUI.tabs("#orderTabs").getTab(index).data("code");
			if(selectedCode=="PDASXD"){
				$(".td-checkbox").hide();	
			}else{
				$(".td-checkbox").show();
			}
			$(".webui-popover").remove();
			initTable(0);
		}
	});
	
	var res=$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetAllSheet",
		hospId:session['LOGON.HOSPID'],
		//filter:"N",
		applyServices:"PDA"
	},false);
	var data=res.rows;
	if(data.length>0){
		for(i=0; i<data.length; i++){
			$HUI.tabs("#orderTabs").add({
	    		title: data[i].Name,
	    		selected: i == 0 ? true : false,	    		
	    		content: '<table id="orderList-' + data[i].Code + '" style="height: ' + tableHeight + 'px"></table>'
			});
			$HUI.tabs("#orderTabs").getTab(i).data("code",data[i].Code);
			datagridStatus[data[i].Code] = false;
		}
		selectedCode = data[0].Code;
		
		// 初始化默认单据的表格数据
		initTable(1);
	}
}

/**
* @description 初始化执行记录列表
*/
function initTable(firstLoadFlag){	
	if(selectedCode){
		if(!datagridStatus[selectedCode]){
			var columns = [];
			// 获取单据对应的表单列 Nur.NIS.Service.OrderExcute.Execute: GetSheetColumns
			runClassMethod("Nur.NIS.Service.OrderExcute.QueryOrder","GetSheetColumns",{sheetCode: selectedCode, "hospId":session['LOGON.HOSPID']},function(data){
				if(data.length > 0){
					var array = [];
					for(var i = 0; i < data.length; i++){
						if(data[i].key == "arcimDesc"){
							var obj = {
								field: data[i].key, title: data[i].title, width: parseInt(data[i].width),halign:"center",
								formatter: function(value, row, index){
				                    var str = '<div style="position:relative;"><p style="font-weight:bold;line-height:22px;padding-left:8px;">' + value + '</p>'
									if(row.childs.length > 0){
										str += ''
										for(var i = 0; i < row.childs.length; i++){
											str += '<p style="line-height:22px;padding-left:8px;">' + row.childs[i].arcimDesc + '</p>'
										}
										str += '<span style="display:inline-block;position:absolute;top:9px;left:-2px;bottom:9px;width:7px;border:1px solid #ccc;border-right:0;"></span></div>'
									}
									if(row.sameLabNoOrders && row.sameLabNoOrders.length > 0){
										for(var j = 0; j < row.sameLabNoOrders.length; j++){
											str += '<p style="font-weight:bold;line-height:22px;padding-left:8px;">' + row.sameLabNoOrders[j].arcimDesc + '</p>'
										}
									}
									if(row.samePartExecInfos && row.samePartExecInfos.length > 0){
										for(var m = 0; m < row.samePartExecInfos.length; m++){
											str += '<p style="font-weight:bold;line-height:22px;padding-left:8px;">' + row.samePartExecInfos[m].arcimDesc + '</p>'
										}
									}									
									return str
								},
								styler: function(value,row,index){
									if (row.backgroundColor) {
										return 'background-color:'+row.backgroundColor+';';
									}
								}
							}
						}else if(data[i].key == "exeRecord"){
							var obj = {
								field: data[i].key, title: data[i].title, width: parseInt(data[i].width),
								formatter: function(value, row, index){
									if(value.length > 0){
										return "<a class='exeRecord' id='exeRecord-" + selectedCode + index + "' style='cursor:pointer;' onclick='showStep(\"" + selectedCode + "\", " + index + ", " + JSON.stringify(value) + ")'>"+$g("明细")+"</a>"
									}																	
								}
							}
						}else{
							var obj = {
								field: data[i].key, title: data[i].title, width: parseInt(data[i].width)
							}
						}	
						array.push(obj);
					}	
					columns.push(array);
				}
			},'json',false);
			console.log(columns);			
			
			$("#orderList-" + selectedCode).datagrid({
				//view: scrollview,
				fitColumns: true,
				nowrap: false,
				pagination: true,
				pageSize: 50,
				pageList: [50, 100, 150, 200],
				loadMsg: "正在加载中...",
				columns: columns,
				onLoadSuccess:function(data){
					$(".webui-popover").remove();
					setPopover(data.rows);
				} 
			});
			datagridStatus[selectedCode] = true;
		}
		
		// 获取所有选中的患者
//		if(!firstLoadFlag){
//			var episodeIDArr=[];
//			var nodes = $('#patientTree').tree('getChecked');
//			if(nodes.length > 0){
//				for(var i = 0; i < nodes.length; i++){
//					episodeIDArr.push(nodes[i].episodeID);	
//				}
//				episodeIdStr = episodeIDArr.join("^");	
//			}else{
//				episodeIdStr = "";
//			}	
//		}		
		var longFlag = $("#long").checkbox('getValue');
		var tempFlag = $("#temp").checkbox('getValue');
		var exeFlag = $("#executed").checkbox('getValue');
		var unexeFlag = $("#unexecute").checkbox('getValue');
		orderTypeFlag = (longFlag && tempFlag) || (!longFlag && !tempFlag) ? "" : longFlag ? "long" : tempFlag ? "temp" : "";
		excutedOrderFlag = (exeFlag && unexeFlag) || (!exeFlag && !unexeFlag) ? "" : exeFlag ? "true" : unexeFlag ? "false" : "";
		startDate = $('#startDate').datebox("getValue");
		startTime = $('#startTime').timespinner("getValue");		
		endDate = $('#endDate').datebox("getValue");
		endTime = $('#endTime').timespinner("getValue"); 
		var methodName = "getAllPatOrderRecord";
		if(selectedCode != "PDASXD"){
			$cm({
				ClassName:"Nur.HISUI.OrderExecuteView",
				MethodName:"getAllPatOrderRecord",			
				episodeIdStr: EpisodeIDStr,
	            sheetCode: selectedCode,
	            groupID: session['LOGON.GROUPID'],
	            startDate: startDate,
	            startTime: startTime,
	            endDate: endDate,
	            endTime: endTime, 
		        wardID: session['LOGON.WARDID'],
		        locID: session['LOGON.CTLOCID'],
		        orderTypeFlag: orderTypeFlag,
		        excutedOrderFlag: excutedOrderFlag,    
			},function(data){
				reloadData(selectedCode, data);
			});	
		}else{
			// 输血单
			$cm({
				ClassName:"Nur.HISUI.OrderExecuteView",
				MethodName:"getBloodList",			
				episodeIdStr: EpisodeIDStr,
				wardID: session['LOGON.WARDID'],
	            startDate: startDate,
	            startTime: startTime,
	            endDate: endDate,
	            endTime: endTime       
			},function(data){
				reloadData(selectedCode, data);		
			});	
		}
	}
}

function reloadData(selectedCode, data){
	$(".webui-popover").remove();
	
	var newData={curPage:1,rows:data,total:data.length};
	$("#orderList-" + selectedCode).datagrid({loadFilter:pagerFilter}).datagrid('loadData',newData);
	setPopover(data);
}
function setPopover(data){
	var timer = setInterval(function(){
		var elemObj = $(".exeRecord");
		if(elemObj){
			clearInterval(timer);
			if(data.length > 0){
				for(var i = 0; i < data.length; i++){
					var record = data[i].exeRecord;
					var width = record.length > 0 ? 140 * record.length + 10 : 0;					
					if(record.length > 0){	
						var html = '<div id="hstp-' + selectedCode + i + '" style="height: 88px;"></div>';
						$HUI.popover("#exeRecord-" + selectedCode + i,{content: html,width: width,trigger: "manual"});						
					}					
				}
			}					
		}
	},100);
}
/**
* @description 重新加载执行记录列表
*/
function initTableData(){
	$HUI.datagrid('#orderList-' + selectedCode).load({
		episodeIdStr: EpisodeID,
      	sheetCode: selectedCode,
      	groupID: session['LOGON.GROUPID'],
      	startDate: startDate,
      	startTime: startTime,
      	endDate: endDate,
      	endTime: endTime, 
      	wardID: session['LOGON.WARDID'],
      	locID: session['LOGON.CTLOCID'],
      	orderTypeFlag: orderTypeFlag,
      	excutedOrderFlag: excutedOrderFlag
 	});	
}

function showStep(code, index, record){
	var data = eval(record);
	var items = [];				
	for(var j = 0; j < data.length; j++){
		var obj = {
			title: data[j].status,
			context: "<p>" + data[j].exeUser + "</p><p>" + data[j].exeDTime + "</p>"	
		};
		items.push(obj);								
	}
	var display = $("#hstp-" + code + index).parents(".webui-popover").css("display");
	if(display != "block"){
		$("#exeRecord-" + code + index).popover('show');
		if(!display){
			$("#hstp-" + code + index).hstep({
				stepWidth: 140,
				currentInd: data.length,
				items: items
			});
		}				
	}else{
		$("#exeRecord-" + code + index).popover('hide');
	}
}

$(function() {
	initUI();
});
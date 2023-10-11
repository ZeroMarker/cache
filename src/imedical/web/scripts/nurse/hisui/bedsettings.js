/**
* HISUI 床位图通用配置-主js
*/
var PageLogicObj={
	BabyBedPositionJSON: [{"id":"0","text":"底部"},{"id":"1","text":"右侧"}],
	BedCardColorJSON: [{"id":"0","text":"默认"},{"id":"1","text":"护理级别"},{"id":"2","text":"病情级别"},{"id":"3","text":"医保类型"},{"id":"4","text":"性别"}],
	OrderImgShow: [{"id":"S","text":"处理"},{"id":"E","text":"执行"},{"id":"P","text":"打印"}]
}
$(function(){ 
	InitHospList();
	InitEvent();
});
$(window).load(function() {
	$("#Loading").hide();
	InitSelect();
	$("#bedStatusTip").popover({
		trigger:'hover',
		content:"默认不可用原因：悬浮空床位时默认显示的不可用原因操作。<br><br>"+
		        "允许修改开始日期：修改床位状态为该不可用原因时是否允许修改开始日期。<br><br>"+
		        "是否显示此状态床位：床位图是否显示维护为该状态的床位。<br><br>",
		style:'inverse'
	});
});
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_BedSettings");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function switchChange(event,obj) {
	if (!obj.value) {
		$("#OccupySwitch").switchbox("setValue",false);
		$("#OccupyComponment").css('display','none');
	}else{
		$("#OccupyComponment").css('display','table-cell');
	}
}
function InitEvent(){
	$("#BSave").click(SaveConfig);
	$("#BBedRequestConfig").click(function(){
		$("#bedRequestConfig-dialog").dialog("open");
		initBasicDataTab();
		initSelectedBasicDataTab();
	});
}
function InitSelect(){
	$("#BabyBedPosition").combobox({
		valueField:'id',
		textField:'text',
		multiple:false,
		method:'local',
		data:PageLogicObj.BabyBedPositionJSON
	});
	$("#BedCardColor").combobox({
		valueField:'id',
		textField:'text',
		multiple:false,
		method:'local',
		data:PageLogicObj.BedCardColorJSON
	});
	$("#LongOrderImg").combobox({
		valueField:'id',
		textField:'text',
		multiple:false,
		method:'local',
		data:PageLogicObj.OrderImgShow
	});
	$("#TempOrderImg").combobox({
		valueField:'id',
		textField:'text',
		multiple:false,
		method:'local',
		data:PageLogicObj.OrderImgShow
	});
	$.cm({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		QueryName:"GetGroupItem",
		hospId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},function(data){
		$("#allowSwitchWardGroups").combobox({
			valueField:'ID',
			textField:'Group',
			multiple:false,
			method:'local',
			multiple:true,
			rowStyle:'checkbox',
			data:data.rows
		});
	})
}
function Init(){
	$.cm({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		MethodName:"GetBedSetting",
		hospId:$HUI.combogrid('#_HospList').getValue()
	},function(data){
		var IntervalTime=data.IntervalTime;
		/*var OperSwitch=data.OperSwitch
		if (OperSwitch==="") {
			OperSwitch=true
		}else{
			OperSwitch=data.OperSwitch==="Y"?true:false;
		}
		if (!OperSwitch) {
			//$("#UnableReason").checkbox('disable');
			$("#OccupyComponment").css('display','none');
		}else{
			$("#OccupyComponment").css('display','table-cell');
		}
		var OccupySwitch=data.OccupySwitch==="Y"?true:false;*/
		var BabyBedPosition=data.BabyBedPosition;
		var BedCardColor=data.BedCardColor;
		var AreaConfig=data.AreaConfig;
		var OutDays=data.OutDays;
		var HoverCardConfig=data.HoverCardConfig;
		//var SumConfig=data.SumConfig==="1"?true:false;
		var WardStatistics=data.WardStatistics;
		var LongOrderImg=data.LongOrderImg;
		var TempOrderImg=data.TempOrderImg;
		$("#IntervalTime").numberbox("setValue",IntervalTime);
		/*$("#OperSwitch").switchbox("setValue",OperSwitch);
		$("#OccupySwitch").switchbox("setValue",OccupySwitch);*/
		$("#BabyBedPosition").combobox("setValue",BabyBedPosition);
		$("#BedCardColor").combobox("setValue",BedCardColor);
		$("#Area_W,#Area_T,#Area_O").checkbox('setValue',false);
//		$("#Area_t").checkbox('setValue',false);
//		$("#Area_c").checkbox('setValue',false);
		AreaConfig.split("@").forEach(function(item){
			$("#Area_"+item).checkbox('setValue',true);
		})
		$("#OutDays").numberbox("setValue",OutDays);
		$("#HoverCard_A,#HoverCard_B,#HoverCard_W,#HoverCard_T,#HoverCard_O").checkbox('setValue',false)
//		$("#HoverCard_b").checkbox('setValue',false)
//		$("#HoverCard_w").checkbox('setValue',false)
//		$("#HoverCard_t").checkbox('setValue',false)
//		$("#HoverCard_c").checkbox('setValue',false)
		HoverCardConfig.split("@").forEach(function(item){
			$("#HoverCard_"+item).checkbox('setValue',true);
		})
		$("#HoverCardDelayTime").numberbox("setValue",data.HoverCardDelayTime);
		/*$("#Sum_1").checkbox('setValue',!SumConfig);
		$("#Sum_2").checkbox('setValue',SumConfig);*/
		$("#WardStatistics").val(WardStatistics);
		$("#LongOrderImg").combobox("setValue",LongOrderImg);
		$("#TempOrderImg").combobox("setValue",TempOrderImg);
		$("#patCredNoImgSwitch").switchbox("setValue",data.PatCredNoImgSwitch=="Y"?true:false);
		$("#IconFilter_L,#IconFilter_G,#IconFilter_R").checkbox("uncheck");
		for (var i=0;i<data.IconFilterConfigs.split("^").length;i++){
			var t=data.IconFilterConfigs.split("^")[i];
			$("#IconFilter_"+t).checkbox("check");
		}
		$("#waitHasBed,#waitNoBed,#transPat").checkbox("uncheck");
		for (var i=0;i<data.SumConfig1.split("^").length;i++){
			var t=data.SumConfig1.split("^")[i];
			$("#"+t).checkbox("check");
		}
		$("#mainDocRequired").checkbox("setValue",data.MainDocRequired=="Y"?true:false);
		$("#mainDocMulti").checkbox("setValue",data.MainDocMulti=="Y"?true:false);
		$("#mainNurseRequired").checkbox("setValue",data.MainNurseRequired=="Y"?true:false);
		$("#mainNurseMulti").checkbox("setValue",data.MainNurseMulti=="Y"?true:false);
		$("#updateMotherDocSyncBaby").switchbox("setValue",data.UpdateMotherDocSyncBabySwitch=="Y"?true:false);
		$("#allowBabyAloneAssignBed").switchbox("setValue",data.AllowBabyAloneAssignBedSwitch=="Y"?true:false);
		$("#showBedBillSwitch").switchbox("setValue",data.ShowBedBillSwitch=="Y"?true:false);
		$("#allowDragDocDischPat").checkbox("setValue",data.allowDragDocDischPat=="Y"?true:false);
		if (data.tranToWaitRoom=="OnlyNoAdmitDiagORDocDisch"){
			$("#waitRoom_OnlyNoAdmitDiagORDocDisch").radio("setValue",true);
		}else{
			$("#waitRoom_NotControl").radio("setValue",true);
		}
		$("#transbabyShowVirtualBed").switchbox("setValue",data.transbabyShowVirtualBed=="Y"?true:false);
		$("#loadBedByWardGroup").switchbox("setValue",data.loadBedByWardGroup=="Y"?true:false);
		$("#allowModifyBedType").switchbox("setValue",data.allowModifyBedType=="Y"?true:false);
		$("#allowModifyBedRoom").switchbox("setValue",data.allowModifyBedRoom=="Y"?true:false);
		$("#allowSwitchWardGroups").combobox("setValues",data.allowSwitchWardGroups==""?"":data.allowSwitchWardGroups.toString().split("$"));
	},false)
	initBedStatusTab();
}
function SaveConfig(){
	var IntervalTime=$("#IntervalTime").val();
	var OperSwitch=$("#OperSwitch").switchbox('getValue')?"Y":"N";
	var OccupySwitch=$("#OccupySwitch").switchbox('getValue')?"Y":"N";
	var BabyBedPosition=$("#BabyBedPosition").combobox("getValue");
	var BedCardColor=$("#BedCardColor").combobox("getValue");
	var AreaConfig=new Array();
	var Area_w=$("#Area_W").checkbox('getValue')?"W":"";
	if (Area_w!==""){
		AreaConfig.push(Area_w);
	}
	var Area_t=$("#Area_T").checkbox('getValue')?"T":"";
	if (Area_t!==""){
		AreaConfig.push(Area_t);
	}
	var Area_c=$("#Area_O").checkbox('getValue')?"O":"";
	if (Area_c!==""){
		AreaConfig.push(Area_c);
	}	
	var OutDays=$("#OutDays").val();
	var HoverCardConfig=new Array();
	var HoverCard_a=$("#HoverCard_A").checkbox('getValue')?"A":"";
	if (HoverCard_a!=="") {
		HoverCardConfig.push(HoverCard_a)
	}
	var HoverCard_b=$("#HoverCard_B").checkbox('getValue')?"B":"";
	if (HoverCard_b!=="") {
		HoverCardConfig.push(HoverCard_b)
	}
	var HoverCard_w=$("#HoverCard_W").checkbox('getValue')?"W":"";
	if (HoverCard_w!=="") {
		HoverCardConfig.push(HoverCard_w)
	}
	var HoverCard_t=$("#HoverCard_T").checkbox('getValue')?"T":"";
	if (HoverCard_t!=="") {
		HoverCardConfig.push(HoverCard_t)
	}
	var HoverCard_c=$("#HoverCard_O").checkbox('getValue')?"O":"";
	if (HoverCard_c!=="") {
		HoverCardConfig.push(HoverCard_c)
	}
	var HoverCardDelayTime=$("#HoverCardDelayTime").val();
	var LongOrderImg=$("#LongOrderImg").combobox("getValue");
	var TempOrderImg=$("#TempOrderImg").combobox("getValue");
	var SumConfig=$("#Sum_2").checkbox('getValue')?1:0;
	var WardStatistics=String($("#WardStatistics").val()).trim();
	
	var patCredNoImgSwitch=$("#patCredNoImgSwitch").switchbox("getValue")?"Y":"N";
	var showBedBillSwitch=$("#showBedBillSwitch").switchbox("getValue")?"Y":"N";
	var IconFilterConfigsArr=[];
	$("#IconFilter_L").checkbox("getValue")?IconFilterConfigsArr.push("L"):"";
	$("#IconFilter_G").checkbox("getValue")?IconFilterConfigsArr.push("G"):"";
	$("#IconFilter_R").checkbox("getValue")?IconFilterConfigsArr.push("R"):"";
	
	var SumConfig1Arr=[];
	$("#waitHasBed").checkbox("getValue")?SumConfig1Arr.push("waitHasBed"):"";
	$("#waitNoBed").checkbox("getValue")?SumConfig1Arr.push("waitNoBed"):"";
	$("#transPat").checkbox("getValue")?SumConfig1Arr.push("transPat"):"";
	
	var mainDocRequired=$("#mainDocRequired").checkbox("getValue")?"Y":"N";
	var mainDocMulti=$("#mainDocMulti").checkbox("getValue")?"Y":"N";
	var mainNurseRequired=$("#mainNurseRequired").checkbox("getValue")?"Y":"N";
	var mainNurseMulti=$("#mainNurseMulti").checkbox("getValue")?"Y":"N";
	var updateMotherDocSyncBaby=$("#updateMotherDocSyncBaby").switchbox("getValue")?"Y":"N";
	var allowBabyAloneAssignBed=$("#allowBabyAloneAssignBed").switchbox("getValue")?"Y":"N";
	var allowDragDocDischPat=$("#allowDragDocDischPat").checkbox("getValue")?"Y":"N";
	var tranToWaitRoom=$("#waitRoom_OnlyNoAdmitDiagORDocDisch").radio("getValue")?"OnlyNoAdmitDiagORDocDisch":"NotControl";
	var transbabyShowVirtualBed=$("#transbabyShowVirtualBed").switchbox("getValue")?"Y":"N";
	var loadBedByWardGroup=$("#loadBedByWardGroup").switchbox("getValue")?"Y":"N";
	var allowModifyBedType=$("#allowModifyBedType").switchbox("getValue")?"Y":"N";
	var allowModifyBedRoom=$("#allowModifyBedRoom").switchbox("getValue")?"Y":"N";
	var allowSwitchWardGroups=$("#allowSwitchWardGroups").combobox("getValues").join("$");
	var dataSaveObj={
		IntervalTime:IntervalTime,
		OperSwitch:OperSwitch,
		OccupySwitch:OccupySwitch,
		BabyBedPosition:BabyBedPosition,
		BedCardColor:BedCardColor,
		AreaConfig:AreaConfig.join("@"),
		OutDays:OutDays,
		HoverCardConfig:HoverCardConfig.join("@"),
		HoverCardDelayTime:HoverCardDelayTime,
		SumConfig:SumConfig,
		WardStatistics:WardStatistics,
		LongOrderImg:LongOrderImg,
		TempOrderImg:TempOrderImg,
		patCredNoImgSwitch:patCredNoImgSwitch,
		IconFilterConfigs:IconFilterConfigsArr.join("^"),
		SumConfig1:SumConfig1Arr.join("^"),
		mainDocRequired:mainDocRequired,
		mainDocMulti:mainDocMulti,
		mainNurseRequired:mainNurseRequired,
		mainNurseMulti:mainNurseMulti,
		updateMotherDocSyncBaby:updateMotherDocSyncBaby,
		allowBabyAloneAssignBed:allowBabyAloneAssignBed,
		showBedBillSwitch:showBedBillSwitch,
		allowDragDocDischPat:allowDragDocDischPat,
		tranToWaitRoom:tranToWaitRoom,
		transbabyShowVirtualBed:transbabyShowVirtualBed,
		loadBedByWardGroup:loadBedByWardGroup,
		allowModifyBedType:allowModifyBedType,
		allowModifyBedRoom:allowModifyBedRoom,
		allowSwitchWardGroups:allowSwitchWardGroups
	}
	$.m({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		MethodName:"SaveBedSetting",
		saveDataJson:JSON.stringify(dataSaveObj),
		hospId:$HUI.combogrid('#_HospList').getValue()
	},function(rtn){
		if (rtn==0) {
			$.messager.popover({msg: '保存成功！',type:'success'});
		}else{
			$.messager.popover({msg: '保存失败！'+rtn,type:'error'});
		}
	})
}
var editIndex = undefined;
function initBedStatusTab(){
	$('#bedStatusTab').datagrid({
        url: $URL,
        singleSelect: true,
        height:207,
        bodyCls:'panel-body-gray',
        queryParams: {
            ClassName: "Nur.NIS.Service.Base.BedConfig",
            MethodName: "getbedUnAvailableConfigs",
        	hospId: $HUI.combogrid('#_HospList').getValue()
        },
        idField:'id',
        columns: [[
	        {
	            field: "unAvailableId",title: "床位不可用原因",width: 120,
	            formatter: function (value, row) {
	                return row.unAvailableDesc;
	            },
	            editor: {
	                type: 'combobox',
	                options: {
	                    mode: 'remote',
	                    valueField: "unAvailableId",
	                    textField: "unAvailableDesc",
	                    displayMsg: '',
	                    url: $URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetBedUnAvailable&rows=9999",
	                    onSelect: function (rec) {
	                        var bedStatusTab = $('#bedStatusTab').datagrid('getData');
	                          var ifExit =false;
	                         bedStatusTab.rows.forEach(function (row) {	              
		                        if(row.unAvailableId == rec.unAvailableId){
	                            	ifExit=true ;
	                            	return false;
		                        }
	                        })
	                        if (!ifExit) {
		                        var rowData=$('#bedStatusTab').datagrid('getSelected');
		                        var rows = $('#bedStatusTab').datagrid('getRows');
		                        if ((editIndex + 1) >= rows.length) { 
	                				endEditing("bedStatusTab");
	                            	savebedStatus("unAvailableId", rec.unAvailableId, rowData.id);
	            				}else{
		            				$('#bedStatusTab').datagrid('reload');
	                				editIndex = undefined;
		            			}
	                        }
	                        else {
	                            $.messager.popover({ msg: rec.unAvailableDesc + '已存在！', type: 'alert', timeout: 2000 });
	                        }
	                    },
	                    loadFilter:function(data){
		                    return data.rows;
		                }
	                }
	            }
	        },
			{ field: 'isDefault',
	          title: '默认不可用原因', 
	          width: 115, 
			  editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ],
						onSelect: function (rec) {
							var rowData=$('#bedStatusTab').datagrid('getSelected');
							if(rowData.id){
								endEditing("bedStatusTab");
								savebedStatus("Default", rec.value, rowData.id);
							}else{
								$("#bedStatusTab").datagrid('reload');
								editIndex = undefined;
							}
						}
                    }
                }
		    }, 
			{ field: 'isAllowEditStTime', 
	          title: '允许修改开始日期', 
	          width: 130, 
			  editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ],
						onSelect: function (rec) {
							var rowData=$("#bedStatusTab").datagrid('getSelected');
							if(rowData.id){
								endEditing("bedStatusTab");
								savebedStatus("AllowEditStTime", rec.value, rowData.id);
							}else{
								$("#bedStatusTab").datagrid('reload');
								editIndex = undefined;
							}
						}
                    }
                }
		    }, 
		    { field: 'isShow',
	          title: '是否显示此状态床位', 
	          width: 135, 
			  editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ],
						onSelect: function (rec) {
							var rowData=$("#bedStatusTab").datagrid('getSelected');
							if(rowData.id){
								endEditing("bedStatusTab");
								savebedStatus("show", rec.value, rowData.id);
							}else{
								$("#bedStatusTab").datagrid('reload');
								editIndex = undefined;
							}
						}
                    }
                }
		    },
		    { field: 'isShowOperationInfo',
	          title: '显示操作信息', 
	          width: 135, 
			  editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ],
						onSelect: function (rec) {
							var rowData=$("#bedStatusTab").datagrid('getSelected');
							if(rowData.id){
								endEditing("bedStatusTab");
								savebedStatus("showOperationInfo", rec.value, rowData.id);
							}else{
								$("#bedStatusTab").datagrid('reload');
								editIndex = undefined;
							}
						}
                    }
                }
		    },
	        { field: 'oper', title: '操作', width: 40, formatter: function(value,row,index){
		        return '<a class="btnCls icon-cancel" href="#" onclick=delbedStatusConfig(\'' + row.unAvailableId + '\',\'' + row.id + '\')></a>'
		    }}
	    ]],
        onClickCell: function (index,field, value) {
	        var rows = $('#bedStatusTab').datagrid('getRows');
	        if ((field=="unAvailableId")&&(rows[index].id)) return;
            if (editIndex != index) {
		        if (endEditing("bedStatusTab")) {
		            $('#bedStatusTab').datagrid('selectRow', index).datagrid('beginEdit', index);
		            editIndex = index;
		        } else {
		            $('#bedStatusTab').datagrid('selectRow', editIndex);
		        }
		    }
        },
        onLoadSuccess: function (data) {
            $('#bedStatusTab').datagrid('appendRow', { unAvailableId: '', unAvailableDesc: '',id:'' });
        },
        onBeforeLoad:function(param){
	        editIndex=undefined;
	        $('#bedStatusTab').datagrid('unselectAll');
	    }
    });
}
function endEditing(tableID) {
    if (editIndex == undefined) { return true }
    if ($("#bedStatusTab").datagrid('validateRow', editIndex)) {
        /*var columnFields = $("#bedStatusTab").datagrid('getColumnFields');
        columnFields.forEach(function (field) {
            var ed = $("#bedStatusTab").datagrid('getEditor', { index: editIndex, field: field });
            if (ed && ed.type && ed.type == 'combobox') {
                var desc = $(ed.target).combobox('getText');
                $("#bedStatusTab").datagrid('getRows')[editIndex][field] = desc;
            }
            if (ed && ed.type && ed.type == 'combogrid') {
                var desc = $(ed.target).combogrid('getText');
                $("#bedStatusTab").datagrid('getRows')[editIndex][field+'Desc'] = desc;
            }
        });*/
        $("#bedStatusTab").datagrid('endEdit', editIndex);
        /*if ($("#bedStatusTab").datagrid('getRows')[editIndex].desc != "") {
            $("#bedStatusTab").datagrid('appendRow', { id: '', desc: '' });
        }*/
        editIndex = undefined;
        return true;
    } else {
        return false;
    }
}
function savebedStatus(setName, value, index){
	$m({
        ClassName: "Nur.NIS.Service.Base.BedConfig",
        MethodName: "saveBedStatusConfig",
        SetName: setName,
        value: value,
        index: index,
		HospID: $HUI.combogrid('#_HospList').getValue()
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 2000 });
            $('#bedStatusTab').datagrid('reload');
            editIndex = undefined;
        }
    });
}

function delbedStatusConfig(unAvailableId,value) {
	if(value){
		$m({
	        ClassName: "Nur.NIS.Service.Base.BedConfig",
	        MethodName: "delbedStatusConfig",
	        unAvailableId: unAvailableId,
	        HospID: $HUI.combogrid('#_HospList').getValue()
	    }, function (txtData) {
	        if (txtData == 0) {
	            $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 2000 });
	            $('#bedStatusTab').datagrid('reload');
	            editIndex = undefined;
	        }
	    });
	}else{
		$.messager.popover({ msg: '未保存的行不能删除！', type: 'alert', timeout: 2000 });
	}    
}
function initBasicDataTab(){
	$('#basicDataTab').datagrid({
        url: $URL,
        singleSelect: false,
        headerCls:'panel-header-gray',
        fit:true,
        title:'护理基础数据',
        shiftCheck:true,
        queryParams: {
            ClassName: "Nur.NIS.Service.Base.BedConfig",
            QueryName: "getBasicData",
            rows:99999
        },
        idField:'NBDRowId',
        columns: [[
	        {field: "key",title: "数据编码",width: 100},
			{field: 'name',title: '名称',width: 120},
			{field: 'note',title: '备注',width: 120} 
	    ]],
	    rowStyler: function(index,row){
		    if (row["selected"]==1){
			    return 'color:#40A2DE;';
			}else{
				return 'color:black;';
			}
	    },
        onBeforeLoad:function(param){
	        param.hospId=$HUI.combogrid('#_HospList').getValue();
	        $('#basicDataTab').datagrid('unselectAll');
	    }
    });
}
function initSelectedBasicDataTab(){
	$('#selectedBasicDataTab').datagrid({
        url: $URL,
        singleSelect: false,
        headerCls:'panel-header-gray',
        title:'床位图请求数据(可拖动调整筛选顺序)',
        fit:true,
        queryParams: {
            ClassName: "Nur.NIS.Service.Base.BedConfig",
            QueryName: "getBedRequestItem"
        },
        idField:'NBDRowId',
        columns: [[
	        {field: "key",title: "数据编码",width: 100},
			{field: 'name',title: '名称',width: 120},
			{field: 'note',title: '备注',width: 120},
			{field: 'isFilter',title: '是否筛选',width: 80,align:'center',
				editor:{
					"type":"icheckbox",
					"options":{
						"on":"Y","off":"N"
					}
				}
			},
			{field: 'defaultFilter',title: '默认筛选条件',width: 100,align:'center',
				editor:{
					"type":"icheckbox",
					"options":{
						"on":"Y","off":"N"
					}
				}
			}
	    ]],
        onLoadSuccess: function (data) {
	        editRowIndex=undefined;
	        $('#selectedBasicDataTab').datagrid('enableDnd');
        },
        onBeforeLoad:function(param){
	        param.hospId=$HUI.combogrid('#_HospList').getValue();
	        $('#selectedBasicDataTab').datagrid('unselectAll');
	    },
	    onDblClickRow:function(rowIndex, rowData){
		    if (rowData.name!=""){
		    	$('#selectedBasicDataTab').datagrid('beginEdit',rowIndex);
		    	var ed = $('#selectedBasicDataTab').datagrid('getEditor', {index:rowIndex,field:'defaultFilter'});
		    	if (rowData["isFilter"]!="Y") ed.target.checkbox("disable");
		    	ed.target.checkbox({onCheckChange:function(e,value){
			    	var tr = $(this).closest("tr.datagrid-row");
			    	var modRowIndex = tr.attr("datagrid-row-index");
			    	var allSelItem=$("#selectedBasicDataTab").datagrid("getRows");
					allSelItem.forEach(function(val,index){
						if (index!=modRowIndex) {
							var editors=$("#selectedBasicDataTab").datagrid("getEditors",index);
							if (editors.length>0){
								var defaultFilter=editors[0].target.checkbox('getValue')?"Y":"N";
								if (defaultFilter=="Y"){
									var ed = $('#selectedBasicDataTab').datagrid('getEditor', {index:index,field:'defaultFilter'});
									ed.target.checkbox("uncheck");
								}
							}else{
								var defaultFilter=val.defaultFilter;
								if (defaultFilter=="Y"){
									$('#selectedBasicDataTab').datagrid('beginEdit',index);
									var ed = $('#selectedBasicDataTab').datagrid('getEditor', {index:index,field:'defaultFilter'});
									ed.target.checkbox("uncheck");
								}
							}
						}
					})
			    }})
		    	var ed1 = $('#selectedBasicDataTab').datagrid('getEditor', {index:rowIndex,field:'isFilter'});
		    	ed1.target.checkbox({onCheckChange:function(e,value){
			    	var tr = $(this).closest("tr.datagrid-row");
			    	var modRowIndex = tr.attr("datagrid-row-index");
			    	var ed = $('#selectedBasicDataTab').datagrid('getEditor', {index:modRowIndex,field:'defaultFilter'});
			    	if (value){
				    	ed.target.checkbox("enable");
				    }else{
					    ed.target.checkbox("disable").checkbox("uncheck");
					}
			    }})
		    	editRowIndex=rowIndex;
		    }
		}
    });
}
var editRowIndex;
function moveRight(){
	var rows=$("#basicDataTab").datagrid("getSelections");
	if(rows.length>0){
		var allSelItem=$("#selectedBasicDataTab").datagrid("getRows");
		rows.forEach(function(val){
			var NBDRowId=val.NBDRowId;
			var key=val.key;
			var name=val.name;
			var note=val.note;
			if(allSelItem.length==0){
				$('#selectedBasicDataTab').datagrid('appendRow',{
					NBDRowId:NBDRowId,
					key:key,
					name:name,
					note:note,
					isFilter:"N",
					defaultFilter:"N",
					BRIRowId:""
				}).datagrid('enableDnd');
			}else{
				var ind=allSelItem.findIndex(function(val){
					return val.NBDRowId==NBDRowId;	
				});	
				if(ind==-1) $('#selectedBasicDataTab').datagrid('appendRow',{
					NBDRowId:NBDRowId,
					key:key,
					name:name,
					note:note,
					isFilter:"N",
					defaultFilter:"N",
					BRIRowId:""
				}).datagrid('enableDnd');
			}				
		})
		$("#basicDataTab").datagrid("unselectAll");
	}else{
		$.messager.popover({ msg: '请选择要右移的项目！', type: 'error'});		
	}
}
function moveLeft(){
	var selRows=$("#selectedBasicDataTab").datagrid("getSelections");		
	if(selRows.length>0){
		var allRows=$("#selectedBasicDataTab").datagrid("getRows");
		for (var i=selRows.length-1;i>=0;i--){
			var index=allRows.findIndex(function(val2){
				return val2.NBDRowId==selRows[i].NBDRowId;	
			})
			$("#selectedBasicDataTab").datagrid("deleteRow",index);
		}
	}else{
		$.messager.popover({ msg: '请选择要左移的项目！', type: 'error'});		
	}
}
function saveBedRequestConfig(){
	var allSaveRows=$("#selectedBasicDataTab").datagrid("getRows");
	var saveDataArr=[],saveBRIItemDRStr="";
	if(allSaveRows.length>0){
		allSaveRows.forEach(function(val,index){
			var editors=$("#selectedBasicDataTab").datagrid("getEditors",index);
			if (editors.length>0){
				var isFilter=editors[0].target.checkbox('getValue')?"Y":"N";
				var defaultFilter=editors[1].target.checkbox('getValue')?"Y":"N";
			}else{
				var isFilter=val.isFilter;
				var defaultFilter=val.defaultFilter
			}
			saveDataArr.push({
				BRIItemDR:val.NBDRowId,
				BRIFilter:isFilter,
				BRIDefaultFilter:defaultFilter,
				BRIFilterSortNo:(index+1),
				BRIHospDR:$HUI.combogrid('#_HospList').getValue()
			});
			if(saveBRIItemDRStr=="") saveBRIItemDRStr=val.NBDRowId;
			else  saveBRIItemDRStr=saveBRIItemDRStr+"^"+val.NBDRowId;
		})
	}
	$.cm({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		MethodName:"saveBedRequestItem",
		saveDataArr:JSON.stringify(saveDataArr),
		hospId:$HUI.combogrid('#_HospList').getValue(),
		saveBRIItemDRStr:saveBRIItemDRStr
	},function(data){
		if(data==0){
			$.messager.popover({ msg: '保存成功！', type: 'success'});
			editRowIndex=undefined;
			$HUI.dialog('#bedRequestConfig-dialog').close();
		}else{
			$.messager.popover({ msg: '保存失败！', type: 'error'});	
		}
	})	
}
$.extend($.fn.datagrid.defaults, {
	onBeforeDrag: function(row){},	// return false to deny drag
	onStartDrag: function(row){},
	onStopDrag: function(row){},
	onDragEnter: function(targetRow, sourceRow){},	// return false to deny drop
	onDragOver: function(targetRow, sourceRow){},	// return false to deny drop
	onDragLeave: function(targetRow, sourceRow){},
	onBeforeDrop: function(targetRow, sourceRow, point){},
	onDrop: function(targetRow, sourceRow, point){},	// point:'append','top','bottom'
});
$.extend($.fn.datagrid.methods, {
	enableDnd: function(jq, index){
		return jq.each(function(){
			var target = this;
			var state = $.data(this, 'datagrid');
			state.disabledRows = [];
			var dg = $(this);
			var opts = state.options;
			if (index != undefined){
				var trs = opts.finder.getTr(this, index);
			} else {
				var trs = opts.finder.getTr(this, 0, 'allbody');
			}
			trs.draggable({
				disabled: false,
				revert: true,
				cursor: 'pointer',
				proxy: function(source) {
					var index = $(source).attr('datagrid-row-index');
					var tr1 = opts.finder.getTr(target, index, 'body', 1);
					var tr2 = opts.finder.getTr(target, index, 'body', 2);
					var p = $('<div style="z-index:9999999999999"></div>').appendTo('body');
					tr2.clone().removeAttr('id').removeClass('droppable').appendTo(p);
					tr1.clone().removeAttr('id').removeClass('droppable').find('td').insertBefore(p.find('td:first'));
					$('<td><span class="tree-dnd-icon tree-dnd-no" style="position:static">&nbsp;</span></td>').insertBefore(p.find('td:first'));
					p.find('td').css('vertical-align','middle');
					p.hide();
					return p;
				},
				deltaX: 15,
				deltaY: 15,
				onBeforeDrag:function(e){
					if(editRowIndex!=undefined) return false;
					if (opts.onBeforeDrag.call(target, getRow(this)) == false){return false;}
					if ($(e.target).parent().hasClass('datagrid-cell-check')){return false;}
					if (e.which != 1){return false;}
					opts.finder.getTr(target, $(this).attr('datagrid-row-index')).droppable({accept:'no-accept'});
				},
				onStartDrag: function() {
					$(this).draggable('proxy').css({
						left: -10000,
						top: -10000
					});
					var row = getRow(this);
					opts.onStartDrag.call(target, row);
					state.draggingRow = row;
				},
				onDrag: function(e) {
					var x1=e.pageX,y1=e.pageY,x2=e.data.startX,y2=e.data.startY;
					var d = Math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
					if (d>3){	// when drag a little distance, show the proxy object
						$(this).draggable('proxy').show();
						var tr = opts.finder.getTr(target, parseInt($(this).attr('datagrid-row-index')), 'body');
						$.extend(e.data, {
							startX: tr.offset().left,
							startY: tr.offset().top,
							offsetWidth: 0,
							offsetHeight: 0
						});
					}
					this.pageY = e.pageY;
				},
				onStopDrag:function(){
					for(var i=0; i<state.disabledRows.length; i++){
						var index = dg.datagrid('getRowIndex', state.disabledRows[i]);
						if (index >= 0){
							opts.finder.getTr(target, index).droppable('enable');
						}
					}
					state.disabledRows = [];
					var index = dg.datagrid('getRowIndex', state.draggingRow);
					dg.datagrid('enableDnd', index);
					opts.onStopDrag.call(target, state.draggingRow);
				}
			}).droppable({
				accept: 'tr.datagrid-row',
				onDragEnter: function(e, source){
					if (opts.onDragEnter.call(target, getRow(this), getRow(source)) == false){
						allowDrop(source, false);
						var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
						tr.find('td').css('border', '');
						tr.droppable('disable');
						state.disabledRows.push(getRow(this));
					}
				},
				onDragOver: function(e, source) {
					var targetRow = getRow(this);
					if ($.inArray(targetRow, state.disabledRows) >= 0){return;}
					var pageY = source.pageY;
					var top = $(this).offset().top;
					var bottom = top + $(this).outerHeight();
					
					allowDrop(source, true);
					var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
					tr.children('td').css('border','');
					if (pageY > top + (bottom - top) / 2) {
						tr.children('td').css('border-bottom','1px solid red');
					} else {
						tr.children('td').css('border-top','1px solid red');
					}
					
					if (opts.onDragOver.call(target, targetRow, getRow(source)) == false){
						allowDrop(source, false);
						tr.find('td').css('border', '');
						tr.droppable('disable');
						state.disabledRows.push(targetRow);
					}
				},
				onDragLeave: function(e, source) {
					allowDrop(source, false);
					var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
					tr.children('td').css('border','');
					opts.onDragLeave.call(target, getRow(this), getRow(source));
				},
				onDrop: function(e, source) {
					var sourceIndex = parseInt($(source).attr('datagrid-row-index'));
					var destIndex = parseInt($(this).attr('datagrid-row-index'));
					
					var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
					var td = tr.children('td');
					var point =  parseFloat(td.css('border-top-width')) ? 'top' : 'bottom';
					td.css('border','');
					
					var rows = dg.datagrid('getRows');
					var dRow = rows[destIndex];
					var sRow = rows[sourceIndex];
					if (opts.onBeforeDrop.call(target, dRow, sRow, point) == false){
						return;
					}
					insert();
					opts.onDrop.call(target, dRow, sRow, point);
					
					function insert(){
						var row = $(target).datagrid('getRows')[sourceIndex];
						var index = 0;
						if (point == 'top'){
							index = destIndex;
						} else {
							index = destIndex+1;
						}
						if (index < sourceIndex){
							dg.datagrid('deleteRow', sourceIndex).datagrid('insertRow', {
								index: index,
								row: row
							});
							dg.datagrid('enableDnd', index);
						} else {
							dg.datagrid('insertRow', {
								index: index,
								row: row
							}).datagrid('deleteRow', sourceIndex);
							dg.datagrid('enableDnd', index-1);
						}
					}
				}
			});
			
			function allowDrop(source, allowed){
				var icon = $(source).draggable('proxy').find('span.tree-dnd-icon');
				icon.removeClass('tree-dnd-yes tree-dnd-no').addClass(allowed ? 'tree-dnd-yes' : 'tree-dnd-no');
			}
			function getRow(tr){
				return opts.finder.getRow(target, $(tr));
			}
		});
	}
})

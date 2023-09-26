$(function(){
    initDataGrid();
})

function initDataGrid()
{
	$("#historyGrid").datagrid({ 
		//title:"申请记录",
		//headerCls:'panel-header-gray',
		//iconCls:'icon-paper',
		pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    url:'../EMRservice.Ajax.auth.authorize.cls?Action=getHistory&frameType=HISUI&EpisodeID=' + episodeID + '&RequestUserID=' + userID,
	    pagination:true,
	    fit:true,
		columns:[[
			{field:'AppointID',title:'授权表ID',width:80,hidden:true},
			{field:'IsAppointed',title:'授权状态',width:80,formatter: rendererIsAppointed},
			{field:'IsActive',title:'是否过期',width:80,formatter: rendererIsActive},
			{field:'Name',title:'患者姓名',width:80},
			{field:'PapmiNo',title:'登记号',width:100},
			{field:'MedicareNo',title:'病案号',width:80},
			{field:'AdmDate',title:'就诊日期',width:95},
			{field:'AdmTime',title:'就诊时间',width:70},
			{field:'PAAdmType',title:'就诊类型',width:70,formatter:rendererPAAdmType},
			{field:'PaadmNO',title:'就诊号',width:120},
			{field:'CurDept',title:'就诊科室',width:100},
			{field:'MainDoc',title:'主治医师',width:80},
			{field:'PAStatus',title:'在院状态',width:80,formatter:rendererPAStatus},
			{field:'PADischgeDateTime',title:'出院日期',width:160,formatter:rendererPADischgeDateTime},
			{field:'RequestUser',title:'申请医师',width:80},
			{field:'RequestDateTime',title:'申请时间',width:150},
			{field:'RequestDept',title:'申请科室',width:100},
			{field:'RequestReason',title:'申请原因',width:160},
			{field:'AuthLevelDesc',title:'授权级别',width:80},
			{field:'AppointUser',title:'授权医师',width:80},
			{field:'AppointType',title:'授权类型',width:80,formatter:getAppointType},
			//{field:'AppointSpan',title:'授权剩余时间(小时)',width:150,formatter:rendererAppointSpan},
			{field:'AppointDateTime',title:'授权/拒绝时间',width:150,formatter:rendererAppointDateTime},
			{field:'AppointEndDateTime',title:'授权结束时间',width:150,formatter:rendererAppointDateTime},
			{field:'BeforeRequestContent',title:'修改前内容',width:160,formatter:TrimEnterAndWrite},
			{field:'AfterRequestContent',title:'修改后内容',width:160,formatter:TrimEnterAndWrite},
			{field:'RefuseReason',title:'拒绝原因',width:160,formatter:TrimEnterAndWrite}
			
		]],
		onSelect:function(rowIndex, rowData){
			
		},
		view:detailview,
		detailFormatter:function(rowIndex, rowData){
			return '<table  class="detailData"></table>';
		},
		onExpandRow:function(index,row){
			var expanderdata = row['AppointDetailData'];
			var detailData = $(this).datagrid('getRowDetail',index).find('table.detailData');
            detailData.datagrid({ 
            	data:expanderdata,
            	singleSelect:true,
            	rownumbers:true,
            	columns:[[
					{field:'CateCharpter',title:'模板ID',hidden:true}, 
					{field:'CCDesc',title:'病历名称',width:320},
					{field:'CCCreator',title:'病历创建者',width:90}, 
					{field:'DetailStr',title:'申请的操作',width:170,formatter:rendererRequestAction},
					{field:'DetailStr1',title:'授权的操作',width:170,formatter:rendererAppointAction}
				]],
				onResize:function(){
					$('#historyGrid').datagrid('fixDetailRowHeight',index);
				},	
				onLoadSuccess:function(){
                    $('#historyGrid').datagrid('fixDetailRowHeight',index);
                },
                onClickRow:function(subindex){
	                if (row.CanAppoint != 1) return;
					//if (editIndex!=subindex) {  //展开多个条目时，每个条目的第一条病历Index都是0，陷入死循环
						if (endEditing()){
							detailData.datagrid('selectRow', subindex)
							detailData.datagrid('beginEdit', subindex);
							editDetailData = detailData;
							editIndex = subindex;
							modifyBeforeRow = $.extend({},detailData.datagrid('getRows')[editIndex]);
						} else {
							detailData.datagrid('selectRow', editIndex);
						}
					//}
				}		
            }); 
            $('#historyGrid').datagrid('fixDetailRowHeight',index); 
		}
	});
}

$.extend($.fn.datagrid.defaults.editors, {
	mybtns: {
		init: function (_662, _663) {
			var opt = $.extend({on:'on',off:'off'},_663);
			var _664 = $("<div></div>").appendTo(_662);
			//_664.checkbox(opt);
			_664.data("opt",opt);
			return _664;
		}, getValue: function (initRtnObj) {
			var rtnArr = [];
			initRtnObj.find("input[type='checkbox']").each(function(){
				var lbl = $(this).attr('label');
				var id = $(this).attr('id');
				var chck = $(this).parent().hasClass('checked');
				chck = chck?1:0;
				rtnArr.push(id+"^"+lbl+"^"+chck);
			});
			return rtnArr.join("#");
		}, setValue: function (initRtnObj, val) {
			var btnArr = val.split("#");
			var opt = initRtnObj.data("opt");
			$.each(btnArr,function(i,item){
				var itemArr = item.split("^");
				$("<input type=\"checkbox\" id="+itemArr[0]+" label="+itemArr[1]+">").appendTo(initRtnObj).checkbox({checked:itemArr[2]==1?true:false});
			});
		}
	}
});
var editIndex=undefined;
var editDetailData=undefined;
var modifyBeforeRow = {};
var modifyAfterRow = {};
var parentIndex = "";
function endEditing(){
	if (editDetailData == undefined){return true}
	if (editIndex == undefined){return true}
	if (editDetailData.datagrid('validateRow', editIndex)){
		editDetailData.datagrid('endEdit', editIndex);
		modifyAfterRow = editDetailData.datagrid('getRows')[editIndex];
		var aStr = JSON.stringify(modifyAfterRow);
		var bStr = JSON.stringify(modifyBeforeRow);
		if(aStr!=bStr){
			updateAppointAction(modifyAfterRow.DetailStr1);
		}
		//去除授权列修改标志
		editDetailData.datagrid("getPanel").find("tr.datagrid-row[datagrid-row-index="+editIndex+"]>td[field='grantBtnGroup']").removeClass("datagrid-value-changed");
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function rendererIsAppointed(val){
    var retStr = "";
    if (val == 'unappointed') {
        retStr = emrTrans('未授权');
    }else if (val == 'appointed') {
        retStr = "<span style='color:#015399;font-weight:bold;'>" + emrTrans('已授权') + "</span>";
    }else if (val == 'refuse') {
        retStr = emrTrans('拒绝');
    }else{
        retStr = val;
    }
    return retStr;
}

function rendererIsActive(val){
    var retStr = "";
    if (val == 1) {
        retStr = "<span style='color:green;font-weight:bold;'>" + emrTrans('授权中') + "</span>";
    } else if (val == 0) {
        retStr = emrTrans('过期');
    } 
     return retStr;
}

function rendererPAStatus(val){
    var retStr = "";
    if (val == 'in') {
        retStr = emrTrans('在院');
    } else {
        retStr = "<span style='color:green;font-weight:bold;'>" + emrTrans('出院') + "</span>";
    }
    return retStr;  
}

function rendererPADischgeDateTime(val){
    if (val == "" || typeof(val) == "undefined") {
        return;
    }else if (val == "1840-12-31 00:00:00") {
        return "";
    }else {
        return val;
    }
}

function getAppointType(val){
    if (val == "" || typeof(val) == "undefined") {
        return;
    }
    var retStr = "";
    switch (val) {
        case '0':
            retStr = emrTrans('个人');
            break;
        case '1':
            retStr = emrTrans('科室');
            break;
        default:
            retStr = val;
    }
    return retStr;
}

function rendererAppointSpan(val){
    if (val == "" || typeof(val) == "undefined") {
        return;
    }
    val = parseFloat(val);
    val = parseInt(val)
	if (val==168)
	{
		return emrTrans('1周');
	}
	else
	{
		return val + emrTrans('小时');
	}
}

function rendererAppointDateTime(val){
    if (val == "" || typeof(val) == "undefined") {
        return;
    }
    else {
        if (val == "1840-12-31 00:00:00") {
            return "";
        }
        else {
            return val;
        }
    }
}

function TrimEnterAndWrite(val)
{
	while (val.indexOf("xiegangxiegang")!= -1)
	{
		val = val.replace("xiegangxiegang","\\");
	}
	while (val.indexOf("@@@")!= -1)
	{
		val = val.replace("@@@","'");
	}
	while (val.indexOf("fanxiegangfanxiegang")!= -1)
	{
		val = val.replace("fanxiegangfanxiegang","/");
	}
	while (val.indexOf("douhaodouhao")!= -1)
	{
		val = val.replace("douhaodouhao",",");
	}
	while (val.indexOf("tanhaotanhao")!= -1)
	{
		val = val.replace("tanhaotanhao","!");
	}
	while (val.indexOf("juhaojuhao")!= -1)
	{
		val = val.replace("juhaojuhao","。");
	}
	while (val.indexOf("zuodanyinhao")!= -1)
	{
		val = val.replace("zuodanyinhao","‘");
	}
	while (val.indexOf("youdanyinhao")!= -1)
	{
		val = val.replace("youdanyinhao","’");
	}
	while (val.indexOf(" ")!= -1)
	{
		val = val.replace(" ","");
	}
	return val;
}

function rendererRequestAction(val)
{
	var actionStr = "";
	if (val == "" || val == undefined) return actionStr;
	var detailObj = val.split('#');
	for (var i = 0; i < detailObj.length; i++) {
		var IDActionStatusStr = detailObj[i].split('^');
		var actionDesc = IDActionStatusStr[1];
		if (actionStr == "")
		{
			actionStr = actionDesc;
		}
		else
		{
			actionStr = actionStr + "," + actionDesc;
		}
	}
	return actionStr;
}

function rendererAppointAction(value,row)
{
	var valArr = value.split('#');
	var rtnArr = [];
	$.each(valArr,function(i,item){
		var itemArr = item.split('^');
		if (itemArr[2]==1) rtnArr.push(itemArr[1]);
	});
	return rtnArr.join();
}

function rendererPAAdmType(val){
    var retStr = "";
    if (val == 'I') {
        retStr = emrTrans('住院');
    }else if (val == 'O') {
        retStr = emrTrans('门诊');
    }else {
	    retStr = emrTrans('急诊');
    }
    return retStr;
}

function cancel(){
	window.close();
}

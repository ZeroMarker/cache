var defaultAppointType = '0'; //个人 0-个人，1-科室
var defaultAppointSpan = '168'; //168小时(1周)
var defaultAppointRequestSpan = '0'; //无
var defaultAppointAction = 'getunappointed'; //getall-获取全部未授权已授权，getrefuse-获取已拒绝，getunappointed-获取未授权
var defaultCanAppoint = '2'; //0-无权限,1-可授权,2-全部
var appointSpan = defaultAppointSpan;
var appointType = defaultAppointType;
var appointRequestSpan = defaultAppointRequestSpan;
var globalRequestRange = "";
var eprIntegratedAuthorization = '1';
var currAppointAction = "getunappointed";  //用于切换查询结果子表中的"授权的操作"和"将要授权的操作"列的Title值 add by niucaicai
$(function(){
	initCombox();
	initDataGrid();
	$("#btnAppointQuery").click(function(){
		//清空下拉框内的内容
		$('#cbxAppointRequestSpan').combobox('clear');
		queryData();
	});
	$("#btnCommit").click(function(){
		commitAppoint();
	});
	$("#btnRefuse").click(function(){
		refuseAppoint();
	});
	$("#btnWithdraw").click(function(){
		withdrawAppoint();
	});
	$("#btnQueryReset").click(function(){
		queryReset();
	});
	$("#btnExport").click(function(){
		var exportType=$('#cbxExport').combobox('getValue');
		exportData(exportType);
	});
});

function initCombox()
{
	//授权权限
	$('#cbxCanAppoint').combobox({
	    data: [{"id":"0","text":emrTrans("无权限")}, {"id":"1","text":emrTrans("可授权")}, {"id":"2","text":emrTrans("全部"),"selected":true}],
	    valueField:'id',
	    textField:'text',
	    editable:false,
	    panelHeight:"auto"
	});	
	//授权级别
	$('#cbxAuthLevel').combobox({
	    data: [{"id":"100","text":emrTrans("主管医师")}, {"id":"200","text":emrTrans("科主任")}, {"id":"300","text":emrTrans("医务处")}, {"id":"400","text":emrTrans("病案室")},{"id":"ALL","text":emrTrans("全部"),"selected":true}],
	    valueField:'id',
	    textField:'text',
	    editable:false,
	    panelHeight:"auto"
	});
	//生效授权
	$('#cbxIsActive').combobox({
	    data: [{"id":"0","text":emrTrans("过期")}, {"id":"1","text":emrTrans("生效授权")}, {"id":"2","text":emrTrans("全部"),"selected":true}],
	    valueField:'id',
	    textField:'text',
	    editable:false,
	    panelHeight:"auto"
	});
	//授权情况
	$('#cbxAppointAction').combobox({
	    data: [{"id":"getunappointed","text":emrTrans("未授权")}, {"id":"getappointed","text":emrTrans("已授权")}, {"id":"getrefuse","text":emrTrans("已拒绝")}],
	    valueField:'id',
	    textField:'text',
	    editable:false,
	    panelHeight:"auto",
	    onChange:function(newValue,oldValue){
		    if (newValue == "getunappointed")
		    {
			    $('#cbxIsActive').combobox('clear');
			    $('#cbxIsActive').combobox('disable');
			    $('#cbxCanAppoint').combobox('enable');
			    $('#dtAppointDateStart').datebox('clear');
			    $('#dtAppointDateStart').datebox('disable');
			    $('#dtAppointDateEnd').datebox('clear');
			    $('#dtAppointDateEnd').datebox('disable');
			    $('#tmAppointTimeStart').timespinner('clear');
			    $('#tmAppointTimeStart').timespinner('disable');
			    $('#tmAppointTimeEnd').timespinner('clear');
			    $('#tmAppointTimeEnd').timespinner('disable');
			    $('#dtRequestDateStart').datebox('enable');
			    $('#dtRequestDateEnd').datebox('enable');
				$('#tmRequestTimeStart').timespinner('enable');
			    $('#tmRequestTimeEnd').timespinner('enable');
			}
			else if (newValue == "getappointed")
			{
				$('#cbxCanAppoint').combobox('clear');
				$('#cbxCanAppoint').combobox('disable');
				$('#cbxIsActive').combobox('enable');
				$('#cbxIsActive').combobox('setValue', '1');
				$('#dtAppointDateStart').datebox('enable');
				$('#dtAppointDateEnd').datebox('enable');
				$('#tmAppointTimeStart').timespinner('enable');
				$('#tmAppointTimeEnd').timespinner('enable');
				$('#dtRequestDateStart').datebox('disable');
				$('#dtRequestDateEnd').datebox('disable');
				$('#tmRequestTimeStart').timespinner('disable');
				$('#tmRequestTimeEnd').timespinner('disable');
				$('#dtRequestDateStart').datebox('clear');
				$('#dtRequestDateEnd').datebox('clear');
				$('#tmRequestTimeStart').timespinner('clear');
				$('#tmRequestTimeEnd').timespinner('clear');
			}
			else
			{
				$('#cbxCanAppoint').combobox('clear');
				$('#cbxCanAppoint').combobox('enable');
				$('#cbxIsActive').combobox('clear');
				$('#cbxIsActive').combobox('enable');
				$('#dtAppointDateStart').datebox('disable');
				$('#dtAppointDateEnd').datebox('disable');
				$('#tmAppointTimeStart').timespinner('disable');
				$('#tmAppointTimeEnd').timespinner('disable');				
				$('#dtRequestDateStart').datebox('enable');
				$('#dtRequestDateEnd').datebox('enable');
				$('#tmRequestTimeStart').timespinner('enable');
				$('#tmRequestTimeEnd').timespinner('enable');
				$('#dtRequestDateStart').datebox('clear');
				$('#dtRequestDateEnd').datebox('clear');
				$('#tmRequestTimeStart').timespinner('clear');
				$('#tmRequestTimeEnd').timespinner('clear');			
			}
	    },
	    onLoadSuccess:function()
	    {
		    $('#cbxAppointAction').combobox('setValue','getunappointed');
		}
	});
	//在院状态
	$('#cbxPAStatus').combobox({
	    data: [{"id":"in","text":emrTrans("在院")}, {"id":"out","text":emrTrans("出院")}],
	    valueField:'id',
	    textField:'text',
	    editable:false,
	    panelHeight:"auto"
	});
	//就诊科室
	$('#cbxTreatmentLoc').combobox({
	    url: '../EMRservice.Ajax.hisData.cls?Action=GetCTLocList',
	    valueField:'Id',
	    textField:'Text'
	});	
	//就诊类型
	$('#cbxPAAdmType').combobox({
	    data: [{"id":"I","text":emrTrans("住院")}, {"id":"O","text":emrTrans("门诊")}, {"id":"E","text":emrTrans("急诊")}],
	    valueField:'id',
	    textField:'text',
	    editable:false,
	    panelHeight:"auto"
	});	
	//申请科室
	$('#cbxRequestLoc').combobox({
	    url: '../EMRservice.Ajax.hisData.cls?Action=GetCTLocList',
	    valueField:'Id',
	    textField:'Text'
	});
	//默认申请时间范围
	$('#cbxAppointRequestSpan').combobox({
	    data: [{"id":"0","text":emrTrans("无"),"selected":true}, {"id":"24","text":emrTrans("24小时内")}, {"id":"48","text":emrTrans("48小时内")}, {"id":"72","text":emrTrans("72小时内")}, {"id":"168","text":emrTrans("1周内")}],
	    width:100,
	    valueField:'id',
	    textField:'text',
	    panelHeight:"auto",
	    editable:false,
	    onSelect: function(record){
		    appointRequestSpan = record.id;
			//清空申请起始/终止框内的内容
		    $('#dtRequestDateStart').datebox('clear')
		    $('#tmRequestTimeStart').timespinner('clear');
		    $('#dtRequestDateEnd').datebox('clear');
		    $('#tmRequestTimeEnd').timespinner('clear');
		    queryData();
	    }
	    
	});	
	//默认授权类型
	$('#cbxDefaultAppointType').combobox({
	    data: [{"id":"0","text":emrTrans("个人"),"selected":true}, {"id":"1","text":emrTrans("科室")}],
	    width:70,
	    valueField:'id',
	    textField:'text',
	    panelHeight:"auto",
	    editable:false,
	    onSelect: function(record){
		    appointType = record.id;
		    queryData();
	    }
	});	
	//默认授权时间
	$('#cbxDefaultAppointSpan').combobox({
	    data: [{"id":"1","text":emrTrans("1小时")}, {"id":"2","text":emrTrans("2小时")}, {"id":"5","text":emrTrans("5小时")}, {"id":"10","text":emrTrans("10小时")}, {"id":"24","text":emrTrans("24小时")}, {"id":"48","text":emrTrans("48小时")}, {"id":"72","text":emrTrans("72小时")}, {"id":"168","text":emrTrans("1周"),"selected":true}],
	    width:85,
	    valueField:'id',
	    textField:'text',
	    panelHeight:"auto",
	    editable:false,
	    onSelect: function(record){
		    appointSpan = record.id;
		    queryData();
	    }	    
	});
	//导出数据
	$('#cbxExport').combobox({
	    data: [{"id":"current","text":emrTrans("导出该页数据"),"selected":true}, {"id":"all","text":emrTrans("导出所有数据")}],
	    valueField:'id',
	    textField:'text',
	    panelHeight:"auto"
	});									
										
}

function initDataGrid()
{
	var param = getParam();
	$("#dgResultGrid").datagrid({ 
		title:"授权列表",
		headerCls:'panel-header-gray',
		iconCls:'icon-doctor',
		toolbar:'#tb',
		pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    url:'../EMRservice.Ajax.auth.authorize.cls',
	    pagination:true,
	    fit:true,
	    queryParams:param,
		columns:[[
			{field:'ck',checkbox:true},
			{field:'AppointID',title:'AppointID',hidden:true},
			{field:'CanAppoint',title:emrTrans('能否审核'),width:70,align:'center',formatter:rendererCanAppoint},
			{field:'AuthLevelDesc',title:emrTrans('授权级别'),width:70},
			{field:'IsActive',title:emrTrans('是否过期'),width:70,formatter:rendererIsActive},
			{field:'AppointDetailData',title:emrTrans('已封存病历'),width:90,align:'center',formatter:IsSealed},
			{field:'CopyedRecords',title:emrTrans('病案室已复印病历'),width:150,align:'center',formatter:IsCopyed},
			{field:'Name',title:emrTrans('患者姓名'),width:100},
			{field:'CurDept',title:emrTrans('就诊科室'),width:100},
			{field:'MainDoc',title:emrTrans('主治医师'),width:100},
			{field:'RequestUser',title:emrTrans('申请医师'),width:100},
			{field:'RequestDateTime',title:emrTrans('申请时间'),width:150},
			{field:'RequestReason',title:emrTrans('申请原因'),width:100,formatter:TrimEnterAndWrite},
			{field:'RequestNumber',title:emrTrans('申请人电话'),width:100,formatter:TrimEnterAndWrite},
			{field:'PAStatus',title:emrTrans('在院状态'),width:70,formatter:rendererPAStatus},
			{field:'PADischgeDateTime',title:emrTrans('出院日期'),width:95,formatter:rendererPADischgeDateTime},
			{field:'PapmiNo',title:emrTrans('登记号'),width:100},
			{field:'MedicareNo',title:emrTrans('病案号'),width:100},
			{field:'AdmDate',title:emrTrans('就诊日期'),width:95},
			{field:'AdmTime',title:emrTrans('就诊时间'),width:70},
			{field:'PAAdmType',title:emrTrans('就诊类型'),width:70,formatter:rendererPAAdmType},
			{field:'PaadmNO',title:emrTrans('就诊号'),width:110},
			{field:'RequestDept',title:emrTrans('申请科室'),width:100},
			{field:'IsAppointed',title:emrTrans('授权状态'),width:100,formatter:rendererIsAppointed},
			{field:'AppointUser',title:emrTrans('授权医师'),width:100},
			{field:'AppointType',title:emrTrans('授权类型'),width:70,formatter:getAppointType},
			//{field:'AppointSpan',title:emrTrans('授权剩余时间(小时)'),width:100,formatter:rendererAppointSpan},
			{field:'AppointDateTime',title:emrTrans('授权/拒绝时间'),width:150,formatter:rendererAppointDateTime},
			{field:'AppointEndDateTime',title:emrTrans('授权结束时间'),width:150,formatter:rendererAppointDateTime},
			{field:'BeforeRequestContent',title:emrTrans('修改前内容'),width:100,formatter:TrimEnterAndWrite},
			{field:'AfterRequestContent',title:emrTrans('修改后内容'),width:100,formatter:TrimEnterAndWrite},
			{field:'RefuseReason',title:emrTrans('拒绝原因'),width:100,formatter:TrimEnterAndWrite}
		]],
		onSelect:function(rowIndex, rowData){
			resetProperty();
			if (rowData.CopyedRecords !== "")
			{
				$.messager.alert("简单提示", "选择的申请中有复印过病历，如果授权可能导致病历内容不一致，请谨慎操作！", 'info');
			}
			$("#taRequestReason").append(rowData.RequestReason);
			$("#taBeforeRequestContent").append(rowData.BeforeRequestContent);
			$("#taAfterRequestContent").append(rowData.AfterRequestContent);
			$("#taRequestNumber").append(rowData.RequestNumber);
			
		},
		view:detailview,
		detailFormatter:function(rowIndex, rowData){
			return '<table  class="detailData"></table>';
		},
		onLoadSuccess:function(data){
		///禁用无权限，已授权或拒绝的授权申请前的checkbox
			if(data.rows.length>0){
				for (var i=0;i<data.rows.length;i++) {
					if(data.rows[i].CanAppoint!=1){
						$("#datagrid-row-r1-2-"+i).find("input[type='checkbox']")[0].disabled=true;
						}
					}
			
				}
				$(".datagrid-header-check").html("<input type='checkbox' id='selectAll'>");
				///全选框事件：让全选框避免选中已禁用的checkbox
				$("#selectAll").change(function () {
                  var state = $(this).is(":checked");
                  $("input:checkbox[name='ck']").each(function (index, e) {
                      if (!$(this).is(":disabled")) {
                          if (state) {
                              $("#dgResultGrid").datagrid("checkRow", index);
                          } else {
                              $("#dgResultGrid").datagrid("uncheckRow", index);
                          }
                      }
                  });
              });
			},
			
		onExpandRow:function(index,row){
			var DetailStr1Title = emrTrans("授权的操作");
			if (currAppointAction == "getunappointed")
			{
				DetailStr1Title = "<span style='color:red;font-weight:bold;'>" + emrTrans("将要授权的操作") + "</span>";
			}
			
			var expanderdata = row['AppointDetailData'];
			var detailData = $(this).datagrid('getRowDetail',index).find('table.detailData');
            detailData.datagrid({ 
            	data:expanderdata,
            	singleSelect:true,
            	rownumbers:true,
            	columns:[[
					{field:'CateCharpter',title:emrTrans('模板ID'),hidden:true}, 
					{field:'CCDesc',title:emrTrans('病历名称'),width:260},
					{field:'IsSealed',title:emrTrans('封存状态'),width:80,align:'center',formatter:rendererSealed},
					{field:'CCCreator',title:emrTrans('病历创建者'),width:80}, 
					{field:'DetailStr',title:emrTrans('申请的操作'),width:170,formatter:rendererRequestAction},
					{field:'DetailStr1',title:DetailStr1Title,width:380,formatter:rendererAppointAction,editor:{type:'mybtns',options:{on:'1',off:'0'}}}
				]],
				onResize:function(){
					$('#dgResultGrid').datagrid('fixDetailRowHeight',index);
				},	
				onLoadSuccess:function(){
                    $('#dgResultGrid').datagrid('fixDetailRowHeight',index);
                },
                onClickRow:function(subindex){
	                if (row.CanAppoint != 1) return;
	                if (detailData.datagrid('getRows')[subindex].IsSealed == "Y")
	                {
		                $.messager.alert("简单提示", "不能对已封存病历进行授权.", 'info');
						return;
		            }
					//if (editIndex!=subindex) {  //展开多个条目时，每个条目的第一条病历Index都是0，陷入死循环
						if (endEditing()){
							detailData.datagrid('selectRow', subindex)
							editDetailData = detailData;
							editIndex = subindex;
							modifyBeforeRow = $.extend({},detailData.datagrid('getRows')[editIndex]);
							detailData.datagrid('beginEdit', subindex);
						} else {
							detailData.datagrid('selectRow', editIndex);
						}
					//}
				}		
            }); 
            $('#dgResultGrid').datagrid('fixDetailRowHeight',index); 
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
				var modify = $(this).attr('text');
				//var chck = $(this).parent().hasClass('checked');
				var chck = $(this)[0].checked;
				chck = chck?1:0;
				if (currRowUpdated == false)
				{
					rtnArr.push(id+"^"+lbl+"^"+chck+"^"+modify);
				}
				else
				{
					rtnArr.push(id+"^"+lbl+"^"+chck+"^1");
				}
			});
			return rtnArr.join("#");
		}, setValue: function (initRtnObj, val) {
			var btnArr = val.split("#");
			var opt = initRtnObj.data("opt");
			var hasModified = false;
			$.each(btnArr,function(i,item){
				var itemArr = item.split("^");
				if (itemArr[3] == 1)
				{
					hasModified = true;
				}
			});
			$.each(btnArr,function(i,item){
				var itemArr = item.split("^");
				if (hasModified == true)
				{
					$("<input type=\"checkbox\" id="+itemArr[0]+" text="+itemArr[3]+" label="+itemArr[1]+">").appendTo(initRtnObj).checkbox({checked:itemArr[2]==1?true:false});
				}
				else
				{   //未对将要授权的操作做过修改时，默认是全部操作都给予授权，应该显示勾选状态；
					$("<input type=\"checkbox\" id="+itemArr[0]+" text="+itemArr[3]+" label="+itemArr[1]+">").appendTo(initRtnObj).checkbox({checked:true});
				}
			});
			//将更新授权操作的动作放到按钮上去，切换编辑行时，不去做更新；
			$('<button type="button" id="updatefs" onclick=updatefsClick() style="height:25px;margin-left:15px;margin-top:1px;text-align:center;border:none;color:white;background:#40A2DE;";>'+emrTrans("确定")+'</button>').appendTo(initRtnObj);
		}
	}
});
var editIndex=undefined;
var editDetailData=undefined;
var modifyBeforeRow = {};
var modifyAfterRow = {};
var parentIndex = "";
var currRowUpdated = false;
//初始化
function initValues()
{
	editIndex=undefined;
	editDetailData=undefined;
	modifyBeforeRow = {};
	modifyAfterRow = {};
	parentIndex = "";
        currRowUpdated = false;
}
function endEditing(){
	if (editDetailData == undefined){return true}
	if (editIndex == undefined){return true}
	if (editDetailData.datagrid('validateRow', editIndex)){
		editDetailData.datagrid('endEdit', editIndex);
		/* //将更新授权操作的动作放到按钮上去，切换编辑行时，不去做更新；
		modifyAfterRow = editDetailData.datagrid('getRows')[editIndex];
		var aStr = JSON.stringify(modifyAfterRow);
		var bStr = JSON.stringify(modifyBeforeRow);
		if(aStr!=bStr){
			updateAppointAction(modifyAfterRow.DetailStr1);
		}
		*/
		//去除授权列修改标志
		editDetailData.datagrid("getPanel").find("tr.datagrid-row[datagrid-row-index="+editIndex+"]>td[field='grantBtnGroup']").removeClass("datagrid-value-changed");
		editIndex = undefined;
		currRowUpdated = false;
		return true;
	} else {
		return false;
	}
}

function updatefsClick()
{
	if (editDetailData.datagrid('validateRow', editIndex)){
		modifyAfterRow = editDetailData.datagrid('getRows')[editIndex];
		currRowUpdated = true;
		editDetailData.datagrid('endEdit', editIndex);
		updateAppointAction(modifyAfterRow.DetailStr1);
		//去除授权列修改标志
		editDetailData.datagrid("getPanel").find("tr.datagrid-row[datagrid-row-index="+editIndex+"]>td[field='grantBtnGroup']").removeClass("datagrid-value-changed");
		editIndex = undefined;
	}
}

function updateAppointAction(value)
{
	var valArr = value.split('#');
	var actions = "";
	$.each(valArr,function(i,item){
		var itemArr = item.split('^');
		if (actions != "") actions += "#";
		actions += itemArr[0]+"^"+itemArr[2];
	});
	
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: '../EMRservice.Ajax.auth.authorize.cls',
		async: true,
		data: {
			Action: "updatefs",
			AppointActions: actions
		},
		success: function(d) {
			if (d != "1")
			{
				$.messager.alert("简单提示", "更改权限范围操作失败", 'info');
			}
		},
		error : function(d) { $.messager.alert("简单提示", "error", 'info');}
	});	
	
}

function rendererCanAppoint(val){
    var retStr = "";
    if (val == '2') {
        retStr = "<span style='color:#015399;font-weight:bold;'>" + emrTrans("已授权") + "</span>";
    } else if (val == '0') {
        retStr = "<span style='color:#D00B06;font-weight:bold;'>" + emrTrans("无权限") + "</span>";
    } else  if (val == '1') {
        retStr = "<span style='color:green;font-weight:bold;'>" + emrTrans("可授权") + "</span>";
    } else if (val == '3') {
        retStr = "<span style='color:#F34C32;font-weight:bold;'>" + emrTrans("拒绝") + "</span>";
    } else {
        retStr = val;
    }
     return retStr;
}

function rendererIsActive(val){
    var retStr = "";
    if (val == 1) {
        retStr = "<span style='color:green;font-weight:bold;'>" + emrTrans("授权中") + "</span>";
    } else if (val == 0) {
        retStr = emrTrans('过期');
    } 
     return retStr;
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

function rendererPAStatus(val){
    var retStr = "";
    if (val == 'in') {
        retStr = emrTrans('在院');
    } else {
        retStr = "<span style='color:green;font-weight:bold;'>" +emrTrans("出院") + "</span>";
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

function rendererIsAppointed(val){
    var retStr = "";
    if (val == 'unappointed') {
        retStr = emrTrans('未授权');
    }else if (val == 'appointed') {
        retStr = "<span style='color:#015399;font-weight:bold;'>" + emrTrans("已授权") + "</span>";
    }else if (val == 'refuse') {
        retStr = emrTrans('拒绝');
    }else{
        retStr = val;
    }
    return retStr;
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
	var hasModify = false;
	$.each(valArr,function(i,item){
		var itemArr = item.split('^');
		if (itemArr[3] == 1)
		{
			hasModify = true;
		}
	});
	$.each(valArr,function(i,item){
		var itemArr = item.split('^');
		if (hasModify == true)
		{
			if (itemArr[2]==1) rtnArr.push(itemArr[1]);
		}
		else
		{
			//未对将要授权的操作做过修改时，默认是全部操作都给予授权，应该显示全部操作，不应该为空，为了和“对将要授权的操作已经做过修改，全部操作权限都拒绝”的情况作区分；
			rtnArr.push(itemArr[1])
		}
	});
	return rtnArr.join();
}

function IsSealed(val)
{
	var retStr = "";
	
	var HasSealedFlag = HasSealed(val);
	if (HasSealedFlag == 'Y') {
        retStr = "<span style='color:red;font-weight:bold;'>" +emrTrans("有") + "</span>";
    }else if (HasSealedFlag == 'N') {
        retStr = "<span style='color:green;font-weight:bold;'>" +emrTrans("无") + "</span>";
    }
    return retStr;
}

function HasSealed(val)
{
	var HasSealed = "N";
	$.each(val,function(i,item){
		if (item.IsSealed == "Y")
		{
			HasSealed = "Y";
			return false;
		}
	});
	
	return HasSealed;
}

function getSealedRecordTitles(val)
{
	var retStr = "";
	$.each(val,function(i,item){
		if (item.IsSealed == "Y")
		{
			if (retStr == "")
			{
				retStr = item.CCDesc;
			}
			else
			{
				retStr = retStr + "<br>" + item.CCDesc;
			}
		}
	});
	
	return retStr;
}

function rendererSealed(val){
	var retStr = "";
    if (val == 'Y') {
        retStr = "<span style='color:red;font-weight:bold;'>" +emrTrans("是") + "</span>";
    }else if (val == 'N') {
        retStr = emrTrans('否');
    }else{
        retStr = val;
    }
    return retStr;
}

function IsCopyed(val)
{
	var retStr = val;
	
	if (val == "") {
        retStr = "<span style='color:green;font-weight:bold;'>" +emrTrans("无") + "</span>";
    }
    return retStr;
}

//获取查询参数
function getParam()
{
  //获取登记号  
  	var PapmiNo = "";
    if  ($('#txtPapmiNo').val() != "") 
    {
        PapmiNo = $('#txtPapmiNo').val();
		//登记号补全十位
		var ncont = 10-PapmiNo.length;
        for (var i = 0; i < ncont; i++)
        {
	        PapmiNo = '0'+PapmiNo;
	    }
	    $('#txtPapmiNo').text(PapmiNo);
    }
    
	//获取病案号，供病案室用户查询使用 
	var MedicareNo = $('#MedicareNo').val();
	
	//获取患者姓名
	var PatName = $('#textName').val();

    //获取就诊科室
    var treatmentLoc = $('#cbxTreatmentLoc').combobox('getValue');
    
    //获取就诊类型
    var pAAdmType = $('#cbxPAAdmType').combobox('getValue');
    
    //获取在院状态
    var pAStatus =  $('#cbxPAStatus').combobox('getValue');

    //获取申请科室
    var requestLoc = $('#cbxRequestLoc').combobox('getValue');
    
    //获取申请医生 
	var requestUserName = $('#txtRequestUserName').val();
    
    //获取action
    var action = $('#cbxAppointAction').combobox('getValue');

    //将action赋给授权情况下拉框
    $('#cbxAppointAction').combobox('setValue', action);
	//获取授权级别
    var cbxAuthLevel = $('#cbxAuthLevel').combobox('getValue');
    var AuthLevelType = authLevelTop;
    if (cbxAuthLevel != "")  AuthLevelType = cbxAuthLevel;
    
    //获取申请起止时间，默认为空
    var dtRequestDateStart = dateFormat($('#dtRequestDateStart').datebox('getValue'));
    var tmRequestTimeStart = $('#tmRequestTimeStart').timespinner('getValue');
    var dtRequestDateEnd = dateFormat($('#dtRequestDateEnd').datebox('getValue'));
	var tmRequestTimeEnd = $('#tmRequestTimeEnd').timespinner('getValue');
    //获取授权起止时间，默认为空，若授权时间有值，则action改为getappointed
    var dtAppointDateStart = dateFormat($('#dtAppointDateStart').datebox('getValue'));
	var tmAppointTimeStart = $('#tmAppointTimeStart').timespinner('getValue');
	var dtAppointDateEnd = dateFormat($('#dtAppointDateEnd').datebox('getValue'));
	var tmAppointTimeEnd = $('#tmAppointTimeEnd').timespinner('getValue');

	//起止日期/授权起止日期/申请起止时间/授权起止时间 必须成对出现
	var isUseRequestDate = (dtRequestDateStart != ""&&dtRequestDateEnd != "")||(dtRequestDateStart == "" && dtRequestDateEnd == "");
	var isUseAppointDate = (dtAppointDateStart != ""&&dtAppointDateEnd != "")||(dtAppointDateStart == "" && dtAppointDateEnd == "");
	var isUseRequestTime = (tmRequestTimeStart != ""&&tmRequestTimeEnd != "")||(tmRequestTimeStart == "" && tmRequestTimeEnd == "");
	var isUseAppointTime = (tmAppointTimeStart != ""&&tmAppointTimeEnd != "")||(tmAppointTimeStart == "" && tmAppointTimeEnd == "");
	if (!(isUseRequestDate && isUseAppointDate && isUseRequestTime && isUseAppointTime)) {
		alert("申请起止日期/授权起止日期/申请起止时间/授权起止时间 必须成对出现!");
		return "";
	}
    
    //获取授权权限
    var cbxCanAppoint = $('#cbxCanAppoint').combobox('getValue');
    var canAppointSelect=""
    //只有未授权的情况下才能给予授权
    if (action == 'getunappointed') 
    {	$('#cbxCanAppoint').combobox('enable');
        if (cbxCanAppoint != "") 
        {
            canAppointSelect = cbxCanAppoint;
            $('#cbxAppointAction').combobox('setValue',action);
        }
        $('#cbxCanAppoint').combobox('setValue',canAppointSelect);
    }
    else 
    {
        //已授权和全部禁用获取权限下拉框
        $('#cbxCanAppoint').combobox('disable');
    }
    //授权当前是否有效
    var isActive = $('#cbxIsActive').combobox('getValue');
	var param = {
		"Action":action,
		"OnlyCurrentDept":onlyCurrentDept,
		"EPRIntegratedAuthorization":eprIntegratedAuthorization,
		"CanAppointSelect":canAppointSelect,
		"IsActive":isActive,
		"TreatmentLoc":treatmentLoc,
		"RequestLoc":requestLoc,
		"RequestUserName":requestUserName,
		"DefaultAppointSpan":appointSpan,
		"DefaultAppointType":appointType,
		"AppointRequestSpan":appointRequestSpan,
		"RequestDateStart":dtRequestDateStart,
		"RequestTimeStart":tmRequestTimeStart,
		"RequestDateEnd":dtRequestDateEnd,
		"RequestTimeEnd":tmRequestTimeEnd,
		"AppointDateStart":dtAppointDateStart,
		"AppointTimeStart":tmAppointTimeStart,
		"AppointDateEnd":dtAppointDateEnd,
		"AppointTimeEnd":tmAppointTimeEnd,
		"PAAdmType":pAAdmType,
		"PAStatus":pAStatus,
		"PapmiNo":PapmiNo,
		"MedicareNo":MedicareNo,
		"PatName":PatName,
		"RequestRange":globalRequestRange,
		"AuthLevelType":AuthLevelType,
		"AuthLevelTop":authLevelTop,
		"frameType":"HISUI"
	};
	return param;		
}

// 查询
function queryData()
{
	var param = getParam();
	$('#dgResultGrid').datagrid('load',param);
	initValues();
        currAppointAction = $('#cbxAppointAction').combobox('getValue');
}

//审批
function commitAppoint(){
	if (!endEditing())
	{
		$.messager.alert("简单提示", "修改 授权的操作 时,最后一次修改存在问题,请稍后再点击当前按钮", 'info');
		return;
	}
	var selections = $('#dgResultGrid').datagrid('getSelections');
	if (selections.length <= 0)
	{
		$.messager.alert("简单提示", "请选中一条记录再提交申请", 'info');
		return;
	}
	if (selections[0].CanAppoint != "1") 
	{
		$.messager.alert("简单提示", "不能操作授权条目,条目已授权或已拒绝", 'info');
		return;
	}
	for (var i = 0; i < selections.length; i++) 
	{
		var row = selections[i];
		var AppointID = row.AppointID;
		
		//var HasSealedFlag = HasSealed(row.AppointDetailData);
		var SealedRecordTitles = getSealedRecordTitles(row.AppointDetailData);
		if (SealedRecordTitles != "")
		{
			var message = "选中的第" + (i+1) + "条存在已封存病历如下:<br>" + SealedRecordTitles + "<br>不能授权，其他未封存病历已授权。"
			$.messager.alert("简单提示", message, 'info');
		}
		
		//授权类型                      
		var appointType = row.AppointType;
		if (appointType == "") appointType = defaultAppointType;
		
		//授权时长		    
		var span = row.AppointSpan;
		if (span == "" || isNaN(span)) span = defaultAppointSpan;
		var appointSpan = 3600 * parseFloat(span).toString();
		
		jQuery.ajax({
			type: "post",
			dataType: "text",
			url: '../EMRservice.Ajax.auth.authorize.cls',
			async: true,
			data: {
				"Action": "appoint",
				AppointID: AppointID,
				AppointSpan: appointSpan,
				AppointUserID: appointUserID,
				AppointType: appointType
			},
			success: function(d) {
				if (d == "1")
				{
					queryData();
				}
				else
				{
					$.messager.alert("简单提示", "申请权限操作提交失败", 'info');
				}
			},
			error : function(d) { alert(" error");}
		});
	}
	resetProperty();	
}

//拒绝
function refuseAppoint(){
	var seletedCount = 0;
	var successCount = 0;
	var selections = $('#dgResultGrid').datagrid('getSelections');
	if (selections.length <= 0)
	{
		$.messager.alert("简单提示", "请选中一条记录再提交申请", 'info');
		return;
	}
	if (selections[0].CanAppoint != "1")
	{
		$.messager.alert("简单提示", "不能操作拒绝条目,条目已授权或已拒绝", 'info');
		return;
	}
	var RefuseReason = "";
	$.messager.prompt("提示", "拒绝原因", function (r) {
		if (r) 
		{
			var RefuseReason = r;
			for (var i = 0; i < selections.length; i++) 
			{
				var row = selections[i];
				var AppointID = row.AppointID;
				jQuery.ajax({
					type: "post",
					dataType: "text",
					url: '../EMRservice.Ajax.auth.authorize.cls',
					async: true,
					data: {
					    "Action": "refuse",
						AppointID: AppointID,
						AppointUserID: appointUserID,
						RefuseReason: RefuseReason
					},
					success: function(d) {
						if (d == "1")
						{
							queryData();
						}
						else
						{
							$.messager.alert("简单提示", "拒绝权限操作提交失败", 'info');
						}
					},
					error : function(d) { $.messager.alert("简单提示", "error", 'info');}
				});					
			}				
		} 
	});
    resetProperty();
}

//回收
function withdrawAppoint(){
    var selections = $('#dgResultGrid').datagrid('getSelections');
    if (selections.length <= 0)
    {
	    $.messager.alert("简单提示", "请选中回收条目", 'info');
	    return;
	}
	
	if (selections[0].CanAppoint != "2")
	{
		$.messager.alert("简单提示", "不能做回收操作,条目非已授权状态", 'info');
		return;
	}
		
	for (var i = 0; i < selections.length; i++) 
	{
		var AppointID = selections[i]['AppointID'];
		jQuery.ajax({
			type: "post",
			dataType: "text",
			url: '../EMRservice.Ajax.auth.authorize.cls',
			async: true,
			data: {
				Action: "withdraw",
				AppointID: AppointID
			},
			success: function(d) {
				if (d == "1")
				{
					queryData();
				}
				else
				{
					$.messager.alert("简单提示", "回收权限失败", 'info');
				}
			},
			error : function(d) { $.messager.alert("简单提示", "error", 'info');}
		});	
	}
    resetProperty();
}

function resetProperty(){
	$("#taRequestReason").empty();
	$("#taBeforeRequestContent").empty();
	$("#taAfterRequestContent").empty();
	$("#taRequestNumber").empty();
}

function JSONToCSVConvertor(JSONData, ReportTitle, ShowLabel) {  
    var arrData = typeof JSONData != 'object'?JSON.parse(JSONData):JSONData;  
    var CSV = '';  
    CSV += ReportTitle + '\r\n\n';  
    if (ShowLabel) {  
        var row = "";   
        row = emrTrans("授权ID,能否审核,授权级别,是否过期,患者姓名") //,就诊科室,主治医师,申请医师,申请时间,申请原因,在院状态,出院日期,登记号,病案号,就诊日期,就诊时间,就诊类型,就诊号,申请科室,授权状态,授权医师,授权类型,授权剩余时间,授权/拒绝时间,授权结束时间,修改前内容,拒绝原因";    
        CSV += row + '\r\n';  
    } 
    var col = ["AppointID","CanAppoint","AuthLevelDesc","IsActive","Name"] //,"CurDept","MainDoc","RequestUser","RequestDateTime","RequestReason","PAStatus","PADischgeDateTime","PapmiNo","MedicareNo","AdmDate","AdmTime","PAAdmType","PaadmNO","RequestDept","IsAppointed","AppointUser","AppointType","AppointSpan","AppointDateTime","AppointEndDateTime","BeforeRequestContent", "AfterRequestContent","RefuseReason"]; 
    for (var i = 0; i < arrData.length; i++) 
    {  
	    var row = "";  
	    for ( var index in col) 
	    {  
	        row += '"' + arrData[i][index] + '",';  
	    }  
	    row.slice(0, row.length - 1);  
        CSV += row + '\r\n';  
    }  

    if (CSV == '') {  
        alert("Invalid data");  
        return;  
    }  

        var fileName = "授权列表_";  
        fileName += ReportTitle.replace(/ /g, "_");  
        var uri = 'data:text/csv;charset=utf-8,' + escape(CSV);  
        var link = document.createElement("a");  
        link.href = uri;  
        link.style = "visibility:hidden";  
        link.download = fileName + ".csv";  
        document.body.appendChild(link);  
        link.click();  
        document.body.removeChild(link);  
    } 
    
function queryReset()
{
	$('#txtPapmiNo').val('');
    $('#cbxPAStatus').combobox("setValue", '');
    $('#dtRequestDateStart').datebox("setValue", '');
    $('#tmRequestTimeStart').timespinner("setValue", '');
    
    $('#MedicareNo').val('');
    $('#cbxPAAdmType').combobox("setValue", '');
    $('#dtRequestDateEnd').datebox("setValue", '');
    $('#tmRequestTimeEnd').timespinner("setValue", '');
    
    $('#textName').val('');
    $('#cbxTreatmentLoc').combobox("setValue", '');
    $('#dtAppointDateStart').datebox("setValue", '');
    $('#tmAppointTimeStart').timespinner("setValue", '');
    
    $('#txtRequestUserName').val('');
    $('#cbxRequestLoc').combobox("setValue", '');
    $('#dtAppointDateEnd').datebox("setValue", '');
    $('#tmAppointTimeEnd').timespinner("setValue", '');
}
function exportData(type){
	var fields =$("#dgResultGrid").datagrid("getColumnFields");
	var col="";
	for(var key in fields){
		var field=$("#dgResultGrid").datagrid('getColumnOption',fields[key])
		var fieldDesc =field.title;
		var fieldHidden=field.hidden;
		if(fieldDesc==undefined || fieldHidden==true)continue;
		if(col !="")col+="#";
		col += fields[key]+":"+fieldDesc;
	}
	//子表可能没有加载
	col += "#"+"CCDesc"+":"+"病历名称"+"#"+"CCCreator"+":"+"病历创建者"+"#"+"DetailStr"+":"+"申请的操作"+"#"+"DetailStr1"+":"+"授权的操作"
	var param = getParam();
	var page="";
	var rows="";
	if(type==="current"){
		var pageObj=$("#dgResultGrid").datagrid('getPager').data("pagination").options;
		rows=pageObj.pageSize;
		page=(pageObj.pageNumber-1)*rows;
	}
	var title=appointUserID+"-"+(new Date()).getTime();
	var defaultAppointSpan=param.DefaultAppointSpan || "24";
	var defaultAppointType=param.DefaultAppointType || "0";
	var appointRequestSpan=param.AppointRequestSpan || "0";
	var parameters = appointUserLoc+"^"+appointUserID+"^"+param.RequestDateStart+"||"+param.RequestTimeStart+"||"+param.RequestDateEnd+"||"+param.RequestTimeEnd+"||"+param.AppointDateStart+"||"+param.AppointTimeStart+"||"+param.AppointDateEnd+"||"+param.AppointTimeEnd+"^"+param.CanAppointSelect+"^"+param.TreatmentLoc+"^"+param.RequestLoc+"^"+param.RequestUserName+"^"+defaultAppointSpan+"^"+defaultAppointType+"^"+param.PAAdmType+"^"+param.PAStatus+"^"+param.IsActive+"^"+appointRequestSpan+"^"+ssgroupID+"^"+param.RequestRange+"^"+hospitalID
	var onlyCurrentDept=param.OnlyCurrentDept;
	var docType="all";
	if(onlyCurrentDept==1){
		docType="loc";
	}
	var authLevelType=param.AuthLevelType;
	if(authLevelType=="ALL"){
		authLevelType="";	
	}
	var action=param.Action;
	if(action=="getunappointed")
	{
		var loadType="UnAppointed";	
	}else if(action=="getappointed")
	{
		var loadType="Appointed";	
	}else if(action=="getrefuse")
	{
		var loadType="Refuse";	
	}else{return;}
	$.messager.progress({
				title: "提示",
				msg: '正在导出数据',
				text: '导出中....'
			});
	var params=loadType+","+patientID+","+parameters+","+type+","+page+","+rows+","+docType+","+authLevelType+","+col
		jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.Tools.ExportToExcel",
			"Method":"toExcelByEMR",
			"p1":title,
			"p2":"EMRservice.Ajax.auth.authorize",
			"p3":"getExcelData",
			"p4":params
		},
		success: function(d) {
				var flag = d.substring(0,1);
				if(flag=="w"){
					location.href=d;
				}else{
					alert("导出错误");
				}	
				$.messager.progress("close");
		},
		error : function(d) { 
			alert("系统错误");
			$.messager.progress("close");
		}
	});	
}
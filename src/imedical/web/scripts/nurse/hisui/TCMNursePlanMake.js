/**
* @author songchunli
* HISUI 中医护理计划制定主js
*/
var PageLogicObj={
	m_TCMDiseaseRecTableGrid:"",
}
$(function(){
	Init();
	InitEvent();
	ResetDomSize();
});
$(window).load(function() {
	$("#loading").hide();
})
function Init(){
	$("#SearchDisease").combobox("setValue","");
	LoadDept();
	// 初始化患者列表树
	if (ServerObj.IsShowPatList =="Y") {
		// 护理分组权限开启时，默认显示责组
		if(ServerObj.groupFlag=="Y"){
			$("#switchBtn").addClass("ant-switch-checked");
			$($(".switch label")[1]).addClass("current");
		}
		InitPatientTree();
	}else{
		InitTCMDiseaseRecTableGrid();
	}
}
function InitEvent(){
	$("#wardPatientSearchBox").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			$HUI.tree('#patientTree','reload');
		}
	});
	$("#wardPatientSearchBtn").click(function(){
		$HUI.tree('#patientTree','reload');
	});
	$("#switchBtn").click(function(){
		$(".current").removeClass("current");
		if ($(".ant-switch-checked").length) {
			$("#switchBtn").removeClass("ant-switch-checked");
			$($(".switch label")[0]).addClass("current");
		}else{
			$("#switchBtn").addClass("ant-switch-checked");
			$($(".switch label")[1]).addClass("current");
		}
		$HUI.tree('#patientTree','reload');
	});
	$("#BFind").click(function(){
		$('#TCMDiseaseRecTable').datagrid("reload");
	});
}
function LoadDept(){
	$.cm({
		ClassName:"web.DHCDocIPBookingCtl",
		QueryName:"admdeplookup",
	    desc:"", UserDepID:session['LOGON.CTLOCID'],
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#SearchLoc", {
				valueField: 'depid',
				textField: 'dep', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["dep"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["ctContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}
function InitPatientTree(){
	$HUI.tree('#patientTree', {
		loader: function(param, success, error) {
			// HIS 8.5 版本
			if (ServerObj.version85 == "1"){
				var parameter = { EpisodeID:ServerObj.EpisodeID, WardID:session['LOGON.WARDID'], LocID:session['LOGON.CTLOCID'], GroupFlag:$(".ant-switch-checked").length ? true : false, BabyFlag:'', SearchInfo:$("#wardPatientSearchBox").val(), LangID:session['LOGON.LANGID'], UserID:session['LOGON.USERID'] };
				$cm({
					ClassName: "Nur.NIS.Service.Base.Ward",
					MethodName: "GetWardPatientsNew",
					wardID:session['LOGON.WARDID'],
					adm:ServerObj.EpisodeID,
					groupSort:$(".ant-switch-checked").length?"true":"false",
					babyFlag:"",
					searchInfo:$("#wardPatientSearchBox").val(),
					locID:session['LOGON.CTLOCID']
				}, function(data) {
					var addIDAndText = function(node) {
						node.id = node.ID;
						node.text = node.label ;
						if (node.id === ServerObj.EpisodeID) {
							node.checked = true;
						}
						if (node.children) {
							node.children.forEach(addIDAndText);
						}
					}
					data.forEach(addIDAndText);
					success(data);
				});
			}else
			{
				// 兼容低版本HIS -- 取护理病历病人列表接口
				$cm({
					ClassName: "NurMp.NursingRecords",
					MethodName: "getWardPatients",
					wardID: session['LOGON.WARDID'],
					adm: ServerObj.EpisodeID,
					groupSort: $(".ant-switch-checked").length?"true":"false", //!$('#wardPatientCondition').switchbox('getValue'),
					babyFlag: '',
					searchInfo:$("#wardPatientSearchBox").val(), //$HUI.searchbox('#wardPatientSearchBox').getValue(),
					locID: session['LOGON.CTLOCID']||'',
					todayOperFlag: $("#radioTodayOper").radio('getValue')
				}, function(data) {
					var addIDAndText = function(node) {
						node.id = node.ID;
						node.text = node.label ;
						if (node.id === ServerObj.EpisodeID) {
							node.checked = true;
						}
						if (node.children) {
							node.children.forEach(addIDAndText);
						}
					}
					data.forEach(addIDAndText);
					success(data);
				});
			}
		},
		onLoadSuccess: function(node, data) {
			var addIDAndText = function(node) {
				node.id = node.ID;
				node.text = node.label ;
				if ((typeof node.icons != 'undefined') && (!!node.icons)) {
					$.each(node.icons.reverse(), function(index, value){
						$("#patientTree > li > ul > li > div > span:contains(" + node.text + ")").after("<img style='margin:6px;' src='" + value + "'/>");
					});
				}
				if (node.children) {
					node.children.forEach(addIDAndText);
				}
			}
			data.forEach(addIDAndText);
			if (!ServerObj.EpisodeID){
				var frm = dhcsys_getmenuform();
				ServerObj.EpisodeID=frm.EpisodeID.value;
			}
			if (!!ServerObj.EpisodeID) {
				var selNode = $('#patientTree').tree('find', ServerObj.EpisodeID);
				$('#patientTree').tree('select', selNode.target);
				if (PageLogicObj.m_TCMDiseaseRecTableGrid){
					$('#TCMDiseaseRecTable').datagrid("reload");
				}else{
					InitTCMDiseaseRecTableGrid();
				}
			}
		},
		lines: true,
		onClick: function (node) {
			patNode=node;
			if (!!node.episodeID) {
				ServerObj.EpisodeID=node.id;
				if (PageLogicObj.m_TCMDiseaseRecTableGrid){
					$('#TCMDiseaseRecTable').datagrid("reload");
				}else{
					InitTCMDiseaseRecTableGrid();
				}
			}
		}
	});
}
function InitTCMDiseaseRecTableGrid(){
	var ToolBar = [{
            text: '新增',
            iconCls: '	icon-add',
            handler: function() {
	            ShowTCMDisease("","新增");
            }
        },{
            text: '修改',
            iconCls: 'icon-edit',
            handler: function() {
	           var sel=$('#TCMDiseaseRecTable').datagrid("getSelected");
	           if (!sel){
		           $.messager.popover({msg:'请选择病种记录！',type:'error'});
		           return false;
		       }
		       ShowTCMDisease(sel.DisRecId,"修改 <span style='color:yellow;'>"+sel.DISRDiseaseDesc+"</span> 信息");
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
	           DelDISRDisease();
            }
        }];
	var Columns=[[ 
		{ field: 'DISRDiseaseDesc', title: '病种',width:120},
		{ field: 'PatLoc', title: '科室',width:140},
		{ field: 'PatName', title: '姓名',width:100},
		{ field: 'PatSex', title: '性别',width:50},
		{ field: 'PatAge', title: '年龄',width:50},
		{ field: 'PatMedNo', title: '病案号',width:100},
		{ field: 'PatTel', title: '联系电话',width:110},
		{ field: 'InHospDateTime', title: '入院时间',width:130},
		{ field: 'PatInDays', title: '住院总天数',width:90},
		{ field: 'ImproveSuggestion', title: '改进意见',width:150},
		{ field: 'FERNurse', title: '护士',width:100},
		{ field: 'FERSuperNurse', title: '护士长',width:100},
		{ field: 'PatOutHosDate', title: '出院时间',width:130},
		{ field: 'DISRLocDesc', title: '填写科室',width:150},
		{ field: 'DISRDateTime', title: '填写时间',width:130}
    ]];
	$('#TCMDiseaseRecTable').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : $g('加载中..'),  
		pagination : true, 
		rownumbers : false,
		idField:"DisRecId",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.TCM.Service.NursingPlan.NursePlanMake&QueryName=GetTCMDiseaseList",
		onBeforeLoad:function(param){
			$('#TCMDiseaseRecTable').datagrid("unselectAll");
			param = $.extend(param,{
				SearchEpisodeID:ServerObj.EpisodeID,
				SearchDateFrom:$("#SearchDateFrom").datebox('getValue'), 
				SearchDateTo:$("#SearchDateTo").datebox('getValue'), 
				SearchDisease:$("#SearchDisease").combobox('getValues').join("^"),
				SearchLoc:$("#SearchLoc").combobox('getValues').join("^"),
			});
		},
		onDblClickRow:function(rowIndex, rowData){
			ShowTCMDisease(rowData.DisRecId,"修改 <span style='color:yellow;'>"+rowData.DISRDiseaseDesc+"</span> 信息");
		}
	})
}
function ShowTCMDisease(DisRecId,title){
	websys_showModal({
		url:"nur.hisui.tcmdisease.csp?DisRecId="+DisRecId+"&EpisodeID="+ServerObj.EpisodeID,
		title:title,
		width:'961px',height:'90%',
		CallBackFunc:function(){
			websys_showModal("close");
			$('#TCMDiseaseRecTable').datagrid("reload");
		}
	})
}
function DelDISRDisease(){
	var sel=$('#TCMDiseaseRecTable').datagrid("getSelected");
    if (!sel){
       $.messager.popover({msg:'请选择需要删除的病种记录！',type:'error'});
       return false;
    }
    var SaveDataArr=[];
    SaveDataArr.push(sel.DisRecId);
    $m({
		ClassName:"Nur.TCM.Service.NursingPlan.NursePlanMake",
		MethodName:"SaveTCMDisease",
		SaveDataArr:JSON.stringify(SaveDataArr),
		event:"DELETE"
	},function(rtn){
		if (rtn ==0){
			$.messager.popover({msg:'删除成功！',type:'success'});
			var index=$('#TCMDiseaseRecTable').datagrid("getRowIndex",sel.DisRecId);
			$('#TCMDiseaseRecTable').datagrid("deleteRow",index);
		}else{
			$.messager.popover({msg:'删除失败！',type:'error'});
		}
	})
}
function ResetDomSize() {
	var innerHeight=window.innerHeight;
	$(".hisui-layout").layout("resize").layout('panel', 'center').panel('resize',{height:'100%',width:'100%'});
	$("#patientListTree").panel('resize', {
	  	height:innerHeight-104
	});
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
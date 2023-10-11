///Creator:	xww
///Date:	2021-06-19
///Desc:	处方数量明细查询
var regNo = "";
var stDate = "";
var edDate = "";
var locName = "";
var monId = "";
$(function(){
	
	initParams();
	
	initDataGrid();
	
	initDrugDataGrid();
})

function initParams(){
	stDate = getParam("stDate");   /// 开始日期
	edDate = getParam("edDate");   /// 结束日期
	locName = getParam("locName"); /// 科室名称
	locName = decodeURI(locName);
	type = getParam("type");   /// 类型
}


function initDataGrid(){

	var params = stDate + "^" + edDate  + "^" + locName  + "^" + type;
	var columns= [[
		{field:'monId',title:'监测主表id',width:100,hidden:true},
		{field:'seqNo',title:'序号',width:40,hidden:false},
		{field:'patName',title:'患者姓名',width:70,hidden:false},
		{field:'PatSex',title:'性别',width:50,hidden:false},
		{field:'PatAge',title:'年龄',width:50,hidden:false},
		{field:'regNo',title:'登记号',width:100,hidden:false},
		{field:'Diagnosis',title:'诊断',width:120,hidden:false},
		{field:'PAAdmDate',title:'就诊日期',width:90,hidden:false},
		{field:'Length',title:'药品错误数量',width:90,hidden:false},
		{field:'CMCreateDate',title:'审查日期',width:90,hidden:false},
		{field:'CMCreateTime',title:'审查时间',width:80,hidden:false},
	]];
	
	$HUI.datagrid('#datagrid',{
		url:'dhcapp.broker.csp?ClassName=web.DHCCKBRecipeAuditStat&MethodName=ErrorPrescDetail',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  
		pageList:[30,60,90], 
		loadMsg: '正在加载信息...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:'处方数量明细', 
		iconCls:'icon-paper',
		headerCls:'panel-header-gray', //ed
		queryParams:{
			params:params,
		},
		onClickRow:function(rowIndex, rowData){
			showAuditDetail(rowData.monId);
			showDrugDetail(rowData.monId);
		},
		onLoadSuccess:function(data){
			
		}
    })

}

function initDrugDataGrid(){

	
	var columns= [[
		{field:'seqNo',title:'序号',width:60,hidden:false},
		{field:'drugName',title:'药品名称',width:350,hidden:false},
		{field:'drugFreq',title:'频次',width:100,hidden:false},
		{field:'drugPreMet',title:'给药途径',width:100,hidden:false},
		{field:'dose',title:'剂量',width:100,hidden:false},
		{field:'treatment',title:'疗程',width:100,hidden:false},
	]];
	
	$HUI.datagrid('#drugdetail',{
		url:'dhcapp.broker.csp?ClassName=web.DHCCKBRecipeAuditStat&MethodName=GetDrugDetailByMonId',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  
		pageList:[30,60,90], 
		loadMsg: '正在加载信息...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:'处方明细信息', 
		iconCls:'icon-paper',
		headerCls:'panel-header-gray', //ed
		queryParams:{
			monId:monId,
		},
		onClickRow:function(rowIndex, rowData){
			
		},
		onLoadSuccess:function(data){
			
		}
    })
}
function showDrugDetail(monId){
	$("#drugdetail").datagrid('reload',{monId:monId});
}

function showAuditDetail(monid){
	runClassMethod("web.DHCCKBMonitor","GetCkbExaRes",{"ID":monid},function(jsonString){
		var Data=jsonString;
		showAuditDetailhtml(Data)
	},"json")
}

function showAuditDetailhtml(retJson){

	$PDSS_PANEL = $('#datagriddetail')   
	$PDSS_PANEL.empty();
	if ($.isEmptyObject(retJson)){
		return;	
	}
	var $mTip = $('<div class="pha-row"></div>');
	$PDSS_PANEL.append($mTip);
	$PDSS_PANEL.append('<div class="pha-line"></div>');
	$mTip.append('<div class="pha-col"><label>审查结果</label></div>');
	if (retJson.passFlag == 0){
		$mTip.append('<div class="pha-col" style="color:red;">'+ '不通过' +'</div>');
	} else if (retJson.passFlag == 1) {
		$mTip.append('<div class="pha-col" style="color:green;">'+ '通过' +'</div>');
	}
	$mTip.append('<div class="pha-col">&ensp;&ensp;</div>');
	$mTip.append('<div class="pha-col"><label>级别</label></div>');
	$mTip.append('<div class="pha-col"><span class="itemlabel-yy '+ retJson.manLevel +'-bg"></span></div>')
	$mTip.append('<div class="pha-col '+ retJson.manLevel +'-color">'+ retJson.manLev +'</div>');
	var itemsArr = retJson.items;
	for (var i = 0; i < itemsArr.length; i++){
		var $row = $('<div class="pha-row"></div>');
		$row.append('<div class="pha-col"><span class="itemlabel-xh '+ itemsArr[i].manLevel +'-bg"><label>'+ itemsArr[i].seqno +'</label></span></div>');
		$row.append('<div class="pha-col"><label>'+ itemsArr[i].item +'</label></div>');
		$PDSS_PANEL.append($row);
		
		var warnsArr = itemsArr[i].warns;
		var $warns = $('<div style="padding-left: 20px;"></div>');
		$PDSS_PANEL.append($warns);
		for (var j = 0; j < warnsArr.length; j++){
			var $warnRow = $('<div class="pha-row"></div>');
			$warns.append($warnRow);
			$warnRow.append('<div class="pha-col"></div>');
			$warnRow.append('<div class="pha-col"><span class="itemlabel-yy '+ warnsArr[j].manLevel +'-bg"></span></div>');
			$warnRow.append('<div class="pha-col '+ warnsArr[j].manLevel +'-color">'+ warnsArr[j].manLev +'</div>');
			$warnRow.append('<div class="pha-col '+ warnsArr[j].manLevel +'-color">'+ warnsArr[j].keyname +'</div>');
			
			var $msg = $('<div class="pha-col"></div>');
			var msgItmsArr = warnsArr[j].itms;
			for (var k = 0; k < msgItmsArr.length; k++){
				var valItemArr = msgItmsArr[k].itms;
				for (var x = 0; x < valItemArr.length; x++){
					$msg.append('<label>'+ valItemArr[x].val +'</label>');
				}
			}
			$warnRow.append($msg);
		}
	}

}

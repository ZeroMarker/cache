///Creator:	xww
///Date:	2021-06-19
///Desc:	����������ϸ��ѯ
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
	stDate = getParam("stDate");   /// ��ʼ����
	edDate = getParam("edDate");   /// ��������
	locName = getParam("locName"); /// ��������
	locName = decodeURI(locName);
	type = getParam("type");   /// ����
}


function initDataGrid(){

	var params = stDate + "^" + edDate  + "^" + locName  + "^" + type;
	var columns= [[
		{field:'monId',title:'�������id',width:100,hidden:true},
		{field:'seqNo',title:'���',width:40,hidden:false},
		{field:'patName',title:'��������',width:70,hidden:false},
		{field:'PatSex',title:'�Ա�',width:50,hidden:false},
		{field:'PatAge',title:'����',width:50,hidden:false},
		{field:'regNo',title:'�ǼǺ�',width:100,hidden:false},
		{field:'Diagnosis',title:'���',width:120,hidden:false},
		{field:'PAAdmDate',title:'��������',width:90,hidden:false},
		{field:'Length',title:'ҩƷ��������',width:90,hidden:false},
		{field:'CMCreateDate',title:'�������',width:90,hidden:false},
		{field:'CMCreateTime',title:'���ʱ��',width:80,hidden:false},
	]];
	
	$HUI.datagrid('#datagrid',{
		url:'dhcapp.broker.csp?ClassName=web.DHCCKBRecipeAuditStat&MethodName=ErrorPrescDetail',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  
		pageList:[30,60,90], 
		loadMsg: '���ڼ�����Ϣ...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:'����������ϸ', 
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
		{field:'seqNo',title:'���',width:60,hidden:false},
		{field:'drugName',title:'ҩƷ����',width:350,hidden:false},
		{field:'drugFreq',title:'Ƶ��',width:100,hidden:false},
		{field:'drugPreMet',title:'��ҩ;��',width:100,hidden:false},
		{field:'dose',title:'����',width:100,hidden:false},
		{field:'treatment',title:'�Ƴ�',width:100,hidden:false},
	]];
	
	$HUI.datagrid('#drugdetail',{
		url:'dhcapp.broker.csp?ClassName=web.DHCCKBRecipeAuditStat&MethodName=GetDrugDetailByMonId',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  
		pageList:[30,60,90], 
		loadMsg: '���ڼ�����Ϣ...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:'������ϸ��Ϣ', 
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
	$mTip.append('<div class="pha-col"><label>�����</label></div>');
	if (retJson.passFlag == 0){
		$mTip.append('<div class="pha-col" style="color:red;">'+ '��ͨ��' +'</div>');
	} else if (retJson.passFlag == 1) {
		$mTip.append('<div class="pha-col" style="color:green;">'+ 'ͨ��' +'</div>');
	}
	$mTip.append('<div class="pha-col">&ensp;&ensp;</div>');
	$mTip.append('<div class="pha-col"><label>����</label></div>');
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

//problemspresc.js
//���⴦��

var LevelArr = [{"value":"normal","text":'��ʾ'},{"value":"tips","text":'����'},{"value":"warn","text":'��ʾ'},{"value":"forbid","text":'��ֹ'}];

$(function(){
	
	initCombobox();	
	initMainList();
	//initDatagrid();
	//initBtn();

});


// ��ʼ������ؼ�
function initCombobox(){
	
	// ��ʼ����
	$HUI.datebox("#startDate").setValue(formatDate(0));
	
	/// ��������
	$HUI.datebox("#endDate").setValue(formatDate(0));	
	
	//����
	$('#ctLoc').combobox({ 
		url:$URL+'?ClassName=web.DHCCKBCommonCom&MethodName=JsonLoc&HospID='+LgHospID,
		valueField: 'value',
		textField: 'text',
		mode:'remote',
		blurValidValue:true,
		onSuccess:function(data){
			var a=data;
			
		}
	})
	
	// ������
	$('#manLevel').combobox({ 
		data:LevelArr,
		valueField: 'value',
		textField: 'text'		
	})
	
}

/// ��ʼ�����������б�
function initMainList(){	

	//  ����columns
	var columns=[[
		{field:'edit',title:'�鿴',width:50,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:'prescNo',title:'������',width:120,align:'center'},
		{field:'stDate',title:'��������',width:120,align:'center'},			
		{field:'patname',title:'��������',width:120,align:'center'},		
		{field:'patsex',title:'�Ա�',width:80,align:'center'},
		{field:'patage',title:'��������',width:100},
		{field:'patloc',title:'����',align:'center',width:120},
		{field:'patdoc',title:'ҽ��',align:'center',width:100},
		{field:'patdis',title:'���',align:'center',width:200},
		{field:'manlevel',title:'������',width:100,align:'center'},		
		{field:'warnmsg',title:'Ԥ����Ϣ',width:400},
		{field:'reason',title:'ǿ�����ԭ��',width:200},
		{field:'cmrowId',title:'��־id',hidden:true}
	]];
	
	var option={	
		columns:columns,
		bordr:false,	
		fitColumns:false,
		singleSelect:true,	
		striped: true, 	
		pagination:true,
		rownumbers:true,
		loadMsg: '���ڼ�����Ϣ...',
		pageSize:50,
		pageList:[50,100,150],		
 		onClickRow:function(rowIndex,rowData){}, 
		onDblClickRow: function (rowIndex, rowData) {			
		}       
	}        
			
	var uniturl = ""
	new ListComponent('main', columns, uniturl, option).Init();
}


///���ò鿴����
function setCellEditSymbol(value, rowData, rowIndex){
				
	return "<a href='#' onclick=\"showEditWin('"+rowData.cmrowId+"')\"><img src='../scripts/dhcadvEvt/images/adv_sel_8.png' border=0/></a>";

}

/// �鿴����
function showEditWin(cmRowID){	

	var linkUrl ="dhcckb.problemdetail.csp?cmRowID=" +cmRowID;

	commonShowWin({
		url: linkUrl,
		title: $g("Ԥ����Ϣ��ϸ"),
		width: document.body.offsetWidth - 100, //window.screen.availWidth - 30,
		height: window.screen.availHeight - 50
	})	
}


/// ��ѯ
function query(){

	var startDate=$("#startDate").datebox('getValue');  //��ʼʱ��
	var endDate=$("#endDate").datebox('getValue');		//����ʱ��
	var manLevel = $HUI.combobox("#manLevel").getValue();// ������
	var ctLoc = $HUI.combobox("#ctLoc").getText();	// ����
	
	var params = startDate +"^"+ endDate +"^"+ manLevel +"^"+ ctLoc;
	var uniturl = $URL+"?ClassName=web.DHCCKBProblemsPresc&MethodName=QueryProblemsPresc&params="+params;
	$("#main").datagrid("options").url = uniturl;
	$("#main").datagrid("load",{"params":params}); 


}

/// ����
function reset(){
	
	$HUI.datebox("#startDate").setValue(GetCurSystemDate(0));  // ��ʼ����
	$HUI.datebox("#endDate").setValue(GetCurSystemDate(0));	  // ��������	
	$HUI.combobox("#manLevel").setValue("");			  /// ������
	$HUI.combobox("#ctLoc").setValue("");			  // ����
	
	query();
}
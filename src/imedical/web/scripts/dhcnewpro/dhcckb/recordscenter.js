$(function(){
	initDateBox();
	initDatagrid();
	initBtn();
})

///��ʼ���¼��ؼ�
function initDateBox(){
	var now = new Date();

    var year = now.getFullYear();       //��
    var month = now.getMonth() + 1;     //��
    var day = now.getDate();            //��
    var clock = year + "-";

    if(month < 10)
        clock += "0";

    clock += month + "-";

    if(day < 10)
        clock += "0";

    clock += day + " ";
    
	
	$HUI.datebox("#stdate").setValue(clock);
	$HUI.datebox("#eddate").setValue(clock);
}

//��ʼ�����
function initDatagrid(){
	var stdate = $("#stdate").datebox("getValue");
	var eddate = $("#eddate").datebox("getValue");
	$("#datagrid").datagrid({
		autoSizeColumn:false,
		fitColumns:true,idField:'id',
		headerCls:'panel-header-gray',iconCls:'icon-paper',
		rownumbers:true,width:650,height:200,
		title:'�����б�',titleNoWrap:false,/*��ͷ�Զ�����*/
		nowrap:false,
		fontSize:12, /*��������������С*/
		lineHeight:12,
		data:{
			rows:[
			{RowID:'1',CMCreateDate:'2021-01-15',CMCreateTime:'01:42:21',CMCreateUser:'����Ա',CMHospDesc:'������Ժ',CMPassFlag:'0',CMManLevDr:'normal',CMIp:'111.19.40.96'},
			{RowID:'2',CMCreateDate:'2021-01-15',CMCreateTime:'01:42:21',CMCreateUser:'����Ա',CMHospDesc:'������Ժ',CMPassFlag:'0',CMManLevDr:'normal',CMIp:'111.19.40.96'},
			{RowID:'3',CMCreateDate:'2021-01-15',CMCreateTime:'01:42:22',CMCreateUser:'����Ա',CMHospDesc:'������Ժ',CMPassFlag:'0',CMManLevDr:'normal',CMIp:'111.19.40.96'},
			{RowID:'4',CMCreateDate:'2021-01-15',CMCreateTime:'01:42:21',CMCreateUser:'����Ա',CMHospDesc:'������Ժ',CMPassFlag:'0',CMManLevDr:'forbid',CMIp:'111.19.40.96'},
			{RowID:'5',CMCreateDate:'2021-01-15',CMCreateTime:'01:42:21',CMCreateUser:'����Ա',CMHospDesc:'������Ժ',CMPassFlag:'0',CMManLevDr:'normal',CMIp:'111.19.40.96'},
			{RowID:'6',CMCreateDate:'2021-01-15',CMCreateTime:'01:42:21',CMCreateUser:'����Ա',CMHospDesc:'������Ժ',CMPassFlag:'0',CMManLevDr:'forbid',CMIp:'111.19.40.96'},
			{RowID:'7',CMCreateDate:'2021-01-15',CMCreateTime:'01:42:21',CMCreateUser:'����Ա',CMHospDesc:'������Ժ',CMPassFlag:'0',CMManLevDr:'normal',CMIp:'111.19.40.96'},
			{RowID:'8',CMCreateDate:'2021-01-15',CMCreateTime:'01:42:21',CMCreateUser:'����Ա',CMHospDesc:'������Ժ',CMPassFlag:'0',CMManLevDr:'forbid',CMIp:'111.19.40.96'},
			{RowID:'9',CMCreateDate:'2021-01-15',CMCreateTime:'01:42:21',CMCreateUser:'����Ա',CMHospDesc:'������Ժ',CMPassFlag:'0',CMManLevDr:'forbid',CMIp:''}
			],
			total:10
		},
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers:true,
		fitColumns:true,
		idField:'RowID',
		singleSelect:false,
		pagination:true,
		pageSize:10,
		pageList:[10,20,40,100]
	})
}

//��ʼ����ť
function initBtn(){
	$("#searchBTN").click(function(){
		search();	
	});
}

//����ѯ
function search(){
	var stdate = $("#stdate").datebox("getValue");
	var eddate = $("#eddate").datebox("getValue");
	$('#datagrid').datagrid('load',{
		'stdate':stdate,
		'eddate':eddate,
	});
}

///���ò�����ϸ����
function queryDetail(value, rowData, rowIndex){
	var btn = "<img class='mytooltip' title='����' onclick=\"addProgressNote('"+rowData.RowID+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn;  	
}
///���ò�����ϸ����
function queryResult(value, rowData, rowIndex){
	var btn = "<img class='mytooltip' title='���' onclick=\"initView('"+rowData.RowID+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn;  	
}

function initView(RowID){

	var pdss = new PDSS({});
	var PdssObj = {};
	PdssObj.lmID=RowID;
	pdss.refresh(PdssObj, null, 1);  /// �������ӿ�
	if(pdss.passFlag == 0) {  
          
	    /// do something  
	    return;  
    }  

}

//���̼�¼����
function addProgressNote(RowID){
	commonShowWin({
		url:'dhcckb.examinecenter.csp', //'dhcckb.checkdetail.csp?RowID='+RowID,
		title:'����¼',
		height:600,
		width:1100
	})
}

/**
* ������������
* @author zhouxin
*/
function commonShowWin(option){
		
		var content = '<iframe src="'+option.url+'" scrolling="auto" width="100%" height="98%" frameborder="0" scrolling="no"></iframe>';
		var defOpt={
			iconCls:"icon-w-paper",
			width: 1110,
			height: 600,
			closed: false,
			content: content,
			modal: true
		}
		$.extend(defOpt,option);
		if (document.getElementById("CommonWin")){
			winObj = $("#CommonWin");
		}else{
			winObj = $('<div id="CommonWin"></div>').appendTo("body");	
		}
		$('#CommonWin').dialog(defOpt);
}

function commonCloseWin(){
	$('#CommonWin').dialog('close');
}
function commonParentCloseWin(){
	window.parent.$('#CommonWin').dialog('close');
}
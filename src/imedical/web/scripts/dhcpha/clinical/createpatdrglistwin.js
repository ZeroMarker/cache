///������ҩ�б���
function createPatDrgListWin()
{
	if($('#mwin').is(":visible")){return;} //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');
	
	$('#mwin').window({
		title:'������ҩ�б�',
		collapsible:true,
		border:false,
		closed:"true",
		width:1050,
		height:520,
		onClose:function(){
			$('#win').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
		}
	}); 

	$('#mwin').window('open');

	//����columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'incidesc',title:'����',width:250},
		{field:'genenic',title:'ͨ����',width:150},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'����',width:50},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'�÷�',width:70},
		{field:'instrudr',title:'instrudr',width:70,hidden:true},
		{field:'freq',title:'Ƶ��',width:60},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'�Ƴ�',width:50},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:'��׼�ĺ�',width:120},
		{field:'manf',title:'����',width:70},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'����',width:60},
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'spec',title:'���',width:80}
	]];
	
	//����datagrid
	$('#medInfo').datagrid({
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:"14976208"}
	});

}
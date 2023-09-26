// ����:ҽ������
// ��д����:2015-05-27
// ����:bianshuai

//�������ҽ��ID������ID���˳���Ӧ��Ϣ
var doctorID = getParam("Doctor");
var docLocID = getParam("docLocID");
//סԺ���ݲ���ADM
var EpisodeID=getParam("EpisodeID");
var monitorID=getParam("monitorID");
//���������С
window.resizeTo(1065,630); 

var url="dhcpha.clinical.action.csp";
$(function(){
	if (monitorID != ""){
		addPatRefusePanel(1,monitorID);
	}else{
		$.post(url,{action:"getPatRefuseList", "DoctorID":doctorID, "EpisodeID":EpisodeID},function(res){
			//var monArr=[2143,2142] //res.split("^");
			if (res==0){return;}
			var monArr=res.replace(/(^\s*)|(\s*$)/g,"").split("^");
		
			//$('div.panel-title').append('<span style="font-weight:bold;font-size:12pt;font-family:���Ŀ���;color:red;">[��ǰ������������<span style="font-size:16pt;padding:0px 5px 0px 5px;">'+monArr.length+'</span>]</span>');
		
			for(var i=0;i<monArr.length;i++){
				addPatRefusePanel(i+1,monArr[i]);
			}
		});
	}
	$('textarea').live("focus",function(){
		if(this.value=="�����뷴������..."){
			$(this).val("");
		}
	});
	
	$('textarea').live("blur",function(){
		if(this.value==""){
			$(this).val("�����뷴������...");
		}
	});
	
	$('a:contains("ά��ģ��")').live("click",function(){
		medAdvTemp();
	});
	
	$('a:contains("����ģ��")').live("click",function(){
		var MonitorID = this.id.split("_")[1];
		createSuggestWin(MonitorID);
		//$.messager.alert("��ʾ","����ģ�幦��,�ݲ���ʹ�ã�");
	});
	
	$('a:contains("����")').live("click",function(){
		var MonitorID = this.id.split("_")[1];
		Meth_Appeal(MonitorID);
	});
	
	$('a:contains("����")').live("click",function(){
		var MonitorID = this.id.split("_")[1];
		Meth_Agree(MonitorID);
	});
})

/// ����panel�б�
function addPatRefusePanel(i,monitorID)
{
	//var htmlstr = '<div id="rf_'+monitorID+'" class="btn-ui-div" style="border:2px solid #95B8E7;width:1000px;margin-left:auto;margin-right:auto;">';
	var htmlstr = '<div id="rf_'+monitorID+'" class="btn-ui-div" style="border:2px solid #95B8E7;width:1000px;margin-left:20px;">';
	////<!--������Ϣ-->
	var htmlstr = htmlstr + '<div>';
	var htmlstr = htmlstr + '	<div class="btn-ui-div">';
	var htmlstr = htmlstr + '		<span style="font-weight:bold;font-size:20px;">���к�:'+i+'</span>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '	<div class="btn-ui-div">';
	var htmlstr = htmlstr + '		<span style="font-weight:bold;font-size:13px;">1��������Ϣ</span>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '	<div class="btn-ui-div">';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">�ǼǺţ�<input name="patno" class="btn-ui-input" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">������<input name="patname" class="btn-ui-input" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">�Ա�<input name="patsex" class="btn-ui-input btn-ui-width1" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">�������ڣ�<input name="patdob" class="btn-ui-input" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">���䣺<input name="patage" class="btn-ui-input btn-ui-width1" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">���(cm)��<input name="height" class="btn-ui-input" readonly></input></span>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '	<div class="btn-ui-div">';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">����(kg)��<input name="weight" class="btn-ui-input" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">�������ڣ�<input name="admdate" class="btn-ui-input btn-ui-width2" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">������ң�<input name="admloc" class="btn-ui-input btn-ui-width2" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">ҽʦ��<input name="doctor" class="btn-ui-input" readonly></input></span>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '	<div class="btn-ui-div">';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">��ϣ�<input name="patdiag" class="btn-ui-input btn-ui-width3" readonly></input></span>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '	<div class="btn-ui-div">';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">����ʷ��<input name="allergy" class="btn-ui-input btn-ui-width3" readonly></input></span>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '</div>';
	////<!--������ҩ-->
	var htmlstr = htmlstr + '<div>';
	var htmlstr = htmlstr + '	<div class="btn-ui-div">';
	var htmlstr = htmlstr + '		<span style="font-weight:bold;font-size:13px;">2��ҽ���б�</span>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '	<div style="border-top:1px solid #95B8E7;border-bottom:1px solid #95B8E7;">';
	var htmlstr = htmlstr + '		<table id="dg'+monitorID+'"></table>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '</div>';
	////<!--����-->
	var htmlstr = htmlstr + '<div class="btn-ui-div">';
	var htmlstr = htmlstr + '	<div>';
	var htmlstr = htmlstr + '		<div><span style="font-weight:bold;font-size:13px;">3����ҩ���飺</span></div>';
	var htmlstr = htmlstr + '		<div id="medA_'+monitorID+'" style="margin-left:40px;margin-top:10px;font-size:20px;color:red;">һ�������˴���������������취�涨������һ��ȷ�ϻ����¿��ߴ������ܵ���ҩƷ��</div>';
	var htmlstr = htmlstr + '   </div>';
	var htmlstr = htmlstr + '</div>';
	////<!--button-->
	var htmlstr = htmlstr + '<div class="btn-ui-div">';
	var htmlstr = htmlstr + '	<span style="margin-left:512px;margin-top:10px;" class="btn-ui">';
	var htmlstr = htmlstr + '		<a href="#" class="yanshi defualt-bk1" id="btnq_'+monitorID+'">ά��ģ��</a>';
	var htmlstr = htmlstr + '		<a href="#" class="yanshi defualt-bk1" id="btnq_'+monitorID+'">����ģ��</a>';
	var htmlstr = htmlstr + '		<a href="#" class="yanshi defualt-bk1" id="btns_'+monitorID+'">����</a>';
	var htmlstr = htmlstr + '		<a href="#" class="yanshi defualt-bk1" id="btnr_'+monitorID+'">����</a>';
	var htmlstr = htmlstr + '	</span>';
	var htmlstr = htmlstr + '</div>';
	////<!--����-->
	var htmlstr = htmlstr + '<div class="btn-ui-div">';
	var htmlstr = htmlstr + '	<textarea id="textarea_'+monitorID+'" style="width:970px;height:85px;font-size:20px;margin-left:5px;border: 1px solid #95B8E7;">�����뷴������...</textarea>';
	var htmlstr = htmlstr + '</div>';

	$('#r_list').append(htmlstr);
	
	///����datagrid
	InitPageDataGrid(monitorID);
	
	///������Ϣ
	LoadPagePatRefuseInfo(monitorID);
}

///����ҳ�没�˾�����Ϣ
function LoadPagePatRefuseInfo(monitorID)
{
 	//��������
	$.post("dhcpha.clinical.action.csp",{action:"getRefPatAdmInfo", "monitorID":monitorID},function(data){
		var data = eval('('+data+')');
		$('#rf_'+monitorID+' div div .btn-ui-span input').each(function(){
			$(this).val(data[this.name]);
		})
	});
	
	//��ȡҽ����Ϣ
	$('#dg'+monitorID).datagrid({
		url:url+'?action=getMonitorDrgItm',
		queryParams:{
			monitorID:monitorID}
	})
	
	//��ȡ��ҩ����
	$.post("dhcpha.clinical.action.csp",{action:"getRefPatAdvise", "monitorID":monitorID},function(data){
		$('#medA_'+monitorID+'').text(data);
	});
}

///��ʼ��ҳ��dagagrid
function InitPageDataGrid(monitorID)
{
	//����columns
	var columns=[[
	    {field:'inciDesc',title:'ҩƷ����',width:220},
	    {field:'form',title:'����',width:80},
	    {field:'reasondesc',title:'�ܾ�����',width:100,formatter:SetCellColor},
	    {field:'instru',title:'��ҩ;��',width:80},
	    {field:'dosage',title:'����',width:60},
	    {field:'uomdesc',title:'��λ',width:40},
	    {field:'qty',title:'����',width:40},
	    {field:'freq',title:'Ƶ��',width:40},
	    {field:'prescno',title:'������',width:120},
	    {field:'doctor',title:'ҽ��',width:70},
	    {field:'ordtime',title:'ҽ��ʱ��',width:100}
	]];

	//����datagrid
	$('#dg'+monitorID).datagrid({
		//title:'2��ҽ���б�',    
		url:'',
		border:false,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
	    pageSize:8,
		pageList:[8,16],
		loadMsg: '���ڼ�����Ϣ...'//,
		//pagination:true
	});

	//InitdatagridRow(monitorID);
}

//��ʼ���б�ʹ��
function InitdatagridRow(monitorID)
{
	for(var k=0;k<5;k++)
	{
		$('#dg'+monitorID).datagrid('insertRow',{
			index: 0, // ������
			row: {
				orditm:'', phcdf:'', incidesc:'', genenic:''
			}
		});
	}
}

///����
function Meth_Agree(monitorID)
{
	$.post(url,{action:"AgreeRefDrg", "monitorID":monitorID},function(data){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal!="0"){
			$.messager.alert("��ʾ","����ʧ�ܣ�","info");
		}else{
			$('#rf_'+monitorID+'').remove();   ///ɾ�������ɹ�����Ŀ
		}
	});
}

///����
function Meth_Appeal(monitorID)
{
	var appReason = $('#textarea_'+monitorID+'').val();
	if (appReason=="�����뷴������..."){
		$.messager.alert("��ʾ","�����뷴�����ɺ�,���ԣ�");
		return;
	}
	$.post(url,{action:"AppealRefDrg", "monitorID":monitorID, "appReason":appReason},function(data){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal!="0"){
			$.messager.alert("��ʾ","����ʧ�ܣ�","info");
		}else{
			$.messager.alert("��ʾ","�����ɹ���");
			$('#rf_'+monitorID+'').remove();   ///ɾ�������ɹ�����Ŀ
		}
	});
}

// �������ô���
function createSuggestWin(MonitorID)
{
	if($('#medAdvWin').is(":visible")){return;} //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="medAdvWin"></div>');
	$('#medAdvWin').append('<div id="medAdvdg"></div>');
	
	$('#medAdvWin').window({
		title:'����ģ��',    
		collapsible:true,
		border:true,
		closed:"true",
		width:900,
		height:450,
		onClose:function(){
			$('#medAdvWin').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
		}
	});

	$('#medAdvWin').window('open');
	
	///����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:'Code',title:'����',width:100},
		{field:'Desc',title:'����',width:800},
	]];
	
	///����datagrid
	$('#medAdvdg').datagrid({  
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){
			var tmpDesc=rowData.Desc;
			if($('#textarea_'+MonitorID).val()=="�����뷴������..."){
				$('#textarea_'+MonitorID).val(tmpDesc);
			}else{
				$('#textarea_'+MonitorID).val($('#textarea_'+MonitorID).val()+","+tmpDesc);
			}
			$('#medAdvWin').window('close');
			$('#medAdvWin').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
		}
	});

	///�Զ����ؽ����ֵ�
	$('#medAdvdg').datagrid({
		url:url+'?action=QueryMedAdvTemp',
		queryParams:{
			params:LgCtLocID+"^"+LgUserID
		}
	});
}

/// ��ҩ����ģ��ά��
function medAdvTemp()
{
	if($('#medAdvTempWin').is(":visible")){return;} //���崦�ڴ�״̬,�˳�
	
	$('body').append('<div id="medAdvTempWin"></div>');
	$('#medAdvTempWin').window({
		title:'��ҩ����ģ��ά��',    
		collapsible:true,
		border:true,
		closed:"true",
		width:900,
		height:450,
		onClose:function(){
			$('#medAdvTempWin').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
		}
	});

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.medadvtemp.csp"></iframe>';
	$('#medAdvTempWin').html(iframe);
	$('#medAdvTempWin').window('open');
}

//formatter="SetCellColor" 
function SetCellColor(value, rowData, rowIndex)
{
	return '<span style="color:red">'+value+'</span>';
}
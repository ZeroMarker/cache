// ����:ҽ������
// ��д����:2015-05-27
// ����:bianshuai

//סԺ���ݲ���ADM
var EpisodeID=getParam("EpisodeID");
var medAdvID=getParam("medAdvID");
//���������С
window.resizeTo(1065,630); 

var url="dhcpha.clinical.action.csp";
$(function(){
	if (medAdvID != ""){
		addPatMedAdv(1,medAdvID);
	}else{
		$.post(url,{action:"jsonPatMedAdvList", "EpisodeID":EpisodeID},function(jsonString){
			var medAdvListObj = jQuery.parseJSON(jsonString);
			if(medAdvListObj.medAdvIDList==""){return;}
			var medAdvArr=medAdvListObj.medAdvIDList.split("||");
				
			for(var i=0;i<medAdvArr.length;i++){
				addPatMedAdv(i+1,medAdvArr[i]);
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
	
	/*$('button:contains("ά��ģ��")').live("click",function(){
		medAdvTemp();
	});
	
	$('button:contains("����ģ��")').live("click",function(){
		var medAdvID = this.id.split("_")[1];
		createSuggestWin(medAdvID);
		//$.messager.alert("��ʾ","����ģ�幦��,�ݲ���ʹ�ã�");
	});*/
	
	$('button:contains("����")').live("click",function(){
		var medAdvID = this.id.split("_")[1];
		Meth_Appeal(medAdvID);
	});
	
	$('button:contains("����")').live("click",function(){
		var medAdvID = this.id.split("_")[1];
		Meth_Agree(medAdvID);
	});
})

/// ����panel�б�
function addPatMedAdv(i,medAdvID)
{
	addPatMedAdvPanel(i,medAdvID)
	
	///����datagrid
	InitPageDataGrid(medAdvID);
	
	///������Ϣ
	LoadPagePatRefuseInfo(medAdvID);

}

///����ҳ�没�˾�����Ϣ
function LoadPagePatRefuseInfo(medAdvID)
{
 	//��������
	$.post("dhcpha.clinical.action.csp",{action:"jsonMedAdvPatAdmInfo", "medAdvID":medAdvID},function(data){
		var jsonObject = eval('('+data+')');
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.patsex == "��"){
				$("#PatPhoto").attr("src","../scripts/dhcpha/jQuery/themes/gray/images/boy.png");
			}else{
				$("#PatPhoto").attr("src","../scripts/dhcpha/jQuery/themes/gray/images/girl.png");
			}
		});
	})

	//��ȡҽ����Ϣ
	$('#dg'+medAdvID).datagrid({
		url:url+'?action=jsonMedAdvDrgItm',
		queryParams:{
			medAdvID:medAdvID}
	})

	//��ȡ��ҩ����
	$.post("dhcpha.clinical.action.csp",{action:"jsonPHMedAdvInDet", "medAdvID":medAdvID},function(jsonString){
		var medAdvListObj = jQuery.parseJSON(jsonString);
		var htmlstr = "";
		for(var i=0;i<medAdvListObj.length;i++){
			var htmlstr = htmlstr + '	<div class="btn-ui-div">';
				htmlstr = htmlstr + '		<span style="font-weight:bold;">'+medAdvListObj[i].medAdvuser+':</span><br><span style="border-bottom:1px solid #95B8E7;width:900px;margin-left:35px;">'+medAdvListObj[i].medAdvCon+'</span>';
				htmlstr = htmlstr + '	</div>';
		}
		$('#medA_'+medAdvID+'').html(htmlstr);
	});
}

function InitPageDataGrid(medAdvID)
{
	//����columns
	var columns=[[
		{field:'priorty',title:'���ȼ�',width:80},
	    {field:'inciDesc',title:'ҩƷ����',width:230},
	    {field:'form',title:'����',width:128},
	    {field:'instru',title:'��ҩ;��',width:80},
	    {field:'dosage',title:'����',width:72},
	    //{field:'uomdesc',title:'��λ',width:40},
	    //{field:'qty',title:'����',width:40},
	    {field:'freq',title:'Ƶ��',width:40},
	    {field:'duration',title:'�Ƴ�',width:40},
	    {field:'presc',title:'������',width:120},
	    {field:'doctor',title:'ҽ��',width:60},
	    {field:'ordtime',title:'ҽ��ʱ��',width:90}
	]];

	//����datagrid
	$('#dg'+medAdvID).datagrid({
		//title:'2��ҽ���б�',    
		url:'',
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...'//,
	});
}

///����
function Meth_Agree(medAdvID)
{
	var curStatus="30";  //ҽ��ͬ��Ϊ30
	$.post(url,{action:"agrPatMedAdv",medAdvID:medAdvID,curStatus:curStatus},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal=="0"){
			$.messager.alert("��ʾ","�����ɹ���");
			$('#rf_'+medAdvID+'').remove();   ///ɾ�������ɹ�����Ŀ
			if($.trim($('#r_list').html())==""){
				  window.close(); 
				}
		}else{
			$.messager.alert("��ʾ","����ʧ�ܣ�");
		}
	});
}

///����
function Meth_Appeal(medAdvID)
{
	var medAdvDetList = $('#textarea_'+medAdvID+'').val();
	if (medAdvDetList=="�����뷴������..."){
		$.messager.alert("��ʾ","�����뷴�����ɺ�,���ԣ�");
		return;
	}
	
	var curStatus="20";  //����״̬
	var medAdvMasList= LgUserID+"^"+curStatus+"^"+medAdvDetList.replace(/(^\s*)|(\s*$)/g,""); //ȥ����ʾ�ַ�
	$.post(url,{action:"SaveMedAdvDetail", "AdvID":medAdvID, "dataList":medAdvMasList},function(data){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal!="0"){
			$.messager.alert("��ʾ","����ʧ�ܣ�","info");
		}else{
			$.messager.alert("��ʾ","�����ɹ���");
			$('#rf_'+medAdvID+'').remove();   ///ɾ�������ɹ�����Ŀ
			if($.trim($('#r_list').html())==""){
				  window.close(); 
				}
		}
	});
}

// �������ô���
function createSuggestWin(medAdvID)
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
			if($('#textarea_'+medAdvID).val()=="�����뷴������..."){
				$('#textarea_'+medAdvID).val(tmpDesc);
			}else{
				$('#textarea_'+medAdvID).val($('#textarea_'+medAdvID).val()+","+tmpDesc);
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
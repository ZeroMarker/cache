///Creator:qqa
///CreatDate:2019-04-18

$(function(){
	
	initParams();  
	
	initPage();
	
	initTable();
})

function initParams(){
	CstID = getParam("ID");              /// ����ID
}

function initPage(){
	if(SingnIn!=1){
		$('#mainLayout').layout('hidden','north');	
	}	
}

function initTable(){
	/// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
    ///  ����columns
	var columns=[[
		{field:'PrvTpID',title:'ְ��ID',width:100,hidden:true},
		{field:'PrvTp',title:'ְ��',width:100,hidden:true},
		{field:'HosID',title:'HosID',width:100,hidden:true},
		{field:'HosType',title:'Ժ��Ժ��',width:110},
		{field:'LocID',title:'����ID',width:100,hidden:true},
		{field:'LocDesc',title:'����',width:100},
		{field:'MarID',title:'��רҵID',width:100,hidden:true},
		{field:'MarDesc',title:'��רҵ',width:100,hidden:true},
		{field:'UserID',title:'ҽ��ID',width:110,hidden:true},
		{field:'UserName',title:'ҽ��',width:120},
		{field:'UserPas',title:'����',width:100,formatter:setInput},
		{field:'Op',title:"����",width:100,align:'center',formatter:setConIn}
	]];
  
	$HUI.datagrid('#docListTable',{
		url: $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID,
		fit:true,
		border:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		headerCls:"panel-header-gray",
		pageSize:60,  
		pageList:[60], 
		loadMsg: '���ڼ�����Ϣ...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:'', 
		iconCls:'icon-paper',
		headerCls:'panel-header-gray', //ed
		queryParams:{
			
		},
		onDblClickRow:function(index,row){
			
		},
		onLoadSuccess:function(data){
			showQRCodeConIn(data.rows);
		}
    })			
}

function showQRCodeConIn(datas){
	$("#QRCodeConInDiv").html("");

	for(i in datas){
		addQRCode(datas[i].UserName);
	}
	return;
}

function addQRCode(name){
	if(name=="") return;
	var html="";
	html+='<div class="imgDivItm">';
	html+=	'<div class="imgItm">';
	html+=		'<img class="imgView" style="width:150px;height:150px" src="../scripts/dhcnewpro/images/Nurse_implementPrint.png"/>';
	html+=	'</div>';
	html+=	'<div class="imgDocName">'+name+'</div>';
	html+='</div>';
	$("#QRCodeConInDiv").append(html);
	return;
}

/// ����
function setInput(value, rowData, rowIndex){
	var isConssignIn = rowData.IsConssignIn;
	var html = "";
	if(isConssignIn!=1){
		html = "<input type='password' index="+rowIndex+" class='hisui-validatebox validatebox-text' />";
	}else{
		html = "***"
	}
	return html;
}


function setConIn(value, rowData, rowIndex){
	var html = "";
	var cstItmID = rowData.itmID;  //���UserID��CareProvID
	var isConssignIn = rowData.IsConssignIn;
	if(isConssignIn!=1){
		 html = "<a href='javascript:void(0)' onclick='conssignIn(\""+cstItmID+"\","+rowIndex+")'>ǩ��</a>";
	}else{
		html = "��"
	}
	return html;
}

function conssignIn(cstItmID,rowIndex){
	var password = $("input[index="+rowIndex+"]").val();
	if(password==""){
		$.messager.alert("��ʾ","���벻��Ϊ��!");
		return;	
	}
	runClassMethod("web.DHCMDTConssignIn","UserConssignIn",{"CstItmID":cstItmID,"Password":password},function(ret){
		if(ret==0) {
			$.messager.alert("��ʾ","ǩ���ɹ���");
			$HUI.datagrid('#docListTable').load({
				ID:CstID
			})
			return;	
		}
		if(ret!=0){
			if(ret==-1){
				$.messager.alert("��ʾ","���벻��ȷ!");
			}else if(ret==-2){
				$.messager.alert("��ʾ","û��ҽ����Ϣ���޷�ǩ����");
			}else if(ret==-3){
				$.messager.alert("��ʾ","�����ʽ����");
			}else if(ret==-99){
				$.messager.alert("��ʾ","�Ƿ���״̬������ǩ����");
			}else{
				$.messager.alert("��ʾ","������־����");
			}
			
			return;	
		}
	},'text')
}


function signIn(){

	$HUI.window("#signInWin").open();
}
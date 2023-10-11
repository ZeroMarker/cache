
//����	DHCPETeamCopy.hisui.js
//����	���Ʒ���
//����	2020.12.22
//������  xy

$(function(){

	InitCombobox();
	
	InitCopyTeamDataGrid();
	
	InitCopyTeamItemDataGrid();
		
	//��ѯ
	$("#BFind").click(function() {	
		BFind_Click();		
        });
        
        
       //����
	$("#BCopyTeam").click(function() {	
		BModifyRoom_Click();		
        });

	
})

function BFind_Click(){
	var LocID=session['LOGON.CTLOCID'];
	var iGBID=$("#GBDesc").combogrid('getValue');
	if (($("#GBDesc").combogrid('getValue')==undefined)||($("#GBDesc").combogrid('getValue')=="")){var iGBID="";} 
	
	$("#CopyTeamGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreGTeam",
			QueryName:"GetGTeamTempSet",
			GBID:iGBID,
			LocID:LocID
			})
	 
}

function BModifyRoom_Click(){
	
	if (ToGID==""){
		$.messager.alert("��ʾ","���Ƶ�������IDΪ��","info");
		return false;
	}
	
	var selectrow = $("#CopyTeamGrid").datagrid("getChecked");//��ȡ�������飬��������
	if(selectrow.length=="0"){
		$.messager.alert("��ʾ","δѡ������Ƶķ���","info");
		return false;
	}
	var j=0
	for(var i=0;i<selectrow.length;i++){
		var TeamID=selectrow[i].TTeamID;
		if (TeamID=="") continue
		var ret=tkMakeServerCall("web.DHCPE.PreGTeam","CopyTeamData",TeamID,ToGID);
		j=j+1;
	}
	
	if(j==selectrow.length){
		$.messager.alert("��ʾ","�������","info");
		return false;
	}
	
}


function InitCopyTeamDataGrid(){
	var LocID=session['LOGON.CTLOCID'];
	$HUI.datagrid("#CopyTeamGrid",{
		url: $URL,
		fit : true,
		border : false,
		striped : false,//�Ƿ���ʾ������Ч��
		fitColumns : false,
		autoRowHeight : false,
		rownumbers : true, //���Ϊtrue, ����ʾһ���к��� 
		pagination : true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������ 
		pageSize: 10,
		pageList : [10,20,30],
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		
		queryParams:{
			ClassName:"web.DHCPE.PreGTeam",
			QueryName:"GetGTeamTempSet",
			LocID:LocID
			
		},
	
		columns:[[
			{title: 'ѡ��',field: 'Select',width: 60,checkbox:true},
			{field:'TID',title:'ID',hidden:true},
			{field:'TTeamID',title:'TeamID',hidden:true},
			{field:'GDesc',width:'120',title:'��������'},
			{field:'GTeamDesc',width:'100',title:'��������'},
			{field:'TAgeRange',width:'70',title:'���䷶Χ'},
			{field:'TTeamSex',width:'40',title:'�Ա�'},
			{field:'TMarried',width:'70',title:'����״��'},
			{field:'TAmt',width:'80',title:'���',align:'right'}
	
		]],
		onSelect: function (rowIndex, rowData) {
			  
				loadCopyTeamItem(rowData);			
					
		},
		onUnselect:function (rowIndex, rowData) {
			  
				loadCopyTeamItem(""); 
					
		}

		
	})
}

function loadCopyTeamItem(rowData)
{
	$('#CopyTeamItemGrid').datagrid('load', {
			ClassName:"web.DHCPE.Query.PreItemList",
			QueryName:"QueryPreItemList", 
		    AdmType:"TEAM",
			AdmId:rowData.TTeamID,
			PreOrAdd:"PRE"
		
	});
}
function InitCopyTeamItemDataGrid(){
	
	$HUI.datagrid("#CopyTeamItemGrid",{
		url: $URL,
		toolbar:[],//������toolbarΪ��ʱ,���ڱ�������ͷ�������",
		fit : true,
		border : false,
		striped : false,//�Ƿ���ʾ������Ч��
		fitColumns : false,
		autoRowHeight : false,
		rownumbers : true, //���Ϊtrue, ����ʾһ���к��� 
		pagination : true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������ 
		pageSize: 10,
		pageList : [10,20,30],
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		queryParams:{
			ClassName:"web.DHCPE.Query.PreItemList",
			QueryName:"QueryPreItemList"	
			
		},
		columns:[[
			{field:'OrderEntId',title:'OrderEntId',hidden:true},
			{field:'ItemDesc',width:'100',title:'��Ŀ����'},
			{field:'ItemSetDesc',width:'90',title:'�ײ�'},
			{field:'TAccountAmount',width:'90',title:'Ӧ�ս��',align:'right'},
			{field:'TFactAmount',width:'90',title:'�Żݽ��',align:'right'},
			{field:'TRecLocDesc',width:'90',title:'���տ���'}	
		
		]]	
	
	})
}


function InitCombobox(){
	
	//����
	var GBDescObj = $HUI.combogrid("#GBDesc",{
		panelWidth:430,
		url:$URL+"?ClassName=web.DHCPE.PreGBaseInfo&QueryName=SearchGListByDesc",
		mode: 'remote',  
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'GBI_RowId',
		textField:'GBI_Desc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},
		onShowPanel:function()
		{
			$('#Name').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'GBI_RowId',title:'ID',width:50},
			{field:'GBI_Desc',title:'����',width:250},
			{field:'GBI_Code',title:'����',width:100}
					
		]]
		});
}

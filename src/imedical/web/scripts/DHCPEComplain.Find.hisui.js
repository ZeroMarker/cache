//����	DHCPEComplain.Find.hisui.js
//����	���Ͷ�߹���	
//����	2023.02.06
//������  ln

$(function(){
	 
	//�����б��
	InitCombobox();
	
	//��ʼ���б�
	InitComplainGrid();
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
     });
    
	//����
	$("#BClear").click(function() {	
		BClear_click();		
     });
     
    //����
    $("#BNew").click(function() {	
		BNew_click();		
     });
     
     //�޸�
    $("#BUpdate").click(function() {	
		BUpdate_click();		
     });
     
     //����
    $("#BProposal").click(function() {	
		BProposal_click();		
     });
     
     //Ĭ������Ϊ"Ͷ��"
	$("#Type").combobox('setValue', "C");
})


//����
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$("#Type").combobox('setValue',"C");
	BFind_click();
}

//��ѯ
function BFind_click(){
	
	var BeginDate="",EndDate="",Type="C";
	
	var CTLocID=session['LOGON.CTLOCID'];
	
	var BeginDate=$("#BeginDate").datebox('getValue');
    var EndDate = $("#EndDate").datebox('getValue');
	
	var Type=$("#Type").combobox('getValue');
	var ProStatus=$('input[name="ProStatus"]:checked').val();
		
	$("#ComplainGrid").datagrid('load',{
		ClassName:"web.DHCPE.Complain",
		QueryName:"FindComplainRecord",
		BDate:BeginDate,
		EDate:EndDate,
		Type:Type,
		ProStatus:ProStatus,
		Loc:CTLocID

	});
	
}
var HISUIStyleCode=tkMakeServerCall("websys.StandardTypeItem","GetIdFromCodeOrDescription","websys","HISUIDefVersion");
if(HISUIStyleCode=="blue"){ var Width=555;}
else {var Width=525;}
//����
function BNew_click()
{	
	$HUI.window("#ComplainEditWin", {
         title: "���Ͷ��ά��",
         iconCls: "icon-w-copy",
         collapsible: false,
         minimizable: false,
         maximizable: false,
         closable: true,
         resizable: false,
         modal: true,
         width: Width,
         height: 625,
         content: '<iframe src="dhcpecomplain.edit.hisui.csp?" width="100%" height="99%" frameborder="0"></iframe>'
     });
}

//�޸�
function BUpdate_click(){
	var RowId=$("#RowId").val();
	if (RowId=="") {
		 $.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
		return false;
	}
	
	$HUI.window("#ComplainEditWin", {
         title: "���Ͷ���޸�",
         iconCls: "icon-w-copy",
         collapsible: false,
         minimizable: false,
         maximizable: false,
         closable: true,
         resizable: false,
         modal: true,
         width: 555,
         height: 625,
         content: '<iframe src="dhcpecomplain.edit.hisui.csp?RowId='+RowId+'" width="100%" height="99%" frameborder="0"></iframe>'
     });
	
}

//����
function BProposal_click(){
	var RowId=$("#RowId").val();
	if (RowId=="") {
		 $.messager.alert("��ʾ","��ѡ�������ļ�¼","info");
		return false;
	}
	
	$HUI.window("#CompdisposeWin", {
         title: "���Ͷ�ߴ���",
         iconCls: "icon-w-copy",
         collapsible: false,
         minimizable: false,
         maximizable: false,
         closable: true,
         resizable: false,
         modal: true,
         width: 695,
         height: 310,
         content: '<iframe src="dhcpecompdispose.hisui.csp?RowId='+RowId+'" width="100%" height="99%" frameborder="0"></iframe>'
     });
	
}

function InitComplainGrid()
{

	$HUI.datagrid("#ComplainGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.Complain",
			QueryName:"FindComplainRecord",
			BDate:$("#BeginDate").datebox('getValue'),
			EDate:$("#EndDate").datebox('getValue'),
			Type:$("#Type").combobox('getValue'),
			ProStatus:"",
			Loc:session['LOGON.CTLOCID']
		},
        frozenColumns:[[
        	
			{field:'TCComplainUser',width:130,title:'Ͷ����'},
			{field:'TStatus',width:130,title:'״̬'}
				 
		]],
		columns:[[ 
			
		    {field:'TRowID',title:'TRowID',hidden: true},
			{field:'TTypeDesc',width:80,title:'����'},
			{field:'TCSource',width:100,title:'�¼���Դ'},
			{field:'TCComplainType',width:100,title:'Ͷ������'},
			{field:'TCComplainObject',width:140,title:'Ͷ�߶���'},
			{field:'TCComplainContent',width:100,title:'Ͷ������'},
			{field:'TCEventTime',width:180,title:'�¼�ʱ��'},
			{field:'TCComplainCause',width:100,title:'Ͷ��ԭ��'},
			{field:'TCDisProposal',width:100,title:'���ý���'},
			{field:'TCRemark',width:80,title:'��ע'}, 
			{field:'TCName',width:100,title:'��������'},
			{field:'TCRegNo',width:100,title:'�ǼǺ�'},
			{field:'TCIDCard',width:100,title:'���֤��'},
			{field:'TCRecord',title:'�����¼',hidden: true},
			{field:'TRecordDate',width:100,title:'����ʱ��'},
			{field:'TCClaimantName',width:100,title:'����������'},
			{field:'TCClaimantNo',width:100,title:'֤����'},
			{field:'TCRelation',width:100,title:'�뻼�߹�ϵ'},
			{field:'TCTel',width:100,title:'�ƶ��绰'},
			{field:'TCUpdateUser',width:100,title:'������'},
			{field:'TCUpdateDate',width:100,title:'��������'},
			{field:'TCUpdateTime',width:100,title:'����ʱ��'},
			{field:'TCLoc',hidden: true}
				
		]],
		onClickRow:function(rowIndex,rowData){
			
			setValueById("RowId",rowData.TRowID);
			selectrow=rowIndex;
	
		},
		onSelect: function (rowIndex, rowData) {	
		
		},
		onLoadSuccess: function(data) {
			
		},
			
	})
}

function InitCombobox()
{	
    //����	
	var TypeObj = $HUI.combobox("#Type",{
        valueField:'id',
        textField:'text',
        panelHeight:'70',
        data:[
           {id:'C',text:$g('Ͷ��')}  
        ]

    });
}
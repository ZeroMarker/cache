var cureRecordDataGrid;
$(function(){
	InitCureRecordDataGrid();
	
});
function Int()
{
	loadCureRecordDataGrid();		
}

function InitCureRecordDataGrid()
{
	// Toolbar
	var cureRecordToolBar = [{
		id:'BtnDetailView',
		text:'���', 
		iconCls:'icon-search',  
		handler:function(){
			var rows = cureRecordDataGrid.datagrid("getSelections");
			if (rows.length==0) 
			{
				$.messager.alert("��ʾ","��ѡ��һ�����Ƽ�¼���鿴");
				return;
			}else if (rows.length>1){
	     		$.messager.alert("����","��ѡ���˶�����Ƽ�¼����",'err')
	     		return;
    		}
    		var DCRRowId=""
			var rowIndex = cureRecordDataGrid.datagrid("getRowIndex", rows[0]);
			var selected=cureRecordDataGrid.datagrid('getRows'); 
			var DCRRowId=selected[rowIndex].Rowid;
			if(DCRRowId=="")
			{
				$.messager.alert('Warning','��ѡ��һ�����Ƽ�¼');
				return false;
			}
			OpenCureRecordDiag(DCRRowId);
		}
	}];
	// �������뵥ԤԼ��¼Grid
	cureRecordDataGrid=$('#tabCureRecordList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		url : "",
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"CureRecordId",
		pageList : [15,50,100,200],
		columns :[[   
        			{field:'Rowid',title:'',width:1,hidden:true}, 
        			{field:'DCRTitle',title:'����',width:300},  
        			{field:'CreateUser',title:'������',width:100},
        			{field:'CreateDate',title:'����ʱ��',width:100},
        			{field:'UpdateUser',title:'��������',width:100},
        			{field:'DDCRSLoc',title:'ԤԼ-����',width:100},
        			{field:'CTCareProv',title:'ԤԼ-��Դ',width:100},
        			{field:'DDCRSDate',title:'ԤԼ-����',width:100},
        			{field:'TimeRangeDesc',title:'ԤԼ-ʱ��',width:100},
        			{field:'ServiceGroupDesc',title:'ԤԼ-������',width:100},
        			{field:'DCAAStatus',title:'ԤԼ-״̬',width:100},
        			{field:'DCAARowId',title:'ԤԼ-ID',width:100}   
        			//,CTCareProv,DDCRSDate,TimeRangeDesc,ServiceGroupDesc,DCAAStatus 
    			 ]] ,
    	toolbar : cureRecordToolBar
	});
}
function loadCureRecordDataGrid()
{
	var DCARowId=$('#DCARowId').val();
	var DCAARowId=$('#DCAARowId').val();
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Record';
	queryParams.QueryName ='FindCureRecordList';
	queryParams.Arg1 =DCARowId;
	queryParams.ArgCnt =1;
	var opts = cureRecordDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp";
	cureRecordDataGrid.datagrid('load', queryParams);
	cureRecordDataGrid.datagrid('unselectAll');
}
function OpenCureRecordDiag(DCRRowId)
{
	var OperateType=$('#OperateType').val();
	var DCAARowId=$('#DCAARowId').val(); //ԤԼID
	if (DCAARowId==""){
		//�����ԤԼID������ ��ȡ���Ƽ�¼�ϵ�
		var rows = cureRecordDataGrid.datagrid("getSelections");
		if (rows.length==1){
	     	var rowIndex = cureRecordDataGrid.datagrid("getRowIndex", rows[0]);
			var selected=cureRecordDataGrid.datagrid('getRows'); 
			DCAARowId=selected[rowIndex].DCAARowId;
		}
	}
	var href="dhcdoc.cure.curerecord.csp?OperateType="+OperateType+"&DCRRowId="+DCRRowId+"&DCAARowId="+DCAARowId;
	//alert(DCRRowId);
	var ReturnValue=window.showModalDialog(href,"","dialogwidth:60em;dialogheight:30em;status:no;center:1;resizable:yes");
	/*
	var _content ="<iframe src='"+href+ "' scrolling='no' frameborder='0' style='width:100%;height:100%;'></iframe>"
	   $("#cureRecordDetailDiag").dialog({
        width: 800,
        height: 470,
        modal: true,
        content: _content,
        title: "���Ƽ�¼��",
        draggable: true,
        resizable: true,
        shadow: true,
        minimizable: false
    });
    */ 
}


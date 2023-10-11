var PageLogicObj={
	m_PilotProDocTabDataGrid:""
};
$(function(){
	//ҳ�����ݳ�ʼ��
	Init();
	//���ط������������
	PilotProDocTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_PilotProDocTabDataGrid=InitPilotProDocTabDataGrid();
}
function InitPilotProDocTabDataGrid(){
    /*RecordSum:%Integer,PPRowId,ProCode,ProDesc,ProCreateDepartmen,ProStartUser,ProBudget,ProState,CheckFreq,InRemNum,Balance,Account*/
	var Columns=[[ 
		{field:'PPRowId',hidden:true,title:''},
		{field:'ProCode',title:'��Ŀ���',width:100},
		{field:'ProDesc',title:'ҩ��/ҽ����е����',width:200},
		{field:'ProCreateDepartmen',title:'�������',width:200},
		{field:'ProStartUser',title:'��Ҫ�о���',width:100},
		{field:'InRemNum',title:'�����ܶ�',width:150,align:'right'},
		//{field:'ProState',title:'',hidden:true},
		{field:'CheckFreq',title:'�������Ƶ��',width:100},
		{field:'Balance',title:'�˻����',width:150,align:'right'},
		{field:'Account',title:'�˻�',width:100},
		{field:'ProCreateDate',title:'��������',width:100},
		{field:'ProState',title:'��Ŀ״̬',width:170,align:'right'}
    ]]
    var toobar=[];
	var PilotProDocTabDataGrid=$("#PilotProDocTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		nowrap:false,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'PPRowId',
		toolbar:toobar,
		columns :Columns
	}); 
	return PilotProDocTabDataGrid;
}
function PilotProDocTabDataGridLoad(){
	$.q({
	    ClassName : "web.PilotProject.DHCDocPilotProject",
	    QueryName : "FindProjectDoc",
	    PPDesc:"",
	    InHosp:session['LOGON.HOSPID'],
	    Pagerows:PageLogicObj.m_PilotProDocTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_PilotProDocTabDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function pagerFilter(data){
	if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
		data = {
			total: data.length,
			rows: data
		}
	}
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	pager.pagination({
		showRefresh:false,
		onSelectPage:function(pageNum, pageSize){
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh',{
				pageNumber:pageNum,
				pageSize:pageSize
			});
			dg.datagrid('loadData',data);
			dg.datagrid('scrollTo',0); //������ָ������        
		}
	});
	if (!data.originalRows){
		data.originalRows = (data.rows);
	}
	var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
	if ((start+1)>data.originalRows.length){
		//ȡ���������������ҳ��ʼֵ
		start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
		opts.pageNumber=opts.pageNumber-1;
	}
	var end = start + parseInt(opts.pageSize);
	data.rows = (data.originalRows.slice(start, end));
	return data;
}
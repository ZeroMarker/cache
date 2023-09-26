
/*
*/

$(function(){
	InitWardList();
	InitPatNoList();
	InitOrdItmdgList();
	InitStatusDg();
	InitCurLabel();

});



//��ʼ�������б�
function InitWardList()
{
	//����columns
	var columns=[[
		{field:"WardID",title:'WardID',hidden:true},
		{field:'WardDesc',title:'����',width:180},
		{field:'Sum',title:'����',width:50}
	]];
	
	//����datagrid
	$('#warddg').datagrid({
		 width:'100%',
	    height:'100%',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		//pageSize:100,  // ÿҳ��ʾ�ļ�¼����
		//pageList:[100],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow:function(rowIndex,rowData){
		   //var wardId=rowData.WardID;
		   //var wardDesc=rowData.WardDesc
		   //var inputs=wardId+","+wardDesc
		   //QueryDetail(rowIndex,rowData);
	   }


	});
    initScroll("#warddg");
}



function InitPatNoList()
{
	
	//����columns
	var columnspat=[[
	    {field:'RegNo',title:'�ǼǺ�',width:60},
		{field:'Adm',title:'adm',width:60},
		{field:'AdmDate',title:'��������',width:100},
		{field:'AdmTime',title:'����ʱ��',width:100},
		{field:'AdmLoc',title:'�������',width:100},
		{field:'CurrWard',title:'����',width:100},
		{field:'CurrWardID',title:'����ID',width:100},
		{field:'Currbed',title:'����',width:100},
		{field:'Currdoc',title:'ҽ��',width:100}
		
	]];
	
	//����datagrid
	$('#admdg').datagrid({
		url:'',
		toolbar:'#patnodgBar',
		fit:true,
		rownumbers:true,
		columns:columnspat,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80,120,160],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow:function(rowIndex,rowData){
		   //var pointer=rowData.CurrWardID;
		  // QuerySubDb(inputs);
		  //var AdmId=rowData.Adm;
		  //QueryResult(pointer,AdmId)
		   }
	});

	initScroll("#admdg");
}



//��ʼ������б�
function InitOrdItmdgList()
{
	
	//����columns
	var columnspat=[[
		

		
		{field:'TbRegNo',title:'����',width:50},
		{field:"TbName",title:'����',width:50},
		{field:'TbBatNo',title:'����',width:50,
		  editor:{type:'validatebox',options:{required:'true'} }
		 },
		{field:'TbItmDesc',title:'��ҩ',width:180},
		{field:'TbItmDesc1',title:'��ý',width:180},
		{field:'TbQty',title:'Ƶ��',width:50},
		{field:'TbDosage',title:'����',width:50}
	]];
	                                                          
	//����datagrid
	$('#ordtimdg').datagrid({
		url:'',
		fit:true,
		singleSelect:true,
		toolbar:'#orditmgbbar',
		rownumbers:true,
		columns:columnspat,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80,120,160],   // ��������ÿҳ��¼�������б�
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow:function(rowIndex,rowData){
        }
	   
	
	});

    initScroll("#ordtimdg");
}

//��ǰƿǩ
function InitCurLabel()
{
	
	//����columns
	var columnspat=[[
		{field:'ward',title:'����',width:180},
	    {field:'drug',title:'����',width:60},
		{field:'freq',title:'��ǩ',width:60},
		{field:'dose1',title:'��ҩ',width:60},
		{field:'dose2',title:'�˶�',width:60},
		{field:'dose3',title:'����',width:60},
		{field:'dose4',title:'��Ʒ�˶�',width:60},
		{field:'dose5',title:'���',width:60},
		{field:'dose6',title:'ֹͣ',width:60},
		{field:'dose7',title:'ֹͣ�˶�',width:60}
		
	]];
	
	//����datagrid
	$('#statusdg').datagrid({
		url:'',
		toolbar:'#curlabeldgbar',
		fit:true,
		rownumbers:true,
		columns:columnspat,
		//pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		//pageList:[40,80,120,160],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:false,
	    onDblClickRow:function(rowIndex,rowData){
		   //var pointer=rowData.CurrWardID;
		  // QuerySubDb(inputs);
		  //var AdmId=rowData.Adm;
		  //QueryResult(pointer,AdmId)
		   }
	});

	initScroll("#statusdg");
}


//
function InitStatusDg()
{
	
	//����columns
	var columnsdrug=[[
		{field:'ward',title:'ҩƷ',width:180},
	    {field:'drug',title:'Ƶ��',width:60},
		{field:'freq',title:'����',width:60}
		
	]];
	
	//����datagrid
	$('#executedg').datagrid({
		url:'',
		toolbar:'#executedgbar',
		fit:true,
		rownumbers:true,
		columns:columnsdrug,
		//pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		//pageList:[40,80,120,160],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:false,
	    onDblClickRow:function(rowIndex,rowData){
		   //var pointer=rowData.CurrWardID;
		  // QuerySubDb(inputs);
		  //var AdmId=rowData.Adm;
		  //QueryResult(pointer,AdmId)
		   }
	});

	initScroll("#executedg");
}




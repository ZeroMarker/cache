$(function(){
	eprPatient.CTLocID = userLocID
	eprPatient.Type = "A"
	InitDataList();
	initcombox();	
	$('#Type').combobox('setValue',"A") 		
});

var eprPatient= new Object();
eprPatient.CTLocID = "";
eprPatient.StartDate = "";
eprPatient.EndDate = "";
eprPatient.Type = "";

function initcombox()
{
	$('#ctLocID').combobox
	({
		valueField:'ID',  
	    textField:'Name',
		url:'../web.eprajax.usercopypastepower.cls?Action=GetCTLocID&Type=E&LocId='+userLocID, 
		mode:'remote',
		onSelect: function(record){
			
	    },
	    onLoadSuccess:function(a,b){
		    $('#ctLocID').combobox('setValue',userLocID)
	    }
    });
    
     var Typebox = $HUI.combobox("#Type",{
			valueField:'id',
			textField:'text',
			multiple:false,
			rowStyle:'checkbox', 
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:true,
			data:[
				{id:'A',text:$g('��Ժ����')},{id:'D',text:$g('��Ժ����')}
			],
			onSelect: function(record){
				if (record.id=="A")
				{
					$('#StartDes').html($g('��Ժ��ʼ����'));
					$('#EndDes').html($g('��Ժ��������'));
				}else if (record.id=="D")
				{
					$('#StartDes').html($g('��Ժ��ʼ����'));
					$('#EndDes').html($g('��Ժ��������'));	
				}
	    	},
	    	
	});
}

function InitDataList()
{
	$('#patientListTable').datagrid({ 
			pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
			method: 'post',
            loadMsg: '������......',
			autoRowHeight: true,
			url:'../EPRservice.Quality.Ajax.AutoResultSummary.cls',
			queryParams: {
				CTLocID: eprPatient.CTLocID,
				StartDate:eprPatient.StartDate,
				EndDate: eprPatient.EndDate,
				Type:eprPatient.Type,
            },
			fit:true,
			columns:[[
				{field: 'ckb',title:'��ѡ��', checkbox: true },
				{field:'Name',title:'����',width:100,align:'left',
					styler: function(value,row,index){
							if(HISUIStyleCode=="lite"){
									return 'border-left:1px solid #cccccc;border-right:1px solid #cccccc';
								}							
						}
				},
				{field:'RegNo',title:'�ǼǺ�',width:100,align:'left'},
				{field:'MRNo',title:'������',width:150,align:'left'},
				{field:'LocDesc',title:'����',width:150,align:'left'},
				{field:'DoctorDesc',title:'����ҽ��',width:100,align:'left'},
				{field:'Score',title:'����',width:150,align:'left'},
				{field:'AdmitDate',title:'��Ժ����',width:150,align:'left'},
				{field:'DischDate',title:'��Ժ����',width:150,align:'left'},
				{field:'EntryTitle',title:'�ʿ���Ŀ',width:450,align:'left'},	
			]],
			onLoadSuccess: function(data){   
			var mark=1;     
			for(var i=1; i <data.rows.length; i++)  { 
			if (data.rows[i]['Name'] == data.rows[i-1]['Name'])
				{
	����������������mark += 1;                                            
	����������������$(this).datagrid('mergeCells',{
	��������������������index: i+1-mark,                 
	��������������������field: 'Name',                 
	��������������������rowspan:mark  
					})
	������������}else{
	����������������mark=1;                               
	������������}
		��������}
		����},
		 	onDblClickRow: function(rowIndex, rowData) {
				var episodeID = rowData.AEpisodeID
				var url = "emr.interface.ip.main.csp?&EpisodeID="+episodeID;
				if('undefined' != typeof websys_getMWToken)
				{
					url += "&MWToken="+websys_getMWToken()
				}
				window.open (url,'newwindow','top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no,channelmode=yes ') 
				
			},
			loadFilter:function(data)
			{
				if(typeof data.length == 'number' && typeof data.splice == 'function'){
					data={total: data.length,rows: data}
				}
				var dg=$(this);
				var opts=dg.datagrid('options');
				var pager=dg.datagrid('getPager');
				pager.pagination({
					onSelectPage:function(pageNum, pageSize){
						opts.pageNumber=pageNum;
						opts.pageSize=pageSize;
						pager.pagination('refresh',{pageNumber:pageNum,pageSize:pageSize});
						dg.datagrid('loadData',data);
					}
				});
				if(!data.originalRows){
					data.originalRows = (data.rows);
				}
				var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
				var end = start + parseInt(opts.pageSize);
				data.rows = (data.originalRows.slice(start, end));
				return data;
			}
			}); 	
}

function doSearch()
{
	var queryParams = $('#patientListTable').datagrid('options').queryParams;
     queryParams.StartDate = $("#inputCreateDateStart").datetimebox('getText');
     queryParams.EndDate =$("#inputCreateDateEnd").datetimebox('getText');
	 queryParams.CTLocID =$("#ctLocID").combobox('getValue')
	 queryParams.Type=""+$("#Type").combobox('getValues')+""
	 if (queryParams.Type=="")
	 {
		$.messager.alert("��ʾ","�������ͱ�ѡ��"); 
		return
	 }
	 if ((queryParams.Type=="D")&&(queryParams.StartDate==""))
	 {
		$.messager.alert("��ʾ","��Ժ���߱���ѡ���Ժʱ��Σ�"); 
		return
	 }
	 
     $('#patientListTable').datagrid('options').queryParams = queryParams;
     $('#patientListTable').datagrid('reload');			   	
}

function exportExcel(){
    var options = $('#patientListTable').datagrid('getPager').data("pagination").options; 
    var curr = options.pageNumber; 
    var total = options.total;
    var pager = $('#patientListTable').datagrid('getPager');
    var rows = []
    for (i=1;i<=((total/options.pageSize)+1);i++)
    {
	     pager.pagination('select',i);
         pager.pagination('refresh');
         var currows =  $('#patientListTable').datagrid('getRows');
         console.log(currows)
         if (currows.length==0)
         {
	         continue;
	     }
         for (var j in currows)
         {
	         rows.push(currows[j]);
	     }
	}
	 pager.pagination('select',curr);
     pager.pagination('refresh');
	$('#patientListTable').datagrid('toExcel',{
		filename:'������Ŀ��ϸ.xls',
		rows:rows
		});
	}

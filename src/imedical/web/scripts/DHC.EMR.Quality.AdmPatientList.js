$(function(){
	
	initcombox();
	InitAuthorityDataList();
});
var eprPatient= new Object();
eprPatient.admStatus = "";
eprPatient.startDate = "";
eprPatient.endDate = "";
eprPatient.medicareNo = "";
eprPatient.locID = "";
eprPatient.specialAdm = "";

//�����б��ʼ��
function InitAuthorityDataList()
{
	$('#patientListTable').datagrid({ 
			pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            //pagePosition: 'bottom',
			fitColumns: true,
			method: 'post',
            loadMsg: '������......',
			autoRowHeight: true,
			url:'../EPRservice.Quality.Ajax.patientInfoList.cls',
			queryParams: {
                StartDate: eprPatient.startDate,
				EndDate: eprPatient.endDate,
				MedicareNo: eprPatient.medicareNo,
				ALocID: eprPatient.locID,
				AdmStatus: eprPatient.admStatus,
				SpecialAdm: eprPatient.specialAdm
            },
			singleSelect:true,
			//idField:'rowID', 
			//rownumbers:true,
			fit:true,
			columns:[[
				{field:'ProblemFlag',title:'ʱЧȱ��',width:100,align:'center',
				formatter:function(value,row,index){  
   					if(row.ProblemFlag != 0 ){
         			return "<img height='15' src='../scripts/emr/image/icon/aging.png'/>";
     				}
 				}},
				{field:'MedicareNo',title:'������',width:100,align:'center'},
				{field:'PAPMIName',title:'��������',width:100,align:'center'},
				{field:'Age',title:'����',width:100,align:'center'},
				{field:'PAPMISex',title:'�Ա�',width:100,align:'center'},
				{field:'Illness',title:'����',width:100,align:'center'},
				{field:'TransLocFlag',title:'ת�Ʊ�־',width:100,align:'center'},
				{field:'ResidentDays',title:'סԺ����',width:100,align:'center'},
				{field:'AdmDateTime',title:'��Ժʱ��',width:100,align:'center'},
				{field:'QualityFlag',title:'�����ʿ�',width:100,align:'center',
				formatter:function(value,row,index){  
   					if(row.QualityFlag == "Y" ){
         			return "<img height='15' src='../scripts/emr/image/icon/segment.png'/>";
     				}
 				}},
				{field:'CreateAdmUser',title:'�ʿ�ҽ��',width:100,align:'center'},
				{field:'MainDiagnos',title:'���',width:100,align:'center'},
				{field:'InPathWayStatus',title:'�ٴ�·��',width:100,align:'center'},
				{field:'PAAdmDocCodeDR',title:'����ҽ��',width:100,align:'center'},
				{field:'Attending',title:'����ҽ��',width:100,align:'center'},
				{field:'Chief',title:'����ҽ��',width:100,align:'center'},
				{field:'BedNo',title:'����',width:100,align:'center'}
			]],
		  rowStyler:function(rowIndex, rowData){   
       			if (rowData.ManualFlag!=""){   
           		return 'background-color:#FFDAB9;';   
       			}   
   			},
		  onDblClickRow: function(rowIndex, rowData) {
				var episodeID = rowData.EpisodeID
				var url = "dhc.emr.quality.checkrule.csp?EpisodeID="+episodeID+ '&action=A';
				window.open (url,'newwindow','top=0,left=0,width='+window.screen.width+',height='+window.screen.height+',toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no,channelmode=yes ')
				
			},
			onClickCell: function(rowIndex, field, value) {
			  var rows = $('#patientListTable').datagrid('getRows');
			  var row = rows[rowIndex];
			  var episodeID = row.EpisodeID;
			  if(field =='ProblemFlag'){
				  createModalDialog("QualityResultDialogA","�Զ��ʿ��б���Ժ","650","600","iframeQualityResultA","<iframe id='iframeQualityResultA' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualityresult.csp?EpisodeID=" + episodeID + "&ARuleID=2" +"' style='width:640px; height:550px; display:block;'></iframe>","","")
				//window.open("dhc.emr.quality.qualityresult.csp?EpisodeID=" + episodeID+ "&RuleID=" + 2); 
			  }
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
function buildImg(value,row,index){  
   if(row.ProblemFlag != 0 ){
         return "<img height='15' src='../scripts/emr/image/icon/aging.png'/>";
     }
 }

//���ҳ�ʼ��
function initcombox()
{
	$('#ctLocID').combobox
	({
		valueField:'ID',  
	    textField:'Name',
		url:'../web.eprajax.usercopypastepower.cls?Action=GetCTLocID&Type=E',
		mode:'remote',
		onChange: function (n,o) {
			$('#ctLocID').combobox('setValue',n);
		    var newText = $('#ctLocID').combobox('getText');
			$('#ctLocID').combobox('reload','../web.eprajax.usercopypastepower.cls?Action=GetCTLocID&Type=E&Filter='+encodeURI(newText.toUpperCase()));
		},
		onSelect: function(record){
			
	    } 
    });
}
///��ʼ���ص㻼��������ѡ��
$(function(){
	var cbox = $HUI.combobox("#specialAdm",{
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'OverAdm',text:'סԺ����31�컼��'},
			{id:'TerminallyIll',text:'��Σ����'},
			{id:'DiseaseSeve',text:'���ػ���'}
		]
		
		
	})
});

//��ѯ��ť�¼�
function doSearch() {
	//alert(specialAdm);
     var queryParams = $('#patientListTable').datagrid('options').queryParams;
     queryParams.StartDate = $("#inputCreateDateStart").datetimebox('getText');;
     queryParams.EndDate = $("#inputCreateDateEnd").datetimebox('getText');;
     queryParams.MedicareNo = $("#mrNo").val();
	 queryParams.ALocID = $("#ctLocID").combobox('getValue');
	 queryParams.AdmStatus = "A";
     queryParams.SpecialAdm = $("#specialAdm").combobox('getValues').join(); 
     if ((queryParams.ALocID=="")&&(queryParams.MedicareNo==""))
     {
	     $.messager.alert("��ʾ","�����������Ϊ��ѯ������","info");
	     //alert("�����������Ϊ��ѯ������");
	     return ;
	 }
     $('#patientListTable').datagrid('options').queryParams = queryParams;
     $('#patientListTable').datagrid('reload');			   
    
}
//����ճ����ť�¼�
function doCopy()
{
	var url = "dhc.emr.quality.usercopypastepower.csp"
	window.open(url,'newwindow','top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no,channelmode=yes'); 
}

function patientListTableReload()
{
	//alert("abc");
	$('#patientListTable').datagrid("reload")
}




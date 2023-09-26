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

//病人列表初始化
function InitAuthorityDataList()
{
	$('#patientListTable').datagrid({ 
			pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            //pagePosition: 'bottom',
			fitColumns: true,
			method: 'post',
            loadMsg: '加载中......',
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
				{field:'ProblemFlag',title:'时效缺陷',width:100,align:'center',
				formatter:function(value,row,index){  
   					if(row.ProblemFlag != 0 ){
         			return "<img height='15' src='../scripts/emr/image/icon/aging.png'/>";
     				}
 				}},
				{field:'MedicareNo',title:'病案号',width:100,align:'center'},
				{field:'PAPMIName',title:'病人姓名',width:100,align:'center'},
				{field:'Age',title:'年龄',width:100,align:'center'},
				{field:'PAPMISex',title:'性别',width:100,align:'center'},
				{field:'Illness',title:'病情',width:100,align:'center'},
				{field:'TransLocFlag',title:'转科标志',width:100,align:'center'},
				{field:'ResidentDays',title:'住院天数',width:100,align:'center'},
				{field:'AdmDateTime',title:'入院时间',width:100,align:'center'},
				{field:'QualityFlag',title:'环节质控',width:100,align:'center',
				formatter:function(value,row,index){  
   					if(row.QualityFlag == "Y" ){
         			return "<img height='15' src='../scripts/emr/image/icon/segment.png'/>";
     				}
 				}},
				{field:'CreateAdmUser',title:'质控医生',width:100,align:'center'},
				{field:'MainDiagnos',title:'诊断',width:100,align:'center'},
				{field:'InPathWayStatus',title:'临床路径',width:100,align:'center'},
				{field:'PAAdmDocCodeDR',title:'经治医生',width:100,align:'center'},
				{field:'Attending',title:'主治医生',width:100,align:'center'},
				{field:'Chief',title:'主任医生',width:100,align:'center'},
				{field:'BedNo',title:'床号',width:100,align:'center'}
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
				  createModalDialog("QualityResultDialogA","自动质控列表在院","650","600","iframeQualityResultA","<iframe id='iframeQualityResultA' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualityresult.csp?EpisodeID=" + episodeID + "&ARuleID=2" +"' style='width:640px; height:550px; display:block;'></iframe>","","")
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

//科室初始化
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
///初始化重点患者下拉多选框
$(function(){
	var cbox = $HUI.combobox("#specialAdm",{
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'OverAdm',text:'住院超过31天患者'},
			{id:'TerminallyIll',text:'病危患者'},
			{id:'DiseaseSeve',text:'病重患者'}
		]
		
		
	})
});

//查询按钮事件
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
	     $.messager.alert("提示","请输入科室作为查询条件！","info");
	     //alert("请输入科室作为查询条件！");
	     return ;
	 }
     $('#patientListTable').datagrid('options').queryParams = queryParams;
     $('#patientListTable').datagrid('reload');			   
    
}
//复制粘贴按钮事件
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




  $(function(){
	
	initcombox();
	InitAuthorityDataList();
	if(HISUIStyleCode == 'lite'){
		$(".centerlite").css({"background-color":"#f5f5f5"})
	}
});
var eprPatient= new Object();
eprPatient.admStatus = "";
eprPatient.startDate = "";
eprPatient.endDate = "";
eprPatient.medicareNo = "";
eprPatient.regNo = "";
eprPatient.patName = "";
eprPatient.locID = "";
eprPatient.specialAdm = "";
eprPatient.Diagnos=""

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
				RegNo: eprPatient.regNo,
				PatName: eprPatient.patName,
				ALocID: eprPatient.locID,
				AdmStatus: eprPatient.admStatus,
				SpecialAdm: eprPatient.specialAdm,
				Diagnos:eprPatient.Diagnos
            },
			singleSelect:true,
			//idField:'rowID', 
			//rownumbers:true,
			fit:true,
			columns:[[
				{field:'ProblemFlag',title:'时效缺陷',width:100,align:'left',
				formatter:function(value,row,index){  
   					if(row.ProblemFlag != 0 ){
         			return "<img height='15' src='../scripts/emr/image/icon/aging.png'/>";
     				}
 				}},
				{field:'RegNo',title:'登记号',width:100,align:'left'},
				{field:'MedicareNo',title:'病案号',width:100,align:'left'},
				{field:'PAPMIName',title:'病人姓名',width:100,align:'left'},
				{field:'Age',title:'年龄',width:100,align:'left'},
				{field:'PAPMISex',title:'性别',width:100,align:'left'},
				{field:'Illness',title:'病情',width:100,align:'left'},
				{field:'TransLocFlag',title:'转科标志',width:100,align:'left'},
				{field:'ResidentDays',title:'住院天数',width:100,align:'left'},
				{field:'AdmDateTime',title:'入院时间',width:100,align:'left'},
				{field:'QualityFlag',title:'环节质控',width:100,align:'left',
				formatter:function(value,row,index){  
   					if(row.QualityFlag == "Y" ){
         			return "<img height='15' src='../scripts/emr/image/icon/segment.png'/>";
     				}
 				}},
				{field:'CreateAdmUser',title:'质控医生',width:100,align:'left'},
				{field:'QualityDT',title:'质控时间',width:150,align:'left'},
				{field:'MainDiagnos',title:'诊断',width:100,align:'left'},
				{field:'InPathWayStatus',title:'临床路径',width:100,align:'left'},
				{field:'PAAdmDocCodeDR',title:'经治医生',width:100,align:'left'},
				{field:'Attending',title:'主治医生',width:100,align:'left'},
				{field:'Chief',title:'主任医生',width:100,align:'left'},
				{field:'BedNo',title:'床号',width:100,align:'left'}
			]],
		  rowStyler:function(rowIndex, rowData){   
       			if (rowData.ManualFlag!=""){ 
       				if(HISUIStyleCode!=='lite'){
	       				return 'background-color:#FFF2E9;color:#FF793E'; 
	       			}else{
		       			return 'background-color:#FFFAE8;color:#FFA200';
		       		}        		  
       			}   
   			},
		  onDblClickRow: function(rowIndex, rowData) {
			  
				var episodeID = rowData.EpisodeID;
				
				if (QuaSetPage=="2")
				{
					var url = "dhc.emr.quality.checkrulewide.csp?EpisodeID="+episodeID+ '&action=A';
					
				}
				else
				{
					var url = "dhc.emr.quality.checkrule.csp?EpisodeID="+episodeID+ '&action=A';	
				}
				if('undefined' != typeof websys_getMWToken)
				{
					url += "&MWToken="+websys_getMWToken()
				}
				window.open (url,'newwindowQuality','top=-33,left=3,width='+ window.screen.width +',height='+ window.screen.height +',toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no,channelmode=yes ') 
				
			},
						onClickCell: function(rowIndex, field, value) {
			  var rows = $('#patientListTable').datagrid('getRows');
			  var row = rows[rowIndex];
			  var episodeID = row.EpisodeID;
			  if(field =='ProblemFlag')
			  {
				  if('undefined' != typeof websys_getMWToken)
				  {
				  	createModalDialog("QualityResultDialogA","自动质控列表在院","650","600","iframeQualityResultA","<iframe id='iframeQualityResultA' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualityresult.csp?EpisodeID=" + episodeID + "&ARuleID=2"+"&Action=GetQualityResult"+"&MWToken="+websys_getMWToken() +"' style='width:800px; height:550px; display:block;'></iframe>","","")
				  }
				  else
				  {
					  createModalDialog("QualityResultDialogA","自动质控列表在院","650","600","iframeQualityResultA","<iframe id='iframeQualityResultA' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualityresult.csp?EpisodeID=" + episodeID + "&ARuleID=2"+"&Action=GetQualityResult" +"' style='width:800px; height:550px; display:block;'></iframe>","","")
					  
				  }
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
		url:'../web.eprajax.usercopypastepower.cls?Action=GetCTLocID&Type=E&HospitalID='+HospitalID+'&LocId='+Locid,
		mode:'remote',
        value:Locid,data:[{id:Locid,text:UserLocDesc}],
		onChange: function (n,o) {
			$('#ctLocID').combobox('setValue',n);
		    var newText = $('#ctLocID').combobox('getText');
			$('#ctLocID').combobox('reload','../web.eprajax.usercopypastepower.cls?Action=GetCTLocID&Type=E&HospitalID='+HospitalID+'&Filter='+encodeURI(newText.toUpperCase())+'&LocId='+Locid);
		},
		onSelect: function(record){
			
	    } 
    });
}
$('#mrNo').bind('keypress', function(event) {
			if (event.keyCode == "13") {
				doSearch();
			}
		});
 $('#regNo').bind('keypress', function(event) {
			if (event.keyCode == "13") {
				setpatientNoLength();
			}
		});
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
			{id:'OverAdm',text:$g('住院超过31天患者')},
			{id:'TerminallyIll',text:$g('病危患者')},
			{id:'DiseaseSeve',text:$g('病重患者')},
			{id:'KSSPat',text:$g('抗生素使用患者')},
      		{id:'HZHZ',text:$g('会诊患者')},
			{id:'ZKHZ',text:$g('转科患者')},
			{id:'Salvage',text:$g('抢救患者')}
		]
		
		
	})
});
function setpatientNoLength(){
	var RegNo = $("#regNo").val();
	if (RegNo != '') {
		for (var i=(10-RegNo.length-1); i>=0; i--){
			RegNo ="0"+ RegNo;
		}
	}
	$("#regNo").val(RegNo);
	doSearch();
}
//导出excel
function makeExcel(){
    var options = $('#patientListTable').datagrid('getPager').data("pagination").options; 
    var curr = options.pageNumber; 
    var total = options.total;
    var pager = $('#patientListTable').datagrid('getPager');
    var rows = [] 
    var limit=(total/options.pageSize)
    if (Math.floor(limit)!=limit)
    {
	    var limit= limit+1
	  }
    for (i=1;i<=limit;i++)
    {
	     pager.pagination('select',i);
         pager.pagination('refresh');
         var currows =  $('#patientListTable').datagrid('getRows');
         if (currows.length==0)
         {
	         continue;
	     }
         for (var j in currows)
         {
	         rows.push(currows[j]);
	     }
         //rows.concat(currows);
	}
	 pager.pagination('select',curr);
     pager.pagination('refresh');
	$('#patientListTable').datagrid('toExcel',{
		filename:'patientListTable.xls',
		rows:rows
		});
	}
//查询按钮事件
function doSearch() {
	//alert(specialAdm);
     var queryParams = $('#patientListTable').datagrid('options').queryParams;
     queryParams.StartDate = $("#inputCreateDateStart").datetimebox('getText');;
     queryParams.EndDate = $("#inputCreateDateEnd").datetimebox('getText');;
     queryParams.MedicareNo = $("#mrNo").val();
     queryParams.RegNo = $("#regNo").val();
     queryParams.PatName = $("#patName").val();
	 queryParams.Diagnos = $("#Diagnos").val();
	 queryParams.ALocID = $("#ctLocID").combobox('getValue');
	 queryParams.AdmStatus = "A";
     queryParams.SpecialAdm = $("#specialAdm").combobox('getValues').join(); 
    if (SSGroupID==KSSGroup)
     {
	     queryParams.ALocID=Locid;
	     }
     //if ((queryParams.ALocID=="")&&(queryParams.MedicareNo==""))
     //{
	 //    $.messager.alert("提示","请输入科室作为查询条件！","info");
	     //alert("请输入科室作为查询条件！");
	 //    return ;
	 //}
     $('#patientListTable').datagrid('options').queryParams = queryParams;
     $('#patientListTable').datagrid('reload');			   
    
}

//重置查询条件  只重置科室
function doReset(){
	initcombox()	
}

//复制粘贴按钮事件
function doCopy()
{
	var url = "dhc.emr.quality.usercopypastepower.csp"
	//window.open(url,'newwindow','top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no,channelmode=yes'); 
	websys_showModal({
		iconCls:'icon-w-msg',
		url:url,
		title:$g('禁用权限设置'),
		width:1390,height:416
		});
}

function patientListTableReload()
{
	//alert("abc");
	$('#patientListTable').datagrid("reload")
}




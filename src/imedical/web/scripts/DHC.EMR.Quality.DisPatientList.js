$(function(){
	$("#DateTime").hide();
	$('#Forever').attr("checked",true);
	$('#seekform').find(':radio').change(function(){
		if (this.id == "Period"){
			$("#DateTime").show();
			//$("#stDateTime").datetimebox('setValue','${notices.release_time}');
		    }else{
			$("#DateTime").hide();
		}
	})
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
eprPatient.ischecked = "";
eprPatient.Diagnos="";

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
				ischecked: eprPatient.ischecked,
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
				{field:'MedicareNo',title:'病案号',width:100,align:'left'},
				{field:'PAPMIName',title:'病人姓名',width:100,align:'left',cellattr: addCellAttr},
				{field:'Age',title:'年龄',width:100,align:'left'},
				{field:'PAPMISex',title:'性别',width:100,align:'left'},
				{field:'Illness',title:'病情',width:100,align:'left',
				formatter:function(value){
	                return $g(value)
	            }
				},
				{field:'TransLocFlag',title:'转科标志',width:100,align:'left',
				formatter:function(value){
	                return $g(value)
	            }
				},
				{field:'ResidentDays',title:'住院天数',width:100,align:'left'},
				{field:'DisDate',title:'出院时间',width:100,align:'left'},
				{field:'AdmDateTime',title:'入院时间',width:100,align:'left'},
				{field:'QualityFlag',title:'环节质控',width:100,align:'left',
				formatter:function(value,row,index){  
   					if(row.QualityFlag == "Y" ){
         				return "<img height='15' src='../scripts/emr/image/icon/segment.png'/>";
     				}
 				}},
				{field:'CreateDisUser',title:'质控医生',width:100,align:'left'},
				{field:'MainDiagnos',title:'诊断',width:100,align:'left'},
				{field:'InPathWayStatus',title:'临床路径',width:100,align:'left'},
				{field:'PAAdmDocCodeDR',title:'经治医生',width:100,align:'left'},
				{field:'Attending',title:'主治医生',width:100,align:'left'},
				{field:'Chief',title:'主任医生',width:100,align:'left'},
				{field:'BedNo',title:'床号',width:100,align:'left'}
			]],
		  rowStyler:function(rowIndex, rowData){   
       			if (rowData.DisManualFlag=="Y"){ 
       				if(HISUIStyleCode!=='lite'){
	       				return 'background-color:#FFF2E9;color:#FF793E'; 
	       			}else{
		       			return 'background-color:#FFFAE8;color:#FFA200';
		       		}     
       			}   
   			},
		  onDblClickRow: function(rowIndex, rowData) {
			  //alert(rowData.EpisodeID);
				var episodeID = rowData.EpisodeID
				var patientName=rowData.PAPMIName
				var MedicareNo=rowData.MedicareNo
				var BedNo=rowData.BedNo
				var url = "dhc.emr.quality.discheckrule.csp?EpisodeID="+episodeID+ '&action=D'+'&patientName='+patientName+'&MedicareNo='+MedicareNo+'&BedNo='+BedNo;
				if('undefined' != typeof websys_getMWToken)
				{
					url += "&MWToken="+websys_getMWToken()
				}
				window.open (url,'newwindowQuality','top=0,left=0,width='+window.screen.width+',height='+window.screen.height+',toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no,channelmode=yes ') 
				
				
			},
		  onClickCell: function(rowIndex, field, value) {
			  var rows = $('#patientListTable').datagrid('getRows');
			  var row = rows[rowIndex];
			  var episodeID = row.EpisodeID;
			  if(field =='ProblemFlag')
			  {
				if('undefined' != typeof websys_getMWToken)
				{
				  createModalDialog("QualityResultDialogA","自动质控列表出院","650","600","iframeQualityResultA","<iframe id='iframeQualityResultA' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualityresult.csp?EpisodeID=" + episodeID + "&ARuleID=7"+"&MWToken="+websys_getMWToken() +"' style='width:640px; height:550px; display:block;'></iframe>","","")
				}
				else
				{
					createModalDialog("QualityResultDialogA","自动质控列表出院","650","600","iframeQualityResultA","<iframe id='iframeQualityResultA' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualityresult.csp?EpisodeID=" + episodeID + "&ARuleID=7" +"' style='width:640px; height:550px; display:block;'></iframe>","","")
				}
				//window.open("dhc.emr.quality.qualityresult.csp?EpisodeID=" + episodeID+ "&RuleID=" + 7); 
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
function addCellAttr(rowId, val, rawObject, cm, rdata) {
             if(rawObject.QualityFlag == "Y" ){
                 return "style='color:red'";
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
			{id:'OverAdm',text:emrTrans("住院超过31天患者")},
			{id:'TerminallyIll',text:emrTrans("病危患者")},
			{id:'DiseaseSeve',text:emrTrans("病重患者")},
			{id:'BloodFilter',text:emrTrans("输血患者")},
			{id:'Operate',text:emrTrans("手术患者")},
			{id:'KSSPat',text:emrTrans('抗生素使用患者')},
			{id:'HZHZ',text:emrTrans('会诊患者')},
			{id:'ZKHZ',text:emrTrans('转科患者')}
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
    for (i=1;i<=((total/options.pageSize)+1);i++)
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
	 queryParams.AdmStatus = "D";
     queryParams.SpecialAdm = $("#specialAdm").combobox('getValues').join(); 
	 queryParams.ischecked = $("input[name='Devaluated']:checked").val();
         if (SSGroupID==KSSGroup)
        {
	   queryParams.ALocID=Locid;
       }
     $('#patientListTable').datagrid('options').queryParams = queryParams;
     $('#patientListTable').datagrid('reload');			   
    
}

//重置查询条件  只重置科室
function doReset(){
	initcombox()	
}






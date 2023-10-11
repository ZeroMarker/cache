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
	});
	if(HISUIStyleCode == "lite"){
	    $(".div_center").css({'background-color':'#f5f5f5'});
	}
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
eprPatient.ischecked = "";
eprPatient.reclaim="";

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
				SpecialAdm: eprPatient.specialAdm,
				ischecked :eprPatient.ischecked,
				HospitalID:HospitalID,
				Reclaim: eprPatient.reclaim
            },
			singleSelect:true,
			//idField:'rowID', 
			//rownumbers:true,
			fit:true,
			columns:[[
                {field:'PAAdmDepCodeDR',title:'科室',width:100,align:'left'},
				{field:'MedicareNo',title:'病案号',width:100,align:'left'},
				{field:'PAPMIName',title:'病人姓名',width:100,align:'left',cellattr: addCellAttr},
				{field:'Age',title:'年龄',width:100,align:'left'},
				{field:'PAPMISex',title:'性别',width:100,align:'left'},
				{field:'Illness',title:'病情',width:100,align:'left'},
				{field:'TransLocFlag',title:'转科标志',width:100,align:'left'},
				{field:'ResidentDays',title:'住院天数',width:100,align:'left'},
				{field:'AdmDateTime',title:'入院时间',width:100,align:'left'},
				{field:'ProblemFlag',title:'质控缺陷',width:100,align:'left'},
				{field:'KSManualFlag',title:'科室质控',width:100,align:'left',
				formatter:function(value,row,index){  
   					if(row.KSManualFlag == "Y" ){
         			return "<a style='color:red'>"+$g('科室')+"</a>";
     				}
     				else if (row.KSManualFlag == "P" ){
         			return "<a style='color:green'>"+$g('科室')+"</a>";
     				}
     				else{
         			return "<a style='color:black'>"+$g('科室')+"</a>";
     				}
 				}},
 				//{field:'KSUser',title:'科室质控员',width:100,align:'left'},
				{field:'BSManualFlag',title:'病案室质控',width:100,align:'left',
				formatter:function(value,row,index){  
   					if(row.BSManualFlag == "Y" ){
         			return "<a style='color:red'>"+$g('病案室')+"</a>";
     				}
     				else if (row.BSManualFlag == "P" ){
         			return "<a style='color:green'>"+$g('病案室')+"</a>";
     				}
     				else{
         			return "<a style='color:black'>"+$g('病案室')+"</a>";
     				}
 				}},
				//{field:'BSUser',title:'病案室质控员',width:100,align:'left'},
				{field:'MainDiagnos',title:'诊断',width:100,align:'left'},
				{field:'InPathWayStatus',title:'临床路径',width:100,align:'left'},
				{field:'PAAdmDocCodeDR',title:'经治医生',width:100,align:'left'},
				{field:'BedNo',title:'床号',width:100,align:'left'}
			]],
		  /*rowStyler:function(rowIndex, rowData){   
       			if (rowData.DisManualFlag=="Y"){   
           		return 'background-color:#B9A8CE;';   
       			}   
   			},*/
		  onDblClickRow: function(rowIndex, rowData) {
			  //alert(rowData.EpisodeID);
				var episodeID = rowData.EpisodeID
				var url = "dhc.emr.quality.bsycheckrule.csp?EpisodeID="+episodeID+ '&action=BS';
				if('undefined'!=typeof websys_getMWToken)
				{
					url+="&MWToken="+websys_getMWToken()
				}
				window.open (url,'newwindow','top=0,left=0,width='+window.screen.width+',height='+window.screen.height+',toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no,channelmode=yes ') 
				
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
		url:'../web.eprajax.usercopypastepower.cls?Action=GetCTLocID&Type=E&HospitalID='+HospitalID,
		mode:'remote',
		onChange: function (n,o) {
			$('#ctLocID').combobox('setValue',n);
		    var newText = $('#ctLocID').combobox('getText');
			$('#ctLocID').combobox('reload','../web.eprajax.usercopypastepower.cls?Action=GetCTLocID&Type=E&HospitalID='+HospitalID+'&Filter='+encodeURI(newText.toUpperCase()));
		},
		onSelect: function(record){
			
	    } 
    });
}
///初始化重点患者下拉多选框
$(function(){
	var Typebox = $HUI.combobox("#ischecked",{
			valueField:'id',
			textField:'text',
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:false,
			data:[
				{id:'N',text:'未质控'},{id:'Y',text:'质控未通过'},{id:'P',text:'质控通过'}
			]
	});
  	
});
function doReclaim(){
	Reclaim="Y";
	doSearch();	
}

function doOutPat(){
	Reclaim = ""
	doSearch();
}



//查询按钮事件
function doSearch() {
	
	//alert(specialAdm);
     var queryParams = $('#patientListTable').datagrid('options').queryParams;
     queryParams.StartDate = $("#inputCreateDateStart").datetimebox('getText');;
     queryParams.EndDate = $("#inputCreateDateEnd").datetimebox('getText');;
     queryParams.MedicareNo = $("#mrNo").val();
	 queryParams.ALocID = $("#ctLocID").combobox('getValue');
	 queryParams.AdmStatus = "DBS";
	 queryParams.Reclaim = Reclaim;
	 queryParams.HospitalID=HospitalID;
     //queryParams.SpecialAdm = $("#specialAdm").combobox('getValues').join(); 
      queryParams.ischecked=""+$("#ischecked").combobox('getValues')+"";
     $('#patientListTable').datagrid('options').queryParams = queryParams;
     $('#patientListTable').datagrid('reload');			   
    
}







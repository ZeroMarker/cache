$(function(){
	InitAuthorityDataList();
	getUserQualityRange()
	//InitCheckedHistory();
	if (HISUIStyleCode=="lite"){
		$('.bg-div').css('background-color','#f5f5f5')
	}
});
/// 为是否质控的下拉框注册一个选择事件，重新选择条件重新查询
$("#QualityFlag").combobox({
	onSelect:function(d){
		doSearch()
	}
})

var crossAction="CQC"  //cross quality control  即交叉质控

function getUserQualityRange(){
	
	var res=$cm({
		ClassName:"EPRservice.Quality.DataAccess.MedDoctor",
		MethodName:"GetUserRange",
		dataType:'text',
		userId:userID
	},function(res){
		if(res==="非质控医师!"){
				$.messager.alert("提示:",res,"info")
			}else
			{
				range=res
				setRangeList(res)
				var rangeText=range.replace("IA",emrTrans("环节病历"))
				var rangeText=rangeText.replace(crossAction,emrTrans("终末病历"))
				var rangeText=rangeText.replace("AO",emrTrans("门诊病历"))
				
				$("#checkRange").text($("#checkRange").text()+rangeText)
				doSearch()
			}
		
	});
	
}
function setRangeList(str){
	var rangeList=[
		{
			value:"AO",
			option:emrTrans('门诊病历')
		},
		{
			value:"IA",
			option:emrTrans('环节病历')
		},
		{
			value:crossAction,
			option:emrTrans('终末病历')
		}
	]
	var selectIndex=0
	for(var i=0;i<rangeList.length;i++){
		if(str.indexOf(rangeList[i].value)==-1){
			rangeList[i].disabled=true  //禁用非权限范围内的病历
		}else{
			if(selectIndex!=1){
				rangeList[i].selected=true
				selectIndex=1	
			}
		}
	}
	$("#Range").combobox({
		valueField:'value',
		textField:'option',
		multiple:false,
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:rangeList,
		onSelect:function(){
			doSearch()
		}
	});
}
var range=""

var hideColumn=range==="IA" //门诊病历质控隐藏住院天数

var eprPatient= new Object();

eprPatient.userID=userID

eprPatient.QualityFlag = "";

eprPatient.Method = "";
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
			url:'../EPRservice.Quality.Ajax.Assign.cls',
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
				{field:'PAPMIName',title:'病人姓名',width:100,align:'left'},
				{field:'Age',title:'年龄',width:100,align:'left'},
				{field:'PAPMISex',title:'性别',width:100,align:'left'},
				{field:'Illness',title:'病情',width:100,align:'left'},
				{field:'TransLocFlag',title:'转科标志',width:100,align:'left'},
				{field:'ResidentDays',title:'住院天数',width:100,align:'left'},
				{field:'AdmDateTime',title:'入院时间',width:100,align:'left'},
				{field:'CreateOutUser',title:'质控医生',width:100,align:'left'},
				{field:'MainDiagnos',title:'诊断',width:100,align:'left'},
				{field:'PAAdmDocName',title:'经治医生',width:100,align:'left'},
				{field:'BedNo',title:'床号',width:100,align:'left'}
			]],
		  rowStyler:function(rowIndex, rowData){   
       			if (rowData.DisManualFlag=="Y"){   
           		return 'background-color:#B9A8CE;';   
       			}   
   			},
		  onDblClickRow: function(rowIndex, rowData) {
				var episodeID = rowData.EpisodeID
				var admType=$("#Range").combobox('getValue')
				
				///不同类型病历，设置双击链接进手工评分界面的URL参数
				var Params={
					AO:{
						url:"dhc.emr.quality.outcheckrule.csp?EpisodeID="+episodeID+ '&action=AO'	
					},
					CQC:{
						url:"dhc.emr.quality.discheckrule.csp?EpisodeID="+episodeID+ '&action=CQC'
					},
					IA:{
						url:"dhc.emr.quality.checkrule.csp?EpisodeID="+episodeID+ '&action=IA'
					}
				}
				var url=''
				if('undefined' != typeof websys_getMWToken)
				{
					Params[admType].url+= "&MWToken="+websys_getMWToken()
				}
				window.open (Params[admType].url+url,'newwindow','top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no,channelmode=yes ') 
				
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


//查询按钮事件
function doSearch() {
    var queryParams={}
	 queryParams.QualityFlag = $("#QualityFlag").combobox('getValue')
	 queryParams.method="GetAssignInfoByUserId"
	 queryParams.userID = userID
	 queryParams.range=$("#Range").combobox('getValue')
	 
    $('#patientListTable').datagrid('options').queryParams = queryParams;
    
    $('#patientListTable').datagrid('reload');			   
   
}

function patientListTableReload()
{
	//alert("abc");
	$('#patientListTable').datagrid("reload")
}

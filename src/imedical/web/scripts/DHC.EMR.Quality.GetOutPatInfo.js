$(function(){
	InitAuthorityDataList();
	InitSummaryHistory()
	InitCheckedHistory()
	doSearch()
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
/// 公共变量

var eprPatient= new Object();

eprPatient.userID=userID

eprPatient.QualityFlag = "";

eprPatient.Method = "";

var AssignedDate=""

var noSummaryFlag=0  //是否存在总结内容


///初始化工作
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
			url:'../EPRservice.Quality.Ajax.spotCheckPatInfoList.cls',
			queryParams: {
				userID: userID,
				QualityFlag:eprPatient.QualityFlag,
				Method:eprPatient.Method
            },
			singleSelect:true,
			//idField:'rowID', 
			//rownumbers:true,
			fit:true,
			columns:[[
				{field:'AssignName',title:'分配医生姓名',width:100,align:'left'},
				{field:'MedName',title:'主管医生',width:100,align:'left'},
				{field:'PAPMIName',title:'患者姓名',width:100,align:'left'},
				{field:'Age',title:'年龄',width:100,align:'left'},
				{field:'PAPMISex',title:'性别',width:100,align:'left'},
				{field:'MainDiagnos',title:'诊断',width:100,align:'left'},
				//{field:'FinishRecord',title:'书写病历',width:100,align:'left'},
				{field:'CheckedFlag',title:'是否质控',width:100,align:'left'}	
			]],
		  rowStyler:function(rowIndex, rowData){   
       			if (rowData.ManualFlag=="Y"){   
           		return 'background-color:#FFDAB9;';   
       			}   
   			},
		  onDblClickRow: function(rowIndex, rowData) {
				var episodeID = rowData.EpisodeID
				var url = "dhc.emr.quality.checkrule.csp?EpisodeID="+episodeID+ '&action=O';
				if('undefined' != typeof websys_getMWToken)
				{
					url += "&MWToken="+websys_getMWToken()
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
///初始化分配历史列表
function InitCheckedHistory()
{
	var checkDateList=GetAllDateGap()
	var selectInfo=[] //这个selectInfo用于在讨论界面的菜单按钮数据
	if(checkDateList==""||checkDateList==undefined)
	{
		selectInfo.push({id:0,text:'无历史数据'})
		
	}else
	{
		
		if(checkDateList.indexOf("/")==-1)
		{
			selectInfo.push({id:checkDateList,text:checkDateList,selected:true})
		}else
		{
			var dateArray=checkDateList.split("/")
		
			for(var i=0;i<dateArray.length;i++)
			{
				if(i==0)
				{
					selectInfo.push({id:dateArray[i],text:dateArray[i],selected:true})
				}else
				{
					selectInfo.push({id:dateArray[i],text:dateArray[i]})
				}
			}	
		}
	}
	
	AssignedDate=selectInfo
	
}

///初始化总结历史列表
function InitSummaryHistory()
{
	var SummaryList=GetAllSummaryDates()
	var listInfo=""
	if(SummaryList==""||SummaryList==undefined)
	{
		noSummaryFlag=1
		listInfo=listInfo+"<div data-options=\"iconCls:'icon-w-plus'\">无历史数据</div>"
	}else
	{
		noSummaryFlag=0
		if(SummaryList.indexOf("/")==-1)
		{
			listInfo=listInfo+"<div onclick='showSummaryHistory(\""+SummaryList+"\")' data-options=\"iconCls:'icon-w-find'\">"+SummaryList+"</div>"
		}else
		{
			var dateArray=SummaryList.split("/")
		
			for(var i=0;i<dateArray.length;i++)
			{
				listInfo=listInfo+"<div onclick='showSummaryHistory(\""+dateArray[i]+"\")' data-options=\"iconCls:'icon-w-find'\">"+dateArray[i]+"</div>"
			}	
		}
	}
	
	$("#SummaryList").append(listInfo)
	
	$("#SummaryHistory").menubutton({menu:'#SummaryList',iconCls:'icon-write-order'})
	
}

function FreshSummaryHistory(date){
	if(noSummaryFlag===1){
		$("#SummaryList").empty()
	}
	console.log(noSummaryFlag)
	var Item="<div class='menu-item' onmouseout='this.style.background=\"white\"' onmouseover='this.style.background=\"#dbecf8\"' onclick='showSummaryHistory(\""+date+"\")' data-options=\"iconCls:'icon-w-find'\"><div class='menu-text'>"+date+"</div><div class='menu-icon icon-w-find'></div></div>"
	$("#SummaryList").append(Item)
	noSummaryFlag=0 //设置有总结数据标志
}




///总结历史窗口设置
function showSummaryHistory(date){
	if(showSummaryHistory.currentPage===date||showSummaryHistory.status==='open') return
	showSummaryHistory.currentPage=date
	var SummaryInfo=GetSummaryInfoByDate(date)
	$.messager.alert("总结数据",SummaryInfo,"")
	showSummaryHistory.currentPage=null
	
}
///打开总结窗口
function summary(){
	var url='dhc.emr.quality.docsummary.csp?noSummaryFlag='+noSummaryFlag;
	websys_showModal({
		iconCls:'icon-w-list',
		url:url,
		title:'总结',
		width:660,
		height:473	
	})
}

///业务操作

//查询按钮事件
function doSearch() {
	//alert(specialAdm);
     var queryParams = $('#patientListTable').datagrid('options').queryParams;
	 queryParams.QualityFlag = $("#QualityFlag").combobox('getValue')
	 queryParams.Method="GetOutPatAssignInfo"
     $('#patientListTable').datagrid('options').queryParams = queryParams;
     $('#patientListTable').datagrid('reload');			   
    
}

function patientListTableReload()
{
	//alert("abc");
	$('#patientListTable').datagrid("reload")
}

///接口

///##class(EPRservice.Quality.Ajax.OutPatDiscussInfo).GetSummaryDateInfo()
///同步方法获取总结的书写时间
function GetAllSummaryDates(){
	var res=$cm({
		ClassName:"EPRservice.Quality.DataAccess.OutPatSummaryInfo",
		MethodName:"GetSummaryDateInfo",
		dataType:'text'
	},false);
	
	return res
	
}

///w ##class(EPRservice.Quality.Ajax.OutPatDiscussInfo).GetDiscussInfo()
///同步方法获取讨论的分配时间对应的讨论内容
function GetSummaryInfoByDate(date){
	var res=$cm({
		ClassName:"EPRservice.Quality.DataAccess.OutPatSummaryInfo",
		MethodName:"GetInfoBySummaryDate",
		dataType:'text',
		date:date
	},false);
	
	return res
	
}
///GetAllDateGap
///同步方法获取分配时间
function GetAllDateGap(){
	var res=$cm({
		ClassName:"EPRservice.Quality.GetSpotCheckOutPatInfo",
		MethodName:"GetAllDateGap",
		dataType:'text'
	},false);
	
	return res
	
}




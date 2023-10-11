$(function(){
	extractSelectControl()
	initcombox()
	InitCheckedHistory()
	InitDiscussHistory()
	InitAuthorityDataList();
	if (HISUIStyleCode=="lite"){
		$('.bg-div').css('background-color','#f5f5f5')
	}
	
});
/// 公共变量初始化
var historyDate=""
var DateGap="",DateArray=[]
var historyDataFlag=0 //是否存在分配数据标志
var AssignedDate=[],noDiscussFlag=0
var rowIndex=0
var selectEpisodeIds=[]
var RefreshTab=0; //查询是否需要刷新界面(查看历史记录后，表格的属性发生改变，重新查询时需要刷新)
var eprPatient= new Object();
eprPatient.startDate = "";
eprPatient.endDate = "";
eprPatient.extractionRatio = "";
eprPatient.AdmStatus="";
//eprPatient.FinishedFlag="";

//科室初始化
function initcombox()
{
	
	$cm({
		ClassName:"web.eprajax.usercopypastepower",
		MethodName:"GetMZCTLocID",
		AType:"E",
		AFilter:"",
		AHospitalID:HospitalID,
		dataType:'text'
	},function(res){
		//展示用户数据	
		res=JSON.parse(res)
		$('#ctLocID').combobox
		({
			valueField:"ID",  
		    textField:"Name",
		    panelHeight:"100",
			mode:'local',
			multiple:true,
			rowStyle:'checkbox',
			data:res,
			filter: function(q, row){
				var opts = $(this).combobox('options');
				return row[opts.textField].indexOf(q) == 0;
			}
	    });	
	});
}

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
			url:'../EPRservice.Quality.Ajax.OutPatientInfoInterface.cls',  //*********
			queryParams: {
                StartDate: eprPatient.startDate,
				EndDate: eprPatient.endDate,
				selectPro: eprPatient.extractionRatio,
				AdmStatus:eprPatient.AdmStatus,
				HospitalID:HospitalID,
				extractNums: "",
				LocIds:""
            },
			singleSelect:true,
			//idField:'rowID', 
			//rownumbers:true,
			fit:true,
			columns:[[
				{field:'LocName',title:'科室',width:100,align:'left',cellattr: addCellAttr},
				{field:'length',title:'患者总数',width:100,align:'left',cellattr: addCellAttr},
				{field:'extractPro',title:'抽取比例',width:100,align:'left',cellattr: addCellAttr},
				
				{field:'number',title:'抽取数量',width:100,align:'left',cellattr: addCellAttr},
				
				{field:'PAPMIName',title:'病人姓名',width:100,align:'left',cellattr: addCellAttr},
				{field:'Age',title:'年龄',width:100,align:'left'},
				{field:'PAPMISex',title:'性别',width:100,align:'left'},
				
				{field:'MainDiagnos',title:'诊断',width:100,align:'left'},
				
				
			]],
			    		// 如果没有数据，就增加提示
			onLoadSuccess:function(data){
							if (undefined == data.rows || null == data.rows || data.rows.length == 0) {
								
								$("#btnAssign").linkbutton("disable")
								
								var tips = "<font color=red colspan=8>没有数据...</font>";
								$("#patientListTable").datagrid("insertRow", {
									index : 1,
									row : {
										LocName:tips	
									}
								});
							}else
							{
								$("#btnAssign").linkbutton("enable")
							}
							
						},
		  rowStyler:function(rowIndex, rowData){ 
       			if (rowData.DisManualFlag=="Y"){   
           		return 'background-color:#B9A8CE;';   
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
///控制抽取比例和抽取数量只能填写其中一个
function extractSelectControl()
{
	$("#extractNums").on("focus",function(){
		$('#extractRatio').numberspinner('setValue', "");
		//$("#extractionRatio").val("")
	})
	
	$("#extractRatio").on("focus",function(){
		$('#extractNums').numberspinner('setValue', "");
		//$("#extractNums").val("")
	})
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

///初始化分配历史列表
function InitCheckedHistory()
{
	var checkDateList=GetAllDateGap()
	var listInfo="",selectInfo=[] //这个selectInfo用于在讨论界面的菜单按钮数据
	if(checkDateList==""||checkDateList==undefined)
	{
		listInfo=listInfo+"<div data-options=\"iconCls:'icon-w-plus'\">无历史数据</div>"
		selectInfo.push({id:0,text:'无历史数据'})
	}else
	{
		historyDataFlag=1
		if(checkDateList.indexOf("/")==-1)
		{
			listInfo=listInfo+"<div onclick='getHistoryData(\""+checkDateList+"\")' data-options=\"iconCls:'icon-w-find'\">"+checkDateList+"</div>"
			selectInfo.push({id:checkDateList,text:checkDateList,selected:true})
		}else
		{
			var dateArray=checkDateList.split("/")
		
			for(var i=0;i<dateArray.length;i++)
			{
				listInfo=listInfo+"<div onclick='getHistoryData(\""+dateArray[i]+"\")' data-options=\"iconCls:'icon-w-find'\">"+dateArray[i]+"</div>"
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
	$("#historyList").append(listInfo)
	//$(listInfo).appendTo("#historyList");
	
	$("#checkHistory").menubutton({menu:'#historyList',iconCls:'icon-write-order'})
	
}

function FreshCheckedHistory(date)
{
	
	var date=date.replace(" ","")
	if (AssignedDate[0].text==="无历史数据")
	{
		AssignedDate=[] //重置
		$("#historyList").empty()
	}	
	var Item="<div class='menu-item' onmouseout='this.style.background=\"white\"' onmouseover='this.style.background=\"#dbecf8\"' onclick='getHistoryData(\" "+date+"\")' data-options=\"iconCls:'icon-w-find'\"><div class='menu-text'> "+date+"</div><div class='menu-icon icon-w-find'></div></div>"
	AssignedDate.push({id:date,text:date})
	
	$("#historyList").append(Item)
	
}

/// 历史数据查询
function getHistoryData(DateGap){
	
	historyDate=DateGap
	
	$("#btnAssign").linkbutton("disable")
	$("#reAssign").linkbutton("enable")
	$('#patientListTable').datagrid({ 
			pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            //pagePosition: 'bottom',
			fitColumns: true,
			method: 'post',
            loadMsg: '加载中......',
			autoRowHeight: true,
			url:'../EPRservice.Quality.Ajax.spotCheckPatInfoList.cls',  //*********
			queryParams: {
				DateGap:DateGap,
				Method:"GetHistoryAssignInfo"
            },
			singleSelect:false,
			//idField:'rowID', 
			//rownumbers:true,
			fit:true,
			//AssignName,MedName,PAPMIName,PAPMISex,MainDiagnos,DateGap
			columns:[[
				{field:'ck',checkbox:true},
				{field:'PAADMRowID',hidden:true},
				{field:'PAPMIName',title:'姓名',width:100,align:'left',cellattr: addCellAttr},
				{field:'PAPMISex',title:'性别',width:100,align:'left',cellattr: addCellAttr},
				{field:'MainDiagnos',title:'诊断',width:100,align:'left',cellattr: addCellAttr},
				
				{field:'DateGap',title:'分配日期段',width:100,align:'left',cellattr: addCellAttr},
				
				{field:'MedName',title:'质控医生',width:100,align:'left',cellattr: addCellAttr,
					formatter:function(value,row)
					{
						return row.MedName
					}
					
				},
				{field:'CheckedFlag',title:'是否质控',width:100,align:'left',cellattr: addCellAttr}
			]],
			onClickCell:function(index,field,value)
			{
				$('#patientListTable').datagrid("selectRow",index)
				$('#patientListTable').datagrid("beginEdit",index)
				rowIndex=index
			},
			    		// 如果没有数据，就增加提示
			onLoadSuccess:function(data){
							if (undefined == data.rows || null == data.rows || data.rows.length == 0) {
								
								var tips = "<font color=red colspan=8>没有数据...</font>";
								$("#patientListTable").datagrid("insertRow", {
									index : 1,
									row : {
										PAPMIName:tips
										
									}
								});
							}
							
						},
		  rowStyler:function(rowIndex, rowData){ 
       			if (rowData.DisManualFlag=="Y"){   
           		return 'background-color:#B9A8CE;';   
       			}   
   			},
   		  onSelect:function(rowIndex,rowData){
	   	  	if(rowData.CheckedFlag==="是"){
		   		$.messager.popover({
			   		msg:"该病历已质控，不可转分配!",
			   		type:"error",
			   		timeout: 2000, 
			   		showType: 'slide'
			   	})
			   	$(this).datagrid("unselectRow",rowIndex)
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
	  
	  RefreshTab=1 //设置刷新表格标志
}

///初始化讨论历史列表
function InitDiscussHistory()
{
	var DiscussList=GetAllDiscussDates()
	var listInfo=""
	if(DiscussList==""||DiscussList==undefined)
	{
		listInfo=listInfo+"<div data-options=\"iconCls:'icon-w-plus'\">无历史数据</div>"
		noDiscussFlag=1 //无数据标志
	}else
	{
		noDiscussFlag=0 
		if(DiscussList.indexOf("/")==-1)
		{
			listInfo=listInfo+"<div onclick='showDiscussHistory(\""+DiscussList+"\")' data-options=\"iconCls:'icon-w-find'\">"+DiscussList+"</div>"
			
		}else
		{
			var dateArray=DiscussList.split("/")
		
			for(var i=0;i<dateArray.length;i++)
			{
				listInfo=listInfo+"<div onclick='showDiscussHistory(\""+dateArray[i]+"\")' data-options=\"iconCls:'icon-w-find'\">"+dateArray[i]+"</div>"
			}	
		}
	}
	
	$("#discussList").append(listInfo)
	
	$("#discussHistory").menubutton({menu:'#discussList',iconCls:'icon-write-order'})
	
}

function FreshDiscussHistory(date)
{
	if(noDiscussFlag===1){
		$("#discussList").empty()
	}
	noDiscussFlag=0
	var Item="<div class='menu-item' onmouseout='this.style.background=\"white\"' onmouseover='this.style.background=\"#dbecf8\"' onclick='showDiscussHistory(\""+date+"\")' data-options=\"iconCls:'icon-w-find'\"><div class='menu-text'> "+date+"</div><div class='menu-icon icon-w-find'></div></div>"
	$("#discussList").append(Item)
}

function showDiscussHistory(date){
	var DiscussInfo=GetDiscussInfoByDate(date)
	DiscussInfo=DiscussInfo.split("^")
	var msgStr=""
	for(i=0;i<DiscussInfo.length;i++)
	{
		msgStr=msgStr+DiscussInfo[i].split("/")[0]
	}	
	$.messager.show({
		title:'讨论数据',
		timeout:0,
		width:400,
		height:300,
		msg:msgStr,
		style:{
			right:'',
			top:document.body.scrollTop+document.documentElement.scrollTop+150,
			bottom:'',
			border:'1 solid rgba(1,123,236,1)'
		}
	})
	$("#updateBtn").linkbutton({iconCls:'icon-accept'})
}

//业务

//抽查按钮事件
function doSearch() {
	
	$("#reAssign").linkbutton("disable")
	
	
	if(RefreshTab==1)
	{
		InitAuthorityDataList() //刷新表格
	}
     var queryParams = $('#patientListTable').datagrid('options').queryParams;
     queryParams.StartDate = $("#inputCreateDateStart").datetimebox('getText');
     queryParams.EndDate = $("#inputCreateDateEnd").datetimebox('getText');
     queryParams.selectPro = $("#extractRatio").numberspinner('getValue')*0.01;
     queryParams.extractNums = $("#extractNums").numberspinner('getValue');
	 queryParams.LocIds = $("#ctLocID").combobox('getValues').toString();
	 queryParams.AdmStatus = "A";
	 
	 DateGap=queryParams.StartDate+"至"+queryParams.EndDate
	 
	 queryParamsReload(queryParams)

	 RefreshTab=0
	
}

function queryParamsReload(queryParam)
{
	$('#patientListTable').datagrid('options').queryParams = queryParam;
    $('#patientListTable').datagrid('reload');
}


/// 分配按钮
function Assign(){
	if(DateGap=="")
	{
		$.messager.alert("提示:", "请先抽查患者病历!", "info");
		return
	}
	var passFlag=CheckQueryDates(DateGap)  //时间检验
	
	if(passFlag[0]=="N")
	{
		$.messager.alert("提示:",passFlag.substring(1,passFlag.length),"info")
		DateArray=[]
		return
	}
	
	//var DateGap=GetParamDateGap(DateArray)  //此处用于将数组类型的数据转换成字符串类型，以便于传入后台
	$.messager.defaults = { ok: "确定", cancel: "重抽" };
	$.messager.confirm("分配操作","您抽查了:"+DateGap+"的门诊病历数据，是否分配？",function(r){
		if(r)
		{
			$.ajax({
				url:'../EPRservice.Quality.Ajax.OutPatAssignment.cls',
				data:{
					UserID:userID,
					dateGap:DateGap,
					action:'Assign'
				},
				dataType:'text',
				success:function(res){
					if(res!="添加成功")
					{
						$.messager.alert("分配提示：",res,"error")
						return
					}
					$.messager.alert("分配提示：",res,"success")
					FreshCheckedHistory(DateGap);
					$("#btnAssign").linkbutton("disable")
					
				}	
			})	
		}else
		{
			DateArray=[]
			return
		}
	})
	
}

//讨论意见修改按钮
function submit(){
	var Idea=$("#idea").text()
	var DiscussDates=$("#cbox").combobox("getValues")
	DiscussDates=DiscussDates.join("/")
	
	if(DiscussDates==""||DiscussDates==undefined)
	{
		$.messager.alert("提示:","请选择本次讨论的所对应的抽查日期!")
		return
	}
	
	$.ajax({
		url:'../EPRservice.Quality.Ajax.OutPatDiscussInfo.cls',
		data:{
			idea:Idea,
			DiscussDates:DiscussDates
		},
		dataType:'text',
		success:function(res){
			$.messager.alert("提示：",res,"info")
			window.parent.InitDiscussHistory()  //打开讨论窗口时刷新下讨论历史数据
		}	
	})
}

/// 打开讨论窗口
function OpenDiscussWin()
{	
	var url='dhc.emr.quality.docdiscuss.csp';
	websys_showModal({
		iconCls:'icon-w-list',
		url:url,
		title:$g('讨论'),
		width:660,
		height:473	
	})
}


function ReAssign()
{
	var selectRows=$('#patientListTable').datagrid('getSelections')
	if(Object.keys(selectRows).length===0)
	{
		$.messager.alert("提示：","请先选择转分配的病历!","info")
		return
	}
	var selectNums=selectRows.length
	var EpisodeIDS=""
	for(var i=0;i<selectNums;i++)
	{
		if(selectRows[i].CheckedFlag==="是")
		{
			continue
		}
		EpisodeIDS=EpisodeIDS+selectRows[i].PAADMRowID+"/"
	}
	var EpisodeIDS = EpisodeIDS.substring(0, EpisodeIDS.length - 1);  //去掉最后一个"/"
	
	GetMedDoctors(EpisodeIDS)
}

///时间检查

///检验抽查时段

function CheckQueryDates(dates)
{
	var passFlag="Y"
	
	if(dates==""||dates.length==0||dates==undefined)
	{
		return passFlag
	}
	
	var checkedDates=GetCheckedDate()
	var dateArray=checkedDates.split("/")
	
	var messages=""
	
	if(dateArray.length==0||checkedDates=="")
	{
		return passFlag
	}
	
	for(var i=0;i<dateArray.length;i++)
	{
		var startDate=dateArray[i].split(",")[0]
		var endDate=dateArray[i].split(",")[1]
		var assignDateInfo=dates.split("至")
		var assignStartDate=assignDateInfo[0]
		var assignEndDate=assignDateInfo[1]
		
		if(assignStartDate<startDate&&assignEndDate>endDate)
		{
			messages=messages+"时段"+startDate+"至"+endDate+"已经分配过，请选择其他时段！"
			break
		}
		
		
		if(assignStartDate<startDate&&assignEndDate>=endDate&&assignEndDate<=endDate)
		{
			messages=messages+"时段"+startDate+"至"+assignEndDate+"已经分配过，请选择其他时段！"
			break
		}
		
		if(assignStartDate>=startDate&&assignEndDate>endDate&&assignStartDate<=endDate)
		{
			messages=messages+"时段"+assignStartDate+"至"+endDate+"已经分配过，请选择其他时段！"
			break
		}
		
		
		
		if(assignStartDate>=startDate&&assignEndDate<=endDate)
		{
			messages=messages+"时段"+assignStartDate+"至"+assignEndDate+"已经分配过，请选择其他时段！"
			break
		}
		
	}
	
	if(messages!="")
	{
		passFlag="N"+messages
	}
	
	return passFlag
	
	
}

/// 抽查时段

function SetCheckDates(date1,date2,dates)
{
	var checkDates={}
	checkDates.startDate=date1
	checkDates.endDate=date2
	var addFlag=1
	for(var i=0;i<dates.length;i++)
	{
		if(dates[i].startDate==checkDates.startDate&&dates[i].endDate==checkDates.endDate)
		{
			addFlag=0
		}
	}
	if(addFlag==1)
	{
		dates.push(checkDates)	
	}
	
	return dates
}

///接口


///同步方法检查输入的时间
function CheckDate(StartDate,EndDate){
	if(StartDate==""||EndDate==""||StartDate<EndDate)
	{
		return "0^输入时间有误！"
	}
	var res=$cm({
		ClassName:"EPRservice.Quality.Ajax.OutPatientInfoInterface",
		MethodName:"DateCheck",
		StartDate:StartDate,
		EndDate:EndDate,
		dataType:'text'
	},false);
	
	return res
	
}

///同步方法获取已抽查时间
function GetCheckedDate(){
	var res=$cm({
		ClassName:"EPRservice.Quality.DataAccess.BOQualityCheckDateInfo",
		MethodName:"GetAllCheckedDate",
		dataType:'text'
	},false);
	
	return res
	
}

///同步方法获取可查询时间
function GetAllRightDate(){
	var res=$cm({
		ClassName:"EPRservice.Quality.DataAccess.BOQualityCheckDateInfo",
		MethodName:"GetAllRightDate",
		dataType:'text'
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

//EPRservice.Quality.DataAccess.BOQualityCheckDateInfo.GetLastCheckDate
///GetAllDateGap
///同步方法获取分配时间
function GetLastCheckDate(){
	var res=$cm({
		ClassName:"EPRservice.Quality.DataAccess.BOQualityCheckDateInfo",
		MethodName:"GetLastCheckDate",
		dataType:'text'
	},false);
	
	return res
	
}

///##class(EPRservice.Quality.Ajax.OutPatDiscussInfo).GetDiscussDatesInfo()
///同步方法获取讨论的抽查时间
function GetAllDiscussDates(){
	var res=$cm({
		ClassName:"EPRservice.Quality.DataAccess.OutPatDiscussInfo",
		MethodName:"GetDiscussDatesInfo",
		dataType:'text'
	},false);
	
	return res
	
}

///w ##class(EPRservice.Quality.Ajax.OutPatDiscussInfo).GetDiscussInfo()
///同步方法获取讨论的抽查时间对应的讨论内容
function GetDiscussInfoByDate(date){
	var res=$cm({
		ClassName:"EPRservice.Quality.DataAccess.OutPatDiscussInfo",
		MethodName:"GetDiscussInfo",
		dataType:'text',
		DiscussDates:date
	},false);
	
	return res
	
}
///获取质控医师
///##Class(EPRservice.Quality.DataGather.SSUser).GetMZMedDoc()
function GetMedDoctors(EpisodeIDS){
	var res=$cm({
		ClassName:"EPRservice.Quality.Ajax.MedDoctor",
		MethodName:"GetEffectiveUserInfoByRange",
		dataType:'text',
		date:"",
		Range:"O"
	},function(data){
		var radio=''
		var newStr=data.replace(/\^/g,"/")
		var doctorList=newStr.split("/")
		if(newStr===""){
			radio="未设置质控员"
		}else
		{
			var length=doctorList.length
			for(var i=0;i<length;i++)
			{
				var doctor=doctorList[i].split("-")
				var docId=doctor[0]
				var docName=doctor[1]
				radio+='<input class="hisui-radio" style="vertical-align: middle;" type="radio" label="'+docName+'" name="medDoc" value="'+docId+'">'
				radio+='<span style="margin-left:10px;">'+docName+'</span><br>'
			}	
		}
		
		
		$.messager.prompt("操作提示", '请选择分配人!', function (data) { 
		    if (data) {
			    var userId=$("input[name='medDoc']:checked").val();
			    
			    if(!userId){
					$.messager.alert("提示","未选择分配人","info")
					return
				}
			    updateMedDoc(EpisodeIDS,userId)
		    }  

	    }); 
	    
	    $(".messager-input").parent().append('<div style="margin-left:30%;">'+radio+'</div>'); 
		$(".messager-input").hide();
		$(".messager-input").val('false')
		/*$('#isc').change(function() { 
			if($(this).is(':checked')){
				$(".messager-input").val('true')
			}else{
				$(".messager-input").val('false')
			} 
		});*/
	});
	$.parser.parse();	
}

///转分配
function updateMedDoc(EpisodeIDS,userID){
	
	$.ajax({
		url:'../EPRservice.Quality.Ajax.OutPatAssignment.cls',
		data:{
			UserID:userID,
			EpisodeIDS:EpisodeIDS,
			action:'updateMedDoc'
		},
		dataType:'text',
		success:function(res){
			$.messager.alert("提示：",res,"success")
			getHistoryData(historyDate)
		}	
	})	
}



/// 将数组形式的数据转成string串
function GetParamDateGap(DateArray)
{
	var result=""
	for(var i=0;i<DateArray.length;i++)
	{
		result=result+DateArray[i].startDate+"至"+DateArray[i].endDate+"/"
	}
	result=result.substring(0,result.length-1)
	
	return result
}









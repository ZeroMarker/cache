

$(".topTask .taskCount").on("click",function(){
	$(".taskCountSelect").removeClass("taskCountSelect")
	$(this).addClass("taskCountSelect")
	var tabId=$(this).attr("tableName")
	
	if(isUndefined(tabId)){
		$(".time-line-item").each(function(){
			$(this).show()
			$(this).find(".content").hide()
			$(this).find(".contentShow").show()
			
		})
	}else{
		scrollOffset(tabId);
		var stdateArrs=[]
		$(".time-line-item").each(function(index){
			
			var showLen=$(this).find(".contentShow[tabId="+tabId+"]").length
			$(this).hide()
			if(showLen>0){
				$(this).find(".content").hide()
				$(this).find(".contentShow[tabId="+tabId+"]").show()
				$(this).show()
				
				var stdate=$(this).find("span.time-str").attr("stdate")
				var sttime=$(this).find("span.time-str").attr("sttime")
				$(this).find("span.time-str").html(stdate+" "+sttime)
				if(stdateArrs.indexOf(stdate)==-1){
					stdateArrs.push(stdate)
					var timeLen=$(this).find("span.time-str").length
					$(this).find("span.time-str").html(sttime)
				}else{
					$(this).find("span.time-str").html(sttime)	
				}
				
			}else{
				
			}
			
		})
	}
})

function ShowOrderExe(that){
	var tabId=that.name
	var tab = $("#"+tabId).tabs('getSelected');

	var title = tab.panel('options').title
	var key = $(title).attr("key")
	var tableId = $(title).attr("tableId")
	var tabId = $(title).attr("tabId")
	
	var recordId=that.id;
	
	var index=$('#'+tableId).datagrid('getRowIndex',recordId);
	var rows = $('#'+tableId).datagrid('getRows');
	console.log(rows)
	var exeInfoList=rows[recordId].execInfos
	var height=31;
		// 来源 触发因素 状态 触发时间 记录ID
	$(that).webuiPopover({
		title:'',
		content:function(){
			var html=[];
			html.push('<table class="related-factors">');
			html.push('<tr><td></td><td></td><td></td><td></td></tr>');
			//var exeInfoList=rtn.orders[i].execInfos
			for(var j=0;j<exeInfoList.length;j++){
				var exeInfo=exeInfoList[j]
				var sttDateTime=exeInfo.sttDateTime
				var planData={
					exeDate:exeInfo.sttDate,
					exeTime:exeInfo.sttTime,
					DspStat:exeInfo.dspStat,
					freqNo:exeInfo.freqNo
				}	
				html.push('<tr>');
				html.push('<td style="height:28px;">'+exeInfo.sttDate+'</td>');
				html.push('<td>'+exeInfo.sttTime+'</td>')
				html.push('<td style="font-weight: bold;color:#E0495A">'+exeInfo.freqNo+'</td>');
				html.push('<td style="font-weight: bold;">'+exeInfo.dspStat+'</td>');
				html.push('</tr>');
			}
			
			html.push('</table>');
			var htmlCode= html.join('');
			delete html;
			return htmlCode;
		},
		trigger:'hover',
		placement:'right',
		style:'inverse',
		height:(height*exeInfoList.length)
	});
	$(that).webuiPopover('show');
}


function ShowQueAssessList(that){
	
	var tabId=that.name
	var tab = $("#"+tabId).tabs('getSelected');

	var title = tab.panel('options').title
	var key = $(title).attr("key")
	var tableId = $(title).attr("tableId")
	var tabId = $(title).attr("tabId")
	
	var recordId=that.id;
	
	var index=$('#'+tableId).datagrid('getRowIndex',recordId);
	var rows = $('#'+tableId).datagrid('getRows');
	
	var tkDataList=rows[recordId].tkDataList
	
	
	var height=31;
		// 来源 触发因素 状态 触发时间 记录ID
	$(that).webuiPopover({
		title:'',
		content:function(){
			var html=[];
			html.push('<table class="related-factors">');
			html.push('<tr class="title"><td>'+$g("ID")+'</td><td class="assess-source">'+$g("来源")+'</td><td class="assess-factors">'+$g("触发因素")+'</td><td class="assess-trggerTime">'+$g("触发时间")+'</td><td class="assess-status">'+$g("触发值")+'</td></tr>');
			for(var i=0;i<tkDataList.length;i++){
				var id=tkDataList[i].id
				var type=tkDataList[i].type
				var desc=tkDataList[i].desc
				var pointDate=tkDataList[i].pointDate
				var pointValue=tkDataList[i].pointValue
				//var exeItemName=tkDataList[i].exeItemName
				
				if(isUndefined(pointValue)){
					pointValue=""		
				}
				html.push('<tr>');
				html.push('<td>'+id+'</td>');
				html.push('<td class="assess-source">'+type+'</td>')
				html.push('<td>'+desc+'</td>');
				//html.push('<td>'+exeItemName+'</td>');
				html.push('<td class="assess-trggerTime">'+pointDate+'</td>');
				html.push('<td class="assess-status">'+pointValue+'</td>');
				html.push('</tr>');
			}
			
			html.push('</table>');
			var htmlCode= html.join('');
			delete html;
			return htmlCode;
		},
		trigger:'hover',
		placement:'right',
		style:'inverse',
		height:(height*tkDataList.length)+64
	});
	$(that).webuiPopover('show');
}
var dataReocrdList={}
var leftTimeRecordList={}
function leftMData(tabsId,alllist){
	var leftTimeData={}
	for(var i=0;i<alllist.length;i++){
		var row=alllist[i]
		var exeDate=row.exeDate
		var exeTime=row.exeTime
		exeDate=mdate(exeDate)
		exeTime=exeTime.split(":")[0]
		var exeId=tabsId+"-"+exeTime
		if(isUndefined(leftTimeData[exeId])){
			leftTimeData[exeId]=[]
		}
		leftTimeData[exeId].push(row)
		
	}
	for(var exeId in leftTimeData){
		$("#"+exeId).parents(".lzc_timeline .content").addClass("contentShow").show()
		$("#"+exeId).text(leftTimeData[exeId].length)	
		leftTimeRecordList[exeId]=leftTimeData[exeId]
	}	
	//setTaskCount(tabsId)
}

function setTaskCount(tabsId){
	
	var tabCount={}
	$(".time-line-item").each(function(index){
		$(this).find(".contentShow").each(function(){
			var tabsId =$(this).attr("tabId")	
			var val=$(this).find("span.timeTaskCount").text()
			var timeCount=tabCount[tabsId]
			if(!isUndefined(timeCount)){
				val=parseInt(val)+parseInt(timeCount)
			}
			tabCount[tabsId]=val
			
		})	
		
	})
	//console.log("开始")
	//for(key in tabCount){
		$(".taskCount[tableName="+tabsId+"]").find(".taskNum").text(tabCount[tabsId])	
	//}
	//console.log("结束")
	return "12"
}

function tabItemBadge(tabsId,rtn){
	var tabs = $("#"+tabsId).tabs("tabs");//获得所有小Tab
	var tCount = tabs.length;
	var titleArr={}
	for(var i=0;i<tCount;i++){
		var title=tabs[i].panel('options').title
		var key = $(title).attr("key");
		titleArr[key]=i
	}
	$("#"+tabsId).find(".tabItem_badge").remove();
	var badgeIndex=[]
	for(var i=0;i<rtn.length;i++){
		var code = rtn[i].exeItemId
		var desc = rtn[i].exeItemName
		var list = rtn[i].list
		if(list.length>0){
			var liIndex=titleArr[code]
			badgeIndex.push(liIndex)
		}
	}
	if(badgeIndex.length>0){
		for(var i=0;i<badgeIndex.length;i++){
			var liIndex=badgeIndex[i]
			$($("#"+tabsId).find("ul li")[liIndex]).append('<sup class="tabItem_badge"></sup>');	
		}
		
		$($("#"+tabsId).find("ul li")[1]).append('<sup class="tabItem_badge"></sup>');
	}
}


function tabItemBadgeBak(tabsId,data){
	var tabs = $("#"+tabsId).tabs("tabs");//获得所有小Tab
	var tCount = tabs.length;
	var titleArr={}
	for(var i=0;i<tCount;i++){
		var title=tabs[i].panel('options').title
		var key = $(title).attr("key");
		titleArr[key]=i
	}
	data.ItemId=""
	var params = JSON.stringify(data)
	var badgeIndex=[]
	runClassMethod("Nur.NIS.Service.NursingTask.Controller","GetNursingTaskRecord",{data:params},function(rtn){
		$("#"+tabsId).find(".tabItem_badge").remove();
		var badgeIndex=[]
		for(var i=0;i<rtn.length;i++){
			var code = rtn[i].exeItemId
			var desc = rtn[i].exeItemName
			var list = rtn[i].list
			if(list.length>0){
				var liIndex=titleArr[code]
				badgeIndex.push(liIndex)
			}
		}
		if(badgeIndex.length>0){
			for(var i=0;i<badgeIndex.length;i++){
				var liIndex=badgeIndex[i]
				$($("#"+tabsId).find("ul li")[liIndex]).append('<sup class="tabItem_badge"></sup>');	
			}
			
			$($("#"+tabsId).find("ul li")[1]).append('<sup class="tabItem_badge"></sup>');
		}
	})
}

function tabTitles(tabsId,taskType){
	var tableId="table-"+tabsId+"-0"
	$HUI.tabs("#"+tabsId).add({
		title: '<span class="keyname" tabId="'+tabsId+'" tableId="'+tableId+'" key="""">未执行</span>'
	});	
	var data={
		HospDR:session['LOGON.HOSPID'],
		TaskType:taskType
	}
	runClassMethod("Nur.NIS.Service.NursingTask.Controller","GetTabTitles",data,function(rtn){	
		for(var i=0;i<rtn.length;i++){
			var tableId="table-"+tabsId+"-"+(i+1)
			var code=rtn[i].itemId
			var desc =rtn[i].itemName
			$HUI.tabs("#"+tabsId).add({
				title: '<span class="keyname" tabId="'+tabsId+'" tableId="'+tableId+'" key="'+code+'">'+desc+'</span>',
				selected: false
			});	
		}
		$("#"+tabsId).tabs('select',1);  
	},'json',false);
}
function gridData(tabsId,gid,code,taskType,time){
	setTimeout(function(){
		var thisTab = $('#'+tabsId).tabs('getSelected');  
		var episodeIDStr = resultPatIds()  
		var data = {
			EpisodeIDs:episodeIDStr,
			WardID:session['LOGON.WARDID'],
			UserId:session['LOGON.USERID'],
			LocID:session['LOGON.CTLOCID'],
			HospDR:session['LOGON.HOSPID'],
			GroupID: session['LOGON.GROUPID'],
			StartDate:$("#execStDate").datebox("getValue"),
			StartTime:$("#execStTime").timespinner("getValue"),
			EndDate:$("#execEndDate").datebox("getValue"),
			EndTime:$("#execEndTime").timespinner("getValue"),
		 	TaskType:taskType,
		 	ItemId:""
		}
	
		var param = JSON.stringify(data)
		runClassMethod("Nur.NIS.Service.NursingTask.Controller","GetNursingTaskRecord",{data:param},function(rtn){
			$("#"+gid).datagrid("unselectAll");
			var alllist=[]
			var itemList={}
			var allcount=0
			for(var i=0;i<rtn.length;i++){
				var rtnCode = rtn[i].exeItemId
				var rtnDesc = rtn[i].exeItemName
				var list = rtn[i].list
				alllist.push.apply(alllist,list)
				itemList[rtnCode]=list
				allcount=allcount+list.length
			}
			leftMData(tabsId,alllist)
			
			tabItemBadge(tabsId,rtn)
			
			var dataList=alllist
			if(code!=""){
				alllist=itemList[code]
			}
			
			var rowData=[]
			if(!isUndefined(time)){
				for(var t=0;t<alllist.length;t++){
					var exeTime=alllist[t].exeTime
					//exeTime=exeTime.split(":")[0]
					if(time==exeTime){
						rowData.push(alllist[t])
					}
				}
			}else{
				rowData=alllist
			}
			
			$("#"+gid).datagrid('loadData', rowData)
			$(".taskCount[tableName="+tabsId+"]").find(".taskNum").text(allcount)	
			
			
			
		},'json',true);
		
	}, 20);		
}


var json={
		tabsTasksSign:{
			id:"tabsTasksSign",
			name:"体征任务",
			iconCls:"icon-batch-add",
			fitColumns:true,
			rtnParma:function(){},
			tabTitles:function(tabsId){	
				tabTitles(tabsId,1)
			},
			gridData:function(tabsId,gid,code){
				gridData(tabsId,gid,code,1)
				
			},
			rtnLeftMData:function(){
				
			},
			onDblClickRow:function(rowData){
				var dataObj={
					startDate:$("#execStDate").datebox("getValue"),
					startTime:$("#execStTime").timespinner("getValue"),
					endDate:$("#execEndDate").datebox("getValue"),
					endTime:$("#execEndTime").timespinner("getValue")
				}
				var stdate = dataObj.startDate +' '+ dataObj.startTime
				var etDate = dataObj.endDate + ' ' + dataObj.endTime
				
				var EpisodeIDS = resultPatIds() 
				var EpisodeID = EpisodeIDS.split("^")[0]
				var arrs = EpisodeIDS.split("^") 
				
				
				
				var h = $("#nrLayout").find(".tabs-panels").eq(0).height()
				var TWsheetCodeName = rowData.exeItemName
				var TWsheetCode = rowData.itemCode

				
				var iframeUrl = 'nur.hisui.multivitalsignbyday.csp?componentArgs={}&codeStr='+TWsheetCode+'&EpisodeIDS='+EpisodeIDS+'&startDateTime='+stdate+'&endDateTime='+etDate+'&EpisodeID='+arrs[0]
				if(iframeUrl !=""){
					var content = '<iframe scrolling="auto" frameborder="0"  src="'+iframeUrl+'" style="width:100%;height:'+h+'px;"></iframe>';
					addTab(TWsheetCodeName,content)
				}	
				
			},
			rtnColumns:function(){
				var Columns=[[ 
					<!--{ field: 'id', checkbox: 'true'},-->
					{ field: 'bedCode', title: '床号',width:70},
					{ field: 'patName', title: '姓名',width:150},
					{ field: 'exeItemName', title: '需测项目',width:200,
						formatter: function(value,row,index){
							var newValue='<a name="tabsTasksSign" id= "' + index + '"onmouseover="ShowQueAssessList(this)">'+value+'</a>';
							return newValue;
						}
					},
					{ field: 'exeDate', title: '需测日期',width:100},
					{ field: 'exeTime', title: '需测时间',width:100},
					{ field: 'configId', title: '配置ID',width:100},
					
					
				]]	
				return Columns
			}
		},
		tabsTasksAssess:{
			id:"tabsTasksAssess",
			name:"评估任务",
			iconCls:"icon-batch-add",
			fitColumns:true,
			rtnParma:function(){},
			tabTitles:function(tabsId){	
				tabTitles(tabsId,2)
			},
			gridData:function(tabsId,gid,code){
				gridData(tabsId,gid,code,2)
				
				
			},
			onDblClickRow:function(rowData){
				console.log(rowData)	
				var dataObj={
					startDate:$("#execStDate").datebox("getValue"),
					startTime:$("#execStTime").timespinner("getValue"),
					endDate:$("#execEndDate").datebox("getValue"),
					endTime:$("#execEndTime").timespinner("getValue")
				}
				var stdate = dataObj.startDate +' '+ dataObj.startTime
				var etDate = dataObj.endDate + ' ' + dataObj.endTime
				var h = $("#nrLayout").find(".tabs-panels").eq(0).height()
				var EpisodeIDS = resultPatIds() 
				var EpisodeID = EpisodeIDS.split("^")[0]
				var arrs = EpisodeIDS.split("^")
				text="常规护理任务-护理评估"
				var TWsheetCode=rowData.exeItemId
				var iframeUrl = 'nur.hisui.nursingtask.assess.csp?1=1&EpisodeIDS='+EpisodeIDS+'&startDateTime='+stdate+'&endDateTime='+etDate+'&showTaskTabName='+text+'&code='+TWsheetCode

				if(iframeUrl !=""){
					console.log(iframeUrl)
					var content = '<iframe scrolling="auto" frameborder="0"  src="'+iframeUrl+'" style="width:100%;height:'+h+'px;"></iframe>';
					addTab(text,content)
				}
				
				
			},
			rtnColumns:function(){
				var Columns=[[ 
					<!--{ field: 'id', checkbox: 'true'},-->
					{ field: 'bedCode', title: '床号',width:70},
					{ field: 'patName', title: '姓名',width:150},
					{ field: 'exeItemName', title: '需评项目',width:200,
						formatter: function(value,row,index){
							var newValue='<a name="tabsTasksAssess" id= "' + index + '"onmouseover="ShowQueAssessList(this)">'+value+'</a>';
							return newValue;
						}
					},
					{ field: 'exeDate', title: '需评日期',width:100},
					{ field: 'exeTime', title: '需评时间',width:100},
					{ field: 'configId', title: '配置ID',width:100},
				]]	
				return Columns
			}
		},
		tabsEduTask:{
			id:"tabsEduTask",
			name:"健康宣教",
			iconCls:"icon-batch-add",
			rtnParma:function(){
				
			},
			tabTitles:function(tabsId){
				var tableId="table-"+tabsId+"0"
				$HUI.tabs("#"+tabsId).add({
					title: '<span class="keyname" tabId="'+tabsId+'" tableId="'+tableId+'" key="0">未执行</span>'
				});	
				
			},
			gridData:function(tabsId,gid,code){
				setTimeout(function(){
					var thisTab = $('#'+tabsId).tabs('getSelected');  
					var episodeIDStr = resultPatIds()  
					var data = {
						Adm:episodeIDStr,
						WardID:session['LOGON.WARDID'],
						UserId:session['LOGON.USERID'],
						LocId:session['LOGON.CTLOCID'],
						HospDR:session['LOGON.HOSPID'],
						NoReturn: "", 
						StartDate:date_obj.startDate,
		 				EndDate:date_obj.endDate
					}
					var param = $.extend(param,data)
					runClassMethod("Nur.NIS.Service.NursingTask.Controller","UpdateEduTaskAndReturnList",param,function(rtn){
						
						$("#"+gid).datagrid("unselectAll");
						$("#"+gid).datagrid('loadData', rtn)
						
						
						/*var tabs = $("#"+tabsId).tabs("tabs");//获得所有小Tab
						var tCount = tabs.length;
						var titleArr={}
						for(var i=0;i<tCount;i++){
							var title=tabs[i].panel('options').title
							var key = $(title).attr("key");
							titleArr[key]=i
						}
						
						
						var allTablist=[]
						for(var i=0;i<rtn.length;i++){
							var title=rtn[i].title
							var subjectId=rtn[i].subjectId
							if(allTablist.indexOf(subjectId)<0){
								if(!isUndefined(titleArr[title])){
									continue;
								}
								var tableId="table-"+tabsId+"-"+(i+1)
								$HUI.tabs("#"+tabsId).add({
									title: '<span class="keyname" tabId="'+tabsId+'" tableId="'+tableId+'" key="'+subjectId+'">'+title+'</span>',
									selected: false
								});	
								allTablist.push(subjectId)
							}
						}
						*/
						
						
						var alllist=[]
						for(var i=0;i<rtn.length;i++){
							var planDateTime=rtn[i].planDate
							var exeDate=planDateTime.split(" ")[0]
							var exeTime="08:00"
							var planData={
								exeDate:exeDate,
								exeTime:exeTime
								}
							alllist.push(planData)
						}
						leftMData(tabsId,alllist)
						
					},'json',true);
				}, 20);		
				
			},
			rtnColumns:function(){
				var Columns=[[ 
					<!--{ field: 'id', checkbox: 'true'},-->
					{ field: 'bedCode', title: '床号',width:150},
					{ field: 'name', title: '姓名',width:150},
					{ field: 'title', title: '宣教项目',width:100},
					{ field: 'planDate', title: '待宣日期',width:100},
					{ field: 'content', title: '宣教内容',width:2000},
					
				]]	
				return Columns
			}
		},
		tabsNurseOrderExe:{
			id:"tabsNurseOrderExe",
			name:"护理计划",
			iconCls:"icon-batch-add",
			className:"Nur.NIS.Service.NursingPlan.InterventionSetting",
			methodName:"FindInterventionType",
			tabTitles:function(tabsId){
				var thisTab = $('#'+tabsId).tabs('getSelected');    
				var tableId="table-"+tabsId+"-0"
				$HUI.tabs("#"+tabsId).add({
					title: '<span class="keyname" tabId="'+tabsId+'" tableId="'+tableId+'" key="""">未执行</span>'
				});	
			
				
				var tabData=$.cm({
					ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
					QueryName:"FindInterventionType",
					nameCN:"",
					hospDR:session['LOGON.HOSPID'],
					rows:99999
				},false)
				var tabs = tabData.rows

				for(var i=0;i<tabs.length;i++){
					var desc= tabs[i].shortNameCN
					var code=tabs[i].id
					var tableId="table-"+tabsId+"-"+(i+1)
					$HUI.tabs("#"+tabsId).add({
						title: '<span class="keyname" tabId="'+tabsId+'" tableId="'+tableId+'" key="'+code+'">'+desc+'</span>'
					});
					
				}
				$("#"+tabsId).tabs('select',1);  
			},
			gridData:function(tabsId,gid,code){
				var parm={  
				 	startDate:date_obj.startDate,
		 			startTime:date_obj.startTime,
		 			endDate:date_obj.endDate,
		 			endTime:date_obj.endTime,
				}
				var episodeIDStr = resultPatIds()
				var rtn=$.cm({
					ClassName:"Nur.NIS.Service.NursingPlan.TaskRecord",
					QueryName:"GetTaskList",
					episodeIDString:episodeIDStr,
					dateFrom:parm.startDate+" "+parm.startTime,
					dateTo:parm.endDate+" "+parm.endTime,
					taskStatus:0,
					intType:code
				},false)
				
				$("#"+gid).datagrid("unselectAll");
				$("#"+gid).datagrid('loadData', rtn.rows)
				
				var alllist=[]
				for(var i=0;i<rtn.rows.length;i++){
					var planDateTime=rtn.rows[i].planDateTime
					var exeDate=planDateTime.split(" ")[0]
					var exeTime=planDateTime.split(" ")[1]
					var planData={
						exeDate:exeDate,
						exeTime:exeTime
						}
					alllist.push(planData)
				}
				leftMData(tabsId,alllist)
				
				//添加红色小点
				var rtnWzx=$.cm({
					ClassName:"Nur.NIS.Service.NursingPlan.TaskRecord",
					QueryName:"GetTaskList",
					episodeIDString:episodeIDStr,
					dateFrom:parm.startDate+" "+parm.startTime,
					dateTo:parm.endDate+" "+parm.endTime,
					taskStatus:0,
					intType:""
				},false)
				$("#"+tabsId).find(".tabItem_badge").remove();
				var tabs = $("#"+tabsId).tabs("tabs");//获得所有小Tab
				var tCount = tabs.length;
				var titleArr={}
				for(var i=0;i<tCount;i++){
					var title=tabs[i].panel('options').title
					var key = $(title).attr("key");
					titleArr[key]=i
				}
				
				for(var i=0;i<rtnWzx.rows.length;i++){
					var wzx=rtnWzx.rows[i]
					var code=wzx.interventionTypeId
					var liIndex=titleArr[code]
					$($("#"+tabsId).find("ul li")[liIndex]).append('<sup class="tabItem_badge"></sup>');
				}
				if(rtnWzx.rows.length>0){
				$($("#"+tabsId).find("ul li")[1]).append('<sup class="tabItem_badge"></sup>');
				}	

			},
			rtnColumns:function(){
				var Columns=[[ 
					<!--{ field: 'recordId', checkbox: 'true'},-->
					{ field: 'patientBedNo', title: '床号',width:150},
					{ field: 'patientName', title: '姓名',width:150},
					{ field: 'interventionTypeName', title: '类型',width:100},
					{ field: 'planDateTime', title: '计划执行时间',width:140},
					{ field: 'executeItemName', title: '执行项目',width:250,wordBreak:"break-all"},
					{ field: 'itemInfo', title: '执行任务',width:180,
						formatter: function(itemInfo,row,index){
							itemInfo=eval("("+itemInfo+")");
							var itemExecutedCount=itemInfo.itemExecutedCount;
							var itemTotalCount=itemInfo.itemTotalCount;
							if ((itemExecutedCount>0)||(itemTotalCount>0)) {
								return "任务总数："+itemTotalCount+"；已执行："+itemExecutedCount;
							}else{
								return "";
							}
						},
						styler: function(itemInfo,row,index){
							itemInfo=eval("("+itemInfo+")");
							var itemExecutedCount=itemInfo.itemExecutedCount;
							var itemTotalCount=itemInfo.itemTotalCount;
							if ((itemTotalCount>0)&&(itemExecutedCount<itemTotalCount)) {
								return "background-color:#fda632;color:white;";
							}
						}
					},
					{ field: 'executeNote', title: '执行备注',width:95},
					{ field: 'freqName', title: '频次',width:100},
					{ field: 'executeUserName', title: '执行人',width:100},
					{ field: 'executeDateTime', title: '执行时间',width:140},
					{ field: 'insertDateTime', title: '开始时间',width:140},
					{ field: 'stopDateTime', title: '结束时间',width:140},
					{ field: 'transferDateTime', title: '转入护理记录时间',width:150},
					{ field: 'executeContent', title: '执行结果',width:250},
					{ field: 'tkStatusName', title: '状态',width:100}
					
			    ]];
			    return Columns
			}
		},
		tabsDoctorOrderExe:{
			id:"tabsDoctorOrderExe",
			name:"医嘱执行",
			iconCls:"icon-batch-add",
			className:"Nur.NIS.Service.OrderExcute.QueryOrder",
			methodName:"GetOrders",
			onDblClickRow:function(rowData){
				console.log(rowData)	
				var dataObj={
					startDate:$("#execStDate").datebox("getValue"),
					startTime:$("#execStTime").timespinner("getValue"),
					endDate:$("#execEndDate").datebox("getValue"),
					endTime:$("#execEndTime").timespinner("getValue")
				}
				var stdate = dataObj.startDate +' '+ dataObj.startTime
				var etDate = dataObj.endDate + ' ' + dataObj.endTime
				var h = $("#nrLayout").find(".tabs-panels").eq(0).height()
				var EpisodeIDS = resultPatIds() 
				var EpisodeID = EpisodeIDS.split("^")[0]

				
				
				TWstartDate = $("#execStDate").datebox("getValue");
				TWstartTime = $("#execStTime").timespinner("getValue");
				TWendDate = $("#execEndDate").datebox("getValue");
				TWendTime = $("#execEndTime").timespinner("getValue");
				TWsheetCode = rowData.exeItemId
				
				var curUrl = window.location.href.split("/csp/")[0] + "/csp/";
				var iframeUrl = curUrl + "dhc.nurse.vue.nis.csp?1=1&pageName=orderExcute/biz/excute"
				if(iframeUrl !=""){
					console.log(iframeUrl)
					var content = '<iframe scrolling="auto" frameborder="0"  src="'+iframeUrl+'" style="width:100%;height:'+h+'px;"></iframe>';
					addTab("",content)
				}
				
				
			},
			rtnParma:function(){
				var episodeIDStr = resultPatIds()
				var rtnData={
					 episodeIDStr: episodeIDStr,
					 currentSheetCode:"DefaultSee",
					 groupID:session['LOGON.GROUPID'],
					startDate:date_obj.startDate,
		 			startTime:date_obj.startTime,
		 			endDate:date_obj.endDate,
		 			endTime:date_obj.endTime,
					 hospID:session['LOGON.HOSPID'],
					 wardID:session['LOGON.WARDID'],
					 locID:session['LOGON.CTLOCID'],
					 doctorOrderFlag:true,
					 createOrderFlag:false,
					 orderType:"A",
					 excutedOrderFlag:false,
					 ifPrint:false,
					 longOrderFlag:false,
					 tempOrderFlag:false,
					 newCreateFlag:false,
					 newDisconFlag:false,
					 confirmFlag:"" 
				}
				
				return rtnData
			},
			tabTitles:function(tabsId){
				var thisTab = $('#'+tabsId).tabs('getSelected');    
				var data = json[tabsId].rtnParma()
				var param = $.extend(param,data)
				
				var locId = session['LOGON.CTLOCID']
				var hospId = session['LOGON.HOSPID']
				var groupId = session['LOGON.GROUPID']
				runClassMethod("Nur.NIS.Service.OrderExcute.SheetConfig","GetCurrentSheets",{groupID:groupId, locId:locId},
					function(tabsData){
						
					
						$HUI.tabs("#"+tabsId).add({
							title: '<span class="keyname" tabId="'+tabsId+'" tableId="table-'+tableId+'-0" key="WZX">未执行</span>'
						});	
			
						
						for(var i=0;i<tabsData.length;i++){
							var tab= tabsData[i]
							var tableId="table-"+tabsId+"-"+(i+0)
							if("WZX"==tab.code){
								continue	
							}
							$HUI.tabs("#"+tabsId).add({
								title: '<span class="keyname" tabId="'+tabsId+'" tableId="'+tableId+'" key="'+tab.code+'">'+tab.desc+'</span>'
							});
						}
						$("#"+tabsId).tabs('select',1);  
					
					},
				'json',false);
			},
			gridData:function(tabsId,gid,code){
				setTimeout(function(){
					var thisTab = $('#'+tabsId).tabs('getSelected'); 
					var tabs = $("#"+tabsId).tabs("tabs");//获得所有小Tab
					var tCount = tabs.length;
					var titleArr={}
					for(var i=0;i<tCount;i++){
						var title=tabs[i].panel('options').title
						var key = $(title).attr("key");
						if(!isUndefined(key)){
							titleArr[key]=i
						}
					}
					var data = json[tabsId].rtnParma()
					data.currentSheetCode=code
					var param = $.extend(param,data)
					runClassMethod("Nur.NIS.Service.OrderExcute.QueryOrder","GetOrders",param,function(rtn){
					 
						$("#"+gid).datagrid("unselectAll");
						$("#"+gid).datagrid('loadData', rtn.orders)
						var badgeIndex=[]
						if(rtn.orders.length>0){
							if(code!=""){
								badgeIndex.push(code)
							}
						}
						for(vcode in rtn){
							if(!isUndefined(titleArr[vcode])){
								badgeIndex.push(vcode)
							}
						}

						$("#"+tabsId).find(".tabItem_badge").remove();
						if(badgeIndex.length>0){
							for(var i=0;i<badgeIndex.length;i++){
								var scode=badgeIndex[i]
								var liIndex=titleArr[scode]
								$($("#"+tabsId).find("ul li")[liIndex]).append('<sup class="tabItem_badge"></sup>');	
							}
						}
						console.log(123)
						orderLeftNum(tabsId,data,rtn)
						
					},'json',true);
					
				}, 20);	
				
			},
			rtnColumns:function(){
				var Columns=[[
			  		<!--{ field: 'ID',title:'ID',width:100,wordBreak:"break-all",align:'center'},-->
			  		<!--{ field: 'ID', checkbox: 'true'},-->
					{ field: 'bedCode',title:'床号',width:150,wordBreak:"break-all"},
					{ field: 'regNo',title:'登记号',width:100,wordBreak:"break-all"},
					{ field: 'patName',title:'病人姓名',width:150,wordBreak:"break-all"},
					//{ field: 'createDateTime',title:'开医嘱时间',width:200,wordBreak:"break-all"},
					{ field: 'oecprDesc',title:'优先级',width:80,wordBreak:"break-all"},
					{ field: 'disposeStatCode',title:'处置状态',width:150,wordBreak:"break-all",
						formatter:function(value,row,index){
							var disposeStatCode=""
							//var ahtml=""
							var statCodeArr={}
							var statCodeHtmlArr={}
							if(!isUndefined(row.execInfos)){
								var len = row.execInfos.length
								if(len>0){
									//ahtml = '<span class="excuteState_num">'+len+'</span>'	
									//row.disposeStatCode = row.execInfos[0].disposeStatCode
								}
								
								for(var i=0;i<len;i++){
									var stcode=row.execInfos[i].disposeStatCode
									var isExitCode=statCodeArr[stcode]
									if(isUndefined(isExitCode)){
										statCodeArr[stcode]=1
									}else{
										var codeNum=statCodeArr[stcode]
										statCodeArr[stcode]=codeNum+1
									}
								}
								for(key in statCodeArr){
									var codeNum=statCodeArr[key]
									statCodeHtmlArr[key]='<span class="excuteState_num">'+codeNum+'</span>'	
								}
								//statCodeArr.push(row.execInfos[i].disposeStatCode)
							}else{
								statCodeHtmlArr[row.disposeStatCode]='<span class="excuteState_num"></span>'	
							}
							
							
							
							var stateArr={
								"NeedToStop":{"name":"需处理停止","bgcolor":"#20BF97"},
								"NeedToDeal":{"name":" 需处理医嘱","bgcolor":"#9FC5E8"},
								"LongUnnew":{"name":" 非新长嘱","bgcolor":"#93C47D"},
								"Temp":{"name":" 临时医嘱","bgcolor":"#F9CB9C"},
								"LongNew":{"name":" 新开长嘱","bgcolor":"#7CBB56"}
								}
							var html=""
							for(var key in statCodeHtmlArr){
								var statCode=key
								var ahtml=statCodeHtmlArr[key]
								var state=stateArr[statCode]
								if(isUndefined(state)){
									state={"name":statCode,"bgcolor":"#9FC5E8"}
								}
								
								html=html+'<a name="tabsDoctorOrderExe" id= "' + index + '" class="excuteState_disposeState" onmouseover="ShowOrderExe(this)" style="background-color: '+state.bgcolor+';">'
								html=html+state.name
								html=html+'<span class="excuteState_triangle" style="border-right-color: '+state.bgcolor+';"><span class="excuteState_circle"></span></span>'
								html=html+ahtml
								html=html+"</a>"
							}
							return html
						}
					},
					{ field: 'arcimDesc',title:'医嘱名称',width:300,wordBreak:"break-all",
						formatter: function(value,row,index){
							var values=[]
							values.push('<span style="font-weight:bold">'+value+'</span>')
							if(row.childs.length>0){
								
								for(var i=0;i<row.childs.length;i++){
									var childOrder=row.childs[i]
									var childArcimDesc=childOrder.arcimDesc
									//value=value+","+childArcimDesc
									values.push('<span>'+childArcimDesc+'</span>')
								}	
							}
							
							var text = '',style='';
							
							var html='<span style="font-weight:bold;color:#F37476;margin-left: 10px;">'+row.lastExecTimes+'</span>'
							var jiHtml='<span class="orderArcimDesc_sealSpanWrapper"><span class="orderArcimDesc_sealSpan is-emergency">急</span></span>'
							
							
							if(values.length==1){
								for (var j = 0; j < values.length; j++) {
									var desc=values[j]
									text += '<div style="margin:5px 0 0 5px">' + desc +html+ '</div>';
								}
							}else{
								for (var j = 0; j < values.length; j++) {
									var desc=values[j]
									text += '<div style="display:flex">'
									text += '<div>'
									text += '<div class="left-bracket"' + style + '></div>'
									text += '<div class="right-bracket"' + style + '></div>'
									text += '</div>';
									text += '<div style="margin:5px 0 0 5px">'+desc+'</div>';
									text += '</div>';
								}
							}
							text = '<div class="arcimdesc" style="padding: 5px 0px 5px 0px">' + text +'</div>';
							return text
							return value +""+row.disposeStatCode+row.lastExecTimes
						}
					},
					{ field: 'notes',title:'备注',width:200,wordBreak:"break-all"},
					{ field: 'doseQtyUnit',title:'剂量',width:100,wordBreak:"break-all"},
					{ field: 'phcfrCode',title:'频率',width:100,wordBreak:"break-all"},
					{ field: 'phcinDesc',title:'用药途径',width:100,wordBreak:"break-all"},
					{ field: 'phOrdQtyUnit',title:'总量',width:100,wordBreak:"break-all"}
			
			    ]];	
				return 	Columns
			}
			
		}	
		
	}

function rtnDataList(rtn,rtnlist){
	//var rtnlist=[]
	for(var i=0;i<rtn.orders.length;i++){
		var exeInfoList=rtn.orders[i].execInfos
		
		if(isUndefined(exeInfoList)){
			var sttDateTime=rtn.orders[i].createDateTime
			var planData={
					exeDate:sttDateTime.split(" ")[0],
					exeTime:sttDateTime.split(" ")[1]
				}
			rtnlist.push(planData)
		}else{
		
			for(var j=0;j<exeInfoList.length;j++){
				var exeInfo=exeInfoList[j]
				var sttDateTime=exeInfo.sttDateTime
				var planData={
					exeDate:sttDateTime.split(" ")[0],
					exeTime:exeInfo.sttTime
				}
				rtnlist.push(planData)
			
			}
		}
	
	}
	return rtnlist
}

function orderLeftNum(tabsId,data,rtn){
	var wzxList=[]
	var defauleSeeList=[]
	if(data.currentSheetCode=="WZX"){
		data.currentSheetCode="DefaultSee"
		wzxList=rtnDataList(rtn,wzxList)
	}else if(data.currentSheetCode=="DefaultSee"){
		data.currentSheetCode="WZX"
		defauleSeeList=rtnDataList(rtn,defauleSeeList)
	}else{
		data.currentSheetCode="WZX^DefaultSee"
	}
	var codesplit=data.currentSheetCode.split("^")
	
	//data.startDate=$("#execStDate").datebox("getValue")
	//data.startTime=$("#execStTime").timespinner("getValue")
	//data.endDate=$("#execEndDate").datebox("getValue")
	//data.endTime=$("#execEndTime").timespinner("getValue")

	
	for(var codeI=0;codeI<codesplit.length;codeI++){
		data.currentSheetCode=codesplit[codeI]
		var param=""
		var paramWzx = $.extend(param,data)
		runClassMethod("Nur.NIS.Service.OrderExcute.QueryOrder","GetOrders",paramWzx,function(rtn){
			
			if(data.currentSheetCode=="WZX"){
				wzxList=rtnDataList(rtn,wzxList)
				
			}
			if(data.currentSheetCode=="DefaultSee"){
				defauleSeeList=rtnDataList(rtn,defauleSeeList)
			}
			
		},'json',false)
	}
	
	leftMData(tabsId,wzxList)		
	var txt=wzxList.length+"+"+defauleSeeList.length
	$(".taskCount[tableName="+tabsId+"]").find(".taskNum").html(txt)	
	
	
	
}

function isUndefined(value){
	return typeof(value) =="undefined"
}
$(function(){
	setDateValue()
	
	
	init()

})




var initflag=0
function init(){
	
	var t2 = window.setInterval(function() {
		var patIds = resultPatIds()
		
		if(patIds!=""){
			window.clearInterval(t2)  // 去除定时器
			//getGridRecord()
			//console.log(1)
			//$("#serachBtn").trigger("click")
			//初始化
			console.log(1)
			loadTab()
			console.log(2)
			//初始化数据
			$("#serachBtn").trigger("click")
			console.log(3)
			
		}
	
	},1000)
	
}



function loadTab(){
	
	for(var tabsId in json){
		console.log(tabsId)
		
		if(isUndefined(json[tabsId])){
			continue;	
		}
		
		var title = json[tabsId].name
		var iconCls=json[tabsId].iconCls
		$HUI.tabs("#"+tabsId).add({
			title: title,
			iconCls:iconCls   		
		});
		json[tabsId].tabTitles(tabsId)
		var tab = $('#'+tabsId).tabs('getSelected');
		if(tab==null){
			continue;	
		}
		var title = tab.panel('options').title
		var key = $(title).attr("key")
		var tableId = $(title).attr("tableId")
		var tabId = $(title).attr("tabId")
		$HUI.tabs("#"+tabId).update({
			tab:tab,
			options:{
				content:'<table id="'+tableId+'"></table>'
			}	
		});
		getGridData.list(tabId,tableId,key)
	}
	
}
var date_obj={
	startDate:"",	
	startTime:"",
	endDate:"",
	endTime:"",
}
function setDateObj(){
	date_obj={
		startDate:$("#execStDate").datebox("getValue"),
		startTime:$("#execStTime").timespinner("getValue"),
		endDate:$("#execEndDate").datebox("getValue"),
		endTime:$("#execEndTime").timespinner("getValue")
	}
}

$("#serachBtn").on("click",function(){
	leftM()
	setDateObj()
	for(var tabsId in json){
		if(isUndefined(json[tabsId])){
			continue;	
		}
		var tab = $('#'+tabsId).tabs('getSelected');
		if(tab==null){
			continue;	
		}
		var title = tab.panel('options').title
		var key = $(title).attr("key")
		var tableId = $(title).attr("tableId")
		var tabId = $(title).attr("tabId")
		$HUI.tabs("#"+tabId).update({
			tab:tab,
			options:{
				content:'<table id="'+tableId+'"></table>'
			}	
		});
		getGridData.list(tabId,tableId,key)
		json[tabId].gridData(tabId,tableId,key)
		$('#'+tabsId).tabs({  
			onSelect:function(title,index){   
				setDateObj() 
				var key = $(title).attr("key");
				var tabId = $(title).attr("tabId")
				var tableId = $(title).attr("tableId")
				var tab = $('#'+tabId).tabs('getSelected');
				
				$HUI.tabs("#"+tabId).update({
					tab:tab,
					options:{
						content:'<table id="'+tableId+'"></table>'
					}	
				});
				
				getGridData.list(tabId,tableId,key)
				json[tabId].gridData(tabId,tableId,key)
			}
		})
		
	}
		
})

 function resultPatIds(){
 	var slen = $("#patient_search").length
	var episodeIDArr=[];
	var nodes = $('#patientTree').tree('getChecked');
	var str = getAllCheckedPatient()
	if(nodes.length > 0){
		for(var i = 0; i < nodes.length; i++){
			if(typeof(nodes[i].episodeID) != "undefined"){
				episodeIDArr.push(nodes[i].episodeID);
			}	
		}
		episodeIdStr = episodeIDArr.join("^");	
	}else{
		episodeIdStr = "";
	}
	return episodeIdStr;
}



var getGridData={
	
	list:function(tabsId,gid,code){
		var fitColumns=false
		if(!isUndefined(json[tabsId].fitColumns)){
			fitColumns=true
		}
		
		$("#"+gid).datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : true,
			fitColumns : fitColumns,		//表格是否自定义宽度
			autoRowHeight : false,
			loadMsg : '加载中..',  
			pagination : true, 		//是否开启分页
			rownumbers : true,//是否开启行号
			idField:"ID",
			pageSize: 10,//分页数量
			pageList : [10,50,100,200],
			columns :json[tabsId].rtnColumns(),
			autoRowHeight:true,
			nowrap:false,  /*此处为false*/
			/*url : $URL+"?ClassName="+json[tabsId].className+"&MethodName="+json[tabsId].methodName,
			onBeforeLoad:function(param){
				var data = json[tabsId].rtnParma()
				console.log(data)
				param = $.extend(param,data)
			},*/
			onLoadSuccess:function(rowData){
				
				var lenA=$("#"+tabsId).find("div.datagrid-pager.pagination").length
				var lenB=$("#"+tabsId).find("div.datagrid-pager.pagination").find("table tr").length
				$("#"+tabsId).find("div.datagrid-pager.pagination").find("table tr").append('<td class="panelIcon" style="position: relative;"><div class="panel-icon icon-batch-cfg"></div></td>')
			},
			onDblClickRow:function(rowIndex, rowData){
				console.log(rowData)
				
				json[tabsId].onDblClickRow(rowData)
				
				
			}
		}).datagrid({loadFilter:DocToolsHUINur.lib.pagerFilter})
		
		/*setTimeout(function(){
			var thisTab = $('#'+tabsId).tabs('getSelected');    
			var data = json[tabsId].rtnParma()
			data.currentSheetCode=code
			var param = $.extend(param,data)
			runClassMethod(json[tabsId].className,json[tabsId].methodName,param,function(rtn){
			
				$("#"+gid).datagrid("unselectAll");
				$("#"+gid).datagrid('loadData', rtn.orders)
			},'json',false);
		}, 20);*/
	},
	columns:function(gid){
		
	}
}
function addTab(title, content){
		if ($('#main-tabs').tabs('exists', title)){
			$('#main-tabs').tabs('select', title);
		} else {
			$HUI.tabs("#main-tabs").add({
				title: title,
				content: content,
				closable:true  		
			});
			
		}
	}

var DocToolsHUINur={
	lib:{
		pagerFilter:function pagerFilter(data){
			if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
				data = {
					total: data.length,
					rows: data
				}
			}else{
				if(typeof(data.rows)=='undefined'){
					var arr = []
					for (var i in data){
						arr.push(data[i])
					}
					data = {
						total: arr.length,
						rows: arr
					}
				}
			}
			var dg = $(this);
			var opts = dg.datagrid('options');
			var pager = dg.datagrid('getPager');
			pager.pagination({
				showRefresh:false,
				onSelectPage:function(pageNum, pageSize){
					opts.pageNumber = pageNum;
					opts.pageSize = pageSize;
					pager.pagination('refresh',{
						pageNumber:pageNum,
						pageSize:pageSize
					});
					dg.datagrid('loadData',data);
					dg.datagrid('scrollTo',0); //滚动到指定的行  
					    
				}
			});
			if (!data.originalRows){
				data.originalRows = (data.rows);
			}
			if (opts.pagination){
				if (data.originalRows.length>0) {
					var start = (opts.pageNumber==0?1:opts.pageNumber-1)*parseInt(opts.pageSize);
					if ((start+1)>data.originalRows.length){
						//取现有行数最近的整页起始值
						start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
						opts.pageNumber=(start/opts.pageSize)+1;
					}
					//解决页码显示不正确的问题
					$.extend($.data(pager[0], "pagination").options,{pageNumber:opts.pageNumber});
					
					var end = start + parseInt(opts.pageSize);
					data.rows = (data.originalRows.slice(start, end));
				}
			}
			//console.log(data)
			return data;
		}
	}
}


	function setDateValue(){
		var opt = $("#execStDate").datebox('options');
		opt.maxDate = formatDate(1);
		$("#execStDate").datebox("setValue",formatDate(0));
		$("#execEndDate").datebox("setValue",formatDate(0));
		var optB = $("#execEndDate").datebox('options');
		//optB.minDate = formatDate(0); 
	};
	function formatDate(t){
		var curr_Date = new Date();  
		curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
		var Year = curr_Date.getFullYear();
		var Month = curr_Date.getMonth()+1;
		var Day = curr_Date.getDate();
		//return Year+"-"+Month+"-"+Day;
		
		if(typeof(DateFormat)=="undefined"){ //2017-03-15 cy
			return Year+"-"+Month+"-"+Day;
		}else{
			if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY 2017-03-07 cy
				return Day+"/"+Month+"/"+Year;
			}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
				return Year+"-"+Month+"-"+Day;
			}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
				return Month+"/"+Day+"/"+Year;
			}else{ //2017-03-15 cy
				return Year+"-"+Month+"-"+Day;
			}
		}
	}
<!--初始化时间end-->



function updateSbgTableSize() {
    var n = 0;
    var timer = setInterval(function() {
	   
        clearInterval(timer);
    window.parent.location.reload()
            
       
    }, 200);
}
window.addEventListener("resize", updateSbgTableSize)


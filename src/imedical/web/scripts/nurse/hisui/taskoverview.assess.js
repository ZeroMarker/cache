
// 初始化
function init() {
  var startMVSDay=window.startDateTime.split(' ')[0];
  var startMVSTime=window.startDateTime.split(' ')[1];
  var endMVSDay=window.endDateTime.split(' ')[0];
  var endMVSTime=window.endDateTime.split(' ')[1];
  $('#startMVSDay').datebox('setValue', startMVSDay);
  $('#endMVSDay').datebox('setValue', endMVSDay);

}
function addTab(title, id){
	if ($('#opeTabs').tabs('exists', title)){
		$('#opeTabs').tabs('select', title);
	} else {
		$HUI.tabs("#opeTabs").add({
			title: title
		})	
	}
	

}

function initList(){
	
	var startMVSDay		= 	$('#startMVSDay').datebox('getValue');
	var endMVSDay 		= 	$('#endMVSDay').datebox('getValue');
	$cm({
    	ClassName: 		'Nur.NIS.Service.VitalSign.TaskRule',
    	MethodName: 	'GetRsDate',
    	startDate: 		startMVSDay,
    	endDate: 		endMVSDay
  	}, function (res) {
	  	for(var i in res){
			var text = res[i]  	
		  	addTab(text,"tabs"+i)
		} 
		
		$('#opeTabs').tabs({
		  onSelect:function(title,index){
			  	var tab = $HUI.tabs("#opeTabs").getTab(index)
			  	$HUI.tabs("#opeTabs").update({
					tab:tab,
					options:{
						content: '<table title="'+title+'" id="tabs'+index+'"></table>'	
					}	
				});
				dataList()
			}  	
	    });	    
	    $('#opeTabs').tabs('unselect', 0);
	    $("#opeTabs").tabs('select',0);  
		
	 })
}
  // 获取患者信息
  var patientList = {};
  function rspatientList(){
	  $cm({
	    	ClassName: 'Nur.NIS.Service.VitalSign.TaskRule',
	    	MethodName: 'GetPatientsByEpisodeIDs',
	    	EpisodeIDs: episodeIDsStr
	  }, function(res) {
	  		for(var i in res){
				var episodeID = res[i].episodeID
				patientList[episodeID] = res[i]  	
			}
			//dataList()
	  });
  }
  var template = {}
  var values={}
function dataList(){
	

	
	var rowA = []
	var rowB=[];

	var dataList=[]
	
	var tabSed = $("#opeTabs").tabs('getSelected')
	var tabId = tabSed.find("table").attr("id")
	var title = tabSed.find("table").attr("title")
	var startMVSDay = title;
	var endMVSDay = title;
	
	console.log(startMVSDay)
	var locID = session['LOGON.CTLOCID']
	$cm({
    	ClassName: 'Nur.NIS.Service.ExecuteSummary.NeedExeTask',
    	MethodName: 'GetPGTempDateMeasureByDay',
    	episodeIDS:episodeIDsStr,
    	startDate: startMVSDay,
    	endDate: endMVSDay,
    	locID:locID
  	}, function (res) {
	  	console.log(res)
	  	var allneeds = res.body.all
	  	console.log(allneeds)
	  	var values={}
	  	var codeTimes={}
	  
	  	var codeObj={}
	  	var timeObj = {}
	  	for(var i in allneeds){
			var name = allneeds[i].name;
			var code = allneeds[i].emrCode;
			var list = allneeds[i].list;
			var tempName = allneeds[i].templateName;
			template[code] = {'tempName':tempName,'name':name}

			var timeArrs = []
			for(var j in list){
				var episodeID = list[j].episodeID
				var longtime = list[j].time
				if(timeArrs.indexOf(longtime)<0){
					timeArrs.push(longtime)
				}
				timeObj[longtime] = list[j].timeStr;
				var key = episodeID+code+longtime
				values[key] = list[j]
					
			}
			codeObj[code] = timeArrs
	  	}

	  	for(var code in codeObj){

		  	var timeArrs = codeObj[code]
		  	var name = template[code].name
		  	var tempName = template[code].tempName
			var count = 0
		  	for(var i in timeArrs){
			  	count=count+1
			  	var longtime = timeArrs[i]
			  	var field = code+longtime
		  		var jsn = {title:timeObj[longtime],field:field,align:'center',width:80,
					styler:function(value,row,index){
						if(value=="无"){
							return 'background-color:#ccc;'
						}
					
					},
					formatter: function(value,row,index){
						if(value=="无"){
							return ''
						}
						return value
					
					}
				}	
				rowB.push(jsn)
		  	}
		  	if(count>0){
		  		rowA.push({title:name,align:'center',colspan:timeArrs.length})
		  	}
		  	
		}
	  	
	  	
	  	var patients = episodeIDsStr.split("^")
	  	//获取列表数据
		var dataList = []
		for(var m in patients){
			var eid = patients[m]
			var patient = patientList[eid]
			
			var pname = patient.name
			var pbedcode = patient.bedCode
			var jns ={"bedNo":pbedcode,"name":pname,"eid":eid}
			for(var n in rowB){
				var fid = rowB[n].field
				var key = eid+fid
				var val = typeof(values[key])!="undefined" ? values[key].value :"无"
				jns[fid] = val
				jns[key] = values[key]
				
			}
			 dataList.push(jns)
			
		}
	  	pushGrid(tabId,dataList,rowA,rowB)
	 })
}
//页面检索事件
	$("#serachBtn").on("click",function(){
		getAllCheckedPatientA()
				
	})


function pushGrid(id,data,rowA,rowB){
			var columns = [
                [
                    { field: 'bedNo', title: '床号', align: 'center', rowspan: 2, width: 100,maxWidth:100 },
                    { field: 'name', title: '姓名', align: 'center', rowspan: 2, width: 100,maxWidth:100 }
                ],
                rowB
               
            ];
            
            
            
            console.log(rowA)
            for(var i in rowA){
	        var obj = rowA[i]
	           columns[0].push(obj)
	        }
            var dataGridOption = {
                rownumbers: true,
                columns: columns,
                singleSelect : true,
                fit : true,
				
                onDblClickCell:function(index, field, value) {
					
					var rows = $(this).datagrid('getRows');//获得所有行
		            var row = rows[index];//根据index获得其中一行。
		            //var templateName = row.tempNames[field]
		            //var emrCode = row.codes[field]
					var key = row.eid+field
		            var templateName = row[key].templateName
		            var emrCode = row[key].itemId
		            var assessId = row[key].assessId
		            var appendUrl=""
		            if(assessId!="" && typeof(assessId)!="undefined"){
			            appendUrl = "&NurMPDataID="+assessId
			        }
					websys_createWindow(templateName+".csp?EmrCode="+emrCode+"&EpisodeID="+row.eid+appendUrl,"患者评估信息","width=96%,height=90%")		

				},
				onLoadSuccess: function () {
		            var table = $(this).prev().find('table')
		            var posDivs = table.eq(0).find('div.datagrid-cell')//表头用来定位用的div
		            var bodyFirstDivs = table.eq(1).find('tr:eq(0) div') //内容第一行用来设置宽度的div，以便设置和表头一样的宽度
		            var orderHeader = posDivs.map(function (index) { return { index: index, left: $(this).position().left} }); //计算表头的左边位置，以便重新排序和内容行单元格循序一致
		            orderHeader.sort(function (a, b) { return a.left - b.left; }); //对表头位置排序

		            setTimeout(function () {//延时设置宽度，因为easyui执行完毕回调后有后续的处理，会去掉内容行用来设置宽度的div的css width属性
		                for (var i = 0; i < orderHeader.length; i++) {
			                var wid = posDivs.eq(orderHeader[i].index).parents("td").width()

		                    bodyFirstDivs.eq(i).parents("td").css('min-width', wid+"px");
		                }
		            }, 50);
		        },
            };

            $('#'+id).datagrid(dataGridOption);
            
            $('#'+id).datagrid('loadData', {
				rows: data,
				ret: "OK"
			});
     	
}



$(function() {
	if(episodeIDsStr==""){
		setTimeout(function(){
			
			
			if(window.startDateTime==""){
		
				window.startDateTime = formatDate(0)+" 00:00"	
			}
			if(window.endDateTime==""){
				
				window.endDateTime = formatDate(0)+" 23:59"	
			}
			getAllCheckedPatientA()
			
			
			},1000)
		
		
	}else{
		
		init();
	rspatientList()
	initList();	
	}
	
	

	
	
});
function getAllCheckedPatientA(){	
	var array=[];
	var EpisodeIDStr="";
	var nodes = $('#patientTree').tree('getChecked');
	if(nodes.length > 0){
		for(var i = 0; i < nodes.length; i++){
			if(nodes[i].episodeID) array.push(nodes[i].episodeID);	
		}
		episodeIDsStr = array.join("^");	
		init();
		rspatientList()
		initList();
	}else{
		pats()
	}
	console.log(episodeIDsStr)
	
}

function pats(){
	$cm({
				ClassName: "Nur.NIS.Service.Base.Ward",
				MethodName: "GetWardPatientsNew",
				wardID: session['LOGON.WARDID']
	}, function(data) {
		var array=[]
		for(var i=0;i<data.length;i++){
			var child = data[i].children
			for(var j=0;j<child.length;j++){
				array.push(child[j].episodeID)
			}
		}	
		episodeIDsStr = array.join("^");
		init();
			rspatientList()
			initList();
	},false)	
}

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


var t = $(".hisui-layout").height()

var st = $(".search").outerHeight()
$("#opeTabs").css({height:(t)+"px"})

window.addEventListener("resize",ResetDomSize);
function ResetDomSize(){
	$(".hisui-layout").layout("resize").layout('panel', 'center').panel('resize',{height:'100%',width:'100%'});
	$("#TaskPlanExecute-panel").panel("resize",{height:$(window).height()-8,width:'100%'});
	$('#NurPlanTaskTab').datagrid("resize");
}

//window.addEventListener("resize",updateDomSize)

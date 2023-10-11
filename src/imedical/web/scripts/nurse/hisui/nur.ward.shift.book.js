var DetailMsg=$g("请在明细区域选择一条交班班次记录！")
var AreaMsg=$g("请在统计区域选择一条交班班次记录！")
var TiShi=$g("提示")
function CloseDialog(id){
	$HUI.dialog("#"+id).close()	
}
//撤销护士签名
function hzqmcx(that){
	$.messager.confirm($g('确认'),$g('您确认想要撤销吗？'),function(r){    
		if (r){
			
			
			
			var params={
				PatientID:$(that).attr("PatientID"),
		        SignUserID:$(that).attr("UserID"),
		        NurseID:$(that).attr("NurseID"),
		        TimeID:$(that).attr("TimeID"),
		        Field:$(that).attr("SignName"),
		        ShiftID:GLOBAL.ShiftID
			}
			runClassMethod("Nur.SHIFT.Service.ShiftController","ShiftMagicClearHzqm",{data:JSON.stringify(params)},function(rtn){
				if(rtn == 0) {
					$.messager.popover({ msg: $g('撤销签名成功'), type: 'success', timeout: 1000 });
					
				}else if(rtn==1){
					$.messager.popover({ msg: $g('只有签名护士可以撤销'), type: 'error', timeout: 1000 });
				
				}else if(rtn==2){
					$.messager.popover({ msg: $g('只能撤销本人签名'), type: 'error', timeout: 1000 });
				
				}
				$(".detail-project li.libgselect").trigger("click")
				
			},'json',true);
			
			
			
			
		}
	})
}

///交班引用
function referHandler() {
	
    var row = $("#shiftBookDetail").datagrid("getSelected");
	if (!row) {
		$.messager.alert($g("提示"),$g("请在明细区域选择一条班次记录！"));
		return false;
	}
    
    
    
    var episodeID = row.PatientID;
    var url = "nur.hisui.nurseRefer.comm.csp?EpisodeID=" + episodeID + "&Tabs=Know,Diag,Order,Exec,Obs,Lis,Pacs,Epr,Chars,Record1"+"&MWToken="+websys_getMWToken();
    $('#dialogRefer').dialog({
        title: $g('引用'),
        width: $(window).width() - 100,
        height: 600,
        top:100,
        cache: false,
        content: "<iframe id='iframeRefer' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
        modal: true,
        closed:true,buttons:[{
			text:$g('关闭'),
			iconCls:'icon-w-close',
			id: 'btnClose',
			handler:closeHandler
		},{
			text:$g('清屏'),
			iconCls:'icon-w-clean',
			id: 'btnClear',
			handler:clearHandler
		},{
			text:$g('引用'),
			iconCls:'icon-w-edit',
			id: 'btnRefer',
			handler:sureReferHandler
		}]
    });
    $("#dialogRefer").dialog("open");

}

function closeHandler(){
	$('#dialogRefer').dialog('close');
}
function clearHandler(){
	var iframeRefer=$('#iframeRefer')[0].contentWindow
	iframeRefer.$('#editor').text("");
	iframeRefer.$('#textEdit').val("");
}
function sureReferHandler(){
	var iframeRefer=$('#iframeRefer')[0].contentWindow
	
    var editContent = iframeRefer.$('#textEdit').val();
    if(editContent=="" || typeof(editContent)=="undefined"){
    	editContent = iframeRefer.$('#editor').val();
    }
    if(editContent=="" || typeof(editContent)=="undefined"){
    	editContent = iframeRefer.$('#editor').text();
    }
    
    
    if (!editContent) {
        //alert('没有要引用的内容!');
        $.messager.alert($g('提示'), $g('没有要引用的内容!'));
        return;
    }
    if (!curElement) {
        // $.messager.popover({ msg: '请选择需要引用的元素！', type:'error'});
        //return;
    }
    var curPosition = getCursortPosition(curElement);
    updateRefer(curElement, editContent, curPosition);
    closeHandler();
}
function GetLastContent(that){
	var ShiftPatientID=$(that).attr("id")
	var FildName=$(that).attr("field")
	//alert(ShiftID+","+field)
	runClassMethod("Nur.SHIFT.Service.ShiftController","GetLastFildText",{"ShiftPatientID":ShiftPatientID,"FildName":FildName},function(rtn){
		///插入交班日志
		var curPosition = getCursortPosition(curElement);
    	updateRefer(curElement, rtn, curPosition);
		
	},"text",true)
	
}
var isExitmwin=0
$(function(){
	var mwin = ("undefined" != typeof window.websys_getMenuWin_origin) ? websys_getMenuWin_origin() : websys_getMenuWin();
	var screens = typeof websys_getMWScreens == 'function' ? websys_getMWScreens().screens : [];
	if ((mwin.DisableSecondScreen == false) && ((screens.length > 1) || ((screens.length == 1) && (screens[0].PrimaryScreen == true))) && (typeof websys_emit == 'function')) {
		isExitmwin=1
	}	
	
})
var DetailMsg="请在明细区域选择一条交班班次记录！"
var AreaMsg="请在统计区域选择一条交班班次记录！"
function referHandlerEmr() {
   
    var tabs=['Know','Diag','Order','Exec','Obs','Lis','Pacs','Epr','Record1','Record2','Symbol','Shift']
   
    var row = $("#shiftBookDetail").datagrid("getSelected");
	if (!row) {
		$.messager.alert($g("提示"),$g(DetailMsg));
		return false;
	}
    
    
    
	if(isExitmwin==1){	
		$cm({
	        ClassName: 'NurMp.Common.Logic.Handler',
	        MethodName: 'Find',
	        ClsName: 'CF.NUR.EMR.ReferView',
	        TableName: 'Nur_IP_ReferTab',
	        HospId: session['LOGON.HOSPID']
	    }, function (viewSetting) {
	        var tabwidth = '50%';
	        var listwidth= '50%';
	        if ((!$.isEmptyObject(viewSetting)) && (viewSetting.status > -1) && (!!viewSetting.data)) {
	            if (!!viewSetting.data.RVPanelTab) {
	                tabwidth = viewSetting.data.RVPanelTab + '%';
	            }
	            if (!!viewSetting.data.RVTabList) {
	                listwidth = viewSetting.data.RVTabList + '%';
	            }
	        }
	        var opt = { EpisodeID:row.PatientID, Tabs:tabs, TabWidth:"", ListWidth:listwidth, ModelId:GetQueryString('ModelId'), VerFlag: '1'};
	    	websys_emit("onOpenRecordRefer", opt);
	    })
		
		
		
		return false;
    }else{
	    var episodeID = row.PatientID;
    	referHandlerEmrs(episodeID,tabs)
	}
   

}
websys_on("onRecordRefer",function(data){
	var editContent=data.EditContent
	//alert(editContent)
	var curPosition = getCursortPosition(curElement);
    updateRefer(curElement, editContent, curPosition);
    closeHandler();
});
function referHandlerEmrs(EpisodeID,tabs) {
        var dgwidth = $(window).width() - 100;
        var dgheight = $(window).height() - 150;
        var winwidth = dgwidth * 0.5;
        // 样式设置
        viewSetting = $cm({
            ClassName: 'NurMp.Common.Logic.Handler',
            MethodName: 'Find',
            ClsName:'CF.NUR.EMR.ReferView', 
            TableName:'Nur_IP_ReferTab', 
            HospId:session['LOGON.HOSPID']
        }, false);
        if ((!$.isEmptyObject(viewSetting)) && (viewSetting.status > -1) && (!!viewSetting.data)) {
            if (!!viewSetting.data.RVPanelTab) {
                winwidth = ($(window).width() - 100) * (viewSetting.data.RVPanelTab / 100);
            }
        }
        var listwidth = winwidth * 0.4;
        if ((!$.isEmptyObject(viewSetting)) && (viewSetting.status > -1) && (!!viewSetting.data)) {
            if (!!viewSetting.data.RVTabList) {
                listwidth = (winwidth) * (viewSetting.data.RVTabList / 100);
            }
        }
        debugger;
       var url = "nur.hisui.nurseRefer.comm.csp?EpisodeID=" + EpisodeID + "&Tabs=" + tabs + "&WinWidth=" + winwidth+ "&ListWidth=" + listwidth + "&ModelId=" + GetQueryString("ModelId")+"&MWToken="+websys_getMWToken();
         //var url = "nur.hisui.shift.Refer.csp?EpisodeID=" + EpisodeID +"&MWToken="+websys_getMWToken();
        
        $('#dialogRefer').dialog({
            title: $g('引用'),
            width: dgwidth,
            height: dgheight,
            cache: false,
            content: "<iframe id='iframeRefer' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
            modal: true,
            closed:true,buttons:[{
			text:$g('关闭'),
			iconCls:'icon-w-close',
			id: 'btnClose',
			handler:closeHandler
		},{
			text:$g('清屏'),
			iconCls:'icon-w-clean',
			id: 'btnClear',
			handler:clearHandler
		},{
			text:$g('引用'),
			iconCls:'icon-w-edit',
			id: 'btnRefer',
			handler:sureReferHandler
		}]
        });
        $("#dialogRefer").dialog("open");
        
       
        
    }



function updateRefer(curElement, editContent, curPosition) {
    var startText = curPosition == 0 ? '' : curElement.value.substring(0, curPosition);
    if (startText.trim() == '/') {
        startText = '';
    }
    var endText = curElement.value.substring(curPosition);
    curElement.value = startText + editContent + endText;
}
function getCursortPosition(obj) {
    var cursorIndex = 0;
    if (document.selection) {
        // IE Support
        obj.focus();
        var range = document.selection.createRange();
        range.moveStart('character', -obj.value.length);
        cursorIndex = range.text.length;
    } else if (obj.selectionStart || obj.selectionStart == 0) {
        // another support
        cursorIndex = obj.selectionStart;
    }
    return cursorIndex;
}
/**引用代码end**/

function setWardSort(value){
	var getValues=$("#SortFildName").combo("getValues")
	//$("#sortFilde").combobox("setValues",getValues)
	var Values=""
	if(value){
		Values=getValues.join(",")
	}
	var ShiftBookID=GetShiftBookID()
	runClassMethod("Nur.SHIFT.Service.ShiftDetailController","SetDefalutSort",{WardID:GLOBAL.WardID,ShiftBookID:ShiftBookID,Values:Values},function(rtn){	
		
		if(rtn==0){
			$.messager.popover({msg:$g('保存成功'),type:'success'});
		}
	},'json',true)
	
	
}

function GetShiftTip(that){
	$(that).popover({title:$g('提示'),trigger:'hover',content:$g('交班项目有新增记录,点击按钮进行查看！')});
}
function GetShiftStopTip(that){
	setTimeout(function(){
		$("#shiftBookDetail").datagrid("clearSelections");
		$("#shiftBookDetail").datagrid("unselectAll");
		
		//$(that).popover({title:'提示',trigger:'hover',content:'当前班次已禁止带入交班术语'});
		//$(that).popover({title:'提示', content: $g('当前班次已禁止带入交班术语'),trigger:'hover' });
		
		
		var idStr=$(that).attr("ItemRecordID")
		var ids=idStr.split(",")
		var gridData=[]
		for(var i=0;i<ids.length;i++){
			var id=ids[i]
			var record=ShiftItemRecord[id]
			gridData.push(record)
		}
		
		
		
		
		$('#dialogRefer').dialog({
	        title: $g('变更情况'),
	        width: 500,
	        height: 300,
	        top:100,
	        cache: false,
	        content: "<table id='mark'></table>",
	        modal: true,
	        onLoad: function () {},
       		onBeforeClose: function () {},
        	onOpen: function () {
           		$("#mark").datagrid({
					fit:true,
					singleSelect : true,
					fitColumns:true,
					idField:"ID",
					rownumbers : true,
					columns :[[
					
						{field:'TimeName',title:$g('班次名称'),width:100,formatter:function(value,row,index){return $g(value)}},
						{field:'ProjectName',title:$g('交班项目'),width:100,formatter:function(value,row,index){return $g(value)}},
						{field:'CreateDate',title:$g('日期'),width:100},
						{field:'CreateTime',title:$g('时间'),width:100},
						{field:'Source',title:$g('来源'),width:100,
						formatter:function(value,row,index){
							if(value==1){
								return $g("系统生成")	
							}
							if(value==2){
								return $g("手动录入")	
							}
							     
						}
						
						},
						
					]],
					
				})
				console.log(gridData)
				$("#mark").datagrid("unselectAll");
				$("#mark").datagrid('loadData', gridData)
        	},
	        closed:true,buttons:[{
				text:$g('取消'),
				iconCls:'icon-w-close',
				id: 'btnClose',
				handler:function(){
					$.messager.confirm($g('确认'),$g('取消后将会删除交班项目,确定要取消吗？'),function(r){    
						if (r){
					
							runClassMethod("Nur.SHIFT.Service.ShiftDetailController","DeleteShiftItemByIDs",{ids:idStr},function(rtn){	
								//setPatientHtml()
								if(rtn==0){
									$.messager.popover({msg:$g('取消成功！'),type:'success'});
									$('#dialogRefer').dialog('close');	
									initLoad()
								}else if(rtn==2){
									$.messager.popover({msg:$g('取消失败！'),type:'error'});
								}
							},'json',true)
						}
					})
				}
			},{
				text:$g('重置'),
				iconCls:'icon-w-clean',
				id: 'btnClear',
				handler:function(){
					$.messager.confirm($g('确认'),$g('重置后将会覆盖原来的交班内容,确定要重置吗？'),function(r){    
						if (r){
					
					
							runClassMethod("Nur.SHIFT.Service.ShiftDetailController","GetShuaXin",{ids:idStr,UserID:session["LOGON.USERID"]},function(rtn){	
								//setPatientHtml()
								if(rtn==0){
									$.messager.popover({msg:$g('重置成功！'),type:'success'});
									$('#dialogRefer').dialog('close');	
									initLoad()
								}else if(rtn==2){
									$.messager.popover({msg:$g('重置失败！'),type:'error'});
								}
							},'json',true)
						}
					})
					
				}
			}]
	    });
    $("#dialogRefer").dialog("open");
		
	//	$.messager.popover({ msg: ids, type: 'error' });
	},1)
}
function GetDetailLeftProject(){
	
	var detailColumns=""
	runClassMethod("Nur.SHIFT.Service.ShiftDetailController","GetDetailLeftProject",{ShiftID:GLOBAL.ShiftID},function(rtn){
		detailColumns=rtn.data
	},'json',false);
	return detailColumns
} 
function InsertProject(){
		//新增交班项目
		var row = $("#shiftBookDetail").datagrid("getSelected");
		if (!row) {
			$.messager.alert($g("提示"),$g("请选择一条交班记录！"));
			return false;
		} 
		var rows = $("#shiftBookDetail").datagrid("getSelections");
		if (rows.length>1) {
			$.messager.alert($g("提示"),$g("请选择一条交班记录！"));
			return false;
		} 
		
		$("#Insert-Dialog").window('open');
		$("#patient-project").html("")
		//取带入明细区域的交班项目
	    var detailColumns=[]
	    
	    runClassMethod("Nur.SHIFT.Service.ShiftProjectController","GetAreaGridColumns",{"ShiftID":GLOBAL.ShiftID,"ShowType":"1"},function(rtn){
			detailColumns=rtn.data
		},'json',false);
		var shiftTimeList=GLOBAL.ShiftTimes
		var comboData=[],comboProjectID=[]
		for(var i=0;i<detailColumns.length;i++){
			if(detailColumns[i].intoDetailArea!=0){
				var data=detailColumns[i]
				console.log(data)
				var json={text:data.title,value:data.ProjectID}
		    	comboData.push(json)
		    	comboProjectID.push(data.ProjectID)
			}
		}
		//取患者当天所有的交班项目
		var PatItemRecords=""
		runClassMethod("Nur.SHIFT.Service.ShiftDetailController","GetPatientProjectList",{"ShiftID":row.ShiftID,"PatientID":row.PatientID},function(rtn){
			PatItemRecords=rtn
		},'json',false);
		
		
		var PatItems={}
		for(var i=0;i<PatItemRecords.length;i++){
			var ShiftProjectID=PatItemRecords[i].ProjectID
			//过滤掉明细区域不存在的项目
			if(comboProjectID.indexOf(ShiftProjectID)==-1){
				continue	
			}
			
			var TimeID=PatItemRecords[i].TimeID
			var json=[]
			if(typeof(PatItems[TimeID])!="undefined"){
				json=PatItems[TimeID]
			}
			json.push(ShiftProjectID)
			PatItems[TimeID]=json
		}
		console.log(PatItems)
		
		var inputw=0
		for(var j=0;j<shiftTimeList.length;j++){
			var shiftData=shiftTimeList[j]
			var TimeID=shiftData.ID
			
			var id='shiftTimeProject-'+TimeID
			var pid='project-'+TimeID
			var td1='<td id="'+pid+'-label" class="label" style="width: 10px;white-space: nowrap;padding-right: 10px;text-align:right;">'+$g(shiftData.ShiftName)+'</td>'
			var td2='<td id="'+pid+'"><input class="patientProject" style="width:100%;" id="'+id+'"> </td>'
			
			$("#patient-project").append('<tr>'+td1+td2+'</tr>')
			inputw=$("#"+id).outerWidth()
			//$("#"+id).width(w)
			/*var t=$("#patient-project").outerWidth()
			var l=$("#"+pid+"-label").outerWidth()
			var w=t-l
			if(w>maxwidth){maxwidth=w}
			$HUI.combo("#"+id,{
				valueField:"value",
				textField:"text",
				multiple:true,
				selectOnNavigation:false,
				panelHeight:"auto",
				editable:true,
				//data:data
			});
			
			var data={"data":comboData}
			data.multiple="true"
			data.rowStyle='checkbox'
			$("#"+id).combobox(data)
			var ProjectIDs=PatItems[TimeID]
			if(typeof(ProjectIDs)!="undefined"){
				$("#"+id).combobox("setValues",ProjectIDs)
			}*/
			
		}
		for(var j=0;j<shiftTimeList.length;j++){
			var shiftData=shiftTimeList[j]
			var TimeID=shiftData.ID
			var id='shiftTimeProject-'+TimeID
			var pid='project-'+TimeID
			$("#"+id).width(inputw)
			$HUI.combo("#"+id,{
				valueField:"value",
				textField:"text",
				multiple:true,
				selectOnNavigation:false,
				panelHeight:"auto",
				editable:true,
				//data:data
			});
			var data={"data":comboData}
			data.multiple="true"
			data.rowStyle='checkbox'
			$("#"+id).combobox(data)
			var ProjectIDs=PatItems[TimeID]
			if(typeof(ProjectIDs)!="undefined"){
				$("#"+id).combobox("setValues",ProjectIDs)
			}
		}
		
		
	
	}
	///新增交班项目-保存
function SaveProject(){
	debugger;
	//DetailToolBarFun.SaveProject()	
	var row = $("#shiftBookDetail").datagrid("getSelected");
	//取患者原来的项目
	var PatItemRecords=""
	runClassMethod("Nur.SHIFT.Service.ShiftDetailController","GetPatientProjectList",{"ShiftID":row.ShiftID,"PatientID":row.PatientID},function(rtn){
		PatItemRecords=rtn
	},'json',false);
	
	var detailColumns=GetDetailLeftProject()
	var comboProjectID=[]
	for(var i=0;i<detailColumns.length;i++){
		var data=detailColumns[i]
	
    	comboProjectID.push(data.ProjectID)
	}
	
	
	
	//取患者每个班次的项目	
	var pItemOld={}
	for(var i=0;i<PatItemRecords.length;i++){
		var ShiftProjectID=PatItemRecords[i].ProjectID
		var TimeID=PatItemRecords[i].TimeID
		var json=[]
		if(typeof(pItemOld[TimeID])!="undefined"){
			json=pItemOld[TimeID]
		}
		if(comboProjectID.indexOf(ShiftProjectID)>-1){
			json.push(PatItemRecords[i])
			pItemOld[TimeID]=json
		}
	}
	
	var PatientID=row.PatientID;
	var PatientWardID=row.PatientWardID;
	var Date=$('#datecombo').datebox("getValue");
	var json={},insertList=[],delList=[]
	$("#patient-project").find(".patientProject").each(function(){
		var cid=$(this).attr("id")	
		var timeId=cid.split("-")[1]
		
		var projectIds=$("#"+cid).combo("getValues")
		//存储当前下拉框内的交班项目
		var newProjectIds=[]
		for(var i=0;i<projectIds.length;i++){
			var projectId=projectIds[i]
			var data={
				WardID:PatientWardID,
				Date:Date,
				ProjectID:projectId,
				TimeID:timeId,
				PatientID:PatientID,
				ShiftID:row.ShiftID
			}
			//下拉框的项目都为新增项目
			insertList.push(data)
			//存储交班项目ID
			newProjectIds.push(projectId)
		}
		//如果没有新增项目，但是有原有项目，那么说明是删除操作
		if(newProjectIds.length==0){
			//当前班次原有的项目
			var oldItem=pItemOld[timeId]
			if(typeof(oldItem)!="undefined"){
				for(var i=0;i<oldItem.length;i++){
					var data={
						ID:oldItem[i].ItemRecordID,
						WardID:PatientWardID,
						Date:Date,
						ProjectID:oldItem[i].ProjectID,
						TimeID:timeId,
						PatientID:PatientID,
						ShiftID:row.ShiftID
					}
					delList.push(data)
					
				}
				
			}
		}else{
			
			//当前班次原有的项目
			var oldItem=pItemOld[timeId]
			if(typeof(oldItem)!="undefined"){
				//存储班次原有的项目ID
				var oldProjectIds=[]
				for(var i=0;i<oldItem.length;i++){
					oldProjectIds.push(oldItem[i].ProjectID+"")
				}
				for(var i=0;i<oldProjectIds.length;i++){
					var oldProjectID=oldProjectIds[i]
					//新项目里面不包含原有项目，说明需要删除
					if(newProjectIds.indexOf(oldProjectIds[i])==-1){
						var projectId=oldProjectIds[i]
						var data={
							ID:oldItem[i].ItemRecordID,
							WardID:PatientWardID,
							Date:Date,
							ProjectID:projectId,
							TimeID:timeId,
							PatientID:PatientID,
							ShiftID:row.ShiftID
						}
						delList.push(data)
					}
				}	
			}
			
		}
		
	})
	if(insertList.length==0&&delList.length==0){
		runClassMethod("Nur.SHIFT.Service.ShiftDetailController","DeleteProjectByPatient",{"ShiftID":row.ShiftID,"PatientID":row.PatientID,UserID:session["LOGON.USERID"]},function(rtn){
			
			$HUI.dialog("#Insert-Dialog").close()
			$.messager.popover({msg:$g('保存成功！'),type:'success'});
			initData()
			
			
		},'json',true)
		
	}else{
		runClassMethod("Nur.SHIFT.Service.ShiftDetailController","InsertProject",{data:JSON.stringify(insertList),delData:JSON.stringify(delList),UserID:session["LOGON.USERID"]},function(rtn){
			
			$HUI.dialog("#Insert-Dialog").close()
			$.messager.popover({msg:$g('保存成功！'),type:'success'});
			initData()
			
			
		},'json',true)
	}
}
var PatientData=[]
function UpdatePatientData(){
	$("#table-patient").html("")
	var rtn=GetDetailGridData("")
	PatientData=rtn.data
	findPatientData()
}

function findPatientData(){
	$("#table-patient").html("")
	var txt=$("#souPatient").searchbox("getValue")

	
	
	
	
	
	var Lis=[]
	for(var i=0;i<PatientData.length;i++){
		var grid=PatientData[i]
		var patientName=grid.PatientName
		var PatientID=grid.PatientID
		var ID=grid.ID
		var IsDeleted=grid.IsDeleted
		if(txt!=""){
			if(patientName.indexOf(txt)==-1){
				continue;	
			}
		}
		if(IsDeleted==1){
			Lis.push("<td style='color:#ccc' id='"+ID+"' PatientID='"+PatientID+"'><span style='margin-left: 0px'><input checked=''  class='hisui-checkbox' lable='"+patientName+"' type='checkbox'>"+patientName+"</span></td>")

		}else{
			Lis.push("<td id='"+ID+"' PatientID='"+PatientID+"'><span style='margin-left: 0px'><input class='hisui-checkbox' lable='"+patientName+"' type='checkbox'>"+patientName+"</span></td>")
		}
	}
	var rowCount=4
	var trs=[],tds=[]
	for(var i=0;i<Lis.length;i++){
		tds.push(Lis[i])
		if(tds.length==rowCount){
			trs.push("<tr>"+tds.join("")+"</tr>")
			tds=[]
		}
	}
	if(tds.length>0){
		if(txt==""){
			var len=tds.length
			for(var i=rowCount;i>len;i--){
				tds.push("<td></td>")
			}
		}
		trs.push("<tr>"+tds.join("")+"</tr>")
	}
	tds=[]

	
	$(".table-all-patient").html(trs.join("")).css({"height":"auto"}).parents("div.all-patient").css("height",400)
	
	
	
	$HUI.checkbox(".table-all-patient input",{
		onChecked:function(e,value){
			
			var id=$(e.target).parents("td").attr("id")
			var PatientID=$(e.target).parents("td").attr("PatientID")
			

			runClassMethod("Nur.SHIFT.Service.ShiftDetailController","UpdatePatientShiftRecord",{ids:id,IsDeleted:1,UserID:session["LOGON.USERID"]},function(rtn){	
				//setPatientHtml()
				//UpdatePatientData()
				for(var i=0;i<PatientData.length;i++){
					var grid=PatientData[i]
					if(id==grid.ID){
						PatientData[i].IsDeleted=1
						break;
					}
				}
				findPatientData()
				
				
				initLoad()
			},'json',true)
			
		},
		
		onUnchecked:function(e,value){
			var id=$(e.target).parents("td").attr("id")
			var PatientID=$(e.target).parents("td").attr("PatientID")
			
			runClassMethod("Nur.SHIFT.Service.ShiftDetailController","UpdatePatientShiftRecord",{ids:id,IsDeleted:0,UserID:session["LOGON.USERID"]},function(rtn){	
				for(var i=0;i<PatientData.length;i++){
					var grid=PatientData[i]
					if(id==grid.ID){
						PatientData[i].IsDeleted=0
						break;
					}
				}
				findPatientData()
				initLoad()
			},'json',true)
		}
	});
	$("#update-patient-dialog").window('open');
}

function DeletePatient(){
	var row = $("#shiftBookDetail").datagrid("getSelected");
	if (!row) {
		$.messager.alert($g("提示"),$g("请选择一条交班记录！"));
		return false;
	}
	var rows = $("#shiftBookDetail").datagrid("getSelections");
	if (rows.length>1) {
		$.messager.alert($g("提示"),$g("请选择一条交班记录！"));
		return false;
	} 
	
	$.messager.confirm($g('确认'),$g('删除后将不可恢复,确定要删除吗？'),function(r){    
		if (r){
	
	
			runClassMethod("Nur.SHIFT.Service.ShiftDetailController","DeletePatientShiftRecord",{ids:row.ID,UserID:session["LOGON.USERID"]},function(rtn){	
				if(rtn==0){
				
					//setPatientHtml2()
					initLoad()
				}else if(rtn==2){
					$.messager.popover({msg:$g('非手动添加患者，删除失败！'),type:'error'});
				}
			},'json',true)
		}
	})
}
function InsertPatient(){
	var ShiftBookID=GetShiftBookID()
	var url="nur.ward.shift.book.insert.patient.csp?ShiftID="+GLOBAL.ShiftID+"&WardID="+GLOBAL.WardID+"&ShiftBookID="+ShiftBookID+"&MWToken="+websys_getMWToken()
	$('#dialogRefer').dialog({    
		title: $g("新增患者"),    
		width: 650,    
		height: 500,    
		closed: false,    
		cache: false,
		iconCls:'icon-w-edit',
        content: "<iframe id='iframeRefer' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
		modal: true ,
		buttons:[{
			text: $g('保存'),
			iconCls:'icon-w-save',
			id: 'btnRefer',
			handler:function(){
				var $iframe = $('#iframeRefer')[0].contentWindow
				var rsTxt = ""
				debugger;
				rsTxt=$iframe.$method.savePatient(GLOBAL.ShiftID,GLOBAL.WardID,GLOBAL.Date)
				
				if(rsTxt=="1"){
					
					$.messager.popover({msg:$g('保存成功！'),type:'success'});
					initData()
					
					//$('#dialogRefer').dialog('close');	
				}else if(rsTxt=="2"){
					$.messager.alert($g('提示'),$g('保存失败！患者已存在当天交班列表') , "info");	
				}
			}
		},{
			text: $g('关闭'),
			iconCls:'icon-w-close',
			id: 'btnClose',
			handler:function(){
				$('#dialogRefer').dialog('close');	
			}
		}]  
	});   
	$("#dialogRefer").dialog("open");	

}


function settingShuyu(){
	
	 var winWidth = $("body").width()*0.96;
	var winHeight = $("body").height()*0.8;
	
        
	
	var LocID=$("#Locs").combobox("getValue")
	 var url = "nur.hisui.shift.new.csp?WardID="+GLOBAL.WardID+"&LocID="+"&MWToken="+websys_getMWToken() 
	 $('#dialogRefer').dialog({
        title: $g('病区术语维护'),
        width: winWidth-200, 
        height: winHeight,
        closed: false,
        cache: false,
        modal: true,
        buttons:[],
        content: "<iframe id='iframeRefer' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
        modal: true
        
    });
    $("#dialogRefer").dialog("open");
	
}

function settingBtn(type){
	var winWidth = $("body").width()*0.96;
	var winHeight = $("body").height()*0.8;
	var dialogHtml = "<div class='commonModalDialog' style='overflow:hidden'><iframe id='dialogFrame' src=''></iframe></div>";
	
	
	
	
    var url= "nur.ward.shift.book.sort.csp?ShiftBookID="+GetShiftBookID()+"&ShiftID="+GLOBAL.ShiftID+"&type="+type+"&MWToken="+websys_getMWToken();

	
	$('#dialogRefer').dialog({    
		title: $g("病区排序设置"),    
		width: 350,    
		height: 500,    
		closed: false,    
		cache: false,
		iconCls:'icon-w-edit',
        content: "<iframe id='iframeRefer' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
		modal: true ,
        onLoad: function () {},
        onBeforeClose: function () {},
        onOpen: function () {
            $('body').css({
                "overflow-y": "hidden"
            });
        },
        onClose: function () {
            $('body').css({
                "overflow-y": "auto"
            });
            //$(this).dialog('destroy');
       		setTimeout(function(){
				initLoad()
			},500)   
        }
    });
    //$("#dialogFrame").attr("height", winHeight - 237);
	//$("#dialogFrame").attr("width", winWidth/2-300);
	
	}
function ShiftModifyLog(){
	
	var LocID=$("#Locs").combobox("getValue")
	var rows = $('#ShiftClassList').combogrid('grid').datagrid('getSelected');
	var nowDate=$('#datecombo').datebox("getValue");
	var dgwidth = $(window).width() - 100;
    var dgheight = $(window).height() - 180;
	var url="nur.ward.shift.book.log.csp?ShiftBookID="+GetShiftBookID()+"&WardID="+GLOBAL.WardID+"&LocID="+LocID+"&ClassID="+rows.ID+"&nowDate="+nowDate+"&MWToken="+websys_getMWToken()
		$('#dialogRefer').dialog({    
    		title: $g("修改记录"),    
    		width: dgwidth,    
    		height: dgheight,    
    		closed: false,    
    		cache: false,
	        content: "<iframe id='iframeRefer' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
    		modal: true ,
    		
		});   
		$("#dialogRefer").dialog("open");	
}

function printProject(){

    
    var detailColumns=GetDetailLeftProject()

    var comboData=[]
    var values=[]
    for(var i=0;i<detailColumns.length;i++){
		var text=detailColumns[i].ProjectName
		var ProjectID=detailColumns[i].ProjectID
		
		var Json={
			"value":detailColumns[i].ProjectID,
			"text":$g(detailColumns[i].ProjectName)	
		}
		comboData.push(Json)
		values.push(detailColumns[i].ProjectID)
    }
    
	$HUI.combo("#printProject",{
		valueField:"value",
		textField:"text",
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:true,
	});
	
	var data={"data":comboData}
	data.multiple="true"
	data.rowStyle='checkbox'
	
	$("#printProject").combobox(data)
	$("#printProject").combobox("setValues",values)
}

$("body").on("click",".printShift",function(){
	var tempCode=$(this).attr("tempCode")
	var timeID=$(this).attr("timeID")
	if (typeof timeID != 'undefined') {

		
		var shiftTimeList=GLOBAL.ShiftTimes
		for(var j=0;j<shiftTimeList.length;j++){
			var shiftData=shiftTimeList[j]
			
			if(timeID==shiftData.ID){
				tempCode=shiftData.ShiftTempCode
			}
		}
	}else{
		var ClsRow = $('#ShiftClassList').combogrid('grid').datagrid('getSelected');
		runClassMethod("Nur.SHIFT.Service.ShiftConfigController","GetShiftClassById",{"id":ClsRow.ID},function(rtn){
			tempCode=rtn.ShiftEmrCode
		},'json',false);
		
		
	}	
	$("#print-dialog").window("open")
	var inputw=0
	$("td.print-combox").each(function(){
		var $thisw=$(this).outerWidth()
		if($thisw>inputw) inputw=$thisw
	})
	
	$("td.print-combox input").width(inputw-10)
	
	
	printProject()
	GetDetailSortMenu("sortFilde")
	$("td.tempCode").html(tempCode)
	//加载默认数据
	var getValues=$("#SortFildName").combo("getValues")
	$("#sortFilde").combobox("setValues",getValues)
	
	$HUI.combo("#printFw",{
		valueField:"value",
		textField:"text",
		multiple:true,
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:true
		//data:data
	});
	var data={"data":comboxLocData}
	$("#printFw").combobox(data)
	
	var WardLocID=GetSouWardLoc(2,"#souLocs")
	
	$("#printFw").combobox("setValue",WardLocID)
	
	$("#print-dialog").window("open")
	
	
})
//直接打印
function AllprintShift(){
	
	var printAll=0
    var detailColumns=GetDetailLeftProject()
    var projects=[]
    var values=[]
    for(var i=0;i<detailColumns.length;i++){
		var text=detailColumns[i].ProjectName
		var ProjectID=detailColumns[i].ProjectID
		projects.push(detailColumns[i].ProjectID)
    }

	var WardID=GetSouWardLoc(1,"#printFw"),LocID=GetSouWardLoc(2,"#printFw")
  	var serverURL = window.location.href.split("/csp/")[0]; // + "/";
  	var params = [
		GLOBAL.ShiftID,
  		"",
  		"",
  		printAll,
  		projects.join(","),
  		WardID,
  		LocID
	];
	console.log(params)
	var ShiftEmrCode=""
	var ClsRow = $('#ShiftClassList').combogrid('grid').datagrid('getSelected');
	runClassMethod("Nur.SHIFT.Service.ShiftConfigController","GetShiftClassById",{"id":ClsRow.ID},function(rtn){
		ShiftEmrCode=rtn.ShiftEmrCode
	},'json',false);
	
	var tempCode=$("td.tempCode").text()
	AINursePrintAll(
  		serverURL,
  		ShiftEmrCode,
  		1,
 		params.join("^"),
 		GLOBAL.bookGenral.OpenCA
	);
  
}

function GetSouWardLoc(type,comboID){
	if(type==1){
		return $("#souWards").combo("getValue")
	}
	if(type==2){
		return $("#souLocs").combo("getValue")
	}
	return ""
}
function printShift(type){
		var ids=[]
		var printAll=0
		if(type==3){
			//选中的记录
			var rows = $("#shiftBookDetail").datagrid("getSelections");
			
			for(var i=0;i<rows.length;i++){
				ids.push(rows[i].ID)
			}	
			if(ids.length==0){
				$.messager.popover({ msg: $g('请选中数据后再打印'), type: 'error', timeout: 1000 });
				return false;	
			}
		}else if(type==2){
			//非空数据
			printAll=1
		}
		
		//排序顺序
		var getValues=$("#sortFilde").combo("getValues")
		var projects=$("#printProject").combo("getValues")

		var WardID=GetSouWardLoc(1,"#printFw"),LocID=GetSouWardLoc(2,"#printFw")
		
		
        // 外部数据源打印bug fix
      	var serverURL = window.location.href.split("/csp/")[0]; // + "/";
      	var params = [
			GLOBAL.ShiftID,
      		getValues.join(","),
      		ids.join(","),
      		printAll,
      		projects.join(","),
      		WardID,
      		LocID
    	];
    	console.log(params)
		
		/*runClassMethod("Nur.SHIFT.Service.ShiftPrintController","GetPrintList",{"dynamicParam":params.join("^")},function(rtn){
			///插入交班日志
			
			//console.log(rtn)
		})
		return false;*/
    	var tempCode=$("td.tempCode").text()
    	AINursePrintAll(
      		serverURL,
      		tempCode,
      		1,
     		params.join("^"),
     		GLOBAL.bookGenral.OpenCA
    	);
  
}
function GetSignNurseId(value){

	var values=value.split("|")
	var userIds=[]
	for(var j=0;j<values.length;j++){
		var userID=values[j].split("*")[1]
		var userName=values[j].split("*")[0]
		if(userName!=""){
			userIds.push(userID)
		}
	}
	return userIds
}
function GetNurse(){
	var comboData=""
	runClassMethod("Nur.SHIFT.Service.ShiftController","GetNurse",{"ShiftID":GLOBAL.ShiftID},function(rtncomboData){
		comboData=rtncomboData
	},'json',false);
	return comboData
}


function GetShiftHeadSign(){
		
	runClassMethod("Nur.SHIFT.Service.ShiftController","GetShiftHeadSign",{"ShiftID":GLOBAL.ShiftID},function(ShiftSignName){
		
		
		if(ShiftSignName!=""){
			var value=ShiftSignName
			var values=value.split("|")
			var userIds=[],userNames=[]
			for(var j=0;j<values.length;j++){
				var userID=values[j].split("*")[1]
				var userName=values[j].split("*")[0]
				if(userName!=""){
					userIds.push(userID)
					var closeHtml='<a class="panel-tool-close" UserID="'+userID+'" NurseID="'+GLOBAL.UserID+'"  href="javascript:void(0)" onclick="cxHszQm(this)" style="visibility: hidden;display: inline-block;width: 16px;    height: 16px;margin: 0 0 0 2px;vertical-align: top;    margin-top: 4px;"></a>'
					userName='<span class="shiftName"  onmouseover="ccc(this)">'+userName+closeHtml+"</span>"

					userNames.push(userName)
				}
			}
					
			
			var text="<div>"+userNames.join("")+"</div>"
			
			$(".hszname").html(userNames.join(""))
			$(".hsz").css({"visibility": "visible"})
			$(".hsz .panel-tool-close").css({"visibility": "visible"})
			
		}else{
			$(".hsz").css({"visibility": "hidden"})
			$(".hsz .panel-tool-close").css({"visibility": "hidden"})
		}
		
	},'text',true);
	
}


/*护士长签名**/
function OpenSignHeadNurse(){
	var ShiftSign=""
	var ShiftTaskSign=""

	$("#signHeadNurse").html("")
	var comboData=GetNurse()
	var data={"data":comboData}
	var hszComboData=[]
	for(var i=0;i<comboData.length;i++){
		var groupName=comboData[i].groupName
		if(typeof(groupName)!="undefined"){
			if(groupName.indexOf("护士长")>-1){
				hszComboData.push(comboData[i])
			}
		}
		
	}
	var userIds=[]
	runClassMethod("Nur.SHIFT.Service.ShiftController","GetShiftHeadSign",{"ShiftID":GLOBAL.ShiftID},function(value){
			if(value!=""){
				
				ShiftTaskSign=GetSignNurseId(value)
			}	
		},'text',false);
	
	var td1='<td class="label" style="width: 10px;white-space: nowrap;padding-right: 10px;">'+$g('护士长')+'</td>'
	var td2='<td><input id="ShiftHeadNurseSign"  style="width:450px;"> </td>'
	$("#signHeadNurse").append('<tr>'+td1+td2+'</tr>')
	
	$HUI.combo("#ShiftHeadNurseSign",{
		valueField:"value",
		textField:"text",
		multiple:true,
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:true,
		//data:data
	});
	
	var data={"data":hszComboData}
	data.multiple="true"
	data.rowStyle='checkbox'
	$("#ShiftHeadNurseSign").combobox(data)
	
	if(ShiftTaskSign!="" && typeof(ShiftTaskSign)!="undefined"){
		$("#ShiftHeadNurseSign").combobox("setValues",ShiftTaskSign)
	}
	$("#modalHeadSign").window('open');
	

}
///保存护士长签名
function saveSignHeadNurse(){
	
	var params={}
	params.ShiftHeadNurseSign=$HUI.combobox("#ShiftHeadNurseSign").getValues().join("@")
	params.ShiftID=GLOBAL.ShiftID
	params.ShiftIsCA=0
	runClassMethod("Nur.SHIFT.Service.ShiftController","MagicHeadSave",{data:JSON.stringify(params)},function(rtn){
		if(rtn == 0) {
			$.messager.popover({ msg: $g('签名成功'), type: 'success', timeout: 1000 });
			$HUI.dialog("#modalHeadSign").close()
			GetShiftHeadSign()
		} 
		
	},'json',false);
	
}

function OpenSignNurse(type){
	debugger
	var ShiftSign=""
	var ShiftTakeSign=""
	
	var row = $("#shiftBookArea").datagrid("getSelected");
	if (!row) {
		$.messager.alert(TiShi,AreaMsg);
		return false;
	}
	var TimeID=row.TimeID; //$(row.ShiftName).attr("TimeID")
	if(typeof(TimeID)=="undefined"){
		return false;	
	}
	
	if(GLOBAL.bookGenral.SignType==2){
		row = $("#shiftBookDetail").datagrid("getSelected");
		if (!row) {
			$.messager.alert(TiShi,$g(DetailMsg));
			return false;
		}
	}
	if (typeof row.ShiftSign != 'undefined') {
		ShiftSign=row.ShiftSign
	}
	if (typeof row.ShiftTakeSign != 'undefined') {
		ShiftTakeSign=row.ShiftTakeSign
	}
	if(GLOBAL.bookGenral.SignStyle=="2"){
		$.messager.confirm($g('确认'),$g('确定要签名吗？'),function(r){    
			if (r){
				var params={}
				var userid=session["LOGON.USERID"]
				if(type==1){
					//交班签名
					params.ShiftSign=userid
					params.SignFilds="ShiftSign"
				}else if(type==2){
					
					//接班签名
					params.ShiftTakeSign=userid
					params.SignFilds="ShiftTakeSign"
				}
				SignNurseOK(params)
			}
		})
		
	}else{
		$("#signNurse").html("")
		var comboData=GetNurse()
		var signContors=[]
		if(type==1){
			createSignHtml("交班护士","ShiftSign",ShiftSign,comboData)
		}else if(type==2){
			createSignHtml("接班护士","ShiftTakeSign",ShiftTakeSign,comboData)
		}else{
			if(GLOBAL.bookGenral.OpenSignA==1){
				createSignHtml("交班护士","ShiftSign",ShiftSign,comboData)
			}
			if(GLOBAL.bookGenral.OpenSignB==1){
				createSignHtml("接班护士","ShiftTakeSign",ShiftTakeSign,comboData)
			}	
			
		}
		$("#modalSign").window('open');
	}
}

function createSignHtml(text,id,value,comboData){
	
	var td1='<td class="label" style="width: 10px;white-space: nowrap;padding-right: 10px;">'+$g(text)+'</td>'
	var td2='<td><input id="'+id+'"  style="width:437px;"> </td>'
	$("#signNurse").append('<tr>'+td1+td2+'</tr>')
	
	$HUI.combo("#"+id,{
		valueField:"value",
		textField:"text",
		multiple:true,
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:true,
	});
	
	var data={"data":comboData}
	data.multiple="true"
	data.rowStyle='checkbox'
	$("#"+id).combobox(data)
	
	if(value!="" && typeof(value)!="undefined"){
		$("#"+id).combobox("setValues",value.split(","))
	}
}

function saveSignNurse(){
	
	var params={}
	if($("#ShiftSign").length>0){
		params.ShiftSign=$HUI.combobox("#ShiftSign").getValues().join("@")
		params.SignFilds="ShiftSign"
	}
	if($("#ShiftTakeSign").length>0){
		params.ShiftTakeSign=$HUI.combobox("#ShiftTakeSign").getValues().join("@")
		params.SignFilds="ShiftTakeSign"
	}
	if($("#ShiftSign").length>0&&$("#ShiftTakeSign").length>0){
		params.ShiftSign=$HUI.combobox("#ShiftSign").getValues().join("@")
		params.ShiftTakeSign=$HUI.combobox("#ShiftTakeSign").getValues().join("@")
		params.SignFilds="ShiftSign,ShiftTakeSign"
	}
	
	SignNurseOK(params)
}
function SignNurseOK(params){
	for(var key in params){
		var sign=params[key]
		if(!sign){
			$.messager.popover({ msg: $g('请选择签名护士'), type: 'success', timeout: 1000 });	
			return;
		}
	}
	///班次签名模式
	if(GLOBAL.bookGenral.SignType==1){
		var row = $("#shiftBookArea").datagrid("getSelected");
		//var $this=$(row.ShiftName)
		var ShiftTimeRecordID=row.ShiftTimeID
		params.ID=ShiftTimeRecordID
		//$.messager.confirm($g('确认'),$g('签名后，本班次将不会再统计数据，确定要签名吗？'),function(r){    
		//if (r){
	
			runClassMethod("Nur.SHIFT.Service.ShiftController","ShiftMagicSave",{data:JSON.stringify(params)},function(rtn){
				if(rtn == 0) {
					$.messager.popover({ msg: $g('签名成功'), type: 'success', timeout: 1000 });
					$HUI.dialog("#modalSign").close()
					setTimeout(function(){
						initData()
						
					},200)
				} 
				
			},'json',false);
		//}})
	}else if(GLOBAL.bookGenral.SignType==2){
		
		var row = $("#shiftBookArea").datagrid("getSelected");
		if (!row) {
			$.messager.alert($g("提示"),$g(AreaMsg));
			return false;
		}
		var TimeID=row.TimeID; //$(row.ShiftName).attr("TimeID")
		
		var rows = $("#shiftBookDetail").datagrid("getSelections");
		var ids=[]	
		for(var i=0;i<rows.length;i++){
			ids.push(rows[i].ID)
		}
		params.ids=ids.join(",")
		params.TimeID=TimeID
		params.ShiftID=GLOBAL.ShiftID
		//$.messager.confirm($g('确认'),$g('签名后，本班次将不会再统计数据，确定要签名吗？'),function(r){    
		//if (r){
	
			runClassMethod("Nur.SHIFT.Service.ShiftController","ShiftPatientMagicSave",{data:JSON.stringify(params)},function(rtn){
				if(rtn == 0) {
					$.messager.popover({ msg: $g('签名成功'), type: 'success'});
					$HUI.dialog("#modalSign").close()
					//initLoad()
					
					setTimeout(function(){
						$(".detail-project li.libgselect").trigger("click")
						
					},200)
					
				} 
				
			},'json',false);
		//}})
	}

}
function ccc(that){
	$("span.shiftName a.panel-tool-close").css("visibility","hidden")
	$(that).find("a.panel-tool-close").css("visibility","visible")
	
}
function cxHszQm(that){
	$.messager.confirm($g('确认'),$g('您确认想要撤销吗？'),function(r){    
		if (r){
			var UserID=$(that).attr("UserID")
			var NurseID=$(that).attr("NurseID")
			var params={
		        UserID:UserID,
		        NurseID:NurseID,
		        ShiftID:GLOBAL.ShiftID,
		        ShiftBookID:GetShiftBookID()
			}

			runClassMethod("Nur.SHIFT.Service.ShiftController","ShiftMagicClearHsz",{data:JSON.stringify(params)},function(rtn){
				if(rtn == 0) {
					$.messager.popover({ msg: $g('撤销签名成功'), type: 'success', timeout: 1000 });
					
					
				}else if(rtn==1){
					$.messager.popover({ msg: $g('只有签名护士可以撤销'), type: 'error', timeout: 1000 });
				
				}else if(rtn==2){
					$.messager.popover({ msg: $g('只能撤销本人签名'), type: 'error', timeout: 1000 });
				
				}else{
					$.messager.popover({ msg: $g('撤销签名成功'), type: 'success', timeout: 1000 });
				}
				GetShiftHeadSign()
				
			},'json',false);
			
			
			
			
		}
	})
}
function ddd(that){
	$.messager.confirm($g('确认'),$g('您确认想要撤销吗？'),function(r){    
		if (r){
			var NurseID=$(that).attr("nurseID")
			var Field=$(that).attr("field")
			var ShiftTimeID=$(that).attr("shiftTimeID")
			
			var params={
				ID:ShiftTimeID,
		        UserID:GLOBAL.UserID,
		        ShiftID:GLOBAL.ShiftID,
		        NurseID:NurseID,
		        Field:Field
			}
			runClassMethod("Nur.SHIFT.Service.ShiftController","ShiftMagicClearAll",{data:JSON.stringify(params)},function(rtn){
				if(rtn == 0) {
					$.messager.popover({ msg: $g('撤销签名成功'), type: 'success', timeout: 1000 });
					$HUI.dialog("#modalSign").close()
					initLoad()
				}else if(rtn==1){
					$.messager.popover({ msg: $g('只有签名护士可以撤销'), type: 'error', timeout: 1000 });
					$HUI.dialog("#modalSign").close()
				}else if(rtn==2){
					$.messager.popover({ msg: $g('只能撤销本人签名'), type: 'error', timeout: 1000 });
					$HUI.dialog("#modalSign").close()
				}
				
			},'json',false);
			
			
			
		}
	})
}
function aaa(that){
	$("span.projectName a.panel-tool-close").css("visibility","hidden")
	$(that).find("a.panel-tool-close").css("visibility","visible")
	
}
function bbb(ID){
	
	$.messager.confirm($g('确认'),$g('您确认想要删除吗？'),function(r){    
		if (r){
			runClassMethod("Nur.SHIFT.Service.ShiftDetailController","DeleteShiftItemByID",{ID:ID,UserID:session["LOGON.USERID"]},function(rtn){
				$.messager.popover({ msg: $g('删除成功'), type: 'success', timeout: 1000 });
				initLoad()
			})
			
			
		}
	})
	
	
}
///交班明细-点击交班项目
$("body").on("click",".detail-project li",function(){
	if(GLOBAL.bookGenral.MultipleProject==1){
		$(".libgselect").removeClass("libgselect")
		$(this).addClass("libgselect")
	}else{
		
		if($(this).hasClass("libgselect")){
			$(this).removeClass("libgselect")
		}else{
			$(this).addClass("libgselect")
		}	
		if($(".libgselect").length==0){
			$(this).addClass("libgselect")
			//return false;
		}
		
		if($(this).index()==0){
			$(".libgselect").removeClass("libgselect")
			$(this).addClass("libgselect")
		}else{
			$(".detail-project li").eq(0).removeClass("libgselect")
		}
		
	}	
	setTimeout(function(){
		detailArea.Data()
		
	},500)
})


var unfoldFlag="false";
function keyup_submit(e){
	
	var evt = window.event || e; 
 	if (evt.keyCode == 13){
	 	detailArea.Data()
 	}
}






function GetDetailSortMenu(id){
	var rtnData=""
	runClassMethod("Nur.SHIFT.Service.ShiftDetailController","GetDetailSortMenu",{"ShiftID":GLOBAL.ShiftID},function(sortList){
		var comboData=[]
		for(var i=0;i<sortList.data.length;i++){
			var Array=sortList.data[i]
			var Json={
				"value":Array.field,
				"text":$g(Array.FildSortName)	
			}
			
			comboData.push(Json)
		}

		$HUI.combo("#"+id,{
			valueField:"value",
			textField:"text",
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:true,
		});

		var data={"data":comboData}
		data.multiple="true"
		data.rowStyle='checkbox'
		data.onSelect=function(value,old){
			setTimeout(function(){
				detailArea.Data()
			},20)
			
		}
		$("#"+id).combobox(data)
		if(comboData.length==0){
			$(".SortFildName").hide()
		}else{
			$(".SortFildName").show()
		}
		
	},'json',false);
	return rtnData
}


function GetDetailSelectData(rtn){
	var rtnData=""

	var comboData=[]
	for(var i=0;i<rtn.data.length;i++){
		var Array=rtn.data[i]
		var Json={
			"value":Array.field,
			"text":$g(Array.ListAreaColName)	
		}
		
		comboData.push(Json)
	}
	setComboboxData(comboData,"FildName")

	
}
function GetDetailGridColumns(){
	var rtnData=""
	runClassMethod("Nur.SHIFT.Service.ShiftDetailController","GetDetailGridColumns",{"ShiftID":GLOBAL.ShiftID,"TimeID":GetTimeID()},function(rtn){
		rtnData=rtn
	},'json',false);
	return rtnData
}

function GetContentColumns(){
	var rtnData=""
	runClassMethod("Nur.SHIFT.Service.ShiftDetailController","GetContentColumns",{"ShiftID":GLOBAL.ShiftID,"TimeID":GetTimeID()},function(rtn){
		rtnData=rtn
	},'json',false);
	return rtnData
}
var comboxLocData=[]
function GetDetailGridData(IsDeleted){

	var ProjectID=""
	var ProjectIDArrs=[]
	$(".detail-project li.libgselect").each(function(){
		var pid=$(this).attr("ProjectID")
		if(typeof(pid)!="undefined"&&pid !=""){
			ProjectIDArrs.push(pid)
		}
	})
	ProjectID=ProjectIDArrs.join(",")
	var rtnData=""
	var field=$("#SortFildName").combo("getValues")
	
	var WardID=GetSouWardLoc(1),LocID=GetSouWardLoc(2)

	
	console.log('##class(Nur.SHIFT.Service.ShiftDetailController).GetDetailDataByField("'+GLOBAL.ShiftID+'","'+field.join(",")+'","'+ProjectID+'","'+GetTimeID()+'","'+IsDeleted+'","'+WardID+'","'+LocID+'","'+GLOBAL.bookGenral.ContentStyle+'")')
	//gen
	runClassMethod("Nur.SHIFT.Service.ShiftDetailController","GetDetailDataByField",{
		"ShiftID":GLOBAL.ShiftID,
		"SortField":field.join(","),
		"ProjectID":ProjectID,
		"TimeID":GetTimeID(),
		"IsDeleted":IsDeleted,
		"WardID":WardID,
		"LocID":LocID,
		"ContentStyle":GLOBAL.bookGenral.ContentStyle,
		"IsSelectAll":IsSelectAll
		
	},function(rtn){
		rtnData=rtn
		/*var ProjectIDArrs=[]
		$(".detail-project li.libgselect").each(function(){
			var pid=$(this).attr("ProjectID")
			if(typeof(pid)!="undefined"&&pid !=""){
				ProjectIDArrs.push(pid)
			}
		})
		ProjectID=ProjectIDArrs.join(",")
		
		var allLoc=rtnData.data
		if(ProjectID==""){
			//取左侧各个交班项目患者数
			var rtnProjectNum=rtnData.rtnProjectNum
			$(".detail-project").find('li span.count').text(0).hide()
			for(var ProjectID in rtnProjectNum){
				var text=rtnProjectNum[ProjectID]
				if(text!="0"){
					
					$(".detail-project").find('li[projectId="'+ProjectID+'"] span.count').text(text).show()	
				}
			}
		}
		
		*/
		if(LoadSouWardLoc==0){
			LoadSouWardLoc=1
			if(rtnData.souWards!=""){
				var souAll=[{"value":"","text":"全部"}]
				for(var i=0;i<rtnData.souWards.length;i++){
					souAll.push(rtnData.souWards[i])
				}
				
				setComboboxData(souAll,"souWards")
				if(rtnData.souWards.length<=1){
					$(".souWards").hide()
				}else{
					$(".souWards").show()	
				}
	
			}
			if(rtnData.souLocs!=""){
				var souAll=[{"value":"","text":"全部"}]
				for(var i=0;i<rtnData.souLocs.length;i++){
					souAll.push(rtnData.souLocs[i])
				}
				comboxLocData=rtnData.souLocs
				setComboboxData(souAll,"souLocs")
				if(rtnData.souLocs.length<=1){
					$(".souLocs").hide()
				}else{
					$(".souLocs").show()	
				}

			}	
			
		}
		

		

		
	},'json',false);
	return rtnData
}
var LoadSouWardLoc=0
function setComboboxData(comboboxData,comboboxID){
	var data={"data":comboboxData}
	$HUI.combo("#"+comboboxID,{
		valueField:"value",
		textField:"text",
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:true,
	});		
	data.onSelect=function(value,old){
		setTimeout(function(){
			initData()
		},20)
	
	}
	$("#"+comboboxID).combobox(data)
	if(comboboxData.length>0){
		$("#"+comboboxID).combobox("setValue",comboboxData[0].value)
	}
	if(comboboxData.length<=1){
		//$("."+comboboxID).hide()
	}	
	
}

function ShiftTimePrint(){
	var ShiftEmrCode=""
	
	var ClsRow = $('#ShiftClassList').combogrid('grid').datagrid('getSelected');
	runClassMethod("Nur.SHIFT.Service.ShiftConfigController","GetShiftClassById",{"id":ClsRow.ID},function(rtn){
		ShiftEmrCode=rtn.ShiftEmrCode
	},'json',false);
		

	var html='<div class="menu-item printShift" tempCode="'+ShiftEmrCode+'"><div class="menu-text">'+$g("全部班次")+'</div></div>'  
	var printlen=1
	var shiftTimeList=GLOBAL.ShiftTimes
	for(var j=0;j<shiftTimeList.length;j++){
		var shiftData=shiftTimeList[j]
		if(shiftData.ShiftTempCode!="" && typeof(shiftData.ShiftTempCode)!="undefined"){
			html=html+'<div class="menu-item printShift" timeID="'+shiftData.ID+'" tempCode="'+shiftData.ShiftTempCode+'"><div class="menu-text">'+$g(shiftData.ShiftName)+'</div></div>'  
			printlen=printlen+1
		}
	}
	
	$("#print-toolbar").html(html).css("height",(printlen)*30)
	$('#printShift').menubutton({ menu: '#print-toolbar' }); 	
}
function LoadShiftTime(){
	var rtnData=""
	runClassMethod("Nur.SHIFT.Service.ShiftController","GetAreaShiftTime",{"ShiftID":GLOBAL.ShiftID},function(rtn){
		rtnData=rtn.data
	},'json',false);
	return rtnData
}
function LoadBookGenral(){
	var bookGenral=""
	var BookRow = $('#ShiftBookList').combogrid('grid').datagrid('getSelected');
	//alert(BookRow.ID)
	runClassMethod("Nur.SHIFT.Service.ShiftConfigController","GetAllGenral",{"ShiftBookID":BookRow.ID},function(rtn){
		bookGenral=rtn
	},'json',false);
	return bookGenral
}

function GetShiftBookID(){
	var BookRow = $('#ShiftBookList').combogrid('grid').datagrid('getSelected');
	return BookRow.ID
}



//获取当天的交班记录ID
function GetShiftID(){
	var LocID=$("#Locs").combo("getValue")
	var ClsRow = $('#ShiftClassList').combogrid('grid').datagrid('getSelected');
	var BookRow = $('#ShiftBookList').combogrid('grid').datagrid('getSelected');
	var Date=$('#datecombo').datebox("getValue");
	///取患者默认的交班记录
	var ShiftID=""
	runClassMethod("Nur.SHIFT.Service.ShiftController","GetShiftIDByBookID",{"WardID":GLOBAL.WardID,"LocID":LocID,"ShiftBookID":BookRow.ID,"Date":Date,"ClassID":ClsRow.ID},function(rtn){
		ShiftID=rtn
	},'text',false);
	return ShiftID
}
//同步当天交班数据，返回交班实际日期
function LoadShiftDate(){
	var LocID=$("#Locs").combobox("getValue")
	var ClsRow = $('#ShiftClassList').combogrid('grid').datagrid('getSelected');
	var BookRow = $('#ShiftBookList').combogrid('grid').datagrid('getSelected');
	var Date=$('#datecombo').datebox("getValue");
	var ShiftDate=""
	if(LocID!=""){
		runClassMethod("Nur.SHIFT.Service.ShiftController","GetShiftDateByLoc",{"LocID":LocID,"ShiftBookID":BookRow.ID,"Date":Date,"ClassID":ClsRow.ID},function(rtn){
			ShiftDate=rtn.data
		},'json',false);
	}else{
		console.log('##class(Nur.SHIFT.Service.ShiftController).GetShiftDate("'+GLOBAL.WardID+'","'+LocID+'","'+BookRow.ID+'","'+Date+'","'+ClsRow.ID+'")')
		runClassMethod("Nur.SHIFT.Service.ShiftController","GetShiftDate",{"WardID":GLOBAL.WardID,"LocID":LocID,"ShiftBookID":BookRow.ID,"Date":Date,"ClassID":ClsRow.ID},function(rtn){
			ShiftDate=rtn.data
		},'json',false);
	}
	return ShiftDate
}

function LoadShiftClass(){
	var rtnA=[],rtnB=[],data=[]
	///查询全院的班次
	runClassMethod("Nur.SHIFT.Service.ShiftConfigController","GetShiftClassList",{HospID:GLOBAL.HospID, WardID:"", LocID:""},function(rtn){
			rtnA=rtn
	},'json',false);
	///查询本病区的班次
	runClassMethod("Nur.SHIFT.Service.ShiftConfigController","GetShiftClassList",{HospID:GLOBAL.HospID, WardID:GLOBAL.WardID, LocID:""},function(rtn){
			rtnB=rtn
	},'json',false);
	
	for(var i=0;i<rtnA.length;i++){
		rtnA[i].isWard=0
		
		data.push(rtnA[i])
	}
	for(var i=0;i<rtnB.length;i++){
		rtnB[i].isWard=1
		data.push(rtnB[i])
	}
	//console.log(data)
	var selectRow=0
	for(var i=0;i<data.length;i++){
		if(data[i].ShiftIsDefalut=="1"){
			selectRow=i
		}
	}
	var trObj = $HUI.combogrid("#ShiftClassList");
    var grid = trObj.grid();
    grid.datagrid("loadData",{"total":5,"rows":data});
 	grid.datagrid('selectRow',selectRow);	
 	if(data.length<=1){
	    	$(".ShiftClass").hide()    
	    }

}
function LoadShiftBook(){
	var ShiftBookID=""
	runClassMethod("Nur.SHIFT.Service.ShiftConfigController","GetShiftBookByWardList",{"hospID":GLOBAL.HospID,WardID:GLOBAL.WardID},function(rtn){
		

		var selectIndex=0
      	var trObj = $HUI.combogrid("#ShiftBookList");
      	var grid = trObj.grid();
    	grid.datagrid("loadData",{"total":5,"rows":rtn});
        grid.datagrid('selectRow',selectIndex);
        
        if(rtn.length<=1){
	    	$(".ShiftBook").hide()    
	    }
        
	},'json',false);	

}
function DefaultShiftBook(){
	//var LocID=$("#Locs").combo("getValue")
	///通过WardID获取交班本
	var ShiftBookID=""
	runClassMethod("Nur.SHIFT.Service.ShiftController","GetWardShiftBookID",{"WardID":GLOBAL.WardID,"LocID":""},function(rtn){
		ShiftBookID=rtn
	},'text',false);
	return ShiftBookID
	
	
	
}
function LoadWard(){
	var ShiftBookID=GetShiftBookID()
	

		var LocArr=[],comboData=[]
		var comboData=[{
				"value":GLOBAL.WardID,
				"text":session["LOGON.CTLOCDESC"]
			}]
		
		$HUI.combo("#Wards",{
			valueField:"value",
			textField:"text",
			multiple:false,
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:true,
			//data:data
		});
		
		var data={"data":comboData}
		$("#Wards").combobox(data)
		if(comboData.length>0){
			$("#Wards").combobox("setValue",comboData[0].value)
		}
		if(comboData.length<=1){
			$("div.Wards").hide()
		}

}
function LoadLoc(){
	var ShiftBookID=GetShiftBookID()
	var WardID=$("#Wards").combobox("getValue")
	runClassMethod("Nur.SHIFT.Service.ShiftController","GetLocIDByWardID",{"ShiftBookID":ShiftBookID,"WardID":WardID},function(rtn){
		

		
		$HUI.combo("#Locs",{
			valueField:"value",
			textField:"text",
			multiple:false,
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:true,
			//data:data
		});
		
		var data={"data":rtn}
		$("#Locs").combobox(data)
		if(rtn.length>0){
			//alert(rtn[0].value)
			$("#Locs").combobox("setValue",rtn[0].value)
			
		}
		if(rtn.length<=1){
			$("div.Locs").hide()
		}
		
	},"json",false)
}
function LoadWardAndLoc(){
	
	LoadWard()
	LoadLoc()
	var souAll=[{'value':'','text':'全部'}]
	setComboboxData(souAll,'souWards')
	setComboboxData(souAll,'souLocs')
	LoadSouWardLoc=0
	
	return false;
	var rtnData=""
	runClassMethod("Nur.SHIFT.Service.ShiftConfigController","GetLocRoleList",{"WardID":GLOBAL.WardID},function(rtn){
		var comboData=[{
			"value":"",
			"text":$g(rtn[0].WardName)	
		}]
		var LocArr={}
		for(var i=0;i<rtn.length;i++){
			var LocID=rtn[i].LocID
			var LocName=rtn[i].LocName
			if(typeof(LocName)!="undefined"){
				LocArr[LocID]=LocName
			}
		}
		for(var key in LocArr){
			var Json={
				"value":key,
				"text":$g(LocArr[key])	
			}
			comboData.push(Json)
		}
		
		$HUI.combo("#Locs",{
			valueField:"value",
			textField:"text",
			multiple:false,
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:true,
			//data:data
		});
		
		var data={"data":comboData}
		$("#Locs").combobox(data)
		if(comboData.length>0){
			$("#Locs").combobox("setValue",comboData[0].value)
		}
		if(comboData.length<=1){
			//$("#Locs").parents("div.souInput").hide()
		}
		
	},'json',false);	

}

function GetDetailGridDataNotNull(e,val){
	if(val){
		var rows = $("#shiftBookDetail").datagrid('getRows');
		var gridData=[]
		GLOBAL.DetailAllRow=rows
		for(var i=0;i<rows.length;i++){
			if(typeof(rows[i].PatItemRecords)!="undefined"){
				if(rows[i].PatItemRecords.length>0){
					gridData.push(rows[i])
				}
			}
		}
		
		detailLoadData(gridData)
		
	}else{

		
		detailLoadData(GLOBAL.DetailAllRow)
	}	
	

	
	
	
}
function GetOpen2(){
	var customDetailAreaH=$(".customDetailArea").outerHeight()
	var $this=$("tr.tr-customArea")
	if($this.css('display') === 'none'){
		$this.show()
	}else{
		$this.hide()
	}	
    var customAreaTdH=$(".customAreaTd").outerHeight()
    var detailToobarAreaH=$(".detailToobarArea").outerHeight()
    if($this.css('display') === 'none'){
	    customAreaTdH=0
	}
	
	/*if(typeof($H.customDetailAreaH)!="undefined"){
		customDetailAreaH=$H.customDetailAreaH
	}else{
		$H.customDetailAreaH=customDetailAreaH
	}
	if(typeof($H.detailToobarAreaH)!="undefined"){
		detailToobarAreaH=$H.detailToobarAreaH
	}else{
		$H.detailToobarAreaH=detailToobarAreaH
	}*/
	customDetailAreaH=$H.customDetailAreaH
	detailToobarAreaH=$H.detailToobarAreaH
	var DetailH=customDetailAreaH-customAreaTdH-detailToobarAreaH
	
    $(".shiftDetail").height(DetailH)
    $(".detailProjectArea").height(DetailH)
    $(".detail-project").height(DetailH)
    $(".shiftBookDetail").height(DetailH)
	$(".detail-list").height(DetailH)
	
	
	
	
	var detailW=$("td.shiftDetail").width()
	var detailH=$("td.shiftDetail").outerHeight()
	var rows = $("#shiftBookDetail").datagrid('getRows');
	var thisfield=""
	$("#shiftBookDetail").datagrid({
		fit:false,
		height:detailH,
		width:detailW,
	})

	detailLoadData(rows)
}





/**点击单元格编辑start**/
var editIndex = -1;
var editField = "";
var curElement = null;

function getSelectionText(curElement) {
    if (!curElement) {
        return false;
    }
    var selectedText = '';
    if (typeof document.selection != 'undefined') {
         selectedText = document.selection.createRange().text;
    } else {
         selectedText = curElement.value.substr(curElement.selectionStart, curElement.selectionEnd - curElement.selectionStart);
    }
    return selectedText.trim();
}
    
$.extend($.fn.datagrid.defaults.editors, {
    textarea: {
        init: function (container, options) {
	       var row = $("#shiftBookDetail").datagrid("getSelected");
	       var field=container.parents("td").attr("field")
	       var h=container.parents("td").height()
	       //console.log(row)
	      
	       	if(isExitmwin==1){	
           		referHandlerEmr()
           }else{
	       		$('<a href="javascript:void(0)" style="" class="l-btn l-btn-small l-btn-plain" onclick="referHandlerEmr();"><span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">'+$g("引用")+'</span><span class="l-btn-icon icon-ok">&nbsp;</span></span></a>').appendTo(container);


           }
            var input = $('<textarea autoHeight="true" name="shiftContent" style="border:none;border-top:1px solid #ddd;min-height:150px;height:'+(h+30)+'px;resize:none;background:#FFF;">').appendTo(container);
            curElement = input[0];
            input.parents("td").css("background","#FFF")
            input.parents("td").css("vertical-align","top")
            //input.parents("div").css({"display":"inline-block","height": "100%"})
            /*input.bind('contextmenu', function (e) {
                e.preventDefault();
                $('#rightClickMenu').menu('show', {
                    left: e.pageX,
                    top: e.pageY
                });
            });
            input.mouseup(function (e) {
            	curElement = e.target;
            	window.clipboardContent = getSelectionText(e.target);
            	
        	});*/
            return input;
        },
        getValue: function (target) {
            return $(target).val();
        },
        setValue: function (target, value) {
            $(target).val(value);
        },
        resize: function (target, width) {
            var input = $(target);
            if ($.boxModel == true) {
                input.width(width - (input.outerWidth() - input.width()));
            } else {
                input.width(width);
            }
        }
    }
});


// 单击 若有在编辑列关闭编辑
function onDBClickCell(index, field,value) {
	
 	DetailCellFuc.onDBClickCell(index, field,value)
}
function onClickCell(index, field,value) {
    DetailCellFuc.onClickCell(index, field,value)
}
function afterEdit(index, row, changes){
	DetailCellFuc.afterEdit(index, row, changes)
	
}
var DetailCellFuc={
	onDBClickCell:function(index, field,value){
		$("td").removeClass("datagrid-row-selected")
		//双击单元格编辑
		$("#shiftBookDetail").datagrid('selectRow', index).datagrid('editCell', {
	        index: index,
	        field: field
	    }); 
	},
	onClickCell:function(index, field,value){
		//单机单元格取消编辑
		$("td").removeClass("datagrid-row-selected")
		
	    var rows = $("#shiftBookDetail").datagrid('getRows');
	    for (var i = 0; i < rows.length; i++) {
	        $("#shiftBookDetail").datagrid('endEdit', i);
	        $("td").removeClass("datagrid-value-changed");
	    }
	},
	afterEdit:function(index, row,changes){
		var parmas={type:0}
		for(var key in changes){
		 	if(key.indexOf("ShiftContent")>-1){
			 	parmas.TimeID=key.split("-")[1]
			 	parmas.ShiftIndex=key.split("-")[2]
			 	parmas.ShiftContent=changes[key]
			 	parmas.type=1
		 	}else{
			 	parmas.FildName=key
				parmas.FildText=changes[key]
			}
		}
		
		var rows = $("#shiftBookDetail").datagrid('getRows');
		detailLoadData(rows)
		setTimeout(function(){
			if(parmas.type==1){
				parmas.PatientID=row.PatientID
				parmas.ShiftID=row.ShiftID
				parmas.UserID=session["LOGON.USERID"]
				runClassMethod("Nur.SHIFT.Service.ShiftDetailController","SaveTimeContent",{data:JSON.stringify(parmas)},function(rtn){
								
					$.messager.popover({msg: $g('保存成功！'),type:'success'});	
				},"json",true)
			}else{
				
				parmas.ShiftTimeID=row.ShiftTimeID
				parmas.PatientID=row.PatientID
				parmas.ShiftID=row.ShiftID
				parmas.UserID=session["LOGON.USERID"]
				runClassMethod("Nur.SHIFT.Service.ShiftDetailController","SaveShiftPatText",{data:JSON.stringify(parmas)},function(rtn){
					$.messager.popover({msg: $g('保存成功！'),type:'success'});	
				})
				
			}
		},20)
		
	},
	
	
	afterEditBak:function(index, row, changes){
		console.log(row)
		///编辑结束保存数据
		//交班内容纵向时，保存操作
		if(typeof(row.ShiftStyle)!="undefined"&&row.ShiftStyle==2){
			
			//需要判断编辑的是交班信息列还是交班内容列
			if(typeof(changes.ShiftContent)!="undefined"){
				//保存交班内容列时
				var TimeID="ShiftContent-"+row.ShiftTimeID+"-1"
				var ShiftContent=changes.ShiftContent
				//通过记录ID进行修改
				if(typeof(row.PatTimeRowID)!="undefined"&&row.PatTimeRowID==2){
					var rows = $("#shiftBookDetail").datagrid('getRows');
					detailLoadData(rows)
					setTimeout(function(){
						runClassMethod("Nur.SHIFT.Service.ShiftDetailController","SavePatientTimeContentByID",{id:row.PatTimeRowID,content:ShiftContent},function(rtn){
							
							$.messager.popover({msg: $g('保存成功！'),type:'success'});	
						},"json",true)
					},20)
				}else{
					//新增交班
					changes.TimeID=TimeID
					changes.PatientID=row.PatientID
					changes.ShiftContent=ShiftContent
					changes.ShiftID=row.ShiftID
					changes.UserID=session["LOGON.USERID"]
					//console.log(changes)
					var rows = $("#shiftBookDetail").datagrid('getRows');
					detailLoadData(rows)
					setTimeout(function(){
						runClassMethod("Nur.SHIFT.Service.ShiftDetailController","SaveShiftContent",{data:JSON.stringify(changes)},function(rtn){
						
							$.messager.popover({msg: $g('保存成功！'),type:'success'});	
						},"json",true)
						
					},20)
					
				}
			}else{
				//保存患者信息列
				changes.id=row.ID
				var rows = $("#shiftBookDetail").datagrid('getRows');
				detailLoadData(rows)
				setTimeout(function(){	
					runClassMethod("Nur.SHIFT.Service.ShiftDetailController","SavePatientFildContent",{data:JSON.stringify(changes)},function(rtn){
						
						
						$.messager.popover({msg: $g('保存成功！'),type:'success',timeout: 1000});	
					},"json",true)
				},20)
				
			}
			
		}else if(typeof(row.ShiftStyle)!="undefined"&&row.ShiftStyle==3){
			
			var parmas={}
			for(var key in changes){
				 parmas.FildName=key
				 parmas.FildText=changes[key]
			}
			parmas.ShiftTimeID=row.ShiftTimeID
			parmas.PatientID=row.PatientID
			parmas.ShiftID=row.ShiftID
			
			
			runClassMethod("Nur.SHIFT.Service.ShiftDetailController","SaveShiftPatText",{data:JSON.stringify(parmas)},function(rtn){
				///插入交班日志
				var rows = $("#shiftBookDetail").datagrid('getRows');
				detailLoadData(rows)
				$.messager.popover({msg: $g('保存成功！'),type:'success',timeout: 1000});	
			})
			
			
		}else{
			///交班内容横向时，保存操作
			var isNull="",TimeID="",ShiftContent=""
		    for(var key in changes){
				isNull=key
				if(key.indexOf("ShiftContent")>-1){
					TimeID=key
					ShiftContent=changes[key]
				}   
			}
	
			if(isNull!=""){
				changes.id=row.ID
				if(TimeID!=""){
					changes.TimeID=TimeID
					changes.PatientID=row.PatientID
					changes.ShiftContent=ShiftContent
					changes.ShiftID=row.ShiftID
					changes.UserID=session["LOGON.USERID"]
					//console.log(changes)
					runClassMethod("Nur.SHIFT.Service.ShiftDetailController","SaveShiftContent",{data:JSON.stringify(changes)},function(rtn){
						///插入交班日志
						var rows = $("#shiftBookDetail").datagrid('getRows');
						detailLoadData(rows)
						$.messager.popover({msg: $g('保存成功！'),type:'success',timeout: 1000});	
					})
				}else{
				
				
					runClassMethod("Nur.SHIFT.Service.ShiftDetailController","SavePatientFildContent",{data:JSON.stringify(changes)},function(rtn){
						///插入交班日志
						var rows = $("#shiftBookDetail").datagrid('getRows');
						detailLoadData(rows)
						$.messager.popover({msg: $g('保存成功！'),type:'success',timeout: 1000});	
					})
				}
			}
		}
	}
}

/**点击单元格编辑end**/


$('#datecombo').datebox().datebox('calendar').calendar({
    validator: function (date) {
        var curr_time = new Date()
        var d1 = new Date(curr_time.getFullYear(), curr_time.getMonth(), curr_time.getDate());
        return d1 >= date;
    }
});
$('#datecombo').datebox({
    onSelect: function (date) {
        var dateH=$('#datecombo').datebox("getValue");
        $("#Loading").show()	
        initLoad()
    }
});
function updateSbgTableSize() {
    var n = 0;
    var timer = setInterval(function() {
        clearInterval(timer);
    	window.location.reload()
    }, 200);
}

$("#northTable").css({"height":35*5+15,"padding-bottom":"5px"})	
window.addEventListener("resize", updateSbgTableSize)
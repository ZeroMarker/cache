var PageLogicObj={
	m_tabHolidaysSetDataGrid:"",
	m_OffWorkTimesDataGrid:"",
	m_NodeRowid:"",
	m_NodeDesc:""
};
$(function(){
	//初始化
	Init();
	setTimeout(function(){
		InitHospList();
	});
	//事件初始化
	InitEvent();
});
function PageHandle(){
	//表格数据初始化
	OffWorkTimesDataGridLoad();
	tabHolidaysSetDataGridLoad();
	LoadWeekend();
}
function InitEvent(){
	//上下班时间设定
	$('#BAddWorkTimes').click(BAddWorkTimesClick);
	$('#BDelWorkTimes').click(BDelWorkTimesClick);
	$('#BtnWorkTimesSave').click(BtnWorkTimesSaveClick);
	$('#BWorkTimeRecSet').click(BWorkTimeRecSetClick);
	$HUI.checkbox("#Weekend",{
        onCheckChange:function(e,value){
	        var WeekendAsHoliday=0;
	        if (value) WeekendAsHoliday=1;
            SaveWeekendSet(WeekendAsHoliday);
        }
    });
    //节假日日期设定
    $("#BtnHolidaySave").click(BtnHolidaySave);
    $('#List_OrderDept').click(ReLoadOrdDeptConfig);
    $('#BRecSave').click(BRecSaveClick);
}
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_HolidaysRecloc");
	hospComp.jdata.options.onSelect = function(e,t){
		PageHandle();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		PageHandle();
	}
}
function Init(){
	PageLogicObj.m_OffWorkTimesDataGrid=InitOffWorkTimes();
	PageLogicObj.m_tabHolidaysSetDataGrid=InittabHolidaysSetDataGrid();
}
function InittabHolidaysSetDataGrid(){
	var HolidaysSetToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
				$('#HolidayStatrDate,#HolidayEndDate').datebox('setValue',''); 
				$('#HolidayStartTime,#HolidayEndTime').timespinner('setValue','');
                ShowAddHolidayWindow();
            }
        },{
	        text: '删除',
	        iconCls: 'icon-cancel',
	        handler: function() {
	            DelHolidaysSet();
	        }
	   },'-',{
		    text: '接收科室设置',
	        iconCls: 'icon-batch-cfg',
	        handler: function() {
		        var rows = PageLogicObj.m_tabHolidaysSetDataGrid.datagrid("getSelections");
			    if (rows.length <= 0) {
					$.messager.alert("提示", "请先选择一条节假日记录!");
					return false;
				}else{
					$("#List_OrderDept,#List_RecLoc").empty();
					//开医嘱科室
					LoadOrderDept("List_OrderDept");
					//默认接收科室
					LoadRecLoc("List_RecLoc","","","");
					if ($("#RecSetWin").hasClass('window-body')){
						$('#RecSetWin').window('open');
					}else{
						ShowHolidaysRecSetWin();
					}
					PageLogicObj.m_NodeRowid=rows[0]['HolidaySetRowId'];
					PageLogicObj.m_NodeDesc="HolidaysRecStr";
				}
	        }
	   }
	];
	var Columns=[[ 
		{ field: 'HolidaySetRowId', title: 'ID', width: 1, align: 'center',hidden:true},
		{ field: 'RDHStartDate', title: '假日开始日期', width: 110, align: 'center'},
		{ field: 'RDHStartTime', title: '假日开始时间', width: 100, align: 'center'},
		{ field: 'RDHEndDate', title: '假日结束日期', width: 110, align: 'center'},
		{ field: 'RDHEndTime', title: '假日结束时间', width: 100, align: 'center'},
		{ field: 'RDHIsActiveFlag',title: '可用标识', width: 80, align: 'center'},
		{ field: 'RDHCreateUser', title: '创建人', width: 100, align: 'center'},
		{ field: 'RDHCreateDate', title: '创建日期', width: 100, align: 'center'},
		{ field: 'RDHCreateTime',title: '创建时间', width: 100, align: 'center'}
    ]]
	var tabHolidaysSetDataGrid=$("#tabHolidaysSet").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'HolidaySetRowId',
		columns :Columns,
		toolbar :HolidaysSetToolBar
	});
	return tabHolidaysSetDataGrid;
}
function InitOffWorkTimes(){
	var OffWorkTimesSetToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
                ShowAddOffWorkTimesWindow();
            }
        },{
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
	            var rows = OffWorkTimesSetDataGrid.datagrid("getSelections");
                if (rows.length <= 0) {
					$.messager.alert("提示", "请先选择一条记录", "error");
					return false;
				}else{
					$.messager.confirm("提示", "你确定要删除吗?",
					function(r) {
						if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].OffWorkTimesSetRowId);
                            }
                            var OffWorkTimesSetRowId=ids.join(',')
                            $.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.HolidaysRecLoc","DeleteOffWorkTimes","false",function testget(value){
						    if(value=="0"){
							   OffWorkTimesSetDataGrid.datagrid('load');
           					   OffWorkTimesSetDataGrid.datagrid('unselectAll');
           					   $.messager.show({title:"提示",msg:"删除成功"});
						    }else{
							   $.messager.alert('提示',"删除失败:"+value);
						    }
						    },"","",OffWorkTimesSetRowId);
                         }
					})
				}
				
            }
	}];
	 OffWorkTimesSetColumns=[[    
        { field: 'OffWorkTimesSetRowId', title: 'ID', width: 1, align: 'center',hidden:true},
		{ field: 'OffWorkStartTime', title: '上班时间', width: 100, align: 'center'},
		{ field: 'OffWorkEndTime', title: '下班时间', width: 100, align: 'center'},
		{ field: 'Active', title: '是否启用(勾选即保存)', width: 200, align: 'center',formatter:ActiveControl
		}
	 ]];
	OffWorkTimesSetDataGrid=$('#tabOffWorkTimesSet').datagrid({ 
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'OffWorkTimesSetRowId',
		columns :OffWorkTimesSetColumns,
		toolbar :'#OffWorkTimesSetToolBar',
		onLoadSuccess:function(data){
			for (var i=0;i<data.rows.length;i++){
				PageLogicObj.m_OffWorkTimesDataGrid.datagrid('beginEdit',i);
			}
			$HUI.checkbox("input.active-checkbox",{});
		}
	});
	return OffWorkTimesSetDataGrid;
}
function OffWorkTimesDataGridLoad(){
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.HolidaysRecLoc",
	    QueryName : "GetOffWorkTimeList",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.m_OffWorkTimesDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_OffWorkTimesDataGrid.datagrid('unselectAll');
		PageLogicObj.m_OffWorkTimesDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function tabHolidaysSetDataGridLoad(){
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.HolidaysRecLoc",
	    QueryName : "GetHolidaysList",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.m_tabHolidaysSetDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_tabHolidaysSetDataGrid.datagrid('unselectAll');
		PageLogicObj.m_tabHolidaysSetDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function BAddWorkTimesClick(){
	$('#OffWorkStartTime,#OffWorkEndTime').timespinner('setValue','');
	$('#Active').checkbox('check');
	if ($("#OffWorkTimeSetWin").hasClass('window-body')){
		$('#OffWorkTimeSetWin').window('open');
	}else{
		InitWorkWindow();
	}
}
function InitWorkWindow(){
	$('#OffWorkTimeSetWin').window({
		title: '增加上下班时间记录',
		zIndex:9999,
		iconCls:'icon-w-edit',
		inline:false,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closable:true,
		onBeforeClose:function(){
			OffWorkTimesDataGridLoad();
		},
		onOpen:function(){
			$("#OffWorkStartTime").focus();
		}			
	});
}
function BDelWorkTimesClick(){
	var rows = PageLogicObj.m_OffWorkTimesDataGrid.datagrid("getSelections");
    if (rows.length <= 0) {
		$.messager.alert("提示", "请先选择一条上下班记录!");
		return false;
	}else{
		$.messager.confirm("提示", "你确定要删除选择的上下班记录吗?",
		function(r) {
			if (r) {
                var ids = [];
                for (var i = 0; i < rows.length; i++) {
                    ids.push(rows[i].OffWorkTimesSetRowId);
                }
                var OffWorkTimesSetRowId=ids.join(',');
				$.cm({
					ClassName:"DHCDoc.DHCDocConfig.HolidaysRecLoc",
					MethodName:"DeleteOffWorkTimes",
					dataType:"text",
					OffWorkTimesSetRowId:OffWorkTimesSetRowId,
					HospId:$HUI.combogrid('#_HospList').getValue()
				},function(rtn){
					if (rtn==0){
						OffWorkTimesDataGridLoad();
					}
				});
             }
		})
	}
}
function checkTime(startTime,endTime){
	var starArr = startTime.split(':');
	var endArr = endTime.split(':');
	if(starArr[0]>endArr[0]){
		return false;
	}
	if(starArr[0]==endArr[0]){
		if(starArr[1]>endArr[1]){
			return false;
		}
		if(starArr[1]==endArr[1]){
			if(starArr[2]>=endArr[2]){
				return false;
			}
		}
	}
	return true;
}
function BtnWorkTimesSaveClick(){
	var OffWorkStartTime=$('#OffWorkStartTime').timespinner('getValue');
	if(!CheckTime(OffWorkStartTime)){
		$.messager.alert("提示", "上班时间格式不正确");
		return false;
	}
	var OffWorkEndTime=$('#OffWorkEndTime').timespinner('getValue');
	if(!CheckTime(OffWorkEndTime)){
		$.messager.alert("提示", "下班时间格式不正确");
		return false;
	}
	var Active=$("#Active").checkbox('getValue')?1:0;
	if(OffWorkStartTime=="00:00:00") {
		$.messager.alert("提示", "上班时间不能为00:00:00");
		return false;
	}
	if(OffWorkEndTime=="00:00:00") {
		$.messager.alert("提示", "下班时间不能为00:00:00");
		return false;
	}
	if ((OffWorkStartTime!="")&&(OffWorkEndTime!="")&&(!checkTime(OffWorkStartTime,OffWorkEndTime))){
		$.messager.alert("提示", "上班时间不能晚于下班时间:"+OffWorkEndTime);
		return false;
	}
	var Data=OffWorkStartTime+"^"+OffWorkEndTime+"^"+Active;
	$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig3",
		dataType:"text",
		Node:"OffWorkTimesSet",
		Node1:"",
		NodeValue:Data,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},function(rtn){
		if (rtn==0){
			$('#OffWorkTimeSetWin').window('close');
		}
	});
}
function SaveWeekendSet(WeekendAsHoliday){
	$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig",
		dataType:"text",
		Coninfo:"WeekendAsHoliday"+String.fromCharCode(1)+WeekendAsHoliday,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},function(rtn){
	});
}
function LoadWeekend(){
	$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode",
		dataType:"text",
		Node:"WeekendAsHoliday",
		HospId:$HUI.combogrid('#_HospList').getValue()
	},function(rtn){
		if (rtn==1){
			$("#Weekend").checkbox('check');
		}else{
			$("#Weekend").checkbox('uncheck');
		}
	});
}
function BtnHolidaySave(){
	var HolidayStatrDate=$('#HolidayStatrDate').datebox('getValue'); 
	if (HolidayStatrDate==""){
		$.messager.alert("提示", "假日开始日期不能为空");
		return false;
	}
	var HolidayStartTime=$('#HolidayStartTime').timespinner('getValue');
	if ((HolidayStartTime!="")&&(!CheckTime(HolidayStartTime))){
		$.messager.alert("提示", "假日开始时间格式不正确");
		return false;
	}
	var HolidayEndDate=$('#HolidayEndDate').datebox('getValue') 
	if (HolidayEndDate==""){
		$.messager.alert("提示", "假日结束日期不能为空");
		return false;
	}
	var HolidayEndTime=$('#HolidayEndTime').timespinner('getValue');
	if ((HolidayEndTime!="")&&(!CheckTime(HolidayEndTime))){
		$.messager.alert("提示", "假日结束时间格式不正确");
		return false;
	}
	if(HolidayStartTime=="00:00:00") HolidayStartTime="";
	if(HolidayEndTime=="00:00:00") HolidayEndTime="";
	var UserID=session['LOGON.USERID']
	var Data=HolidayStatrDate+"^"+HolidayStartTime+"^"+HolidayEndDate+"^"+HolidayEndTime+"^"+UserID;
	$.cm({
		ClassName:"DHCDoc.DHCDocConfig.HolidaysRecLoc",
		MethodName:"InsertHoliday",
		dataType:"text",
		Data:Data,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},function(rtn){
		if (rtn==0){
			$("#HoliddaysSetWin").window('close');
		}else{
			$.messager.alert('提示',"保存失败:"+rtn);
			return false;
		}
	});
}
function ShowAddHolidayWindow(){
	$('#HoliddaysSetWin').window({
		title: '增加节假日日期记录',
		zIndex:9999,
		iconCls:'icon-w-edit',
		inline:false,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closable:true,
		onBeforeClose:function(){
			tabHolidaysSetDataGridLoad();
		}			
	});
}
function DelHolidaysSet(){
	var rows = PageLogicObj.m_tabHolidaysSetDataGrid.datagrid("getSelections");
    if (rows.length <= 0) {
		$.messager.alert("提示", "请先选择一条节假日日期记录!");
		return false;
	}else{
		$.messager.confirm("提示", "你确定要删除吗?",
		function(r) {
			if (r) {
                var ids = [];
                for (var i = 0; i < rows.length; i++) {
                    ids.push(rows[i].HolidaySetRowId);
                }
                var HolidaySetRowId=ids.join(',');
                $.cm({
					ClassName:"DHCDoc.DHCDocConfig.HolidaysRecLoc",
					MethodName:"DeleteHoliday",
					dataType:"text",
					HolidaySetRowId:HolidaySetRowId
				},function(rtn){
					if (rtn==0){
						tabHolidaysSetDataGridLoad();
					}else{
						$.messager.alert('提示',"删除失败:"+rtn);
						return false;
					}
				});
             }
		})
	}
}
function ShowHolidaysRecSetWin(){
	$('#RecSetWin').window({
		title: '节假日接收科室科室设置',
		zIndex:9999,
		iconCls:'icon-w-edit',
		inline:false,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closable:true,
		onBeforeClose:function(){
			tabHolidaysSetDataGridLoad();
		}			
	});
}
function LoadOrderDept(param1){
	$.cm({
		ClassName:"DHCDoc.DHCDocConfig.HolidaysRecLoc",
		QueryName:"FindDep",
		HospRowId:$HUI.combogrid('#_HospList').getValue(),
		rows:"99999",
	},function(objScope){
	   var vlist = ""; 
	   var selectlist="";
	   jQuery.each(objScope.rows, function(i, n) { 
			    selectlist=selectlist+"^"+n.selected
                vlist += "<option value=" + n.CTLOCRowID + ">" + n.CTLOCDesc + "</option>"; 
       });
       $("#"+param1+"").append(vlist); 
	   for (var j=1;j<=selectlist.split("^").length;j++){
				if(selectlist.split("^")[j]==1){
					$("#"+param1+"").get(0).options[j-1].selected = true;
				}
		}
	});
};
function LoadRecLoc(param1,LocId,NodeRowid,NodeDesc){
	$("#"+param1+"").find("option").remove();
	$.cm({
		ClassName:"DHCDoc.DHCDocConfig.HolidaysRecLoc",
		QueryName:"FindRecDep",
		LocId:LocId,
		NodeRowid:NodeRowid,
		NodeDesc:NodeDesc,
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:"99999",
	},function(objScope){
	   var vlist = ""; 
	   var selectlist="";
	   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.CTLOCRowID + ">" + n.CTLOCDesc + "</option>"; 
       });
       if ($("#"+param1+" option").length==0){
       	   $("#"+param1+"").append(vlist); 
       }
	   for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]==1){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
		}
	});
}
function BWorkTimeRecSetClick(){
	/*var rows = PageLogicObj.m_OffWorkTimesDataGrid.datagrid("getSelections");
    if (rows.length <= 0) {
		$.messager.alert("提示", "请先选择一条上下班记录!");
		return false;*/
	//}else{
		$("#List_OrderDept,#List_RecLoc").empty();
		//开医嘱科室
		LoadOrderDept("List_OrderDept");
		//默认接收科室
		LoadRecLoc("List_RecLoc","","","");

		if ($("#RecSetWin").hasClass('window-body')){
			$('#RecSetWin').window('open');
		}else{
			ShowHolidaysRecSetWin();
		}
		PageLogicObj.m_NodeRowid="OffWorkTimesRec";
		PageLogicObj.m_NodeDesc="OffWorkTimesRecStr";
	//}
}
function ReLoadOrdDeptConfig(){
	var obj=$("#List_OrderDept").find("option:selected");
	if (obj.length==1){
		$("#List_RecLoc").empty();
	}
	for (var i=0;i<obj.length;i++){
		var LocID=obj[i].value;
		LoadRecLoc("List_RecLoc",LocID,PageLogicObj.m_NodeRowid,PageLogicObj.m_NodeDesc);
	}
}
function BRecSaveClick(){
	var obj=$("#List_OrderDept").find("option:selected");
	if (obj.length==0){
		$.messager.alert("提示","请选择患者所在科室!");
		return false;
	}
	for (var i=0;i<obj.length;i++){
		var LocID=obj[i].value;
		var recobj=$("#List_RecLoc").find("option:selected");
		var RecStr="";
		for (var j=0;j<recobj.length;j++){
			if (RecStr=="") RecStr=recobj[j].value;
			else RecStr=RecStr+"^"+recobj[j].value;
		}
		var rtn=$.cm({
			ClassName:"DHCDoc.DHCDocConfig.HolidaysRecLoc",
			MethodName:"SaveRecConfig",
			NodeDesc:PageLogicObj.m_NodeDesc,
			LocId:LocID,
			NodeRowid:PageLogicObj.m_NodeRowid,
			RecLocStr:RecStr,
			HospId:$HUI.combogrid('#_HospList').getValue(),
			dataType:"text"
		},false);
	}
	$("#RecSetWin").window('close');
}
function CheckTime(ParaTime){
	var time= /^([0-1]?[0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$/;
	if (time.test(ParaTime) != true) {
			return false;
	}
	return true;
}
function ActiveControl(value,row,index){
	switch(value){	// Y/N 控制能不能勾选(医嘱项标识)   1/0 控制是否已经勾选（医嘱表加急标志）
		case "0":
			return '<input type=\'checkbox\' class="active-checkbox" id=\'CK_ActiveFlag'+index+'\' onclick=\'setCheckFlag('+index+')\'/>';
		case "1":
			return '<input type=\'checkbox\' class="active-checkbox" id=\'CK_ActiveFlag'+index+'\' checked=\'checked\' onclick=\'setCheckFlag('+index+')\'/>';				
	}	
}
/// 设置rowsData值
function setCheckFlag(index){
	var rows=PageLogicObj.m_OffWorkTimesDataGrid.datagrid('getRows');
	var rowData=rows[index];
	var Node1=rowData.OffWorkTimesSetRowId;
	var OffWorkStartTime=rowData.OffWorkStartTime;
	var OffWorkEndTime=rowData.OffWorkEndTime;
	var Active=$("#CK_ActiveFlag"+index).checkbox('getValue')?1:0;
	var Data=OffWorkStartTime+"^"+OffWorkEndTime+"^"+Active;
	$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig3",
		dataType:"text",
		Node:"OffWorkTimesSet",
		Node1:Node1,
		NodeValue:Data,
		HospId:$HUI.combogrid('#_HospList').getValue(),
	},false);
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}

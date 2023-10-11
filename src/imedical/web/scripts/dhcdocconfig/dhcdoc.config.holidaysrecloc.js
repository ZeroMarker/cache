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
    LoadCheckBoxConf("Weekend","WeekendAsHoliday");
    LoadCheckBoxConf("StrictHolRecLoc","StrictHolRecLoc");
}
function InitEvent(){
	//上下班时间设定
	$('#BAddWorkTimes').click(BAddWorkTimesClick);
	$('#BDelWorkTimes').click(BDelWorkTimesClick);
	$('#BtnWorkTimesSave').click(BtnWorkTimesSaveClick);
	$('#BWorkTimeRecSet').click(BWorkTimeRecSetClick);
	$HUI.checkbox("#Weekend",{
        onCheckChange:function(e,value){
            SaveCheckBoxConf("Weekend","WeekendAsHoliday");
        }
    });
	$HUI.checkbox("#StrictHolRecLoc",{
        onCheckChange:function(e,value){
            SaveCheckBoxConf("StrictHolRecLoc","StrictHolRecLoc");
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
					// $("#List_OrderDept,#List_RecLoc").empty();
					// //开医嘱科室
					// LoadOrderDept("List_OrderDept");
					// //默认接收科室
					// LoadRecLoc("List_RecLoc","","","");
					// if ($("#RecSetWin").hasClass('window-body')){
					// 	$('#RecSetWin').window('open');
					// }else{
					// 	ShowHolidaysRecSetWin();
					// }
					// PageLogicObj.m_NodeRowid=rows[0]['HolidaySetRowId'];
					// PageLogicObj.m_NodeDesc="HolidaysRecStr";

					RecSetTableWinObj.Init("HolidaysRecStr",rows[0]['HolidaySetRowId'])
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
		{ field: 'RDHIsActiveFlag',title: '可用标识', hidden:true},
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
		ClassName:"DHCDoc.DHCDocConfig.HolidaysRecLoc",
		MethodName:"SaveOffWorkTimes",
		dataType:"text",
		
		Node1:"",
		NodeValue:Data,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},function(rtn){
		if (rtn==0){
			$('#OffWorkTimeSetWin').window('close');
		}else{
			$.messager.alert("提示", rtn);
		}
	});
}

function LoadCheckBoxConf(ObjID,ObjKey){
    var HospId=$HUI.combogrid('#_HospList').getValue();
    $.cm({
        ClassName:"web.DHCDocConfig",
        MethodName:"GetConfigNode",
        dataType:"text",
        Node:ObjKey,
        HospId:HospId
    },function(rtn){
        if (rtn==1){
            $("#"+ObjID).checkbox('check');
        }else{
            $("#"+ObjID).checkbox('uncheck');
        }
    });

}

function SaveCheckBoxConf(ObjID,ObjKey){
    var HospId=$HUI.combogrid('#_HospList').getValue();
    var Value=$("#"+ObjID).checkbox('getValue')?"1":"0";
    var Coninfo=ObjKey+String.fromCharCode(1)+Value;
    $.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig",
		dataType:"text",
		Coninfo:Coninfo,
		HospId:HospId
	},function(rtn){
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

	RecSetTableWinObj.Init("OffWorkTimesRecStr","")


	// $("#List_OrderDept,#List_RecLoc").empty();
	// //开医嘱科室
	// LoadOrderDept("List_OrderDept");
	// //默认接收科室
	// LoadRecLoc("List_RecLoc","","","");

	// if ($("#RecSetWin").hasClass('window-body')){
	// 	$('#RecSetWin').window('open');
	// }else{
	// 	ShowHolidaysRecSetWin();
	// }
	// PageLogicObj.m_NodeRowid="OffWorkTimesRec";
	// PageLogicObj.m_NodeDesc="OffWorkTimesRecStr";
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
		ClassName:"DHCDoc.DHCDocConfig.HolidaysRecLoc",
		MethodName:"SaveOffWorkTimes",
		dataType:"text",
		
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

///弹出的接收科室维护界面的方法及参数封装
var RecSetTableWinObj=(function(){
	var m_RecHolidayDr;		//""						HolidaySetRowId
	var m_ConfigType;		//OffWorkTimesRecStr		HolidaysRecStr
	var m_tabOrderDeptParam;
	var m_tabRecLoc;
	var OrderDeptEditRow;
	var RecLocEditRow;
	//初始化
	var Init=function(ConfigType,RecHolidayDr){
		if ($("#RecSetTableWin").hasClass('window-body')){
			$('#RecSetTableWin').window('open');
		}else{
			ShowHolidaysRecSetTableWin();
		}
		m_RecHolidayDr=RecHolidayDr;
		m_ConfigType=ConfigType;
		if (m_ConfigType=="OffWorkTimesRecStr"){
			$('#RecSetTableWin').window('setTitle','上下班接收科室设置');
		}else{
			$('#RecSetTableWin').window('setTitle','节假日接收科室设置');
		}
		OrderDeptEditRow=undefined;
		m_tabOrderDeptParam=InittabOrderDeptParam();
		m_tabRecLoc=InittabRecLoc();
	}
	function ShowHolidaysRecSetTableWin(){
		$('#RecSetTableWin').window({
			title: '1',
			width:900,
			height:510,
			iconCls:'icon-w-edit',
			inline:false,
			minimizable: false,
			maximizable: false,
			collapsible: false,
			closable:true,
			onBeforeClose:function(){
				m_RecHolidayDr=""
				m_ConfigType=""
				OrderDeptEditRow=undefined;
				RecLocEditRow=undefined;
				m_tabOrderDeptParam.datagrid("clearSelections")
				m_tabRecLoc.datagrid("clearSelections")
				tabHolidaysSetDataGridLoad();
			}			
		});
	}
	//初始化开医嘱科室及医嘱参数
	function InittabOrderDeptParam(){
		var OECPriirtyStr=$.cm({
			ClassName:"DHCDoc.DHCDocConfig.HolidaysRecLoc",
			MethodName:"GetOECPriirty"
		},false).rows;
		var OrderDeptParamToolBar = [{
				text: '增加',
				iconCls: 'icon-add',
				handler: function() { 
					OrderDeptEditRow = undefined;
					m_tabOrderDeptParam.datagrid("rejectChanges").datagrid("unselectAll");
					if (OrderDeptEditRow != undefined) {
						m_tabOrderDeptParam.datagrid("endEdit", OrderDeptEditRow);
						return;
					}else{
						 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
						m_tabOrderDeptParam.datagrid("insertRow", {
							index: 0,
							row: {}
						});
						m_tabOrderDeptParam.datagrid("beginEdit", 0);
						OrderDeptEditRow = 0;
						var editors = m_tabOrderDeptParam.datagrid('getEditors', OrderDeptEditRow);
						editors[1].target.combobox('setValue',ServerObj.NormPriorID)
						editors[2].target.combobox('setValue',"All")
						$(editors[3].target).checkbox("check")
					}
				}
        	},{
				text: '保存',
				iconCls: 'icon-save',
				handler: function() {
					if (OrderDeptEditRow == undefined){
						$.messager.alert("提示","没有需要保存的数据!");
						return false;
					}
					var editors = m_tabOrderDeptParam.datagrid('getEditors', OrderDeptEditRow);  
					var SelRow=m_tabOrderDeptParam.datagrid("selectRow",OrderDeptEditRow).datagrid("getSelected"); 
					var RowID=SelRow["RowID"];
					var OrdLocDr=SelRow["OrdLocDr"];
					if ((OrdLocDr=="")||(OrdLocDr==undefined)){
						$.messager.alert("提示","请选择病人科室!");
						return false;
					}
					//医嘱类型
					var OrderPrior=editors[1].target.combobox('getValue');
					//加急类型
					var NotifyClinician=editors[2].target.combobox('getValue');
					if ((NotifyClinician=="")){
						$.messager.alert("提示","请选择加急类型!");
						return false;
					}
					//启用
					var IsActiveFlag=editors[3].target.is(":checked");
					if (IsActiveFlag){IsActiveFlag="Y";}else{IsActiveFlag="N";}
					
					var Val=m_ConfigType+"^"+m_RecHolidayDr+"^"+OrdLocDr+"^"+"^"+IsActiveFlag+"^"+OrderPrior+"^"+NotifyClinician
					
					$.cm({
						ClassName:"DHCDoc.DHCDocConfig.HolidaysRecLoc",
						MethodName:"SaveRecConfig",
						RowID:RowID,
						HospId:$HUI.combogrid('#_HospList').getValue(),
						Val:Val,
						dataType:"text"
					},function(value){
						if(value=="0"){
							m_tabOrderDeptParam.datagrid("endEdit",OrderDeptEditRow);
							OrderDeptEditRow = undefined;
							m_tabOrderDeptParam.datagrid("reload").datagrid("unselectAll");
						}else{
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
					});
				}
			},{
				text: '删除',
				iconCls: 'icon-remove',
				handler: function() {
					var rows = OrderDeptParamDataGrid.datagrid("getSelections");
					if (rows.length <= 0) {
						$.messager.alert("提示", "请先选择一条记录", "error");
						return false;
					}else{
						$.messager.confirm("提示", "你确定要删除吗?",
						function(r) {
							if (r) {
								var ids = [];
								for (var i = 0; i < rows.length; i++) {
									ids.push(rows[i].RowID);
								}
								var RowID=ids.join(',')

								$.cm({
									ClassName:"DHCDoc.DHCDocConfig.HolidaysRecLoc",
									MethodName:"DeleteOffWorkTimesDetails",
									OffWorkTimesSetRowId:RowID,
									HospId:$HUI.combogrid('#_HospList').getValue(),
									dataType:"text"
								},function(value){
									if(value=="0"){
										OrderDeptEditRow = undefined;
										m_tabOrderDeptParam.datagrid("reload").datagrid("unselectAll");
										m_tabRecLoc.datagrid("reload");
										$.messager.show({title:"提示",msg:"删除成功"});
									}else{
										$.messager.alert('提示',"删除失败:"+value);
										return false;
									}
								});
							}
						})
					}
					
				}
			},"-",{
				text: '关联子类',
				iconCls: 'icon-edit',
				handler: function() {
					var rows = OrderDeptParamDataGrid.datagrid("getSelections");
					if (rows.length <= 0) {
						$.messager.alert("提示", "请先选择一条记录", "error");
						return false;
					}
					var HospID=$HUI.combogrid('#_HospList').getValue();
					var RowID=rows[0].RowID;
					var ItemCatList=rows[0].ItemCatList;
					ConectModel(HospID,RowID,ItemCatList)
					function ConectModel(HospID,RowID,ItemCatList){
					websys_showModal({
						url:"dhcdoc.util.tablelist.csp?TableName=ARC_ItemCat&IDList="+ItemCatList+"&HospDr="+HospID,
						title:' 子类选择',
						width:400,height:610,
						closable:false,
						CallBackFunc:function(result){
							websys_showModal("close");
							if ((typeof result==="undefined")||(result===false)){
								return;
							}
							if (result==""){
								$.messager.alert('提示',"保存失败，未选中数据！");
								return false;
							}
							var value =tkMakeServerCall("DHCDoc.DHCDocConfig.HolidaysRecLoc","UpdateItemCatList",RowID,result)
							if(value=="0"){
								OrderDeptEditRow = undefined;
								m_tabOrderDeptParam.datagrid("reload").datagrid("unselectAll");
								$.messager.show({title:"提示",msg:"更新成功"});
							}else{
								$.messager.alert('提示',"更新失败:"+value,'error',function (){ConectModel(HospID,RowID,ItemCatList)});
								return false;
							}
						}
					})
					}
				}
			},"-",{
				text: '例外的医嘱项',
				iconCls: 'icon-edit',
				handler: function() {
					var rows = OrderDeptParamDataGrid.datagrid("getSelections");
					if (rows.length <= 0) {
						$.messager.alert("提示", "请先选择一条记录", "error");
						return false;
					}
					var HospID=$HUI.combogrid('#_HospList').getValue();
					var RowID=rows[0].RowID;
					var ExceptionArcimList=rows[0].ExceptionArcimList;
					showmodediag(HospID,RowID,ExceptionArcimList)
					function showmodediag(HospID,RowID,ExceptionArcimList){
						websys_showModal({
							url:"dhcdoc.util.tablelist.csp?TableName=ARC_ItmMast&IDList="+ExceptionArcimList+"&HospDr="+HospID+"&DisplayType=Search",
							title:' 例外的医嘱项选择',
							width:400,height:610,
							closable:false,
							CallBackFunc:function(result){
								websys_showModal("close");
								if ((typeof result==="undefined")||(result===false)){
									return;
								}
								// if (result==""){
								// 	$.messager.alert('提示',"未选中数据");
								// 	return false;
								// }
								var value =tkMakeServerCall("DHCDoc.DHCDocConfig.HolidaysRecLoc","UpdateArcimList",RowID,result)
								if(value=="0"){
									OrderDeptEditRow = undefined;
									m_tabOrderDeptParam.datagrid("reload").datagrid("unselectAll");
									$.messager.show({title:"提示",msg:"更新成功"});
								}else{
									$.messager.alert('提示',"更新失败:"+value,'error',function (){showmodediag(HospID,RowID,ExceptionArcimList)});
									return false;
								}
							}
						})
					}
				}
			}];
		var OrderDeptParamColumns=[[    
			{ field: 'RowID', title: 'ID', width: 1, align: 'center',hidden:true},
			{ field: 'OrdLocDr',hidden:true},
			{ field: 'OrderDept', title: '病人科室', width: 300, align: 'center', 
				editor:{
					type:'combogrid',
					options:{
						required: true,
						idField:'CTLOCRowID',
						textField:'CTLOCDesc',
						value:'',//缺省值 
						mode:'remote',
						//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LabBindRuleSetting&QueryName=LookUpAllLoc",
						url:$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmbGroup",
						columns:[[
							{field:'CTLOCDesc',title:'名称',width:300,sortable:true},
							{field:'CTLOCRowID',title:'ID',width:120,sortable:true},
						]],onSelect : function(rowIndex, rowData) {
							var ArcimSelRow=m_tabOrderDeptParam.datagrid("selectRow",OrderDeptEditRow).datagrid("getSelected"); 
							ArcimSelRow.OrdLocDr=rowData.CTLOCRowID;
						},onLoadSuccess:function(data){
							$(this).next('span').find('input').focus();
						},onBeforeLoad:function(param){
							var desc="";
							if (param['q']) {
								var desc=param['q'];
							}
							param = $.extend(param,{hospid:$HUI.combogrid('#_HospList').getValue(),tablename:"DHCExaBorough",desc:desc,start:0,limit:9999,rows:9999});
						}
					}
				}
			},
			{ field: 'OrderPrior', title: '医嘱类型', width: 100, align: 'center',
				editor : {
					type:'combobox',
					options:{
						valueField:'OECPR_RowId',
						textField:'OECPR_Desc',
						required:false,
						data:OECPriirtyStr,
						onSelect:function(rec){}
					}
				}
			},
			{ field: 'NotifyClinician', title: '加急', width: 100, align: 'center',
				editor : {
					type:'combobox',
					options:{
						valueField:'code',
						textField:'desc',
						required:true,
						data:[{"code":"All","desc":"全部"},{"code":"N","desc":"普通"},{"code":"Y","desc":"加急"}],
						onSelect:function(rec){}
					}
				},formatter: function(value,row,index){
					if (value=="All"){
						return "全部";
					}else if (value=="N"){
						return "普通";
					}else if (value=="Y"){
						return "加急";
					}
				}
			},{
				field : 'IsActiveFlag',title : '启用',width:60,align:"center",
				editor : {
					type : 'icheckbox',
					options : {
						on : 'Y',
						off : 'N'
					}
				}
			},{ field: 'ItemCatList', title: '关联子类', hidden:true
			},{ field: 'ExceptionArcimList', title: '例外的医嘱项', hidden:true}

			
		]];
		OrderDeptParamDataGrid=$('#tabOrderDeptParam').datagrid({ 
			fit : true,
			border : false,
			striped : true,
			singleSelect : true,
			fitColumns : false,
			autoRowHeight : false,
			pagination : false,  
			idField:'RowID',
			columns :OrderDeptParamColumns,
			toolbar :OrderDeptParamToolBar,
			url:$URL+"?ClassName=DHCDoc.DHCDocConfig.HolidaysRecLoc&QueryName=FindRecConfig&ConfigType="+m_ConfigType+"&HolidayDr="+m_RecHolidayDr+"&HospId="+$HUI.combogrid('#_HospList').getValue(),
			onLoadSuccess:function(data){
				for (var i=0;i<data.rows.length;i++){
					PageLogicObj.m_OffWorkTimesDataGrid.datagrid('beginEdit',i);
				}
				$HUI.checkbox("input.active-checkbox",{});
			},onDblClickRow:function(rowIndex, rowData){
				if (OrderDeptEditRow != undefined) {
					$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
					return false;
				}
				m_tabOrderDeptParam.datagrid("beginEdit", rowIndex);
				OrderDeptEditRow=rowIndex;
				var editors = m_tabOrderDeptParam.datagrid('getEditors', rowIndex);  
				var OECPriorJson=editors[1].target.combobox('options').data;
				var OECPRRowId="";
				OECPriorJson.forEach(function(obj){
					if (obj.OECPR_Desc==rowData.OrderPrior){
						OECPRRowId=obj.OECPR_RowId;
						return false;
					}
				});
				//医嘱类型
				editors[1].target.combobox('setValue',OECPRRowId);
			},onClickRow:function(rowIndex, rowData){
				m_tabRecLoc.datagrid("reload");
			},onSelect:function(rowIndex, rowData){
				RecLocEditRow = undefined;
				m_tabRecLoc.datagrid("reload").datagrid("unselectAll");
			}
		});
		return OrderDeptParamDataGrid;
	}
	function InittabRecLoc(){
		var RecLocToolBar = [{
			text: '增加',
			iconCls: 'icon-add',
			handler: function() { 
				var OrderDeptRow = m_tabOrderDeptParam.datagrid('getSelected');  
				if (OrderDeptRow == null){
					$.messager.alert("提示","未选择病人科室信息!");
					return false;
				}
				RecLocEditRow = undefined;
				m_tabRecLoc.datagrid("rejectChanges").datagrid("unselectAll");
				if (RecLocEditRow != undefined) {
					m_tabRecLoc.datagrid("endEdit", RecLocEditRow);
					return;
				}else{
					 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
					m_tabRecLoc.datagrid("insertRow", {
						index: 0,
						row: {}
					});
					m_tabRecLoc.datagrid("beginEdit", 0);
					RecLocEditRow = 0;
				}
			}
		},{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				if (RecLocEditRow == undefined){
					$.messager.alert("提示","没有需要保存的数据!");
					return false;
				}
				var OrderDeptRow = m_tabOrderDeptParam.datagrid('getSelected');  
				if (OrderDeptRow == null){
					$.messager.alert("提示","未选择病人科室信息!");
					return false;
				}
				var OrderDeptRowID=OrderDeptRow["RowID"];

				var editors = m_tabRecLoc.datagrid('getEditors', RecLocEditRow);  
				var SelRow=m_tabRecLoc.datagrid("selectRow",RecLocEditRow).datagrid("getSelected"); 
				var RecLocDr=SelRow["RecLocDr"];
				if ((RecLocDr=="")||(RecLocDr==undefined)){
					$.messager.alert("提示","请选择接收科室!");
					return false;
				}
				$.cm({
					ClassName:"DHCDoc.DHCDocConfig.HolidaysRecLoc",
					MethodName:"UpdateRecLocInfo",
					TYPE:"Add",
					RowID:OrderDeptRowID,
					RecLocDr:RecLocDr,
					dataType:"text"
				},function(value){
					if(value=="0"){
						RecLocEditRow = undefined;
						m_tabRecLoc.datagrid("reload").datagrid("unselectAll");
					}else{
						$.messager.alert('提示',"保存失败:"+value);
						return false;
					}
				});
			}
		},{
			text: '删除',
			iconCls: 'icon-remove',
			handler: function() {
				var OrderDeptRow = m_tabOrderDeptParam.datagrid('getSelected');  
				if (OrderDeptRow == null){
					$.messager.alert("提示","未选择病人科室信息!");
					return false;
				}
				var OrderDeptRowID=OrderDeptRow["RowID"];

				var row = RecLocDataGrid.datagrid("getSelected");
				if (row == null) {
					$.messager.alert("提示", "请先选择一条接收科室记录", "error");
					return false;
				}
				$.messager.confirm("提示", "你确定要删除吗?",
				function(r) {
					if (r) {
						var RecLocDr=row.ReclocDr
						$.cm({
							ClassName:"DHCDoc.DHCDocConfig.HolidaysRecLoc",
							MethodName:"UpdateRecLocInfo",
							TYPE:"Delete",
							RowID:OrderDeptRowID,
							RecLocDr:RecLocDr,
							dataType:"text"
						},function(value){
							if(value=="0"){
								m_tabOrderDeptParam.datagrid("endEdit",RecLocEditRow);
								RecLocEditRow = undefined;
								m_tabRecLoc.datagrid("reload").datagrid("unselectAll");
							}else{
								$.messager.alert('提示',"保存失败:"+value);
								return false;
							}
						});
					}
				})
				
				
			}
		}];
		var RecLocColumns=[[    
			{ field: 'RecLocDr',hidden:true},
			{ field: 'RecLoc', title: '接收科室', width: 240, align: 'center', 
				editor:{
					type:'combogrid',
					options:{
						required: true,
						idField:'CTLOCRowID',
						textField:'CTLOCDesc',
						value:'',//缺省值 
						mode:'remote',
						//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.HolidaysRecLoc&QueryName=LookUpAllLoc",
						url:$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1",
						columns:[[
							{field:'CTLOCDesc',title:'名称',width:300,sortable:true},
							{field:'CTLOCRowID',title:'ID',width:120,sortable:true},
						]],onSelect : function(rowIndex, rowData) {
							var ArcimSelRow=m_tabRecLoc.datagrid("selectRow",RecLocEditRow).datagrid("getSelected"); 
							ArcimSelRow.RecLocDr=rowData.CTLOCRowID;
						},onLoadSuccess:function(data){
							$(this).next('span').find('input').focus();
						},onBeforeLoad:function(param){
							var desc="";
							if (param['q']) {
								var desc=param['q'];
							}
							param = $.extend(param,{desc:desc,start:0,limit:9999,rows:9999});
							///param = $.extend(param,{Desc:desc,rows:9999});
						}
					}
				}
			}
		]];
		RecLocDataGrid=$('#tabRecLoc').datagrid({ 
			fit : true,
			border : false,
			striped : true,
			singleSelect : true,
			fitColumns : false,
			autoRowHeight : false,
			pagination : false,  
			idField:'ReclocDr',
			textField:'RecLoc',
			columns :RecLocColumns,
			toolbar :RecLocToolBar,
			url:$URL+"?ClassName=DHCDoc.DHCDocConfig.HolidaysRecLoc&QueryName=FindRecDetails&RDHDr=",
			onLoadSuccess:function(data){
				for (var i=0;i<data.rows.length;i++){
					PageLogicObj.m_OffWorkTimesDataGrid.datagrid('beginEdit',i);
				}
				$HUI.checkbox("input.active-checkbox",{});
			},onBeforeLoad:function(param){
				var rows = OrderDeptParamDataGrid.datagrid("getSelections");
				if (rows.length <= 0) {
					var RDHDr="";
				}else{
					var RDHDr=rows[0].RowID;
				}
				param = $.extend(param,{RDHDr:RDHDr});
			}
		});
		return RecLocDataGrid;
	}
	return {
		Init:Init
	}
})()

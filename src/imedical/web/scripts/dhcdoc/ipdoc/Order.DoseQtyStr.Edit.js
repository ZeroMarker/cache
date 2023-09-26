var PageLogicObj = {
	m_OrdItemDoseQtyList:"",
	DoseStrSttDate:""
}
$(function(){
	//页面元素初始化
	PageHandle();
	//事件初始化
	InitEvent();
});
function PageHandle(){
	PageLogicObj.m_OrdItemDoseQtyList=InitOrdItemDoseQtyList();
	LoadOrdItemDoseQtyList();
}
function InitEvent(){
	//$('#DoseStrSttDate').datebox('setValue', ServerObj.DefaultDoseStrSttDate);
	$("#update").click(update_onclick);
	$("#clear").click(clear_onclick);
	$("#Close").click(Close_onclick);
	$(".doseqty").keyup(DoseQtyKeyDown);
	
	
	var dateFormate="d/m/Y H:i:S"; //d-m-Y H:i:S
    if (ServerObj.sysDateFormat==3){
        dateFormate="Y-m-d H:i:S"
    }
	PageLogicObj.DoseStrSttDate=$("#DoseStrSttDate").flatpickr({
    	enableTime: true,
    	enableSeconds:true,
    	dateFormat: dateFormate,
    	time_24hr: true,
    	onOpen:function(pa1,ap2){
	        PageLogicObj.DoseStrSttDate.setDate(ap2,true);
	    }
    });
	PageLogicObj.DoseStrSttDate.setDate(ServerObj.DefaultDoseStrSttDate,true);
}

function DoseQtyKeyDown(e){
	var id=e.target.id;
	var keycode=websys_getKey(e);
	if (keycode==13) {
		var len=$(".doseqty").length;
		for (var i=0;i<len;i++){
			if ($(".doseqty")[i].id==id){
				if (i==(len-1)){
					update_onclick();
					$("#"+$(".doseqty")[0].id).focus();
				}else{
					$("#"+$(".doseqty")[i+1].id).focus();
				}
				return;
			}
		}
	}
	if ((keycode == 8) || (keycode == 9) || (keycode == 190) || (keycode == 46) || (keycode == 13) || (keycode == 110) || ((keycode > 47) && (keycode < 58)) || ((keycode > 95) && (keycode < 106)))  {
		var val=$("#"+id).val();
		$("#"+id).val(val.replace(/。/g,'.'));
	} else {
        window.event.keyCode = 0;
        return websys_cancel();
    }
}
function update_onclick(){
	var FreqStr="";
	var len=$(".doseqty").length;
	for (var i=0;i<len;i++){
		var id=$(".doseqty")[i].id;
		var value=$.trim($("#"+id).val());
		if (value==""){
			$.messager.alert("提示","剂量不能为空!","info",function(){
				$("#"+id).focus();
			})
			return;
		}else{
			if (!isNumber(value)||(value<=0)){
				$.messager.alert("提示","请填写正确的剂量!","info",function(){
					$("#"+id).focus();
				})
				return;
			}
			if (+value>9999) {
				$.messager.alert("提示","剂量不能超过9999","info",function(){
					$("#"+id).focus();
				})
				return;
			}
			if (FreqStr=="") FreqStr=id+"$"+value; //.replace("_","||")
			else FreqStr=FreqStr+"!"+id+"$"+value;
		}
	}
	var SttDateStr=$("#DoseStrSttDate").val();
	var UserAdd=session['LOGON.USERID'];
	var rtn=$.cm({
		ClassName:"web.DHCOEOrdItemDoseQty",
		MethodName:"InsertDoseQtyList",
		OEORIRowid:ServerObj.OEORIRowid,
		DoseQtyStr:FreqStr,
		SttDateStr:SttDateStr,
		UserAdd:UserAdd,
		dataType:"text",
		Pagerows:PageLogicObj.m_OrdItemDoseQtyList.datagrid("options").pageSize,rows:99999
	},false);
	var rtnArr=rtn.split("^");
	if (rtnArr[0]=="0"){
		clear_onclick();
		LoadOrdItemDoseQtyList();
	}else{
		$.messager.alert("失败",rtn);
	}
}
function clear_onclick(){
	
	ServerObj.DefaultDoseStrSttDate=$.cm({
		ClassName:"web.DHCOEOrdItemDoseQty",
		MethodName:"GetDefaultDoseStrSttDate",
		OEORIRowid:ServerObj.OEORIRowid,
		dataType:"text"
	},false);
	PageLogicObj.DoseStrSttDate.setDate(ServerObj.DefaultDoseStrSttDate,true);
	$(".doseqty").val("");
}
function Close_onclick(){
	var FreqStr="";
	var len=$(".doseqty").length;
	for (var i=0;i<len;i++){
		var id=$(".doseqty")[i].id;
		var value=$.trim($("#"+id).val());
		if ((value=="")||(!isNumber(value))||(value<=0)||(+value>9999)) {
			websys_showModal("options").CallBackFunc("");
			return;
		}
		if (FreqStr=="") FreqStr=id+"$"+value;
		else FreqStr=FreqStr+"!"+id+"$"+value;
	}
	websys_showModal("options").CallBackFunc(FreqStr);
}
function isNumber(objStr){
	strRef = "1234567890.";
	for (i=0;i<objStr.length;i++) {
		tempChar= objStr.substring(i,i+1);
		if (strRef.indexOf(tempChar,0)==-1) {return false;}
	}
	return true;
}


function InitOrdItemDoseQtyList(){
	var columnsList=[[
		{field:'ID',hidden:true},
		{field:'OIDQDoseQtyStr',title:"单次剂量",width:120,align:'left'},
		{field:'DoseUOM',title:"单位",width:50,align:'left'},
		{field:'IDQActive',title:"有效",width:60,align:'left'},
		{field:'OIDQSttDate',title:"生效日期",width:110,align:'left'},
		{field:'OIDQSttTime',title:"生效时间",width:60,align:'left'},
		{field:'OIDQDoctor',title:"添加人",width:60,align:'left'},
		{field:'OIDQEndDate',title:"截止日期",hidden:true},
		{field:'OIDQEndTime',title:"截止时间",hidden:true},
		{field:'OIDQNote',title:"备注",hidden:true},
		{field:'OIDQInsertDate',title:"添加日期",width:110,align:'left'},
		{field:'OIDQInsertTime',title:"添加时间",width:60,align:'left'},
		{field:'OIDQExeFlag',title:"已生效",width:60,align:'left',hidden:true},
		{field:'OIDQExeDate',title:"生效日期",width:110,align:'left',hidden:true},
		{field:'OIDQExeTime',title:"生效时间",width:60,align:'left',hidden:true},
		{field:'OIDQLastUpdateDate',title:"最后更新日期",width:110,align:'left',hidden:true},
		{field:'OIDQLastUpdateTime',title:"最后更新时间",width:60,align:'left',hidden:true},
		{field:'OIDQLastUpdateDoctor',title:"最后更新人",width:150,align:'left',hidden:true}
		
	]];
	var tabdatagrid=$('#OrdItemDoseQtyList').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : false,   
		//pageSize: 20,
		//pageList : [20,50],
		idField:"ID",
		columns :columnsList
	});
	
	
	return tabdatagrid
}
function LoadOrdItemDoseQtyList(){
	var GridData=$.cm({
		ClassName:"web.DHCOEOrdItemDoseQty",
		QueryName:"QueryDoseQtyList",
		OEORIRowid:ServerObj.OEORIRowid,
		Pagerows:PageLogicObj.m_OrdItemDoseQtyList.datagrid("options").pageSize,rows:99999
	},false);
	PageLogicObj.m_OrdItemDoseQtyList.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
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
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
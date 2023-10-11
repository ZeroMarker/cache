$(function(){
	//页面元素初始化
	PageHandle();
	initReCallPatListTab();
	$("#BFind").click(function(){
		$('#recallPatListTab').datagrid("reload");
	});
	document.onkeydown = DocumentOnKeyDown;
})
function PageHandle(){
	$("#Startdate").datebox("setValue",ServerObj.defStDate);
	$("#Enddate").datebox("setValue",ServerObj.curDate);
	//科室
	LoadDept(); 
	//病区
	LoadWard();
	$("#isFinish").combobox({
		valueField: 'id',
		textField: 'text',
		data:[{"id":"Y","text":$g("是")},{"id":"N","text":$g("否")}],
		multiple:true,
		rowStyle:'checkbox'
	})
	$("#recallType").combobox({
		valueField: 'id',
		textField: 'text',
		data:[{"id":"C","text":$g("医生召回")},{"id":"R","text":$g("护士召回")}],
		multiple:true,
		rowStyle:'checkbox'
	})
}
function LoadDept(){
	$.cm({
		ClassName:"web.DHCBillOtherLB",
		QueryName:"QryIPDept",
	   	desc:"",hospId:session['LOGON.HOSPID'],
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#CTLoc", {
				valueField: 'id',
				textField: 'text', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["text"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["contactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onSelect: function(rec){ 
					$("#WardDesc").combobox('setValue',"").combobox('setText',""); 
					LoadWard(); 
				},
				onChange:function(newValue,oldValue){
					if (newValue==""){
						$("#WardDesc").combobox('setValue',"").combobox('setText',""); 
						LoadWard();
					}
				}
		 });
	});
}
function LoadWard(){
	var LocId=$("#CTLoc").combobox('getValue');
	var GridData=$.cm({
		ClassName:"web.DHCExamPatList",
		QueryName:"GetWardMessage",
		desc:"", luloc:LocId,
		HospID:session['LOGON.HOSPID'],
		rows:99999
	},false);
	var cbox = $HUI.combobox("#WardDesc", {
		valueField: 'HIDDEN', 
		textField: 'Ward', 
		editable:true,
		data: GridData["rows"],
		filter: function(q, row){
			return (row["Ward"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	 });
	 if ($.hisui.indexOfArray(GridData["rows"],"HIDDEN",session['LOGON.WARDID'])>=0){
		 $("#WardDesc").combobox('select',session['LOGON.WARDID']);
	 }
}
function initReCallPatListTab(){
	
	$('#recallPatListTab').datagrid({
        url: $URL,
        queryParams: {
            ClassName: "web.DHCDischargeHistory",
            QueryName: "QueryDichReCallQuery"
        },
        columns: [[
            { field: 'admLoc', title: '科室', width: 120 },
			{ field: 'admWard', title: '病区', width: 140 },
            { field: 'regNo', title: '登记号', width: 100 },
            { field: 'patName', title: '姓名', width: 100 },
            { field: 'telPhone', title: '联系电话', width: 120 },
            { field: 'recallTypeDesc', title: '召回类型', width: 80,
            	formatter: function(value,row,index){
	            	return $g(value);
            	}
            },
            { field: 'status', title: '状态', width: 60,
            	formatter: function(value,row,index){
	            	return $g(value);
            	}
            },
            { field: 'recallDate', title: '召回日期', width: 100 },
            { field: 'recallTime', title: '召回时间', width: 80 },
            { field: 'endDate', title: '结束日期', width: 100 },
            { field: 'endTime', title: '结束时间', width: 80 },
            { field: 'updateUser', title: '召回人', width: 120 }
        ]],
        idField: 'OeoriId',
        selectOnCheck:false, 
		checkOnSelect:false,
		singleSelect:true, 
		fit:true,
		border:false,
		onBeforeLoad:function(param){
			var finishStatus=$("#isFinish").combobox("getValues").join("^");
			if (finishStatus=="Y"){
				finishStatus="结束";
			}else if(finishStatus=="N"){
				finishStatus="未结束";
			}else{
				finishStatus="";
			}
			param = $.extend(param,{
				Startdate:$("#Startdate").datebox('getValue'),
				Enddate:$("#Enddate").datebox('getValue'),
				recallType:$("#recallType").combobox("getValues").join("^"),
				searchLocID:$("#CTLoc").combobox("getValue"),
				searchWardID:$("#WardDesc").combobox("getValue"),//||session['LOGON.WARDID']
				finishStatus:finishStatus,
				searchPatNo:$("#PatNo").val(),
				searchName:$("#Name").val(),
				HospDr:session['LOGON.HOSPID']
			});
		}
    });
}
function DocumentOnKeyDown(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("PatNo")>=0){
			var PatNo=$('#PatNo').val();
			if (PatNo=="") return;
			if (PatNo.length<10) {
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
			$('#PatNo').val(PatNo);
			FindPatDetail();
			return false;
		}
	}
}
function FindPatDetail(){
	var PatNo=$('#PatNo').val();
	if (PatNo!=""){
		var value=$.cm({
		    ClassName : "web.DHCExamPatList",
		    MethodName : "PatListBroker",
		    itmjs:"1", itmjsex:"", val:PatNo,
		    dataType:"text"
		},false);
		SetPatient_Sel(value);
	}
}
function SetPatient_Sel(value){
	if (value=="0"){
		return;
	}
	var Split_Value=value.split("^");
	$("#Name").val(unescape(Split_Value[0]));
	$('#recallPatListTab').datagrid("reload");
}
/*function myformatter(date){
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
}*/

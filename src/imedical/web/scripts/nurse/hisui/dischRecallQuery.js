$(function(){
	//ҳ��Ԫ�س�ʼ��
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
	//����
	LoadDept(); 
	//����
	LoadWard();
	$("#isFinish").combobox({
		valueField: 'id',
		textField: 'text',
		data:[{"id":"Y","text":$g("��")},{"id":"N","text":$g("��")}],
		multiple:true,
		rowStyle:'checkbox'
	})
	$("#recallType").combobox({
		valueField: 'id',
		textField: 'text',
		data:[{"id":"C","text":$g("ҽ���ٻ�")},{"id":"R","text":$g("��ʿ�ٻ�")}],
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
            { field: 'admLoc', title: '����', width: 120 },
			{ field: 'admWard', title: '����', width: 140 },
            { field: 'regNo', title: '�ǼǺ�', width: 100 },
            { field: 'patName', title: '����', width: 100 },
            { field: 'telPhone', title: '��ϵ�绰', width: 120 },
            { field: 'recallTypeDesc', title: '�ٻ�����', width: 80,
            	formatter: function(value,row,index){
	            	return $g(value);
            	}
            },
            { field: 'status', title: '״̬', width: 60,
            	formatter: function(value,row,index){
	            	return $g(value);
            	}
            },
            { field: 'recallDate', title: '�ٻ�����', width: 100 },
            { field: 'recallTime', title: '�ٻ�ʱ��', width: 80 },
            { field: 'endDate', title: '��������', width: 100 },
            { field: 'endTime', title: '����ʱ��', width: 80 },
            { field: 'updateUser', title: '�ٻ���', width: 120 }
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
				finishStatus="����";
			}else if(finishStatus=="N"){
				finishStatus="δ����";
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

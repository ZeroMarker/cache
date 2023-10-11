var PageLogicObj={
	m_DocDiagnosCertificateListGrid:""
}
$(function(){
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	$("#CardNo").focus();
});
function PageHandle(){
	$("#Startdate,#Enddate").datebox('setValue',ServerObj.NowDate);
	//科室
	LoadDept(); 
	//医生
	LoadDoc();
	LoadOrdListDataGrid();
}
function InitEvent(){
	$("#BFind").click(LoadOrdListDataGrid);
	$("#BReadCard").click(ReadCardClickHandle);
	$("#CardNo").change(CardNoChange);
	$("#PatNo").change(PatNoChange);
	document.onkeydown = DocumentOnKeyDown;
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
		if(SrcObj && SrcObj.id.indexOf("CardNo")>=0){
			var CardNo=$('#CardNo').val();
			if (CardNo=="") return;
			var myrtn=DHCACC_GetAccInfo("",CardNo,"","","CardNoKeyDownCallBack");
			return false;
		}
		if(SrcObj && SrcObj.id.indexOf("PatNo")>=0){
			var PatNo=$('#PatNo').val();
			if (PatNo=="") return;
			if (PatNo.length<10) {
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
			$("#CardTypeNew,#CardNo").val("");
			$('#PatNo').val(PatNo);
			FindPatDetail();
			return false;
		}
		return true;
	}
}
function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}
function CardNoKeyDownCallBack(myrtn){
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": 
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
    		$("#CardNo").val(CardNo);
    		$("#PatNo").val(PatientNo);
    		FindPatDetail();
			break;
		case "-200": 
			$.messager.alert("提示","卡无效!","info",function(){
				$("#CardTypeNew,#PatNo,#Name").val("");
				$("#CardNo").focus();
			});
			break;
		case "-201": 
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
    		$("#CardNo").val(CardNo);
    		$("#PatNo").val(PatientNo);
    		FindPatDetail();
			break;
		default:
			break;
	}
}
function CardNoChange(){
	var CardNo=$('#CardNo').val();
	if (CardNo==""){
		$("#PatientID,#CardTypeNew,#PatNo,#Name").val("");
	}
}
function PatNoChange(){
	var PatNo=$('#PatNo').val();
	if (PatNo==""){
		$("#CardNo,#PatientID,#CardTypeNew,#PatNo,#Name").val("");
	}
}
function FindPatDetail(){
	var PatNo=$('#PatNo').val();
	if (PatNo!=""){
		//如果是按患者查询则清空开始与截止日期
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
	$("#Birth").val(unescape(Split_Value[1]));
	$("#Sex").val(unescape(Split_Value[2]));
	$("#PatNo").val(unescape(Split_Value[3]));
	//PatListTabDataGridLoad();
}
function Init(){
	PageLogicObj.m_DocDiagnosCertificateListGrid=InitDocDiagnosCertificateListGrid();
}
function InitDocDiagnosCertificateListGrid(){
	var toobar=[{
        text: '打印',
        iconCls: 'icon-print',
        handler: function() {PrintClickHandle(); }
    }];
	// DDCRowId,DDCDiagnosIDStr,DiagnosDescStr,DDCDiagConfirmDate,DDCDaysOff,DDCDocNotes,DDCStatus,DDCStatusDesc
	var Columns=[[ 
		{ field: 'name', title:'',width:90,
			styler: function(value,row,index){
				if (value){
  					return 'background-color:#58C8B8;color:white;';
				}
			}
		},
		{field:'DiagnosDescStr',title:'诊断',width:200},
		{field:'DDCDiagConfirmDate',title:'确诊日期',width:90},
		{field:'DDCDaysOff',title:'建议休假天数',width:100},
		{field:'DDCDocNotes',title:'医生建议',width:300},
		{field:'DDCCompany',title:'单位',width:150,
		    editor :{
				type:'text'
			}
		},
		{field:'DDCNotes',title:'备注',width:300,
			editor :{  
				type:'text'
			}
		},
		{field:'DDCStatusDesc', title:'状态',width:60},
    ]]
	var DocDiagnosCertificateListGrid=$("#DocDiagnosCertificateList").treegrid({
		checkbox:true,
		idField:'index',
	    treeField:'name',
	    fit : true,
		fitColumns:true,
	    border: false,
		columns :Columns,
		toolbar:toobar,
		onLoadSuccess:function(rows,data){
			var columnLen=$('#DocDiagnosCertificateList').treegrid('options').columns[0].length;
			for (var i=0;i<data.length;i++){
				if (data[i].name) {
					var _$td=$($("#datagrid-row-r1-2-"+data[i].index+" td")[0]);
					_$td.attr("colSpan",columnLen).children("div").css({"width":"100%"});
					$("#datagrid-row-r1-2-"+data[i].index+" td:not(:eq(0))").hide();;
					$("#datagrid-row-r1-2-"+data[i].index+" .tree-title").css("font-size",'16px');
					var children=data[i].children;
					for (var j=0;j<children.length;j++){
						$('#DocDiagnosCertificateList').treegrid('beginEdit',children[j].index);
					}
				}
			}
		}
	}); 
	return DocDiagnosCertificateListGrid;
}
function LoadOrdListDataGrid()
{
	var SearchSttDate=$("#Startdate").datebox('getValue');
	var SearchEndDate=$("#Enddate").datebox('getValue');
	var PatNo=$("#PatNo").val();
	var AdmLocId=$("#CTLoc").combobox('getValue');
	var AdmDocId=$("#AdmDoc").combobox('getValue');
	$.cm({
	    ClassName : "web.DHCDocDiagnosCertificate",
	    MethodName : "GetDiagCertificatePrintDataJson",
	    PatNo:PatNo, 
	    SearchStartDate:SearchSttDate, SearchEndDate:SearchEndDate,
	    AdmLocId:AdmLocId,AdmDocId:AdmDocId
	},function(JsonData){
		$('#DocDiagnosCertificateList').treegrid('uncheckAll').treegrid('loadData',JsonData);
	})
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
function CardNoChange(){
	var CardNo=$('#CardNo').val();
	if (CardNo==""){
		$("#CardTypeNew").val("");
	}
}
function LoadDept(){
	$.cm({
		ClassName:"web.DHCExamPatList",
		QueryName:"ctloclookup",
	   	desc:"",hospid:session['LOGON.HOSPID'],
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#CTLoc", {
				valueField: 'ctlocid',
				textField: 'ctloc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["ctloc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onSelect: function(rec){  
					LoadDoc(); 
				},
				onChange:function(newValue,oldValue){
					if (newValue==""){
						LoadDoc();
					}
				}
		 });
	});
}
function LoadDoc(){
	$.cm({
		ClassName:"web.DHCExamPatList",
		QueryName:"FindDoc",
	   	LocId:$("#CTLoc").combobox('getValue'), DocDesc:"",
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#AdmDoc", {
				valueField: 'DocId',
				textField: 'DocDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["DocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}
function PrintClickHandle(){
	var HavePrinted=0;
	var DDCDataArr=[];
	var rows=$('#DocDiagnosCertificateList').treegrid('getCheckedNodes');
	for (var i=0;i<rows.length;i++){
		var DDCRowId=rows[i].DDCRowId;
		var DDCStatus=rows[i].DDCStatus;
		if (!DDCRowId) continue;
		if (DDCStatus =="P") {
			HavePrinted=1;
		}
		var edites=$('#DocDiagnosCertificateList').treegrid('getEditors',rows[i].index);
		rows[i].DDCCompany=edites[0].target.val();
		rows[i].DDCNotes=edites[1].target.val();
		DDCDataArr.push(rows[i]);
	}
	if (DDCDataArr.length==0){
		$.messager.alert("提示","请选择需要打印的记录 !");
		return;
	}
	if (HavePrinted ==1) {
		$.messager.confirm('确认对话框', "本次打印存在已打印的记录，继续打印将作废原打印记录，是否继续？", function(r){
			if (r){
				PrintCom();
			}
		});
	}else{
		PrintCom();
	}
	function PrintCom(){
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocDiagCertificate");
		var PrintDataJson=$.cm({
			ClassName:"web.DHCDocDiagnosCertificate",
			MethodName:"GetPrintDDCJson",
			DDCDataJson:JSON.stringify(DDCDataArr),
		   	ExpStr:session['LOGON.USERID']
		},false)
		for (var i=0;i<PrintDataJson.length;i++){
			var MyPara = "" + String.fromCharCode(2)
			for (Element in PrintDataJson[i]){
				MyPara=MyPara +"^"+ Element + String.fromCharCode(2) + PrintDataJson[i][Element];
			}
			DHC_PrintByLodop(getLodop(),MyPara,"","","");
		}
		LoadOrdListDataGrid();
	}
}
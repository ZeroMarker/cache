var PageLogicObj={
	m_IPBookQueryTabDataGrid:"",
	dw:$(window).width()-400,
	dh:$(window).height()-100,
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	$("#CardNo").focus();
})
function PageHandle(){
	$("#StDate,#EdDate").datebox('setValue',ServerObj.CurDate);
	//录入人
	LoadDocCreateBookId(); 
	//科室
	LoadDept(); 
	//病区
	LoadWard(0); 
	//状态
	LoadStatus();
	IPBookQueryTabDataGridLoad();
}
function Init(){
	PageLogicObj.m_IPBookQueryTabDataGrid=InitIPBookQueryTabDataGrid();
}
function InitEvent(){
	$("#BFind").click(IPBookQueryTabDataGridLoad);
	$("#BExport").click(ExportClickHandle);
	$("#BReadCard").click(ReadCardClickHandle);
	document.onkeydown = DocumentOnKeyDown;
}
function InitIPBookQueryTabDataGrid(){
	var Columns=[[ 
		{field:'RowID',title:'链接',width:40,align:'center',
			formatter: function(value,row,index){
				if (ServerObj.UDHCJFFlag=="Y"){  
					if ((row["CurrentState"]=="预约")||(row["CurrentState"]=="预住院")){
						//住院登记
						return '<a class="editcls" onclick="Register(\'' + row["RowID"] + '\' ,\''+row["RegNo"]+'\',\''+row["patNo"]+'\')">入</a>';
					}else{
						return '';
					}
				}else{
					return '<a class="editcls" onclick="Detail(\'' + row["RowID"] + '\')">详</a>';;
				}
			}
		},
		{field:'PatientID',hidden:true,title:''},
		{field:'EpisodeIDIP',hidden:true,title:''},
		{field:'RegNo',title:'登记号',width:100},
		{field:'PatientName',title:'姓名',width:80},
		{field:'Sex',title:'性别',width:50},
		{field:'Age',title:'年龄',width:80},
		{field:'TPAPMICardType',title:'证件类型',width:100},
		{field:'PersonalID',title:'证件号码',width:130},
		//{field:'Days',title:'预计住院天数',width:90},
		{field:'Diagnose',title:'门诊诊断',width:150},
		{field:'CurrentState',title:'当前状态',width:70,
			styler: function(value,row,index){
				var mode=$.cm({
					ClassName:"web.DHCBillInterface",
					MethodName:"IIsIPBook",
				    IPBook:row["RowID"],
					dataType:"text"
				},false);
				if (mode!=""){
					return 'background-color:#E0E0E0;';
				}
			}
		},
		{field:'OPDate',title:'门诊日期',width:100},
		{field:'IPDep',title:'住院科室',width:100},
		{field:'IPLoc',title:'病房',width:120},
		{field:'InputDoctor',title:'开证医生',width:80},
		{field:'Company',title:'工作单位',width:150},
		{field:'Address',title:'家庭住址',width:200},
		
		{field:'InputUser',title:'录入人',width:90},
		{field:'PriorityCondtion',title:'入院病情',width:80},
		{field:'TabWaitDate',title:'等候天数',width:70}
    ]]
	var IPBookQueryTabDataGrid=$("#IPBookQueryTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'RowID',
		columns :Columns,
		onDblClickRow:function(index, row){
			var mode = $.cm({
				ClassName:"web.DHCBillInterface",
				MethodName:"IIsIPBook",
			    IPBook:row["RowID"],
				dataType:"text"
			},false);
			if (mode!=""){
				if (mode=="IPBookErr"){
					$.messager.alert("提示","不是当天的住院证");
					return false;
				}
				if (mode=="Admission"){
					$.messager.alert("提示","病人正在住院");
					return false;
				}
				if (mode=="OnceAdmission"){
					$.messager.alert("提示","病人曾住院");
					return false;
				}
			}
			/*window.parent.returnValue=row["RowID"];
			window.parent.name="";
			window.parent.close()*/
		}
	});
	return IPBookQueryTabDataGrid;
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
		if(SrcObj && SrcObj.id.indexOf("RegNo")>=0){
			var PatientNo=$("#RegNo").val();
			if (PatientNo!='') {
				if (PatientNo.length<10) {
					for (var i=(10-PatientNo.length-1); i>=0; i--) {
						PatientNo="0"+PatientNo;
					}
				}
			}
			$("#RegNo").val(PatientNo);
			IPBookQueryTabDataGridLoad();
			return false;
		}else if(SrcObj && SrcObj.id.indexOf("CardNo")>=0){
			var CardNo=$('#CardNo').val();
			if (CardNo=="") return;
			var myrtn=DHCACC_GetAccInfo("",CardNo,"","","CardNoKeyDownCallBack");
			return false;
		}
		return true;
	}
}
function CardNoKeyDownCallBack(myrtn){
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": 
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$('#RegNo').val(PatientNo);
    		$("#CardNo").val(CardNo);
    		IPBookQueryTabDataGridLoad();
			break;
		case "-200": 
			$.messager.alert("提示","卡无效!","info",function(){
				$("#CardTypeNew").val("");
				$("#CardNo").focus();
			});
			break;
		case "-201": 
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$('#RegNo').val(PatientNo);
    		$("#CardNo").val(CardNo);
    		IPBookQueryTabDataGridLoad();
			break;
		default:
			break;
	}
}
function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}
function IPBookQueryTabDataGridLoad(){
	var FromDate=$("#StDate").datebox('getValue');
	var ToDate=$("#EdDate").datebox('getValue');
	var Regno=$("#RegNo").val();
	if (Regno!=""){
		if(ServerObj.UDHCJFFlag=="Y"){
			var FromDate="";
			var ToDate="";
		}else{
			var vaild = window.confirm("是否仅按照病人Id进行查询，不需要日期条件！");
			if(vaild){
				var FromDate="";
				var ToDate="";
			}
		}
	}
	$.cm({
	    ClassName : "web.DHCDocIPBookingCtl",
	    QueryName : "QueryBookByDateLoc",
	    FromDate:FromDate,
	    ToDate:ToDate,
	    CtLoc:$("#CtLoc").combobox('getValue'),
	    State:$("#State").combobox('getValue'),
	    RegNo:$("#RegNo").val(),
	    PacWardId:$("#PacWardId").combobox('getValue'),
	    DocCreateBookId:$("#DocCreateBookId").combobox('getValue'),
	    OrderOrCreateDate:$HUI.checkbox("#OrderOrCreateDate").getValue() ? 1 : 2,
	    Pagerows:PageLogicObj.m_IPBookQueryTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_IPBookQueryTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
}
function ExportClickHandle(){
	var logonUserID=session['LOGON.USERID']
	var gnum=$.cm({
	    ClassName : "web.DHCDocIPBookingCtl",
	    MethodName : "getnum",
	    logonUserID:logonUserID,
	    dataType:"text"
	},false)
	if((gnum=="")||(gnum=="0")){
		return false	
	}
	var Template,xlApp,xlsheet,xlBook
	var path =$.cm({
	    ClassName : "web.DHCDocIPBookingCtl",
	    MethodName : "getpath",
	    dataType:"text"
	},false)
	Template=path+"DHCDocIPBookingCtl.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
	xlsheet.cells(1,1)="登记号"
	xlsheet.cells(1,2)="病人姓名"
	xlsheet.cells(1,3)="性别"
	xlsheet.cells(1,4)="年龄"
	xlsheet.cells(1,5)="证件类型"
	xlsheet.cells(1,6)="证件号码"
	xlsheet.cells(1,7)="工作单位"
	xlsheet.cells(1,8)="家庭住址"
	xlsheet.cells(1,9)="门诊日期"
	xlsheet.cells(1,10)="住院科室"
	xlsheet.cells(1,11)="病房"
	xlsheet.cells(1,12)="医师"
	xlsheet.cells(1,13)="预计住院天数"
	xlsheet.cells(1,14)="门诊诊断"
	xlsheet.cells(1,15)="当前状态"
	xlsheet.cells(1,16)="录入人"
	xlsheet.cells(1,17)="入院病情"
	for (var i=1;i<=gnum;i++){
		var str =$.cm({
		    ClassName : "web.DHCDocIPBookingCtl",
		    MethodName : "getdata",
		    itmjs:"", logonUserID:logonUserID, num:i,
		    dataType:"text"
		},false)
		myData=str.split("^")    
		xlsheet.cells(i+1,1)=myData[0]
		xlsheet.cells(i+1,2)=myData[1]
		xlsheet.cells(i+1,3)=myData[2]
		xlsheet.cells(i+1,4)=myData[3]
		xlsheet.cells(i+1,5)=myData[15]
		xlsheet.cells(i+1,6)=myData[4]
		xlsheet.cells(i+1,7)=myData[5]
		xlsheet.cells(i+1,8)=myData[6]
		xlsheet.cells(i+1,9)=myData[7]
		xlsheet.cells(i+1,10)=myData[8]
		xlsheet.cells(i+1,11)=myData[9]
		xlsheet.cells(i+1,12)=myData[10]
		xlsheet.cells(i+1,13)=myData[11]
		xlsheet.cells(i+1,14)=myData[12]
		xlsheet.cells(i+1,15)=myData[13]
		xlsheet.cells(i+1,16)=myData[14]
		xlsheet.cells(i+1,17)=myData[16]
	}
	xlApp.Visible=true
	xlBook.Close (savechanges=true);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null
}
function LoadDocCreateBookId(){
	var GridData=$.cm({
		ClassName:"web.UDHCJFIPReg",
		QueryName:"GetDocCreateBookInfo",
	    DocCreateBook:"",
		rows:99999
	},false);
	var cbox = $HUI.combobox("#DocCreateBookId", {
			valueField: 'DocNo',
			textField: 'DocDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["DocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["SSUSRInitials"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onLoadSuccess:function(){
				var Rtn=$.cm({
					ClassName:"web.DHCDocIPBookingCtl",
					MethodName:"IsMZLoc",
				    CTLOCID:session['LOGON.CTLOCID'],
				    dataType:"text"
				},false)
				if (Rtn=="Y"){
					$("#DocCreateBookId").combobox('select',session['LOGON.USERID'])
				}
			}
	 });
}
function LoadDept(){
	$.cm({
		ClassName:"web.UDHCJFIPReg",
		QueryName:"admdeplookup",
	    desc:"", UserDepID:"",
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#CtLoc", {
				valueField: 'depid',
				textField: 'dep', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["dep"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["ctContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onSelect: function(rec){  
					LoadWard(1);  
				},
				onChange:function(newValue,oldValue){
					if (newValue==""){
						LoadWard(0);
					}
				}
		 });
	});
}
function LoadWard(type){
	var admdepid=$("#CtLoc").combobox('getValue');
	//if (admdepid=="") admdepid=session['LOGON.CTLOCID']; 
	var GridData=$.cm({
		ClassName:"web.DHCDocIPBookingCtl",
		QueryName:"admwardlookup",
	    admdepid:admdepid, desc:"",
		rows:99999
	},false);
	var cbox = $HUI.combobox("#PacWardId", {
			valueField: 'wardid',
			textField: 'ward', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["ward"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["ctContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onLoadSuccess:function(){
				if (type=="0"){
					$.cm({
						ClassName:"web.PACWard",
						MethodName:"GetWardFromLoc",
					    CTLOCID:session['LOGON.CTLOCID'],
					    dataType:"text"
					},function(wardid){
						if (wardid==""){
							$("#PacWardId").combobox('select',wardid);
						}
					})
				}
			}
	 });
}
function LoadStatus(){
	$.cm({
		ClassName:"web.DHCDocIPBDictionaryCtl",
		MethodName:"QueryByType",
	    Type:"IPBookingState", Flag:"Y", stateFlag:"",
		dataType:"text"
	},function(Str){
		var Arr=new Array();
		for (var i=0;i<Str.split(String.fromCharCode(1)).length;i++){
			var id=Str.split(String.fromCharCode(1))[i].split("^")[0];
			if (id=="") continue;
			var text=Str.split(String.fromCharCode(1))[i].split("^")[2];
			Arr.push({"id":id,"text":text});
		}
		var cbox = $HUI.combobox("#State", {
				valueField: 'id',
				textField: 'text', 
				editable:true,
				data: Arr
		 });
	})
}
function Register(RowID,regNo,CardNo){
	var src="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFIPReg&Regno="+regNo+"&IPBook="+RowID+"&opcardno="+CardNo;
	var $code ="<iframe width='99%' height='99%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("ChgAdmReason","入院登记", PageLogicObj.dw+150, PageLogicObj.dh+50,"icon-write-order","",$code,"")
}
function Detail(BookID){
	var src="doc.ipbookcreate.hui.csp?BookID="+BookID; // dhcdocipbooknewcreat.csp
	var $code ="<iframe width='100%' height='99%' scrolling='yes' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("ChgAdmReason","住院证详情", 1100, 610,"icon-write-order","",$code,"")
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
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
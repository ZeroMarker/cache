var PageLogicObj={
	m_IPBookQueryTabDataGrid:"",
	m_OrdLocBox: "",
	dw:$(window).width()-400,
	dh:$(window).height()-100,
	onlySearchByPatId:0,
	FromDate:"",
	ToDate:""
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
	$("#RegNo").val(ServerObj.PAPMINO);
	if ((ServerObj.CanChange=="N")&&(ServerObj.UDHCJFFlag=="Y")){
		$("#RegNo").attr("disabled",true); 
	}
	$("#StDate,#EdDate").datebox('setValue',ServerObj.CurDate);
	//录入人
	LoadDocCreateBookId(""); 
	//科室
	LoadDept(); 
	//开单科室
	LoadOrdLoc();
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
					if (row['IsCanAdmission']=="1"){
						//住院登记
						return '<a class="editcls" onclick="Register(\'' + row["RowID"] + '\' ,\''+row["RegNo"]+'\',\''+row["patNo"]+'\')">入</a>';
					}
					/*if ((row["CurrentState"]=="预约")||(row["CurrentState"]=="申请")||(row["CurrentState"]=="预住院")){
						//住院登记
						return '<a class="editcls" onclick="Register(\'' + row["RowID"] + '\' ,\''+row["RegNo"]+'\',\''+row["patNo"]+'\')">入</a>';
					}*/else{
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
		{field:'CurrentState',title:'当前状态',width:70/*,
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
			}*/
		},
		{field:'PatientLevel',title:'患者等级',width:100},
		{field:'OPDate',title:'门诊日期',width:100},
		{field:'IPDep',title:'预住院科室',width:100},
		{field:'ConIPDep',title:'实际住院科室',width:100},
		{field:'IPLoc',title:'病房',width:120},
		{field:'InputDoctor',title:'开证医生',width:80,hidden:true},
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
		onLoadSuccess:function(data){
			var BookStatusCountObj = $.cm({
				ClassName:"web.DHCDocIPBookingCtl",
				MethodName:"GetBookStatusCount",
			    logonUserID:session['LOGON.USERID']
			},false);
			var SumStr="";
			for ( var status in BookStatusCountObj[0]) {
				if (SumStr==""){
					SumStr=status+": "+BookStatusCountObj[0][status];
				}else{
					SumStr=SumStr+","+status+": "+BookStatusCountObj[0][status];
				}
			}
			if (SumStr!="") var SumStr=$g("总计:  ")+SumStr
			$("#SumallStatus").html(SumStr)
		},
		onDblClickRow:function(index, row){
			if (ServerObj.UDHCJFFlag=="Y"){
				//if (window.parent.name=="") return false;
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
				websys_showModal("options").callbackFunc(row["RowID"]);
				websys_showModal("close");
				/*
				window.parent.returnValue=row["RowID"];
				window.parent.name="";
				window.parent.close();
				*/
			}
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
		}else if(SrcObj && SrcObj.id.indexOf("IDCardNo")>=0){
			IPBookQueryTabDataGridLoad();
			return false;
		}else if(SrcObj && SrcObj.id.indexOf("CardNo")>=0){
			var CardNo=$('#CardNo').val();
			if (CardNo=="") return;
			var myrtn=DHCACC_GetAccInfo("",CardNo,"","","CardNoKeyDownCallBack");
			return false;
		}else if(SrcObj && SrcObj.id.indexOf("PatName")>=0){
			IPBookQueryTabDataGridLoad();
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
function ReadCardClickHandle(PrintFlag){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}
function IPBookQueryTabDataGridLoad(){
	PageLogicObj.onlySearchByPatId=0;
	PageLogicObj.FromDate=$("#StDate").datebox('getValue');
	PageLogicObj.ToDate=$("#EdDate").datebox('getValue');
	var Regno=$("#RegNo").val();
	if (Regno!=""){
		if(ServerObj.UDHCJFFlag=="Y"){
			PageLogicObj.FromDate="";
			PageLogicObj.ToDate="";
			LoadData();
		}else{
			$.messager.confirm("确认对话框", "是否仅按照患者ID进行查询,不需要日期条件!", function (r) {
				if (r) {
					PageLogicObj.FromDate="";
					PageLogicObj.ToDate="";
					PageLogicObj.onlySearchByPatId=1;
				}
				LoadData();
			});
		}
	}else{
		LoadData();
	}
}
function LoadData(){
	
		var GridData=$.cm({
		    ClassName : "web.DHCDocIPBookingCtl",
		    QueryName : "QueryBookByDateLoc",
		    FromDate:PageLogicObj.FromDate,
		    ToDate:PageLogicObj.ToDate,
		    CtLoc:$("#CtLoc").combobox('getValue'),
		    State:$("#State").combobox('getValue'),
		    RegNo:$("#RegNo").val(),
		    PacWardId:$("#PacWardId").combobox('getValue'),
		    DocCreateBookId:$("#DocCreateBookId").combobox('getValue'),
		    OrderOrCreateDate:$HUI.checkbox("#OrderOrCreateDate").getValue() ? 1 : 2,
		    OrdLoc:PageLogicObj.m_OrdLocBox.getValue(),
		    PatName:$("#PatName").val(),
		    IDCardNo:$("#IDCardNo").val(),
		    Pagerows:PageLogicObj.m_IPBookQueryTabDataGrid.datagrid("options").pageSize,rows:99999
		},function(GridData){
			PageLogicObj.m_IPBookQueryTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		});
	}
function ExportClickHandle(){
	var Data=PageLogicObj.m_IPBookQueryTabDataGrid.datagrid("getRows");
	if (Data.length==0){
		$.messager.alert("提示","请查询出数据后导出!");
		return false;
	}
	var FromDate=$("#StDate").datebox('getValue');
	var ToDate=$("#EdDate").datebox('getValue');
	var Regno=$("#RegNo").val();
	if (Regno!=""){
		if(ServerObj.UDHCJFFlag=="Y"){
			FromDate="";
			ToDate="";
		}else{
			if (PageLogicObj.onlySearchByPatId==1){
				FromDate="";
				ToDate="";
			}
		}
	}
	var rtn = $cm({
		localDir:"Self",
	    ResultSetType:"ExcelPlugin",
		ExcelName:'住院证查找单',
		ClassName : "web.DHCDocIPBookingCtl",
	    QueryName : "QueryBookByDateLocExport",
	    FromDate:FromDate,
	    ToDate:ToDate,
	    CtLoc:$("#CtLoc").combobox('getValue'),
	    State:$("#State").combobox('getValue'),
	    RegNo:$("#RegNo").val(),
	    PacWardId:$("#PacWardId").combobox('getValue'),
	    DocCreateBookId:$("#DocCreateBookId").combobox('getValue'),
	    OrderOrCreateDate:$HUI.checkbox("#OrderOrCreateDate").getValue() ? 1 : 2,
	    OrdLoc:PageLogicObj.m_OrdLocBox.getValue()
	}, false);
}
function LoadDocCreateBookId(DepID){
	var GridData=$.cm({
		ClassName:"web.DHCDocIPBookingCtl",
		QueryName:"GetDocCreateBookInfo",
	    DocCreateBook:"",
	    txtAdmDepID:DepID,
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
					row=GridData["rows"]
					for (var i=0;i<GridData["rows"].length;i++){
						if (GridData["rows"][i].DocNo.toUpperCase().indexOf(session['LOGON.USERID'].toUpperCase()) >= 0){
							$("#DocCreateBookId").combobox('select',session['LOGON.USERID'])
						}
					}
				}
			}
	 });
}
function LoadOrdLoc () {
	PageLogicObj.m_OrdLocBox = $HUI.combobox("#OrdLoc", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=GetLocByType&TypeList=O^E&ResultSetType=array",
		valueField:'rowid',
		textField:'Desc',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.ContactName) {
				mCode = row.ContactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		},
		onSelect: function(rec){  
					LoadDocCreateBookId(rec.rowid);  
				},
	});
}
function LoadDept(){
	$.cm({
		ClassName:"web.DHCDocIPBookingCtl",
		QueryName:"admdeplookup",
	    desc:"", UserDepID:session['LOGON.CTLOCID'],
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

function Register(RowID,regNo,CardNo) {
	var url = "dhcbill.ipbill.reg.csp?PatientNo=" + regNo + "&IPBookID=" + RowID + "&CardNo=" + CardNo;
	websys_showModal({
		url: url,
		title: "入院登记",
		iconCls: "icon-w-paper",
		height: '95%',
		width: '98%',
		onClose:function(title,index){
			LoadData();
		}
	});
}

function Detail(BookID){
	var src="doc.ipbookcreate.hui.csp?BookID="+BookID; // dhcdocipbooknewcreat.csp
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	websys_showModal({
		url: src,
		title: "住院证详情",
		iconCls: "icon-w-paper",
		height: 716,
		width: 1280,
		onClose:function(title,index){
			LoadData();
		}
	});
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
	        setTimeout(function(){destroyDialog(id);});
	    }
    });
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}

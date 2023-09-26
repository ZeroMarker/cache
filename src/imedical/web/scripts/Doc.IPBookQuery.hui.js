var PageLogicObj={
	m_IPBookQueryTabDataGrid:"",
	m_OrdLocBox: "",
	dw:$(window).width()-400,
	dh:$(window).height()-100,
}
$(function(){
	//��ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	$("#CardNo").focus();
})
function PageHandle(){
	$("#RegNo").val(ServerObj.PAPMINO);
	if ((ServerObj.CanChange=="N")&&(ServerObj.UDHCJFFlag=="Y")){
		$("#RegNo").attr("disabled",true); 
	}
	$("#StDate,#EdDate").datebox('setValue',ServerObj.CurDate);
	//¼����
	LoadDocCreateBookId(); 
	//����
	LoadDept(); 
	//��������
	LoadOrdLoc();
	//����
	LoadWard(0); 
	//״̬
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
		{field:'RowID',title:'����',width:40,align:'center',
			formatter: function(value,row,index){
				if (ServerObj.UDHCJFFlag=="Y"){  
					if (row['IsCanAdmission']=="1"){
						//סԺ�Ǽ�
						return '<a class="editcls" onclick="Register(\'' + row["RowID"] + '\' ,\''+row["RegNo"]+'\',\''+row["patNo"]+'\')">��</a>';
					}
					/*if ((row["CurrentState"]=="ԤԼ")||(row["CurrentState"]=="����")||(row["CurrentState"]=="ԤסԺ")){
						//סԺ�Ǽ�
						return '<a class="editcls" onclick="Register(\'' + row["RowID"] + '\' ,\''+row["RegNo"]+'\',\''+row["patNo"]+'\')">��</a>';
					}*/else{
						return '';
					}
				}else{
					return '<a class="editcls" onclick="Detail(\'' + row["RowID"] + '\')">��</a>';;
				}
			}
		},
		{field:'PatientID',hidden:true,title:''},
		{field:'EpisodeIDIP',hidden:true,title:''},
		{field:'RegNo',title:'�ǼǺ�',width:100},
		{field:'PatientName',title:'����',width:80},
		{field:'Sex',title:'�Ա�',width:50},
		{field:'Age',title:'����',width:80},
		{field:'TPAPMICardType',title:'֤������',width:100},
		{field:'PersonalID',title:'֤������',width:130},
		//{field:'Days',title:'Ԥ��סԺ����',width:90},
		{field:'Diagnose',title:'�������',width:150},
		{field:'CurrentState',title:'��ǰ״̬',width:70/*,
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
		{field:'OPDate',title:'��������',width:100},
		{field:'IPDep',title:'ԤסԺ����',width:100},
		{field:'ConIPDep',title:'ʵ��סԺ����',width:100},
		{field:'IPLoc',title:'����',width:120},
		{field:'InputDoctor',title:'��֤ҽ��',width:80},
		{field:'Company',title:'������λ',width:150},
		{field:'Address',title:'��ͥסַ',width:200},
		
		{field:'InputUser',title:'¼����',width:90},
		{field:'PriorityCondtion',title:'��Ժ����',width:80},
		{field:'TabWaitDate',title:'�Ⱥ�����',width:70}
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
			if (SumStr!="") var SumStr="�ܼ�:  "+SumStr
			$("#SumallStatus").html(SumStr)
		},
		onDblClickRow:function(index, row){
			if (ServerObj.UDHCJFFlag=="Y"){
				if (window.parent.name=="") return false;
				var mode = $.cm({
					ClassName:"web.DHCBillInterface",
					MethodName:"IIsIPBook",
				    IPBook:row["RowID"],
					dataType:"text"
				},false);
				if (mode!=""){
					if (mode=="IPBookErr"){
						$.messager.alert("��ʾ","���ǵ����סԺ֤");
						return false;
					}
					if (mode=="Admission"){
						$.messager.alert("��ʾ","��������סԺ");
						return false;
					}
					if (mode=="OnceAdmission"){
						$.messager.alert("��ʾ","������סԺ");
						return false;
					}
				}
				websys_showModal("options").originWindow.getRegInfoByIPBook(row["RowID"]);
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
			$.messager.alert("��ʾ","����Ч!","info",function(){
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
	var FromDate=$("#StDate").datebox('getValue');
	var ToDate=$("#EdDate").datebox('getValue');
	var Regno=$("#RegNo").val();
	if (Regno!=""){
		if(ServerObj.UDHCJFFlag=="Y"){
			var FromDate="";
			var ToDate="";
		}else{
			$.messager.confirm("ȷ�϶Ի���", "�Ƿ�����ջ���ID���в�ѯ,����Ҫ��������!", function (r) {
				if (r) {
					var FromDate="";
					var ToDate="";
				}
				LoadData();
				return;
			});
		}
	}
	LoadData();
	function LoadData(){
		var GridData=$.cm({
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
		    OrdLoc:PageLogicObj.m_OrdLocBox.getValue(),
		    Pagerows:PageLogicObj.m_IPBookQueryTabDataGrid.datagrid("options").pageSize,rows:99999
		},function(GridData){
			PageLogicObj.m_IPBookQueryTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		});
	}
}
function GetPrintDetailData(){
	var PrintFlag="Y";
	return IPBookQueryTabDataGridLoad(PrintFlag);
}
function ExportClickHandle(){
	var FromDate=$("#StDate").datebox('getValue');
	var ToDate=$("#EdDate").datebox('getValue');
	var Regno=$("#RegNo").val();
	if (Regno!=""){
		if(ServerObj.UDHCJFFlag=="Y"){
			var FromDate="";
			var ToDate="";
		}else{
			var vaild = window.confirm("�Ƿ�����ղ���Id���в�ѯ������Ҫ����������");
			if(vaild){
				var FromDate="";
				var ToDate="";
			}
		}
	}
	var rtn = $cm({
		localDir:"Self",
	    ResultSetType:"ExcelPlugin",
		ExcelName:'סԺ֤���ҵ�',
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
	/*var logonUserID=session['LOGON.USERID']
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
	xlsheet.cells(1,1)="�ǼǺ�"
	xlsheet.cells(1,2)="��������"
	xlsheet.cells(1,3)="�Ա�"
	xlsheet.cells(1,4)="����"
	xlsheet.cells(1,5)="֤������"
	xlsheet.cells(1,6)="֤������"
	xlsheet.cells(1,7)="������λ"
	xlsheet.cells(1,8)="��ͥסַ"
	xlsheet.cells(1,9)="��������"
	xlsheet.cells(1,10)="סԺ����"
	xlsheet.cells(1,11)="����"
	xlsheet.cells(1,12)="ҽʦ"
	//xlsheet.cells(1,13)="Ԥ��סԺ����"
	xlsheet.cells(1,13)="�������"
	xlsheet.cells(1,14)="��ǰ״̬"
	xlsheet.cells(1,15)="¼����"
	xlsheet.cells(1,16)="��Ժ����"
	xlsheet.cells(1,17)="�Ⱥ�����"
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
		//xlsheet.cells(i+1,13)=myData[11]
		xlsheet.cells(i+1,13)=myData[12]
		xlsheet.cells(i+1,14)=myData[13]
		xlsheet.cells(i+1,15)=myData[14]
		xlsheet.cells(i+1,16)=myData[16]
		xlsheet.cells(i+1,17)=myData[17]
	}
	xlApp.Visible=true
	var fname = xlApp.Application.GetSaveAsFilename("סԺ֤�б�.xls", "Excel Spreadsheets (*.xls), *.xls");
    xlBook.SaveAs(fname);
	//xlBook.Close (savechanges=true);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null*/
}
function LoadDocCreateBookId(){
	var GridData=$.cm({
		ClassName:"web.DHCDocIPBookingCtl",
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
		}
	});
}
function LoadDept(){
	$.cm({
		ClassName:"web.UDHCJFIPReg",
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
		title: "��Ժ�Ǽ�",
		iconCls: "icon-write-order",
		height: '95%',
		width: '98%',
		onClose:function(title,index){
			IPBookQueryTabDataGridLoad();
		}
	});
}

function Detail(BookID){
	var src="doc.ipbookcreate.hui.csp?BookID="+BookID; // dhcdocipbooknewcreat.csp
	websys_showModal({
		url: src,
		title: "סԺ֤����",
		iconCls: "icon-w-paper",
		height: 570,
		width: 1260,
		onClose:function(title,index){
			IPBookQueryTabDataGridLoad();
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
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
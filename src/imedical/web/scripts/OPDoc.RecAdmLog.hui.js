var PageLogicObj={
	m_OPDocLogTabDataGrid:"",
	NotShowColTitleStr:"^����^֤����^֤������^��Ⱦ��^ICD^��ַ^�ǼǺ�^�ѱ�^��������^������^����^������^��������^ҽ������^����ʱ��(ҽ��)^ְҵ^" 
	//�������ߴ�ӡ ͨ��indexOf�жϲ���Ҫ��ʾ���� title��^�ָ�
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
	$("#OpDate,#OpDate2").datebox('setValue',ServerObj.NowDate);
	//��ѯ����
	LoadSearchConditions(); 
	//����
	LoadDept(); 
	//״̬����
	LoadSerCon();
	//���
	IntMRDiagnos();
	//OPDocLogTabDataGridLoad();
}
function Init(){
	PageLogicObj.m_OPDocLogTabDataGrid=InitOPDocLogTabDataGrid();
}
function InitEvent(){
	$("#BFind").click(OPDocLogTabDataGridLoad);
	$("#BReadCard").click(ReadCardClickHandle);
	$("#BPrint").click(function(){
		ExportPrintCommon("Print");
	}); //PrintClickHandle
	$("#BExport").click(function(){
		ExportPrintCommon("Export");
	}); //ExportClickHandle
	$("#BAmount").click(AmountClickHandle);
	$("#CardNo").change(CardNoChange);
	document.onkeydown = DocumentOnKeyDown;
}
function InitOPDocLogTabDataGrid(){
	var Columns=[[ 
		{field:'xuhao',title:'���',width:40,align:'center'},
		{field:"patOperBtn", title:'����', width:90, align:'center',
			formatter: function(value, row, index) {
				var operDiv = '<div id="patOperBtn_'  + index + '" style="width:100%;height:100%"></div>'
				return operDiv
			}
		},
		{field:'paadmrowid',hidden:true,title:''},
		{field:'PatientID',hidden:true,title:''},
		{field:'papmiCardNo',title:'�ǼǺ�',width:100,
			formatter:function(value,row,index){
	    		var btn = '<a style="text-decoration: underline;color:#339eff" onclick="OpenOrderView(\''+row.paadmrowid +'\')">'+value+'\</a>';
	    		return btn;
	    	}
		},
		{field:'papminame',title:'����',width:110},
		{field:'papmigender',title:'�Ա�',width:50},
		{field:'papmiage',title:'����',width:50},
		{field:'AdmReason',title:'�ѱ�',width:80},
		{field:'TPAPMICardType',title:'֤������',width:130},
		{field:'papmicredno',title:'֤����',width:150},
		{field:'papmiwork',title:'��ַ',width:150},
		{field:'papmidiagnose',title:'�������',width:150},
		{field:'ctdesc',title:'ҽ��',width:100},
		{field:'admdate',title:'��������',width:100},
		{field:'InfectFlag',title:'�Ƿ񱨿�',width:80},
		{field:'PAPERTelH',title:'��ϵ�绰',width:100},
        {field:'admfir',title:'����',width:50,align:'center'
        },
       	{field:'admre',title:'����',width:50,align:'center'
        },
        {field:'IliFlag',title:'������',width:60,align:'center',
			formatter: function(value,row,index){
	        	if (value=="on"){value=$g("��")}else{value=$g("��")}
				return value;
			}
        },
		/*//������������ �༭ģʽ
		{field:'admfir',title:'����',formatter: function(value,row,index){  
                var checked=(value=="1")?"checked":"";  
                return "<input type='checkbox' disabled "+checked+">";  
            }  
        },  
        {field:'admre',title:'����',formatter: function(value,row,index){  
                var checked=(value=="1")?"checked":"";  
                return "<input type='checkbox' disabled "+checked+">";  
            }},  
        {field:'IliFlag',title:'������',formatter: function(value,row,index){  
                var checked=(value=="1")?"checked":"";  
                return "<input type='checkbox' disabled "+checked+">";  
            }  
        }, */
		{field:'InfectionStr',title:'��Ⱦ��',width:80},
		{field:'CTLOCDesc',title:'����',width:120},
		{field:'CTOCCDesc',title:'ְҵ',width:100},
		{field:'jz',title:'����',width:50},
		{field:'Mdeicare',title:'������',width:80},
		{field:'time',title:'����ʱ��(ҽ��)',width:120},
		{field:'PAADMTriageDat',title:'��������',width:130},
		{field:'CTPCPId',title:'ҽ������',width:100},
		{field:'MRDIAICDCodeDR',title:'ICD',width:150}
    ]]
	var OPDocLogTabDataGrid=$("#OPDocLogTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		//pageSize: 20,
		//pageList : [20,100,200],
		idField:'paadmrowid',
		columns :Columns,
		onSelect:function(index, row){
			var menuWin=websys_getMenuWin();
			if ((menuWin) &&(menuWin.MainClearEpisodeDetails)) menuWin.MainClearEpisodeDetails();
			var frm=dhcsys_getmenuform();
			if (frm){
				frm.PatientID.value=row["PatientID"];
				frm.EpisodeID.value=row["paadmrowid"];
			}
		},
		onBeforeSelect:function(index, row){
			var oldSelRow=$(this).datagrid('getSelected');
			var oldSelIndex=$(this).datagrid('getRowIndex',oldSelRow);
			if (oldSelIndex==index){
				$(this).datagrid('unselectRow',index);
				var frm=dhcsys_getmenuform();
				if (frm){
					frm.PPRowId.value="";
					frm.EpisodeID.value="";
				}
				return false;
			}
		},
		onResizeColumn: function(field, width) {
			// �п�ı䣬��ť����֮�仯
			if (field == "patOperBtn") {
				$(this).datagrid('getPanel').find('td[field="patOperBtn"]').find('.shortcutbar-list-x').panel('resize')
			}
		},
		onLoadSuccess: function(data) {
			// �����и�̫С
			$(this).datagrid('getPanel').find('div.datagrid-body tr').find('td[field="patOperBtn"]').children("div").css({   
				"height": "40px" 
			})
			// ������Ÿ߶�
			$(this).datagrid('getPanel').find('.datagrid-td-rownumber').css({   
				"height": "40px"
			})
			if (data.total > 0) {
				data.rows.forEach(function(value, index, array) {
					$('#patOperBtn_' + index).marybtnbar({
						barCls: 'background:none;padding:5px 0px;',
						queryParams: {ClassName:'DHCDoc.OPDoc.MainFrame',QueryName:'QueryBtnCfg',url:'opdoc.recadmlog.hui.csp'},
						onBeforeLoad: function(param){
							param.EpisodeID=value.paadmrowid;
						},
						onClick: function(jq,cfg){
							jq.tooltip('hide');
							$("#OPDocLogTab").datagrid("unselectAll")
							$("#OPDocLogTab").datagrid("selectRow", index)
							jumpMenu(cfg)
						}
					})
				});
			}
		}
	});
	return OPDocLogTabDataGrid;
}
function OPDocLogTabDataGridLoad(PrintFlag){
	var OpDate=$("#OpDate").datebox('getValue');
	var OpDate2=$("#OpDate2").datebox('getValue');
	if ((OpDate=="")||(OpDate2=="")){
		$.messager.alert("��ʾ","���ڲ���Ϊ��!");
		return false;
	}
	var Gsearchmessage=$('#Gsearchmessage').val();
	var SearchConditions=$('#SearchConditions').combobox('getValue');
	if ((SearchConditions==2)&&(Gsearchmessage!="")){
		if (Gsearchmessage.length<10) {
			for (var i=(10-Gsearchmessage.length-1); i>=0; i--) {
				Gsearchmessage="0"+Gsearchmessage;
			}
		}
		$('#Gsearchmessage').val(Gsearchmessage);
	}
	var GridData=$.cm({
	    ClassName : "web.DHCOPDOCLog",
	    QueryName : "DHCOPLocLog",
	    Gsearchmessage:$("#Gsearchmessage").val(),
	    SearchConditions:$("#SearchConditions").combobox('getValue'),
	    SPatientAge:$("#SPatientAge").val(),
	    EPatientAge:$("#EPatientAge").val(),
	    FindByDoc:$("#FindDoc").combobox('getValue'),
	    RLocID:$("#LocQuery").combobox('getValue'),
	    SerCon:$("#SerCon").combobox('getText'), //session['LOGON.CTLOCID'],
	    DocNo1:session['LOGON.USERCODE'],
	    OpDate:OpDate,
	    OpDate2:OpDate2,
	    SearhLoc:$HUI.checkbox("#SearhLoc").getValue() ? "on" : "", //��ѯ����
	    MRDiagnos:$("#MRDiagnos").lookup('getText'),
	    MRDIAICDCodeID:"",
	    Time:$("#Time").timespinner('getValue'),
	    Time2:$("#Time2").timespinner('getValue'),
	    PatientID:$("#PatientID").val(),
	    Pagerows:1, //PageLogicObj.m_OPDocLogTabDataGrid.datagrid("options").pageSize,
	    rows:99999
	},false);
	if (PrintFlag=="Y") {
		return GridData.rows;
	}else{
		PageLogicObj.m_OPDocLogTabDataGrid.datagrid('loadData',GridData);
	}
}
function LoadSearchConditions(){
	var cbox = $HUI.combobox("#SearchConditions", {
			valueField: 'id',
			textField: 'text', 
			editable:true,
			data: [{"id":"1","text":$g("��������")},{"id":"2","text":$g("�ǼǺ�")},{"id":"3","text":$g("������")}]
	 });
}
function LoadDept(){
	$.cm({
		ClassName:"web.DHCOPReg",
		QueryName:"OPLoclookup",
	   	desc:"", hospid:session['LOGON.HOSPID'],
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#LocQuery", {
				valueField: 'rowid',
				textField: 'OPLocdesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["OPLocdesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
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
		ClassName:"web.DHCUserGroup",
		QueryName:"FindLogonLocDocNew",
	   	LogLoc:$("#LocQuery").combobox('getValue'), Desc:"",
		rows:99999  
	},function(GridData){
		var cbox = $HUI.combobox("#FindDoc", {
				valueField: 'CTPCPDr',
				textField: 'CTPCPDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CTPCPDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}
function LoadSerCon(){
	$.cm({
		ClassName:"web.DHCOPDOCLog",
		QueryName:"FindInfo",
		rows:99999  
	},function(GridData){
		var cbox = $HUI.combobox("#SerCon", {
				valueField: 'NO',
				textField: 'state', 
				editable:true,
				data: GridData["rows"]
		 });
	});
}
function IntMRDiagnos(){
	$("#MRDiagnos").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'desc',
        columns:[[  
            {field:'desc',title:'�������',width:300,sortable:true},
			{field:'code',title:'code',width:150,sortable:true},
			{field:'HIDDEN',title:'HIDDEN',width:120,sortable:true,hidden:true}
        ]], 
        pagination:true,
        panelWidth:500,
	fitColumns:true,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true, //web.DHCMRDiagnos  LookUpWithAlias  MRDiagnos,depid,'1','','All'
        queryParams:{ClassName: 'web.DHCMRDiagnos',QueryName: 'LookUpWithAlias'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
			param = $.extend(param,{desc:desc,loc:session['LOGON.CTLOCID'],ver1:1,ICDType:"All"});
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
		if(SrcObj && SrcObj.id.indexOf("CardNo")>=0){
			var CardNo=$('#CardNo').val();
			if (CardNo=="") return;
			var myrtn=DHCACC_GetAccInfo("",CardNo,"","","CardNoKeyDownCallBack");
			return false;
		}
		if(SrcObj && SrcObj.id.indexOf("Gsearchmessage")>=0){
			var Gsearchmessage=$('#Gsearchmessage').val();
			if (Gsearchmessage=="") return;
			var SearchConditions=$('#SearchConditions').combobox('getValue');
			if (SearchConditions==2){
				if (Gsearchmessage.length<10) {
					for (var i=(10-Gsearchmessage.length-1); i>=0; i--) {
						Gsearchmessage="0"+Gsearchmessage;
					}
				}
				$('#Gsearchmessage').val(Gsearchmessage);
			}
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
    		$("#CardNo").val(CardNo);
    		$("#PatientID").val(PatientID);
    		OPDocLogTabDataGridLoad();
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
    		$("#CardNo").val(CardNo);
    		$("#PatientID").val(PatientID);
    		OPDocLogTabDataGridLoad();
			break;
		default:
			break;
	}
}
function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}
function CardNoChange(){
	var CardNo=$('#CardNo').val();
	if (CardNo==""){
		$("#PatientID,#CardTypeNew").val("");
	}
}
function GetPrintDetailData(){
	var PrintFlag="Y";
	return OPDocLogTabDataGridLoad(PrintFlag);
}
function LodopPrint(IndirPrint){
	var PrintNum = 1; //��ӡ����
	//var IndirPrint = "N"; //�Ƿ�Ԥ����ӡ
	var StartDate=$('#OpDate').datebox('getValue');
    var EndDate=$('#OpDate2').datebox('getValue');
	var TaskName="���ﲡ��ͳ�Ʊ�"; //��ӡ��������
	var Title=ServerObj.HospName+StartDate+"��"+EndDate+TaskName; //��ͷ
	var DetailData=GetPrintDetailData(); //��ϸ��Ϣ
	if (DetailData.length==0) {
		$.messager.alert("��ʾ","û����Ҫ����������!");
		return false;
	}
	//��ϸ��Ϣչʾ
	var Cols=[
		{field:'xuhao',title:'���',width:'70px',align:"center"},
		{field:'papminame',title:'����',width:'15%',align:"center"},
		{field:'papmigender',title:'�Ա�',width:'15%',align:"center"},
		{field:'papmiage',title:'����',width:'15%',align:"center"},
		{field:'papmidiagnose',title:'���',width:'15%',align:"center"},
		{field:'InfectFlag',title:'�Ƿ񱨿�',width:'15%',align:"center"},
		{field:'PAPERTelH',title:'��ϵ�绰',width:'15%',align:"center"},
		{field:'admfir',title:'�Ƿ����',width:'15%',align:"center"},
		{field:'admre',title:'�Ƿ���',width:'65px',align:"center"},
		{field:'CTLOCDesc',title:'�������',width:'15%',align:"center"},
		{field:'ctdesc',title:'����ҽ��',width:'15%',align:"center"}
	];	
	PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData)
}
function PrintClickHandle(){
	LodopPrint("N");
    /*var TemplatePath=$.cm({
		ClassName:"web.UDHCJFCOMMON",
		MethodName:"getpath",
		dataType:"text"
	},false); 
	TemplatePath=TemplatePath+"DHCOPDOCLog1.xls";
    var BeginDate,Depart,TotalSum,PatPaySum,PayorSum;
	var ParkINVInfo,ParkSum,ParkNum;
    var RefundINVInfo,RefundSum,RefundNum,CheckSum,CheckNum;
    var INVInfo;
    var UserName="";
    var myTotlNum=0;
    var CashNUM=0;
    var myencmeth="";
    var xlApp,xlsheet,xlBook;
    var UserName=session['LOGON.USERNAME'];
    //�õ�ҽ��ְ��
    var UserID=session['LOGON.USERID'];
    var UserTPDesc=$.cm({
		ClassName:"web.DHCOPDOCLog",
		MethodName:"GetUserTP",
		UserID:UserID,
		dataType:"text"
	},false); 
    //�õ�����
    var StartDate=$('#OpDate').datebox('getValue');
    var EndDate=$('#OpDate2').datebox('getValue');
    var BeginDate=StartDate;
    var Depart=session['LOGON.CTLOCDESC'];
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(TemplatePath);
    xlsheet = xlBook.ActiveSheet;
    xlsheet.PageSetup.LeftMargin=0;  
    xlsheet.PageSetup.RightMargin=0;
	var xlsrow=4;
	var xlsCurcol=1;
	if (ServerObj.HospName!="") xlsheet.cells(1,5)=ServerObj.HospName+"���ﲡ��ͳ�Ʊ�";
	xlsheet.cells(3,1)="��ӡ��������:";
	if (StartDate==EndDate){
		cxsj=EndDate;			
	}else{
		cxsj=StartDate+"��"+EndDate;
	}
    xlsheet.cells(3,5)=cxsj;
    var data=PageLogicObj.m_OPDocLogTabDataGrid.datagrid('getData');
	for (var i=0;i<data.rows.length;i++){
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,xlsCurcol)=data['rows'][i]['xuhao'];
		xlsheet.cells(xlsrow,xlsCurcol+1)=data['rows'][i]['papminame'];
		xlsheet.cells(xlsrow,xlsCurcol+2)=data['rows'][i]['papmigender'];
		xlsheet.cells(xlsrow,xlsCurcol+3)=data['rows'][i]['papmiage'];
		xlsheet.cells(xlsrow,xlsCurcol+4)=data['rows'][i]['papmidiagnose'];
		xlsheet.cells(xlsrow,xlsCurcol+5)=data['rows'][i]['InfectFlag'];
		xlsheet.cells(xlsrow,xlsCurcol+6)=data['rows'][i]['PAPERTelH'];
		var admfir="��"
		if (data['rows'][i]['admfir']==1){
			admfir="��";
		}
		xlsheet.cells(xlsrow,xlsCurcol+7)=admfir;
		var admre="��"
		if (data['rows'][i]['admre']==1){
			admre="��";
		}
		xlsheet.cells(xlsrow,xlsCurcol+8)=admre;
		xlsheet.cells(xlsrow,xlsCurcol+9)=data['rows'][i]['CTLOCDesc'];
		xlsheet.cells(xlsrow,xlsCurcol+10)=data['rows'][i]['ctdesc'];
	}
   gridlist(xlsheet,5,xlsrow,1,11)
   xlsheet.printout;
   xlBook.Close (savechanges=false);
   xlApp.Quit();
   xlApp=null;
   xlsheet=null;*/
}
function ExportClickHandle(){
	LodopPrint("Y");
	/*try {
		var TemplatePath=$.cm({
			ClassName:"web.UDHCJFCOMMON",
			MethodName:"getpath",
			dataType:"text"
		},false); 
        var BeginDate,Depart,TotalSum,PatPaySum,PayorSum;
		var ParkINVInfo,ParkSum,ParkNum;
	    var RefundINVInfo,RefundSum,RefundNum,CheckSum,CheckNum;
        var INVInfo;
        var UserName="";
        var myTotlNum=0;
        var CashNUM=0;
        var myencmeth="";
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCOPDOCLog.xls";
	    var UserName=session['LOGON.USERNAME'];
	    var StartDate=$('#OpDate').datebox('getValue');
    	var EndDate=$('#OpDate2').datebox('getValue');
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  
	    xlsheet.PageSetup.RightMargin=0;
	    xlsheet.cells(1,1)=StartDate+"��"+EndDate+"�ڼ�������־";
		var xlsrow=2;
		var xlsCurcol=0;
		var data=PageLogicObj.m_OPDocLogTabDataGrid.datagrid('getData');
		for (var i=0;i<data.rows.length;i++){
			xlsrow=xlsrow+1;
			xlsheet.cells(xlsrow,xlsCurcol+1)=data['rows'][i]['xuhao'];
			xlsheet.cells(xlsrow,xlsCurcol+2)=data['rows'][i]['CTLOCDesc'];
			xlsheet.cells(xlsrow,xlsCurcol+3)=data['rows'][i]['admdate'];
			xlsheet.cells(xlsrow,xlsCurcol+4)=data['rows'][i]['PatientID'];
			xlsheet.cells(xlsrow,xlsCurcol+5)=data['rows'][i]['papminame'];
			xlsheet.cells(xlsrow,xlsCurcol+6)=data['rows'][i]['PAPERTelH'];
			xlsheet.cells(xlsrow,xlsCurcol+7)=data['rows'][i]['papmigender'];
			xlsheet.cells(xlsrow,xlsCurcol+8)=data['rows'][i]['papmiage'];
			xlsheet.cells(xlsrow,xlsCurcol+9)=data['rows'][i]['TPAPMICardType'];
			xlsheet.cells(xlsrow,xlsCurcol+10)=data['rows'][i]['papmicredno'];
			
			xlsheet.cells(xlsrow,xlsCurcol+11)=data['rows'][i]['CTOCCDesc'];
			xlsheet.cells(xlsrow,xlsCurcol+12)=data['rows'][i]['papmiwork'];
			xlsheet.cells(xlsrow,xlsCurcol+13)=data['rows'][i]['papmidiagnose'];
			//xlsheet.cells(xlsrow,xlsCurcol+14)=data['rows'][i]['papmidiagnose'];
			xlsheet.cells(xlsrow,xlsCurcol+14)=data['rows'][i]['MRDIAICDCodeDR'];
			xlsheet.cells(xlsrow,xlsCurcol+15)=data['rows'][i]['PAADMTriageDat'];
			var val="";
			if (data['rows'][i]['admfir']==1) val="����";
			if (data['rows'][i]['admre']==1) val="����";
			xlsheet.cells(xlsrow,xlsCurcol+16)=val;
			xlsheet.cells(xlsrow,xlsCurcol+17)=data['rows'][i]['ctdesc'];
			xlsheet.cells(xlsrow,xlsCurcol+18)=data['rows'][i]['CTPCPId'];
			
			xlsheet.cells(xlsrow,xlsCurcol+19)=data['rows'][i]['InfectFlag'];
			xlsheet.cells(xlsrow,xlsCurcol+20)=data['rows'][i]['InfectionStr'];
			xlsheet.cells(xlsrow,xlsCurcol+21)=data['rows'][i]['IliFlag']?"��":"��";
		}
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()
	    $.messager.alert("��ʾ","�ļ�������������E�̸�Ŀ¼��!","info",function(){
		    xlBook.SaveAs("E:\\����ҽ����־"+h+m+s+".xls"); 
		    xlBook.Close (savechanges=false);
		    xlApp.Quit();
		    xlApp=null;
		    xlsheet=null;
		});
	} catch(e) {
		$.messager.alert("��ʾ",e.message);
	};*/
}
function gridlist(objSheet,row1,row2,c1,c2){
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}
function AmountClickHandle(){
	/*var data=PageLogicObj.m_OPDocLogTabDataGrid.datagrid('getData');
	if(data.rows.length==0){
		$.messager.alert("��ʾ","���Ȳ�ѯ������,�Ա�ͳ��.");
		return false;
	}
	var InfectStr=$.cm({
		ClassName:"web.DHCOPDOCLog",
		MethodName:"GetInfectStr",
		dataType:"text"
	},false); 
	if(InfectStr=="") InfectStr="0^0";*/
	var InfectStr="";
	var src="opdoc.recadmlogamount.hui.csp?InfectStr="+InfectStr;
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Amount","������־����", 650, 460,"icon-w-list","",$code,"");
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
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function OpenOrderView(EpisodeID){
	websys_showModal({
		url:"oeorder.opbillinfo.csp?EpisodeID="+EpisodeID,
		title:'ҽ���鿴',
		width:'90%',height:'90%',
		iconCls:'icon-w-paper'
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
function ExportPrintCommon(ResultSetTypeDo){
	var data=PageLogicObj.m_OPDocLogTabDataGrid.datagrid('getData');
	if(data.rows.length==0){
		$.messager.alert("��ʾ","���Ȳ�ѯ������,�Ա�ͳ��.");
		return false;
	}
	if (ResultSetTypeDo=="Print") {
		PageLogicObj.m_OPDocLogTabDataGrid.datagrid('print','���ﲡ��ͳ�Ʊ�');
		return ;
	}
	PageLogicObj.m_OPDocLogTabDataGrid.datagrid('toExcel','���ﲡ��ͳ�Ʊ�.xls');
	return ;
	//excel������ӡ���������⻻��Datagird������ӡ
	var TemplatePath=$.cm({
		ClassName:"web.UDHCJFCOMMON",
		MethodName:"getpath",
		dataType:"text"
	},false); 
	TemplatePath=TemplatePath+"DHCOPDOCLog1.xls";
	var Str ="(function test(x){"
		Str +="var xlApp = new ActiveXObject('Excel.Application');"
		Str +="var xlBook = xlApp.Workbooks.Add('"+TemplatePath+"');"
		Str +="var xlSheet = xlBook.ActiveSheet;"
		Str +="xlSheet.Columns.NumberFormatLocal = '@';"
		
		var xlsrow=4;
		var xlsCurcol=1;
		if (ServerObj.HospName!="") {
			Str +="xlSheet.cells(1,1)='"+ServerObj.HospName+"���ﲡ��ͳ�Ʊ�';"
		}
		Str +="xlSheet.cells(3,1)='��ӡ��������:';"
		var StartDate=$('#OpDate').datebox('getValue');
    	var EndDate=$('#OpDate2').datebox('getValue');
		if (StartDate==EndDate){
			cxsj=EndDate;			
		}else{
			cxsj=StartDate+"��"+EndDate;
		}
	    Str +="xlSheet.cells(3,5)='"+cxsj+"';"
	    var data=PageLogicObj.m_OPDocLogTabDataGrid.datagrid('getData');
		for (var i=0;i<data.rows.length;i++){
			xlsrow=xlsrow+1;
			Str +="xlSheet.cells("+(xlsrow)+","+(xlsCurcol)+")='"+data['rows'][i]['xuhao']+"';";
			Str +="xlSheet.cells("+(xlsrow)+","+(xlsCurcol+1)+")='"+data['rows'][i]['papminame']+"';";
			Str +="xlSheet.cells("+(xlsrow)+","+(xlsCurcol+2)+")='"+data['rows'][i]['papmigender']+"';";
			Str +="xlSheet.cells("+(xlsrow)+","+(xlsCurcol+3)+")='"+data['rows'][i]['papmiage']+"';";
			Str +="xlSheet.cells("+(xlsrow)+","+(xlsCurcol+4)+")='"+data['rows'][i]['papmidiagnose']+"';";
			Str +="xlSheet.cells("+(xlsrow)+","+(xlsCurcol+5)+")='"+data['rows'][i]['InfectFlag']+"';";
			Str +="xlSheet.cells("+(xlsrow)+","+(xlsCurcol+6)+")='"+data['rows'][i]['PAPERTelH']+"';";
			Str +="xlSheet.cells("+(xlsrow)+","+(xlsCurcol+7)+")='"+data['rows'][i]['admfir']+"';";
			Str +="xlSheet.cells("+(xlsrow)+","+(xlsCurcol+8)+")='"+data['rows'][i]['admre']+"';";
			Str +="xlSheet.cells("+(xlsrow)+","+(xlsCurcol+9)+")='"+data['rows'][i]['CTLOCDesc']+"';";
			Str +="xlSheet.cells("+(xlsrow)+","+(xlsCurcol+10)+")='"+data['rows'][i]['ctdesc']+"';";
		}
		var filename="���ﲡ��ͳ�Ʊ�.xls";
		if (ResultSetTypeDo=="Print") {
			Str +="xlSheet.PrintOut();"
		}else{
			Str += "var fname = xlApp.Application.GetSaveAsFilename('"+filename+"', 'Excel Spreadsheets (*.xls), *.xls');" 
			Str += "xlBook.SaveAs(fname);"
		}
		Str +="xlApp.Visible = false;"
		Str +="xlApp.UserControl = false;"
		Str +="xlBook.Close(savechanges=false);"
		Str +="xlApp.Quit();"
		Str +="xlSheet=null;"
		Str +="xlBook=null;"
		Str +="xlApp=null;"
		Str +="return 1;}());";
	//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
	CmdShell.notReturn =1;   //�����޽�����ã�����������
	var rtn =CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ����
}

/**
 * �����б�ť��ת�˵�
 * @param {*} cfg 
 */
function jumpMenu(cfg) {
	var menuCodeStr = cfg.url
	if (menuCodeStr == "") {
		var msg = "��ǰ�� <font style='font-weight:bold;color:red;'>ҽ��վ����-��ʾ��Ϣ����-���﹦������ť���� ��/������־�а�ť</font> ������ ���� ��Ӧ�˵����룡"
		$.messager.alert("��ʾ", msg, "info")
		return false
	}
	var top = websys_getMenuWin()
	if(top) {
		var matchMenu = getMatchMenu(top.menuJson.records, menuCodeStr, null)
		// console.log(matchMenu)
		if (matchMenu != null) {
			var link = ""
			var newwin = ""
			if (matchMenu.target == "_blank") {
				newwin = matchMenu.blankOpt
			}
			// ҽ��վ����-��ʾ��Ϣ����-���﹦������ť���� ���߲�ѯ�а�ť �����¼������ô��´��ڵĲ���������Ҫ�Ŀɲ����ã���ԭ�в˵��򿪷�ʽ����
			// Ex: "top=6%,left=2%,width=96%,height=105%"
			if (cfg.handler != "") {
				newwin = cfg.handler
			}
			if (matchMenu.link.indexOf("javascript:") > -1) {
				link = matchMenu.link.split("'")[1]
			} else {
				link = matchMenu.link
			}
			top.PassDetails(link, newwin)
		} else {
			$.messager.alert("��ʾ", "��û��Ȩ�޴򿪵�ǰ��ť��Ӧ�˵���", "info")
			return false
		}
	} else {
		$.messager.alert("��ʾ", "δ�ܻ�ȡͷ�˵� ��top��, ����ϵ����ƽ̨֧�֣�", "info")
		return false
	}
}

/**
 * �ݹ��ȡ��ť��Ӧ�˵���ĿǰӦ����Ҫ��ͷ�˵���
 * @param {*} menuArr 
 * @param {*} menuCodeStr 
 * @param {*} matchMenu 
 * @returns 
 */
function getMatchMenu(menuArr, menuCodeStr, matchMenu) {
	for (var i = 0; i < menuArr.length; i++) {
		if (menuArr[i].link != "#") {
			// replaceAll() ������ҽΪ�����
			// var menuCode = menuArr[i].code.replaceAll("_", ".")
			var menuCode = menuArr[i].code.replace(/_/g, ".")
			if ((";" + menuCodeStr + ";").indexOf(";" + menuCode + ";") > -1) {
				matchMenu = menuArr[i]
				return matchMenu
			}
		} else {
			var matchMenu = getMatchMenu(menuArr[i].children, menuCodeStr, matchMenu)
			if (matchMenu) {
				return matchMenu
			}
		}
	}
	return matchMenu
}
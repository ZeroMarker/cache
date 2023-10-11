var PageLogicObj={
	m_OPDocLogTabDataGrid:"",
	NotShowColTitleStr:"^操作^证件号^证件类型^传染病^ICD^地址^登记号^费别^就诊日期^流感样^就诊^病案号^发病日期^医生工号^就诊时间(医嘱)^职业^" 
	//导出或者打印 通过indexOf判断不需要显示的列 title用^分割
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
	$("#OpDate,#OpDate2").datebox('setValue',ServerObj.NowDate);
	//查询条件
	LoadSearchConditions(); 
	//科室
	LoadDept(); 
	//状态条件
	LoadSerCon();
	//诊断
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
		{field:'xuhao',title:'序号',width:40,align:'center'},
		{field:"patOperBtn", title:'操作', width:90, align:'center',
			formatter: function(value, row, index) {
				var operDiv = '<div id="patOperBtn_'  + index + '" style="width:100%;height:100%"></div>'
				return operDiv
			}
		},
		{field:'paadmrowid',hidden:true,title:''},
		{field:'PatientID',hidden:true,title:''},
		{field:'papmiCardNo',title:'登记号',width:100,
			formatter:function(value,row,index){
	    		var btn = '<a style="text-decoration: underline;color:#339eff" onclick="OpenOrderView(\''+row.paadmrowid +'\')">'+value+'\</a>';
	    		return btn;
	    	}
		},
		{field:'papminame',title:'姓名',width:110},
		{field:'papmigender',title:'性别',width:50},
		{field:'papmiage',title:'年龄',width:50},
		{field:'AdmReason',title:'费别',width:80},
		{field:'TPAPMICardType',title:'证件类型',width:130},
		{field:'papmicredno',title:'证件号',width:150},
		{field:'papmiwork',title:'地址',width:150},
		{field:'papmidiagnose',title:'初步诊断',width:150},
		{field:'ctdesc',title:'医生',width:100},
		{field:'admdate',title:'就诊日期',width:100},
		{field:'InfectFlag',title:'是否报卡',width:80},
		{field:'PAPERTelH',title:'联系电话',width:100},
        {field:'admfir',title:'初诊',width:50,align:'center'
        },
       	{field:'admre',title:'复诊',width:50,align:'center'
        },
        {field:'IliFlag',title:'流感样',width:60,align:'center',
			formatter: function(value,row,index){
	        	if (value=="on"){value=$g("是")}else{value=$g("否")}
				return value;
			}
        },
		/*//初诊，复诊，流感样 编辑模式
		{field:'admfir',title:'初诊',formatter: function(value,row,index){  
                var checked=(value=="1")?"checked":"";  
                return "<input type='checkbox' disabled "+checked+">";  
            }  
        },  
        {field:'admre',title:'复诊',formatter: function(value,row,index){  
                var checked=(value=="1")?"checked":"";  
                return "<input type='checkbox' disabled "+checked+">";  
            }},  
        {field:'IliFlag',title:'流感样',formatter: function(value,row,index){  
                var checked=(value=="1")?"checked":"";  
                return "<input type='checkbox' disabled "+checked+">";  
            }  
        }, */
		{field:'InfectionStr',title:'传染病',width:80},
		{field:'CTLOCDesc',title:'科室',width:120},
		{field:'CTOCCDesc',title:'职业',width:100},
		{field:'jz',title:'就诊',width:50},
		{field:'Mdeicare',title:'病案号',width:80},
		{field:'time',title:'就诊时间(医嘱)',width:120},
		{field:'PAADMTriageDat',title:'发病日期',width:130},
		{field:'CTPCPId',title:'医生工号',width:100},
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
			// 列宽改变，按钮区随之变化
			if (field == "patOperBtn") {
				$(this).datagrid('getPanel').find('td[field="patOperBtn"]').find('.shortcutbar-list-x').panel('resize')
			}
		},
		onLoadSuccess: function(data) {
			// 处理行高太小
			$(this).datagrid('getPanel').find('div.datagrid-body tr').find('td[field="patOperBtn"]').children("div").css({   
				"height": "40px" 
			})
			// 处理序号高度
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
		$.messager.alert("提示","日期不能为空!");
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
	    SearhLoc:$HUI.checkbox("#SearhLoc").getValue() ? "on" : "", //查询本科
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
			data: [{"id":"1","text":$g("患者姓名")},{"id":"2","text":$g("登记号")},{"id":"3","text":$g("病案号")}]
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
            {field:'desc',title:'诊断名称',width:300,sortable:true},
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
			$.messager.alert("提示","卡无效!","info",function(){
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
	var PrintNum = 1; //打印次数
	//var IndirPrint = "N"; //是否预览打印
	var StartDate=$('#OpDate').datebox('getValue');
    var EndDate=$('#OpDate2').datebox('getValue');
	var TaskName="门诊病人统计表"; //打印任务名称
	var Title=ServerObj.HospName+StartDate+"至"+EndDate+TaskName; //表头
	var DetailData=GetPrintDetailData(); //明细信息
	if (DetailData.length==0) {
		$.messager.alert("提示","没有需要操作的数据!");
		return false;
	}
	//明细信息展示
	var Cols=[
		{field:'xuhao',title:'序号',width:'70px',align:"center"},
		{field:'papminame',title:'姓名',width:'15%',align:"center"},
		{field:'papmigender',title:'性别',width:'15%',align:"center"},
		{field:'papmiage',title:'年龄',width:'15%',align:"center"},
		{field:'papmidiagnose',title:'诊断',width:'15%',align:"center"},
		{field:'InfectFlag',title:'是否报卡',width:'15%',align:"center"},
		{field:'PAPERTelH',title:'联系电话',width:'15%',align:"center"},
		{field:'admfir',title:'是否初诊',width:'15%',align:"center"},
		{field:'admre',title:'是否复诊',width:'65px',align:"center"},
		{field:'CTLOCDesc',title:'就诊科室',width:'15%',align:"center"},
		{field:'ctdesc',title:'就诊医生',width:'15%',align:"center"}
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
    //得到医生职称
    var UserID=session['LOGON.USERID'];
    var UserTPDesc=$.cm({
		ClassName:"web.DHCOPDOCLog",
		MethodName:"GetUserTP",
		UserID:UserID,
		dataType:"text"
	},false); 
    //得到日期
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
	if (ServerObj.HospName!="") xlsheet.cells(1,5)=ServerObj.HospName+"门诊病人统计表";
	xlsheet.cells(3,1)="打印就诊日期:";
	if (StartDate==EndDate){
		cxsj=EndDate;			
	}else{
		cxsj=StartDate+"至"+EndDate;
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
		var admfir="否"
		if (data['rows'][i]['admfir']==1){
			admfir="是";
		}
		xlsheet.cells(xlsrow,xlsCurcol+7)=admfir;
		var admre="否"
		if (data['rows'][i]['admre']==1){
			admre="是";
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
	    xlsheet.cells(1,1)=StartDate+"至"+EndDate+"期间门诊日志";
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
			if (data['rows'][i]['admfir']==1) val="初诊";
			if (data['rows'][i]['admre']==1) val="复诊";
			xlsheet.cells(xlsrow,xlsCurcol+16)=val;
			xlsheet.cells(xlsrow,xlsCurcol+17)=data['rows'][i]['ctdesc'];
			xlsheet.cells(xlsrow,xlsCurcol+18)=data['rows'][i]['CTPCPId'];
			
			xlsheet.cells(xlsrow,xlsCurcol+19)=data['rows'][i]['InfectFlag'];
			xlsheet.cells(xlsrow,xlsCurcol+20)=data['rows'][i]['InfectionStr'];
			xlsheet.cells(xlsrow,xlsCurcol+21)=data['rows'][i]['IliFlag']?"是":"否";
		}
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()
	    $.messager.alert("提示","文件将保存在您的E盘根目录下!","info",function(){
		    xlBook.SaveAs("E:\\门诊医生日志"+h+m+s+".xls"); 
		    xlBook.Close (savechanges=false);
		    xlApp.Quit();
		    xlApp=null;
		    xlsheet=null;
		});
	} catch(e) {
		$.messager.alert("提示",e.message);
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
		$.messager.alert("提示","请先查询出数据,以便统计.");
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
	createModalDialog("Amount","门诊日志汇总", 650, 460,"icon-w-list","",$code,"");
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
function OpenOrderView(EpisodeID){
	websys_showModal({
		url:"oeorder.opbillinfo.csp?EpisodeID="+EpisodeID,
		title:'医嘱查看',
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
		$.messager.alert("提示","请先查询出数据,以便统计.");
		return false;
	}
	if (ResultSetTypeDo=="Print") {
		PageLogicObj.m_OPDocLogTabDataGrid.datagrid('print','门诊病人统计表');
		return ;
	}
	PageLogicObj.m_OPDocLogTabDataGrid.datagrid('toExcel','门诊病人统计表.xls');
	return ;
	//excel导出打印经常出问题换成Datagird导出打印
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
			Str +="xlSheet.cells(1,1)='"+ServerObj.HospName+"门诊病人统计表';"
		}
		Str +="xlSheet.cells(3,1)='打印就诊日期:';"
		var StartDate=$('#OpDate').datebox('getValue');
    	var EndDate=$('#OpDate2').datebox('getValue');
		if (StartDate==EndDate){
			cxsj=EndDate;			
		}else{
			cxsj=StartDate+"至"+EndDate;
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
		var filename="门诊病人统计表.xls";
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
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
	var rtn =CmdShell.EvalJs(Str);   //通过中间件运行打印程序
}

/**
 * 患者列表按钮跳转菜单
 * @param {*} cfg 
 */
function jumpMenu(cfg) {
	var menuCodeStr = cfg.url
	if (menuCodeStr == "") {
		var msg = "请前往 <font style='font-weight:bold;color:red;'>医生站配置-显示信息配置-门诊功能区按钮配置 门/急诊日志行按钮</font> 的链接 配置 对应菜单代码！"
		$.messager.alert("提示", msg, "info")
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
			// 医生站配置-显示信息配置-门诊功能区按钮配置 患者查询行按钮 单击事件，配置打开新窗口的参数，不需要的可不配置，按原有菜单打开方式处理
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
			$.messager.alert("提示", "您没有权限打开当前按钮对应菜单！", "info")
			return false
		}
	} else {
		$.messager.alert("提示", "未能获取头菜单 “top”, 请联系基础平台支持！", "info")
		return false
	}
}

/**
 * 递归获取按钮对应菜单（目前应该主要是头菜单）
 * @param {*} menuArr 
 * @param {*} menuCodeStr 
 * @param {*} matchMenu 
 * @returns 
 */
function getMatchMenu(menuArr, menuCodeStr, matchMenu) {
	for (var i = 0; i < menuArr.length; i++) {
		if (menuArr[i].link != "#") {
			// replaceAll() 不兼容医为浏览器
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
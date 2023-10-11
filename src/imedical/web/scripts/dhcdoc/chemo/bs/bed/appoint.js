/**
 * appoint.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
var PLObject = {
	v_DefaultDate:''
}
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitCombox()
	InitGlobal();
	InitDate();
	InitGrid();
	
}

function InitEvent () {
	$("#i-find").click(Find_Handle);
	$("#i-printAM").click(function(){
		Print_Handle("A","上午")
	})
	$("#i-printPM").click(function() {
		Print_Handle("P","下午")	
	})
	$("#BL").click(BL_Handle)
	//$(document.body).bind("keydown",BodykeydownHandler)
}

function InitCombox() {
	PLObject.m_Hosp = $HUI.combobox("#Hosp", {
		url:$URL+"?ClassName=DHCDoc.PW.COM.Query&QueryName=QryHosp&ResultSetType=array",
		valueField:'id',
		textField:'text',
		disabled:true,
		value:session['LOGON.HOSPID'],
		blurValidValue:true

	});
}

function InitDate() {
	$("#ChemoDate").datebox({
		value:PLObject.v_DefaultDate,
		editable:false,
		onSelect: function (date) {
			var curDate = $(this).datebox("getValue");
			Find_Handle();
		}
	})
	//$("#ChemoDate").datebox("setValue",result);
	
}
function InitGlobal () {
	var result = tkMakeServerCall("DHCDoc.Chemo.BS.Bed.Manage", "GetDefaultDate");
	PLObject.v_DefaultDate = result;
	
}

function InitGrid(){
	var columns = tkMakeServerCall("DHCDoc.Chemo.BS.Bed.AppList","GetColumns");
	var columnsArr = columns.split(String.fromCharCode(1));
	for (var i=0; i<columnsArr.length; i++) {
		var json = JSON.parse(columnsArr[i]);
		columnsArr[i] = json;
	}
	var columnsNew = [];
	columnsNew.push(columnsArr);
	
	var frozenColumns= [[
		{field:'patName',title:'姓名'},
	]]
	var DataGrid = $HUI.datagrid("#i-list", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		//fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		nowrap:false,
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.Chemo.BS.Bed.AppList",
			QueryName : "QryAppList",
			SelectDate:$("#ChemoDate").datebox("getValue")||"",
			InHosp:session['LOGON.HOSPID']
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		//frozenColumns:frozenColumns,
		toolbar:[
				{
						text:'病历',
						id:'BL',
						iconCls: 'icon-emr-cri'
				}
				/*,
				{
						text:'患者费用',
						id:'i-edit',
						iconCls: 'icon-pat-fee-det'
				},{
						text:'化验结果',
						id:'i-delete',
						iconCls: 'icon-write-order'
				},{
						text:'检查结果',
						id:'i-delete',
						iconCls: 'icon-end-adm'
				}*/
					
		],
		columns :columnsNew
	});
	
	PLObject.m_Grid = DataGrid;
}

function Find_Handle () {
	var SelectDate = $("#ChemoDate").datebox("getValue")||""
	PLObject.m_Grid.reload({
		ClassName : "DHCDoc.Chemo.BS.Bed.AppList",
		QueryName : "QryAppList",
		SelectDate:SelectDate,
		InHosp:session['LOGON.HOSPID']
	});
}

function clearConfig() {
	//PLObject.v_Arcim = "";
	//$("#i-drug").lookup("setText","");
	$("#i-drug").val("");
	findConfig();
}

function DatatLoad(){
	$.cm({
	    ClassName : PageLogicObj.m_ClassName,
	    QueryName : "FindUPLSClassProperty",
		ClsName:$("#ClassListSearch").combobox("getValue"),
	    rows:99999
	},function(GridData){
		$("#DataList").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		$("#DataList").datagrid("clearSelections")
	});
}


function BodykeydownHandler(e){
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
		if(SrcObj && SrcObj.id.indexOf("i-drug")>=0){
			findConfig();
		}
		return true;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}

function BL_Handle (EpisodeID) {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var EpisodeID = selected.EpisodeID;
	//var lnk= "emr.record.browse.csp?"+"EpisodeID="+selected.EpisodeID;
	
	var lnk= "websys.chartbook.hisui.csp?"+"EpisodeID="+EpisodeID;
	lnk = lnk +"&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookName=DHC.Doctor.DHCEMRbrowse"
	
	websys_showModal({
		url:lnk,
		iconCls: 'icon-w-list',
		title:'病历浏览',
		width:$(window).width()-100,height:$(window).height()-100
	})
	return false;
}

function Print_Handle(Type,TypeDesc){
	var SelectDate = $("#ChemoDate").datebox("getValue")||""
	
	var param = "SelectDate="+SelectDate+"&InType="+Type+"&InHosp="+session['LOGON.HOSPID'];
	
	var URL = "dhccpmrunqianreport.csp?reportName=Chemo-AppointList.rpx&"+param;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-print',
		title:'打印'+TypeDesc,
		width:1000,height:600
	})
}

function Print_Handle2 () {
	var SelectDate = $("#ChemoDate").datebox("getValue")||"",IsTitle=1
	// 加载XML
	/*DHCP_GetXMLConfig("InvPrintEncrypt","ChemoAppointList")
	var LODOP = getLodop();
	LODOP.PRINT_INIT(""); //清除上次打印元素
	
	LODOP.ADD_PRINT_TEXT(11,23,98,19,"签名医生")
	//LODOP.ADD_PRINT_TEXT(11,23,98,19,"<table><tr><td>1</td></tr></table>")
	LODOP.PRINT();*/
	var param = "SelectDate="+SelectDate+"&IsTitle="+IsTitle
	websys_printout("ChemoAppointList","isLodop=1&showPrintBtn=1&"+param,"width=830,height=660,top=20,left=100");
	//websys_printout("DHCPassWork","isLodop=1&showPrintBtn=1&"+param,"width=830,height=660,top=20,left=100");
}

function Print_Handle3(Type){
	
	try {   
		var TemplatePath="";
		var GetPrescPath=document.getElementById("printpath");  
		if (GetPrescPath) {var encmeth=GetPrescPath.value} else {var encmeth=''};
		if (encmeth!="") {
			TemplatePath=cspRunServerMethod(encmeth);
		}
		//alert(TemplatePath)
		//上边的方法是用来获取模板所在地址的
		//TemplatePath="http://192.192.10.123/TrakCare/App/Results/Template/"DHCEQSDepreLoc  DHCExamPatList1.xls
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"ChemoList.xls";
	   
		//左右边距
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=15;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
		//获取页面数据
		var UserID=session['LOGON.USERID']
		
		var myRows=2;
		var vaild = window.confirm("确认打印么!")
		if(vaild){} else{return;}
		
		var SelectDate = $("#ChemoDate").datebox("getValue")||""
		if (ServerObj.GetChemoRowList!="") {
			ChemoRowList=cspRunServerMethod(ServerObj.GetChemoRowList,SelectDate,Type);
		} else {
			return false;
		}
		//alert(ChemoRowList)
		var ChemoJSON = jQuery.parseJSON(ChemoRowList)
		var xlsrow=2; //用来指定模板的开始行数位置
		var xlsCurcol=0;  //用来指定开始的列数位置
		//alert(111)
		
		var Flag=1
		
		for (var Row=1;Row<=ChemoJSON.length;Row++)
		{   
		    if (xlsrow==(50*Flag))
		    {Flag=Flag+1
			 xlsheet.PrintOut;
			 var xlsrow=2;
		     var xlsCurcol=0;
		     xlApp = new ActiveXObject("Excel.Application");
		     xlBook = xlApp.Workbooks.Add(Template);
		     xlsheet = xlBook.ActiveSheet; 
		     //alert(111)
		     //console.log(xlsheet.PageSetup.Orientation)
		    xlsheet.PageSetup.Orientation =2 ; 
		     
		    /*LeftMargin   = xlApp.InchesToPoints( 0.748031496062992 ) ;
			RightMargin  = xlApp.InchesToPoints( 0.748031496062992 ) ;  
			TopMargin    = xlApp.InchesToPoints( 0.984251968503937 ) ;
			BottomMargin = xlApp.InchesToPoints( 0.984251968503937 ) ;
			
			HeaderMargin = xlApp.InchesToPoints( 0.511811023622047 ) ;
			FooterMargin = xlApp.InchesToPoints( 0.511811023622047 ) ;
			*/
		     //xlsheet.PageSetup.LeftMargin=15;  //lgl+
	    	 //xlsheet.PageSetup.RightMargin=0;
			   }
			  // return 
			xlsrow=xlsrow+1; //从第三行开始
			
            var DataValue = ChemoJSON[Row];
            DataValue = DataValue.split("^");
            xlsheet.cells(xlsrow,xlsCurcol+1)=DataValue[0];	//时间
            xlsheet.cells(xlsrow,xlsCurcol+2)=DataValue[1]; //姓名
            xlsheet.cells(xlsrow,xlsCurcol+3)=DataValue[2];//年龄
            xlsheet.cells(xlsrow,xlsCurcol+4)=DataValue[3];//性别
           
            xlsheet.cells(xlsrow,xlsCurcol+5)=DataValue[4];//床号
            xlsheet.cells(xlsrow,xlsCurcol+6)=DataValue[5];//病人ID
            xlsheet.cells(xlsrow,xlsCurcol+7)=DataValue[6];//患者电话
            xlsheet.cells(xlsrow,xlsCurcol+8)=DataValue[7];//录入人
			
            xlsheet.cells(xlsrow,xlsCurcol+9)=DataValue[14];// 化疗方案
            xlsheet.cells(xlsrow,xlsCurcol+10)=DataValue[8];// 药品
			
               }
        
        xlsheet.cells(1,1)="门诊化疗预约一览表"
		//gridlist(xlsheet,6,xlsrow,2,13)  //此处是画横向表格
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()
	    // alert("文件将保存在您的C盘根目录下");
	    xlsheet.PrintOut;
	    //xlBook.SaveAs("C:\\"+"北京协和医院患者查找单"+h+m+s+".xls");   //lgl+
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} catch(e) {
		//alert(e.message);
	};
}
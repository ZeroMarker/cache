//===========================================================================================
// 作者：      sufan
// 编写日期:   2018-12-04
// 描述:	   死亡登记
//===========================================================================================
var excelData=[];
/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化加载病人就诊ID
	InitPatEpisodeID();
	
	InitPatInfoPanel();
	
	initDisable();
	
	/// 初始化加载病人列表
	InitDeathRegList();
	
	InitMethod();
	
}

function initDisable(){
	$HUI.datebox("#WinRegDate").disable();
	$("#WinPatNo").attr("disabled",true);
	$("#WinName").attr("disabled",true);
	$("#WinPatSex").attr("disabled",true);
	$("#WinAdd").attr("disabled",true);
	$("#WinPatAge").attr("disabled",true);
	$("#WinTel").attr("disabled",true);
	
	$HUI.combobox("#Winsource").disable();
	$HUI.datebox("#WinBirthDate").disable();
	return;
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");
}

/// 初始化病人基本信息
function InitPatInfoPanel(){
	
	
	$HUI.datebox("#stDate").setValue(formatDate(0)); 	///开始日期
	$HUI.datebox("#endDate").setValue(formatDate(0));	///结束日期
	
	///位置
	$HUI.combobox("#Location",{
		url:LINK_CSP+"?ClassName=web.DHCEMVisitStat&MethodName=GetEmWard&HospID="+session['LOGON.HOSPID'],
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		onSelect:function(option){
	      
	    }	
	})
	
	
	///弹出窗口来源
	$HUI.combobox("#Winsource",{
		url:LINK_CSP+"?ClassName=web.DHCEMVisitStat&MethodName=GetEmWard&HospID="+session['LOGON.HOSPID'],
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		onSelect:function(option){
	      
	    }	
	})
	
	/// 送预防科日期控制
	$('#WinSendDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	/// 送病历室日期控制
	$('#WinSendMedDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
}

///初始化事件
function InitMethod()
{
	///登记号回车事件
	$('#PatRegNo').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            RegNoBlur();
            commonQuery();
        }
    });	
}

///补零方法
function RegNoBlur()
{
	var i;
    var regno=$('#PatRegNo').val();
    var oldLen=regno.length;
    if (oldLen==10) return;
	if (regno!="") {  //add 0 before regno
	    for (i=0;i<10-oldLen;i++)
	    //for (i=0;i<8-oldLen;i++)
	    {
	    	regno="0"+regno 
	    }
	}
    $("#PatRegNo").val(regno);
}
/// 页面DataGrid初始定义已选列表
function InitDeathRegList(){
	
	///  定义columns
	var columns=[[
		{field:'select',title:'选择',checkbox:true,width:40,align:'center'},
		{field:'seqNo',title:'序号',width:40,align:'center'},
		{field:'DeathNum',title:'编号',width:80},
		{field:'PatRegNo',title:'登记号',width:80},
		{field:'PatName',title:'姓名',width:60},
		{field:'PatSex',title:'性别',width:80},
		{field:'PatAge',title:'实足年龄',width:80},
		{field:'HouseHoldName',title:'户主姓名',width:80},
		{field:'RegDate',title:'登记日期',width:100},
		{field:'Birth',title:'出生日期',width:100},
		{field:'VistDate',title:'死亡日期',width:100},
		{field:'DateDel',title:'送预防科日期',width:100},
		{field:'DateSendMed',title:'送病历室日期',width:100},
		{field:'Tel',title:'电话',width:100},
		{field:'Add',title:'地址',width:100},
		{field:'Come',title:'来源',width:100}
	]];
	
	///  定义datagrid
	var option = {
		iconCls:'icon-paper', //hxy 2022-11-16 st
		title:$g('死亡登记'),
		fitColumns:true, //ed
		//showHeader:false,
		toolbar:"#toolbar",
		border:true,
		headerCls:'panel-header-gray',
		rownumbers : false,
		singleSelect : true,
		checkOnSelect : false,
		selectOnCheck : false,
		pagination: true,
		onClickRow:function(rowIndex, rowData){
	    },
		onLoadSuccess:function(data){
			excelData = data.rows;
		}
	};

	var param = getSearParam();
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMDeathRegQuery&MethodName=JSonQueryEmDeathData&params="+param;
	new ListComponent('deathreglist', columns, uniturl, option).Init();
}

///查询
function commonQuery()
{
	var param = getSearParam();
	$HUI.datagrid('#deathreglist').load({
		"params":param
	})
}
///导出
function commonExport()
{
	if(excelData.length){
		expExcel(excelData);	
	}else{
		$.messager.alert("提示","没有数据导出！");	
	}
}
///导出
function expExcelOld(itbl)
{		
//		runClassMethod("web.UDHCJFCOMMON","getpath",{'itmjs':'','itmjsex':''},function(jsonString){
//			TemplatePath = jsonString;
//		},'',false)
//		
		var TemplatePath = serverCall("web.DHCDocConfig","GetPath");
		var hospName = "";
		runClassMethod("web.DHCEMRegister","gethHospitalName",{'locId':LgCtLocID},function(jsonString){
			hospName = jsonString;  
		},'text',false)
		
 	 	xlsExcel = new ActiveXObject("Excel.Application");
 	 	xlsBook = xlsExcel.Workbooks.Add() 
    	xlsSheet = xlsBook.ActiveSheet; 
    	xlsExcel.Visible = true;  
    	xlsExcel.Range(xlsSheet.Cells(1,1),xlsSheet.Cells(1,15)).MergeCells = true;
    	xlsExcel.Range(xlsSheet.Cells(2,1),xlsSheet.Cells(2,15)).MergeCells = true;
    	xlsSheet.cells(1,1).Font.Bold = true;
    	xlsSheet.cells(2,1).Font.Bold = true;
    	xlsSheet.cells(1,1).Font.Size =24;
    	xlsSheet.cells(1,1).HorizontalAlignment = -4108;
    	xlsSheet.cells(2,1).HorizontalAlignment = -4108;
    	for(i=1;i<15;i++){
	    	if(i==1) xlsSheet.cells(1,i).ColumnWidth=5;
	    	if(i!=1) xlsSheet.cells(1,i).ColumnWidth=10;	
	    }
    	
    	
		xlsSheet.cells(1,1) =hospName;     
  	  	xlsSheet.cells(2,1)="死亡登记";
    	xlsSheet.cells(3,1)="序号";
		xlsSheet.cells(3,2)="编号";
	   	xlsSheet.cells(3,3)="登记号";
	    xlsSheet.cells(3,4)="姓名";
	    xlsSheet.cells(3,5)="性别";
	    xlsSheet.cells(3,6)="实足年龄";
	    xlsSheet.cells(3,7)="户主姓名";
	    xlsSheet.cells(3,8)="登记日期";
		xlsSheet.cells(3,9)="出生日期";
	    xlsSheet.cells(3,10)="死亡日期";
	    xlsSheet.cells(3,11)="送预防科日期";
	    xlsSheet.cells(3,12)="送病历室日期";
	    xlsSheet.cells(3,13)="电话";
		xlsSheet.cells(3,14)="地址";
		xlsSheet.cells(3,15)="来源";
   
    if (itbl.length==0) {
	    $.messager.alert("提示","没有选中数据！");
	    return;
	}	
    for (var i=0; i<itbl.length; i++) {
	    xlsSheet.cells(i+4,1)=i+1;
		xlsSheet.cells(i+4,2)="'"+itbl[i].DeathNum;
	    xlsSheet.cells(i+4,3)="'"+itbl[i].PatRegNo;
	    xlsSheet.cells(i+4,4)="'"+itbl[i].PatName;
	    xlsSheet.cells(i+4,5)=itbl[i].PatSex;
	    xlsSheet.cells(i+4,6)=itbl[i].PatAge;
	    xlsSheet.cells(i+4,7)=itbl[i].HouseHoldName;
	    xlsSheet.cells(i+4,8)=itbl[i].RegDate;
	    xlsSheet.cells(i+4,9)=itbl[i].Birth;                   
	    xlsSheet.cells(i+4,10)=itbl[i].VistDate; 
	    xlsSheet.cells(i+4,11)="'"+itbl[i].DateDel;
	    xlsSheet.cells(i+4,12)=itbl[i].DateSendMed;   
	    xlsSheet.cells(i+4,13)=itbl[i].Tel;  
	    xlsSheet.cells(i+4,14)="'"+itbl[i].Add;  
	    xlsSheet.cells(i+4,15)=itbl[i].Come;    
 	 }
	gridlist(xlsSheet,3,itbl.length+3,1,15)
	xlsSheet.Columns.AutoFit; 
	xlsExcel.ActiveWindow.Zoom = 75 
	xlsExcel.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 

	xlsExcel=null; 
    xlsBook=null; 
    xlsSheet=null; 
}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=2
}

///导出
function expExcel(itbl)
{		var Dea=$g('死亡登记');
		var DeathNum=$g('编号');
		var PatRegNo=$g('登记号')
		var PatName=$g('姓名');
		var PatSex=$g('性别');
		var PatAge=$g('实足年龄');
		var HouseHoldName=$g('户主姓名');
		var RegDate=$g('登记日期');
		var Birth=$g('出生日期');
		var VistDate=$g('死亡日期');
		var DateDel=$g('送预防科日期');
		var DateSendMed=$g('送病历室日期');
		var Tel=$g('电话');
		var Add=$g('地址');
		var Come=$g('来源');
		
		var TemplatePath = serverCall("web.DHCDocConfig","GetPath");
		var hospName = "";
		runClassMethod("web.DHCEMRegister","gethHospitalName",{'locId':LgCtLocID},function(jsonString){
			hospName = jsonString;  
		},'text',false)
	
 	 	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
		"var xlBook = xlApp.Workbooks.Add();"+
		"var xlSheet = xlBook.ActiveSheet;";
		
		Str=Str+"xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,15)).MergeCells = true;"+ //合并单元格
		"xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(2,15)).MergeCells = true;"+ //合并单元格
		"xlSheet.Cells(1,1).Font.Bold = true;"+
		"xlSheet.Cells(2,1).Font.Bold = true;"+
		"xlSheet.Cells(1,1).Font.Size = 24;"+
		"xlSheet.Cells(1,1).HorizontalAlignment = -4108;"+
		"xlSheet.Cells(2,1).HorizontalAlignment = -4108;";
    	for(i=1;i<15;i++){
	    	if(i==1) Str=Str+"xlSheet.cells(1,"+i+").ColumnWidth=5;";
	    	if(i!=1) Str=Str+"xlSheet.cells(1,"+i+").ColumnWidth=10;";
	    }
    	
		Str=Str+"xlSheet.cells(1,1) ='"+hospName+"';"+    
  	  	"xlSheet.cells(2,1).value='"+Dea+"';"+
    	"xlSheet.cells(3,2).value='"+DeathNum+"';"+
    	"xlSheet.cells(3,3).value='"+PatRegNo+"';"+
    	"xlSheet.cells(3,4).value='"+PatName+"';"+
    	"xlSheet.cells(3,5).value='"+PatSex+"';"+
    	"xlSheet.cells(3,6).value='"+PatAge+"';"+
		"xlSheet.cells(3,7).value='"+HouseHoldName+"';"+
		"xlSheet.cells(3,8).value='"+RegDate+"';"+
		"xlSheet.cells(3,9).value='"+Birth+"';"+
		"xlSheet.cells(3,10).value='"+VistDate+"';"+
		"xlSheet.cells(3,11).value='"+DateDel+"';"+
		"xlSheet.cells(3,12).value='"+DateSendMed+"';"+
		"xlSheet.cells(3,13).value='"+Tel+"';"+
		"xlSheet.cells(3,14).value='"+Add+"';"+
		"xlSheet.cells(3,15).value='"+Come+"';";
   
    if (itbl.length==0) {
	    $.messager.alert("提示","没有选中数据！");
	    return;
	}	
    for (var i=0; i<itbl.length; i++) {
	    Str=Str+"xlSheet.cells("+(i+4)+",1).value='"+(i+1)+"';"+
	    "xlSheet.Columns(2).NumberFormatLocal='@';"+
	    "xlSheet.Columns(3).NumberFormatLocal='@';"+
	    "xlSheet.Columns(4).NumberFormatLocal='@';"+
	    "xlSheet.Columns(11).NumberFormatLocal='@';"+
	    "xlSheet.Columns(13).NumberFormatLocal='@';"+
	    "xlSheet.Columns(14).NumberFormatLocal='@';"+
	    "xlSheet.cells("+(i+4)+",2)='"+itbl[i].DeathNum+"';"+
	    "xlSheet.cells("+(i+4)+",3)='"+itbl[i].PatRegNo+"';"+
	    "xlSheet.cells("+(i+4)+",4)='"+itbl[i].PatName+"';"+
	    "xlSheet.cells("+(i+4)+",5)='"+itbl[i].PatSex+"';"+
	    "xlSheet.cells("+(i+4)+",6)='"+itbl[i].PatAge+"';"+
	    "xlSheet.cells("+(i+4)+",7)='"+itbl[i].HouseHoldName+"';"+
	    "xlSheet.cells("+(i+4)+",8)='"+itbl[i].RegDate+"';"+
	    "xlSheet.cells("+(i+4)+",9)='"+itbl[i].Birth+"';"+
	    "xlSheet.cells("+(i+4)+",10)='"+itbl[i].VistDate+"';"+
	    "xlSheet.cells("+(i+4)+",11)='"+itbl[i].DateDel+"';"+
	    "xlSheet.cells("+(i+4)+",12)='"+itbl[i].DateSendMed+"';"+
	    "xlSheet.cells("+(i+4)+",13)='"+itbl[i].Tel+"';"+
	    "xlSheet.cells("+(i+4)+",14)='"+itbl[i].Add+"';"+
	    "xlSheet.cells("+(i+4)+",15)='"+itbl[i].Come+"';";
 	 }
    
    var row1=3,row2=itbl.length+3,c1=1,c2=15;
	Str=Str+"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;"+
	"xlSheet.Columns.AutoFit;"+
	"xlApp.Visible=true;"+
	"xlApp=null;"+
	"xlBook=null;"+
	"xlSheet=null;"+
    "return 1;}());";
    //以上为拼接Excel打印代码为字符串
    CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行打印程序 
	return; 
}

///死亡登记
function DeathRegist()
{
	var rowObj=$('#deathreglist').datagrid('getSelected');
	if(rowObj==null)
	{
		$.messager.alert("提示","请选择一条记录！");
		return false;
	}
	$('#DeathWin').window({
		iconCls:'icon-w-edit',
		title:$g('死亡登记'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:false,
		width:720,
		height:340
	});
			
	$('#DeathWin').window('open');
	initWinInfo(rowObj)     ///加载面板基本信息
}
///窗口信息查询
function initWinInfo(rowObj)
{
	$("#WinNumber").val(rowObj.DeathNum);					///编号
	if(rowObj.RegDate==""){
		$HUI.datebox("#WinRegDate").setValue(formatDate(0));	///登记日期
	}else{
		$HUI.datebox("#WinRegDate").setValue(rowObj.RegDate);	///登记日期
	}
	$("#WinPatNo").val(rowObj.PatRegNo);					///登记号
	$("#WinName").val(rowObj.PatName);						///姓名
	$("#WinPatSex").val(rowObj.PatSex);						///性别
	$HUI.datebox("#WinBirthDate").setValue(rowObj.Birth);	///出生日期
	$HUI.datebox("#WinDeathDate").setValue(rowObj.VistDate); ///死亡日期
	$HUI.datebox("#WinSendDate").setValue(rowObj.DateDel);  ///送预防科日期
	$HUI.datebox("#WinSendMedDate").setValue(rowObj.DateSendMed);  ///送病历室日期
	$("#WinPatAge").val(rowObj.PatAge);						///实足年龄
	$("#WinTel").val(rowObj.Tel);							///电话
	$("#WinAdd").val(rowObj.Add);							///住址
	$HUI.combobox("#Winsource").setValue(rowObj.Come);		///来源
	$("#WinHomeName").val(rowObj.HouseHoldName);			///户主姓名
	$("#WinFundis").val(rowObj.FundLetDis);					///根本致死疾病
			
	
}
///获取参数
function getSearParam()
{
	var stDate=$HUI.datebox("#stDate").getValue();   		///开始日期
	var edDate=$HUI.datebox("#endDate").getValue();	 		///结束日期
	var PatRegNo=$("#PatRegNo").val();				 		///登记号
	var PatName=$("#PatName").val();				 		///姓名
	var Location=$HUI.combobox("#Location").getText();		///位置
	return stDate +"^"+ edDate +"^"+ PatRegNo +"^"+ PatName +"^"+ Location+"^"+LgHospID; //hxy 2020-06-03 LgHospID
}

///保存患者基本信息
function SavePatInfo()
{
	var rowObj=$('#deathreglist').datagrid('getSelected');
	var PatientID=rowObj.PatientID;									/// 患者ID
	var DeathPatNum=$("#WinNumber").val();							/// 死亡患者编号
	var DelPreSecDate=$HUI.datebox("#WinSendDate").getValue();		/// 送预防科日期
	var DelMedRecDate=$HUI.datebox("#WinSendMedDate").getValue();	/// 送病历室日期
	var FundLetDis=$("#WinFundis").val();							/// 根本致死疾病
	var HouHolderName=$("#WinHomeName").val();						/// 户主姓名
	var Params=PatientID +"^"+ DeathPatNum +"^"+ DelPreSecDate +"^"+ DelMedRecDate +"^"+ FundLetDis +"^"+ HouHolderName +"^"+ LgUserID;
	runClassMethod("web.DHCEMDeathRegQuery","SaveDeathInfo",{'Params':Params},function(data){
			if(data==0)
			{
				$("#DeathWin").window('close');
				commonQuery();
			}
			
		},'',false)
}
///窗口导出
function exportList()
{
	var data=$("#deathreglist").datagrid('getChecked');
	
	if(data.length==0){
		$.messager.alert("提示","没有数据导出！");
		return;
	}
	
	expExcel(data);
	$("#DeathWin").window('close');
}

function CloseWindow(express){
	$(express).window('close');	
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })




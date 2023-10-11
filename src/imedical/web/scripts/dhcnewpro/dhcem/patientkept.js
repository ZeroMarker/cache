///Creator:qqa
///CreatDate:2017-01-01
///留观病人
$(function (){   

	initParams();  
	
	initCombobox();
	
	initDateBox();
	
	initTable();
    
	initMethod();
	
	flashTable(1);   //初始化默认查询  
})

function initCombobox(){
	$HUI.combobox("#obsLoc",{
		url:LINK_CSP+"?ClassName=web.DHCEMKeptPatient&MethodName=GetObsLoc&CurLoc="+LocId,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    },
	    onLoadSuccess:function(data){
		   
			$HUI.combobox("#obsLoc").setValue(data[0].value);   
		}
	})
}

///全局参数
function initParams(){
	excelData=[];  //导出数据
	DateFormat = "";   //日期格式
	runClassMethod("web.DHCEMCommonUtil","DateFormat",{},  //hxy 2017-03-07 日期格式走配置
	function(data){
		DateFormat = data;
	});	
}	

function initDateBox(){
	$HUI.datebox("#startDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}
	
function initTable(){

    var columns= [[
		{field: 'Num',title: '序号',width:50},
		{field: 'Date',title: '日期',width:100}, 
		{field: 'Time',title: '时间',width:80},
		{field: 'Department',title: '号别',width:100},
		{field: 'Sex',title: '性别',width:50},
		{field: 'Age',title: '年龄',width:50},
		{field: 'BedNum',title: '床号',width:50},
		{field: 'Name',title: '姓名',width:100},
		{field: 'MRDiagnos',title: '诊断',width:100},
		{field: 'CurregNo',title: '登记号',width:100},
		{field: 'IPBKRowID',title: '转入院',width:60, formatter:function(value,row,index){
				var ret="";
				if(row.IPBKRowID){
					row.InHospWardDesc?ret="是":"";
				}
				return ret;
			}
		},
		{field: 'InHospWardDesc',title: '转入病区',width:100},
		{field: 'ObsDoc',title: '入观用户',width:100},
		{field: 'GoDate',title: '离院日期',width:100},
		{field: 'GoTime',title: '离院时间',width:80},
		{field: 'DisDoc',title: '离院用户',width:100},
		{field: 'LGTime',title: '留观时间',width:100},
		{field: 'OrdAction',title: '联系电话',width:100},
		{field: 'PatLocDesc',title: '科室',width:100},
		{field: 'Where',title: '病人去向',width:80},
		{field: 'Notes',title: '备注',width:100},
		{field: 'Apache',title: 'Apache评分',width:100}
		]];
	
	$HUI.datagrid('#keptPatTable',{
		url:'dhcapp.broker.csp?ClassName=web.DHCEMKeptPatient&MethodName=ListObservationPatient',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:60,  
		pageList:[30,60,90], 
		loadMsg: $g('正在加载信息...'),
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:$g('留观登记查询'), //hxy 2018-10-19 st
		toolbar:'#toolbar',
		iconCls:'icon-paper',
		headerCls:'panel-header-gray', //ed
		queryParams:{
			startDate:$HUI.datebox("#startDate").getValue(),
	        endDate:$HUI.datebox("#endDate").getValue(),
	        Loc:$HUI.combobox('#obsLoc').getValue()
		},
		onDblClickRow:function(index,row){
		
		},
		onLoadSuccess:function(data){
			excelData = data.rows;
		}
    })
	
}

///绑定方法
function initMethod(){
	$('#searchBtn').on('click',flashTable);

	$('#exportBtn').on('click',expExcelAjax);
	
	$('#patName').bind('keypress',function(event){
        if(event.keyCode == "13") {
            flashTable()
        }
    });	
	
}

///导出	
function expExcelAjax(){

 	if(excelData.length){
		expExcelNew(excelData);	
	}else{
		$.messager.alert("提示","没有数据导出！");	
	}
	
}
	
function expExcel(itbl)
{		
		runClassMethod("web.UDHCJFCOMMON","getpath",{'itmjs':'','itmjsex':''},function(jsonString){
			TemplatePath = jsonString;
		},'',false)
	
		//TemplatePath=TemplatePath+"DHCEM_PatKeptObs.xlsx"; //cy

 	 	xlsExcel = new ActiveXObject("Excel.Application");
 	 	xlsBook = xlsExcel.Workbooks.Add() 
    	xlsSheet = xlsBook.ActiveSheet; 
    	xlsExcel.Visible = true;  
    	
    	xlsExcel.Range(xlsSheet.Cells(1,1),xlsSheet.Cells(1,20)).MergeCells = true;
    	xlsExcel.Range(xlsSheet.Cells(2,1),xlsSheet.Cells(2,20)).MergeCells = true;
    	xlsSheet.cells(1,1).Font.Bold = true;
    	xlsSheet.cells(2,1).Font.Bold = true;
    	xlsSheet.cells(1,1).Font.Size =24;
    	xlsSheet.cells(1,1).HorizontalAlignment = -4108;
    	xlsSheet.cells(2,1).HorizontalAlignment = -4108;
    	for(i=1;i<21;i++){
	    	if(i==1) xlsSheet.cells(1,i).ColumnWidth=5;
	    	if(i!=1) xlsSheet.cells(1,i).ColumnWidth=10;	
	    }
    	runClassMethod("web.DHCEMRegister","gethHospitalName",{'locId':LocId},function(HospName){
			xlsSheet.cells(1,1) = "  "+HospName;     //QQA  2016-10-16   
		},'text',false)
		var exportLimitPress=$HUI.combobox('#obsLoc').getText()+":"+$HUI.datebox("#startDate").getValue()+"至"+$HUI.datebox("#endDate").getValue();
  	  	xlsSheet.cells(2,1)="急诊登记"+"("+exportLimitPress+")";
    	xlsSheet.cells(3,1)="序号";
		xlsSheet.cells(3,2)="日期";
	   	xlsSheet.cells(3,3)="时间";
	    xlsSheet.cells(3,4)="登记号";
	    xlsSheet.cells(3,5)="姓名";
	    xlsSheet.cells(3,6)="性别";
	    xlsSheet.cells(3,7)="年龄";
	    xlsSheet.cells(3,8)="科室";
		xlsSheet.cells(3,9)="床号";
	    xlsSheet.cells(3,10)="诊断";
	    xlsSheet.cells(3,11)="离院日期";
	    xlsSheet.cells(3,12)="离院时间";
	    xlsSheet.cells(3,13)="留观时间";
		xlsSheet.cells(3,14)="联系电话";
		xlsSheet.cells(3,15)="科室";
		xlsSheet.cells(3,16)="号别";
		xlsSheet.cells(3,17)="病人去向";
		xlsSheet.cells(3,18)="入观用户";
		xlsSheet.cells(3,19)="离院用户";
		xlsSheet.cells(3,20)="Apache评分";
   
    if (itbl.length==0) {alert("没有选中数据！"); return}	
    for (var i=0; i<itbl.length; i++) {
	    xlsSheet.cells(i+4,1)=i+1;
		xlsSheet.cells(i+4,2)="'"+itbl[i].Date;
	    xlsSheet.cells(i+4,3)=itbl[i].Time;
	    xlsSheet.cells(i+4,4)="'"+itbl[i].CurregNo;
	    xlsSheet.cells(i+4,5)=itbl[i].Name;
	    xlsSheet.cells(i+4,6)=itbl[i].Sex;
	    xlsSheet.cells(i+4,7)=itbl[i].Age;
	    xlsSheet.cells(i+4,8)=itbl[i].PatLocDesc;
	    xlsSheet.cells(i+4,9)=itbl[i].BedNum;                   //床号
	    xlsSheet.cells(i+4,10)=itbl[i].MRDiagnos; 
	    xlsSheet.cells(i+4,11)="'"+itbl[i].GoDate;
	    xlsSheet.cells(i+4,12)=itbl[i].GoTime;   
	    xlsSheet.cells(i+4,13)=itbl[i].LGTime;  
	    xlsSheet.cells(i+4,14)="'"+itbl[i].OrdAction;  
	    xlsSheet.cells(i+4,15)=itbl[i].PatLocDesc;  
	    xlsSheet.cells(i+4,16)=itbl[i].Department;  	     
	    xlsSheet.cells(i+4,17)=itbl[i].Where; 
	    xlsSheet.cells(i+4,18)=itbl[i].ObsDoc; 
	    xlsSheet.cells(i+4,19)=itbl[i].DisDoc; 
	    xlsSheet.cells(i+4,20)=itbl[i].Apache;  
 	 }
	gridlist(xlsSheet,3,itbl.length+3,1,20)
	xlsBook.SaveAs("D:\\留观病人统计.xlsx");
	$.messager.alert("提示","文件成功导出,D:\\留观病人统计.xls.注意如果D盘中含有该文件，不会覆盖！");
	xlsExcel=null;
	xlsBook.Close(savechanges=false);
	xlsSheet=null;
}



function expExcelNew(itbl)
{		
	runClassMethod("web.UDHCJFCOMMON","getpath",{'itmjs':'','itmjsex':''},function(jsonString){
		TemplatePath = jsonString;
	},'',false)

	var Str = "(function test(x){"+
	"xlsExcel = new ActiveXObject('Excel.Application');"+
	"xlsBook = xlsExcel.Workbooks.Add();"+
	"xlsSheet = xlsBook.ActiveSheet;"+
	"xlsExcel.Visible = true;"+
	"xlsExcel.Range(xlsSheet.Cells(1,1),xlsSheet.Cells(1,19)).MergeCells = true;"+
	"xlsExcel.Range(xlsSheet.Cells(2,1),xlsSheet.Cells(2,19)).MergeCells = true;"+
	"xlsSheet.cells(2).NumberFormatLocal='@';"+
	"xlsSheet.cells(4).NumberFormatLocal='@';"+
	"xlsSheet.cells(11).NumberFormatLocal='@';"+
	"xlsSheet.cells(14).NumberFormatLocal='@';"+
	"xlsSheet.cells(1,1).Font.Bold = true;"+
	"xlsSheet.cells(2,1).Font.Bold = true;"+
	"xlsSheet.cells(1,1).Font.Size =24;"+
	"xlsSheet.cells(1,1).HorizontalAlignment = -4108;"+
	"xlsSheet.cells(2,1).HorizontalAlignment = -4108;";
	for(i=1;i<21;i++){
		if(i==1) Str=Str+"xlsSheet.cells(1,"+i+").ColumnWidth=5;";
		if(i!=1) Str=Str+"xlsSheet.cells(1,"+i+").ColumnWidth=10;";	
	}
	runClassMethod("web.DHCEMRegister","gethHospitalName",{'locId':LocId},function(HospName){
		Str=Str+"xlsSheet.cells(1,1) = '"+HospName+"';";     
	},'text',false)
	var exportLimitPress=$HUI.combobox('#obsLoc').getText()+":"+$HUI.datebox("#startDate").getValue()+"至"+$HUI.datebox("#endDate").getValue();

	Str=Str+"xlsSheet.cells(2,1)='急诊登记("+exportLimitPress+")';"+
	"xlsSheet.cells(3,1)='序号';"+
	"xlsSheet.cells(3,2)='日期';"+
	"xlsSheet.cells(3,3)='时间';"+
	"xlsSheet.cells(3,4)='登记号';"+
	"xlsSheet.cells(3,5)='姓名';"+
	"xlsSheet.cells(3,6)='性别';"+
	"xlsSheet.cells(3,7)='年龄';"+
	"xlsSheet.cells(3,8)='科室';"+
	"xlsSheet.cells(3,9)='床号';"+
	"xlsSheet.cells(3,10)='诊断';"+
	"xlsSheet.cells(3,11)='离院日期';"+
	"xlsSheet.cells(3,12)='离院时间';"+
	"xlsSheet.cells(3,13)='留观时间';"+
	"xlsSheet.cells(3,14)='联系电话';"+
	//"xlsSheet.cells(3,15)='科室';"+
	"xlsSheet.cells(3,15)='号别';"+
	"xlsSheet.cells(3,16)='病人去向';"+
	"xlsSheet.cells(3,17)='入观用户';"+
	"xlsSheet.cells(3,18)='离院用户';"+
	"xlsSheet.cells(3,19)='Apache评分';";
   
    if (itbl.length==0) {
	    $.messager.alert("提示","没有选中数据！"); 
	    return
	}

    for (var i=0; i<itbl.length; i++) {
	    Str=Str+
		"xlsSheet.cells("+(i+4)+",1)='"+(i+1)+"';"+
		"xlsSheet.cells("+(i+4)+",2)='"+itbl[i].Date+"';"+
	    "xlsSheet.cells("+(i+4)+",3)='"+itbl[i].Time+"';"+
	    "xlsSheet.cells("+(i+4)+",4)='"+itbl[i].CurregNo+"';"+
	    "xlsSheet.cells("+(i+4)+",5)='"+itbl[i].Name+"';"+
	    "xlsSheet.cells("+(i+4)+",6)='"+itbl[i].Sex+"';"+
	    "xlsSheet.cells("+(i+4)+",7)='"+itbl[i].Age+"';"+
	    "xlsSheet.cells("+(i+4)+",8)='"+itbl[i].PatLocDesc+"';"+
	    "xlsSheet.cells("+(i+4)+",9)='"+itbl[i].BedNum+"';"+                   //床号 
	    "xlsSheet.cells("+(i+4)+",10).WrapText=true;"+ 
	    "xlsSheet.cells("+(i+4)+",10)='"+formatHtmlToValue(itbl[i].MRDiagnos)+"';"+ 
	    "xlsSheet.cells("+(i+4)+",11)='"+itbl[i].GoDate+"';"+
	    "xlsSheet.cells("+(i+4)+",12)='"+itbl[i].GoTime+"';"+   
	    "xlsSheet.cells("+(i+4)+",13)='"+itbl[i].LGTime+"';"+  
	    "xlsSheet.cells("+(i+4)+",14)='"+itbl[i].OrdAction+"';"+ 
	    //"xlsSheet.cells("+(i+4)+",15)='"+itbl[i].PatLocDesc+"';"+  
	    "xlsSheet.cells("+(i+4)+",15)='"+itbl[i].Department+"';"+  	     
	    "xlsSheet.cells("+(i+4)+",16)='"+itbl[i].Where+"';"+ 
	    "xlsSheet.cells("+(i+4)+",17)='"+itbl[i].ObsDoc+"';"+ 
	    "xlsSheet.cells("+(i+4)+",18)='"+itbl[i].DisDoc+"';"+ 
	    "xlsSheet.cells("+(i+4)+",19)='"+itbl[i].Apache+"';";
 	}
	
	var row1=3,row2=itbl.length+3,c1=1,c2=19;
	Str=Str+"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"xlsSheet.Range(xlsSheet.Cells("+row1+","+c1+"),xlsSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;";
	
	Str=Str+"xlsSheet.Columns.AutoFit;"; 
	Str=Str+"xlsBook.SaveAs('留观病人统计.xlsx');"+
	"xlsExcel.Visible=true;"+
	"xlsExcel=null;"+
	"xlsBook=null;"+
	"xlsSheet=null;"+
	"return 1;}());";
	
	
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行打印程序 
	return;
	//$.messager.alert("提示","文件成功导出,D:\\留观病人统计.xls.注意如果D盘中含有该文件，不会覆盖！");
	
}


//刷新表格
function flashTable(){
	
	var initFlag=arguments[0];
	var obsLocID="";
	if(initFlag==1) obsLocID=GetObsLocID();
	if(initFlag!=1) obsLocID=$HUI.combobox('#obsLoc').getValue();
	var patName=$("#patName").val();
	var transInHosp=$HUI.checkbox("#transInHospCheckBox").getValue()?"Y":"";
	var otherParams=patName+"^"+transInHosp;
	$HUI.datagrid('#keptPatTable').load({
		startDate:$HUI.datebox("#startDate").getValue(),
        endDate:$HUI.datebox("#endDate").getValue(),
        Loc:obsLocID,
        otherParams:otherParams
	})
	return;
}

function GetObsLocID(){
	var ObsLocID="";
	var ObsLocID = $HUI.combobox('#obsLoc').getValue()
	if(ObsLocID==""||ObsLocID==undefined){
		runClassMethod("web.DHCEMKeptPatient","GetObsLoc",{"CurLoc":LocId},  //hxy 2017-03-07 日期格式走配置
		function(data){
			ObsLocID = data[0].value;
		},"json",false);		
	}
	return ObsLocID;
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

function myFormatDate(date){
	if(date.indexOf("/")){
		dateArr = date.split("/");
		return dateArr[2]+"-"+dateArr[1]+"-"+dateArr[0];
	}else{
		return date;	
	}
}


function formatHtmlToValue(text){
	text = text.replace(new RegExp('&nbsp;',"g"),' '); //text.replaceAll("&nbsp;"," ");
	text = text.replace(new RegExp('&nbsp',"g"),' '); //text.replaceAll("&nbsp"," ");
	return text;
}
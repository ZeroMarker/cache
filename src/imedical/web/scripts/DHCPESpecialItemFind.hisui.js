//名称	DHCPESpecialItemFind.hisui.js
//功能	体检特殊项目查询
//创建	2019.06.21
//创建人  xy

$(function(){
			
	InitCombobox();
	
	InitSpecialItemFindGrid();  
     
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
    
	  
	$("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        }); 

    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
     
    //导出
     $("#BExport").click(function() {	
		BExportNew_click();		
        });
    
})

//清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue');
	$(".hisui-combobox").combobox('setValue',"");
	$(".hisui-combogrid").combogrid('setValue',"");
	$("#RegNo,#Name,#UserNo").val("");
	BFind_click();	
}


function BExportNew_click(){
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEExportCommon.xls';
	
	var ExportName="DHCPESpecial"
	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+ //固定
     	"var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
     	"var xlSheet = xlBook.ActiveSheet;"
 
	var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo","",ExportName);
	var Row=1;
	var ret="";
	while (Info!="") {
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		for (i=1;i<DataLength;i++) {
			if(ret=="") {	
				ret="xlSheet.Cells("+Row+","+i+").Value='"+DataArr[i]+"';";
			} else {
				ret=ret+"xlSheet.Cells("+Row+","+i+").Value='"+DataArr[i]+"';";
			}
		}
		
		var Sort=DataArr[0];
		if (Sort=="") break;
		Row=Row+1;
		var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",Sort,ExportName);
	
	}
	var Str=Str+ret+
	    "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells("+Row+","+(DataLength-1)+")).Borders.LineStyle='1';"+
     	"xlApp.Visible = true;"+
        "xlApp.UserControl = true;"+
      	"xlBook.Close(savechanges=true);"+
        "xlApp.Quit();"+
        "xlApp=null;"+
        "xlSheet=null;"+
        "return 1;}());";
	//alert(Str)
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
	return ;
}


function BExport_click()
{
	if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEExportCommon.xls';
	var ExportName="DHCPESpecial"
	
	xlApp= new ActiveXObject("Excel.Application"); //固定
	xlApp.UserControl = true;
    xlApp.visible = true; //显示
	xlBook= xlApp.Workbooks.Add(Templatefilepath); //固定
	xlsheet= xlBook.WorkSheets("Sheet1"); //Excel下标的名称
	
	var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo","",ExportName);
	var Row=1;
	while (Info!="")
	{
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		for (i=1;i<DataLength;i++)
		{
			xlsheet.cells(Row,i).value=DataArr[i];
		}
		var Sort=DataArr[0];
		if (Sort=="") break;
		Row=Row+1;
		var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",Sort,ExportName);
		
	}
	
	xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
	}else{
		BExportNew_click()	
	}

}

//查询
function BFind_click(){
	
	var RegNo=$("#RegNo").val();
	if(RegNo!="") {
		var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
		$("#RegNo").val(RegNo)
		}


	$("#SpecialItemFindGrid").datagrid('load',{
			ClassName:"web.DHCPE.FetchReport",
			QueryName:"SearchSpecialItem",
			StartDate:$("#BeginDate").datebox('getValue'),
		    EndDate:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			UserNo:$("#UserNo").val(),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			Status:$("#Status").combobox('getValue'),
			StationID:$("#StationDesc").combobox('getValue'),
			Item:$("#ArcimDesc").combogrid('getValue'),
			
		});	
}


//完成
function CompleteItem(rowIndex)
{
	var row=$("#SpecialItemFindGrid").datagrid("getRows")
	OIIDStr=row[rowIndex].TOIID;
	var OEID=OIIDStr.split("^")[0];
	UpdateComplete(OEID,"1");
}
//取消完成
function UnCompleteItem(rowIndex)
{
	var row=$("#SpecialItemFindGrid").datagrid("getRows")
	OIIDStr=row[rowIndex].TOIID;
	var OEID=OIIDStr.split("^")[0];
	UpdateComplete(OEID,"0");
}

function UpdateComplete(OEID,Type)
{
	
    var Date=tkMakeServerCall("web.DHCPE.FetchReport","GetCompleteDate",OEID);
	var ret=tkMakeServerCall("web.DHCPE.FetchReport","UpdateComplete",OEID+"^"+Date,Type);
	//alert(ret)
	if (ret!=""){
		 $.messager.alert("提示",ret,"info");
		return false;
	}
	BFind_click();
}

//报告
function ReportItem(rowIndex)
{	
	var row=$("#SpecialItemFindGrid").datagrid("getRows")
	OIIDStr=row[rowIndex].TOIID;
	var OEID=OIIDStr.split("^")[0];
	UpdateReport(OEID,"1");
}
//取消报告
function UnReportItem(rowIndex)
{
	var row=$("#SpecialItemFindGrid").datagrid("getRows")
	OIIDStr=row[rowIndex].TOIID;
	var OEID=OIIDStr.split("^")[0];
	UpdateReport(OEID,"0");
}

function UpdateReport(OEID,Type)
{	
	var Date=tkMakeServerCall("web.DHCPE.FetchReport","GetReportDate",OEID);	
	var ret=tkMakeServerCall("web.DHCPE.FetchReport","UpdateReport",OEID+"^"+Date,Type);
	if (ret!=""){
		 $.messager.alert("提示",ret,"info");
		return false;
	}
	BFind_click();
}



function InitSpecialItemFindGrid(){
	
		$HUI.datagrid("#SpecialItemFindGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.FetchReport",
			QueryName:"SearchSpecialItem",

		},
		frozenColumns:[[
		
			{field:'Complete',title:'完成操作',width:80,
				formatter: function(value,rowData,rowIndex) {
					var UserName = rowData.UserName;
					var OIIDStr = rowData.TOIID;
					if (OIIDStr != "") {
						if (OIIDStr.split("^")[1] == "3") {
							return "<span style='color:red;'>谢绝检查</span>";
						} else if (UserName != "") {
							return "<a href='#' class='grid-td-text' onclick=UnCompleteItem("+rowIndex+"\)>取消完成</a>";
						} else {
							return "<a href='#' class='grid-td-text' onclick=CompleteItem("+rowIndex+"\)>完成</a>";
						}
					}
				}
			},
			{field:'Report',title:'报告操作',width:80,
				formatter:function(value,rowData,rowIndex){
				
				if(session['LOGON.GROUPDESC'].indexOf("超级")!="-1") {
					var OIIDStr=rowData.TOIID;
					var ReportDate = rowData.TReportDate;
					
					if(OIIDStr != ""){
						//var OEID=OIIDStr.split("^")[0];
						//var flag=tkMakeServerCall("web.DHCPE.FetchReport","IsExistReport",OEID);
						if (OIIDStr.split("^")[1] == "3") {
							return "<span style='color:red;'>谢绝检查</span>";
						} else if (ReportDate != ""){
							return "<a href='#' class='grid-td-text' onclick=UnReportItem("+rowIndex+"\)>取消报告</a>";
						} else {
							return "<a href='#'  class='grid-td-text' onclick=ReportItem("+rowIndex+"\)>报告</a>";
						}
					}
				    
				}
			}},
			{field:'TItem',width:120,title:'项目'},
			{field:'TRegNo',width:100,title:'登记号'},
			{field:'TName',width:100,title:'姓名'},
			{field:'THPNo',width:100,title:'体检号'}
			
		]],
		columns:[[
			{field:'TOIID',title:'TOIID',hidden: true},
			{field:'Feestatus',title:'Feestatus',hidden: true},
			{field:'TGroup',width:150,title:'团体名称'},
			{field:'TTel',width:120,title:'电话'},
			{field:'TArrivedDate',width:100,title:'到达时间'},
			{field:'TCheckDate',width:100,title:'完成日期'},
			{field:'TReportDate',width:100,title:'报告日期'},
			{field:'TVIPLevel',width:80,title:'VIP等级'},
			{field:'TReCheck',width:60,title:'复查'},
			{field:'TPosition',width:80,title:'当前诊室'},
			{field:'TAge',width:100,title:'出生日期'},
			{field:'PIADMPIBIDRSEX',width:60,title:'性别'},
			{field:'PACCardDesc',width:100,title:'证件类型'},
			{field:'CardID',width:170,title:'证件号'},
			{field:'UserName',width:100,title:'操作人'},
			
			
		]]
			
	})	
}


function InitCombobox(){
	
	
	//VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
	
	
	//状态
	var StatusObj = $HUI.combobox("#Status",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
            //{id:'0',text:'预约'},
            {id:'1',text:'未完成'},
            {id:'3',text:'谢绝检查'},
            {id:'6',text:'已完成'},
           
        ]

	});	
	//项目
	var ArcimDescObj = $HUI.combogrid("#ArcimDesc",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.FetchReport&QueryName=GetSpecialItem",
		mode:'remote',
		delay:200,
		idField:'ItemID',
		textField:'ItemDesc',
		onBeforeLoad:function(param){
			
			var STId=$("#StationDesc").combobox('getValue');
			param.StationID = STId;
		},
		onShowPanel:function()
		{
			$('#ArcimDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
			 {field:'ItemID',title:'ID',width:80},
			{field:'ItemDesc',title:'医嘱名称',width:200},	
		]]
		});
		
	//站点
	var StationObj = $HUI.combobox("#StationDesc",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onChange:function(newValue, oldValue)
		{
			var ItemID = $("#ArcimDesc").combogrid("getValue");
			var Flag=tkMakeServerCall("web.DHCPE.HISUICommon","GetStationFlag",newValue,ItemID);
			if (Flag==0) {
			    $("#ArcimDesc").combogrid('setValue',"");
			}
			
		}
		})	
}

//����	DHCPESpecialItemFind.hisui.js
//����	���������Ŀ��ѯ
//����	2019.06.21
//������  xy

$(function(){
			
	InitCombobox();
	
	InitSpecialItemFindGrid();  
     
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
    
	  
	$("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        }); 

    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
     
    //����
     $("#BExport").click(function() {	
		BExportNew_click();		
        });
    
})

//����
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
		"var xlApp = new ActiveXObject('Excel.Application');"+ //�̶�
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
	//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
	CmdShell.notReturn = 1;   //�����޽�����ã�����������
	var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
	return ;
}


function BExport_click()
{
	if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEExportCommon.xls';
	var ExportName="DHCPESpecial"
	
	xlApp= new ActiveXObject("Excel.Application"); //�̶�
	xlApp.UserControl = true;
    xlApp.visible = true; //��ʾ
	xlBook= xlApp.Workbooks.Add(Templatefilepath); //�̶�
	xlsheet= xlBook.WorkSheets("Sheet1"); //Excel�±������
	
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

//��ѯ
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


//���
function CompleteItem(rowIndex)
{
	var row=$("#SpecialItemFindGrid").datagrid("getRows")
	OIIDStr=row[rowIndex].TOIID;
	var OEID=OIIDStr.split("^")[0];
	UpdateComplete(OEID,"1");
}
//ȡ�����
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
		 $.messager.alert("��ʾ",ret,"info");
		return false;
	}
	BFind_click();
}

//����
function ReportItem(rowIndex)
{	
	var row=$("#SpecialItemFindGrid").datagrid("getRows")
	OIIDStr=row[rowIndex].TOIID;
	var OEID=OIIDStr.split("^")[0];
	UpdateReport(OEID,"1");
}
//ȡ������
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
		 $.messager.alert("��ʾ",ret,"info");
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
		
			{field:'Complete',title:'��ɲ���',width:80,
				formatter: function(value,rowData,rowIndex) {
					var UserName = rowData.UserName;
					var OIIDStr = rowData.TOIID;
					if (OIIDStr != "") {
						if (OIIDStr.split("^")[1] == "3") {
							return "<span style='color:red;'>л�����</span>";
						} else if (UserName != "") {
							return "<a href='#' class='grid-td-text' onclick=UnCompleteItem("+rowIndex+"\)>ȡ�����</a>";
						} else {
							return "<a href='#' class='grid-td-text' onclick=CompleteItem("+rowIndex+"\)>���</a>";
						}
					}
				}
			},
			{field:'Report',title:'�������',width:80,
				formatter:function(value,rowData,rowIndex){
				
				if(session['LOGON.GROUPDESC'].indexOf("����")!="-1") {
					var OIIDStr=rowData.TOIID;
					var ReportDate = rowData.TReportDate;
					
					if(OIIDStr != ""){
						//var OEID=OIIDStr.split("^")[0];
						//var flag=tkMakeServerCall("web.DHCPE.FetchReport","IsExistReport",OEID);
						if (OIIDStr.split("^")[1] == "3") {
							return "<span style='color:red;'>л�����</span>";
						} else if (ReportDate != ""){
							return "<a href='#' class='grid-td-text' onclick=UnReportItem("+rowIndex+"\)>ȡ������</a>";
						} else {
							return "<a href='#'  class='grid-td-text' onclick=ReportItem("+rowIndex+"\)>����</a>";
						}
					}
				    
				}
			}},
			{field:'TItem',width:120,title:'��Ŀ'},
			{field:'TRegNo',width:100,title:'�ǼǺ�'},
			{field:'TName',width:100,title:'����'},
			{field:'THPNo',width:100,title:'����'}
			
		]],
		columns:[[
			{field:'TOIID',title:'TOIID',hidden: true},
			{field:'Feestatus',title:'Feestatus',hidden: true},
			{field:'TGroup',width:150,title:'��������'},
			{field:'TTel',width:120,title:'�绰'},
			{field:'TArrivedDate',width:100,title:'����ʱ��'},
			{field:'TCheckDate',width:100,title:'�������'},
			{field:'TReportDate',width:100,title:'��������'},
			{field:'TVIPLevel',width:80,title:'VIP�ȼ�'},
			{field:'TReCheck',width:60,title:'����'},
			{field:'TPosition',width:80,title:'��ǰ����'},
			{field:'TAge',width:100,title:'��������'},
			{field:'PIADMPIBIDRSEX',width:60,title:'�Ա�'},
			{field:'PACCardDesc',width:100,title:'֤������'},
			{field:'CardID',width:170,title:'֤����'},
			{field:'UserName',width:100,title:'������'},
			
			
		]]
			
	})	
}


function InitCombobox(){
	
	
	//VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
	
	
	//״̬
	var StatusObj = $HUI.combobox("#Status",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
            //{id:'0',text:'ԤԼ'},
            {id:'1',text:'δ���'},
            {id:'3',text:'л�����'},
            {id:'6',text:'�����'},
           
        ]

	});	
	//��Ŀ
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
			{field:'ItemDesc',title:'ҽ������',width:200},	
		]]
		});
		
	//վ��
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

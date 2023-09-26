
var reg=/^[0-9]+.?[0-9]*$/; 
var logUserId=session['LOGON.USERID'];
$(function(){
	$HUI.datebox("#DateFrom",{
	})
	$HUI.datebox("#DateTo",{
	})
	LoadMaterialData();
	$("#btnSearch").click(function(){
        $HUI.datagrid("#MaterialData").load();
    }); 
   $("#btnExport").click(function(){
        ExportData();
    }); 
});
var lastselctrowindex="";
function LoadMaterialData()
{
	var materialobj=$("#MaterialData").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
        iconCls:'icon-paper',
        bodyCls:'panel-body-gray',
        rownumbers: true,
        pagination: true,
        pageSize: 100,
        pageList: [100, 200, 500],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANOPMaterialList",
            QueryName:"MaterialList"
        },
        onBeforeLoad: function(param) {
	        param.stdate=$("#DateFrom").datebox('getValue');;
	        param.enddate=$("#DateTo").datebox('getValue');
	        param.showDetail=$("#IsShowDetail").checkbox('getValue')?"Y":"N";
        },
        columns:[
            [
            //opaId,room,ordno,Id,tcssdr,cssdpack,tnumber
               {field: "room", title: "����", width: 60, sortable: true },
               {field: "ordno", title: "̨��", width: 35, sortable: true },
               {field: "opaId", title: "opaId", width: 40, sortable: true },
               {field: "patName", title: "����", width: 50, sortable: true },
               {field: "regNo", title: "�ǼǺ�", width: 80, sortable: true },
               {field: "opName", title: "����", width: 180, sortable: true },
               {field: "tcssdr", title: "tcssdr", hidden: true },
               {field: "Id", title: "Id", hidden: true },
               {field: "cssdpack", title: "���ϰ�", width: 160, sortable: true },
               {field: "tnumber", title: "����", width: 60, sortable: true}
               
            ]
        ],
        onClickRow: function(rowIndex, rowData) {
       }
        
       
    });

}
	function GetFilePath()
	{
		var path=$.m({
        ClassName:"web.DHCClinicCom",
        MethodName:"GetPath"
    },false);
    return path;
	}

function ExportData()
{
		    var name,fileName,path,operStat,printTitle;
	    var xlgendercel,xlsBook,xlsSheet,titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
	    var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
	    path=GetFilePath();
	    fileName=path+"DHCANOPControlledDrug.xlsx";
	    
	    //fileName=path+"DHCBPDetection.xlsx";
	    xlgendercel = new ActiveXObject("Excel.Application");
	    xlsBook = xlgendercel.Workbooks.Add(fileName);
	    xlsSheet = xlsBook.ActiveSheet;

	    row=0;
	    var operlistdata=$("#MaterialData").datagrid('getData');
	    var count =operlistdata.total;
	    for(var i=0;i<count;i++)
	    {
		    var record=operlistdata.rows[i];
			row=row+1;
		    var ordno=record.ordno;
			var comOpRoom=record.room;
			var opaId=record.opaId; 
			var cssdpack=record.cssdpack; 
			var tnumber=record.tnumber;
			
			xlsSheet.cells(1,1)="����";
			xlsSheet.cells(2,1)="������";
			xlsSheet.cells(2,2)="̨��";
			xlsSheet.cells(2,3)="�����Ű�Id";
			xlsSheet.cells(2,4)="���ϰ�";
			xlsSheet.cells(2,5)="����";
			xlsSheet.cells(3+(row-1),1)=comOpRoom;
			xlsSheet.cells(3+(row-1),2)=ordno;
			xlsSheet.cells(3+(row-1),3)=opaId;
			xlsSheet.cells(3+(row-1),4)=cssdpack;
			xlsSheet.cells(3+(row-1),5)=tnumber;	
		}
		LeftHeader = " ",CenterHeader = " ",RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = "";
		titleRows = 0,titleCols = 0,LeftHeader = " ",CenterHeader = " ",
		RightHeader = " ",LeftFooter = "",CenterFooter = "",RightFooter = " &N - &P ";
		//xlgendercel.Visible = true;
		var savefileName="d:\\";
			var d = new Date();
			savefileName+=d.getYear()+"-"+(d.getMonth()+ 1)+"-"+d.getDate();
			savefileName+=" "+d.getHours()+","+d.getMinutes()+","+d.getSeconds();
			savefileName+=".xlsx"
			xlsSheet.SaveAs(savefileName);	
		alert("�뵽D�̲���!")
		xlsSheet = null;
		xlsBook.Close(savechanges=false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;

}


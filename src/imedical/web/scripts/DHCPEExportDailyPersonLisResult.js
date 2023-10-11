/// DHCPEExportDailyPersonLisResult.js

$(function(){
			
	Initdate();
	InitPersonStatisticGrid();  
     
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
	  
    

        
   
      
    //��������
	$("#BExport").click(function() {	
		BExport_click();		
        });
        
        
    //��������
	$("#BImport").click(function() {	
		BImport_click();		
        });    
  
       
      
})


function BImport_click(){
	
	var lnk="DHCPEImportDailyPersonLisResultInfo.csp"
	$HUI.window("#ImportGWin", {
        title: "��������Ϣ",
        iconCls: "icon-w-import",
        collapsible: false,
        minimizable: false,
        maximizable: true,
        resizable: true,
        closable: true,
        modal: true,
        width: 1200,
        height: 700,
        content: '<iframe src="' + PEURLAddToken(lnk)+ '" width="100%" height="100%" frameborder="0"></iframe>'
    }); 
	
	
	//alert("δ��")
	//return
	
	
	
	}


function BExport_click()
{
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEExportDailyPersonLisResult.xlsx';
	
	
	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet= xlBook.ActiveSheet;"
	
	var User=session['LOGON.USERID']
	var NumStr=tkMakeServerCall("web.DHCPE.SecretPE","GetRowNum","ExportDailyPersonLisResult")
	var Num=NumStr.split("^")
	var Rows=Num.length
	     var ret=""
		for (var i=1;i<=Rows;i++){
			//alert(i)
			var Datas=tkMakeServerCall("web.DHCPE.SecretPE","ExportStationWorkInfo",i,"ExportDailyPersonLisResult")
            //alert(Datas)
			var DayData=Datas.split("^");
			var n=i+1
		
			for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
				var m=iDayLoop+1
				//alert(DayData[iDayLoop])
				ret=ret+"xlSheet.Cells("+n+","+m+").Value='"+DayData[iDayLoop]+"';"
			}

		}
	var k=parseInt(Rows)+1;	
	//alert(Str)
	var Str=Str+ret+
		   "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells("+k+",9)).Borders.LineStyle='1';"+
         	"xlApp.Visible = true;"+
           // "xlApp.UserControl = true;"+
          	//"xlBook.Close(savechanges=true);"+
           // "xlApp.Quit();"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
            //alert(Str)
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
       CmdShell.notReturn = 1;   //�����޽�����ã�����������
       //alert(Str)
		var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
		return ;

	
	}


function BExport_clickOld()
{
	
	
	
		var obj;
		
		/*
		obj=document.getElementById("prnpath");
		if (obj && ""!=obj.value) {
			var prnpath=obj.value;
			var Templatefilepath=prnpath+'DHCPEStationWorkStatistic.xls';
		      //var Templatefilepath='D:\\DHCPEStationOrderList.xls';
		}else{
			alert("��Чģ��·��");
			return;
		}
		*/
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
		var Templatefilepath=prnpath+'DHCPEExportDailyPersonLisResult.xlsx';
		xlApp = new ActiveXObject("Excel.Application"); 
		xlApp.UserControl = true;
    	xlApp.visible = true; //��ʾ 
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  
		xlsheet = xlBook.WorkSheets("Sheet1");  
		
		/*
		obj=document.getElementById('GetRowNum');
		 if (obj) {var encmeth=obj.value; } else {var encmeth=''; };
		 var NumStr=cspRunServerMethod(encmeth);
		 
		 */
		 var NumStr=tkMakeServerCall("web.DHCPE.SecretPE","GetRowNum","ExportDailyPersonLisResult");
		 alert(NumStr+"NumStr")
		 var Num=NumStr.split("^")
		k=2
		for (j=0;j<Num.length;j++)
		{  
		    /*
			var Ins=document.getElementById('GetStationWorkInfoBox');
		    	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
		    	
		    	var DataStr=cspRunServerMethod(encmeth,Num[j]);
		    	*/
		    	
		    	var DataStr=tkMakeServerCall("web.DHCPE.SecretPE","ExportStationWorkInfo",Num[j],"ExportDailyPersonLisResult");
		    	
		    	//alert(DataStr)
		    	if (""==DataStr) { return false; }
// TRegNo_"^"_PatName_"^"_GDesc_"^"_ARCIMDesc_"^"_Status_"^"_OSTATDesc_"^"_ADMPEDateBegin_"^"_ADMPEDateEnd_"^"_FactPrice_"^"_ARCIMPrice

		     	var Data=DataStr.split("^")
		     	xlsheet.cells(k+j,1)=Data[0]
		     	xlsheet.cells(k+j,2)=Data[1] 
			    xlsheet.cells(k+j,3)=Data[2] 
			    xlsheet.cells(k+j,4)=Data[3] 
			    xlsheet.cells(k+j,5)=Data[4] 
			    xlsheet.cells(k+j,6)=Data[5] 
			    xlsheet.cells(k+j,7)=Data[6] 
			    xlsheet.cells(k+j,8)=Data[7] 
			    //xlsheet.cells(k+j,9)=Data[8] 
			    
			xlsheet.Range( xlsheet.Cells(k+j,1),xlsheet.Cells(k+j,8)).Borders.LineStyle   = 1
			   
		} 
	   /*
   		var SaveDir="d:\\���ҹ�����ͳ��.xls";
   		xlsheet.SaveAs(SaveDir);
   		xlApp.Visible = true;
   		xlApp.UserControl = true;  
		*/
		xlBook.Close(savechanges = true);
		xlApp.Quit();
		xlApp = null;
		xlsheet = null;
                                

                                //ֱ�ӵ���
                                xlApp.Visible = true;
                                xlApp.UserControl = true;
                                
		
   	
	
	} 



//��ѯ
function BFind_click(){

	$("#PersonStatisticGrid").datagrid('load',{
			ClassName:"web.DHCPE.SecretPE",
			QueryName:"ExportDailyPersonLisResult",
			PEBeginDate:$("#BeginDate").datebox('getValue'),
			PEEndDate :$("#EndDate").datebox('getValue'),
			NameIn :$("#Name").val()
			});
}


function InitPersonStatisticGrid(){
	$HUI.datagrid("#PersonStatisticGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 1000,
		pageList : [20,100,200,1000],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.SecretPE",
			QueryName:"ExportDailyPersonLisResult",

		},
		
		
		//	set Data=$lb(PatName,SecretDate,InPAADM,InOrdItemID,OutPAADM,ARCItemID,OutOrdItemID,LisResultStr)

		columns:[[
			{field:'PatName',width:100,title:'����'},
			{field:'SecretDate',width:100,title:'����'},
			{field:'InPAADM',title:'Ժ�ھ���id'},
			
			
			{field:'InOrdItemID',width:150,title:'Ժ��ҽ��id'},
			{field:'OutPAADM',width:90,title:'Ժ�����id'},
			{field:'ARCItemID',width:100,title:'ҽ����id'},
			{field:'OutOrdItemID',width:180,title:'Ժ��ҽ��id'},
			{field:'LisResultStr',width:150,title:'��������',},
					
			
			
			
		]],
			
	});
}






//����Ĭ��ʱ��
function Initdate()
{
	var today = getDefStDate(0);
	var day = getDefStDate(0);
	$("#BeginDate").datebox('setValue', today);
	$("#EndDate").datebox('setValue', day);
	$("#ARRIVED").checkbox('setValue',true);
}

//����	DHCPENoResultItems.hisui.js
//����	δ�ش������Ŀ��ѯ
//����	2019.06.10
//������  xy

$(function(){
			
	InitCombobox();
	
	InitNoResultItemDataGrid();  
     
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
          
    //����
	$("#BExport").click(function() {	
		BExport_click();		
        });
    	
	$('#ArrivedFlag').checkbox({
		onCheckChange:function(e,vaule){
			SetButtonName(vaule);
			
			}
			
	});     
})


function SetButtonName(vaule)
{
	if(vaule==true)
	{
		document.getElementById('tDateFrom').innerHTML="���￪ʼ����";	
		document.getElementById('tDateTo').innerHTML="�����������";
	}else{
		document.getElementById('tDateFrom').innerHTML="�ձ�ʼ����";	
		document.getElementById('tDateTo').innerHTML="�ձ��������";
	}
}
//����
function BClear_click()
{
	$("#DateFrom,#DateTo").datebox('setValue',"")
	$("#RecLoc").combogrid('setValue',"")
	$("#ArrivedFlag").checkbox('setValue',"")
	BFind_click();
}

//����
function BExportNew_click()
{
	
			var DateFromTo=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetDateFromTo");
			var QueryTime=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetQueryTime");
			if(QueryTime=="")
			{
				$.messager.alert('��ʾ','�����²�ѯ',"info");
				return; 
			}
		var RowsLen=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetRowLength");  
		if(RowsLen==0){	
			$.messager.alert('��ʾ','�˴β�ѯ���Ϊ��',"info");	
	   		return;
		}
		
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
		var Templatefilepath=prnpath+'DHCPENoResultItems.xlsx';
		

	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"+
     
         "xlSheet.Cells(1,1).Value='��ѯʱ���:"+DateFromTo+"';"+
         "xlSheet.Cells(2,1).Value='��ӡʱ��:"+QueryTime+"';"+
         "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(1,4)).mergecells=true;"+   //�ϲ���Ԫ��
		"xlSheet.Range(xlSheet.Cells(2,1),xlSheet.Cells(2,4)).mergecells=true;"    //�ϲ���Ԫ��
         
        var ret=""
		var k=2
		for(var i=1;i<=RowsLen;i++)
		{  
			var DataStr=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetRowData",i); 
			var tempcol=DataStr.split("^");
			k=k+1;
			//xlsheet.Rows(k+1).insert(); 
			if((tempcol[1]==""))
			{    
			    
			     if(ret==""){
				    ret="xlSheet.Cells("+k+",1).Value='"+tempcol[0]+"';"+     //д��������
					 "xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+",4)).mergecells=true;"    //�ϲ���Ԫ��
					  k=k+1;
					  
					 ret=ret+"xlSheet.Cells("+k+",1).Value='����';"+
				  	 "xlSheet.Cells("+k+",2).Value='�ǼǺ�';"
				  	 
				  	var ArrivedFlag=$('#ArrivedFlag').checkbox('getValue');
				if(ArrivedFlag){
					ret=ret+"xlSheet.Cells("+k+",3).Value='��������';"
					}
				else {
					ret=ret+"xlSheet.Cells("+k+",3).Value='�ձ�����';"
					}
					
				ret=ret+"xlSheet.Cells("+k+",4).Value='��Ŀ';"+
				"xlSheet.Columns(2).NumberFormatLocal='@';"+	//���õǼǺ�Ϊ�ı��� 
				"xlSheet.Columns(3).NumberFormatLocal='@';"	
				
			     }else{
				     ret=ret+"xlSheet.Cells("+k+",1).Value='"+tempcol[0]+"';"+     //д��������
					 "xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+",4)).mergecells=true;"   //�ϲ���Ԫ��
					  k=k+1;
					 ret=ret+ "xlSheet.Cells("+k+",1).Value='����';"+
				  	 "xlSheet.Cells("+k+",2).Value='�ǼǺ�';"
				  	   	var ArrivedFlag=$('#ArrivedFlag').checkbox('getValue');
					if(ArrivedFlag){
						ret=ret+"xlSheet.Cells("+k+",3).Value='��������';"
					}
					else {
						ret=ret+"xlSheet.Cells("+k+",3).Value='�ձ�����';"
					}
					ret=ret+"xlSheet.Cells("+k+",4).Value='��Ŀ';"+
					"xlSheet.Columns(2).NumberFormatLocal='@';"+	//���õǼǺ�Ϊ�ı��� 
					"xlSheet.Columns(3).NumberFormatLocal='@';"	
			     }
			    
			
			}
			else
			{ 
				if(ret==""){
					ret="xlSheet.Cells("+k+",1).Value='"+tempcol[0]+"';"+
				  	"xlSheet.Cells("+k+",2).Value='"+tempcol[1]+"';"+
				  	"xlSheet.Cells("+k+",3).Value='"+tempcol[2]+"';"+
				  	"xlSheet.Cells("+k+",4).Value='"+tempcol[3]+"';"
					}else{
						ret=ret+"xlSheet.Cells("+k+",1).Value='"+tempcol[0]+"';"+
				  		"xlSheet.Cells("+k+",2).Value='"+tempcol[1]+"';"+
				  		"xlSheet.Cells("+k+",3).Value='"+tempcol[2]+"';"+
				  		"xlSheet.Cells("+k+",4).Value='"+tempcol[3]+"';"
					}
			                          
			}  
		}
		var Str=Str+ret+
		   "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells("+k+",4)).Borders.LineStyle='1';"+
         	"xlApp.Visible = true;"+
            "xlApp.UserControl = true;"+
             "xlSheet.PrintOut();"+
          	"xlBook.Close(savechanges=true);"+
            "xlApp.Quit();"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
           // alert(Str)
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
       CmdShell.notReturn = 1;   //�����޽�����ã�����������
		var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
		return ;
}
//����
function BExport_click()
{
	
	if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
		try{
			var DateFromTo=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetDateFromTo");
			var QueryTime=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetQueryTime");
			if(QueryTime=="")
			{
				$.messager.alert('��ʾ','�����²�ѯ',"info");
				return; 
			}
		var RowsLen=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetRowLength");  
		if(RowsLen==0){	
			$.messager.alert('��ʾ','�˴β�ѯ���Ϊ��',"info");	
	   		return;
		}
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
		var Templatefilepath=prnpath+'DHCPENoResultItems.xlsx';
		xlApp = new ActiveXObject("Excel.Application"); 
		xlApp.UserControl = true;
    	xlApp.visible = true; 
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  
		xlsheet = xlBook.WorkSheets("Sheet1"); //Excel�±������
	
  
	
		xlsheet.cells(1,1).value="��ѯʱ���:"+DateFromTo;
		
		xlsheet.cells(2,1).value="��ӡʱ��:"+QueryTime;
		
		var k=2
		for(var i=1;i<=RowsLen;i++)
		{  
			var DataStr=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetRowData",i); 
			var tempcol=DataStr.split("^");
			k=k+1
			xlsheet.Rows(k+1).insert(); 
			if((tempcol[1]==""))
			{   
				xlsheet.cells(k,1)=tempcol[0]; //д��������
				var Range=xlsheet.Cells(k,1);
	        	xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,4)).mergecells=true; //�ϲ���Ԫ��
	        	k=k+1
				xlsheet.Rows(k+1).insert();  
				xlsheet.cells(k,1)="����"
				xlsheet.cells(k,2)="�ǼǺ�" 
				var ArrivedFlag=$('#ArrivedFlag').checkbox('getValue');
				if(ArrivedFlag){xlsheet.cells(k,3)="��������";}
				else {xlsheet.cells(k,3)="�ձ�����"; }
				
				xlsheet.cells(k,4)="��Ŀ" 
				xlsheet.Columns(2).NumberFormatLocal="@";  //���õǼǺ�Ϊ�ı��� 
				xlsheet.Columns(3).NumberFormatLocal="@";   
			}
			else
			{
				xlsheet.cells(k,1)=tempcol[0]
				xlsheet.cells(k,2)=tempcol[1]
				xlsheet.cells(k,3)=tempcol[2]
				xlsheet.cells(k,4)=tempcol[3]
			                          
			}  
		}
		xlBook.Close(savechanges = true);
		xlApp.Quit();
		xlApp = null;
		xlsheet = null;
	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}
	}else{
		
		BExportNew_click()
	}
}

//��ѯ
function BFind_click()
{	
	var ArrivedFlag=$("#ArrivedFlag").checkbox('getValue');
	if(ArrivedFlag){
		var columns =[[
			{field:'Name',width:'300',title:'����'},
			{field:'RegNo',width:'300',title:'�ǼǺ�'},
			{field:'ARCIMDesc',width:'600',title:'��Ŀ'},
			{field:'Date',width:'300',title:'��������'},
						 
		]];
	}else{
		var columns =[[
			{field:'Name',width:'300',title:'����'},
			{field:'RegNo',width:'300',title:'�ǼǺ�'},
			{field:'ARCIMDesc',width:'600',title:'��Ŀ'},
			{field:'TReceivedDate',width:'300',title:'�ձ�����'},
						 
		]];
	}


	$HUI.datagrid("#NoResultItemGrid",{
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
			ClassName:"web.DHCPE.Report.NoResultItems",
			QueryName:"NoResultItems",
			DateFrom:$("#DateFrom").datebox('getValue'),
		    DateTo:$("#DateTo").datebox('getValue'),
			ArrivedFlag:$HUI.checkbox('#ArrivedFlag').getValue() ? "on" : "",
			RecLocID:$("#RecLoc").combogrid('getValue'),  
			CurLocID:session['LOGON.CTLOCID'] 

		},
		columns:columns,
			
	})
}


var columns =[[
			{field:'Name',width:'300',title:'����'},
			{field:'RegNo',width:'300',title:'�ǼǺ�'},
			{field:'ARCIMDesc',width:'600',title:'��Ŀ'},
			{field:'TReceivedDate',width:'300',title:'�ձ�����'},
						 
		]];

function InitNoResultItemDataGrid()
{
	$HUI.datagrid("#NoResultItemGrid",{
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
			ClassName:"web.DHCPE.Report.NoResultItems",
			QueryName:"NoResultItems",
			DateFrom:$("#DateFrom").datebox('getValue'),
		    DateTo:$("#DateTo").datebox('getValue'),
			ArrivedFlag:"",
			RecLocID:"",   
			CurLocID:session['LOGON.CTLOCID'] 

		},
		columns:columns,
			
	})
}



function InitCombobox()
{
		//���տ���
		var LocObj = $HUI.combogrid("#RecLoc",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=Querytest",
		mode:'remote',
		delay:200,
		idField:'CTLOCID',
		textField:'Desc',
		onBeforeLoad:function(param){
			param.ctlocdesc = param.q;
			param.hospId = session['LOGON.HOSPID'];
		},
		
		columns:[[
			{field:'CTLOCID',hidden:true},
			{field:'CTLOCCODE',title:'���ұ���',width:100},
			{field:'Desc',title:'��������',width:200}
			
			
			
		]]
	});
}
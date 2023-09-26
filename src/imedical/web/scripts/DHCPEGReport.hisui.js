
//����	DHCPEGReport.hisui.js
//����	���屨��	
//����	2019.04.24
//������  xy

$(function(){
	InitCombobox();
	 
	InitGReportQueryTabDataGrid();
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
     
     //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
    //��ӡ����
	$("#BPrint").click(function() {	
		BPrint_click();		
        });
   
	 //��ӡԤ��
	$("#BPrintView").click(function() {
		BPrintView_click();
        });

   //����������  
	$("#BExportGroupResult").click(function() {	
		BExportGroupResult_click();		
        });
        
     //���������쳣ֵ
	$("#BExportGroupAbnormity").click(function() {	
		//BExportGroupAbnormity_click();	
        BExportGroupAbnormityNew_click();		
        });
   
        
})

 //����
function BClear_click()
{
	
	$("#DateFrom").datebox('setValue',"");
	$("#DateTo").datebox('setValue',"");
	$("#StationID").combobox('setValue',"");
	$("#GDesc").combogrid('setValue',"");
	$("#GADM_DR").val("");
	InitCombobox();
	BFind_click();
}
 //��ӡ����
function BPrint_click()
{
	var iGADMDR=$('#GADM_DR').val();
	var Depart=$("#Depart").combogrid("getValue");

	if(iGADMDR=="") {
		$.messager.alert("��ʾ","����ѡ�����ӡ���������","info");
		return false;
		}

  	
	var fileName="DHCPETeamReport.raq&GADMDR="+iGADMDR+"&Depart="+Depart;
	DHCCPM_RQPrint(fileName);
	
	var iUserUpdateDR=session['LOGON.USERID'];
  	var iStatus="P";
  	var Instring=$.trim(iGADMDR)
			+"^"+$.trim(iStatus)
			+"^"+$.trim(iUserUpdateDR)
			;
	
	var flag=tkMakeServerCall("web.DHCPE.Report","SetReportStatusNew",Instring);
	
	return false;
}

//��ӡԤ��
function BPrintView_click()
{
	var iGADMDR=$('#GADM_DR').val();
	if(iGADMDR=="") {
		$.messager.alert("��ʾ","����ѡ���Ԥ�����������","info");
		return false;
		}
		var Depart=$("#Depart").combogrid("getValue");
	var fileName="DHCPETeamReport.raq&GADMDR="+iGADMDR+"&Depart="+Depart;
	DHCCPM_RQPrint(fileName);
	
	return false;
}
//���������쳣ֵ
function BExportGroupAbnormity_click()
{	
	  if ((""==PGADMDR)){
	    $.messager.alert("��ʾ","����ѡ�������������","info");
		return false;
	}
     var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
     var Templatefilepath=prnpath+'DHCPEGroupAbnormity.xls';
 
	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
	var PGADMDR=$('#GADM_DR').val();
	var PGADMName=$('#GADM_DR_Name').val();
	
    var iadms=tkMakeServerCall("web.DHCPE.Report.GroupIllGather","GetIADM",PGADMDR);
    var StationID="";
    var StationID=$("#StationID").combobox('getValue');  
    var patInfo=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMs",iadms,StationID);
	var patArray=patInfo.split("&");
	Array.prototype.name="";
	var array=new Array;  //��Ԫ��Ϊ�������,���ڰ����Ŵ����Ա��Ϣ,ÿ������Ԫ�ض�Ӧһ������
	
	/*����ѭ���ǶԷ��������������ݰ����ŷ����Ŵ���*/
	for(var i=0;i<patArray.length;i++)
	{
		if(i==0)
		{
			var arr=new Array(patArray[0]);
			arr.name=patArray[0].split('$')[0].split('^')[2]; //ָ������name����Ϊ��������
			array.push(arr);
			continue;
		}
		for(var j=0;j<array.length;j++)  
		{
			if(array[j].name==patArray[i].split('$')[0].split('^')[2])  //array�����������д˲���,����Ա��Ϣ��ӵ��˲�����
			{
				array[j].push(patArray[i]);
				break;
			}
			if(j==(array.length-1)) //array���޴˲���,�����
			{
				var arr=new Array(patArray[i]);
				arr.name=patArray[i].split('$')[0].split('^')[2];
				array.push(arr);
			}
		}
	}
	
	var k=1;
	xlsheet.cells(k,1)=PGADMName+"�쳣ֵ����";
	xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).mergecells=true;
	xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).HorizontalAlignment= -4108;
	xlsheet.Rows(k).Font.Name = "����";
	xlsheet.Columns(1).NumberFormatLocal="@";
	/*����ѭ�������ݰ���ʽ������Excel*/
	for(var i=0;i<array.length;i++)
	{
		k+=2;		
		xlsheet.cells(k,1)=array[i].name;
		xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).HorizontalAlignment= -4108;
		xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).mergecells=true;
		xlsheet.Rows(k).Font.Name = "����";
		for(var j=0;j<array[i].length;j++)
		{
			k+=2;
			if(array[i][j].split('$')[0].split('^')[1]==undefined){
				var Name="";
				}
			else{
				var Name=array[i][j].split('$')[0].split('^')[1];
				}

			xlsheet.Cells(k,1)="�ǼǺ�:"+array[i][j].split('$')[0].split('^')[0];  //�ǼǺ�
			//xlsheet.Cells(k,2)="����:"+array[i][j].split('$')[0].split('^')[1];  //����
			xlsheet.Cells(k,2)="����:"+Name;  //����
			xlsheet.Rows(k).Font.Name = "����";
			k+=1
			xlsheet.Cells(k,1)="ҽ������";
			xlsheet.Cells(k,2)="ϸ������";
			xlsheet.Cells(k,5)="�����";
			for(var m=1;m<array[i][j].split('$').length;m++)
			{
				
			
				k+=1;
				
				xlsheet.Cells(k,1)=array[i][j].split('$')[m].split('^')[0];
				xlsheet.Cells(k,2)=array[i][j].split('$')[m].split('^')[1];
				xlsheet.Cells(k,5)=array[i][j].split('$')[m].split('^')[2];
			
			}
		}
	}
	xlsheet.SaveAs("d:\\�����쳣ֵ����.xls");
	
    xlApp.Visible = true;
    xlApp.UserControl = true;
}


function BExportGroupResultNew_click(){
	
	var GADM=$('#GADM_DR').val();
    if ((""==GADM)){
	    $.messager.alert("��ʾ","����ѡ�������������","info");
		return false;
	}
    var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
     var Templatefilepath=prnpath+'DHCPEPrintPositiveStatistic.xls';
     
     var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"
         
       var ret=""  
        var UserID=session['LOGON.USERID'];
	var flag=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","ExportGroupResult",GADM+"^"+UserID);
	if(flag==""){
			$.messager.alert("��ʾ","û�����ݵ���","info");
	 		return false;
	}
 	if (flag!=""){
	 		var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","-2",UserID);
 		ret="xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(1,"+Info+")).mergecells=true;"+
 			"xlSheet.cells(1,1).value='����������';"
 			
	 	 var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","-1",UserID);
 		var Arr=Info.split("$");
 		var ArrLength=Arr.length;
 		
 		if ((ArrLength=="2")&&(Arr[1]=="")){
	 		$.messager.alert("��ʾ","û��ϸ��","info");
	 		return false;
 		}

	    var ret1=""
 		var Merge=0;
 		for (var i=0;i<ArrLength;i++)
 		{
	 		var OneInfo=Arr[i];
	 		var OneArr=OneInfo.split("^");
	 		var Desc=OneArr[0];
	 		var MergeCount=OneArr[1];
	 		var StartCell=Merge+1;
	 		Merge=Merge+(+MergeCount);
	 		ret1=ret1+"xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(2,"+Merge+")).mergecells=true;"+
	 		
	 				"xlSheet.Cells(2,"+StartCell+").value = '"+Desc+"';"
        	
        	
		}
 		var ret2=""
        var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","0",UserID);
 		var Arr=Info.split("^");
 		var ArrLength=Arr.length;
 		for (var i=0;i<ArrLength;i++)
 		{
	 		var OneInfo=Arr[i];
	 		n=i+1
	 		ret2=ret2+"xlSheet.Cells(3,"+n+").value = '"+OneInfo+"';"
	 		
		}
		
		
		var ret3=""
 	
 	var IADMInfo=flag.split("#");
 	var IADMLength=IADMInfo.length;
 	var GName=""
 	
 	for (var i=0;i<IADMLength;i++)
 	{
	 	var PAADM=IADMInfo[i]
	 	var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData",PAADM,UserID);
 		var Arr=Info.split("^");
 		var ArrLength=Arr.length;
 		for (var j=0;j<ArrLength;j++)
 		{
	 		var OneInfo=Arr[j];
	 		var row=4+i;
	 		var col=j+1;
	 		ret2=ret2+"xlSheet.Cells("+row+","+col+").value = '"+OneInfo+"';"	
        	
		}
		
	}
         
 	}
 	// var Str=Str+
	 var Str=Str+ret+ret1+ret2+ret3+
	 
         	"xlApp.Visible = true;"+
            "xlApp.UserControl = true;"+
          	"xlSheet.SaveAs('d:\\����������.xls');"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
                    //alert(Str)
//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
       CmdShell.notReturn = 1;   //�����޽�����ã�����������
		var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
		return ;
	    
	
	
}
//���������� 
function BExportGroupResult_click()
{
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
	var GADM=$('#GADM_DR').val();
    if ((""==GADM)){
	    $.messager.alert("��ʾ","����ѡ�������������","info");
		return false;
	}
    var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
     var Templatefilepath=prnpath+'DHCPEPrintPositiveStatistic.xls';
	
	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
		var UserID=session['LOGON.USERID'];
	var flag=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","ExportGroupResult",GADM+"^"+UserID);
	//alert(flag)
 	if (flag!=""){
	 	var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","-2",UserID);
 		xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,(+Info))).mergecells=true;
 		xlsheet.cells(1,1).value = "����������";
       
        var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","-1",UserID);
 		var Arr=Info.split("$");
 		var ArrLength=Arr.length;
 		
 		if ((ArrLength=="2")&&(Arr[1]=="")){
	 		$.messager.alert("��ʾ","û��ϸ��","info");
	 		return false;
 		}

 		var Merge=0;
 		for (var i=0;i<ArrLength;i++)
 		{
	 		var OneInfo=Arr[i];
	 		var OneArr=OneInfo.split("^");
	 		var Desc=OneArr[0];
	 		var MergeCount=OneArr[1];
	 		var StartCell=Merge+1;
	 		Merge=Merge+(+MergeCount);
	 		xlsheet.Range(xlsheet.Cells(2,StartCell),xlsheet.Cells(2,Merge)).mergecells=true;
        	xlsheet.cells(2,StartCell).value = Desc;
        	
        	
		}
 		
        var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","0",UserID);
 		var Arr=Info.split("^");
 		var ArrLength=Arr.length;
 		for (var i=0;i<ArrLength;i++)
 		{
	 		var OneInfo=Arr[i];
	 		xlsheet.cells(3,i+1).value = OneInfo;
        	
		}
         
 	}
 	var IADMInfo=flag.split("#");
 	var IADMLength=IADMInfo.length;
 	var GName=""
 	
 	for (var i=0;i<IADMLength;i++)
 	{
	 	var PAADM=IADMInfo[i]
	 	var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData",PAADM,UserID);
 		var Arr=Info.split("^");
 		var ArrLength=Arr.length;
 		for (var j=0;j<ArrLength;j++)
 		{
	 		var OneInfo=Arr[j];
	 		xlsheet.cells(4+i,j+1).value = OneInfo;
        	
		}
		
	}

	var UserID=session['LOGON.USERID'];
	var flag=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","ExportGroupResult",GADM+"^"+UserID);
	//alert(flag)
 	if (flag!=""){
	 	var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","-2",UserID);
 		xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,(+Info))).mergecells=true;
 		xlsheet.cells(1,1).value = "����������";
       
        var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","-1",UserID);
 		var Arr=Info.split("$");
 		var ArrLength=Arr.length;
 		
 		if ((ArrLength=="2")&&(Arr[1]=="")){
	 		$.messager.alert("��ʾ","û��ϸ��","info");
	 		return false;
 		}

 		var Merge=0;
 		for (var i=0;i<ArrLength;i++)
 		{
	 		var OneInfo=Arr[i];
	 		var OneArr=OneInfo.split("^");
	 		var Desc=OneArr[0];
	 		var MergeCount=OneArr[1];
	 		var StartCell=Merge+1;
	 		Merge=Merge+(+MergeCount);
	 		xlsheet.Range(xlsheet.Cells(2,StartCell),xlsheet.Cells(2,Merge)).mergecells=true;
        	xlsheet.cells(2,StartCell).value = Desc;
        	
        	
		}
 		
        var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","0",UserID);
 		var Arr=Info.split("^");
 		var ArrLength=Arr.length;
 		for (var i=0;i<ArrLength;i++)
 		{
	 		var OneInfo=Arr[i];
	 		xlsheet.cells(3,i+1).value = OneInfo;
        	
		}
         
 	}
 	var IADMInfo=flag.split("#");
 	var IADMLength=IADMInfo.length;
 	var GName=""
 	
 	for (var i=0;i<IADMLength;i++)
 	{
	 	var PAADM=IADMInfo[i]
	 	var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData",PAADM,UserID);
 		var Arr=Info.split("^");
 		var ArrLength=Arr.length;
 		for (var j=0;j<ArrLength;j++)
 		{
	 		var OneInfo=Arr[j];
	 		xlsheet.cells(4+i,j+1).value = OneInfo;
        	
		}
		
	}
    
	xlsheet.SaveAs("d:\\����������.xls");
    xlApp.Visible = true;
    xlApp.UserControl = true;
	xlsheet=null;
	xlApp=null;
}else{
	BExportGroupResultNew_click();
}
	
	
	
}




function BExportGroupAbnormityNewGoogle_click(){
			var PGADMDR=$('#GADM_DR').val();
	var PGADMName=$('#GADM_DR_Name').val();
	

    if ((""==PGADMDR)){
	    $.messager.alert("��ʾ","����ѡ�������������","info");
		return false;
	}

    var iadms=tkMakeServerCall("web.DHCPE.Report.GroupIllGather","GetIADM",PGADMDR);
    if ( iadms=="" ) {
	    $.messager.alert("��ʾ","���������ܼ���Ա���ݣ�","info");
		return false;
    }
    var StationID="";
    var StationID=$("#StationID").combobox('getValue');
    var UserId=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",iadms,StationID,"");
    if (UserId == "") {
	    $.messager.alert("��ʾ","�޷���ȡ�û����ݣ�","info");
		return false;
    } else if (UserId == "-1") {
	    $.messager.alert("��ʾ","���������쳣������ݣ�","info");
		return false;
    }

	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
     var Templatefilepath=prnpath+'DHCPEGroupAbnormity.xls';
	//var Templatefilepath="http://127.0.0.1/imedical/med/Results/Template/"+'DHCPEGroupAbnormity.xls';
	 
    var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"

    var ret="";
	var MainHeadInfo=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",UserId,StationID,"-1");  // ��ͷ
	var MainHead=MainHeadInfo.split("^");
	var HeadInfo=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",UserId,StationID,"-2");  // ϸ���ͷ
	var Head=HeadInfo.split("^");
	var BaseCount=Head[0].split("$$");
	var Merge=0;
		for(var i=0; i<MainHead.length; i++) {
		 	var OneInfo=MainHead[i];
		 	var OneArr=OneInfo.split("$$");
		 	var Desc=OneArr[0];
		 	var MergeCount=OneArr[1];
		 	var StartCell=Merge+1;
		 	Merge=Merge+(+MergeCount);
		 	if(ret==""){
		 	if ( Merge < +BaseCount[0] || Merge == ((+BaseCount[0]) + (+BaseCount[1])) ){
			 	ret="xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(3,"+Merge+")).mergecells=true;"+
		 		"xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(3,"+Merge+")).HorizontalAlignment= -4108;"
		 	} else {
			 	ret="xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(2,"+Merge+")).mergecells=true;"+
		 		"xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(3,"+Merge+")).HorizontalAlignment= -4108;"
		 	
		 	}
		 	}else{
			 	if ( Merge < +BaseCount[0] || Merge == ((+BaseCount[0]) + (+BaseCount[1])) ){
			 	ret=ret+"xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(3,"+Merge+")).mergecells=true;"+
		 		"xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(3,"+Merge+")).HorizontalAlignment= -4108;"
		 	} else {
			 	ret=ret+"xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(2,"+Merge+")).mergecells=true;"+
		 		"xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(3,"+Merge+")).HorizontalAlignment= -4108;"
		 	
		 	}
			 	
		 	}
		 	
		 	ret=ret+"xlSheet.Cells(2,"+StartCell+").WrapText=true;"+
		 	"xlSheet.Cells(2,"+StartCell+").VerticalAlignment = 2;"+
		 	"xlSheet.Cells(2,"+StartCell+").Font.Bold = true;"+
		 	"xlSheet.Cells(2,"+StartCell+").value = '"+Desc+"';"
		 	
		 
		}
		//alert(ret)
		var ret1=""
		for(var i=1; i<Head.length; i++) {
		 	var OrderDesc=Head[i];
		 	var StartCell=parseInt(BaseCount[0])+i-1;
		 	StartCell=parseInt(StartCell);
		 	
		 	ret1=ret1+"xlSheet.Cells(3,"+StartCell+").WrapText=true;";
		 	if (OrderDesc.length >= 8 && OrderDesc.length < 20){
			 	ret1=ret1+"xlSheet.Cells(3,"+StartCell+").ColumnWidth = 20;"
		 	}
		 	else if (OrderDesc.length > 20 && OrderDesc.length < 35) 
		 	{
			 	ret1=ret1+"xlSheet.Cells(3,"+StartCell+").ColumnWidth = 40;"	
		   }
		 	else if (OrderDesc.length >= 35){
			 	ret1=ret1+"xlSheet.Cells(3,"+StartCell+").ColumnWidth = 60;"
		 	}
		 	else{
			 	ret1=ret1+"xlSheet.Cells(3,"+StartCell+").ColumnWidth = 10;"
		 	
		   }
		  // alert(StartCell+"StartCell")
		     //��ֱ���뷽ʽö��*(1-���ϣ�2-���У�3-���£�4-���˶��룬5-��ɢ����)
		   ret1=ret1+"xlSheet.Cells(3,"+StartCell+").VerticalAlignment = 2;"+
		   "xlSheet.Cells(3,"+StartCell+").Font.Bold = true;"+
		   "xlSheet.Cells(3,"+StartCell+").value ='"+ OrderDesc+"';"		
		 
		}
		var ret2=""
		var ret3=""
		var IADMInfo=iadms.split("^");var StartRow=3;
		for (var i=0; i<IADMInfo.length; i++) {
			var DataInfo=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",UserId,StationID,IADMInfo[i]);  // ����
			if (DataInfo == "") continue;
			StartRow=StartRow+1;
		    var Data=DataInfo.split("^");
		    if (StartRow == 4) {
			    //�ǼǺ�
		    	//xlsheet.Columns(1).WrapText=true;               //����Ϊ�Զ�����*
		    	ret2=ret2+"xlSheet.Columns(1).HorizontalAlignment = 3;" +
		    				"xlSheet.Columns(1).ColumnWidth = 12;"+
		    	"xlSheet.Columns(2).HorizontalAlignment = 3;"+
		    	"xlSheet.Columns(2).ColumnWidth = 12;"+
		    	"xlSheet.Columns(3).HorizontalAlignment = 3;"+
		    	"xlSheet.Columns(3).ColumnWidth = 6;"+
		    	"xlSheet.Columns(4).HorizontalAlignment = 3;"+
		    	"xlSheet.Columns(4).ColumnWidth = 6;"+	
		    	"xlSheet.Columns(3).WrapText=true;;"+	
		    	"xlSheet.Columns(3).ColumnWidth = 50;"+	
		    	"xlSheet.Columns(6).HorizontalAlignment = 3;"+
		    	"xlSheet.Columns(6).ColumnWidth = 15;"+
		    	
		    	//�ܼ����
		    	"xlSheet.Columns("+Data.length+").WrapText=true;"+
		    	"xlSheet.Columns("+Data.length+").ColumnWidth = 200;"+
				"xlSheet.Columns(1).NumberFormatLocal='@';"
		    }
		
		for(var j=0; j<Data.length; j++) {
			 	var IADMData=Data[j];
			 	var StartCell=j+1;
			 	
				if (i == 0) {
					ret3=ret3+"xlSheet.Columns("+StartCell+").NumberFormatLocal='@';"+
    				"xlSheet.Columns("+StartCell+").VerticalAlignment = 2;"
					if ( StartCell > 6 ) {
						ret3=ret3+"xlSheet.Columns("+StartCell+").WrapText=true;"
					}
				}
				
				ret3=ret3+"xlSheet.Cells("+StartRow+","+StartCell+").value ='"+IADMData+"';"
			}
		}
		var k=1;
		
		if(ret!=""){var Str=Str+ret;}
		else {var Str=Str;}
			
		if(ret1!=""){var Str=Str+ret1;}
		else {var Str=Str;}
			
		if(ret2!=""){var Str=Str+ret2;}
		else {var Str=Str;}
		
		if(ret3!=""){var Str=Str+ret3;}
		else {var Str=Str;}
		
		
		var Str=Str+
		"xlSheet.Cells("+k+",1)='"+PGADMName+"�����������ܼ콨��';"+
		"xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+","+Merge+")).mergecells=true;"+
		"xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+","+Merge+")).HorizontalAlignment= -4108;"+
		"xlSheet.Rows("+k+").Font.Name = '����';"+
		"xlSheet.Cells("+k+",1).Font.Size = 17;" +
		"xlSheet.Cells("+k+",1).Font.Bold = true;"+
		"xlSheet.Columns(1).NumberFormatLocal='@';"+
		"xlApp.Visible = true;"+
        "xlApp.UserControl = true;"+
		"xlSheet.SaveAs('d:\\" + PGADMName + "�����������ܼ콨��.xls');"+
       "return 1;}());";
          //alert(Str)
//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
       CmdShell.notReturn = 1;   //�����޽�����ã�����������
		var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ����// 
		return ;
	  
		
	
}
//���������쳣ֵ
function BExportGroupAbnormityNew_click() {
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
	var PGADMDR=$('#GADM_DR').val();
	var PGADMName=$('#GADM_DR_Name').val();
	

    if ((""==PGADMDR)){
	    $.messager.alert("��ʾ","����ѡ�������������","info");
		return false;
	}

    var iadms=tkMakeServerCall("web.DHCPE.Report.GroupIllGather","GetIADM",PGADMDR);
    if ( iadms=="" ) {
	    $.messager.alert("��ʾ","���������ܼ���Ա���ݣ�","info");
		return false;
    }
    var StationID="";
    var StationID=$("#StationID").combobox('getValue');
    var UserId=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",iadms,StationID,"");
    if (UserId == "") {
	    $.messager.alert("��ʾ","�޷���ȡ�û����ݣ�","info");
		return false;
    } else if (UserId == "-1") {
	    $.messager.alert("��ʾ","���������쳣������ݣ�","info");
		return false;
    }

	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEGroupAbnormity.xls';
	//var Templatefilepath="d:\\"+'DHCPEGroupAbnormity.xls';

	try {
		xlApp = new ActiveXObject("Excel.Application");  //�̶�
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
		xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������

	    var MainHeadInfo=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",UserId,StationID,"-1");  // ��ͷ
	    var MainHead=MainHeadInfo.split("^");
		var HeadInfo=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",UserId,StationID,"-2");  // ϸ���ͷ
	    var Head=HeadInfo.split("^");
	    var BaseCount=Head[0].split("$$");
		var Merge=0;
		for(var i=0; i<MainHead.length; i++) {
		 	var OneInfo=MainHead[i];
		 	var OneArr=OneInfo.split("$$");
		 	var Desc=OneArr[0];
		 	var MergeCount=OneArr[1];
		 	var StartCell=Merge+1;
		 	Merge=Merge+(+MergeCount);
		 	if ( Merge < +BaseCount[0] || Merge == ((+BaseCount[0]) + (+BaseCount[1])) ){
		 		xlsheet.Range(xlsheet.Cells(2,StartCell),xlsheet.Cells(3,Merge)).mergecells=true;
				xlsheet.Range(xlsheet.Cells(2,StartCell),xlsheet.Cells(3,Merge)).HorizontalAlignment= -4108;
		 	} else {
		 		xlsheet.Range(xlsheet.Cells(2,StartCell),xlsheet.Cells(2,Merge)).mergecells=true;
				xlsheet.Range(xlsheet.Cells(2,StartCell),xlsheet.Cells(2,Merge)).HorizontalAlignment= -4108;
		 	}
		 	xlsheet.cells(2,StartCell).WrapText=true;
			xlsheet.cells(2,StartCell).VerticalAlignment = 2;		//��ֱ���뷽ʽö��*(1-���ϣ�2-���У�3-���£�4-���˶��룬5-��ɢ����)
		 	xlsheet.cells(2,StartCell).Font.Bold = true;             //����Ϊ����*
	        xlsheet.cells(2,StartCell).value = Desc;
		}

		for(var i=1; i<Head.length; i++) {
		 	var OrderDesc=Head[i];
		 	var StartCell=+BaseCount[0]+i-1;
		 	xlsheet.cells(3,StartCell).WrapText=true;
		 	if (OrderDesc.length >= 8 && OrderDesc.length < 20) xlsheet.cells(3,StartCell).ColumnWidth = 20;			//�����п�
		 	else if (OrderDesc.length > 20 && OrderDesc.length < 35) xlsheet.cells(3,StartCell).ColumnWidth = 40;			//�����п�
		 	else if (OrderDesc.length >= 35)xlsheet.cells(3,StartCell).ColumnWidth = 60;			//�����п�
		 	else xlsheet.cells(3,StartCell).ColumnWidth = 10;			//�����п�
			xlsheet.cells(3,StartCell).VerticalAlignment = 2;		//��ֱ���뷽ʽö��*(1-���ϣ�2-���У�3-���£�4-���˶��룬5-��ɢ����)
		 	xlsheet.cells(3,StartCell).Font.Bold = true;
		 	xlsheet.cells(3,StartCell).value = OrderDesc;
		}

		var IADMInfo=iadms.split("^");var StartRow=3;
		for (var i=0; i<IADMInfo.length; i++) {
			var DataInfo=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",UserId,StationID,IADMInfo[i]);  // ����
			if (DataInfo == "") continue;
			StartRow=StartRow+1;
		    var Data=DataInfo.split("^");
		    if (StartRow == 4) {
			    //�ǼǺ�
		    	//xlsheet.Columns(1).WrapText=true;               //����Ϊ�Զ�����*
		    	xlsheet.Columns(1).HorizontalAlignment = 3;		//ˮƽ���뷽ʽö��* (1-���棬2-����3-���У�4-���ң�5-��� 6-���˶��룬7-���о��У�8-��ɢ����)
		    	xlsheet.Columns(1).ColumnWidth = 12;			//�����п�
		    	
		    	//����
		    	//xlsheet.Columns(2).WrapText=true;               //����Ϊ�Զ�����*
		    	xlsheet.Columns(2).HorizontalAlignment = 3;		//ˮƽ���뷽ʽö��* (1-���棬2-����3-���У�4-���ң�5-��� 6-���˶��룬7-���о��У�8-��ɢ����)
		    	xlsheet.Columns(2).ColumnWidth = 12;			//�����п�
		    	
		    	//�Ա�
		    	//xlsheet.Columns(3).WrapText=true;               //����Ϊ�Զ�����*
		    	xlsheet.Columns(3).HorizontalAlignment = 3;		//ˮƽ���뷽ʽö��* (1-���棬2-����3-���У�4-���ң�5-��� 6-���˶��룬7-���о��У�8-��ɢ����)
		    	xlsheet.Columns(3).ColumnWidth = 6;			//�����п�
		    	
		    	//����
		    	//xlsheet.Columns(4).WrapText=true;               //����Ϊ�Զ�����*
		    	xlsheet.Columns(4).HorizontalAlignment = 3;		//ˮƽ���뷽ʽö��* (1-���棬2-����3-���У�4-���ң�5-��� 6-���˶��룬7-���о��У�8-��ɢ����)
		    	xlsheet.Columns(4).ColumnWidth = 6;			//�����п�
		    	
		    	//��������
		    	xlsheet.Columns(5).WrapText=true;               //����Ϊ�Զ�����*
		    	//xlsheet.Columns(5).HorizontalAlignment = 2;		//ˮƽ���뷽ʽö��* (1-���棬2-����3-���У�4-���ң�5-��� 6-���˶��룬7-���о��У�8-��ɢ����)
		    	xlsheet.Columns(5).ColumnWidth = 50;			//�����п�
		    	
		    	//��ϵ�绰
		    	//xlsheet.Columns(6).WrapText=true;               //����Ϊ�Զ�����*
		    	xlsheet.Columns(6).HorizontalAlignment = 3;		//ˮƽ���뷽ʽö��* (1-���棬2-����3-���У�4-���ң�5-��� 6-���˶��룬7-���о��У�8-��ɢ����)
		    	xlsheet.Columns(6).ColumnWidth = 15;			//�����п�
		    	
		    	//�ܼ����
		    	xlsheet.Columns(Data.length).WrapText=true;               //����Ϊ�Զ�����*
		    	//xlsheet.Columns(Data.length).HorizontalAlignment = 2;		//ˮƽ���뷽ʽö��* (1-���棬2-����3-���У�4-���ң�5-��� 6-���˶��룬7-���о��У�8-��ɢ����)
		    	xlsheet.Columns(Data.length).ColumnWidth = 200;			//�����п�
		    }
    		//xlsheet.Columns(StartCell).RowHeight = 22;				//�����и�
			for(var j=0; j<Data.length; j++) {
			 	var IADMData=Data[j];
			 	var StartCell=j+1;
			 	
				if (i == 0) {
					xlsheet.Columns(StartCell).NumberFormatLocal="@";
    				xlsheet.Columns(StartCell).VerticalAlignment = 2;		//��ֱ���뷽ʽö��*(1-���ϣ�2-���У�3-���£�4-���˶��룬5-��ɢ����)
					if ( StartCell > 6 ) xlsheet.Columns(StartCell).WrapText=true;   //����Ϊ�Զ�����*
				}
				
				xlsheet.cells(StartRow,StartCell).value = IADMData;
			}
		}
		var k=1;
		xlsheet.cells(k,1)=PGADMName+"�����������ܼ콨��";
		xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,Merge)).mergecells=true;
		xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,Merge)).HorizontalAlignment= -4108;
		xlsheet.Rows(k).Font.Name = "����";
		xlsheet.cells(k,1).Font.Size = 17;  //����Ϊ10����*
		xlsheet.cells(k,1).Font.Bold = true;
		xlsheet.Columns(1).NumberFormatLocal="@";

		xlsheet.SaveAs("d:\\" + PGADMName + "�����������ܼ콨��.xls");

	    xlApp.Visible = true;
	    xlApp.UserControl = true;
	} catch(e) {
		xlsheet=null;
		xlApp=null;
		alert(e);
	}
}else{
	BExportGroupAbnormityNewGoogle_click()
	
}
}


function InitCombobox()
{
	
	//����
	var GroupNameObj = $HUI.combogrid("#GDesc",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},
		onChange:function()
		{
			DepartObj.clear();
			
		},
		columns:[[
			{field:'TRowId',title:'����ID',width:80},
			{field:'TGDesc',title:'��������',width:140},
			{field:'TGStatus',title:'״̬',width:100},
			{field:'TAdmDate',title:'����',width:100}			
			
		]]
		});
		
		
		//����
	var DepartObj = $HUI.combogrid("#Depart",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.PreGTeam&QueryName=SearchGDepart",
		mode:'remote',
		delay:200,
		idField:'DepartName',
		textField:'DepartName',
		onBeforeLoad:function(param){
			//alert($("#GDesc").combogrid("getValue"))
			param.GID = $("#GDesc").combogrid("getValue");
			//param.TeamID = "";
			//param.GID = 69;
			param.Depart = param.q;
		},
		onShowPanel:function()
		{
			$('#Depart').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'DepartName',title:'����'}
						
			
		]]
		});
		
	//վ��	
	var StationObj = $HUI.combobox("#StationID",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		});

}

//��ѯ
function BFind_click(){
	
	$("#GReportQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.Report",
			QueryName:"SearchGReportNew",
			DateFrom:$("#DateFrom").datebox('getValue'),
			DateTo:$("#DateTo").datebox('getValue'),
			GID:$("#GDesc").combogrid('getValue')
			});
	
}


function InitGReportQueryTabDataGrid(){
	
	$HUI.datagrid("#GReportQueryTab",{
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
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.Report",
			QueryName:"SearchGReportNew",
			DateFrom:$("#DateFrom").datebox('getValue'),
			DateTo:$("#DateTo").datebox('getValue'),
			GID:$("#GDesc").combogrid('getValue')
				
		},
		columns:[[
		    {field:'RPT_ID',title:'RPT_ID',hidden: true},
		    {field:'GADM_DR',title:'GADM_DR',hidden: true},
			{field:'Grp_Code',width:'150',title:'�������'},
			{field:'Grp_RegNo',width:'150',title:'�ǼǺ�'},
			{field:'Grp_Name',width:'240',title:'��������'},
			{field:'PGADM_StatusDesc',width:'60',title:'״̬'},
			{field:'GADM_Date',width:'120',title:'����'},
			{field:'RPT_Status',title:'����״̬',hidden: true},
			{field:'RPT_PrintDate',width:'150',title:'��ӡ����'},
			{field:'RPT_PrintTime',width:'150',title:'��ӡʱ��'},
			{field:'RPT_PrintUser',width:'100',title:'��ӡ��'},
			{field:'PGBILinkman1',width:'100',title:'��ϵ��'},
			{field:'PGBITel1',width:'120',title:'��ϵ�绰'},			
		]],
		onSelect: function (rowIndex, rowData) {
			$('#GADM_DR').val(rowData.GADM_DR);
			$('#GADM_DR_Name').val(rowData.Grp_Name);

		}
			
	})
		
}


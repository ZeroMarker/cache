//����	DHCPEPreGADM.Find.hisui.js
//����	����ԤԼ��ѯ
//����	2020.11.19
//������  xy

$(function(){
	
			
	InitCombobox();
	
	Initdate();
	
	InitPreGADMFindGrid();  
	
 
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
    //����
	$("#Clear").click(function() {	
		Clear_click();	
        });
        
    //�������
    $("#BAllowToCharge").click(function() {	
		BAllowToCharge_click();	
        });
        
    //��������
    $("#HomeSet").click(function() {	
		HomeSet_click();	
        });
    
    //����
    $("#BCopyTeam").click(function() {	
		BCopyTeam_click();	
        });
    //ԤԼ�޸�
    $("#Update").click(function() {	
		Update_click();	
        });
        
   //��Ŀ�޸�
   $("#BModifyItem").click(function() {	
		BModifyItem_click();	
        });
   
    
	  //��ӡ����
    $("#BPrintBaseInfo").click(function() {	
		BPrintBaseInfo_click();	
		
        });
        
    //��ӡ����
    $("#PrintGroupPerson").click(function() {	
		PrintGroupPerson_Click();	
        });  
       
      //ȡ��ԤԼ
      $("#BCancelPre").click(function() {	
		BCancelPre_click();	
        }); 
      
     //������
     $("#PEFinish").click(function() {	
		PEFinish_click();	
        }); 
      
   	//ȡ�����
   	$("#CancelPE").click(function() {	
		CancelPE();		
        });

	//����ȡ�����
	 $("#UnCancelPE").click(function() {	
		UnCancelPE();		
        });
	
	//����
	$("#UpdatePreAudit").click(function() {	
		UpdatePreAudit();		
        });

	
    //������������嵥
     $("#BPrintGroupItem").click(function() {
			BPrintGroupItem_click();			
        });
	
    iniForm();
})


function iniForm(){

	 //ԤԼ�޸�
	$("#Update").linkbutton('disable');
		
	//ȡ��ԤԼ
	$("#BCancelPre").linkbutton('disable');
	
	//��Ŀ�޸�
	$("#BModifyItem").linkbutton('disable');
	
	var UserDR=session['LOGON.USERID'];
	var LocID=session['LOGON.CTLOCID'];
	/*
	var OPflag=tkMakeServerCall("web.DHCPE.ChargeLimit","GetOPChargeLimitInfo",UserDR); 
	var OPflagOne=OPflag.split("^");
	if(OPflagOne[0]=="0"){
		$("#UpdatePreAudit").linkbutton('disable');
		}
	*/
   var OPflag=tkMakeServerCall("web.DHCPE.CT.ChargeLimit","GetOPChargeLimitInfo",UserDR,LocID);
   var OPflagOne=OPflag.split("^");
   if(OPflagOne[0]=="N"){
		$("#UpdatePreAudit").linkbutton('disable');
	} 


}

//����
function UpdatePreAudit()
{
	var Type="G",ID="";
	var ID = $("#PGADMID").val();
   	if ((""==ID)){
	   	$.messager.alert("��ʾ","��ѡ�������������","info");
		return false;
	}
	var lnk="dhcpepreauditlist.hiui.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
	//websys_lu(lnk,false,'iconCls=icon-w-edit,width=1400,height=750,hisui=true,title=����')
	$HUI.window("#SplitWin", {
        title: "����",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1300,
        height: 650,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });
	return true;
}

//������������嵥
function BPrintGroupItem_click()
{
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
    try{
		var obj;
		
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	    var Templatefilepath=prnpath+'DHCPEGroupPersonItem.xls';
	    var PGADM=$("#PGADMID").val();
	  	if (PGADM=="")  {
		  	$.messager.alert("��ʾ","����ѡ������","info");
	  		return false;
	  	}
		xlApp = new ActiveXObject("Excel.Application");  //�̶�
		xlApp.UserControl = true;
        xlApp.visible = true; 
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
		xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������

	    
	    var locType="";
	    var ExecFlag="";
	   
	    var ReturnStr=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPersonIADM",PGADM,locType,ExecFlag);
	    var IADMStr=ReturnStr.split("%")[1];
	    var ItemStr=ReturnStr.split("%")[0];
	    var String=ItemStr.split("&");
		var Cols=String.length;
		for (j=0;j<Cols;j++)
		  {
		   var ItemColData=String[j].split("^");
		   var Col=ItemColData[0];
		   var DataStr=ItemColData[1];
		 
		   xlsheet.cells(1,+Col).value=DataStr
		   }
		   var IADM=IADMStr.split("^");
		   
	       var IADMRows=IADM.length;
	    
		var row=0;
	    for (k=0;k<IADMRows;k++)
	    {   
	    
			var FeeStr=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPersonItem",IADM[k]);
	     
	        if (FeeStr==0) continue;
	        row=row+1;
	        var Str=FeeStr.split("&");
	
		    var FeeCols=Str.length;
		    for (i=0;i<FeeCols;i++)
		  {
		   var FeeColData=Str[i].split("^");
		   var FeeCol=FeeColData[0];
		   var FeeData=FeeColData[1];
		   xlsheet.cells(row+1,+FeeCol).value=FeeData
		  
		   }

	    }
	   
	    var n=row+2

	     var TotalFeeString=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetItemFeeTotal");
	    var TotalFeeStr=TotalFeeString.split("&");
		var TotalFeeCols=TotalFeeStr.length;
		for (i=0;i<TotalFeeCols;i++)
		  {
		   var TFeeColData=TotalFeeStr[i].split("^");
		  
		   var TFeeCol=TFeeColData[0];
		   var TFeeData=TFeeColData[1];
		   xlsheet.cells(n,+TFeeCol).value=TFeeData}
    	   
	    
		var GroupDesc=$("#GName").val();
		
	 	xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(n,Cols)).Borders.LineStyle=1;	
		xlBook.Close(savechanges = true);
		xlApp.Quit();
		xlApp = null;
		xlsheet = null;
	}
	    
    
	catch(e)
	{
		$.messager.alert("��ʾ","�������󣺴���Ϊ"+e.message,"info");
	  	return false;
	}
}else{
	BPrintGroupItemNew_click();
}
	
}


function BPrintGroupItemNew_click(){
	
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	    var Templatefilepath=prnpath+'DHCPEGroupPersonItem.xls';
		
		var PGADM=$("#PGADMID").val();
	  	if (PGADM=="")  {
		  	$.messager.alert("��ʾ","����ѡ������","info");
	  		return false;
	  	}
	  	var StrNew = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"
         
         
	    var locType="";
	    var ExecFlag="";
	   /* var obj=document.getElementById("NoExceFlag");
	    if ((obj)&&(obj.checked)){
	    	ExecFlag="N";
	    }
	    var obj=document.getElementById("RecLoc");
	    if ((obj)&&(obj.checked)){
	    	locType="RecLoc";
	    }*/
	    
	   
	    var ReturnStr=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPersonIADM",PGADM,locType,ExecFlag);
	    var IADMStr=ReturnStr.split("%")[1];
	
	    var ItemStr=ReturnStr.split("%")[0];
	    var String=ItemStr.split("&");
		var Cols=String.length;
		var ret=""
		for (j=0;j<Cols;j++)
		  {
		   var ItemColData=String[j].split("^");
		   var Col=ItemColData[0];
		   var DataStr=ItemColData[1];
		    if(ret==""){ret="xlSheet.Cells(1,"+Col+").Value='"+DataStr+"';" }
		    else{ret=ret+"xlSheet.Cells(1,"+Col+").Value='"+DataStr+"';"}
		  
		   }
		   
		   var IADM=IADMStr.split("^");
		   
	       var IADMRows=IADM.length;
	    
		var row=0;
	    for (k=0;k<IADMRows;k++)
	    {   
		   var FeeStr=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPersonItem",IADM[k]);
	        if (FeeStr==0) continue;
	        row=row+1;
	        var Str=FeeStr.split("&");
	
		    var FeeCols=Str.length;
		    for (i=0;i<FeeCols;i++)
		  {
		   var FeeColData=Str[i].split("^");
		   var FeeCol=FeeColData[0];
		   var FeeData=FeeColData[1];
		   var rownew=row+1;
		   if(ret==""){ret="xlSheet.Cells("+rownew+","+FeeCol+").Value='"+FeeData+"';" }
		    else{ret=ret+"xlSheet.Cells("+rownew+","+FeeCol+").Value='"+FeeData+"';"}
		  
		   }
		 
    	
	    }
	    
	    
	    var n=row+2;

	    var TotalFeeString=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetItemFeeTotal");
	    var TotalFeeStr=TotalFeeString.split("&");
		var TotalFeeCols=TotalFeeStr.length;
		for (i=0;i<TotalFeeCols;i++)
		  {
		   var TFeeColData=TotalFeeStr[i].split("^");
		   //alert(TFeeColData)
		   var TFeeCol=TFeeColData[0];
		   var TFeeData=TFeeColData[1];
		   
    	    if(ret==""){ret="xlSheet.Cells("+n+","+TFeeCol+").Value='"+TFeeData+"';" }
		    else{ret=ret+"xlSheet.Cells("+n+","+TFeeCol+").Value='"+TFeeData+"';"}
		  }
		var GroupDesc=$("#GName").val();
	    var StrNew=StrNew+ret+
		   "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells("+n+","+Cols+")).Borders.LineStyle='1';"+
         	"xlApp.Visible = true;"+
            "xlApp.UserControl = true;"+
          	"xlBook.Close(savechanges=true);"+
            "xlApp.Quit();"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
           //alert(StrNew)
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
       CmdShell.notReturn = 1;   //�����޽�����ã�����������
		var rtn = CmdShell.EvalJs(StrNew);   //ͨ���м�����д�ӡ���� 
		return ;
	   

}

//ȡ�����
function CancelPE()
{
	
	 var ID = $("#PGADMID").val();
   	if ((""==ID)){
	   	$.messager.alert("��ʾ","��ѡ���ȡ����������","info");
		return false;
	}
	
	$.messager.confirm("ȷ��", "ȷ��Ҫȡ�������", function(r){
		if (r){
				CancelPECommon(ID,"G",0);
				BFind_click();
				$("#PGADMID,#GName,#Status,#CompleteStatus").val("");
		}
	});
}

//����ȡ�����
function UnCancelPE()
{
	
	var PGADM = $("#PGADMID").val();
   	if ((""==PGADM)){
	   	$.messager.alert("��ʾ","��ѡ�������ȡ����������","info");
		return false;
	}
	
	var Status=$("#Status").val();
	if(Status!="ȡ�����"){
		$.messager.alert("��ʾ","����ȡ�����״̬,���ܳ���ȡ�����","info");
		return false;
	}

    $.messager.confirm("ȷ��", "ȷ��Ҫ����ȡ�������", function(r){
		if (r){
				CancelPECommon(PGADM,"G",1);
	 			BFind_click();
	 			$("#PGADMID,#GName,#Status,#CompleteStatus").val("");
		}
	});
	
}

function CancelPECommon(PGADM,Type,DoType)
{
	var LocID=session['LOGON.CTLOCID'];
	var UserID=session['LOGON.USERID'];
	var Ret=tkMakeServerCall("web.DHCPE.CancelPE","CancelPE",PGADM,Type,DoType,UserID,LocID);
	Ret=Ret.split("^");
	$.messager.alert("��ʾ",Ret[1],"info");
		
}

//������
function PEFinish_click()
{
	
	var ID = $("#PGADMID").val();
   	if ((""==ID)){
	   	$.messager.alert("��ʾ","��ѡ�������������壡","info");
		return false;
	}
	
	var iComplete=$("#CompleteStatus").val();
	if(iComplete=="δ���"){var status="������";}
	
	else{var status="ȡ��������";}
	
		$.messager.confirm("ȷ��", "ȷ��Ҫ"+status+"��", function(r){
		if (r){
				FinishPECommon("G",0);
				BFind_click();
				$("#PGADMID,#GName,#Status,#CompleteStatus").val("");
		}
	});
}

function FinishPECommon(Type,DoType)
{	
	
	var Id= $("#PGADMID").val();
	if(Id==""){
		$.messager.alert("��ʾ","δѡ�������������壡","info");
		    return false;
	}
		
	var Status=$("#Status").val();
	if(Status=="CANCELPE"){
			$.messager.alert("��ʾ","��������ȡ����죡","info");
		    return false;
	} 

	var Ret=tkMakeServerCall("web.DHCPE.PreGADM","UpdatePEComplete",Id)	
	$.messager.alert("��ʾ","�����ɹ���","info");		
}


//ȡ��ԤԼ
function BCancelPre_click()
{
	var ID = $("#PGADMID").val();
   	if ((""==ID)){
	   	$.messager.alert("��ʾ","����ѡ������","info");
		return false;
	}
	
	var Type=trim($("#BCancelPre").text());
	var Status="PREREG";
	if (Type=="ȡ��ԤԼ") Status="CANCELPREREG"
	

	 var PGADMStatus=$("#Status").val();

	var Flag=tkMakeServerCall("web.DHCPE.PreGADM","UpdateStatus",ID,Status)
	
	if (Flag!="0")
	{
		$.messager.alert("��ʾ", "��������״̬ʧ��", 'error');
		return;
	}else{
		if (Type=="ȡ��ԤԼ") {$.messager.alert("��ʾ", "ȡ��ԤԼ�ɹ�", 'success');}
		else{$.messager.alert("��ʾ", "ԤԼ�ɹ�", 'success');}
		BFind_click();
		$("#PGADMID,#GName,#Status,#CompleteStatus").val("");

	}

}

//��ӡ����

function PrintGroupPersonNew_Click(){
	
	var HospID=session['LOGON.HOSPID']

	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEPrintGPerson.xls';
	var PGADM = $("#PGADMID").val();
   	if ((""==PGADM)){
	   	$.messager.alert("��ʾ","����ѡ������","info");
		return false;
	}
	
	
    var GName=$("#GName").val();

    var returnval=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPerson",PGADM,"N")
	var str=returnval; 
	//ѭ����
   	var temprow=str.split("^");
   	if(temprow=="")
   	{
	   	 $.messager.alert("��ʾ","��������Ա����Ϊ��","info");
	   	return;
	}

	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"
    var ret="";
	var k=3; 
   	var tmp=0; 
  
   
	for(i=0;i<=(temprow.length-1);i++)
	{  
		var row=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetInfoById",temprow[i],HospID);
		var tempcol=row.split("^");
	    var id=i+1;
		itemrowid=tempcol[7];
		//������rowid�������ϴ���rowid���Ҳ��ǵ�һ��ʱ���м�2
		if((itemrowid != tmp))
		{   
			var count=1;
			k=k+1;
			//xlsheet.Rows(k+1).insert();
			k=k+1;
			//xlsheet.Rows(k+1).insert(); 
			var m=k-1;
			
			if(ret==""){
			 
		     ret="xlSheet.Cells("+m+",1).Value='"+tempcol[8]+"';"+
			 "xlSheet.Range(xlSheet.Cells("+m+",1),xlSheet.Cells("+m+",10)).mergecells=true;"+  //�ϲ���Ԫ��
	         "xlSheet.Cells("+k+",1).Value='���';"+
	         "xlSheet.Cells("+k+",2).Value='�ǼǺ�';"+ 
	         "xlSheet.Cells("+k+",3).Value='����';"+ 
	         "xlSheet.Cells("+k+",4).Value='�Ա�';"+ 
	         "xlSheet.Cells("+k+",5).Value='����';"+
	         "xlSheet.Cells("+k+",6).Value='����';"+ 
	         "xlSheet.Cells("+k+",7).Value='���֤��';"+ 
	         "xlSheet.Cells("+k+",8).Value='�շ�״̬';"+  
	         "xlSheet.Cells("+k+",9).Value='�Էѽ��(Ԫ)';"+ 
	         "xlSheet.Cells("+k+",10).Value='���ѽ��(Ԫ)';"+  
	       
			"xlSheet.Columns(2).NumberFormatLocal='@';"+  //���õǼǺ�Ϊ�ı���
			"xlSheet.Columns(5).NumberFormatLocal='@';"+
			"xlSheet.Columns(7).NumberFormatLocal='@';"+
			"xlSheet.Columns(9).NumberFormatLocal='@';"+
			"xlSheet.Columns(10).NumberFormatLocal='@';"
			}else{
				ret=ret+
				"xlSheet.Cells("+m+",1).Value='"+tempcol[8]+"';"+
			 "xlSheet.Range(xlSheet.Cells("+m+",1),xlSheet.Cells("+m+",10)).mergecells=true;"+  //�ϲ���Ԫ��
	         "xlSheet.Cells("+k+",1).Value='���';"+
	         "xlSheet.Cells("+k+",2).Value='�ǼǺ�';"+ 
	         "xlSheet.Cells("+k+",3).Value='����';"+ 
	         "xlSheet.Cells("+k+",4).Value='�Ա�';"+ 
	         "xlSheet.Cells("+k+",5).Value='����';"+
	         "xlSheet.Cells("+k+",6).Value='����';"+ 
	         "xlSheet.Cells("+k+",7).Value='���֤��';"+ 
	         "xlSheet.Cells("+k+",8).Value='�շ�״̬';"+  
	         "xlSheet.Cells("+k+",9).Value='�Էѽ��(Ԫ)';"+ 
	         "xlSheet.Cells("+k+",10).Value='���ѽ��(Ԫ)';"+  
	       
			"xlSheet.Columns(2).NumberFormatLocal='@';"+  //���õǼǺ�Ϊ�ı���
			"xlSheet.Columns(5).NumberFormatLocal='@';"+
			"xlSheet.Columns(7).NumberFormatLocal='@';"+
			"xlSheet.Columns(9).NumberFormatLocal='@';"+
			"xlSheet.Columns(10).NumberFormatLocal='@';"
			}

		}
		//tempcol[0]=count;
		count=count+1;
		//xlsheet.Rows(k+1).insert();         //����һ��
		//alert(tempcol)
		var n=k+1
		 if(ret==""){ret="xlSheet.Cells("+n+",1).Value='"+tempcol[0]+"';"+
		  "xlSheet.Cells("+n+",2).Value='"+tempcol[1]+"';"+
		  "xlSheet.Cells("+n+",3).Value='"+tempcol[2]+"';"+
		  "xlSheet.Cells("+n+",4).Value='"+tempcol[3]+"';"+
		  "xlSheet.Cells("+n+",5).Value='"+tempcol[4]+"';"+
		  "xlSheet.Cells("+n+",6).Value='"+tempcol[6]+"';"+
		  "xlSheet.Cells("+n+",9).Value='"+tempcol[17]+"';"+
		  "xlSheet.Cells("+n+",10).Value='"+tempcol[16]+"';"+
		   "xlSheet.Cells("+n+",7).Value='"+tempcol[18]+"';"+
		  "xlSheet.Cells("+n+",8).Value='"+tempcol[19]+"';"
		 }else{
			 ret=ret+"xlSheet.Cells("+n+",1).Value='"+tempcol[0]+"';"+
		  "xlSheet.Cells("+n+",2).Value='"+tempcol[1]+"';"+
		  "xlSheet.Cells("+n+",3).Value='"+tempcol[2]+"';"+
		  "xlSheet.Cells("+n+",4).Value='"+tempcol[3]+"';"+
		  "xlSheet.Cells("+n+",5).Value='"+tempcol[4]+"';"+
		  "xlSheet.Cells("+n+",6).Value='"+tempcol[6]+"';"+
		  "xlSheet.Cells("+n+",9).Value='"+tempcol[17]+"';"+
		  "xlSheet.Cells("+n+",10).Value='"+tempcol[16]+"';"+
		   "xlSheet.Cells("+n+",7).Value='"+tempcol[18]+"';"+
		  "xlSheet.Cells("+n+",8).Value='"+tempcol[19]+"';"
		 }
				 
	   tmp=itemrowid;   //��������rowid����һ����ʱ����?�����´�ȡ�õ���rowid�Ƚ�
	   k=k+1;
	  
	}
	
	

	  var HospID=session['LOGON.HOSPID'];
	  var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HospID);
	  var Str=Str+ret+
	  		"xlSheet.Cells(1,1).Value='"+HosName+"';"+
	  		"xlSheet.Cells(2,1).Value='������Ա����';"+
	  		"xlSheet.Cells(3,1).Value='��������:"+GName+"(��"+id+"��)';"+
	  		"xlSheet.Range(xlSheet.Cells(2,1),xlSheet.Cells("+k+",10)).Borders.LineStyle='1';"+
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

function PrintGroupPerson_Click()
{ 
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
    try{
	var obj;
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEPrintGPerson.xls';
	
	var PGADM = $("#PGADMID").val();
   	if ((""==PGADM)){
	   	$.messager.alert("��ʾ","����ѡ������","info");
		return false;
	}
	
	
    var GName=$("#GName").val();
    
	var returnval=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPerson",PGADM,"N")
   	
	var str=returnval; //[0]
	//var num=info[1]      //��ĸ���
	//ѭ����
   	var temprow=str.split("^");
   	if(temprow=="")
   	{
	   	 $.messager.alert("��ʾ","��������Ա����Ϊ��","info");
	   	return;
	}


	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlApp.UserControl = true;
    xlApp.visible = true; //��ʾ
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
	

   
   	k=2; 
   	var tmp=0; 
  	
	for(i=0;i<=(temprow.length-1);i++)
	{  
		var row=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetInfoById",temprow[i]);
	    var row=cspRunServerMethod(encmeth,temprow[i]);
		var tempcol=row.split("^");
	    var id=i+1;
		itemrowid=tempcol[7];
		//������rowid�������ϴ���rowid���Ҳ��ǵ�һ��ʱ���м�2
		if((itemrowid != tmp))
		{   var count=1;
			k=k+1;
			xlsheet.Rows(k+1).insert();
			k=k+1;
			xlsheet.Rows(k+1).insert(); 
			xlsheet.cells(k-1,1)=tempcol[8]; 
			var Range=xlsheet.Cells(k-1,1);
	        xlsheet.Range(xlsheet.Cells(k-1,1),xlsheet.Cells(k-1,10)).mergecells=true; //�ϲ���Ԫ��
			xlsheet.cells(k,1)="���"
			xlsheet.cells(k,2)="�ǼǺ�" 
			xlsheet.cells(k,3)="����" 
			xlsheet.cells(k,4)="�Ա�"
			xlsheet.cells(k,5)="����"
			//xlsheet.cells(k,6)="����״��"
			xlsheet.cells(k,6)="����"
			xlsheet.cells(k,7)="���֤��"
			xlsheet.cells(k,8)="�շ�״̬"
			xlsheet.cells(k,9)="�Էѽ��"
			xlsheet.cells(k,10)="���ѽ��"
			//xlsheet.cells(k,8)="�Żݽ��"
			//xlsheet.cells(k,9)="ʵ�ʽ��"
			//var Range=xlsheet.Cells(k,1)
			//xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,5)).HorizontalAlignment =-4108;//����
			//xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).HorizontalAlignment =-4108;//����
			
			
			xlsheet.Columns(2).NumberFormatLocal="@";  //���õǼǺ�Ϊ�ı��� 
			xlsheet.Columns(5).NumberFormatLocal="@"; 
			xlsheet.Columns(7).NumberFormatLocal="@"; 
			xlsheet.Columns(9).NumberFormatLocal="@"; 
			xlsheet.Columns(10).NumberFormatLocal="@";   

		}
		//tempcol[0]=count;
		count=count+1;
		xlsheet.Rows(k+1).insert();         //����һ��
		//alert(tempcol)
		
			xlsheet.cells(k+1,1).Value=tempcol[0];
			xlsheet.cells(k+1,2).Value=tempcol[1];
			xlsheet.cells(k+1,3).Value=tempcol[2];
			xlsheet.cells(k+1,4).Value=tempcol[3];
			xlsheet.cells(k+1,5).Value=tempcol[4];
			xlsheet.cells(k+1,6).Value=tempcol[6];  
			xlsheet.cells(k+1,9).Value=tempcol[17];  
			xlsheet.cells(k+1,10).Value=tempcol[16];
			xlsheet.cells(k+1,7).Value=tempcol[18];  
			xlsheet.cells(k+1,8).Value=tempcol[19]; 
				 

				 
	   tmp=itemrowid;   //��������rowid����һ����ʱ����?�����´�ȡ�õ���rowid�Ƚ�
	   k=k+1;
	   xlsheet.cells(2,1)="��������:"+GName+"(��"+id+"��)";
	}
///ɾ�����Ŀ���
xlsheet.Rows(k+1).Delete;
///ɾ�����Ŀ���
xlsheet.Rows(k+1).Delete;
///ɾ�����Ŀ���
xlsheet.Rows(k+1).Delete;
///ɾ�����Ŀ���
xlsheet.Rows(k+1).Delete;

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
	
	PrintGroupPersonNew_Click()
}
}





//��ӡ����
function BPrintBaseInfo_click()
{
	var HospID=session['LOGON.HOSPID'];
   	var PGADM = $("#PGADMID").val();
   	if ((""==PGADM)){
	   	$.messager.alert("��ʾ","����ѡ������","info");
		return false;
	}
    var NewHPNo=$("#Code").val();
    var VIPLevel=$("#VIPLevel").combobox("getValue");
     
	var str=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPerson",PGADM,"Y",NewHPNo,VIPLevel)
	var temprow=str.split("^");
	if(temprow=="")
	{
		$.messager.alert("��ʾ","��������Ա����Ϊ��","info");
   		return false ;
	} 
	
	for(i=0;i<=(temprow.length-1);i++)
	{  
		var row=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetInfoById",temprow[i],HospID);
		var tempcol=row.split("^");
    	var Amount=tkMakeServerCall("web.DHCPE.HandlerPreOrds","IGetAmount4Person",temprow[i]); 
		var FactAmount=Amount.split('^')[1]+'Ԫ';
   		//var Info=RegNo+"^"+Name+"  "+FactAmount+"^"+"^"+"^"+"^"+Sex+String.fromCharCode(1)+"^"+Age+"^"+RegNo;
		var Info=tempcol[1]+"^"+tempcol[2]+"  "+FactAmount+"^"+"^"+"^"+"^"+tempcol[3]+String.fromCharCode(1)+"^"+tempcol[4]+"^"+tempcol[1]+"^"+"";
		//alert(Info)
		PrintBarRis(Info);
	}
}


//��Ŀ�޸�
function BModifyItem_click()
{
	
	var iRowId = $("#PGADMID").val();
   	if ((""==iRowId)){
	   	$.messager.alert("��ʾ","����ѡ������","info");
		return false;
	}
	
	
    var iName=$("#GName").val();
    
	var lnk="dhcpepregadm.edit.hisui.csp?"
			+"ParRef="+iRowId
			+"&ParRefName="+iName
			+"&OperType="+"T"
			;
	/*
	var wwidth=1450;
	var wheight=1450;
	var xposition = 0;
	var yposition = 0;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	*/
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=1430,height=750,hisui=true,title=ԤԼ�޸�')	
	return true;		
	
	
}
// ԤԼ�޸�
function Update_click() {
	
	
	var ID = $("#PGADMID").val();
	if (ID=="") {
		 $.messager.alert("��ʾ","����ѡ������","info");
	 	 return false;
	 }

	var iName=$("#GName").val();
	var lnk="dhcpepregadm.edit.hisui.csp?"
			+"ParRef="+ID
			+"&ParRefName="+iName
			+"&OperType="+"E"
			;
	

    //websys_lu(lnk,false,'iconCls=icon-w-edit,width=1430,height=750,hisui=true,title=ԤԼ�޸�')
  $HUI.window("#PreEditWin", {
        title: "ԤԼ�޸�",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1440,
        height: 760,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });
	return true;		
	

}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}

//����
function Clear_click() {
	
	$("#Code,#PersonNum,#PGADMID,#GName,#Status,#CompleteStatus").val("");
	$(".hisui-combobox").combobox('setValue','');
	
	$(".hisui-combogrid").combogrid('setValue','');
	$("#RegDateFrom").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$("#RegDateTo").datebox('setValue',"");

	$("#BCopyTeam,#HomeSet,#PEFinish").linkbutton('enable');
			
    iniForm();

	Initdate();
 
  	$(".hisui-checkbox").checkbox('setValue',false);
	
	BFind_click();
   
}

//����Ĭ��ʱ��
function Initdate()
{
	var today = getDefStDate(0-10);
	$("#BeginDate").datebox('setValue', today);
}

//��ѯ
function BFind_click() {
	
    var iCode=$("#Code").val();
	
	var iGroupID=$("#Name").combogrid('getValue');
	if (($("#Name").combogrid('getValue')==undefined)||($("#Name").combogrid('getValue')=="")){var iGroupID="";} 
	
	var iBeginDate=$("#BeginDate").datebox('getValue');
	
	var iEndDate=$("#EndDate").datebox('getValue');
	
	var iChargedStatus=$("#ChargeStatus").combobox('getValue');
	
	var iRegDateFrom=$("#RegDateFrom").datebox('getValue');
	
	var iRegDateTo=$("#RegDateTo").datebox('getValue');
	
	var iPersonNum=$("#PersonNum").val();
	
	var iContractID=$("#Contract").combogrid('getValue');
	if (($("#Contract").combogrid('getValue')==undefined)||($("#Contract").combogrid('getValue')=="")){var iContractID="";} 
	
	var iStatus=GetStatus();


	var iShowPrintGroup="0";
	var ShowPrintGroup=$("#ShowPrintGroup").checkbox('getValue');
	if(ShowPrintGroup){iShowPrintGroup="1";} 
	else{iShowPrintGroup="0";}	     
	
	$("#PreGADMFindGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreGADM",
			QueryName:"SearchPreGADM",
			Code:iCode,
			PGBID:iGroupID,
			BeginDate:iBeginDate,
			EndDate:iEndDate,
			ChargeStatus:iChargedStatus,
			RegDateFrom:iRegDateFrom,
			RegDateTo:iRegDateTo,
			PersonNum:iPersonNum,
			ContractID:iContractID,
			Status:iStatus,
			ReportGroup:iShowPrintGroup
			})
	 

}


function GetStatus() {
	var iStatus="";
	
	// PREREG ԤԼ
	var PREREG=$("#Status_PREREG").checkbox('getValue');
	if(PREREG){iStatus=iStatus+"^"+"PREREG";}      
	
	// REGISTERED �Ǽ�
	var REGISTERED=$("#Status_REGISTERED").checkbox('getValue');
	if(REGISTERED){iStatus=iStatus+"^"+"REGISTERED";}  
	
	//����
	var ARRIVED=$("#Status_ARRIVED").checkbox('getValue');
	if(ARRIVED){iStatus=iStatus+"^"+"ARRIVED";}  
	
	//����ԤԼ
	var CANCELPREREG=$("#Status_CANCELPREREG").checkbox('getValue');
	if(CANCELPREREG){iStatus=iStatus+"^"+"CANCELPREREG";}  
	
	//ȡ�����
	var CANCELPE=$("#Status_CANCELPE").checkbox('getValue');
	if(CANCELPE){iStatus=iStatus+"^"+"CANCELPE";}  
	
	
	return iStatus;
}




//�����޸���־��¼
function BGAdmRecordList(PGADM)
{
	//var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEGAdmRecordList"+"&GAdmId="+PGADM;
	// websys_lu(lnk,false,'width=600,height=500,hisui=true,title=�����޸���־��¼')
	var lnk="dhcpegadmrecordlist.hisui.csp"+"?GAdmId="+PGADM;
	 websys_lu(lnk,false,'width=900,height=500,hisui=true,title=���������־��¼')
}

//�Ѽ���Ա
function BHadCheckedList(PGADM)
{
	var lnk="dhcpehadcheckedlist.hisui.csp"+"?GroupID="+PGADM+"&HadCheckType=Y";
	//var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEHadCheckedList"+"&GroupID="+PGADM+"&HadCheckType=Y";
	 websys_lu(lnk,false,'width=1200,height=600,hisui=true,title=�Ѽ�����')
	
}

//δ����Ա
function BNoHadCheckedList(PGADM)
{
	var lnk="dhcpehadcheckedlist.hisui.csp"+"?GroupID="+PGADM+"&HadCheckType=N";
	//var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEHadCheckedList"+"&GroupID="+PGADM+"&HadCheckType=N";
	 websys_lu(lnk,false,'width=1200,height=600,hisui=true,title=δ������')
	
}

//ȷ�ϼ�����Ա��Ϣ
var openComfirmWin= function(PGADM){

	$("#myWin").show();
	$HUI.window("#myWin",{
		title:"ȷ�ϼ�����Ա��ϸ",
		iconCls:'icon-w-list',
		minimizable:false,
		maximizable:false,
		collapsible:false,
		modal:true,
		width:550,
		height:390
	});
	
	var ConfirmObj = $HUI.datagrid("#ConfirmAddOrdItemGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		pageSize: 20,
		pageList : [20,100,200],
		queryParams:{
			ClassName:"web.DHCPE.PreGADM",
			QueryName:"GetConfirmItemPerson",
			PreGADM:PGADM,
		},
		
		columns:[[
			{field:'RegNo',width:'150',title:'�ǼǺ�'},
			{field:'Name',width:'150',title:'����'},
			{field:'Team',width:'150',title:'��������'}
			
		]]				
		
		})

	
};
function InitPreGADMFindGrid()
{
	
	$HUI.datagrid("#PreGADMFindGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 50,
		pageList : [50,100,150],
		singleSelect: true,
		checkOnSelect: false, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: false,
		
		queryParams:{
			ClassName:"web.DHCPE.PreGADM",
			QueryName:"SearchPreGADM",
			BeginDate:$("#BeginDate").datebox('getValue')

		},
		frozenColumns:[[	
	
			{field:'PGADM_PGBI_DR_Code',width:120,title:'�������'},
			{field:'TRegNo',width:120,title:'�ǼǺ�'},
			{field:'PGADM_PGBI_DR_Name',width:180,title:'��������'},
					
		]],
		columns:[[

			{field:'PGADM_RowId',title:'PGADM_RowId',hidden: true},
			{field:'PGADM_BookDateBegin',width:100,title:'��ʼ����',
			formatter:function(value,rowData,rowIndex){	
				if(rowData.PGADM_RowId!=""){
						return "<a href='#'  class='grid-td-text' onclick=BGAdmRecordList("+rowData.PGADM_RowId+"\)>"+value+"</a>";
			
					}else{return value}
					
					
	
			}},
			{field:'PGADM_BookDateEnd',width:100,title:'��ֹ����'},
			{field:'PGADM_Status',title:'PGADM_Status',hidden: true},
			{field:'PGADM_Status_Desc',width:100,title:'״̬'},
			{field:'PGADM_ChargedStatus_Desc',width:100,title:'�շ�״̬'},
			{field:'PGADM_CompleteStatus',width:100,title:'���״̬'},
			{field:'TTotalPerson',width:250,title:'����'},
			{field:'GTotalAmont',width:400,title:'�ܽ��'},
			{field:'GGAmountTotal',width:100,title:'���ѽ��',align:'right'},
			{field:'GIAmountTotal',width:100,title:'�Էѽ��',align:'right'},
			{field:'THadChecked',width:80,title:'�Ѽ�����',
			formatter:function(value,rowData,rowIndex){	
				if(rowData.PGADM_RowId!=""){
					    return "<span style='cursor:pointer;padding:0 10px 0px 20px' class='icon-paper' title='�Ѽ�����' onclick='BHadCheckedList("+rowData.PGADM_RowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
			            return '<a><img style="padding:0 10px 0px 20px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  title="�Ѽ�����" border="0" onclick="BHadCheckedList('+rowData.PGADM_RowId+'\)"></a>';
					}
					
			}},
			
			{field:'TNoCheckDetail',width:80,title:'δ������',
				formatter:function(value,rowData,rowIndex){	
				if(rowData.PGADM_RowId!=""){
						return "<span style='cursor:pointer;padding:0 10px 0px 20px' class='icon-paper' title='δ������' onclick='BNoHadCheckedList("+rowData.PGADM_RowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
			            return '<a><img style="padding:0 10px 0px 20px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  title="δ������" border="0" onclick="BNoHadCheckedList('+rowData.PGADM_RowId+'\)"></a>';
					}
					
			}},
			{field:'PGBI_Linkman1',width:100,title:'��ϵ��'},
			{field:'PGBI_Tel1',width:100,title:'��ϵ�绰'},
		     {field:'TConfirmAddOrdItemPerson',width:100,title:'�Ƿ�ȷ�ϼ���',align:'center',
				formatter:function(value,rowData,rowIndex){ 
				if(rowData.PGADM_RowId!=""){
					if(rowData.TConfirmAddOrdItemPerson=="��"){
						return "<a href='#'  class='grid-td-text' onclick=openComfirmWin("+rowData.PGADM_RowId+"\)>"+value+"</a>";
					}else{
						
						return value;
					}
				}
					
			}},
			{field:'PGADM_PEDeskClerk_DR_Name',width:100,title:'�Ӵ���Ա'},
			{field:'PGADM_ContractNo',width:100,title:'��ͬ���'},
			{field:'TContract',width:120,title:'��ͬ����'},
			{field:'PGADM_CheckedStatus_Desc',width:100,title:'����״̬'},
			{field:'TGetReportDate',width:100,title:'ȡ��������'},
			{field:'TType',width:100,title:'����ɷ�'},
			
			{field:'THomeGroup',width:100,title:'��������'},
			{field:'TPGADMHPCode',width:100,title:'�������'},
			{field:'TMark',width:120,title:'��ע',editor:{type:'textarea',options:{height:'30px'}}}
					
					
		]],
		onClickRow: onClickRow,
		onAfterEdit: function(index, rowdata, changes) {
			if(rowdata.PGADM_RowId==""){
					//$.messager.alert("��ʾ","�ϼ��в���Ҫ���汸ע",'info');
					return false;
			}else{
				var rtn=tkMakeServerCall("web.DHCPE.PreGADM","UpDateGMark",rowdata.PGADM_RowId,rowdata.TMark);
				
			}
			

		},
		onSelect: function (rowIndex, rowData) {
			
			$("#PGADMID").val(rowData.PGADM_RowId);
			$("#GName").val(rowData.PGADM_PGBI_DR_Name);
			$("#Status").val(rowData.PGADM_Status_Desc);
			$("#CompleteStatus").val(rowData.PGADM_CompleteStatus);
			DisableButton(rowData.PGADM_Status,rowData.PGADM_CompleteStatus);		
					
		},
		 onLoadSuccess: function(data) {
			//editIndex = undefined;
		}
			
	})
}

//�б�༭
var editIndex = undefined;
var modifyBeforeRow = "";
var modifyAfterRow = "";

//�����б༭
function endEditing() {

	if (editIndex == undefined) {
		return true
	}
	if ($('#PreGADMFindGrid').datagrid('validateRow', editIndex)) {

		$('#PreGADMFindGrid').datagrid('endEdit', editIndex);



		editIndex = undefined;
		return true;
	} else {
		return false;
	}

}

//���ĳ�н��б༭
function onClickRow(index, value) {
	if (editIndex != index) {
		if (endEditing()) {
			$('#PreGADMFindGrid').datagrid('selectRow', index)
				.datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $('#PreIADMFindGrid').datagrid('getRows')[index]['TMark']

		} else {
			$('#PreIADMFindGrid').datagrid('selectRow', editIndex);
		}


	}

}



function DisableButton(Status,iComplete){

	SetCElement("PEFinish","������");
	if (Status!="ARRIVED"){
		 $("#PEFinish").linkbutton('disable');		
	}else{
		$("#PEFinish").linkbutton('enable');
		if(iComplete=="�����"){
			SetCElement("PEFinish","ȡ�����");
		}
	}
	
	
		if (Status=="PREREG")
		{
			 $("#Update").linkbutton('enable');
			 $("#BModifyItem").linkbutton('enable');

			DisableBElement("BCancelPre",false);
				
			SetCElement("BCancelPre","ȡ��ԤԼ");

			$("#HomeSet").linkbutton('enable');
			$("#BCopyTeam").linkbutton('enable');
			$("#CancelPE,#UpdatePreAudit,#BPrintGroupItem,#BPrintBaseInfo,#PrintGroupPerson,#BCancelPre,#BAllowToCharge").linkbutton('enable');
				
			return;
		}
		if (Status=="CANCELPREREG")
		{
			$("#Update").linkbutton('disable');
			$("#BModifyItem").linkbutton('disable');
			$("#HomeSet").linkbutton('disable');
			$("#BCopyTeam").linkbutton('disable');	
			DisableBElement("BCancelPre",false);
			SetCElement("BCancelPre","ԤԼ");
			$("#BCancelPre").css({"width":"118px"});
			$("#CancelPE,#UnCancelPE,#UpdatePreAudit,#BPrintGroupItem,#BPrintBaseInfo,#PrintGroupPerson,#BAllowToCharge").linkbutton('disable');
		
			return;
		}

		if (Status=="CANCELPE")
		{
			 $("#Update").linkbutton('disable');
			 $("#BModifyItem").linkbutton('disable');
			 $("#HomeSet").linkbutton('disable');
			 $("#BCopyTeam").linkbutton('disable');
			 $("#UnCancelPE").linkbutton('enable');
			 $("#CancelPE,#UpdatePreAudit,#BPrintGroupItem,#BPrintBaseInfo,#PrintGroupPerson,#BCancelPre,#BAllowToCharge").linkbutton('disable');
			
			 return;
		}

		$("#CancelPE,#UpdatePreAudit,#BPrintGroupItem,#BPrintBaseInfo,#PrintGroupPerson,#BCancelPre,#BAllowToCharge").linkbutton('enable');
		$("#HomeSet").linkbutton('enable');
		$("#BCopyTeam").linkbutton('enable');

		$("#Update").linkbutton('enable');
		if (iComplete=="�����"){                         
			$("#Update").linkbutton('disable');
		}  
		   
		 $("#BModifyItem").linkbutton('enable');                         
		if (iComplete=="�����"){                         
		 	$("#BModifyItem").linkbutton('disable');    
		} 
		                            
		$("#BCancelPre").linkbutton('disable');    

}
function InitCombobox(){
	

	//VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		});
		
	
	//�շ�״̬
	var ChargeStatusObj = $HUI.combobox("#ChargeStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'130',
		data:[
            {id:'0',text:$g('���շѼ�¼')},
            {id:'1',text:$g('δ�շ�')},
            {id:'2',text:$g('���շ�')},
            {id:'3',text:$g('�����շ�')}
        ]

	});
	
	//����
	var NameObj = $HUI.combogrid("#Name",{
		panelWidth:430,
		url:$URL+"?ClassName=web.DHCPE.PreGBaseInfo&QueryName=SearchGListByDesc",
		mode: 'remote',  
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'GBI_RowId',
		textField:'GBI_Desc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},
		onShowPanel:function()
		{
			$('#Name').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'GBI_RowId',title:'ID',width:30},
			{field:'GBI_Desc',title:'����',width:150},
			{field:'GBI_Code',title:'����',width:100}
					
		]]
		});
		
		
		//��ͬ
		var ContractObj = $HUI.combogrid("#Contract",{
        panelWidth:600,
        url:$URL+"?ClassName=web.DHCPE.Contract&QueryName=SerchContract",
        mode:'remote',
        delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
        idField:'TID',
        textField:'TName',
        onBeforeLoad:function(param){ 
            param.Contract = param.q;
        },
        onShowPanel:function()
        {
            $('#Contract').combogrid('grid').datagrid('reload');
        },
        columns:[[
            {field:'TID',hidden:true},
            {field:'TNo',title:'��ͬ���',width:100},
            {field:'TName',title:'��ͬ����',width:100},
            {field:'TSignDate',title:'ǩ������',width:100},
            {field:'TRemark',title:'��ע',width:100},
            {field:'TCreateDate',title:'¼������',width:100},
            {field:'TCreateUser',title:'¼����',width:80}
            
        ]]
        });
       

}


//����
function BCopyTeam_click(){
	var ID = $("#PGADMID").val();
	if (ID=="") {
		 $.messager.alert("��ʾ","����ѡ������","info");
	 	 return false;
	 }
    var repUrl="dhcpeteamcopy.hisui.csp?ToGID="+ID;	
	websys_lu(repUrl,false,'width=1020,height=545,hisui=true,title=���Ʒ���') 
}

//��������
function HomeSet_click(){
	var ID = $("#PGADMID").val();
	if (ID=="") {
		 $.messager.alert("��ʾ","��ѡ����趨����������","info");
	 	 return false;
	 }
	var lnk = "dhcpe.prehome.csp?PGADM=" + ID;
	//var lnk="dhcpepregadm.home.hisui.csp?PGADMDr="+ID+"&Type=G";	
	websys_lu(lnk, true, 'width=1290,height=660,hisui=true,title=��������');
}

//�������
function BAllowToCharge_click()
{
	
	 var ID = $("#PGADMID").val();
	 if (ID=="") {
		 $.messager.alert("��ʾ","����ѡ������","info");
	 	 return false;
	 }
	
	var Type="Group";
	var ReturnStr=tkMakeServerCall("web.DHCPE.AllowToCharge","AllowToChargeNew",ID+"^"+"1",Type,"Pre")
	if (ReturnStr==""){
		$.messager.alert("��ʾ","�޸����","info");
		
	}else{
		$.messager.alert("��ʾ","��û�еǼ�,������ɷ�","info");
		 return false;
	
	}
}




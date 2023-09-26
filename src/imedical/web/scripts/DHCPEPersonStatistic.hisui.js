
//����	DHCPEPersonStatistic.hisui.js
//����	����ۺϲ�ѯ
//����	2019.06.26
//������  xy

$(function(){
			
	InitCombobox();
	
	InitPersonStatisticGrid();  
     
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
	  
     $("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });

   $("#Name").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });

      
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
   
      
    //��������
	$("#BExport").click(function() {	
		BExport_click();		
        });
      
})


function BPrintView(PAADM){
	 
	 if (""==PAADM) { 
	 	$.messager.alert("��ʾ","����ѡ��ͻ�","info");
	    return false; 
	}
	var PrintFlag=1;
	var PrintView=1;
	var viewmark=2;
	var Instring=PAADM+"^"+PrintFlag+"^PAADM"+"Y"; 
	var value=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPatOrdItemInfo",'','',Instring);
	
	if (value=="NoPayed"){
		$.messager.alert("��ʾ","����δ������Ŀ������Ԥ��","info");
		return false;
	}
	PEPrintDJD("V",PAADM,"");//DHCPEPrintDJDCommon.js lodopԤ�����ﵥ
	//Print(value,PrintFlag,viewmark); //DHCPEIAdmItemStatusAdms.PatItemPrint.js
	
 }
 

 
 

 //��������
function BExportNew_click(){
	
		var iBeginDate="",iEndDate="";
		var iBeginDate=$("#BeginDate").datebox('getValue');
		var iEndDate=$("#EndDate").datebox('getValue');
	 	if (iEndDate==""){ iEndDate=EndDate();}
	 	
		 var value=tkMakeServerCall("web.DHCPE.Report.PEPersonStatistic","PEPersonStatisticImport");
		if (""==value) { return false; }
		
		
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	    var Templatefilepath=prnpath+'DHCPEPersonStatistic.xls';
	    
	    
	    
	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet= xlBook.ActiveSheet;"+
         "xlSheet.Cells(1,2).Value='"+iBeginDate+"';"+
         "xlSheet.Cells(2,2).Value='"+iEndDate+"';"
     	
        
		var FRow=4; 
		var User=session['LOGON.USERID']
		var values=tkMakeServerCall("web.DHCPE.Report.PEPersonStatistic","GetPEPersonStatisticImportRows",User)
        var value=values.split("&");
        var Rows=value[0];
        var valueTotal=value[1];
        var ret=""
		for (var i=1;i<=Rows;i++){
			var Datas=tkMakeServerCall("web.DHCPE.Report.PEPersonStatistic","GetPEPersonStatisticImportData",User,i+1)

			var DayData=Datas.split("^");
			var n=i+3
		
			for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
				var m=iDayLoop+1
				ret=ret+"xlSheet.Cells("+n+","+m+").Value='"+DayData[iDayLoop]+"';"
			}

		}
		
	    var valueTotalData=valueTotal.split("^");
	 
		for (var j=0;j<valueTotalData.length;j++) {
			
			    var row=parseInt(Rows)+4;
			    var col=j+1
				ret=ret+"xlSheet.Cells("+row+","+col+").Value='"+valueTotalData[j]+"';"
				
			}
	
		var k=parseInt(Rows)+4;
		var Str=Str+ret+
		   "xlSheet.Range(xlSheet.Cells(4,1),xlSheet.Cells("+k+",18)).Borders.LineStyle='1';"+
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

//��������
function BExport_click(){
	if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
	try{
		var iBeginDate="",iEndDate="";
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	    var Templatefilepath=prnpath+'DHCPEPersonStatistic.xls';
	    
		xlApp = new ActiveXObject("Excel.Application"); 
		xlApp.UserControl = true;
        xlApp.visible = true; 
		xlBook = xlApp.Workbooks.Add(Templatefilepath); 
		xlsheet = xlBook.WorkSheets("����"); 
    	var iBeginDate=$("#BeginDate").datebox('getValue');
		var iEndDate=$("#EndDate").datebox('getValue');
	 	if (iEndDate==""){ iEndDate=EndDate();}
	 	
		 var value=tkMakeServerCall("web.DHCPE.Report.PEPersonStatistic","PEPersonStatisticImport");
        //alert(value)
		if (""==value) { return false; }
		
		var FRow=4; 
		xlsheet.cells(1,2)=iBeginDate;
		xlsheet.cells(2,2)=iEndDate;
		
		var User=session['LOGON.USERID']
		var values=tkMakeServerCall("web.DHCPE.Report.PEPersonStatistic","GetPEPersonStatisticImportRows",User)
        var value=values.split("&");
        var Rows=value[0];
        var valueTotal=value[1];
        
        
		for (var i=1;i<=Rows;i++){
			var Datas=tkMakeServerCall("web.DHCPE.Report.PEPersonStatistic","GetPEPersonStatisticImportData",User,i+1)

			var DayData=Datas.split("^");
			for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
				xlsheet.cells(i+3, iDayLoop+1)=DayData[iDayLoop];
			}

		}
		
	    var valueTotalData=valueTotal.split("^");
	 
		for (var j=0;j<valueTotalData.length;j++) {
				xlsheet.cells(parseInt(Rows)+4,j+1)=valueTotalData[j];
			}
		
		xlsheet.Range(xlsheet.Cells(4,1),xlsheet.Cells(parseInt(Rows)+4,18)).Borders.LineStyle=1;	
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

//����
function BClear_click(){
	$("#RegNo,#Name,#Depart").val("");
	$(".hisui-combobox").combobox('setValue','');
	$(".hisui-combogrid").combogrid('setValue','')
	$("#BeginDate,#EndDate").datebox('setValue',"");
	$("#REGISTERED,#ARRIVED").checkbox('setValue',false);
	
	InitCombobox();
	BFind_click();
}

//��ѯ
function BFind_click(){
	
	var GADMID=$("#GADMDesc").combogrid('getValue');
	if (($("#GADMDesc").combogrid('getValue')==undefined)||($("#GADMDesc").combogrid('getValue')=="")){var GADMID="";} 
	
	var ReCheck=$("#ReCheck").combobox('getValue');
	if (($("#ReCheck").combobox('getValue')==undefined)||($("#ReCheck").combobox('getValue')=="")){var ReCheck="";} 
	
	var ChargeStatus=$("#ChargeStatus").combobox('getValue');
	if (($("#ChargeStatus").combobox('getValue')==undefined)||($("#ChargeStatus").combobox('getValue')=="")){var ChargeStatus="";}
	
	var iStatus=GetStatus();
	
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	var iRegNo=	$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo);
			$("#RegNo").val(iRegNo);
	}

	$("#PersonStatisticGrid").datagrid('load',{
			ClassName:"web.DHCPE.Report.PEPersonStatistic",
			QueryName:"PEPersonStatistic",
			PEBeginDate:$("#BeginDate").datebox('getValue'),
			PEEndDate :$("#EndDate").datebox('getValue'),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			SexDR:$("#Sex").combobox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			GDR:GADMID,
			IFSTSF:$("#IFSTSF").combobox('getValue'),
			ReCheck:ReCheck+"^"+ChargeStatus,
			Status:iStatus,
			DepName:$("#Depart").val(),
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
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Report.PEPersonStatistic",
			QueryName:"PEPersonStatistic",

		},
		frozenColumns:[[
			//{field: 'Select',width: 70,checkbox:true,title:'ѡ��',},
			{field:'PA_RegNo',width:100,title:'�ǼǺ�'},
			{field:'PA_Name',width:100,title:'����'},
			{field:'TPEID',width:100,title:'����'}
			
		]],
		columns:[[
		
			{field:'PA_ADMDR',title:'PAADM',hidden: true},
			{field:'PIADM_RowId',title:'PreIADM',hidden: true},
			{field:'PA_AdmDate',width:100,title:'�Ǽ�����'},
			{field:'PA_Status',width:100,title:'״̬'},
			{field:'PA_Sex',width:150,title:'�Ա�'},
			{field:'TAge',width:60,title:'����'},
			{field:'PA_AccountAmount',width:100,title:'Ӧ�ս��',align:'right',},
			{field:'PA_DiscountedAmount',width:100,title:'�Żݽ��',align:'right',},
			{field:'PA_FinalAmount',width:100,title:'ʵ�ʽ��',align:'right',},
			{field:'GAmount',width:100,title:'���ѽ��',align:'right',},
			{field:'IAmount',width:100,title:'�Էѽ��',align:'right',},
			{field:'PA_Payed',width:100,title:'�Ѹ����',align:'right',
				formatter:function(value,rowData,rowIndex){	
					if(rowData.PA_ADMDR!=""){
						return "<a href='#'  class='grid-td-text' onclick=BFAmountPayList("+rowData.PA_ADMDR+"\)>"+value+"</a>";
			
					}else{return value}
					
					
	
			}},
			{field:'PA_UnPayed',width:100,title:'δ�����',align:'right',},
			{field:'PA_Company',width:100,title:'��λ'},
			{field:'PA_GDesc',width:100,title:'��������'},
			{field:'PA_Saler',width:100,title:'ҵ��Ա'},
			{field:'PA_PartName',width:100,title:'����'},
			{field:'PA_TeamName',width:100,title:'��������'},  
			{field:'PIADM_ItemList',width:100,title:'�鿴ԤԼ��Ŀ',
			   
				formatter:function(value,rowData,rowIndex){	
					
				if(rowData.PA_ADMDR!=""){
					return '<a><img style="padding:0 10px 0px 30px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  title="��Ŀ��ϸ" border="0" onclick="BItemList('+rowData.PIADM_RowId+')"></a>';
					
				}
				}},
			
		
			{field:'PGBI_Tel1',width:120,title:'�绰'},
			{field:'TVIPLevel',width:80,title:'VIP�ȼ�'},
			{field:'TCardDesc',width:80,title:'֤������'},
			{field:'TIDCard',width:180,title:'֤����'},
			 
			{field:'TRoundFee',width:80,title:'������',align:'right',},  
			{field:'TIFSTSF',width:80,title:'��ͬ�շ�',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
					if(value!=""){
	   					if (value=="Y") {checked="checked=checked"}
						else{checked=""}
						var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
						return rvalue;
					}
				
				}},
			{field:'TPrtFlag',title:'�Ƿ��ӡ',hidden:true,
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="Y") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			{field:'TReport',title:'���Ԥ��',width:70,
				formatter:function(value,rowData,rowIndex){
				if(rowData.PA_ADMDR!=""){
					return '<a><img style="padding:0 10px 0px 5px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" title="����Ԥ��" border="0" onclick="ReportView('+rowData.PA_ADMDR+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/add_note.png" title="ָ����Ԥ��" border="0" onclick="BPrintView('+rowData.PA_ADMDR+')"></a>';		
				}
				}},
					
			
			
			
		]],
			
	});
}

//����Ԥ�� 
function ReportView(PAADM)
{
	var NewVerReportFlag = tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
	//alert(NewVerReportFlag)
	//if (NewVerReportFlag == "Y") {
	
	if(NewVerReportFlag == "Word") {
		calPEReportProtocol("BPrintView",PAADM);
	} else if (NewVerReportFlag == "Lodop") {
		PEPrintReport("V",PAADM,"");
	} else {
		PEPrintReport("V",PAADM,"");
	}
	
	/*
	var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
	if(NewVerReportFlag=="Lodop"){

			var Flag=tkMakeServerCall("web.DHCPE.PreIADM","IsHaveResultByPAADM",PAADM);
			if(Flag=="0"){
				$.messager.alert("��ʾ","û�������������Ԥ��","info");
				 return false; 
			PEPrintReport("V",PAADM,""); //lodop+cspԤ����챨��
			//calPEReportProtocol("BPrintView",PAADM);
		} 
		return false;
		}else if(NewVerReportFlag=="Word"){	
			var Flag=tkMakeServerCall("web.DHCPE.PreIADM","IsHaveResultByPAADM",PAADM);
			if(Flag=="0"){
				$.messager.alert("��ʾ","û�������������Ԥ��","info");
				 return false; 
			}
			calPEReportProtocol("BPrintView",PAADM);
			return false;
	
	}else{
	
	var wwidth=1200;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	
	var repUrl="dhcpeireport.normal.csp?PatientID="+PAADM+"&OnlyRead=Y";
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	var cwin=window.open(repUrl,"_blank",nwin)
	}
	*/
}
function calPEReportProtocol(sourceID,jarPAADM){
	var opType=(sourceID=="BPrint"||sourceID=="NoCoverPrint")?"2":(sourceID=="BPrintView"?"5":"1");
	if(opType=="2"){
		jarPAADM=jarPAADM+"@"+session['LOGON.USERID'];
	}
	var saveType=sourceID=="BExportPDF"?"pdf":(sourceID=="BExportHtml"?"html":"word"); 
	var printType=sourceID=="NoCoverPrint"?"2":"1";
	location.href="PEReport://"+jarPAADM+":"+opType+":"+saveType+":"+printType
}
//ʵ�ʽ���Ӧ֧����ʽ
function BFAmountPayList(ADMID){
	
	var lnk="dhcpefinalamountpaylist.hisui.csp"+"?ADMID="+ADMID;
	 websys_lu(lnk,false,'width=500,height=400,hisui=true,title=֧����ʽ�б�')
	
	
}

//�鿴ԤԼ��Ŀ
function BItemList(AdmId){
	var lnk="dhcpepreitemlist.list.hisui.csp"+"?ADMID="+AdmId;
	 websys_lu(lnk,false,'width=1200,height=600,hisui=true,title=��Ŀ��ϸ')
}

function InitCombobox(){
	

	//VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
		
		
		//����
	var ReCheckObj = $HUI.combobox("#ReCheck",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'0',text:'�Ǹ���'},
            {id:'1',text:'����'},
        ]

	});
	
	
	//�Ա�
	var SexObj = $HUI.combobox("#Sex",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex',
		panelHeight:'130',
	});
	
	//��ͬ�շ�
	var IFSTSFObj = $HUI.combobox("#IFSTSF",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'0',text:'��'},
            {id:'1',text:'��'},
        ]

	});
	
	//�շ�״̬
	var ChargeStatusObj = $HUI.combobox("#ChargeStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'0',text:'δ����'},
            {id:'1',text:'�����շ�'},
            {id:'2',text:'ȫ���շ�'},
        ]

	});
	
	//����
	var GADMDescObj = $HUI.combogrid("#GADMDesc",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
			param.ShowPersonGroup="1";
		},
		onShowPanel:function()
		{
			$('#GADMDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'TRowId',title:'ID',hidden: true},
			{field:'TGDesc',title:'��������',width:200},
			{field:'TGStatus',title:'״̬',width:100},
			{field:'TAdmDate',title:'ʱ��',width:100},
				
		]]
		});
		
}

function GetStatus(){

	var iStatus="";
	// REGISTERED �Ǽ�
	var REGISTERED=$("#REGISTERED").checkbox('getValue');
	if(REGISTERED){iStatus=iStatus+"^"+"REGISTERED^";}                                             
	// ARRIVED" ����
	var ARRIVED=$("#ARRIVED").checkbox('getValue');
	if(ARRIVED){iStatus=iStatus+"^"+"ARRIVED^";}  
	
	return iStatus;
	
}


function EndDate(){
   var s=""; 
 	var date = new Date(); 
    var y = date.getFullYear();  
    var m = date.getMonth()+1;  
    var d = date.getDate(); 
    var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
		if (dtformat=="YMD"){
			var s=y+"-"+m+"-"+d;
		}else if (dtformat=="DMY"){
			var s=d+"/"+m+"/"+y;
		}	        
   return(s);                               
}
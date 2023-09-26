//DHCPEIReport.hisui.js
//����	���˱���	
//����	2019.04.02
//������  xy

$(function(){
	 
	InitCombobox();
	
	InitIReportDataGrid();
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
    //���� 
    $("#BClear").click(function() {	
		 BClear_click();		
        }); 
 	
	$("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				RegNoOnChange();
			}
			
        }); 
         	
    
     //��������
    $("#BExportED").click(function() {	
		BExportED_click();		
        });  
    
	Init();
   

})


function Init()
{
	 var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
    if(NewVerReportFlag=="Lodop"){
	     $("#BExport").css('display','none');//���� 
    }else{
	     $("#BExport").css('display','block');//��ʾ
    }
}

function RegNoOnChange()
{
	
	var RegNo=$("#RegNo").val();	
 	if(RegNo!="") {
	 	var RegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":RegNo
		}, false);
		
			$("#RegNo").val(RegNo)
		}

	if (RegNo=="") return false;
	BFind_click();
		
}

//��ѯ
function BFind_click(){
	var iSTatus=""
	
	//δ���
	var iSTatusNA=$("#STatusIsNoAudit").checkbox('getValue');
	if(iSTatusNA) {iSTatus=iSTatus+"^"+"NA";}
	
	//�����
	var iSTatusA=$("#STatusIsCheched").checkbox('getValue');
	if(iSTatusA) {iSTatus=iSTatus+"^"+"A";}
	
	//�����
	var iSTatusC=$("#HadCompete").checkbox('getValue');
	if(iSTatusC) {iSTatus=iSTatus+"^"+"C";}
	
	//�Ѵ�ӡ
	var iSTatusP=$("#STatusIsPrint").checkbox('getValue');
	if(iSTatusP) {iSTatus=iSTatus+"^"+"P";}
	
	//��ȡ����
	var iSTatusS=$("#STatusIsSend").checkbox('getValue');
	if(iSTatusS) {iSTatus=iSTatus+"^"+"S"; }
	
	//�Ƿ��Ͷ���
	//var iSTatusS=$("#IsSendMessage").checkbox('getValue');
	//if(iSTatusS) {iSTatus=iSTatus+"^"+"S"; }

	
	$("#IReportQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.Report",
			QueryName:"SearchIReport",
	        RegNo:$("#RegNo").val(),
			PatName:$("#PatName").val(),
			DepartName:$("#DepartName").val(), 
			DateFrom:$("#DateFrom").datebox('getValue'),
			DateTo:$("#DateTo").datebox('getValue'),
			AuditDateFrom:$("#AuditDateFrom").datebox('getValue'),
			AuditDateEnd:$("#AuditDateEnd").datebox('getValue'),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			GroupID:$("#GroupName").combogrid('getValue'),
			TeamID:$("#TeamName").combogrid('getValue'),
			IsSecret:IsSecret,
			DocDR:$("#DocName").combogrid('getValue'),
			ReportStatus:iSTatus,
			HospID:session['LOGON.HOSPID']
			})
	
}

//���� 
function BClear_click(){
	$("#RegNo,#PatName,#DepartName").val("");
	$(".hisui-combobox").combobox('setValue',"");
	$(".hisui-combogrid").combogrid('setValue',"");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#DateFrom,#DateTo,#AuditDateFrom,#AuditDateEnd").datebox('setValue',"")
		InitCombobox();
		BFind_click()
	
}

//��������
function BExportED_cmdshell()
{
	var iPAADMDRStr=""
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//��ȡ�������飬��������
	for(var i=0;i<selectrow.length;i++){
		
     	var iPAADMDR=selectrow[i].RPT_PAADM_DR;
		if(iPAADMDRStr=""){iPAADMDRStr=iPAADMDR;}
		else{iPAADMDRStr=iPAADMDRStr+"^"+iPAADMDR;}		
		
	}
	
	if(iPAADMDRStr==""){
		$.messager.alert("��ʾ","��ѡ����������۵���Ա","info");
		return false;
	}
	
	
	var wdCharacter=1;	
	var Str = "(function test(x){"+
		"var WordApp=new ActiveXObject('Word.Application'); "+

		"var wdOrientLandscape = 1;"+ 
		"WordApp.Application.Visible=true;"+ //ִ�����֮���Ƿ񵯳��Ѿ����ɵ�word 
		"var myDoc=WordApp.Documents.Add();"+//�����µĿ��ĵ� 
		//WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//ҳ�淽������Ϊ���� 
		"WordApp.Selection.ParagraphFormat.Alignment=0;"+ //1���ж���,0Ϊ���� 
		"WordApp.Selection.Font.Bold=false;"+ 
		"WordApp.Selection.Font.Size=20;"+ 
		"WordApp.Selection.TypeText('����������');"+ 
		"WordApp.Selection.MoveRight("+wdCharacter+");"+��������//��������ַ� 
		"WordApp.Selection.TypeParagraph();"+ //������� 
		"WordApp.Selection.Font.Size=8;"+ 
		"WordApp.Selection.TypeParagraph();"+ //������� 
		"var myTable=myDoc.Tables.Add(WordApp.Selection.Range,1,3);"+ //1��7�еı�� 
		"myTable.Style='������';"+ 
		//�����п�
		"myTable.Columns(1).Width=45;"+
		"myTable.Columns(2).Width=35;"+
		"myTable.Columns(3).Width=380;"+
		//�����ͷ��Ϣ
		"myTable.Cell(1,1).Range.Text ='ID��';"+
		"myTable.Cell(1,2).Range.Text ='����';"+
		"myTable.Cell(1,3).Range.Text ='����';";
		var appendStr="";	
		var iPAADMDR="",RegNo="",Name="";
		var Row=1;
		for(var i=0;i<selectrow.length;i++){
			
	     	    var iPAADMDR=selectrow[i].RPT_PAADM_DR;
				var Info=tkMakeServerCall("web.DHCPE.ReportGetInfor","GetGeneralAdviceByAdmJS",iPAADMDR);
				appendStr="myTable.Rows.add();";//������
				Row=Row+1;
				appendStr=appendStr+"myTable.Cell("+Row+",3).Range.Text='"+Info+"';";
				RegNo=selectrow[i].RPT_RegNo;
				appendStr=appendStr+"myTable.Cell("+Row+",1).Range.Text='"+RegNo+"';";;
				Name=selectrow[i].RPT_IADM_DR_Name;
				appendStr=appendStr+"myTable.Cell("+Row+",2).Range.Text='"+Name+"';";;
			
		}	        
        Str=Str+appendStr+"return 1;}());";
		CmdShell.notReturn = 1;   //�����޽�����ã�����������
		var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
}
//��������
function BExportED_click()
{
	if(EnableLocalWeb==1){
		return BExportED_cmdshell();
	}
	var iPAADMDRStr=""
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//��ȡ�������飬��������
	for(var i=0;i<selectrow.length;i++){
		
     	var iPAADMDR=selectrow[i].RPT_PAADM_DR;
		if(iPAADMDRStr=""){iPAADMDRStr=iPAADMDR;}
		else{iPAADMDRStr=iPAADMDRStr+"^"+iPAADMDR;}		
		
	}
	
	if(iPAADMDRStr==""){
		$.messager.alert("��ʾ","��ѡ����������۵���Ա","info");
		return false;
	}
	
	
	var WordApp=new ActiveXObject("Word.Application"); 
	var wdCharacter=1 
	var wdOrientLandscape = 1 
	WordApp.Application.Visible=true; //ִ�����֮���Ƿ񵯳��Ѿ����ɵ�word 
	var myDoc=WordApp.Documents.Add();//�����µĿ��ĵ� 
	//WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//ҳ�淽������Ϊ���� 
	WordApp. Selection.ParagraphFormat.Alignment=0 //1���ж���,0Ϊ���� 
	WordApp. Selection.Font.Bold=false; 
	WordApp. Selection.Font.Size=20 
	WordApp. Selection.TypeText("����������"); 
	WordApp. Selection.MoveRight(wdCharacter);��������//��������ַ� 
	WordApp.Selection.TypeParagraph() //������� 
	WordApp. Selection.Font.Size=8 
	WordApp.Selection.TypeParagraph() //������� 
	var myTable=myDoc.Tables.Add (WordApp.Selection.Range,1,3) //1��7�еı�� 
	myTable.Style="������" 
	var TableRange;
	//�����п�
	myTable.Columns(1).Width=45;
	myTable.Columns(2).Width=35;
	myTable.Columns(3).Width=380;
	//�����ͷ��Ϣ
	myTable.Cell(1,1).Range.Text ="ID��";
	myTable.Cell(1,2).Range.Text ="����";
	myTable.Cell(1,3).Range.Text ="����";
		
	var iPAADMDR="",RegNo="",Name="";
	var Row=1;
	for(var i=0;i<selectrow.length;i++){
		
     	    var iPAADMDR=selectrow[i].RPT_PAADM_DR;
			var Info=tkMakeServerCall("web.DHCPE.ReportGetInfor","GetGeneralAdviceByAdm",iPAADMDR);
			myTable.Rows.add();//������
			Row=Row+1;
			myTable.Cell(Row,3).Range.Text=Info;
			RegNo=selectrow[i].RPT_RegNo;
			myTable.Cell(Row,1).Range.Text=RegNo;
			Name=selectrow[i].RPT_IADM_DR_Name;
			myTable.Cell(Row,2).Range.Text=Name;
		
	}
	
}

function BPrintViewLodop(e){
	
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//��ȡ�������飬��������
	for(var i=0;i<selectrow.length;i++){
			var iPAADMDR=selectrow[i].RPT_PAADM_DR;
			var printerName=tkMakeServerCall("web.DHCPE.Report","GetVirtualPrinter");
			if (e.id=="BPrint"){//��ӡ����
				PEPrintReport("P",iPAADMDR,printerName);
			}else if (e.id=="BPrintView"){//��ӡԤ��
				PEPrintReport("V",iPAADMDR,printerName);
			}else if (e.id=="BPrintYGReport") {  // �Ҹα���
				var YGItemFlag = tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetYGItemFlag",iPAADMDR,"PAADM");
				if (YGItemFlag != "3") {
					if (YGItemFlag == "0") $.messager.alert("��ʾ","���Ҹ���Ŀ��","info");
					else if (YGItemFlag == "2") $.messager.alert("��ʾ","�Ҹ���Ŀ�����죡","info");
					else $.messager.alert("��ʾ","�Ҹ���Ŀ�޽����","info");
					return false;
				}
				PEPrintOneFormatReport("P",iPAADMDR,printerName,"YGReport");
			}else{//��������
				PEPrintReport("E",iPAADMDR,printerName);
			} 
	}
	
	return false

}


function BPrintView(e){
	
	var iPAADMStr="", iRowID="",jarPAADM="",statusStr="";
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//��ȡ�������飬��������
	for(var i=0;i<selectrow.length;i++){
		
		var iPAADMDR=selectrow[i].RPT_PAADM_DR;
		if(jarPAADM=="") jarPAADM=iPAADMDR;
		else jarPAADM=jarPAADM+"#"+iPAADMDR;
		var Template=tkMakeServerCall("web.DHCPE.Report","GetTemplateName",iPAADMDR);
			if (Template!=""){
				if (iPAADMStr==""){iPAADMStr=iPAADMDR+";"+Template;}
				else{iPAADMStr=iPAADMStr+"^"+iPAADMDR+";"+Template;}
			}else{
				var RowID=selectrow[i].RPT_RowId;
				 if (iRowID==""){iRowID=RowID;}
				 else{ iRowID=iRowID+"^"+RowID;}
			}
			
	}
	
	
    var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
    //alert(NewVerReportFlag)
	//if(NewVerReportFlag=="Y"){
	if(NewVerReportFlag=="Word"){	
	
		if(e.id=="BExport"||e.id=="BPrint"||e.id=="BExportPDF"||e.id=="NoCoverPrint"||e.id=="BExportHtml"||e.id=="BPrintView"){
			if (jarPAADM==""){
				$.messager.alert("��ʾ","��ѡ�����ӡ����","info");
			}else if(statusStr.indexOf("δ")>0){
				$.messager.alert("��ʾ","δ���죬���ʵ����״̬","info");
			}else if(e.id=="BPrintView"&&jarPAADM.split("#").length>1){
				$.messager.alert("��ʾ","��������Ԥ����������ѡ��","info");
				
			}else{	
				calPEReportProtocol(e.id,jarPAADM);
			}		
			return false;
		} else if(e.id=="BPrintYGReport") {  // �Ҹα���ֻ��ӡCSPģ��
			BPrintViewLodop(e);	
		}
	
	}else if(NewVerReportFlag=="Lodop"){
		BPrintViewLodop(e);
		
	}else{
		
		if ((iRowID!="")||(iPAADMStr!="")){
			//alert(iRowID+"  @@iPAADMStr"+iPAADMStr);
			ShowPrintWindows(iRowID,iPAADMStr,e);
		}else{
			$.messager.alert("��ʾ","��ѡ�����ӡ���棡","info");
		}
	}
	return false;
}



//�ⲿЭ�����챨����� 
function calPEReportProtocol(sourceID,jarPAADM){

	var opType=(sourceID=="BPrint"||sourceID=="NoCoverPrint")?"2":(sourceID=="BPrintView"?"5":"1");
	if(opType=="2"){
		jarPAADM=jarPAADM+"@"+session['LOGON.USERID'];
	}
	var saveType=sourceID=="BExportPDF"?"pdf":(sourceID=="BExportHtml"?"html":"word"); 
	var printType=sourceID=="NoCoverPrint"?"2":"1";
	location.href="PEReport://"+jarPAADM+":"+opType+":"+saveType+":"+printType
}

//�ɰ��ӡ����
function ShowPrintWindows(iRowID,iPAADMStr,e) {
	var iPAADMDR='',iPAPMIDR="",iReportID="",iprnpath="",VipReturn="1",IsSendMessage="N"
	//alert(e.id)
	obj=document.getElementById("PAADMDR");
	if (obj){ iPAADMDR=obj.value; }
	obj=document.getElementById("PAPMIDR");
	if (obj){ iPAPMIDR=obj.value; }	
	obj=document.getElementById("GetIReportStatus");
	if (obj) var encmeth=obj.value;
	
	obj=document.getElementById("IsSendMessage");
	if (obj&&obj.checked) IsSendMessage="Y";
	
	var flag=cspRunServerMethod(encmeth,iPAPMIDR,"I");
	if (flag!=0)
	{	var eSrc=window.event.srcElement;
		if (eSrc.id!="BPrintView")
		{
			
			if (!confirm(t[flag])) {
			return false;
			}
		}
	}
	var Type="Export",OnlyAdvice="";
	var eSrc=window.event.srcElement;
	//alert(eSrc.id)
	if (eSrc.id=="BPrintView"){
		Type="View"
	}else if(eSrc.id=="BPrint"){
		Type="Print"
		var CoverFlag="0"
	}else if(eSrc.id=="BExportHtml"){
		Type="ExportHTML"
	}else if(eSrc.id=="SimPrint"){
		Type="Print"
		OnlyAdvice="N";
		var CoverFlag="0"
	}else if(eSrc.id=="NoCoverPrint"){
		Type="Print"
		var CoverFlag="1"
	}else if (eSrc.id=="BExportPDF"){
		Type="ExportPDF";
	}
	
	//alert(Type);
	obj=document.getElementById("prnpath");
	if (obj){ iprnpath=obj.value; }
	//alert(iPAADMStr);
	
	if (iPAADMStr!=""){
		PrintTemplateReport(iPAADMStr);
	}
	
	if (iRowID=="") return true;
	obj=document.getElementById("ReportNameBox");
	if (obj) { var iReportName=obj.value; }
	var width=screen.width-60;
	var height=screen.height-10;
	var nwin='toolbar=no,alwaysLowered=yes,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+width+',height='+height+',left=30,top=5';
 	
 	if ((Type=="Print")||((Type=="ExportPDF"))){
		
		var Arr=iRowID.split("^");
		
		var Length=Arr.length;
		for (var i=0;i<Length;i++)
		{
			var OneID=Arr[i]
			var lnk=iReportName+"?PatientID="+iPAADMDR+"&ReportID="+OneID+"&prnpath="+iprnpath+"&Type="+Type+"&OnlyAdvice="+OnlyAdvice+"&CoverFlag="+CoverFlag+"&IsSendMessage="+IsSendMessage;
			var ret=window.showModalDialog(lnk, "", "dialogwidth:800px;dialogheight:600px;center:1"); 
			//open(lnk,"_blank",nwin);
		}
	}else{
		
		var lnk=iReportName+"?PatientID="+iPAADMDR+"&ReportID="+iRowID+"&prnpath="+iprnpath+"&Type="+Type+"&OnlyAdvice="+OnlyAdvice+"&CoverFlag="+CoverFlag;
		open(lnk,"_blank",nwin);
	}
 	return false;
 
}
function InitIReportDataGrid(){
	
	$HUI.datagrid("#IReportQueryTab",{
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
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Report",
			QueryName:"SearchIReport",
			RegNo:$("#RegNo").val(),
			PatName:$("#PatName").val(),
			DepartName:$("#DepartName").val(), 
			DateFrom:$("#DateFrom").datebox('getValue'),
			DateTo:$("#DateTo").datebox('getValue'),
			AuditDateFrom:$("#AuditDateFrom").datebox('getValue'),
			AuditDateEnd:$("#AuditDateEnd").datebox('getValue'),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			GroupID:$("#GroupName").combogrid('getValue'),
			TeamID:$("#TeamName").combogrid('getValue'),
			ReportStatus:"",
			IsSecret:IsSecret,
			DocDR:$("#DocName").combogrid('getValue'),
			HospID:session['LOGON.HOSPID']
		},
		frozenColumns:[[
			{title: 'ѡ��',field: 'Select',width: 60,checkbox:true},
			{field:'RPT_RegNo',width:'100',title:'�ǼǺ�'},
		]],
		columns:[[
			
			{field:'RPT_RowId',title:'RPT_RowId',hidden: true},
			{field:'RPT_IADM_DR',title:'RPT_IADM_DR',hidden: true},
			{field:'RPT_PAADM_DR',title:'RPT_PAADM_DR',hidden: true},
			{field:'RPT_IADM_DR_Name',width:'100',title:'����'},
			{field:'RPT_IADM_Sex',width:'60',title:'�Ա�'},
			{field:'RPT_Age',width:'60',title:'����'},
			{field:'TDepartName',width:'100',title:'����'},
			{field:'Tel',width:'110',title:'��ϵ�绰'},
			{field:'TVIPLevel',width:'60',title:'VIP�ȼ�'},
			{field:'RPT_AduitUser_DR_Name',width:'100',title:'�����'},
			{field:'RPT_AduitDate',width:'100',title:'������� '},
			{field:'RPT_PrintUser_DR_Name',width:'100',title:'��ӡ��'},
			{field:'RPT_PrintDate',width:'100',title:'��ӡ����'},
			{field:'RPT_Status_Name',width:'100',title:'����״̬'},
			{field:'FetchReportUser',width:'100',title:'ȡ������'},
			{field:'FetchReportDate',width:'100',title:'ȡ����ʱ��'},
			{field:'RPT_SendUser_DR',width:'100',title:'������',hidden: true},
			{field:'RPT_SendDate',width:'100',title:'����ʱ��',hidden: true},
			{field:'UnAppedItems',width:'200',title:'δ�����Ŀ'},
			{field:'RPT_IADM_RegDate',width:'100',title:'��������'},
			{field:'THPNo',width:'100',title:'����'},
			{field:'RPT_GADM_DR_Name',width:'200',title:'����'},
			{field:'TeamDRName',width:'100',title:'����'},
			{field:'TPhotoFlag',width:'60',title:'Ƭ��'},
			{field:'PACCardDesc',width:'90',title:'֤������'},
			{field:'IDCard',width:'180',title:'֤����'},

					
		]]
			
	})
		
}



	
function InitCombobox()
{
	// VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		})
	
	//����
	var GroupNameObj = $HUI.combogrid("#GroupName",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
			param.ShowPersonGroup="1";
		},
		onChange:function()
		{
			TeamNameObj.clear();
			
		},
		columns:[[
			{field:'TRowId',title:'����ID',width:80},
			{field:'TGDesc',title:'��������',width:140},
			{field:'TGStatus',title:'״̬',width:100},
			{field:'TAdmDate',title:'����',width:100}
			
			
			
		]]
		})
		
		//����
		var TeamNameObj = $HUI.combogrid("#TeamName",{
		panelWidth:250,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=DHCPEGItemList",
		mode:'remote',
		delay:200,
		idField:'GT_RowId',
		textField:'GT_Desc',
		onBeforeLoad:function(param){
			
			var PreGId=$("#GroupName").combogrid("getValue");
			param.GID = PreGId;
		},
		onShowPanel:function()
		{
			$('#TeamName').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'GT_Desc',title:'��������',width:140},
			{field:'GT_RowId',title:'����ID',width:80}
			
		]]
	});
		
		
	//ҽ��
	var DocNameObj = $HUI.combogrid("#DocName",{
		panelWidth:270,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUserNew&Type=GAuditStationS^JGAUDITSTATIONS^GMainAuditStationS^KGMAINAUDITSTATIONS",
		mode:'remote',
		delay:200,
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'DocDr',title:'ID',width:60},
			{field:'DocName',title:'����',width:150}
				
		]]
	});
		
}

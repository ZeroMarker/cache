
//����	DHCPECheckProgress.hisui.js
//����	�����̲�ѯ
//����	2019.06.24
//������  xy

$(function(){
			
	InitCombobox();
	
	InitCheckProgressGrid();  
     
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
    
    //����
    $("#BAddItem").click(function() {	
		BAddItem_click();		
        });
    
    //�ձ�
    $("#BRec").click(function() {	
		BRec_click();		
        });
   
    //ճ��
    $("#BSendAudit").click(function() {	
		BSendAudit_click();		
        });
        
    //���������
    $("#BReport").click(function() {	
		BReport_click();		
        });
    
    //ȡ����
    $("#BFetchReport").click(function() {	
		BFetchReport_click();		
        });
        
    //����Ԥ��
    $("#BReportView").click(function() {	
		BReportView_click();		
        });
    
    //������
    $("#BSendMessage").click(function() {	
		BSendMessage_click();		
        });
    
})



//ճ��
function BSendAudit_click(){
	  lnk="dhcpesendaudit.hisui.csp"
	 //websys_lu(lnk,false,'width=1400,height=600,hisui=true,title=ճ��')  
	 var wwidth=1430;
	 var wheight=600;
	 var xposition = 0;
	 var yposition = ((screen.height - wheight) / 2)-10;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
}

//���������
 function BReport_click(){
	 //var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPESendReportMessage";
	  var lnk="dhcpesendreportmessage.hiui.csp"
	// websys_lu(lnk,false,'width=1400,height=600,hisui=true,title=���������') 
	 var wwidth=1430;
	var wheight=600;
	var xposition = 0;
	 var yposition = ((screen.height - wheight) / 2)-10;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	  
	 
 }
 
//�ձ�
function BRec_click(){
	
	//var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPERecPaper";
	var lnk="dhcperecpaper.hisui.csp";				
	//websys_lu(lnk,false,'width=1400,height=800,hisui=true,title=�ձ�')  
	 var wwidth=1430;
	var wheight=1430;
	var xposition = 0;
	 var yposition = 0;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)  
   
}

//ȡ����
function BFetchReport_click(){
	  
	var lnk="dhcpefetchreport.hisui.csp";
	//websys_lu(lnk,false,'width=1430,height=600,hisui=true,title=ȡ����') 
	var wwidth=1430;
	var wheight=600;
	var xposition = 0;
	 var yposition = ((screen.height - wheight) / 2)-10;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
}

//������
function BSendMessage_click(){
	var Type="PAADM",flag=0;
	var InfoStr=GetSelectId();
	if(InfoStr==""){
			$.messager.alert("��ʾ","��ѡ������Ͷ��ŵ���Ա","info");
			return;
	}
	var Stars=InfoStr.split(";")
	for(var PSort=0;PSort<Stars.length;PSort++)
	{
		var Star=Stars[PSort];
		var ret=tkMakeServerCall("web.DHCPE.SendMessage","SaveMessage",Type,Star);
		if (ret!=0) {var flag=1;}	
	
	}
	BFind_click();
	
}
function GetSelectId() 
{   
	var selectrow = $("#CheckProgressGrid").datagrid("getChecked");//��ȡ�������飬��������
	var SelectIds=""
	var Content=$.trim($("#Content").val());
	if (Content=="") {
			$.messager.alert("��ʾ","�������ݲ���Ϊ��","info");
			return;
		}
	for(var i=0;i<selectrow.length;i++){
		var ID=selectrow[i].TPAADM;
		var RegNo=selectrow[i].TRegNo;
		var TTel=$.trim(selectrow[i].TTel);
		if (TTel=="") {
			$.messager.alert("��ʾ","�绰����Ϊ��","info");
			continue;
		}
		if (!isMoveTel(TTel))
		{
			$.messager.alert("��ʾ","�绰���벻��ȷ","info");
			continue;
		}
	
		if (SelectIds=="") {SelectIds=ID+"^"+RegNo+"^"+TTel+"^"+Content;}
			else {SelectIds=SelectIds+";"+ID+"^"+RegNo+"^"+TTel+"^"+Content;}
	
	}
  return SelectIds;
	
}

///�ж��ƶ��绰
function isMoveTel(elem){
	if (elem=="") return true;
	var pattern=/^0{0,1}13|15|18[0-9]{9}$/;
	if(pattern.test(elem)){
		return true;
	}else{

	return false;
 	}
}


//����Ԥ��
function BReportView_click(){
	var selectrow = $("#CheckProgressGrid").datagrid("getChecked");//��ȡ�������飬��������
	var selectlen=selectrow.length;
	if(selectlen==""){
			$.messager.alert("��ʾ","��ѡ���Ԥ���������Ա","info");
			return false;
	   }
	if(selectlen>1){
			$.messager.alert("��ʾ","Ԥ�����治��ѡ�����","info");
			return false;
	   }
	 var PAADM=selectrow[0].TPAADM;

	 var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
	if(NewVerReportFlag=="Word"){
		calPEReportProtocol("BPrintView",PAADM);	
	}if(NewVerReportFlag=="Lodop"){
		if (PAADM==""){
			$.messager.alert("��ʾ","����ID����","info");
		    return false;
		}else{
			//calPEReportProtocol("BPrintView",PAADM);
			PEPrintReport("V",PAADM,""); //lodop+cspԤ����챨��
		} 
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


//����
function BAddItem_click()
{
	var selectrow = $("#CheckProgressGrid").datagrid("getChecked");//��ȡ�������飬��������
	var selectlen=selectrow.length;
	
	
	if(selectlen==""){
			$.messager.alert("��ʾ","��ѡ����������Ա","info");
			return false;
	   }
	if(selectlen>1){
			$.messager.alert("��ʾ","�����ѡ�����","info");
			return false;
	   }
	   
	var PreOrAdd="PRE";
	var GroupFlag=0;
	///����������еĸ��˵����������
	if(selectrow[0].TGroupDesc!=""){
			PreOrAdd="ADD";
			GroupFlag=1;
	}
	
	var iRowId=selectrow[0].TPreIADM;
	var lnk="dhcpepreitemlist.main.hisui.csp"+"?AdmType=PERSON"
			+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
			;
    
	websys_lu(lnk,false,'width=1400,height=750,hisui=true,title=����')
}



//��ѯ
function BFind_click(){
	
	var RegNo=$("#RegNo").val();
	if(RegNo!="") {
		var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
		$("#RegNo").val(RegNo)
		}

	var GADMID=$("#GADMDesc").combogrid('getValue');
	if (($("#GADMDesc").combogrid('getValue')==undefined)||($("#GADMDesc").combogrid('getValue')=="")){var GADMID="";} 
	var CheckStatus=$("#CheckStatus").combobox('getValue');
	if (($("#CheckStatus").combobox('getValue')==undefined)||($("#CheckStatus").combobox('getValue')=="")){var CheckStatus="";} 
	
	$("#CheckProgressGrid").datagrid('load',{
			ClassName:"web.DHCPE.Report.DoctorWorkStatistic",
			QueryName:"CheckProgress",
			DateBegin:$("#BeginDate").datebox('getValue'),
			DateEnd:$("#EndDate").datebox('getValue'),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			SexDR:$("#Sex").combobox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			GADMID:GADMID,
			DietFlag:$("#DietFlag").combobox('getValue'),
			ReCheck:$("#ReCheck").combobox('getValue'),
			CheckStatus:CheckStatus,
			Depart:$("#Depart").val(),
			});
}


//����
function BClear_click(){
	
	$("#BeginDate,#EndDate").datebox('setValue');
	$(".hisui-combobox").combobox('setValue',"");
	$(".hisui-combogrid").combogrid('setValue',"");
	$("#RegNo,#Name,#Content,#Depart").val("");
	
	InitCombobox();
	BFind_click();
}

//δ�����Ŀ
function UComItemDetail(PAADM){
	//lnk="dhcpeshowinfo.csp"
     lnk="dhcpenocheckitemdetail.hisui.csp"
          +"?EpisodeID="+PAADM;
	websys_lu(lnk,false,'width=900,height=260,hisui=true,title=δ����Ŀ����') 
   
}

function InitCheckProgressGrid(){
	
		$HUI.datagrid("#CheckProgressGrid",{
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
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Report.DoctorWorkStatistic",
			QueryName:"CheckProgress",

		},
		frozenColumns:[[
			{field: 'Select',width: 70,checkbox:true,title:'ѡ��',},
			{field:'TRegNo',width:100,title:'�ǼǺ�'},
			{field:'TName',width:100,title:'����'},
			{field:'THPNo',width:100,title:'����'}
			
		]],
		columns:[[
		
			{field:'TPAADM',title:'PAADM',hidden: true},
			{field:'TPreIADM',title:'PreIADM',hidden: true},
			{field:'TReportID',title:'ReportID',hidden: true},
			{field:'TSex',width:50,title:'�Ա�'},
			{field:'TUnCheckItems',width:100,title:'δ�����Ŀ',
			    
				formatter:function(value,rowData,rowIndex){	
					if(value!=""){
						return "<a href='#'  class='grid-td-text' onclick=UComItemDetail("+rowData.TPAADM+"\)>��</a>";
			
					}
					if(value==""){
						return "<a href='#' class='grid-td-text'>��</a>";
					
					}
	
				}},
			{field:'THadRec',width:50,title:'�ձ�',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			
			{field:'TSendAudit',width:50,title:'ճ��',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			{field:'TReportAudit',width:50,title:'����',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				}},
			{field:'TMainAudit',width:60,title:'����',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			{field:'TReportPrint',width:80,title:'�����ӡ',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value!="") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				}},
			{field:'TFetchReport',width:60,title:'��ȡ',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			{field:'THadSendMessage',width:100,title:'�Ƿ��ѷ���',
			formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			{field:'TAge',width:60,title:'����'},
			{field:'PACCardDesc',width:90,title:'֤������'},
			{field:'IDCard',width:160,title:'֤����'}, 
			{field:'TPosition',width:80,title:'����'},
			{field:'TTel',width:120,title:'�绰'},
			{field:'TVIPLevel',width:80,title:'VIP�ȼ�'},
			{field:'TCheckDate',width:100,title:'�������'},
			{field:'TGroupDesc',width:120,title:'��������'},  
			{field:'TDietFlag',width:60,title:'���',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			
			
			
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
	var CheckStatusObj = $HUI.combobox("#CheckStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'240',
		data:[
            {id:'1',text:'δ�ձ�'},
            {id:'2',text:'δճ��'},
            {id:'3',text:'δ����'},
            {id:'4',text:'δ����'},
            {id:'5',text:'δ��ӡ'},
            {id:'6',text:'δȡ'},
            {id:'7',text:'��ȡ'},  
        ]

	});	
	
	//����
	var ReCheckObj = $HUI.combobox("#ReCheck",{
		valueField:'id',
		textField:'text',
		panelHeight:'80',
		data:[
            {id:'0',text:'�Ǹ���'},
            {id:'1',text:'����'},
        ]

	});	
	//���
		var DietObj = $HUI.combobox("#DietFlag",{
		valueField:'id',
		textField:'text',
		panelHeight:'80',
		data:[
            {id:'0',text:'��'},
            {id:'1',text:'��'},
        ]

	});
	
	
	//�Ա�
	var SexObj = $HUI.combobox("#Sex",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex',
		panelHeight:'130',
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
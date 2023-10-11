//phaauxiliaryinfo.js
//������Ϣ��
var lisFlag=0;
var pacsFlag=0;
var orderFlag=0;
var diaFlag=0;
var pathology=0
var EpisodeID=4
var orderArr =  [{"value":"genenic+dosage+doseuom+instru+freq+duration","text":"ҽ������+����+������λ+���÷���+��ҩƵ��+�Ƴ�"},{"value":"genenic+dosage+doseuom+instru+freq","text":"ҽ������+����+������λ+���÷���+��ҩƵ��"},{"value":"genenic+dosage+doseuom","text":"ҽ������+����+������λ"}]
var VitalsignsArr = [{"value":"WriteDate+temperature+pulse+breath+sysPressure+diaPressure","text":"�ɼ�ʱ��+����+����+����+����ѹ+����ѹ"},{"value":"WriteDate+temperature+pulse+breath+sysPressure","text":"�ɼ�ʱ��+����+����+����+����ѹ"}]
var LisArr=[{"value":"LabEpisode+OrdItemName+AuthDateTime+PatName+freq","text":"�����+ҽ������+��������+����+��������"},{"value":"LabEpisode+OrdItemName+AuthDateTime+PatName","text":"�����+ҽ������+��������+����"}]
var PacsArr=[{"value":"ReqNo+strOrderName+strOrderDate","text":"���뵥��+�������+��������"},{"value":"ReqNo+strOrderName","text":"���뵥��+�������"}]
var AllergyArr=[{"value":"tag+Allergen+ALGItem+Status+OnsetDateText+LastUpdateUser+LastUpdateDate","text":"��������+����Դ+������Ŀ+״̬+��������+�������û�+����������"},{"value":"tag+Allergen+ALGItem+Status+OnsetDateText","text":"��������+����Դ+������Ŀ+״̬+��������"}]
var ComArr=""   //��������
var comid=""   //����datagrid id
$(function(){
	var frm = dhcadvdhcsys_getmenuform();
	
		if (frm) {
			frm.EpisodeID.value=4
	        EpisodeID = frm.EpisodeID.value;
	}

	initTab();
	
	//initCombox();
})
function initTab(){
	$('#phaTab').tabs({
	    onSelect:function(title){
			if(title=="����"){
				initLis();
			}
			if(title=="���"){
				initPacs();
			}
			if(title=="ҩ��ҽ��"){
				initOrder();
			}
			if(title=="��������"){
				initVitalsigns();
			}
			if(title=="ҩ������"){
				initAllergy();
			}
	    }
	});
}

///��ʼ��ҽ��tabǩ
function initOrder(){
		$("#OrderDatagrid").css("dispaly","block")
		ComArr=orderArr
		comid="#OrderDatagrid"
		//ҽ�����÷�ʽ
		$HUI.combobox("#queryOrdType",{
			valueField:'value',
			textField:'text',
			panelHeight:"auto",
			editable:false,
			data:ComArr
		});
		$("#OrderReview").css("display","")
		initOrderDatagrid();
		
}
///��ʼ������tabǩ
function initLis(){
		$("#LisDatagrid").css("dispaly","block")
		ComArr=LisArr
		comid="#LisDatagrid"
		//���÷�ʽ
		$HUI.combobox("#queryOrdType",{
			valueField:'value',
			textField:'text',
			panelHeight:"auto",
			editable:false,
			data:ComArr
		});

		$("#OrderReview").css("display","none")
		initLisDatagrid();
		
}
///��ʼ�����tabǩ
function initPacs(){
		$("#PacDatagrid").css("dispaly","block")
		ComArr=PacsArr
		comid="#PacDatagrid"
		//���÷�ʽ
		$HUI.combobox("#queryOrdType",{
			valueField:'value',
			textField:'text',
			panelHeight:"auto",
			editable:false,
			data:ComArr
		});
		$("#OrderReview").css("display","none")
		initPacDatagrid();
		
}
//��������
function initVitalsigns(){
		$("#VitalsignsDatagrid").css("dispaly","block")
		ComArr=VitalsignsArr
		comid="#VitalsignsDatagrid"
		//���÷�ʽ
		$HUI.combobox("#queryOrdType",{
			valueField:'value',
			textField:'text',
			panelHeight:"auto",
			editable:false,
			data:ComArr
		});

		$("#OrderReview").css("display","none")
		initVitalsignsDatagrid();
	
	}

//ҩ������
function initAllergy(){
		$("#AllergyDatagrid").css("dispaly","block")
		
		ComArr=AllergyArr
		comid="#VitalsignsDatagrid"
		//���÷�ʽ
		$HUI.combobox("#queryOrdType",{
			valueField:'value',
			textField:'text',
			panelHeight:"auto",
			editable:false,
			data:ComArr
		});

		$("#OrderReview").css("display","none")
		initAllergyDatagrid();
	}


///��ʼ��ҽ��datagrid
function initOrderDatagrid(){
		$HUI.datagrid('#OrderDatagrid',{
		    url:'dhcapp.broker.csp?ClassName=web.DHCCKBPHAAuxInfo&MethodName=GetAdmOrdList',
		    fit:true,
			autoSizeColumn:false,
			fitColumns:true,
			showFooter:true,			
			onBeforeLoad:function(param){
				var EpisodeIDs=EpisodeID  //$("#EpisodeID").val()
				param.EpisodeID=EpisodeIDs
				return param
			},
			fontSize:12,
		    columns:[[
		    	{field:'ck',title:'sel',checkbox:true,width:42},
		        {field:'startdate',title:'ҽ������',width:88},
		        {field:'StartTime',title:'ҽ��ʱ��',width:78},
		        {field:'genenic',title:'ҽ������',width:117},
		        {field:'dosage',title:'����',width:55},
		        {field:'doseuom',title:'������λ',width:78},
		        {field:'instru',title:'���÷���',width:78},
		        {field:'freq',title:'��ҩƵ�� ',width:78},
		        {field:'duration',title:'�Ƴ� ',width:34},
		        {field:'orditm',title:'Oeori ',width:100,hidden:true}
		    ]]
		   
		  });	
}
// ��ѯҽ��
function QueryOrder()
{
	var orderCode = $("#orderCode").val();
	
	$('#OrderDatagrid').datagrid('load',{
		EpisodeID:EpisodeID, 
		orderCode:orderCode,
	}); 
}
//��ѯ��������
function QueryVitalsigns(){
	$('#VitalsignsDatagrid').datagrid('load',{
				AEpisodeID:EpisodeID,
				AInterFace:"HIS",
				AItem:"WriteDate^temperature^pulse^breath^sysPressure^diaPressure^EpisodeDate^DeptDesc",
				AStDate:$("#VitalsignsStDate").datebox('getValue'),
				AEdDate:$("#VitalsignsEndDate").datebox('getValue')
	}); 

	}
// ��ѯ���
function QueryPac()
{
	var stdate= $("#PacStDate").datebox('getValue')	;
	var enddate= $("#PacEndDate").datebox('getValue')	;
	var params = EpisodeID+"^^"+stdate+"^"+enddate;
	$('#PacDatagrid').datagrid('load',{
		Params:params
	}); 
}

// ��ѯ����
function QueryLis()
{
	var stdate= $("#LisStDate").datebox('getValue')	;
	var enddate= $("#LisEndDate").datebox('getValue')	;
	var params = EpisodeID+"^^"+stdate+"^"+enddate;
	$('#LisDatagrid').datagrid('load',{
		Params:params
	}); 
}

// ��ѯҩ������
function QueryAllergy()
{
	var orderCode = $("#AllergyCode").val();
	
	$('#AllergyDatagrid').datagrid('load',{
		EpisodeID:EpisodeID, 
		code:orderCode,
	}); 
}
///��ʼ������datagrid
function initLisDatagrid(){
		$HUI.datagrid('#LisDatagrid',{
		    url:'dhcapp.broker.csp?ClassName=web.DHCCKBPHAAuxInfo&MethodName=JsonQryOrdListNew',
		    fit:true,
			autoSizeColumn:false,
			fitColumns:true,
			showFooter:true,			
			onBeforeLoad:function(param){
				var stdate= $("#LisStDate").datebox('getValue')	;
				var enddate= $("#LisEndDate").datebox('getValue')	;
				var params = EpisodeID+"^^"+stdate+"^"+enddate;
				param.Params=params
				return param
			},
			fontSize:12,
		    columns:[[
		    	{field:'ck',title:'sel',checkbox:true,width:42},
		        {field:'LabEpisode',title:'�����',width:88},
		        {field:'OrdItemName',title:'ҽ������',width:78},
		        {field:'AuthDateTime',title:'��������',width:117},
		        {field:'PatName',title:'����',width:55},
		        {field:'freq',title:'�������� ',width:78},
		        {field:'ResultStatus',title:'���״̬',width:78,formatter:ResultIconPrompt}
		        ]]
		   
		  });	
}


//���ͼ����ʾ
function ResultIconPrompt(value, rowData, rowIndex) {
	///(1�Ǽǣ�2����3��ˣ�4���飬5ȡ����ˣ�6���ϣ�O����)
    var mcStr="";
    if (value == "3") {
	    var paramList=rowData.VisitNumberReportDR;
	    if (rowData.TSResultAnomaly == "3") {
        	mcStr+="<a style='text-decoration:none;color:#FF83FA;' href='javascript:void(ReportView(\"" + rowData.PortUrl + "\"))';><span class='icon-absurb' color='red' title='�ĵ����')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "2") {
        	mcStr+="<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(\"" + rowData.PortUrl + "\"))';><span class='icon-panic' color='red' title='Σ��ֵ���')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "1") {
        	mcStr+="<a style='text-decoration:none;color:#FF7F00;' href='javascript:void(ReportView(\"" + rowData.PortUrl + "\"))';><span class='icon-abnormal' color='red' title='�쳣���')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "0") {
        	mcStr+="<a style='text-decoration:none;color:blue' href='javascript:void(ReportView(\"" + rowData.PortUrl + "\"))';><span class='icon-normal' color='red' title='������')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
		}
    }
    
    if(rowData.HasBic=="1")
	{
		mcStr="<span style='color:red;'>��</span>"+mcStr;
	}

    return mcStr;
}

///��ʼ�����datagrid
function initPacDatagrid(){
		$HUI.datagrid('#PacDatagrid',{
		    url:'dhcapp.broker.csp?ClassName=web.DHCCKBPHAAuxInfo&MethodName=GetLisInspectOrdNew',
		    fit:true,
			autoSizeColumn:false,
			fitColumns:true,
			showFooter:true,			
			onBeforeLoad:function(param){
				var stdate= $("#PacStDate").datebox('getValue')	;
				var enddate= $("#PacEndDate").datebox('getValue')	;
				var params = EpisodeID+"^^"+stdate+"^"+enddate;
				param.Params=params;
				return param
			},
			fontSize:12,
		    columns:[[
		    	{field:'ck',title:'sel',checkbox:true,width:42},
		    	{field:'lx',title:'����',width:60,formatter:formatterlx},
		        {field:'ReqNo',title:'���뵥��',width:88},
		        {field:'strOrderName',title:'�������',width:78},
		        {field:'strOrderDate',title:'��������',width:117},
		        {field:'Report',title:'����',width:55,formatter:formatterPort},
		        {field:'Image',title:'ͼ��',width:78,formatter:formatterImg},
		   		{ field: 'BlMorePort',align: 'center', title: '������',formatter:formatterBlMorePort},
		        ]]
		   
		  });	
}
function ReportView(url) {
	window.open (url, "newwindow", "height=500, width=900, toolbar =no,top=100,left=200,, menubar=no, scrollbars=no, resizable=no, location=no, status=no") ;
	return false;
}

function formatterImg(value,rowData){	
	retStr = "<a href='#' title='' onclick='showImg(\""+rowData.ImgUrl+"\")'>"+value+"</span></a>"
	return retStr;	
}
///�Ķ�ͼ��
function showImg(url){
	if(url===""){
		$.messager.alert("��ʾ","RIS����ƽ̨û������ͼ���Ķ�·��");	
		return false;
	}

	window.open (url, "newwindow", "height=550, width=950, toolbar =no,top=100,left=300,menubar=no, scrollbars=no, resizable=yes, location=no,status=no");
	return false;	
}

///�Ķ�����
function showReport(url){
	if(url===""){
		$.messager.alert("��ʾ","RIS����ƽ̨û������ͼ���Ķ�·��");	
		return false;
	}
	
	//�򿪱���
	window.open (url, "newwindow", "height=550, width=950, toolbar =no,top=100,left=300,menubar=no, scrollbars=yes, resizable=yes, location=no,status=no");
	return false;
}

function formatterPort(value,rowData){
	var url="",params="";
	if(rowData.BLOrJC==0){}
	if(rowData.BLOrJC==1){}
	url=rowData.PortUrl
	if(rowData.PortUrl===""){
		url="";
	}
	retStr = "<a href='#' title='' onclick='showReport(\""+url+"\")'>"+value+"</span></a>"
	return retStr;	
}

function formatterlx(value,rowData){
	if(rowData.BLOrJC==0){
		return "���";
	}
	
	if(rowData.BLOrJC==1){
		return "����";
	}
}

function formatterBlMorePort(value,rowData){
	var url = rowData.PortUrl;
	url = url.replace("Rpt=1","Rpt=");  //����鿴��ݱ���
	retStr = "<a href='#' title='' onclick='showReport(\""+url+"\")'>"+value+"</span></a>"
	return retStr;	
}

function initVitalsignsDatagrid(){
	$HUI.datagrid('#VitalsignsDatagrid',{
		    url:'dhcapp.broker.csp?ClassName=web.DHCCKBPHAAuxInfo&MethodName=GetVitalsigns',
		    fit:true,
			autoSizeColumn:false,
			fitColumns:true,
			showFooter:true,			
			onBeforeLoad:function(param){
				param.AEpisodeID=EpisodeID;
				param.AInterFace="HIS";
				param.AItem="WriteDate^temperature^pulse^breath^sysPressure^diaPressure^EpisodeDate^DeptDesc"
				return param;
			},
			fontSize:12,
		    columns:[[
		    	{field:'ck',title:'sel',checkbox:true,width:42},
		    	{field:'WriteDate',title:'�ɼ�ʱ��',width:130},
		        {field:'temperature',title:'����',width:80},
		        {field:'pulse',title:'����',width:80},
		        {field:'breath',title:'����',width:80},
		        {field:'sysPressure',title:'����ѹ',width:80},
		        {field:'diaPressure',title:'����ѹ',width:80},
		        ]]
		   
		  });
	}
	
function initAllergyDatagrid(){
		$HUI.datagrid('#AllergyDatagrid',{
		    url:'dhcapp.broker.csp?ClassName=web.DHCCKBPHAAuxInfo&MethodName=QueryAllergyInfo',
		    fit:true,
			autoSizeColumn:false,
			fitColumns:true,
			showFooter:true,			
			onBeforeLoad:function(param){
				param.EpisodeID=EpisodeID;
				param.code="";
				return param;
			},
			fontSize:12,
		    columns:[[
		    	{field:'ck',title:'sel',checkbox:true,width:42},
		        {field:'Allergen',title:'����Դ',width:80},
		        {field:'ALGItem',title:'������Ŀ',width:80},
		        {field:'Comments',title:'ע��',width:80},
		        {field:'Status',title:'״̬',width:80},
		        {field:'OnsetDateText',title:'��������',width:80},
		        {field:'LastUpdateUser',title:'�������û�',width:80},
		        {field:'LastUpdateDate',title:'����������',width:80},
		        {field:'tag',title:'��������',width:80},
		        ]]
		   
		  });

	}
//ҽ������
function getOrder(){
	var OrdType= $("#queryOrdType").combobox("getValue")
	var OrdTypeText= $("#queryOrdType").combobox("getText")
	if (OrdType=="") {
		$.messager.alert("��ʾ","��ѡ�����÷�ʽ!");
		return;	
	} 

	OrdType=OrdType.split("+")
	OrdTypeText=OrdTypeText.split("+")
	var rowsData = $(comid).datagrid('getSelections')
	if (rowsData.length=="0") {
		$.messager.alert("��ʾ","��ѡ��һ����¼!");
		return;	
	} 
	var info="";
	for(var i=0;i<rowsData.length;i++){
		var lineInfo = "" // ������
		for(var j =0;j<OrdType.length;j++){
			var colume=OrdType[j]
			if(lineInfo==""){	
				lineInfo=OrdTypeText[j]+":"+rowsData[i][colume];
			}else{
				lineInfo=lineInfo+","+OrdTypeText[j]+":"+rowsData[i][colume];
				}
			
		}	
		if(info==""){
			info=lineInfo;
			}else{
			info=info+";"+lineInfo;
			
			}
	}
	window.clipboardData.setData('Text',info);
	$.messager.alert("��ʾ","�����ã�ճ���ȿɣ�");
}

//ҽ�����
function ipmonitor(){
	var url = "dhcpha.inpha.ipmonitor.csp"
	window.open (url, "newwindow", "height=550, width=950, toolbar =no,top=100,left=300,menubar=no, scrollbars=yes, resizable=yes, location=no,status=no");

	}
/// ��ӻ�ȡ���˲˵���Ϣ����
function dhcadvdhcsys_getmenuform(){
	var frm = null;
	try{
		var win=top.frames['eprmenu'];
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if(frm) return frm;
		}
		//���´��ڴ򿪵Ľ���
		win = opener;
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if (frm) return frm;
		}
		win = parent.frames[0];
		if (win){
			frm = win.document.forms["fEPRMENU"];
			if (frm) return frm;
		}
		if (top){
			frm =top.document.forms["fEPRMENU"];
			if(frm) return frm
		}
	}catch(e){}
	return frm;
}
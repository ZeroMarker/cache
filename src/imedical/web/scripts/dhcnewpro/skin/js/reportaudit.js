// Creator: congyue
/// CreateDate: 2017-07-28
//  Descript: �����¼����� ��˽���
var url = "dhcadv.repaction.csp";
var statShare = [{ "val": "δ����", "text": "δ����" },{ "val": "����", "text": "����" }];
var statReceive = [{ "val": "δ����", "text": "δ����" },{ "val": "1", "text": "����" },{ "val": "2", "text": "����" },{ "val": "3", "text": "����" },{ "val": "4", "text": "���" },{ "val": "5", "text": "�鵵" },{ "val": "6", "text": "�����鵵" }];
var statusstr = [{ "value": "ȫ��", "text": "ȫ��" },{ "value": "1", "text": "�" },{ "value": "2", "text": "��ʿ�����" },{ "value": "3", "text": "�ƻ�ʿ�����" },{ "value": "4", "text": "�������" }];
var statOverTime = [{ "val": "Y", "text": "��ʱ" },{ "val": "N", "text": "δ��ʱ" }];
var Active = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
var editRow="",TranFlag=0,errflag=0 ;///TranFlag:ת����־   errflag:ת���ظ���Ա�뱻ת����Ա�Ƿ�һ��
var loceditRow=0;
var StrParam="";
var StDate="";  //formatDate(-7);  //һ��ǰ������   2018-01-26 �޸ģ�Ĭ�Ͽ�ʼ����Ϊ����ʹ�����ڣ���2018-01-01
var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
var audittitle="" ;
$(function(){ 
	if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //���꿪ʼ����
	}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
		StDate=2018+"-"+"01"+"-"+"01";  //���꿪ʼ����
	}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //���꿪ʼ����
	}
	//ȥ����������hxy 08-30
	$("#ConfirmAudit,#CancelAudit,#CancelReject,#CancelFile,#CancelCanFile").click(function(){
	 	$("#showalert").hide();
	});
	/*document.onkeydown = function(e){ 
    var ev = document.all ? window.event : e;
    	if(ev.keyCode==13) {
			commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
     	}
	}*/
	
	//����
	$('#receive').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:statReceive
	});

/* 	//����
	$('#dept').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=SelAllLoc'
		
	}); */
	
	var UserId="";
	if((LgGroupDesc=="����")||(LgGroupDesc=="Nursing Manager")){
		UserId="";
	}else{
		UserId=LgUserID;
	}
	$('#dept').combobox({ //  yangyongtao   2017-11-17
		mode:'remote',  //���������������
		onShowPanel:function(){ //GetSecuGroupCombox(UserId)
			$('#dept').combobox('reload','dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetSecuGroupCombox&UserId='+UserId+'&GroupId='+LgGroupID+'&LocId='+LgCtLocID+'')
		}
	});
	if(LgGroupDesc=="סԺ��ʿ"){
		$('#dept').combobox({disabled:true});;  //����ID
		$('#dept').combobox("setValue",LgCtLocID);     //����ID
		$("#dept").combobox('setText',LgCtLocDesc);
	}
	//�������������zhaowuqiang   2016-09-22
	$('#typeevent').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=SelEventbyNew'
		/* onSelect: function(rec){  
           var TypeStatus=rec.value; 
			ComboboxEvent(TypeStatus);        
	  } */	  
	}); 
	//���������״̬
    $('#status').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		//url:url+'?action=SelEvtStatusbyNew&params='+TypeStatus
		data:statusstr
	});
	//����״̬
	$('#Share').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:statShare
	});
	//��ʱ״̬
	$('#OverTime').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:statOverTime
	});
	//��ҳ �����������
	StrParam=getParam("StrParam");
	audittitle=getParam("audittitle");
	if(StrParam!=""){
		var tmp=StrParam.split("^");
		$("#stdate").datebox("setValue", tmp[0]);  //Init��ʼ����
		$("#enddate").datebox("setValue", tmp[1]);  //Init��������
		if(tmp[2]!=""){
			$('#dept').combobox({disabled:true});;  //����ID
			$('#dept').combobox("setValue",tmp[2]);     //����ID
			$("#dept").combobox('setText',LgCtLocDesc);
		}else{
			$('#dept').combobox("setValue",tmp[2]);     //����ID
			$("#dept").combobox('setText',"")
		}
		$('#status').combobox("setValue",tmp[7]);  //״̬
		$('#typeevent').combobox("setValue",tmp[8]);  //��������
		$('#receive').combobox("setValue",tmp[9]); //����״̬
		$('#Share').combobox("setValue",tmp[10]);  //����״̬ 
	
	}else{
		$("#stdate").datebox("setValue", StDate);  //Init��ʼ����
		$("#enddate").datebox("setValue", EndDate);  //Init��������
	}
	$('#audittitle').html("������˲�ѯ"+audittitle);
	if((LgGroupDesc=="����")||(LgGroupDesc=="Nursing Manager")){
		$('#Auditbttr').show();
	}else{
		$('#Auditbttr').hide();
	}
	
	$('#Refresh').bind("click",Query);  //ˢ��
	$('#Find').bind("click",Query);  //�����ѯ 
	$('#Export').bind("click",Export);  //�������(��̬����)
	$('#ExportWord').bind("click",ExportWord);  //�������(����ίwprd����)	
	$('#ExportExcel').bind("click",ExportExcel);  //�������(����ίexcel����)
	$('#ExportExcelAll').bind("click",ExportExcelAll);  //�������(ҽ�ܾ�excel����)
	$('#ExportAll').bind("click",ExportAll);  //�������(ȫ�����͹̶�����)
	$('#ExportGather').bind("click",ExportGather);  //�������(���ܰ�)
	$('#Print').bind("click",Print); //��ӡ
	$('#REceive').bind("click",REceive); //����
	//$('#Back').bind("click",Back); //���沵��
	
	$('#Reject').bind("click",BackBt); //���沵��  
	$('#Back').bind("click",RejectWin); //����
	
	$('#SHare').bind("click",Share); //����״̬  RepShareStatus
	$('#RepImpFlag').bind("click",RepImpFlag); //�ص��ע
	$('#Audit').bind("click",Audit); //���� Audit
	$('#ConfirmAudit').bind("click",ConfirmAudit); //ȷ������ ConfirmAudit
	$('#Transcription').bind("click",Transcription); //ת������	
	$('#File').bind("click",File); //�鵵����	
	$('#ConfirmFile').bind("click",ConfirmFile); //ȷ�Ϲ鵵 
	$('#ConfirmCanFile').bind("click",ConfirmCanFile); //ȷ�ϳ����鵵 
	$('#RepCancel').bind("click",RepCancel); //���� 
	$('#CaseShare').bind("click",CaseShare); //�������� 
	$('#RepDelete').bind("click",RepDelete); //ɾ�� 
	
	InitPatList();
	
	$("#reqList").height($(window).height()-245)//hxy 08-28 st
	$("#maindg").datagrid('resize', {           
		height : $(window).height()-245
    }); 
    window.onresize=resizeH;                    //hxy 08-28 ed
	$('#WardW').window('close');  //2018-01-12 cy ��ӷֹܿ���
});
//����Ӧ hxy 2017-08-28
function resizeH(){
	$("#reqList").height($(window).height()-245)
	$("#maindg").datagrid('resize', { 
            height : $(window).height()-245
    }); 
}
//���ݱ������Ͳ�ѯ  zhaowuqiang   2016-09-22
function ComboboxEvent(TypeStatus){
   //���������״̬
    $('#status').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=SelEvtStatusbyNew&params='+TypeStatus
	});    

}
//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"RepID",title:'RepID',width:80,hidden:true},
		{field:"recordID",title:'recordID',width:80,hidden:true},
		{field:'RepShareStatus',title:'����״̬',width:80,align:'center',hidden:true},
		{field:'Edit',title:'�鿴',width:60,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:'AuditList',title:'������ϸ',width:60,align:'center',formatter:setCellAuditList,hidden:false},
		{field:'StatusLast',title:'��һ״̬',width:100,hidden:true},
		{field:'StatusLastID',title:'��һ״̬ID',width:100,hidden:true},
		{field:"RepStaus",title:'����״̬',width:100,hidden:false},
		{field:"RepStausDr",title:'����״̬ID',width:90,hidden:true},
		{field:'StatusNext',title:'��һ״̬',width:100,hidden:true},
		{field:'StatusNextID',title:'��һ״̬ID',width:100,hidden:true},
		{field:'RepDate',title:'��������',width:100},
		{field:'Medadrreceive',title:'����״̬',width:100},
		{field:'Medadrreceivedr',title:'����״̬dr',width:80,hidden:true},
		{field:'PatID',title:'�ǼǺ�',width:100,hidden:false},		
		{field:'AdmNo',title:'������',width:100},
		{field:'PatName',title:'����',width:100},
		{field:'RepType',title:'��������',width:260},
		{field:'OccurDate',title:'��������',width:100},
		{field:'OccurLoc',title:'��������',width:130},
		{field:'LocDep',title:'����ϵͳ',width:150},
		{field:'RepLoc',title:'�������',width:130},	
		{field:'RepUser',title:'������',width:100},	
		{field:'RepTypeCode',title:'�������ʹ���',width:120,hidden:true},
		{field:'RepImpFlag',title:'�ص��ע',width:100,hidden:false},
		{field:'RepSubType',title:'����������',width:120,hidden:true},
		{field:'Subflag',title:'�ӱ��־',width:120,hidden:true},
		{field:'SubUserflag',title:'�ӱ��û���־',width:120,hidden:true},
		{field:'RepLevel',title:'�����¼�����',width:120,hidden:true},
		{field:'RepInjSev',title:'�˺����ض�',width:120,hidden:true},
		{field:'RepTypeDr',title:'��������Dr',width:120,hidden:true},
		{field:'StsusGrant',title:'��˱�ʶ',width:120,hidden:true},
		{field:'MedadrRevStatus',title:'����ָ��',width:120,hidden:true},
		{field:'StaFistAuditUser',title:'��������',width:120,hidden:true},
		{field:'BackAuditUser',title:'���ز�����',width:120,hidden:true},
		{field:'RepOverTimeflag',title:'���ʱ',width:120,hidden:false},
		{field:'AutOverTimeflag',title:'��ʿ����˳�ʱ',width:120,hidden:false},
		{field:'CaseShareLoclist',title:'�������',width:120,hidden:false},
		{field:'FileFlag',title:'�鵵״̬',width:80}

	]];
	
	//����datagrid
	$('#maindg').datagrid({
		toolbar: '#toolbar',//hxy add 08-28
		title:'', //hxy �����б�
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryAuditRepList'+'&StrParam='+StrParam,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		nowrap:false,
		//height:300,
		rowStyler:function(index,row){  
	        if ((row.StaFistAuditUser==LgUserName)||(row.BackAuditUser==LgUserName)){  
	            return 'background-color:red;';  
	        }  
    	},
        onSelect:function(rowIndex, rowData){  
        	var StsusGrant=rowData.StsusGrant; //���״̬ 2018-01-17
			var RepID=rowData.RepID;         //����ID
			var RepTypeCode=rowData.RepTypeCode;         //��������
			var params=RepID+"^"+RepTypeCode+"^"+LgUserID;
			var Subflag=rowData.Subflag;
			var SubUserflag=rowData.SubUserflag;
			if(StsusGrant=="1"){ //2018-01-17
				$('#Audit').attr('class','toolbar-auditUndo');
				$('#Audit').text(" �������");
            }else{
				$('#Audit').attr('class','toolbar-audit');
				$('#Audit').text(" ���");            
	        }
			if((Subflag==1)&&(SubUserflag==1)){
				$('#REceive').hide();
				$('#Back').hide();
				$('#RepImpFlag').hide();
				//$('#SHare').hide();
				$('#Audit').hide();
			}else{
				$('#REceive').show();
				$('#Back').show();
				$('#RepImpFlag').show();
				//$('#SHare').show();
				$('#Audit').show();
			}
			var RepImpFlag=rowData.RepImpFlag;    //�ص��ע
	        var RepShareStatus=rowData.RepShareStatus; //����״̬
        	
		    if ((RepImpFlag=="��ע")){
				$('#RepImpFlag').attr('class','toolbar-focusUndo');
				$('#RepImpFlag').text(" ȡ����ע");
		    }else{
				$('#RepImpFlag').attr('class','toolbar-focus');
				$('#RepImpFlag').text(" �ص��ע");
		    }
		    var FileFlag=rowData.FileFlag; //�鵵״̬
		    if ((FileFlag=="�ѹ鵵")){
				$('#File').attr('class','toolbar-fileUndo');
				$('#File').text(" �����鵵");
		    }else{
				$('#File').attr('class','toolbar-file');
				$('#File').text(" �鵵");
		    }
	    
		    /* if ((RepShareStatus=="����")){
				$('#SHare').attr('class','adv_sel_71');
				$('#SHare').text(" ��������");
			}else{
				$('#SHare').attr('class','adv_sel_7');
				$('#SHare').text(" ����");
			} */
		}  
	});
	if(StrParam==""){
		Query();
	}
	//initScroll("#maindg");//��ʼ����ʾ���������
}
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	if((audittitle!="")&&(LgGroupDesc=="סԺ��ʿ")){
		$('#dept').combobox("setValue",LgCtLocID);     //����ID
		$("#dept").combobox('setText',LgCtLocDesc);
	}
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	var status=$("#status").combobox('getValue');
	var typeevent=$('#typeevent').combobox('getValue');  //��������
	var receive=$('#receive').combobox('getValue');  //����״̬
	var statShare=$('#Share').combobox('getValue');  //����״̬ 
	var OverTime=$('#OverTime').combobox('getValue');  //����״̬
	if (LocID==undefined){LocID="";}
	if (status==undefined){status="";}
	if (typeevent==undefined){typeevent="";}
	if (receive==undefined){receive="";}
	if (statShare==undefined){statShare="";}
	if (OverTime==undefined){OverTime="";}
	var PatNo=$.trim($("#patno").val());
	
	var StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+receive+"^"+statShare+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+OverTime;
	//var StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+134+"^"+6+"^"+359+"^"+status+"^"+typeevent+"^"+receive+"^"+statShare;
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryAuditRepList',	
		queryParams:{
			StrParam:StrParam}
	});
	audittitle="";
	$('#audittitle').html("������˲�ѯ"+audittitle);
	//var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+"";
	//location.href=Rel;
}

///���ñ༭����
function setCellEditSymbol(value, rowData, rowIndex)
{
		var recordID=rowData.recordID;         //����д��¼ID
		var RepID=rowData.RepID                //����ID   yangyongtao 2017-11-28
		var RepStaus=rowData.RepStaus;         //��״̬
		var RepTypeDr=rowData.RepTypeDr;       //��������Dr
		var RepTypeCode=rowData.RepTypeCode;   //�������ʹ���
		var RepType=rowData.RepType;           //��������
		var StatusLast=rowData.StatusLast;     //������һ״̬
		var Medadrreceivedr=rowData.Medadrreceivedr; //����״̬dr
		var RepUser=rowData.RepUser  //������
		var StaFistAuditUser=rowData.StaFistAuditUser  //��������
		var BackAuditUser=rowData.BackAuditUser //���ز�����
		var editFlag=1;  //�޸ı�־  1�����޸� -1�������޸�   �����һ״̬Ϊ�ղ��ҽ���״̬�ǲ��أ�����״̬drΪ2��������޸�
		/* if((StatusLast!="")&&(RepUser!=LgUserName)&&(StaFistAuditUser!=LgUserName)){///&&(Medadrreceivedr!=2)
			editFlag=-1;
		} */
		
		if(((StatusLast!="")&&(StaFistAuditUser!=LgUserName)&&(LgGroupDesc=="סԺ��ʿ"))){///&&(Medadrreceivedr!=2)
			editFlag=-1;
		}
		if(((StatusLast=="")&&(RepUser!=LgUserName)&&(LgGroupDesc=="סԺ��ʿ"))){///&&(Medadrreceivedr!=2)
			editFlag=-1;
		}
		if((Medadrreceivedr==2)&&(StaFistAuditUser!=LgUserName)&&(BackAuditUser!=LgUserName)){
			editFlag=-1;
		}
		return "<a href='#' onclick=\"showEditWin('"+recordID+"','"+RepStaus+"','"+RepTypeDr+"','"+RepTypeCode+"','"+RepType+"','"+RepID+"','"+editFlag+"','"+Medadrreceivedr+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_8.png' border=0/></a>";
}

//�༭����
function showEditWin(recordID,RepStaus,RepTypeDr,RepTypeCode,RepType,RepID,editFlag,Medadrreceivedr)
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'����༭',
		collapsible:true,
		border:false,
		closed:"true",
		width:1350,    ///2017-11-23  cy  �޸ĵ��������С 1250
		height:600
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&RepID='+RepID+'&editFlag='+editFlag+'&adrReceive='+Medadrreceivedr+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
	//window.open("formrecorditmedit.csp?recordId="+rowsData.ID)
}

/*//��ӡ
function Print(){
	var rowsData = $("#maindg").datagrid('getSelections')
	if (rowsData.length!="1") {
		$.messager.alert("��ʾ","��ֻѡ��һ����¼!");
		return;	
	}
	window.open("formprint.csp?recordId="+rowsData[0].recordID);
}*/
//��ӡ
function Print(){
	var rowsData = $("#maindg").datagrid('getSelections')
	if (rowsData.length=="0") {
		$.messager.alert("��ʾ","��ѡ��һ����¼!");
		return;	
	} 
	for(i=0;i<rowsData.length;i++){
		var recordId = rowsData[i].recordID;
		var RepID = rowsData[i].RepID;
		var RepTypeCode= rowsData[i].RepTypeCode;
		printRepForm(RepID,RepTypeCode);
		
	}	
	//window.open("formprint.csp?recordId="+rowsData[0].recordID);
}

//����
function REceive()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	
	var RepFileFlag=""; //�鵵״̬ 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //�鵵״̬ 2018-01-23
		if (FileFlag=="�ѹ鵵"){
			RepFileFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert("��ʾ:","��ѡ��������ѹ鵵���棬���ܽ��գ�");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ���н��ղ���", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //��������ID
				var RepTypeCode=item.RepTypeCode;         //�������ʹ���
				var Medadrreceivedr=item.Medadrreceivedr;//����״̬dr
				var RepStausDr=item.RepStausDr //��ǰ״̬id
				var params=RepID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode+"^"+RepStausDr;   //������
				var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  ��ȡindexֵ 
				var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 ��ȡ�к�
				//alert(params);
				//��������
				$.post(url+'?action=REMataReport',{"params":params},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
					if(resobj.ErrCode < 0){
						$.messager.alert("��ʾ:","���մ���,����ԭ��:"+"<font style='color:red;'>"+resobj.ErrMsg+"</font>");  //+"��"+errnum+"������"
					}
					
				});
			})
			$("#showalert").hide();
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
		}
	})
}
//���� 2018-01-17
function RejectWin()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("��ʾ:","���ز���,��ֻѡ��һ�����ݣ�");
		return;
	}
	var RepFileFlag="",RepBackFlag="" //�鵵״̬ 2018-01-23  �Ƿ���Բ��ر�ʶ�����ϵı��治�ܽ��в��ز����� 2018-04-08
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //�鵵״̬ 2018-01-23
		var StatusNextID=item.StatusNextID; //������һ״̬ID 2018-04-08
		if (FileFlag=="�ѹ鵵"){
			RepFileFlag="-1";
		}
		if(StatusNextID==""){
			RepBackFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert("��ʾ:","��ѡ��������ѹ鵵���棬���ܲ��أ�");
		return;
	}
	if (RepBackFlag=="-1"){
		$.messager.alert("��ʾ:","��ѡ��������������ϵı��棬���ܲ��أ�");
		return;
	}
	var RepStausDr=selItems[0].RepStausDr //��ǰ״̬id
	$("#showalert").show();//hxy 08-30 ��ʾ��Ӱ��
	$('#RetWin').window({
		title:'����',
		collapsible:false,
		border:false,
		closed:false,
		minimizable:false,
		maximizable:false,
		closable:false,
		width:400,
		height:280
	}); 
	//����ָ�� ״̬
	$('#RevStatus').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetRevStatusCombox&EvenCode='+"NursingRep"
	});
	if ((LgGroupDesc!="����")&&(LgGroupDesc!="Nursing Manager")){
		$('#RevStatus').combobox({disabled:true});;  //����ָ��
		$('#RevStatus').combobox('setValue',RepStausDr);  //����ָ��
	}
	$('#RetWin').window('open'); 
	$("#retreason").empty(); 
}

//ȷ�ϲ��� 2018-01-17
function BackBt()
{
	var NextLoc="";
	var LocAdvice="";
	var Retreason=$('#retreason').val();
	var RevStatus=$('#RevStatus').combobox('getValue');  //����ָ��
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("��ʾ:","���ز���,��ֻѡ��һ�����ݣ�");
		return;
	}
	if (RevStatus==""){
		$.messager.alert("��ʾ:","��ѡ�񲵻�ָ��");
		return;
	}
	if ($('#RevStatus').combobox('getText')=="�������"){
		$.messager.alert("��ʾ:","����δ��ˣ�����ָ����Ϊ������ˣ�");
		return;
	}
	if (Retreason==""){
		$.messager.alert("��ʾ:","����д���������");
		return;
	}
	var RepID=selItems[0].RepID;         //����ID
	var RepTypeCode=selItems[0].RepTypeCode;         //�������ʹ���
	var Medadrreceivedr=selItems[0].Medadrreceivedr;//����״̬dr			
	var RepStausDr=selItems[0].RepStausDr //��ǰ״̬id
	var params=RepID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode+"^"+RepStausDr+"^"+Retreason+"^"+RevStatus;   //������
	runClassMethod("web.DHCADVCOMMONPART","ReportBack",{'params':params},
			function(jsonString){ 
				//var resobj = jQuery.parseJSON(jsonString);
				//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
				if(jsonString.ErrCode < 0){
					$.messager.alert("��ʾ:","���ش���,����ԭ��:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"��"+errnum+"������"
				}
	},"json");
	
	$('#maindg').datagrid('reload'); //���¼���
	$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
	$('#RetWin').window('close');
	$("#showalert").hide();
}

//����
function Share(){
var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("��ʾ:","�������,��ֻѡ��һ�����ݣ�");
		return;
	}
	var RepID=selItems[0].RepID;         //����ID
	var RepTypeCode=selItems[0].RepTypeCode;         //�������ʹ���
	var RepShareStatus=selItems[0].RepShareStatus;//����״̬				
	var RepStausDr=selItems[0].RepStausDr //��ǰ״̬id
	var params=RepID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+RepTypeCode+"^"+RepStausDr+"^"+RepShareStatus   //������

  	var Sharemessage=""
     if(RepShareStatus=="δ����"){
	     Sharemessage="����";
	} 
	if(RepShareStatus=="����"){
	     Sharemessage="ȡ������";
	}
	$.messager.confirm("��ʾ", "�Ƿ����"+Sharemessage+"����", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			//��������
			$.post(url+'?action=InsRepShare',{"params":params},function(jsonString){
				var resobj = jQuery.parseJSON(jsonString);
				if(resobj.ErrCode < 0){
					$.messager.alert("��ʾ:","�������,����ԭ��:"+"<font style='color:red;'>"+resobj.ErrMsg+"</font>");
				}
			});
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
		}
	})
}

//�ص��ע
function RepImpFlag()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
   	if (selItems.length>1){
		$.messager.alert("��ʾ:","��ע����,��ֻѡ��һ�����ݣ�");
		return;
	}
	var RepID=selItems[0].RepID;         //����ID
	var RepTypeCode=selItems[0].RepTypeCode;         //�������ʹ���
    var RepImpFlag=selItems[0].RepImpFlag;    //�ص���
  	var Impmessage=""
    if(RepImpFlag=="δ��ע"){
	     RepImpFlag="N";
	     Impmessage="��ע";
	} 
	if(RepImpFlag=="��ע"){
	     RepImpFlag="Y";
	     Impmessage="ȡ����ע";
	}
	var Focusparams=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+RepTypeCode;
	//��ȡ�ص��עȨ��
	var FocusAuthority="";
	 $.ajax({  
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMON&MethodName=GetFocusAuthority'+'&params='+Focusparams, 	        
        async : false,	 // ע��˴���Ҫͬ������Ϊ���������ݺ���������ý���ĵ�һ��selected  
        type : "POST",  
        success : function(data) {       
        	FocusAuthority=data;
        }  
	});	
	if(FocusAuthority=="N"){
		$.messager.alert("��ʾ:","��"+Impmessage+"����Ȩ�ޣ�");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ����"+Impmessage+"����", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			//��������
			runClassMethod("web.DHCADVCOMMONPART","InsRepImp",{'RepID':RepID,'RepImpFlag':RepImpFlag},
				function(data){ 
					if (data!="0") {
						$.messager.alert("��ʾ:",Impmessage+"ʧ��!");
					}
				},"text");
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
		}
	})
}
//�������� 2018-01-17
function CancelAuditBt()
{	var NextLoc="" //$('#matadrNextLoc').combobox('getValue');
	var LocAdvice="" //$('#matadrLocAdvice').val();
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	var Medadrreceivedr=selItems[0].Medadrreceivedr;//����״̬
	if (Medadrreceivedr==1){
		$.messager.alert("��ʾ:","�����ѽ��ղ��ܳ�����ˣ�");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ���г�����˲���", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //����ID
				var RepTypeCode=item.RepTypeCode; //�������ʹ���
				var StatusLastID=item.StatusLastID; //��һ��״̬
				var Medadrreceivedr=item.Medadrreceivedr;//����״̬
				var StatusNext=item.StatusNext; //��һ��״̬
				var StaFistAuditUser=item.StaFistAuditUser; //��������
				
				if ((StaFistAuditUser!="")&(StaFistAuditUser!=LgUserName)){
					$.messager.alert("��ʾ:","����Ϊ���ر��棬��δ���ظ���ǰ��¼�ˣ���Ȩ�޳�����ˣ�");
					return;
				}
				var params=RepID+"^"+StatusLastID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode;   //������
				//��������
				runClassMethod("web.DHCADVCOMMONPART","CancelAuditReport",{'params':params},
				function(jsonString){ 
					//var resobj = jQuery.parseJSON(jsonString);
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
					if(jsonString.ErrCode < 0){
						$.messager.alert("��ʾ:","��˴���,����ԭ��:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"��"+errnum+"������"
					}
				},"json");								
			})
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
		}
	})
	
	
}
//���
function Audit()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
   	if (selItems.length>1){
		$.messager.alert("��ʾ:","��˲���,��ֻѡ��һ�����ݣ�");
		return;
	}
	var RepFileFlag=""; //�鵵״̬ 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //�鵵״̬ 2018-01-23
		if (FileFlag=="�ѹ鵵"){
			RepFileFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert("��ʾ:","��ѡ��������ѹ鵵���棬������ˣ�");
		return;
	}
	
	var RepTypeCode=selItems[0].RepTypeCode;         //�������ʹ���
    var RepStausDr=selItems[0].RepStausDr;    //��ǰ״̬ID
    var StsusGrant=selItems[0].StsusGrant; //���״̬ 2018-01-17
    if(StsusGrant=="1"){
	    CancelAuditBt();
	}else{
		$.each(selItems, function(index, item){
			$("#showalert").show();//hxy 08-30 ��ʾ��Ӱ��
			$('#Process').window({
				title:'���',
				collapsible:false,
				border:false,
				closed:false,
				minimizable:false,
				maximizable:false,
				closable:false,
				width:400,
				height:260
			});
			//ָ�����
			$('#matadrNextLoc').combobox({
				url:url+'?action=QueryAuditLocList&RepTypeCode='+RepTypeCode+'&CurStatusDR='+RepStausDr
			}); 
			if (RepTypeCode=="med"){
				$('#NextLocList').show();
			}else{
				$('#NextLocList').hide();
			}
			$('#Process').window('open'); 
			$("#matadrLocAdvice").empty(); 
		});
	}
}

//ȷ������
function ConfirmAudit()
{	
	var NextLoc=$('#matadrNextLoc').combobox('getValue');
	var LocAdvice=$('#matadrLocAdvice').val();
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if(LocAdvice=="")     // wangxuejian 2016-10-26
	{
		$.messager.alert("��ʾ:","�����������Ϊ�գ�");	
		return;
	}
	$.each(selItems, function(index, item){
		
		var RepID=item.RepID;         //����ID
		var RepTypeCode=item.RepTypeCode; //�������ʹ���
		var StatusNextID=item.StatusNextID; //��һ��״̬
		var Medadrreceivedr=item.Medadrreceivedr;//����״̬
		var params=RepID+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode;   //������
		//alert(params);
		var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  ��ȡindexֵ 
		var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 ��ȡ�к�
		runClassMethod("web.DHCADVCOMMONPART","AuditMataReport",{'params':params},
				function(jsonString){ 
					//var resobj = jQuery.parseJSON(jsonString);
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
					if(jsonString.ErrCode < 0){
						$.messager.alert("��ʾ:","��˴���,����ԭ��:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"��"+errnum+"������"
					}
		},"json");
		
	})
	$('#maindg').datagrid('reload'); //���¼���
	$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
	$('#Process').window('close');
}


//ת��  2016-05-13 ����
function Transcription()
{	
	//TranFlag=0;
	//��������
	$('#medadrUser').attr("disabled",false);
	$('#medadrDateTime').attr("disabled",false);
	$("#tranLocAdvic").attr("disabled",false);
	$("#medadrUser").val("");
	$("#medadrDateTime").val("");
	$("#tranLocAdvic").val("");
	$("#tranLocDr").combobox('setValue',"");
	$("#tranReplyMess").val("");

	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("��ʾ:","ת������,��ֻѡ��һ�����ݣ�");
		return;
	}
	//$("#showalert").show();//hxy 08-30 ��ʾ��Ӱ��
	$('#TranWin').window({
		title:'ת��',
		collapsible:false,
		border:false,
		closed:false,
		width:900,
		height:480
	});
	$('#TranWin').window('open');
	$.each(selItems, function(index, item){
		
		var RepID=item.RepID;         //����ID
		var RepTypeCode=item.RepTypeCode;         //��������
		var params=RepID+"^"+RepTypeCode+"^"+LgUserID;
		var Subflag=item.Subflag;         //�ӱ��־
		var SubUserflag=item.SubUserflag;//��ǰ��¼��Ա������Ƿ�ƥ�䱻ָ����Ա�����
		TranUserList(RepID,RepTypeCode,SubUserflag);//ת��ָ����Ա
		TranLocUserList(RepID,RepTypeCode,SubUserflag);//ת��������Ա�����Ϣ
		if(SubUserflag==0){
			//��������
			//var time=
			getDateTime(); //2016-10-08 congyue
			$('#medadrUser').attr("disabled",false);
			$('#medadrDateTime').attr("disabled",false);
			$("#tranLocAdvic").attr("disabled",false);
			$("#medadrUser").val(LgUserName);//��ʾת����(��ǰ��½��)
			$("#medadrUser").attr("disabled",true);
			$("#medadrDateTime").attr("disabled",true);
			$("#tranLocAdvic").val("");
			$("#tranLocDr").combobox('setValue',"");
			$("#tranReplyMess").val("");
			$("#tranReply").hide();
			$("#tranReplyMess").hide();	
			$("#replyFlag").hide();//�Ƿ�ת���ظ�

		}
		$.ajax({
			type: "POST",// ����ʽ
	    	url: url,
	    	data: "action=SearchAuditMess&params="+params,
			success: function(data){
				var tmp=data.split("^");
				if(SubUserflag==1){
					$('#medadrUser').val(tmp[0]); //������Ա
					$('#medadrUser').attr("disabled","true");
					$('#medadrDateTime').val(tmp[1]+" "+tmp[2]);   //����ʱ��
					$('#medadrDateTime').attr("disabled","true");
					$('#tranLocAdvic').val(tmp[3]); //�������
					$('#tranLocAdvic').attr("disabled","true");
					$("#tranReply").show();
			        $("#tranReplyMess").show();
			        $("#replyFlag").show();//�Ƿ�ת���ظ�
					//var UserID=rowData.UserID;
					if ((tmp[5]!=LgUserID)&(tmp[6]!=LgCtLocID)){
						errflag=1;
						$("#tranLocDr").combobox('setValue',"");
					}else{
						errflag=0;
					}
		
				}
				else{
					errflag=0;
				}
			}
		});
		if(SubUserflag==1){
			$('#transub').hide();
			$('#tranreply').show();
			$('#tranrec').show();
	
		}else{
			$('#transub').show();
			$('#tranreply').hide();
			$('#tranrec').hide();
	    }
   });
	
}
//ת��ָ����Ա
function TranUserList(RepID,RepTypeCode,SubUserflag)
{
	//ת������
	$('#tranLocDr').combobox({
		url:url+'?action=GetQueryLoc&RepTypeCode='+RepTypeCode,
		onSelect:function(){
			var tranLocDr=$('#tranLocDr').combobox('getValue');
			$('#selectdg').datagrid({
				url:url+'?action=GetUserDr',	
				queryParams:{
					params:RepTypeCode+"^"+tranLocDr}
			});
		}
	}); 
	//����columns
	var usercolumns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:"LocID",title:'LocID',width:90,hidden:true},
		{field:"Locname",title:'Locname',width:90,hidden:true},
		{field:"UserID",title:'UserID',width:90,hidden:true},
		{field:'Username',title:'������Ա',width:120}
	]];
	var titleNotes="";
	if(SubUserflag==1){
		titleNotes="";
	}else{
		titleNotes='<span style="font-size:10pt;font-family:���Ŀ���;color:red;">[˫���м��������ת����Ϣ��]</span>';
	}
	var params=RepID+"^"+RepTypeCode;
	//����datagrid
	$('#selectdg').datagrid({
		title:'ָ����Ա'+titleNotes,
		url:url+'?action=QueryUserMess&paramsuser='+params,
		fit:true,
		rownumbers:true,
		columns:usercolumns,
		border:false,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){ 
			if((SubUserflag==1)){ //(SubUserflag==1)||(TranFlag==1)
				$('#selectdg').datagrid({title:'ָ����Ա'});
				return;
			}else{
				$('#selectdg').datagrid({title:'ָ����Ա'+titleNotes});
				if ((editRow != "")||(editRow == "0")) {
	            	$("#selectdg").datagrid('endEdit', editRow);
				}
				var LocID=rowData.LocID;
				var UserID=rowData.UserID;
				var Username=rowData.Username;
			
				var tranLocDr=$('#tranLocDr').combobox('getValue');
				var tranLocDesc=$('#tranLocDr').combobox('getText');
				//2017-11-23 cy �ж�ת������Ϊ�ղ��������Ա
				if(tranLocDesc==""){
					$.messager.alert("��ʾ:","ת�����Ҳ���Ϊ�գ�");	
					return;
				}
				//2017-11-23 cy �ж������Ա�����ظ����
				var  dataList=$('#tranmesdg').datagrid('getData'); 
				for(var i=0;i<dataList.rows.length;i++){
					if(UserID==dataList.rows[i].nameID){
						$.messager.alert("��ʾ","����Ա����ӣ�"); 
						return ;
					}
				}				

				$('#tranmesdg').datagrid('insertRow',{
					 index: 0,	// index start with 0
					 row: {
						ID:"",
						name: Username,
						nameID: UserID,
						LocDesc: tranLocDesc,
						LocDr: tranLocDr
					}
		        });
		    }
		}
     
	});
}
//ת��������Ա�����Ϣ
function TranLocUserList(RepID,RepTypeCode,SubUserflag)
{
	//����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:"tranDateTime",title:'ת��ʱ��',width:90,hidden:true},
		{field:'tranuser',title:'ת����',width:120,hidden:true},
		{field:"tranuserID",title:'tranuserID',width:90,hidden:true},
		{field:'LocDesc',title:'����',width:120},
		{field:"LocDr",title:'LocDr',width:90,hidden:true},
		{field:'name',title:'��Ա',width:80},
		{field:"nameID",title:'nameID',width:90,hidden:true},
		{field:'LocAdvice',title:'�������',width:100},
		{field:'advice',title:'�ظ�����',width:100},
		{field:'DutyFlag',title:'��ע',width:200},
		{field:"tranreceive",title:'����״̬',width:90,hidden:true},
		{field:"tranrecedate",title:'��������',width:90,hidden:true},
		{field:"trancompdate",title:'�������',width:90,hidden:true}
	]];
	var titleOpNotes="";
	if(SubUserflag==1){
		titleOpNotes="";
	}else{
		titleOpNotes='<span style="font-size:10pt;font-family:���Ŀ���;color:red;">[˫���м��������������]</span>';
	}
	var params=RepID+"^"+RepTypeCode;
	//����datagrid
	$('#tranmesdg').datagrid({
		title:'ת����Ϣ��'+titleOpNotes,
		url:url+'?action=QueryTranLocUser&params='+params,
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
        nowrap:false,
		onDblClickRow:function(rowIndex, rowData){  //˫�����ѡ����
			if((SubUserflag==1)){ //(SubUserflag==1)||(TranFlag==1)
				return;
			}else{
				if((rowData.LocAdvice==undefined)||(rowData.LocAdvice=="")){
					$('#tranmesdg').datagrid('deleteRow',rowIndex);
				}else{
					alert("��ת��,����ɾ��");	
				}
			}
		}
	});	
	
}
//ת���ύ
function TranSub()
{
	/* if(TranFlag==1){
		$.messager.alert("��ʾ:","���ύ�ɹ��������ظ����");
		return;
	} */
	if(errflag==1){
		$.messager.alert("��ʾ:","��ת����ָ����Ա����Ȩ�޲���");
		return;
	}
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	var tranReplyMess=$('#tranReplyMess').val();
	var mediReceive="",mediRecDate="",mediRecTime="",mediCompleteDate="",mediCompleteTime="",medadrList="";	
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.each(selItems, function(index, item){
		var RepID=item.RepID;         //����ID
		var RepTypeCode=item.RepTypeCode; //�������ʹ���
		var Medadrreceivedr=item.Medadrreceivedr;//����״̬
		var StatusNextID=item.StatusNextID; //��һ��״̬
		var RepStausDr=item.RepStausDr //��ǰ״̬
		medadrList=RepID+"^"+RepTypeCode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+RepStausDr;   //������
	})		
	var rows = $("#tranmesdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].LocDr=="")||(rows[i].nameID=="")){
			$.messager.alert("��ʾ","����ָ�����Ա����Ϊ��!"); 
			return false;
		}
		if(tranLocAdvic==""){
			$.messager.alert("��ʾ","�����������Ϊ��!"); 
			return false;
		}
		var List=rows[i].ID+"^"+LgUserID+"^"+rows[i].LocDr+"^"+rows[i].nameID+"^"+tranReplyMess+"^"+mediReceive+"^"+mediRecDate+"^"+mediRecTime+"^"+mediCompleteDate+"^"+mediCompleteTime+"^"+tranLocAdvic;
		dataList.push(List);
	} 
	var medadriList=dataList.join("&&");
	var params="medadrList="+medadrList+"&medadriList="+medadriList; 

	//��������
	$.post(url+'?action=SaveTranMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode==0){
			//TranFlag=1;
			$.messager.alert("��ʾ:","�ύ�ɹ�");
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ $('#maindg').datagrid('clearSelections')  //2017-06-09 ���ȫѡ
			
		}
		if(resobj.ErrCode < 0){
			$.messager.alert("��ʾ:","ת���ύ����,����ԭ��:"+"<font style='color:red;'>"+resobj.ErrMsg+"</font>");
			return ;
		}
		//$('#selectdg').datagrid('reload'); //���¼���
		//$('#tranmesdg').datagrid('reload'); //���¼���
		
	});
	closeDrgWindow();		
}
//ת���ظ�
function TranReply(Replyflag)
{   var tranDutyFlag="N"  //ת��֮��δ�ظ�
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	var tranReplyMess=$('#tranReplyMess').val();
	if($("#reply").is(':checked')){
		tranDutyFlag="Y";
	}
	var medadriList=LgUserID+"^"+tranReplyMess+"^"+Replyflag+"^"+tranDutyFlag;
	
	var rows = $("#tranmesdg").datagrid('getRows');
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((Replyflag==1)&&(rows[i].advice!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert("��ʾ:","���ύ�ɹ��������ظ����");
			return false;
		}
		
		if((Replyflag==0)&&(rows[i].tranrecedate!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert("��ʾ:","�ѽ��ճɹ��������ظ����");
			return false;
		}
		if((Replyflag==0)&&(rows[i].advice!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert("��ʾ:","�ظ����ύ��������Ч");
			return false;
		}
	} 
	/* if((TranFlag==1)&(Replyflag==1)){
		$.messager.alert("��ʾ:","���ύ�ɹ��������ظ����");
		return;
	}
	if((TranFlag==2)&(Replyflag==0)){
		$.messager.alert("��ʾ:","�ѽ��ճɹ��������ظ����");
		return;
	}
	if((TranFlag==1)&(Replyflag==0)){
		$.messager.alert("��ʾ:","�ظ����ύ��������Ч");
		return;
	} */
	
	if((errflag==1)&(Replyflag==0)){
		$.messager.alert("��ʾ:","��ת����ָ����Ա����Ȩ�޲���");
		return;
	}
	if((Replyflag==1)&(tranReplyMess=="")){
		$.messager.alert("��ʾ:","�ظ��ύ�������ظ����ݲ���Ϊ��");
		return;
	}
	if((Replyflag==0)&(tranReplyMess!="")){
		$.messager.alert("��ʾ:","���ղ������ظ����ݲ���");
		return;
	}
	var selItems = $('#maindg').datagrid('getSelections');
	var medadrList="";
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.each(selItems, function(index, item){
		var RepID=item.RepID;         //����ID
		var RepTypeCode=item.RepTypeCode; //�������ʹ���
		var Medadrreceivedr=item.Medadrreceivedr;//����״̬
		var StatusNextID=item.StatusNextID; //��һ��״̬
		medadrList=RepID+"^"+RepTypeCode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID;   //������
		//var params="medadrList="+medadrList+"&medadriList="+medadriList; 
	})
	//alert(params);
	//��������
	$.post(url+'?action=SaveReplyMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode==0){
			if(Replyflag==1){
				//TranFlag=1;
				$('#maindg').datagrid('reload'); //���¼���
				$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ $('#maindg').datagrid('clearSelections')  //2017-06-09 ���ȫѡ
			}
			$.messager.alert("��ʾ:","�����ɹ�");
			   closeDrgWindow();	
		}
		if(resobj.ErrCode < 0){
			$.messager.alert("��ʾ:","��������,����ԭ��:"+"<font style='color:red;'>"+resobj.ErrMsg+"</font>");
		}
		//$('#selectdg').datagrid('reload'); //���¼���
		//$('#tranmesdg').datagrid('reload'); //���¼���
		
	});
}

//�ر�ת������
function closeDrgWindow()
{  
	$('#TranWin').window('close');
}

///����������ϸ����  
function setCellAuditList(value, rowData, rowIndex)
{
		var RepID=rowData.RepID;         //����ID
		var RepTypeCode=rowData.RepTypeCode; //�������ʹ���
		return "<a href='#' onclick=\"showAuditListWin('"+RepID+"','"+RepTypeCode+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/></a>";
}
//�༭����
function showAuditListWin(RepID,RepTypeCode)
{
	$('#Auditwin').window({
		title:'������ϸ',
		collapsible:true,
		border:false,
		closed:"true",
		width:900,
		height:500
	});
	var columns=[[
		{field:'Status',title:'����״̬',width:80},
		{field:'StatusDR',title:'����״̬ID',width:100,hidden:true},
		{field:'AuditUser',title:'������',width:100},
		{field:'AuditUserDR',title:'������ID',width:100,hidden:true},
		{field:'AuditDateTime',title:'����ʱ��',width:150},
		{field:'NextLoc',title:'����ָ��',width:150,hidden:true},
		{field:'NextLocDR',title:'����ָ��ID',width:100,hidden:true},
		{field:'LocAdvice',title:'�������/�������',width:280},
		{field:'Receive',title:'����״̬',width:60},
		{field:'RetStatus',title:'����ָ��',width:80},
		{field:'Subflag',title:'Subflag',width:60,hidden:true},
		{field:'ID',title:'ID',width:50,hidden:true} 
	]]; 
	
	// ����columns
	var itmcolumns=[[
		{field:'MedIAuditDateTime',title:'����ʱ��',width:150,hidden:false}, // yangyongtao 2017-11-20 ��������ʱ��
		{field:'MedIAuditUser',title:'������',width:100,hidden:false}, // yangyongtao 2017-11-20  ����������
		{field:'MedIAuditUserDR',title:'������ID',width:100,hidden:true},
		{field:'MedINextLoc',title:'ָ�����',width:150},
		{field:'MedINextLocDR',title:'����ָ��ID',width:100,hidden:true},
		{field:'MedILocAdvice',title:'�������',width:200},
		{field:'MedINextUser',title:'ָ����Ա',width:100},
		{field:'MedINextUserDR',title:'ָ����ԱID',width:100,hidden:true},
		{field:'MedIUserAdvice',title:'��Ա���',width:200},
		{field:'MedIReceive',title:'����״̬',width:60},
		{field:'DutyFlag',title:'��ע',width:200},
		{field:'MedIReceiveDateTime',title:'����ʱ��',width:150},
		{field:'MedICompleteDateTime',title:'���ʱ��',width:150}
	]];
	var params=RepID+"^"+RepTypeCode;
	//����datagrid
	$('#AuditListdg').datagrid({
		url:url+'?action=QueryAuditMess&params='+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		//fitColumns:true,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
        view: detailview,
        subGrid: true,
        nowrap:false,
        detailFormatter:function(index,rowData){
	         if(rowData.Subflag==0) return "";
             return '<div style="padding:0px"><table class="AuditItmListdg"></table></div>';
        },
        onExpandRow:function(index,rowData){
          	var AuditID=rowData.ID;
            var Subflag=rowData.Subflag;
            if(Subflag==0){
	         	return;   
	         }
            if (Subflag==1){
            var AuditItmListdg = $(this).datagrid('getRowDetail',index).find('table.AuditItmListdg');
            AuditItmListdg.datagrid({
				url:url+'?action=QueryAudItmMess&params='+AuditID,
				columns:itmcolumns,
                singleSelect:false,
                rownumbers:true,
				loadMsg: '���ڼ�����Ϣ...',
                height:'auto',
                nowrap:false,
		        onResize:function(){
                    $('#AuditListdg').datagrid('fixDetailRowHeight',index);
                },
                onLoadSuccess:function(){
					setTimeout(function(){
						$('#AuditListdg').datagrid('fixDetailRowHeight',index);
                    },0);
                }
            });
            $('#AuditListdg').datagrid('fixDetailRowHeight',index);
	      } 
        },
        onLoadSuccess:function(data){
			var me = this;
			$(me).parent().find('span.datagrid-row-expander').trigger('click'); //ûЧ��ע���޸������ѡ����
		}
	});
	$('#Auditwin').window('open');
	
}
//��ȡ����ʱ�� 2016-10-08 congyue
function getDateTime(){
	var tmp="";
	var time="";
  		$.ajax({
	  	async: false,
		type: "POST",// ����ʽ
    	url: url,
    	data: "action=GetDealDateTime",
		success: function(data){
		var tmp=data.split("^");
		$('#medadrDateTime').val(tmp[0]+" "+tmp[1]);   //����ʱ��
		}
  	}); 
}
///����ҳ
function Gologin(){
	location.href='dhcadv.homepage.csp';
}
//2016-10-10
function CloseWinUpdate(){
	$('#win').window('close');
}

function cleanInput(){
	var StDate=formatDate(-7);  //һ��ǰ������
	var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
	$("#stdate").datebox("setValue", StDate);  //Init��ʼ����
	$("#enddate").datebox("setValue", EndDate);  //Init��������
	$('#dept').combobox('setValue',"");     //����ID
	$("#status").combobox('setValue',"");
	$('#typeevent').combobox('setValue',"");;  //��������
	$('#receive').combobox('setValue',"");;  //����״̬
	$('#Share').combobox('setValue',"");;  //����״̬

   //���������״̬
   	var par="";
    $('#status').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=SelEvtStatusbyNew&params='+par
	});    
	$("#patno").val("");
}

// ����word ����ί
function ExportWord()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('��ʾ',"<font style='color:red;font-weight:bold;font-size:20px;'>����ѡ��һ�м�¼!</font>","error");
		return;
	}
	//$.messager.confirm("��ʾ", "�Ƿ���е�������", function (res) {//��ʾ�Ƿ�ɾ��
		//if (res) {
			var filePath=browseFolder();
			if (typeof filePath=="undefined"){
				$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
				return;
			}
       var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	     if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		 	$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		 	return;
	     }

	    for(i=0;i<selItems.length;i++){
				var recordId = selItems[i].recordID;
				var RepID = selItems[i].RepID;
				var RepTypeCode= selItems[i].RepTypeCode;
				var RepType= selItems[i].RepType;
				ExportWordData(RepID,RepTypeCode,RepType,filePath);
		
			}	
	    
			$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
		//}
	//})
}
// ����Excel ����ί
function ExportExcel()
{
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
		return;
	}
  var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		return;
	}
	var Staticflag=ExportExcelStatic(StDate,EndDate,filePath);
	if(Staticflag==true){
	$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
	}else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	}
}
// ����Excel ҽ�ܾ�
function ExportExcelAll()
{

	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var typeevent=$('#typeevent').combobox('getText');  //��������
	if((typeevent=="")||(typeevent=="ȫ��")){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����屨������,���ԣ�</font>","error");
		return;
	}
	if((typeevent.indexOf("ҽ��") >= 0)){
		$.messager.alert("��ʾ:","������û��ҽ�ܾ���Ҫ���ݣ���ѡ����������","error");
		return;
	}
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
		return;
	}
  var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		return;
	}
	var Allflag=ExportExcelAllData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
	$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
	}else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	}
}
// ����(��̬)
function Export()
{
	var typeevent=$('#typeevent').combobox('getValue');  //��������
	if((typeevent=="")||(typeevent=="ȫ��")){
		$.messager.alert("��ʾ:","��ѡ����屨������","error");
		return;
	}
	//formNameID==##class(web.DHCADVCOMMONPART).GetFormNameID
	runClassMethod("web.DHCADVCOMMONPART","GetFormNameID",{"AdrEvtDr":typeevent},
	function(ret){
		formNameID=ret
	},'text',false);
	//���崦�ڴ�״̬,�˳�
	if(!$('#ExportWin').is(":visible")){
		$('#ExportWin').window('open');
		//initDatagrid();
		reloadAllItmTable(formNameID);
		$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
		return;
	} 
	
	$('#ExportWin').window({
		title:'����',
		collapsible:false,
		border:false,
		closed:false,
		width:800,
		height:480
	});
	$('#ExportWin').window('open');
	initDatagrid();
	$("a:contains('���Ԫ��')").bind('click',addItm);
    $("a:contains('ɾ��Ԫ��')").bind('click',delItm);
    $("a:contains('ȫ��ѡ��')").bind('click',selAllItm);
    $("a:contains('ȡ��ѡ��')").bind('click',unSelAllItm);
    $("a:contains('ȫ��ɾ��')").bind('click',delAllItm);

}

function initDatagrid(){
	var columns=[[
		{field:'FormDicID',title:'FormDicID',width:50,hidden:true},
		{field:'DicField',title:'DicField',width:100,hidden:true},
		{field:'DicDesc',title:'ȫ����',width:200}
	]];
	
	$("#allItmTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetSetFiel",
		queryParams:{
			ForNameID:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: '���ڼ�����Ϣ...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});	
	
	var setcolumns=[[
		{field:'FormDicID',title:'FormDicID',width:50,hidden:true},
		{field:'DicField',title:'DicField',width:100,hidden:true},
		{field:'DicDesc',title:'������',width:200}
	]];

	$("#setItmTable").datagrid({
		url:"",
		fit:true,
		rownumbers:true,
		columns:setcolumns,
		loadMsg: '���ڼ�����Ϣ...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});
	$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
	reloadAllItmTable(formNameID);
	reloadSetFielTable(formNameID);
		
}
///���Ԫ��
function addItm(){
	var datas = $("#allItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("��ʾ","δѡ��������ݣ�");
		return;	    
	}
	for(var i=0;i<datas.length;i++)
	{
		$('#setItmTable').datagrid('insertRow',{
			index:0,
			row:{
				FormDicID:datas[i].FormDicID,
				DicField:datas[i].DicField,
				DicDesc:datas[i].DicDesc
			}
		
		})
		var aindex=$('#allItmTable').datagrid('getRowIndex',datas[i]);
		$('#allItmTable').datagrid('deleteRow',aindex);

	} 

}
function delItm(){
	var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("��ʾ","δѡ���Ҳ����ݣ�");
		return;	    
	}
	for(var i=0;i<datas.length;i++)
	{
		var aindex=$('#setItmTable').datagrid('getRowIndex',datas[i]);
		$('#setItmTable').datagrid('deleteRow',aindex);
		$('#allItmTable').datagrid('insertRow',{
			index:0,
			row:{
				FormDicID:datas[i].FormDicID,
				DicField:datas[i].DicField,
				DicDesc:datas[i].DicDesc
			}
		})
	}
}

function delAllItm(){
	$("#setItmTable").datagrid("checkAll");
	delItm();
}
function selAllItm(){
	$("#allItmTable").datagrid("checkAll");
}
function unSelAllItm(){
	$("#allItmTable").datagrid("uncheckAll");
}
//reload ���ϱ�
function reloadAllItmTable(value){
	$("#allItmTable").datagrid('load',{
		ForNameID:value
	})
}

function reloadSetFielTable(value){
	$("#setItmTable").datagrid('load',{
		ForNameID:value
	})
}
///ˢ�� field��fieldVal
function reloadTopTable(){
	reloadSetFielTable(formNameID);
	reloadAllItmTable(formNameID);
}
function ExportOK(){
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var RepType=$('#typeevent').combobox('getText');  //��������
	var datas = $("#setItmTable").datagrid("getRows");
	if(datas.length<1){
		$.messager.alert("��ʾ","������Ϊ�գ�����ӵ����У�");
		return;	    
	}
	var fieldList = [],descList=[],tablefield=[],tabledesc=[];
	for(var i=0;i<datas.length;i++)
	{
		if (datas[i].DicField.indexOf("UlcerPart")>=0){
			tablefield.push(datas[i].DicField);
			tabledesc.push(datas[i].DicDesc);
		}else{
			fieldList.push(datas[i].DicField);
			descList.push(datas[i].DicDesc);
		}
	} 
	var TitleList=fieldList.join("#");
	var DescList=descList.join("#");
	var TabFieldList=tablefield.join("#");
	var TabDescList=tabledesc.join("#");
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		return;
	}
	var Allflag=ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList);
	if(Allflag==true){
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
		$('#ExportWin').window('close');
	}else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	} 
	
}
// ȫ������Excel 
function ExportAll()
{

	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var typeevent=$('#typeevent').combobox('getText');  //��������
	/* if((typeevent=="")||(typeevent=="ȫ��")){
		$.messager.alert("��ʾ:","��������Ϊ�գ���ѡ������","error");
		return;
	} */
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		return;
	}
	var Allflag=ExportAllData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
	}else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	}
}
// ����Excel ���ܰ�
function ExportGather()
{

	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var typeevent=$('#typeevent').combobox('getText');  //��������
	/* if((typeevent=="")||(typeevent=="ȫ��")){
		$.messager.alert("��ʾ:","��������Ϊ�գ���ѡ������","error");
		return;
	} */
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		return;
	}
	var Allflag=ExportGatherData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
	}else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	}
}

//��ȡ����Ȩ�ޱ�־  2018-01-17
function GetShareAuthority(ReportID,params)
{
	var ShareFlag="";
	$.ajax({
		type: "POST",
		url: "dhcadv.repaction.csp",
		async: false, //ͬ��
		data: "action=GetShareAuthority&ReportID="+ReportID+"&params="+params,
		success: function(val){
			ShareFlag=val.replace(/(^\s*)|(\s*$)/g,"");
		}
	});
	return ShareFlag ;
}
//�����鵵
function CancelFilewin()
{
	$("#showalert").show();//hxy 08-30 ��ʾ��Ӱ��
	$('#CanFileWin').window({
		title:'�����鵵',
		collapsible:false,
		border:false,
		closed:false,
		minimizable:false,
		maximizable:false,
		closable:false,
		width:400,
		height:270
	});
	$('#CanFileWin').window('open');
	//�鵵����
	$('#canfilereason').empty();
	

}
//ȷ�ϳ����鵵 2018-01-17
function ConfirmCanFile()
{	
	var canfilereason=$('#canfilereason').val();
	if (canfilereason==""){
		$.messager.alert("��ʾ:","�����鵵���鲻��Ϊ�գ�");
		return;
	}
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.each(selItems, function(index, item){
		var RepID=item.RepID;         //����ID
		var RepTypeCode=item.RepTypeCode; //�������ʹ���
		var RepStausDr=item.RepStausDr; //��ǰ״̬
		var auditparams=RepID+"^"+RepStausDr+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+""+"^"+canfilereason+"^"+6+"^"+RepTypeCode;   //������
		var fileparams=RepID+"^"+RepTypeCode+"^"+"N"+"^"+LgUserID;   //������
		
		//alert(auditparams+"hhhhh"+fileparams);
		//��������
		runClassMethod("web.DHCADVCOMMONPART","FileMataReport",{'auditparams':auditparams,'fileparams':fileparams},
				function(jsonString){ 
					//var resobj = jQuery.parseJSON(jsonString);
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
					if(jsonString < 0){
						$.messager.alert("��ʾ:","���泷���鵵ʧ��!");   ///+"��"+errnum+"������"
					}
		},"",false);
		
		
	})
	$('#maindg').datagrid('reload'); //���¼���
	$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
	$('#CanFileWin').window('close');
	$("#showalert").hide();
}
//�鵵
function File()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
   	if (selItems.length>1){
		$.messager.alert("��ʾ:","�鵵����,��ֻѡ��һ�����ݣ�");
		return;
	}
	
    var FileFlag=selItems[0].FileFlag; //�鵵״̬ 2018-01-23
    
    var winshowflag="";
    $.each(selItems, function(index, item){
		var StatusNextID=item.StatusNextID; //��һ��״̬
		var FileFlag=item.FileFlag; //�鵵״̬ 2018-01-23
		if((StatusNextID!="")||(FileFlag=="�ѹ鵵")){
			winshowflag=-1;
		}
	
	});
	
    if(FileFlag=="�ѹ鵵"){
	    CancelFilewin();
	}else{
		if(winshowflag=="-1"){
		$.messager.alert("��ʾ:","����ѡ������δ�����ɵı��棬����ϸ��鹴ѡ���ݣ�");
		return;
	}
		$("#showalert").show();//hxy 08-30 ��ʾ��Ӱ��
		$('#FileWin').window({
			title:'�鵵',
			collapsible:false,
			border:false,
			closed:false,
			minimizable:false,
			maximizable:false,
			closable:false,
			width:400,
			height:320
		});
		$('#FileWin').window('open');
		//�鵵����
		$('#filereason').empty();
		$('#UserCodeFile').val(LgUserCode);
		$('#UserCodeFile').attr("disabled","true");
		$('#passWordFile').val("");
		$('#UserCodeAudit').val("");
		$('#passWordAudit').val(""); 
	}
}

//ȷ�Ϲ鵵
function ConfirmFile()
{	
	var filereason=$('#filereason').val();
	if (filereason==""){
		$.messager.alert("��ʾ:","�鵵���鲻��Ϊ�գ�");
		return;
	}
	var UserCodeFile=$('#UserCodeFile').val();
	if (UserCodeFile==""){
		$.messager.alert("��ʾ:","�鵵��Ա����Ϊ�գ�");
		return;
	}
	var passWordFile=$('#passWordFile').val();
	if (passWordFile==""){
		$.messager.alert("��ʾ:","�鵵��Ա���벻��Ϊ�գ�");
		return;
	}
	var UserCodeAudit=$('#UserCodeAudit').val();
	if (UserCodeAudit==""){
		$.messager.alert("��ʾ:","������Ա����Ϊ�գ�");
		return;
	}
	var passWordAudit=$('#passWordAudit').val();
	if (passWordAudit==""){
		$.messager.alert("��ʾ:","������Ա���벻��Ϊ�գ�");
		return;
	}
	//�жϹ鵵��Ա�븴����Ա�Ƿ�Ϊͬһ��
	if(UserCodeFile==UserCodeAudit){
		$.messager.alert("��ʾ:","�鵵��Ա�븴����Ա������ͬ��");
		return;
	}
	var UserIDFile="",UserIDAudit="",ifFileflag="",ifAuditflag="";
	runClassMethod("web.DHCADVREPFILE","ConfirmPassWord",{ 'userCode':UserCodeFile,'passWord':passWordFile},
		function(data){ 
			if(data.split("^")[0] != 0){
				$.messager.alert("��ʾ:","�鵵��Ա��"+"<font style='color:red;'>"+data+"</font>");
				ifFileflag=-1;
			}else{
				UserIDFile = data.split("^")[1];   ///��������û�ID
			}
	},"",false);
	if (ifFileflag=="-1"){
		return;
	}
	
	runClassMethod("web.DHCADVREPFILE","ConfirmPassWord",{ 'userCode':UserCodeAudit,'passWord':passWordAudit},
		function(data){ 
			if(data.split("^")[0] != 0){
				$.messager.alert("��ʾ:","������Ա��"+"<font style='color:red;'>"+data+"</font>");  
				ifAuditflag=-1;
			}else{
				UserIDAudit = data.split("^")[1];   ///��������û�ID
			}
	},"",false);
	if (ifAuditflag=="-1"){
		return;
	}
		
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.each(selItems, function(index, item){
		
		var RepID=item.RepID;         //����ID
		var RepTypeCode=item.RepTypeCode; //�������ʹ���
		var RepStausDr=item.RepStausDr; //��ǰ״̬
		var Medadrreceivedr=item.Medadrreceivedr;//����״̬
		var auditparams=RepID+"^"+RepStausDr+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+""+"^"+filereason+"^"+5+"^"+RepTypeCode;   //������
		var fileparams=RepID+"^"+RepTypeCode+"^"+"Y"+"^"+UserIDFile+"^"+UserIDAudit;   //������
		
		//alert(auditparams+"hhhhh"+fileparams);
		var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  ��ȡindexֵ 
		var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 ��ȡ�к�
		runClassMethod("web.DHCADVCOMMONPART","FileMataReport",{'auditparams':auditparams,'fileparams':fileparams},
				function(jsonString){ 
					//var resobj = jQuery.parseJSON(jsonString);
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
					if(jsonString < 0){
						$.messager.alert("��ʾ:","����鵵ʧ��!");   ///+"��"+errnum+"������"
					}
		},"",false);
		
	})
	$('#maindg').datagrid('reload'); //���¼���
	$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
	$('#FileWin').window('close');
	$("#showalert").hide();
}
//����
function RepCancel()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	var RepFileFlag=""; //�鵵״̬ 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //�鵵״̬ 2018-01-23
		if (FileFlag=="�ѹ鵵"){
			RepFileFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert("��ʾ:","��ѡ��������ѹ鵵���棬�������ϣ�");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ�������ϲ���", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //��������ID
				var RepTypeCode=item.RepTypeCode;         //�������ʹ���
				var Medadrreceivedr=item.Medadrreceivedr;//����״̬dr
				var RepStausDr=item.RepStausDr //��ǰ״̬id
				var params=RepID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode+"^"+RepStausDr+"^"+"Y";   //������
				var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  ��ȡindexֵ 
				var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 ��ȡ�к�
				
				runClassMethod("web.DHCADVCOMMONPART","MataRepCancel",{'params':params},
				function(jsonString){ 
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
					if(jsonString.ErrCode < 0){
						$.messager.alert("��ʾ:","���ϴ���,����ԭ��:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");  //+"��"+errnum+"������"
					}
				},"json",false);
				
			})
			$("#showalert").hide();
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
		}
	})
}

// �༭��
var texteditor={
	type: 'validatebox'//���ñ༭��ʽ
	
}

///��ӹ���ָ�����
function CaseShare(){
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("��ʾ:","ֻ��ѡ��һ������,�����ԣ�");
		return;
	}
	var RepID=selItems[0].RepID;         //��������ID
	var RepTypeCode=selItems[0].RepTypeCode;         //�������ʹ���
	var params=RepID+"^"+RepTypeCode;
	$('#WardW').window('open');	
	//�Ƿ���ñ�־
	var activeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				
				var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'Active'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	//����
	var Eventeditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "val", 
			textField: "text",
			url:url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'',
			required:true,
			mode:'remote',  //,  //���������������
			onSelect:function(option){
				///��������ֵ
				
				var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareLoc'});
				$(ed.target).combobox('setValue', option.text); 
				var eds=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareLocDr'});
				$(eds.target).val( option.val); 
			} 
		}
	}
	// ����columns
	var columns=[[
		{field:"RepDr",title:'����ָ��',width:80,editor:texteditor,hidden:true},
		{field:'RepTypeCode',title:'״̬����',width:80,editor:texteditor,hidden:true},
		{field:"ShareLocDr",title:'����Dr',width:80,editor:texteditor,hidden:true},
		{field:"ShareLoc",title:'����',width:120,editor:Eventeditor},
		{field:'Active',title:'�Ƿ���',width:80,editor:activeEditor},
		{field:"ID",title:'ID',width:70,align:'center'}
	]];
	
	// ����datagrid
	$('#Warddg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCASESHARE&MethodName=QueryCaseShare'+'&params='+params+'&rows='+10+'&page='+1,
		//url:'',
		fit:true,
		rownumbers:true,
		columns:columns,  
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((loceditRow != "")||(loceditRow == "0")) {
            	$("#Warddg").datagrid('endEdit', loceditRow);
			}
            $("#Warddg").datagrid('beginEdit', rowIndex); 
            var ed=$("#Warddg").datagrid('getEditor',{index:rowIndex,field:'ShareLoc'});
            if(rowData.ShareLoc!=""){
	            $(ed.target).combobox({disabled:true});
	            $(ed.target).combobox('setValue',rowData.ShareLoc);
	        }else{
		        $(ed.target).combobox({disabled:false});
		    }
            loceditRow = rowIndex; 
        } 
        
	});
	/* $('#Warddg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCASESHARE&MethodName=QueryCaseShare'+'&params='+params+'&rows='+10+'&page='+1
	});	 */
	
}
/* ///��Ӱ�ȫС���Ա����-����
function addWardAdd(){
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("��ʾ:","ֻ��ѡ��һ������,�����ԣ�");
		return;
	}
	var RepID=selItems[0].RepID;         //��������ID
	var RepTypeCode=selItems[0].RepTypeCode;         //�������ʹ���
	commonAddRow({'datagrid':'#Warddg',value:{'RepDr':RepID,'RepTypeCode':RepTypeCode}})
	
}
 */
// ��������
function addWardAdd()
{	
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("��ʾ:","ֻ��ѡ��һ������,�����ԣ�");
		return;
	}
	var RepID=selItems[0].RepID;         //��������ID
	var RepTypeCode=selItems[0].RepTypeCode;         //�������ʹ���
	if(loceditRow>="0"){
		$("#Warddg").datagrid('endEdit', loceditRow);//�����༭������֮ǰ�༭����
	}
	var rows = $("#Warddg").datagrid('getChanges');
	var ShareLocDr=""
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ShareLoc=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!"); 
			return false;
		}
	} 
	$("#Warddg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		
		index: 0, // ������0��ʼ����
		row: {ID: '',RepDr:RepID,RepTypeCode: RepTypeCode,EventType:'',ShareLocDr:'',ShareLoc:'',Active: 'Y'}
	});
	
	$("#Warddg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	loceditRow=0;
}
// ����༭��
function saveSecuGUW()
{
	if(loceditRow>="0"){
		$("#Warddg").datagrid('endEdit', loceditRow);
	}
	var rows = $("#Warddg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ShareLoc=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].RepDr+"^"+rows[i].RepTypeCode+"^"+rows[i].ShareLocDr+"^"+rows[i].Active+"^"+LgUserID;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	runClassMethod("web.DHCADVCASESHARE","SaveCaseShare",{'DataList':rowstr},
	function(data){ 
		if(data==0){
			$.messager.alert('��ʾ','�����ɹ�');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ������','warning');
			return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
		}else {
			$.messager.alert('��ʾ','����ʧ��','warning');
			return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
		}
	},"",false);
	
	$('#WardW').window('close');
	$("#showalert").hide();
	$('#maindg').datagrid('reload'); //���¼���
	$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ

}
//ɾ��
function RepDelete()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	var RepFileFlag=""; //�鵵״̬ 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //�鵵״̬ 2018-01-23
		if (FileFlag=="�ѹ鵵"){
			RepFileFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert("��ʾ:","��ѡ��������ѹ鵵���棬����ɾ����");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ����ɾ������", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //��������ID
				runClassMethod("web.DHCADVCOMMONPART","DelRepData",{'RepID':RepID},
				function(data){ 
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
					if(data< 0){
						$.messager.alert("��ʾ:","ɾ��ʧ�ܣ�");  //+"��"+errnum+"������"
					}
				},"",false);
				
			})
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
		}
	})
}

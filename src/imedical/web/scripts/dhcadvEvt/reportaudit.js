// Creator: congyue
/// CreateDate: 2017-07-28
//  Descript: �����¼����� ��˽���
var url = "dhcadv.repaction.csp";
var statShare = [{ "val": "δ����", "text": $g("δ����") },{ "val": "����", "text": $g("����") }];
var statReceive = [{ "val": "δ����", "text": $g("δ����") },{ "val": "1", "text": $g("����") },{ "val": "2", "text": $g("����") },{ "val": "3", "text": $g("����") },{ "val": "4", "text": $g("���") },{ "val": "7", "text": $g("�鵵(������)") },{ "val": "5", "text": $g("�鵵") },{ "val": "6", "text": $g("�����鵵") }];
var statOverTime = [{ "val": "Y", "text": $g("��ʱ") },{ "val": "N", "text": $g("δ��ʱ") }];
var Active = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
var condArray= [{ "val": "and", "text": $g("����") },{ "val": "or", "text": $g("����") }]; //�߼���ϵ
var stateBoxArray= [{ "val": "=", "text": $g("����") },{ "val": ">", "text": $g("����") },{ "val": ">=", "text": $g("���ڵ���") },{ "val": "<=", "text": $g("С�ڵ���") },{ "val": "<", "text": $g("С��") }]; //����
var editRow="",TranFlag=0,errflag=0 ;///TranFlag:ת����־   errflag:ת���ظ���Ա�뱻ת����Ա�Ƿ�һ��
var loceditRow=0,StrParam="",audittitle="",curCondRow=1; // ����������޸ı�־, ��ѯ������, ��˲�ѯ����, �߼���ѯ���� ����
var StDate="";  //һ��ǰ������   2018-01-26 �޸ģ�Ĭ�Ͽ�ʼ����Ϊ����ʹ�����ڣ���2018-01-01
var EndDate=""; //ϵͳ�ĵ�ǰ����
var FileTimes=serverCall("web.DHCADVCOMMON","GetEmSysConfig",{"AdvCode":"FILETIMES","Params":LgParam})
var ColSort="",ColOrder=""; // ������ , �����־:desc ����   asc ����
var receiveflag="",impflag="",appauditflag="",backflag="";//��ҳ-���ձ�ʶ �ص��ע ��������ʶ �˻ر�ʶ
var auditflag="",inpfileflag="",homeAutOverTime=""; //��ҳ-�Ѵ����ʶ �鵵��ʶ ��ҳ�Ƿ�ʿ����˳�ʱ
$(function(){ 
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPageButton();         /// ���水ť����
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	InitPageStyle();          /// ��ʼ��ҳ����ʽ
});
/// ��ʼ������ؼ�����
function InitPageComponent(){
	$.messager.defaults = { ok: $g("ȷ��"),cancel: $g("ȡ��")};
	// ��ȡ��¼�� ��Ϣ
	runClassMethod("web.DHCADVCOMMONPART","GetRepUserInfo",{'UserID':LgUserID,'LocID':LgCtLocID,'HospID':LgHospID,'GroupID':LgGroupID},
	function(Data){ 
		LgGroupDesc=Data.GroupDesc;
		
	},"json",false);
	runClassMethod("web.DHCADVCOMMON","GetStaEndDate",{'LgParam':LgParam},function(data){
		var tmp=data.split("^"); 
		StDate=tmp[0];
		EndDate=tmp[1];
	},'',false);
	
	//����
	$('#receive').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:statReceive
	});
	// ����
	$('#dept').combobox({ 
		mode:'remote',  //���������������
		onShowPanel:function(){ 
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
	});
	
	//�������������
	$('#typeevent').combobox({
		url:url+'?action=SelEventbyNew&param='+LgParam,
		onSelect: function(rec){  
			var TypeStatus=rec.value; 
			ComboboxEvent(TypeStatus);  
		} 	  
	}); 
	//����״̬
	$('#Share').combobox({
		panelHeight:"auto",  
		data:statShare
	});
	//��ʱ״̬
	$('#OverTime').combobox({
		panelHeight:"auto", 
		data:statOverTime
	});
	//�߼���ϵ
	$('#condCombox').combobox({
		panelHeight:"auto", 
		data:condArray
	});
	//��ҳ �����������
	StrParam=getParam("StrParam");
	audittitle=getParam("audittitle");
	audittitle=decodeURI(decodeURI(audittitle));
	if(StrParam!=""){
		var tmp=StrParam.split("^");
		$('#stdate').combobox({disabled:true});
		$('#enddate').combobox({disabled:true});		
		$("#stdate").datebox("setValue", tmp[0]);  //Init��ʼ����
		$("#enddate").datebox("setValue", tmp[1]);  //Init��������
		if(tmp[2]!=""){
			$('#dept').combobox({disabled:true});  //����ID
			$('#dept').combobox("setValue",tmp[2]);     //����ID
			$("#dept").combobox('setText',LgCtLocDesc);
		}else{
			$('#dept').combobox("setValue",tmp[2]);     //����ID
			$("#dept").combobox('setText',"")
		}
		if(tmp[7]!=""){
			$('#status').combobox({disabled:true});
			$('#status').combobox("setValue",tmp[7]);  //״̬
		}
		if(tmp[8]!=""){
			$('#receive').combobox({disabled:true});
			$('#receive').combobox("setValue",tmp[9]); //����״̬
		}
		if(tmp[9]!=""){
			$('#typeevent').combobox({disabled:true});
			$('#typeevent').combobox("setValue",tmp[8]);  //��������
		}
		if(tmp[10]!=""){
			$('#Share').combobox({disabled:true});
			$('#Share').combobox("setValue",tmp[10]);  //����״̬ 
		}
		if(tmp[18]!=""){
			$('#OverTime').combobox({disabled:true});
			$('#OverTime').combobox("setValue",tmp[18]);  //��ʱ״̬
		}
   		
   		receiveflag=tmp[11];
		impflag=tmp[12];
		appauditflag=tmp[13];
		backflag=tmp[14];
		auditflag=tmp[15];
		inpfileflag=tmp[16];
		homeAutOverTime=tmp[18];
	
	}else{
		$("#stdate").datebox("setValue", StDate);  //Init��ʼ����
		$("#enddate").datebox("setValue", EndDate);  //Init��������
		if((LgCtLocDesc!="����")&&(LgCtLocDesc!="ҽ��")){
			//$('#dept').combobox("setValue",LgCtLocID);     //����ID  sufan 2020-12-09  ��Ʒ������
			//$("#dept").combobox('setText',LgCtLocDesc);
		}
		
	}
}
/// ���水ť����
function InitPageButton(){
	$('#audittitle').html($g("������˲�ѯ")+audittitle);
	
	$('#Refresh').bind("click",Query);  //ˢ��
	$('#Find').bind("click",Query);  //�����ѯ 
	$('#Export').bind("click",Export);  //�������(��̬����)
	$('#ExportWord').bind("click",ExportWordFile);  //�������(word����)	
	$('#ExportExcel').bind("click",ExportExcel);  //�������(����ίexcel����)
	$('#ExportExcelAll').bind("click",ExportExcelAll);  //�������(ҽ�ܾ�excel����)
	$('#ExportAll').bind("click",ExportAll);  //�������(ȫ�����͹̶�����)
	$('#ExportGather').bind("click",ExportGather);  //�������(���ܰ�)
	$('#Printhtml').bind("click",htmlPrint);  //�����ӡ  Print ʹ��html��ӡ
	$('#REceive').bind("click",REceive); //����
	$('#SHare').bind("click",Share); //����״̬  RepShareStatus
	$('#RepImpFlag').bind("click",RepImpFlag); //�ص��ע
	$('#File').bind("click",File); //�鵵����	
	$('#ConfirmFile').bind("click",ConfirmFile); //ȷ�Ϲ鵵 
	$('#ConfirmCanFile').bind("click",ConfirmCanFile); //ȷ�ϳ����鵵 
	$('#RepCancel').bind("click",RepCancel); //���� 
	$('#CaseShare').bind("click",CaseShare); //�������� 
	$('#RepDelete').bind("click",RepDelete); //ɾ�� 
	$('#Fish').bind("click",fish); //���ͼ
	$('#FileAudit').bind("click",FileAudit);		 //���˹鵵
	$('#RevFile').bind("click",RevFile);		 //ȷ�ϸ��˹鵵
	$("#addCondBTN").on('click',addCondition); // �߼���ѯ��������
	$("#Print").bind("click",Print);		 //�����Ĵ�ӡ
	$('#DeptConBtn').bind("click",DeptConBtn); // ����׷�ٷ�����ť 2020-02-13
}
/// ��ʼ��ҳ����ʽ
function InitPageStyle(){
	//ȥ����������hxy 08-30
	$("#ConfirmAudit,#CancelAudit,#CancelReject,#CancelFile,#CancelCanFile,#CancelAudFile").click(function(){
	 	$("#showalert").hide();
	});
	addCondition(); // �߼���ѯ��������
}
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
/// ��ʼ��ҳ��datagrid
function InitPageDataGrid()
{
	//����columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"RepID",title:'RepID',width:80,hidden:true},
		{field:"recordID",title:'recordID',width:80,hidden:true},
		{field:'Edit',title:$g('�鿴'),width:60,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:'AuditList',title:$g('������ϸ'),width:60,align:'center',formatter:setCellAuditList,hidden:false},
		{field:'PatOutFlag',title:$g('��ϸ׷��'),width:280,align:'center',formatter:setLinkList,hidden:false},
		{field:'TranList',title:$g('ת����ϸ'),width:60,align:'center',formatter:setTranList,hidden:false},
		{field:'StatusLast',title:$g('��һ״̬'),width:100,hidden:true},
		{field:'StatusLastID',title:$g('��һ״̬ID'),width:100,hidden:true},
		{field:"RepStaus",title:$g('����״̬'),hidden:false},
		{field:"RepStausDr",title:$g('����״̬ID'),width:90,hidden:true},
		{field:'StatusNext',title:$g('��һ״̬'),width:100,hidden:true},
		{field:'StatusNextID',title:$g('��һ״̬ID'),width:100,hidden:true},
		{field:'RepDate',title:$g('��������'),width:100,sortable:true},
		{field:'Medadrreceive',title:$g('����״̬'),width:100},
		{field:'Medadrreceivedr',title:$g('����״̬dr'),width:80,hidden:true},
		{field:'PatID',title:$g('�ǼǺ�'),width:100,hidden:false},		
		{field:'AdmNo',title:$g('������'),width:100,formatter:setPatientRecord},
		{field:'PatName',title:$g('����'),width:100},
		{field:'RepType',title:$g('��������'),width:260},
		{field:'OccurDate',title:$g('��������'),width:100},
		{field:'OccurLoc',title:$g('��������'),width:130},
		{field:'LocDep',title:$g('����ϵͳ'),width:150,hidden:true},
		{field:'RepLocDr',title:'RepLocDr',width:150,hidden:true},
		{field:'RepLoc',title:$g('�������'),width:130},	
		{field:'RepUser',title:$g('������'),width:100},	
		{field:'RepUserDr',title:'RepUserDr',width:150,hidden:true},	
		{field:'RepTypeCode',title:$g('�������ʹ���'),width:120,hidden:true},
		{field:'RepImpFlag',title:$g('�ص��ע'),width:100,hidden:false},
		{field:'RepSubType',title:$g('����������'),width:120,hidden:true},
		{field:'Subflag',title:$g('�ӱ��־'),width:120,hidden:true},
		{field:'SubUserflag',title:$g('�ӱ��û���־'),width:120,hidden:true},
		{field:'RepLevel',title:$g('�����¼�����'),width:120,hidden:true},
		{field:'RepInjSev',title:$g('�˺����ض�'),width:120,hidden:true},
		{field:'RepTypeDr',title:$g('��������Dr'),width:120,hidden:true},
		{field:'StsusGrant',title:$g('��˱�ʶ'),width:120,hidden:true},
		{field:'MedadrRevStatus',title:$g('����ָ��'),width:120,hidden:true},
		{field:'StaFistAuditUser',title:$g('��������'),width:120,hidden:true},
		{field:'BackAuditUser',title:$g('���ز�����'),width:120,hidden:true},
		{field:'RepOverTimeflag',title:$g('���ʱ'),width:120,hidden:false},
		{field:'AutOverTimeflag',title:$g('����ʱ'),width:120,hidden:false},
		{field:'CaseShareLoclist',title:$g('�������'),width:120,hidden:false},
		{field:'CaseShareUserlist',title:$g('�����û�'),width:120,hidden:false},
		{field:'CaseShareAdvicelist',title:$g('�������'),width:120,hidden:false},
		{field:'FileFlag',title:$g('�鵵״̬'),width:80},
		{field:'RepShareStatus',title:$g('����״̬'),width:80,align:'center',hidden:false},
		{field:'UserLeadflag',title:$g('�ƻ�ʿ����ʶ'),width:80,hidden:true},
		{field:'AdmID',title:$g('����ID'),width:80,hidden:true},
		{field:'RepAppAuditFlag',title:$g('��������ʶ'),width:80,hidden:true}

	]];
	
	//����datagrid
	$('#maindg').datagrid({
		toolbar: '#toolbar',//hxy add 08-28
		title:'', //hxy �����б�
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryAuditRepList'+'&StrParam='+StrParam+'&LgParam='+LgParam+'&ParStr='+"",
		fit:true,
		rownumbers:true,
		columns:columns,
		remoteSort:false,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		nowrap:true,
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
			if((Subflag==1)&&(SubUserflag==1)){
				$('#REceive').hide();
				$('#RepImpFlag').hide();
			}else{
				$('#REceive').show(); //2018-03-28 cy ȥ�����հ�ť
				$('#RepImpFlag').show();
			}
			
		    var FileFlag=JudgeIsOutCome(); //�鵵״̬
		    if(FileFlag==0){
			    $('#File').show();
			    $('#File').attr('class','toolbar-file');
				$('#File').text($g("�鵵"));
			}else if(FileFlag==1){ // 1���� �����ѹ鵵 ��ʾ�����鵵��ť
				$('#File').show();
				$('#File').attr('class','toolbar-fileUndo');
				$('#File').text($g("�����鵵"));
			}else if(FileFlag==2){ // 1����  �����ѳ����鵵 ��ʾ�鵵��ť
				$('#File').show();
				$('#File').attr('class','toolbar-file');
				$('#File').text($g("�鵵"));
			}else if(FileFlag==3){ // 2���� �����ѹ鵵  ��ʾ�������˹鵵��ť
				$("#File").hide();
				$("#FileAudit").show();
				$('#FileAudit').attr('class','toolbar-fileUndo');
				$('#FileAudit').text($g(" ��������"));
			}else if(FileFlag==4){ // 2���� �����ѹ鵵������ ��ʾ���˹鵵��ť�ͳ����鵵��ť
				$("#FileAudit").show();
				$('#FileAudit').attr('class','toolbar-fileUndo');
				$('#FileAudit').text($g("�鵵����"));
				$("#File").show();
				$('#File').attr('class','toolbar-fileUndo');
				$('#File').text($g("�����鵵"));
			}else if(FileFlag==5){ // 2���� �����ѹ鳷���鵵 ��ʾ�鵵��ť
				$("#File").show();
				$('#File').attr('class','toolbar-file');
				$('#File').text($g("�鵵"));
				$("#FileAudit").hide();

			}else{
				$("#FileAudit").hide();
			}
	        ButtonInfo();
	    },
        onUnselect:function(rowIndex, rowData){ 
        	ButtonInfo();
		},
		onSortColumn:function (sort,order){
			ColSort=sort;
			ColOrder=order;
			Query();
 		},onDblClickRow:function(rowIndex, rowData){ 
        	setCellEditSymbol("DblClick", rowData, rowIndex);
		}  
	});
	if(StrParam==""){
		Query();
	}
	//initScroll("#maindg");//��ʼ����ʾ���������
}
function GetParamList(){
	
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
	//StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+statShare+"^"+receive+"^^^^^^^"+OverTime+"^^^^^^2";
	StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+statShare+"^"+receive+"^"+receiveflag+"^"+impflag+"^"+appauditflag+"^"+backflag+"^"+auditflag+"^"+inpfileflag+"^"+OverTime+"^"+homeAutOverTime+"^^^^^2";
	return StrParam;
}
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	StrParam=GetParamList();
	var ColParam=ColSort+"^"+ColOrder;
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryAuditRepList',	
		queryParams:{
			StrParam:StrParam,
			LgParam:LgParam,
			ParStr:getParStr(),
			ColParam:ColParam}
	});
	//audittitle="";
	$('#audittitle').html($g("������˲�ѯ")+audittitle);
	//var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+"";
	//location.href=Rel;
}

///���ñ༭����
function setCellEditSymbol(value, rowData, rowIndex)
{
		var recordID=rowData.recordID;         //����д��¼ID
		var RepID=rowData.RepID;               //����ID   yangyongtao 2017-11-28
		var RepStaus=rowData.RepStaus;         //��״̬
		var RepStausDr=rowData.RepStausDr;     //��״̬Dr
		var RepTypeDr=rowData.RepTypeDr;       //��������Dr
		var RepTypeCode=rowData.RepTypeCode;   //�������ʹ���
		var RepType=rowData.RepType;           //��������
		var StatusLast=rowData.StatusLast;     //������һ״̬
		var Medadrreceivedr=rowData.Medadrreceivedr; //����״̬dr
		var StatusNextID=rowData.StatusNextIDaudit // StatusNextIDaudit Ϊƥ��Ȩ�޵���һ״̬  �滻 rowData.StatusNextID; //��һ״̬ID
		var StatusNext=rowData.StatusNext; 	   //��һ״̬
		var RepUser=rowData.RepUser ; 		   //������
		var RepUserDr=rowData.RepUserDr;   //������id
		var StaFistAuditUser=rowData.StaFistAuditUser;  //��������
		var BackAuditUser=rowData.BackAuditUser; //���ز�����
		var editFlag=rowData.IfRepEdit;  		//�޸ı�־  1�������޸�(����δ����˲����ұ���δ�鵵)���������������޸�
		var StsusGrant=rowData.StsusGrant; 		//��˱�ʶ
		var StatusLastID=rowData.StatusLastID;  //��һ��״̬
		var StaFistAuditUser=rowData.StaFistAuditUser; //��������
		var UserLeadflag=rowData.UserLeadflag;  //�ƻ�ʿ����ʶ
		var FileFlag=rowData.FileFlag;  			//�鵵��ʶ
		var RepAppAuditFlag=rowData.RepAppAuditFlag;  //��������ʶ
		var Medadrreceive=rowData.Medadrreceive;     //����״̬
		var RepLocDr=rowData.RepLocDr;				 //�ϱ�����		sufan 2019-06-24
		var SubUserflag=rowData.SubUserflag;     // ת���˱�־
		var AdmID=rowData.AdmID;     // ����id

		if((RepAppAuditFlag!=1)&&(Medadrreceivedr!=2)){
			editFlag=-1;
		}
		
		if((Medadrreceivedr==2)&&(StaFistAuditUser!=LgUserName)&&(BackAuditUser!=LgUserName)){
			editFlag=-1;
		}
		
		if((FileFlag.indexOf($g("�鵵")) > 0)&&(FileFlag!=$g("δ�鵵"))&&(FileFlag!=$g("�����鵵"))){
			editFlag=-1;
		}
		if(editFlag!="1"){
			editFlag=-1;
		}
		FileFlag=escape(FileFlag);  		//�鵵��ʶ
		RepStaus=escape(RepStaus);         //��״̬
		RepType=escape(RepType);           //��������
		StatusLast=escape(StatusLast);     //������һ״̬
		StatusNext=escape(StatusNext); 	   //��һ״̬
		RepUser=escape(RepUser) ; 		   //������
		StaFistAuditUser=escape(StaFistAuditUser);  //��������
		BackAuditUser=escape(BackAuditUser); //���ز�����
		Medadrreceivedr=escape(Medadrreceivedr); //����״̬dr
		Medadrreceive=escape(Medadrreceive);     //����״̬
		if(value!="DblClick"){  // 
			return "<a href='#' onclick=\"showEditWin('"+recordID+"','"+RepStaus+"','"+RepTypeDr+"','"+RepTypeCode+"','"+RepType+"','"+RepID+"','"+editFlag+"','"+RepStausDr+"','"+StatusNextID+"','"+Medadrreceivedr+"','"+FileFlag+"','"+StsusGrant+"','"+StatusLastID+"','"+StaFistAuditUser+"','"+UserLeadflag+"','"+RepAppAuditFlag+"','"+StatusNext+"','"+RepUser+"','"+Medadrreceive+"','"+RepLocDr+"','"+SubUserflag+"','"+AdmID+"')\"><img src='../scripts/dhcadvEvt/images/adv_sel_8.png' border=0/></a>";
		}else{
			showEditWin(recordID,RepStaus,RepTypeDr,RepTypeCode,RepType,RepID,editFlag,RepStausDr,StatusNextID,Medadrreceivedr,FileFlag,StsusGrant,StatusLastID,StaFistAuditUser,UserLeadflag,RepAppAuditFlag,StatusNext,RepUser,Medadrreceive,RepLocDr,SubUserflag,AdmID);
		}
}

//�༭����
function showEditWin(recordID,RepStaus,RepTypeDr,RepTypeCode,RepType,RepID,editFlag,RepStausDr,StatusNextID,Medadrreceivedr,FileFlag,StsusGrant,StatusLastID,StaFistAuditUser,UserLeadflag,RepAppAuditFlag,StatusNext,RepUser,Medadrreceive,RepLocDr,SubUserflag,AdmID)
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:$g('����༭'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		width:screen.availWidth-100,    ///2017-11-23  cy  �޸ĵ��������С 1250
		height:screen.availHeight-100
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&RepID='+RepID+'&editFlag='+editFlag+'&adrReceive='+Medadrreceivedr+'&RepStausDr='+RepStausDr+'&StatusNextID='+StatusNextID+'&FileFlag='+FileFlag+'&StsusGrant='+StsusGrant+'&StatusLastID='+StatusLastID+'&StaFistAuditUser='+StaFistAuditUser+'&UserLeadflag='+UserLeadflag+'&RepAppAuditFlag='+RepAppAuditFlag+'&StatusNext='+StatusNext+'&winflag='+2+'&RepUser='+RepUser+'&Medadrreceive='+Medadrreceive+'&RepLocDr='+RepLocDr+'&SubUserflag='+SubUserflag+'&AdmID='+AdmID+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
	//window.open("formrecorditmedit.csp?recordId="+rowsData.ID)
}

//����
function REceive()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	
	var RepFileFlag=""; //�鵵״̬ 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //�鵵״̬ 2018-01-23
		if (FileFlag==$g("�ѹ鵵")){
			RepFileFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert($g("��ʾ:"),$g("��ѡ��������ѹ鵵���棬���ܽ��գ�"));
		return;
	}
	$.messager.confirm($g("��ʾ"), $g("�Ƿ���н��ղ���"), function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //��������ID
				var RepTypeCode=item.RepTypeCode;         //�������ʹ���
				var Medadrreceivedr=item.Medadrreceivedr;//����״̬dr
				var RepStausDr=item.RepStausDr //��ǰ״̬id
				var params=RepID+"^"+RepStausDr+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode;   //������

				//var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  ��ȡindexֵ 
				//var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 ��ȡ�к�
				//alert(params);
				//��������
				runClassMethod("web.DHCADVCOMMONPART","REMataReport",{'params':params,'LgParam':LgParam},
				function(jsonString){ 
				//$.post(url+'?action=REMataReport',{"params":params},function(jsonString){
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
					if(jsonString.ErrCode < 0){
						$.messager.alert($g("��ʾ:"),$g("���մ���,����ԭ��:")+"<font style='color:red;'>"+$g(jsonString.ErrMsg)+"</font>");  //+"��"+errnum+"������"
					}
					
				});
			})
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
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("��ʾ:"),$g("���ز���,��ֻѡ��һ�����ݣ�"));
		return;
	}
	var RepFileFlag="",RepBackFlag="" //�鵵״̬ 2018-01-23  �Ƿ���Բ��ر�ʶ�����ϵı��治�ܽ��в��ز����� 2018-04-08
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //�鵵״̬ 2018-01-23
		var StatusNextID=item.StatusNextID; //������һ״̬ID 2018-04-08
		if (FileFlag==$g("�ѹ鵵")){
			RepFileFlag="-1";
		}
		if(StatusNextID==""){
			RepBackFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert($g("��ʾ:"),$g("��ѡ��������ѹ鵵���棬���ܲ��أ�"));
		return;
	}
	if (RepBackFlag=="-1"){
		$.messager.alert($g("��ʾ:"),$g("��ѡ��������������ϵı��棬���ܲ��أ�"));
		return;
	}
	var RepStausDr=selItems[0].RepStausDr //��ǰ״̬id
	$("#showalert").show();//hxy 08-30 ��ʾ��Ӱ��
	$('#RetWin').window({
		title:$g('����'),
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
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("��ʾ:"),$g("���ز���,��ֻѡ��һ�����ݣ�"));
		return;
	}
	if (RevStatus==""){
		$.messager.alert($g("��ʾ:"),$g("��ѡ�񲵻�ָ��"));
		return;
	}
	if ($('#RevStatus').combobox('getText')=="�������"){
		$.messager.alert($g("��ʾ:"),$g("����δ��ˣ�����ָ����Ϊ������ˣ�"));
		return;
	}
	if (Retreason==""){
		$.messager.alert($g("��ʾ:"),$g("����д���������"));
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
					$.messager.alert($g("��ʾ:"),$g("���ش���,����ԭ��:")+"<font style='color:red;'>"+$g(jsonString.ErrMsg)+"</font>");   ///+"��"+errnum+"������"
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
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("��ʾ:"),$g("�������,��ֻѡ��һ�����ݣ�"));
		return;
	}
	var RepID=selItems[0].RepID;         //����ID
	var RepTypeCode=selItems[0].RepTypeCode;         //�������ʹ���
	var RepShareStatus=selItems[0].RepShareStatus;//����״̬				
	var RepStausDr=selItems[0].RepStausDr //��ǰ״̬id
	var params=RepID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+RepTypeCode+"^"+RepStausDr+"^"+RepShareStatus   //������

  	var Sharemessage=""
     if(RepShareStatus==$g("δ����")){
	     Sharemessage=$g("����");
	} 
	if(RepShareStatus==$g("����")){
	     Sharemessage=$g("ȡ������");
	}
	$.messager.confirm($g("��ʾ"), $g("�Ƿ����")+$g(Sharemessage)+$g("����"), function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			//��������
			$.post(url+'?action=InsRepShare',{"params":params},function(jsonString){
				var resobj = jQuery.parseJSON(jsonString);
				if(resobj.ErrCode < 0){
					$.messager.alert($g("��ʾ:"),$g("�������,����ԭ��:")+"<font style='color:red;'>"+resobj.ErrMsg+"</font>");
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
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
   	if (selItems.length>1){
		$.messager.alert($g("��ʾ:"),$g("��ע����,��ֻѡ��һ�����ݣ�"));
		return;
	}
	var RepID=selItems[0].RepID;         //����ID
	var RepTypeCode=selItems[0].RepTypeCode;         //�������ʹ���
    var RepImpFlag=selItems[0].RepImpFlag;    //�ص���
  	var Impmessage=""
    if(RepImpFlag==$g("δ��ע")){
	     RepImpFlag="N";
	     Impmessage=$g("��ע");
	} 
	if(RepImpFlag==$g("��ע")){
	     RepImpFlag="Y";
	     Impmessage=$g("ȡ����ע");
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
		$.messager.alert($g("��ʾ:"),$g("��")+$g(Impmessage)+$g("����Ȩ�ޣ�"));
		return;
	}
	$.messager.confirm($g("��ʾ"), $g("�Ƿ����"+Impmessage+"����"), function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			//��������
			runClassMethod("web.DHCADVCOMMONPART","InsRepImp",{'RepID':RepID,'RepImpFlag':RepImpFlag},
				function(data){ 
					if (data!="0") {
						$.messager.alert($g("��ʾ:"),Impmessage+$g("ʧ��!"));
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
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	var Medadrreceivedr=selItems[0].Medadrreceivedr;//����״̬
	if (Medadrreceivedr==1){
		$.messager.alert($g("��ʾ:"),$g("�����ѽ��ղ��ܳ�����ˣ�"));
		return;
	}
	$.messager.confirm($g("��ʾ"), $g("�Ƿ���г�����˲���"), function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //����ID
				var RepTypeCode=item.RepTypeCode; //�������ʹ���
				var StatusLastID=item.StatusLastID; //��һ��״̬
				var Medadrreceivedr=item.Medadrreceivedr;//����״̬
				var StatusNext=item.StatusNext; //��һ��״̬
				var StaFistAuditUser=item.StaFistAuditUser; //��������
				
				if ((StaFistAuditUser!="")&(StaFistAuditUser!=LgUserName)){
					$.messager.alert($g("��ʾ:"),$g("����Ϊ���ر��棬��δ���ظ���ǰ��¼�ˣ���Ȩ�޳�����ˣ�"));
					return;
				}
				var params=RepID+"^"+StatusLastID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode;   //������
				//��������
				runClassMethod("web.DHCADVCOMMONPART","CancelAuditReport",{'params':params},
				function(jsonString){ 
					//var resobj = jQuery.parseJSON(jsonString);
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
					if(jsonString.ErrCode < 0){
						$.messager.alert($g("��ʾ:"),$g("��˴���,����ԭ��:")+"<font style='color:red;'>"+$g(jsonString.ErrMsg)+"</font>");   ///+"��"+errnum+"������"
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
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
   	if (selItems.length>1){
		$.messager.alert($g("��ʾ:"),$g("��˲���,��ֻѡ��һ�����ݣ�"));
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
		$.messager.alert($g("��ʾ:"),$g("��ѡ��������ѹ鵵���棬������ˣ�"));
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
				title:$g('���'),
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
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	if(LocAdvice=="")     // wangxuejian 2016-10-26
	{
		$.messager.alert($g("��ʾ:"),$g("�����������Ϊ�գ�"));	
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
						$.messager.alert($g("��ʾ:"),$g("��˴���,����ԭ��:")+"<font style='color:red;'>"+$g(jsonString.ErrMsg)+"</font>");   ///+"��"+errnum+"������"
					}
		},"json");
		
	})
	$('#maindg').datagrid('reload'); //���¼���
	$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
	$('#Process').window('close');
}

///����������ϸ����  
function setCellAuditList(value, rowData, rowIndex)
{
		var RepID=escape(rowData.RepID);         //����ID
		var RepTypeCode=escape(rowData.RepTypeCode); //�������ʹ���
		var RepUser=rowData.RepUser; // ������
		var RepUserFlag=0;
		if(RepUser==$g("����")){
			RepUserFlag=-1;
		}
		return "<a href='#' onclick=\"showAuditListWin('"+RepID+"','"+RepTypeCode+"','"+RepUserFlag+"')\"><img src='../scripts/dhcadvEvt/images/adv_sel_11.png' border=0/></a>";
}
//�༭����
/*function showAuditListWin(RepID,RepTypeCode)
{
	$('#Auditwin').window({
		title:'������ϸ',
		collapsible:true,
		collapsed:true, //hxy 2017-12-29
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
		{field:'LocAdvice',title:'�������/�������',width:280,formatter:transAdvice},
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
		{field:'MedILocAdvice',title:'�������',width:200,formatter:transAdvice},
		{field:'MedINextUser',title:'ָ����Ա',width:100},
		{field:'MedINextUserDR',title:'ָ����ԱID',width:100,hidden:true},
		{field:'MedIUserAdvice',title:'��Ա���',width:200,formatter:transAdvice},
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
	$("#Auditwin").window('expand'); //hxy 2017-12-29
	$('#Auditwin').window('open');
	
}*/

function showAuditListWin(RepID,RepTypeCode,RepUserFlag)
{
	if($('#winonline').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:$g('������ϸ'),
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		closed:"true",
		width:1100,
		height:500
	});
	$('#winonline').window('open');
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.exaappdetail.csp?RepID='+ RepID +'&RepTypeCode='+ RepTypeCode+'&RepUserFlag='+ RepUserFlag +'"></iframe>';
	$('#winonline').html(iframe);
	
	
}
/// qunianpeng 2018/1/3 ��ת����^    ��ת����"
function transAdvice(value, rowData, rowIndex){
	if (value != undefined) {
		value = value.replace(/\��/g,"^");
		return value.replace(/\��/g,'"');
	}
	return "";
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

/*// ����word ����ί
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
}*/
// ����Excel ����ί
function ExportExcel()
{
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert($g("��ʾ:"),"<font style='color:red;font-weight:bold;font-size:20px;'>"+$g("��ȡ��������")+"</font>","error");
		return;
	}
  var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert($g("��ʾ:"),"<font style='color:red;font-weight:bold;font-size:20px;'>"+$g("��ѡ����Ч·����,���ԣ�")+"</font>","error");
		return;
	}
	var Staticflag=ExportExcelStatic(StDate,EndDate,filePath);
	if(Staticflag==true){
	$.messager.alert($g("��ʾ:"),"<font style='color:green;font-weight:bold;font-size:20px;'>"+$g("������ɣ�����Ŀ¼Ϊ:")+filePath+"</font>","info");
	}/*else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	}*/
}
// ����Excel ҽ�ܾ�
function ExportExcelAll()
{

	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var typeevent=$('#typeevent').combobox('getText');  //��������
	if((typeevent=="")||(typeevent=="ȫ��")){
		$.messager.alert($g("��ʾ:"),"<font style='color:red;font-weight:bold;font-size:20px;'>"+$g("��ѡ����屨������,���ԣ�")+"</font>","error");
		return;
	}
	if((typeevent.indexOf("ҽ��") >= 0)){
		$.messager.alert($g("��ʾ:"),$g("������û��ҽ�ܾ���Ҫ���ݣ���ѡ����������"),"error");
		return;
	}
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert($g("��ʾ:"),"<font style='color:red;font-weight:bold;font-size:20px;'>"+$g("��ȡ��������")+"</font>","error");
		return;
	}
  var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert($g("��ʾ:"),"<font style='color:red;font-weight:bold;font-size:20px;'>"+$g("��ѡ����Ч·����,���ԣ�")+"</font>","error");
		return;
	}
	var Allflag=ExportExcelAllData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
	$.messager.alert($g("��ʾ:"),"<font style='color:green;font-weight:bold;font-size:20px;'>"+$g("������ɣ�����Ŀ¼Ϊ:")+filePath+"</font>","info");
	}/*else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	}*/
}
// ����(��̬)
function Export()
{
	var typeevent=$('#typeevent').combobox('getValue');  //��������
	if((typeevent=="")||(typeevent=="ȫ��")){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����屨������"),"error");
		return;
	}
	/// 2021-07-09 cy ������ϸ����
	var LinkID="",FormNameID="";
	runClassMethod("web.DHCADVCOMMONPART","GetFormNameID",{"AdrEvtDr":typeevent},
	function(ret){
		FormNameID=ret
	},'text',false);
	runClassMethod("web.DHCADVEXPFIELD","GetExpLinkID",{"FormNameDr":FormNameID,"HospDr":LgHospID},
	function(ret){
		LinkID=ret
	},'text',false);
	//���崦�ڴ�״̬,�˳�
	if(!$('#ExportWin').is(":visible")){
		$('#ExportWin').window('open');
		reloadAllItmTable(LinkID);
		$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
		return;
	} 
	
	$('#ExportWin').window({
		title:$g('����'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:false,
		width:800,
		height:480
	});
	$('#ExportWin').window('open');
	initDatagrid(LinkID);
	$("#cuidAdd").bind('click',addItm); //a:contains('���Ԫ��')
    $("#cuidDel").bind('click',delItm); //a:contains('ɾ��Ԫ��')
    $("#cuidSelAll").bind('click',selAllItm); //a:contains('ȫ��ѡ��')
    $("#cuidCanSel").bind('click',unSelAllItm); //a:contains('ȡ��ѡ��')
    $("#cuidDelAll").bind('click',delAllItm); //a:contains('ȫ��ɾ��')

}

function initDatagrid(LinkID){
	var columns=[[
		{field:'FormDicID',title:'FormDicID',width:50,hidden:true},
		{field:'DicField',title:'DicField',width:100,hidden:true},
		{field:'DicDesc',title:$g('ȫ����'),width:200}
	]];
	
	$("#allItmTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetSetFiel",
		queryParams:{
			LinkID:LinkID
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: $g('���ڼ�����Ϣ...'),
		rownumbers : false,
		pagination:false
	});	
	
	var setcolumns=[[
		{field:'FormDicID',title:'FormDicID',width:50,hidden:true},
		{field:'DicField',title:'DicField',width:100,hidden:true},
		{field:'DicDesc',title:$g('������'),width:200}
	]];

	$("#setItmTable").datagrid({
		url:"",
		fit:true,
		rownumbers:true,
		columns:setcolumns,
		loadMsg: $g('���ڼ�����Ϣ...'),
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});
	$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 		
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
		LinkID:value
	})
}
function ExportOK(){
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var RepType=$('#typeevent').combobox('getText');  //��������
	var datas = $("#setItmTable").datagrid("getRows");
	if(datas.length<1){
		$.messager.alert($g("��ʾ"),$g("������Ϊ�գ�����ӵ����У�"));
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
	var filePath="";
	ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList,StrParam,LgParam,getParStr());
	//var filePath=browseFolder();
	//if (typeof filePath=="undefined"){
	//	$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
	//	return;
	//}
  	//var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	//if ((filePath.match(re)=="")||(filePath.match(re)==null)){
	//	$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
	//	return;
	//}
	//var Allflag=ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList);
	//if(Allflag==true){
	//	$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
	//	$('#ExportWin').window('close');
	//}else{
	//	$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	//} 
	
}
// ȫ������Excel 
function ExportAll()
{

	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var typeevent=$('#typeevent').combobox('getText');  //��������
	ExportAllData(StDate,EndDate,typeevent,StrParam,LgParam,getParStr());
	
	/* if((typeevent=="")||(typeevent=="ȫ��")){
		$.messager.alert("��ʾ:","��������Ϊ�գ���ѡ������","error");
		return;
	} */
	/*var filePath=browseFolder();
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
	} */
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
		$.messager.alert($g("��ʾ:"),"<font style='color:red;font-weight:bold;font-size:20px;'>"+$g("��ȡ��������")+"</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert($g("��ʾ:"),"<font style='color:red;font-weight:bold;font-size:20px;'>"+$g("��ѡ����Ч·����,���ԣ�")+"</font>","error");
		return;
	}
	var Allflag=ExportGatherData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
		$.messager.alert($g("��ʾ:"),"<font style='color:green;font-weight:bold;font-size:20px;'>"+$g("������ɣ�����Ŀ¼Ϊ:")+filePath+"</font>","info");
	}/*else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	}*/
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
function CancelFilewin(flag)
{
	
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	var title=flag==1?$g("�����鵵"):$g("��������");
	$("#showalert").show();//hxy 08-30 ��ʾ��Ӱ��
	$('#CanFileWin').window({
		title:title,
		collapsible:false,
		border:false,
		closed:false,
		minimizable:false,
		maximizable:false,
		closable:false,
		width:600,
		height:400
	});
	$('#CanFileWin').window('open');
	
	///��ʼ���鵵�б�
	InitCancFileList(flag);
	
	//�鵵����
	$('#canfilereason').empty();
	

}

//�鵵
function File()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
   	if (selItems.length>1){
		$.messager.alert($g("��ʾ:"),$g("�鵵����,��ֻѡ��һ�����ݣ�"));
		return;
	}
	
    var FileFlag=selItems[0].FileFlag; //�鵵״̬ 2018-01-23
    
    var winshowflag="";
    $.each(selItems, function(index, item){
		var StatusNextID=item.StatusNextID; //��һ��״̬
		var FileFlag=item.FileFlag; //�鵵״̬ 2018-01-23
		if((StatusNextID!="")||(FileFlag==$g("�ѹ鵵"))){
			winshowflag=-1;
		}
	
	});
    if((JudgeIsOutCome()==1)||(JudgeIsOutCome()==4)){   //
	    CancelFilewin(1);
	    return;
	}else{
		if(winshowflag=="-1"){
		$.messager.alert($g("��ʾ:"),$g("����ѡ������δ�����ɵı��棬����ϸ��鹴ѡ���ݣ�"));
		return;
	}
		$("#showalert").show();//hxy 08-30 ��ʾ��Ӱ��
		$('#FileWin').window({
			title:$g('�鵵'),
			collapsible:false,
			border:false,
			closed:false,
			minimizable:false,
			maximizable:false,
			closable:false,
			resizable:false,
			width:600,
			height:310
		});
		$('#FileWin').window('open');
		//�鵵����
		$('#filereason').empty();
		$('#UserCodeFile').val(LgUserCode);
		$('#UserCodeFile').attr("disabled","true");
		$('#passWordFile').val("");
	}
}

//ȷ�Ϲ鵵
function ConfirmFile()
{	
	var filereason=$.trim($('#filereason').val());
	if (filereason==""){
		$.messager.alert($g("��ʾ:"),$g("�鵵���鲻��Ϊ�գ�"));
		return;
	}
	filereason= $_TrsSymbolToTxt(filereason); /// �����������	
	var UserCodeFile=$('#UserCodeFile').val();
	if (UserCodeFile==""){
		$.messager.alert($g("��ʾ:"),$g("�鵵��Ա����Ϊ�գ�"));
		return;
	}
	var passWordFile=$('#passWordFile').val();
	if (passWordFile==""){
		$.messager.alert($g("��ʾ:"),$g("�鵵��Ա���벻��Ϊ�գ�"));
		return;
	}
	var selItems = $('#maindg').datagrid('getSelections');
    var RepTypeCode=selItems[0].RepTypeCode; //�鵵״̬ 2018-01-23
	var UserIDFile="",UserIDAudit="",ifFileflag="",ifAuditflag="";
	runClassMethod("web.DHCADVREPFILE","ConfirmPassWord",{ 'userCode':UserCodeFile,'passWord':passWordFile,'RepTypeCode':RepTypeCode,'LgParam':LgParam},
		function(data){ 
			if(data.split("^")[0] != 0){
				$.messager.alert($g("��ʾ:"),$g("�鵵��Ա��")+"<font style='color:red;'>"+$g(data)+"</font>");
				ifFileflag=-1;
			}else{
				UserIDFile = data.split("^")[1];   ///��������û�ID
			}
	},"",false);
	if (ifFileflag=="-1"){
		return;
	}
	var UserIDAudit="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	var FileId=serverCall("web.DHCADVCOMMONPART","GetFileRecordId",{"RepID":selItems[0].RepID,"RepTypeDr":selItems[0].RepTypeDr,"flag":1})
	
	$.each(selItems, function(index, item){
		
		var RepID=item.RepID;         //����ID
		var RepTypeCode=item.RepTypeCode; //�������ʹ���
		var RepStausDr=item.RepStausDr; //��ǰ״̬
		
		var Medadrreceivedr=item.Medadrreceivedr;//����״̬
		var Auditnum=FileTimes>1?7:5;
		var auditparams=RepID+"^"+RepStausDr+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+""+"^"+filereason+"^"+Auditnum+"^"+RepTypeCode;   //������
		var fileparams=RepID+"^"+RepTypeCode+"^"+"01"+"^"+UserIDFile+"^"+UserIDAudit+"^"+FileId;   //������
		
		//alert(auditparams+"hhhhh"+fileparams);
		var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  ��ȡindexֵ 
		var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 ��ȡ�к�
		runClassMethod("web.DHCADVCOMMONPART","FileMataReport",{'auditparams':auditparams,'fileparams':fileparams},
				function(jsonString){ 
					if(jsonString < 0){
						$.messager.alert($g("��ʾ:"),$g("����鵵ʧ��!")+"ErrCode:"+jsonString);   ///+"��"+errnum+"������"
					}
		},"",false);
		
	})
	$('#maindg').datagrid('reload'); //���¼���
	$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
	$('#FileWin').window('close');
	$("#showalert").hide();
}
///�鵵����
function FileAudit()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
   	if (selItems.length>1){
		$.messager.alert($g("��ʾ:"),$g("�鵵����,��ֻѡ��һ�����ݣ�"));
		return;
	}
	
    var FileFlag=selItems[0].FileFlag; //�鵵״̬ 2018-01-23
    
    var winshowflag="";
    $.each(selItems, function(index, item){
		var StatusNextID=item.StatusNextID; //��һ��״̬
		var FileFlag=item.FileFlag; //�鵵״̬ 2018-01-23
		if((StatusNextID!="")||(FileFlag==$g("�ѹ鵵"))){
			winshowflag=-1;
		}
	
	});
    if(JudgeIsOutCome()==3){   
	    CancelFilewin(2);
	    return;
	}else{
		if(winshowflag=="-1"){
		$.messager.alert($g("��ʾ:"),$g("����ѡ������δ�����ɵı��棬����ϸ��鹴ѡ���ݣ�"));
		return;
	}
		$("#showalert").show();//hxy 08-30 ��ʾ��Ӱ��
		$('#RevFileWin').window({
			title:$g('�鵵����'),
			collapsible:false,
			border:false,
			closed:false,
			minimizable:false,
			maximizable:false,
			resizable:false,
			closable:false,
			width:600,
			height:310
		});
		$('#RevFileWin').window('open');
		//InitFileList();
		//�鵵����
		$('#filereasonaud').empty();
		$('#UserCodeAudit').val(LgUserCode);
		$('#UserCodeAudit').attr("disabled","true");
		$('#passWordAudit').val("");
	}
}

///ȷ�ϸ��˹鵵
function RevFile()
{
	var filereason=$.trim($('#filereasonaud').val());
	if (filereason==""){
		$.messager.alert($g("��ʾ:"),$g("���˹鵵���鲻��Ϊ�գ�"));
		return;
	}
	filereason = $_TrsSymbolToTxt(filereason); /// �����������
	var UserCodeFile=$('#UserCodeAudit').val();
	if (UserCodeFile==""){
		$.messager.alert($g("��ʾ:"),$g("���˹鵵��Ա����Ϊ�գ�"));
		return;
	}
	var passWordFile=$('#passWordAudit').val();
	if (passWordFile==""){
		$.messager.alert($g("��ʾ:"),$g("���˹鵵��Ա���벻��Ϊ�գ�"));
		return;
	}
	var selItems = $('#maindg').datagrid('getSelections');
    var RepTypeCode=selItems[0].RepTypeCode; //�鵵״̬ 2018-01-23
	var UserIDFile="",UserIDAudit="",ifFileflag="",ifAuditflag="";
	runClassMethod("web.DHCADVREPFILE","ConfirmPassWord",{ 'userCode':UserCodeFile,'passWord':passWordFile,'RepTypeCode':RepTypeCode,'LgParam':LgParam},
		function(data){ 
			if(data.split("^")[0] != 0){
				$.messager.alert($g("��ʾ:"),$g("���˹鵵��Ա��")+"<font style='color:red;'>"+$g(data)+"</font>");
				ifFileflag=-1;
			}else{
				UserIDFile = data.split("^")[1];   ///��������û�ID
			}
	},"",false);
	if (ifFileflag=="-1"){
		return;
	}
	var UserIDAudit="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	
	var FileId=serverCall("web.DHCADVCOMMONPART","GetFileRecordId",{"RepID":selItems[0].RepID,"RepTypeDr":selItems[0].RepTypeDr,"UserId":LgUserID,"flag":2})
	
	$.each(selItems, function(index, item){
		
		var RepID=item.RepID;         //����ID
		var RepTypeCode=item.RepTypeCode; //�������ʹ���
		var RepStausDr=item.RepStausDr; //��ǰ״̬
		var Medadrreceivedr=item.Medadrreceivedr;//����״̬
		var auditparams=RepID+"^"+RepStausDr+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+""+"^"+filereason+"^"+5+"^"+RepTypeCode;   //������
		var fileparams=RepID+"^"+RepTypeCode+"^"+"02"+"^"+UserIDFile+"^"+UserIDAudit+"^"+FileId;   //������
		
		//alert(auditparams+"hhhhh"+fileparams);
		var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  ��ȡindexֵ 
		var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 ��ȡ�к�
		runClassMethod("web.DHCADVCOMMONPART","FileMataReport",{'auditparams':auditparams,'fileparams':fileparams},
				function(jsonString){ 
					//var resobj = jQuery.parseJSON(jsonString);
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
					if(jsonString < 0){
						$.messager.alert($g("��ʾ:"),$g("���渴�˹鵵ʧ��!"));   ///+"��"+errnum+"������"
					}
		},"",false);
		
	})
	$('#maindg').datagrid('reload'); //���¼���
	$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
	$('#RevFileWin').window('close');
	$("#showalert").hide();
}
//����
function RepCancel()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	var RepFileFlag=""; //�鵵״̬ 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //�鵵״̬ 2018-01-23
		if (FileFlag==$g("�ѹ鵵")){
			RepFileFlag="-1";
		}
	})
	
	if (RepFileFlag=="-1"){
		$.messager.alert($g("��ʾ:"),$g("��ѡ��������ѹ鵵���棬�������ϣ�"));
		return;
	}
	$.messager.confirm($g("��ʾ"), $g("�Ƿ�������ϲ���"), function (res) {//��ʾ�Ƿ�ɾ��
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
						$.messager.alert($g("��ʾ:"),$g("���ϴ���,����ԭ��:")+"<font style='color:red;'>"+$g(jsonString.ErrMsg)+"</font>");  //+"��"+errnum+"������"
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
// �ı��༭��
var texteditors={
	type: 'text',//���ñ༭��ʽ
}

var adviceditor={
	type: 'textarea'//���ñ༭��ʽ
	
}
///��ӹ���ָ�����
function CaseShare(){
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("��ʾ:"),$g("ֻ��ѡ��һ������,�����ԣ�"));
		return;
	}
	var RepID=selItems[0].RepID;         //��������ID
	var RepTypeCode=selItems[0].RepTypeCode;         //�������ʹ���
	var params=RepID+"^"+RepTypeCode;
	CaseShareShow(params);
}
function CaseShareShow(params){
	$('#WardW').window({
			title:$g('��������'),
			collapsible:false,
			border:false,
			minimizable:false,
			maximizable:false,
			resizable:false,
			width:900,
			height:450
		});
	$('#WardW').window('open');	
	//�Ƿ���ñ�־
	var activeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			//required:true,
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
			//url:url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'',
			//required:true,
			mode:'remote',  //,  //���������������
			onSelect:function(option){
				///��������ֵ
				var eds=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareLocDr'});
				if($(eds.target).val()!=option.val){
					var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareUser'});
					$(ed.target).combobox('setValue',""); 
					var eds=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareUserDr'});
					$(eds.target).val("");
				}
				var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareLoc'});
				$(ed.target).combobox('setValue', option.text); 
				var eds=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareLocDr'});
				$(eds.target).val( option.val);
			},		
			onShowPanel:function(){
				var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareLoc'});
				var unitUrl=url+'?action=GetAllLocNewVersion&hospId='+LgHospID+''
				$(ed.target).combobox('reload',unitUrl);
			} 
		}
	}
	
   //�û�
	var Usereditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "val", 
			textField: "text",
			//url:url+'?action=GetLocUserList&LocDr='+4+'',
			//required:true,
			mode:'remote',  //,  //���������������
			onSelect:function(option){
			///��������ֵ
				var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareUser'});
				$(ed.target).combobox('setValue', option.text); 
				var eds=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareUserDr'});
				$(eds.target).val( option.val); 				
			},
			onShowPanel:function(){
				var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareLocDr'});
				var LocID = $(ed.target).val();
				var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareUser'});
				var unitUrl=url+'?action=GetLocUserList&LocDr='+LocID+''
				$(ed.target).combobox('reload',unitUrl);
			} 
		}
	}
		
	// ����columns
	var columns=[[
		{field:"RepDr",title:$g('����ָ��'),width:80,editor:texteditor,hidden:true}, 
		{field:'RepTypeCode',title:$g('״̬����'),width:80,editor:texteditor,hidden:true},
		{field:"ShareLocDr",title:$g('����Dr'),width:80,editor:texteditor,hidden:true},
		{field:"ShareLoc",title:$g('����'),width:200,editor:Eventeditor},		
		{field:"ShareUserDr",title:$g('�û�Dr'),width:80,editor:texteditors,hidden:true},
		{field:"ShareUser",title:$g('�û�'),width:140,editor:Usereditor},
		{field:"ShareAdvice",title:$g('���/Ŀ��'),width:350,editor:adviceditor},
		{field:'Active',title:$g('�Ƿ���'),width:80,editor:activeEditor},
		{field:"ID",title:'ID',width:70,align:'center',hidden:true}
	]];
	
	// ����datagrid
	$('#Warddg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCASESHARE&MethodName=QueryCaseShare'+'&params='+params,
		fit:true,
		rownumbers:true,
		columns:columns, 
		pageSize:10,  // ÿҳ��ʾ�ļ�¼����
		pageList:[10,20,40],   // ��������ÿҳ��¼�������б� 
	    singleSelect:true,
	    nowrap:false,
	    pagination:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((loceditRow != "")||(loceditRow == "0")) {
            	$("#Warddg").datagrid('endEdit', loceditRow);
			}
            $("#Warddg").datagrid('beginEdit', rowIndex); 
            var ed=$("#Warddg").datagrid('getEditor',{index:rowIndex,field:'ShareLoc'});
            if((rowData.ShareLoc!="")&&(rowData.ID!="")){
	            $(ed.target).combobox({disabled:true});
	            $(ed.target).combobox('setValue',rowData.ShareLoc);
	        }else{
		        $(ed.target).combobox({disabled:false});
		    }
		    
		    var ed=$("#Warddg").datagrid('getEditor',{index:rowIndex,field:'ShareUser'});
            if((rowData.ShareUser!="")&&(rowData.ID!="")){
	            $(ed.target).combobox({disabled:true});
	            $(ed.target).combobox('setValue',rowData.ShareUser);
	        }else{
		        $(ed.target).combobox({disabled:false});
		    }
		    var ed=$("#Warddg").datagrid('getEditor',{index:rowIndex,field:'ShareAdvice'});
		    $(ed.target).css("word-break","break-all");
            if((rowData.ShareAdvice!="")&&(rowData.ID!="")){
	            $(ed.target).val(rowData.ShareAdvice);
	            $(ed.target).attr("readonly","readonly");
	        }else{
		        $(ed.target).attr("readonly",false);
		    }
		    
            loceditRow = rowIndex; 
        }
        
	});
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
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("��ʾ:"),$g("ֻ��ѡ��һ������,�����ԣ�"));
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
			$.messager.alert($g("��ʾ"),$g("�б�����δ��д�����ʵ!")); 
			return false;
		}
	} 
	$("#Warddg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		
		index: 0, // ������0��ʼ����
		row: {ID: '',RepDr:RepID,RepTypeCode: RepTypeCode,EventType:'',ShareLocDr:'',ShareLoc:'',ShareUserDr:'',ShareUser:'',ShareAdvice:'',Active: 'Y'}
	});
	
	$("#Warddg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	loceditRow=0;
	var ed=$("#Warddg").datagrid('getEditor',{index:loceditRow,field:'ShareAdvice'});
	$(ed.target).css("word-break","break-all");
	
}
// ����༭��
function saveSecuGUW()
{
	if(loceditRow>="0"){
		$("#Warddg").datagrid('endEdit', loceditRow);
	}
	var rows = $("#Warddg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert($g("��ʾ"),$g("û�д���������!"));
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ShareLoc=="")){
			$.messager.alert($g("��ʾ"),$g("�б�����δ��д�����ʵ!")); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].RepDr+"^"+rows[i].RepTypeCode+"^"+rows[i].ShareLocDr+"^"+rows[i].Active+"^"+LgUserID+"^"+rows[i].ShareUserDr+"^"+rows[i].ShareAdvice;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	
	runClassMethod("web.DHCADVCASESHARE","SaveCaseShare",{'DataList':rowstr},
	function(data){ 
		if(data==0){
			$.messager.alert($g('��ʾ'),$g('�����ɹ�'));
		}else if ((data == -1)||((data == -2))){
			$.messager.alert($g('��ʾ'),$g('�����ظ�,���ʵ������'),'warning');
			return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
		}else {
			$.messager.alert($g('��ʾ'),$g('����ʧ��'),'warning');
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
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("��ʾ:"),$g("��ѡ��һ�����ݣ�"));
		return;
	}
	var RepFileFlag=""; //�鵵״̬ 2018-01-23
	var StatusLast=selItems[0].StatusLast; //������һ״̬
	var RepUserDr=selItems[0].RepUserDr; //������
	var Medadrreceivedr=selItems[0].Medadrreceivedr; //����״̬dr
	var FileFlag=selItems[0].FileFlag; //�鵵״̬ 2018-01-23
	
	if (FileFlag=="�ѹ鵵"){
		RepFileFlag="-1";
	}
	
	if (RepFileFlag=="-1"){
		$.messager.alert($g("��ʾ:"),$g("��ѡ��������ѹ鵵���棬����ɾ����"));
		return;
	}
	if (RepUserDr!=LgUserID){
		$.messager.alert($g("��ʾ:"),$g("����Ǳ����ϱ�������ɾ����"));
		return;
	}
	if (((StatusLast!="")||(Medadrreceivedr!="δ����"))&&(Medadrreceivedr!=2)){
		$.messager.alert($g("��ʾ:"),$g("�����ѱ����ջ���ˣ�����ɾ����"));
		return;
	}

	$.messager.confirm($g("��ʾ"), $g("�Ƿ����ɾ������"), function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //��������ID
				runClassMethod("web.DHCADVCOMMONPART","DelRepData",{'RepID':RepID},
				function(data){ 
					if(data< 0){
						$.messager.alert($g("��ʾ:"),$g("ɾ��ʧ�ܣ�"));  //+"��"+errnum+"������"
					}
				},"",false);
				
			})
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
		}
	})
}
//���ͼ cy 2018-08-03
function fish(){
	var selItems = $('#maindg').datagrid('getSelections');
	var RepID="",RepTypeCode=""
	if(selItems.length==1){
		RepID=selItems[0].RepID;//����ID
		RepTypeCode=selItems[0].RepTypeCode;//�������ʹ���/������Code
	}
	var RepType=$('#typeevent').combobox('getValue');  //��������
	if (((RepTypeCode=="")||(RepTypeCode==undefined))&&((RepType=="")||(RepType==undefined))){
		$.messager.alert($g("��ʾ:"),$g("��ѡ��һ�����ݻ���ѡ������������ԣ�"));
		return;
	}
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	
	var StrParamList=StDate+"^"+EndDate+"^"+RepTypeCode+"^"+RepType;
	if($('#fishwin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="fishwin"></div>');
	$('#fishwin').window({
		title:$g('���ͼ'),
		collapsible:false,
		border:false,
		minimizable:false,
		maximizable:false,
		closed:"true",
		width:1200,
		height:620
	});
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.fishbone.csp?RepID='+RepID+'&StrParam='+StrParamList+'"></iframe>';
	$('#fishwin').html(iframe);
	$('#fishwin').window('open');
}
//����  ����
function setPatientRecord(value, rowData, rowIndex)
{   
	var RepID=rowData.RepID;         //����ID
	var RepTypeCode=rowData.RepTypeCode; //�������ʹ���
	var Adm=rowData.AdmID
	var PatNo=rowData.AdmNo  //����״̬
	html = "<a href='#' onclick=\"LoadPatientRecord('"+rowData.PatID+"','"+Adm+"')\">"+PatNo+"</a>";
    return html;
   // return "<a href='#' mce_href='#' onclick='LoadPatientRecord("+rowData.PatID+","+Adm+");'>"+PatNo+"</a>";  
    
}
/// �����鿴
function LoadPatientRecord(PatID,Adm){
	//createPatInfoWin(Adm,PatID);
	
	if($('#winlode').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:$g('��������б�'),
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:"true",
		width:document.body.offsetWidth-100,
		height:document.body.offsetHeight-100
	});
	var frm=window.parent.document.forms["fEPRMENU"];
		if(frm.EpisodeID){
			frm.EpisodeID.value=Adm;
		} 
		
	//var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="websys.chartbook.hisui.csp?ChartBookName='+"DHC.inpatient.Doctor.DHCEMRbrowse"+"&PatientListPage="+ "inpatientlist.csp"+"&EpisodeID="+Adm+'"></iframe>';
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="websys.chartbook.hisui.csp?ChartBookName='+"DHC.Doctor.DHCEMRbrowse"+"&PatientListPage="+ "emr.browse.patientlist.csp"+"&SwitchSysPat=N"+"&EpisodeID="+Adm+'"></iframe>';
		$('#winlode').html(iframe);
		$('#winlode').window('open'); 
	
}


//����  ת������
function setPatOutForm(value, rowData, rowIndex)
{   
	var recordID=escape(rowData.recordID);         //���� recordID
	var RepID=escape(rowData.RepID);         //����ID	
	var PatOutFlag=escape(rowData.PatOutFlag);         // ת���ʶ
	
	if (PatOutFlag == "Y"){
		html = "<a href='#' onclick=\"LoadPatOutcomWin('"+RepID+"','"+recordID+"')\" >"+$g("��")+"</a>";
	}else{
		html = "<span>"+$g("��")+"</span>";
	}
    return html;
    
}

//�༭����  2018-05-07 cy ת�����
function LoadPatOutcomWin(RepID,recordID)
{
	if($('#patoutwin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="patoutwin"></div>');
	$('#patoutwin').window({
		title:$g('����ת��'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		width:800,    ///2017-11-23  cy  �޸ĵ��������С 1250
		height:400
	});
	var PatOutWinRecId="";
	 runClassMethod("web.DHCADVCOMMONPART","GetRecordId",
		{'LinkRecordId':recordID,
		 'FormCode':"PatOutcomform"},
		function(data){ 
			 PatOutWinRecId=data;
	},"text",false) 
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+PatOutWinRecId+'&code='+"PatOutcomform"+'&LinkRecordId='+recordID+'&RepID='+RepID+'"></iframe>'; 
	$('#patoutwin').html(iframe);
	$('#patoutwin').window('open');
}


window.onbeforeunload = onbeforeunload_handler;
/// ҳ��ر�֮ǰ����
function onbeforeunload_handler() {
    var frm=window.parent.document.forms["fEPRMENU"];
	if(frm.EpisodeID){
		frm.EpisodeID.value="";
	}
}
//html��ӡ
function htmlPrint(){

	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("��ʾ:"),$g("��ѡ��һ�����ݣ�"));
		return;
	}
	var RepID=selItems[0].RepID;//����ID
	var RepTypeCode=selItems[0].RepTypeCode;//�������ʹ���/������Code
	var recordID=selItems[0].recordID;//����¼IDrecordID
	var url="dhcadv.htmlprint.csp?RepID="+RepID+"&RepTypeCode="+RepTypeCode+"&recordID="+recordID+"&prtOrExp="+this.id

	//return;
	window.open(url,"_blank");
}
//�жϵ�¼���Ƿ��в�����ť��Ȩ�������ư�ť��ʾ������
function ButtonInfo(){
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$('#File').hide();
		$("#FileAudit").hide();
        $('#CaseShare').hide();
		$('#RepDelete').hide();
		$('#RepCancel').hide();
		$('#Fish').hide();
		$('#RepImpFlag').hide();
		$('#SHare').hide();
		return;
	}
	var FileOperSec="",CaseShareOperSec="",DeleteOperSec="",CancelOperSec="",FishOperSec="",RepImpFlagSec="",ShareFlagSec="";
	$.each(selItems, function(index, item){
		var RepTypeCode=item.RepTypeCode; //�������ʹ���
		var RepImpFlag=item.RepImpFlag;    //�ص��ע
		    if ((RepImpFlag==$g("��ע"))){
				$('#RepImpFlag').attr('class','toolbar-focusUndo');
				$('#RepImpFlag').text($g("ȡ����ע"));
		    }else{
				$('#RepImpFlag').attr('class','toolbar-focus');
				$('#RepImpFlag').text($g("�ص��ע"));
		    }
		//if((RepTypeCode=="advPipeOff")||(RepTypeCode=="advDrugUseErr")||(RepTypeCode=="advFallDownFill")||(RepTypeCode=="advSkinUlcer")){
        	FishOperSec="Y";
       // }
       
       var RepShareStatus=item.RepShareStatus;    // ����״̬
       if ((RepShareStatus==$g("����"))){
			$('#SHare').attr('class','adv_sel_71');
			$('#SHare').text($g("��������"));
		}else{
			$('#SHare').attr('class','adv_sel_7');
			$('#SHare').text($g("����"));
		}
       
		runClassMethod("web.DHCADVCOMMON","GetOperSecAll",{'RepTypeCode':RepTypeCode,'LgParam':LgParam},
		function(data){
			var tmp=data.split("^"); 
			// ����Ȩ��
			if((tmp[0]=="Y")&&(ShareFlagSec!="N")){
				ShareFlagSec="Y";
	        }else{
		        ShareFlagSec="N";
		    }
			//�ص��עȨ��
			if((tmp[1]=="Y")&&(RepImpFlagSec!="N")){
				RepImpFlagSec="Y";
	        }else{
		        RepImpFlagSec="N";
		    }
			//�鵵Ȩ��
			if((tmp[2]=="Y")&&(FileOperSec!="N")){
				FileOperSec="Y";
	        }else{
		        FileOperSec="N";
		    }
	        //��������Ȩ��
			if((tmp[3]=="Y")&&(CaseShareOperSec!="N")){
				CaseShareOperSec="Y";
	        }else{
		        CaseShareOperSec="N";
		    }
	        //ɾ��Ȩ��
			if((tmp[4]=="Y")&&(DeleteOperSec!="N")){
				DeleteOperSec="Y";
	        }else{
		        DeleteOperSec="N";
		    }
	        //����Ȩ��
			if((tmp[5]=="Y")&&(CancelOperSec!="N")){
				CancelOperSec="Y";
	        }else{
		        CancelOperSec="N";
		    }
		   	

		},"text",false);
		
	})
	// ����Ȩ��
	if(ShareFlagSec=="N"){
		$('#SHare').hide();
    }else{
		$('#SHare').show();
    }
	//�ص��עȨ��
	if(RepImpFlagSec=="N"){
		$('#RepImpFlag').hide();
    }else{
		$('#RepImpFlag').show();
    }
	//�鵵Ȩ��
	if(FileOperSec=="N"){
		$('#File').hide();
		$('#FileAudit').hide();
		
    }
    //��������Ȩ��
    if(CaseShareOperSec=="N"){
		$('#CaseShare').hide();
    }else{
		$('#CaseShare').show();
    }
    //ɾ��Ȩ��
    if(DeleteOperSec=="N"){
		$('#RepDelete').hide();
    }else{
		$('#RepDelete').show();
    }
    //����Ȩ��
    if(CancelOperSec=="N"){
		$('#RepCancel').hide();
    }else{
		$('#RepCancel').show();
    }
    //���ͼȨ��
	if(FishOperSec=="Y"){
		$('#Fish').show();
    }else{
		$('#Fish').hide();
    }
	
}
function InitFileList()
{
	var selItems = $('#maindg').datagrid('getSelections');
	
	var RepID=selItems[0].RepID;         	
	var RepTypeDr=selItems[0].RepTypeDr; 
	
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"FileId",title:'FileId',width:80,hidden:true},
		{field:"AuitUserId",title:'AuitUserId',width:80,hidden:true},
		{field:'AuitUser',title:$g('�鵵�û�'),width:80,align:'center'},
		{field:'FileFlagCode',title:'FileFlagCode',width:60,align:'center',hidden:true},
		{field:'FileFlag',title:$g('�鵵��ʶ'),width:60,align:'center'},
		{field:'FileDate',title:$g('�鵵����'),width:160,align:'center'},
		{field:'FileTime',title:$g('�鵵ʱ��'),width:100,align:'center'}
	]];
	//����datagrid
	$('#filelist').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryFileList&RepID='+RepID+'&RepTypeID='+RepTypeDr,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		nowrap:false
	});
}
///��ʼ���鵵�б�
function InitCancFileList(flag)
{
	var selItems = $('#maindg').datagrid('getSelections');
	
	var RepID=selItems[0].RepID;         	
	var RepTypeDr=selItems[0].RepTypeDr; 
	
	var columns=[[
		//{field:'ItemOpt',title:'����',width:60,align:'center',formatter:SetCanFileOpUrl},
		{field:"FileId",title:'FileId',width:80,hidden:true},
		{field:"AuitUserId",title:'AuitUserId',width:80,hidden:true},
		{field:'AuitUser',title:$g('�鵵�û�'),width:80,align:'center'},
		{field:'FileFlagCode',title:'FileFlagCode',width:60,align:'center',hidden:true},
		{field:'FileFlag',title:$g('�鵵��ʶ'),width:60,align:'center'},
		{field:'FileDate',title:$g('�鵵����'),width:160,align:'center'},
		{field:'FileTime',title:$g('�鵵ʱ��'),width:100,align:'center'}
	]];
	//����datagrid
	$('#cancelfilelist').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryFileList&RepID='+RepID+'&RepTypeID='+RepTypeDr+'&flag='+flag,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		nowrap:false
	});
}
/// ����
function SetCanFileOpUrl(value, rowData, rowIndex){
	
	if ((rowData.FileFlagCode == "11")||(rowData.FileFlagCode == "12")){
		 return "";
	}
	if ((rowData.FileFlagCode == "01")||(rowData.FileFlagCode == "02")){
		var html = "<a href='#' onclick='ConfirmFileNew("+rowIndex+","+rowData.FileFlagCode+")'>"+$g("����")+"</a>";
	}
    return html;
}
//ȷ�ϳ����鵵 
function ConfirmCanFile()
{
	var canfilereason=$('#canfilereason').val();
	if (canfilereason==""){
		$.messager.alert($g("��ʾ:"),$g("�����鵵���鲻��Ϊ�գ�"));
		return;
	}
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	var canitem=$('#cancelfilelist').datagrid('getRows');
	var flag=canitem[0].FileFlagCode;
	var FileFlag=flag=="01"?11:12;
	var Auditnum=flag=="01"?6:7;
	var FileId=canitem[0].FileId;
	var RepID=selItems[0].RepID;         //����ID
	var RepTypeCode=selItems[0].RepTypeCode; //�������ʹ���
	var RepStausDr=selItems[0].RepStausDr; //��ǰ״̬
	var auditparams=RepID+"^"+RepStausDr+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+""+"^"+canfilereason+"^"+Auditnum+"^"+RepTypeCode;   //������
	var fileparams=RepID+"^"+RepTypeCode+"^"+FileFlag+"^"+LgUserID+"^"+""+"^"+ FileId;   //������
	runClassMethod("web.DHCADVCOMMONPART","FileMataReport",{'auditparams':auditparams,'fileparams':fileparams},
		function(jsonString){
			if(jsonString=="-1") {
				$.messager.alert($g("��ʾ:"),$g("���泷������ʧ��! ʧ��ԭ��:����������������˲�һ��"));
			}else if((jsonString !=0)){
				$.messager.alert($g("��ʾ:"),$g("���泷������ʧ��!")+"ErrCode:"+jsonString);   ///+"��"+errnum+"������"
			}
	},"",false);
	$('#maindg').datagrid('reload'); //���¼���
	$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
	$('#CanFileWin').window('close');
	$("#showalert").hide();
}

///�жϱ����ǹ鵵״̬
function JudgeIsOutCome()
{
	var selItems = $('#maindg').datagrid('getSelections');
	var RepID=selItems[0].RepID;         //����ID
	var RepTypeDr=selItems[0].RepTypeDr;
	var FileFlag=""
	runClassMethod("web.DHCADVCOMMONPART","JudgeIsOutCome",{'RepID':RepID,'RepTypeDr':RepTypeDr,"LgParam":LgParam},
		function(jsonString){ 
			FileFlag=jsonString
			
	},"",false);
	return FileFlag;
}
/////////////////////////////////////�߼���ѯ����////////////////////////////////////////
// ������
function addCondition(){
	
	curCondRow=curCondRow+1;
	var html=""
	html+='<tr id="'+curCondRow+'Tr"><td><b style="padding-left:30px">'+$g("��ѯ����")+'</b>';
	html+=getLookUpHtml(curCondRow,1);
	html+=getSelectHtml(curCondRow,1);
	html+='<span style="padding-left:20px;"><input class="dhcc-input" id="QueCond"'+curCondRow+"-"+1+' style="width:120"/></span>';
	html+='</td><td style="padding-left:60px"><b style="padding-left:30px">'+$g("��ѯ����")+'</b>';
	html+=getLookUpHtml(curCondRow,2);
	html+=getSelectHtml(curCondRow,2);
	html+='<span style="padding-left:20px;"><input class="dhcc-input" id="QueCond"'+curCondRow+"-"+2+' style="width:120"/></span>';
	html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="addCondition()"><span  class="icon icon-add" >&nbsp;&nbsp;&nbsp;&nbsp;</span>'+$g("������")+'</span></td>>';
	if(curCondRow>2){
		html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="removeCond('+curCondRow+')"><span  class="icon icon-remove" >&nbsp;&nbsp;&nbsp;&nbsp;</span>'+$g("ɾ����")+'</span></td></tr>';
	}
	$("#condTable").append(html);
	//����
	$("input[id^=stateBox"+curCondRow+"-]").combobox({
		panelHeight:"auto", 
		data:stateBoxArray
	});
	// ��ѯ������
	$("input[id^=LookUp"+curCondRow+"-]").combobox({
		data:GetFrozeData()
	});
	setHeight();
}
// ɾ����
function removeCond(row){
	$("#"+row+"Tr").remove();
	setHeight();
}
function setHeight(){
    var tableHeight=$('#condTable')[0].offsetHeight
    var divHeight=tableHeight+150;
    var centertop=divHeight+50;
    var maindgHeight=$(window).height()-divHeight-120;
    if(maindgHeight<400){
	    maindgHeight='auto';
	}
    $('#northdiv').css({
        height:divHeight+'px'
    });
    $('#nourthlayot').panel('resize', {
        height:'auto'
    });
    $('#centerlayout').panel('resize', {
        top:centertop+'px',
        height:'auto'
    });
    $("#reqList").css({
	    height:maindgHeight
	})
	$("#maindg").datagrid('resize', {           
        height:maindgHeight
    }); 

}
// �������
function getSelectHtml(row,column){
	var key=row+"-"+column;
	var html='<span style="padding-left:20px;">';
	html+='<input  id="stateBox'+key+'" style="width:80;" class="easyui-combobox" data-options="valueField:\'val\',textField:\'text\'"/>'
	html+='</span>'
	return html;
}
// ��ѯ���� ��������
function getLookUpHtml(row,column){
	var html="";
	var key=row+"-"+column;
	html+='<span class="lookup" style="padding-left:20px;">'
	//html+='		<input data-id="" class="textbox lookup-text validatebox-text"  style="width: 118px; height: 28px; line-height: 28px;" id="'+key+'" onkeypress="return onKeyPress(event,this)" data-key='+key+' type="text" >'
	//html+='		<span class="lookup-arrow" style="height: 28px;" onclick="showDic(this)" data-key='+key+'></span>'
	html+='<input id="LookUp'+key+'" style="width:120" class="easyui-combobox" data-options="valueField:\'val\',textField:\'text\'"/>'	
	html+='</span>'
	return html;
}
// ����¼�
function toggleExecInfo(obj){
	if($(obj).hasClass("expanded")){
		$(obj).removeClass("expanded");
		$(obj).html($g("�߼���ѯ"));
		$("#condTable").hide();
		$("#dashline").hide();
		$("#condTd").hide();
		
	}else{
		$(obj).addClass("expanded");
		$(obj).html($g("����"));
		$("#condTable").show();
		$("#dashline").show();
		$("#condTd").show();
	}
	setHeight();
}
// ��ȡ�����ʾ�У���Ϊ��ѯ�����������ݣ�
function GetFrozeData(){
	//��ȡ����δ����������
     var cols = $("#maindg").datagrid('getColumnFields');
     var array = [];
     for (var i=0;i<cols.length;i++) {     
         //��ȡÿһ�е���������
         var col = $("#maindg").datagrid("getColumnOption", cols[i]);
         //��������
         var obj = new Object();
         if((cols[i]!="ck")&&(cols[i]!="Edit")&&(cols[i]!="AuditList")&&(col.hidden!=true)){
         	obj["val"] = cols[i];
         	obj["text"] = col.title.trim();
         	//׷�Ӷ���
         	array.push(obj);
         }
     }   
     return array;
}

// ��ȡ��ѯ�����ַ���
function getParStr(){
	var retArr=[];
	var cond=$("#condCombox").combobox('getValue');
	$("#condTable").find("td").each(function(index,obj){
		if($(obj).children().length<3){
			return true;
		}
		// ��������ֵ������ ���룩
		var column=$(obj).children().eq(1).find("input")[2];
		if(column!=undefined){
			column=column.value;
		}else{
			column="";
		}
		if(column==""){
			return true;	
		}
		// �ж����� ����ֵ�����ڣ�С�ڣ�
		var op=$(obj).children().eq(2).find("input")[2];
		if(op!=undefined){
			op=op.value;
		}else{
			op="";
		}
		// �����ж�ֵ ����������ݣ�
		var columnValue=$(obj).children().eq(3).find("input")[0].value;
		if(columnValue==""){
			return true;
		}

		// ��_$c(1)_ֵ_$c(1)_�ж�����_$c(1)_�߼���ϵ
		var par=column;
		par+=String.fromCharCode(1)+columnValue;
		par+=String.fromCharCode(1)+op;
		par+=String.fromCharCode(1)+cond;
		retArr.push(par);
	})
	return retArr.join("^");
}
/////////////////////////////////////������ӡ�뵼��////////////////////////////////////////
///�����Ĵ�ӡ
function Print()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	$.each(selItems, function(index, item){
		var RepID=item.RepID;//����ID
		var RepTypeCode=item.RepTypeCode;//�������ʹ���/������Code
		runClassMethod("web.DHCADVRepPrint","GetPrintData",{"AdvMasterDr":RepID,"PrintUserId":LgUserID,"LgHospID":LgHospID},function(ret){
			dhcprtPrint(RepTypeCode,ret,"print");
		},"json");
	})
}
///����word��ʽ
function ExportWordFile()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("��ʾ:"),$g("��ѡ��һ�����ݣ�"));
		return;
	}
	var RepID=selItems[0].RepID;//����ID
	var RepTypeCode=selItems[0].RepTypeCode;//�������ʹ���/������Code
	runClassMethod("web.DHCADVRepPrint","GetPrintData",{"AdvMasterDr":RepID,"PrintUserId":LgUserID,"LgHospID":LgHospID},function(ret){
		exportword(RepTypeCode,ret);
	},"json");
}

// ����׷��������д 2020-02-13
function DeptConBtn(){
	var AssWinRecId=""
	var AssWinCode="FunDeptConform"
    var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
   	if (selItems.length>1){
		$.messager.alert($g("��ʾ:"),$g("����׷�ٲ���,��ֻѡ��һ�����ݣ�"));
		return;
	}
	var recordId=selItems[0].recordID
	if($('#deptconwin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="deptconwin"></div>');
	$('#deptconwin').window({
		title:LgGroupDesc+$g('����׷������'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal:true,
		width:900,    
		height:420
	});
	 runClassMethod("web.DHCADVCOMMONPART","GetRecordId",
		{'LinkRecordId':recordId,
		 'FormCode':AssWinCode},
		function(data){ 
			 AssWinRecId=data
	},"text",false) 
	
	//alert(AssWinRecId+","+AssWinCode+","+recordId)
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+AssWinRecId+'&code='+AssWinCode+'&LinkRecordId='+recordId+'"></iframe>'; 
	$('#deptconwin').html(iframe);
	$('#deptconwin').window('open');
	
}
// �رճ���׷�ٴ���
function closeDeptConWindow()
{  
	$('#deptconwin').window('close');
	$('#linkwin').window('close');
}


//����  ת������
function setLinkList(value, rowData, rowIndex)
{   
	var recordID=rowData.recordID;         //���� recordID
	var RepID=rowData.RepID;         //����ID
	var RepType=rowData.RepType;         //����ID	
	var PatOutFlag=rowData.PatOutFlag;         // ת���ʶ
	var CaseShareflag=rowData.CaseShareflag; // ���������־
	var RepTypeCode=rowData.RepTypeCode;         //�������ʹ���
	var params=RepID+"^"+RepTypeCode;
	var SubUserflag=rowData.SubUserflag;  // ��ת���û���ʶ
	
	var FunDeptFlag="",RepAssFalg="";
	var PatOutFormCode="PatOutcomform",FunDeptFormCode="FunDeptConform";
	if(RepType.indexOf("Ժ��")>=0){
		PatOutFormCode="UlcPatOutcomform";
	}
	runClassMethod("web.DHCADVCOMMON","GetLinkFlagList",{'LinkRecordId':recordID},
	function(data){
		var tmp=data.split("^"); 
		// ת���ʶ
		PatOutFlag=tmp[0];
        // ׷�ٷ�����ʶ
		FunDeptFlag=tmp[1];
        // ������ʶ
		RepAssFalg=tmp[2];
	},"text",false);
			
	if (PatOutFlag == "Y"){
		html = "<a href='#' id='zg' class='dhcc-btn-tb'  onclick=\"LoadLinkWin('"+RepID+"','"+recordID+"','"+PatOutFormCode+"',$g('ת��'))\" >"+$g("ת��")+"</a>";
	}else{
		html ="<span class='dhcc-btn-tb disabled' style='cursor:default;'>"+$g("ת��")+"</span>";
	}
	if (FunDeptFlag == "Y"){
		html =html+ "<a href='#' class='dhcc-btn-tb yellow' onclick=\"LoadLinkWin('"+RepID+"','"+recordID+"','"+FunDeptFormCode+"',$g('׷�ٷ���'))\" >"+$g("����")+"</a>";
	}else{
		html =html+ "<span class='dhcc-btn-tb disabled' style='cursor:default;'>"+$g("����")+"</span>";
	}
	if (RepAssFalg == "Y"){
		html =html+ "<span class='dhcc-btn-tb' style='cursor:default;'>"+$g("����")+"</span>";
	}else{
		html =html+ "<span class='dhcc-btn-tb disabled' style='cursor:default;'>"+$g("����")+"</span>";
	
	}
	if (CaseShareflag == "Y"){
		html = html+ "<a href='#' class='dhcc-btn-tb yellow' onclick=\"ShowWin('"+params+"')\" >"+$g("��������")+"</a>";
	}else{
		html =html+ "<span class='dhcc-btn-tb disabled' style='cursor:default;'>"+$g("��������")+"</span>";
	}
	if (SubUserflag == "1"){
		//html = html+ "<a href='#' id='zc' class='dhcc-btn-tb' onclick=\"TranList('"+params+"')\" >"+$g("ת��")+"</a>";
		html =html+ "<span class='dhcc-btn-tb' style='cursor:default;'>"+$g("ת��")+"</span>";
	}else{
		html =html+ "<span class='dhcc-btn-tb disabled' style='cursor:default;'>"+$g("ת��")+"</span>";
	}
	
    return html;
    
}

//�༭����  2018-05-07 cy ת�����
function LoadLinkWin(RepID,recordID,FormCode,FormTitle)
{
	if($('#linkwin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="linkwin"></div>');
	$('#linkwin').window({
		title:FormTitle,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		width:800,    ///2017-11-23  cy  �޸ĵ��������С 1250
		height:400
	});
	var WinRecId="";
	 runClassMethod("web.DHCADVCOMMONPART","GetRecordId",
		{'LinkRecordId':recordID,
		 'FormCode':FormCode},
		function(data){ 
			 WinRecId=data;
	},"text",false) 
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+WinRecId+'&code='+FormCode+'&LinkRecordId='+recordID+'&RepID='+RepID+'"></iframe>'; 
	$('#linkwin').html(iframe);
	$('#linkwin').window('open');
}

// 2021-03-18 cy ��������鿴
function ShowWin(params){
	CaseShareShow(params);
	$('#WardWbar').hide();
}

/// 2021-03-18 cy ����ת����ϸ����  
function setTranList(value, rowData, rowIndex)
{
		var RepID=escape(rowData.RepID);         //����ID
		var RepTypeCode=escape(rowData.RepTypeCode); //�������ʹ���
		var params=RepID+"^"+RepTypeCode;
		return "<a href='#' onclick=\"TranList('"+params+"')\"><img src='../scripts/dhcadvEvt/images/adv_sel_11.png' border=0/></a>";
}
// 2021-03-18 cy ת����ϸ�鿴
function TranList(params)
{
	$('#TranWin').window({
		title:$g('ת����ϸ'),
		collapsible:false,
		border:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:1100,
		height:500
	});
	$('#TranWin').window('open');	
	
	//����columns
	var columns=[[
		{field:'MedItmID',title:$g('ת��ID'),width:150,hidden:true},
		{field:'MedIAuditDateTime',title:$g('ת��ʱ��'),width:150,hidden:false},
		{field:'MedIAuditUser',title:$g('ת����'),width:100,hidden:false},
		{field:'MedIAuditUserDR',title:$g('ת����ID'),width:100,hidden:true},
		{field:'MedILocAdvice',title:$g('ת���������'),width:200,formatter:setLocAdvice},
		{field:'MedINextLoc',title:$g('ת��ָ�����'),width:150},
		{field:'MedINextLocDR',title:$g('ת��ָ�����ָ��ID'),width:100,hidden:true},
		{field:'MedINextUser',title:$g('ת��ָ����Ա'),width:100},
		{field:'MedINextUserDR',title:$g('ת��ָ����ԱID'),width:100,hidden:true},
		{field:'MedIUserAdvice',title:$g('��Ա�ظ����'),width:200,formatter:setUserAdvice},
		{field:'MedIReceive',title:$g('����״̬'),width:60},
		{field:'DutyFlag',title:$g('��ע'),width:200},
		{field:'MedIReceiveDateTime',title:$g('����ʱ��'),width:150},
		{field:'MedICompleteDateTime',title:$g('���ʱ��'),width:150}
	]];
	//����datagrid
	$('#Trandg').datagrid({   
		title:'',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVSEARCHREPORT&MethodName=QueryTranMess'+'&params='+params,
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
        nowrap:false
	});	
	
}
//����  ����
function setLocAdvice(value, rowData, rowIndex)
{   
    return $_TrsTxtToSymbol(rowData.MedILocAdvice);
   // return "<a href='#' mce_href='#' onclick='LoadPatientRecord("+rowData.PatID+","+Adm+");'>"+PatNo+"</a>";  
    
}
//����  ����
function setUserAdvice(value, rowData, rowIndex)
{   
    return $_TrsTxtToSymbol(rowData.MedIUserAdvice);
   // return "<a href='#' mce_href='#' onclick='LoadPatientRecord("+rowData.PatID+","+Adm+");'>"+PatNo+"</a>";  
    
}


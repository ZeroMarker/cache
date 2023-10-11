
var url="dhcpha.clinical.action.csp";
var statArray = [{ "value": "I", "text": $g("��Ժ") },{ "value": "O", "text": $g("��Ժ")}];
$(function(){
	/* ��ʼ������ؼ� */
	InitComponent();
})

/* ��ʼ������ؼ� */
function InitComponent(){
	//����columns
	var columns=[[
		{field:"AdmDr",title:'AdmDr',width:90,hidden:true},
		{field:'Ward',title:$g('����'),width:160},
		{field:'PatNo',title:$g('�ǼǺ�'),width:80},
		{field:'InMedicare',title:$g('������'),width:80},
		{field:'PatName',title:$g('����'),width:80},
		{field:'Bed',title:$g('����'),width:80},
		{field:'PatSex',title:$g('�Ա�'),width:80},
		{field:'PatAge',title:$g('����'),width:80},
		{field:'PatHeight',title:$g('���'),width:80},
		{field:'PatWeight',title:$g('����'),width:80},
		{field:'AdmLoc',title:$g('����'),width:150},
		{field:'AdmDoc',title:$g('ҽ��'),width:80},
		{field:'PatDiag',title:$g('���'),width:180},
		{field:'PatInDate',title:$g('��Ժʱ��'),width:140},
		{field:'PatOutDate',title:$g('��Ժʱ��'),width:140},
		{field:'OPer',title:$g('����'),width:100,align:'center',formatter:ShowPatMonInfo}
	]];
	
	/// ��ʼ�� datagrid
	var option = {title:$g('�����б�'),singleSelect:true};
	var mListComponent = new ListComponent('PatCompList', columns, '', option);
	mListComponent.Init();
	
	initScroll("#PatCompList");//��ʼ����ʾ���������
        $('#PatCompList').datagrid('loadData', {total:0,rows:[]});
	
	/// ��ʼ������
	$("#StDate").datebox("setValue", formatDate(-31));  //��ʼ����
	$("#EndDate").datebox("setValue", formatDate(0));  //��������
	
	/// ����
	$('#Ward').combobox({
		mode:'remote',	
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			$('#Ward').combobox('reload',url+'?action=GetAllWardNewVersion&hospId='+LgHospID+'  ')
			//$('#ward').combobox('reload',url+'?actiontype=SelAllLoc')			
		}
	});
	//var WardCombobox = new ListCombobox("Ward",url+'?action=SelAllWard&HospID='+LgHospID);
	//WardCombobox.init();

	/// ����
	$('#Loc').combobox({
		mode:'remote',		
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			$('#Loc').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'  ')
			//$('#dept').combobox('reload',url+'?action=SelAllLoc&HospID='+HospID)
		}
	}); 
	//var LocCombobox = new ListCombobox("Loc",url+'?action=SelAllLoc&loctype=E&HospID='+LgHospID);
	//LocCombobox.init();
	
	/// ����
	var TypeCombobox = new ListCombobox("Type",'',statArray);
	TypeCombobox.init();


      ///�ǼǺ�                                 wangxuejian 2016-09-13
     $("#PatNo").bind('keypress',function(event){       
        if(event.keyCode == "13"){
	        SetPatNoLength();
                Patnoquery();
          }
         });
	
	/// ��ѯ��ť
	$('a:contains('+$g("��ѯ")+')').bind("click",Query);  //�����ѯ
}

//�ǼǺŲ�ѯ  wangxuejian 2016-09-13

function Patnoquery()
{ 
	var StDate=$('#StDate').datebox('getValue');   //��ʼ����
	var EndDate=$('#EndDate').datebox('getValue'); //��ֹ����
	var PatNo=$.trim($("#PatNo").val());
	var params=StDate+"^"+EndDate+"^^^^"+PatNo+"^";
	$('#PatCompList').datagrid({url:url+'?action=QueryAllInHosPatList',	
		queryParams:{
			params:params}
			});
}

//��ѯ
function Query(){

	var StDate=$('#StDate').datebox('getValue');   //��ʼ����
	var EndDate=$('#EndDate').datebox('getValue'); //��ֹ����
	var WardID=$('#Ward').combobox('getValue');    //����ID
	var LocID=$('#Loc').combobox('getValue');  //����ID
	var Type=$('#Type').combobox('getValue');  //����
	var PatNo=$.trim($("#PatNo").val());
	//���ҺͲ�������������ݺ��ѯȫ�� duwensheng 2016-09-06
	if($('#Ward').combobox('getText')=="")
	{
		var WardID="";
	}
	if($('#Loc').combobox('getText')=="")
	{
		var LocID="";
	}
	var params=StDate+"^"+EndDate+"^"+WardID+"^"+LocID+"^"+Type+"^"+PatNo+"^"+LgHospID;
	
	//��Ϣ��ѯ���Ǵӵ�һҳ��ʼ duwensheng 2016-09-06
	$('#PatCompList').datagrid({url:url+'?action=QueryAllInHosPatList',pageNumber:"1",
		queryParams:{
			params:params}
	});
}


//�ǼǺ�λ������ʱ������    qunianpeng 2016-09-12 
function SetPatNoLength(){	
	var PatientNo=$('#PatNo').val();      //�ǼǺ�
	if(PatientNo!=""){
	var PatLen=PatientNo.length;			
	if(PatLen<10)     //�ǼǺų���Ϊ10λ
	{
		for (i=1;i<=10-PatLen;i++)
		{
			PatientNo="0"+PatientNo; 
		}
	}
	$('#PatNo').val(PatientNo);
	}
}

/// �鿴�໤����
function  ShowPatMonInfo(value, rowData, rowIndex){

   	return "<a href='#' mce_href='#' onclick='showPatMonWin("+rowData.AdmDr+");'>"+$g("�鿴��ϸ")+"</a>";   //wangxuejian 2016-09-23   ����Ժ���Խ���ѡȡ
    
}

///  �鿴��ϸ����                               wangxuejian 2016-09-23
function showPatMonWin(EpisodeID){ 
    
	var option = {
		collapsible:true,
		border:true,
		closed:"true",
		minimizable:false,					/// ������С����ť
		maximized:true						/// ���(qunianpeng 2018/5/2)
	};
	new WindowUX($g('����ҩѧ�����Ϣ��ѯ'), 'newItmWin', '950', '550', option).Init();
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.perpharservice.csp?EpisodeID='+EpisodeID+'&MWToken='+websys_getMWToken()+'"></iframe>';
	$("#newItmWin").html(iframe);  //csp ������
}

///Creator:    bianshuai
///CreateDate: 2016-01-28
///Descript:   ҩѧ����ѯ

var url="dhcpha.clinical.action.csp";
var TeacherSfArr=[{"value":"Y","text":'����'}, {"value":"N","text":'������'}];
var TeacherTitArr=[{"value":"Y","text":'�ϸ�'}, {"value":"N","text":'���ϸ�'}];
var TeacherSexArr=[{"value":"Y","text":'���'}, {"value":"N","text":'�����'}];
var bmTEduArr = [{"value":"Y","text":'���'}, {"value":"N","text":'�����'}];
$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));     //Init��������
	
	$("a:contains('�½�')").bind("click",newCreateWriteWin);
	$("a:contains('��ѯ')").bind("click",querybmTeacherDet);
	$("a:contains('ɾ��')").bind("click",delTeacherDetail);
	///event.keyCode == "13"��ʾ�س�
    $('#TeacherCode').bind('keypress',function(event){
        if(event.keyCode == "13"){                            
	        findUserInfo();}
	        
    });
        $('#GiveCode').bind('keypress',function(event){
        if(event.keyCode == "13"){                            
	        findUserInfoz();}
	        
    });
	
	/**
	 * �Ա�
	 */
	var teacherSexCombobox = new ListCombobox("TeacherSex",'',TeacherSexArr,{panelHeight:"auto"});
	teacherSexCombobox.init();
	
	/**
	 * ѧ��
	 */
	var teacherEduCombobox = new ListCombobox("TeacherEdu",'',bmTEduArr,{panelHeight:"auto"});
	teacherEduCombobox.init();

	/**
	 * ����רҵ
	 */
	var teacherCarCombobox = new ListCombobox("TeacherCar",url+'?action=SelProDirect','',{panelHeight:"auto"});
	teacherCarCombobox.init();

	/**
	 * ְ��
	 */
	var teacherTitCombobox = new ListCombobox("TeacherTit",'',TeacherTitArr,{panelHeight:"auto"});
	teacherTitCombobox.init();

	/**
	 * ��ʩ
	 */
	var teacherSfCombobox = new ListCombobox("TeacherSf",'',TeacherSfArr,{panelHeight:"auto"});
	teacherSfCombobox.init();
	/**
	 * ����
	 */
    var teacherLocCombobox = new ListCombobox("TeacherLoc",url+'?action=QueryConDept','',{});
	teacherLocCombobox.init();
	
    var locIdCombobox = new ListCombobox("LocId",url+'?action=QueryConDept','',{});
	locIdCombobox.init();
	
	
	InitCliTeaList();    //��ʼ�������б�
	
})

//��ʼ���б�
function InitCliTeaList()
{

	
	var columns=[[
		{field:'bmTeaID',title:'bmTeaID',width:80,hidden:true,rowspan:2},
		{field:'bmTDate',title:'����',width:100},
        {field:'bmTTime',title:'ʱ��',width:100,hidden:true},
        {field:'bmGiveUserName',title:'������',width:100},
        {field:'bmTeacherName',title:'�Ӱ���',width:100},
        {field:'bmLocName',title:'����',width:100},
        {field:'bmTeacherSex',title:'ҩƷƷ��',width:100},
        {field:'bmTeacherEdu',title:'ҩƷ����',width:100},
        {field:'bmTeacherTit',title:'ҩƷ����',width:100},
        {field:'bmTeacherSf',title:'��ȫ��ʩ',width:100},
		{field:'LinkModify',title:'�޸���Ϣ',width:100,align:'center',formatter:SetCellOpUrl},
		{field:'bmTRemark',title:'��ע',width:200}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'����ҩƷ���ӵǼ���ϸ',
		//nowrap:false,
		singleSelect : true ,
		onDblClickRow:function(rowIndex, rowData){
		  	showModifyWin(rowIndex);
		},
		onLoadSuccess:function(data){
			var rows = $("#bmTDetList").datagrid('getRows');
			var rowcount=rows.length ;			   
			if (rowcount==0) return;
			var rowData = $('#bmTDetList').datagrid('getData').rows[0];
			var TmpbmTCareerDesc = rowData.bmTCareerDesc;
			var mergerows=0;
			for (var i=1;i<rows.length;i++){
				mergerows = mergerows + 1;
				if (TmpbmTCareerDesc != rows[i].bmTCareerDesc){
					$('#bmTDetList').datagrid('mergeCells',{
				       index:(i - mergerows),
				       field:'bmTCareerDesc',
				       rowspan:mergerows
				    });
				    mergerows=0;
				    TmpbmTCareerDesc = rows[i].bmTCareerDesc;
				}
			}
			if(i == rows.length){
				mergerows = mergerows + 1;
				$('#bmTDetList').datagrid('mergeCells',{
				       index:(i - mergerows),
				       field:'bmTCareerDesc',
				       rowspan:mergerows
				    });
			}
		}
	};
		
	var bmTDetListComponent = new ListComponent('bmTDetList', columns, '', option);
	bmTDetListComponent.Init();

	initScroll("#bmTDetList");//��ʼ����ʾ���������

	querybmTeacherDet();
}

 /**
  * �½���д����
  */
function newCreateWriteWin(){
	newCreateWrOrEdWin();  //�½���д����
	initbmTWrOrEdWin();
}

 /**
  * �½���д����
  */
function newCreateWrOrEdWin(){
	var option = {
			buttons:[{
				text:'����',
				iconCls:'icon-save',
				handler:function(){
					saveTeaDetail();
					}
			},{
				text:'ȡ��',
				iconCls:'icon-cancel',
				handler:function(){
					$('#newWrWin').dialog('close');
					}
			}]
		};
	var newWrDialogUX = new DialogUX('���ӽ��ӵǼ���Ϣ', 'newWrWin', '730', '415', option);
	newWrDialogUX.Init();
}

 /**
  * ���������ʦ��Ϣ
  */
function saveTeaDetail(){
	
	var teaUserID=$('#TeaUserID').val();    //�û�ID
	if (teaUserID == ""){
		showMsgAlert("������ʾ:","�Ӱ�����������Ϊ�գ�");
		return;
	}
	var giveUserID=$('#GiveUserID').val();    //������ID
	var teacherSex=$('#TeacherSex').combobox('getValue');    //�Ա�
	if (teacherSex == ""){
		showMsgAlert("������ʾ:","ҩƷƷ�治��Ϊ�գ�");
		return;
	}

	var teacherEdu=$('#TeacherEdu').combobox('getValue');    //ѧ��
	if (teacherEdu == ""){
		showMsgAlert("������ʾ:","ҩƷ��������Ϊ�գ�");
		return;
	}
	
	var teacherTit=$('#TeacherTit').combobox('getValue');    //ְ��
	if (teacherTit == ""){
		showMsgAlert("������ʾ:","ҩƷ��������Ϊ�գ�");
		return;
	}
	
	var teacherLoc=$('#TeacherLoc').combobox('getValue');    //����
	if (teacherLoc == ""){
		showMsgAlert("������ʾ:","���Ҳ���Ϊ�գ�");
		return;
	}
    var teacherSf=$('#TeacherSf').combobox('getValue');    //��ʩ
	if (teacherSf == ""){
		showMsgAlert("������ʾ:","ҩƷ��ʩ����Ϊ�գ�");
		return;
	}
    var teacherDesc = $("#TeacherDesc").val();   //������Ϣ

	var bmTeacherID = $("#TeacherID").val();
	
	
	var bmTDataList = teaUserID +"^"+giveUserID +"^"+ teacherSex +"^"+ teacherEdu +"^"+ teacherLoc +"^"+ teacherTit +"^"+teacherSf +"^"+ teacherDesc;

	//��������
	$.post(url+'?action=SavePhDrugShReg',{"bmTeacherID":bmTeacherID,"bmTDataList":bmTDataList},function(jsonString){
		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			$('#newWrWin').dialog('close');     //�رմ���
			$('#bmTDetList').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ:","�ύʧ��,����ԭ��"+jsonConsObj.ErrorMessage);
		}
	});
}

 /**
  * ��ѯ��ѯ����
  */
function querybmTeacherDet(){
	
	//1�����datagrid 
	$('#CliTeaList').datagrid('loadData', {total:0,rows:[]});
	
	//2����ѯ
	var startDate=$('#startDate').datebox('getValue');   //��ʼ����
	var endDate=$('#endDate').datebox('getValue');       //��ֹ����

	var LocId=$('#LocId').combobox('getValue');    //����
	var params=startDate +"^"+ endDate +"^"+ LocId;

	$('#bmTDetList').datagrid({
		url:url + "?action=QuerybmTeaListz",	
		queryParams:{
			params:params}
	});
}

/// ɾ����ѯ��ϸ
function delTeacherDetail(){
	showMsgAlert("����ԭ��:" , "ɾ��������ʱ�����ã�");
}

//����
function SetCellOpUrl(value, rowData, rowIndex)
{
	var html = "<a href='#' onclick='showModifyWin("+rowIndex+")'>�޸�����</a>";
    return html;
}

 /**
  * �޸Ĵ���
  */
function showModifyWin(index){

	newCreateWrOrEdWin();  //�½���д����
	
	var rowData = $('#bmTDetList').datagrid('getData').rows[index];
	
	$("#TeacherID").val(rowData.bmTeaID);       //DHC_PHBasManTeacher ID
	$("#TeaUserID").val(rowData.bmTUserID);     //�û�ID
	$("#TeacherName").val(rowData.bmTUserName); //����
	$("#TeacherCode").val(rowData.bmTUserCode); //����
	$("#TeacherSex").combobox('setValue',rowData.bmTSexID);     //�Ա�
	$("#TeacherEdu").combobox('setValue',rowData.bmTEduca);     //ѧ��
	$("#TeacherTit").combobox('setValue',rowData.bmTCarePrvID); //ְ��
	$("#TeacherLoc").combobox('setValue',rowData.bmTLocID);     //����
	$("#TeacherCar").combobox('setValue',rowData.bmTCareer);    //����רҵ
	$("#TeacherDesc").val(rowData.bmTRemark);   //��ע
}

/// ��ʼ��������ʦ��д����
function initbmTWrOrEdWin(){
	$("#TeacherID").val("");     //DHC_PHBasManTeacher ID
	$("#TeaUserID").val("");     //�û�ID
	$("#TeacherName").val("");   //����
	$("#TeacherCode").val("");   //����
	$("#GiveCode").val("");   //����
	$("#GiveName").val("");   //
	$("#TeacherDesc").val("");   //��ע
	$("#TeacherSex").combobox('setValue',"");     //�Ա�
	$("#TeacherEdu").combobox('setValue',"");     //ѧ��
	$("#TeacherTit").combobox('setValue',"");     //ְ��
	$("#TeacherLoc").combobox('setValue',"");     //����  
    $("#TeacherSf").combobox('setValue',""); //��ʩ	
	$("#GiveUserID").val(""); 
	
}

/// �����û����Ų�ѯ�û���Ϣ
function findUserInfo(){
	
	var usercode = $('#TeacherCode').val();
	if (usercode == ""){
		showMsgAlert("������Ϣ","�����빤�ź�,�س���ѯ��");
		return;
	}
	$.post(url+'?action=QueryUserInfo',{"usercode":usercode},function(jsonString){
	
		var resobj = jQuery.parseJSON(jsonString);
		if (typeof resobj.bmTUserID == "undefined"){
			showMsgAlert("����ԭ��:" , "'����'���������ԣ�");
			return;
		}
		$("#TeaUserID").val(resobj.bmTUserID);    //�û�ID
		$("#TeacherCode").val(resobj.bmTUserCode);    //����
		$("#TeacherName").val(resobj.bmTUserName);    //����
	});
}
/// �����û����Ų�ѯ�û���Ϣ
function findUserInfoz(){
	
	var usercode = $('#GiveCode').val();
	if (usercode == ""){
		showMsgAlert("������Ϣ","�����빤�ź�,�س���ѯ��");
		return;
	}
	$.post(url+'?action=QueryUserInfo',{"usercode":usercode},function(jsonString){
	
		var resobj = jQuery.parseJSON(jsonString);
		if (typeof resobj.bmTUserID == "undefined"){
			showMsgAlert("����ԭ��:" , "'����'���������ԣ�");
			return;
		}
		$("#GiveUserID").val(resobj.bmTUserID);    //�û�ID
		$("#GiveCode").val(resobj.bmTUserCode);    //����
		$("#GiveName").val(resobj.bmTUserName);    //����
	});
}

/// ��Ϣ��ʾ����
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("��ʾ:","<font style='font-size:20px;'>" + ErrMsg + "</font><font style='font-size:20px;color:red;'>" + ErrDesc + "</font>");
}

///Creator:    bianshuai
///CreateDate: 2016-01-28
///Descript:   ��ʦ��Ϣ�б�
var flag=0;
var url="dhcpha.clinical.action.csp";
var bmTEduArr = [{"value":"1","text":$g('��ʿ������')}, {"value":"2","text":$g('˶ʿ')}, {"value":"3","text":$g('����')}, {"value":"4","text":$g('��ר')}];
$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));     //Init��������
	
	$("a:contains("+$g('����')+")").bind("click",newCreateWriteWin);
	$("a:contains("+$g('��ѯ')+")").bind("click",querybmTeacherDet);
	$("a:contains("+$g('ɾ��')+")").bind("click",delTeacherDetail);
    $('#TeacherCode').bind('keypress',function(event){
        if(event.keyCode == "13"){
	        findUserInfo();}
    });
	
	/**
	 * �Ա�
	 */
	var teacherSexCombobox = new ListCombobox("TeacherSex",url+'?action=SelCTSex','',{panelHeight:"auto"});
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
	var teacherTitCombobox = new ListCombobox("TeacherTit",url+'?action=QueryConsIden','',{});
	teacherTitCombobox.init();

	/**
	 * ����
	 */
	  $('#TeacherLoc').combobox({
		mode:'remote',		
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			$('#TeacherLoc').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'  ')
			//$('#dept').combobox('reload',url+'?action=SelAllLoc&HospID='+HospID)
		},
			onHidePanel: function() { //lbb 2020.2.26 ���Ӽ������ݺ���������ƥ��
            var valueField = $(this).combobox("options").valueField;
            var val = $(this).combobox("getValue");  //��ǰcombobox��ֵ
            var allData = $(this).combobox("getData");   //��ȡcombobox��������
            var result = true;      //Ϊtrue˵�������ֵ�������������в�����
            for (var i = 0; i < allData.length; i++) {
                if (val == allData[i][valueField]) {
                    result = false;
                }
            }
            if (result) {
                $(this).combobox("clear");
            }

        }
	}); 
	//var teacherLocCombobox = new ListCombobox("TeacherLoc",url+'?action=QueryConDept','',{});
	//teacherLocCombobox.init();

	InitCliTeaList();    //��ʼ�������б�
	
})

//��ʼ���б�
function InitCliTeaList()
{
	
	var columns=[[
		{field:'bmTeaID',title:'bmTeaID',width:80,hidden:true,rowspan:2},
		{field:'bmTCareer',title:$g('����רҵCode'),width:100,hidden:true,rowspan:2},
		{field:'bmTCareerDesc',title:$g('����רҵ'),width:100,rowspan:2},
		{title:'<span style="font-weight:bold">'+$g("������ʦ���")+'</span>',align:'center',colspan:9}
	],[
		{field:'bmTUserID',title:$g('�û�ID'),width:100,hidden:true},
		{field:'bmTUserCode',title:$g('����'),width:80},
		{field:'bmTUserName',title:$g('����'),width:80},
		{field:'bmTSexID',title:$g('�Ա�ID'),width:60,hidden:true},
		{field:'bmTSex',title:$g('�Ա�'),width:60},
		{field:'bmTAge',title:$g('����'),width:60},
		{field:'bmTEduca',title:$g('ѧ��Code'),width:100,hidden:true},
		{field:'bmTEducaDesc',title:$g('ѧ��'),width:120},
		{field:'bmTCarePrvID',title:$g('ְ��ID'),width:100,hidden:true},
		{field:'bmTCarePrvTP',title:$g('ְ��'),width:100},
		{field:'bmTLocID',title:$g('����ID'),width:160,hidden:true},
		{field:'bmTLoc',title:$g('����'),width:200},
		{field:'bmTDate',title:$g('����'),width:100},
		{field:'bmTTime',title:$g('ʱ��'),width:90,hidden:true},
		{field:'bmTClinicalDate',title:$g('�ٴ�ҩʦ֤��ʱ��'),width:150},
		{field:'bmTTeacherDate',title:$g('�ٴ�ҩʦʦ��֤��ʱ��'),width:150},
		{field:'bmSNameStr',title:$g('����ѧԱ'),width:150},
		{field:'bmTRemark',title:$g('��ע'),width:200},
		{field:'LinkModify',title:$g('�޸���Ϣ'),width:100,align:'center',formatter:SetCellOpUrl},

	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:$g('������ʦ��ϸ'),
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
				text:$g('����'),
				iconCls:'icon-save',
				handler:function(){
					saveTeaDetail();
					}
			},{
				text:$g('�ر�'),
				iconCls:'icon-cancel',
				handler:function(){
					$('#newWrWin').dialog('close');
					}
			}]
		};
	if(flag==1){
		var newWrDialogUX = new DialogUX($g('�޸Ĵ��̽�ʦ��Ϣ'), 'newWrWin', '730', '400', option); //lbb 2019-03-12
	}
	else{
	    var newWrDialogUX = new DialogUX($g('���Ӵ��̽�ʦ��Ϣ'), 'newWrWin', '730', '400', option)
	}
	newWrDialogUX.Init();
	flag=0;
}

 /**
  * ���������ʦ��Ϣ
  */
function saveTeaDetail(){
	
	var teaUserID=$('#TeaUserID').val();    //�û�ID
	if (teaUserID == ""){
		showMsgAlert("������ʾ:","��������Ϊ�գ�");
		return;
	}
		
	var teacherSex=$('#TeacherSex').combobox('getValue');    //�Ա�
	if (teacherSex == ""){
		showMsgAlert("������ʾ:","�Ա���Ϊ�գ�");
		return;
	}

	var teacherEdu=$('#TeacherEdu').combobox('getValue');    //ѧ��
	if (teacherEdu == ""){
		showMsgAlert("������ʾ:","ѧ������Ϊ�գ�");
		return;
	}
	
	var teacherTit=$('#TeacherTit').combobox('getValue');    //ְ��
	if (teacherTit == ""){
		showMsgAlert("������ʾ:","ְ�Ʋ���Ϊ�գ�");
		return;
	}
	
	var teacherLoc=$('#TeacherLoc').combobox('getValue');    //����
	if (teacherLoc == ""){
		showMsgAlert("������ʾ:","���Ҳ���Ϊ�գ�");
		return;
	}

	var teacherCar=$('#TeacherCar').combobox('getValue');    //����רҵ
	if (teacherCar == ""){
		showMsgAlert("������ʾ:","����רҵ����Ϊ�գ�");
		return;
	}
	var teacherAge=$('#TeacherAge').val();    //����
	if (teacherAge == ""){
		showMsgAlert("������ʾ:","���䲻��Ϊ�գ�");
		return;
	}
	var ClinicalDate=$('#ClinicalDate').datebox('getValue')
    if (ClinicalDate == ""){
		showMsgAlert("������ʾ:","ȡ���ٴ�ҩʦ֤��ʱ�䲻��Ϊ�գ�");
		return;
	}
	var TeacherDate=$('#TeacherDate').datebox('getValue')
    if (TeacherDate == ""){
		showMsgAlert("������ʾ:","ȡ���ٴ�ҩʦʦ��֤��ʱ�䲻��Ϊ�գ�");
		return;
	}
    var teacherDesc = $("#TeacherDesc").val();   //������Ϣ

	var bmTeacherID = $("#TeacherID").val();
	
	var bmTDataList = teaUserID +"^"+ teacherSex +"^"+ teacherEdu +"^"+ teacherLoc +"^"+ teacherCar +"^"+ teacherTit +"^"+ teacherDesc+"^"+teacherAge+"^"+ClinicalDate+"^"+TeacherDate;

	//��������
	$.post(url+'?action=SaveBasManTeacher',{"bmTeacherID":bmTeacherID,"bmTDataList":bmTDataList},function(jsonString){

		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			$('#newWrWin').dialog('close');     //�رմ���
			$('#bmTDetList').datagrid('reload'); //���¼���
		}else if(jsonConsObj.ErrorCode==""){
			$.messager.alert("��ʾ:","�ύʧ��,����ԭ�򣺴˽�ʦ�Ѵ��ڣ�������ά������")
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

	var userCode=$('#userCode').val();    //����
	var userName=$('#userName').val();
	var params=startDate +"^"+ endDate +"^"+ userCode+"^"+LgHospID+"^"+userName;
	$('#bmTDetList').datagrid({
		url:url + "?action=QuerybmTeaList",	
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
    
    flag=1;
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
	$("#TeacherLoc").combobox('setText',rowData.bmTLoc);     //����
	$("#TeacherCar").combobox('setValue',rowData.bmTCareer);    //����רҵ
	$("#TeacherAge").val(rowData.bmTAge); //����
	$("#ClinicalDate").datebox("setValue",rowData.bmTClinicalDate)
	$("#TeacherDate").datebox("setValue",rowData.bmTTeacherDate)
	$("#TeacherDesc").val(rowData.bmTRemark);   //��ע
}

/// ��ʼ��������ʦ��д����
function initbmTWrOrEdWin(){
	$("#TeacherID").val("");     //DHC_PHBasManTeacher ID
	$("#TeaUserID").val("");     //�û�ID
	$("#TeacherName").val("");   //����
	$("#TeacherCode").val("");   //����
	$("#TeacherSex").combobox('setValue',"");     //�Ա�
	$("#TeacherEdu").combobox('setValue',"");     //ѧ��
	$("#TeacherTit").combobox('setValue',"");     //ְ��
	$("#TeacherLoc").combobox('setValue',"");     //����
	$("#TeacherCar").combobox('setValue',"");     //����רҵ
	$("#TeacherDesc").val("");   //��ע
	$("#ClinicalDate").datebox("setValue","")
	$("#TeacherDate").datebox("setValue","")
	$("#TeacherAge").val("");
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
		/* if (resobj.bmTUserGroup != LgGroupID){
			showMsgAlert("����ԭ��:" , "���ǵ�¼�İ�ȫ����Ա����");
			$("#TeaUserID").val("")
			$("#TeacherCode").val("");    //����
		    $("#TeacherName").val("");
			return;
		} */
		$("#TeaUserID").val(resobj.bmTUserID);    //�û�ID
		$("#TeacherCode").val(resobj.bmTUserCode);    //����
		$("#TeacherName").val(resobj.bmTUserName);    //����
	});
}

/// ��Ϣ��ʾ����
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("��ʾ:","<font style=''>" + ErrMsg + "</font><font style='color:red;'>" + ErrDesc + "</font>");
}

///Creator:    bianshuai
///CreateDate: 2016-01-28
///Descript:   ҩѧ����ѯ
var flag=0;
var url="dhcpha.clinical.action.csp";
var bmTEduArr = [{"value":"1","text":'��ʿ�о���'}, {"value":"2","text":'˶ʿ�о���'}, {"value":"3","text":'ר��/����'}, {"value":"4","text":'��ְ/����'}];
var GuiCarArr = [{"value":"1","text":'��ʿ�о���'}, {"value":"2","text":'˶ʿ�о���'}, {"value":"3","text":'ר��/����'}, {"value":"4","text":'��ְ/����'}];
$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));     //Init��������
	
	$("a:contains('����')").bind("click",newCreateWriteWin);
	$("a:contains('��ѯ')").bind("click",querybmTeacherDet);
	$("a:contains('ɾ��')").bind("click",delTeacherDetail);
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

	/**
	 * ����columns
	 */
	 /*
	var columns=[[
		{field:'bmTeaID',title:'bmTeaID',width:80,hidden:true},
		{field:'bmTCareer',title:'����רҵCode',width:100,hidden:true},
		{field:'bmTCareerDesc',title:'����רҵ',width:100},
		{field:'bmTUserID',title:'�û�ID',width:100,hidden:true},
		{field:'bmTUserCode',title:'����',width:80},
		{field:'bmTUserName',title:'����',width:80},
		{field:'bmTSexID',title:'�Ա�ID',width:60,hidden:true},
		{field:'bmTSex',title:'�Ա�',width:60},
		{field:'bmTEduca',title:'ѧ��Code',width:100,hidden:true},
		{field:'bmTEducaDesc',title:'ѧ��',width:100},
		{field:'bmTCarePrvID',title:'ְ��ID',width:100,hidden:true},
		{field:'bmTCarePrvTP',title:'ְ��',width:100},
		{field:'bmTLocID',title:'����ID',width:160,hidden:true},
		{field:'bmTLoc',title:'����',width:160},
		{field:'bmTRemark',title:'��ע',width:200},
		{field:'bmTDate',title:'����',width:100},
		{field:'bmTTime',title:'ʱ��',width:90},
		{field:'LinkModify',title:'�޸���Ϣ',width:100,align:'center',formatter:SetCellOpUrl}
	]];
	*/
	
	var columns=[[
		{field:'bmTeaID',title:'bmTeaID',width:80,hidden:true,rowspan:2},
		{field:'bmTCareer',title:'����רҵCode',width:100,hidden:true,rowspan:2},
		{field:'bmTCareerDesc',title:'����רҵ',width:100,rowspan:2},
		{title:'<span style="font-weight:bold">������ʦ���</span>',align:'center',colspan:9}
	],[
		{field:'bmTUserID',title:'�û�ID',width:100,hidden:true},
		{field:'bmTUserCode',title:'����',width:80},
		{field:'bmTUserName',title:'����',width:80},
		{field:'bmTSexID',title:'�Ա�ID',width:60,hidden:true},
		{field:'bmTSex',title:'�Ա�',width:60},
		{field:'bmTEduca',title:'ѧ��Code',width:100,hidden:true},
		{field:'bmTEducaDesc',title:'ѧ��',width:120},
		{field:'bmTCarePrvID',title:'ְ��ID',width:100,hidden:true},
		{field:'bmTCarePrvTP',title:'ְ��',width:100},
		{field:'bmTLocID',title:'����ID',width:160,hidden:true},
		{field:'bmTLoc',title:'����',width:200},
		{field:'bmTDate',title:'����',width:100},
		{field:'bmTTime',title:'ʱ��',width:90,hidden:true},
		{field:'LinkModify',title:'�޸���Ϣ',width:100,align:'center',formatter:SetCellOpUrl},
		{field:'bmTRemark',title:'��ע',width:200}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'������ʦ��ϸ',
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
				text:'�ر�',
				iconCls:'icon-cancel',
				handler:function(){
					$('#newWrWin').dialog('close');
					}
			}]
		};
	if(flag==1){
		var newWrDialogUX = new DialogUX('�޸Ĵ��̽�ʦ��Ϣ', 'newWrWin', '730', '350', option); //lbb 2019-03-12
	}
	else{
	    var newWrDialogUX = new DialogUX('���Ӵ��̽�ʦ��Ϣ', 'newWrWin', '730', '350', option)
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

    var teacherDesc = $("#TeacherDesc").val();   //������Ϣ

	var bmTeacherID = $("#TeacherID").val();
	
	
	var bmTDataList = teaUserID +"^"+ teacherSex +"^"+ teacherEdu +"^"+ teacherLoc +"^"+ teacherCar +"^"+ teacherTit +"^"+ teacherDesc;

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
	
	var params=startDate +"^"+ endDate +"^"+ userCode+"^"+LgHospID;

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

/// ��Ϣ��ʾ����
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("��ʾ:","<font style=''>" + ErrMsg + "</font><font style='color:red;'>" + ErrDesc + "</font>");
}

///Creator:    bianshuai
///CreateDate: 2016-01-28
///Descript:   ѧԱ��Ϣ��
var flag=0;
var url="dhcpha.clinical.action.csp";
var OutProFlagArr = [{"value":"1","text":$g('��')}, {"value":"2","text":$g('��')}];
var bmSEduArr = [{"value":"1","text":$g('��ʿ������')}, {"value":"2","text":$g('˶ʿ')}, {"value":"3","text":$g('����')}, {"value":"4","text":$g('��ר')}];
var bmSProArr = [{"value":"1","text":$g('�ٴ�ҩѧ')}, {"value":"2","text":$g('ҩѧ')}, {"value":"3","text":$g('ҩ���Ƽ�')}, {"value":"4","text":$g('ҩ�����')}, {"value":"5","text":$g('ҩ�ﻯѧ')},{"value":"6","text":$g('ҩ��ѧ')},{"value":"7","text":$g('ҩ��ѧ')}, {"value":"8","text":$g('��ҩѧ������')}];
var bmSHigEduArr = [{"value":"1","text":$g('��ʿ������')}, {"value":"2","text":$g('˶ʿ')}, {"value":"3","text":$g('����')}, {"value":"4","text":$g('��ר')}];
var bmSTopProArr = [{"value":"1","text":$g('�ٴ�ҩѧ')}, {"value":"2","text":$g('ҩѧ')}, {"value":"3","text":$g('ҩ���Ƽ�')}, {"value":"4","text":$g('ҩ�����')}, {"value":"5","text":$g('ҩ�ﻯѧ')},{"value":"6","text":$g('ҩ��ѧ')},{"value":"7","text":$g('ҩ��ѧ')}, {"value":"8","text":$g('��ҩѧ������')}];
var IsAssessment = [{"value":"0","text":'��'}, {"value":"1","text":'��'}];
$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));     //Init��������
	
	$("a:contains("+$g('����')+")").bind("click",newCreateWriteWin);
	$("a:contains("+$g('��ѯ')+")").bind("click",querybmSeacherDet);
	$("a:contains("+$g('ɾ��')+")").bind("click",delbmSeacherDet);
	
	/**
	 * �Ա�
	 */
	var bmSSexCombobox = new ListCombobox("bmSSex",url+'?action=SelCTSex','',{panelHeight:"auto"});
	bmSSexCombobox.init();
	

	/**
	 * ��ѵרҵ
	 */
	var bmSCareerCombobox = new ListCombobox("Career",url+'?action=SelProDirect','',{panelHeight:"auto"});
	bmSCareerCombobox.init();

	/**
	 * ��ѵרҵ
	 */
	var bmSCareerCombobox = new ListCombobox("bmSCareer",url+'?action=SelProDirect','',{panelHeight:"auto"});
	bmSCareerCombobox.init();

	/**
	 * ְ��
	 */
	var bmSCarPrvTpCombobox = new ListCombobox("bmSCarPrvTp",url+'?action=QueryConsIden','');
	bmSCarPrvTpCombobox.init();

	/**
	 * �Ƿ�ʡ��
	 */
	var bmSOutProFlagCombobox = new ListCombobox("bmSOutProFlag",'',OutProFlagArr,{panelHeight:"auto"});
	bmSOutProFlagCombobox.init();
	
	/**
	 * ��һѧ��
	 */
	var bmSEduCombobox = new ListCombobox("bmSEdu",'',bmSEduArr,{panelHeight:"auto"});
	bmSEduCombobox.init();
	/**
	 * רҵ
	 */
    var bmSProCombobox = new ListCombobox("bmSProfession",'',bmSProArr,{panelHeight:"auto"});
	bmSProCombobox.init();
    
    /**
	 * ���ѧ��
	 */
	var bmSHigEduCombobox = new ListCombobox("bmSHigEdu",'',bmSHigEduArr,{panelHeight:"auto"});
	bmSHigEduCombobox.init();
	/**
	 * רҵ
	 */
    var bmSTopProCombobox = new ListCombobox("bmSTopProfession",'',bmSTopProArr,{panelHeight:"auto"});
	bmSTopProCombobox.init();
	
	/**
	 * �Ƿ�ͨ������
	 */
	var bmSIsAssessmentCombobox = new ListCombobox("bmSIsAssessment",'',IsAssessment,{panelHeight:"auto"});
	bmSIsAssessmentCombobox.init();
	
	//�û�
	//var bmSTeacherCombobox = new ListCombobox("bmSTeacher",url+'?action=jsonGetSSUser');
	//bmSTeacherCombobox.init();
	
	$("#bmSBegEduDate").datebox("setValue", formatDate(0));  //��ѧ����
	$("#bmSEndEduDate").datebox("setValue", formatDate(0));  //��ҵ����
	//�û�
	$("#bmSTeacher").combobox({
		mode:'remote',
		onShowPanel:function(){
			$('#bmSTeacher').combobox('reload',url+'?action=jsonGetSSUser')
		}
	}); 
	
	
	InitCliTeaList();    //��ʼ�������б�
	
})

//��ʼ���б�
function InitCliTeaList()
{

	/**
	 * ����columns
	 */
	
	var columns=[[
		{field:'bmStuID',title:'bmStuID',width:80,hidden:true,rowspan:2},
		{field:'bmSCareerDesc',title:$g('��ѵרҵ'),width:100,rowspan:2},
		{title:'<span style="font-weight:bold">'+$g("ѧԱ���")+'</span>',align:'center',colspan:12}
	],[
		{field:'bmSName',title:$g('����'),width:100},
		{field:'bmSSex',title:$g('�Ա�'),width:80},
		{field:'bmSAge',title:$g('����'),width:80},
		{field:'bmSCarePrvTP',title:$g('ְ��'),width:100},
		{field:'bmSBegEduDate',title:$g('��ѧʱ��'),width:100},
		{field:'bmSEndEduDate',title:$g('��ҵʱ��'),width:100},
		{field:'bmSWorkUnit',title:$g('������λ'),width:160},
		{field:'bmSOutProFlagDesc',title:$g('ʡ��'),width:40},
		{field:'bmSAddDate',title:$g('����'),width:100},
		{field:'bmSEducaDesc',title:$g('��һѧ��'),width:100},
		{field:'bmSProfessionDesc',title:$g('��һרҵ'),width:100},
		{field:'bmSHigEduDesc',title:$g('���ѧ��'),width:100},
		{field:'bmSTopProfessionDesc',title:$g('���רҵ'),width:100},
		{field:'bmSTeacherDesc',title:$g('������ʦ'),width:100},
		{field:'bmSTrainDate',title:$g('��ѵʱ��'),width:100},
		{field:'bmSIsAssessmentDesc',title:$g('�Ƿ�ͨ������'),width:50},
		{field:'bmSAddTime',title:$g('ʱ��'),width:90,hidden:true},
		{field:'bmSRemark',title:$g('��ע'),width:200},
		{field:'LinkModify',title:$g('�޸���Ϣ'),width:100,align:'center',formatter:SetCellOpUrl},

	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:$g('����ѧԱ��ϸ'),
		//nowrap:false,
		singleSelect : true,
		onDblClickRow:function(rowIndex, rowData){
		  	showModifyWin(rowIndex);
		},
		onLoadSuccess:function(data){
			var rows = $("#bmSDetList").datagrid('getRows');
			var rowcount=rows.length ;			   
			if (rowcount==0) return;
			var rowData = $('#bmSDetList').datagrid('getData').rows[0];
			var TmpbmSCareerDesc = rowData.bmSCareerDesc;
			var mergerows=0;
			for (var i=1;i<rows.length;i++){
				mergerows = mergerows + 1;
				if (TmpbmSCareerDesc != rows[i].bmSCareerDesc){
					$('#bmSDetList').datagrid('mergeCells',{
				       index:(i - mergerows),
				       field:'bmSCareerDesc',
				       rowspan:mergerows
				    });
				    mergerows=0;
				    TmpbmSCareerDesc = rows[i].bmSCareerDesc;
				}
			}
			if(i == rows.length){
				mergerows = mergerows + 1;
				$('#bmSDetList').datagrid('mergeCells',{
				       index:(i - mergerows),
				       field:'bmSCareerDesc',
				       rowspan:mergerows
				    });
			}
		}
	};
		
	var bmSDetListComponent = new ListComponent('bmSDetList', columns, '', option);
	bmSDetListComponent.Init();

	initScroll("#bmSDetList");//��ʼ����ʾ���������

	querybmSeacherDet();
}

 /**
  * �½���д����
  */
function newCreateWriteWin(){
	newCreateWrOrEdWin();  //�½���д����
	initbmSWrOrEdWin();
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
		var newWrDialogUX = new DialogUX($g('�޸�ѧԱ��Ϣ'), 'newWrWin', '730', '480', option); //lbb 2019-03-12
	}
	else{
	    var newWrDialogUX = new DialogUX($g('����ѧԱ��Ϣ'), 'newWrWin', '730', '480', option);
	}
	newWrDialogUX.Init();
	flag=0;
}

 /**
  * ���������ʦ��Ϣ
  */
function saveTeaDetail(){
	
    //����
	var bmSName=$('#bmSName').val();
	if (bmSName == ""){
		showMsgAlert("������ʾ:","��������Ϊ�գ�");
		return;
	}
	
    //�Ա�
	var bmSSex=$('#bmSSex').combobox('getValue');
	if (bmSSex == ""){
		showMsgAlert("������ʾ:","�Ա���Ϊ�գ�");
		return;
	}

    //����
	var bmSAge=$('#bmSAge').val();
	if (bmSAge == ""){
		showMsgAlert("������ʾ:","���䲻��Ϊ�գ�");
		return;
	}

	//ѧ��
	var bmSEdu=$('#bmSEdu').combobox('getValue');
	if (bmSEdu == ""){
		showMsgAlert("������ʾ:","��һѧ������Ϊ�գ�");
		return;
	}
	
	//ְ��
	var bmSCarPrvTp=$('#bmSCarPrvTp').combobox('getValue');
	if (bmSCarPrvTp == ""){
		showMsgAlert("������ʾ:","ְ�Ʋ���Ϊ�գ�");
		return;
	}
	
    //������λ
	var bmSWorkUnit=$('#bmSWorkUnit').val();
	if (bmSWorkUnit == ""){
		showMsgAlert("������ʾ:","������λ����Ϊ�գ�");
		return;
	}
	
    //��ѧ����
	var bmSBegEduDate=$('#bmSBegEduDate').datebox('getValue');
		
    //��ҵ����
	var bmSEndEduDate=$('#bmSEndEduDate').datebox('getValue');

	//��ѧ�ͱ�ҵ����Ϊ������   qunianpeng  2016-09-14
	if((bmSBegEduDate=="")||(bmSEndEduDate=="")){      
		showMsgAlert("������ʾ:","��ѧ���ںͱ�ҵ���ڶ�����Ϊ�գ�");
		return;
	}

    //��ѵרҵ
	var bmSCareer=$('#bmSCareer').combobox('getValue');
	if (bmSCareer == ""){
		showMsgAlert("������ʾ:","��ѵרҵ����Ϊ�գ�");
		return;
	}
			
    //�Ƿ�ʡ��
	var bmSOutProFlag=$('#bmSOutProFlag').combobox('getValue');
	if (bmSOutProFlag == ""){
		showMsgAlert("������ʾ:","�Ƿ�ʡ�ⲻ��Ϊ�գ�");
		return;
	}
    var bmSRemark = $("#bmSRemark").val();   //������Ϣ

	var bmStudentID = $("#bmStudentID").val();
	
	//��һרҵ
	var bmSProfession=$('#bmSProfession').combobox('getValue');
	if (bmSProfession == ""){
		showMsgAlert("������ʾ:","��һרҵ����Ϊ�գ�");
		return;
	}
	
	//���ѧ��
	var bmSHigEdu=$('#bmSHigEdu').combobox('getValue');
	if (bmSHigEdu == ""){
		showMsgAlert("������ʾ:","���ѧ������Ϊ�գ�");
		return;
	}
	
	var bmSTopProfession=$('#bmSTopProfession').combobox('getValue');
	if (bmSTopProfession == ""){
		showMsgAlert("������ʾ:","���רҵ����Ϊ�գ�");
		return;
	}
	var bmSTeacher=$('#bmSTeacher').combobox('getValue');
	if (bmSTeacher == ""){
		showMsgAlert("������ʾ:","ָ����ʦ����Ϊ�գ�");
		return;
	}
	
	var bmSTrainDate=$('#bmSTrainDate').datebox('getValue');
	if (bmSTrainDate == ""){
		showMsgAlert("������ʾ:","��ѵʱ�䲻��Ϊ�գ�");
		return;
	}
	
	var bmSIsAssessment=$('#bmSIsAssessment').combobox('getValue');
	if (bmSIsAssessment == ""){
		showMsgAlert("������ʾ:","�Ƿ�ͨ�����˲���Ϊ�գ�");
		return;
	}
	var bmSDataList = bmSName +"^"+ bmSSex +"^"+ bmSAge +"^"+ bmSEdu +"^"+ bmSCarPrvTp +"^"+ bmSWorkUnit +"^"+ bmSBegEduDate
	bmSDataList = bmSDataList +"^"+ bmSEndEduDate +"^"+ bmSCareer +"^"+ bmSOutProFlag +"^"+ bmSRemark+"^"+bmSProfession+"^"+bmSHigEdu+"^"+bmSTopProfession+"^"+ bmSTeacher+"^"+ bmSTrainDate+"^"+ bmSIsAssessment;
	//��������
	$.post(url+'?action=SaveBasManStudent',{"bmStudentID":bmStudentID,"bmSDataList":bmSDataList},function(jsonString){

		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			$('#newWrWin').dialog('close');     //�رմ���
			$('#bmSDetList').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ:","�ύʧ��,����ԭ��"+jsonConsObj.ErrorMessage);
		}
	});
}

 /**
  * ��ѯ��ѯ����
  */
function querybmSeacherDet(){
	
	//1�����datagrid 
	$('#bmSDetList').datagrid('loadData', {total:0,rows:[]});
	
	//2����ѯ
	var startDate=$('#startDate').datebox('getValue');   //��ʼ����
	var endDate=$('#endDate').datebox('getValue');       //��ֹ����

	var userName=$('#userName').val();    //����
	var CareerID=$('#Career').combobox('getValue')
	if($('#Career').combobox('getText')=="")
	{
		var CareerID="";
	}
	var TrainstartDate=$("#TrainstartDate").datebox('getValue');   
	var TrainendDate=$("#TrainendDate").datebox('getValue'); 
	
	var params=startDate +"^"+ endDate +"^"+ userName+"^"+CareerID+"^"+TrainstartDate+"^"+TrainendDate;

	$('#bmSDetList').datagrid({
		url:url + "?action=QuerybmStudentList",	
		queryParams:{
			params:params}
	});
}

/// ɾ����ѯ��ϸ
function delbmSeacherDet(){
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
	
	var rowData = $('#bmSDetList').datagrid('getData').rows[index];

	$("#bmStudentID").val(rowData.bmStuID); ///ѧԱ��ID
	$("#bmSName").val(rowData.bmSName);  	///����
	$("#bmSSex").combobox('setValue',rowData.bmSSexID);  	///�Ա�
	$("#bmSAge").val(rowData.bmSAge);       ///����
	$("#bmSEdu").combobox('setValue',rowData.bmSEdu);    	///ѧ��
	$("#bmSCarPrvTp").combobox('setValue',rowData.bmSCarePrvID);  	 ///ְ��
	$("#bmSWorkUnit").val(rowData.bmSWorkUnit);  	 ///������λ
	$("#bmSBegEduDate").datebox("setValue", rowData.bmSBegEduDate);  ///��ѧ����
	$("#bmSEndEduDate").datebox("setValue", rowData.bmSEndEduDate);  ///��ҵ����
	$("#bmSCareer").combobox('setValue',rowData.bmSCareer);  		 ///��ѵרҵ
	$("#bmSOutProFlag").combobox('setValue',rowData.bmSOutProFlag);  ///�Ƿ�ʡ��
	$("#bmSRemark").val(rowData.bmSRemark);  		 ///��ע
	$('#bmSProfession').combobox('setValue',rowData.bmSProfession);
	$('#bmSHigEdu').combobox('setValue',rowData.bmSHigEdu);
	$('#bmSTopProfession').combobox('setValue',rowData.bmSTopProfession);
	$("#bmSTeacher").combobox('setValue',rowData.bmSTeacher);
	$('#bmSTrainDate').datebox('setValue',rowData.bmSTrainDate);
	$('#bmSIsAssessment').combobox('setValue',rowData.bmSIsAssessment);

}

/// ��ʼ��������ʦ��д����
function initbmSWrOrEdWin(){
	$("#bmStudentID").val("");  ///ѧԱ��ID
	$("#bmSName").val("");  	///����
	$("#bmSSex").combobox('setValue',"");  		  ///�Ա�
	$("#bmSAge").val("");       ///����
	$("#bmSEdu").combobox('setValue',"");    	  ///ѧ��
	$("#bmSCarPrvTp").combobox('setValue',"");    ///ְ��
	$("#bmSWorkUnit").val("");  	 			  ///������λ
	$("#bmSBegEduDate").datebox("setValue", "");  ///��ѧ����
	$("#bmSEndEduDate").datebox("setValue", "");  ///��ҵ����
	$("#bmSCareer").combobox('setValue',"");  	  ///��ѵרҵ
	$("#bmSOutProFlag").combobox('setValue',"");  ///�Ƿ�ʡ��
	$("#bmSRemark").val("");  		 			  ///��ע
    $('#bmSProfession').combobox('setValue',"");
	$('#bmSHigEdu').combobox('setValue',"");
	$('#bmSTopProfession').combobox('setValue',"");
	$('#bmSTeacher').combobox('setValue',"");
	$('#bmSTrainDate').datebox('setValue',"");
	$('#bmSIsAssessment').combobox('setValue',"");
}

/// ��Ϣ��ʾ����
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("��ʾ:","<font style=''>" + ErrMsg + "</font><font style='color:red;'>" + ErrDesc + "</font>");
}
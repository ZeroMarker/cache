
///Creator:    bianshuai
///CreateDate: 2016-01-28
///Descript:   ѧԱ��Ϣ��
var flag=0;
var url="dhcpha.clinical.action.csp";
var bmSEduArr = [{"value":"1","text":'��ʿ�о���'}, {"value":"2","text":'˶ʿ�о���'}, {"value":"3","text":'����'}, {"value":"4","text":'ר��'}];
var OutProFlagArr = [{"value":"1","text":'��'}, {"value":"2","text":'��'}];

$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));     //Init��������
	
	$("a:contains('����')").bind("click",newCreateWriteWin);
	$("a:contains('��ѯ')").bind("click",querybmSeacherDet);
	$("a:contains('ɾ��')").bind("click",delbmSeacherDet);
	
	/**
	 * �Ա�
	 */
	var bmSSexCombobox = new ListCombobox("bmSSex",url+'?action=SelCTSex','',{panelHeight:"auto"});
	bmSSexCombobox.init();
	
	/**
	 * ѧ��
	 */
	var bmSEduCombobox = new ListCombobox("bmSEdu",'',bmSEduArr,{panelHeight:"auto"});
	bmSEduCombobox.init();

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
	
	$("#bmSBegEduDate").datebox("setValue", formatDate(0));  //��ѧ����
	$("#bmSEndEduDate").datebox("setValue", formatDate(0));  //��ҵ����
	
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
		{field:'bmSCareerDesc',title:'��ѵרҵ',width:100,rowspan:2},
		{title:'<span style="font-weight:bold">ѧԱ���</span>',align:'center',colspan:12}
	],[
		{field:'bmSName',title:'����',width:100},
		{field:'bmSSex',title:'�Ա�',width:80},
		{field:'bmSAge',title:'����',width:80},
		{field:'bmSEducaDesc',title:'ѧ��',width:100},
		{field:'bmSCarePrvTP',title:'ְ��',width:100},
		{field:'bmSBegEduDate',title:'��ѧʱ��',width:100},
		{field:'bmSEndEduDate',title:'��ҵʱ��',width:100},
		{field:'bmSWorkUnit',title:'������λ',width:160},
		{field:'bmSOutProFlagDesc',title:'ʡ��',width:40},
		{field:'LinkModify',title:'�޸���Ϣ',width:100,align:'center',formatter:SetCellOpUrl},
		{field:'bmSAddDate',title:'����',width:100},
		{field:'bmSAddTime',title:'ʱ��',width:90,hidden:true},
		{field:'bmSRemark',title:'��ע',width:200}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'����ѧԱ��ϸ',
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
		var newWrDialogUX = new DialogUX('�޸�ѧԱ��Ϣ', 'newWrWin', '730', '385', option); //lbb 2019-03-12
	}
	else{
	    var newWrDialogUX = new DialogUX('����ѧԱ��Ϣ', 'newWrWin', '730', '385', option);
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
		showMsgAlert("������ʾ:","ѧ������Ϊ�գ�");
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
		showMsgAlert("������ʾ:","��ѧ���ҵ���ڲ���Ϊ�գ�");
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
	
	var bmSDataList = bmSName +"^"+ bmSSex +"^"+ bmSAge +"^"+ bmSEdu +"^"+ bmSCarPrvTp +"^"+ bmSWorkUnit +"^"+ bmSBegEduDate
	bmSDataList = bmSDataList +"^"+ bmSEndEduDate +"^"+ bmSCareer +"^"+ bmSOutProFlag +"^"+ bmSRemark;
	
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
	
	var params=startDate +"^"+ endDate +"^"+ userName;

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
}

/// ��Ϣ��ʾ����
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("��ʾ:","<font style=''>" + ErrMsg + "</font><font style='color:red;'>" + ErrDesc + "</font>");
}
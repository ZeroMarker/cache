
///Creator:    bianshuai
///CreateDate: 2016-01-28
///Descript:   ҩѧ����ѯ

var editRow="";  ///��ǰ�༭������
var consultID = 0;
var flag=0
var finiFlag="N"
var url="dhcpha.clinical.action.csp";
$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));     //Init��������
	$("a:contains("+$g('�½�')+")").bind("click",newCreateConWin);
	$("a:contains("+$g('��ѯ')+")").bind("click",queryConsultDetail);
	$("a:contains("+$g('ɾ��')+")").bind("click",delConsultDetail);

	$("#consPatMedNo").bind('keypress',function(event){
        if(event.keyCode == "13"){
	        SetPatNoLength();
            GetPatEssInfoByPatNo(); //���ò�ѯ
        }
    });
	
	$("#consPatCardNo").bind('keypress',function(event){
        if(event.keyCode == "13"){
            GetPatEssInfoByCardNo(); //���ò�ѯ
        }
    });
	/**
	 * �Ա�
	 */
	var consPatSexCombobox = new ListCombobox("consPatSex",url+'?action=SelCTSex','',{panelHeight:"auto"});
	consPatSexCombobox.init();
	
	/**
	 * ������Ⱥ
	 */
	var consSpeCrowdCombobox = new ListCombobox("consSpeCrowd",url+'?action=QueryConSpCrowd','',{panelHeight:"auto"});
	consSpeCrowdCombobox.init();
	
	/**
	 * ��ѯ���
	 */
	 var consIdenCombobox = new ListCombobox("consIden",url+'?action=QueryConsIdenInfo','',{panelHeight:"auto"});
	consIdenCombobox.init();
	
	/**
	 * ��������
	 */
	var quesTypeCombobox = new ListCombobox("consType",url+'?action=QueryQuesType','',{panelHeight:"auto"});
	quesTypeCombobox.init();
	
	/**
	 * ��ѯ����
	 */
	//var conDeptCombobox = new ListCombobox("consDept",url+'?action=QueryConDept','',{});
	//conDeptCombobox.init();
	$('#consDept').combobox({
		mode:'remote',		
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			//$('#consDept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'  ')
			$('#consDept').combobox('reload',url+'?action=SelAllLoc&hospId='+LgHospID);
			//$('#dept').combobox('reload',url+'?action=SelAllLoc&HospID='+HospID)
		}
	}); 
	
	/**
	 * ��ѯ��ʽ
	 */
	var consWaysCombobox = new ListCombobox("consWays",url+'?action=QueryConsWays','',{panelHeight:"auto"});
	consWaysCombobox.init();
	
	/**
	 * �ο�����
	 */
	var consRefMatCombobox = new ListCombobox("consRefMat",url+'?action=QueryConsBasis','',{panelHeight:"auto"});
	consRefMatCombobox.init();
	
	/**
	 * ����ʱ��
	 */
	var consDurationCombobox = new ListCombobox("consDuration",url+'?action=QueryConsTime','',{panelHeight:"auto"});
	consDurationCombobox.init();;
	
	InitConsultList();    //��ʼ����ѯ��Ϣ�б�
	
	$('input').live('click',function(){
		if ((editRow != "")||(editRow == "0")) { 
            $("#consDrugItem").datagrid('endEdit', editRow); 
        } 
	});
	
})

//��ʼ������Ĭ����Ϣ
function InitConsultDefault(){

	$("#consPatientID").val(''); 				//����ID
	$("#consPatCardNo").val(''); 				//����
	$('#consPatName').val('');  				//��������	
	$('#consPatMedNo').val('');    				//������
	$('#consPatSex').combobox('setValue','');   //�Ա�
	$('#consPatAge').val('');    				//����
	$('#consContact').val('');    				//��ϵ��ʽ
	$('#consSpeCrowd').combobox('setValue',''); //������Ⱥ
	$('#consType').combobox('setValue','');     //��������
	$('#consDiagDesc').val('');       			//�����Ϣ
	$('#consWays').combobox('setValue','');     //��ѯ��ʽ
	$('#consRefMat').combobox('setValue','');   //�ο�����
	$('#consDuration').combobox('setValue',''); //����ʱ��
	$('#consQusDesc').val('');  				//��������
	$('#consAnsDesc').val('');  				//�ش�����
	$("#consultID").val(''); 					//��ѯID
	
	$('#consName').val(LgUserName);  		    //�û�����
	$('#consDept').combobox('setValue',LgCtLocID);  //Ĭ�Ͽ���
	$('#consDept').combobox('setText',LgCtLocDesc);  //Ĭ�Ͽ���
	$('#consIden').combobox('setValue','');     //��ѯ��� 

}

//��ʼ�������б�
function InitConsultList()
{

	/**
	 * ����columns
	 */
	var columns=[[
		{field:'consultID',title:'consultID',width:80,hidden:true},
		{field:'finiFlag',title:$g('���'),width:50,align:'center',formatter:SetCellColor},
		{field:'consDate',title:$g('��ѯ����'),width:100},
		{field:'consTime',title:$g('��ѯʱ��'),width:90},
		{field:'consQusTypeDesc',title:$g('��������'),width:120},
		{field:'consIdenDesc',title:$g('��ѯ���'),width:100},
		{field:'consPatName',title:$g('��������'),width:100},
		{field:'consName',title:$g('��¼��'),width:100},
		{field:'consContact',title:$g('��ϵ��ʽ'),width:100},
		{field:'consQusDesc',title:$g('��������'),width:500},
		{field:'consDet',title:$g('��ϸ'),width:100,align:'center',formatter:SetCellUrl},
		{field:'LkDetial',title:$g('����'),width:100,align:'center',formatter:SetCellOpUrl}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:$g('��ѯ��ϸ'),
		//nowrap:false,
		singleSelect : true,
		remoteSort:false,
		onLoadSuccess:function(data){
			///��ʾ��Ϣ
    		LoadCellTip("consQusDesc");
		},
		onDblClickRow:function(rowIndex, rowData){
			showModifyWin(rowIndex);
		} 
	};
		
	var conDetListComponent = new ListComponent('conDetList', columns, '', option);
	conDetListComponent.Init();

	initScroll("#conDetList");//��ʼ����ʾ���������

	queryConsultDetail();
}

/// ��ѯҩƷ�б�
function InitConsDrugItem(){
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}

	//����columns
	var columns=[[
	    {field:'consDesc',title:$g('ҩƷ����'),width:260,editor:texteditor},
	    {field:'consSpec',title:$g('���'),width:100,editor:texteditor},
		{field:'consForm',title:$g('����'),width:100,editor:texteditor},
		{field:'consManf',title:$g('����'),width:100,editor:texteditor},
		{field:'consInstruc',title:$g('�÷�'),width:100,editor:texteditor},
		{field:'consDosage',title:$g('����'),width:100,editor:texteditor},
		{field:'consDuration',title:$g('�Ƴ�'),width:100,editor:texteditor},
		{field:'operation',title:'<a href="#" onclick="appendRow()"><img style="margin:5px 0px 0px 0px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',width:30,align:'center',
			formatter:SetCellImgBtn}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		fit:'',
		//title:'ҩƷ��ϸ',
		width:970,
		singleSelect : true,
		pagination : false,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) { 
                $("#consDrugItem").datagrid('endEdit', editRow); 
            } 
            $("#consDrugItem").datagrid('beginEdit', rowIndex); 
            dataGridBindEnterEvent(rowIndex);  //���ûس��¼�
            editRow = rowIndex;
        }
	};
	
	var baseurl = url + "?action=QueryConsDrgItmList&consultID="+ consultID;
	var consDrugItemComponent = new ListComponent('consDrugItem', columns, baseurl, option);
	consDrugItemComponent.Init();
	
	//initScroll("#consDrugItem");//��ʼ����ʾ���������
	//InitdatagridRow();
}

//��ʼ���б�ʹ��
function InitdatagridRow(){

	for(var k=0;k<4;k++)
	{
		$('#consDrugItem').datagrid('insertRow',{
			index: 0, // ������
			row: {
				consDesc:'', consSpec:'', consForm:'', consManf:'', consIntr:'', consDoage:'', consDurat:''
			}
		});
	}	
}

function setCurrEditRowCellVal(rowObj){
	///Ʒ��
	var ed=$("#consDrugItem").datagrid('getEditor',{index:editRow, field:'consDesc'});		
	$(ed.target).val(rowObj.InciDesc);
	///���
	var ed=$("#consDrugItem").datagrid('getEditor',{index:editRow, field:'consSpec'});		
	$(ed.target).val(rowObj.Spec);
	///����
	var ed=$("#consDrugItem").datagrid('getEditor',{index:editRow, field:'consManf'});		
	$(ed.target).val(rowObj.Manf);
	///����
	var ed=$("#consDrugItem").datagrid('getEditor',{index:editRow, field:'consForm'});		
	$(ed.target).val(rowObj.Form);
	
	///�÷�
	var ed=$("#consDrugItem").datagrid('getEditor',{index:editRow, field:'consInstruc'});		
	$(ed.target).val(rowObj.instru);
	
	///�Ƴ�
	var ed=$("#consDrugItem").datagrid('getEditor',{index:editRow, field:'consDuration'});		
	$(ed.target).val(rowObj.duration);
	
}

/// ��datagrid�󶨻س��¼�
function dataGridBindEnterEvent(index){
	
	var editors = $('#consDrugItem').datagrid('getEditors', index);
	var workRateEditor = editors[0];
	workRateEditor.target.focus();  ///���ý���
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#consDrugItem").datagrid('getEditor',{index:index, field:'consDesc'});		
			var input = $(ed.target).val();
			var mydiv = new UIDivWindow($(ed.target), input,500,500, setCurrEditRowCellVal);   //liyarong 2016-09-28
		    //var mydiv = new UIDivWindow($("#consPatMedNo"));
            mydiv.init();
		}
	});
}

 /**
  * �½�
  */
function newCreateConWin(){
	finiFlag="N"
	consultID = 0;
	newCreateConsult();
}

 /**
  * �½���ѯ����
  */
function newCreateConsult(){
	newCreateConsultWin(); //�½���ѯ����
	InitConsultDefault();  //��ʼ������Ĭ����Ϣ
}

 /**
  * �½���ѯ����
  */
function newCreateConsultWin(){
	var option = {
			buttons:[{
				text:$g('����'),
				iconCls:'icon-save',
				handler:function(){
					saveConsultDetail();
					}
			},{
				text:$g('�ر�'),
				iconCls:'icon-cancel',
				handler:function(){
					$('#newConWin').dialog('close');
					$("#win").remove();
					}
			}]			
		};
	if(flag==1){
		var newConDialogUX = new DialogUX($g('�޸�ҩѧ��ѯ'), 'newConWin', '1000', '585', option);
	}
	else{
	    var newConDialogUX = new DialogUX($g('�½�ҩѧ��ѯ'), 'newConWin', '1000', '585', option);
	}
	newConDialogUX.Init();
	
	///��ѯҩƷ��ϸ
	InitConsDrugItem();
	flag=0;
}

 /**
  * ������ѯ����
  */
function saveConsultDetail(){
	
	 if(finiFlag=="Y"){
		alert("����ȡ����ɺ��ٽ����޸�!!!");
		return;
	 }
	
	/// �����б༭״̬
	if ((editRow != "")||(editRow == "0")) { 
        $("#consDrugItem").datagrid('endEdit', editRow); 
    }
    
    //��ѯ���
	var consIden=$('#consIden').combobox('getValue');
	if ((consIden == "")||(consIden == undefined)){
		showMsgAlert("������ʾ:","��ѯ��ݲ���Ϊ�գ�");
		return;
	}
	
	//��ѯ����
	var consDept=$('#consDept').combobox('getValue');
	if (consDept == ""){
		showMsgAlert("������ʾ:","��ѯ���Ų���Ϊ�գ�");
		return;
	}
	
	//����ID
	var consPatientID = $("#consPatientID").val();
    
    //��������
	var consPatName=$('#consPatName').val();
	if (consPatName == ""){
		showMsgAlert("������ʾ:","������������Ϊ�գ�");
		return;
	}

    //������
	var consPatMedNo=$('#consPatMedNo').val();

    //�Ա�
	var consPatSex=$('#consPatSex').combobox('getValue');
	if (consPatSex == ""){
		showMsgAlert("������ʾ:","�Ա���Ϊ�գ�");
		return;
	}

    //����
	var consPatAge=$('#consPatAge').val();
	if (consPatAge == ""){
		showMsgAlert("������ʾ:","���䲻��Ϊ�գ�");
		return;
	}
	
    //��ϵ��ʽ
	var consContact=$('#consContact').val();
	if (consContact == ""){
		showMsgAlert("������ʾ:","��ϵ��ʽ����Ϊ�գ�");
		return;
	}

   //������Ⱥ
	var consSpeCrowd=$('#consSpeCrowd').combobox('getValue'); 
	if((consSpeCrowd == "")||(consSpeCrowd == undefined)||(consSpeCrowd ==0)){
	    consSpeCrowd="";
	    }
    
    //��������
	var consType=$('#consType').combobox('getValue');
	if ((consType == "")||(consType == undefined)||(consType ==0)){
		showMsgAlert("������ʾ:","�������Ͳ���Ϊ�գ�");
		return;
	}
	
    //�����Ϣ
	var consDiagDesc=$('#consDiagDesc').val();
	if (consDiagDesc == ""){
		showMsgAlert("������ʾ:","�����Ϣ����Ϊ�գ�");
		return;
	}
	
    //��ѯ��ʽ
	var consWays=$('#consWays').combobox('getValue');
	if (consWays == ""){
		showMsgAlert("������ʾ:","��ѯ��ʽ����Ϊ�գ�");
		return;
	}
	
    //�ο�����
	var consRefMat=$('#consRefMat').combobox('getValue');
	if (consRefMat == ""){
		showMsgAlert("������ʾ:","�ο����ϲ���Ϊ�գ�");
		return;
	}
	
    //����ʱ��
	var consDuration=$('#consDuration').combobox('getValue');
	if (consDuration == ""){
		showMsgAlert("������ʾ:","����ʱ�䲻��Ϊ�գ�");
		return;
	}
	
	//��������
	var consQusDesc=$('#consQusDesc').val(); 
	if (consQusDesc == ""){
		showMsgAlert("������ʾ:","������������Ϊ�գ�");
		return;
	}
	if($('#consQusDesc').val().length>800){
			showMsgAlert("������ʾ:","�����������ܳ���800�֣�");
			return;
			}
	//�ش�����
	var consAnsDesc=$('#consAnsDesc').val(); 
	/*if (consAnsDesc == ""){
		showMsgAlert("������ʾ:","�ش����ݲ���Ϊ�գ�");
		return;
	}
	*/
	if($('#consAnsDesc').val().length>800){
			showMsgAlert("������ʾ:","�ش����ݲ��ܳ���800�֣�");
			return;
			}
	var consultID = $("#consultID").val();
	
	
	var consDataList = consPatientID +"^"+ consPatName +"^"+ consPatSex +"^"+ consPatAge +"^"+ consContact +"^"+ consSpeCrowd +"^"+ consType +"^"+ consDiagDesc;
		consDataList = consDataList +"^"+ consWays +"^"+ consRefMat +"^"+ consDuration +"^"+ consQusDesc +"^"+ consAnsDesc +"^"+ "";
		consDataList = consDataList +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ LgUserID +"^"+ consIden +"^"+ consDept+"^"+ "PHC"+"^"+LgHospID;

	/// ��ѯҩƷ�б�
	var itemListData = drugListData();
	
	//��������
	$.post(url+'?action=savePatConsult',{"consultID":consultID,"consDataList":consDataList,"consDrgItmList":itemListData},function(jsonString){
		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			$('#newConWin').dialog('close');     //�رմ���
			$('#conDetList').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ:","�ύʧ��,����ԭ��"+jsonConsObj.ErrorMessage);
		}
	});
}

 /**
  * ��ѯ��ѯ����
  */
function queryConsultDetail(){
	
	//1�����datagrid 
	$('#conDetList').datagrid('loadData', {total:0,rows:[]});
	
	//2����ѯ
	var startDate=$('#startDate').datebox('getValue');   //��ʼ����
	var endDate=$('#endDate').datebox('getValue');       //��ֹ����

	var consDesc=$('#inConsDesc').val();    //��ѯ����
	
	var params=startDate +"^"+ endDate +"^"+ LgUserID + "^" + consDesc +"^"+ "" +"^"+ "PHC" +"^"+LgHospID;

	$('#conDetList').datagrid({
		url:url + "?action=QueryPatConsult",	
		queryParams:{
			params:params}
	});
	
	//������ӵ�˳������
	$("#conDetList").datagrid('sort', {     //qunianpeng  2016-09-12
		sortName: 'consultID', 
		sortOrder: 'asc'
	});
}

/// ɾ����ѯ��ϸ
function delConsultDetail(){
	showMsgAlert("����ԭ��:" , "ɾ��������ʱ�����ã�");
}

/// �����ѯҩƷ
function addConsultDrug(){
	//$("#consDrugItem").parent().parent().css({display:"block"})	
}

//��������formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showModifyWin("+rowIndex+")'>"+$g('�޸���ϸ')+"</a>";
	
}

//��������formatter="SetCellUrl"
function SetCellColor(value, rowData, rowIndex)
{
	var html = "";
	if (value == "Y"){
		html = "<span style='margin:0px 5px;font-weight:bold;color:red;'>"+$g('���')+"</span>";		
	}else{
		html = "<span style='margin:0px 5px;font-weight:bold;color:green;'>No</span>";
		}
    return html;}


//����
function SetCellOpUrl(value, rowData, rowIndex)
{
	var html = "";
	if (rowData.finiFlag != "Y"){
		html = "<a href='#' onclick='setConsultComplete("+"\""+rowData.consultID+"\""+","+"\"Y\""+")'>"+$g('�������')+"</a>";
	}else{
		html = "<a href='#' onclick='setConsultComplete("+"\""+rowData.consultID+"\""+","+"\"N\""+")'>"+$g('ȡ�����')+"</a>";
	}
    return html;
}


/// �������״̬
function setConsultComplete(consultID, consComFlag){

	//��������
	$.post(url+'?action=setConsultComplete',{"consultID":consultID, "consComFlag":consComFlag},function(jsonString){

		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			showMsgAlert("","���óɹ���");
			$('#conDetList').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ:","����ʧ��,����ԭ��"+jsonConsObj.ErrorMessage);
		}
	});
}

 /**
  * �޸Ĵ���
  */
function showModifyWin(index){
    flag=1;
	var rowData = $('#conDetList').datagrid('getData').rows[index];
	consultID = rowData.consultID;
	finiFlag=rowData.finiFlag   //lbb  2019/11/18  ȡ���״̬����ɺ����޸ı��棬ֻ�������
	newCreateConsult();  //�½���д����
	
	$("#consPatientID").val(rowData.consPatientID); 	        //����ID
	$("#consPatCardNo").val(rowData.CardNo);
	$('#consPatName').val(rowData.consPatName);  				//��������	
	$('#consPatMedNo').val(rowData.consPatNo);	    			//������
	$('#consPatSex').combobox('setValue',rowData.consPatSex);   //�Ա�
	$('#consPatAge').val(rowData.consPatAge);    				//����
	$('#consContact').val(rowData.consContact);    				//��ϵ��ʽ
	$('#consSpeCrowd').combobox('setValue',rowData.consSpeCrowd); //������Ⱥ
	$('#consType').combobox('setValue',rowData.consQusT);         //��������
	$('#consDiagDesc').val(rowData.consDiagDesc);       		  //�����Ϣ
	$('#consWays').combobox('setValue',rowData.consWays);         //��ѯ��ʽ
	$('#consRefMat').combobox('setValue',rowData.consRefMat);     //�ο�����
	$('#consDuration').combobox('setValue',rowData.consDuration); //����ʱ��
	$('#consQusDesc').val(rowData.consQusDesc);  				  //��������
	$('#consAnsDesc').val(rowData.consAnsDesc);  				  //�ش�����
	$("#consultID").val(rowData.consultID); 					  //��ѯID
	$("#consName").val(rowData.consName); 					      //��ѯ��
	$("#consIden").combobox('setValue',rowData.consIden); 		  //��ѯ���
	$("#consDept").combobox('setValue',rowData.consDept); 		  //��ѯ����
	$("#consDept").combobox('setText',rowData.consDeptDesc); 	  //��ѯ����
}

/// ��ȡ���˾�����Ϣ
function GetPatEssInfoByPatNo(){

	var PatientNo=$('#consPatMedNo').val();    //�ǼǺ�
	if(PatientNo==""){
	   $.messager.alert("��ʾ:","��¼��ǼǺ�");
	   return;
	}
	var patFlag=tkMakeServerCall("web.DHCSTPHCMCOMMON", "checkpatFlag",PatientNo,LgHospID)
    if(patFlag==""){
	    InitConsultDefault()
	    $.messager.alert("��ʾ:","�û��߲��Ǳ�Ժ���Ļ���");
	       return;                                      
    }
 $.ajax({type: "POST", url: url, data: "action=GetPatInfoByPatNo&PatientNo="+PatientNo+"&hospId="+LgHospID, 
	   success: function(val){
			tmp=val.split("^");
			$("#consPatientID").val(tmp[0]); 	        //����ID
			$('#consPatName').val(tmp[2]);  			    //��������	
			$('#consPatCardNo').val(tmp[1]);    			    //����
			$('#consPatSex').combobox('setValue',tmp[3]);    //�Ա�
			$('#consPatAge').val(tmp[4]);    			    //����
			$('#consDiagDesc').val(tmp[5]); 
			$('#consPatMedNo').val(tmp[6]); 
			
	   }
   });

}
function GetPatEssInfoByCardNo(){

	 var PatCardNo=$('#consPatCardNo').val();    //����
	 if(PatCardNo==""){
		$.messager.alert("��ʾ:","��¼�뿨��");
	    return;
	}
	 $.ajax({type: "POST", url: url, data: "action=GetPatInfoByCardNo&PatCardNo="+PatCardNo+"&hospId="+LgHospID, 
	 success: function(val){
			tmp=val.split("^");
			var patFlag=tkMakeServerCall("web.DHCSTPHCMCOMMON", "checkpatFlag",tmp[6],LgHospID)
		    if(patFlag==""){
			    InitConsultDefault()
			    $.messager.alert("��ʾ:","�û��߲��Ǳ�Ժ���Ļ���");
			       return;
		    }
			$("#consPatientID").val(tmp[0]); 	        //����ID
			$('#consPatName').val(tmp[2]);  			    //��������	
			$('#consPatCardNo').val(tmp[1]);    			    //����
			$('#consPatSex').combobox('setValue',tmp[3]);    //�Ա�
			$('#consPatAge').val(tmp[4]);    			    //����
			$('#consDiagDesc').val(tmp[5]); 
			$('#consPatMedNo').val(tmp[6]); 
			
	   }
   })
}
/// ��Ϣ��ʾ����
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("��ʾ:","<font >" + ErrMsg + "</font><font style='color:red;'>" + ErrDesc + "</font>");
}


/// ����
function SetCellImgBtn(value, rowData, rowIndex)
{	
	return "<a href='#' onclick='deleteRow("+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}

/// ɾ����
function deleteRow(rowIndex)
{		
	// �ж���
    var rowobj={
		consDesc:'', consSpec:'', consForm:'', consManf:'', 
	  //  consIntr:'', consDoage:'', consDurat:''     //qunianpeng 2016-08-16
	   consInstruc:'',consDosage:'',consDuration:''
	};
	// ��ǰ��������4,��ɾ�����������
	if(rowIndex=="-1"){
		$.messager.alert("��ʾ:","����ѡ���У�");
		return;
	}
	var rows = $("#consDrugItem").datagrid('getRows');
	if(rows.length>4){
		 $("#consDrugItem").datagrid('deleteRow',rowIndex);
	}else{
		$("#consDrugItem").datagrid('updateRow',{
			index: rowIndex, // ������
			row: rowobj
		});
	}
	
	// ɾ����,��������
	/*
	$("#consDrugItem").datagrid('sort', {
		sortName: 'consDesc', 
		sortOrder: 'desc'
	});
	*/
}

/// ׷����
function appendRow(){
	
	// �ж���
    var rowobj={
		consDesc:'', consSpec:'', consForm:'', consManf:'', 
	    consInstruc:'', consDosage:'', consDuration:''
	};
	$("#consDrugItem").datagrid('appendRow',rowobj);
}

/// ҩƷ�б�
function drugListData(){
	
	var tmpItmArr=[];
	//����ҩƷ
	var rowsItems = $('#consDrugItem').datagrid('getRows');
	$.each(rowsItems, function(index, item){
		if(item.consDesc!=""){
		    var tmp = item.consDesc +"^"+ trsUndefinedToEmpty(item.consSpec) +"^"+ trsUndefinedToEmpty(item.consForm) +"^"+ trsUndefinedToEmpty(item.consManf);
		    tmp =  tmp +"^"+ trsUndefinedToEmpty(item.consInstruc) +"^"+ trsUndefinedToEmpty(item.consDosage) +"^"+ trsUndefinedToEmpty(item.consDuration);
		    tmpItmArr.push(tmp);
		}
	})
	return tmpItmArr.join("!!");
}

//δ����Ĭ��Ϊ��
function trsUndefinedToEmpty(str)
{
	if(typeof str=="undefined"){
		str="";
	}
	return str;
}

//�ǼǺ�λ������ʱ������    qunianpeng 2016-09-12 
function SetPatNoLength(){	
	var PatientNo=$('#consPatMedNo').val();    //�ǼǺ�
	if(PatientNo!=""){
	var PatLen=PatientNo.length;			
	if(PatLen<10)     //�ǼǺų���Ϊ10λ
	{
		for (i=1;i<=10-PatLen;i++)
		{
			PatientNo="0"+PatientNo; 
		}
	}
	$('#consPatMedNo').val(PatientNo);
	}
}
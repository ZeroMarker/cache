/// Creator: yangyongtao   
/// CreateDate: 2016-5-9
/// Descript:   �������

var url="dhcadv.repaction.csp";
var rshStatusArr = [{"val":"","text":$g('ȫ��')}, {"val":"Y","text":$g('���')}, {"val":"N","text":$g('δ���')}];
var TypeCode="",reportID="";
var ronID = "", shareId="",rshOnlineDr="";
$(function(){ 
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPageButton();         /// ���水ť����
	InitShareList();          /// ��ʼ�������б�
	InitConBakDetList();      /// ��ʼ���ظ��б�
	ResizeHeight();          /// ��ʼ��ҳ����ʽ
})
// ��ʼ������ؼ�����
function InitPageComponent(){
	$.messager.defaults = { ok: $g("ȷ��"),cancel: $g("ȡ��")};
	TypeCode= getParam("TypeCode");
	reportID= getParam("ID");     
	$("#stdate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	/**
	 * ���״̬   
	 */
	var rshStatusCombobox = new ListCombobox("rshStatus",'',rshStatusArr,{panelHeight:"auto"});
	    rshStatusCombobox.init();
	/// ���� ��Ϣ����
	$('#ronContent').bind("focus",function(){
		if(this.value==$g("������������Ϣ...")){
			$('#ronContent').val("");
		}
	});
	$('#ronContent').bind("blur",function(){
		if(this.value==""){
			$('#ronContent').val($g("������������Ϣ..."));
		}
	});
}
// ���水ť����
function InitPageButton(){
	// �����ѯ
    $('#Find').bind("click",Query);  
    // ���� ����
	$("#SaveMessage").bind("click",saveConsultDetail);
	// ���� ���
	$("#ClearMessage").bind("click",clearConsultDetail);
}
//����Ӧ hxy 2017-08-28
function ResizeHeight(){
	// ���������б� �߶�
	$("#BakDetList").height($(window).height()-250)
	$("#conBakDetList").datagrid('resize', { 
		height : $(window).height()-250
    }); 
    // �����б� �߶� 
    $("#maindgList").height($(window).height()-270)
	$("#maindg").datagrid('resize', { 
		height : $(window).height()-270
    }); 
}

//������ϸ
function InitShareList()
{	
	//����columns  reportDr
	var columns=[[
        {field:'ID',title:'ID',width:50,hidden:true},//
        {field:'reportDr',title:'reportDr',width:50,hidden:true},
        {field:'Edit',title:$g('����'),width:50,align:'center',formatter:setCellEditSymbol,hidden:false},  //�°治���¼���ʱ�ò���  yangyongtao  2017-11-23
		{field:'typeEvent',title:$g('��������'),width:60,align:'center'},
		{field:'TypeCode',title:$g('����Code'),width:50,align:'center',hidden:true},
		{field:'rshCreateDate',title:$g('��������'),width:80,align:'center'},
		{field:'rshCreateTime',title:$g('����ʱ��'),width:80,align:'center'}
	]];
	var params=TypeCode+"^"+reportID;
	//����datagrid
	$('#maindg').datagrid({
		title:'',
		url:url + "?action=getRepShareByID&params="+params,
		fit:true,
		border:false,
		columns:columns,
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		showFooter:true,
		pagination:true,
		onLoadSuccess: function (data) {
		},
		onClickRow:function(rowIndex, rowData){//������ʾ������Ϣ����
		    shareId=rowData.ID;    ///
		    rshOnlineDr="";//huaxiaoying 2018-02-05
	 		var params=shareId+"^"+LgUserID;
			$('#conBakDetList').datagrid({
				url:url + "?action=QueryRepOnline",	
				queryParams:{
					params:params
				}
			});
			// �����������
			clearConsultDetail();
	    }
	});
	initScroll("#maindg");//��ʼ����ʾ���������
}

//��ʼ�������б�
function InitConBakDetList()
{
	/**
	 * ����columns  
	 */
	var columns=[[
		{field:'ronID',title:'ronID',width:50,hidden:true}, //
		{field:'ronUserName',title:$g('������'),width:80,align:'center'},
		{field:'ronDate',title:$g('����ʱ��'),width:150,align:'center'},
		{field:'ronDesc',title:$g('��������'),width:300,formatter:setMonLevelShow},
		{field:'ronOkNum',title:$g('������'),width:80,align:'center'},
		{field:'ronAcceptFlag',title:$g('����'),width:80,align:'center',hidden:true,formatter:SetCellUrl},
		{field:'ronDetial',title:$g('���ɲ���'),width:100,align:'center',formatter:SetCellOpUrl},
		{field:'ronOKflag',title:$g('���ޱ�ʶ'),width:80,align:'center',hidden:true},
		{field:'ronDetialOKNum',title:$g('���޲���'),width:60,align:'center',formatter:SetCellOpNumUrl},
		{field:'ronOkNumDetial',title:$g('��������'),width:60,align:'center',formatter:SetCellOkNumList}
	]];

	/**
	 * ����datagrid
	 */
	$('#conBakDetList').datagrid({
		url:'',
		fit:true,
		columns:columns,
	    singleSelect:false,
		loadMsg: $g('���ڼ�����Ϣ...'),
		showFooter:true,
		pagination:true,
		fitColumns:true,
		singleSelect:true,
		border:false,
		nowrap:false,
		onLoadSuccess: function (data) {
		},
		onClickRow:function(rowIndex, rowData){//������ʾ������Ϣ����
	    	rshOnlineDr=rowData.ronID;    ///����ID
	    }
	});	
	initScroll("#conBakDetList");//��ʼ����ʾ���������
	$("#conBakDetList").datagrid('loadData',{total:0,rows:[]});
}
// ��ѯ������Ϣ
function Query()
{
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var statShare=$('#rshStatus').combobox('getValue');  //���״̬
	var params=StDate+"^"+EndDate+"^"+statShare;

	$('#maindg').datagrid({
		url:url+'?action=getRepShareList',	
		queryParams:{
			params:params}
	});
	// ���������б��������������
	$('#conBakDetList').datagrid('loadData', {total:0,rows:[]}); 
	clearConsultDetail();
}

 /**
  * ������ѯ����
  */
function saveConsultDetail(){
	
	var ronContent = $('#ronContent').val();  ///��������
	if (ronContent == $g("������������Ϣ...")){
		showMsgAlert($g("������Ϣ����Ϊ�գ�"));
		return;
	}	
	if(ronContent.length>2000){
		$.messager.alert($g("��ʾ��"),$g("������Ϣ���࣬����ʧ��"));
		return;
	}
	ronContent =$_TrsSymbolToTxt(ronContent);
	ronContent = ronContent.replace(/\r\n/g,"<br>"); 
	ronContent = ronContent.replace(/\t\n/g,"<br>");
	ronContent = ronContent.replace(/\n/g,"<br>");
	var ronDataList = LgUserID +"^"+ ronContent +"^"+ rshOnlineDr+"^"+shareId;
	 
	//��������
	$.post(url+'?action=saveReviewDetail',{"ronID":ronID,"ronDataList":ronDataList},function(jsonString){
		
		var jsonConsObj = jQuery.parseJSON(jsonString);
		if ((jsonConsObj.ErrorCode == "0")&&(shareId!="")){
			$('#conBakDetList').datagrid('reload'); //���¼���
			clearConsultDetail();
			$.messager.alert($g("��ʾ��"),$g("����ɹ���"));
		}else if(shareId==""){
			clearConsultDetail();
			$.messager.alert($g("��ʾ��"),$g("��ѡ���������Ϣ��"));
		}else{
		   $.messager.alert($g("��ʾ��"),$g("����ʧ�ܣ�"));
		}
	});
}

/// �������
function clearConsultDetail(){
	var ErrDesc=""
	$('#ronContent').val($g("������������Ϣ..."));  ///��������
}

/// ��Ϣ��ʾ����
function showMsgAlert(ErrMsg ){
	$.messager.alert($g("��ʾ��"), ErrMsg );
}
function setMonLevelShow(value,rowData,rowIndex)
{
	var html="";
	value =$_TrsTxtToSymbol(value);
	if(value != ""){
		html='<p style="line-height:1.2;text-indet:2em;letter-spacimg:3.2;">'+value+'</p>';
	}
	return html;
}

//����(����״̬) SetNumUrl
function SetCellUrl(value, rowData, rowIndex)
{
	var html = "";
	if (value == "Y"){
		html = "<span style='margin:0px 5px;font-weight:bold;color:red;'>"+$g("����")+"</span>";		
	}else{
		html = "<span style='margin:0px 5px;font-weight:bold;color:green;'>No</span>";
		}
    return html;
}
//���޲���
function SetCellOpNumUrl(value, rowData, rowIndex)
{    
	var htmlstr = "";
	if (rowData.ronOKflag != "Y"){
		htmlstr = "<a href='#' onclick='adoptOK("+"\""+rowData.ronID+"\""+","+"\"Y\""+")'><img src='../scripts/dhcadvEvt/images/heart_add.png' border=0/></a>";
	}else{    
		htmlstr = "<a href='#' onclick='adoptOK("+"\""+rowData.ronID+"\""+","+"\"N\""+")'><img src='../scripts/dhcadvEvt/images/heart_delete.png' border=0/></a>";
	}
    return htmlstr;
}
//����(����״̬)  SetCellOpNumUrl
function SetCellOpUrl(value, rowData, rowIndex)
{    
	
	var html = "";
	if (rowData.ronAcceptFlag != "Y"){
		html = "<a href='#' onclick='adoptConsult("+"\""+rowData.ronID+"\""+","+"\"Y\""+")'><img src='../scripts/dhcadvEvt/images/star_grey.png' border=0/></a>";
	}else{    
		html = "<a href='#' onclick='adoptConsult("+"\""+rowData.ronID+"\""+","+"\"N\""+")'><img src='../scripts/dhcadvEvt/images/star.png' border=0/></a>";
	}
    return html;
}

 /// ���õ���
function adoptOK(ronID,ronOKflag){
	
	var alertOKmessage="";
	if (ronOKflag=="Y"){
		alertOKmessage=$g("����"); 
	}
	if (ronOKflag=="N"){
		alertOKmessage=$g("ȡ������") ; 
	}
	 $.messager.confirm($g("��ʾ"), $g("��ȷ��Ҫ")+alertOKmessage+$g("����������"), function (res) {//��ʾ�Ƿ����	
		if (res) { 
		  	//�������� 
			$.post(url+'?action=InsRepOnlineAcc',{"ronID":ronID,"LgUserID":LgUserID},function(jsonString){
				var jsonConsObj = jQuery.parseJSON(jsonString);
			    if (jsonConsObj == "0"){						
			    	$.messager.alert($g("��ʾ"),alertOKmessage+$g("�ɹ���"));	
					$('#conBakDetList').datagrid('reload'); //���¼���
			   }else{
					$.messager.alert($g("��ʾ:"),alertOKmessage+$g("ʧ��"));
			   }				
			})
		}
	})										
}       

/// ���ò��ɱ�׼���
function adoptConsult(ronID, ronAcceptFlag){
	//��������
	params=ronID+"^"+ronAcceptFlag+"^"+LgUserID+"^"+shareId;
	var alertmessage="";
	if (ronAcceptFlag=="Y"){
		alertmessage=$g("����") ; 
	}
	if (ronAcceptFlag=="N"){
		alertmessage=$g("ȡ������") ; 
	}
	$.messager.confirm($g("��ʾ"), $g("��ȷ��Ҫ")+alertmessage+$g("��������������"), function (res) {//��ʾ�Ƿ����
		if (res){
			$.post(url+'?action=saveAdoptOnline',{"params":params},function(jsonString){	    		      
				var jsonConsObj = jQuery.parseJSON(jsonString);
				if (jsonConsObj == "0"){
			    	$.messager.alert($g("��ʾ"),alertmessage+$g("�ɹ���"));	
					$('#conBakDetList').datagrid('reload'); //���¼���
				}else if(jsonConsObj == "1"){
					$.messager.alert($g("��ʾ"),$g("�Ǳ���������ˣ���Ȩ��")+alertmessage+"��"); //hxy 2018-01-11
				}else{
			    	$.messager.alert($g("��ʾ"),alertmessage+$g("ʧ�ܣ�"));	
					//$('#conBakDetList').datagrid('reload'); //���¼���
				} 
			})
		}
	});
}

///���ñ༭����
function setCellEditSymbol(value, rowData, rowIndex)
{
		var reportDr=rowData.reportDr;         //����ID
		var TypeCode=rowData.TypeCode; //�������ʹ���
		var typeEvent=rowData.typeEvent; //�������ʹ���
		var satatusButton=1  //��ť״̬
		var recordID=rowData.recordID;         // ����¼id
		var RepStaus=rowData.RepStaus;         // ����״̬
		var rshTypeDr=rowData.rshTypeDr;         // ��������id

		return "<a href='#' onclick=\"showEditWin('"+reportDr+"','"+TypeCode+"','"+satatusButton+"','"+recordID+"','"+RepStaus+"','"+rshTypeDr+"','"+typeEvent+"')\"><img src='../scripts/dhcadvEvt/images/viewlist.png' border=0/></a>";
}

//�༭����
function showEditWin(reportDr,TypeCode,satatusButton,recordID,RepStaus,rshTypeDr,typeEvent)
{     
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:$g('��������'),
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		collapsed:false, 
		resizable:false,
		closed:"true",
		width:screen.availWidth-170,    ///2017-11-23  cy  �޸ĵ��������С 1250  ��Ŀ1550
		height:screen.availHeight-190
	});
	var iframe="";
	if(TypeCode=="material"){
		iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.matareport.csp?matadrID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
	}else if(TypeCode=="drugerr"){
		iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medsafetyreport.csp?medsrID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';		
	}else if(TypeCode=="blood"){
		iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.bloodreport.csp?bldrptID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
	}else if(TypeCode=="med"){
		iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medicalreport.csp?adrRepID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
	}else if(TypeCode=="drug"){
		iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.advreport.csp?advdrID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
	}else{
		iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+rshTypeDr+'&code='+TypeCode+'&desc='+typeEvent+'&editFlag=-1'+'&RepID='+reportDr+'"></iframe>';
	}
	$('#win').html(iframe);
	$('#win').window('open');
}

///���õ�����������  2016-05-31
function SetCellOkNumList(value, rowData, rowIndex)
{  
	return "<a href='#' onclick=\"showOkNumListWin('"+rowData.ronID+"')\"><img src='../scripts/dhcadvEvt/images/viewlist.png' border=0/></a>";
}
//�༭����
function showOkNumListWin(ronID)
{
	$('#OkNumDetail').window({
		title:$g('��������'),
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		collapsed:false, 
		resizable:false,
		modal:true,
		width:500,
		height:300
	});
	var columns=[[ 
		{field:'ID',title:'ID',align:'center',width:60},  //,hidden:true
		{field:'roaOnlineDr',title:$g('����ID'),align:'center',width:60},//,hidden:true
		{field:'roaDateTime',title:$g('��������'),align:'center',width:200},
		{field:'roaUserName',title:$g('������'),align:'center',width:80}
	]]; 
	var params=ronID;
	//����datagrid
	$('#DetailList').datagrid({
		url:url+'?action=GetOkNumDetail&params='+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		border:false,
		pageSize:20,  // ÿҳ��ʾ�ļ�¼����
		pageList:[20,40,60,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true 
	});
	$('#OkNumDetail').window('open');
}

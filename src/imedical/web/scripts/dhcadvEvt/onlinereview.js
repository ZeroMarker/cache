/// Creator: yangyongtao   
/// CreateDate: 2016-5-9
/// Descript:   ��������

var url="dhcadv.repaction.csp";
var rshStatusArr = [{"val":"","text":'ȫ��'}, {"val":"Y","text":'���'}, {"val":"N","text":'δ���'}];

var ronID = ""; shareId="";rshOnlineDr="";
$(function(){ 
	 TypeCode= getParam("TypeCode");
	 reportID= getParam("ID");     
	$("#stdate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	
		/**
	 * ���״̬   
	 */
	var rshStatusCombobox = new ListCombobox("rshStatus",'',rshStatusArr,{panelHeight:"auto"});
	    rshStatusCombobox.init();
	
	
    $('#Find').bind("click",Query);  //�����ѯ
	   InitShareList(); //��ʼ�������б�
	
	$("a:contains('����')").bind("click",saveConsultDetail);
	$("a:contains('���')").bind("click",clearConsultDetail);
	
	InitConBakDetList(); //�ظ��б�
	//1�����datagrid 
	$('#conBakDetList').datagrid('loadData', {total:0,rows:[]}); 
	InitShareList(); //�����б�
		
	$('#ronContent').bind("focus",function(){
		if(this.value=="������������Ϣ..."){
			$('#ronContent').val("");
		}
	});
	
	$('#ronContent').bind("blur",function(){
		if(this.value==""){
			$('#ronContent').val("������������Ϣ...");
		}
	});
	
 		var params=TypeCode+"^"+reportID;
 		//alert(params)
	    $('#maindg').datagrid({ 
		url:url + "?action=getRepShareByID",	
		queryParams:{
			params:params
		}
		});
})

//��ѯ������Ϣ
 function Query()
{

	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var statShare=$('#rshStatus').combobox('getValue');  //���״̬
	var params=StDate+"^"+EndDate+"^"+statShare;
	//alert(params)
	$('#maindg').datagrid({
		url:url+'?action=getRepShareList',	
		queryParams:{
			params:params}
	});

}


//��ʼ�������б�
function InitConBakDetList()
{
	/**
	 * ����columns  
	 */
	var columns=[[
		{field:'ronID',title:'ronID',width:50,hidden:true}, //
		{field:'ronUserName',title:'������',width:80,align:'center'},
		{field:'ronDate',title:'����ʱ��',width:150,align:'center'},
		{field:'ronDesc',title:'��������',width:240,formatter:setMonLevelShow},
		{field:'ronOkNum',title:'������',width:80,align:'center'},
		{field:'ronAcceptFlag',title:'����',width:80,align:'center',hidden:true,formatter:SetCellUrl},
		{field:'ronDetial',title:'���ɲ���',width:100,align:'center',formatter:SetCellOpUrl},
		{field:'ronOKflag',title:'���ޱ�ʶ',width:80,align:'center',hidden:true},
		{field:'ronDetialOKNum',title:'���޲���',width:60,align:'center',formatter:SetCellOpNumUrl},
		{field:'ronOkNumDetial',title:'��������',width:60,align:'center',formatter:SetCellOkNumList}
	]];

	/**
	 * ����datagrid
	 */
	/* var option = {
		title:'���������б�',
		nowrap:false,
		singleSelect:true
		};
	var conBakDetListComponent = new ListComponent('conBakDetList', columns, '', option);
	conBakDetListComponent.Init(); */
		//����datagrid
	//$('#conBakDetList').datagrid('loadData', {total:0,rows:[]}); 
	$('#conBakDetList').datagrid({
		title:'���������б�',
		url:'',
		fit:true,
		columns:columns,
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		showFooter:true,
		pagination:true,
		onLoadSuccess: function (data) {
		},
		onClickRow:function(rowIndex, rowData){//������ʾ������Ϣ����
	    rshOnlineDr=rowData.ronID;    ///����ID
 		//var params=shareId;
        //alert(ronID)
	    }
	});	
	initScroll("#conBakDetList");//��ʼ����ʾ���������
}

//������ϸ
function InitShareList()
{	
	//����columns  reportDr
var columns=[[
        {field:'ID',title:'ID',width:50,hidden:true},//
        {field:'reportDr',title:'reportDr',width:50,hidden:true},
        {field:'Edit',title:'����',width:50,align:'center',formatter:setCellEditSymbol,hidden:false},  //�°治���¼���ʱ�ò���  yangyongtao  2017-11-23
		{field:'typeEvent',title:'��������',width:60,align:'center'},
		{field:'TypeCode',title:'����Code',width:50,align:'center',hidden:true},
		{field:'rshCreateDate',title:'��������',width:80,align:'center'},
		{field:'rshCreateTime',title:'����ʱ��',width:80,align:'center'}
	]];
	//����datagrid
	$('#maindg').datagrid({
		title:'�����б�',
		url:'',
		fit:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
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
	    }
	});
	initScroll("#maindg");//��ʼ����ʾ���������
	
}


 /**
  * ������ѯ����
  */
function saveConsultDetail(){
	
	var ronContent = $('#ronContent').val();  ///��������
	if (ronContent == "������������Ϣ..."){
		showMsgAlert("������Ϣ����Ϊ�գ�");
		return;
	}	
	
	//var lkConsultID = "";  rshOnlineDr
	var ronDataList = LgUserID +"^"+ ronContent +"^"+ rshOnlineDr+"^"+shareId;
	 
	//��������
	$.post(url+'?action=saveReviewDetail',{"ronID":ronID,"ronDataList":ronDataList},function(jsonString){
		
		var jsonConsObj = jQuery.parseJSON(jsonString);
		//alert(shareId)
		if ((jsonConsObj.ErrorCode == "0")&&(shareId!="")){
			$('#conBakDetList').datagrid('reload'); //���¼���
			clearConsultDetail();
			$.messager.alert("��ʾ��","����ɹ���");
		}else if(shareId==""){
			clearConsultDetail();
			$.messager.alert("��ʾ��","��ѡ�����������Ϣ��");
			
		}else{
		   $.messager.alert("��ʾ��","����ʧ�ܣ�");
			}
	});
}

/// �������
function clearConsultDetail(){
	var ErrDesc=""
	$('#ronContent').val("������������Ϣ...");  ///��������
}

/// ��Ϣ��ʾ����
function showMsgAlert(ErrMsg ){
	$.messager.alert("��ʾ��", ErrMsg );
}


function setMonLevelShow(value,rowData,rowIndex)
{
	var html="";
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
		html = "<span style='margin:0px 5px;font-weight:bold;color:red;'>����</span>";		
	}else{
		html = "<span style='margin:0px 5px;font-weight:bold;color:green;'>No</span>";
		}
    return html;
}
//���޲���
function SetCellOpNumUrl(value, rowData, rowIndex)
{    
	var htmlstr = "";
	//htmlstr="<a href='#' onclick='adoptOK("+"\""+rowData.ronID+"\""+")' ><img src='../scripts/dhcadvEvt/images/heart.png' border=0/></a>";
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
        //$.messager.confirm("��ʾ", "��ȷ��Ҫ��������������", function (res) {//��ʾ�Ƿ�ɾ��	 
	      //if (res) {
	 	   html = "<a href='#' onclick='adoptConsult("+"\""+rowData.ronID+"\""+","+"\"Y\""+")'><img src='../scripts/dhcadvEvt/images/star_grey.png' border=0/></a>";
	     // }    
	   //});    
	}else{    
	//$.messager.confirm("��ʾ", "��ȷ��Ҫȡ����������������", function (res) {//��ʾ�Ƿ�ɾ��	 
         //if (res) {
		   html = "<a href='#' onclick='adoptConsult("+"\""+rowData.ronID+"\""+","+"\"N\""+")'><img src='../scripts/dhcadvEvt/images/star.png' border=0/></a>";
		   // }
	   //});
		}
    return html;
}

 /// ���õ���
function adoptOK(ronID,ronOKflag){
	
	var alertOKmessage="";
	if (ronOKflag=="Y"){
		alertOKmessage="����" ; 
	}
	if (ronOKflag=="N"){
		alertOKmessage="ȡ������" ; 
	}
	 $.messager.confirm("��ʾ", "��ȷ��Ҫ"+alertOKmessage+"����������", function (res) {//��ʾ�Ƿ����	
		if (res) { 
		  	//�������� 
			$.post(url+'?action=InsRepOnlineAcc',{"ronID":ronID,"LgUserID":LgUserID},function(jsonString){
				var jsonConsObj = jQuery.parseJSON(jsonString);
			    if (jsonConsObj == "0"){						
			     $.messager.alert("��ʾ",alertOKmessage+"�ɹ���");	
					$('#conBakDetList').datagrid('reload'); //���¼���
			   }else{
					$.messager.alert("��ʾ:",alertOKmessage+"ʧ��");
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
		alertmessage="����" ; 
	}
	if (ronAcceptFlag=="N"){
		alertmessage="ȡ������" ; 
	}
	$.messager.confirm("��ʾ", "��ȷ��Ҫ"+alertmessage+"��������������", function (res) {//��ʾ�Ƿ����
		if (res){
			$.post(url+'?action=saveAdoptOnline',{"params":params},function(jsonString){	    		      
				var jsonConsObj = jQuery.parseJSON(jsonString);
				if (jsonConsObj == "0"){
					$.messager.alert("��ʾ",alertmessage+"�ɹ���");	
					$('#conBakDetList').datagrid('reload'); //���¼���
				}else if(jsonConsObj == "1"){
					$.messager.alert("��ʾ:","�Ǳ���������ˣ���Ȩ��"+alertmessage+"��"); //hxy 2018-01-11
				}else{
					$.messager.alert("��ʾ:",alertmessage+"ʧ�ܣ�");
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
		var satatusButton=1  //��ť״̬
		return "<a href='#' onclick=\"showEditWin('"+reportDr+"','"+TypeCode+"','"+satatusButton+"')\"><img src='../scripts/dhcadvEvt/images/viewlist.png' border=0/></a>";
}

//�༭����
function showEditWin(reportDr,TypeCode,satatusButton)
{     
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'��������',
		collapsible:true,
		border:false,
		closed:"true",
		width:1080,
		height:600
	});
	if(TypeCode=="material"){
		
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.matareport.csp?matadrID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(TypeCode=="drugerr"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medsafetyreport.csp?medsrID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}
	if(TypeCode=="blood"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.bloodreport.csp?bldrptID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}	
	if(TypeCode=="med"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medicalreport.csp?adrRepID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}	
	if(TypeCode=="drug"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.advreport.csp?advdrID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}		
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
		title:'��������',
		collapsible:true,
		border:false,
		closed:"true",
		width:500,
		height:300
	});
	var columns=[[ //,hidden:true
		{field:'ID',title:'ID',align:'center',width:60},  //,hidden:true
		{field:'roaOnlineDr',title:'����ID',align:'center',width:60},//,hidden:true
		{field:'roaDateTime',title:'��������',align:'center',width:200},
		{field:'roaUserName',title:'������',align:'center',width:80}
	]]; 
	var params=ronID;
	//����datagrid
	$('#DetailList').datagrid({
		url:url+'?action=GetOkNumDetail&params='+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  // ÿҳ��ʾ�ļ�¼����
		pageList:[20,40,60,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true 
	});
	$('#OkNumDetail').window('open');
	
}
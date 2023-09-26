/*
 * FileName:	dhcbill.pkg.product.js
 * User:		DingSH
 * Date:		2019-09-24
 * Function:	
 * Description: �ײͲ�Ʒά��
 */
 //var HospDr=session['LOGON.HOSPID'];
 var GUser = session['LOGON.USERID'];
 $(function () {
	
	//��ʼ��Grid
	init_dg(); 
	
	//��ʼ���ײ���	
	init_PackageGroup();

	//��ʼ��Big-linkbutton
	init_LnkBtn_Big();
	
	//��ʼ��linkbutton
	 init_LnkBtn();
	
	
	//����searchbox���� �س��¼�
	$('#KeyWords').searchbox({  
    searcher:function(value,name){  
        initLoadGrid();
    },  
    
  })
	
	//��һ�μ��ײ�
	initLoadGrid();
	
	$('#tPanel').hide();
	// ����������
	init_ComBobox();
	
});


function init_LnkBtn_Big() {
	//����
	$HUI.linkbutton("#BtnDraft", {
		onClick: function () {
			initDraftClick();
		}
	}); 
	
	// ������
	$HUI.linkbutton("#BtnReleasePre", {
		onClick: function () {
		 iniCheckData(6,"","")
		 UpdStatus();
		}
	});
	
	
	// ����
	$HUI.linkbutton("#BtnRelease", {
		onClick: function () {
		 setValueById("pStatus","10");
		 iniCheckData(10,"����","���ͨ��")
		 showChkProdWin()
		}
	});
	
	
	// ����
	$HUI.linkbutton("#BtnReject", {
		onClick: function () {
	     iniCheckData(7,"����","")
		 showChkProdWin()
		}
	});
	

	
	//ͣ��
	$HUI.linkbutton("#BtnStopUse", {
		onClick: function () {	
	     iniCheckData(15,"ͣ��","")
		 showChkProdWin()
		}
	});
	
	//ͣ��
	$HUI.linkbutton("#BtnStopSale", {
		onClick: function () {
	     iniCheckData(20,"ͣ��","")
		 showChkProdWin()
		}
	});
	
	//����
	$HUI.linkbutton("#ProBtnSave", {
		onClick: function () {
			initProBtnSave();
		}
	});
	//ȡ��
	$HUI.linkbutton("#ProBtnCancel", {
		onClick: function () {
			
			$HUI.dialog("#ProductWin", 'close');
		}
	});
	
	
}


function iniCheckData(status,statusDesc,msg)
{
	
	  setValueById("pStatus",status);     //���״̬Code
	  $("#pStatusDesc").text(statusDesc); //���״̬
	  $("#pChkMsg").text(msg);         
	
}


function init_LnkBtn() {
	
/*	
	$HUI.linkbutton("#BtnFind", {
		onClick: function () {
	var url = "dhcbill.pkg.opcharge.paymshw.csp?papmiDr="+346+'&PrtStr='+232810+"&DiscAmt="+38.6+"&receiptNo="+"INV001"
	websys_showModal({
		url: url,
		title: "֧����Ϣ",
		iconCls: "icon-fee",
		width: "45%",
		height: "40%",
		onClose:function() {
			initLoadGrid();
		}
	});	
		}
	}); */
	
 $HUI.linkbutton("#BFindAll", {
		onClick: function () {
			
			setValueById('PStatus','');
			SetBtnAcess("")
			LeftBtnClick('BFindAll');
			//initLoadGrid();
		}
	}); 
	
	
	//�ݸ�
	$HUI.linkbutton("#BDraft", {
		onClick: function () {
			setValueById('PStatus','5');
			SetBtnAcess("5")
			LeftBtnClick('BDraft');
		}
	}); 
	
	// ������
	$HUI.linkbutton("#BReleasePre", {
		onClick: function () {
			setValueById('PStatus','6');
			SetBtnAcess("6")
			LeftBtnClick('BReleasePre');
		}
	});
	
	// �Ѳ���
	$HUI.linkbutton("#BRejected", {
		onClick: function () {
		   setValueById('PStatus','7')
		   SetBtnAcess("7")
		   LeftBtnClick('BRejected');
		}
	});
	
	// �ѷ���
	$HUI.linkbutton("#BReleased", {
		onClick: function () {
			setValueById('PStatus','10');
			SetBtnAcess("10")
			LeftBtnClick('BReleased');
		}
	});
	
	// ��ͣ�� 
	$HUI.linkbutton("#BStopUsed", {
		onClick: function () {
			setValueById('PStatus','15');
			SetBtnAcess("15")
			LeftBtnClick('BStopUsed');
		}
	});
	
	// ��ͣ��  
	$HUI.linkbutton("#BStopSaled", {
		onClick: function () {		
			setValueById('PStatus','20');
			SetBtnAcess("20")
			LeftBtnClick('BStopSaled');		 
		}
	});
	
	//���ȷ��
	$HUI.linkbutton("#pConfirm", {
		onClick: function () {	
		  var ChkMsg=getValueById("pChkMsg");
		  if (ChkMsg!="")
		  {	
		  UpdStatus();
		  }
		  else
		  {
			  $.messager.alert("��ʾ","�����������Ϊ��","info")
			 
			  
		  }
		 
		}
	});
	
	//���ȡ��
	$HUI.linkbutton("#pCancel", {
		onClick: function () {		
			$HUI.dialog("#CheckWin",'close')
		}
	});
	
	
}

function LeftBtnClick(id,CheckName) {
	 $(".a-oplist-selected").removeClass("a-oplist-selected");
	 $("#"+id).addClass("a-oplist-selected");
	 //$("#"+id).addClass("a-"+id.toLowerCase()+"-selected");
	 initLoadGrid();
}


/*
 * �ײͲ�Ʒά������datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'PROCode',title:'��Ʒ����',width:100},
			{field:'PROName',title:'��Ʒ����',width:150 },
			{field:'PROPrice',title:'��׼���',width:80 },
			{field:'PROSalesPrice',title:'ʵ���ۼ�',width:80 },	
			{field:'PROMimuamout',title:'����ۼ�',width:80},	
			{field:'PROStatusDesc',title:'��Ʒ״̬',width:80,align:'center',
				styler:function(value,row,index){
					return value==="�ѷ���"? 'color:green;font-weight:bold':'color:red;font-weight:bold'
			}},
		    {field:'PROStatus',title:'��Ʒ״̬',width:80,hidden:true },
		    {field:'PROMark',title:'��ע',width:100},
		    {field:'PROStartDate',title:'��Ч��ʼ����',width:100},
		    {field:'PROTypeDesc',title:'�ײ�����',width:100,align:'center'},
			{field:'PROProdTypeDesc',title:'ʹ������',width:100,align:'center'},
			{field:'PROLevelDesc',title:'��Ʒ�ȼ�',width:100,align:'center'},
			{field:'PRORefundStandardDesc',title:'�˷ѱ�׼',width:100,align:'center'},
			{field:'PROIsshare',title:'�Ƿ���',width:80,hidden:true},
			{field:'PROIsshareDesc',title:'�Ƿ���',width:80},
			{field:'PROIndependentpricing',title:'�Ƿ���������',width:100,hidden:true},
			{field:'PROIndepDesc',title:'�Ƿ���������',width:100},
			{field:'PROIssellseparately',title:'�Ƿ��������',width:100,hidden:true},
			{field:'PROIssellspDesc',title:'�Ƿ��������',width:100},
			{field:'PROCreator',title:'������',width:80},
			{field:'PROCreatDate',title:'��������',width:100,order:'desc',sortable:true},
			{field:'PROCreatTime',title:'����ʱ��',width:100},
		    {field:'PROUpdateUser',title:'�޸���',width:80},
			{field:'PROUpdateDate',title:'�޸�����',width:100},
			{field:'PROUpdateTime',title:'�޸�ʱ��',width:100},
		
			{field:'PRORefundStandard',title:'�˷ѱ�׼',width:100,hidden:true},
			{field:'PROUpdateUserDr',title:'PROUpdateUserDr',width:150,hidden:true },
		    {field:'PROCreatorId',title:'PROCreatorId',width:150,hidden:true },
			{field:'Rowid',title:'Rowid',width:150,hidden:true }
		]];
	$('#dg').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		frozenColumns: [[
							{
								title: '��Ʒ��ϸ', field: 'ProdInfo', width:80,align:'center',
								formatter:function(value, row, index){
									return "<a href='#' onclick='showProdWin("+JSON.stringify(row)+")' \
									'><img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/template.png ' border=0/>\
									</a>";
								}
							}
							,
						{
						 title: '����ҽ��', field: 'ProConArc', width:80,align:'center',
								formatter:function(value, row, index){
									return "<a href='#' onclick='showProConArcWdindow("+JSON.stringify(row)+")'><img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/switch.png ' border=0/>\
									</a>";
								}
							}
							
							
							
							
							
						]],
						
			onSelect:function(rowIndex, rowData)
			{
			setValueById("pProdDr",rowData.Rowid)
			setValueById("pPrice",rowData.PROPrice)
			SetBtnAcess(rowData.PROStatus)	
		    },			
						
				
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
}


function initLoadGrid(){
	var KeyWords=$("#KeyWords").searchbox('getValue') 
	var inArgStr="&KeyWords="+encodeURI(KeyWords);
	    inArgStr=inArgStr+"&Status="+getValueById('PStatus');
	    inArgStr=inArgStr+"&PkgDr="+getValueById('PackageGroup');
	    inArgStr= inArgStr+"&HospDr="+PUBLIC_CONSTANT.SESSION.HOSPID;
	var url = $URL + "?ClassName=BILL.PKG.BL.Product&QueryName=QueryProduct" +inArgStr;
    $('#dg').datagrid('options').url=url;
    $('#dg').datagrid('reload');
	
}

function init_PackageGroup(){
	$('#PackageGroup').combobox({
		valueField:'Id',
		textField:'Desc',
		url:$URL,
		mode:'remote',
		onSelect:function(data){
			initLoadGrid();					
		},
		onBeforeLoad:function(param){
			param.ClassName='BILL.PKG.BL.PackageGroup';
			param.QueryName='QueryPackageGroup';
			param.ResultSetType='array';
			param.KeyWords=param.q;
			param.ActStatus='1'
			param.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
		}	
	});
}

/*
 * �ײͲβ�Ʒ����ҽ��ά��
 */
function showProConArcWdindow(rowData){
	var url = "dhcbill.pkg.prodconarcitms.csp?ProdDr="+rowData.Rowid+'&PROCode='+rowData.PROCode+'&PROName='+charTransAsc(rowData.PROName)+'&PROStatus='+rowData.PROStatus+'&PROPrice='+rowData.PROPrice
	    url=url+'&PROSalesPrice='+rowData.PROSalesPrice+'&PROMimuamout='+rowData.PROMimuamout;
	    url=url+'&PROTypeDesc='+charTransAsc(rowData.PROTypeDesc)+'&PROStatusDesc='+ charTransAsc(rowData.PROStatusDesc)
	    url=url+'&PROProdTypeDesc='+charTransAsc(rowData.PROProdTypeDesc)+'&PROIsshareDesc='+ charTransAsc(rowData.PROIsshareDesc)
	    url=url+'&PROIndepDesc='+ charTransAsc(rowData.PROIndepDesc) +'&PROLevelDesc='+charTransAsc(rowData.PROLevelDesc)
	     url=url+'&PROIssellspDesc='+ charTransAsc(rowData.PROIssellspDesc) 
	    
	websys_showModal({
		url: url,
		title: "�ײͲ�Ʒ����ҽ��ά��",
		iconCls: "icon-w-edit",
		width: "95%",
		height: "75%",
		onClose:function() {
			initLoadGrid();
		}
	});	
}

/*
 * �����ʾ��Ʒ��Ϣ
 * ---------Start----------  
 */
function showProdWin(rowData){
	$('#tPanel').show(); 
	$('#ProdInfo').window({
		width:"900",
		height:"700",
		//left:'120px',
		title:'�ײͲ�Ʒ���',
		iconCls: "icon-w-list"
	})
	
	$('#spProCode').text(rowData.PROCode);
	$('#spProDesc').text(rowData.PROName);
	$('#spPrice').text(rowData.PROPrice);
	$('#spSalesPrice').text(rowData.PROSalesPrice);
	$('#spMimuamout').text(rowData.PROMimuamout);
	$('#ProdInfo').window('open');
	add_ProdArcItmsTableData(rowData); //ҽ����Ϣ�б� 
	
}

 /*
 * ��˵���
 * 
 */
function showChkProdWin(rowData){
	
		$HUI.dialog("#CheckWin",{
		title:"����ײ�",
		height:260,
		width:360,
		collapsible:false,
		modal:true,
	    iconCls: 'icon-w-update',
	    
	});
	
}

function add_ProdArcItmsTableData(rowData){
	var dgColumns = [[
			{field:'PRODArcimCode',title:'ҽ������',width:100},
			{field:'ArcimDesc',title:'ҽ������',width:120 },
			{field:'ItemPrice',title:'��׼����',width:90,align:'right' },
			{field:'ActualPrice',title:'ʵ�۵���',width:90,align:'right' },
			{field:'Qty',title:'����',width:70,align:'right' },
			{field:'TotalAmt',title:'���',width:80,align:'right' },
			{field:'SalesAmount',title:'ʵ�۽��',width:80,align:'right' },
			{field:'PRODDayNum',title:'��������',width:80,align:'right'},
			{field:'PRODMutex',title:'�����ʶ',width:80,align:'right',hidden:true},
			{field:'ArcimRowID',title:'PRODArcimId',width:50,hidden:true},
			{field:'Rowid',title:'Rowid',width:50,hidden:true}
		]];
	$('#ProdArcItmsTable').datagrid({
		height:300,
		title:'��Ʒҽ����Ϣ',
		headerCls:'panel-header-gray',
		//fit: true,
		border: false,
		striped: true,
		//rownumbers: true,
		fitColumns:true,
		url: $URL,
		columns: dgColumns,
		onLoadSuccess: function (data) {
			
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	});
			
	var queryParams={
			ClassName:'BILL.PKG.BL.ProductDetails',
			QueryName:'QueryProductDetails',
			ProdDr:rowData.Rowid,
	}
	$('#ProdArcItmsTable').datagrid({
		queryParams:queryParams	
	})
	$('#ProdArcItmsTable').datagrid('reload');

}

function closeProdPanel(){
	$('#tPanel').hide(); 
	$('#ProdInfo').window('close')
}

/*
 * ���������ʾ��Ʒ��Ϣ
 *
 * ---------End----------  
 */
 /*
 * Description:	ά����Ʒ��Ϣ
 * Creator:		TianZJ
 * CreatDate:	2019-09-26
 */
function initDraftClick()
{
	$('#ProductWin').show(); 

	$HUI.dialog("#ProductWin",{
		title:"�����ײ�",
		height:360,
		width:680,
		collapsible:false,
		modal:true,
	    iconCls: 'icon-w-edit',
	    onBeforeOpen:function(){
		    	$('#ProductWin').form('clear');
		    	$("#RefundType").combobox("setValue","01")
		    	$("#ProType").combobox("setValue","Bill")
		    	setDefValidStartDateValue();
		    	
		    }
	});
}

function init_ComBobox(){
	init_Group();
	PKGLoadDicData('Type','PacType','','combobox');
	PKGLoadDicData('ProType','PacCate','','combobox');
	PKGLoadDicData('Levol','PacLevl','','combobox');
	PKGLoadDicData('RefundType','RefStand','','combobox');

}

function initProBtnSave()
{  
	var ProGroup = getValueById('Group');
    var Isshare=0;Independentpricing=0;Issellseparately=0;ContractResponsibility=0
	var IsshareObj= getValueById("Isshare");
	if (IsshareObj==true){
		Isshare = 1;
	}
	var IndependentpricingObj = getValueById("Independentpricing");
	if (IndependentpricingObj==true){
		Independentpricing = 1;
	}
	var IssellseparatelyObj = getValueById("Issellseparately");
	if (IndependentpricingObj==true){
		Issellseparately = 1;
	}
	var ContractResponsibilityObj = getValueById("ContractResponsibility");
	if (IndependentpricingObj==true){
		ContractResponsibility = 1;
	}
	var ProDesc = getValueById('ProDesc');
    if(ProDesc ==''){
		$.messager.alert('��ʾ', "��Ʒ��������Ϊ��", 'info');	
		return;
	}	
	var ProCode = getValueById('ProCode');
    if(ProCode==''){
		$.messager.alert('��ʾ', "��Ʒ���벻��Ϊ��", 'info');	
		return;
	}	
	var Levol = getValueById('Levol');
    if(Levol ==''){
		$.messager.alert('��ʾ', "��Ʒ�ȼ�����Ϊ��", 'info');	
		return;
	}	
	var ValidStartDate = getValueById('ValidStartDate');
    if(ValidStartDate ==''){
		$.messager.alert('��ʾ', "��ʼʹ�����ڲ���Ϊ��", 'info');	
		return;
	}	
	//var Protructure = getValueById('Protructure');
	var Protructure="" ;
	/*
    if(Protructure =='') {
		$.messager.alert('��ʾ', "��Ʒ�ṹ����Ϊ��", 'info');	
		return;
	}
	*/	
	var Type = getValueById('Type')
    if(Type==''){
		$.messager.alert('��ʾ', "�ײ����Ͳ���Ϊ��", 'info');	
		return;
	}	
	var ProType = getValueById('ProType');
    if(ProType==''){
		$.messager.alert('��ʾ', "ʹ�����Ͳ���Ϊ��", 'info');	
		return;
	}	
	var RefundType = getValueById('RefundType');
    if(RefundType==''){
		$.messager.alert('��ʾ', "�˷ѱ�׼����Ϊ��", 'info');	
		return;
	}
	// �жϴ˲�Ʒ�����ǲ����Ѿ�����ͬ�Ĳ�Ʒ����ʱ��������ӳɹ���
	// �ж�û��ά����Ʒ��ʱ���ǲ�ʱ�Ѿ�������ͬ�Ĳ�Ʒ����ʱ��������ӳɹ���
	// �����������ۡ��������������ɡ���Ʒ��������Ʒ���롢��ʼʹ�����ڡ��ȼ����ṹ����Ʒ���͡�ʹ�����͡��˷ѱ�׼
	var ExStr=ProGroup+"^"+ProCode+"^"+ProDesc+"^"+ValidStartDate+"^"+Levol+"^"+Protructure+"^"+ProType+"^"+Type+"^"+RefundType;
	ExStr = ExStr+"^"+Isshare+"^"+Independentpricing+"^"+Issellseparately+"^"+ContractResponsibility;
	ExStr = ExStr+"^"+PUBLIC_CONSTANT.SESSION.USERID+"^"+PUBLIC_CONSTANT.SESSION.HOSPID
	$.m({
		ClassName: "BILL.PKG.BL.Product",
		MethodName: "CheckProduct",
		ProGroup:ProGroup,
		Code:ProCode,
		Desc:ProDesc,
	}, function (rtn) {
		if(rtn!='0'){
			$.messager.alert('��ʾ','�Ѿ�������ͬ�Ĳ�Ʒ������������'+rtn,'info');
			return ;
		}else{
			saveInfo(ExStr); // ���ظ����ܽ��з���
		}
	});
}

function saveInfo(ExStr){
	$.m({
		ClassName: "BILL.PKG.BL.Product",
		MethodName: "ProGroupDuctSave",
		ExStr: ExStr
	}, function(rtn){
		if(rtn.split('^')[0]=='0'){
			$.messager.alert('��ʾ', "����ɹ�", 'info');
			setTimeout("initLoadGrid()",1500);	
		}else{
			$.messager.alert('��ʾ', "����ʧ�ܣ�������룺" + rtn.split('^')[1], 'error');	
		}
		$HUI.dialog("#ProductWin", 'close');
	});
}

function init_Group(){
	$('#Group').combobox({
		valueField:'Id',
		textField:'Desc',
		url:$URL,
		mode:'remote',
		onSelect:function(data){
			initLoadGrid();
		},
		onBeforeLoad:function(param){
			param.ClassName='BILL.PKG.BL.PackageGroup';
			param.QueryName='QueryPackageGroup';
			param.ResultSetType='Array';
			param.KeyWords=param.q;
			param.ActStatus='1'
			param.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
		}		
	});
}

//���״̬����
function UpdStatus(){
	
	if (getValueById("pProdDr")==""){
		
		$.messager.alert("��ʾ","��ѡһ��������ײ�","info")
		return ;
		
		}
		
	if (getValueById("pPrice")=="0.00"){
		
		$.messager.alert("��ʾ","����Ϊ���ײ͹���ҽ��","info")
		return ;
		
		}
		
		
	
	$.m(
	
	    {
		    ClassName:"BILL.PKG.BL.Product",
		    MethodName:"UpdStatus",
		    ProdDr:getValueById("pProdDr"),
		    Status:getValueById("pStatus"),
		    ChkMsg:getValueById("pChkMsg"),
		    UserDr:GUser,
		    ExpStr:""
		   
		 },
	    
	    function(rtn)
	    {
		    
		    if(rtn.split("^")[0]==0)
		    {
			    
			    $.messager.alert("��ʾ","������","info")
			    setTimeout("initLoadGrid()",1500);
			    $HUI.dialog("#CheckWin",'close')
			}else
			{
				
				$.messager.alert("��ʾ","���ʧ��,Err="+rtn,"error")
				
		    }
		    
		    
		 }
	
	
    	);
	
	
	
	
	}


//������˰�ťȨ��	
function SetBtnAcess(Status)
{
	
	
	
	
   if(Status=="")
   {
	   disableById("BtnReleasePre"); //������
	   disableById("BtnReject");     //����
	   disableById("BtnRelease");   //����
	   disableById("BtnStopUse");    //ͣ��
	   disableById("BtnStopSale");   //ͣ��
	   
   }
	 
   //5 �ݸ�״̬	 
   if(Status==5)
   {
	   enableById("BtnReleasePre"); //������
	   disableById("BtnReject");     //����
	   disableById("BtnRelease");   //����
	   disableById("BtnStopUse");    //ͣ��
	   disableById("BtnStopSale");   //ͣ��
	   
   }
   //6 ������״̬	 
   if(Status==6)
   {
	   
	   disableById("BtnReleasePre"); //������
	   enableById("BtnReject");     //����
	   enableById("BtnRelease");   //����
	   disableById("BtnStopUse");    //ͣ��
	   disableById("BtnStopSale");   //ͣ��
	   
   }
   //7 ����״̬	 
   if(Status==7)
   {
	   
	   enableById("BtnReleasePre"); //������
	   disableById("BtnReject");     //����
	   disableById("BtnRelease");   //����
	   disableById("BtnStopUse");    //ͣ��
	   disableById("BtnStopSale");   //ͣ��
	   
   }
   //10 ����״̬	 
   if(Status==10)
   {
	   
	   disableById("BtnReleasePre"); //������
	   disableById("BtnReject");     //����
	   disableById("BtnRelease");   //����
	   enableById("BtnStopUse");    //ͣ��
	   enableById("BtnStopSale");   //ͣ��
	   
   }
   //15 ͣ��״̬
   if(Status==15)
   {
	   
	   disableById("BtnReleasePre"); //������
	   disableById("BtnReject");     //����
	   disableById("BtnRelease");   //����
	   disableById("BtnStopUse");    //ͣ��
	   disableById("BtnStopSale");   //ͣ��
	   
   }
    //20 ͣ��״̬
   if(Status==20)
   {
	   
	   disableById("BtnReleasePre"); //������
	   disableById("BtnReject");     //����
	   disableById("BtnRelease");   //����
	   disableById("BtnStopUse");    //ͣ��
	   disableById("BtnStopSale");   //ͣ��
	   
   }
   
   
	 
	 
}


/**
* ��ʼʹ����������Ĭ��
*/
function setDefValidStartDateValue() {
	
	var curDateTime = getCurDateTime();
	var myAry = curDateTime.split(/\s+/);
	setValueById("ValidStartDate", myAry[0]);
	
}

/**
* ȡ��ǰʱ��
*/
function getCurDateTime() {
	return $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "FormDateTime"}, false);
}


// Ժ��combogridѡ���¼�
function selectHospCombHandle(){
	init_PackageGroup()
	//alert("PUBLIC_CONSTANT.SESSION.HOSPID="+PUBLIC_CONSTANT.SESSION.HOSPID)
	initLoadGrid()
	
	}
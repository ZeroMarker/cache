var cureApplyDataGrid;
var DCARowId=""
$(function(){
	/*
    if (PatientID=="")
	{
		var frm =dhcsys_getmenuform();
        if (frm) 
        {
			EpisodeID=frm.EpisodeID.value;
			PatientID=frm.PatientID.value;
        }
	}
	*/
	InitCureApplyDataGrid();
	
	
});

//��ʼ��
function Int()
{
	loadCureApplyDataGrid()
	IntCatdType()
	$('#btnReadCard').click(ReadCard)
	$('#patNoIn').keydown(patNoInKeyDown) 
	$('#patNoIn').keyup(patNoInkeyup) 
	$('#btnFind').click(loadCureApplyDataGrid)
	$('#cardNo').keydown(cardNoKeyDown)
	$('#cardNo').keyup(cardNokeyUp)
	$('#DocApplayNo').keydown(DocApplayNoKeyDown)
	$('#btnFinish').click(btnFinish) //���뵥������ɺ�ʹ�øù���
	
	
	
}

//�������뵥����ɲ���
function btnFinish()
{
	var rows = cureApplyDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
			$.messager.alert("��ʾ","��ѡ��һ�����뵥");
			return false;
	}else if (rows.length>1){
	     	$.messager.alert("����","��ѡ���˶�����뵥��",'err')
	     	return false;
     }
	var DCARowId=""
	var rowIndex = cureApplyDataGrid.datagrid("getRowIndex", rows[0]);
	var selected=cureApplyDataGrid.datagrid('getRows'); 
	var DCARowId=selected[rowIndex].DCARowId;
	if(DCARowId=="")
	{
			$.messager.alert('Warning','��ѡ��һ�����뵥');
			return false;
	}
	var Rtn=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","FinishCureApply",DCARowId,session['LOGON.USERID'])
	if (Rtn==0){
		$.messager.alert('��ʾ','�����ɹ�!');
		return false;
	}else{
		$.messager.alert('����','����ʧ��:'+Rtn);
		return false;
		
	}
}

function DocApplayNoKeyDown(e)
{
	if(e.keyCode==13){
		var DocApplayNo=$('#DocApplayNo').val()
		if (DocApplayNo==""){$.messager.alert("��ʾ","��������Ч�����뵥��");return false}
		loadCureApplyDataGrid()
	}
	
}
function cardNokeyUp()
{
	var CardNo=$('#cardNo').val()
	if (CardNo==""){
		 $("#patNo").val("");
		 $("#PatientID").val('')
		 
	}
	
}
//���Żس�
function cardNoKeyDown(e)
{
	if(e.keyCode==13)
	 {  
		      $("#patNo").val("");
		      $("#PatientID").val('')
		      var cardType=$("#cardType").combobox('getValue');
		      if (cardType==""){$.messager.alert("��ʾ","�����Ͳ�����!");return false;} 
		      var cardTypeInfo=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetCardTypeInfo",cardType);
			  if (cardTypeInfo==""){ $.messager.alert("��ʾ","��������Ϣ��ȡʧ��");return false;}
			  var cardNoLength=cardTypeInfo.split("^")[16];
			  var cardNo=$("#cardNo").val();
			  if(cardNo=="") return false;
			  if ((cardNo.length<cardNoLength)&&(cardNoLength!=0)) {
					for (var i=(cardNoLength-cardNo.length-1); i>=0; i--) {
						cardNo="0"+cardNo;
					}
				}
			 $("#cardNo").val(cardNo);
			 var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",cardNo,cardType)
			 if(PatientID=="")
			 {
				 $("#cardNo").val('');
				 $.messager.alert("��ʾ","����Ч");
				 return false;
			 }
			$("#PatientID").val(PatientID)
			loadCureApplyDataGrid()
			 
	}	
	
}

function patNoInkeyup()
{
	var patNoIn=$("#patNoIn").val()
	if (patNoIn==""){
		$("#PatientID").val('')
	}
	
}
function patNoInKeyDown(e)
{

	if(e.keyCode==13)
	{
		 $("#cardNo").val("");
		  var patNo=$("#patNoIn").val();
		  if(patNo=="") return;
		  for (var i=(10-patNo.length-1); i>=0; i--) {
			patNo="0"+patNo;
		}
		$("#patNoIn").val(patNo);
		var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByNo",patNo)
		if (PatientID==""){
			$.messager.alert("��ʾ","δ��ѯ���ǼǺŶ�Ӧ�Ļ�����Ϣ����ȷ�ϵǼǺ��Ƿ���ȷ!");
			$("#patNoIn").val('');
			$("#PatientID").val('')
			return false
		}
		else{
			
			$("#PatientID").val(PatientID)
			loadCureApplyDataGrid()
		}
		
	}
	
	
}
//����
function ReadCard()
{
	$("#cardType").combobox('setValue',2)
	var cardType=$("#cardType").combobox('getValue');
	var ret=tkMakeServerCall('web.UDHCOPOtherLB','ReadCardTypeDefineListBroker1',cardType);
    var CardInform=DHCACC_GetAccInfo(cardType,ret)
    var myary=CardInform.split("^");
    var rtn=myary[0];
	switch (rtn){
		case "-200": //����Ч
			$.messager.alert("��ʾ","����Ч!");
			$('#cardNo').val('')
			$("#PatientID").val('')
			break;
		default:
			$('#cardNo').val(myary[1])
			 var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",myary[1],cardType)
			 if(PatientID=="")
			 {
				 $.messager.alert("��ʾ","��δ��ѯ����Ч�Ļ�����Ϣ!");
				 $("#cardNo").val('');
				 return;
			 }
			 $("#PatientID").val(PatientID)
			 loadCureApplyDataGrid()
			 break;
	}

}
//��ʼ��������
function IntCatdType()
{
	
		//�������б�
    $('#cardType').combobox({      
    	valueField:'CardTypeId',   
    	textField:'CardTypeDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.Config';
						param.QueryName = 'FindCardType'
						param.ArgCnt =0;
		}  
	});	
	

     $('#cardNo').bind('keydown', function(event){
		  
    });
    $('#cardNo').bind('change', function(event){
		   if ($("#cardNo").val()==""){$("#PatientID").val("");}
    });
	
	
	
}

//��ʼ�����뵥Table
function InitCureApplyDataGrid()
{
	// Toolbar
	var cureApplyToolBar = [{
		id:'BtnDetailView',
		text:'���뵥���', 
		iconCls:'icon-search',  
		handler:function(){
			OpenApplyDetailDiag();
		}
	}
	,'-',{
		id:'BtnClear',
		text:'����', 
		iconCls:'icon-cancel',  
		handler:function(){
			location.reload();
		}
	}];
	// ���Ƽ�¼���뵥Grid fit : true,
	cureApplyDataGrid=$('#tabCureApplyList').datagrid({  
		
		width : 'auto',
		border : true,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:true,    
		url : '',
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : false,  //
		idField:"DCARowId",
		pageNumber:0,
		pageSize : 0,
		pageList : [5],
		//frozenColumns : FrozenCateColumns,
		columns :[[ 
		
					{field:'RowCheck',checkbox:true},
					{field:'PapmiNo',title:'���ߵǼǺ�',width:150,align:'center'},
					{field:'PatName',title:'��������',width:100,align:'center'},
					{field:'Sex',title:'�Ա�',width:50,align:'center'},
					{field:'Tel',title:'���ߵ绰',width:150,align:'center'},  
					{field:'GovNo',title:'���֤',width:100,align:'center',hidden:true},
					{field:'DocCurNO',title:'���뵥���',width:150,align:'center'},
        			{field:'ArcimDesc',title:'��������',width:200,align:'center'},
        			{field:'OrdStatus',title:'ҽ��״̬',width:80,align:'center',hidden:true},
        			{field:'OrdBillUOM',title:'�Ƽ۵�λ',width:100,align:'center'}, 
        			{field:'OrdReLoc',title:'���տ���',width:150,align:'center'},   
        			{field:'ApplyStatus',title:'״̬',width:80,align:'center',
        				styler:function(value,row,index){
	        				if (value=="ȡ��"){
		        				return 'color:red'	
		        			}
	        			}
        			},
        			{field:'ApplyUser',title:'�µ�ҽ��',width:120,align:'center'},
        			{field:'AppLoc',title:'�µ�����',width:120,align:'center'},
        			{field:'ApplyDateTime',title:'����ʱ��',width:200,align:'center'},
        			{field:'OrdQty',title:'��������',width:100,align:'center'}, 
        			{field:'ApplyAppedTimes',title:'��Լ����',width:100,align:'center'},
        			{field:'ApplyNoAppTimes',title:'δԼ����',width:100,align:'center'},
        			{field:'ApplyFinishTimes',title:'������',width:100,align:'center'},
        			{field:'ApplyNoFinishTimes',title:'δ����',width:100,align:'center'},
        			{field:'ApplyRemarks',title:'��ע',width:150,align:'center'},
        			{field:'ApplyPlan',title:'���Ʒ���',width:150,align:'center'},
        			{field:'Adm',title:'�����',width:150,align:'center'},
        			{field:'InsertDate',title:'���뵥����',width:100,align:'center',hidden:true},
        			{field:'InsertTime',title:'���뵥ʱ��',width:100,align:'center',hidden:true},
        			
        			{field:'DCARowId',title:'DCARowId',width:100,hidden:true},
        			{field:'OrdReLocId',title:'OrdReLocId',width:100,hidden:true}	   
    			 ]] ,
    	toolbar : cureApplyToolBar,
		onClickRow:function(rowIndex, rowData){
			//alert()
			loadTabData()
		}
	});
	$('#tabs').tabs({
  onSelect: function(title,index){
	loadTabData()
  }
});

}

//��ѯ ���뵥�б�
function loadCureApplyDataGrid()
{
	//EpisodeID
	var DisCancel=""
	var DisFinish=""
	var PatientID=$("#PatientID").val()
	var CancelDis=$("#CancelDis").prop("checked")
	if (CancelDis){DisCancel="Y"}
	var FinishDis=$("#FinishDis").prop("checked")
	if (FinishDis){DisFinish="Y"}
	var DocApplayNo=$('#DocApplayNo').val()
	
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Apply';
	queryParams.QueryName ='FindCureApplyList';
	queryParams.Arg1 ="";
	queryParams.Arg2 =PatientID;
	queryParams.Arg3 =session['LOGON.CTLOCID'];
	queryParams.Arg4 =DisCancel;
	queryParams.Arg5 =DocApplayNo;
	queryParams.Arg6 =DisFinish;
	queryParams.ArgCnt =6;
	var opts = cureApplyDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureApplyDataGrid.datagrid('load', queryParams);
	cureApplyDataGrid.datagrid('unselectAll');
}
//��ѯ���뵥��Ӧ�����Ƽ�¼
function loadTabData()
{
		var rows = cureApplyDataGrid.datagrid("getSelections");
		var DCARowId=""
		if (rows.length==1)
		{
		var rowIndex = cureApplyDataGrid.datagrid("getRowIndex", rows[0]);
		var selected=cureApplyDataGrid.datagrid('getRows'); 
		var DCARowId=selected[rowIndex].DCARowId;
		}
		var title = $('.tabs-selected').text();
		var href=""
		if (title=="ԤԼ") 
		{href="dhcdoc.cure.applyreslist.csp?OperateType=YS&DCARowId="+DCARowId;}
		else if (title=="ԤԼ�б�") 
		{href="dhcdoc.cure.applyapplist.csp?OperateType=YS&DCARowId="+DCARowId;}
		else if (title=="���Ƽ�¼�б�") 
		{href="dhcdoc.cure.curerecordlist.csp?OperateType=YS&DCARowId="+DCARowId;}
		//alert(href);
		if(href=="")return;
		refreshTab({tabTitle:title,url:href}); 
}

function OpenApplyDetailDiag()
{
	var rows = cureApplyDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
			$.messager.alert("��ʾ","��ѡ��һ�����뵥");
			return;
	}else if (rows.length>1){
	     	$.messager.alert("����","��ѡ���˶�����뵥��",'err')
	     	return;
     }
	var DCARowId=""
	var rowIndex = cureApplyDataGrid.datagrid("getRowIndex", rows[0]);
	var selected=cureApplyDataGrid.datagrid('getRows'); 
	var DCARowId=selected[rowIndex].DCARowId;
	if(DCARowId=="")
	{
			$.messager.alert('Warning','��ѡ��һ�����뵥');
			return false;
	}
	
	var href="dhcdoc.cure.apply.csp?DCARowId="+DCARowId;
	var ReturnValue=window.showModalDialog(href,"","dialogwidth:60em;dialogheight:30em;status:no;center:1;resizable:yes");
	/*
	var _content ="<iframe src='"+href+ "' scrolling='no' frameborder='0' style='width:100%;height:100%;'></iframe>"
	   $("#ApplyDetailDiag").dialog({
        width: 800,
        height: 470,
        modal: true,
        content: _content,
        title: "�������뵥",
        draggable: true,
        resizable: true,
        shadow: true,
        minimizable: false
    });*/ 
}
function refreshTab(cfg){  
    var refresh_tab = cfg.tabTitle?$('#tabs').tabs('getTab',cfg.tabTitle):$('#tabs').tabs('getSelected');  
    if(refresh_tab && refresh_tab.find('iframe').length > 0){  
    var _refresh_ifram = refresh_tab.find('iframe')[0];  
    var refresh_url = cfg.url?cfg.url:_refresh_ifram.src;   
    _refresh_ifram.contentWindow.location.href=refresh_url;  
    }  
}  

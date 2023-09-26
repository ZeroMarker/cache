var cureApplyDataGrid;
var DCARowId=""
$(function(){
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
	$('#btnFind').bind('click', function(){
		   loadCureApplyDataGrid();
    });
    $('#patNo').bind('keydown', function(event){
		   if(event.keyCode==13)
		   {
			  var patNo=$("#patNo").val();
			  if(patNo=="") return;
			  for (var i=(10-patNo.length-1); i>=0; i--) {
				patNo="0"+patNo;
			}
			$("#patNo").val(patNo);
			var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByNo",patNo)
			$("#PatientID").val(PatientID);
			loadCureApplyDataGrid();
		   }
    });
     $('#cardNo').bind('keydown', function(event){
		   if(event.keyCode==13)
		   {  
		      if ($("#patNo").val()!="")$("#patNo").val("");
		      var cardType=$("#cardType").combobox('getValue');
		      if (cardType=="") return;
		      var cardTypeInfo=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetCardTypeInfo",cardType);
			  if (cardTypeInfo=="") return;
			  var cardNoLength=cardTypeInfo.split("^")[16];
			  //alert(cardNoLength);
			  var cardNo=$("#cardNo").val();
			  if(cardNo=="") return;
			  if ((cardNo.length<cardNoLength)&&(cardNoLength!=0)) {
					for (var i=(cardNoLength-cardNo.length-1); i>=0; i--) {
						cardNo="0"+cardNo;
					}
				}
			$("#cardNo").val(cardNo);
			var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",cardNo,cardType)
			if(PatientID=="")
			{
				 alert("����Ч");
				 return;
			}
			$("#PatientID").val(PatientID);
			loadCureApplyDataGrid();
		   }
    });
      $('#btnReadCard').bind('click', function(){
			  ReadCardClick();
    });  
    $('#btnReadInsuCard').bind('click', function(){
			  ReadInsuCardClick();
    });
     $('#btnSearchApp').bind('click', function(){
			  ReadInsuCardClick();
    });
	InitCureApplyDataGrid();
	loadCureApplyDataGrid();
});
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
	// ���Ƽ�¼���뵥Grid
	cureApplyDataGrid=$('#tabCureApplyList').datagrid({  
		fit : true,
		width :500,
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
		idField:"ARCIMId",
		pageNumber:0,
		pageSize : 0,
		pageList : [10,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :[[ 
					{field:'RowCheck',checkbox:true},     
        			{field:'PatNo',title:'�ǼǺ�',width:40,align:'center'},   
        			{field:'PatName',title:'����',width:40,align:'center'},   
        			{field:'PatSex',title:'�Ա�',width:10,align:'center'},
        			{field:'PatAge',title:'����',width:10,align:'center'},
        			{field:'PatTel',title:'��ϵ�绰',width:10,align:'center'},
        			{field:'AdmType',title:'��������',width:30,align:'center'},
        			{field:'AdmDep',title:'�������',width:50,align:'center'},    
        			{field:'ArcimDesc',title:'������Ŀ',width:50,align:'center'},
        			{field:'OrdQty',title:'����',width:30,align:'center'}, 
        			{field:'OrdBillUOM',title:'��λ',width:50,align:'center'}, 
        			{field:'OrdReLoc',title:'���տ���',width:50,align:'center'},   
        			{field:'ApplyStatus',title:'���뵥״̬',width:50,align:'center'},
        			{field:'ApplyUser',title:'����ҽ��',width:80,align:'center'},
        			{field:'ApplyDateTime',title:'����ʱ��',width:50,align:'center'},
        			{field:'ApplyAppedTimes',title:'��ԤԼ����',width:10,align:'center'},
        			{field:'ApplyNoAppTimes',title:'δԤԼ����',width:10,align:'center'},
        			{field:'ApplyFinishTimes',title:'�����ƴ���',width:10,align:'center'},
        			{field:'ApplyNoFinishTimes',title:'δ���ƴ���',width:10,align:'center'},
        			{field:'DCARowId',title:'DCARowId',width:100,hidden:true}  	   
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
function loadCureApplyDataGrid()
{
	var PatientID=$("#PatientID").val();
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var queryStatus=$("#queryStatus").val();
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Apply';
	queryParams.QueryName ='FindAllCureApplyList';
	queryParams.Arg1 =PatientID;
	queryParams.Arg2 =StartDate;
	queryParams.Arg3 =EndDate;
	queryParams.ArgCnt =3;
	var opts = cureApplyDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureApplyDataGrid.datagrid('load', queryParams);
	cureApplyDataGrid.datagrid('unselectAll');
}
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
		{href="dhcdoc.cure.applyreslist.csp?OperateType=ZLYY&DCARowId="+DCARowId;}
		else if (title=="ԤԼ�б�") 
		{href="dhcdoc.cure.applyapplist.csp?OperateType=ZLYY&DCARowId="+DCARowId;}
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
function ReadCardClick()
{
	var cardType=$("#cardType").combobox('getValue');
	//var myEquipDR=DHCWeb_GetListBoxValue("CardTypeDefine");
	//var myEquipDR=combo_CardType.getActualValue();
	var ret=tkMakeServerCall('web.UDHCOPOtherLB','ReadCardTypeDefineListBroker1',cardType);
    var CardInform=DHCACC_GetAccInfo(cardType,ret)
    //alert(CardInform)
    var myary=CardInform.split("^");
    var rtn=myary[0];
	switch (rtn){
		case "-200": //����Ч
			alert("����Ч");
			document.getElementById('cardNo').value=""
			break;
		default:
			document.getElementById('cardNo').value=myary[1] //myary[2]
			var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",myary[1],cardType)
			if(PatientID=="")
			{
				 alert("����Ч");
				 return;
			}
			$("#PatientID").val(PatientID);
			loadCureApplyDataGrid();
			break;
	}
		
    
}
function ReadInsuCardClick()
{
	$("#cardType").combobox('setValue',4)
	var cardType=$("#cardType").combobox('getValue');
	var CardInform=DHCACC_ReadMagCard(cardType,"","","");
	var myary=CardInform.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "-200": //����Ч
			alert("����Ч");
			document.getElementById('cardNo').value=""
			break;
		
		default:
			document.getElementById('cardNo').value=myary[1];
			/*
			var myrtn=DHCACC_GetAccInfo("",myary[1],"","PatInfo");
			var myary=myrtn.split("^");
			var rtn=myary[0];
			AccAmount=myary[3];
			//alert(myrtn)

			switch (rtn){
			case "-200": //����Ч
				alert("����Ч");
				document.getElementById('PatientNo').value=""
				websys_setfocus("PatientNo");
				break;
			default:
				//alert(myrtn)
				document.getElementById('PatientNo').value=myary[5]
				return Find_click();
				websys_setfocus("PatientNo");
				break;
				}*/
			break;
	}
}
  

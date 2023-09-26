var cureWorkListDataGrid;
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
	//�������б�
    $('#serviceGroup').combobox({      
    	valueField:'Rowid',   
    	textField:'Desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.RBCServiceGroupSet';
						param.QueryName = 'QueryServiceGroup'
						param.ArgCnt =0;
		}  
	});
	$('#btnFind').bind('click', function(){
		   loadCureWorkListDataGrid();
    });

    $('#btnReadCard').bind('click', function(){
		   ReadCard();
    });
    $('#btnReadInsuCard').bind('click', function(){
		   ReadInsuCard();
    });
    
    $('#saveOrder').bind('click', function(){
		   saveOrder();
    });
    $('#DHCDocANUm').bind('keydown', function(e){
	     if(event.keyCode==13){
		    loadCureWorkListDataGrid()
		    
		 }
		   //saveOrder();
    });
    
    
    
    
    
    $('#patNo').bind('keydown', function(event){
		   if(event.keyCode==13)
		   {
			  if ($("#cardNo").val()!="")$("#cardNo").val("");
			  var patNo=$("#patNo").val();
			  if(patNo=="") return;
			  for (var i=(10-patNo.length-1); i>=0; i--) {
				patNo="0"+patNo;
			}
			$("#patNo").val(patNo);
			var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByNo",patNo)
			$("#PatientID").val(PatientID);
			loadCureWorkListDataGrid();
		   }
		   if ($("#patNo").val()=="")
		   {$("#PatientID").val("");}
    });
    $('#patNo').bind('change', function(event){
		   if ($("#patNo").val()=="")
		   {$("#PatientID").val("");}
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
			loadCureWorkListDataGrid();
		   }
    });
    $('#cardNo').bind('change', function(event){
		   if ($("#cardNo").val()=="")
		   {$("#PatientID").val("");}
    });
    // Toolbar
	var cureWorkListToolBar = [/*{
		id:'BtnAdd',
		text:'�к�',
		iconCls:'icon-add',
		handler:function(){
					 
		}
	},'-',*/{
		id:'BtnClear',
		text:'���', 
		iconCls:'icon-cancel',  
		handler:function(){
			location.reload();
		}
	}];
	// ���ƹ���̨��ѯGrid
	//PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
	//fit : true,
	cureWorkListDataGrid=$('#tabCureWorkList').datagrid({  
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
		rownumbers : true,  //
		idField:"Rowid",
		pageNumber:0,
		pageSize : 0,
		pageList : [5],
		columns :[[   
        			{ field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					},
					{field:'PatNo',title:'�ǼǺ�',width:80,align:'center'},   
        			{field:'PatName',title:'����',width:80,align:'center'},   
        			{field:'PatSex',title:'�Ա�',width:30,align:'center'},
        			{field:'PatAge',title:'����',width:30,align:'center',hidden:true},
        			{field:'PatTel',title:'��ϵ�绰',width:10,align:'center',hidden:true},
        			{field:'AdmType',title:'��������',width:40,align:'center'},
        			{field:'AdmDep',title:'�������',width:100,align:'center'},    
        			{field:'ArcimDesc',title:'������Ŀ',width:120,align:'center'}, 
					{ field: 'DDCRSDate', title:'����', width: 80, align: 'center', sortable: true, resizable: true  
					},
					{ field: 'LocDesc', title:'����', width: 120, align: 'center', sortable: true, resizable: true  
					},
        			{ field: 'ResourceDesc', title: '��Դ', width: 100, align: 'center', resizable: true
					},
					{ field: 'TimeDesc', title: 'ʱ��', width: 40, align: 'center', resizable: true
					},
					{ field: 'StartTime', title: '��ʼʱ��', width: 60, align: 'center',resizable: true
					},
					{ field: 'EndTime', title: '����ʱ��', width: 60, align: 'center',resizable: true
					},
					{ field: 'ServiceGroupDesc', title: '������', width: 60, align: 'center',resizable: true
					},
					{ field: 'DDCRSStatus', title: '�Ű�״̬', width: 50, align: 'center',resizable: true
					},
					{ field: 'DCAAStatus', title: 'ԤԼ״̬', width: 50, align: 'center',resizable: true
					},
					{ field: 'ReqUser', title: 'ԤԼ������', width: 60, align: 'center',resizable: true
					},
					{ field: 'ReqDate', title: 'ԤԼ����ʱ��', width: 60, align: 'center',resizable: true
					},
					{ field: 'LastUpdateUser', title: '������', width: 60, align: 'center',resizable: true
					},
					{ field: 'LastUpdateDate', title: '����ʱ��', width: 60, align: 'center',resizable: true
					} ,
					{ field: 'DHCDocApplyNoGet', title: '���뵥��', width: 70, align: 'center',resizable: true
					}
					
					
    			 ]] ,
    	toolbar : cureWorkListToolBar,
		onClickRow:function(rowIndex, rowData){
			loadTabData();
		}
	});
		$('#tabs').tabs({
  		onSelect: function(title,index){
				loadTabData()
  		}
	});
	loadCureWorkListDataGrid();
});
function loadCureWorkListDataGrid()
{
	var ServiceGroup=$("#serviceGroup").combobox('getValue');
	var PatientID=$("#PatientID").val();
	var sttDate=$('#sttDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	var DHCDocANUm=$('#DHCDocANUm').val()
	var queryStatus=$("#queryStatus").combobox('getValue');
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Appointment';
	queryParams.QueryName ='FindCurrentAppointmentList';
	queryParams.Arg1 =session['LOGON.CTLOCID'];
	queryParams.Arg2 =session['LOGON.USERID'];
	queryParams.Arg3 =sttDate;
	queryParams.Arg4 =endDate;
	queryParams.Arg5 =PatientID;
	queryParams.Arg6 =ServiceGroup;
	queryParams.Arg7 =queryStatus;
	queryParams.Arg8 =DHCDocANUm;
	queryParams.ArgCnt =8;
	var opts = cureWorkListDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureWorkListDataGrid.datagrid('load', queryParams);
	cureWorkListDataGrid.datagrid('unselectAll');
}
function loadTabData()
{
		var rows = cureWorkListDataGrid.datagrid("getSelections");
		var DCAARowId="",DCARowId=""
		if (rows.length==1)
		{
		var rowIndex = cureWorkListDataGrid.datagrid("getRowIndex", rows[0]);
		var selected=cureWorkListDataGrid.datagrid('getRows'); 
		var DCAARowId=selected[rowIndex].Rowid;
		}
		if (DCAARowId!="")
		{
			DCARowId=DCAARowId.split("||")[0];
		}
		
		var title = $('.tabs-selected').text();
		var href=""
		if (title=="���Ƽ�¼") 
		{href="dhcdoc.cure.curerecord.csp?OperateType=ZLYS&DCAARowId="+DCAARowId;}
		else if (title=="ԤԼ�б�") 
		{href="dhcdoc.cure.applyapplist.csp?OperateType=ZLYS&DCARowId="+DCARowId+"&DCAARowId="+DCAARowId;}
		else if (title=="���Ƽ�¼�б�") 
		{href="dhcdoc.cure.curerecordlist.csp?OperateType=ZLYS&DCARowId="+DCARowId+"&DCAARowId="+DCAARowId;}
		//alert(href);
		if(href=="")return;
		refreshTab({tabTitle:title,url:href}); 
}
function refreshTab(cfg){  
    var refresh_tab = cfg.tabTitle?$('#tabs').tabs('getTab',cfg.tabTitle):$('#tabs').tabs('getSelected');  
    if(refresh_tab && refresh_tab.find('iframe').length > 0){  
    var _refresh_ifram = refresh_tab.find('iframe')[0];  
    var refresh_url = cfg.url?cfg.url:_refresh_ifram.src;   
    _refresh_ifram.contentWindow.location.href=refresh_url;  
    }  
}

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
			alert("����Ч");
			document.getElementById('cardNo').value=""
			break;
		default:
			document.getElementById('cardNo').value=myary[1];
			$("#PatientID").val(myary[4]);
			loadCureWorkListDataGrid();
			break;
	}
}
function ReadInsuCard()
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
			loadCureWorkListDataGrid();
			break;
	}
}

function saveOrder()
{	

		var rows = cureWorkListDataGrid.datagrid("getSelections");
		var DCAARowId="",DCARowId=""
		if (rows.length==1)
		{
		var rowIndex = cureWorkListDataGrid.datagrid("getRowIndex", rows[0]);
		var selected=cureWorkListDataGrid.datagrid('getRows'); 
		var DCAARowId=selected[rowIndex].Rowid;
		}
		if (DCAARowId!="")
		{
			DCARowId=DCAARowId.split("||")[0];
		}else{
			 $.messager.alert("��ʾ","����ѡ����ԤԼ��¼,�����¼��!");
			 return	false
		}
		
		var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",DCARowId)
		var RtnStrArry=RtnStr.split(String.fromCharCode(1));
		var PatientArr=RtnStrArry[0].split("^"); //���߻�����Ϣ
		var CureApplyArr=RtnStrArry[1].split("^"); //ԤԼ����Ϣ
		
		var PatID=PatientArr[0]
		var AdmID=CureApplyArr[15]
		var ArcimID=CureApplyArr[20]
		var ApplyStatusCode=CureApplyArr[23]
		if (ApplyStatusCode=="C"){
			 $.messager.alert("��ʾ","�������뵥�Ѿ����������ܼ����Խ��е�ԤԼ��¼����¼��ҽ��!");
			 return	false

		}
	
		
		
		//var lnk="oeorder.entrysinglelogon.csp?EpisodeID="+AdmID+"&PatientID="+PatID+"&DCAARowId="+DCAARowId;
		var lnk="dhcdoc.cure.order.csp?EpisodeID="+AdmID+"&PatientID="+PatID+"&DCAARowId="+DCAARowId;
		//var NewWin=window.open(lnk,"DCAAOrder","scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");
		
	   var url=lnk;          
	   var winName="DCAAOrder";       
	   var awidth=screen.availWidth;       //���ڿ��,��Ҫ����   
	   var aheight=screen.availHeight;         //���ڸ߶�,��Ҫ����    
	   var atop=(screen.availHeight - aheight)/2;  //���ڶ���λ��,һ�㲻��Ҫ��   
	   var aleft=(screen.availWidth - awidth)/2;   //���ڷ�����,һ�㲻��Ҫ��   
	   var param0="scrollbars=1,status=0,menubar=1,resizable=1,location=0"; //�´��ڵĲ���   
	   var params="top=" + atop + ",left=" + aleft + ",width=" + awidth + ",height=" + aheight + "," + param0 ;  
	   win=window.open(url,winName,params); //���´���   
	   win.focus(); //�´��ڻ�ý���   
		

}
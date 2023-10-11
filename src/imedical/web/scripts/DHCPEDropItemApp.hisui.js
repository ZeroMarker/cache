
//����	DHCPEDropItemApp.hisui.js
//����  ����˷�����
//����	2018.10.11
//������  xy

$(function(){
	// �˷�ԭ�����밴ť����
	$("#RefundRmark").width($("#RefundRmark").width()-7);
	 
	InitCombobox();
	
	initInvList();
	
	initOrdItmList();
	
	iniForm();
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
    //���� 
   	 $("#Bclear").click(function() {	
		 Bclear_click();		
        }); 
      
	$HUI.linkbutton('#BReadCard', {
		onClick: function () {
			ReadCardClickHandle();
		}
	});


	//���Żس���ѯ�¼�
	$('#CardNo').keydown(function (e) {
		CardNoKeydownHandler(e);
	});
     
	//�ǼǺŻس���ѯ�¼�
	$('#RegNo').keydown(function (e) {
		RegNoKeyDown(e);
	});
	
	//��Ʊ�س���ѯ�¼�
	$('#InvNo').keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
		var invNo=$("#InvNo").val();
		if (invNo=="") return false;
		BFind_click();
		}
	});
	
	//ȫ������
	$("#BAllRefundApp").click(function() {	
		 BAllRefundApp_Click();		
    }); 
	
	//��ӡ�˷ѵ�
	$("#BPrint").click(function() {	
		 BPrint_Click();		
    }); 

	//�����˷�����
	$("#BCancelRefundApp").click(function() { 
		 BCancelRefundApp_Click(); 
    });

    
    //������
	$HUI.combobox('#cardType', {
		panelHeight: 'auto',
		url: $URL,
		editable: false,
		multiple: false,
		valueField: 'value',
		textField: 'caption',
		onBeforeLoad: function (param) {
			param.ClassName = 'web.DHCBillOtherLB';
			param.QueryName = 'QCardTypeDefineList';
			param.ResultSetType = 'array';
		},
		
		onLoadSuccess: function () {
			var cardType = $(this).combobox('getValue');
			initReadCard(cardType);
		},
		onSelect: function (record) {
			var cardType = record.value;
			initReadCard(cardType);
		}
	});
	
})


function iniForm(){

    var UserDR=session['LOGON.USERID'];
	var LocID=session['LOGON.CTLOCID'];
	

	var OPflag=tkMakeServerCall("web.DHCPE.CT.ChargeLimit","GetOPChargeLimitInfo",UserDR,LocID);
	var OPflagOne=OPflag.split("^");
	
	//ȫ������
	if(OPflagOne[5]=="Y"){
		$("#BAllRefundApp").linkbutton('enable');
	}else{
		$("#BAllRefundApp").linkbutton('disable');
	}

}


function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}
function CardNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		var CardNo=$("#CardNo").val();
		if (CardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",CardNo,"","PatInfo",CardNoKeyDownCallBack);
		
		return false;
	}
}

function CardNoKeyDownCallBack(myrtn){
   var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			BFind_click();
			event.keyCode=13; 
			break;
		case "-200": //����Ч
			$.messager.alert("��ʾ","����Ч","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			BFind_click();
			event.keyCode=13;
			break;
		default:
	}
}


function InitCombobox()
{
	// �ս���	
	var RPObj = $HUI.combobox("#RPFlag",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'Y',text:$g('��')},
            {id:'N',text:$g('��')} 
        ]

	}); 
		
}

//����
function Bclear_click()
{
	$("#RegNo,#PatName,#InvNo,#User,#CardTypeNew,#CardNo").val("");
	$(".hisui-combobox").combobox('select','');
	$("#BeginDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	BFind_click();
}


// ��ѯ
function BFind_click(){

	$HUI.datagrid("#invList",{
		
		queryParams:{
			ClassName:"web.DHCPE.InvPrt",
			QueryName:"FindInvPrtList",
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			InvNo:$("#InvNo").val(),
			PatName:$("#PatName").val(),
			User:$("#User").val(),
			RPFlag:$("#RPFlag").combobox('getValue'),
			isApply:"0",
			LocID:session['LOGON.CTLOCID']
			
		}
	});
	$('#ordItmList').datagrid('loadData', {
				total: 0,
				rows: []
			});
	$("#InvPrtId").val("");
	$("#RefundRmark").val("");
	
}


function loadOrdItmList(row) {
	 RefundAmount=[];
    SelectItems=[];

	$('#ordItmList').datagrid('load', {
		ClassName: 'web.DHCPE.ItemFeeList',
		QueryName: 'FindItemFeeList',
		InvPrtId: row.TRowId,
		CSPName:"dhcpedropfeeapp.hisui.csp"	
		
	});
	if(row.TRowId!=$('#InvPrtId').val()){$("#RefundRmark").val("");}
	//$('#InvPrtId').val(row.TRowId);
	//inti();
}

function RegNoKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var RegNo=$("#RegNo").val();	
 		if(RegNo!="") {
	 	var RegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":RegNo
		}, false);
		
			$("#RegNo").val(RegNo)
		}

		if (RegNo=="") return false;
		
			BFind_click();
		
	}
}

function initInvList() {
	$HUI.datagrid('#invList', {
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		rownumbers : true, 
		pageSize: 15,
		pageList: [15, 20, 25, 30],
		singleSelect: true,
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.InvPrt",
			QueryName:"FindInvPrtList",
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			InvNo:$("#InvNo").val(),
			PatName:$("#PatName").val(),
			User:$("#User").val(),
			RPFlag:$("#RPFlag").combobox('getValue'),
			isApply:"0",
			LocID:session['LOGON.CTLOCID']
			
		},
		columns: [[{
					title: '��Ʊ��',
					field: 'TInvNo',
					width: 120
				}, {
					title: '�ǼǺ�',
					field: 'TRegNo',
					width: 120
				}, {
					title: '����',
					field: 'TPatName',
					width: 100
				}, {
					title: '���',
					field: 'TAmount',
					align: 'right',
					width: 100
				}, {
					title:'�Ƿ��ӡ���ӷ�Ʊ',
					field:'TPrintEInv',
					width:160,
					align:'center',
           			formatter: function (value,rowData,rowIndex) {
	           			if(rowData.TRowId!=""){
							if(value=="0"){
								return '<input type="checkbox" checked="checked" disabled/>';
							}else{
								return '<input type="checkbox" value="" disabled/>';
							}
	           			}
					}
    			},{
	    			title:'����Ʊ�ݺ�',
	    			field:'TEInvNo',
    				width:140	
    			},{
					title: '�շ�Ա',
					field: 'TUser',
					width: 100
				}, {
					title: '�շ�����',
					field: 'TInvDate',
					width: 160
				},{
					title: '�ս���',
					field: 'TRPFlag',
					width: 80
				}, {
					title: 'TRowId',
					field: 'TRowId',
					hidden: true
				}
			]],
		onSelect: function (rowIndex, rowData) {
			$('#InvPrtId').val(rowData.TRowId);
			$('#ordItmList').datagrid('loadData', {
				total: 0,
				rows: []
			});
			var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","GetApplyRefundFlag",rowData.TRowId);
   			if(flag=="0"){
				$("#AllRefundApp").checkbox('setValue',true);
			}else{
				 $("#AllRefundApp").checkbox('setValue',false);	
			}
			
			loadOrdItmList(rowData);
		}
	});
}


function initOrdItmList() {
	$HUI.datagrid('#ordItmList', {	
		fit: true,
		striped: true, //�Ƿ���ʾ������Ч��
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect:false,
		autoRowHeight: false,
		//showFooter: true,
		url: $URL,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		pageSize: 20,
		pageList: [20, 30, 40, 50],
	    queryParams:{
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
			CSPName:"dhcpedropfeeapp.hisui.csp"
				
		},
		columns: [[{
					title: 'ѡ��',
					field: 'Select',
					width: 70,
					checkbox:true,
					/*formatter:function(value,rowData,index){
						return "<input type='checkbox' onclick=\"GetSelectIds('" + value + "', '" + index + "')\"/>"; 
					}
					
                  */
				
				}, {
					title: 'ҽ������',
					field: 'ItemName',
					width: 120
				}, {
					title: 'ҽ��״̬',
					field: 'OrdStatusDesc',
					width: 100
				}, {
					title: '���۽��',
					field: 'FactAmount',
					align: 'right',
					width: 100
				}, {
					title: '�Ż���ʽ',
					field: 'PrivilegeMode',
					width: 100
				}, {
					title: '�Ż�����',
					field: 'Privilege',
					hidden: true
					//width: 100
				}, {
					title: 'RowId',
					field: 'RowId',
					hidden: true
				},{
					title: 'FeeType',
					field: 'FeeType',
					hidden: true
				},{
					title: '����',
					field: 'PatName',
					width: 100
				},
				{
					title: '�ǼǺ�',
					field: 'PatRegNo',
					width: 100
				}

			]],
			
	
	//ȡ��ѡ���к���	
	onUncheck:function(rowIndex,rowData){
				//GetSelectIds();
				RemoveSelectItem(rowIndex,rowData);
			},
			
	//ѡ���к���
	onCheck:function(rowIndex,rowData){
	//if ((rowData.OrdStatusDesc == "ִ��")||(rowData.OrdStatusDesc == "�ѷ�ҩ")) {
	if ((rowData.OrdStatusDesc == "ִ��")) {
		            //����datagrid��ĳ�в��ܱ�ѡ��
					$('#ordItmList').datagrid('unselectRow', rowIndex);
				}
				//GetSelectIds();
				AddSelectItem(rowIndex,rowData); 
			},		
			
	onLoadSuccess: function (rowData) { 
	  $('#ordItmList').datagrid('unselectAll');
	   //$('#ordItmList').datagrid('clearSelections'); //һ��Ҫ������һ�䣬Ҫ��Ȼdatagrid���ס֮ǰ��ѡ��
	   $("#ordItmList").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
		
		var invPrtId=$("#InvPrtId").val();
		//alert(invPrtId)
		if (invPrtId==""){
		//alert("û���˷����뷢Ʊ");
		return false;
		}
		var info=tkMakeServerCall("web.DHCPE.ItemFeeList","GetApplyRefund",invPrtId);
		//alert(info)
		for ( var i = 0; i < rowData.rows.length; i++) {
			// if(info.indexOf(objtbl[index].RowId)>=0)
		    if (info.indexOf(rowData.rows[i].RowId)>=0) {
					//$(".datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[0].checked = true
						//$(this)[i].TChecked.disabled = true;

					}
			 



	     }
		
		
		
	  /*
	   //��һ�֣�����datagrid����checkbox���
	   for ( var i = 0; i < rowData.rows.length; i++) {
		   if ((rowData.rows[i].OrdStatusDesc=="ִ��")||(rowData.rows[i].OrdStatusDesc=="�ѷ�ҩ")) {

						$("input[type='checkbox']")[i + 1].disabled = true;

					}



	   }
	   */
	   	
        var invPrtId=$("#InvPrtId").val();
		if (invPrtId==""){
			return false;
		} 
		$("#BackAmount").val(0);
	
        var info=tkMakeServerCall("web.DHCPE.ItemFeeList","GetApplyRefund",invPrtId);
       
	    var objtbl = $("#ordItmList").datagrid('getRows');
	              
		if (rowData) { 
		   
		  //����datagrid����            
		 $.each(rowData.rows, function (index) {
			    
			 	//if((objtbl[index].OrdStatusDesc=="ִ��")||(objtbl[index].OrdStatusDesc=="�ѷ�ҩ")){	
			 	// ��Ϊ �ѷ�ҩҽ���Ƿ������Զ�������ҩ����
			 	if((objtbl[index].OrdStatusDesc=="ִ��")){	
			 		//�ڶ��֣�����datagrid����checkbox���	 
			  		$(".datagrid-row[datagrid-row-index="+index+"] input[type='checkbox']").attr('disabled','disabled');
				 } else{ 
			 			if(info.indexOf(objtbl[index].RowId)>=0){
				 			//����ҳ��ʱ���ݺ�̨�෽������ֵ�ж�datagrid����checkbox�Ƿ񱻹�ѡ
				 			$('#ordItmList').datagrid('checkRow',index);
				 		}
			 	}
		 });
		 
		 
		 }
		}
		            
	});
	
	
}



var backAmount=0;
var RefundAmount=[];
var SelectItems=[];

function FindSelectItem(ID) { 
 //alert("SelectItems.length:"+SelectItems.length)
      for (var i = 0; i < SelectItems.length; i++) { 
            if (SelectItems[i] == ID) return i; 
         } 
       return -1; 
  } 

function AddSelectItem(rowIndex,rowData)
{
	
	 var invPrtId=$("#InvPrtId").val();
	 var InvStatus=tkMakeServerCall("web.DHCPE.InvPrt","GetInvStatus",invPrtId);
	 if(InvStatus=="1"){
		 $.messager.alert("��ʾ","�÷�Ʊ�����ϣ����������˷�!","info");
		return ;
	 }
	 var SelectIds=","
	  backAmount=0

     if (FindSelectItem(rowData.FeeType+"^"+rowData.RowId) == -1) { 
         	SelectItems.push(rowData.FeeType+"^"+rowData.RowId); 
         	RefundAmount.push(rowData.FactAmount);
         

         }
                
      for (var i = 0; i < SelectItems.length; i++) { 
               var SelectIds=SelectIds+SelectItems[i]+","    
       }
                  
      for (var j = 0; j< RefundAmount.length; j++) { 
       		 backAmount = parseFloat(backAmount) + parseFloat(RefundAmount[j]); 
       }
       
       //alert(SelectIds)
      backAmount= parseFloat(backAmount).toFixed(2);
       $("#BackAmount").val(backAmount); 
	var UserID=session['LOGON.USERID'];
	var LocID=session['LOGON.CTLOCID'];
    var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","SetApplyRefund",invPrtId,SelectIds,"temp",backAmount,LocID,UserID)
	  
}

function RemoveSelectItem(rowIndex, rowData) { 
  //alert(rowIndex+"rowIndex")
    var UserID=session['LOGON.USERID'];
	var invPrtId=$("#InvPrtId").val();
	var InvStatus=tkMakeServerCall("web.DHCPE.InvPrt","GetInvStatus",invPrtId);
	 if(InvStatus=="1"){
		 $.messager.alert("��ʾ","�÷�Ʊ�����ϣ����������˷�!","info");
		return ;
	 }
	if(rowData.OrdStatusDesc=="�ѷ�ҩ"){
	var CancleDuugApply=tkMakeServerCall("web.DHCPE.ItemFeeList","CancleDrugApply",rowData.RowId,rowData.FeeType,UserID);
	//alert(CancleDuugApply+"CancleDuugApply")
	if(CancleDuugApply!=0){
		$.messager.alert("��ʾ", "������ҩ����ʧ��!", 'success');
		$(this).datagrid('reload');
		return false;
		}
	}
	 backAmount=0
    var SelectIds=","
    var k = FindSelectItem(rowData.FeeType+"^"+rowData.RowId); 
    if (k != -1) { 
             SelectItems.splice(k,1); 
             RefundAmount.splice(k,1);
      } 
      
     
    for (var i = 0; i < SelectItems.length; i++) { 
             var SelectIds=SelectIds+SelectItems[i]+","    
      }
      
     for (var j = 0; j< RefundAmount.length; j++) { 
       		 backAmount = parseFloat(backAmount) + parseFloat(RefundAmount[j]); 
       }
       
      backAmount= parseFloat(backAmount).toFixed(2); 
     $("#BackAmount").val(backAmount);
     //alert(SelectIds+"SelectIds")
	  if(SelectIds==","){var SelectIds="";}
	  var UserID=session['LOGON.USERID'];
	 var LocID=session['LOGON.CTLOCID'];  
     var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","SetApplyRefund",invPrtId,SelectIds,"temp",backAmount,LocID,UserID)
	
                        
  } 
 

//ʵʱ�����˷ѽ����˷�������Ϣд��global:^DHCPEDataEx("DHCPERefundApply","SelectIds",invPrtId)
function GetSelectIds()
{
	
	var backAmount=0;
	
	var invPrtId=$("#InvPrtId").val();
	//alert(invPrtId)
	if (invPrtId==""){
		alert("û���˷����뷢Ʊ");
		return false;
	}
 	
   $("#BackAmount").val(backAmount);
	var SelectIds=""
	var selectrow = $("#ordItmList").datagrid("getChecked");//��ȡ�������飬��������
	
	for(var i=0;i<selectrow.length;i++){

		 backAmount=backAmount+Number(selectrow[i].FactAmount);
	     $("#BackAmount").val(backAmount);
	   
		if (SelectIds==""){
				SelectIds=","+selectrow[i].FeeType+"^"+selectrow[i].RowId+",";
			}else{
				SelectIds=SelectIds+","+selectrow[i].FeeType+"^"+selectrow[i].RowId+",";
			} 
	}

	//�˷�����ļ�¼д��global��
	//alert(invPrtId+","+SelectIds+","+backAmount)
	var UserID=session['LOGON.USERID'];
	var LocID=session['LOGON.CTLOCID']; 
	var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","SetApplyRefund",invPrtId,SelectIds,"temp",backAmount,LocID,UserID)
	//alert(flag+"flag")
	if(flag==1)
	{
	//$.messager.alert("��ʾ", "����ɹ�", 'success');
	//$(this).datagrid('reload')
	}
	else if(flag==-1)
	{
		$.messager.alert("��ʾ", "����ʧ��,��ҩ����ʧ��", 'success');
		$(this).datagrid('reload')
		}
	//alert(SelectIds)
}


function BCancelRefundApp_Click()
{
	var UserId=session['LOGON.USERID'];
	var invPrtId=$("#InvPrtId").val();
	if (invPrtId==""){
		$.messager.alert("��ʾ","��ѡ��������˷�����ķ�Ʊ!","info");
		return false;
	}
	 var InvStatus=tkMakeServerCall("web.DHCPE.InvPrt","GetInvStatus",invPrtId);
	 if(InvStatus=="1"){
		 $.messager.alert("��ʾ","�÷�Ʊ�����ϣ����ܳ��������˷�!","info");
		return ;
	 }
	var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","GetApplyRefundFlag",invPrtId);
	if(flag==""){
		$.messager.alert("��ʾ","û�������˷�,���ܳ����˷�����!","info");
return false;
	}else{
		var ret=tkMakeServerCall("web.DHCPE.ItemFeeList","BCancelRefundApp",invPrtId,UserId);
		if(ret=="0"){
			$.messager.alert("��ʾ","�����˷�����ɹ�!","success");
			var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","GetApplyRefundFlag",invPrtId);
   			if(flag=="0"){
				$("#AllRefundApp").checkbox('setValue',true);
			}else{
				$("#AllRefundApp").checkbox('setValue',false);	
			}
			
			$('#ordItmList').datagrid('load', {
				ClassName: 'web.DHCPE.ItemFeeList',
				QueryName: 'FindItemFeeList',
				InvPrtId:invPrtId
		
			});
		}
	}
	
	
}

//ȫ������
function BAllRefundApp_Click()
{
	var UserID=session['LOGON.USERID'];
	var LocID=session['LOGON.CTLOCID']; 
	var invPrtId=$("#InvPrtId").val();
	if (invPrtId==""){
		$.messager.alert("��ʾ","û���˷����뷢Ʊ!","info");
		return false;
	}
     var InvStatus=tkMakeServerCall("web.DHCPE.InvPrt","GetInvStatus",invPrtId);
	 if(InvStatus=="1"){
		 $.messager.alert("��ʾ","�÷�Ʊ�����ϣ����������˷�!","info");
		return ;
	 }
	//�˷�����ļ�¼д��global��
	var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","SetApplyRefund",invPrtId,"AllRefund","","",LocID,UserID)
	if(flag==1){
		$.messager.alert("��ʾ","ȫ������ɹ�!","success");
		var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","GetApplyRefundFlag",invPrtId);
   		if(flag=="0"){
			$("#AllRefundApp").checkbox('setValue',true);
		}else{
			$("#AllRefundApp").checkbox('setValue',false);	
		}
	}else{
		$.messager.alert("��ʾ","ȫ������ʧ��!","error");
		
	}
}

//��ӡ�˷ѵ�lodop��ӡ
function BPrint_Click() 
{
	var invPrtId=$("#InvPrtId").val();
	if (invPrtId==""){
		$.messager.alert("��ʾ","û���˷����뷢Ʊ!","info");
		return false;
	}
	 var InvStatus=tkMakeServerCall("web.DHCPE.InvPrt","GetInvStatus",invPrtId);
	 if(InvStatus=="1"){
		 $.messager.alert("��ʾ","�÷�Ʊ�����ϣ����ܴ�ӡ�˷����뵥!","info");
		return ;
	 }
	var info=tkMakeServerCall("web.DHCPE.ItemFeeList","GetRefundInfo",invPrtId);
	
	if (info==""){
		$.messager.alert("��ʾ","��û�����˷����룬��ѡ���˷���Ŀ���ߵ��ȫ������!","info");
		return false;
	}
	var RefundRmark=$("#RefundRmark").val();
	var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","SetRefundRemark",invPrtId,RefundRmark);
	var PrinterName="" //��ӡ������
	TFDCreatePrintPage(PrinterName,invPrtId);
}

function TFDCreatePrintPage(PrinterName,invPrtId)
{
	LODOP=getLodop(); 
	LODOP.PRINT_INIT(invPrtId+"���˷����뵥"); //��ӡ���������
	if (PrinterName!=""){ //ָ����ӡ������
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	var PrintURL=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetTFDPrintInfo",invPrtId,"Header");
	//alert(PrintURL)
	var xmlHttp=createXmlHttp();
	xmlHttp.onreadystatechange = function (a,b){
	    if (xmlHttp.readyState == 4) {
			//���Ӵ�ӡ������Ϣ����Ϊҳü��ӡ��ÿҳ����
			//LODOP.ADD_PRINT_URL("12mm","12mm","RightMargin:6mm","80mm",PrintURL); //Top,Left,Width,Height,strURL
			LODOP.ADD_PRINT_HTM("12mm","12mm","RightMargin:6mm","80mm",xmlHttp.responseText);
			LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
			LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT","Full-Page");
	
			//���Ӵ�ӡ��Ŀ��Ϣ
			var PrintURL=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetTFDPrintInfo",invPrtId,"Body");
			var xmlHttp2=createXmlHttp();
			xmlHttp2.onreadystatechange = function (a,b){
	    		if (xmlHttp2.readyState == 4) {
					//LODOP.ADD_PRINT_URL("60mm","12mm","RightMargin:6mm","BottomMargin:20mm",PrintURL); //Top,Left,Width,Height,strURL
					LODOP.ADD_PRINT_HTM("60mm","12mm","RightMargin:6mm","BottomMargin:20mm",xmlHttp2.responseText);
					LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW",true);
	
					LODOP.PRINT();
	    		}
			}
			xmlHttp2.open("GET", PEURLAddToken(PrintURL), true);
    		xmlHttp2.send(null);
		} 
	}
	xmlHttp.open("GET", PEURLAddToken(PrintURL), true);
    xmlHttp.send(null);
}
function createXmlHttp() {
    //����window.XMLHttpRequest�����Ƿ����ʹ�ò�ͬ�Ĵ�����ʽ
    if (window.XMLHttpRequest) {
       xmlHttp = new XMLHttpRequest();                  //FireFox��Opera�������֧�ֵĴ�����ʽ
    } else {
       xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");//IE�����֧�ֵĴ�����ʽ
    }
    return xmlHttp;
}

/*
//��ӡ�˷ѵ�
function BPrint_Click()
{
	
	var idTmr="";
	var invPrtId=$("#InvPrtId").val();
	if (invPrtId==""){
		alert("û���˷����뷢Ʊ");
		return false;
	}
	
	var info=tkMakeServerCall("web.DHCPE.ItemFeeList","GetRefundInfo",invPrtId);
	if (info==""){
		alert("��û�����˷����룬��ѡ���˷���Ŀ���ߵ��ȫ������");
		return false;
	}
	
	var char_1=String.fromCharCode(1);
	var char_2=String.fromCharCode(2);
	var infoArr=info.split(char_1);
	var patientInfo=infoArr[0];
	var patientArr=patientInfo.split("^");
	var orditemInfo=infoArr[1];
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEDropItemRequest.xls';

	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	
	var HosName=""
	var HosName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
	
	xlsheet.cells(1,1).Value=HosName;

	xlsheet.cells(4,2).Value=patientArr[0];
	xlsheet.cells(4,5).Value=patientArr[1];
	xlsheet.cells(5,2).Value=patientArr[2];
	xlsheet.cells(6,2).Value=patientArr[3];
	xlsheet.cells(6,6).Value=patientArr[4];
	var orditemArr=orditemInfo.split(char_2);
	var row=9;
	var i=orditemArr.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++){
		var oneOrdItem=orditemArr[iLLoop];
		var oneOrdArr=oneOrdItem.split("^");
		xlsheet.cells(row+iLLoop,1).Value=oneOrdArr[0];
		xlsheet.cells(row+iLLoop,5).Value=oneOrdArr[1];
	}
	
	
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null
	idTmr   =   window.setInterval("Cleanup();",1); 
	
	
}
*/

function   Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
  
}
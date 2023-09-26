
//����	DHCPEDropItemApp.hisui.js
//����  ����˷�����
//����	2018.10.11
//������  xy

$(function(){
	 
	InitCombobox();
	
	initInvList();
	
	initOrdItmList();
	
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
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindRPFlag&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		})
		
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
			isApply:"0"
			
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
		InvPrtId: row.TRowId
		
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
			isApply:"0"
			
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
					title: '�շ�Ա',
					field: 'TUser',
					width: 100
				}, {
					title: '�շ�����',
					field: 'TInvDate',
					width: 180
				},{
					title: '�ս���',
					field: 'TRPFlag',
					width: 30
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
		showFooter: true,
		url: $URL,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		pageSize: 20,
		pageList: [20, 30, 40, 50],
	    queryParams:{
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
				
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
       
      backAmount= parseFloat(backAmount).toFixed(2);
       $("#BackAmount").val(backAmount); 
    var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","SetApplyRefund",invPrtId,SelectIds,"temp",backAmount)
	  
}

function RemoveSelectItem(rowIndex, rowData) { 
	var invPrtId=$("#InvPrtId").val();
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
     var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","SetApplyRefund",invPrtId,SelectIds,"temp",backAmount)
	
                        
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
	var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","SetApplyRefund",invPrtId,SelectIds,"temp",backAmount)
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

//ȫ������
function BAllRefundApp_Click()
{
	
	var invPrtId=$("#InvPrtId").val();
	if (invPrtId==""){
		$.messager.alert("��ʾ","û���˷����뷢Ʊ","info");
		return false;
	}
	//�˷�����ļ�¼д��global��
	var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","SetApplyRefund",invPrtId,"AllRefund")
	if(flag==1){
		$.messager.alert("��ʾ","ȫ������ɹ�!","success");
	}else{
		$.messager.alert("��ʾ","ȫ������ʧ��!","error");
		
	}
}

//��ӡ�˷ѵ�lodop��ӡ
function BPrint_Click() 
{
	var invPrtId=$("#InvPrtId").val();
	if (invPrtId==""){
		$.messager.alert("��ʾ","û���˷����뷢Ʊ","info");
		return false;
	}
	var info=tkMakeServerCall("web.DHCPE.ItemFeeList","GetRefundInfo",invPrtId);
	
	if (info==""){
		$.messager.alert("��ʾ","��û�����˷����룬��ѡ���˷���Ŀ���ߵ��ȫ������","info");
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
	//���Ӵ�ӡ������Ϣ����Ϊҳü��ӡ��ÿҳ����
	LODOP.ADD_PRINT_URL("12mm","12mm","RightMargin:6mm","80mm",PrintURL); //Top,Left,Width,Height,strURL
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT","Full-Page");
	
		//���Ӵ�ӡ��Ŀ��Ϣ
	var PrintURL=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetTFDPrintInfo",invPrtId,"Body");
	LODOP.ADD_PRINT_URL("60mm","12mm","RightMargin:6mm","BottomMargin:20mm",PrintURL); //Top,Left,Width,Height,strURL
	LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW",true);
	
	LODOP.PRINT();
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
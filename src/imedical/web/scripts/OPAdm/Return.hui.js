var PageLogicObj={
	m_RegReturnListTabDataGrid:"",
	dw:$(window).width()-400,
	dh:$(window).height()-100,
	toolbar:"",
	m_CardNoFlag:0
}
$(function(){
	//��ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	$("#CardNo").focus();
})
$(window).load(function() {
	//InitCSPShortcutKey("opadm.return.hui.csp");
	//�粻����toolbar ��ťtext�����޸�,���ڱ���������ʱ���toolbar�����ݼ�
	ReSetGridToolBar();
})
function ReSetGridToolBar(){
	var opts = PageLogicObj.m_RegReturnListTabDataGrid.datagrid('options');
	for (var i=0;i<opts.toolbar.length;i++){
		var id=opts.toolbar[i].id;
		if ((id)&&($("#"+id).length>0)){
			opts.toolbar[i].text=$("#"+id+" .l-btn-text")[0].innerText;
		}
	}
}
function InitEvent(){
	$("#Find").click(RegReturnListTabDataGridLoad);
	$('#CardNo').change(CardNoChange);
	$('#CardNo').blur(CardNoOnBlur);
	$('#InvoiceNo').change(InvoiceNoChange);
	//����
	$("#readcard").click(ReadCardClickHandler);
	$("#nday").change(ndayChange);
	$(document.body).bind("keydown",BodykeydownHandler);
	$("#Accpinv").click(AccpinvClick)
}
function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//�س��¼�����
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("RegNo")>=0){
			RegNoKeydownHandler(e);
			return false;
		}else if(SrcObj && SrcObj.id.indexOf("CardNo")>=0){
			PageLogicObj.m_CardNoFlag=1;
			CardNoKeydownHandler(e);
			return false;
		}
		return true;
	}/*else if(keyCode==115){ //F4 ����
		ReadCardClickHandler();
	}else if(keyCode==117){ //F6 ����
		SwichRegclickHandle();
	}else if(keyCode==118){ //F7 ԭ���ش�
		OldRegPrintClickHandler();
	}else if(keyCode==119){ //F8 �����ش�
		ReprintClickHandler();
	}else if(keyCode==120){ //F9 �˺�
		UpdateclickHandler("");
	}*/
	window.onhelp = function() { return false };
	return true;
}
function ReturnMRClickHandler()
{
	var row=PageLogicObj.m_RegReturnListTabDataGrid.datagrid("getSelected");
	if (row){
		//��ѡ�ı��¼������ջ,����������ִ��change�¼����ڸĳ�checkbox�Ĺ�ѡ����
		setTimeout(function(){SetReturnSum(row);});
	}
}
function PageHandle(){
	//��Ʊ����ˮ��
	GetReceiptNo();
	//�˺�ԭ��
	LoadReturnReason();
	if (ServerObj.EpisodeID!=""){
		var str=$.cm({
			ClassName:"web.DHCDocOrderItemList",
			MethodName:"GetPAADMInfo",
			dataType:"text",
			PaadmId:ServerObj.EpisodeID
		},false)
		var PatNo=str.split(" ")[1];
		$("#RegNo").val(PatNo);
		RegReturnListTabDataGridLoad();
	}
}
function Init(){
	PageLogicObj.m_RegReturnListTabDataGrid=InitRegReturnListTabDataGrid();
}
function InitRegReturnListTabDataGrid(){
	PageLogicObj.toolbar=[{
		id:"Update",
		text:"�˺�", //(F9)
		iconCls: 'icon-exe-order',
		handler: function(){UpdateclickHandler("")}
	},{
		text:"�˲�����",
		iconCls: 'icon-exe-order',
		handler: function(){CancelMedicalBookclickHandle()}
	},'-',{
		id:"SwichReg",
		text:"����", //(F6)
		iconCls: 'icon-change-loc',
		handler: function(){SwichRegclickHandle()}
	},'-',{
		text:"�޸Ļ������ͼ�����ѱ�",
		iconCls: 'icon-edit',
		handler: function(){UpdatePatAdmReasonClickHandle()}
	},'-',{
		id:"OldRegPrint",
		text:"ԭ���ش�", //(F7)
		iconCls: 'icon-print',
		handler: function(){OldRegPrintClickHandler()}
	},{
		id:"Reprint",
		text:"�����ش�",
		iconCls: 'icon-print', //(F8)
		handler: function(){ReprintClickHandler()}
	},{
		id:"ReprintRegist",
		text:"�Һ�С���ش�",
		iconCls: 'icon-print',
		handler: function(){ReprintRegist()}
	}]

	var Columns=[[ 
		{field:'AdmId',hidden:true,title:''},
		{field:'Dept',title:'����',width:100},
		{field:'Doctor',title:'ҽ��',width:100},
		{field:'Regno',title:'�ǼǺ�',width:105},
		{field:'PatName',title:'��������',width:100},
		{field:'Tph',title:'���',width:50},
		{field:'UserName',title:'�Һ�Ա',width:80},
		{field:'TabPrice',title:'���',width:50},
		{field:'TabDate',title:'��������',width:100},
		{field:'RegfeeDate',title:'�Һ�����',width:90},
		{field:'RegfeeTime',title:'�Һ�ʱ��',width:80},
		{field:'TabInvoiceNo',title:'��Ʊ��',width:100},
		{field:'TabReturnFlag',title:'�˺ű�ʶ',showTip:true,width:140,
			styler: function(value,row,index){
				if (value!="����"){
					return 'background-color:red;color:#fff;';
				}
			}
		},
		{field:'TabTRDoc',title:'����ҽ��',width:100},
		{field:'TabRBASStatus',title:'ҽ��״̬',width:80},
		{field:'TabRegType',title:'ԤԼ',width:50,align:'center',
			editor : {
                type : 'icheckbox',
                options : {
                    on : '1',
                    off : '0',
                    disabled:true
                }
           }
		},
		{field:'TabAppFee',title:'ԤԼ��',width:50},
		{field:'RBASStatusReason',title:'ͣ����ԭ��',width:100},
		{field:'INVPayMode',title:'֧����ʽ',showTip:true,width:90},
		{field:'RegFee',title:'�Һŷ�',width:50},
		{field:'CheckFee',title:'���Ʒ�',width:50},
		{field:'MRFee',title:'��������',width:50},
		{field:'ReCheckFee',title:'�����',width:50},
		{field:'HoliFee',title:'���շ�',width:50},
		{field:'OtherFee',title:'������',width:50},
		{field:'TabTime',title:'',hidden:true},
		{field:'AdmReasonId',title:'',hidden:true},
		{field:'InsuAdmInfoDr',title:'',hidden:true},
		{field:'PatDr',title:'',hidden:true},
		{field:'ChangeSum',title:'',hidden:true},
		{field:'TRSum',title:'',hidden:true},
		{field:'TabRBASStatusCode',title:'',hidden:true},
		{field:'TabTRRBASRowId',title:'',hidden:true},
		{field:'TabRBASRowId',title:'',hidden:true},
		{field:'RegfeeRowId',title:'',hidden:true},
		{field:'InvoiceId',title:'',hidden:true},
		{field:'Arcdr',title:'',hidden:true},
		{field:'Doctorid',title:'',hidden:true},
		{field:'Deptid',title:'',hidden:true}
    ]]
	var RegReturnListTabDataGrid=$("#RegReturnListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'AdmId',
		columns :Columns,
		toolbar:PageLogicObj.toolbar,
		onSelect:function(index, row){
			if (!row) return;
			SetReturnSum(row);
			$("#RegNo").val(row["Regno"]); 
			$("#PatientID").val(row["PatDr"]);
		},
		onLoadSuccess:function(data){
			//Ĭ��ѡ�е�һ��
			if (data["total"]>0){
				var index=0;
				if (ServerObj.EpisodeID!=""){
					index=PageLogicObj.m_RegReturnListTabDataGrid.datagrid("getRowIndex",ServerObj.EpisodeID);
				}
				if (index<0) index=0;
				PageLogicObj.m_RegReturnListTabDataGrid.datagrid("checkRow",index);
			}
			for (var i=0;i<data.rows.length;i++){
				PageLogicObj.m_RegReturnListTabDataGrid.datagrid('beginEdit',i);
			}
		},
		onRowContextMenu:function(e, index, row){
			e.preventDefault(); //��ֹ����������Ҽ��¼�
			PageLogicObj.m_RegReturnListTabDataGrid.datagrid("selectRow",index);
			setTimeout(function(){ShowGridRightMenu(e,index, row);});
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter})
	RegReturnListTabDataGrid.datagrid("load",{ });
	return RegReturnListTabDataGrid;
}
function ShowGridRightMenu(e,rowIndex, rowData){
	$("#RightKeyMenu").empty(); //	������еĲ˵�
	for (var i=0;i<PageLogicObj.toolbar.length;i++){
		if (PageLogicObj.toolbar[i]=="-") continue;
		var id=PageLogicObj.toolbar[i]["id"];
		var text=PageLogicObj.toolbar[i]["text"];
		var iconCls=PageLogicObj.toolbar[i]["iconCls"];
		var handler=PageLogicObj.toolbar[i]["handler"];
        $('#RightKeyMenu').menu('appendItem', {
            id:id,
			text:text,
			iconCls: iconCls, 
			onclick: eval(handler)
		});
    }
    $('#RightKeyMenu').menu('show', {  
        left: e.pageX,         //�����������ʾ�˵�
        top: e.pageY
    });
}

function RegReturnListTabDataGridLoad(){
	PageLogicObj.m_RegReturnListTabDataGrid.datagrid('unselectAll');
	var RegNo=$('#RegNo').val();
	var InvoiceNo=$('#InvoiceNo').val();
	if ((CardNo=='')&&(InvoiceNo=='')&&(RegNo=='')){
		$.messager.alert("��ʾ","�������ѯ����!","info",function(){
			$('#CardNo').focus();
		});
		return false;
	}
	$.q({
	    ClassName : "web.DHCOPAdmReg",
	    QueryName : "DHCOPAdm",
	    RegNo:$("#RegNo").val(),
	    nday:$("#nday").val(),
	    InvoiceNo:$("#InvoiceNo").val(),
	    PatientID:$("#PatientID").val(),
	    UserRowId:session['LOGON.USERID'],
	    QueryCancel:"",
	    RegDate:$("#RegDate").datebox('getValue'),
	    Pagerows:PageLogicObj.m_RegReturnListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		if ((GridData['rows'].length>0)&&(GridData['rows'][0]['AdmId']=="")){
			RegReturnListTabDataGrid.datagrid("load",{ });
			//PageLogicObj.m_RegReturnListTabDataGrid.datagrid('loadData', {"total":0,"rows":[]});
		}else{
			PageLogicObj.m_RegReturnListTabDataGrid.datagrid('loadData',GridData);
		}
	}); 
}
function pagerFilter(data){
	if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
		data = {
			total: data.length,
			rows: data
		}
	}
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	pager.pagination({
		showRefresh:false,
		onSelectPage:function(pageNum, pageSize){
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh',{
				pageNumber:pageNum,
				pageSize:pageSize
			});
			dg.datagrid('loadData',data);
			dg.datagrid('scrollTo',0); //������ָ������        
		}
	});
	if (!data.originalRows){
		data.originalRows = (data.rows);
	}
	var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
	if ((start+1)>data.originalRows.length){
		//ȡ���������������ҳ��ʼֵ
		start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
		opts.pageNumber=opts.pageNumber-1;
	}
	var end = start + parseInt(opts.pageSize);
	data.rows = (data.originalRows.slice(start, end));
	return data;
}
function RegNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		var RegNo=$("#RegNo").val();
		if (RegNo!="") {
			if (RegNo.length<10){
				for (var i=(10-RegNo.length-1); i>=0; i--) {
					RegNo="0"+RegNo
				}
			}
		}
		$("#RegNo").val(RegNo);
		RegReturnListTabDataGridLoad();
	}
}
function InvoiceNoChange(){
	var InvoiceNo=$("#InvoiceNo").val();
	if (InvoiceNo==""){
		$("#CardNo,#CardTypeNew,#PatientID,#RegNo").val('');
	}
}
function CardNoChange(){
	var CardNo=$("#CardNo").val();
	if (CardNo=="") {
		$("#CardTypeNew").val("");
		PageLogicObj.m_CardNoFlag=0;
	}
}
function CardNoOnBlur(){
	var PatientID=$("#PatientID").val();
	if ((PatientID=="")&&(PageLogicObj.m_CardNoFlag==0)){
		CheckCardNo();
	}
}
function CardNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		CheckCardNo();
	}
}
function CheckCardNo(){
	var CardNo=$("#CardNo").val();
	if (CardNo=="") return false;
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","",CardNoKeyDownCallBack);
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
			SetPatientInfo(PatientNo,CardNo,PatientID);
			RegReturnListTabDataGridLoad();	
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
			SetPatientInfo(PatientNo,CardNo,PatientID);
			RegReturnListTabDataGridLoad();	
			event.keyCode=13;
			break;
		default:
	}
}
function SetPatientInfo(PatientNo,CardNo,PatientID){
	if (PatientNo!='') {
		$("#RegNo").val(PatientNo);
		$("#CardNo").val(CardNo);
		$("#PatientID").val(PatientID);
	}
}
function GetCardNoLength(){
	var CardNoLength="";
	var CardTypeValue=$("#CardType").combobox("getValue");
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	return CardNoLength;
}

function FormatCardNo(){
	var CardNo=$("#CardNo").val();
	if (CardNo!='') {
		var CardNoLength=GetCardNoLength();
		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}
	return CardNo
}
function GetCardTypeRowId(){
	var CardTypeRowId="";
	var CardTypeValue=$("#CardType").combobox("getValue");
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId
}
function GetReceiptNo(){
	var insType = "";
	var p1=session['LOGON.USERID']+"^"+"^"+session['LOGON.GROUPID']+"^"+"R" + "^" + insType + "^" + session['LOGON.HOSPID'];
	if (cspRunServerMethod(ServerObj.GetreceipNO,'SetReceipNO','',p1)!='0') {
		$.messager.alert("��ʾ","û�з��䷢Ʊ��,���ܽ���!");
		return false;
	}
}
function SetReceipNO(value) {
	var myary=value.split("^");
	var ls_ReceipNo=myary[0];
	var title = myary[4];
	var tipFlag = myary[5];
	var receiptNo = title + ls_ReceipNo;
	$('#ReceiptNo').val(receiptNo);
	//�������С����С��ʾ��change the Txt Color
	if (tipFlag == "1"){	
		$("#ReceiptNo").addClass("newclsInvalid"); 
	}
}
function LoadReturnReason(){
	var ReturnStr=$.cm({
	    ClassName : "web.DHCOPReturnReason",
	    MethodName : "FindReason",
	    dataType:"text"
	},false);
	var ArrData=new Array();
	var ReturnStrArry=ReturnStr.split("^");
	var LenR=ReturnStrArry.length
	for (var j=0;j<LenR;j++){
		var Desc=ReturnStrArry[j].split("!")[0];
		var RowID=ReturnStrArry[j].split("!")[1];
		ArrData.push({"id":RowID,"text":Desc})
	}
	var cbox = $HUI.combobox("#ReturnReason", {
			valueField: 'id',
			textField: 'text', 
			editable:true,
			data: ArrData,
			onChange:function(newValue,oldValue){
				if (newValue==""){
					$(this).combobox("select","");
				}
			}
	 });
}
function SetReturnSum(row){
	var TotalFee=row['TabPrice'];
	var AppFee=row['TabAppFee']; 
	var ReturnFee=(+TotalFee)-(+AppFee);
	var InvoiceId=row['InvoiceId']; 
	var TabINVPayMode=row['INVPayMode'];  
	var CashPayMode=ServerObj.CashPayMode;
	var CashAmt=0,MRFee=0;
	if (InvoiceId!=""){
		for (var m=0;m<TabINVPayMode.split(",").length;m++){
			var OnePayModeStr=TabINVPayMode.split(",")[m];
			var OnePayMode=OnePayModeStr.split(":")[0];
			var OnePayModeAmt=OnePayModeStr.split(":")[1];
			if (OnePayMode==CashPayMode){
				var CashAmt=OnePayModeAmt;
				break;
			}
	    }
	}else{
		CashAmt=TotalFee-AppFee;
	}
	if (InvoiceId!=""){
		var FeeTypeStr="MR";
		var MRFee=$.cm({
		    ClassName : "web.DHCOPAdmReg",
		    MethodName : "GetRegINVAppFee",
		    dataType:"text",
		    InvoiceRowId:InvoiceId,
		    RegFeeType:FeeTypeStr,
		    ExcludeFlag:0
		},false);
	}else{
		var MRFee=row['MRFee'];
	}
	var o=$HUI.checkbox("#ReturnMR");
	if (o.getValue()){
		$("#ReturnCash").val((+CashAmt).toFixed(2));
		$("#Mon").val((+ReturnFee).toFixed(2))
	}else{
		if ((+CashAmt)==0) var sum=+CashAmt 
		else  var sum=(+CashAmt)-(+MRFee);
		sum=sum.toFixed(2);
		$("#ReturnCash").val(sum);
		$("#Mon").val(((+ReturnFee)-(+MRFee)).toFixed(2))
	}
}
function UpdateclickHandler(type){
	var row=PageLogicObj.m_RegReturnListTabDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫ�˺ŵļ�¼!");
		return false;
	}
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
	var RegRowId=row["RegfeeRowId"];
	var xPaadm=row['AdmId'];
	/*var CheckForPrint=$.cm({    ///�˺����û�д�ӡ��Ʊ������Ҫ�ȴ�ӡ��Ʊ
	    ClassName : "web.DHCOPAdmReg",
	    MethodName : "CheckforCanclePrint",
	    dataType:"text",
	    adm:xPaadm
	},false);
	if (CheckForPrint!=""){
		$.messager.alert("��ʾ",CheckForPrint);
		return false;
	}*/
	var groupid=session['LOGON.GROUPID'];
	var rtn=$.cm({
	    ClassName : "web.DHCOPAdmReg",
	    MethodName : "CheckAdmDiagnos",
	    dataType:"text",
	    adm:xPaadm,
	    GroupRowId:groupid
	},false);
	var rtnArray=rtn.split("^");
	if (rtnArray[0]==1){
		$.messager.alert("��ʾ",rtnArray[1]);
		return false;
	}
	var CostSum=$("#ReturnCash").val();
	var PayModeStr=row['INVPayMode'];
	$.messager.confirm('ȷ�϶Ի���', '�Ƿ�ȷ��Ҫ�˺�?'+"<div>�˻��ֽ�:<div style='color:#f16e57'>"+CostSum+"Ԫ</div></div>"+"<div>֧����ʽ:<div style='color:#2ab66a'>"+PayModeStr+"</div></div>", function(r){
		if (r){
			var ReturnMR="N"
			var o=$HUI.checkbox("#ReturnMR");
			if (o.getValue()){
				ReturnMR="Y";
			}
			if(ReturnMR=="Y"){
				$.messager.confirm('ȷ�϶Ի���', '�Ƿ��˲�������?', function(r){
					if (r){
						CancelOPRegist();
					}else{
						o.setValue(false);
						setTimeout(function(){
							ReturnMR="N";
							CancelOPRegist();
						});
					}
				});
			}else{
				var MRFee=row['MRFee'];
				if(+MRFee!=0){
					$.messager.confirm('ȷ�϶Ի���', '�Ƿ��˲�������?', function(r){
						if (r){
							o.setValue(true);
							setTimeout(function(){
								ReturnMR="Y";
								CancelOPRegist();
							});
						}else{
							o.setValue(false);
							setTimeout(function(){
								ReturnMR="N";
								CancelOPRegist();
							});
						}
					});
				}else{
					CancelOPRegist();
				}
			}
		}
	});
	function CancelOPRegist(){
		var row=PageLogicObj.m_RegReturnListTabDataGrid.datagrid("getSelected");
		var RegRowId=row["RegfeeRowId"];
		RegRowId=RegRowId.replace(/(^\s*)|(\s*$)/g,'');
		var AdmId=row["AdmId"];
		var RBASRowId=row["TabRBASRowId"];
		var InsuAdmInfoDr=row['InsuAdmInfoDr'];
		var AdmReasonId=row['AdmReasonId'];
		var TabPayMode=row['TabPayMode'];
		var pno=$('#RegNo').val();
		var amount=$('#mon').val();
		var PatientNo=$('#RegNo').val();		
		var PatientID=$('#PatientID').val();
		var TabPrice=row['TabPrice'];
		var userid=session['LOGON.USERID'];	
		var groupid=session['LOGON.GROUPID'];	
		var ctlocid=session['LOGON.CTLOCID'];
		var ReturnMR="N"
		var o=$HUI.checkbox("#ReturnMR");
		if (o.getValue()){
			ReturnMR="Y";
		}
		//�˺�����д�ӡ��Ʊ��ʾ�ջط�Ʊ
		var InvCheckrtn=$.cm({
			    ClassName : "web.DHCOPAdmReg",
			    MethodName : "CheckforCancleINvPrt",
			    dataType:"text",
			    EpisodeID:AdmId
		},false);
		//�˺�ԭ��
		var ReturnReasonDr=$("#ReturnReason").combobox("getValue");
		ReturnReasonDr=CheckComboxSelData("ReturnReason",ReturnReasonDr);
		
		//ҽ�������˺�,���ʧ����Ҫ�����쳣����
		if (InsuAdmInfoDr!="") {
			var InsuRetValue=InsuOPRegStrike(0,userid,InsuAdmInfoDr,"",AdmReasonId,"");
			if(InsuRetValue!=0) {
				$.messager.alert("��ʾ","ҽ���˺�ʧ��,�������˺�!");
				//TODO �����쳣��������,�˺Ų����ӣ���Ϊ�˺��Ѿ�Ϊҽ������ǰ�����HIS���ɹ������˺ż���(ҽ���˺ŷ����ɶ�ε��ã�ҽ���Ѿ����ж�)
				// ҽ���˺�ʧ�ܣ�����HIS�Һ�ʧ�ܣ��洢�쳣����
				//��Ϣ��������ID^����ID^ҽ��ָ��^������^����״̬^�Ű�ID^�Ƿ�Һ�							    
				var OPRegINABInfo=PatientID+"^"+xPaadm+"^"+InsuAdmInfoDr+"^"+userid+"^"+"N"+"^"+RegRowId+"^"+"N"+"^"+AdmReasonId;	
				var ret=tkMakeServerCall("web.DHCOPAdmReg","SaveDHCOPAdmINAB",OPRegINABInfo);
				return false;
			}
		}
		var rtn=$.cm({
		    ClassName : "web.DHCOPAdmReg",
		    MethodName : "CancelOPRegistBroker",
		    dataType:"text",
		    itmjs:"",itmjsex:"",
		    RegFeeRowId:RegRowId,
		    UserRowId:userid, GroupRowId:groupid, LogonLocRowId:ctlocid,
		    ReturnMR:ReturnMR,
		    ReturnReasonDr:ReturnReasonDr
		},function(ret){
			var retarr=ret.split("$");	
			if (retarr[0]!="0"){
				SetPid(retarr[0]);
			}else{
				
				var RetInfo=""
				if(TabPayMode=="CASH") RetInfo="���˻������ֽ�"+TabPrice+"Ԫ";
				if(TabPayMode=="CPP") RetInfo="���˽���Ѿ��˻ص����ߵĿ��˻���,�����˻��ֽ�";
				if (retarr[1]!="") {
					var PrintArr=retarr[1].split("^");
					var RegfeeRowID=PrintArr[42];
					var APIFlag=retarr[2];
					if (APIFlag=="Y"){
						PrintInvCPP(RegfeeRowID);
					}else{
						PrintInv(RegfeeRowID);
					}
				}
				var AlertMsg="�˺ųɹ���"+RetInfo
				//lxz ���õ�����֧���ӿڽ����˷�
				var rtn=RegPayObj.RefundPay(RegRowId)
				if (!rtn){
					AlertMsg=AlertMsg+",��Mispose�˷�ʧ�ܣ�"	//��Ʒ���һ����������쳣�˵��Ĵ������
				}
				
				$.messager.alert("��ʾ",AlertMsg,"info",function(){
					if (AdmId==ServerObj.EpisodeID){
						ServerObj.EpisodeID="";
					}
					if (ServerObj.PageFrom=="Reg"){
						//����ͨ���ҺŽ��������˺Ų���,��Ҫˢ�¹ҺŽ��浱���ѹҺż�¼
						window.parent.GetCurDateRegList();
					}
					if (InvCheckrtn==2){$.messager.alert("��ʾ","�����Ѿ���ӡ��Ʊ,�˺����ջء�","info" , function (){
							if(type=="SwicthReg"){
								SwichReg();
								return false;
							}
						});
					}else if (InvCheckrtn==3){$.messager.alert("��ʾ","�����Ѿ����д�ӡ��Ʊ,�˺����ջء�","info",function(){
						if(type=="SwicthReg"){
								SwichReg();
								return false;
							}
						});
					}else{
						if(type=="SwicthReg"){
								SwichReg();
								return false;
							}
						}
					//����ʱ��Ҫ���˺�,�ٹҺ�
					GetReceiptNo();
					RegReturnListTabDataGridLoad();
					return true;
				});
			}
		});
	}
}
function SetPid(value){
	if (value!="0") {
		if(value=="cancel") {$.messager.alert("��ʾ",t['AdmIsCanceled']);}
		if(value=="diagnos") {$.messager.alert("��ʾ","�����Ѿ�����ϻ�ҽ�������˺Ż򻻺�!");}
		if(value=="orditem") {$.messager.alert("��ʾ","�Ѿ��й�ҽ��,�������˻���!");}
		if(value=="Invoice") {$.messager.alert("��ʾ","�Ѿ���ӡ����Ʊ,�������˻���!");}
		if(value=="overtime") {$.messager.alert("��ʾ","�Ѿ������˺�ʱ��!");}
		if(value=="NotSameHosp") {$.messager.alert("��ʾ","���ܿ�Ժ�˺�,���ʵ���˺�����ҽԺ!");}
		if ((value!="Invoice")&&(value!="orditem")&&(value!="diagnos")&&(value!="overtime")&&(value!="cancel")&&(value!="NotSameHosp")){
			$.messager.alert("��ʾ","�˺�ʧ��:"+value);
		}
	}else{
	  	$.messager.popover({msg: '�˺ųɹ�!',type:'success'});
	}
}
function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
	      var CombValue=Data[i].id
	 	  var CombDesc=Data[i].text
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}
function ReprintClickHandler(){
	var row=PageLogicObj.m_RegReturnListTabDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫ���������ش�ļ�¼!");
		return false;
	}
	if (row['TabInvoiceNo']==""){
		$.messager.alert("��ʾ","��Ʊ��Ϊ�յļ�¼���������ش�!");
		return false;
	}
	var RegRowId=row["RegfeeRowId"];
	RegRowId=RegRowId.replace(/(^\s*)|(\s*$)/g,'');
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
	var userid=session['LOGON.USERID'];	
	var groupid=session['LOGON.GROUPID'];	
	var ctlocid=session['LOGON.CTLOCID'];
	var rtn=$.cm({
	    ClassName : "web.DHCOPAdmReg",
	    MethodName : "RePrintBroker",
	    dataType:"text",
	    itmjs:"",itmjsex:"",
	    RegFeeRowId:RegRowId,
	    UserRowId:userid, GroupRowId:groupid, LogonLocRowId:ctlocid
	},function(ret){
		var retarr=ret.split("$");	
		if (retarr[0]=="0"){
			//��ӡ��Ʊ --�������ҽ����Ҫ�ж��ǵ���ҽ���ӿڴ�ӡ��Ʊ���ǵ���HIS��ӡ��Ʊ-ҽ���޸İ�����Ŀ���������޸�
			var PrintArr=retarr[1].split("^");
			var RegfeeRowID=PrintArr[42];
			PrintInv(RegfeeRowID)
			$.messager.alert("��ʾ","�ش�ɹ�!","info",function(){
				GetReceiptNo();
				RegReturnListTabDataGridLoad();
			});
		}else{
			if (retarr[0]=="-200"){
				$.messager.alert("��ʾ","ֻ���ش��Լ���δ���㷢Ʊ");
			}else if (retarr[0]=="-300"){
				$.messager.alert("��ʾ","��Ʊ��Ϊ�յĹҺż�¼,���������ش�!");
			}else if (retarr[0]=="-201"){
				$.messager.alert("��ʾ","�����շ�ȷ�����ʧ��!���������շ��쳣����������½���!")
			}else if (retarr[0]=="-202"){
				$.messager.alert("��ʾ","�ش�ʧ��!�˰�ȫ��û��Ȩ�޴�ӡ��Ʊ!")
			}else{
				$.messager.alert("��ʾ","�ش�ʧ��!");
			}
		}
	});
}
//�Һŷ�Ʊ��ӡ
function PrintInv(RegFeeID)
{   
	var UserID=session['LOGON.USERID'];
	var Return=tkMakeServerCall("web.DHCOPAdmReg","GetPrintInvInfo","InvPrint","INVPrtFlag2007",RegFeeID, UserID, "","");
}
function PrintInvCPP(RegFeeID){
	var UserID=session['LOGON.USERID'];
	var Return=tkMakeServerCall("web.DHCOPAdmReg","GetPrintInvInfo","InvPrintNewCPP","INVPrtFlagCPP", RegFeeID, UserID, "","");
}
function InvPrintNewCPP(TxtInfo, ListInfo){
	DHCP_GetXMLConfig("InvPrintEncrypt","INVPrtFlagCPP");
	InvPrintNew(TxtInfo, ListInfo);
}
function InvPrint(TxtInfo, ListInfo){
	DHCP_GetXMLConfig("InvPrintEncrypt","INVPrtFlag2007");
	InvPrintNew(TxtInfo, ListInfo);
}
function InvPrintNew(TxtInfo, ListInfo)
{   
	//DHCP_GetXMLConfig("InvPrintEncrypt","INVPrtFlag2007");
	var myobj=document.getElementById("ClsBillPrint");
	//------���շ�ʹ��ͬģ�壬������ӡ��һ�ſհ�ҳ�����------
	var tmpListInfo="";
	var tmpListAry=ListInfo.split(String.fromCharCode(2));
	var ListLen=tmpListAry.length;
	for (var i = 0; i < ListLen; i++) {
		if (i>7) break;
		if (tmpListInfo=="") {
			tmpListInfo=tmpListAry[i];
		}else{
			tmpListInfo=tmpListInfo+String.fromCharCode(2)+tmpListAry[i];
		}	
	}
	ListInfo=tmpListInfo;
	//------
	//PrintFun(myobj,TxtInfo,ListInfo);	
	DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","");
}
function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;    //close
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)			
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function OldRegPrintClickHandler(){
	var row=PageLogicObj.m_RegReturnListTabDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫ����ԭ���ش�ļ�¼!");
		return false;
	}
	if (row['TabInvoiceNo']==""){
		$.messager.alert("��ʾ","��Ʊ��Ϊ�յļ�¼����ԭ���ش�!");
		return false;
	}
	var RegRowId=row["RegfeeRowId"];
	RegRowId=RegRowId.replace(/(^\s*)|(\s*$)/g,'');
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
	var userid=session['LOGON.USERID'];	
	var groupid=session['LOGON.GROUPID'];	
	var ctlocid=session['LOGON.CTLOCID'];
	$.cm({
	    ClassName : "web.DHCOPAdmReg",
	    MethodName : "OldRegRePrintBroker",
	    dataType:"text",
	    itmjs:"",itmjsex:"",
	    RegFeeRowId:RegRowId,
	    UserRowId:userid, GroupRowId:groupid, LogonLocRowId:ctlocid
	},function(ret){
		var retarr=ret.split("$");	
		if (retarr[0]=="0"){
			//��ӡ��Ʊ --�������ҽ����Ҫ�ж��ǵ���ҽ���ӿڴ�ӡ��Ʊ���ǵ���HIS��ӡ��Ʊ-ҽ���޸İ�����Ŀ���������޸�
			var PrintArr=retarr[1].split("^");
			var RegfeeRowID=PrintArr[42];
			PrintInv(RegfeeRowID)
			$.messager.alert("��ʾ","�ش�ɹ�!","info",function(){
				GetReceiptNo();
				RegReturnListTabDataGridLoad();
			});
		}else{
			if (retarr[0]=="-200"){
				$.messager.alert("��ʾ","ֻ���ش��Լ���δ���㷢Ʊ!");
			}else if (retarr[0]=="-300"){
				$.messager.alert("��ʾ","��Ʊ��Ϊ�յĹҺż�¼,���������ش�!");
			}else if (retarr[0]=="-202"){
				$.messager.alert("��ʾ","�ش�ʧ��!�˰�ȫ��û��Ȩ�޴�ӡ��Ʊ!")
			}else{
				$.messager.alert("��ʾ","�ش�ʧ��!");
			}
		}
	});
}
function ReprintRegist() {
	var row=PageLogicObj.m_RegReturnListTabDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫ���йҺ�С���ش�ļ�¼!");
		return false;
	}
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
	var RegRowId=row["RegfeeRowId"];
	var userid=session['LOGON.USERID'];	
	var groupid=session['LOGON.GROUPID'];	
	var ctlocid=session['LOGON.CTLOCID'];
	var ret=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetPrintData",
		dataType:"text",
		RegfeeRowId:RegRowId, AppFlag:"", RePrintFlag:"Y"
	},false);
	PrintOut(ret);
	$.messager.popover({msg: '�ش�ɹ�!',type:'success'});
}
function PrintOut(PrintData) {
	try {
		if (PrintData=="") return;
		var PrintArr=PrintData.split("^");
		var AdmNo=PrintArr[0];
		var PatName=PrintArr[1];
		var RegDep=PrintArr[2];
		var DocDesc=PrintArr[3];
		var SessionType=PrintArr[4];
		var MarkDesc=DocDesc
		var AdmDateStr=PrintArr[5];
		var TimeRange=PrintArr[6];
		var AdmDateStr=AdmDateStr+" "+TimeRange;
		var SeqNo=PrintArr[7];
		var RoomNo=PrintArr[8];
		var RoomFloor=PrintArr[9];
		var UserCode=PrintArr[10];
		var RegDateYear=PrintArr[12];
		var RegDateMonth=PrintArr[13];
		var RegDateDay=PrintArr[14];
		var TransactionNo=PrintArr[15];
		var Total=PrintArr[16];
		var RegFee=PrintArr[17];
		var AppFee=PrintArr[18];
		var OtherFee=PrintArr[19];
		var ClinicGroup=PrintArr[20];
		var RegTime=PrintArr[21];
		var ExabMemo=PrintArr[23];
		var InsuPayCash=PrintArr[24];
		var InsuPayCount=PrintArr[25];
		var InsuPayFund=PrintArr[26];
		var InsuPayOverallPlanning=PrintArr[27];
		var InsuPayOther=PrintArr[28];
		var TotalRMBDX=PrintArr[29];
		var INVPRTNo=PrintArr[30];
		var CardNo=PrintArr[31];
		var Room=PrintArr[32];
		var AdmReason=PrintArr[33];
		var Regitems=PrintArr[34];
		var AccBalance=PrintArr[35];
		var PatNo=PrintArr[36];
		var TimeRangeInfo=PrintArr[37];
		var HospitalDesc=PrintArr[38];
		var PersonPay=PrintArr[39];
		var YBPay=PrintArr[40];
		var DYIPMRN=PrintArr[41];
		var RowID=PrintArr[42];
		var PayModeStr1=PrintArr[46];
		var PayModeStr2=PrintArr[47];
		var MyList="";
		for (var i=0;i<Regitems.split("!").length-1;i++){
			var tempBillStr=Regitems.split("!")[i];
			if (tempBillStr=="") continue;
			var tempBillDesc=tempBillStr.split("[")[0];
			var tempBillAmount=tempBillStr.split("[")[1];
			if (MyList=="") MyList=tempBillDesc+"   "+tempBillAmount;
			else  MyList = MyList + String.fromCharCode(2)+tempBillDesc+"   "+tempBillAmount;
		}

		//�����Ը������ı�ע
		var ProportionNote="";
		var ProportionNote1="";
		var ProportionNote2="";
		InsuPayCash="";
		InsuPayCount="";
		InsuPayOverallPlanning="";
		InsuPayOther="";
		ProportionNote="���վ���,"+RegFee+"Ԫ"+"������ҽ��������Χ";
		ProportionNote1="";
		ProportionNote2="";
		var NeedCardFee=false;
		var CardFee=0;
 		if (NeedCardFee==true){
 			var CardFee="������ "+parseFloat(CardFee)+"Ԫ";
 		}else{
 			var CardFee="";
 		}
		RegTime=RegDateYear+"-"+RegDateMonth+"-"+RegDateDay+" "+RegTime
		if (AccBalance=="") AccBalance=0;
		//�ش���ʾ���ѽ�
		//���Ѻ���
		AccTotal="" //SaveNumbleFaxed(AccBalance);
		//����ǰ���
    	AccAmount="" //SaveNumbleFaxed(parseFloat(AccBalance)+parseFloat(Total));
		var cardnoprint=$('#CardNo').val();
		if (cardnoprint=="") {
			cardnoprint=ServerObj.CardNo
		}
		var TimeD=TimeRange;
		if (AppFee!=0){AppFee="ԤԼ��:"+AppFee}else{AppFee=""}
		if (OtherFee!=0) {OtherFee="���Ʒ�:"+OtherFee}else{OtherFee=""}
		var PDlime=String.fromCharCode(2);
		var MyPara="AdmNo"+PDlime+AdmNo+"^"+"PatName"+PDlime+PatName+"^"+"TransactionNo"+PDlime+TransactionNo+"^"+"AccTotal"+PDlime+AccTotal+"^"+"AccAmount"+PDlime+AccAmount;
		var MyPara=MyPara+"^"+"MarkDesc"+PDlime+MarkDesc+"^"+"AdmDate"+PDlime+AdmDateStr+"^"+"SeqNo"+PDlime+SeqNo+"^RegDep"+PDlime+RegDep;
		var MyPara=MyPara+"^"+"RoomFloor"+PDlime+RoomFloor+"^"+"UserCode"+PDlime+UserCode;
		var MyPara=MyPara+"^"+"RegDateYear"+PDlime+RegDateYear+"^RegDateMonth"+PDlime+RegDateMonth+"^RegDateDay"+PDlime+RegDateDay;
		var MyPara=MyPara+"^"+"Total"+PDlime+Total+"^RegFee"+PDlime+RegFee+"^AppFee"+PDlime+AppFee+"^OtherFee"+PDlime+OtherFee;
		var MyPara=MyPara+"^"+"RoomNo"+PDlime+RoomNo+"^"+"ClinicGroup"+PDlime+ClinicGroup+"^"+"SessionType"+PDlime+SessionType+"^"+"TimeD"+PDlime+TimeD+"^"+"RegTime"+PDlime+RegTime+"^"+"cardnoprint"+PDlime+cardnoprint;
		var MyPara=MyPara+"^"+"INVPRTNo"+PDlime+INVPRTNo;
		var MyPara=MyPara+"^"+"TimeRangeInfo"+PDlime+TimeRangeInfo;
		var MyPara=MyPara+"^"+"YBPay"+PDlime+YBPay;
		var MyPara=MyPara+"^"+"PersonPay"+PDlime+PersonPay;
		var MyPara=MyPara+"^"+"RowID"+PDlime+RowID;
		var MyPara=MyPara+"^"+"DYIPMRN"+PDlime+Trim(DYIPMRN);
		var MyPara=MyPara+"^"+"ExabMemo"+PDlime+ExabMemo;
		var MyPara=MyPara+"^"+"PatNo"+PDlime+PatNo;       //��ӡ�ǼǺ�
		var MyPara=MyPara+"^"+"HospName"+PDlime+HospitalDesc+"^"+"paymoderstr1"+PDlime+PayModeStr1+"^"+"paymoderstr2"+PDlime+PayModeStr2;
		var myobj=document.getElementById("ClsBillPrint");
		//PrintFun(myobj,MyPara,"");
		DHC_PrintByLodop(getLodop(),MyPara,"","","");	
	} catch(e) {$.messager.alert("��ʾ",e.message)};
}
function Trim(str){
	return str.replace(/[\t\n\r ]/g, "");
}
function SwichRegclickHandle(){
	UpdateclickHandler("SwicthReg");
}
function SwichReg(){
	var userid=session['LOGON.USERID'];	
	var groupid=session['LOGON.GROUPID'];	
	var ctlocid=session['LOGON.CTLOCID'];
	var kname=session['LOGON.USERNAME'];
	var Pid=$('#PatientID').val();
	var m_CardNo=$('#CardNo').val();
    var amount=$('#Mon').val();
    var rtn=$.cm({
	    ClassName : "web.DHCOPRegTime",
	    MethodName : "GetPInfo",
	    dataType:"text",
	    PatId:Pid,
	},false);
    var Str=rtn.split("^");
	var PatName=Str[0];
	var PatSex=Str[1];
	var PatAge=Str[2];
	var Parobj=window.parent;
	if (window.parent){  //(window.name=="CacelReg"){   
		var CardNo=$("#CardNo").val();
		var CardTypeNew=$("#CardTypeNew").val();
		var RegNo=$("#RegNo").val();
		$("#PatientNo" , parent.document).val(RegNo);
		Parobj.destroyDialog("Project");
		if (CardNo!=""){
			Parobj.SetPassCardNo(CardNo,CardTypeNew);
		}else if(RegNo!=""){
			Parobj.CheckPatientNo();
		}
	}
}
function CancelMedicalBookclickHandle(){
	var row=PageLogicObj.m_RegReturnListTabDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫ�˲������ѵļ�¼!");
		return false;
	}
	var GroupID=session['LOGON.GROUPID'];
	var UserID=session['LOGON.USERID'];
	var LocID=session['LOGON.CTLOCID'];
	var NewInvoiceId="";
	var RegRowId=row["RegfeeRowId"];
	RegRowId=RegRowId.replace(/(^\s*)|(\s*$)/g,'');
	$.cm({
	    ClassName : "web.DHCOPAdmReg",  
	    MethodName : "CancelMedicalBookBroker",
	    dataType:"text",
	    RegFeeRowId:RegRowId, UserRowId:UserID, GroupRowId:GroupID, LogonLocRowId:LocID,
	    dataType:"text"
	},function(ret){
		if (ret.split('^')[0]!="0") {
			$.messager.alert("��ʾ","�˲�������ʧ��:"+ret.split('^')[1]);
			return false;
		}else{
			NewInvoiceId=ret.split('^')[1];
		}
		if (NewInvoiceId!=""){
			var APIFlag=ret.split('^')[2];
			if (APIFlag=="Y"){
				PrintInvCPP(RegRowId);
			}else{
				PrintInv(RegRowId);
			}
			//BillPrintNew('0^'+NewInvoiceId);
			$.messager.alert("��ʾ","�˲������ѳɹ�!","info",function(){
				GetReceiptNo();
				RegReturnListTabDataGridLoad();
			})
		}else{
			$.messager.alert("��ʾ","�˲������ѳɹ�!","info",function(){
				GetReceiptNo();
				RegReturnListTabDataGridLoad();
			})
		}
	});
}
function BillPrintNew(INVstr){
	var myrtn=$.cm({
	    ClassName : "web.UDHCOPGSConfig",  
	    MethodName : "ReadCFByGRowID",
	    dataType:"text",
	    GPRowID:session['LOGON.GROUPID']
	},false);
    var myary=myrtn.split("^");
	if (myary[0]==0){
		var BillPrtXMLName=myary[10];
	}else{
		return false;
	}
	DHCP_GetXMLConfig("InvPrintEncrypt",BillPrtXMLName);
	var INVtmp=INVstr.split("^");
	for (var invi=1;invi<INVtmp.length;invi++)
	{
		if (INVtmp[invi]!=""){
			var PayMode="";
			var Guser=session['LOGON.USERID'];
			var sUserCode=session['LOGON.USERCODE'];
			var myExpStr="";
			var myPreDep="";
			var myCharge="";
			var myCurGroupDR=session['LOGON.GROUPID'];
			var myExpStr=myPreDep+"^"+myCharge+"^"+myCurGroupDR;
			//s val=##Class(%CSP.Page).Encrypt($lb("web.UDHCOPINVPrtIF.GetOPPrtData"))
			var Return=tkMakeServerCall("web.UDHCOPINVPrtIF","GetOPPrtData","InvPrintNew",BillPrtXMLName,INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}
function ReadCardClickHandler(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}
function UpdatePatAdmReasonClickHandle(){
	var row=PageLogicObj.m_RegReturnListTabDataGrid.datagrid("getSelected");
	if (!row){
		$.messager.alert("��ʾ","��ѡ��Һż�¼!");
		return false;
	}
	var admid=row["AdmId"];
	var src="opadm.chgadmreason.hui.csp?EpisodeID="+admid;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("ChgAdmReason","�޸Ļ������ͼ�����ѱ�", "700", PageLogicObj.dh,"icon-w-edit","",$code,"");
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function destroyDialog(id){
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function RegDateonSelect(){
	$("#nday").val("");
}
function ndayChange(){
	var NDay=$("#nday").val();
	if (NDay!=""){
		//$("#RegDate").text("");
		$HUI.datebox("#RegDate").setValue("");
	}
}
function AccpinvClick() {
	websys_showModal({
		url:"dhcbill.opbill.accpinv.csp",
		title:'���д�ӡ',
		width:'95%',height:'95%'
	})
}
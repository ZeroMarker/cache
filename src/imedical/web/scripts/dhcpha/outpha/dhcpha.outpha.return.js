/*
ģ��:����ҩ��
��ģ��:����ҩ��-��ҩ
createdate:2016-05-11
creator:dinghongying,yunhaibao
*/
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var invRowId=""
var currEditRow=undefined; //�����б༭
var returnRowId="";
var m_CardNoLength=0;
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitConditon();
	InitCardType();
	var retReasonCombo=new ListCombobox("retReason",commonOutPhaUrl+'?action=GetRetReason','',combooption);
	retReasonCombo.init(); //��ʼ����ҩԭ��	
	var refuseReasonCombo=new ListCombobox("retRefuseReason",commonOutPhaUrl+'?action=GetRetRefuseReason','',combooption);
	refuseReasonCombo.init(); //��ʼ����ҩԭ��		
	InitInfo();
	InitReqGrid();
	$('#btnClear').bind("click",btnClearHandler);
	$('#btnPrint').bind("click",btnPrintHandler);
	$('#btnReadCard').bind("click",btnReadCardHandler);  
	$('#btnSearch').bind("click",btnSearchHandler);  
	$('#btnReturn').bind("click",btnReturnHandler); 
	$('#btnRefuseReturn').bind("click",btnRefuseReturnHandler); 
	$('#patNo').bind('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			if (patno!=""){
				GetWholePatID(patno);
			}	
		}
	});
	$('#cardNo').bind('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardno=$.trim($("#cardNo").val());
			if (cardno!=""){
				GetPatInfoByCardNo(cardno);
			}	
		}
	});
	$('#invNo').bind('keypress',function(event){
	 	if(event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			if (patno!=""){
				var input=gLocId+"^"+patno+"^"+$("#phaDate").datebox("getValue")
				var mydiv = new InvNoDivWindow($("#invNo"), input,getInvReturn);
	            mydiv.init();
			}else{
				
		 	}	
	 	}
	});
})
//��ʼ������
function InitConditon(){
	$.ajax({  
		type: 'POST',
		url: commonOutPhaUrl+'?action=GetPminoLen',
		data: "",
		success:function(value){     
			if (value!=""){
				hisPatNoLen=value;
			}   
		},    
		error:function(){        
			alert("��ȡ����ʧ��!");
		}
	});
	$("#phaDate").datebox("setValue", formatDate(0));  //Init��ʼ����
}
//���
function btnClearHandler(){
	invRowId=""
	returnRowId=""
	currEditRow=undefined;
	$("#phaDate").datebox("setValue", formatDate(0));  //Init��ʼ����
	$("#cardNo").val("");
	$("#patNo").val("");
	$("#patName").val("");
	$("#prescNo").val("");
	$("#invNo").val("");
	$('#retReason').combobox("setValue","");
	$('#retRefuseReason').combobox("setValue","");
	$('#reqgrid').datagrid('loadData',{total:0,rows:[]}); 
	$('#reqgrid').datagrid('options').queryParams.params = "";
	$('#returngrid').datagrid('loadData',{total:0,rows:[]}); 
	$('#returngrid').datagrid('options').queryParams.params = ""; 
}

//��ʼ��������
function InitCardType()
{
	$('#cardType').combobox({  
		width:100,
		panelHeight:'auto',
		panelWidth: '150',
		width:'150',
		url:commonOutPhaUrl+'?action=GetCardType',  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#cardType').combobox('getData');
            if (data.length > 0) {
                  $('#cardType').combobox('select', data[0].RowId);
                  m_CardNoLength=data[0].RowId.split("^")[17];
                  for (var i=0;i<data.length;i++){
						var tmpcardvalue = data[i].RowId;
						var tmpcardarr = tmpcardvalue.split("^");
						var defaultflag = tmpcardarr[8];
						if (defaultflag == "Y") {
							$('#cardType').combobox('select', data[i].RowId);
						}
	              }
              }            
	    },
       onSelect:function(record){  
       		if (record.Desc=="������"){
	       		//$("#cardNo").attr("disabled", true);	
	       	}
	       	else{
		      // $("#cardNo").attr("disabled", true);	
		    }  
        } 
	    
	});
}
//��ʼ�����ݱ�
function InitInfo(){
	//����columns
	var columnspat=[[
	    {field:'TPhdesc',title:'ҩƷ����',width:225},    
        {field:'TPhUom',title:'ҩƷ��λ',width:80},    
        {field:'TPrice',title:'ҩƷ����',width:100,align:'right'},
        {field:'TDispQty',title:'��ҩ����',width:80,align:'right'},
        {field:'TDispMoney',title:'��ҩ���',width:100,align:'right'},
        {field:'TRetQty',title:'��ҩ����',width:100,align:'center',editor:{
			type:'numberbox',
				options:{
					precision:2
				}
			},
			formatter: function(value,row,index){
				return  '<span style="color:#ff0066;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ value+'</span>';
			}
        },
        {field:'TRetMoney',title:'��ҩ���',width:100,align:'right',
        	formatter: function(value,row,index){
				return  '<span style="color:#ff0066;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ value+'</span>';
			}
        },
        {field:'TPhgg',title:'���',width:100},
        {field:'TIncDispBatCode',title:'��ҩ����',width:100},
        {field:'TIncRetBatCode',title:'��ҩ����',width:100,
        	editor:{
	        	type:"text"
	        },
	        formatter: function(value,row,index){
				return  '<span style="color:#ff0066;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ value+'</span>';
			}
        },
        {field:'TPhdItm',title:'TPhdItm',width:100,hidden:true},
        {field:'TPhUomid',title:'TPhUomid',width:100,hidden:true},
        {field:'TReqItm',title:'TReqItm',width:100,hidden:true},
        {field:'TRefuse',title:'����ԭ��',width:100},
         ]];  
	
   //����datagrid	
   $('#returngrid').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  rownumbers:true,
      columns:columnspat,   
      pageSize:200,  // ÿҳ��ʾ�ļ�¼����
	  pageList:[200],   // ��������ÿҳ��¼�������б�
	  loadMsg: '���ڼ�����Ϣ...',
	  //pagination:true,
	  rowStyler: function(index,row){
		if ((row.TRefuse!="")&&(row.TRefuse!=undefined)){
            return 'color:#ff0066;font-weight:bold';
        } 
	  },
	  onLoadSuccess: function(){
		if (currEditRow!=undefined){
			$('#returngrid').datagrid('endEdit', currEditRow);
			currEditRow = undefined
		}
	  },
	  onClickCell: function (rowIndex, field, value) {
		    if ((field!="TIncRetBatCode")&&(field!="TRetQty")){return;}
		  	if (rowIndex != currEditRow) {
	        	if (endEditing(field)) {
					$("#returngrid").datagrid('beginEdit', rowIndex);
					var editor = $('#returngrid').datagrid('getEditor', {index:rowIndex,field:field});
		     	    editor.target.focus();
		     	    editor.target.select();
					var fieldEdt=$('#returngrid').datagrid('getEditor', { index: rowIndex, field: field });
					$(fieldEdt.target).bind("blur",function(){
	                	endEditing(field);        // ���� �����򵥼۱������� ���
	            	});
					currEditRow=rowIndex;  
	        	}
			}
	  }
     
});
}
var endEditing = function (field) {
    if (currEditRow == undefined) { return true }
    if ($('#returngrid').datagrid('validateRow', currEditRow)) {
        var ed = $('#returngrid').datagrid('getEditor', { index: currEditRow, field: field });
        var inputtxt = ""
		var selecteddata = $('#returngrid').datagrid('getSelected');
		var dispedqty=selecteddata["TDispQty"];
		var price=selecteddata["TPrice"]; 
		var retmoney=selecteddata["TRetMoney"]; 
        if (ed.type=="numberbox"){
	        inputtxt=$(ed.target).numberbox('getValue');
		    if (inputtxt<0){
		    	$.messager.alert('������ʾ',"���ֲ���С��0!");
		    	return false;
		    }
		    if (inputtxt!=""){
			   	if (parseFloat(inputtxt).toFixed(2)>parseFloat(dispedqty).toFixed(2)){
			    	$.messager.alert('������ʾ',"��ҩ�������ܴ��ڷ�ҩ����!");
			    	return false;
			    }
			    retmoney=inputtxt*price
		    }else{
				retmoney=""
			}
        }else if (ed.type=="text"){
	        inputtxt=$(ed.target).val();	    	
	    }
        var columns = $('#returngrid').datagrid("options").columns;
        var columnsstr=$('#returngrid').datagrid('getColumnFields',false);
		var columni=columnsstr.indexOf(field);
		var returngridrowsdata=$('#returngrid').datagrid("getRows");
		var retmoneycol=columnsstr.indexOf("TRetMoney");
		returngridrowsdata[currEditRow][columns[0][columni].field]=inputtxt;
		returngridrowsdata[currEditRow][columns[0][retmoneycol].field]=retmoney;
		$('#returngrid').datagrid('refreshRow', currEditRow);
        $('#returngrid').datagrid('endEdit', currEditRow);
        currEditRow = undefined;
        return true;
    } else {
        return false;
    }
}
 //���뵥�б�
function InitReqGrid()
{
	$('#reqgrid').datagrid({     
	    url:commonOutPhaUrl+"?action=GetReqListByReqNo",    
	    columns:[[     
	        {field:'reqNo',title:'���뵥��',width:100},
	        {field:'invNo',title:'�վݺ�',width:100},
	        {field:'prescNo',title:'������',width:100},    
	        {field:'reqUser',title:'������',width:100},
	        {field:'reqRowId',title:'reqRowId',width:100,hidden:true},  
	        {field:'reqReason',title:'reqReason',width:100,hidden:true},                   
	    ]],
	    fit:true, 
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    onLoadSuccess: function(){
         	//ѡ�е�һ
         	if ($('#reqgrid').datagrid("getRows").length>0){
	         	$('#reqgrid').datagrid("selectRow", 0)
         	}
         	else{
	        	$('#returngrid').datagrid('loadData',{total:0,rows:[]}); 
				$('#returngrid').datagrid('options').queryParams.params = ""; 
	        }
         	
	    },
	    onSelect:function(rowIndex,rowData){
		    var reqid=rowData["reqRowId"]
		    if (reqid>0){
			    var reqreason=rowData["reqReason"]
			    if (reqreason>0){
			    	$('#retReason').combobox("setValue",reqreason);
			    }
			    returnRowId=""
		    	$('#returngrid').datagrid('options').url=commonOutPhaUrl+"?action=GetReturnListByReq"
			   	$('#returngrid').datagrid('options').queryParams.params =reqid;
				$('#returngrid').datagrid('reload')
			}	   
	    }   
	});  
}
 //�������Ų�����ҩ��Ϣ
function btnSearchHandler(){
	if ($.trim($("#invNo").val())==""){invRowId==""}
	returnRowId=""
	var params=invRowId+"^"+$.trim($("#prescNo").val())+"^"+gLocId
	$('#returngrid').datagrid('options').url=commonOutPhaUrl+"?action=GetNeedReturnList"
	$('#returngrid').datagrid('options').queryParams.params =params;
	$('#returngrid').datagrid('reload')
   	$('#reqgrid').datagrid('options').queryParams.params ="";
	$('#reqgrid').datagrid('loadData',{total:0,rows:[]}); 
}
function getInvReturn(returndata)
{
	var tmpnewinvid=returndata["newInvId"]
	if (tmpnewinvid>0){
		invRowId=tmpnewinvid
		$("#invNo").val(returndata["newInvNo"]);
		$("#prescNo").val(returndata["prescNo"]);
		btnSearchHandler();
	}else{
		invRowId=""
	}
}
function GetCardTypeRowId() {
	var CardTypeRowId = "";
	var CardTypeValue = $('#cardType').combobox("getValue");
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
		m_CardNoLength= CardTypeArr[17];
	}
	return CardTypeRowId;
}
//����
function btnReadCardHandler() {
	var CardTypeRowId = GetCardTypeRowId();
	var myoptval = $('#cardType').combobox("getValue");
	var myrtn; 
	myrtn = DHCACC_GetAccInfo(CardTypeRowId, myoptval); 
	if (myrtn == -200) { //����Ч
		$.messager.alert('������ʾ',"����Ч!");
		return;
	}
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//����Ч
		PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1]
		var NewCardTypeRowId = myary[8];
		$("#patNo").val(PatientNo);
		$("#cardNo").val(CardNo);
		SetPatInfo(PatientNo);
		break;
	case "-200":
		$.messager.alert('������ʾ',"����Ч");
		break;
	case "-201":
		//�ֽ�
		PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1]
		var NewCardTypeRowId = myary[8];
		$("#patNo").val(PatientNo);
		$("#cardNo").val(CardNo);
		SetPatInfo(PatientNo);
		break;
	default:
	}
}
///��0���˵ǼǺ�
function GetWholePatID(RegNo)
{    
	if (RegNo=="") {
		return RegNo;
	}
	var patLen = hisPatNoLen;
	var plen=RegNo.length;
	if (plen>patLen){
		$.messager.alert('������ʾ',"�ǼǺ��������");
		return;
	}
	for (i=1;i<=patLen-plen;i++){
		RegNo="0"+RegNo;  
	}
	$("#patNo").val(RegNo);
	SetPatInfo(RegNo);
	$("#invNo").val("");
	$("#prescNo").val("");
	$('#reqgrid').datagrid('options').queryParams.params = gLocId+"^"+RegNo;
	$('#reqgrid').datagrid('reload')
	  
}
function GetPatInfoByCardNo(cardno){
	var cardlen=cardno.length;
	var lszero=""
	if (m_CardNoLength>cardlen){
		var lszero="";
		for (i=1;i<=m_CardNoLength-cardlen;i++){
			lszero=lszero+"0"  
		}
		var cardno=lszero+cardno;
	}
	var patno=tkMakeServerCall("web.DHCOutPhCommon","GetPmiNoFrCardNo",cardno)
	if (patno=="-1"){
		$.messager.alert('��ʾ',"������Ч,�Ҳ�����Ӧ�ĵǼǺ�!","warning");
		return;	
	}
	GetWholePatID(patno);

}
function SetPatInfo(patno){
	var patinfo=tkMakeServerCall("web.DHCSTPharmacyCommon","GetPatInfoByNo",patno)
	var patname=patinfo.split("^")[0];
	$("#patName").val(patname);
}
 //ִ����ҩ
function btnReturnHandler(){
	var returngridrowsdata=$('#returngrid').datagrid("getRows");
	var returngridrows=returngridrowsdata.length;
	if (returngridrows<=0){
		$.messager.alert('��ʾ',"û����ϸ����!","info");
		return;
	}
	var retreason=$('#retReason').combobox("getValue");
	if ($.trim($('#retReason').combobox("getText"))==""){
		retreason=""
	}
	if (retreason==""){
		$.messager.alert('��ʾ',"��ҩԭ��Ϊ��!","info");
		return;	
	}
	if (returnRowId!=""){
		$.messager.alert('��ʾ',"����ҩ!","info");
		return;	
	}
	var checkretsum=0
	var returninfo="",oweflag=""
	var reti=0;
	for (reti=0;reti<returngridrows;reti++){
		var returnselectdata=returngridrowsdata[reti];
		var retqty=returnselectdata["TRetQty"];
		var dispedqty=returnselectdata["TDispQty"];
		var phditm=returnselectdata["TPhdItm"];
		var retmoney=returnselectdata["TRetMoney"];
	   	var price=returnselectdata["TPrice"];
	   	var batno=returnselectdata["TIncDispBatCode"];
	    var retuomid=returnselectdata["TPhUomid"];
	    var refusereason=returnselectdata["TRefuse"];
	    if((refusereason!="")&&(refusereason!=undefined)){continue;}
		if (retqty==""){continue;}
		if (phditm==""){continue;}
		if (parseFloat(retqty).toFixed(2)>parseFloat(dispedqty).toFixed(2)){
			$.messager.alert('��ʾ',"��"+(reti+1)+"��,��ҩ�������ڷ�ҩ����!","info");
			return;	
		}
	   	if ((retqty>0)&&(batno!="Ƿҩ")){
		   var checkret=tkMakeServerCall("web.DHCOutPhReturn","CheckRetQty",phditm,retqty)
		   if (checkret=="-1"){ checkretsum=checkretsum+1;}	
	   	}
	   	if (batno=="Ƿҩ"){
		   	oweflag=1;
		}
	   	var onereturn="";
	   	if (oweflag=="1"){
			onereturn=phditm;
		}else{
			onereturn=phditm+"^"+retqty+"^"+retmoney+"^"+retuomid+"^"+reti;
		}
		if (returninfo==""){
			returninfo=onereturn;
		}
		else{
			returninfo=returninfo+"&"+onereturn;
		}
	}
	if (checkret>0){
		$.messager.alert('��ʾ',"��ҩ�������ڷ�ҩ����,�޷���ҩ!","info");
		return;	
	}
	if (returninfo==""){
		$.messager.alert('��ʾ',"û�п���ҩƷ!","info");
		return;	
	}
	var reqrowid=""
	var reqdata = $('#reqgrid').datagrid('getSelected');
	if (reqdata){
		reqrowid=reqdata["reqRowId"];
	}
	//��֤�Ƿ�����
	if (oweflag=="1"){
		var oweret=tkMakeServerCall("web.DHCOutPhReturn","DoChowReturn",reqrowid,gUserId,returninfo)
		if (oweret!=0){
			$.messager.alert('��ʾ',"Ƿҩ��ҩʧ�ܣ��������:"+oweret,"error");
			return;
		}else {
			$.messager.alert("��ʾ","Ƿҩ��ҩ�ɹ���");
			return;
		}
	}else{
		var retrowid=""											
		var retval=tkMakeServerCall("web.DHCOutPhReturn","DoReturn",gLocId,gUserId,phditm,retreason,invRowId,"",reqrowid,returninfo)
		if (retval=="-1"){
			$.messager.alert("��ʾ","�û�û����ҩ������,��Ȩ������ҩ","info");
			return;
		}else if (retval=="-2"){
			$.messager.alert("��ʾ","������ҩ����ʧ��!�������:"+retval,"error");
			return;
		}else if (retval=="-3"){
			$.messager.alert("��ʾ","������ҩ����ʧ��!�������:"+retval,"error");
			return;
		}else if (retval=="-4"){
			$.messager.alert("��ʾ","������ҩ�ӱ�ʧ��!�������:"+retval,"error");
			return;
		}else if (retval=="-6"){
			$.messager.alert("��ʾ","��ҩ��������ҩ���Ҳ�һ�£����ʵ!","info");
			return;
		}else if (retval=="-7"){
			$.messager.alert("��ʾ","������Һ�˹�һ��ҩ���������ˣ�","info");
			return;
		}else {
			retrowid=retval;
		}
		//�˷Ѵ���
		if (retrowid>0){
			returnRowId=retrowid
			var retval=tkMakeServerCall("web.DHCOutPhReturn","RetMoney",gLocId,gUserId,gGroupId,invRowId,retrowid,"card")
			if (retval=="300"){
				$.messager.alert("��ʾ","�˷ѳ��ִ���,�������:"+retval,"error");
				return;
			}else if (retval=="200"){
				$.messager.alert("��ʾ","��ҩ�ɹ�!��Ʊ�Ѵ�ӡ,�뵽�շѴ��˷�!");
			}else if (retval=="0"){
				$.messager.alert("��ʾ","��ҩ�ɹ�!");
			}else if (retval=="100"){
				$.messager.alert("��ʾ","��ҩ�ɹ�!�뵽�շѴ��˷�!");
			}			
		}
	}
}
function btnPrintHandler(){
	if (returnRowId==""){
		$.messager.alert("��ʾ","������ҩ��,�ٴ�ӡ!","info");
		return;
	}
	PrintReturn(returnRowId,"")
}
 //�ܾ���ҩ
function btnRefuseReturnHandler(){
	var returngridselect=$('#returngrid').datagrid("getSelected");
	var returngridrowsdata=$('#returngrid').datagrid("getRows");
	var selectrow=$('#returngrid').datagrid("getRowIndex",returngridselect);
	if (returngridselect==null){
		$.messager.alert('��ʾ',"��ѡ����Ҫ�ܾ�����ҩ��¼!","info");
		return;
	}
	var reqitm=returngridselect["TReqItm"];
	var refuse=returngridselect["TRefuse"];
	if ((reqitm=="")||(reqitm==undefined)){
		$.messager.alert('��ʾ',"��������ҩ������ҩʱ����ܾ�!","info");
		return;
	}
	if ((refuse!="")&&(refuse!=undefined)){
		$.messager.alert('��ʾ',"�ü�¼�Ѿܾ�!","info");
		return;
	}
	var refuseReason=$.trim($("#retRefuseReason").combobox("getValue"));
	var refuseReasonDesc=$.trim($("#retRefuseReason").combobox("getText"))
	if (refuseReasonDesc==""){
		refuseReason="";
		$.messager.alert('��ʾ',"����ѡ��ܾ�ԭ��!","info");
		return;
	}
	var refuseret=tkMakeServerCall("web.DHCOutPhReturn","RefuseReason",refuseReason,reqitm)
	if (refuseret==0){
		$.messager.alert('��ʾ',"�ܾ��ɹ�!");
		var columns = $('#returngrid').datagrid("options").columns;
		var columnsstr=$('#returngrid').datagrid('getColumnFields',false);
		var columni=columnsstr.indexOf("TRefuse");
		returngridrowsdata[selectrow][columns[0][columni].field]=refuseReasonDesc;
		$('#returngrid').datagrid('refreshRow', selectrow);
	}else{
		$.messager.alert('��ʾ',"�ܾ�ʧ��!�������:"+refuseret);
	}
	
}
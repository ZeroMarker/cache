/*
ģ��:����ҩ��
��ģ��:����ҩ��-��ҩ��ѯ
createdate:2016-05-25
creator:dinghongying,yunnaibao
*/
var url = "dhcpha.outpha.dispquery.action.csp";
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var inciRowId="";
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitCondition(); //��ʼ����ѯ����
	InitCardType();
	var pyUserCombo=new ListCombobox("pyUser",commonOutPhaUrl+'?action=GetPYUserList&gLocId='+gLocId+'&gUserId='+gUserId,'',combooption);
	pyUserCombo.init(); //��ʼ����ҩ��		
	var fyUserCombo=new ListCombobox("fyUser",commonOutPhaUrl+'?action=GetPYUserList&gLocId='+gLocId+'&gUserId='+gUserId,'',combooption);
	fyUserCombo.init(); //��ʼ����ҩ��
	$('#dispStat').combobox("setValue",1)
	InitDispMainList();	
	InitDispDetailList();
	$('#invNo').bind('keypress',function(event){
	 	if(event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			if (patno!=""){
				var input=gLocId+"^"+patno+"^"+$("#startDate").datebox("getValue")+"^"+$("#endDate").datebox("getValue")
				var mydiv = new InvNoDivWindow($("#invNo"), input,getInvReturn);
	            mydiv.init();
			}else{
				
		 	}	
	 	}
	});	
	$('#inciDesc').bind('keypress',function(event){
	 	if(event.keyCode == "13")    
	 	{
		 var input=$.trim($("#inciDesc").val());
		 if (input!="")
		 {
			var mydiv = new IncItmDivWindow($("#inciDesc"), input,getDrugList);
            mydiv.init();
		 }else{
		 }	
	 }
	});
	$('#patNo').bind('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			if (patno!=""){
				GetWholePatID(patno);
			}else{
				$("#patName").val("");
			}	
		}
	});
	//�����ѯ
	$('#btnRetrieve').bind('click', Query);	
	$('#btnClear').bind('click',btnClearHandler);
	$('#btnExport').bind('click',function(){
		ExportAllToExcel("DispMain")
	});
	$('#DispMain').datagrid('loadData',{total:0,rows:[]});
	$('#DispMain').datagrid('options').queryParams.params = ""; 
});
function InitCondition()
{
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: commonOutPhaUrl+'?action=GetPminoLen',//�ύ������ �����ķ���  
		data: "",
		success:function(value){     
			if (value!=""){
				hisPatNoLen=value;
			}   
		},    
		error:function(){        
			alert("��ȡ�ǼǺų���ʧ��!");
		}
	});
	$("#startDate").datebox("setValue", formatDate(0)+" "+"00:00:00");  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0)+" "+"23:59:59"); //Init��������
}
//��ʼ����ҩ��ѯ�б�
function InitDispMainList(){
	//����columns
	var columns=[[
        {field:'TPerName',title:'����',width:80},
        {field:'TPmiNo',title:'�ǼǺ�',width:80},  
        {field:'TPrtDate',title:'�շ�����',width:80},
        {field:'TPyDate',title:'��ҩ����',width:80},
        {field:'TDispDate',title:'��ҩ����',width:80},
        {field:'TPhMoney',title:'ҩ��',width:80,align:'right'},
        {field:'TPyName',title:'��ҩ��',width:80},
        {field:'TFyName',title:'��ҩ��',width:80},
        {field:'TPrescNo',title:'������',width:100},
        {field:'TPrescType',title:'��������',width:80},
        {field:'TPrtTime',title:'�շ�ʱ��',width:70},
        {field:'TPyTime',title:'��ҩʱ��',width:70},
        {field:'TDispTime',title:'��ҩʱ��',width:70},
        {field:'TDocloc',title:'����',width:120},
        {field:'TDoctor',title:'ҽ��',width:80,hidden:true},
        {field:'TOrdate',title:'ҽ������',width:80},
        {field:'TOrdremark',title:'ҽ����ע',width:80},
        {field:'TDiag',title:'���',width:120},
        {field:'TRpAmt',title:'���۽��',width:100,align:'right'},
        {field:'TEncryptLevel',title:'�����ܼ�',width:80},
        {field:'TPatLevel',title:'���˼���',width:80},
        {field:'tphd',title:'tphd',width:80,hidden:true},
        {field:'TPrtID',title:'TPrtID',width:80,hidden:true},

         ]];  
	
   //����datagrid	
   $('#DispMain').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  //rownumbers:true,
      columns:columns,
      nowrap:false,
      pageSize:50,  // ÿҳ��ʾ�ļ�¼����
	  pageList:[50,100,300],   // ��������ÿҳ��¼�������б�
	  singleSelect:true,
	  loadMsg: '���ڼ�����Ϣ...',
	  pagination:true,
	  onLoadSuccess: function(){
         	//ѡ�е�һ
         	if ($('#DispMain').datagrid("getRows").length>0){
	         	$('#DispMain').datagrid("selectRow", 0)
	         	QueryDetail();
         	}         	
	    },
	    onSelect:function(rowIndex,rowData){
		   QueryDetail();		   
	    }	 
   });
   $('#DispMain').gridupdown($('#DispMain'));
}


//��ʼ����ҩ��ϸ�б�
function InitDispDetailList(){
	//����columns
	var columns=[[
        {field:'TPhDesc',title:'ҩƷ',width:200},    
        {field:'TPhUom',title:'��λ',width:80},
        {field:'TPrice',title:'�۸�',width:80,align:'right'},
        {field:'TPhQty',title:'����',width:80,align:'right'},
        {field:'TPhMoney',title:'���',width:80,right:'right'},
        {field:'TStatus',title:'״̬',width:60},
        {field:'TJL',title:'����',width:70},
        {field:'TPC',title:'Ƶ��',width:70},
        {field:'TYF',title:'�÷�',width:70},
        {field:'TLC',title:'�Ƴ�',width:70},
        {field:'TDoctor',title:'ҽʦ',width:70},
        {field:'TIncPC',title:'����',width:90},
        {field:'TIncHW',title:'��λ',width:100},
        {field:'TRetQty',title:'��ҩ',width:70}
         ]];  
	
   //����datagrid	
   $('#DispDetail').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  nowrap:false,
	  singleSelect:true,
	  rownumbers:true,
      columns:columns,
      pageSize:100,  // ÿҳ��ʾ�ļ�¼����
	  singleSelect:true,
	  loadMsg: '���ڼ�����Ϣ...',
	  rowStyler: function(index,row){
			if (row.TStatus!="��ʵ"){
                return 'color:#ff0066;font-weight:bold';
            }
	  }	 
   });
}



///��ҩ��ѯ
function Query(){
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('������ʾ',"�����뿪ʼ����!","info");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('������ʾ',"�����뿪ʼ����!","info");
		return;
	}
	var patNo=$.trim($('#patNo').val());
	var patName=$("#patName").val();
	if ($.trim($("#inciDesc").val())==""){
		inciRowId=""
	}
	var pyUser=$("#pyUser").combobox("getValue");
	if ($.trim($("#pyUser").combobox("getText"))==""){
		pyUser="";
	}
	var fyUser=$("#fyUser").combobox("getValue");
	if ($.trim($("#fyUser").combobox("getText"))==""){
		fyUser="";
	}
	var dispStat=$("#dispStat").combobox("getValue");
	if ($.trim($("#dispStat").combobox("getValue"))==""){
		$.messager.alert('������ʾ',"��ѡ��ҩ״̬!","info");
		return;
	}
	var manaFlag=""
	if ($('#checkedMan').is(':checked')){manaFlag=1;}
	var startTime=$('#startTime').timespinner('getValue');
	var endTime=$('#endTime').timespinner('getValue');
	var invNo=$.trim($("#invNo").val());
	var depcode="";
	var doctor="";
	var params=startDate+"^"+endDate+"^"+gLocId+"^"+patNo+"^"+patName+"^"
			  +invNo+"^"+inciRowId+"^"+pyUser+"^"+fyUser+"^"+dispStat+"^"
			  +startTime+"^"+endTime+"^"+manaFlag+"^"+depcode+"^"+doctor
	$('#DispMain').datagrid({
     	url:url+'?action=QueryDispList',
     	queryParams:{
			params:params
		}
	});
}



///��ҩ��ϸ��ѯ
function QueryDetail(){
	var params=""
	var selecteddata = $('#DispMain').datagrid('getSelected');
	if(selecteddata==null){
		return;	
	}
	var phdRowId=selecteddata["tphd"];
	var pyUser=selecteddata["TPyName"];
	var fyFlag="1";
	if (pyUser=="W"){fyFlag="2";}
	var prescNo=selecteddata["TPrescNo"];
	var prtId=selecteddata["TPrtID"];
	params=phdRowId+"^"+fyFlag+"^"+gLocId+"^"+prescNo;
	$('#DispDetail').datagrid({
     	url:url+'?action=QueryDispDetailList',
     	queryParams:{
			params:params
		}
	});
	
}
function getDrugList(returndata){
	if (returndata["Inci"]>0){
		$("#inciDesc").val(returndata["InciDesc"]);
		inciRowId=returndata["Inci"]
	}
	else{
		$("#inciDesc").val("");
		inciRowId=""
	}
}
function getInvReturn(returndata)
{
	var tmpnewinvid=returndata["newInvId"]
	if (tmpnewinvid>0){
		$("#invNo").val(returndata["newInvNo"]);
	}else{
	}
}
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
	  
}
function SetPatInfo(patno){
	var patinfo=tkMakeServerCall("web.DHCSTPharmacyCommon","GetPatInfoByNo",patno)
	var patname=patinfo.split("^")[0];
	$("#patName").val(patname);
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
function btnClearHandler(){
	$("#startDate").datebox("setValue", formatDate(0)+" "+"00:00:00");  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0)+" "+"23:59:59"); //Init��������
	inciRowid="";
	$('#dispStat').combobox("setValue",1);
	$('#fyUser').combobox("setValue","");
	$('#pyUser').combobox("setValue","");
	$('#inciDesc').val("");
	$('#invNo').val("");
	$('#patNo').val("");
	$('#patName').val("");
	$('#startTime').timespinner('setValue',"");
	$('#endTime').timespinner('setValue',"");
	$('#checkedMan').attr('checked',false); 
	$('#DispDetail').datagrid('loadData',{total:0,rows:[]}); 
	$('#DispMain').datagrid('loadData',{total:0,rows:[]});
	$('#DispDetail').datagrid('options').queryParams.params = "";  
	$('#DispMain').datagrid('options').queryParams.params = ""; 
}
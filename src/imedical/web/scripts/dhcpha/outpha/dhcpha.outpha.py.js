/*
ģ��:����ҩ��
��ģ��:����ҩ��-��ҩ
createdate:2016-04-25
creator:yunhaibao
*/
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var hisCardNoLen=0;
var LocIsCY="";
var The_Time;
$(function(){
	InitTitle();
	InitCardType();
	InitPYList();
	InitPYListItm();
	$('#btnClear').bind("click",InitCondition);  
	$('#btnFind').bind("click",QueryPY); 
	$('#btnReadCard').bind("click",BtnReadCardHandler); 
	$('#btnPYSure').bind("click",BtnPYHandler); //��ҩ
	$('#btnTime').bind("click",BtnTimeHandler); 
	$('#btnRePrint').bind("click",BtnRePrintHandler); //����	 
	//�ǼǺŻس��¼�
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
		 CardNoKeyPress()
	 }
	});
	InitCondition();
});
function InitTitle(){
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: commonOutPhaUrl+'?action=GetDescFromId',//�ύ������ �����ķ���  
		data: "gphl="+gphl+"&gpyphw="+gphw+"&gpydr="+gpydr+"&gfydr="+gfydr+"&gpos="+gpos,//�ύ�Ĳ���  
		success:function(value){     
			if (value!=""){
				var getdescarr=value.split("^");
				$('#currentLoc').text(getdescarr[0]);
				$('#currentWin').text(getdescarr[1]);
				$('#pyUser').text(getdescarr[2]);
			}
			$('#stepTime').text(gsteptime+"��");    
		},    
		error:function(){        
			alert("��ȡ����ʧ��!");
		}
	}); 
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
			alert("��ȡ����ʧ��!");
		}
	});
	//ҩ������
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: commonOutPhaUrl+'?action=GetPhLocConfig',//�ύ������ �����ķ���  
		data: "gLocId="+gLocId,
		success:function(value){     
			if (value!=""){
				var valuearr=value.split("^")
				LocIsCY=valuearr[1];
			}   
		},    
		error:function(){        
			alert("��ȡ����ʧ��!");
		}
	});	
}
function InitCondition(){
	$("#startDate").datebox("setValue", formatDate(0));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));  //Init��������
	$("#patNo").val("");
	$("#cardNo").val("");
	$("input[type='checkbox'][id=checkedPY]").removeAttr("checked");
	$('#pygrid').datagrid('loadData',{total:0,rows:[]}); 
	$('#pydetailgrid').datagrid('loadData',{total:0,rows:[]});
	$('#pygrid').datagrid('options').queryParams.params = "";  
	$('#pydetailgrid').datagrid('options').queryParams.params = ""; 
	
}
function InitPYList(){
		//����columns
	var columns=[[
		{field:"TPatName",title:'����',width:80},
		{field:"TPmiNo",title:'�ǼǺ�',width:80},
		{field:'TPrtDate',title:'�շ�����',width:80},
		{field:'TPrintFlag',title:'��ӡ',width:40},	
		{field:'TFyFlag',title:'��ҩ',width:40,hidden:true},
		{field:'TPrtInv',title:'�վݺ�',width:80},
		{field:'TPrtTime',title:'�վ�ʱ��',width:100},
		{field:'TPrt',title:'TPrt',width:50,hidden:true},	
		{field:'TPrescNo',title:'������',width:100},
		{field:'TPrescMoney',title:'�������',width:80},	
		{field:'TPerSex',title:'�Ա�',width:50},
		{field:'TPerAge',title:'����',width:50},
		{field:'TMR',title:'���',width:150},	
		{field:'TGLOrd',title:'TGLOrd',width:100,hidden:true},			
		{field:'TPerLoc',title:'����',width:100},
		{field:'TSyFlag',title:'TSyFlag',width:100,hidden:true},	
		{field:'TPrescType',title:'�ѱ�',width:100},	
		{field:'TWinDesc',title:'��ҩ����',width:100},
		{field:'TPatID',title:'TPatID',width:100,hidden:true},	
		{field:'TJS',title:'����',width:100},
		{field:'TJYType',title:'��ҩ����',width:100},	
		{field:'TCallCode',title:'�绰',width:100},	
		{field:'TPatAdd',title:'��ַ',width:100,hidden:true},
		{field:'TPrescTitle',title:'TPrescTitle',width:100,hidden:true},	
		{field:'Tphdrowid',title:'Tphdrowid',width:100,hidden:true},
		{field:'TEncryptLevel',title:'�����ܼ�',width:100},		
		{field:'TPatLevel',title:'���˼���',width:100},			
	]];
	
	//����datagrid
	$('#pygrid').datagrid({
		border:false,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		singleSelect: true,
		selectOnCheck: true, 
		checkOnSelect: true,
		pageSize:30,  // ÿҳ��ʾ�ļ�¼����
		pageList:[30,50,100],   // ��������ÿҳ��¼�������б�
		pagination:true,
		rowStyler: function(index,row){
		      /* if (row.TPrintFlag=="OK"){
			    $('tr[datagrid-row-index='+index+']')
			    	.removeClass("datagrid-row-alt")
					.addClass("datagrid-row-set");
				}*/
				if (row.TPrintFlag=="OK"){
                    return 'color:#ff0066;font-weight:bold';
                } 
		},
		onLoadSuccess: function(){
         	//ѡ�е�һ
         	if ($('#pygrid').datagrid("getRows").length>0){
	         	$('#pygrid').datagrid("selectRow", 0)
	         	QueryPYSub();
         	}
         	
	    },
	    onSelect:function(rowIndex,rowData){
		   QueryPYSub();   
	    }

	});
	$('#pygrid').gridupdown($('#pygrid'));
}
function InitPYListItm()
{
	var columns=[[
		{field:'TPhDesc',title:'ҩƷ����',width:200},
		{field:'TPhQty',title:'����',width:80},
		{field:'TPhUom',title:'��λ',width:80},
		{field:'TPrice',title:'����',width:80},	
		{field:'TMoney',title:'���',width:80},	
		{field:'TOrdStatus',title:'ҽ��״̬',width:80},	
		{field:'TJL',title:'����',width:80},	
		{field:'TPC',title:'Ƶ��',width:80},
		{field:'TYF',title:'�÷�',width:80},
		{field:'TLC',title:'�Ƴ�',width:80},	
		{field:'TDoctor',title:'ҽʦ',width:80},	
		{field:'TOrditm',title:'TOrditm',width:80,hidden:true},	
		{field:'TUnit',title:'TUnit',width:80,hidden:true},	
		{field:'TIncPC',title:'����',width:80,hidden:true},	
		{field:'TIncHW',title:'��λ',width:80},
		{field:'TPhType',title:'TPhType',width:80,hidden:true},	
		{field:'TPhgg',title:'���',width:80},
		{field:'TPhbz',title:'��ע',width:80},
		{field:'TKCFlag',title:'���',width:80,hidden:true},	
		{field:'TSkinTest',title:'Ƥ��',width:80},
		{field:'TSyFlag',title:'TSyFlag',width:80,hidden:true},
		{field:'TPhFact',title:'����',width:80},
		{field:'TDoctCode',title:'TDoctCode',width:80,hidden:true},
		{field:'TJRFlag',title:'TJRFlag',width:80,hidden:true},
		{field:'TCyyf',title:'TCyyf',width:80,hidden:true},
		{field:'TKCQty',title:'�����',width:80},
		{field:'TYBType',title:'����',width:80},
		{field:'TDX',title:'TDX',width:80,hidden:true},
		{field:'TRealQty',title:'ʵ����',width:80,hidden:true}		
	]];
	
	//����datagrid
	$('#pydetailgrid').datagrid({
		border:false,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		singleSelect: true,
		selectOnCheck: true, 
		checkOnSelect: true,
		toolbar:"#conditiondiv",
		rowStyler: function(index,row){
			if (row.TOrdStatus!="��ʵ"){
                return 'color:#ff0066;font-weight:bold';
            } 
            if (row.TKCFlag=="����"){
                return 'color:#00cc00;font-weight:bold';
            } 
		}
	});
}
function InitCardType()
{
	$('#cardType').combobox({  
		width:100,
		panelHeight:'auto',
		panelWidth: 100,
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
	QueryPY();
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
//��ѯ��ҩ�б�
function QueryPY(){
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('������ʾ',"�����뿪ʼ����!");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('������ʾ',"�����뿪ʼ����!");
		return;
	}
	var patNo=$("#patNo").val();
	var patName=""
	var checkedPy=""
	$("input[type=checkbox][id=checkedPY]").each(function(){
		if($('#'+this.id).is(':checked')){
			checkedPy=this.value;
		}
	})
	var cPyUser=""
	var specialId=""
	var stopcon=""
	var params=startDate+"^"+endDate+"^"+gphl+"^"+gphw+"^"+patNo+"^"+patName
	+"^"+gpydr+"^"+gfydr+"^"+gpos+"^"+checkedPy+"^"+cPyUser+"^"+stopcon+"^"+specialId;
	$('#pygrid').datagrid({
		url:commonOutPhaUrl+'?action=QueryPYList',	
		queryParams:{
			params:params}
	});
	
}
//��ѯ��ҩ��ϸ
function QueryPYSub(){
	var selecteddata = $('#pygrid').datagrid('getSelected');
	if(selecteddata==null){
		return;	
	}
	var prt=selecteddata["TPrt"];
	var prescno=selecteddata["TPrescNo"];
	var phdrow=selecteddata["Tphdrowid"];
	var params=gphl+"^"+prt+"^"+prescno;
	$('#pydetailgrid').datagrid({
		url:commonOutPhaUrl+'?action=QueryDispListDetail',	
		queryParams:{
			params:params}
	});
}
//����
function BtnReadCardHandler() {
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
		QueryPY();
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
		QueryPY();
		break;
	default:
	}
}
function CardNoKeyPress(){
	 var cardno=$.trim($("#cardNo").val());
	 if (cardno!=""){
		var cardlen=cardno.length
		var CardTypeValue =$('#cardType').combobox("getValue");
		if (CardTypeValue != "") {
			var CardTypeArr = CardTypeValue.split("^");
			m_CardNoLength= CardTypeArr[17]
		}
		else {
			return
		}
		if (m_CardNoLength>cardlen){
			var lszero="";
			for (i=1;i<=m_CardNoLength-cardlen;i++)
			{
				lszero=lszero+"0"  
			}
			var lscard=lszero+cardno;
		}

		var pminofrmcardno=tkMakeServerCall("web.DHCOutPhCommon","GetPmiNoFrCardNo",lscard)	
		if (pminofrmcardno=="-1")
		{
			$("#cardNo").val("");
			$.messager.alert('������ʾ',"����Ч!");
			return;
		}
		$("#patNo").val(pminofrmcardno);
		$("#cardNo").val("");
		QueryPY();		
 	}	
}
//��ҩ��ť����
function BtnPYHandler(){
	if ($('#pygrid').datagrid("getRows").length<=0){
		$.messager.alert('��ʾ',"û������,�޷���ҩ!");
		return;
	}
	var selecteddata = $('#pygrid').datagrid('getSelected');
	if(selecteddata==null){
		$.messager.alert('��ʾ',"û��ѡ������,�޷���ҩ!");
		return;	
	}
	var selectedrow=$('#pygrid').datagrid("getRowIndex",selecteddata);
    /*if (selecteddata["TPrintFlag"]=="OK"){
    $('tr[datagrid-row-index='+selectedrow+']').removeClass("datagrid-row-alt")
		.addClass("datagrid-row-set");
	} */
	var prescno=selecteddata["TPrescNo"];
	var printflag=selecteddata["TPrintFlag"];
	var prt=selecteddata["TPrt"];
	if (printflag=="OK"){
		$.messager.alert('��ʾ',"�ü�¼�Ѿ���ҩ!");
		return;
	}
	//��鴦����˽��
	var checkprescadt=tkMakeServerCall("web.DHCOutPhCommon","GetOrdAuditResultByPresc",prescno)
	if (checkprescadt==""){
		$.messager.alert('��ʾ',"�������!");
		return;
    }
     
	if (checkprescadt=="N"){
		$.messager.alert('��ʾ',"��˲�ͨ��,��������ҩ");
		return;
	}
	var dispret=tkMakeServerCall("web.DHCOutPhTQDisp","InsertPHDisp",prt,gphl,gphw,gpydr,"",prescno,"",gpydr)
     if (dispret==-1){
	     $.messager.alert('��ʾ',"�ô���������,������ҩ");
	     return -1;
     }
     if (dispret==-2){
	     $.messager.alert('��ʾ',"�ô���ҩƷ����,�����ظ���ҩ");
	     return -2;
     }
     if (dispret==-3){  
	     $.messager.alert('��ʾ',"�ô���ҩƷ��ҩ,�����ظ���ҩ");
	     return -3;
     }
	 if (dispret==-4){
	     $.messager.alert('��ʾ',"�ô���ҽ����ͣ,������ҩ");
	     return -4;
     }     
     if (dispret==-7){
	     $.messager.alert('��ʾ',"��ҩʧ��,"+"ʧ��ԭ��: ��治��,��˲�");
	     return -7;
     }     
     if (dispret==-10){   
         $.messager.alert('��ʾ',"����ҩ,�����ظ���ҩ")
	     return -10;
     }     
     if (dispret==-24){
	     $.messager.alert('��ʾ',"��ҩʧ��,"+"ʧ��ԭ��: ��治��,��˲�")
	     return -24;
     }
     if (dispret==-123){
	     $.messager.alert('��ʾ',"�ô���δ��Ƥ�Ի�Ƥ�Խ������!")
	     return -123;
     }
     if (dispret<0){
	     $.messager.alert('��ʾ',"��ҩʧ��,"+"�������: "+retval)
	     return retval;
     } 
     if (!(dispret>0)){
	     $.messager.alert('��ʾ',"��ҩʧ��,"+"�������: "+retval)
	     return -100;
	     
     }
     if (dispret>0){   
	     $('#pygrid').datagrid('updateRow',{
			index: selectedrow,
			row: {Tphdrowid: dispret,TPrintFlag:'OK'}
		 });
		 PrintPrescCom(dispret,LocIsCY,"")
 		 /*if (selecteddata["TPrintFlag"]=="OK"){
		     $('tr[datagrid-row-index='+selectedrow+']')
		     	.removeClass("datagrid-row-alt")
				.addClass("datagrid-row-set");
			 $("#pydetailgrid").removeClass("datagrid-row-set")
		 }*/
     }
	
}
function BtnTimeHandler()
{

	if ($.trim($('#btnTime').text())=="��ʼ"){
		$('#btnTime').linkbutton({
			iconCls : 'icon-stop',
			text:'ֹͣ'
		});
		AutoDispHandler();
	}
	else{
		$('#btnTime').linkbutton({
			iconCls : 'icon-start',
			text:'��ʼ'
		});
		clearTimeout(The_Time) 
	}
}
function AutoDispHandler()
{
  var cyflag=LocIsCY;
  var autopy=tkMakeServerCall("web.DHCOutPhCode","GetPhlAutoPyFlag",gphl)
  if (autopy!=1) return ;
  var startDate=$('#startDate').datebox('getValue');
  var endDate=$('#endDate').datebox('getValue');
  var settime=gsteptime;
  var step=settime*1000
  The_Time=setTimeout("AutoDispHandler();", step);
  var getautodispinfo=tkMakeServerCall("web.DHCOutPhTQDisp","GetAutoDispInfo",startDate,startDate,gphl,gphw)
  var retarr=getautodispinfo.split("^")
  var retnum=retarr[0]
  var retpid=retarr[1]
  if  (retnum==0) {return ;}
  var insertphdispauto=tkMakeServerCall("web.DHCOutPhTQDisp","InsertPHDispAuto",cyflag,retpid,gphl,gphw,gpydr,"")
  if (insertphdispauto==""){return ; }
  PrintPrescCom(insertphdispauto,cyflag,"")

}
function BtnRePrintHandler(){
	var selecteddata = $('#pygrid').datagrid('getSelected');
	if(selecteddata==null){
		$.messager.alert('��ʾ',"û��ѡ������,�޷���ӡ!");
		return;	
	}
	var phdrowid=selecteddata["Tphdrowid"];
	PrintPrescCom(phdrowid,LocIsCY,"")
}
//��ݼ�
//jQuery(document).bind('KeyDown.f5',function(){ BtnReadCardHandler();return false});
$(document).keydown(function(event){
 	if(event.keyCode==115){BtnReadCardHandler();return false;}	//F4,����  
 	if(event.keyCode==118){QueryPY();return false;}	//F7,����  
 	if(event.keyCode==120){BtnRePrintHandler();return false;}	//F9,��ӡ 
 	if(event.keyCode==121){InitCondition();return false;}	//F10,��� 
 	if(event.keyCode==119){BtnPYHandler();return false;}	//F8,��ҩ  
}); 
/*
ģ��:����ҩ��
��ģ��:����ҩ��-ֱ�ӷ�ҩ
createdate:2016-04-29
creator:yunhaibao
*/

var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var hisCardNoLen=0;
var LocIsCY="";
var currEditRow=undefined; //�����б༭
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitTitle();
	InitCardType();
	InitFYList();
	InitNeedFYList();
	QueryNeedFYList();
	var basicLocCombo=new ListCombobox("basicLoc",commonOutPhaUrl+'?action=GetBasicLocList','',combooption);
	basicLocCombo.init(); //��ʼ������ҩ����
	var EMLocCombo=new ListCombobox("EMLoc",commonOutPhaUrl+'?action=GetEMLocList','',combooption);
	EMLocCombo.init(); //��ʼ���������ۿ���
	$('#btnClear').bind("click",InitCondition);  
	$('#btnFind').bind("click",QueryFY); 
	$('#btnReadCard').bind("click",BtnReadCardHandler); 
	$('#btnFYSure').bind("click",BtnFYHandler); //��ҩ
	$('#btnAllFYSure').bind("click",BtnAllFYHandler); //��ҩ
	$('#btnRefuse').bind("click",BtnRefuseHandler); //�ܾ���ҩ
	$('#btnCancelRefuse').bind("click",BtnCancelRefuseHandler); //�����ܾ���ҩ
	$('#btnRePrint').bind("click",BtnRePrintHandler); //����	 
	//$('#btnPrescAnalyse').bind("click",BtnPrescAnalyseHandler); //��������	 
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
	InitComputerIp();
	StartDaTongDll();
	InitCondition();
});
function InitTitle(){
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: commonOutPhaUrl+'?action=GetDescFromId',//�ύ������ �����ķ���  
		data: "gphl="+gphl+"&gpyphw="+""+"&gpydr="+gpydr+"&gfydr="+gfydr+"&gpos="+gpos+"&gfyphw="+gphw,//�ύ�Ĳ���  
		success:function(value){     
			if (value!=""){
				var getdescarr=value.split("^");
				$('#currentLoc').text(getdescarr[0]);
				$('#currentWin').text(getdescarr[5]);
				$('#pyUser').text(getdescarr[2]);
				$('#fyUser').text(getdescarr[3]);
			}
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
	$("#startDate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));  //Init��������
	$("#patNo").val("");
	$("#cardNo").val("");
	$("#basicLoc").combobox("setValue","");
	$("#EMLoc").combobox("setValue","");
	$("input[type='checkbox'][id=checkedFY]").removeAttr("checked");
	$('#fygrid').datagrid('loadData',{total:0,rows:[]}); 
	$('#fygrid').datagrid('options').queryParams.params = "";
	//$('#fygrid').datagrid('reload')
	$("#divReport").empty(); 
}

function InitFYList(){
		//����columns
	var columns=[[
		{field:"TPatName",title:'����',width:80},
		{field:"TPmiNo",title:'�ǼǺ�',width:80},
		{field:'TPrescNo',title:'������',width:100},
		{field:'TFyFlag',title:'��ҩ',width:40},
		{field:'TPrtDate',title:'�շ�����',width:80},
		{field:'TPrintFlag',title:'��ҩ',width:40},
		{field:'TPrtInv',title:'�վݺ�',width:80},
		{field:'TPrt',title:'TPrt',width:50,hidden:true},
		{field:'TWinDesc',title:'����',width:80},
		{field:'TPrescMoney',title:'�������',width:80},	
		{field:'TPatSex',title:'�Ա�',width:50},
		{field:'TPatAge',title:'����',width:50},
		{field:'TMR',title:'���',width:150},			
		{field:'TPatID',title:'TPatID',width:100,hidden:true},	
		{field:'TJyType',title:'��ҩ����',width:100},	
		{field:'TPrescTitle',title:'TPrescTitle',width:100,hidden:true},	
		{field:'Tphd',title:'Tphd',width:100,hidden:true},	
		{field:'TPyCode',title:'��ҩ��',width:100,hidden:true},	
		{field:'TPid',title:'TPid',width:100,hidden:true},	
		{field:'TFyDate',title:'��ҩ����',width:100}	,	
		{field:'TDocSS',title:'���״̬',width:100,
			formatter: function(value,row,index){
				return  '<span style="color:red" >'+ value+'</span>';
			}
		},
		{field:"TPassCheck",title:'������ҩ',width:60,
			formatter:function(value,row,index){
				if ((value=="")||(value==undefined)){
					return "";
				}else{
					if (value == "0") {
						var imgname = "greenlight.gif";
					}else if (value == "1") {
						var imgname = "yellowlight.gif";
					}else if (value == "2") {
						var imgname = "blacklight.gif";
					}
					var str = "<img id='DrugUseImg" + index + "'" + " src='../scripts/dhcpha/img/" + imgname + "'>";
					return str
				}
			}
		},
		{field:'TPatLoc',title:'����',width:100},
		{field:'TOrdGroup',title:'Э������',width:100},	
		{field:'TUseLocdr',title:'TUseLocdr',width:100,hidden:true},	
		{field:'TRecLocdesc',title:'���տ���',width:100},	
		{field:'TEncryptLevel',title:'�����ܼ�',width:100},		
		{field:'TPatLevel',title:'���˼���',width:100}			
	]];
	
	//����datagrid
	$('#fygrid').datagrid({
		border:false,
		url:commonOutPhaUrl,
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
				if (row.TFyFlag=="OK"){
                    return 'color:#ff0066;font-weight:bold';
                } 
		},
		onLoadSuccess: function(){
         	//ѡ�е�һ
         	if ($('#fygrid').datagrid("getRows").length>0){
	         	$('#fygrid').datagrid("selectRow", 0)
         	}
         	else{
				$("#divReport").empty();
	        }
         	
	    },
	    onSelect:function(rowIndex,rowData){
		    currEditRow=undefined;
			var phdrowid=rowData["Tphd"];
			var prescno=rowData["TPrescNo"];
			var cyflag=LocIsCY;
			var	prtrowid=rowData["TPrt"];
			var phlrowid=gphl;
			var paramsstr=phdrowid+"^"+prescno+"^"+prtrowid+"^"+phlrowid+"^"+cyflag
			$("#divReport").empty();
			frm_onload(paramsstr)	
	    }

	});
	$('#fygrid').gridupdown($('#fygrid'));
}
function InitNeedFYList()
{
	var columns=[[
		{field:'tbname',title:'����',width:80},
		{field:'tbpatid',title:'�ǼǺ�',width:80},	
		{field:'TEncryptLevel',title:'�����ܼ�',width:80},
		{field:'TPatLevel',title:'���˼���',width:80}	
	]];
	
	//����datagrid
	$('#needfylist').datagrid({
		border:false,
		url:commonOutPhaUrl,
		fit:true,
		//rownumbers:true,
		columns:columns,
	    singleSelect:true,
	    method:'post',
		loadMsg: '���ڼ�����Ϣ...',
		singleSelect: true,
		selectOnCheck: true, 
		checkOnSelect: true,
		pageSize: 30,
        pageList: [30,50,100],
		pagination:true,
		onClickRow:function(rowIndex,rowData){
			if (rowData){
				var patno=rowData['tbpatid'];
				$("#patNo").val(patno);
				QueryFY();
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
	QueryFY();
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
function QueryFY(){
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
	var checkedFy=""
	$("input[type=checkbox][id=checkedFY]").each(function(){
		if($('#'+this.id).is(':checked')){
			checkedFy=this.value;
		}
	})
	var basicLocId=$('#basicLoc').combobox("getValue");
	var EMLocId=$('#EMLoc').combobox("getValue");
	if ($('#basicLoc').combobox("getText")==""){
		basicLocId=""
	}
	if ($('#EMLoc').combobox("getText")==""){
		EMLocId=""
	}
	var params=startDate+"^"+endDate+"^"+gphl+"^"+gphw+"^"+patNo+"^"+patName
	+"^"+gpydr+"^"+gfydr+"^"+gpos+"^"+checkedFy+"^"+EMLocId+"^"+basicLocId
	$('#fygrid').datagrid('options').queryParams.action = "QueryDispList"; 
    $('#fygrid').datagrid('options').queryParams.params = params; 
    $("#fygrid").datagrid('reload');//���¼���table  
	var fygridpager = $('#fygrid').datagrid('getPager'); 
	fygridpager.pagination({  
		beforePageText:'',
		afterPageText:'/{pages}', 
  		displayMsg:''  
	});

}

//��ѯ����ҩ�б�,������
function QueryNeedFYList(){
	var params=gphl+"^"+gphw+"^"+"1"
	$('#needfylist').datagrid('options').queryParams.action = "QueryNeedFYList";//����ֵ  
    $('#needfylist').datagrid('options').queryParams.params = params;//����ֵ  
    $("#needfylist").datagrid('reload');//���¼���table  
	var fylistpager = $('#needfylist').datagrid('getPager'); 
	fylistpager.pagination({  
		beforePageText:'',
		afterPageText:'/{pages}', 
  		displayMsg:''  
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
		QueryFY();
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
		QueryFY();
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
		QueryFY();		
 	}	
}
//��ҩ��ť����
function BtnFYHandler(){
	if (CheckBeforeDoSth()==false){return;}
	var basicLocId=$("#basicLoc").combobox("getValue")
	if ((basicLocId!="")&&(basicLocId!="undefined")){
		 $.messager.alert("��ʾ","��ѡ��ļ�¼Ϊ����ҩ,��ʹ��ȫ���������ɲ�����!")
		 return ;
	}
	var selecteddata = $('#fygrid').datagrid('getSelected');
	DispensingMonitor(selecteddata,"");	
	ChkUnFyOtherLoc();
}
function BtnRePrintHandler(){
	if (CheckBeforeDoSth()==false){return;}
	var selecteddata = $('#fygrid').datagrid('getSelected');
	var phdrow=selecteddata["Tphd"];
	PrintPrescCom(phdrow,LocIsCY,"")
}
function BtnRefuseHandler(){
	if (CheckBeforeDoSth()==false){return;}
	var selecteddata = $('#fygrid').datagrid('getSelected');
	var selectedrow=$('#fygrid').datagrid("getRowIndex",selecteddata);
	var fyflag=selecteddata["TFyFlag"];
	var prescno=selecteddata["TPrescNo"];
	if (fyflag=="OK"){
		$.messager.alert('��ʾ',"�ü�¼�Ѿ���ҩ!");
		return;
	}
	var checkprescref = GetOrdRefResultByPresc(prescno);���� //LiangQiang 2014-12-22  �����ܾ�
	if (checkprescref=="N"){
		$.messager.alert("��ʾ","�ô����ѱ��ܾ�,�����ظ�����!")
		return;
	}else if (checkprescref=="A"){
		$.messager.alert("��ʾ","�ô����ѱ��ܾ�,�����ظ�����!")
		return;
	} 
	var checkprescadt=GetOrdAuditResultByPresc(prescno) ;
	if (checkprescadt==""){
		$.messager.alert("��ʾ","�ô���δ���,��ֹ����!")
		return;
	}else if (checkprescadt!="Y"){
		$.messager.alert("��ʾ","�ô������δͨ��,��ֹ����!")
		return;
	}
    var waycode ="32" //OutPhaWay;
	var retstr=showModalDialog('dhcpha.comment.selectreason.csp?orditm='+prescno+'&waycode='+waycode,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
	if (!(retstr)){return;}
	if (retstr==""){return;}
	var retarr=retstr.split("@");
    var ret="N";
	var reasondr=retarr[0];
	var advicetxt=retarr[2];
	var factxt=retarr[1];
	var phnote=retarr[3];		
	var input=ret+"^"+gUserId+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+gGroupId+"^"+prescno+"^OR"  //orditm;	
	if (reasondr.indexOf("$$$")=="-1"){
		reasondr=reasondr+"$$$"+prescno ;
	}
	var refuseret=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","SaveOPAuditResult",reasondr,input)
    if(refuseret==0){
		$('#fygrid').datagrid('updateRow',{
			index: selectedrow,
			row: {TDocSS:'�ܾ���ҩ'}
		});
    }else{
	    $.messager.alert("��ʾ","�ܾ�ʧ��!�������:"+refuseret)
		return;
    }
	
}
function BtnCancelRefuseHandler(){
	if (CheckBeforeDoSth()==false){return;}
	///����Ƿ��оܾ���ҩȨ��
    var refauthority=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","CheckFyUserAuthority",gphl,gfydr);
    if (refauthority=="0"){
	    $.messager.alert("��ʾ","���û�û�в���Ȩ��,�����ϼ��û���ݳ���!");
		return;
    }
 	var selecteddata = $('#fygrid').datagrid('getSelected');
	var selectedrow=$('#fygrid').datagrid("getRowIndex",selecteddata);
	var fyflag=selecteddata["TFyFlag"];
	var prescno=selecteddata["TPrescNo"];
	if (fyflag=="OK"){
		$.messager.alert('��ʾ',"�ü�¼�Ѿ���ҩ!");
		return;
	}
	var checkprescref = GetOrdRefResultByPresc(prescno);���� //LiangQiang 2014-12-22  �����ܾ�
	if ((checkprescref!="N")&&(checkprescref!="A")){
		if (checkprescref=="S"){
			$.messager.alert("��ʾ","�ô���ҽ�����ύ����,����Ҫ����!")
			return;
		}else{
			$.messager.alert("��ʾ","�ô���δ���ܾ�,���ܳ�������!")
			return;
		}
	}
	var cancelrefuseret=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","CancelRefuse",gUserId,prescno,"OR");
	if (cancelrefuseret == "0"){
		$('#fygrid').datagrid('updateRow',{
			index: selectedrow,
			row: {TDocSS:''}
		});
		$.messager.alert("��ʾ","�����ɹ�!");
	}
	else if (cancelrefuseret == "-2"){
		$.messager.alert("��ʾ","�ô���δ���ܾ�,���ܳ�������!");
	}else if (retval == "-3"){
		$.messager.alert("��ʾ","�ô����ѳ���,�����ٴγ���!");
	}
}
function BtnAllFYHandler(){	
	var fygridrowsdata=$('#fygrid').datagrid("getRows");
	var fygridrows=fygridrowsdata.length;
	if (fygridrows<=0){
		$.messager.alert('��ʾ',"û������!");
		return;
	}
	//���Ż���ҩƷ,��������ҩ�����嵥
	var uselocdr=fygridrowsdata[0]["TUseLocdr"];
	if (uselocdr!=""){
		var confirmtext=confirm("ȷ��ȫ����?ϵͳ��ȫ�����Ų�ѯ�������д������������ɲ�����!")
		if (confirmtext==false) return ;
		var pid=fygridrowsdata[0]["TPid"];
        var dispbasemedret=tkMakeServerCall("web.DHCOutPhDisp","SAVESUPPDATA",pid,gfydr,gphl)
        if (dispbasemedret>0){
	        PrintPrescCom("","",dispbasemedret);
	        QueryFY();
        }
        else{
		    $.messager.alert('��ʾ',"����ҩƷ��ҩʧ��,�������:"+dispbasemedret);
	    }
		return;
	}
	var confirmtext=confirm("ȷ��ȫ����?ϵͳ��ȫ�����Ų�ѯ�������д���!")
	if (confirmtext==false) return ;
	for(var rowi=0;rowi<fygridrows;rowi++){
		DispensingMonitor(fygridrowsdata[rowi],"U");		
	}
	ChkUnFyOtherLoc(); //����������� 
}
function CheckBeforeDoSth(){
	if ($('#fygrid').datagrid("getRows").length<=0){
		$.messager.alert('��ʾ',"û������!");
		return false;
	}
	var selecteddata = $('#fygrid').datagrid('getSelected');
	if(selecteddata==null){
		$.messager.alert('��ʾ',"û��ѡ������!");
		return false;	
	}
	return true
}
//DispensingMonitor.��ҩ��ͬ��
function DispensingMonitor(dispselectdata,updflag){
	var selectedrow=$('#fygrid').datagrid("getRowIndex",dispselectdata);
	var prescno=dispselectdata["TPrescNo"];
	var fyflag=dispselectdata["TFyFlag"];
	var patname=dispselectdata["TPatName"];
	var warnmsgtitle="��������:"+patname+"\t"+"������:"+prescno+"\n"
	if (fyflag=="OK"){
		alert(warnmsgtitle+"�ü�¼�Ѿ���ҩ!");
		return;
	}
	var checkprescadt=GetOrdAuditResultByPresc(prescno)
	if (checkprescadt==""){
		alert(warnmsgtitle+"�������!");
		return;
    }else if (checkprescadt=="N"){
		alert(warnmsgtitle+"��˲�ͨ��,������ҩ!");
		return;
	}else if (checkprescadt=="S"){
		if(!confirm(warnmsgtitle+"�ô���ҽ�����ύ����\n���'ȷ��'��ͬ�����߼�����ҩ�����'ȡ��'��������ҩ������")){
			return;
		} 
	}
	var checkprescref=GetOrdRefResultByPresc(prescno)
	if (checkprescref=="N"){
		alert(warnmsgtitle+"�ô����ѱ��ܾ�,��ֹ��ҩ!");
		return;
    }else if (checkprescref=="A"){
		alert(warnmsgtitle+"�ô����ѱ��ܾ�,��ֹ��ҩ!");
		return;
	}else if (checkprescref=="S"){
		if(!confirm(warnmsgtitle+"�ô���ҽ�����ύ����\n���'ȷ��'��ͬ�����߼�����ҩ�����'ȡ��'��������ҩ������")){
			return;
		} 
	}
	var dispQtyString=""
	var prt=dispselectdata["TPrt"];
	var newwin=""
	var shdr=""                                             
	var retval=tkMakeServerCall("web.DHCOutPhDisp","SAVEDATA",prt,gphl,gphw,gpydr,gfydr,prescno,gpos,shdr,newwin,dispQtyString,updflag)
	if (retval==-1){
		alert(warnmsgtitle+"�ô���������,���ܷ�ҩ!")
		return;
	}else if (retval==-2){
		alert(warnmsgtitle+"�ô���ҩƷ�ѷ�,�����ظ���ҩ")
		return;
	}else if (retval==-3){
		alert(warnmsgtitle+"�ô���ҩƷ�ѷ�,�����ظ���ҩ")
		return;
	}else if (retval==-4){
		alert(warnmsgtitle+"�ô���ҽ����ͣ,���ܷ�ҩ")
		return;
	}else if (retval==-7){
		alert(warnmsgtitle+"��ҩʧ��ԭ��: ��治��,��˲�")
		return;
	}else if (retval==-9){
		alert(warnmsgtitle+"�ò���Ѻ����,��˲�")
		return;
	}else if (retval==-24){
		alert(warnmsgtitle+"��ҩʧ��ԭ��: ��治��,��˲�")
		return;
	}else if (retval==-111){
		alert(warnmsgtitle+"�ô����ѱ��ܾ�,���ܷ�ҩ")
		return;
	}else if (retval==-123){
		alert(warnmsgtitle+"�ô���δ��Ƥ�Ի�Ƥ�Խ������")
		return;
	}else if (retval<0){
		alert(warnmsgtitle+"��ҩʧ��,�������: "+retval)
		return;
	}else if (!(retval>0)){
		alert(warnmsgtitle+"��ҩʧ��,�������: "+retval)
		return;
	}
	$('#fygrid').datagrid('updateRow',{
		index: selectedrow,
		row: {TFyFlag:'OK'}
	});
	$('#fygrid').datagrid('updateRow',{
		index: selectedrow,
		row: {Tphd:retval}
	});
	PrintPrescCom(retval,LocIsCY,"")
	//ChkUnFyOtherLoc(); //�����������
}

 //��ȡ�����ܾ���� 
function GetOrdRefResultByPresc(prescno)
{
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdRefResultByPresc",prescno);
	return ref;
}
 //��ȡ������˽�� 
function GetOrdAuditResultByPresc(prescno)
{
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdAuditResultByPresc",prescno);
	return ref;
}
//��ȡ��������δ��ҩ��¼,��������ҩʱ
function ChkUnFyOtherLoc()
{
	var startDate=$('#startDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	var patNo=$("#patNo").val();
	if((patNo=="")||(patNo==null)){
		return;
	}
	var ret=tkMakeServerCall("web.DHCOutPhAdd","ChkUnFyOtherLoc",startDate,endDate,patNo,gphl)
	if(ret==-1){
		//alert("����Ϊ��,�����")
	}
	else if(ret==-2)
	{
		alert("û�ҵ��ǼǺ�Ϊ"+patNo+"�Ĳ���");
		return;
		
	}
	else if((ret!="")&&(ret!=null))
	{
		alert("�ò����� "+ret+" ��ҩûȡ~��")
	}
}
 //��������
function BtnPrescAnalyseHandler(){
	var selecteddata = $('#fygrid').datagrid('getSelected');
	if (selecteddata==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�����Ĵ���!");
		return;
	}
	var fydetailgridrowsdata=$('#fydetailgrid').datagrid("getRows");
	var fydetailgridrows=fydetailgridrowsdata.length;
	if (fydetailgridrows<=0){
		$.messager.alert('��ʾ',"û����ϸ����!");
		return;
	}
	var oeoristr=""
	for(var rowi=0;rowi<fydetailgridrows;rowi++){
		var toeori=fydetailgridrowsdata[rowi]["TOrditm"];
		if (oeoristr==""){
			oeoristr=toeori;
		}else{
			oeoristr=oeoristr+"^"+toeori;
		}
	}
	if (oeoristr==""){
		return;
	}
	dtywzxUI(3, 0, "");
	var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongOutPresInfo", oeoristr);
	myrtn = dtywzxUI(28676, 1, myPrescXML);
	var selectedrow=$('#fygrid').datagrid("getRowIndex",selecteddata);
    $('#fygrid').datagrid('updateRow',{
		index: selectedrow,
		row: {TPassCheck:$.trim(myrtn)}
	});
}
 //����Ԥ��
function showPreviewPrescWindow(rowindex){
	var selecteddata=$('#fygrid').datagrid('getData').rows[rowindex];
	var phdrowid=selecteddata["Tphd"];
	var prescno=selecteddata["TPrescNo"];
	var cyflag=LocIsCY;
	var	prtrowid=selecteddata["TPrt"];
	var phlrowid=gphl;
	var lnk="dhcpha.outpha.prescpreview.csp?phdispid="+phdrowid+"&prescno="+prescno+"&cyflag="+cyflag+"&prtrowid="+prtrowid+"&phlrowid="+phlrowid;
	window.open(lnk,"����Ԥ��","height="+document.body.clientHeight*0.95+",width="+document.body.clientWidth*0.65+",menubar=no,status=yes,toolbar=no,resizable=yes,scrollbars = yes") ;
	
}
function InitComputerIp() 
{
   var ipAddr="";
   var locator = new ActiveXObject ("WbemScripting.SWbemLocator");  
   var service = locator.ConnectServer("."); //���ӱ���������
   var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");  //��ѯʹ��SQL��׼ 
   var e = new Enumerator (properties);
   var p = e.item ();
   for (;!e.atEnd();e.moveNext ())  
   {
	  	var p = e.item ();  
		ipAddr=p.IPAddress(0); 
		if(ipAddr) break;
	}
	$("#ipAddress").text(ipAddr)
}
$(document).keydown(function(event){
 	if(event.keyCode==115){BtnReadCardHandler();return false;}	//F4,����  
 	if(event.keyCode==118){QueryFY();return false;}	//F7,����  
 	if(event.keyCode==120){BtnRePrintHandler();return false;}	//F9,��ӡ 
 	if(event.keyCode==121){InitCondition();return false;}	//F10,��� 
 	if(event.keyCode==119){BtnFYHandler();return false;}	//F8,��ҩ  
}); 

/***************������ҩ��س���*********************/
//��ʼ����ͨ
function StartDaTongDll() {
	dtywzxUI(0, 0, "");
}
//���ô�ͨ����
function dtywzxUI(nCode, lParam, sXML) {
	var result;
	result = CaesarComponent.dtywzxUI(nCode, lParam, sXML);
	return result;
}

/****************************************************/

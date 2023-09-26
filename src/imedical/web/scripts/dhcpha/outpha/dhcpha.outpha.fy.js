/*
ģ��:����ҩ��
��ģ��:����ҩ��-��ҩ
createdate:2016-04-25
creator:yunhaibao
*/
var commonOutPhaUrl='DHCST.OUTPHA.ACTION.csp';
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var hisCardNoLen=0;
var LocIsCY="";
$(function(){
	InitTitle();
	InitCardType();
	InitFYList();
	InitFYListItm();
	InitNeedFYList();
	QueryNeedFYList();
	$('#btnClear').bind("click",InitCondition);  
	$('#btnFind').bind("click",QueryFY); 
	$('#btnReadCard').bind("click",BtnReadCardHandler); 
	$('#btnFYSure').bind("click",BtnFYHandler); //��ҩ
	$('#btnAllFYSure').bind("click",BtnAllFYHandler); //��ҩ
	$('#btnRefuse').bind("click",BtnRefuseHandler); //�ܾ���ҩ
	$('#btnCancelRefuse').bind("click",BtnCancelRefuseHandler); //�����ܾ���ҩ
	$('#btnRePrint').bind("click",BtnRePrintHandler); //����	 
	$('#btnRePrintLabel').bind("click",BtnRePrintLabelHandler); //�����ǩ	 
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
	InitComputerIp();
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
	$("input[type='checkbox'][id=checkedFY]").removeAttr("checked");
	$('#fygrid').datagrid('loadData',{total:0,rows:[]}); 
	$('#fydetailgrid').datagrid('loadData',{total:0,rows:[]});
	$('#fygrid').datagrid('options').queryParams.params = "";  
	$('#fydetailgrid').datagrid('options').queryParams.params = "";  
}

function InitFYList(){
		//����columns
	var columns=[[
		{field:"TPatName",title:'����',width:80},
		{field:"TPmiNo",title:'�ǼǺ�',width:80},
		{field:'TPrtDate',title:'�շ�����',width:80},
		{field:'TFyFlag',title:'��ҩ',width:40},
		{field:'TPrtInv',title:'�վݺ�',width:80},
		{field:'TPrt',title:'TPrt',width:50,hidden:true},	
		{field:'TPrescNo',title:'������',width:100},
		{field:'TPrescMoney',title:'�������',width:80},	
		{field:'TPerSex',title:'�Ա�',width:50},
		{field:'TPerAge',title:'����',width:50},
		{field:'TMR',title:'���',width:150},			
		{field:'TPatID',title:'TPatID',width:100,hidden:true},	
		{field:'TJyType',title:'��ҩ����',width:100},	
		{field:'TPrescTitle',title:'TPrescTitle',width:100,hidden:true},	
		{field:'phdrow',title:'phdrow',width:100,hidden:true},
		{field:'TPyCode',title:'��ҩ��',width:100,hidden:true},	
		{field:'TFyDate',title:'��ҩ����',width:100}	,	
		{field:'TDocSS',title:'���״̬',width:100,
			formatter: function(value,row,index){
				return  '<span style="color:red" >'+ value+'</span>';
			}
		},
		{field:'TEncryptLevel',title:'�����ܼ�',width:100},		
		{field:'TPatLevel',title:'���˼���',width:100}			
	]];
	
	//����datagrid
	$('#fygrid').datagrid({
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
				if (row.TFyFlag=="OK"){
                    return 'color:#ff0066;font-weight:bold';
                } 
		},
		onLoadSuccess: function(){
         	//ѡ�е�һ
         	if ($('#fygrid').datagrid("getRows").length>0){
	         	$('#fygrid').datagrid("selectRow", 0)
	         	QueryFYSub();
         	}
         	
	    },
	    onSelect:function(rowIndex,rowData){
		   QueryFYSub();
		   
	    }

	});
	$('#fygrid').gridupdown($('#fygrid'));
}
function InitFYListItm()
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
	$('#fydetailgrid').datagrid({
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
function InitNeedFYList()
{
	var columns1=[[
		{field:'tbname',title:'����',width:80},
		{field:'tbpatid',title:'�ǼǺ�',width:80},	
		{field:'TEncryptLevel',title:'�����ܼ�',width:80},
		{field:'TPatLevel',title:'���˼���',width:80}	
	]];
	//����datagrid
	$('#needfylist').datagrid({
		border:false,
		url:commonOutPhaUrl+"?action=QueryNeedFYList",
		fit:true,
		//rownumbers:true,
		columns:columns1,
	    //singleSelect:true,
	    method:'post',
		loadMsg: '���ڼ�����Ϣ...',
		singleSelect: true,
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
	var specialId=""
	var prescno=""
	var cludeflag=""
	var params=startDate+"^"+endDate+"^"+gphl+"^"+gphw+"^"+patNo+"^"+patName
	+"^"+cludeflag+"^"+prescno+"^"+checkedFy+"^"+specialId;
	$('#fygrid').datagrid({
		url:commonOutPhaUrl+'?action=jsQueryFYList',	
		queryParams:{
			params:params}
	});
	
}
//��ѯ��ҩ��ϸ
function QueryFYSub(){
	var selecteddata = $('#fygrid').datagrid('getSelected');
	if(selecteddata==null){
		return;	
	}
	var prt=selecteddata["TPrt"];
	var prescno=selecteddata["TPrescNo"];
	var phdrow=selecteddata["phdrow"];
	var params=gphl+"^"+prt+"^"+prescno;
	$('#fydetailgrid').datagrid({
		url:commonOutPhaUrl+'?action=QueryDispListDetail',	
		queryParams:{
			params:params}
	});
}
//��ѯ����ҩ�б�,������
function QueryNeedFYList(){
	var params=gphl+"^"+gphw+"^"+""
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
	var selecteddata = $('#fygrid').datagrid('getSelected');;
	DispensingMonitor(selecteddata);	
}
//��ӡ����
function BtnRePrintHandler(){
	if (CheckBeforeDoSth()==false){return;}
	var selecteddata = $('#fygrid').datagrid('getSelected');
	var phdrow=selecteddata["phdrow"];
	PrintPrescCom(phdrow,LocIsCY,"")
}
//��ӡ��ǩ
function BtnRePrintLabelHandler(){
	if (CheckBeforeDoSth()==false){return;}
	var selecteddata = $('#fygrid').datagrid('getSelected');
	var prt=selecteddata["TPrt"];
	var prescno=selecteddata["TPrescNo"];
	PrintPrescLabelCom(gLocId,prt,prescno)
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
	for(var rowi=0;rowi<fygridrows;rowi++){
		DispensingMonitor(fygridrowsdata[rowi]);		
	} 

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
function DispensingMonitor(dispselectdata){
	var selectedrow=$('#fygrid').datagrid("getRowIndex",dispselectdata);
	var prescno=dispselectdata["TPrescNo"];
	var fyflag=dispselectdata["TFyFlag"];
	var patname=dispselectdata["TPatName"];
	var warnmsgtitle="��������:"+patname+"\t"+"������:"+prescno+"\n"
	if (fyflag=="OK"){
		alert(warnmsgtitle+"�ü�¼�Ѿ���ҩ!");
		return;
	}
	var prt=dispselectdata["TPrt"];
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
	var retval=tkMakeServerCall("web.DHCOutPhDisp","UpdatePyd",prt,gphl,"",gfydr,prescno,"",gphw,"","")
	if (retval==-20){
		alert(warnmsgtitle+"�ô���������,���ܷ�ҩ!")
		return;
	}else if (retval==-21){
		alert(warnmsgtitle+"�ô���ҩƷ�ѷ�,�����ظ���ҩ")
		return;
	}else if (retval==-4){
		alert(warnmsgtitle+"�ô���ҽ����ͣ,���ܷ�ҩ")
		return;
	}else if (retval==-7){
		alert(warnmsgtitle+"��ҩʧ��ԭ��: ��治��,��˲�")
		return;
	}else if (retval==-24){
		alert(warnmsgtitle+"��ҩʧ��ԭ��: ��治��,��˲�")
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
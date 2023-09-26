/*
ģ��:����ҩ��
��ģ��:����ҩ��-Ƿҩ������
createdate:2016-05-27
creator:yunhaibao
*/

var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gPhLocId=tkMakeServerCall("web.DHCOutPhCommon","GetPhlFrmLoc",gLocId);
var gPyUserId=tkMakeServerCall("web.DHCOutPhCommon","GetPhPerson",gUserId);
var hisPatNoLen=0;
var hisCardNoLen=0;
var inciRowId="";
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
	InitOweList();
	InitOweListItm();
	$('#patNo').bind('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			if (patno!=""){
				GetWholePatID(patno);
			}	
		}
	});
	$('#inciDesc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var input=$.trim($("#inciDesc").val());
			if (input!=""){
				var mydiv = new IncItmDivWindow($("#inciDesc"), input,getDrugList);
				mydiv.init();
			}else{
				inciRowId="";
			}	
		}
	});
	$('#btnClear').bind("click",InitCondition);  
	$('#btnFind').bind("click",QueryOwe); 
	$('#btnReadCard').bind("click",BtnReadCardHandler); 
	$('#btnFYSure').bind("click",BtnFYHandler); //��ҩ
	$('#btnTYSure').bind("click",BtnTYHandler); //��ҩ
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
	$("#patName").val("");
	$("#cardNo").val("");
	$("#prescNo").val("");
	inciRowId="";
	$("#inciDesc").val("");
	$('#oweStat').combobox("setValue","");
	$('#owegrid').datagrid('loadData',{total:0,rows:[]}); 
	$('#owedetailgrid').datagrid('loadData',{total:0,rows:[]});
	$('#owegrid').datagrid('options').queryParams.params = "";  
	$('#owedetailgrid').datagrid('options').queryParams.params = "";  
}

function InitOweList(){
		//����columns
	var columns=[[
		{field:"TPatName",title:'����',width:80},
		{field:"TPmiNo",title:'�ǼǺ�',width:80},
		{field:'TPrtDate',title:'�շ�����',width:80},
		{field:'TPrtInv',title:'�վݺ�',width:80},
		{field:'TPrt',title:'TPrt',width:50,hidden:true},
		{field:'TOweStatusdesc',title:'Ƿҩ״̬',width:60,align:'center'},
		{field:'TPrescNo',title:'������',width:100},
		{field:'TPrescMoney',title:'�������',width:80},	
		{field:'TPerSex',title:'�Ա�',width:50},
		{field:'TPerAge',title:'����',width:50},
		{field:'TMR',title:'���',width:150},			
		{field:'TPerLoc',title:'����',width:150},			
		{field:'TPatID',title:'TPatID',width:100,hidden:true},	
		{field:'TJyType',title:'��ҩ����',width:100,hidden:true},	
		{field:'TPrescType',title:'�ѱ�',width:100},	
		{field:'Tphdrowid',title:'Tphdrowid',width:100,hidden:true},	
		{field:'TCallCode',title:'TCallCode',width:100,hidden:true},
		{field:'TOweDate',title:'Ƿҩʱ��',width:150},
		{field:'TOweUser',title:'Ƿҩ��',width:80},
		{field:'TOwedr',title:'TOwedr',width:80,hidden:true},
		{field:'TOweretdate',title:'��ҩʱ��',width:150},
		{field:'TOweretuser',title:'��ҩ��',width:80},
		{field:'TEncryptLevel',title:'�����ܼ�',width:100},		
		{field:'TPatLevel',title:'���˼���',width:100}			
	]];
	
	//����datagrid
	$('#owegrid').datagrid({
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
			if (row.TOweStatusdesc=="�ѷ�ҩ"){
	            return 'color:#ff0066;font-weight:bold';
	        }else if(row.TOweStatusdesc=="����ҩ"){
				return 'color:#00cc00;font-weight:bold';
	        }		   
		},
		onLoadSuccess: function(){
         	//ѡ�е�һ
         	if ($('#owegrid').datagrid("getRows").length>0){
	         	$('#owegrid').datagrid("selectRow", 0)
	         	QueryOweSub();
         	}
         	else{
	        	$('#owedetailgrid').datagrid('loadData',{total:0,rows:[]}); 
				$('#owedetailgrid').datagrid('options').queryParams.params = ""; 
	        }
         	
	    },
	    onSelect:function(rowIndex,rowData){
		   currEditRow=undefined
		   QueryOweSub();
		   
	    }

	});
	$('#owegrid').gridupdown($('#owegrid'));
}
function InitOweListItm()
{
	var columns=[[
		{field:'TPhDesc',title:'ҩƷ����',width:200},
		{field:'TPhQty',title:'����',width:80,align:'center',
			formatter: function(value,row,index){
				return  '<span style="font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ value+'</span>';
			}
		},
		{field:'TDispedqty',title:'�ѷ�����',width:80},
		{field:'TRealQty',title:'Ԥ������',width:80,align:'center',
			editor:{
			type:'numberbox',
				options:{
					precision:2
				}
			},
			formatter: function(value,row,index){
				return  '<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ value+'</span>';
			}
		},
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
		{field:'TDX',title:'TDX',width:80,hidden:true}	
	]];
	
	//����datagrid
	$('#owedetailgrid').datagrid({
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
		},
		onClickCell: function (rowIndex, field, value) {
			if (field!="TRealQty"){
				return;
			}
			var selecteddata = $('#owegrid').datagrid('getSelected');
			var owestat=selecteddata["TOweStatusdesc"];
			if (owestat=="�ѷ�ҩ"){
				$.messager.alert('��ʾ',"�ü�¼�ѷ�ҩ!","info");
				return
			}
			if (owestat=="����ҩ"){
				$.messager.alert('��ʾ',"�ü�¼����ҩ!","info");
				return
			}
			if (rowIndex != currEditRow) {
	        	if (endEditing()) {
					$("#owedetailgrid").datagrid('beginEdit', rowIndex);
					var realQtyEdt=	$('#owedetailgrid').datagrid('getEditor', { index: rowIndex, field: 'TRealQty' });
		     	    realQtyEdt.target.focus();
		     	    realQtyEdt.target.select();
					$(realQtyEdt.target).bind("blur",function(){
	                	endEditing();    
	            	});
					currEditRow=rowIndex;  
	        	}
			}
		}
	});
}
var endEditing = function () {
    if (currEditRow == undefined) { return true }
    if ($('#owedetailgrid').datagrid('validateRow', currEditRow)) {
        var ed = $('#owedetailgrid').datagrid('getEditor', { index: currEditRow, field: 'TRealQty' });
        var realqty = $(ed.target).numberbox('getValue');
        $('#owedetailgrid').datagrid('updateRow',{
			index: currEditRow,
			row: {TRealQty:realqty}
		});
        $('#owedetailgrid').datagrid('endEdit', currEditRow);
        currEditRow = undefined;
        return true;
    } else {
        return false;
    }
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
	QueryOwe();
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
function getDrugList(returndata){
	if (returndata["Inci"]>0){
		$("#inciDesc").val(returndata["InciDesc"]);
		inciRowId=returndata["Inci"];
	}
	else{
		$("#inciDesc").val("");
		inciRowId="";
	}
}
//��ѯ��ҩ�б�
function QueryOwe(){
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('������ʾ',"��������ʼ����!");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('������ʾ',"�������ֹ����!");
		return;
	}
	var patNo=$("#patNo").val();
	var patName="";
	var prescNo=$("#prescNo").val();
	var oweStat=$("#oweStat").combobox("getValue");
	var disped=0,returned=0;
	if(oweStat=="1"){
		disped=1;;
	}else if(oweStat=="0"){
		returned=1
	}
	if ($.trim($("#inciDesc").val())==""){
		inciRowId="";
	}
	var gphw="",gphl="",printed="0";
	var params=startDate+"^"+endDate+"^"+gLocId+"^"+gphw+"^"+patNo+"^"+printed
	+"^"+disped+"^"+returned+"^"+prescNo+"^"+patName+"^"+inciRowId;
	$('#owegrid').datagrid({
		url:commonOutPhaUrl+'?action=QueryOweList',	
		queryParams:{
			params:params}
	});
	
}
//��ѯ��ҩ��ϸ
function QueryOweSub(){
	var selecteddata = $('#owegrid').datagrid('getSelected');
	if(selecteddata==null){
		return;	
	}
	var phdowerow=selecteddata["TOwedr"];
	var params=phdowerow;
	$('#owedetailgrid').datagrid({
		url:commonOutPhaUrl+'?action=QueryOweListDetail',	
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
		QueryOwe();
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
		QueryOwe();
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
		QueryOwe();		
 	}	
}
//ȷ�Ϸ�ҩ��ť����
function BtnFYHandler(){
	if (CheckBeforeDoSth()==false){return;}
	var selecteddata = $('#owegrid').datagrid('getSelected');
	OweDispMonitor(selecteddata,"");	
}
//ִ����ҩ��ť����
function BtnTYHandler(){
	if (CheckBeforeDoSth()==false){return;}
	var selecteddata = $('#owegrid').datagrid('getSelected');
	var gpydr=gPyUserId;
	var prescno=selecteddata["TPrescNo"];
	var owedr=selecteddata["TOwedr"];
	var retval=tkMakeServerCall("web.DHCOutPhOweList","ExcRetrun",gpydr,prescno,owedr);
	if (retval==-1){
		$.messager.alert("��ʾ","��Ƿҩ��״̬�Ѵ���,������ҩ!","info");
		return;
	}else if (retval==-2){
		$.messager.alert("��ʾ","��Ƿҩ��״̬�Ѵ���,�����ظ���ҩ!","info")
		return;
	}else if (retval==-4){
		$.messager.alert("��ʾ","�ô�����δ��ҩ,��ȡ����ҩ��,����ִ����ҩ!","info")
		return;
	}else if (retval<0){
		$.messager.alert("��ʾ","��ҩʧ��:"+retval,"error")
		return;
	} 
	$.messager.alert("��ʾ","Ƿҩ��ҩ�ɹ�,�뵽�շѴ��˷�!"); 
	var selectedrow=$('#owegrid').datagrid("getRowIndex",selecteddata);
	$('#owegrid').datagrid('updateRow',{
		index: selectedrow,
		row: {TOweStatusdesc:'����ҩ'}
	});	
}
function CheckBeforeDoSth(){
	if (($('#owegrid').datagrid("getRows").length<=0)||($('#owedetailgrid').datagrid("getRows").length<=0)){
		$.messager.alert('��ʾ',"û������!","info");
		return false;
	}
	var selecteddata = $('#owegrid').datagrid('getSelected');
	if(selecteddata==null){
		$.messager.alert('��ʾ',"û��ѡ������!","info");
		return false;	
	}
	return true
}
//OweDispMonitor Ƿҩ����
function OweDispMonitor(oweselectdata,updflag){
	var selectedrow=$('#owegrid').datagrid("getRowIndex",oweselectdata);
	var prescno=oweselectdata["TPrescNo"];
	var owestat=oweselectdata["TOweStatusdesc"];
	var patname=oweselectdata["TPatName"];
	var warnmsgtitle="��������:"+patname+"\t"+"������:"+prescno+"\n"
	if ((owestat=="�ѷ�ҩ")||(owestat=="����ҩ")){
		$.messager.alert("��ʾ",warnmsgtitle+"�ü�¼"+owestat+"!","info");
		return;
	}
	var dispQtyString=""
	var updflag=""
	if (updflag==""){ //ȫ��ʱ�˱�־ΪU
		var owedetailgridrowsdata=$('#owedetailgrid').datagrid("getRows");
		var owedetailgridrows=owedetailgridrowsdata.length;
		if (owedetailgridrows<=0){
			$.messager.alert('��ʾ',"û����ϸ����!");
			return;
		}
		var chkflag=0,allowe=1
		var dispQtyString=0
		for(var rowi=0;rowi<owedetailgridrows;rowi++){
			var oeoriQty=owedetailgridrowsdata[rowi]["TPhQty"]
			var realQty=owedetailgridrowsdata[rowi]["TRealQty"]
			oeoriQty=$.trim(oeoriQty);
			realQty=$.trim(realQty);
			if(parseFloat(realQty)>parseFloat(oeoriQty)){
				$.messager.alert('��ʾ',"ʵ���������ܴ���ҽ������!");
				return;
			}
			if (parseFloat(realQty)<0){
				$.messager.alert('��ʾ',"ʵ����������С��0!");
				return;
			}
			if (parseFloat(realQty)!=parseFloat(oeoriQty)){
				chkflag="1";
			}
			if (allowe!=0) {allowe=0}
			var oeori=owedetailgridrowsdata[rowi]["TOrditm"]
			var unit=owedetailgridrowsdata[rowi]["TUnit"]
			var tmpdispstring=oeori+"^"+realQty+"^"+oeoriQty+"^"+unit
			if (dispQtyString==0){
				dispQtyString=tmpdispstring
			}
			else{
				dispQtyString=dispQtyString+"!!"+tmpdispstring
			}
			
		} 	
		dispQtyString=chkflag+"&&"+allowe+"&&"+dispQtyString ;
		var tmpordstr=dispQtyString.split("&&") 
		var chkord=tmpordstr[0] ;
		ChkAllOweFlag=tmpordstr[1] ;  //�Ƿ�ȫ��Ƿҩ
		ChkOweFlag=chkord;
		if (chkflag=="1"){
			if (confirm("�Ƿ���Ҫ����Ƿҩ��? ���[ȷ��]���ɡA���[ȡ��]�˳�")==false){
				return; 
			} 
		}			
	}
	var owedr=oweselectdata["TOwedr"];
	dispQtyString=dispQtyString+"&&"+owedr;
	var prt=oweselectdata["TPrt"];
	var gphl=gPhLocId;
	var gphw=""
	var gpydr=gPyUserId;
	var gfydr=gPyUserId;
	var prescno=oweselectdata["TPrescNo"];
	var gpos=""
	var newwin=""
	var shdr=""                                             
	var retval=tkMakeServerCall("web.DHCOutPhDisp","SAVEDATA",prt,gphl,gphw,gpydr,gfydr,prescno,gpos,shdr,newwin,dispQtyString)
	if (retval==-1){
		$.messager.alert("��ʾ",warnmsgtitle+"�ô���������,���ܷ�ҩ!","info");
		return;
	}else if (retval==-2){
		$.messager.alert("��ʾ",warnmsgtitle+"�ô���ҩƷ�ѷ�,�����ظ���ҩ","info");
		return;
	}else if (retval==-3){
		$.messager.alert("��ʾ",warnmsgtitle+"�ô���ҩƷ�ѷ�,�����ظ���ҩ","info");
		return;
	}else if (retval==-4){
		$.messager.alert("��ʾ",warnmsgtitle+"�ô���ҽ����ͣ,���ܷ�ҩ","info");
		return;
	}else if (retval==-7){
		$.messager.alert("��ʾ",warnmsgtitle+"��ҩʧ��ԭ��: ��治��,��˲�","info");
		return;
	}else if (retval==-9){
		$.messager.alert("��ʾ",warnmsgtitle+"�ò���Ѻ����,��˲�","info");
		return;
	}else if (retval==-24){
		$.messager.alert("��ʾ",warnmsgtitle+"��ҩʧ��ԭ��: ��治��,��˲�","info");
		return;
	}else if (retval==-111){
		$.messager.alert("��ʾ",warnmsgtitle+"�ô����ѱ��ܾ�,���ܷ�ҩ","info");
		return;
	}else if (retval==-5){
		$.messager.alert("��ʾ",warnmsgtitle+"��Ƿҩ��״̬�Ѵ���,�����ظ���ҩ!")
		return;
	}else if (retval==-27){
		$.messager.alert("��ʾ",warnmsgtitle+"��Ƿҩ��״̬�Ѵ���,�����ظ���ҩ!","info");
		return;
	}else if (retval<0){
		$.messager.alert("��ʾ",warnmsgtitle+"��ҩʧ��,�������: "+retval,"info");
		return;
	}else if (!(retval>0)){
		$.messager.alert("��ʾ",warnmsgtitle+"��ҩʧ��,�������: "+retval,"info");
		return;
	}
	$('#owegrid').datagrid('updateRow',{
		index: selectedrow,
		row: {TOweStatusdesc:'�ѷ�ҩ'}
	});
}

$(document).keydown(function(event){
 	if(event.keyCode==115){BtnReadCardHandler();return false;}	//F4,����  
 	if(event.keyCode==118){QueryOwe();return false;}	//F7,����  
 	if(event.keyCode==120){BtnTYHandler();return false;}	//F9,��ҩ 
 	if(event.keyCode==121){InitCondition();return false;}	//F10,��� 
 	if(event.keyCode==119){BtnFYHandler();return false;}	//F8,��ҩ  
}); 

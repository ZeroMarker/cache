/// Creator: lvpeng 
/// CreateDate: 2017-01-25

var createUser=""; //������ dws 2017-02-24

$(document).ready(function() {
	//��ʼ������
	initParam();
	
	//��ʼ������
	//initLayout();
	
	//��ʼ��ʱ��ؼ�
	initDate();
	
	//��ʼ��combo
	initCombo();
	
	//��ʼ��easyui datagrid
	initTable();
	
	//��ʼ���ؼ��󶨵��¼�
	initMethod();
	
	
});

//��ʼ������
function initParam(){
	//��;����ȡ��̨����
	$.ajax({
		url:LINK_CSP,
		data:{
			"ClassName":"web.DHCDISAffirmStatus",
	        "MethodName":"GetParamByInit"
		},
		type:'get',
		async:false,
		dataType:'json',
		success:function (data){
			Params = data;    
		}
		})
		
	rowData="";   //ѡ��������ȫ�ֱ���
}

//��ʼ��ʱ���
function initDate(){
	$('#StrDate').datebox("setValue",formatDate(0));
	$('#EndDate').datebox("setValue",formatDate(0));	
}

//��ʼ��datagrid
function initTable(){
	
	var columns = [[
		{
	        field: 'REQ',
	        align: 'center',
            //title: 'mainRowID',
            hidden: true,
            width: 100
	    },  {
	        field: 'REQTypeID',
	        align: 'center',
	        //hidden: true,
            title: '��������ID',
            hidden: true,
            width: 100
	    },{
	        field: 'REQEmFlag',
	        align: 'center',
            title: '�Ӽ���־',
            hidden: true,
            width: 70
	    },{
	        field: 'REQCurStatus',
	        align: 'center',
            title: '��ǰ״̬',
            width: 70
	    }, {
            field: 'REQConfirmUser',
            align: 'center',
            title: '����ȷ����',
            hidden: true,
            width: 50
        },{
            field: 'REQCreateDate',
            align: 'center',
            title: '��������',
            width: 80
        }, {
            field: 'REQCreateTime',
            align: 'center',
            title: '����ʱ��',
            width: 100
        }, {
            field: 'REQLoc',
            align: 'center',
            title: '�������',
            width: 80
        }, {
            field: 'REQNo',
            align: 'center',
            title: '��֤��',
            width: 100  
        }, {
            field: 'REQRecLoc',
            align: 'center',
            title: '���տ���',
            width: 160
        }, { 
            field: 'REQExeDate',
            align: 'center',
            title: '��������',
            width: 100 
        }, { 
            field: 'REQExeTime',
            align: 'center',
            title: '����ʱ��',
            width: 100 
        }, {
            field: 'REQRemarks',
            align: 'center',
            title: '��ע',
            width: 100
        }
        ]]
        
    var param=getParam(); //��ȡ����
    $('#cspAccompStatusTb').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISAccompStatus&MethodName=listGoodsRequest&param='+param,
	   	//formatShowingRows:function(pageFrom, pageTo, totalRows){
		   	//pageTo=0;
		   	//totalRows=0
		    //return "�� "+pageFrom+" ���� "+pageTo+" ����¼���� "+totalRows+" ����¼"
		    //return "�� 0���� 0 ����¼���� 0 ����¼"
		//},
	    fit:true,
	    rownumbers:true,
	    fitColumns:true,
	    columns:columns,
	    pageSize:20, // ÿҳ��ʾ�ļ�¼����
	    pageList:[20,40],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    onSelect:function(Index, row){
	        rowData= row;
	    },
	    onUnselect:function (Index, row){
			rowData= "";
		},
		onClickRow:function(Index, row){
			ClickRowDetail();
		}
	})
	$('#cspAccompStatusTb').datagrid({
		rowStyler:function(index,row){
				if(row.REQEmFlag=="Y"){
					return 'color:#EE2C2C'
				}
			}
		
	})
	
	var columnsdetail = [[
		{
	        field: 'ITM',
	        align: 'center',
	        title: '��Ŀ����',
	        width: 250	        
        },/* {
            field: 'RECLOC',
            align: 'center',
            title: 'ȥ��',
            width: 200
        }, */{
            field: 'QTY',
            align: 'center',
            title: '����',
            width: 200
        }
        ]]
		
	$('#cspAccompStatusCarefulTb').datagrid({
		columns:columnsdetail,
	    pageSize:20,
	    pageList:[20,40],
        singleSelect:true,
        loadMsg: '���ڼ�����Ϣ...',
	    pagination:true
    })
    
}

///������ѯ��ϸ
function ClickRowDetail(){
	var row =$("#cspAccompStatusTb").datagrid('getSelected');
	DisMainRowId=row.REQ; ///��id
	//alert(DisMainRowId)
	$('#cspAccompStatusCarefulTb').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISAccompStatus&MethodName=listGoodsRequestItm&req='+DisMainRowId
	});
	
	}

//��ʼ��combobox
function initCombo(){
	$('#ApplayLoc').combobox({
		//	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo",
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' 
	});
	
	$('#RecLoc').combobox({
		//	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo",
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' 
	});
	
	$('#AffirmStatus').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=StatusComboS&type="+1,// type 0: ���� ,1: ����
		valueField:'id',    
	    textField:'text' 
	});
}

function initMethod(){
	 //�س��¼�
     $('#RegNo').bind('keypress',RegNoBlur);
     $('#verifiBtn').bind('click',verifiDis); 		//��֤ȷ��
     $('#exeBtn').bind('click',exeDis);       		//����ȷ��
 	 $('#undoBtn').bind('click',Undorequest);      	//��������
 	 $('#printbarcode').bind('click',printbarcode); //��ӡ����
 	 $('#complete').bind('click',complete);			//���
 	 $('#GetGoods').bind('click',GetGoods);			//����
 	 $('#givenconfirm').keydown(function (e) {
     if (e.keyCode == 13) {
        afterconfirm();
     }
 	});
 	 
 	 
 	 $('#searchBtn').bind('click',search) //����	
 	 
 	 $("#appraiseBtn").on('click',function(){
	 	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	 	//dws 2017-02-24 ����Ȩ��
		if((($("#cspAccompStatusTb").datagrid('getSelected').REQCurStatus)=="��ǩ��")||(($("#cspAccompStatusTb").datagrid('getSelected').REQCurStatus)=="������")){
			runClassMethod("web.DHCDISAppraise","getAccPeo",{mainRowId:DisMainRowId},function(data){
				if(data==LgUserID){
					createUser=data;
					ScorePages(); //�����۽���
				}
				else{
					$.messager.alert("��ʾ","���뵥�����˲ſ�������!");
				}
			});
			
		}
		else{
			$.messager.alert("��ʾ","��ǩ�����뵥��������!");
		}
	 })
	 
	 $("#particulars").on('click',function(){
	 	ParticularsPages();   //����
	 })
	 
	 
	 $("#unfiniBtn").on('click',function(){
	 	UndonePages();   //δ���                  
	 })
}


/*======================================================*/

//�ǼǺŻس��¼�
function RegNoBlur(event){
    if(event.keyCode == "13")    
    {
        var i;
	    var Regno=$('#RegNo').val();
	    var oldLen=Regno.length;
	    if (oldLen>Params.regNoLen){
		    $.messager.alert("��ʾ","�ǼǺų�����������")
		    $('#RegNo').val("");
		    return;
		    }
		if (Regno!="") {  //add 0 before regno
		    for (i=0;i<Params.regNoLen-oldLen;i++)
		    //for (i=0;i<8-oldLen;i++)
		    {
		    	Regno="0"+Regno 
		    }
		}
	    $("#RegNo").val(Regno);
    }
};

//��ѯ
function search(){
	var Params=getParam(); //��ȡ����
	$('#cspAccompStatusTb').datagrid({
			queryParams:{param:Params}	
	})
	$('#cspAccompStatusCarefulTb').datagrid('loadData', {total:0,rows:[]})
}

//����ȷ��&����ȷ��
function verifiDis(){
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	createVertifyWin();
}
function createVertifyWin(){	
	if($('#confirmwin').is(":hidden")){
	   $('#confirmwin').window('open');
		return;
		}           ///���崦�ڴ�״̬,�˳�	
	var option = {
		closed:"true"
	};
	new WindowUX('����ȷ��', 'confirmwin', '300', '180', option).Init();
	
}

///����ȷ��
function afterconfirm()
{
	var StatusCode=13
	
	var EmFlag=rowData.REQEmFlag
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	var UserCode=$('#givenconfirm').val();
	if(UserCode!=LgUserCode)
	{
		$.messager.alert("��ʾ:","���Ŵ���!")
		$('#givenconfirm').val('');
		return;
	}
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":13,"lgUser":LgUserID,"EmFlag":EmFlag,"reason":""},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","ȷ�ϳɹ���");
			$('#confirmwin').window('close');
		}else{
			$.messager.alert('����',jsonString);
			return;
		}
	},'text');
	$('#cspAccompStatusTb').datagrid('reload');
	rowData="";
}

//ǩ��ȷ��
function exeDis(){
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	if((rowData.REQCurStatus!="���")){			//sufan 2018-03-22 ����ȷ�ϵ�ǰ״̬
			$.messager.alert("��ʾ","�����״̬�����벻����˲�����")
			return;	
		}
	var statuscode="" ;
	var EmFlag=rowData.REQEmFlag;
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	if(TypeID!="18")       //sufan 2018-03-22 �������ж�״̬����
	{
		statuscode="���ȷ��";
	}
	var datalist=ReqID+"#"+TypeID+"#"+statuscode+"#"+LgUserID+"#"+EmFlag;
	$.messager.confirm('����ȷ��','ȷ�Ͻ�������״̬��Ϊ���ȷ����',function(r){
		if (r){
			runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":statuscode,"lgUser":LgUserID,"EmFlag":EmFlag,"reason":""},
					function(data){
						if(data!=0){
							$.messager.alert("��ʾ",data);	
						}
						else{
							$.messager.alert("��ʾ","ǩ�ճɹ���");
						}
					},'text',false)
			$('#cspAccompStatusTb').datagrid('reload');
			rowData=""
		}	
	})
}

// ��������
function Undorequest(){
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
	}
	var ReqID=rowData.REQ
	var StatusCode=100
	var ReqType=rowData.REQTypeID
	var CurStatus=rowData.REQCurStatus;
	if((CurStatus!="������")&&(CurStatus!=("��������"))){
		$.messager.alert("��ʾ","������������ŵ����뵥�ſ��Գ�����");
		return;	
		}
	//var ss=ReqID+"^"+StatusCode+"^"+ReqType+"^"+LgUserID
	//alert(ss)
	$.messager.confirm('ȷ��','��ȷ��Ҫ�����������뵥��',function(r){
			if(r){
				runClassMethod("web.DHCDISRequestCom","CancelApplicaion",{'disreqID':ReqID,'statuscode':StatusCode,'type':ReqType,'lgUser':LgUserID},function(data){
					if(data!=0){
						$.messager.alert("��ʾ",data)
					}else{
						$.messager.alert("��ʾ","�����ɹ���")
					}
				},'text',false)
				$('#cspAccompStatusTb').datagrid('reload');
				rowData="";
			}	
	})
}


//���鵯����ҳ��
function ParticularsPages(mainRowID){
	if((rowData=="")){
		$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
		return;	
	}
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
		title:'����',
		border:true,
		closed:"true",
		width:800,
		height:400,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		onClose:function(){
			$('#win').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
			}
	}); 

	//iframe ����

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcdis.accompdetail.csp?mainRowID='+rowData.REQ+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}


//���ֵ��������
function ScorePages(){
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
			title:'����',
			border:true,
			closed:"true",
			width:600,
			height:420,
			collapsible:false,
			minimizable:false,
			maximizable:false,
			resizable:false,
			collapsible:true,
			draggable:false,
		onClose:function(){
			$('#win').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
			}
	}); 
	
	//iframe ����
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.disappraise.csp?mainRowID='+DisMainRowId+'&createUser='+createUser+'&type='+rowData.REQTypeID+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');	
}

//δ��ɽ��洰��
function UndonePages(){
	if((rowData=="")){
		$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
		return;	
	}
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
		title:'δ���',
		border:true,
		closed:"true",
		width:600,
		height:400,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		onClose:function(){
			$('#win').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
			}
	}); 

	//iframe ����
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcdis.failreason.csp"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');	
}

//Table�������
//return ����ʼʱ��^����ʱ��^����ID^���տ���^�������^״̬
function getParam(){
	var stDate = $('#StrDate').datebox('getValue');
	var endDate=$('#EndDate').datebox('getValue');
	var taskID= $('#TaskID').val();
	var regno = $('#RegNo').val();
	var recLoc = $('#RecLoc').combobox('getValue');
	if(recLoc==undefined){
		recLoc=""
	}
	var applayLocDr= $('#ApplayLoc').combobox('getValue');
	if(applayLocDr==undefined){
		applayLocDr=""		
	}
	var affirmStatus = $('#AffirmStatus').combobox('getValue');
	if(affirmStatus==undefined){
		affirmStatus=""		
	}
	return stDate+"^"+endDate+"^"+taskID+"^"+recLoc+"^"+applayLocDr+"^"+affirmStatus
}

function printbarcode()
{	
	if((rowData=="")){
		$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
		return;	
	}
	var ReqID=rowData.REQ;
		runClassMethod("web.DHCDISAccompStatus","PrintBarCode",{"ReqID":ReqID},function(data){
						if((data==-1)||(data==-2)||(data=="")){
							$.messager.alert("��ʾ:","��������!");
							return;
						}else {
								Print(data);
							}
					},'text',false)
}
///����
function Print(data){	
		       
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCDIS_PC"); 
	
	var MyPara="RegNo"+String.fromCharCode(2)+data;
	//var MyPara="RegNo"+String.fromCharCode(2)+ExaReqObj.PatNo;

	//var myobj=document.getElementById("ClsBillPrint");
	DHCSTPrintFun(MyPara,"")	
}

function complete()
{
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	var EmFlag=rowData.REQEmFlag;
	if(EmFlag=="Y")
	{
		$.messager.alert("��ʾ:","�Ӽ���������˲���!");
		return;
	}
	if(rowData.REQCurStatus!="�Ѱ���"){			//sufan 2018-03-22 ����ȷ�ϵ�ǰ״̬
		$.messager.alert("��ʾ:","���Ѱ���״̬������˲���!");
		return;
	}
	var statuscode=""
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	if(TypeID!="18")
	{
		statuscode="���"
	}
	var datastr=ReqID+"#"+TypeID+"#"+statuscode+"#"+LgUserID;
	//alert(datastr)
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":statuscode,"lgUser":LgUserID,"reason":""},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","����ɹ���");

		}else{
			$.messager.alert('����',jsonString);
			return;
		}
	},'text');
	$('#cspAccompStatusTb').datagrid('reload');
	rowData="";
				
}
function GetGoods()
{
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	var EmFlag=rowData.REQEmFlag;
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":14,"lgUser":LgUserID,"EmFlag":EmFlag,"reason":""},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","����ɹ���");

		}else{
			$.messager.alert('����',jsonString);
			return;
		}
	},'text');
	$('#cspAccompStatusTb').datagrid('reload');
	rowData="";
}

///��ӡ����
PrtAryData=new Array();
function DHCP_GetXMLConfig(encName,PFlag){
	////
	/////InvPrintEncrypt
	try{		
		PrtAryData.length=0
		runClassMethod("web.DHCXMLIO",
					   "ReadXML",
					   {'JSFunName':'DHCP_RecConStr',"CFlag":PFlag},
					    function(ret){ret},
					   "script",
					   false	
		)
		for (var i= 0; i<PrtAryData.length;i++){
			PrtAryData[i]=DHCP_TextEncoder(PrtAryData[i]) ;
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function DHCP_TextEncoder(transtr){
	if (transtr.length==0){
		return "";
	}
	var dst=transtr;
	try{
		dst = DHCWeb_replaceAll(dst, '\\"', '\"');
		dst = DHCWeb_replaceAll(dst, "\\r\\n", "\r\t");
		dst = DHCWeb_replaceAll(dst, "\\r", "\r");
		dst = DHCWeb_replaceAll(dst, "\\n", "\n");
		dst = DHCWeb_replaceAll(dst, "\\t", "\t");
	}catch(e){
		alert(e.message);
		return "";
	}
	return dst;
}

function DHCWeb_replaceAll(src,fnd,rep) 
{ 
	//rep:replace
	//src:source
	//fnd:find
	if (src.length==0) 
	{ 
		return ""; 
	} 
	try{
		var myary=src.split(fnd);
		var dst=myary.join(rep);
	}catch(e){
		alert(e.message);
		return ""
	}
	return dst; 
} 
function DHCP_RecConStr(ConStr){
	
	PrtAryData[PrtAryData.length]=ConStr;
	
}
//������ӡ����
function DHCSTPrintFun(inpara,inlist){
	
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
			
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false; 
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			var PObj=new ActiveXObject("DHCOPPrint.ClsBillPrint")
			alert(PObj)
			var rtn=PObj.ToPrintDoc(inpara,inlist,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}

}
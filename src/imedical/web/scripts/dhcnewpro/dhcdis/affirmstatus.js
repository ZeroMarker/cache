/// Creator: qiaoqingao&lvpeng
/// CreateDate: 2017-01-05

var createUser=""; //������ dws 2017-02-24
var varSelect=""   //����ԭ�� ylp

$(document).ready(function() {
	//��ʼ������
	initParam();
	
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
	        field: 'patname',
	        align: 'center',
            title: '����',
            width: 80
	    },
	    {
	        field: 'hosno',
	        align: 'center',
            title: 'סԺ��',
            width: 80
	    },
     	{
	        field: 'mainRowID',
	        align: 'center',
	        hidden: true,
            title: '���뵥ID',
            width: 80
	    },{
	        field: 'newStatus',
	        align: 'center',
            title: '��ǰ״̬',
            width: 80
	    },{
	        field: 'TypeID',
	        align: 'center',
	        hidden: true,
            title: '����ID',
            width: 80
	    },{
            field: 'applyDate',
            align: 'center',
            title: '��������',
            width: 100
        }, /* {
            field: 'applyTime',
            align: 'center',
            title: '����ʱ��',
            width: 80
        },  */ {
            field: 'currregNo',
            align: 'center',
            title: '�ǼǺ�',
            width: 100
        }, {
            field: 'bedNo',
            align: 'center',
            title: '����',
            width: 80
        }, {
            field: 'endemicArea',
            align: 'center',
            title: '����',
            width: 180
        }, {
            field: 'taskID',
            align: 'center',
            title: '��֤��',
            width: 80 
        },{
            field: 'acceptLoc',
            align: 'center',
            title: '���տ���',
            hidden: true,
            width: 100
        },{ 
            field: 'deliveryDate',
            align: 'center',
            title: '��������',
            width: 100 
        }, /* { 
            field: 'deliveryTime',
            align: 'center',
            title: '����ʱ��',
            width: 60 
        }, */ {
            field: 'deliveryWay',  
            align: 'center',
            title: '���ͷ�ʽ',
            width: 60
        }, {
            field: 'deliveryType',
            align: 'center',
            title: '��������',
            width: 60
        }, {
            field: 'remarkDesc',
            align: 'center',
            title: '��ע',
            width: 100
        }, 
        {
            field: 'dispeople',
            align: 'center',
            title: '������Ա',
            width: 100
        }, {
            field: 'nullFlag',
            align: 'center',
            title: '����',
            hidden: true,
            width: 60
        }
        ]]
        
    var param=getParam(); //��ȡ����
    $('#cspAffirmStatusTb').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisListOrd&param='+param,
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
	
	var columnsdetail = [[
		{
	        field: 'projectName',
	        align: 'center',
	        title: '��Ŀ����',
	        width: 250	        
        },{
            field: 'toBourn',
            align: 'center',
            title: 'ȥ��',
            width: 200
        }
        ]]
		
	$('#cspAffirmStatusCarefulTb').datagrid({
		columns:columnsdetail,
	    pageSize:20,
	    pageList:[20,40],
        singleSelect:true,
        loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    nowrap:false//�����Զ�����
    })
 
}

//��ѯ��ϸ
function ClickRowDetail(){
	var row =$("#cspAffirmStatusTb").datagrid('getSelected');
	DisMainRowId=row.mainRowID; //����id
	$('#cspAffirmStatusCarefulTb').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisListOrdDetail&DisMainRowId='+DisMainRowId
	});
	
	}

//��ʼ��combobox
function initCombo(){
	$('#ApplayLoc').combobox({
		//url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo",
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' 
	});
	
	$('#AffirmStatus').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=StatusCombo&type="+0,// type 0: ���� ,1: ����
		valueField:'id',
	    textField:'text'
	});
}

// ��ʼ��ť�󶨷���
function initMethod(){
	 //�س��¼�
     $('#RegNo').bind('keypress',RegNoBlur);
     //$('#verifiBtn').bind('click',verifiDis); //��֤ȷ��
     $('#exeBtn').bind('click',DisAffirm);       //����ȷ��
     $("#undoBtn").bind('click',Undorequest)	//��������
 	 $('#searchBtn').bind('click',search) //����
 	 $('#nullflagBtn').bind('click',SetNullFlag) //���ÿ��˱�ʶ
 	 $('#requestCopy').bind('click',RequestCopy) //������������
 	 $('#recieve').bind('click',Recieve)  
 	 $('#complete').bind('click',complete)
 	 $('#confirm').keydown(function (e) {
     if (e.keyCode == 13) {
        afterconfirm();
     }
 	 })
 	 
 	 $("#appraiseBtn").on('click',function(){
		if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	/*  if(($("#cspAffirmStatusTb").datagrid('getSelected').newStatus)=="������"){
		$.messager.alert("��ʾ","�ö��������ۣ�")
			return;
		} 
		*/
		//dws 2017-02-24 ����Ȩ��
		if((($("#cspAffirmStatusTb").datagrid('getSelected').newStatus)=="���ȷ��")||(($("#cspAffirmStatusTb").datagrid('getSelected').newStatus)=="������")||(($("#cspAffirmStatusTb").datagrid('getSelected').newStatus)=="����")){
			/*runClassMethod("web.DHCDISAppraise","getAffPeo",{mainRowId:DisMainRowId},function(data){
				if(data==LgUserID){
					createUser=data;
					appraise(); //�����۽���
				}
				else{
					$.messager.alert("��ʾ","���뵥�����˲ſ�������!");
				}
			});*/
			appraise(); //�����۽���
		}
		else{
			$.messager.alert("��ʾ","�����ȷ�����뵥��������!");
		}
	 })
	 
	 $("#detailsbtn").on('click',function(){
	 	ParticularsPages();   //����
	 })

	 $("#unfiniBtn").on('click',function(){
	 	unfinished();   //δ���                  
	 })
}


/*======================================================*/

//�ǼǺŻس��¼�
function RegNoBlur(event)
{
    if(event.keyCode == "13")    
    {
        var i;
	    var Regno=$('#RegNo').val();
	    var oldLen=Regno.length;
	    if (oldLen>Params.regNoLen){
		    $.messager.alert("��ʾ","�ǼǺų�����������");
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
}


//���ÿ��˱�ʶ
function SetNullFlag()
{
	if((rowData=="")){
		$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
		return;	
	}
	var data=$("#cspAffirmStatusTb").datagrid('getSelected')
	if((data.newStatus=="������")){
		$.messager.alert("��ʾ","���뵥�����ۣ��޷�������");
		return;	
	}
	if((data.newStatus=="����")){
		$.messager.alert("��ʾ","�������ظ��ÿ��ˣ�");
		return;	
	}
	if((data.newStatus=="������")||(data.newStatus=="")){
		$.messager.alert("��ʾ","���뵥δ���ܣ��޷��ÿ��ˣ�");
		return;	
	}
	var mainRowID=$("#cspAffirmStatusTb").datagrid('getSelected').mainRowID
	var varSelect=""      //����ԭ��


	$('#NullReason').window({
		title:'����ԭ��',
		collapsible:false,
		border:false,
		closed:false,
		width:300,
		height:200
	});
	
	$('#NullReason').window('open');
	$('#FailReason').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISAffirmStatus&MethodName=getFailReason',
		required : true,
	    idField:'id',
	    fitColumns:true,
	    fit: true,//�Զ���С  
		panelWidth:150,
		panelHeight:150,
		textField:'name',
		mode:'remote',
		valueField:'value',											
		textField:'text',
		onSelect:function(){
		varSelect = $(this).combobox('getValue');
		
		}
	});
	
	
}
// yuliping  ������дԭ��
function nullconfirm(){
	var reason=$('#FailReason').combobox('getValue')
	var mainID = rowData.mainRowID
	var TypeID = rowData.TypeID
	var ReqNo=rowData.taskID
	
	if(reason!=""){
		$.messager.confirm('ȷ�Ͽ���','ȷ�Ͻ�������״̬��Ϊ������',function(r){
			if (r){
				runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":mainID,"type":TypeID,"statuscode":19,"lgUser":LgUserID,"EmFlag":"Y","reason":reason},
						function(data){
							if(data!=0){
								
								$.messager.alert("��ʾ",data);	
							}
							else{
								
								runClassMethod("web.DHCDISAffirmStatus","SetNullFlag",{param:ReqNo},function(data){
										if(data==0){
											$.messager.alert("��ʾ","�ɹ�!");
											$('#NullReason').window('close');
											$('#cspAffirmStatusTb').datagrid('reload')
										}
										else{
											$.messager.alert("��ʾ","ʧ��!");
										}
										//$('#cspAffirmStatusCarefulTb').datagrid('loadData', {total:0,rows:[]})
										
									});
							
							}
							
						},'text',false)
			$('#cspAffirmStatusTb').datagrid('reload');
			rowData="";
			}		
		})
				
	}
	
}

///������������
function RequestCopy()
{
	if((rowData=="")){
		$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
		return;	
	}

	$('#copyTime').window({
		title:'ʱ��',
		collapsible:false,
		border:false,
		closed:false,
		width:500,
		height:260
	});
			
	$('#copyTime').window('open');
	InitCopyCombobox();  //��ʼ��combobox
	GetReqMessage(rowData); //��ȡ���뵥��Ϣ
}
///��ʼ��combobox
function InitCopyCombobox()
{
	$('#CopyRecLoc').combobox({ //���տ���    
	    //url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp,
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote'     
	});
	$('#CopyReqType').combobox({ //��������   
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTypeList",    
	    valueField:'id',    
	    textField:'text'   
	});  
	$('#CopyReqWay').combobox({ //���ͷ�ʽ 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisToolList",    
	    valueField:'id',    
	    textField:'text'   
	});
	$('#CopyTime').combobox({ //����ʱ�� 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=IntTime",    
	    valueField:'id',    
	    textField:'text',  
	});
	$('#CopyTimePart').combobox({ //����ʱ��� 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTimePart",    
	    valueField:'id',    
	    textField:'text',
	    panelHeight:'auto'
	});
}
///��ȡ���뵥��Ϣ  2017-06-02  zwq
function GetReqMessage(rowData)
{
	var ReqID=rowData.mainRowID;
	runClassMethod("web.DHCDISAffirmStatus","GetReqMessage",{'ReqID':ReqID},function(data){
				SetComboboxValue(data);
			},'text');
	
}
///��combobox����ԭ���뵥Ĭ��ֵ
function SetComboboxValue(ReqMessage)
{
	var CopyReqRecLocdr=ReqMessage.split("^")[0];
	var CopyReqWay=ReqMessage.split("^")[1];
	var CopyReqType=ReqMessage.split("^")[2];
	var CopyReqMark=ReqMessage.split("^")[3];
	if(CopyReqRecLocdr=="")
	{
		$('#CopyRecLoc').combobox({disabled:true});
	}
	else
	{
		$('#CopyRecLoc').combobox('setValue',CopyReqRecLocdr);
	}
	$('#CopyReqWay').combobox('setValue',CopyReqWay);
	$('#CopyReqType').combobox('setValue',CopyReqType);
	$('#CopyNote').combobox('setValue',CopyReqMark);
}
///ȷ�ϸ�����������
function SureRequestCopy(){
	var ReqID=rowData.mainRowID
	var ReqRecLoc=rowData.acceptLoc
	var CopyReqRecLoc=$('#CopyRecLoc').combobox('getValue');//���տ���
	var CopyReqDate=$('#CopyStartDate').combobox('getValue'); //��������
	var CopyReqWay=$('#CopyReqWay').combobox('getValue');
	var CopyReqTimePoint=$('#CopyTimePart').combobox('getText');
	var CopyReqType=$('#CopyReqType').combobox('getValue');
	var CopyReqTime=$('#CopyTime').combobox('getText')
	var CopyReqNote=$('#CopyNote').val()
	var CopyNum=1
	CopyDate=CopyReqDate+" "+CopyReqTime+" "+CopyReqTimePoint;
	if(CopyReqDate=="")
	{
		$.messager.alert("��ʾ:","��ѡ������ʱ��!");
		return;
	}
	if(CopyReqWay=="")
	{
		$.messager.alert("��ʾ:","��ѡ�����ͷ�ʽ!");
		return;
	}
	if(CopyReqType=="")
	{
		$.messager.alert("��ʾ:","��ѡ����������!");
		return;
	}
	if(CopyReqTimePoint=="")
	{
		$.messager.alert("��ʾ:","��ѡ������ʱ���!");
		return;
	}
	if((ReqRecLoc!="")&&(CopyReqRecLoc==""))
	{
		$.messager.alert("��ʾ:","��ѡ����տ���!");
		return;
	}
	var CopyStr=CopyReqRecLoc+"^"+CopyDate+"^"+CopyReqType+"^"+CopyReqWay+"^"+CopyNum+"^"+CopyReqNote+"^"+locId+"^"+LgUserID
	runClassMethod("web.DHCDISAffirmStatus","RequestCopy",{'reqID':ReqID,'copyStr':CopyStr},function(data){
				if(data==0){
					$.messager.alert("��ʾ","���Ƴɹ�!");
					$('#copyTime').window('close');
				}
				else{
					$.messager.alert("��ʾ","����ʧ��!");
				}
				$('#cspAffirmStatusTb').datagrid('reload')
			});
			rowData=="";
		
}
///���ȡ��,�رո��ƴ���
function CancleRequestCopy()
{
	$('#copyTime').window('close');
}
//��ѯ
function search(){
	//$('#cspAffirmStatusTb').datagrid('loadData', {total:0,rows:[]}); 
	var Params=getParam(); //��ȡ����
	//$('#cspAffirmStatusTb').datagrid('reload',{params:Params})
	$('#cspAffirmStatusTb').datagrid({
			queryParams:{param:Params}	
	})
	$('#cspAffirmStatusCarefulTb').datagrid('loadData', {total:0,rows:[]})
	
}	
//��֤ȷ��
function verifiDis()
{
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

///��������ȷ�ϴ���
function afterconfirm()
{
	var StatusCode=13
	var ReqID=rowData.mainRowID;
	var TypeID=rowData.TypeID
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":13,"lgUser":LgUserID,"EmFlag":"Y","reason":""},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","ȷ�ϳɹ���");
			$('#confirmwin').window('close');
		}else{
			$.messager.alert('����',jsonString);
			return;
		}
	},'text');
	$('#cspAffirmStatusTb').datagrid('reload');
	rowData="";
}
//  **********************************************
function DisAffirm()
{
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	var CurrentStatus=rowData.newStatus
	if(CurrentStatus!="�Ѱ���")
	{
		$.messager.alert("��ʾ:","��ǰ״̬������˲���!");
		return;
	}
	DisAffirmWindow();
}
function DisAffirmWindow()
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
			title:'����',
			border:true,
			closed:"true",
			width:600,
			height:450,
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
	var iframe='<iframe id="ifraemApp" scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.disaffirm.csp?mainRowID='+DisMainRowId+'&createUser='+LgUserID+'&type='+rowData.TypeID+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}
//����ȷ��
function exeDis(){
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	var mainID = rowData.mainRowID
	var TypeID = rowData.TypeID
	$.messager.confirm('����ȷ��','ȷ�Ͻ�������״̬��Ϊ���ȷ����',function(r){
		if (r){
			runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":mainID,"type":TypeID,"statuscode":16,"lgUser":LgUserID,"EmFlag":"Y","reason":""},
					function(data){
						if(data!=0){
							$.messager.alert("��ʾ",data);	
						}
						else{
							$.messager.alert("��ʾ","�����ɹ���");
						}
						
					},'text',false)
			$('#cspAffirmStatusTb').datagrid('reload');
			rowData="";
		}		
	})
}

// ��������
function Undorequest(){
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
	}
	var ReqID=rowData.mainRowID
	var StatusCode=100
	var ReqType=rowData.TypeID
	var CurStatus=$("#cspAffirmStatusTb").datagrid('getSelected').newStatus;
	if((CurStatus!="������")&&(CurStatus!=("��������"))){
		$.messager.alert("��ʾ","������������ŵ����뵥�ſ��Գ�����");
		return;	
		}
	//var ss=ReqID+"^"+StatusCode+"^"+ReqType+"^"+LgUserID
	//alert(ss)
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ��������¼��',function(r){
			if(r){
				runClassMethod("web.DHCDISAffirmStatus","CancelApplicaion",{'disreqID':ReqID,'statuscode':StatusCode,'type':ReqType,'lgUser':LgUserID},function(data){
					if(data!=0){
						$.messager.alert("��ʾ",data)
					}else{
						$.messager.alert("��ʾ","�����ɹ���")
					}
				},'text',false)
				$('#cspAffirmStatusTb').datagrid('reload');
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
	if($('#detailswin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="detailswin"></div>');

	$('#detailswin').window({
		title:'����',
		border:true,
		closed:"true",
		width:800,
		height:400,
		collapsible:true,
		minimizable:false,
		maximizable:false,
		resizable:false,
		//draggable:false,
		onClose:function(){
			$('#detailswin').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
			}
	}); 

	//iframe ����
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.affirmdetail.csp?mainRowID='+rowData.mainRowID+'&typeID='+rowData.TypeID+'"></iframe>';
	$('#detailswin').html(iframe);
	$('#detailswin').window('open');
}


//���۵�������� dws 2017-2-21 �޸�
function appraise(){
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
			title:'����',
			border:true,
			closed:"true",
			width:600,
			height:350,
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
	var iframe='<iframe id="ifraemApp" scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.disappraise.csp?mainRowID='+DisMainRowId+'&createUser='+LgUserID+'&type='+rowData.TypeID+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}


//δ��ɽ��洰��
function unfinished(){
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
		resizable:false,
		draggable:false,
		onClose:function(){
			$('#win').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
			}
	}); 

	//iframe ����
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.failreason.csp"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');	
}

//Table�������
//return ����ʼʱ��^����ʱ��^����ID^�ǼǺ�^�������^״̬
function getParam(){
	var stDate = $('#StrDate').datebox('getValue');
	var endDate=$('#EndDate').datebox('getValue');
	var taskID= $('#TaskID').val();
	var regno = $('#RegNo').val();
	var applayLocDr= $('#ApplayLoc').combobox('getValue');
	var DisHosNo = $('#HosNo').val();
	if(applayLocDr==undefined){
		applayLocDr=""		
	}
	var affirmStatus = $('#AffirmStatus').combobox('getValue');
	if(affirmStatus==undefined){
		affirmStatus=""		
	}
	return stDate+"^"+endDate+"^"+taskID+"^"+regno+"^"+applayLocDr+"^"+affirmStatus+"^"+DisHosNo;
}
function Recieve()
{
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	var ReqID=rowData.mainRowID;
	var TypeID = rowData.TypeID
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":14,"lgUser":LgUserID,"EmFlag":"Y","reason":""},
					function(data){
						if(data!=0){
							$.messager.alert("��ʾ",data);	
						}
						else{
							$.messager.alert("��ʾ","�����ɹ���");
						}
						
					},'text',false)
	$('#cspAffirmStatusTb').datagrid('reload');
	rowData="";
}
function complete()
{
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	var ReqID=rowData.mainRowID;
	var TypeID = rowData.TypeID
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":15,"lgUser":LgUserID,"EmFlag":"Y","reason":""},
					function(data){
						if(data!=0){
							$.messager.alert("��ʾ",data);	
						}
						else{
							$.messager.alert("��ʾ","�����ɹ���");
						}
						
					},'text',false)
	$('#cspAffirmStatusTb').datagrid('reload');
	rowData="";
}
///  Ч��ʱ����¼�����ݺϷ��� add 2016-09-23
function CheckDHCCTime(id){
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	
	if (InTime.length < 4){InTime = "0" + InTime;}
	if (InTime.length != 4){
		dhccBox.alert("��¼����ȷ��ʱ���ʽ������:18:23,��¼��1823","register-three");
		return $('#'+ id).val();
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		//dhccBox.alert("�ҵ�message","classname");
		dhccBox.alert("Сʱ�����ܴ���23��","register-one");
		return $('#'+ id).val();
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		dhccBox.alert("���������ܴ���59��","register-one");
		return $('#'+ id).val();
	}	
	return hour +":"+ itme;
}

/// ��ȡ�����ʱ�������� add 2016-09-23
function SetDHCCTime(id){
		
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	InTime = InTime.replace(":","");
	return InTime;
}
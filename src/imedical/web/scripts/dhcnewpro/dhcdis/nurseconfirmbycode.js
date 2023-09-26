/**	��������ȷ�Ͻ���
  * �������� sufan 2018-05-11
  * ԭ���밲�Ž���
  * ���Ϊ��������ȷ����ɺ���ɽ���
**/
var pid="1";
$(document).ready(function() {
		
	initArrgrid();			 //��ʼ��ȷ���б�
 	initsubgrid();
 	$("#discode").focus();  //���ý���
 	
   	//��Ʒ��س��¼�
	$('#discode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			SaveBarCode();
			QueryDisList();	 
		}     
	});
	
	//���Żس��¼�
	$('#usercode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			ExecuteSure();
		}    		 
	});
	
	$("#compty").on('click',EmptyCode);
	$("#confirm").on('click',ExecuteSure);
	$("#exeuser").val(LgUserName) 	
});

//��ʼ��ȷ�������б�
function initArrgrid()
{
 	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
    $('#disItemList').datagrid({
		    url:LINK_CSP+'?ClassName=web.DHCDISGoodsRequest&MethodName=getDisLabel',
		    fit:true,
		    fitColumns:true,
		    rownumbers:true,
		    columns:[[
		    {
		        field: 'REQ',
		        hidden:true
		    },
		    {
		        field: 'REQNo',
		        align: 'center',
		        title: '��֤��',
		        hidden: true,
		        width:100
		    },
		 	{
		        field: 'REQCurStatus',
		        align: 'center',
		        title: '��ǰ״̬',
		        width:100
		    },{
		        field: 'TypeID',
		        align: 'center',
		        title: '������������ID',
		        hidden:true,
		        width:100
		    },{
		        field: 'REQEmFlag',
		        align: 'center',
		        title: '�Ӽ���־',
		        hidden:true,
		        width:100
		    }, {
		        field: 'REQLoc',
		        align: 'center',
		        title: '�������',
		        width:130
		    }, {
		        field: 'REQRecLoc',
		        align: 'center',
		        title: '���տ���',
		        width:130
		    }, {
		        field: 'OpUserName',
		        align: 'center',
		        title: 'ȷ����Ա',
		        width:100
		    },{ 
		        field: 'ExeDate',
		        align: 'center',
		        title: 'ȷ������',
		        width:100
		    }, { 
		        field: 'ExeTime',
		        align: 'center',
		        title: 'ȷ��ʱ��',
		        width:100
		    },
		    {
		        field: 'REQPeople',
		        align: 'center',
		        title: '������Ա',
		        width:100
		    }, { 
		        field: 'REQExeDate',
		        align: 'center',
		        title: '��������',
		        width:100
		    }, { 
		        field: 'REQExeTime',
		        align: 'center',
		        title: '����ʱ��',
		        width:100
		    }, {
		        field: 'REQPeopleDr',
		        align: 'center',
		        title: '������ԱID',
		        hidden:true,
		        width:200,
		        editor:textEditor
		    },{
		        field:'Phone',title:'�����绰',
		    	width:120,
		    	hidden:false,
		    	styler:function(value,row){
				if(row.REQCurStatus=="������")
					{return 'color:#0000CD'}
		    	}
		    },{
		        field: 'REQCreateDate',
		        align: 'center',
		        title: '��������',
		        width:100
		    }, {
		        field: 'REQCreateTime',
		        align: 'center',
		        title: '����ʱ��',
		        width:100
		    }, {
		        field: 'REQRemarks',
		        align: 'center',
		        title: '��ע',
		        width:100
		    }
	    ]],
	    
	    pageSize:20, // ÿҳ��ʾ�ļ�¼����
	    pageList:[20,40],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
		onClickRow:function(Index, row){
			ClickRowDetail(row)
		}
	})
}
///��ʼ����ϸ�б�
function initsubgrid()
{
	$('#subTable').datagrid({
		fit:true,
		columns:[[
		{
	        field: 'REQI',
	        hidden:true	        
        },
		{
	        field: 'USERID',
	        hidden:true	        
        },
		{
	        field: 'ITM',
	        align: 'center',
	        title: '��Ŀ����',
	        width: 200	        
        },{
            field: 'RECLOC',
            align: 'center',
            title: 'ȥ��',
            hidden:true,
            width: 200
        }
        ,{
            field: 'QTY',
            align: 'center',
            title: '����',
            width: 200
        }]],
	    pageSize:20,
	    pageList:[20,40],
        singleSelect:true,
        loadMsg: '���ڼ�����Ϣ...',
	    pagination:true
    })
}

//��ѯ��ϸ
function ClickRowDetail(row){
	$('#subTable').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISGoodsRequest&MethodName=listGoodsRequestItm&req='+row.REQ
	});	
}
///���������ѯ�����б�
function QueryDisList()
{
	var ReqDisCode=$.trim($("#discode").val());
	if (ReqDisCode!=""){
		var retValue=tkMakeServerCall("web.DHCDISGoodsRequest","CheckReqBarCode",ReqDisCode);
		if(retValue==-1){
			$.messager.alert("��ʾ","������Ʒ��Ϊ��,���ʵ!");
			$("#discode").focus();
			return false;
		}
		if(retValue==-2){
			$.messager.alert("��ʾ","������Ʒ�����,���ʵ!");
			killTmpGlobal();
			$("#discode").val("");
			$("#discode").focus();
			return false;
		}else if(retValue==-3){
			$.messager.alert("��ʾ","����δǩ��,���ʵ!");
			killTmpGlobal();
			$("#discode").val("");
			$("#discode").focus();
			return false;
		}else if(retValue==-4){
			$.messager.alert("��ʾ","�˰�����ȷ��,���ʵ!");
			killTmpGlobal();
			$("#discode").val("");
			$("#discode").focus();
			return false;
		}else if(retValue==-5){
			$.messager.alert("��ʾ","δ�ҵ�������Ϣ,���ʵ!");
			killTmpGlobal();
			$("#discode").val("");
			$("#discode").focus();
			return false;
		}else{
			var params=ReqDisCode;
			$('#disItemList').datagrid('load',{params:params});  
			$("#discode").val("");
			//$("#usercode").focus();         
		}			
		
	}
	else{
		$.messager.alert("��ʾ","������Ʒ��Ϊ��,���ʵ!"); 
	}
	$('#disItemList').datagrid('load',{params:ReqDisCode}); 
}

///sufan 2018-05-11 ��������ȷ��
function ExecuteSure()
{
	var userLoginID=$.trim($("#usercode").val());
	var userId="",userName=""
	if (userLoginID!="")
	{
		var retValue=tkMakeServerCall("web.DHCDISGoodsRequest","getExeUser",userLoginID);
		if(retValue=="-1")
		{
			$.messager.alert("��ʾ","���ƴ���,���ʵ��")
			return;
		}
		userId=retValue.split("^")[0];
		userName=retValue.split("^")[1];
		$("#exeuser").val("")
		$("#exeuser").val(userName)
	}else{
		$.messager.alert("��ʾ","��ɨ�蹤�ƣ�")
		return;
	}
	var rowsData = $("#disItemList").datagrid("getRows");
	if((rowsData.length<=0)){
		$.messager.alert("��ʾ","����ɨ����Ʒ�룡")
		$("#usercode").val(""); 
		$("#usercode").focus();  //���ý���
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].REQCurStatus=="ȷ�����"){
			return false;
		}	
		if ((rowsData[i].REQPeopleDr=="")||(rowsData[i].REQPeople=="")){
			$.messager.alert("��ʾ","��"+i-1+"��������Ա����Ϊ�գ�"); 
			return false;
		} 
		var ReqID = rowsData[i].REQ;					//����Id
		var TypeID = rowsData[i].TypeID;				//��������
		if(TypeID!="18")
		{ 	
		
			if(rowsData[i].tmpRecLoc== LgCtLocID){
				statuscode="104";
			}else{
				statuscode="104";
				}							//״̬����
		}
		var EmFlag = rowsData[i].REQEmFlag;				//�Ƿ�Ӽ�
		var Relation = ""
		var LocaFlag = ""
		var DisUserId = rowsData[i].REQPeopleDr;		//����Id
			
		var tmp=ReqID +"^"+ TypeID +"^"+ statuscode +"^"+ userId +"^"+ EmFlag +"^"+ "" +"^"+ Relation +"^"+ LocaFlag +"^"+ DisUserId ;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	runClassMethod("web.DHCDISGoodsRequest","DisTaskConfirm",{"ListData":params},function(jsonString){
		if (jsonString==0){
			//$.messager.alert("��ʾ","����ɹ���");
			killTmpGlobal();
			$("#usercode").val(""); 
			$("#discode").focus();  //���ý���
		}else{
			$.messager.alert('����',jsonString);
			return;
		}
	},'text');
	$('#disItemList').datagrid('reload');
	
}
///���code
function EmptyCode()
{
	$("#discode").val("");
	$("#usercode").val("");
	$("#disItemList").datagrid('loadData',{total:0,rows:[]});
	$("#subTable").datagrid('loadData',{total:0,rows:[]});
	$("#discode").focus();  //���ý���
}
function SaveBarCode()
{
	var BarCode=$("#discode").val();
	runClassMethod("web.DHCDISGoodsRequest","SaveBarCode",{"pid":pid,"BarCode":BarCode},function(jsonString){
	},'text');
}

function killTmpGlobal()
{
	runClassMethod("web.DHCDISGoodsRequest","killTmpGlobal",{},function(jsonString){
	},'',false)
}
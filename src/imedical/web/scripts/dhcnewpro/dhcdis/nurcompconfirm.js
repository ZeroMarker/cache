/// Descript: ���͹��������
/// Creator : sufan
/// Date    : 2017-02-22
var editRow = ""; var AdmNo = "";
/// ҳ���ʼ������
function initPageDefault(){
	
	initButton();          ///  ҳ��Button���¼�	
	initItmlist();       	/// ��ʼҳ��DataGrid�������
	
}
///������ 
function initItmlist(){
	
	
	var columns = [[
		
		{
	        field: 'ck',
	        checkbox:'true',
            
	    },{
	        field: 'patname',
	        //align: 'center',
            title: '����'
	    },
	    {
	        field: 'hosno',
	        //align: 'center',
            title: 'סԺ��'
	    },
     	{
	        field: 'mainRowID',
	        //align: 'center',
	        hidden: true,
            title: '���뵥ID'
	    },{
	        field: 'newStatus',
	        //align: 'center',
            title: '��ǰ״̬'
	    },{
	        field: 'TypeID',
	        //align: 'center',
	        hidden: true,
            title: '����ID'
	    },{
            field: 'applyDate',
            //align: 'center',
            title: '��������'
        }, /* {
            field: 'applyTime',
            align: 'center',
            title: '����ʱ��',
            width: 80
        },  */ {
            field: 'currregNo',
            //align: 'center',
            title: '�ǼǺ�'
        }, {
            field: 'bedNo',
            //align: 'center',
            title: '����'
        }, {
            field: 'endemicArea',
            //align: 'center',
            title: '����'
        }, {
            field: 'taskID',
            //align: 'center',
            title: '��֤��',
            hidden: 'true'
        },{
            field: 'acceptLoc',
            //align: 'center',
            title: '���տ���',
            hidden: true
        },{ 
            field: 'deliveryDate',
            //align: 'center',
            title: '��������'
        }, /* { 
            field: 'deliveryTime',
            align: 'center',
            title: '����ʱ��',
            width: 60 
        }, */ {
            field: 'deliveryWay',  
            //align: 'center',
            title: '���ͷ�ʽ'
        }, {
            field: 'deliveryType',
            //align: 'center',
            title: '��������'
        }, {
            field: 'remarkDesc',
            //align: 'center',
            title: '��ע'
        }, 
        {
            field: 'dispeople',
            //align: 'center',
            title: '������Ա'
        }, {
            field: 'nullFlag',
            //align: 'center',
            title: '����',
            hidden: true
        },{
            field: 'ConfirDate',
            //align: 'center',
            title: 'ȷ������',
            hidden: false
        },{
            field: 'ConfirUser',
            //align: 'center',
            title: 'ȷ����Ա',
            hidden: false
        }, {
            field: 'AssNumber',
            //align: 'center',
            title: '����',
        }, {
            field: 'AssRemarks',
            //align: 'center',
            title: '����',
           
        }
        ]]
    var param=getinParam(); //��ȡ����
	///  ����datagrid  
	var option = {
	    	rownumbers:true,
	    	//fitColumns:true,
	    	columns:columns,
	   		pageSize:50,
	    	pageList:[50],
	    	//singleSelect:true,
	    	loadMsg: '���ڼ�����Ϣ...',
	   	 	pagination:true,
			onClickRow:function(Index, row){
			//ClickRowDetail();
			},
			onLoadSuccess: function (data) {
      			$('#reqdislist').datagrid('clearSelections');
			}
	};
	var uniturl = $URL+'?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisListOrdEscort&param='+param+'&PatLoc='+""+'&AdmNo='+""+'&HospID='+LgHospID;
	new ListComponent('reqdislist', columns, uniturl, option).Init(); 
	
}
/// ҳ�� Button ���¼�
function initButton(){
	
	$('#StrDateS').datebox("setValue",formatDate(0));
	$('#EndDateS').datebox("setValue",formatDate(0));
	$('#AffirmStatusS').combobox({
		url:$URL+"?ClassName=web.DHCDISCommonDS&MethodName=StatusCombo&type="+0,// type 0: ���� ,1: ����
		valueField:'id',
	    textField:'text',
	    mode:'remote'
	});
	runClassMethod("web.DHCDISRequest","getStatusValue",{'code':11},function(data){
		$('#AffirmStatusS').combobox("setValue",data);
	},'text',false)
	///��ʼ��������Ա������
	$('#Escortper').combobox({
		url:$URL+"?ClassName=web.DHCDISEscortArrage&MethodName=GetSSUser",
		valueField:'value',
	    textField:'text',
	    mode:'remote'
	});
    ///  ���Ӽ�����
	$('#Complete').bind("click",Complete);
	$('#searchBtn').bind('click',search) 			//����
	
}
//��ѯ
function search(){
	
	var Params=getinParam(); //��ȡ����
	$('#reqdislist').datagrid('load',{param:Params,PatLoc:"",AdmNo:"",HospID:LgHospID}); 
	
}
function getinParam(){
	var stDate = $('#StrDateS').datebox('getValue');
	var endDate=$('#EndDateS').datebox('getValue');
	var affirmStatus = $('#AffirmStatusS').combobox('getValue');
	if(affirmStatus==undefined){
		affirmStatus=""		
	}
	var Escortper = $("#Escortper").combobox('getValue');
	if(Escortper==undefined){
		Escortper=""		
	}
	return stDate+"^"+endDate+"^"+""+"^"+""+"^"+""+"^"+affirmStatus+"^"+""+"^"+Escortper;
}
///sufan 2017-12-20
///PC�˴����Ѱ��ŵ���������    
function Complete()
{
	var statuText=$("#AffirmStatusS").combobox("getText")
	if(statuText!="�Ѱ���")
	{
		$.messager.alert("��ʾ","����ݲ�ѯ�������Ѱ��š���ѯ���Ѱ��ŵ����룬��ȷ����ɣ�")
		return;	
	}
	var selItems = $('#reqdislist').datagrid('getSelections');  /// sufan 2017-12-15 �޸�����ȷ��
	if(selItems.length==0){
		$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
		return;	
	}
	
	var ReqIDArr= new Array();
	var ReqTypeArr= new Array();
	var count=0
	for(i = 0;i < selItems.length; i++)
	{
		var ReqID = selItems[i].mainRowID ;
		var ReqType = selItems[i].TypeID ;
		var newStatus = selItems[i].newStatus;
		if(newStatus.indexOf("����")<0){continue;}
		count=count+1
		ReqIDArr.push(ReqID);
		ReqTypeArr.push(ReqType);
	}
	if(count==0){
		$.messager.alert("��ʾ","�������Ѱ���״̬�����룡")
		return;	
	}
	updEscAppCompletstaArray(ReqIDArr.toString(),ReqTypeArr.toString());
}

///���������������״̬
function updEscAppCompletstaArray(reqIDStr,reqTypeStr){

	var statusCode=12;
	runClassMethod("web.DHCDISAffirmStatus","CancelApplicaionArray",{'ReqIDStr':reqIDStr,'ReqTypeStr':reqTypeStr,'StatusCode':statusCode,'LgUser':LgUserID},function(data){
		
		if(data!=0){
			$.messager.alert("��ʾ",data)
		}else{
			
			
		}
	})
	$('#reqdislist').datagrid('reload');
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })

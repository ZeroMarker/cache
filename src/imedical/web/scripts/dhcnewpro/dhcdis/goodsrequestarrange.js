/**	��������ȷ�Ͻ���
  * �������� sufan 2018-05-11
  * ԭ���밲�Ž���
  * ���Ϊ��������ȷ����ɺ���ɽ���
**/
var editRow="",Select="";
$(document).ready(function() {
		
	initcombox();		// ��ʼ���������Ԫ��
	initArrgrid();		// ��ʼ��ȷ���б�
	initsubgrid();		// ��ʼ����ϸ�б� 
    initMethod();		// ��ʼ���ؼ��󶨵��¼�
	  	
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
    var Usereditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
			options: {
				valueField: "value", 
				textField: "text",
				url:LINK_CSP+"?ClassName=web.DHCDISEscortArrage&MethodName=GetSSUser", 
				required:true,
				editable:false, 
				panelHeight:"350",  //���������߶��Զ�����
				onSelect:function(record){
					var ed=$("#table").datagrid('getEditor',{index:editRow,field:'REQPeople'});
					$(ed.target).combobox('setValue', record.text);
					var ed=$("#table").datagrid('getEditor',{index:editRow,field:'REQPeopleDr'});
					$(ed.target).val(record.value); 
			},
		}
    }  
    
 	par=getParam();		//��ѯ����
 
    $('#table').datagrid({
		    url:LINK_CSP+'?ClassName=web.DHCDISGoodsRequest&MethodName=listGoodsRequest&param='+par,
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
		        //styler: tdStyle,
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
		        title: '������Ա',
		        width:100
		    },{ 
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
		        field: 'REQPeople',
		        align: 'center',
		        title: '������Ա',
		        editor:Usereditor,
		        width:100,
		        styler:function(value,row){
				if(row.REQCurStatus=="������")
					{return 'color:#0000CD'}
		    	}
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
			
			ClickRowDetail(row);
		},
		onDblClickRow: function (Index, row) {//˫��ѡ���б༭
			
			if((row.REQCurStatus!="������")&&(row.REQCurStatus!="�Ѱ���")&&(row.REQCurStatus!="��������")&&(row.REQCurStatus!="���"))
			{
				$.messager.alert("��ʾ:","��ǰ״̬��������������Ա!");
				return;
			}
			if ((editRow != "")||(editRow == "0")) { 
	            $("#table").datagrid('endEdit', editRow); 
	        } 
	        
	       	$("#table").datagrid('beginEdit', Index); 	
	       	Select="true"
	      	editRow = Index; 
		},
	    rowStyler:function(index,row){
			if(row.REQEmFlag=="Y"){
					return 'color:#EE2C2C'
			}
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
        }
        ,{
            field: 'USERNAME',
            align: 'center',
            title: '��Ա',
            width: 200,
            hidden:true,
            editor:{
				type:'combogrid',
				options:{
					    id:'id',
					    fitColumns:true,
					    fit: true,//�Զ���С  
						pagination : true,
						panelWidth:600,
						textField:'name',
						mode:'remote',
						url:'dhcapp.broker.csp?ClassName=web.DHCDISCommonDS&MethodName=LocUserComboGrid',
						columns:[[
								{field:'name',title:'����',width:60},
								{field:'status',title:'״̬',width:40},
								{field:'locdesc',title:'����',width:100},
								{field:'id',hidden:true}
								]],
							onSelect:function(rowIndex, rowData) {
               					fillValue(rowIndex, rowData);
            				}		   
						}
				}
        }
        ]],
	    pageSize:20,
	    pageList:[20,40],
        singleSelect:true,
        loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    onClickRow:function(index,row){onClickRow(index,row)}
    })
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#subTable");
}
function fillValue(rowIndex, rowData){
	
	$('#subTable').datagrid('getRows')[editIndex]['USERID']=rowData.id
}

//���鵯����ҳ��
function ParticularsPages(){
	
	var selectRow = $('#table').datagrid('getSelected');
	if((selectRow==null)){
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

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcdis.accompdetail.csp?mainRowID='+selectRow.REQ+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}
//zhanghailong
function initMethod(){
	
	//��ֺϲ�����¼�
	$("#splitmergebtn").on('click',function(){
	 	splitmerge();
	 });
	 
	//����
	$("#Arrange").bind('click',ArrangeToo);  
	
	//�鿴��֤����ϸ
	$("#vercodebtn").bind('click',verificatCode) 
	
	//ȡ������
	$('#Cancelbtn').on("click",CancelArrange); 
	
	//����
	$('#searchBtn').bind('click',search) 		
	
	//��֤��س��¼�
	$('#TaskID').keydown(function(e){
		if(e.keyCode==13){
	   		search();
		}
	});
	
	//����
	$("#detailMsg").bind('click',ParticularsPages)	
	
	//���
	$('#complete').bind('click',complete);			
}

///��ʼ������Ԫ��
function initcombox()
{
	$('#StrDate').datebox("setValue",formatDate(0));
	$('#EndDate').datebox("setValue",formatDate(0));
	
	//��ǰλ��
	$('#currLoca').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISGoodsRequest&MethodName=GetCurrLoca",
		valueField:'id',    
	    textField:'text',
	    mode:'remote',
	    panelHeight:"auto",  
	});
}
//��ѯ��ϸ
function ClickRowDetail(row){
	$('#subTable').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISGoodsRequest&MethodName=listGoodsRequestItm&req='+row.REQ
	});	
}

//��ѯ
function search(){
	var Params=getParam(); //��ȡ����
	$('#table').datagrid({
			queryParams:{param:Params}	
	})
}	


//����ȷ��
function save(){
	
	
	if(($("#subTable").datagrid('getSelected')=="")){
			$.messager.alert("��ʾ","��ѡ������һ����¼��")
			return;
	}
	arr=new Array();
	tableData=$("#subTable").datagrid('getRows');
	for(var i=0;i<tableData.length;i++){
		arr.push(tableData[i].REQI+"!!"+tableData[i].USERID)
	}
	subStr=arr.join("^");
	runClassMethod(
		"web.DHCDISGoodsRequest",
		"saveUser",
		{'mainStr':subStr},
		function(data){ 
			$.messager.alert("����ɹ�");
			search();  
		},
		"json")	 	
}

//function arrange(){
//
//	updateStatus(27,"");
//	
//}
function refuse(){
	var row=$("#table").datagrid('getSelected')
		if(row==""){
				$.messager.alert("��ʾ","��ѡ������һ�����룡")
				return;
		}	
	var typeid=row.TypeID
	var reqID=row.REQ
	runClassMethod("web.DHCDISGoodsRequest",
					   "refuse",
					   {'reqID':reqID,
					   'type':typeid,
					   'statuscode':98,
					   'lgUser':LgUserID,
					   'reason':''},
					   function(data){
						    
						    if(data==0){
							  $.messager.alert("��ʾ","�����ɹ�!");
					   		  search();  
							}else{
								$.messager.alert('����',data);	
							}  
					   		
					   },"text")
}
function accpet(){

	updateStatus(12,"");
	
}
function updateStatus(statuscode,reason){
	    
	var row=$("#table").datagrid('getSelected')
		if(row==""){
				$.messager.alert("��ʾ","��ѡ������һ�����룡")
				return;
		}	
	var typeid=row.TypeID
	var disreqID=row.REQ
	var emflag=row.REQEmFlag
		runClassMethod("web.DHCDISRequestCom",
					   "updateStatus",
					   {'pointer':disreqID,
					   'type':typeid,
					   'statuscode':statuscode,
					   'lgUser':LgUserID,
					   'EmFlag':emflag,
					   'reason':reason},
					   function(data){
						    
						    if(data==0){
							  $.messager.alert("��ʾ","����ɹ�");
					   		  search();  
							}else{
								$.messager.alert('����',data);	
							}  
					   		
					   },"text")	 	
	
}

//��ֺϲ�zhanghailong
function splitmerge(){
	
	var selItems = $('#table').datagrid('getSelections');
	
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡһ�����ݣ�");
		return;
	}
	var row=$('#table').datagrid('getSelected');
	var req=row.REQ;    //ȡid
	if($('#splitmergewin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="splitmergewin"></div>');
	$('#splitmergewin').window({
		title:'��ֺϲ�',
		collapsible:true,
		border:false,
		closed:"true",
		width:600,
		height:400,
		onClose:function(){
			$('#splitmergewin').remove();
		}
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcdis.splitmerge.csp?reqs='+ req+'"></iframe>';
	$('#splitmergewin').html(iframe);
	$('#splitmergewin').window('open');

}
//Table�������
//return ����ʼʱ��^����ʱ��^����ID^�������^״̬
function getParam(){
		
	 var stDate = $('#StrDate').datebox('getValue');			//��ʼ����	
	 var endDate=$('#EndDate').datebox('getValue');				//��������
	 //taskID= $('#TaskID').val();
	 var recLoc = $('#RecLoc').combobox('getValue');			//���տ���
	 var applayLocDr= $('#ApplayLoc').combobox('getValue');		//�������
	 var status = $('#status').combobox('getValue');			//���뵥״̬
	 var currloc = $("#currLoca").combobox("getValue");			//��ǰλ��
	return stDate +"^"+ endDate +"^"+ "" +"^"+ recLoc +"^"+ applayLocDr +"^"+ status +""+ currloc;
}


//���� ����	
function arrange()
{
	var selectRow = $('#table').datagrid('getSelected');
	var Typeid=selectRow.TypeID; //cy  2017-05-09 ��ȡ���뵥����id
	if (selectRow==null){ 
		$.messager.alert("��ʾ:","��ѡһ�����ݣ�");
		return;
	}
	
	$('#ArrangeWin').window({
		title:'����',
		collapsible:false,
		border:false,
		closed:false,
		width:820,
		height:500
	});
	$('#ArrangeWin').window('open');
	WardNurserList(selectRow.REQ,Typeid);
}
//���ذ��Ŵ��������ݱ��
function WardNurserList(disreqID,Typeid)
{
	var freecolumns=[[
	    {field:'id',title:'id',width:20,hidden:true},
	    {field:'Score',title:'����',width:80},
		{field:'UserCode',title:'����',width:80,align:'center'},
	    {field:'User',title:'����',width:80},
		{field:'Desc',title:'��һ������',width:80,align:'center'}
	]];
	var busycolumns=[[
	    {field:'id',title:'id',width:20,hidden:true},
	    {field:'Score',title:'����',width:80},
		{field:'UserCode',title:'����',width:80,align:'center'},
	    {field:'User',title:'����',width:80},
		{field:'Desc',title:'���ڽ���',width:80,align:'center'}
	]];
	//���ڲ��������б� ����
	$('#wardnurfreedg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=QueryWardNurList&locId='+LgCtLocID+'&StatusType='+0+'&Typeid='+Typeid,
		columns:freecolumns,
		width:400,
		height:187,
		rownumbers:true,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	//���ڲ��������б� æµ
	$('#wardnurbusydg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=QueryWardNurList&locId='+LgCtLocID+'&StatusType='+1+'&Typeid='+Typeid,
		columns:busycolumns,
		width:400,
		height:189,
		rownumbers:true,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	//���������б� ����
	$('#othnurfreedg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=QueryOthNurList&locId='+LgCtLocID+'&StatusType='+0+'&Typeid='+Typeid,
		columns:freecolumns,
		width:400,
		height:187,
		rownumbers:true,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	//���������б� æµ
	$('#othnurbusydg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=QueryOthNurList&locId='+LgCtLocID+'&StatusType='+1+'&Typeid='+Typeid,
		columns:busycolumns,
		width:400,
		height:189,
		rownumbers:true,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	//��ѡ�����б�
	var selnurcolumns=[[
	    {field:'ID',title:'ID',width:80,hidden:true},
	    {field:'UserCode',title:'����',width:80},
		{field:'User',title:'����',width:100,align:'center'}
	]];
	$('#selnurdg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=QueryLocUserList&disreqID='+disreqID+'&reqtypeid='+Typeid,
		columns:selnurcolumns,
		fit:true,
		height:375,
		rownumbers:true,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	/* ָ����Ա�����б�*/
	$('#LocUser').combogrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=LocUserComboGrid&page='+1+'&rows='+20,
		columns:[[
			{field:'UserCode',title:'����',width:90,hidden:false},
			{field:'name',title:'����',width:90,hidden:false},
			{field:'id',title:'id',width:20,hidden:true}
		]],
		required : true,
	    idField:'id',
	    fitColumns:true,
	    fit: true,//�Զ���С  
		panelWidth:150,
		panelHeight:150,
		textField:'name',
		mode:'remote'
	});
}

//���ָ����Ա
function AddLocUserRow()
{
	var LocUserItme= $('#LocUser').combogrid('grid');	// get datagrid object
    var rowData = LocUserItme.datagrid('getSelected');	// get the selected row
	var LocUserID=rowData.id;
    //�жϲ����¼���������Ƿ��ظ�
	var  dataList=$('#selnurdg').datagrid('getData'); 
	for(var i=0;i<dataList.rows.length;i++){
		if(LocUserID==dataList.rows[i].ID){
			$.messager.alert("��ʾ","����Ա����ӣ�"); 
				return false;
		}
	}
	$('#selnurdg').datagrid('insertRow',{
		index: 0, // ������
		row: {
			ID:LocUserID, UserCode:rowData.UserCode, User:rowData.name
		}
	});
}
//����ָ����Ա
function SaveLocUserList()
{
	var rows = $("#selnurdg").datagrid('getChanges');
	var rowdata = $("#table").datagrid('getSelected');
	var typeid=rowdata.TypeID
	var disreqID=rowdata.REQ
	var emflag=rowdata.REQEmFlag
	var curStatus=rowdata.REQCurStatus
	
	var dataList = [],LocUserList="";
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].ID+"^"+rows[i].UserCode+"^"+rows[i].User;
		dataList.push(tmp);
	} 
	LocUserList=dataList.join("$c(1)");
	if(LocUserList==""){
		$.messager.alert("��ʾ","�����ָ����Ա��"); 
		return false;
	}
	//disreqID=$('#table').datagrid('getSelected').REQ
	/// ����ָ����Ա ���Ŵ���:
	//alert(disreqID)
	//alert(typeid)
	//alert(LgUserID)
	//alert(LocUserList)
	//alert(curStatus)
	runClassMethod("web.DHCDISEscortArrage","ArrangeDisReq",{"pointer":disreqID,"type":typeid,"statuscode":11,"lgUser":LgUserID,"EmFlag":emflag,"reason":"","LocUserList":LocUserList,"curStatus":curStatus},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","����ɹ���");
			WardNurserList();
			search();
		}else{
			$.messager.alert('����',jsonString);
		}
	},'text');
}
//��֤����ϸ    zhaowuqiang   2017-02-27
function verificatCode(){
	var selectRow = $('#table').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("��ʾ:","��ѡһ�����ݣ�");
		return;
	}

	var row=$('#table').datagrid('getSelected');
	var disreqID=row.REQ;
	var typeID=row.TypeID
	if($('#vercodewin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="vercodewin"></div>');
	$('#vercodewin').window({
		title:'��֤����ϸ',
		collapsible:true,
		border:false,
		closed:"true",
		width:800,
		height:400,
		minimizable:false,
		maximizable:false,
		resizable:false,
		onClose:function(){
			$('#vercodewin').remove();
		}
	});
	//var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.affirmdetail.csp?mainRowID='+disreqID+'"></iframe>';
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.idcodedetail.csp?mainRowID='+disreqID+'&TypeID='+typeID+'"></iframe>';
	$('#vercodewin').html(iframe);
	$('#vercodewin').window('open'); 

}
/// ���Ż���   2017-06-20  zwq
function ArrangeToo()
{
	if(editRow>="0"){			///sufan 2017-11-23  �������㰲�ű�������
		$("#table").datagrid('endEdit', editRow);
	}
	var selectRow=$('#table').datagrid('getChanges');
	if(selectRow.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	if((selectRow.REQCurStatus!="�Ѱ���")&&(selectRow.REQCurStatus!="������")&&(selectRow.REQCurStatus!="��������"))
	{
		$.messager.alert("��ʾ:","��ǰ״̬������˲���!");
		return;
	}
	if((selectRow.REQPeopleDr=="")&&(selectRow.REQPeople==""))
	{
		$.messager.alert("��ʾ:","��ѡ��������Ա!");
		return;
	}
	
	var SetUserDr=selectRow.REQPeopleDr;
	var ReqID=selectRow.REQ
	var TypeID = selectRow.TypeID;
	var statusCode=11			//sufan 2018-03-22,�˴�Ӧ�ö�̬ȡ
	if(TypeID!="18")
	{
		statusCode="101"
	}
	var ss=ReqID+"^"+TypeID+"^"+SetUserDr+"^"+statusCode+"^"+LgUserID
	runClassMethod("web.DHCDISGoodsRequest","ArrangeToo",{"pointer":ReqID,"typeid":TypeID,"user":SetUserDr,"statuscode":statusCode,"lgUser":LgUserID},function(jsonString){
		if (jsonString==0){
			//$.messager.alert("��ʾ","����ɹ���");
			Select=""; //�Ƿ��Ѱ���
			$('#table').datagrid('reload'); //���¼���
			//search();
		}else{
			$.messager.alert('����',jsonString);
		}
	},'text');
}
///   2017-06-20  zwq
function CancelArrange()
{
	var selectRow = $('#table').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("��ʾ:","��ѡһ�����ݣ�");
		return;
	}
	var disreqID=selectRow.REQ
	var Crrstatue=selectRow.REQCurStatus;
	var TypeID = selectRow.TypeID;
	var statusCode="105";
	if(Crrstatue!="�Ѱ���")
	{
		$.messager.alert("��ʾ:","�Ѱ������뵥�ſ��Խ��д˲���!")
		return;
	}
	var str=disreqID+"^"+TypeID+"^"+statusCode+"^"+LgUserID
	runClassMethod("web.DHCDISGoodsRequest","CancelArrange",{"pointer":disreqID,"typeid":TypeID,"statuscode":statusCode,"lgUser":LgUserID},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","�����ɹ���");
			search();
		}else{
			$.messager.alert('����',jsonString);
		}
	},'text');
	
}

///sufan 2018-05-11 ��������ȷ��
function complete()
{
	if(editRow>="0"){
		$("#table").datagrid('endEdit', editRow);
	}
	var rowsData = $("#table").datagrid('getSelections');
	if((rowsData.length<=0)){
			$.messager.alert("��ʾ","û�д��������ݣ�")
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
		Relation = $("#currLoca").combobox("getValue");	//��ǰλ��	
		if(Relation == ""){
			Relation = LgCtLocID;							
			LocaFlag = "1";				
		}else{
			LocaFlag = "0";								//λ�ñ�ʶ
		}
		var DisUserId = rowsData[i].REQPeopleDr;		//����Id
			
		var tmp=ReqID +"^"+ TypeID +"^"+ statuscode +"^"+ LgUserID +"^"+ EmFlag +"^"+ "" +"^"+ Relation +"^"+ LocaFlag +"^"+ DisUserId ;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	runClassMethod("web.DHCDISGoodsRequest","DisTaskConfirm",{"ListData":params},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","����ɹ���");

		}else{
			$.messager.alert('����',jsonString);
			return;
		}
	},'text');
	$('#table').datagrid('reload');
	rowData="";
	
}
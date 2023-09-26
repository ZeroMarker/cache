/// Creator: congyue
/// CreateDate: 2017-01-12
/// Descript: ���������ѯ����
var disreqID="";
var WardDr="";
var DisREQNums="";
var editRow="";
var Select="";
$(document).ready(function() {

	//��ʼ��ʱ��ؼ�
	initDate();
	
	//��ʼ��combo
	initCombo();
	
	//��ʼ�� table
	initTable();
	
	//��ʼ���ؼ��󶨵��¼�
	initMethod();

	setInterval("search()",150000);
});
function initDate(){
	$("#StDate").datebox("setValue", formatDate(0));  //Init��ʼ����
	$("#EndDate").datebox("setValue", formatDate(0));  //Init��������
}
function initCombo(){
	/* ���� LocUserCombo*/
	$('#ApplyLoc').combobox({
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' 
	});
	var typecode="����";
	/* ״̬ */
	$('#Status').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=StatusCombo&type="+0,// type 0: ���� ,1: ����
		valueField:'id',
	    textField:'text' ,
	    panelHeight:100,
	});
	///����״̬Ĭ��   sufan 2017-12-26
	runClassMethod("web.DHCDISRequest","getStatusValue",{'code':10},function(data){
		$('#Status').combobox("setValue",data);
	},'text',false)
}
function initTable(){
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	var Usereditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISEscortArrage&MethodName=GetSSUser", 
			//required:true,
			//editable:false, 
			panelHeight:200,  //���������߶��Զ�����
			mode:'remote',
			onSelect:function(record){
				///��������ֵ
				var ed=$("#DisReqtb").datagrid('getEditor',{index:editRow,field:'DisREQLocUser'});
				$(ed.target).combobox('setValue', record.text);
				var ed=$("#DisReqtb").datagrid('getEditor',{index:editRow,field:'UserDr'});
				$(ed.target).val(record.value); 
				var ed=$("#DisReqtb").datagrid('getEditor',{index:editRow,field:'PhoneStr'});
				$(ed.target).val(record.telphone); 
			},
		}
	} 
	//����columns
	var columns=[[
	    {field:'DisREQ',title:'disreqID',hidden:true},
		{field:'DisREQTypeID',title:'����ID',hidden:true},  
		{field:'DisName',title:'����'},    //zhl
		{field:'DisHosNo',title:'סԺ��'},  //zhl
		{field:'DisREQCreateDate',title:'��������'},
		{field:'DisREQPatNo',title:'�ǼǺ�'},
		{field:'DisREQWardBed',title:'����'},
		{field:'DisREQWard',title:'����'},
		{field:'DisREQNo',title:'��֤��',hidden:true},
		{field:'DisREQExeDate',title:'��������'},
		{field:"DisREQEscortTool",title:'��ʽ',hidden:false},
		{field:'DisREQEscortType',title:'����'},
		{field:'DisREQCurStatus',title:'����״̬',styler:function(value,row){   ///sufan 2017-11-28
			if((row.DisREQCurStatus=="������")&&(row.DisREQEscortType=="����"))
			{return 'background-color:rgb(255, 98, 72);color:white'}
			if((row.DisREQCurStatus=="������")&&(row.DisREQEscortType!="����"))
			{
				return 'background-color:rgb(139, 195, 74);color:white'
			}
			if(row.DisREQCurStatus=="��������")
			{
				return 'background-color:#ffb746;color:white'
			}
		}},
		{field:'DisREQCurStatusCode',title:'����״̬Code',hidden:true},
		{field:'DisREQLocUser',title:'������Ա',editor:Usereditor},
		{field:'UserDr',title:'����ID',hidden:true,editor:textEditor},
		{field:'PhoneStr',title:'������Ա�绰',hidden:false,editor:textEditor},
		{field:'DisREQRemarks',title:'��ע',hidden:false},
		{field:'DisREQNums',title:'��������',hidden:true},
		{field:'AssNumber',title:'����'},
		{field:'AssRemarks',title:'����'}
		
	]];
	var param=getParam();
	var option = {
		singleSelect : true,
		pageSize:20,
	    pageList:[20,40],
	    loadMsg: '���ڼ�����Ϣ...',
	    onClickRow:function(Index, row){
			disreqID=row.DisREQ;
			DisREQNums=row.DisREQNums; //��������
			ClickRowDetail(disreqID);//��ʾ���뵥��ϸ�б�
		},
       onDblClickRow: function (Index, row) {//˫��ѡ���б༭
			if((row.DisREQCurStatus!="������")&&(row.DisREQCurStatus!="�Ѱ���")&&(row.DisREQCurStatus!="��������"))
			{
				$.messager.alert("��ʾ:","��ǰ״̬��������������Ա!");
				return;
			}
			if (editRow != ""||editRow === 0){ 
           		 $("#DisReqtb").datagrid('endEdit', editRow); 
        	} 
			if(Select=="true")
			{
            	$.messager.alert("��ʾ:","���ȱ�����һ������");
            	Select="false"
            	return;
			}
       		$("#DisReqtb").datagrid('beginEdit', Index); 
       		Select="true";
        	editRow = Index;
            	
        }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCDISEscortArrage&MethodName=listDisRequest&param='+param;
	new ListComponent('DisReqtb', columns, uniturl, option).Init(); 
	
	//����columns
	var DRItmcolumns=[[
		{field:'DISREQI',title:'DISREQI',width:100,hidden:true},
		{field:'ItemDR',title:'��Ŀ����ID',width:100,hidden:true},
	    {field:'Item',title:'��Ŀ����',width:200},
	    {field:'ExeLocDR',title:'RECLOCDR',width:100,hidden:true},
		{field:'ExeLoc',title:'ȥ��',width:200},
		{field:'ItemType',title:'��Ŀ����',width:100,hidden:true}
	]];
	//���뵥��ϸ�б� 
    $('#DisReqItmtb').datagrid({
		columns:DRItmcolumns,
		fit:true,
	    url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=listGoodsRequestItm&disreq='+'',
	    pageSize:20,
	    pageList:[20,40],
        singleSelect:true,
        loadMsg: '���ڼ�����Ϣ...',
	    nowrap:false,//�����Զ�����
	    pagination:true
    });
    
    
    //������δ���Ų����б� 
    
    $('#DisReqWardtb').datagrid({
		columns:[[
			{field:'WardDesc',title:'����',width:190,hidden:false}, ///,formatter:setCellLabel
			{field:'WardDr',title:'WardDr',width:20,hidden:true}
		]],
	    url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=listWard&param='+param,
		fit:true,
		rownumbers:true,
		pageSize:10,  	// ÿҳ��ʾ�ļ�¼����
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		showHeader:false,
		rownumbers : false,
		showPageList : false,
	    onClickRow:function(Index, row){
			WardDr=row.WardDr;
			var Params=getParam(); //��ȡ����
			$('#DisReqtb').datagrid({
				queryParams:{param:Params}	
			});
			$('#DisReqItmtb').datagrid({
				url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=listGoodsRequestItm&disreq='+''
			}); 

		},
		onLoadSuccess:function(data){
			// ���ط�ҳͼ��
            $('#List .pagination-page-list').hide();
            $('#List .pagination-info').hide();
            
		}
    });
	//����ˢ��
    $('#DisReqWardtb').datagrid('getPager').pagination({ showRefresh: false}); 
}	
/// ������δ���Ų����б�   ��Ƭ��ʽ
function setCellLabel(value, rowData, rowIndex){
	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.WardDesc +'</h3><br></div>';
	return htmlstr;
}

function initMethod(){
	//�ǼǺŻس��¼�
	$('#RegNo').bind('keypress',RegNoBlur)
	$("#acceptbtn").on('click',function(){
		Accept(); 
	})
	$("#rejectbtn").on('click',function(){
		Refuse(); 
	})
	//���� ����¼�
	$("#detailsbtn").on('click',function(){
	 	details();
	}) 
	$("#Arrange").bind("click",ArrangeToo);
	$('#searchBtn').bind('click',search) //�������뵥����
	//$('#Arrangebtn').bind("click",Arrange);//���� �������Ŵ���
	$('#Cancelbtn').bind("click",CancelArrange); //ȡ������
	$("#vercodebtn").on('click',function(){
	 	verificatCode();//��֤����ϸ
	}) 
	
	
}	

/*======================================================*/

//�ǼǺŻس��¼�
function RegNoBlur(event){
    if(event.keyCode == "13")    
    {
	    var RegNo=$('#RegNo').val();
	    if(RegNo==""){return false;}
		var len=RegNo.length;
		var  reglen=10;
		var zerolen=reglen-len;
		var zero="";
		for (var i=1;i<=zerolen;i++)
		{
			zero=zero+"0" ;
		}
	    $("#RegNo").val(zero+RegNo);
    }
};
//Table�������
//return ����ʼ���ڡ���ֹ���ڡ��������id���ǼǺš�����id��״̬
function getParam(){
	var stDate = $('#StDate').datebox('getValue');
	var endDate=$('#EndDate').datebox('getValue');
	var RegNo= $('#RegNo').val();
	
	var ApplyLoc= $('#ApplyLoc').combobox('getValue');
	var taskID= $('#TaskID').val();
	var DisHosNo = $('#HosNo').val();
	if(taskID==undefined)
	{
		taskID="";
	}
	
	if(ApplyLoc==undefined){
		ApplyLoc=""	;	
	}
	var status = $('#Status').combobox('getValue');
	if(status==undefined){
		status="" ;		
	}
	return stDate+"^"+endDate+"^"+ApplyLoc+"^"+RegNo+"^"+taskID+"^"+status+"^"+WardDr+"^"+DisHosNo+"^"+LgHospID;
}

///��ѯ��ť��������ȥ��������Ϣ
function getSearch()
{
	var stDate = $('#StDate').datebox('getValue');
	var endDate=$('#EndDate').datebox('getValue');
	var RegNo= $('#RegNo').val();
	
	var ApplyLoc= $('#ApplyLoc').combobox('getValue');
	var taskID= $('#TaskID').val();
	var DisHosNo = $('#HosNo').val();
	if(taskID==undefined)
	{
		taskID="";
	}
	
	if(ApplyLoc==undefined){
		ApplyLoc=""	;	
	}
	var status = $('#Status').combobox('getValue');
	if(status==undefined){
		status="" ;		
	}
	return stDate+"^"+endDate+"^"+ApplyLoc+"^"+RegNo+"^"+taskID+"^"+status+"^"+""+"^"+DisHosNo+"^"+LgHospID;
}
//��ѯ��ϸ
function ClickRowDetail(disreqID){
	$('#DisReqItmtb').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=listGoodsRequestItm&disreq='+disreqID
	});	
}
//��ѯ
function search(){
	Select="";
	var Params=getSearch(); //��ȡ����
	$('#DisReqtb').datagrid('load',{param:Params}); 
	
	$('#DisReqItmtb').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=listGoodsRequestItm&disreq='+''
	}); 
	//var StDate=$('#StDate').datebox('getValue');
	//var EndDate=$('#EndDate').datebox('getValue');
	//var DateParams=StDate+"^"+EndDate
	$('#DisReqWardtb').datagrid({
		queryParams:{param:Params}	
	});
	
}
//���� add lvpeng 17-02-22 �޸�
function details(){
	var selectRow = $('#DisReqtb').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("��ʾ:","��ѡһ�����ݣ�");
		return;
	}

	if($('#detailswin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append("<div id='detailswin' class='hisui-window' title='����' style='width:800px;height:400px;top:100px;left:260px;padding:10px'></div>");
	$('#detailswin').window({
		iconCls:'icon-paper-info',
		collapsible:true,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		onClose:function(){
			$('#detailswin').remove();
		}
	});
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.affirmdetail.csp?mainRowID='+disreqID+'&typeID='+selectRow.DisREQTypeID+'"></iframe>';
	$('#detailswin').html(iframe);
	$('#detailswin').window('open');

}

//���� �ܾ����� //״̬���� ���� 12 �ܾ� 98
function operation(statusCode){
	var selectRow = $('#DisReqtb').datagrid('getSelected');
	var TypeID=selectRow.DisREQTypeID;

	if (selectRow==null){
		$.messager.alert("��ʾ:","��ѡһ�����ݣ�");
		return;
	}
	/// ���ܣ��ܾ����뵥����
	runClassMethod("web.DHCDISEscortArrage","StatusOperat",{"pointer":disreqID,"typeid":TypeID,"status":statusCode,"lgUser":LgUserID},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","����ɹ���");
			search();
		}else{
			$.messager.alert('����',jsonString);
		}
	},'text');
}
//���� ����	
function Arrange()
{
	var selectRow = $('#DisReqtb').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("��ʾ:","��ѡһ�����ݣ�");
		return;
	}
	var Typeid=selectRow.DisREQTypeID;
	$('#ArrangeWin').window({
		title:'����',
		collapsible:false,
		border:false,
		closed:false,
		width:820,
		height:600
	});
	$('#ArrangeWin').window('open');
	WardNurserList(Typeid);
}
//���ذ��Ŵ��������ݱ��
function WardNurserList(Typeid)
{
	var freecolumns=[[
	    {field:'id',title:'id',width:20,hidden:true},
	    {field:'Score',title:'����',width:50,align:'center'},
		{field:'UserCode',title:'����',width:80,align:'center'},
	    {field:'User',title:'����',width:100,align:'center'},
		{field:'Desc',title:'��һ������',width:80,align:'center'},
		{field:'AllNum',title:'AllNum',width:80,align:'center',hidden:true},
		{field:'UserDr',title:'UserDr',width:20,hidden:true},
		
	]];
	var busycolumns=[[
	    {field:'id',title:'id',width:20,hidden:true},
	    {field:'Score',title:'����',width:50,align:'center'},
		{field:'UserCode',title:'����',width:80,align:'center'},
	    {field:'User',title:'����',width:100,align:'center'},
		{field:'Desc',title:'���ڽ���',width:80,align:'center'},
		{field:'AllNum',title:'AllNum',width:80,align:'center',hidden:true}
	]];
	//���ڲ��������б� ����
	$('#wardnurfreedg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISEscortArrage&MethodName=QueryWardNurList&locId='+LgCtLocID+'&StatusType='+0+'&Typeid='+Typeid,
		columns:freecolumns,
		width:400,
		height:290,
		rownumbers:true,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onClickRow:function(rowIndex, rowData){  //yuliping  �������������Ա 2017-05-03
			var UserCode=rowData.UserCode
			var User=rowData.User                
			var UserDr=rowData.UserDr
			var  dataList=$('#selnurdg').datagrid('getData'); 
			for(var i=0;i<dataList.rows.length;i++){
		
			if(UserDr==dataList.rows[i].ID){
				
			$.messager.alert("��ʾ","����Ա����ӣ�"); 
				return ;
			}
			}
		$('#selnurdg').datagrid('insertRow',{
			index: 0, // ������
			row: {
				ID:UserDr, UserCode:UserCode, User:User
			 }
			
			});
			
			}
		
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
		height:290,
		rownumbers:true,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		
		onClickRow:function(rowIndex, rowData){  //yuliping  �������������Ա 2017-05-03
			var UserCode=rowData.UserCode
			var User=rowData.User                
			var UserDr=rowData.UserDr
			//alert(ID+','+UserCode+','+User)
			
			var  dataList=$('#selnurdg').datagrid('getData'); 
			for(var i=0;i<dataList.rows.length;i++){
		
			if(UserDr==dataList.rows[i].ID){
				
			$.messager.alert("��ʾ","����Ա����ӣ�"); 
				return ;
			}
			}
		$('#selnurdg').datagrid('insertRow',{
			index: 0, // ������
			row: {
				ID:UserDr, UserCode:UserCode, User:User
			}
			
			});
			
			}
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
		{field:'DPRowid',title:'DPRowid',width:80,hidden:true},
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
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){  //˫�����ѡ����
			if((rowData.DPRowid==undefined)||(rowData.DPRowid=="")){
				$('#selnurdg').datagrid('deleteRow',rowIndex);
			}
		}
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
	var rows = $("#selnurdg").datagrid('getRows');
	var changerows = $("#selnurdg").datagrid('getChanges');
	
	var rowdata = $("#DisReqtb").datagrid('getSelected');
	var Typeid=rowdata.DisREQTypeID;
	var emflag="Y";
	var curStatus=rowdata.DisREQCurStatus;
	
	var dataList = [],LocUserList="";
	if(changerows.length==0){
		$.messager.alert("��ʾ","�����ָ����Ա��"); 
		return false;
	}
	if(rows.length!=DisREQNums){
		$.messager.alert("��ʾ","�����"+DisREQNums+"��ָ����Ա��"); 
		return false;
	}
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].ID+"^"+rows[i].UserCode+"^"+rows[i].User;
		dataList.push(tmp);
	} 
	LocUserList=dataList.join("$c(1)");
	//alert(disreqID+"&"+typeID+"&"+11+"&"+LgUserID+"&"+emflag+"&"+""+"&"+LocUserList+"&"+curStatus);
	/// ����ָ����Ա ���Ŵ���:11
	runClassMethod("web.DHCDISEscortArrage","ArrangeDisReq",{"pointer":disreqID,"type":Typeid,"statuscode":11,"lgUser":LgUserID,"EmFlag":emflag,"reason":"","LocUserList":LocUserList,"curStatus":curStatus},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","����ɹ���");
			WardNurserList(Typeid);
			search();
		}else{
			$.messager.alert('����',jsonString+" ����ʧ��");
		}
	},'text');
}
//��֤����ϸ    zwq
function verificatCode(){
	var selectRow = $('#DisReqtb').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("��ʾ:","��ѡһ�����ݣ�");
		return;
	}

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
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.codedetail.csp?mainRowID='+disreqID+'"></iframe>';
	$('#vercodewin').html(iframe);
	$('#vercodewin').window('open'); 

}
/// ���ܲ��� zhaowuqiang
function Accept()
{
	var selectRow = $('#DisReqtb').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("��ʾ:","��ѡһ�����ݣ�");
		return;
	}
	var ReqType = selectRow.DisREQTypeID;
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":disreqID,"type":ReqType,"statuscode":12,"lgUser":LgUserID,"EmFlag":"Y"},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","����ɹ���");
			search();
		}else{
			$.messager.alert('����',jsonString+" ����ʧ��");
		}
	},'text');
}
///   2017-05-31  zwq
function CancelArrange()
{
	var selectRow = $('#DisReqtb').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("��ʾ:","��ѡһ�����ݣ�");
		return;
	}
	var Crrstatue=selectRow.DisREQCurStatus;
	var TypeID = selectRow.DisREQTypeID;
	var statusCode=99;
	if(Crrstatue!="�Ѱ���")
	{
		$.messager.alert("��ʾ:","�Ѱ������뵥�ſ��Խ��д˲���!")
		return;
	}
	//var str=disreqID+"^"+TypeID+"^"+statusCode+"^"+LgUserID
	//alert(str)
	runClassMethod("web.DHCDISEscortArrage","CancelArrange",{"pointer":disreqID,"typeid":TypeID,"statuscode":statusCode,"lgUser":LgUserID},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","�����ɹ���");
			search();
		}else{
			$.messager.alert('����',jsonString);
		}
	},'text');
	
}
///   2017-05-31  zwq
function ArrangeToo()
{
	if(editRow>="0"){			///sufan 2017-11-23  �������㰲�ű�������
		$("#DisReqtb").datagrid('endEdit', editRow);
	}
	var selectRow=$('#DisReqtb').datagrid('getSelected');
	if (selectRow==null){
		$.messager.alert("��ʾ:","��ѡһ�����ݣ�");
		return;
	}
	if((selectRow.DisREQCurStatus!="�Ѱ���")&&(selectRow.DisREQCurStatus!="������")&&(selectRow.DisREQCurStatus!="��������"))
	{
		$.messager.alert("��ʾ:","��ǰ״̬������˲���!");
		return;
	}
	if(selectRow.DisREQCurStatus=="�Ѱ���")
	{
		var rowsData = $("#DisReqtb").datagrid('getChanges');
		if(rowsData=="")
		{
			$.messager.alert("��ʾ:","�Ѱ��Ż�������˲飡");
			return;
		}
		
	}
	if((selectRow.UserDr=="")||(selectRow.DisREQLocUser==""))
	{
		$.messager.alert("��ʾ:","��ѡ��������Ա!");
		return;
	}
	var SetUserDr = selectRow.UserDr;
	var ReqID = selectRow.DisREQ
	var TypeID = selectRow.DisREQTypeID;
	var statusCode = 11;
	//var ss=ReqID+"^"+TypeID+"^"+SetUserDr+"^"+statusCode+"^"+LgUserID
	//alert(ss)
	runClassMethod("web.DHCDISEscortArrage","ArrangeToo",{"pointer":ReqID,"typeid":TypeID,"user":SetUserDr,"statuscode":statusCode,"lgUser":LgUserID},function(jsonString){
		if (jsonString==0){
			//$.messager.alert("��ʾ","����ɹ���");
			Select=""; //�Ƿ��Ѱ���
			$('#DisReqtb').datagrid('reload'); //���¼���
			//search();
		}else{
			$.messager.alert('����',jsonString);
		}
	},'text',false);
	

}

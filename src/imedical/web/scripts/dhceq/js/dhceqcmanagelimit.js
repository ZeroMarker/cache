///Modified by JDL 20151020 ������������ݣ��Ż�����ȡ����,����������⣬����ѡ�и�ֵ���⼰��������

var InitGroupFlag=false;
var InitRoleFlag=false;
var searchFlag=true;
var SelectedRowID = 0;
var preRowID=0;

$(document).ready(function () {
//InitGroupCboGrid();
//InitRoleCbo();
//$('#user').combogrid('grid').datagrid('options').onSelect=function(){return false;};
$('#user').combogrid({
	url:'dhceq.jquery.csp', 
	panelWidth:300,
	delay:800,  
	idField:'rowid',
	textField:'name',
	method:"post",
	mode:'remote',
	queryParams:{
		ClassName: 'web.DHCEQCManageLimit',
		QueryName: 'User',
		Arg1: '',
		ArgCnt: 1
	},
	columns:[[    
        {field:'rowid',title:'rowid',hidden:true},    
        {field:'name',title:'����'},
        {field:'initials',title:'����'}
        ]],
    onSelect: function (rec) {  //Modefied by zc 2015-07-13 zc0027 �������Ϳ������ݵ���ʾ
        //$('#group').combogrid('clear');
        var sid = $('#user').combogrid('getValue');
        if (searchFlag==true)
	        {	ReloadGrid("group","",sid+SplitChar);	}
        },
	keyHandler: { 
		query: function(q) {
			ReloadGrid("user",q,q);}
		},
//	onChange: function(newValue, oldValue){
//		ReloadGrid("user",newValue);
//	},
	pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75,90,105]
    });

$('#managelimitdatagrid').datagrid({   
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCManageLimit",
        QueryName:"GetManageLimit",
        ArgCnt:0
    },
    border:'true',
    singleSelect:true,
    toolbar:[{   
    			iconCls: 'icon-add',
                text:'����',          
                handler: function(){   /// Modfied by zc 2015-07-30 ZC0027
                     AddgridData();
                }   
                },'------------------------',{        
                iconCls: 'icon-save',
                text:'����',          
                handler: function(){
                     SavegridData();
                }   
                },'------------------------',{        
                iconCls: 'icon-cut', 
                text:'ɾ��',      
                 handler: function(){
                     DeleteGridData();
                     }      
                 },'------------------------',{        
                iconCls: 'icon-search', 
                text:'��ѯ',      
                 handler: function(){
                     findGridData();
                     }      
                 }] , 
   
    columns:[[
    	{field:'rowid',title:'Rowid',width:50,hidden:true},    
        {field:'user',title:'������',width:100,align:'center'},
        {field:'groupdr',title:'groupdr',width:50,align:'center',hidden:true}, 
        {field:'group',title:'��ȫ��',width:180,align:'center'},       
        {field:'role',title:'��ɫ',width:100,align:'center'},  
        {field:'equiptypeflag',title:'����',width:80,align:'center',formatter: equiptypeOperation},
        {field:'statcatflag',title:'����',width:80,align:'center',formatter: statcatOperation},       
        {field:'equipcatflag',title:'����',width:80,align:'center',formatter: equipcatOperation},
        {field:'locflag',title:'����',width:80,align:'center',formatter: locOperation},
        {field:'equipflag',title:'�豸',width:80,align:'center',formatter: equipOperation},
        {field:'itemflag',title:'�豸��',width:80,align:'center',formatter: itemOperation},                
    ]],
    onClickRow : function (rowIndex, rowData) {
        managelimitdatagrid_OnClickRow();
    },
	fit:true,
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75,90,105]    
	});

//$('#managelimitdatagrid').datagrid('hideColumn', 'rowid')
});

function managelimitdatagrid_OnClickRow()
{
     var selected=$('#managelimitdatagrid').datagrid('getSelected'); 
     if (selected)
     {       
        var SelectedRowID=selected.rowid;
        if(preRowID!=SelectedRowID)
        {			
             $('#Rowid').val(selected.rowid);             
             ///��ֵʱ��֤Grid������             
             ReloadGrid("user",selected.user,selected.user);
             searchFlag=false; 
             $('#user').combogrid('setValue',selected.userdr);
             
             $('#group').combogrid('setText',selected.group);
             ReloadGrid("group",selected.group,selected.userdr+SplitChar+selected.group); 
             
             $('#group').combogrid('setValue',selected.groupdr);
             $('#group').combogrid('setText',selected.group);   ///modify by lmm 2017-06-01 372449 ����״̬���ı���ֵ����ֹ��ʾgroupdr

             //setTimeout("alertShow('0.5 seconds!')",500)
             ///��ֵʱ��֤Grid������
             searchFlag=true;
             ReloadGrid("role",selected.role,selected.groupdr+SplitChar+selected.role);
             if (selected.roledr!=0)
             {
	             $('#role').combogrid('setValue',selected.roledr);
            	 $('#role').combogrid('setText',selected.role);  ///add by lmm 2017-06-01  372449  ����״̬���ı���ֵ����ֹ��ʾroledr
             }
             SetCheckValue("equiptypeflag",selected.equiptypeflag)
             SetCheckValue("statcatflag",selected.statcatflag)
             SetCheckValue("equipcatflag",selected.equipcatflag)
             SetCheckValue("locflag",selected.locflag)
             SetCheckValue("equipflag",selected.equipflag)
			 SetCheckValue("itemflag",selected.itemflag)
             preRowID=SelectedRowID;
         }
         else
         {
             Clear();             
         }
     }
} 

function equiptypeOperation(value,row,index)
{
	return GetFlagHtml(1,value,row);
}
 
function statcatOperation(value,row,index)
{
	return GetFlagHtml(2,value,row);
}
 
function equipcatOperation(value,row,index)
{
	return GetFlagHtml(3,value,row);
}
 
function locOperation(value,row,index)
{
	return GetFlagHtml(4,value,row);
}	

function equipOperation(value,row,index)
{
	return GetFlagHtml(5,value,row);
}

function itemOperation(value,row,index)
{
	return GetFlagHtml(6,value,row);
}

function GetFlagHtml(type,value,row)
{
	var btn=""
	if ("Y"==value)
	{
		var para="id="+row.rowid+"&type="+type;
		var url="dhceqcmanagelimitlist.csp?";
		if (type<3)
		{	para=para+"&Group="+row.groupdr;
			url="dhceqcmanagelimitlistinfo.csp?";	}
		url=url+para;		
		btn='<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>';
	}
	return btn;
}

function findGridData(){
	$('#managelimitdatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCManageLimit",
        QueryName:"GetManageLimit",
        Arg1:$('#user').combogrid('getValue'),
        Arg2:$('#group').combogrid('getValue'),
        Arg3:$('#role').combogrid('getValue'),
        ArgCnt:3
    },
    border:'true',
    singleSelect:true});
}

/// Modfied by zc 2015-07-30 ZC0027
/// ����:����AddgridData����
function AddgridData(){
	if (CheckData()==false) return false;	
	var data={
                ClassName:"web.DHCEQCManageLimit",
                MethodName:"AddManageLimit",
                Arg1:$('#user').combogrid('getValue'),
                Arg2:$('#group').combogrid('getValue'),
                Arg3:$('#role').combogrid('getValue'),
				Arg4:GetCheckValue("equiptypeflag"),
        		Arg5:GetCheckValue("statcatflag"),
        		Arg6:GetCheckValue("equipcatflag"),
        		Arg7:GetCheckValue("locflag"),
        		Arg8:GetCheckValue("equipflag"),
				Arg9:GetCheckValue("itemflag"),
                ArgCnt:9
            };
	DoAjaxAction(data,"���ڱ�����...","Add");
}

function SavegridData(){
	if ($('#Rowid').val()==""){
	    $.messager.alert("����", "��ѡ��һ�У�", 'error')
	    return false;
    }
    if (CheckData()==false) return false;
	var data={
                ClassName:"web.DHCEQCManageLimit",
                MethodName:"SaveManageLimit",
                Arg1:$('#Rowid').val(),
                Arg2:$('#user').combogrid('getValue'),
                Arg3:$('#group').combogrid('getValue'),
                Arg4:$('#role').combogrid('getValue'),
				Arg5:GetCheckValue("equiptypeflag"),
        		Arg6:GetCheckValue("statcatflag"),
        		Arg7:GetCheckValue("equipcatflag"),
        		Arg8:GetCheckValue("locflag"),
        		Arg9:GetCheckValue("equipflag"),
				Arg10:GetCheckValue("itemflag"),
                ArgCnt:10
            };
	DoAjaxAction(data,"���ڱ�����...","Save");
}


function DeleteGridData(){
    if ($('#Rowid').val()==""){
	    $.messager.alert("����", "��ѡ��һ��!", 'error')
	    return false;
    } 
    var rows = $('#managelimitdatagrid').datagrid('getSelections');
    var ids = [];
    var unSaveIndexs = [];
    if (rows.length > 0) {
        $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ����?', function (b) { 
	        if (b==false)
	        {	return;	}
	        else
	        {
		        var data={
	                ClassName:"web.DHCEQCManageLimit",
	                MethodName:"DeleteManageLimit",
	                Arg1:$('#Rowid').val(),
	                ArgCnt:1
	            };
				DoAjaxAction(data,"����ɾ����...","Delete");
	        }
        });
    }
    else
    {	$.messager.alert("����","��ѡ��һ�У�",'err');	}
}

/// Modfied by zc 2015-09-11 ZC0029
/// ����:������պ���
function Clear(){
	$('#Rowid').val("");
    $('#user').combogrid('setValue',"");
    ReloadGrid("user","","");		//Add By DJ 2017-02-18 begin
    ReloadGrid("group","","");
    ReloadGrid("role","","");		//Add By DJ 2017-02-18 end
    $('#group').combogrid('setValue',"");
    $('#role').combogrid('setValue',"");
    $('#equiptypeflag').val(""); 
    if($('#equiptypeflag').val()=="")
    {
	    $('#equiptypeflag').attr("checked",false);//��
	}
    $('#statcatflag').val("");
    if($('#statcatflag').val()=="")
    {
	    $('#statcatflag').attr("checked",false);//��
	}
    $('#equipcatflag').val("");
    if($('#equipcatflag').val()=="")
    {
	    $('#equipcatflag').attr("checked",false);//��
	}
    $('#locflag').val("");
    if($('#locflag').val()=="")
    {
	    $('#locflag').attr("checked",false);//��
	}
	$('#equipflag').val("");
    if($('#equipflag').val()=="")
    {
	    $('#equipflag').attr("checked",false);//��
	}
	$('#itemflag').val("");
	if($('#itemflag').val()=="")
    {
	    $('#itemflag').attr("checked",false);//��
	}
	SelectedRowID = 0;
	preRowID=0;
}

///��ʼ��CboGrid
function InitCboGrid(DataGridID)
{
	if (DataGridID=="group")
		{	InitGroupCboGrid();	}
	else if (DataGridID=="role")
		{	InitRoleCbo();	}
}

//��ʼ����ȫ�� Add JDL 20151020
function InitGroupCboGrid()
{
	if (InitGroupFlag==true) return;
	//alertShow("InitGroupCboGrid");
	$('#group').combogrid({
		url:'dhceq.jquery.csp',      
		idField:'groupdr',
		textField:'group',
		method:"post",
		mode:'remote',
		queryParams:{
			ClassName:"web.DHCEQCManageLimit",
			QueryName:"GetGroup",
			Arg1:$('#user').combogrid('getValue'),
			Arg2:$('#group').combogrid('getText'),
			ArgCnt:2
			},
		keyHandler: { 
			query: function(q) {
				if (searchFlag==true){	ReloadGrid("group",q,$('#user').combogrid('getValue')+SplitChar+q);}
				}
    	},
    	onSelect: function (rec) {  //Modefied by zc 2015-07-13 zc0027 �������Ϳ������ݵ���ʾ	        
	        if (searchFlag==true){	ReloadGrid("role","", $('#group').combogrid('getValue'))	};}
	});
	InitGroupFlag=true;
	QueryFlag=false;
}

//��ʼ����ɫ Add JDL 20151020
function InitRoleCbo()
{
	if (InitRoleFlag) return;
	$('#role').combogrid({
			url:'dhceq.jquery.csp',      
			idField:'roledr',
			textField:'role',
			method:"post",
			mode:'remote',
			queryParams:{
				ClassName:"web.DHCEQCGroupRole",
				QueryName:"GroupRole",
				Arg1:$('#group').combogrid('getValue'),
				ArgCnt:1
			}		
	});
	InitRoleFlag=true;
	QueryFlag=false;
}

//������Ч��� Add JDL 20151020
function CheckData()
{
	if ($('#user').combogrid('getValue')==""){
           $.messager.alert("����", "�����˲���Ϊ�գ�", 'error')
           return false;
    }
    if ($('#group').combogrid('getValue')==""){
            $.messager.alert("����", "��ȫ�鲻��Ϊ�գ�", 'error')
            return false;
    }
//    if ($('#role').combogrid('getValue')==""){
//            $.messager.alert("����", "��ɫ����Ϊ�գ�", 'error')
//            return false;
//    }
	return true;
}

///���ú�̨DoAjaxAction��ִ�н���ɹ�ʱ������data����Ӧ���� Add JDL 20151020
function DoAjaxResult(data, response, status,action)
{
	var SuccessFlag=false;
	if (action=="Add")
		{	if (data>0) SuccessFlag=true;	}
	else
		{	if (data==0) SuccessFlag=true;	}
	if ((action=="Add")||(action=="Save"))
	{
		if (SuccessFlag==true)	
		{
            $('#managelimitdatagrid').datagrid('reload'); 
            $.messager.show({
                title: '��ʾ',
                msg: '����ɹ�'
            	});
			Clear();
		}   
        else 
        {	$.messager.alert('����ʧ�ܣ�',data, 'warning');	}
	}
	else if (action=="Delete")
	{
		if (SuccessFlag==true) 
		{
            $('#managelimitdatagrid').datagrid('reload');
            $.messager.show({
                title: '��ʾ',
                msg: 'ɾ���ɹ�'
            });
			Clear();
		}   
        else 
        {	$.messager.alert('ɾ��ʧ�ܣ�',data, 'warning');	}
	}
}
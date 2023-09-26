/*
ģ��:����ҩ��
��ģ��:����ҩ��-��ҳ-��˵�-ҩ����Ա����ά��
createdate:2016-06-07
creator:dinghongying
modified by yunhaibao20160614
*/
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var url = "dhcpha.outpha.percode.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID']; 
var gridChkIcon='<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>';
var gridUnChkIcon='<i class="fa fa-close" aria-hidden="true" style="color:#DD4F43;font-size:18px"></i>'
$(function(){
	InitPharmacyStaffList();	
	InitCLocDesc();
	InitCUserName();
    $("input[type=checkbox][name=effectFlag]").on('click',function(){
		if ($('#'+this.id).is(':checked')){
			$('#CUseFlag').prop('checked',false); 
		}	
    });
    $("input[type=checkbox][name=uneffectFlag]").on('click',function(){
		if ($('#'+this.id).is(':checked')){
			$("input[type=checkbox][name=effectFlag]").prop('checked',false); 
		}	
    });
	$('#BSearch').bind('click', Query);//�����ѯ
	$('#BAdd').bind('click', Add);//�������
	$('#BUpdate').bind('click', Update);//����޸�
	$('#BClear').bind('click', Clear);//�������Ļ
});


//��ʼ��ҩ������
function InitCLocDesc()
{
	$('#CLocDesc').combobox({  
		panelWidth: 150,
		url:commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+gUserId+'',
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#CLocDesc').combobox('getData');
            if (data.length > 0) {
                  $('#CLocDesc').combobox('select', gLocId);
              }            
	    },
	   	 onSelect:function(){
		    var selectLoc=$('#CLocDesc').combobox("getValue")
	        $('#CUserName').combobox('reload',commonOutPhaUrl+'?action=GetLocAllUserDs&params='+selectLoc); 	          
		}
	});	
}


//��ʼ��ҩ����Ա
function InitCUserName()
{
	$('#CUserName').combobox({  
		panelWidth: 150,
		url:commonOutPhaUrl+'?action=GetLocAllUserDs&params='+gLocId+'',
		valueField:'RowId',  
		textField:'Desc'
	});	
}


//��ʼ��ҩ����Ա�б�
function InitPharmacyStaffList(){
	//����columns
	var columns=[[
        {field:'TPhpid',title:'RowId',width:200,hidden:true},
        {field:'TPhlid',title:'TPhlid',width:100,hidden:true},
        {field:'TUserId',title:'TUserId',width:100,hidden:true},
        {field:'TCtLocId',title:'TCtLocId',width:100,hidden:true},
	    {field:'TLocDesc',title:'ҩ������',width:200},
	    {field:'TUserCode',title:'��Ա����',width:100},
        {field:'TUserName',title:'����',width:100}, 
        {field:'TCheckFlag',title:'���',width:75,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="��"){
	        		return gridChkIcon; 
	        	}else{
		        	return gridUnChkIcon;
		        }
	        }
        },
        {field:'TPyFlag',title:'��ҩ',width:75,align:'center',
            formatter:function(value,row,index){
	        	if (value=="��"){
	        		return gridChkIcon; 
	        	}else{
		        	return gridUnChkIcon;
		        }
	        }
        },
        {field:'TFyFlag',title:'��ҩ',width:75,align:'center',
            formatter:function(value,row,index){
	        	if (value=="��"){
	        		return gridChkIcon; 
	        	}else{
		        	return gridUnChkIcon;
		        }
	        }
        },
        {field:'TUseFlag',title:'��Ч',width:75,align:'center',
            formatter:function(value,row,index){
	        	if (value=="��"){
	        		return gridChkIcon; 
	        	}else{
		        	return gridUnChkIcon;
		        }
	        }
        }
	]];  
	
   //����datagrid	
   $('#pharmacystaffdg').datagrid({    
        url:url+'?action=GetPharmacyStaffList',
        fit:true,
	    border:false,
	    striped:true,
	    toolbar:'#btnbar',
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
        pageSize:30,  // ÿҳ��ʾ�ļ�¼����
	    pageList:[30,50,100],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    fitColumns:true,
	    pagination:true,
	    onClickRow:function(rowIndex,rowData){
			if (rowData){
				var RowId=rowData['TRowId'];
				var username=rowData['TUserName'];
				var userid=rowData['TUserId'];
				var locdesc=rowData['TLocDesc'];
				var usercode=rowData['TUserCode'];
				var pyflag=rowData['TPyFlag'];
				var fyflag=rowData['TFyFlag'];
				var useflag=rowData['TUseFlag'];
				var checkflag=rowData['TCheckFlag'];
				var ctlocid=rowData['TCtLocId'];
				$("#CLocDesc").combobox('setValue',ctlocid);
				$("#CLocDesc").combobox('setText',locdesc);
				$("#CUserName").combobox('setValue',userid);
				$("#CUserName").combobox('setText',username);
				$("#CUserCode").val(usercode);
				if(pyflag=="��")
				{
					$("#CPyFlag").prop("checked",true);
				}
				else
				{
					$("#CPyFlag").prop("checked",false);
				}
				if(fyflag=="��")
				{
					$("#CFyFlag").prop("checked",true);
				}
				else
				{
					$("#CFyFlag").prop("checked",false);
				}
				if(useflag=="��")
				{
					$("#CUseFlag").prop("checked",true);
				}
				else
				{
					$("#CUseFlag").prop("checked",false);
				}
				if(checkflag=="��")
				{
					$("#CheckFlag").prop("checked",true);
				}
				else
				{
					$("#CheckFlag").prop("checked",false);
				}
			}
		}   
   });
}


///ҩ����Ա��������
function Add()
{
	var locId=$("#CLocDesc").combobox('getValue');
	if ($('#CLocDesc').combobox("getText")==""){
		$.messager.alert('������ʾ',"��ѡ��ҩ������!");
		return;
	}
	var UserName=$("#CUserName").combobox('getText');
	if ($('#CUserName').combobox("getText")==""){
		$.messager.alert('������ʾ',"��ѡ��ҩ����Ա!");
		return;
	}
	var UserCode=$("#CUserName").combobox('getValue');
	var PyFlag=""
	if($('#CPyFlag').is(':checked')){
		PyFlag=1;
	}
	else{
		PyFlag=0;
	}
	var FyFlag=""
	if($('#CFyFlag').is(':checked')){
		FyFlag=1;
	}
	else{
		FyFlag=0;
	}
	var UseFlag=""
	if($('#CUseFlag').is(':checked')){
		UseFlag=1;
	}
	else{
		UseFlag=0;
	}
	var CheckFlag=""
	if($('#CheckFlag').is(':checked')){
		CheckFlag=1; 
	}
	else{
		CheckFlag=0;
	}
    var retValue= tkMakeServerCall("web.DHCOutPhCode","insertPhPerson",locId,UserName,UserCode,PyFlag,FyFlag,UseFlag,CheckFlag);
    if(retValue==-1){
	    $.messager.alert('��Ϣ��ʾ',"�����������ظ�����!");
    }else if (retValue==-2){
	   	$.messager.alert('��Ϣ��ʾ',"��������ҩ������ά������ά��ѡ��Ŀ���!");
	}
    else{
	    $('#pharmacystaffdg').datagrid('reload');
	    $.messager.alert('��Ϣ��ʾ',"���ӳɹ�!");
    }
}


///ҩ����Ա�����޸�
function Update()
{
	var seletcted = $("#pharmacystaffdg").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert('��ʾ',"��ѡ����Ҫ�޸ĵ�����!","info");
	}
	var RowId=seletcted.TPhpid;
	var UserId=seletcted.TUserId;
	var PyFlag=""
	if($('#CPyFlag').is(':checked')){
		PyFlag=1;
	}
	else{
		PyFlag=0;
	}
	var FyFlag=""
	if($('#CFyFlag').is(':checked')){
		FyFlag=1;
	}
	else{
		FyFlag=0;
	}
	var UseFlag=""
	if($('#CUseFlag').is(':checked')){
		UseFlag=1;
	}
	else{
		UseFlag=0;
	}
	var CheckFlag=""
	if($('#CheckFlag').is(':checked')){
		CheckFlag=1; 
	}
	else{
		CheckFlag=0;
	}
    var retValue=tkMakeServerCall("web.DHCOutPhCode","updatePhPerson",RowId,PyFlag,FyFlag,UseFlag,UserId,CheckFlag);
    if(retValue==0){
		$('#pharmacystaffdg').datagrid('reload');
    	$.messager.alert('��Ϣ��ʾ',"�޸ĳɹ�!");
    }
    else{
    	$.messager.alert('��Ϣ��ʾ',"�޸�ʧ��!");
    }
}

///ҩ����Ա����ɾ��
function Delete(){
	var seletcted = $("#pharmacystaffdg").datagrid("getSelected");
	var RowId=seletcted.TPhpid
	$.messager.confirm('��Ϣ��ʾ',"ȷ��ɾ����",function(r){
		if(r){
			var retValue=tkMakeServerCall("web.DHCOutPhCode","deletePhPerson",RowId);
			if(retValue==0){
				$('#pharmacystaffdg').datagrid('reload');
				$.messager.alert('��Ϣ��ʾ',"ɾ���ɹ�!");
			}
			else{
				$.messager.alert('��Ϣ��ʾ',"ɾ��ʧ��!");
			}
		}
	});
}


///ҩ����Ա�����ѯ
function Query()
{
	var LocId=$("#CLocDesc").combobox('getValue');
	if ($.trim($("#CLocDesc").combobox('getText'))==""){
		LocId="";	
	}
	var UserId=$("#CUserName").combobox('getValue');
	if ($.trim($("#CUserName").combobox('getText'))==""){
		UserId="";	
	}
	var UserCode=$("#CUserCode").val();
    var PyFlag=""
	if($('#CPyFlag').is(':checked')){
		PyFlag=1;
	}
	else{
		PyFlag=0;
	}
	var FyFlag=""
	if($('#CFyFlag').is(':checked')){
		FyFlag=1;
	}
	else{
		FyFlag=0;
	}
	var UseFlag=""
	if($('#CUseFlag').is(':checked')){
		UseFlag=1;
	}
	else{
		UseFlag=0;
	}
	var CheckFlag=""
	if($('#CheckFlag').is(':checked')){
		CheckFlag=1; 
	}
	else{
		CheckFlag=0;
	}
	var params=LocId+"^"+UserId+"^"+UserCode+"^"+PyFlag+"^"+FyFlag+"^"+UseFlag+"^"+CheckFlag;
	$('#pharmacystaffdg').datagrid('loadData',{total:0,rows:[]});
	$('#pharmacystaffdg').datagrid({
     	url:url+'?action=GetPharmacyStaffList',
     	queryParams:{
			params:params
     	}
	});
}

function Clear(){
	$("#CLocDesc").combobox('setValue',session['LOGON.CTLOCID']);
	$("#CUserName").combobox('setValue','');
	$("#CUserCode").val('');
	$("#CheckFlag").prop("checked",false);
	$("#CPyFlag").prop("checked",false);
	$("#CFyFlag").prop("checked",false);
	$("#CUseFlag").prop("checked",false);
	$('#pharmacystaffdg').datagrid('loadData',{total:0,rows:[]});
	$('#pharmacystaffdg').datagrid({
     	url:url+'?action=GetPharmacyStaffList',
     	queryParams:{
			params:""
		}
	});
}

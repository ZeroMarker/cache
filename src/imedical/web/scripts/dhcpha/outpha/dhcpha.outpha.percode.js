/*
模块:门诊药房
子模块:门诊药房-首页-侧菜单-药房人员代码维护
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
	$('#BSearch').bind('click', Query);//点击查询
	$('#BAdd').bind('click', Add);//点击增加
	$('#BUpdate').bind('click', Update);//点击修改
	$('#BClear').bind('click', Clear);//点击清屏幕
});


//初始化药房名称
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


//初始化药房人员
function InitCUserName()
{
	$('#CUserName').combobox({  
		panelWidth: 150,
		url:commonOutPhaUrl+'?action=GetLocAllUserDs&params='+gLocId+'',
		valueField:'RowId',  
		textField:'Desc'
	});	
}


//初始化药房人员列表
function InitPharmacyStaffList(){
	//定义columns
	var columns=[[
        {field:'TPhpid',title:'RowId',width:200,hidden:true},
        {field:'TPhlid',title:'TPhlid',width:100,hidden:true},
        {field:'TUserId',title:'TUserId',width:100,hidden:true},
        {field:'TCtLocId',title:'TCtLocId',width:100,hidden:true},
	    {field:'TLocDesc',title:'药房名称',width:200},
	    {field:'TUserCode',title:'人员代码',width:100},
        {field:'TUserName',title:'姓名',width:100}, 
        {field:'TCheckFlag',title:'审核',width:75,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon; 
	        	}else{
		        	return gridUnChkIcon;
		        }
	        }
        },
        {field:'TPyFlag',title:'配药',width:75,align:'center',
            formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon; 
	        	}else{
		        	return gridUnChkIcon;
		        }
	        }
        },
        {field:'TFyFlag',title:'发药',width:75,align:'center',
            formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon; 
	        	}else{
		        	return gridUnChkIcon;
		        }
	        }
        },
        {field:'TUseFlag',title:'无效',width:75,align:'center',
            formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon; 
	        	}else{
		        	return gridUnChkIcon;
		        }
	        }
        }
	]];  
	
   //定义datagrid	
   $('#pharmacystaffdg').datagrid({    
        url:url+'?action=GetPharmacyStaffList',
        fit:true,
	    border:false,
	    striped:true,
	    toolbar:'#btnbar',
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
        pageSize:30,  // 每页显示的记录条数
	    pageList:[30,50,100],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
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
				if(pyflag=="是")
				{
					$("#CPyFlag").prop("checked",true);
				}
				else
				{
					$("#CPyFlag").prop("checked",false);
				}
				if(fyflag=="是")
				{
					$("#CFyFlag").prop("checked",true);
				}
				else
				{
					$("#CFyFlag").prop("checked",false);
				}
				if(useflag=="是")
				{
					$("#CUseFlag").prop("checked",true);
				}
				else
				{
					$("#CUseFlag").prop("checked",false);
				}
				if(checkflag=="是")
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


///药房人员代码增加
function Add()
{
	var locId=$("#CLocDesc").combobox('getValue');
	if ($('#CLocDesc').combobox("getText")==""){
		$.messager.alert('错误提示',"请选择药房名称!");
		return;
	}
	var UserName=$("#CUserName").combobox('getText');
	if ($('#CUserName').combobox("getText")==""){
		$.messager.alert('错误提示',"请选择药房人员!");
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
	    $.messager.alert('信息提示',"不允许添加重复数据!");
    }else if (retValue==-2){
	   	$.messager.alert('信息提示',"请在门诊药房科室维护中先维护选择的科室!");
	}
    else{
	    $('#pharmacystaffdg').datagrid('reload');
	    $.messager.alert('信息提示',"添加成功!");
    }
}


///药房人员代码修改
function Update()
{
	var seletcted = $("#pharmacystaffdg").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert('提示',"请选择需要修改的数据!","info");
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
    	$.messager.alert('信息提示',"修改成功!");
    }
    else{
    	$.messager.alert('信息提示',"修改失败!");
    }
}

///药房人员代码删除
function Delete(){
	var seletcted = $("#pharmacystaffdg").datagrid("getSelected");
	var RowId=seletcted.TPhpid
	$.messager.confirm('信息提示',"确认删除吗？",function(r){
		if(r){
			var retValue=tkMakeServerCall("web.DHCOutPhCode","deletePhPerson",RowId);
			if(retValue==0){
				$('#pharmacystaffdg').datagrid('reload');
				$.messager.alert('信息提示',"删除成功!");
			}
			else{
				$.messager.alert('信息提示',"删除失败!");
			}
		}
	});
}


///药房人员代码查询
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


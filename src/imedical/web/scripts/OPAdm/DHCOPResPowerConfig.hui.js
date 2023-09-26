var PageLogicObj={
	m_MarkListTabDataGrid:"",
	m_selLocId:"",
	m_selMarkId:""
};
$(function(){
	//初始化医院
	var hospComp = GenHospComp("Doc_OPAdm_GroupResAuth");
	hospComp.jdata.options.onSelect = function(e,t){
		PageLogicObj.m_selLocId="";
		PageLogicObj.m_selMarkId="";
		$("#Dept,#Mark").lookup('setText',"");
		MarkListTabDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		//页面元素初始化
		PageHandle();
	}
	//事件初始化
	InitEvent();	
	$("#Dept").focus();
});
function Init(){
	InitDeptLookup();
	InitMarkLookup();
	PageLogicObj.m_MarkListTabDataGrid=InitMarkListTabDataGrid();
	initResRegPowerWin();
	initResSchedulePowerWin();
}
function InitEvent(){
	$("#Bfind").click(MarkListTabDataGridLoad);
}
function PageHandle(){
	MarkListTabDataGridLoad();
}
function InitMarkListTabDataGrid(){
	var Columns=[[ 
		{field:'LocDesc',title:'科室',width:200},
		{field:'CTPCPDesc',title:'医生号别',width:150},
		{field:'RESRowId',title:'挂号授权',width:100,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="ShowResPowerReg(\'' + row.RESRowId + '\')">挂号授权</a>';
				return btn;
			}
		},
		{field:'LocId',title:'排班授权',width:100,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="ShowResPowerSchedule(\'' + row.RESRowId + '\')">排班授权</a>';
				return btn;
			}
		}
    ]]
	var MarkListTabDataGrid=$("#MarkListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'RESRowId',
		columns :Columns
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	return MarkListTabDataGrid;
}
function InitDeptLookup(){
	//科室
	$("#Dept").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'id',
        textField:'name',
        columns:[[  
            {field:'id',title:'ID'},
			{field:'name',title:'科室',width:330}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:410,
        isCombo:true,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.DHCDocConfig.CommonFunction',QueryName: 'QueryLoc'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        param = $.extend(param,{depname:desc,LogHospId:$HUI.combogrid('#_HospList').getValue()});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					PageLogicObj.m_selLocId=rec["id"];
					PageLogicObj.m_selMarkId="";
					$("#Mark").lookup('setText',"");
					$("#Mark").focus();
					MarkListTabDataGridLoad();
				}
			});
		}
    });
}
function InitMarkLookup(){
	//号别
	$("#Mark").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowID',
        textField:'Desc',
        columns:[[  
            {field:'RowID',title:'ID'},
			{field:'Desc',title:'号别',width:330}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:410,
        isCombo:true,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCExaBorough',QueryName: 'FindDoc'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        param = $.extend(param,{depid:GetSelLocId(),docname:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					PageLogicObj.m_selMarkId=rec["RowID"];
					MarkListTabDataGridLoad();
				}
			});
		}
    });
}
function GetSelLocId(){
	var LocDesc=$("#Dept").lookup("getText");
    if (LocDesc=="") {
	    PageLogicObj.m_selLocId="";
    }
    return PageLogicObj.m_selLocId;
}
function GetSelMarkId(){
	var MarkDesc=$("#Mark").lookup("getText");
    if (MarkDesc=="") {
	    PageLogicObj.m_selMarkId="";
    }
    return PageLogicObj.m_selMarkId;
}
function MarkListTabDataGridLoad(){
	var LocId=GetSelLocId();
	var MarkId=GetSelMarkId();
	$.q({
	    ClassName : "web.DHCOPAdmPowerConfig",
	    QueryName : "FindResList",
	    DeptId:LocId,
	    MarkId:MarkId,
	    Pagerows:PageLogicObj.m_MarkListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_MarkListTabDataGrid.datagrid("uncheckAll").datagrid('loadData',GridData);
	}); 
}
/****挂号授权****/
function ShowResPowerReg(ResRowId){
	$('#res-regpower-win-search').searchbox('setValue','');
	$('#res-regpower-win-id').val(ResRowId);
	$('#res-regpower-win-list').datagrid('options').url='websys.Broker.cls';
	$('#res-regpower-win-list').datagrid('unselectAll').datagrid('load',{ClassName:'web.DHCOPAdmPowerConfig',QueryName:'FindGroupByRes',ResRowId:ResRowId,groupDesc:'',HospRowId:$HUI.combogrid('#_HospList').getValue()});
	$('#res-regpower-win').dialog('open');
}
function initResRegPowerWin(){
	var winH=$(window).height()||550-120;
	var winW=430;
	$('#res-regpower-win').dialog({
		height:winH,
		width:winW,
		title:'挂号授权',
		buttons:[
			{
				text:'保存',
				handler:saveResRegPower
			},
			{
				text:'关闭',
				handler:function(){
					$('#res-regpower-win').dialog('close');
				}	
			}
		]
	});
	$('#res-regpower-win-search').searchbox({
		width:winW-20-10,
		searcher:function(value){
			var ResRowId=$('#res-regpower-win-id').val();
			$('#res-regpower-win-list').datagrid('load',{ClassName:'web.DHCOPAdmPowerConfig',QueryName:'FindGroupByRes',ResRowId:ResRowId,groupDesc:value,HospRowId:$HUI.combogrid('#_HospList').getValue()});
		}
	})
	$('#res-regpower-win-list').datagrid({
		width:winW-20,
		height:winH-207+110,
		bodyCls:'panel-header-gray',
		singleSelect:true,
		pagination:true,
		pageSize:30,
		columns:[[
			{field:'GroupDesc',title:'安全组',width:300},
			
			{field:'GrantedFlag',title:'挂号授权',width:80,align:'center',formatter:function(value,row,index){
				return "<label class='checkbox-label'><input type='checkbox' data-id='"+row.GroupId+"'  "+(value=="1"?"checked":"")+"/> </label>";
			}},
			{field:'GroupId',title:'ID',hidden:true}
		]],
		idField:'GroupId',
		url:"",
		lazy:true,
		toolbar:'#res-regpower-win-list-tb'
	})
}
function saveResRegPower(){
	var ResRowId=$('#res-regpower-win-id').val();
	var data={ClassName:'web.DHCOPAdmPowerConfig',MethodName:'SaveResRegPower',ResRowId:ResRowId};
	$('#res-regpower-win .checkbox-label>input').each(function(i){
		data["GroupIdz"+i]=$(this).data('id');
		if($(this).is(':checked')){
			data["GrantedFlagz"+i]='on';
		}
	})
	$.m(data,function(rtn){
		if(rtn==0){
			$.messager.popover({msg:'授权保存成功',type:'success',timeout:1000});
		}
	})
}
/****排班授权****/
function initResSchedulePowerWin(){
	var winH=$(window).height()||550-120;
	var winW=430;
	$('#res-schedulepower-win').dialog({
		height:winH,
		width:winW,
		title:'排班授权',
		buttons:[
			{
				text:'保存',
				handler:saveResSchedulePower
			},
			{
				text:'关闭',
				handler:function(){
					$('#res-schedulepower-win').dialog('close');
				}	
			}
		]
	});
	$('#res-schedulepower-win-search').searchbox({
		width:winW-20-10,
		searcher:function(value){
			var ResRowId=$('#res-schedulepower-win-id').val();
			$('#res-schedulepower-win-list').datagrid('load',{ClassName:'web.DHCOPAdmPowerConfig',QueryName:'FindUserByRes',ResRowId:ResRowId,userDesc:value});
		}
	})
	$('#res-schedulepower-win-list').datagrid({
		width:winW-20,
		height:winH-207+110,
		bodyCls:'panel-header-gray',
		singleSelect:true,
		pagination:true,
		pageSize:30,
		columns:[[
			{field:'UserName',title:'排班员',width:300},
			
			{field:'GrantedFlag',title:'排班授权',width:80,align:'center',formatter:function(value,row,index){
				return "<label class='checkbox-label'><input type='checkbox' data-id='"+row.UserId+"'  "+(value=="1"?"checked":"")+"/> </label>";
			}},
			{field:'UserId',title:'ID',hidden:true}
		]],
		idField:'UserId',
		url:"",
		lazy:true,
		toolbar:'#res-schedulepower-win-list-tb'
	})
}

function ShowResPowerSchedule(ResRowId){
	$('#res-schedulepower-win-search').searchbox('setValue','');
	$('#res-schedulepower-win-id').val(ResRowId);
	$('#res-schedulepower-win-list').datagrid('options').url='websys.Broker.cls';
	$('#res-schedulepower-win-list').datagrid('unselectAll').datagrid('load',{ClassName:'web.DHCOPAdmPowerConfig',QueryName:'FindUserByRes',ResRowId:ResRowId,userDesc:'',HospRowId:$HUI.combogrid('#_HospList').getValue()});
	$('#res-schedulepower-win').dialog('open');
}
function saveResSchedulePower(){
	var ResRowId=$('#res-schedulepower-win-id').val();
	var data={ClassName:'web.DHCOPAdmPowerConfig',MethodName:'SaveResSchedulePower',ResRowId:ResRowId};
	$('#res-schedulepower-win .checkbox-label>input').each(function(i){
		data["UserIdz"+i]=$(this).data('id');
		if($(this).is(':checked')){
			data["GrantedFlagz"+i]='on';
		}
	})
	$.m(data,function(rtn){
		if(rtn==0){
			$.messager.popover({msg:'授权保存成功',type:'success',timeout:1000});
		}
	})
}
/*var arrayObj=new Array(
   new Array("List_WYInstr","WYInstr"),
   new Array("List_NotFollowInstr","NotFollowInstr"),
   new Array("List_SkinTestInstr","SkinTestInstr"),
   new Array("List_IPDosingInstr","IPDosingInstr"),
   new Array("List_OPInfusionInstr","OPInfusionInstr"),
   new Array("List_DrippingSpeedInstr","DrippingSpeedInstr")
);
$(function(){
	InitHospList();
    $('#Confirm').click(SaveInstrConfig)
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_InstrConfig");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		InitCache();
	}
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function Init(){
	for( var i=0;i<arrayObj.length;i++) {
		   var param1=arrayObj[i][0];
		   var param2=arrayObj[i][1];
	       LoadInstrData(param1,param2);	    
   }
}
function LoadInstrData(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.InstrConfig", 
		QueryName:"FindTypeInstr",
		value:param2,
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
	    selectlist=selectlist+"^"+n.selected
        vlist += "<option value=" + n.InstrRowID + ">" + n.InstrDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
							
};
function SaveInstrConfig()
{
	var DataList=""
   for( var i=0;i<arrayObj.length;i++) {
	   var InstrStr=""
	   var param1=arrayObj[i][0];
	   var param2=arrayObj[i][1];
	   var size = $("#" + param1 + " option").size();
	   if(size>0){
			$.each($("#"+param1+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (InstrStr=="") InstrStr=svalue
			  else InstrStr=InstrStr+"^"+svalue
			})
			DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+InstrStr
	   }	   
   }
   var value=$.cm({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"SaveConfig",
		Coninfo:DataList,
		HospId:$HUI.combogrid('#_HospList').getValue(),
	},false);
	if(value=="0"){
		$.messager.show({title:"提示",msg:"保存成功"});					
	}
}*/
$(function(){  
	InitHospList();
})
function InitHospList(){
	var hospComp = GenHospComp("Doc_BaseConfig_SubCatContral");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#InstrListTab").datagrid("reload");
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		InitCache();
	}
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function Init(){
	InitInstrConfigTab();
	InitInstrListTab();
}
function InitInstrConfigTab(){
	var Columns=[[    
		{ field: 'text', title: '特殊用法配置项', width: 200}					
	]];
	$("#InstrConfigTab").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : $URL+"?ClassName=DHCDoc.DHCDocConfig.InstrConfig&QueryName=FindInstrConfigList",
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"id",
		pageSize:20,
		pageList : [20,50,100,200],
		columns :Columns,
		onBeforeLoad:function(param){
			$.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
			$("#InstrConfigTab").datagrid("unselectAll");
		},
		onClickRow:function(index, row){
			$("#InstrListTab").datagrid("reload",{value:row.id});
		}
	});
}
function InitInstrListTab(){
	var ToolBar = [{
        text: '保存配置项数据',
        iconCls: 'icon-save',
        handler: function() { 
        	SaveInstrDataByConfig();
        }
    }]
	var Columns=[[ 
		{ field: 'InstrRowID', checkbox: true},   
		{ field: 'InstrDesc', title: '用法', width: 200,
			formatter:function(v,rec){
				if(rec.InstrActive!="Y"){
					
					return '<span style="color:red">'+v+"(未激活)"+'</span>';
				}else{
					return v;	
				}
			}
		},
		{ field: 'InstrActive', title: '是否激活', width: 100,hidden:true},
		{ field: 'selected', title: '已有配置项', width: 90,
			formatter:function(v,rec){
				return '<a href="#this" class="editcls1" onclick="ShowInstrConfig('+(rec.InstrRowID)+')">&nbsp</a>';
			}
		}
	]];
	$("#InstrListTab").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		url : $URL+"?ClassName=DHCDoc.DHCDocConfig.InstrConfig&QueryName=FindTypeInstr&value=&PassCMInstr=Y&rows=99999",
		loadMsg : '加载中..',  
		pagination : false,  
		rownumbers : false, 
		idField:"InstrRowID",
		columns :Columns,
		toolbar:ToolBar,
		onBeforeLoad:function(param){
			$.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
			$("#InstrListTab").datagrid("unselectAll");
		},
		onLoadSuccess:function(data){
			$('.editcls1').linkbutton({text:'&nbsp',plain:true,iconCls:'icon-search'});
			for (var i=0;i<data.total;i++){
				if (data.rows[i].selected) {
					$("#InstrListTab").datagrid("selectRow",i);
				}	
			}
			setTimeout(function() {
				$("#InstrListTab").datagrid("scrollTo",0);
			})
		}
	});
}
function SaveInstrDataByConfig(){
	var HospId=$HUI.combogrid('#_HospList').getValue();
	var row=$("#InstrConfigTab").datagrid("getChecked");
	if (row.length ==0) {
		 $.messager.alert('提示',"请选择配置项！");
		 return;
	}
	var param2=row[0].id;
	var InstrIDStr="";
	var rows=$("#InstrListTab").datagrid("getChecked");
	for (var i=0;i<rows.length;i++){
		if (InstrIDStr=="") InstrIDStr=rows[i].InstrRowID;
		else InstrIDStr=InstrIDStr+"^"+rows[i].InstrRowID;
	}
	var DataList=param2+String.fromCharCode(1)+InstrIDStr;
	var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"SaveConfig",
		Coninfo:DataList,
		HospId:HospId
	},false);
	if(value=="0"){
		$.messager.popover({msg: '保存成功！',type:'success'});
	}
}
function ShowInstrConfig(InstrRowID){
	var index=$("#InstrListTab").datagrid("getRowIndex",InstrRowID);
	var rows=$("#InstrListTab").datagrid("getRows");
	$("#dialog-InstrHasConfig").dialog('setTitle',"用法<span style='color:yellow;'>"+rows[index].InstrDesc +"</span>已有配置项列表").dialog("open");
	InitInstrHasConfigTab(InstrRowID);
}
function InitInstrHasConfigTab(InstrRowID){
	var ToolBar = [{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { 
        	SaveInstrConfigBySubInstrId();
        }
    }]
	var Columns=[[
		{ field: 'id', checkbox: true},   
		{ field: 'text', title: '配置项', width: 350}
	]];
	$("#InstrHasConfigTab").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		url : $URL+"?ClassName=DHCDoc.DHCDocConfig.InstrConfig&QueryName=FindInstrConfigList&InstrRowId="+InstrRowID+"&rows=99999",
		loadMsg : '加载中..',  
		pagination : false,  
		rownumbers : false, 
		idField:"id",
		columns :Columns,
		toolbar:ToolBar,
		onBeforeLoad:function(param){
			$.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
			$("#InstrHasConfigTab").datagrid("unselectAll");
		},
		onLoadSuccess:function(data){
			for (var i=0;i<data.total;i++){
				if (data.rows[i].InstrHasConfigFlag =="Y") {
					$("#InstrHasConfigTab").datagrid("selectRow",i);
				}	
			}
			setTimeout(function() {
				$("#InstrHasConfigTab").datagrid("scrollTo",0);
			})
		}
	});
}
function SaveInstrConfigBySubInstrId(){
	var HospId=$HUI.combogrid('#_HospList').getValue();
	var url=$("#InstrHasConfigTab").datagrid("options").url;
	var InstrRowId=GetQueryString(url,"InstrRowId");
	var ConfigIdStr="";
	var rows=$("#InstrHasConfigTab").datagrid("getChecked");
	for (var i=0;i<rows.length;i++){
		if (ConfigIdStr=="") ConfigIdStr=rows[i].id;
		else ConfigIdStr=ConfigIdStr+"^"+rows[i].id;
	}
	$.m({ 
		ClassName:"DHCDoc.DHCDocConfig.InstrConfig", 
		MethodName:"SaveInstrConfigByInstrId",
		ConfigIdStr:ConfigIdStr,
		InstrRowId:InstrRowId,
		HospId:HospId
	},function(value){
		if(value=="0"){
			$.messager.popover({msg: '保存成功！',type:'success'});
		}
	});
}
function GetQueryString(url,name) { 
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i"); 
    var r = url.substr(1).match(reg);  //获取url中"?"符后的字符串并正则匹配
    var context = ""; 
    if (r != null) 
         context = r[2]; 
    reg = null; 
    r = null; 
    return context == null || context == "" || context == "undefined" ? "" : context; 
}
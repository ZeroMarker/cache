$(function(){
	InitHospList();
})
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_TechOrdExcuteCfg");
	hospComp.jdata.options.onSelect = function(e,t){
		$('#OrdItemCatTab,#OrdItemCatTab1').datagrid('unselectAll').datagrid('reload');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitOrdItemCatTab();
		InitOrdItemCatTab1();
	}
	$('#OpenForAllHosp').next().after($('<a></a>').linkbutton({
        plain:true,
        iconCls:'icon-help'
    }).tooltip({
        content:"勾选后医技执行/执行记录执行页面接收科室显示登录账号下其他院区可登录科室。"
    }));
    $("#searchTypeTip").tooltip({
	    tipWidth:'300px',
		position: 'bottom',
		content: '<p>按开单科室查询：开单科室必填，查询开单科室科室为可登陆科室的医嘱，默认显示当前登录科室。</p>'+
				 '<p>按接收科室查询：接收科室必填，查询接收科室科室为可登陆科室的医嘱，默认显示当前登录科室。</p>'
	})
}
function InitOrdItemCatTab(){
	$("#tab-div").css("height",$(window).height()-204);
	var Columns=[[    
		{ field: 'ItemCatRowId', checkbox:true},
		{ field: 'ItemCatDesc', title: '医嘱子类', width: 80}
    ]];
	$('#OrdItemCatTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=CF.NUR.NIS.TechOrdExcuteCfg&QueryName=GetItemCatList&rows=9999",
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"ItemCatRowId",
		columns :Columns,
		onLoadSuccess:function(data){
			$.cm({
				 ClassName:"CF.NUR.NIS.TechOrdExcuteCfg",
				 MethodName:"GetConfig",
				 HospId:$HUI.combogrid('#_HospList').getValue(),
				 dataType:"text"
			},function(data){
				var OpenForAllHosp=data.split(String.fromCharCode(1))[0];
				var ItemCats=data.split(String.fromCharCode(1))[1];
				var LoginPageDefaultQuery=data.split(String.fromCharCode(1))[2];
				$("#OpenForAllHosp").checkbox("setValue",OpenForAllHosp=="Y"?true:false);
				$("#LoginPageDefaultQuery").checkbox("setValue",LoginPageDefaultQuery=="Y"?true:false);
				for (var i=0;i<ItemCats.split("^").length;i++){
					var index=$('#OrdItemCatTab').datagrid("getRowIndex",ItemCats.split("^")[i]);
					if (index>=0){
						$('#OrdItemCatTab').datagrid("selectRow",index);
					}
				}
			});
		},
		onBeforeLoad:function(param){
			$('#OrdItemCatTab').datagrid("unselectAll");
			param = $.extend(param,{
				HospId:$HUI.combogrid('#_HospList').getValue(),
				desc:$("#SearchDesc").searchbox("getValue").toUpperCase(),
				filter:$("#filter").combobox('getValue')
			});
		}
	});
}
function saveSet(){
	var tab = $('#tabs').tabs('getSelected');
	var index = $('#tabs').tabs('getTabIndex',tab);
	if (index ==0){
		var OpenForAllHosp=$("#OpenForAllHosp").checkbox("getValue")?"Y":"N";
		var LoginPageDefaultQuery=$("#LoginPageDefaultQuery").checkbox("getValue")?"Y":"N";
		var rows=$('#OrdItemCatTab').datagrid('getRows');
		/*if (rows.length==0) {
			$.messager.alert("提示","没有需要保存的数据!");
			return false;
		}*/
		var GridSelectArr=$('#OrdItemCatTab').datagrid('getSelections');
		var inItemCatPara="",subItemCatPara="";
		for (var i=0;i<rows.length;i++){
			var ItemCatRowId=rows[i].ItemCatRowId;
			if ($.hisui.indexOfArray(GridSelectArr,"ItemCatRowId",ItemCatRowId)>=0) {
				if (inItemCatPara == "") inItemCatPara = ItemCatRowId;
				else  inItemCatPara = inItemCatPara + "^" + ItemCatRowId;
			}else{
				if (subItemCatPara == "") subItemCatPara = ItemCatRowId;
				else  subItemCatPara = subItemCatPara + "^" + ItemCatRowId;
			}
		}
		$.cm({
			 ClassName:"CF.NUR.NIS.TechOrdExcuteCfg",
			 MethodName:"SaveConfig",
			 OpenForAllHosp:OpenForAllHosp,
			 LoginPageDefaultQuery:LoginPageDefaultQuery,
			 inItemCatPara:inItemCatPara,
		     subItemCatPara:subItemCatPara,
			 HospId:$HUI.combogrid('#_HospList').getValue(),
			 dataType:"text"
		},function(rtn){
			if (rtn ==0){
				return $.messager.popover({ msg: "保存成功！", type:'success' });	
			}else{
				return $.messager.popover({ msg: "保存失败！"+rtn, type:'error' });	
			}
		});
	}else{
		var OpenForAllHosp=$("#OpenForAllHosp").checkbox("getValue")?"Y":"N";
		var SearchType=$("#SearchType").combobox('getValue');
		var rows=$('#OrdItemCatTab1').datagrid('getRows');
		/*if (rows.length==0) {
			$.messager.alert("提示","没有需要保存的数据!");
			return false;
		}*/
		var GridSelectArr=$('#OrdItemCatTab1').datagrid('getSelections');
		var inItemCatPara="",subItemCatPara="";
		for (var i=0;i<rows.length;i++){
			var ItemCatRowId=rows[i].ItemCatRowId;
			if ($.hisui.indexOfArray(GridSelectArr,"ItemCatRowId",ItemCatRowId)>=0) {
				if (inItemCatPara == "") inItemCatPara = ItemCatRowId;
				else  inItemCatPara = inItemCatPara + "^" + ItemCatRowId;
			}else{
				if (subItemCatPara == "") subItemCatPara = ItemCatRowId;
				else  subItemCatPara = subItemCatPara + "^" + ItemCatRowId;
			}
		}
		$.cm({
			 ClassName:"CF.NUR.NIS.TechOrdExcuteCfg",
			 MethodName:"SaveOrdExecConfig",
			 SearchType:SearchType,
			 inItemCatPara:inItemCatPara,
		     subItemCatPara:subItemCatPara,
		     OpenForAllHosp:OpenForAllHosp,
			 HospId:$HUI.combogrid('#_HospList').getValue(),
			 dataType:"text"
		},function(rtn){
			if (rtn ==0){
				return $.messager.popover({ msg: "保存成功！", type:'success' });	
			}else{
				return $.messager.popover({ msg: "保存失败！"+rtn, type:'error' });	
			}
		});
	}
}
function filterTabData(){
	$('#OrdItemCatTab').datagrid("reload");
}
function filterTabData1(){
	$('#OrdItemCatTab1').datagrid("reload");
}
function InitOrdItemCatTab1(){
	$("#tab-div1").css("height",$(window).height()-244);
	var Columns=[[    
		{ field: 'ItemCatRowId', checkbox:true},
		{ field: 'ItemCatDesc', title: '医嘱子类', width: 80}
    ]];
	$('#OrdItemCatTab1').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=CF.NUR.NIS.TechOrdExcuteCfg&QueryName=GetItemCatList&rows=9999",
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"ItemCatRowId",
		columns :Columns,
		onLoadSuccess:function(data){
			$.cm({
				 ClassName:"CF.NUR.NIS.TechOrdExcuteCfg",
				 MethodName:"GetOrdEexecConfig",
				 SearchType:$("#SearchType").combobox('getValue'),
				 HospId:$HUI.combogrid('#_HospList').getValue(),
				 dataType:"text"
			},function(ItemCats){
				for (var i=0;i<ItemCats.split("^").length;i++){
					var index=$('#OrdItemCatTab1').datagrid("getRowIndex",ItemCats.split("^")[i]);
					if (index>=0){
						$('#OrdItemCatTab1').datagrid("selectRow",index);
					}
				}
			});
		},
		onBeforeLoad:function(param){
			$('#OrdItemCatTab1').datagrid("unselectAll");
			param = $.extend(param,{
				HospId:$HUI.combogrid('#_HospList').getValue(),
				desc:$("#SearchDesc1").searchbox("getValue").toUpperCase(),
				filter:$("#filter1").combobox('getValue'),
				SearchType:$("#SearchType").combobox('getValue'),
			});
		}
	});
}

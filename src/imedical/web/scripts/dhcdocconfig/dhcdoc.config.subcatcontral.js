/*var arrayObj = new Array(
      new Array("List_FrequencedItemCat","FrequencedItemCat"),
      new Array("List_NeedExecCat","NeedExecCat"),
      new Array("List_NotAlertRepeatItemCat","NotAlertRepeatItemCat"),
      new Array("List_OPUnRepeatItemCat","OPUnRepeatItemCat"),
      new Array("List_NoDisplayItemCat","NoDisplayItemCat"), 
      new Array("List_CheckItemCat","CheckItemCat"),
      new Array("List_MedItemCat","MedItemCat"),
      new Array("List_CPMedItemCat","CPMedItemCat"),
      new Array("List_LimitMedItemCat","LimitMedItemCat"),
      new Array("List_PreciousDrugItemCat","PreciousDrugItemCat"),	
      new Array("List_AllowEntryDecimalItemCat","AllowEntryDecimalItemCat"), 
      new Array("List_NotAlertZeroItemCat","NotAlertZeroItemCat"),	  
      new Array("List_StopAllExecItemCat","StopAllExecItemCat"),
	  new Array("List_TreatItemCat","TreatItemCat"),
	  new Array("List_SelectInstrNotDrugCat","SelectInstrNotDrugCat"),
	  new Array("List_IssuedNotCancelItemCat","IssuedNotCancelItemCat"),	 
	  new Array("List_IPNecessaryCat","IPNecessaryCat"),
	  new Array("List_NotSamePriorNeedAlertItemCat","NotSamePriorNeedAlertItemCat"),
	  new Array("List_NotLinkItemCat","NotLinkItemCat"),
	  new Array("List_OPAutoDurCat","OPAutoDurCat"),
	  new Array("List_AfterNurDealCanUnuseItemCat","AfterNurDealCanUnuseItemCat")
);
var arrayObj1=new Array(
      new Array("Combo_FrequencedItemFreq","FrequencedItemFreq"),
      new Array("Combo_NeedExecFreq","NeedExecFreq")
);
var arrayObj2=new Array(
      new Array("Combo_FrequencedItemDur","FrequencedItemDur"),
      new Array("Combo_NeedExecDur","NeedExecDur")
);
$(function(){  
	InitHospList();
})
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_SubCatContral");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		InitCache();
	}
	$('#Confirm').click(SaveSubCatContral);
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function Init(){
   for( var i=0;i<arrayObj1.length;i++) {
	   var param1=arrayObj1[i][0];
	   var param2=arrayObj1[i][1];
	   LoadFreqData(param1,param2);
   }
   for( var i=0;i<arrayObj2.length;i++) {
	   var param1=arrayObj2[i][0];
	   var param2=arrayObj2[i][1];
	   LoadDurData(param1,param2);
   }
   for( var i=0;i<arrayObj.length;i++) {
	   var param1=arrayObj[i][0];
	   var param2=arrayObj[i][1];
       LoadData(param1,param2);	    
   }
   //初始化分类
	InitComboCategory()
	$("#List_ReSetOrdSubCat").empty();
	LoadSubData("List_ReSetOrdSubCat","")
    var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	var PropmtInfo=tkMakeServerCall("DHCDoc.DHCDocConfig.SubCatContral","GetPropmtInfo",HospID);
	$("#Prompt").html(PropmtInfo)
}
function LoadSubData(param1,param2){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.SubCatContral", 
		QueryName:"FindCatListNew",
		value:param2,
		HospId:HospID,
		rows:99999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
	    selectlist=selectlist+"^"+n.selected
        vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
}
function InitComboCategory()
{
	$("#Combo_Category").combobox({  
    	valueField:'Rowid',   
    	textField:'Desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.SubCatContral';
			param.QueryName = 'ReOrdSubCatList';
			param.ArgCnt =0;
		},
		onChange:function (catdr,o){
			$("#List_ReSetOrdSubCat").empty();
			LoadSubData("List_ReSetOrdSubCat",catdr)
		}
	});
}
function LoadData(param1,param2){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.SubCatContral", 
		QueryName:"FindCatList",
		value:param2,
		HospId:HospID,
		rows:99999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
	    selectlist=selectlist+"^"+n.selected
        vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
}
function LoadDurData(item,param2)
{
	$("#"+item+"").combobox({
		valueField:'DurRowId',   
    	textField:'DurCode',
    	url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindDurList&value="+param2+"&Type=XY&HospId="+$HUI.combogrid('#_HospList').getValue(),
    	loadFilter: function(data){
			return data['rows'];
		}
	});
}
function LoadFreqData(item,param2)
{
	$("#"+item+"").combobox({
		valueField:'FreqRowId',   
    	textField:'FreqCode',
    	url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindFreqList&value="+param2+"&Type=&HospId="+$HUI.combogrid('#_HospList').getValue(),
    	loadFilter: function(data){
			return data['rows'];
		}
	});
}

function SaveSubCatContral()
{
	var HospId=$HUI.combogrid('#_HospList').getValue();
	var DataList=""
	for( var i=0;i<arrayObj1.length;i++) {
	   var param1=arrayObj1[i][0];
	   var param2=arrayObj1[i][1];
	   var FrequencedItemFreq=$("#"+param1+"").combobox('getValue');
	   if (!FrequencedItemFreq) FrequencedItemFreq="";
	   DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+FrequencedItemFreq
   }
   for( var i=0;i<arrayObj2.length;i++) {
	   var param1=arrayObj2[i][0];
	   var param2=arrayObj2[i][1];
	   var DurationItemDur=$("#"+param1+"").combobox('getValue');
	   if (!DurationItemDur) DurationItemDur="";
	   DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+DurationItemDur
   }
   for( var i=0;i<arrayObj.length;i++) {
	   var CatIDStr=""
	   var param1=arrayObj[i][0];
	   var param2=arrayObj[i][1];
	   var size = $("#" + param1 + " option").size();
	   if(size>0){
			$.each($("#"+param1+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (CatIDStr=="") CatIDStr=svalue
			  else CatIDStr=CatIDStr+"^"+svalue
			})
			DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+CatIDStr
	   }	   
   }
   var ComboValue=$("#Combo_Category").combobox('getValue');
   if(ComboValue!=""){
		var CatIDStr=""
		var size = $("#List_ReSetOrdSubCat"  + " option").size();
		if(size>0){
			$.each($("#List_ReSetOrdSubCat"+" option:selected"), function(i,own){
	            var svalue = $(own).val();
				if (CatIDStr=="") CatIDStr=svalue
				else CatIDStr=CatIDStr+"^"+svalue
			})
		}
		var objScope=$.m({ 
			ClassName:"web.DHCDocConfig", 
			MethodName:"SaveConfig1",
			Node:"DHCDocReSetOrdSubCat",
			Node1:ComboValue,
			NodeValue:CatIDStr,
			HospId:HospId
		},false);
    }
    var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"SaveConfig",
		Coninfo:DataList,
		HospId:HospId
	},false);
	if(value=="0"){
		$.messager.show({title:"提示",msg:"保存成功"});					
	}
	if (ComboValue!=""){
		$("#List_ReSetOrdSubCat").empty();
		LoadSubData("List_ReSetOrdSubCat",ComboValue);
	}
}*/
$(function(){  
	InitHospList();
	$('#subCatConfig').layout('panel', 'center').panel({
		onResize: function() {
			setTimeout(function() { 
	        	var c = $("#subCatConfig").layout('panel', 'center');
				if ($('#subCatExtendConfig-div').is(':visible')) {
					var Height=$(window).height()-134;
					var top=51;
				}else{
					var Height=$(window).height()-80;
					var top=0;
				}
				if (c.panel('options').height!=Height){
					c.panel('resize', {height:Height,top:top});
					$("#SubCatListTab").datagrid("resize");
				}
				
	        });
		}
	})
})
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_SubCatContral");
	hospComp.jdata.options.onSelect = function(e,t){
		var selConfigId="";
		var opts = $("#SubCatListTab").datagrid("options");
		var row=$("#SubCatConfigTab").datagrid("getChecked");
		if (row.length >0) {
			selConfigId=row[0].id;
		}
		if (selConfigId =="DHCDocReSetOrdSubCat") {
			InitComboReSetCategory();
			$("#SubCatListTab").datagrid("unselectAll");
			$("#SubCatListTab").datagrid("reload");
		}else{
			if (selConfigId =="FrequencedItemCat") {
				$("#Combo_Freq,#Combo_Dur").combobox('select',"");
				LoadFreqData("FrequencedItemFreq");
				LoadDurData("FrequencedItemDur");
			}else if(selConfigId =="NeedExecCat"){
				$("#Combo_Freq,#Combo_Dur").combobox('select',"");
				LoadFreqData("NeedExecFreq");
				LoadDurData("NeedExecDur");
			}
			$("#SubCatListTab").datagrid("reload");
		}
		InitTip();
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
	InitSubCatConfigTab();
	InitSubCatListTab();
}
function InitSubCatConfigTab(){
	var Columns=[[    
		{ field: 'text', title: '子类配置项', width: 200}					
	]];
	$("#SubCatConfigTab").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		url : $URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindSubCatConfigList",
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"id",
		pageSize:20,
		pageList : [20,50,100,200],
		columns :Columns,
		onBeforeLoad:function(param){
			$.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
			$("#SubCatConfigTab").datagrid("unselectAll");
		},
		onClickRow:function(index, row){
			$("#subCatExtendConfig-div").hide();
			var id=row.id;
			if (id =="DHCDocReSetOrdSubCat") {
				// 医嘱重分类
				$("#subCatExtendConfig-div").show();
				if ($("#Combo_Freq").hasClass("combobox-f")) {
					$("#Combo_Freq,#Combo_Dur").next().hide();
					$("label[for=Combo_Freq],label[for=Combo_Dur]").hide();
				}else{
					$("#Combo_Freq,label[for=Combo_Freq]").hide();
					$("#Combo_Dur,label[for=Combo_Dur]").hide();
				}
				$("label[for=Combo_ReSetCategory]").show();
				if ($("#Combo_ReSetCategory").hasClass("combobox-f")) {
					$("#Combo_ReSetCategory").combobox('select',"");
					$("#Combo_ReSetCategory").next().show();
				}else{
					$("#Combo_ReSetCategory").show();
				}
				InitComboReSetCategory();
				$("#SubCatListTab").datagrid("unselectAll");
			}else if((id =="FrequencedItemCat")||(id =="NeedExecCat")){
				// 录入频次疗程的非药品子类 需生成执行记录的无频次子类V6.0-6.9
				$("#subCatExtendConfig-div").show();
				if ($("#Combo_ReSetCategory").hasClass("combobox-f")) {
					$("#Combo_ReSetCategory").next().hide();
					$("label[for=Combo_ReSetCategory]").hide();
				}else{
					$("#Combo_ReSetCategory,label[for=Combo_ReSetCategory]").hide();
				}
				$("label[for=Combo_Freq],label[for=Combo_Dur]").show();
				if ($("#Combo_Freq").hasClass("combobox-f")) {
					$("#Combo_Freq,#Combo_Dur").combobox('select',"");
					$("#Combo_Freq,#Combo_Dur").next().show();
				}else{
					$("#Combo_Freq,#Combo_Dur").show();
				}
				if (id =="FrequencedItemCat") {
					LoadFreqData("FrequencedItemFreq");
					LoadDurData("FrequencedItemDur");
				}else{
					LoadFreqData("NeedExecFreq");
					LoadDurData("NeedExecDur");
				}
				$("#SubCatListTab").datagrid("reload",{value:id});
			}else{
				$("#SubCatListTab").datagrid("reload",{value:id});
			}
			var p = $("#subCatConfig").layout('panel', 'north');
			p.parent().css('width','100%');
			var c = $("#subCatConfig").layout('panel', 'center');
			if ($('#subCatExtendConfig-div').is(':visible')) {
				var Height=$(window).height()-134;
				c.panel('resize', {height:Height,top:51});
			}else{
				var Height=$(window).height()-80;
				c.panel('resize', {height:Height,top:0});
			}
			$("#SubCatListTab").datagrid("resize");
		},
		onLoadSuccess:function(data){
			var view=$(this).data('datagrid').dc.view;
			$.each(data.rows,function(index,row){
				if(row.tip){
					var $cell=view.find('tr[datagrid-row-index="'+index+'"]').find('td[field="text"]').find('div.datagrid-cell');
					$cell.css('color','#017bce').tooltip({content:row.tip});
				}
			});
		}
	});
}
function InitSubCatListTab(){
	var ToolBar = [{
        text: '保存配置项数据',
        iconCls: 'icon-save',
        handler: function() { 
        	SaveSubCatDataByConfig();
        }
    },'-',{
		id:'tip',
		iconCls: 'icon-help',
		text:'医嘱重分类异常提示',
		handler: function(){
			$("#tip").popover('show');
		}
	}]
	var Columns=[[ 
		{ field: 'ARCICRowId', checkbox: true},   
		{ field: 'ARCICDesc', title: '子类', width: 200},
		{ field: 'selected', title: '已有配置项', width: 90,
			formatter:function(v,rec){
				return '<a href="#this" class="editcls1" onclick="ShowSubCatConfig('+(rec.ARCICRowId)+')">&nbsp</a>';
			}
		}
	]];
	$("#SubCatListTab").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		url : $URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindCatList&value=&rows=99999",
		loadMsg : '加载中..',  
		pagination : false,  
		rownumbers : false, 
		idField:"ARCICRowId",
		columns :Columns,
		toolbar:ToolBar,
		onBeforeLoad:function(param){
			var selConfigId="";
			var opts = $("#SubCatListTab").datagrid("options");
			var row=$("#SubCatConfigTab").datagrid("getChecked");
			if (row.length >0) {
				selConfigId=row[0].id;
			}
			if (selConfigId =="DHCDocReSetOrdSubCat") {
				opts.url = $URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindCatListNew&value=&rows=99999";
			}else{
				opts.url = $URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindCatList&value=&rows=99999";
			}
			$.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
			$("#SubCatListTab").datagrid("unselectAll");
		},
		onLoadSuccess:function(data){
			$('.editcls1').linkbutton({text:'&nbsp',plain:true,iconCls:'icon-search'});
			for (var i=0;i<data.total;i++){
				if (data.rows[i].selected) {
					$("#SubCatListTab").datagrid("selectRow",i);
				}	
			}
			setTimeout(function() {
				$("#SubCatListTab").datagrid("scrollTo",0);
			})
		}
	});
	InitTip();
}
function LoadDurData(param2)
{
	$("#Combo_Dur").combobox({
		valueField:'DurRowId',   
    	textField:'DurCode',
    	url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindDurList&value="+param2+"&Type=XY&HospId="+$HUI.combogrid('#_HospList').getValue()+"&rows=99999",
    	loadFilter: function(data){
			return data['rows'];
		}
	});
}
function LoadFreqData(param2)
{
	$("#Combo_Freq").combobox({
		valueField:'FreqRowId',   
    	textField:'FreqCode',
    	url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindFreqList&value="+param2+"&Type=&HospId="+$HUI.combogrid('#_HospList').getValue()+"&rows=99999",
    	loadFilter: function(data){
			return data['rows'];
		}
	});
}
function InitComboReSetCategory()
{
	$("#Combo_ReSetCategory").combobox({  
    	valueField:'Rowid',   
    	textField:'Desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.SubCatContral';
			param.QueryName = 'ReOrdSubCatList';
			param.ArgCnt =0;
		},
		onChange:function (catdr,o){
			$("#SubCatListTab").datagrid("reload",{value:catdr});
		}
	});
}
// 保存配置项的子类数据
function SaveSubCatDataByConfig(){
	var HospId=$HUI.combogrid('#_HospList').getValue();
	var DataList="";
	var row=$("#SubCatConfigTab").datagrid("getChecked");
	if (row.length ==0) {
		 $.messager.alert('提示',"请选择配置项！");
		 return;
	}
	var param2=row[0].id;
	var CatIDStr="";
	var rows=$("#SubCatListTab").datagrid("getChecked");
	for (var i=0;i<rows.length;i++){
		if (CatIDStr=="") CatIDStr=rows[i].ARCICRowId;
		else CatIDStr=CatIDStr+"^"+rows[i].ARCICRowId;
	}
	if (param2 =="DHCDocReSetOrdSubCat") {
		var ReSetCategoryId=$("#Combo_ReSetCategory").combobox('getValue');
		if (!ReSetCategoryId) {
			$.messager.alert('提示',"请选择分类！");
		 	return;
		}
		var value=$.m({ 
			ClassName:"web.DHCDocConfig", 
			MethodName:"SaveConfig1",
			Node:param2,
			Node1:ReSetCategoryId,
			NodeValue:CatIDStr,
			HospId:HospId
		},false);
	}else{
		 if((param2 =="FrequencedItemCat")||(param2 =="NeedExecCat")){
			var FrequencedItemFreq=$("#Combo_Freq").combobox('getValue');
			if (!FrequencedItemFreq) FrequencedItemFreq="";
			var DurationItemDur=$("#Combo_Dur").combobox('getValue');
			if (!DurationItemDur) DurationItemDur="";
			if (param2 =="FrequencedItemCat") {
				DataList=DataList+String.fromCharCode(2)+"FrequencedItemFreq"+String.fromCharCode(1)+FrequencedItemFreq;
				DataList=DataList+String.fromCharCode(2)+"FrequencedItemDur"+String.fromCharCode(1)+DurationItemDur;
			}else{
				DataList=DataList+String.fromCharCode(2)+"NeedExecFreq"+String.fromCharCode(1)+FrequencedItemFreq;
				DataList=DataList+String.fromCharCode(2)+"NeedExecDur"+String.fromCharCode(1)+DurationItemDur;
			}
		}
		DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+CatIDStr;
		var value=$.m({ 
			ClassName:"web.DHCDocConfig", 
			MethodName:"SaveConfig",
			Coninfo:DataList,
			HospId:HospId
		},false);
	}
	if(value=="0"){
		$.messager.popover({msg: '保存成功！',type:'success'});
	}
}

function ShowSubCatConfig(ARCICRowId){
	var index=$("#SubCatListTab").datagrid("getRowIndex",ARCICRowId);
	var rows=$("#SubCatListTab").datagrid("getRows");
	$("#dialog-SubCatHasConfig").dialog('setTitle',"子类<span style='color:yellow;'>"+rows[index].ARCICDesc +"</span>已有配置项列表").dialog("open");
	InitSubCatHasConfigTab(ARCICRowId);
}
function InitSubCatHasConfigTab(ARCICRowId){
	var ToolBar = [{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { 
        	SaveSubCatConfigBySubCatId();
        }
    }]
	var Columns=[[
		{ field: 'id', checkbox: true},   
		{ field: 'text', title: '配置项', width: 550}
	]];
	$("#SubCatHasConfigTab").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		url : $URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindSubCatConfigList&ARCICRowId="+ARCICRowId+"&rows=99999",
		loadMsg : '加载中..',  
		pagination : false,  
		rownumbers : false, 
		idField:"id",
		columns :Columns,
		toolbar:ToolBar,
		onBeforeLoad:function(param){
			$.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
			$("#SubCatHasConfigTab").datagrid("unselectAll");
		},
		onLoadSuccess:function(data){
			for (var i=0;i<data.total;i++){
				if (data.rows[i].SubCatHasConfigFlag =="Y") {
					$("#SubCatHasConfigTab").datagrid("selectRow",i);
				}	
			}
			setTimeout(function() {
				$("#SubCatHasConfigTab").datagrid("scrollTo",0);
			})
		}
	});
}
function SaveSubCatConfigBySubCatId(){
	var HospId=$HUI.combogrid('#_HospList').getValue();
	var url=$("#SubCatHasConfigTab").datagrid("options").url;
	var ARCICRowId=GetQueryString(url,"ARCICRowId");
	var ConfigIdStr="";
	var rows=$("#SubCatHasConfigTab").datagrid("getChecked");
	for (var i=0;i<rows.length;i++){
		if (ConfigIdStr=="") ConfigIdStr=rows[i].id;
		else ConfigIdStr=ConfigIdStr+"^"+rows[i].id;
	}
	$.m({ 
		ClassName:"DHCDoc.DHCDocConfig.SubCatContral", 
		MethodName:"SaveSubCatConfigBySubCatId",
		ConfigIdStr:ConfigIdStr,
		ARCICRowId:ARCICRowId,
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
function InitTip(){
	$("#tip").popover("destroy");
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	var PropmtInfo=tkMakeServerCall("DHCDoc.DHCDocConfig.SubCatContral","GetPropmtInfo",HospID);
	if (PropmtInfo =="<br/>") {
		PropmtInfo="无异常!"
	}
	$("#tip").popover({
		width:500,
		trigger:'hover',
		content:PropmtInfo
	});
}

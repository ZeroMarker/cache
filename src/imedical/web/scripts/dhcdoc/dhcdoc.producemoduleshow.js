$(function(){
	Init();
	InitEvent();
});
var PageLogicObj={
	PageRowID:"",
	PageRowIDCode:"",
	PageRowIDType:""
	}
function Init(){
	InitTree();
	$('#tabs').tabs({
	  onSelect: function(title,index){
		var currTab = $('#tabs').tabs('getSelected');
		var tabsinfo = currTab.panel('options').tabsinfo; 
		PageLogicObj.PageRowID=tabsinfo.split(String.fromCharCode(1))[0]
		PageLogicObj.PageRowIDCode=tabsinfo.split(String.fromCharCode(1))[2]
		PageLogicObj.PageRowIDType=tabsinfo.split(String.fromCharCode(1))[1]
		//$("#hospidtab").html("")
		/*$("[id=hospidtab]").each(function(i){
			$(this).html("")
		});
		$("[id=_HospList]").each(function(i){
			if ($(this).html()!=""){
			$(this).parent().html("")}
		});*/
		if(currTab.panel('options').title != 'Home') {
			$('#tabs').tabs('update',{
				tab:currTab,
				options:{
					content:createFrame(PageLogicObj.PageRowID),
					tabsinfo:tabsinfo
				}
			})
			InitHosp(PageLogicObj.PageRowID)
			//InitOnetab(PageLogicObj.PageRowID)
			//if (LinkType=="none") LoadOnetabData()
			if (PageLogicObj.PageRowIDType!="csp") {
				var InitRowID=PageLogicObj.PageRowID.split("S")[1]
				$("#BSave"+InitRowID).click(SaveOnetab);
				}
			if((PageLogicObj.PageRowIDType=="loc")||(PageLogicObj.PageRowIDType=="group")||(PageLogicObj.PageRowIDType=="arcim")){
				var InitRowID=PageLogicObj.PageRowID.split("S")[1]
				InitTable(InitRowID,PageLogicObj.PageRowIDType,PageLogicObj.PageRowIDCode)
			}
		}
	  }
	});

	}
function InitEvent(){
	}
function InitTree(){
	$('#treeProduce').tree({
		lines:true,autoNodeHeight:true,
		onContextMenu: function(e, node){
			
		},
		onSelect:function(node){
			addTab(node)
			}	
	})
	LoadTree("")
	}
function producesearchItem(desc, name){
	LoadTree(desc)
	}
function LoadTree(desc){
	var ProduceShowType=ServerObj.ProduceShowType
	$.cm({
        ClassName: 'DHCDoc.DHCDocConfig.DHCDocProduceModule',
        MethodName: 'FindMasterProduceTree',
        desc:desc,
        ProduceShowType:ProduceShowType
    }, function (data) {
        $('#treeProduce').tree({
            data: data
        });
    });
	}
function addTab(node){
	var RowID=node.id
	var title=node.text
	var LinkType=node.LinkType
	if ((node.id.indexOf("M") != "-1")){
		return
		}
	PageLogicObj.PageRowID=""
	PageLogicObj.PageRowIDCode=""
	PageLogicObj.PageRowIDType=LinkType
	/*$("[id=hospidtab]").each(function(i){
		$(this).html("")
	});*/
	var tabsinfo=node.id+String.fromCharCode(1)+node.LinkType+String.fromCharCode(1)+node.Code
	if ($('#tabs').tabs('exists', title)){
		$('#tabs').tabs('select', title);//选中并刷新
		var currTab = $('#tabs').tabs('getSelected');
		if(currTab.panel('options').title != 'Home') {
			$('#tabs').tabs('update',{
				tab:currTab,
				options:{
					content:createFrame(RowID),
					tabsinfo:tabsinfo
				}
			})
			PageLogicObj.PageRowID=RowID
			InitHosp(RowID)
			//InitOnetab(RowID)
			//if (LinkType=="none") LoadOnetabData()
			if (LinkType!="csp") {
				var InitRowID=RowID.split("S")[1]
				$("#BSave"+InitRowID).click(SaveOnetab);}
			if((LinkType=="loc")||(LinkType=="group")||(LinkType=="arcim")){
				var Code=node.Code
				var InitRowID=RowID.split("S")[1]
				InitTable(InitRowID,LinkType,Code)
			}
		}
	} else {
		var content = createFrame(RowID);
		if (content==""){
			return;
			}
		$('#tabs').tabs('add',{
			title:title,
			content:content,
			closable:true,
			tabsinfo:tabsinfo,
			onLoadSuccess:function(){
						}
		});
		PageLogicObj.PageRowID=RowID
		InitHosp(RowID)
		//InitOnetab(RowID)
		//if (LinkType=="none") LoadOnetabData()
		if (LinkType!="csp") {
			var InitRowID=RowID.split("S")[1]
			$("#BSave"+InitRowID).click(SaveOnetab);}
		if((LinkType=="loc")||(LinkType=="group")||(LinkType=="arcim")){
			var Code=node.Code
			var InitRowID=RowID.split("S")[1]
			InitTable(InitRowID,LinkType,Code)
			}
	}
	tabClose();
}
function createFrame(RowID){
	var content=$.m({
		ClassName:"DHCDoc.DHCDocConfig.DHCDocProduceModule",
		MethodName:"CreatFrame",
	   	RowID :RowID
	},false);
	return content;
	}
function tabClose() {
	/*双击关闭TAB选项卡*/
	$(".tabs-inner").dblclick(function(){
		var subtitle = $(this).children(".tabs-closable").text();
		$('#tabs').tabs('close',subtitle);
	})
	/*为选项卡绑定右键*/
	$(".tabs-inner").bind('contextmenu',function(e){
		$('#mm').menu('show', {
			left: e.pageX,
			top: e.pageY
		});
		var subtitle =$(this).children(".tabs-closable").text();
		$('#mm').data("currtab",subtitle);
		$('#tabs').tabs('select',subtitle);
		return false;
	});
}	
function InitHosp(RowID){
	var InitRowID=RowID.split("S")[1]
	var hospComp = GenHospCompNew("Doc_BaseConfig_CNMedCode","","",InitRowID);
	hospComp.jdata.options.onSelect = function(e,t){
		InitOnetab(PageLogicObj.PageRowID)
		if ((PageLogicObj.PageRowIDType=="loc")||(PageLogicObj.PageRowIDType=="group")||(PageLogicObj.PageRowIDType=="arcim")) {LoadOnetab(PageLogicObj.PageRowID,PageLogicObj.PageRowIDCode,"")
		} else if ((PageLogicObj.PageRowIDType=="none")||(PageLogicObj.PageRowIDType=="linkcsp")){LoadOnetabData()} 
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitOnetab(PageLogicObj.PageRowID)
		if ((PageLogicObj.PageRowIDType=="loc")||(PageLogicObj.PageRowIDType=="group")||(PageLogicObj.PageRowIDType=="arcim")) {LoadOnetab(PageLogicObj.PageRowID,PageLogicObj.PageRowIDCode,"")
		} else if ((PageLogicObj.PageRowIDType=="none")||(PageLogicObj.PageRowIDType=="linkcsp")){LoadOnetabData()} 
	}
	}
function InitOnetab(RowID){
	$cm({
		ClassName:"DHCDoc.DHCDocConfig.DHCDocProduceModule",
		QueryName:"FindModuleConfig",
		ModuleRowID:RowID,
		page:1,    //可选项，页码，默认1
		rows:9999    //可选项，获取多少条数据，默认50
	},function(rs){
		var ModeData=rs.rows
		var InitRowID=RowID
		if (RowID.indexOf("S")>=0) var InitRowID=RowID.split("S")[1]
		var HospID=$HUI.combogrid('#_HospList'+InitRowID).getValue()
		for (var i=0;i<ModeData.length;i++){
			var OneModelData=ModeData[i]
			var OneModeID=OneModelData.RowID
			var ConfigType=OneModelData.ConfigType
			var ConfigCode=OneModelData.ConfigCode
			if (ConfigType=="下拉框单选"){
				var GridData=$.m({
					ClassName: 'DHCDoc.DHCDocConfig.DHCDocProduceModule',
        			MethodName: 'GetProduceModuleJSON',
					RowID:OneModeID,HospID:HospID
				},false)
				
					var cbox = $HUI.combobox("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1], {
						editable:false,
						valueField: 'Value',
						textField: 'Desc', 
						data:eval(GridData),
						onLoadSuccess:function(){
						}
					 });	
				
			}else if (ConfigType=="下拉框多选"){
				var GridData=$.m({
					ClassName: 'DHCDoc.DHCDocConfig.DHCDocProduceModule',
        			MethodName: 'GetProduceModuleJSON',
					RowID:OneModeID,HospID:HospID
				},false)
				var cbox = $HUI.combobox("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1], {
						editable:false,
						valueField: 'Value',
						textField: 'Desc',
						multiple:true,
						//rowStyle:'checkbox', //显示成勾选行形式
						selectOnNavigation:false,
						panelHeight:"auto", 
						data: eval(GridData),
						onLoadSuccess:function(){
						}
					 });
			}else if (ConfigType=="链接按钮"){
				$("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).click(function (){
					var openwidth=screen.availWidth-400
					var openheight=screen.availHeight-200
					if(typeof websys_writeMWToken=='function') OneModelData.ConfigLinkStr=websys_writeMWToken(OneModelData.ConfigLinkStr);
					var $code ="<iframe width='100%' height='99%' scrolling='no' frameborder='0' src='"+OneModelData.ConfigLinkStr+"'></iframe>" ;
					createModalDialog("dhcopregconfig",OneModelData.ConfigDesc, openwidth, openheight,"","",$code,"");
				});
			}
		}
		
	});
	}
function InitTable(RowID,LinkType,Code){
    var ProduceModuleconfigColumns=[[   
    			{ field: 'RowID', title: 'Rowid', width: 10,hidden:true },
        		{ field: 'Desc', title: '名称', width: 200}
    			 ]];
	$('#tabList'+Code+RowID).datagrid({  
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 15,
		pageList : [15,50,100],
		idField:'RowID',
		columns :ProduceModuleconfigColumns,
		//toolbar :ProduceModuleconfigToolBar,
		onClickRow:function(rowIndex, rowData){
			LoadSelecttabDate()
		},
		onDblClickRow:function(rowIndex, rowData){
			LoadSelecttabDate()
		}
	});
	PageLogicObj.PageRowID=RowID
	PageLogicObj.PageRowIDCode=Code
	//LoadOnetab(RowID,Code,"")
	}
function LoadOnetab(RowID,Code,desc){
	if (RowID=="") RowID=PageLogicObj.PageRowID
	if (Code=="") Code=PageLogicObj.PageRowIDCode
	var HospID=$HUI.combogrid('#_HospList'+RowID).getValue()
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.DHCDocProduceModule",
	    QueryName : "FindModuleConfigtab",
	    ModuleRowID :RowID,
	    HospID:HospID,
	    desc:desc,
	    Pagerows:$('#tabList'+Code+RowID).datagrid("options").pageSize,rows:99999
	},function(GridData){
		$('#tabList'+Code+RowID).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		//$('#tabList'+Code+RowID).datagrid("clearSelections")
	})
	}
function searchItem(desc, name){
	LoadOnetab("","",desc)
	}
function SaveOnetab(){
	$cm({
		ClassName:"DHCDoc.DHCDocConfig.DHCDocProduceModule",
		QueryName:"FindModuleConfig",
		ModuleRowID:PageLogicObj.PageRowID,
		page:1,    //可选项，页码，默认1
		rows:9999    //可选项，获取多少条数据，默认50
	},function(rs){
		var DataList=""
		var ModeData=rs.rows
		var InitRowID=PageLogicObj.PageRowID.split("S")[1]
		var HospID=$HUI.combogrid('#_HospList'+InitRowID).getValue()
		var Type=PageLogicObj.PageRowIDType
		var SaveObj={
			HospID:HospID,
			Type:Type,
			ModuleRowID:InitRowID
			}
		if (Type!="none"){
			var row=$('#tabList'+PageLogicObj.PageRowIDCode+PageLogicObj.PageRowID).datagrid('getSelected');
			if ((!row)||(row.length==0)){
				$.messager.alert("提示","请选择需要保存的行!","info");
				return false;
			}
			TypeValue=row.RowID;
			$.extend(SaveObj, {TypeValue:TypeValue});
		}
		var JsonAry = new Array();
		for (var i=0;i<ModeData.length;i++){
			var OneModelData=ModeData[i]
			var OneModeID=OneModelData.RowID
			var ConfigType=OneModelData.ConfigType
			var ConfigCode=OneModelData.ConfigCode
			var OneValue=""
			if (ConfigType=="文本"){
				OneValue=$("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).val()
			}else if (ConfigType=="勾选框"){
				if ($("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).checkbox('getValue')) {
				       OneValue=1;
				   }else{OneValue=0;}
			}else if (ConfigType=="下拉框单选"){
				OneValue=$HUI.combobox("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).getValue()
			}else if (ConfigType=="下拉框多选"){
				OneValue=$HUI.combobox("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).getValues().join("!");
			}
			JsonAry[JsonAry.length]={
				id:OneModeID,
				value:OneValue,
				type:ConfigType,
				code:ConfigCode
			};
			/*if (DataList==""){
				DataList=ConfigCode+String.fromCharCode(1)+OneValue;
			}else{
				DataList=DataList+String.fromCharCode(2)+ConfigCode+String.fromCharCode(1)+OneValue;
			}*/
		}
		$.extend(SaveObj, {"JsonAry":JsonAry})
		var SaveObjStr=JSON.stringify(SaveObj);
		/*var value=$.m({
			ClassName:"DHCDoc.DHCDocConfig.DHCDocProduceModule",
			MethodName:"SaveProduceModuleMethod",
		   	ObjStr:SaveObjStr, ModuleRowID:InitRowID
		},false);*/
		runClassMethod("DHCDoc.DHCDocConfig.DHCDocProduceModule","SaveProduceModuleMethod",{"ObjStr":SaveObjStr, "ModuleRowID":InitRowID},function(jsonString){
			if(jsonString=="0"){
				$.messager.popover({msg: '保存成功',type:'success'});
				if (Type=="none"){
					LoadOnetabData()
				}else{
					LoadSelecttabDate()
					}	
			}
		},'',false)
		
		})
	}
function LoadOnetabData(){
	var InitRowID=PageLogicObj.PageRowID.split("S")[1]
	var HospID=$HUI.combogrid('#_HospList'+InitRowID).getValue()
	$.cm({
		ClassName: 'DHCDoc.DHCDocConfig.DHCDocProduceModule',
		MethodName: 'GetProduceModuleMethod',
		ModuleRowID:PageLogicObj.PageRowID,HospID:HospID,Type:"none", TypeValue:"",
		dataType:"text"
	},function(GridData){
		if (GridData!=""){
			var DataListAry=GridData.split(String.fromCharCode(2))
			for (var i=0;i<DataListAry.length;i++){
				var OneDataListAry=DataListAry[i].split(String.fromCharCode(1))
				var OneModeID=OneDataListAry[1]
				var ConfigType=OneDataListAry[2]
				var ConfigCode=OneDataListAry[0]
				var OneValue=OneDataListAry[3]
				if (ConfigType=="text"){
					$("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).val(OneValue)
				}else if (ConfigType=="check"){
					if (OneValue==1){
						$("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).checkbox("setValue",true)
					}else{
						$("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).checkbox("setValue",false)
					}
				}else if (ConfigType=="Combobox"){
					$HUI.combobox("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).setValue(OneValue)
				}else if (ConfigType=="ComboboxM"){
					//$HUI.combobox("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).setValue(OneValue)
					var OneValueArr=OneValue.split("!");
					for (j=0;j<OneValueArr.length;j++){
						if (OneValueArr[j]!="")  $HUI.combobox("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).select(OneValueArr[j]);
					}
				}
				}
			
			}
		})
	}
function LoadSelecttabDate(){
	var InitRowID=PageLogicObj.PageRowID.split("S")[1]
	var HospID=$HUI.combogrid('#_HospList'+InitRowID).getValue()
	var Type=PageLogicObj.PageRowIDType
	var row=$('#tabList'+PageLogicObj.PageRowIDCode+PageLogicObj.PageRowID).datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要展示的行!","info");
		return false;
	}
	TypeValue=row.RowID;	
	$.cm({
		ClassName: 'DHCDoc.DHCDocConfig.DHCDocProduceModule',
		MethodName: 'GetProduceModuleMethod',
		ModuleRowID:PageLogicObj.PageRowID,HospID:HospID,Type:Type, TypeValue:TypeValue,
		dataType:"text"
	},function(GridData){
		if (GridData!=""){
			var DataListAry=GridData.split(String.fromCharCode(2))
			for (var i=0;i<DataListAry.length;i++){
				var OneDataListAry=DataListAry[i].split(String.fromCharCode(1))
				var OneModeID=OneDataListAry[1]
				var ConfigType=OneDataListAry[2]
				var ConfigCode=OneDataListAry[0]
				var OneValue=OneDataListAry[3]
				if (ConfigType=="text"){
					$("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).val(OneValue)
				}else if (ConfigType=="check"){
					if (OneValue==1){
						$("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).checkbox("setValue",true)
					}else{
						$("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).checkbox("setValue",false)
					}
				}else if (ConfigType=="Combobox"){
					$HUI.combobox("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).setValue(OneValue)
				}else if (ConfigType=="ComboboxM"){
					//$HUI.combobox("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).setValue(OneValue)
					var OneValueArr=OneValue.split("!");
					for (j=0;j<OneValueArr.length;j++){
						if (OneValueArr[j]!="")  $HUI.combobox("#"+ConfigCode+"_"+OneModeID.split("||")[0]+"_"+OneModeID.split("||")[1]).select(OneValueArr[j]);
					}
				}
				}
			
			}
		})
	}
var _BDPHOSPCLS="web.DHCBL.BDP.BDPMappingHOSP";
function GenHospCompNew(tableName,sessionStr,opt,RowID){
	tableName = tableName||"CommonTable";
	sessionStr = sessionStr||"";
	var hospid = (session&&session['LOGON.HOSPID'])||"";
	var defaultOpt = {width:350};
	opt = $.extend(defaultOpt,opt||{});
	var defHospId = $cm({dataType:'text',ClassName:_BDPHOSPCLS,MethodName:"GetDefHospIdByTableName",tableName:tableName,HospID:hospid},false);
	var obj = $HUI.combogrid('#_HospList'+RowID,{
		delay: 500,
		blurValidValue:true,
		panelWidth:350,
		width:opt.width,
		mode: 'remote',
		editable:false,
		pagination:true,
		lazy:true,
		minQueryLen:1,
		value:defHospId,
		isCombo:true,
		showPageList:false,
		showRefresh:false,
		displayMsg:"当前:{from}~{to},共{total}条",
        onBeforeLoad:function(param){
			param = $.extend(param,{desc:$("#_HospList"+RowID).lookup("getText")});
			return true;
		},
		queryParams:{ClassName:_BDPHOSPCLS,QueryName:'GetHospDataForCombo',tablename:tableName,SessionStr:sessionStr},
		url: $URL,
		idField: 'HOSPRowId',
		textField: 'HOSPDesc',
		columns: [[
			{field:"HOSPRowId",title:"HOSPRowId",align:"left",hidden:true,width:100},
			{field:"HOSPDesc",title:"医院名称",align:"left",width:300}
		]]
	});
	return obj;
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function destroyDialog(id){
   $("body").remove("#"+id); //移除存在的Dialog
   $("#"+id).dialog('destroy');
}


var PageLogicObj={
	PHRecLocDataGrid:"",
	ItemCatExtDataGrid:"",
	
	editRow:undefined,
	LocRowID:""
}

$(function(){ 
	InitHospList();
	InitTip();
	
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_PHReclocAbout");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	InitPHRecLoc();
    InitItemCatExtDataGrid();
	ChangePHRecLocCommon()
	//初始化静配相关区域
	InitDosingConfig();
}
function InitItemCatExtDataGrid()
{
	var ItemCatExtTools = [{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            SaveItemCatExt();
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                PageLogicObj.editRow = undefined;
                PageLogicObj.ItemCatExtDataGrid.datagrid("rejectChanges");
                PageLogicObj.ItemCatExtDataGrid.datagrid("unselectAll");
            }
        }];
        ///ItemCatDr:%String,ItemCatDesc:%String,NormSplitPackQty:%String,AutoCreatONEOrd
	var ItemCatExtColumns=[[    
                    { field: 'ItemCatDr',hidden:true},
        			{ field: 'ItemCatDesc', title: '药品子类', width: 150, align: 'center', sortable: true},
        			///非急诊留观押金模式下，计费、药房组无法处理
					{ field: 'NormSplitPackQty', title: '临时医嘱拆分整包装发药(仅在急诊留观押金的虚拟长期模式下有效)',  align: 'center', sortable: true,
					   editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       },
                       styler: function(value,row,index){
			 				if (value=="Y"){
				 				return 'color:#21ba45;';
				 			}else{
					 			return 'color:#f16e57;';
					 		}
		 			   },
			 		   formatter:function(value,record){
				 			if (value=="Y") return "是";
				 			else  return "否";
				 	   }
					}/*,
					{ field: 'EMAutoCreatONEOrd', title: '急诊虚拟长期嘱托、自备药医嘱自动计算插入取药医嘱',  align: 'center', sortable: true,hidden:true,
					   editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       },
                       styler: function(value,row,index){
			 				if (value=="Y"){
				 				return 'color:#21ba45;';
				 			}else{
					 			return 'color:#f16e57;';
					 		}
		 			   },
			 		   formatter:function(value,record){
				 			if (value=="Y") return "是";
				 			else  return "否";
				 	   }
					},
					{ field: 'EnableIPDispensingMode', title: '启用医生科室发药',  align: 'center', sortable: true,hidden:true,
					   editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       },
                       styler: function(value,row,index){
			 				if (value=="Y"){
				 				return 'color:#21ba45;';
				 			}else{
					 			return 'color:#f16e57;';
					 		}
		 			   },
			 		   formatter:function(value,record){
				 			if (value=="Y") return "是";
				 			else  return "否";
				 	   }
					}*/
    			 ]];
	PageLogicObj.ItemCatExtDataGrid=$('#tabPHItemCatExtConfig').datagrid({  
		fit : true,
		width : 'auto', //
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"ItemCatDr",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :ItemCatExtColumns,
		toolbar :ItemCatExtTools,
		remoteSort: false,
		onClickRow:function(rowIndex, rowData){
			if (PageLogicObj.editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			PageLogicObj.ItemCatExtDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.editRow=rowIndex
		},onLoadSuccess:function(data){
			$(this).datagrid('unselectAll');
			PageLogicObj.editRow=undefined;
		}
	});
};
function LoadItemCatExtDataGrid()
{
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.PHReclocAbout",
	    QueryName : "GetItemCatExtConfig",
	    PHRecloc:PageLogicObj.LocRowID,
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.ItemCatExtDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.editRow = undefined;
		PageLogicObj.ItemCatExtDataGrid.datagrid('unselectAll');
		PageLogicObj.ItemCatExtDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
};
function InitPHRecLoc(){
	var GridData=$.cm({
	    ClassName : "DHCDoc.DHCDocConfig.DocConfig",
	    QueryName : "FindDep",
	    desc:"",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    rows:99999
	},false);
	if (PageLogicObj.PHRecLocDataGrid!=""){
		PageLogicObj.PHRecLocDataGrid.datagrid("unselectAll").datagrid("loadData",GridData['rows']);
		PageLogicObj.LocRowID="";
		ChangePHRecLocCommon();
		return ;
	}
	var PHRecLocColumns=[[    
		{ field: 'CTLOCRowID',hidden:true},
		{ field: 'CTLOCDesc', title: '名称', width: 150, align: 'center', sortable: false}
	]]
	PageLogicObj.PHRecLocDataGrid=$("#tabPHRecLoc").datagrid({   
		fit : true,
		width : 'auto', //
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"CTLOCRowID",
		columns :PHRecLocColumns,
		toolbar :[],
		data:GridData['rows'],
		onSelect:function(rowIndex, rowData){
			PageLogicObj.LocRowID=rowData.CTLOCRowID;
			ChangePHRecLocCommon();
		}
	})
}
function ChangePHRecLocCommon(){
	//加载子类扩展设置
	LoadItemCatExtDataGrid();
	//加载静配设置
	LoadDosingConfig();
}
function SaveItemCatExt(){
	if ((PageLogicObj.LocRowID=="")||(PageLogicObj.editRow == undefined)){
	  return false;
	}
	var rows = PageLogicObj.ItemCatExtDataGrid.datagrid("getRows"); 
	var NormSplitPackQty="0";
	var EMAutoCreatONEOrd="0";
	var EnableIPDispensingMode="0";
	var rows=PageLogicObj.ItemCatExtDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
	var editors = PageLogicObj.ItemCatExtDataGrid.datagrid('getEditors', PageLogicObj.editRow); 
	var selected=editors[0].target.is(':checked');
	if(selected) NormSplitPackQty="1";
	/*
	var selected=editors[1].target.is(':checked');
	if(selected) EMAutoCreatONEOrd="1";
	var selected=editors[2].target.is(':checked');
	if(selected) EnableIPDispensingMode="1";
	*/
	if ((EMAutoCreatONEOrd=="1")&&(NormSplitPackQty=="1")){
		$.messager.alert('提示',"该子类无法同时拆包装发药且自动生成取药！");
		return false;
	}
	
	var HospDr=$HUI.combogrid('#_HospList').getValue();
	var UserEMVirtualtLong = $.cm({
			ClassName:"web.DHCDocConfig",
			MethodName:"GetConfigNode",
		    Node:"UserEMVirtualtLong",
		    HospId:HospDr,
			dataType:"text"
		},false)
	//目前药房判是否启用医生科室发药是根据虚拟长期勾选判断的，仅使用医生科室发药界面操作时才能按执行记录发药、计费、退药、退费
	//目前药房无法将判断修改为该勾选，因为涉及不同子类需要切换发药界面的问题。
	if ((UserEMVirtualtLong!="1")&&(NormSplitPackQty=="1")){
		$.messager.alert('提示',"当前医院未开启急诊虚拟长期，无法配置临时医嘱拆分整包装发药！");
		return false;
	}
	/*
	if ((NormSplitPackQty=="1")&&(EnableIPDispensingMode=="0")){
		$.messager.alert('提示',"该子类在拆包装发药模式下,请务必启用住院发药模式！");
		return false;
	}
	*/
	var DHCFieldNumStr="1^2^3";
	var ValStr=NormSplitPackQty+"^"+EMAutoCreatONEOrd+"^"+EnableIPDispensingMode;

	$.m({
		ClassName:"DHCDoc.DHCDocConfig.PHReclocAbout",
		MethodName:"SetPHReclocAboutItemCatExtValue",
		PHRecloc:PageLogicObj.LocRowID, ItemCatDr:rows.ItemCatDr,DHCFieldNumStr:DHCFieldNumStr, ValStr:ValStr
	},function(value){
		if(value=="0"){
			PageLogicObj.ItemCatExtDataGrid.datagrid("endEdit", PageLogicObj.editRow);
			LoadItemCatExtDataGrid();
			$.messager.show({title:"提示",msg:"保存成功"});
		}else{
			$.messager.alert('提示',"保存失败:"+value);
			return false;
		}
	});
}


function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>子类相关设置页面使用说明</li>"
		+ "<li>1、若启用急诊虚拟长期功能，建议针剂、大输液等子类勾选【临时医嘱拆分整包装发药】，方可按执行记录进行撤销，以实现部分退药等业务场景。</li>"
	;
	$("#Panel-Tools-CatExtConfig-Tip").popover({
		trigger:'hover',
		content:_content
	});

	var _content = "<ul class='tip_class'><li style='font-weight:bold'>静配相关设置页面使用说明</li>"
		+ "<li>1、以下配置对普通药房均不生效。</li>"
		+ "<li>2、勾选任意<i>隔日配液、按上下班时间修改静配接收科室</i>配置后:</li>"
		+ "<li>2.1、跨日补开到静配药房的医嘱一律接收到默认药房。</li>"
		+ "<li>2.2、开立临时医嘱时，接收到静配的时间分别受本配置中的配液时间逻辑、<i>用法关联接收科室设置</i>中的起止时间管控，不满足其中任意医嘱开立时间要求时，临时医嘱均不可接收到静配。</li>"
		+ "<li>     注意：按医嘱项、子类、大类等配置至静配中心的医嘱，系统默认静配药房可以全时段接收临时医嘱。</li>"
		+ "<li>3、<i>隔日配液、按上下班时间修改静配接收科室</i>均关闭时，默认静配接收所有执行记录（包含跨日补开）。</li>"
	;
	$("#Panel-Tools-DosingRecConfig-Tip").popover({
		trigger:'hover',
		content:_content
	});

}
function GetConfigData2(Node,SubNode)
{
	var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"GetConfigNode1",
		Node:Node,
		SubNode:SubNode,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	return value
}
function GetConfigData3(Node,SubNode1,SubNode2)
{
	var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"GetConfigNode3",
		Node:Node,
		SubNode1:SubNode1,
		SubNode2:SubNode2,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	return value
}
function InitDosingConfig(){
	$("#BSaveDosingConfig").click(SaveDosingConfig);
	$("#Check_IPDosingNextDay,#Check_IPDosingTodayRecLoc").checkbox({
		onCheckChange:function (e,value){
			var id=e.target.id;
			if (id=="Check_IPDosingNextDay"){
				if (value==true){
					$("#DTPicker_DosingStartTime").timespinner('enable');
					var time=$("#DTPicker_DosingStartTime").timespinner('getValue');
					if (time==""){
						$("#DTPicker_DosingStartTime").timespinner('setValue','00:00:00');
					}
					$("#Check_IPDosingTodayRecLoc").checkbox('uncheck');
					$("#DTPicker_DosingEndTime").timespinner('disable').timespinner('setValue','');
				}
			}
			if (id=="Check_IPDosingTodayRecLoc"){
				if (value==true){
					$("#DTPicker_DosingStartTime,#DTPicker_DosingEndTime").timespinner('enable')
					var time=$("#DTPicker_DosingStartTime").timespinner('getValue');
					if (time==""){
						$("#DTPicker_DosingStartTime").timespinner('setValue','00:00:00');
					}
					var time=$("#DTPicker_DosingEndTime").timespinner('getValue');
					if (time==""){
						$("#DTPicker_DosingEndTime").timespinner('setValue','23:59:59');
					}
					$("#Check_IPDosingNextDay").checkbox('uncheck');
				}
				
			}
			var value1=$("#Check_IPDosingNextDay").checkbox('getValue');
			var value2=$("#Check_IPDosingTodayRecLoc").checkbox('getValue');
			if ((value1==false)&&(value2==false)){
				$("#DTPicker_DosingStartTime").timespinner('disable').timespinner('setValue','');
				$("#DTPicker_DosingEndTime").timespinner('disable').timespinner('setValue','');
			}
		}
	});
}
	
/// 加载静配区域数据
function LoadDosingConfig(){
	if (PageLogicObj.LocRowID==""){
		ActiveDosingConfig(false);
		return;
	}else{
		ActiveDosingConfig(true);
	}
	$('#DosingConfig').find('[class~="hisui-checkbox"]').each(function(index,ele){
		var value=GetConfigData3("IPDosingRecLoc",PageLogicObj.LocRowID,ele.id.split("_")[1]);
		$(ele).checkbox(value==1?'check':'uncheck');
	})
	$('#DosingConfig').find('[class~="hisui-timespinner"]').each(function(index,ele){
		var value=GetConfigData3("IPDosingRecLoc",PageLogicObj.LocRowID,ele.id.split("_")[1]);
		$(ele).timespinner('setValue',value);	//value==""?'00:00:00':value
	})
	var value=GetConfigData3("IPDosingRecLoc",PageLogicObj.LocRowID,"Active");
	$HUI.switchbox('#ISDosingRecLoc').setValue(value==1?true:false);

	function ActiveDosingConfig(Active){
		$HUI.switchbox('#ISDosingRecLoc').setValue(Active);
		$HUI.switchbox('#ISDosingRecLoc').setActive(Active);
		$('#DosingConfig').find('[class~="hisui-checkbox"]').each(function(index,ele){
			$(ele).checkbox('setValue',Active).checkbox('setDisable',!Active);
		})
		$('#DosingConfig').find('[class~="hisui-timespinner"]').each(function(index,ele){
			$(ele).timespinner(Active?'enable':'disable').timespinner('setValue','');
		})
	}
}
function SaveDosingConfig(){
	if (PageLogicObj.LocRowID==""){
		$.messager.alert("提示", "请选择需要保存的药房!");
		return false;
	}
	var LocRowID=PageLogicObj.LocRowID;
	var value=$HUI.switchbox('#ISDosingRecLoc').getValue();
	var IPDosingRecLoc=value===true?1:0;
	var DosingConfig={};
	DosingConfig[LocRowID]={}
	DosingConfig[LocRowID]["Active"]=IPDosingRecLoc
	
	$('#DosingConfig').find('[class~="hisui-checkbox"]').each(function(index,ele){
		var value=$(ele).checkbox('getValue');
		DosingConfig[LocRowID][ele.id.split("_")[1]]=value==true?'1':'0'
	})
	
	$('#DosingConfig').find('[class~="hisui-timespinner"]').each(function(index,ele){
		var value=$(ele).timespinner('getValue');
		DosingConfig[LocRowID][ele.id.split("_")[1]]=value;	//value==""?'00:00:00':value
	})
	var ConfigJson=$.extend({},{IPDosingRecLoc:DosingConfig});
	console.log(JSON.stringify(ConfigJson))
	var rtn=$.m({ 
		ClassName:"DHCDoc.DHCDocConfig.DocConfig", 
		MethodName:"SaveDocConfigCommon",
		HospId:$HUI.combogrid('#_HospList').getValue(),
		ConfigJson:JSON.stringify(ConfigJson)
	},false);
	if (rtn=="0"){
		$.messager.popover({msg: '保存成功！',type: 'success',timeout: 2000, showType: 'slide' });
	}else{
		$.messager.popover({msg: '保存失败，程序发生异常！',type: 'error',timeout: 2000});
	}
}





var arrayObj1 = new Array(
   new Array("List_OPStopPaidItemCat","OPStopPaidItemCat"),
   new Array("List_StopInDependExecItemCat","StopInDependExecItemCat")
);
//点击按钮保存
var arrayObj2 = new Array(
   new Array("Check_IPStopPaidOrder","IPStopPaidOrder"),
   new Array("Check_IPStopExecOrder","IPStopExecOrder"),
   new Array("Check_AutoCreateDispApply","AutoCreateDispApply")
);
//勾选后自动保存
var arrayObj3 = new Array(
	new Array("Check_NurseUnUseOrdAuth","NurseUnUseOrdAuth")
 );
var PageLogicObj={
	NurOperatDocAuthDataGrid:undefined
}
$(function(){
	InitHospList();
	//页面元素初始化
	PageHandle();
	$("#BSave").click(SaveStopConfig);
})
function PageHandle() {
	InitTip();
	InitNurOperatDocAuthDataGrid();
	LoadItemCatExtDataGrid();
}
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_StopConfig");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
		LoadItemCatExtDataGrid();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	//listbox 数据加载
	for( var i=0;i<arrayObj1.length;i++) {
	   var param1=arrayObj1[i][0];
	   var param2=arrayObj1[i][1];
	   LoadSubStopConfig(param1,param2);
    }
	//需要控制执行的医嘱优先级
	LoadStopExecOrderPrior("List_StopExecOrderPrior","StopExecOrderPrior");
	//checkbox数据加载
	for( var i=0;i<arrayObj2.length;i++) {
	   var param1=arrayObj2[i][0];
	   var param2=arrayObj2[i][1];
	   InitCheckItems(param1,param2);
    }
	for( var i=0;i<arrayObj3.length;i++) {
		var param1=arrayObj3[i][0];
		var param2=arrayObj3[i][1];
		InitCheckItems(param1,param2);
		$("#"+param1+"").checkbox({
			'onCheckChange':function(e,value){
				var id=e.currentTarget.id;
				var checkItemVal=value?1:0;
				var param2=arrayObj3.findIndex(function (Item) {
					if (Item[0]==id){
						return Item;
					}
				})
				if (param2==-1){
					$.messager.popover({msg: '保存失败!',type:'error'});
					return;
				}
				param2=arrayObj3[param2][1];
				var DataList=param2+String.fromCharCode(1)+checkItemVal
				var value=$.m({ 
					ClassName:"web.DHCDocConfig", 
					MethodName:"SaveConfig",
					Coninfo:DataList,
					HospId:$HUI.combogrid('#_HospList').getValue()
			},false);
				if(value=="0"){
					$.messager.popover({msg: '保存成功!',type:'success'});				
				}
			}
		});
	 }
}
function LoadSubStopConfig(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.SubCatContral", 
		QueryName:"FindCatList",
		value:param2,
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:9999
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
function InitCheckItems(param1,param2)
{
	var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"GetConfigNode",
		Node:param2,
		HospId:$HUI.combogrid('#_HospList').getValue()
   },false);
	if (value==1){
	  $("#"+param1+"").checkbox('check');
	}else{
	  $("#"+param1+"").checkbox('uncheck');
	}
}
function LoadStopExecOrderPrior(param1,param2)
{
	$("#"+param1+"").find("option").remove()
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.RollOrder", 
		QueryName:"FindPrior",
		value:param2,
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:9999
   },false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		selectlist=selectlist+"^"+n.selected
		vlist += "<option value=" + n.OECPRRowId + ">" + n.OECPRDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
							
}
function SaveStopConfig()
{
	var DataList=""
	for( var i=0;i<arrayObj2.length;i++) {
		var param1=arrayObj2[i][0];
	    var param2=arrayObj2[i][1];
		var checkItemVal=0;
		if ($("#"+param1).is(":checked")) {
		   checkItemVal=1
	    }
		if(DataList=="") DataList=param2+String.fromCharCode(1)+checkItemVal
		else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+checkItemVal
	}
	
	var size = $("#List_StopExecOrderPrior"  + " option").size();
    if(size>0){
		var PriorStr=""
		$.each($("#List_StopExecOrderPrior"+" option:selected"), function(i,own){
		  var svalue = $(own).val();
		  if (PriorStr=="") PriorStr=svalue;
		  else PriorStr=PriorStr+"^"+svalue;
		})
		DataList=DataList+String.fromCharCode(2)+"StopExecOrderPrior"+String.fromCharCode(1)+PriorStr
    }
	for( var i=0;i<arrayObj1.length;i++) {
	   var CatIDStr=""
	   var param1=arrayObj1[i][0];
	   var param2=arrayObj1[i][1];
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
   var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"SaveConfig",
		Coninfo:DataList,
		HospId:$HUI.combogrid('#_HospList').getValue()
   },false);
	if(value=="0"){
		$.messager.popover({msg: '保存成功!',type:'success'});				
	}
}

function InitTip(){

	var _content = "<ul class='tip_class'><li style='font-weight:bold'>权限配置使用说明</li>"
		+ "<li>1、只对跨医护人员类型操作医嘱时生效，即护士操作医生开立的医嘱。护士操作其他护士开立的医嘱时，不受该配置影响。</li>"
		+ "<li>2、权限不再与医嘱单配置相关联。</li>"
		+ "<li>3、<i>仅某项配置项为空</i>但存在其他配置项有值时，则有该项的所有权限;<i>全部配置项均为空</i>时，代表无权限。</li>"
		+ "<li>4、各有效配置项之间为或关系，即存在一个符合条件的有效配置项时，则拥有该项权限。</li>"
		+ "<li>4.1、医嘱优先级与其他配置项为且关系，即若配置优先级则必须满足该条件。</li>"
		+ "<li>5、作废权限仅能本人操作,无法跨医护人员类型操作。</li>"
	;
	$("#Panel-Tools-NurOperatDocAuth-Tip").popover({
		trigger:'hover',
		content:_content
	});

}

function InitNurOperatDocAuthDataGrid() {
	
	var Columns = [[
		{field:'OperatTypeDesc',title:'操作类型',width:100},
		{field:'OperatTypeCode',title:'操作类型代码',width:100},
		{field:'Prior',title:'医嘱类型',width:200,
			formatter:function(value,rec){
				var btn = '<a class="editcls" ';
				btn=btn+'onclick="SetNurOperatDocAuthfig(\'' + rec.OperatTypeCode + '\',\'医嘱类型\',\'Prior\',\'OEC_Priority\',\'' + rec.PriorIDs + '\')">';
				btn=btn+value+'</a>';
				return btn;
			}
		},
		{field:'PriorIDs',hidden:true},
		{field:'OrderCat',title:'医嘱子类',width:400,
			formatter:function(value,rec){
				var btn = '<a class="editcls" ';
				btn=btn+'onclick="SetNurOperatDocAuthfig(\'' + rec.OperatTypeCode + '\',\'医嘱子类\',\'OrderCat\',\'ARC_ItemCat\',\'' + rec.OrderCatIDs + '\')">';
				btn=btn+value+'</a>';
				return btn;
			}
		},
		{field:'OrderCatIDs',hidden:true},
		{field:'SpecialItem',title:'特殊医嘱',width:200,
			formatter:function(value,rec){
				var btn = '<a class="editcls" ';
				btn=btn+'onclick="SetNurOperatDocAuthfig(\'' + rec.OperatTypeCode + '\',\'特殊医嘱\',\'SpecialItem\',\'ARC_ItmMast\',\'' + rec.SpecialItemIDs + '\')">';
				btn=btn+value+'</a>';
				return btn;
			}
		},
		{field:'SpecialItemIDs',hidden:true},
		{field:'BindSource',title:'绑定来源',width:400,
			formatter:function(value,rec){
				var btn = '<a class="editcls" ';
				btn=btn+'onclick="SetNurOperatDocAuthfig(\'' + rec.OperatTypeCode + '\',\'绑定来源\',\'BindSource\',\'\',\'' + rec.BindSourceCodes + '\')">';
				btn=btn+value+'</a>';
				return btn;
			}
		},
		{field:'BindSourceCodes',hidden:true}
    ]]
	var Tools = [];
	PageLogicObj.NurOperatDocAuthDataGridDataGrid=$('#tabNurOperatDocAuth').datagrid({  
		fit : true,
		width : 'auto', //
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		idField:"OperatTypeCode",
		columns :Columns,
		toolbar :Tools,
		remoteSort: false,
		onClickRow:function(rowIndex, rowData){
		},onLoadSuccess:function(data){
			$(this).datagrid('unselectAll');
		}
	});
}

function LoadItemCatExtDataGrid()
{
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.StopConfig",
	    QueryName : "QueryNurOperatDocAuth",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:99999,rows:99999
	},function(GridData){
		PageLogicObj.NurOperatDocAuthDataGridDataGrid.datagrid('unselectAll');
		PageLogicObj.NurOperatDocAuthDataGridDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
};
/// 设置操作类型上的配置数据
function SetNurOperatDocAuthfig(OperatTypeCode,Title,ConfigType,TableName,IDs) {
	var HospID=$HUI.combogrid('#_HospList').getValue();
	IDs=IDs.replace(/,/g,"!");
	var DisplayType="Select";
	var CustomQuery="",IDFieldName="",DescFieldName="";
	if (Title=="特殊医嘱"){
		DisplayType="Search";
	}else if (Title=="绑定来源"){
		CustomQuery="web.DHCDocQryOEOrder.GetBindSource";
		IDFieldName="Code"
		DescFieldName="Desc"
	}
	var url="dhcdoc.util.tablelist.csp?TableName="+TableName;
	url=url+"&CustomQuery="+CustomQuery+"&IDFieldName="+IDFieldName+"&DescFieldName="+DescFieldName;
	url=url+"&IDList="+IDs+"&HospDr="+HospID+"&DisplayType="+DisplayType;
	websys_showModal({
		url:url,
		title:' '+Title+'选择',
		width:440,height:610,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if ((typeof result==="undefined")||(result===false)){
				return;
			}
			
			var NewPriorIDs=result.replace(/!/g,",")
			var value =tkMakeServerCall("DHCDoc.DHCDocConfig.StopConfig","SetNurOperatDocAuthfig",HospID,OperatTypeCode,ConfigType,NewPriorIDs)
			if(value=="0"){
				LoadItemCatExtDataGrid()
				$.messager.show({title:"提示",msg:"更新成功"});
			}else{
				$.messager.alert('提示',"更新失败:"+value,'error');
				return false;
			}
		}
	})
}
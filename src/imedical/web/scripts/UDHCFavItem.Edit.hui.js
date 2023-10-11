var PageLogicObj={
	m_ARCOSRowid:"",
	m_rightMenuRowObj:{},
	m_CNFreqArr:"",
	m_CNDurationArr:"",
	m_CNInstrArr:"",
	m_CNPrescTypeArr:"",
	m_UDHCARCOrderSetItemEdit:""
};
var DescchangeTime;
$(function(){
	Init();
	InitEvent();
	if (TDis ==1) {
		$("#mainLayout").layout('panel', 'west').panel("resize",{width:753});
		$("#SearchDesc,#SearchAlias").css('width',150);
		$("#SearchDesc").parents("table").css('width',733);
	}
})
function Init(){
	CombListCreat();
	//InitARCOrdSetsTreeGrid();
	InitOrderSetItemEdit();
}
function InitEvent(){
	$("#BSaveARCLocAuthorize").click(BSaveARCLocAuthorize);
	$("#SaveARCOSBtn").click(SaveARCOSClick);
	$("#Desc").change(DescChange);
	$("#Desc").keydown(function(e){
		var keycode = websys_getKey(e);
		if ((keycode==9||keycode==13)){
			$(this).blur();
		}
	});
	$("#ClearFind").click(function(){
		$("#SearchDesc,#SearchAlias").val("");
		$("#SearchSubCategory,#SearchConditiones").combobox('setValue',"");
		$("#SearchCelerType").checkbox('uncheck');
		$('#ARCOrdSetsTreeGrid').treegrid('reload');
	});
	$("#Search1").click(function(){
		$('#ARCOrdSetsTreeGrid').treegrid('reload');
	});
	$('#right').menu({
		onShow:function(){
			if(!PageLogicObj.m_rightMenuRowObj.ARCOSRowid) return true;
			InitFavSaveMenu();
		}
	});
}
function DescChange(e){
	clearTimeout(DescchangeTime);
    DescchangeTime = setTimeout(function() { AutoSetAlias(e);}, 250);
}
function InitARCOrdSetsTreeGrid(){
	var Columns=[[
        //{field:'CheckArcos',title:'选择',hidden:true},
		//{field:'ARCOSOrdCat',title:'大类',width:80,align:'left'},
		{field:'Name',title:'组套',width:200,sortable:true},
		{field:'ARCOSOrdSubCat',title:'子类',width:100,sortable:true},
		{field:'ARCOSCode',title:'代码',width:100,sortable:true},   
		//{field:'ARCOSDesc',title:'名称',width:150,sortable:true},   
		{field:'ARCOSAlias',title:'别名',width:100,sortable:true},
		{field:'CelerType',title:'快速',width:50,sortable:true},
		{field:'FavUserDesc',title:'用户',width:80,sortable:true},
		{field:'FavDepDesc',title:'使用科室',width:100,sortable:true},
		{field:'FavDateTo',title:'结束日期',width:100,sortable:true},
		{field:'ARCOSAddUser',title:'创建人',width:80,sortable:true},
		{field:'ARCOSAddDate',title:'创建时间',width:150,sortable:true},
		{field:'MedUnitDesc',title:'组名',width:100,hidden:true},
		{field:'ARCOSRowid',title:'ARCOSRowid',width:100,hidden:true},   
		{field:'ARCOSOrdSubCatDR',title:'ARCOSOrdSubCatDR',width:100,hidden:true}, 
		{field:'ARCOSEffDateFrom',title:'生效日期',width:100,hidden:true}, 
		{field:'FavRowid',title:'FavRowid',width:100,hidden:true}, 
		{field:'ARCOSOrdCatDR',title:'ARCOSOrdCatDR',width:100,hidden:true}, 
		{field:'FavUserDr',title:'用户ID',width:100,hidden:true}, 
		{field:'FavDepDr',title:'科室ID',width:100,hidden:true}, 
		{field:'MedUnit',title:'组',width:100,hidden:true},
		{field:'PrescTypeCode',hidden:true},
        {field:'DuratId',hidden:true},
        {field:'FreqId',hidden:true},
        {field:'InstrId',hidden:true},
        {field:'DosageId',hidden:true},
        {field:'Notes',hidden:true}
    ]];
    $HUI.treegrid('#ARCOrdSetsTreeGrid',{
		toolbar:[],
		checkbox:true,
		fitColumns:false,
	    idField:'Index',
	    treeField:'Name',
	    headerCls:'panel-header-gray',
	    fit : true,
	    border: false,   
	    columns:Columns,
	    url:$URL+"?ClassName=web.DHCUserFavItems&MethodName=GetDHCDocARCOSList",
		onSelect:function(index,rowData){
			if(!$(event.target).hasClass('tree-checkbox')){
				$('#ARCOrdSetsTreeGrid').treegrid('checkNode',rowData.Index);
			}
			$("#UDHCARCOrderSetItemEdit").parent().prev().show();
			var Level=$('#ARCOrdSetsTreeGrid').treegrid('getLevel',rowData.Index);
			if (Level>1) {
				PageLogicObj.m_ARCOSRowid=rowData.ARCOSRowid;
				if(!UserAuthObj[rowData.Type]){
					$("#UDHCARCOrderSetItemEdit").parent().prev().hide();
				}
			}else{
				PageLogicObj.m_ARCOSRowid="";
			}
			LoadUDHCARCOrderSetItemEditDataGrid();
		},
		rowStyler: function(rowData){
			if (rowData.ActiveFlag=="0"){
				return 'color:red;';
			}
		},
		onContextMenu:function(e, rowData){
			e.preventDefault(); //阻止浏览器捕获右键事件
			$('#ARCOrdSetsTreeGrid').treegrid('select',rowData.Index);
			$("#right .menu-sep,#right .menu-item").show();
			if(!UserAuthObj[rowData.Type]){
				$("#AddARCOS,#AddSameFavARCOS,#UpdateARCOS,#OtherARCAlias,#SetARCOSEPrice,#DelARCOS,#ARCOSAuthorize,#ARCOSSaveToOrdTempl").hide();
				$("#AddARCOS,#AddSameFavARCOS,#UpdateARCOS,#OtherARCAlias,#SetARCOSEPrice,#DelARCOS,#ARCOSAuthorize,#ARCOSSaveToOrdTempl").next(".menu-sep").hide();
			}else{
				var CONTEXT="";
				var CheckedNodes=$('#ARCOrdSetsTreeGrid').treegrid('getCheckedNodes');
				for(var i=0;i<CheckedNodes.length;i++){
					var FavRowid=CheckedNodes[i].FavRowid;
					if(!FavRowid) continue;
					if(!UserAuthObj[CheckedNodes[i].Type]){
						$.messager.popover({msg: $g('没有操作[')+CheckedNodes[i].Name+$g(']权限!'),type:'error'});
						CONTEXT="";
						break;
					}
					var tmpCONTEXT=(CNMedItemCatStr.indexOf("^"+CheckedNodes[i].ARCOSOrdSubCatDR+"^")>-1)?'W50007':'WNewOrderEntry';
					if((CONTEXT!="")&&(tmpCONTEXT!=CONTEXT)){
						$.messager.popover({msg: '同时勾选草药与西药医嘱套,不能保存模板',type:'alert'});
						CONTEXT="";
						break
					}
					CONTEXT=tmpCONTEXT;
				}
				if(CONTEXT==''){
					$("#ARCOSSaveToOrdTempl").hide();
					$("#ARCOSSaveToOrdTempl").next(".menu-sep").hide();
				}
			}
			var Level=$('#ARCOrdSetsTreeGrid').treegrid('getLevel',rowData.Index);
			if (Level==1) {
				$("#AddSameFavARCOS,#UpdateARCOS,#SetARCOSEPrice,#OtherARCAlias,#ARCOSAuthorize,#SaveAsUserARCOS,#SaveAsLocARCOS,#SaveAsHospARCOS,#ARCOSSaveToOrdTempl").hide();
				$("#AddSameFavARCOS,#UpdateARCOS,#SetARCOSEPrice,#OtherARCAlias,#ARCOSAuthorize,#SaveAsUserARCOS,#SaveAsLocARCOS,#SaveAsHospARCOS,#ARCOSSaveToOrdTempl").next(".menu-sep").hide();
			}else {
				$("#AddARCOS").hide();
				if(rowData.Type=='User'){
					$("#SaveAsUserARCOS").hide();
					$("#SaveAsUserARCOS").next(".menu-sep").hide();
				}else if(rowData.Type=='Loc'){
					$("#SaveAsLocARCOS").hide();
					$("#SaveAsLocARCOS").next(".menu-sep").hide();
				}else if(rowData.Type=='Hosp'){
					$("#SaveAsHospARCOS").hide();
					$("#SaveAsHospARCOS").next(".menu-sep").hide();
				}
			}
			PageLogicObj.m_rightMenuRowObj=rowData;
			// 显示快捷菜单
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
		onDblClickRow:function(ARCOSRowid,rowData){
			if (TDis ==1) {
				if ((ARCOSRowid!="User")&&(ARCOSRowid!="Loc")&&(ARCOSRowid!="Hosp")) {
					var row=$("#ARCOrdSetsTreeGrid").treegrid("find",ARCOSRowid);
					if(!UserAuthObj[rowData.Type]){
						$.messager.popover({msg: '无对应医嘱套权限!',type:'alert'});
						return;
					}
					var ARCOSOrdSubCatDR=row.ARCOSOrdSubCatDR;
					if ((CMFlag=="Y")&&(CNMedItemCatStr.indexOf("^"+ARCOSOrdSubCatDR+"^")<0)) {
						$.messager.alert('提示','请选择草药医嘱套！'); 
						return;
					}
					if ((CMFlag=="Y")&&(rowData.PrescTypeCode!=PreCMPrescTypeCode)){
						$.messager.alert('提示','请选择对应剂型的草药医嘱套！'); 
						return;
						}
					if ((CMFlag=="N")&&(CNMedItemCatStr.indexOf("^"+ARCOSOrdSubCatDR+"^")>=0)) {
						$.messager.alert('提示','请选择西药医嘱套！'); 
						return;
					}
					if (row.ActiveFlag=="0"){
						$.messager.confirm("确认对话框", "该医嘱套已经失效，是否继续保存到该医嘱套？", function (r) {
							if (r) {
								CloseWindow(ARCOSRowid);
							}
						});
					}else{
						CloseWindow(ARCOSRowid);
					}
				}
			}
		},
		onBeforeLoad:function(row, param){
			PageLogicObj.m_ARCOSRowid="";
			if (PageLogicObj.m_UDHCARCOrderSetItemEdit){
				 LoadUDHCARCOrderSetItemEditDataGrid();
			}
			$('#ARCOrdSetsTreeGrid').treegrid('unselectAll').treegrid('clearChecked');
			var SearchSubCatID=$("#SearchSubCategory").combobox('getValue');
			if (!SearchSubCatID) SearchSubCatID="";
			var SearchDesc=$("#SearchDesc").val();
			var SearchAlias=$("#SearchAlias").val();
			var SearchCelerType=$("#SearchCelerType").checkbox('getValue')?"Y":"N";
			var SearchConditiones=$("#SearchConditiones").combobox('getValue');
			if (!SearchConditiones) SearchConditiones="";
			
			$.extend(param,{
				SearchSubCatID:SearchSubCatID,
				SearchDesc:SearchDesc,SearchAlias:SearchAlias,SearchCelerType:SearchCelerType,SearchConditiones:SearchConditiones,
				LogonUserID:session['LOGON.USERID'], LogonCTLocId:session['LOGON.CTLOCID'],LogonHospID:session['LOGON.HOSPID']
			});
		}
	});
}
function FindDeptChange(value){
	value=value.toUpperCase();
	var matchIndexArr=new Array();
	var _$selOptions=$("#List_OrderDept option");
	var Obj=document.getElementById('List_OrderDept');
	for (var i=0;i<Obj.length;i++){
		$(_$selOptions[i]).show();
		var DepDesc=Obj[i].text;
		var DepArr=DepDesc.split("-");
		var selText=DepArr[0].toUpperCase();
		var selCode="";
		if (DepArr[1]) {
			selCode=DepArr[1].toUpperCase();
		}
		if ((selText.indexOf(value)>=0)||(selCode.indexOf(value)>=0)){
			matchIndexArr.push(i);
		}else{
			$(_$selOptions[i]).hide();
		}
	}
	if ((matchIndexArr.length>=1)&&(value!="")){
		Obj.selectedIndex=matchIndexArr[0];
	}
}
function CloseWindow(ARCOSRowidGet,ARCOSSubCatID,ARCOSDesc){
    if (websys_showModal('options')) {
		websys_showModal("hide");
		if (websys_showModal('options').SaveItemToARCOS) {
			websys_showModal('options').SaveItemToARCOS(ARCOSRowidGet);
		}
		if (websys_showModal('options').CallBackFunc) {
			websys_showModal('options').CallBackFunc(ARCOSRowidGet);
		}
		websys_showModal("close");
	}else{
		if(ARCOSRowidGet){
			$.messager.confirm("确认对话框", $g("是否将医嘱套【")+ARCOSDesc+$g("】保存到医嘱模板？"), function (r) {
				if (r) {
					var Type="西药";
					if(CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")>-1){	//是中草药医嘱套
						Type="草药";
					}
					OpenOrdTemplateWin(Type,ARCOSRowidGet,ARCOSDesc);
				}
			});
		}
	}
}
//加载医嘱套详细信息
function LoadUDHCARCOrderSetItemEditDataGrid(type)
{
	if($('#UDHCARCOrderSetItemEdit').length<=0){return}
	if (typeof(type) == "undefined") type="";
	var QueryFlag=""
	if (PageLogicObj.m_ARCOSRowid!=""){QueryFlag=1}
	$('#UDHCARCOrderSetItemEdit').closest('.panel-body').showMask();
	$.cm({
	    ClassName : "web.DHCARCOrdSets",
	    QueryName : "FindOSItem",
	    ARCOSRowid:PageLogicObj.m_ARCOSRowid, QueryFlag:QueryFlag,
	    Pagerows:$('#UDHCARCOrderSetItemEdit').datagrid("options").pageSize,rows:99999
	},function(GridData){
		$('#UDHCARCOrderSetItemEdit').datagrid('unselectAll').datagrid('loadData',GridData);
		//如果是医嘱明细维护界面新增的明细，则自动跳转到最后一页的最后一条记录
		if (type!=""){
			var total=parseInt($('#UDHCARCOrderSetItemEdit').datagrid('getData').total);
			var pageSize=parseInt($('#UDHCARCOrderSetItemEdit').datagrid("options").pageSize);
			var LastPage=Math.ceil(total/pageSize);
			if (LastPage>1){
				$('#UDHCARCOrderSetItemEdit').datagrid('getPager').pagination('select',LastPage); //跳转到最后一页
				var LastPageData=$('#UDHCARCOrderSetItemEdit').datagrid('getData');
				$('#UDHCARCOrderSetItemEdit').datagrid("scrollTo",LastPageData.rows.length-1)
			}else{
				$('#UDHCARCOrderSetItemEdit').datagrid("scrollTo",total-1);
			}
		}
		$('#UDHCARCOrderSetItemEdit').closest('.panel-body').hideMask();
	})
}
function InitOrderSetItemEdit() {
	ARCOSItemToolBar = [{
            text: '新增',
            iconCls: 'icon-add',
            handler: function() { 
               LAddClickHandler();
            }
        }, {
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
               LDeleteClickHandler();
            }
        },{
            text: '修改',
            iconCls: 'icon-edit',
            handler: function() {
			  LUpdateClickHandler();
            }
        },
        '-', {
            text: '上移',
            iconCls: 'icon-arrow-top',
            handler: function() {
                upClick();
            }
        },{
            text: '下移',
            iconCls: 'icon-arrow-bottom',
            handler: function() {
                dwClick();
            }
        }];
	//医嘱套详细信息
	PageLogicObj.m_UDHCARCOrderSetItemEdit=$('#UDHCARCOrderSetItemEdit').datagrid({  
		url:'',
		width : 'auto',
		fit:true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : true,
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : false,  //
		idField:"NO", 
		pageSize:20,
		pageList : [20,50,100,500],
		toolbar :ARCOSItemToolBar,
		columns :[[
			{field:'NO',title:'序号',width:50},
			{field:'ARCIMDesc',title:'名称',width:300,align:'left',
				formatter: function(value,row,index){
					if(row.ValidItemFlag!='1'){
						value='<span style="color:red;">['+$g("项目已无效")+']</span>'+value;
					}
					return value;
				},
				styler:function(value,row,index){
					if(row.ValidItemFlag!='1'){
						return "background:#D9D9D9;"
					}
				}
			}, 
			{field:'ARCOSItemDoseQty',title:'剂量',width:100},
			{field:'ARCOSItemUOM',title:'剂量单位',width:100},
			{field:'ARCOSItemFrequence',title:'频次',width:100},
			{field:'ARCOSItemInstruction',title:'用法',width:100},
			{field:'ARCOSItemDuration',title:'疗程',width:50},  
			{field:'ARCOSItemQty',title:'数量',width:60},   
			{field:'ARCOSItemBillUOM',title:'单位',width:50},
			{field:'ARCOSItmLinkDoctor',title:'关联',width:50},
			{field:'Tremark',title:'备注',width:150},
			{field:'ARCOSDHCDocOrderType',title:'医嘱类型',width:100},
			{field:'SampleDesc',title:'标本',width:100},
			{field:'OrderPriorRemarks',title:'附加说明',width:100},
			{field:'DHCDocOrdRecLoc',title:'接收科室',width:200},
			{field:'DHCDocOrdStage',title:'医嘱阶段',width:150},
			{field:'DHCMustEnter',title:'必开项',width:80},
			{field:'SpeedFlowRate',title:'输液流速',width:80},
			{field:'FlowRateUnit',title:'流速单位',width:85},
			{field:'ARCOSItemRowid',title:'ARCOSItemRowid',width:100,hidden:true},   
			{field:'ARCIMRowid',title:'ARCIMRowid',width:100,hidden:true}, 
			{field:'ARCOSItemUOMDR',title:'ARCOSItemUOMDR',width:100,hidden:true}, 
			{field:'ARCOSItemFrequenceDR',title:'ARCOSItemFrequenceDR',width:100,hidden:true}, 
			{field:'ARCOSItemDurationDR',title:'ARCOSItemDurationDR',width:100,hidden:true}, 
			{field:'ARCOSItemInstructionDR',title:'ARCOSItemInstructionDR',width:100,hidden:true}, 
			{field:'ARCOSDHCDocOrderTypeDR',title:'ARCOSDHCDocOrderTypeDR',width:100,hidden:true}, 
			{field:'SampleID',title:'SampleID',width:100,hidden:true}, 
			{field:'ITMSerialNo',title:'ITMSerialNo',width:100,hidden:true}, 
			{field:'OrderPriorRemarksDR',title:'OrderPriorRemarksDR',width:100,hidden:true}
		
		 ]],
    	onDblClickRow:function(rowid,RowData){
			//ModifyHospArcosFlag 未定义？ 
    	    //if (ModifyHospArcosFlag=="0") return false;
    		//定义双击编辑事件
			var rowData=$('#ARCOrdSetsTreeGrid').treegrid('getSelected');
    	    if(!UserAuthObj[rowData.Type]){
				$.messager.popover({msg: '无对应医嘱套权限!',type:'alert'});
				return;
			}
    		var EARCOSItemRowid=RowData.ARCOSItemRowid;
    		if (EARCOSItemRowid!=""){
	    		var ARCIMRowid=RowData.ARCIMRowid;
				OpenArcosEditWindow(PageLogicObj.m_ARCOSRowid,EARCOSItemRowid,ARCIMRowid);
    		}
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});	
}
// 新增医嘱套项目
function LAddClickHandler(){
	OpenArcosEditWindow(PageLogicObj.m_ARCOSRowid,"")
}

//修改医嘱套明细-内容
function LUpdateClickHandler(){
	var rowdata=$('#UDHCARCOrderSetItemEdit').datagrid('getSelections')
	if (rowdata){
		if (rowdata.length==0){
			$.messager.alert('提示','请选择需要修改的项目!');
			return false;
		}
		if (rowdata.length>1){
			$.messager.alert('提示','请选择一条有效的医嘱信息进行更新');
			return false;
		}
		var ARCOSItemRowid=rowdata[0].ARCOSItemRowid;
		var ARCIMRowid=rowdata[0].ARCIMRowid;
		OpenArcosEditWindow(PageLogicObj.m_ARCOSRowid,ARCOSItemRowid,ARCIMRowid)
	}
}
//打开医嘱套明细编辑窗口
function OpenArcosEditWindow(EditARCOSRowid,ARCOSItemRowid,ARCIMRowid){
	if (EditARCOSRowid==""){
	   $.messager.alert('提示','请选择相应的医嘱套');
	   return false;
   	}
   	websys_showModal({
		iconCls:'icon-w-edit',
		url:"udhcfavitem.edit.newedit.csp?&ARCOSItemRowid="+ARCOSItemRowid+"&ARCOSRowid="+EditARCOSRowid+"&ARCIMRowid="+ARCIMRowid,
		title:'医嘱套明细维护',
		width:'490px',height:'560px',
		LoadUDHCARCOrderSetItemEditDataGrid:LoadUDHCARCOrderSetItemEditDataGrid
	})
}
//删除医嘱套明细
function LDeleteClickHandler()
{
	var rowdata=$('#UDHCARCOrderSetItemEdit').datagrid('getSelections')
	if (rowdata){
		if (rowdata.length==0){
			$.messager.alert('提示','请选择需要删除的医嘱!');
			return false;
		}
		$.messager.confirm("确认对话框", "是否删除医嘱数据？", function (r) {
			if (r) {
				for (var i=0;i<rowdata.length;i++){
					var ARCOSItemRowid=rowdata[i].ARCOSItemRowid;
					var ARCIMDesc=rowdata[i].ARCIMDesc;
					var ARCIMRowid=rowdata[i].ARCIMRowid;
					if (ARCOSItemRowid!=""){
						var ReturnValue=$.cm({
							ClassName:"web.DHCARCOrdSets",
							MethodName:"DeleteItem",
							ARCOSItemRowid:ARCOSItemRowid, 
							ARCIMRowid:ARCIMRowid,
							dataType:"text"
						},false);
						if (ReturnValue=="-1"){
							$.messager.alert('提示',ARCIMDesc+'删除失败');
							return false;
						}
					}
				}
				LoadUDHCARCOrderSetItemEditDataGrid()
			}
		})
	}
}
function upClick(){
	Mouvw("up")
}
function dwClick(){
	Mouvw("dw")
}
function Mouvw(Type){
	var row = $('#UDHCARCOrderSetItemEdit').datagrid('getSelected');
    var index = $('#UDHCARCOrderSetItemEdit').datagrid('getRowIndex', row);
    var rows = $('#UDHCARCOrderSetItemEdit').datagrid('getRows').length;
	if (Type=="up"){
		if (index != 0) {
			var toup = $('#UDHCARCOrderSetItemEdit').datagrid('getData').rows[index];
            var todown = $('#UDHCARCOrderSetItemEdit').datagrid('getData').rows[index - 1];
            
            var TopNO=toup.NO; 
            var TopARCOSItemNO=toup.ITMSerialNo; 
            
            var DwNO=todown.NO;
            var DwARCOSItemNO=todown.ITMSerialNo;
            
            todown.NO=TopNO;
            todown.ITMSerialNo=TopARCOSItemNO;
            
            toup.ITMSerialNo=DwARCOSItemNO;
            toup.NO=DwNO;
            
            $('#UDHCARCOrderSetItemEdit').datagrid('getData').rows[index] = todown;
            $('#UDHCARCOrderSetItemEdit').datagrid('getData').rows[index - 1] = toup;
            $('#UDHCARCOrderSetItemEdit').datagrid('refreshRow', index);
            $('#UDHCARCOrderSetItemEdit').datagrid('refreshRow', index - 1);
            $('#UDHCARCOrderSetItemEdit').datagrid('selectRow', index - 1);
            var rtn=UpdateSerialNO(todown.ARCOSItemRowid,todown.ITMSerialNo,todown.ARCIMRowid)
            var rtn=UpdateSerialNO(toup.ARCOSItemRowid,toup.ITMSerialNo,toup.ARCIMRowid)
		}
	}else if (Type=="dw"){
		  if (index != rows - 1){
			var todown = $('#UDHCARCOrderSetItemEdit').datagrid('getData').rows[index];
            var toup = $('#UDHCARCOrderSetItemEdit').datagrid('getData').rows[index + 1];
            var TopNO=toup.NO; 
            var TopARCOSItemNO=toup.ITMSerialNo;
            
            var DwARCOSItemNO=todown.ITMSerialNo;
            var DwNO=todown.NO;
            
            todown.NO=TopNO;;
            todown.ITMSerialNo=TopARCOSItemNO;
            
            toup.NO=DwNO;
            toup.ITMSerialNo=DwARCOSItemNO;
         
            $('#UDHCARCOrderSetItemEdit').datagrid('getData').rows[index + 1] = todown;
            $('#UDHCARCOrderSetItemEdit').datagrid('getData').rows[index] = toup;
            $('#UDHCARCOrderSetItemEdit').datagrid('refreshRow', index);
            $('#UDHCARCOrderSetItemEdit').datagrid('refreshRow', index + 1);
            $('#UDHCARCOrderSetItemEdit').datagrid('selectRow', index + 1);
            var rtn=UpdateSerialNO(todown.ARCOSItemRowid,todown.ITMSerialNo,todown.ARCIMRowid)
            var rtn=UpdateSerialNO(toup.ARCOSItemRowid,toup.ITMSerialNo,toup.ARCIMRowid)
		}
	}	
}
///更新序列
function UpdateSerialNO(ARCOSItemRowid,SerNO,arcimid){	
	 var rtn=tkMakeServerCall("web.DHCARCOrdSets","UpdateItemSerialNo",ARCOSItemRowid,SerNO,arcimid)
	 return rtn	
}
function AddARCOSClick(){
	ClearARCOSData();
	if (PageLogicObj.m_rightMenuRowObj.ARCOSRowid) {
		var FavUserDr=PageLogicObj.m_rightMenuRowObj.FavUserDr;		
		var FavDepDr=PageLogicObj.m_rightMenuRowObj.FavDepDr;
		if (FavUserDr!="") {
			$('#Conditiones').combobox('setValue',1);
		}else if(FavDepDr!="") {
			$('#Conditiones').combobox('setValue',2);
		}else{
			$('#Conditiones').combobox('setValue',3);
		}
	}else{
		var Type=PageLogicObj.m_rightMenuRowObj.Type;
		if (Type =="User") {
			$('#Conditiones').combobox('setValue',1);
		}else if(Type =="Loc") {
			$('#Conditiones').combobox('setValue',2);
		}else{
			$('#Conditiones').combobox('setValue',3);
		}
	}
	$('#ARCOSSetWin').window({
		iconCls:'icon-w-add',
		title: "新增",
		zIndex:9999,
		iconCls:'icon-w-edit',
		inline:false,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closable:true,
		shadow:false
	});
	$("#SubCategory").next('span').find('input').focus();
}
function UpdateARCOSClick(){
	SetARCOSDataFromRow();
	$('#ARCOSSetWin').window({
		iconCls:'icon-w-edit',
		title: "<span style='color:"+(HISUIStyleCode=="lite"?"#FF9933":"#FFB746")+"'>"+PageLogicObj.m_rightMenuRowObj.ARCOSDesc+'</span>'+$g(' 医嘱套信息修改'),
		zIndex:9999,
		iconCls:'icon-w-edit',
		inline:false,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closable:true,
		shadow:false,
		onClose:function(){
			$("#FavRowid").val("");
		}
	});
	$("#Desc").focus();
}
function DelARCOSClick(){
	var delFavRowidArr=new Array();
	var delARCOSRowidArr=new Array();
	var FindARCOSRowid=false;
	var CheckedNodes=$('#ARCOrdSetsTreeGrid').treegrid('getCheckedNodes');
	for(var i=0;i<CheckedNodes.length;i++){
		var FavRowid=CheckedNodes[i].FavRowid;
		if(!FavRowid) continue;
		if(!UserAuthObj[CheckedNodes[i].Type]){
			$.messager.popover({msg: $g('没有删除[')+CheckedNodes[i].Name+$g(']权限!'),type:'error'});
			return false;
		}
		delFavRowidArr.push(FavRowid);
		delARCOSRowidArr.push(CheckedNodes[i].ARCOSRowid);
		if (CheckedNodes[i].ARCOSRowid ==PageLogicObj.m_ARCOSRowid) {
			FindARCOSRowid=true;
		}
	}
	if(!delFavRowidArr.length){
		$.messager.popover({msg: '请勾选需要删除的医嘱套',type:'alert'});
		return false;
	}
	$.messager.confirm("确认对话框", "确认删除勾选的医嘱套数据？", function (r) {
		if(r){
			var ReturnValue=$.cm({
				ClassName:"web.DHCUserFavItems",
				MethodName:"DeleteUserARCOSMulti",
				FavRowidStr:delFavRowidArr.join("^"), 
				dataType:"text"
			},false);
			if (ReturnValue=='-1') {
				$.messager.alert('提示','删除失败.');  
			}else{
				$.messager.popover({msg: '删除成功!',type:'success'});
				for (var i=0;i<delARCOSRowidArr.length;i++){
					$('#ARCOrdSetsTreeGrid').treegrid('remove',delARCOSRowidArr[i]);
				}
				if (FindARCOSRowid) {
					PageLogicObj.m_ARCOSRowid="";
					LoadUDHCARCOrderSetItemEditDataGrid();
				}
			}
		}
	});
}
function SaveAsARCOSClick(ToType){
	var ARCOSRowidArr=new Array();
	var CheckedNodes=$('#ARCOrdSetsTreeGrid').treegrid('getCheckedNodes');
	for(var i=0;i<CheckedNodes.length;i++){
		var FavRowid=CheckedNodes[i].FavRowid;
		if(!FavRowid) continue;
		if(CheckedNodes[i].Type==ToType){
			$.messager.popover({msg: '['+CheckedNodes[i].Name+'] '+$g('与复制权限相同!'),type:'error'});
			return;
		}
		ARCOSRowidArr.push(CheckedNodes[i].ARCOSRowid);
	}
	if(!ARCOSRowidArr.length) return;
	var ret=$.cm({
		ClassName:'DHCDoc.Order.Sets',
		MethodName:'CopyToOtherAuth',
		ASCOSRowids:ARCOSRowidArr.join('^'), 
		UserID:session['LOGON.USERID'], LocID:session['LOGON.CTLOCID'], HospID:session['LOGON.HOSPID'], 
		ToType:ToType,
		dataType:'text'
	},false);
	if(ret==0){
		$.messager.popover({msg: '另存医嘱套成功！',type:'success'});
		$('#ARCOrdSetsTreeGrid').treegrid('reload');
	}else{
		$.messager.alert('提示',$g("另存医嘱套失败:")+ret);
	}
}
function AppendTreeGridRowByFavRowId(FavRowid,type,OpertionType){
	var dataObj=$.cm({
		ClassName:"web.DHCUserFavItems",
		MethodName:"GetARCOSDataByFavRowid",
		FavRowId:FavRowid.replace(/(^\s*)|(\s*$)/g,'')
	},false);
	if (OpertionType=="A") {
		var Childrens=$('#ARCOrdSetsTreeGrid').treegrid("getChildren",type);
		if (Childrens.length>0) {
			$('#ARCOrdSetsTreeGrid').treegrid('insert',{
				before: Childrens[0].Index,
				data: dataObj[0]
			});
		}else{
			$('#ARCOrdSetsTreeGrid').treegrid('append',{
				parent: type,
				data: dataObj
			});
		}
	}else if(OpertionType =="U"){
		var OldObj=$('#ARCOrdSetsTreeGrid').treegrid('find',dataObj[0].ARCOSRowid);
		var FavUserDr=OldObj.FavUserDr;		
		var FavDepDr=OldObj.FavDepDr;
		if (FavUserDr!="") {
			var OldType="User";
		}else if(FavDepDr!="") {
			var OldType="Loc";
		}else{
			var OldType="Hosp";
		}
		if (OldType ==type) {
			$('#ARCOrdSetsTreeGrid').treegrid('update',{
				id: dataObj[0].ARCOSRowid,
				row: dataObj[0]
			});
		}else{
			$('#ARCOrdSetsTreeGrid').treegrid('remove',dataObj[0].ARCOSRowid);
			var Childrens=$('#ARCOrdSetsTreeGrid').treegrid("getChildren",type);
			if (Childrens.length>0) {
				$('#ARCOrdSetsTreeGrid').treegrid('insert',{
					before: Childrens[0].Index,
					data: dataObj[0]
				});
			}else{
				$('#ARCOrdSetsTreeGrid').treegrid('append',{
					parent: type,
					data: dataObj
				});
			}
		}
	}
	$('#ARCOrdSetsTreeGrid').treegrid('clearChecked').treegrid('select',dataObj[0].Index);
}
function SetARCOSEPriceClick(){
	var ARCOSRowid=PageLogicObj.m_rightMenuRowObj.ARCOSRowid;
	websys_showModal({
		iconCls:'icon-w-edit',
		url:"doc.favitemprice.hui.csp?ARCOSRowid="+ARCOSRowid,
		title:"<span style='color:"+(HISUIStyleCode=="lite"?"#FF9933":"#FFB746")+"'>"+PageLogicObj.m_rightMenuRowObj.ARCOSDesc+'</span> '+$g('包装价格维护'),
		width:'1130px',height:'500px'
	})
}
function OtherARCAliasClick(){
	var ARCOSRowid=PageLogicObj.m_rightMenuRowObj.ARCOSRowid;
	websys_showModal({
		iconCls:'icon-w-edit',
		url:"dhcdoc.arcosoteralias.hui.csp?ARCOSRowid="+ARCOSRowid,
		title:"<span style='color:"+(HISUIStyleCode=="lite"?"#FF9933":"#FFB746")+"'>"+PageLogicObj.m_rightMenuRowObj.ARCOSDesc+'</span>'+$g(' 医嘱套别名维护'),
		width:'500px',height:'500px'
	})
}
function AuthorizeSetWinClick(){
	var CheckedOSRowids=GetCheckedOSRowids();
	if(!CheckedOSRowids) return;
	if(!CheckedOSRowids.length){
		$.messager.popover({msg: '请勾选需授权的医嘱套',type:'alert'});
		return;
	}
	//授权科室列表
	LoadOrderDept("List_OrderDept");
	$("#FindDept").searchbox("setValue","");
	if ($("#RecSetWin").hasClass('window-body')){
		$('#RecSetWin').window('open');
	}else{
		ShowHolidaysRecSetWin();
	}
	$("#FindDept").next('span').find('input').focus();
}
function LoadOrderDept(param1){
	$("#List_OrderDept").empty();
	var CheckedOSRowids=GetCheckedOSRowids();
	var ARCOSRowid=CheckedOSRowids[0];
	$.cm({
		ClassName:"web.DHCARCOrdSetsAuthorize",
		QueryName:"FindDep",
		ARCOSRowId:ARCOSRowid,
		LogonHospDr:$HUI.combogrid('#_HospUserList').getValue(),
		rows:"99999",
	},function(objScope){
	   var vlist = ""; 
	   var selectlist="";
	   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.CTLOCRowID + " alias=" + n.alias + ">" + n.CTLOCDesc + "</option>"; 
       });
       $("#"+param1+"").append(vlist); 
	   if(CheckedOSRowids.length==1){
			for (var j=1;j<=selectlist.split("^").length;j++){
				if(selectlist.split("^")[j]=="true"){
					$("#"+param1+"").get(0).options[j-1].selected = true;
				}
			}
	   }
	});
}
function ShowHolidaysRecSetWin(){
	$('#AuthorizeSetWin').window({
		title: $g('医嘱套授权'),
		zIndex:9999,
		iconCls:'icon-w-edit',
		inline:false,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closable:true,
		onOpen:function(){
			$('#_HospUserList').setValue(session['LOGON.HOSPID']);
		}
	});
}
function BSaveARCLocAuthorize(){
	var CheckedOSRowids=GetCheckedOSRowids().join('^');
	var LocStr="";
	var obj=$("#List_OrderDept").find("option:selected");
	for (var i=0;i<obj.length;i++){
		var LocID=obj[i].value;
		if (LocStr=="") LocStr=LocID;
		else LocStr=LocStr+"^"+LocID;
	}
	var rtn=$.cm({
		ClassName:"web.DHCARCOrdSetsAuthorize",
		MethodName:"SaveARCLocAuthorize",
		ARCOSRowIds:CheckedOSRowids,
		LocStr:LocStr,
		dataType:"text"
	},false);
	if(rtn==0){
		$("#AuthorizeSetWin").window('close');
	}else{
		$.messager.alert('提示',$g('授权失败:')+rtn);
	}
}
function ARCOSCopyClick(){
	websys_showModal({
		iconCls:'icon-w-copy',
		url:"udhcfavitem.copy.csp",
		title:$g('引用医嘱套'),
		width:'90%',height:'90%',
		onClose:function(){
			$('#ARCOrdSetsTreeGrid').treegrid('reload');
		}
	})
}
function ARCOSSaveToOrdTemplClick(){
    var Type="西药";
	var ARCOSOrdSubCatDR=PageLogicObj.m_rightMenuRowObj.ARCOSOrdSubCatDR;
	if(CNMedItemCatStr.indexOf("^"+ARCOSOrdSubCatDR+"^")>-1){	//是中草药医嘱套
		Type="草药";
	}
	OpenOrdTemplateWin(Type,PageLogicObj.m_rightMenuRowObj.ARCOSRowid,PageLogicObj.m_rightMenuRowObj.ARCOSDesc);
}
function OpenOrdTemplateWin(Type,ARCOSRowid,ARCOSDesc){
	websys_showModal({
		iconCls:'icon-w-save',
		url:"doc.arcossavetotemplate.hui.csp?Type="+Type,
		title:"<span style='color:"+(HISUIStyleCode=="lite"?"#FF9933":"#FFB746")+"'>"+ARCOSDesc+'</span>'+$g(' 保存到医嘱模板'),
		paraObj:{name:ARCOSRowid},
		width:'500px',height:'420px'
	})
}
function SaveARCOSClick(){
	clearTimeout(DescchangeTime);
	var Contions=$("#Conditiones").getValue();
	if (Contions==""){
		$.messager.alert('提示','条件为必选项,请选择!');
		return false;
	}
	if ((!UserAuthObj["Loc"])&&(Contions=="2")){
		$.messager.alert('提示','用户没有保存科室医嘱套的权限!');
		return false;
	}
	if ((!UserAuthObj["Hosp"])&&(Contions=="3")){
		$.messager.alert('提示','用户没有保存全院医嘱套的权限!');
		return false;
	}
	var UserID=session['LOGON.USERID'];
	if (UserID==""){
		$.messager.alert('提示','缺少用户信息,请刷新界面或从新登陆后再次尝试!'); 
		return;
	}
	var UserCode=session["LOGON.USERCODE"];
	var GroupID=session['LOGON.GROUPID'];
	var	CTLOCID=session['LOGON.CTLOCID'];
	var HospID=""
	var ARCOSCode="";
	var ARCOSDesc=$("#Desc").val().replace(/(^\s*)|(\s*$)/g,'');
	if (ARCOSDesc==""){
		$.messager.alert('提示','医嘱套名称不能为空,请填写名称!'); 
		return;
	}
	var ARCOSAlias=$("#Alias").val().replace(/(^\s*)|(\s*$)/g,'');
	if (ARCOSAlias==""){
		$.messager.alert('提示','医嘱套别名不能为空,请填写别名!'); 
		return;
	}
	var Desc=ARCOSDesc;
	if (ARCOSDesc.indexOf("-")>=0){
		Desc=ARCOSDesc.split("-").slice(1).join("-");
	}
	var ARCOSCatID=$('#Category').combobox('getValue');
	if (ARCOSCatID==""){
		$.messager.alert('提示','请选择相应的医嘱套大类!'); 
		return;
	}
	var ARCOSSubCatID=$('#SubCategory').combobox('getValue');
	var index=$.hisui.indexOfArray($('#SubCategory').combobox("getData"),"CombValue",ARCOSSubCatID);
	if (index < 0) {
		$.messager.alert('提示','请选择有效的子类！'); 
		return false;
	}
	var CelerType=$('#CelerType').checkbox("getValue")?"Y":"N";
	var IsCMARCOS="N"; //是否为草药医嘱套
	if (CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")>=0) {
		IsCMARCOS="Y";
	}
	if((IsCMARCOS =="Y")&&(CelerType=="Y")){
		$.messager.alert('提示','草药医嘱套暂不支持快速录入！'); 
		return false;
	}
	if ((CMFlag=="Y")&&(IsCMARCOS=="N")) {
		$.messager.alert('提示','请选择草药相关的医嘱套子类!'); 
		return false;
	}
	if ((CMFlag=="N")&&(IsCMARCOS=="Y")) {
		$.messager.alert('提示','请选择西药相关的医嘱套子类!'); 
		return;
	}
	var FavDateTo=$("#FavDateTo").datebox('getValue');
	var AROSCNInfo="";
	if (IsCMARCOS =="Y") {
		var PrescTypeCode=$('#PrescTypeComb').combobox('getValue');
		var index=$.hisui.indexOfArray($('#PrescTypeComb').combobox("getData"),"id",PrescTypeCode);
		if ((PrescTypeCode!="")&&(index < 0)) {
			$.messager.alert('提示','请选择处方类型！'); 
			return false;
		}
		if (PrescTypeCode!=""){
			PrescTypeCode=PrescTypeCode.split("#")[0];
		}
		var DuratId=$('#DurationComb').combobox('getValue');
		var index=$.hisui.indexOfArray($('#DurationComb').combobox("getData"),"id",DuratId);
		if ((DuratId!="")&&(index < 0)) {
			$.messager.alert('提示','请选择有效的用药副数！'); 
			return false;
		}
		var FreqId=$('#FreqComb').combobox('getValue');
		var index=$.hisui.indexOfArray($('#FreqComb').combobox("getData"),"id",FreqId);
		if ((FreqId!="")&&(index < 0)) {
			$.messager.alert('提示','请选择有效的用药频次！'); 
			return false;
		}
		var InstrId=$('#InstrComb').combobox('getValue');
		var index=$.hisui.indexOfArray($('#InstrComb').combobox("getData"),"id",InstrId);
		if ((InstrId!="")&&(index < 0)) {
			$.messager.alert('提示','请选择有效的使用方式！'); 
			return false;
		}
		var DoseQtyId=$('#DoseQtyComb').combobox('getValue');
		var index=$.hisui.indexOfArray($('#DoseQtyComb').combobox("getData"),"Code",DoseQtyId);
		if ((DoseQtyId!="")&&(index < 0)) {
			$.messager.alert('提示','请选择有效的一次用量！'); 
			return false;
		}
		var Notes=$('#CNNote').val();
		AROSCNInfo=PrescTypeCode+"^"+DoseQtyId+"^"+DuratId+"^"+FreqId+"^"+InstrId+"^"+Notes;
	}
	AutoSetAlias(null,function(Spell){
		ARCOSAlias=Spell;
		var ARCOSEffDateFrom=NowDate;
		var FavDepList=CTLOCID;
		var DocMedUnit=""	
		//取组
		var DocMedUnit=tkMakeServerCall("web.DHCUserFavItems","GetMedUnit",UserID,CTLOCID);
		var FavDepList="";
		var InUser=UserID;
		//条件判断设置相关值
		if (Contions=="1"){
			FavDepList="";DocMedUnit="";
			//医嘱套的名字要加上Code
			if (ARCOSDesc.indexOf("-")<0){
				ARCOSDesc=UserCode+"-"+ARCOSDesc;
			}
		}else if (Contions=="2"){
			InUser="";FavDepList=CTLOCID;DocMedUnit=""
		}else if(Contions=="3"){
			InUser="";FavDepList="";DocMedUnit="";
			HospID=session['LOGON.HOSPID']
		}else if(Contions=="4"){
			FavDepList="";
			if (DocMedUnit==''){
				$.messager.alert('提示','您没有被加入到登陆科室有效的组内,不能进行该条件保存！');
				return;
			}
		}
		var Type="Hosp";
		if (Contions==1) Type="User";
		else if (Contions==2) Type="Loc";
		var FavRowid=$("#FavRowid").val();
		if (FavRowid) {
			var ARCOSCode=$("#Code").val().replace(/(^\s*)|(\s*$)/g,'');
			var Err=tkMakeServerCall("web.DHCUserFavItems","UpdateUserARCOS",FavRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffDateFrom,ARCOSAlias,FavDepList,DocMedUnit,InUser,HospID,CelerType,AROSCNInfo,FavDateTo)
			if (Err=='-1') {
				$.messager.alert('提示','更新失败');
				return;
			}else if (Err=='-2') {
				$.messager.alert('提示','您可能填写了已经使用的代码');
				return;
			}else if (Err=='-3') {
				$.messager.alert('提示','原医嘱套已维护处方剂型或已维护明细数据不能修改为非草药医嘱套!');
				return;
			}else if (Err=='-4') {
				$.messager.alert('提示','原医嘱套已维护明细数据不能修改为草药医嘱套!');
				return;
			}else{
				$.messager.popover({msg: '更新成功!',type:'success'});
				$("#FavRowid").val("");
				$("#ARCOSSetWin").window('close');
				$("#Alias").val(Spell);
				AppendTreeGridRowByFavRowId(FavRowid,Type,"U");
			}
		}else{
			//保存医嘱套
			var ret=tkMakeServerCall("web.DHCUserFavItems","InsertUserARCOS",InUser,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit,HospID,CelerType,session['LOGON.HOSPID'],AROSCNInfo,FavDateTo,Type)
			if (ret=='-1') {
				$.messager.alert('提示',"保存医嘱套失败您可能填写了已经使用的代码!");
				return;
			}else{
				var FavRowid=ret.split(String.fromCharCode(1))[0];
				var ARCOSRowidGet=ret.split(String.fromCharCode(1))[1];
				var ARCOSCode=ret.split(String.fromCharCode(1))[2];
				FavRowid=FavRowid.replace(/(^\s*)|(\s*$)/g,'')
				if (FavRowid==""){
				$.messager.alert('提示'," 您可能填写了已经使用的代码");
				return;
				}
			}
			$.messager.popover({msg: '保存成功！',type:'success'});
			$("#Alias").val(Spell);
			$("#ARCOSSetWin").window('close');
			AppendTreeGridRowByFavRowId(FavRowid,Type,"A");
			CloseWindow(ARCOSRowidGet,ARCOSSubCatID,ARCOSDesc);
		}
	});
}
function AutoSetAlias(e,callBackFun) {
	var Desc=$("#Desc").val();
	if (Desc==""){
		if(callBackFun) callBackFun("");
		return true;
	}
	if (Desc.indexOf("-")>=0){
		Desc=Desc.split("-").slice(1).join("-");
	}
	var Spell=tkMakeServerCall("ext.util.String","ToChineseSpell",Desc);
	var Alias=$("#Alias").val();
	if ((Alias!="")&&(Alias!=Spell)){
		$.messager.confirm('提示',$g("是否将别名替换为")+Spell+"?",function(r){
			if(r){
				$("#Alias").val(Spell);
				if(callBackFun) callBackFun(Spell);
			}else{
				if(callBackFun) callBackFun(Alias);
			}
		});
	}else{
		$("#Alias").val(Spell);
		if(callBackFun) callBackFun(Spell);
	}
}
function CombListCreat(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		LoadOrderDept("List_OrderDept");
	}
	//初始化条件
	ConditionesCombCreat()
	//大类Comb
	CategoryCombCreat()
}
function ConditionesCombCreat(){
	$("#SearchConditiones,#Conditiones").combobox({
		valueField: 'CombValue',
		textField: 'CombDesc', 
		editable:true,
		filter: function(q, row){
			return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},
		onSelect:function(record){
			if ($(this)[0].id =="SearchConditiones") {
				$('#ARCOrdSetsTreeGrid').treegrid('reload');
			}
		},
		onBeforeLoad:function(param){
			param.ClassName="web.UDHCFavItemNew";
			param.QueryName="CombListFind";
			param.CombName="Conditiones";
		}
	});
}
//初始化大类
function CategoryCombCreat(){
	$("#SearchCategory,#Category").combobox({
		valueField: 'CombValue',
		textField: 'CombDesc', 
		editable:true,
		filter: function(q, row){
			return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},
		onBeforeLoad:function(param){
			param.ClassName="web.UDHCFavItemNew";
			param.QueryName="CombListFind";
			param.CombName="Category";
		},
		onLoadSuccess:function(data){
			for (var i=0;i<data.length;i++){
				if (data[i]['CombDesc'].indexOf($g("医嘱套"))>=0){
					$('#SearchCategory,#Category').combobox('select',data[i]['CombValue']);
					break;
				}
			}
		   //大类加载完毕之后
		   SubCategoryCombCreat();
		}
	});
}
//初始化子类
function SubCategoryCombCreat(){
	$("#SearchSubCategory,#SubCategory").combobox({
		valueField: 'CombValue',
		textField: 'CombDesc', 
		editable:true,
		filter: function(q, row){
			return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},
		onSelect:function(record){
			if ($(this)[0].id =="SubCategory") {
				ClearARCOSCNData();
				if ((record)&&(CNMedItemCatStr.indexOf("^"+record.CombValue+"^")>=0)){
					$(".CNARCOSInfo").show();
					if (PageLogicObj.m_CNPrescTypeArr==""){
						InitCMCombo();
						InitPrescNotes();
					}
					//只加载子类能选择的处方类型
					var newCNPrescTypeArr=new Array;
					for(var i=0;i<PageLogicObj.m_CNPrescTypeArr.length;i++){
						var CatStr=PageLogicObj.m_CNPrescTypeArr[i].id.split("#")[5];
						if(("^"+CatStr+"^").indexOf("^"+record.CombValue+"^")>-1){
							newCNPrescTypeArr[newCNPrescTypeArr.length]=PageLogicObj.m_CNPrescTypeArr[i];
						}
					}
					$("#PrescTypeComb").combobox('loadData',newCNPrescTypeArr);
					$("#CelerType").checkbox('disable').checkbox('uncheck');
					//$HUI.checkbox('#CelerType').disable();
				}else{
					$(".CNARCOSInfo").hide();
					$HUI.checkbox('#CelerType').enable();
				}
			}
		},
		onBeforeLoad:function(param){
			param.ClassName="web.UDHCFavItemNew";
			param.QueryName="CombListFind";
			param.CombName="SubCategory";
			param.Inpute1=$('#Category').combobox('getValue');
		},
		onLoadSuccess:function(){
			InitARCOrdSetsTreeGrid();
		}
	});
}
function SetARCOSDataFromRow(){
	ClearARCOSData();
	if (PageLogicObj.m_rightMenuRowObj.ARCOSRowid) {
		var ARCOSOrdCatDR=PageLogicObj.m_rightMenuRowObj.ARCOSOrdCatDR;
		var ARCOSOrdSubCatDR=PageLogicObj.m_rightMenuRowObj.ARCOSOrdSubCatDR;
		var ARCOSCode=PageLogicObj.m_rightMenuRowObj.ARCOSCode;
		var ARCOSDesc=PageLogicObj.m_rightMenuRowObj.ARCOSDesc;
		var CelerType=PageLogicObj.m_rightMenuRowObj.CelerType;
		var ARCOSAlias=PageLogicObj.m_rightMenuRowObj.ARCOSAlias;
		var FavUserDr=PageLogicObj.m_rightMenuRowObj.FavUserDr;		
		var FavDepDr=PageLogicObj.m_rightMenuRowObj.FavDepDr;
		var FavDateTo=PageLogicObj.m_rightMenuRowObj.FavDateTo;
		if (FavUserDr!="") {
			$('#Conditiones').combobox('setValue',1);
		}else if(FavDepDr!="") {
			$('#Conditiones').combobox('setValue',2);
		}else{
			$('#Conditiones').combobox('setValue',3);
		}
		$("#FavRowid").val(PageLogicObj.m_rightMenuRowObj.FavRowid);
		$("#Code").val(ARCOSCode);
		$("#Desc").val(ARCOSDesc);
		$("#Alias").val(ARCOSAlias);
		$('#SubCategory').combobox('setValue',ARCOSOrdSubCatDR);
		$('#Category').combobox('setValue',ARCOSOrdCatDR);
		$("#FavDateTo").datebox("setValue",FavDateTo);
		if ((ARCOSOrdSubCatDR!="")&&(CNMedItemCatStr.indexOf("^"+ARCOSOrdSubCatDR+"^")>-1)){
			$HUI.checkbox('#CelerType').disable();
			$(".CNARCOSInfo").show();
		}else{
			$HUI.checkbox('#CelerType').enable();
		}
		if (CelerType=="Y"){
			$("#CelerType").checkbox('check');
		}else{
			$("#CelerType").checkbox('uncheck');
		}
		
		InitOSCNInfo();
	}else{
		var Type=PageLogicObj.m_rightMenuRowObj.Type;
		if (Type =="User") {
			$('#Conditiones').combobox('setValue',1);
		}else if(FavDepDr =="Loc") {
			$('#Conditiones').combobox('setValue',2);
		}else{
			$('#Conditiones').combobox('setValue',3);
		}
	}
}
function ClearARCOSData(){
	$(".CNARCOSInfo").hide();
	$("#Code,#Desc,#Alias").val("");
	$('#SubCategory,#Conditiones').combobox('setValue',"");
	$('#CelerType').checkbox('enable').checkbox('uncheck');
	$("#FavDateTo").datebox('setValue',"");
	ClearARCOSCNData();
}
function ClearARCOSCNData(){
	$("#CNNote").val("");
	$("#PrescTypeComb,#InstrComb,#DurationComb,#FreqComb,#DoseQtyComb").combobox('setValue',"");
}
function InitOSCNInfo(){
	var PrescTypeCode=PageLogicObj.m_rightMenuRowObj.PrescTypeCode;
    var DurRowid=PageLogicObj.m_rightMenuRowObj.DuratId;
    var FreqRowid=PageLogicObj.m_rightMenuRowObj.FreqId;
    var QtyID=PageLogicObj.m_rightMenuRowObj.DosageId;
    var InstrRowid=PageLogicObj.m_rightMenuRowObj.InstrId;
    var Notes=PageLogicObj.m_rightMenuRowObj.Notes;
	if (PageLogicObj.m_CNPrescTypeArr==""){
		InitCMCombo();
	}
	//只加载子类能选择的处方类型
	var newCNPrescTypeArr=new Array;
    for(var i=0;i<PageLogicObj.m_CNPrescTypeArr.length;i++){
        var CatStr=PageLogicObj.m_CNPrescTypeArr[i].id.split("#")[5];
        if(("^"+CatStr+"^").indexOf("^"+PageLogicObj.m_rightMenuRowObj.ARCOSOrdSubCatDR+"^")>-1){
	    	newCNPrescTypeArr[newCNPrescTypeArr.length]=PageLogicObj.m_CNPrescTypeArr[i];
	    }
    }
    $("#PrescTypeComb").combobox('loadData',newCNPrescTypeArr);
    var PrescTypeCodeId="";
    if(PrescTypeCode!=""){
	    for(var i=0;i<newCNPrescTypeArr.length;i++){
		    if(newCNPrescTypeArr[i].id.split("#")[0]==PrescTypeCode){
			    PrescTypeCodeId=newCNPrescTypeArr[i].id;
			}
		}
	}
    if((DurRowid!="")||(FreqRowid!="")||(InstrRowid!="")||(QtyID!="")){
	    $("#PrescTypeComb").combobox('setValue',PrescTypeCodeId);
    	SetCMInfo(DurRowid,FreqRowid,InstrRowid,QtyID)
    }else{
	     $("#PrescTypeComb").combobox('select',PrescTypeCodeId);
	}
	InitPrescNotes();
    $('#CNNote').val(Notes);
}
function InitCMCombo(){
    InitSingleCombo('DoseQtyComb','Code','Desc','DHCDoc.DHCDocConfig.CMDocConfig','FindInstrLinkOrderQty')
    if (PageLogicObj.m_CNFreqArr==""){
	    PageLogicObj.m_CNFreqArr=$.cm({
			ClassName:"DHCDoc.DHCDocConfig.OrdSets",
			MethodName:"WriteQueryJson",
			className:"web.DHCDocOrderEntryCM", queryName:"LookUpFrequence", IdCol:5, TextCol:1, CodeCol:2
		},false);
	    InitLocalCombo('FreqComb',PageLogicObj.m_CNFreqArr);
	    PageLogicObj.m_CNDurationArr=$.cm({
			ClassName:"DHCDoc.DHCDocConfig.OrdSets",
			MethodName:"WriteQueryJson",
			className:"web.DHCDocOrderEntryCM", queryName:"LookUpDuration", IdCol:1, TextCol:2, CodeCol:4
		},false);
	    InitLocalCombo('DurationComb',PageLogicObj.m_CNDurationArr);
	    PageLogicObj.m_CNInstrArr=$.cm({
			ClassName:"DHCDoc.DHCDocConfig.OrdSets",
			MethodName:"WriteQueryJson",
			className:"web.DHCDocOrderEntryCM", queryName:"LookUpInstr", IdCol:1, TextCol:2, CodeCol:3
		},false);
	    InitLocalCombo('InstrComb',PageLogicObj.m_CNInstrArr);
	    InitLocalCombo('PrescTypeComb',[]);
	    PageLogicObj.m_CNPrescTypeArr=$.cm({
			ClassName:"DHCDoc.DHCDocConfig.OrdSets",
			MethodName:"WriteCNPrescType"
		},false);
    }
}
function InitSingleCombo(id,valueField,textField,ClassName,QueryName)
{
	var ComboObj={
		editable:false,
		multiple:false,
		selectOnNavigation:true,
	  	valueField:valueField,   
	  	textField:textField,
	  	url:$URL+'?ClassName='+ClassName+'&QueryName='+QueryName
	};
	if(id=='DoseQtyComb'){
	    $.extend(ComboObj,{ 
	    	editable:false, 
		    panelHeight:'auto',
            onBeforeLoad:function(param){
	            var InstrucRowId=$('#InstrComb').combobox('getValue');
	            param = $.extend(param,{InstrucRowId:InstrucRowId});
            },
            loadFilter:function(data){
	            return data['rows'];
	        }
        });
	}
	$("#"+id).combobox(ComboObj);
}
function InitLocalCombo(id,data){
    var ComboObj={
		url:'',
		editable:false,
		multiple:false,
		selectOnNavigation:true,
	  	valueField:'id',   
        textField:'text',
        data:data,
        filter: function(q, row){
			var opts = $(this).combobox('options');
			return ("-"+row[opts.textField]).toUpperCase().indexOf("-"+q.toUpperCase()) >-1;
		}
    };
    if(id=='PrescTypeComb'){
	    $.extend(ComboObj,{
		    onSelect:function(){
			    PrescTypeChange();
			}
		})
	}else if(id=='InstrComb'){
		$.extend(ComboObj,{
		    onSelect:function(){
			    $('#DoseQtyComb').combobox('select',"")
			    $('#DoseQtyComb').combobox('reload');
			    SetCMDoseQty($('#DoseQtyComb').combobox('getValue'));
			}
		})
	}
    $("#"+id).combobox(ComboObj);
}
function PrescTypeChange(){
	//选择处方类型后初始化用法用量等信息
	 var PrescTypeInfo=$("#PrescTypeComb").combobox('getValue');
	 var CNInfoArr="",FreqRowid="",InstrRowid="",DurRowid="",DefaultQtyID=""
	 if(PrescTypeInfo!=''){
		 CNInfoArr=PrescTypeInfo.split("#");
		 FreqRowid=CNInfoArr[1].split("!")[0];
		 InstrRowid=CNInfoArr[2].split("!")[0];
		 DurRowid=CNInfoArr[3].split("!")[0];
		 DefaultQtyID=CNInfoArr[4].split("!")[0];
		 $('#DoseQtyComb').combobox('select',"");
	 }
	 SetCMInfo(DurRowid,FreqRowid,InstrRowid,DefaultQtyID);
}
function SetCMInfo(DurRowid,FreqRowid,InstrRowid,QtyID){
	$('#DurationComb').combobox('select',DurRowid);
	$('#FreqComb').combobox('select',FreqRowid);
	$('#InstrComb').combobox('select',InstrRowid);
	setTimeout(function(){SetCMDoseQty(QtyID);},1000);
}
function SetCMDoseQty(QtyID){
	$('#DoseQtyComb').combobox('setValue','');
	var DoseQtyArr=$('#DoseQtyComb').combobox('getData');
	for(var i=0;i<DoseQtyArr.length;i++){
		if(DoseQtyArr[i].Code==QtyID){
			$('#DoseQtyComb').combobox('setValue',QtyID);
			break;
		}
	}
}
function InitPrescNotes(){
	$("#CNNote").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Code',
        textField:'Desc',
        columns:[[  
			{field:'Desc',title:'名称',width:350,sortable:true},
			{field:'Code',hidden:true}
        ]],
        pagination:true,
        panelWidth:500,
        panelHeight:370,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.PilotProject.DHCDocPilotProject',QueryName: 'FindDefineData',MDesc:"医嘱录入字典",DDesc:"草药录入备注"},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
			param = $.extend(param,{Alias:desc});
	    },onSelect:function(ind,item){
		    $("#CNNote").val(item.Desc);
		}
    });
}
function InitFavSaveMenu()
{
	var CONTEXT='WNewOrderEntry';
	var ARCOSOrdSubCatDR=PageLogicObj.m_rightMenuRowObj.ARCOSOrdSubCatDR;
	if(CNMedItemCatStr.indexOf("^"+ARCOSOrdSubCatDR+"^")>-1){
		CONTEXT='W50007'
	}
	$('div[name="menucopy"]').each(function(){
		$('#right').menu('removeSubMenu',this);
		var target=this;
		var key=$(target).attr('key');
		$.cm({ 
			ClassName:"DHCDoc.Order.Fav",
			MethodName:"GetFavData", 
			Type:key,
			CONTEXT:CONTEXT, 
			LocID:session['LOGON.CTLOCID'],
			UserID:session['LOGON.USERID'],
			OnlyCatNode:1
		},function(data){
			$.each(data,function(index, value){
				if (value .children.length==0){
					$('#right').menu('appendItem', {
						parent:target,
						text:value.text,
						iconCls:'icon-star-empty',
						onclick:function(){
							$.messager.alert('提示','不能保存到'+value.text);
						}
					});
				}else{
					$('#right').menu('appendItem', {
						parent:target,
						text:value.text,
						iconCls:'icon-star-empty'
					});
				}
				var submenu=$('#right').menu('getSubMenu',target);
				var subTarget=submenu.children("div.menu-item:last")[0];
				$.each(value.children,function(index, value){
					$('#right').menu('appendItem', {
						parent:subTarget,
						text:value.text,
						iconCls:'icon-paper-save',
						onclick:function(){
							var CheckedOSRowids=GetCheckedOSRowids();
							if(!CheckedOSRowids) return;
							if(!CheckedOSRowids.length){
								$.messager.popover({msg: '请勾选需保存的医嘱套',type:'alert'});
								return;
							}
							var itemArr=new Array();
							for(var i=0;i<CheckedOSRowids.length;i++){
								itemArr.push({'itemid':CheckedOSRowids[i]});
							}
							var ret=$.cm({ 
								ClassName:"DHCDoc.Order.Fav",
								MethodName:"InsertMultItem", 
								FavItemStr:JSON.stringify(itemArr),
								SubCatID:value.id,
								UserID:session['LOGON.USERID'],
								dataType:'text'
							},false);
							if(ret=='0'){
								$.messager.popover({msg:"保存成功",type:'success'});
							}else{
								$.messager.alert('提示','保存失败:'+ret);
							}
						}
					});
				});
			});
		});	
	});
}
function GetCheckedOSRowids()
{
	var ARCOSRowidArr=new Array();
	var CheckedNodes=$('#ARCOrdSetsTreeGrid').treegrid('getCheckedNodes');
	for(var i=0;i<CheckedNodes.length;i++){
		var FavRowid=CheckedNodes[i].FavRowid;
		if(!FavRowid) continue;
		if(!UserAuthObj[CheckedNodes[i].Type]){
			$.messager.popover({msg: $g('没有操作[')+CheckedNodes[i].Name+$g(']权限!'),type:'error'});
			return null;
		}
		ARCOSRowidArr.push(CheckedNodes[i].ARCOSRowid);
	}
	return ARCOSRowidArr;
}
var PageLogicObj={
	m_ARCOSItemListTabDataGrid:"",
	m_loadedFlag:0
};
$(function(){
	//初始化
	Init();
	//表格数据初始化
	ARCOSItemListTabDataGridLoad();
	$(".datagrid-toolbar tbody tr").append("<td><span>"+$g("总价")+"</span><span id='Sum'></span><span>"+$g("元")+"</span></td>");
	document.onkeydown=Doc_OnKeyDown;
});
function Init(){
	PageLogicObj.m_ARCOSItemListTabDataGrid=InitARCOSItemListTabDataGrid();
}
function InitARCOSItemListTabDataGrid(){
	var toobar=[{
        text: '新增(F4)',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    }];
	var Columns=[[ 
		{field:'ItemRowid',checkbox:true,title:''},
		{field:'Item',title:'名称',width:250},
		{field:'ItemQty',title:'数量',width:50,
			//editor:{type : 'text'}
			formatter: function(value,row,index){
				if(row.LongPriorFlag=='1') return "";
				var CNMedItemFlag=row['CNMedItemFlag'];
				if (CNMedItemFlag==0) {
					return '<input class="datagrid-editable-input" id="ItemQty_'+index+'" value="'+value+'" style="padding:0 0 0 5px;width:43px;height:28px;">';
				}
				return value;
			}
		},
		{field:'ItemBillUOM',title:'单位',width:50},
		{field:'ItemDoseQty',title:'剂量',width:50, //showTip:true,tipWidth:200,
			//editor:{type : 'text'}
			formatter: function(value,row,index){
				var CNMedItemFlag=row['CNMedItemFlag'];
				if (CNMedItemFlag==1) {
					return '<input class="datagrid-editable-input" id="ItemDoseQty_'+index+'" value="'+value+'" style="padding:0 0 0 5px;width:43px;height:28px;">';
				}
				return value;
			}
		},
		{field:'ItemDoseUOM',title:'剂量单位',width:50},
		{field:'ItemFreq',title:'频次',width:100},
		{field:'ItemInstr',title:'用法',width:70},
		{field:'ItemDur',title:'疗程',width:50},
		{field:'ItemStatus',title:'项目状态',width:70},
		{field:'ItemSeqNo',title:'序号',width:40},
		{field:'DHCDocOrderType',title:'医嘱类型',width:70},
		{field:'ItemSpec',title:'标本',width:50},
		{field:'ItemRemark',title:'备注',width:70},
		{field:'OrderPriorRemarks',title:'附加说明',width:70},
		{field:'Sensitive',title:'加急',width:40,align:'center', //
			/*editor:{
				type:'icheckbox',options:{on:'3',off:'',disabled:true}
			}*/
			formatter: function(value,row,index){
				var checked=row['NotifyClinician']=="Y"?"checked":"";
				var Sensitive=row['Sensitive'];
				if (Sensitive=="Y") {
					return '<input id="Sensitive_'+index+'" type="checkbox" name="vehicle" value="Car" '+checked+'/>';
				}
				return value;
			}
		},
		{field:'NotifyClinician',hidden:true},
		{field:'ItemCatDR',hidden:true}
		
    ]]
	var ARCOSItemListTabDataGrid=$("#ARCOSItemListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		checkOnSelect:false,
		pagination : false,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'id',
		columns :Columns,
		toolbar:toobar,
		rowStyler: function(index,row){
			if ((row['ItemStatus']==$g("停用"))||(row['ItemStatus']==$g("无权限"))) {
				return "background:yellow;";
			}
			var ReclocDescStr=row['ReclocDescStr'];
			if((ReclocDescStr=="")&&(ServerObj.EpisodeID!="")){
				return "background:red;";
			}
		},
		onCheckAll:function(rows){
			SelectAll(rows);
		},
		onUncheckAll:function(rows){
			UnSelectAll(rows);
		},
		onCheck:function(index, row){
			if (PageLogicObj.m_loadedFlag=="1"){
				var OrderMustEnter=row['OrderMustEnter'];
				var SeqNo=row['ItemSeqNo'];
		    	var arry1=SeqNo.split(".");
		    	var SelectFun=$(this).datagrid('options').onCheck;
            	$(this).datagrid('options').onCheck=function(){};
		    	if ((arry1.length>=1)&&(+arry1[0]!=0)) {
			    	var MasterSeqNo=arry1[0];
			    	ChangelLinkItemSelect(MasterSeqNo,true,OrderMustEnter);
			    }
		   		GetSum();
		   		$(this).datagrid('options').onCheck=SelectFun;
		   	}
		},
		onUncheck:function(index, row){
			var OrderMustEnter=row['OrderMustEnter'];
			var SeqNo=row['ItemSeqNo'];
	    	var arry1=SeqNo.split(".");
	    	var SelectFun=$(this).datagrid('options').onUncheck;
            $(this).datagrid('options').onUncheck=function(){};
	    	if ((arry1.length>=1)&&(+arry1[0]!=0)) {
		    	var MasterSeqNo=arry1[0];
		    	ChangelLinkItemSelect(MasterSeqNo,false,OrderMustEnter);
		    }
		    if (PageLogicObj.m_loadedFlag=="1"){
		    	GetSum();
		    }
		    $(this).datagrid('options').onUncheck=SelectFun;
		},
		onBeforeSelect:function(index, row){
			var ItemStatus=row['ItemStatus'];
			if ((ItemStatus==$g("停用"))||(ItemStatus==$g("无权限"))) {
				return false;
			}
		},onBeforeUnselect:function(index, row){
			var OrderMustEnter=row['OrderMustEnter'];
			if (OrderMustEnter=="Y"){
				return false;
			}
			if ($("input[name='ItemRowid']")[index].disabled){
				return false;
			}
		},onLoadSuccess:function(data){
			if (data['rows'].length>=0){
				var _$ItemRowid=$("input[name='ItemRowid']");
				_$ItemRowid.prop("checked", true);
				for (var i=0;i<data['rows'].length;i++){
					var ItemQty=$.trim(data['rows'][i]['ItemQty']);
					if (parseInt(ItemQty)==0) {
						//$(_$ItemRowid[i]).prop("checked", false);
					}
					var ItemStatus=data['rows'][i]['ItemStatus'];
					if ((ItemStatus==$g("停用"))||(ItemStatus==$g("无权限"))) {
						$(_$ItemRowid[i]).attr('disabled','disabled');
						$(_$ItemRowid[i]).prop("checked", false);
					}
					var OrderMustEnter=data['rows'][i]['OrderMustEnter'];
					if(OrderMustEnter=="Y"){
						$(_$ItemRowid[i]).attr('disabled','disabled');
					}else if ((ItemStatus!=$g("停用"))&&(ItemStatus!=$g("无权限"))){
						var SeqNo=data['rows'][i]['ItemSeqNo'];
						var OrderMustEnter=data['rows'][i]['OrderMustEnter'];
						if ((+SeqNo!=0)&&(OrderMustEnter!="Y")){
							//成组医嘱,判断是否有必填标志
							if (CheckLinkMustEnter(data['rows'][i])) {
								$(_$ItemRowid[i]).attr('disabled','disabled');
							}
						}
					}
				}
				//设置焦点,否则在选中第一行后监听不到上下键事件
				if (data['rows'].length>=0) {
					var CNMedItemFlag=data['rows'][0]['CNMedItemFlag'];
					if (CNMedItemFlag=="1") {
						$("#ItemDoseQty_0").focus().select();
					}else{
						$("#ItemQty_0").focus().select();
					}
				}
			}
			if ($("input[name='ItemRowid']:checkbox:checked").length==data['rows'].length) {
				$(".datagrid-header-check input").prop("checked", true);
			}
			GetSum();
			SetLinkItemStyle();
			PageLogicObj.m_loadedFlag=1;
			var _$ItemDoseQty=$("input[id^='ItemDoseQty']");
			_$ItemDoseQty.keydown(ItemKeydown);
			_$ItemDoseQty.keypress(ItemKeypress);
			_$ItemDoseQty.change(ItemChange);
			var _$ItemQty=$("input[id^='ItemQty']");
			_$ItemQty.keydown(ItemKeydown);
			_$ItemQty.keypress(ItemKeypress);
			_$ItemQty.change(ItemChange);
		},onClickCell:function(index, field, value){
			return false;
		},onDblClickCell:function(index, field, value){
			//return false;
		}/*,onBeforeEdit:function(index, row){
			var CNMedItemFlag=row['CNMedItemFlag'];
			if (CNMedItemFlag=="1"){
				var editor1 = PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getColumnOption', "ItemQty");
                editor1.editor = {};
			}else{
				var editor1 = PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getColumnOption', "ItemDoseQty");
                editor1.editor = {};
			}
		},onBeginEdit:function(index, row){
			var ItemQtyObj = PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getEditor', { index: index, field: 'ItemQty' });
			if (ItemQtyObj){ 
				ItemQtyObj.target.change(function (e) {
					var qty=e.target.value;
					if (!isPositiveInteger(qty)){
						//e.target.value="";
					}
					GetSum();
				});
			}
			var ItemDoseQtyObj = PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getEditor', { index: index, field: 'ItemDoseQty' }); 
			if (ItemDoseQtyObj){ 
				ItemDoseQtyObj.target.change(function (e) {
					var qty=e.target.value;
					if (!isPositiveInteger(qty)){
						e.target.value="";
					}
					GetSum();
				})
			}
			if (row['Sensitive']=="Y"){
				var Editors = PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getEditors', index);
				Editors[1].target.checkbox('setDisable',false);
				if(row['NotifyClinician']=="Y") Editors[1].target.checkbox('setValue',true);
			}
		}*/
	});
	return ARCOSItemListTabDataGrid;
}
function CheckPackQty_Update(row){
	var RowData=PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getRows')
	var AllowEntryDecimalItemCatStr = "^" + ServerObj.AllowEntryDecimalItemCat + "^";
	var ItemCatDR=RowData[row]['ItemCatDR']
	if (AllowEntryDecimalItemCatStr.indexOf("^"+ItemCatDR+"^")<0) {
		return false;
	}
	return true;
}
function AddClickHandle(){
	var OrderPrior="";
	var OrderPriorRowid='';
 	var Copyary=new Array();
	var par_win = window.opener;
	var reg = new RegExp("~","g");//g,表示全部替换。
	var data=PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getRows');
	for (var i=0; i<data.length; i++) {
		if (!$($("input[name='ItemRowid']")[i]).is(":checked")) continue;
		var code=data[i]["ItemRowid"];
		var ItemData=data[i]["ItemData"];
		ItemData=ItemData.replace(reg,String.fromCharCode(1));
		var Type=data[i]["ItemOrderType"]; 
		var ItemQty=data[i]["ItemQty"]; 
		var ItemDoseQty=data[i]["ItemDoseQty"]; 
		var CNMedItemFlag=data[i]["CNMedItemFlag"]; 
		var id=data[i]["id"]; 
		var index=PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getRowIndex',id);
		var eds=PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getEditors',index);
		/*if (CNMedItemFlag=="1"){
			var ItemDoseQty=eds[0].target.val();
		}else{
			var ItemQty=eds[0].target.val();
		}*/
		if (CNMedItemFlag=="1"){
			var ItemDoseQty=$("#ItemDoseQty_"+i).val();
		}else{
			if($("#ItemQty_"+i).size()) ItemQty=$("#ItemQty_"+i).val();
		}
		if ((ItemQty.indexOf(".")>=0)&&(!CheckPackQty_Update(i))) {
			$.messager.alert("提示",data[i]["Item"]+$g("没有录入整数！"))
			return false;
		}
		if (data[i]["Sensitive"]=="Y") {
			var Urgent=$("#Sensitive_"+i).is(':checked')?"Y":"";
		}else{
			var Urgent="";
		}
		//var Urgent=eds[1].target.is(':checked')?"Y":""; 
	    var OrderSeqNo=data[i]["ItemSeqNo"];
		if (OrderSeqNo=="&nbsp;") OrderSeqNo="";
		var TempArr=new Array();
		TempArr=ItemData.split("^");
		var ITMRowId=TempArr[13];
		var TempItemArr=TempArr[4].split(String.fromCharCode(1));
		if (CNMedItemFlag=="1"){
			TempArr[0]=ItemDoseQty;
		}else{
			TempItemArr[0]=ItemQty;
		}
		TempArr[4]=TempItemArr.join(String.fromCharCode(1));
		var OrderPriorRemarksDR=data[i]["OrderPriorRemarksDR"];
		TempArr[10]=OrderPriorRemarksDR
		TempArr[12]=Urgent
		TempArr[13]=ITMRowId
		//28_1$0.1!28_2$0.2!28_3$0.3
		//同频次不同剂量串有!会影响后续取数据,统一替换为$c(2)
		var ITMOrderFreqTimeDoseStr=TempArr[22];
		TempArr[22]=ITMOrderFreqTimeDoseStr.replace(/!/g,String.fromCharCode(2));
		var ITMFreqWeekStr=TempArr[23];
		TempArr[23]=ITMFreqWeekStr.replace(/@/g,String.fromCharCode(2));
		ItemData=TempArr.join("^");
		Copyary[Copyary.length]=code+"!"+OrderSeqNo+"!"+ItemData+"!"+Type+"!"+"!"+""+"!"+"OSItem"+"!!"+ServerObj.ARCOSRowid;
	}
	/*if ((par_win)&&(Copyary.length!=0)){
		debugger;
		par_win.AddCopyItemToList(Copyary);
		window.close();
	}*/
	if (Copyary.length!=0){
		websys_showModal("hide");
		websys_showModal('options').AddCopyItemToList(Copyary);
		websys_showModal("close");
	}
}
function ARCOSItemListTabDataGridLoad(){
	$.q({
	    ClassName : "web.DHCDocOrderCommon",
	    QueryName : "FindOSItems",
	    ARCOSRowid:ServerObj.ARCOSRowid,
	    HospitalId:session['LOGON.HOSPID'],
	    EpisodeID:ServerObj.EpisodeID,
	    Pagerows:PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('loadData',GridData);
	}); 
}
function ChangelLinkItemSelect(MasterSeqNo,checkflag,OrderMustEnter){
    try{
		var data=PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getData');
		for (var k=0; k<data.rows.length; k++) {
			var SeqNo=data['rows'][k]['ItemSeqNo'];
			if (+SeqNo==0) continue;
			var arry=SeqNo.split(".");
			if (arry[0]==MasterSeqNo) {
				if (checkflag){
					if (!$($("input[name='ItemRowid']")[k]).is(":checked")){
					//if (!$($("input[type='checkbox']")[k+1]).is(":checked")){
						PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('checkRow',k);
					}
				}else{
					//if ($($("input[type='checkbox']")[k+1]).is(":checked")){
					if ($($("input[name='ItemRowid']")[k]).is(":checked")){
						PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('uncheckRow',k);
					}
				}
				if (OrderMustEnter=="Y"){
					//$("input[type='checkbox']")[k+1].disabled = true;
					$("input[name='ItemRowid']")[k].disabled = true;
				}
			}
		}
    }catch(e){alert(e.message)}
}
function GetSum(){
	var _$ItemRowid=$("input[name='ItemRowid']");
	var Sum=0;
	var data=PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getRows');
	for (var i=0; i<data.length; i++) {
		var ItemPriorRemarks=$.trim(data[i]['ItemPriorRemarks']);
		var CNMedItemFlag=$.trim(data[i]['CNMedItemFlag']);
		var checked=$(_$ItemRowid[i]).is(":checked");
		//var checked=$($("input[type='checkbox']")[i+1]).is(":checked");
		if((checked)&&(+ItemPriorRemarks=="0")){ 
			var OrderPriorRemarksDR= data[i]['OrderPriorRemarksDR'];
			if ((OrderPriorRemarksDR=="OM")||(OrderPriorRemarksDR=="ZT")){
				continue;
			}
			var ItemDoseQty=data[i]['ItemDoseQty'];
			var ItemQty=data[i]['ItemQty'];
			var ItemPrice=data[i]['ItemPrice'];
			var OrderConFac=data[i]['OrderConFac'];
			if (OrderConFac==""){
				OrderConFac=1	
			}
			var ItemFreqFactor=data[i]['ItemFreqFactor'];
			if(ItemFreqFactor==""){
				ItemFreqFactor=1	
			}
			var BaseDoseQty=data[i]['BaseDoseQty'];
			if(BaseDoseQty==""){
				BaseDoseQty=1
			}
			var DHCDocOrderType=$.trim(data[i]['DHCDocOrderType']);
			/*
			var eds=PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getEditors',i);
			if (CNMedItemFlag=="1"){
				var ItemDoseQty=eds[0].target.val();
			}else{
				var ItemQty=eds[0].target.val();
			}*/
			if (CNMedItemFlag=="1"){
				var ItemDoseQty=$("#ItemDoseQty_"+i).val();
			}else{
				var ItemQty=$("#ItemQty_"+i).val();
			}
			if ((DHCDocOrderType=="临时医嘱")||(DHCDocOrderType=="出院带药")||((+DHCDocOrderType==0)&&(ServerObj.nowOrderPrior=="0"))){
				//if (+ItemQty==0) ItemQty=1;
				if (+ItemDoseQty==0) ItemDoseQty=1;
				if (CNMedItemFlag=="1"){
					var OrderSum=parseFloat(ItemPrice)*parseFloat(ItemDoseQty)
				}else{
					if (+ItemQty==0) {
						var OrderSum=parseFloat(ItemPrice)/OrderConFac*parseFloat(BaseDoseQty)
					}else{
						var OrderSum=parseFloat(ItemPrice)*parseFloat(ItemQty)
					}
					
				}
			}else{
				if (CNMedItemFlag=="1"){
					var OrderSum=parseFloat(ItemPrice)/OrderConFac*ItemFreqFactor*ItemDoseQty
				}else{
					if (+ItemQty==0) {
						var OrderSum=parseFloat(ItemPrice)/OrderConFac*parseFloat(BaseDoseQty)
					}else{
						var OrderSum=parseFloat(ItemPrice)/OrderConFac*ItemFreqFactor*BaseDoseQty
					}
				}
				
			}
			if(OrderSum==""){continue}		
			Sum=parseFloat(Sum)+parseFloat(OrderSum);
		}
	}
	Sum=Sum.toFixed(4);
	$("#Sum").html(Sum);
}
function UnSelectAll(rows){
	for (var i=0;i<rows.length;i++){
		var SeqNo=rows[i]['ItemSeqNo'];
		var OrderMustEnter=rows[i]['OrderMustEnter'];
		if ((+SeqNo!=0)&&(OrderMustEnter!="Y")){
			//成组医嘱,判断是否有必填标志
			if (CheckLinkMustEnter(rows[i])) OrderMustEnter="Y";
			var ItemStatus=rows['ItemStatus'];
			if ((ItemStatus==$g("停用"))||(ItemStatus==$g("无权限"))) {
				OrderMustEnter="N";
			}
		}
		if(OrderMustEnter=="Y"){
			PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('checkRow',i);
		}else{
		    PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('uncheckRow',i);
	    }
	}
	GetSum();
}
function CheckLinkMustEnter(RowData){
	var SeqNo=RowData['ItemSeqNo'];
	if (SeqNo.indexOf(".")) MasterSeqNo=SeqNo.split(".")[0];
	else  MasterSeqNo=SeqNo;
	var Row=PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getRowIndex');
	var data=PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getRows');
	for (var m=0; m<data.length; m++) {
		if (m!=Row){
			var tmpSeqNo=data[m]['ItemSeqNo'];
			if (tmpSeqNo.indexOf(".")) tmpMasterSeqNo=tmpSeqNo.split(".")[0];
			else  tmpMasterSeqNo=tmpSeqNo;
			if (tmpMasterSeqNo==MasterSeqNo){
				var tmpOrderMustEnter=data[m]['OrderMustEnter'];
				if (tmpOrderMustEnter=="Y") {
					return true;
					break;
				}
			}
		}
	}
	return false;
}
function SelectAll(rows){
	for (var i=0; i<rows.length; i++) {
		if (!$("input[name='ItemRowid']")[i].disabled){
		//if (!$("input[type='checkbox']")[i+1].disabled) {
			PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('selectRow',i);
		}else{
			if ((rows[i]['ItemStatus']==$g("停用"))||(rows[i]['ItemStatus']==$g("无权限"))) {
				PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('unselectRow',i);
				debugger;
				$($("input[name='ItemRowid']")[i]).prop("checked", false);
			}
		}
	}
	GetSum();
}
function SetLinkItemStyle(){
	var rows=PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getRows');
	for (var i=0; i<rows.length; i++) {
	    var SeqNo=rows[i]['ItemSeqNo'];
		if ((SeqNo=="") || (SeqNo.indexOf(".")>-1)) continue;
        for (var j=0; j<rows.length; j++) {
	         var SeqNo1=rows[j]['ItemSeqNo'];
		     if (SeqNo1.indexOf(".")==-1) continue;
		     var arry=SeqNo1.split(".");
		     if (arry[0]==SeqNo){
			    $("#datagrid-row-r1-2-"+i).addClass("OrderMasterM");
			    $("#datagrid-row-r1-2-"+j).addClass("OrderMasterS");
			 }
	    }
	}
}
//是否为正整数
function isPositiveInteger(s){
   var re = /^[0-9]+$/ ;
   return re.test(s)
} 
function Doc_OnKeyDown(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if(keycode==115){
		AddClickHandle();
	}
}
function GridBindEnterEvent(index){
	var eds = PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getEditors',index);
	if (index==0) {
		$(eds[0].target).focus().select();	
	}
	eds[0].target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var input = $(e.target).val();
			if (input == ""){return;}
			var rows=PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getRows');
			for (var i=parseInt(index)+1;i<rows.length;i++){
				var Nexteditors = PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getEditors', i);
				var NextOrderPriceEditor= Nexteditors[0];
				NextOrderPriceEditor.target.focus().select();  ///设置焦点并选中
				break;
			}
		}
	});
	eds[0].target.bind("keypress",function(e){
		try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
		if ((keycode == 8) || (keycode == 9) || (keycode == 46) || (keycode == 13) || ((keycode > 47) && (keycode < 58)) || ((keycode > 95) && (keycode < 106))) {
			if (keycode == 46) {
				var ret=CheckPackQty_Update(index);
				if(!ret){
					return websys_cancel();
				}
			}
		}else{
			return websys_cancel();
		}
	})
}
function ItemKeydown(e){
	if((e.keyCode==13)||(e.keyCode==38)||(e.keyCode==40)){
		var id=e.target.id;
		var indArr=id.split("_");
		var ItemId=indArr[0];
		var index=parseInt(indArr[1]);
		var input = $("#"+id).val();
		//if (input == ""){return;}
		var NewIndex=(e.keyCode==38)?(index-1):(index+1)
		var $nextItem=$("#"+ItemId+"_"+NewIndex);
		if ($nextItem.length>0) {
			setTimeout(function(){
				PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('unselectAll').datagrid('selectRow',NewIndex);
				$nextItem.focus().select();
			},50)
		}else{
			//不用回到第一行
			//$("#"+ItemId+"_0").focus().select();
		}
	}
}
function ItemKeypress(e){
	try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
	if ((keycode == 8) || (keycode == 9) || (keycode == 46) || (keycode == 13) || ((keycode > 47) && (keycode < 58)) || ((keycode > 95) && (keycode < 106))) {
		if (keycode == 46) {
			var id=e.target.id;
			var index=id.split("_")[1];
			var ret=CheckPackQty_Update(index);
			if(!ret){
				return websys_cancel();
			}
		}
	}else{
		return websys_cancel();
	}
}
function ItemChange(e){
	var id=e.target.id;
	var indArr=id.split("_");
	var ItemId=indArr[0];
	var qty=e.target.value;
	if (ItemId=="ItemDoseQty") {
		if ((qty!="")&&(!isPositiveInteger(qty))&&(!CheckPackQty_Update(indArr[1]))){
			var data=PageLogicObj.m_ARCOSItemListTabDataGrid.datagrid('getRows');
			$.messager.alert("提示",data[indArr[1]]["Item"]+"没有录入整数！","info",function(){
				e.target.value="";
				$(e.target).focus();
				GetSum();
			})
			return false;
		}
	}
	GetSum();
}

var showFormatData = [
	{code:'@',desc:'文本'},
	{code:'0.00',desc:'数字(两位小数0.00)'},
	{code:'0.00%',desc:'两位小数百分数(0.00%)'},
	{code:'000000',desc:'6位整数(000000)'},
	{code:'[DBNum2]',desc:'数字中文大写'},
	{code:'yyyy-m-d',desc:'日期(yyyy-mm-dd)'},
	{code:'yyyy年m月d日',desc:'日期(yyyy年m月dj日)'}
];
var horAlignData = [
	{code:"1",desc:"常规方式"},
	{code:"2",desc:"左对齐"},
	{code:"3",desc:"居中"},
	{code:"4",desc:"右对齐"},
	{code:"5",desc:"填充方式"},
]
function SetSaveAs(type){
	saveAsTypeCode = type;
	var desc = localCode[type]["desc"];
	$("#saveastype").text(desc);
}
function endEdit(){
	var editInd = "";
	if ($.fn.datagrid.methods['getEditingIndex']){
		editInd = $("#columnsTbl").datagrid('getEditingIndex');
	}
	if (editInd){
		editInd = parseInt(editInd);
		if ($("#columnsTbl").datagrid('validateRow',editInd)){
			$("#columnsTbl").datagrid('endEdit',editInd);
			return true;
		}
		return false;
	}else{
		return true;
	}
}
function mysort(index, type, gridname) {
	if ("up" == type) {
		if (index != 0) {
			var toup = $('#' + gridname).datagrid('getData').rows[index];
			var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
			$('#' + gridname).datagrid('getData').rows[index] = todown;
			$('#' + gridname).datagrid('getData').rows[index - 1] = toup;
			$('#' + gridname).datagrid('refreshRow', index);
			$('#' + gridname).datagrid('refreshRow', index - 1);
			$('#' + gridname).datagrid('selectRow', index - 1);
		}
	} else if ("down" == type) {
		var rows = $('#' + gridname).datagrid('getRows').length;
		if (index != rows - 1) {
			var todown = $('#' + gridname).datagrid('getData').rows[index];
			var toup = $('#' + gridname).datagrid('getData').rows[index + 1];
			$('#' + gridname).datagrid('getData').rows[index + 1] = todown;
			$('#' + gridname).datagrid('getData').rows[index] = toup;
			$('#' + gridname).datagrid('refreshRow', index);
			$('#' + gridname).datagrid('refreshRow', index + 1);
			$('#' + gridname).datagrid('selectRow', index + 1);
		}
	}
}
var karr = ["headerCfg","footerCfg","sortColCb","sortColOrderCb","showLineCb","LandscapeOrientationCb"
	,"leftMargin","rightMargin","topMargin","bottomMargin","ShrinkToFit","sortColCb2","sortColOrderCb2","PrintTitleRows","StopRunInNotRecord"];
	
var varr = ["headerCfg","footerCfg","sortColCfg","sortOrdCfg","showLineCfg","LandscapeOrientation"
	,"lm","rm","tm","bm","ShrinkToFit","sortColCfg2","sortOrdCfg2","PrintTitleRows","StopRunInNotRecord"];
var initPageCfg = function(){
	for(var i=0; i<karr.length; i++){
		setValueById(karr[i],window[varr[i]]);
	}
}
$(function(){
	$("#saveBtn").click(function(){
		if(!endEdit()){ return false; }
		if (!saveAsTypeCode){
			$.messager.alert("提示","不能保存成[安全级]权限");
			return ;
		}
		var c2 = String.fromCharCode(2);
		var c4 = String.fromCharCode(4);
		var c5 = String.fromCharCode(5);
		var rows = $("#columnsTbl").datagrid("getRows");
		var dataArr = [];
		for (var i=0; i<rows.length ;i++){
			var itemArr = [];
			for (var j=0;j<cmapArr.length;j++) {
				itemArr.push(rows[i][cmapArr[j]]);
			}
			dataArr.push(itemArr.join(c2));
		}
		var otherCfgArr = [];
		for(var i=0; i<karr.length; i++){
			otherCfgArr.push(getValueById(karr[i]));
		}
		// objectType , objectReference , appKey , appSubKey , Data
		// ,context:context
		// ("MYAPP","SETTINGS","SSGroup","SuperUser",mydata)
		var saveAsTypeDesc = $("#saveastype").text();
		
		$.messager.confirm("提示", "确定保存成"+saveAsTypeDesc+"?", function (r) {
			if (r) {
				$cm({
					ClassName:"websys.Preferences",
					MethodName:"SetData",
					objectType:localCode[saveAsTypeCode]["objectType"],
					objectReference:localCode[saveAsTypeCode]["objectReference"],
					appKey:"PRTCOLUMNS"+context,
					appSubKey:pageName,
					Data:dataArr.join(c4)+c5+(otherCfgArr.join(c5)), //+headerCfgVal+c5+footerCfgVal+c5+sortColVal+c5+sortColOrdVal+c5+showLineVal+c5+LandscapeOrientationVal+c5+tmplm+c5+tmprm+c5+tmptm+c5+tmpbm+c5+ShrinkToFitVal+c5+sortColVal2+c5+sortColOrdVal2+c5+PrintTitleRows,
					add:1,
					dataType:'text'
				},function(rtn){
					if(rtn!=1){
						$.messager.alert("提示","保存错误。"+rtn);
					}else{
						$("#columnsTbl").datagrid('acceptChanges');
						$("#columnsTbl").datagrid('getPanel').find('td').removeClass('datagrid-value-changed');
						$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					}
				});
			}
		});
		
	});
	$("#delBtn").click(function(){
		if(!endEdit()){ return false; }
		if (!saveAsTypeCode){
			$.messager.alert("提示","不能保存成[安全级]权限");
			return ;
		}
		var saveAsTypeDesc = $("#saveastype").text();
		$.messager.confirm("提示", "确定删除"+saveAsTypeDesc+"?", function (r) {
			if (r) {
				$cm({
					ClassName:"websys.Preferences",
					MethodName:"KillData",
					objectType:localCode[saveAsTypeCode]["objectType"],
					objectReference:localCode[saveAsTypeCode]["objectReference"],
					appKey:"PRTCOLUMNS"+context,
					appSubKey:pageName,
					dataType:'text'
				},function(rtn){
					open("../csp/websys.query.customisecolumn.csp?CONTEXT="+context+"&PREFID="+prefid+"&PAGENAME="+pageName,"_self");
				});
			}
		});
		
	});

	$("#columnsTbl").datagrid({
		columns:[[
			{field:"code",title:"列头代码",width:120},
			{field:"name",title:"列头名称",width:120,editor:{type:'text'}},
			{field:"showFormat",title:"格式",width:160,formatter:function(val,row){
				var obj = $.hisui.getArrayItem(showFormatData,'code',val);
				if (obj) return obj.desc;
				return "";
				},editor:{
					type:'combobox',
					options:{
						editable:false,
						valueField:'code',
						textField:'desc',
						data:showFormatData
					}
				}
			},
			{field:"colWidth",title:"列宽(1=2.2733mm)",width:100,editor:{type:"text"},formatter:function(val,row){
				return val==""?"":val;
				}},
			{field:"colFontSize",title:"列字体大小",width:50,formatter:function(val,row){
				return val==""?"默认":val;
				},editor:{type:"text"}}, //{type:"checkbox",options:{on:'1',off:'0'}}
			{field:"horAlign",title:"水平对齐",width:60,formatter:function(val,row){
				var obj = $.hisui.getArrayItem(horAlignData,'code',val);
				if (obj) return $.hisui.getArrayItem(horAlignData,'code',val).desc;
				return "";
				},editor:{
					type:'combobox',
					options:{
						editable:false,
						valueField:'code',
						textField:'desc',
						panelHeight:'auto',
						data:horAlignData
					}
				}
			}
		]],
		idField:'id',
		headerCls:"panel-header-gray",
		data:queryJson,
		rownumbers:true,
		border:false,
		singleSelect:true,
		title:"",
		autoSizeColumn:false,
		fitColumns:true,
		fit:true,
		clicksToEdit:1,
		rowStyler:function(index,row){
			if(row.isHidden==1){
				//background-color:#fff;
				return 'color:#bbbbbb;'
			}
		},
		onLoadSuccess:function(data){
			//$.parser.parse(); //,{iconCls:"icon-w-config"});
			//$.parser.parse('#cc');
		},
		toolbar:[
		{
			iconCls:'icon-up',text:"上移",handler:function(){
				var ind = $("#columnsTbl").datagrid('getRowIndex',$("#columnsTbl").datagrid('getSelected'));
				mysort(ind,'up',"columnsTbl");
				//
			}
		},{
			iconCls:'icon-down',text:"下移",handler:function(){
				var ind = $("#columnsTbl").datagrid('getRowIndex',$("#columnsTbl").datagrid('getSelected'));
				mysort(ind,'down',"columnsTbl");
			}
		},{
			iconCls:'icon-eye',text:"隐藏/显示",handler:function(){
				var index = $("#columnsTbl").datagrid('getRowIndex',$("#columnsTbl").datagrid('getSelected'));
				var myrow = $('#columnsTbl').datagrid('getData').rows[index];
				if (myrow.isHidden==0){
					 myrow.isHidden= 1;
				}else{
					myrow.isHidden= 0;
				}
				$("#columnsTbl").datagrid('refreshRow', index);
				$("#columnsTbl").datagrid('unselectRow', index);
			}	
		}
		]
	});
	$("#sortColCb").combobox({
		valueField: 'code',
		textField: 'name',
		//value:20,data:[{id:20,text:"中国"}], //当前框中默认选中【中国】，如果默认空时可以去掉这行
		data:queryJson,
		onShowPanel:function(){
			$("#sortColCb").combobox("loadData",queryJson);
		}
	});
	$("#sortColCb2").combobox({
		valueField: 'code',
		textField: 'name',
		//value:20,data:[{id:20,text:"中国"}], //当前框中默认选中【中国】，如果默认空时可以去掉这行
		data:queryJson,
		onShowPanel:function(){
			$("#sortColCb2").combobox("loadData",queryJson);
		}
	});
	initPageCfg();
});
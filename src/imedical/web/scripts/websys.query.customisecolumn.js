var showFormatData = [
	{code:'@',desc:'�ı�'},
	{code:'0.00',desc:'����(��λС��0.00)'},
	{code:'0.00%',desc:'��λС���ٷ���(0.00%)'},
	{code:'000000',desc:'6λ����(000000)'},
	{code:'[DBNum2]',desc:'�������Ĵ�д'},
	{code:'yyyy-m-d',desc:'����(yyyy-mm-dd)'},
	{code:'yyyy��m��d��',desc:'����(yyyy��m��dj��)'}
];
var horAlignData = [
	{code:"1",desc:"���淽ʽ"},
	{code:"2",desc:"�����"},
	{code:"3",desc:"����"},
	{code:"4",desc:"�Ҷ���"},
	{code:"5",desc:"��䷽ʽ"},
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
			$.messager.alert("��ʾ","���ܱ����[��ȫ��]Ȩ��");
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
		
		$.messager.confirm("��ʾ", "ȷ�������"+saveAsTypeDesc+"?", function (r) {
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
						$.messager.alert("��ʾ","�������"+rtn);
					}else{
						$("#columnsTbl").datagrid('acceptChanges');
						$("#columnsTbl").datagrid('getPanel').find('td').removeClass('datagrid-value-changed');
						$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
					}
				});
			}
		});
		
	});
	$("#delBtn").click(function(){
		if(!endEdit()){ return false; }
		if (!saveAsTypeCode){
			$.messager.alert("��ʾ","���ܱ����[��ȫ��]Ȩ��");
			return ;
		}
		var saveAsTypeDesc = $("#saveastype").text();
		$.messager.confirm("��ʾ", "ȷ��ɾ��"+saveAsTypeDesc+"?", function (r) {
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
			{field:"code",title:"��ͷ����",width:120},
			{field:"name",title:"��ͷ����",width:120,editor:{type:'text'}},
			{field:"showFormat",title:"��ʽ",width:160,formatter:function(val,row){
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
			{field:"colWidth",title:"�п�(1=2.2733mm)",width:100,editor:{type:"text"},formatter:function(val,row){
				return val==""?"":val;
				}},
			{field:"colFontSize",title:"�������С",width:50,formatter:function(val,row){
				return val==""?"Ĭ��":val;
				},editor:{type:"text"}}, //{type:"checkbox",options:{on:'1',off:'0'}}
			{field:"horAlign",title:"ˮƽ����",width:60,formatter:function(val,row){
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
			iconCls:'icon-up',text:"����",handler:function(){
				var ind = $("#columnsTbl").datagrid('getRowIndex',$("#columnsTbl").datagrid('getSelected'));
				mysort(ind,'up',"columnsTbl");
				//
			}
		},{
			iconCls:'icon-down',text:"����",handler:function(){
				var ind = $("#columnsTbl").datagrid('getRowIndex',$("#columnsTbl").datagrid('getSelected'));
				mysort(ind,'down',"columnsTbl");
			}
		},{
			iconCls:'icon-eye',text:"����/��ʾ",handler:function(){
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
		//value:20,data:[{id:20,text:"�й�"}], //��ǰ����Ĭ��ѡ�С��й��������Ĭ�Ͽ�ʱ����ȥ������
		data:queryJson,
		onShowPanel:function(){
			$("#sortColCb").combobox("loadData",queryJson);
		}
	});
	$("#sortColCb2").combobox({
		valueField: 'code',
		textField: 'name',
		//value:20,data:[{id:20,text:"�й�"}], //��ǰ����Ĭ��ѡ�С��й��������Ĭ�Ͽ�ʱ����ȥ������
		data:queryJson,
		onShowPanel:function(){
			$("#sortColCb2").combobox("loadData",queryJson);
		}
	});
	initPageCfg();
});
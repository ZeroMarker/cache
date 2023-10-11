/** 
 * FileName: dhcbill.conf.general.seturl.js
 * Creator: WangXQ
 * Date: 2023-01-13
 * Description: 通用配置配置url弹窗
*/

var GVV={
    wdg:"",
    maxRowsLimit:"2",
    cntDicEditor:{ 
		type: 'combobox', 
		options: {
			defaultFilter: 4,
			valueField: 'code',
			textField: 'text',
			url:$URL,
			mode:'local',
			blurValidValue: true,
			onBeforeLoad:function(param){
				param.ClassName = 'BILL.CFG.COM.GeneralCfg';
				param.QueryName = 'QryDicDataByType';
				param.dicType = 'SYS';
				param.ResultSetType = 'array';
				return true;
							
			},
			onSelect: function(){
				var SelectRow=$('#wdg').datagrid("getSelected");
				var index=INSUMIGetEditRowIndexByID('wdg');	
				if(SelectRow.cnt!=""){
					$("#wdg").datagrid("endEdit",rowindex);
				}else{
					$("#wdg").datagrid("beginEdit",rowindex);
				}				
			}	
		}
	}
}

$(function () {
    setPageLayout();
    setElementEvent();
});
function setPageLayout(){

    //url类型
    $("#urlStyle").combogrid({
        panelWidth: 470,
        panelHeight: 300,
        striped: true,
        method: 'GET',
        pagination: true,
        fitColumns: false,
        editable: false,
        url: $URL + "?ClassName=BILL.CFG.COM.GeneralCfg&QueryName=QryDicDataByType&dicType=" + "URL",
        idField: 'value',
        textField: 'value',
        columns: [[{field: 'value', title: 'URL', width: 300},
                   {field: 'text', title: '描述', width: 150}
            ]],
    });
    init_wdg();
    analysisurl();
}
function setElementEvent(){
    //配置URL-新增
    $HUI.linkbutton("#url-add", {
        onClick: function () {
            wdg_addRow();
        }
    });
    //配置URL-保存
    /*$HUI.linkbutton("#url-save", {
        onClick: function () {
            endEditRow();
        }
    });*/
    //配置URL-修改
   /* $HUI.linkbutton("#url-write", {
        onClick: function () {
            editRow();
        }
    });*/
    //配置URL-删除
    $HUI.linkbutton("#url-del", {
        onClick: function () {
            wdg_delRow();
        }
    });
	//配置URL-删除
    $HUI.linkbutton("#btnSave", {
        onClick: function () {
            btnSave();
        }
    });
	//配置URL-删除
    $HUI.linkbutton("#btnCancel", {
        onClick: function () {
            btnCancel();
        }
    });
}



function init_wdg() { 
	GVV.wdg=$HUI.datagrid("#wdg", {
		//iconCls:'icon-apply-check',
		border:false,
		striped:true,
		singleSelect: true,
		fit:true,
		toolbar:'#wdgTB',
		columns: [[   
		{field:'cnt',title:'列名',width:200,editor:{
				type: 'text'
			}},
		{field:'cntPrcunt',title:'属性',width:200,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'code',
					textField: 'text',
					url:$URL,
					mode:'remote',
					editable:false,
					onBeforeLoad:function(param){
				      	param.ClassName = 'BILL.CFG.COM.GeneralCfg';
				      	param.QueryName = 'QryDicDataByType';
				      	param.dicType = 'CPDataViewType';
				      	param.ResultSetType = 'array';
				      	return true;
					},
					onSelect: function(){
					 changeproduct(this);
					}
				}
			}
			},
			{field:'cntDic',title:'字典',width:200,editor:{
				type: 'text',
			
			}
			},
		]],
		onDblClickRow: function(index, row){
		
			$('#wdg').datagrid('beginEdit', index);		
            var editor = $('#wdg').datagrid('getEditors', index);
			var va= $(editor[1].target).combobox('getValue');
			if(va!="combobox"){				
				var cellEdit = $('#wdg').datagrid('getEditor', {index:index,field:'cntDic'});
				var $input = cellEdit.target;
				$input.prop('readonly',true);
				$input.val("");	
						   
			}else{//第三列combobox赋值触发
				var aeditor=GVV.cntDicEditor;
				$("#wdg").datagrid("endEdit",index)
				$("#wdg").datagrid("addEditor",[{field:'cntDic',editor:aeditor,index:index}])
				$('#wdg').datagrid('beginEdit', index);
			}
			
		},
	}); 
}
//------------------------------------------------
		function getRowIndex(target) {
            var tr = $(target).closest('tr.datagrid-row');
            return parseInt(tr.attr('datagrid-row-index'));
        }
        function changeproduct(r){  
			
            var rowindex = getRowIndex(r);			
            var editor = $('#wdg').datagrid('getEditors', rowindex);
	    var va= $(editor[1].target).combobox('getValue');						
	    var cntDicTextEditor={type:'text'};
			if(va=="combobox"){				
				var aeditor=GVV.cntDicEditor;
				$("#wdg").datagrid("endEdit",rowindex)
				$("#wdg").datagrid("removeEditor","cntDic")
				$("#wdg").datagrid("addEditor",[{field:'cntDic',editor:aeditor}])
				$("#wdg").datagrid("beginEdit",rowindex);	
				// 得到单元格对象,index指哪一行,field跟定义列的那个一样
				var cellEdit = $('#wdg').datagrid('getEditor', {index:rowindex,field:'cntDic'});
				var $input = cellEdit.target; // 得到文本框对象	
				$input.prop('readonly',false); // 设值只读	
					   
			}else{				
				var aeditor=cntDicTextEditor;
				$("#wdg").datagrid("endEdit",rowindex)
				$("#wdg").datagrid("removeEditor","cntDic")
				$("#wdg").datagrid("addEditor",[{field:'cntDic',editor:aeditor}])
				$("#wdg").datagrid("beginEdit",rowindex);
				// 得到单元格对象,index指哪一行,field跟定义列的那个一样
				var cellEdit = $('#wdg').datagrid('getEditor', {index:rowindex,field:'cntDic'});
				var $input = cellEdit.target; // 得到文本框对象	
				$input.prop('readonly',true); // 设值只读
				$input.val("");				
			}
	};
		$.extend($.fn.datagrid.methods, {
			/*表格编辑器*/
			editCell: function(jq,param){
				return jq.each(function(){
					var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
					for(var i=0; i<fields.length; i++){
						var col = $(this).datagrid('getColumnOption', fields[i]);
						col.editor1 = col.editor;
						if (fields[i] != param.field){
							col.editor = null;
						}
					}
					$(this).datagrid('beginEdit', param.index);
					for(var i=0; i<fields.length; i++){
						var col = $(this).datagrid('getColumnOption', fields[i]);
						col.editor = col.editor1;
					}
				});
			},
			/*添加编辑器*/
			addEditor : function(jq, param) {
				if (param instanceof Array) {
					$.each(param, function(index, item) {
						var e = $(jq).datagrid('getColumnOption', item.field);
						e.editor = item.editor; });
				} else {
					var e = $(jq).datagrid('getColumnOption', param.field);
					e.editor = param.editor;
				}
			},
			/*移除编辑器*/
			removeEditor : function(jq, param) {
				if (param instanceof Array) {
					$.each(param, function(index, item) {
						var e = $(jq).datagrid('getColumnOption', item);
						e.editor = {};
					});
				} else {
					var e = $(jq).datagrid('getColumnOption', param);
					e.editor = {};
				}
			}
		});
//------------------------------------------------
// 新增
function wdg_addRow(){
	var urlStyle=$("#urlStyle").combobox('getValue')
	if (urlStyle==""){
		$.messager.alert("提示", "请选择URL类型", 'info');
		return;
	}
	var SelectIndex = INSUMIGetEditRowIndexByID('wdg');
	
	
	if(SelectIndex > -1 ){
       //$('#wdg').datagrid('endEdit', SelectIndex);
	 //  endEditRow();		
	}
	if(closeEdit() ){
		var rows = $('#wdg').datagrid('getRows');
		var lastRows = rows.length;
		if (lastRows>GVV.maxRowsLimit){
			$.messager.alert("提示", "列表最大行数不能超过三行", 'info');
			return;
		}
	
		$('#wdg').datagrid('appendRow',{
			numberbox: '',
			cntPrcunt: '',
			hilistCode: '',
			hilistName: '',
			listType: '',
			cnt:'',
			cntDic:''
			
		});		
	
		$('#wdg').datagrid('beginEdit', lastRows);
		$('#wdg').datagrid('scrollTo',lastRows);
		$('#wdg').datagrid('selectRow',lastRows);
	
	}else{
		return false;
	}
 
}

 // 获取datagrid正在编辑的行号
 function INSUMIGetEditRowIndexByID(gridId){
	var tr = $('#' + gridId).siblings().find('.datagrid-editable').parent().parent();//
	var SelectIndex = tr.attr('datagrid-row-index') || -1; 
	return SelectIndex
}
//保存(结束行编辑)
function endEditRow()
{
	var editRowIndex=INSUMIGetEditRowIndexByID('wdg')
	$('#wdg').datagrid('endEdit',editRowIndex);
}
//关掉编辑方法
//返回成功与否
//方法包含：1.先判断是否有正在编辑的列，如果没有，返回true;如果有，关掉编辑前的判断，只判断当前编辑的行。列明、属性、字典是否符合规矩
function closeEdit(){
	
	var SelectRow=$('#wdg').datagrid("getSelected");
	var index=INSUMIGetEditRowIndexByID('wdg'); 
	console.log(typeof index);		 
	if(index!="-1" && index!=-1 ){//有正在编辑的行
		if(SelectRow && (SelectRow.cnt!="" || SelectRow.cntPrcunt!="" || SelectRow.cntDic!="")){
				
				
			var cnt=SelectRow.cnt;
			var cntPrcunt=SelectRow.cntPrcunt;
			var cntDic=SelectRow.cntDic;
			var ed = $('#wdg').datagrid("getEditor", {
						index: index,
						field: "cnt"
					}); // 获取编辑器
			if (ed) {
				$('#wdg').datagrid("endEdit", index);
				SelectRow=$('#wdg').datagrid("getSelected");
				cnt=SelectRow.cnt;	
			}
			
			if(cnt==undefined){
				cnt="";
			}
			if(cntPrcunt==undefined){
				cntPrcunt="";
			}
			if(cntDic==undefined){
				cntDic="";
			}	
			if(cnt=="" || cntPrcunt=="" || ((cntPrcunt=="combobox")&&(cntDic==""))){
				$.messager.alert("提示","列名、属性、字典不能都为空,请输入数据后再添加");
				return false;				
			}else{
				
				$('#wdg').datagrid('endEdit',index);
				return true;
			}
		}else{
			$.messager.alert("提示","列名、属性、字典不能都为空,请输入数据后再添加");
				return false;	
		}		
	}else{	
			return true;	
	}
	
}

///编辑行信息
function editRow()
{
	var SelectRow=$('#wdg').datagrid("getSelected");
	var index=INSUMIGetEditRowIndexByID('wdg')
	if(index!="-1"){
		$.messager.alert("提示","有未保存的行数据，请先保存!");
		return
	}
	if(SelectRow==null){
		$.messager.alert("提示","未选中需要编辑的行");
		return
	}
	var index=$("#wdg").datagrid("getRowIndex",SelectRow);

	$('#wdg').datagrid('beginEdit', index);
	
}
//删除行
function wdg_delRow() {
	var SelectRow=$('#wdg').datagrid("getSelected");
	if(SelectRow==null){
		$.messager.alert("温馨提示","请选择要删除的数据!", 'info');
		return ;	
	}
	var index=$("#wdg").datagrid("getRowIndex",SelectRow);
	$.messager.confirm('提示','是否继续删除该数据?',function(r){
	if(r){
			 $('#wdg').datagrid('deleteRow', index);	
		}
	})
}

function analysisurl() {
	var url=CV.url;
    	if (url!=""){
        var arry=url.split("|");
        setValueById('urlStyle',arry[0]);			
        for(var i=1;i<=arry[1];i++){
		var SelectIndex = INSUMIGetEditRowIndexByID('wdg');	
	
		if(SelectIndex > -1 ){
      		//$('#wdg').datagrid('endEdit', SelectIndex);
	    	endEditRow(); 	
		}
        var rows = $('#wdg').datagrid('getRows');
		var lastRows = rows.length;

		$('#wdg').datagrid('appendRow',{
				numberbox: '',
				cntPrcunt: '',
				hilistCode: '',
				hilistName: '',
				listType: '',
				cnt:'',
				cntDic:''
			
		});			
			$('#wdg').datagrid('beginEdit', lastRows);
			$('#wdg').datagrid('scrollTo',lastRows);
			$('#wdg').datagrid('selectRow',lastRows);
		
            var index=INSUMIGetEditRowIndexByID('wdg');
			var arrayDataNew=arry[i+1].split(":");
			
            var obj1 = GVV.wdg.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field=cnt] input");
            if (obj1) {
                $(obj1).val(arrayDataNew[0]);
            }
			
            var obj2 = GVV.wdg.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field=cntPrcunt] input");
            if (obj2) {
                $(obj2).val(arrayDataNew[1]);
            }
		
			 var obj3 = GVV.wdg.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field=cntDic] input");
            if (obj3) {
                $(obj3).val(arrayDataNew[2]);
            }
		
        }
        endEditRow();
    }
}
function btnSave() {
	endEditRow();
	var urlStyle=$("#urlStyle").combobox('getValue')
	
	if (urlStyle==""){
		$.messager.alert("提示", "请选择URL类型", 'info');
		return;
	}
	var row=$('#wdg').datagrid('getRows');
	var url=""
	if (row!=""){
		for(var i=row.length - 1;i>=0;i--){
			var cnt=row[i].cnt;
			var cntPrcunt=row[i].cntPrcunt;
			var cntDic=row[i].cntDic;
			if(cnt==undefined){
				cnt="";
			}
			if(cntPrcunt==undefined){
				cntPrcunt="";
			}
			if(cntDic==undefined){
				cntDic="";
			}
			if(cnt=="" || cntPrcunt=="" ){		
				$('#wdg').datagrid('deleteRow', i);
				 continue;	
			}		
		}	
	}
	//删除空白行后重新拼接url
	var rowsNew=$('#wdg').datagrid('getRows');
	if (rowsNew!=""){
		for(var j=0;j<rowsNew.length;j++){
			
			if(url==""){
				url=urlStyle+"|"+rowsNew.length+"|"+rowsNew[j].cnt+":"+rowsNew[j].cntPrcunt+":"+rowsNew[j].cntDic
			}else{
				url=url+"|"+rowsNew[j].cnt+":"+rowsNew[j].cntPrcunt+":"+rowsNew[j].cntDic
			}	
		}
	}
	if(url==""){
		var url=urlStyle
	}
	
	websys_showModal('options').CallBackFunc(url,true);
	return ;
}
function btnCancel() {
	websys_showModal('options').CallBackFunc("",false);
}

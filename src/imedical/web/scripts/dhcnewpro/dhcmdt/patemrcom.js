/**EasyUI组件开发公用JS**/
var editIndex = undefined;

$.extend($.fn.datagrid.defaults.editors, {

    combogrid: {
         init: function(container, options){
            var input = $('<input class="combogrid-editable-input" />').appendTo(container); 
             input.combogrid(options);
             return input;
         },
         destroy: function(target){
             $(target).combogrid('destroy');
         },
         getValue: function(target){
            return $(target).combogrid('getValue');
         },
        setValue: function(target, value){
            $(target).combogrid('setValue', value);
         },
         resize: function(target, width){
             $(target).combogrid('resize',width);
         }
     }

 });
 
///单选下拉框
function InitSingleCombo(id,width,panelWidth,value,text,type,className,methodName,parr,selectfn,changefn,loadfn)
{
	$("#"+id+"").combobox({ 
		width:width,
		panelWidth:panelWidth,
    	valueField:'id',   
    	textField:'desc',
    	url:'',
    	onBeforeLoad:function(param){
			param.ClassName = className;
			param.MethodName = methodName;
			param.Type = type;
		},
		onSelect:function() {
			if (selectfn) selectfn();
		},
		onChange:function()
		{
			if (changefn) changefn();
		},
		onLoadSuccess:function(){
			if (loadfn) loadfn();
        }
	});
	ReloadSingleCombo(id,parr)
}

///重新加载下拉框数据
function ReloadSingleCombo(id,parr)
{
	$('#'+id).combobox('setValue',"");
	var url=DHCNUR.URL.QUERY_COMBO_URL+"?Arg="+parr
	$('#'+id).combobox('reload',url);
}

///加载数据列表
function InitDataGrid(id,column,topbar,single,loadfn,clickfn,dbclickfn,page,rowno,cellckfn,check,uncheck,allselect,unallselect)
{
	if (page==undefined) page=true;
	if (rowno==undefined) rowno=true;
	if (check==undefined) check=null;
	if (uncheck==undefined) uncheck=null;
	if (allselect==undefined) allselect=null;
	if (unallselect==undefined) unallselect=null;
	
	$('#'+id).datagrid({  
		fit : true,
		width : 'auto',
		height: 'auto',
		border : false,
		striped : true,
		singleSelect : single,
		fitColumns : false,      //为true时 不显示横向滚动条
		autoRowHeight : false,
		url : '',
		loadMsg : '加载中..',  
		pagination : page,       //是否分页
		rownumbers : rowno,       //
		idField : "rowId",
		pageList : [15,30,50,100,200],
		columns : column,
		toolbar : topbar,
		onClickCell:function(index,field){
			if (cellckfn) cellckfn(id,index,field);
		},
		onClickRow:function(rowIndex, rowData){
			if (clickfn) clickfn(rowIndex, rowData); 
		},
		onCheck:function(rowIndex,rowData){
			if (check) check(id,rowIndex,rowData); 	
		},
		onUncheck:function(rowIndex,rowData){
			if (uncheck) uncheck(id,rowIndex,rowData); 	
		},
		onCheckAll:function(rowIndex){
			if (allselect) allselect(id,rowIndex); 	
		},
		onUncheckAll:function(rowIndex){
			if (unallselect) unallselect(id,rowIndex); 	
		},
		
		rowStyler: function(index,row){
			if (((row.rowId=="")||(row.rowId==undefined))&&(row.flag!="1"))
			{ 
				return 'visibility:hidden'; 
			} 
			if ((row.color!="")&&(row.color!=undefined))
			{ 
				return 'background-color:'+row.color; 
			} 
			
		},
		onLoadSuccess:function(data){ 
			//无数据也要有横向滚动条(插入一条空记录并将它隐藏)
		    if (data.total == 0) {
		        $('#'+id).datagrid('insertRow', {
		            row : {}
		        });
			}
		   	$(this).datagrid('loaded');
		   	
		   	if (loadfn) loadfn(data); 
        },
		onDblClickRow:function(rowIndex, rowData){
			if (dbclickfn) dbclickfn(rowIndex, rowData);
		}
	});
}

function GetTableTrID(id)
{
    var p = $('#'+id).prev().find('div table:eq(1)');
    var ID = $(p).find('tbody tr:first').attr('id');
    if (ID != undefined && ID != '' && ID.length > 3) {
        ID = ID.toString().substr(0, ID.toString().length - 1);
    }
    return ID;
}

function endEditing(id){
	if (editIndex == undefined){return true}
	if ($('#'+id).datagrid('validateRow', editIndex)){
		$('#'+id).datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
		
function onClickCell(id, index, field){
	if (endEditing(id)){
		$('#'+id).datagrid('selectRow', index);
		$('#'+id).datagrid('editCell', {index:index,field:field});
		var editor = $('#'+id).datagrid('getEditor', {index:index,field:field});
      	editor.target.focus();
		editIndex = index;
	}
}

$.extend($.fn.datagrid.methods, {
	editCell: function(jq,param){
		return jq.each(function(){
			var opts = $(this).datagrid('options');
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
	}
});
	
$.fn.extend({
	insertContent : function(myValue, t) {
		var $t = $(this)[0];
		if (document.selection) { 
			//ie
			this.focus();
			var sel = document.selection.createRange();
			sel.text = myValue;
			this.focus();
			sel.moveStart('character', -l);
			var wee = sel.text.length;
			if (arguments.length == 2) {
				var l = $t.value.length;
				sel.moveEnd("character", wee + t);
				t <= 0 ? sel.moveStart("character", wee - 2 * t - myValue.length) : sel.moveStart( "character", wee - t - myValue.length);
				sel.select();
			}
		} 
		else if ($t.selectionStart|| $t.selectionStart == '0') {
			var startPos = $t.selectionStart;
			var endPos = $t.selectionEnd;
			var scrollTop = $t.scrollTop;
			$t.value = $t.value.substring(0, startPos) + myValue + $t.value.substring(endPos,$t.value.length);
			this.focus();
			$t.selectionStart = startPos + myValue.length;
			$t.selectionEnd = startPos + myValue.length;
			$t.scrollTop = scrollTop;
			if (arguments.length == 2) {
				$t.setSelectionRange(startPos - t,$t.selectionEnd + t);
				this.focus();
			}
		}
		else {
			this.value += myValue;
			this.focus();
		}
	}
})


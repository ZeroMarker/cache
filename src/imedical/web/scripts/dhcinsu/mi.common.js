/**
 * 根据入参获取对应grid的对象
 * @method loadDataGridStore
 * @param {String} gridIndex 表格序号 gridIndex 0:pat,1:,2:tar,3:ord
 * @param {type} 要获取指定表格的哪个对象/值【tr,td,field,td-div,tdHead,td】
 * @author tangzf
 */
 // INSUMIDataGrid.setValueToEditor
var INSUMIDataGrid={ 
	setGridVal:function(gridId,index,field,val){
		var gridViewArr = $('#' + gridId).siblings();
		var GridView2 = '';
		for (var gridIndex = 0; gridIndex < gridViewArr.length - 1; gridIndex++) {
			var GridClass = $(gridViewArr[gridIndex]).attr('class');
			if(GridClass.indexOf('view2') > 0){
				GridView2 = gridViewArr[gridIndex];		
			}
		}
	    var td = $(GridView2).find('.datagrid-body td[field="' + field + '"]')[index];
		var grid = $('#' + gridId);
        if (index === undefined || index === '') {
            index = 0;
        }
        var row = grid.datagrid('getRows')[index];
        if (row != null) {
            var editor = grid.datagrid('getEditor', {
                    index: index,
                    field: field
                });
            if (editor != null) {
                this.setValueToEditor(gridId, index,field,val);
            } else {
		        tmpdiv = $(td).find('div')[0];
		        if(tmpdiv){
			    	tmpdiv.innertText = val;
			    }
				$(tmpdiv).text(val);
            }
        }
	},
	//设置datagrid的编辑器的值 可以使用setGridVal 进行赋值
    setValueToEditor: function (dg,index,field, value) {
	    var editor = $('#' + dg).datagrid('getEditor', {
      		index: index,
      		field: field
		});
        switch (editor.type) {
        case 'combobox':
            editor.target.combobox('setValue', value);
            break;
        case 'combotree':
            editor.target.combotree('setValue', value);
            break;
        case 'textbox':
            editor.target.textbox('setValue', value);
            break;
        case 'numberbox':
            editor.target.numberbox("setValue", value);
            break;
        case 'datebox':
            editor.target.datebox("setValue", value);
            break;
        case 'datetimebox':
            editor.target.datebox("setValue", value);
            break;
        case 'switchbox':
            editor.target.switchbox("setValue", value);
            break;
        default:
            editor.html = value;
            editor.target[0].value = value; 
            break;
        }
    },
    // 获取编辑框的值
    getCellVal: function (dg,index,field) {
		var rtn = '';
		var editor = $('#' + dg).datagrid('getEditor', {
      		index: index,
      		field: field
		});
		if(editor){ // 编辑器的值
	        switch (editor.type) {
	        case 'combobox':
	            rtn = editor.target.combobox('getValue');
	            break;
	        case 'combotree':
	            rtn = editor.target.combotree('getValue');
	            break;
	        case 'textbox':
	            rtn = editor.target.textbox('getValue');
	            break;
	        case 'numberbox':
	            rtn = editor.target.numberbox("getValue");
	            break;
	        case 'datebox':
	            rtn = editor.target.datebox("getValue");
	            break;
	        case 'datetimebox':
	            rtn = editor.target.datebox("getValue");
	            break;
	        case 'switchbox':
	            rtn = editor.target.switchbox("getValue");
	            break;
	        case 'combogrid':
	            rtn = editor.target.combobox('getValue');
	            break;
	        default:
	            rtn = editor.target[0].value ; 
	            break;
	        }
		}else{ // 非编辑器的
			var rows = $('#' + dg).datagrid('getRows');
			rtn = rows[index][field];
			var gridViewArr = $('#' + dg).siblings();
			var GridView2 = '';
			for (var gridIndex = 0; gridIndex < gridViewArr.length - 1; gridIndex++) {
				var GridClass = $(gridViewArr[gridIndex]).attr('class');
				if(GridClass.indexOf('view2') > 0){
					GridView2 = gridViewArr[gridIndex];		
				}
			}
		    var view = GridView2;
			// 
			var Field = $(view).find('.datagrid-body td[field="' + field + '"]')[index];
			var divObj = $(Field).find('div')[0];
			var jObj = $(divObj).children(":first");
			var result = '';
			if(!jObj || (jObj && jObj.length == 0)){
				result = divObj.innerText; 
			}
	        else if (jObj[0].tagName=="INPUT"){
				var objType=jObj.prop("type");
				var objClassInfo=jObj.prop("class");
				if (objType=="checkbox"){
					//result=jObj.is(':checked')
					result = jObj.checkbox("getValue");
				}else if (objType=="select-one"){
					result=jObj.combobox("getValue");
				}else if (objType=="text"){
					if (objClassInfo.indexOf("combogrid")>=0){
						result=jObj.combogrid("getText");
					}else if (objClassInfo.indexOf("datebox-f")>=0){
						result=jObj.datebox('getText')
					}else if (objClassInfo.indexOf("combobox")>=0){
						result=jObj.combobox("getValue");
					}else if(objClassInfo.indexOf("number")>=0){
						result=jObj.numberbox("getValue");
					}
				}
			}else if(jObj[0].tagName=="SELECT"){
				var objClassInfo=jObj.prop("class");
				if (objClassInfo.indexOf("combogrid")>=0){
					result=jObj.combogrid("getText");
				}else if (objClassInfo.indexOf("combobox")>=0){
					result=jObj.combobox("getValue");
				}
			}else if(jObj[0].tagName=="LABEL"){
				result = jObj.text();
				
			}else if(jObj[0].tagName=="A"){  //按钮修改显示值 2018-07-23 
				result = jObj.find(".l-btn-text").text();
			}else if(jObj[0].tagName=="TABLE"){  // editor
				var editInput = $(jObj).find('input');
				var objType=editInput.prop("type");
				var objClassInfo=editInput.prop("class");
				if (objType=="checkbox"){
					result = editInput.checkbox("getValue");
				}else if (objType=="select-one"){
					result=editInput.combobox("getValue");
				}else if (objType=="text"){
					if (objClassInfo.indexOf("combogrid")>=0){
						result = editInput.combogrid("getText");
					}else if (objClassInfo.indexOf("datebox-f")>=0){
						result = editInput.datebox('getText')
					}else if (objClassInfo.indexOf("combobox")>=0){
						result = editInput.combobox("getValue");
					}else if(objClassInfo.indexOf("number")>=0){
						result = editInput.numberbox("getValue");
					}else{
						result = editInput[0].value; 	
					}
				}
			}
	        rtn = result;	
		}
        return rtn;
    },
    // 表格对象
    getTableObj:function(grid,index,type){
		var gridViewArr = $('#' + gridId).siblings();
		var GridView2 = '';
		for (var gridIndex = 0; gridIndex < gridViewArr.length - 1; gridIndex++) {
			var GridClass = $(gridViewArr[gridIndex]).attr('class');
			if(GridClass.indexOf('view2') > 0){
				GridView2 = gridViewArr[gridIndex];		
			}
		}
    	var tr = $(view).find('.datagrid-body tr[datagrid-row-index=' + index + ']');
		switch (type){ // gridIndex 0:pat,1:,2:tar,3:ord
		    case "tr" :
				// 审核人
				rtn = tr;
		    	break;
		    case "tdHead" :  
		    	tr = $(view).find('.datagrid-header-row');  
	 			td = $(tr).find('td[field="' + field + '"]');
	 			rtn = td;
		    	break;
		    case "td" :  
	 			td = $(tr).find('td[field="' + field + '"]');
	 			rtn = td;
		    	break;
			default :
	    		break;
		}
	}
}
function INSUMIAlert(msg,type,tite,callback){
	type = type || 'info';
	tite = tite || '提示';
	$.messager.alert(tite , msg,type);
	/*$.messager.alert('提示', '保存成功：'  + rtn,'success',function(){
		callback;
	});	*/
}
function INSUMIPOP(msg,type){
	type = type || 'info';
	$.messager.popover({
		msg:msg,
		type:type	
	});
}
function INSUMIClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
}
function INSUMIFileOpenWindow(funOpt) {
    try {
        if (typeof funOpt != 'function') {
            $.messager.alert('提示', '导入失败 ','info');
            return;
        } else {
	        	var filePath=""
				var exec= '(function tst(){ var xlApp  = new ActiveXObject("Excel.Application");'
				           +'var fName=xlApp.GetOpenFilename("Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls");'
				           +'if (!fName){fName="";}'
				           +'xlApp.Quit();'
			               +'xlSheet=null;'
			               +'xlApp=null;'
				           +'return fName;}());'
				  CmdShell.notReturn = 0;
			      var rs=CmdShell.EvalJs(exec);
			      if(rs.msg == 'success'){
			        filePath = rs.rtn;
			        funOpt(filePath);
			      }else{
			         $.messager.alert('提示', '打开文件错误！'+rs.msg,'error');
			      }	
/*             if ($('#FileWindowDiv').length == 0) {
                $('#FileWindowDiv').empty();
                $FileWindowDiv = $("<a id='FileWindowDiv' class='FileWindow' style='display:none'>&nbsp;</a>");
                $("body").append($FileWindowDiv);
                $FileWindow = $("<input id='FileWindow' type='file' name='upload'/>");
                $("#FileWindowDiv").append($FileWindow);                          
            }
            $("#FileWindow").off('input');
            $("#FileWindow").on('input', function (e) {
                    var FilePath = $('#FileWindow').val();
                    funOpt(FilePath);
                });
            $('#FileWindow').val("");
            $('#FileWindow').select();
            $(".FileWindow input").click(); */
        }
    } catch (error) {
        $.messager.alert('提示','dhcinsu.common.js发生错误:INSUMIFileOpenWindow:' + error,'info');
    }
}
 // 获取datagrid正在编辑的行号
function INSUMIGetEditRowIndexByID(gridId){
	var tr = $('#' + gridId).siblings().find('.datagrid-editable').parent().parent();//
	var SelectIndex = tr.attr('datagrid-row-index') || -1; 
	return SelectIndex
}

function getExploreName(){
   var userAgent = navigator.userAgent;
   if(userAgent.indexOf("Opera") > -1 || userAgent.indexOf("OPR") > -1){
     return 'Opera';
   }
   else if(userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1){
     return 'IE';
   }
   else if(userAgent.indexOf("Edge") > -1){
      return 'Edge';
   }
   else if(userAgent.indexOf("Firefox") > -1){
      return 'Firefox';
   }
   else if(userAgent.indexOf("Safari") > -1 && userAgent.indexOf("Chrome") == -1){
     return 'Safari';
   }
   else if(userAgent.indexOf("Chrome") > -1 && userAgent.indexOf("Safari") > -1){
      return 'Chrome';
   }
   else if(!!window.ActiveXObject || "ActiveXObject" in window){
      return 'IE>=11';
   }
   else{
    return 'Unkonwn';
   }
}
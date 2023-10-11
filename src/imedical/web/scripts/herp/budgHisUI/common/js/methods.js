
/* treegrid Function 开始*/

	/* 
	Creator:Liu XiaoMing
	CreatDate:2018-03-28
	Description:判断某个节点下是否有被选中的子节点
	*/
	function ChildrenIsChecked(treegridObj, nodeId) {
		var nodeChildren = treegridObj.getChildren(nodeId);
		var flag = 0;
		if (nodeChildren.length > 0) {
			for (j = 0; j < nodeChildren.length; j++) {
				flag = nodeChildren[j].checked ? 1 : 0;
				if (flag == 1) {
					break;
				}
			}
		}
		return flag;
	};
	
	/* 
	Creator:Liu XiaoMing
	CreatDate:2018-03-28
	Description:获取没有子节点且被选中的节点ID串
	*/
	function getNoChiChkedNodesId(treegridObj) {
		var idStr = "";
		var nodes = treegridObj.getCheckedNodes();
		if (nodes.length > 0) {
			for (i = 0; i < nodes.length; i++) {
				var nodeId = nodes[i].id;
				var flag = ChildrenIsChecked(treegridObj, nodeId);
				if(flag) continue;
				if (idStr == "") {
					idStr = nodeId;
				} else {
					idStr = idStr + "^" + nodeId;
				}
			}
		} else {
			$.messager.alert('提示', '请先选中要操作的节点！', 'info');
		}

		return idStr;
	}
	
	/* 
	Creator:Liu XiaoMing
	CreatDate:2018-10-12
	Description:判断某个节点下是否有被选中的子节点
	使用入参为非HISUI对象
	*/
	function ChildrenIsCheckedNotObj(treegridObj, nodeId) {
		var nodeChildren = treegridObj.treegrid('getChildren',nodeId);
		var flag = 0;
		if (nodeChildren.length > 0) {
			for (j = 0; j < nodeChildren.length; j++) {
				flag = nodeChildren[j].checked ? 1 : 0;
				if (flag == 1) {
					break;
				}
			}
		}
		return flag;
	};
	
	/* 
	Creator:Liu XiaoMing
	CreatDate:2018-03-28
	Description:获取没有子节点且被选中的节点ID串
	*/
	function getNoChiChkedNodesIdNotObj(treegridObj) {
		var idStr = "";
		var nodes = treegridObj.treegrid('getCheckedNodes');
		if (nodes.length > 0) {
			for (i = 0; i < nodes.length; i++) {
				var nodeId = nodes[i].id;
				var flag = ChildrenIsCheckedNotObj(treegridObj, nodeId);
				if(flag) continue;
				if (idStr == "") {
					idStr = nodeId;
				} else {
					idStr = idStr + "^" + nodeId;
				}
			}
		} else {
			$.messager.alert('提示', '请先选中要操作的节点！', 'info');
		}

		return idStr;
	}	
/* treegrid Function 结束*/
/* Fomat Function 开始*/

/*
Creator:Liu XiaoMing
CreatDate:2018-03-29
Description: easyui datagrid 格式化列显示两位小数、千分位
 */
function dataFormat(value, row, index) {
	if ((row != null)&&(value!='')&&(value!=null)) {
		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
	}
}

/*
Creator:Liu XiaoMing
CreatDate:2018-03-29
Description: easyui datagrid 格式化列checkbox是否选中,只读不可编辑
 */
function isChecked(value, rec, rowIndex) {
	if(value==1){
		return '<input type="checkbox" onclick="return false;" checked="checked" value="' + value + '"/>';
	}else{
		return '<input type="checkbox" onclick="return false;" value=""/>';
	}
}

/* 
Creator:Liu XiaoMing
CreatDate:2018-06-26
Description:前端用分隔符"^"获取字符串中指定位置的字符串
*/
function mPiece(Input1,Input2,Input3){
	var OutValue="";
	try{
		 OutValue=Input1.split(Input2)[Input3];
	}catch(e){
		return OutValue;
	}
	return OutValue	
}


/* Fomat Function 结束*/
/* 
Creator:Liu XiangSong
CreatDate:2018-04-25
Description:获取当前编辑行的行索引
*/
// 先通过jquery获取父节点的方法parents()或者closest()，获取该行tr标签，再通过attr()获取属性"datagrid-row-index"，即可获取index。
// 代码如下：
function getRowIndex(target){
    var tr = $(target).closest('.datagrid-row');//或者$(target).parents('.datagrid-row')
    return parseInt(tr.attr("datagrid-row-index"));               
}




var editIndex = undefined;
var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];

/*
结束编辑
入参说明：grid-> $('#DetailGrid')
*/
function endEditing(grid,editIndex){
			if (editIndex == undefined){return true}
			if (grid.datagrid('validateRow', editIndex)){
                grid.datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
/*
行点击事件
入参说明：grid-> $('#DetailGrid')，index->行索引
*/
function onClickRow(grid,index){
			if (editIndex != index){
				//console.log("editIndex:"+editIndex+",index:"+index);
				if (endEditing(grid,editIndex)){
					
					grid.datagrid('selectRow', index).datagrid('beginEdit', index);
					editIndex = index;
					console.log("editIndex:"+editIndex+",index:"+index);
				} else {
					grid.datagrid('selectRow', editIndex);
				}
			}
		}
//增加方法
//入参说明：grid-> $('#DetailGrid'),items->{name:'1'}
function append(grid,items,editIndex){
            if (endEditing(grid,editIndex)){
				grid.datagrid('appendRow',items);
				editIndex = grid.datagrid('getRows').length-1;
				grid.datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
				return editIndex;
			}
        }
//重置方法
//入参说明：grid-> $('#DetailGrid')
function clear(grid){
			grid.datagrid('rejectChanges');
			editIndex = undefined;
			return editIndex;
        }	

// 获取当前选中的行，包括前面复选框选中的和行选中的
//入参说明：grid-> $('#DetailGrid')
function GetSelectRows(grid){
			var rows1 = grid.datagrid("getSelections");
            var rows2 = grid.datagrid("getChecked")
			var c = rows1.concat(rows2);//合并成一个数组
            temp = {};//用于id判断重复
            rows = [];//最后的新数组
            //遍历c数组，将每个item.id在temp中是否存在值做判断，如不存在则对应的item赋值给新数组，并将temp中item.id对应的key赋值，下次对相同值做判断时便不会走此分支，达到判断重复值的目的；
            c.map(function(item,indexx){
	            if(!temp[item.rowid]){
		            rows.push(item);
		            temp[item.rowid] = true;
		        }
		    });
		    return rows;
}
	
//删除方法
//适合入参是rowid的情况
//入参说明：grid-> $('#DetailGrid'),classname->类名,methodname->方法名
function del(grid,classname,methodname){
			$.messager.confirm('确定','确定要删除选定的数据吗？',function(t){
            if(t){
                var rows1 = grid.datagrid("getSelections");
                var rows2 = grid.datagrid("getChecked")
                
                /*var len=rows1.length;
                var len2=rows2.length;
                var length=Math.max(parseInt(len),parseInt(len2));*/
                //console.log(length);
                
                var c = rows1.concat(rows2);//合并成一个数组
                temp = {};//用于id判断重复
                rows = [];//最后的新数组
                //遍历c数组，将每个item.id在temp中是否存在值做判断，如不存在则对应的item赋值给新数组，并将temp中item.id对应的key赋值，下次对相同值做判断时便不会走此分支，达到判断重复值的目的；
                c.map(function(item,indexx){
	                if(!temp[item.rowid]){
		                rows.push(item);
		                temp[item.rowid] = true;
		            }
		        });
		        //console.log(JSON.stringify(rows));
                if(rows.length>0){
	                //alert(rows.length);
	                for(var i=0; i<rows.length; i++){
		              var row=rows[i];
		              var rowid= row.rowid;
		              if(!(row.rowid>0)){//新增的行删除
			              editIndex= grid.datagrid('getRowIndex', row);
			              grid.datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
			          }else{//其他选中的行删除
				          $.m({
					          ClassName:classname,
					          MethodName:methodname,
					          rowid:rowid
					          },
					          function(Data){
						          if(Data==0){
							          $.messager.popover({
								          msg: '删除成功',
								          type:'success',
								          style:{"position":"absolute","z-index":"9999",
								          left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
								      grid.datagrid("reload");
							      }else{
								      $.messager.popover({
									      msg: '删除失败！',
									      type:'error',
									      style:{"position":"absolute","z-index":"9999",
									      left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
								  }
							});
				      }
		            } 
	            }else{return}//没有选中，不操作
                               
                grid.datagrid("unselectAll"); //取消选择所有当前页中所有的行
                editIndex = undefined;
                return editIndex;
            } 
        	}) 
    	}	
/*保存方法
//适合入参是rowid的情况
//入参说明：grid-> $('#DetailGrid'),classname->类名,methodname->方法名
*/    		
function save(grid,classnameinsert,methodnameinsert,classnameupdate,methodnameupdate,editIndex){
	    	if (editIndex == undefined){return}
			$.messager.confirm('确定','确定要保存选定的数据吗？',function(t){
            if(t){
	            // 关闭最后一个当前编辑行，否则最后一行的数据不会被getChanges方法捕获到
	            grid.datagrid('endEdit', editIndex);
	            var rows = grid.datagrid("getChanges");
	            var rowIndex="";
                if(rows.length>0){
	                for(var i=0; i<rows.length; i++){
		                var row=rows[i];
		                var rowid= row.rowid;
		                var data="";
		                //保存前不能为空列的验证
		                //获取当前行的行索引
		                if(!row.rowid){//新增的行
		                	rowIndex = grid.datagrid('getRows').length-1;
		                }else{
		                	rowIndex = grid.datagrid('getRowIndex', rowid);//id是关键字值  
		                }
		                
		                //console.log("fields:"+grid.datagrid('getColumnFields'));
		                var fields=grid.datagrid('getColumnFields')	
		                for (var j = 0; j < fields.length; j++) {
			                var field=fields[j];
			                //console.log("field"+i+":"+field);
							var tmobj=grid.datagrid('getColumnOption',field);  
							if (tmobj != null) {
								var reValue="";
								//reValue=grid.datagrid('getData').rows[rowIndex][field];
								reValue=row[field];
								if(reValue == undefined){
									reValue = "";
								}
								if(field!=='ck'){
									if(field=="userid"){reValue=userid;}
									if(field=="hospid"){reValue=hospid;}
									if(data==''){
										data=reValue;
									}else{
										data=data+"^"+reValue;
									}
								}
								//console.log("Value:"+reValue);
								//console.log("typeof:"+typeof(reValue));
								if (tmobj.allowBlank == false) {
									var title = tmobj.title;
									if ((reValue== "")||(reValue = "undefined")||(parseInt(reValue) == 0)) {
										var info =title + "列为必填项，不能为空或零！";
										$.messager.popover({
											msg: info,
											type: 'success',
											style: {
												left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
												top: 10
											}
										});
										return ;
									}
								}
							}
						}
		              //console.log("data:"+data);
                      $.messager.progress({
	                      title: '提示',
	                      msg: '正在保存，请稍候……'
	                  });
		              if(!row.rowid){//新增的行保存
			              $.m({
					          ClassName:classnameinsert,
					          MethodName:methodnameinsert,
					          data:data
					          },
					          function(Data){
						          if(Data==0){
							          $.messager.alert('提示','保存成功！','info',function(){grid.datagrid("reload")});
							      	  $.messager.progress('close');
							      	  editIndex = undefined;
							      }else{
								      var message=""
								      if (Data=="RepName"){message="编码重复！"	}
								      else{message=Data}
								      $.messager.alert('提示','保存失败！' +Data,'error');
								      $.messager.progress('close');
								  }
							});
			          }else{//行数据修改
				          $.m({
					          ClassName:classnameupdate,
					          MethodName:methodnameupdate,
					          rowid:rowid,
					          data:data
					          },
					          function(Data){
						          if(Data==0){
							          $.messager.alert('提示','保存成功！','info',function(){grid.datagrid("reload")});
							      	  $.messager.progress('close');
							      }else{
								      var message=""
								      if (Data=="RepName"){message="编码重复！"	}
								      else{message=Data}
								      $.messager.alert('提示','保存失败！' +Data,'error',function(){grid.datagrid("reload")});
								  	  $.messager.progress('close');	
								  }
							});
				      }
	                
		            } 
	                
	            }else{return}//没有改变，不操作
                editIndex = undefined;               
                grid.datagrid("unselectAll"); //取消选择所有当前页中所有的行
                return editIndex;
                
            }
			})
	    }	
		
/*
Creator:Hao Shanshan
CreatDate:2018-06-22
Description: easyui datagrid 保存前不能为空列验证
入参说明：grid-> $('#DetailGrid'),row->操作的行对象
调用写法：if (saveAllowBlankVaild($('#DetailGrid'),row)){//里面是相关保存处理}
*/
function saveAllowBlankVaild(grid,row){
 
	//获取当前行的行索引
		                if(!row.rowid){//新增的行
		                	rowIndex = grid.datagrid('getRows').length-1;
		                }else{
		                	rowIndex = grid.datagrid('getRowIndex', row.rowid);//id是关键字值  
		                }
		                
		                //console.log("fields:"+grid.datagrid('getColumnFields'));
		                var fields=grid.datagrid('getColumnFields')	
		                for (var j = 0; j < fields.length; j++) {
			                var field=fields[j];
			                //console.log("field"+j+":"+field);
							var tmobj=grid.datagrid('getColumnOption',field); 
							if (tmobj != null) {
								var reValue="";
								//reValue=grid.datagrid('getData').rows[rowIndex][field];
								//reValue=grid.datagrid('getRows')[rowIndex][field];
								reValue=row[field];
								if(reValue == undefined){
									reValue = "";
								}
								//console.log("row:"+JSON.stringify(row)+",field"+j+":"+field+",Value:"+reValue);
								//console.log("typeof:"+typeof(reValue));
								if (tmobj.allowBlank == false) {
									var title = tmobj.title;
									if ((reValue== "")||(reValue = undefined)||(parseInt(reValue) == 0)) {
										//grid.datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
										//grid.datagrid('selectRow', rowIndex);
										var info ="必填项不能为空或零！";
										$.messager.popover({
											msg: info,
											type: 'alert',
											style: {
												left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
												top: 10
											}
										});
										return ;
									}
								}
							}
						}return true;
}
/*
Creator:Hao Shanshan
CreatDate:2018-06-22
Description: combox根据value来选择正确的textField值,适合combox值比较少的情况
data格式参考如下：
							data:[
							{rowid:'1',name:'计划指标'},
							{rowid:'2',name:'收支预算'},
							{rowid:'3',name:'费用标准'},
							{rowid:'4',name:'预算结果表'}
							],
调用：formatter:comboboxFormatter,							
*/
  		function  comboboxFormatter (value, row, rowIndex){
	  		if (!value){
		  		return value;
		  	}
		  	var e = this.editor;
		  	if(e && e.options && e.options.data){
			  	var values = e.options.data;
			  	for (var i = values.length - 1; i >= 0; i--) {
				  	//0 {k: "1", v: "test"}
				  	var k = values[i]['rowid'];
				  	if (value == k ){
					  	//返回V值
					  	return values[i]['name'];
					}
					// 对于float类型字段，转换成数取整，再比较
					else if (!isNaN(k) && !isNaN(value) && Math.floor(parseFloat(k))===Math.floor(parseFloat(value)) ) {
						return values[i]['id'];
					}
				}
			}
		}


function CommonFormatter(combo,valueField,textField){
	if(typeof textField == 'undefined'){
		//仅按RowId进行combo-fammatter
		var FindIndex;
		return function(value,row,index){
			try{
				for (var i = 0; i < combo.options.data.length; i++) {
					if (combo.options.data[i][combo.options.valueField] == value) {
						FindIndex = i;
						break;
					}
				}
			}catch(e){}
			return (FindIndex != -1)? combo.options.data[FindIndex][combo.options.textField] : '';
		}
	}else{
		return function(value,row,index){
			//alert(value);
			if(value==null|| value==""){
				return '';
			}
			try{
				for (var i = 0; i < combo.options.data.length; i++) {
					if (combo.options.data[i].rowid == value) {
						alert(combo.options.data[i].rowid);
						alert(row[textField]);
						if(row[textField]){
							row[textField]=combo.options.data[i].name;
						}
						return combo.options.data[i].name;
					}
				}
			}catch(e){}
			/*
			try{
				for (var i = 0; i < combo.getData.length; i++) {  
					if (combo.getData[i].RowId == value) {
						if(row[textField]){
							row[textField]=combo.getData[i].Description;
						}
						return combo.getData[i].Description;
					}
				}
			}catch(e){}
			*/
			//通过Row里的textField
			if(row[textField]) {
				return row[textField]
			}
			return value;
		}
	}
}		
/*
Creator:Liu XiangSong
CreatDate:2018-08-03
Description: 未知高度宽度的表单“垂直居中”样式操作
入参说明：bigdiv是外层区域（例如div）的$("#id")或者$(".class"),smalldiv是内层区域（例如div）的$("#id")或者$(".class")
调用写法：xycenter($("#bigid"),$("#smallid"))
*/
function xycenter(bigdiv,smalldiv){
	var val=(bigdiv.height()-smalldiv.height())/2;
	smalldiv.css("margin-top",val);
}

//数字链接渲染函数
function ValueFormatter(value, row, index) {
	if ((row != null)&&(value!='')&&(value!=null)) {
		value=(parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
	}
	return '<a href="#" class="grid-td-text" >' + value + '</a>';
}

/*表格单元格链接渲染函数*/
function gridTextStyler(value, row, index) {
	return 'color:#017bce;cursor:hand;cursor:pointer;text-decoration:underline;';

}

//年度预算样式是否有链接
function planValueStyle(value, row, index){
	var Schmrow=$("#schemGrid").datagrid('getSelected');
	if((value=='')||(value==null)){
		return'<a href="#"  class="SpecialClass" title="启用" data-options="iconCls:\'icon-run\'"></a>'
		}
	if ((row != null)&&(value!='')&&(value!=null)) {
		value=(parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
		}
	if (Schmrow.IsEconItem==1) {
		return '<a href="#" class="grid-td-text" >' + value + '</a>';
	} else {
		return value;
		}
	}
	
//最终预算样式是否有链接
function finalValueStyle(value, row, index){
	var factYearRow=$("#schemDetailGrid").datagrid('getSelected');
	if((value=='')||(value==null)){
		return'<a href="#"  class="SpecialClass" title="启用" data-options="iconCls:\'icon-run\'"></a>'
		}
	if ((row != null)&&(value!='')&&(value!=null)) {
		value=(parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
		}
	if (factYearRow.IsGovBuy==1) {
		return '<a href="#" class="grid-td-text" >' + value + '</a>';
		} else {
		return value;
		}
	}

//	
function IsYesorNoFormatter(value, row, index){
	if(value==1)  {value="是"}
	if(value==0)  {value="否"}
	return value
	}


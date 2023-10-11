/*
csp: herp.budg.hisui.budgschemmain.csp
*/
var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
}); 

function Init(){
	//预算年度combox
    var YearboxObj = $HUI.combobox("#Yearbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
                
	// 方案类别combox 
    var SchemTypeboxObj = $HUI.combobox("#SchemTypebox",{
        valueField:'id',
		textField:'name',
		data:[
			{id:'1',name:'全院'}
			,{id:'2',name:'科室'}	
		]
    });
    
     //查询函数
     $("#FindBn").click(function(){
        var year		= $('#Yearbox').combobox('getValue'); // 预算年度
        var schemtype	= $('#SchemTypebox').combobox('getValue'); // 单据单号
        var schem		= $('#Schemfeild').val(); // 申请人

        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemMain",
                MethodName:"List",
                hospid : hospid,
                Year : year,
                sChemeType :schemtype,
                sCN : schem
            })
    })

    MainColumns=[[  
                {
	                field:'ck',
	                checkbox:true
	            },{
	                field:'rowid',
	                title:'ID',
	                width:80,
	                hidden: true
                },{
	                field:'CompName',
	                title:'医疗单位',
	                width:80,
	                hidden: true
	            },{
	                field:'Year',
	                allowBlank:false,
	                title:'年度',
	                width:70,
	                //allowBlank:false,
					editor:{
						type:'combobox',
						options:{
							valueField:'year',
							textField:'year',
							url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
							delay:200,
                    		onBeforeLoad:function(param){
	                    		param.str = param.q;
	                    	},  
	                    	onSelect:function(data){
		                    	var value = data.year;
		                    	var row = $('#MainGrid').datagrid('getSelected');  
                                var rowIndex = $('#MainGrid').datagrid('getRowIndex',row);//获取行号  
                                //var thisTarget = $('#MainGrid').datagrid('getEditor', {'index':rowIndex,'field':'Year'}).target;  
                                //var value = thisTarget.combobox('getValue'); 
                                        
		                    	var target = $('#MainGrid').datagrid('getEditor', {'index':rowIndex,'field':'ItemCode'}).target;  
                                target.combobox('clear'); //清除原来的数据  
                                var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem&hospid="+hospid+"&year="+value;  
                                target.combobox('reload', url);//联动下拉列表重载  
                            },                          
                    	required:true
                    	}
					}
                },{
	                field:'Code',
	                title:'方案编码',
	                width:90,
	                allowBlank:false,
		            required:true,
	                editor:{
		                type:'validatebox',
		                options:{
			               required:true}
	                }
                },{
	                field:'Name',
	                title:'方案名称',
		            required:true,
	                width:220,
	                allowBlank:false,
	                editor:{type:'validatebox',
	                 options:{
			              required:true}}
	            },{
		            field:'UnitType',
		            title:'方案属性',
		            width:80,
	                //allowBlank:false,
					formatter:comboboxFormatter,
	                editor:{
		                type:'combobox',
						options:{
							valueField:'id',
							textField:'name',
							data:[
							{id:'1',name:'全院'},
							{id:'2',name:'科室'}],
							required:true
                    	}
					}
		        },{ 
			        field:'Type',
			        title:'预算类别',
			        width:90,
					formatter:comboboxFormatter,
	                allowBlank:false,
	                editor:{
						type:'combobox',
						options:{
							valueField:'id',
							textField:'name',
							data:[
							{id:'1',name:'计划指标'},
							{id:'2',name:'收支预算'},
							{id:'3',name:'费用标准'},
							{id:'4',name:'预算结果表'}
							],                            
                    	required:true
                    	}
					}
			    },{
				    field:'OrderBy',
				    title:'编制顺序',
				    width:80,
				    hidden: true,
	                editor:{type:'text'}
				},{
					field:'ItemCode',
					title:'结果预算项',
					//allowBlank:false,
					width:100,
					formatter:function(value,row){
						return row.ItemName;
					},
					editor:{
						type:'combobox',
						options:{
							valueField:'code',
							textField:'name',
							url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem",
							delay:200,
							required:true,
                    		onBeforeLoad:function(param){
	                    		param.str = param.q;
	                    		param.hospid=hospid;
	                    		var row = $('#MainGrid').datagrid('getSelected');  
                                /*var rowIndex = $('#MainGrid').datagrid('getRowIndex',row);//获取行号                                 
                                var thisTarget = $('#MainGrid').datagrid('getEditor', {'index':rowIndex,'field':'Year'}).target; 
                                var value = thisTarget.combobox('getValue');*/
                                param.year= row.Year; 
	                    	}
                    	}
					}
				},{
					field:'qzfa',
					title:'前置方案',
					align:'center',
					width:70,
					hidden:true,
                    formatter:function(value,row,index){
	                    var rowid=row.rowid;
	                    return '<a href="#" class="grid-td-text" onclick=endEditing('+rowid+'\')>设置</a>';
                    }
				},{
					field:'nrsz',
					title:'内容设置',
					align:'center',
					width:70,
                    formatter:function(value,row,index){
	                    return '<span class="grid-td-text"><u>编辑</u></span>'
                    }
				},{
					field:'copy',
					title:'内容复制',
					align:'center',
					width:70,
                    formatter:function(value,row,index){
	                    var rowid=row.rowid;
	                    return "<a href='#' class='grid-td-text' onclick=copyfun("+rowid+"\)>复制</a>";
                    }
				},{
					field:'IsHelpEdit',
					title:'是否代编',
					width:70,
					align:'center',
					formatter: function (value, rec, rowIndex) {
						if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
					editor:{type:'checkbox',options:{on:'1',off:'0'}}
				},{
					field:'IsCheck',
					title:'审核状态',
					width:70
				},{
					field:'chkrowid',
					title:'审批流',
					width:150,
					//allowBlank:false,
					formatter:function(value,row){
						return row.ChkFlowName;
					},
					editor:{
						type:'combobox',
						options:{
							valueField:'rowid',
							textField:'name', 
							url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Getcheckflow",
							delay:200,
							required:true,
                    		onBeforeLoad:function(param){
	                    		param.hospid = hospid;
	                    		param.str = param.q;
	                    	}
                    	}
					}
				}

            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemMain",
            MethodName:"List",
            hospid :    hospid,
            Year : "",
            sChemeType : "",
            sCN : ""
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        autoSizeColumn:true, //调整列的宽度以适应内容
        rownumbers:true,//行号
        singleSelect: true, 
        checkOnSelect : true,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
        selectOnCheck : false,//如果设置为 true，点击复选框将会选中该行。如果设置为 false，选中该行将不会选中复选框
        nowap : true,//禁止单元格中的文字自动换行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onClickRow: onClickRow,  //在用户点击一行的时候触发
        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发
            if (field=="nrsz") {
	            var rows = $('#MainGrid').datagrid('getRows');
	            var row = rows[index];	            
                DetailFun(row,comboboxFormatter);
	             
            }
        },
        toolbar: [
        	{
	        	id: 'Add',
            	iconCls: 'icon-add',
           		text: '新增',
            	handler: function(){
	            	add()
           		}
        	},{
	        	id: 'Save',
	        	iconCls: 'icon-save',
	        	text: '保存',
	        	handler: function(){
		        	$('#MainGrid').datagrid('endEdit', editIndex);
		        	savefunction()
            	}
        	},{
	        	id: 'Del',
	        	iconCls: 'icon-cancel',
	        	text: '删除',
	        	handler: function(){
		        	$('#MainGrid').datagrid('endEdit', editIndex);
		        	if($('#MainGrid').datagrid("getSelections").length==0&&($('#MainGrid').datagrid("getChecked").length==0)){
			               $.messager.popover({
			               msg:'没有选中的记录！',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			         }else{
		        	 	del()
		        	 }
		        	
		        }
        	},{
	        	id: 'Clear',
	        	iconCls: 'icon-reset',
	        	text: '重置',
	        	handler: function(){
		        	 editIndex=clear($('#MainGrid'))
		        }
        	},{
	        	id: 'Audit',
	        	iconCls: 'icon-stamp',
	        	text: '审核',
	        	handler: function(){
		        	audit()
		        }
        	},{
	        	id: 'AuditCancel',
	        	iconCls: 'icon-stamp-cancel',
	        	text: '取消审核',
	        	handler: function(){
		        	auditCancel()
		        }
        	}
        ]      
    });    

  		var editIndex = undefined;
  		var curTr;
  		var curTd;
  		var change;
  		
  		//combox根据value来选择正确的textField值,适合combox值比较少的情况
  		function  comboboxFormatter (value, row, rowIndex){
	  		if (!value){
		  		return value;
		  	}
		  	var e = this.editor;
		  	if(e && e.options && e.options.data){
			  	var values = e.options.data;
			  	for (var i = values.length - 1; i >= 0; i--) {
				  	//0 {k: "1", v: "test"}
				  	var k = values[i]['id'];
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
		function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#MainGrid').datagrid('validateRow', editIndex)){
				//$('#MainGrid').datagrid('beginEdit', editIndex);//防止点击之后刷新，然后再点击
				var row = $('#MainGrid').datagrid('getRows')[editIndex];
				if(row.Code.substring(0,3)!="SYS"){
					
					//列表中下拉框实现，修改后把回写chkname，因为formatter显示的是chkname字段
					//审批流
					$('#MainGrid').datagrid('beginEdit', editIndex);
					var ed = $('#MainGrid').datagrid('getEditor', {index:editIndex,field:'chkrowid'});
					var chkname = $(ed.target).combobox('getText');
					$('#MainGrid').datagrid('getRows')[editIndex]['ChkFlowName'] = chkname;
				
					//结果预算项
					ed1 = $('#MainGrid').datagrid('getEditor', {index:editIndex,field:'ItemCode'});
					var ItemName = $(ed1.target).combobox('getText');
					$('#MainGrid').datagrid('getRows')[editIndex]['ItemName'] = ItemName;
				}
				
                $('#MainGrid').datagrid('endEdit', editIndex);
				
				editIndex = undefined;
				//添加高亮样式
				//if (curTr) curTr.addClass('edited');
				//curTr = null;
				return true;
			} else {
				return false;
			}
		}
		
		function onClickRow(index){	
			//if (editIndex != index){
				if (endEditing()){
					$('#MainGrid').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#MainGrid').datagrid('selectRow', editIndex);
				};
				
				var row = $('#MainGrid').datagrid('getRows')[index];
				if(row.Code.substring(0,3)=="SYS"){
					var ed1 = $('#MainGrid').datagrid('getEditor', { index: editIndex, field: 'chkrowid' });
					$(ed1.target).combobox("disable");
					var ed2 = $('#MainGrid').datagrid('getEditor', { index: editIndex, field: 'UnitType' });
					$(ed2.target).combobox("disable");
					var ed3 = $('#MainGrid').datagrid('getEditor', { index: editIndex, field: 'ItemCode' });
					$(ed3.target).combobox("disable");
				}else{
					var ed1 = $('#MainGrid').datagrid('getEditor', { index: editIndex, field: 'chkrowid' });
					$(ed1.target).combobox("enable");
					var ed2 = $('#MainGrid').datagrid('getEditor', { index: editIndex, field: 'UnitType' });
					$(ed2.target).combobox("enable");
					var ed3 = $('#MainGrid').datagrid('getEditor', { index: editIndex, field: 'ItemCode' });
					$(ed3.target).combobox("enable");
				}
			//}
		};
		
		function add(){
			if (endEditing()){
				$('#MainGrid').datagrid('appendRow',{IsCheck:'未审核'});
				editIndex = $('#MainGrid').datagrid('getRows').length-1;
				$('#MainGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
				//console.log("editIndex:"+editIndex);
				var ed = $('#MainGrid').datagrid('getEditor', { 'index': editIndex, field: 'Code' });
			 	$(ed.target).keyup(function (event) {
					if($(ed.target).val().trim().substring(0,3)=="SYS"){
						var ed1 = $('#MainGrid').datagrid('getEditor', { 'index': editIndex, field: 'chkrowid' });
						$(ed1.target).combobox("disable");
						var ed2 = $('#MainGrid').datagrid('getEditor', { 'index': editIndex, field: 'UnitType' });
						$(ed2.target).combobox("disable");
						var ed3 = $('#MainGrid').datagrid('getEditor', { 'index': editIndex, field: 'ItemCode' });
						$(ed3.target).combobox("disable");
					}else{
						var ed1 = $('#MainGrid').datagrid('getEditor', { 'index': editIndex, field: 'chkrowid' });
						$(ed1.target).combobox("enable");
						var ed2 = $('#MainGrid').datagrid('getEditor', { 'index': editIndex, field: 'UnitType' });
						$(ed2.target).combobox("enable");
						var ed3 = $('#MainGrid').datagrid('getEditor', { 'index': editIndex, field: 'ItemCode' });
						$(ed3.target).combobox("enable");
					}
			 })	
			}
		}
		function del(){
			$.messager.confirm('确定','确定要删除选定的数据吗？',function(t){
            if(t){
                var rows1 = $('#MainGrid').datagrid("getSelections");
                var rows2 = $('#MainGrid').datagrid("getChecked")
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
			              editIndex= $('#MainGrid').datagrid('getRowIndex', row);
			              $('#MainGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
			         }else{//其他选中的行删除，只有非审核状态的方案可删除
			          	if(row.IsCheck!="审核"){
				          $.m({
					          ClassName:'herp.budg.hisui.udata.uBudgSchemMain',
					          MethodName:'DeleteSM',
					          rowid:rowid
					          },
					          function(Data){
						          if(Data==0){
							          $.messager.popover({
								          msg: '删除成功',
								          type:'success',
								          style:{"position":"absolute","z-index":"9999",
								          left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
								      $('#MainGrid').datagrid("reload");
							      }else{
								      $.messager.popover({
									      msg: '删除失败！',
									      type:'error',
									      style:{"position":"absolute","z-index":"9999",
									      left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
								  }
							});
			         	}else{
				         	$.messager.popover({
								          msg: '第'+(editIndex+1)+'行,已审核不可删除！',
								          type:'error',
								          style:{"position":"absolute","z-index":"9999",
								          left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
				         }
				      }
		            } 
	            }else{return}//没有选中，不操作
                               
                $('#MainGrid').datagrid("unselectAll"); //取消选择所有当前页中所有的行
                editIndex = undefined;
                return editIndex;
            } 
        	}) 
    	}
    	function savefunction(){
	    	if($('#MainGrid').datagrid("getChanges").length==0){
			$.messager.popover({
			               msg:'没有需要保存的记录！',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			}
	    	$.messager.confirm('确定','确定要保存选定的数据吗？',function(t){
		    	if(t){
	            var rows = $('#MainGrid').datagrid("getChanges");
                if(rows.length>0){
	                for(var i=0; i<rows.length; i++){
		                var row=rows[i]; 
		                //console.log("row:"+JSON.stringify(row));
		                var rowid= row.rowid;
		                if(row.Code){
			                if(row.Code.substring(0,3)!="SYS"){
				                if(!row.UnitType){
					                $.messager.popover({
						                msg: '方案属性不能为空',
						                type:'error',
						                style:{"position":"absolute","z-index":"9999",
						                left:-document.body.scrollTop - document.documentElement.scrollTop/2}
						        	})
						        	return;
						        }
						        if(!row.ItemCode){
					                $.messager.popover({
						                msg: '结果预算项不能为空',
						                type:'error',
						                style:{"position":"absolute","z-index":"9999",
						                left:-document.body.scrollTop - document.documentElement.scrollTop/2}
						        	})
						        	return;
						        }
						        if(!row.chkrowid){
					                $.messager.popover({
						                msg: '审批流不能为空',
						                type:'error',
						                style:{"position":"absolute","z-index":"9999",
						                left:-document.body.scrollTop - document.documentElement.scrollTop/2}
						        	})
						        	return;
						        }
				                
				            }
			                
			            }
		              //保存前不能为空列的验证
		             if (saveAllowBlankVaild($('#MainGrid'),row)){
			             
		              var Year=((row.Year==undefined)?'':row.Year);
		              var Code=((row.Code==undefined)?'':row.Code);
		              var Name=((row.Name==undefined)?'':row.Name);
		              var Type=((row.Type==undefined)?'':row.Type);
		              var UnitType=((row.UnitType==undefined)?'':row.UnitType);
		              var OrderBy=((row.OrderBy==undefined)?'':row.OrderBy);
		              var ItemCode=((row.ItemCode==undefined)?'':row.ItemCode);
		              var IsCheck='';
		              var CheckDate=((row.CheckDate==undefined)?'':row.CheckDate);;
		              var Checker='';
		              var File='';
		              var IsHelpEdit=((row.IsHelpEdit==undefined)?'':row.IsHelpEdit);
		              var chkrowid=((row.chkrowid==undefined)?'':row.chkrowid);
		              var IsSys='';
		              var CompName=((hospid==undefined)?'':hospid);
		              //2017|11|11|1|1||0|||undefined|undefined|0|1|undefined|2
		              //console.log("CheckDate:"+CheckDate);
		              var data=Year+"|"+Code+"|"+Name+"|"+Type+"|"+UnitType
		              			+"|"+OrderBy+"|"+ItemCode+"|"+IsCheck+"|"+CheckDate
		              			+"|"+Checker+"|"+File+"|"+IsHelpEdit+"|"+chkrowid
		              			+"|"+IsSys+"|"+CompName;
		              //alert(data);
		              // 后台处理数据时先显示一个提示框，防止用户多次点击【保存】重复提交数据
                      $.messager.progress({
	                      title: '提示',
	                      msg: '正在保存，请稍候……'
	                  });
		              if(!row.rowid){//新增的行保存
			              $.m({
					          ClassName:'herp.budg.hisui.udata.uBudgSchemMain',
					          MethodName:'InsertSM',
					          data:data
					          },
					          function(Data){
						          if(Data==0){
							          $.messager.popover({
								          msg: '保存成功！',
								          type:'success',
								           style:{"position":"absolute","z-index":"9999",
								                 left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                                         top:1}});
							      	  $.messager.progress('close');
							      	  $('#MainGrid').datagrid("reload");
							      	  editIndex = undefined;
							      }else{
								      var message=""
								       if (Data=="RepName"){
									       $.messager.popover({
										        msg: '编码重复',
										        type:'error',
										        style:{"position":"absolute","z-index":"9999",
										        left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
										}else{
											$.messager.popover({
												msg: '保存失败'+Data,
												type:'error',
												style:{"position":"absolute","z-index":"9999",
												left:-document.body.scrollTop - document.documentElement.scrollTop/2,
												top:1}
												})
										    $.messager.progress('close');
								}}});
			          }else{//行数据修改
				          $.m({
					          ClassName:'herp.budg.hisui.udata.uBudgSchemMain',
					          MethodName:'UpdateSM',
					          rowid:rowid,
					          data:data
					          },
					          function(Data){
						          if(Data==0){
							          $.messager.popover({
								          msg: '保存成功！',
								          type:'success',
								           style:{"position":"absolute","z-index":"9999",
								                 left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                                         top:1}});
		                              $('#MainGrid').datagrid("reload");
							      	  $.messager.progress('close');
							      }else{
								      var message=""
								       if (Data=="RepName"){
									       $.messager.popover({
										       msg: '编码重复',
										       type:'error',
										       style:{"position":"absolute","z-index":"9999",
										       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
										       top:1}})
									   }else{
										   $.messager.popover({
											   msg: '保存失败'+Data,
											   type:'error',
											   style:{"position":"absolute","z-index":"9999",
											   left:-document.body.scrollTop - document.documentElement.scrollTop/2,
											   top:1}})}
										   $.messager.progress('close');
								  }
							});
				      }
				      editIndex = undefined;               
                $("#MainGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
	              }} 
	                
	            }else{return}//没有改变，不操作     
		    	}})
            }
			
	    };
	//审核
	function audit(){
		if($('#MainGrid').datagrid("getSelections").length==0&&($('#MainGrid').datagrid("getChecked").length==0)){
			$.messager.popover({
			               msg:'没有选中的记录！',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			}
			$.messager.confirm('确定','确定要审核选定的数据吗？',function(t){
            if(t){
                var rows = GetSelectRows($('#MainGrid'));
                //console.log(JSON.stringify(rows));
                //console.log(rows.length);
                if(rows.length>0){
	                //alert(rows.length);
	                for(var i=0; i<rows.length; i++){
		              var row=rows[i];
		              var rowid= row.rowid;
		              if(!(row.rowid>0)){//新增的行审核
		               $.messager.popover({
			               msg:'请先保存再审核！',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			          }else{
				          //其他选中的行审核，只审核未审核的数据需要审核
				          //console.log(row.IsCheck);
				          if(row.IsCheck=="未审核"){
					          $.m({
						          ClassName:'herp.budg.hisui.udata.uBudgSchemMain',
						          MethodName:'Updstate',
						          schMainDr:rowid,
						          Checker:userid
						          },
						          function(Data){
							          if(Data==0){
								      $.messager.popover({
									      msg: '审核成功！',
									      type:'success',
									      style:{"position":"absolute","z-index":"9999",
									      left:-document.body.scrollTop - document.documentElement.scrollTop/2,
									      top:1}});
								          $('#MainGrid').datagrid("reload");
								      }else{
									      $.messager.popover({
										  msg: '审核信息:'+Data,
										  type:'error',
										  style:{"position":"absolute","z-index":"9999",
										  left:-document.body.scrollTop - document.documentElement.scrollTop/2,
										  top:1}});
										  $('#MainGrid').datagrid("reload")
										   }
								});
							}
				      }
		            } 
	            }else{return}//没有选中，不操作
                               
                $("#MainGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
                editIndex = undefined;
            } 
        	}) 
	};
	
	//取消审核
	function auditCancel(){
		if($('#MainGrid').datagrid("getSelections").length==0&&($('#MainGrid').datagrid("getChecked").length==0)){
			$.messager.popover({
			               msg:'没有选中的记录！',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			}
			$.messager.confirm('确定','确定要取消审核选定的数据吗？',function(t){
            if(t){
                var rows =GetSelectRows($('#MainGrid'));
                //console.log(JSON.stringify(rows));
                //console.log(rows.length);
                if(rows.length>0){
	                //alert(rows.length);
	                for(var i=0; i<rows.length; i++){
		              var row=rows[i];
		              var rowid= row.rowid;
		              if(!(row.rowid>0)){//新增的行取消审核
		                $.messager.popover({
			               msg:'未审核，无需取消审核！',
			               type:'alert',
			               timeout: 2000,
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
			               top:1}});
                            return;
			          }else{
				          //其他选中的行审核，只审核审核的数据需要取消审核
				          //console.log(row.IsCheck);
				          if(row.IsCheck=="审核"){
					          $.m({
						          ClassName:'herp.budg.hisui.udata.uBudgSchemMain',
						          MethodName:'UnUpdstate',
						          schMainDr:rowid,
						          Checker:userid
						          },
						          function(Data){
							          if(Data==0){
								           $.messager.popover({
									           msg: '取消审核成功！',
									           type:'success',
									           style:{"position":"absolute","z-index":"9999",
									           left:-document.body.scrollTop - document.documentElement.scrollTop/2,
									           top:1}});
									        $('#MainGrid').datagrid("reload")
								      }else{
									       $.messager.popover({
										       msg: '操作失败:'+Data,
										       type:'error',
										       style:{"position":"absolute","z-index":"9999",
										       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
										       top:1}});
									  }
								});
							}
				      }
		            } 
	            }else{return}//没有选中，不操作
                               
                $("#MainGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
                editIndex = undefined;
            } 
        	}) 
	};
	//复制
	copyfun=function (rowid){
		//console.log(rowid);
		if(!(rowid>0)){//新增的行复制
		$.messager.popover({
			msg:'请先保存再复制！',
			type:'alert',
			timeout: 2000,
			showType: 'show',
			style:{"position":"absolute","z-index":"9999",
			left:-document.body.scrollTop - document.documentElement.scrollTop/2,
			top:1}});
		     return;
		 }else{
			 $.messager.prompt("复制", "复制到年度:", function (r) {
				 if (r) {
					 $.m({
						 ClassName:'herp.budg.hisui.udata.uBudgSchemMain',
						 MethodName:'copyScheme',
						 schemeDr:rowid,
						 Year:r
						 },
						 function(Data){
							 if(Data==0){
								 $.messager.popover({
									 msg: '复制成功！',
									 type:'success',
									 style:{"position":"absolute","z-index":"9999",
									 left:-document.body.scrollTop - document.documentElement.scrollTop/2,
									 top:1}});
									 $('#MainGrid').datagrid("reload")
									 }else{
								 $.messager.popover({
									 msg: '操作失败:'+Data,
									 type:'error',
									 style:{"position":"absolute","z-index":"9999",
									 left:-document.body.scrollTop - document.documentElement.scrollTop/2,
									 top:1}});
							 	}
							 });
				} else {
					return
					}
					});	
				}
				$("#MainGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
                editIndex = undefined;
	};
   //方案编码的文本框
   var Code1 = $('#Code').attr('getValue'); 
   $("#Code").blur(function(){
		    if("Code1".substring(0, 3) == "SYS"){
			    $("#UnitType").combobox("disable");
			    $("#Type").combobox("disable");
			    $("#chkrowid").combobox("disable")}} 
    )
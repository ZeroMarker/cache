$(function(){//初始化
    Init();
}); 

function Init(){
	
    //预算年度combox
    var YearboxObj = $HUI.combobox("#Yearbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
        onSelect:function(data){
	        //console.log(JSON.stringify(data));
	        $('#Schembox').combobox('clear'); //清除原来的数据
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem&hospid="+hospid+"&userdr="+userid+"&flag=1&year="+data.year;
	        $('#Schembox').combobox('reload', url);//联动下拉列表重载  
        }
    });
    //预算方案
    var Schembox = $HUI.combobox("#Schembox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem",
        mode:'remote',
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
	        var year=$('#Yearbox').combobox('getValue');
	        if(year==""){
		        $.messager.popover({msg: '请先选择年度！',type:'info',timeout: 2000,showType: 'show',style:{"position":"absolute","z-index":"9999",
		               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		               top:1}});
		        return;
		    }
            param.str = param.q;
            param.hospid=hospid;
            param.userdr=userid;
            param.flag=1;
            param.year=year;
        },
        onSelect:function(data){
	        //console.log(JSON.stringify(data));
	        var IsLast = $('#IsLastBox').checkbox('getValue'); //是否末级
        	if(IsLast == true){
	       		IsLast=1;
	    	}else{
		    	IsLast=0;
			}
		    MainGridObj.load({
                	ClassName:"herp.budg.hisui.udata.uBudgSchemIncrement",
                	MethodName:"List",
                	hospid : hospid, 
                	year : $('#Yearbox').combobox('getValue'), 
                	bsmId : data.rowid, 
                	deptId : -1, 
                	bidTy : $('#ItemTypebox').combobox('getValue'), 
                	isLast : IsLast, 
                	bidCo : $('#Itemfield').val()
         	}) ; 
     	}
    });
                
     //科目类别
    var Schembox = $HUI.combobox("#ItemTypebox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType",
        mode:'remote',
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.flag=1;
        },
        onSelect:function(data){
	        //console.log(JSON.stringify(data));
	        var Schem=$('#Schembox').combobox('getValue');
	        if(Schem!==""){
		        var IsLast = $('#IsLastBox').checkbox('getValue'); //是否末级
        		if(IsLast == true){
	       			IsLast=1;
	    		}else{
		    		IsLast=0;
				}
		       	MainGridObj.load({
                	ClassName:"herp.budg.hisui.udata.uBudgSchemIncrement",
                	MethodName:"List",
                	hospid : hospid, 
                	year : $('#Yearbox').combobox('getValue'), 
                	bsmId : Schem, 
                	deptId : -1, 
                	bidTy : data.code, 
                	isLast : IsLast, 
                	bidCo : $('#Itemfield').val()
         		}) ;
		    }
	        
     	}
    });
  
	//是否末级
    $("#IsLastBox").checkbox({
        onCheckChange:function(event,value){
	        if(value == true){
	        	value=1;
	       	}else{
		       	value=0;
		   	}		   

        	var Schem		= $('#Schembox').combobox('getValue'); // 方案
        	if(Schem!==""){
	        	MainGridObj.load({
                	ClassName:"herp.budg.hisui.udata.uBudgSchemIncrement",
                	MethodName:"List",
                	hospid : hospid, 
                	year : $('#Yearbox').combobox('getValue'), 
                	bsmId : Schem, 
                	deptId : -1, 
                	bidTy : $('#ItemTypebox').combobox('getValue'), 
                	isLast : value, 
                	bidCo : $('#Itemfield').val()
         		}) ;
	    	}
        }
    })
    
     //查询函数
    var FindBtn= function()
    {
	    
        var Year		= $('#Yearbox').combobox('getValue'); // 预算年度
        var Schem		= $('#Schembox').combobox('getValue'); // 方案
        if(Schem==""){
	        $.messager.popover({
						    msg:'请根据方案查询！',timeout: 3000,type:'info',showType: 'show',
				            style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:1
					        }
			});
	        return;
	    }
        var ItemType	= $('#ItemTypebox').combobox('getValue'); //科目类别
        var Item		= $('#Itemfield').val(); // 科目
        var IsLast = $('#IsLastBox').checkbox('getValue'); //是否末级
        if(IsLast == true){
	       	IsLast=1;
	    }else{
		    IsLast=0;
		}

        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemIncrement",
                MethodName:"List",
                hospid : hospid, 
                year : Year, 
                bsmId : Schem, 
                deptId : -1, 
                bidTy : ItemType, 
                isLast : IsLast, 
                bidCo : Item
         });
    }

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
	                field:'bfyear',
	                title:'年度',
	                width:70
                },{
	                field:'bfitemcode',
	                title:'科目编码',
	                width:150
                },{
	                field:'bfitemcodename',
	                title:'科目名称',
	                width:250
	            },{
		            field:'bfrealvaluelast',
		            title:'上年执行',
		            width:150, 
		            align:'right',
					formatter: function (value, row, index) {
						if (row != null) {
							return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
                        }
                    }
		        },{ 
			        field:'bfincreaserate',
			        title:'增量比例',
			        width:100, 
		            align:'right',
			        editor: {
				        type: 'numberbox',
				        options: {
					        required: true,
					        precision:2
					    } 
            		},
            		styler: function (value, row, index) {
	            		return 'background-color:#E7F7FE;color:red;cursor:hand;cursor:pointer;';
	            	}
			    },{
				    field:'bfplanvalue',
				    title:'本年计划',
				    width:150,  
		            align:'right',
					formatter: function (value, row, index) {
						if (row != null) {
							return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
                        }
                    }
				},{
					field:'CalFlag',
					title:'计算方法',
					width:150
				},{
					field:'IsLast',
					title:'是否末级',
					width:150,
					hidden:true
					
				}

            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        autoSizeColumn:true, //调整列的宽度以适应内容
        rownumbers:true,//行号
        singleSelect: false, 
        checkOnSelect : true,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
        selectOnCheck : true,//如果设置为 true，点击复选框将会选中该行。如果设置为 false，选中该行将不会选中复选框
        nowap : true,//禁止单元格中的文字自动换行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onClickRow: onClickRow,  //在用户点击一行的时候触发
        toolbar: [
        	{
	        	id: 'Save',
	        	iconCls: 'icon-save',
	        	text: '保存',
	        	handler: function(){
		        	save()
            	}
        	},{
	        	id: 'Batch',
	        	iconCls: 'icon-batch-cfg',
	        	text: '批量',
	        	handler: function(){
		        	Batch()
		        }
        	}
        ]      
    });    

  		var editIndex = undefined;
		function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#MainGrid').datagrid('validateRow', editIndex)){
				$('#MainGrid').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
		function onClickRow(index){
			if (editIndex != index){
				if (endEditing()){
					$('#MainGrid').datagrid('selectRow', index).datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#MainGrid').datagrid('selectRow', editIndex);
				}
			}
			if($('#MainGrid').datagrid("getSelected").IsLast==0){
				var ed1 = $('#MainGrid').datagrid('getEditor', { index: editIndex, field: 'bfincreaserate' });
			    $(ed1.target).numberbox("disable");};
		}	

    	function save(){
	    	if (editIndex == undefined){return}
			$.messager.confirm('确定','确定要保存选定的数据吗？',function(t){
            if(t){
	            // 关闭最后一个当前编辑行，否则最后一行的数据不会被getChanges方法捕获到
	            $('#MainGrid').datagrid('endEdit', editIndex);
	            var rows = $('#MainGrid').datagrid("getChanges");
                if(rows.length>0){
	                for(var i=0; i<rows.length; i++){
		              var row=rows[i]; 
		              var rowid= row.rowid;
		              //保存前不能为空列的验证
		             if (saveAllowBlankVaild($('#MainGrid'),row)){
			             
		              var incRate=row.bfincreaserate;
		              var calMeth=((row.bsdcalflag==undefined)?'':row.bsdcalflag);
		              var schId=$('#Schembox').combobox('getValue');

		              //console.log("CheckDate:"+CheckDate);
		              
		              // 后台处理数据时先显示一个提示框，防止用户多次点击【保存】重复提交数据
                      $.messager.progress({
	                      title: '提示',
	                      msg: '正在保存，请稍候……'
	                  });
		              
			          $.m({
				          ClassName:'herp.budg.hisui.udata.uBudgSchemIncrement',
					      MethodName:'UpdateRec',
					      userId : userid, 
					      rowid : rowid, 
					      incRate : incRate, 
					      calMeth : calMeth, 
					      schId : schId
					      },
					      function(Data){
						      if(Data==0){
							      $.messager.popover({
								      msg:'操作成功！',timeout: 3000,type:'info',showType: 'show',
								      style:{
									      "position":"absolute",
									      "z-index":"9999",
									      left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
									      top:1
									   }
									});
							          $('#MainGrid').datagrid("reload");
							      	  $.messager.progress('close');
							      	  editIndex = undefined;
							   }else{
								   var message=""
								   if (Data=="RepName"){message="编码重复！"	}
								   else{message=Data}
								   
								   $.messager.popover({
								      msg:message,timeout: 3000,type:'info',showType: 'show',
								      style:{
									      "position":"absolute",
									      "z-index":"9999",
									      left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
									      top:1
									   }
									});
								    $.messager.progress('close');
								  }
							});
	                }
		            } 
	                
	            }else{return}//没有改变，不操作
                editIndex = undefined;               
                $("#MainGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
                
            }
			})
	    }
	//批量
	Batch=function (rowid){
		//console.log(rowid);
		var rows = $('#MainGrid').datagrid("getSelections");
        if(rows.length>0){
	        var schId=$('#Schembox').combobox('getValue');
	        var rowids="";
	        for(var i=0; i<rows.length; i++){
		        var row=rows[i];
		        var rowid= row.rowid;
		        if(rowids==""){
			        rowids=rowid;
			    }else{
				    rowids=rowids+"^"+rowid;
				}
		        var calMeth=((row.bsdcalflag==undefined)?'':row.bsdcalflag);
		    }
		}else{
			$.messager.popover({
				msg:'请选中需要操作的记录',timeout: 3000,type:'info',showType: 'show',
				style:{
					"position":"absolute",
					"z-index":"9999",
					left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					top:1
				 }
			 });
			 return;
		}
		$.messager.prompt("批量设置增长比例", "增长比例%:", function (r) {
				 if (r) {
					 $.m({
						 ClassName:'herp.budg.hisui.udata.uBudgSchemIncrement',
						 MethodName:'UpdateRecs',
						 userId : userid, 
					     rowids : rowids, 
					     incRate : r, 
					     calMeth : calMeth, 
					     schId : schId
						 },
						 function(Data){
							 if(Data==0){
								 $.messager.popover({
								      msg:'操作成功！',timeout: 3000,type:'info',showType: 'show',
								      style:{
									      "position":"absolute",
									      "z-index":"9999",
									      left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
									      top:1
									   }
								 });
							          $('#MainGrid').datagrid("reload");
							}else{
								$.messager.popover({
								      msg:Data,timeout: 3000,type:'info',showType: 'show',
								      style:{
									      "position":"absolute",
									      "z-index":"9999",
									      left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
									      top:1
									   }
								});
								 
							 }
						});
				} else {
					return;
					}
		});	
				
				$("#MainGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
                editIndex = undefined;
	}
    //点击查询按钮 
    $("#FindBn").click(FindBtn); 
}
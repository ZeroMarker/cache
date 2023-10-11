/**
 *按钮权限说明
 *新建状态：增加、保存、删除均可用
 *其他：均不可用
 *
 **/

var RowDelim = String.fromCharCode(1); //行数据间的分隔符, IsCheck, curSchemeName, syear
DetailFun = function (row,comboboxFormatter) {
	//console.log(JSON.stringify(row));
	
	var curSchemeDr = row.rowid;
	var IsCheck = row.IsCheck;
	var curSchemeName = row.Name;
	var year = row.Year;
	var schemdr = row.rowid;
	  
	//初始化窗口
	var $Detailwin;
	$Detailwin = $('#DetailWin').window({
	    title: '当前方案:'+curSchemeName,
	    width: 1015,
	    height: 500,
	    top: ($(window).height() - 500) * 0.5,
	    left: ($(window).width() - 1015) * 0.5,
	    shadow: true,
	    modal: true,
	    closed: true,
	    minimizable: false,
	    maximizable: false,
	    collapsible: false,
	    resizable: true,
	    onClose:function(){ //关闭关闭窗口后触发
	    	
            //$("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
	});
	$Detailwin.window('open');
    
    
    //列配置对象
    EditColumns=[[  
                {
	                field:'ck',
	                checkbox:true
	            },{
	                field:'rowid',
	                title:'ID',
	                width:80,
	                hidden: true
                },{
	                field:'sname',
	                title:'项目名称',
	                width:250,
	                allowBlank:false,
					editor:{
						type:'combobox',
						options:{
							valueField:'code',
							textField:'name1',
							mode:'remote',
							url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem",
							delay:200,
                    		onBeforeLoad:function(param){
	                    		param.str = param.q;
	                    		param.hospid=hospid;
                                param.year= year; 
	                    	},                           
                    	required:true
                    	}
					}
	            },{
	                field:'CalFlag',
	                title:'计算方法',
	                width:160,
					formatter:comboboxFormatter,
					allowBlank:false,
	                editor:{
						type:'combobox',
						options:{
							valueField:'id',
							textField:'name',
							data:[
							{id:'1',name:'公式计算'},
							{id:'2',name:'历史数据* 比例系数'},
							{id:'3',name:'历史数据'}
							],
		                    onSelect: function(rec){ 
		                    	/*公式计算选择后，弹出公式设置窗口*/
		                        if(rec.id=='1'){
			                        var rowIndex=getRowIndex(this);
			                        var getRows=$("#DetailGrid").datagrid("getRows");
			                        var OldeFormula=getRows[rowIndex].formuladesc;
		                        	formula(OldeFormula,rowIndex,$("#DetailGrid"),"formuladesc","formulaset");
		                        }; 
		                    }
                    	}
					}
                },{
	                field:'IsCal',
	                title:'是否计算',
	                width:70,
					align:'center',
					allowBlank:false,
					formatter: function (value, rec, rowIndex) {
						if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
	                editor:{type:'icheckbox',options:{on:'1',off:'0',onCheckChange:function(event,value){
		                var rowIndex=getRowIndex(this);
		                var Editors = $('#DetailGrid').datagrid("getEditors",rowIndex);
		                if(value==false){
			                $(Editors[1].target).combobox("disable");
			                $(Editors[1].target).combobox("clear");
			                $(Editors[3].target).text();
			                $(Editors[3].target).attr("disabled",true);
			                $(Editors[4].target).attr("disabled",true);
			            }else{
				            $(Editors[1].target).combobox("enable");
				            $(Editors[3].target).attr("disabled",false);
				            $(Editors[4].target).attr("disabled",false);
				        }
		                }}}
                },{
		            field:'CalNo',
		            title:'计算顺序',
		            width:100,
		            editor:{type:'text'}
		        },{
		            field:'formulaset',
		            title:'公式表达式',
		            width:180,
		            hidden: true,
		            editor:{type:'text'}

		        },{ 
			        field:'formuladesc',
			        title:'公式描述',
			        width:180,
			        editor:{type:'text'}
			    },{
				    field:'IsSplit',
				    title:'是否分解',
					align:'center',
				    width:70,
				    allowBlank:false,
					formatter: function (value, rec, rowIndex) {
						if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
	                editor:{type:'checkbox',options:{on:'1',off:'0'}}
				},{
					field:'IsLast',
					title:'是否末级',
					width:70,
					align:'center',
					hidden:true,
					editor:{type:'checkbox',options:{on:'1',off:'0'}}
				}

            ]];
    //批量按钮 
    var BatchBtn={
        id: 'Batchset',
        iconCls: 'icon-batch-cfg',
        text: '批量',
        handler: function() {
            batchsetting (year,schemdr);  
        }
    }
    //批量添加按钮
    var BatchaddBtn={
        id: 'BatchAdd',
        iconCls: 'icon-batch-add',
        text: '批量添加',
        handler: function() {
            batchadd (year,schemdr);  
        }
    }
    
    //增加按钮
    var AddBtn={
        id: 'AddD',
        iconCls: 'icon-add',
        text: '新增',
        handler: function(){ 
            append();  //增加一行函数
        }
    }
    //保存按钮
    var SaveBtn= {
        id: 'SaveD',
        iconCls: 'icon-save',
        text: '保存',
        handler: function(){
	        save(); //保存方法
        }
    }
    //删除按钮
    var DelBt= {
        id: 'DelD',
        iconCls: 'icon-cancel',
        text: '删除',
        handler: function(){
	         if($('#DetailGrid').datagrid("getSelections").length==0){
			               $.messager.popover({
			               msg:'没有选中的记录！',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			          }else{
	        del($('#DetailGrid'),'herp.budg.udata.uBudgSchemDetail','Delete');
		              }}
       
    }
    //重置按钮
    var ClearBT= {
        id: 'ClearD',
        iconCls: 'icon-reset',
        text: '重置',
        handler: function(){
            clear($('#DetailGrid'));
        }
    }
  
    //定义表格
    var DetailGrid = $HUI.datagrid("#DetailGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemMain",
            MethodName:"DetailList",
            schemeDr : curSchemeDr 
        },
        autoRowHeight: true,
        autoSizeColumn:true, //调整列的宽度以适应内容
        singleSelect: false, 
        checkOnSelect : true,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
        selectOnCheck : true,//如果设置为 true，点击复选框将会选中该行。如果设置为 false，选中该行将不会选中复选框
        loadMsg:"正在加载，请稍等…",
        rownumbers:true,//行号 
        nowap : true,//禁止单元格中的文字自动换行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:EditColumns,
        onClickRow: onClickRow,  //在用户点击一行的时候触发
       /* onClickCell: function(index,field,value){
	        if(field=="formuladesc"){
		        $('#DetailGrid').datagrid('selectRow', index);
		        $('#DetailGrid').datagrid('beginEdit', index);
		        var cellEdit = $('#DetailGrid').datagrid("getEditor",{index:index,field:"formuladesc"});
		        $(cellEdit.target).prop('disabled',true);
		        var oldFormula=$('#DetailGrid').datagrid('getSelected').formuladesc
		        formula(oldFormula,index,$("#DetailGrid"),"formuladesc","formulaset")}},*/
        onBeforeEdit:function(rowIndex, rowData){
            /*if (checkBefEdit() == false) {
                return false;
            } else {
                return true;
            } */           
        },
        toolbar: [BatchaddBtn,BatchBtn,AddBtn,SaveBtn,DelBt,ClearBT]       
    });
	
	if(IsCheck=="审核"){
		$('#Batchset').linkbutton('disable');
		$('#BatchAdd').linkbutton('disable');
		$('#AddD').linkbutton('disable');
		$('#SaveD').linkbutton('disable');
		$('#DelD').linkbutton('disable');
		$('#ClearD').linkbutton('disable');
	} 
	
    //函数区
    var editIndex = undefined; //定义全局变量：当前编辑的行
 	function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#DetailGrid').datagrid('validateRow', editIndex)){
				//列表中下拉框实现，修改后把回写sname，因为formatter显示的是sname字段
				//项目名称
				$('#DetailGrid').datagrid('beginEdit', editIndex);
				var ed = $('#DetailGrid').datagrid('getEditor', {index:editIndex,field:'sname'});
				var sname = $(ed.target).combobox('getText');
				$('#DetailGrid').datagrid('getRows')[editIndex]['sname'] = sname;
                $('#DetailGrid').datagrid('endEdit', editIndex);
				
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
	function onClickRow(index,row){
			if (editIndex != index){
				if (endEditing()){
					$('#DetailGrid').datagrid('selectRow', index)
					$('#DetailGrid').datagrid('beginEdit', index);
				var cellEdit = $('#DetailGrid').datagrid("getEditor",{index:index,field:"formuladesc"});
				  
				  $(cellEdit.target).focus(function(){
					  if(row.CalFlag==1){
				      var oldFormula=$('#DetailGrid').datagrid('getSelected').formuladesc
		              formula(oldFormula,index,$("#DetailGrid"),"formuladesc","formulaset")
					  }else{
						$('#DetailGrid').datagrid('endEdit', index);
						$(cellEdit.target).prop('disabled',true) }	
				      })
					editIndex = index;
				} else {
					$('#DetailGrid').datagrid('selectRow', editIndex);
				}
			}
		}
          
    //增加方法
    	function append(){
            if (endEditing()){
				$('#DetailGrid').datagrid('appendRow',{CalFlag:2,IsCal:1});
				editIndex = $('#DetailGrid').datagrid('getRows').length-1;
				$('#DetailGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
			}
        }
        /*//删除方法
    	function del(){
	    	if (editIndex == undefined){return}
			$.messager.confirm('确定','确定要删除选定的数据吗？',function(t){
            if(t){
                var rows = $('#DetailGrid').datagrid("getSelections");
                //console.log(JSON.stringify(rows));
                //console.log(rows.length);
                if(rows.length>0){
	                //alert(rows.length);
	                for(var i=0; i<rows.length; i++){
		              var row=rows[i];
		              var rowid= row.rowid;
		              if(!(row.rowid>0)){//新增的行删除
			              editIndex= $('#DetailGrid').datagrid('getRowIndex', row);
			              $('#DetailGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
			          }else{//其他选中的行删除
				          $.m({
					          ClassName:'herp.budg.udata.uBudgSchemDetail',
					          MethodName:'Delete',
					          rowid:rowid
					          },
					          function(Data){
						          if(Data==0){
							          $.messager.alert('提示','删除成功！','info',function(){$('#DetailGrid').datagrid("reload")});
							      }else{
								      $.messager.alert('提示','错误信息:' +Data,'error',function(){$('#DetailGrid').datagrid("reload")});
								  }
							});
				      }
		            } 
	            }else{return}//没有选中，不操作
                               
                $("#DetailGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
                editIndex = undefined;
            } 
        	}) 
    	}*/
    	function save(){
	    	if($('#DetailGrid').datagrid("getSelections").length==0){
			$.messager.popover({
			               msg:'没有选中的记录！',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			}
			$.messager.confirm('确定','确定要保存选定的数据吗？',function(t){
            if(t){
	            // 关闭最后一个当前编辑行，否则最后一行的数据不会被getChanges方法捕获到
	            $('#DetailGrid').datagrid('endEdit', editIndex);
	            var rows = $('#DetailGrid').datagrid("getChanges");
	            var rowIndex="";
                if(rows.length>0){
	                for(var i=0; i<rows.length; i++){
		                var row=rows[i];
		                var rowid= row.rowid;
		                
		                //保存前不能为空列的验证
		                if (saveAllowBlankVaild($('#DetailGrid'),row)){
		              
		              //console.log(JSON.stringify(row));
		              //console.log(row.sname);
		              var sname=((row.sname=="undefined")?'':row.sname.split("_")[0]);
		              var CalFlag=((row.CalFlag=="undefined")?'':row.CalFlag);
		              var IsCal=((row.IsCal=="undefined")?'':row.IsCal);
		              var formulaset=((row.formulaset=="undefined")?'':row.formulaset);
		              var formuladesc=((row.formuladesc=="undefined")?'':row.formuladesc);
		              var IsSplit=((row.IsSplit=="undefined")?'':row.IsSplit);
		              var SplitMeth=((row.SplitMeth=="undefined")?'':row.SplitMeth);
		              var CalNo=((row.CalNo=="undefined")?'':row.CalNo);
		         
		              
		              //SchemDR, Code, Level, CalFlag, IsCal, Formula, CalNo, formuladesc, IsSplit, SplitMeth
		              //sname,CalFlag,IsCal,set,formulaset,formuladesc,IsSplit,SplitMeth
		              // 后台处理数据时先显示一个提示框，防止用户多次点击【保存】重复提交数据
                      $.messager.progress({
	                      title: '提示',
	                      msg: '正在保存，请稍候……'
	                  });
		              if(!row.rowid){//新增的行保存
			              $.m({
					          ClassName:'herp.budg.udata.uBudgSchemDetail',
					          MethodName:'Insert',
					          SchemDR:curSchemeDr,
					          Code:sname,
					          Level:'',
					          CalFlag:CalFlag,
					          IsCal:IsCal,
					          Formula:formulaset,
					          CalNo:CalNo,
					          CalDesc:formuladesc,
					          IsSplit:IsSplit,
					          SplitMeth:SplitMeth
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
							      	  $('#DetailGrid').datagrid("reload");
							       	  editIndex = undefined;
							      }else{
								      var message=""
								       if (Data=="RepName"){
									       $.messager.popover({
										        msg: '编码重复',
										        type:'error',
										        style:{"position":"absolute","z-index":"9999",
										        left:-document.body.scrollTop - document.documentElement.scrollTop/2}})}
										         else{
											         $.messager.popover({
												          msg: '保存失败'+Data,
												          type:'error',
												          style:{"position":"absolute","z-index":"9999",
												          left:-document.body.scrollTop - document.documentElement.scrollTop/2}})}}		  
							 $.messager.progress('close');
							});
			          }else{//行数据修改
				          $.m({
					          ClassName:'herp.budg.udata.uBudgSchemDetail',
					          MethodName:'Update',
					          rowid:rowid,
					          SchemDR:curSchemeDr,
					          Code:sname,
					          Level:'',
					          CalFlag:CalFlag,
					          IsCal:'',
					          Formula:formulaset,
					          CalNo:CalNo,
					          CalDesc:formuladesc,
					          IsSplit:IsSplit,
					          SplitMeth:SplitMeth
					          },
					          function(SQLCODE){
						          if(SQLCODE==0){
							          $.messager.popover({
								          msg: '保存成功！',
								          type:'success',
								           style:{"position":"absolute","z-index":"9999",
								                 left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                                         top:1}});
							      	  $.messager.progress('close');
							      	  $('#DetailGrid').datagrid("reload");
							      	  editIndex = undefined;
							      }else{
								      var message=""
								       if (SQLCODE=="RepName"){
									       $.messager.popover({
										        msg: '编码重复',
										        type:'error',
										        style:{"position":"absolute","z-index":"9999",
										        left:-document.body.scrollTop - document.documentElement.scrollTop/2}})}
										         else{
											         $.messager.popover({
												          msg: '保存失败'+SQLCODE,
												          type:'error',
												          style:{"position":"absolute","z-index":"9999",
												          left:-document.body.scrollTop - document.documentElement.scrollTop/2}})}}		  
							 $.messager.progress('close');		  
							});
				      }
	                }
		            } 
	                
	            }else{return}//没有改变，不操作
                editIndex = undefined;               
                $("#DetailGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
                
            }
			})
	    }
    //关闭按钮
	$("#DetailClose").click(function(){
        $Detailwin.window('close');
    })
}
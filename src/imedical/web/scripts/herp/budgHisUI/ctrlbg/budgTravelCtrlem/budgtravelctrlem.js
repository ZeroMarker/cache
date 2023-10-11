var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    
    Init();
});

function Init(){
	
	var YMboxObj = $HUI.combobox("#YMbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
        onSelect: function () {
	            $('#CodeDatabox').combobox('clear');
				$('#CodeDatabox').combobox('reload');
				$('#MainGrid').datagrid('load', {
					ClassName: 'herp.budg.hisui.udata.BudgTravelCashCtrlem',
					MethodName: 'List',
					hospid :hospid, 
                    Year : $("#YMbox").combobox('getValue'),
                    ItemCode :"", 
                    Type :""
					
				});

			}
    });
    
    var YMboxObj = $HUI.combobox("#CodeDatabox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=CtrlItemCode",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
        onSelect: function () {
	            
				$('#MainGrid').datagrid('load', {
					ClassName: 'herp.budg.hisui.udata.BudgTravelCashCtrlem',
					MethodName: 'List',
					hospid :hospid, 
                    Year : $("#YMbox").combobox('getValue'),
                    ItemCode :$("#CodeDatabox").combobox('getValue'), 
                    Type :""
					
				});

			}
    });
    
    MainColumns=[[  
                {
	                field:'ckbox',
	                checkbox:true,
                },
                {
	                field:'rowid',
	                title:'ID',
	                width:80,
	                hidden: true
                },
                {
	                field:'CompDR',
	                title:'医院ID',
	                width:80,
	                hidden: true
                },
                {
	                field:'Year',
	                title:'年度',
	                width:150,
	                editor: {
		                type:'combobox',
		                options:{
			                valueField:'year',    
                            textField:'year',
                            mode:'remote',
                            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
                            delay:200,
			                onBeforeLoad:function (param){
				                param.flag = '';
                                param.str = param.q;
                               },
		                }
			                
		                }
	                
                },
                {
	                field:'ItemCode',
	                title:'差旅费控制项',
	                width:350,
					formatter:function(value,row,index){
						return row.Name},
	                editor:{type:'combobox',
	                        options:{
		                       url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=CtrlItemCode",
                               mode:'remote',
                               delay:200,
                               valueField:'code',     
                               textField:'name',
                               onBeforeLoad:function(param){
                                            param.str = param.q;
                                            }    
			               }   
                }
                },
                {
	                field:'Type',
	                title:'控制类型',
	                width:150,
	                hidden: true
                } 
                
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.BudgTravelCashCtrlem",
            MethodName:"List",
            hospid :    hospid, 
            Year :      "",
            ItemCode :      "", 
            Type :      ""
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        ctrlSelec:true, //在启用多行选择的时候允许使用Ctrl键+鼠标点击的方式进行多选操作
        scheckOnSelect : true,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
        selectOnCheck : false,
        singleSelect: true, //只允许选中一行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        rowStyler: function(index,row){
            if(index%2==1){
                return 'background-color:#FAFAFA;';
            } 
        },
        onClickRow: onClickRow,
        toolbar: '#tb'     
    }); 
    
    
    //表格编辑
    var editIndex = undefined;
	function endEditing() {
		if (editIndex == undefined) {
			return true
		}
		if ($('#MainGrid').datagrid('validateRow', editIndex)) {
			
			$('#MainGrid').datagrid('endEdit', editIndex);
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	
	function onClickRow(index) {
		    $('#MainGrid').datagrid('endEdit', editIndex);
			if (endEditing()) { 
				$('#MainGrid').datagrid('selectRow', index);
				$('#MainGrid').datagrid('beginEdit', index);
				editIndex = index;
			}else{
				$('#MainGrid').datagrid('selectRow', editIndex);
			}  
		
	}
	
	//查询函数
    var FindBtn= function()
    {
	    //alert('ok')
        var year    = $('#YMbox').combobox('getValue'); // 申请年度
        var ItemCode  = $('#CodeDatabox').combobox('getValue'); // 责任科室
        MainGridObj.load({
	        ClassName:"herp.budg.hisui.udata.BudgTravelCashCtrlem",
	        MethodName:"List",
	        hospid : hospid, 
	        Year : year, 
            ItemCode : ItemCode,
            Type: ""
       })
    }

    //点击查询按钮 
    $("#FindBn").click(FindBtn);
	
	//新增
    var AddBtn = function()
   {
	    if (endEditing()) {
			$('#MainGrid').datagrid('appendRow', {
				//IsLast: 0
			});
		editIndex = $('#MainGrid').datagrid('getRows').length - 1;
		$('#MainGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);	
		}		
    }
    
    //点击新增按钮
    $("#AddBn").click(AddBtn);
    
    
    //删除
    var DelBtn = function()
    {
	    	var grid = $('#MainGrid')
			if($('#MainGrid').datagrid("getSelections").length==0&&($('#MainGrid').datagrid("getChecked").length==0)){
				$.messager.popover({
				msg: '请选择所要删除的行！',
				timeout: 2000,
				type: 'alert',
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
					top: 0
				}
			});
		} else {
			del(grid, "herp.budg.hisui.udata.BudgTravelCashCtrlem", "Delete"); 
		}	
	};
    //点击删除按钮
    $("#DelBn").click(DelBtn);
    
    
    //保存 
    var saveOrder = function() {
        var rows = $('#MainGrid').datagrid("getSelections");
        var length=rows.length;
        if(length<1){
            $.messager.alert('提示','请先选中至少一行数据!','info');
            return false;
        }else{
            var indexs=$('#MainGrid').datagrid('getEditingRowIndexs')
            if(indexs.length>0){
                for(var i=0;i<indexs.length;i++){
                    $("#MainGrid").datagrid("endEdit", indexs[i]);
                }
            }
            for(var i=0; i<length; i++){
                var row = rows[i];
                rowid=row.rowid;
                CompDR=hospid;
                Year=row.Year;
                ItemCode=row.ItemCode;
                Type=row.Type
            	
            	
                if(rowid==null){
	                //alert('新增插入新的列！！！')
                    $.m({
                        ClassName:'herp.budg.hisui.udata.BudgTravelCashCtrlem',
                        MethodName:'InsertRec',
                        Year:Year,
                        CompDR:CompDR,
                        ItemCode:ItemCode,
                        //Type:"差旅费控制"
                        },
                        function(Data){
                            if(Data==0){
					             //$.messager.alert('提示','保存成功！','info');
					             $.messager.popover({
					            msg: '保存成功！',
					            type:'success',
					            style:{"position":"absolute","z-index":"9999",
		                        left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                        top:1}});
			                    $.messager.progress('close');
                                 $('#MainGrid').datagrid("reload");     
                            }else{
	                            
                                //$.messager.alert('提示','设置控制项重复，不能新增！','info');
                                $.messager.popover({
					            msg: '设置控制项重复，不能新增！',
					            type:'success',
					            style:{"position":"absolute","z-index":"9999",
		                        left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                        top:1}});
			                    $.messager.progress('close');
                            }
                        }
                    );
                }else{
	                //alert('更新编辑的列！！！')
                    $.m({
                        ClassName:'herp.budg.hisui.udata.BudgTravelCashCtrlem',
                        MethodName:'UpdateRec',
                        rowid:rowid,
                        Year:Year,
                        CompDR:CompDR,
                        ItemCode:ItemCode,
                        Type: Type
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
							      	  //$('#MainGrid').datagrid("reload");
							      	  editIndex = undefined;
							          }else{
								          $.messager.popover({
												msg: '保存失败'+SQLCODE,
												type:'error',
												style:{"position":"absolute","z-index":"9999",
												left:-document.body.scrollTop - document.documentElement.scrollTop/2,
												top:1}
												})
										   $.messager.progress('close');
										   $('#MainGrid').datagrid("reload"); 
								      
								      }
                        }
                    );
                }
            }
             //alert('新增插入新的列！！！直接加载表格')
            $('#MainGrid').datagrid("reload");       
        }        
    }
    //点击保存按钮 
    $("#SaveBn").click(saveOrder);
	
	}
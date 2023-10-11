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
        }
    });
    
    // 数据来源的下拉框
    var DataboxObj = $HUI.combobox("#Databox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=DataFrom",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.flag   = 1;
            param.str = param.q;
        },
          onChange:function(n,o){
	           if(n!=o){
		        $('#CodeDatabox').combobox('clear');

                $('#CodeDatabox').combobox('reload');
	           } 
	            
            } 
        
         
    });
    //各控制项编码下拉框
        var BCodeDataboxObj = $HUI.combobox("#CodeDatabox",{
	        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetU8Code",
	        mode:'remote',
	        delay:200,
	        valueField:'code',
	        textField:'name',
	        onBeforeLoad:function(param){
		        param.flag   = 1;
                param.sysno =$('#Databox').combobox('getValue') ;
				param.str = param.q;
            	
            	  
	        },
	        onShowPanel:function(){
            if($('#Databox').combobox('getValue')==""){
                $(this).combobox('hidePanel');
                $.messager.popover({msg: '请先选择系统！',type:'info'});
                return false;
            }
        }
        
        });
 	//是否按年控制
    $("#IsYBox").checkbox({
        onCheckChange:function(event,value){
        	FindBtn();   
        }
    })
    
     //是否按累计月控制
    $("#IsSMBox").checkbox({
        onCheckChange:function(event,value){
        	FindBtn();
        }
    })
    
     //是否按月控制
    $("#IsMBox").checkbox({
        onCheckChange:function(event,value){
        	FindBtn();
        }
    })
    
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
	                width:80,
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
	                field:'IsY',
	                title:'按年控制', 
	                width:100, 
	                align:'center',
	                formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}  
                    },
	                editor:{type:'checkbox',
	                options:{
		                on:'1',
		                off:'0'
		                }
	                
	                }
	                },
                {
	                field:'IsSM',
	                title:'按累计月控制', 
	                width:100, 
	                align:'center',
	                formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}  
                    },
	                editor:{type:'checkbox',options:{on:'1',off:'0'}}
	            },
                {
	                field:'IsM',
	                title:'按月控制',
	                width:100, 
	                align:'center',
	                formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}  
                    },
	                editor:{type:'checkbox',options:{on:'1',off:'0'}}},
                {
	                field:'SYSNo',
	                title:'各系统编码',
	                width:120,
	                editor:
	                {	                  
		                  type:'combobox',
		                  options:{
			                   url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=DataFrom",
                               mode:'remote',
                               delay:200,
                               valueField:'code',    
                               textField:'name',
                               onBeforeLoad:function(param){
                                            param.hospid = hospid;
                                            param.flag   = 1;
                                            param.str = param.q;
                                            },
                               onSelect:function(data){
	                               var value = data.code;
	                               var row = $('#MainGrid').datagrid('getSelected');
	                               var rowIndex = $('#MainGrid').datagrid('getRowIndex',row);
	                               var target = $('#MainGrid').datagrid('getEditor', {'index':rowIndex,'field':'Code'}).target;
	                               target.combobox('clear');
	                               var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetU8Code&sysno="+value; 
                                   target.combobox('reload', url); 
	                               
                               }
                              
			                  }
		                  }
		                
	                
                },
                {
	                field:'Code',
	                title:'各系统控制项编码',
	                width:180,
	                formatter:function(value,row){
						return row.Code;
					},
	                editor:{type:'combobox',
	                        options:{
		                       url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetU8Code",
                               mode:'remote',
                               delay:200,
                               valueField:'code',    
                               textField:'name',
                               onBeforeLoad:function(param){
                                            param.flag   = 1;
                                            param.str = param.q;
                                            var row = $('#MainGrid').datagrid('getSelected'); 
                                            param.code= row.SYSNo;
                                            }    
			               }
			               }
                }
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgCtrlMode",
            MethodName:"List",
            hospid :    hospid, 
            Year :      "",
            IsY :      "", 
            IsSM :      "", 
            IsM :      "", 
            SYSNo :      "", 
            Code :      ""
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        ctrlSelec:true, //在启用多行选择的时候允许使用Ctrl键+鼠标点击的方式进行多选操作
        checkOnSelect : true,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
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
        //function(index,field,value){   //在用户点击一个单元格的时候触发
            //if ((field=="IsY")||(field=="IsSM")||(field=="IsM")) {
	           //$('#MainGrid').datagrid('checkRow',index);
	           //$('#MainGrid').datagrid('selectRow', index);
	           
               //$('#MainGrid').datagrid('beginEdit', index); //索引为index的行开启编辑
            //}
        //},
        toolbar: '#tb'     
    }); 
    
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
        var SYSNo  = $('#Databox').combobox('getValue'); // 责任科室
        var Code   = $('#CodeDatabox').combobox('getValue');
        var IsY = $('#IsYBox').checkbox('getValue');
        	if(IsY == true){
	        	IsY=1;
	        }else{
		        IsY=0;
		    }
       var IsSM = $('#IsSMBox').checkbox('getValue');
        	if(IsSM == true){
	        	IsSM=1;
	        }else{
		        IsSM=0;
		    }
        var IsM = $('#IsMBox').checkbox('getValue');
        	if(IsM == true){
	        	IsM=1;
	        }else{
		        IsM=0;
		    }
		    
        //var Code   = $('#CodeDatabox').combobox('getValue');
        MainGridObj.load({
	        ClassName:"herp.budg.hisui.udata.uBudgCtrlMode",
	        MethodName:"List",
	        hospid :    hospid, 
	        Year :      year,
	        IsY :      	IsY, 
	        IsSM :      IsSM, 
           	IsM :      	IsM, 
            SYSNo :     SYSNo, 
            Code :      Code
       })
    }

    //点击查询按钮 
    $("#FindBn").click(FindBtn);
    //新增
    var AddBtn = function()
   {
	    if (endEditing()) {
			$('#MainGrid').datagrid('appendRow', {
				IsLast: 0
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
			               msg:'没有选中的记录！',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			 }else{
		        	del(grid, "herp.budg.hisui.udata.uBudgCtrlMode", "Delete");
		        	}
	
	};
	
    //点击删除按钮
    $("#DelBn").click(DelBtn);


    //保存 
    var saveOrder = function() {
        var rows = $('#MainGrid').datagrid("getSelections");
        var length=rows.length;
        //var str="",rowid="",StartDate="",EndDate="",DutyDeptDR="",Year=""
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
                Year=row.Year;
               	IsY=row.IsY;
	        	IsSM=row.IsSM;
           		IsM=row.IsM;
            	SYSNo=row.SYSNo;
            	Code=row.Code;
            	CompDR=hospid;
            	
              
            	if((!SYSNo)&&(!Year)&&(IsY=='0')&&(IsSM=='0')&&(IsM=='0'))
            	{
	            	var message = "请添加控制信息!";
                    $.messager.alert('提示',message,'info');
                    return false;
            	}else if(!Year)
            	{
	            	var message = "年度不能为空!";
                    $.messager.alert('提示',message,'info');
                    return false;
	            	
            	}else if ((IsY=='0')&&(IsSM=='0')&&(IsM=='0')){
	            	var message = "控制方式不能为空!";
                    $.messager.alert('提示',message,'info');
                    return false;
            	}else if(!SYSNo)
            	{
            	    var message = "系统不能为空!";
                    $.messager.alert('提示',message,'info');
                    return false;
	            	
            	} 
            	
               
                if(rowid==null){
	                 
	                
	                //alert('新增插入新的列！！！')
                    $.m({
                        ClassName:'herp.budg.hisui.udata.uBudgCtrlMode',
                        MethodName:'InsertRec',
                        Year:Year,
                        CompDR:CompDR,
                        IsY:IsY,
                        IsSM:IsSM,
                        IsM:IsM,
                        SYSNo:SYSNo,
                        Code:Code
                        },
                        function(Data){
                            if(Data==0){
					             $.messager.alert('提示','保存成功！','info');
                                 $('#MainGrid').datagrid("reload");     
                            }else{
	                            
                                $.messager.alert('提示','设置控制项重复，不能新增！','info');
                            }
                        }
                    );
                }else{
	                //alert('更新编辑的列！！！')
                    $.m({
                        ClassName:'herp.budg.hisui.udata.uBudgCtrlMode',
                        MethodName:'UpdateRec',
                        rowid:rowid,
                        Year:Year,
                        CompDR:CompDR,
                        IsY:IsY,
                        IsSM:IsSM,
                        IsM:IsM,
                        SYSNo:SYSNo,
                        Code:Code
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
	
	var width1=500;
	var height1=350;
    /**批量设置截止时间  开始**/
    var SetFun=function() {
        var $win;
        $win = $('#BtchWin').window({
            title: '设置各系统控制模式',
            width: width1,
            height: height1,
            top: ($(window).height() - height1) * 0.5,
            left: ($(window).width() - width1) * 0.5,
            shadow: true,
            modal: true,
            iconCls: 'icon-save',
            closed: true,
            minimizable: false,
            maximizable: false,
            collapsible: false,
            resizable: true,
            onClose:function(){ //关闭关闭窗口后触发
                $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
            }
        });
        $win.window('open');
        // 年度的下拉框
        var BYMboxObj = $HUI.combobox("#BYMbox",{
            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
            mode:'remote',
            delay:200,
            valueField:'year',    
            textField:'year',
            value: new Date().getFullYear(),
            onBeforeLoad:function(param){
                param.str = param.q;
            }
        });
        // xitong的下拉框
        var BDataboxObj = $HUI.combobox("#BDatabox",{
            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=DataFrom",
            mode:'remote',
            delay:200,
            valueField:'code',    
            textField:'name',
            onBeforeLoad:function(param){
                param.hospid = hospid;
            	param.flag   = 1;
            	param.str = param.q;
            },
            onChange:function(n,o){
	           if(n!=o){
		        $('#BCodeDatabox').combobox('clear');

                $('#BCodeDatabox').combobox('reload');
	           } 
	            
            } 
             
            
              
        });
        //各控制项编码下拉框
        var BCodeDataboxObj = $HUI.combobox("#BCodeDatabox",{
	        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetU8Code",
	        mode:'remote',
	        delay:200,
	        valueField:'code',
	        textField:'name',
	        onBeforeLoad:function(param){
		        param.flag   = 1;
                //param.sysno= row.SYSNo;
                param.sysno = $('#BDatabox').combobox('getValue');
            	param.str = param.q;
            	  
	        },
	        onShowPanel:function(){
            if($('#BDatabox').combobox('getValue')==""){
                $(this).combobox('hidePanel');
                $.messager.popover({msg: '请先选择系统！',type:'info'});
                return false;
            }
        }
        
        });
         

        //批量设置 
        $("#BtchSave").unbind('click').click(function(){
            
           	var Year    = $('#BYMbox').combobox('getValue'); // 申请年度
        	var SYSNo  = $('#BDatabox').combobox('getValue'); // XITONG
        	
        	//var Code = $('#BCodeField').val(); 
        	var IsY = $('#BIsYBox').checkbox('getValue');
        	if(IsY == true){
	        	IsY=1;
	        }else{
		        IsY=0;
		    }
       		var IsSM = $('#BIsSMBox').checkbox('getValue');
        	if(IsSM == true){
	        	IsSM=1;
	        }else{
		        IsSM=0;
		    }
        	var IsM = $('#BIsMBox').checkbox('getValue');
        	if(IsM == true){
	        	IsM=1;
	        }else{
		        IsM=0;
		    }
		    var Code = $('#BCodeDatabox').combobox('getValue');
       		//var Code = $('#BCodeField').val();
            if (!SYSNo) {
                var message = "系统不能为空!";
                $.messager.alert('提示',message,'info');
               return false;
            }
            
            $.m({
                ClassName:'herp.budg.hisui.udata.uBudgCtrlMode',MethodName:'Batch',
                CompDR:hospid, 
                Year:Year, 
                IsY:IsY, 
                IsSM:IsSM, 
                IsM:IsM, 
                SYSNo:SYSNo, 
                Code:Code
                },
                function(Data){
                    if(Data==0){
                        $.messager.alert('提示','设置成功！','info');
                    }else{
                        $.messager.alert('提示','错误信息:' +Data,'error');
                    }
                }
            );
            $win.window('close');
        });
        //取消 
        $("#BtchClose").unbind('click').click(function(){
            $win.window('close');
        });

    }
    $("#BatchBn").click(SetFun);   
    /**批量设置  结束**/


}
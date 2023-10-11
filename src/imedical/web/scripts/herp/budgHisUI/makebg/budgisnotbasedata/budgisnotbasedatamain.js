/**
Creator:Liu XiangSong
CreatDate:2018-08-25
Description:全面预算管理-预算编制准备-参考执行数据剔除
CSPName:herp.budg.hisui.budgisnotbasedata.csp
ClassName:herp.budg.hisui.udata.uBudgIsNotBaseData,
herp.budg.udata.uBudgIsNotBaseData
**/
var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];

$(function(){//初始化
    Init();
}); 

function Init(){
        
	//年月
    var DYMBoxObj = $HUI.combobox("#DYMBox",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgIsNotBaseData&MethodName=YearOrYearMon",
        mode:'remote',
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.flag = 1;
            param.str = param.q;
        },
        onChange:function(n,o){
            if(n!=o){
                //$('#DItemBox').combobox('clear');
                //$('#DItemBox').combobox('reload'); 
                $('#DDeptBox').combobox('clear');
                $('#DDeptBox').combobox('reload');
            }
        }
    });
    //科室
    var DDeptObj = $HUI.combobox("#DDeptBox",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgIsNotBaseData&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.YearMon= $('#DYMBox').combobox('getValue');
            param.str    = param.q;
        },
        onShowPanel:function(){
            if($('#DYMBox').combobox('getValue')==""){
                $(this).combobox('hidePanel');
                $.messager.popover({msg: '请先选择年月！',type:'info'});
                return false;
            }
        }
    });
    //科目分类
    var DItemTypeObj = $HUI.combobox("#DItemType",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.flag = 1;
            param.str = param.q;
        }
    });
    //科目
    var DItemBoxObj = $HUI.combobox("#DItemBox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItemForIsNotBaseData",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.str = param.q;
            param.yearmonth = $('#DYMBox').combobox('getValue');
	        param.deptdr = $('#DDeptBox').combobox('getValue');
	        param.typecode = $('#DItemType').combobox('getValue');
           
        }
    });
    DetailColumns=[[  
                {field:'ckbox',checkbox:true},//复选框
                {
	                field:'rowid',
	                title:'ID',
	                width:80,
	                hidden: true
                },
                {
	                field:'bfrmId',
                	title:'月执行汇总表ID',
                	width:80,
                	hidden: true,
                	allowBlank:false
                },
                {
	                field:'CompName',
	                title:'医疗单位',
	                width:100,
	                hidden: true,
	                allowBlank:true
                },
                {
	                field:'yearmonth',
	                title:'年月',
	                width:140,
	                allowBlank:false
                },
                {
	                field:'bdeptname',
	                title:'科室名称',
	                width:200,
	                allowBlank:false
                },
                {
	                field:'itemcode',
	                title:'预算项编码',
	                width:200,
	                allowBlank:false
                },
                {
	                field:'itemname',
	                title:'预算项名称',
	                width:200,
	                allowBlank:false,
					editor:{
						type:'combobox',
						options:{
							valueField:'code',
							textField:'name1',
							url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItemForIsNotBaseData",
							delay:200,
							required:true,
                    		onBeforeLoad:function(param){
	                    		param.hospid = hospid;
	                    		param.str = param.q;
	                    		param.yearmonth = $('#DYMBox').combobox('getValue');
	                    		param.deptdr = $('#DDeptBox').combobox('getValue');
	                    		param.typecode = $('#DItemType').combobox('getValue');
	                    	},
        					onSelect:function(data){
	        					var row = $('#MainGrid').datagrid('getSelected');  
                                var rowIndex = $('#MainGrid').datagrid('getRowIndex',row);//获取行号  
        						exefun(data.code,$('#DYMBox').combobox('getValue'),$('#DDeptBox').combobox('getValue'),$('#DItemType').combobox('getValue'),rowIndex);
        					}
                    	}
					}
                },
                {
	                field:'rejmoney',
	                title:'剔除金额',
	                width:200,
	                align:'right',
	                formatter:dataFormat,
                    editor: { 
                    	type: 'numberbox', 
                    	options: { 
                    		precision:2
                    	} 
                    },allowBlank:false
                },
                {
	                field:'rejreason',
	                title:'剔除原因',
	                width:200,
	                editor: { 
	                	type: 'text'
	                }
                }
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgIsNotBaseData",
            MethodName:"List",
            hospid :    hospid, 
            yearmonth:  "",
            deptdr :    "",
            typecode:   "",
            itemcode:   ""            
        },
        delay:200,
        fitColumns: true,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        singleSelect: true,
        rownumbers:true,//行号
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:DetailColumns,
        onClickRow:onClickRow,
        onClickCell: function(index,field,value){
        	$('#MainGrid').datagrid('beginEdit', index);
        },
        toolbar: '#dtb'            
    });  
    
    var editIndex=undefined;
      
    // 查询函数
    var DFindBtn= function()
    {
        var DYearMonth = $('#DYMBox').combobox('getValue'); // 年月
        var DDeptDR  = $('#DDeptBox').combobox('getValue'); // 方案类别
        var DItemType= $('#DItemType').combobox('getValue');// 科目类别
        var DItemCode= $('#DItemBox').combobox('getValue'); // 科目
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgIsNotBaseData",
                MethodName:"List",
                hospid :    hospid, 
                yearmonth:  DYearMonth,
                deptdr :    DDeptDR,
                typecode:   DItemType,
                itemcode:   DItemCode  
            })
    }

    // 点击查询按钮 
    $("#DFindBn").click(DFindBtn);
    
    function add(){
			if (endEditing()){
				$('#MainGrid').datagrid('appendRow',{});
				editIndex = $('#MainGrid').datagrid('getRows').length-1;
				$('#MainGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
				
			}
		}
	    function endEditing(){
			if (editIndex == undefined){return true}
			//alert($('#MainGrid').datagrid('validateRow', editIndex));
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
					$('#MainGrid').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#MainGrid').datagrid('selectRow', editIndex);
				}
			}
		};
    //增加一行
    $("#AddBn").click(function(row){
    	add()
    });

    $("#SaveBn").click(function(){
	    $('#MainGrid').datagrid('endEdit', editIndex);
		var row = $('#MainGrid').datagrid('getSelected');
		var index = $('#MainGrid').datagrid('getRowIndex',row);
		$('#MainGrid').datagrid('endEdit',index);
		if(row!=null){
			if (saveAllowBlankVaild($('#MainGrid'),row) == true) {
                saveOrder(); //保存方法
            }else {
                return;
        	}
        }
	});
	            
    //保存 
    var saveOrder=function() {
	    var row = $('#MainGrid').datagrid('getSelected');
    	$.messager.confirm('确定','确定要保存选定的数据吗？',function(t){
            if(t){
		        if(!row.rowid){
		            $.m({
		                ClassName:'herp.budg.udata.uBudgIsNotBaseData',
		                MethodName:'InsertRec',
		                hospid:hospid,
		                yearmonth:row.yearmonth,
		                bfrmId:row.bfrmId,
		                fee:row.rejmoney,
		                desc:row.rejreason
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

		                        }else{
		                            $.messager.popover({
			                            msg: '保存失败！'+SQLCODE,
			                            type:'error',
						                style:{"position":"absolute","z-index":"9999",
						                      left:-document.body.scrollTop - document.documentElement.scrollTop/2,
						                      top:1}})}
		                    }
		            );
		        }else{
		            $.m({
		                ClassName:'herp.budg.udata.uBudgIsNotBaseData',
		                MethodName:'UpdateRec',
		                rowid:row.rowid,
		                fee:row.rejmoney,
		                desc:row.rejreason},
		                    function(SQLCODE){
		                        if(SQLCODE==0){
			                        $.messager.popover({
				                        msg: '保存成功！',
				        	            type:'success',
				        	            style:{"position":"absolute","z-index":"9999",
				        	                   left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				        	                   top:1}});
				        	        $.messager.progress('close');
		                        }else{
		                           $.messager.popover({
			                            msg: '保存失败！'+SQLCODE,
			                            type:'error',
						                style:{"position":"absolute","z-index":"9999",
						                      left:-document.body.scrollTop - document.documentElement.scrollTop/2,
						                      top:1}})}
		                        }
		                    
		            );
		        }
		        $("#MainGrid").datagrid("reload");
    		}
		})
    }
    // 点击删除按钮 
    $("#DelBn").click(function(){
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
		        	 	var classname = "herp.budg.udata.uBudgIsNotBaseData";
    					var methodname = "Delete";
        				del($("#MainGrid"),classname,methodname)
		        	 }
    }); 

}
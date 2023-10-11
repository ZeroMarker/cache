/*
* @Author: 基础数据平台-杨帆
* @Date:   2020-12-25
* @描述:群组通讯录授权
*/

var HCCSCLRowId=""

var init=function()
{
	
	//多院区下拉框
	var hospComp = GenHospComp("CT_HCCSEquipment");
	hospComp.jdata.options.onSelect = function(e){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		contactRefreshFun();
	}
	
	//个人通讯录
    var hiscolumns =[[
	  {field:'HCCSCLRowId',title:'HCCSCLRowId',width:100,sortable:true,hidden:true},
	  {field:'HCCSCLUserCode',title:'用户代码',width:100,sortable:true},
	  {field:'HCCSCLUserDesc',title:'用户名称',width:100,sortable:true},
	  {field:'HCCSCLLoc',title:'科室',width:150,sortable:true},

    ]];
    var contactgrid = $HUI.datagrid("#contactgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.CTHCCSContactList",
            QueryName:"GetDataForCmb1",
			'hospid':hospComp.getValue()    ///多院区医院
        },
        columns: hiscolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        idField:'HCCSCLRowId',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		onClickRow:function(rowIndex,rowData){
			LinkScenesFun();
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }	
    });
	
    //搜索
    $('#contactsearch').click(function(e){
        Searchcontact();
    });
    //搜索回车事件
    $('#contactDesc').keyup(function(event){
        if(event.keyCode == 13) {
          Searchcontact();
        }
    });
    //搜索方法
    Searchcontact=function()
    {
		//var contactDesc=$("#contactDesc").combobox('getValue');
		var contactDesc=$('#contactDesc').val();
		var HospID=hospComp.getValue();
        $('#contactgrid').datagrid('reload',  {
                ClassName:"web.DHCBL.CT.CTHCCSContactList",
                QueryName:"GetDataForCmb1",
                'desc':contactDesc,
				'hospid':HospID
        });
		$('#contactgrid').datagrid('unselectAll');
		LinkScenesFun() //右侧群组重置
    }    
    //重置
    $('#contactRefresh').click(function(e){
    	contactRefreshFun();
    });
	//重置事件
    $('#contactDesc').keyup(function(event){
        if(event.keyCode == 27) {
          contactRefreshFun();
        }
    });    
    //重置方法
    contactRefreshFun=function()
    {
        //$("#contactDesc").combobox('contactValue','');
		$('#contactDesc').val("");
		var HospID=hospComp.getValue();
    	$('#contactgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.CT.CTHCCSContactList",
            	QueryName:"GetDataForCmb1",
				'hospid':HospID
    	});
		$('#contactgrid').datagrid('unselectAll');
		LinkScenesFun() //右侧群组重置
		
    }   
	
	
	/****************************群组个人通讯录授权部分**2020-12-24***************************/
	
	var TREE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHCCSPreferences&pClassMethod=GetJsonDataForTree";
	var changestr=""  //右侧列表是否勾选的变化串
	
	//检索框
	$("#myChecktreeUserDesc").keyup(function(){ 
		var str = $("#myChecktreeUserDesc").val(); 
		findByRadioCheck("myChecktree",str,$("input[name='FilterCK']:checked").val())
		
	})
	///全部、已选、未选
	$HUI.radio("#myGroup [name='FilterCK']",{
        onChecked:function(e,value){
        	findByRadioCheck("myChecktree",$("#myChecktreeUserDesc").val(),$(e.target).attr("value"))
       }
    });
    
	//点击保存按钮(群组个人通讯录授权)
    $('#saveButton').click(function(e)
    {
        savedata();
	});
	
	//保存方法（群组个人通讯录授权）
	savedata=function() {
		var record = $("#contactgrid").datagrid("getSelected"); 
		if(!record)
		{
			$.messager.alert('提示',"未选中要保存的个人通讯录数据!","info");						
			return false;
		}
		
		var HCCSCLRowId=record.HCCSCLRowId;
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				var rs=tkMakeServerCall("web.DHCBL.CT.CTHCCSPreferences","SavePreferences",HCCSCLRowId,changestr,"G");						  
				if (rs=="true") 
				{
					$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
					$('#myChecktree').tree('reload');  // 重新载入当前页面数据	
					changestr=""
				}
				else
				{
					$.messager.alert('操作提示',"保存失败","error");
				}
				
			}
		})

	}
	
	//右侧树形群组重置
	LinkScenesFun=function ()
	{
		var record = $("#contactgrid").datagrid("getSelected"); 
		HCCSCLRowId=""
		if(record)
		{
			HCCSCLRowId=record.HCCSCLRowId;
		}
		
		//var titleCompany=record.ASRSScenesCommandName;
		$("#myChecktree").tree("reload");  //窗口每次打开时，数据重新加载
		$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部
		$("#myChecktreeUserDesc").val("")
		changestr=""
	}
	
	///定义树
	var myChecktree = $HUI.tree("#myChecktree",{
		url:TREE_QUERY_ACTION_URL,
		idField: 'id',
		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		checkbox:true,
		cascadeCheck:true,  //是否级联检查。默认true  菜单特殊，不级联操作
		animate:false,     //是否树展开折叠的动画效果
		onCheck:function(node,checked)
		{
			if(node.GroupLinkContListFlag==true)
			{
				$.messager.alert('提示',"该用户属于当前群组，不能取消勾选!","info");
			}
			//记录勾选、取消勾选变化的数据
			if(node)
			{
				var id ="A"+node.id+"A"
				if (changestr.indexOf(id)==-1)
				{
					if (changestr!="")
					{
						changestr=changestr+"^"
					}
					changestr=changestr+id
				}
				else
				{
					changestr=changestr.replace(id,"")	
				}
			}	
		},
		onClick: function(node){
			if(node.GroupLinkContListFlag==true)
			{
				$.messager.alert('提示',"该用户属于当前群组，不能取消勾选!","info");
			} // 在用户点击的时候提示
		},	
		onBeforeExpand:function(node){
			//2018-11-30展开一个节点，展开下面第一级子节点，而不是只符合查询条件的数据。 
			$(this).tree('expandFirstChildNodes',node)
        },
		onBeforeLoad:function(node,param){
			param.contactlistid=HCCSCLRowId
			param.hospid=hospComp.getValue() 
		},
		onLoadSuccess:function(node, data){
			if (data) {
                $.each(data, function (index, item) {
                    if (item.GroupLinkContListFlag == true) {
						var node = $("#myChecktree").tree('find',item.id);
						$('#myChecktree').tree('disableCheck', node.target);// 禁用   
                    }
                });
			}

		}

	});
	/****************************群组个人通讯录授权部分完*****************************/
	/**
 * tree方法扩展
 * 作者:小雪转中雪
 */
$.extend($.fn.tree.methods, {
    /**
     * 激活复选框
     * @param {Object} jq
     * @param {Object} target
     */
    enableCheck : function(jq, target) {
        return jq.each(function(){
            var realTarget;
            if(typeof target == "string" || typeof target == "number"){
                realTarget = $(this).tree("find",target).target;
            }else{
                realTarget = target;
            }
            var ckSpan = $(realTarget).find(">span.tree-checkbox");
            if(ckSpan.hasClass('tree-checkbox-disabled0')){
                ckSpan.removeClass('tree-checkbox-disabled0');
            }else if(ckSpan.hasClass('tree-checkbox-disabled1')){
                ckSpan.removeClass('tree-checkbox-disabled1');
            }else if(ckSpan.hasClass('tree-checkbox-disabled2')){
                ckSpan.removeClass('tree-checkbox-disabled2');
            }
        });
    },
    /**
     * 禁用复选框
     * @param {Object} jq
     * @param {Object} target
     */
    disableCheck : function(jq, target) {
        return jq.each(function() {
            var realTarget;
            var that = this;
            var state = $.data(this,'tree');
            var opts = state.options;
            if(typeof target == "string" || typeof target == "number"){
                realTarget = $(this).tree("find",target).target;
            }else{
                realTarget = target;
            }
            var ckSpan = $(realTarget).find(">span.tree-checkbox");
            ckSpan.removeClass("tree-checkbox-disabled0").removeClass("tree-checkbox-disabled1").removeClass("tree-checkbox-disabled2");
            if(ckSpan.hasClass('tree-checkbox0')){
                ckSpan.addClass('tree-checkbox-disabled0');
            }else if(ckSpan.hasClass('tree-checkbox1')){
                ckSpan.addClass('tree-checkbox-disabled1');
            }else{
                ckSpan.addClass('tree-checkbox-disabled2')
            }
            if(!state.resetClick){
                $(this).unbind('click').bind('click', function(e) {
                    var tt = $(e.target);
                    var node = tt.closest('div.tree-node');
                    if (!node.length){return;}
                    if (tt.hasClass('tree-hit')){
                        $(this).tree("toggle",node[0]);
                        return false;
                    } else if (tt.hasClass('tree-checkbox')){
                        if(tt.hasClass('tree-checkbox-disabled0') || tt.hasClass('tree-checkbox-disabled1') || tt.hasClass('tree-checkbox-disabled2')){
                            $(this).tree("select",node[0]);
                        }else{
                            if(tt.hasClass('tree-checkbox1')){
                                $(this).tree('uncheck',node[0]);
                            }else{
                                $(this).tree('check',node[0]);
                            }
                            return false;
                        }
                    } else {
                        $(this).tree("select",node[0]);
                        opts.onClick.call(this, $(this).tree("getNode",node[0]));
                    }
                    e.stopPropagation();
                });
            }

        });
    }
});   
}
$(init);
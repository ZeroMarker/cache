/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-08-15 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-11-05 09:56:29
* @描述:诊断逻辑推导目录
*/
var TREE_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseTree&pClassMethod=GetNewTreeComboJson";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseTree&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDiseaseTree";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseTree&pClassMethod=DeleteData";
var SAVE_ACTION_URL_LinkLabel = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseLinkLabel&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDiseaseLinkLabel";
var DELETE_ACTION_URL_LinkLabel = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseLinkLabel&pClassMethod=DeleteData";
var SAVE_ACTION_URL_LabelItm = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLabelItm&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDisLabelItm";
var DELETE_ACTION_URL_LabelItm = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLabelItm&pClassMethod=DeleteData";
var init=function()
{
	var parrefDesc="";
	var parref="";
	var labeldr="";
	itmMethod(parref,parrefDesc,labeldr);	
	comMethod(parrefDesc,labeldr);
	//上级分类下拉框
	var lastLevelTree = $HUI.combotree('#PDTLastRowid',{
		url:TREE_COMBO_URL
		//multiple:true,
        //cascadeCheck:false
	});
    /*******************************************左侧列表增删改*********************************************/
    //点击添加按钮
    $('#add_btn').click(function(e){
        AddData();
    });
    //点击修改按钮
    $('#update_btn').click(function(){
        updateData();
    });
    //点击删除按钮
    $('#del_btn').click(function(e){
        delData();
    });
    //点击搜索按钮
    $('#diaSearch').click(function(e){
       	SearchDia();
    });	
    //搜索回车事件
	$('#TextDia').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchDia();
		}
	});    
    //搜索方法
    SearchDia=function()
    {
    	var	desc=$('#TextDia').val();
		$("#diagrid").treegrid("search", desc);
        $('#diagrid').treegrid('unselectAll');
        $('#listgrid').datagrid('reload',  { 
            ClassName:"web.DHCBL.KB.DHCPHDiseaseLinkLabel",
            QueryName:"GetList",
            treeid:"-1"
        });  

        $('#itmgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHDisLabelItm",
            QueryName:"GetList",
            pdliid:-1
        });	        
        itmMethod("","","");   	
    }    
    //点击重置按钮
    $('#diaRefresh').click(function(e){
		clearFunLib();	
    });
    clearFunLib=function()
    {
    	$("#TextDia").val('');//清空检索框
		$('#diagrid').treegrid('load',  { 
		'id':''	
		});
		$('#diagrid').treegrid('unselectAll');
        $('#listgrid').datagrid('reload',  { 
            ClassName:"web.DHCBL.KB.DHCPHDiseaseLinkLabel",
            QueryName:"GetList",
            treeid:"-1"
        });	

        $('#itmgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHDisLabelItm",
            QueryName:"GetList",
            pdliid:-1
        });	        
        itmMethod("","","");
    }    
	///删除
    delData=function()
	{                  
		//更新
		var row = $("#diagrid").treegrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.id;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{"id":rowid},  
					type:"POST",   
					//dataType:"TEXT",  
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
								/*$.messager.show({ 
								  title: '提示消息', 
								  msg: '删除成功', 
								  showType: 'show', 
								  timeout: 1000, 
								  style: { 
									right: '', 
									bottom: ''
								  } 
								}); */
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								 $('#diagrid').treegrid('reload');  // 重新载入当前页面数据 
								 $('#diagrid').datagrid('unselectAll');  // 清空列表选中数据 
							  } 
							  else { 
								var errorMsg ="删除失败！"
								if (data.info) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.info
								}
								 $.messager.alert('操作提示',errorMsg,"error");
					
							}			
					}  
				})
			}
		});
	} 
	/*$('#helpbtn').click(function(){

	});*/  
	//点击修改按钮
    updateData=function() {
		var record = diagrid.getSelected(); 
		if (record){			
			 //调用后台openData方法给表单赋值
			var id = record.id;
			$.cm({
				ClassName:"web.DHCBL.KB.DHCPHDiseaseTree",
				MethodName:"NewOpenData",
				id:id
			},function(jsonData){
				//给是否可用单独赋值				
				if (jsonData.PDTActiveFlag=="Y"){
					$HUI.checkbox("#PDTActiveFlag").setValue(true);		
				}else{
					$HUI.checkbox("#PDTActiveFlag").setValue(false);
				}
				if (jsonData.PDTSysFlag=="Y"){
					$HUI.checkbox("#PDTSysFlag").setValue(true);		
				}else{
					$HUI.checkbox("#PDTSysFlag").setValue(false);
				}				
				$('#form-save').form("load",jsonData);	
			});
			$("#myWin").show(); 
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					id:'save_btn',
					handler:function(){SaveFunLib(id,1)}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}]
			});				
			
		}else{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
		}
	}    
	 //点击新增按钮,添加添加下级
	AddData=function () {
		var record = diagrid.getSelected(); 
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					SaveFunLib("",1)
				}
			},
			{
				text:'继续新增',
				id:'save_btnagain',
				handler:function(){
					SaveFunLib("",2)
				}
			},
			{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		$('#form-save').form("clear");
        var codeTex=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","GetLastCode");
        $("#PDTCode").val(codeTex);		
		$('#PDTLevel').val(1);
		//点击某行添加新数据时，默认选择该行为上级
		if(record){
			var per=record.id;
			$('#PDTLastRowid').combotree('reload',TREE_COMBO_URL);
			$('#PDTLastRowid').combotree('setValue',per);
		}
		$HUI.checkbox("#PDTActiveFlag").setValue(true);
		$HUI.checkbox("#PDTSysFlag").setValue(true);			
	}
	
	//点击添加本级按钮
    AddDataB=function(){
		var record = diagrid.getSelected(); 
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-addlittle',
			resizable:true,
			title:'添加',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					SaveFunLib("",1)
				}
			},
			{
				text:'继续新增',
				id:'save_btnagain',
				handler:function(){
					SaveFunLibT("",2)
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		$('#form-save').form("clear");
        var codeTex=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","GetLastCode");
        $("#PDTCode").val(codeTex);			
		$('#PDTLevel').val(1);
		//点击某行添加新数据时，默认选择该行为同级
		if(record){
			var per=record.id;
			var LastLevel = tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","GetLastLevel",per);
			var LastId = LastLevel.split("^")[0];
			$('#PDTLastRowid').combotree('reload',TREE_COMBO_URL);
			$('#PDTLastRowid').combotree('setValue',LastId);
		}
		$HUI.checkbox("#PDTActiveFlag").setValue(true);
		$HUI.checkbox("#PDTSysFlag").setValue(true);			
	}  
	///新增、更新
    SaveFunLib=function(id,flagT)
	{            
						
		var code=$.trim($("#PDTCode").val());
		var desc=$.trim($("#PDTDesc").val());		
		if (code=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"error");
			return;
		}
		if (desc=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"error");
			return;
		}
		///上级分类
		if ($('#PDTLastRowid').combotree('getText')=='')
		{
			$('#PDTLastRowid').combotree('setValue','')
		}
		if(id!="")
		{
			//在修改添加时判断选中的上级是不是本身或者自己的下级
			var comboId=$('#PDTLastRowid').combotree('getValue');
			if(justFlag(comboId,id,"diagrid"))
			{
				return;				
			}
			
		}
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			onSubmit: function(param){
				param.PDTRowId = id;
			},
			success: function (data) { 
			  var data=eval('('+data+')'); 
			  if (data.success == 'true') {
				/*$.messager.show({ 
				  title: '提示消息', 
				  msg: '提交成功', 
				  showType: 'show', 
				  timeout: 1000, 
				  style: { 
					right: '', 
					bottom: ''
				  } 
				});*/
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000}); 
				$('#diagrid').treegrid('reload');  // 重新载入当前页面数据 
	            if(flagT==1)
	            {
	                //alert(flagT)
	                $('#myWin').dialog('close'); // close a dialog
	            }
	            else
	            {
	                $('#form-save').form("clear");
			        var codeTex=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","GetLastCode");
			        $("#PDTCode").val(codeTex);		
					$('#PDTLevel').val(1);	                
	                //默认选中
	                $HUI.checkbox("#PDTActiveFlag").setValue(true);
	                $HUI.checkbox("#PDTSysFlag").setValue(true);                
	            }
			  } 
			  else { 
				var errorMsg ="更新失败！"
				if (data.errorinfo) {
					errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
				}
			 $.messager.alert('操作提示',errorMsg,"error");

		}

		} 
	  }); 
	}	    
    /******************************************增删改结束*************************************************/
    /*******************************************配置开始**************************************************/
    //点击配置按钮
    $("#configure_btn").click(function(e){
        openConfigure();
    }); 
    //配置多选框的触发事件
    $HUI.checkbox('#AutoCode',{
        onChecked:function(e,value)
        {
            //alert("选中啦")
            $('#StartCode').attr("disabled",true);
            $('#CodeLen').attr("disabled",true);
        },
        onUnchecked:function(e,value)
        {
            //alert("去掉啦")
            $('#StartCode').attr("disabled",false);
            $('#CodeLen').attr("disabled",false);
        }
    });
    openConfigure=function()
    {
        var AutoCode=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","ShowAutoCode","AutoCode");
        var CodeLen=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","ShowAutoCode","CodeLen");
        var StartCode=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","ShowAutoCode","StartCode"); 
        if(AutoCode=="true"){
            $('#StartCode').val('');
            $('#CodeLen').val('');
            $HUI.checkbox('#AutoCode').setValue(true);
            $('#StartCode').attr("disabled",true);
            $('#CodeLen').attr("disabled",true);            
        }else{
            $HUI.checkbox('#AutoCode').setValue(false);
            $('#StartCode').val(StartCode);
            $('#CodeLen').val(CodeLen);             
        }           
        $("#conWin").show();
        var conWin = $HUI.dialog("#conWin",{
            resizable:true,
            title:'代码生成规则',
            iconCls:'icon-w-batch-cfg',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存',
                id:'saveCon_btn',
                handler:function(){
                    saveConfigure()
                }
            },{
                text:'关闭',
                handler:function(){
                    conWin.close();
                }
            }]
        });   
    } 
    saveConfigure=function()
    {
        var configureFlag=$('#AutoCode').checkbox('getValue');
        if(configureFlag)
        {
            var StartCodeS="";
            var CodeLenS="";
            var AutoCodeS="true"
        }
        else
        {
            //未选中
           var StartCodeS=$('#StartCode').val();
           var CodeLenS=$('#CodeLen').val();
           var AutoCodeS=""
           var regex=/^[a-zA-Z]+$/;
           if (!StartCodeS.match(regex))
           {
                $.messager.alert('错误提示','代码起始字符必须为英文字母!',"error");
                return;  
           }
           if(StartCodeS=="")
           {
                $.messager.alert('错误提示','代码起始字符不能为空!',"error");
                return;            
           }
           if(CodeLenS=="")
           {
                $.messager.alert('错误提示','代码长度不能为空!',"error");
                return;            
           }           
        }
        //alert(AutoCodeS+"^"+CodeLenS+"^"+StartCodeS)
        var saveflag =tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","SaveAutoCode",AutoCodeS,CodeLenS,StartCodeS);
        if(saveflag==1)
        {
            $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});           
            $('#StartCode').val('');
            $('#CodeLen').val('');            
            $('#conWin').dialog('close');
        }
        else if (saveflag==2 && StartCodeS!="" & CodeLenS!="")
        {
            alert("代码起始字符的长度要小于代码长度");
        } 
        else
        {
            $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
            $('#conWin').dialog('close');
        }      
    }         
    /*******************************************配置jieshu**************************************************/
 	//弹窗按钮
    $('#prompt_btn').click(function(e){
        promptLink();
    }); 
    promptLink=function()
    {
        var record = diagrid.getSelected(); 
        if(record)
        {
            var resutText=record.text;
            $('#promptWin').show();
            var resultWin = $HUI.dialog("#promptWin",{
                iconCls:'icon-textbook',
                resizable:true,
                title:"推导目录提示表-"+resutText,
                modal:true
            }); 
        var parref=record.id;   
        var parrefDesc=record.text;                
        var url="../csp/dhc.bdp.kb.dhcphdislabelprompt.csp"+"?parref="+parref+"&parrefDesc="+parrefDesc;
	    //token改造 GXP 20230209
		if('undefined'!==typeof websys_getMWToken)
		{
			url+="&MWToken="+websys_getMWToken()
		}	        
        $('#prompt_iframe').attr("src",url);
        }
        else
        {
            $.messager.alert('错误提示','请先选择一条记录!',"error");           
        }       
    }    
    //树形表格
    var TREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseTree&pClassMethod=GetNewTreeJson";
    var diaclumns=[[
        {field:'id',title:'id',sortable:true,width:100,hidden:true},
        {field:'text',title:'',sortable:true,width:100}
    ]];
    var diagrid = $HUI.treegrid("#diagrid",{
        url:TREE_ACTION_URL,
		columns: diaclumns,  //列信息
		height:$(window).height()-105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
        idField:'id',
        showHeader:false,
        ClassName: "web.DHCBL.KB.DHCPHDiseaseTree", //拖拽方法DragNode 存在的类
        SQLTableName:'DHC_PHDiseaseTree',
        ClassTableName:'User.DHCPHDiseaseTree',
        DragMethodName:"DragNode",
        treeField:'text',
		autoSizeColumn:false,
		lines:true,
		animate:false,     //是否树展开折叠的动画效果
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
        onDblClickRow:function(){

        },
        onLoadSuccess:function(data){
            $(this).treegrid('enableDnd', data?data.id:null);//为treegrid同级拖拽引用的插件enableDnd,允许拖拽
        },
        onDrop:function (targetRow,sourceRow,point)
        {
            //onDrop,当选中某一行时触发
            //1.targetRow:放置的目标行/替换的行
            //2.sourceRow:拖拽的源行
            //3.point：指示放置的位置,可能的值:'append''top'或'bottom'。
            $(this).treegrid('enableDnd'); //允许拖拽
        },
        onBeforeSelect:function(node){
	    	//$("#TextDesc").combobox("panel").panel("close");
		}, 
        onContextMenu:function (e, row) { //右键时触发事件
            e.preventDefault();//阻止浏览器捕获右键事件
            $(this).treegrid('select', row.id);
            var diagridmm = $('<div style="width:120px;"></div>').appendTo('body');
            $(
                '<div onclick="AddDataB()" iconCls="icon-add" data-options="">添加同级</div>' +
                '<div onclick="AddData()" iconCls="icon-add" data-options="">添加子级</div>' +
                '<div onclick="updateData()" iconCls="icon-write-order" data-options="">修改</div>' +
                '<div onclick="delData()" iconCls="icon-cancel" data-options="">删除</div>' +
                '<div onclick="clearFunLib()" iconCls="icon-reload" data-options="">刷新</div>'
            ).appendTo(diagridmm)
            diagridmm.menu()
            diagridmm.menu('show',{
                left:e.pageX,
                top:e.pageY
            });
        },
        onClickRow:function(index,row)
        {
	        //RefreshSearchData("User.MKBInterfaceManage",row.id,"A",row.MKBINMDesc);
	    	$('#listgrid').datagrid('reload',  { 
	            ClassName:"web.DHCBL.KB.DHCPHDiseaseLinkLabel",
	            QueryName:"GetList",
				treeid:row.id
	        });
	        $('#Promptgrid').datagrid('unselectAll');	

	        $('#itmgrid').datagrid('load',  { 
	            ClassName:"web.DHCBL.KB.DHCPHDisLabelItm",
	            QueryName:"GetList",
	            pdliid:-1
	        });	        
	        itmMethod("","","");	                
        },
        onDblClickRow:function()
        {
        	updateData();
        }     

    });    
	//ShowUserHabit('diagrid');
	//指导目录列表
	var listcolumns =[[
        {field:'PDLDisTreeDr',title:'检验项目',sortable:true,width:100,hidden:true},
        {field:'PDLLabelDr',title:'指南目录',sortable:true,width:100},
        {field:'PDLLabelDrID',title:'指南目录id',sortable:true,width:100,hidden:true},
        {field:'PDLRelation',title:'逻辑关系',sortable:true,width:100,
        	formatter: function(value,row,index)
        	{
			    if (value=="O")
	    		{
	    		   return "Or";
	    		}
	    		if (value=="A")
	    		{
	    		   return "And";
	    		}
        	}
    	},
        {field:'PDLOperator',title:'运算符',sortable:true,width:100,
        	formatter: function(value,row,index)
        	{
        		if (value==">")
        		{
        		   return "大于";
        		}
        		if (value=="<")
        		{
        		   return "小于";
        		}
        		if (value=="=")
        		{
        		   return "等于";
        		}
        		if (value=="!>")
        		{
        		   return "不大于";
        		}
        		if (value=="!<")
        		{
        		   return "不小于";
        		}
        		if (value=="<>")
        		{
        		   return "不等于";
        		}
        	}
    	},
        {field:'PDLNum',title:'数量',sortable:true,width:100},
        {field:'PDLRowId',title:'rowid',sortable:true,width:100,hidden:true}
    ]];
    var listgrid = $HUI.datagrid("#listgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHDiseaseLinkLabel",
            QueryName:"GetList"
        },
        columns: listcolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCPHExtPart',
		//SQLTableName:'DHC_PHExtPart',
        idField:'PDLRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(index,row)
        {
        	updateDataL();
        },
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },
        onClickRow:function(index, field, value)
        {
        	clickListGrid();
        }	 	
    });
    clickListGrid=function()
    {
    	var record = listgrid.getSelected(); 
    	if(record)
    	{
    		/*var labeldr=record.PDLLabelDrID
    		//alert(record.PDLLabelDr+"^"+record.PDLRowId)
    		var url="../csp/dhc.bdp.kb.dhcphdislabelltm.csp"+"?parref="+record.PDLRowId+"&parrefDesc="+record.PDLLabelDr+"&labeldr="+labeldr;
        	$('#itm_iframe').attr("src",url);*/
	    	parref=record.PDLRowId;
	    	parrefDesc=record.PDLLabelDr;
	    	labeldr=record.PDLLabelDrID;
			itmMethod(parref,parrefDesc,labeldr);	
			comMethod(parrefDesc,labeldr);         	
    	}   	
    }
    //搜索是关联目录下拉框
	$('#TextList').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHGuideLabel&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'PGLRowId',
        textField:'PGLDesc'
        //mode:'remote', 
    });
	$('#PDLLabelDr').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHGuideLabel&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'PGLRowId',
        textField:'PGLDesc'
        //mode:'remote', 
    });
	//逻辑下拉框
	$('#PDLRelation').combobox({
        valueField:'id',
        textField:'text',
        data:[
			{id:'O',text:'Or'},
			{id:'A',text:'And'}	
		]
    }); 
    //运算符
	$('#PDLOperator').combobox({
        valueField:'id',
        textField:'text',
        data:[
			{id:'>',text:'大于'},
			{id:'<',text:'小于'},
			{id:'=',text:'等于'},
			{id:'!>',text:'不大于'},
			{id:'!<',text:'不小于'},
			{id:'<>',text:'不等于'}	
		]
    });            
	$('#addl_btn').click(function(){
		AddDataL();
	});
	$('#updatel_btn').click(function(){
		updateDataL();
	});
	$('#dell_btn').click(function(){
		delDataL();
	});
	$('#listSearch').click(function(){
    	var desc=$("#TextList").combobox('getText');
    	var record = diagrid.getSelected(); 
    	$('#listgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHDiseaseLinkLabel",
            QueryName:"GetList",
        	treeid:record.id,
        	label:desc
        });
        $('#listgrid').datagrid('unselectAll');		

        $('#itmgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHDisLabelItm",
            QueryName:"GetList",
            pdliid:-1
        });	        
        itmMethod("","","");
	});
	$('#listRefresh').click(function(){
		var record = diagrid.getSelected(); 
		$("#TextList").combobox('setValue','');
        $('#listgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHDiseaseLinkLabel",
            QueryName:"GetList",
            treeid:record.id
        });
        //alert(1)
        $('#itmgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHDisLabelItm",
            QueryName:"GetList",
            pdliid:-1
        });	        
        itmMethod("","","");
        //alert(2)
        //$('#itm_iframe').attr("src","");
		$('#listgrid').datagrid('unselectAll');		
	});
 	//点击添加按钮方法
    AddDataL=function(){
    	var record = diagrid.getSelected(); 
    	if(record)
    	{
	    	$("#listWin").show();
			var listWin = $HUI.dialog("#listWin",{
				iconCls:'icon-addlittle',
				resizable:true,
				title:'添加',
				modal:true,
				buttonAlign : 'center',
				buttons:[{
					text:'保存',
					id:'savel_btn',
					handler:function(){
						SaveFunLibL("",1)
					}
				},{
					text:'继续添加',
					id:'savel_goon',
					handler:function(){
						//goOnSaveData();
						SaveFunLibL("",2)
					}
				},{
					text:'关闭',
					handler:function(){
						$('#listWin').dialog('close');
					}
				}]
			});
			$('#list-save').form("clear");	
    	}
		else{
			$.messager.alert('错误提示','请先在左侧列表选择一条记录!',"error");
		}   	
	}
	SaveFunLibL=function(id,flagT)
	{
		var desc=$('#PDLLabelDr').combobox('getValue');
		if (desc==""||desc==undefined)
		{
			$.messager.alert('错误提示','指南目录不能为空!',"error");
			return;
		}
		var record = diagrid.getSelected();
		var parref=record.id; 
		$('#PDLDisTreeDr').val(parref);	
		$('#list-save').form('submit', {
			url:SAVE_ACTION_URL_LinkLabel,
			onSubmit: function(param){
                param.PDLRowId = id;
            },
		success: function (data) { 
		  	var data=eval('('+data+')'); 
		  	if (data.success == 'true') {
				/*$.messager.show({ 
			 	title: '提示消息', 
			  	msg: '提交成功', 
			  	showType: 'show', 
			  	timeout: 1000, 
			  	style: { 
				right: '', 
				bottom: ''
			  	} 
			});*/
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$('#listgrid').datagrid('reload');  // 重新载入当前页面数据 
			//alert(flagT)
			if(flagT==1)
			{
				//alert(flagT)
				$('#listWin').dialog('close'); // close a dialog
			}
			else
			{
				$('#list-save').form("clear");				
			}
		  } 
		  else { 
			var errorMsg ="更新失败！"
			if (data.errorinfo) {
				errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
			}
		$.messager.alert('操作提示',errorMsg,"error");

			}
		} 
		});		
	}
	updateDataL=function()
	{
		var recordD = diagrid.getSelected(); 
    	if(recordD)
    	{
			var record = listgrid.getSelected(); 
			if(record)
			{
				var id=record.PDLRowId;
				$.cm({
					ClassName:"web.DHCBL.KB.DHCPHDiseaseLinkLabel",
					MethodName:"NewOpenData",
					id:id
				},function(jsonData){			
					$('#list-save').form("load",jsonData);	
				});	
				$("#listWin").show();
				var listWin = $HUI.dialog("#listWin",{
					iconCls:'icon-updatelittle',
					resizable:true,
					title:'修改',
					modal:true,
					buttons:[{
						text:'保存',
						id:'save_btn',
						handler:function(){
							SaveFunLibL(id,1)
						}
					},{
						text:'关闭',
						handler:function(){
							$('#listWin').dialog('close');
						}
					}]
				});							
			}else{
				$.messager.alert('错误提示','请先选择一条记录!',"error");
			}
	    	}
		else{
			$.messager.alert('错误提示','请先在左侧列表选择一条记录!',"error");
		} 		
	}
	delDataL=function()
	{
		var row = $("#listgrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.PDLRowId;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				$.ajax({
					url:DELETE_ACTION_URL_LinkLabel,  
					data:{"id":rowid},  
					type:"POST",   
					//dataType:"TEXT",  
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
								/*$.messager.show({ 
								  title: '提示消息', 
								  msg: '删除成功', 
								  showType: 'show', 
								  timeout: 1000, 
								  style: { 
									right: '', 
									bottom: ''
								  } 
								}); */
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								 $('#listgrid').datagrid('reload');  // 重新载入当前页面数据 
								 $('#listgrid').datagrid('unselectAll');  // 清空列表选中数据 
							  } 
							  else { 
								var errorMsg ="删除失败！"
								if (data.info) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.info
								}
								 $.messager.alert('操作提示',errorMsg,"error");
							}			
					}  
				})
			}
		});
	}



/******************************************************************************明细*********************************************/
	function itmMethod(parref,parrefDesc,labeldr)
	{
		if(parrefDesc=="症状" || parrefDesc=="诊断")
		{
			var columns =[[
		        {field:'PHEGDesc',title:'通用名',sortable:true,width:100,hidden:true},
		        {field:'PDLIVal',title:'检验值',sortable:true,width:100,hidden:true},
		        {field:'PDLIOperator',title:'运算符',sortable:true,width:100,
		        	formatter: function(value,row,index)
		        	{
		        		if (value==">")
		        		{
		        		   return "大于";
		        		}
		        		if (value=="<")
		        		{
		        		   return "小于";
		        		}
		        		if (value=="=")
		        		{
		        		   return "等于";
		        		}
		        		if (value=="!>")
		        		{
		        		   return "不大于";
		        		}
		        		if (value=="!<")
		        		{
		        		   return "不小于";
		        		}
		        		if (value=="<>")
		        		{
		        		   return "不等于";
		        		}
		        	},hidden:true
		    	},
		        {field:'PDLIResultText',title:'结果',sortable:true,width:100,
		        	formatter: function(value,row,index)
		        	{
		        		if (value=="H")
		        		{
		        		   return "高";
		        		}
		        		if (value=="L")
		        		{
		        		   return "低";
		        		}
		        		if (value=="N")
		        		{
		        		   return "正常";
		        		}
		        		if (value=="I")
		        		{
		        		   return "包含";
		        		}
		        		if (value=="NT")
		        		{
		        		   return "阳性";
		        		}
		        		if (value=="PT")
		        		{
		        		   return "阴性";
		        		}
		        	},hidden:true	        	
		    	},
		    	{field:'PHKWDesc',title:'关联项目',sortable:true,width:100},
		    	{field:'PDLIRelation',title:'逻辑',sortable:true,width:100,
			    	formatter: function(value,row,index)
		        	{
					    if (value=="O")
			    		{
			    		   return "Or";
			    		}
			    		if (value=="A")
			    		{
			    		   return "And";
			    		}
		        	},hidden:true
		    	},
		        {field:'PDLISysFlag',title:'是否系统标识',sortable:true,width:100,
		            formatter:ReturnFlagIcon,hidden:true
		        },         
		        {field:'PDLIRowId',title:'rowid',sortable:true,width:100,hidden:true}
		    ]];
		}
		else if(parrefDesc=="检查" || parrefDesc=="检验")
		{
			var columns =[[
		        {field:'PHEGDesc',title:'通用名',sortable:true,width:100},
		        {field:'PDLIVal',title:'检验值',sortable:true,width:100},
		        {field:'PDLIOperator',title:'运算符',sortable:true,width:100,
		        	formatter: function(value,row,index)
		        	{
		        		if (value==">")
		        		{
		        		   return "大于";
		        		}
		        		if (value=="<")
		        		{
		        		   return "小于";
		        		}
		        		if (value=="=")
		        		{
		        		   return "等于";
		        		}
		        		if (value=="!>")
		        		{
		        		   return "不大于";
		        		}
		        		if (value=="!<")
		        		{
		        		   return "不小于";
		        		}
		        		if (value=="<>")
		        		{
		        		   return "不等于";
		        		}
		        	}
		    	},
		        {field:'PDLIResultText',title:'结果',sortable:true,width:100,
		        	formatter: function(value,row,index)
		        	{
		        		if (value=="H")
		        		{
		        		   return "高";
		        		}
		        		if (value=="L")
		        		{
		        		   return "低";
		        		}
		        		if (value=="N")
		        		{
		        		   return "正常";
		        		}
		        		if (value=="I")
		        		{
		        		   return "包含";
		        		}
		        		if (value=="NT")
		        		{
		        		   return "阴性";
		        		}
		        		if (value=="PT")
		        		{
		        		   return "阳性";
		        		}
		        	}	        	
		    	},
		    	{field:'PHKWDesc',title:'关联项目',sortable:true,width:100,hidden:true},
		    	{field:'PDLIRelation',title:'逻辑',sortable:true,width:100,
			    	formatter: function(value,row,index)
		        	{
					    if (value=="O")
			    		{
			    		   return "Or";
			    		}
			    		if (value=="A")
			    		{
			    		   return "And";
			    		}
		        	}
		    	},
		        {field:'PDLISysFlag',title:'是否系统标识',sortable:true,width:100,
		            formatter: function(value,row,index){
		                    if(value=='N')  
		                    {
		                        return "<img  src='../scripts/bdp/Framework/icons/no.png' style='border: 0px'><span>"
		                    }
		                    else if(value=='Y') 
		                    {
		                    	return "<img src='../scripts/bdp/Framework/icons/yes.png' style='border: 0px'><span>";
		                    }
		            }
		        },         
		        {field:'PDLIRowId',title:'rowid',sortable:true,width:100,hidden:true}
		    ]];		
		}
		else
		{
			var columns = [[]];
		}
	    var itmgrid = $HUI.datagrid("#itmgrid",{
	        url:$URL,
	        queryParams:{
	            ClassName:"web.DHCBL.KB.DHCPHDisLabelItm",
	            QueryName:"GetList",
	            pdliid:parref
	        },
	        columns: columns,  //列信息
	        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
	        pageSize:PageSizeMain,
	        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
	        singleSelect:true,
	        remoteSort:false,
	        //ClassTableName:'User.DHCLabItmResult',
			//SQLTableName:'DHC_LabItmResult',
	        idField:'PDLIRowId',
	        rownumbers:true,    //设置为 true，则显示带有行号的列。
	        fixRowNumber:true,
	        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
	        onDblClickRow:function(index,row)
	        {
	        	updateItmData();
	        },
	        onLoadSuccess:function(data){
				$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
	        }	
	    	
	    });
	}
    $('#additm_btn').click(function(){
    	addItmData();
    });
    $('#updateitm_btn').click(function(){
    	updateItmData();
    });
    $('#delitm_btn').click(function(){
    	delItmData();
    });
    delItmData=function()
    {
 		var row = $("#itmgrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.PDLIRowId;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				$.ajax({
					url:DELETE_ACTION_URL_LabelItm,  
					data:{"id":rowid},  
					type:"POST",   
					//dataType:"TEXT",  
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
								/*$.messager.show({ 
								  title: '提示消息', 
								  msg: '删除成功', 
								  showType: 'show', 
								  timeout: 1000, 
								  style: { 
									right: '', 
									bottom: ''
								  } 
								}); */
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								 $('#itmgrid').datagrid('reload');  // 重新载入当前页面数据 
								 $('#itmgrid').datagrid('unselectAll');  // 清空列表选中数据 
							  } 
							  else { 
								var errorMsg ="删除失败！"
								if (data.info) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.info
								}
								 $.messager.alert('操作提示',errorMsg,"error");
					
							}			
					}  
				})
			}
		});   	
    }    
  	updateItmData=function()
	{
    	if(parrefDesc=="症状" || parrefDesc=="诊断")
    	{
    		$('#gendrid').hide();
    		$('#valid').hide();
    		$('#operatorid').hide();
    		$('#resultid').hide();
    		$('#relationid').hide();
    		$('#flagid').hide();
    		$('#keywordid').show();
    	}
    	else
    	{
    		$('#gendrid').show();
    		$('#valid').show();
    		$('#operatorid').show();
    		$('#resultid').show();
    		$('#relationid').show();
    		$('#flagid').show();
    		$('#keywordid').hide();
    	}		
		var record = $("#itmgrid").datagrid("getSelected"); 
		if(record)
		{
			var id=record.PDLIRowId;
			$.cm({
				ClassName:"web.DHCBL.KB.DHCPHDisLabelItm",
				MethodName:"NewOpenData",
				id:id
			},function(jsonData){
				//alert(jsonData.PDPLabelDr)
				//alert(jsonData.PDLISysFlag)
				if (jsonData.PDLISysFlag=="Y"){
					$HUI.checkbox("#PDLISysFlag").setValue(true);		
				}else{
					$HUI.checkbox("#PDLISysFlag").setValue(false);
				}					
				$('#itm-save').form("load",jsonData);	
			});	
			$("#itmWin").show();
			var itmWin = $HUI.dialog("#itmWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					id:'save_btn',
					handler:function(){
						saveItmFunLib(id,1)
					}
				},{
					text:'关闭',
					handler:function(){
						itmWin.close();
					}
				}]
			});							
		}else{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
		}
	}      
    saveItmFunLib=function(id,flagT)
    {
    	if(parrefDesc=="症状" || parrefDesc=="诊断")
    	{
    		var desc=$('#PDLIKeyWord').combobox('getValue');
    		if(desc=="")
	    	{
				$.messager.alert('错误提示','关联项目不能为空!',"error");
				return;    		
	    	} 
    	}
    	else
    	{
    		var desc=$('#PDLIGenDr').combobox('getValue');
	    	if(desc=="")
	    	{
				$.messager.alert('错误提示','通用名不能为空!',"error");
				return;    		
	    	}     		
    	}   	
		$('#PDLIId').val(parref);		
		$('#itm-save').form('submit', {
			url:SAVE_ACTION_URL_LabelItm,
			onSubmit: function(param){
                param.PDLIRowId = id;
            },
			success: function (data) { 
			  	var data=eval('('+data+')'); 
			  	if (data.success == 'true') {
					/*$.messager.show({ 
				 	title: '提示消息', 
				  	msg: '提交成功', 
				  	showType: 'show', 
				  	timeout: 1000, 
				  	style: { 
					right: '', 
					bottom: ''
				  	} 
				});*/
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000}); 
				$('#itmgrid').datagrid('reload');  // 重新载入当前页面数据 
				if(flagT==1)
				{
					$('#itmWin').dialog('close'); // close a dialog
				}
				else
				{
					$('#itm-save').form("clear");
					$HUI.checkbox("#PDLISysFlag").setValue(true);
				}
		    } 
		  	else { 
				var errorMsg ="更新失败！"
				if (data.errorinfo) {
					errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
				}
			 	$.messager.alert('操作提示',errorMsg,"error");
			}

		} 
		});		    	
    }  
    function comMethod(parrefDesc,labeldr)
    {
	    if(parrefDesc=="检验")
	    {
		    $('#PDLIGenDr').combobox({
		        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=LAB",
		        valueField:'PHEGRowId',
		        textField:'PHEGDesc'
		        //mode:'remote', 
		    });	     
	    }
	    if(parrefDesc=="检查")
	    {
		    $('#PDLIGenDr').combobox({
		        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=CHECK",
		        valueField:'PHEGRowId',
		        textField:'PHEGDesc'
		        //mode:'remote', 
		    });     	
	    }
	    $('#PDLIKeyWord').combobox({
	        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHDiseaseGuide&QueryName=GetIDDataForCmb&ResultSetType=array&labeldr="+labeldr,
	        valueField:'RowId',
	        textField:'Desc'
	        //mode:'remote', 
	    }); 	    
    }    
    //运算符
	$('#PDLIOperator').combobox({
        valueField:'id',
        textField:'text',
        data:[
			{id:'>',text:'大于'},
			{id:'<',text:'小于'},
			{id:'=',text:'等于'},
			{id:'!>',text:'不大于'},
			{id:'!<',text:'不小于'},
			{id:'<>',text:'不等于'}	
		]
    }); 
	//逻辑下拉框
	$('#PDLIRelation').combobox({
        valueField:'id',
        textField:'text',
        data:[
			{id:'O',text:'Or'},
			{id:'A',text:'And'}	
		]
    });
    //运算符
	$('#PDLIResultText').combobox({
        valueField:'id',
        textField:'text',
        data:[
			{id:'H',text:'高'},
			{id:'L',text:'低'},
			{id:'N',text:'正常'},
			{id:'I',text:'包含'},
			{id:'NT',text:'阴性'},
			{id:'PT',text:'阳性'}	
		]
    });                           
    addItmData=function()
    {
 		var row = $("#listgrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条指南目录信息!',"error");
			return;
		}    	
    	//singleselect=true;
    	if(parrefDesc=="症状" || parrefDesc=="诊断")
    	{
    		$('#gendrid').hide();
    		$('#valid').hide();
    		$('#operatorid').hide();
    		$('#resultid').hide();
    		$('#relationid').hide();
    		$('#flagid').hide();
    		$('#keywordid').show();
    	}
    	else
    	{
    		$('#gendrid').show();
    		$('#valid').show();
    		$('#operatorid').show();
    		$('#resultid').show();
    		$('#relationid').show();
    		$('#flagid').show();
    		$('#keywordid').hide();
    	}
 		$("#itmWin").show();
		var itmWin = $HUI.dialog("#itmWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					saveItmFunLib("",1)
				}
			},
			{
				text:'继续新增',
				id:'save_goon',
				handler:function(){
					saveItmFunLib("",2)
				}
			},{
				text:'关闭',
				handler:function(){
					itmWin.close();
				}
			}]
		});
		$('#itm-save').form("clear");
		$HUI.checkbox("#PDLISysFlag").setValue(true);		
    }     						
}
$(init);
 /*
	Function: 科室分级
	Creator: sunfengchao
	CreateDate:2018-09-15
 */
 var DELETE_TreeACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPBaseDataMap&pClassMethod=DeleteData";
 var TREE_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPBaseDataMap&pClassMethod=GetTreeList";
 /// 所属目录的下拉树 url
 var COMBOTREE_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPBaseDataMap&pClassMethod=GetComboTreeList";
 var SAVE_DATA_ACTION_URL =  "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BDPBaseDataMap&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BDPBaseDataMap";
 
 var SAVE_ACTION_URL =  "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BDPBaseDataMap&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BDPBaseDataMap";
 var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPBaseDataMap&pClassMethod=DeleteData";
 
 var DELETE_LOCCTION_URL ="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPBaseDataMapDetail&pClassMethod=DeleteData";
 var LOC_SAVE_ACTION_URL= "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BDPBaseDataMapDetail&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BDPBaseDataMapDetail" ;  
 var TABLE_COMBOTREE_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTableList&pClassQuery=GetDataForCmb1";
 var init = function(){
 var treeid = "";
 var maptype="";
 var list="";
 
// 重写disableItem方法和enableItem方法。
/**
 * menu方法扩展
 * @param {Object} jq
 * @param {Object} itemEl
 */
$.extend($.fn.menu.methods, { 
    enableItem : function(jq, itemEl) {
        return jq.each(function(){
            var jqElements = $(itemEl);
            var state = $.data(this, 'menu');
            if (jqElements.length > 0) {
                jqElements.each(function(){
                    if ($(this).hasClass('menu-item-disabled')) {
                        for(var i=0; i<state._eventsStore.length; i++){
                            var itemData = state._eventsStore[i];
                            if(itemData.target == this){
                                //恢复超链接
                                if (itemData.href) {
                                    $(this).attr("href", itemData.href);
                                }
                                //回复点击事件
                                if (itemData.onclicks) {
                                    for (var j = 0; j < itemData.onclicks.length; j++) {
                                        $(this).bind('click', itemData.onclicks[j]);
                                    }
                                }
                                //设置target为null，清空存储的事件处理程序
                                itemData.target = null;
                                itemData.onclicks = [];
                                $(this).removeClass('menu-item-disabled');
                            }
                        }
                    }
                });
            }
        });
    },
    /**
     * 禁用选项（覆盖重写）
     * @param {Object} jq
     * @param {Object} itemEl
     */
    disableItem : function(jq, itemEl) {
        return jq.each(function() {
            var jqElements = $(itemEl);
            var state = $.data(this,'menu');
            if (jqElements.length > 0) {
                if (!state._eventsStore)
                    state._eventsStore = [];
                jqElements.each(function(){
                    if (!$(this).hasClass('menu-item-disabled')) {
                        var backStore = {};
                        backStore.target = this;
                        backStore.onclicks = [];
                        //处理超链接
                        var strHref = $(this).attr("href");
                        if (strHref) {
                            backStore.href = strHref;
                            $(this).attr("href", "javascript:void(0)");
                        }
                        //处理直接耦合绑定到onclick属性上的事件
                        var onclickStr = $(this).attr("onclick");
                        if (onclickStr && onclickStr != "") {
                            backStore.onclicks[backStore.onclicks.length] = new Function(onclickStr);
                            $(this).attr("onclick", "");
                        }
                        //处理使用jquery绑定的事件
                        var eventDatas = $(this).data("events") || $._data(this, 'events');
                        if (eventDatas["click"]) {
                            var eventData = eventDatas["click"];
                            for (var i = 0; i < eventData.length; i++) {
                                if (eventData[i].namespace != "menu") {
                                    backStore.onclicks[backStore.onclicks.length] = eventData[i]["handler"];
                                    $(this).unbind('click', eventData[i]["handler"]);
                                    i--;
                                }
                            }
                        }
                        //遍历_eventsStore数组，如果有target为null的元素，则利用起来
                        var isStored = false;
                        for(var j=0; j<state._eventsStore.length; j++){
                            var itemData = state._eventsStore[j];
                            if(itemData.target==null){
                                isStored = true;
                                state._eventsStore[j] = backStore;
                            }
                        }
                        //没有现成的，则push进去
                        if(isStored==false){
                            state._eventsStore[state._eventsStore.length] = backStore;
                        }
                        $(this).addClass('menu-item-disabled');
                    }
                });
            }
        });
    }
});

 $.extend($.fn.datagrid.methods, {
           addEditor : function(jq, param) {
               if (param instanceof Array) {
                   $.each(param, function(index, item) {
                       var e = $(jq).datagrid('getColumnOption', item.field);
                       e.editor = item.editor;
                   });
              } else {
                 var e = $(jq).datagrid('getColumnOption', param.field);
                  e.editor = param.editor; 
              }
        },
         removeEditor : function(jq, param) {
              if (param instanceof Array) {
                  $.each(param, function(index, item) {
                      var e = $(jq).datagrid('getColumnOption', item);
                      e.editor = {};
                 });
              } else {
                  var e = $(jq).datagrid('getColumnOption', param);
                  e.editor = {};
              }
         }
     });
  
   // 对照类型下拉框 
    $("#DPBaseDMTypeF").combobox({
        valueField:'id',
        textField:'text',
        data:[
            {id:'D',text:'HIS字典'},
            {id:'T',text:'文本'} 
        ],
		onSelect:function(){  
			$('#BDPBaseDMTableDRF').combobox('clear');  
			var type=$('#DPBaseDMTypeF').combobox('getValue');
			if (type=="T"){
				$('#BDPBaseDMTableDRF').combobox("disable");
			}
			else{
				$('#BDPBaseDMTableDRF').combobox("enable");
			} 
		}  
    });
 
	//父菜单
	$HUI.combotree('#BDPBaseDMParentDRF',{
		url:COMBOTREE_ACTION_URL
	});
	
	//  表结构 指向  
	var CityAreaCombo = $HUI.combobox("#BDPBaseDMTableDRF",{
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPTableList&QueryName=GetList&ResultSetType=array", 
		valueField:'ID',
 		textField:'TableDesc'                                                       
 	});
	 
	
  	/// 右侧  搜索按钮
  	$("#btnSearch").click(function (e) {
		SearchData();
	})
	// 右侧 属性清屏按钮
	$("#btnRefresh").click(function (e) { 
		ClearData();
	 })  
	//属性新增按钮
	$("#add_btn").click(function (e) {   
		ToolbarAddProperty();
	 })
	 //属性 修改
	$("#update_btn").click(function (e) {  
		UpdateProperty();
	 })  
	 
	//属性 删除
	$("#del_btn").click(function (e) {  
		removes();
	 });
  
	 $('#TextDesc').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchData();
		}
		if(event.keyCode == 27) {
		  ClearData();
		}  
	});  
	 
	// 右侧字典数据 新增按钮
	$("#add_dicdata_btn").click(function (e) {   
		AddDicMapFun();
	 })
	 //右侧字典数据  修改
	$("#modify_dicdata_btn").click(function (e) {  
		ModifyDicMapFun();
	 })  
	 
	//右侧字典数据  删除
	$("#del_dicdata_btn").click(function (e) {  
		DeleteDicMapFun();
	 });	
	 
	/// 左侧 搜索框响应 
	$('#TextTreeDesc').searchbox({ 
		searcher:function () {  
			var SearchContent = $("#TextTreeDesc").searchbox('getValue');
			$("#Tree").treegrid("search", SearchContent) 
		}
	});
		/// 左侧 清屏按钮
	$("#btnTreeRefresh").click(function (e) {   
		$("#TextTreeDesc").searchbox('setValue',''); 
		$("#Tree").treegrid('reload');  
	 })  
  
	
	 //属性查询方法
	function SearchData(){
		var HISCode=$("#TextHISCode").val();   
		var HISDesc=$("#TextHISDesc").val(); 
		var ExtCode=$("#TextEXTCode").val();   
		var ExtDesc=$("#TextEXTDesc").val();
		$('#DataGrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.BDPBaseDataMapDetail",
			QueryName:"GetList", 
			NodeId:treeid,
			HisCode:HISCode,
			HisDesc:HISDesc,
			ExtCode:ExtCode,
			ExtDesc:ExtDesc 
		});
		$('#DataGrid').datagrid('unselectAll'); 
	}
	//属性清屏方法
	function ClearData(){
		$("#TextHISCode").val('');   
		$("#TextHISDesc").val(''); 
		$("#TextEXTCode").val('');   
		$("#TextEXTDesc").val('');
		$('#DataGrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.BDPBaseDataMapDetail",
			QueryName:"GetList", 
			NodeId:treeid,
			HisCode:'',
			HisDesc:'',
			ExtCode:'',
			ExtDesc:'' 
		}); 
		$('#DataGrid').datagrid('unselectAll'); 
	}
	  
     
///删除左侧树形目录  
removes=function(){
	$.messager.confirm("提示", "删除目录，会同时删除该目录下的子目录以及对照表数据，确定删除该目录？", function (r) {
	if (r) { 
  	 $.ajax({
        url:DELETE_TreeACTION_URL,  
        data:{"id":treeid},  
        type:"POST",   
        success: function(data){
		  var data=eval('('+data+')'); 
		  if (data.success == 'true') {
			$.messager.show({ 
			  title: '提示消息', 
			  msg: '删除成功', 
			  showType: 'show', 
			  timeout: 1000 
			}); 
			treeid = ""; /// 置空 id
			$('#Tree').treegrid('reload');
			$('#DataGrid').datagrid('reload');  // 重新载入当前页面数据  
			$('#DataGrid').datagrid('unselectAll'); 
		  } 
		  else { 
			var errorMsg ="删除失败！"
			if (data.info) {
				errorMsg =errorMsg+ '<br/>错误信息:' + data.info
			}
			$.messager.alert('操作提示',errorMsg,"error");
			$("#Tree").treegrid('reload');
		}           
      }  
     }) ;
	}
	else{
		$('#Tree').treegrid('reload');
        $('#DataGrid').datagrid('reload');  // 重新载入当前页面数据  
        $('#DataGrid').datagrid('unselectAll');
	}
	});
  }

/// 修改字典 
UpdateProperty=function (){    
		$('#BDPBaseDMParentDRF').combotree('reload'); ///上级分类
		if ($('#BDPBaseDMParentDRF').combotree('getText')=='')
		{
			$('#BDPBaseDMParentDRF').combotree('setValue','')
		} 
        if (treeid!==""){   
            $.cm({   //调用后台openData方法给表单赋值
                ClassName:"web.DHCBL.CT.BDPBaseDataMap",
                MethodName:"OpenData",
                id:treeid
            },function(jsonData){  
                $('#form-save2').form("load",jsonData); 
            });
            if (maptype=="T"){
				$('#BDPBaseDMTableDRF').combobox("disable");
			}
			else{
				$('#BDPBaseDMTableDRF').combobox("enable");
			} 
            $("#myWin2").show(); 
            var myWin = $HUI.dialog("#myWin2",{
                iconCls:'icon-w-edit',
                resizable:true,
                title:'修改',
                modal:true,
                buttons:[{
                    text:'保存', 
                    id:'save_btn',
                    handler:function(){
                    	SaveFunLib(treeid,"")
                    }
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

 
 ///新增 左侧 菜单项目
AddTJProperty =function (){  
		var menudr=tkMakeServerCall("web.DHCBL.CT.BDPBaseDataMap","GetMenuDR",treeid);  
		$('#BDPBaseDMParentDRF').combotree('setValue',""); 		
		$('#BDPBaseDMParentDRF').combotree('setValue',menudr);
		$('#BDPBaseDMParentDRF').combotree('reload');			
  	    $("#BDPBaseDMRowIdF").val(""); 
  	    $("#BDPBaseDMCodeF").val("");
        $("#BDPBaseDMDescF").val("");   
		$('#DPBaseDMTypeF').combobox('setValue',''); 
		$('#BDPBaseDMTableDRF').combobox('setValue','');
		$('#BDPBaseDMDateFromF').datebox('setValue','');
		$('#BDPBaseDMDateToF').datebox('setValue','');  
	    $("#myWin2").show(); 
        var myWin = $HUI.dialog("#myWin2",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'新增',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存', 
                id:'save_btn',
                handler:function(){
                    SaveFunLib("","Self")
                }
            },{
                text:'关闭', 
                handler:function(){
                    myWin.close();
                }
            }] 
        }); 
  }


	///新增字典时的保存方法     新增、更新
    function SaveFunLib(id)
    {            
        var code=$.trim($("#BDPBaseDMCodeF").val());
        var desc=$.trim($("#BDPBaseDMDescF").val());
        var datefrom =$("#BDPBaseDMDateFromF").datebox('getValue');
		var dateto =$("#BDPBaseDMDateToF").datebox('getValue'); 
		var type=$("#DPBaseDMTypeF").combobox('getValue');
		var linktable=$('#BDPBaseDMTableDRF').combobox('getValue');
        if (code=="")
        {
            $.messager.alert('错误提示','代码不能为空!',"error");
            return false;
        }
        if (desc=="")
        {
            $.messager.alert('错误提示','名称不能为空!',"error");
            return false;
        }
		if ((type=="D")&&(linktable=="")){
			$.messager.alert('错误提示','对照类别为HIS字典,请选择指向表!',"error");
            return false;
		}
		if ((type=="T")&&(linktable!=="")){
			$.messager.alert('错误提示','对照类别为文本,不能选择指向表!',"error");
            return false;
		}
        if (datefrom=="")
        {
            $.messager.alert('错误提示','开始日期不能为空!',"error");
            return false;
        }
		if (datefrom != "" && dateto != "") {
			var dateflag= tkMakeServerCall("web.DHCBL.CT.BDPBaseDataMap","CompareDate",datefrom,dateto) 
			if(dateflag==1){  
				$.messager.alert('错误提示','开始日期不能大于结束日期!',"error");
				return false;
			}
		}
  
		$('#form-save2').form('submit', { 
				url: SAVE_ACTION_URL, 
				onSubmit: function(param){
					 param.datalist = list; 
				},
				success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
					$.messager.show({ 
						  title: '提示消息', 
						  msg: '提交成功', 
						  showType: 'show', 
						  timeout: 1000 
					}); 
					list="";
					$('#Tree').treegrid('reload');
					$('#myWin2').dialog('close'); 
					var treerowid = data.id;
					$('#DataGrid').datagrid('options').queryParams.dictorydr = treerowid;
			   
					//动态列重新加载后刷新datagrid
					$('#DataGrid').datagrid('reload'); 
				  } 
				  else { 
					list="";
					$('#Tree').treegrid('reload');
					var errorMsg ="更新失败！"
					if (data.errorinfo) {
						errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
					}
					$.messager.alert('操作提示',errorMsg,"error");
				} 
			} 
		 });   
   }

    ///加载树形目录
    var TreeColumns =[[  
		  {field:'text',title:'描述',width:290,sortable:true},
		  {field:'ID',title:'ID',width:80,sortable:true,hidden:true}
	]];
	/// 定义 左侧树形列表			  
	var mygrid = $HUI.treegrid("#Tree",{
		url: TREE_ACTION_URL,  
		columns: TreeColumns,  
		//height: 'auto', 
		height:$(window).height()-105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
		fit:true,
		idField: 'id',
		treeField:'text',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
		animate:false,    
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		lines:true,
		showHeader:false, 
		onDblClickRow:function(index,row)
		{ 
			UpdateProperty(); 
		},
		onContextMenu: function(e, row){ 
				e.preventDefault();
        	 	$(this).treegrid('select', row.id);
			    $('#TreeMenu').menu('show',{
                    left: e.pageX,
                    top: e.pageY,
                    noline: true
               });  
			   var Flag=tkMakeServerCall("web.DHCBL.CT.BDPBaseDataMap","AllowAddNexNode",treeid); 
			   if (Flag==0){
				  $('#TreeMenu').menu('enableItem',$('#PropertyAddNextSelf'));
				  $('#TreeMenu').menu('enableItem',$('#PropertyAddSelf'));				  
			   }
			   else{  
				  $('#TreeMenu').menu('disableItem',$('#PropertyAddNextSelf'));
				  $('#TreeMenu').menu('enableItem',$('#PropertyAddSelf'));
			   }
          },
		onSelect:function(rowIndex,rowData){    
    		treeid = rowIndex;
			maptype=rowData.DPBaseDMType;
            $('#DataGrid').datagrid('options').queryParams.NodeId = treeid;
            /// 点击根节点的时候 动态加载 datagrid 
            //动态列重新加载后刷新datagrid 
            $('#DataGrid').datagrid('reload'); 
			$('#BDPMapDHisDicDesc').combobox({
				onBeforeLoad: function(param){
					param.nodeid = treeid; 
				}
			});  
        } 
	}); 

  
	///  字典表结构 下拉框    
	var CityAreaCombo = $HUI.combobox("#BDPMapDHisDicDesc",{ 
		url:$URL+"?ClassName=web.DHCBL.CT.BDPBaseDataMap&QueryName=GetTableListForCmb1&ResultSetType=array", 
		valueField:'RowId',
		textField:'BDPBaseDMTableDesc' , 
		onSelect:function(record){  
			// $('#BDPMapDHisDicDesc').combobox('reload',$URL+"?ClassName=web.DHCBL.CT.BDPBaseDataMap&QueryName=GetTableListForCmb1&ResultSetType=array");
			$("#BDPMapDHisDicCode").val(record.BDPBaseDMTableCode);
			$("#BDPMapDHisDicDescF").val(record.BDPBaseDMTableDesc);
			//$("#BDPMapDHisDicCode").disable();
			//$("#BDPMapDHisDicDescF").disable();
		}                                                          
	});
	 
 /// 字典数据对照  新增
	 var AddDicMapFun=function(){ 
		if (treeid==""){
			$.messager.alert('操作提示',"请先选择左侧字典目录","error"); 
			return false;
		} 
 
		if (maptype=="T"){ // 文本字段型的 手动填写 
			$('#BDPMapDHisDicDesc').combobox("disable");
			var box=$("#BDPMapDHisDicCode"); 
			$('#BDPMapDHisDicCode').attr("readonly", false); 
			$("#BDPMapDHisDicDescF").attr("readonly", false); 
		}
		else{ // 字典 需要通过 表结构下拉选择 进行赋值
			$('#BDPMapDHisDicDesc').combobox("enable"); 
			$('#BDPMapDHisDicCode').attr("readonly", true); 
			$("#BDPMapDHisDicDescF").attr("readonly", true);
		} 
			
		$("#BDPBaseDMRowId").val("");  
		$('#BDPMapDRowId').val("");  // rowid 置空
		$('#BDPMapDBaseTabNameDR').val(treeid);  /// 所属 字典  
		$('#BDPMapDHisDicCode').val(""); 
		$("#BDPMapDHisDicDescF").val(""); 
		$("#BDPMapDHisDicDesc").combobox('setValue',"");
        $("#BDPMapDHisDicDesc").combobox('reload');		
		$('#BDPMapDExtDicCode').val(""); 
		$('#BDPMapDExtDicDesc').val("");   
		$('#BDPMapDActive').checkbox("setValue","N"); 
		//默认选中 
		$HUI.checkbox("#BDPMapDActive").setValue(true);
		 
		 var myWin = $HUI.dialog("#myWin",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'新增',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存', 
                id:'save_btn',
                handler: SaveDicMapFun
            },{
                text:'关闭', 
                handler:function(){
                    myWin.close();
                }
            }] 
        }); 
	 }
	 
//  右侧数据对照  修改
 var ModifyDicMapFun=function(){
		if (maptype=="T"){ // 文本字段型的 手动填写 
			$('#BDPMapDHisDicDesc').combobox("disable"); 
			$('#BDPMapDHisDicCode').attr("readonly", false); 
			$("#BDPMapDHisDicDescF").attr("readonly", false); 
		}
		else{ // 字典 需要通过 表结构下拉选择 进行赋值
			$('#BDPMapDHisDicDesc').combobox("enable");  
			$('#BDPMapDHisDicCode').attr("readonly", true); 
			$("#BDPMapDHisDicDescF").attr("readonly", true);
		}  
        var record =$('#DataGrid').datagrid("getSelected"); 
        if (record){             
            var id = record.BDPMapDRowId;   //调用后台openData方法给表单赋值 
            $.cm({
                ClassName:"web.DHCBL.CT.BDPBaseDataMapDetail",
                MethodName:"OpenData",
                id:id
            },function(jsonData){ 
                $('#dicmap-form-save').form("load",jsonData);  //给是否可用单独赋值 
				$('#BDPMapDHisDicDesc').combobox("setValue",record.BDPMapDHisDicDesc);				
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
                    handler:function(){
						SaveDicMapFun(id)
					}
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
	 
	/// 右侧的保存方法     新增、更新
    function SaveDicMapFun(id)
    {    
		var BDPMapDHisDicCodeVal= $("#BDPMapDHisDicCode").val(); 
        var BDPMapDHisDicDescVal= $("#BDPMapDHisDicDescF").val();  
		var BDPMapDExtDicCodeVal=$('#BDPMapDExtDicCode').val(); 
		var BDPMapDExtDicDescVal=$('#BDPMapDExtDicDesc').val();
		if (BDPMapDHisDicCodeVal=="")
        {
            $.messager.alert('错误提示','HIS代码不能为空!',"error");
            return false;
        } 
		if (BDPMapDHisDicDescVal=="")
        {
            $.messager.alert('错误提示','HIS名称不能为空!',"error");
            return false;
        } 		
		if (BDPMapDExtDicCodeVal=="")
        {
            $.messager.alert('错误提示','外部代码不能为空!',"error");
            return false;
        } 
		if (BDPMapDExtDicDescVal=="")
        {
            $.messager.alert('错误提示','外部名称不能为空!',"error");
            return false;
        }  
		$('#dicmap-form-save').form('submit', { 
			url: LOC_SAVE_ACTION_URL, 
			onSubmit: function(param){
			//	console.log(param)
				//  param.datalist = list; 
			},
			success: function (data) { 
			  var data=eval('('+data+')'); 
			  if (data.success == 'true') {
				$.messager.show({ 
					  title: '提示消息', 
					  msg: '提交成功', 
					  showType: 'show', 
					  timeout: 1000 
				}); 
				list="";
				$('#Tree').treegrid('reload');
				$('#myWin').dialog('close'); 
				var treerowid = data.id;
				$('#DataGrid').datagrid('options').queryParams.dictorydr = treerowid; 
				//动态列重新加载后刷新datagrid
				$('#DataGrid').datagrid('reload'); 
				$('#Tree').treegrid('reload');
			  } 
			  else { 
				list="";
				$('#Tree').treegrid('reload');
				var errorMsg ="更新失败！"
				if (data.errorinfo) {
					errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
				}
				$.messager.alert('操作提示',errorMsg,"error");
			} 
		} 
	 });  
	 
   }
  
	///  字典对照  删除 
	var DeleteDicMapFun=function(){ 
		var row = $("#DataGrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.BDPMapDRowId; 
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				$.ajax({
					url:DELETE_LOCCTION_URL,  
					data:{"id":rowid},  
					type:"POST",    
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
								 $.messager.show({ 
								  title: '提示消息', 
								  msg: '删除成功', 
								  showType: 'show', 
								  timeout: 1000, 
								  style: { 
									right: '', 
									bottom: ''
								  } 
								});  
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								 $('#DataGrid').datagrid('reload');  // 重新载入当前页面数据 
								 $('#DataGrid').datagrid('unselectAll');  // 清空列表选中数据
								 $('#Tree').treegrid('reload');
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
   
	 
     // 字典数据列表
  	$('#DataGrid').datagrid({ 
                height: 300,
                nowrap: false,
                striped: true,
                border: true,  
                fit: true,//自动大小
                url: $URL, 
				 queryParams:{
					ClassName:"web.DHCBL.CT.BDPBaseDataMapDetail",
					MethodName:"GetList",
					//QueryName:"GetList"
				}, 
				idField: 'BDPBaseDMRowId',
                checkOnSelect: false,
                selectOnCheck: false,
                singleSelect: true,//是否单选
                pagination: true,//分页控件
                rownumbers: true,//行号 
                columns: [[               
				    { field: 'BDPMapDRowId', title: 'ID', width: 30,hidden:true }, 
				    { field: 'BDPMapDHisDicCode', title: 'HIS代码', width: 150 },
				    { field: 'BDPMapDHisDicDesc', title: 'HIS名称', width: 150 },  					
					{ field:'BDPMapDExtDicCode',title:'外部代码',width:150},  					
					{ field:'BDPMapDExtDicDesc',title:'外部名称',width:150},  					
					{ field:'BDPMapDHisFlag',title:'外部到HIS对照',width:120,formatter:ReturnFlagIcon} , 
					{ field:'BDPMapDActive',title:'有效标志',width:90,formatter:ReturnFlagIcon}, 
					{ field: 'BDPBaseDMCode', title: '所属系统', width: 150 },
				    { field: 'BDPBaseDMDesc', title: '表名称', width: 150 }, 
					{ field: 'BDPMapDTableCode', title: '字典表或文本型代码', width: 150 }
				]] ,
				onDblClickRow:function(index,row)
				{ 
					ModifyDicMapFun(); 
				},
            });
     
    //设置分页控件
  	$('#DataGrid').datagrid('getPager').pagination({
        pageSize: 50,//每页显示的记录条数，默认为10
        pageList: [50, 100, 150],//可以设置每页记录条数的列表
        beforePageText: '第',//页数文本框前显示的汉字
        afterPageText: '页    共 {pages} 页',
        displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录',
    });
   
   
  ///删除字典数据
function DelData(){
    var row = $("#DataGrid").datagrid("getSelected"); 
    if (!(row))
    {   
		$.messager.alert('错误提示','请先选择一条记录!',"error");
        return false;
    }
	$.messager.confirm("提示", "确定删除数据?", function (r) {
		if (r) { 		
			var rowid=row.BDPBaseDMRowId; 
			$.ajax({
				url:DELETE_ACTION_URL,  
				data:{"id":rowid},  
				type:"POST",   
				success: function(data){
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
							$.messager.show({ 
							  title: '提示消息', 
							  msg: '删除成功', 
							  showType: 'show', 
							  timeout: 1000 
							}); 
							$('#DataGrid').datagrid('reload');  // 重新载入当前页面数据  
							$('#DataGrid').datagrid('unselectAll');
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
		} else {
			$('#DataGrid').datagrid('reload');  // 重新载入当前页面数据  
			$('#DataGrid').datagrid('unselectAll');
		}
	}); 
} 
 
///新增下级节点属性
 function ToolbarAddProperty(){  
		$('#BDPBaseDMParentDRF').combotree('setValue',treeid);  
  	    $("#myWin2").show(); 
  	    $("#BDPBaseDMRowIdF").val("");
        $("#BDPBaseDMRowId").val("");
        $("#BDPBaseDMCodeF").val("");
        $("#BDPBaseDMDescF").val("");
	    $('#BDPBaseDMDateFromF').datebox('setValue','');
		$('#BDPBaseDMDateToF').datebox('setValue',''); 
		$('#BDPBaseDMParentDRF').combotree('reload');			
        $("#BDPBaseDMParentDRF").val(treeid);  // 所属目录
        $('#DPBaseDMTypeF').combobox('setValue',''); 
		$('#BDPBaseDMTableDRF').combobox('setValue',''); 
        var myWin = $HUI.dialog("#myWin2",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'新增',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存', 
                id:'save_btn',
                handler:function(){
                    SaveFunLib("","Next")
                }
            },{
                text:'关闭', 
                handler:function(){
                    myWin.close();
                }
            }] 
        }); 
  } 
   
///新增下级节点属性
AddProperty =function (){ 
		$('#BDPBaseDMParentDRF').combotree('setValue',treeid)
  	    $("#myWin2").show();  
        $("#BDPBaseDMRowIdF").val("");
        $("#BDPBaseDMCodeF").val("");
        $("#BDPBaseDMDescF").val(""); 
		$('#DPBaseDMTypeF').combobox('setValue',''); 
		$('#BDPBaseDMTableDRF').combobox('setValue','');
		$('#BDPBaseDMParentDRF').combotree('reload');			
        $("#BDPBaseDMParentDRF").val(treeid);  // 所属目录
       
        var myWin = $HUI.dialog("#myWin2",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'新增',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存', 
                id:'save_btn',
                handler:function(){
                    SaveFunLib("","Next")
                }
            },{
                text:'关闭', 
                handler:function(){
                    myWin.close();
                }
            }] 
        }); 
  }  	
    
};
$(init);
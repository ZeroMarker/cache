 /*
	Function:通用字典
	Creator: sunfengchao
	CreateDate:2018-09-15
 */
 var DELETE_TreeACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDataDictionary&pClassMethod=DeleteDicData";
 var TREE_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDataDictionary&pClassMethod=GetDictionaryTreeList";
 /// 所属目录的下拉树 url
 var COMBOTREE_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDataDictionary&pClassMethod=GetComboTreeList";
 var SAVE_DATA_ACTION_URL =  "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPDataDictionary&pClassMethod=SaveData&pEntityName=web.Entity.BDP.BDPDataDictionary";
 /// 新增字典时的配置列表
 var SAVE_ACTION_URL =  "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPDataDictionary&pClassMethod=SaveData&pEntityName=web.Entity.BDP.BDPDataDictionary";
 var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDataDictionary&pClassMethod=DeleteData";
 var DELETE_PROPERTY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDictionaryConfig&pClassMethod=RemoveProperty";
 var COMBO_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDictionaryConfig&pClassMethod=GetComboDataList";
 var init = function(){
 var treeid = "";
 var list="";
 var datasourse="";
 var columns=new Array();
// 重写disableItem方法和enableItem方法。
/**
 * menu方法扩展
 * @param {Object} jq
 * @param {Object} itemEl
 */
$.extend($.fn.menu.methods, {
    /**
     * 激活选项（覆盖重写）
     * @param {Object} jq
     * @param {Object} itemEl
     */
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
  
	///表结构登记的下拉框
	$HUI.combobox("#BDPMenu",{
		valueField:'ID',
		textField:'TableDesc',
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataDictionary&QueryName=GetTableList&ResultSetType=array"
	});
 
	///父菜单
	$HUI.combotree('#BDPParentMenuDR',{
		url:COMBOTREE_ACTION_URL
	});

	/// 左侧 搜索框响应 
	$('#TextDicDesc').searchbox({ 
		searcher:SearchDicFun
	});
	
	 /// 父表菜单搜索
	 function SearchDicFun(){
		var SearchContent = $("#TextDicDesc").searchbox('getValue');
		$("#Tree").treegrid("search", SearchContent) 
	 }

 	/// 左侧 清屏按钮
	$("#btnDicRefresh").click(function (e) { 
		$('#TextDicDesc').searchbox('setValue',''); 
		$("#Tree").treegrid('reload');  
	 }) 
	
	
  	/// 搜索按钮
  	$("#btnSearch").click(function (e) {
		SearchData();
	})
	/// 右侧  清屏按钮
	$("#btnRefresh").click(function (e) { 
		ClearData();
	 }) 
	 
	/// 右侧 新增按钮
	$("#add_btn").click(function (e) {   
		ToolbarAddProperty(); 
	 })
	 
	 ///属性 修改
	$("#update_btn").click(function (e) {  
		UpdateProperty();
	 })  
	 
	///属性 删除
	$("#del_btn").click(function (e) {  
		removes();
	 });
	  
	 ///  右侧 新增
	 $("#data_addbtn").click(function(){ 
	 	 AddData();
	 });
	 /// 右侧 修改
	 $("#data_updatebtn").click(function(){
	 	 UpdateData(); 
	 });
	 /// 右侧 删除 
	 $("#data_delbtn").click(function(){
	 	 DelData();
	 }); 
	 
	 /// 下载数据模板
	 $("#import_template_btn").click(function(){
	 	DownloadTemplate();
	 });
	 /// 数据导入
	 $("#import_btn").click(function(){
	 	ImportData();
	 });
	 ///数据导出
	 $("#export_btn").click(function(){
	 	ExportData();
	 });
	
	$('#TextCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchData();
		}
		if(event.keyCode == 27) {
		  ClearData();
		}  
	});  
	$('#TextDesc').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchData();
		}
		if(event.keyCode == 27) {
		  ClearData();
		}  
	});   
	 //属性查询方法
	function SearchData(){
		var code=$.trim($("#TextCode").val());
		var desc=$.trim($("#TextDesc").val());
		$('#DataGrid').datagrid('load',  { 
			ClassName:"web.DHCBL.BDP.BDPDataDictionary",
			QueryName:"GetList",
			'dictorydr':treeid,
			'code':code,
			'desc':desc
		});
		$('#mygridProperty').datagrid('unselectAll');
	}
	//属性清屏方法
	function ClearData(){
		$("#TextDesc").val('');
		$('#DataGrid').datagrid('load',  { 
			ClassName:"web.DHCBL.BDP.BDPDataDictionary",
			QueryName:"GetList",
			'dictorydr':treeid,
			'code':"",
			'desc':""
		});
		$('#mygridProperty').datagrid('unselectAll');
	}
	
	
 	
	
	/// 下载数据模板
	function DownloadTemplate(){
		if (treeid=="")
		{
			$.messager.alert('错误提示','请先选择左侧目录字典!',"error");
		}
		else{
			var rtn = tkMakeServerCall("web.DHCBL.BDP.BDPDictionaryConfig","ProductTemplate","BDPDicTemplate",treeid); 
			location.href = rtn;
		}
	}
 
  	
	/// 导入操作
	function ImportData(){
		if (treeid=="")
		{
			$.messager.alert('错误提示','请先选择左侧目录字典!',"error");
		}
		else{  
			/// 根据权限去判断 是否可以导入数据 与新增数据时的权限相同
			var Flag= tkMakeServerCall("web.DHCBL.BDP.BDPDataDictionary","AllowAddDataFlag",treeid);
			if (Flag==1){
				$.messager.alert('错误提示','此目录不允许导入字典数据,请选择左侧字典再做导入操作!',"error");
				return false;
			}
			$("#importExcel").dialog({
				iconCls:'icon-w-import',
				resizable:true, 
				height:390,
				modal:true  , 
				buttons:[{
                    text:'导入',
					style:'marginTop:10px;',					
                    id:'importdata_btn',
                    handler:function(){  
                    	uploadExcel() 
                    }
                },{
                    text:'取消', 
					style:'marginTop:10px;',
                    id:'importdata_btn',
                    handler:function(){  
						$("#importExcel").dialog("close");
                    }
                }]
			});  
		}
	}	
		
	function uploadExcel() { 
		var efilepath=$('#ExcelImportPath').val();  //要导入的模板 
 		if (efilepath){
			if(efilepath.indexOf("fakepath")>0 ) {
				$.messager.alert('错误提示', '请在IE下执行导入！',"error");   
				return;
			}
			if((efilepath.indexOf(".xls")<=0) &&(efilepath.indexOf(".csv")<=0)) { 
				$.messager.alert('错误提示', '文件类型不正确,请选择.xls文件！',"error");  
				return;
			} 
			else{  
				var kbclassname=""  //类名
				var sheet_id =1;
				var file=efilepath.split("\\");
				var filename=file[file.length-1];  
				try{ 
					var oXL = new ActiveXObject("Excel.application"); 
					var oWB = oXL.Workbooks.open(efilepath);  	
				}		
				catch(e){
					var emsg="请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
					$.messager.alert('提示',emsg,"error"); 
					return;
				}
				
				$('#importload').dialog({ 
					resizable:true, 
					modal:true  
				});  
				$('#importload').dialog('open'); //显示进度条 
			
				var errorRow="";//没有插入的行
				var errorMsg="";//错误信息
				oWB.worksheets(sheet_id).select(); 
				var oSheet = oWB.ActiveSheet; 
				var rowcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Rows.Count ; /// 行数
				var colcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Columns.Count ; ///列数
				var ProgressText='';
				for (row=2;row<=rowcount;row++){ 
					var tempStr = ""; //每行数据（第一列[next]第二列[next]...）
					var i=row
					
					for (var j=1;j<=colcount;j++){
						var cellValue=""
						if(typeof(oSheet.Cells(i,j).value)=="undefined"){
							cellValue=""
						}	
						else{
							cellValue=oSheet.Cells(i,j).value
						}
						tempStr+=(cellValue+"#") 	
					}	 
					var kbclassname ="web.DHCBL.BDP.BDPDictionaryConfig";
					var Flag =tkMakeServerCall(kbclassname,"ImportExcel",treeid,tempStr); 
					if (Flag.indexOf("true")>0){
						errorRow=errorRow
					}
					else{
						if(errorRow!=""){
							errorRow=errorRow+","+i
						}else{
							errorRow=i
						}
					}
					tempStr="";  
					progressText = "正在导入"+oSheet.name+"表的第"+row+"条记录,总共"+rowcount+"条记录!";  
					setInterval(function(){  
					 	$('#pro').progressbar('setValue',row/rowcount*100);  
					  	$('#pro').attr('text',progressText); 
					}, 1000);  
					if(row==rowcount) //当到达最后一行退出
				  	{ 
				  		if(errorRow!=""){
							errorMsg=oSheet.name+"表导入完成，第"+errorRow+"行插入失败!" ;			
						}else{
							errorMsg=oSheet.name+"表导入完成!"
						}
					 	$('#pro').progressbar('setValue', 100); 
					 	progressText = "正在导入"+oSheet.name+"表的记录,总共"+rowcount+"条记录!";  
					 	$('#pro').attr('text', progressText);   
  
						oWB.Close(); 
						oXL.Quit(); 
						oXL=null;
						oSheet=null; 
						if (errorRow!=""){
							$.messager.alert('错误提示',errorMsg,"error"); 
						}else{
							$.messager.alert('提示',errorMsg,"success"); 
						}
					    $('#importload').window('close'); 
				  	}  
				  $('#importExcel').window('close'); 
				} 
		  	}
		}
		else{
			$.messager.alert('错误提示', '请选择将要上传的文件!',"error");    
		}
	}
	 
	
	/// 导出操作
	function ExportData(){
		if (treeid=="")
		{
			$.messager.alert('错误提示','请先选择左侧目录字典!',"error");
		}
		else{
			var rtn = tkMakeServerCall("web.DHCBL.BDP.BDPDictionaryConfig","ExportToExcel","BDPDictory","web.DHCBL.BDP.BDPDataDictionary","GetList",treeid);
			location.href = rtn;
		}
    }
 //动态添加列，将字符串转换为datagrid的column的data
 function covertHeader(headerString){
 	 	var colObjArr=[
		    { field: 'BDPDictionaryRowId', title: 'ID', width: 30,hidden:true },
		    { field: 'BDPDictionaryCode', title: '代码', width: 120 },
		    { field: 'BDPDictionaryDesc', title: '描述', width:120 },
		    { field: 'BDPDictionaryDateFrom', title: '开始日期', width: 120 },
		    { field: 'BDPDictionaryDateTo', title: '结束日期', width: 120 }
		]
        if(headerString){
            var headArr = headerString.split('^');
            for(var i = 0;i < headArr.length; i++) {
                var fieldName = headArr[i];
                //创建一个column列对象
                var colObj = new Object();
                //设置field属性
                if (fieldName!==""){
                	colObj['field'] = "BDPDictionaryText"+(i+1);
	                //设置title属性
	                colObj['title'] = fieldName;
	                colObj['width'] = '120';
	                colObj['align'] = 'center';
	                //将创建的column列对象添加到columns集合
	                colObjArr.push(colObj); 
                }
               else{
               		continue
               }
            }
        }
        return colObjArr;
    }   
     
///删除左侧树形数据  
removes=function(){
	$.messager.confirm("提示", "确定删除该目录?", function (r) {
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
		$("#dictab").tabs('select',0);     
		$('#BDPParentMenuDR').combotree('reload'); ///上级分类
		if ($('#BDPParentMenuDR').combotree('getText')=='')
		{
			$('#BDPParentMenuDR').combotree('setValue','')
		}
        if (treeid!==""){   
            $.cm({   //调用后台openData方法给表单赋值
                ClassName:"web.DHCBL.BDP.BDPDataDictionary",
                MethodName:"NewOpenData",
                id:treeid
            },function(jsonData){ 
                //给是否可用单独赋值    
                if (jsonData.BDPExtMenuDr==""){ 
                	$HUI.checkbox("#BDPConfigFlag").setValue(false); 
					$("#dictab").tabs('enableTab',1);   
                }else{  
                	$HUI.checkbox("#BDPConfigFlag").setValue(true);   
					$("#dictab").tabs('disableTab',1);  // 根据表结构登记生成扩展字段  第二个选项卡面板 不可用 
				}  
                $('#form-save2').form("load",jsonData);  
				
            });
            $('#PropertyGrid').datagrid('options').queryParams.dictorydr = treeid;
            $('#PropertyGrid').datagrid('reload');  
            $("#dlgEdit").show(); 
            var myWin = $HUI.dialog("#dlgEdit",{
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

 
 ///新增 左侧同级字典
AddTJProperty =function (){ 
		///上级分类
		$('#BDPParentMenuDR').combotree('setValue',"");
		$('#datefrom2').datebox('setValue','');
		$('#dateto2').datebox('setValue','');
		var menudr=tkMakeServerCall("web.DHCBL.BDP.BDPDataDictionary","GetMenuDR",treeid) 
	    $('#BDPParentMenuDR').combotree('setValue',menudr); // treeid)
  	    $("#dlgEdit").show(); 
  	    $("#BDPDictionaryRowIdF2").val("");
        $("#BDPDictionaryRowId").val("");
        $("#BDPDictionaryCodeF2").val("");
        $("#BDPDictionaryDescF2").val("");
		$("#datefrom2").datebox('setValue', '');	 
		$("#dateto2").datebox('setValue', '');	 
        $('#PropertyGrid').datagrid('options').queryParams.dictorydr ="";
        $('#ExtendGrid').datagrid('options').queryParams.dictorydr = "";
        $('#ExtendGrid').datagrid('reload');
        $('#PropertyGrid').datagrid('reload'); 
		$('#BDPParentMenuDR').combotree('reload');	
        $("#BDPParentMenuDR").val(treeid);  // 所属目录
		$('#BDPMenu').combobox('setValue',""); /// 扩展字段来源	 
		$("#dictab").tabs('enableTab', 1); 
        $('#BDPConfigFlag').checkbox({
			onChecked: function(){
				 $("#dictab").tabs('disableTab', 1); // 禁用第二个选项卡面板
			},
			onUnchecked :function(){  /// 取消选中时触发 
				 $("#dictab").tabs('enableTab', 1); 
			}
		});
        var myWin = $HUI.dialog("#dlgEdit",{
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
        var code=$.trim($("#BDPDictionaryCodeF2").val());
        var desc=$.trim($("#BDPDictionaryDescF2").val());
        var datefrom =$("#datefrom2").datebox('getValue');
		var dateto =$("#dateto2").datebox('getValue'); 
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
        if (datefrom=="")
        {
            $.messager.alert('错误提示','开始日期不能为空!',"error");
            return false;
        }
		if (datefrom != "" && dateto != "") {
			var dateflag= tkMakeServerCall("web.DHCBL.BDP.BDPDataDictionary","CompareDate",datefrom,dateto) 
			if(dateflag==1){  
				$.messager.alert('错误提示','开始日期不能大于结束日期!',"error");
				return false;
			}
		}
        /// 可编辑状态 中止
	    if (Propertyindexs!==""){
        	$('#PropertyGrid').datagrid('endEdit', Propertyindexs);
        }
        var  rvalue="";
        rvalue=$HUI.checkbox("#BDPConfigFlag").getValue(); 
        if (rvalue==true){ 
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
		                $('#dlgEdit').dialog('close'); 
		                var treerowid = data.id;
			            $('#DataGrid').datagrid('options').queryParams.dictorydr = treerowid;
			            /// 点击根节点的时候 动态加载 datagrid
			            var datalist= tkMakeServerCall("web.DHCBL.BDP.BDPDictionaryConfig","GetColumnName",treerowid);
			          	var colObjArr=covertHeader(datalist);
			            //动态加载动态列
			            var options={};  
			            options.columns = [colObjArr];
			            $('#DataGrid').datagrid(options);    
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
        else{
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
		                $('#dlgEdit').dialog('close');  
		                var treerowid = data.id;
			            $('#DataGrid').datagrid('options').queryParams.dictorydr = treerowid;
			            /// 点击根节点的时候 动态加载 datagrid
			            var datalist= tkMakeServerCall("web.DHCBL.BDP.BDPDictionaryConfig","GetColumnName",treerowid);
			          	var colObjArr=covertHeader(datalist);
			            //动态加载动态列
			            var options={};  
			            options.columns = [colObjArr];
			            $('#DataGrid').datagrid(options);    
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
		height: 'auto',
		fit:true,
		idField: 'id',
		treeField:'text',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
		animate:false,    
		onContextMenu: function(e, row){ 
				e.preventDefault();
        	 	$(this).treegrid('select', row.id);
			    $('#TreeMenu').menu('show',{
                    left: e.pageX,
                    top: e.pageY,
                    noline: true
               }); 
			   // var Flag= tkMakeServerCall("web.DHCBL.BDP.BDPDataDictionary","AllowAddDictionFlag",treeid); 
			   var Flag=tkMakeServerCall("web.DHCBL.BDP.BDPDataDictionary","AllowAddNexNode",treeid);
			 
			   if (Flag==0){
				  $('#TreeMenu').menu('enableItem',$('#PropertyAddNextSelf'));
				  $('#TreeMenu').menu('enableItem',$('#PropertyAddSelf'));				  
			   }
			   else{  
				  $('#TreeMenu').menu('disableItem',$('#PropertyAddNextSelf'));
				  $('#TreeMenu').menu('enableItem',$('#PropertyAddSelf'));
			   }
          },
		onDblClickRow:function(index,row)
		{  
			UpdateProperty(); 
		},
		onSelect:function(rowIndex,rowData){  
    		treeid = rowIndex;
            $('#DataGrid').datagrid('options').queryParams.dictorydr = treeid;
            /// 点击根节点的时候 动态加载 datagrid 
            var datalist= tkMakeServerCall("web.DHCBL.BDP.BDPDictionaryConfig","GetColumnName",treeid); 
          	var colObjArr=covertHeader(datalist);
            //动态加载动态列
            var options={};  
            options.columns = [colObjArr];
            $('#DataGrid').datagrid(options);    
            //动态列重新加载后刷新datagrid 
            $('#DataGrid').datagrid('reload'); 
        } 
	});
 
     // 字典数据列表
  	$('#DataGrid').datagrid({
                width: 500,
                height: 'auto',
                nowrap: false,
                striped: true,
                border: true,
                collapsible: false,//是否可折叠的
                autoScroll:true,
                fit: true,//自动大小
                url: $URL,
				 queryParams:{
					ClassName:"web.DHCBL.BDP.BDPDataDictionary",
					QueryName:"GetList"
				}, 
				idField: 'BDPDictionaryRowId',
                checkOnSelect: false,
                selectOnCheck: false,
                singleSelect: true,//是否单选
                pagination: true,//分页控件
                rownumbers: true,//行号
                columns: [[
				    { field: 'BDPDictionaryRowId', title: 'ID', width: 30,hidden:true },
				    { field: 'BDPDictionaryCode', title: '代码', width: 120 },
				    { field: 'BDPDictionaryDesc', title: '描述', width: 120 },
				    { field: 'BDPDictionaryDateFrom', title: '开始日期', width: 120 },
				    { field: 'BDPDictionaryDateTo', title: '结束日期', width: 120 }
				]] ,
				onDblClickRow:function(index,row)
				{ 
					UpdateData(); 
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
  
 /// 弹出窗口新增数据时的 query列表
  var Propertyindexs="";
  var editBoxing = undefined;
  $('#PropertyGrid').datagrid({ 
         url: $URL,
         queryParams:{
            ClassName:"web.DHCBL.BDP.BDPDataDictionary",
            QueryName:"GetPropertyConfigList"
        }, 
		fitColumns:true,
        singleSelect : true,
        height:300,
        idField : 'id',
        columns : [ [ {   
            field : 'BDPRowId',
            title : 'BDPRowId',
            hidden:true,
            width : 100 
        }, {
            field : 'BDPCode',
            title : '字段代码',
            width :220 
        }, {
            field : 'BDPValue',
            title : '字段名称',
            width : 150,
            align : 'right',
            editor : {
                type : "validatebox" 
            }
        }, {
            field : 'BDPPropertyType',
            title : '字段类型',
            width : 120,
            align : 'right',
            editor : {
                  type : 'combobox',
                  options : {
                      data:[{
							text: 'String',
							value: 'String'
						},{
							text: 'Date',
							value: 'Date'
						} ,{
							text: 'TextArea',
							value: 'TextArea'
						} ,{
							text: 'DR',
							value: 'DR'
						},{
							text: 'Y/N',
							value: 'Y/N'
						} ,{
							text: 'Integer',
							value: 'Integer'
						}],
			          valueField : 'value',
                      textField : 'text',
                      method : 'get',
                      editable : false,
					  onSelect:function(data){  
                        var row = $('#PropertyGrid').datagrid('getSelected'); 
						var rowIndex = $('#PropertyGrid').datagrid('getRowIndex',row);//获取行号  
                        var thisTarget = $('#PropertyGrid').datagrid('getEditor', {'index':rowIndex,'field':'BDPDRSource'}).target; 
						var thisTarget2 = $('#PropertyGrid').datagrid('getEditor', {'index':rowIndex,'field':'BDPDRCode'}).target; 	
						var e = $("#PropertyGrid").datagrid('getColumnOption', 'BDPDRSource');  
						if (data.value=="DR"){   
							thisTarget.combobox("enable"); 
							thisTarget2.combobox("enable");
						}else{ 
							thisTarget.combobox('setValue','');
							thisTarget2.combobox('setValue','');
							thisTarget.combobox("disable");  
							thisTarget2.combobox("disable");
                       }  
                    }  
                }
              }
        } , {
            field : 'BDPDRSource',
            title : '指向表来源',
            width : 150,
            align : 'right',
            editor : {
                type : "combobox" ,
                options : {
                      data:[{
							text: '表结构登记',
							value: 'BDPTableList'
						},{
							text: '通用字典',
							value: 'BDPDictionary'
						}],
			          valueField : 'value',
                      textField : 'text',
                      method : 'get',
                      editable : false , 
                      onSelect:function(data){  
                        var row = $('#PropertyGrid').datagrid('getSelected');  
                        var rowIndex = $('#PropertyGrid').datagrid('getRowIndex',row);//获取行号  
                        var thisTarget = $('#PropertyGrid').datagrid('getEditor', {'index':rowIndex,'field':'BDPDRSource'}).target;  
                        var value = thisTarget.combobox('getValue');  
                        datasourse =value; 
                        var target = $('#PropertyGrid').datagrid('getEditor', {'index':rowIndex,'field':'BDPDRCode'}).target;  
                       // target.combobox('clear'); //清除原来的数据  
                       if (value=="BDPTableList"){
                       		var url=$URL+"?ClassName=web.DHCBL.BDP.BDPDataDictionary&QueryName=GetTableList&ResultSetType=array";
                       }else if (value=="BDPDictionary"){ 
                       		var url=$URL+"?ClassName=web.DHCBL.BDP.BDPDataDictionary&QueryName=GetDataForCmb1&ResultSetType=array";
                       }
                       target.combobox('reload', url);//联动下拉列表重载  
                    }   
              }
           },
		   formatter: function(value,row,index){
				if (value=="BDPTableList"){
					return "表结构登记";
				} else if (value=="BDPDictionary") {
					return "通用字典";
				}else{
					return value ;
				}
		  } 
        }  , {
            field : 'BDPDRCode',
            title : '指向表',
            width : 150,
            align : 'right',
            editor : {
                type : 'combobox',    
                options : {    
                    url:'',  
                    valueField:'ID',
 					textField:'TableDesc',
 					onBeforeSelect:function(data){  
                        var row = $('#PropertyGrid').datagrid('getSelected');  
                        var rowIndex = $('#PropertyGrid').datagrid('getRowIndex',row);//获取行号  
                        var thisTarget = $('#PropertyGrid').datagrid('getEditor', {'index':rowIndex,'field':'BDPDRSource'}).target;  
                        var value = thisTarget.combobox('getValue');  
                          
                        var target = $('#PropertyGrid').datagrid('getEditor', {'index':rowIndex,'field':'BDPDRCode'}).target;  
                       // target.combobox('clear'); //清除原来的数据  
                       if (value=="BDPTableList"){
                       		var url=$URL+"?ClassName=web.DHCBL.BDP.BDPDataDictionary&QueryName=GetTableList&ResultSetType=array";
                       }else if (value=="BDPDictionary"){ 
                       		var url=$URL+"?ClassName=web.DHCBL.BDP.BDPDataDictionary&QueryName=GetDataForCmb1&ResultSetType=array";
                       }
                       target.combobox('reload', url);//联动下拉列表重载  
                    }
                }
            },
		   formatter: function(value,row,index){  
				if(parseInt(value)>0){  
					var DataValue=tkMakeServerCall("web.DHCBL.BDP.BDPDataDictionary","GetDescByRowId",datasourse,value);		
					if (DataValue!==""){
						return DataValue;
					}
				}
				else{
					return value ;
				}
		  } 
        }   
      ] 
    ],
        loadFilter : function(data) {  
            var data_ = {
                "rows" : data.rows,
                "total" : data.total
            };
            return data_;
        },
        toolbar : [{
            text : '删除字段',
            iconCls : 'icon-cancel',
            handler : function() {
                var row = $("#PropertyGrid").datagrid("getSelected"); 
		        if (!(row))
		        {  
					$.messager.alert('错误提示','请先选择一条记录!',"error");
		            return;
		        }
        		var index=row.BDPRowId;
        		$.ajax({
		            url:DELETE_PROPERTY_ACTION_URL,  
		            data:{
		            	  idstr:treeid+"^"+index
		            },
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
		                        $('#PropertyGrid').datagrid('reload');  // 重新载入当前页面数据  
		                        $('#PropertyGrid').datagrid('unselectAll');
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
        },{
            text : '取消编辑',
            iconCls : 'icon-redo',
            handler : function() {
                if (editBoxing == 0) {
                    $('#PropertyGrid').datagrid('deleteRow', editBoxing);
                    editBoxing = undefined;
                    $('#PropertyGrid').datagrid('reload');
                } else {
                    editBoxing = undefined;
                    $('#PropertyGrid').datagrid('reload');
                }
            }
        } ],
        onDblClickCell : function(index, field, value) {  
            if(Propertyindexs!==""){
	             $(this).datagrid('endEdit', Propertyindexs);
	          }
	          $(this).datagrid('beginEdit', index);
	          Propertyindexs=index; 
			  var thisTarget = $('#PropertyGrid').datagrid('getEditor', {'index':index,'field':'BDPDRSource'}).target;  
			  var thisTarget2 = $('#PropertyGrid').datagrid('getEditor', {'index':index,'field':'BDPDRCode'}).target; 
			  var thisTarget3 = $('#PropertyGrid').datagrid('getEditor', {'index':index,'field':'BDPPropertyType'}).target; 
			  var value = thisTarget3.combobox('getValue');   
			  if (value=="DR"){
				thisTarget.combobox("enable");  
				thisTarget2.combobox("enable"); 
			  }else{
				thisTarget.combobox("setValue","");
				thisTarget2.combobox("setValue",""); 
				thisTarget.combobox("disable");  
				thisTarget2.combobox("disable"); 
			  }   
	    }, 
	    onAfterEdit : function(index, row, changes) {
	        if(JSON.stringify(changes)!="{}"){ 
				if(list!==""){
				    list=list+'#'+row.BDPRowId+"^"+row.BDPValue+"^"+row.BDPPropertyType+"^"+row.BDPDRSource+"^"+row.BDPDRCode;   
				}
				else{
					list=row.BDPRowId+"^"+row.BDPValue+"^"+row.BDPPropertyType+"^"+row.BDPDRSource+"^"+row.BDPDRCode;   
				}  
	        }  
        }
    }); 
  /// 动态实现 控件的生成
  function AddColumnType(rowIndex){
     $('#ExtendGrid').datagrid('selectRow', rowIndex);
     var row = $('#ExtendGrid').datagrid('getSelected');
     var BDPPropertyType = row.BDPPropertyType;
     var TableName=row.BDPPropertyDRCode;
     var DataSource=row.BDPDataSource;
    //判断 类型
    if ((BDPPropertyType=="ComboBox")||(BDPPropertyType=="DR")){ 
    	$("#ExtendGrid").datagrid('addEditor', {
              field : 'BDPValue',
              editor : {
                  type : 'combobox',
                  options : {
                  	  url:$URL+"?ClassName=web.DHCBL.BDP.BDPDictionaryConfig&QueryName=GetComboDataList&ResultSetType=array&DataSource="+DataSource+"&TableID="+TableName,
                      valueField : 'ID',
                      textField : 'PropertyDesc',
                      method : 'get',
                      editable : false
                 }
              }
         });
    }
 	else if (BDPPropertyType=="Date"){
        	$("#ExtendGrid").datagrid('addEditor', {
        		field : 'BDPValue',
            	editor : {
               		type : 'datebox' 
            	}
         });
   } 
   else if (BDPPropertyType=="TextArea"){
        	$("#ExtendGrid").datagrid('addEditor', {
        		field : 'BDPValue',
            	editor : {
               		type : 'textarea' 
            	}
         });
   } 
   else if (BDPPropertyType=="Y/N"){   
        	$("#ExtendGrid").datagrid('addEditor', {
        		field : 'BDPValue',
            	editor : {
               		  type : 'combobox',
                  	  options : {
	                  	  data:[{
								text:'Y',
								value:'Y'
							},{
								text:'N',
								value: 'N'
						  }],
	                      valueField : 'value',
	                      textField : 'text',
	                      method : 'get',
	                      editable : false
	            	}
                }
         });
  }  
   else if (BDPPropertyType=="Integer"){
        	$("#ExtendGrid").datagrid('addEditor', {
        		field : 'BDPValue',
            	editor : {
               		type : 'numberbox' 
            	}
         });
   } 
  else{
 		$("#ExtendGrid").datagrid('addEditor', {
        		field : 'BDPValue',
            	editor : {
               		type : 'text' 
            	}
         });
 	}
  }  

/// 弹出窗口新增数据时的 query列表
  var indexs="";
  var listdata="";
  $('#ExtendGrid').datagrid({ 
         url: $URL,
         queryParams:{
            ClassName:"web.DHCBL.BDP.BDPDataDictionary",
            QueryName:"GetPropertyList"
        }, 
		fitColumns:true,
        singleSelect : true,
        height:300,
        idField : 'id',
        columns : [ [ {   
            field : 'BDPRowId',
            title : 'BDPRowId',
            hidden:true,
            width : 100 
        }, {
            field : 'BDPCode',
            title : '字段',
            width : 100 
        },{
        	field:'BDPPropertyType',
        	title:'字段类型',
        	width:50 ,
        	hidden:true
        },{
        	field:'BDPPropertyDRCode',
        	title:'字段指向表',
        	width:50,
        	hidden:true
        }, {
        	field:'BDPDataSource',
        	title:'数据来源',
        	width:50,
        	hidden:true
        },{
            field : 'BDPValue',
            title : '值',
            width : 100,
            align : 'right'  ,
            editor : {
                type : "validatebox" 
            }  
			,formatter: function(value,row,index){ 
				console.log(row)
				var BDPPropertyType=row.BDPPropertyType;
				if ((BDPPropertyType=="DR")&((parseInt(value)>0))){
					var BDPDataSource =row.BDPDataSource;  ///数据来源
					var BDPPropertyDRCode = row.BDPPropertyDRCode;  /// 指向表的id
					var BDPValue=row.BDPValue; /// 执向表里的数据的id
					var DataValue= tkMakeServerCall("web.DHCBL.BDP.BDPDictionaryConfig","GetValueDescByRowId",BDPDataSource,BDPPropertyDRCode,BDPValue);		
					if (DataValue!==""){
						return DataValue; 
					}
				}
				else{
					return value ;
				} 
		  }   
        }  ] ],  
        toolbar : [{
            text : '取消编辑',
            iconCls : 'icon-redo',
            handler : function() {
                if (editBoxing == 0) {
                    $('#ExtendGrid').datagrid('deleteRow', editBoxing);
                    editBoxing = undefined;
              		$('#DataGrid').datagrid('options').queryParams.dictorydr = treeid;
                    $('#DataGrid').datagrid('reload');
                } else {
                    editBoxing = undefined;
                    $('#DataGrid').datagrid('options').queryParams.dictorydr = treeid;
                    $('#ExtendGrid').datagrid('reload');
                }
            }
        } ],
        loadFilter : function(data) {  
            var data_ = {
                "rows" : data.rows,
                "total" : data.total
            };
            return data_;
        },
        onClickCell:function(index, field, value){ 
          if(indexs!==""){
             $(this).datagrid('endEdit', indexs);
          }
          $(this).datagrid('beginEdit', index);
          indexs=index;
        },
      onBeforeEdit:function(index,row){ 
             AddColumnType(index);    //编辑前设置单元格类型
        },
        onAfterEdit:function(index, row, changes){
          if(JSON.stringify(changes)!="{}"){
            if(listdata!==""){
	              listdata=listdata+'#'+row.BDPRowId+"^"+row.BDPValue  
	            }
	            else{
	              listdata=row.BDPRowId+"^"+row.BDPValue;
	          }
          }
        } 
    }); 
  
  ///修改数据
function UpdateData(){
		if (treeid==""){
	 		$.messager.alert('错误提示','请先选中左侧的字典!',"error");
	        return false;
	 	}
        var record = $("#DataGrid").datagrid("getSelected"); 
        if (record){            
             //调用后台openData方法给表单赋值
            var id = record.BDPDictionaryRowId;  
            $.cm({
                ClassName:"web.DHCBL.BDP.BDPDataDictionary",
                MethodName:"NewOpenData",
                id:id
            },function(jsonData){
                //给是否可用单独赋值             
                $('#form-save').form("load",jsonData);  
            });
            $('#ExtendGrid').datagrid('options').queryParams.dictorydr = treeid;
            $('#ExtendGrid').datagrid('options').queryParams.rowid = id;
            $('#ExtendGrid').datagrid('reload'); 
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
                    	SaveSelfFunLib(id)
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
  ///删除字典数据
function DelData(){
    var row = $("#DataGrid").datagrid("getSelected"); 
    if (!(row))
    {   $.messager.alert('错误提示','请先选择一条记录!',"error");
        return false;
    }
	$.messager.confirm("提示", "确定删除数据?", function (r) {
		if (r) { 		
			var rowid=row.BDPDictionaryRowId; 
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

/// 工具条 新增按钮的 响应

///新增下级节点属性
 function ToolbarAddProperty(){ 
		var Flag=tkMakeServerCall("web.DHCBL.BDP.BDPDataDictionary","AllowAddNexNode",treeid);
		if (Flag==1){
			$.messager.alert('错误提示','选中的目录字典不允许新增下级字典!',"error");
            return false; 
		}
		$('#BDPParentMenuDR').combotree('setValue',treeid); 
		$("#dictab").tabs('enableTab',1); 
  	    $("#dlgEdit").show(); 
  	    $("#BDPDictionaryRowIdF2").val("");
        $("#BDPDictionaryRowId").val("");
        $("#BDPDictionaryCodeF2").val("");
        $("#BDPDictionaryDescF2").val("");
	    $('#datefrom2').datebox('setValue','');
		$('#dateto2').datebox('setValue','');
        $('#PropertyGrid').datagrid('options').queryParams.dictorydr ="";
        $('#ExtendGrid').datagrid('options').queryParams.dictorydr = "";
        $('#ExtendGrid').datagrid('reload');
        $('#PropertyGrid').datagrid('reload'); 
		$('#BDPParentMenuDR').combotree('reload');			
        $("#BDPParentMenuDR").val(treeid);  // 所属目录
        $('#BDPConfigFlag').checkbox({
			onChecked: function(){
				 $("#dictab").tabs('disableTab', 1); // 禁用第二个选项卡面板
			},
			onUnchecked :function(){  /// 取消选中时触发 
				 $("#dictab").tabs('enableTab', 1); 
			}
		});
        var myWin = $HUI.dialog("#dlgEdit",{
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
		// var Flag= tkMakeServerCall("web.DHCBL.BDP.BDPDataDictionary","AllowAddDictionFlag",treeid);
		var Flag=tkMakeServerCall("web.DHCBL.BDP.BDPDataDictionary","AllowAddNexNode",treeid);	   
		if (Flag==1){
			$.messager.alert('错误提示','选中的目录字典不允许新增下级字典!',"error");
            return false; 
		}
		$("#dictab").tabs('enableTab', 1); 
		$('#BDPParentMenuDR').combotree('setValue',treeid)
  	    $("#dlgEdit").show(); 
  	    $("#BDPDictionaryRowIdF2").val("");
        $("#BDPDictionaryRowId").val("");
        $("#BDPDictionaryCodeF2").val("");
        $("#BDPDictionaryDescF2").val("");
        $('#PropertyGrid').datagrid('options').queryParams.dictorydr ="";
        $('#ExtendGrid').datagrid('options').queryParams.dictorydr = "";
        $('#ExtendGrid').datagrid('reload');
        $('#PropertyGrid').datagrid('reload'); 
		$('#BDPParentMenuDR').combotree('reload');			
        $("#BDPParentMenuDR").val(treeid);  // 所属目录
        $('#BDPConfigFlag').checkbox({
			onChecked: function(){
				 $("#dictab").tabs('disableTab', 1); // 禁用第二个选项卡面板
			},
			onUnchecked :function(){  /// 取消选中时触发 
				 $("#dictab").tabs('enableTab', 1); 
			}
		});
        var myWin = $HUI.dialog("#dlgEdit",{
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
  
  /// 新增 字典数据
 function AddData() { 
	 	if (treeid==""){
	 		$.messager.alert('错误提示','请先选中左侧的字典!',"error");
	        return false;
	 	}
		var Flag= tkMakeServerCall("web.DHCBL.BDP.BDPDataDictionary","AllowAddDataFlag",treeid);
		if (Flag==1){
			$.messager.alert('错误提示','树形目录不允许新增字典数据,请选择左侧字典再新增数据!',"error");
            return false;
		}
        $("#myWin").show(); 
        $("#BDPDictionaryRowId").val("");
        $("#BDPDictionaryCode").val("");
        $("#BDPDictionaryDesc").val("");
        $("#BDPDictionaryDR").val(treeid);
        $('#BDPDictionaryDateFrom').datebox('setValue', '');	
        $('#BDPDictionaryDateTo').datebox('setValue', '');
        $('#ExtendGrid').datagrid('options').queryParams.dictorydr = treeid;
        $('#ExtendGrid').datagrid('options').queryParams.rowid="";
        $('#ExtendGrid').datagrid('reload');
        
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
                    SaveSelfFunLib("")
                }
            },{
                text:'关闭', 
                handler:function(){
                    myWin.close();
                }
            }] 
        });  
    }
 
 	///新增、更新 字典里的数据
    function SaveSelfFunLib(id)
    {       
        var code=$.trim($("#BDPDictionaryCode").val());
        var desc=$.trim($("#BDPDictionaryDesc").val());
        var datefrom =$("#BDPDictionaryDateFrom").datebox('getValue');
		var dateto=$("#BDPDictionaryDateTo").datebox('getValue');
  
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
        if (datefrom==""){
        	$.messager.alert('错误提示','开始日期不能为空!',"error");
			return false;
        }
		if (datefrom != "" && dateto != "") {
			var dateflag= tkMakeServerCall("web.DHCBL.BDP.BDPDataDictionary","CompareDate",datefrom,dateto) 
			if(dateflag==1){ 
				$.messager.alert('错误提示','开始日期不能大于结束日期!',"error");
				return false;
			}
		}
        if (indexs!==""){
        	$('#ExtendGrid').datagrid('endEdit', indexs);
        }
        $('#form-save').form('submit', { 
            url: SAVE_ACTION_URL, 
            onSubmit: function(param){
                 param.datalist = listdata;
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
	                $('#DataGrid').datagrid('reload');  // 重新载入当前页面数据 
	                $('#DataGrid').datagrid('unselectAll');
	                $('#myWin').dialog('close');
	                listdata="";
              } 
              else { 
                var errorMsg ="更新失败！"
                if (data.errorinfo) {
                    errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
                }
                 $.messager.alert('操作提示',errorMsg,"error");
                 listdata="";
            } 
        } 
     });  
   }
};
$(init);
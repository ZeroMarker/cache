/*
* @Author: 基础数据平台-谢海睿
* @Date:   2019-11-13
* @描述:检验标本维护 - 采集容器
*/
var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.LAB.BTContainer&pClassQuery=GetList";
var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.LAB.BTContainer&pClassMethod=OpenData";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.LAB.BTContainer&pClassMethod=SaveEntity&pEntityName=web.Entity.LAB.BTContainer";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.LAB.BTContainer&pClassMethod=DeleteData";

var init = function(){
	//jquery颜色选择器
	(function($){
		$(function(){
			if (!$('#easyui-color-style').length){
				$('head').append(
					'<style id="easyui-color-style">' +
					'.color-cell{display:inline-block;float:left;cursor:pointer;border:1px solid #fff}' +
					'.color-cell:hover{border:1px solid #000}' +
					'</style>'
				);
			}
		});
		function create(target){
			var opts = $.data(target, 'color').options;
			$(target).combo($.extend({}, opts, {
				panelWidth: opts.cellWidth*8+2,
				panelHeight: opts.cellHeight*7+2,
				onShowPanel: function(){
					var p = $(this).combo('panel');
					if (p.is(':empty')){
						var colors = [
							"0,0,0","68,68,68","102,102,102","153,153,153","204,204,204","238,238,238","243,243,243","255,255,255",
							"244,204,204","252,229,205","255,242,204","217,234,211","208,224,227","207,226,243","217,210,233","234,209,220",
							"234,153,153","249,203,156","255,229,153","182,215,168","162,196,201","159,197,232","180,167,214","213,166,189",
							"224,102,102","246,178,107","255,217,102","147,196,125","118,165,175","111,168,220","142,124,195","194,123,160",
							"204,0,0","230,145,56","241,194,50","106,168,79","69,129,142","61,133,198","103,78,167","166,77,121",
							"153,0,0","180,95,6","191,144,0","56,118,29","19,79,92","11,83,148","53,28,117","116,27,71",
							"102,0,0","120,63,4","127,96,0","39,78,19","12,52,61","7,55,99","32,18,77","76,17,48"
						];
						for(var i=0; i<colors.length; i++){
							var a = $('<a class="color-cell"></a>').appendTo(p);
							a.css('backgroundColor', 'rgb('+colors[i]+')');
						}
						var cells = p.find('.color-cell');
						cells._outerWidth(opts.cellWidth)._outerHeight(opts.cellHeight);
						cells.bind('click.color', function(e){
							var color = $(this).css('backgroundColor');
							$(target).color('setValue', color);
							$(target).combo('hidePanel');
						});
					}
				}
			}));
			if (opts.value){
				$(target).color('setValue', opts.value);
			}
		}

		$.fn.color = function(options, param){
			if (typeof options == 'string'){
				var method = $.fn.color.methods[options];
				if (method){
					return method(this, param);
				} else {
					return this.combo(options, param);
				}
			}
			options = options || {};
			return this.each(function(){
				var state = $.data(this, 'color');
				if (state){
					$.extend(state.options, options);
				} else {
					state = $.data(this, 'color', {
						options: $.extend({}, $.fn.color.defaults, $.fn.color.parseOptions(this), options)
					});
				}
				create(this);
			});
		};

		$.fn.color.methods = {
			options: function(jq){
				return jq.data('color').options;
			},
			setValue: function(jq, value){
				return jq.each(function(){
					var tb = $(this).combo('textbox').css('backgroundColor', value);
					value = tb.css('backgroundColor');
					if (value.indexOf('rgb') >= 0){
						var bg = value.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
						value = '#' + hex(bg[1]) + hex(bg[2]) + hex(bg[3]);
					}
					$(this).combo('setValue', value).combo('setText', value);

					function hex(x){
						return ('0'+parseInt(x).toString(16)).slice(-2);
					}
				})
			},
			clear: function(jq){
				return jq.each(function(){
					$(this).combo('clear');
					$(this).combo('textbox').css('backgroundColor', '');
				});
			}
		};

		$.fn.color.parseOptions = function(target){
			return $.extend({}, $.fn.combo.parseOptions(target), {

			});
		};

		$.fn.color.defaults = $.extend({}, $.fn.combo.defaults, {
			editable: false,
			cellWidth: 20,
			cellHeight: 20
		});

		$.parser.plugins.push('color');
	})(jQuery);
	// easyui 颜色选择器插件（自定义）
	$.extend($.fn.datagrid.defaults.editors, {
		colorpicker : {
			// colorpicker就是你要自定义editor的名称
			init : function(container, options) {
				var input = $('<input>').appendTo(container);
				input.ColorPicker({
					color : '#0000ff',
					onShow : function(colpkr) {
						$(colpkr).fadeIn(500);
						return false;
					},
					onHide : function(colpkr) {
						$(colpkr).fadeOut(500);
						return false;
					},
					onChange : function(hsb, hex, rgb) {
						input.css('backgroundColor', '#' + hex);
						input.val('#' + hex);
					}
				});
				return input;
			},
			getValue : function(target) {
				return $(target).val();
			},
			setValue : function(target, value) {
				$(target).val(value);
				$(target).css('backgroundColor', value);
				$(target).ColorPickerSetColor(value);
			},
			resize : function(target, width) {
				var input = $(target);
				if ($.boxModel == true) {
					input.width(width - (input.outerWidth() - input.width()));
				} else {
					input.width(width);
				}
			}
		}
	});

	//颜色的转化
	//hex -> rgb
	function hexToRgb(hex) {
	return 'rgb(' + parseInt('0x' + hex.slice(1, 3)) + ',' + parseInt('0x' + hex.slice(3, 5))
			+ ',' + parseInt('0x' + hex.slice(5, 7)) + ')';
	}
	//hex -> rgba
	function hexToRgba(hex, opacity) {
	return 'rgba(' + parseInt('0x' + hex.slice(1, 3)) + ',' + parseInt('0x' + hex.slice(3, 5)) + ','
			+ parseInt('0x' + hex.slice(5, 7)) + ',' + opacity + ')';
	}
	//datagrid排序：
	function sort_int(a,b){
		if(a.length >b.length) return 1;
		else if (a.length <b.length) return -1;
		else if (a > b) return 1;
		else return -1;
	}
	var columns =[[
			{field:'RowID',title:'RowID',sortable:true,width:100,hidden:true},
			{field:'Code',title:'代码',sortable:true,width:100},
			{field:'Sequence',title:'序号',sortable:true,width:50, sortable:true,sorter:sort_int},
			{field:'CName',title:'名称',sortable:true,width:150},
			{field:'Volumn',title:'容量(毫升)',sortable:true,width:100},
			{field:'Color',title:'颜色',sortable:true,width:100,
			//字体颜色根据颜色的深浅进行变化
			formatter:function(value, row,index) {
				value = value.replace(/0x/, "#");
				rgb = hexToRgb(value);
				var r= parseInt(rgb.split('(')[1].split(',')[0]);
    			var g = parseInt(rgb.split('(')[1].split(',')[1]);
				var b = parseInt(rgb.split('(')[1].split(',')[2]); 
				if((r<=165&&g<=165)||(g<=165&&b<=165)||(r<=165&&b<=165&&g<240)){
					var color='white';
				}else{
					var color='#000000'
				}
				return '<div id=\"colorpickerField1\" style="background-color:'+value+';width:100%;">'+ '<font color='+color+'>' +value +'</font>' +'</div>';	
			}},
			{field:'Remark',title:'说明',sortable:true,width:100},
            {field:'HospitalDR',title:'医院',sortable:true,width:200},
            {field:'Active',title:'激活',sortable:true,width:100,align:'center',formatter:ReturnFlagIcon},
			{field:'Photo',title:'容器图片',sortable:true,width:100,formatter:function(value, row,index) {
				if(value!=""){
					return '<img src="' + value + '" width="80px;" height="80px;"/>';
				}		
			}},
			{field:'ConType',title:'容器类型',sortable:true,width:100},
			]];
    var grid = $HUI.datagrid("#grid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.LAB.BTContainer",
            QueryName:"GetList"
        },
		ClassTableName:'dbo.BTContainer',
		SQLTableName:'dbo.BT_Container',
		idField:'RowID',
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(index,row)
        {
        	UpdateData();
        },
		onLoadSuccess:function(data)
		{
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        }	
	});
	/* ****************************************************处理图片********************************************** */
	//压缩后转换base64
	function compress() { 
		var  fileObj = document.getElementsByName("Photo1")[0].files[0] //上传文件的对象
		var  reader = new FileReader()
		reader.readAsDataURL(fileObj)
		reader.onload = function(e) {
			let image = new Image() //新建一个img标签（还没嵌入DOM节点)
			image.src = e.target.result
			image.onload = function() {
				let canvas = document.createElement('canvas'), 
				context = canvas.getContext('2d'),
				imageWidth = image.width / 3,    //压缩后图片的大小
				imageHeight = image.height / 3,
				data = ''
				canvas.width = imageWidth
				canvas.height = imageHeight
				context.drawImage(image, 0, 0, imageWidth, imageHeight)
				data = canvas.toDataURL('image/jpeg')
				$('#Photo').val(data);
			}
		}
	}
  /* *********************************************************************************************************************** */
	//色彩下拉框
	$('#Color').color({
		onChange:function(value){
			value = value.replace(/0x/, "#");
			rgb = hexToRgb(value);
			var r= parseInt(rgb.split('(')[1].split(',')[0]);
			var g = parseInt(rgb.split('(')[1].split(',')[1]);
			var b = parseInt(rgb.split('(')[1].split(',')[2]); 
			if((r<=165&&g<=165)||(g<=165&&b<=165)||(r<=165&&b<=165&&g<240)){
				$("#col .validatebox-text").css({
					color:"white"
				})
			}else{
				$("#col .validatebox-text").css({
					color:"#000000"
				})
			}
		},
	
	});
	///文件选择框
	$('#Photo1').filebox({
		buttonText:'',
		prompt:'选择图片',
		plain:true,
		buttonIcon:'icon-img-blue',
		width:215,
		onChange:function(value){
			compress();
		},
	});
	//医院下拉框
	$('#HospitalDR,#Hospital').combobox(
		{
			url:$URL+"?ClassName=web.DHCBL.LAB.BTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
			valueField:'RowID',
			textField:'CName',
	    }
	);
    //点击搜索按钮
	$('#btnSearch').click(function(e)
	{
    	SearchFunLib();
	});
    //搜索回车事件,ESC事件
	$('#TextDesc,#TextCode,#Hospital').keyup(function(event)
	{
		if(event.keyCode == 13) 
		{
			SearchFunLib();
		}
		if(event.keyCode == 27){
			ClearFunLib();
		}
	}); 

    //搜索方法
    SearchFunLib=function()
    {
    	var code=$("#TextCode").val();
		var CName=$("#TextDesc").val();
		var hospital=$("#Hospital").combobox('getValue');
    	$('#grid').datagrid('load',{
            ClassName:"web.DHCBL.LAB.BTContainer",
			QueryName:"GetList",
			code:code,
			cname:CName,
			hospital:hospital
        });
        $('#grid').datagrid('unselectAll');
	}
    //点击重置按钮
	$('#btnRefresh').click(function(e)
	{
		ClearFunLib();
	});
	//重置方法
	ClearFunLib=function(){
		$("#TextDesc").val('');//清空检索框
		$("#TextCode").val('');
		$("#Hospital").combobox('setValue',"");
		$('#grid').datagrid('load',{
			ClassName: "web.DHCBL.LAB.BTContainer",
            QueryName:"GetList"
		});
		$('#grid').datagrid('unselectAll');
	}
    //点击添加按钮
	$('#add_btn').click(function(e)
	{
    	AddData();
	});	
    //点击修改按钮
	$('#update_btn').click(function(e)
	{
    	UpdateData();
	});	
    //点击删除按钮
	$('#del_btn').click(function(e)
	{
    	DelData();
	}); 
	//删除方法
    DelData=function()
    {
		var row = $("#grid").datagrid('getSelected'); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.RowID;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r)
		{
			if (r)
			{
				$.ajax(
					{
						url:DELETE_ACTION_URL,  
						data:{"id":rowid},  
						type:"POST",     
						success: function(data)
						{
							var data=eval('('+data+')'); 
							if (data.success == 'true') 
							{
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								$('#grid').datagrid('reload');  // 重新载入当前页面数据 
								$('#grid').datagrid('unselectAll');  // 清空列表选中数据 
							} 
							else {
								var errorMsg ="删除失败！"
								if (data.info) 
								{
									errorMsg =errorMsg+ '<br/>错误信息:' + data.info
								}
								$.messager.alert('操作提示',errorMsg,"error");
					
							}			
						}  
					});
			}
		});    	
	} 
	//新增方法
    AddData=function()
    {
		$('#HospitalDR').combobox('reload');
		$('#Color').color('setValue',"");
		$('#Photo1').filebox('setValue','');
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",
		{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:
			[
				{
					text:'保存',
					id:'save_btn',
					handler:function()
					{
						SaveFunLib("");
					}
				},
			    {
					text:'关闭',
					handler:function()
					{
						myWin.close();
						editIndex = undefined;
					}
			    }
			],	
		});
		$('#form-save').form("clear");
		$HUI.checkbox("#Active").setValue(true);	
	}
	//修改数据方法
    UpdateData = function()
	{
		$('#HospitalDR').combobox('reload');
		$('#Photo1').filebox('clear');
		var record = grid.getSelected();
		if(record)
		{   
			//同步颜色
			$('#Color').color('setValue',record.Color);
			var id=record.RowID; 
			//同步基本信息
			$.cm(
				{
					ClassName:"web.DHCBL.LAB.BTContainer",
					MethodName:"OpenData",
					id:id
			    },
				function(jsondata)
				{
					if(jsondata.Active==1){
                        $HUI.checkbox("#Active").setValue(true);
                    }else{
                        $HUI.checkbox("#Active").setValue(false);
                    }
					$('#form-save').form("load",jsondata);
				}
            );
			$("#myWin").show();
			var myWin = $HUI.dialog("#myWin",
			{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[
					{
						text:'保存',
						id:'save_btn',
						handler:function()
						{
							SaveFunLib(id);
						}
					},
					{
						text:'关闭',
						handler:function()
						{
							 myWin.close();
							 editIndex = undefined;
						}
					}
				],
				onClose:function()
				{
					editIndex = undefined;
				}
			});	
		}
		else
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
		}
	}
	//保存
    SaveFunLib=function(id)
    {
		var Code=$.trim($("#Code").val());
		var CName=$.trim($("#CName").val());		
		///判空	
		if (Code=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"info");
			return;
		}else if(Code.length>=10)
		{
			$.messager.alert('错误提示','代码长度不能超过10个字节!',"info");
			return;
		}
		if (CName=="")
		{
			$.messager.alert('错误提示','名称不能为空!',"info");
			return;
		}
		var HospitalDR=$('#HospitalDR').combobox('getValue')
		if ((HospitalDR==undefined)||(HospitalDR=="undefined")||(HospitalDR==""))
		{
			$.messager.alert('错误提示','医院请选择下拉列表里的值',"info");
			return;
		}
		var result= tkMakeServerCall("web.DHCBL.LAB.BTContainer","FormValidate",id,Code,HospitalDR);
		if(result==0)
		{
			$.messager.confirm("提示", "确认要保存数据吗?", function (r) {
				if (r)
				{
					$('#form-save').form('submit', 
					{
						url:SAVE_ACTION_URL,
						onSubmit: function(param)
						{
							param.RowID=id;
						},
						success:function (data) 
						{
							var data=eval('('+data+')');
							if (data.success == 'true') 
							{
								$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
								if (id!="")
								{
									$('#grid').datagrid('reload');  // 重新载入当前页面数据 
								}
								else{
									
										$.cm({
										ClassName:"web.DHCBL.LAB.BTContainer",
										QueryName:"GetList",
										rowid: data.id   
									},function(jsonData){
										$('#grid').datagrid('insertRow',{
											index:0,
											row:jsonData.rows[0]
										})
									})
									$('#grid').datagrid('unselectAll');
								}
								$('#myWin').dialog('close'); // close a dialog		
						
					
							} 
							else 
							{ 
								var errorMsg ="更新失败！"
								if (data.errorinfo)
								{
									errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
								}
								$.messager.alert('操作提示',errorMsg,"error");
							}
						} 
					});		
					}
					else 
					{
						return false;
					}								
			});
		}
		else
		{
			$.messager.alert('操作提示',"该记录已经存在！","info");
		} 	
    }  	
	HISUI_Funlib_Translation('grid');
    HISUI_Funlib_Sort('grid');
} 

$(init);
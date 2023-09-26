    
	
	
	
	/*
 *	window 
 *  option 自定义window参数设置
 */
 
 var WindowUX = function(title, id, width, height, option){
 	this.title = title;
 	this.id = id;
 	this.width = width;
 	this.height = height;
 	this.option = option;
 }
 
 WindowUX.prototype.Init = function(){
	var option = {
		//closable : false,
		modal : true,
		inline : false,
		border : false,
		title : this.title,
		collapsible : false,
		//minimizable : false,
		//maximizable : false,
		width : this.width,
		height : this.height
	}
	$('#'+this.id).window($.extend(option,this.option));
	$('#'+this.id).window('open');
}
	
	
	
	/*
	  creator:LiangQiang
	  creatdate:2014-08-01
	  description:jquery easyui　相关控件封装

	*/

	/*
	   datagrid控件
	*/
	var DataGrid=function (obj)
	{
		this.url=obj.url;
		this.columns=obj.columns;
		this.pagesize=obj.pagesize;
		this.table=obj.table;
		this.field=obj.field;
		this.params=obj.params;
		this.toolbar=obj.tbar;


	}

	DataGrid.prototype={ 
		init:function(){
			 			 //初始化
			 var tmptbl=this.table;
			 $(this.table).datagrid({  
				  bordr:false,
				  fit:true,
				  singleSelect:true,
				  loadMsg:null,
				  idField:this.field, 
				  striped: true, 
				  pagination:true,
				  rownumbers:true,//行号 
				  pageSize:this.pageSize,
				  pageList:[this.pagesize,this.pagesize*2],
				  columns:this.columns,
				  url:this.url,
				  queryParams:this.params,
				  toolbar:this.toolbar,
				  onLoadSuccess:function() {

              		    var rows = $(tmptbl).datagrid('getRows');
						var rowcount=rows.length ;			   
						if (rowcount==0) return;
				        $(tmptbl).datagrid('selectRow', 0);
				  }

			  });

        },
		loaddata:function(params){
			//按条件加载数据
			$(this.table).datagrid('options').url=this.url;
            $(this.table).datagrid('options').queryParams=params;
			$(this.table).datagrid('reload');
		},
		clickrow:function(fn){
			//单击行
			$(this.table).datagrid('options').onClickRow=function(rowIndex, rowData){
					   fn(rowIndex, rowData)
			  }

		},
		dblclickrow:function(fn){
			//双击行
			$(this.table).datagrid('options').onDblClickRow=function(rowIndex, rowData){
					   fn(rowIndex, rowData)
			}

		},
	    clear:function(){
			//清空数据
			$(this.table).datagrid('options').url=null;
			$(this.table).datagrid('loadData',{total:0,rows:[]}); 

		}



	}

     /*
	 treegrid控件
	 */
	var TreeGrid=function (obj)
	{
		this.url=obj.url;
		this.columns=obj.columns;
		this.pagesize=obj.pagesize;
		this.table=obj.table;
		this.field=obj.field;
		this.treefield=obj.treefield;
		this.params=obj.params;
                this.toolbar=obj.tbar;

	}

	TreeGrid.prototype={ 
		init:function(){
				$(this.table).treegrid({  
						  bordr:false,
						  fit:true,
						  fitColumns:true,
						  singleSelect:true,
						  idField:this.field, 
						  treeField:this.treefield,
						  nowrap: false,
						  striped: true, 
						  pagination:true,
						  rownumbers:false,//行号 
						  pageSize:this.pageSize,
						  pageList:[this.pagesize,this.pagesize*2],
						  columns:this.columns,
						  url:this.url,
						  queryParams:this.params,
                                                  toolbar:this.toolbar

					  });


		},
		dblclickrow:function(fn){
			 $(this.table).treegrid({
				onDblClickRow: function(rowData){
					   fn(rowData);
				}
             })
		}




	}
  
   /*
       combogrid控件
   */

   	var ComboGrid=function (obj)
	{
		this.url=obj.url;
		this.pw=obj.pw;
		this.columns=obj.columns;
		this.pagesize=obj.pagesize;
		this.combo=obj.combo;
		this.idfield=obj.idfield;
		this.valuefield=obj.valuefield
		this.textfield=obj.textfield;
		this.multiple=obj.multiple;

	}

	ComboGrid.prototype={ 
		init:function(){

				$(this.combo).combogrid({ 
							  url:this.url, 
							  valueField:this.valuefield,
							  panelWidth:this.pw,
							  idField:this.idfield,
							  textField:this.textfield,
							  fitColumns: true,  
							  multiple:this.multiple, 
							  columns:this.columns
				 }); 


		}

	}
	


	/*
	   Jquery请求
	*/
	var JRequest=function (obj)
	{
			this.url=obj.url;
			this.async=obj.async;
			this.data=obj.data;
			this.type=obj.type;

	}

	JRequest.prototype={ 

		post:function(fn)
		{
			    var params=this.data;
				var request = $.ajax({
				url: this.url,
				type: "POST",
				async: this.async,
				data: jQuery.param(this.data),
				dataType: this.type,
				cache: false,
				success: function (r, textStatus) {
                       fn(r,params);
                },
				error: function (XMLHttpRequest, textStatus, errorThrown) {  
					   fn(XMLHttpRequest.readyState) ;

					}

			    });

			
		}


	}

/**
 * Combobox
 * option 自定义Combobox参数设置
 */
var ListCombobox = function(id, url, data, option){
	this.id = id;
	this.url= url;
	this.data = data;
	this.option = option;
	}
	
ListCombobox.prototype.init = function(){
	
	var option = {
		url : this.url,
		data : this.data,
		valueField : 'val',    
		textField : 'text'
	}

	$('#'+this.id).combobox($.extend(option,this.option));
}

/*
 *	dategrid 
 *  option 自定义datagrid参数设置
 */
var ListComponent = function(id, columns, url, option){
 	this.id = id;
	this.url = url;
	this.option = option;
	this.columns = columns;
}

ListComponent.prototype.Init = function(){
	var option = {
		url : this.url,
		fit : true,
		striped : true, //是否显示斑马线效果
		columns : this.columns,
		pageSize : [30],
		pageList : [30,60,90],
		loadMsg : '正在加载信息...',
		rownumbers : true, //行号
		fitColumns : true,
		singleSelect : false,
		pagination : true,
		bordr : false,
		onBeforeLoad : function(param){
			///清空数据
			$('#'+this.id).datagrid('loadData',{total:0,rows:[]});
		},
		onLoadSuccess:function(data){
			///提示信息
    		LoadCellTip("");
		} 
	}
	$('#'+this.id).datagrid($.extend(option,this.option));
}

/// 加载提示消息
function LoadCellTip(TipFieldList)
{
	var html='<div id="tip" style="border-radius:30px; display:none; border:1px solid #000; padding:10px;position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);

	$('.datagrid-body').delegate('td', {
		'mousemove' :function(){
			var tleft=(event.clientX + 20);
			if((event.clientX+300)>document.body.offsetWidth){
				tleft=event.clientX-20;
			}
			
			if ($(this).text().length <= "10"){
				return;
			}
			
			if (TipFieldList.indexOf(this.field) == "-1"){
				return;
			}

			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 0.7
			}).text($(this).text());
		},
		'mouseout' :function(){
			$("#tip").css({display : 'none'});
		}
   })
}

// 文本编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

// 日期编辑格
var dateboxditor={
	type: 'datebox',//设置编辑格式
	options: {
		//required: true //设置编辑规则属性
	}
}
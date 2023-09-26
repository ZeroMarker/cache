    
	
	/*
	  creator:LiangQiang
	  creatdate:2014-08-01
	  description:jquery easyui����ؿؼ���װ

	*/

	/*
	   datagrid�ؼ�
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
			 			 //��ʼ��
			 var tmptbl=this.table;
			 $(this.table).datagrid({  
				  bordr:false,
				  fit:true,
				  singleSelect:true,
				  loadMsg:null,
				  idField:this.field, 
				  striped: true, 
				  pagination:true,
				  rownumbers:true,//�к� 
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
                                      //$(tmptbl).datagrid('selectRow', 0);  2016-09-01 wangxuejian
				  }

			  });

        },
		loaddata:function(params){
			//��������������
			$(this.table).datagrid('options').url=this.url;
            $(this.table).datagrid('options').queryParams=params;
			$(this.table).datagrid('reload');
		},
		clickrow:function(fn){
			//������
			$(this.table).datagrid('options').onClickRow=function(rowIndex, rowData){
					   fn(rowIndex, rowData)
			  }

		},
		dblclickrow:function(fn){
			//˫����
			$(this.table).datagrid('options').onDblClickRow=function(rowIndex, rowData){
					   fn(rowIndex, rowData)
			}

		},
	    clear:function(){
			//�������
			$(this.table).datagrid('options').url=null;
			$(this.table).datagrid('loadData',{total:0,rows:[]}); 

		}



	}

     /*
	 treegrid�ؼ�
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
						  rownumbers:false,//�к� 
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
       combogrid�ؼ�
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
	   Jquery����
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
 * option �Զ���Combobox��������
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
		valueField :'value',    
		textField :'text'
	}

	$('#'+this.id).combobox($.extend(option,this.option));
}

/*
 *	dategrid 
 *  option �Զ���datagrid��������
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
		striped : true, //�Ƿ���ʾ������Ч��
		columns : this.columns,
		pageSize : [30],
		pageList : [30,60,90],
		loadMsg : '���ڼ�����Ϣ...',
		rownumbers : true, //�к�
		fitColumns : true,
		singleSelect : false,
		pagination : true,
		bordr : false,
		onBeforeLoad : function(param){
			///�������
			var thisrows=$('#'+this.id).datagrid("getRows").length;
			if (thisrows<=0){
				$('#'+this.id).datagrid('loadData',{total:0,rows:[]});
			}
		},
		onLoadSuccess:function(data){
			//$('#'+this.id).datagrid('loadData',{total:0,rows:[]});
			///��ʾ��Ϣ
    		LoadCellTip("");
		} 
	}
	$('#'+this.id).datagrid($.extend(option,this.option));
}

/// ������ʾ��Ϣ
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
			
			//if (TipFieldList.indexOf(this.field) == "-1"){
			//	return;
			//}

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

// �ı��༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

// ���ڱ༭��
var dateboxditor={
	type: 'datebox',//���ñ༭��ʽ
	options: {
		//required: true //���ñ༭��������
	}
}
/*
 *	window 
 *  option �Զ���window��������
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
 *	window 
 *  option �Զ���window��������
 */
 
 var DialogUX = function(title, id, width, height, option){
 	 this.title = title;
 	 this.id = id;
 	 this.width = width;
 	 this.height = height;
 	 this.option = option;
 }
 
 DialogUX.prototype.Init = function(){
	var option = {
		//closable : false,
		modal : true,
		inline : false,
		border : false,
		title : this.title,
		collapsible : false,
		minimizable : false,
		maximizable : false,
		width : this.width,
		height : this.height
	}
	$('#'+this.id).dialog($.extend(option,this.option));
	$('#'+this.id).dialog('open');
}

/*
 *	TabUX 
 *  option �Զ���TabUX��������
 */
 
 var TabsUX = function(title, id, option){
	 this.id = id;
 	 this.title = title;
 	 this.option = option;
 	 
 }
 
 TabsUX.prototype.Init = function(){
	var option = {
		border:false,
	    fit:"true"
	}
	$('#'+this.id).tabs($.extend(option,this.option));
}

var UIDivWindow = function(tarobj, input, width, height,fn){
	this.input = input;
	this.tarobj = tarobj;
	this.width = width;
	this.height = height;
	this.fn = fn;
	}
	
UIDivWindow.prototype.init=function(){
		var fn = this.fn;
		
		//����columns
		var columns=[[
		    {field:'InciDesc',title:'ҩƷ����',width:220},
		    //{field:'Spec',title:'���',width:80},
			{field:'Form',title:'����',width:80},
			{field:'Manf',title:'����',width:200},
			{field:'PuomDesc',title:'��λ',width:80},
			{field:'GoodName',title:'��Ʒ��',width:120},
			{field:'GeneName',title:'ͨ����',width:160}
		]];
		
		/**
		 * ����datagrid
		 */ 
		var option = {
			//title:'ҩƷ��ϸ',
			pageSize : [15],
			pageList : [15,30],
			singleSelect : true,
			onLoadSuccess:function(data) {
				$("#mydiv").datagrid("selectRow",0);
			},
		    onDblClickRow: function (rowIndex, rowData) {
				var rowData = $('#mydiv').datagrid('getSelected');
				RemoveMyDiv();
				fn(rowData);
	        }
		};

		///������������
		$(document.body).append('<div id="win" style="width:'+ this.width +';height:300px;border:1px solid #E6F1FA;position:absolute;z-index:9999;background-color:#ffa8a8;"></div>') 
		$("#win").append('<div id="mydiv"></div>');	
		$("#win").show();
		$("#win").css("left",this.tarobj.offset().left);
		$("#win").css("top",this.tarobj.offset().top+ this.tarobj.outerHeight());
		
		var utilUrl = 'dhcpha.clinical.action.csp?action=QueryStockDetail&Input='+ this.input +'&HospID="1"';
		var stockItemComponent = new ListComponent('mydiv', columns, utilUrl, option);
		stockItemComponent.Init();
		//initScroll("#mydiv");//��ʼ����ʾ���������
		
		//���÷�ҳ�ؼ�
		var pag = $("#mydiv").datagrid('getPager');
		$(pag).pagination({
			buttons: [{
				text:'�ر�',
				handler:function(){
					RemoveMyDiv();
					//fn('');
				}
			}]
		});
		
	    $("#mydiv").datagrid('getPanel').panel('panel').attr("tabindex",0);
	    $("#mydiv").datagrid('getPanel').panel('panel').focus();
	
		var opt=$("#mydiv").datagrid('options');
		opt.onClickRow=function(rowIndex, rowData){
			 //RemoveMyDiv();
			 //fn(rowData);
			 //return;
		}
		
	    $("#mydiv").datagrid('getPanel').panel('panel').bind('keydown', function (e){
	        switch (e.keyCode){
	        	case 13: // enter
			   		var rowData = $('#mydiv').datagrid('getSelected');
			   		RemoveMyDiv();
			   		fn(rowData);
			   		break ;
	        	case 27:  //Esc
			   		RemoveMyDiv();
			   		//fn('');
			   		break;
			   	case 33:  //Page Up
			   		var rowData = $('#mydiv').datagrid('getSelected');
			   		var currRowIndex = $('#mydiv').datagrid('getRowIndex',rowData);
			   		if (currRowIndex - 1 >= 0){
			   			$("#mydiv").datagrid("selectRow",currRowIndex - 1);
			   		}
			   		break;
			   	case 34:  //Page Down
			   		var rows = $('#mydiv').datagrid('getRows');
			   	    var rowData = $('#mydiv').datagrid('getSelected');
			   		var currRowIndex = $('#mydiv').datagrid('getRowIndex',rowData);
			   		if (currRowIndex + 1 <= rows.length){
			   			$("#mydiv").datagrid("selectRow",currRowIndex + 1);
			   		}
			   		break;
			    case 38:  //Page Up
			   		var rowData = $('#mydiv').datagrid('getSelected');
			   		var currRowIndex = $('#mydiv').datagrid('getRowIndex',rowData);
			   		if (currRowIndex - 1 >= 0){
			   			$("#mydiv").datagrid("selectRow",currRowIndex - 1);
			   		}
			   		break;
			   	case 40:  //Page Down
			   		var rows = $('#mydiv').datagrid('getRows');
			   	    var rowData = $('#mydiv').datagrid('getSelected');
			   		var currRowIndex = $('#mydiv').datagrid('getRowIndex',rowData);
			   		if (currRowIndex + 1 <= rows.length){
			   			$("#mydiv").datagrid("selectRow",currRowIndex + 1);
			   		}
			   		break;
			}
		})
		
		  //ɾ������
		  function RemoveMyDiv(){
			if($("#mydiv").length>0){
			   $("#mydiv").remove(); 
		   	   $("#win").remove(); 
			}
		  } 
}

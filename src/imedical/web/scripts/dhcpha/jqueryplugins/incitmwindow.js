///createdate:20160504
///门诊住院药房统一调用此处
///药品弹窗
var IncItmDivWindow = function(tarobj, input, fn){
	this.input = input;
	this.tarobj = tarobj;
	this.fn = fn;
	}
	
IncItmDivWindow.prototype.init=function(){
		var fn = this.fn;		
		//定义columns
		var columns=[[
			{field:'Inci',title:'Inci',width:10,hidden:true},
			{field:'InciCode',title:'药品代码',width:50},
		    {field:'InciDesc',title:'药品名称',width:150}
		]];
		
		/**
		 * 定义datagrid
		 */ 
		var option = {
			width:210,
			singleSelect : true,
			toolbar:[ {
	            id: '',
	            text: '关闭',
	            iconCls: 'icon-cancel',
	            handler: function () {
		           RemoveMyDiv();
		          }
        	}],
        	pagination:false,
			onLoadSuccess:function(data) {
				$("#mydiv").datagrid("selectRow",0);
			},
		    onDblClickRow: function (rowIndex, rowData) {
				var rowData = $('#mydiv').datagrid('getSelected');
				RemoveMyDiv();
				fn(rowData);
	        }
		};
		
		///创建弹出窗体
		$(document.body).append('<div id="win" style="width:500px;height:300px;border:1px solid #E6F1FA;position:absolute;z-index:9999;background-color:#ffa8a8;"></div>') 
		$("#win").append('<div id="mydiv"></div>');	
		$("#win").show();
		var tmpWidth=document.body.clientWidth;
		var tmpHeight=document.body.clientHeight;
		var winleft=this.tarobj.offset().left;
		var windivwidth=parseFloat(document.getElementById("win").style.width);
		var windivheight=parseFloat(document.getElementById("win").style.height);
		if ((this.tarobj.offset().left+windivwidth)>tmpWidth){
			winleft=winleft-(this.tarobj.offset().left+windivwidth-tmpWidth);
		}
		var wintop=this.tarobj.offset().top+this.tarobj.outerHeight();
		if ((this.tarobj.offset().top+windivheight+this.tarobj.outerHeight())>tmpHeight){
			document.getElementById("win").style.height=tmpHeight-(this.tarobj.offset().top+this.tarobj.outerHeight());		
		}
		$("#win").css("left",winleft);
		$("#win").css("top",wintop);
		var utilUrl = 'DHCST.INPHA.ACTION.csp?action=GetIncItmForDialog&Input='+ this.input +'&HospID='+ 1;
		var stockItemComponent = new ListComponent('mydiv', columns, utilUrl, option);
		stockItemComponent.Init();		
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
		
		  //删除弹窗
		  function RemoveMyDiv(){
			if($("#mydiv").length>0){
			   $("#mydiv").remove(); 
		   	   $("#win").remove(); 
			}
		  } 
}
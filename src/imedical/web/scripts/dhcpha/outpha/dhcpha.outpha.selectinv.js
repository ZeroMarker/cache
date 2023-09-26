///creator:yunhaibao
///createdate:20160511
///����ҩ����ȡ��Ʊ����
var InvNoDivWindow = function(tarobj, input, fn){
	this.input = input;
	this.tarobj = tarobj;
	this.fn = fn;
	}
	
InvNoDivWindow.prototype.init=function(){
		var fn = this.fn;		
		var columns=[[
			{field:'newInvNo',title:'���վ�',width:100},
			{field:'patName',title:'����',width:100},
		    {field:'invDate',title:'����',width:100},
		    {field:'invId',title:'invId',width:100,hidden:true},
		    {field:'prescNo',title:'������',width:100},
		    {field:'newInvId',title:'newInvId',width:100,hidden:true},
		    {field:'invNo',title:'ԭ�վ�',width:100}
		]];
		
		/**
		 * ����datagrid
		 */ 
		var option = {
			width:210,
			singleSelect : true,
			toolbar:[ {
	            id: '',
	            text: '�ر�',
	            iconCls: '',
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
		
		///������������
		$(document.body).append('<div id="win" style="width:700px;height:300px;border:1px solid #E6F1FA;position:absolute;z-index:9999;background-color:#ffa8a8;"></div>') 
		$("#win").append('<div id="mydiv"></div>');	
		$("#win").show();
		$("#win").css("left",this.tarobj.offset().left);
		$("#win").css("top",this.tarobj.offset().top+ this.tarobj.outerHeight());
		
		var utilUrl = 'DHCST.OUTPHA.ACTION.csp?action=GetInvListForReturn&params='+ this.input;
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
		
		  //ɾ������
		  function RemoveMyDiv(){
			if($("#mydiv").length>0){
			   $("#mydiv").remove(); 
		   	   $("#win").remove(); 
			}
		  } 
}
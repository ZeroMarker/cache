var ListComponentWin = function(tarobj, input, width, height, url, columns, fn){
	this.input = input;
	this.tarobj = tarobj;
	this.width = width;
	this.height = height;
	this.url = (typeof websys_writeMWToken=='function')?websys_writeMWToken(url):url;
	this.columns = columns;
	this.fn = fn;
}
	
ListComponentWin.prototype.init=function(){
	var fn = this.fn;
			
	// ����datagrid
	var option = {
		pageSize : [10],
		pageList : [10,20],
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
	if ($("#win").length == 0){
		$(document.body).append('<div id="win" style="width:'+ this.width +';height:310px;border:1px solid #E6F1FA;position:absolute;z-index:9999;background-color:#ffa8a8;"></div>') 
		$("#win").append('<div id="mydiv"></div>');	
		$("#win").show();
		var tleft = "";
		if((this.tarobj.offset().left+500)>document.body.offsetWidth){
			tleft= 500 - (document.body.offsetWidth - this.tarobj.offset().left);
		}
		
		$("#win").css("left",this.tarobj.offset().left - tleft);
		$("#win").css("top",this.tarobj.offset().top+ this.tarobj.outerHeight());
	}
	
	var stockItemComponent = new ListComponent('mydiv', this.columns, encodeURI(this.url), option);
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
		}],
		onSelectPage:function(pageNumber, pageSize){
			//��ҳ���ȡ����
			var opts=$('#mydiv').datagrid('options');
	            opts.pageNumber =pageNumber;
	            opts.pageSize = pageSize;
	            $(pag).pagination("refresh", { pageNumber: pageNumber, pageSize:pageSize });
	            $('#mydiv').datagrid('reload');
	            $("#mydiv").datagrid('getPanel').panel('panel').focus();	
		}
	});
	
    $("#mydiv").datagrid('getPanel').panel('panel').attr("tabindex",0);
    $("#mydiv").datagrid('getPanel').panel('panel').focus();

	var opt=$("#mydiv").datagrid('options');
	opt.onClickRow=function(rowIndex, rowData){
		 //RemoveMyDiv();
		 //fn(rowData);
		 //return;
	}
	UnbindEvt();
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
			$("#mydiv").datagrid('getPanel').panel('panel').unbind();
			$("#mydiv").remove(); 
			$("#win").remove(); 
		}
	} 
	function UnbindEvt(){
		if($("#mydiv").length>0){
			$("#mydiv").datagrid('getPanel').panel('panel').unbind(); 
		}
	}
}

ListComponentWin.prototype.RemoveMyDiv=function(){
	if($("#mydiv").length>0){
		$("#mydiv").datagrid('getPanel').panel('panel').unbind();
	   	$("#mydiv").remove(); 
   	   	$("#win").remove(); 
	}
}
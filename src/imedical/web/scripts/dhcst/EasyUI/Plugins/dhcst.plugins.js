/**
 * creator:    yunhaibao
 * createdate: 2016-06-26
 * description:ҩ���õ�EasyUI����Ķ��η�װ
 */
$(function(){
	/// easyui-combobox
	$.fn.dhcstcomboeu=function(_options){
		if (typeof _options == 'string'){
			if (_options="getValue") {
				var tmpValue=$(this).combobox('getValue');
				if (tmpValue==undefined){
					tmpValue="";
				}
				return tmpValue;
			}
		}
		
		var options={
			valueField :'RowId',    
			textField :'Description',
			panelWidth:'200'
		}
		var strParams=_options.StrParams;
		if (strParams==undefined){
			strParams="";
		}
		var _url="DHCST.QUERY.JSON.csp?Plugin=EasyUI.ComboBox&"+
				 "ClassName="+_options.ClassName+"&QueryName="+_options.QueryName+
				 "&StrParams="+strParams;
		var opts = $.extend({},options, _options);
		opts.url=_url;
		$(this).combobox(opts);
	}
	
	/// easyui-datagrid
	$.fn.dhcstgrideu=function(_options){
		var options={
	        fit:true,
		    border:false,
		    singleSelect:true,
		    loadMsg: '���ڼ�����Ϣ...',
		    pageSize:30,  // ÿҳ��ʾ�ļ�¼����
	    	pageList:[30,50,100],   // ��������ÿҳ��¼�������б�
	    	pagination:true,
		    onRowContextMenu: function(e, rowIndex, rowData) { //�Ҽ�ʱ�����¼�
		  		if ($("#easyui-rightmenu").html()==undefined){
			  		return;
			  	}
			  	var _grid_id=$(this).attr("id");
		        e.preventDefault(); //��ֹ����������Ҽ��¼�
		        $(this).datagrid("clearSelections"); 
		        $(this).datagrid("selectRow", rowIndex); 
		        $("#easyui-rightmenu #menu-export").unbind().bind("click",function(){
			    	ExportAllToExcel(_grid_id);  
			    })
		        $('#easyui-rightmenu').menu('show', {
		            left: e.pageX,
		            top: e.pageY
		        });
	      }
		}
		var strParams=_options.StrParams;
		if (strParams==undefined){
			strParams="";
		}
		var _url="DHCST.QUERY.JSON.csp?Plugin=EasyUI.DataGrid"+
		"&ClassName="+_options.ClassName+"&QueryName="+_options.QueryName;
		var opts = $.extend({},options, _options);
		opts.url=_url;
		$(this).datagrid(opts);
	}	
	/// easyui-combogrid
	$.fn.dhcstcombogrideu=function(_options){
		var options={
		    panelWidth:500,
		    idField:'RowId',
		    textField:'Description',
		    fitColumns: true,
		    mode:"remote",
			onBeforeLoad: function(param) {
	            param.StrParams = param.q;
	        }
		}
		var strParams=_options.StrParams;
		if (strParams==undefined){
			strParams="";
		}
		var Plugin="EasyUI.ComboBox";
		if (_options.pageSize){
			Plugin="EasyUI.DataGrid";
		}
		var _url="DHCST.QUERY.JSON.csp?Plugin="+Plugin+"&"+
				 "ClassName="+_options.ClassName+"&QueryName="+_options.QueryName+
				 "&StrParams="+strParams;
		var opts = $.extend({},options, _options);
		opts.url=_url;
		$(this).combogrid(opts);
	}


});
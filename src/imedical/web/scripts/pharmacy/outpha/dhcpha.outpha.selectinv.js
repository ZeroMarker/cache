/*
 *模块:门诊药房
 *子模块:门诊药房-发票弹窗
 *createdate:2016-08-18
 *creator:yunhaibao
*/
var InvNoDivWindow = function(tarobj, input, fn){
	this.input = input;
	this.tarobj = tarobj;
	this.fn = fn;
	}
	
InvNoDivWindow.prototype.init=function(){
		var fn = this.fn;		
		var columns=[
			{index:'newInvNo',name:'newInvNo',header:'新收据',width:100},
			{index:'patName',name:'patName',header:'姓名',width:100},
		    {index:'invDate',name:'invDate',header:'日期',width:100},
		    {index:'invId',name:'invId',header:'invId',width:100,hidden:true},
		    {index:'prescNo',name:'prescNo',header:'处方号',width:100},
		    {index:'newInvId',name:'newInvId',header:'newInvId',width:100,hidden:true},
		    {index:'invNo',name:'invNo',header:'原收据',width:100}
		];
		/*jqgrid*/
		var jqOptions={
		    colModel: columns, //列
		    url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+'?action=GetInvListForReturn&params='+ this.input,
		    height:210,
		    ondblClickRow:function(rowid, iRow, iCol, e){
				RemoveMyDiv();
				var rowdata= $(this).jqGrid('getRowData', rowid);
				fn(rowdata);
			},
			loadComplete: function(){ 
				$(this).focus(); //定窗体焦点
				$(this).setSelection(1);
			}	
		};
		
		///创建弹出窗体
		var invprthtml='<div id="invprtwin" style="width:700px;height:300px;border:1px solid #40A2DE;position:absolute;z-index:9999;background-color:#ffffff;">'
						+'<table id="grid-invprt"></table>'
						+'<div style="position:absolute;bottom:10px;left:290px">'
					  	+'<button class="btn dhcpha-btn-common dhcpha-btn-danger" id="btn-close">关闭</button>'					
				  	  	+'</div>'
						+'</div>'
		RemoveMyDiv()				
		$(document.body).append(invprthtml) ;
		//$("#win").append('');	
		$("#invprtwin").show();
		$("#invprtwin").css("left",this.tarobj.offset().left);
		$("#invprtwin").css("top",this.tarobj.offset().top+ this.tarobj.outerHeight());	
		$('#grid-invprt').dhcphaJqGrid(jqOptions);
		
		$("#btn-close").on("click",function(){
			RemoveMyDiv()
		})
		$("#grid-invprt").bind('keydown', function (e){
	        switch (e.keyCode){
	        	case 13: // enter
					var id = $(this).jqGrid('getGridParam', 'selrow');
					var rowdata = $(this).jqGrid('getRowData', id);
			   		RemoveMyDiv();
			   		fn(rowdata);
			   		break ;
	        	case 27:  //Esc
			   		RemoveMyDiv();
			   		break;
			    case 38:  //pre
					var id = $(this).jqGrid('getGridParam', 'selrow');
					//var rowdata = $(this).jqGrid('getRowData', id);
			   		if (id - 1 > 0){
			   			$(this).setSelection(id-1);
			   		}
			   		break;
			   	case 40:  //next
			   		var rows=$(this).getGridParam('records');
					var id = $(this).jqGrid('getGridParam', 'selrow');
					var nextrow=parseInt(id)+1
					//var rowdata = $(this).jqGrid('getRowData', id);
			   		if (nextrow <=rows){
			   			$(this).setSelection(nextrow);
			   		}
			   		break;

			}
		})
		function RemoveMyDiv(){
			if($("#grid-invprt").length>0){
				$("#grid-invprt").remove(); 
				$("#invprtwin").remove(); 
			}
		} 
}

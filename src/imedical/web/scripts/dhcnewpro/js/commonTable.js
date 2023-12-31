
$(document).ready(function() {
	/**bootstrap table**/
    jQuery.fn.bootstrapTable.defaults.icons = {
        paginationSwitchDown: 'fa-arrow-down',
        paginationSwitchUp: 'fa-arrow-up',
        refresh: 'fa-refresh',
        toggle: 'fa-th-large',
        columns: 'fa-th-list',
        detailOpen: 'fa-add',
        detailClose: 'fa-remove'
    }
	

	//以后方便扩展
	$.fn.dhccTable=function(_options){
	   var options={
		   formatLoadingMessage:function() {
				return  "<div style='position:relative;top:100px;height:40px;overflow:hidden'><img style='background-color:#D1D1D1;' src='../scripts/dhcnewpro/images/loading.gif'>" +"<span style='background-color:#D1D1D1;line-height:40px;height:40px;text-align:center;padding:10px 4px 12px 0'>数据正在加载中...</span></div>";
		 		//return  "<div style='position:relative;top:100px;'><img style='background-color:#D1D1D1' src='../scripts/dhcnewpro/images/loading.gif'>" +"<span style='background-color:#D1D1D1;padding:10px 15px 12px 0'> 　数据正在加载中...</span></div>";
		 　}, //huaxiaoying 2017-01-07
		   silent:true,  //服务端chaxun 
		   pagination:'true',
		   iconsPrefix:'fa',
		   sidePagination: "server", //服务端处理分页
		   dataType: "json",
		   contentType:'application/json',
		   pageSize:15,
		   pageList:[15,50,100],
		   clickToSelect:true,
		   idField: 'id',
		   showRefresh:false,
		   showToggle:false,
		   showColumns:false,
		   showPaginationSwitch:false,
		   queryParams:function(params){
			    
			   	tmp={
					limit: params.limit,   //页面大小  
      				offset: params.offset,  //
      				page:params.pageNumber
			   	}
			   	tmp=$.extend({},tmp, _options.queryParam)
			   	return tmp;  
		   },rowStyle:function(row, index){
				return {classes: 'text-nowrap'}
		   }
	   };
	   
	   //alert(window.location.href)	
	   pathArr=window.location.pathname.split("/")
	   csp=pathArr[pathArr.length-1];
	   menuId=getUrlParByName("TMENU")	
	   tableId=$(this).attr("id");
	   columnArr=[];
	   $.each(_options.columns,function(n,value){
			columnArr.push(value.field+"^"+value.title+"^"+value.width+"^"+value.checkbox)
	   });
	   options.columns=_options.columns;
	   
	   var flag=1
	   if((csp=="dhcem.nur.exec.csp")||("dhcem.column.csp"==csp)){
		    opts=$.extend(true,options,_options);
			$(this).bootstrapTable(opts);
	   }else{
		    data=runClassMethod("web.DHCEMColumn","getColumnByTable",{cspName:csp,tableId:tableId,column:columnArr.join("$$"),menuId:menuId}, function(data){ },"json",false)				   
	   		_options.columns=eval(data.responseText)
	   		for(var jj=0;jj<_options.columns.length;jj++){
		   		_options.columns[jj].visible=_options.columns[jj].visible=="true"?true:false
		   	}
			opts=$.extend(true,options,_options);
			
			$(this).bootstrapTable(opts);
			//alert($("#"+tableId).find("thead").html())
			//console.log('33')
			$(this).find("thead").on('dblclick',{tableId:tableId,column:columnArr.join("$$")},function(event){
					//console.log($(this).attr("id"))
					option={
						title:'列设置',
			  			type: 2,
			  			shadeClose: true,
			  			shade: 0.8,
			  			area: ['80%','80%'],
				    	content: 'dhcem.column.csp?cspName='+csp+'&tableId='+event.data.tableId+'&column='+event.data.column+"&menuId="+menuId

					}
					layer.open(option);   
	   		})   
	   }
	   //alert(JSON.stringify(_options.columns))	


	}

	$.fn.dhccQuery=function(_options){
		$(this).bootstrapTable('refresh',_options);
		$(this).bootstrapTable('getOptions').queryParams=function(params){
			   	tmp={
					limit: params.limit,   //页面大小  
      				offset: params.offset,  //
      				page:params.pageNumber==undefined?0:params.pageNumber
			   	}
			   	
			   	if(_options){
				   	try{
					   	if(_options.hasOwnProperty('query')){
						   	tmp=$.extend(tmp,_options.query)
						}
				   	}catch(e){}
			   	}
			   	return tmp;  
		}
		$(this).bootstrapTable('refreshOptions');
	}

	$.fn.dhccTableM=function(method,par){
		
		return $(this).bootstrapTable(method,par);
	}
	/**bootstrap select2**/
	$.fn.dhccSelect=function(_options){
		
		options=
		{  
		   //multiple:true,
		   language : 'zh-CN',
		   //tags: "true",
  		   placeholder: "请选择"
  		   //allowClear: true,
  		   	

		}
		ajaxOption={
			ajax: {
			url:_options.url,   
			dataType: "json",     
		    processResults: function (data, page) {
		      return {
		        results: data
		      };
		    },
		    data: function (params) {
		      // Query paramters will be ?search=[term]&page=[page]
		      return {
		        search: params.term
		      };
		    },
		    cache:false
		  }	
		}
		var opts = $.extend({},options, _options);
		opts=((_options.url==undefined)?opts:$.extend({},opts, ajaxOption))
		$(this).select2(opts);
	}
	$.fn.dhccSelectM=function(m){
		return $(this).select2(m)
	};
	
	/**datepicker**/ //hxy 2017-03-29 测试！！！
	/*$.fn.datepicker.dates['zh-CN'] = {
	    days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"],
	    daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
	    daysMin: ["日", "一", "二", "三", "四", "五", "六"],
	    months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
	    monthsShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
	    today: "今天",
	    clear: "清除",
	    format: "dd-mm-yyyy", //"dd-mm-yyyy"  yyyy-mm-dd
	    titleFormat: "MM yyyy", //* Leverages same syntax as 'format' //
	    weekStart: 0
	};
	
	$.fn.dhccDate=function(_options){
		options={
			autoclose:true,
			language: 'zh-CN',
			//clearBtn:true,
			//todayBtn:true
			todayHighlight:true,
			todayBtn:'linked'
		}
		var opts = $.extend({},options, _options);
		return $(this).datepicker(opts);
	}
	$.fn.extend({ 
		getDate: function () { 
			return $(this).datepicker('getDate').Format('yyyy-MM-dd')  //yyyy-MM-dd  dd/MM/yyyy
		},
		setDate:function(date){
			$(this).datepicker('setDate', date);
		},
		setCurDate:function(){
            return $(this).datepicker('setDate', new Date().Format("yyyy-MM-dd"));
			//$(this).datepicker('setDate', new Date().Format("yyyy-MM-dd"));
		} 
	});  //hxy 2017-03-29 测试！！！ end
	
	/**datepicker**/ //hxy 2017-03-06
	/*$.fn.datepicker.dates['zh-CN'] = {
	    days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"],
	    daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
	    daysMin: ["日", "一", "二", "三", "四", "五", "六"],
	    months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
	    monthsShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
	    today: "今天",
	    clear: "清除",
	    format: "dd/mm/yyyy", //"dd-mm-yyyy"  yyyy-mm-dd
	    titleFormat: "MM yyyy", //* Leverages same syntax as 'format' //
	    weekStart: 0
	};
	
	$.fn.dhccDate=function(_options){
		options={
			autoclose:true,
			language: 'zh-CN',
			//clearBtn:true,
			//todayBtn:true
			todayHighlight:true,
			todayBtn:'linked'
		}
		var opts = $.extend({},options, _options);
		return $(this).datepicker(opts);
	}
	$.fn.extend({ 
		getDate: function () { 
			return $(this).datepicker('getDate').Format('dd/MM/yyyy')  //yyyy-MM-dd
		},
		setDate:function(date){
			$(this).datepicker('setDate', date);
		} 
	}); 
	
	
	/*daterangepicker*/
	  
    /*$.fn.dhccDateRange=function(_options,cb){  //hxy 2017-03-08
	    options={}
		options.locale = {
	      format: 'DD/MM/YYYY', //YYYY-MM-DD DD/MM/YYYY
	      separator: ' / ',
	      applyLabel: '确认',
	      cancelLabel: '取消',
	      fromLabel: '从',
	      toLabel: '到',
	      customRangeLabel: 'Custom',
	      daysOfWeek: ['日', '一', '二', '三', '四', '五','六'],
	      monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
	      firstDay: 1
      	};
		var opts = $.extend({},options, _options);
		return $(this).daterangepicker(opts,cb);
	}*/
	
    $.fn.editableform = $.fn.editableform||{};
    $.fn.editableform.buttons =
        '<button type="submit" class="btn btn-primary editable-submit">'+
            '<i class="fa fa-fw fa-check"></i>'+
        '</button>'+
        '<button type="button" class="btn btn-default editable-cancel">'+
            '<i class="fa fa-fw fa-times"></i>'+
        '</button>';
    });

bootbox.setDefaults("locale","zh_CN");
bootbox.setDefaults("title","提示");
var msgOptions={
				type: 'success',
			    icon : 'fa fa-exclamation',
			    message : '提示!',
			    container : 'floating',
			    timer : 5000,
			    layout:'bottomRight'}
var dhccBox=(		
{   
    alert:function(mymessage,myclassName){
	   bootbox.dialog({
	      message: mymessage,     // dialog的内容
	      className: myclassName,  // dialog的类名 
	      buttons: {                 // dialog底端按钮配置
	        success: {               // 其中一个按钮配置  
	          label: "确认",         // 按钮显示的名称
	          className: "btn-primary" //callback: function() {}
	        }
	      }
	   });
	   //dhccmodalstyle("title标题","className请唯一并与上方className保持一致");
	   //dhccmodalstyle("提示",myclassName);
	   dhccalertstyle("提示",myclassName);
	},//hxy 2016-09-29
	confirm:function(mytitle,mymessage,myclassName,mycallback){
		bootbox.dialog({
		   message: mymessage,     // dialog的内容
		   className: myclassName,  // dialog的类名 
		   buttons: {                 // dialog底端按钮配置
		     success: {               // 其中一个按钮配置  
		       label: "确认",         // 按钮显示的名称
		       className: "btn-primary",
		       callback: mycallback
		     },
		     "取消": {                // 另一个按钮配置
		       className: "btn-primary",
		       callback: function() {}
		     }
		   }
		});
		//dhccmodalstyle("title标题","className请唯一并与上方className保持一致");
		dhccmodalstyle(mytitle,myclassName);
	}, //hxy 2016-09-29	
	cusconfirm:function(mytitle,mymessage,myclassName,labelone,labeltwo,mycallback,callbacktwo){
		bootbox.dialog({
		   message: mymessage,     // dialog的内容
		   className: myclassName,  // dialog的类名 
		   buttons: {                 // dialog底端按钮配置
		     success: {               // 其中一个按钮配置  
		       label: labelone,         // 按钮显示的名称
		       className: "btn-primary",
		       callback: mycallback
		     },
		    labeltwo: { 
		       label: labeltwo,                    // 另一个按钮配置
		       className: "btn-primary",
		       callback: callbacktwo
		     }
		   }
		});
		//dhccmodalstyle("title标题","className请唯一并与上方className保持一致");
		dhccmodalstyle(mytitle,myclassName);
	},//hxy	2016-09-29	
	//alert:function(message,callback){
	//	bootbox.alert(message,callback);
	//},
	//confirm:function(message,callback){
	//	bootbox.confirm(message,callback);
	//},//hxy	
	prompt:function(message,callback){
		bootbox.prompt(message,callback);
	},
	dialog:function(_options){
		var opts = $.extend({},boxOptions, _options);
		bootbox.dialog(opts)
	},
	message:function(_options){
		
		var opts = $.extend({},msgOptions, _options);
		//opts.container='container'
		$.niftyNoty(opts);
		//layer.msg(_options.message, {
		//  offset: 0,
		//  shift: 6
		//});
	}
});


//修改alert样式 hxy 
function dhccalertstyle(title,className){
	var mytitle=""
	mytitle='.'+className+' '+'.modal-title'
	$(mytitle).html('<i style="margin-right:6px;" class="fa fa-chevron-circle-down"></i>'+title )
		$(mytitle).addClass("dhccdialogtitle")
		myhead='.'+className+' '+'.modal-header'
		$(myhead).addClass("dhccdialogheader")
		mycontent='.'+className+' '+'.modal-content'
		$(mycontent).addClass("dhccdialog")
		myclose='.'+className+' '+'.close'
		$(myclose).addClass("dhccdialogclose")
		footerone='.'+className+' '+'.modal-footer button'	//2017-02-15
		$(footerone).addClass("dhccdialogfooterbutton")//2017-02-15

}

//修改confirm样式 hxy
function dhccmodalstyle(title,className){
	var mytitle=""
	mytitle='.'+className+' '+'.modal-title'
	$(mytitle).html('<i style="margin-right:6px;" class="fa fa-chevron-circle-down"></i>'+title )
	//myheaderbutton='.'+className+' '+'.modal-header'+' '+'.close'
	//$(myheaderbutton).html('<button type="button" style="color:#fff;font-siza:16px;" class="close dhccdialogclose" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>' )
		$(mytitle).addClass("dhccdialogtitle")
		myhead='.'+className+' '+'.modal-header'
		$(myhead).addClass("dhccdialogheader")
		mycontent='.'+className+' '+'.modal-content'
		$(mycontent).addClass("dhccdialog")
		myclose='.'+className+' '+'.close'
		$(myclose).addClass("dhccdialogclose")
		footerone='.'+className+' '+'.modal-footer button:nth-child(1)'
		footertwo='.'+className+' '+'.modal-footer button:nth-child(2)'
		$(footerone).addClass("dhccdialogfooterbuttonone")
		$(footertwo).addClass("dhccdialogfooterbuttontwo")
		//$(".modal-footer button:nth-child(1)").addClass("dhccdialogfooterbuttonone")
		//$(".modal-footer button:nth-child(2)").addClass("dhccdialogfooterbuttontwo")
		
}

///下拉框的清空 2016-09-27 hxy
function dhccOptionClear(id){
	id=id.substr(5,id.length);
	$('#'+ id).val("");	
	$("#"+ id).attr("title","");
	$("#"+ id).empty();
}
function getUrlParByName(name){
	
	ret=""
	urlParArr=window.location.href.split("?")
	if(urlParArr.length>1){
		parArr=urlParArr[1].split("&")
		for(var i=0;i<parArr.length;i++){
		   strArr=parArr[i].split("=")
		   if(strArr[0]==name){
			   ret=strArr[1]
			}
		}
	}
	
	return ret;	 
}
